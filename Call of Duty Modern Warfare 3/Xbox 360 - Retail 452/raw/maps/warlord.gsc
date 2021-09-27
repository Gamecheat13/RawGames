/****************************************************

Level: Warlord
Moments: 
	1. Stealth Intro - stealth through river
	2. Infiltration - player climbs tower and snipes
	3. Advance - go through shanty, take over technical, turret section
	4. Mortar Run - escape mortar explosions
	5. Player Mortar - blow stuff up
	6. Assault - meat and potatoes
	7. Player Breach - low tech breach of church
	8. Protect - protect your package

****************************************************/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\_stealth_utility;
#include maps\warlord_code;
#include maps\warlord_stealth;
#include maps\warlord_utility;
#include maps\warlord_obj;
#include maps\_shg_common;

main()
{
	template_level( "warlord" );
	// constants
	level.friendlyFireDisabled = 0;
	level.cosine[ "45" ] = cos( 45 );
	level.confrontation_weapon = "fnfiveseven_warlord_end";
	
	//tone down spec throughout level
	setsaveddvar("r_specularcolorscale", 2);
	//shadow resolution adjusted throughout level to .85
	setsaveddvar("sm_sunshadowscale",.8);
	
	//VARIABLE SCOPE
	PreCacheString( &"VARIABLE_SCOPE_SNIPER_MAG" );
	PreCacheString( &"VARIABLE_SCOPE_SNIPER_ZOOM" );
	
	// precache data
	PreCacheString( &"WARLORD_INTROSCREEN_LINE1" );
	PreCacheString( &"WARLORD_INTROSCREEN_LINE2" );
	PreCacheString( &"WARLORD_INTROSCREEN_LINE3" );
	PreCacheString( &"WARLORD_INTROSCREEN_LINE4" );
	PreCacheString( &"WARLORD_INTROSCREEN_LINE5" );
	PreCacheString( &"WARLORD_OBJ_FOLLOW_PRICE" );
	PreCacheString( &"WARLORD_OBJ_COVER_PRICE_AND_SOAP" );
	PreCacheString( &"WARLORD_OBJ_MOVE_THROUGH_SHANTY" );
	PreCacheString( &"WARLORD_OBJ_COMMANDEER_TECHNICAL" );
	PreCacheString( &"WARLORD_OBJ_EVADE_MORTAR_FIRE" );
	PreCacheString( &"WARLORD_OBJ_COVER_PRICE" );
	PreCacheString( &"WARLORD_OBJ_ENTER_COMPOUND" );
	PreCacheString( &"WARLORD_OBJ_DESTROY_TECHNICAL" );
//	PreCacheString( &"WARLORD_OBJ_BREACH_CHURCH" );
	PreCacheString( &"WARLORD_OBJ_CAPTURE_WARLORD" );
//	PreCacheString( &"WARLORD_OBJ_LET_CONVOY_IN" );
	PreCacheString( &"WARLORD_OBJ_POINTER_PROTECT" );
	PreCacheString( &"WARLORD_OBJ_POINTER_CAPTURE" );
	PreCacheString( &"WARLORD_OBJ_POINTER_DESTROY" );
	PreCacheString( &"WARLORD_HINT_CROUCH" );
	PreCacheString( &"WARLORD_MORTAR_DEATH" );
	PreCacheString( &"WARLORD_PRONE_DEATH" );
	PreCacheString( &"WARLORD_STEALTH_DEATH" );

	PreCacheModel( "viewmodel_m14_ebr" );
	PreCacheModel( "projectile_rpg7" );
	PreCacheModel( "weapon_truck_m2_50cal_mg_viewmodel" );
	PreCacheModel( "com_folding_chair" );
	PreCacheModel( "accessories_gas_canister_highrez" );
	PreCacheModel( "com_crate01" );
	PreCacheModel( "afr_pipe_gate_01" );
	PreCacheModel( "paris_crowbar_01" );
	PreCacheModel( "afr_chem_crate_01" );
	PreCacheModel( "weapon_machette" );
	PreCacheModel( "viewhands_yuri" );
	PreCacheModel( "viewhands_player_yuri" );
	PreCacheModel( "africa_civ_male_notburned" );
	PreCacheModel( "africa_civ_male_burned" );
	PreCacheModel( "vehicle_mi17_africa_palette" );
	
	PreCacheItem( "ak47_silencer_reflex" );
	PreCacheItem( level.confrontation_weapon );
	PreCacheItem( "fnfiveseven" );
	
	PreCacheShellshock( "slowview" );
	
	PreCacheRumble( "falling_land" );
	PreCacheRumble( "subtle_tank_rumble" );
	PreCacheRumble( "viewmodel_small" );
	PreCacheRumble( "viewmodel_medium" );
	PreCacheRumble( "viewmodel_large" );
	
	// start points
	add_start( "start_stealth_intro", ::start_stealth_intro, "", ::warlord_stealth_intro );
	add_start( "start_log_encounter", ::start_log_encounter, "", ::warlord_log_encounter );
	add_start( "start_burn_encounter", ::start_burn_encounter, "", ::warlord_burn_encounter );
	add_start( "start_river_big_moment", ::start_river_big_moment, "", ::warlord_river_big_moment );
	add_start( "start_infiltration", ::start_infiltration, "", ::warlord_infiltration );
	add_start( "start_advance", ::start_advance, "", ::warlord_advance );
	add_start( "start_technical", ::start_technical, "", ::warlord_technical );
	add_start( "start_mortar_run", ::start_mortar_run, "", ::warlord_mortar_run );
	add_start( "start_player_mortar", ::start_player_mortar, "", ::warlord_player_mortar );
	add_start( "start_assault", ::start_assault, "", ::warlord_assault );
	add_start( "start_super_technical", ::start_super_technical, "", ::warlord_super_technical );
	add_start( "start_confrontation", ::start_player_breach, "", ::warlord_player_breach );
	
	// include assets/art
	maps\warlord_precache::main();
	maps\createart\warlord_art::main();
	
	//stuff
	maps\_load::set_player_viewhand_model( "viewhands_player_yuri" );
	
	// level flags
	flag_init( "allies_spawned" );
	flag_init( "play_river_dialogue" );
	flag_init( "warlord_advance" );
	flag_init( "warlord_technical" );
	flag_init( "warlord_mortar_run" );
	flag_init( "warlord_player_mortar" );
	flag_init( "warlord_assault" );
	flag_init( "warlord_protect" );
	flag_init( "compound_technical_dead" );
	flag_init( "church_breach_complete" );
	flag_init( "mortar_technical" );
	flag_init( "church_side_door_open" );
	// flags: river section
	flag_init( "river_encounter_done" );
	flag_init( "price_past_log" );
	flag_init( "price_ready_to_reach_door" );
	flag_init( "soap_ready_to_reach_door" );
	flag_init( "river_big_moment_stealth_spotted" );
	flag_init( "river_encounter_3_begin" );
	flag_init( "river_encounter_3_complete" );
	flag_init( "river_house_burn_execution_setup" );
	flag_init( "river_house_burn_execution" );
	flag_init( "river_burn_interrupted" );
	flag_init( "jeer_guy_leave" );
	flag_init( "price_post_bridge" );
	flag_init( "soap_post_bridge" );
	flag_init( "end_river_big_moment" );
	flag_init( "clean_up_river" );
	// flags: infiltration section
	flag_init( "inf_stealth_spotted" );
	flag_init( "start_inf_door_open" );
	flag_init( "infiltration_over" );
	flag_init( "inf_factory_breach" );
	flag_init( "inf_factory_breach_done" );
	// flags: advance section
	flag_init( "advance_done" );
	// flags: technical section
	flag_init( "technical_combat_door_open" );
	flag_init( "delete_destroyed_technicals" );
	// flags: mortar run
	flag_init( "mortar_timer_done" );
	// flags: mortar
	flag_init( "mortar_introduce" );
	flag_init( "mortar_fight_shot_2" );
	flag_init( "compound_truck_left" );
	flag_init( "price_moving_to_pipe" );
	// flags: assault
	flag_init( "ready_to_open_grate" );
	flag_init( "breach_starting" );
	// flags: objective
	flag_init( "river_allies_stand" );
	flag_init( "player_show_gun" );
	
	// include anims
	maps\_patrol_anims::main();
	maps\warlord_anim::main();

	// drones
	maps\_drone_civilian::init();
	maps\_drone_ai::init();
	
	// setup audio
	maps\warlord_aud::main();

	//include fx
	maps\warlord_fx::main();
	
	// main logic
	maps\_load::main();
	maps\_stealth::main();
	warlord_stealth_init();
	
	// needs to happen after load in order to be able to use level flags set thru radiant
	maps\warlord_vo::main();
	
	// hint strings need to happen after _load
	add_hint_string( "neck_stab_hint", &"SCRIPT_PLATFORM_OILRIG_HINT_STEALTH_KILL", ::no_neck_stab_hint );
	
	add_hint_string( "crouch_hint", &"WARLORD_HINT_CROUCH", ::no_crouch_hint );
	add_hint_string( "crouch_hint_stance", &"WARLORD_HINT_CROUCH_STANCE", ::no_crouch_hint );
	add_hint_string( "crouch_hint_toggle", &"WARLORD_HINT_CROUCH_TOGGLE", ::no_crouch_hint );
	add_hint_string( "crouch_hint_hold", &"WARLORD_HINT_CROUCH_HOLD", ::no_crouch_hint );
	
	add_hint_string( "prone_hint", &"WARLORD_HINT_PRONE", ::no_prone_hint );
	add_hint_string( "prone_hint_stance", &"WARLORD_HINT_PRONE_STANCE", ::no_prone_hint );
	add_hint_string( "prone_hint_toggle", &"WARLORD_HINT_PRONE_TOGGLE", ::no_prone_hint );
	add_hint_string( "prone_hint_hold", &"WARLORD_HINT_PRONE_HOLD", ::no_prone_hint );
	
	add_hint_string( "switch_hint", &"WARLORD_HINT_WEAPON_SWITCH", ::weapon_switch_hint );
	
	level.hint_binding_map = [];
	level.hint_binding_map[ "crouch" ][0] = [ "togglecrouch", "crouch_hint_toggle" ];
	level.hint_binding_map[ "crouch" ][1] = [ "+stance", "crouch_hint_stance" ];
	level.hint_binding_map[ "crouch" ][2] = [ "gocrouch", "crouch_hint" ];
	level.hint_binding_map[ "crouch" ][3] = [ "+movedown", "crouch_hint_hold" ];
	level.hint_binding_map[ "prone" ][0] = [ "toggleprone", "prone_hint_toggle" ];
	level.hint_binding_map[ "prone" ][1] = [ "+stance", "prone_hint_stance" ];
	level.hint_binding_map[ "prone" ][2] = [ "goprone", "prone_hint" ];
	level.hint_binding_map[ "prone" ][3] = [ "+prone", "prone_hint_hold" ];
	
	// adjust exploders to support script_group, which is used
	//   to differentiate exploders in prefabs
	adjust_exploders();
	
	// player-controlled mortar logic
	maps\_weapon_mortar60mm::main( 
		&"WARLORD_HINT_USE_MORTAR", 	// use string to display
		32,								// right view arc
		41,								// left view arc
		9,								// top view arc
		5,								// bottom view arc
		448,							// max target height
		200,							// min target range
		15000, 							// max target range
		150, 							// arc height
		0.4, 							// time to reach arc height
		256,							// damage radius
		3100,							// maximum damage
		3100,							// minimum damage
		undefined,						// ammo (undefined is infinite)
		false );						// debug draw arc
	
	// set objective
	thread warlord_objectives();
	
	level.variable_scope_weapons = ["m14ebr_scoped_silenced_warlord"];
	thread maps\_shg_common::monitorScopeChange();
	
	maps\_compass::setupMiniMap("compass_map_warlord");
	
	// workaround to get around surface types that are not penetrable by bullets
	manage_bullet_penetrate_triggers();
}

start_stealth_intro()
{
	aud_send_msg("start_stealth_intro");
}

// assume you're in the river
warlord_stealth_intro()
{
	// player stealth
	level.player stealth_warlord();
	
	// set stealth ranges
	default_stealth_ranges();
	
	// spawn allies
	start_allies();
	
	thread river_corpses();
	
	// intro text
	thread warlord_intro_text();

	// technicals encounter
	thread river_technicals_encounter();
	thread restore_player_run_speed();
	
	// fall through to warlord_log_encounter()
}

start_log_encounter()
{
	aud_send_msg("start_river_big_moment");
	
	start_point_common( "player_log_start", "price_log_start", "soap_log_start" );
	vision_set_fog_changes( "warlord_intro", 0 );
	
	// player stealth
	level.player stealth_warlord();
	
	// initialize stealth settings
	default_alert_duration();
	no_detect_corpse_range();
	thread river_corpses();
	
	flag_set( "obj_first_follow_price" );
	
	delaythread( 2, ::price_play_log_anims );
	delaythread( 4, ::soap_play_log_anims );
}

warlord_log_encounter()
{
	thread village_corpse();
	// prone encounter
	thread river_prone_encounter();
	
	// fall through to warlord_burn_encounter()
}

start_burn_encounter()
{
	aud_send_msg("start_river_big_moment");
	
	start_point_common( "player_burn_start", "price_burn_start", "soap_burn_start" );
	vision_set_fog_changes( "warlord_intro", 0 );
	
	// player stealth
	level.player stealth_warlord();
	
	// initialize stealth settings
	default_alert_duration();
	no_detect_corpse_range();
	
	flag_set( "obj_first_follow_price" );
	thread river_corpses();
	thread village_corpse();
	
	wait 2;
	
	// set this flag just to spawn the dead civ
	flag_set( "river_prone_encounter_spawn" );
	flag_set( "price_ready_to_reach_door" );
	flag_set( "soap_ready_to_reach_door" );
	flag_set( "river_house_door_open" );
	flag_set( "river_encounter_3_complete" );
}

warlord_burn_encounter()
{
	// house
	thread river_house_door();
	thread river_house_burn_execution();
	thread allies_path_to_big_moment();
	thread burn_ambient_walk();
	// fall through to warlord_river_big_moment()
}

start_river_big_moment()
{
	aud_send_msg("start_river_big_moment");
	
	start_point_common( "player_river_start", "price_river_start", "soap_river_start" );
	vision_set_fog_changes( "warlord_intro", 0 );
	
	// player stealth
	level.player stealth_warlord();
	
	// initialize stealth settings
	default_alert_duration();
	no_detect_corpse_range();
	thread setup_jeer_guys();
	flag_set( "obj_first_follow_price" );
	
	delaythread( 2, ::activate_trigger_with_targetname, "trig_path_to_big_moment" );
}

warlord_river_big_moment()
{
	// big moment
	thread river_big_moment_clip_blocker();
	thread river_big_moment();
	thread river_big_moment_prone_hint();
	thread river_cleanup();
	thread prone_patrol_dialogue();
	
	// need to spawn inf guy before big moment because he 
	//   sticks out from the river section
	thread inf_encounter_sleeping_guard();
	
	// wait for end of section
	start_infiltration_trigger = GetEnt( "start_infiltration_trigger", "targetname" );
	start_infiltration_trigger waittill( "trigger" );
	flag_set( "end_river_big_moment" );
	
	// give time to river_cleanup to select all the enemies before proceeding 
	//   (and spawning more)
	wait 0.05;
}

start_point_common( player_start_point, price_start_point, soap_start_point )
{
	spawn_allies();
	
	move_player_to_start( player_start_point );
	
	if ( IsDefined( price_start_point ) )
	{
		level.price move_entity_to_start( price_start_point );
		level.price SetGoalPos( drop_to_ground( level.price.origin ) );
	}
	
	if ( IsDefined( soap_start_point ) )
	{
		level.soap move_entity_to_start( soap_start_point );
		level.soap SetGoalPos( drop_to_ground( level.soap.origin ) );
	}
}

start_point_after_stealth()
{
	disable_stealth_system();
	level.soap forceUseWeapon( "ak47_reflex", "primary" );
	level.price forceUseWeapon( "ak47_reflex", "primary" );
}

switch_sniper_rifle()
{
	level.player switch_player_weapon( "m14ebr_scoped_silenced_warlord", level.player.lastweapon );
}

start_infiltration()
{
	aud_send_msg("start_infiltration");
	
	start_point_common( "player_infiltration_start", "price_infiltration_start", "soap_infiltration_start" );
	vision_set_fog_changes( "warlord_shanty", 0 );
	
	level.player stealth_warlord();
	
	blind_and_deaf_ranges();
	default_alert_duration();
	no_detect_corpse_range();
	
	flag_set( "infiltrate_encounter_1" );
	flag_set( "price_post_bridge" );
	flag_set( "soap_post_bridge" );
	
	thread inf_encounter_sleeping_guard();
}

warlord_infiltration()
{
	flag_init( "start_inf_snipe_encounter_1" );
	
	autosave_stealth();
	
	// set up section data
	level.price enable_arrivals();
	level.soap enable_arrivals();
	
	if ( !flag( "_stealth_spotted" ) )
	{
		level.price.ignoreall = true;
		level.soap.ignoreall = true;
	}
	
	// reset friendly fire points, for civilians in the area
	level.player.participation = 0;
	
	// reset friendly fire block duration
	setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
	
	// pre-infiltration area
	thread infiltrate_civilians();
	thread inf_encounter_first_patroller();
	
	//handle graph blocker
	thread inf_clear_graph_blocker();
	
	//hide down fence
	mantle = getent( "inf_fence_down", "targetname" );
	old_origin = mantle.origin;
	mantle.origin = (0, 0, 0);
	thread inf_fence_cleanup( mantle, old_origin );
	
	// after in infiltration area
	flag_wait( "start_inf_door_open" );
	autosave_stealth();
	thread handle_mantle_brush();
	thread infiltrate_cleanup();
	thread inf_snipe_encounters();
	thread inf_factory_breach();
	thread yuri_advance();
	thread show_switch_hint();
}

start_advance()
{
	aud_send_msg("start_advance");
	
	start_point_common( "player_advance_start", "price_advance_start", "soap_advance_start" );
	vision_set_fog_changes( "warlord_shanty", 0 );
	start_point_after_stealth();
	flag_set( "obj_move_through_shanty_given");
	flag_set( "inf_factory_breach_done" );
	
	level.price enable_arrivals();
	level.soap enable_arrivals();
	
	level.price go_to_node_with_targetname("node_price_inf_6");
	
	flag_set( "warlord_advance" );
}

warlord_advance()
{
	flag_wait( "warlord_advance" );
	start_autosave( "advance_start" );
	level.price disable_cqbwalk();
	level.soap disable_cqbwalk();

	thread advance_soap_runs_for_cover();
	thread advance_go_loud();
	thread monitor_advance_skip();
	
	flag_wait( "advance_done" );
	flag_set( "warlord_technical" );
}

start_technical()
{
	aud_send_msg("start_technical");
	
	start_point_common( "player_technical_start", "price_technical_start", "soap_technical_start" );
	vision_set_fog_changes( "warlord_shanty", 0 );
	start_point_after_stealth();
	
	level.price enable_arrivals();
	level.soap enable_arrivals();
	
	level.price.at_technical_area = true;
	level.soap.at_technical_area = true;
	
	flag_set( "advance_go_loud_complete" );
	flag_set( "obj_move_through_shanty_given" );
	flag_set( "obj_go_loud_given" );
	flag_set( "obj_follow_price_advance_given" );
	flag_set( "warlord_technical" );
	flag_set( "inf_factory_breach_done" );
	aud_send_msg( "mus_to_technical" );
}

warlord_technical()
{
	flag_wait( "warlord_technical" );
	
	flag_init( "move_anim_technical_clip" );
	flag_init( "technical_gunner_dead" );
	flag_init( "mortar_technical_hit" );
	flag_init( "player_on_technical" );
	flag_init( "player_get_on_technical_abort" );
	flag_init( "player_boarding_technical" );
	flag_init( "technical_combat_started" );
	
	ground = getent( "technical_ground", "targetname" );
	ground hide();
	
	//new
	level.exploderFunction = ::warlord_technical_exploder;
	level.soap.goalradius = 1024;
	
	level thread technical_kill_player();
	level thread technical_drivein_turret();
	level thread technical_combat();
	level thread technical_combat_complete();
	thread move_anim_technical_clip();
	thread monitor_player_at_back_of_truck();
	
	//hide rubble
	rubble = getentarray( "mortar_rubble", "targetname" );
	foreach( rubble_piece in rubble )
	{
		rubble_piece hide();
	}
  	
	//wait_to use technical
	flag_wait( "turret_ready_to_use" );
	flag_set( "player_technical_dialogue" );
	flag_wait( "technical_combat_started" );
	
	//player can get on technical	
	level.player_technical thread player_get_on_technical( level.player_technical_turret );
	
	//objective change
	flag_set( "obj_follow_price_advance_complete" );
	flag_set( "obj_commandeer_technical_given" );
	
	level waittill( "turret_finished" );
	flag_set( "warlord_mortar_run" );
	
	level.exploderFunction = ::exploder_after_load;
}

start_mortar_run()
{
	aud_send_msg("start_mortar_run");
	
	start_point_common( "player_mortar_run_start", "price_mortar_run_start", "soap_mortar_run_start" );
	vision_set_fog_changes( "warlord_shanty", 0 );
	start_point_after_stealth();
	
	level.price enable_arrivals();
	level.soap enable_arrivals();
	
	thread switch_sniper_rifle();
	
	// delete barrier
	rubble = getentarray( "mortar_rubble", "targetname" );
	foreach( rubble_piece in rubble )
	{
		rubble_piece show();
	}
	
	blockers = getentarray( "technical_blocker_graph", "targetname" );
	foreach( blocker in blockers )
	{
		blocker ConnectPaths();
		blocker delete();
	}
	
	flag_set( "warlord_mortar_run" );
}

warlord_mortar_run()
{
	flag_wait( "warlord_mortar_run" );
	flag_set( "mortar_run_dialogue" );
	start_autosave( "mortar_run_start" );
	level.soap mortar_run_ally_setup();
	level.price mortar_run_ally_setup();
	
	thread mortar_gauntlet();	
	thread setup_mortar_motivation_guys();	
}

start_player_mortar()
{
	aud_send_msg("start_player_mortar");

	start_point_common( "player_player_mortar_start", "price_player_mortar_start", "soap_player_mortar_start" );
	vision_set_fog_changes( "warlord_shanty", 0 );
	start_point_after_stealth();
	
	level.player switch_sniper_rifle();
	
	level.price enable_arrivals();
	level.soap enable_arrivals();
	
	level.soap disable_awareness();
	
	flag_set( "warlord_player_mortar" );
	flag_set( "mortar_operator_off" );
	flag_set( "flag_mortar_obj_2" ); //put objective dot in correct place
	flag_set( "flag_mortar_obj_3" ); //put objective dot in correct place
	flag_set( "flag_mortar_obj_mortar" ); //put objective dot in correct place
}

warlord_player_mortar()
{
	flag_wait( "warlord_player_mortar" );
	level notify( "warlord_player_mortar" );
	start_autosave( "player_mortar_start" );
	thread mortar_introduce();
	thread mortar_fight();
	thread mortar_allies();
	thread mortar_rpg_setup();
	thread mortar_rpg_guys();
	level.soap enable_arrivals();
	level.soap disable_sprint();
	level.price enable_arrivals();
	level.price disable_sprint();
}

start_assault()
{
	aud_send_msg("start_assault");

	start_point_common( "player_assault_start", "price_assault_start", "soap_assault_start" );
	vision_set_fog_changes( "warlord_camp", 0 );
	start_point_after_stealth();
	
	level.player switch_sniper_rifle();
	
	level.price enable_arrivals();
	level.soap enable_arrivals();
	
	level.soap disable_awareness();
	
	flag_set( "warlord_assault" );
	flag_set( "price_moving_to_pipe" );
	flag_set( "assault_run_to_pipe" );
}

warlord_assault()
{
	flag_wait( "warlord_assault" );
	start_autosave( "assault_start" );
	
	aud_send_msg( "warlord_assault" );
	
	thread assault_run_to_pipe();
	thread assault_pipe_crawl();
	thread assault_disable_prone_on_stairs();
	thread assault_roof_deaths();
	thread post_warehouse_trigger();
	thread assault_door_kick();
}

start_super_technical()
{
	aud_send_msg("start_super_technical");

	start_point_common( "player_super_technical_start", "price_super_technical_start", "soap_super_technical_start" );
	vision_set_fog_changes( "warlord_camp", 0 );
	start_point_after_stealth();
	
	level.player switch_sniper_rifle();
	
	level.price enable_arrivals();
	level.soap enable_arrivals();
	
	activate_trigger_with_targetname( "trig_price_enter_compound_house" );
	activate_trigger_with_targetname( "trig_soap_enter_compound_house" );
}

warlord_super_technical()
{
	//thread assault_door_spawners();
	
	level.player thread compound_autosave();
	//thread compound_truck_right();
	//thread compound_truck_left();
	
	thread ally_lower_accuracy();
	thread mi17_flyby();
	thread setup_change_goal_radius_on_goal();
	thread setup_ignore_until_goal();
	thread setup_fire_while_moving();
	thread setup_ignore_all_until_goal();
	thread setup_first_guys();
	thread setup_run_guys();
	//thread compound_retreat();
	//thread roof_runner_1();
	thread delete_roof_ai();
	thread compound_church_doors();
	
}

start_player_breach()
{
	aud_send_msg("start_player_breach");

	start_point_common( "player_confrontation_start", "price_confrontation_start", "soap_confrontation_start" );
	vision_set_fog_changes( "warlord_church", 0 );
	start_point_after_stealth();
	level.player switch_sniper_rifle();
	
	flag_set( "warlord_player_breach" );
	flag_set( "church_breach_complete" );
}

warlord_player_breach()
{
	flag_wait( "warlord_player_breach" );
	flag_set( "aud_warlord_player_breach" );
	level notify( "warlord_church_breach" );
	start_autosave( "player_breach_start" );
	
	thread turn_off_compound_triggers();
	thread player_exits_church_stage_fix();

	thread warlord_confrontation();
}


player_exits_church_stage_fix()
{
	flag_wait("exiting_courtyard");
	srcEnt = getent( "church", "targetname" );
	dstEnt = getent( "yard", "targetname" );
	remapStage(srcEnt.origin,dstEnt.origin);
}



// bug in engine with saving during the 1st server frame
start_autosave( checkpoint_name )
{
	wait 0.05;
	autosave_by_name( checkpoint_name );
}
