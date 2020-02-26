#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;

#using_animtree( "vehicles" );

main()
{
	self ent_flag_init( "playing_scripted_anim" );	// created this flag because _animActive doesn't seem to be reduced normally

	self build_spiderbot_anims();
	
	self thread watch_mounting();
	self thread spiderbot_animating();
}

build_spiderbot_anims()
{
	level.REVERSE = 1;
	level.IDLE = 2;
	level.WALK = 3;
	level.RUN = 4;
	level.SPRINT = 5;
	level.JUMP = 6;
	
	self.in_air = false;
	self.idle_state = 0;
	self.idle_anim_finished_state = 0; // the state the horse will be in once the current idle animation is done
	self.current_anim_speed = level.IDLE;
	
// NOTE: There is currently a bug that causes this to never clear
	self._animActive = 0;	// variable used by anim system to indicate is something is playing a scripted anim
	
	if( IsDefined( level.spiderbot_anims_inited ) )
	{
		return;
	}

	level.spiderbot_anims_inited = true;
	
	level.spiderbot_speeds = [];
	level.spiderbot_speeds[level.REVERSE-1] = -5000;
	level.spiderbot_speeds[level.REVERSE] = -23;
	level.spiderbot_speeds[level.IDLE] = 0;
	level.spiderbot_speeds[level.WALK] = 18;
	//level.spiderbot_speeds[level.RUN] = 42;
	//level.spiderbot_speeds[level.SPRINT] = 50;
	// temp until the run and sprint anims are replaced
	level.spiderbot_speeds[level.RUN] = 400;
	level.spiderbot_speeds[level.SPRINT] = 500;
	level.spiderbot_speeds[level.SPRINT+1] = 5000;
	
	level.spiderbot_anims = [];
	level.spiderbot_anims[level.REVERSE] = %ai_spider_walk_b;
	level.spiderbot_anims[level.IDLE] = %ai_spider_idle;
	level.spiderbot_anims[level.WALK] = %ai_spider_walk_f;
	level.spiderbot_anims[level.RUN] = %ai_spider_run_f;
	level.spiderbot_anims[level.SPRINT] = %ai_spider_sprint_f;
	
	//level.spiderbot_anims[level.REVERSE] = %ai_spider_walk_b;
	//level.spiderbot_anims[level.IDLE] = %ai_spider_idle;
	//level.spiderbot_anims[level.WALK] = %ai_spider_walk_f;
	//level.spiderbot_anims[level.RUN] = %ai_spider_run_f;
	//level.spiderbot_anims[level.SPRINT] = %ai_spider_sprint_f;
	
	level.spiderbot_anims[level.JUMP] = [];
	level.spiderbot_anims[level.JUMP][0] = %ai_spider_idle;
	level.spiderbot_anims[level.JUMP][1] = %ai_spider_idle;
	level.spiderbot_anims[level.JUMP][2] = %ai_spider_idle;
}

precache_fx()
{
	
}

update_idle_anim()
{
}

spiderbot_animating() 
{
	self endon("death");

	wait .5;
	
	self.idle_end_time = 0;

	while( true )
	{
		speed = self GetSpeed();
		angular_velocity = self GetAngularVelocity();
		turning_speed = abs( angular_velocity[2] );
		
		velocity = self.velocity;
		
		right = AnglesToRight( self.angles );
		side_vel = VectorDot( right, velocity );
		
		//iprintlnbold( "Speed: " + speed + " Avel: " + angular_velocity[2] );

//		if ( self._animActive )	// Playing a scripted animation
		// this is a temp change since I can't rely on _animActive at the moment
		//	due to a bug.
		if ( self ent_flag( "playing_scripted_anim" ) )	
		{
		}
		else if( self.in_air )	// jump or fall, jump thread will take care of animating this
		{
		}
		else if( abs(side_vel) > 0.4 && abs(side_vel) > abs(speed) )
		{
			anim_rate = abs(side_vel) / 15;
			anim_rate = clamp( anim_rate, 0.0, 1.5 );
			
			if( side_vel < speed )
			{
				self SetAnimKnobAll( %ai_spider_strafe_l, %root, 1, 0.2, anim_rate );
			}
			else
			{
				self SetAnimKnobAll( %ai_spider_strafe_r, %root, 1, 0.2, anim_rate );
			}
			self.current_anim_speed = level.WALK;
		}
		else if( speed < -0.4 )	// reverse
		{
			self.current_anim_speed = level.REVERSE;
		
			anim_rate = speed / level.spiderbot_speeds[self.current_anim_speed];
			anim_rate = clamp( anim_rate, 0.0, 1.5 );
			
			self SetAnimKnobAll( level.spiderbot_anims[level.REVERSE], %root, 1, 0.2, anim_rate );
		}
		else if( speed < 1 && turning_speed > 0.2 )	// turning idle
		{
			anim_rate = turning_speed / 3;
			//anim_rate = 1;
			if( angular_velocity[2] > 0 )
			{
				self SetAnimKnobAll( %ai_spider_idle_turn_l, %root, 1, 0.2, anim_rate );
			}
			else
			{
				self SetAnimKnobAll( %ai_spider_idle_turn_r, %root, 1, 0.2, anim_rate );
			}
			self.current_anim_speed = level.IDLE;
			self.idle_end_time = 0;
		}
		else if( speed < 0.5 )	// Idle
		{	
			self SetAnimKnobAll( level.spiderbot_anims[self.current_anim_speed], %root, 1, 0.2, 0 );
		}
		else	// Running
		{
			next_anim_delta = level.spiderbot_speeds[self.current_anim_speed + 1] - level.spiderbot_speeds[self.current_anim_speed];
			next_anim_speed = level.spiderbot_speeds[self.current_anim_speed] + next_anim_delta * 0.6;
			
			prev_anim_delta = level.spiderbot_speeds[self.current_anim_speed] - level.spiderbot_speeds[self.current_anim_speed - 1];
			prev_anim_speed = level.spiderbot_speeds[self.current_anim_speed] - prev_anim_delta * 0.6;

			if( speed > next_anim_speed )
			{
				self.current_anim_speed++;
			}
			else if( speed < prev_anim_speed )
			{
				self.current_anim_speed--;
			}
		
			if( self.current_anim_speed	<= level.IDLE )
			{
				self.current_anim_speed = level.WALK;
			}
			
			anim_rate = speed / level.spiderbot_speeds[self.current_anim_speed];
			anim_rate = clamp( anim_rate, 0.0, 1.5 );

			self SetAnimKnobAll( level.spiderbot_anims[self.current_anim_speed], %root, 1, 0.2, anim_rate );
		}
		
		wait(0.05);
	}
}

check_for_landing()
{
	self waittill( "veh_landed" );
	self.already_landed = true;
}

watch_for_jump() // self == horse
{
	self endon("death");
	self endon("no_driver");

	while( true )
	{
		if ( self.driver JumpButtonPressed() && !self.in_air && !self ent_flag( "playing_scripted_anim" ) )
		{
			self.in_air = true;

			// Calculate a relative jump vector (initial velocity is taken into consideration)
			
			// This is the relative direction of the controller
			// We'll also add in a vertical jump component in the Z axi
			// 	Need to flip the y component to match world vectors
			// 	The Z component is reduced a bit to allow for a more lateral jump
			v_movement = VectorNormalize( level.player GetNormalizedMovement() + (0,0,1) );

			// This is the orientation vectors of the spider
			v_forward = AnglesToForward( self.angles );
			v_right = AnglesToRight( self.angles );
			v_up = AnglesToUp( self.angles );

			// Reduce the velocity if the spider is not relatively level
			// Orientation vector is generally pointing in an upward direction if the Z component is fairly positive
			//	(0.7071 ~ sin(45degrees) )
			if ( v_up[2] < 0.7071 ) 
			{
				v_force = v_up * 165;	// 165 will completely push you off the wall
			}
			else
			{
				// We're relatively facing upwards
				// So now we will add in a vector to the up vector that will reflect our current direction of travel
				v_forward = v_forward * v_movement[0];
				v_right   = v_right * v_movement[1];
				v_up 	  = v_up * v_movement[2];
				v_orientation = VectorNormalize( v_forward + v_right + v_up );
				
				v_force = v_orientation * 165;
			}

//iPrintlnBold( "angles : " + self.angles );
//iPrintlnBold( "vector up : " + v_orientation );
//iPrintlnBold( "force : " + v_force );

			self.driver SetClientDvar("phys_vehicleGravityMultiplier", 0.5 );
			self LaunchVehicle(v_force, (0,0,0), 0);
			self playsound( "veh_spiderbot_jump" );

			self.already_landed = false;

			anim_rate = 1;
			self SetAnimKnobAll( level.spiderbot_anims[level.JUMP][0], %root, 1, 0.1, anim_rate );
			
			self waittill_notify_or_timeout( "veh_landed", 2 );

			self.driver SetClientDvar("phys_vehicleGravityMultiplier", 1.0 );

			// Don't let them hold down the button to keep jumping
			n_restart_time = GetTime() + 0.2;
			// some small delay for landing shock absorbtion
			while ( GetTime() < n_restart_time && self.driver JumpButtonPressed() )
			{
				wait( 0.05 );
			}
			self.in_air = false;
		}

		// Don't let them hold down the button to keep jumping
		while ( self.driver JumpButtonPressed() )
		{
			wait( 0.05 );
		}

		wait(0.05);
	}
}

watch_for_fall()
{
	while( true )
	{
		self waittill( "veh_inair" );
		if( !self.in_air )
		{
			self.in_air = true;
			self SetAnimKnobAll( level.spiderbot_anims[level.JUMP][1], %root, 1, 0.1, 1 );
			self waittill_notify_or_timeout( "veh_landed", 1 );
			
			self.in_air = false;
		}
		else
		{
			self waittill( "veh_landed" );
		}
	}
}

watch_mounting()
{
	self endon("death");

	n_gravity = GetDvarFloat("bg_gravity");

	while(true)
	{
		self waittill( "enter_vehicle", player );
		
		self.driver = player;
		
		self thread watch_for_jump();
		self thread watch_for_fall();
		maps\_vehicle::lights_on();
		
		self waittill( "exit_vehicle" );
		self notify("no_driver");
		maps\_vehicle::lights_off();
		self.driver = undefined;
	}
}