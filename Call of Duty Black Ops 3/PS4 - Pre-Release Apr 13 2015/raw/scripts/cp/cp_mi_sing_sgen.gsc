// Shared
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\visionset_mgr_shared;

// CP Common
#using scripts\cp\_ammo_cache;
#using scripts\cp\_load;
#using scripts\cp\_mobile_armory;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;

// Depts
#using scripts\cp\cp_mi_sing_sgen_fx;
#using scripts\cp\cp_mi_sing_sgen_sound;
#using scripts\cp\cp_mi_sing_sgen_util;

// Events
#using scripts\cp\cp_mi_sing_sgen_exterior;
#using scripts\cp\cp_mi_sing_sgen_enter_silo;
#using scripts\cp\cp_mi_sing_sgen_dark_battle;
#using scripts\cp\cp_mi_sing_sgen_testing_lab_igc;
#using scripts\cp\cp_mi_sing_sgen_fallen_soldiers;
#using scripts\cp\cp_mi_sing_sgen_pallas;
#using scripts\cp\cp_mi_sing_sgen_revenge_igc;
#using scripts\cp\cp_mi_sing_sgen_silo_swim;
#using scripts\cp\cp_mi_sing_sgen_uw_battle;
#using scripts\cp\cp_mi_sing_sgen_water_ride;
#using scripts\cp\cp_mi_sing_sgen_flood;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                       

#using scripts\shared\vehicles\_quadtank;

#namespace sgen;

#precache( "fx", "debris/fx_debris_underwater_current_sgen_os" );
#precache( "fx", "destruct/fx_dest_drone_mapper" );
#precache( "fx", "explosions/fx_exp_generic_lg" );
#precache( "fx", "explosions/fx_exp_underwater_depth_charge" );
#precache( "fx", "explosions/fx_vexp_hunter_death" );
#precache( "fx", "fog/fx_fog_coolant_jet_pallas_sgen" );
#precache( "fx", "fog/fx_fog_coolant_leak_lg" );
#precache( "fx", "fog/fx_fog_coolant_leak_md" );
#precache( "fx", "fog/fx_fog_coolant_release_column_sgen" );
#precache( "fx", "fog/fx_fog_coolant_vent_lg" );
#precache( "fx", "light/fx_light_emergency_flare_red"	);
#precache( "fx", "light/fx_temp_glow_cookie_crumb_sgen" );
#precache( "fx", "steam/fx_steam_decon_fill_elevator_sgen" );
#precache( "fx", "water/fx_temp_water_tidal_wave_sgen" );
#precache( "fx", "water/fx_water_leak_torrent_md" );
#precache( "fx", "water/fx_water_splash_25v25" );

#precache( "lui_menu", "CACWaitMenu" );
#precache( "lui_menu", "drone_pip" );

#precache( "material", "t7_hud_prompt_beacon_64" );
#precache( "material", "t7_hud_prompt_hack_64" );
#precache( "material", "generic_filter_ev_interference" );

#precache( "model", "p7_monitor_curved_military" );



function main()
{
	precache();
	init_clientfields();
	init_flags();
	flood_setup();
	setup_skiptos();

	util::init_streamer_hints( 5 );

	cp_mi_sing_sgen_fx::main();
	cp_mi_sing_sgen_sound::main();

	// Set Level Vars
	level.b_enhanced_vision_enabled = true;	// Enables Enhanced Vision.  See _oed.gsc
	level.can_revive_use_depthinwater_test = true;	//TEMP Allows reviving underwater.  Also allows reviving from any distance
	level.overrideAmmoDropTeam3 = true;		// to allow rogue-controlled robots to drop weapons.

	if ( ( GetDvarString( "skipto" ) === "dev_flood_combat" ) )
	{
		sgen_util::rename_coop_spawn_points( "flood_combat", "dev_flood_combat" );
	}

	load::main();

	a_s_align = struct::get_array( "dark_battle_align_2", "targetname" );
	if ( IsDefined( a_s_align ) && a_s_align.size > 1 )
	{
		level.v_underwater_offset = a_s_align[ 1 ].origin - a_s_align[ 0 ].origin;
	}

	t_boundary = GetEnt( "flood_defend_out_of_boundary_trig", "targetname" );
	t_boundary SetInvisibleToAll();
	
	level thread level_threads();	
}

function setup_skiptos()
{
	skipto::add( "intro",				&cp_mi_sing_sgen_exterior::skipto_intro_init, 					"Intro",			&cp_mi_sing_sgen_exterior::skipto_intro_done );
	skipto::add( "post_intro",			&cp_mi_sing_sgen_exterior::skipto_post_intro_init, 				"Post Intro",		&cp_mi_sing_sgen_exterior::skipto_post_intro_done );
	skipto::add( "enter_sgen",			&cp_mi_sing_sgen_exterior::skipto_enter_sgen_init, 				"Enter SGEN",		&cp_mi_sing_sgen_exterior::skipto_enter_sgen_done );
	skipto::add( "enter_lobby",			&cp_mi_sing_sgen_exterior::skipto_enter_lobby_init, 			"Enter Lobby",		&cp_mi_sing_sgen_exterior::skipto_enter_lobby_done );

	skipto::add( "discover_data", 		&cp_mi_sing_sgen_enter_silo::skipto_discover_data_init, 		"Discover Data",	&cp_mi_sing_sgen_enter_silo::skipto_discover_data_done );
	skipto::add( "aquarium_shimmy", 	&cp_mi_sing_sgen_enter_silo::skipto_aquarium_shimmy_init, 		"Aquarium Shimmy",	&cp_mi_sing_sgen_enter_silo::skipto_aquarium_shimmy_done );
	skipto::add( "gen_lab", 			&cp_mi_sing_sgen_enter_silo::skipto_gen_lab_init, 				"Genetics Lab",		&cp_mi_sing_sgen_enter_silo::skipto_gen_lab_done );
	skipto::add( "post_gen_lab", 		&cp_mi_sing_sgen_enter_silo::skipto_post_gen_lab_init, 			"Post Gen Lab",		&cp_mi_sing_sgen_enter_silo::skipto_post_gen_lab_done );
	skipto::add( "chem_lab", 			&cp_mi_sing_sgen_enter_silo::skipto_chem_lab_init, 				"Chemical Lab",		&cp_mi_sing_sgen_enter_silo::skipto_chem_lab_done );
	skipto::add( "post_chem_lab", 		&cp_mi_sing_sgen_enter_silo::skipto_post_chem_lab_init, 		"Post Chem Lab",	&cp_mi_sing_sgen_enter_silo::skipto_post_chem_lab_done );
	skipto::add( "silo_floor", 			&cp_mi_sing_sgen_enter_silo::skipto_silo_floor_init, 			"Silo Floor Battle",&cp_mi_sing_sgen_enter_silo::skipto_silo_floor_done );
	skipto::add( "under_silo", 			&cp_mi_sing_sgen_enter_silo::skipto_under_silo_init, 			"Under Silo",		&cp_mi_sing_sgen_enter_silo::skipto_under_silo_done );

	skipto::add( "fallen_soldiers", 	&cp_mi_sing_sgen_fallen_soldiers::skipto_fallen_soldiers_init,	"Fallen Soldiers",	&cp_mi_sing_sgen_fallen_soldiers::skipto_fallen_soldiers_done );
	skipto::add( "testing_lab_igc", 	&cp_mi_sing_sgen_testing_lab_igc::skipto_testing_lab_igc_init, 	"Human Testing Lab",&cp_mi_sing_sgen_testing_lab_igc::skipto_testing_lab_igc_done );
	skipto::add( "dark_battle", 		&cp_mi_sing_sgen_dark_battle::skipto_dark_battle_init, 			"Dark Battle", 		&cp_mi_sing_sgen_dark_battle::skipto_dark_battle_done );
	skipto::add( "charging_station", 	&cp_mi_sing_sgen_dark_battle::skipto_charging_station_init, 	"Charging Station", &cp_mi_sing_sgen_dark_battle::skipto_charging_station_done );

	skipto::add( "descent", 			&cp_mi_sing_sgen_pallas::skipto_descent_init, 					"Descent",			&cp_mi_sing_sgen_pallas::skipto_descent_done );
	skipto::add( "pallas_start", 		&cp_mi_sing_sgen_pallas::skipto_pallas_start_init,				"pallas start", 	&cp_mi_sing_sgen_pallas::skipto_pallas_start_done);
	skipto::add( "pallas_end", 			&cp_mi_sing_sgen_pallas::skipto_pallas_end_init, 				"Pallas Death", 	&cp_mi_sing_sgen_pallas::skipto_pallas_end_done );
	skipto::add( "twin_revenge", 		&cp_mi_sing_sgen_revenge_igc::skipto_revenge_init, 				"Twin Revenge", 	&cp_mi_sing_sgen_revenge_igc::skipto_revenge_done );

	skipto::add( "flood_combat", 		&cp_mi_sing_sgen_flood::skipto_flood_init, 						"Flood Combat", 	&cp_mi_sing_sgen_flood::skipto_flood_done );
	skipto::add( "flood_defend", 		&cp_mi_sing_sgen_flood::skipto_flood_defend_init, 				"Flood Defend", 	&cp_mi_sing_sgen_flood::skipto_flood_defend_done );
	skipto::add( "underwater_battle", 	&cp_mi_sing_sgen_uw_battle::skipto_underwater_init, 			"Underwater Battle", &cp_mi_sing_sgen_uw_battle::skipto_underwater_done );
	skipto::add( "underwater_rail", 	&cp_mi_sing_sgen_water_ride::skipto_underwater_rail_init, 		"Underwater Rail", 	&cp_mi_sing_sgen_water_ride::skipto_underwater_rail_done );
	skipto::add( "silo_swim", 			&cp_mi_sing_sgen_silo_swim::skipto_silo_swim_init, 				"Silo Swim", 		&cp_mi_sing_sgen_silo_swim::skipto_silo_swim_done );

	// For Asher to quickly see the FX Anims. No guarantee for gameplay progression.
	skipto::add_dev( "dev_flood_combat", 	&cp_mi_sing_sgen_flood::skipto_flood_init, 					"Flood Combat", 	&cp_mi_sing_sgen_flood::skipto_flood_done );
}

function precache()
{
	// DO ALL PRECACHING HERE
	level._effect[ "current_effect" ]	= "debris/fx_debris_underwater_current_sgen_os";
	level._effect[ "decon_mist" ]		= "steam/fx_steam_decon_fill_elevator_sgen";
	level._effect[ "drone_breadcrumb" ]	= "light/fx_temp_glow_cookie_crumb_sgen";
	level._effect[ "drone_sparks" ]		= "destruct/fx_dest_drone_mapper";
	level._effect[ "red_flare" ]		= "light/fx_light_emergency_flare_red";
	level._effect[ "water_spout" ]		= "water/fx_water_leak_torrent_md";
	level._effect[ "coolant_fx" ]       = "fog/fx_fog_coolant_jet_pallas_sgen";
	level._effect[ "fake_depth_charge_explosion" ]       = "explosions/fx_exp_underwater_depth_charge";
	level._effect[ "tidal_wave" ] 		= "water/fx_temp_water_tidal_wave_sgen";
	level._effect[ "drone_splash" ]		= "water/fx_water_splash_25v25";
	level._effect[ "rock_explosion" ]	= "explosions/fx_exp_generic_lg";
	level._effect[ "coolant_tower_unleash" ]	= "fog/fx_fog_coolant_release_column_sgen";
	level._effect[ "coolant_tower_damage_minor" ]	= "fog/fx_fog_coolant_leak_md";
	level._effect[ "coolant_tower_damage_major" ]	= "fog/fx_fog_coolant_leak_lg";
	level._effect[ "central_tower_damage_minor" ]	= "fog/fx_fog_coolant_vent_lg";
	level._effect[ "central_tower_damage_major" ]	= "explosions/fx_vexp_hunter_death";
	level._effect[ "depth_charge_explosion" ]	= "explosions/fx_exp_underwater_depth_charge";
}

function init_clientfields()
{
	// FX Anim bits
	clientfield::register( "world", "w_fxa_truck_flip",					1, 1, "int" );	// FXANIM during Quad Tank fight
	clientfield::register( "world", "w_robot_window_break",				1, 1, "int" );
	clientfield::register( "world", "silo_swim_bridge_fall",			1, 1, "int" );
	clientfield::register( "world", "w_underwater_state",				1, 1, "int" );
	clientfield::register( "world", "w_flood_combat_windows_b",			1, 1, "int" );
	clientfield::register( "world", "w_flood_combat_windows_c",			1, 1, "int" );
	clientfield::register( "world", "elevator_light_probe",				1, 1, "int" );
	clientfield::register( "world", "flood_defend_hallway_flood_siege",	1, 1, "int" );
	clientfield::register( "world", "tower_chunks1",					1, 1, "int" );
	clientfield::register( "world", "tower_chunks2",					1, 1, "int" );
	clientfield::register( "world", "tower_chunks3",					1, 1, "int" );
	clientfield::register( "world", "observation_deck_destroy",			1, 1, "counter" );
	clientfield::register( "world", "fallen_soldiers_client_fxanims",	1, 1, "int" );
	clientfield::register( "world", "w_flyover_buoys",					1, 1, "int" );
	clientfield::register( "world", "w_twin_igc_fxanim",				1, 2, "int" );
	
	//fxanim rocks
	clientfield::register( "world", "debris_catwalk",					1, 1, "int" );
	clientfield::register( "world", "debris_wall",						1, 1, "int" );
	clientfield::register( "world", "debris_fall",						1, 1, "int" );
	clientfield::register( "world", "debris_bridge",					1, 1, "int" );
	
	clientfield::register( "scriptmover", "structural_weakness",		1, 1, "int" );
	clientfield::register( "scriptmover", "sm_elevator_extracam",		1, 2, "int" );
	clientfield::register( "scriptmover", "sm_elevator_shader",			1, 2, "int" );
	clientfield::register( "scriptmover", "sm_elevator_door_state",		1, 2, "int" );
	clientfield::register( "scriptmover", "mappy_path", 				1, 1, "int" );
	clientfield::register( "scriptmover", "weakpoint",	 				1, 1, "int" );
	clientfield::register( "scriptmover", "sm_depth_charge_fx",	 		1, 1, "int" );

	clientfield::register( "toplayer",	"reduce_oed_range",				1, 1, "int" );
	clientfield::register( "toplayer",	"activate_pallas_monitoring",	1, 2, "int" );
	clientfield::register( "toplayer",	"tp_water_sheeting",  			1, 1, "int" );
	clientfield::register( "toplayer",	"oed_interference",  			1, 1, "int" );
	clientfield::register( "toplayer",	"sndSiloBG",  					1, 1, "int" );
	clientfield::register( "toplayer",	"sndSgenUW",  					1, 1, "int" );
	clientfield::register( "toplayer", 	"dust_motes", 					1, 1, "int" );
	clientfield::register( "toplayer",	"futz_interference",			1, 5, "float" );
	clientfield::register( "toplayer",	"silo_debris",					1, 1, "counter" );
	clientfield::register( "toplayer", 	"water_teleport", 				1, 1, "int" );
	clientfield::register( "toplayer", "pstfx_frost_up", 				1, 1, "counter" );
	clientfield::register( "toplayer", "pstfx_frost_down", 				1, 1, "counter" );	

	clientfield::register( "scriptmover", "turn_fake_robot_eye",		1, 1, "int" );
	clientfield::register( "vehicle",	"extra_cam_ent",				1, 2, "int" );	// Use the drone as extracam
	clientfield::register( "vehicle",	"show_mappy_path",				1, 1, "int" );

	// 0 = off, 1 = on
	clientfield::register( "actor", "robot_eye_fx", 1, 1, "int" );
	clientfield::register( "actor", "sndStepSet", 1, 1, "int" );

	visionset_mgr::register_info( "overlay", "earthquake_blur", 1, 50, 1, true, &visionset_mgr::timeout_lerp_thread_per_player, false );
}

function init_flags()
{
	level flag::init( "exterior_start_patrol" );		// This is needed for _patrol.gsc scripts to work properly
	level flag::init( "hendricks_on_hill" );

	level flag::init( "start_vehicle_patrols" );
	level flag::init( "intro_igc_done" ); //notetrack on last intro anim
	level flag::init( "hendricks_intro_done" ); //notetrack on hendricks intro anim
	level flag::init( "player_has_silenced_weap" );
	level flag::init( "start_technical" );		// Start moving the intro technical
	level flag::init( "qtank_active" );			// Has the quad tank activated?
	level flag::init( "fallback_to_qt" );
	level flag::init( "hendricks_qt_reveal" );
	level flag::init( "intro_quadtank_dead" );
	level flag::init( "quadtank_hijacked" );
	level flag::init( "hendricks_at_lobby_idle" );
	level flag::init( "lobby_door_opening" );	// Has the player started opening the lobby door?
	level flag::init( "lobby_door_opened" );	// Has the lobby door opened?
	level flag::init( "silo_door_opened" );		// Has the door to the silo top opened?
	level flag::init( "data_discovered" );		// Has the player found the EMF Device?
	level flag::init( "hendricks_move_up_3" );  // hendricks move up in silo swim through the shaft flag.
	level flag::init( "hendricks_corvus_examination" );
	level flag::init( "corvus_entrance_hendrick_idle_trigger" );
	level flag::init( "chem_door_open" );
	level flag::init( "player_raise_hendricks_player_ready" );
	level flag::init( "player_raise_hendricks_hendricks_ready" );
	level flag::init( "spawn_quadtank_reinforcements" );
	level flag::init( "start_hendricks_move_up_battle_1" );
	level flag::init( "start_hendricks_move_up_battle_2" );
	level flag::init( "gen_lab_cleared" );
	level flag::init( "hendricks_at_gen_lab_door" );
	level flag::init( "gen_lab_door_opened" );
	level flag::init( "hendricks_door_line" );
	level flag::init( "player_has_double_jump" );
	level flag::init( "spawn_quad_tank" );
	level flag::init( "enable_battle_volumes" );
	level flag::init( "hendricks_shimmy_halfway" );
	level flag::init( "trophy_system_disabled" );
	level flag::init( "direct_hit_vo_playing" );
	
	level flag::init( "qtank_fight_completed" );
	level flag::init( "mappy_path_active" );
	level flag::init( "hendricks_data_anim_done" );

	level flag::init( "hendricks_at_silo_doors" );
	level flag::init( "gen_lab_gone_hot" );
	level flag::init( "bridge_debris_player_kill" ); //flag from bridge debris fxanim
	
	level flag::init( "start_silo_ambush" );
	level flag::init( "spawn_left_side_robots" );
	level flag::init( "start_floor_risers" );
	level flag::init( "all_players_outside_chem_lab" );
	level flag::init( "gen_lab_pip_off" );
	level flag::init( "exterior_gone_hot" );

	level flag::init( "hendricks_in_cqb" );
	level flag::init( "hendricks_in_gen_lab" );
	level flag::init( "drone_over_grate" );
	level flag::init( "drone_over_grate_real" );

	level flag::init( "drone_died" );
	level flag::init( "kane_data_callout" );

	level flag::init( "highlight_railing_glass" ); //called from bundle
	level flag::init( "glass_railing_kicked" );	//called from bundle
	
	level flag::init( "spawn_silo_robots" );
	level flag::init( "start_middle_room_risers" );
	
	level flag::init( "drone_silo_anim_done" ); //notetrack flag
	
	//	level flag::init( "post_discover_data" );	// Set by trigger
	//	level flag::init( "follow1_2" );			// Set by trigger
	//	level flag::init( "follow1_3" );			// Set by trigger
	//	level flag::init( "follow1_4" );			// Set by trigger
	//	level flag::init( "follow1_5" );			// Set by trigger
	//	level flag::init( "follow_gen_lab" );		// Set by trigger
	//	level flag::init( "follow_chem_lab" );		// Set by trigger
	//	level flag::init( "follow3_1" );			// Set by trigger
	//	level flag::init( "follow3_2" );			// Set by trigger
	//	level flag::init( "follow3_3" );			// Set by trigger
	//
	//	level flag::init( "hendricks_follow1_jump1" );		// Set by trigger
	//	level flag::init( "hendricks_exit_gen_lab" );		// Set by trigger
	//	level flag::init( "hendricks_follow2_jumpdown" );	// Set by trigger

	level flag::init( "drone_scanning" );

	level flag::init( "hendricks_at_silo_floor" );
	
	level flag::init( "send_drone_over_grate" );
	level flag::init( "silo_floor_cleared" );
	level flag::init( "silo_grate_open" );

	level flag::init( "pallas_intro_completed" );
	level flag::init( "pallas_start" );
	level flag::init( "pallas_end" );
	level flag::init( "core_two_destroyed" );
	level flag::init( "tower_three_destroyed" );
	
	level flag::init( "dark_battle_hendricks_above" );

	level flag::init( "pallas_ambush_over" );

	level flag::init( "fallen_soldiers_hendricks_ready" );

	level flag::init( "pallas_lift_front_open" );	// Is the front door to the Pallas elevator open?
	level flag::init( "pallas_lift_back_open" );	// Is the back door to the Pallas elevator open?

	//bridge notetracks
	level flag::init( "bridge_hit_1" );
	level flag::init( "bridge_hit_2" );
	
	level flag::init( "optics_out" );
	level flag::init( "hendricks_door_open" );
	level flag::init( "water_robot_spawned" );
	level flag::init( "pod_robot_spawned" );

	level flag::init( "depth_charges_cleared" );
	
	level flag::init( "player_raise_hendricks_hendricks" );

	level flag::init( "silo_swim_bridge_collapse" );
	level flag::init( "silo_swim_take_out" );
	
	level flag::init( "sgen_end_igc" );
}

//
//	Grouping level-wide threads
function level_threads()
{
	a_t_mover = GetEntArray( "t_mover", "targetname" );
	array::thread_all( a_t_mover, &sgen_util::trig_mover );

	a_t_futz = GetEntArray( "futz_vision", "targetname" );
	array::thread_all( a_t_futz, &futz_vision_trigger, true );

	a_t_ev_on = GetEntArray( "enhanced_vision_on", "targetname" );
	a_t_ev_off = GetEntArray( "enhanced_vision_off", "targetname" );
	array::thread_all( a_t_ev_on, &ehanced_vision_trigger, true );
	array::thread_all( a_t_ev_off, &ehanced_vision_trigger, false );

	a_t_water = GetEntArray( "water_movement_trigger", "targetname" );
	array::thread_all( a_t_water, &water_movement );

	// Handles the grate at the bottom of the silo
	level thread silo_grate();
	level thread scale_rock_slide();

	level thread hide_show_fxanim_door_flood();
	//level thread lift_pillar_cover_pallas();
	level thread robot_oed_toggles();
	level thread igc_player_setup();
}

function init_hendricks( str_objective )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_hendricks colors::set_force_color( "r" );

	if ( !IsSubStr( level.skipto_point, "dev_flood_combat" ) )
	{
		skipto::teleport_ai( str_objective );
	}
}

function igc_player_setup()
{
	// Intro
	level scene::add_scene_func( "cin_sgen_01_intro_3rd_pre100_flyover", &sgen_util::igc_begin, "play" );
	level scene::add_scene_func( "cin_sgen_01_intro_3rd_pre200_overlook_sh060", &sgen_util::igc_end, "done" );

	// DNI
	level scene::add_scene_func( "cin_sgen_14_humanlab_3rd_sh005", &sgen_util::igc_begin, "play" );
	level scene::add_scene_func( "cin_sgen_14_humanlab_3rd_sh200", &sgen_util::igc_end, "done" );

	// Post Pallas
	level scene::add_scene_func( "cin_sgen_19_ghost_3rd_sh010", &sgen_util::igc_begin, "play" );
	level scene::add_scene_func( "cin_sgen_19_ghost_3rd_sh190", &sgen_util::igc_end, "done" );

	// Twin Revenge
	level scene::add_scene_func( "cin_sgen_20_twinrevenge_3rd_sh010", &sgen_util::igc_begin, "play" );
	level scene::add_scene_func( "cin_sgen_20_twinrevenge_3rd_sh080", &sgen_util::igc_end, "done" );
	
	// End
	level scene::add_scene_func( "cin_sgen_26_01_lobbyexit_1st_escape_underwater", &sgen_util::igc_begin, "play" );
	level scene::add_scene_func( "cin_sgen_26_01_lobbyexit_1st_escape_outro", &sgen_util::igc_end, "done" );
}

function robot_oed_toggles()
{
	for ( x = 2; x < 4; x++ )
	{
		scene::add_scene_func( "cin_sgen_15_04_robot_ambush_aie_arise_robot0" + x, &enhanced_vision_entity_off, "init" );
		scene::add_scene_func( "cin_sgen_15_04_robot_ambush_aie_arise_robot0" + x, &enhanced_vision_entity_on, "play" );
	}

	for ( x = 1; x < 6; x++ )
	{
		scene::add_scene_func( "cin_sgen_13_01_robots_awaken_aie_awake_robot0" + x, &enhanced_vision_entity_off, "init" );
		scene::add_scene_func( "cin_sgen_13_01_robots_awaken_aie_awake_robot0" + x, &enhanced_vision_entity_on, "play" );
	}

	for ( x = 1; x < 5; x++ )
	{
		scene::add_scene_func( "cin_sgen_12_02_corvus_vign_wakeup_rail_robot_0" + x, &enhanced_vision_entity_off, "init" );
		scene::add_scene_func( "cin_sgen_12_02_corvus_vign_wakeup_rail_robot_0" + x, &enhanced_vision_entity_on, "play" );
	}

	scene::add_scene_func( "cin_sgen_16_01_charging_station_aie_idle_robot01", &enhanced_vision_entity_off, "init" );
	scene::add_scene_func( "cin_sgen_16_01_charging_station_aie_idle_robot01", &enhanced_vision_entity_off, "play" );
	scene::add_scene_func( "cin_sgen_16_01_charging_station_aie_fail_robot01", &enhanced_vision_entity_off, "init" );
	scene::add_scene_func( "cin_sgen_16_01_charging_station_aie_fail_robot01", &enhanced_vision_entity_off, "play" );

	for ( x = 1; x < 7; x++ )
	{
		scene::add_scene_func( "cin_sgen_16_01_charging_station_aie_awaken_robot0" + x, &enhanced_vision_entity_on, "play" );
	}

	scene::add_scene_func( "cin_sgen_16_01_charging_station_aie_awaken_robot05_jumpdown", &enhanced_vision_entity_on, "play" );
}

function lift_pillar_cover_pallas()
{
	e_pillars = GetEntArray( "diaz_tower_1", "targetname" );

	foreach( pillar in e_pillars )
	{
		pillar movez( 106, 0.05 );
	}

}

//TEMP Stolen from Biodomes
function wait_for_all_players_to_spawn()
{
	level flag::wait_till( "all_players_spawned" );

	wait 0.1;  //start IGC before the CACWaitMenu is still displayed

	//	level thread close_cacwaitmenu();
}

//TEMP Stolen from Biodomes
function close_cacwaitmenu()
{
	wait 1;  //wait until IGC has started playing before closing menu

	foreach( player in level.players )
	{
		if ( isdefined( player.wait_menu ) )
		{
			player CloseLUIMenu( player.wait_menu );
			player setClientUIVisibilityFlag( "hud_visible", 1 );
			player enableweapons();
		}
	}
}

function player_reduce_oed()
{
	level flag::wait_till( "pallas_start" );
	self clientfield::set_to_player( "reduce_oed_range", 1 );

	level flag::wait_till( "pallas_end" );
	self clientfield::set_to_player( "reduce_oed_range", 0 );
}

//
//	Handle the silo grate at the bottom of the silo
function silo_grate()
{
	//	In under_silo, Hendricks opens the grate
	level flag::wait_till( "silo_grate_open" );

	a_blockers = GetEntArray( "silo_floor_clip", "targetname" );
	array::run_all( a_blockers, &Delete );

	//	Wait until we get to the silo swim
	level flag::wait_till( "silo_swim" );

	//	Remove the rest of the grate
	a_blockers = GetEntArray( "silo_grate", "targetname" );
	array::run_all( a_blockers, &Delete );
}

function flood_setup()
{
	// Disable Flood Combat entities
	array::run_all( GetEntArray("flood_combat_trigger", "script_noteworthy" ), &TriggerEnable, false );

	level thread sgen_util::set_door_state( "flood_robot_room_door_close", "open" );
	level thread sgen_util::set_door_state( "surgical_room_door", "open" );
	level thread sgen_util::set_door_state( "charging_station_entrance", "open" );

	e_water_nosight = GetEnt( "flood_combat_water_nosight", "targetname" );
	e_water_nosight.origin += ( 0, 0, -512 );
}

function futz_vision_trigger()
{
	while ( true )
	{
		self waittill( "trigger", e_player );

		if ( !( isdefined( e_player.is_futz_active ) && e_player.is_futz_active ) )
		{
			e_player.is_futz_active = true;

			self thread futz_vision_trigger_tracking( e_player );
		}
	}
}

function futz_vision_trigger_tracking( e_player )
{
	e_player endon( "death" );

	s_target = struct::get( self.target );

	while ( e_player IsTouching( self ) )
	{
		n_futz = MapFloat( 0, self.radius, 0.6, 0.0, Distance2D( s_target.origin, e_player.origin ) );
		e_player clientfield::set_to_player( "futz_interference", n_futz );

		wait ( 0.05 );
	}

	e_player clientfield::set_to_player( "futz_interference", 0.0 );
	e_player.is_futz_active = false;
}

function ehanced_vision_trigger( b_enable )
{
	while ( true )
	{
		self waittill( "trigger", e_player );

		e_player clientfield::set_to_player( "oed_interference", !b_enable );

		if ( !b_enable )
		{
			level flag::set( "optics_out" );
			e_player.b_tactical_mode_enabled = false;
			e_player oed::set_player_tmode( false );
			e_player cybercom::disableCybercom();
		}
		else
		{
			e_player.b_tactical_mode_enabled = true;
			e_player cybercom::enableCybercom();
		}
	}
}

function enhanced_vision_entity_off( a_ents )
{
	if ( IsAI( self ) )
	{
		self.ignoreme = true;
		self oed::disable_thermal();
		self DisableAimAssist();
	}

	if ( IsDefined( a_ents ) )
	{
		array::thread_all( a_ents, &enhanced_vision_entity_off );
	}
}

function enhanced_vision_entity_on( a_ents )
{
	if ( IsAI( self ) )
	{
		self.ignoreme = false;
		self oed::enable_thermal();
		self EnableAimAssist();
	}

	if ( IsDefined( a_ents ) )
	{
		array::thread_all( a_ents, &enhanced_vision_entity_on );
	}
}

function water_movement()
{
	while ( true )
	{
		self waittill( "trigger", e_player );

		if ( !( isdefined( e_player.is_in_water ) && e_player.is_in_water ) )
		{
			self thread water_movement_player( e_player );
		}
	}
}

function water_movement_player( e_player )
{
	e_player endon( "disconnect" );

	e_player.is_in_water = true;
	e_player SetMoveSpeedScale( 0.70 );

	while ( e_player IsTouching( self ) )
	{
		wait ( 0.1 );
	}

	e_player SetMoveSpeedScale( 1 );
	e_player.is_in_water = false;
}

function scale_rock_slide()
{
	m_rocks = getentarray( "silo_rock_slide", "targetname" );
	array::run_all( m_rocks, &Setscale, 2 );
}

function script_tag_align_create( str_name, n_index = 0 )
{
	a_s_align = struct::get_array( str_name, "targetname" );

	s_align = SpawnStruct();
	s_align.origin = a_s_align[ n_index ].origin;
	s_align.angles = a_s_align[ n_index ].angles;
	s_align.targetname = str_name + "_script";

	level.struct_class_names[ "targetname" ][ str_name + "_script" ] = Array( s_align );
}

function hide_show_fxanim_door_flood()
{
	e_door_clip = getent( "flood_door_player_clip", "targetname" );
	e_door_clip movez( 128, 0.05);
	level thread sgen_util::set_door_state( "surgical_room_entrance_door", "open" );

	//	flooded_door = getent( "fxanim_flooded_lab_door", "targetname" );
	//	flooded_door hide();
}
