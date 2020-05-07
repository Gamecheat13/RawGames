////////  WEEK 01 MISSION 01  ////////
////////   NARRATIVE SCRIPT   ////////

global boolean e2m3_narrative_in_use = FALSE;
global short e2m3_bases_saved = 0;
global object player_0 = player0;  
global object player_1 = player1;
global object player_2 = player2; 
global object player_3 = player3;     


script startup sparops_e02_m03_main()
	dprint (":::  E2M3 NARRATIVE SCRIPT  :::");
end

//343++343==343++343==343++343	E2M3 Narrative In	343++343==343++343==343++343//

script static void e2m3_narrative_in()
//fires e2 m3 Narrative In scene
	
	ai_erase (sq_e2m3_male_01);
	ai_place (sq_e2m3_male_01);
	
	ai_erase (sq_e2m3_male_02);
	ai_place (sq_e2m3_male_02);
	
	ai_erase (sq_e2m3_jackal);
	ai_place (sq_e2m3_jackal);
	
	ai_erase (sq_e2m3_elite);
	ai_place (sq_e2m3_elite);
	
	pup_play_show(e2m3_narrative_in);
	
	print ("e2m3 puppeteer narrative in starting!");
	sleep_s (2.0);

end

//343++343==343++343==343++343	E2M3 Opening VO	343++343==343++343==343++343//

script static void e2m3_puppeteer_opening_tts()
//	During Puppeteer VO
	// VO for intro scene
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	sleep (120);
	
	start_radio_transmission( "e2m3_marine_1_transmission_name" );
		
	// e2m3_marine_01 : Infinity!  This is Hacksaw.  We're getting hit hard on all sides!
	dprint ("e2m3_marine_01: Infinity!  This is Hacksaw.  We're getting hit hard on all sides!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00100'));

	sleep (30 * 1);

	// e2m3_marine_01 : We need reinforcements, ordnance -- Hell, I'd settle for a straight-up evac right now!
	dprint ("e2m3_marine_01: We need reinforcements, ordnance -- Hell, I'd settle for a straight-up evac right now!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00200'));
	
	sleep (10);

	// Palmer : Man up, Hacksaw.  Reinforcements inbound.
	dprint ("Palmer: Man up, Hacksaw.  Reinforcements inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00300'));
	
	end_radio_transmission();
	
	sleep (30 * 2);
	thread (e2m3_tts_savemarines());
end


script static void e2m3_tts_savemarines()
	// instruct to save marines
	
	// PIP
	start_radio_transmission( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep2_m3_1_60);
	
	// Palmer : Crimson, it's a straightforward rescue op.  If it's UNSC, save its ass.  If it's a Covie, blast it to hell.
	dprint ("Palmer: Crimson, it's a straightforward rescue op.  If it's UNSC, save its ass.  If it's a Covie, blast it to hell.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00100_pip'));

	cui_hud_hide_radio_transmission_hud();
	// end PIP

	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Commander Palmer, I'm painting the locs of Marines calling for assistance.
	dprint ("Miller: Commander Palmer, I'm painting the locs of Marines calling for assistance.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00200'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	thread (e2m3_locationblips());
	b_wait_for_narrative_hud = FALSE;
	e2m3_narrative_in_use = FALSE;
end


//343++343==343++343==343++343	E2M3 Fort Objective VO Triggers	343++343==343++343==343++343//

//	VO for drop pods

script static void e2m3_tts_droppod01()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Drop pod incoming!
	dprint ("Miller: Drop pod incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100'));
	
	end_radio_transmission();

	e2m3_narrative_in_use = FALSE;
end


script static void e2m3_tts_droppod02()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Heads up, drop pods incoming!
	dprint ("Miller: Heads up, drop pods incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_4_00100'));
	
	end_radio_transmission();

	e2m3_narrative_in_use = FALSE;
end


script static void e2m3_tts_droppod03()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Covenant drop pods inbound!
	dprint ("Miller: Covenant drop pods inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_3_00100'));
	
	end_radio_transmission();

	e2m3_narrative_in_use = FALSE;
end

//	VO for arriving at each Fort

script static void e2m3_tts_marine01arrive()
	// arrive at first Marines
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "e2m3_marine_2_transmission_name" );
		
	// e2m3_marine_02 : Hey!  It's Spartans!
	dprint ("e2m3_marine_02: Hey!  It's Spartans!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "e2m3_marine_3_transmission_name" );

	// e2m3_marine_03 : Oh, hell yeah!
	dprint ("e2m3_marine_03: Oh, hell yeah!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00200'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end


script static void e2m3_tts_marine02arrive()
	// arrive at second Marines
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "e2m3_marine_6_transmission_name" );
		
	// e2m3_marine_06 : There's our ride home, Marines!
	dprint ("e2m3_marine_06: There's our ride home, Marines!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "e2m3_marine_7_transmission_name" );

	// e2m3_marine_07 : Hell yes!
	dprint ("e2m3_marine_07: Hell yes!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00200'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end


script static void e2m3_tts_marine03arrive()
	// arrive at third Marines
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
//	// e2m3_marine_04 : They won't stop!  They just won't stop!
//	dprint ("e2m3_marine_04: They won't stop!  They just won't stop!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00100'));

	start_radio_transmission( "e2m3_marine_5_transmission_name" );
	
	// e2m3_marine_05 : Look!  Spartans!  We're saved!
	dprint ("e2m3_marine_05: Look!  Spartans!  We're saved!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00200'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end


//	VO for objectives progress

script static void e2m3_1_base_saved()
	// rescued first Marines
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Nice work, Crimson.  Hacksaw team, you're under Spartan command for the duration.  Fall in with Crimson and offer fire support.
	dprint ("Palmer: Nice work, Crimson.  Hacksaw team, you're under Spartan command for the duration.  Fall in with Crimson and offer fire support.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "e2m3_marine_2_transmission_name" );

	// e2m3_marine_02 : You got it, Commander!
	dprint ("e2m3_marine_02: You got it, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00200'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
	if	(e2m3_bases_saved == 1)	then
		sleep (30 * 1);
		else (sleep (30 * 1));
	end
end


script static void e2m3_2_bases_saved()
	// have rescued second Marines
	
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Hacksaw group two is clear, Commander.
	dprint ("Miller: Hacksaw group two is clear, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Looking good down there, Crimson.  Keep it up.
	dprint ("Palmer: Looking good down there, Crimson.  Keep it up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (60);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Dalton, you there?
	dprint ("Palmer: Dalton, you there?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Online, Commander.
	dprint ("Dalton: Online, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Line up a ride for Crimson and friends.
	dprint ("Palmer: Line up a ride for Crimson and friends.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Pelican will be inbound inside of ten, Commander.
	dprint ("Dalton: Pelican will be inbound inside of ten, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02rescue_00600'));	
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
	if	(e2m3_bases_saved == 2)	then
		sleep (30 * 1);
		else (sleep (30 * 1));
	end
end


script static void e2m3_3_bases_saved()
	// rescued third Marines
	
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Excellent work.
	dprint ("Palmer: Excellent work.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_4_00100'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end



//343++343==343++343==343++343	E2M3 Reinforcements VO Triggers	343++343==343++343==343++343//

script static void e2m3_tts_reinforcements()
// incoming Covenant Reinforcements
	
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Watch out! Hostiles inbound!
	dprint ("Miller: Watch out! Hostiles inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_4_00100'));
	
	end_radio_transmission();
	
	thread (e2m3_tts_wraith01());
end


script static void e2m3_tts_wraith01()
	// incoming wraith 1
	
	sleep (15);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Phantom's transporting a Wraith, Commander.
	dprint ("Miller: Phantom's transporting a Wraith, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_wraith01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_wraith01_00100'));
	
	end_radio_transmission();
	
	thread (e2m3_tts_cleartolz());
end


script static void e2m3_tts_cleartolz()
	// clear path to landing zone_set_trigger_volume_enable
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Dalton, sitrep on the extraction team?
	dprint ("Palmer: Dalton, sitrep on the extraction team?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00100'));
	
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Just need a place to land, Commander.  But there is a lot of activity down there.
	dprint ("Dalton: Just need a place to land, Commander.  But there is a lot of activity down there.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, clear the tower of any Covenant and give Dalton's people somewhere to park.
	dprint ("Palmer: Crimson, clear the tower of any Covenant and give Dalton's people somewhere to park.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00300'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end

script static void e2m3_tts_phantomreinforcements()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Look out, there's a Phantom headed your way!
	dprint ("Miller: Look out, there's a Phantom headed your way!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_7_00100'));

	end_radio_transmission();
	e2m3_narrative_in_use = FALSE;
end


script static void e2m3_tts_phantomreinforcements02()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Hostiles inbound, Crimson!
	dprint ("Miller: Hostiles inbound, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_2_00100'));

	end_radio_transmission();
	e2m3_narrative_in_use = FALSE;
end


script static void e2m3_tts_phantomreinforcements03()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Phantom incoming!
	dprint ("Miller: Phantom incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00100'));

	end_radio_transmission();
	e2m3_narrative_in_use = FALSE;
end


script static void e2m3_tts_stragglers()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Just a few Covenant remaining. Marking them for you.
	dprint ("Miller: Just a few Covenant remaining. Marking them for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_2_00100'));

	end_radio_transmission();
	e2m3_narrative_in_use = FALSE;
	
	f_blip_ai_cui (e2m3_ff_all, "navpoint_enemy");
end


//343++343==343++343==343++343	E2M3 Location Objective VO Triggers	343++343==343++343==343++343//

script static void e2m3_tts_headtoevac01()
	
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : All right, Crimson.  Your ride's inbound.  Fall back ot the LZ.
	dprint ("Miller: All right, Crimson.  Your ride's inbound.  Fall back ot the LZ.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00400'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end

//343++343==343++343==343++343	E2M3 Phantom Fendoff Objective VO Triggers	343++343==343++343==343++343//

script static void e2m3_tts_phantomfendoffstart
	// second Phantom incoming
	
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Oh this is bad.
	dprint ("Miller: Oh this is bad.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Spit it out, Miller.
	dprint ("Palmer: Spit it out, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Phantoms.  Multiple inbound on Crimson's position.
	dprint ("Miller: Phantoms.  Multiple inbound on Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00300'));
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Multiple?!
	dprint ("Dalton: Multiple?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Well, that's hardly fair.  They'll need way more than that if they're going to beat Crimson.
	dprint ("Palmer: Well, that's hardly fair.  They'll need way more than that if they're going to beat Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom02_00500'));
	
	end_radio_transmission();

	
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e2m3_template_phantom04.driver), "navpoint_healthbar_neutralize");
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e2m3_template_phantom05.driver), "navpoint_healthbar_neutralize");
	sleep (30 * 3);
	thread (e2m3_tts_ammocrates());
end

script static void e2m3_tts_ammocrates()
	// Ammo crates arrive
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Ammo crates.
	dprint ("Palmer: Ammo crates.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Left over from earlier, Commander.  Should be pretty well stocked.
	dprint ("Dalton: Left over from earlier, Commander.  Should be pretty well stocked.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	NotifyLevel ("e2m3_rocketammo");

	// Palmer : Ammo up, Crimson.
	dprint ("Palmer: Ammo up, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00300'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	thread (e2m3_rocketammo_respawn());
	e2m3_narrative_in_use = FALSE;
end

script static void e2m3_2phantoms_dead()
	// all Phantoms down
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : That's all of the Phantoms, commander!
	dprint ("Miller: That's all of the Phantoms, commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantomsclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantomsclear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Told ya it wasn't a fair fight.
	dprint ("Palmer: Told ya it wasn't a fair fight.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantomsclear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantomsclear_00200'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end

script static void e2m3_tts_stragglers02()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, clear out the last few stragglers down there.  Dalton, get your bird on the ground pronto.
	dprint ("Palmer: Crimson, clear out the last few stragglers down there.  Dalton, get your bird on the ground pronto.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_stragglers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_stragglers_00100'));
	
	end_radio_transmission();

	sleep (15);
	f_blip_ai_cui (e2m3_ff_all, "navpoint_enemy");
	
	e2m3_narrative_in_use = FALSE;
end

//343++343==343++343==343++343	E2M3 Cleanup Objective VO Triggers	343++343==343++343==343++343//

script static void e2m3_tts_locationarrival02start()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	
	sleep (30 * 1);

	if (ai_living_count (gr_e2m3_marines) == 6)	then
		// you got all the marines out
			
		start_radio_transmission( "palmer_transmission_name" );
			
		// Palmer : Nice work keeping Hacksaw in one piece, Crimson.
		dprint ("Palmer: Nice work keeping Hacksaw in one piece, Crimson.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_allmarinesout_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_allmarinesout_00100'));
		cui_hud_hide_radio_transmission_hud();
		e2m3_narrative_in_use = FALSE;
		f_achievement_spops_2();
		
	elseif ((ai_living_count (gr_e2m3_marines) >= 2) and (ai_living_count (gr_e2m3_marines) <= 5))	then
		// got some marines out
			

		start_radio_transmission( "palmer_transmission_name" );
					
		// Palmer : Textbook example of kicking ass. Well done, Crimson.
		dprint ("Palmer: Textbook example of kicking ass. Well done, Crimson.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_10_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_10_00100'));	
		cui_hud_hide_radio_transmission_hud();
		e2m3_narrative_in_use = FALSE;
		f_achievement_spops_2();
			
	elseif (ai_living_count (gr_e2m3_marines) == 1)	then
		// got only one marine out
			
		start_radio_transmission( "palmer_transmission_name" );
					
		// Palmer : Well, Crimson, at least you got one Marine out.
		dprint ("Palmer: Well, Crimson, at least you got one Marine out.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_onemarineout_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_onemarineout_00100'));
		cui_hud_hide_radio_transmission_hud();
		e2m3_narrative_in_use = FALSE;
		f_achievement_spops_2();
			
	elseif (ai_living_count (gr_e2m3_marines) == 0)	then
		// no marines survived

		start_radio_transmission( "palmer_transmission_name" );
				
		// Palmer : Crimson, this was a search and rescue mission.  I think you forgot the rescue bit.
		dprint ("Palmer: Crimson, this was a search and rescue mission.  I think you forgot the rescue bit.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marinesdead_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marinesdead_00100'));
		cui_hud_hide_radio_transmission_hud();
		e2m3_narrative_in_use = FALSE;
	end
		
	cui_hud_hide_radio_transmission_hud();
	sleep (30 * 1);
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : That's everyone. Crimson, you can head to the evac point.
	dprint ("Miller: That's everyone. Crimson, you can head to the evac point.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03rescue_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03rescue_00100'));
	
	end_radio_transmission();
	
end

//	Misison End


script static void e2m3_tts_alldone()
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;
	sleep (30 * 1);
// level is done

	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Pelican is on point and waiting, Commander.
	dprint ("Dalton: Pelican is on point and waiting, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);

	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep2_m3_2_60);
	// Palmer : Understood, Dalton.  Job's done, Crimson.  Come on home.
	dprint ("Palmer: Understood, Dalton.  Job's done, Crimson.  Come on home.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00200_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e2m3_narrative_in_use = FALSE;
end

//343++343==343++343==343++343	E2M3 Callout VO Triggers	343++343==343++343==343++343//

script static void e2m3_tts_phantom_arrival
		// incoming Phantom 1
	sleep_until (e2m3_narrative_in_use == FALSE);
	e2m3_narrative_in_use = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Don't relax yet. You've got more hostiles headed your way.
	dprint ("Miller: Don't relax yet. You've got more hostiles headed your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_3_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Keep sharp, Crimson.
	dprint ("Palmer: Keep sharp, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00200'));
	
	end_radio_transmission();
	
	e2m3_narrative_in_use = FALSE;
end
