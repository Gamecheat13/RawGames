//=============================================================================================================================
//============================================ CHOPPER BOWL FIREFIGHT SCRIPT ========================================================
//=============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
script startup horseshoe
//THIS STARTS ALL OF FIREFIGHT SCRIPTS
	wake (firefight_lost_game);
	wake (firefight_won_game);
	firefight_player_goals();
	print ("goals ended");
	print ("game won");
	//mp_round_end();
  b_game_won = true;
end


//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																				Test																							//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
script continuous test_horseshoe_variant
	sleep_until (LevelEventStatus ("test_horseshoe_variant"), 1);
	ai_ff_all = gr_ff_all;
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);
	switch_zone_set (test);
	print ("Hello world!");
	f_add_crate_folder (test_horseshoe_allcrates);
	f_add_crate_folder(spawn_points_0);
	firefight_mode_set_crate_folder_at(spawn_points_0, 90);
	firefight_mode_set_objective_name_at(lz_0, 50);
	firefight_mode_set_objective_name_at(test_powercore_destroy, 51);
	firefight_mode_set_objective_name_at(test_powercore_defend, 52);
	firefight_mode_set_objective_name_at(test_obj_touchscreen, 53);
	firefight_mode_set_squad_at(gr_ff_template_01, 1);
	firefight_mode_set_squad_at(gr_ff_template_02, 2);
	firefight_mode_set_squad_at(gr_ff_template_03, 3);
	firefight_mode_set_squad_at(gr_ff_template_04, 4);
	firefight_mode_set_squad_at(gr_ff_template_05, 5);
	firefight_mode_set_squad_at(gr_ff_droppods, 6);
	sleep_forever();
end

//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																			Root Scenario Scripts																//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//

script static void setup_destroy
	//set any variables and start the main objective script from the global firefight script
	wake (objective_destroy);
end

script static void setup_defend
	//set any variables and start the main objective script from the global firefight script
	wake (objective_defend);
end

script static void setup_swarm
	//set any variables and start the main objective script from the global firefight script
	wake (objective_swarm);
end

script static void setup_wait_for_trigger
	wake (objective_wait_for_trigger);
end

script static void setup_capture
	//set any variables and start the main objective script from the global firefight script
	wake (objective_capture);
end

script static void setup_take
	//set any variables and start the main objective script from the global firefight script
	wake (objective_take);
end

script static void setup_atob
	wake (objective_atob);
end

script static void setup_boss
	wake (objective_kill_boss);
end