#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;

main()
{
	// This MUST be first for CreateFX!	
	maps\afghanistan_fx::main();
	
	level_precache();
	level_init_flags();
	init_fade_settings();
	blocking_point_chooser();
	setup_skiptos();
	setup_level();
	init_crew_emplacement();
	
	maps\_load::main();

	maps\afghanistan_amb::main();
	maps\afghanistan_anim::main();
	maps\_heatseekingmissile::init();
	
	level thread setup_objectives();
	level thread maps\_objectives::objectives();
	level thread maps\createart\afghanistan_art::main();
	
	level thread maps\afghanistan_utility::handle_map_controls();
		
		//Shawn J - Sound
	SetSavedDvar( "vehicle_sounds_cutoff", 30000 );
	SetDvar( "footstep_sounds_cutoff", 3000 );
	//battlechatter_on( "allies" );
	//battlechatter_on( "axis" );
	
	OnPlayerConnect_Callback( ::on_player_connect );	
	//wait_for_all_players();
}


on_player_connect()
{
	level.player = get_players()[0];	
	
	setup_challenges();
	
	level.player thread waittill_player_mounts_horse();
}


level_precache()
{
	precachemodel("c_usa_cia_masonjr_viewbody");
	precachemodel("t5_weapon_1911_sp_world");
	precachemodel("t6_wpn_mortar_shell_prop_view");
	
	//PrecacheItem( "generic_filter_binoculars" );
	PrecacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "ak47_sp" );
	PrecacheItem( "btr60_heavy_machinegun" );
	PrecacheItem( "huey_rockets" );
	//PrecacheItem( "huey_minigun_gunner" );
	PrecacheItem( "stinger_sp" );
	PrecacheItem( "rpg_player_sp" );
	PrecacheItem( "pulwar_sword_sp" );
	PrecacheItem( "tc6_mine_sp" );
	
	//PrecacheItem( "p6_anim_strongbox" );
	//PrecacheItem( "p6_anim_strongbox_lock" );
	//	PrecacheItem( "t6_wpn_boltcutters_prop_view" );

	maps\_horse::precache_models();
}


level_init_flags()
{
	maps\afghanistan_horse_intro::init_flags();
	maps\afghanistan_intro_rebel_base::init_flags();
	maps\afghanistan_firehorse::init_flags();
	maps\afghanistan_wave_1::init_flags();
	maps\afghanistan_wave_2::init_flags();
	maps\afghanistan_wave_3::init_flags();
	maps\afghanistan_blocking_done::init_flags();
	maps\afghanistan_horse_charge::init_flags();
	maps\afghanistan_krav_captured::init_flags();
	maps\afghanistan_deserted::init_flags();
}


/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
setup_skiptos()
{
	//Section 1
	add_skipto( "intro", maps\afghanistan_intro::skipto_intro, "Intro", maps\afghanistan_intro::main );
	add_skipto( "horse_intro", maps\afghanistan_horse_intro::skipto_intro, "Horse Intro", maps\afghanistan_horse_intro::main );
	add_skipto( "rebel_base_intro", maps\afghanistan_intro_rebel_base::skipto_intro, "rebel base intro", maps\afghanistan_intro_rebel_base::main );

	//Section 2
	add_skipto( "firehorse", maps\afghanistan_firehorse::skipto_firehorse, "Fire Horse", maps\afghanistan_firehorse::main );
	add_skipto( "wave_1", maps\afghanistan_wave_1::skipto_wave1, "Wave 1", maps\afghanistan_wave_1::main );
	add_skipto( "wave_2", maps\afghanistan_wave_2::skipto_wave2, "Wave 2", maps\afghanistan_wave_2::main );
	add_skipto( "wave_3", maps\afghanistan_wave_3::skipto_wave3, "Wave 3", maps\afghanistan_wave_3::main );
	add_skipto( "blocking_done", maps\afghanistan_blocking_done::skipto_blockingdone, "Blocking Done", maps\afghanistan_blocking_done::main );
		
	//Section 3
	add_skipto( "horse_charge", maps\afghanistan_horse_charge::skipto_horse_charge, "Horse Charge", maps\afghanistan_horse_charge::main );
	add_skipto( "krav_tank", maps\afghanistan_horse_charge::skipto_krav_tank, "Krav Tank", maps\afghanistan_horse_charge::main );
	add_skipto( "krav_captured", maps\afghanistan_krav_captured::skipto_krav_captured, "Krav Captured", maps\afghanistan_krav_captured::main );
	add_skipto( "interrogation", maps\afghanistan_krav_captured::skipto_krav_interrogation, "Krav Captured", maps\afghanistan_krav_captured::main );
	add_skipto( "beat_down", maps\afghanistan_krav_captured::skipto_beat_down, "Beatdown", maps\afghanistan_krav_captured::main );
	add_skipto( "deserted", maps\afghanistan_deserted::skipto_deserted, "Deserted", maps\afghanistan_deserted::main );
	
	default_skipto( "intro" );
}


/* ------------------------------------------------------------------------------------------
OBJECTIVES
-------------------------------------------------------------------------------------------*/
setup_objectives()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	
	//Section 1
	
	level.OBJ_AFGHAN_BC1 = register_objective( &"AFGHANISTAN_BASECAMP_1");
	level.OBJ_AFGHAN_BC2 = register_objective( &"AFGHANISTAN_BASECAMP_2");
	level.OBJ_AFGHAN_BC3 = register_objective( &"AFGHANISTAN_BASECAMP_3");
	level.OBJ_AFGHAN_RC1 = register_objective( &"AFGHANISTAN_REBEL_CAMP");
	
	//Section 2
	level.OBJ_FOLLOW = register_objective( &"" );
	level.OBJ_AFGHAN_BP1 = register_objective( &"AFGHANISTAN_OBJ_BP1" );
	level.OBJ_AFGHAN_BP2 = register_objective( &"AFGHANISTAN_OBJ_BP2" );
	level.OBJ_AFGHAN_BP3 = register_objective( &"AFGHANISTAN_OBJ_BP3" );
	level.OBJ_AFGHAN_WAVE3 = register_objective( &"AFGHANISTAN_OBJ_WAVE3" );
	level.OBJ_DEFEND_ALL = register_objective( &"AFGHANISTAN_OBJ_DEFEND_ALL" );
	level.OBJ_RETURN_BASE = register_objective( &"AFGHANISTAN_OBJ_RETURN_BASE" );
	
	//Section 3
}


setup_level()
{
	t_exit = getent( "tunnel_exit", "targetname" );
	t_exit trigger_off();
		
	t_horse = getent( "trigger_base_horse", "targetname" );
	t_horse trigger_off();
	
	t_overlook = getent( "player_at_overlook", "targetname" );
	t_overlook trigger_off();
	
	t_mig = getent( "mig_in_face", "targetname" );
	t_mig trigger_off();
	
	//wave2 - bp3
	t_uaz = getent( "spawn_uaz", "targetname" );
	t_uaz trigger_off();
	
	a_t_hip = GetEntArray( "trigger_hip1_bp3", "script_noteworthy" );
	foreach( t_hip in a_t_hip )
	{
		t_hip trigger_off();
	}
	
	t_boss = getent( "trigger_boss_bp3", "script_noteworthy" );
	t_boss trigger_off();
	
	t_btr = getent( "spawn_btr1_bp3", "script_noteworthy" );
	t_btr trigger_off();
	
	t_boss_bp3 = getent( "spawn_boss_bp3", "script_noteworthy" );
	t_boss_bp3 trigger_off();
	
	level.player_wave3_loc = 0;  //bp the player is located when wave3 is complete
	
	SetSavedDvar( "vehicle_selfCollision", 0 );
}


blocking_point_chooser()
{
	// Wave 2
	level.wave2_loc = "blocking point 2";
	
	if ( cointoss() )
	{
		level.wave2_loc = "blocking point 3";
	}
	
	// Wave 3
	if ( level.wave2_loc == "blocking point 2" )
	{
		level.wave3_loc = "blocking point 3";  //plus "blocking point 1"	
	}
	
	else
	{
		level.wave3_loc = "blocking point 2";
	}
}


waittill_player_mounts_horse()  //self = level.player
{
	while( 1 )
	{
		self waittill( "enter_vehicle", vehicle );
		
		vehicle Godon();
		
		self waittill( "exit_vehicle", vehicle );
		
//		if(!is_corpse(vehicle))
//		{
//			vehicle Godoff();
//		}
	}
}



// Challenge script

setup_challenges( )
{
	self thread maps\_challenges_sp::register_challenge( "nodeath", ::nodeath_challenge);
	self thread maps\_challenges_sp::register_challenge( "locateintel", ::locate_int);
	self thread maps\_challenges_sp::register_challenge( "allspecialties", ::accessallperk);
	self thread maps\_challenges_sp::register_challenge( "drug_trafic_intel", ::kravchenko_intel);
	self thread maps\_challenges_sp::register_challenge( "killallvulture", ::kill_all_vultures);
	self thread maps\_challenges_sp::register_challenge( "support_crews_faster", ::lockbreaker_challenge);
}

nodeath_challenge( str_notify )
{
	level.player waittill( "mission_finished" );
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
	
}

		
locate_int( str_notify )
{
	level.player waittill( "mission_finished" );
	
	player_collected_all = collected_all();
	
	if( player_collected_all )
	{
		self notify( str_notify );		
	}
	
}

accessallperk( str_notify )
{
	
	
}
kravchenko_intel( str_notify )
{
	level.player waittill("krav_got_shot");
	
	if(!level.player.is_shooting)
	{
		self notify( str_notify );
	}
}

kill_all_vultures( str_notify )
{
	level endon("vulture_flew_away");
	
	level waittill( "vulture_event_over" );
	
	for(i = 0; i < (3 - level.vultures_alive); i++)
	{
		self notify( str_notify );	
	}
}

lockbreaker_challenge( str_notify )
{
	level waittill( "lockbreaker_opened" );

	self notify( str_notify );	

}
