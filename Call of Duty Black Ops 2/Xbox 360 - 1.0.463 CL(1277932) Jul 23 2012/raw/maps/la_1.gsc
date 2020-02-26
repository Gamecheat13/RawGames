/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	level.createfx_callback_thread = ::createfx_setup;
	
	// This MUST be first for CreateFX!	
	maps\la_1_fx::main();
	maps\la_1_anim::main();
	
	VisionSetNaked( "la_1" );
	
	CreateThreatBiasGroup( "potus" );
	CreateThreatBiasGroup( "potus_rushers" );
	
	level_precache();
	init_flags();
	setup_objectives();
	setup_skiptos();
	
	maps\_load::main();
	
	maps\_apc_cougar_ride::init();
		
	OnPlayerConnect_Callback( ::on_player_connect );
	
	level thread maps\createart\la_1_art::main();
	
	level.callbackVehicleDamage = ::la_1_vehicle_damage;
	level.vehicleSpawnCallbackThread = ::global_vehicle_spawn_func;
	
	maps\_lockonmissileturret::init( false, undefined, 6 );
	
	setup_spawn_funcs();
	
	init_vehicles();

	maps\la_1_amb::main();
		
	level thread maps\_objectives::objectives();
	
	//Shawn J - Sound
	SetSavedDvar( "vehicle_sounds_cutoff", 30000 );
        SetDvar( "footstep_sounds_cutoff", 3000 );
        // SetSavedDvar( "bg_chargeShotPenetrationMultiplier", 7.1 );

        battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	cleanup();
}

setup_spawn_funcs()
{
	add_spawn_function_veh_by_type( "drone_avenger_fast", maps\_avenger::update_objective_model );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret", ::veh_brake_unload );
	add_spawn_function_veh_by_type( "civ_pickup_red", ::veh_brake_unload );
	add_spawn_function_veh_by_type( "plane_fa38_hero", ::f35_vtol_spawn_func );
	add_spawn_function_veh_by_type( "civ_pickup_red", ::dont_free_vehicle );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret", ::dont_free_vehicle );
	add_spawn_function_veh_by_type( "civ_pickup_red_wturret", ::manage_vehicle_turret );
	
	add_spawn_function_veh( "flyby", ::spawn_func_scripted_flyby );
	add_spawn_function_veh( "flyby", ::play_a_word );
}

play_a_word()
{
	level.player playsound( "evt_fake_f35_flyby" );
	wait(.8);
	level.player playsound( "evt_fake_f35_flyby" );
}

on_player_connect()
{
	self thread sam_visionset();
		
	level_settings();
	
	waittillframeend;
	
	self player_flag_wait( "loadout_given" );	
	give_max_ammo_for_sniper_weapons();
}

level_settings()
{
	self SetClientDvar( "cg_tracerSpeed", 20000 ); // default is 7500
	SetSavedDvar( "vehicle_collision_prediction_time", 0.3 );
	
	level thread setup_story_states(); 
	//SetDvar( "bg_chargeShotPenetrationMultiplier", 30 ); //max is 30
}

level_precache()
{
	PrecacheModel( "veh_t6_mil_cougar_destroyed_low" );
	PrecacheModel( "veh_t6_mil_cougar_hood_obj" );
	PrecacheModel( "veh_t6_cougar_hatch_shadow" );
	PrecacheModel( "veh_t6_mil_cougar_door_obj" );
	PrecacheModel( "veh_t6_mil_cougar_interior_obj" );
	PrecacheModel( "veh_t6_air_blackhawk_stealth_dead" );
	PrecacheModel( "veh_t6_mil_cougar_interior" );
	PrecacheModel( "veh_t6_mil_cougar_interior_attachment" );
	PrecacheModel( "veh_t6_mil_cougar_interior_shadow" );
	PrecacheModel( "veh_t6_mil_cougar_interior_front" );	
	PrecacheModel( "fxanim_la_cougar_interior_static_mod" );
	PrecacheModel( "veh_t6_cougar_roof_decal" );
	PrecacheModel( "fxanim_gp_secret_serv_backpack_mod" );
	PrecacheModel( "fxanim_gp_secret_serv_gasmask_mod" );
	PrecacheModel( "p_jun_vc_ammo_crate" );
	PrecacheModel( "p_jun_vc_ammo_crate_open_single" );
	PrecacheModel( "c_usa_cia_masonjr_viewbody_vson" );
	PrecacheModel( "adrenaline_syringe_small_animated" );
	PrecacheModel( "jun_ammo_crate" );
	PrecacheModel( "com_ammo_pallet" );
	
	PrecacheItem( "usrpg_player_sp" );
	PrecacheItem( "usrpg_magic_bullet_sp" );
	PrecacheItem( "avenger_side_minigun_no_explosion" );
	PrecacheItem( "f35_missile_turret" );
	PrecacheItem( "type95_sp" );
	
	PrecacheTurret( "sam_turret_sp" );
	
	// ShellShock
	PrecacheShellshock( "la_1_crash_exit" );
	PrecacheShellshock( "khe_sanh_woods_verb" );
	PrecacheShellshock( "la1b_crash_exit" );

	PrecacheRumble( "la_1_fa38_intro_rumble" );
	PrecacheRumble( "flyby" );
	
	PrecacheModel( "veh_t6_drone_avenger_x2" );
}

setup_skiptos()
{
	add_skipto( "intro",				maps\la_intro::skipto_intro,
	           &"SKIPTO_STRING_HERE",	maps\la_intro::main );
	
	add_skipto( "after_the_attack",		maps\la_sam::skipto_after_attack,
	           &"SKIPTO_STRING_HERE", 	maps\la_sam::main );
	
	add_skipto( "sam_jump",				maps\la_sam::skipto_sam_jump,
	           &"SKIPTO_STRING_HERE", 	maps\la_sam::main );
	
	add_skipto( "sam",					maps\la_sam::skipto_sam,
	           &"SKIPTO_STRING_HERE", 	maps\la_sam::sam_main );
	
	add_skipto( "cougar_fall",			maps\la_sam::skipto_cougar_fall,
	           &"SKIPTO_STRING_HERE", 	maps\la_sam::cougar_fall );
	
	add_skipto( "sniper_rappel",	maps\la_low_road::skipto_sniper_rappel,
	           &"SKIPTO_STRING_HERE",	maps\la_low_road::main );
	
	add_skipto( "sniper_exit",		maps\la_low_road::skipto_sniper_exit,
	       &"SKIPTO_STRING_HERE", 	maps\la_low_road::last_stand_main );
	
	add_skipto( "g20_group1",		maps\la_low_road::skipto_g20,
	       &"SKIPTO_STRING_HERE", 	maps\la_low_road::last_stand_main );
	
	add_skipto( "drive",			maps\la_drive::skipto_drive,
	       &"SKIPTO_STRING_HERE", 	maps\la_drive::main );
	
	add_skipto( "skyline",			maps\la_drive::skipto_skyline,
	       &"SKIPTO_STRING_HERE", 	maps\la_drive::main );
	
	// section 2
	
	add_skipto( "street",				::skipto_la_1b );
	add_skipto( "plaza",				::skipto_la_1b );
	add_skipto( "intersection",			::skipto_la_1b );
	
	// section 3 - flyable f35
	add_skipto( "f35_wakeup",			::skipto_la_2 );
	add_skipto( "f35_boarding",			::skipto_la_2 );
	add_skipto( "f35_flying", 			::skipto_la_2 );
	add_skipto( "f35_ground_targets", 	::skipto_la_2 );
	add_skipto( "f35_pacing", 			::skipto_la_2 );
	add_skipto( "f35_rooftops", 		::skipto_la_2 );
	add_skipto( "f35_dogfights", 		::skipto_la_2 );
	add_skipto( "f35_trenchrun", 		::skipto_la_2 );
	add_skipto( "f35_hotel", 			::skipto_la_2 );
	add_skipto( "f35_eject", 			::skipto_la_2 );
	add_skipto( "f35_outro", 			::skipto_la_2 );
	
	default_skipto( "intro" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}

skipto_la_1b()
{
	ChangeLevel( "la_1b", true );
}

skipto_la_2()
{
	ChangeLevel( "la_2", true );
}

sam_visionset()
{
	self endon( "death" );
	
	while ( true ) 
	{
		self waittill( "missileTurret_on" );
		
		self.lockonmissileturret thread maps\_vehicle_death::vehicle_damage_filter( undefined, 5, 1, true );
		wait( 0.05 );
		ClientNotify( "sam_on" );
		
		battlechatter_off( "allies" );
		battlechatter_off( "axis" );
		
		visionset = self GetVisionSetNaked();
		self VisionSetNaked( "sam_turret", 0.5 );
		
		cin_id = Start3DCinematic( "sam_gizmos_v2", true, false);		
		
		//level thread sam_hint();
		
		self waittill( "missileTurret_off" );
		ClientNotify( "sam_off" );
		
		Stop3DCinematic(cin_id);
		
		battlechatter_on( "allies" );
		battlechatter_on( "axis" );
		
		self VisionSetNaked( visionset, 0 );
	}
}

sam_hint()
{
	screen_message_create( &"LA_SHARED_SAM_HINT_ADS", &"LA_SHARED_SAM_HINT_FIRE" );
	
	level waittill( "sam_hint_drone_killed" );
	
	screen_message_delete();
//	screen_message_create( &"LA_SHARED_SAM_HINT_FIRE", &"LA_SHARED_SAM_HINT_TRACK" );
//	
//	screen_message_delete();
}

init_vehicles()
{
	a_script_models = GetEntArray( "script_model", "classname" );
	a_vehicles = ArrayCombine( a_script_models, GetEntArray( "script_vehicle", "classname" ),false,false );
	
	foreach ( veh in a_vehicles )
	{
		global_vehicle_spawn_func( veh );
	}
}

global_vehicle_spawn_func( veh )
{
	if ( is_police_car( veh ) )
	{
		veh thread police_car();
	}
	else if ( is_police_motorcycle( veh ) )
	{
		veh thread police_motorcycle();
	}
	else if ( is_suv( veh ) && IS_EQUAL( veh.script_animation, "open_suv_doors" ) )
	{
		veh open_suv_doors();
	}
}

cleanup()
{
	GetEnt( "shadow_cougar", "targetname" ) Delete();
	
	add_flag_function( "rappel_option", ::cleanup_kvp, "cougarfalls_f35intro_car01", "targetname" );
	add_flag_function( "rappel_option", ::cleanup_kvp, "cougarfalls_f35intro_car02", "targetname" );
	add_flag_function( "rappel_option", ::cleanup_kvp, "cougarfalls_f35intro_van", "targetname" );
	
	add_flag_function( "sniper_option", ::cleanup_kvp, "cougarfalls_f35intro_car01", "targetname" );
	add_flag_function( "sniper_option", ::cleanup_kvp, "cougarfalls_f35intro_car02", "targetname" );
	add_flag_function( "sniper_option", ::cleanup_kvp, "cougarfalls_f35intro_van", "targetname" );
	
	add_flag_function( "player_driving", ::cleanup_kvp, "g20_group1_cougar2", "targetname" );
	add_flag_function( "player_driving", ::cleanup_kvp, "sam_cougar", "targetname" );
	add_flag_function( "player_driving", ::cleanup_kvp, "freeway_battle_vehicles", "script_noteworthy" );
}
