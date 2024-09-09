#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include soundscripts\_audio;
#include soundscripts\_audio_zone_manager;
#include soundscripts\_audio_mix_manager;
#include soundscripts\_audio_music;
#include soundscripts\_audio_dynamic_ambi;
#include soundscripts\_audio_vehicle_manager;
#include soundscripts\_snd;
#include soundscripts\_snd_common;
#include soundscripts\_snd_filters;
#include soundscripts\_audio_reverb;
#include soundscripts\_audio_whizby;
#include maps\_shg_debug;

main()
{
	config_system();
	init_audio_flags();
	init_globals();
	launch_threads();
	launch_loops();
	create_level_envelop_arrays();
	register_trigger_callbacks();
	add_note_track_data();
	precache_presets();
	setup_pcap_vo();
	register_snd_messages();
	
	// Comment this out before checking in (TODO: use dvars to enable this).
	/#
	thread start_audio_debugging();
	#/
}	
	
/********************************************************************
	Register & Handle Snd Messages.
********************************************************************/
register_snd_messages()
{
	// CHECKPOINT HANDLERS ////////////////////////////////////////////////////////////////////////////////
	snd_register_message( "start_intro_fly_in",					::start_intro_fly_in );
	snd_register_message( "start_intro_fly_in_part2",			::start_intro_fly_in_part2 );
	snd_register_message( "start_courtyard",					::start_courtyard );
	snd_register_message( "start_security_room",				::start_security_room );
	snd_register_message( "start_lab",							::start_lab );
	snd_register_message( "start_reactor",						::start_reactor );
	snd_register_message( "start_reactor_exit",					::start_reactor_exit );
	snd_register_message( "start_turbine_room",					::start_turbine_room );
	snd_register_message( "start_control_room_entrance",		::start_control_room_entrance );
	snd_register_message( "start_control_room",					::start_control_room );
	snd_register_message( "start_control_room_exit",			::start_control_room_exit );
	snd_register_message( "start_cooling_tower",				::start_cooling_tower );
	
	// AWESOME TRIGGER HANDLERS ///////////////////////////////////////////////////////////////////////////
	snd_register_message( "snd_zone_handler",					::snd_zone_handler );

	// MUSIC MESSAGE HANDLER //////////////////////////////////////////////////////////////////////////////
	snd_register_message( "snd_music_handler",					::snd_music_handler );
	
	// EVENT HANDLERS /////////////////////////////////////////////////////////////////////////////////////
		
	// AREA: INTRO FLIGHT ///////////////////////////////////
	
	// WARBIRD FLYIN
	snd_register_message( "player_warbird_spawn",				::player_warbird_spawn );
	snd_register_message( "start_hologram_audio",				::start_hologram_audio );
	snd_register_message( "start_burke_foley",					::start_burke_foley );
	snd_register_message( "start_intro_npc_foley",              ::start_intro_npc_foley );
	snd_register_message( "decloak_intro_helicopter",			::decloak_intro_helicopter );
	snd_register_message( "intro_flight_missiles_fire",			::intro_flight_missiles_fire );
	snd_register_message( "missile_hit_warbird_b",				::missile_hit_warbird_b );
	snd_register_message( "warbird_b_crash_tower",				::warbird_b_crash_tower );	
	snd_register_message( "rooftop_strafe_start",				::rooftop_strafe_start );
	
	// FAST ZIP
	snd_register_message( "fastzip_turret_switch_to",			::fastzip_turret_switch_to );
	snd_register_message( "fastzip_turret_switch_complete",		::fastzip_turret_switch_complete );
	snd_register_message( "fastzip_turret_fire",				::fastzip_turret_fire );	
	snd_register_message( "fastzip_turret_putaway",				::fastzip_turret_putaway );	
	snd_register_message( "fastzip_hit_the_ground",				::fastzip_hit_the_ground );		
	snd_register_message( "fastzip_rappel",						::fastzip_rappel );	
	snd_register_message( "player_zipped_down",					::player_zipped_down );	
	
	// AREA: COURTYARD //////////////////////////////////////
	
	// AMBIENT COURTYARD ELEMENTS
	snd_register_message( "snd_start_ambient_jet",				::start_ambient_jet );
	snd_register_message( "courtyard_ambient_bullet_impact",	::courtyard_ambient_bullet_impact );

	// WARBIRD MOBILE TURRET DROPOFF
	snd_register_message( "warbird_mobile_turret_dropoff",		::warbird_mobile_turret_dropoff );
	snd_register_message( "walker_mobile_turret_dropoff",		::walker_mobile_turret_dropoff );
	snd_register_message( "player_warbird_flyout",				::player_warbird_flyout );
	
	// MOBILE COVER DRONE PAIRED ANIM
	snd_register_message( "cvrdrn_paired_anim_start",			::cvrdrn_paired_anim_start );
	snd_register_message( "cvrdrn_paired_anim_explo",			::cvrdrn_paired_anim_explo );
	
	// BUILDING EXPLOSIONS
	snd_register_message( "building_explode",					::building_explode );
	snd_register_message( "spawn_walker_mobile_turret_deploy",	::spawn_walker_mobile_turret_deploy );
	snd_register_message( "spawn_ally_walker_02",				::spawn_ally_walker_02 );
	snd_register_message( "street_wall_1_explode",				::street_wall_1_explode );
	
	// PLAYER WALKER
	snd_register_message( "player_enter_walker",				::player_enter_walker);
	snd_register_message( "player_exit_walker",					::player_exit_walker);
	snd_register_message( "player_enter_walker_anim",			::player_enter_walker_anim);
	snd_register_message( "player_exit_walker_anim",   			::player_exit_walker_anim);
	snd_register_message( "player_mobile_turret_explo",			::player_mobile_turret_explo );
	
	//PLAYER WALKER MISSILE TURRET
	snd_register_message( "x4_walker_hud_target_aquired",		::x4_walker_hud_target_aquired );
	snd_register_message( "x4_walker_hud_missile_launched",		::x4_walker_hud_missile_launched );
	snd_register_message( "x4_walker_fire_missile",				::x4_walker_fire_missile );
	
	// NPC Walker
	snd_register_message( "mobile_turret_missile",				::mobile_turret_missile);
	
	// MI17 COURTYARD SPAWN
	snd_register_message( "courtyard_mi17_spawn_01",			::courtyard_mi17_spawn_01 );
	snd_register_message( "courtyard_mi17_spawn_02",			::courtyard_mi17_spawn_02 );
	
	// KVA TITAN
	snd_register_message( "titan_init",							::titan_init );
	snd_register_message( "titan_enter",						::titan_enter );
	snd_register_message( "titan_missile",						::titan_missile );
	snd_register_message( "trophy_system_explosion",			::trophy_system_explosion );
	snd_register_message( "titan_take_damage_from_smaw",		::titan_take_damage_from_smaw );
	snd_register_message( "titan_death",						::titan_death );
	
	// ITIOT
	snd_register_message( "itiot_fade_out",						::itiot_fade_out );
	snd_register_message( "itiot_fade_in",						::itiot_fade_in );
	
	// AREA: SECURITY ROOM
	
	snd_register_message( "start_elevator_zone_audio",			::start_elevator_zone_audio );
	snd_register_message( "start_dead_guy_foley",				::start_dead_guy_foley );
	snd_register_message( "Sec_Room_Move_To_Elevator",			::Sec_Room_Move_To_Elevator );
	snd_register_message( "Sec_Room_Attach_To_Elevator",		::Sec_Room_Attach_To_Elevator );
	snd_register_message( "Sec_Room_Elevator_Open",				::Sec_Room_Elevator_Open );
	snd_register_message( "start_burke_elevator_slide",			::start_burke_elevator_slide );
	snd_register_message( "start_player_elevator_slide",		::start_player_elevator_slide );
	

	// AREA: REACTOR ROOM
	
	snd_register_message( "start_airlock_anim_notetracks",		::start_airlock_anim_notetracks  );
	snd_register_message( "start_reactor_airlock_open",			::start_reactor_airlock_open  );
	snd_register_message( "start_reactor_burke_attack",			::start_reactor_burke_attack  );
	
	snd_register_message( "crane_mach_mvmnt_start",				::crane_mach_mvmnt_start  );
	snd_register_message( "crane_mach_mvmnt_stop",				::crane_mach_mvmnt_stop  );
	snd_register_message( "crane_claw_mvmnt_start",				::crane_claw_mvmnt_start  );
	snd_register_message( "crane_claw_mvmnt_stop",				::crane_claw_mvmnt_stop  );
	snd_register_message( "crane_claw_drop_start",				::crane_claw_drop_start  );
	snd_register_message( "crane_claw_drop_stop",				::crane_claw_drop_stop  );
	snd_register_message( "crane_claw_rise_start",				::crane_claw_rise_start  );
	snd_register_message( "crane_claw_rise_stop",				::crane_claw_rise_stop  );
	snd_register_message( "crane_claw_crate_grab",				::crane_claw_crate_grab  );
	snd_register_message( "crane_claw_crate_release",			::crane_claw_crate_release  );
	
	snd_register_message( "reactor_bot_drive_shelf_start",		::reactor_bot_drive_shelf_start  );
	snd_register_message( "reactor_bot_drive_shelf_stop",		::reactor_bot_drive_shelf_stop  );
	snd_register_message( "reactor_bot_drive_self_start",		::reactor_bot_drive_shelf_stop  );
	snd_register_message( "reactor_bot_drive_self_stop",		::reactor_bot_drive_shelf_stop  );
	snd_register_message( "reactor_bot_turn_shelf",				::reactor_bot_turn_shelf  );
	snd_register_message( "reactor_bot_turn_self",				::reactor_bot_turn_shelf  );
	snd_register_message( "reactor_bot_shelf_pickup",			::reactor_bot_shelf_pickup  );
	snd_register_message( "reactor_bot_shelf_drop",				::reactor_bot_shelf_drop  );
	snd_register_message( "reactor_bot_elevator_start_lp",		::reactor_bot_elevator_start_lp  );
	snd_register_message( "reactor_bot_elevator_stop_lp",		::reactor_bot_elevator_stop_lp  );
	snd_register_message( "reactor_bot_initial_elevator_start",	::reactor_bot_initial_elevator_start  );
	snd_register_message( "reactor_bot_initial_elevator_stop",	::reactor_bot_initial_elevator_stop  );
	snd_register_message( "reactor_bot_final_elevator_start",	::reactor_bot_final_elevator_start  );
	snd_register_message( "reactor_bot_final_elevator_stop",	::reactor_bot_final_elevator_stop  );
	snd_register_message( "reactor_bot_elevator_open",			::reactor_bot_elevator_open  );
	
	snd_register_message( "start_reactor_zone_audio",			::start_reactor_zone_audio );
	
	// AREA: TURBINE ELEVATOR
	
	snd_register_message( "disable_turbine_elevator_trigger",   ::disable_turbine_elevator_trigger );
	snd_register_message( "start_turbine_elevator",   			::start_turbine_elevator );
	snd_register_message( "stop_turbine_elevator",   			::stop_turbine_elevator );
	
	
	// AREA: TURBINE ROOM //////////////////////////////////
	snd_register_message( "start_turbine_loop",					::start_turbine_loop);
	snd_register_message( "turbine_pre_explo",					::turbine_pre_explo);
	snd_register_message( "turbine_explo_audio",				::turbine_explo);
	snd_register_message( "start_pa_emergency_turbine",			::start_pa_emergency_turbine);
	snd_register_message( "start_turbine_door_breach",			::start_turbine_door_breach);
	snd_register_message( "start_turbine_door_impt",			::start_turbine_door_impt);
	
	// AREA: CONTROL ROOM & HANGAR /////////////////////////
	
	snd_register_message( "start_control_room_explo",			::start_control_room_explo );
	
	// FIRE/STEAM LOOPS
	
	snd_register_message( "start_pre_loading_bay",				::start_pre_loading_bay );
	
	snd_register_message( "snd_start_fire_steam",				::start_fire_steam_loops );	
	
	//Glass Shatters
	snd_register_message( "hangar_explo_and_debris_01", 		::hangar_explo_and_debris_01 );
	snd_register_message( "hangar_explo_and_debris_02", 		::hangar_explo_and_debris_02 );
						 
	// HANGAR TRANSPORT AWAY
	snd_register_message( "hangar_transport_01_away",			::hangar_transport_01_away );
	snd_register_message( "hangar_transport_flying_01_away",	::hangar_transport_flying_01_away );
	snd_register_message( "hangar_transport_flying_02_away",	::hangar_transport_flying_02_away );
	
	// AREA: ESCAPE OUTRO //////////////////////////////////

	// PRESSURE EXPLOSION
	snd_register_message( "pressure_explosion",					::pressure_explosion );

	// TRUCK FLIP
	snd_register_message( "fus_truck_flip_01",					::fus_truck_flip_01 );
	snd_register_message( "fus_truck_flip_02",					::fus_truck_flip_02 );	
	
	// EXTRACTION CHOPPER 
	snd_register_message( "extraction_chopper_spawn",			::extraction_chopper_spawn );
	snd_register_message( "extraction_chopper_move",			::extraction_chopper_move );
	
	// GAZ RETREAT
	snd_register_message( "start_gaz_02_retreat",				::start_gaz_02_retreat );
	snd_register_message( "start_gaz_03_retreat",				::start_gaz_03_retreat );
	
	// AREA: SILO COLLAPSE ///////////////////////////////////
	
	// TOWER COLLAPSE BIG MOMENT
	snd_register_message( "tower_collapse_prep",				::tower_collapse_prep );
	snd_register_message( "tower_collapse_start",				::tower_collapse_start );
	snd_register_message( "tower_collapse_player_stumble",		::tower_collapse_player_stumble );	
	snd_register_message( "tower_collapse_player_knockback",	::tower_collapse_player_knockback );
	
	// COLLAPSE STUN
	snd_register_message( "silo_collapse_plr_stunned",			::silo_collapse_plr_stunned);
	snd_register_message( "fus_outro_burke_foley",			::fus_outro_burke_foley);

	// END FADE & LOGO VID
	snd_register_message( "ending_fade_out",			::ending_fade_out);
	snd_register_message( "fusion_endlogo",				::fusion_endlogo);
}

/*********************************************************************
	Level Init Support Functions.
********************************************************************/
precache_presets()
{
}	

config_system()
{
	set_stringtable_mapname( "shg" );
	// snd_set_occlusion( "med_occlusion" ); This is set in zone defs. Should not do it both ways.
	// deactivate occlusion
	level.player DeactivateOcclusion( "voices_critical" );
	// setup whizby settings(
	// unfortunately, no way to "gate" whizby events (needs new feature), so this a way to make "far" whizbies out of range
	WHIZ_set_radii( 50, 100, 5000 ); 
	WHIZ_set_offset( 15 );
	WHIZ_set_probabilities( 50, 50, 100 ); // make the "far" higher prob to filter out whizby events
	WHIZ_set_spreads( 200, 300, 400 );
	//aud_set_timescale();
}

init_audio_flags()
{
	//flag_init("aud_all_clear");
	
	flag_init( "aud_alarm_outside_started" );
	flag_init( "aud_alarm_outside_enabled" );
	flag_set( "aud_alarm_outside_enabled" );  // default is outside alarm is enabled
	
	// PCap/VO flags.
	flag_init("aud_start_fusion_fly_in_intro_vo_done");
	flag_init("aud_start_fusion_fly_in_pt2_vo_done");
	
	flag_init( "flag_player_zip_started" );
	
	flag_init("fusion_controlroom_dialog_done");
}

init_globals()
{
	if( !IsDefined( level.aud ) )
		level.aud = SpawnStruct();

	// 2D reverb alarm volume that scales with distance
	level.aud.reverb_alarm_volume = 1.0;
	level.aud.reverb_alarm_volume_update_rate = 0.1;
	level.aud.bomb_shakes = false;
	level.aud.control_room_buzzer_started = false;
	
	//Debug Submix for Player Weapons
	//MM_add_dynamic_volmod_submix("shg_weapons", ["s1_wpn_fire_plr", 1, "s1_wpn_sub_plr", 1, "s1_wpn_mech_plr", 1, "s1_wpn_tail_plr", 1, "mw3_wpn_plr", 0]);	
	disable_trigger_with_targetname( "audio_reactor_entrance" );
	disable_trigger_with_targetname( "audio_elevator_entrance" );
	
	//Turn up deprecated MW3 bullet impact volmod
	MM_add_submix("fusion_bullet_impt");
		
}

launch_threads()
{	
	// If in specops, bail immediately.
	if ( aud_is_specops() )
		return;

	// Not in specops, ok.

	thread intro_fly_in_part2_vo();
	thread fastzip_explosion_seq();	
	thread trigger_alarm_on_street_combat_started();
	
	//thread trigger_courtyard_point_sounds();
	thread trigger_control_room_gas_leak();
	
	checkpoint1 = getent( "audio_security_checkpoint_01", "targetname" );
	checkpoint2 = getent( "audio_security_checkpoint_02", "targetname" );
	checkpoint1 thread security_checkpoint_trigger_think();
	checkpoint2 thread security_checkpoint_trigger_think();
	
/#
	//thread PrintPlayerPosition();
#/
}

launch_loops()
{
	thread start_looping_alarm_sounds();
	
	//Security Room
	loop_fx_sound( "metal_detector_hum_lp", ( 657, 3291, 60 ),  true );
	loop_fx_sound( "metal_detector_hum_lp", ( 657, 2721, 60 ),  true );
	
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 697, 3251, 30 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 699, 2754, 30 ),  true );
	
	//Lab Hallway
	loop_fx_sound( "computer_main_frame_lp", ( 1105, 2566, -484 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 987, 2566, -484 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 865, 2566, -484 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 1546, 2949, -484 ),  true );
	
	loop_fx_sound( "alarm_computer_warning_01", ( 1545, 2959, -484 ),  true );
	loop_fx_sound( "alarm_computer_warning_04", ( 865, 2566, -484 ),  true );
	
	//Lab
	loop_fx_sound( "computer_main_frame_lp", ( 42, 3362, -484 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 42, 3483, -484 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 42, 3600, -484 ),  true );
	
	loop_fx_sound( "static_offline_tv_panel_lp", ( 1020, 3212, -400 ),  true );
	loop_fx_sound( "static_offline_tv_panel_lp", ( 1020, 3450, -400 ),  true );
	loop_fx_sound( "static_offline_tv_panel_lp", ( 1190, 3543, -400 ),  true );
	loop_fx_sound( "static_offline_tv_panel_lp", ( 637, 3697, -400 ),  true );
	
	loop_fx_sound( "alarm_computer_warning_01", ( 596, 3168, -484 ),  true );
	loop_fx_sound( "alarm_computer_warning_02", ( 959, 3670, -484 ),  true );
	loop_fx_sound( "alarm_computer_warning_04", ( 822, 3527, -484 ),  true );
	loop_fx_sound( "alarm_computer_warning_03", ( 1111, 3420, -484 ),  true );
	loop_fx_sound( "alarm_computer_warning_01", ( 1028, 3899, -484 ),  true );
	
	loop_fx_sound( "electrical_transformer_hum_lp", ( 1309, 3108, -479 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 577, 3091, -479 ),  true );
	
	//Pre Reactor Hallway
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 1986, 4147, -400 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 1719, 4405, -400 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 2129, 4268, -400 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 1861, 4547, -400 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 1872, 4809, -400 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 2162, 5089, -400 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 1739, 4945, -400 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 1989, 5186, -400 ),  true );
	
	loop_fx_sound( "electrical_transformer_hum_lp", ( 1941, 4645, -479 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 2263, 5011, -479 ),  true );
	
	//Reactor
	loop_fx_sound( "mach_industrial_steam_lp", ( 3367, 4382, -485 ),  true );
	loop_fx_sound( "mach_industrial_generator_lp", ( 3947, 4478, -485 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 3777, 4568, -484 ),  true );
	loop_fx_sound( "alarm_computer_warning_01", ( 3307, 4059, -484 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 3136, 3983, -484 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 3302, 4076, -484 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 3487, 4142, -484 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 3707, 4203, -484 ),  true );
	loop_fx_sound( "alarm_computer_warning_03", ( 4289, 4106, -484 ),  true );
	loop_fx_sound( "liquid_coolant_pool_lp", ( 3558, 3794, -509 ),  true );
	loop_fx_sound( "liquid_coolant_pool_lp", ( 4795, 3197, -509 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 4259, 4029, -541 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 4539, 3903, -541 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 4343, 4484, -485 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 4677, 4394, -485 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 4186, 4244, -485 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 4486, 3251, -543 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 5242, 3051, -485 ),  true );
	loop_fx_sound( "alarm_computer_warning_04", ( 5177, 2166, -484 ),  true );
	loop_fx_sound( "mach_industrial_steam_lp", ( 5500, 2698, -485 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 5186, 2446, -485 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 5051, 2153, -485 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 5377, 2160, -454 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 5288, 2017, -454 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 5040, 2497, -541 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 4918, 2221, -541 ),  true );
	loop_fx_sound( "mach_industrial_steam_lp", ( 4076, 1214, -485 ),  true );
	loop_fx_sound( "mach_industrial_steam_lp", ( 3485, 1939, -541 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 4078, 1538, -485 ),  true );
	loop_fx_sound( "amb_elec_comp_hard_drive_lp", ( 3448, 1590, -485 ),  true );
	loop_fx_sound( "mach_industrial_steam_lp", ( 3409, 1339, -485 ),  true );
	
	//Reactor upstairs room
	loop_fx_sound( "computer_main_frame_lp", ( 4507, 4416, -357 ),  true );
	loop_fx_sound( "computer_main_frame_lp", ( 4685, 4333, -357 ),  true );
	loop_fx_sound( "alarm_computer_warning_02", ( 4724, 4363, -357 ),  true );
	loop_fx_sound( "alarm_computer_warning_03", ( 4329, 4531, -357 ),  true );
	
	//Post reactor hallway
	loop_fx_sound( "electrical_transformer_hum_lp", ( 4021, 608, -479 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 4013, 23, -484 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 3548, 31, -484 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 3958, -139, -450 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 3585, -143, -450 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 3962, -324, -450 ),  true );
	loop_fx_sound( "amb_elec_comp_smart_glass_lp", ( 3579, -329, -450 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 4563, 7, -482 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 4563, 449, -482 ),  true );
	loop_fx_sound( "electrical_transformer_hum_lp", ( 4563, 595, -482 ),  true );
	
	//Turbine Room
	loop_fx_sound( "steam_broken_pipe_lp", ( 5295, 1252, -36 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 5870, 719, -36 ),  true );
	
	//Turbine room mid level
	loop_fx_sound( "steam_broken_pipe_lp", ( 5830, 721, 93 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 6554, 1065, 108 ),  true );
	
	//Turbine room top level
	loop_fx_sound( "steam_broken_pipe_lp", ( 5735, 528, 228 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 6146, 437, 228 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 6251, 523, 238 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 6257, 927, 268 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 6460, 1103, 228 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 6536, 1016, 268 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 7206, 1604, 230 ),  true );
	loop_fx_sound( "mach_industrial_boiler_lp", ( 6149, 534, 350 ),  true );
	loop_fx_sound( "mach_industrial_boiler_lp", ( 6891, 1266, 350 ),  true );
	loop_fx_sound( "mach_industrial_boiler_lp", ( 7274, 2228, 350 ),  true );
	
	//Turbine broken
	loop_fx_sound( "steam_broken_pipe_lp", ( 6721, 1801, 164 ),  true );
	loop_fx_sound( "steam_broken_pipe_lp", ( 6621, 2086, 147 ),  true );
	
	//Control Room
	loop_fx_sound( "steam_broken_pipe_sml_lp_01", ( 6550, 3171, 250 ),  true );
	loop_fx_sound( "steam_broken_pipe_sml_lp_02", ( 6165, 3408, 250 ),  true );
	loop_fx_sound( "steam_broken_pipe_sml_lp_01", ( 6347, 3656, 250 ),  true );
	
}

create_level_envelop_arrays()
{
	level.aud.envs[ "alarm_verb_level_over_distance" ] =
	[	
		[0.000,	0.75],
		//[300,	0.2],
		[700,	1.0],
		[1200,	0.5],
		[2500,	0.1],
		[3500,	0.0]
	]; 
	
	level.aud.envs[ "alarm_verb_level_flyin_over_distance" ] =
	[	
		[0.000,	0.0],
		[500,	0.2],
		[1000,	1.0],
		[4000,	0.6],
		[7000,	0.0]
	]; 

	level.aud.envs[ "turret_drop_shake_over_distance" ] =
	[	
		[0.000,	0.5],
		[1000,	0.1],
		[1200,	0.1]
	]; 
	
	level.aud.envs[ "titan_tank_cannon" ] =
	[	
		[0,	1],
		[1500,	0.75],
		[3000,	0.4],		
		[4500,	0.1]
	]; 	
}

register_trigger_callbacks()
{
}

add_note_track_data()
{
}

/********************************************************************
	DEBUG CODE
********************************************************************/
/#
start_audio_debugging()
{
//	// Player Weapon Debuging.
//	MM_add_dynamic_volmod_submix("shg_weapons", ["s1_wpn_fire_plr", 1, "s1_wpn_sub_plr", 1, "s1_wpn_mech_plr", 1, "s1_wpn_tail_plr", 1, "mw3_wpn_plr", 0]);	
//	level.aud.current_weapon_set = "shg";
//	level.aud.dpadup = ::wb_reload_weapons; //::Action Slot #1.
//	level.aud.dpaddown = ::debug_weapon_swap; //::Action Slot #2.
//	
//	// Alarm Debugging.
//	level.aud.dpadleft = ::debug_solo_alarm;  //::Action Slot #3.
//	level.aud.dpadright = ::debug_unsolo_alarm; //::Action Slot #4.
//	
//	// DPad Debugging support.
//	thread dpad_functions_setup();

//	thread dv_start_audio_debugging();
	
	//thread jg_start_audio_debugging();
}

jg_start_audio_debugging()
{
	wait 0.05;

	/*** GOD MODE ***/
	level.player EnableInvulnerability();

	//level.aud.dpaddown = maps\fusion_code::fly_in_ambient_street_jets();
	
}

dv_start_audio_debugging()
{
	wait 0.5;	
		
	/*** GOD MODE ***/
	level.player EnableInvulnerability();
	
	MM_add_submix("solo_vehicles");
	
//	/*** IMPACTS ***/
//	MM_add_submix("solo_impacts");
	
//	/*** DRONES ***/
//	MM_add_submix("solo_pdrone");

//	/*** COVER DRONE ***/
//	level.player SetOrigin( (-1329, -2646, -3) );
//	aiarray = GetAIArray( "axis" );
//	foreach (dude in aiarray)
//	{
//		if ( IsDefined( dude.magic_bullet_shield ) && dude.magic_bullet_shield )
//		{
//			dude stop_magic_bullet_shield();
//		}
//		wait 0.05;
//		dude kill();
//	}
	
//	/*** WALKER ***/
//	MM_add_submix("solo_plr_vehicle");
//	MM_add_submix("solo_npc_vehicle");
	
//	/*** VEHICLE MONITOR THREAD ***/
//	thread debug_vehicle_monitor();
	
//	/*** MUTE MUSIC ***/
//	wait(1);
//	MM_add_submix("mute_music");
}

debug_vehicle_monitor()
{
//	while ( 1 ) 
//	{
//		iprintln("Vehicle Count = " + VM2_get_vehicle_count());
//		
//		wait 1.0;
//	}
}

debug_weapon_swap()
{
	if (level.aud.current_weapon_set == "shg")
	{
		iprintln("IW Guns Now Active");
		MM_clear_submix("shg_weapons");
		MM_add_dynamic_volmod_submix("iw_weapons", ["s1_wpn_fire_plr", 0, "s1_wpn_sub_plr", 0, "s1_wpn_mech_plr", 0, "s1_wpn_tail_plr", 0, "mw3_wpn_plr", 1]);
		level.aud.current_weapon_set = "iw";
		return;		
	}
	else if (level.aud.current_weapon_set == "iw")
	{
		iprintln("SHG Guns Now Active");
		MM_clear_submix("iw_weapons");
		MM_add_dynamic_volmod_submix("shg_weapons", ["s1_wpn_fire_plr", 1, "s1_wpn_sub_plr", 1, "s1_wpn_mech_plr", 1, "s1_wpn_tail_plr", 1, "mw3_wpn_plr", 0]);		
		
		level.aud.current_weapon_set = "shg";
		return;		
	}
}

dpad_functions_setup()
{	
	//level.player NotifyOnPlayerCommand( "dpad_action_01", "+actionslot 1" ); //Up on Dpad.
	level.player NotifyOnPlayerCommand( "dpad_action_02", "+actionslot 2" ); //Down on Dpad.
	level.player NotifyOnPlayerCommand( "dpad_action_03", "+actionslot 3" ); //Left on Dpad.
	level.player NotifyOnPlayerCommand( "dpad_action_04", "+actionslot 4" ); //Right on Dpad.
	
	//thread dpad_function_wait( "dpad_action_01", level.aud.dpadup ); //Action Slot 1
	thread dpad_function_wait( "dpad_action_02", level.aud.dpaddown ); //Action Slot 2
	thread dpad_function_wait( "dpad_action_03", level.aud.dpadleft ); //Action Slot 3
	thread dpad_function_wait( "dpad_action_04", level.aud.dpadright ); //Action Slot 4
}

dpad_function_wait( dpad_action, dpad_direction)
{
	while (1)
	{
		level.player waittill( dpad_action );	
		
		if (!Isdefined(dpad_direction))
			IPrintLn( dpad_action + " is Currently Unassigned");
		
		if (IsDefined(dpad_direction))
		{
			[[ dpad_direction ]]();
		}

		wait(0.05);
	}
}

PrintPlayerPosition()
{
    level.player endon( "death" );

    // Create HUD
    fontsize = 1.0;
    x = 500;
    y = 110;
    label_color = ( 1.0, 1.0, 1.0 );
    create_debug_text_hud( "position_hud", x, y, label_color, "Pos:", fontsize);
    y = 120;
    create_debug_text_hud( "direction_hud", x, y, label_color, "Dir:", fontsize);

    while(1)
    {
        print_debug_text_string_hud( "position_hud", level.player.origin );
        print_debug_text_string_hud( "direction_hud", level.player.angles );
        wait(0.05);
    }
}
#/
		
/*******************************/
/***** CHECKPOINT HANDLERS *****/
/*******************************/	
start_intro_fly_in(args)
{
	thread intro_flight_start();
	thread intro_fly_in_vo();
}

start_intro_fly_in_part2(args)
{
	flag_set("aud_start_fusion_fly_in_intro_vo_done");
}

start_courtyard(args)
{
	AZM_start_zone( "fusion_courtyard_battle" );
}

start_security_room(args)
{
	AZM_start_zone( "fusion_courtyard_battle" );
}
	
start_lab(args)
{
	if ( IsDefined( level.aud.security_building_entrance ) )
	{
	level.aud.security_building_entrance aud_fade_out(0.1);
	level.aud.security_building_entrance = undefined;
	}
	
	thread start_lab_alarms();
	
	//Temp fix until reverb is working when spawning inside of a trigger.
	AZM_start_zone( "fusion_airlock_lab_hallway" );
}

start_reactor(args)
{
	AZM_start_zone( "fusion_pre_reactor_hallway" );
	thread start_lab_alarms();
	thread start_pre_reactor_alarms();
}

start_reactor_exit(args)
{
	AZM_start_zone( "fusion_post_reactor_hallway" );
	thread start_alarm_post_reactor();
	thread start_pa_codered();
	
}

start_turbine_room(args)
{
	AZM_start_zone( "fusion_turbine_elevator" );
}

start_control_room_entrance(args)
{
	AZM_start_zone( "fusion_turbine_room" );
	
	level endon( "stop_pa_turbine" );
	
	if (IsDefined(level.aud.pa_emergency_turbine) && level.aud.pa_emergency_turbine)
	{
		return;
	}
	else
	{
		level.aud.pa_emergency_turbine = true;
		while( 1 )
		{
			thread play_sound_in_space("fusion_pa_emergencyexit",( 7231, 2847, 267 ));
	
			wait(9);	
		}
	}
}

start_control_room(args)
{
	AZM_start_zone( "fusion_control_room" );
}

start_control_room_exit(args)
{
	AZM_start_zone( "fusion_pre_loading_bay" );
	thread start_loading_bay_alarms();
	thread start_control_room_alarms();
	thread trigger_bomb_shake();
	
	if ( !flag( "aud_alarm_outside_started" ) )
	{
		thread start_outside_alarm();
	}
}

start_cooling_tower(args)
{
	snd_music_message("mus_fusion_pressure_readings_critical");
	AZM_start_zone( "fusion_battle_retreat" );
	if ( !flag( "aud_alarm_outside_started" ) )
	{
		thread start_outside_alarm();
	}
}


/***********************************/
/***** AWESOME TRIGGER HANDLERS ****/
/***********************************/
snd_zone_handler( zone_message, args )
{
	switch ( zone_message )
	{		
		
		case "enter_fusion_elevator_shaft":
		{
			thread start_lab_alarms();
		}
		break;
		
		case "enter_fusion_airlock_lab_hallway":
		{
			if ( IsDefined( level.aud.security_building_entrance ) )
			{
			level.aud.security_building_entrance aud_fade_out(1);
			level.aud.security_building_entrance = undefined;
			}
		}
		break;
		
		case "enter_fusion_airlock_lab":
		{
			thread start_pa_emergency_exit();
			thread start_pa_airlockclosing();
			thread start_pre_reactor_alarms();
		}
		break;
		
		case "enter_fusion_post_reactor_hallway":
		{
			thread start_pa_codered();
			thread start_alarm_post_reactor();
		}
		break;
		
		case "enter_fusion_turbine_elevator_quiet":
		{
			level notify( "stop_lab_alarms" );
			level notify("stop_all_crane_audio");
			MM_clear_submix("fusion_post_reactor_room");
		}
		break;
		
		case "enter_fusion_pre_loading_bay":
		{
			level notify( "stop_pa_turbine" );
		}
		break;
		
		//Blend Trigger: fusion_control_room fusion_loading_baycase "enter_fusion_loading_bay":
		
		case "enter_fusion_loading_bay":
		{
			zone_from = args;
		}
		break;
		
		case "exit_fusion_control_room":
		{
			zone_to = args;
			if ( zone_to == "fusion_control_room" )
			{
				flag_clear( "aud_alarm_outside_enabled" );
				thread trigger_bomb_shake();	
			}
			else if ( zone_to == "fusion_loading_bay" )
			{
				flag_set( "aud_alarm_outside_enabled" );
				level notify( "notify_out_of_control_room" );
				level.aud.bomb_shakes = false;
			}
		}
		break;	
		
		case "exit_fusion_loading_bay":
		{
			zone_to = args;
			if ( zone_to == "fusion_control_room" )
			{
				flag_clear( "aud_alarm_outside_enabled" );
				thread trigger_bomb_shake();				
			}			
			else if ( zone_to == "fusion_loading_bay" )
			{
				flag_set( "aud_alarm_outside_enabled" );
				level notify( "notify_out_of_control_room" );
				level.aud.bomb_shakes = false;
			}
		}
		break;	
		
		//Blend Trigger: fusion_loading_bay fusion_battle_retreat
		case "enter_fusion_battle_retreat":
		{
			zone_from = args;
		}
		break;
		
		case "exit_fusion_battle_retreat":
		{
			zone_to = args;
			if ( zone_to == "fusion_battle_retreat" )
			{
				level notify( "notify_out_of_loading_bay" );
				level.aud.control_room_buzzer_started = false;
			}
			
			else if (zone_to == "fusion_loading_bay" )
			{
				thread start_control_room_alarms();
			}
		}
		break;	
	}
}
	
/**************************/
/***** EVENT HANDLERS *****/
/**************************/

intro_flight_start()
{
	MM_add_submix("fusion_intro_flight", 0.05);
	wait 0.45;
	
	//Warbird Interior
	aud_delay_play_2d_sound("fus_intro_helo_interior", 0.05);
	aud_delay_play_2d_sound("fus_intro_helo_controls", 0.05);

	//Warbird Door Open
	aud_delay_play_2d_sound("fus_intro_door_mech_a", 47.25);
	aud_delay_play_2d_sound("fus_intro_door_mech_b", 47.25);
	aud_delay_play_2d_sound("fus_intro_door_decompress", 47.25);
	aud_delay_play_2d_sound("fus_intro_door_wind", 47.25);
	
	//Warbird_b Flyin
	aud_delay_play_2d_sound("fus_intro_warbird_b_flyin", 50.25);

	//Warbird_b De-Cloak
	aud_delay_play_2d_sound("fus_intro_warbird_b_decloak", 54.10);
	aud_delay_play_2d_sound("fus_intro_warbird_b_chop", 54.10);
	aud_delay_play_2d_sound("fus_intro_warbird_b_engine", 54.10);	
	
	wait (48);
	aud_set_music_submix( 0.75, 5 ); //Bringing music back up now that the warbird door is open.
	
}


start_hologram_audio()
{
	wait(.05);
	
	aud_delay_play_2d_sound("fus_intro_monitor_static_01", 13.6);
	aud_delay_play_2d_sound("fus_intro_monitor_static_02", 14.8);
	aud_delay_play_2d_sound("fus_intro_monitor_buttons_01", 21.5);
	aud_delay_play_2d_sound("fus_intro_monitor_buttons_02", 30.6);
	aud_delay_play_2d_sound("fus_intro_hologram_on", 30.75);
	aud_delay_play_2d_sound("fus_intro_hologram_on_02", 31.3);
	aud_delay_play_2d_sound("fus_intro_hologram_turn_01", 37.2);
	aud_delay_play_2d_sound("fus_intro_hologram_obj_draw", 38.7);
	aud_delay_play_2d_sound("fus_intro_hologram_off", 48);
	
/*	Removing this because the fade is not working (may be code bug that we know about). */
//	aud_monitor_lp_01 = aud_create_entity((0,0,0));
//	aud_monitor_lp_01 aud_fade_in("fus_intro_monitor_static_lp_01", 10, true);
	wait(22);
//	aud_monitor_lp_01 aud_fade_out(.1);
	aud_monitor_lp_02 = aud_create_entity((0,0,0));
	aud_monitor_lp_02 aud_fade_in("fus_intro_monitor_static_lp_02", .1, true);
	wait(4);
	aud_monitor_lp_02 aud_fade_out(4);
}


start_burke_foley(args)
{
	level waittill("heli_intro_burke_foley");
 
    //Making all Burke Foley, inside Warbird, 2D to better control spacialization.  Player movement is very limited so 2D sounds will have no negative spacialization effects.
    //Also, 3D sounds on the Burke ent are playing at the position of Burke's feet.  Because he is leaning over for some of the time, this causes the sounds to be
    //incorrectly weighted to the right.

	aud_delay_play_2d_sound("fus_intro_burke_walk_to_computer", 14.8);
	aud_delay_play_2d_sound("fus_intro_burke_rattle_gun_comp", 18.9);
	aud_delay_play_2d_sound("fus_intro_burke_push_button_comp", 22);
	aud_delay_play_2d_sound("fus_intro_burke_walk_to_holo_map", 25.8);
	aud_delay_play_2d_sound("fus_intro_burke_gesture_holo_map_01", 29.1);
	aud_delay_play_2d_sound("fus_intro_burke_gesture_holo_map_02", 31.4);
	aud_delay_play_2d_sound("fus_intro_burke_gesture_holo_map_03", 33.9);
	aud_delay_play_2d_sound("fus_intro_burke_gesture_holo_map_04", 35.9);
	aud_delay_play_2d_sound("fus_intro_burke_walk_away_holo_map", 40);
	aud_delay_play_2d_sound("fus_intro_burke_walk_to_door", 45.7);

	//Commenting out the following Burke Foley sounds because it is not likely they would be heard in the context of flying in a helicopter with the doors open.  
	
	//aud_delay_play_2d_sound("fus_intro_burke_salute", 55.1);
	//aud_delay_play_2d_sound("fus_intro_burke_hold_on_door", 67.5);
	//aud_delay_play_2d_sound("fus_intro_burke_let_go_door", 70.5);
	//aud_delay_play_2d_sound("fus_intro_burke_swing_gun_around", 90);
	//aud_delay_play_2d_sound("fus_intro_burke_firing_stance", 93.1);
	flag_wait( "flag_burke_zip" );
	aud_delay_play_linked_sound("fus_intro_burke_jump_zipline", args, 7.7);
	
}

start_intro_npc_foley(args)
{
	level waittill("heli_intro_burke_foley");
	
	aud_delay_play_linked_sound("fus_intro_npc_gun_up", args, 7);
	aud_delay_play_linked_sound("fus_intro_npc_fire_arm_check", args, 8.9);
	aud_delay_play_linked_sound("fus_intro_npc_aim_down_sights", args, 14.8);
	aud_delay_play_linked_sound("fus_intro_npc_check_comms", args, 16.9);
	aud_delay_play_linked_sound("fus_intro_npc_check_vest", args, 18.2);
	aud_delay_play_linked_sound("fus_intro_npc_feet_rustle", args, 34.3);
	aud_delay_play_linked_sound("fus_intro_npc_rub_nose", args, 37.9);
	aud_delay_play_linked_sound("fus_intro_npc_scratch_head", args, 40.4);
	aud_delay_play_linked_sound("fus_intro_npc_check_ear_piece", args, 43.1);
	aud_delay_play_linked_sound("fus_intro_npc_arm_down", args, 45.6);	
	
}	
	
decloak_intro_helicopter()
{
	//IPrintLnBold( "AUDIO:  Warbird Decloak" );

	//Warbird_b Bank
	aud_delay_play_2d_sound("fus_intro_warbird_b_bank", 6.43);
	
	//Warbirds Flyover
	aud_delay_play_2d_sound("fus_intro_warbirds_engine", 8.25);
	aud_delay_play_2d_sound("fus_intro_warbirds_flyby", 8.25);
	aud_delay_play_2d_sound("fus_intro_warbirds_flyby_rear", 8.25);	

	//Warbird Cliff
	aud_delay_play_2d_sound("fus_intro_warbird_cliff_engine", 12.97);
	aud_delay_play_2d_sound("fus_intro_warbird_cliff_chop", 12.97);

	//Fighter Jets
	aud_delay_play_2d_sound("fus_intro_fighter_jets", 18.29);

	//Anti-Aircraft
	aud_delay_play_2d_sound("fus_intro_anti_air_explo", 19);
}

intro_flight_missiles_fire()
{
	//IPrintLnBold( "AUDIO:  Spawn Fly-In Missile" );
	
	//Rockets that Miss
	aud_delay_play_2d_sound("fus_intro_rockets_miss", 1.67);

	//Rockets that Hit
	aud_delay_play_2d_sound("fus_intro_rockets_hit", 5.47);
	
	wait 3.16;
	snd_music_message( "mus_fusion_first_contact" );
}

missile_hit_warbird_b()
{
	//IPrintLnBold( "AUDIO:  Warbird Missile Hit" );

	//Warbird_b Hit
	aud_delay_play_2d_sound("fus_intro_warbird_hit", 0.05);
	aud_delay_play_2d_sound("fus_intro_warbird_hit_debris", 0.05);
	aud_delay_play_2d_sound("fus_intro_warbird_hit_chop", 0.05);	
	aud_delay_play_2d_sound("fus_intro_warbird_hit_broke", 0.05);
	aud_delay_play_2d_sound("fus_intro_warbird_engine_hit", 1.52);
	
	//Warbird_b Crash
	aud_delay_play_2d_sound("fus_intro_warbird_crash", 2.7);
	aud_delay_play_2d_sound("fus_intro_warbird_crash_kick", 2.7);
	aud_delay_play_2d_sound("fus_intro_warbird_crash_mtl", 2.7);

	//Warbird_a Hover
	aud_delay_play_2d_sound("fus_intro_warbird_a_hover", 4);
}

warbird_b_crash_tower()
{
	//IPrintLnBold( "AUDIO:  Warbird Crash Tower" );
	wait 8.0;
	MM_clear_submix("fusion_intro_flight", 4);
	MM_add_submix( "fusion_courtyard_battle_flyin", 5 );	// submix removed at "player_zipped_down"
	AZM_start_zone("fusion_courtyard_battle", 5);
}

rooftop_strafe_start()
{
	//IPrintLnBold( "AUDIO:  Warbird MobileTurret Dropoff" ); 
	MM_add_submix( "fusion_courtyard_warbirds", 2 );
	warbird = self;
	assert(IsDefined(warbird));
	warbird thread snd_air_vehicle_smart_flyby("fus_warbird_roof_strafe_by", 1700);
	wait (5);
	//Warbird 3d Chop Loop
	warbird_chop = aud_play_linked_sound("fus_warbird_plr_chop_lp", warbird, "loop", "stop_warbird_chop", (0, 0, 0), 0);
	warbird_chop ScaleVolume(0.0);
	warbird_chop thread delaycall(0.05, ::ScaleVolume, 1, 4);
	
	flag_wait( "flag_squad_heli_01_zip_complete" );

	//Play Warbird Depart
	warbird thread snd_air_vehicle_smart_flyby("fus_warbird_roof_strafe_depart", 1000);

	//Stop Warbird 3d Loop	
	warbird_chop ScaleVolume(0, 5);
	wait (5.05);
	level notify("stop_warbird_chop");
}

player_warbird_spawn()
{
	level waittill("aud_roof_combat_complete");  //Bring in the player_warbird 3d heli loops now that rooftop combat music is over. 

	player_warbird = self;
	assert(IsDefined(player_warbird));

	//Warbird 3d Blades Loop
	warbird_plr_blades = aud_play_linked_sound("fus_warbird_plr_blades_lp", player_warbird, "loop", "stop_warbird_plr_blades", (-50, 200, 100), 0);
	warbird_plr_blades ScaleVolume(0.0);
	warbird_plr_blades thread delaycall(0.05, ::ScaleVolume, 0.75, 2);

	//Warbird 3d Interior Loop
	warbird_plr_interior = aud_play_linked_sound("fus_warbird_plr_interior_lp", player_warbird, "loop", "stop_warbird_plr_interior", (-50, -200, 100), 0);
	warbird_plr_interior ScaleVolume(0.0);
	warbird_plr_interior thread delaycall(0.05, ::ScaleVolume, 0.75, 2);

	level waittill("aud_fastzip_end");

	//Stop Warbird 3d Loops
	warbird_plr_blades thread delaycall(0.05, ::ScaleVolume, 0, 5);
	warbird_plr_interior thread delaycall(0.05, ::ScaleVolume, 0, 5);
	wait (5.05);
	level notify("stop_warbird_plr_blades");
	level notify("stop_warbird_plr_interior");	
}

// FASTZIP SEQUENCE
fastzip_turret_switch_to()
{
	aud_play_2d_sound("tac_fastzip_start");
}

fastzip_turret_switch_complete()
{
	
}

fastzip_turret_fire()
{
	aud_play_2d_sound("tac_fastzip_fire_plr");
}

fastzip_turret_putaway()
{
	aud_play_2d_sound("tac_fastzip_turret_putaway");
}

fastzip_rappel()
{
	wait(0.3);
	fastzip = aud_play_2d_sound("tac_fastzip_slide");
	level waittill("aud_fastzip_end");

	aud_play_2d_sound("tac_fastzip_land");
	if(IsDefined(fastzip))
		fastzip scalevolume(0, 0.01);
}

fastzip_explosion_seq()
{
	flag_wait( "flag_player_zip_started" );
	wait(1.2);

	explo_params = SpawnStruct();
	explo_params.pos 							= level.player.origin;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );

	aud_delay_play_2d_sound("fus_fastzip_explo_mtl_debris", 0.6);
}

fastzip_hit_the_ground()
{
	level notify("aud_fastzip_end");
}


player_zipped_down(args)
{
	MM_clear_submix( "fusion_courtyard_battle_flyin", 1 );
}

player_warbird_flyout()
{
	self thread snd_air_vehicle_smart_flyby("fus_warbird_plr_depart_flyby", 900);
}

warbird_mobile_turret_dropoff()
{
	//IPrintLnBold( "AUDIO:  Warbird MobileTurret Dropoff" );
	warbird = self;
	assert(IsDefined(warbird));
	wait (0.05);
	thread aud_play_linked_sound("fus_warbird_turret_drop_chop", warbird);
	wait(2.95);
	thread aud_play_linked_sound("fus_warbird_turret_drop_engine", warbird);
	wait(7.5);
	thread aud_play_linked_sound("fus_warbird_turret_drop_depart", warbird);
	wait(5);
	MM_clear_submix("fusion_courtyard_warbirds", 8);
	
}

walker_mobile_turret_dropoff()
{
	//IPrintLnBold( "AUDIO:  Walker MobileTurret Dropoff" ); 
	shake_threshold_dist = 1000;
	walker = self;
	wait(8.35);
	assert(IsDefined(walker));
	thread aud_play_linked_sound("fus_warbird_turret_drop_chain", walker);
	thread aud_play_linked_sound("fus_warbird_turret_drop_mech", walker);
	
	wait (0.40);
	
	//Do screen shake if player is close enough to the turret when it hits the ground
	player_dist = distance(level.player.origin, walker.origin); // Get players distance from the walker.
	
	if(player_dist < shake_threshold_dist)
	{
		//IPrintLnBold( player_dist );
		shake_scale = aud_map2( player_dist, level.aud.envs[ "turret_drop_shake_over_distance" ] );
		earthquake( shake_scale, 0.5, level.player.origin, shake_threshold_dist);
	}
}

cvrdrn_paired_anim_start()
{
	// I think this is the magic.  Leads me to suspect a bug related to starting sounds on the first frame after level load.
	// (maybe having to do with the 'settling' stuff, where the server runs for a few frames before the client starts, maybe audio code is inproperly anticipating this).
	// Anyway with this it works -- Tom
	waitframe();
	
	thread aud_play_linked_sound("fus_cvrdrn_paired_anim", self);
}

cvrdrn_paired_anim_explo()
{
	thread aud_play_linked_sound("fus_cvrdrn_paired_anim_explo", self);

	explo_params = SpawnStruct();
	explo_params.pos 							= self.origin;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
}

start_ambient_jet()
{
	//show us where the jets are
	//jet_ent thread aud_print_3d_on_ent("looping_jet");
	
	//instead of relying on loops, trigger a flyby when the jet gets within range of the player
	self thread snd_air_vehicle_smart_flyby("veh_fa18_flyby_rand", 6000);
}

courtyard_ambient_bullet_impact( weapon_str, pos_from, pos_to )
{
	thread play_sound_in_space( "fus_bullet_large_dirt", pos_to );
}

street_wall_1_explode( location )
{
	thread play_sound_in_space("wall_explode", location );

	explo_params = SpawnStruct();
	explo_params.pos 							= location;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
}

spawn_walker_mobile_turret_deploy()
{
	self waittill( "death" );
	thread play_sound_in_space("fus_walker_explo_wall", self.origin);

	explo_params = SpawnStruct();
	explo_params.pos 							= self.origin;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
}

spawn_ally_walker_02()
{
	self waittill( "death" );
	thread play_sound_in_space("fus_walker_explo_wall", self.origin);

	explo_params = SpawnStruct();
	explo_params.pos 							= self.origin;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
}
	
player_enter_walker( location )
{
	MM_add_submix( "fusion_inside_xwalker", 0.10 );
}

player_exit_walker( location )
{
	MM_clear_submix( "fusion_inside_xwalker", 1.0 );
}

player_enter_walker_anim()
{
	MM_add_submix( "fusion_enter_exit_walker", 0 );

	ent = aud_play_2d_sound("x4walker_player_enter");
	ent waittill("sounddone");
	MM_clear_submix( "fusion_enter_exit_walker", .1);	
}

player_exit_walker_anim()
{
	MM_add_submix( "fusion_enter_exit_walker", 0 );

	ent = aud_play_2d_sound("x4walker_player_exit");
	ent waittill("sounddone");
	MM_clear_submix( "fusion_enter_exit_walker", .1);	
}

x4_walker_hud_missile_launched( args )
{
}

x4_walker_hud_target_aquired( args )
{
	thread aud_play_2d_sound( "x4_walker_missile_lock" );
}

x4_walker_fire_missile( args )
{
	if(IsDefined( self ))
	{
		missile_target = args;
		missile_ent = self;
		
		// Play RPG Projectile Sounds.
		thread aud_play_2d_sound( "x4_walker_missile_fire" );
		missile_ent playloopsound( "x4_walker_missile_loop" );
		
		// Wait for RPG to explode, use exploder system.
		missile_ent waittill( "explode", origin);
		
		explo_params = SpawnStruct();
		explo_params.pos 							= origin;
		explo_params.speed_of_sound_	 			= true;
		explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
		explo_params.duck_dist_threshold_ 			= 1000;
		explo_params.explo_delay_chance_ 			= 100;
		explo_params.shake_dist_threshold_ 			= 2000;
		explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
		explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
		explo_params.ground_zero_dist_threshold_ 	= 500; 
	 
		snd_ambient_explosion( explo_params );		
	}	
}

player_mobile_turret_explo()
{
	explo_params = SpawnStruct();
	explo_params.pos 							= self.origin;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
	thread aud_play_linked_sound( "fus_cvrdrn_paired_anim_explo", self );
	wait 0.2;
	thread play_sound_in_space( "fus_walker_explo_wall", self.origin );
}

//NPC Mobile Turret
mobile_turret_missile( args )
{
	if(IsDefined( self ))
	{
		missile_target = args;
		missile_ent = self;
		
		thread aud_play_2d_sound( "x4_walker_missile_fire_npc" );
		missile_ent playloopsound( "x4_walker_missile_loop" );
		
		missile_ent waittill( "explode", origin);
		
		explo_params = SpawnStruct();
		explo_params.pos 							= origin;
		explo_params.speed_of_sound_	 			= true;
		explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
		explo_params.duck_dist_threshold_ 			= 800;
		explo_params.explo_delay_chance_ 			= 25;
		explo_params.shake_dist_threshold_ 			= 400;
		explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
		explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
		explo_params.ground_zero_dist_threshold_ 	= 500; 
	 
		snd_ambient_explosion( explo_params );		
	}	
}

courtyard_mi17_spawn_01(args)
{
	args endon( "death" );
	
	args.snd_disable_vehicle_system = true;
	args thread audio_monitor_chopper01_death();

	level.aud.chopper_01_dist_lp = aud_create_linked_entity(args);
	level.aud.chopper_01_dist_lp aud_fade_in("mi17_dist_towards_lp", 1, true);
	
	wait( 7.5 );
		
	level.aud.chopper_01_by_in = aud_create_linked_entity(args);
	level.aud.chopper_01_by_in aud_play("mi17_by_in_01");
	
	level.aud.chopper_01_dist_lp aud_fade_out(0.35);
	level.aud.chopper_01_dist_lp = undefined;
	
	wait( 4 );
	
	level.aud.chopper_01_close_lp = aud_create_linked_entity(args);
	level.aud.chopper_01_close_lp aud_fade_in("mi17_close_towards_lp", 0.75, true);
	
	wait( 15 );
	
	level.aud.chopper_01_wind_up = aud_create_linked_entity(args);
	level.aud.chopper_01_wind_up aud_play("mi17_by_windup_01");
	
	level.aud.chopper_01_close_lp aud_fade_out(1);
	level.aud.chopper_01_close_lp = undefined;
	
	wait( 2 );
	
	level.aud.chopper_01_away_by = aud_create_linked_entity(args);
	level.aud.chopper_01_away_by aud_play("mi17_by_out_01");
	
}

courtyard_mi17_spawn_02(args)
{
	args endon( "death" );
	
	args.snd_disable_vehicle_system = true;
	args thread audio_monitor_chopper02_death();
	
	level.aud.chopper_02_dist_lp = aud_create_linked_entity(args);
	level.aud.chopper_02_dist_lp aud_fade_in("mi17_dist_towards_lp", 1, true);
	
	wait( 7.5 );
		
	level.aud.chopper_02_by_in = aud_create_linked_entity(args);
	level.aud.chopper_02_by_in aud_play("mi17_by_in_02");
	
	level.aud.chopper_02_dist_lp aud_fade_out(0.35);
	level.aud.chopper_02_dist_lp = undefined;
	
	wait( 4 );
	
	level.aud.chopper_02_close_lp = aud_create_linked_entity(args);
	level.aud.chopper_02_close_lp aud_fade_in("mi17_close_towards_lp", 0.75, true);
	
	wait( 15 );
	
	level.aud.chopper_02_wind_up = aud_create_linked_entity(args);
	level.aud.chopper_02_wind_up aud_play("mi17_by_windup_02");
	
	level.aud.chopper_02_close_lp aud_fade_out(1);
	level.aud.chopper_02_close_lp = undefined;
	
	wait( 2 );
	
	level.aud.chopper_02_away_by = aud_create_linked_entity(args);
	level.aud.chopper_02_away_by aud_play("mi17_by_out_02");
}


////// Titan Scene

titan_init( args )
{
	// +++ Titan Scene Mix Notes: Titan movements are triggered off notetracks and are on the "vehicle_npc" mix group. 
	//Cannon shots and death explosions are found on the "explosion_critical" mix group.
	//The enter/transforming sound effects and the death mechanical sounds are on "fullvolume" as a hack to hear them under time pressure for the slice, must be fixed later.
	
	// NoteTrack Data for Titan
	addNotetrack_customFunction( "walker_tank", "footstep_left_large",							::titan_footstep_front_left );
	addNotetrack_customFunction( "walker_tank", "footstep_right_large", 						::titan_footstep_front_right );
	addNotetrack_customFunction( "walker_tank", "footstep_left_rear_large", 					::titan_footstep_rear_left );
	addNotetrack_customFunction( "walker_tank", "footstep_right_rear_large",					::titan_footstep_rear_right );
		
	addNotetrack_customFunction( "walker_tank", "aud_titan_siege_mode_adj_left_side",			::aud_titan_siege_mode_adj_left_side );	
	addNotetrack_customFunction( "walker_tank", "aud_titan_siege_mode_adj_right_side",			::aud_titan_siege_mode_adj_right_side );	
	addNotetrack_customFunction( "walker_tank", "aud_titan_siege_mode_adj_left_side_back",		::aud_titan_siege_mode_adj_left_side_back );	
	addNotetrack_customFunction( "walker_tank", "aud_titan_siege_mode_adj_right_side_back",		::aud_titan_siege_mode_adj_right_side_back );	
		
	self thread titan_engine();
	self thread titan_fire_wait();
}

titan_enter()
{
	thread aud_delay_play_linked_sound( "titan_enter_transform", self, 5);
	thread aud_delay_play_linked_sound( "titan_servo_move", self, 9.5);
	thread aud_delay_play_linked_sound( "titan_servo_move", self, 8);
	thread aud_delay_play_linked_sound( "titan_servo_move", self, 7);
	thread aud_delay_play_linked_sound( "titan_footstep", self, 9);
	thread aud_delay_play_linked_sound( "titan_footstep", self, 11);	
	
	wait(9);
	self thread play_sound_on_tag( "titan_servo_move", "frontWheelTread01_FL");
	wait(1);
	self thread play_sound_on_tag( "titan_footstep", "frontWheelTread01_FR");
}

titan_missile( args )
{
	if(IsDefined(self))
	{
		// RPG Fire
		thread play_sound_in_space("wpn_rpg_npc", self.origin );
		
		// Attach Loop Sound to the projectile.
		rpg_loop = aud_play_linked_sound( "wpn_rpg_loop", self, "loop", "titan_rpg_loop_stop");
		
		self waittill( "explode", origin);
		
		explo_params = SpawnStruct();
		explo_params.pos 							= origin;
		explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
		explo_params.duck_dist_threshold_ 			= 1000;
		explo_params.explo_delay_chance_ 			= 100;
		explo_params.shake_dist_threshold_ 			= 2000;
		explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
		explo_params.shake_duration					= 1.5;
		
		// Play Amb Exps 
		thread snd_ambient_explosion( explo_params );	
	}
}

titan_engine()
{
	if( IsDefined( self ))
	{
		aud_play_linked_sound( "titan_engine_lp", self, "loop", "stop_titan_engine_loop" );
		self waittill( "death" );
		level notify( "stop_titan_engine_loop" );
	}
}

titan_fire_wait()
{
	self endon("death");
	
	while(IsDefined(self))
	{
		self waittill("weapon_fired");
		
		dist = distance( self.origin, level.player.origin );
		map_value = aud_map2( dist, level.aud.envs[ "titan_tank_cannon" ] );
		
		tank_shot = aud_play_linked_sound( "titan_cannon_shot_main", self );
		tank_shot_low = aud_play_linked_sound( "titan_cannon_shot_low", self );
		tank_shot_punch = aud_play_linked_sound( "titan_cannon_shot_crunch", self );
		titan_cannon_shot_tail = aud_play_linked_sound( "titan_cannon_shot_tail", self );
		titan_cannon_shot_lfe = aud_play_linked_sound( "titan_cannon_shot_lfe", self );
		titan_hydraulic_reload = aud_play_linked_sound( "titan_cannon_hydraulics", self );
		
		//If the player is 2500 units or closer, do not delay the distant tail sound.
		if( dist > 2500 )
		{
			titan_cannon_shot_tail_dist_delay = aud_play_linked_sound( "titan_cannon_shot_tail_dist", self );	
		}
		else
		{
			titan_cannon_shot_tail_dist = aud_delay_play_linked_sound("titan_cannon_shot_tail_dist", self, 0.5);				
		}
		
		// Scale 2d Tank shot sounds by player distance.
		shot_array = [tank_shot, tank_shot_low, tank_shot_punch, titan_cannon_shot_lfe, titan_cannon_shot_tail];
		
		foreach(thing in shot_array)
		{
			thing setvolume( map_value, 0);			
		}

		wait(0.05);
	}
}

trophy_system_explosion( args )
{
	// Play 2d Explosion Sound, scaled by players distance.
	dist = distance( self.origin, level.player.origin );
	map_value = aud_map2( dist, level.aud.envs[ "titan_tank_cannon" ] );
	
	titan_trophy_exp = aud_play_linked_sound( "titan_trophy_system_explode", level.player );
	titan_trophy_exp_impact = aud_play_linked_sound( "titan_trophy_system_explode_impact", level.player );
	
	titan_trophy_exp scalevolume( map_value, 0);
	titan_trophy_exp_impact scalevolume( map_value, 0);
}

titan_take_damage_from_smaw( args )
{
	dist = distance( self.origin, level.player.origin );
	map_value = aud_map2( dist, level.aud.envs[ "titan_tank_cannon" ] );
	
	titan_dmg = aud_play_linked_sound( "titan_take_smaw_dmg", self );
	titan_dmg scalevolume( map_value*2, 0);
	titan_pos = (self.origin + (500, 0, 0) );
	
	explo_params = SpawnStruct();
	explo_params.pos 							= titan_pos;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 3000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	
	// Play Amb Exps 
	thread snd_ambient_explosion( explo_params );
	snd_ambient_explosion( explo_params );	
}

titan_death( args )
{
	wait(1);
	
	// Gears/Servos Going Haywire as the tank tries to stay up.
	titan_death_whine_pt_01 = aud_play_linked_sound( "titan_death_whine", self );
	titan_death_whine_pt_02 = aud_play_linked_sound( "titan_take_smaw_dmg_sparks", self );	
	titan_death_whine_pt_03 = aud_play_linked_sound( "titan_servo_move", self );
	titan_death_whine_pt_04 = aud_play_linked_sound( "titan_cannon_hydraulics", self );	
	titan_death_whine_pt_05 = aud_delay_play_linked_sound( "titan_servo_move", self, 3 );
	
	// Wait for big explosion to happen.
	wait( 3.5 );
	
	// Setup Explosion System Params for big titan exp.
	explo_params = SpawnStruct();
	explo_params.pos 							= level.player.origin;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.shake_duration					= 1.5;
	
	// Play Amb Exps 
	snd_ambient_explosion( explo_params );	
	thread snd_ambient_explosion( explo_params );
	
	// Play Additional Close SFX.
	titan_death_exp_main = aud_play_linked_sound( "titan_death_exp_main", self );
	titan_death_exp_mtl = aud_play_linked_sound( "titan_death_exp_mtl_debris", self );
	titan_death_exp_low = aud_play_linked_sound( "titan_death_exp_low", self );
	
	// Delayed Rock Debris
	titan_death_debris_01 = aud_delay_play_linked_sound( "exp_debris_dirt_chunks", self, 1.5 );	
	titan_death_debris_02 = aud_delay_play_linked_sound( "exp_debris_dirt_chunks", self, 2 );	
	
	// Scale volume on 2d explosion sounds based on where the player is.
	death_exp_sounds = [ titan_death_exp_main, titan_death_exp_mtl,  titan_death_exp_low ];
	
	dist = distance( self.origin, level.player.origin );
	map_value = aud_map2( dist, level.aud.envs[ "titan_tank_cannon" ] );
	
	foreach( exp in death_exp_sounds )
	{
		exp setvolume( map_value, 0);
	}
}

titan_footstep_front_left( tank_ent )
{	
	tank_ent thread play_sound_on_tag( "titan_footstep", "frontWheelTread01_FL");
}

titan_footstep_front_right( tank_ent )
{
	tank_ent thread play_sound_on_tag( "titan_footstep", "frontWheelTread01_FR");
}

titan_footstep_rear_left( tank_ent )
{
	tank_ent thread play_sound_on_tag( "titan_footstep_rear", "frontWheelTread05_KL");
}

titan_footstep_rear_right( tank_ent )
{
	tank_ent thread play_sound_on_tag( "titan_footstep_rear", "frontWheelTread05_KR");
}

aud_titan_siege_mode_adj_left_side( tank_ent )
{
	tank_ent thread play_sound_on_tag( "titan_servo_move", "frontWheelTread01_FL");
}

aud_titan_siege_mode_adj_right_side( tank_ent )
{
	tank_ent thread play_sound_on_tag( "titan_servo_move", "frontWheelTread01_FR");
}

aud_titan_siege_mode_adj_left_side_back( tank_ent )
{
	tank_ent thread play_sound_on_tag( "titan_servo_move", "frontWheelTread01_FL");	
}

aud_titan_siege_mode_adj_right_side_back( tank_ent )
{
	tank_ent thread play_sound_on_tag( "titan_servo_move", "frontWheelTread01_FR");
}

// in the interest of time fade out
itiot_fade_out()
{
	fade_time = 2;
	MM_add_submix( "mute_all", fade_time );
}

// in the interest of time fade in
itiot_fade_in()
{
	fade_in = 2;
	MM_clear_submix( "mute_all", fade_in );
}

//////SECURITY ROOM

security_checkpoint_trigger_think()
{
	while( 1 )
	{
		self waittill( "trigger", instigator );
		self thread security_checkpoint_trigger_play_beep(instigator);
		wait 0.05;
	}
}

security_checkpoint_trigger_play_beep(newInstigator)
{
	if(IsDefined(self.instigators))
	{
		if(array_contains(self.instigators, newInstigator))
		{
			return;
		}
	}
	else
	{
		self.instigators = [];
	}

	self.instigators[self.instigators.size] = newInstigator;
	
	ent = aud_create_linked_entity(self);
	ent aud_play("beep_metal_detector_alert");

	while ( newInstigator istouching( self ) )
	{
		wait(0.1);
	}

	self.instigators = array_remove(self.instigators, newInstigator);
	self.instigators = array_removeundefined(self.instigators);
}

start_elevator_zone_audio()
{
	enable_trigger_with_targetname( "audio_elevator_entrance" );			
}

start_dead_guy_foley(corpse)
{
	MM_add_submix("fusion_security_dead_guy");
	aud_delay_play_linked_sound("fus_sec_dead_guy_drop", corpse, 0.6);
	aud_delay_play_linked_sound("fus_sec_dead_guy_brk_spin", level.burke, 0.96);
	aud_delay_play_linked_sound("fus_sec_dead_guy_brk_leave", level.burke, 5.15);
	wait 10.0;
	MM_clear_submix("fusion_security_dead_guy");
}

Sec_Room_Move_To_Elevator()
{
	
	aud_delay_play_linked_sound("fus_sec_room_joker_foley_01", level.joker, 0);
	aud_delay_play_linked_sound("fus_sec_room_carter_foley_01", level.carter, 0);
	aud_delay_play_linked_sound("fus_sec_room_joker_foley_02", level.joker, 2.58);
}
	
Sec_Room_Attach_To_Elevator()
{
	aud_delay_play_linked_sound("fus_sec_room_carter_foley_02", level.carter, 2.87);
	
}
	
Sec_Room_Elevator_Open()
{
	door = getent( "security_room_elevator_doors", "targetname" );
	aud_delay_play_linked_sound("fus_sec_room_elev_pry_open", door, 2.4);
	aud_delay_play_linked_sound("fus_sec_room_carter_foley_03", level.carter, 2.67);
	aud_delay_play_linked_sound("fus_sec_room_joker_foley_03", level.joker, 2.8);
	
}

start_burke_elevator_slide()
{
	MM_add_submix("fusion_security_elevator_burke");
	aud_delay_play_linked_sound("fus_elev_slide_burke_look", level.burke, 2.4);
	aud_delay_play_linked_sound("fus_elev_slide_burke_run", level.burke, 3.6);
	aud_delay_play_linked_sound("fus_elev_slide_burke_jump", level.burke, 5.1);
	aud_delay_play_linked_sound("fus_elev_slide_burke_grab", level.burke, 5.4);
	aud_delay_play_linked_sound("fus_elev_slide_burke_slide", level.burke, 5.9);
	aud_delay_play_linked_sound("fus_elev_slide_burke_land", level.burke, 7.9);
	wait 10.0;
	MM_clear_submix("fusion_security_elevator_burke");
}

start_player_elevator_slide()
{
	MM_add_submix("fusion_security_elevator_player");
	aud_delay_play_2d_sound("fus_elev_slide_plr_jump", 0);	
	aud_delay_play_2d_sound("fus_elev_slide_plr_slide", 1.2);
	wait 6.0;
	MM_clear_submix("fusion_security_elevator_player");
}

////// LAB

start_lab_alarms()
{
	level endon( "stop_lab_alarms" );

	if (IsDefined(level.aud.lab_alarms) && level.aud.lab_alarms)
	{
		return;
	}
	else
	{
		level.aud.lab_alarms = true;
		while( 1 )
		{
			thread play_sound_in_space("alarm_interior_hallway_verb",( 1730, 3044, -445 ));
			thread play_sound_in_space("alarm_interior_hallway_verb",( 1145, 2883, -445 ));
			thread play_sound_in_space("alarm_interior_hallway_verb",( 794, 4173, -445 ));
			thread play_sound_in_space("alarm_interior_hallway_verb",( 1051, 4847, -445 ));
			//thread play_sound_in_space("alarm_interior_hallway_verb",( 1713, 4077, -445 ));
		
			wait(2.5);
		}
	}
}
		
start_pa_emergency_exit()
{
	level endon( "stop_lab_alarms" );
	
	if (IsDefined(level.aud.pa_emergency) && level.aud.pa_emergency)
	{
		return;
	}
	else
	{
		level.aud.pa_emergency = true;
		while( 1 )
		{
			thread play_sound_in_space("fusion_pa_emergencyexit",( 789, 3596, -445 ));
	
			wait(11);	
		}
	}
}
	
start_pa_airlockclosing()
{
	level endon( "stop_lab_alarms" );
	
	if (IsDefined(level.aud.pa_airlock) && level.aud.pa_airlock)
	{
		return;
	}
	else
	{
		level.aud.pa_airlock = true;
		while( 1 )
		{
			thread play_sound_in_space("fusion_pa_airlockclosing",( 1438, 4445, -445 ));
	
			wait(8);
		}
	}
}
	
start_pre_reactor_alarms()
{
	level endon( "stop_lab_alarms" );

	if (IsDefined(level.aud.pre_reactor_alarms) && level.aud.pre_reactor_alarms)
	{
		return;
	}
	else
	{
		level.aud.pre_reactor_alarms = true;
		while( 1 )
		{
			thread play_sound_in_space("alarm_interior_hallway_siren_verb",( 2080, 4817, -445 ));
		
		wait(2.5);
		}
	}
}
	
////// REACTOR ROOM

start_reactor_zone_audio()
{
	wait 6;
	enable_trigger_with_targetname( "audio_reactor_entrance" );		
	
	level endon( "stop_lab_alarms" );

	if (IsDefined(level.aud.reactor_alarm) && level.aud.reactor_alarm)
	{
		return;
	}
	else
	{
		level.aud.reactor_alarm = true;
		while( 1 )
		{
			thread play_sound_in_space("alarm_interior_hall_dist_verb",( 3358, 3350, -300 ));
			thread play_sound_in_space("alarm_interior_hall_dist_verb",( 4474, 3302, -300 ));
			thread play_sound_in_space("alarm_interior_hall_dist_verb",( 3707, 2198, -300 ));
		
		wait(3.5);
		}
	}	
}	

start_airlock_anim_notetracks()
{
	addNotetrack_animSound("carter", "fusion_airlock_opening_approach",			"fus_airlock_carter_comp_strt",			"fus_airlock_carter_comp_strt");
	addNotetrack_animSound("carter", "fusion_airlock_opening_approach",			"fus_airlock_comp_beep_01",			    "fus_airlock_comp_beep_01");	
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_02",			    "fus_airlock_comp_beep_02");
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_03",			    "fus_airlock_comp_beep_03");
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_04",			    "fus_airlock_comp_beep_04");
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_05",			    "fus_airlock_comp_beep_05");
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_06",			    "fus_airlock_comp_beep_06");
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_07",			    "fus_airlock_comp_beep_07");
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_08",			    "fus_airlock_comp_beep_02");
	addNotetrack_animSound("carter", "fusion_airlock_opening_idle",			"fus_airlock_comp_beep_09",			    "fus_airlock_comp_beep_03");
	addNotetrack_animSound("carter", "fusion_airlock_opening",			"fus_airlock_comp_beep_10",			    "fus_airlock_comp_beep_04");
}

start_reactor_airlock_open(door)
{
	MM_add_submix("fusion_reactor_airlock_open");
	
	aud_play_linked_sound("fus_reactor_airlock_open", door);
	
	wait 4.0;
	
	door_loop = aud_play_linked_sound("fus_reactor_airlock_servo_lp", door, "loop", "stop_airlock_door_loop" );
	door_loop ScaleVolume(0.0);
	door_loop thread delaycall(0.05, ::ScaleVolume, 1, 4);
	
	wait 21.0;
	
	aud_play_linked_sound("fus_reactor_airlock_stop", door);
	
	wait 0.5;
	
	level notify("stop_airlock_door_loop");
	
	MM_clear_submix("fusion_reactor_airlock_open");
}

start_reactor_burke_attack()
{
	wait 8.4;
	aud_play_linked_sound("fus_airlock_burke_grab", level.burke);	
	wait 0.7;
	aud_play_linked_sound("fus_airlock_burke_gun_butt", level.burke);
	wait 0.4;
	aud_play_linked_sound("fus_airlock_burke_exo_throw", level.burke);
	wait 1.9;
	aud_play_linked_sound("fus_airlock_burke_gun_up", level.burke);	
}

crane_mach_mvmnt_start(track_inner, track_outer)
{
	track_inner.snd_ent = aud_create_linked_entity(track_inner);
	track_inner.snd_ent aud_play("crane_rctr_mach_start_01");
	track_inner.snd_ent thread crane_check_for_stop_command();

	track_outer.snd_ent = aud_create_linked_entity(track_outer);
	track_outer.snd_ent aud_play("crane_rctr_mach_start_02");
	track_outer.snd_ent thread crane_check_for_stop_command();
}

crane_mach_mvmnt_stop(track_inner, track_outer)
{
	if(IsDefined(track_inner.snd_ent))
	{
		track_inner.snd_ent aud_fade_out(0.5);
		track_inner.snd_ent = undefined;
	}
	if(IsDefined(track_outer.snd_ent))
	{
		track_outer.snd_ent aud_fade_out(0.5);
		track_outer.snd_ent = undefined;
	}
	
	track_inner.snd_ent = aud_create_linked_entity(track_inner);
	track_inner.snd_ent aud_play("crane_rctr_mach_stop_01");
	track_inner.snd_ent thread crane_check_for_stop_command();

	track_outer.snd_ent = aud_create_linked_entity(track_outer);
	track_outer.snd_ent aud_play("crane_rctr_mach_stop_02");
	track_outer.snd_ent thread crane_check_for_stop_command();
}

crane_claw_mvmnt_start(claw)
{
	claw.snd_ent = aud_create_linked_entity(claw);
	claw.snd_ent aud_play("crane_rctr_claw_mvmnt_start");
	claw.snd_ent thread crane_check_for_stop_command();
}

crane_claw_mvmnt_stop(claw)
{
	if(IsDefined(claw.snd_ent))
	{
		claw.snd_ent aud_fade_out(0.5);
		claw.snd_ent = undefined;
	}
	
	claw.snd_ent = aud_create_linked_entity(claw);
	claw.snd_ent aud_play("crane_rctr_claw_mvmnt_stop");
	claw.snd_ent thread crane_check_for_stop_command();
}

crane_claw_drop_start(claw)
{
	claw endon("stop_claw_beep");

	claw PlaySound("crane_rctr_claw_drop_start");
	claw PlayLoopSound("crane_rctr_claw_drop_lp");
	claw thread crane_check_for_stop_command();
	while (true)
	{
		claw PlaySound("crane_rctr_claw_drop_beep");
		wait 1;
	}
}

crane_claw_drop_stop(claw)
{
	claw notify("stop_claw_beep");

	claw StopLoopSound("crane_rctr_claw_drop_lp");
	claw PlaySound("crane_rctr_claw_drop_stop");
	claw thread crane_check_for_stop_command();
}

crane_claw_rise_start(claw)
{
	claw PlaySound("crane_rctr_claw_rise_start");
	claw PlayLoopSound("crane_rctr_claw_rise_lp");
	claw thread crane_check_for_stop_command();
}

crane_claw_rise_stop(claw)
{
	claw StopLoopSound("crane_rctr_claw_rise_lp");
	claw PlaySound("crane_rctr_claw_rise_stop");
	claw thread crane_check_for_stop_command();
}

crane_claw_crate_grab(claw)
{
	claw PlaySound("crane_rctr_claw_grab");
	claw thread crane_check_for_stop_command();
}

crane_claw_crate_release(claw)
{
	claw PlaySound("crane_rctr_claw_release");
	claw thread crane_check_for_stop_command();
}

crane_check_for_stop_command()
{
	self endon("death");

	if(IsDefined(self.hasAudioCheck))
		return;

	self.hasAudioCheck = true;
	level waittill("stop_all_crane_audio");

	if(!IsDefined(self))
	{
		return;
	}

	self StopSounds();
}

reactor_bot_drive_shelf_start(robot)
{
	robot PlayLoopSound("fus_reactor_robot_drive_with_shelf");
}

reactor_bot_drive_shelf_stop(robot)
{
	robot StopLoopSound("fus_reactor_robot_drive_with_shelf");
	robot PlaySound("fus_reactor_robot_stop_with_shelf");
}

reactor_bot_drive_self_start(robot)
{
	robot PlayLoopSound("fus_reactor_robot_drive_no_shelf");
}

reactor_bot_drive_self_stop(robot)
{
	robot StopLoopSound("fus_reactor_robot_drive_no_shelf");
	robot PlaySound("fus_reactor_robot_stop_with_shelf");
}

reactor_bot_turn_shelf(robot)
{
	robot PlaySound("fus_reactor_robot_turn_with_shelf");
	wait (.85);
	robot PlaySound("fus_reactor_robot_lock_in");
		
}

reactor_bot_turn_self(robot)
{
	robot PlaySound("fus_reactor_robot_turn_no_shelf");
	wait (.85);
	robot PlaySound("fus_reactor_robot_lock_in");
}

reactor_bot_shelf_pickup(robot)
{
	robot PlaySound("fus_reactor_robot_shelf_pickup");
}

reactor_bot_shelf_drop(robot)
{
	robot PlaySound("fus_reactor_robot_shelf_drop");
}

reactor_bot_elevator_start_lp(elevator)
{
	elevator ScaleVolume( 0.0, 0.0 );
	elevator PlayLoopSound("fus_reactor_robot_elevator_lp");
	elevator ScaleVolume( 1.0, 1.0 );
}

reactor_bot_elevator_stop_lp(elevator, delayTime)
{
	if (IsDefined(delayTime))
		wait delayTime;

	elevator StopLoopSound("fus_reactor_robot_elevator_lp");
}

reactor_bot_initial_elevator_start(elevator, delayTime)
{
	if (IsDefined(delayTime))
		wait delayTime;

	elevator PlaySound("fus_reactor_robot_elevator_start");
}

reactor_bot_initial_elevator_stop(elevator, delayTime)
{
	if (IsDefined(delayTime))
		wait delayTime;

	elevator PlaySound("fus_reactor_robot_elevator_stop");
}

reactor_bot_final_elevator_start(elevator, delayTime)
{
	if (IsDefined(delayTime))
		wait delayTime;

	//elevator PlaySound("fus_reactor_robot_elevator_start");
	elevator PlaySound("fus_reactor_robot_elevator_door_close");
}

reactor_bot_final_elevator_stop(elevator, delayTime)
{
	
	
	if (IsDefined(delayTime))
		wait delayTime;

	//elevator PlaySound("fus_reactor_robot_elevator_stop");
	
}

reactor_bot_elevator_open(gate)
{
	gate PlaySound("fus_reactor_robot_elevator_door_open");
	
}

////// POST REACTOR HALLWAY

start_pa_codered()
{
	level endon( "stop_lab_alarms" );
	
	if (IsDefined(level.aud.pa_codered) && level.aud.pa_codered)
	{
		return;
	}
	else
	{
		level.aud.pa_codered = true;
		while( 1 )
		{
			thread play_sound_in_space("fusion_pa_codered",( 3798, 331, -430 ));
	
			wait(12);
		}
	}
}

start_alarm_post_reactor()
{
	level endon( "stop_lab_alarms" );

	if (IsDefined(level.aud.post_reactor_alarm) && level.aud.post_reactor_alarm)
	{
		return;
	}
	else
	{
		level.aud.post_reactor_alarm = true;
		while( 1 )
		{
			thread play_sound_in_space("alarm_interior_hallway_siren_verb",( 4670, 106, -445 ));
			
			wait(2.5);
		}
	}	
}
		
////// TURBINE ELEVATOR

disable_turbine_elevator_trigger()
{
	disable_trigger_with_targetname( "audio_turbine_elevator_top" );
}

start_turbine_elevator()
{
	//Sets up notetrack for cover deploy.
	addNotetrack_customFunction("joker", 	"aud_start_cover_deploy",		::aud_start_cover_deploy,			"turbine_elevator_enter");
	
	thread start_turbine_elevator_alarm();
	MM_add_submix("fusion_turbine_elevator");
	wait 0.2;
	thread play_sound_in_space("fus_elev_door_close",( 4676, 787, -445 ));
	wait 5.1;
	level.aud.elev_ride = aud_create_entity((0, 0, 0));
	level.aud.elev_ride aud_fade_in( "fus_elev_ride_lp", 0.35, true);
	
}

stop_turbine_elevator()
{
	thread play_sound_in_space("fus_elev_door_open",( 4862, 960, -95 ));
	
	if(IsDefined(level.aud.elev_ride))
	{
		level.aud.elev_ride aud_fade_out(0.5);
		level.aud.elev_ride = undefined;
	}
	
	wait 2.5;
	MM_clear_submix("fusion_turbine_elevator", 1.0);
}

start_turbine_elevator_alarm()
{
	wait 1.1;
	aud_play_2d_sound("fus_elev_door_alarm");
	wait 0.83;
	aud_play_2d_sound("fus_elev_door_alarm");
	wait 0.83;
	aud_play_2d_sound("fus_elev_door_alarm");
}

aud_start_cover_deploy(ent)
{
	aud_delay_play_linked_sound( "fus_elev_cover_prepare", level.joker, 0.85 );
	aud_delay_play_linked_sound( "fus_elev_cover_deploy_01", level.joker, 1.88 );
	aud_delay_play_linked_sound( "fus_elev_cover_stretch", level.joker, 2.8 );
	aud_delay_play_linked_sound( "fus_elev_cover_deploy_02", level.joker, 4.86 );
	aud_delay_play_linked_sound( "fus_elev_cover_activate", level.joker, 5.75 );
}

////// TURBINE ROOM

start_turbine_loop()
{
	wait 0.5;
		
	//turbine_1
	turbine_1_01 = getstruct( "turbine_1_sound_source_upper", "targetname");
	thread play_loopsound_in_space( "fus_turbine_upper_01", turbine_1_01.origin );
	turbine_1_02 = getstruct( "turbine_1_sound_source_lower", "targetname");
	thread play_loopsound_in_space( "fus_turbine_01", turbine_1_02.origin );
	
	//turbine 1 mech close
	thread play_loopsound_in_space( "fus_turbine_mech_parts_close", ( 5393, 960, 3 ));
	
	
	//turbine_2
	turbine_2_01 = getstruct( "turbine_2_sound_source_upper", "targetname");
	thread play_loopsound_in_space( "fus_turbine_upper_02", turbine_2_01.origin );
	turbine_2_02 = getstruct( "turbine_2_sound_source_lower", "targetname");
	thread play_loopsound_in_space( "fus_turbine_02", turbine_2_02.origin );
	
	//turbine 2 mech close
	thread play_loopsound_in_space( "fus_turbine_mech_parts_close", ( 6020, 1398, 3 ));
	
	//turbine_3 - damaged
	turbine_3_01 = getstruct( "turbine_3_sound_source_upper", "targetname");
	level.aud.damaged_turbine_1 = play_loopsound_in_space( "fus_turbine_damaged", turbine_3_01.origin );
	turbine_3_02 = getstruct( "turbine_3_sound_source_lower", "targetname");
	level.aud.damaged_turbine_2 = play_loopsound_in_space( "fus_turbine_damaged", turbine_3_02.origin );
	play_loopsound_in_space( "fus_turbine_upper_02", ( 6967, 1920, 140 ) );
	
	AZM_start_zone( "fusion_turbine_elevator_loud", 0.5 );
	
	enable_trigger_with_targetname( "audio_turbine_elevator_top" );
}

turbine_pre_explo()
{
	MM_add_submix ("fusion_turbine_room_expl");
	thread aud_play_2d_sound ("turbine_pre_expl_2d_lr");
	thread play_sound_in_space ("turbine_pre_expl_3d_01", (6701.75, 1845.58, 115.563));
	MM_clear_submix ("fusion_turbine_room_expl", 0.35);
	
	wait (0.4);
	
	MM_add_submix ("fusion_turbine_room_expl");
	thread play_sound_in_space ("turbine_pre_expl_3d_02", (7000.59, 1638, 91.9606));
	MM_clear_submix ("fusion_turbine_room_expl", 0.35);
	
}
	
turbine_explo()
{

	MM_add_submix ("fusion_turbine_room_expl");
	thread aud_play_2d_sound ("turbine_expl_2d_lr");
	wait (.2);
	thread aud_play_2d_sound ("turbine_expl_2d_lfe");
	thread play_sound_in_space ("turbine_expl_3d_01", (6701.75, 1845.58, 115.563));
	wait (.1);
	thread play_sound_in_space ("turbine_expl_3d_02", (7000.59, 1638, 91.9606));
	wait (0.5);
	MM_clear_submix ("fusion_turbine_room_expl", 1.0);
	wait (0.75);
	
	turbine_3_01 = getstruct( "turbine_3_sound_source_upper", "targetname");
	turbine_3_02 = getstruct( "turbine_3_sound_source_lower", "targetname");
	thread play_sound_in_space ("turbine_expl_windup", turbine_3_02.origin);
	level.aud.damaged_turbine_1 StopLoopSound();
	level.aud.damaged_turbine_2 StopLoopSound();
	level.aud.damaged_turbine_1 Delete();
	level.aud.damaged_turbine_2 Delete();
	wait(4);
	play_loopsound_in_space( "turbine_expl_post_lp", turbine_3_02.origin );
	play_loopsound_in_space( "turbine_expl_post_lp_top", turbine_3_01.origin );

}

////// POST TURBINE HALLWAY

start_pa_emergency_turbine()
{
	level endon( "stop_pa_turbine" );
	
	if (IsDefined(level.aud.pa_emergency_turbine) && level.aud.pa_emergency_turbine)
	{
		return;
	}
	else
	{
		level.aud.pa_emergency_turbine = true;
		while( 1 )
		{
			thread play_sound_in_space("fusion_pa_emergencyexit",( 7231, 2847, 267 ));
	
			wait(9);	
		}
	}
}

start_turbine_door_breach()
{
	thread control_room_foley_notetracks();
	
	MM_add_submix ("fusion_turbine_door_breach");
	wait 1.72;
	aud_play_linked_sound("door_trbn_rm_exo_pnch", level.carter);
	wait 0.28;
	play_sound_in_space( "door_trbn_rm_breach", ( 7234, 2736, 228 ));
}

start_turbine_door_impt(door_left, door_right)
{
	wait 2.2;
	aud_play_linked_sound("door_trbn_rm_impt_left", door_left);
	wait 0.25;
	aud_play_linked_sound("door_trbn_rm_impt_right", door_right);
	MM_clear_submix ("fusion_turbine_door_breach", 1.0);
}

////// CONTROL ROOM & HANGAR

control_room_foley_notetracks()
{
	addNotetrack_customFunction("burke", 	"aud_start_burke_ctrl_rm_start",			::burke_cr_foley_start,				"fusion_door_explosion");
	addNotetrack_customFunction("burke", 	"aud_start_burke_ctrl_rm_enter",			::burke_cr_foley_enter,				"fusion_door_explosion");
	addNotetrack_customFunction("burke", 	"aud_start_burke_ctrl_rm_idle",			::burke_cr_foley_idle,				"control_room_idle");
	addNotetrack_customFunction("burke", 	"aud_start_burke_ctrl_rm_console",			::burke_cr_foley_console,				"control_room_scene");
	
	addNotetrack_customFunction("carter", 	"aud_start_carter_ctrl_rm_start",			::carter_cr_foley_start,				"fusion_door_explosion");
	addNotetrack_customFunction("carter", 	"aud_start_carter_ctrl_rm_idle",			::carter_cr_foley_idle,				"control_room_idle");
}

burke_cr_foley_start(ent)
{
	aud_delay_play_linked_sound( "fus_cr_burke_explo_foley", level.burke, 3.07 );	
}

burke_cr_foley_enter(ent)
{
	aud_delay_play_linked_sound( "fus_cr_burke_to_console_foley", level.burke, 0.75 );
}

burke_cr_foley_idle(ent)
{
	aud_delay_play_linked_sound( "fus_cr_burke_idle_foley_lp", level.burke, 0.0 );
}

burke_cr_foley_console(ent)
{
	aud_delay_play_linked_sound( "fus_cr_burke_console_foley", level.burke, 0.075 );
	aud_delay_play_linked_sound( "fus_cr_burke_away_foley", level.burke, 35.163 );
	
	aud_delay_play_linked_sound( "fus_cr_carter_end_walk_foley", level.carter, 26.191 );
	aud_delay_play_linked_sound( "fus_cr_carter_leave_foley", level.carter, 42.172 );
	
	aud_delay_play_linked_sound( "fus_cr_joker_console_foley", level.joker, 2.581 );
	aud_delay_play_linked_sound( "fus_cr_joker_grab_foley", level.joker, 25.581 );
	aud_delay_play_linked_sound( "fus_cr_joker_leave_foley", level.joker, 21.662 );
}

carter_cr_foley_start(ent)
{
	aud_delay_play_linked_sound( "fus_cr_carter_explo_run_foley", level.carter, 3.485 );
	aud_delay_play_linked_sound( "fus_cr_carter_bodyfall_foley", level.carter, 9.776 );
	aud_delay_play_linked_sound( "fus_cr_carter_get_up_foley", level.carter, 14.061 );
	aud_delay_play_linked_sound( "fus_cr_carter_to_console_foley", level.carter, 16.465 );
	aud_delay_play_linked_sound( "fus_cr_carter_pre_idle_foley", level.carter, 29.162 );
}

carter_cr_foley_idle(ent)
{
	aud_delay_play_linked_sound( "fus_cr_carter_idle_foley_01", level.carter, 1.103 );
	aud_delay_play_linked_sound( "fus_cr_carter_idle_foley_02", level.carter, 4.974 );
}


start_control_room_explo()
{
	MM_add_submix( "fusion_control_rm_explo" );
	
	explosionEnt = aud_create_entity((7000, 3540, 168));
	explosionEnt.angles = VectorToAngles( explosionEnt.origin - level.player.origin ); 
	explosionEnt aud_play("fus_cntrl_rm_door_explo");
	explosionEnt waittill( "sounddone" );
	
	MM_clear_submix( "fusion_control_rm_explo" );
}

start_pre_loading_bay(args)
{
	thread start_loading_bay_alarms();
	thread start_control_room_alarms();
	thread trigger_bomb_shake();
	
	if ( !flag( "aud_alarm_outside_started" ) )
	{
		thread start_outside_alarm();
	}
}

hangar_explo_and_debris_01()
{
	pos_0 = ( 6564,5343,61 );
	//thread play_sound_in_space( "hangar_ceiling_explode", level.player.origin );
	explo_params = SpawnStruct();
	explo_params.pos 							= pos_0;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 50;
	explo_params.shake_dist_threshold_ 			= 2000;
 
	snd_ambient_explosion( explo_params );

	thread play_sound_in_space( "hangar_glass_shatter_rain", pos_0 );

	wait(0.4);
	thread play_sound_in_space( "hangar_glass_shatter_01", pos_0 );
}

hangar_explo_and_debris_02( args )
{
	exp_num = args;
	
	exp_ent = aud_find_exploder(exp_num);
	if(IsDefined(exp_ent))
	{
		assert(IsDefined(exp_ent.v));
		exploder_pos = exp_ent.v["origin"];
		assert(IsDefined(exploder_pos));
	}
	
	// Locations
	pos_0 = ( 6480,5522,94 );	//Floating 'Glue' in center of event.
	pos_1 = ( 6302,5684,-49 );	//Glass on Concrete.
	pos_2 = ( 6442,5347,4 );	//Glass on Concrete.
	pos_3 = ( 6564,5343,61 );	//Glass on Staircase.
	pos_4 = ( 6682,5600,-59 );	//Glass on Concrete.
	
	//thread play_sound_in_space( "hangar_ceiling_explode", level.player.origin );
	explo_params = SpawnStruct();
	explo_params.pos 							= pos_0;
	explo_params.speed_of_sound_	 			= true;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 50;
	explo_params.shake_dist_threshold_ 			= 2000;
 
	snd_ambient_explosion( explo_params );
	
	thread play_sound_in_space( "hangar_glass_shatter_rain", pos_0 );

	wait(0.4);
	thread play_sound_in_space( "hangar_glass_shatter_01", pos_1 );
	thread play_sound_in_space( "hangar_glass_shatter_02", pos_2 );

	wait(1.2);
	thread play_sound_in_space( "hangar_glass_shatter_03", pos_3 );
	thread play_sound_in_space( "hangar_glass_shatter_01", pos_4 );
	thread play_sound_in_space( "hangar_glass_shatter_02", pos_3 );
}

hangar_transport_01_away(transport_01)
{
	transport_01.snd_disable_vehicle_system = true;
	
	MM_add_submix( "fusion_hangar_exit_helos", 0 );

	aud_play_linked_sound("mi17_hangar_transport_01_away", transport_01);
	aud_play_2d_sound( "mi17_hangar_transport_01_away_2d" );
	
	wait(6.5);
	MM_clear_submix( "fusion_hangar_exit_helos", .1);	
		
	
	wait(1.5);
	
	transport_01.snd_disable_vehicle_system = false;
}

hangar_transport_flying_01_away(transport_flying_01)
{
	transport_flying_01.snd_disable_vehicle_system = true;
	
	wait(.3);
	
	aud_play_linked_sound("mi17_hangar_transport_flying_01_away", transport_flying_01);	

	wait(4.5);
	
	transport_flying_01.snd_disable_vehicle_system = false;
}

hangar_transport_flying_02_away(transport_flying_02)
{
	transport_flying_02.snd_disable_vehicle_system = true;
	
	wait(.75);
	
	aud_play_linked_sound("mi17_hangar_transport_flying_02_away", transport_flying_02);		

	wait(3.7);
	
	transport_flying_02.snd_disable_vehicle_system = false;
}

extraction_chopper_spawn()
{
	warbird = self;
	assert(IsDefined(warbird));
	
	MM_add_submix( "fusion_extraction_warbird", 2, true );

	warbird thread snd_air_vehicle_smart_flyby("fus_warbird_extract_flyby", 4000);

	aud_play_linked_sound("fus_warbird_extract_engine", warbird);
	aud_delay_play_linked_sound("fus_warbird_extract_turn", warbird, 5.2);

	wait(12);
	//Warbird 3d Chop Loop
	warbird_chop = aud_play_linked_sound("fus_warbird_extract_chop_lp", warbird, "loop", "stop_warbird_chop", (0, 0, 0), 0);
	warbird_chop ScaleVolume(0.0);
	warbird_chop thread delaycall(0.05, ::ScaleVolume, 1.0, 4);
	
	level waittill( "aud_extract_warbird_move" );

	//Play Warbird Depart
	aud_play_linked_sound("fus_warbird_extract_move", warbird);

	//Stop Warbird 3d Loop	
	warbird_chop ScaleVolume(0, 5);
	wait (5.05);
	level notify("stop_warbird_chop");
}

extraction_chopper_move()
{
	//IPrintLnBold( "AUDIO: Warbird Extraction Move" );
	level notify( "aud_extract_warbird_move");
	snd_music_message( "mus_pre_tower_collapse_build" );	
}

building_explode( location )
{
	thread play_sound_in_space("building_explode", location );

	explo_params = SpawnStruct();
	explo_params.pos 							= location;
	explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
	explo_params.duck_dist_threshold_ 			= 1000;
	explo_params.explo_delay_chance_ 			= 100;
	explo_params.shake_dist_threshold_ 			= 2000;
	explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	explo_params.ground_zero_alias_ 			= "exp_grnd_zero_stone"; 
	explo_params.ground_zero_dist_threshold_ 	= 500; 
 
	snd_ambient_explosion( explo_params );
}

//////FUSION ESCAPE

pressure_explosion(args)
{
	exp_num = args;
	
	exp_ent = aud_find_exploder(exp_num);
	if(IsDefined(exp_ent))
	{
		assert(IsDefined(exp_ent.v));
		pos = exp_ent.v["origin"];
		assert(IsDefined(pos));

		explo_params = SpawnStruct();
		explo_params.pos 							= pos;
		explo_params.duck_alias_ 					= "exp_generic_explo_sub_kick"; 
		explo_params.duck_dist_threshold_ 			= 1000;
		explo_params.explo_delay_chance_ 			= 100;
		explo_params.shake_dist_threshold_ 			= 2000;
		explo_params.explo_debris_alias_ 			= "exp_debris_dirt_chunks";
	 
		snd_ambient_explosion( explo_params );		
	}
}

fus_truck_flip_01( args )
{
	exp_num = args;
	
	exp_ent = aud_find_exploder(exp_num);
	if(IsDefined(exp_ent))
	{
		assert(IsDefined(exp_ent.v));
		pos = exp_ent.v["origin"];
		assert(IsDefined(pos));
		
		//Play Pressure Explosion.
		big_boom = aud_play_2d_sound( "fus_truck_flip_exp");
		big_boom_lfe = aud_play_2d_sound( "fus_truck_flip_exp_lfe_big" );
		
		//Play Debris
		thread play_sound_in_space("fus_truck_flip_exp_debris", pos);
		
		//Play 3d Steam Sound on Now Broken Pipe.
		steam_pos = (9681, 9270, -12);
		DAMB_start_preset_at_point("air_pressure_leak_large", steam_pos, "air_pressure_truck_flip_01");
		
		wait(0.65);
		
		truck_impact_pos = (10201, 8959, 75);
		
		thread play_sound_in_space("fus_truck_flip_impact", truck_impact_pos);
	}
}


fus_truck_flip_02( args )
{	
	exp_num = args;
	
	exp_ent = aud_find_exploder(exp_num);
	if(IsDefined(exp_ent))
	{
		assert(IsDefined(exp_ent.v));
		pos = exp_ent.v["origin"];
		assert(IsDefined(pos));
		
		//Play Pressure Explosion
		thread play_sound_in_space("fus_truck_flip_02_exp", pos);
		big_boom_lfe = aud_play_2d_sound( "fus_truck_flip_exp_lfe_big" );
		
		//Play Debris
		thread play_sound_in_space("fus_truck_flip_exp_debris", pos);
		
		//Play 3d Steam Sound on Now Broken Pipe.
		steam_pos = (11578, 9038, -52);
		DAMB_start_preset_at_point("air_pressure_leak_large", pos, "air_pressure_truck_flip_02");
		
		wait(0.8);
		
		land_pos = ( 11544, 8868, 18 );
		thread play_sound_in_space("fus_truck_flip_02_impact", land_pos);	
	}
}

start_gaz_02_retreat(args)
{
	
	args.snd_disable_vehicle_system = true;	

	level.aud.gaz_02 = aud_create_linked_entity (args);
	level.aud.gaz_02 aud_play("veh_gaz_tigr_pull_away_fusion_01");
	
	wait(4.5);
	
	args.snd_disable_vehicle_system = false;
		
}

start_gaz_03_retreat(args)
{
	
	args.snd_disable_vehicle_system = true;	

	level.aud.gaz_03 = aud_create_linked_entity (args);
	level.aud.gaz_03 aud_play("veh_gaz_tigr_pull_away_fusion_02");
	
	wait(5.0);
	
	args.snd_disable_vehicle_system = false;
		
}

tower_collapse_prep()
{
	MM_add_submix( "fusion_tower_collapse", 0.05 );
	snd_music_message( "mus_tower_collapse_start" );	
	aud_delay_play_2d_sound( "fus_tower_explo_shot_12", 0.104 ); //secondaryaliasname: fus_tower_reverse_rubble.
	aud_delay_play_2d_sound( "fus_tower_explo_shot_08", 0.382 );
	aud_delay_play_2d_sound( "fus_tower_explo_shot_06", 0.687 ); //secondaryaliasname: fus_tower_pre_explode.
	aud_delay_play_2d_sound( "fus_tower_explo_shot_07", 0.837 );
}

tower_collapse_start()
{
	aud_play_2d_sound( "fus_tower_explo_sweet_lfe" );
	aud_delay_play_2d_sound( "fus_tower_big_boom", 0.130 );
	aud_delay_play_2d_sound( "fus_tower_bass_dive", 0.394 ); //secondaryaliasname: fus_tower_slomo_rubble.
	aud_delay_play_2d_sound( "fus_tower_1st_wave_rubble", 1.445 ); //secondaryaliasname: fus_tower_whoosh.
	aud_delay_play_2d_sound( "fus_tower_rip_whoosh_front", 1.888 ); //secondaryaliasname: fus_tower_1st_wave_sub.
}

tower_collapse_player_stumble()
{
	thread tower_collapse_dialog();
	
	aud_delay_play_2d_sound( "fus_tower_1st_wave_debris_front", 0.538 ); //secondaryaliasname: fus_tower_bodyfall.
	//STREAMED aud_delay_play_2d_sound( "fus_tower_rock_rips_front", 3.616 );
	aud_delay_play_2d_sound( "fus_tower_chunk_impacts", 6.138 ); //secondaryaliasname: fus_tower_chunks_sub_sweet.
	aud_delay_play_2d_sound( "fus_tower_chunk_impact_left", 8.458 );
	//STREAMED aud_delay_play_2d_sound( "fus_tower_2nd_wave_debris_front", 11.181 );
	aud_delay_play_2d_sound("fus_tower_chunk_impact_right", 11.612 );
	aud_delay_play_2d_sound("fus_tower_2nd_wave_rvrs_rubble", 14.946 );
	
	rock_rips = spawn( "script_origin", level.player.origin );
	rock_rips aud_prime_stream( "fus_tower_rock_rips_front" );
	wait( 3.616 );
	isprimed = rock_rips aud_is_stream_primed( "fus_tower_rock_rips_front" );
	assert( isprimed );
	rock_rips playsound( "fus_tower_rock_rips_front" );
	
	wait( 4 );

	second_wave_debris = spawn( "script_origin", level.player.origin );
	second_wave_debris aud_prime_stream( "fus_tower_2nd_wave_debris_front" );	
	wait( 3.565 );
	isprimed = second_wave_debris aud_is_stream_primed( "fus_tower_2nd_wave_debris_front" );
	assert( isprimed );
	second_wave_debris playsound( "fus_tower_2nd_wave_debris_front" );
}

tower_collapse_dialog()
{
	//////////////////////////////////////////////////
	/// Moving the triggering of all collapse dialog from dialog_collapse() in fusion_code.gsc.
	/// Purpose of move is to coordinate the timing of each dialog alias with the collapse SFX.  
	/// Also, applying DSP filters on dialog that needs to be timed with the collapse SFX.
	/// -Swenson
	/////////////////////////////////////////////////
	snd_enable_filters();
	snd_fade_in_filter( "fus_tower_collapse_800", 3.0 );
	wait( 1.733 );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_plt1_doyoucopy" );
	snd_fade_out_filter( 2.35 );
	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_keepmovingkeepmoving" );
	snd_fade_in_filter( "fus_tower_collapse_800", 0.05 );
	wait( 0.5 );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_hqr_massiveexplosionnorth" );
	snd_fade_out_filter( 0.05 );
	wait( 0.6 );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_jkr_itscomingdown" );
	snd_fade_in_filter( "fus_tower_collapse_800", 0.05 );
	wait( 1.1 );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_jkr_wherescarter" );
	snd_fade_out_filter( 0.05 );
	wait( 0.15 );
	snd_fade_in_filter( "fus_tower_collapse_1000", 0.05 );
	maps\fusion_vo::radio_dialogue_queue_global ( "fusion_plt1_bravotakecover" );
	snd_fade_out_filter( 0.05 );
}

tower_collapse_player_knockback()
{
	aud_delay_play_2d_sound( "fus_tower_teleport_impact", 4.102 );
	aud_delay_play_2d_sound( "fus_tower_mtl_chunk_flip", 6.032 );
	aud_delay_play_2d_sound( "fus_tower_mtl_impact", 6.842 );
	aud_delay_play_2d_sound( "fus_tower_mtl_sweet_front", 6.842 );
	aud_delay_play_2d_sound( "fus_tower_end_burk_debris", 14.965 );
	//STREAMED aud_delay_play_2d_sound( "fus_tower_filtered_warbird_front", 17.818 );
	wait( 1.178 );
	thread snd_music_message( "mus_tower_collapse_ending_guitar" );

	wait ( 10 );
	MM_clear_submix("fusion_tower_collapse", 4);
	
	wait( 3.822 );
	warbird = spawn( "script_origin", level.player.origin );
	warbird aud_prime_stream( "fus_tower_filtered_warbird_front" );
	wait( 2.818 );
	isprimed = warbird aud_is_stream_primed( "fus_tower_filtered_warbird_front" );
	assert( isprimed );
	warbird playsound( "fus_tower_filtered_warbird_front" );
}
	
silo_collapse_plr_stunned()
{
	fade_time = 6.0;
	
//	RVB_start_preset( "fusion_silo_collapse_plr_stunned", fade_time );
	
//	verb_priority	= "snd_enveffectsprio_level";
//	verb_type		= "arena";
//	verb_dry_level	= 0.5;
//	verb_wet_level	= 0.5;
//	level.player SetReverb(verb_priority, verb_type, verb_dry_level, verb_wet_level, fade_time);
	
	snd_enable_filters();
	snd_fade_in_filter( "fus_silo_collapse_plr_stunned", fade_time );
	
	wait 3.0;
	loop_entity = Spawn("script_origin", (0,0,0));
	aud_fade_sound_in( loop_entity, "fus_end_heartbeat", 1.0, 4.0, true );

	wait 3.0;
	MM_add_submix( "fusion_silo_collapse_plr_stunned", 6.0 );
}


fus_outro_burke_foley()
{
	aud_delay_play_2d_sound("fus_out_burke_foley_01", 10.8);
	aud_delay_play_2d_sound("fus_out_burke_foley_02", 16.2);
	aud_delay_play_2d_sound("fus_out_burke_foley_03", 20.0);
	aud_delay_play_2d_sound("fus_out_burke_foley_04", 22.15);
	aud_delay_play_2d_sound("fus_out_burke_foley_05", 22.8);
	aud_delay_play_2d_sound("fus_out_burke_foley_06", 26.87);
	aud_delay_play_2d_sound("fus_out_burke_foley_07", 31.93);
	aud_delay_play_2d_sound("fus_out_burke_foley_08", 38.52);	
}

ending_fade_out(fade_time)
{
	// Stubbed.  
}

fusion_endlogo()
{
	aud_play_2d_sound("fus_end_logo");
	MM_add_submix("fusion_end_logo", 12.0);
	wait 0.05;
	MM_set_default_volmod("scripted5", 1.0, 0.05);	// Plays over end logo video;  needs to start at 1.0 while everything else fades out.
}


/***************************************/
/******** MUSIC MESSAGE HANDLER ********/
/***************************************/

snd_music_handler(message)
{
	// MUS API:  MUS_play(alias, fade_in_time_, cross_fade_out_time_, volume_, forceplay_)
	
	switch (message)
	{
		case "mus_fusion_intro":
		{
			wait(0.45);
			aud_set_music_submix( 0.75, 0 );
			MUS_play( "mus_fusion_intro", 0 );
			wait (2);
			aud_set_music_submix( 0.5, 6 );
		}
		break;
		case "mus_fusion_first_contact":
		{
			aud_set_music_submix( 1.0, 10 );
			MUS_play( "mus_fusion_first_contact", 0, 3 );
			wait( 15 );
			aud_set_music_submix( 0.75, 10 );
			wait( 15 );
			aud_set_music_submix( 0.5, 10 );
		}
		break;
		case "mus_combat_zip_rooftop_complete":
		{
			//IPrintLnBold( "AUDIO: Music Fade Start" );
			MUS_stop( 15 );
			level notify("aud_roof_combat_complete");
			wait( 15 );
			aud_set_music_submix( 1.0, 0 );
		}
		break;
		case "mus_fusion_welcome_to_the_party":
		{
			aud_set_music_submix( 1.0, 0 );
			MUS_play( "mus_fusion_welcome_to_the_party", 0, 3.0 );
		}
		break;
		case "mus_fusion_pressure_readings_critical":
		{
			aud_set_music_submix( 0.3, 0.05 );
			wait 0.1;
			MUS_play( "mus_fusion_first_contact", 0, 3 );
			aud_set_music_submix( 1, 30 );
		} 
		break;
		case "mus_pre_tower_collapse_build":
		{
			//MUS_play( "bs_tmp_fusion_silo_climax", 4.0, 6.0 ); //This music cue is ~12 seconds long with the climax happening at ~11 seconds. 
			//MUS_play( "mus_fusion_silo_collapse", 4.0 );  //No longer playing the Tower Collapse music aliases as a single music cue.  Playing as two seperate aliases.  The 2nd "Guitar" alias is triggered in the Big Moment SFX sequence.
		}
		break;
		case "mus_tower_collapse_start":
		{
			MUS_stop( 0.5 ); //Stops music at the moment the tower collapse explosions begin.
		}
		break;
		case "mus_tower_collapse_ending_guitar":
		{
			MUS_play( "bs_tmp_fusion_silo_guitar", 4.0 );
		}
		break;
		default:
		{
			aud_print_warning("\tMUSIC MESSAGE NOT HANDLED: " + message);
		}
		break;
	}
}

/********************************************************************
	Note-Track Set-Up & Handlers.
********************************************************************/
/////////////////////////
//INTRO FLIGHT VO 
////////////////////////
setup_pcap_vo()
{
	addNotetrack_customFunction("burke", 	"aud_start_fusion_fly_in_intro",			::aud_start_fusion_fly_in_intro,				"fly_in_intro");
	addNotetrack_customFunction("burke", 	"aud_start_fusion_fly_in_pt2",				::aud_start_fusion_fly_in_pt2,					"fly_in_part2");
	addNotetrack_customFunction("burke",	"aud_start_fusion_controlroom_dialog",		::aud_start_fusion_controlroom_dialog_burke, 	"control_room_scene");
	addNotetrack_customFunction("joker",	"aud_start_fusion_controlroom_dialog",		::aud_start_fusion_controlroom_dialog_joker, 	"control_room_scene");
	addNotetrack_customFunction("burke", 	"aud_start_fusion_scene5_burke_rescue",		::aud_start_fusion_scene5_burke_rescue,			"fusion_silo_collapse_finale");
	
	//DEPRECATED
	//addNotetrack_customFunction("burke", 	"aud_start_fusion_scene4_reactor_fadeup",	::aud_start_fusion_scene4_reactor_fadeup,		"reactor_talk");
}

// Game VO
intro_fly_in_vo()
{
	wait 5.2;
	level notify("heli_intro_burke_foley");
	radio_dialogue_queue( "fusion_plt1_315magnetic" ); 						//Two-one, we're bearing three one five magnetic at angels twelve, distance two nautical miles from the target, over.
	wait 1.0;
	radio_dialogue_queue( "fusion_plt2_enemypax" );
}

// PCAP VO
aud_start_fusion_fly_in_intro(param)
{
	ent = param;
	
	ent aud_play_pcap_vo("fusion_brk_staticondisplay",		14.39);
	
	ent aud_play_pcap_vo("fusion_hqr_signaldistortion",		17.00);
	
	ent aud_play_pcap_vo("fusion_brk_everyoneseeingthis",	21.57);
	
	ent aud_play_pcap_vo("fusion_jkr_gotit",				24.57);		//DelayThread( 25, ::radio_dialogue_queue, "fusion_jkr_gotit" );
	
	ent aud_play_pcap_vo("fusion_brk_meltdownscenario",		26.18);
	ent aud_play_pcap_vo("fusion_brk_shitendsnoprisoners",	33.15);
	ent aud_play_pcap_vo("fusion_brk_getinposition",		37.42);
	
	// Signal that pcap vo is done.  (TODO: would be a nice feature to be able to pass a flag into aud_play_pcap_vo() to automatically be set when the alias is done.)
	wait(40);
	flag_set("aud_start_fusion_fly_in_intro_vo_done");
}

// PCAP VO
aud_start_fusion_fly_in_pt2(param)
{
	ent = param;
	ent aud_play_pcap_vo("fusion_brk_panama", 4.15);
	
	wait(9);
	flag_set("aud_start_fusion_fly_in_pt2_vo_done");
}

// Game VO
intro_fly_in_part2_vo()
{
	flag_wait("aud_start_fusion_fly_in_intro_vo_done");
	wait 4.75;	
	radio_dialogue_queue( "fusion_plt3_disengagingstealth" ); 				//Chopper 3: Disengaging stealth.
	wait 2.25;
	radio_dialogue_queue( "fusion_plt3_restrictedroe" ); 					//Chopper 3: Two-three, understand we are still operating under a restricted ROE, over?
	radio_dialogue_queue( "fusion_plt1_prosecutetargets" ); 				//Chopper 1: Negative on that restricted ROE, two-four, we are free to prosecute all targets, over.
	
	flag_wait("aud_start_fusion_fly_in_pt2_vo_done");
	
	wait 7.12;
	radio_dialogue_queue( "fusion_plt1_visualonplant" ); 					//Chopper 1: Two-four, we've got a SAM launch at our twelve o'clock, over.
	//CUT radio_dialogue_queue( "fusion_plt2_copythat" ); 						//Chopper 2: Copy that two-three.
	
	wait 0.37;
	thread radio_dialogue( "fusion_plt1_swarmcountermeasures" ); 			//Chopper 1: Contact, contact! Deploying SWARM countermeasures.
	wait 2.34;
	level.burke thread dialogue_queue( "fusion_brk_holdon" ); 		//Burke: Hold on!
	//CUT level.joker_intro dialogue_queue( "fusion_jkr_shit" ); 				//Joker: Shit!

	wait 1.0;
	radio_dialogue_queue( "fusion_plt3_tryingtostabilize" ); 				//Chopper 3: Wraith two-three, we're hit, we're hit! Trying to stabilize---!
	wait 1.0;
	radio_dialogue_queue( "fusion_plt1_twofourisdown" );					//Chopper 1: Two-four is down, two-four is down. 
	
	//CUT level.joker_intro dialogue_queue( "fusion_jkr_theymakeit" ); 			//Joker: Did they make it?
	//CUT level.burke_intro dialogue_queue( "fusion_brk_nothingwecando" );		//Burke: Eyes forward, nothing we can do! Get ready to deploy!
	radio_dialogue_queue( "fusion_plt1_24providesupport" ); 				//Chopper 1: Two-four, break position and provide support for Alpha, over.
	wait 0.15;
	radio_dialogue_queue( "fusion_plt4_copythat23" ); 						//Chopper 4: Copy that two-three.
	
	wait 0.58;
	flag_set( "flag_rooftop_combat_dialogue" );
}

// PCAP VO
/* Deprecated, see control room scene below
//aud_start_fusion_scene4_reactor_fadeup(param)
//{
//	ent = param;
//	ent aud_play_pcap_vo("fusion_brk_gocritical_pre",	1.51);
//	ent aud_play_pcap_vo("fusion_brk_gocritical",		5.10); // This was supposd to be at t = 5.21, but was actually edited at 5.20, not divisible by 20hz (60/3).
//	ent aud_play_pcap_vo("fusion_brk_gocritical_post",	9.57);
//	
//	wait 15;
//	
//	level.joker maps\fusion_vo::dialogue_queue_global ( "fusion_jkr_bailinout" );
//	level.burke maps\fusion_vo::dialogue_queue_global ( "fusion_brk_keepmoving" );
//}
---------------------------------------------*/

aud_start_fusion_controlroom_dialog_burke(param)
{
	ent = param;
		
	ent aud_play_pcap_vo("fusion_brk_prophetgotthis", 0.18);	//Expected 0.30 at 60hz
	
	ent aud_play_pcap_vo("fusion_hqr_seeingwhatyoureseeing", 1.36, true);
	
	ent aud_play_pcap_vo("fusion_brk_levelsaredropping", 3.15);
	
	ent aud_play_pcap_vo("fusion_hqr_steamreleasecutoff", 12.30, true);
	
	ent aud_play_pcap_vo("fusion_brk_tryingtoreroute", 16.54);
	
	ent aud_play_pcap_vo("fusion_hqr_criticalabort", 20.24, true);
	
	ent aud_play_pcap_vo("fusion_brk_icandothis", 24.00);
	
	ent aud_play_pcap_vo("fusion_hqr_level7withdraw", 25.00, true);
	
	ent aud_play_pcap_vo("fusion_brk_shit", 30.00);
	
	ent aud_play_pcap_vo("fusion_brk_gocritical", 32.18);	//Expected 32.36 at 60hz
	
	wait(35);
	flag_set("fusion_controlroom_dialog_done");
}

aud_start_fusion_controlroom_dialog_joker(param)
{
	ent = param;
	
	ent aud_play_pcap_vo("fusion_jkr_boss", 16.00);
	
	ent aud_play_pcap_vo("fusion_jkr_burke", 23.36);
}

// PCAP VO
aud_start_fusion_scene5_burke_rescue(param)
{
	ent = param;
	ent aud_play_pcap_vo("fusion_brk_mitchell_pre",				 0.00);
	ent aud_play_pcap_vo("fusion_brk_mitchell",					 3.15);
	ent aud_play_pcap_vo("fusion_brk_medevac",					 6.27);
	ent aud_play_pcap_vo("fusion_brk_holdonman",				10.09);
	ent aud_play_pcap_vo("fusion_brk_holdonman_post",			11.51);
	ent aud_play_pcap_vo("fusion_brk_staywithme",				16.41);
	ent aud_play_pcap_vo("fusion_brk_goingtobealright",			18.02);
	ent aud_play_pcap_vo("fusion_brk_goingtobealright_post",	19.05);
	ent aud_play_pcap_vo("fusion_brk_gettingyouhome",			25.50);
	ent aud_play_pcap_vo("fusion_brk_gettingyouhome_post",		27.17);  

	thread play_arm_stinger();
}

play_arm_stinger()
{
	wait 30.5;
	level.player PlaySound("mus_fusion_arm_stinger");
}

/********************************************************************
	Support Functions.
********************************************************************/
monitor_2d_reverb_volume()
{
	self endon( "sounddone" );	
	while ( true )
	{
		assert( IsDefined( level.aud.reverb_alarm_volume ) );
		// scale volume based on the reverb_alarm_volume set in separate update function based on distance
		self ScaleVolume( level.aud.reverb_alarm_volume, level.aud.reverb_alarm_volume_update_rate );
		wait( level.aud.reverb_alarm_volume_update_rate );
	}
}

play_2d_reverb_alarm_sound()
{
	ent = Spawn( "script_origin", ( 0, 0, 0 ) ); // 2D sound doesn't need an origin
	ent PlaySound( "alarm_horn_1shot_verb_ver_04", "sounddone" );
	ent thread monitor_2d_reverb_volume();
	ent waittill( "sounddone" );
	Assert ( IsDefined( ent ) );
	ent StopSounds();
	wait 0.05;
	Assert ( IsDefined( ent ) );
	ent Delete();
}

trigger_alarm_on_street_combat_started()
{
	wait( 1 ); 	// make sure the flag has been initialized in fusion_code
	flag_wait( "street_combat_start" );
	
	start_outside_alarm();
}

// starts the loop of one shot outside alarm sound.
start_outside_alarm()
{
	assert( !flag( "aud_alarm_outside_started" ) );
	
	flag_set( "aud_alarm_outside_started" );
	

	alarm_trigger_rate = 3.0;
	
	alarm_emitter_array =
		[
			//( 2160,-10630, 2225 )	,   // flyin - between cooling towers
			( -505, -3395, 0 ),			// outside wall - where you zip down
			//(1082, -3522, 700 ),  	// helicopter hover
			( -1408, 608, 1 ),  		// pillar before building entrance
			//( -200, 3012, 154 )		,  	// building entrance
			( 7984, 8323, 48 )			// loading bay exit
		]; 
	
	thread alarm_reverb_distance_mix( alarm_emitter_array );
	
	while ( true )
	{
		if ( flag( "aud_alarm_outside_enabled" ) )
		{
			for( i = 0 ; i < alarm_emitter_array.size ; i++ )
			{
				thread play_sound_in_space( "alarm_horn_1shot_ver_04",alarm_emitter_array[i] );
			}
			thread play_2d_reverb_alarm_sound();
		}
		wait( alarm_trigger_rate ); 	
	}
}  // end of start outside alarm

alarm_reverb_distance_mix( emitter_array )
{
	wait( 0.05 );
	closest_emitter = emitter_array[ 0 ];
	
	while ( true )
	{
		if ( flag( "aud_alarm_outside_enabled" ) )
		{
			closest_emitter_dist = distance( level.player.origin, closest_emitter );
			for (i = 0; i < emitter_array.size; i++ )
			{
				//closest_emitter = emitter_array[ i - 1 ];
				emitter_dist = distance( level.player.origin, emitter_array[ i ] );
				if ( emitter_dist < closest_emitter_dist )
				{
					closest_emitter = emitter_array[ i ];
					closest_emitter_dist = emitter_dist;
				}
			}
			dist = distance( level.player.origin, closest_emitter );
			level.aud.reverb_alarm_volume = aud_map2( dist, level.aud.envs[ "alarm_verb_level_over_distance" ] );	
				
			//IPrintLnBold( "AlarmVerb: dist = " + dist + " vol = " + alarm_verb_vol );
			//IPrintLnBold( "Closest emitter = " + closest_emitter + "  dist: " + closest_emitter_dist );
		}
		wait( level.aud.reverb_alarm_volume_update_rate );
	}
} // end of distance reverb mix


trigger_courtyard_point_sounds()
{
	//DAMB_start_preset_at_point("fire_gas_large", (-2302, -2798, 83), "gas_fire_forklift", 600, 1.0);
	//DAMB_start_preset_at_point("fire_gas_large", (-645, -3801, -4), "test_gas_fire", 600, 1.0);
	//DAMB_start_preset_at_point("fire_gas_vehicle", (-2110, 9874, 748 ), "test_vehicle_fire",600,1.0);
}
	
start_control_room_alarms()
{
	level endon( "notify_out_of_loading_bay" );
	if( !level.aud.control_room_buzzer_started )
	{
		level.aud.control_room_buzzer_started = true;
		while (true)
		{
			thread play_sound_in_space("alarm_buzzer_control_room_3",( 5444, 4390, 220 ));
			thread play_sound_in_space("alarm_buzzer_control_room_3",( 5144, 4641, 220 ));
			wait(1.2);
		}
	}
}
trigger_control_room_gas_leak()
{
	DAMB_start_preset_at_point("air_pressure_leak_large", (5002, 4713, 400), "air_pressure_control_room", 600, 1.0);
}

start_fire_steam_loops()
{
	//loading bay
	//DAMB_start_preset_at_point("fire_gas_large", (7357, 5850, 80), "gas_fire_loading_bay_right", 600, 1.0);
	DAMB_start_preset_at_point("fire_gas_large", (6604, 6221, 80), "gas_fire_loading_bay_left", 600, 1.0);
	DAMB_start_preset_at_point("air_pressure_leak_large", (6212, 5834, 50), "air_pressure_leak_left1", 600, 1.0);
	DAMB_start_preset_at_point("air_bbpressure_leak_large", (6844, 6428, 50), "air_pressure_leak_left2", 600, 1.0);
	DAMB_start_preset_at_point("air_pressure_leak_large", (6922, 5828, 0), "air_pressure_leak_middle", 600, 1.0);
	DAMB_start_preset_at_point("air_pressure_leak_large", (7124, 5602, 260), "air_pressure_leak_right_high", 600, 1.0);
	
}

start_loading_bay_alarms()
{
	while (true)
	{
		thread play_sound_in_space("alarm_buzzer_inside_1shot_ver_02",( 6372, 5827, 100 ));
		thread play_sound_in_space("alarm_buzzer_inside_1shot_ver_02",( 7576, 6047, 100 ));
		wait(2);
	}	
}

start_looping_alarm_sounds()
{
	//small alarms that are outside
	loop_fx_sound( "alarm_small_outside_loop_ver_05", ( -2733, -219, 60 ),  true ); // middle building entrance
	loop_fx_sound( "alarm_small_outside_loop_ver_03", ( -2827, -3112, 61 ), true ); // building across from drop site
	loop_fx_sound( "alarm_small_outside_loop_ver_01", ( -3192, 1426, 61 ),  true ); // at car in garage
	//loop_fx_sound( "alarm_small_outside_loop_ver_05", ( -200, 3012, 154 ),  true ); // building entrance
	
	level.aud.security_building_entrance = aud_create_entity(( -200, 3012, 154 ));
	level.aud.security_building_entrance aud_fade_in("alarm_small_outside_loop_ver_05", 1, true);
	
	
	//control room
	// located back side wall - one on left and one on right
	loop_fx_sound( "alarm_inside_ver_02", ( 5574, 4255, 406 ), true );
	loop_fx_sound( "alarm_inside_ver_02", ( 5156, 4634, 406 ), true );
	
	// just before the vault door before leaving the control room
	loop_fx_sound( "alarm_inside_ver_02", ( 5879, 4882, 406 ), true );
}


do_inside_bombshake()
{
	ent = Spawn("script_origin", level.player.origin);
	
	// Play the sound.
	ent PlaySound("bomb_explo_shakes", "sounddone"); 
	//control room dust fx
	level thread maps\fusion_fx::dust_falling_control_room();
	// Do the screen shake.
	Earthquake( 0.3, 3, level.player.origin, 850 );
	
	// Clean up.
	ent waittill("sounddone");
	Assert ( IsDefined( ent ) );
	ent StopSounds();
	wait 0.05;
	Assert ( IsDefined( ent ) );
	ent Delete();
}

trigger_bomb_shake()
{
	level endon( "notify_out_of_control_room" );
	
	if(level.aud.bomb_shakes)
	{
		return;
	}
	else
	{
		level.aud.bomb_shakes = true;
		time = RandomIntRange( 10, 11 );
		while( true )
		{
			//IPrintLnBold( "time = " + time );
			wait( time );
			time = RandomIntRange( 10, 20 );
			thread do_inside_bombshake();
			//falling fx dust inside control room
			//level notify ("dust_falling");
		}
	}
}

//courtyard chopper clean up

audio_monitor_chopper01_death()
{
	self waittill( "death" );
	
	if ( IsDefined( level.aud.chopper_01_dist_lp ) )
	{
		level.aud.chopper_01_dist_lp aud_fade_out(0.1);
		level.aud.chopper_01_dist_lp = undefined;
	}
	if ( IsDefined( level.aud.chopper_01_by_in ) )
	{
		level.aud.chopper_01_by_in aud_fade_out(0.1);
		level.aud.chopper_01_by_in = undefined;
	}
	if ( IsDefined( level.aud.chopper_01_close_lp ) )
	{
		level.aud.chopper_01_close_lp aud_fade_out(0.1);
		level.aud.chopper_01_close_lp = undefined;
	}
	if ( IsDefined( level.aud.chopper_01_wind_up ) )
	{
		level.aud.chopper_01_wind_up aud_fade_out(0.1);
		level.aud.chopper_01_wind_up = undefined;
	}
	if ( IsDefined( level.aud.chopper_01_away_by ) )
	{
		level.aud.chopper_01_away_by aud_fade_out(0.1);
		level.aud.chopper_01_away_by = undefined;
	}
}

audio_monitor_chopper02_death(args)
{
	self waittill( "death" );
	
	if ( IsDefined( level.aud.chopper_02_dist_lp ) )
	{
		level.aud.chopper_02_dist_lp aud_fade_out(0.1);
		level.aud.chopper_02_dist_lp = undefined;
	}
	if ( IsDefined( level.aud.chopper_02_by_in ) )
	{
		level.aud.chopper_02_by_in aud_fade_out(0.1);
		level.aud.chopper_02_by_in = undefined;
	}
	if ( IsDefined( level.aud.chopper_02_close_lp ) )
	{
		level.aud.chopper_02_close_lp aud_fade_out(0.1);
		level.aud.chopper_02_close_lp = undefined;
	}
	if ( IsDefined( level.aud.chopper_02_wind_up ) )
	{
		level.aud.chopper_02_wind_up aud_fade_out(0.1);
		level.aud.chopper_02_wind_up = undefined;
	}
	if ( IsDefined( level.aud.chopper_02_away_by ) )
	{
		level.aud.chopper_02_away_by aud_fade_out(0.1);
		level.aud.chopper_02_away_by = undefined;
	}
}


/***************************************
LEVEL-SPECIFIC UTILITY FUNCTIONS
/***************************************/

aud_play( alias_name, is_loop_ )
{
	assert(IsString(alias_name));

	is_loop = false;
	if ( IsDefined( is_loop_ ) )
	{
		is_loop = is_loop_;
	}

	if ( is_loop )
	{
		self PlayLoopSound( alias_name );
	}
	else
	{
		self PlaySound( alias_name, "sounddone" );
		self aud_delete_on_sounddone();
	}
}

aud_fade_in( alias_name, fade_in_time, is_loop_ )
{
	assert(IsString(alias_name));
	assert(IsDefined(fade_in_time));
	
	is_loop = false;
	if ( IsDefined( is_loop_ ) )
	{
		is_loop = is_loop_;
	}

	if ( is_loop )
	{
		self PlayLoopSound( alias_name );
	}
	else
	{
		self PlaySound( alias_name, "sounddone" );
		self aud_delete_on_sounddone();
	}

	if ( fade_in_time > 0.0 )
	{
		self thread audx_fade_in_internal( fade_in_time );
	}
}

audx_fade_in_internal( fade_in_time )
{
	self ScaleVolume( 0.0 );
	wait( 0.05 );

	if ( !IsDefined( self ) )
	{
		return;
	}

	self ScaleVolume( 1.0, fade_in_time );
}

aud_fade_out( fade_out_time )
{
	self thread audx_fade_out_internal(fade_out_time);
}

audx_fade_out_internal( fade_out_time )
{
	self ScaleVolume( 0.0, fade_out_time );
	wait( fade_out_time + 0.05 );

	if ( !IsDefined( self ) )
	{
		return;
	}

	self StopSounds();
	self StopLoopSound();
	wait( 0.05 );

	if ( !IsDefined( self ) )
	{
		return;
	}

	self Delete();
}

aud_delete_on_sounddone()
{
	self thread audx_delete_on_sounddone_internal();
}

audx_delete_on_sounddone_internal()
{
	self endon( "death" );

	self waittill( "sounddone" );

	if ( !IsDefined( self ) )
	{
		return;
	}

	self Delete();
}

aud_play_distance_attenuated_2D( aliasname, minDistance, maxDistance, rolloffFactor_, is_loop_ )
{
	assert(IsDefined(aliasname));
	assert(IsDefined(minDistance));
	assert(IsDefined(maxDistance));

	rolloffFactor = 1.0;
	if ( IsDefined(rolloffFactor_) )
	{
		rolloffFactor = rolloffFactor_;
	}

	self aud_play( aliasname, is_loop_ );
	self thread audx_play_distance_attenuated_2D_internal( minDistance, maxDistance, rolloffFactor );
}

audx_play_distance_attenuated_2D_internal( minDistance, maxDistance, rolloffFactor )
{
	self endon( "death" );
	self endon( "aud_stop_distance_attenuation" );
	
	while ( IsDefined( self ) )
	{
		dist = Distance( self.origin, level.player.origin );
		volume = audx_attenuate( dist, minDistance, maxDistance, rolloffFactor );
		self ScaleVolume( volume );
		wait(0.05);
	}
}

audx_attenuate( dist, minDistance, maxDistance, rolloffFactor )
{
	// Clamp the to the attenuation distance to the min (the sound will not get any louder beyond this point)
	dist = Max(dist, minDistance);
	if ( dist > maxDistance )
	{
		// If we go beyond the max distance, mute the sound.
		return 0.0;
	}

	// Attenuate the volume due to distance.
	// NOTE - This method provides a "real world" roll-off where doubling the distance
	// cuts the volume in half (IASIG I3DL2, http://www.iasig.org/pubs/3dl2v1a.pdf)
	volume = minDistance / ( minDistance + rolloffFactor * ( dist - minDistance ) );
	return volume;
}

aud_create_entity(position)
{
	assert(IsDefined(position));

	return spawn("script_origin", position);
}

aud_create_linked_entity(ent_to_linkto, offset)
{
	assert(IsDefined(ent_to_linkto));

	ent = spawn( "script_origin", ent_to_linkto.origin );
	if ( IsDefined( offset ) )
		ent linkto( ent_to_linkto, "", offset, ( 0, 0, 0 ) );
	else
		ent linkto( ent_to_linkto );

	return ent;
}
