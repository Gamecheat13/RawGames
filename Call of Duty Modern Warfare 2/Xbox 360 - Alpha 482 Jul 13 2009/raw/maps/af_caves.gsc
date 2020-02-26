/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
Level: 	"Off The Grid"  af_caves.bsp               
Campaign: 	
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */ 

#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\_slowmo_breach;
#include maps\af_caves_code;

#using_animtree( "generic_human" );

main()
{
	default_start( ::start_default );
	add_start( "rappel", ::start_rappel );
	add_start( "entrance", ::start_cave_entrance );
	add_start( "steam", ::start_steamroom );
	add_start( "ledge", ::start_ledge );
	add_start( "overlook", ::start_overlook );
	add_start( "control", ::start_control_room );
	add_start( "airstrip", ::start_airstrip );
	
	precacheModel( "com_flashlight_on" );
	
	precacheItem( "littlebird_FFAR" );
	precacheItem( "scar_h_thermal_silencer" );
	precacheItem( "usp_silencer" );
	precacheItem( "rappel_knife" );
	precacheItem( "rpg_straight" );	
	
	PreCacheRumble( "damage_heavy" );
	
	level.mortarNoIncomingSound = true;
	level.mortarNoQuake = true;
	
	maps\af_caves_fx::main();
	maps\af_caves_precache::main();

	VisionSetNaked( "af_caves_outdoors", 0 );
	
	//intro fog
	setExpFog( 3764.17, 19391, 0.661137, 0.554261, 0.454014, 0.7, 0 );

	setsaveddvar( "cg_cinematicFullScreen", "0" );

	level.goodFriendlyDistanceFromPlayerSquared = 250 * 250;
	level.cosine[ "70" ] = cos( 70 );
	level.cosine[ "45" ] = cos( 45 );
	
	maps\af_caves_backhalf::main_af_caves_backhalf_preload();
	maps\_attack_heli::preLoad();
	maps\_breach::main();
	
	maps\af_caves_anim::main(); 
	
	maps\_load::main();
	
	maps\af_caves_backhalf::main_af_caves_backhalf_postload();
	maps\_load::set_player_viewhand_model( "viewhands_player_us_army" );

	maps\_drone_ai::init();
	maps\_slowmo_breach::slowmo_breach_init();
	maps\_nightvision::main();
	common_scripts\_sentry::main();
	
	maps\_stealth::main();
	stealth_settings();
	maps\_patrol_anims::main();
	
	animscripts\dog\dog_init::initDogAnimations();
	maps\_idle::idle_main();
	maps\_idle_phone::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_coffee::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	
	thread maps\_mortar::bunker_style_mortar();
	level thread maps\af_caves_amb::main();

	fire_missile_setup();
	
	add_hint_string( "begin_descent", &"AF_CAVES_DESCEND", ::should_stop_descend_hint );
	
	// Press^3 [{+actionslot 1}] ^7to use Night Vision Goggles.
	add_hint_string( "nvg", &"SCRIPT_NIGHTVISION_USE", maps\_nightvision::ShouldBreakNVGHintPrint );

	maps\_compass::setupMiniMap( "compass_map_afghan_caves" );
	
//	****** Flag Inits ****** //
//  Intro
	flag_init( "price_unstable_comment" );
	flag_init( "price_rise_up" );
	flag_init( "price_intro_stop" );
   	flag_init( "price_at_hillside" );
   	flag_init( "player_shot_someone" );
    flag_init( "someone_became_alert" );
   	flag_init( "pri_takeemout" );
   	flag_init( "rappel_threads" );
	flag_init( "price_abort_intro_stop" );
	
//  Rappel
	flag_init( "price_at_rappel" );
	flag_init( "price_hooksup" );
//	flag_init( "price_hookedup" );
	flag_init( "player_hooking_up" );
	flag_init( "player_hooked_up" );
	flag_init( "player_failed_rappel" );
	flag_init( "player_braked" );   	
	flag_init( "guard_2_exposing_himself" );
	flag_init( "player_killing_guard" );
	flag_init( "player_rappeled" );
	flag_init( "end_of_rappel_scene" );
	flag_init( "shadow_breaking" );

//	Backdoor Barracks
	flag_init( "destroy_tv" );
	flag_init( "speakers_active" );
	flag_init( "price_said_letsgo" );
	flag_init( "price_said_grabit" );
	flag_init( "player_picked_up_headset" );
	flag_init( "enemies_alerted" );
	flag_init( "descending" );	
	flag_init( "rappel_end" );
	flag_init( "take_point" );

//	Steam Room
	flag_init( "steamroom_halfway_point" );
	flag_init( "blow_cave" );
	flag_init( "grp1_lights_out" );
	flag_init( "grp3_lights_out" );
	flag_init( "left_mg_guy_spawned" );
	flag_init( "get_out" );
	
//	Ledge	
	flag_init( "price_get_down" );
	flag_init( "price_dived" );
	flag_init( "rockets_fired" );
	flag_init( "bridge_hit" );
	flag_init( "price_prebridge_node" );
	flag_init( "rpg_guys_go_guns" );	
	
//	Cavern		
	flag_init( "sentry_fired" );
	
//	Control Room
	flag_init( "controlroom_door_clip_on" );
 	flag_init( "controlroom_door_clip_off" );

//	Airstrip
	flag_init( "nade_tossers_retreat" );	
	flag_init( "rpg_hit" );
	flag_init( "price_kill_that_bird" );
	flag_init( "player_found_price" );
		
	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "price" );		
	createthreatbiasgroup( "intro_sniper_spawner" );
	createthreatbiasgroup( "airstrip_tower_enemy" );

	setignoremegroup( "price", "intro_sniper_spawner" );// sniper will ignore price
	setignoremegroup( "intro_sniper_spawner", "price" );// price will ignore sniper

	setignoremegroup( "price", "airstrip_tower_enemy" );// airstrip_tower_enemy will ignore price
	setignoremegroup( "airstrip_tower_enemy", "price" );// price will ignore airstrip_tower_enemy

	level.player setthreatbiasgroup( "player" );

	intro_sniper_spawner = getent( "enemy_road_sniper", "targetname" );
	intro_sniper_spawner add_spawn_function( ::set_thread_bias_group, "intro_sniper_spawner" );
	
	airstrip_tower_enemy = getentarray( "tower_gunners", "script_noteworthy" );
	array_thread( airstrip_tower_enemy, ::add_spawn_function, ::set_thread_bias_group, "airstrip_tower_enemy" );
	
	price_spawner = getent( "price_spawner", "targetname" );
	price_spawner add_spawn_function( ::price_spawn );
	price_spawner add_spawn_function( ::set_thread_bias_group, "price" );
	price_spawner spawn_ai();

	
//  Intro
	array_spawn_function_noteworthy( "enemy_road_patrollers_dogs", ::dog_think);

//	Backdoor Barracks
	array_spawn_function_targetname( "backdoor_barracks_sleepers", ::backdoor_barracks_sleeper_think );
	array_spawn_function_targetname( "backdoor_barracks_patroller_guy1", ::no_cqb );
	array_spawn_function_targetname( "backdoor_barracks_patroller_guy2", ::no_cqb );
	array_spawn_function_targetname( "backdoor_barracks_patroller_guy3", ::no_cqb );
	array_spawn_function_targetname( "backdoor_barracks_patroller_guy2", ::enemy_starting_health );

	array_spawn_function_noteworthy( "backdoor_entrance_guard", ::enemy_starting_health);
	array_spawn_function_noteworthy( "backdoor_barracks_slackers_grp1", ::enemy_starting_health);
	array_spawn_function_noteworthy( "backdoor_barracks_slackers_grp2", ::enemy_starting_health);
	array_spawn_function_noteworthy( "backdoor_barracks_smoker", ::enemy_starting_health);
	array_spawn_function_noteworthy( "backdoor_barracks_flashlight_guys_grp1", ::enemy_be_aggressive );
	array_spawn_function_noteworthy( "stealth_breakers", ::backdoor_barracks_give_flashlight);

	spawner_array = getentarray( "backdoor_barracks_flashlight_guys_grp1", "script_noteworthy" );
	array_thread( spawner_array, ::add_spawn_function, ::backdoor_barracks_give_flashlight );

//	Steam Room
	array_thread( getentarray( "steamroom_seaching_left", "script_noteworthy" ), ::add_spawn_function, ::steamroom_fallback );
	array_thread( getentarray( "steamroom_seaching_right", "script_noteworthy" ), ::add_spawn_function, ::steamroom_fallback );
	array_thread( getentarray( "steamroom_grp1_fallback", "script_noteworthy" ), ::add_spawn_function, ::steamroom_fallback );
	array_spawn_function_noteworthy( "steamroom_seaching_left", ::steamroom_enemy_flank_left );
	array_spawn_function_noteworthy( "steamroom_seaching_right", ::steamroom_enemy_flank_right );


//	Misc
	array_spawn_function_noteworthy( "aggressive_dudes", ::enemy_be_aggressive );
	array_thread( getentarray( "clip_nosight", "targetname" ), ::clip_nosight_logic );

	player_rope = getent( "player_rope", "targetname" );
	player_rope hide();
	
	price_new_rope = getent( "soldier_rope", "targetname" );
	price_new_rope hide();

	rappel_railing_glowing = getent( "rappel_hookup_glowing", "targetname" );
	rappel_railing_glowing hide();
	
	bridge_cable = getent( "bridge_wires", "targetname" );
	bridge_cable hide();

   	bridge_clip = getent( "no_going_back", "targetname" );
   	bridge_clip notsolid();
   	bridge_clip connectpaths();
   	
	level.mortarNoIncomingSound = true;
	level.mortarNoQuake = true;
	
	thread rappel_setup();
	thread backdoor_setup();
	thread steamroom_setup();
	thread player_falling_kill_trigger();
	thread player_falling_removegun();
	thread setup_barrel_earthquake();
	thread price_unstable_comment();
	
	thread maps\af_caves_backhalf::AA_backhalf_init();
	
	for ( ;; )
	{
		flag_wait( "backdoor_barracks_tv" );
		thread tv_movie();
		flag_waitopen( "backdoor_barracks_tv" );
		level notify( "stop_cinematic" );
		StopCinematicInGame();
	}
}

//	****** Starts ****** //
start_default()
{
	thread half_particles_setup();
	thread set_player_positions();
	thread intro_setup();
	level.default_goalradius = 7800;
}

start_rappel()
{
	level notify( "use_start" );

	thread objective_follow_price();
	
	rappel_player = getent( "rappel_player", "targetname" );
	level.player setorigin( rappel_player.origin );
	level.player setplayerangles( rappel_player.angles );
	
	level.player stealth_default();
	
	rappel_price = getent( "rappel_price", "targetname" );
	level.price teleport( rappel_price.origin, rappel_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	
	wait .5;
	thread autosave_by_name( "rappel" );
	
	flag_set( "rappel_threads" );	
}

start_cave_entrance()
{
	level notify( "use_start" );
	
	flag_set( "end_of_rappel_scene" );
	
	activate_trigger_with_targetname( "spawner_backdoor_barracks_slakers" );// maybe move this somewhere's else later.
	
	thread rappel_price_setup_at_cave();
	
	cave_entrance_player = getent( "cave_entrance_player", "targetname" );
	level.player setorigin( cave_entrance_player.origin );
	level.player setplayerangles( cave_entrance_player.angles );

	level.player stealth_default();
	
	level.player GiveWeapon( "scar_h_thermal_silencer" );
	level.player SwitchToWeapon( "scar_h_thermal_silencer" );
			
	cave_entrance_price = getent( "cave_entrance_price", "targetname" );
	level.price teleport( cave_entrance_price.origin, cave_entrance_price.angles );

	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	level.price set_force_color( "r" );
	level.price allowedstances( "crouch" );

	wait .5;
	thread autosave_by_name( "cave_entrance" );
}

start_steamroom() //Starts at the bottom of the stairs just before the steamroom area.
{
	level notify( "use_start" );

	thread objective_locate_shehperd();
	thread objective_three_location_changes();
	thread price_free_to_kill();
	thread steamroom_pipe2_destruction();
	thread backdoor_barracks_investigators_dialogue();
	
	flag_set( "location_change_backdoor_barracks" );
	flag_set( "set_price_color_red" );
	flag_set( "price_said_letsgo" );
	
	activate_trigger_with_targetname( "control_room_visionset_indoors" );
	
	steamroom_player = getent( "steamroom_player", "targetname" );
	level.player setorigin( steamroom_player.origin );
	level.player setplayerangles( steamroom_player.angles );

	level.player stealth_default();
	
	level.player GiveWeapon( "scar_h_thermal_silencer" );
	level.player SwitchToWeapon( "scar_h_thermal_silencer" );
		
	steamroom_price = getent( "steamroom_price", "targetname" );
	level.price teleport( steamroom_price.origin, steamroom_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	
	level.price enable_ai_color();
	level.price set_force_color( "r" );
	
	activate_trigger_with_targetname( "price_to_steamroom" );

	thread turn_off_stealth();
	
	wait .5;
	thread autosave_by_name( "steamroom" );
}

start_ledge()
{
	level notify( "use_start" );
	level notify( "start_ledge" );
	
//	thread objective_locate_shehperd();
//	flag_set( "location_change_backdoor_barracks" );	
	flag_set( "take_point" );
	flag_set( "location_change_ledge" );	
	flag_set( "steamroom_halfway_point" );
	flag_set( "last_steamroom_guys" );
	flag_set( "turn_off_stealth" );
	flag_set( "get_out" );
	flag_set( "blow_cave" );
	
	ledge_player = getent( "ledge_player", "targetname" );
	level.player setorigin( ledge_player.origin );
	level.player setplayerangles( ledge_player.angles );
	
	level.player GiveWeapon( "scar_h_thermal_silencer" );
	level.player SwitchToWeapon( "scar_h_thermal_silencer" );
	
	ledge_price = getent( "ledge_price", "targetname" );
	level.price teleport( ledge_price.origin, ledge_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	
	thread turn_off_stealth();
	
	wait .5;
	thread autosave_by_name( "ledge" );
}

start_overlook()
{
	level notify( "use_start" );

	overlook_player = getent( "overlook_player", "targetname" );
	level.player setorigin( overlook_player.origin );
	level.player setplayerangles( overlook_player.angles );
	
	level.player GiveWeapon( "scar_h_thermal_silencer" );
	level.player SwitchToWeapon( "scar_h_thermal_silencer" );
	
	overlook_price = getent( "overlook_price", "targetname" );
	level.price teleport( overlook_price.origin, overlook_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	
	thread turn_off_stealth();
	thread objective_three_location_changes();
	
	flag_set( "turn_off_stealth" );
	flag_set( "player_crossed_bridge" );
	activate_trigger_with_targetname( "player_passed_bridge" );	
	
	wait .5;
	thread autosave_by_name( "overlook" );
}

start_control_room()
{
	level notify( "use_start" );
	
	activate_trigger_with_targetname( "control_room_visionset_indoors" );

	control_room_player = getent( "control_room_player", "targetname" );
	level.player setorigin( control_room_player.origin );
	level.player setplayerangles( control_room_player.angles );
	
	level.player GiveWeapon( "scar_h_thermal_silencer" );
	level.player SwitchToWeapon( "scar_h_thermal_silencer" );
	
	control_room_price = getent( "control_room_price", "targetname" );
	level.price teleport( control_room_price.origin, control_room_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	level.price set_ignoreme( false );
	
//	thread kill_sentry_minigun();
	thread turn_off_stealth();
	
	thread maps\af_caves_backhalf::controlroom_sheppard_close_the_door();
	thread maps\af_caves_backhalf::cavern_breach_that_door();
	thread maps\af_caves_backhalf::controlroom_breach_destruction();

	flag_set( "turn_off_stealth" );
	
	thread objective_locate_shehperd();
	thread objective_three_location_changes();
	flag_set( "location_change_overlook" );
}

start_airstrip()
{
	level notify( "use_start" );
	
	airstrip_player = getent( "airstrip_player", "targetname" );
	level.player setorigin( airstrip_player.origin );
	level.player setplayerangles( airstrip_player.angles );
	
	level.player GiveWeapon( "scar_h_thermal_silencer" );
	level.player SwitchToWeapon( "scar_h_thermal_silencer" );
	
	airstrip_price = getent( "airstrip_price", "targetname" );
	level.price teleport( airstrip_price.origin, airstrip_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	level.price set_ignoreme( false );
	
	thread turn_off_stealth();
	thread objective_locate_shehperd();
	thread objective_three_location_changes();

	flag_set( "location_change_control_room" );
	flag_set( "turn_off_stealth" );
	flag_set( "location_change_overlook" );
}

// ****** OBJECTIVES ****** // 

// ****** 1st Objective, Follow Cpt. Price ****** //
objective_follow_price()
{
	objective_number = 0;
	obj_position = level.price.origin;

	objective_add( objective_number, "active", &"AF_CAVES_FOLLOW_PRICE", obj_position );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, (0, 0, 70) );

	flag_wait( "price_hooksup" );

	wait .5;
	objective_state( objective_number, "done" );
	
	thread objective_rappel();
}

// ****** 2nd Objective, Rappel ****** //
objective_rappel()
{
	objective_number = 1;
	
	objective_add( objective_number, "active", &"AF_CAVES_RAPPEL", ( 3006, 11756, -1834 ) );
	objective_current( objective_number );
	
	flag_wait( "player_hooking_up" );

	wait 1;
	objective_state( objective_number, "done" );
}

// ****** 3rd Objective, Follow Cpt. Price ****** //
objective_follow_price_again()
{
	flag_wait( "price_said_letsgo" );
	
	objective_number = 2;
	obj_position = level.price.origin;

	objective_add( objective_number, "active", &"AF_CAVES_FOLLOW_PRICE", obj_position );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, (0, 0, 70) );

	flag_wait( "take_point" );

	wait .5;
	objective_state( objective_number, "done" );
	
	thread objective_locate_shehperd();
}

// ****** 4th Objective, Locate Shehpard ****** //
objective_locate_shehperd()
{
	flag_wait( "take_point" );
//	flag_wait( "price_said_letsgo" );
	
	wait 1;
	objective_number = 3;
	obj_position = getent( "origin_obj_ledge", "targetname" );
//	obj_position = getent( "origin_obj_backdoor_barracks", "targetname" );

	objective_add( objective_number, "active", &"AF_CAVES_LOCATE_SHEPHERD", obj_position.origin );
	objective_current( objective_number );
	
	thread objective_three_location_changes();
}

objective_three_location_changes()// Laying down bread crumbs for the player.
{
//	flag_wait( "location_change_backdoor_barracks" );

	objective_number = 3;
//	obj_position = getent( "origin_obj_ledge", "targetname" );
//	objective_position( objective_number, obj_position.origin );

	flag_wait( "location_change_ledge" ); 

	obj_position = getent( "origin_obj_overlook", "targetname" );
	objective_position( objective_number, obj_position.origin );

	flag_wait( "location_change_overlook" );

	obj_position = getent( "origin_obj_control_room", "targetname" );
	objective_position( objective_number, obj_position.origin );

	flag_wait( "location_change_control_room" );
	
	obj_position = getent( "origin_obj_airstrip", "targetname" );
	objective_position( objective_number, obj_position.origin );

	flag_wait( "sheppard_southwest" );
	
	obj_position = getent( "origin_obj_exit", "targetname" );
	objective_position( objective_number, obj_position.origin );
	
	flag_wait( "littlebird_crashed" );
	
	thread objective_regroup_on_price();
}

objective_regroup_on_price()
{
	objective_number = 4;
	obj_position = level.price.origin;

	objective_add( objective_number, "active", &"AF_CAVES_REGROUP_WITH_PRICE", obj_position );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, (0, 0, 70) );

	flag_wait( "level_exit" );

	objective_state( objective_number, "done" );
}

// ACT 1, SCENE 1
intro_setup()
{
	thread intro_fade_in();
	thread intro_dialogue_part1();
	thread intro_price_rise_out_of_sand();
	
	thread intro_dialogue_part2();
	thread intro_price_to_hillside();
	thread intro_price_hillside_nag();
    thread intro_price_hillside_dialogue();
    thread intro_price_order_attack();
    
    thread intro_road_patrol_grp1_dead();
	thread intro_price_goto_road();
	thread intro_spawn_road_sniper();	
}

intro_fade_in()
{
	//half buffer partciles for PS3
	SetHalfResParticles( true );

	level.player FreezeControls( true );

	introblack = create_client_overlay( "black", 1, level.player );

	wait( 0.5 );

	lines = [];
	lines[ lines.size ] = &"AF_CAVES_LINE1"; //"Just Like Old Times"
	lines[ "date" ]     = &"AF_CAVES_LINE2"; //Day 7 – 16:40:
	lines[ lines.size ] = &"AF_CAVES_LINE3"; //'Soap' MacTavish
	lines[ lines.size ] = &"AF_CAVES_LINE4"; //Site Hotel Bravo, Afghanistan
	
	level thread maps\_introscreen::introscreen_feed_lines( lines );

	wait( 4.5 );
	
	introblack FadeOverTime( 4 );
	introblack.alpha = 0;

	flag_set( "price_rise_up" );

	wait( 4 );
	introblack Destroy();
	
	thread autosave_by_name( "intro" );
	
	wait 1.5;
	level.player FreezeControls( false );
	level.player enableweapons();

}

intro_dialogue_part1()
{
	flag_wait( "price_rise_up" );
	
	wait 8;
	//Price: "The sandstorm's clearing, Let's go."
	radio_dialogue( "pri_stormclearing" );
	
	thread objective_follow_price();
}

intro_price_rise_out_of_sand()// Part of the intro, Price rises up out of the sand.
{
	flag_wait( "price_rise_up" );

	activate_trigger_with_targetname( "intro_color_trigger" );

	thread maps\af_caves_fx::introSandStorm();
	
	anim_ent = getnode( "price_get_up", "targetname" );
	tarp = spawn_anim_model( "tarp", anim_ent.origin );
	
	price_and_tarp[ 0 ] = level.price;
	price_and_tarp[ 1 ] = tarp;
	
	anim_ent anim_first_frame( price_and_tarp, "rise_up" );
	
	wait 6;
	anim_ent anim_single( price_and_tarp, "rise_up" );// Price gets up from his hiding spot

	level.price allowedstances( "stand", "crouch", "prone" );
	level.price.dontshootwhilemoving = true;
	level.price.dontEverShoot = true;	
}

intro_price_to_hillside()
{
	flag_wait( "price_goto_hillside" );
	
	thread intro_price_to_hillside_abort_notify( "player_moving_to_road" );
	thread intro_price_to_hillside_abort_notify( "_stealth_spotted" );
	thread intro_price_to_hillside_abort_notify( "player_shot_someone" );
	thread intro_price_to_hillside_abort_notify( "someone_became_alert" );
	
	level.price allowedstances( "crouch" );
	
	node = getnode( "intro_price_hold_up_node", "targetname" );
  	node anim_reach_solo( level.price, "intro_stop" );
  	
  	flag_set( "price_at_hillside" );
    flag_set( "price_intro_stop" );
    
	if ( flag( "price_abort_intro_stop" ) )
		return;
	
    node anim_single_solo( level.price, "intro_stop" );
}

intro_price_to_hillside_abort_notify( sNotifyString )
{
	level endon( "price_abort_intro_stop" );
	level waittill( sNotifyString );
	flag_set( "price_abort_intro_stop" );
}

intro_dialogue_part2()
{
	flag_wait( "headset_on" );
	
	//Price: "Let's see if these headsets still work."
	radio_dialogue( "pri_headsetswork" );

	//Shepherd: "Lieutenant, are your men in position?"
	radio_dialogue( "shp_inposition" );

	//Price: Lieutenant: "Yes sir, I have eyes patroling the caynon now."
	radio_dialogue( "lnt_canyon" );
}

intro_price_hillside_dialogue()
{
	level endon ( "player_moving_to_road" );
	level endon( "_stealth_spotted" );
	level endon( "player_shot_someone" );
	level endon( "someone_became_alert" );
	
	flag_wait( "price_at_hillside" );
	
	wait 1.25;
	//Price: "Soap, hold up."
	radio_dialogue( "pri_holdup" );
	
	//Price: "Enemy Patrol."
	radio_dialogue( "pri_enemypatrol" );
	
	flag_wait( "pri_takeemout");
	//Price: "Take'em out."
	radio_dialogue( "pri_takeemout" );
}

intro_price_hillside_nag()
{
	level endon( "price_goto_hillside" );
	
	wait 30;
	
	while ( !flag( "price_goto_hillside" ) )
	{
		wait( randomintrange( 25, 35 ) );
		if ( flag( "price_goto_hillside" ) )
			break;
			
		//Price: "Soap, over here."
		radio_dialogue( "pri_overhere" );
	}
	
	while ( !flag( "price_orders_roadside_attack" ) )
	{
		wait( randomintrange( 20, 30 ) );
		if ( flag( "price_orders_roadside_attack" ) )
			break;
			
		//Price: "Soap, over here."
		radio_dialogue( "pri_overhere" );
	}	
}

intro_price_order_attack()
{
	flag_wait ( "price_orders_roadside_attack" );
	flag_wait( "price_intro_stop" );

	thread autosave_by_name( "hillside" );
	
	flag_set( "pri_takeemout");

	add_wait( ::flag_wait, "_stealth_spotted" );
//	add_wait( ::flag_wait, "player_shot_someone" );
	add_wait( ::flag_wait, "someone_became_alert" );
	do_wait_any();
	
	wait 1;
    level.price.dontEverShoot = undefined;
	level.price set_ignoreme( false );
	
	level.price.baseAccuracy = 20; // I want him to take out a some enemies, but not all of them. 	
	
	af_caves_intro_stealth_settings();
}

intro_price_goto_road()
{
	add_wait( ::flag_wait, "road_patrol" );
	add_wait( ::flag_wait, "player_moving_to_road" );
	do_wait_any();
   	
	level.price set_ignoreme( true );
	
   	clip = getent( "price_hillside_clip", "targetname" );// so price doesn't fall down the cliff if the dogs attack him
   	clip notsolid();
   	clip connectpaths();
   	
	activate_trigger_with_targetname( "spawner_enemy_road_reinforcements" );
	
	anim_ent = getent( "price_slide_animent", "targetname" );
	anim_ent anim_reach_solo( level.price, "price_slide" );
	anim_ent anim_single_solo( level.price, "price_slide" );
	
	level.price set_ignoreme( false );
    level.price enable_ai_color();
	level.price allowedstances( "stand", "crouch", "prone" );
   	
	activate_trigger_with_targetname( "friendlies_move_to_road" );
	
	thread intro_road_clear();
}

intro_spawn_road_sniper()
{
	level endon( "road_patrol_dead" );

	flag_wait( "player_moving_to_road" );
		
	road_sniper_spawner = getent( "enemy_road_sniper", "targetname" );
	guy = road_sniper_spawner spawn_ai();
	guy.health = 1;
	assert( isalive( guy ) );
	
	guy thread intro_price_sniper_dialogue();

	guy waittill( "death", killer );
	
	if ( !isdefined( killer ) )
		return;
		
	if ( isplayer( killer ) )
	{
		//Price: "Good kill."
		radio_dialogue( "pri_goodkill" );
		return;
	}
	
	flag_wait( "kill_intro_sniper" );
	
	if( isalive( guy ) )
		guy kill();
}

intro_price_sniper_dialogue()
{
	self endon( "death" );
	
	wait 1;
	//Price: "Got a sniper, on the ridge to the east."
	radio_dialogue( "pri_sniperridgeeast" );
	
	//Price: "Take him out." 
	radio_dialogue( "pri_takehimout" );
}

intro_road_patrol_grp1_dead()
{
	level endon( "player_moving_to_road" );
	
	flag_wait( "road_patrol" );
	
	//Price: "Move."
	radio_dialogue( "pri_move2" );
}

intro_road_clear()
{
	flag_wait( "road_patrol2" );	
		
	level notify( "road_patrol_dead" );
	
	enemies = getaiarray( "axis" );
	waittill_dead_or_dying( enemies );
	
	//Price: "Clear. Move."
	radio_dialogue( "pri_clearmove" );
	
	thread intro_price_sees_thermalspike();
	
	flag_set( "rappel_threads" );
}

intro_price_sees_thermalspike()
{
	flag_wait( "price_dialogue_thermalspike" ); // flag triggered by price or player which ever hits it first

	//Price: "Soap, I'm picking up a thermal spike up ahead. The cave must be somewhere over the edge"
	radio_dialogue( "pri_thermalspike" );
}

// ACT 2, SCENE 1
rappel_setup()
{
	flag_wait( "rappel_threads" );
	
	thread rappel_guard_weapons();
	thread rappel_effects();
	thread rappel_kill_enemy_hint();
	thread rappel_price_hookup_nag();
	thread rappel_prices_rappel_start();
	thread rappel_show_objective_railing();
	thread rappel_player_rappel_setup();
	thread rappel_dialogue();
	thread rappel_ropes();
	thread rappel_price_setup_at_cave();
}

rappel_guard_weapons()//
{
	guards_guns = getentarray( "guard_weapons", "targetname" );
	foreach ( gun in guards_guns )
	{
		gun makeunusable();
		gun hide();
	}

	flag_wait( "player_killing_guard" );
	
	wait 1.75;
	guards_guns = getentarray( "guard_weapons", "targetname" );
	foreach ( gun in guards_guns )
	{
		gun show();
	}
	
	flag_wait( "end_of_rappel_scene" );

	wait 1;
	guards_guns = getentarray( "guard_weapons", "targetname" );
	foreach ( gun in guards_guns )
	{
		gun makeusable();
	}
}

rappel_player_rappel_setup()
{
	flag_wait( "price_hooksup" );

	wait 1.2;
	rappel_trigger = getent( "player_rappel_trigger", "targetname" );
	rappel_trigger sethintstring( &"AF_CAVES_RAPPEL_HINT" );	// Press and hold^3 &&1 ^7to rappel
	rappel_trigger waittill( "trigger" );
	rappel_trigger delete();
	
	level.player setstance( "stand" );
	
	activate_trigger_with_targetname( "spawner_backdoor_barracks_slakers" );
	
	//battlechatter_off( "axis" );

	af_caves_rappel_behavior();
}

rappel_effects()
{
	flag_wait( "rappel_end" );
	exploder( "rappel_disturbance" );
}

rappel_prices_rappel_start()
{
   	level.price allowedstances( "stand" );
 	level.price cqb_walk( "off" );
 	
	level.price.anim_ent = getent( "rappel_animent", "targetname" );
	level thread rappel_price_rappel( level.price.anim_ent );

	level.price.anim_ent anim_reach_solo( level.price, "pri_rappel_setup" );
	
	flag_set( "price_hooksup" );
	
	level.price.anim_ent anim_single_solo( level.price, "pri_rappel_setup" );

	if ( !flag( "player_hooking_up" ) )
		level.price.anim_ent thread anim_loop_solo( level.price, "pri_rappel_idle" );	
}

price_rope_hookup( guy )//notetrack
{
	level.price_rope = spawn_anim_model( "rope_price", level.price.anim_ent.origin );
	level.price.anim_ent thread anim_single_solo( level.price_rope, "rope_hookup" );
}

rappel_price_rappel( anim_ent )
{
	flag_wait( "player_hooking_up" );
	
	thread rappel_price_kill( anim_ent );
	level endon( "player_killing_guard" );
	
	level.price Set_Ignoreme( true );
	level.price Set_Ignoreall( true );
		
	// price is hooked up, now switch to the other rope model.	
	level.price_rope Delete();
	level.price_rope = spawn_anim_model( "rappel_rope_price", level.price.anim_ent.origin );
	
	price_and_rope[ 0 ] = level.price;
	price_and_rope[ 1 ] = level.price_rope;
	
	anim_ent anim_stopanimscripted();
	anim_ent anim_single( price_and_rope, "pri_rappel_jump" );
	
	anim_ent thread anim_loop( price_and_rope, "pri_hanging_idle", "stop_hang_idle" );
}

rappel_price_kill( anim_ent )
{
	flag_wait( "player_killing_guard" );
	
	wait 1;

	anim_ent notify( "stop_hang_idle" );
	anim_ent anim_stopanimscripted();
	level.price attach_model_if_not_attached( "weapon_parabolic_knife", "TAG_INHAND" );
	anim_ent thread anim_single_solo( level.price, "pri_rappel_kill" );
}

rappel_kill_enemy_hint()
{
	flag_wait( "rappel_end" );
	level.player enableweapons();

	// lerp view back to 0 fov
	level.player LerpViewAngleClamp( 0.5, 0.2, 0.2, 0, 0, 0, 0 );//( 0.5, 0.2, 0.2, 0, 0, 0, 0 )

	sHint = &"SCRIPT_PLATFORM_OILRIG_HINT_STEALTH_KILL";
	thread hint( sHint );
}

rappel_guards_think()
{
	self endon( "death" );
	
	self.battlechatter = false;
	self set_ignoreall( true );
	self set_ignoreme( true );
}

rappel_guard2_patrol()// this is the guard below the price
{
	level endon( "player_killing_guard" );
	
	anim_ent = getent( "flick_animent", "targetname" );
	self.animname = "guard_2";
	
	wait 2.75;
	anim_ent anim_single_solo( self, "flick" );
	
	anim_ent thread anim_loop_solo( self, "guardB_idle", "stop_guardB_idle" );
}

rappel_guard2_death()// this is the guard below the price
{
	anim_ent = getent( "rappel_animent", "targetname" );
	self.animname = "guard_2";
	
	flag_wait( "player_killing_guard" );
	
	wait 1;
	self thread gun_Remove();
	anim_ent anim_single_solo( self, "guard_2_death" );	
	
	self.a.nodeath = true;
	self.allowdeath = true;
	self.diequietly = true;
	self kill();
}

rappel_guard2_kill_player()// this is the guard below the price
{
	level endon( "player_killing_guard" );
	
	anim_ent = getent( "flick_animent", "targetname" );
	self.animname = "guard_2";
	
	flag_wait( "rappel_end" );
	
	wait .5;
	anim_ent notify( "stop_guardB_idle" );
	anim_ent thread anim_single_solo( self, "guardB_react" );
}

rappel_guard1_kill_player()// this is the guard below the player
{
	level endon( "player_killing_guard" );
	
	anim_ent = getent( "players_rappel_guard", "targetname" );
	self.animname = "guard_1";
	
	anim_ent thread anim_loop_solo( self, "guardA_idle", "stop_guardA_idle" );
	
	flag_wait( "rappel_end" );
	
	wait .5;
	anim_ent notify( "stop_guardA_idle" );
	anim_ent thread anim_single_solo( self, "guardA_react" );
	
	wait 2;
	thread hint_fade();
	
	level.player EnableDeathShield( false );
	level.player EnableHealthShield( false );

	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	
	level.player kill();
	
	flag_set( "player_failed_rappel" );
}

rappel_show_objective_railing()
{
	flag_wait( "price_hooksup" );
	
	wait .5;
	rappel_railing = getent( "rappel_hookup", "targetname" );
	rappel_railing hide();

	rappel_railing_glowing = getent( "rappel_hookup_glowing", "targetname" );
	rappel_railing_glowing show();

	flag_wait( "player_hooking_up" );

	rappel_railing = getent( "rappel_hookup", "targetname" );
	rappel_railing show();

	rappel_railing_glowing = getent( "rappel_hookup_glowing", "targetname" );
	rappel_railing_glowing hide();
}

rappel_dialogue()
{
	flag_wait( "pri_hook_up" );
	
	//Price: "Here we go - hook up here."
	radio_dialogue( "pri_hookup" );
	
	flag_wait( "player_hooking_up" );
	
	wait 5.5;
	thread autosave_by_name( "rappeling" );
	
	//Price: "Go."
	radio_dialogue( "pri_go" );
	
 	level.price thread play_sound_on_entity( "scn_afcaves_rappel_start_npc" );
	wait 5.3;
	//Price: "Got two tangos down below."
	radio_dialogue( "pri_2inthechest" );
	
	flag_wait( "rappel_end" );
	
	level endon( "player_killing_guard" );

	//Price: "Do it."
	radio_dialogue( "pri_doit" );
}

rappel_price_hookup_nag()
{
	flag_wait( "price_hooksup" );
	level endon( "player_hooking_up" );
	
	while ( !flag( "player_hooking_up" ) )
	{
		wait( randomintrange( 24, 34 ) );
		if ( flag( "player_hooking_up" ) )
			break;
			
	//* Price: "Soap, hook up."                                                                                    
		radio_dialogue( "pri_soaphookup" );
	
		wait( randomintrange( 20, 30 ) );
		if ( flag( "player_hooking_up" ) )
			break;

	//* Price: "Soap, what's the problem? Hook up to the railing."                                                                                    
		radio_dialogue( "pri_whatstheproblem" );
			
		wait( randomintrange( 20, 30 ) );
		if ( flag( "player_hooking_up" ) )
			break;

	//* Price: "Soap, hook up, let's go."
		radio_dialogue( "pri_hookupletsgo" );
	}	
}

rappel_ropes()
{
	flag_wait( "end_of_rappel_scene" );
	
	player_rope = getent( "player_rope", "targetname" );
	player_rope show();
	
	level.price_rope delete();

	price_new_rope = getent( "soldier_rope", "targetname" );
	price_new_rope show();
}

rappel_price_setup_at_cave()
{	
	flag_wait( "end_of_rappel_scene" );
	
	level.default_goalradius = 2048;
	level.price disable_surprise();
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price set_ignoreall( true );
	level.price set_ignoreme( true );
	level.price.dontshootwhilemoving = undefined;
	level.price.baseAccuracy = 25; // I want him to take out a some enemies, but not all of them. 
}

// ACT 3, SCENE 1
backdoor_setup()
{
	flag_wait( "end_of_rappel_scene" );
	
	activate_trigger_with_targetname( "spawner_backdoor_barracks_sleepers" );	
	
	thread objective_follow_price_again();
	thread backdoor_barracks_price_movement();
	thread backdoor_barracks_price_barracks_dialogue();
	thread backdoor_barracks_price_smoker_comment();
	thread backdoor_barracks_chess_dialogue();
	thread stealth_enemy_alerted();
	thread backdoor_pa_alarm();
	thread backdoor_price_dialogue();
	thread price_free_to_kill();

	thread backdoor_barracks_kill_slackers_grp1();
	thread backdoor_barracks_chess_players();
	thread backdoor_barracks_guard();
	thread backdoor_barracks_kill_remaining_slackers();
	thread backdoor_barracks_destroy_tv();
	thread backdoor_barracks_kill_sleepers_grp2();
	thread backdoor_barracks_tv_light();
	thread backdoor_barracks_investigators_dialogue();
	thread backdoor_barracks_end();

	thread steamroom_pipe2_destruction();
	thread turn_off_stealth();
}

backdoor_pa_alarm()
{
	flag_wait ( "enemies_alerted" );
	
	wait( randomintrange( 2, 4 ) );
	// Loudspeaker: "Site Hotel Bravo has been compromised! Go to full alert, I repeat go to full alert!"
	play_sound_on_speaker( "afcaves_sc2_fullalert" );

	flag_clear ( "enemies_alerted" );
}

backdoor_price_dialogue()
{	
	//Price: "Let's go." 
	radio_dialogue( "pri_letsgo" );

	flag_set( "price_said_letsgo" );
	
	//Price: "These guys are unaware of us and stealth is on our side for now, move slowly."
	radio_dialogue( "pri_unawareofus" );
}

backdoor_barracks_price_movement()
{
	flag_wait( "end_of_rappel_scene" );
	
    level.price allowedstances( "crouch" ); 
 
 	node = getnode( "price_easynow_node", "targetname" );
	level.price.radius = node.radius;
	level.price.fixednodesaferadius = node.fixednodesaferadius;  
	level.price setGoalNode( node );
	level.price set_ignoreall( false );// have price aiming at the chair gaurd as he walks by
      	
	add_wait( ::flag_wait, "entrance_guard" );
	add_wait( ::flag_wait, "entrance_chair_guard" );
	do_wait_any();

	level.price set_ignoreall( true );
	
	activate_trigger_with_targetname( "spawn_patroller_guy1" );
		
	level endon( "_stealth_spotted" );
	
	add_wait( ::flag_wait, "patroll_guy1" );
	add_wait( ::flag_wait, "patroller_guy_1" );
	add_wait( ::flag_wait, "patroll_guy1_passed_by" );	
	do_wait_any();
	
//	level.price set_ignoreall( false );// price aims at the patroller as he walks by?
	
	node = getnode( "price_smoker_node", "targetname" );
	level.price setGoalNode( node );

	add_wait( ::flag_wait, "smoker" );
	add_wait( ::flag_wait, "barracks_smoker" );
	do_wait_any();
	
//	level.price set_ignoreall( true );
	
	node = getnode( "price_going_left_node", "targetname" );
	level.price setGoalNode( node );
	
	level endon( "pre_stair_guy2" );
	level endon( "set_price_color_red" );
	
	add_wait( ::flag_wait, "headed_to_grp2_sleepers" );
	add_wait( ::flag_wait, "sleeper_guy1_grp2" );
	add_wait( ::flag_wait, "player_skipping_sleepers" );
	do_wait_any();
	
	node = getnode( "price_went_left_node", "targetname" );
	level.price setGoalNode( node );
	
	add_wait( ::flag_wait, "player_past_grp2_sleepers" );
	add_wait( ::flag_wait, "sleeper_guy2_grp2" );
	add_wait( ::flag_wait, "player_skipped_sleepers" );
	do_wait_any();
	
	node = getnode( "price_oh_shit_node", "targetname" );
	level.price.radius = node.radius;
	level.price.fixednodesaferadius = node.fixednodesaferadius;  
	level.price setGoalNode( node );
	
	add_wait( ::flag_wait, "trig_pre_stairs1" );
	add_wait( ::flag_wait, "pre_stair_guy1" );
	do_wait_any();
	
	node = getnode( "pre_stairs1", "targetname" );
	level.price setGoalNode( node );
}

backdoor_barracks_end()//all dead we are moving on/// price no move.....!!!!
{
	level endon( "_stealth_spotted" );
	
	add_wait( ::flag_wait, "pre_stair_guy2" );
	add_wait( ::flag_wait, "set_price_color_red" );
	do_wait_any();
	
	level.price set_ignoreall( false );
	level.price set_ignoreme( false );
	
	level.price thread friendly_adjust_movement_speed();
	level.price enable_ai_color();
	level.price set_force_color( "r" );
	
	activate_trigger_with_targetname( "price_to_steamroom" );
	
	flag_wait( "lights_out" );
	
	level.price set_ignoreall( true );
	level.price set_ignoreme( true );

	level.price notify( "stop_adjust_movement_speed" );
}

backdoor_barracks_investigators_dialogue()// The player is going up the stairs leading to the steamroom
{
	flag_wait( "set_price_color_red" );
	
	//Shadow Company 1: "Sir, we've lost contact with Alpha Team at the back door."   
	radio_dialogue( "sc1_lostcontact" );

	//Shadow Company 1: "We may have a problem."
	radio_dialogue( "sc1_haveaprob" );
	
	wait 1;
	//Price: "Soap, Take point"
	radio_dialogue( "pri_takepoint" );

	flag_set( "take_point" );

/*
	//Lieutenant: "Steam room,be advised, we're going dark."
	radio_dialogue( "lnt_goingdark" );

	//Shadow Company 3: "Roger, going dark."   
	radio_dialogue( "sc3_goingdark" );	
*/
}

backdoor_barracks_price_barracks_dialogue()
{
	level endon( "_stealth_spotted" );
	
	flag_wait( "backdoor_barracks_price_noise" );
	
	wait 1;
	//Price: "Easy now..."
	radio_dialogue( "pri_easynow" );
	
	flag_wait( "pri_suggest_go_left" );
	
	//Price: "Stay to the left" 
	radio_dialogue( "pri_staytoleft" );
}

backdoor_barracks_price_smoker_comment()
{
	level endon( "barracks_smoker" );
	level endon( "_stealth_spotted" );
	
	flag_wait( "past_by_quietly" );
	
	//Price: "I suggest we quietly pass by this fellow."
	radio_dialogue( "pri_quietlypassby" );
}

backdoor_barracks_chess_dialogue()
{
	level endon( "chess_players_broken" );	
	
	flag_wait( "chess_dialogue" );
	org = getent( "chess_speaker", "targetname" );
	
	add_wait( ::waittill_msg, "chess_players_broken" );
	org add_call( ::stopsounds );
	thread do_wait();
	
	thread backdoor_barracks_pri_chess_comment();
	
	//* Shadow Company 1: "What the hell are you doin'?" 
	org play_sound_in_space( "afcaves_sc1_whatthe", org.origin );
	
	//* Shadow Company 2: "What?"   
	org play_sound_in_space( "afcaves_sc2_what", org.origin );
	
	//* Shadow Company 1: "I saw that. You took your hand off the piece." 
	org play_sound_in_space( "afcaves_sc1_sawthat", org.origin );
		
	//* Shadow Company 2: "So?" 
	org play_sound_in_space( "afcaves_sc2_so", org.origin );
	
	//* Shadow Company 1: "So? So you can't move it again." 
	org play_sound_in_space( "afcaves_sc1_cantmove", org.origin );
		
	//* Shadow Company 1: "Try to rip me off again and I'll cut your throat." 
	org play_sound_in_space( "afcaves_sc1_cutyourthroat", org.origin );
	
	//* Shadow Company 2: "Whatever man." 
	org play_sound_in_space( "afcaves_sc2_whatever", org.origin );
}

backdoor_barracks_pri_chess_comment()
{	
	level endon( "set_price_color_red" );	
	
	flag_wait( "player_chess_right" );
	
	//Price: "Might I suggest we leave the Chess Masters be?"
	radio_dialogue( "pri_leavechess" );
}

backdoor_barracks_guard()// Kill him if the player doesn't.
{
	flag_wait( "player_walked_pass_guard" );
	
	backdoor_barracks_guard = get_living_ai( "backdoor_entrance_guard", "script_noteworthy");	
	
	if( isalive( backdoor_barracks_guard ) )
	{
		backdoor_barracks_guard kill();
	}
}

backdoor_barracks_sleeper_think()
{
	self endon( "death" );
	
	org = getent( self.target, "targetname" );
	org stealth_ai_idle_and_react( self, "sleep_idle1", "sleep_alert1" );

	self.deathanim = level.scr_anim[ "generic" ][ "sleep_death1" ];
	self thread maps\_idle::reaction_sleep();
	
	self waittill_either( "stealth_enemy_endon_alert", "_idle_reaction" );
	self.deathanim = undefined;
}

backdoor_barracks_chess_players()
{
	guy1 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_1" );
	guy2 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_2" );
	
	guy1 add_wait( ::ent_flag_waitopen, "_stealth_normal" );
	guy2 add_wait( ::ent_flag_waitopen, "_stealth_normal" );
	level add_func( ::send_notify, "chess_players_broken" );
	thread do_wait_any();
		
	guy1.animname = "chess_guy1";
	guy2.animname = "chess_guy2";
	guys = [];
	guys[ guys.size ] = guy1;
	guys[ guys.size ] = guy2;

	array_thread( guys, ::set_deathanim, "death" );
	array_thread( guys, ::set_allowdeath, true );
	array_thread( guys, ::set_ignoreall, true );

	node = getent( "chess_ent", "targetname" );
	node2 = spawn( "script_origin", node.origin );
	node2.angles = node.angles;
	
	node thread stealth_ai_idle_and_react( guy1, "idle_1", "surprise_1" );
	node2 thread stealth_ai_idle_and_react( guy2, "idle_2", "surprise_2" );

	array_thread( guys, ::backdoor_barracks_trigger_chess_zone );
	array_thread( guys, ::backdoor_barracks_chess_alert );
	array_thread( guys, ::backdoor_barracks_chess_players_alert );
}

backdoor_barracks_chess_players_alert()
{
	self stealth_enemy_waittill_alert();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted_bring_group( level.player.origin );
	self set_ignoreall( false );
	self.deathanim = undefined;
}

backdoor_barracks_trigger_chess_zone()// If the player gets near the the chess players, they become aware.
{
	level endon( "_stealth_spotted" );
	
	self endon( "damage" );
	self endon( "death" );
	
	flag_wait( "chess_players_zone" );
	
	self notify( "heard_scream", level.player.origin  );
}

backdoor_barracks_chess_alert()
{
	level endon( "_stealth_spotted" );
	
	self endon( "damage" );
	self endon( "death" );
	
	self addAIEventListener( "grenade danger" );
	self addAIEventListener( "gunshot" );
	self addAIEventListener( "bulletwhizby" );
	self addAIEventListener( "projectile_impact" );
	self addAIEventListener( "explode" );
	
	while( 1 )
	{
		self waittill( "ai_event", eventType );
		if ( eventType == "grenade danger" ||
				 eventType == "damage" ||
				 eventType == "gunshot" || 
				 eventType == "bulletwhizby" ||
				 eventType == "projectile_impact" ||
				 eventType == "explode" )
				break;
	}
}

backdoor_barracks_give_flashlight() // If stealth is blown, reinforcemts will spawn, give them flashlights.
{	
	self endon( "death" );
	self cqb_walk( "on" );
	self attach_flashlight();
}

backdoor_barracks_kill_slackers_grp1()// Kill them if the player doesn't.
{
	flag_wait( "player_walked_pass_slackers_grp1" );
	
	backdoor_barracks_slackers_grp1 = get_living_ai_array( "backdoor_barracks_slackers_grp1", "script_noteworthy");	
	foreach ( slacker in backdoor_barracks_slackers_grp1 )
	{
		if( isalive( slacker ) )
			slacker kill();
	}
}

backdoor_barracks_kill_sleepers_grp2()// Kill them if the player doesn't.
{
	flag_wait( "player_skipped_sleepers" );
	
	backdoor_barracks_slackers_grp2 = get_living_ai_array( "backdoor_barracks_slackers_grp2", "script_noteworthy");	
	foreach ( slacker in backdoor_barracks_slackers_grp2 )
	{
		if( isalive( slacker ) )
			slacker kill();
	}
}

backdoor_barracks_kill_remaining_slackers()// Kill any enemy left alive when the player leaves the barracks area.
{
	flag_wait( "backdoor_barracks_kill_all_slackers" );
	flag_set( "destroy_tv" );
	
	volume = getent( "backdoor_barracks_killer", "targetname" );

	enemies = getaiarray( "axis" );
	foreach ( guy in enemies ) 
	{
		if ( guy istouching( volume ) )
		{
			guy.diequietly = true;
			guy kill();
		}

	}
}

//  ACT 4, SCENE 1
steamroom_setup()
{
	thread steamroom_lighting_setup();
	thread steamroom_lights_go_out();
	thread steamroom_enemy_ambush_dialogue();
	
	thread steamroom_enemy_left_grp1();
	thread steamroom_enemy_right_grp1();
	thread steamroom_enemy_right_grp2();
	thread steamroom_enemy_right_grp3();
	
	thread steamroom_mg_gunner_right();
	thread steamroom_mg_gunner_left();
	
	thread steamroom_gunner_left_backup();
//	thread steamroom_reinforcements_grp1();
	thread steamroom_shepherd_blowit();
	//thread steamroom_blow_it_up();
	thread steamroom_price_warning();
	thread steamroom_flashbang_enemy();
	thread steamroom_delete_leftover_enemy();
	
	rt_attack = getent( "flank_rt_attack", "targetname" );
	rt_attack trigger_off();
	
	rock_rubble1 = getent( "steamroom_exit_rubble", "targetname" );
	rock_rubble1 notsolid();
	rock_rubble1 hide();
}

steamroom_lighting_setup()
{
	lights_out_grp1 = getentarray( "lights_off_grp1", "targetname" );
	array_thread( lights_out_grp1, ::_setLightIntensity, 1.5 );
	
	light_models_off_grp1 = getentarray( "security_lights_off_grp1", "targetname" );
	foreach ( light_model in light_models_off_grp1 )
	light_model hide();
	
	lights_out_grp2 = getentarray( "lights_off_grp2", "targetname" );
	array_thread( lights_out_grp2, ::_setLightIntensity, 1.7);
	
	light_models_off_grp2 = getentarray( "security_lights_off_grp2", "targetname" );
	foreach ( light_model in light_models_off_grp2 )
	light_model hide();
	
	lights_out_grp3 = getentarray( "lights_off_grp3", "targetname" );
	array_thread( lights_out_grp3, ::_setLightIntensity, 1.7);
	
	light_models_off_grp3 = getentarray( "security_lights_off_grp3", "targetname" );
	foreach ( light_model in light_models_off_grp3 )
	light_model hide();

	lights_out_grp4 = getentarray( "lights_off_grp4", "targetname" );
	array_thread( lights_out_grp4, ::_setLightIntensity, 1.5);
	
	light_models_off_grp4 = getentarray( "security_lights_off_grp4", "targetname" );
	foreach ( light_model in light_models_off_grp4 )
	light_model hide();
}

steamroom_lights_go_out()
{
	add_wait( ::flag_wait, "player_went_left" );
	add_wait( ::flag_wait, "player_going_far_right" );
	do_wait_any();

	//Shadow Company Leader: "Heh heh. All too easy. Take 'em!"
	org = getent( "mg_rt_speaker", "targetname" );
	org thread play_sound_in_space( "afcaves_scl_alltooeasy", org.origin );

	flag_set( "grp1_lights_out" );
	
	level.player playsound( "scn_blackout_breaker_box" );

	activate_trigger_with_targetname( "steamroom_outdoor_visionset" );
	
	lights_out_grp1 = getentarray( "lights_off_grp1", "targetname" );
	array_thread( lights_out_grp1, ::_setLightIntensity, 0 );

	light_models_on_grp1 = getentarray( "security_lights_on_grp1", "targetname" );
	foreach ( light_model in light_models_on_grp1 )
	light_model hide();

	light_models_off_grp1 = getentarray( "security_lights_off_grp1", "targetname" );
	foreach ( light_model in light_models_off_grp1 )
	light_model show();

	wait .75;
		
	thread steamroom_turn_on_nightvision();

	level.player playsound( "scn_blackout_breaker_box" );

	lights_out_grp2 = getentarray( "lights_off_grp2", "targetname" );
	array_thread( lights_out_grp2, ::_setLightIntensity, 0 );

	light_models_on_grp2 = getentarray( "security_lights_on_grp2", "targetname" );
	foreach ( light_model in light_models_on_grp2 )
	light_model hide();

	light_models_off_grp2 = getentarray( "security_lights_off_grp2", "targetname" );
	foreach ( light_model in light_models_off_grp2 )
	light_model show();

	wait .75;
	level.player playsound( "scn_blackout_breaker_box" );

	lights_out_grp3 = getentarray( "lights_off_grp3", "targetname" );
	array_thread( lights_out_grp3, ::_setLightIntensity, 0 );

	light_models_on_grp3 = getentarray( "security_lights_on_grp3", "targetname" );
	foreach ( light_model in light_models_on_grp3 )
	light_model hide();

	light_models_off_grp3 = getentarray( "security_lights_off_grp3", "targetname" );
	foreach ( light_model in light_models_off_grp3 )
	light_model show();
	
	flag_set( "grp3_lights_out" );
	
	wait .75;
	level.player playsound( "scn_blackout_breaker_box" );

	lights_out_grp4 = getentarray( "lights_off_grp4", "targetname" );
	array_thread( lights_out_grp4, ::_setLightIntensity, 0 );

	light_models_on_grp4 = getentarray( "security_lights_on_grp4", "targetname" );
	foreach ( light_model in light_models_on_grp4 )
	light_model hide();

	light_models_off_grp4 = getentarray( "security_lights_off_grp4", "targetname" );
	foreach ( light_model in light_models_off_grp4 )
	light_model show();	
}

steamroom_turn_on_nightvision()
{
	if ( maps\_nightvision::nightVision_check( level.player ) )
		return;

	wait .5;
	//Price: "Soap, go to night vision."
	thread radio_dialogue( "pri_nightvision" );

	wait 1.5;
	level.player thread display_hint( "nvg" );
}

steamroom_enemy_ambush_dialogue()
{
	flag_wait( "grp1_lights_out" );
	
	wait 3;
	//Shadow Company 2: "Roger engaging!"
	org = getent( "mg_rt_speaker", "targetname" );
	org play_sound_in_space( "afcaves_sc2_engaging", org.origin );
	
	battlechatter_on( "allies" );
}

steamroom_mg_gunner_right()
{
	flag_wait( "grp3_lights_out" );

	steamroom_gunner_right = getent( "steamroom_mg_right", "targetname" );
	steamroom_gunner_right spawn_ai();
}

steamroom_mg_gunner_left()
{
	flag_wait( "steamroom_attack_player" );
	
	thread steamroom_mg_left_wait();

	//Shadow Company Leader: "Gunner! Move - in!"
	org = getent( "mg_lt_speaker", "targetname" );
	org thread play_sound_in_space( "afcaves_scl_gunnermovein", org.origin );

	steamroom_gunner_left = getent( "steamroom_mg_left", "targetname" );
	guy = steamroom_gunner_left spawn_ai();
	guy endon( "death" );
	
	guy.favoriteenemy = level.player;
	
	flag_set( "left_mg_guy_spawned" );
	
	//Shadow Company 3: "Roger, gonna kick some ass."
	org play_sound_in_space( "afcaves_sc3_kicksome", org.origin );
}

steamroom_mg_left_wait()
{
	level endon( "player_going_left" );
	enemies = get_living_ai_array( "steamroom_seaching_left", "script_noteworthy" );
	waittill_dead_or_dying( enemies, 1 );
}

steamroom_gunner_left_backup()
{
	add_wait( ::flag_wait, "left_mg_guy_spawned" );
	add_wait( ::flag_wait, "player_went_right" );
	do_wait_any();

	gunner_lt_backup = getentarray( "steamroom_lt_gunner_backup", "targetname" );
	array_thread( gunner_lt_backup, ::spawn_ai );
}

steamroom_enemy_left_grp1()// spawn these guys early but make them wait until the player is close before attacking
{
	flag_wait( "lights_out" );	
	
	//Price: "Careful now." 
	radio_dialogue( "pri_carefulnow" );
	
	left_flankers = getentarray( "steamroom_flank_left_grp1", "targetname" );
	array_thread( left_flankers, ::spawn_ai );
}

steamroom_enemy_right_grp1()
{
	level endon( "player_going_far_right" );
	level endon( "player_going_right" );
	flag_wait( "grp3_lights_out" );

	flank_rt_guys1 = getentarray( "steamroom_flank_right_grp1", "targetname" );
	array_thread( flank_rt_guys1, ::spawn_ai );
}

steamroom_enemy_right_grp2()// spawn these guys early but make them wait until the player is close before attacking
{
	flag_wait( "lights_out" );	
	
	right_flankers = getentarray( "steamroom_flank_right_grp2", "targetname" );
	array_thread( right_flankers, ::spawn_ai );
	
	add_wait( ::flag_wait, "player_going_far_right" );
	add_wait( ::flag_wait, "player_going_right" );
	do_wait_any();

	wait 3;
	rt_attack = getent( "flank_rt_attack", "targetname" );
	rt_attack trigger_on();
}


steamroom_enemy_right_grp3()
{
	add_wait( ::flag_wait, "player_going_far_right" );
	add_wait( ::flag_wait, "player_going_right" );
	do_wait_any();

	enemies = get_living_ai_array( "steamroom_seaching_right", "script_noteworthy" );
	waittill_dead_or_dying( enemies );

	right_flankers = getentarray( "steamroom_flank_right_grp3", "targetname" );
	array_thread( right_flankers, ::spawn_ai );
}


/*
steamroom_reinforcements_grp1()// extra bad guys if needed
{
	flag_wait( "spawn_reinforcement_grp1" );
	
	activate_trigger_with_targetname( "spawner_steamroom_reinforcement_guys_grp1" );

	org = getent( "reinforcements_speaker", "targetname" );
	org play_sound_in_space( "afcaves_scl_movein", org.origin );
	
	//Shadow Company 3: "Heh heh…let's show these SAS punks how it's really done."
	org play_sound_in_space( "afcaves_sc3_saspunks", org.origin );
}
*/

steamroom_enemy_flank_left()
{
	self endon( "death" );
	
	battlechatter_off( "axis" );
	self.allowDeath = true;
	self.neverEnableCQB = undefined;
	self cqb_walk( "on" );
	self.dontEverShoot = true;
	self.combatmode = "no_cover";
	
	self allowedstances( "crouch" );
	goal = getnode( self.target, "targetname" );
	self setgoalnode( goal );
	self.ignoreall = true;
	
	add_wait( ::flag_wait, "player_went_left" );
	add_wait( ::flag_wait, "player_went_right" );
	do_wait_any();

	wait 2;
	self allowedstances( "stand", "crouch", "prone" );
	self.goalradius = 350;
	self.ignoreall = false;
	self.favoriteenemy = level.player;
	self setgoalentity( level.player );

	add_wait( ::flag_wait, "steamroom_attack_player" );
	add_wait( ::flag_wait, "player_went_right" );
	do_wait_any();

	self.dontEverShoot = undefined;
	self.combatmode = "cover";
	battlechatter_on( "axis" );
	self thread disable_cqbwalk();
}

steamroom_enemy_flank_right()
{
	self endon( "death" );
	
	battlechatter_off( "axis" );
	self.allowDeath = true;
	self.neverEnableCQB = undefined;
	self cqb_walk( "on" );
	self.dontEverShoot = true;
	self.combatmode = "no_cover";
	
	self allowedstances( "crouch" );
	goal = getnode( self.target, "targetname" );
	self setgoalnode( goal );
	self.ignoreall = true;
	
	add_wait( ::flag_wait, "player_going_far_right" );
	add_wait( ::flag_wait, "player_going_right" );
	add_wait( ::flag_wait, "player_going_left" );
	do_wait_any();

	self allowedstances( "stand", "crouch", "prone" );
	self.goalradius = 350;
	self.ignoreall = false;
	self.favoriteenemy = level.player;
	self setgoalentity( level.player );

	add_wait( ::flag_wait, "steamroom_flank_rt_attack_player" );
	add_wait( ::flag_wait, "player_going_left" );
	do_wait_any();
	
	self.dontEverShoot = undefined;
	self.combatmode = "cover";
	battlechatter_on( "axis" );
	self thread disable_cqbwalk();
}

steamroom_pipe2_destruction()
{
	pipe1 = getent( "steamroom_pipe2_rubble", "targetname" );
	pipe1 hide();
	
	flag_wait( "steamroom_pipe2" );
	
	level.player PlayRumbleOnEntity( "damage_heavy" );

	wait .5;
	pipe2 = getent( "steamroom_pipe2", "targetname" );
	pipe2 hide();
	
	pipe1 show();
}

steamroom_shepherd_blowit()
{	
	level endon( "start_ledge" );
	level endon( "player_leaving_steamroom" );
	
	flag_wait( "steamroom_halfway_point" );
	
	volume = getent( "enemy_in_steamroom", "targetname" );
	enemies = volume get_ai_touching_volume( "axis" );

	waittill_dead_or_dying( enemies, 12 );  

	//Lieutenant: "Sir, I believe MacTavish has infiltrated our base and is making his way through the steam room."
	radio_dialogue( "lnt_infiltratedbase" );

	//Shepherd: "Blow the cave."
	radio_dialogue( "shp_blowthecaves" );
	
	flag_set( "blow_cave" );
	
	//Lieutenant: "Sir, we still have men in there…"
	radio_dialogue( "lnt_meninthere" );

	//Shepherd: "Blow the cave Lieutenant!"
	radio_dialogue( "shp_blowcavelt" );
	
	//Lieutenant: "Yes sir."
	radio_dialogue( "lnt_yessir1" );

	flag_set( "get_out" );
	
	wait 1;
	exploder( "steamroom" );
	
	wait 11;
	volume_steamroom = getent( "player_in_steamroom", "targetname" );
	if ( level.player istouching( volume_steamroom ) )
	{
		playfx( getfx ( "player_death_explosion" ), level.player.origin );
		level.player kill();
		earthquake( 1, 1, level.player.origin, 100 );
	}
}

steamroom_flashbang_enemy()// flash surviving enemy when caves start blowing up
{
	flag_wait( "get_out" );
	
	wait 1.1;
	enemies = getaiarray( "axis" );
	foreach ( guy in enemies ) 
	{
		guy doDamage ( 25, guy.origin );
		guy flashbangstart( 5 );
	}
}

steamroom_blow_it_up()
{
	flag_wait( "player_leaving_steamroom" );
	
	if ( !flag( "blow_cave" ) )
		return;
	
	level notify( "exited_cave" );
	exploder( "steamroom_exit" );
		
	stop_exploder( "steamroom" );
	
	wait 1.5;
	volume_steamroom = getent( "player_in_steamroom", "targetname" );
	if ( level.player istouching( volume_steamroom ) )
	{
		playfx( getfx ( "player_death_explosion" ), level.player.origin );
		level.player kill();
		earthquake( 1, 1, level.player.origin, 100 );
	}
	
	rock_rubble1 = getent( "steamroom_exit_rubble", "targetname" );
	rock_rubble1 solid();
	rock_rubble1 show();
}

steamroom_price_warning()
{
	level endon( "player_leaving_steamroom" );
	flag_wait( "get_out" );
	
	wait .5;
	//Price: "We gotta move Soap, RUN!"
	radio_dialogue( "pri_gottamoverun" );
}

steamroom_fallback()
{
	self endon( "death" );
	
	flag_wait( "steamroom_set_goalvolume" );
	
	volume = getent( "back_half", "targetname" );
	self setgoalpos( self.origin );
	self.goalradius = 350;
	self cqb_walk( "off" );
	self.neverEnableCQB = true;
	self SetGoalVolumeAuto( volume );
}

steamroom_delete_leftover_enemy()
{
	flag_wait( "player_leaving_steamroom" );	
	volume = getent( "steamroom_enemy_killer", "targetname" );
	
	enemies = getaiarray( "axis" );
	foreach ( guy in enemies ) 
	{
		if ( guy istouching( volume ) )
		{
			guy.diequietly = true;
			guy kill();
		}

	}
}
