//// =============================================================================================================================
// ============================================ MEZZANINE SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
// ================================================== LEVEL SCRIPT ==================================================================
// =============================================================================================================================

script startup mezzanine

	print( "mezzanine startup" );
	
	// setup defaults
	f_spops_mission_startup_defaults();
	
	// track mission flow
	f_spops_mission_flow();
	
end


//============ MAIN SCRIPT STARTS ==================================================================
//	ai_allegiance (human, player);
//	ai_allegiance (player, human);
//	ai_lod_full_detail_actors (20);
//
//	//THIS STARTS ALL OF FIREFIGHT SCRIPTS
//	wake (start_waves);
//end
//
//script dormant start_waves
//	wake (firefight_lost_game);
//	wake (firefight_won_game);
//	firefight_player_goals();
//	print ("goals ended");
//	print ("game won");
//	//mp_round_end();
//	b_game_won = true;
//
//end
