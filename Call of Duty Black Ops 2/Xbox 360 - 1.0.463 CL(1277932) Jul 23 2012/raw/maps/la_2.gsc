/*
la_2.gsc - sets up global functions and skiptos
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_glasses;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

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
	level thread maps\_lockonmissileturret::init( undefined, ::GetBestMissileTurretTarget_f38 );
	level thread maps\_heatseekingmissile::init();	
	level thread level_start();  
	level thread maps\_objectives::objectives();
	level thread maps\la_2_convoy::main();  // setup friendly convoy 
	level thread maps\la_2_player_f35::main();  // setup f35 
	level thread global_funcs();
	level thread la_2_objectives();  // sequential function for objective handling
	level thread setup_destructibles();  
	level thread maps\la_2_drones_ambient::main();
	animscripts\assign_weapon::assign_weapon_allow_random_weapons( true );
	SetNorthYaw( 90 ); // match game compass to radiant
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	//Shawn J - Sound
	setsaveddvar ("vehicle_sounds_cutoff", 30000);
	
	level thread temp_disable_hud_damage();
	
	/#
	level thread maps\la_2_debug::main();	
	#/
}

on_player_connect()
{
	level thread setup_story_states(); 
}

temp_disable_hud_damage()
{
	flag_wait( "all_players_connected" );
	wait 1;
	while ( true )
	{
		while ( GetDvarint( "fa38_disable_hud_damage" ) != 1 )
		{
			wait 0.05;	
		}
		level clientnotify( "temp_disable_hud_damage" );	
		
		if ( IsDefined( level.player.e_temp_fx ) )
		{
			level.player.e_temp_fx Unlink();
			level.player.e_temp_fx Delete();
		}		
		
		while ( GetDvarint( "fa38_disable_hud_damage" ) == 1 )
		{
			wait 0.05;	
		}	
		level clientnotify( "temp_enable_hud_damage" );
	}
}

global_funcs()
{
	wait_for_first_player();
	
	level.missile_lock_on_range = 15000;
	
	level.PERSISTENT_FIRES_MAX = 31;  // temp value - 7/21/2011 TravisJ	
	
	setup_spawn_functions();
	spawn_manager_set_global_active_count( 24 );
	
	// global vehicle spawn functions
	add_spawn_function_veh_by_type( "drone_pegasus_fast_la2_2x", maps\_pegasus::update_objective_model );
	add_spawn_function_veh_by_type( "drone_avenger_fast_la2_2x", maps\_avenger::update_objective_model );
	add_spawn_function_veh_by_type( "drone_pegasus_fast_la2_2x", maps\_pegasus::update_damage_states );	
	add_spawn_function_veh_by_type( "drone_avenger_fast_la2_2x", maps\_avenger::update_damage_states );
	add_spawn_function_veh_by_type( "drone_pegasus_fast_la2_2x", ::spawn_plane_fx_on_death );
	add_spawn_function_veh_by_type( "drone_avenger_fast_la2_2x", ::spawn_plane_fx_on_death );
	add_spawn_function_veh_by_type( "plane_f35_fast_la2", ::spawn_plane_fx_on_death );
//	add_spawn_function_veh_by_type( "plane_f35_fast_la2", ::f35_hide_landing_gear );
	add_spawn_function_veh_by_type( "drone_pegasus_fast_la2_2x", ::plane_midair_deathfx );
	add_spawn_function_veh_by_type( "drone_avenger_fast_la2_2x", ::plane_midair_deathfx );		
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::ground_vehicle_fires_at_player );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::add_missile_turret_target );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::blow_up_vehicle_at_spline_end );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::delay_free_vehicle );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::prevent_riders_from_unloading );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::add_vehicle_to_convoy_target_pool );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::clean_up_vehicle_at_air_to_air );
	add_spawn_function_veh_by_type( "civ_van_sprinter_la2", ::add_ground_vehicle_damage_callback );	
	add_spawn_function_veh_by_type( "civ_van_sprinter_la2", maps\la_2_ground::stop_at_spline_end );	
	add_spawn_function_veh_by_type( "civ_van_sprinter_la2", ::add_missile_turret_target );	
	add_spawn_function_veh_by_type( "heli_pavelow_la2", ::add_ground_vehicle_damage_callback );	
	add_spawn_function_veh_by_type( "heli_pavelow_la2", ::add_missile_turret_target );
	add_spawn_function_veh_by_type( "heli_pavelow_la2", ::helicopter_fires_at_player );
	add_spawn_function_veh_by_type( "heli_pavelow_la2", ::hover_at_spline_end );
	add_spawn_function_veh_by_type( "heli_pavelow_la2", ::func_on_death, ::pavelow_tailor_rotor_fire_on_death );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::add_missile_turret_target );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::bigrig_add_trailer );
	//add_spawn_function_veh_by_type( "civ_bigrig_la2", ::bigrig_spawn_claw );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::bigrig_death_fx );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::blow_up_vehicle_at_spline_end );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::add_ground_vehicle_damage_callback );
	add_spawn_function_veh_by_type( "civ_bigrig_la2", ::clean_up_vehicle_at_air_to_air );
	add_spawn_function_veh_by_type( "civ_police_la2", ::police_car_cheap );
	add_spawn_function_veh_by_type( "civ_police_la2", ::delay_free_vehicle );
	add_spawn_function_veh_by_type( "civ_police_la2", ::add_ground_vehicle_damage_callback );
	
	// AI in police cars
	sp_police_car_rider = get_ent( "lapd_in_car", "targetname", true );
	a_police_ground_ents = get_ent_array( "lapd_drone_target_origins", "targetname", true );
	sp_police_car_rider add_spawn_function( ::find_target_after_getout, a_police_ground_ents );
	add_spawn_function_veh_by_type( "civ_police", ::police_car_add_occupants, sp_police_car_rider );	
	
	// AI in red pickups
	//sp_red_truck_guys = get_ent( "pickup_guy", "targetname", true );
	//sp_red_truck_guys add_spawn_function( ::find_target_after_getout );	
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret_la2", ::pickup_add_occupants );
	
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

delay_free_vehicle()
{
	self.dontfreeme = true;
	
	self waittill( "death" );
	
	wait 10;
	
	if ( IsDefined ( self ) )
	{
		self.dontfreeme = undefined;
	}
}

pavelow_tailor_rotor_fire_on_death()
{
	PlayFXOnTag( level._effect[ "pavelow_tail_rotor_fire" ], self, "tag_origin" );
}

blow_up_vehicle_at_spline_end()
{
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "blow_up_at_spline_end" ) )
	{
		self endon( "death" );
		
		self waittill( "reached_end_node" );
		
		self do_vehicle_damage( self.health + 100, level.convoy.vh_potus, "explosive" );
	}
}

clean_up_vehicle_at_air_to_air()
{
	self endon ( "death" );
	
	level waittill ( "start_dogfight_event" );
	
	VEHICLE_DELETE( self );
}

police_car_add_occupants( sp_rider )
{
	if ( IsDefined( self.script_string ) && ( self.script_string == "no_riders" ) ) 
	{
		return;
	}

	self endon( "death" );
	
	if ( !IsDefined( sp_rider.currently_spawning ) )
	{
		sp_rider.currently_spawning = false;
	}
	
	while ( sp_rider.currently_spawning )
	{
		wait RandomFloatRange( 0.05, 0.25 );
	}
	
	sp_rider.currently_spawning = true;
	ai_rider = simple_spawn_single( sp_rider );
	sp_rider.currently_spawning = false;
	
	ai_rider enter_vehicle( self );
}

prevent_riders_from_unloading()
{
	self.dontunloadonend = true;
}

add_vehicle_to_convoy_target_pool()
{
	//TODO - setup convoy target pool
	
	//add enemy vehicle to array
	
	//pass array into _init_cougar_turret( str_type ) for each convoy vehicle
	
}

find_target_after_getout( a_target_ents )
{
	self endon( "death" );
	
	const n_max_cover_distance = 2048;
	const n_lifetime_min = 3;
	const n_lifetime_max = 8;
	
	self waittill( "jumpedout" );  // waittill vehicle getout animations are done
	
	a_cover = GetCoverNodeArray( self.origin, n_max_cover_distance );
	//Assert( ( a_cover.size > 0 ), self.targetname + " found no cover nodes within " + n_max_cover_distance + " units of " + self.origin + "!" );
	if ( a_cover.size == 0 )
		return;
	
	self.goalradius = 32;
	
	b_found_node = false;
	
	while ( !b_found_node )
	{
		nd_best = GetClosest( self.origin, a_cover );
		
		if ( !IsNodeOccupied( nd_best ) && ( IsDefined(nd_best.script_string) && nd_best.script_string == self.team ) )
		{
			b_found_node = true;
		}
		else 
		{
			ArrayRemoveValue( a_cover, nd_best );
			wait 0.05;
		}
	}
	
	self SetGoalNode( nd_best );
	
	self delay_thread( RandomFloatRange( n_lifetime_min, n_lifetime_max ), ::bloody_death );
	
	if ( IsDefined( a_target_ents ) )
	{
		self shoot_at_target( random( a_target_ents ), undefined, 0, -1 );
	}
}

hover_at_spline_end()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	
	self SetHoverParams( 500 );
}

police_car_cheap()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	self play_fx( "siren_light", undefined, undefined, -1, true, "tag_origin" );	
	
	// TODO: uncomment once destroyed models are set up properly
	self waittill( "reached_end_node" );
	
	wait 5;

	if ( !IsDefined( self.is_ambient_turret_target ) )
	{
		// spawn in a destructible version of the same vehicle since it will never move again	
		m_cheap_car = Spawn( "script_model", self.origin, 0, undefined, undefined, "veh_t6_police_car_destructible_sp_low" );
		m_cheap_car.angles = self.angles;
		
		wait 0.05;
		m_cheap_car play_fx( "siren_light", undefined, undefined, -1, true, "tag_origin" );	
		
		self Delete();
	}
}

helicopter_fires_at_player()
{
	self endon( "death" );
	
	const HELI_TURRET_INDEX = 0;
	
	maps\_turret::shoot_turret_at_target( level.player, -1, ( 0, 0, 0 ), HELI_TURRET_INDEX );
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
	if ( IsDefined( self.script_string ) && ( self.script_string == "no_riders" ) ) 
	{
		return;
	}	
	
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
		vh_truck notify( "gunner_dead" );
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
	// bigrigs with sharp turns lack trailers since they don't follow correctly without animation
	if ( IsDefined( self.script_string ) && ( self.script_string == "no_trailer" ) )
	{
		return;
	}
	
	self.trailer_model = Spawn( "script_model", self.origin );
	self.trailer_model.angles = self.angles;
	self.trailer_model LinkTo( self );
	
	self.trailer_model SetModel( "veh_t6_civ_18wheeler_trailer" );
	
	// script_int is defined on bigrigs that drop off CLAWs. use full model due to animation alignment
	if ( IsDefined( self.script_int ) )
	{
		self.model_old = self.model;
		self SetModel( "veh_t6_civ_18wheeler" );
		self.trailer_model Hide();
	}
	
	self waittill( "death" );
	self.trailer_model Show();
	self.trailer_model SetModel( "veh_t6_civ_18wheeler_trailer_dead" );
	
	if ( IsDefined( self.model_old ) )
	{
		self SetModel( self.model_old );
	}
}

#using_animtree( "vehicles" );
_play_bigrig_trailer_anim()
{
//	self thread maps\_anim::anim_single( self, "bigrig_trailer_2claw_exit", "bigrig" );
}

// trigger targets a second trigger with vehicle spawngroups, vehicle_startmove KVPs; trigger 1 waits for convoy, trigger 2 actually spawns/moves vehicles
convoy_trigger_proc()  // self = trigger
{
	Assert( IsDefined( self.target ), "target trigger missing for convoy_trigger_proc at origin " + self.origin );
	
	self maps\la_2_convoy::_waittill_triggered_by_convoy();
	
	t_vehicle_spawn = get_ent( self.target, "targetname", true );
	
	t_vehicle_spawn notify( "trigger" );
	
	wait 1;
	 
	self Delete();
	t_vehicle_spawn Delete();
}

plane_midair_deathfx()
{
	self waittill( "death" );
	
	if ( flag( "convoy_at_dogfight" ) && !flag( "dogfight_done" ) )
	{
		if ( IsDefined( self ) && IsDefined( self.origin ) && IsDefined( self.angles ) )
		{
			PlayFx( level._effect[ "plane_deathfx_small" ], self.origin, AnglesToForward( self.angles ) );
			//Play boom CDC
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

precache_everything()
{
	// weapons
	PrecacheItem( "usrpg_player_sp" );
	PrecacheItem( "usrpg_magic_bullet_sp" );
	PrecacheItem( "f35_death_blossom" );
	PrecacheItem( "pegasus_missile_turret_doublesize" );
	PrecacheItem( "m4_sp" );  // axis drone weapon
	PrecacheItem( "ksg_sp" );  // LAPD drone weapon
	PrecacheItem( "molotov_sp" );
	
	// models
	PrecacheModel( "test_ui_hud_visor" );
	PrecacheModel( "veh_t6_mil_cougar_interior" );
	PrecacheModel( "veh_t6_civ_18wheeler" );
	PrecacheModel( "veh_t6_civ_18wheeler_trailer" );
	PrecacheModel( "veh_t6_civ_18wheeler_trailer_dead" );
	PrecacheModel( "veh_t6_air_fa38_landing_gear" );
	PrecacheModel( "veh_t6_air_fa38_ladder" );
	PrecacheModel( "veh_t6_drone_avenger_x2" );
	PrecacheModel( "veh_t6_air_fa38_x2" );
	PrecacheModel( "veh_t6_mil_cougar_interior_attachment" );
	PrecacheModel( "veh_t6_mil_cougar_interior_shadow" );
	PrecacheModel( "veh_iw_civ_ambulance_int" );
	
	PrecacheModel( "p6_light_ad_03_crnr" );
	PrecacheModel( "p6_light_ad_05_crnr" );
	PrecacheModel( "p6_light_ad_07_crnr" );
	PrecacheModel( "p6_light_ad_09_crnr" );
	PrecacheModel( "p6_light_ad_10_crnr" );

	// rumbles
	PrecacheRumble( "tank_damage_light_mp" );
	PrecacheRumble( "tank_damage_heavy_mp" );
	
	// strings
	PrecacheString( &"hud_f35" );
	PrecacheString( &"hud_f35_death_blossom" );
	PrecacheString( &"hud_f35_end" );
	PrecacheString( &"hud_link_lost" );
	PrecacheString( &"hud_missile_incoming" );
	PrecacheString( &"hud_missile_incoming_dist" );	
	PrecacheString( &"hud_damage" );
	PrecacheString( &"hud_weapon_heat" );
	PrecacheString( &"hud_update_vehicle" );
//	PrecacheString( &"pip_convoy_1" );
//	PrecacheString( &"pip_convoy_2" );
	PrecacheString( &"la_pip_seq_1" );
	PrecacheString( &"la_pip_seq_3" );
	PrecacheString( &"la_pip_seq_4" );
	PrecacheString( &"la_pip_seq_5" );
	PrecacheString( &"la_pip_seq_6" );
	PrecacheString( &"la_pip_seq_7" );
	PrecacheString( &"la_pip_seq_8" );
//	PreCacheString( &"pip_hilary_3" );
//	PrecacheString( &"pip_hilary_4" );
}

la_drones_setup()
{
	maps\_drones::init();
	maps\_drones::drones_set_max( 100 );
	maps\_drones::drones_set_muzzleflash( level._effect[ "drone_muzzle_flash" ] );
	maps\_drones::drones_set_impact_effect( level._effect[ "drone_impact_fx" ] );
	
	// assign LAPD model to allies across the whole map
	drones_assign_global_spawner( "allies", "lapd_drone_guy" );
	drones_assign_global_spawner( "axis", "axis_drone_spawner_guy" );
	
	// assign weapons to axis
	level.drone_weaponlist_axis = array( "m4_sp" );
	
	// assign weapons to allies
	level.drone_weaponlist_allies = array( "ksg_sp" );
	
	// vary drone runspeeds generally 
	a_drone_triggers = get_ent_array( "drone_axis", "targetname" );
	a_drone_triggers_allies = get_ent_array( "drone_allies", "targetname" );
	
	a_drone_triggers = ArrayCombine( a_drone_triggers, a_drone_triggers_allies, true, false );
	
	foreach ( drone_trigger in a_drone_triggers )
	{
		maps\_drones::drones_speed_modifier( drone_trigger.script_string, -0.3, 0.3  );
	}
	
	// custom run speeds
	maps\_drones::drones_speed_modifier( "warehouse_st_right_blockade", -0.2, 0.4  );
	maps\_drones::drones_speed_modifier( "hotel_street_breakthrough_drones", 0.0, 0.4 );

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
	default_skipto( "f35_wakeup" );
	
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
	
	// section 3 - flyable f35
	add_skipto( "f35_wakeup",	maps\la_2::skipto_f35_wakeup, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_wakeup );
	
	// boarding animation for F35
	add_skipto( "f35_boarding",	maps\la_2::skipto_f35_boarding, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_boarding );
	
	// F35 tutorial/flying
	add_skipto( "f35_flying", maps\la_2::skipto_f35_flying, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_flight_start );
	
	// ground targets engagement
//	add_skipto( "f35_ground_targets", maps\la_2::skipto_f35_ground_targets, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_ground_targets );
	
	// pacing section 
	add_skipto( "f35_pacing", maps\la_2::skipto_f35_pacing, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_pacing );
	
	// rooftops engagement
	add_skipto( "f35_rooftops", maps\la_2::skipto_f35_rooftops, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_rooftops );
	
	// UAV dogfight
	add_skipto( "f35_dogfights", maps\la_2::skipto_f35_dogfights, &"SKIPTO_STRING_HERE", maps\la_2_fly::f35_dogfights );
	
	// UAV trenchrun
	//add_skipto( "f35_trenchrun", maps\la_2::skipto_f35_trenchrun, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_trenchrun );
	
	// hotel fight
	//add_skipto( "f35_hotel", maps\la_2::skipto_f35_hotel, &"SKIPTO_STRING_HERE", maps\la_2_ground::f35_hotel );
	
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
	
	flag_wait( "roadblock_done" );
	maps\_objectives::set_objective( level.OBJ_FOLLOW_VAN, undefined, "delete" );
	
	// Protect the Presidents vehicle	
	maps\_objectives::set_objective( level.OBJ_PROTECT, level.convoy.vh_potus, "protect" );		
	
//	flag_wait( "convoy_at_ground_targets" );
//	wait 0.5;
//	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, undefined, undefined, level.ground_attack_targets );
//	
//	flag_wait( "ground_targets_done" );
//	//flag_wait( "ground_attack_vehicles_dead" );  // temp - replace with hud element for F35
//	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, undefined, "delete" );
	
	flag_wait( "convoy_at_dogfight" );
	maps\_objectives::set_objective( level.OBJ_PROTECT, undefined, "remove" );
	
	flag_wait( "dogfight_done" );
//	maps\_objectives::set_objective( level.OBJ_PROTECT, level.convoy.vh_potus, "protect" );
	
	flag_wait( "eject_drone_spawned" );
	maps\_objectives::set_objective( level.OBJ_PROTECT, undefined, "remove" );
	
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
	ChangeLevel( "la_1", true );
}

skipto_la_1b()
{
	ChangeLevel( "la_1b", true );
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
	
	a_vehicles[ a_vehicles.size ] = vh_van;  // add van
	
	if ( !maps\_skipto::is_after_skipto( "f35_dogfights" ) && maps\_skipto::is_after_skipto( "f35_ground_targets" ) )
	{
		a_vehicles = ArrayCombine( a_vehicles, level.convoy.lapd_escort, true, false );
	}
	
	a_structs = get_struct_array( str_struct_names, "targetname", true );
	
	Assert( ( a_structs.size >= a_vehicles.size ), "missing structs for convoy_move_to_position. Have " + a_structs.size + ", need " + a_vehicles.size );
	
	for ( i = 0; i < a_vehicles.size; i++ )
	{
		b_found_struct = false;
		
		for ( j = 0; j < a_structs.size; j++ )
		{
			// Assert( IsDefined( a_structs[ j ].target ), "convoy_move_to_position struct is missing target at " + a_structs[ j ].origin );
			
			if ( a_vehicles[ i ].script_int == a_structs[ j ].script_int )
			{
				vh_temp = a_vehicles[ i ];
				s_temp = a_structs[ j ];
				
				println( vh_temp.targetname + "moving to struct " + s_temp.targetname + " at " + s_temp.origin + "\n" );
				
				b_found_struct = true;
				vh_temp CancelAIMove();
				wait 0.05;
				
				vh_temp.origin = s_temp.origin; 
				if ( IsDefined( s_temp.angles ) )
				{
					vh_temp.angles = s_temp.angles;
					vh_temp SetPhysAngles( s_temp.angles );
				}				

				if( IsDefined( s_temp.target ) )
				{				
					nd_temp = GetVehicleNode( s_temp.target, "targetname" );
				
					vh_temp AttachPath( nd_temp );
					
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
		}
		
		Assert( b_found_struct, a_vehicles[ i ].targetname + " is missing struct for " + str_struct_names + ". Script_int = " + a_vehicles[ i ].script_int );
	}
}

convoy_move_to_dogfight_position( str_structs_name )
{
	
}

skipto_f35_wakeup()
{
}

skipto_f35_boarding()
{
	skipto_teleport( "f35_boarding_skipto" );
	maps\_scene::run_scene_first_frame( "F35_startup_vehicle" );
	maps\createart\la_2_art::fog_intro();  // 'level start' fog settings
}

skipto_f35_flying()
{	
	f35_move_to_position( "skipto_f35_flying_struct" );
	
	maps\la_2_player_f35::f35_startup_console( undefined );		
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

	level thread maps\la_2_fly::_autosave_after_bink();
	
	if ( is_greenlight_build() )
	{
		maps\la_2_player_f35::f35_show_console( "tag_display_flight" );
		level thread convoy_waits_for_player_input();
	}	
}

skipto_f35_rooftops()
{
	_skipto_turn_off_roadblock_triggers();
	f35_move_to_position( "skipto_f35_rooftops_struct" );  // skipto_f35_rooftops_struct
	convoy_move_to_position( "skipto_convoy_rooftops_struct" );  // skipto_convoy_rooftops_struct
	
	maps\la_2_player_f35::f35_startup_console( undefined );	
}

convoy_waits_for_player_input()
{
	array_notify( level.convoy.vehicles, "convoy_stop" );
	wait 0.1;
	array_notify( level.convoy.lapd_escort, "convoy_stop" );

//	foreach( vehicle in level.convoy.lapd_escort )
//	{
//		vehicle SetSpeed( 0 );
//	}	
//	
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
	
	flag_wait( "pip_intro_done" );
	flag_set( "convoy_can_move" );
	
	wait 0.5;  // SetSpeed will be called from general convoy movement functions; make sure this is done before setting speed
	level thread maps\la_2_fly::_autosave_after_bink();
	
	foreach( vehicle in level.convoy.vehicles )
	{
		if ( is_alive( vehicle ) )
		{
			vehicle SetSpeed( 30 );
		}
	}
	
	foreach( vehicle in level.convoy.lapd_escort )
	{
		if ( is_alive( vehicle ) )
		{
			vehicle SetSpeed( 30 );
		}
	}		
}

skipto_f35_dogfights()
{
	f35_move_to_position( "skipto_f35_dogfight_struct" );
	convoy_move_to_position( "skipto_convoy_dogfights_struct" );
	
	level.f35 SetHeliHeightLock( false );
	
	level thread f35_hide_outer_model_parts( true, 0.25 );
	
	flag_set( "convoy_can_move" );
	flag_set( "dogfights_story_done" );
	flag_set( "player_flying" );
	delay_notify( "fxanim_bldg_convoy_block_start", 2 );  // start building collapse fxanim	
	_skipto_turn_off_roadblock_triggers();
	
	maps\la_2_player_f35::f35_startup_console( undefined );		
	
	//Hooking up music when using a checkpoint.
	setmusicstate ("LA_2_DOGFIGHT");
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
	convoy_move_to_position( "convoy_moveto_final_position" );	
}

skipto_f35_eject()
{
	maps\_lockonmissileturret::EnableLockOn();
	
	f35_move_to_position( "skipto_f35_eject_struct" );
	convoy_move_to_position( "convoy_moveto_eject_sequence" );	
	
	spawn_eject_friendly_follow_plane();
	wait 1;
	level.f35 thread _f35_set_vtol_mode_v2();
	
	flag_set( "hotel_done" );
	flag_set( "no_fail_from_distance" );
	
	maps\la_2_player_f35::f35_startup_console( undefined );		
	
	//level.player notify( "turretownerchange" );
}

skipto_f35_outro()
{
	flag_set( "no_fail_from_distance" );
	flag_set( "eject_done" );
	//convoy_move_to_position( "skipto_convoy_hotel_struct" );	
}

skipto_dev_build_test()
{
	wait 2;
	level.player SetClientDvar( "cg_fov", 65 );
//	level.player hide_hud();
	maps\createart\la_2_art::art_jet_mode_settings();		
}

GetBestMissileTurretTarget_f38()
{
	a_targets_all = target_getArray();
	a_targets_valid = [];

	// only get targets within lockon distance
	a_targets_all = get_array_of_closest( self.origin, a_targets_all, undefined, 10, level.missile_lock_on_range );

	// get all valid targets within lockon cone	
	for ( idx = 0; idx < a_targets_all.size; idx++ )
	{
		if( self InsideMissileTurretReticleNoLock( a_targets_all[ idx ] ) )//Free for all
		{
			a_targets_valid[ a_targets_valid.size ] = a_targets_all[ idx ];
		}
	}

	if ( a_targets_valid.size == 0 )
		return undefined;

	e_best_target = a_targets_valid[ 0 ];
	
	n_best_target_index = -1;
	best_distance = 99999;
	
	// find closest of targets in cone
	if ( a_targets_valid.size > 1 )
	{
		for ( i = 0; i < a_targets_valid.size; i++ )
		{
			n_dist_to_target = Distance( self.origin, a_targets_valid[ i ].origin );
			
			if ( n_dist_to_target < best_distance )
			{
				best_distance = n_dist_to_target;
				n_best_target_index = i;
			}
		}
	}
	
	if ( n_best_target_index > -1 )
		e_best_target = a_targets_valid[ n_best_target_index ];
	
	return e_best_target;
}
