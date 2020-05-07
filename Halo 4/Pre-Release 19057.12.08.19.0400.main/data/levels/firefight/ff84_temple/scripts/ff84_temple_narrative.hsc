//=============================================================================================================================
//============================================ TEMPLE NARRATIVE SCRIPT ========================================================
//=============================================================================================================================

global boolean e1m4_narrative_is_on = FALSE;
global boolean b_e5m3_nin_done = false;
global boolean e5m2_narrative_is_on = FALSE;

// behold, the greatest narrative script ever to pass through the halls of 343...or 550...or whatever...it will be good anyway.

script startup sparops_e01_m02_main()
	
	dprint (":::  NARRATIVE SCRIPT  :::");
	
end


script static void play_in_scene()
	//fires e1 m2 Narrative In scene
//	pup_play_show(e1_m2_narrative_in);
	sleep_s(15);
	firefight_mode_set_player_spawn_suppressed(false);
	b_wait_for_narrative_e1_m4 = FALSE;
end


script static void ex1()
	camera_control (true);
	camera_fov = 90;
	
	fade_in (0, 0, 0, 150);
	
	wake (vo_e1m4_intro);
	
	camera_pan (camin_01_1, camin_01_2, 300, 0, 1, 0, 1);
	sleep (310);
	
	camera_fov = 55;
	camera_pan (camin_02_1, camin_02_2, 300, 0, 1, 0, 1);
	sleep (310);
	
	camera_pan (camin_03_1, camin_03_2, 300, 0, 1, 0, 1);
	sleep (310);
	
	camera_fov = 78;
	camera_control (false);
	fade_out (0, 0, 0, 15);
end


script static void ex2()

	ai_erase (squads_knight_out);
	ai_place (squads_knight_out);
	
	pup_play_show(e1m4_narrative_out);

end


script static void ex3()

	ai_erase (sq_e2m5_out_marines);
	ai_place (sq_e2m5_out_marines);
	ai_erase (sq_e2m5_out_pelican1);
	ai_place (sq_e2m5_out_pelican1);
	
	pup_play_show(e2m5_narrative_out);

end


script command_script cs_e5m2_intro()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (.5); 
	
	cs_fly_by (ps_e5m2_pelican.p0);
	
	sleep (60);
	
	cs_vehicle_speed (.3); 
	cs_fly_to_and_face (ps_e5m2_pelican.p1, ps_e5m2_pelican.p2);	
end


script static void e5m2_narrative_in()
	// plays e5 m2 narrative in scene
	
	fade_in (0, 0, 0, 90);
	camera_control (true);
	
	camera_fov = 22;
	camera_pan (e5m2_in_01_1, e5m2_in_01_2, 200, 0, 1, 0, 1);
	sleep (30);
	
	ai_place (sq_e5m2_in_pelican1);
	sleep (150);
	
	camera_fov = 44;
	camera_pan (e5m2_in_02_1, e5m2_in_02_2, 250, 0, 1, 0, 1);
	sleep (200);
	
	fade_out (0, 0, 0, 30);
	sleep (30);
	
	fade_in (0, 0, 0, 1);
	camera_fov = 78;
	camera_control (false);
	
	ai_erase (sq_e5m2_in_pelican1);
	e5m2_narrativein_done = TRUE;
end


script static void e1m4_narrative_in()
	// Ep 1 Mission 2 narrative in

	camera_control (true);
	camera_fov = 90;
	
	fade_in (0, 0, 0, 150);
	
	wake (vo_e1m4_intro);
	
	camera_pan (camin_01_1, camin_01_2, 270, 0, 1, 200, 0);
	sleep(260);;
	
	camera_fov = 55;
	camera_pan (camin_02_1, camin_02_2, 160, 0, 1, 0, 1);
	sleep (150);
	
	camera_pan (camin_03_1, camin_03_2, 300, 0, 1, 0, 1);
	sleep (160);
	
	fade_out (0, 0, 0, 60);
	sleep (60);
	
	camera_fov = 78;
	camera_control (false);
	b_wait_for_narrative_e1_m4 = FALSE;
end


script static void e2m5_narrative_in()
	// Ep 2 Mission 5 narrative in
	
	camera_control (true);

	fade_in (0, 0, 0, 90);
	
	camera_fov = 44;
	camera_pan (e2m5_in_01_1, e2m5_in_01_2, 300, 0, 1, 0, 1);
	sleep (150);
	
	camera_fov = 55;
	camera_pan (e2m5_in_02_1, e2m5_in_02_2, 300, 0, 1, 0, 1);
	sleep (110);
	
	camera_fov = 55;
	camera_pan (e2m5_in_03_1, e2m5_in_03_2, 190, 0, 1, 100, 0);
	sleep (130);
	
	fade_out (0, 0, 0, 60);
	sleep (61);
	
	camera_fov = 78;
	camera_control (false);
	fade_in (0, 0, 0, 1);
	
end


//=============================================================================================================================
//====================================== TEMPLE Ep 01 Mission 04 VO scripts ===================================================
//=============================================================================================================================


script dormant vo_e1m4_intro()  // called
	//play vo over intro
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Comms are open, Commander Palmer.
	dprint ("Miller: Comms are open, Commander Palmer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Thanks Miller.
	dprint ("Palmer: Thanks Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, good work showing Majestic Team how it's done.  Demarco'll be mad about that for days.
	dprint ("Palmer: Crimson, good work showing Majestic Team how it's done.  Demarco'll be mad about that for days.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I need a fireteam I can depend on and until you prove otherwise, you're it.  I'll be on your comms a bit more than usual, but Miller's still your team's handler.
	dprint ("Palmer: I need a fireteam I can depend on and until you prove otherwise, you're it.  I'll be on your comms a bit more than usual, but Miller's still your team's handler.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Infinity Science has identified a jungle structure they want to see up close.  Initial drones say the place is deserted, but I want boots on the ground before the egg heads go poking at every shiny object they find.
	dprint ("Palmer: Infinity Science has identified a jungle structure they want to see up close.  Initial drones say the place is deserted, but I want boots on the ground before the egg heads go poking at every shiny object they find.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_intro_00500'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_begin() //called
	// as gameplay begins
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	// PIP
	hud_play_pip_from_tag (bink\spops\ep1_m4_1_60);
		
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Looking all quiet, Crimson.  I think you have the place to yourselves.
	dprint ("Palmer: Looking all quiet, Crimson.  I think you have the place to yourselves.");
	
	// subtitles
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00100_pip'));
	
	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander?  Power fluctuation at the back corner of the facility.
	dprint ("Miller: Commander?  Power fluctuation at the back corner of the facility.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Somebody's been here recently, and they left the lights on.
	dprint ("Miller: Somebody's been here recently, and they left the lights on.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Let's have a look, Crimson.
	dprint ("Palmer: Let's have a look, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Marking a waypoint.
	dprint ("Miller: Marking a waypoint.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_playstart_00500'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end


script dormant vo_e1m4_crawlers() //called
	// first sight of Crawlers
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : This is why I didn't let Science Team go in there alone.  Pop 'em and move on.
	dprint ("Palmer: This is why I didn't let Science Team go in there alone.  Pop 'em and move on.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_firstcrawlers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_firstcrawlers_00100'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_1stpromethean()  //out now
	//no longer used
	thread (story_blurb_add("vo", "script no longer used"));
end

script dormant vo_e1m4_reachstarmap() //called
	// reached star map
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, Crimson has reached the source of the power fluctuations.
	dprint ("Miller: Commander, Crimson has reached the source of the power fluctuations.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_reachmap_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_reachmap_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : That's a star map. See if you can access the data.
	dprint ("Palmer: That's a star map. See if you can access the data.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_reachmap_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_reachmap_00200'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_usestarmap() //called
	// interact with star map
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Uplink established.  Pulling data now.
	dprint ("Miller: Uplink established.  Pulling data now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_mapused_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_mapused_00100'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_knightspawn()
	// knights spawn in
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson!  Heads up!  Knights!
	dprint ("Palmer: Crimson!  Heads up!  Knights!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_knights01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_knights01_00100'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_intro_knightspawn() //called
	// knights spawn in
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson! Watch out!
	dprint("Miller: Crimson! Watch out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_knights01_00200', NONE, 1);
	sleep(sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_knights01_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Knights are nasty customers, but you can deal with them. Keep them front and center, and don’t stop shooting until they pop.
	dprint ("Palmer: Knights are nasty customers, but you can deal with them. Keep them front and center, and don’t stop shooting until they pop.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_knights01_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_knights01_00300'));
	
	end_radio_transmission();

	e1m4_narrative_is_on = FALSE;
end


script dormant vo_e1m4_returntoextract() //called
	// data is extracted, go to extract point
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, we pulled all the data the map had to offer.
	dprint ("Miller: Commander, we pulled all the data the map had to offer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_backtoevac_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_backtoevac_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	
	sleep (50);
	
	// PIP
	hud_play_pip_from_tag (bink\spops\ep1_m4_2_60);
	
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	// Palmer : Okay, Crimson.  This was only ever recon.  I'm pulling you out until Science Team can review the data.
	// Palmer : Miller, mark the extraction point.
	dprint ("Palmer: Okay, Crimson.  This was only ever recon.  I'm pulling you out until Science Team can review the data.");
	dprint ("Palmer: Miller, mark the extraction point.");
	
	
	// subtitles
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_backtoevac_00200', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_backtoevac_00300', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_backtoevac_00200_pip'));
		
	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	
	sleep_s(0.5);
	b_end_player_goal = TRUE;
	sleep_s(1);
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Waypoint's up, Commander.
	dprint ("Miller: Waypoint's up, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_backtoevac_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_backtoevac_00400'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_watcherwarning()
	// watcher warning
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander!  Watchers on station!
	dprint ("Miller: Commander!  Watchers on station!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_watcherwarn01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_watcherwarn01_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Pop those flyers quick, Crimson, or they'll resurrect their buddies.
	dprint ("Palmer: Pop those flyers quick, Crimson, or they'll resurrect their buddies.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_watcherwarn01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_watcherwarn01_00200'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_extractblocked() //called
	// path to extract blocked
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Spartan Miller!  Where did Crimson's egress just disappear to?
	dprint ("Palmer: Spartan Miller!  Where did Crimson's egress just disappear to?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander, the building's walls are moving!  Path to extraction is blocked!
	dprint ("Miller: Commander, the building's walls are moving!  Path to extraction is blocked!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Find them a way out, Miller!
	dprint ("Palmer: Find them a way out, Miller!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I'm trying, Commander!
	dprint ("Miller: I'm trying, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Make it quick, Miller!
	dprint ("Palmer: Make it quick, Miller!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00500'));
	
	end_radio_transmission();

//	// Palmer : Crimson, hold position until Miller can --
//	dprint ("Palmer: Crimson, hold position until Miller can --");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00600', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00600'));

	e1m4_narrative_is_on = FALSE;
end


script dormant vo_e1m4_extractblocked_2()
	// Miller : I found a back door!  Marking the waypoint now!
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, I think I’ve found the door controls for the door. Marking the waypoint now!
	dprint ("Miller: Commander, I think I’ve found the door controls for the door. Marking the waypoint now!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00700'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	sleep_s(1);
	b_end_player_goal = TRUE;
	sleep_s(1);
	
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Move it, Crimson!
	dprint ("Palmer: Move it, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00800', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00800'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_clean_area_out()
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : That did it! Path is clear.
	dprint ("Miller: That did it! Path is clear.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00900', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_exitblocked_00900'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Hold up Crimson, that place still isn’t safe for Science-types.
	dprint ("Palmer: Hold up Crimson, that place still isn’t safe for Science-types.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_hangon_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_hangon_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Clear the area of all hostiles so those eggheads don't get hurt.
	dprint ("Palmer: Clear the area of all hostiles so those eggheads don't get hurt.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_hangon_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_hangon_00200'));
	
	end_radio_transmission();

	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_exit_temple()
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : No more hostiles on radar.
	dprint ("Miller: No more hostiles on radar.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_everyone_dead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_everyone_dead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Everything’s baby-proofed? Good stuff.
	dprint ("Palmer: Everything’s baby-proofed? Good stuff.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_everyone_dead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_everyone_dead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Dalton.  I need a ride for Crimson at their new extraction location.
	dprint ("Palmer: Dalton.  I need a ride for Crimson at their new extraction location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Already on it, Commander.  Pelican is on station above the facility.  Just need to tell them where to land.
	dprint ("Dalton: Already on it, Commander.  Pelican is on station above the facility.  Just need to tell them where to land.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00200'));
	
	end_radio_transmission();

	e1m4_narrative_is_on = FALSE;
end


script dormant vo_e1m4_backdoor()
	// you should use back door
	thread (story_blurb_add("vo", "no longer used"));
end


script dormant vo_e1m4_newexit()
	// alert pelican about new exit
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Dalton.  I need a ride for Crimson at their new extraction location.
	dprint ("Palmer: Dalton.  I need a ride for Crimson at their new extraction location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Already on it, Commander.  Pelican is on station above the facility.  Just need to tell them where to land.
	dprint ("Dalton: Already on it, Commander.  Pelican is on station above the facility.  Just need to tell them where to land.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_newwaypoint_00200'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end


script dormant vo_e1m4_switch()
	// told to flip switch
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller, that doesn't look like a clear path to me.
	dprint ("Palmer: Miller, that doesn't look like a clear path to me.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_theswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_theswitch_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander, telemetry shows --  hang on.  That wall shouldn't be there.  Crimson, there has to be some way through.
	dprint ("Miller: Commander, telemetry shows --  hang on.  That wall shouldn't be there.  Crimson, there has to be some way through.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_theswitch_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_theswitch_00200'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end


script dormant vo_e1m4_switchflipped() //called
	// switch flipped
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Dalton, Crimson's near their extraction point.
	dprint ("Palmer: Dalton, Crimson's near their extraction point.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_switchflipped_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_switchflipped_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Got it, Commander.  Pelican's inbound.  On the ground in thirty.
	dprint ("Dalton: Got it, Commander.  Pelican's inbound.  On the ground in thirty.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_switchflipped_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_switchflipped_00200'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end

script dormant vo_e1m4_outro()
	// upon completion condition met
	sleep_until (e1m4_narrative_is_on == FALSE);
	e1m4_narrative_is_on = TRUE;
	
//	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
//	
//	// Dalton : Crimson's onboard Pelican, and headed home, Commander.
//	dprint ("Dalton: Crimson's onboard Pelican, and headed home, Commander.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00100'));
//
//	cui_hud_hide_radio_transmission_hud();
//	
//	sleep (50);
	
	// PIP
	start_radio_transmission( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep1_m4_3_60);
	
	// Palmer : Nice work, Crimson.
	dprint ("Palmer: Nice work, Crimson.");
	// subtitles
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00200_pip'));
	
	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Miller, get that data over to Science Team and see what they can get from it.
	dprint ("Palmer: Miller, get that data over to Science Team and see what they can get from it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : It'd better be something worthwhile.
	dprint ("Palmer: It'd better be something worthwhile.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_04\e1m4_missionover_00400'));
	
	end_radio_transmission();
	
	e1m4_narrative_is_on = FALSE;
end


//=============================================================================================================================
//====================================== TEMPLE Ep 05 Mission 02 VO scripts ===================================================
//=============================================================================================================================


script static void vo_e5m2_intro()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "roland_transmission_name" );
	
	// Roland : Okay, Crimson!  How's it going?  Roland here.
	dprint ("Roland: Okay, Crimson!  How's it going?  Roland here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00100'));
	
	sleep (10);

	// Roland : This whole Spartan Ops thing is pretty darn exciting!  Although this mission here, probably not so much.  Standing around, mostly, if I had to guess.
	dprint ("Roland: This whole Spartan Ops thing is pretty darn exciting!  Although this mission here, probably not so much.  Standing around, mostly, if I had to guess.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00200'));
	
	sleep (10);

	// Roland : Anyway, today you're helping some science types study science.  Or something.
	dprint ("Roland: Anyway, today you're helping some science types study science.  Or something.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00300'));
	
	sleep_until (b_players_are_alive(), 1);
	
	sleep (15);
	
	// Roland : They asked for you to come hang out while they poke at portals.  So get to it.
	dprint ("Roland: They asked for you to come hang out while they poke at portals.  So get to it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_intro_00400'));
	
	end_radio_transmission();
	
	f_blip_flag (fl_e5m1_stage_flag01, default);
	
	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_playstart()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );

	// Doctor Boyd : Ah!  Hello!  Good morning.  Doctor Boyd here.  I'll be up shortly.  For now, speak with Doctor Ruiz--
	dprint ("Doctor Boyd: Ah!  Hello!  Good morning.  Doctor Boyd here.  I'll be up shortly.  For now, speak with Doctor Ruiz--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_playstart_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_playstart_00100'));
	
	sleep (10);

	// e5m2_scientist : [horrified scream as he's ambushed and killed]
	dprint ("e5m2_scientist: [horrified scream as he's ambushed and killed]");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_playstart_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_playstart_00200'));
	
	end_radio_transmission();
	
	e5m2_youscurred = TRUE;
	thread (vo_e5m2_baddies());
end


script static void vo_e5m2_baddies()
	
	sleep (30);
	start_radio_transmission( "roland_transmission_name" );
	
	// Roland : Whoa, Crimson!  Be careful there!
	dprint ("Roland: Whoa, Crimson!  Be careful there!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_baddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_baddies_00100'));
	
	end_radio_transmission();
	
	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_afterstart()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
//	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//	// Miller : I'm back.  Roland?  What's going on?
//	dprint ("Miller: I'm back.  Roland?  What's going on?");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_afterstart_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_afterstart_00100'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
//
//	// Roland : Crimson are doing what they're trained to do.  I don't know why you always get so worked up about it.  They're very professional.
//	dprint ("Roland: Crimson are doing what they're trained to do.  I don't know why you always get so worked up about it.  They're very professional.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_afterstart_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_afterstart_00200'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	
//	sleep (10);
	
	// PIP
	
	start_radio_transmission( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep5_m2_1_60);
	
	// Miller : Crimson.  I'm back online.  Still can't get hold of Commander Palmer, she's got her comms turned off.
	dprint ("Miller: Crimson.  I'm back online.  Still can't get hold of Commander Palmer, she's got her comms turned off.");
	// subtitle
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_afterstart_00300', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_afterstart_00300_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_givecover()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "e5m3_scientist_3_transmission_name" );

	// e2m5_scientist_01 : [scared yell]
	dprint ("e2m5_scientist_01: [scared yell]");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_findscientist_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_findscientist_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "e5m3_scientist_1_transmission_name" );

	// e2m5_scientist_02 : HELP!
	dprint ("e2m5_scientist_02: HELP!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_findscientist_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_findscientist_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Crimson! Give cover to the Science Team!
	dprint ("Miller: Crimson! Give cover to the Science Team!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_defendscientists_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_defendscientists_00100'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end

script static void vo_e5m2_knights_callout01()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : Knights! Crimson! Be careful!
	dprint ("Miller: Knights! Crimson! Be careful!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_5_00100'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_crawlers_callout()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watch out for the Crawlers. They're everywhere.
	dprint ("Miller: Watch out for the Crawlers. They're everywhere.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_4_00100'));
	
	end_radio_transmission();
	
	e5m2_narrative_is_on = FALSE;
end

script static void vo_e5m2_watchers()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : Watchers in your area.
	dprint ("Miller: Watchers in your area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_watchers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_watchers_00100'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_whatnow()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;

	start_radio_transmission( "boyd_transmission_name" );

	// Doctor Boyd : Umm…hello?  Can anyone hear me?
	dprint ("Doctor Boyd: Umm…hello?  Can anyone hear me?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Doctor Boyd!  You're still alive!
	dprint ("Miller: Doctor Boyd!  You're still alive!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : As soon as they attack started, I ran to the safe room!
	dprint ("Doctor Boyd: As soon as they attack started, I ran to the safe room!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00300'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_sittightdoctor()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Sit tight, Doctor. We’ll will be with you shortly. Crimson, clear the area a-sap.
	dprint ("Miller: Sit tight, Doctor. We’ll will be with you shortly. Crimson, clear the area a-sap.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_whatnow_00500'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_useswitch()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	sleep (30 * 3);
	
	start_radio_transmission( "boyd_transmission_name" );

	// Doctor Boyd : Doctor Ruiz identified the device that allows portals to open.  He was about to shut it down, but the attack--
	dprint ("Doctor Boyd: Doctor Ruiz identified the device that allows portals to open.  He was about to shut it down, but the attack--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Can you tell us where the device is, Doctor?
	dprint ("Miller: Can you tell us where the device is, Doctor?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Wha?  Yes.  It's right-- right over…there.  C-Can you see that?
	dprint ("Doctor Boyd: Wha?  Yes.  It's right-- right over…there.  C-Can you see that?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : You bet.  Sit tight, we'll have this taken care of shortly.
	dprint ("Miller: You bet.  Sit tight, we'll have this taken care of shortly.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_useswitch_00400'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_thatswitch()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : There's the device, Crimson.  If the Doctor's right, deactivating it should stop the Promethean assault.
	dprint ("Miller: There's the device, Crimson.  If the Doctor's right, deactivating it should stop the Promethean assault.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_thatswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_thatswitch_00100'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_switchnow()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson!  Come on!  Deactivate the portal device already.
	dprint ("Miller: Crimson!  Come on!  Deactivate the portal device already.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_switchnow_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_switchnow_00100'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_deactivated()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Doctor Boyd, the device has been -- wait.  That doesn't look deactivated to me.
	dprint ("Miller: Doctor Boyd, the device has been -- wait.  That doesn't look deactivated to me.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_deactivated_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_deactivated_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Well Doctor Ruiz didn't explain how he was going to deactivate it.
	dprint ("Doctor Boyd: Well Doctor Ruiz didn't explain how he was going to deactivate it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_deactivated_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_deactivated_00200'));
	
	end_radio_transmission();

	sleep (30 * 5);
	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_blowitup()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	// PIP
	start_radio_transmission( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep5_m2_2_60);
	
	// Miller : Crimson, target the device.  I'm pretty sure Commander Palmer would consider deactivating it and busting it to be the same thing.
	dprint ("Miller: Crimson, target the device.  I'm pretty sure Commander Palmer would consider deactivating it and busting it to be the same thing.");
	// subtitle
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_blowitup_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_blowitup_00100_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_ifstillbaddies()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Looks like Doctor Boyd was right.  I'm not seeing any new blips since you destroyed the device.  Clean up the area while I sort what's next.
	dprint ("Miller: Looks like Doctor Boyd was right.  I'm not seeing any new blips since you destroyed the device.  Clean up the area while I sort what's next.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_ifstillbaddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_ifstillbaddies_00100'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_ifallclear
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;

	// PIP
	start_radio_transmission( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep5_m2_3_60);
	
	// Miller : Well done and all clear.  Crimson, you'll remain on station for now.  I'm sending some reinforcements, but I feel better about you staying there until we know for certain everything is locked down tight.
	dprint ("Miller: Well done and all clear.  Crimson, you'll remain on station for now.  I'm sending some reinforcements, but I feel better about you staying there until we know for certain everything is locked down tight.");
	// subtitle
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_ifallclear_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_ifallclear_00100_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_ifalldead()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );

	// Doctor Boyd : You let them die?!
	dprint ("Doctor Boyd: You let them die?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_dead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_dead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : It’s not like that we didn't try—
	dprint ("Miller: It’s not like that we didn't try—");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_dead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_dead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : I’ll tell you what it’s like! My colleagues are dead!
	dprint ("Doctor Boyd: I’ll tell you what it’s like! My colleagues are dead!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_dead_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_dead_00300'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_ifsomedead()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );

	// Doctor Boyd : You let them die…
	dprint ("Doctor Boyd: You let them die…");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_somescientists_dead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_somescientists_dead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Nobody LET anybody die.
	dprint ("Miller: Nobody LET anybody die.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_somescientists_dead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_somescientists_dead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : I’m sorry. I didn’t-- I didn't mean – I’m glad your people saved what lives they could. Thank you.
	dprint ("Doctor Boyd: I’m sorry. I didn’t-- I didn't mean – I’m glad your people saved what lives they could. Thank you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_somescientists_dead_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_somescientists_dead_00300'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


script static void vo_e5m2_ifnonedead()
	sleep_until (e5m2_narrative_is_on == FALSE);
	e5m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );

	// Doctor Boyd : You saved everyone?
	dprint ("Doctor Boyd: You saved everyone?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_alive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_alive_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Crimson did, yes. Happy to help.
	dprint ("Miller: Crimson did, yes. Happy to help.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_alive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_alive_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Thank you so much! Fantastic work!
	dprint ("Doctor Boyd: Thank you so much! Fantastic work!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_alive_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_02\e5m2_allscientists_alive_00300'));
	
	end_radio_transmission();

	e5m2_narrative_is_on = FALSE;
end


//=============================================================================================================================
//====================================== TEMPLE Ep 05 Mission 03 VO scripts ===================================================
//=============================================================================================================================


script dormant vo_e5m3_intro()

start_radio_transmission( "miller_transmission_name" );

// Miller : Crimson, Marines from Warbird Company are touching down on --
dprint ("Miller: Crimson, Marines from Warbird Company are touching down on --");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Miller, heads up!  You've got a Covenant cruiser inbound on Crimson's location.
dprint ("Dalton: Miller, heads up!  You've got a Covenant cruiser inbound on Crimson's location.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Sonuva -- Thanks, Dalton.
dprint ("Miller: Sonuva -- Thanks, Dalton.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Crimson, looks like the Covies are mad we broke their portal toy.  Get ready to repel invaders.
dprint ("Miller: Crimson, looks like the Covies are mad we broke their portal toy.  Get ready to repel invaders.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_intro_00400'));

end_radio_transmission();

thread(e5m3_intro_callback());		//TJP 

end


script dormant vo_e5m3_shank()

//// e5m3_marine1 : Infinity, this is Warbird Company. You can relax, the Marines are here. We got this place on lockdown, so go ahead and bring your Spartans on home.
//dprint ("e5m3_marine1: Infinity, this is Warbird Company. You can relax, the Marines are here. We got this place on lockdown, so go ahead and bring your Spartans on home.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_narr_in_00100', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_narr_in_00100'));

//// e5m3_marine2 : Wha—AAAAAAHHH!
//dprint ("e5m3_marine2: Wha—AAAAAAHHH!");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_shank_00200', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_shank_00200'));

end_radio_transmission();

end


script dormant vo_e5m3_fightstart()

start_radio_transmission( "miller_transmission_name" );

// Miller : Dalton, what can you do for backup?
dprint ("Miller: Dalton, what can you do for backup?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_fightstart_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_fightstart_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Not a lot with the air support they're bringing to the party.
dprint ("Dalton: Not a lot with the air support they're bringing to the party.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_fightstart_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_fightstart_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Is that a -- Oh no.  Spartans, be advised, you've got a Covenant Cruiser on your position.
dprint ("Miller: Is that a -- Oh no.  Spartans, be advised, you've got a Covenant Cruiser on your position.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_fightstart_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_fightstart_00300'));

end_radio_transmission();

thread(e5m3_fightstart_callback());		//TJP 

end


script dormant vo_e5m3_marinehelp()

start_radio_transmission( "e5m3_marine_4_transmission_name" );

// Swamp Marine 4 : Multiple contacts!
dprint ("Swamp Marine 4: Multiple contacts!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\m60_soundstory_00113', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\m60_soundstory_00113'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "e5m3_marine_5_transmission_name" );

// Swamp Marine 5 : 12 o'clock! 4 o'clock! 9 o'clock!
dprint ("Swamp Marine 5: 12 o'clock! 4 o'clock! 9 o'clock!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\m60_soundstory_00114', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\m60_soundstory_00114'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Aw, hell.  Crimson!  Double time it to Warbird's position!
dprint ("Miller: Aw, hell.  Crimson!  Double time it to Warbird's position!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinehelp_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinehelp_00200'));

end_radio_transmission();

thread(e5m3_marinehelp_callback());		//TJP 

end


script static void vo_e5m3_shieldblock()

start_radio_transmission( "miller_transmission_name" );

// Miller : Warbird, Infinity.  There's a shield system between Crimson and you.
dprint ("Miller: Warbird, Infinity.  There's a shield system between Crimson and you.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_shieldblock_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_shieldblock_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "e5m3_marine_3_transmission_name" );

// e5m3_marine3 : That shield's Covenant-deployed, sir.  We can't bring it down.  They've boxed us in!
dprint ("e5m3_marine3: That shield's Covenant-deployed, sir.  We can't bring it down.  They've boxed us in!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_shieldblock_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_shieldblock_00200'));

end_radio_transmission();

thread(e5m3_shieldblock_callback());	//TJP

end


script dormant vo_e5m3_hackshields()

start_radio_transmission( "miller_transmission_name" );

// Miller : Roland, got any ideas on those Covenant shields?
dprint ("Miller: Roland, got any ideas on those Covenant shields?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00100'));

//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

//// Roland : Turn them off?
//dprint ("Roland: Turn them off?");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00200', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00200'));
//
//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//// Miller : Nobody seems real sure how to do that, Roland.
//dprint ("Miller: Nobody seems real sure how to do that, Roland.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00300', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00300'));
//
//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
//
//// Roland : Ah!  I see…hmm…Well, Crimson's armor sensors show the shields operating on a frequency in the upper --
//dprint ("Roland: Ah!  I see…hmm…Well, Crimson's armor sensors show the shields operating on a frequency in the upper --");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00400', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00400'));
//
//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//// Miller : Can you do it or not?!
//dprint ("Miller: Can you do it or not?!");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00500', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00500'));
//
//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

//TJP - disabled for brevity
//// Roland : Somebody's been hanging around Commander Palmer too long.
//dprint ("Roland: Somebody's been hanging around Commander Palmer too long.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00600', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00600'));
//
//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//TJP - disabled for brevity
//// Miller : I'll take that as a compliment.  Can you lower the shields?
//dprint ("Miller: I'll take that as a compliment.  Can you lower the shields?");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00700', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00700'));

//TJP - disabled the following line. It's an alt. The subsequent line is the first choice.
// Roland : Yep.  It's a simple enough hack to bring those down.  There you go.
//dprint ("Roland: Yep.  It's a simple enough hack to bring those down.  There you go.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00800', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00800'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

// Roland : Yep.  It's a simple enough hack to make them vulnerable to small arms fire.
dprint ("Roland: Yep.  It's a simple enough hack to make them vulnerable to small arms fire.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00800_alt', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00800_alt'));

cui_hud_hide_radio_transmission_hud();
sleep (60);
cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

thread(e5m3_hackshields_callback());	//TJP

// Roland : There you go Crimson; blast away.
dprint ("Roland: There you go Crimson; blast away.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00900_alt', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hackshields_00900_alt'));

end_radio_transmission();

end


script dormant vo_e5m3_marinefight()

start_radio_transmission( "e5m3_marine_3_transmission_name" );

// e5m3_marine3 : Oh, man, Spartans!  Is it ever good to see you!
dprint ("e5m3_marine3: Oh, man, Spartans!  Is it ever good to see you!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinefight_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinefight_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

// Roland : Covenant comm chatter about the "Silent Blade" operating in this area.  Special Ops team, apparently.
dprint ("Roland: Covenant comm chatter about the 'Silent Blade' operating in this area.  Special Ops team, apparently.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinefight_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinefight_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Keep your eyes sharp, Crimson.  Heavy active camo use by Covenant forces.
dprint ("Miller: Keep your eyes sharp, Crimson.  Heavy active camo use by Covenant forces.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinefight_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_marinefight_00300'));

end_radio_transmission();

thread(e5m3_marinefight_callback());	//TJP

end


script dormant vo_e5m3_carrier()		// tjp - 8-12-12 - no longer being called, per Josh's request

start_radio_transmission( "miller_transmission_name" );

// Miller : I need to remove a carrier from the sky over Crimson's location.
dprint ("Miller: I need to remove a carrier from the sky over Crimson's location.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_carrier_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_carrier_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : I'm sorry, man.  Carriers are tied up outside the shell.  I've got nobody in there.
dprint ("Dalton: I'm sorry, man.  Carriers are tied up outside the shell.  I've got nobody in there.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_carrier_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_carrier_00200'));

end_radio_transmission();

thread(e5m3_carrier_callback());	//TJP

end


script dormant vo_e5m3_millerplan()

start_radio_transmission( "miller_transmission_name" );

// Miller : Fireteam Shadow, this is Spartan Miller in Ops.  I'm filling in for Commander Palmer, so apologies to your team's handler, uh, Spartan Carmichael, for going over his head here. 
dprint ("Miller: Fireteam Shadow, this is Spartan Miller in Ops.  I'm filling in for Commander Palmer, so apologies to your team's handler, uh, Spartan Carmichael, for going over his head here.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "shadow_transmission_name" );

// Shadow Leader : This is Shadow leader.  Go ahead, Miller. 
dprint ("Shadow Leader: This is Shadow leader.  Go ahead, Miller.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Got a job for you.  Infiltrate a Covenant cruiser and destroy her power core.  I'm sending you coordinates now. 
dprint ("Miller: Got a job for you.  Infiltrate a Covenant cruiser and destroy her power core.  I'm sending you coordinates now.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

//// Roland : Spartan Miller!  Is that a good idea? 
//dprint ("Roland: Spartan Miller!  Is that a good idea?");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00400', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00400'));
//
//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//// Miller : It's my only idea right now, Roland.  Shadow's the closest Fireteam with air transport. 
//dprint ("Miller: It's my only idea right now, Roland.  Shadow's the closest Fireteam with air transport.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00500', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00500'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "shadow_transmission_name" );

// Shadow Leader : We can help you out there.  Give us a few to get over to those grid squares.
dprint ("Shadow Leader: We can help you out there.  Give us a few to get over to those grid squares.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00600', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_millerplan_00600'));

end_radio_transmission();

thread(e3m5_shadow1_callback());

end


script dormant vo_e5m3_afterawhile()

cui_hud_hide_radio_transmission_hud();
sleep (10);
start_radio_transmission( "shadow_transmission_name" );

// Shadow Leader : Shadow Miller, we're inbound on the Covenant Cruiser.  We're going to kick the door in and surprise them in ten.
dprint ("Shadow Leader: Shadow Miller, we're inbound on the Covenant Cruiser.  We're going to kick the door in and surprise them in ten.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_afterawhile_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_afterawhile_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Understood, Miller.  Keep me informed.
dprint ("Miller: Understood, Miller.  Keep me informed.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_afterawhile_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_afterawhile_00200'));

end_radio_transmission();

thread(e5m3_generic_callback());

end


script dormant vo_e5m3_evacorder()

start_radio_transmission( "miller_transmission_name" );

// Miller : This is Spartan Miller to Marine unit Warbird.  I need your men to evacuate the area.  You're going to have a cruiser coming down on your heads in a few minutes.
dprint ("Miller: This is Spartan Miller to Marine unit Warbird.  I need your men to evacuate the area.  You're going to have a cruiser coming down on your heads in a few minutes.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_evacorder_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_evacorder_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "e5m3_marine_3_transmission_name" );

// e5m3_marine3 : Understood, Infinity.  Warbirds!  Fall out!
dprint ("e5m3_marine3: Understood, Infinity.  Warbirds!  Fall out!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_evacorder_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_evacorder_00200'));

end_radio_transmission();

thread(e5m3_generic_callback());

end


script dormant vo_e5m3_wontopen()

start_radio_transmission( "boyd_transmission_name" );

// Doctor Boyd : Hello!  Infinity?!
dprint ("Doctor Boyd: Hello!  Infinity?!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Doctor Boyd?  Where are you?
dprint ("Miller: Doctor Boyd?  Where are you?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

// Doctor Boyd : Still in the safe room.  The door won't open!
dprint ("Doctor Boyd: Still in the safe room.  The door won't open!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Jeez…along with everything else…
dprint ("Miller: Jeez…along with everything else…");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00400'));

thread(e5m3_wontopen_callback());	//TJP

cui_hud_hide_radio_transmission_hud();
sleep (30);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Crimson, see if you can lend Doctor Boyd a hand.
dprint ("Miller: Crimson, see if you can lend Doctor Boyd a hand.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00500', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wontopen_00500'));

end_radio_transmission();

thread(e5m3_generic_callback());

end


script dormant vo_e5m3_opendoor()

start_radio_transmission( "miller_transmission_name" );

// Miller : There's the safe room door.  Doctor Boyd, stand back.
dprint ("Miller: There's the safe room door.  Doctor Boyd, stand back.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_opendoor_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_opendoor_00100'));

end_radio_transmission();

thread(e5m3_opendoor_callback());		//TJP

end


script dormant vo_e5m3_dooropen()

start_radio_transmission( "boyd_transmission_name" );

// Doctor Boyd : Oh, thank you!
dprint ("Doctor Boyd: Oh, thank you!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_dooropen_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_dooropen_00100'));

// Miller : Doctor Body, follow the Marines.  They'll get you to an evac point.
//dprint ("Miller: Doctor Body, follow the Marines.  They'll get you to an evac point.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_dooropen_00200', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_dooropen_00200'));

end_radio_transmission();

thread(e5m3_dooropen_callback());		//TJP

end


script dormant vo_e5m3_lottadropships()

start_radio_transmission( "roland_transmission_name" );

// Roland : Well, that's a lot of drop ships.
dprint ("Roland: Well, that's a lot of drop ships.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_lottadropships_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_lottadropships_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Is that what I sound like?
dprint ("Miller: Is that what I sound like?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_lottadropships_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_lottadropships_00200'));

end_radio_transmission();

thread(e5m3_lottadropships_callback());		//TJP

end


script dormant vo_e5m3_phantom()

start_radio_transmission( "miller_transmission_name" );

// Miller : Crimson!  Phantom inbound!
dprint ("Miller: Crimson!  Phantom inbound!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_phantom_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_phantom_00100'));

end_radio_transmission();

end


script dormant vo_e5m3_hunters()

start_radio_transmission( "miller_transmission_name" );

// Miller : Oh hell, it's the kitchen sink today, isn't it?  Here come Hutners!
dprint ("Miller: Oh hell, it's the kitchen sink today, isn't it?  Here come Hutners!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hunters_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hunters_00100'));

end_radio_transmission();

thread(e5m3_hunters_callback());

end


script dormant vo_e5m3_oncruiser()

start_radio_transmission( "shadow_transmission_name" );

// Shadow Leader : Shadow Leader to Spartan Miller.  Sorry for the delay, sir.  We're meeting heavy resistance in the Cruiser.  Seems they don't want their spaceship blown up.
dprint ("Shadow Leader: Shadow Leader to Spartan Miller.  Sorry for the delay, sir.  We're meeting heavy resistance in the Cruiser.  Seems they don't want their spaceship blown up.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_oncruiser_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_oncruiser_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Understood, Shadow Leader.  Keep me informed.
dprint ("Miller: Understood, Shadow Leader.  Keep me informed.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_oncruiser_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_oncruiser_00200'));

end_radio_transmission();

thread(e5m3_generic_callback());

end


script dormant vo_e5m3_cruiserhit()

cui_hud_hide_radio_transmission_hud();
sleep (10);
start_radio_transmission( "shadow_transmission_name" );

// Shadow Leader : Miller!  Shadow Leader!  Cruiser power core is hit1  Overload in progress!  We're evacing now.  Expect a light show wihtin 30.
dprint ("Shadow Leader: Miller!  Shadow Leader!  Cruiser power core is hit1  Overload in progress!  We're evacing now.  Expect a light show wihtin 30.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserhit_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserhit_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Hot damn, good work, Shadow Leader!
dprint ("Miller: Hot damn, good work, Shadow Leader!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserhit_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserhit_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (30);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Crimson!  Hold out just a bit longer!  Your troubles are over.
dprint ("Miller: Crimson!  Hold out just a bit longer!  Your troubles are over.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserhit_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserhit_00300'));

end_radio_transmission();

thread(e5m3_generic_callback());

end


script dormant vo_e5m3_cruiserboom()

start_radio_transmission( "miller_transmission_name" );

// Miller : Shadow Leader!  Was your team clear?!...Shadow Leader!
dprint ("Miller: Shadow Leader!  Was your team clear?!...Shadow Leader!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "shadow_transmission_name" );

// Shadow Leader : We're here, Infinity.  And all in one piece.
dprint ("Shadow Leader: We're here, Infinity.  And all in one piece.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Excellent work, Spartans.
dprint ("Miller: Excellent work, Spartans.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00300'));

end_radio_transmission();

thread(e5m3_vo_cruiserboom_callback());

end


script dormant vo_e5m3_wrapup()

start_radio_transmission( "roland_transmission_name" );

// Roland : Spartan Miller, distress call from Forward Base Magma.  They've been under attack for some time and would appreciate backup.
dprint ("Roland: Spartan Miller, distress call from Forward Base Magma.  They've been under attack for some time and would appreciate backup.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Crimson, you're closest to them.  Hope you weren't planning on catching your breath.
dprint ("Miller: Crimson, you're closest to them.  Hope you weren't planning on catching your breath.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Dalton, I need a quick ride for Crimson to Magma's position.
dprint ("Miller: Dalton, I need a quick ride for Crimson to Magma's position.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (20);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Pelican's on station.																					// tjp - moved here to cap off this conversation after snip (below)
dprint ("Dalton: Pelican's on station.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_pelican_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_pelican_00100'));

end_radio_transmission();
sleep (10);

// Dalton : I can arrange that.  Sorry about earlier, Miller.						 // tjp - snipped at josh's request
//dprint ("Dalton: I can arrange that.  Sorry about earlier, Miller.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00400', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00400'));
//
//cui_hud_hide_radio_transmission_hud();
//sleep (10);
//cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//// Miller : We'll talk about it later.
//dprint ("Miller: We'll talk about it later.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00500', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_wrapup_00500'));
//
//cui_hud_hide_radio_transmission_hud();

thread(e5m3_wrapup_callback());

end


script dormant vo_e5m3_pelican()																				// unused - can't afford pelican

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Pelican's on station.
dprint ("Dalton: Pelican's on station.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_pelican_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_pelican_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);

// PIP
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
hud_play_pip_from_tag (bink\spops\ep5_m3_1_60);

// Miller : There's your ride, Crimson.  All aboard.  Let's go save the world for, what, the third time today?
dprint ("Miller: There's your ride, Crimson.  All aboard.  Let's go save the world for, what, the third time today?");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_pelican_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_pelican_00200_pip'));

end_radio_transmission();
// end PIP

thread(e5m3_pelican_callback());

end