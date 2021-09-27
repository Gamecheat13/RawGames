#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;
#include maps\prague_code;
#include maps\prague_courtyard_script_code;
#include maps\prague_plaza_script;

main()
{
	blocker = get_Target_ent( "courtyard_btr_blocker" );
	blocker connectpaths();
	blocker notsolid();
	
	flag_init( "courtyard_retreat_one" );
	flag_init( "new_courtyard_start" );
	flag_init( "retreat_three" );
	flag_init( "retreat_two" );
	flag_init( "courtyard_air_drop" );
	flag_init( "tunnel_convoy_two" );
	flag_init( "long_convoy_move_two" );
	flag_init( "pre_courtyard_ally_clean_up" );
	flag_init( "plaza_btrs_new_attack" );
	flag_init( "btr_attack_plaza" );
	flag_init( "btr_dead_now" );
	flag_init( "player_take_out_btr" );
	flag_init( "rebels_two" );
	flag_init( "can_shoot_player_courtyard" );
	flag_init( "can_shoot_player" );
	flag_init( "fire_flare" );
	flag_init( "fire_flare_two" );
	flag_init( "sniper_shot" );
	flag_init( "heli_support_courtyard" );
	flag_init( "courtyard_combat_start" );
	flag_init( "roof_all_standing" );
	flag_init( "roof_start_to_stand" );
	flag_init( "apart_blowup_window_2nd" );
	flag_init( "plaza_see" );
	flag_init( "plaza_see_two" );
	flag_init( "plaza_see_two_two" );
	flag_init( "player_at_gate" );
	flag_init( "courtyard_player_moving_too_fast" );
	flag_init( "plaza_move_sandman_up" );
	flag_init( "plaza_move_sandman_up_two" );
	flag_init( "turn_death_trigger_on" );
	flag_init( "tank_attack_building" );
	flag_init( "kill_sniper_nag_lines" );
	flag_init( "turn_death_trigger_on_for_btr" );
	flag_init( "turn_on_laser_moment" );
	flag_init( "sandman_start_first_take_down" );
	flag_init( "soap_over_the_fence" );
	flag_init( "spotlight_aim_at_player" );
	flag_init( "spotlight_aim_at_sandman" );
	
	PreCacheShader( "nightvision_overlay_goggles" );
//  precachestring();
	precacheshellshock( "nightvision" );
	precachemodel( "weapon_usp_silencer" );

	precachemodel( "weapon_rpg7_obj" );
	precachemodel( "weapon_rpg7" );
	
	PrecacheString( &"PRAGUE_HINT_USE_SHORT_SCOPE" );
	add_hint_string( "short_scope", &"PRAGUE_HINT_USE_SHORT_SCOPE", ::should_break_scope_hint );
	
	array_thread( getentarray( "dead_body_spawner_trigger_ally", "targetname" ), ::dead_body_spawner_trigger );
	array_spawn_function_targetname( "courtyard_puzzle_guys", ::courtyard_puzzle_guys_think );
	array_spawn_function_targetname( "courtyard_roof_dying_quick_kill", ::courtyard_puzzle_guys_think );
	
	
	array_spawn_function_targetname( "courtyard_heli_flyby", ::cargo_heli_think );
	array_spawn_function_noteworthy( "plaza_loader", ::plaza_loader_think );
	array_spawn_function_noteworthy( "plaza_loader", ::enemy_dead_add );
	
	array_spawn_function_noteworthy( "courtyard_backup", :: enemy_dead_add );
	array_spawn_function_targetname( "apt_resistance_drone_spawner_under", ::delete_on_notify, "cleanup_dead_bodies_three" );
	
	array_spawn_function_targetname( "roof_stealth_one", ::guys_on_rooftops );
	array_spawn_function_targetname( "roof_stealth_two", ::guys_on_rooftops );
	
	
	array_spawn_function_targetname( "courtyard_rpg_guy_build_one", ::molotov_guy_think );
	array_spawn_function_targetname( "courtyard_rpg_guy_build_one", ::roof_top_assign_random_death );
	array_spawn_function_targetname( "courtyard_ar_guy_build_one", ::molotov_guy_think );
	array_spawn_function_targetname( "courtyard_ar_guy_build_one", ::roof_top_assign_random_death );
	
	array_spawn_function_targetname( "courtyard_ar_guy_build_two", :: roof_top_assign_random_death );
	array_spawn_function_targetname( "courtyard_rpg_guy_build_two", :: roof_top_assign_random_death );
	array_spawn_function_targetname( "courtyard_rpg_guy_build_two_third", :: roof_top_assign_random_death );
	array_spawn_function_targetname( "courtyard_ar_guys_build_three", :: roof_top_assign_random_death );
	array_spawn_function_targetname( "courtyard_ar_guys_build_four", :: roof_top_assign_random_death );
//	array_spawn_function_targetname( "courtyard_ar_guys_build_five", :: roof_top_assign_random_death );

	array_spawn_function_targetname( "plaza_resistance_drone_runner_3", :: plaza_resistance_drone_runner_think );
	array_spawn_function_targetname( "plaza_resistance_drone_runner_2", :: plaza_resistance_drone_runner_think );
	array_spawn_function_targetname( "plaza_resistance_drone_runner_1", :: plaza_resistance_drone_runner_think );
	
	array_spawn_function_targetname( "roof_stealth_epic", ::guys_on_rooftops );
	array_spawn_function_targetname( "roof_stealth_epic", ::roof_top_assign_random_death );
	
	
	array_spawn_function_targetname( "plaza_btr_attack", ::delete_on_notify, "start_apartment_fight" );
	array_spawn_function_targetname( "courtyard_support_ai", ::enemy_dead_add );
	array_spawn_function_targetname( "courtyard_support_ai_two", ::enemy_dead_add );
	array_spawn_function_targetname( "courtyard_support_ai_three", ::enemy_dead_add );
//	array_spawn_function_targetname( "helicopter_backup", ::enemy_dead_add_two );
	
	level.counter_dead = 0;
	
	level.looked_at_roof_rebel = 0;
	level.number_to_random = 0;
	level.magic = 0;
	level.btr_turret_in_use = 0;
	level.wait_for_new_lines = 15;
	
	trigger = GetEnt( "battle_1_guys", "target" );
	trigger trigger_off();
}

start_courtyard() // ts is run from the jump to start point
{
	level.player vision_set_fog_changes( "prague_redbuilding", 1 );
//	level.player thread jug_look();
	spawn_sandman();
	set_start_positions( "start_courtyard" );
	flag_set( "start_sewers" );
	flag_set( "player_out_of_water" );
	flag_set( "start_alcove" );
	flag_set( "start_alley" );
	flag_set( "start_long_convoy" );
	flag_set( "fade_up" );
	flag_set( "city_reveal" );
	flag_set( "start_kamarov_scene" );
	flag_set( "start_follow_soap" );
	wait( 0.3 );
	flag_set( "start_courtyard" );
	long_convoy_traverse_to_courtyard();
}

courtyard_setup() // this is run from the beggining of the level. This is skipped in later start points.
{
	damage_trigger = getent ( "detect_damage_clear_stealth", "targetname" );
	damage_trigger trigger_off();
	flag_wait( "start_courtyard" );
	thread cqb_trigger();
	thread courtyard_airdrop();
	setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
	
	flag_clear( "sandman_killfirms" );
	
	
	flag_wait( "new_courtyard_start" );
	level.sandman.moveplaybackrate = 1;
	
	thread courtyard_sandman_cover_direction();
	thread heli_support_prague_code();	
	thread courtyard_puzzle();
	thread tell_player_too_slow_down();
	thread damage_trigger_clear_stealth();
	thread courtyard_knife_kill();
	thread courtyard_beg_player_ignore();
	level endon( "player_gonna_die" );
	guys = array_spawn_targetname( "courtyard_puzzle_guys" );
	array_thread( guys, ::delete_on_notify, "cleanup_puzzle" );
	
	player_speed_percent( 84 );
	
	thread magic_smoke( "plaza_smoke" );
	
	level.sandman notify( "stop_path" );
	level.sandman AllowedStances( "stand", "crouch", "prone" );
	if ( !flag( "sandman_climb_dumpster" ) )
	{
		level.sandman notify( "clear_idle_anim" );
		level.sandman clear_generic_idle_anim();
		
		level.sandman disable_cqbwalk();
		level.sandman enable_sprint();
		long_convoy_traverse_to_courtyard();
		level.sandman disable_sprint();
	}	
	
	ai = getaiarray( "axis" );
	delayThread( 3, ::group_flavorbursts, ai, "ru", 9, 9, false );
	

	thread courtyard_sandman_think();
	thread music_start_flare();
	thread courtyard_backup();	
	thread sandman_combat();
	thread courtyard_clean_stealth_thinkers();
	thread player_death_trigger();
	thread courtyard_plaza_enemy_manager();
	
	thread moving_in_ally_too_fast();
	thread base_loud_speakers();

}

should_break_scope_hint()
{
	weapons = level.player GetWeaponsList( "primary" );
	hashybridweapon = false;
	foreach ( w in weapons )
	{
		if ( issubstr( w, "hybrid" ) )
		{
			hashybridweapon = true;
			break;
		}
	}
	
	currentweapon = level.player GetCurrentWeapon();
	isusinghybrid = issubstr( currentweapon, "alt_" ) && issubstr( currentweapon, "hybrid" );

	isusingunsilenced = !issubstr( currentweapon, "silence" );

	return ( !hashybridweapon || isusinghybrid || isusingunsilenced );
}

cqb_trigger()
{
	trigger = get_target_ent( "cqbwalk_trigger" );
	trigger waittill( "trigger" );
	level.sandman enable_cqbwalk();
}