// =============================================================================================================================
//============================================ SCURVE NARRATIVE SCRIPT ========================================================
// =============================================================================================================================


// behold, the greatest narrative script ever to pass through the halls of 343...or 550...or whatever...it will be good anyway.

global object pup_player0 = player0;
global object pup_player1 = player1;
global object pup_player2 = player2;
global object pup_player3 = player3;
global boolean b_pelican_done = false;

script startup sparops_e01_m05_main()
	
	dprint (":::  NARRATIVE SCRIPT  :::");
	
end
//
//


script static void ex1()
	//fires e1 m5 Narrative Out scene
	
//	ai_erase (squads_elite);
//	ai_erase (squads_jackal);
//	ai_place (squads_elite);
//	ai_place (squads_jackal);

	pup_play_show(e1_m5_narrative_in_e3);
	
//	pup_play_show(e1_m5_narrative_in);
	
end


script static void ex2()
	//fires e1 m5 Narrative Out scene
	
	ai_erase (squads_1);
	ai_erase (squads_2);
	ai_erase (squads_3);
	
	pup_play_show(e1_m5_narrative_out);
	
end


script static void ex3()
	// plays e2m2 intro
	
	scene_e2m2_intro();
	
end


script static void scene_e2m2_intro()
	// scripting to control E2 M2 intro scene
	
//	fade_out (0, 0, 0, 1);
	camera_control (true);
	chud_show (false);
	camera_fov = 22;
	camera_pan (e2m2_camin_01_1, e2m2_camin_01_2, 300, 0, 1, 0, 1);
	fade_in (0, 0, 0, 90);
	
	sleep (75);
	ai_place (sq_e2m2_pelican_1);
	
	sleep (180);
	camera_fov = 22;
	camera_pan (e2m2_camin_02_1, e2m2_camin_02_2, 300, 0, 1, 0, 1);
	
	sleep (210);
	
	fade_out (0, 0, 0, 30);
	sleep (30);
	
	camera_control (false);
	camera_fov = 78;
	
	ai_erase (sq_e2m2_pelican_1);
	chud_show (true);
	fade_in (0, 0, 0, 1);
	
end


script command_script cs_e2m2_intro()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_fly_by (ps_e2m2_intro.p0);
 	cs_fly_by (ps_e2m2_intro.p1);
	
end


script command_script cs_evac()

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it’s avoiding things for no reason
	
 	cs_fly_by (ps_e1m5_evac.p5);
	// cs_fly_by (ps_e1m5_evac.p6);
	
  cs_vehicle_speed (.3); 
  //Slows down the vehicle
  
  cs_fly_to_and_face (ps_e1m5_evac.p0, ps_e1m5_evac.p1);
  
  cs_vehicle_speed (.2);
  
  sleep_s (2.5);
  
  cs_fly_to_and_face (ps_e1m5_evac.p1, ps_e1m5_evac.p2);
  
  sleep_s (.5);
  b_pelican_done = true;
  
  cs_vehicle_speed (0.05);
  
  repeat 
		
		dprint ("next noise loop");
		
		cs_fly_to_and_face  (ps_e1m5_evac.p7, ps_e1m5_evac.p2);
		//sleep (90);
		
		cs_fly_to_and_face  (ps_e1m5_evac.p6, ps_e1m5_evac.p2);
		//sleep (90);

	until (1 == 0, 15); // set the time here to be whatever instead of 1/2 a second
  
end


script command_script cs_evac_phantom()

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it’s avoiding things for no reason
	
  //cs_vehicle_speed (.5); 
  //Slows down the vehicle
  
  cs_fly_by (ps_e1m5_evac.p_phantom_1);
  
end


script command_script cs_evac_leave()
	// pelican leaves in cutscene
	
	cs_vehicle_speed (1.0);
//	cs_fly_by (ps_e1m5_evac.p3);
	cs_fly_to (ps_e1m5_evac.p8);
	
end


//script startup jesse_playground_main()
//
//	//thread (m40_target_designator_main());
//
//	local long thread_id = thread(pelican_flyto_random_points());
//	sleep_s(5);
//	kill_thread(thread_id);
//
//end


script static void pelican_flyto_random_points()
	// loops flying to random points for pelican

	repeat 
	
		cs_vehicle_speed (squads_1, .01);
		
		dprint ("next noise loop");
		
		begin_random_count(1)
			cs_fly_to_and_face  (squads_1, 1, ps_e1m5_evac.p6, ps_e1m5_evac.p2);
			cs_fly_to_and_face  (squads_1, 1, ps_e1m5_evac.p7, ps_e1m5_evac.p2);
			cs_fly_to_and_face  (squads_1, 1, ps_e1m5_evac.p1, ps_e1m5_evac.p2);
		end
	until (1 == 0, 90); // set the time here to be whatever instead of 1/2 a second
	
end 


script static void scene_narrative_out()
	// set camera move for final shot
	
	cs_run_command_script (squads_1, command_script_ender);
	
	camera_control (true);
	camera_fov = 22;
	camera_pan (e1m5_out_01_1, e1m5_out_01_2, 110, 0, 1, 0, 1);
	sleep (30);
	cs_run_command_script (squads_1, cs_evac_leave);
	sleep (75);
	
	camera_fov = 55;
	camera_pan (e1m5_out_02_1, e1m5_out_02_2, 270, 0, 1, 140, 0);
	
	thread (f_music_e1_m5_6_end());
	
	sleep (240);
	fade_out (0, 0, 0, 30);
	
//	sleep (30);
//	camera_control (false);
//	fade_in (0, 0, 0, 1);
	
end


script static void e3_fluttercut_knight()
	// plays E3 Fluttercut Knight scene
	
	pup_play_show (e3_fluttercut_knight);
	
end


script command_script cs_e1m5_in_phantom()
	// flies-in phantom
	
	cs_ignore_obstacles (TRUE); 	
  //cs_vehicle_speed (.5); 
  
  //cs_fly_by (ps_e1m5_in_phantom.p0);
  cs_fly_by (ps_e1m5_in_phantom.p1);
  cs_fly_to_and_face  (ps_e1m5_in_phantom.p2, ps_e1m5_in_phantom.p3);
	
end

script command_script command_script_ender()
	print ("ended a command script");
end


// =============================================================================================================================
//======================================= SCURVE Ep 01 Mission 05 VO scripts ==================================================
// =============================================================================================================================


script static void vo_e1m5_intro()
	// play over intro
	
	// Miller : Crimson comms are open, Commander Palmer.
	dprint ("Miller: Crimson comms are open, Commander Palmer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00100'));

	// Palmer : Okay, Crimson.  The data you pulled out of the jungle ties into some earlier info on Covenant arhaeological teams.
	dprint ("Palmer: Okay, Crimson.  The data you pulled out of the jungle ties into some earlier info on Covenant arhaeological teams.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00200'));

	// Palmer : The Covies have found a needle in the Requiem haystack, and you're going to stop them from retrieving it.
	dprint ("Palmer: The Covies have found a needle in the Requiem haystack, and you're going to stop them from retrieving it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00300'));
	
end


script static void vo_e1m5_playstart()
	// as gameplay starts
	
	// Palmer : First things first, Crimson: eliminate anything that moves.
	dprint ("Palmer: First things first, Crimson: eliminate anything that moves.");
	
	hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP1_1);
	
//	800_00A_3_QV0A01_()_00001275b (cut 2) Time – 12:19:32:21 – 12:19:38:24
//	e1m5_playstart_00100
//	1:07
	sleep (41);
	
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100', NONE, 1);
	
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100'));
	
end

script static void vo_e1m5_playstart_test(short time)
	// as gameplay starts
	
	// Palmer : First things first, Crimson: eliminate anything that moves.
	dprint ("Palmer: First things first, Crimson: eliminate anything that moves.");
	
	hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP1_1);
	
//	800_00A_3_QV0A01_()_00001275b (cut 2) Time – 12:19:32:21 – 12:19:38:24
//	e1m5_playstart_00100
//	1:07
	sleep (time);
	
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100', NONE, 1);
	
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100'));
	
end


script static void vo_e1m5_waypoint01()
	// bring up waypoint
	
	// Miller : Enemy spotted at following waypoint, Crimson.
	dprint ("Miller: Enemy spotted at following waypoint, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_waypoint01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_waypoint01_00100'));
	
end


script static void vo_e1m5_turret1()
	// warn about first turret
	
	// Miller : Crimson, I advise you keep an eye on that turret.
	dprint ("Miller: Crimson, I advise you keep an eye on that turret.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_turret01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_turret01_00100'));
	
end


script static void vo_e1m5_doorspowerup()
	// if you went to doors first
	
	// Palmer : Miller, find Crimson a way through those doors.
	dprint ("Palmer: Miller, find Crimson a way through those doors.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00100'));

	// Miller : There appears to be a power source here.  Activating waypoint now.
	dprint ("Miller: There appears to be a power source here.  Activating waypoint now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00200'));
	
end


script static void vo_e1m5_doorsfirstswitch()
	// fires near switch if you went to doors first
	
	// Palmer : Power it up, Crimson.
	dprint ("Palmer: Power it up, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_doorsfirstswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_doorsfirstswitch_00100'));
	
end


script static void vo_e1m5_ifswitchfirst()
	// if you go to switch first
	
	// Miller : No idea what that switch does, Crimson.
	dprint ("Miller: No idea what that switch does, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifswitchfirst_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifswitchfirst_00100'));
	
end


script static void vo_e1m5_switchbeforedoors()
	// at the switch before going to doors	
	
	// Palmer : Crimson, pressing buttons at random might be bad for your health.
	dprint ("Palmer: Crimson, pressing buttons at random might be bad for your health.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00100'));

	// Miller : Actually, Commander,  I think Crimson's found a way to clear the path ahead of them.
	dprint ("Miller: Actually, Commander,  I think Crimson's found a way to clear the path ahead of them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00200'));
	
end


script static void vo_e1m5_spire1()
	// mention of first spire
	
	// Miller : Structural movement, Commander.
	dprint ("Miller: Structural movement, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spirelifts_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spirelifts_00100'));
	
end


script static void vo_e1m5_switchesid()
	// mark location of switches
	
	// Miller : Crimson, I'm marking a pair of power sources that just appeared.  Activating them should clear the path between you and our Covenant archaeologists.
	dprint ("Miller: Crimson, I'm marking a pair of power sources that just appeared.  Activating them should clear the path between you and our Covenant archaeologists.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_powerid_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_powerid_00100'));
	
end


script static void vo_e1m5_switch1()
	// first switch done
	
	// Miller : That's one.
	dprint ("Miller: That's one.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100'));
	
end


script static void vo_e1m5_switch2()
	// second switch done
	
	// Palmer : Got 'em both.  Miller?
	dprint ("Palmer: Got 'em both.  Miller?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00100'));

	// Miller : I was right.  Door's opening, Commander.
	dprint ("Miller: I was right.  Door's opening, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00200'));

	// Palmer : Move ahead to the next area, Crimson.
	dprint ("Palmer: Move ahead to the next area, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00300'));
	
end


script static void vo_e1m5_moveon()
	// tell players to move on
	
	// Dalton : Commander?
	dprint ("Dalton: Commander?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00100'));

	// Palmer : Go ahead, Dalton.
	dprint ("Palmer: Go ahead, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00200'));

	// Dalton : There's some serious anti-air activity happening in the area around Crimson.  We can't guarantee any kind of extraction.
	dprint ("Dalton: There's some serious anti-air activity happening in the area around Crimson.  We can't guarantee any kind of extraction.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00300'));

	// Palmer : Commander Palmer to Fireteam Castle.  You're on, Spartans.  Dalton's got targets for you.
	dprint ("Palmer: Commander Palmer to Fireteam Castle.  You're on, Spartans.  Dalton's got targets for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00400'));

	// Castle Leader : Affirmative, Commander.
	dprint ("Castle Leader: Affirmative, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00500'));
	
end


script static void vo_e1m5_moreshields()
	// more shields come up
	
	// Miller : More shields.
	dprint ("Miller: More shields.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100'));

	// Palmer : Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.
	dprint ("Palmer: Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.");
	hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP1_2);
	
//	800_00B_2_QV0A01_()_00001277b – Time – 12:28:06:29 to 12:28:12:15
//	e1m5_covshields_00200
//	1:17
	sleep (47);
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200'));

end


script static void vo_e1m5_moreshields_test(short time)
	// more shields come up
	
	// Miller : More shields.
	dprint ("Miller: More shields.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100'));

	// Palmer : Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.
	dprint ("Palmer: Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.");
	hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP1_2);
	
//	800_00B_2_QV0A01_()_00001277b – Time – 12:28:06:29 to 12:28:12:15
//	e1m5_covshields_00200
//	1:17
	sleep (time);
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200'));

end

script static void vo_e1m5_hackcontrols()
	// hack controls to take down shields
	
	// Miller : There are the controls to take down the shields.
	dprint ("Miller: There are the controls to take down the shields.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_hackcontrols_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_hackcontrols_00100'));
	
end


script static void vo_e1m5_didntwork()
	// that didnt work on the shields
	
	// Miller : Huh.  That should have worked.  Let me try...
	dprint ("Miller: Huh.  That should have worked.  Let me try...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00100'));

	// Miller : Commander, I can't crack the shields electronically.
	dprint ("Miller: Commander, I can't crack the shields electronically.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00200'));

	// Palmer : Crimson, give it a Spartan Hack.
	dprint ("Palmer: Crimson, give it a Spartan Hack.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00300'));

end


script static void vo_e1m5_spartanhack()
	// after "spartan hack"
	
	// Palmer : Works every time.
	dprint ("Palmer: Works every time.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spartanhack_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spartanhack_00100'));
	
end


script static void vo_e1m5_crawlers()
	//intro to crawlers
	
	// Palmer : Those aren't archaeologists, Miller.
	dprint ("Palmer: Those aren't archaeologists, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00100'));

	// Miller : No, Commander.  Those are Crawlers.
	dprint ("Miller: No, Commander.  Those are Crawlers.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00200'));

	// Palmer : Shut them down, Crimson.
	dprint ("Palmer: Shut them down, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300'));
	
end


script static void vo_e1m5_morecrawlers()
	//when more crawlers show up
	
	// Palmer : Holy.  Wow.  Be careful, Crimson.
	dprint ("Palmer: Holy.  Wow.  Be careful, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morecrawlers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morecrawlers_00100'));
	
end


script static void vo_e1m5_knights()
	//first knights
	
	// Miller : Commander Palmer!  Something new!
	dprint ("Miller: Commander Palmer!  Something new!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00100'));

	// Palmer : Promethean Knights.  Crimson, hese guys are a lot tougher than the Crawlers.  Concentrate your fire on single targets.  Take them down quick.
	dprint ("Palmer: Promethean Knights.  Crimson, hese guys are a lot tougher than the Crawlers.  Concentrate your fire on single targets.  Take them down quick.");
	
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00200'));
	
end


script static void vo_e1m5_foundcrew()
	// when you find the archaeologists
	
		// Palmer : Shut them down, Crimson.
	dprint ("Palmer: Shut them down, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300'));
	
	// Palmer : There's our archaeologists.  Shut them down, Crimson.
//	dprint ("Palmer: There's our archaeologists.  Shut them down, Crimson.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_foundcrew_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_foundcrew_00100'));
//	
end


script static void vo_e1m5_allclear()
	// when the archaeologists are taken out
	
	// Palmer : Promethean Knights are working alongside Covenant.  That's bad news.  Get a look at what they were guarding.
	dprint ("Palmer: Promethean Knights are working alongside Covenant.  That's bad news.  Get a look at what they were guarding.");
	hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP2_1);
	
//	800_00C_1_QV0A01_()_00001278b (last cut) Time – 12:30:26:00 to 12:30:35:00
//	e1m5_allclear_00100
//	1:23
	sleep (53);

	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100'));
	
end

script static void vo_e1m5_allclear_test(real time)
	// when the archaeologists are taken out
	
	// Palmer : Promethean Knights are working alongside Covenant.  That's bad news.  Get a look at what they were guarding.
	dprint ("Palmer: Promethean Knights are working alongside Covenant.  That's bad news.  Get a look at what they were guarding.");
	hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP2_1);
	
//	800_00C_1_QV0A01_()_00001278b (last cut) Time – 12:30:26:00 to 12:30:35:00
//	e1m5_allclear_00100
//	1:23
	sleep (time);

	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100'));
	
end


script static void vo_e1m5_artifact()
	// about the artifact
	
	sleep (120);
	// Miller : What is that?
	dprint ("Miller: What is that?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00100'));

	// Palmer : Don't care.  If the Covies wanted it this badly, I'm happy to get it --
	dprint ("Palmer: Don't care.  If the Covies wanted it this badly, I'm happy to get it --");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00200'));

end


script static void vo_e1m5_moreknights()
	//more Knights
	
	// Miller : Watch out!
	dprint ("Miller: Watch out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00100'));

	// Palmer : Defend the artifact, Crimson!
	dprint ("Palmer: Defend the artifact, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00200'));

	// Palmer : Dalton!  Crimson needs immediate evac!
	dprint ("Palmer: Dalton!  Crimson needs immediate evac!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00300'));

	// Dalton : Still working with Castle to take down air defenses, Commander!
	dprint ("Dalton: Still working with Castle to take down air defenses, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00400'));

	// Palmer : Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!
	dprint ("Palmer: Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00500'));
	
end

script static void vo_e1m5_artifact2()
	// Palmer : Defend the artifact, Crimson!
	dprint ("Palmer: Defend the artifact, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00400'));

	// Palmer : Dalton!  Crimson needs immediate evac!
	dprint ("Palmer: Dalton!  Crimson needs immediate evac!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00500'));

//	// Dalton : Still working with Castle to take down air defenses, Commander!
//	dprint ("Dalton: Still working with Castle to take down air defenses, Commander!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00600', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00600'));
//
//	// Palmer : Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!
//	dprint ("Palmer: Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00700', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00700'));
//
//	// Castle Leader : It's going to take a bit longer, Commander!  We're doing all we can!
//	dprint ("Castle Leader: It's going to take a bit longer, Commander!  We're doing all we can!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00800', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00800'));
//	
end


script static void vo_e1m5_morebads()
	// more bad guys show up
	
	// Miller : More bad guys, Commander!
	dprint ("Miller: More bad guys, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00100'));

	// Palmer : Castle?
	dprint ("Palmer: Castle?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00200'));

	// Castle Leader : We got it, Commander!
	dprint ("Castle Leader: We got it, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00300'));

	// Castle Leader : Fireteam Castle to Crimson.  The skies are clear.  Your ride is on the way.
	dprint ("Castle Leader: Fireteam Castle to Crimson.  The skies are clear.  Your ride is on the way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00400'));

	// Palmer : Dalton?  ETA on the Pelican?
	dprint ("Palmer: Dalton?  ETA on the Pelican?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00500'));

	// Dalton : Fast as they can, Commander.
	dprint ("Dalton: Fast as they can, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00600'));
	
end


script static void vo_e1m5_aircraftinbound()
	//warning of inbound aircraft
	
	// Miller : Commander, there's a LOT of Covenant aircraft inbound!
	dprint ("Miller: Commander, there's a LOT of Covenant aircraft inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00100'));

	// Palmer : Dalton!  Where the hell is that Pelican?!
	dprint ("Palmer: Dalton!  Where the hell is that Pelican?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00200'));

	
end


script static void vo_e1m5_pelican()
	// pelican onsite
	
	// Dalton : She's at the LZ, Commander.
	dprint ("Dalton: She's at the LZ, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00100'));

	// Palmer : About time!  Crimson!  Grab that artifact and get on the Pelican!
	dprint ("Palmer: About time!  Crimson!  Grab that artifact and get on the Pelican!");
	//hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP2_2);
	
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00200'));
	
end


script static void vo_e1m5_takeoff()
	// as pelican takes off
	
	// e1m5_Pilot : Crimson and artifact are onboard, and we are Infinity bound.
	dprint ("e1m5_Pilot: Crimson and artifact are onboard, and we are Infinity bound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00100'));

	// Palmer : Nice work, Crimson.  Come on home.
	dprint ("Palmer: Nice work, Crimson.  Come on home.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00200'));
	
end


// =============================================================================================================================
//====== SCURVE Ep 02 Mission 02 VO scripts ==================================================
// =============================================================================================================================


script static void vo_e2m2_intro()
	// during narrative in
	
	// Miller : Telemetry -- online.  Spartan tags -- online.  Comms -- online.
	dprint ("Miller: Telemetry -- online.  Spartan tags -- online.  Comms -- online.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00100'));

	// Miller : The Op is live, Commander Palmer.  Crimson is approaching deployment zone.
	dprint ("Miller: The Op is live, Commander Palmer.  Crimson is approaching deployment zone.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00200'));

	// Palmer : Any word from the science team on the ground?
	dprint ("Palmer: Any word from the science team on the ground?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00300'));

	// Miller : Not since their distress call.
	dprint ("Miller: Not since their distress call.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00400', NONE, 1);
	//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00400'));
	
end


script static void vo_e2m2_clearhill()
	// instruct to clear hill
	
	// Palmer : Crimson, secure the area.  Miller, try to raise the geeks.  If they're still alive, tell them help's on the way.
	dprint ("Palmer: Crimson, secure the area.  Miller, try to raise the geeks.  If they're still alive, tell them help's on the way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_clearhill_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_clearhill_00100'));
	
end


script static void vo_e2m2_hillcleared()
	// when hill has been cleared
	
	// Miller : Still no word from the science team, Commander.
	dprint ("Miller: Still no word from the science team, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00100'));

	// Palmer : Keep looking, Miller.
	dprint ("Palmer: Keep looking, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00200'));
	
end


script static void vo_e2m2_hitcomms()
	// instruct to take out Comms
	
	// Palmer : Crimson, I'm painting some targets for you.  Covie comm equipment.  Take it out.
	dprint ("Palmer: Crimson, I'm painting some targets for you.  Covie comm equipment.  Take it out.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hitcomms_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hitcomms_00100'));
	
end


script static void vo_e2m2_commsdown()
	// when comms are taken out
	
	// Miller : Commander, I've got a bead on the science team's last location.  Not seeing any movement, but there's UNSC gear nearby.
	dprint ("Miller: Commander, I've got a bead on the science team's last location.  Not seeing any movement, but there's UNSC gear nearby.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00100'));

	// Palmer : Get moving, Crimson.
	dprint ("Palmer: Get moving, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00200'));
	
end


script static void vo_e2m2_seeunscgear()
	// when you see the UNSC gear
	
	// Palmer : There's the UNSC gear.  You're getting close.
	dprint ("Palmer: There's the UNSC gear.  You're getting close.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_seeunscgear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_seeunscgear_00100'));
	
end


script static void vo_e2m2_baddies()
	// bad guys show up
	
	// Miller : There's an IFF tag nearby, but -- Look out!
	dprint ("Miller: There's an IFF tag nearby, but -- Look out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_baddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_baddies_00100'));
	
end


script static void vo_e2m2_nothere()
	// they're not here
	
	// Miller : Nobody's here.
	dprint ("Miller: Nobody's here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00100'));

	// Palmer : Crimson, collect that IFF tag and see what it recorded.
	dprint ("Palmer: Crimson, collect that IFF tag and see what it recorded.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00200'));
	
end


script static void vo_e2m2_ifftag()
	// play the IFF tag's recording_kill
	
	// e2m2_Scientist : They're coming this way!  Leave the gear and run!  Run!
	dprint ("e2m2_Scientist: They're coming this way!  Leave the gear and run!  Run!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_ifftag_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_ifftag_00100'));
	
end


script static void vo_e2m2_overthere()
	// instruct on next destination
	
	// Dalton : Commander Palmer, pardon the interruption.
	dprint ("Dalton: Commander Palmer, pardon the interruption.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00100'));

	// Palmer : Go ahead, Dalton.
	dprint ("Palmer: Go ahead, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00200'));

	// Dalton : I've got some eggheads on the resupply channel calling for help.  Transferring them over to you.
	dprint ("Dalton: I've got some eggheads on the resupply channel calling for help.  Transferring them over to you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00300'));

	// Rivera : Hello?!
	dprint ("Rivera: Hello?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00400'));

	// Palmer : Doctor --?
	dprint ("Palmer: Doctor --?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00500'));

	// Rivera : Doctor Rivera.  Infinity Science.  Thank god you're here!
	dprint ("Rivera: Doctor Rivera.  Infinity Science.  Thank god you're here!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00600'));

	// Palmer : We're not there yet, Doctor.
	dprint ("Palmer: We're not there yet, Doctor.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00700'));

	// Palmer : Miller, get Crimson a loc on the Doc Rivera's signal.
	dprint ("Palmer: Miller, get Crimson a loc on the Doc Rivera's signal.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00800', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00800'));

	// Miller : Already painting the waypoint for them, Commander.
	dprint ("Miller: Already painting the waypoint for them, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00900', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00900'));
	
end


script static void vo_e2m2_shieldsblock()
	// shields blocking path
	
	// Palmer : Crimson, have a look around.  The shield generator has to be around there somewhere.
	dprint ("Palmer: Crimson, have a look around.  The shield generator has to be around there somewhere.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shieldsblock_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shieldsblock_00100'));
	
end


script static void vo_e2m2_closer()
	// getting closer
	
	// Palmer : Doctor Rivera?  Status?
	dprint ("Palmer: Doctor Rivera?  Status?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00100'));

	// Rivera : We're holed up.  Turned some of their own shields against them.  But I can't imagine we're safe for too long.
	dprint ("Rivera: We're holed up.  Turned some of their own shields against them.  But I can't imagine we're safe for too long.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00200'));
	
end


script static void vo_e2m2_lava()
	// watch your step
	
	// Palmer : Watch your step, Crimson.
	dprint ("Palmer: Watch your step, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_lava_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_lava_00100'));
	
end


script static void vo_e2m2_keepbarrier()
	// tell scientists to keep up barrier
	
	// Rivera : I see Spartans!
	dprint ("Rivera: I see Spartans!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00100'));

	// Palmer : Stay put Doctor.  Let the professionals clear the area.
	dprint ("Palmer: Stay put Doctor.  Let the professionals clear the area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00200'));
	
end


script static void vo_e2m2_allclear()
	// all clear
	
	// Miller : That's the last of them, Commander.
	dprint ("Miller: That's the last of them, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00100'));

	// Palmer : Nice work, Crimson.  Doctor Rivera, you can take the shields down now.
	dprint ("Palmer: Nice work, Crimson.  Doctor Rivera, you can take the shields down now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00200'));

	// Rivera : Umm.  Yes.  Hang on.  We were rather lucky to figure out how to turn them on in the first place.  Hrmmm.
	dprint ("Rivera: Umm.  Yes.  Hang on.  We were rather lucky to figure out how to turn them on in the first place.  Hrmmm.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00300'));
	
end