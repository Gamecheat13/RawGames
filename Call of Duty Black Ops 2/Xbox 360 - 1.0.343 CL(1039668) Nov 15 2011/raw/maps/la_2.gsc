/*
la_2.gsc - sets up global functions and skiptos
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;

#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!	
	maps\la_2_fx::main();
	maps\la_utility::init_flags();
	setup_objectives();
	setup_skiptos();
	precache_everything();
		
	maps\_load::main();

	maps\la_2_amb::main();
	maps\la_2_anim::main();	
	la_drones_setup();
	level thread maps\_lockonmissileturret::init(undefined, maps\_lockonmissileturret::GetBestMissileTurretTarget_f38);
	level thread maps\_heatseekingmissile::init();	
	level thread level_start();  
	level thread setup_challenges();
	level thread maps\_objectives::objectives();
	level thread maps\la_2_convoy::main();  // setup friendly convoy 
	level thread maps\la_2_player_f35::main();  // setup f35 
	level thread global_funcs();
	level thread la_2_objectives();  // sequential function for objective handling
	level thread setup_destructibles();  
	level thread maps\la_2_drones_ambient::main();
	animscripts\assign_weapon::assign_weapon_allow_random_weapons( true );
	SetNorthYaw( 90 ); // match game compass to radiant
	
	//Shawn J - Sound
	setsaveddvar ("vehicle_sounds_cutoff", 30000);
	
	/#
	level thread maps\la_2_debug::main();	
	#/
}

global_funcs()
{
	wait_for_first_player();
	
	level.PERSISTENT_FIRES_MAX = 31;  // temp value - 7/21/2011 TravisJ	
	
	setup_spawn_functions();
	spawn_manager_set_global_active_count( 24 );
	
	// global vehicle spawn functions
	add_spawn_function_veh_by_type( "drone_pegasus_fast_la2", maps\_pegasus::update_objective_model );
	add_spawn_function_veh_by_type( "drone_avenger_fast_la2", maps\_avenger::update_objective_model );		
	add_spawn_function_veh_by_type( "drone_pegasus_fast_la2", ::spawn_plane_fx_on_death );
	add_spawn_function_veh_by_type( "drone_avenger_fast_la2", ::spawn_plane_fx_on_death );
	add_spawn_function_veh_by_type( "plane_f35_fast_la2", ::spawn_plane_fx_on_death );
	add_spawn_function_veh_by_type( "plane_f35_fast_la2", ::f35_hide_landing_gear );
	add_spawn_function_veh_by_type( "drone_pegasus_fast_la2", ::plane_midair_deathfx );
	add_spawn_function_veh_by_type( "drone_avenger_fast_la2", ::plane_midair_deathfx );		
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::ground_vehicle_fires_at_player );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::add_missile_turret_target );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::pickup_add_occupants );
	add_spawn_function_veh_by_type( "civ_van_sprinter_la2", ::add_ground_vehicle_damage_callback );	
	add_spawn_function_veh_by_type( "civ_van_sprinter_la2", maps\la_2_ground::stop_at_spline_end );	
	add_spawn_function_veh_by_type( "civ_van_sprinter_la2", ::add_missile_turret_target );	
	add_spawn_function_veh_by_type( "heli_pavelow_la2", ::add_ground_vehicle_damage_callback );	
	add_spawn_function_veh_by_type( "heli_pavelow_la2", ::add_missile_turret_target );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::add_missile_turret_target );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::bigrig_add_trailer );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::bigrig_spawn_claw );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::bigrig_death_fx );
	add_spawn_function_veh_by_type( "civ_police", ::police_car_add_lights );
	
	if ( !IsDefined( level.green_zone_volume ) )
	{
		level.green_zone_volume = get_ent( "green_zone_volume", "targetname", true );
	}

	if ( !IsDefined( level.dogfights_volume ) )
	{
		level.dogfights_volume = get_ent( "dogfights_zone", "targetname", true );
	}	
	
	level.player SetClientDvar( "cg_aggressiveCullRadius", 2000 ); 
	
	level.player thread toggle_occluders();
	
	level thread convoy_trigger_setup();
	
	maps\_lockonmissileturret::DisableLockOn();
}

police_car_add_lights()
{
	play_fx( "siren_light", undefined, undefined, -1, true, "tag_fx_siren_lights" );	
}

spawn_plane_fx_on_death()
{
	self func_on_death( maps\la_2_drones_ambient::crash_landing_fx );
}

bigrig_death_fx()
{
	self waittill( "death" );

	PlayFXOnTag( level._effect[ "bigrig_death" ], self, "tag_origin" );
}

add_missile_turret_target()
{
	v_offset = ( 0, 0, 0 );
	
	if ( IS_VEHICLE( self ) )
	{
		if ( self.vehicletype == "civ_van_sprinter" )
		{
			v_offset = ( 0, 0, 60 );
		}
		else if ( self.vehicletype == "civ_bigrig_la2" )
		{
			v_offset = ( 0, 0, 80 );
		}
	}
	
	Target_Set( self, v_offset );
}

pickup_add_occupants()
{	
	str_driver_tag = "tag_driver";
	str_gunner_tag = "tag_gunner1";	
	
	ai_driver = simple_spawn_single( "pickup_guy" );
	wait_network_frame();
	ai_gunner = simple_spawn_single( "pickup_guy", ::pickup_disable_turret_on_gunner_death, self );
	
	ai_driver enter_vehicle( self, str_driver_tag );
	ai_gunner enter_vehicle( self, str_gunner_tag );        
}

pickup_disable_turret_on_gunner_death( vh_truck )
{
	self.overrideActorDamage = ::pickup_gunners_dont_take_cougar_damage;	
	
	self waittill( "death" );
	
	n_index = 1;
	
	if ( IsDefined( vh_truck ) )
	{
		vh_truck maps\_turret::disable_turret( n_index );
	}
}

pickup_gunners_dont_take_cougar_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( IsDefined( sWeapon ) && sWeapon == "cougar_gun_turret" )
	{
		iDamage = 1;
	}
	
	return iDamage;
}

convoy_trigger_setup()
{
	a_triggers = get_ent_array( "convoy_vehicle_trigger", "script_noteworthy", true );
	
	for ( i = 0; i < a_triggers.size; i++ )
	{
		a_triggers[ i ] thread convoy_trigger_proc();
	}
}

bigrig_add_trailer()
{
	self Attach( "veh_t6_civ_18wheeler_trailer" );
}

bigrig_spawn_claw()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	
	Assert( IsDefined( self.script_int ), "script_int is missing on bigrig at " + self.origin );
	
	if ( self.script_int == 1 )
	{
		simple_spawn( "bigrig_claw_spawners_1" );
	}
	else if ( self.script_int == 2 )
	{
		simple_spawn( "bigrig_claw_spawners_2" );
	}
	else if ( self.script_int == 3 )
	{
		simple_spawn( "bigrig_claw_spawners_3" );
	}	
}

// on convoy triggers: script_int = vehiclespawngroup. All vehicles should be connected to splines on this spawngroup.
convoy_trigger_proc()  // self = trigger
{
	self maps\la_2_convoy::_waittill_triggered_by_convoy();
	//iprintlnbold( "trigger hit" );	
	
}

f35_hide_landing_gear()
{
	self HidePart( "tag_gear" );
}

plane_midair_deathfx()
{
	self waittill( "death" );
	
	if ( flag( "convoy_at_dogfight" ) && !flag( "dogfight_done" ) )
	{
		if ( IsDefined( self ) && IsDefined( self.origin ) && IsDefined( self.angles ) )
		{
			PlayFx( level._effect[ "plane_deathfx_huge" ], self.origin, AnglesToForward( self.angles ) );
		}
	}
}

toggle_occluders()
{
	level endon( "death" );
	
	wait_for_first_player();
	
	e_occluders_on = level.green_zone_volume;  // when player is inside this volume, occluders should be on
	
	flag_wait( "convoy_at_dogfight" );
	
	while( true )
	{ 
		b_is_in_volume = self IsTouching( e_occluders_on );
		
		if ( b_is_in_volume )
		{
			n_value = 1;  // turn occluders on
		}
		else 
		{
			n_value = 0;  // turn occluders off
		}
		
		EnableOccluder( "", n_value );  // an empty string will find all unnamed occluders in the map. Note you name these with 'name', not 'targetname's
		wait 0.5;
	}
}

setup_challenges()
{
	wait_for_first_player();
	
	// nodeath - complete the level ( la_1 and la_2 ) without dying
	level.player thread maps\_challenges_sp::register_challenge( "nodeath", ::challenge_nodeath );
	
	// save all three G20 convoy vehicles
	level.player thread maps\_challenges_sp::register_challenge( "savecougars", ::challenge_savecougars );
	
	// trenchruns_no_missiles - defeat all the kamikaze planes without using missiles
	level.player thread maps\_challenges_sp::register_challenge( "trenchruns_no_missiles", ::challenge_trenchruns_no_missiles );
	 
	// save_F35s - save X F35s being attacked by UAVs
	level.player thread maps\_challenges_sp::register_challenge( "save_f35s", ::challenge_save_f35s );
}

precache_everything()
{
	// weapons
	PrecacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "f35_death_blossom" );
	PrecacheItem( "pegasus_missile_turret_doublesize" );
	PrecacheItem( "uzi_sp" );  // axis drone weapon
	PrecacheItem( "ksg_sp" );  // LAPD drone weapon
	PrecacheItem( "molotov_sp" );
	
	// models
	PrecacheModel( "test_ui_hud_visor" );
	PrecacheModel( "veh_t6_mil_cougar_interior" );
	PrecacheModel( "veh_t6_civ_18wheeler_trailer" );
	
	// rumbles
	PrecacheRumble( "tank_damage_light_mp" );
	PrecacheRumble( "tank_damage_heavy_mp" );
	
	// strings
	PrecacheString( &"hud_missile_incoming" );
	PrecacheString( &"hud_missile_incoming_dist" );	
	PrecacheString( &"hud_damage" );
	PrecacheString( &"hud_weapon_heat" );
	PrecacheString( &"hud_update_vehicle" );
	
	// shader
	PrecacheShader( "compass_static" );
}

la_drones_setup()
{
	maps\_drones::init();
	maps\_drones::drones_set_max( 100 );
	maps\_drones::drones_set_muzzleflash( level._effect[ "drone_muzzle_flash" ] );
	
	// assign LAPD model to allies across the whole map
	drones_assign_global_spawner( "allies", "lapd_drone_guy" );
	drones_assign_global_spawner( "axis", "axis_drone_spawner_guy" );
	
	// assign weapons to axis
	if ( !IsDefined( level.drone_weaponlist_axis ) )
	{
		level.drone_weaponlist_axis = [];
	}
	level.drone_weaponlist_axis[ level.drone_weaponlist_axis.size ] = "uzi_sp";
	
	// assign weapons to allies
	if ( !IsDefined( level.drone_weaponlist_allies ) )
	{
		level.drone_weaponlist_allies = [];
	}
	level.drone_weaponlist_allies[ level.drone_weaponlist_allies.size ] = "ksg_sp";
	
	// vary drone runspeeds
	maps\_drones::drones_speed_modifier( "warehouse_st_left_turn_drones_allies", -0.2, 0.2  );
	maps\_drones::drones_speed_modifier( "warehouse_st_left_turn_drones_axis", -0.2, 0.2  );
	maps\_drones::drones_speed_modifier( "warehouse_st_right_blockade", -0.2, 0.4  );
	maps\_drones::drones_speed_modifier( "warehouse_st_distant_runners", -0.2, 0.2  );
	maps\_drones::drones_speed_modifier( "warehouse_st_blockade_lapd", -0.2, 0.2  );	
	
	maps\_drones::drones_add_custom_func( "throw_molotov", ::drone_throws_molotov );
}

drone_throws_molotov( s_start, v_destination, params )
{
	self delay_thread( 1.4, ::_drone_throws_molotov_proc );  // function is blocking in _drones.gsc, so thread
}

_drone_throws_molotov_proc()
{
	if ( IsDefined( self ) )
	{
		v_start = self GetTagOrigin( "tag_weapon" );  //
		v_end = self.origin + AnglesToForward( self.angles ) * 1000;
			
		self molotov_throw( undefined, v_start, v_end );
	}	
}

drones_assign_global_spawner( str_side, str_spawner_targetname )
{
	if ( str_side == "allies" )
	{
		str_targetname = "drone_allies";
	}
	else 
	{
		str_targetname = "drone_axis";
	}
	
	a_drone_spawners = get_ent_array( str_targetname, "targetname", true );
	sp_drone_model = get_ent( str_spawner_targetname, "targetname", true );
	
	for ( i = 0; i < a_drone_spawners.size; i++ )
	{
		maps\_drones::drones_assign_spawner( a_drone_spawners[ i ].script_string, sp_drone_model );
	}
}

// place to put temp starting conditions while level is in development
level_start()
{	
	wait_for_first_player();	
	
	// DEBUG: if we're not coming from la_1, save all G20 vehicles and Anderson
	if ( ( GetDvar( "la_1_ending_position" ) != "1" ) )
	{
		println( "LA_1 ENDING POSITION NOT FOUND. USING DEFAULT LEVEL START CONDITIONS!" );
		flag_set( "F35_pilot_saved" );
		flag_set( "G20_1_saved" );
		flag_set( "G20_2_saved" );
	}	
	
	// anderson
	if( IsDefined( GetDvar( "la_F35_pilot_saved" ) ) && ( GetDvar( "la_F35_pilot_saved" ) == "1" ) )
	{
		flag_set( "F35_pilot_saved" );
	}
	
	// g20_1 - g20_1_saved
	if( IsDefined( GetDvar( "la_G20_1_saved" ) ) && ( GetDvar( "la_G20_1_saved" ) == "1" ) )
	{
		flag_set( "G20_1_saved" );
	}	
	
	// g20_2 - g20_2_saved
	if( IsDefined( GetDvar( "la_G20_2_saved" ) ) && ( GetDvar( "la_G20_2_saved" ) == "1" ) )
	{
		flag_set( "G20_2_saved" );
	}		
	
	println( "Anderson saved: " + flag( "F35_pilot_saved" ) );
	println( "G20_1 saved: " + flag( "G20_1_saved" ) );
	println( "G20_2 saved: " + flag( "G20_2_saved" ) );
	
	flag_set( "la_transition_setup_done" );
}

/*=============================================================================
SKIPTO SECTION
=============================================================================*/
setup_skiptos()
{
	str_default_skipto = "f35_wakeup";
	
	if ( is_greenlight_build() )
	{
		str_default_skipto = "f35_pacing";
	}
	
	default_skipto( str_default_skipto ); // f35_wakeup normal / "f35_pacing" GL
	
	add_skipto( "intro",			::skipto_la_1 );
	add_skipto( "after_the_attack",	::skipto_la_1 );
	add_skipto( "sam",				::skipto_la_1 );
	add_skipto( "cougar_fall",		::skipto_la_1 );
	add_skipto( "sniper_rappel",	::skipto_la_1 );
	add_skipto( "low_road",			::skipto_la_1 );
	add_skipto( "g20_group1",		::skipto_la_1 );
	add_skipto( "drive",			::skipto_la_1 );
	add_skipto( "skyline",			::skipto_la_1 );
	add_skipto( "street",			::skipto_la_1b );
	add_skipto( "plaza",			::skipto_la_1b );
	add_skipto( "intersection",		::skipto_la_1b );
	add_skipto( "arena",			::skipto_la_1b );
	add_skipto( "arena_exit",		::skipto_la_1b );
	
	// section 3 - flyable f35
	add_skipto( "f35_wakeup",	maps\la_2::skipto_f35_wakeup, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_wakeup );
	
	// boarding animation for F35
	add_skipto( "f35_boarding",	maps\la_2::skipto_f35_boarding, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_boarding );
	
	// F35 tutorial/flying
	add_skipto( "f35_flying", maps\la_2::skipto_f35_flying, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_flight_start );
	
	// ground targets engagement
	add_skipto( "f35_ground_targets", maps\la_2::skipto_f35_ground_targets, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_ground_targets );
	
	// pacing section 
	add_skipto( "f35_pacing", maps\la_2::skipto_f35_pacing, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_pacing );
	
	// rooftops engagement
	add_skipto( "f35_rooftops", maps\la_2::skipto_f35_rooftops, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_rooftops );
	
	// UAV dogfight
	add_skipto( "f35_dogfights", maps\la_2::skipto_f35_dogfights, &"SKIPTO_STRING_HERE", maps\la_2_fly::f35_dogfights );
	
	// UAV trenchrun
	add_skipto( "f35_trenchrun", maps\la_2::skipto_f35_trenchrun, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_trenchrun );
	
	// hotel fight
	add_skipto( "f35_hotel", maps\la_2::skipto_f35_hotel, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_hotel );
	
	// eject sequence
	add_skipto( "f35_eject", maps\la_2::skipto_f35_eject, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_eject );
	
	// outro anim (post blackout)
	add_skipto( "f35_outro", maps\la_2::skipto_f35_outro, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_outro );
	
	// dev only skipto for art/build test
	add_skipto( "dev_build_test", maps\la_2::skipto_dev_build_test, &"SKIPTO_STRING_HERE" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );

}

// TODO: sequential objectives in one function?
la_2_objectives()
{
	wait_for_first_player();
	
	flag_wait( "player_awake" );
	
	// Get in the F35
	t_f35_bump_trigger = get_ent( "f35_bump_trigger", "targetname", true );
	maps\_objectives::set_objective( level.OBJ_FLY, t_f35_bump_trigger, "use" );  
	level thread objective_f35_hint();
	
	flag_wait( "player_in_f35" );
	
	maps\_objectives::set_objective( level.OBJ_FLY, level.f35, "done" );
	
	flag_wait( "player_flying" );
	maps\_objectives::set_objective( level.OBJ_FOLLOW_VAN, level.convoy.vh_van, "follow" );
	
	flag_wait( "convoy_movement_started" );
	
	maps\_objectives::set_objective( level.OBJ_FOLLOW_VAN, undefined, "delete" );
	
	// Protect the Presidents vehicle	
	maps\_objectives::set_objective( level.OBJ_PROTECT, level.convoy.vh_potus, "protect" );		
	
	flag_wait( "convoy_at_ground_targets" );
	wait 0.5;
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, undefined, undefined, level.ground_attack_targets );
	
	flag_wait( "ground_targets_done" );
	//flag_wait( "ground_attack_vehicles_dead" );  // temp - replace with hud element for F35
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, undefined, "delete" );
	
	flag_wait( "convoy_at_dogfight" );
	maps\_objectives::set_objective( level.OBJ_PROTECT, undefined, "remove" );
	
	flag_wait( "dogfight_done" );
	maps\_objectives::set_objective( level.OBJ_PROTECT, level.convoy.vh_potus, "protect" );
	
	flag_wait( "eject_done" );
	
	maps\_objectives::set_objective( level.OBJ_PROTECT, undefined, "done" );
}

objective_f35_hint()
{
	level endon( "player_flying" );
	
	wait 30; 
	
	// set 3d objective indicator on f35
}

skipto_la_1()
{
	/#
		AddDebugCommand( "devmap la_1" );
	#/
}

skipto_la_1b()
{
	/#
		AddDebugCommand( "devmap la_1b" );
	#/
}

f35_move_to_position( str_struct_name )
{
	Assert( IsDefined( str_struct_name ), "str_struct_name is a required parameter for f35_move_to_struct" );
	
	s_f35_position = get_struct( str_struct_name, "targetname", true );
	
	level.f35.origin = s_f35_position.origin;
	
	if ( IsDefined( s_f35_position.angles ) )
	{
		level.f35 SetPhysAngles( s_f35_position.angles );
	}

	maps\la_2_player_f35::player_boards_f35();	
}

convoy_move_to_position( str_struct_names )
{
	Assert( IsDefined( str_struct_names ), "str_struct_names is a required parameter for convoy_move_to_position" );
	Assert( IsDefined( level.convoy.vehicles ), "level.convoy.vehicles is missing in convoy_move_to_position" );
	
	a_vehicles = level.convoy.vehicles;
	vh_van = level.convoy.vh_van;
	a_vehicles[ a_vehicles.size ] = vh_van;
	a_structs = get_struct_array( str_struct_names, "targetname", true );
	
	Assert( ( a_structs.size >= a_vehicles.size ), "missing structs for convoy_move_to_position. Have " + a_structs.size + ", need " + level.convoy.vehicles.size );
	
	for ( i = 0; i < a_vehicles.size; i++ )
	{
		b_found_struct = false;
		
		for ( j = 0; j < a_structs.size; j++ )
		{
			Assert( IsDefined( a_structs[ j ].target ), "convoy_move_to_position struct is missing target at " + a_structs[ j ].origin );
			
			if ( a_vehicles[ i ].script_int == a_structs[ j ].script_int )
			{
				vh_temp = a_vehicles[ i ];
				s_temp = a_structs[ j ];
				nd_temp = GetVehicleNode( s_temp.target, "targetname" );
				
				println( vh_temp.targetname + "moving to struct " + s_temp.targetname + " at " + s_temp.origin + "\n" );
				
				b_found_struct = true;
				vh_temp CancelAIMove();
				wait 0.05;
				vh_temp.origin = s_temp.origin; 
				vh_temp AttachPath( nd_temp );
				
				if ( IsDefined( s_temp.angles ) )
				{
					vh_temp SetPhysAngles( s_temp.angles );
				}
				
				if ( vh_temp == vh_van )
				{
					vh_temp thread maps\la_2_convoy::convoy_vehicle_think_van( nd_temp );
				}
				else
				{
					vh_temp thread maps\la_2_convoy::convoy_vehicle_think( nd_temp );
				}
			}
		}
		
		Assert( b_found_struct, a_vehicles[ i ].targetname + " is missing struct for " + str_struct_names + ". Script_int = " + a_vehicles[ i ].script_int );
	}
}

skipto_f35_wakeup()
{
}

skipto_f35_boarding()
{
	start_teleport( "f35_boarding_skipto" );
	maps\_scene::run_scene_first_frame( "F35_startup_vehicle" );
	maps\createart\la_2_art::fog_intro();  // 'level start' fog settings
}

skipto_f35_flying()
{	
	f35_move_to_position( "skipto_f35_flying_struct" );
}

skipto_f35_ground_targets()
{
	f35_move_to_position( "skipto_f35_ground_targets_struct" );
	convoy_move_to_position( "skipto_convoy_ground_targets" );
}

skipto_f35_pacing()
{
	_skipto_turn_off_roadblock_triggers();
	
	f35_move_to_position( "skipto_f35_pacing_struct" );
	convoy_move_to_position( "skipto_convoy_roadblock_struct" );
	
	if ( is_greenlight_build() )
	{
		level thread convoy_waits_for_player_input();
	}	
}

skipto_f35_rooftops()
{
	_skipto_turn_off_roadblock_triggers();
	f35_move_to_position( "skipto_f35_rooftops_struct" );  // skipto_f35_rooftops_struct
	convoy_move_to_position( "skipto_convoy_rooftops_struct" );  // skipto_convoy_rooftops_struct
}

convoy_waits_for_player_input()
{
	array_notify( level.convoy.vehicles, "convoy_stop" );
	flag_clear( "convoy_can_move" );	
	
	const n_using_thumbstick = 0.1;
	
	b_player_moving = false;
	wait 1;	

	while ( !b_player_moving )
	{
		if ( Length( level.player GetNormalizedMovement() ) > n_using_thumbstick )
		{
			b_player_moving = true;
		}
		
		wait 0.05;
	}
	
	flag_set( "convoy_can_move" );
	
	wait 0.5;  // SetSpeed will be called from general convoy movement functions; make sure this is done before setting speed
	
	foreach( vehicle in level.convoy.vehicles )
	{
		vehicle SetSpeed( 30 );
	}
}

skipto_f35_dogfights()
{
	f35_move_to_position( "skipto_f35_dogfight_struct" );
	convoy_move_to_position( "skipto_convoy_dogfights_struct" );
	
	_skipto_turn_off_roadblock_triggers();
}

_skipto_turn_off_roadblock_triggers()
{	
	t_stop = get_ent( "convoy_tutorial_stop_trigger", "targetname", true );
	t_stop trigger_off();		
}

skipto_f35_trenchrun()
{
	f35_move_to_position( "skipto_f35_trenchrun_struct" );
	convoy_move_to_position( "skipto_convoy_trenchruns_struct" );
	
	for ( i = 0; i < level.convoy.vehicles.size; i++ )
	{
		level.convoy.vehicles[ i ] SetSpeed( 30 );  // gets set on nodes around building collapse during normal playthrough
	}
}

skipto_f35_hotel()
{
	f35_move_to_position( "skipto_f35_hotel_struct" );
	convoy_move_to_position( "skipto_convoy_hotel_struct" );	
}

skipto_f35_eject()
{
	f35_move_to_position( "skipto_f35_eject_struct" );
	convoy_move_to_position( "skipto_convoy_hotel_struct" );	
	flag_set( "hotel_done" );
	
	level.player notify( "turretownerchange" );
}

skipto_f35_outro()
{
	flag_set( "eject_done" );
	//convoy_move_to_position( "skipto_convoy_hotel_struct" );	
}

skipto_dev_build_test()
{
	wait 2;
	level.player SetClientDvar( "cg_fov", 65 );
	level.player hide_hud();
	maps\createart\la_2_art::art_jet_mode_settings();		
}


/*===========================================
Challenges
===========================================*/
challenge_savecougars( str_notify )  // self = player
{
	flag_wait( "eject_done" );
	
	a_temp = level.convoy.vehicles;
	
	for ( i = 0; i < a_temp.size; i++ )
	{
		self notify( str_notify );
		wait 0.05;
	}
}


challenge_trenchruns_no_missiles( str_notify )
{
	flag_wait( "eject_done" );

	Assert( IsDefined( level.trenchruns_struct ), "level.trenchruns_struct is missing for challenge_trenchruns_no_missiles!" );

	if ( level.trenchruns_struct.missile_deaths == 0 )
	{
		self notify( str_notify );
	}
}

challenge_save_f35s( str_notify )
{
	while ( true )
	{
		level waittill( "player_saved_tracked_friendly_f35" );
		
		self notify( str_notify );
	}
}

challenge_nodeath( str_notify )
{
	flag_wait( "eject_done" );
	
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
}
