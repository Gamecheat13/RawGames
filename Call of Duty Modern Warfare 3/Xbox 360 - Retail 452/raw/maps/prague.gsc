#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_code;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;

main()
{
	maps\prague_precache::main();
	maps\prague_fx::main();
	maps\prague_anim::main();
	maps\createfx\prague_fx::main();
	maps\createart\prague_art::main();
	
	PrecacheShader( "compass_map_prague_intro" );
	PrecacheShader( "compass_map_prague_streets" );
	PrecacheShader( "compass_map_prague_church" );
	
	PrecacheModel( "com_flashlight_on" );
	PrecacheModel( "com_flashlight_off" );
	PrecacheModel( "projectile_us_smoke_grenade" );
	PrecacheModel( "vehicle_mi17_woodland_fly_cheap" );
	PreCacheModel( "com_prague_rope_animated" );
	PrecacheModel( "vehicle_btr80" );
	PrecacheModel( "com_blackhawk_spotlight_on_mg_setup" );
	PrecacheModel( "mil_mre_chocolate01" );
	PrecacheModel( "com_bottle2" );
	PrecacheModel( "mil_emergency_flare" );
	PrecacheModel( "head_london_female_b" );
	PrecacheModel( "head_fso_a_dirty" );
	PrecacheModel( "head_fso_b_dirty" );
	PrecacheModel( "head_fso_e_dirty" );
	PrecacheModel( "body_prague_civ_male_b" );
	PrecacheModel( "body_prague_civ_male_bb" );
	PrecacheModel( "com_barrel_black" );
	PrecacheModel( "trash_carton_milk" );
	PrecacheModel( "com_boat_fishing_1" );
	PrecacheModel( "com_boat_fishing_buoy2" );
	PrecacheModel( "com_bottle3" );
	PrecacheModel( "foliage_tree_destroyed_fallen_log_a" );
	PrecacheModel( "ch_crate48x64" );
	PrecacheModel( "weapon_m67_grenade" );
	
	PrecacheString( &"PRAGUE_HINT_SCAFFOLD" );
	PrecacheString( &"PRAGUE_HINT_PRONE" );
	PrecacheString( &"PRAGUE_DONT_MOVE" );
	
	PrecacheItem( "rpg" );
	PrecacheItem( "rpg_straight" );
	PrecacheItem( "rpg_player" );
	PrecacheItem( "heli_spotlight" );
	
	PrecacheRumble( "subtle_tank_rumble" );
	
	PrecacheShellShock( "prague_swim" );
	PrecacheShellShock( "prague_explosion" );
	
	level.male_heads = [ "head_fso_a_dirty", "head_fso_b_dirty", "head_fso_e_dirty" ];
	
	add_hint_string( "hint_scaffold", &"PRAGUE_HINT_SCAFFOLD", ::should_break_scaffold_hint );
	add_hint_string( "hint_prone", &"PRAGUE_HINT_PRONE", ::should_break_prone_hint );
	
	set_default_start( "new_intro" );

	add_start( "new_intro", maps\prague_new_intro::start_new_intro, "Intro", maps\prague_new_intro::new_intro_setup );
	add_start( "sewer_traverse", ::start_sewers, "Sewers", ::sewers_setup );
	add_start( "alcove", ::start_alcove, "Alcove", ::alcove_setup );
	add_start( "alley", ::start_alley, "Alley", ::alley_setup );
	add_start( "convoy", ::start_convoy, "Convoy", ::convoy_setup );
	add_start( "courtyard", maps\prague_courtyard_script::start_courtyard, "Courtyard", maps\prague_courtyard_script::courtyard_setup );
	add_start( "plaza", maps\prague_plaza_script::start_plaza, "Plaza", maps\prague_plaza_script::plaza_setup );
	add_start( "apartments", ::start_apartments, "Apartments", ::apartments_setup );
	add_start( "apartment_fight", ::start_apartment_fight, "Apartment Fight", ::apartment_fight_setup );
	add_start( "gallery", ::start_gallery, "Gallery", ::gallery_setup );
	add_start( "church", maps\prague_church_script::start_church, "Chruch", maps\prague_church_script::church_setup );
	
	maps\_dynamic_run_speed::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_yuri_europe" );
	maps\_load::main();

	thread maps\prague_amb::main();

	maps\_stealth::main();
	maps\_drone_civilian::init();
	maps\_drone_ai_rambo::init();

	maps\_molotov::init();

	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	maps\_idle_smoke_balcony::main();

	maps\_flare_no_sunchange::main( "tag_flash" );
	
	maps\_patrol_anims::main();
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	paired_death_restart();
	level.sandman_shooting = false;
	level.heli_spot_movetime = 0.75;
	level.heli_spot_staytime = 3.75;
	level.last_killfirm_time = -999999;
	level.last_killfirm_timeout = 5000;
	level.rainlevel = 9;
	visionSetNaked ( "prague", 0 );
	
	init_level_flags();
	
	anim.fire_notetrack_functions[ "drone" ] = maps\_drone::Drone_Shoot;
	
	array_spawn_function( Vehicle_GetSpawnerArray(), ::disable_mg );
	
	array_spawn_function_targetname( "kamarov", ::setup_kamarov );

	array_spawn_function_targetname( "street_scene_3_spawner", ::vignette_runner_setup );
	array_spawn_function_targetname( "street_scene_3_spawner", ::delete_on_notify, "start_alcove" );
	
	array_spawn_function_targetname( "tunnel_kickers", ::spawnfunc_idle );
	array_spawn_function_targetname( "long_convoy_btr", ::long_convoy_btr_think );
	array_spawn_function_targetname( "long_convoy_foot", ::long_convoy_foot_think );
	array_spawn_function_targetname( "long_convoy_foot_2", ::long_convoy_foot_think );
//	array_spawn_function_targetname( "long_convoy_foot_3", ::long_convoy_foot_think );
	array_spawn_function_targetname( "long_convoy_foot_4", ::long_convoy_foot_think );
	array_spawn_function_targetname( "long_convoy_foot_extra", ::delete_on_notify );
	
	array_spawn_function_targetname( "apartment_rpg_guy", ::apartment_rpg_guy );
	array_spawn_function_targetname( "apt_fight_good_5_drone", ::drone_assign_unique_death );
	array_spawn_function_targetname( "gallery_btr_troop_deployer", ::btr_attack_player_on_flag, "btr_spotted" );
	array_spawn_function_targetname( "gallery_btr_watchdog", ::btr_attack_player_on_flag, "btr_spotted" );
	
	array_spawn_function_targetname( "bank_backup", ::bank_backup_think );
	array_spawn_function_targetname( "bank_backup_2", ::bank_backup_think );
	
	array_spawn_function_targetname( "alcove_cargo_heli", ::cargo_heli_think );
	array_spawn_function_targetname( "alley_cargo_heli", ::cargo_heli_think );
	
	array_spawn_function_targetname( "street_convoy", ::check_dead_bodies_think );
	array_spawn_function_targetname( "street_snipers", ::flag_on_death, "alley_sniper_dead" );
	array_spawn_function_targetname( "street_snipers", ::teleport_on_spotted );
	array_spawn_function_targetname( "street_snipers", ::delete_on_notify, "cleanup_snipers" );
	array_spawn_function_targetname( "dead_body_spawner_intro", ::delete_on_notify, "player_out_of_water" );
	array_spawn_function_targetname( "dead_body_spawner_alcove", ::delete_on_notify, "cleanup_dead_bodies" );
	array_spawn_function_targetname( "dead_body_spawner_redhouse", ::delete_on_notify, "cleanup_dead_bodies" );
	array_spawn_function_targetname( "sewer_resistance_group", ::delete_on_notify, "spawn_alcove_guys" );
	
	array_spawn_function_targetname( "apt_stagger_death_guy", ::set_generic_deathanim, "airport_security_guard_pillar_death_R" );
	array_spawn_function_targetname( "apt_stagger_death_guy", ::stagger_death );
	
	array_spawn_function_targetname( "mg_gunner", ::mg_guy_think );
	array_spawn_function_targetname( "mg_gunner_support", ::mg_guy_support );
	
	array_spawn_function_noteworthy( "molotov_guy", ::molotov_guy_think );
	array_spawn_function_noteworthy( "apt_runner", ::apt_runner_drone_think );
	array_spawn_function_noteworthy( "alley_snipers", ::light_on_gun );
	
	array_spawn_function_noteworthy( "apt_resistance_drone_anim", ::inside_apt_resistance_anim_think );
	array_spawn_function_noteworthy( "apt_resistance_drone_anim_then_idle", ::inside_apt_resistance_anim_then_idle_think );
	array_spawn_function_noteworthy( "apt_resistance_drone_anim_then_die", ::inside_apt_resistance_anim_then_die_think );
	array_spawn_function_noteworthy( "resistance_cover_behavior", ::resistance_cover_behavior );
	
	array_spawn_function_noteworthy( "delete_on_notify", ::delete_on_notify );
	array_spawn_function_noteworthy( "vignette_btr", ::vignette_btr_think );

	init_common_triggers();
	
	array_thread( getentarray( "level_cleanup", "targetname" ), ::level_cleanup_trigger );
	array_thread( getentarray( "start_vignette", "targetname" ), ::start_vignette_trigger );
	
	array_thread( getentarray( "heli_scan_trigger", "targetname" ), ::heli_scan_update );
	array_thread( getentarray( "heli_move_trigger", "targetname" ), ::heli_move_update );
	array_thread( getentarray( "heli_teleport_trigger", "targetname" ), ::heli_teleport );
	array_thread( getentarray( "heli_default_target_trigger", "targetname" ), ::heli_default_target_trigger );
	
	array_thread( getentarray( "sandman_follow_path", "targetname" ), ::sandman_follow_path );
	array_thread( getentarray( "stealth_range_trigger", "targetname" ), ::stealth_range_trigger );
	array_thread( getentarray( "delete_triggerer", "targetname" ), ::delete_triggerer );
	array_thread( getentarray( "physics_explosion_trigger", "targetname" ), ::physics_explosion_trigger );
	array_thread( getentarray( "btr_stop_trigger", "targetname" ), ::long_convoy_btr_stop );
	array_thread( getentarray( "convoy_clear_run_anim_trigger", "targetname" ), ::long_convoy_clear_run_anim );
	array_thread( getentarray( "clear_run_anim_trigger", "targetname" ), ::clear_run_anim_trigger );
	array_thread( getentarray( "stealth_spotted_trigger", "targetname" ), ::stealth_spotted_trigger );
	array_thread( getentarray( "sandman_clear_run_anim", "targetname" ), ::sandman_clear_run_anim_trigger );
	array_thread( getentarray( "idle_spawner_trigger", "targetname" ), ::idle_spawner_trigger );
	array_thread( getentarray( "dead_body_spawner_trigger", "targetname" ), ::dead_body_spawner_trigger );
	array_thread( getentarray( "remove_ignore_trigger", "targetname" ), ::remove_ignore_trigger );
	array_thread( getentarray( "door_shut_trigger", "targetname" ), ::door_shut_trigger );

	array_thread( getentarray( "physics_jolt_trigger", "targetname" ), ::physics_jolt_trigger );
	array_thread( getentarray( "player_ignore_trigger", "targetname" ), ::player_ignore_trigger );
	array_thread( getentarray( "bank_wakeup_trigger", "targetname" ), ::flag_set_trigger );
	array_thread( getentarray( "flag_set_trigger", "targetname" ), ::flag_set_trigger );
	array_thread( getentarray( "damage_trigger", "targetname" ), ::damage_trigger );

	maps\prague_new_intro::main();
	maps\prague_courtyard_script::main();
	maps\prague_church_script::main();
	
	disable_trigger_with_targetname( "flag_alley_trigger" );
	disable_trigger_with_targetname( "dog_spotted_trigger" );
	disable_trigger_with_targetname( "dog_spotted_trigger2" );
	
	level.player thread maps\_stealth_utility::stealth_default();
	thread flashbang_track_setup();
	level.global_callbacks[ "_spawner_stealth_default" ] 	= ::_spawner_stealth_custom;	

	thread patrol_chopper( "patrol_heli" );
	thread level_cleanup_thread();

	CreateThreatBiasGroup( "battle_russians" );
	CreateThreatBiasGroup( "battle_civs" );
	CreateThreatBiasGroup( "delta" );
	
//	SetThreatBias( "battle_civs", "battle_russians", 3000 );
//	SetThreatBias( "delta", "battle_russians", -3000 );
//	SetThreatBias( "battle_russians", "delta", -500 );
	
	level.player setThreatBiasGroup( "delta" );
	
	delayThread( 0.5, ::custom_animset_run_move );
		
	hide_me = getentarray( "hide_me", "script_noteworthy" );
	foreach ( h in hide_me )
		h Hide();

	triggers = getentarray( "long_convoy_death", "script_noteworthy" );
	foreach ( t in triggers )
		t trigger_off();
		
	lights = getentarray( "sewer_flare_primary", "script_noteworthy" );
	foreach ( l in lights )
		l setLightIntensity( 0 );
	
	level.struct = undefined;
		
	thread stealth_busted_music();
	thread objectives();
	thread loud_speakers();
	thread let_it_rain();
	
	add_global_spawn_function( "allies", ::remove_helmetpop );
	
	node = get_Target_ent( "courtyard_takedown" );
	node.origin += (8,20,0);
	node.origin = ( 12098.8, node.origin[1], node.origin[2] );
}

init_level_flags()
{
	PreCacheShellShock( "default" );
	
	anim.grenadeTimers[ "AI_molotov" ] = randomIntRange( 0, 20000 );	
	level.player.grenadeTimers[ "molotov" ] = 0;
	
	flag_init( "alley_sniper_dead" );
	flag_init( "mg_event_done" );
	flag_init( "start_follow_soap_icon" );
	flag_init( "start_follow_soap" );
	flag_init( "alcove_guys_leave" );
	flag_init( "long_convoy_deadbody_shot" );
	flag_init( "player_out_of_water" );
	flag_init( "start_kamarov_scene" );
	flag_init( "clear_to_dock" );
	flag_init( "alcove_soldier_shot" );
	flag_init( "alley_lights_out" );
	flag_init( "alley_move_up" );
	flag_init( "alley_spotted" );
	flag_init( "alley_sandman_in_position" );
	flag_init( "chopper_escape" );
	flag_init( "start_interrogation" );
	flag_init( "start_long_convoy" );
	flag_init( "long_convoy_all_clear" );
	flag_init( "plaza_heli_gone" );
	flag_init( "player_has_rpg" );
	flag_init( "long_convoy_btr_stop" );
	flag_init( "begin_introductions" );
	flag_init( "start_apartments" );
	flag_init( "start_apartment_fight" );
	flag_init( "player_started_riot" );
	flag_init( "gallery_street_clear" );
	flag_init( "courtyard_puzzle_sandman_ready" );
	flag_init( "courtyard_smokers_dead" );
	flag_init( "courtyard_statue_patrol_dead" );
	flag_init( "courtyard_loaders_dead" );
	flag_init( "courtyard_snipers_dead" );
	flag_init( "white_building_breachers_in_position" );
	flag_init( "church_street_clear" );
	flag_init( "sandman_climb_dumpster" );
	flag_init( "courtyard_btr_left" );
	flag_init( "bridge_sniper_dead" );
	flag_init( "courtyard_sandman_killed_dude" );
	flag_init( "sandman_at_red_house" );
	flag_init( "alley_sniper_dead" );
	flag_init( "foot_patrol_dead" );
	flag_init( "convoy_scare_done" );
	flag_init( "bully_died" );
	flag_init( "alcove_snipers_dead" );
	flag_init( "alcove_dog_dead" );
	flag_init( "btr_spotted" );
	flag_init( "start_sewer_drag" );
	flag_init( "apt_resistance_guy_hit" );
	flag_init( "apt_player_kill_point_nags" );
	flag_init( "the_end" );
	
	flag_init( "allow_mg_gunners_to_die" );
	
	flag_init( "sandman_killfirms" );
	flag_set( "sandman_killfirms" );
	
	flag_init( "sandman_announce_spotted" );
	flag_set( "sandman_announce_spotted" );
}

start_sewers()
{
	thread maps\_utility::set_ambient("prague_sewer"); // start prague_zodiac zone
	level.player vision_set_fog_changes( "prague_sewer", 1 );
	spawn_sandman();
	spawn_price();
	spawn_kamarov();
	set_start_positions( "start_sewers" );
	flag_set( "city_reveal" );
	flag_set( "start_kamarov_scene" );
	
	thread maps\prague_new_intro::player_leaves_water();
	
	player_speed_percent( 85 );
}

start_alcove()
{
	level.player vision_set_fog_changes( "prague_courtyard", 1 );
	spawn_sandman();
	set_start_positions( "start_alcove" );
	flag_set( "start_sewers" );
	flag_set( "player_out_of_water" );
}

start_alley()
{
	level.player vision_set_fog_changes( "prague_courtyard", 1 );
	disable_trigger_with_targetname( "alcove_sniper_spotted_trigger" );
	spawn_sandman();
	set_start_positions( "start_alley" );
	flag_set( "start_sewers" );
	flag_set( "start_alcove" );
	flag_set( "player_out_of_water" );
	activate_trigger( "heli_goes_far_away", "script_noteworthy" );
	wait( 0.3 );
	flag_set( "start_alley" );
	//thread flickering_light( "alley_light", 0.3, 0.5 );
}

start_convoy()
{
	level.player vision_set_fog_changes( "prague_courtyard", 1 );
	spawn_sandman();
	set_start_positions( "start_convoy" );
	flag_set( "start_sewers" );
	flag_set( "player_out_of_water" );
	flag_set( "start_alcove" );
	flag_set( "start_alley" );
	activate_trigger( "heli_goes_far_away", "script_noteworthy" );
	
	paired_death_restart();
	flag_set( "alley_heli_left" );
	disable_trigger_with_noteworthy( "alley_heli_failsafe_trigger" );
	flag_set( "start_long_convoy" );
}

start_apartments()
{
	spawn_sandman();
	set_start_positions( "start_apartments" );
	level.player vision_set_fog_changes( "prague_courtyard2", 1  );
	flag_set( "fade_up" );
	flag_set( "city_reveal" );
	flag_set( "start_kamarov_scene" );
	flag_set( "start_follow_soap" );
	flag_set( "fire_flare" );
	
	flag_set( "start_sewers" );
	flag_set( "player_out_of_water" );
	flag_set( "start_alcove" );
	flag_set( "start_alley" );
	flag_set( "start_long_convoy" );
	flag_set( "start_courtyard" );
	flag_set( "pre_courtyard_ally_clean_up" );
	
	node = get_target_ent( "sandman_apt_enter_path" );
	node = node get_target_ent();
	node = get_target_ent( "sandman_apt_path_backup" );
	
	waitframe();
	level.sandman disable_cqbwalk();
	level.sandman follow_path_waitforplayer( node );
}

start_apartment_fight()
{
	spawn_sandman();
	level.player vision_set_fog_changes( "prague_redbuilding", 1 );
	set_start_positions( "start_apartment_fight" );
	flag_set( "start_sewers" );
	flag_set( "player_out_of_water" );
	flag_set( "start_alcove" );
	flag_set( "start_alley" );
	flag_set( "start_long_convoy" );
	flag_set( "start_courtyard" );
	flag_set( "pre_courtyard_ally_clean_up" );
	flag_set( "start_apartments" );
	
	wait( 0.1 );
	thread magic_smoke( "battle_1_smoke" );
	thread magic_smoke( "battle_2_smoke" );
	spawn_vehicles_from_targetname( "battle_2_btrs" );
	maps\_spawner::flood_spawner_scripted( getentarray( "battle_2_guys", "targetname" ) );
	flag_set( "start_apartment_fight" );
}

start_gallery()
{
	spawn_sandman();
	level.player vision_set_fog_changes( "prague_redbuilding", 1 );
	set_start_positions( "start_gallery" );
	flag_set( "start_sewers" );
	flag_set( "player_out_of_water" );
	flag_set( "start_alcove" );
	flag_set( "start_alley" );
	flag_set( "start_long_convoy" );
	flag_set( "start_courtyard" );
	flag_set( "pre_courtyard_ally_clean_up" );
	flag_set( "start_apartments" );
	flag_set( "start_apartment_fight" );
	flag_set( "start_apartment_exit" );
	wait( 0.5 );
	tank = spawn_vehicle_from_targetname_and_drive( "apt_btr_backup" );
	tank Vehicle_SetSpeed( 30, 15, 15 );
}


zodiac_ride_setup()
{

}

sewers_setup()
{
	flag_wait( "start_sewers" );
	
	anim.notetracks[ "gun_2_chest" ] = maps\prague_anim::do_nothing;
	
	level.treadfx_maxheight = undefined;
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_fly_cheap", "water", "treadfx/heli_water" );

	spawn_kamarov();	
	level.heli thread heli_wants_spotlight();
	
	thread dustfall();
	thread sewer_gate();
	thread kamarov_scene();
	thread sandman_stop_look_convoy();
	thread fail_on_spotted( "spawn_alcove_guys" );
	thread sewer_flash_check();
	thread wait_for_convoy_to_pass();
	
	wait( 0.1 );
	
	lights_flick = getentarray( "sewer_light_primary", "targetname" );
	
	foreach ( light in lights_flick )
	{
		thread flickering_light( light, 1, 2 );
	}
}

alcove_setup()
{
	flag_wait( "start_alcove" );
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	
	autosave_stealth();
	waitframe();
	thread magic_smoke( "alley_smoke" );
	
	player_speed_percent( 85 );
	
	if ( isdefined( level.price ) )
		level.price delete();
	if ( isdefined( level.kamarov ) )
		level.kamarov delete();
		
	thread flickering_light( get_target_ent( "alley_alcove_light" ), 0.5, 0.75 );
	
	thread alley_blocker();
	thread sandman_knife_kill();
	thread alcove_sniper_sight();
	thread alcove_scene();
	thread alcove_backup();
	thread alley_move_up();
	thread street_convoy_spawn();
}

alley_setup()
{
	flag_wait( "start_alley" );
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	
	player_speed_percent( 85 );
	
	thread foot_patrol_incoming();
	thread elevator_start();
}

convoy_setup()
{
	flag_wait( "start_long_convoy" );
	player_speed_percent( 85 );
	music_stop( 4 );
	
	thread long_convoy();
}

apartments_setup()
{
	flag_wait( "start_apartments" );
	flag_clear( "_stealth_spotted" );
	autosave_by_name( "apartments" );
	
	paired_death_restart();
	
	music_play( "prague_tragic", 10 );
	
	player_speed_percent( 85 );
	
	level.sandman disable_dynamic_run_speed();
	level.sandman.goalradius = 256;
	level.sandman.goalheight = 32;
	level.sandman.ignoreAll = true;
	
	thread apartment_dust();
	thread apartment_exploder();
	thread apartment_scene();
	thread apartment_moans();
	thread sandman_apartment_think();
	thread peptalk();
}

apartment_fight_setup()
{
	flag_wait( "start_apartment_fight" );
	
	level.player.ignoreme = false;
	
	battlechatter_on( "axis" );
	triggers = getentarray( "stealth_spotted_trigger", "targetname" );
	foreach ( t in triggers )
	{
		t trigger_off();
	}
	
	thread radio_dialogue( "prague_mct_okletsgo" );
	
//	iprintlnbold( "The church shouldn't be far." );
	
	autosave_by_name( "apartment_fight" );
	
	thread music_play( "prague_apt_combat" );
	
//	thread magic_smoke( "battle_3_smoke" );
	thread magic_smoke( "battle_3b_smoke" );
	thread magic_smoke( "battle_3c_smoke" );
	
	level.sandman set_force_color( "r" );
	level.sandman enable_ai_color();
	level.sandman.goalradius = 128;
	level.sandman.goalheight = 16;
	level.sandman disable_cqbwalk();
	
	player_speed_percent( 85 );
	
	thread mg_event();
	thread magic_rpg();
	thread crowd_charge();
	thread apt_fight_sandman_think();
}

gallery_setup()
{
	flag_wait( "start_gallery" );
	Objective_OnEntity( obj( "fight" ), level.sandman );
	
	autosave_by_name( "gallery" );
	
	level.sandman.goalradius = 128;
	level.sandman.goalheight = 16;
	level.sandman setGoalNode( getNode( "gallery_guard_node", "targetname" ) );
	
	thread resume_stealth();
	thread sandman_gallery_think();
	thread sandman_gallery_exit();
	thread btrs_drive_away();
	thread sandman_opens_bank();
	thread guy_runs_and_gets_owned();
	thread heli_drops_troops();
	thread secure_white_building();
	
	flag_wait( "gallery_exit" );
	thread magic_smoke( "church_smoke" );
	triggers = getentarray( "stealth_spotted_trigger", "targetname" );
	foreach ( t in triggers )
	{
		t trigger_on();
	}
		
	flag_wait( "entering_white_building" );
	triggers = getentarray( "church_stealth_triggers", "script_noteworthy" );
	foreach ( t in triggers )
	{
		t trigger_off();
	}	
}


_spawner_stealth_custom()
{
	self thread death_notify();
	self thread stealth_custom();
}

do_zodiac_anim( anime )
{
//	if ( self == level.sandman )
//	{
//		seat = level.sandman_seat;
//		idleanim = level.sandman_zodiac_idle;
//	}
//	else if ( self == level.driver )
//	{
//		seat = level.driver_seat;
//		idleanim = "prague_zodiac_driver_idle";
//	}
//	else
//		return;
//	
//	seat notify( "stop_loop" );
//	seat anim_single_solo( self, anime );
//	seat thread anim_loop_solo( self, idleanim );
}

sandman_zodiac_aimup()
{
//	level.sandman_zodiac_idle = "prague_zodiac_sandman_aim_idle";
//	level.sandman do_zodiac_anim( "prague_zodiac_sandman_cover2aim" );
}

sandman_zodiac_aimdown()
{
//	level.sandman_zodiac_idle = "prague_zodiac_sandman_cover_idle";
//	level.sandman do_zodiac_anim( "prague_zodiac_sandman_aim2cover" );
}

sandman_zodiac_shot( guy )
{
	if ( level.sandman_shooting )
		return;
	
	level.sandman_shooting = true;
	
	aim_spot = guy GetEye();
	vec = VectorNormalize( level.sandman GetEye() - aim_spot );
	vec *= 96;// bullet starts 96 units from head
	start_spot = aim_spot + vec;
	
	MagicBullet( level.sandman.primaryweapon, start_spot, aim_spot );
//	level.sandman do_zodiac_anim( "prague_zodiac_sandman_fire" );
	
	level.sandman_shooting = false;
}

should_break_scaffold_hint()
{
	volume = get_Target_Ent( "scaffold_volume" );
	return level.player isTouching( volume );
}

should_break_prone_hint()
{
	return ( level.player getStance() == "prone" );
}

flag_set_trigger()
{
	maps\_load::flag_set_trigger( self );
}

fail_on_spotted( endon_str )
{
	level endon( endon_str );
	
	flag_wait( "_stealth_spotted" );
	wait( 0.5 );
	quote = &"PRAGUE_YOUR_ACTIONS_GOT_RES";

	SetDvar( "ui_deadquote", quote );
	thread maps\_utility::missionFailedWrapper();
}

sewer_flash_check()
{
	level endon( "spawn_alcove_guys" );
	level endon( "convoy_has_passed" );
	volume = get_target_ent( "sewer_under_volume" );
	wait_till_flashed( volume );
	flag_set( "_stealth_spotted" );
}

wait_till_flashed( volume )
{	
	volume endon ( "flashed" );
	assert ( isdefined ( volume ) );
	
	while ( 1 )
	{
		level.player waittill( "grenade_fire", grenade, weaponName );
		if ( weaponname == "flash_grenade" )
		{
			tracker = spawn ("script_origin", (0,0,0));
			grenade thread track_grenade_origin( tracker, volume );
			grenade thread check_if_in_volume( tracker, volume );
		}
	}
}

check_if_in_volume( tracker, volume )
{
	self waittill ( "death" );
	if ( tracker istouching ( volume ) )
	{
		volume notify ( "flashed" );
	}
}

track_grenade_origin( tracker, volume )
{
	self endon ( "death" );
	volume endon ( "flashed" );
	while ( 1 )
	{
		tracker.origin = self.origin;
		wait .05;
	}
}

wait_for_convoy_to_pass()
{
	trigger_wait( "sewer_convoy_start", "script_noteworthy" );
	wait( 30 );
	level notify( "convoy_has_passed" );
	disable_trigger_with_noteworthy( "convoy_spotted_trigger" );
}

remove_helmetpop()
{
	if ( issubstr( self.classname, "prague_resistance" ) )
	{
		waittillframeend;
		self.hatmodel = undefined;		
	}
}

disable_mg()
{
	wait( 0.5 );
	
	if ( !isdefined( self.mgturret ) )
		return;
		
	foreach ( mg in self.mgturret )
	{
		mg setDefaultDropPitch( 0 );
		mg setmode( "manual" );
	}
}