#using_animtree( "generic_human" );
main()
{
	anims();
	radio();
	fx();
}

anims()
{
	// Walkcycles
	level.scr_anim[ "generic" ][ "civ_escort_walk" ] 							= %prague_resistance_walk_01;
	level.scr_anim[ "generic" ][ "civ_escort_idle" ][0]							= %prague_intro_dock_resistance_standidle_01;
	
	level.scr_anim[ "generic" ][ "civ_captured" ][0] 							= %prague_resistance_walk_01;
	level.scr_anim[ "generic" ][ "civ_captured" ][1] 							= %prague_resistance_walk_02;
	level.scr_anim[ "generic" ][ "apt_jog" ]									= %huntedrun_1_look_right;
	level.scr_anim[ "generic" ][ "church_jog" ]									= %huntedrun_1_look_left;
	level.scr_anim[ "generic" ][ "cqb_walk" ] 									= %walk_CQB_f;
	level.scr_anim[ "generic" ][ "bully_walk" ] 								= %prague_bully_a_run;
	level.scr_anim[ "generic" ][ "civ_walk" ] 									= %prague_bully_civ_run;	
	level.scr_anim[ "generic" ][ "active_patrolwalk_v5" ] 						= %active_patrolwalk_v5;
	level.scr_anim[ "generic" ][ "active_patrolwalk_v4" ]						= %active_patrolwalk_v4;
	level.scr_anim[ "generic" ][ "active_patrolwalk_v2" ]						= %active_patrolwalk_v2;
	level.scr_anim[ "generic" ][ "active_patrolwalk_v1" ] 						= %active_patrolwalk_v1;
	level.scr_anim[ "generic" ][ "active_patrolwalk_gundown" ]					= %active_patrolwalk_gundown;
	level.scr_anim[ "generic" ][ "casual_killer_walk_F" ]						= %casual_killer_walk_F;
	level.scr_anim[ "generic" ][ "patrol_bored_patrolwalk" ]					= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "crouch_sprint" ]								= %crouch_sprint;
	
	level.scr_anim[ "generic" ][ "patrol_walk_and_twitch" ][0]					= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_and_twitch" ][1]					= %patrol_bored_patrolwalk_twitch;

	level.scr_anim[ "generic" ][ "civilian_run_hunched_C" ] 					= %civilian_run_hunched_C;
	level.scr_anim[ "generic" ][ "civilian_run_hunched_A" ] 					= %civilian_run_hunched_A;
	level.scr_anim[ "generic" ][ "civilian_run_upright" ] 						= %civilian_run_upright;
	
	// Patrol pause and turn
	level.scr_anim[ "generic" ][ "active_patrolwalk_pause" ] 					= %active_patrolwalk_pause;
	level.scr_anim[ "generic" ][ "active_patrolwalk_turn" ] 					= %active_patrolwalk_turn_180;
	
	// Execute
	level.scr_anim[ "generic" ][ "prague_interrogate_2_soldier_kill" ] 			= %prague_interrogate_2_soldier_kill;
	level.scr_anim[ "generic" ][ "prague_interrogate_2_soldier_drag" ] 			= %prague_interrogate_2_soldier_drag;
	level.scr_anim[ "generic" ][ "prague_interrogate_2_civ_kill" ] 				= %prague_interrogate_2_civ_kill;
	level.scr_anim[ "generic" ][ "prague_interrogate_2_civ_idle" ][ 0 ]			= %prague_interrogate_2_civ_idle;
	level.scr_anim[ "generic" ][ "prague_interrogate_2_civ_drag" ] 				= %prague_interrogate_2_civ_drag;
	
	// Rebel Hop Fence
	level.scr_anim[ "generic" ][ "rebel_hop_fence" ]							= %prague_dumpster_climb_so;
}

radio()
{
	// ACTUAL RADIO LINES BEING USED
	
	// Soap: Intro
	level.scr_radio[ "soap_intro" ] 					= "so_ste_prague_mct_gatherrebels";
	
	// Soap: Outro Fail Friendly Fire
	level.scr_radio[ "soap_warn_friendly_fire" ]		= "so_ste_prague_mct_watchfire";
	
	//Sandman: We've been spotted! Take 'em out!
	level.scr_radio[ "prague_spotted_3" ]				= "prague_snd_spottedtakeout";
	
	//Soap: Recovery lines after being spotted
	level.scr_radio[ "prague_recover_1" ]				= "so_ste_prague_mct_sloppy";
	level.scr_radio[ "prague_recover_2" ]				= "so_ste_prague_mct_notagain";
	level.scr_radio[ "prague_recover_3" ]				= "so_ste_prague_mct_bloodyawful";
	level.scr_radio[ "prague_recover_4" ]				= "so_ste_prague_mct_bloodyawful";
	
	// Soap: near the end
	level.scr_radio[ "so_ste_prague_mct_doubletime" ] 	= "so_ste_prague_mct_doubletime";
	
	// Soap: Mission End Comments
	level.scr_radio[ "so_ste_prague_mct_goodjob" ]		= "so_ste_prague_mct_goodjob";
	level.scr_radio[ "so_ste_prague_mct_somebehind" ]	= "so_ste_prague_mct_somebehind";
	
	// Rebels: Agree to go with Soap
	level.scr_radio[ "so_ste_prague_reb1_illgo" ] 		= "so_ste_prague_reb1_illgo";
	level.scr_radio[ "so_ste_prague_reb1_withyou" ] 	= "so_ste_prague_reb1_withyou";
	level.scr_radio[ "so_ste_prague_reb2_followyou" ] 	= "so_ste_prague_reb2_followyou";
	level.scr_radio[ "so_ste_prague_reb2_yessir" ] 		= "so_ste_prague_reb2_yessir";
	level.scr_radio[ "so_ste_prague_reb3_somuch" ] 		= "so_ste_prague_reb3_somuch";
	level.scr_radio[ "so_ste_prague_reb3_helping" ] 	= "so_ste_prague_reb3_helping";
	
	// Soap: Player picks up an unsilenced weapon
	level.scr_radio[ "so_ste_prague_mct_careful" ] 		= "so_ste_prague_mct_careful";
	
	// -.-.-.-.-.-.-.-.-.-.-.-. Radio: Stealth Kills -.-.-.-.-.-.-.-.-.-.-.-. //
	
	// Single Kills
	
	//Sandman: Perfect.
	level.scr_radio[ "prague_killfirm_player_1" ]	= "prague_snd_goodshot";
	//Sandman: He's down.
	level.scr_radio[ "prague_killfirm_other_1" ]	= "prague_snd_hesdown";
	//Sandman: Target down.
	level.scr_radio[ "prague_killfirm_other_2" ]	= "prague_snd_targetdown";		
	//Sandman: That's a kill.
	level.scr_radio[ "prague_killfirm_other_4" ]	= "prague_snd_thatsakill";
	//Soap: Good night new stealth kill line
	level.scr_radio[ "prague_mct_goodnight" ] = "prague_mct_goodnight";
	
	level.scr_radio[ "so_ste_prague_mct_hesdead" ] = "so_ste_prague_mct_hesdead";
	level.scr_radio[ "so_ste_prague_mct_beautiful" ] = "so_ste_prague_mct_beautiful";
	
	// Multi Kills
	
	//Sandman: Nice.
	level.scr_radio[ "prague_killfirm_player_3" ]	= "prague_snd_nice";
	//Sandman: Got 'em.
	level.scr_radio[ "prague_killfirm_other_3" ]	= "prague_snd_gotem";	
	//Sandman: All clear.
	level.scr_radio[ "prague_clear_1" ]	= "prague_snd_allclear2";	
	//Sandman: Clear.
	level.scr_radio[ "prague_clear_2" ]	= "prague_snd_clear";		
	//Sandman: Targets neutralized.
	level.scr_radio[ "prague_clear_3" ]	= "prague_snd_targetsneutralized";
	
	level.scr_radio[ "so_ste_prague_mct_gotemall" ] = "so_ste_prague_mct_gotemall";
	level.scr_radio[ "so_ste_prague_mct_goodkills" ] = "so_ste_prague_mct_goodkills";
	level.scr_radio[ "so_ste_prague_mct_tangosdown" ] = "so_ste_prague_mct_tangosdown";
	level.scr_radio[ "so_ste_prague_mct_eliminated" ] = "so_ste_prague_mct_eliminated";
}

fx()
{
	level._effect[ "extraction_smoke" ]						= LoadFX( "smoke/signal_smoke_green" );
}