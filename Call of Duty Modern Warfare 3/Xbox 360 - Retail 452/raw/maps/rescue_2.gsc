#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\rescue_2_code;



//#include maps\jeremy_util;

main()
{
	maps\createart\rescue_2_art::main();
	maps\rescue_2_fx::main();
	maps\rescue_2_anim::main();
	maps\rescue_2_precache::main();
	
	define_loadout( "rescue_2" );
	define_introscreen( "rescue_2" );
	
	level.VISION_UAV = "mine_exterior";
		
	add_start( "elevator_down", ::start_elevator_down, "elevator down", ::elevator_down_setup );
//	add_start( "elevator_opening", ::start_elevator_opening, "elevator opening", ::elevator_opening_setup );
	add_start( "zip_line_cave", ::start_zip_line_cave, "zip line cave", ::zip_line_cave_setup );
	add_start( "enter_bay", ::start_enter_bay, "enter bay", ::enter_bay_setup );
//	add_start( "exit_bay", ::start_exit_bay, "exit bay", ::exit_bay_setup );
	add_start( "exit_bay_doors_reveal", ::start_exit_bay_doors_reveal, "exit bay   reveal", ::exit_bay_doors_reveal_setup );
//	add_start( "outside_of_cave", ::start_outside_of_cave, "outside of cave", ::outside_of_cave_setup );
//	add_start( "outside_of_cave_truck", ::start_outside_of_cave_truck, "outside of cave truck", ::outside_of_cave_truck_setup );
//	add_start( "outside_of_cave_tunnel", ::start_outside_of_cave_tunnel, "outside of cave tunnel", ::outside_of_cave_tunnel_setup );
	add_start( "yard_one", ::start_yard_one, "yard one", ::yard_one_setup );
	add_start( "yard_two", ::start_yard_two, "yard two", ::yard_two_setup );
	add_start( "cavern_start", maps\rescue_2_cavern_script::start_cavern, "Cavern start", maps\rescue_2_cavern_code::cavern_setup );
	add_start( "cavern_breach", maps\rescue_2_cavern_script::cavern_breach, "Cavern breach", maps\rescue_2_cavern_code::cavern_breach_setup );
	add_start( "cavern_top_fight", maps\rescue_2_cavern_script::cavern_top_fight, "Cavern top fight", maps\rescue_2_cavern_code::cavern_top_fight_setup );
	add_start( "cavern_top_rappel", maps\rescue_2_cavern_script::cavern_top_rappel, "Cavern rappel", maps\rescue_2_cavern_code::cavern_top_rappel_setup );
	add_start( "cavern_bottom_fight", maps\rescue_2_cavern_script::cavern_bottom_fight_one, "Cavern", maps\rescue_2_cavern_code::cavern_bottom_fight_one_setup );
	add_start( "cavern_bottom_breach", maps\rescue_2_cavern_script::cavern_bottom_breach, "Cavern", maps\rescue_2_cavern_code::cavern_bottom_breach_setup );
	add_start( "cavern_bottom_pres_defend", maps\rescue_2_cavern_script::cavern_bottom_pres_defend, "Cavern", maps\rescue_2_cavern_code::cavern_bottom_pres_defend_setup );
	add_start( "cavern_bottom_pres_heli", maps\rescue_2_cavern_script::cavern_bottom_pres_heli, "Cavern", maps\rescue_2_cavern_code::cavern_bottom_pres_heli_setup );
	add_start( "cavern_heli_fly_out", maps\rescue_2_cavern_script::cavern_heli_fly_out, "Cavern", maps\rescue_2_cavern_code::cavern_heli_fly_out_setup );

	add_hint_string( "hint_predator_shoot", &"RESCUE_2_HINT_SHOOT_PREDATOR", ::should_break_predator_shoot_hint );	
	add_hint_string( "nvg", &"SCRIPT_NIGHTVISION_USE", maps\_nightvision::ShouldBreakNVGHintPrint );
	add_hint_string( "disable_nvg", &"SCRIPT_NIGHTVISION_STOP_USE", maps\_nightvision::should_break_disable_nvg_print );
	PreCacheString( &"SCRIPT_NIGHTVISION_USE" );
	PreCacheString( &"SCRIPT_NIGHTVISION_STOP_USE" );
	PreCacheString( &"RESCUE_2_HINT_SHOOT_PREDATOR" );
	
	precacheModel( "weapon_saw_rescue" );
	precacheModel( "coop_bridge_rappelrope" );
	PreCacheItem( "remote_missile_invasion" );
	PreCacheItem( "claymore" );
	PreCacheItem( "rpd" );
	PreCacheItem( "littlebird_FFAR" );
	PreCacheItem( "rpg" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "remote_missile_snow" );
	PreCacheItem( "remote_missile_not_player_snow" );
	PreCacheItem( "remote_missile_not_player_snow_cluster" );
	PrecacheItem( "g36c_reflex" );
	PreCacheShader( "veh_hud_friendly" );
	precacheshellshock( "rescue_2_ele_crash" );
	
	level.uav_missile_override = "remote_missile_snow";
	
	// These are overrides so the missle shoots in front of the player.
	level.uav_missle_start_forward_distance = -800.0;
	level.uav_missle_start_right_distance = 0.0;
	
//	MagicBullet( "mp5", struct2.origin, struct5_target.origin );
	
//	maps\_remotemortar_sp::main();
	maps\_load::main();
	
	thread maps\rescue_2_amb::main();
	
	maps\_remotemissile::init();
	maps\_predator2::main();
	maps\_stinger::init();
	maps\_nightvision::main( level.players );
	common_scripts\_pipes::main();	
	
	maps\_drone_ai::init();
	maps\rescue_2_cavern_script::main();
		
	level.vttype = "suburban_minigun"; // borrowed from boneyard so we can have suburban's with mini guns
	level.vtmodel = "vehicle_suburban_technical";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_aianims( maps\rescue_2_anim::suburban_minigun_overrides, vehicle_scripts\_suburban_minigun::set_vehicle_anims );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", "TAG_CAB_FIRE", "fire_metal_medium", undefined, undefined, true, 0 );
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", undefined, "car_explode" );
	level.vttype = "suburban";
	level.vtmodel = "vehicle_suburban";
	typemodel = level.vttype + level.vtmodel;
	level.vehicle_death_fx[ typemodel ] = [];
	maps\_vehicle::build_aianims( maps\rescue_2_anim::suburban_overrides, vehicle_scripts\_suburban::set_vehicle_anims );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm", "TAG_CAB_FIRE", "fire_metal_medium", undefined, undefined, true, 0 );
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion", undefined, "car_explode" );
	
	init_level_flags();
	
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
	
	
	cur_vision_set = GetDvar( "vision_set_current" ); 
    set_vision_set( cur_vision_set, 0 );

	createthreatbiasgroup( "yard_one_top_guys" );
	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "allies_center" );
	createthreatbiasgroup( "delta" );
	
	level.remote_missile_invasion = true;	
	level.player_killed_ai_count = 0;
	level.counter = 0; // global counter used for tracking when needed.
	array_spawn_function_targetname( "cave_ambush", ::cave_ambush_think );
	array_spawn_function_targetname( "cave_ambush_support", ::cave_ambush_support_think );
	array_spawn_function_targetname( "cave_rappel_ground", ::cave_rappel_ground_think );
	array_spawn_function_targetname( "cave_rappel", ::cave_rappel_think );
	//array_spawn_function_targetname( "cave_rappel", ::cave_rappel_think );
	array_spawn_function_noteworthy( "cave_run_to_bay", ::bay_runner_think );
	array_spawn_function_targetname( "bay_runner", ::bay_runner_think_two );
//	array_spawn_function_targetname( "bay_runner_stay", ::bay_runner_think_two );
	array_spawn_function_targetname( "bay_runner_garage", ::bay_runner_garage_think );
	array_spawn_function_targetname( "bay_garage_support", ::bay_garage_support_think );
	array_spawn_function_noteworthy( "bay_top_outside_two", ::bay_top_outside_two_think );
	array_spawn_function_targetname( "road_fighters", ::road_fighters_think );
	array_spawn_function_targetname( "road_fighters", ::kill_ai );
	
	array_spawn_function_targetname( "suburban_road_one_path_one", ::sub_delete );
	array_spawn_function_targetname( "suburban_road_one_path_two", ::sub_delete );
	array_spawn_function_targetname( "suburban_road_one_path_three", ::sub_delete );
	
	
	
	
//	array_spawn_function_noteworthy( "yard_sniper_one", ::yard_sniper_think );
//	array_spawn_function_noteworthy( "yard_sniper_two", ::yard_sniper_think );
	array_spawn_function_targetname( "cave_rappel_rpg", ::cave_rappel_rpg_think );
	array_spawn_function_targetname( "yard_com_support", ::yard_com_support_think );
	
	array_spawn_function_noteworthy( "delta_yard_left", ::setup_orange1_left );
	array_spawn_function_noteworthy( "delta_yard_right", ::setup_red1_right );
	array_spawn_function_targetname( "suburban_road_one_path_three", ::sub_delete );
	array_spawn_function_targetname( "cave_lead_player_eye_top", ::cave_lead_player_eye_top_think );
	array_spawn_function_targetname( "elevator_passive_guys", ::elevator_passive_guys_think );
	
	array_spawn_function_targetname( "yard_second_flood", ::yard_second_flood_think );
	
	
	//array_spawn_function_targetname( "delta_yard_left", ::delta_yard_left_think );
	//array_spawn_function_targetname( "delta_yard_right", ::delta_yard_right_think );
	
//	array_spawn_function_noteworthy( "yard_high_road_support", ::yard_high_road_support_think );
	array_spawn_function_noteworthy( "second_yard_runners", ::second_yard_runners_think );
	
	array_spawn_function_noteworthy( "heli_engage_suburb_guys", ::sniper_track );
	
	array_spawn_function_targetname( "elevator_rocket_guys", ::elevator_rocket_guys_think );
	
	
	
	// don't add this tell the player kills three targets
	add_global_spawn_function( "axis", :: setup_remote_missile_target_guy ); // places red boxed for predator mode.
//	add_global_spawn_function( "allies", :: setup_remote_missile_target_guy ); // places red boxed for predator mode.
	
	level.snow_effect = getfx( "snow_light" );
	level.snow_delay = 0.75;
	level.snow_offset = ( 0, 0, 350 );
	
	thread objectives();
	thread loud_speakers();
	thread cave_dust();
	thread start_uav();
	
	thread nightvision_setup();
	
	fire_missile_setup();
	
	SetSavedDvar( "sm_sunShadowScale", 0.6 );

}

player_loadout()
{
//	level.player giveweapon( "scar_h_acog" );
//	level.player giveweapon();
//	level.player giveweapon();
}

// you have four guys two heros and two delta going down the elevator.

init_level_flags()
{
	flag_init( "elevator_one_done_moving" );
	flag_init( "elevator_one_attack_now" );
	flag_init( "elevator_one_done_moving_new_beggining" );
	flag_init( "elevator_one_ambush" );
	flag_init( "start_ambush" );
	flag_init( "ai_use_orange_cnodes" );
	flag_init( "ai_use_red_cnodes" );
	flag_init( "fire_at_elevator" );
	flag_init( "start_bay_runners" );
	flag_init( "start_bay_combat" );
	flag_init( "get_ai_flow_clear" );
	flag_init( "saw_door" );
	flag_init( "saw_door_open" );
	flag_init( "shut_large_bay_doors" );
	flag_init( "cave_runner_close_door" );
	flag_init( "start_bay_sequence" );
	flag_init( "start_yard_one" );
	flag_init( "yard_activate_orange_nodes" );
	flag_init( "activate_second_yard_flood" );
	flag_init( "player_has_predator_drones" );
	flag_init( "open_bay_double_doors" );
	flag_init( "now_spawn_rappel" );
	flag_init( "now_spawn_rappel_two" );
	flag_init( "activate_end_courtyard" );
	flag_init( "courtyard_cleared" );
	flag_init( "middle_yard_color_red" );
	flag_init( "sparks_elevator_one" );
	flag_init( "reset_angles" );
	flag_init( "spawn_middle_yard" );
	flag_init( "middle_yard_blockers" );
	flag_init( "yard_start_heli_drop" );
	flag_init( "hard_targets_dead");
	flag_init( "top_side_god_off" );
	flag_init( "blow_up_the_door" ); 
	flag_init( "kill_first_tunnel_guys" ); 
	flag_init( "stop_ele_sparks" ); 
	flag_init( "yard_retreat_one_new" ); 
	flag_init( "yard_start_strafes" );
	flag_init( "turn_off_nvg" );
	flag_init( "spawn_in_last_subs" );
	flag_init( "flow_flag_player_ahead_spawn_enemies" );
	flag_init( "uav_in_use" );
}

start_elevator_down() // Ai ambush player at elevator
{
//	start_elevator
//	after_fight_one
//	
//	start_zipline_cave_below
//	start_zipline_cave_above
//	start_after_zipline_cave
//	
//	start_garage
//	start_inside_garage
//	start_large_garage_doors
//	
//	start_reveal_one
//	start_after_reveal_one
//	
//	
//	start_courtyard_one
//	start_middle_courtyard_one
//	start_end_courtyard_one
//	
//	
//	start_courtyard_two
//	start_middle_courrtyard_two
//	start_end_courrtyard_two

	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	spawn_delta_one();
	spawn_delta_two();
	
	set_start_positions( "start_elevator_moving" );
	
	thread battle_one_in_cave();
}


start_elevator_opening() // Ai ambush player at elevator
{
	flag_set( "elevator_one_done_moving" );
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	
	set_start_positions_two( "start_elevator" );
	
	thread battle_one_in_cave();
}


// make the last troops run away to the next location..
// setup zip line guys from above
Start_zip_line_cave() // Ai drop down from elevated positions using zip lines
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	waitframe();
	
//	set_start_positions( "start_zipline_cave_below" );
	set_start_positions_two( "start_zipline_cave_above" );
}


// setup counter with objects on it..
// see vehicles leaving the doors as they are being shut down
start_enter_bay() // fight through the glass as ai takes cover around the snow cats
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	
	level.small_bay_door_safety_clip = getent( "small_bay_door_safety_clip", "targetname" );
	level.small_bay_door_safety_clip delete();
	set_start_positions_two( "start_garage" );
	flag_set( "start_bay_sequence" );
	
	level.small_bay_door = getent( "bay_small_door", "targetname" );
	level.bay_small_door_break = getent( "bay_small_door_breawk", "targetname" );
 	level.bay_small_door_break linkto ( level.small_bay_door );
 	
 	burn_background = getent( "burn_background", "targetname" );
	// Hide burn decals
	burns = getentarray( "burns", "script_noteworthy" );
	foreach( decal in burns )
	{
		decal linkto ( level.small_bay_door );
		//decal linkto ( level.small_bay_door, "", (0, 0, -50), (0, 0, 0) );
		//decal moveto( level.small_bay_door.origin +( -1, 30,0 ), 0.1 );
		decal hide();
	}
	burn_background linkto ( level.small_bay_door );
	burn_background hide();
}


start_inside_bay() // fight through the glass as ai takes cover around the snow cats
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_inside_garage" );
}


// Let the player walk down the long tunnel cause it's cool
// 
start_exit_bay() // fight through the glass as ai takes cover around the snow cats
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_large_garage_doors" );
}

// setup air battle. Can the battle escalate as you go through
// the player encounters a small group of guys
//
start_exit_bay_doors_reveal() // The doors slowly open to reveal an star wars like battel. Steal Holmes jet crashing into doors moment.
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	flag_set( "open_bay_double_doors" );
	set_start_positions_two( "start_reveal_one" );
}

start_outside_of_cave() // 
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_after_reveal_one" );
}

start_outside_of_cave_truck() // 
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_outside_of_cave_truck" );
}

start_outside_of_cave_tunnel() // 
{
	flag_set( "ai_use_red_cnodes");
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_outside_of_cave_tunnel" );
}

start_yard_one()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	flag_set( "ai_use_red_cnodes");
	flag_set( "yard_activate_orange_nodes" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "open_bay_double_doors" );
		//	start_courtyard_one
		//	start_middle_courtyard_one
		//	start_end_courtyard_one
//	set_start_positions( "start_reveal_one" );
	set_start_positions_two( "start_courtyard_one" );
	wait( 2 );
	level.sandman disable_cqbwalk();
	level.truck disable_cqbwalk();
	level.grinch disable_cqbwalk();
	level.price disable_cqbwalk();

}

start_yard_two()
{
	level.new_cave_door_collision = get_target_ent( "new_cave_door_collision" );
	level.new_cave_door_collision disconnectpaths();
	
	// flag_set( "blow_up_the_door" );
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	flag_set( "ai_use_red_cnodes");
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "open_bay_double_doors" );
	flag_set( "middle_yard_color_red" );
	ai_ally = getaiarray( "allies" ); // sets everyone to red for the end.
	foreach( ai in ai_ally )
	{
		ai set_force_color( "r" );
	}
//	set_start_positions( "start_courtyard_two" );
	level.power_trigger_damage = getent( "yard_blow_power_tower",  "targetname" );
	set_start_positions_two( "start_end_courtyard_one" );
	
	flag_set( "activate_end_courtyard" );
	
	ent = getent( "last_hind_path", "targetname" );
	waitframe();
	heli_spawner = getent( "hind_off_spawner", "targetname" );
	level.hind_three = heli_spawner move_spawn_and_go( ent );
	
	//give_player_predator_reaper

	wait( 3 );
	level.power_trigger_damage trigger_on();
	thread give_player_predator_drone();
	//thread give_player_predator_reaper();
	
	//thread in_bound_missle_strike();
	
	level.sandman disable_cqbwalk(); 
	level.price disable_cqbwalk();
	level.truck disable_cqbwalk();
	level.grinch disable_cqbwalk();
	
	level.truck set_force_color ("r");
	level.grinch set_force_color ("r");
	
	hind_fake = spawn_vehicle_from_targetname( "hind_three_fake_box" );
	hind_fake hide();
	hind_fake thread hind_fake_damage();
	hind_fake thread maps\_remotemissile_utility::setup_remote_missile_target();
	
	
	level.hind_three waittill ( "reached_dynamic_path_end" );
	level.hind_three thread maps\_remotemissile_utility::setup_remote_missile_target();
//	level.hind_two thread hind_attack_player_end();
	level.hind_three thread hind_two_random_shoot();	
	level.hind_three.target_ent = level.player;
	//level.hind_two = spawn_vehicle_from_targetname( "heli_one" );
	level.hind_three thread hind_attack_player_end();
	level.hind_three thread hind_two_random_shoot();
	level.hind_three.target_ent = level.player;
	
	
//	level.hind_two.target_ent = level.player;
//	while( 1 )
//	{
//		level.hind_two.target_ent = level.player;
//		num = RandomIntRange( 0, 3 ); 
//		switch ( num )
//		{
//				case 0:
//					level.hind_two.target_ent = level.player.origin + ( 300, 300, 150 );
//				case 1:
//					level.hind_two.target_ent = level.player.origin + ( -300, -300, 150 );
//				case 2:
//					level.hind_two.target_ent = level.player.origin + ( 0, 100, -100 );
//				case 3:
//					level.hind_two.target_ent = level.player.origin + ( 0, 0, 0 );
//		}	
//		wait( 1 );
//	}
}


