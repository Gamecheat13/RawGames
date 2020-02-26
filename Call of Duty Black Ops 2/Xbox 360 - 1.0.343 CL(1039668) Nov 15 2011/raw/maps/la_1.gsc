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
	// This MUST be first for CreateFX!	
	maps\la_1_fx::main();
	
	//TODO: remove this, is for LA_1s first playable
	early_black();
	
	VisionSetNaked( "la_1" );
	
	level_precache();
	init_flags();
	setup_objectives();
	setup_skiptos();
	
	maps\_player_rappel::rappel_precache();
	maps\_apc_cougar_ride::init();
	
	level.createfx_callback_thread = ::createfx_setup;
	maps\_load::main();
		
	OnPlayerConnect_Callback( ::on_player_connect );
	
	level thread maps\createart\la_1_art::main();
	
	level.callbackVehicleDamage = ::la_1_vehicle_damage;
	level.vehicleSpawnCallbackThread = ::global_vehicle_spawn_func;
	
	maps\_lockonmissileturret::init( false, undefined, 6 );
	
	add_spawn_function_veh_by_type( "drone_pegasus_fast", maps\_pegasus::update_objective_model );
	add_spawn_function_veh_by_type( "drone_avenger_fast", maps\_avenger::update_objective_model );
	add_spawn_function_veh_by_type( "civ_van_sprinter", ::veh_brake_unload );
	
	init_vehicles();

	maps\la_1_amb::main();
	maps\la_1_anim::main();
		
	level thread maps\_objectives::objectives();
	
	//Shawn J - Sound
	SetSavedDvar( "vehicle_sounds_cutoff", 30000 );
	SetDvar( "footstep_sounds_cutoff", 3000 );
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	cleanup();
}

on_player_connect()
{
	setup_challenges();
	self thread sam_visionset();
	self SetClientDvar( "cg_tracerSpeed", 20000 ); // default is 7500
	
	waittillframeend;
	self player_flag_wait( "loadout_given" );
	
	give_max_ammo_for_sniper_weapons();
}

level_precache()
{
	PrecacheModel( "veh_t6_mil_cougar_hood_obj" );
	PrecacheModel( "veh_t6_mil_cougar_door_obj" );
	PrecacheModel( "veh_t6_mil_cougar_interior_obj" );
	PrecacheModel( "veh_t6_air_blackhawk_stealth_dead" );
	PrecacheModel( "veh_t6_mil_cougar_destroyed" );
	PrecacheModel( "veh_t6_mil_cougar_interior" );
	PrecacheModel( "veh_t6_mil_cougar_interior_shadow" );
	PrecacheModel( "veh_t6_mil_cougar_interior_front" );	
	PrecacheModel( "p_jun_vc_ammo_crate" );
	PrecacheModel( "p_jun_vc_ammo_crate_open_single" );
	
	PrecacheItem( "rpg_player_sp" );
	PrecacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "frag_grenade_sonar_sp" );
	
	PrecacheTurret( "sam_turret_sp" );
	
	PrecacheShellshock( "khe_sanh_woods" );
	
	PrecacheRumble( "la_1_fa38_intro_rumble" );
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
	
	if ( is_greenlight_build() )
	{
		add_skipto( "g20_group1",		maps\la_low_road::skipto_g20,
		       &"SKIPTO_STRING_HERE", 	maps\la_low_road::last_stand_green_light );
		
		add_skipto( "drive",			maps\la_drive::skipto_drive,
		       &"SKIPTO_STRING_HERE", 	maps\la_drive::main );
		
		add_skipto( "skyline",			maps\la_drive::skipto_skyline,
		       &"SKIPTO_STRING_HERE", 	maps\la_drive::main );
	}
	else
	{
		add_skipto( "sniper_rappel",	maps\la_low_road::skipto_sniper_rappel,
	           &"SKIPTO_STRING_HERE",	maps\la_low_road::main );
		
		add_skipto( "g20_group1",		maps\la_low_road::skipto_g20,
		       &"SKIPTO_STRING_HERE", 	maps\la_low_road::last_stand_main );
		
		add_skipto( "drive",			maps\la_drive::skipto_drive,
		       &"SKIPTO_STRING_HERE", 	maps\la_drive::main );
		
		add_skipto( "skyline",			maps\la_drive::skipto_skyline,
		       &"SKIPTO_STRING_HERE", 	maps\la_drive::main );
	}
	
	// section 2
	
	add_skipto( "street",				::skipto_la_1b );
	add_skipto( "plaza",				::skipto_la_1b );
	add_skipto( "arena", 				::skipto_la_1b );
	add_skipto( "arena_exit", 			::skipto_la_1b );
	
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

early_black()
{
	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true;
	level.introblack SetShader( "black", 640, 480 );
}

skipto_la_1b()
{
	/#
		AddDebugCommand( "devmap la_1b" );
	#/
}

skipto_la_2()
{
	/#
		AddDebugCommand( "devmap la_2" );
	#/
}

sam_visionset()
{
	self endon( "death" );
	
	while ( true ) 
	{
		self waittill( "missileTurret_on" );
		ClientNotify( "sam_on" );
		
		battlechatter_off( "allies" );
		battlechatter_off( "axis" );
		
		visionset = self GetVisionSetNaked();
		self VisionSetNaked( "sam_turret", 0.5 );
		
		level thread sam_hint();
		
		self waittill( "missileTurret_off" );
		ClientNotify( "sam_off" );
		
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
	a_vehicles = array_merge( a_script_models, GetEntArray( "script_vehicle", "classname" ) );
	
	foreach ( veh in a_vehicles )
	{
		if ( is_police_car( veh ) )
		{
			veh thread police_car();
		}
	}
}

global_vehicle_spawn_func( veh )
{
	if ( is_police_car( veh ) )
	{
		veh thread police_car();
	}
}

setup_challenges()
{
	self thread maps\_challenges_sp::register_challenge( "turretdrones", maps\la_sam::challenge_turretdrones );
	self thread maps\_challenges_sp::register_challenge( "snipekills", maps\la_low_road::challenge_snipekills );
	self thread maps\_challenges_sp::register_challenge( "rescuefirst", maps\la_low_road::challenge_rescuefirst );
}

cleanup()
{
	add_flag_function( "done_rappelling", ::cleanup_kvp, "cougarfalls_f35intro_car01", "targetname" );
	add_flag_function( "done_rappelling", ::cleanup_kvp, "cougarfalls_f35intro_car02", "targetname" );
	add_flag_function( "done_rappelling", ::cleanup_kvp, "cougarfalls_f35intro_van", "targetname" );
	
	add_flag_function( "player_driving", ::cleanup_kvp, "g20_group1_cougar2", "targetname" );
	add_flag_function( "player_driving", ::cleanup_kvp, "sam_cougar", "targetname" );
	add_flag_function( "player_driving", ::cleanup_kvp, "freeway_battle_vehicles", "script_noteworthy" );
}
