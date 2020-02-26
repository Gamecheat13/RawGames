#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;

#using_animtree( "vehicles" );

init()
{
	vehicle_add_main_callback( "drone_claw", ::main );
	vehicle_add_main_callback( "drone_claw_wflamethrower", ::main );
	vehicle_add_main_callback( "drone_claw_rts", ::main );
	vehicle_add_main_callback( "drone_claw_suicide", ::main );
	
	PrecacheString( &"hud_weapon_heat" );
}

main()
{
	self ent_flag_init( "playing_scripted_anim" );	// created this flag because _animActive doesn't seem to be reduced normally

	self build_claw_anims();
	
	self thread watch_mounting();
	self thread claw_animating();
	self thread claw_death();
}

build_claw_anims()
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
	
	if( IsDefined( level.claw_anims_inited ) )
	{
		return;
	}

	level.claw_anims_inited = true;
	
	//%int_claw_stun_fall_b
	
	level.claw_speeds = [];
	level.claw_speeds[level.REVERSE-1] = -50000;
	level.claw_speeds[level.REVERSE] = -100;
	level.claw_speeds[level.IDLE] = 0;
	level.claw_speeds[level.WALK] = 100;
	//level.claw_speeds[level.RUN] = 42;
	//level.claw_speeds[level.SPRINT] = 50;
	// temp until the run and sprint anims are replaced
	level.claw_speeds[level.RUN] = 4000;
	level.claw_speeds[level.SPRINT] = 5000;
	level.claw_speeds[level.SPRINT+1] = 50000;
	
	level.claw_anims = [];
	level.claw_anims[level.REVERSE] = %int_claw_walk_b;
	level.claw_anims[level.IDLE] = %int_claw_idle;
	level.claw_anims[level.WALK] = %int_claw_walk_f;
	level.claw_anims[level.RUN] = %int_claw_walk_f;
	level.claw_anims[level.SPRINT] = %int_claw_walk_f;
	
	level.claw_anims[level.JUMP] = [];
	level.claw_anims[level.JUMP][0] = %int_claw_idle;
	level.claw_anims[level.JUMP][1] = %int_claw_idle;
	level.claw_anims[level.JUMP][2] = %int_claw_idle;
}

precache_fx()
{
	
}

claw_animating() 
{
	self endon("death");

	wait .5;
	
	self.idle_end_time = 0;

	while( true )
	{
		speed = self GetSpeed();
		angular_velocity = self GetAngularVelocity();
		turning_speed = abs( angular_velocity[2] );
		
		//iprintlnbold( "Speed: " + speed + " Avel: " + angular_velocity[2] );

		if ( self ent_flag( "playing_scripted_anim" ) )
		{
		}
		else if( self.in_air )	// jump or fall, jump thread will take care of animating this
		{
		}
		else if( speed < 55 && speed > -20 && turning_speed > 0.2 )	// turning idle
		{
			anim_rate = turning_speed;
			anim_rate = clamp( anim_rate, 0.0, 3 );
			//anim_rate = 1;
			if( angular_velocity[2] > 0 )
			{
				self SetAnimKnobAll( %int_claw_turn_l, %root, 1, 0.2, anim_rate );
			}
			else
			{
				self SetAnimKnobAll( %int_claw_turn_r, %root, 1, 0.2, anim_rate );
			}
			self.current_anim_speed = level.IDLE;
			self.idle_end_time = 0;
		}
		else if( speed < -8.0 )	// reverse
		{
			self.current_anim_speed = level.REVERSE;
		
			anim_rate = speed / level.claw_speeds[self.current_anim_speed];
			anim_rate = clamp( anim_rate, 0.0, 1.5 );
			
			self SetAnimKnobAll( level.claw_anims[level.REVERSE], %root, 1, 0.2, anim_rate );
		}
		else if( speed < 5 )	// Idle
		{	
			self SetAnimKnobAll( level.claw_anims[self.current_anim_speed], %root, 1, 0.2, 0 );
		}
		else	// Running
		{
			next_anim_delta = level.claw_speeds[self.current_anim_speed + 1] - level.claw_speeds[self.current_anim_speed];
			next_anim_speed = level.claw_speeds[self.current_anim_speed] + next_anim_delta * 0.6;
			
			prev_anim_delta = level.claw_speeds[self.current_anim_speed] - level.claw_speeds[self.current_anim_speed - 1];
			prev_anim_speed = level.claw_speeds[self.current_anim_speed] - prev_anim_delta * 0.6;

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
			
			anim_rate = speed / level.claw_speeds[self.current_anim_speed];
			anim_rate = clamp( anim_rate, 0.0, 1.5 );

			self SetAnimKnobAll( level.claw_anims[self.current_anim_speed], %root, 1, 0.2, anim_rate );
		}
		
		wait(0.05);
	}
}

check_for_landing()
{
	self waittill( "veh_landed" );
	self.already_landed = true;
}

watch_for_fall()
{
	while( true )
	{
		self waittill( "veh_inair" );
		if( !self.in_air )
		{
			self.in_air = true;
			self SetAnimKnobAll( level.claw_anims[level.JUMP][1], %root, 1, 0.1, 1 );
			self waittill_notify_or_timeout( "veh_landed", 1 );
			
			self.in_air = false;
		}
		else
		{
			self waittill( "veh_landed" );
		}
	}
}

watch_exit_vehicle()
{
	self waittill( "exit_vehicle" );
	self.ignoreme = false;
	self DisableInvulnerability();
}

watch_mounting()
{
	self endon("death");

	while(true)
	{
		self waittill( "enter_vehicle", player );
		
		self.driver = player;
		
		self thread watch_for_fall();
		
		vision_set_name = ( level.script == "pakistan_2" ? "sp_pakistan2_claw" : "firestorm_turret" );
		self thread maps\_vehicle_death::vehicle_damage_filter( vision_set_name );
		
		self HidePart( "tag_turret", "veh_t6_drone_claw_mk2_turret" );
		player.ignoreme = true;
		player EnableInvulnerability();
		self SetViewModelRenderFlag( true );
		
		//self thread watch_for_sprint();
		//self thread wind_driving();
		
		player thread claw_update_hud();
		
		player thread watch_exit_vehicle();
		self waittill( "exit_vehicle" );
		
		self ShowPart( "tag_turret", "veh_t6_drone_claw_mk2_turret" );
		self notify("no_driver");
		self SetViewModelRenderFlag( false );
		
		self.driver = undefined;
	}
}

claw_update_hud()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	heat_1 = 0;
	heat_2 = 0;
	overheat_1 = 0;
	overheat_2 = 0;

	while( true )
	{
		if ( IsDefined( self.viewlockedentity ) )
		{
			old_heat_1 = heat_1;
			heat_1 = self.viewlockedentity GetTurretHeatValue( 0 );

			old_heat_2 = heat_2;
			heat_2 = self.viewlockedentity GetTurretHeatValue( 1 );

			old_overheat_1 = overheat_1;
			overheat_1 = self.viewlockedentity IsVehicleTurretOverheating( 0 );

			old_overheat_2 = overheat_2;
			overheat_2 = self.viewlockedentity IsVehicleTurretOverheating( 1 );

			if( old_heat_1 != heat_1 || old_heat_2 != heat_2 || old_overheat_1 != overheat_1 || old_overheat_2 != overheat_2 )
			{
				LUINotifyEvent( &"hud_weapon_heat", 4, Int( heat_1 ), Int( heat_2 ), overheat_1, overheat_2 );
			}
		}
		
		wait( 0.05 );
	}
}

claw_death()
{
	self waittill( "death" );

	// removed entity is undefined
	//self SetAnimKnobAll( %ai_claw_mk2_stun_fall_l, %root, 1, 0.1, 1 );	
}
