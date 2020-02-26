#include maps\_utility;
#include maps\_riotshield;
#include maps\_vehicle;
#include maps\_vehicle_spline;
#include maps\_anim;
#include maps\_hud_util;
#include common_scripts\utility;
#include maps\gulag_code;
#include maps\_specialops;

// ---------------------------------------------------------------------------------
//	NEED TO PURGE AND CLEAN MAIN
// ---------------------------------------------------------------------------------

main()
{

	level.so_compass_zoom = "close";

//	breakpoint;
	gulag_destructible_volumes = GetEntArray( "gulag_destructible_volume", "targetname" );
	mask_destructibles_in_volumes( gulag_destructible_volumes );
	mask_interactives_in_volumes( gulag_destructible_volumes );

	level.default_goalheight = 128;
	create_dvar( "f15", 1 );
	SetSavedDvar( "g_friendlyNameDist", 0 );

	maps\createfx\gulag_audio::main();
	//VisionSetNight( "gulag_nvg", 1.5 );

	// The Gulag
	PreCacheString( &"GULAG_INTROSCREEN_LINE_1" );
	// Northern Russia - 09:20:[{FAKE_INTRO_SECONDS:02}] hrs
	PreCacheString( &"GULAG_INTROSCREEN_LINE_2" );
	// P03 'Roach' Silvers
	PreCacheString( &"GULAG_INTROSCREEN_LINE_3" );
	// SEAL Team Six, U.S.N.
	PreCacheString( &"GULAG_INTROSCREEN_LINE_4" );

//	level.start_point = "unload";
	set_default_start( "so_showers" );
	add_start( "intro", ::start_empty, "Intro", ::gulag_flyin );
	add_start( "approach", ::start_approach, "Approach", ::gulag_approach );
	add_start( "f15", ::start_f15, "f15", ::gulag_perimeter );
	add_start( "unload", ::start_f15, "Unload", ::gulag_perimeter );
	add_start( "control_room", ::start_control_room, "Control Room", ::gulag_cellblocks );
	add_start( "armory", ::start_armory, "Armory", ::gulag_armory );
	add_start( "rappel", ::start_rappel, "Rappel", ::gulag_rappel );
	add_start( "bathroom", ::start_bathroom, "Bathroom", ::gulag_bathroom );
	add_start( "so_showers", ::start_so_showers_timed, "Special Op: Showers" );
	add_start( "rescue", ::start_rescue, "Rescue", ::gulag_rescue );
	

	falling_rib_chunks = GetEntArray( "falling_rib_chunk", "targetname" );
	array_thread( falling_rib_chunks, ::self_delete );
	top_hall_exploders = GetEntArray( "top_hall_exploder", "targetname" );
	array_thread( top_hall_exploders, ::self_delete );
	top_hall_chunks = GetEntArray( "top_hall_chunk", "targetname" );
	array_thread( top_hall_chunks, ::self_delete );
	top_hall_chunks = GetEntArray( "top_hall_chunk", "targetname" );
	array_thread( top_hall_chunks, ::self_delete );

	level.disable_interactive_tv_use_triggers = true;

	/*
	start = create_start( "intro" );
	start.main = ::gulag_flyin;
	start.text = "Intro";
	
	start = create_start( "approach" );
	start.main = ::gulag_approach;
	start.text = "Approach";
	*/

	level.custom_no_game_setupFunc = ::gulag_no_game_start_setupFunc;
	level.slowmo_viewhands = "viewhands_player_udt";

	maps\_drone_ai::init();
	maps\gulag_precache::main();
	maps\createart\gulag_fog::main();
	maps\gulag_fx::main();
	thread maps\gulag_ending::endlog_common();

	//delaythread( 3, ::exploder, "hall_attack" );

	maps\_load::main();
	maps\_compass::setupMiniMap( "compass_map_gulag_2" );
	setsaveddvar( "compassmaxrange", "1350" );

	maps\_slowmo_breach::slowmo_breach_init();
	level._effect[ "breach_door" ]					 = LoadFX( "explosions/breach_wall_concrete" );

	maps\gulag_anim::gulag_anim();
	maps\_nightvision::main( level.players );

	add_global_spawn_function( "axis", ::higher_max_facedist );

	// Press^3 [{+actionslot 3}] ^7to use\nthe M203 Grenade Launcher.
	add_hint_string( "grenade_launcher", &"SCRIPT_LEARN_GRENADE_LAUNCHER", ::should_break_m203_hint );

	// Press^3 [{+actionslot 1}] ^7to use Night Vision Goggles.
	add_hint_string( "nvg", &"SCRIPT_NIGHTVISION_USE", maps\_nightvision::ShouldBreakNVGHintPrint );

	// Press^3 [{+actionslot 1}] ^7to disable Night Vision Goggles.
	add_hint_string( "disable_nvg", &"SCRIPT_NIGHTVISION_STOP_USE", maps\_nightvision::should_break_disable_nvg_print );

	level.rioter_threat = 1000;
	level._pipe_fx_time = 2.5;

	flag_init( "intro_helis_go" );
	flag_init( "stop_tv_loop" );
	flag_init( "f15s_spawn" );
	flag_init( "anti_air_missiles_fire" );
	flag_init( "aa_hit" );
	flag_init( "f15s_attack" );
	flag_init( "player_heli_uses_modified_yaw" );
	flag_init( "intro_helis_spawned" );
	flag_init( "player_lands" );
	flag_init( "overlook_cleared_with_safe_time" );
	//flag_init( "cell_door1" );
	flag_init( "cell_door2" );
	flag_init( "cell_door3" );
	flag_init( "cell_door4" );
	flag_init( "cell_door_weapons" );
	flag_init( "access_control_room" );
	flag_init( "going_in_hot" );
	flag_init( "gulag_cell_doors_enabled" );
	flag_init( "player_exited_bathroom" );
	flag_init( "player_rappels_from_bathroom" );
	flag_init( "rope_drops_now" );
	flag_init( "cell_duty" );
	flag_init( "cellblock_player_starts_rappel" );
	flag_init( "bathroom_second_wave_trigger" );
	flag_init( "soap_snipes_tower" );
	flag_init( "slamraam_gets_players_attention" );
	flag_init( "slamraam_killed_2" );
	flag_init( "stop_rotating_around_gulag" );
	flag_init( "player_goes_in_for_landing" );
	flag_init( "enable_endlog_fx" );
	flag_init( "escape_the_gulag" );
//	flag_set( "player_goes_in_for_landing" );
	flag_init( "gulag_perimeter" );
	flag_init( "pre_boats_attack" );
	flag_init( "clear_dof" );
	flag_init( "player_heli_backs_up" );
	flag_init( "stop_shooting_right_side" );
	flag_set( "player_can_rappel" );// didnt need

	flag_init( "gulag_shower_music_done" );

	//thread setup_celldoor( "cell_door1" );


	thread setup_celldoor( "cell_door2" );
	thread setup_celldoor( "cell_door3" );
	thread setup_celldoor( "cell_door4" );
	thread setup_celldoor( "cell_door_weapons" );

	PreCacheItem( "smoke_grenade_american" );
	PreCacheItem( "armory_grenade" );
	PreCacheItem( "m4m203_reflex" );
	PreCacheItem( "f15_sam" );
	PreCacheItem( "sam" );
	PreCacheItem( "slamraam_missile" );
	PreCacheItem( "slamraam_missile_guided" );
	PreCacheItem( "stinger" );
	PreCacheItem( "cobra_seeker" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "cobra_Sidewinder" );
	PreCacheItem( "m14_scoped" );
	PreCacheItem( "claymore" );
	PreCacheItem( "mp5_silencer_reflex" );
	PreCacheTurret( "heli_spotlight" );
	PreCacheTurret( "player_view_controller" );


	PreCacheItem( "m14_scoped" );
	PreCacheItem( "m4m203_reflex" );
	PreCacheItem( "fraggrenade" );
	PreCacheItem( "flash_grenade" );
	PreCacheItem( "claymore" );

	precachemodel( "viewhands_player_udt" );
	precachemodel( "viewhands_udt" );

	PreCacheModel( "com_emergencylightcase_blue" );
	PreCacheModel( "gulag_price_ak47" );
	PreCacheModel( "com_emergencylightcase_orange" );
	PreCacheModel( "com_emergencylightcase_blue_off" );
//	PreCacheModel( "rappelrope100_le_obj" );
	PreCacheModel( "com_drop_rope_obj" );
	PreCacheModel( "com_blackhawk_spotlight_on_mg_setup" );
	PreCacheModel( "com_blackhawk_spotlight_on_mg_setup_3x" );
	PreCacheModel( "vehicle_slamraam_launcher_no_spike" );
	PreCacheModel( "vehicle_slamraam_missiles" );
	PreCacheModel( "projectile_slamraam_missile" );
	PreCacheModel( "tag_turret" );
	PreCacheModel( "me_lightfluohang_double_destroyed" );
	PreCacheModel( "me_lightfluohang_single_destroyed" );
	PreCacheModel( "ma_flatscreen_tv_wallmount_broken_01" );
	PreCacheModel( "ma_flatscreen_tv_wallmount_broken_02" );
	PreCacheModel( "com_tv2_d" );
	PreCacheModel( "com_tv1" );
	PreCacheModel( "com_tv2" );
	PreCacheModel( "com_tv1_testpattern" );
	PreCacheModel( "com_tv2_testpattern" );
	PreCacheModel( "com_locker_double_destroyed" );
	PreCacheModel( "ch_street_wall_light_01_off" );
	PreCacheModel( "dt_mirror_dam" );	
	PreCacheModel( "dt_mirror_des" );	


	loadfx( "explosions/tv_flatscreen_explosion" );
	loadfx( "misc/light_fluorescent_single_blowout_runner" );
	loadfx( "misc/light_fluorescent_blowout_runner" );
	loadfx( "props/locker_double_des_01_left" );
	loadfx( "props/locker_double_des_02_right" );
	loadfx( "props/locker_double_des_03_both" );
	loadfx( "misc/no_effect" );
	loadfx( "misc/light_blowout_swinging_runner" );
	loadfx( "props/mirror_dt_panel_broken" );
	loadfx( "props/mirror_shatter" );
	precacheshellshock( "gulag_attack" );
	precacheshellshock( "nosound" );

	

	level.breakables_fx[ "tv_explode" ] = LoadFX( "explosions/tv_explosion" );


	thread handle_gulag_world_fx();

	level thread maps\gulag_amb::main();
	thread player_riotshield_threatbias();

	level thread init_tv_movies();
//	thread gulag_music();

	level.tarp_guys = [];
	tarp_pull_orgs = GetEntArray( "tarp_pull_org", "targetname" );
	array_thread( tarp_pull_orgs, ::tarp_pull_org_think );

	player_start = getstruct( "start_approach", "script_noteworthy" );
	friendly_starts = getstructarray( "start_approach_friendly", "script_noteworthy" );
	friendly_starts[ "p" ] = player_start;

	thread blow_up_first_tower_soon();



	thread remove_rpgs();

	SetIgnoreMeGroup( "team3", "axis" );
	SetIgnoreMeGroup( "axis", "team3" );

	spawner = GetEnt( "endlog_soap_spawner", "targetname" );
	spawner thread add_spawn_function( ::gulag_become_soap );

	spawner = GetEnt( "ghost", "script_noteworthy" );
	spawner thread add_spawn_function( ::gulag_become_ghost );

	array_spawn_function_noteworthy( "overlook_spawner", ::overlook_spawner_think );
	//array_spawn_function_noteworthy( "hallway_runner_spawner", ::hallway_runner_spawner_think );
	array_spawn_function_targetname( "bhd_spawner", ::bhd_heli_think );
	array_spawn_function_noteworthy( "breach_death_spawner", ::die_on_ragdoll );
	array_spawn_function_noteworthy( "riot_shield_spawner", ::riot_shield_guy );
	array_spawn_function_noteworthy( "flee_armory_spawner", ::flee_armory_think );
	array_spawn_function_noteworthy( "tarp_spawner", ::tarp_spawner_think );
//	array_spawn_function_noteworthy( "doomed_just_doomed", ::doomed_just_doomed_think );
	array_spawn_function_noteworthy( "close_fighter_spawner", ::close_fighter_think );
	array_spawn_function_noteworthy( "bathroom_balcony_spawner", ::bathroom_balcony_spawner );
	array_spawn_function_noteworthy( "riot_escort_spawner", ::riot_escort_spawner );
	array_spawn_function_noteworthy( "catwalk_spawner", ::catwalk_spawner );
	

	ally_gets_missed_triggers = GetEntArray( "ally_gets_missed_trigger", "targetname" );
	array_thread( ally_gets_missed_triggers, ::ally_gets_missed_trigger_think );

	ally_can_get_hit_triggers = GetEntArray( "ally_can_get_hit_trigger", "targetname" );
	array_thread( ally_can_get_hit_triggers, ::ally_can_get_hit_trigger_think );
	
	ally_in_armorys = getentarray( "ally_in_armory", "targetname" );
	array_thread( ally_in_armorys, ::ally_in_armory_think );

	challenge_onlys = GetEntArray( "challenge_only", "targetname" );
	array_thread( challenge_onlys, ::challenge_only_think );
	
	damage_targ_triggers = GetEntArray( "damage_targ_trigger", "targetname" );
	array_thread( damage_targ_triggers, ::damage_targ_trigger_think );

	friendlies_ditch_riot_shields_triggers = getentarray( "friendlies_ditch_riot_shields_trigger", "targetname" );
	array_thread( friendlies_ditch_riot_shields_triggers, ::friendlies_ditch_riot_shields_trigger_think );

	
	add_wait( ::flag_wait, "player_moves_into_gulag" );
	add_func( ::flag_set, "gulag_cell_doors_enabled" );
	thread do_wait();

	thread landing_blocker_think();


	level.ending_flee_guys = 0;
	level.ending_flee_max = 0;
	//array_spawn_function_noteworthy( "ending_flee_spawner", ::ending_flee_spawner_think );

	//price_spawner = GetEnt( "price_spawner", "script_noteworthy" );
	//price_spawner thread add_spawn_function( ::price_spawn_think );


	level.slamraam_missile = "slamraam_missile_guided";
	//thread heli_strike();
	//thread gulag_center_shifts_as_we_move_in();

	thread gulag_objectives();
	thread gulag_startpoint_catchup_thread();

	// makes the friendlies go the right way
	ai_field_blocker = GetEnt( "ai_field_blocker", "targetname" );
	ai_field_blocker ConnectPaths();
	ai_field_blocker NotSolid();

	deprecated_traverses = GetEntArray( "deprecated_traverse", "targetname" );
	array_thread( deprecated_traverses, ::self_delete );

	/*

	wait( 2 );
	vision_set_changes( "gulag_hallways", 1 );
	fog_set_changes( "gulag_hallways", 1 );
	wait( 2 );
	exploder( "hallway_collapse" );
	ent = getstruct( "hallway_cavein_damage", "targetname" );
	time = 3;
	frames = time * 20;
	for ( i = 0; i < frames; i++ )
	{
		RadiusDamage( ent.origin, ent.radius, 10, 5 );
		wait( 0.05 );
	}
	*/

	//thread gulag_hallway_explodes();



//	thread gulag_boats();
//	player_view_controller = SpawnTurret( "misc_turret", (0,0,0), "heli_spotlight" );	

/*
	for ( ;; )
	{
		foreach ( start in friendly_starts )
		{
		//	Print3d( start.origin, "x", (1,0,0), 1, 5 );
		}
		wait( 0.05 );
	}
*/
//	level.player SetActionSlot( 1, "nightvision" );
}

// ---------------------------------------------------------------------------------
//	SPECIAL OPS SPECIFIC
// ---------------------------------------------------------------------------------

start_so_showers_timed()
{
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_showers_timed_setup_Regular();	break;	// Regular
		case 2:	so_showers_timed_setup_hardened();	break;	// Hardened
		case 3:	so_showers_timed_setup_veteran();	break;	// Veteran
	}
	
	// Prevent player from leaving the valid play space.
	thread enable_escape_warning();
	thread enable_escape_failure();
	
	objective_marker = getent( "player_rappels_from_bathroom", "script_noteworthy" );
	Objective_Add( 1, "current", level.challenge_objective, objective_marker.origin );

	volume = GetEnt( "gulag_shower_destructibles", "script_noteworthy" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();

	thread fade_challenge_in();
	thread fade_challenge_out( "player_exited_bathroom" );
	thread enable_challenge_timer( "player_enters_bathroom", "player_exited_bathroom" );
	thread enable_triggered_complete( "player_rappels_from_bathroom", "player_exited_bathroom" );
	thread gulag_shower_challenge_music();

	foreach ( player in level.players )
		player SetActionSlot( 1, "" );

	flag_wait( "player_enters_bathroom" );

	thread maps\_ambient::activateAmbient( "gulag_shower_int0" );

	level.player.attackeraccuracy = 0;
	level.player delayThread( 6, maps\_gameskill::update_player_attacker_accuracy );

	activate_trigger_with_targetname( "bathroom_initial_enemies" );
	
	delayThread( 10, ::activate_trigger_with_targetname, "bathroom_balcony_room1_trigger" );

	flag_wait( "bathroom_start_second_wave" );

	delaythread( 1, ::activate_trigger_with_targetname, "bathroom_balcony_room2_trigger" );
	activate_trigger_with_targetname( "bathroom_second_wave_trigger" );
}

so_showers_timed_setup_get_spawners( randomize )
{
	if ( !isdefined( randomize ) )
		randomize = true;
		
	// Access all the enemy spawners used in the bathroom
	level.bathroom_initial			= getentarray( "bathroom_initial_spawner", "script_noteworthy" );
	level.bathroom_balcony			= getentarray( "bathroom_balcony_spawner", "script_noteworthy" );
	level.bathroom_reinforcements	= getentarray( "bathroom_reinforcements_spawner", "script_noteworthy" );
	level.riot_shield				= getentarray( "riot_shield_spawner", "script_noteworthy" );
	level.riot_escort				= getentarray( "riot_escort_spawner", "script_noteworthy" );

	if ( randomize )
	{
		array_randomize( level.bathroom_initial );
		array_randomize( level.bathroom_balcony );
		array_randomize( level.bathroom_reinforcements );
		array_randomize( level.riot_shield );
		array_randomize( level.riot_escort );
	}
	
	// Purge the riot_shield guys not actually used in the bathroom.
	for ( i = 0; i < level.riot_shield.size; i++ )
	{
		if ( level.riot_shield[i].classname ==  "actor_enemy_arctic_SMG" )
			level.riot_shield[i] = undefined;
	}
	array_removeUndefined( level.riot_shield );
}

reduce_enemy_spawner_count( count )
{
	for ( i = 0; i < self.size; i++ )
	{
		if ( i >= count )
			self[i].count = 0;
	}
}

so_showers_timed_setup_regular()
{
	level.challenge_objective = &"SO_SHOWERS_GULAG_OBJ_REGULAR";
}

so_showers_timed_setup_hardened()
{
	level.challenge_objective = &"SO_SHOWERS_GULAG_OBJ_HARDENED";
}

so_showers_timed_setup_veteran()
{
	level.challenge_time_limit = 180; 
	level.challenge_objective = &"SO_SHOWERS_GULAG_OBJ_VETERAN";
}

gulag_shower_challenge_music()
{
	level waittill( "slowmo_breach_ending" );
	wait( 2 );
	
	while ( 1 )
	{
		MusicPlayWrapper( "airplane_alt_music" );
		wait 212;
	}
}

challenge_only_think()
{
	if ( level.start_point == "so_showers" )
	{
		if ( self.classname == "script_model" )
		{
			self setcandamage( true );
		}
		return;
	}
	
	if ( self.classname == "script_brushmodel" )
		self connectpaths();
	
	self delete();
}

// ---------------------------------------------------------------------------------
//	NEED TO PURGE AND CLEAN EVERYTHING BELOW
// ---------------------------------------------------------------------------------


gulag_introscreen()
{
	level.player FreezeControls( true );

	introblack = create_client_overlay( "black", 1, level.player );

	wait( 0.5 );

	lines = [];
	// SEAL Team Six, U.S.N.
	lines[ lines.size ] = &"GULAG_INTROSCREEN_LINE_4";// "SEAL Team Six, U.S.N."
	// P03 'Roach' Silvers
	lines[ lines.size ] = &"GULAG_INTROSCREEN_LINE_3";// "P03 'Roach' Silvers"
	// Northern Russia - 09:20:[{FAKE_INTRO_SECONDS:02}] hrs
	lines[ "date" ] = &"GULAG_INTROSCREEN_LINE_2";// "Northern Russia - 09:20:[{FAKE_INTRO_SECONDS:02}] hrs"
	// The Gulag
	lines[ lines.size ] = &"GULAG_INTROSCREEN_LINE_1";// "The Gulag"
	level thread maps\_introscreen::introscreen_feed_lines( lines );

	wait( 2 );

	introblack FadeOverTime( 4 );
	introblack.alpha = 0;

	wait( 1 );

	level.player FreezeControls( false );

	wait( 3 );
	introblack Destroy();
}



// sets McCord up with stuff he needs to test the map
gulag_no_game_start_setupFunc()
{
	maps\_loadout::init_loadout();

	level.spawn_funcs = [];
	level.spawn_funcs[ "allies" ] = [];
	level.spawn_funcs[ "axis" ] = [];
	level.spawn_funcs[ "neutral" ] = [];

	maps\_nightvision::main( level.players );
	level.player SetActionSlot( 1, "nightvision" );
}

start_empty()
{
}

gulag_flyin()
{
	delaythread( 5.5, ::music_loop, "gulag_intro", 240 );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "hud_showStance", 0 );
	setSavedDvar( "hud_drawhud", 0 );

	array_spawn_function_noteworthy( "goal_delete_spawner", ::delete_on_player_land );

	thread control_room_destructibles_turn_on();

	// helis that hit this will create smoke as they fly through it
	heli_smoke_triggers = GetEntArray( "heli_smoke_trigger", "targetname" );
	array_thread( heli_smoke_triggers, ::heli_smoke_trigger_think );

	thread gulag_top_drones();
	thread spawn_f15s();
	thread maps\_introscreen::introscreen_generic_white_fade_in( 0.5, 1 );

	timer = GetTime();
	level.good_tone_timer = GetTime();
	going_in_hot = GetEnt( "going_in_hot", "script_noteworthy" );
	going_in_hot add_spawn_function( ::going_in_hot );

	thread spawn_player_heli();

	spawners = GetEntArray( "intro_heli_1", "targetname" );
	thread spawn_friendly_helis( spawners );

	//level thread gulag_introscreen();

	player_heli = level.player_heli;



	wait( 1.2 );

	// Thirty seconds.	
	thread radio_dialogue( "gulag_rpt_30sec" );

	// Hornet Two-One, this is Jester One-One, flight of two F-15s, four HARMs for the section, standby for SEAD (pr. see-add) over.	
	delayThread( 2.7, ::radio_dialogue, "gulag_hrp1_angelsone" );

	// Solid copy Jester. Go get 'em.	
	delayThread( 3, ::radio_dialogue, "gulag_lbp1_gogetem" );

	// Good tone good tone - Fox three fox three.	
	delayThread( 12, ::radio_dialogue, "gulag_fp1_goodtone" );

	wait( 21 );

	// Good kill good kill!	
	thread radio_dialogue( "gulag_fp2_goodkill" );

	// Hornet Two-One you're cleared all the way in. Have a nice day.	
	thread radio_dialogue( "gulag_fp1_niceday" );

	// Hornet Two-One copies.	
	thread radio_dialogue( "gulag_lbp1_copies" );

	// Two-two copies all.	
	thread radio_dialogue( "gulag_lbp2_copiesall" );

	// Two-Three solid copy.	
	thread radio_dialogue( "gulag_lbp3_solidcopy" );
}

start_approach()
{
	array_spawn_function_noteworthy( "goal_delete_spawner", ::delete_on_player_land );
	thread gulag_top_drones();
	flag_set( "display_introscreen_text" );
}

gulag_approach()
{
	/#
	if ( level.start_point == "approach" )
	{
		// teleport the helis to closer in positions
		heli_intro_player = GetEnt( "heli_intro_player", "targetname" );
		player_start = getstruct( "start_approach", "script_noteworthy" );
		heli_intro_player.origin = player_start.origin;
		remap_targets( heli_intro_player.target, player_start.targetname );
		heli_intro_player.target = player_start.targetname;

		friendly_starts = getstructarray( "start_approach_friendly", "script_noteworthy" );
		friendly_heli_spawners = GetEntArray( "intro_heli_1", "targetname" );
		foreach ( index, spawner in friendly_heli_spawners )
		{
			remap_targets( spawner.target, friendly_starts[ index ].targetname );
			spawner.origin = friendly_starts[ index ].origin;
			spawner.target = friendly_starts[ index ].targetname;
		}

		going_in_hot = GetEnt( "going_in_hot", "script_noteworthy" );
		going_in_hot add_spawn_function( ::going_in_hot );
		thread spawn_player_heli();

		spawners = GetEntArray( "intro_heli_1", "targetname" );
		thread spawn_friendly_helis( spawners );

		level.player SetPlayerAngles( ( 0, -163, 0 ) );
		level.player_heli Vehicle_SetSpeedImmediate( 84, 84 / 4, 84 / 4 );
	}
	else
	if ( level.start_point == "landing_test" )
	{
		// teleport the helis to closer in positions
		heli_intro_player = GetEnt( "heli_intro_player", "targetname" );
		player_start = getstruct( "start_approach", "script_noteworthy" );
		heli_intro_player.origin = player_start.origin;
		remap_targets( heli_intro_player.target, player_start.targetname );
		heli_intro_player.target = player_start.targetname;

		friendly_starts = getstructarray( "start_approach_friendly", "script_noteworthy" );
		new_start = getstruct( "test_unload_node", "script_noteworthy" );
		friendly_starts[ 2 ] = new_start;
		friendly_heli_spawners = GetEntArray( "intro_heli_1", "targetname" );
		foreach ( index, spawner in friendly_heli_spawners )
		{
			remap_targets( spawner.target, friendly_starts[ index ].targetname );
			spawner.origin = friendly_starts[ index ].origin;
			spawner.target = friendly_starts[ index ].targetname;
		}

		going_in_hot = GetEnt( "going_in_hot", "script_noteworthy" );
		going_in_hot add_spawn_function( ::going_in_hot );
		thread spawn_player_heli();

		spawners = GetEntArray( "intro_heli_1", "targetname" );
		thread spawn_friendly_helis( spawners );

		level.player SetPlayerAngles( ( 0, -163, 0 ) );
		level.player_heli Vehicle_SetSpeedImmediate( 84, 84 / 4, 84 / 4 );

		level.player Unlink();
		gulag_center = GetEnt( "gulag_center", "targetname" );
		level.player SetOrigin( gulag_center.origin );
	}

	#/

	// guys that ignore you at first then run over to fight	
	//array_spawn_function_noteworthy( "exploding_ignore_spawner", ::exploding_ignore_spawner_think );


	flag_wait( "display_introscreen_text" );
	
	wait( 2.2 );
	// autosave
	SaveGame( "approach", &"AUTOSAVE_AUTOSAVE", " ", true );
	
	lines = [];
	lines[ lines.size ] = &"GULAG_INTROSCREEN_1";
	lines[ "date" ] 	= &"GULAG_INTROSCREEN_2";
	lines[ lines.size ] = &"GULAG_INTROSCREEN_3";
	lines[ lines.size ] = &"GULAG_INTROSCREEN_4";
	lines[ lines.size ] = &"GULAG_INTROSCREEN_5";
	thread maps\_introscreen::introscreen_feed_lines( lines );


	flag_wait( "approach_dialogue" );



	wait( 1 );


	radio_dialogue_stop();

	// Two going in hot.	
	thread radio_dialogue( "gulag_lbp2_goinghot" );
	flag_set( "going_in_hot" );

	// Roger.	
	thread radio_dialogue( "gulag_lbp1_roger" );
	wait( 3.65 );

	delayThread( 7, ::blend_in_gulag_dof, 11 );

	//flag_wait( "guns_guns_guns" );

	//array_thread( level.deathFlags[ "first_tower" ][ "ai" ], ::glassy_pain );// temp thing to get some glass in the air

	//thread armed_heli_fires_turrets();

	wait( 0.5 );
	// Gunsgunsguns. guns guns guns	
	thread radio_dialogue( "gulag_lbp2_guns" );
	wait( 1.85 );

//	level.heli_armed mgOn();
	wait( 1 );

	// Gunsgunsguns.	
	thread radio_dialogue( "gulag_lbp2_guns2" );
	wait( 1.9 );

	delayThread( 4, ::kill_deathflag, "first_tower" );

//	delayThread( 2, ::flag_set, "num2_moves_on" );

	flag_set( "player_heli_uses_modified_yaw" );

	wait( 1 );
	// Two-two, two-one - good effect on target.	
	delayThread( 1, ::radio_dialogue_overlap, "gulag_lbp1_goodeffect" );


	foreach ( heli in level.friendly_helis )
	{
		heli mgon();
		foreach ( turret in heli.mgturret )
		{
			turret SetMode( "auto_nonai" );
		}
	}

//	level.player_heli_tag RotateTo( ( 0, 90, 0 ), 2, 1, 1 );
//	level.player PlayerLinkToBlend( level.player_heli_tag, "tag_origin", time, accel time, decel time);



	// Peeling.	
	//radio_dialogue( "gulag_lbp2_peeling" );


//	delayThread( 2, ::flag_set, "start_your_attack" );

	/*
	// Hornet Five-Three, go ahead and start your attack run.	
	radio_dialogue( "gulag_lbp1_startattack" );

	// Roger that. Rolling in.	
	radio_dialogue( "gulag_lbp3_rollingin" );
	*/


	level.stabilize_offset = 3;// how much the player heli rotates relative to the gulag center
	level.player_heli thread player_heli_rotates_properly_around_gulag();


	wait( 3.2 );

	// All snipers this is Raptor, standby to engage.	
	thread radio_dialogue( "gulag_rpt_stbyengage" );
	delayThread( 2, ::gulag_player_snipes );

	wait( 3 );

	// player heli flies up to a shooting position

	wait( 0.65 );
	// Stabilize.	
	thread radio_dialogue( "gulag_rpt_stabilize" );

	flag_wait( "stabilize" );

	/*
	
	// On target.	
	radio_dialogue( "gulag_tco_ontarget" );
	*/

	wait( 0.75 );
	// All snipers - cleared to engage.	
	thread radio_dialogue( "gulag_rpt_clearedengage" );
	delayThread( 2, ::flag_set, "soap_snipes_tower" );

	// Roger.	
	thread radio_dialogue( "gulag_lbp1_roger2" );

	delayThread( 8, ::kill_deathflag, "stab1_clear", 6 );

	old_time = GetTime();
	flag_wait( "stab1_clear" );
	//wait_for_buffer_time_to_pass( old_time, 6 );

	flag_clear( "stabilize" );
	flag_clear( "soap_snipes_tower" );
	wait( 0.75 );

	// Shift right.	
	wait( 0.75 );
	thread radio_dialogue( "gulag_rpt_shiftright" );
	wait( 1.25 );
	flag_set( "stab1_shift" );

	// Shifting.	
	thread radio_dialogue( "gulag_lbp1_shifting" );

//	timer = GetTime();
	flag_wait( "stabilize" );
//	Assert( timer != GetTime() );

	delayThread( 2, ::flag_set, "soap_snipes_tower" );

	// thread off so the dialogue can cut off if the tower is killed
	thread second_tower_stabilize_dialogue();
	// Stabilize.	
	// Ready.	
	// On target.	


	delayThread( 8, ::kill_deathflag, "second_tower_clear", 4 );
	//flag_wait( "second_tower_clear" );
	wait( 4 );

	car_blows_up = GetEnt( "car_blows_up", "script_noteworthy" );
	RadiusDamage( car_blows_up.origin, 1200, 5000, 5000 );


	tarp_puller_spawners = GetEntArray( "tarp_puller_spawner", "targetname" );
	array_thread( tarp_puller_spawners, ::spawn_ai );



	/*
	// the tarp ents are in a prefab so just find the nearest
	tarp_ents = GetEntArray( "tarp_pull_org", "targetname" );
	slamraam_center = GetEnt( "slamraam_center", "script_noteworthy" );
	tarp = getClosest( slamraam_center.origin, tarp_ents );
	tarp waittill( "tarp_activate" );
	*/
	level waittill( "tarp_activate" );

//	flag_set( "slamraam_gets_players_attention" );
//	wait( 0.7 );
//	tarp thread slamraam_attacks( 1.5, 2.3 );
	delayThread( 4, ::kill_deathflag, "sam_cleared", 2.5 );

	//old_time = GetTime();
	flag_wait( "sam_cleared" );
	flag_clear( "soap_snipes_tower" );
	//wait_for_buffer_time_to_pass( old_time, 6 );

	wait( 0.5 );





//	thread debug_heli_times();

	// Shift right.	
	delayThread( 2.2, ::exploder, "main_building" );
	thread radio_dialogue( "gulag_rpt_shiftright2" );
//	wait( 1.25 );


	wait( 1.5 );
	flag_set( "stab2_clear" );

//	delayThread( 8, ::kill_deathflag, "stab2_clear" );
//	flag_wait( "stab2_clear" );
	flag_clear( "stabilize" );

	// Shifting.	
	radio_dialogue( "gulag_lbp1_shifting2" );
}

start_perimeter()
{
	array_spawn_function_noteworthy( "goal_delete_spawner", ::delete_on_player_land );
	thread gulag_top_drones();

	// teleport the helis to closer in positions
	heli_intro_player = GetEnt( "heli_intro_player", "targetname" );
	player_start = getstruct( "start_player_perimeter", "script_noteworthy" );
	heli_intro_player.origin = player_start.origin;
	heli_intro_player.angles = player_start.angles;
	remap_targets( heli_intro_player.target, player_start.targetname );
	heli_intro_player.target = player_start.targetname;

	thread spawn_player_heli();

	level.player SetPlayerAngles( ( 0, -163, 0 ) );
	speed = 24;
	level.player_heli Vehicle_SetSpeedImmediate( speed, speed / 4, speed / 4 );

	level.stabilize_offset = 3;// how much the player heli rotates relative to the gulag center
	level.player_heli thread player_heli_rotates_properly_around_gulag();
	blend_in_gulag_dof( 3 );
}

start_f15()
{
	array_spawn_function_noteworthy( "goal_delete_spawner", ::delete_on_player_land );

	// teleport the helis to closer in positions
	heli_intro_player = GetEnt( "heli_intro_player", "targetname" );
	player_start = getstruct( "f15_attack_start", "script_noteworthy" );
	heli_intro_player.origin = player_start.origin;
	heli_intro_player.angles = player_start.angles;
	remap_targets( heli_intro_player.target, player_start.targetname );
	heli_intro_player.target = player_start.targetname;

	thread spawn_player_heli();

//	level.player SetPlayerAngles( ( 0, -163, 0 ) );
	speed = 40;
	level.player_heli Vehicle_SetSpeedImmediate( speed, speed / 4, speed / 4 );

	level.stabilize_offset = 3;// how much the player heli rotates relative to the gulag center
	level.player_heli thread player_heli_rotates_properly_around_gulag();
	blend_in_gulag_dof( 3 );
}

/*
}

start_unload()
{
	// teleport the helis to closer in positions
	heli_intro_player = GetEnt( "heli_intro_player", "targetname" );
	player_start = getstruct( "start_unload", "script_noteworthy" );
	heli_intro_player.origin = player_start.origin;
	heli_intro_player.angles = player_start.angles;
	remap_targets( heli_intro_player.target, player_start.targetname );
	heli_intro_player.target = player_start.targetname;

	friendly_starts = getstructarray( "start_unload_friendly", "script_noteworthy" );
	friendly_heli_spawners = GetEntArray( "intro_heli_1", "targetname" );
	foreach ( index, spawner in friendly_heli_spawners )
	{
		remap_targets( spawner.target, friendly_starts[ index ].targetname );
		spawner.origin = friendly_starts[ index ].origin;
		spawner.target = friendly_starts[ index ].targetname;
	}

	thread spawn_player_heli();

	spawners = GetEntArray( "intro_heli_1", "targetname" );
	thread spawn_friendly_helis( spawners );


	level.player SetPlayerAngles( ( 0, -163, 0 ) );
	level.player_heli Vehicle_SetSpeedImmediate( 84, 84 / 4, 84 / 4 );

	level.stabilize_offset = 3;// how much the player heli rotates relative to the gulag center
	level.player_heli thread player_heli_rotates_properly_around_gulag();
}

gulag_landing()
{
*/

gulag_perimeter()
{

	thread f15_gulag_attack();

//	plane_sound_nodes = GetVehicleNodeArray( "plane_sound", "script_noteworthy" );
//	array_thread( plane_sound_nodes, maps\_f15::plane_sound_node );

	flag_set( "gulag_perimeter" );
	// I see 4 hostiles on the next tower!	
	level.soap delaythread( 1.8, ::dialogue_queue, "gulag_cmt_seehostiles" );
	
	flag_wait( "f15_gulag_explosion" );
	
	wait( 2 );
//	level.friendlyFireDisabled = 1;
	autosave_by_name( "gulag_perimeter" );
	// when you duck behind the main fortress, new helis spawn in so they are timed with you
	//thread prepare_perimeter_slamraam_attack();

	level.player GiveWeapon( "m4m203_reflex" );

	level notify( "stop_gulag_drones" );


	/*
	flag_wait( "slamraam_killed_2" );
	
	exploding_tower_spawners = GetEntArray( "exploding_tower_spawner", "targetname" );
	//delaythread( 2.5, ::array_spawn, exploding_tower_spawners );
	
	wait( 3 );
	flag_set( "move_to_boom_tower" );

	level.player_heli waittill( "reached_dynamic_path_end" );
	level.player_heli SetNearGoalNotifyDist( 8 );
	level.player_heli waittill_any( "near_goal", "goal" );

	thread explosion_knocks_player_heli_out_of_control();
	
	flag_wait( "player_heli_backs_up" );
	*/

	// Hang on!	
	thread radio_dialogue( "gulag_lbp1_hangon" );

	wait( 1.2 );
	// Command, we need those Russian naval vessels to cease fire immediately! That was too close!	
	iprint( "Hargrove, get the navy to cease fire immediately! That was too close!" );
	thread radio_dialogue( "gulag_rpt_tooclose" );

	/*
	level.friendlyFireDisabled = 0;
	//level.stabilize_offset = 5; // how much the player heli rotates relative to the gulag center
	flag_wait( "stabilize" );

	// Stabilize.	
	thread radio_dialogue( "gulag_rpt_stabilize3" );

	// Ready.	
	thread radio_dialogue( "gulag_lbp1_ready2" );

	// On target.	
	//radio_dialogue( "gulag_wrm_ontarget2" );

	// On target.	
	thread radio_dialogue( "gulag_tco_ontarget2" );

	// Take 'em out.	
	thread radio_dialogue( "gulag_rpt_takeemout" );

//	delayThread( 8, ::kill_deathflag, "stab3_clear" );
	wait( 6.15 );
	thread radio_dialogue( "gulag_rpt_shiftright" );
	wait( 1.5 );
	//flag_set( "stab3_clear" );

	flag_clear( "stabilize" );

	flag_wait( "stabilize" );
	thread radio_dialogue( "gulag_rpt_stabilize" );
	// First wave going in.	
	thread radio_dialogue( "gulag_lbp2_firstwave" );

	wait( 4 );
	exploder( 40 );
	delayThread( 0.25, ::exploder, 93 );
	wait( 0.5 );
	flag_set( "stab4_clear" );



	tower_4_radius_damage = GetEnt( "tower_4_radius_damage", "targetname" );
	RadiusDamage( tower_4_radius_damage.origin, tower_4_radius_damage.radius, 2000, 2000 );

	//wait( 0.8 );
	level notify( "stop_gulag_drones" );
	// Hang on!	
	thread radio_dialogue( "gulag_lbp1_hangon" );

	// Command, we need those Russian naval vessels to cease fire immediately! That was too close!	
	thread radio_dialogue( "gulag_rpt_tooclose" );

	*/

	thread bhd_heli_attack_setup();

	// makes the friendlies go the right way
	ai_field_blocker = GetEnt( "ai_field_blocker", "targetname" );
	ai_field_blocker Solid();
	ai_field_blocker DisconnectPaths();


	noself_delayCall( 11, ::SetSavedDvar, "g_friendlyNameDist", 15000 );

	battlechatter_off( "allies" );
	delayThread( 41, ::battlechatter_on, "allies" );
	thread friendlies_traverse_gulag_exterior();

	iprint( "The navy doesn't care about one man in a Gulag. I'll try to buy you some time but I can't promise much." );
	// Roger, we are currently negotiating with the commander of Russian naval forces for more time. Out.	
	thread radio_dialogue( "gulag_hqr_moretime" );

	// Crazy motherfu**ers. Are these the good Russians or the bad Russians!	
	thread radio_dialogue( "gulag_tco_goodorbad" );

	// Taco cut the chatter. Stay frosty.	
	thread radio_dialogue( "gulag_rpt_cutchatter" );

	/*	
	// Three-One, troops are on the deck.	
	thread radio_dialogue( "gulag_lbp2_ondeck";
	
	// This is Three-One, troops are on the deck, going into holding pattern.	
	thread radio_dialogue( "gulag_lbp2_holdingpatt";
	*/

	// Second wave going in. Standby.	
	thread radio_dialogue( "gulag_lbp1_2ndwave" );

	//// Fifty feet.	
	//thread radio_dialogue( "gulag_lbp1_50ft";

	// Ten feet.	
	thread radio_dialogue( "gulag_lbp1_10ft" );

	thread gulag_landing_update_entities();	

	//wait( 4 );
	level.player_heli waittill( "nearing_landing" );
	
	thread soap_paths_to_node_then_leads();
	

	// Two-One touching down at target.	
	thread radio_dialogue( "gulag_lbp1_touchdown" );

	// Team One is deployed. Going into holding pattern.	
	thread radio_dialogue( "gulag_lbp1_deployed" );

	// Five-Three going into overhead pattern to provide sniper cover, over.	
	thread radio_dialogue( "gulag_lbp3_snipercover" );

	// Five-Three, this is Two-One, solid copy on all.	
	thread radio_dialogue( "gulag_lbp1_solidcopy" );

	// Go! Go! Go!	
	thread radio_dialogue( "gulag_rpt_gogogo" );

	level.soap StopLookAt();


//	flag_wait( "player_lands" );
	level.player_heli waittill( "stable_for_unlink" );
	level.player PlayerSetGroundReferenceEnt( undefined );
	
	ai = getaiarray( "allies" );
	foreach ( guy in ai )
	{
		guy pathrandompercent_set( 200 );
	}


	// point the player off the heli at the right angle then unlink
	angles = level.player_view_controller GetTagAngles( "tag_aim" );
	angles = ( 0, angles[ 1 ], 0 );
	forward = AnglesToForward( angles );
	forward *= 32;
	
	/*
	ent = spawn_tag_origin();
	ent.origin = level.player.origin;

	level.player PlayerLinkToDelta( ent, "tag_origin", 1, 180, 180, 90, 90, true );
	level.player_view_controller Delete();
	movetime = 0.5;
	ent MoveTo( ent.origin + forward + (0,0,8), movetime, 0.2, 0.2 );
	wait( movetime );
	*/

	ent = spawn_tag_origin();
	ent.origin = level.player_view_controller.origin;
	ent.angles = level.player_view_controller.angles;

	level.player_view_controller linkto( ent );
	movetime = 0.2;
	ent moveto( ent.origin + forward + (0,0,4), movetime, 0.1, 0.1 );
	wait( movetime );
	level.player_view_controller delete();
	ent delete();
	//level.player Unlink();
	level.player AllowCrouch( true );
	level.player AllowProne( true );

	autosave_by_name( "player_lands" );

	level.soap forceUseWeapon( "m4m203_reflex", "primary" );
	flag_set( "access_control_room" );
	
	


	//activate_trigger_with_targetname( "friendly_gulag_top" );

	/*
	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay FadeOverTime( 1 );
	black_overlay.alpha = 1;
	wait( 2 );
	nextmission();
	*/

}

start_control_room()
{
	spawners = GetEntArray( "start_controlroom_spawner", "targetname" );
	spawners = update_soap_spawner( spawners );
	array_thread( spawners, ::spawn_ai );


	player_org = GetEnt( "start_controlroom_player", "targetname" );
	level.player SetOrigin( player_org.origin );
	level.player SetPlayerAngles( player_org.angles );
}

soap_chats_outside_gulag()
{
	flag_init( "soap_chats_outside_gulag" );
	// This is it! We go in, grab Prisoner 627, and get out! Ready?	
	level.soap dialogue_queue( "gulag_cmt_getout" );

	// Check your corners! Let's go!	
	level.soap thread dialogue_queue( "gulag_cmt_checkcorners" );
	wait( 1.5 );
	flag_set( "soap_chats_outside_gulag" );
}

gulag_cellblocks()
{
	flag_wait( "player_progresses_passed_ext_area" );
	kill_deathflag( "upper_balcony_deathflag", 4 );
	activate_trigger_with_targetname( "ext_finished" );
		
	flag_wait( "postup_outside_gulag" );
	
	ai = getaiarray( "allies" );
	foreach ( guy in ai )
	{
		guy pathrandompercent_reset();
	}
	
	
	add_global_spawn_function( "axis", ::ambush_behavior );
	add_global_spawn_function( "allies", ::enable_cqbwalk );
	

	//  This is it. We need to get in there, break him out of the cellblock, and get out.
	//  Ok, let's go! Check those corners.

	//  <Ghost> The control hub is up ahead. I can use it to find Prisoner #627.

	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy.baseaccuracy = 1;
		guy.attackeraccuracy = 1;
	}
//	array_thread( ai, ::set_force_color, "g" );

	// wait for these 2 to die before moving in
	flag_wait_either( "last_outside_guys", "player_moves_into_gulag" );

	level.soap set_force_color( "cyan" );
	activate_trigger_with_targetname( "outside_gulag_postup" );

	flag_wait_either( "outside_gulag_dialogue", "enable_interior_fx" );
	
	thread soap_chats_outside_gulag();
	flag_wait_either( "soap_chats_outside_gulag", "enable_interior_fx" );
	



	friendly_respawn_trigger = GetEnt( "friendly_reinforcement_trigger", "targetname" );
	friendly_respawn_trigger thread reinforcement_friendlies();


	

	// In this section of script, the 2 guys standing in the volume get to be purple guys and stand in a certain spot.
	// If we cant find two non heroes in the volume then other guys become purple. The rest of the non heroes become
	// orange.
	volume = getent( "purple_friendlies_priority_volume", "targetname" );
	ai = getaiarray( "allies" );
	ai = remove_heroes_from_array( ai );
	
	purple_guys = 0;
	foreach ( index, guy in ai )
	{
		if ( guy istouching( volume ) )
		{
			purple_guys++;
			guy set_force_color( "p" );
			ai[ index ] = undefined;
		}
	}
	
	ai = remove_dead_from_array( ai );
	for ( i = purple_guys; i < 2; i++ )
	{
		if ( !isalive( ai[ i ] ) )
			continue;
			
		ai[ i ] set_force_color( "p" );
		ai[ i ] = undefined;
	}
	
	ai = remove_dead_from_array( ai );
	foreach ( guy in ai )
	{
		guy set_force_color( "o" );
	}
	
	activate_trigger_with_targetname( "pre_controlroom_postup" );

	//thread gulag_cellblocks_friendlies_go_to_control_room();
	activate_trigger_with_targetname( "control_room_postup" );
	
//	flag_wait( "enable_interior_fx" );
	
		
	
	flag_wait( "disable_exterior_fx" );

	// That's the control room up ahead! I can use it to find our prisoner!	
	radio_dialogue( "gulag_gst_controlroom" );


	// player enters the control room
	flag_wait( "control_room" );
	
	thread gulag_cellblocks_spotlight();
	//flag_set( "open_cell_door1" );

	if ( isalive( level.ghost ) )
	{
		level.ghost disable_ai_color();
	}
	else
	{
		assertex( !is_default_start(), "Ghost was dead on default start!" );
	}
		

	ai = GetAIArray( "allies" );
	excluders = [];
	excluders[ 0 ] = level.soap;
	excluders[ 1 ] = level.ghost;
	ai = get_array_of_closest( level.player.origin, ai, excluders );

	extra_friendlies = 2;
	// the 2 closest guys stay on the friendly chain
	for ( i = 0; i < extra_friendlies; i++ )
	{
		guy = ai[ i ];
		guy set_force_color( "g" );
		guy allies_have_low_attacker_accuracy();
	}

	for ( i = extra_friendlies; i < ai.size; i++ )
	{
		ai[ i ] disable_ai_color();
	}

	add_global_spawn_function( "allies", ::allies_have_low_attacker_accuracy );

	wait_while_enemy_near_player();
	battlechatter_off( "allies" );

	
	// I'll tap into their system and look for the prisoner! It's gonna take some time!	
	radio_dialogue( "gulag_cmt_tapinto" );
	
	flag_set( "cell_duty" );

	thread friendly_cellblock_respawner();

	activate_trigger_with_targetname( "first_cell_postup" );

	
	// Copy that! Roach, we're on cell duty! Follow me!	
	level.soap dialogue_queue( "gulag_cmt_cellduty" );

	flag_wait( "player_nears_cell_door1" );
	
	// All right, I'm patched in. I'm tracking your progress on the security cameras.	
	radio_dialogue( "gulag_gst_patchedin" );
	
	// Copy that! Do you have the location of Prisoner 627?	
	level.soap dialogue_queue( "gulag_cmt_location" );
	
	// Negative, but I've got a searchlight tracking hostiles on your floor. That should make your job easier.	
	radio_dialogue( "gulag_gst_jobeasier" );
	
	// Roger that! Roach! Stay sharp! The prisoner may be in one of these cells!	
	level.soap dialogue_queue( "gulag_cmt_staysharp" );


	battlechatter_on( "allies" );

//	activate_trigger_with_targetname( "vol_blocked_by_celldoor2" );

	flag_wait( "player_nears_cell_door2" );
	
	thread insure_player_has_enemies_to_fight_for_door_sequence();

	// Ghost, we've hit a security door, get it open!	
	level.soap dialogue_queue( "gulag_cmt_secdoor" );

	// Workin' on it...this hardware is ancient!	
	thread radio_dialogue( "gulag_cmt_ancient" );
	wait( 2.5 );

	flag_set( "open_cell_door3" );
	wait( 3 );

	// Ghost, you opened the wrong door!
	level.soap dialogue_queue( "gulag_cmt_wrongdoor" );
	// Roger, standby
	thread radio_dialogue( "gulag_gst_standby" );

	wait( 3 );

	flag_set( "open_cell_door2" );

	// got it
	radio_dialogue( "gulag_gst_gotit2" );
	activate_trigger_with_targetname( "mid_door_opens" );

	wait( 1 );

	// That's better, let's go!	
	level.soap dialogue_queue( "gulag_cmt_thatsbetter" );
//	activate_trigger_with_targetname( "vol_blocked_by_celldoor3" );

	flag_wait( "player_nears_cell_door3" );
	

	//activate_trigger_with_targetname( "vol_blocked_by_celldoor4" );

	flag_wait( "player_nears_cell_door4" );
	

	delaythread( 3.5, ::flag_set, "open_cell_door4" );
	
	// Talk to me Ghost...these cells are deserted! 	
	level.soap dialogue_queue( "gulag_cmt_talktome" );
	
	enemies_retreat_and_delete();
	
	// Got it! Prisoner 627's been transferred to the east wing! Head through the armory in the center - that's the fastest way there.	
	radio_dialogue( "gulag_gst_eastwing" );
	
	// Roger that! Roach, head for that armory down there! Move!	
	level.soap thread dialogue_queue( "gulag_cmt_armorydownthere" );
	activate_trigger_with_targetname( "pre_armory" ); // note targetname
	wait( 2.3 );
	

	//  Ghost, the cells are deserted, what's going on?
	//  The prisoner has been moved. The fastest way out of the cellblocks is to cut through the armory in the center.
	//  Alright follow me, we'll stock up while Ghost finds our man.
	
	// Ok - next door in three, two -	
	
//	level waittill( "opened_cell_door4" );
	flag_set( "pre_armory_open" );
	activate_trigger_with_noteworthy( "pre_armory" ); // note, noteworthy
	

	flag_wait( "player_approaches_armory" );
	ai = GetAIArray( "axis" );
	array_thread( ai, ::die_soon );
}

start_armory()
{
	thread gulag_cellblocks_spotlight();

	flag_set( "player_nears_cell_door1" );
	flag_set( "pre_armory_open" );
	
	activate_trigger_with_noteworthy( "pre_armory" );
	
	spawners = GetEntArray( "start_armory_spawner", "targetname" );
	spawners = update_soap_spawner( spawners );
	array_thread( spawners, ::spawn_ai );

	player_org = GetEnt( "start_armory_player", "targetname" );
	level.player SetOrigin( player_org.origin );
	level.player SetPlayerAngles( player_org.angles );

	wait( 0.05 );	
	level.soap set_force_color( "cyan" );
}

gulag_armory()
{
	level.soap forceUseWeapon( "mp5", "primary" );
	
	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy disable_heat_behavior();
		guy delayThread( 3, ::enable_dontevershoot );
	}
	thread battlechatter_off( "axis" );
	thread battlechatter_off( "allies" );

	flag_wait( "player_in_armory" );

	// See anything you like?	
	level.soap thread dialogue_queue( "gulag_cmt_seeanything" );
	wait( 1.5 );

	level.armory_laser_index = 0;// used for good timing on lasers
	add_global_spawn_function( "axis", ::armory_laser_ambush );

	wait( 1.5 );
	
	// spotlight points at baddies again
	level.spotlight_override_pos = undefined;

	// bunch of baddies spawn in and laser you
	activate_trigger_with_targetname( "cellblock_armory_attackers_trigger" );

	cellblock_armory_attacker_spawners = GetEntArray( "cellblock_armory_attacker_spawner", "targetname" );
	array_thread( cellblock_armory_attacker_spawners, ::spawn_ai );

	wait( 3 );

	ai = GetAIArray( "allies" );
	array_thread( ai, ::disable_dontevershoot );

	wait( 0.5 );
	// friendlies run to the edges
	activate_trigger_with_targetname( "armory_attacked_postup" );
	wait( 1.5 );
	
	// Ghost! We're getting pinned down here! Open the armory gate! Hurry!	
	level.soap dialogue_queue( "gulag_cmt_openarmory" );



	// Grab a riot shield!	
	level.soap dialogue_queue( "gulag_cmt_riotshield" );
	
	
	riotshield_friendlies = [];
	ai = getaiarray();
	foreach ( guy in ai )
	{
		if ( !isdefined( guy.armory ) )
			continue;

		guy thread guy_gets_riotshield();
		riotshield_friendlies[ riotshield_friendlies.size ] = guy;
	}

	//level.soap subclass_riotshield()


	// We've got company!!	
//	level.soap dialogue_queue( "gulag_cmt_gotcompany" );



	activate_trigger_with_targetname( "escape_armory" );

	// evil baddies stop shooting and throw grenades!
	/*
	wait( 2 );
	ai = GetAIArray( "axis" );
	array_thread( ai, ::enable_dontevershoot );

	ai = GetAIArray( "axis" );
	foreach( guy in ai )
	{
		timer = RandomFloat( 2 );
		guy delayCall( timer, ::LaserForceOff );
	}

	wait( 3 );
	*/


	/*
	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy.grenadeawareness = 0;
	}
	*/


	wait( 1.5 );
	flag_set( "open_cell_door_weapons" );

	//cellblock_spawn_lots_of_grenades();
	wait( 4.5 );

	// Open the door!!	
	level.soap dialogue_queue( "gulag_cmt_openthedoor" );

	//  <Ghost> Working on it, the main circuit's dead.."
	// Almost there. Standby.	
	radio_dialogue( "gulag_gst_almostthere" );
//	wait( 1.25 );
	//  <Ghost> Almost there, routing through the auxilary circuit.. got it!"
	// Got it.	
	thread radio_dialogue( "gulag_gst_gotit" );

	//  Go go go!

//	wait( 1.5 );
	//flag_set( "open_cell_door_weapons" );
	wait( 2.5 );
	level notify( "force_door_open" );
	
	level waittill( "cell_door_opens" );
	
	activate_trigger_with_targetname( "post_armory" );
	
	flag_wait( "run_from_armory" );
	kill_volume = getent( "run_from_armory_kill_volume", "targetname" );
	ai = kill_volume get_ai_touching_volume( "axis" );
	foreach ( guy in ai )
	{
		guy thread die_soon();
	}
	
	remove_global_spawn_function( "axis", ::armory_laser_ambush );
	ai = GetAIArray( "axis" );
	array_call( ai, ::LaserForceOff );

	spawn_rappel_rope();
	thread cellblock_rappel_player();

	level notify( "stop_cellblock_respawn" );


	thread friendlies_ignore_grenades_for_awhile ();
	
	// Go go go! 	
	level.soap thread dialogue_queue( "gulag_cmt_gogogo1" );
	
	foreach ( guy in riotshield_friendlies )
	{
		guy enable_dontevershoot();
		guy riotshield_fastwalk_on();
	}
	
	/*
	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy.grenadeawareness = 0.9;
	}
	*/

	flag_wait( "use_your_riotshield" );
	
	if ( level.player getCurrentWeapon() == "riotshield" )
	{
		// player is using his riot shield, friendlies draw fire
		
		// Use your riot shield to draw their fire!	
		level.soap thread dialogue_queue( "gulag_cmt_usesheild" );
		
		ai = getaiarray( "allies" );
		foreach ( guy in ai )
		{
			guy clear_rioter();
		}
	}
	else
	{
		// player is firing, friendlies draw fire with riotshield

		// I'll draw their fire with the riot shield, you take 'em out!	
		level.soap thread dialogue_queue( "gulag_cmt_illdrawfire" );
	}

	flag_wait( "last_cellblock_guys_flee" );
	lower_cellblock_enemies_retreat_and_delete();
	

	flag_wait( "rappel_time" );
	
	thread rappel_time_dialogue();
}

rappel_time_dialogue()
{
	// Ghost here. Recommend you bypass the lower floors by rappelling out that window.	
	radio_dialogue( "gulag_gst_bypassfloors" );
	
	// Copy that! Roach, follow me!	
	level.soap dialogue_queue( "gulag_cmt_roachfollow" );
	
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
}

start_rappel()
{
	spawn_rappel_rope();

	spawners = GetEntArray( "start_rappel_spawner", "targetname" );
	spawners = update_soap_spawner( spawners );
	for ( i = 1; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::replace_on_death );
	}

	array_thread( spawners, ::spawn_ai );

	player_org = GetEnt( "start_rappel_player", "targetname" );
	level.player SetOrigin( player_org.origin );
	level.player SetPlayerAngles( player_org.angles );
	cellblock_rappel_player();
}

gulag_solitary_dialogue()
{
	// The camera feed in solitary confinement is dead. The power must be down in that section.	
	radio_dialogue( "gulag_gst_feedisdead" );
	
	// Roger that. Roach, switch to night vision.	
	level.soap dialogue_queue( "gulag_cmt_switchnv" );
}

gulag_rappel()
{
	gulag_hallway_collapse_setup();

	flag_set( "access_control_room" );
	flag_set( "control_room" );

	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy.baseaccuracy = 1;
		guy.attackeraccuracy = 1;
	}

	// kills the axis and waits if neccessary
	kill_all_axis();

	level.soap thread hero_rappels();

	flag_wait( "cellblock_player_starts_rappel" );

	// push the fog out a bit
	fog_set_changes( "gulag_hallways" );

	volume = GetEnt( "gulag_hallway_destructibles", "script_noteworthy" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();

	wait( 5 );

	level.soap set_force_color( "green" );
	activate_trigger_with_targetname( "cellblock_exit_postup" );
	
	thread gulag_solitary_dialogue();
	
	// delete the extraneous friendlies
	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		if ( guy is_hero() )
			continue;

		if ( IsDefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();

		guy Delete();
	}

	// spawn some reinforcements
	friendly_cellhall_spawners = GetEntArray( "friendly_cellhall_spawner", "targetname" );
	array_spawn_function( friendly_cellhall_spawners, ::replace_on_death );
	array_thread( friendly_cellhall_spawners, ::spawn_ai );


	flag_wait( "leaving_cellblock" );
	activate_trigger_with_targetname( "friendly_nvg_hallway_trigger" );

	// Switch to night vision.	
	//level.soap delayThread( 1.8, ::dialogue_queue, "gulag_cmt_switchnv" );
	level.player delayThread( 1.8, ::display_hint, "nvg" );

	flag_wait( "nvg_zone" );

	spawners = GetEntArray( "hallway_runner_spawner", "script_noteworthy" );
	nodes = GetNodeArray( "nvg_ambush_node", "targetname" );
	nodes = array_randomize( nodes );
	array_thread( nodes, ::nodes_are_periodically_bad );
	foreach ( index, spawner in spawners )
	{
		spawner.origin = nodes[ index ].origin;
	}

	activate_trigger_with_targetname( "friendly_nvg_cell_hall_postup" );

	thread nvg_hallway_fight();

	flag_wait( "nvg_moveup" );
	activate_trigger_with_targetname( "friendly_nvg_cell_hall_moveup" );

	flag_wait( "nvg_leave_cellarea" );
	DisableForcedSunShadows(); // bring back real sun
	exploder( "hall_attack_explosion" );
	level.player delaycall( 0.5, ::ShellShock, "gulag_attack", 5, false );
	level.player delaycall( 0.5, ::setstance, "prone" );
	Earthquake( 0.3, 3, level.player.origin, 5000 );
	level.player PlayRumbleloopOnEntity( "damage_heavy" );
	level.player delaycall( 2, ::StopRumble, "damage_heavy" );
	axis = getaiarray( "axis" );
	foreach ( guy in axis )
	{
		if ( distance( level.player.origin, guy.origin ) < 350 )
			guy delaycall( 0.5, ::kill );
	}
	
	delaythread( 1.5, ::exploder, "hall_attack" );
	
	add_wait( ::flag_wait, "nvg_disable_night_vision" );
	add_func( ::display_hint, "disable_nvg" );
	thread do_wait();
	
	vision_set_changes( "gulag_hallways", 4 );
	
	wait( 5 );
	thread soap_is_angry_about_attack();
	
	//thread gulag_hallway_explodes();

	activate_trigger_with_targetname( "nvg_hallway_fightnodes" );
	
	flag_wait( "nvg_disable_night_vision" );

//	flag_wait( "nvg_fight_spawner" );
	//spawners = getentarray( "nvg_fight_spawner", "targetname" );
	//array_thread( spawners, ::spawn_ai );
	//spawners = getentarray( "post_nvg_fight_spawner", "targetname" );
	//array_thread( spawners, ::spawn_ai );
	

//	flag_wait( "nvg_advance_onward" );
//	wait( 10.4 );
	activate_trigger_with_targetname( "pipe_tunnel_fight_nodes" );

	flag_wait( "go_to_pipearea_postup" );
	
	activate_trigger_with_targetname( "pipe_tunnel_postup" );

	//flag_wait( "cell_hallway_explodes" );

	//activate_trigger_with_targetname( "pipe_tunnel_postup" );
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
	
	flag_wait( "advance_through_pipearea" );
	EnableForcedNoSunShadows(); // gbye real sun

//	wait( 2 );
	iprint( "Its too narrow! Roach, sweep the corridor and we'll follow once its clear." );
	
	MusicStop( 10 );
	level notify ( "stop_music" );
	
	// Its too narrow! Roach, sweep the corridor and we'll follow once its clear! Go!	
	level.soap thread dialogue_queue( "gulag_cmt_toonarrow" );
	
	fog_set_changes( "gulag" );
	
	flag_wait( "friendlies_follow_pipe_area" );

	// Go go go! 	
	level.soap thread dialogue_queue( "gulag_cmt_gogogo1" );

	activate_trigger_with_targetname( "breach_bathroom_postup" );

	flag_wait( "nearing_bathroom_breach" );

	// The old shower room's about thirty feet ahead on your left. You'll have to breach the wall to get in.	
	thread radio_dialogue( "gulag_gst_30ftonleft" );
}


start_bathroom()
{
	// mbs on the one guy
	spawners = GetEntArray( "friendly_bathroom_spawner", "targetname" );
	spawners = update_soap_spawner( spawners );

	if ( level.start_point == "bathroom" )
	{
		for ( i = 1; i < spawners.size; i++ )
		{
			spawners[ i ] add_spawn_function( ::replace_on_death );
		}
	}

	array_thread( spawners, ::spawn_ai );
	
	start_point = getent( "start_bathroom_player", "targetname" );
	level.player SetOrigin( start_point.origin );
	level.player setPlayerAngles( start_point.angles );
	
	activate_trigger_with_targetname( "breach_bathroom_postup" );
}

enable_bathroom_complete_trigger()
{
	trigger_ent = getent( "player_rappels_from_bathroom", "script_noteworthy" );
	trigger_ent waittill( "trigger" );
	flag_set( "player_exited_bathroom" );
}

gulag_bathroom()
{
	fog_set_changes( "gulag" );

	flag_wait( "leaving_pipe_area" );
//	bathroom_spawn_rappel_rope();
//	flag_set( "breach_door_icon_" + 2 );

//	bathroom_c4 glow();
//	bathroom_c4 Show();

	level waittill( "breaching" );

	thread gulag_bathroom_music();
	
	volume = GetEnt( "gulag_shower_destructibles", "script_noteworthy" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();

	level.player.attackeraccuracy = 0;
	level.player delayThread( 6, maps\_gameskill::update_player_attacker_accuracy );

	flag_wait( "player_enters_bathroom" );

	thread maps\_ambient::activateAmbient( "gulag_shower_int0" );
	thread enable_bathroom_complete_trigger();

	// We got companyyy!	 // we've got company
	//level.soap delayThread( 3.5, ::dialogue_queue, "gulag_cmt_wegotcompany" );
	// Spread out!	
	level.soap delaythread( 3.5, ::dialogue_queue, "gulag_cmt_spreadout" );
	
	activate_trigger_with_targetname( "bathroom_initial_enemies" );
	
	//thread friendlies_traverse_showers();
	delay = 15;

	delayThread( delay, ::activate_trigger_with_targetname, "bathroom_balcony_room1_trigger" );

	// Hostiles on the second floor! Take them out!	
	level.soap delayThread( delay + 3, ::dialogue_queue, "gulag_cmt_hostiles2ndfloor" );

//	activate_trigger_with_targetname( "bathroom_postup1" );

	flag_wait( "bathroom_start_second_wave" );

	// more baddies come in

	bathroom_second_wave();

	// wait for the new enemies to reach mid-room, then friendlies fall back
	flag_clear( "bathrom_friendlies_fall_back" );
	
	// Use the lockers for cover!	
	add_wait( ::flag_wait, "use_lockers_for_cover" );
	level.soap add_func( ::dialogue_queue, "gulag_cmt_uselockers" );
	thread do_wait();		
	
	riot_shield_detector = getent( "riot_shield_detector", "targetname" );
	riot_shield_detector thread riot_shield_detector_think();
	

	add_wait( ::flag_wait, "bathrom_friendlies_fall_back" );
	add_wait( ::flag_wait, "bathroom_room2_enemies_dead" );
	add_wait( ::flag_wait, "player_exited_bathroom" );
	do_wait_any();

	if ( !flag( "bathroom_room2_enemies_dead" ) )
	{
		wait( 1 );

		allies = GetAIArray( "allies" );
		foreach ( guy in allies )
		{
			guy SetEngagementMaxDist( 2000, 2500 );
			guy SetEngagementMinDist( 700, 550 );
		}

		thread bathroom_periodic_autosave();

		// Keep moving!	
		level.soap thread dialogue_queue( "gulag_cmt_keepmoving" );
	}

	autosave_by_name( "bathroom_cleared" );

	//activate_trigger_with_targetname( "bathroom_vol2" );
	//flag_wait_or_timeout( "leaving_bathroom_vol2", 35 );
	flag_wait( "leaving_bathroom_vol2" );
	
	shower_friendly_triggers = getentarray( "shower_friendly_trigger", "targetname" );
	array_thread( shower_friendly_triggers, ::self_delete );
	
	// I’m heading for that hole in the floor on the far side of the showers! Follow me! Let's go!	
	level.soap thread dialogue_queue( "gulag_cmt_holeinfloor" );

	activate_trigger_with_targetname( "cistern_friendly_trigger" );

	//activate_trigger_with_targetname( "bathroom_vol3" );

	// Go go go! 	
	level.soap delayThread( 1.5, ::dialogue_queue, "gulag_cmt_gogogo1" );




	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy.attackeraccuracy = 0;
	}

	thread friendly_hole_rappel();
	//thread bathroom_rappel_player();

	//wait( 5 );
	/*
	activate_trigger_with_targetname( "bathroom_rappel" );
	wait( 0.1 );
	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		guy disable_ai_color();
	}

	*/
	
	flag_wait( "player_exited_bathroom" );
	flag_set( "gulag_shower_music_done" );

	run_thread_on_targetname( "slide_trigger", ::sewer_slide_trigger );
	
	ai = getaiarray( "bad_guys" );
	array_thread( ai, ::die_soon );

	
	thread maps\_ambient::activateAmbient( "gulag_exit" );

	autosave_by_name( "reached_sewers" );

	thread gulag_cistern_dialogue();
}

gulag_cistern_dialogue()
{
	if ( flag( "player_approaches_rescue_breach" ) )
		return;
	level endon( "player_approaches_rescue_breach" );
	
	flag_wait( "friendly_rappels_from_bathroom" );
	wait( 1.5 );
	// Ghost, we’re in the old tunnel system – which way?	
	level.soap dialogue_queue( "gulag_cmt_whichway" );

	// I'm checking the blueprints, standby. Ok. Head fifty meters along that tunnel to the west.	
	radio_dialogue( "gulag_gst_50meters" );
	activate_trigger_with_targetname( "breach_rescue_trigger" );
	wait( 3 );

	// Talk to me Ghost...I don’t want to be down here when those ships start firing again.	
	level.soap dialogue_queue( "gulag_cmt_startfiring" );

	// Keep going - you should see an old cistern in thirty meters.	
	radio_dialogue( "gulag_gst_cistern" );
}

start_rescue()
{
	// mbs on the one guy
	spawners = GetEntArray( "start_rescue_spawner", "targetname" );
	spawners = update_soap_spawner( spawners );
	for ( i = 1; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::magic_bullet_shield );
	}

	array_thread( spawners, ::spawn_ai );

	player_org = GetEnt( "start_rescue_player", "targetname" );
	level.player SetOrigin( player_org.origin );
	level.player SetPlayerAngles( player_org.angles );
	activate_trigger_with_targetname( "breach_rescue_trigger" );
}

gulag_rescue_music()
{
	level notify ( "stop_music" );
	musicStop(0.1);
	wait 0.15;
	thread MusicPlayWrapper( "gulag_ending", 0 );	
}

gulag_rescue()
{
	flag_wait( "player_approaches_rescue_breach" );
	
	remove_global_spawn_function( "allies", ::enable_cqbwalk );
	
	ai = getaiarray( "bad_guys" );
	array_thread( ai, ::die_soon );
	
	flag_set( "rescue_begins" );
	level.player.dont_unlink_after_breach = true;
	level.forced_slowmo_breach_slowdown = true;

	autosave_by_name( "end_breach" );
	// Ok, I cound eight tangos. Plant your breaching charge as far to the northwest as you can – otherwise you risk killing our man inside.
	thread radio_dialogue( "gulag_gst_8tangos" );

	trigger_from = level.breach_groups[ 3 ].trigger;
	trigger_to = level.breach_groups[ 4 ].trigger;

	// stop this breach when it starts so we can teleport
	level.skip_breach = [];
	level.skip_breach[ 3 ] = true;
	ent = spawn_tag_origin();
	ent.origin = level.breach_groups[ 3 ].left_post.origin;
	ent.angles = level.breach_groups[ 3 ].left_post.angles;

	arm_ent = spawn_tag_origin();

	from_org = trigger_from.origin;
	from_angles = trigger_from.angles;

	ai = GetAIArray( "allies" );


	trigger_from waittill( "trigger" );
	thread gulag_rescue_music();

	ending_room_spawners = GetEntArray( "ending_room_spawner", "targetname" );
	/*
	foreach ( spawner in ending_room_spawners )
	{
		spawner delayThread( 2, ::spawn_ai );
	}
	*/

	waittillframeend;// wait for trigger_to to start breach logic


	level.player DontInterpolate();
	arm_ent.origin = level.player.origin;
	arm_ent.angles = level.player.angles;
	arm_ent LinkTo( ent );
	level.player PlayerLinkTo( arm_ent, "tag_origin", 1, 0, 0, 0, 0, 0 );

	ent.origin = level.breach_groups[ 4 ].left_post.origin;
	ent.angles = level.breach_groups[ 4 ].left_post.angles;

	thread gulag_finish_rescue_thread( trigger_to, ai );

	if ( level.start_point == "ending" )
	{
		wait( 0.05 ); // if we're from a start point we need to let the sun get turned off before we turn it back on
	}

	DisableForcedSunShadows(); // lets get some sunlight in here
	setsaveddvar( "ai_friendlysuppression", 0 );
	setsaveddvar( "ai_friendlyfireblockduration", 0 );
	
	//thread player_cavein(); //kill player if he falls behind

	delaythread( 0.05, ::exploder, "rock_glass" ); 

	trash_sound = getent( "trash_sound", "script_noteworthy" );
	trash_sound thread maps\gulag_ending_code::trash_sound_think();
	
	run_thread_on_targetname( "hallway_flicker_light", maps\gulag_ending_code::hallway_flicker_light );
	thread maps\_utility::set_ambient( "gulag_exit" );

	level waittill( "breaching" );
	level.player setstance( "stand" );
	level.player allowcrouch( false );
	level.player allowprone( false );
	
	delaythread( 4, ::vision_set_fog_changes, "gulag_ending", 4 );
	
	level.player.attackeraccuracy = 0;
	level.player.ignorerandombulletdamage = true;
	level.player delaythread( 15, maps\_gameskill::update_player_attacker_accuracy );

	spawner = GetEnt( "price_spawner", "targetname" );
	spawner spawn_ai();
	
//	level.price forceUseWeapon( "mp5", "primary" );
	
	spawner = getent( "price_choke_spawner", "targetname" );
	chokey = spawner spawn_ai();
	chokey.animname = "chokey";

	ent = getstruct( "ending_breach_org", "targetname" );
	
	// tweak the position of the scene model from script for iteration
	localtrans = spawnstruct();
	localtrans.entity = ent;
	localtrans.forward = -38;
	localtrans.right = -24;
	localtrans translate_local();
	
	player_rig = spawn_anim_model( "player_rig" );
	player_rig hide();
	
	guys = [];
	guys[ guys.size ] = level.price;
	guys[ guys.size ] = chokey;
	guys[ guys.size ] = player_rig;	
	
	time = getanimlength( level.price getanim( "price_breach" ) );
	time -= 2;
	delaythread( time, maps\gulag_ending_code::player_gets_knocked_out_by_price, player_rig );
	
	
	
	ent anim_first_frame( guys, "price_breach" );
	wait( 2.2 );
	thread price_breach_dof();

	level.price thread play_sound_on_entity( "scn_gulag_price_rescue_foley" );
	level.timer = gettime();	
	delaythread( 3.95, ::play_sound_in_space, "scn_gulag_price_rescue_punch", level.player geteye() );
	delaythread( 4.35, ::play_sound_in_space, "scn_gulag_price_rescue_bodyfall", level.player geteye() );
	
	ent anim_single( guys, "price_breach" );
	axis = getaiarray( "axis" );
	foreach ( guy in axis )
	{
		guy delete();
	}

	spawner = GetEnt( "endlog_soap_spawner", "targetname" );
	spawner.count = 1;
	spawner spawn_ai();
	
	spawner = getentarray( "endlog_redshirt_spawner", "targetname" )[ 0 ];
	spawner.count = 1;
	spawner spawn_ai();

	level.soap forceUseWeapon( "glock", "sidearm" );

	guys = [];
	guys[ guys.size ] = level.price;
	guys[ guys.size ] = level.redshirt;
//	guys[ guys.size ] = player_rig;	
	guys[ guys.size ] = level.soap;


	exploder( "background_explosion" );
	ent thread anim_single( guys, "price_rescue" );
	ent delaythread( 0.6, ::anim_single_solo, player_rig, "price_rescue" );

	animation = level.soap getanim( "price_rescue" );
	time = getanimlength( animation );
	offset = 1.5;
	wait( time - offset );

	level.soap forceUseWeapon( "m4_grunt", "primary" );
	level.price notify( "change_to_regular_weapon" );
	flag_set( "escape_the_gulag" );

	thread finish_rescue_sequence( offset );
}

gulag_finish_rescue_thread( trigger_to, ai )
{
	wait( 0.1 );
	trigger_to notify( "trigger", level.player );

	wait( 2.5 );
	level notify( "kill_color_replacements" );


	foreach ( guy in ai )
	{
		if ( !isalive( guy ) )
			continue;

		if ( IsDefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();

		guy Delete();
	}

}


finish_rescue_sequence( offset )
{
	wait( offset - 0.3 );
	
	level.player enableweapons();
	
	weapons = level.player GetWeaponsListPrimaries();
	
	foreach ( weapon in weapons )
	{
		level.player SwitchToWeapon( weapon );
		break;
	}

	
	level.player unlink();
	level.player allowcrouch( true );
	level.player allowprone( true );
}


gulag_objectives()
{
}

gulag_startpoint_catchup_thread()
{
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;

	if ( is_default_start() )
		return;

	thread control_room_destructibles_turn_on();

	if ( start == "intro" )
		return;

	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "hud_showStance", 0 );
	setSavedDvar( "hud_drawhud", 0 );

	if ( start == "approach" )
		return;

	flag_set( "player_heli_uses_modified_yaw" );

	gulag_player_loadout();	// Moved to before the wait so prechaching can happen in give_default_loadout in coop
	wait( 0.05 );
	vision_set_fog_changes( "gulag_circle", 1 );

	car_blows_up = GetEnt( "car_blows_up", "script_noteworthy" );
	RadiusDamage( car_blows_up.origin, 1200, 5000, 5000 );

	flag_set( "approach_dialogue" );
	flag_set( "slamraam_gets_players_attention" );

	flag_set( "stab2_clear" );

	if ( start == "unload" )
		return;
	if ( start == "f15" )
		return;

	SetSavedDvar( "compass", "1" );
	SetSavedDvar( "ammoCounterHide", 0 );
	SetSavedDvar( "hud_showStance", 1 );
	setSavedDvar( "hud_drawhud", 1 );

	flag_set( "stop_rotating_around_gulag" );
	flag_set( "player_heli_uses_modified_yaw" );

	wait( 0.05 );
	vision_set_fog_changes( "gulag", 1 );


	if ( start == "bhd" )
		return;

	flag_set( "access_control_room" );
	flag_set( "player_progresses_passed_ext_area" );
	if ( start == "control_room" )
		return;

	add_global_spawn_function( "axis", ::ambush_behavior );
	add_global_spawn_function( "allies", ::enable_cqbwalk );

	flag_set( "gulag_cell_doors_enabled" );
	flag_set( "enable_interior_fx" );
	flag_set( "disable_exterior_fx" );
	flag_set( "pre_armory_open" );

	if ( start == "armory" )
		return;

	if ( start == "rappel" )
		return;

	fog_set_changes( "gulag_hallways" );

	flag_set( "access_control_room" );
	flag_set( "nearing_bathroom_breach" );
	flag_set( "cell_duty" );
	flag_set( "leaving_pipe_area" );

	if ( start == "bathroom" )
		return;

	if ( start == "so_showers" )
		return;

	fog_set_changes( "gulag" );

	flag_set( "access_control_room" );
	flag_set( "control_room" );
	flag_set( "advance_through_pipearea" );
	flag_set( "leaving_pipe_area" );
	flag_set( "player_enters_bathroom" );

	maps\gulag_ending::gulag_ending_startpoint_catchup_thread();
}


landing_blocker_think()
{
	landing_blockers = GetEntArray( "landing_blocker", "targetname" );
	foreach ( blocker in landing_blockers )
	{
		blocker ConnectPaths();
		blocker NotSolid();
	}

	flag_wait( "player_lands" );

	foreach ( blocker in landing_blockers )
	{
		blocker Solid();
		blocker DisconnectPaths();
	}
}

/*
	iprint( "I spot 4 hostiles on the next tower!"
	dialogue for f15
	dialogue for heli leaving after strike
*/