#include maps\_vehicle;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include soundscripts\_snd;

#using_animtree( "vehicles" );

main( model, type, classname )
{
	PreCacheModel( model );
	
	set_console_status();
	
	//Flying fx
	level._effect[ "drone_fan_distortion" ]	= loadfx( "vfx/distortion/drone_fan_distortion" );
	level._effect[ "drone_fan_distortion_large" ]	= loadfx( "vfx/distortion/drone_fan_distortion_large" );
	level._effect[ "drone_thruster_distortion" ]	= loadfx( "vfx/distortion/drone_thruster_distortion" );
	level._effect[ "pdrone_death_explosion" ] = loadfx( "vfx/explosion/vehicle_pdrone_explosion" );
	level._effect[ "pdrone_large_death_explosion" ] = loadfx( "vfx/explosion/vehicle_pdrone_large_explosion" );
	level._effect[ "pdrone_emp_death" ] = loadfx( "vfx/explosion/vehicle_pdrone_explosion" );
	level._effect[ "drone_beacon_red" ] = LoadFX( "vfx/lights/light_drone_beacon_red" );
	level._effect[ "emp_drone_damage" ] = LoadFX( "vfx/sparks/emp_drone_damage" );
	
	//personal drone deploys
	level.scr_animtree["personal_drone"] = #animtree;
	level.scr_model["personal_drone"] = model;
	level.scr_anim[ "personal_drone" ][ "drone_deploy_crouch_to_crouch" ] = %drone_deploy_crouch_to_crouch;
	level.scr_anim[ "personal_drone" ][ "drone_deploy_crouch_to_run" ] = %drone_deploy_crouch_to_run;
	level.scr_anim[ "personal_drone" ][ "drone_deploy_run_to_run" ] = %drone_deploy_run_to_run;
	level.scr_anim[ "personal_drone" ][ "drone_deploy_run_to_stand" ] = %drone_deploy_run_to_stand;
	level.scr_anim[ "personal_drone" ][ "personal_drone_folded_idle" ][0] = %personal_drone_folded_idle;
	
	setup_ai_anims();
	
	build_template( "pdrone", model, type, classname );
	build_localinit( ::init_local );

	
	
	// no tag_engine yet
	//build_deathfx( "explosions/bouncing_betty_explosion", 	"tag_engine", 	undefined, 	undefined, 			undefined, 		undefined, 		0.0, 		true );

	build_deathquake( 0.4, 0.8, 1024 );
	
	build_life( 499 );
	
	build_team( "allies" );
	build_mainturret();
	
	randomStartDelay = randomfloatrange( 0, 1 );
	lightmodel = classname;
	
	build_is_helicopter();
}

#using_animtree( "generic_human" );
setup_ai_anims()
{
	//drone deploys
	level.scr_anim[ "generic" ][ "drone_deploy_crouch_to_crouch" ] = %drone_deploy_crouch_to_crouch_guy;
	level.scr_anim[ "generic" ][ "drone_deploy_crouch_to_run" ] = %drone_deploy_crouch_to_run_guy;
	level.scr_anim[ "generic" ][ "drone_deploy_run_to_run" ] = %drone_deploy_run_to_run_guy;
	level.scr_anim[ "generic" ][ "drone_deploy_run_to_stand" ] = %drone_deploy_run_to_stand_guy;
}

init_local()
{
	self endon( "death" );
	self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );// TODO - FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.script_badplace = false;// All helicopters dont need to create bad places
	self.dontDisconnectPaths = true; //so it can land. pathing through heli's generally not a problem
	
	if( self.script_team == "allies" )
	{
		thread maps\_vehicle::vehicle_lights_on( "friendly" );
		self.contents = self SetContents( 0 ); //turn off collision so friendly pdrones don't lift up npcs
	}
	else
	{
		thread maps\_vehicle::vehicle_lights_on( "hostile" );
		
		// no death set up for enemy drone yet.  take this out when death works properly
		self.ignore_death_fx = true;
		self.delete_on_death = true;
		self thread pdrone_handle_death();
		/#
			self thread destroy_drones_when_nuked();
		#/
		//self.free_on_death = true;
	}
	self ent_flag_init( "sentient_controlled" );
	self ent_flag_init( "fire_disabled" );
	
	waittillframeend; // wait for turrets to get setup
	
	self.emp_death_function = ::pdrone_emp_death;
	self add_damage_function( ::pdrone_damage_function );
	
	b_expendable = false;
	
	if( isDefined( self.script_parameters ) && self.script_parameters == "expendable" )
	{
		b_expendable = true;
	}
	
	self thread pdrone_ai( b_expendable );
	
	self thread pdrone_flying_fx();
	
	self notify( "stop_kicking_up_dust" );
	
	self thread handle_pdrone_audio();
}

// Instances/deinstances pdrone sound vehicle based on distance to player.
// Called on vehicle entity.
handle_pdrone_audio()
{
	self endon( "death" );
	
	update_rate  = 0.25;
	if (level.currentgen)
		update_rate = 1.0;

	// Set defaults to small drones (pdrone, atlas small), and override later large drones.
	audio_on			= false;
	cull_dist			= 36 * 16;
	fadeout_time		= 1.0;
	stop_delay			= 0;	
	args				= SpawnStruct();
	args.preset_name	= "pdrone";
	
	if (!IsSubStr(self.classname, "pdrone_atlas_large"))
	{
		snd_message("snd_register_vehicle", "pdrone",				vehicle_scripts\_pdrone_aud::snd_pdrone_constructor);
	}
	else
	{
		snd_message("snd_register_vehicle", "pdrone_atlas_large",	vehicle_scripts\_pdrone_aud::snd_adrone_constructor);
		args.preset_name = "pdrone_atlas_large";
		cull_dist	= 36 * 32;
	}
		
	while ( 1 )
	{
		dist = Distance(self.origin, level.player.origin);
		
		if (!audio_on && dist < cull_dist)
		{
			self snd_message("snd_start_vehicle", args);
			audio_on = true;
		}
		else if (audio_on && dist > cull_dist)
		{
			self snd_message("snd_stop_vehicle", fadeout_time, stop_delay);
			audio_on = false;
		}
		
		wait update_rate;
	}
}

pdrone_ai( b_expendable )
{
	self endon( "death" );
	
	self MakeEntitySentient( self.script_team, b_expendable );
	if( self.script_team != "allies" )	//only do aim assist against enemy drones
		self EnableAimAssist();
	self SetMaxPitchRoll( 60, 60 );	//bank a lot
	// run pdrone ai
	if ( IsDefined( self.owner ) )
	{
		self thread pdrone_movement();
	}
	
	self thread pdrone_targeting();
}

pdrone_flying_fx()
{
	self endon( "death" );
	
	//start pdrone flying fx
	beaconDelay = 0.3;
	
	if( self.classname == "script_vehicle_pdrone_atlas" )
	{
		playfxontag( getfx( "drone_fan_distortion" ), self, "TAG_FX_FAN_L");
		waitframe();
		playfxontag( getfx( "drone_fan_distortion" ), self, "TAG_FX_FAN_R");
	}
	
	if( self.classname == "script_vehicle_pdrone_atlas_large")
	{
		playfxontag( getfx( "drone_fan_distortion_large" ), self, "TAG_FX_FAN_L");
		waitframe();
		playfxontag( getfx( "drone_fan_distortion_large" ), self, "TAG_FX_FAN_R");
	}
		
	if( self.classname != "script_vehicle_pdrone_atlas" )
	{
		playfxontag( getfx( "drone_thruster_distortion" ), self, "TAG_FX_THRUSTER_L");
		waitframe();
		playfxontag( getfx( "drone_thruster_distortion" ), self, "TAG_FX_THRUSTER_R");
	}
	
	if( self.script_team == "axis" )
	{
		PlayFXOnTag( getfx( "drone_beacon_red" ), self, "TAG_FX_BEACON_0" );
		wait beaconDelay;
		PlayFXOnTag( getfx( "drone_beacon_red" ), self, "TAG_FX_BEACON_1" );
		wait beaconDelay;
		PlayFXOnTag( getfx( "drone_beacon_red" ), self, "TAG_FX_BEACON_2" );
	}
}

/*
give_pdrone_npc()
{
	pdrone_npc_rate = GetDvarFloat( "pdrone_npc_rate", 0.0 );
	
	if(RandomFloat( 1 ) >= pdrone_npc_rate)
	{
		return;
	}
	
	owner = self;
	
	pdrone = self get_pdrone();
	
	pdrone MakeEntitySentient( owner.team );
	
	//npc got killed before they got a drone
	if( !IsDefined( pdrone ) )
	{
		return;
	}
	//pdrone = spawn( "script_vehicle_pdrone", player.origin + (0, 0, 120) );
	//pdrone.angles = player.angles;
	pdrone.owner = owner;
	
	pdrone.script_team = owner.team;
	
	pdrone EnableAimAssist();
	
	//pdrone godon();
	
	pdrone notify( "stop_kicking_up_dust" );
	
	pdrone thread pdrone_movement();
	pdrone thread pdrone_targeting();
	pdrone thread pdrone_flying_fx();
	
	owner.pdrone = pdrone;
	owner notify( "pdrone_launched" );
	
	self waittill( "death" );
	
	pdrone delete();
}
*/

pdrone_movement()
{
	self.owner endon( "pdrone_returning" );
	self.owner endon( "death" );
	self endon( "death" );
	
	if( self.script_team == "allies" )
	{
		self SetHoverParams( 20, 20, 20 );
		self.goalradius = 64;
	}
	else
	{
		self SetHoverParams( 0, 0, 0.05 );
		self.goalradius = 8;
	}
	
	self vehicle_setspeed( 20, 20, 20 );
	self SetYawSpeedByName( "faster" );
	
	self thread pdrone_movement_follow();
	
	while( 1 )
	{
		self.owner waittill( "pdrone_defend_point", trace );
		
		self thread pdrone_movement_go_to_point( trace );
	}
}

pdrone_movement_follow()
{
	self notify( "change_movement_type" );
	self endon( "change_movement_type" );
	self.owner endon( "pdrone_returning" );
	self.owner endon( "death" );
	self endon( "death" );
	
	min_trace_period = .2;		
	
	if( IsPlayer( self.owner ) )
	{
		random_range = (1, 5, 3);
		local_offset = (-50, 130, 90);
	}
	else
	{
		random_range = (1, 64, 10);
		local_offset = (-60, 0, 95);
	}
	
	// to stagger our raycasts
	wait RandomFloat(min_trace_period);

	cur_yaw = 0;
	goal_pos = self.origin;
	last_valid_pos = self.origin;
	global_point = self.origin;
	hover_noise_timer = 0;
	hover_offset = (0, 0, 0);
	trace_timer = 0;
	trace_fail_time = 0;	
	last_debug_pos = self.origin;		
	update_rate = 0.05;
	if (level.currentgen)
		update_rate = 0.25;
	
	while( 1 )
	{
		trace_timer += update_rate;
		hover_noise_timer += update_rate;
	
		if(hover_noise_timer > 2)
		{
			// todo: perlin noise?
			hover_noise_timer = 0;
			hover_offset = (RandomFloatRange(-.5, .5) * random_range[0], RandomFloatRange(-.5, .5) * random_range[1], RandomFloatRange(-.5, .5) * random_range[2]);
		}

		global_point = TransformMove(self.owner.origin, self.owner.angles, (0, 0, 0), (0, cur_yaw, 0), local_offset + hover_offset, (0, 0, 0))["origin"];


		if(Distance(global_point, last_valid_pos) > 16)
		{					
			if(trace_timer > min_trace_period)
			{
				if(trace_fail_time > .5 && cointoss())
				{
					// try to move sideways around an obstacle (we'll only move if the move would allow us to see our owner)
					trying_sideways_move = true;
					dir_to_player = VectorNormalize(self.owner.origin - self.origin);
					dir_to_player_perp = VectorCross(dir_to_player, (0, 0, 1));
					trace_goal = self.origin + dir_to_player_perp * (RandomFloatRange(-1, 1) * 256);
					
					/# if(pdrone_debug()) IPrintLn("trying sideways move"); #/
				}
				else
				{
					trying_sideways_move = false;
					trace_goal = global_point;
				}
	
				if(pdrone_can_move_to_point(self.origin, trace_goal) && pdrone_can_see_owner_from_point(trace_goal))
				{
					trace_fail_time = 0;
					
					last_valid_pos = trace_goal;
					goal_pos = trace_goal;					
				}
				else
				{
					trace_fail_time += trace_timer;
					
					// choose a new direction
					// somewhat biased towards our current direction, and also biased towards our rear
					normal_distributed_random = RandomFloat(1) + RandomFloat(1) - 1; // not exact, n=2
					cur_yaw = AngleClamp(AngleClamp180(cur_yaw) * .5 + (normal_distributed_random * 250));
					
					// we'll raycast again next frame, for now just keep our old goal_pos
				}
		
				trace_timer = 0;
			}
		
			// else, not time to do a raycast again, so don't mess with goal_pos
		
		}
		else
		{
			// didn't move much from last raycast, so assume the point is good
			goal_pos = global_point;
			trace_fail_time = 0;
		}
		
		/#
		if(pdrone_debug())
		{
			Line(self.origin, goal_pos, (0, 0, 1));
			Print3d(self.origin, "" + Int(AngleClamp180(cur_yaw)));
		
			trail_time = 60;
			if(GetTime() % 1000 == 0 && Distance(self.origin, last_debug_pos) > 16)
			{
				thread draw_line_for_time(last_debug_pos, self.origin, 1, 1, 0, trail_time);
				//thread draw_line_for_time(self.owner.origin, self.origin, 0, 1, 1, trail_time);							
				last_debug_pos = self.origin;
			}			
		}		
		#/
		
		if(trace_fail_time > 3)
		{
			// we've been left behind, try to teleport
			/#
			if(pdrone_debug())
			{
				Print3d(self.origin, "teleport from");
				Print3d(global_point, "teleport to");
				Line(self.origin, global_point, (1, 1, 1));
			}
			#/
			if( !(level.player point_in_fov(global_point))    &&
				!(level.player point_in_fov(self.origin))     &&
				pdrone_can_see_owner_from_point(global_point) &&
				pdrone_can_teleport_to_point(global_point))
			{
				/# if(pdrone_debug()) IPrintLn("drone got stuck, teleporting"); #/
				self Vehicle_Teleport(global_point, self.angles);
				goal_pos = global_point;
				last_valid_pos = global_point;
			}
		}
		self SetVehGoalPos( goal_pos, true );

		wait update_rate;
	}
}

/#
pdrone_debug()
{
	SetDevDvarIfUninitialized("pdrone_debug", 0);
	return GetDebugDvarInt("pdrone_debug") == 1;
}

pdrone_nerf_raycasts()
{
	SetDevDvarIfUninitialized("pdrone_nerf_raycasts", 0);
	return GetDebugDvarInt("pdrone_nerf_raycasts") == 1;
}
#/


pdrone_can_move_to_point(start, end)
{
	/# if(pdrone_nerf_raycasts()) return true; #/
	
	// extend a few inches in the direction of travel
	end += VectorNormalize(end - start) * 32;
			
	//can_move = SightTracePassed(start, end, false, self);
	
	// for player trace, shift down a bit
	start += (0, 0, -24);
	end   += (0, 0, -24);	
	trace_result = PlayerPhysicsTrace(start, end);
	can_move = DistanceSquared(trace_result, end) < .01;
	
	/# if(pdrone_debug()) debug_draw_raycast(start, end, can_move); #/
		
	return can_move;
}

pdrone_can_teleport_to_point(end)
{
	/# if(pdrone_nerf_raycasts()) return true; #/
	
	start = end + (0, 0, 12);
	
	trace_result = PlayerPhysicsTrace(start, end);
	can_teleport = DistanceSquared(trace_result, end) < .01;
	
	/# if(pdrone_debug()) debug_draw_raycast(start, end, can_teleport);	#/
		
	return can_teleport;
		}


pdrone_can_see_owner_from_point(global_point)
{
	/# if(pdrone_nerf_raycasts()) return true; #/
	
	eye = self.owner GetEye();
	can_see = SightTracePassed(global_point, eye, false, self);
	
	/# if(pdrone_debug()) debug_draw_raycast(global_point, eye, can_see); #/
	
	return can_see;
}


/#
debug_draw_raycast(start, end, success)
{
	if(success)
	{
		thread draw_line_for_time(start, end, 0, 1, 0, 5);
	}
	else
	{
		thread draw_line_for_time(start, end, 1, 0, 0, 30);
	}
}
#/

pdrone_movement_go_to_point( trace )
{
	self notify( "change_movement_type" );
	self endon( "change_movement_type" );
	self.owner endon( "pdrone_returning" );
	self.owner endon( "death" );
	self endon( "death" );
	
	offset = 110;
	
	point = trace[ "position" ] + offset * trace[ "normal" ];
	
	self SetVehGoalPos( point, true );
	
	self.owner waittill_any_timeout( 10, "stop_pdrone_pov" );
	
	self thread pdrone_movement_follow();
}

pdrone_targeting()
{
	max_traces_per_frame = 5;
	if (level.currentgen)
		max_traces_per_frame = 1;
	
	if( IsDefined( self.owner ) )
	{
		self.owner endon( "pdrone_returning" );
		self.owner endon( "death" );
	}
	self endon( "death" );
	self endon( "emp_death" );
	
	enemyTeam = "axis";
	if( self.script_team == "axis" )
	{
		enemyTeam = "allies";
		if( IsDefined( self.mgturret ) )
		{
			foreach( turret in self.mgturret )
			{
				turret.script_team = "axis";
			}
		}
	}
	
	update_rate = 0.05;
	if (level.currentgen)
		update_rate = 0.5;
	
	while( 1 )
	{
		if( self ent_flag( "fire_disabled" ) )
		{
			wait( update_rate );
			continue;
		}
		
		if( IsDefined( self.pacifist ) && self.pacifist )
		{
			wait update_rate * 2.0;
			continue;
		}
		
		traces_this_frame = 0;
		
		enemies = GetAIArray( enemyTeam );
		if( enemyTeam == "allies" )
		{
			enemies = array_insert( enemies, level.player, 0 );
//				array_add( enemies, level.player );
		}
		start = self GetTagOrigin( "tag_flash" );
		targetfound = false;
		
		foreach( guy in enemies )
		{
			if( !IsDefined( guy ) || !IsAlive( guy ) )
				continue;
			
			guy_eye = guy GetEye();
			
			if(self pdrone_could_be_friendly_fire(start, guy_eye))
			{
				continue;	
			}
			
			traces_this_frame++;
			if(traces_this_frame > max_traces_per_frame)
			{
				waitframe();
				traces_this_frame = 0;
				
				if( !IsDefined( guy ) || !IsAlive( guy ) )	
				{
					continue;	
				}
				start = self GetTagOrigin( "tag_flash" );
				guy_eye = guy GetEye();
				if(self pdrone_could_be_friendly_fire(start, guy_eye))
				{
					continue;	
				}
			}
			
			if( BulletTracePassed( start, guy_eye, false, self ) )
			{
				chance_to_target_player = 33;
				if( IsPlayer( guy ) && RandomInt( 100 ) > chance_to_target_player )
				{
					continue;
				}
				self SetLookAtEnt( guy );
				self thread pdrone_fire_at_enemy( guy );
				guy waittill_any_timeout( 5, "death", "target_lost" );
				targetfound = true;
				break;
			}
		}
		
		if( !targetfound )
		{
			self ClearLookAtEnt();
			if( IsDefined( self.owner ) )
				self SetTargetYaw( self.owner.angles[1] );
		}
		
		wait update_rate;
	}
}

pdrone_fire_at_enemy( guy, start, end )
{
	guy endon( "death" );
	self endon( "death" );
	self endon( "emp_death" );
	if( IsDefined( self.owner ) )
		self.owner endon( "pdrone_returning" );
	
	self notify( "new_target" );
	self endon( "new_target" );
	
	to_eye = guy GetEye() - guy.origin;
	
	aim_offset_base = ( 0, 0, to_eye[2]/2 );
	
	//lower accuracy when targeting a player
	if( IsPlayer( guy ) )
		accuracy = 0.1;
	else
		accuracy = 0.3;
	
	fire_rate = 0.095;
	burst_time_min = 0.2;
	burst_time_max = 0.3;
	if (level.currentgen)
	{
		fire_rate = 0.2499;
		burst_time_min = 0.5;
		burst_time_max = 0.75;
	}
	acc_min_xy = -10 / accuracy;
	acc_max_xy = 10 / accuracy;
	acc_min_z = -5 / accuracy;
	acc_max_z = 5 / accuracy;
	
	while( 1 )
	{
		aim_offset = aim_offset_base + ( RandomFloatRange( acc_min_xy , acc_max_xy ), RandomFloatRange( acc_min_xy, acc_max_xy ), RandomFloatRange( acc_min_z, acc_max_z ) );
		self SetTurretTargetEnt( guy, aim_offset );
		
		tag_flash_origin = self GetTagOrigin( "tag_flash" );
		
		if( self pdrone_could_be_friendly_fire(tag_flash_origin, guy.origin + aim_offset) || !BulletTracePassed( tag_flash_origin, guy GetEye(), false, self ) )
		{
			guy notify( "target_lost" );
			return;
		}
		
		// fire at target in bursts
		fire_time_total = RandomFloatRange( 2, 3 );
			
		while ( fire_time_total > 0 )
		{
			fire_burst_time = RandomFloatRange( burst_time_min, burst_time_max );
			
			burst_time = min( fire_burst_time, fire_time_total );
			while ( burst_time > 0 )
			{
				flashOrigin = self GetTagOrigin("tag_flash");
				gunForward = compute_fireweapon_direction(flashOrigin, self GetTagAngles("tag_flash"), guy.origin + aim_offset, 10);
				if( self pdrone_could_be_friendly_fire(flashOrigin, flashOrigin + gunForward * 10000))
				{
					guy notify( "target_lost" );
					return;
				}

				// /# thread draw_line_for_time(guy GetEye(), self GetTagOrigin( "tag_flash" ), 1, 1, 1, .25); #/
				
				self FireWeapon();
				fire_time_total -= fire_rate;
				burst_time -= fire_rate;
				wait fire_rate;
			}
			
			burst_wait_time = RandomFloatRange( 0.5, 1 );
			burst_wait_time = min( burst_wait_time, fire_time_total );
			if ( burst_wait_time > 0 )
			{
				fire_time_total -= burst_wait_time;
				wait burst_wait_time;
			}
		}
	}
}

// compute the actual direction the turret will fire (based on aimPadding, set in the weapon def)
// see VehCmd_FireWeapon() in vehicle_script.cpp
compute_fireweapon_direction(flashOrigin, gunAngles, targetOrigin, aimPadding)
{
	bulletAngles = VectorToAngles(targetOrigin - flashOrigin);
	diffAngles = AnglesSubtract(gunAngles, bulletAngles);
	diffAngles = (Clamp(diffAngles[0], 0-aimPadding, aimPadding), Clamp(diffAngles[1], 0-aimPadding, aimPadding), 0);
	gunAngles = AnglesSubtract(gunAngles, diffAngles);
	gunForward = AnglesToForward(gunAngles);
	return gunForward;
}

AnglesSubtract(a, b)
{
	return (
		AngleClamp180(a[0] - b[0]),
		AngleClamp180(a[1] - b[1]),
		AngleClamp180(a[2] - b[2])
	);
}

pdrone_could_be_friendly_fire(start, end)
{
	if(self.script_team == "axis")
	{
		return false;
	}
	else
	{
		return shot_endangers_any_player(start, end);
	}
}


pdrone_damage_function( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	//5x damage from energy weapons
	if( type == "MOD_ENERGY" )
		self DoDamage( damage*4, attacker.origin, attacker );
}

pdrone_handle_death()
{
	self waittill( "death" );
	
	if( IsDefined( self ) )
	{
		if( self.classname == "script_vehicle_pdrone_atlas_large")
		{
			playfx( getfx( "pdrone_large_death_explosion" ), self GetTagOrigin( "tag_origin" ) );			
			self snd_message( "pdrone_death_explode" );
		}
		else
		{
			playfx( getfx( "pdrone_death_explosion" ), self GetTagOrigin( "tag_origin" ) );			
			self snd_message( "pdrone_death_explode" );			
		}
	}
}

pdrone_emp_death()
{
	self endon( "death" );
	self endon( "in_air_explosion" );
	self notify( "emp_death" );
	
	//we are doing a custom death
	self.vehicle_stays_alive = true;
	
	velocity = self Vehicle_GetVelocity();
	radius = 60;
	
	//special case crash location logic
	if( IsDefined( level.get_pdrone_crash_location_override ) )
	{
		crashLoc = [[ level.get_pdrone_crash_location_override ]]();
	}
	else
	{
		//determine crash location
		dest = (self.origin[0] + velocity[0]*10, self.origin[1] + velocity[1]*10, self.origin[2] - 2000 );
		crashLoc = PhysicsTrace( self.origin, dest );
	}
	
	self notify( "newpath" );
	self notify( "deathspin" ); //need to know when deathspin begins (not just newpath)

	self thread drone_deathspin();
	
	crash_speed = 60;
	self Vehicle_SetSpeed( crash_speed, 60, 1000 );
	self SetNearGoalNotifyDist( radius );
	self SetVehGoalPos( crashLoc, 0 );
	self thread drone_emp_crash_movement( crashloc, radius, crash_speed );
	self waittill_any( "goal", "near_goal" );

	self notify( "stop_crash_loop_sound" );
	self notify( "crash_done" );
	
	if( self.classname == "script_vehicle_pdrone_atlas_large")
	{
		playfx( getfx( "pdrone_large_death_explosion" ), self GetTagOrigin( "tag_origin" ) );
		self snd_message( "pdrone_death_explode" );
	}
	else
	{
		playfx( getfx( "pdrone_death_explosion" ), self GetTagOrigin( "tag_origin" ) );	
		self snd_message( "pdrone_death_explode" );
	}

	self delete();
}

//set up dummy model and animate its spin
#using_animtree( "script_model" );
drone_deathspin()
{
	level.scr_animtree[ "pdrone_dummy" ] 				= #animtree;
	level.scr_anim[ "pdrone_dummy" ][ "roll_left" ][0]	= %rotate_X_L;
	level.scr_anim[ "pdrone_dummy" ][ "roll_right" ][0]	= %rotate_X_R;
	
	dummy = spawn( "script_model", self.origin );
	dummy.angles = self.angles;
	dummy linkto( self );
	if( IsDefined( self.death_model_override ) )
		dummy SetModel( self.death_model_override );
	else
		dummy SetModel( self.model );
	self hide();
	stopFXOnTag( getfx( "drone_beacon_red" ), self, "tag_origin" );
	playfxontag(getfx("emp_drone_damage"), dummy, "TAG_ORIGIN");
	self snd_message( "pdrone_emp_death" );
	
	dummy.animname = "pdrone_dummy";
	dummy assign_animtree();
	if( cointoss() )
	{
		anime = "roll_left";
	}
	else
	{
		anime = "roll_right";
	}
	dummy thread anim_loop_solo( dummy, anime );
		
	
	self waittill( "death" );
	dummy delete();
}

drone_emp_crash_movement( target_origin, target_radius, crash_speed )
{
	self endon( "crash_done" );
	self ClearLookAtEnt();
	
	self SetMaxPitchRoll( 180, 180 );
	self SetYawSpeed( 400, 100, 100 );
	self setturningability( 1 );
	yawspeed = 1400;
	yawaccel = 800;
	targetyaw = undefined;
	
	angleoff = 90 * RandomIntRange( -2, 3 );
	
	for ( ;; )
	{
		if( self.origin[2] < (target_origin[2] + target_radius) )
			self notify( "near_goal" );
		
		if( cointoss() )
		{
			targetyaw = self.angles[ 1 ] - 300;
			self setyawspeed( yawspeed, yawaccel );
			self settargetyaw( targetyaw );
			self SetTargetYaw( targetyaw );
		}
		
		wait 0.05;
	}	
}

/*
 * pdrone_ai_deploy: Spawn npcSpawner and deploy a drone
 * * Requires 
 */
pdrone_ai_deploy( npcSpawner )
{
	guy = npcSpawner spawn_ai( true );
	guy.animname = "generic";
	struct = getstruct( npcSpawner.target, "targetname" );
	org = spawn( "script_origin", struct.origin );
	org.angles = struct.angles;
	droneSpawner = getent( struct.target, "targetname" );
	
	isRun = false;
	approachType = undefined;
	
	switch ( struct.animation )
	{
		case "drone_deploy_crouch_to_crouch_guy":
			approachType = "Cover Crouch";
			break;
		case "drone_deploy_crouch_to_run_guy":
			isRun = true;
			approachType = "Cover Crouch";
			break;
		case "drone_deploy_run_to_run_guy":
			isRun = true;
			break;	
		case "drone_deploy_run_to_stand_guy":
			break;
		default:
			Assert( "Animation [" + struct.animation + "] not supported in _pdrone for deploying." );
			break;
	}
	
	anime = GetSubStr( struct.animation, 0, struct.animation.size - 4 );
	drone_prop = spawn( "script_model", guy GetTagOrigin( "J_Spine4" ) );
	drone_prop SetModel( droneSpawner.model );
	
	rotOffset = guy GetTagAngles( "J_Spine4" );
	drone_prop.angles = rotOffset;
	
	drone_prop LinkTo( guy, "J_Spine4", (-3.746, -9.852, -.08), (0, 0, 90) );
	drone_prop.animname = "personal_drone";
	drone_prop UseAnimTree( level.scr_animtree[ "personal_drone" ] );
	//drone_prop thread anim_loop_solo( drone_prop, "personal_drone_folded_idle" );
	//drone_prop setanim( drone_prop getanim( anime ), 1, 0 );
	drone_prop setanim( level.scr_anim[ "personal_drone" ][ "personal_drone_folded_idle" ][0], 1, 0 );	
	
	//anim_reach_and_approach_solo
	
	guy.ignoreall = true;
	
	if( IsDefined( approachType ) )
		org anim_reach_and_approach_solo( guy, anime, undefined, approachType );
	else
		org anim_generic_reach( guy, anime );
	org anim_generic_reach( guy, anime );
	if( IsDefined( isRun ) && isRun )
		org thread anim_generic_run( guy, anime );
	else
		org thread anim_generic( guy, anime );
	
	
	droneSpawner.origin = drone_prop.origin;
	droneSpawner.angles = drone_prop.angles;
	
	drone = droneSpawner spawn_vehicle();
	if( IsDefined( drone.target ) )
		drone_follows_launcher = false;
	else
	{
		drone_follows_launcher = true;
		drone.owner = guy;
	}
	
	//wait until launched before firing
	drone.pacifist = true;
	//drone.origin = drone_prop.origin;
	//drone.angles = drone_prop.angles;
	drone_prop delete();
	drone.animname = "personal_drone";
	org anim_single_solo( drone, anime );
	
	//wait until launched before firing
	drone.pacifist = undefined;
	guy.ignoreall = false;
	
	//If drone has a path, follow it.  Otherwise, follow the launcher
	if( !drone_follows_launcher )
		drone gopath();
	
	if( drone.script_team == "axis" )
		drone thread maps\_shg_utility::make_emp_vulnerable();
	return guy;
}

destroy_drones_when_nuked()
{
	self endon( "death" );
	
	while( true )
	{
		if( GetDvar( "debug_nuke" ) == "on" )
		{
			self DoDamage( self.health + 99999, ( 0, 0, -500 ), level.player );
		}
		
		wait( 0.05 );
	}
}

/*QUAKED script_vehicle_pdrone (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER
 
This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_pdrone::main( "vehicle_pdrone", undefined, "script_vehicle_pdrone" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pdrone

defaultmdl="vehicle_pdrone"
default:"vehicletype" "pdrone"
default:"script_team" "allies"
 */

/*QUAKED script_vehicle_pdrone_kva (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER
 
This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_pdrone::main( "vehicle_pdrone_kva", undefined, "script_vehicle_pdrone_kva" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pdrone_kva

defaultmdl="vehicle_pdrone_kva"
default:"vehicletype" "pdrone"
default:"script_team" "axis"
 */
 
/*QUAKED script_vehicle_pdrone_atlas (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER
 
This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_pdrone::main( "vehicle_atlas_assault_drone", undefined, "script_vehicle_pdrone_atlas" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pdrone_atlas

defaultmdl="vehicle_atlas_assault_drone"
default:"vehicletype" "pdrone"
default:"script_team" "axis"
 */
 
/*QUAKED script_vehicle_pdrone_atlas_large (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER
 
This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_pdrone::main( "vehicle_atlas_assault_drone_large", undefined, "script_vehicle_pdrone_atlas_large" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pdrone_atlas_large

defaultmdl="vehicle_atlas_assault_drone_large"
default:"vehicletype" "pdrone"
default:"script_team" "axis"
*/
