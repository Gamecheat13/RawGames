#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\dubai_code;
#include maps\dubai_utils;
#include maps\dubai_vo;
#include maps\_shg_common;
#include maps\_audio;

main()
{
	mode = getdvar( "ui_play_credits" );
	if (isdefined(mode) && (mode != ""))
	{
		SetSavedDvar( "ui_hidemap", 1 );	// ensure no map if entered level in XMB, since it would pause early
		level.credits_active = true;
	}
	template_level( "dubai" );
	//---- precache ----//
	precacheShader("black");
	
	init_level_flags();
	
	level.secondaryweapon = "m4m203_acog";
	
	setup_start_points();
	
	precache_main();
	
	//---- loads ----/
	maps\createart\dubai_art::main();
	maps\dubai_fx::main();
	maps\dubai_aud::main();
	maps\dubai_anim::main_anim();
	maps\dubai_precache::main();
	maps\_load::main();
	maps\_drone_civilian::init();
	maps\_drone_ai::init();
	if (isdefined(mode) && (mode != ""))
		maps\dubai_finale::finale_player_setup();	// hide hud and weapons

	prepare_dialogue();
	thread play_dialogue();

	level thread handle_objectives();

	thread setup_level_scripting();

	thread finale_credit_setup();
}

init_level_flags()
{
	flag_init( "objective_kill_makarov" );
	flag_init( "objective_complete_kill_makarov" );
	flag_init( "update_obj_pos_exterior_on_yuri" );
	flag_init( "update_obj_pos_in_elevator" );
	flag_init( "update_obj_pos_elevator_jump" );
	flag_init( "update_obj_pos_elevator_jump_complete" );
	flag_init( "update_obj_pos_top_floor_atrium_landing" );
	flag_init( "update_obj_pos_restaurant_makarov_spotted" );
	flag_init( "update_obj_pos_restaurant_makarov_escaped" );
	flag_init( "update_obj_pos_restaurant_destruction" );
	flag_init( "update_obj_pos_finale_chopper" );
	flag_init( "update_obj_pos_finale_no_marker" );
	
	flag_init( "intro_truck_left" );
	flag_init( "intro_complete" );
	
	flag_init( "exterior_initial_enemies" );
	flag_init( "exterior_civilians_initial" );
	flag_init( "exterior_juggernaut_paired_start" );
	flag_init( "exterior_juggernaut_paired_complete" );
	flag_init( "exterior_suv_scene" );
	flag_init( "exterior_rpg_enemies_in_position" );
	
	flag_init( "remove_exterior_rpg_enemies" );
	
	flag_init( "player_dynamic_move_speed" );
	flag_init( "remove_player_juggernaut" );
	flag_init( "remove_yuri_juggernaut" );
	flag_init( "yuri_no_juggernaut_spawned" );
	
	flag_init( "lobby_combat_top_riotshield_enemies" );
	flag_init( "lobby_yuri_to_elevator" );
	
	flag_init( "yuri_in_elevator" );
	flag_init( "elevator_button_pressed" );
	flag_init( "elevator_doors_closed" );
	flag_init( "elevator_chopper_preattack" );
	flag_init( "elevator_attack_chopper_kill" );
	flag_init( "elevator_chopper_min_time_passed" );
	flag_init( "elevator_chopper_near_crash" );
	flag_init( "elevator_chopper_killed" );
	flag_init( "elevator_chopper_crash_done" );
	flag_init( "elevator_remove_gear_2" );
	flag_init( "elevator_remove_gear_3" );
	flag_init( "elevator_initial_short_drop" );
	flag_init( "elevator_initial_big_drop" );
	flag_init( "elevator_initial_big_drop_done" );
	flag_init( "elevator_yuri_jump" );
	flag_init( "replacement_elevator_in_position" );
	flag_init( "player_jumped_to_replacement_elevator" );
	flag_init( "player_finished_jump_to_replacement_elevator" );
	flag_init( "elevator_player_missed_jump" );
	flag_init( "drop_player_elevator" );
	flag_init( "elevator_replacement_moving_to_top" );
	
	flag_init( "player_at_top_floor" );
	flag_init( "top_floor_countdown_start" );
	flag_init( "top_floor_yuri_grenade_start" );
	flag_init( "top_floor_yuri_grenade_thrown" );
	flag_init( "top_floor_lounge_combat_3" );
	flag_init( "top_floor_lounge_clear" );
	
	flag_init( "chopper_restaurant_intro" );
	flag_init( "restaurant_chopper_initial_loop" );
	flag_init( "restaurant_chopper_move_up" );
	flag_init( "chopper_restaurant_outro" );
	flag_init( "restaurant_makarov_spotted" );
	flag_init( "restaurant_destruction" );
	flag_init( "restaurant_destruction_floor_done" );
	flag_init( "restaurant_destruction_player_over_ledge" );
	flag_init( "restaurant_destruction_rolling_soldier" );
	flag_init( "restaurant_drop_section_falling" );
	flag_init( "restaurant_destroyed" );
	flag_init( "restaurant_tilt" );
	flag_init( "restaurant_rubble_fall_on_yuri" );
	flag_init( "yuri_restaurant_dialogue_done" );
	flag_init( "restaurant_sequence_complete" );
	flag_init( "top_floor_corpses" );
	
	flag_init( "finale_player_jump_start" );
	flag_init( "finale_player_jump_successful" );
	flag_init( "finale_too_late_to_jump" );
	flag_init("finale_chopper_takeoff_finished");
	flag_init("finale_player_jump_finished");
	flag_init( "finale_chopper_crash_complete" );
	flag_init( "finale_crawl_lookup" );
	flag_init( "finale_fall" );
	flag_init( "finale_fall_complete" );
	flag_init( "finale_lobby" );
	flag_init( "player_started_draw" );
	flag_init( "start_finale_showdown" );
	flag_init( "end_finale_showdown" );
	flag_init( "beatdown_failure" );
	flag_init( "beatdown_start_success" );
	flag_init( "beatdown_tackle_start" );
	flag_init( "end_of_credits" );
	flag_init( "fadeout_at_end_done");
	
	flag_init( "player_falling_kill_in_progress" );
	
	flag_init("level_end");

	flag_init( "model_spot_lighting_enabled" );
	flag_init( "model_spot_lighting_disabled" );
	
	setdvar( "makarov_escaping_time_left", "4" );
	
	//VO flags
	flag_init( "vo_intro_on_black" );
	flag_init( "vo_intro_start" );
	flag_init( "vo_intro_get_ready" );
	flag_init( "vo_streets_start" );
	flag_init( "vo_lobby_start" );
	flag_init( "vo_lobby_near_elevator" );
	flag_init( "vo_elevator_start" );
	flag_init( "vo_elevator_player_falling" );
	flag_init( "vo_elevator_near_top" );
	flag_init( "vo_top_floor_start" );
	flag_init( "vo_restaurant_start" );
	flag_init( "vo_restaurant_destruction_yuri" );
	flag_init( "vo_stairwell_start" );
	flag_init( "vo_finale_roof_start" );
	flag_init( "vo_finale_lobby_start" );
	flag_init( "vo_finale_lobby_final" );
	
	//PiP flags
	flag_init( "pip_atrium_start" );
	flag_init( "pip_atrium_end" );
	flag_init( "pip_lounge_start" );
	flag_init( "pip_lounge_end" );
	flag_init( "pip_restaurant_start" );	
	flag_init( "pip_restaurant_end" );
	
	flag_init( "pip_elevator_chopper_start" );
	flag_init( "pip_elevator_chopper_end" );
}

setup_start_points()
{
		//---- start points ----//
	add_start( "intro", ::start_intro );
	add_start( "exterior", ::start_exterior );
	add_start( "exterior_circle", ::start_exterior_circle );
	add_start( "lobby", ::start_lobby );
	add_start( "elevator", ::start_elevator );
	add_start( "top_floor", ::start_top_floor );
	add_start( "restaurant_entrance", ::start_restaurant_entrance );
	add_start( "restaurant_destruction", ::start_restaurant_destruction );
	add_start( "restaurant_exit", ::start_restaurant_exit );
	add_start( "finale_chopper_sequence", ::start_finale_chopper_sequence );
	add_start( "finale_crash_site", ::start_finale_crash_site );
	add_start( "finale_beatdown", ::start_finale_beatdown );
	add_start( "finale_ending", ::start_finale_ending );
	
	/#
	add_start( "dev_elevator_anim_test", ::start_dev_elevator_anim_test, undefined, ::dev_elevator_anim_test_setup );
	add_start( "dev_capture_reflection", ::start_dev_capture_reflection );
	add_start( "dev_credits", ::start_dev_credits );
	add_start( "dev_credits_black", ::start_dev_credits_black );
	#/
}

precache_main()
{
	//slow view
	PreCacheShellshock( "slowview" );
	
	//rumbles
	PreCacheRumble( "damage_light" );
	PreCacheRumble( "damage_heavy" );
	PreCacheRumble( "subtle_tank_rumble" );
	PreCacheRumble( "steady_rumble" );
	PreCacheRumble( "falling_land" );
	PreCacheRumble( "viewmodel_small" );	// these are usually in the weapon, but let's be safe
	PreCacheRumble( "viewmodel_medium" );
	PreCacheRumble( "viewmodel_large" );
	
	//juggernaut intro
	PreCacheShader( "juggernaut_overlay_half" );	
	PreCacheShader( "juggernaut_damaged_overlay" );
	//PreCacheModel( "body_complete_sp_juggernaut" );
	PrecacheModel( "viewhands_pmc" );
	PreCacheItem( "mk46" );
	//PreCacheItem( "ak47_acog" );
	PreCacheItem( "usp" );
	PreCacheModel( "viewmodel_pecheneg_sp_iw5" );
	PrecacheModel( "dub_juggernaut_helmet" );
	
	PrecacheModel( "body_juggernaut_nohelmet" );
	PrecacheModel( "body_juggernaut_quartergear" );
	PrecacheModel( "body_juggernaut_nogear" );
	
	//elevator
	precachemodel( "dub_bldg_elevator_des" );
	PrecacheModel( "dub_juggernaut_chestarmor" );
	PrecacheModel( "dub_juggernaut_helmet" );
	
	//chopper spotlights
	PrecacheTurret( "heli_spotlight" );
	PrecacheModel( "com_blackhawk_spotlight_on_mg_setup" );
	
	//chopper weapon
	PreCacheItem( "littlebird_FFAR" );
	PreCacheItem( "zippy_rockets" );
	
	precacherumble( "tank_rumble" );
	
	//PiP
	PreCacheShader( "overlay_static" );	
	precacheshader( "cinematic" );
	
	//Restaurant
	PrecacheModel( "dub_restaurant_column_shatter_02" );
	PrecacheModel( "dub_restaurant_roundtable_set_sim" );
	PrecacheModel( "dub_restaurant_squaretable_set_sim" );
	PrecacheModel( "fx_char_light_rig" );
	
	//finale hands
	PrecacheItem( "freerunner" );
	
	// finale
	PreCacheItem( "nosound_magicbullet" );
	PreCacheShellShock( "dubai_ending_wakeup" );
	PreCacheShellShock( "dubai_ending_wounded" );
	PreCacheShellShock( "dubai_ending_no_control" );
	PreCacheShellShock( "dubai_ending_pulling_knife_later" );
	PreCacheShellShock( "dubai_injured_passout" );
	PreCacheShellShock( "dubai_ending_crash_site" );
	PrecacheModel( "head_price_africa" );	// used for reflection
	PrecacheModel( "dub_finale_skylight_shards" );
	PrecacheModel( "head_tank_a_pilot" );
	PrecacheModel( "head_henchmen_c" );
	PrecacheModel( "dub_roof_top_sky_light_broken" );
	PrecacheModel( "viewmodel_desert_eagle_sp_dubai_finale" );
	PrecacheModel( "body_fso_suit_a" ); //mysterious stranger
	PrecacheModel( "head_fso_d" ); //mysterious head

	PrecacheMenu( "nopause" );	
	PrecacheMenu( "allowpause" );	
	PreCacheShader("victory_iw5");
	PreCacheShader("victory_menu");
	precachestring(&"MENU_SP_CONTINUE_TO_SPECIAL_OPS");
	// debugging
	PreCacheModel( "axis" );
}

handle_objectives()
{
	waittillframeend;

	set_completed_objective_flags();

	thread minimap_update( 1 );

	//GIVE: Kill Makarov
	flag_wait( "objective_kill_makarov" );
	
	Objective_Add( 1, "current", &"DUBAI_OBJ_KILL_MAKAROV" );
	
	flag_wait( "update_obj_pos_exterior_on_yuri" );
	
	if( isdefined( level.yuri ) )
	{
		Objective_OnEntity( 1, level.yuri );
		
		//Objective_SetPointerTextOverride( 1, &"DUBAI_JUMP" );
	}
	
	//Objective_Position(1, obj_pos.origin);
	
	flag_wait( "update_obj_pos_lobby_upper_floor" );
	obj_pos = getent( "obj_pos_lobby_upper_floor", "targetname" );
	Objective_Position(1, obj_pos.origin);
	
	flag_wait( "update_obj_pos_lobby_elevator" );
	obj_pos = getent( "obj_pos_lobby_elevator", "targetname" );
	Objective_Position(1, obj_pos.origin);
	
	flag_wait( "update_obj_pos_in_elevator" );
	Objective_Position(1, (0, 0, 0) );

	flag_wait( "update_obj_pos_elevator_jump" );	
	if( isdefined( level.yuri ) )
	{
		//Objective_OnEntity( 1, level.replacement_elevator.e[ "housing" ][ "mainframe" ][ 0 ], (0, -80, 0) );
		
		Objective_Position(1, (-640, -64, level.yuri.origin[2] ) );
		
		Objective_SetPointerTextOverride( 1, &"DUBAI_JUMP" );
	}
	flag_wait( "update_obj_pos_elevator_jump_complete" );
	Objective_Position(1, (0, 0, 0) );
	Objective_SetPointerTextOverride( 1, "" );
	
	flag_wait( "update_obj_pos_top_floor_atrium_landing" );
	obj_pos = getent( "obj_pos_top_floor_atrium_landing", "targetname" );
	Objective_Position(1, obj_pos.origin);
	thread minimap_update( 2 );
	
	flag_wait( "update_obj_pos_top_floor_lounge" );
	obj_pos = getent( "obj_pos_top_floor_lounge", "targetname" );
	Objective_Position(1, obj_pos.origin);
	
	flag_wait( "update_obj_pos_restaurant_entrance" );
	obj_pos = getent( "obj_pos_restaurant_entrance", "targetname" );
	Objective_Position(1, obj_pos.origin);
	
	flag_wait( "update_obj_pos_restaurant_makarov_spotted" );
	if( isdefined( level.makarov ) )
	{
		Objective_OnEntity( 1, level.makarov, (0, 0, 64));
		Objective_SetPointerTextOverride( 1, &"DUBAI_KILL" );
	}
	
	flag_wait( "update_obj_pos_restaurant_makarov_escaped" );
//	obj_pos = getent( "obj_pos_restaurant_makarov_escaped", "targetname" );
//	Objective_Position(1, obj_pos.origin);
	Objective_Position(1, (0, 0, 0) );
	Objective_SetPointerTextOverride( 1, "" );
	
	flag_wait( "update_obj_pos_restaurant_destruction" );
	Objective_Position(1, (0, 0, 0) );
	
	flag_wait( "update_obj_pos_restaurant_exit" );
	obj_pos = getent( "obj_pos_restaurant_exit", "targetname" );
	Objective_Position(1, obj_pos.origin);
	
	thread minimap_update( 3 );
	
	flag_wait( "update_obj_pos_stairwell" );
	obj_pos = getent( "obj_pos_stairwell", "targetname" );
	Objective_Position(1, obj_pos.origin);
	
	flag_wait( "update_obj_pos_roof" );
	obj_pos = getent( "obj_pos_roof", "targetname" );
	Objective_Position(1, obj_pos.origin);
	
	flag_wait( "update_obj_pos_finale_chopper" );
	
	ent = undefined;
	if( isdefined( level.finale_chopper ) )
	{
		ent = spawn_tag_origin();
		ent.origin = level.finale_chopper GetTagOrigin("tag_guy1");
		ent linkto( level.finale_chopper, "tag_guy1" );
		Objective_OnEntity( 1, ent );
		Objective_SetPointerTextOverride( 1, &"DUBAI_JUMP" );
	}
	
	flag_wait( "update_obj_pos_finale_no_marker" );
	Objective_Position(1, (0, 0, 0) );
	if (isdefined(ent))
		ent Delete();
	
	flag_wait( "objective_complete_kill_makarov" );
	objective_complete( 1 );
	//obj_pos_entity = getent( "objective_position_kill_makarov", "targetname" );
	//Objective_Add( 1, "current", "Kill Makarov");
	//Objective_Position(1, obj_pos_entity.origin);
	
}

set_completed_objective_flags()
{
//	if( !isdefined(level.start_point))
//		return;
	
	if ( is_default_start() )
		return;

	start = level.start_point;
	flag_set( "objective_kill_makarov" );
	
	flag_set( "update_obj_pos_exterior_on_yuri" );
	
	if(start == "exterior")
		return;
	
	if(start == "exterior_circle")
		return;
	
	flag_set( "update_obj_pos_lobby_upper_floor" );
	
	if(start == "lobby")
		return;
	
	flag_set( "update_obj_pos_lobby_elevator" );
	
	if( start == "elevator" )
		return;
	
	/#
	if( start == "dev_elevator_anim_test" )
		return;
	#/
	
	flag_set( "update_obj_pos_in_elevator" );
	flag_set( "update_obj_pos_elevator_jump" );
	flag_set( "update_obj_pos_elevator_jump_complete" );
	flag_set( "update_obj_pos_top_floor_atrium_landing" );
	level.player SetViewmodel( "viewhands_pmc" );
	
	if(start == "top_floor")
		return;
	
	flag_set( "update_obj_pos_top_floor_lounge" );
	flag_set( "update_obj_pos_restaurant_entrance" );
	
	flag_clear( "model_spot_lighting_disabled" );
	flag_set( "model_spot_lighting_enabled" );
	
	if(start == "restaurant_entrance")
		return;
	
	flag_set( "update_obj_pos_restaurant_makarov_spotted" );
	flag_set( "update_obj_pos_restaurant_makarov_escaped" );

	if( start == "restaurant_destruction" )
		return;
		
	flag_set( "update_obj_pos_restaurant_destruction" );
	flag_set( "update_obj_pos_restaurant_exit" );
	
	if(start == "restaurant_exit")
		return;
	
	flag_set( "update_obj_pos_stairwell" );
	flag_set( "update_obj_pos_roof" );
	
	flag_clear( "model_spot_lighting_enabled" );
	flag_set( "model_spot_lighting_disabled" );
	
	if(start == "finale_chopper_sequence")
		return;

	flag_set( "update_obj_pos_finale_chopper" );
	flag_set( "update_obj_pos_finale_no_marker" );
	
	if(start == "finale_crash_site")
		return;
		
	if(start == "finale_beatdown")
		return;
		
	if(start == "finale_ending")
		return;
		
	/#
	if( start == "dev_capture_reflection" )
		return;
	if( start == "dev_credits" )
		return;
	if( start == "dev_credits_black" )
		return;
	#/
	
	AssertMsg( "Start point " + start + " isn't supported" );
}

start_intro()
{
	mode = getdvar( "ui_play_credits" );
	if (isdefined(mode) && (mode != ""))
	{
		maps\dubai_finale::finale_player_setup();	// hide hud and weapons
		aud_send_msg("play_credits_music");
		SetSavedDvar( "compass", 0 );
		start_credits();
		return;
	}
	aud_send_msg("start_intro");
	
	setup_friends();
	
	thread intro();
	
	/#
	setDevDvar( "dev_elevator_anim_test", "0" );
	#/
}

start_exterior()
{
	aud_send_msg("start_exterior");
	
	move_player_to_start("player_start_exterior");
	setup_friends( "player_start_exterior" );
	//flag_set( "intro_truck_left" );
	flag_set( "intro_complete" );
	flag_set( "exterior_initial_enemies" );
	//flag_set( "vo_streets_start" );
	thread juggernaut_player();
	
	/#
	setDevDvar( "dev_elevator_anim_test", "0" );
	#/
}

start_exterior_circle()
{
	aud_send_msg("start_exterior_circle");
	
	move_player_to_start("player_start_exterior_circle");
	setup_friends( "player_start_exterior_circle" );
	//flag_set( "intro_truck_left" );
	flag_set( "intro_complete" );
	//flag_set( "exterior_initial_enemies" );
	//flag_set( "vo_streets_start" );
	thread juggernaut_player();
	
	/#
	setDevDvar( "dev_elevator_anim_test", "0" );
	#/
}

start_lobby()
{
	aud_send_msg("start_lobby");
	
	move_player_to_start("player_start_lobby");
	setup_friends( "player_start_lobby" );
	thread juggernaut_player();
	
	/#
	setDevDvar( "dev_elevator_anim_test", "0" );
	#/
}

start_elevator()
{
	aud_send_msg("start_elevator");
	
	move_player_to_start("player_start_elevator");
	setup_friends( "player_start_elevator" );
	
	level notify( "vo_lobby_near_elevator" );
	
	thread juggernaut_player();
	
	flag_set( "lobby_yuri_to_elevator" );
	
	flag_set( "ocean_vista" );
	
	/#
	setDevDvar( "dev_elevator_anim_test", "0" );
	#/
}

start_dev_elevator_anim_test()
{
	move_player_to_start("player_start_elevator");
	setup_friends( "player_start_elevator" );
	
	level notify( "vo_lobby_near_elevator" );
	
	thread juggernaut_player();
	
	flag_set( "lobby_yuri_to_elevator" );
	
	flag_set( "ocean_vista" );
	
	/#
	setDevDvar( "dev_elevator_anim_test", "1" );
	#/
}

dev_elevator_anim_test_setup()
{
	
}

start_top_floor()
{
	aud_send_msg("start_top_floor");

	move_player_to_start("player_start_top_floor");
	setup_friends( "player_start_top_floor" );
	
	top_floor_yuri_grenade_location = getent( "top_floor_yuri_grenade_location", "targetname" );
		
	level.yuri ForceTeleport( top_floor_yuri_grenade_location.origin, top_floor_yuri_grenade_location.angles );
	level.yuri thread top_floor_yuri_throw_grenade( top_floor_yuri_grenade_location, true );
	
	flag_set( "player_at_top_floor" );
	flag_set( "elevator_replacement_moving_to_top" );
	
	setdvar( "makarov_escaping_time_left", "3.5" );
	flag_set( "top_floor_countdown_start" );
	
	left_door = level.replacement_elevator common_scripts\_elevator::get_outer_leftdoor( 1 );
	right_door = level.replacement_elevator common_scripts\_elevator::get_outer_rightdoor( 1 );
	left_door ConnectPaths();
	right_door ConnectPaths();
	
	level.player SwitchToWeapon( level.secondaryweapon );
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
}

start_restaurant_entrance()
{
	aud_send_msg("start_restaurant_entrance");
	
	move_player_to_start("player_start_restaurant_entrance");
	setup_friends( "player_start_restaurant_entrance" );
	
	setdvar( "makarov_escaping_time_left", "1" );
	
	flag_set( "top_floor_countdown_start" );
	
	level.player SwitchToWeapon( level.secondaryweapon );
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
}

start_restaurant_destruction()
{
	aud_send_msg("start_restaurant_destruction");

	move_player_to_start("player_start_restaurant_destruction");
	setup_friends( "player_start_restaurant_destruction" );
	
	flag_set( "chopper_restaurant_intro" );
	flag_set( "vo_restaurant_start" );
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
}

start_restaurant_exit()
{
	aud_send_msg("start_restaurant_exit");

	move_player_to_start("player_start_restaurant_exit");
	
	//thread restaurant_destruction_scripted_structure_animation();
	
	thread restaurant_destruction_drop_section();
	exploder(250);
	exploder(300);
	exploder(500);
	exploder(600);
	thread restaurant_destroy_glass();
	
	
	flag_set( "restaurant_drop_section_falling" );
	flag_set( "restaurant_destroyed" );
	
	level.player teleport_player( getent( "restaurant_sequence_player_end_point", "targetname" ) );
	
	thread finale_player_hands();
	
	level.doPickyAutosaveChecks = false;
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
	
	//thread restaurant_chase_timer();
	
	thread destroy_finale_func_glass();
}

start_finale_chopper_sequence()
{
	aud_send_msg("start_finale_chopper_sequence");

	start = getstruct( "player_start_finale_chopper_sequence", "targetname" );
	if (!isdefined(start.base_origin))
	{	// gsc hack to get player out of terrain
		start.base_origin = start.origin;
		start.origin = start.origin + (0,0,12);
	}
	move_player_to_start("player_start_finale_chopper_sequence");
	
	thread finale_player_hands();
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
	
	thread destroy_finale_func_glass();
}

start_finale_crash_site()
{
	aud_send_msg("start_finale_crash_site");

	level.player TakeAllWeapons();
	level.debug_start_finale_crash_site = true;
	flag_set( "finale_chopper_crash_complete" );
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
	
	thread destroy_finale_func_glass();
}

start_finale_beatdown()
{
	level.beatdown_debugstart = true;	
	aud_send_msg("start_finale_crash_site");

	level.player TakeAllWeapons();
	
	flag_set( "end_finale_showdown" );
	flag_set( "beatdown_tackle_start" );
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
	
	//setup lighting and vision
	thread maps\dubai_fx::setup_rooftop_searchlight_key();
	thread maps\dubai_fx::setup_atrium_fire_light_key();
	thread vision_set_fog_changes("dubai_fall",0.05);
	
	thread destroy_finale_func_glass();
}

start_finale_ending()
{
	level.ending_debugstart = true;	
	aud_send_msg("start_finale_crash_site");

  thread maps\dubai_finale::finale_player_setup();
	
	//setup lighting and vision set
	thread maps\dubai_fx::setup_rooftop_searchlight_key();
	thread maps\dubai_fx::setup_atrium_fire_light_key();
	thread maps\dubai_fx::setup_mysterious_stranger_rimlight();
	thread vision_set_fog_changes("dubai_cigar",1);
	
	flag_set( "elevator_doors_closed" );
	flag_set( "ocean_vista" );
	thread maps\dubai_finale::finale_beatdown_during_credits( undefined, undefined, true );
	flag_set( "end_of_credits");
	
	//destroy nearby glass
	thread maps\dubai_finale::finale_beatdown_break_glass_rail();
	
	thread destroy_finale_func_glass();
}

start_dev_capture_reflection()
{
	flag_set( "elevator_doors_closed" );
	thread maps\dubai_finale::finale_capture_reflection();
}

start_dev_credits()
{
	setdvar( "ui_char_museum_mode", "credits_2" );
	level.player TakeAllWeapons();
	start_credits();
}

start_dev_credits_black()
{
	setdvar( "ui_char_museum_mode", "credits_black" );
	level.player TakeAllWeapons();
	start_credits();
}

start_credits()
{
	flag_set( "elevator_doors_closed" );
	level.black = get_black_overlay();
	level.black.alpha = 1;
	//thread finale_end_mission();
	mode = getdvar("ui_char_museum_mode");
	if (mode != "credits_black")
	{
		thread maps\dubai_finale::finale_beatdown_during_credits();
	//	wait 0.05;
	//	level.black fadeOverTime( 2 );
	//	level.black.alpha = 0;
	}
	else
	{
		flag_set( "level_end" );
	}
}
