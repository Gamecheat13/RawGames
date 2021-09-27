#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\berlin_code;
#include maps\berlin_vo;
#include maps\berlin_util;
#include maps\_audio;
#include maps\_shg_common;
#include maps\berlin_a10;

main()
{
	template_level("berlin");
	
	//Blinky traffic lights
	PreCacheModel( "berlin_traffic_signal_2x_01_green_on" );
	PreCacheModel( "berlin_traffic_signal_2x_01_red_on" );
	PreCacheModel( "berlin_traffic_signal_2x_01_yellow_on" );
	
	level.friendly_sniper_weapon = "m14ebr_scope";
	PreCacheItem( level.friendly_sniper_weapon );
	
	level.primary_weapon = "acr_hybrid_berlin";
	level.secondary_weapon = "m14ebr_scope";
	level.reverse_breach_weapon = "fnfiveseven_reverse_breach";
	PreCacheItem(level.primary_weapon);
	PreCacheItem(level.secondary_weapon);
	PreCacheItem(level.reverse_breach_weapon);
	PreCacheItem( "leopard_2a7_sabot" );
	
	PreCacheItem( "ninebang_grenade" );
	PreCacheItem( "flash_grenade" );
	
	//setup what sniper rifle we tell the player to pickup ontop of the aa building
	level.sniper_rifle = "m14ebr_scope";
	
	PreCacheShellShock( "berlin_intro" );
	//PreCacheShellShock("af_chase_ending_wakeup_nomove");
	PreCacheItem( "a10_designator_ads" );
	PreCacheItem( "rpg" );
	PrecacheItem( "javelin_berlin" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "stinger_speedy" );
	
	//glowy models
	PreCacheModel( "weapon_m14_sp_iw5_obj" );
	PreCacheModel( "weapon_rpg7_obj" );
	
	//Dyanmic A10
	PreCacheModel( "vehicle_a10_warthog" );
	PreCacheItem( "a10_30mm" );
	
	//need tags to fire from
	level.apache_weapons[1] = "cobra_20mm";
	level.apache_tags[1][0] = "tag_flash";
	precacheItem( level.apache_weapons[1] );
	
	level.apache_weapons[2] = "cobra_Hellfire";
	level.apache_tags[2][0] = "tag_flash_2";
	level.apache_tags[2][1] = "tag_flash_11";
	precacheItem( level.apache_weapons[2] );
	
	level.apache_weapons[3] = "cobra_Sidewinder_berlin";
	level.apache_tags[3][0] = "tag_flash_3";
	level.apache_tags[3][1] = "tag_flash_22";
	precacheItem( level.apache_weapons[3] );
	
	PreCacheItem( "rpg_cheap" );
	
	//keep around math functions
	level.cosine[ "sniper" ] = cos(5);
	
	//laser_arty assets
	PreCacheShader( "dpad_soflam_static" );
	PreCacheShader( "dpad_soflam_inactive" );
	
	//building collapse assets
	PreCacheModel( "viewhands_delta_dirty" );
	
	//building traverse
	PreCacheShader("hint_mantle");
	
	//end laser_arty assets
	
	PreCacheRumble( "heavy_3s" );
	PreCacheRumble( "light_1s" );

	//reverse breach assets
	level.scr_sound[ "detpack_explo_main" ] 		 = "detpack_explo_main";

	PreCacheShellShock( "berlin_building" );
	//end reverse breach assets
	
	//building collapse asset precache
	precacheShader("black");
	PreCacheModel( "body_delta_woodland_assault_aa_dusty" );
	PreCacheModel( "body_hero_sandman_delta_dusty" );
	PreCacheModel( "body_hero_truck_delta_dusty" );
	
	//init interface
	maps\berlin_a10::a10_interface_init();
	
	add_start( "Intro", ::start_intro, undefined, ::berlin_intro );
	add_start( "Heli_Ride", ::start_heli_ride, undefined, ::berlin_heli_ride );
	add_start( "Chopper_Crash", ::start_chopper_crash, undefined, ::berlin_chopper_crash );
	add_start( "Clear_Roof", ::start_clear_roof, undefined, ::berlin_clear_roof );
	add_start( "Sniper", ::start_sniper, undefined, ::berlin_sniper );
	add_start( "Rappel", ::start_rappel, undefined, ::berlin_rappel );
	add_start( "Rappel_Complete", ::start_rappel_complete, undefined, ::berlin_rappel_complete );
	add_start( "Clear_Bridge", ::start_clear_bridge, undefined, ::berlin_clear_bridge );
	add_start( "Advance_pkwy", ::start_advance_parkway, undefined, ::berlin_advance_pkway );
	add_start( "Building_Collapse", ::start_building_collapse, undefined, ::berlin_building_collapse );
	add_start( "Traverse_Building", ::start_traverse_building, undefined, ::berlin_traverse_building );
	add_start( "Emerge", ::start_emerge, undefined, ::berlin_emerge );
	add_start( "Last_Stand", ::start_last_stand, undefined, ::berlin_last_stand );
	add_start( "Reverse Breach", ::start_reverse_breach, undefined, ::berlin_reverse_breach );
	
	//VARIABLE SCOPE
	PreCacheString( &"VARIABLE_SCOPE_SNIPER_MAG" );
	PreCacheString( &"VARIABLE_SCOPE_SNIPER_ZOOM" );
	
	//INTROSCREEN
	//20 Minutes Earlier
	PreCacheString( &"BERLIN_INTROSCREEN_20MINS" );
	//"Scorched Earth"
	PreCacheString( &"BERLIN_INTROSCREEN_LINE1" );
	//Day 10 - 10:18:[{FAKE_INTRO_SECONDS:02}]
	PreCacheString( &"BERLIN_INTROSCREEN_LINE2" );
	//Sgt. Derek "Frost" Westbrook
	PreCacheString( &"BERLIN_INTROSCREEN_LINE3" );
	//Delta Force
	PreCacheString( &"BERLIN_INTROSCREEN_LINE4" );
	//Berlin, Germany
	PreCacheString( &"BERLIN_INTROSCREEN_LINE5" );
	
	//OBJECTIVES
	//Get to overwatch to provide sniper support.
	PreCacheString( &"BERLIN_OVERWATCH" );
	//Provide sniper cover for Granite team.
	PreCacheString( &"BERLIN_SNIPE_B" );
	//Destroy the Russian tanks using the A-10.
	PreCacheString( &"BERLIN_AIR_SUPPORT" );
	//Rappel down the building.
	PreCacheString( &"BERLIN_RAPPEL_OBJ" );
	//Get to the Bridge
	PreCacheString( &"BERLIN_SUPPORT_SANDMAN" );
	//Destroy the Russian tank using the A-10.
	PreCacheString( &"BERLIN_DESTROY_TANKS_OBJ" );
	//Advance with the German tanks.
	PreCacheString( &"BERLIN_ADVANCE_OBJ" );
	//Get to the Hotel
	PreCacheString( &"BERLIN_TRAVERSE_BUILDING_OBJ" );
	//Get to the roof.
	PreCacheString( &"BERLIN_FALL_BACK_TO_ROOF" );
	
	//SPECIAL MARKERS
	//Targets
	PreCacheString( &"BERLIN_TARGETS" );
	//Protect
	PreCacheString( &"BERLIN_PROTECT" );
	//Destroy
	PreCacheString( &"BERLIN_DESTROY" );
	//Rappel
	PreCacheString( &"BERLIN_RAPPEL" );
	//Breach
	PreCacheString( &"BERLIN_BREACH" );
	
	//HINTS
	//Press and hold^3 &&1 ^7to rappel
	PreCacheString( &"BERLIN_RAPPEL_HINT" );
	//Press and hold^3 &&1 ^7 to breach
	PreCacheString( &"BERLIN_BREACH_HINT" );
	//Press^3 &&1 ^7to switch to your second weapon.
	add_hint_string( "rpg_secondary", &"BERLIN_RPG_HINT", ::rpg_weapon_switch_hint );
	//You are damaging a friendly tank.
	//PreCacheString( &"BERLIN_FRIENDLY_TANK_FIRE_WARNING" );
	//Do not fire on Allied tanks.
	add_hint_string( "damage_leapard_hint", &"BERLIN_FRIENDLY_TANK_FIRE_WARNING" );
	
	//A-10
	//Pull ^3[{+attack}]^7 to confirm first coordinate
	PreCacheString( &"BERLIN_DIRECT_A10" );
	//Press^3 [{+actionslot 4}] ^7to provide coordinates for A-10 strafing run
	PreCacheString( &"BERLIN_ACTIVATE_A10" );
	//Use ^3&&"BUTTON_LOOK"^7 to draw A-10 line\nPull ^3[{+attack}]^7 to confirm
	PreCacheString( &"BERLIN_DIRECT_A10_POINTS" );
	//Use ^3[{+holdbreath}]^7 to set direction\nPull ^3[{+attack}]^7 to confirm
	PreCacheString( &"BERLIN_DIRECT_A10_STATIC" );
	
	//FAIL QUOTES
	//Granite team was killed.  Clear the rooftop of enemies.
	PreCacheString( &"BERLIN_SNIPER_FAIL_QUOTE" );
	//Your team has died.  Provide the A-10 with coordinates to destroy the Russian tanks.
	PreCacheString( &"BERLIN_SNIPER_TANK_FAIL_QUOTE" );
	//The allied tanks have been destroyed.  Provide the A-10 with coordinates to destroy the Russian tanks.
	PreCacheString( &"BERLIN_BRIDGE_BATTLE_FAIL_QUOTE" );
	//You abandoned your squad. Get to the roof.
	PreCacheString( &"BERLIN_LAST_STAND_FAIL" );


	//Intro
	flag_init( "is_intro" );
	flag_init( "falling_column_fell" );
	flag_init( "intro_dialogue_complete" );
	flag_init( "start_intro_fade_2_white" );
	flag_init( "intro_outro_full_white" );
	flag_init( "intro_sequence_complete" );
	flag_init( "intro_lone_star_facial_anim_complete" );

	//heli ride
	flag_init( "intro_start_on_path" );
	flag_init( "start_sandman_vo" );
	flag_init( "intro_heli_hit" );
	flag_init( "start_level_ambient" );
	flag_init( "player_unloaded_from_intro_flight" );
	flag_init( "rpg_attacker_fires" );
	
	//aa building
	flag_init( "lone_star_near_building_throw" );
	
	//clear_roof
	flag_init( "patroller_alerted" );
	flag_init( "sniper_hotel_roof_clear" );
	flag_init( "delta_support_squad_heli_check_failure" );
	flag_init( "delta_support_squad_heli_stop_firing" );
	flag_init( "sniper_rooftop_fire_rocket" );
	
	//sniper
	flag_init( "aa_building_level4_dead" );
	flag_init( "sniper_hotel_roof_spawn_helis" );
	flag_init( "sniper_delta_support_squad_unloaded" );
	flag_init( "spawn_sniper_patrol_wave2" );
	flag_init( "bravo_team_spawned");
	flag_init( "bravo_team_unloaded");
	flag_init( "delta_support_squad_roof_advance_1" );
	flag_init( "delta_support_squad_roof_advance_2" );
	flag_init( "delta_support_breach_kick" );
	flag_init( "snipe_hotel_roof_complete" );
	flag_init( "sniper_tank_1_reached_path_end" );
	flag_init( "sniper_tank_2_reached_path_end" );
	flag_init( "bravo_team_begin_rappel" );
	flag_init( "bravo_team_reached_lower_rooftop" );
	flag_init( "delta_support_in_hotel" );
	flag_init( "sniper_complete" );
	flag_init( "mainstreet_battle_start" );
	flag_init( "bravo_team_planted_c4" );
	flag_init( "bravo_team_ground_enemies1_dead" );//set in berlin_vo to stop dialog collisions
	flag_init( "bravo_team_ground_enemies1_2_dead" );//set in berlin_vo to stop dialog collisions
	flag_init( "delta_support_street_enemies4" );
	flag_init( "sniper_tanks_one_dead" );
	flag_init( "sniper_tanks_two_dead" );
	flag_init( "start_parkway_tank" );
	flag_init( "parkway_tank_dead" );
	flag_init( "sniper_delta_support_guys_dead" );
	flag_init( "allies_in_sniping_position" );
	flag_init( "sniper_victim_heli_shoot" );
	flag_init( "sniper_vo_complete" );
	flag_init( "begin_rappel_vo" );
	flag_init( "sniper_tank_2_mission_failing" );
	flag_init( "player_looking_at_granite" );
	flag_init( "spawn_hotel_rooftop_enemies_complete" );
	flag_init( "spawn_sniper_tanks_complete" );
	flag_init( "granite_team_dead" );
	flag_init( "lone_star_sniping_position_complete" );
	flag_init( "grinch_sniping_position_complete" );
	flag_init( "truck_sniping_position_complete" );
	flag_init( "rappel_teleport_dudes" );
	flag_init( "stop_sniper_glow" );
	
	//a10
	flag_init( "paint_targets_vo" );
	
	//rappel
	flag_init( "rappel_end" );
	
	//alley
	flag_init( "rappel_complete" );
	flag_init( "vo_check_wounded_soldier" );
	flag_init( "vo_downed_apache_complete" );
	flag_init( "stop_chopper_blade" );
	flag_init( "downed_apache_paired_guy_dead" );
	flag_init( "clean_up_downed_apache" );
	flag_init( "player_passed_apache" );
	
	//bridge battle
	flag_init( "bridge_deadtank_dead" );
	flag_init( "stop_rpg_glow" );
	flag_init( "bridge_rpg_picked_up" );
	flag_init( "bridge_fighters_start_fighting" );
	flag_init( "tank_turret_target_player" );
	flag_init( "bridge_one_tank_destroyed" );
	flag_init( "rus_all_tanks_dead" );
	flag_init( "rus_all_tanks_dead_delay" );
	flag_init( "bridge_combat_dudes_dead" );
	flag_init( "trig_path_heroes_bridge_02_triggered" );
	
	//parkway
	flag_init( "parkway_tank_left_pause_01" );
	flag_init( "parkway_tank_right_pause_01" );
	
	//collapsed building
	flag_init( "lone_star_going_down" );
	flag_init( "player_interacting_with_wounded_lonestar" );
	flag_init( "player_teleport_after_collapse_complete" );
	flag_init( "ambush_after_building_collapse_start" );
	flag_init( "sandman_start_aftermath" );
	
	//aftermath
	flag_init( "swivel_fades_out" );
	flag_init( "swivel_ends" );
	flag_init( "not_random_blur" );
	flag_init( "player_limping" );
	flag_init( "stop_being_stunned" );
	flag_init( "aftermath_se_complete" );
	flag_init( "vo_building_collapse_complete" );
	
	//building traverse
	flag_init( "lone_star_at_ceiling_collapse" );
	flag_init( "start_intro_vo" );
	flag_init( "clean_up_tank_corpse" );//initing here so we don't initialize it twice.
	flag_init( "collapse_roof" );
	flag_init( "ceiling_collapse_complete" );
	flag_init( "lone_star_at_emerge_door" );
	flag_init( "truck_at_emerge_door" );
	
	//emerge
	flag_init( "emerge_door_in_position" );
	flag_init( "emerge_door_open" );
	flag_init( "emerge_dialogue_done" );
	flag_init( "emerge_door_begin_open" );
	
	//last stand
	flag_init( "last_stand_player_outside" );//for vo
	flag_init( "last_stand_tanks_stopped_firing" );
	flag_init( "tank_killed_player" );
	
	//hotel doors
	flag_init( "door_hotel_stairs_1_open" );
	flag_init( "door_hotel_stairs_2_open" );
	
	//reverse breach
	flag_init( "exfil_hallway_dudes_dead" );
	flag_init( "reverse_breach_ready" );
	flag_init( "breach_weapon_drawn" );
	flag_init( "reverse_breach_start" );
	flag_init( "reverse_breach_door_blown" );
	flag_init( "reverse_breach_complete" );
	flag_init( "reverse_breach_player_back_in_business" );
	flag_init( "lone_star_wounded" );
	flag_init( "reverse_breach_ending_vo_complete" );
	flag_init( "reverse_breach_getup_slowmo_start" );
	
	//initiallizing for berlin_vfx.gsc
	flag_init ("start_bridge_battle");
	
	level.objective_count = 0;
	
	maps\berlin_precache::main();

	maps\berlin_anim::main();
	maps\createart\berlin_art::main();
	maps\berlin_fx::main();
	maps\berlin_aud::main();
	
	maps\_load::main();
	
/#
	thread spawn_metrics_init();
	thread debug_magic();
#/
	thread setup_ignore_suppression_triggers();

	maps\_drone_ai::init();

	prepare_dialogue();
	thread play_dialogue();
	
	//Sunshadow directional
	maps\_shg_common::vision_change_multiple_init();
	
	//Specular Tweaks
	setsaveddvar("r_specularcolorscale", 1.8);
	
	level.custombadplacethread = ::berlin_tank_badplace;
	
	level.variable_scope_weapons = ["m14ebr_scope"];
	thread maps\_shg_common::monitorScopeChange();
	
	level.laser_targets = [];
	
	trigger = GetEntArray( "delete_enemies_in_volume", "targetname" );
	array_thread( trigger, ::delete_enemies_in_volume );
	
	// Fire lights
	flag_init( "off_fire_light" );
  thread berlin_carfire_rappel();
  
 	// Blinky traffic lights
  array_thread( GetEntArray( "traffic_light_green_off_blinky", "targetname" ), ::traffic_light_green_off_blinky );
  array_thread( GetEntArray( "traffic_light_red_off_blinky", "targetname" ), ::traffic_light_red_off_blinky );
  array_thread( GetEntArray( "traffic_light_yellow_off_blinky", "targetname" ), ::traffic_light_yellow_off_blinky );
  array_thread( GetEntArray( "traffic_light_yellow_green_blinky", "targetname" ), ::traffic_light_yellow_green_blinky );
  
  maps\_compass::setupMiniMap("compass_map_berlin"); 
  
  anim.grenadeTimers[ "AI_ninebang_grenade" ] = 0;	
  
  add_global_spawn_function("axis", maps\berlin_a10::a10_add_target );
  add_global_spawn_function("axis", maps\berlin_a10::a10_remove_target_ondeath );
  
  add_global_spawn_function("allies", maps\berlin_a10::a10_add_target );
  add_global_spawn_function("allies", maps\berlin_a10::a10_remove_target_ondeath );
  
  	
  //disable damage from steam pipes	
	level.pipesDamage = false;
	
	//hack: hide falling column traversal geo
	//couldn't figure out how to have negotiation node at the end of the traversal be on top of clip, so using actual terrain geo and hiding it through script.
	falling_column_ai_clip = getent( "falling_column_ai_clip", "targetname" );
	falling_column_ai_clip hide();
}

start_intro()
{
		//level heroes
	level.heroes = [];

	//since this is the only start point that doesnt call spawn_friendlies we need to garuntee that 
	//the spawn functions for the friendly AI are set up correctly
	setup_friendly_spawner ( "lone_star", ::setup_lone_star );
	setup_friendly_spawner ( "essex", ::setup_essex );
	setup_friendly_spawner ( "truck", ::setup_truck );
}



start_heli_ride() 
{		
	
		
	
	//level heroes
	level.heroes = [];

	//since this is the only start point that doesnt call spawn_friendlies we need to garuntee that 
	//the spawn functions for the friendly AI are set up correctly
	setup_friendly_spawner ( "lone_star", ::setup_lone_star );
	setup_friendly_spawner ( "essex", ::setup_essex );
	setup_friendly_spawner ( "truck", ::setup_truck );
	
	flag_set("intro_outro_full_white");
}

start_chopper_crash() 
{	
	aud_send_msg("start_chopper_crash");
	
		
	
	thread vision_set_fog_changes("berlin",0);
		
	move_player_to_start("player_start_chopper_crash");
	
	flag_set("player_unloaded_from_intro_flight");
		//Specular Tweaks
	//setsaveddvar("r_specularcolorscale", 1.15);
	aud_send_msg("mus_player_unloaded_from_intro_flight");	

	ent = getent("aa_building_hit0", "targetname");
	ent delete();
	
	ent = getent("aa_building_hit1", "targetname");
	ent delete();
	
	ent = getent("aa_building_hit2", "targetname");
	ent delete();
	
	spawn_berlin_friendlies("player_start_chopper_crash");
	

	
}

start_clear_roof() 
{	
		
	aud_send_msg("start_clear_roof");
	thread vision_set_fog_changes("berlin",0);
			//Specular Tweaks
	//setsaveddvar("r_specularcolorscale", 2.15);

	move_player_to_start("player_start_sam_destroyed");
	
	spawn_berlin_friendlies("player_start_sam_destroyed");
	
	first_battle_spawner = getent("aa_building_level1_spawn", "target");
	first_battle_spawner delete();
	
	flag_set( "player_on_roof" );
	flag_set( "aa_building_level4_dead" );
	
	aa_building_obj_loc = getstruct("aa_building_obj_loc_3", "targetname");
	level.over_obj_num = level.objective_count;
	Objective_Add( level.over_obj_num, "current", &"BERLIN_OVERWATCH", aa_building_obj_loc.origin ); //first objective
	level.objective_count++;
	
	thread kill_player_triggers( "kill_player_sniper", "player_rappels" );
}

start_sniper()
{
	aud_send_msg("start_sniper");
	
	flag_set("mainstreet_battle_start");
	flag_set( "aa_building_level4_dead" );
	
	move_player_to_start("player_start_sniper");
	spawn_berlin_friendlies("player_start_sniper");
	
	thread vision_set_fog_changes("berlin",0);
	thread roof_top_sniper();
	thread monitor_mainstreet_battle();
	thread kill_player_triggers( "kill_player_sniper", "player_rappels" );
	spawn_rappel_ropes();
	
	first_battle_spawner = getent("aa_building_level1_spawn", "target");
	first_battle_spawner delete();
	
	aa_building_obj_loc = getstruct("aa_building_obj_loc_3", "targetname");
	level.over_obj_num = level.objective_count;
	Objective_Add( level.over_obj_num, "current", &"BERLIN_OVERWATCH", aa_building_obj_loc.origin ); //first objective
	level.objective_count++;
}

start_rappel()
{
	aud_send_msg("start_rappel");
	
	trig = GetEnt( "snipe_player_in_position_trigger", "targetname" );
	assert(isdefined( trig ));
	trig Delete(); //nuke this trigger as it causes asserts if you run backwards from the start point.  dev only issue
	
	move_player_to_start("start_point_rappel");
	spawn_berlin_friendlies("start_point_rappel");
	//thread maps\berlin_a10::airstrike_on();
	thread vision_set_fog_changes("berlin",0);
	spawn_rappel_ropes();
	
	flag_set( "lone_star_sniping_position_complete" );
	flag_set( "grinch_sniping_position_complete" );
	flag_set( "truck_sniping_position_complete" );
	flag_set( "sniper_complete" );
	flag_set( "begin_rappel_vo" );
}

start_rappel_complete() 
{
	aud_send_msg("start_rappel_complete");
	
	thread vision_set_fog_changes("berlin_rappel_complete",0);
	
	move_player_to_start("player_start_rappel_complete");
	spawn_berlin_friendlies("player_start_rappel_complete");
	
	flag_set( "rappel_complete" );

	//thread maps\berlin_a10::airstrike_on();
	
	obj_rappel_loc = getstruct("obj_rappel_loc", "targetname");
	level.rappel_obj_num = level.objective_count;
	Objective_Add( level.rappel_obj_num, "current", &"BERLIN_RAPPEL_OBJ", obj_rappel_loc.origin );
	Objective_SetPointerTextOverride(level.rappel_obj_num, &"BERLIN_RAPPEL");
	level.objective_count++;
} 

start_clear_bridge()
{
	
		
	aud_send_msg("start_clear_bridge");
	
	thread vision_set_fog_changes("berlin_pre_parkway",0);
	
	move_player_to_start("player_start_clear_bridge");
	spawn_berlin_friendlies("player_start_clear_bridge");
	
	obj_advance_to_bridge = getstruct("obj_advance_to_bridge", "targetname");
	assert(!isdefined(level.take_bridge_obj_num));
	level.take_bridge_obj_num = level.objective_count;
	Objective_Add( level.take_bridge_obj_num, "current", &"BERLIN_SUPPORT_SANDMAN");//is completed with clear_bridge
	Objective_OnEntity(level.take_bridge_obj_num, level.lone_star);
	level.objective_count++;

	flag_set("start_bridge_battle");
	flag_set( "vo_downed_apache_complete" );
}

start_advance_parkway()
{
	aud_send_msg("start_advance_parkway");
	
	level.usa_tanks = [];
	
	thread vision_set_fog_changes("berlin_parkway",0);
	//Specular Tweaks
//	setsaveddvar("r_specularcolorscale", 1.4);
	
	assert(!isdefined(level.adv_pky_obj_num));
	obj_advance_to = getstruct("start_parkway_objective", "targetname");
	level.adv_pky_obj_num = level.objective_count;
	Objective_Add( level.adv_pky_obj_num, "current", &"BERLIN_ADVANCE_OBJ", obj_advance_to.origin);
	level.objective_count++;	
		
	move_player_to_start("player_start_advance_parkway");	
	spawn_berlin_friendlies("player_start_advance_parkway");	
	thread parkway_advance_tanks();
	//thread maps\berlin_a10::airstrike_on();
	flag_set("usa_tanks_start_bridge_advance");
	flag_set("bridge_one_tank_destroyed");
	flag_set("rus_all_tanks_dead");
	
	//setup Advance color groups
	//thread maps\berlin_util::color_volume_advance( "parkway_color_advance", 1 );		

}

start_building_collapse()
{
	level.usa_tanks = [];
	aud_send_msg("start_building_collapse");
	
	thread vision_set_fog_changes("berlin_parkway",0);
		//Specular Tweaks
	//setsaveddvar("r_specularcolorscale", 2);
	
	move_player_to_start("player_start_building_collapse");	
	spawn_berlin_friendlies("player_start_building_collapse");	
	
	level.adv_pky_obj_num = level.objective_count;
	obj_advance_to = getstruct("obj_advance_to_collapse", "targetname");
	Objective_Add( level.adv_pky_obj_num, "current", &"BERLIN_ADVANCE_OBJ", obj_advance_to.origin);
	level.objective_count++;
}

start_traverse_building()
{
	aud_send_msg("start_traverse_building");
	
	thread vision_set_fog_changes("berlin_traverse_building",0);
	
	move_player_to_start("player_start_traverse_building");	
	
	building = getent("building_to_destroy", "script_noteworthy");
	building delete();
	
	spawn_berlin_friendlies("player_start_traverse_building");
	
	flag_set("building_collapse_player_safe");
	flag_set( "not_intro" );
	flag_set( "vo_building_collapse_complete" );
	
	level.emerge_obj_num = level.objective_count;
	Objective_Add( level.emerge_obj_num, "current", &"BERLIN_TRAVERSE_BUILDING_OBJ");
	Objective_OnEntity(level.emerge_obj_num, level.lone_star);
	level.objective_count++;	
	
	level.lone_star enable_cqbwalk();
	level.essex enable_cqbwalk();
	level.truck enable_cqbwalk();
}

start_emerge()
{
	aud_send_msg("start_emerge");
	
	thread vision_set_fog_changes("berlin_traverse_building",0);
		
	move_player_to_start("player_start_emerge");	
	spawn_berlin_friendlies("player_start_emerge");
	
	level.emerge_obj_num = level.objective_count;
	Objective_Add( level.emerge_obj_num, "current", &"BERLIN_TRAVERSE_BUILDING_OBJ");
	Objective_OnEntity(level.emerge_obj_num, level.lone_star);
	level.objective_count++;
	
	building = getent("building_to_destroy", "script_noteworthy");
	building delete();
	
	flag_set( "lone_star_at_emerge_door" );	
	flag_set( "truck_at_emerge_door" );	
}

start_last_stand()
{
	aud_send_msg("start_last_stand");
	
	thread vision_set_fog_changes("berlin_emerge",0);
	
	move_player_to_start("player_start_last_stand");
	spawn_berlin_friendlies("player_start_last_stand");
	
	level.emerge_obj_num = level.objective_count;
	Objective_Add( level.emerge_obj_num, "current", &"BERLIN_TRAVERSE_BUILDING_OBJ");
	Objective_OnEntity(level.emerge_obj_num, level.lone_star);
	level.objective_count++;

	
	building = getent("building_to_destroy", "script_noteworthy");
	building delete();	
	
	flag_set( "emerge_dialogue_done" );
	flag_set( "emerge_door_begin_open" );
	thread berlin_setup_tvs();	
}


start_reverse_breach()
{
	aud_send_msg("start_reverse_breach");
	
	thread vision_set_fog_changes("berlin_emerge_hotelhall",0);
	
	
	move_player_to_start("player_start_reverse_breach");
	spawn_berlin_friendlies("player_start_reverse_breach");

	level.last_stand_obj = level.objective_count;
	
	flag_set( "exfil_hallway_dudes_dead" );
}


//Turning the spotlight on when the breach moment happens
	breach_spot_light()
	{
	light = GetEnt( "breach_spot_light", "targetname" );
		if( !isdefined( light ) )
		return;
	{  
		wait(2.25); 
		//iprintlnbold( "light on?" );
    delta = .16;
		val = 0.001;
		while( val < 2.75 )
			{
			val = ( val + delta );
      light SetLightIntensity( ( val ) );
   		//iprintlnbold( val );
			wait(.05);
			}		
	}      
	//iprintlnbold( "hurr" );  
	light SetLightIntensity( 2.75 );
}


berlin_intro()
{
	aud_send_msg("start_berlin_intro");
	
	//no battle chatter for the duration of the fallen building
	thread battlechatter_off("allies");
	
	//setup player and friendlies
	player_teleport_loc = getstruct("player_teleport","targetname");
	teleport_player(player_teleport_loc);
	level.player DisableWeapons();
	
	spawn_friendlies( "intro_lonestar_teleport", "lone_star", false );
	spawn_friendlies( "intro_essex_teleport", "essex", false );
	spawn_friendlies( "intro_truck_teleport", "truck", false );
	
	lone_star_teleport_loc = getstruct("lone_star_teleport","targetname");
	level.lone_star forceTeleport(lone_star_teleport_loc.origin, lone_star_teleport_loc.angles);

	level.lone_star disable_sprint();

	essex_teleport_loc = getstruct("essex_teleport","targetname");
	level.essex forceTeleport(essex_teleport_loc.origin, essex_teleport_loc.angles);
	
	truck_teleport_loc = getstruct("truck_teleport","targetname");
	level.truck forceTeleport(truck_teleport_loc.origin, truck_teleport_loc.angles);
	
	level.essex change_character_model( "body_delta_woodland_assault_aa_dusty" );
	level.truck change_character_model("body_hero_truck_delta_dusty");
	level.lone_star change_character_model("body_hero_sandman_delta_dusty");
	
	flag_set( "is_intro" );
	
	thread player_speed_percent( 75 );
	thread aftermath_se();//getup vm and lonestar
	thread aftermath_ambush();
	thread path_heroes_post_building_collapse();
	delaythread ( 8, ::setup_corporate_ambient, true ); //corpses and dying dudes
	thread traverse_building_ally_behavior();
	thread building_falling_column( true );
	thread intro_sequence();
	thread reset_after_intro();
	thread intro_fade_2_white();
	thread intro_player_disable_grenades();
	
	flag_wait( "intro_dialogue_complete" );
	
	wait(5);
	
	thread intro_artillery_shot();
	
	wait( 2 );
	flag_set( "start_intro_fade_2_white" );
	
	level.player AllowFire( false );//don't allow friendly fire
	level.player AllowMelee( false );//don't allow friendly fire
	level.player EnableInvulnerability();//don't allow death
	
	level notify( "building_traverse_end" ); //clean up
	
	flag_wait("intro_outro_full_white");
	
	//delete the heros since the helicopter spawns it's own.
	foreach( guy in level.heroes)
	{
		level.heroes = array_remove(level.heroes, guy);
		guy stop_magic_bullet_shield();
		guy delete();
	}
	
	flag_wait("intro_sequence_complete");
	
	//set player back to normal
	level.player DisableInvulnerability();
	level.player AllowMelee( true );
	level.player AllowFire( true );
	level.player enableoffhandweapons();
	thread player_speed_percent( 100 );
	
	autosave_by_name( "berlin_intro_01" );
}


berlin_heli_ride()
{
	aud_send_msg("start_heli_ride");
	thread heli_ride_intro_text();
	thread spawn_intro();	
	apache = spawn_apache();
	playerbird = spawn_playerbird();
	deadbird = spawn_deadbird();
	thread spawn_intro_helicopters();
	thread maps\berlin_fx::intro_dof();
	
	setsavedDvar( "g_friendlyNameDist", 100 );
	SetSavedDvar( "compass", "0" );
	
	level.player givestartammo(level.primary_weapon);
	level.player setweaponammoclip(level.primary_weapon, WeaponClipSize( level.primary_weapon ));
	
	level.player givestartammo(level.secondary_weapon);
	level.player setweaponammoclip(level.secondary_weapon, WeaponClipSize( level.secondary_weapon ));
	
	//this comes from loadout?
	level.player GiveWeapon( "fraggrenade" );
	level.player GiveWeapon( "ninebang_grenade" );	
	level.player switchToWeapon( level.primary_weapon );
	
	SetUpPlayerForAnimations();
	level.player DisableWeapons();
	playerbird lerp_player_view_to_tag(level.player, "TAG_GUY2", 0.05, 1, -90, 65, 20, 20);
	playerbird thread magic_bullet_shield();
	
	setsaveddvar("sm_sunsamplesizenear", 0.05);
	
	level.player SetPlayerAngles( (0,88,0) );
	
	tag_origin = spawn_tag_origin();
	tag_origin LinkTo( playerbird, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	//level.lone_star thread anim_loop_solo(level.lone_star, "heli_ride", "stop_heli_ride_anim");
	thread intro_heli_ride_sandman_anims();
	
	//waiting for intro to fade out to give sandman enough time to talk later.  spawning mainly so we get the sounds and helicopters spawned
	flag_wait("intro_start_on_path");
	
	gopath(apache);
	gopath(playerbird);
	gopath(deadbird);
	thread heli_ride_ambient(deadbird);
	
	level.player EnableInvulnerability();
		
	flag_set("start_level_ambient");
	
	thread rooftop_action(apache, deadbird);
	thread monitor_little_bird_unload(playerbird);
	
	bad_guys = getaiarray("axis");
	foreach( ai in bad_guys)
		ai.ignoreall = true;
		
	add_global_spawn_function( "axis", ::ignore_all_wrapper );
	
	wait(21);
	level.player EnableWeapons();
	setsavedDvar( "g_friendlyNameDist", 15000 );
	
	playerbird waittill ("unloaded");
	delaythread( .75, ::activate_trigger_with_targetname, "trig_path_truck_grinch_post_heli_land" );
	
	setsaveddvar("sm_sunsamplesizenear", .25);
	
	flag_wait("player_unloaded_from_intro_flight");
	
	level.player DisableInvulnerability();
	level.player enabledeathshield( true );
	
	aud_send_msg( "mus_player_unloaded_from_intro_flight" );
	SetUpPlayerForGamePlay();
	SetSavedDvar( "compass", "1" );
	
	level.player delaycall( 3, ::enabledeathshield, false );
	
	remove_global_spawn_function( "axis", ::ignore_all_wrapper );
	
	bad_guys = getaiarray("axis");
	foreach( ai in bad_guys)
		ai.ignoreall = false;	
	
	despawn_intro();
	
	//Setting up Friendlies to have bullet shields.
	little_bird_friendlies = getentarray("little_bird_friendlies","script_noteworthy");
	foreach( ai in little_bird_friendlies)
	{
		if(!isSpawner(ai))
		{
			ai thread stop_magic_bullet_shield();
		}
	}
	
	playerbird stop_magic_bullet_shield();
}

berlin_chopper_crash() 
{
	array_thread( level.heroes, ::set_goal_radius, 200 );
	battlechatter_on( "allies" );//it's been off since the intro
	
	thread start_indoor_think();
	thread start_outdoor_think();
	thread monitor_building_throw();
	thread monitor_mainstreet_battle();
	thread monitor_aa_frag_throw();
	thread kill_player_triggers( "kill_player_sniper", "player_rappels" );
	
	//objective dots through AA building
	aa_building_obj_loc = getstruct("aa_building_obj_loc_1", "targetname");
	level.over_obj_num = level.objective_count;
	Objective_Add( level.over_obj_num, "current", &"BERLIN_OVERWATCH", aa_building_obj_loc.origin );
	level.objective_count++;	
	thread MonitorAABuildingAmbiance();
	
	flag_wait( "aa_building_obj_loc_2" );//this comes from a radiant trig
	aa_building_obj_loc = getstruct("aa_building_obj_loc_2", "targetname");
	Objective_Position( level.over_obj_num, aa_building_obj_loc.origin );
	
	flag_wait( "aa_building_obj_loc_3" );//this comes from a radiant trig
	aa_building_obj_loc = getstruct("aa_building_obj_loc_3", "targetname");
	Objective_Position( level.over_obj_num, aa_building_obj_loc.origin );
}

berlin_clear_roof() 
{
	flag_wait("player_on_roof");
	autosave_by_name( "clear_roof_01" );
	
	spawn_rappel_ropes();
	thread roof_top_sniper();
}

berlin_sniper()
{
	array_thread( level.heroes, ::disable_cqbwalk);
	array_thread( level.heroes, ::set_neverEnableCQB, true);
	flag_wait("snipe_player_in_position");
	objective_complete( level.over_obj_num );
	
	thread sniper_objectives();
	
	flag_wait("paint_targets_vo");
	autosave_by_name( "berlin_sniper_01" );
	
	flag_wait( "parkway_tank_dead" );
	level.a10_suppress_ready_vo = true;
	
	//turning off forever :(
	thread maps\berlin_a10::airstrike_off();
	
	flag_wait( "bravo_team_reached_lower_rooftop" );
	thread battlechatter_off( "allies" );//turning off until bridge battle
	
	flag_wait("sniper_complete");
}

berlin_rappel()
{
	//objective
	obj_rappel_loc = getstruct("obj_rappel_loc", "targetname");
	level.rappel_obj_num = level.objective_count;
	Objective_Add( level.rappel_obj_num, "current", &"BERLIN_RAPPEL_OBJ", obj_rappel_loc.origin );
	Objective_SetPointerTextOverride(level.rappel_obj_num, &"BERLIN_RAPPEL");
	level.objective_count++;
	
	thread buildingrappel();
	
	wait( 1 );
	autosave_by_name( "sniper_complete_01" );
	
	flag_wait("player_rappels");
	flag_wait("rappel_end");
	
	array_thread( level.heroes, ::set_neverEnableCQB);
}

berlin_rappel_complete() 
{
	thread downed_apache_dudes();
	thread spin_chopper_blades();
	
	flag_wait( "rappel_complete" );
	
	thread delete_pipes_in_volume( "delete_pipes_volume" );
	
	objective_complete( level.rappel_obj_num);
	
	//objective
	obj_advance_to_bridge = getstruct("obj_advance_to_bridge", "targetname");
	assert(!isdefined(level.take_bridge_obj_num));
	level.take_bridge_obj_num = level.objective_count;
	objective_loc = getstruct("bridge_battle_objective_location", "targetname");
	Objective_Add( level.take_bridge_obj_num, "current", &"BERLIN_SUPPORT_SANDMAN", objective_loc.origin);//is completed with clear_bridge
	//Objective_OnEntity(level.take_bridge_obj_num, level.lone_star);
	level.objective_count++;
}

berlin_clear_bridge()
{
	thread bridge_tank_battle();	
	thread parkway_advance_tanks();
	thread monitor_bridge_battle_ambient();
	
	//path allies forward
	thread path_heroes_post_bridge_tank_destroyed();
	
	//thread bridge_activate_a10_hint();
	
	//setup Advance color groups
	//thread maps\berlin_util::color_volume_advance( "bridge_battle_color_advance", 1 );
	//thread maps\berlin_util::color_volume_advance( "bridge_battle_color_advance", 2 );
	//turning the color advance trigger off until the player has killed the tanks and the btr.
	//thread monitor_bridge_battle_color_advance();

	flag_wait("player_at_bridge_battle");
	level.a10_suppress_ready_vo = false;
	flag_set("stop_chopper_blade");
	//level notify( "bridge_activate_a10_hint" );
	battlechatter_on( "allies" );//it's been off since the end of the sniper section
	//complete follow lone star obj
	objective_complete( level.take_bridge_obj_num );
	
	//put objective on the tanks and do fun objective positioning, also make the rpg glowy
	thread destroy_tanks_objective( level.rus_tanks );
	
	//setup Advance color groups
	//thread maps\berlin_util::color_volume_advance( "parkway_color_advance", 1 );	
	
	flag_wait("rus_all_tanks_dead");
	aud_send_msg("mus_bridge_battle_all_tanks_dead");
	
	//complete the kill tank objective
	objective_complete(level.kill_tanks_obj);
	autosave_by_name( "berlin_clear_bridge_01" );
	
	//change the objective marker
	obj_advance_to = getstruct("start_parkway_objective", "targetname");
	level.adv_pky_obj_num = level.objective_count;
	Objective_Add( level.adv_pky_obj_num, "current", &"BERLIN_ADVANCE_OBJ", obj_advance_to.origin);
	level.objective_count++;
}


berlin_advance_pkway()
{
	//path allies forward
	thread path_heroes_post_tanks_over_barrier_1();
	
	flag_wait("usa_tanks_start_parkway");
	
	//setup ally spawners to be in godmode
	spawners = getentarray( "end_of_parkway_allies", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::magic_bullet_shield );
	array_thread( spawners, ::add_spawn_function, ::set_allowpain, false );
	
	thread monitor_parkway_drones();//setup friendlies to respawn from bridge and attack up the street
	thread monitor_parkway_player_path();//sets up threat bais groups to left or right side of street.
	thread random_tracers( "parkway_tracer_south", "parkway_tracer_north","lone_star_wounded");//add some tracers over head as the player heads down the parkway

	flag_wait( "update_parkway_obj_loc_1" );
	
	//Support Lonestar advance with tanks obj
	obj_advance_to = getstruct("obj_advance_to_collapse", "targetname");
	Objective_Position( level.adv_pky_obj_num, obj_advance_to.origin);
}

berlin_building_collapse()
{
	//building collapse
	thread building_collapse_setup_subcompact(); //setup subcompact car that has started it first frame of anim
	thread monitorWoundedLonestar();
	
	flag_wait("player_interacting_with_wounded_lonestar");
	Objective_Position( level.adv_pky_obj_num, (0,0,0) );
	aud_send_msg( "mus_start_building_collapse" );
	
	//no battle chatter for the duration of the fallen building
	thread battlechatter_off("allies");
	
	flag_set( "not_intro" );
	flag_set( "parkway_retreat_start" );
	
	objective_position(level.adv_pky_obj_num, (0,0,0));

	flag_wait("player_teleport_after_collapse_complete");
	
	aud_send_msg( "mus_player_teleport_after_building_collapse" );
	
	thread player_speed_percent( 75 );
	thread aftermath_se();//getup vm and lonestar
	thread aftermath_ambush();
	thread path_heroes_post_building_collapse();
	//corpses and dying dudes
	delaythread ( 8, ::setup_corporate_ambient, false );
	
	wait(8);//wait a little after the transition so the objective dot does not ruin the moment
	//objective_state(level.adv_pky_obj_num, "failed");
	objective_complete( level.adv_pky_obj_num );

	level.emerge_obj_num = level.objective_count;
	off_street_obj = getstruct("off_street_obj", "targetname");
	Objective_Add( level.emerge_obj_num, "current", &"BERLIN_TRAVERSE_BUILDING_OBJ", off_street_obj.origin );
	level.objective_count++;
}

berlin_traverse_building()
{
	thread monitor_traverse_building_ambient();
	thread building_falling_column( false );
	thread traverse_building_ally_behavior();
	
	flag_wait("building_collapse_player_safe");
	Objective_OnEntity(level.emerge_obj_num, level.lone_star);
	
	thread monitor_roof_collapse( false );
	thread random_shake();
	thread traverse_building_tank_corpse();
}

berlin_emerge()
{	
	thread berlin_setup_tvs();	
	thread setup_emerge_combat();
	
	flag_wait("building_traverse_end");
	flag_wait( "emerge_door_open" );
	
	thread player_speed_percent( 100, 2 );
	
	obj_pos = getstruct( "hotel_obj_marker", "targetname" );
	Objective_Position( level.emerge_obj_num, obj_pos.origin );
	
	thread battlechatter_on("allies"); //battle chatter turns back on for the allies
	
	flag_wait("emerge_hotel_in_view");
}

berlin_last_stand()
{
	flag_wait("start_last_stand");
	autosave_by_name( "berlin_last_stand_1" );

	thread setup_defend_sequence();
	thread setup_run_to_roof();
	
	//objective
	objective_complete( level.emerge_obj_num );
	level.last_stand_obj = level.objective_count;
	obj_pos = getstruct( "last_stand_obj_marker_1", "targetname" );
	Objective_Add( level.last_stand_obj, "current", &"BERLIN_FALL_BACK_TO_ROOF" );
	Objective_Position( level.last_stand_obj, obj_pos.origin );
	level.objective_count++;
	
	flag_wait( "obj_last_stand_advance_1" );//this comes from radiant
	obj_pos = getstruct( "last_stand_obj_marker_2", "targetname" );
	Objective_Position( level.last_stand_obj, obj_pos.origin );
	
	flag_wait( "door_hotel_stairs_1_open" );
	obj_pos = getstruct( "last_stand_obj_marker_3", "targetname" );
	Objective_Position( level.last_stand_obj, obj_pos.origin );
	
	flag_wait("player_top_of_hotel_stairwell");
}

berlin_reverse_breach()
{
	thread setup_reverse_breach();
	
	reverse_breach_obj_loc = getstruct("reverse_breach_objective_origin", "targetname");
	Objective_OnEntity(	level.last_stand_obj, level.lone_star );
	
	flag_wait( "reverse_breach_ready" );
	Objective_Position( level.last_stand_obj, reverse_breach_obj_loc.origin );
	Objective_SetPointerTextOverride( level.last_stand_obj, &"BERLIN_BREACH" );
	
	flag_wait("reverse_breach_start");
	exfil_obj_loc = getstruct("exfil_objective_origin", "targetname");
	Objective_Position(	level.last_stand_obj,exfil_obj_loc.origin);
	Objective_SetPointerTextOverride( level.last_stand_obj, "" );
	
	
	thread breach_spot_light();
	
	
	thread battlechatter_off("allies");
	
	thread monitor_end_mission();
	
	flag_wait( "reverse_breach_complete" );
	Objective_Position(	level.last_stand_obj, (0, 0, 0) );
}

berlin_carfire_rappel()
{
	level endon("fx_zone_3000_deactivating");
	light = GetEnt( "berlin_carfire_rappel", "targetname" );
	if( !isdefined( light ) )
		return;
		
	//flickerLight( color0, color1, minDelay, maxDelay )
	
	level waittill("fx_zone_3000_activating");

	light SetLightIntensity( ( 3 ) );
	light thread maps\_lights::flickerLight( ( 0.952941, 0.807843, 0.462745 ), ( 0.600000, 0.325490, 0.050980 ), .005, .085 );

	original_origin = light.origin;
	original_angles = light.angles;
	original_radius = light.radius;
	
	random_x		= 10;
	random_y 		= 10;
	random_z 		= 10;
	random_r 		= 2;
	min_delay 	= .15;
	max_delay 	= .35;
	
	while( 1 )
	{
		delay = RandomFloatRange( min_delay, max_delay );
		amount = randomfloatrange( .1, 1 );
	
		x = ( random_x * ( randomfloatrange( .1, 1 ) ) );
		y = ( random_y * ( randomfloatrange( .1, 1 ) ) );
		z = ( random_z * ( randomfloatrange( .1, 1 ) ) );
		r = ( random_r * ( randomfloatrange( .1, 1 ) ) );

		new_position = original_origin + ( x, y, z );
		new_radius = original_radius - ( r );
		light moveto( new_position, delay ) ;
		light SetLightRadius( new_radius );
		wait delay;
	}
	light SetLightIntensity( 0 );	
}

traffic_light_green_off_blinky()
{
	wait(RandomFloatRange( 0.05, 1) );
	self endon( "death" );
	while ( 1 )
	{
		self SetModel( "berlin_traffic_signal_2x_01_green_on" );
		wait .75;
		self SetModel( "berlin_traffic_signal_2x_01_off" );
		wait .75;
	}
}

traffic_light_red_off_blinky()
{
	wait(RandomFloatRange( 0.05, 1) );
	self endon( "death" );
	while ( 1 )
	{
		self SetModel( "berlin_traffic_signal_2x_01_red_on" );
		wait .75;
		self SetModel( "berlin_traffic_signal_2x_01_off" );
		wait .75;
	}
}

traffic_light_yellow_off_blinky()
{
	wait(RandomFloatRange( 0.05, 1) );
	self endon( "death" );
	while ( 1 )
	{
		self SetModel( "berlin_traffic_signal_2x_01_yellow_on" );
		wait .5;
		self SetModel( "berlin_traffic_signal_2x_01_off" );
		wait .25;
	}
}

traffic_light_yellow_green_blinky()
{
	wait(RandomFloatRange( 0.05, 1) );
	self endon( "death" );
	while ( 1 )
	{
		self SetModel( "berlin_traffic_signal_2x_01_yellow_on" );
		wait .75;
		self SetModel( "berlin_traffic_signal_2x_01_green_on" );
		wait .75;
	}
}