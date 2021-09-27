#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

#include maps\_audio;

#include maps\paris_a_code;
#include maps\paris_shared;

main()
{
	template_level("paris_a");
	init_level_flags();
		
	maps\createart\paris_a_art::main();
	maps\paris_a_fx::main();
	maps\paris_a_precache::main();

	PreCacheItem("minigun_littlebird_spinnup");

	// precaching stuff

	// for the player
	PreCacheItem( "ninebang_grenade" );
	PreCacheItem( "rpg" );

	PreCacheString( &"PARIS_INTROSCREEN_LINE1" );
	PreCacheString( &"PARIS_INTROSCREEN_LINE2" );
	PreCacheString( &"PARIS_INTROSCREEN_LINE3" );
	PreCacheString( &"PARIS_INTROSCREEN_LINE4" );
	PreCacheString( &"PARIS_INTROSCREEN_LINE5" );
	PreCacheString( &"PARIS_PROTECT_TIMER" );
	PreCacheString( &"PARIS_USE_MANHOLE" );
	
	PreCacheRumble( "steady_rumble" );
	PreCacheRumble( "viewmodel_small" );
	
	//PrecacheShader( "gasmask_overlay_delta2" );
	PrecacheShader( "gasmask_overlay_delta2_top" );
	PrecacheShader( "gasmask_overlay_delta2_bottom" );

	// Press ^3 [{+actionslot 4}] ^7 to use an air support marker.
	add_hint_string("air_support_hint", &"PARIS_AIR_SUPPORT_HINT", ::using_strobe);
	
	add_hint_string("air_support_fire_hint", &"PARIS_AIR_SUPPORT_THROW_HINT", ::break_air_support_fire_hint);
	add_hint_string("air_support_fire_hint_pc", &"PARIS_AIR_SUPPORT_THROW_HINT_PC", ::break_air_support_fire_hint);
	
	default_start( ::debug_start_rooftops );
	add_start( "rooftops",					::debug_start_rooftops,					"Rooftops",						::rooftops_logic);
	add_start( "stairwell",					::debug_start_stairwell,				"Stairwell",					::stairwell_logic);						
	add_start( "restaurant_approach",		::debug_start_restaurant_approach,		"Restaurant Approach",			::restaurant_approach_logic);
	add_start( "ac_moment",					::debug_start_ac_moment,				"AC Moment",					::ac130_moment_logic);
	add_start( "sewer_entrance",			::debug_start_sewer_entrance,			"Sewer Entrance",				::sewer_entrance_logic);

	maps\paris_aud::main();
	maps\_load::main();

	// init various systems
	maps\_air_support_strobe::main();
	maps\_compass::setupMiniMap("compass_map_paris_a");
	SetSavedDVar("compassMaxRange", 2200); // default was 3500
	
	//rumble ent
	level.rumble = get_rumble_ent( "steady_rumble" );
	level.rumble.intensity = 0;
	
	spawn_metrics_init();
	
	thread windy_tree_system();

	// setup anims
	maps\paris_a_anim::main();

	maps\paris_a_vo::main();  // must be after flag_inits()

	// set up the manhole in its slightly ajar position
	level.manhole_node = GetStruct("struct_move_manhole", "script_noteworthy");
	level.manhole = GetEnt("model_manhole", "script_noteworthy");
	level.manhole_blocker = GetEnt("manhole_blocker", "script_noteworthy");
	level.manhole.animname = "manhole";
	level.manhole assign_animtree();
	level.manhole_node anim_first_frame_solo(level.manhole, "delta_pull_movemanhole");
	level.manhole_blocker DisconnectPaths();

	bookstore_reno_check_door_init();
	
	ac130 = getent_safe("ac130_spawner", "script_noteworthy") spawn_vehicle();
	ac130 gopath();
	maps\_air_support_strobe::set_aircraft(ac130, 1000 * 12, "tag_40mm" );

	// start threads to handle non-alpha-path events (important gameplay stuff should go in the *_logic() functions)
	
	thread setup_ignore_suppression_triggers();
	thread jets_flyby_01();
	thread jets_flyby_02();
	thread tanks_side_alley_bookstore();
	thread jet_flyby_back_alley();
	thread sprint_to_restaurant();
	thread tanks_side_alley_01();
	thread player_enters_yoga_room();
	thread spawn_civ_corpses_ac_alley();
	thread btr_courtyard();
	
	// have to put this early in case the player sprints ahead
	thread restaurant_meeting_init();
	
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ),vehicle_scripts\_mig29::plane_sound_node );

	thread obj_setup();
	
	/#
	thread debug_magic();
	thread debug_npc_count();
	thread debug_test_dialogue();
	#/

	getent_safe("lone_star", "targetname").animname = "lonestar";
	getent_safe("reno", "targetname").animname = "reno";
	getent_safe("frenchie", "targetname").animname = "gign_leader";
	getent_safe("redshirt", "targetname").animname = "redshirt";
	
	foreach(spawner in GetSpawnerArray())
	{
		spawner add_spawn_function(maps\paris_a_code::process_ai_script_parameters);
	}
			
	// this is where the old weapon was coming from
	paris_equip_player();
	
	// bit of a hack: we need this trigger to kill players also when in demigod mode
	// ultimately we should have a general system for this, or just make trigger_hurt always work this way
	foreach(trigger in GetEntArray("trigger_hurt", "classname"))
	{
		trigger thread trigger_kill_player();		
	}		
}

init_level_flags()
{
	// todo: remove this one
	flag_init("game_fx_started");

	flag_init( "intro_screen_complete" );
	flag_init( "flag_little_bird_landed" );
	flag_init( "flag_move_debris_guy2_begin" );
	flag_init( "flag_move_debris_guy2_commited" );
	flag_init( "flag_move_debris_guy2_stop_idle" );	
	flag_init( "flag_stairwell_reaction_start" );
	flag_init( "flag_bookstore_straglers" );
	flag_init( "flag_bookstore_exit_start" );
	flag_init( "flag_restaurant_meeting_start" );
	flag_init( "flag_restaurant_meeting_complete" );
	flag_init( "flag_conversation_blocker_leave" );
	flag_init( "heli_crash_start" );
	flag_init( "flag_ai_initial_top_retreat" );
	flag_init( "bookstore_combat_interior_rear_done" );
	flag_init( "flag_tanks_side_alley_aggro" );
	flag_init( "flag_ac130_moment_friendlies_in_position" );
	if( !flag_exist( "flag_ac130_moment_complete" ) )
	{
		flag_init( "flag_ac130_moment_complete" );
	}
	flag_init( "btr_cortyard_killed" );
	flag_init( "courtyard_1_cleared" );
	flag_init( "courtyard_1_wave_2" );
	flag_init( "flag_courtyard_2_combat_finished" );
	flag_init( "flag_frenchie_manhole_ready" );
	flag_init( "flag_player_manhole_ready" );
	flag_init( "flag_catacombs_gate_finished" );
	
	flag_init( "flag_obj_01_position_change_1" );
	flag_init( "flag_obj_01_position_change_2" );
	flag_init( "flag_obj_01_position_change_3" );
	flag_init( "flag_obj_01_position_change_4" );
	flag_init( "flag_obj_01_position_change_5" );
	flag_init( "flag_obj_01_position_change_6" );

}
	
// ***********************************************************************************************************************
// NOTE:
//
// Nothing important (audio, visionsets, etc.) should be put exclusively in debug_*() functions, because they will not be
// called when playing through the game normally.  In general, all state changes should go in the *_logic() functions.
//
// The _debug() functions only exist to hack the game state to simulate having progressed past previous *_logic() functions,
// for example by making sure the right people are spawned, seting up completed objectives, and setting important state
// that has been missed by the skipping over of previous *_logic() functions.

debug_start_rooftops()
{
	aud_send_msg("debug_start_rooftops");
	flag_set( "game_fx_started" );
}

debug_start_stairwell()
{
	aud_send_msg("debug_start_stairwell");
	
	battlechatter_on( "allies" );
	
	level.hero_lone_star = spawn_targetname("lone_star");
	level.hero_reno = spawn_targetname("reno");
	
	level.hero_lone_star deletable_magic_bullet_shield();
	level.hero_reno deletable_magic_bullet_shield();
	
	level.player thread gasmask_on_player(false);

	flag_set( "game_fx_started" );
	flag_set( "flag_obj_01_position_change_1" );
	flag_set( "flag_obj_01_position_change_2" );
	flag_set( "flag_obj_01_position_change_3" );
	flag_set( "flag_obj_01_position_change_4" );
	
	teleport_to_scriptstruct("checkpoint_stairwell");
	
	// kick start the stairway surprise moment, since we teleported past the trigger for it.
	flag_set("player_rooftop_jump_complete");
	
//	spawners_axis = getentarray( "paris_street_enemy_spawners", "targetname" );
		
	thread enemies_ignore_player_until_shot_or_hot();		
}
	
debug_start_restaurant_approach()
{
	aud_send_msg("debug_start_restaurant_approach");

	battlechatter_on( "allies" );

	level.hero_lone_star = spawn_targetname("lone_star");
	level.hero_reno = spawn_targetname("reno");
	
	level.hero_lone_star enable_sprint();
	level.hero_reno enable_sprint();

	level.hero_lone_star deletable_magic_bullet_shield();
	level.hero_reno deletable_magic_bullet_shield();
	
	level.hero_lone_star thread ally_keep_player_distance(39 * 8, .8, 1.2, .25);	
	level.hero_reno      thread ally_keep_player_distance(39 * 6, .8, 1.2, .25);
	
	level.player thread gasmask_on_player(false);

	flag_set( "game_fx_started" );
	
	teleport_to_scriptstruct("checkpoint_restaurant_approach");	
	
	level.player SetMoveSpeedScale(.8);
	SetSavedDvar( "ai_friendlyFireBlockDuration", 0 );
	
	thread spawn_corpses("dead_bodies_back_alley");
	thread restaurant_meeting_random_shots();
	thread bookstore_breach_axis_death("guy_bookstore_death_1", "struct_bookstore_alley_shooting_1", "bookstore_alley_shooting_1");
	thread bookstore_breach_axis_death("guy_bookstore_death_2", "struct_bookstore_alley_shooting_2", "bookstore_alley_shooting_2");
	thread gign_meeting_runner();
	thread alley_bullet_spray();
	thread gign_wave_restaurant();
}

debug_start_ac_moment()
{
	aud_send_msg("debug_start_ac_moment");
	
	battlechatter_on( "allies" );
	
	flag_set( "game_fx_started" );
	vision_set_fog_changes( "paris_a", 0 );

	flag_set( "flag_spawn_corpses_ac_alley" );

	level.hero_lone_star = spawn_targetname("lone_star");
	level.hero_frenchie = spawn_targetname("frenchie");
	level.hero_reno = spawn_targetname("reno");
	level.hero_redshirt = spawn_targetname("redshirt");
	
	level.hero_lone_star 	thread ally_keep_player_distance(39 * 8, .8, 1.2, .25);	
	level.hero_reno     	thread ally_keep_player_distance(39 * 6, .8, 1.2, .25);
	level.hero_frenchie 	thread ally_keep_player_distance(39 * 8, .8, 1.2, .25);	
	level.hero_redshirt     thread ally_keep_player_distance(39 * 6, .8, 1.2, .25);
	
	level.player thread gasmask_on_player(false);

	level.hero_lone_star deletable_magic_bullet_shield();
	level.hero_frenchie deletable_magic_bullet_shield();
	level.hero_reno deletable_magic_bullet_shield();
	level.hero_redshirt deletable_magic_bullet_shield();
	
	teleport_to_scriptstruct("checkpoint_ac_moment");
}

debug_start_sewer_entrance()
{
	aud_send_msg("debug_start_sewer_entrance");
	
	battlechatter_off( "allies" );
	
	flag_set( "game_fx_started" );
	vision_set_fog_changes( "paris_a", 0 );

	level.hero_lone_star = spawn_targetname("lone_star");
	level.hero_frenchie = spawn_targetname("frenchie");
	level.hero_reno = spawn_targetname("reno");
	level.hero_redshirt = spawn_targetname("redshirt");

	level.hero_lone_star deletable_magic_bullet_shield();
	level.hero_frenchie deletable_magic_bullet_shield();
	level.hero_reno deletable_magic_bullet_shield();
	level.hero_redshirt deletable_magic_bullet_shield();

	level.player thread gasmask_on_player(false);

	teleport_to_scriptstruct("checkpoint_catacombs_entrance");
}

rooftops_logic()
{
	level.hero_lone_star = spawn_targetname("lone_star");
	level.hero_reno = spawn_targetname("reno");
	
	level.hero_lone_star enable_cqbwalk();
	level.hero_reno enable_cqbwalk();
	
	level.hero_lone_star thread ally_keep_player_distance(39 * 6, .8, 1.2);	
	level.hero_reno      thread ally_keep_player_distance(39 * 4, .8, 1.2);
		
	level.hero_lone_star deletable_magic_bullet_shield();
	level.hero_reno deletable_magic_bullet_shield();
	
	thread spawn_corpses("dead_civ_rooftops");
	rooftops_sequence_init();
	
	thread battlechatter_off( "allies" );

	level.player SetMoveSpeedScale(.7);
	
	thread enemies_ignore_player_until_shot_or_hot();
	thread paris_intro_screen();
	thread player_shimmy();	
	
	little_bird_fly_away();

	rooftops_sequence();
	
	level.player SetMoveSpeedScale(1);
}

stairwell_logic()
{	
	level.hero_lone_star thread ally_keep_player_distance(39 * 6, .8, 1.2);	
	level.hero_reno      thread ally_keep_player_distance(39 * 4, .8, 1.2);
	
	thread initial_combat();
	thread bookstore_combat_exterior();
	thread bookstore_runners();
	thread player_enters_bookstore();
	thread ai_clean_up_initial();

	array_thread([level.hero_lone_star, level.hero_reno], ::stop_cqb_after_fall);

	stairwell_reaction();
	
	// geo prevents player from going back to the ledge at this point.
	level notify("player_shimmy_stop");
	
	level.hero_lone_star thread ally_keep_player_distance(39 * 8, .8, 1.2, .25);	
	level.hero_reno      thread ally_keep_player_distance(39 * 6, .8, 1.2, .25);
			
	bookstore_reno_check_door();
}	
	
restaurant_approach_logic()
{	
	
	flag_wait("trigger_restaurant_meeting");
	restaurant_meeting();
		
	level.hero_redshirt enable_ai_color();

	foreach(dude in level.extras_gign)
	{
		if(IsAlive(dude))
			dude enable_ai_color();
	}

	// todo: hmm, is this in the right place?
	aud_send_msg("meet_gign");

	flag_wait("flag_cross_courtyard_complete");
}

ac130_moment_logic()
{

	flag_wait( "trigger_ac130_moment" );
	thread ac130_moment();
	
	// todo: make this a saved var so we can safely set it.
	//SetSavedDvar("ai_corpseCount", Int(GetDvarInt("ai_corpseCount") * .5));

	flag_wait( "flag_courtyard_2_combat_start" );
	thread courtyard_2_combat();

	flag_wait( "flag_ai_clean_up_ac130_moment" );
	thread ai_clean_up_ac130_moment();

	flag_wait("flag_courtyard_2_combat_finished");

}

sewer_entrance_logic()
{

	move_manhole();
	
	level.player maps\_air_support_strobe::disable_strobes_for_player();
}

/****************************************************************************
    OBJECTIVE FUNCTIONS

    - to add new objectives, add them in the right order in the switch
      statement, under the correct debug start point

    - don't put non-objective-related stuff in these

****************************************************************************/
obj_setup()
{
	obj_create_completed_objectives();
	
	// fallthroughs are intentional
	switch( level.start_point )
	{
		case "default":
		case "rooftops":
		case "stairwell":
		case "restaurant_approach":
			obj_meet_with_gign();
		case "ac_moment":
			obj_follow_gign();
			obj_destroy_btr();
		case "sewer_entrance":
			obj_follow_gign_manhole();

		break;
		default:
			AssertMsg("Unhandled start point " + level.start_point);
	}
}

obj_create_completed_objectives()
{
	// This should only happen when starting from debug checkpoints.  The idea
	// is to fill in completed objectives without actually doing them, so we get
	// consistent greyed-out objectives above.
	
	if(level.start_point == "default") return;
	
	if(level.start_point == "rooftops") return;
	if(level.start_point == "stairwell") return;
	
	flag_set( "flag_obj_01_position_change_1" );
	flag_set( "flag_obj_01_position_change_2" );
	flag_set( "flag_obj_01_position_change_3" );
	flag_set( "flag_obj_01_position_change_4" );
	flag_set( "flag_obj_01_position_change_5" );
	flag_set( "flag_obj_01_position_change_6" );

	if(level.start_point == "restaurant_approach") return;
	
	objective_add( 1, "invisible", &"PARIS_OBJECTIVE_MEET_GIGN" );
	objective_state_nomessage(1, "done");
	
	flag_set("flag_restaurant_meeting_complete");
	flag_set("flag_cross_courtyard_complete");
	
	if(level.start_point == "ac_moment") return;
	
	objective_add( 1, "invisible", &"PARIS_OBJECTIVE_MEET_GIGN" );
	objective_state_nomessage(1, "done");
	objective_add( 2, "invisible", &"PARIS_OBJECTIVE_FOLLOW_GIGN" );
	objective_state_nomessage(2, "done");
	objective_add( 3, "invisible", &"PARIS_OBJECTIVE_DESTROY_BTR" );
	objective_state_nomessage(3, "done");
	
	if(level.start_point == "sewer_entrance") return;
	
	AssertMsg("Unhandled start point in obj_create_completed_objectives(): " + level.start_point);
}

obj_meet_with_gign()
{
	flag_wait( "flag_obj_01_position_change_1" );
	
	objective_number = 1;
	objective_add( objective_number, "active", &"PARIS_OBJECTIVE_MEET_GIGN");	
	objective_current( objective_number );
	objective_position ( objective_number, getstruct( "obj_01_gign_target_1", "targetname" ).origin );
	flag_wait( "flag_obj_01_position_change_2" );
	objective_position ( objective_number, getstruct( "obj_01_gign_target_2", "targetname" ).origin );
	flag_wait( "flag_obj_01_position_change_3" );
	objective_position ( objective_number, getstruct( "obj_01_gign_target_3", "targetname" ).origin );
	flag_wait( "flag_obj_01_position_change_4" );
	objective_position ( objective_number, getstruct( "obj_01_gign_target_4", "targetname" ).origin );
	flag_wait( "flag_obj_01_position_change_5" );
	flag_set( "flag_ai_initial_top_retreat" );
	objective_position ( objective_number, getstruct( "obj_01_gign_target_5", "targetname" ).origin );
	flag_wait( "flag_obj_01_position_change_6" );
	objective_position ( objective_number, getstruct( "obj_01_gign_target_6", "targetname" ).origin );

	flag_wait( "flag_restaurant_meeting_start" );

	objective_complete( objective_number );
}

obj_follow_gign()
{
	flag_wait("flag_restaurant_meeting_complete");

	objective_number = 2;
	Objective_add( objective_number, "active", &"PARIS_OBJECTIVE_FOLLOW_GIGN" );
	objective_position ( objective_number, getstruct( "obj_cross_courtyard", "targetname" ).origin );
	objective_current( objective_number );
	
	flag_wait("flag_cross_courtyard_complete");
	
	// in a debug start we need to wait for him to be spawned
	while(!IsDefined(level.hero_frenchie))
	{
		waitframe();
	}
	
	Objective_OnEntity( objective_number, level.hero_frenchie );

	flag_wait_any( "flag_obj_btr_courtyard", "flag_dialogue_heli_unloading", "flag_mi17_courtyard_02_dead" );

	wait 5.5;

	// objective stays active as we go to the next one
}

obj_destroy_btr()
{
	// must wait for the BTR to spawn
	while(!IsDefined(level.btr_courtyard))
	{
		waitframe();
	}

	wait 4;
	
	objective_number = 3;
	objective_add( objective_number, "active", &"PARIS_OBJECTIVE_DESTROY_BTR" );
	Objective_OnEntity_safe( objective_number, level.btr_courtyard, ( 0, 0, 64) );
	Objective_SetPointerTextOverride( objective_number, &"PARIS_OBJECTIVE_BTR" );
	objective_current( objective_number );

	flag_wait("btr_cortyard_killed");
	
	wait 2;
	
	objective_complete( objective_number );
}

obj_follow_gign_manhole()
{
	
	// delete the old follow_gign objective so this new one appears at the bottom
	objective_delete(2);

	objective_number = 4;
	objective_add( objective_number, "active", &"PARIS_OBJECTIVE_FOLLOW_GIGN" );
	
	// in a debug start we need to wait for him to be spawned
	while(!IsDefined(level.hero_frenchie))
	{
		waitframe();
	}
	
	Objective_OnEntity( objective_number, level.hero_frenchie );
	objective_current( objective_number );

	flag_wait("flag_player_manhole_ready");

	objective_position ( objective_number, getstruct( "obj_enter_sewers", "targetname" ).origin );
	Objective_SetPointerTextOverride( objective_number, &"PARIS_OBJECTIVE_ENTER" );
	
	flag_wait("flag_player_manhole");
	
	objective_complete( objective_number );
}
