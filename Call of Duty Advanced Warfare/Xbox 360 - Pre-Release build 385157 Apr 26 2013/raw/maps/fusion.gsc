#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\ss_util;
#include maps\fusion_code;
#include soundscripts\_audio;
#include soundscripts\_snd;
#include soundscripts\_audio_music;
#include maps\_shg_utility;
#include maps\fusion_utility;
#include maps\_lighting;

main()
{
	template_level( "fusion" );
	set_console_status();
	if (level.currentgen)
		LoadStartPointTransient("fusion_intro_tr");
	
	setup_precache();
	
	// Meltdown
	// June 3rd, 2056
	// Player
	// MARSOC
	// Bainbridge Island, WA
	intro_screen_create( "Meltdown", "June 3rd, 2056", "Player", "MARSOC", "Bainbridge Island, WA" );
	intro_screen_custom_func( ::fusion_intro_screen );
	
	// start points
	setup_start_points();
	
	init_level_flags();
	
	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "axis_street" );
	
	maps\_player_fastzip::main();
	maps\createart\fusion_art::main();
	maps\fusion_fx::main();
	
	maps\_weapon_pdrone::initialize();
		
	maps\fusion_precache::main();
	maps\fusion_anim::main();
	maps\_load::main();
	maps\fusion_aud::main();
	
	thread maps\fusion_lighting::main();
	
	maps\_drone_ai::init();
	
	maps\_chargeable_weapon::setup_charged_shot();
	
	//animscripts\traverse\boost::precache_boost_fx_npc();
	
	spawn_metrics_init_for_noteworthy("enemy_street_zip_rooftop");
	spawn_metrics_init_for_noteworthy("enemy_street_zip_rooftop_strafe");
	
	/#
	thread debug_magic();
	SetDevDvar("scr_autosave_debug", 1);
	thread debug_player_damage();
	#/
	
	add_hint_string( "hint_mt_fire_gun", &"FUSION_HINT_FIRE_GUN", ::should_break_use_mt_fire );
	add_hint_string( "hint_mt_fire_missiles", &"FUSION_HINT_FIRE_MISSILES", ::should_break_use_mt_missiles );
	add_hint_string( "hint_threat_grenade", &"FUSION_HINT_THREAT_GRENADE", ::should_break_use_threat_grenade );
	add_hint_string( "hint_directed_energy", &"FUSION_HINT_DIRECTED_ENERGY", ::should_break_use_directed_energy );
		
	thread gameplay_setup();
	
	maps\fusion_vo::main();

	thread handle_objectives();
	
	//player rig
	level.player_rig = spawn_anim_model( "player_rig" );
	level.player_rig Hide();
	
	//set dvar for X-Slice demo "In the interest of time"
	SetDvarIfUninitialized( "demo_itiot", 0 );

	// ensure the materialscriptparam is initialized	
	armapshade = getent( "armapshade", "targetname");
	armapshade SetMaterialScriptParam( 0.0, 0.0 );
	
	//setup portal scripting
	setup_portal_scripting();
	
	//adds functionality for steam, water and fire to play out of certain pipes
	common_scripts\_pipes::main();
	
}

setup_precache()
{
	PreCacheModel( "fus_cooling_tower_b_vista_dmg" );	
	PreCacheModel( "fus_cooling_tower_collapse_chunks" );
	PreCacheModel( "fus_cooling_tower_collapse_concrete_shattered" );
	PreCacheModel( "fus_cooling_tower_collapse_concrete_shattered2" );
	PreCacheModel( "fus_cooling_tower_collapse_street_collapse" );
	
	PreCacheModel( "vehicle_xh9_warbird_cloaked" );	
	PreCacheModel( "vehicle_mobile_cover" );
	if (level.nextgen)
		PreCacheModel( "weapon_javelin" );
	PreCacheModel( "npc_zipline101ft" );
	
	PreCacheModel( "vehicle_drone_02" );
	PreCacheModel( "vehicle_ind_utility_tractor_01_dstrypv" );
	
	PreCacheModel( "fus_sever_debris" );
	PreCacheModel( "fus_sever_debris_02" );
	PreCacheModel( "fus_pipes_elec_set_01_piece_01" );
	PreCacheModel( "fus_end_scene_rubble" );
	PreCacheModel( "vb_pmc" );
	PreCacheModel( "vb_pmc_dismember" );
	PreCacheModel( "rubble_combo_01" );
	PreCacheModel( "rubble_rock_chunk_01" );
	PreCacheModel( "viewhands_s1_pmc" );
	PreCacheModel( "worldhands_s1_pmc" );
	PreCacheModel( "vehicle_mobile_cover_dstrypv" );
	
	PreCacheModel( "fus_control_monitor_02_cinematic" );
	
	PreCacheShader( "cinematic" );
	
	PreCacheShellShock( "fusion_pre_collapse" );
	PreCacheShellShock( "fusion_collapse" );
	precacheshellshock( "slowview" );
	precacheshellshock( "fusion_slowview" );
	PreCacheShellShock( "zipline" );
	PrecacheNightvisionCodeAssets();
	
	precachestring ( &"FUSION_HINT_FIRE_GUN" );
	precachestring ( &"FUSION_HINT_FIRE_MISSILES" );
	precachestring ( &"FUSION_HINT_THREAT_GRENADE" );
	precachestring ( &"FUSION_HINT_DIRECTED_ENERGY" );
	
	PreCacheModel( "ind_streetlight_single_off_rig" );
	
	PreCacheModel( "vehicle_drone_02" );
	
	PreCacheModel( "npc_m160" );
	
	PreCacheModel( "fus_shelving_robot_01" );
	PreCacheModel( "fus_shelving_unit_cage_01" );
	PreCacheModel( "fus_shelving_unit_item_01" );
	
	PreCacheModel( "vehicle_v22_osprey_damaged_static_bladepiece_left" );
	
	PreCacheModel( "deployable_cover" );
	
	PreCacheModel( "fus_elevator_button_02" );
	
	PreCacheModel( "door_double_01_rigged" );
	PreCacheModel( "furniture_metal_door02_handleright" );
	PreCacheModel( "furniture_metal_door02_handleright_destroyed" );
	
	PreCacheModel( "breach_door_metal_right" );
	
	PreCacheRumble( "steady_rumble" );
	
	if ( level.currentgen )
	{
		// models that pop due to streaming in fixed with precache
		PreCacheModel( "fus_tower_lower_panel_01_dark" );
	}
}

setup_start_points()
{
	transients = [];
	if (level.currentgen)
		transients[0] = "fusion_intro_tr";
	
	add_start( "fly_in_animated",		::start_intro_fly_in,		"",	::intro_fly_in_animated, transients);
//	add_start( "fly_in_animated_part2",	::start_intro_fly_in_part2,	"",	::intro_fly_in_animated_part2, transients);
	add_start( "courtyard",				::start_courtyard,			"",	::courtyard, transients);
	
	//interior
	add_start( "security_room", 		::start_security_room, 			"", undefined, transients);
	
	if (level.currentgen)
		transients[0] = "fusion_middle_tr";
	
	add_start( "lab", 					::start_lab, 					"", undefined, transients);
	add_start( "reactor_room", 			::start_reactor, 				"", undefined, transients);
	add_start( "reactor_room_exit", 	::start_reactor_exit, 			"", undefined, transients);
	
	if (level.currentgen)
		transients[0] = "fusion_outro_tr";
	
	add_start( "turbine_room", 			::start_turbine_room, 			"", undefined, transients);
	add_start( "control_room_entrance", ::start_control_room_entrance, 	"", undefined, transients);
	add_start( "control_room",			::start_control_room,			"", undefined, transients);
	
	add_start( "control_room_exit",		::start_control_room_exit,	"",	::control_room_exit, transients);
	add_start( "cooling_tower",			::start_cooling_tower,		"",	::cooling_tower, transients);
}

init_level_flags()
{
	//init flags here
	flag_init( "intro_screen_done" );
	flag_init( "intro_squad_helis_start" );
	flag_init( "start_heli_fly" );
	flag_init( "ready_zip" );
	flag_init( "flag_player_zip_started" );
	flag_init( "flag_combat_zip_rooftop_start" );
	flag_init( "flag_burke_zip" );
	flag_init( "flag_combat_zip_rooftop_complete" );
	flag_init( "player_can_zip" );
	flag_init( "street_combat_start" );
	flag_init( "flag_rooftop_strafe" );
	flag_init( "flag_player_cleared_rooftop" );
	flag_init( "sun_shad_off_zip" );
	flag_init( "player_fly_in_done" );
	flag_init( "burke_fastzip_done" );
	flag_init( "flag_squad_heli_2_unload" );
	flag_init( "flag_squad_heli_01_zip_complete" );
	flag_init( "flag_rpg_at_heli" );
	flag_init( "flag_player_enters_mobile_turret" );
	flag_init( "flag_player_starts_entering_mobile_turret" );
	flag_init( "flag_m_turret_dead" );
	flag_init( "flag_walker_tank_on_mount" );
	flag_init( "flag_player_picked_up_smaw" );
	flag_init( "flag_walker_death_anim_start" );
	flag_init( "flag_walker_destroyed" );
	flag_init( "walker_trophy_1" );
	flag_init( "walker_trophy_2" );
	flag_init( "walker_damaged" );
	flag_init( "security_room_player_start" );
	flag_init( "lab_player_start" );
	flag_init( "reactor_player_start" );
	flag_init( "reactor_exit_player_start" );
	flag_init( "joker_placing_turbine_elevator_cover" );
	flag_init( "turbine_room_player_start" );
	flag_init( "control_room_entrance_player_start" );
	flag_init( "start_itiot" );
	flag_init( "evacuation_started" );
	flag_init( "flag_shut_down_reactor_failed" );
	flag_init( "tower_debris" );
	flag_init( "hangar_retreat_done" );
	flag_init( "evacuation_first_drones_down" );
	flag_init( "player_start_control_room" );
	flag_init( "start_control_room_exit_lighting" );
	flag_init( "player_start_cooling_tower" );
	flag_init( "sun_shad_fly_in" );
	flag_init( "tower_knockback" );
	flag_init( "extraction_chopper_move_from_explosion" );
	flag_init( "objective_on_extraction_chopper" );
	flag_init( "off_fire_light" );
	flag_init( "hangar_exit_explosion" );
	flag_init( "mobile_turret_health_1" );
	flag_init( "mobile_turret_health_2" );
	flag_init( "mobile_turret_health_3" );
	flag_init( "mobile_turret_health_4" );
	flag_init( "play_ending" );
	flag_init( "directed_energy_weapon_used" );
	
	//objective flags
	flag_init( "update_obj_pos_walker" );
	flag_init( "update_obj_pos_security_entrance" );
	flag_init( "update_obj_pos_security_elevator" );
	flag_init( "update_obj_pos_elevator_descent" );
	flag_init( "update_obj_pos_lab_follow_joker" );
	flag_init( "update_obj_pos_lab_follow_burke" );
	flag_init( "update_obj_pos_lab_follow_carter" );
	flag_init( "update_obj_pos_reactor_1" );
	flag_init( "update_obj_pos_turbine_elevator_button" );
	flag_init( "update_obj_pos_turbine_elevator_ascent" );
	flag_init( "update_obj_pos_turbine_room_1" );
	flag_init( "update_obj_pos_control_room_door" );
	flag_init( "update_obj_pos_control_room_explosion" );
	flag_init( "update_obj_pos_control_room_console" );
	flag_init( "update_obj_pos_control_room_using_console" );
	flag_init( "update_obj_pos_control_room_exit_1" );
	
	interior_init_level_flags();
}

interior_init_level_flags()
{
	flag_init( "interior_allies" );
	
	flag_init( "burke_facing_elevator" );
	
	flag_init( "lab_cqb" );
	flag_init( "start_lab_traversals" );
	
	flag_init( "reactor_room_reveal_allies_advance" );
	
	flag_init( "control_room_run_prep" );
	
	flag_init( "control_room_explosion" );
	flag_init( "control_room_console_enable" );
	flag_init( "control_room_scene_ready" );
	flag_init( "control_room_scene" );
	
	flag_init( "shutdown_reactor_failed" );
	
	//VO
	flag_init( "vo_security_room_elevator_access" );
	flag_init( "vo_security_room_elevator_open" );
	flag_init( "vo_lab_elevator_slide_complete" );
	flag_init( "vo_reactor_gogogo" );
	flag_init( "vo_reactor_open_airlock" );
	flag_init( "vo_reactor_entrance" );
	flag_init( "vo_turbine_elevator_near" );
	flag_init( "vo_turbine_elevator_ready" );
	flag_init( "vo_turbine_elevator" );
	flag_init( "vo_turbine_room_entrance" );
	flag_init( "vo_turbine_explosion" );
	flag_init( "vo_control_hall_door_stack" );
	flag_init( "vo_control_hall_door_kicked" );
	flag_init( "vo_control_room_explosion" );
	flag_init( "vo_control_room_scene" );
	
}

should_break_use_mt_fire()
{
	if ( !isDefined( level.player.drivingVehicleAndTurret ) || level.player AttackButtonPressed() )
	{
		return true;
	}
	return false;
}

should_break_use_mt_missiles()
{
	if ( !isDefined( level.player.drivingVehicleAndTurret ) || level.player FragButtonPressed() )
	{
		return true;
	}
	return false;
}

should_break_use_threat_grenade()
{
	if ( level.player buttonpressed ( "BUTTON_LSHLDR" ) || level.player buttonpressed ( "BUTTON_RSHLDR" ) )
	{
		return true;
	}
	return false;
}

should_break_use_directed_energy()
{
	if ( level.player buttonpressed ( "DPAD_LEFT" ) || flag( "directed_energy_weapon_used" ) )
	{
		return true;
	}
	return false;
}

///////////////////////// INTRO FLY-IN ///////////////////////////////
start_intro_fly_in()
{
	setup_allies();
	snd_message("start_intro_fly_in");
	snd_music_message( "mus_fusion_intro" );
	
	//setting lighting settings to fix "previous checkpoint" bug
	setsaveddvar("r_disablelightsets", 0 );
	level.player lightsetforplayer("fusion_helicopter_intro");
	setsaveddvar("r_tonemapexposure", 8 );
}

intro_fly_in_animated()
{
	thread fly_in_sequence();
	thread show_hide_plant_vista_intro();
	//thread squad_fly_in();
	thread setup_ally_squad();
	thread road_battle_setup();
//	thread roof_fx();
	
	// fall through to part 2
}

	
///////////////////////// INTRO FLY-IN PART 2 ///////////////////////////////
// note that this is run if you do the debug start
start_intro_fly_in_part2()
{
	snd_message("start_intro_fly_in_part2");
	thread setup_ally_squad();
	thread road_battle_setup();
	//thread roof_fx();

	//messages
	flag_set( "sun_shad_fly_in" );
	flag_set( "intro_squad_helis_start" );
	level notify("hatch_door_open");	
	
	
	//lighting
	thread maps\fusion_lighting::hatch_door_lightgrid_off();
	thread maps\fusion_lighting::fusion_intro_dof();
	thread maps\fusion_lighting::hatch_door_vision();
	thread maps\fusion_lighting::hatch_door_veil();
	thread maps\fusion_lighting::hatch_door_push_fog_out();
	thread vision_set_fog_changes("fusion_helicopter_open",0);
	
	if ( IsUsingHDR() )
		setsavedDvar( "r_veilStrength", .16);
	
	thread flag_set_delayed( "street_combat_start", 20 );
	
	thread squad_heli_zip();
	thread fly_in_ambient_heli_squad();
	
	level.warbird_a = spawn_vehicle_from_targetname( "blackhawk" );
	level.warbird_a.animname = "warbird_a";
	level.warbird_a.no_anim_rotors = true;
	//PlayFxOnTag(getfx("light_red_strobe"), level.warbird_a, "TAG_TURRET_ZIPLINE_FL");
	
	spawn_intro_heroes();
	spawn_intro_pilots();
	
	player_rig = spawn_player_anim_rig();
	level.player setup_player_for_scene();
	level.player PlayerLinkToDelta( player_rig, "tag_player", 0.75, 50, 30, 15, 45, true );
	
	org = getstruct( "org_flyin", "targetname" );
	
	org anim_first_frame_solo( level.warbird_a, "fly_in_part2" );
	
	warbird_a_guys = [ player_rig, level.burke, level.joker, level.carter, level.copilot_intro, level.pilot_intro ];
	level.warbird_a anim_first_frame( warbird_a_guys, "fly_in_part2", "tag_guy0" );
	foreach( guy in warbird_a_guys )
	{
		guy LinkTo( level.warbird_a, "tag_guy0" );
	}
	
	wait 2.5;
	
	thread finish_fly_in_sequence( org, level.warbird_a, player_rig );
	
	wait 54;
	
	flag_set( "flag_combat_zip_rooftop_start" );
	
	flag_wait( "flag_combat_zip_rooftop_complete" );
	
	flag_set( "ready_zip" );
	
	activate_trigger_with_targetname( "trig_move_squad_from_heli" );

}

intro_fly_in_animated_part2()
{
	flag_wait( "player_fly_in_done" );
	delayThread(3, ::autosave_by_name);
}


////////////////////////// COURTYARD ///////////////////////////
start_courtyard()
{
	snd_message("start_courtyard");
//	
//	level.burke = spawn_targetname("hero_burke");
//	level.joker = spawn_targetname("hero_joker");
//	level.carter = spawn_targetname("hero_carter");
	setup_allies( "checkpoint_courtyard" );
	teleport_to_scriptstruct( "checkpoint_courtyard" );
	
	level.carter disable_ai_color();

	level.carter goto_node( "node_carter_zip_rally", false );
	
//	level.burke deletable_magic_bullet_shield();
//	level.joker deletable_magic_bullet_shield();
//	level.carter deletable_magic_bullet_shield();
	
//	teleport_to_scriptstruct( "checkpoint_courtyard" );
	
	thread rooftop_slide();
	thread hide_water();
	thread allies_rally_init();
	thread burke_rally_init();
	thread setup_ally_squad();
	thread road_battle_setup();	
	thread street_hanging_pipes_anim();
	thread show_hide_plant_vista();
	
	waittillframeend;
	
	flag_set( "ready_zip" );
	flag_set( "burke_fastzip_done" );
	flag_set( "player_fly_in_done" );
	flag_set( "flag_ambient_explosions_start" );
	flag_set( "flag_player_zip_started" );
	flag_set( "flag_rooftop_strafe" );
	flag_set( "flag_player_cleared_rooftop" );
	flag_set( "sun_shad_off_zip" );
	flag_set( "street_combat_start" );
}

courtyard()
{
	thread courtyard_ambient_explosions();  //temporary turn off ambient explosion
	thread evacuation_kiosk_movie();
	enemy_walker();
//	reactor_entrance_rally();
	thread demo_skip_forward();

	wait 0.05;
	autosave_by_name();
}

/////////////////////////// SECURITY ROOM ///////////////////////
start_security_room()
{
	snd_message("start_security_room");
	move_player_to_start("security_room_player_start");
	setup_allies( "security_room_player_start" );
	flag_set( "security_room_player_start" );
	flag_set( "interior_allies" );
	MUS_play( "london_uav", 0 );
}

/////////////////////////// LAB ///////////////////////
start_lab()
{
	snd_message("start_lab");
	move_player_to_start("lab_player_start");
	flag_set( "vo_lab_elevator_slide_complete" );
	setup_allies( "lab_player_start" );
	flag_set( "lab_player_start" );
	flag_set( "interior_allies" );
	flag_set( "lab_cqb" );
	flag_set( "start_lab_traversals" );
	MUS_play( "london_uav", 0 );
}

/////////////////////////// REACTOR ///////////////////////
start_reactor()
{
	snd_message("start_reactor");
	move_player_to_start("reactor_player_start");
	setup_allies( "reactor_player_start" );
	flag_set( "interior_allies" );
	flag_set( "lab_cqb" );
	flag_set( "reactor_player_start" );
	activate_trigger_with_targetname( "airlock_color_trigger" );
}

/////////////////////////// REACTOR EXIT ///////////////////////
start_reactor_exit()
{
	snd_message("start_reactor_exit");
	move_player_to_start("reactor_exit_player_start");
	setup_allies( "reactor_exit_player_start" );
	flag_set( "interior_allies" );
	flag_set( "reactor_exit_player_start" );
}

/////////////////////////// TURBINE ROOM ///////////////////////
start_turbine_room()
{
	snd_message("start_turbine_room");
	move_player_to_start("turbine_room_player_start");
	setup_allies( "turbine_room_player_start" );
	level.turbine_room_elevator_ascent_time = 0;
	flag_set( "interior_allies" );
	flag_set( "elevator_ascend" );
	flag_set( "turbine_room_player_start" );
	flag_set( "turbine_elevator_enter" );
	
	//portal on
	flag_set("portal_on_turbine_room_flag");
	wait 0.05;
	flag_clear("portal_on_turbine_room_flag");
}

/////////////////////////// CONTROL ROOM ENTRANCE ///////////////////////
start_control_room_entrance()
{
	snd_message("start_control_room_entrance");
	move_player_to_start("control_room_entrance_player_start");
	flag_set( "control_room_entrance_player_start" );
	setup_allies( "control_room_entrance_player_start" );
	flag_set( "interior_allies" );
	flag_set( "control_room_run_prep" );
	flag_set( "control_room_run_approach" );
	vision_set_fog_changes( "fusion_control_room_dark", .5 );
}

/////////////////////////// CONTROL ROOM ///////////////////////
start_control_room()
{
	snd_message("start_control_room");
	move_player_to_start("control_room_player_start");
//	flag_set( "control_room_player_start" );
	setup_allies( "control_room_player_start" );
	flag_set( "interior_allies" );
	vision_set_fog_changes( "fusion_control_room_dark", .5 );
	setsaveddvar("r_disablelightsets", 0 );
	level.player lightsetforplayer("fusion_screen_control_room_lightset");
	thread control_room_scene_player( getstruct( "control_room_burke_position", "targetname" ) );
	thread control_room_scene();
	thread control_room_screens();
	//explosion happened
	flag_set( "control_room_explosion" );
	flag_set( "control_room_console_enable" );
	array_call( GetEntArray( "control_room_doors", "targetname" ), ::delete );
	control_room_door_clip = getent( "control_room_door_clip", "targetname" );
	if( IsDefined( control_room_door_clip ) )
		control_room_door_clip delete();
}

/////////////////////////// CONTROL ROOM EXIT ///////////////////////
start_control_room_exit()
{
	snd_message("start_control_room_exit");
	move_player_to_start( "itiot_player_start" );
	level.player SetPlayerAngles( level.player.angles + (7, 0, 0) ); //tilt view down slightly
	thread evacuation_kiosk_movie();
	
	flag_set( "flag_obj_01_pos_update_02" );
	flag_set( "flag_shut_down_reactor_failed" );
	flag_set( "player_start_control_room" );
	flag_set( "evacuation_started" );
	flag_set( "start_control_room_exit_lighting" );
	
	//portal on
	flag_set("portal_on_control_room_flag");
	wait 0.05;
	flag_clear("portal_on_control_room_flag");
}
 
control_room_exit()
{
	//flag_set( "player_start_control_room" );
	flag_wait( "flag_shut_down_reactor_failed" );
	snd_message("start_pre_loading_bay");
	flag_set( "player_start_control_room" );
	thread burke_moment();
	thread dialog_meltdown();
	//thread ambient_explosions();  //removing this to be spawned in fusion_fx.gsc
	thread reaction_explosions();
	thread reaction_ai();
	wait 0.5;
	//thread cooling_tower_collapse();
	thread combat_hangar();
	
	autosave_by_name();
}


////////////////////////// COOLING TOWER //////////////////////////
start_cooling_tower()
{
	snd_message("start_cooling_tower");
	move_player_to_start();
	flag_set( "player_start_cooling_tower" );
	flag_set( "evacuation_started" );
	flag_set( "show_collapse_tower" );
	flag_set( "stop_ambient_explosions" );
	flag_set( "ct_final_retreat" );
	
	getent( "retreat_gaz_01", "targetname" ) delete(); //remove old gaz
	
	thread vision_set_fog_changes("fusion_cooling_towers",0);
	
	spawner = getent( "burke", "targetname" );
	level.burke = spawner spawn_ai( true, true );
	level.burke.animname = "burke";
//	level.burke thread magic_bullet_shield();
	level.burke forceTeleport( level.player.origin, level.player.angles );
	level.burke SetGoalPos( level.burke.origin );
	
	spawner = getent( "carter", "targetname" );
	level.carter = spawner spawn_ai( true, true );
	level.carter.animname = "carter";
//	level.carter thread magic_bullet_shield();
	level.carter forceTeleport( level.player.origin, level.player.angles );
	level.carter SetGoalPos( level.carter.origin );
	
//	spawner = getent( "thompson", "targetname" );
//	level.thompson = spawner spawn_ai( true );
//	level.thompson.animname = "thompson";
////	level.thompson thread magic_bullet_shield();
//	level.thompson forceTeleport( level.player.origin, level.player.angles );
//	level.thompson SetGoalPos( level.thompson.origin );
	
	spawner = getent( "joker", "targetname" );
	level.joker = spawner spawn_ai( true, true );
	level.joker.animname = "joker";
//	level.joker thread magic_bullet_shield();
	level.joker forceTeleport( level.player.origin, level.player.angles );
	level.joker SetGoalPos( level.joker.origin );

	//thread cooling_tower_collapse();
	thread dialog_collapse();
	
	activate_trigger_with_targetname( "allies_move_to_tower" );
}

cooling_tower()
{
}

setup_allies( location )
{
	//burke
	level.burke = getent( "hero_burke", "targetname" ) spawn_ai( true, true );
	level.burke.animname = "burke";
//	level.burke magic_bullet_shield( true );
	//level.burke enable_cqbwalk();
	
	//joker
	level.joker = getent( "hero_joker", "targetname" ) spawn_ai( true, true );
	level.joker.animname = "joker";
//	level.joker magic_bullet_shield( true );
	//level.joker enable_cqbwalk();
	
	//carter
	level.carter = getent( "hero_carter", "targetname" ) spawn_ai( true, true );
	level.carter.animname = "carter";
//	level.carter magic_bullet_shield( true );
	//level.carter enable_cqbwalk();
	
//	flag_set( "interior_allies" );
	
	if( IsDefined( location ) )
	{
		dest = getstruct( location, "targetname" );
		
		if( !IsDefined( dest ) )
			dest = getstruct( location, "script_noteworthy" );
		
		level.burke teleport_ent( dest );
		level.joker teleport_ent( dest );
		level.carter teleport_ent( dest );
		
		if( location == "lab_player_start" )
		{
			level.burke thread laboratory_start_idle();
			level.joker thread laboratory_start_idle();
			level.carter thread laboratory_start_idle();
		}
		if( location == "reactor_player_start" )
		{
			level.burke enable_cqbwalk();
			level.joker enable_cqbwalk();
			level.carter enable_cqbwalk();
			
			level.burke.moveplaybackrate = 1.1;
			level.joker.moveplaybackrate = 1.1;
			level.carter.moveplaybackrate = 1.1;
		}
		
		if( location != "turbine_room_player_start" && 
		   location != "control_room_entrance_player_start" && 
		   location != "control_room_player_start" && 
		   location != "control_room_exit_player_start" && 
		   location != "cooling_tower_player_start" )
		{
			thread deployable_cover_think();
		}
	}
	else
	{
		thread deployable_cover_think();
	}
}

deployable_cover_think()
{
	
//	wait 3;
	deployable_cover = Spawn( "script_model", level.joker GetTagOrigin( "j_SpineUpper" ) + (0, 0, 0) );
	deployable_cover.angles = level.joker GetTagAngles( "j_SpineUpper" ) + (0, 0, 0);
	deployable_cover.animname = "deployable_cover";
	deployable_cover SetModel( "deployable_cover" );
	deployable_cover SetAnimTree();
	deployable_cover anim_first_frame_solo( deployable_cover, "deployable_cover_closed_idle" );
	deployable_cover linkto( level.joker, "j_SpineUpper" );
	
	flag_wait( "joker_placing_turbine_elevator_cover" );
	deployable_cover delete();
}

handle_objectives()
{
	waittillframeend;
	
	set_completed_objective_flags();
	
	objectives();
}

set_completed_objective_flags()
{
	if ( is_default_start() )
		return;

	start = level.start_point;
	if(start == "fly_in_animated")
		return;
	
	if(start == "fly_in_animated_part2")
		return;
	
	if(start == "courtyard")
		return;
	
	flag_set( "update_obj_pos_walker" );
	flag_set( "update_obj_pos_security_entrance" );
	
	if(start == "security_room")
		return;
	
	flag_set( "update_obj_pos_security_room" );
	flag_set( "update_obj_pos_security_elevator_burke" );
	flag_set( "update_obj_pos_security_elevator" );
	flag_set( "update_obj_pos_elevator_descent" );
	flag_set( "update_obj_pos_lab_follow_joker" );
	
	if(start == "lab")
		return;
	
	flag_set( "update_obj_pos_lab_follow_burke" );
	flag_set( "update_obj_pos_lab_follow_carter" );
	
	if(start == "reactor_room")
		return;
	
	flag_set( "update_obj_pos_reactor_1" );
	flag_set( "update_obj_pos_reactor_2" );
	flag_set( "update_obj_pos_reactor_exit" );
	flag_set( "update_obj_pos_reactor_storage_1" );
	flag_set( "update_obj_pos_reactor_storage_2" );
	flag_set( "update_obj_pos_turbine_elevator" );
	
	if(start == "reactor_room_exit")
		return;
	
	flag_set( "update_obj_pos_turbine_elevator_button" );
	flag_set( "update_obj_pos_turbine_elevator_ascent" );
	
	if(start == "turbine_room")
		return;
	
	flag_set( "update_obj_pos_turbine_room_1" );
	flag_set( "update_obj_pos_turbine_room_exit" );
	
	if(start == "control_room_entrance")
		return;
	
	flag_set( "update_obj_pos_control_room_door" );
	flag_set( "update_obj_pos_control_room_explosion" );
	flag_set( "update_obj_pos_control_room_console" );
	
	if(start == "control_room")
		return;
	
	flag_set( "update_obj_pos_control_room_using_console" );
	flag_set( "update_obj_pos_control_room_exit_1" );
	flag_set( "update_obj_pos_control_room_exit_2" );
	flag_set( "update_obj_pos_hangar_entrance" );
	
	if(start == "control_room_exit")
		return;
	
	if(start == "cooling_tower")
		return;
	
	AssertMsg( "Start point " + start + " isn't supported" );
	
}

//////////INITIALIZE PORTAL HANDLERS//////////
setup_portal_scripting()
{
	//portal handling for reactor room
	thread handle_fusion_portal_groups_toggle("portal_grp_reactor_room", "portal_on_reactor_room_flag", "portal_off_reactor_room_flag");
	
	//portal handling for turbine room in elevator shaft
	flag_init("portal_on_turbine_room_flag");
	thread handle_fusion_portal_groups_on("portal_grp_turbine_room", "portal_on_turbine_room_flag", "endPortalTurbineRoom", "turbine_room"); //FIXME: temp fix to get level working with portal issue.
	
	//portal handling for control room exit
	flag_init("portal_on_control_room_flag");
	thread handle_fusion_portal_groups_toggle("portal_grp_control_room", "portal_on_control_room_flag", "portal_off_control_room_flag");
}

//////////PORTAL FUNCTION TO TURN ON PORTAL GROUP - 1 TRIGGER//////////
handle_fusion_portal_groups_on(portalGroup, scriptFlag, killString, checkpoint)
{
	
	level.player endon("death");
	level endon("missionfailed");
	if (IsDefined(killString) && IsString(killString))
		level endon(killString);
	
	portalG = GetEnt(portalGroup, "targetname");
	portalG EnablePortalGroup(false);   //turn off portal group
	
	while(true)
	{
		flag_wait(scriptFlag);
		/#
//		IPrintLn("Turning On Portal Group");
		#/
		portalG EnablePortalGroup(true);   //turn on portal once we hit the trigger
		wait 0.05;
		if (IsDefined(killString))
			level notify(killString);
	}
}

//////////PORTAL FUNCTION TO TURN ON/off PORTAL GROUP. USES TWO SCRIPT FLAGS(TWO TRIGGER BOXES)//////////
handle_fusion_portal_groups_toggle(portalGroup, scriptOnFlag, scriptOffFlag)
{
	level.player endon("death");
	level endon ("missionfailed");
	
	//initialize portal off
	pGroup = getent(portalGroup, "targetname");
	pGroup EnablePortalGroup(false);
	
	while(true)
	{	
		flag_wait(scriptOnFlag);
		/#
//		IPrintLn("Turning on portal");
		#/
		pGroup EnablePortalGroup(true);
		wait 0.05;
		
		flag_wait(scriptOffFlag);
		/#
//		IPrintLn("Turning off portal");
		#/
		pGroup EnablePortalGroup(false);
		wait 0.05;	
	}
}

/#
debug_player_damage()
{
	while(true) {
		level.player waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
		PrintLn("player damage: " + safe_string(amount) + " attacker " + safe_entnum(attacker) + " point " + safe_string(point) + " type: " + safe_string(type) + "weapon" + safe_string(weaponName));
	}
}

safe_entnum(e)
{
	if(IsDefined(e))
		return e GetEntNum();
	return -1;
}

safe_string(s)
{
	if(IsDefined(s))
		return "" + s;
	return "(undefined)";
}
#/
