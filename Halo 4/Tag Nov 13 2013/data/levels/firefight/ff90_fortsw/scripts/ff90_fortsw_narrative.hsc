//=============================================================================================================================
//============= FORTSW NARRATIVE SCRIPT ========================================================
//=============================================================================================================================
global boolean b_wait_for_narrative_e1_m3 = TRUE;
global boolean e1m3_narrative_is_on = FALSE;
global boolean e4m3_narrative_is_on = FALSE; 

script startup sparops_e01_m03_main()

	dprint (":::  NARRATIVE SCRIPT  :::");
	
end


script static void ex1()
	//fires e1 m5 Narrative Out scene
	
	wake (vo_e1m3_intro);
	pup_play_show(e1_m3_narrative_in);
	sleep_until(b_wait_for_narrative_e1_m3 == FALSE);
	print("________________narrative is done");
	firefight_mode_set_player_spawn_suppressed(false);
	
end


script static void ex2()
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
	
end


script command_script cs_evac()

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it’s avoiding things for no reason
	
 	cs_fly_by (ps_e1m3_evac.p0);
 	cs_fly_by (ps_e1m3_evac.p1);
	
  cs_vehicle_speed (.6); 
  //Slows down the vehicle
  
//  cs_fly_by (ps_e1m3_evac.p2);
  
//  cs_vehicle_speed (.2);
//  
	sleep_s (1.5);
//  
  cs_fly_to_and_face (ps_e1m3_evac.p2, ps_e1m3_evac.p3);
//  
//  sleep_s (.5);
//	b_pelican_done = true;
  
end


//=============================================================================================================================
//========== FORTS Ep 01 Mission 03 VO scripts ===================================================
//=============================================================================================================================


script dormant vo_e1m3_intro()
  //plays over intro
  
  sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
//  // Miller : Crimson and Majestic are online, Commander Palmer.
//	dprint ("Miller: Crimson and Majestic are online, Commander Palmer.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00100'));

	start_radio_transmission( "miller_transmission_name" );
	
	// Palmer : Spartans, you're being deployed to a pair of identical structures located north of primary operations.
	dprint ("Palmer: Spartans, you're being deployed to a pair of identical structures located north of primary operations.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Here's a challenge for you: who can clear their base of Prometheans first?
	dprint ("Palmer: Here's a challenge for you: who can clear their base of Prometheans first?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : What do we win if we beat Crimson, Commander?
	dprint ("DeMarco: What do we win if we beat Crimson, Commander?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : The respect of your peers, DeMarco.  That should be an exciting new experience for you.
	dprint ("Palmer: The respect of your peers, DeMarco.  That should be an exciting new experience for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_intro_00500'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_hitjammer()
	// when gameplay begins
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
		
//	// Miller : These facilities are --
//	dprint ("Miller: These facilities are --");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00100'));

	start_radio_transmission( "demarco_transmission_name" );
	
	// DeMarco : Demarco to Commander Palmer.  Hello?
	dprint ("DeMarco: Demarco to Commander Palmer.  Hello?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : Crimson!  Are you there?
	dprint ("DeMarco: Crimson!  Are you there?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : I can't hear anybody.
	dprint ("DeMarco: I can't hear anybody.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "thorne_transmission_name" );

	// Thorne : Maybe everyone's ignoring you, Demarco.
	dprint ("Thorne: Maybe everyone's ignoring you, Demarco.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00500'));

//	// Hoya : Heh.  Good one, Thorne.
//	dprint ("Hoya: Heh.  Good one, Thorne.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00600', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00600'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : Shut it, Thorne.  Get on point and take down that Comm Jammer.
	dprint ("DeMarco: Shut it, Thorne.  Get on point and take down that Comm Jammer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_playstart_00700'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_nearjammer()
	// approach jammer
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
//	// DeMarco : Target down.  How's it going on your end, Crimson?
//	dprint ("DeMarco: Target down.  How's it going on your end, Crimson?");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00100'));

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson?  Majestic?  Can anyone hear me?
	dprint ("Miller: Crimson?  Majestic?  Can anyone hear me?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00200_soundstory', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00200_soundstory'));

//	// Thorne : That sounded like Commander Palmer.
//	dprint ("Thorne: That sounded like Commander Palmer.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00300'));

	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : Taking down the jammer cleared up the signal.  Crimson, if you can hear us, hit any jammers you see!
	dprint ("DeMarco: Taking down the jammer cleared up the signal.  Crimson, if you can hear us, hit any jammers you see!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_majesjammer_00400'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_jammerdown()
	// jammer is down
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
//	// Palmer : …er, I need an explanation.  Now.
//	dprint ("Palmer: …er, I need an explanation.  Now.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00100'));
//
//	// DeMarco : Commander Palmer!
//	dprint ("DeMarco: Commander Palmer!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00200'));

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander!  Majestic and Crimson comm signals are back.
	dprint ("Miller: Commander!  Majestic and Crimson comm signals are back.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : About time!  Whatever you did down there, good work teams.  Now then, let the games begin.
	dprint ("Palmer: About time!  Whatever you did down there, good work teams.  Now then, let the games begin.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_jammerdown_00400'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_go1sttower()
	// go to first tower
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Marking first targets for each team, Commander.
	dprint ("Miller: Marking first targets for each team, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1goto_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1goto_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	
	sleep_s(1);
	b_end_player_goal = TRUE;
	sleep_s(1);
	
	//sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Show me what you've got, Spartans.
	dprint ("Palmer: Show me what you've got, Spartans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1goto_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1goto_00200'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_1sttowerdeactivate()
	// first tower deactivated
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson's first target is down, Commander.
	dprint ("Miller: Crimson's first target is down, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1down_00100'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_prometheans()  // <______________need to add this line...
	// Prometheans spawn after first tower down
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, looks like your first contact with Prometheans.  These are Crawlers, fast and mean, but pretty easy to deal with.
	dprint ("Miller: Crimson, looks like your first contact with Prometheans.  These are Crawlers, fast and mean, but pretty easy to deal with.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_prometheans_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_prometheans_00100'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_scoreboard1()
	// update on competition's progress
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "demarco_transmission_name" );
		
	// DeMarco : Target down.
	dprint ("DeMarco: Target down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_scoreboard1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_scoreboard1_00100'));
	
	sleep (10);

	// DeMarco : Tie game again, Commander.
	dprint ("DeMarco: Tie game again, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_scoreboard1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_scoreboard1_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "thorne_transmission_name" );

	// Thorne : Prometheans!
	dprint ("Thorne: Prometheans!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_scoreboard1_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_scoreboard1_00300'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_turretdeploy()  //<--- need to add this line
	// warning about turret deploying
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, what watcher's bringing a turret online!
	dprint ("Miller: Crimson, what watcher's bringing a turret online!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_turret1warn_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_turret1warn_00100'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_1sttowerhalf()
	// first tower is halfway done
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "demarco_transmission_name" );
		
	// DeMarco : Commander, we're moving to the next target.
	dprint ("DeMarco: Commander, we're moving to the next target.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1halfdone_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1halfdone_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, pick up the pace.  Demarco's team is making you look bad.
	dprint ("Palmer: Crimson, pick up the pace.  Demarco's team is making you look bad.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1halfdone_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1halfdone_00200'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_1sttowerclear()
	// first tower is clear
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson's cleared their tower, Commander
	dprint ("Miller: Crimson's cleared their tower, Commander");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1clear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1clear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Next tower, then.  Show some hustle.
	dprint ("Palmer: Next tower, then.  Show some hustle.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1clear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower1clear_00200'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_2ndturretwarn()
	// second turret warning
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, watch out!  Another turret coming online!
	dprint ("Miller: Crimson, watch out!  Another turret coming online!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_turret2warn_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_turret2warn_00100'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_2ndtowerhalf()
	// second tower is halfway done
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Haven't heard from you in awhile, Demarco.
	dprint ("Palmer: Haven't heard from you in awhile, Demarco.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2half_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2half_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// SoundStory : Just having a discussion with the locals, Commander.
	dprint ("SoundStory: Just having a discussion with the locals, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2half_00200_soundstory', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2half_00200_soundstory'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : FYI.  Crimson's gaining on you.
	dprint ("Palmer: FYI.  Crimson's gaining on you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2half_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2half_00300'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_2ndtowerdeactivate()
	// 2nd tower deactivated
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson's got their second tower down, Commander.
	dprint ("Miller: Crimson's got their second tower down, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2down_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Nicely done.  Planting a waypoint for your third target.
	dprint ("Palmer: Nicely done.  Planting a waypoint for your third target.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2down_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_tower2down_00200'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_target3enroute()
	// on the way to the 3rd target
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "demarco_transmission_name" );
		
	// DeMarco : Second tower down, Commander.
	dprint ("DeMarco: Second tower down, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3go_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3go_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson's way ahead of you, Demarco.
	dprint ("Palmer: Crimson's way ahead of you, Demarco.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3go_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3go_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : We'll catch up, Commander.
	dprint ("DeMarco: We'll catch up, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3go_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3go_00300'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_target3arrive()
	// arrive at target 3
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, there's your next target.
	dprint ("Palmer: Crimson, there's your next target.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3at_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3at_00100'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_3rdtowerdeactivate()
	// 3rd location powered down
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson has disabled all systems, Commander.
	dprint ("Miller: Crimson has disabled all systems, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Good show.  Marking an evac location for you now.
	dprint ("Palmer: Good show.  Marking an evac location for you now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00200'));
	
	b_end_player_goal = TRUE; //<-- goal after you hit the 3rd switch
	f_new_objective(e1m3_obj04);
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : Oh, come on!  Crimson's base can't have had the defenses ours did!
	dprint ("DeMarco: Oh, come on!  Crimson's base can't have had the defenses ours did!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : You're right, Demarco.  Crimson  had more to deal with than you.
	dprint ("Palmer: You're right, Demarco.  Crimson  had more to deal with than you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_location3down_00400'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_evaclocation()
	// mark evac location
	
	thread (story_blurb_add("vo", "no longer used"));
	
end


script dormant vo_e1m3_secureevac()
	// arrive at evac area
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Crimson, Dalton in Transport.  You need to secure that location before your ride out can land.
	dprint ("Dalton: Crimson, Dalton in Transport.  You need to secure that location before your ride out can land.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_clearevac_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_clearevac_00100'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end


script dormant vo_e1m3_evacsecured()
	// evac area is secure
	sleep_until (e1m3_narrative_is_on == FALSE);
	e1m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
			
	// Miller : Dalton, Crimson has secured the location.
	dprint ("Miller: Dalton, Crimson has secured the location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Affirmative.  Pelican inbound.
	dprint ("Dalton: Affirmative.  Pelican inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00200'));

	sleep (41);
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP 
	hud_play_pip_from_tag(bink\spops\ep1_m3_1_60);
	thread (pip_e1m3_1_subtitles());
	
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Nice work down there, Crimson.
	// Palmer : Maybe next time, eh, Majestic?
	dprint ("Palmer: Nice work down there, Crimson.");
	dprint ("Palmer: Maybe next time, eh, Majestic?");
	
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00300', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00300_pip'));
	
	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : You know we will, Commander.
	dprint ("DeMarco: You know we will, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00500'));
	
	end_radio_transmission();
	
	e1m3_narrative_is_on = FALSE;
end

script static void pip_e1m3_1_subtitles()
	sleep_s (1.08);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_01_mission_03\e1m3_evacclear_00300');
end


//=============================================================================================================================
//========== FORTS Ep 02 Mission 03 VO scripts ===================================================
//=============================================================================================================================


script static void vo_e2m3_intro()
	// VO for intro scene
	
	start_radio_transmission( "e2m3_marine_1_transmission_name" );
		
	// e2m3_marine_01 : Infinity!  This is Hacksaw.  We're getting hit hard on all sides!
	dprint ("e2m3_marine_01: Infinity!  This is Hacksaw.  We're getting hit hard on all sides!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00100'));
	
	sleep (10);

	// e2m3_marine_01 : We need reinforcements, ordnance, hell, I'd settle for a straight up evac right now!
	dprint ("e2m3_marine_01: We need reinforcements, ordnance, hell, I'd settle for a straight up evac right now!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00200'));
	
	sleep (10);

	// Palmer : Man up, Hacksaw.  Reinforcements inbound.
	dprint ("Palmer: Man up, Hacksaw.  Reinforcements inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_in_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	
end


script dormant vo_e2m3_savemarines()
	// instruct to save marines

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson, it's a straightforward rescue op.  If it's UNSC, save its ass.  If it's a Covie, blast it to hell.
	dprint ("Palmer: Crimson, it's a straightforward rescue op.  If it's UNSC, save its ass.  If it's a Covie, blast it to hell.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander Palmer, I'm painting the locs of Marines calling for assistance.
	dprint ("Miller: Commander Palmer, I'm painting the locs of Marines calling for assistance.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_savemarines_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	
end


script dormant vo_e2m3_marine01arrive()
	// arrive at first Marines
	
	start_radio_transmission ( "e2m3_marine_2_transmission_name" );
	
	// e2m3_marine_02 : Hey!  It's Spartans!
	dprint ("e2m3_marine_02: Hey!  It's Spartans!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00100'));

	// e2m3_marine_03 : Oh hell yeah!
	dprint ("e2m3_marine_03: Oh hell yeah!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01arrive_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	
end


script dormant vo_e2m3_marine01rescue()
	// rescued first Marines
	
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Nice work, Crimson.  Hacksaw team, you're under Spartan command for the duration.  Fall in with Crimson and offer fire support.
	dprint ("Palmer: Nice work, Crimson.  Hacksaw team, you're under Spartan command for the duration.  Fall in with Crimson and offer fire support.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);

	// e2m3_marine_02 : You got it, Commander!
	dprint ("e2m3_marine_02: You got it, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine01rescue_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	
end


script dormant vo_e2m3_marine02arrive()
	// arrive at second Marines
	
	// e2m3_marine_04 : They won't stop!  They just won't--
	dprint ("e2m3_marine_04: They won't stop!  They just won't--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00100'));

	// e2m3_marine_05 : Look!  Spartans!  We're saved!
	dprint ("e2m3_marine_05: Look!  Spartans!  We're saved!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine02arrive_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	
end


script dormant vo_e2m3_marine02rescue()
	// have rescued second Marines
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
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

	sleep (10);

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
	
	cui_hud_hide_radio_transmission_hud();
	
end	


script dormant vo_e2m3_marine03arrive()
	// arrive at third Marines
	
	// e2m3_marine_06 : There's our ride home, Marines!
	dprint ("e2m3_marine_06: There's our ride home, Marines!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00100'));

	// e2m3_marine_07 : Hell yes!
	dprint ("e2m3_marine_07: Hell yes!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03arrive_00200'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_marine03rescue()
	// rescued third Marines
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : That's everyone.
	dprint ("Miller: That's everyone.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03rescue_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marine03rescue_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_cleartolz()
	// clear path to landing zone_set_trigger_volume_enable
	
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Dalton, sitrep on the extraction team?
	dprint ("Palmer: Dalton, sitrep on the extraction team?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_cleartolz_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Just need a place to land, Commander.  But there's a lot of activity down there.
	dprint ("Dalton: Just need a place to land, Commander.  But there's a lot of activity down there.");
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
	
end


script dormant vo_e2m3_phantom01()
	// incoming Phantom 1
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Phantom incoming!
	dprint ("Miller: Phantom incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Keep sharp, Crimson.
	dprint ("Palmer: Keep sharp, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_phantom01_00200'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_wraith01()
	// incoming wraith 1
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Phantom's transporting a Wraith, Commander.
	dprint ("Miller: Phantom's transporting a Wraith, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_wraith01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_wraith01_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_reinforcements01()
	// incoming Covenant Reinforcements
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Reinforcements inbound.
	dprint ("Miller: Reinforcements inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_reinforcements01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_reinforcements01_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_hunters01()
	// incoming Hunters

	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Reinforcements inbound.
	dprint ("Miller: Reinforcements inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_reinforcements01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_reinforcements01_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_ammocrates()
	// Ammo crates arrive
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
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

	// Palmer : Ammo up, Crimson.
	dprint ("Palmer: Ammo up, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_ammocrates_00300'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_phantom02()
	// second Phantom incoming
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
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
	
end


script dormant vo_e2m3_allmarinesout()
	// you got all the marines out

	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Nice work keeping Hacksaw in one piece, Crimson.
	dprint ("Palmer: Nice work keeping Hacksaw in one piece, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_allmarinesout_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_allmarinesout_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_somemarinesout()
	// got some marines out

	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Hacksaw, those of you left standing owe Crimson your lives.  I suggest at least buying them a round of beers each.
	dprint ("Palmer: Hacksaw, those of you left standing owe Crimson your lives.  I suggest at least buying them a round of beers each.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_somemarinesout_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_somemarinesout_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_onemarineout()
	// got only one marine out

	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Well, Crimson, at least you got one Marine out.
	dprint ("Palmer: Well, Crimson, at least you got one Marine out.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_onemarineout_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_onemarineout_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_marinesdead()
	// no marines survived

	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Crimson, this was a search and rescue mission.  Maybe you forgot the rescue bit?
	dprint ("Palmer: Crimson, this was a search and rescue mission.  Maybe you forgot the rescue bit?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marinesdead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_marinesdead_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_phantomsclear()
	// all Phantoms down

	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
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
	
end


script dormant vo_e2m3_stragglers()
	// take out all the stragglers

	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Crimson, clear out the last few stragglers down there.  Dalton, get your bird on the ground pronto.
	dprint ("Palmer: Crimson, clear out the last few stragglers down there.  Dalton, get your bird on the ground pronto.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_stragglers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_stragglers_00100'));
	
	end_radio_transmission();
	
end


script dormant vo_e2m3_alldone()
	// level is done
	
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Pelican is on point and waiting, Commander.
	dprint ("Dalton: Pelican is on point and waiting, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Understood, Dalton.  Job's done, Crimson.  Come on home.
	dprint ("Palmer: Understood, Dalton.  Job's done, Crimson.  Come on home.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_03\e2m3_alldone_00200'));
	
	end_radio_transmission();
	
end


//=============================================================================================================================
//========= FORTS Ep 04 Mission 03 VO scripts ===================================================
//=============================================================================================================================

script dormant vo_e4m3_intro()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : So where the hell did Crimson go?
	dprint ("Palmer: So where the hell did Crimson go?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : No idea, Commander.  I'm working on it.
	dprint ("Miller: No idea, Commander.  I'm working on it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : Commander Palmer?  If you don't mind, I've located Crimson's IFF tags.  They're in one of the arctic comm forts.
	dprint ("Roland: Commander Palmer?  If you don't mind, I've located Crimson's IFF tags.  They're in one of the arctic comm forts.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Whoa.  Okay.  Thanks, Roland.  Bit of a jump there, Crimson.
	dprint ("Palmer: Whoa.  Okay.  Thanks, Roland.  Bit of a jump there, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00400'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_playstart()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Miller, what can we do to clear up the transmission?
	dprint ("Palmer: Miller, what can we do to clear up the transmission?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_playstart_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_playstart_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Working on it, Commander.
	dprint ("Miller: Working on it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_playstart_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_playstart_00200'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_boxedin()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, don't know if you can hear me, but you're boxed in there.  Only way out is through the bad guys.
	dprint ("Palmer: Crimson, don't know if you can hear me, but you're boxed in there.  Only way out is through the bad guys.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_boxedin_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_boxedin_00100'));
	
	end_radio_transmission();

	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_commrelay()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander, there's a UNSC relay still online.  If Crimson can reach that, it should clear our transmissions.  Painting a waypoint for them now.
	dprint ("Miller: Commander, there's a UNSC relay still online.  If Crimson can reach that, it should clear our transmissions.  Painting a waypoint for them now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_commrelay_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_commrelay_00100'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_clearedup()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Much better, Crimson.  Miller, now that we can see straight, where's Jul 'Mdama?
	dprint ("Palmer: Much better, Crimson.  Miller, now that we can see straight, where's Jul 'Mdama?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_clearedup_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_clearedup_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : There was another slipspace rupture at this location just before Crimson's arrival.
	dprint ("Miller: There was another slipspace rupture at this location just before Crimson's arrival.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_clearedup_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_clearedup_00200'));
	
	sleep (10);

	// Miller : Looking into it.
	dprint ("Miller: Looking into it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_clearedup_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_clearedup_00300'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_fortsinfo()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "roland_transmission_name" );
		
	// Roland : I'm bored.
	dprint ("Roland: I'm bored.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Roland?  Clear the channel.
	dprint ("Palmer: Roland?  Clear the channel.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : The data that's confusing Spartan Miller is only confusing because he still thinks forts are comm relays.
	dprint ("Roland: The data that's confusing Spartan Miller is only confusing because he still thinks forts are comm relays.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : So what are they really?
	dprint ("Miller: So what are they really?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : They're a portal nexus.  Just like back at those towers.  Thought it'd be obvious by now.
	dprint ("Roland: They're a portal nexus.  Just like back at those towers.  Thought it'd be obvious by now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_fortsinfo_00500'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_activateportal()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Do you see a way to activate the protals, Roland?
	dprint ("Miller: Do you see a way to activate the protals, Roland?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	
	// PIP
	hud_play_pip_from_tag(bink\spops\ep4_m3_1_60);
	thread (pip_e4m3_1_subtitles());
	cui_hud_show_radio_transmission_hud( "" );

	// Roland : Of course.  Can I turn on the waypoints for Crimson?  It's exciting being part of an Op!	
	// Miller : Go ahead.
	// Palmer : Hey!  Protocols, Miller!
	// Roland : There you are, Crimson!  Get up there!  I command it!
	// Roland : Okay, now I'm bored again.  Bye.
	
	dprint ("Roland: Of course.  Can I turn on the waypoints for Crimson?  It's exciting being part of an Op!");
	dprint ("Miller: Go ahead.");
	dprint ("Palmer: Hey!  Protocols, Miller!");
	dprint ("Roland: There you are, Crimson!  Get up there!  I command it!");
	dprint ("Roland: Okay, now I'm bored again.  Bye.");
	
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00200', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00300', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00400', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00500', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00600', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00200_pip'));
	
	end_radio_transmission();
	// end PIP
	
	b_end_player_goal = TRUE;
	e4m3_narrative_is_on = FALSE;
end

script static void pip_e4m3_1_subtitles()
	sleep_s (0.21);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00200');
	sleep_s (0.03);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00300');
	sleep_s (0.21);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00400');
	sleep_s (0.1);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00500');
	sleep_s (2.25);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_activateportal_00600');
end


script dormant vo_e4m3_2portalsopen
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander, two portal activators just powered up.
	dprint ("Miller: Commander, two portal activators just powered up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Which did Jul 'Mdama use?
	dprint ("Palmer: Which did Jul 'Mdama use?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Not sure.  But now that I know what these things are, I can probably figure that out if Crimson gets a closer look.
	dprint ("Miller: Not sure.  But now that I know what these things are, I can probably figure that out if Crimson gets a closer look.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Show 'em where to go, Miller.	
	dprint ("Palmer: Show 'em where to go, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	
	sleep_s(2);
	navpoint_track_object_named(e4_m3_switch_1, "navpoint_activate");
	navpoint_track_object_named(e4_m3_switch_2, "navpoint_activate");
	sleep_s(1);
	
	sleep (1);
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Either one of these waypoints should do it, Crimson.
	dprint ("Miller: Either one of these waypoints should do it, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00500'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_analyzeportal()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Okay, stay put right there just for a moment…
	dprint ("Miller: Okay, stay put right there just for a moment…");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_analyzeportal_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_analyzeportal_00100'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_portalfail()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : No…Last activation date on this portal is days ago.  It's not the one 'Mdama activated.
	dprint ("Miller: No…Last activation date on this portal is days ago.  It's not the one 'Mdama activated.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_portalfail_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_portalfail_00100'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_portalsuccess()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : That's the one, Commander!  Jul 'Mdama came through here just a few minutes ago.
	dprint ("Miller: That's the one, Commander!  Jul 'Mdama came through here just a few minutes ago.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_portalsuccess_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_portalsuccess_00100'));
	
	end_radio_transmission();

	e4m3_narrative_is_on = FALSE;
end


script dormant vo_e4m3_gotoportal1()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : It's turned on, where's the portal?
	dprint ("Palmer: It's turned on, where's the portal?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00100'));
	
	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end

script dormant vo_e4m3_gotoportal2()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Painting a waypoint now.
	dprint ("Miller: Painting a waypoint now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00200'));
	
	b_end_player_goal = TRUE;
	
	cui_hud_hide_radio_transmission_hud();
	sleep (1);
	sleep (10);
	
		cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	sleep (41);

	// PIP
	hud_play_pip_from_tag(bink\spops\ep4_m3_2_60);	
	thread (pip_e4m3_2_subtitles());
	
	// Palmer : There's your doorway, Crimson.  Get in there.
	dprint ("Palmer: There's your doorway, Crimson.  Get in there.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_getinportal_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_getinportal_00100_pip'));
	
	end_radio_transmission();
	// end PIP
	
	
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//
//	// Palmer : Get moving, Crimson.  We've got a hinge head to chase.
//	dprint ("Palmer: Get moving, Crimson.  We've got a hinge head to chase.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00300'));
//	
//	cui_hud_hide_radio_transmission_hud();
	
	e4m3_narrative_is_on = FALSE;
end

script static void pip_e4m3_2_subtitles()
	sleep_s (1.13);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_getinportal_00100');
end



script dormant vo_e4m3_getinportal()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;
	
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//	
//	sleep (41);
//
//	// PIP
//	hud_play_pip_from_tag(bink\spops\ep4_m3_2_60);	
//	
//	// Palmer : There's your doorway, Crimson.  Get in there.
//	dprint ("Palmer: There's your doorway, Crimson.  Get in there.");
//	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_getinportal_00100', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_getinportal_00100_pip'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	// end PIP
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Get moving, Crimson.  We've got a hinge head to chase.
	dprint ("Palmer: Get moving, Crimson.  We've got a hinge head to chase.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_gotoportal_00300'));
	
	end_radio_transmission();
	
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	
	e4m3_narrative_is_on = FALSE;
end

script dormant vo_e4m3_slmost_got_it()
	sleep_until (e4m3_narrative_is_on == FALSE);
	e4m3_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		// Miller : Almost got it.
	dprint ("Miller: Almost got it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00100'));

	end_radio_transmission();
	
	e4m3_narrative_is_on = FALSE;
end