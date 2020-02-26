#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

main()
{
	// section 2 anims
	add_scene( "anthem_grapple_setup", "anthem_grappel" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_1_grapple_device_harper_setup, true, false );
	add_player_anim( "player_body", %player::p_pakistan_5_1_grapple_device_player_setup, false );
	add_prop_anim( "harper_grappler", %animated_props::o_pakistan_5_1_grapple_device_setup_harper_gun, "t6_wpn_rappel_gun_prop_view", false );
	
	add_scene( "anthem_grapple_idle", "anthem_grappel", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_1_grapple_device_harper_idle, true, false );
	add_prop_anim( "harper_grappler", %animated_props::o_pakistan_5_1_grapple_device_idle_harper_gun, undefined, false );
	
	add_scene( "anthem_grapple_idle_body", "anthem_grappel", false, false, true );
	add_player_anim( "player_body", %player::p_pakistan_5_1_grapple_device_player_idle, false, undefined, undefined, true, 1, 30, 30, 80, 40, true, false );
	
	add_scene( "anthem_grapple", "anthem_grappel" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_1_grapple_device_harper, true, true );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_5_1_grapple_device_salazar, false, false, true );
	add_player_anim( "player_body", %player::p_pakistan_5_1_grapple_device_player, true );
	add_prop_anim( "harper_grappler", %animated_props::o_pakistan_5_1_grapple_device_harper_gun, undefined, true );
	add_prop_anim( "player_grappler", %animated_props::o_pakistan_5_1_grapple_device_player_gun, "t6_wpn_rappel_gun_prop_view", true );
	
	add_scene( "id_melee", "id_melee_guard_ai" );
	add_actor_anim( "id_melee_guard", %generic_human::ai_contextual_melee_necksnap );
	add_player_anim( "player_body", %player::int_contextual_melee_necksnap, true );
	
	add_scene( "tower_melee_guard_idle", "tower_melee_chair", false, false, true );
	add_actor_anim( "tower_guard", %generic_human::ai_contextual_melee_garrotesit_idle, true, false, false, true );
	
	add_scene( "tower_melee_kill", "tower_melee_chair" );
	add_actor_anim( "tower_guard", %generic_human::ai_contextual_melee_garrotesit_death, true, false, false, true );
	add_player_anim( "player_body", %player::int_contextual_melee_garrotesit, true );
	add_prop_anim( "tower_melee_chair", %animated_props::prop_contextual_melee_garrotesit_chair );
	add_prop_anim( "garrote", %animated_props::prop_contextual_melee_garrotesit_garrotewire_aligned, "t5_weapon_garrot_wire", true );
	
	add_scene( "tower_melee_death_pose", "tower_melee_chair", false, false, true );
	add_actor_anim( "tower_guard", %generic_human::ai_contextual_melee_garrotesit_deathpose, true, false, true, true );
	
	add_scene( "courtyard_btr_entrance", "anthem_gate_align" );
	add_actor_anim( "anthem_btr_guy1", %generic_human::ch_pakistan_5_3_activity_below_btr_gate_entrance_guy01, false, false, false, true );
	add_actor_anim( "anthem_btr_guy2", %generic_human::ch_pakistan_5_3_activity_below_btr_gate_entrance_guy02, false, false, false, true );
	add_actor_anim( "anthem_btr_guy3", %generic_human::ch_pakistan_5_3_activity_below_btr_gate_entrance_guy03, false, false, false, true );
	add_actor_anim( "anthem_btr_guy4", %generic_human::ch_pakistan_5_3_activity_below_btr_gate_entrance_guy04, false, false, false, true );
	add_actor_anim( "anthem_btr_guy5", %generic_human::ch_pakistan_5_3_activity_below_btr_gate_entrance_guy05, false, false, false, true );
	add_prop_anim( "anthem_cin_btr", %animated_props::v_pakistan_5_3_activity_below_btr_gate_entrance_btr, undefined, false );
	
	add_scene( "courtyard_air_controller", undefined, false, false, true, true );
	add_actor_anim( "air_controller", %generic_human::ch_pakistan_5_3_activity_below_air_controller, false, false, false, true );
	
	add_scene( "courtyard_mechanics", "courtyard_carport" );
	add_actor_model_anim( "btr_mechanic1", %generic_human::ch_pakistan_5_3_activity_below_btr_carport_guy01, undefined, true );
	add_actor_model_anim( "btr_mechanic2", %generic_human::ch_pakistan_5_3_activity_below_btr_carport_guy02, undefined, true );
	
	add_scene( "courtyard_train_clipboard", "anthem_train_align", false, false, true );
	add_actor_model_anim( "train_guy1", %generic_human::ch_pakistan_5_3_activity_below_train_platform_guy01, undefined, true );
	
	add_scene( "courtyard_train_tire", "anthem_train_align", false, false, true );
	add_actor_model_anim( "train_guy2", %generic_human::ch_pakistan_5_3_activity_below_train_platform_guy02, undefined, true );
	add_actor_model_anim( "train_guy3", %generic_human::ch_pakistan_5_3_activity_below_train_platform_guy03, undefined, true );
	
	add_scene( "courtyard_train_bolt", "anthem_train_align", false, false, true );
	add_actor_model_anim( "train_guy4", %generic_human::ch_pakistan_5_3_activity_below_train_platform_guy04, undefined, true );
	
	add_scene( "courtyard_train_box", "anthem_train_align" );
	add_actor_model_anim( "train_guy5", %generic_human::ch_pakistan_5_3_activity_below_train_platform_guy05, undefined, true );
	add_actor_model_anim( "train_guy6", %generic_human::ch_pakistan_5_3_activity_below_train_platform_guy06, undefined, true );
	add_prop_anim( "train_box1", %animated_props::o_pakistan_5_3_activity_below_train_platform_crate01, "dest_glo_dest_glo_crate01_d0", false );
	add_prop_anim( "train_box2", %animated_props::o_pakistan_5_3_activity_below_train_platform_crate02, "dest_glo_dest_glo_crate01_d0", false );
	add_prop_anim( "courtyard_cin_train", %animated_props::v_pakistan_5_3_activity_below_train_platform_train );
	
	add_scene( "confirm_menendez_soldiers", "anthem_stairs_align" );
	add_actor_model_anim( "confirm_menendez_soldier1", %generic_human::ch_pakistan_5_4_confirm_menendez_soldier01 );
	add_actor_model_anim( "confirm_menendez_soldier2", %generic_human::ch_pakistan_5_4_confirm_menendez_soldier02 );
	add_actor_model_anim( "confirm_menendez_soldier3", %generic_human::ch_pakistan_5_4_confirm_menendez_soldier03 );
	add_actor_model_anim( "confirm_menendez_soldier4", %generic_human::ch_pakistan_5_4_confirm_menendez_soldier04 );
	add_actor_model_anim( "confirm_menendez_soldier5", %generic_human::ch_pakistan_5_4_confirm_menendez_soldier05 );
	add_vehicle_anim( "confirm_menendez_gaz", %vehicles::v_pakistan_5_4_confirm_menendez_tigr );
	
	add_scene( "confirm_menendez_soldiers_idle", "confirm_menendez_gaz", false, false, true );
	add_actor_model_anim( "confirm_menendez_soldier1", %generic_human::ch_pakistan_5_4_tigr_patrol_idle_soldier01, undefined, true, "tag_body" );
	add_actor_model_anim( "confirm_menendez_soldier2", %generic_human::ch_pakistan_5_4_tigr_patrol_idle_soldier02, undefined, true, "tag_body" );
	add_actor_model_anim( "confirm_menendez_soldier3", %generic_human::ch_pakistan_5_4_tigr_patrol_idle_soldier03, undefined, true, "tag_body" );
	add_actor_model_anim( "confirm_menendez_soldier4", %generic_human::ch_pakistan_5_4_tigr_patrol_idle_soldier04, undefined, true, "tag_body" );
	add_actor_model_anim( "confirm_menendez_soldier5", %generic_human::ch_pakistan_5_4_tigr_patrol_idle_soldier05, undefined, true, "tag_body" );
	
	add_scene( "confirm_menendez_crew_idle", "anthem_stairs_align", false, false, true );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_4_confirm_menendez_idle_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_4_confirm_menendez_idle_leader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_4_confirm_menendez_idle_guard01, true, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_4_confirm_menendez_idle_guard02, true, false, false, true );
	
	add_scene( "confirm_menendez_crew", "anthem_stairs_align" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_4_confirm_menendez_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_4_confirm_menendez_leader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_4_confirm_menendez_guard01, true, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_4_confirm_menendez_guard02, true, false, false, true );
	
	add_scene( "menendez_path1", "anthem_stairs_align" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_5_menendez_path_1_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_5_menendez_path_1_letleader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_5_menendez_path_1_guard01, false, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_5_menendez_path_1_guard02, false, false, false, true );
	
	add_scene( "menendez_path1_idle", "anthem_stairs_align", false, false, true );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_5_menendez_path_1_idle_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_5_menendez_path_1_idle_letleader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_5_menendez_path_1_idle_guard01, false, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_5_menendez_path_1_idle_guard02, false, false, false, true );
	
	add_scene( "menendez_path2", "anthem_bridge_align" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_5_menendez_path_2_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_5_menendez_path_2_letleader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_5_menendez_path_2_guard01, false, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_5_menendez_path_2_guard02, false, false, false, true );
	
	add_scene( "menendez_path2_idle", "anthem_bridge_align", false, false, true );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_5_menendez_path_2_idle_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_5_menendez_path_2_idle_letleader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_5_menendez_path_2_idle_guard01, false, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_5_menendez_path_2_idle_guard02, false, false, false, true );
	
	add_scene( "menendez_path3", "anthem_bridge_align" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_5_menendez_path_3_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_5_menendez_path_3_letleader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_5_menendez_path_3_guard01, false, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_5_menendez_path_3_guard02, false, false, false, true );
	
	add_scene( "menendez_path3_idle", "anthem_bridge_align", false, false, true );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_5_menendez_path_3_idle_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_5_menendez_path_3_idle_letleader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_5_menendez_path_3_idle_guard01, false, false, false, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_5_menendez_path_3_idle_guard02, false, false, false, true );
	
	add_scene( "menendez_path4", "roof_scene" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_5_menendez_path_4_menendez, true, false, false, true );
	add_actor_anim( "militia_leader", %generic_human::ch_pakistan_5_5_menendez_path_4_letleader, true, false, false, true );
	add_actor_anim( "bodyguard1", %generic_human::ch_pakistan_5_5_menendez_path_4_guard01, false, false, true, true );
	add_actor_anim( "bodyguard2", %generic_human::ch_pakistan_5_5_menendez_path_4_guard02, false, false, true, true );
	
	add_scene( "player_id_approach", "anthem_stairs_align" );
	add_player_anim( "player_body", %player::p_pakistan_5_5_follow_menendez_approach_player, true );
	
	add_scene( "id_melee_approach_harper", "anthem_grappel", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_patrol_guard_kill_approach_harper, false, false, false, true );
	
	add_scene( "id_melee_approach_guard", "anthem_grappel" );
	add_actor_anim( "id_melee_guard", %generic_human::ch_pakistan_5_4_patrol_guard_kill_approach_guard, false, false, false, false );
	
	add_scene( "id_melee_approach_idle_harper", "anthem_grappel", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_patrol_guard_kill_idle_harper, false, false, false, true );
	
	add_scene( "id_melee_approach_idle_guard", "anthem_grappel", false, false, true );
	add_actor_anim( "id_melee_guard", %generic_human::ch_pakistan_5_4_patrol_guard_kill_idle_guard, false, false, false, false );
	
	add_scene( "id_melee_success", "anthem_grappel" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_patrol_guard_kill_success_harper, false, false, false, true );
	
	add_scene( "id_melee_react", "anthem_grappel" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_patrol_guard_kill_react_harper, false, false, false, true );
	add_actor_anim( "id_melee_guard", %generic_human::ch_pakistan_5_4_patrol_guard_kill_react_guard, false, false, false, false );
	
	add_scene( "harper_path1", "anthem_grappel", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_drop_down_stealth_harper, false, false, false, true );
	
	add_scene( "harper_path2", "roof_station", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_slide_to_balcony_harper, false, false, false, true );
	
	add_scene( "harper_path2_idle", "roof_station", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_balcony_crouch_idle_harper, false, false, false, true );
	
	add_scene( "harper_path2_crawl", "roof_station" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_balcony_crawl_harper, false, false, false, true );
	
	add_scene( "harper_path2_prone", "roof_station", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_balcony_prone_harper, false, false, false, true );
	
	add_scene( "harper_path2_climb", "roof_station" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_balcony_climb_harper, false, false, false, true );
	
	add_scene( "harper_path3", "roof_station", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_station_approach_harper, false, false, false, true );
	
	add_scene( "harper_rooftop_door_idle", "roof_station", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_station_wait_harper, false, false, false, true );
	
	add_scene( "harper_rooftop_door_close", "roof_station" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_station_doorclose_harper, false, false, false, true );
	
	add_scene( "rooftop_entrance_open", "roof_station" );
	add_prop_anim( "guard_entrance", %animated_props::o_pakistan_5_4_station_approach_door1, undefined, false, true );
	
	add_scene( "rooftop_entrance_close", "roof_station" );
	add_prop_anim( "guard_entrance", %animated_props::o_pakistan_5_4_station_doorclose_door1, undefined, false, true );
	
	add_scene( "rooftop_exit_open", "roof_station" );
	add_prop_anim( "guard_exit", %animated_props::o_pakistan_5_4_station_exit_door2, undefined, false, true );
	
	add_scene( "tower_guard_idle", "roof_station", false, false, true );
	add_actor_anim( "tower_guard", %generic_human::ch_pakistan_5_4_station_idle_guard, true, false, false, false );
	add_prop_anim( "tower_guard_chair", %animated_props::o_pakistan_5_4_station_idle_chair, "anim_glo_melee_chair_01", false, true );
	
	add_scene( "harper_path3_idle", "roof_station", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_station_idle_harper, false, false, false, true );
	
	add_scene( "harper_path4", "roof_station" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_4_station_exit_harper, false, false, false, true );
	
	add_scene( "harper_path4_hide", "pipe_slide2", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_8_drone_hide_arrival_harper, false, false, false, true );
	
	add_scene( "harper_path4_hide_idle", "pipe_slide2", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_8_drone_hide_idle_harper, false, false, false, true );
	
	add_scene( "harper_path4_hide_exit", "pipe_slide2" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_8_drone_hide_exit_harper, false, false, false, true );
	
	add_scene( "harper_jump_roll", "pipe_slide", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_10_jump_roll_harper, false, false, false, true );
	add_notetrack_custom_function( "harper", "attach_knife", maps\pakistan_roof_meeting::melee_attach_knife_harper );
	add_notetrack_custom_function( "harper", "detach_knife", maps\pakistan_roof_meeting::melee_detach_knife_harper );
	add_notetrack_custom_function( "harper", "blood_fx", maps\pakistan_roof_meeting::melee_bloodfx_knife_harper );
	
	add_scene( "enemy_jump_roll", "pipe_slide" );
	add_actor_anim( "rooftop_slide_enemy", %generic_human::ch_pakistan_5_10_jump_roll_enemy, false, false, false );
	
	add_scene( "rooftop_meeting", "roof_scene" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_7_meeting_menendez, true, false, true, true );
	add_actor_anim( "defalco", %generic_human::ch_pakistan_5_7_meeting_defalco, true, false, true, true );
	add_notetrack_flag( "menendez", "start_soldiers", "anthem_start_soldiers_exit" );
	
	add_scene( "rooftop_meeting_soldiers_idle", "roof_scene", false, false, true );
	add_actor_anim( "rooftop_meeting_soldier1", %generic_human::ch_pakistan_5_7_meeting_idle_soldier01, false, false, false, true );
	add_actor_anim( "rooftop_meeting_soldier2", %generic_human::ch_pakistan_5_7_meeting_idle_soldier02, false, false, false, true );
	add_actor_anim( "rooftop_meeting_soldier3", %generic_human::ch_pakistan_5_7_meeting_idle_soldier03, false, false, false, true );
	add_actor_anim( "rooftop_meeting_soldier4", %generic_human::ch_pakistan_5_7_meeting_idle_soldier04, false, false, false, true );
	add_actor_anim( "rooftop_meeting_soldier5", %generic_human::ch_pakistan_5_7_meeting_idle_soldier05, false, false, false, true );
	add_actor_model_anim( "rooftop_meeting_soldier6", %generic_human::ch_pakistan_5_7_meeting_idle_soldier06, undefined, false );
	add_actor_model_anim( "rooftop_meeting_soldier7", %generic_human::ch_pakistan_5_7_meeting_idle_soldier07, undefined, false );
	add_actor_model_anim( "rooftop_meeting_soldier8", %generic_human::ch_pakistan_5_7_meeting_idle_soldier08, undefined, false );
	
	add_scene( "rooftop_meeting_soldiers_exit", "roof_scene" );
	add_actor_anim( "rooftop_meeting_soldier1", %generic_human::ch_pakistan_5_7_meeting_soldier01, false, false, true, true );
	add_actor_anim( "rooftop_meeting_soldier2", %generic_human::ch_pakistan_5_7_meeting_soldier02, false, false, true, true );
	add_actor_anim( "rooftop_meeting_soldier3", %generic_human::ch_pakistan_5_7_meeting_soldier03, false, false, true, true );
	add_actor_anim( "rooftop_meeting_soldier4", %generic_human::ch_pakistan_5_7_meeting_soldier04, false, false, true, true );
	add_actor_anim( "rooftop_meeting_soldier5", %generic_human::ch_pakistan_5_7_meeting_soldier05, false, false, true, true );
	add_actor_model_anim( "rooftop_meeting_soldier6", %generic_human::ch_pakistan_5_7_meeting_soldier06, undefined, true );
	add_actor_model_anim( "rooftop_meeting_soldier7", %generic_human::ch_pakistan_5_7_meeting_soldier07, undefined, true );
	add_actor_model_anim( "rooftop_meeting_soldier8", %generic_human::ch_pakistan_5_7_meeting_soldier08, undefined, true );
	
	add_scene( "rooftop_observation_harper_wait_idle", "pipe_slide", true, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_10_wait_harper, false, false, false );
	
	add_scene( "trainyard_melee_harper_approach", "drone_scene", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_11_contextual_melee_approach_harper, false, false, false, true );

	add_scene( "trainyard_melee_harper_cross_bridge", "bridge_crossing", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_10_cross_bridge_harper, false, false, false, true );
	
	add_scene( "trainyard_melee_harper_approach_idle", "drone_scene", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_11_contextual_melee_idle_harper, false, false, false, true );
	
	add_scene( "trainyard_melee_guards_idle", "drone_scene", false, false, true );
	add_actor_anim( "trainyard_melee_guard1", %generic_human::ch_pakistan_5_11_contextual_melee_idle_guard01, false, false, false, true );
	add_actor_anim( "trainyard_melee_guard2", %generic_human::ch_pakistan_5_11_contextual_melee_idle_guard02, false, false, false, true );
	
	add_scene( "trainyard_melee_tigr_idle", "drone_scene", false, false, true );
	add_prop_anim( "melee_tigr", %animated_props::v_pakistan_5_11_contextual_melee_tigr );
	
	add_scene( "trainyard_melee_attack", "drone_scene" );
	add_actor_anim( "trainyard_melee_guard1", %generic_human::ch_pakistan_5_11_contextual_melee_guard01, true, false, true, true );
	add_actor_anim( "trainyard_melee_guard2", %generic_human::ch_pakistan_5_11_contextual_melee_guard02, true, false, true, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_11_contextual_melee_harper, true, true, false, true );
	add_player_anim( "player_body", %player::p_pakistan_5_11_contextual_melee_player, true );
	add_notetrack_custom_function( "player_body", "attach_knife", maps\pakistan_roof_meeting::melee_attach_knife_player );
	add_notetrack_custom_function( "player_body", "detach_knife", maps\pakistan_roof_meeting::melee_detach_knife_player );
	add_notetrack_custom_function( "player_body", "blood_fx", maps\pakistan_roof_meeting::melee_bloodfx_knife_player );
	
	add_scene( "trainyard_melee_attack_door", "drone_scene" );
	add_prop_anim( "melee_door", %animated_props::o_pakistan_5_11_contextual_melee_door );
	
	add_scene( "trainyard_melee_harper_door_open", "drone_scene", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_11_approach_door_harper, false, false, false, true );
	
	add_scene( "trainyard_melee_door_door_open", "drone_scene" );
	add_prop_anim( "drone_entrance", %animated_props::o_pakistan_5_11_approach_door_door );
	
	add_scene( "trainyard_melee_harper_door_idle", "drone_scene", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_11_idle_door_harper, false, false, false, true );
	
	add_scene( "trainyard_melee_harper_door_close", "drone_scene" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_11_close_door_harper, false, false, false, true );
	add_prop_anim( "drone_entrance", %animated_props::o_pakistan_5_11_close_door_door );
	
	add_scene( "trainyard_drone_meeting_harper_approach", "drone_scene", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_13_get_closer_arrival_harper, false, false, false, true );
	
	add_scene( "trainyard_drone_meeting_harper_approach_idle", "drone_scene", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_13_get_closer_idle_harper, false, false, false, true );
	
	add_scene( "trainyard_drone_meeting_harper_exit", "drone_scene" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_13_get_closer_exit_harper, false, false, false, true );
	
	add_scene( "trainyard_drone_meeting", "drone_scene" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_13_get_closer_menendez, true, false, false, true );
	add_actor_anim( "defalco", %generic_human::ch_pakistan_5_13_get_closer_defalco, true, false, false, true );
	//add_notetrack_flag( "menendez", "start_train", "railyard_train_enter" );
	
	add_scene( "trainyard_drone_meeting_gantry", "drone_scene" );
	add_prop_anim( "drone_gantry", %animated_props::v_pakistan_5_13_get_closer_gantry, undefined, false );
	add_prop_anim( "dead_drone", %animated_props::v_pakistan_5_13_get_closer_drone, undefined, false );
	
	add_scene( "trainyard_millibar_meeting_harper_approach", "drone_scene", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_5_14_millibar_swim_harper, true, false, false, true );
	
	
	
	// switch align node
	
	add_scene( "trainyard_millibar_meeting_harper_idle", "elevator_node", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_1_grenades_harper_idle, true, false, false, true );
	
	add_scene( "trainyard_millibar_meeting_player_approach", "elevator_node" );
	add_player_anim( "player_body", %player::p_pakistan_5_14_millibar_approach_player, true );
	add_notetrack_flag( "player_body", "start_millibar", "underground_millibar_on" );
	
	add_scene( "trainyard_millibar_meeting_player_idle", "elevator_node", false, false, true );
	add_player_anim( "player_body", %player::p_pakistan_5_14_millibar_player, true, undefined, undefined, true, 1, 20, 20, 20, 20, true, false );
	
	add_scene( "trainyard_millibar_meeting_enemy_idle", "elevator_node", false, false, true );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_5_14_millibar_menendez, true, false, false, true );
	add_actor_anim( "defalco", %generic_human::ch_pakistan_5_14_millibar_defalco, true, false, false, true );
	
	add_scene( "trainyard_millibar_meeting_soldiers_idle", "elevator_node", false, false, true );
	add_actor_anim( "millibar_soldier1", %generic_human::ch_pakistan_6_1_grenades_idle_soldier01, false, false, false, true );
	add_actor_anim( "millibar_soldier2", %generic_human::ch_pakistan_6_1_grenades_idle_soldier02, false, false, false, true );
	add_actor_anim( "millibar_soldier3", %generic_human::ch_pakistan_6_1_grenades_idle_soldier03, false, false, false, true );
	add_actor_anim( "millibar_soldier4", %generic_human::ch_pakistan_6_1_grenades_idle_soldier04, false, false, false, true );
	
	
	add_scene( "trainyard_harper_millibar_grenades", "elevator_node" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_1_grenades_harper, true, false, false, true );
	add_notetrack_custom_function( "harper", "start_guy", ::start_railing_guy );
	add_notetrack_level_notify( "harper", "knife_cut", "play_blood_fx");
	
	
	add_scene( "trainyard_millibar_grenade_railing_guard", "elevator_node");
	add_actor_anim( "knifed_guard", %generic_human::ch_pakistan_6_1_grenades_soldier05, true, false, false, true );
	
	add_scene( "trainyard_millibar_grenades", "elevator_node" );
	add_player_anim( "player_body", %player::p_pakistan_6_1_grenades_player, true );
	add_notetrack_custom_function( "player_body", "explosion", ::incendiary_grenade_explosion );
	add_notetrack_level_notify( "player_body", "start_millibar", "millibar_start");
	add_notetrack_level_notify( "player_body", "stop_millibar", "millibar_stop");
	add_notetrack_level_notify( "player_body", "surface_break", "surface_break");
	add_notetrack_level_notify( "player_body", "jamming", "grenade_jamming");
	add_notetrack_level_notify( "player_body", "delete_grates", "delete_grates");
	
	
	add_scene( "trainyard_millibar_grenades_enemy_heroes", "elevator_node" );
	add_actor_anim( "menendez", %generic_human::ch_pakistan_6_1_grenades_menendez, true, false, true, true );
	add_actor_anim( "defalco", %generic_human::ch_pakistan_6_1_grenades_defalco, true, false, true, true );
	
	add_scene( "trainyard_millibar_grenades_enemies", "elevator_node" );
	add_actor_anim( "millibar_soldier1", %generic_human::ch_pakistan_6_1_grenades_soldier01, false, false, true, true );
	add_actor_anim( "millibar_soldier2", %generic_human::ch_pakistan_6_1_grenades_soldier02, false, false, true, true );
	add_actor_anim( "millibar_soldier3", %generic_human::ch_pakistan_6_1_grenades_soldier03, false, false, true, true );
	add_actor_anim( "millibar_soldier4", %generic_human::ch_pakistan_6_1_grenades_soldier04, false, false, true, true );
	
	
	add_scene( "trainyard_millibar_grenades_fire_grate", "elevator_node" );
	add_prop_anim( "gernade_grate_1", %animated_props::o_pakistan_6_1_grenades_door2, undefined, true );
	add_prop_anim( "grenade_grate_2", %animated_props::o_pakistan_6_1_grenades_door2, undefined, true );
	
	add_scene( "trainyard_millibar_grenades_fire", "elevator_node" );
	add_prop_anim( "incendiary1", %animated_props::o_pakistan_6_1_grenades_grenade_01, "t6_wpn_grenade_incendiary_prop", true );
	add_prop_anim( "incendiary2", %animated_props::o_pakistan_6_1_grenades_grenade_02, "t6_wpn_grenade_incendiary_prop", true );
	
	add_scene( "claw_garage_defend_harper_start", "drone_scene", true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_5_defend_area_harper, false, false, false, true );
	
	add_scene( "claw_garage_defend_door_start", "drone_scene" );
	add_prop_anim( "garage_entrance", %animated_props::o_pakistan_6_5_defend_area_door );
	
	add_scene( "claw_garage_defend_soldiers_start", "drone_scene" );
	add_actor_anim( "garage_soldier1", %generic_human::ch_pakistan_6_5_defend_area_enemy01, false, false, true, false );
	add_actor_anim( "garage_soldier2", %generic_human::ch_pakistan_6_5_defend_area_enemy02, false, false, true, false );
	
	add_scene( "claw_start_player", undefined, false, false, false, true );
	add_player_anim( "player_body", %player::p_pakistan_6_5_player_controls_claws_player, true );
	
	add_scene( "claw_start_breach", "drone_scene" );
	add_actor_anim( "door_breacher1", %generic_human::ch_pakistan_6_5_door_assult_enemy01, false, false, false, false );
	add_actor_anim( "door_breacher2", %generic_human::ch_pakistan_6_5_door_assult_enemy02, false, false, false, false );
	add_actor_anim( "door_breacher3", %generic_human::ch_pakistan_6_5_door_assult_enemy03, false, false, false, false );
	add_actor_anim( "door_breacher4", %generic_human::ch_pakistan_6_5_door_assult_enemy04, false, false, false, false );
	add_actor_anim( "door_breacher5", %generic_human::ch_pakistan_6_5_door_assult_enemy05, false, false, false, false );
	add_actor_anim( "door_breacher6", %generic_human::ch_pakistan_6_5_door_assult_enemy06, false, false, false, false );
	
	add_scene( "garage_exit_harper", "claw_self_destruct" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_9_climb_out_harper_start, false, false, false, true );
	add_prop_anim( "garage_entrance", %animated_props::o_pakistan_6_9_climb_out_door );
	
	add_scene( "garage_exit_harper_idle", "claw_self_destruct", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_9_climb_out_harper_idle01, false, false, false, true );
	
	add_scene( "claw_soct_entrance_enemy", "claw_self_destruct" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_9_climb_out_harper, false, false, false, true );
	add_vehicle_anim( "claw_enemy_soct", %vehicles::v_pakistan_6_9_climb_out_enemy_soct, false );
	add_actor_anim( "claw_enemy_driver", %generic_human::ch_pakistan_6_9_climb_out_enemy_driver, true, true, false, true );
	add_actor_anim( "claw_enemy_gunner", %generic_human::ch_pakistan_6_9_climb_out_enemy_gunner, true, true, false, true );
	add_notetrack_custom_function( "claw_enemy_soct", "start_spray", maps\pakistan_claw::soct_fire_weapon );
	add_notetrack_custom_function( "claw_enemy_soct", "end_spray", maps\pakistan_claw::soct_stop_fire_weapon );
	
	add_scene( "claw_soct_harper_idle", "claw_self_destruct", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_9_climb_out_harper_idle02, false, false, false, true );
	
	add_scene( "claw_soct_entrance_ally", "claw_self_destruct" );
	add_vehicle_anim( "claw_player_soct", %vehicles::v_pakistan_6_11_mount_soct_player_soct, false );
	add_vehicle_anim( "claw_salazar_soct", %vehicles::v_pakistan_6_11_mount_soct_salazar_soct, false );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_6_11_mount_soct_salazar, false, false, false, true );
	add_actor_anim( "claw_redshirt", %generic_human::ch_pakistan_6_11_mount_soct_redshirt, false, false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_11_mount_soct_harper, false, false, false, true );
	
	add_scene( "claw_soct_mount_player", "claw_self_destruct" );
	add_player_anim( "player_body", %player::p_pakistan_6_11_mount_soct_player, true );
	
	add_scene( "claw_soct_exit", "claw_self_destruct" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_6_11_mount_soct_harper, false, false, false, true );
	add_actor_anim( "claw_redshirt", %generic_human::ch_pakistan_6_11_mount_soct_redshirt, false, false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_6_11_mount_soct_salazar, false, false, false, true );
	add_vehicle_anim( "claw_player_soct", %vehicles::v_pakistan_6_11_mount_soct_player_soct, false );
	add_vehicle_anim( "claw_salazar_soct", %vehicles::v_pakistan_6_11_mount_soct_salazar_soct, false );	
	
	precache_assets();
	
	maps\voice\voice_pakistan_2::init_voice();
}

//-- exploder for incindiary grenades after underground meeting

#define INCENDIARY_WATER 5
	
incendiary_grenade_explosion( e_temp )
{
	
	level.player PlayRumbleOnEntity("explosion_generic");
	e_fire_water = GetEnt( "firewater", "targetname" );
	e_fire_water SetclientFlag( INCENDIARY_WATER );
	
	//--TODO: REPLACE THIS WITH A NOTETRACK
	level.player ShellShock("default", 3);
	wait( 1.0 );
	
	level notify("trigger_grenade_room_change");
	level thread maps\createart\pakistan_2_art::underground_fire_fx_vision();
	
	level waittill("surface_break");
	exploder( 610 );
	wait(5);
	level thread maps\createart\pakistan_2_art::turn_back_to_default();
	
	
	
	
}

start_railing_guy( guy)
{
	level thread run_scene("trainyard_millibar_grenade_railing_guard");
	wait(0.05);
	knife_guard = getent("knife_guard", "targetname");
	level waittill("play_blood_fx");
	PlayFXOnTag(level._effect[ "underwater_blood"], knife_guard, "J_Head");
	
}