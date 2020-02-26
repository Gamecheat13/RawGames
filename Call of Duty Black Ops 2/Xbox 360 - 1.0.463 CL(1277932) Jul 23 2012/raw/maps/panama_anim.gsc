#include maps\_utility;
#include maps\_scene;

#using_animtree ("generic_human");
main()
{
	maps\voice\voice_panama::init_voice();
	
	patroller_anims();
	
	//section anim functions
	house_anims();
	airfield_anims();
	motel_anims();
	
	//call after all scenes are setup
	precache_assets();
}

house_anims()
{
	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 15;
	n_bottom_arc = 15;
	b_use_tag_angles = true;
	
	//Player putting his hat on
	add_scene( "player_exits_hummer", "front_yard_align" );
	add_prop_anim( "player_hat", %animated_props::o_pan_01_01_intro_hat, "c_usa_milcas_woods_cap", true );
	add_vehicle_anim( "player_hummer", %vehicles::v_pan_01_01_intro_out_of_hummer_hum1 );
	add_player_anim( "player_body", %player::p_pan_01_01_intro_grab_hat, true );
	//add_notetrack_custom_function( "player_body", "hat_overlay", maps\panama_house::toggle_hat_overlay );
				
	//Player putting his hat on (extra cam)
	add_scene( "player_exits_hummer_xcam", "front_yard_align_extracam" );
	add_actor_model_anim( "reflection_woods", %generic_human::p_pan_01_01_intro_grab_hat_reflection, "c_usa_milcas_woods_fb", true );
	add_prop_anim( "player_hat_xcam", %animated_props::o_pan_01_01_intro_hat_reflection, "c_usa_milcas_woods_cap", true );
	add_prop_anim( "player_hummer_xcam", %animated_props::v_pan_01_01_intro_out_of_hummer_hum1, "veh_iw_humvee_camo", true );
		
	//Mason sitting in Hummer
	add_scene( "mason_sits_hummer", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_frontyard_idle_mason, true );
	add_vehicle_anim( "mason_hummer", %vehicles::v_pan_01_01_intro_frontyard_idle_humvee );
	
	//Mason exits Hummer and greets McKnight
	add_scene( "mason_greets_mcknight", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_frontyard_mason );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_frontyard_mcknight, true );
	add_vehicle_anim( "mason_hummer", %vehicles::v_pan_01_01_intro_frontyard_humvee );
	add_prop_anim( "m_front_door", %animated_props::o_pan_01_01_intro_frontyard_door, undefined, false, true );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_01_intro_frontyard_hat, "c_usa_milcas_mason_cap" );
	
	//Mason waits at front gate
	add_scene( "mason_wait_gate", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_02_intro_gate_wait_mason );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_02_intro_gate_wait_hat, "c_usa_milcas_mason_cap" );
	
	//To the backyard
	add_scene( "front_gate", "front_yard_align" );
	add_prop_anim( "m_front_gate", %animated_props::o_pan_01_03_intro_backyard_enter_gate, undefined, false, true );
	
	add_scene( "squad_to_backyard", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_03_intro_backyard_enter_mason );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_03_intro_backyard_enter_mcknight );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_03_intro_backyard_enter_hat, "c_usa_milcas_mason_cap" );
	add_prop_anim( "beer", %animated_props::o_pan_01_03_intro_backyard_enter_beer, "p6_anim_beer_pack" );
	add_prop_anim( "mason_beer", %animated_props::o_pan_01_03_intro_backyard_enter_beer_can01, "p6_anim_beer_can" );
	add_prop_anim( "mcknight_beer", %animated_props::o_pan_01_03_intro_backyard_enter_beer_can02, "p6_anim_beer_can" );
	
	//Wait at table
	add_scene( "wait_table", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_04_intro_backyard_wait_mason );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_04_intro_backyard_wait_mcknight );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_04_intro_backyard_wait_hat, "c_usa_milcas_mason_cap" );
	add_prop_anim( "beer", %animated_props::o_pan_01_04_intro_backyard_wait_beer, "p6_anim_beer_pack" );
	add_prop_anim( "mason_beer", %animated_props::o_pan_01_04_intro_backyard_wait_beer_can01, "p6_anim_beer_can" );
	add_prop_anim( "mcknight_beer", %animated_props::o_pan_01_04_intro_backyard_wait_beer_can02, "p6_anim_beer_can" );
	
	//Player grabs bag from shed
	add_scene( "get_bag", "front_yard_align" );
	add_player_anim( "player_body", %player::ch_pan_01_05_intro_get_bag_player, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_05_intro_get_bag_mason );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_05_intro_get_bag_mcknight );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_05_intro_get_bag_hat, "c_usa_milcas_mason_cap" );
	add_prop_anim( "beer", %animated_props::o_pan_01_05_intro_get_bag_beer, "p6_anim_beer_pack" );
	add_prop_anim( "bag", %animated_props::o_pan_01_05_intro_get_bag_duffle, "p6_anim_duffle_bag", true );
	add_prop_anim( "pajamas", %animated_props::o_pan_01_05_intro_get_bag_pajamas, "p6_anim_cloth_pajamas", true );
	add_prop_anim( "coke_1", %animated_props::o_pan_01_05_intro_get_bag_coke01, "p6_anim_cocaine", true );
	add_prop_anim( "coke_2", %animated_props::o_pan_01_05_intro_get_bag_cocaine02, "p6_anim_cocaine", true );
	add_prop_anim( "mason_beer", %animated_props::o_pan_01_05_intro_get_bag_beer_can01, "p6_anim_beer_can", true );
	add_prop_anim( "mcknight_beer", %animated_props::o_pan_01_05_intro_get_bag_beer_can02, "p6_anim_beer_can" );
	
	add_scene( "get_bag_door", "front_yard_align" );
	add_prop_anim( "m_shed_door_right", %animated_props::o_pan_01_05_intro_get_bag_door, undefined, false, true );
	
	//XCam shed
	add_scene( "reflection_woods_grabs_bag", "front_yard_align_extracam" );
	add_actor_model_anim( "reflection_woods", %generic_human::ch_pan_01_05_intro_get_bag_player_reflection, "c_usa_milcas_woods_fb", true );
	add_prop_anim( "reflection_bag", %animated_props::o_pan_01_01_intro_get_bag_mirrorbag, "p6_anim_duffle_bag", true );
	add_prop_anim( "player_hat_xcam", %animated_props::o_pan_01_05_intro_get_bag_hat_reflection, "c_usa_milcas_woods_cap", true );
	
	add_scene( "reflection_woods_grabs_bag_door", "front_yard_align_extracam" );
	add_prop_anim( "m_mirrored_shed_door", %animated_props::o_pan_01_05_intro_get_bag_door_reflection, "p6_shed_door_right", false, true );
	
	//Mason and McKnight leave backyard table
	add_scene( "leave_table", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_06_intro_backyard_leave_mason );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_06_intro_backyard_leave_mcknight );
	add_prop_anim( "beer", %animated_props::o_pan_01_06_intro_backyard_leave_beer, "p6_anim_beer_pack" );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_06_intro_backyard_leave_hat, "c_usa_milcas_mason_cap" );
	add_prop_anim( "mcknight_beer", %animated_props::o_pan_01_06_intro_backyard_leave_beer_can02, "p6_anim_beer_can" );
	
	add_scene( "leave_table_wait", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_07_intro_backyard_leave_wait_mason );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_07_intro_backyard_leave_wait_mcknight );
	add_prop_anim( "beer", %animated_props::o_pan_01_07_intro_backyard_leave_wait_beer, "p6_anim_beer_pack" );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_07_intro_backyard_leave_wait_hat, "c_usa_milcas_mason_cap" );
	add_prop_anim( "mcknight_beer", %animated_props::o_pan_01_07_intro_backyard_leave_wait_beer_can02, "p6_anim_beer_can" );
	
	//Gringos
	add_scene( "player_outro", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_07_gringos_mason, true, false, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_07_gringos_mcknight, true, false, true );
	add_actor_anim( "gringo_guy_1", %generic_human::ch_pan_01_07_gringos_backguy1, true, false, true );
	add_actor_anim( "gringo_guy_2", %generic_human::ch_pan_01_07_gringos_backguy2, true, false, true );
	add_actor_anim( "gringo_driver", %generic_human::ch_pan_01_07_gringos_driver, true, false, true );
	add_actor_anim( "gringo_passenger", %generic_human::ch_pan_01_07_gringos_passenger, true, false, true );
	add_actor_anim( "gringo_tagger", %generic_human::ch_pan_01_07_gringos_tagger, true, false, true );
	add_prop_anim( "beer", %animated_props::o_pan_01_07_gringos_beer, "p6_anim_beer_pack" );
	add_prop_anim( "mason_hat", %animated_props::o_pan_01_07_gringos_hat, "c_usa_milcas_mason_cap" );
	add_prop_anim( "mcknight_beer", %animated_props::o_pan_01_07_gringos_beer_can, "p6_anim_beer_can");
	add_vehicle_anim( "vh_panamanian_jeep", %vehicles::v_pan_01_07_gringos_truck, true, "tag_trunk" );
	add_vehicle_anim( "mason_hummer", %vehicles::v_pan_01_07_gringos_humvee );
	
	
	
	add_player_anim( "player_body", %player::ch_pan_01_07_gringos_player, true );
	
	add_scene( "outro_back_gate", "front_yard_align" );
	add_prop_anim( "m_back_gate", %animated_props::o_pan_01_01_intro_end_gate_b, undefined, false, true );
	
	add_scene( "house_end_flag", "vh_panamanian_jeep" );
	add_prop_anim( "truck_flag", %animated_props::fxanim_panama_truck_flag_anim, "fxanim_panama_truck_flag_mod", true, false, undefined, "tag_origin" );
	
	
	
	//OLD ANIMS////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// 
	//Mason Getting out of Hummer
	add_scene( "mason_exits_hummer", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_out_of_hummer_mason, true );
	add_notetrack_custom_function( "mason", "start_frontdoor_skinner", maps\panama_house::skinner_wave_us_back );
	
	add_scene( "mason_hummer", "front_yard_align" );	
	add_vehicle_anim( "mason_hummer", %vehicles::v_pan_01_01_intro_out_of_hummer_hum2 );

	//Skinner/Jane Arguing
	add_scene( "skinner_jane_argue_loop", "front_yard_align", false, false, true );
	add_actor_anim( "jane", %generic_human::ch_pan_01_01_intro_argue_idle_jane, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_argue_idle_skinner, true );
	
	//Skinner waves player around
	add_scene( "skinner_waves_us_back", "front_yard_align" );
	add_actor_anim( "jane", %generic_human::ch_pan_01_01_intro_frontdoor_jane, true, false, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_frontdoor_skinner, true );
	
	add_scene( "house_front_door", "front_yard_align" );	
	add_prop_anim( "m_front_door", %animated_props::o_pan_01_01_intro_frontdoor_frontdoor, undefined, false, true );
	
	//Mason idles the gate
	add_scene( "mason_gate_loop", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_gate_idle_mason, true );
	
	//Mason opens the gate to dog
	add_scene( "backyard_walk", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_tobackyard_mason, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_tobackyard_skinner, true );
//	add_actor_anim( "skinners_dog", %dog::ch_pan_01_01_intro_tobackyard_dog, false, false, true );
//	add_actor_model_anim( "ai_skinners_dog", %generic_human::ch_pan_01_01_intro_tobackyard_dog, undefined, true );
//	add_prop_anim( "skinners_dog", %animated_props::ch_pan_01_01_intro_tobackyard_dog, "german_sheperd_dog", true );
	add_prop_anim( "beer", %animated_props::o_pan_01_01_intro_tobackyard_beer, "p6_anim_beer_pack" );
	
	add_scene( "house_front_gate", "front_yard_align" );	
	add_prop_anim( "m_front_gate", %animated_props::o_pan_01_01_intro_tobackyard_gate_a, undefined, false, true );
	
	//Mason and Skinner beer idle
	add_scene( "beer_loop", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_drinking_idle_mason, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_drinking_idle_skinner, true );
	add_prop_anim( "beer", %animated_props::o_pan_01_01_intro_drinking_idle_beer, "p6_anim_beer_pack" );
	
//	add_scene( "reflection_shed_door", "front_yard_align_extracam" );	
//	add_prop_anim( "m_mirrored_shed_door", %animated_props::o_pan_01_01_intro_get_bag_shed_door_mirror, undefined, false, true );		

	//Player and Full Woods grabs bag
	add_scene( "player_grabs_bag", "front_yard_align" );
	add_prop_anim( "bag", %animated_props::o_pan_01_01_intro_get_bag_bag, "p6_anim_duffle_bag", true );
	add_prop_anim( "pajamas", %animated_props::o_pan_01_01_intro_get_bag_pajamas, "p6_anim_cloth_pajamas", true );
	add_prop_anim( "coke_1", %animated_props::o_pan_01_01_intro_get_bag_coke1, "p6_anim_cocaine", true );
	add_prop_anim( "coke_2", %animated_props::o_pan_01_01_intro_get_bag_coke2, "p6_anim_cocaine", true );
	add_player_anim( "player_body", %player::p_pan_01_01_intro_get_bag_player, true );
	
	// TODO: uncomment this
//	b_do_delete = true;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 15;
//	n_bottom_arc = 15;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_01_01_intro_get_bag_player,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
	
	add_scene( "shed_door", "front_yard_align" );	
	add_prop_anim( "m_shed_door_right", %animated_props::o_pan_01_01_intro_get_bag_shed_door, undefined, false, true );			
	
	//Mason/Skinner bag anim
	add_scene( "bag_anim", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_get_bag_mason, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_get_bag_skinner, true );
	add_prop_anim( "beer", %animated_props::o_pan_01_01_intro_get_bag_beer, "p6_anim_beer_pack" );

	add_scene( "exit_gate_loop", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_gate_b_idle_mason, true );	
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_gate_b_idle_skinner, true );	
}


anim_seals_on_zodiac( player )
{
	end_scene( "zodiac_approach_seals" );
	
	level thread run_scene( "zodiac_approach_seals_turn" );
	
	scene_wait( "zodiac_approach_seals_turn" );
	
	level thread run_scene( "zodiac_approach_seals" );
}


airfield_anims()
{
	add_scene( "zodiac_approach_boat", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_player", %animated_props::o_pan_02_01_beach_approach_zodiac, undefined, true );
	add_notetrack_custom_function( "m_intro_zodiac_player", "underwater_in", ::underwater_snapshot_on );
	add_notetrack_custom_function( "m_intro_zodiac_player", "underwater_out", ::underwater_snapshot_off );
		

	add_scene( "zodiac_approach_seals", "m_intro_zodiac_player", false, false, true );
	add_actor_anim( "ai_zodiac_seal_1", %generic_human::ch_pan_02_01_beach_approach_seal_1_cycle, true, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_seal_3", %generic_human::ch_pan_02_01_beach_approach_seal_3_cycle, true, false, false, true, "origin_animate_jnt" );
	
	add_scene( "zodiac_approach_seals2", "m_intro_zodiac_player", false, false, true );
	add_actor_anim( "ai_zodiac_seal_2", %generic_human::ch_pan_02_01_beach_approach_seal_2_cycle, true, false, true, true, "origin_animate_jnt" );
	
	add_scene( "zodiac_approach_seals_turn", "m_intro_zodiac_player" );
	add_actor_anim( "ai_zodiac_seal_1", %generic_human::ch_pan_02_01_beach_approach_seal_1_turn, true, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_seal_3", %generic_human::ch_pan_02_01_beach_approach_seal_3_turn, true, false, false, true, "origin_animate_jnt" );
	
	add_scene( "zodiac_approach_mason", "m_intro_zodiac_player" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_01_beach_approach_mason, true, true, false, false, "origin_animate_jnt" );
	
	add_scene( "zodiac_dismount_mason", "boat_landing_align_temp" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_01_beach_approach_mason_dismount );
		
	add_scene( "zodiac_approach_player", "m_intro_zodiac_player" );
	
	b_do_delete = true;
	n_player_number = 0;
	str_tag = "origin_animate_jnt";
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 80;
	n_left_arc = 60;
	n_top_arc = 15;
	n_bottom_arc = 15;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_01_beach_approach_player,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
	
	add_notetrack_custom_function( "player_body", "start_turn", ::anim_seals_on_zodiac );

	add_scene( "zodiac_dismount_player", "boat_landing_align_temp" );
	add_player_anim( "player_body", %player::p_pan_02_01_beach_approach_player_dismount, true );
	
	//BOAT 1
	add_scene( "zodiac_approach_seal_boat_1", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_1", %animated_props::o_pan_02_01_beach_approach_zodiac_1 );
	
	add_scene( "zodiac_approach_seal_group_1", "m_intro_zodiac_1", false, false, true );
	add_actor_anim( "ai_zodiac_boat_1_seal_1", %generic_human::ch_pan_02_01_zodiac_crew_idle_1, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_2", %generic_human::ch_pan_02_01_zodiac_crew_idle_2, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_3", %generic_human::ch_pan_02_01_zodiac_crew_idle_3, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_4", %generic_human::ch_pan_02_01_zodiac_crew_idle_4, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_5", %generic_human::ch_pan_02_01_zodiac_crew_idle_5, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_6", %generic_human::ch_pan_02_01_zodiac_crew_idle_6, true, true, true, true, "origin_animate_jnt" );
	
	//BOAT 2
	add_scene( "zodiac_approach_seal_boat_2", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_2", %animated_props::o_pan_02_01_beach_approach_zodiac_2 );
	
	add_scene( "zodiac_approach_seal_group_2", "m_intro_zodiac_2", false, false, true  );
	add_actor_anim( "ai_zodiac_boat_2_seal_1", %generic_human::ch_pan_02_01_zodiac_crew_idle_1, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_2", %generic_human::ch_pan_02_01_zodiac_crew_idle_2, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_3", %generic_human::ch_pan_02_01_zodiac_crew_idle_3, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_4", %generic_human::ch_pan_02_01_zodiac_crew_idle_4, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_5", %generic_human::ch_pan_02_01_zodiac_crew_idle_5, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_6", %generic_human::ch_pan_02_01_zodiac_crew_idle_6, true, true, true, true, "origin_animate_jnt" );
	
	//BOAT 3
	add_scene( "zodiac_approach_seal_boat_3", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_3", %animated_props::o_pan_02_01_beach_approach_zodiac_3 );
	
	add_scene( "zodiac_approach_seal_group_3", "m_intro_zodiac_3", false, false, true  );
	add_actor_anim( "ai_zodiac_boat_3_seal_1", %generic_human::ch_pan_02_01_zodiac_crew_idle_1, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_2", %generic_human::ch_pan_02_01_zodiac_crew_idle_2, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_3", %generic_human::ch_pan_02_01_zodiac_crew_idle_3, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_4", %generic_human::ch_pan_02_01_zodiac_crew_idle_4, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_5", %generic_human::ch_pan_02_01_zodiac_crew_idle_5, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_6", %generic_human::ch_pan_02_01_zodiac_crew_idle_6, true, true, true, true, "origin_animate_jnt" );

	//player contextual kill
	add_scene( "player_climbs_up", "first_blood_align" );
	
	b_do_delete = false;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 15;
	n_bottom_arc = 15;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_in,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );	
	//add_player_anim( "player_body", %player::p_pan_02_03_guards_player_in );
	
//	add_scene( "player_melee_loop", "first_blood_align", false, false, true );
//	
//	b_do_delete = false;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 15;
//	n_bottom_arc = 15;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_loop,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );	
	//add_player_anim( "player_body", %player::p_pan_02_03_guards_player_loop );
	
//	add_scene( "player_melee_grab_kill", "first_blood_align" );
//	
//	b_do_delete = false;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 15;
//	n_bottom_arc = 15;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_grab_gaurd,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );		
	//add_player_anim( "player_body", %player::p_pan_02_03_guards_player_grab_gaurd );
	
//	add_scene( "player_button_wait", "first_blood_align" );
//	
//	b_do_delete = false;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 15;
//	n_bottom_arc = 15;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_button_loop,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );	
	//add_player_anim( "player_body", %player::p_pan_02_03_guards_player_button_loop );	
	
	add_scene( "player_knife_kill", "first_blood_align" );
	
	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 15;
	n_bottom_arc = 15;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_kills,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );		
	//add_player_anim( "player_body", %player::p_pan_02_03_guards_player_kills, true );	
	add_prop_anim( "player_knife", %animated_props::o_pan_02_03_guards_player_kills_knife, "t6_wpn_knife_sog_prop_view", true );
	
	add_scene( "player_knife_no_kill", "first_blood_align" );

	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 15;
	n_bottom_arc = 15;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_no_kill,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );	
	//add_player_anim( "player_body", %player::p_pan_02_03_guards_player_no_kill, true );	

	add_scene( "player_melee_whistle", "first_blood_align" );

	b_do_delete = false;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 15;
	n_bottom_arc = 15;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_wistle,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );	
	
	//guard 1, the guy the player kills
//	add_scene( "guard_01_walkup", "first_blood_align" );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_gaurd_01_walkup );
	
//	add_scene( "guard_01_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_gaurd_01_loop );
	
//	add_scene( "guard_01_grab_kill", "first_blood_align" ); 
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_guard01_grabbed );
	
//	add_scene( "guard_01_button_wait", "first_blood_align" ); 
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_guard01_button_loop );
	
//	add_scene( "guard_01_kill", "first_blood_align" ); 
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_killed_guard01 );
	
//	add_scene( "guard_01_no_kill", "first_blood_align" ); 
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_guard01_no_kill );
	
	//guard 2
//	add_scene( "guard_02_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_gaurd_02_loop );
	
//	add_scene( "guard_02_kill", "first_blood_align" ); 
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_killed_guard02 );
	

	
//	add_scene( "guard_03_button_wait", "first_blood_align" );
//	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_button_loop );	
	

	
//	add_scene( "guard_03_no_kill", "first_blood_align" ); 
//	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_lives );
					
	
	
	
	
	
	
	
	//**** NEW KNFIE KILL ANIMS 
	
	//guard 3
	add_scene( "guard_03_in", "first_blood_align" );
	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_in );
	
//	add_scene( "guard_03_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_loop );
	
	add_scene( "guard_03_kill", "first_blood_align" ); 
	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_killed );	
	
	//flare guy
//	add_scene( "flare_guy_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "flare_guy", %generic_human::ch_pan_02_03_guards_flareguy_loop );	

	add_scene( "flare_guy_walkout", "first_blood_align" );
	add_actor_anim( "flare_guy", %generic_human::ch_pan_02_03_guards_flareguy_walkout, true );	
	add_prop_anim( "flare_gun", %animated_props::o_pan_02_03_guards_flaregun_walkout, "t6_wpn_flare_gun_prop" );
	//add_notetrack_custom_function( "flare_gun", "Kinfe_button_start", maps\panama_airfield::player_contextual_button_press );
	
	add_scene( "flare_guy_killed", "first_blood_align" );
	add_actor_anim( "flare_guy", %generic_human::ch_pan_02_03_guards_flareguy_killed, true );		
	add_prop_anim( "flare_gun", %animated_props::o_pan_02_03_guards_flaregun_killed, "t6_wpn_flare_gun_prop" );
	//add_notetrack_fx_on_tag( "flare_gun", "bang", "fx_cuba_flare_burst", "TAG_FX" );
	add_notetrack_custom_function( "flare_gun", "bang", maps\panama_airfield::flare_guy_killed_flare );
	
	add_scene( "flare_guy_lives", "first_blood_align" );
	add_actor_anim( "flare_guy", %generic_human::ch_pan_02_03_guards_flareguy_notkilled, true, true );		
	add_prop_anim( "flare_gun", %animated_props::o_pan_02_03_guards_flaregun_not_killed, "t6_wpn_flare_gun_prop" );
	//add_notetrack_fx_on_tag( "flare_gun", "bang", "fx_cuba_flare_burst", "TAG_FX" );
	add_notetrack_custom_function( "flare_gun", "bang", maps\panama_airfield::flare_guy_lives_flare );

	//mason
	add_scene( "mason_drain_approach", "first_blood_align", true ); 
	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_approach_sewer );

	add_scene( "mason_drain_walks2back", "first_blood_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_approach_sewer_walks2back );
	
	add_scene( "mason_drain_loop", "first_blood_align", false, false, true ); 
	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_approach_sewer_loop );		
	
//	add_scene( "mason_drain_exit", "first_blood_align", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_approach_sewer_exit );	
	
//	add_scene( "mason_melee_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_loop );	

	add_scene( "mason_melee_kill", "first_blood_align" ); 
	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_kills );
	add_prop_anim( "mason_knife", %animated_props::o_pan_02_03_guards_mason_kills_knife, "t6_wpn_knife_sog_prop_view", true );

	//**** NEW KNFIE KILL ANIMS 

	
//	add_scene( "first_blood_guards_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_arguing_guard01, false, true, false, false );
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_arguing_guard02, false, true, false, false );
//	
//	add_scene( "first_blood_guard_1_reaction", "first_blood_align" );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_reaction_guard01, false, true, false, false );
//	
//	add_scene( "first_blood_guard_2_reaction", "first_blood_align" );
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_reaction_guard02, false, true, false, false );
//
//	add_scene( "mason_cliff_mantle", "first_blood_align", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_mantle_cliff_mason );
//
//	add_scene( "mason_cliff_approach", "first_blood_align", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_in );
//	
//	add_scene( "mason_cliff_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_loop );
//
//	add_scene( "player_cliff_kill", "first_blood_align" );
//	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_kills, true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_kills );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_killed_guard01 );
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_killed_guard02 );
//
//	add_scene( "mason_cliff_crawl", "first_blood_align", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_crawls );
//
//	add_scene( "mason_cliff_reaction", "first_blood_align" );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_reacts );
	
	add_scene( "car_slide", "car_slide_align" );
	add_actor_anim( "car_slide", %generic_human::ai_slide_across_car );
	
	add_scene( "dive_over", "dive_over_align" );
	add_actor_anim( "window_table_flip", %generic_human::ai_dive_over_40 );
	
	add_scene( "window_mantle", "window_mantle_align" );
	add_actor_anim( "window_mantle", %generic_human::ai_mantle_window_36_run );
	
	add_scene( "window_dive", "window_dive_align" );
	add_actor_anim( "window_dive", %generic_human::ai_mantle_window_dive_36 );
	
	add_scene( "table_flip_open_ai", "table_flip_open_align", true );
	add_actor_anim( "window_table_flip", %generic_human::ch_la_06_02_plaza_table_flip_guy_02 );
	
	add_scene( "table_flip_open_table", "table_flip_open_align" );
	add_prop_anim( "window_table", %animated_props::o_la_06_02_plaza_table_flip_table_02, "p6_plaza_table", false, true );
	
	add_scene( "table_flip_hall_ai", "table_flip_hall_align", true );
	add_actor_anim( "window_table_flip", %generic_human::ch_la_06_02_plaza_table_flip_guy_02 );
	
	add_scene( "table_flip_hall_table", "table_flip_hall_align" );
	add_prop_anim( "table_flip_table", %animated_props::o_la_06_02_plaza_table_flip_table_02, "p6_plaza_table", false, true );
	
	add_scene( "seal_encounter_mason", "mason_hangar", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_07_seal_encounter_mason );
	add_notetrack_custom_function( "mason", "flash_light", ::flashlight_mason );
	add_notetrack_custom_function( "mason", "lock_break", ::lockbreak_mason );
	
	add_scene( "seal_encounter_seals", "mason_hangar" );
	add_actor_anim( "seal_encounter_1", %generic_human::ch_pan_02_07_seal_encounter_seal_01, false, false, true );
	add_actor_anim( "seal_encounter_2", %generic_human::ch_pan_02_07_seal_encounter_seal_02, false, false, true );
	add_notetrack_custom_function( "seal_encounter_1", "flash_light", ::flashlight_seal );
	
	add_scene( "seal_encounter_gate", "mason_hangar" );
	add_prop_anim( "hanger_gate", %animated_props::o_pan_02_07_seal_encounter_door );
	
//	add_scene( "mason_standoff_fence_kick", "hangar_hatch", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_07_fence_kick_mason );
//	add_notetrack_custom_function( "mason", "door_kick", maps\panama_airfield::open_ladder_door );
	
//	add_scene( "mason_standoff_arrival", "hangar_hatch", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_07_hangar_ladder_enter_mason );
	
//	add_scene( "mason_standoff_loop", "hangar_hatch", false, false, true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_07_hangar_ladder_loop_mason );

//	add_scene( "mason_standoff_exit", "hangar_hatch" );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_07_hangar_ladder_exit_mason );

//	add_scene( "pdf_ladder_loop", "hangar_hatch", false, false, true );
//	add_actor_anim( "ladder_pdf", %generic_human::ch_pan_02_07_hangar_ladder_soldier_loop );
//	add_notetrack_custom_function( "ladder_pdf", "muzzle_flash", maps\panama_airfield::extra_muzzle_flash );

//	add_scene( "pdf_ladder_reaction", "hangar_hatch" );
//	add_actor_anim( "ladder_pdf", %generic_human::ch_pan_02_07_hangar_ladder_soldier_reaction );

	//ladder hatch
//	add_scene( "ladder_hatch", "hangar_hatch" );
//	add_prop_anim( "ladder_hatch", %animated_props::o_pan_02_07_hangar_ladder_door_hatch, "p6_anim_hangar_hatch" );
	
	//Player opening hatch
//	add_scene( "player_opens_hatch", "hangar_hatch" );
//
//	b_do_delete = true;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 30;
//	n_bottom_arc = 30;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_02_07_hangar_ladder_door_open_player,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );


//	add_scene( "player_exits_hatch", "hangar_hatch" );
//	
//	b_do_delete = true;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 30;
//	n_bottom_arc = 30;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_02_07_hangar_ladder_door_exit_player,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
	
	//slide anim
	add_scene( "rooftop_slide_1", "hangar_roof", true );
	add_actor_anim( "slide_guy_1", %generic_human::ch_pan_02_08_rooftop_slide_guy01 );
	
	add_scene( "rooftop_slide_2", "hangar_roof", true );
	add_actor_anim( "slide_guy_2", %generic_human::ch_pan_02_08_rooftop_slide_guy02 );
	
	//seal_standoff = align_node
	add_scene( "seal_standoff_loop", undefined, false, false, true, true );
	add_actor_anim( "seal_1", %generic_human::ch_pan_02_07_golf_team_guy_01  );
	add_actor_anim( "seal_2", %generic_human::ch_pan_02_07_golf_team_guy_02 );
	add_actor_anim( "seal_3", %generic_human::ch_pan_02_07_golf_team_guy_03 );
	add_actor_anim( "seal_4", %generic_human::ch_pan_02_07_golf_team_guy_04 );
	add_actor_anim( "seal_5", %generic_human::ch_pan_02_07_golf_team_guy_05 );
	add_actor_anim( "seal_6", %generic_human::ch_pan_02_07_golf_team_guy_06 );
//	add_actor_anim( "seal_7", %generic_human::ch_pan_02_07_standoff_seal_07 );
//	add_actor_anim( "seal_8", %generic_human::ch_pan_02_07_standoff_seal_08 );
	
//	add_scene( "seal_rescue_1", "seal_standoff" );
//	add_actor_anim( "seal_rescue_guy_1", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_1, false, true, false, true );
//	add_actor_anim( "seal_8", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_8, false, true, false, true );
//	
//	add_scene( "seal_rescue_1_dies", "seal_standoff" );
//	add_actor_anim( "seal_rescue_guy_1", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_1_dies, false, true, false, true );
//	add_actor_anim( "seal_8", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_8_dies, false, true, false, true );
//	
//	add_scene( "seal_rescue_2", "seal_standoff" );
//	add_actor_anim( "seal_rescue_guy_2", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_2, false, true, false, true );
//	add_actor_anim( "seal_3", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_3, false, true, false, true );
//	
//	add_scene( "seal_rescue_2_dies", "seal_standoff" );
//	add_actor_anim( "seal_rescue_guy_2", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_2_dies, false, true, false, true );
//	add_actor_anim( "seal_3", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_3_dies, false, true, false, true );
//	
//	add_scene( "seal_rescue_3", "seal_standoff" );
//	add_actor_anim( "seal_rescue_guy_3", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_4, false, true, false, true );
//	add_actor_anim( "seal_5", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_5, false, true, false, true );

	add_scene( "mason_skylight_approach", "hangar_roof", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_08_skylight_approach_mason );

	add_scene( "mason_skylight_loop", "hangar_roof", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_08_skylight_loop_mason );
	
	add_scene( "mason_skylight_jump_in", "hangar_roof" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_08_skylight_entry_mason );
	add_prop_anim( "skylight_door", %animated_props::o_pan_02_08_skylight_entry_door );
	
	add_scene( "mason_hangar_door_kick", "hangar_doorkick_align", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_09_door_kick_mason );
	
	add_scene( "hangar_door", "hangar_doorkick_align" );	
	add_prop_anim( "hangar_door_mason", %animated_props::ch_pan_02_09_door_kick_door, undefined, false, true );
	
//	add_scene( "player_intruder", "control_room" );
//	add_player_anim( "player_body", %player::int_specialty_panama_intruder, true );
//	add_prop_anim( "boltcutter_intruder", %animated_props::o_specialty_panama_intruder_boltcutter, "t6_wpn_boltcutters_prop_view", true );
//	add_prop_anim( "lock_intruder", %animated_props::o_specialty_panama_intruder_lock, "test_p_anim_specialty_lockbreaker_padlock", true );
	
	add_scene( "lock_breaker", "control_room_door" );
	add_prop_anim( "lock_pick", %animated_props::o_specialty_panama_lockbreaker_device, "t6_wpn_lock_pick_view", true );
	add_player_anim( "player_body", %player::int_specialty_panama_lockbreaker, true );
	add_notetrack_custom_function( "player_body", "door_open", maps\panama_airfield::hangar_intruder_door_open );
	
	add_scene( "lock_breaker_door", "control_room_door" );
	add_prop_anim( "control_room_door", %animated_props::o_specialty_panama_lockbreaker_door_open );
	
	add_scene( "pull_the_lever", "hangar_lever" );
	add_prop_anim( "hangar_lever", %animated_props::o_panama_pull_power_lever, undefined, false, true );
	add_player_anim( "player_body", %player::int_panama_pull_power_lever, true );
	
	add_scene( "intruder", "intruder_box" );
	add_prop_anim( "boltcutter", %animated_props::o_specialty_panama_intruder_boltcutter, "t6_wpn_boltcutters_prop_view", true );
	add_prop_anim( "nightingale", %animated_props::o_specialty_panama_intruder_grabbed_nightingale, "t5_weapon_nightingale_world", true );
	add_prop_anim( "nightingale_2", %animated_props::o_specialty_panama_intruder_grabbed_nightingale_2 , "t5_weapon_nightingale_world", true );
	add_prop_anim( "intruder_box", %animated_props::o_specialty_panama_intruder_strongbox );
	add_player_anim( "player_body", %player::int_specialty_panama_intruder, true );
	
//	add_scene( "pdf_door_reaction_0", undefined, false, false, false, true );s
//	add_actor_anim( "pdf_0", %generic_human::ch_pan_02_09_hangar_door_reactions_1 );
	
//	add_scene( "pdf_door_reaction_1", undefined, false, false, false, true );
//	add_actor_anim( "pdf_1", %generic_human::ch_pan_02_09_hangar_door_reactions_2 );
	
//	add_scene( "pdf_door_reaction_2", undefined, false, false, false, true );
//	add_actor_anim( "pdf_2", %generic_human::ch_pan_02_09_hangar_door_reactions_3 );

	add_scene( "seal_group_1_hangar_entry", "seal_standoff" );
	add_actor_anim( "seal_guy_1", %generic_human::ch_pan_02_11_seal_hangar_entry_seal01, false, true, false, true );
	add_actor_anim( "seal_guy_2", %generic_human::ch_pan_02_11_seal_hangar_entry_seal02, false, true, false, true );

	add_scene( "seal_group_2_hangar_entry", "seal_standoff" );
	add_actor_anim( "seal_guy_3", %generic_human::ch_pan_02_11_seal_hangar_entry_seal03, false, true, false, true );
	add_actor_anim( "seal_guy_4", %generic_human::ch_pan_02_11_seal_hangar_entry_seal04, false, true, false, true );

	//Unloading boxes off of Gaz66
//	add_scene( "unloading_gaz66_truck_loop", undefined, false, false, true, true );
//	add_vehicle_anim( "unloading_gaz", %vehicles::v_pan_02_04_unloading_gaz66_loop, false, undefined, "tag_origin" );

//	add_scene( "truck_guy_1_loop", "unloading_gaz", false, false, true, true );
//	add_actor_anim( "truck_pdf_1", %generic_human::ch_pan_02_04_unloading_guy1_loop, true, true, false, false, "tag_origin_animate_jnt" );
//	
//	add_scene( "truck_guy_2_loop", "unloading_gaz", false, false, true, true );
//	add_actor_anim( "truck_pdf_2", %generic_human::ch_pan_02_04_unloading_guy2_loop, true, true, false, false, "tag_origin_animate_jnt" );
	
	//reaction
//	add_scene( "truck_pdf_1_reaction", "unloading_gaz", false, false, false, true );
//	add_actor_anim( "truck_pdf_1", %generic_human::ch_pan_02_04_unloading_guy1_reaction, false, true );
//
//	add_scene( "truck_pdf_2_reaction", "unloading_gaz", false, false, false, true );
//	add_actor_anim( "truck_pdf_2", %generic_human::ch_pan_02_04_unloading_guy2_reaction, false, true );

//	add_scene( "unloading_box_loop", "unloading_gaz", false, false, true );
//	add_prop_anim( "the_box", %animated_props::o_pan_02_04_unloading_box_loop, "anim_jun_ammo_box", true, false, undefined, "tag_origin_animate_jnt" );
	
//	add_scene( "unloading_loop", "unloading_align", false, false, true );
//	add_actor_anim( "truck_pdf_1", %generic_human::ch_pan_02_04_unloading_guy1_loop );
//	add_actor_anim( "truck_pdf_2", %generic_human::ch_pan_02_04_unloading_guy2_loop );
//	add_prop_anim( "the_box", %animated_props::o_pan_02_04_unloading_box_loop, "anim_jun_ammo_box", true );
	
	//Leerjet battle (seal vs pdf)
	add_scene( "learjet_battle_pdf", "learjet_battle" );
	add_actor_anim( "lj_battle_pdf", %generic_human::ch_pan_02_12_leerjet_battle_pdf );
	
	add_scene( "learjet_battle_seal", "learjet_battle" );
	add_actor_anim( "lj_battle_seal", %generic_human::ch_pan_02_12_leerjet_battle_seal, false, false, true );
	
	add_scene( "seal_rocket", "learjet_battle" );
	add_actor_anim( "lj_seal_rocket", %generic_human::ch_pan_02_12_leerjet_battle_seal_rocket, false, false, true, true );

//	add_scene( "shoulder_bash", "motel_path_bash", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_10_shoulder_bash_mason );
//	add_notetrack_custom_function( "mason", "door_hit", maps\panama_airfield::open_bash_door );

	add_scene( "mason_shoulder_bash", "motel_path_bash", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_12_door_bash_mason );
	
	add_scene( "mason_shoulder_bash_door", "motel_path_bash" );
	add_prop_anim( "bash_door", %animated_props::o_pan_02_12_door_bash_door, undefined, false, true );
//	add_notetrack_custom_function( "mason", "door_hit", maps\panama_airfield::open_bash_door );
	
	add_scene( "pdf_shoulder_bash", "motel_path_bash" );
	add_actor_anim( "pdf_shoulder_bash", %generic_human::ch_pan_02_12_door_close_pdf, false, false, true, true );
	add_prop_anim( "bash_door", %animated_props::o_pan_02_12_door_close_door, "p_rus_door_white_60", false, true );
	
	add_scene( "player_door_kick", "player_door_kick_align" );
	add_player_anim( "player_body", %player::int_player_kick, true );
	
	add_scene( "player_door_kick_door", "motel_path_bash" );
	add_prop_anim( "bash_door", %animated_props::o_panama_player_kick_door, undefined, false, true );
	
//	add_scene( "bash_door_mason", "motel_path_bash" );
//	add_prop_anim( "bash_door_mason", %animated_props::o_pan_02_12_door_bash_door, "p_rus_door_white_60", false, true );
		
//	add_scene( "bash_door_pdf", "motel_path_bash" );
//	add_prop_anim( "bash_door_pdf", %animated_props::o_pan_02_12_door_close_door, "p_rus_door_white_60", false, true );
	
	add_scene( "learjet_explosion", "vh_lear_jet" );
	add_vehicle_anim( "vh_lear_jet", %vehicles::fxanim_panama_private_jet_anim );
	
	add_scene( "pool_guy_1", "pool_death" );
	add_actor_anim( "pool_guy_1", %generic_human::ch_pan_02_12_pool_death_guy_1, false, false, false, true );
	add_notetrack_custom_function( "pool_guy_1", "fire", maps\panama_airfield::shoot_pool_guy_1 );
	
	add_scene( "pool_guy_2", "pool_death", true );
	add_actor_anim( "pool_guy_2", %generic_human::ch_pan_02_12_pool_death_guy_2 );
	add_notetrack_custom_function( "pool_guy_2", "fire", maps\panama_airfield::shoot_pool_guy_2 );

	add_scene( "rolling_door_guy", "rollup_door" );
	add_actor_anim( "rolling_door_guy", %generic_human::ch_pan_02_12_rolling_door_guy_1 );	
	
	add_scene( "rolling_door_guy_2", "rollup_door" );
	add_actor_anim( "rolling_door_guy_2", %generic_human::ch_pan_02_12_rolling_door_guy_2 );

	add_scene( "learjet_back_door_kick", "learjet_back_door_kick_align" );
	add_actor_anim( "learjet_back_door_kick_pdf", %generic_human::ch_pan_02_09_door_kick_mason );
	add_notetrack_custom_function( "learjet_back_door_kick_pdf", "door_hit", maps\panama_airfield::learjet_back_door_open );
	
	add_scene( "seal_breach_1", "door_breach_align_1", true );
	add_actor_anim( "door_breach_a_1", %generic_human::ch_pan_02_11_seals_breaching_guy01 );
	add_actor_anim( "door_breach_a_2", %generic_human::ch_pan_02_11_seals_breaching_guy02 );
	add_notetrack_custom_function( "door_breach_a_1", "door_open", maps\panama_airfield::seal_breach_door_open );
}


flashlight_mason( mason )
{
	level.mason play_fx( "mason_flashlight", level.mason.origin, undefined, 0.1, true, "tag_weapon_left" );
	wait 0.3;
	level.mason play_fx( "mason_flashlight", level.mason.origin, undefined, 0.1, true, "tag_weapon_left" );
}


flashlight_seal( seal )
{
	seal play_fx( "mason_flashlight", seal.origin, undefined, 0.1, true, "tag_weapon_left" );
	wait 0.3;
	seal play_fx( "mason_flashlight", seal.origin, undefined, 0.1, true, "tag_weapon_left" );
	wait 0.3;
	seal play_fx( "mason_flashlight", seal.origin, undefined, 0.1, true, "tag_weapon_left" );
}


lockbreak_mason( mason )
{
	exploder( 251 );
}


#using_animtree( "generic_human" );
patroller_anims()
{
	level.scr_anim[ "generic" ][ "bored_idle" ][ 0 ]			 	 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_walk" ]					 = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]			 	 = %patrol_bored_idle_smoke;
	
	level.scr_anim[ "generic" ][ "exchange_surprise_0" ]			 = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "exchange_surprise_1" ]			 = %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "exchange_surprise_2" ]			 = %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "exchange_surprise_3" ]			 = %exposed_idle_twitch_v4;
	level.surprise_anims = 4;
}

motel_anims()
{
	add_scene( "motel_approach", "motel_room", true );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_noriegas_room_approach_mason );
	
	add_scene( "motel_approach_loop", "motel_room", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_noriegas_room_approach_mason_loop );
	
	add_scene( "motel_door", "motel_room" );
	add_prop_anim( "hotel_door", %animated_props::o_pan_03_01_noriegas_room_breach_door, undefined, false, true );
	
	add_scene( "motel_chair", "motel_room" );
	add_prop_anim( "chair", %animated_props::o_pan_03_01_noriegas_room_chair, "p6_chair_wood_hotel", false, true );
	
	add_scene( "motel_breach", "motel_room" );
	add_actor_anim( "thug_1", %generic_human::ch_pan_03_01_noriegas_room_breach_guy01, true, false, false, true );
	add_actor_anim( "thug_2", %generic_human::ch_pan_03_01_noriegas_room_breach_guy02, true, false, false, true );
	add_actor_anim( "thug_3", %generic_human::ch_pan_03_01_noriegas_room_breach_guy03, true, false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_noriegas_room_breach_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_noriegas_room_breach_noriega, true );
	add_prop_anim( "flash_bang", %animated_props::o_pan_03_01_noriegas_room_breach_flashbang, "t6_wpn_grenade_flash_prop_view" );
	add_player_anim( "player_body", %player::ch_pan_03_01_noriegas_room_breach_player, false, 0, undefined, true, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "player_body", "sndChangeMusicState", maps\panama_amb::sndChangeMotelMusicState );
	add_notetrack_custom_function( "thug_3", "tv_smash", maps\panama_motel::motel_tv_swap );
	add_notetrack_exploder( "thug_3", "tv_smash", 302 );
	
	add_scene( "motel_scene", "motel_room" );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_noriegas_room_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_noriegas_room_noriega, true );
	add_prop_anim( "duffle_bag", %animated_props::o_pan_03_01_noriegas_room_bag, "p6_anim_duffle_bag" );
	add_prop_anim( "cocaine_1", %animated_props::o_pan_03_01_noriegas_room_cocaine01, "p6_anim_cocaine" );
	add_prop_anim( "cocaine_2", %animated_props::o_pan_03_01_noriegas_room_cocaine02, "p6_anim_cocaine" );
	add_prop_anim( "pajamas", %animated_props::o_pan_03_01_noriegas_room_pajamas , "p6_anim_cloth_pajamas" );
	add_player_anim( "player_body", %player::ch_pan_03_01_noriegas_room_player, true, 0, undefined, true, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "mason", "condition_mason", maps\panama_motel::motel_vo_nicaragua );
	add_notetrack_custom_function( "player_body", "gun_raise", maps\panama_motel::gun_raise );
	add_notetrack_custom_function( "player_body", "gun_lower", maps\panama_motel::gun_lower );
	add_notetrack_custom_function( "player_body", "condition_woods", maps\panama_motel::motel_vo_afghanistan );
	add_notetrack_custom_function( "player_body", "fade_out_condition_all_intel", maps\panama_motel::next_mission );
}


underwater_snapshot_on(bro)
{
	clientnotify ("underwater_on");
}

underwater_snapshot_off(bro)
{
	clientnotify ("underwater_off");
}




//motel_anims_old()
//{
//	//Player Breach
//	add_scene( "player_breach_intro_loop", "motel_room", false, false, true );
//	
//	b_do_delete = true;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 15;
//	n_bottom_arc = 15;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_03_01_old_friends_player_intro_loop,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );		
//	//add_player_anim( "player_body", %player::p_pan_03_01_old_friends_player_intro_loop );
//	
//	add_scene( "player_breach_intro", "motel_room" );
//
//	b_do_delete = true;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_left_arc = 30;
//	n_right_arc = 30;
//	n_top_arc = 15;
//	n_bottom_arc = 15;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_03_01_old_friends_player_intro,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );		
//	//add_player_anim( "player_body", %player::p_pan_03_01_old_friends_player_intro, true );
//	//add_notetrack_sound( "player_body", "Pull_pin", );
//	//add_notetrack_sound( "player_body", "Flashbang", );
//	add_notetrack_custom_function( "player_body", "raise_gun", maps\panama_motel::set_breach_gun_raised );		
//	add_notetrack_custom_function( "player_body", "drop_gun", maps\panama_motel::clear_breach_gun_raised );	
//	
//	add_notetrack_custom_function( "player_body", "Bang_bathroom", maps\panama_motel::head_shot_bathroom_guy );	
//	add_notetrack_custom_function( "player_body", "Door_breach_hit", maps\panama_motel::open_motel_door );
//	add_notetrack_custom_function( "player_body", "Tv_smash", maps\panama_motel::motel_tv_swap );
//	add_notetrack_exploder( "player_body", "Tv_smash", 302 );
//	add_actor_anim( "mason", %generic_human::ch_pan_03_01_old_friends_mason_intro );
//	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_old_friends_noriega_intro );
//
//	add_scene( "player_breach_xcool", "motel_room" );
//
//	b_do_delete = true;
//	n_player_number = 0;
//	str_tag = undefined;
//	b_do_delta = true;
//	n_view_fraction = 0;
//	n_right_arc = 30;
//	n_left_arc = 30;
//	n_top_arc = 15;
//	n_bottom_arc = 15;
//	b_use_tag_angles = true;
//	
//	add_player_anim( "player_body", %player::p_pan_03_01_xcool_player,
//	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
//	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );	
//	//add_player_anim( "player_body", %player::p_pan_03_01_xcool_player, true );
//	
//	add_notetrack_stop_exploder( "player_body", "fade_out", 302 );	
//	add_notetrack_custom_function( "player_body", "fade_out", maps\panama_motel::notetrack_motel_nextmission );	
//	
//	add_scene( "guys_breach_xcool", "motel_room" );	
//	add_actor_anim( "mason", %generic_human::ch_pan_03_01_xcool_mason, false, false, true );
//	add_prop_anim( "bag", %animated_props::o_pan_03_01_xcool_bag, "p6_anim_duffle_bag", true );
//	add_prop_anim( "pajamas", %animated_props::o_pan_03_01_xcool_pajamas, "p6_anim_duffle_bag", true );
//	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_xcool_noriega, false, false, true );
//	add_actor_anim( "pizza_guy", %generic_human::ch_pan_03_01_xcool_pizza_guy, false, false, true );
//	
//	//MASON BREACH
//	add_scene( "mason_door_approach", "motel_room", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_03_01_old_friends_mason_approach );
//
//	add_scene( "mason_door_loop", "motel_room", false, false, true );
//	add_actor_anim( "mason", %generic_human::ch_pan_03_01_old_friends_mason_door_loop );
//	
//	//THUG 1
//	add_scene( "thug_1_intro", "motel_room" );
//	add_actor_anim( "thug_1", %generic_human::ch_pan_03_01_old_friends_guy_1_intro );
//
//	add_scene( "thug_1_death_loop", "motel_room", false, false, true );
//	add_actor_anim( "thug_1", %generic_human::ch_pan_03_01_old_friends_guy_1_custom_death );
//
//	//THUG 2
//	add_scene( "thug_2_intro", "motel_room" );
//	add_actor_anim( "thug_2", %generic_human::ch_pan_03_01_old_friends_guy_2_intro );
//
//	add_scene( "thug_2_shot", "motel_room" );
//	add_actor_anim( "thug_2", %generic_human::ch_pan_03_01_old_friends_guy_2_shot );
//
//	add_scene( "thug_2_death_loop", "motel_room", false, false, true );
//	add_actor_anim( "thug_2", %generic_human::ch_pan_03_01_old_friends_guy_2_dead_loop, true, false, false, true );
//
//	//THUG 3
//	add_scene( "thug_3_intro", "motel_room" );
//	add_actor_anim( "thug_3", %generic_human::ch_pan_03_01_old_friends_guy_3_intro );
//
//	add_scene( "thug_3_death_loop", "motel_room", false, false, true );
//	add_actor_anim( "thug_3", %generic_human::ch_pan_03_01_old_friends_guy_3_death_loop );
//
//	//THUG 4 ( surprise enemy )
//	add_scene( "thug_4_intro", "motel_room" );
//	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_old_friends_supprise_enemy_intro );
//
//	add_scene( "thug_4_shot", "motel_room" );
//	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_old_friends_supprise_enemy_shot );
//
//	add_scene( "thug_4_death_loop", "motel_room", false, false, true );
//	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_old_friends_supprise_enemy_shot_loop );
//
//	add_scene( "noriega_intro_loop", "motel_room", false, false, true );
//	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_old_friends_noriega_intro_loop );
//}