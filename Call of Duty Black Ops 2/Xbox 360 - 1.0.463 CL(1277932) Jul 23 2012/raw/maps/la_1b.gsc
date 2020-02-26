/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\la_utility;
#include maps\la_1b_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\la_1b_fx::main();
	
	maps\_quadrotor::init();
	
	VisionSetNaked( "la_1" );

	level_precache();
	init_flags();
	setup_objectives();
	setup_skiptos();
	
	level.supportsPistolAnimations = true;
	level.vehicleSpawnCallbackThread = ::global_vehicle_spawn_func;
	
	init_vehicles();
	
	maps\la_1b_anim::main();
	maps\_load::main();

	maps\la_1b_amb::main();
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	level thread maps\createart\la_1b_art::main();
	
	maps\_rusher::init_rusher();
	maps\_lockonmissileturret::init( false, undefined, 6 );
	
	level thread objectives();
	
	level thread load_roof_gump();
	
	//Extending footstep cutoff range so we can make the big dogs audible from a greater distance 
	SetDvar ("footstep_sounds_cutoff", 8000);
	
	//HACK: give future grenades to the player
	//level thread player_give_grenades();
        level thread do_eye();


}

do_eye()
{
        SetSavedDvar( "r_stereo3DEyeSeparation", 0.2);
        wait(30);
        for(val=0.2;val<=0.6;val+=0.1)
        {
                SetSavedDvar( "r_stereo3DEyeSeparation", val);
                wait(0.1);
        }
}


player_give_grenades()
{
	flag_wait("level.player");
	level.player GiveWeapon("frag_grenade_future_sp");
}

load_roof_gump()
{
	while ( true )
	{
		trigger_wait( "load_roof_gump" );
		
		maps\la_plaza::cleanup_street();
		spawn_roof_sam();
		
		trigger_wait( "load_plaza_gump" );
		
		if ( IsDefined( level.veh_roof_sam ) )
		{
			level.veh_roof_sam Delete();
		}
		
		wait( 0.25 );
		
		level thread load_gump( "la_1b_gump_1" );
	}
}

spawn_roof_sam()
{
	level endon( "flushing_la_1b_gump_3" );
	load_gump( "la_1b_gump_3" );
	
	wait( 0.25 );
	
	level.veh_roof_sam = spawn_vehicle_from_targetname( "intruder_sam" );
}

on_player_connect()
{
	level_settings();
}

level_settings()
{
	level thread setup_story_states(); 
}

init_vehicles()
{
	a_script_models = GetEntArray( "script_model", "classname" );
	a_vehicles = ArrayCombine( a_script_models, GetEntArray( "script_vehicle", "classname" ), false, false );
	
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
}

// All precache calls go here
level_precache()
{
	//HACK: give future grenades to the player
	PrecacheItem("frag_grenade_future_sp");
	
	PrecacheItem( "frag_grenade_sonar_sp" );
	PrecacheItem( "usrpg_player_sp" );
	PrecacheItem( "usrpg_magic_bullet_sp" );
	PrecacheItem( "metalstorm_sp" );
	
	PrecacheShellshock( "khe_sanh_woods_verb" );

	PreCacheString( &"la_pip_seq_1" );
	PreCacheString( &"la_pip_seq_2" );
	
	PrecacheModel( "c_usa_cia_masonjr_viewbody_vson" );
	PrecacheModel( "veh_t6_air_fa38_landing_gear" );
	PrecacheModel( "veh_t6_civ_18wheeler_trailer_props" );
	PrecacheModel( "t6_wpn_special_storm_world" );
	PrecacheModel( "veh_t6_drone_avenger_x2" );
	PrecacheModel( "veh_t6_police_car_destroyed" );
	
	PrecacheRumble( "la_1b_building_collapse" );
	PrecacheRumble( "flyby" );

	maps\_fire_direction::precache();
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	// section 1
	add_skipto( "intro",				::skipto_la_1 );
	add_skipto( "after_the_attack",		::skipto_la_1 );
	add_skipto( "sam",					::skipto_la_1 );
	add_skipto( "cougar_fall",			::skipto_la_1 );
	add_skipto( "sniper_rappel",		::skipto_la_1 );
	add_skipto( "g20_group1",			::skipto_la_1 );
	add_skipto( "drive",				::skipto_la_1 );
	add_skipto( "skyline",				::skipto_la_1 );
	
	// section 2
	add_skipto( "street",				maps\la_street::skipto_street,
	           &"SKIPTO_STRING_HERE", 	maps\la_street::main );
	
	add_skipto( "plaza",				maps\la_plaza::skipto_plaza,
	           &"SKIPTO_STRING_HERE", 	maps\la_plaza::main );
	
	add_skipto( "intersection",			maps\la_intersection::skipto_intersection,
	           &"SKIPTO_STRING_HERE", 	maps\la_intersection::main );
	
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
	
	default_skipto( "street" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}

skipto_la_1()
{
	ChangeLevel( "la_1", true );
}

skipto_la_2()
{
	ChangeLevel( "la_2", true );
}
