////////  WEEK 01 MISSION 01  ////////
////////   NARRATIVE SCRIPT   ////////



global object player_0 = player0;  
global object player_1 = player1;
global object player_2 = player2; 
global object player_3 = player3;   
global boolean e3m1_narrative_is_on = FALSE; 
global boolean e1m1_narrative_is_on = FALSE; 
global boolean e5m5_narrative_is_on = FALSE;

script startup sparops_e01_m01_main()
	
	dprint (":::  NARRATIVE SCRIPT  :::");
	
end

script static void e1m1_pup_in()
	//fires e1 m1 Narrative In scene

	
//	ai_place (squads_1);
	thread (vo_e1m1_intro());
	pup_play_show(e1_m1_intro_vin);
	NotifyLevel ("e1m1_pelican_should_leave");
	print ("squads are erased");

end


script static void f_respawn_pelicans()
	// respawns the first five intro pelicans
	
	ai_erase (sq_e1m1_pelican_1);
	ai_erase (sq_e1m1_pelican_2);
	ai_erase (sq_e1m1_pelican_3);
	ai_erase (sq_e1m1_pelican_4);
	ai_erase (sq_e1m1_pelican_5);
	
	ai_place (sq_e1m1_pelican_1);
	ai_place (sq_e1m1_pelican_2);
	ai_place (sq_e1m1_pelican_3);
	ai_place (sq_e1m1_pelican_4);
	ai_place (sq_e1m1_pelican_5);
	
end


script static void f_erase_pelicans()
	// respawns the first five intro pelicans
	
	ai_erase (sq_e1m1_pelican_1);
	ai_erase (sq_e1m1_pelican_2);
	ai_erase (sq_e1m1_pelican_3);
	ai_erase (sq_e1m1_pelican_4);
	ai_erase (sq_e1m1_pelican_5);
	
end


script command_script cs_warthog_drive()
	// CS for Hog driver in e1m1 intro
	
	cs_fly_to (ps_hog.p0);
	
end


script static long e3_m1_intro()
	// play e3m1 intro
	
	ai_erase (sq_e3m1_elites);
	ai_place (sq_e3m1_elites);
	ai_erase (sq_e3m1_lessers);
	ai_place (sq_e3m1_lessers);
	
	sleep (60);
	
	pup_play_show (pup_e3_m1_intro);
	
end

script static void pup_e5m5_intro()
	// play e5m5 intro
	
	pup_play_show (e5_m5_intro);
	
end

script command_script cs_intro_pelican()

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it’s avoiding things for no reason
	
  cs_vehicle_speed (1); 
  //Slows down the vehicle
  
  cs_fly_by (ps_narr_pelican.p0);
  
  sleep_until (LevelEventStatus ("e1m1_pelican_should_leave"), 1);
	cs_fly_to_and_face (ps_e1m1_pelican_exit.p0, ps_e1m1_pelican_exit.p2);
	cs_fly_to_and_face (ps_e1m1_pelican_exit.p1, ps_e1m1_pelican_exit.p2);
	cs_fly_to_and_face (ps_e1m1_pelican_exit.p2, ps_e1m1_pelican_exit.p2);
	cs_fly_to_and_face (ps_e1m1_pelican_exit.p3, ps_e1m1_pelican_exit.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e1m1_pelican_last);
end


//=============================================================================================================================
//================================= COMMAND SCRIPTS for E1 M1 Opening Pelicans ================================================
//=============================================================================================================================


script command_script cs_e1m1_pelican1()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e1m1_open_pel_1.p0);
	
end


script command_script cs_e1m1_pelican2()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e1m1_open_pel_2.p0);
	cs_fly_by (ps_e1m1_open_pel_2.p1);
	
end


script command_script cs_e1m1_pelican3()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e1m1_open_pel_3.p0);
	cs_fly_by (ps_e1m1_open_pel_3.p1);
	
end


script command_script cs_e1m1_pelican4()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e1m1_open_pel_4.p0);
	cs_fly_by (ps_e1m1_open_pel_4.p1);
	
end


script command_script cs_e1m1_pelican5()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e1m1_open_pel_5.p0);
	cs_fly_by (ps_e1m1_open_pel_5.p1);
	
end


//=============================================================================================================================
//================================= COMMAND SCRIPTS for E3 M1 Opening Pelicans ================================================
//=============================================================================================================================


script command_script cs_e3m1_pelican()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e3m1_open_pel.p0);
	
end


//=============================================================================================================================
//================================= COMMAND SCRIPTS for E5 M5 Outro Phantoms ==================================================
//=============================================================================================================================


script static void e5m5_spawn_phantoms()
	//spawn the phantoms in e5m5_narrative_is_on
	
//	ai_place (phantom_00.phantom_00);
//	sleep (20);
//	ai_place (phantom_01.phantom_01);
//	sleep (20);
	ai_place (phantom_02.phantom_02);
	sleep (20);
	ai_place (phantom_03.phantom_03);
	sleep (20);
	ai_place (phantom_04.phantom_04);
	sleep (20);
	ai_place (phantom_05.phantom_05);
	sleep (60);
	ai_place (phantom_06.phantom_06);
	sleep (30);
	ai_place (phantom_07.phantom_07);
	sleep (30);
	ai_place (phantom_08.phantom_08);
	
end


script command_script cs_e5m5_phantom_00()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e5m5_out_phantoms.p0);
	
end


script command_script cs_e5m5_phantom_01()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e5m5_out_phantoms.p1);
	
end


script command_script cs_e5m5_phantom_02()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e5m5_out_phantoms.p2);
	
end


script command_script cs_e5m5_phantom_03()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e5m5_out_phantoms.p3);
	
end


script command_script cs_e5m5_phantom_04()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_e5m5_out_phantoms.p4);
	
end


//=============================================================================================================================
//================================== CHOPPER BOWL Ep 01 Mission 01 VO scripts ==================================================
//=============================================================================================================================

//================================== Vignette Intro VO scripts ==================================================

script static void vo_e1m1_intro()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	start_radio_transmission ( "palmer_transmission_name" );
		
	// Palmer : Spartan Sarah Palmer, Infinity Commander to all Navy, Army, and Marine forces, you can relax.  The Spartans are here.
	dprint ("Palmer: Spartan Sarah Palmer, Infinity Commander to all Navy, Army, and Marine forces, you can relax.  The Spartans are here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_intro_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Spartan Miller to Fireteams Castle, Majestic, Domino, Ivy, and Crimson, sending coordinates for your Ops now. Crimson, I’ll be your handler for today.
	dprint ("Miller: Spartan Miller to Fireteams Castle, Majestic, Domino, Ivy, and Crimson, sending coordinates for your Ops now. Crimson, I’ll be your handler for today.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_narr_in_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_narr_in_00100'));
	
	end_radio_transmission();

	thread (vo_e1m1_objective());
	
end

script static void vo_e1m1_objective()
	//describe objective
	sleep_until (f_narrativein_done == TRUE);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, we’re dropping you off behind enemy lines to lend Marines a hand. You heard Commander Palmer at the briefing. We're here to knock some heads together.
	dprint ("Miller: Crimson, we’re dropping you off behind enemy lines to lend Marines a hand. You heard Commander Palmer at the briefing. We're here to knock some heads together.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_playstart_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_playstart_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (45);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// PIP
	hud_play_pip_from_tag (bink\spops\ep1_m1_1_60);

	// Palmer : Crimson, Commander Palmer.  Your mission's not just about wreaking havoc, fun though that may be.  Miller, light up the targets for Crimson.
	dprint ("Palmer: Crimson, Commander Palmer.  Your mission's not just about wreaking havoc, fun though that may be.  Miller, light up the targets for Crimson.");
	// 	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_objectives_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_objectives_00100_pip'));
	
	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	// Miller : Already on it, Commander
	dprint ("Miller: Already on it, Commander");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_objectives_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_objectives_00200'));

	b_wait_for_narrative_hud = FALSE;
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Those are power cores, intended for short-range wireless distribution.  Destroy them or the Covies will build bases, and we'll have a hell of a time rooting them out.
	dprint ("Palmer: Those are power cores, intended for short-range wireless distribution.  Destroy them or the Covies will build bases, and we'll have a hell of a time rooting them out.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_objectives_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_objectives_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : There are Covenant vehicles available for acquisition.
	dprint ("Miller: There are Covenant vehicles available for acquisition.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_taketanks_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_taketanks_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


//================================== Power Cores VO scripts ==================================================

script static void vo_e1m1_firstcore()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	sleep (30 * 1);	
	//play when first core is destroyed
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander Palmer, Crimson has completed the first objective.
	dprint ("Miller: Commander Palmer, Crimson has completed the first objective.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target1down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target1down_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I don't need second by second, Miller.  Tell me once the other three are down.
	dprint ("Palmer: I don't need second by second, Miller.  Tell me once the other three are down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target1down_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target1down_00200'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_secondcore()
	sleep_until (e1m1_narrative_is_on == FALSE);
	sleep (30 * 2);
	if	(e1m1_objectives_still_alive == 2)	then
		sleep_until (e1m1_narrative_is_on == FALSE);
		e1m1_narrative_is_on = TRUE;

		//play when second core is destroyed
		
		start_radio_transmission( "miller_transmission_name" );
			
		// Miller : You're half way there, Crimson.
		dprint ("Miller: You're half way there, Crimson.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target2down_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target2down_00100'));
		
		end_radio_transmission();
	
		e1m1_narrative_is_on = FALSE;
	else	(sleep (30 * 1));
	end
end


script static void vo_e1m1_thirdcore()
	sleep_until (e1m1_narrative_is_on == FALSE);
	sleep (30 * 2);
	if	(e1m1_objectives_still_alive == 3)	then
		sleep_until (e1m1_narrative_is_on == FALSE);
		e1m1_narrative_is_on = TRUE;
	
		//play when third core is destroyed
		
		start_radio_transmission( "miller_transmission_name" );
			
		// Miller : One more.  Then you can dust off for home.
		dprint ("Miller: One more.  Then you can dust off for home.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target3down_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_target3down_00100'));
		
		end_radio_transmission();
	
		e1m1_narrative_is_on = FALSE;
	else	(sleep (30 * 1));
	end
end


script static void vo_e1m1_lastcore()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	sleep (30 * 2);
	//play when last core is destroyed
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Final power core disabled, Commander.
	dprint ("Miller: Final power core disabled, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Affirmative, Miller.  Dalton, scramble a ride home from Crimson.
	dprint ("Palmer: Affirmative, Miller.  Dalton, scramble a ride home from Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Pelican already en route, Commander.
	dprint ("Dalton: Pelican already en route, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00300'));
	
	end_radio_transmission();

	e1m1_narrative_is_on = FALSE;
end


//================================== No More Waves VO scripts ==================================================

script static void vo_e1m1_securearea()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	sleep (30 * 2);
	
	if	(ai_living_count (gr_ff_all) >= 12)	then
	 
		start_radio_transmission( "miller_transmission_name" );
			
		// Miller : Need to finish securing the area. I'll mark the last few hostiles.
		dprint ("Miller: Need to finish securing the area. I'll mark the last few hostiles.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_3_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_3_00100'));
		
		end_radio_transmission();
		sleep (30 * 1);
		f_blip_ai_cui (gr_ff_all, "navpoint_enemy");
		sleep (30 * 2);
		f_new_objective (e1m1_objective02);

	else	(sleep (15));
	end
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_covenant_04()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	sleep (30 * 2);
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Eyes up. You've got a Phantom coming your way.
	dprint ("Palmer: Eyes up. You've got a Phantom coming your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_6_00100'));
		
	cui_hud_hide_radio_transmission_hud();
	sleep (90);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	sleep (30 * 1);
	
	// Miller : Crimson, more Covies arriving.  Be ready.
	dprint ("Miller: Crimson, more Covies arriving.  Be ready.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov04_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov04_00100'));
	
	end_radio_transmission();
	sleep (30 * 2);
	f_new_objective (e1m1_objective02);
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_droppodcallout_01()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Drop pods coming down near your position, Crimson!
	dprint ("Miller: Drop pods coming down near your position, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_5_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : There you go, Crimson. Something to shoot! Enjoy.
	dprint ("Palmer: There you go, Crimson. Something to shoot! Enjoy.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_10_0100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_10_0100'));
	
	end_radio_transmission();

	e1m1_narrative_is_on = FALSE;
end

script static void vo_e1m1_congrats01()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Beautiful, Crimson.
	dprint ("Palmer: Beautiful, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_8_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end

script static void vo_e1m1_droppodcallout_02()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Heads up, drop pods incoming!
	dprint ("Miller: Heads up, drop pods incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_4_00100'));
	
	end_radio_transmission();

	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_droppodcallout_03()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
// Miller : Drop pod incoming!
dprint ("Miller: Drop pod incoming!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100'));

end_radio_transmission();

	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_phantom_3()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Miller, recon says Phantom inbound.
	dprint ("Dalton: Miller, recon says Phantom inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_incphantom3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_incphantom3_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_covenant_02()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	// incoming covenant 2

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Reinforcements inbound, Crimson.
	dprint ("Miller: Reinforcements inbound, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov02_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov02_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


//================================== Get To LZ VO scripts ==================================================

script static void vo_e1m1_gettolz()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : All right, Crimson.  Your ride's inbound.  Fall back ot the LZ.
	dprint ("Miller: All right, Crimson.  Your ride's inbound.  Fall back ot the LZ.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_lasttargetdown_00400'));
	
	end_radio_transmission();
	
	b_wait_for_narrative_hud = FALSE;
	e1m1_narrative_is_on = FALSE;
	
end


//================================== End Mission VO scripts ==================================================

script static void vo_e1m1_arrivelz()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	// when player arrives at LZ
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander Palmer, mission successful.  Crimson's heading for home.
	dprint ("Miller: Commander Palmer, mission successful.  Crimson's heading for home.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Already?
	dprint ("Palmer: Already?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00200'));

	sleep (30);
	
	// Palmer : Everyone else is still hip deep in bad guys.
	dprint ("Palmer: Everyone else is still hip deep in bad guys.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00400'));

	sleep (15);
		
	// Palmer : Impressive work, Miller.  Congratulate the team.
	dprint ("Palmer: Impressive work, Miller.  Congratulate the team.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00500'));
	cui_hud_hide_radio_transmission_hud();
	
	sleep (30);
	
	// Pip
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep1_m1_2_60);
	
	// Miller : Well, Crimson…never heard Commander Palmer compliment anyone before.  Not a bad day at the office.
	dprint ("Miller: Well, Crimson…never heard Commander Palmer compliment anyone before.  Not a bad day at the office. See you back on Infinity.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00600', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00700', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_missionend_00600_pip'));
	
	end_radio_transmission();
	// end PIP

	e1m1_narrative_is_on = FALSE;
end


//================================== Enemy Callout VO scripts ==================================================

script static void vo_e1m1_phantom()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	//play when first phantom approaches

	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Miller, Phantom inbound on Crimson's position.
	dprint ("Dalton: Miller, Phantom inbound on Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_incphantom1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_incphantom1_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_phantom_2()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;

	//play when second phantom approaches

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, heads up.  Phantom inbound.
	dprint ("Miller: Crimson, heads up.  Phantom inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_incphantom2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_incphantom2_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_covenant_01()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	// incoming covenant 1
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, be advised of enemy reinforcements.
	dprint ("Miller: Crimson, be advised of enemy reinforcements.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov01_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_covenant_03()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	// incoming covenant 3
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Looks like more Covenant on the way.  Stay alert, Crimson.
	dprint ("Miller: Looks like more Covenant on the way.  Stay alert, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov03_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov03_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_covenant_05()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	// incoming covenant 5

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Eyes open, Crimson.  More Covies in your area.
	dprint ("Miller: Eyes open, Crimson.  More Covies in your area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov05_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov05_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


script static void vo_e1m1_wraith()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	//play when wraith approaches

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, be advised: you've got a Wraith closing in on your position.
	dprint ("Miller: Crimson, be advised: you've got a Wraith closing in on your position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_wraith01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_wraith01_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end

script static void vo_e1m1_justafewleft()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Painting the last targets for you now.
	dprint ("Miller: Painting the last targets for you now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_1_00100'));
	
	end_radio_transmission();
	
	e1m1_narrative_is_on = FALSE;
end


//================================== Misc Callout VO scripts ==================================================

script static void vo_e1m1_entervehicle()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
		
	// when player enters vehicle
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Nice, Crimson. Using the enemy’s toys against them!
	dprint ("Miller: Nice, Crimson. Using the enemy’s toys against them!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_gameplay_begins', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_gameplay_begins'));
	
	end_radio_transmission();

	e1m1_narrative_is_on = FALSE;
end

script static void vo_e1m1_troopdrop()
	sleep_until (e1m1_narrative_is_on == FALSE);
	e1m1_narrative_is_on = TRUE;
	
	//play when troops drop
	
	thread (story_blurb_add("vo", "no longer used"));
	
end


//============================================================================================================
//	Not used	//


//script static void vo_e1m1_playstarts()
//	sleep_until (e1m1_narrative_is_on == FALSE);
//	e1m1_narrative_is_on = TRUE;
//	
//	//when gameplay starts
//	
//	// Miller : Crimson, Spartans are lending a helping hand to Marines today.  You heard Commander Palmer at the briefing.  We're here to knock some heads together.
//	dprint ("Miller: Crimson, Spartans are lending a helping hand to Marines today.  You heard Commander Palmer at the briefing.  We're here to knock some heads together.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_playstart_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_playstart_00100'));
//	
//	e1m1_narrative_is_on = FALSE;
//end
//
//
//script static void vo_e1m1_hintvehicle()
//	// hint to take a vehicle
//	
//	// Miller : There are Covenant vehicles available for acquisition.
//	dprint ("Miller: There are Covenant vehicles available for acquisition.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_taketanks_00100', NONE, 1);
//	//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_taketanks_00100'));
//	
//end

//=============================================================================================================================
//================================== CHOPPER BOWL Ep 03 Mission 05 VO scripts =================================================
//=============================================================================================================================


script dormant e3m1_vo_intro()
	// intro
	
	sleep (60);
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, we've got a line on Parg Vol, a Sangheili terrorist, and a known associate of Jul 'Mdama.
	dprint ("Palmer: Crimson, we've got a line on Parg Vol, a Sangheili terrorist, and a known associate of Jul 'Mdama.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_intro_00300'));
	
	sleep (150);

	// Palmer : My thinking is, if we can put Vol down like a sick dog, then the galaxy's a better place.	
	dprint ("Palmer: My thinking is, if we can put Vol down like a sick dog, then the galaxy's a better place.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_intro_00400'));
	
	end_radio_transmission();
	
end


script dormant e3m1_vo_playstart()
	// play starts
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Incoming hostiles.
	dprint ("Miller: Incoming hostiles.");
	sound_impulse_start('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_inchostiles_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_inchostiles_00100'));
	
	end_radio_transmission();

	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_targetid()
	// target id'd
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Miller : Commander Palmer!  Parg Vol sighted.
	dprint ("Miller: Commander Palmer!  Parg Vol sighted.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_thereheis_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_thereheis_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Show Crimson.
	dprint ("Palmer: Show Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_thereheis_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_thereheis_00200'));
	
	end_radio_transmission();
	
	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_gettingaway()
	// he's getting away
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Miller, that Phantom's getting away!
	dprint ("Palmer: Miller, that Phantom's getting away!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00110', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00110'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : No!  Hey!  No fair!
	dprint ("Miller: No!  Hey!  No fair!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (90);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Damnit…
	dprint ("Palmer: Damnit…");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : We'll get another chance.  We know he can't go far.
	dprint ("Palmer: We'll get another chance.  We know he can't go far.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettingaway_00300'));	
	
	end_radio_transmission();
	
	e3m1_narrative_is_on = FALSE;
end

script dormant e3m1_clean_up_cronnies()
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, clean up the rest of Parg Vol’s cronies. No reason to let any of those hinge heads escape.
	dprint ("Palmer: Crimson, clean up the rest of Parg Vol’s cronies. No reason to let any of those hinge heads escape.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_cleanup_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_cleanup_00100'));
	
	end_radio_transmission();
	
	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_targetdown()
	//targets destroyed
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Parg Vol is down!  Confirmed kill!
	dprint ("Miller: Parg Vol is down!  Confirmed kill!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Great work, Crimson.
	dprint ("Palmer: Great work, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00200'));
	
	end_radio_transmission();
	
	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_unsctoys()
	//get the UNSC toys
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Commander Palmer?
	dprint ("Dalton: Commander Palmer?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Go ahead, Dalton.
	dprint ("Palmer: Go ahead, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Taking a look at your drone footage, I see Parg Vol snatched a considerable number of UNSC assets.  I'd like to recover those if we can.
	dprint ("Dalton: Taking a look at your drone footage, I see Parg Vol snatched a considerable number of UNSC assets.  I'd like to recover those if we can.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Don't see why not.
	dprint ("Palmer: Don't see why not.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Thanks.  Painting a waypoint now.
	dprint ("Dalton: Thanks.  Painting a waypoint now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_unsctoys_00500'));
	
	end_radio_transmission();
	
	e3m1_narrative_is_on = FALSE;
end

script dormant e3m1_tech_stolen()
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, do me a favor and take down any bad guys. I don't appreciate UNSC tech being stolen.
	dprint ("Palmer: Crimson, do me a favor and take down any bad guys. I don't appreciate UNSC tech being stolen.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3_m1_cleararea_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3_m1_cleararea_00200'));
	
	end_radio_transmission();

	e3m1_narrative_is_on = FALSE;
end

script dormant e3m1_vo_toysget()
	//got the toys
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Parg Vol wasn't screwing around when he decided to start a UNSC collection, was he?
	dprint ("Palmer: Parg Vol wasn't screwing around when he decided to start a UNSC collection, was he?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettinggear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettinggear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Thanks for securing that gear, Crimson.  Much appreciated.
	dprint ("Dalton: Thanks for securing that gear, Crimson.  Much appreciated.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettinggear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_gettinggear_00200'));
	
	end_radio_transmission();
	
	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_hornetsnest()
	//opened a hornets nest
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	sleep (50);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander…we've got trouble.  Crimson's kicked the hornet's nest down there.  Every member of the Covenant within two klicks is heading their way.
	dprint ("Miller: Commander…we've got trouble.  Crimson's kicked the hornet's nest down there.  Every member of the Covenant within two klicks is heading their way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_hornetsnest_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_hornetsnest_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	hud_play_pip_from_tag (bink\spops\ep3_m1_1_60);
	// Palmer : Grab some ammo and dig in, Crimson.  Here comes a party.
	dprint ("Palmer: Grab some ammo and dig in, Crimson.  Here comes a party.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_hornetsnest_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_hornetsnest_00200_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_badsarrive()
	//more baddies
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : They're here!
	dprint ("Miller: They're here!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_morebaddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_morebaddies_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Give 'em hell, Crimson.
	dprint ("Palmer: Give 'em hell, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_morebaddies_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_morebaddies_00200'));
	
	end_radio_transmission();

	e3m1_narrative_is_on = FALSE;
end

script dormant e3m1_vo_scorched_earth()
	//more baddies
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Clear the area, Crimson. Scorched Earth policy here.
	dprint ("Palmer: Clear the area, Crimson. Scorched Earth policy here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3_m1_cleararea_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3_m1_cleararea_00100'));
	
	end_radio_transmission();

	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_alldone()
	//all's well
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : That's the last of them.
	dprint ("Miller: That's the last of them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_comehome_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_comehome_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Well done, Crimson.  Dalton, give Crimson a lift home?
	dprint ("Palmer: Well done, Crimson.  Dalton, give Crimson a lift home?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_comehome_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_comehome_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Of course, Commander.  Pelican on the way now.
	dprint ("Dalton: Of course, Commander.  Pelican on the way now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_comehome_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_comehome_00300'));
	
	end_radio_transmission();

	e3m1_narrative_is_on = FALSE;
end


script dormant e3m1_vo_doctorowen()
	//Doctor Owen calls in
	sleep_until (e3m1_narrative_is_on == FALSE);
	e3m1_narrative_is_on = TRUE;
	
	sleep (50);

	start_radio_transmission( "owen_transmission_name" );
		
	// Doctor Owen : Infinity!  This is Doctor Owen at Galileo base --
	dprint ("Doctor Owen: Infinity!  This is Doctor Owen at Galileo base --");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00100_soundstory', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00100_soundstory'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Doctor Owen?  Hello?
	dprint ("Palmer: Doctor Owen?  Hello?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Emergency beacon activated at Galileo.  They're under attack.
	dprint ("Miller: Emergency beacon activated at Galileo.  They're under attack.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep3_m1_2_60);
	
	// Palmer : Crimson, you're closest.  Saddle up.  You're the rescue crew.
	dprint ("Palmer: Crimson, you're closest.  Saddle up.  You're the rescue crew.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_01\e3m1_outro_00400_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e3m1_narrative_is_on = FALSE;
end


//=============================================================================================================================
//================================== CHOPPER BOWL Ep 05 Mission 05 VO scripts ==================================================
//=============================================================================================================================


script static void vo_e5m5_intro()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Roland, any more info on Thorne's whereabouts?
	dprint ("Miller: Roland, any more info on Thorne's whereabouts?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : The Elites carried him out of surveillance range.  Can't do much more than give you a general direction right now.
	dprint ("Roland: The Elites carried him out of surveillance range.  Can't do much more than give you a general direction right now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Keep looking.  And try to get Commander Palmer on the line.  She needs to know what's happening.
	dprint ("Miller: Keep looking.  And try to get Commander Palmer on the line.  She needs to know what's happening.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Crimson, this is straight search and rescue.  Get in there, and see what you can find.
	dprint ("Miller: Crimson, this is straight search and rescue.  Get in there, and see what you can find.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_intro_00400'));
	
	end_radio_transmission();

	thread (vo_e5m5_1stgoal());
end


script static void vo_e5m5_1stgoal()

	sleep_until (b_players_are_alive(), 1);
	sleep (30 * 1);
	start_radio_transmission( "roland_transmission_name" );
	
	hud_play_pip_from_tag (bink\spops\ep5_m5_1_60); 
	print ("PiP : ROLAND : Here’s the most likely location for where Spartan Thorne might have been taken.");
	// PiP : I'm showing two likely locations where Spartan Thorne might have been taken.
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_overthere_00100_pip'));
	
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Marking a waypoint.
	dprint ("Miller: Marking a waypoint.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00500'));
	
	end_radio_transmission();

	f_blip_flag (fl_e5m5_area01, default);
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_nothere()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : I'm not seeing Thorne anywhere, Roland.
	dprint ("Miller: I'm not seeing Thorne anywhere, Roland.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothere_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : Agreed.
	dprint ("Roland: Agreed.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothere_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothere_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30 * 2);
	
	if	(ai_living_count (e5m5_ff_all) > 0)	then
		cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
		// Miller : Just a few stragglers, Crimson.
		dprint ("Miller: Just a few stragglers, Crimson.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_2_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_2_00100'));
	
		cui_hud_hide_radio_transmission_hud();
	else	(sleep (10));
	
	end
	
	end_radio_transmission();
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_covenant_03()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	// incoming covenant 3
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Oh boy... Crimson, Phantom inbound.
	dprint ("Miller: Oh boy... Crimson, Phantom inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_10_0100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_10_0100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_covenant_reinforcements()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	// incoming covenant 5

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Eyes open, Crimson.  More Covies in your area.
	dprint ("Miller: Eyes open, Crimson.  More Covies in your area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov05_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_01\e1m1_morecov05_00100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_overthere()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Power source nearby. Might be worth getting a look at it?
	dprint ("Miller: Power source nearby. Might be worth getting a look at it?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_5_00100'));
	
	end_radio_transmission();
	
	f_unblip_ai (e5m5_ff_all);
	f_unblip_ai_cui (e5m5_ff_all);
	f_blip_flag (fl_e5m5_area02, default);
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_lottabads()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	sleep (30 * 3);
	
	f_unblip_ai (e5m5_ff_all);
	f_unblip_ai_cui (e5m5_ff_all);
	start_radio_transmission( "roland_transmission_name" );
		
	// Roland : There is a higher than average number of enemy forces in this area.
	dprint ("Roland: There is a higher than average number of enemy forces in this area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Might mean there's something worth guarding.
	dprint ("Miller: Might mean there's something worth guarding.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : Like a Spartan.
	dprint ("Roland: Like a Spartan.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Yup.
	dprint ("Miller: Yup.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_lottabads_00400'));
	
	end_radio_transmission();

	f_unblip_ai (e5m5_ff_all);
	f_unblip_ai_cui (e5m5_ff_all);
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_unscgear()
	sleep_until (e5m5_narrative_is_on == FALSE);
	sleep (30 * 2);
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "roland_transmission_name" );
		
	// Roland : Lots of UNSC gear here.
	dprint ("Roland: Lots of UNSC gear here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_unscgear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_unscgear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Grrr…but where's Thorne?!
	dprint ("Miller: Grrr…but where's Thorne?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_unscgear_00200', NONE, 1);

	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_unscgear_00200'));
	
	end_radio_transmission();

	thread (vo_e5m5_nothorne());
end


script static void vo_e5m5_nothorne()

	sleep (60);
	start_radio_transmission( "roland_transmission_name" );
	
	// Roland : I've confirmed that Spartan Thorne isn't here.
	dprint ("Roland: I've confirmed that Spartan Thorne isn't here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	hud_play_pip_from_tag (bink\spops\ep5_m5_2_60); 
	cui_hud_show_radio_transmission_hud( "" );

	// Miller : Then where the hell is he, Roland?
	// Roland : No ideas right now.
	// Miller : Alright.  Dalton, I need a ride home for Crimson.
	
	dprint ("Miller: Then where the hell is he, Roland?");
	dprint ("Roland: No ideas right now.");
	dprint ("Miller: Alright.  Dalton, I need a ride home for Crimson.");
	
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00200', NONE, 1);
	// 	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00300', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00200_pip'));

	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Gonna be a few on that request.
dprint ("Dalton: Gonna be a few on that request.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00500', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_nothorne_00500'));

end_radio_transmission();

e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_droppods()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Drop pods incoming!
	dprint ("Miller: Drop pods incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_droppods_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_droppods_00100'));
	
	end_radio_transmission();

	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_someguns()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Don't relax yet. You've got more hostiles headed your way.
	dprint ("Miller: Don't relax yet. You've got more hostiles headed your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_3_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30 * 2);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : If we have to wait for a ride, how about some guns?
	dprint ("Miller: If we have to wait for a ride, how about some guns?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_someguns_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_someguns_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : That, I can do.
	dprint ("Dalton: That, I can do.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_someguns_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_someguns_00200'));
	
	end_radio_transmission();

	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_pelican()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;

	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Finally got your bird, Miller.  Where ya want it?
	dprint ("Dalton: Finally got your bird, Miller.  Where ya want it?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelican_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelican_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Put her down right here, should be safe.
	dprint ("Miller: Put her down right here, should be safe.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelican_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelican_00200'));
	
	end_radio_transmission();

	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_arrives()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "e5m5_pilot_1_transmission_name" );
	
	// e5m5_pilot1 : This is Pelican 653.  I have visual on Fireteam Crimson.  Touching down at LZ.
	dprint ("e5m5_pilot1: This is Pelican 653.  I have visual on Fireteam Crimson.  Touching down at LZ.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_arrives_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_arrives_00100'));
	
	end_radio_transmission();

	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_pelicanboom()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Oh God!  What was that!
	dprint ("Miller: Oh God!  What was that!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : Spartan Miller!  This is pretty bad!  Incoming enemy forces!  Numerous.
	dprint ("Roland: Spartan Miller!  This is pretty bad!  Incoming enemy forces!  Numerous.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Define numerous, Roland.
	dprint ("Miller: Define numerous, Roland.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : A lot!  Maybe all of them?
	dprint ("Roland: A lot!  Maybe all of them?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (90);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	sleep (30 * 1);
	
	// Miller : Ohhh boy.  Crimson, brace yourselves.  This is gonna get ugly.
	dprint ("Miller: Ohhh boy.  Crimson, brace yourselves.  This is gonna get ugly.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_pelicanboom_00500'));
	
	end_radio_transmission();

	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_sniper()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "roland_transmission_name" );
	
// Roland : Sniper!
dprint ("Roland: Sniper!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_sniper_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_sniper_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Light him up, Roland!
dprint ("Miller: Light him up, Roland!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_sniper_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5_sniper_00200'));

end_radio_transmission();
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_rvb_01
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	// RvB_Sarge : I know you boys wanted a lift, but all I’ve got are these guns. I suppose you COULD assemble some sort of primitive, gun-like vehicle out of the parts. But who knows what the insurance rates would be on that bad boy...
	dprint ("RvB_Sarge: I know you boys wanted a lift, but all I’ve got are these guns. I suppose you COULD assemble some sort of primitive, gun-like vehicle out of the parts. But who knows what the insurance rates would be on that bad boy...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5rvb_dropguns_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5rvb_dropguns_00100'));

	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_rvb_02
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	// RvB_Sarge : Damnit, Grif, you dropped our cargo! Now how are we supposed to play Grifball?
	dprint ("RvB_Sarge: Damnit, Grif, you dropped our cargo! Now how are we supposed to play Grifball?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5rvb_gravhammer_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5rvb_gravhammer_00100'));

	// RvB_Grif : I think the bigger question here is why a military vehicle was sent into battle with sports equipment.
	dprint ("RvB_Grif: I think the bigger question here is why a military vehicle was sent into battle with sports equipment.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5rvb_gravhammer_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_05\e5m5rvb_gravhammer_00200'));

	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_callouts_01()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Still have a few Covies to clear out, Crimson.
	dprint ("Miller: Still have a few Covies to clear out, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_3_00100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_callouts_02()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Just a few Covies left. I'll get markers on them.
	dprint ("Miller: Just a few Covies left. I'll get markers on them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_1_00100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_callouts_03()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Area's not secure yet. Marking your last few targets.
	dprint ("Miller: Area's not secure yet. Marking your last few targets.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_1_00100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end

script static void vo_e5m5_callouts_04()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Phantom!
	dprint ("Miller: Phantom!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_8_00100'));
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	sleep (10);
	cui_hud_hide_radio_transmission_hud();

	// Miller : Crimson! Look out!
	dprint ("Miller: Crimson! Look out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_7_00100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_callouts_05()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Watch out! Hostiles inbound!
	dprint ("Miller: Watch out! Hostiles inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_4_00100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end


script static void vo_e5m5_callouts_06()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Drop pods coming down near your position, Crimson!
	dprint ("Miller: Drop pods coming down near your position, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_5_00100'));
	
	end_radio_transmission();
	
	e5m5_narrative_is_on = FALSE;
end

script static void vo_e5m5_callouts_07()
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Uh oh. Phantom inbound!
	dprint ("Miller: Uh oh. Phantom inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_9_00100'));
	
	end_radio_transmission();

	e5m5_narrative_is_on = FALSE;
end