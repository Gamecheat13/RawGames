#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_digbats;
#include maps\_skipto;
#include maps\_scene;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

level_init_flags()
{
	//global flags
	flag_init( "movie_done" );
	
	maps\panama_house::init_house_flags();
	maps\panama_airfield::init_airfield_flags();
	maps\panama_motel::init_motel_flags();
	maps\panama_slums::init_flags();
	maps\panama_building::init_flags();
	maps\panama_chase::init_flags();
	maps\panama_docks::init_flags();
	
}

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_setup()
{
	load_gumps_panama();
	
	skipto = level.skipto_point;
		
	if ( skipto == "house" )
		return;	

	flag_set( "house_meet_mason" );
	flag_set( "house_follow_mason" );
	flag_set( "start_shed_obj" );
	flag_set( "player_opened_shed" );
	flag_set( "player_frontyard_obj" );
	flag_set( "trig_player_exit" );
	flag_set( "house_event_end" );
	flag_set( "zodiac_approach_start" );	
	
	if ( skipto == "zodiac" )
		return;	
	
	flag_set( "zodiac_approach_end" );	
	
	if ( skipto == "beach" )
		return;

	flag_set( "player_at_first_blood" );
	flag_set( "player_contextual_start" );
	flag_set( "parking_lot_gone_hot" );
	flag_set( "setup_runway_standoff" );
	
	if (skipto == "runway")
		return;		
	
	if (skipto == "learjet")
		return;		
	
	flag_set( "airfield_end" );
	flag_set( "skinner_motel_dialogue" );
	
	if (skipto == "motel")
		return;	

	flag_set( "skinner_motel_dialogue" );
	flag_set( "mason_at_motel" );
	flag_set( "start_intro_anims" );
	flag_set( "motel_room_cleared" );
	flag_set( "motel_scene_end" );
		
	if (skipto == "slums_intro")
		return;		
		
	flag_set( "ambulance_complete" );
	flag_set( "slums_update_objective" );	

	if (skipto == "slums_main" )
		return;

	if (skipto == "building")
		return;	

	flag_set( "panama_building_start" );
	
	if (skipto == "chase")
		return;	

	if (skipto == "checkpoint")
		return;
	
	flag_set( "jump_start" );
	flag_set( "checkpoint_approach" );
	flag_set( "checkpoint_reached" );
	flag_set( "checkpoint_cleared" );
	flag_set( "checkpoint_finished" );
	
	if (skipto == "docks")
		return;		

	flag_set( "docks_cleared" );
	flag_set( "docks_entering_elevator" );
	
	if (skipto == "sniper")
		return;
}

setup_objectives()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	
	//HOUSE
	level.OBJ_MEET = 				register_objective( &"PANAMA_OBJ_MEET" );
	level.OBJ_SHED = 				register_objective( &"PANAMA_OBJ_SHED" );
	level.OBJ_FRONTYARD = 			register_objective( &"PANAMA_OBJ_FRONTYARD" );
	
	//AIRFIELD
	level.OBJ_INTERACT = 			register_objective( &"SP_OBJECTIVES_INTERACT" );
	level.OBJ_CAPTURE_NORIEGA = 	register_objective( &"PANAMA_OBJ_CAPTURE_NORIEGA" );
	level.OBJ_ASSIST_SEALS = 		register_objective( &"PANAMA_OBJ_ASSIST_SEALS" );

	//SLUMS
	level.OBJ_CAPTURE_MENENDEZ = 	register_objective( &"PANAMA_OBJ_CAPTURE_MENENDEZ" );
	level.OBJ_REACH_CHECKPOINT = 	register_objective( &"PANAMA_OBJ_REACH_CHECKPOINT" );
	
	//Docks
	level.OBJ_DOCKS_SNIPER = register_objective( &"PANAMA_OBJ_DOCKS_SNIPER" );
	level.OBJ_DOCKS_KILL_MENENDEZ = register_objective( &"PANAMA_OBJ_DOCKS_KILL_MENENDEZ" );
	wait 0.05;
	
	level thread house_objectives();
	level thread airfield_objectives();
	level thread slums_objectives();
	level thread chase_objectives();
	level thread docks_objectives();
}

setup_challenges()
{
	wait_for_first_player();

	level.player thread maps\_challenges_sp::register_challenge( "locateintel", ::locate_int );
	level.player thread maps\_challenges_sp::register_challenge( "destroylearjet", maps\panama_airfield::challenge_destroy_learjet );	
	level.player thread maps\_challenges_sp::register_challenge( "destroyzpu", maps\panama_slums::challenge_destroy_zpu );
	level.player thread maps\_challenges_sp::register_challenge( "nodeath", ::challenge_nodeath );
	level.player thread maps\_challenges_sp::register_challenge( "grenadecombo", maps\panama_slums::challenge_grenade_combo );
}

//Handles logic for completing nodeath challenge
challenge_nodeath( str_notify )
{
	flag_wait( "challenge_nodeath_check_start" );
	
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
	
	flag_set( "challenge_nodeath_check_end" );
}

locate_int( str_notify )
{
	flag_wait( "final_cin_fade_out" );
	
	player_collected_all = collected_all();
	
	if( player_collected_all )
	{
		self notify( str_notify );		
	}	
}

house_objectives()
{
	flag_wait( "house_meet_mason" );

	set_objective( level.OBJ_MEET, getstruct( "s_greet_mason_obj" ), "breadcrumb" );
	
	flag_wait( "house_follow_mason" );
	
	set_objective( level.OBJ_MEET, undefined, "remove" );
	
	set_objective( level.OBJ_MEET , level.ai_mason_casual, "follow" );
	
	flag_wait( "start_shed_obj" );
	
	set_objective( level.OBJ_MEET, level.ai_mason_casual, "done" );
	
	set_objective( level.OBJ_SHED, getstruct( "s_shed_door_obj" ), "breadcrumb" );
	
	flag_wait( "player_opened_shed" );
	
	set_objective( level.OBJ_SHED, undefined, "remove" );
	set_objective( level.OBJ_SHED, undefined, "done" );
	
	flag_wait( "player_frontyard_obj" );
	
	set_objective( level.OBJ_FRONTYARD, getstruct( "s_player_gate_obj" ), "breadcrumb" );
	
	flag_wait( "trig_player_exit" );
	set_objective( level.OBJ_FRONTYARD, undefined, "remove" );	
	set_objective( level.OBJ_FRONTYARD, undefined, "done" );	
	
	flag_wait( "house_event_end" );

	set_objective( level.OBJ_MEET, undefined, "delete" );	
	set_objective( level.OBJ_SHED, undefined, "delete" );		
	set_objective( level.OBJ_FRONTYARD, undefined, "delete" );	
}

airfield_objectives()
{
	flag_wait( "zodiac_approach_start" );

	set_objective( level.OBJ_CAPTURE_NORIEGA , level.mason, "follow" );
	set_objective( level.OBJ_CAPTURE_NORIEGA , level.mason, "remove" );
		
	flag_wait( "zodiac_approach_end" );
	
	wait 0.05;

	set_objective( level.OBJ_CAPTURE_NORIEGA , level.mason, "follow" );
	
	flag_wait( "player_at_first_blood" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA , level.mason, "remove" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "s_mantle_up_obj_1" ), "kill" );
	
	level.player AllowMelee( false );

	flag_wait_any( "player_contextual_start", "parking_lot_gone_hot" );

	level.player AllowMelee( true );

	trig_contextual_melee = GetEnt( "trig_contextual_melee", "targetname" );
	if ( IsDefined( trig_contextual_melee ) )
	{
		trig_contextual_melee Delete();
	}

	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );
	
	waittill_ai_group_cleared( "parking_lot_guys" );

	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "follow" );
	
	flag_wait( "setup_runway_standoff" );
		
	wait( 2 );	

	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "remove" );	
	set_objective( level.OBJ_ASSIST_SEALS, level.mason, "follow" );
	
	flag_wait( "airfield_end" );

	set_objective( level.OBJ_ASSIST_SEALS, level.mason, "remove" );	
	set_objective( level.OBJ_ASSIST_SEALS, undefined, "done" );

	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "follow" );
	
	flag_wait( "skinner_motel_dialogue" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "s_hotel_obj_breadcrumb" ), "breadcrumb" );

	flag_wait( "mason_at_motel" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );
	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "remove" );
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "s_breach_motel_obj" ), "breach" );

	flag_wait( "start_intro_anims" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );
	
	flag_wait( "motel_room_cleared" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "done" );
	
	flag_wait( "motel_scene_end" );

	set_objective( level.OBJ_ASSIST_SEALS, undefined, "delete" );	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "delete" );
}

slums_objectives()
{
	
	flag_wait( "motel_scene_end" );
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ );
	
	flag_wait( "ambulance_complete" );
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, level.noriega, "follow" );
	
	flag_wait( "slums_update_objective" );
	
	//increase the draw distance of objectives
	level.player SetClientDvar("cg_objectiveIndicatorFarFadeDist", 80000);
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, GetEnt( "building_enter_front_door", "targetname" ).origin + (0,0,72) );

	flag_wait( "panama_building_start" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, level.mason, "follow" );
}

chase_objectives()
{
	flag_wait( "jump_start" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, GetStruct( "jump_obj_marker", "targetname" ), "breadcrumb" );
	flag_wait( "checkpoint_approach" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, GetStruct( "checkpoint_approach_marker", "targetname" ), "breadcrumb" );
	flag_wait( "checkpoint_reached" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	flag_wait( "checkpoint_cleared" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, GetStruct( "checkpoint_obj_marker_jeep", "targetname" ), "breadcrumb" );
	flag_wait( "checkpoint_finished" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "done" );
}

docks_objectives()
{	
	flag_wait( "docks_cleared" );
	
	set_objective( level.OBJ_DOCKS_SNIPER, GetStruct( "docks_obj_marker_elevator", "targetname" ), "breadcrumb" );
	flag_wait( "docks_entering_elevator" );
	
	set_objective( level.OBJ_DOCKS_SNIPER, GetStruct( "docks_obj_marker_rifle", "targetname" ), "breadcrumb" );
	flag_wait( "docks_rifle_mounted" );
	
	set_objective( level.OBJ_DOCKS_SNIPER, undefined, "done" );
	flag_wait( "docks_kill_menendez" );
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "delete" );
	set_objective( level.OBJ_DOCKS_KILL_MENENDEZ, level.mason, "kill" );
	flag_wait( "docks_mason_dead_reveal" );
}

load_gumps_panama()
{
	if ( is_after_skipto( "checkpoint" ) )
	{
		load_gump( "panama_gump_4" );
	}
	else if ( is_after_skipto( "motel" ) )
	{
		load_gump( "panama_gump_3" );
	}
	else if ( is_after_skipto( "house" ) )
	{
		level thread load_gump( "panama_gump_2" );
	}
	else
	{
		level thread load_gump( "panama_gump_1" );
	}
}

nightingale_watch()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "grenade_fire", e_grenade, str_weapon_name );
		
		if( str_weapon_name == "nightingale_sp" )
		{
			//e_grenade thread onSpawnDecoy();
			e_grenade thread nightingale_think();
		}
	}
}

nightingale_think()
{
	//wait for grenade to reach the ground
	wait 2;	
	
	//start the smoke
	PlayFXOnTag( level._effect[ "nightingale_smoke" ], self, "tag_fx" );
	
	a_enemies = GetAiArray( "axis" );
	foreach( ai_enemy in a_enemies )
	{
		if( IsDefined( ai_enemy ) && IsAlive( ai_enemy ) )
		{
			if( Distance2D( self.origin, ai_enemy.origin ) < 2000 )
			{
				ai_enemy thread shoot_at_target( self, undefined, undefined, 20 );
				ai_enemy thread nightingale_marked();
				
			}
		}
	}
	
	//shoot friendly weapon bullets
	for ( i = 0; i < 200; i++ )
	{
		v_start_pos = self.origin + ( 0, 0, 10 );
		v_end_pos = v_start_pos + ( 0, 0, 100 );
		v_offset = ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), 0 );
		MagicBullet( "m16_sp", v_start_pos, v_end_pos + v_offset );
		wait 0.1;
	}
		
}

nightingale_marked()
{
	self endon( "death" );
	
	self.grenade_marked = true;
	
	wait 20;
	
	self.grenade_marked = undefined;
}

onSpawnDecoy()
{
	self endon( "death" );
	
	self.initial_velocity = self GetVelocity();
	delay = 1;
	
	wait (delay );
	decoy_time = 30;
	spawn_time = GetTime();

	self thread simulateWeaponFire();

	while( 1 )
	{
		if ( GetTime() > spawn_time + ( decoy_time * 1000 ))
		{
			self destroyDecoy();
			return;
		}
		
		wait(0.05);
	}
}

moveDecoy( count, fire_time, main_dir, max_offset_angle )
{
	self endon( "death" );
	self endon( "done" );
	
	if ( !(self IsOnGround() ) )
		return;
		
	min_speed = 100;
	max_speed = 200;
	
	min_up_speed = 100;
	max_up_speed = 200;
	
	current_main_dir = RandomIntRange(main_dir - max_offset_angle,main_dir + max_offset_angle);
	
	avel = ( RandomFloatRange( 800, 1800) * (RandomIntRange( 0, 2 ) * 2 - 1), 0, RandomFloatRange( 580, 940) * (RandomIntRange( 0, 2 ) * 2 - 1));

	intial_up = RandomFloatRange( min_up_speed, max_up_speed );
	
	start_time = GetTime();
	gravity = GetDvarint( "bg_gravity" );
	
//	PrintLn( "start time " + start_time );
	for ( i = 0; i < 1; i++ )
	{		
		angles = ( 0,RandomIntRange(current_main_dir - max_offset_angle,current_main_dir + max_offset_angle), 0 );
		dir = AnglesToForward( angles );
		
		dir = VectorScale( dir, RandomFloatRange( min_speed, max_speed ) );
		
		deltaTime = ( GetTime() - start_time ) * 0.001;
		
		// must manually manage the gravity because of the way the Launch function and the tr interpolater work
		up = (0,0, (intial_up) - (800 * deltaTime)  );
		
		//TODO: There is no optional angular velocity parameter on the Launch() function.  Fixed this temporarily by removing the second
		//parameter.  -Jacob True
		//self Launch( dir + up, avel );
		self Launch( dir + up );
		
		wait( fire_time );
	}
//	PrintLn( "end time " + GetTime() );
}

destroyDecoy()
{
	self notify( "done" );
	//self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	
	// play deactivated particle effect here
}

simulateWeaponFire()
{
	self endon( "death" );
	self endon( "done" );
	
	weapon = "m16_sp";
	
	//self thread watchForExplosion(owner, weapon);
	self thread trackMainDirection();
	
	self.max_offset_angle = 30;
	
	fireTime = 10; //WeaponFireTime(weapon);
	clipSize = 5; // WeaponClipSize(weapon);
	reloadTime = 1.0; //WeaponReloadTime(weapon);

	if ( clipSize  > 30 )
		clipSize = 30;
		
	burst_spacing_min = 2;
	burst_spacing_max = 6;

	while( 1 )
	{
		burst_count = RandomIntRange( Int(clipSize * 0.6), clipSize );
		interrupt = false; // RandomIntRange( 0, 2 );
		self thread moveDecoy( burst_count, fireTime, self.main_dir, self.max_offset_angle );
		//self fireburst( weapon, fireTime, burst_count, interrupt );

		//finishWhileLoop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}


fireburst( weapon, fireTime, count, interrupt )
{
	interrupt_shot = count;
	
	if ( interrupt )
	{
		interrupt_shot = Int( count * RandomFloatRange( 0.6, 0.8 ) ); 
	}
	
	//self FakeFire( self.origin, weapon, interrupt_shot );
	wait ( fireTime * interrupt_shot );
	
	if ( interrupt )
	{
		//self FakeFire( owner, self.origin, weapon, count - interrupt_shot );
		wait ( fireTime * (count - interrupt_shot) );
	}
}

trackMainDirection()
{
	self endon( "death" );
	self endon( "done" );
	self.main_dir = Int(VectorToAngles((self.initial_velocity[0], self.initial_velocity[1], 0 ))[1]);
	
	up = (0,0,1);
	while( 1 )
	{
		self waittill( "grenade_bounce", pos, normal );
		
		dot = VectorDot( normal, up );
		
		// something got in the way thats somewhat vertical 
		if ( dot < 0.5 && dot > -0.5 ) 
		{
			self.main_dir = Int(VectorToAngles((normal[0], normal[1], 0 ))[1]);
		}
	}
}


//threaded once on the player at the start of the level
ir_strobe_watch()
{
	self endon( "death" );
	
	//check for multiple calls since this bool is created
	if( IsDefined( level.strobe_active ) )
	{
		return;
	}
	
	screen_message_create( "Use strobe grenades to call down AC130 fire on a position" );
	
	delay_thread( 5.0, ::screen_message_delete );

	level.strobe_active = false;
	level.strobe_queue = [];
	
	//function that watches for active but unused strobes
	self thread _ir_strobe_queue();
	
	while( 1 )
	{
		self waittill( "grenade_fire", e_grenade, str_weapon_name );
		
		if( str_weapon_name == "irstrobe_sp" )
		{
			e_grenade.active = true;
			e_grenade ent_flag_init( "start_fire" );
			level.strobe_queue[ level.strobe_queue.size ] = e_grenade;
			e_grenade thread _ir_strobe_logic();
		}
	}
}

_ir_strobe_queue()
{
	self endon( "death" );
	
	while( 1 )
	{
		if( !level.strobe_active )
		{
			for( i = 0; i < level.strobe_queue.size; i++ )
			{
				if( level.strobe_queue[i].active )
				{
					level.strobe_active = true;
					level.strobe_queue[i] ent_flag_set( "start_fire" );
					break;
				}
			}
		}
		
		wait 1;
	}
}

_ir_strobe_logic()
{
	//wait a few seconds before starting strobe
	wait 2;
	
	//create strobe blinking FX	
	e_model = spawn( "script_model", self.origin );
	e_model SetModel( "tag_origin" );
	PlayFxOnTag(level._effect["ir_strobe"], e_model, "tag_origin");
	e_model playloopsound( "fly_irstrobe_beep", .1 );

	//wait in queue until ready
	self ent_flag_wait( "start_fire" );
	
	//a reasonable time for the AC130 to get in firing position
	wait 3;	
	
	//check for LOS with the sky
	traceData = BulletTrace( self.origin, self.origin + (0,0,256), false, self );
	if( traceData[ "fraction" ] == 1 )
	{
		//rain vulcan bullets
		v_end_pos = self.origin;
		ac130_shoot( v_end_pos, true );
		
		self.active = false;
		level.strobe_active = false;
	}
	else
	{
		self.active = false;
		level.strobe_active = false;
		wait 6;
	}
	
	level.strobe_active = false;
	e_model delete();
	
}

air_ambience( str_veh_targetname, str_paths, flag_ender, n_min_wait, n_max_wait )
{
	if( !IsDefined( n_min_wait ) )
	{
		n_min_wait = 4.0;
	}
	
	if( !IsDefined( n_max_wait ) )
	{
		n_max_wait = 6.0;	
	}
	
	a_paths = GetVehicleNodeArray( str_paths, "targetname" );
	nd_last_path = a_paths[0];
	
	while( !flag( flag_ender ) )
	{
		nd_path = a_paths[ RandomInt( a_paths.size ) ];
		while( nd_path == nd_last_path )
		{
			nd_path = a_paths[ RandomInt( a_paths.size ) ];
		}
		nd_last_path = nd_path;
		
		v_jet = spawn_vehicle_from_targetname( str_veh_targetname );
		v_jet thread _air_ambience_think( nd_path );
		v_jet SetForceNoCull();
		
		if ( v_jet.vehicletype == "plane_mig23" )
		{
			v_jet thread add_jet_fx();
		}
		
		wait RandomFloatRange( n_min_wait, n_max_wait );
	}
}

_air_ambience_think( nd_path )
{
	self getonpath( nd_path );
	self gopath();
	VEHICLE_DELETE( self );
}

add_jet_fx()
{
	PlayFXOnTag( level._effect[ "jet_contrail" ], self, "tag_wingtip_l" );
	PlayFXOnTag( level._effect[ "jet_contrail" ], self, "tag_wingtip_r" );
	
	PlayFXOnTag( level._effect[ "jet_exhaust" ], self, "tag_engine_fx" );
}

ac130_ambience( flag_ender )
{
	while( !flag( flag_ender ) )
	{
		//find a position 5000 units roughly away from the player in front of him
		v_forward = AnglesToForward( level.player GetPlayerAngles() ) * 5000;
		v_end_pos = level.player.origin + ( v_forward[0], v_forward[1], 0 );
		
		//an additional offset of a 2000 radius
		v_offset = ( RandomIntRange( -2000, 2000 ), RandomIntRange( -2000, 2000 ), 0 );
		v_end_pos = v_end_pos + v_offset;
		
		ac130_shoot( v_end_pos );		
		
		wait 5;
	}
}

ac130_shoot( v_end_pos, b_close )
{
	//the start position is about 2500 units above
	v_start_pos = v_end_pos + ( 0, 0, 2500 );	
	
	//the fx play position is even higher, out of the skybox	
	v_fx_pos = v_start_pos + ( 0, 0, 5000 );
	
	sound_ent = spawn( "script_origin", v_start_pos );
	
	//this call is made close to a player
	if( IsDefined( b_close ) && b_close )
	{
		Earthquake( 0.3, 8, v_end_pos, 1028 );
		level.player thread _ac130_vibration( v_start_pos );
		level thread _ac130_clear_enemies( v_start_pos );
	}
					
	for ( i = 0; i < 60; i++ )
	{
		v_offset_end = v_end_pos + ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), 0 );
		
		sound_ent playloopsound( "wpn_ac130_fire_loop", .25 );
		MagicBullet( "ac130_vulcan_minigun", v_start_pos, v_offset_end );
	//	PlayFX( getfx( "ac130_sky_light" ), v_fx_pos, v_end_pos - v_fx_pos );
		wait 0.1;
	}
	
	sound_ent delete();
	
	//stops rumble from the gunfire if it was going
	if( IsDefined( b_close ) && b_close )
	{
		level.player notify( "stop_rumble_check" );
	}
}

_ac130_vibration( v_start_pos )
{
	self endon( "stop_rumble_check" );
	
	while( 1 )
	{
		if( Distance2D( v_start_pos, self.origin ) < 1028 )
		{
			self PlayRumbleOnEntity( "damage_heavy" );
		}
		wait 0.05;
	}
}

_ac130_clear_enemies( v_start_pos )
{
	wait 1;
	
	a_axis = GetAIArray( "axis" );
	foreach( e_enemy in a_axis )
	{
		//if the enemy is currently distracted with a nightingale grenade kill them and notify the challenge
		if( IsAlive( e_enemy) && IsDefined( e_enemy.grenade_marked ) && e_enemy.grenade_marked )
		{
			MagicBullet( "ac130_vulcan_minigun", v_start_pos, e_enemy.origin );
			e_enemy die();
			level notify( "combo_death" );
			wait RandomFloatRange( 0.5, 1.0 );
		}
		//kill any enemies in the radius of the strobe grenade
		else if( IsAlive( e_enemy ) && ( Distance2D( v_start_pos, e_enemy.origin ) < 800 ) )
		{
			MagicBullet( "ac130_vulcan_minigun", v_start_pos, e_enemy.origin );
			e_enemy die();
			wait RandomFloatRange( 0.5, 1.0 );
		}
	}
}

sky_fire_light_ambience( str_area, flag_ender )
{
	a_exploder_id = [];
	
	switch( str_area )
	{
		case "airfield":
			a_exploder_id[0] = 102;
			a_exploder_id[1] = 103;
			a_exploder_id[2] = 104;
			a_exploder_id[3] = 105;
			break;
		case "slums":
			a_exploder_id[0] = 501;
			a_exploder_id[1] = 502;
			a_exploder_id[2] = 503;
			a_exploder_id[3] = 504;
			break;
	}
	
	while( !flag( flag_ender ) )
	{
		wait RandomFloatRange( 5.0, 8.0 );
		
		n_exploder_id = a_exploder_id[ RandomInt( a_exploder_id.size ) ];
		exploder( n_exploder_id );
	}
}

player_lock_in_position( origin, angles )
{
	link_to_ent = spawn("script_model", origin);
	link_to_ent.angles = angles;
	link_to_ent setmodel("tag_origin");
	self playerlinktoabsolute(link_to_ent, "tag_origin");
	
	self waittill("unlink_from_ent");
	self unlink();
	link_to_ent delete();
}

old_man_woods( str_movie_name )
{
	flag_clear( "movie_done" );
	play_movie( str_movie_name, false, false, undefined, true, "movie_done" );
	flag_set( "movie_done" );
}

run_anim_to_idle( str_start_scene, str_idle_scene )
{
	run_scene( str_start_scene );
	level thread run_scene( str_idle_scene );
}

fail_player( str_dead_quote_ref )
{
	SetDvar( "ui_deadquote", str_dead_quote_ref );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}