//=============================================================================================================================
//============================================ COURTYARD NARRATIVE SCRIPT ========================================================
//=============================================================================================================================

// behold, the greatest narrative script ever to pass through the halls of 343...or 550...or whatever...it will be good anyway.

global object pup_player0 = player0;
global object pup_player1 = player1;
global object pup_player2 = player2;
global object pup_player3 = player3;
global boolean b_pelican_done = false;
global boolean e5m1_narrative_is_on = FALSE;

script startup sparops_e2_m1_main()
	dprint (":::  NARRATIVE SCRIPT  :::");
end

script static void ex1()
	//fires e1 m5 Narrative Out scene
	print ("ex1");
end


//=============================================================================================================================
//======================================== CATHEDRAL Narrative Design stuff ===================================================
//=============================================================================================================================


//script command_script cs_evac_leave()
//	// pelican leaves in cutscene
//	
//	cs_vehicle_speed (1.0);
//	cs_fly_to (e3m5_pelican.p0);
//	
//end
//
//
//script static void e3_m5_out()
//	// set camera move for final shot
//	
//	ai_erase (e3m5_pelican);
//	ai_place (e3m5_pelican);
//	
//	camera_control (true);
//	camera_fov = 90;
//	camera_pan (e3m5_out_01_1, e3m5_out_01_2, 110, 0, 1, 0, 1);
//	sleep (30);
//	cs_run_command_script (e3m5_pelican, cs_evac_leave);
//	sleep (75);
//	
//	camera_fov = 55;
//	camera_pan (e3m5_out_02_1, e3m5_out_02_2, 270, 0, 1, 140, 0);
//	
//	//thread (f_music_e1_m5_6_end());
//	
//	sleep (240);
//	fade_out (0, 0, 0, 30);
//	
//	sleep (30);
//	camera_control (false);
//	fade_in (0, 0, 0, 1);
//	
//end


script static void e5_m1_intro()
	// set camera move for e5 m1 intro
	
	fade_in (0, 0, 0, 90);
	camera_control (true);
	
	wake (e5m1_vo_intro);
	
	camera_fov = 90;
	camera_pan (e5m1_in_01_1, e5m1_in_01_2, 215, 0, 1, 0, 1);
	sleep (210);
	
//	camera_fov = 90;
//	camera_pan (e5m1_in_02_1, e5m1_in_02_2, 270, 0, 1, 140, 0);
//	sleep (90);
	
	camera_pan (e5m1_in_03_1, e5m1_in_03_2, 270, 0, 1, 0, 1);
	sleep (180);
	
	fade_out (0, 0, 0, 60);
	
	sleep (60);
	camera_fov = 78;
	camera_control (false);
	//fade_in (0, 0, 0, 1);
	b_e5m1_narrative_in_over = TRUE;
	
end


//=============================================================================================================================
//====================================== CATHEDRAL Ep 02 Mission 01 VO scripts ================================================
//=============================================================================================================================


script dormant e2m1_vo_intro()

//// Miller : Comms are open, Commander Palmer.  Crimson's online.  The Op is live.
//dprint ("Miller: Comms are open, Commander Palmer.  Crimson's online.  The Op is live.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00100', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00100'));
//
//// Palmer : Thank you, Spartan Miller.
//dprint ("Palmer: Thank you, Spartan Miller.");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00200', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00200'));

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Crimson your job today is to dig out some nasty Covenant squatters.  They've parked themselves in this hole with anti-air guns and they're proving themselves to be quite the pain in the UNSC's ass.
dprint ("Palmer: Crimson your job today is to dig out some nasty Covenant squatters.  They've parked themselves in this hole with anti-air guns and they're proving themselves to be quite the pain in the UNSC's ass.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00300'));

sleep (30);

// Palmer : Hit 'em fast, hit 'em hard, don't leave anyone standing.
dprint ("Palmer: Hit 'em fast, hit 'em hard, don't leave anyone standing.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_intro_00400'));

end_radio_transmission();

thread(e2m1_vo_callback_intro());

end


script dormant e2m1_vo_targetguns()

start_radio_transmission( "miller_transmission_name" );

// Miller : I've got a lock on the control systems for those guns, Commander.
dprint ("Miller: I've got a lock on the control systems for those guns, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetguns_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetguns_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Show Crimson where to go.
dprint ("Palmer: Show Crimson where to go.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetguns_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetguns_00200'));

end_radio_transmission();

thread(e2m1_vo_callback());

end


script dormant e2m1_vo_turrets1()

start_radio_transmission( "miller_transmission_name" );

// Miller : Whoa!  Mounted turrets.
dprint ("Miller: Whoa!  Mounted turrets.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_turrets1_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_turrets1_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Take it slow, Crimson.  No need to rush.
dprint ("Palmer: Take it slow, Crimson.  No need to rush.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_turrets1_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_turrets1_00200'));

end_radio_transmission();

thread(e2m1_vo_callback_turrets());

end


script dormant e2m1_vo_watchers()

start_radio_transmission( "miller_transmission_name" );

// Miller : Commander, there's a few Watchers in the air.
dprint ("Miller: Commander, there's a few Watchers in the air.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_watchers_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_watchers_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : So not just Covenant, but Prometheans too.  Noted.
dprint ("Palmer: So not just Covenant, but Prometheans too.  Noted.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_watchers_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_watchers_00200'));

end_radio_transmission();

thread(e2m1_vo_callback());

end


script dormant e2m1_vo_daltonaa()

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Commander Palmer, how long until those guns are offline?  I can't get a bird within ten klicks of that location.
dprint ("Dalton: Commander Palmer, how long until those guns are offline?  I can't get a bird within ten klicks of that location.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_daltonaa_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_daltonaa_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Settle down, Dalton, we're working on it.
dprint ("Palmer: Settle down, Dalton, we're working on it.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_daltonaa_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_daltonaa_00200'));

end_radio_transmission();

thread(e2m1_vo_callback());

end


script dormant e2m1_vo_fewmorecov()

start_radio_transmission( "miller_transmission_name" );

// Miller : Almost done.  Just a few to go.
dprint ("Miller: Almost done.  Just a few to go.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_fewmorecov_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_fewmorecov_00100'));

end_radio_transmission();

thread(e2m1_vo_callback());

end


script dormant e2m1_vo_areaclear()

start_radio_transmission( "miller_transmission_name" );

// Miller : Area's clear, Commander.
dprint ("Miller: Area's clear, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_areaclear_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_areaclear_00100'));

end_radio_transmission();

thread(e2m1_vo_callback_areaclear());

end


script dormant e2m1_vo_targetpylons()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Let's get those AA guns offline.
dprint ("Palmer: Let's get those AA guns offline.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetpylons_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetpylons_00100'));

thread(e2m1_vo_targetpylons_mid_vo_advance_objective());

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Marking the power conduit pylons now.  There you go, Crimson.
dprint ("Miller: Marking the power conduit pylons now.  There you go, Crimson.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetpylons_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_targetpylons_00200'));

end_radio_transmission();

thread(e2m1_vo_callback_targetpylons());

end


script dormant e2m1_vo_pylon1down()

start_radio_transmission( "miller_transmission_name" );

// Miller : One pylon offline.
dprint ("Miller: One pylon offline.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_pylon1down_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_pylon1down_00100'));

end_radio_transmission();

thread(e2m1_vo_callback());

end


script dormant e2m1_vo_bothpylonsdown()

start_radio_transmission( "miller_transmission_name" );

// Miller : That's both pylons, Comman--Whoa.  A slipspace signature just blipped near Crimson.
dprint ("Miller: That's both pylons, Comman--Whoa.  A slipspace signature just blipped near Crimson.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_bothpylonsdown_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_bothpylonsdown_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Point the way, Miller.  Let's have a look.
dprint ("Palmer: Point the way, Miller.  Let's have a look.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_bothpylonsdown_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_bothpylonsdown_00200'));

end_radio_transmission();

thread(e2m1_vo_callback_bothpylonsdown());

end

script dormant e2m1_vo_lotsabaddies()
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Prometheans!  Multiple targets!  All directions!
	dprint ("Miller: Prometheans!  Multiple targets!  All directions!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_lotsabaddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_lotsabaddies_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Stay focused, Crimson.  Take them down.
	dprint ("Palmer: Stay focused, Crimson.  Take them down.");

	hud_play_pip_from_tag (bink\SPops\EP2_M1_1_60);
	thread (pip_e2m1_1_subtitles());

	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_lotsabaddies_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_lotsabaddies_00200_pip'));

	end_radio_transmission();

	thread(e2m1_vo_callback());
end

script static void pip_e2m1_1_subtitles()
	//sleep_s (1.05);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_lotsabaddies_00200');
end


script dormant e2m1_vo_fewtogo()

start_radio_transmission( "miller_transmission_name" );

// Miller : You're almost there!  Hell, yeah!
dprint ("Miller: You're almost there!  Hell, yeah!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_fewtogo_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_fewtogo_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Miller.  A bit of decorum, yeah?
dprint ("Palmer: Miller.  A bit of decorum, yeah?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_fewtogo_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_fewtogo_00200'));

end_radio_transmission();

thread(e2m1_vo_callback());

end


script dormant e2m1_vo_alldead()

start_radio_transmission( "miller_transmission_name" );

// Miller : That's the last of them, Commander.
dprint ("Miller: That's the last of them, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_alldead_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_alldead_00100'));

end_radio_transmission();

thread(e2m1_vo_callback_alldead());

end


script dormant e2m1_vo_ridehome()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Dalton, a ride home for Crimson, please.
dprint ("Palmer: Dalton, a ride home for Crimson, please.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (15);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : You got it, Commander.
dprint ("Dalton: You got it, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00200'));

end_radio_transmission();

thread(e2m1_vo_callback_ridehome());

end

script dormant e2m1_vo_outro()
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander Palmer, distress call coming in.  It's the science team investigating where Crimson recovered that Forerunner artifact.
	dprint ("Miller: Commander Palmer, distress call coming in.  It's the science team investigating where Crimson recovered that Forerunner artifact.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Distress?
	dprint ("Palmer: Distress?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Heavy Covenant forces bearing on their position.  They've taken refuge, but they need extraction.
	dprint ("Miller: Heavy Covenant forces bearing on their position.  They've taken refuge, but they need extraction.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00300'));

	cui_hud_hide_radio_transmission_hud();

	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	hud_play_pip_from_tag (bink\spops\ep2_m1_2_60);
	thread (pip_e2m1_2_subtitles());
	
	// Palmer : Tell them help's on the way, Miller.
	dprint ("Palmer: Tell them help's on the way, Miller. Dalton, change of plans.  Crimson's going to rescue some eggheads.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00500', NONE, 1);
		
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00400_pip'));
	thread(e2m1_vo_callback_outro());

	end_radio_transmission();
	// end PIP
	
end

script static void pip_e2m1_2_subtitles()
	sleep_s (1.2);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_outro_00500');
end


//=============================================================================================================================
//====================================== CATHEDRAL Ep 03 Mission 05 VO scripts ================================================
//=============================================================================================================================

script dormant e3m5_vo_intro() 

sleep (30 * 2.5);

start_radio_transmission( "miller_transmission_name" );

// Miller : Comms online.  The Op is live, Commander. 
dprint ("Miller: Comms online.  The Op is live, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_intro_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_intro_00100'));

sleep(20);

// Palmer : Crimson, we've got a solid line on Parg Vol. 
dprint ("Palmer: Crimson, we've got a solid line on Parg Vol.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_intro_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_intro_00200'));

end_radio_transmission();

sleep(20);

thread(e3m5_callback_intro());

end


script dormant e3m5_vo_playstart() 
	
	hud_play_pip_from_tag (bink\SPops\EP3_M5_1_60); 
	sleep_until(bink_is_playing(), 1);
	
	start_radio_transmission( "palmer_transmission_name" );
	thread (pip_e3m5_1_subtitles());

	// Palmer : Job's simple -- hit Parg Vol's camp hard, leave nothing standing. 
	dprint ("Palmer: Job's simple -- hit Parg Vol's camp hard, leave nothing standing.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_playstart_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_playstart_00100_pip'));

	end_radio_transmission();

	thread (e3m5_callback_playstart()); 
end

script static void pip_e3m5_1_subtitles()
	//sleep_s (1.2);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_playstart_00100');
end


script dormant e3m5_vo_targetid() 

start_radio_transmission( "miller_transmission_name" );

// Miller : Target identified, Commander.  There's Parg Vol. 
dprint ("Miller: Target identified, Commander.  There's Parg Vol.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetid_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetid_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Take him down, Crimson! 
dprint ("Palmer: Take him down, Crimson!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetid_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetid_00200'));

end_radio_transmission();

thread(e3m5_callback_targetid());

end


script dormant e3m5_vo_targetdown() 
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Parg Vol is down!  Confirmed kill! 
	dprint ("Miller: Parg Vol is down!  Confirmed kill!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	hud_play_pip_from_tag (bink\spops\ep3_m5_2_60);
	thread (pip_e3m5_2_subtitles());

	// Palmer : Great work, Crimson. 
	dprint ("Palmer: Great work, Crimson.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00200', NONE, 1);
	
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00200_pip'));

	end_radio_transmission();
	thread(e3m5_callback_targetdown());
end

script static void pip_e3m5_2_subtitles()
	sleep_s (1.11);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_targetdown_00200');
end


script dormant e3m5_vo_backup() 

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Commander Palmer, tell Crimson to get ready.  They've upset the locals and have a little bit of everything headed their way. 
dprint ("Dalton: Commander Palmer, tell Crimson to get ready.  They've upset the locals and have a little bit of everything headed their way.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_backup_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_backup_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Few things make me happier than upsetting the Covenant.  Spartans!  Ready up. 
dprint ("Palmer: Few things make me happier than upsetting the Covenant.  Spartans!  Ready up.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_backup_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_backup_00200'));

end_radio_transmission();

thread(e3m5_callback_backup());

end


script dormant e3m5_vo_droppods()

start_radio_transmission( "miller_transmission_name" );

// Miller : Oh wow.  Dalton wasn't kidding.  Drop pods inbound on Crimson's location. 
dprint ("Miller: Oh wow.  Dalton wasn't kidding.  Drop pods inbound on Crimson's location.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_droppods_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_droppods_00100'));

end_radio_transmission();

thread(e3m5_callback_droppods());

end


script dormant e3m5_vo_phantoms() 

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Phantoms near Crimson's location, Commander. 
dprint ("Dalton: Phantoms near Crimson's location, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : We see them, Dalton.  How are we on air support? 
dprint ("Palmer: We see them, Dalton.  How are we on air support?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (20);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Spread thin at the moment, but I'm working on it. 
dprint ("Dalton: Spread thin at the moment, but I'm working on it.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (20);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Work faster, please. 
dprint ("Palmer: Work faster, please.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_phantoms_00400'));

end_radio_transmission();

thread(e3m5_callback_phantoms());  

end


script dormant e3m5_vo_snipers() 

start_radio_transmission( "miller_transmission_name" );

// Miller : Snipers!  Marking them for you as I see them, Crimson. 
dprint ("Miller: Snipers!  Marking them for you as I see them, Crimson.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_snipers_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_snipers_00100'));

end_radio_transmission();

thread(e3m5_callback_snipers());

end


script dormant e3m5_vo_jetpacks() 

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Jetpacking goons…What the hell?  Do they they we won't just shoot them out of the sky? 
dprint ("Palmer: Jetpacking goons…What the hell?  Do they they we won't just shoot them out of the sky?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_jetpacks_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_jetpacks_00100'));

end_radio_transmission();

thread(e3m5_callback_jetpacks());

end


script dormant e3m5_vo_holdout() 

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Dalton!  Where's that air support you promised me? 
dprint ("Palmer: Dalton!  Where's that air support you promised me?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_holdout_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_holdout_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : I didn't promise -- I said I was working on it! 
dprint ("Dalton: I didn't promise -- I said I was working on it!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_holdout_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_holdout_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Same thing, Dalton.  Get Crimson some air support and get it to them soon. 
dprint ("Palmer: Same thing, Dalton.  Get Crimson some air support and get it to them soon.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_holdout_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_holdout_00300'));

end_radio_transmission();

thread(e3m5_callback_holdout());

end


script dormant e3m5_vo_lotsphantoms() 

start_radio_transmission( "miller_transmission_name" );

// Miller : Commander!  Multiple Phantoms closing in on Crimson!  Oh, this is bad! 
dprint ("Miller: Commander!  Multiple Phantoms closing in on Crimson!  Oh, this is bad!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Dalton!  Air support!  Now! 
dprint ("Palmer: Dalton!  Air support!  Now!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Inbound, Commander!  Get Crimson to cover! 
dprint ("Dalton: Inbound, Commander!  Get Crimson to cover!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : You heard the man, Crimson!  Get your asses into some shelter!
dprint ("Palmer: You heard the man, Crimson!  Get your asses into some shelter!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_lotsphantoms_00400'));

end_radio_transmission();

thread(e3m5_callback_lotsphantoms());

end


script dormant e3m5_vo_bombingrun() 

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Missiles inbound.  If Crimson's not somewhere safe yet, they've got about three seconds. 
dprint ("Dalton: Missiles inbound.  If Crimson's not somewhere safe yet, they've got about three seconds.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00100'));

cui_hud_hide_radio_transmission_hud();

sleep_until(s_e3m5_end_convo == 1, 1);

sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Multiple confirmed hits on target.  Phantoms are all down! 
dprint ("Miller: Multiple confirmed hits on target.  Phantoms are all down!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (20);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Better late than never, Dalton.  Thanks.  Now send Crimson a Pelican. 
dprint ("Palmer: Better late than never, Dalton.  Thanks.  Now send Crimson a Pelican.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (15);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Already on its way, Commander. 
dprint ("Dalton: Already on its way, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00400'));

s_e3m5_end_convo = 2;

cui_hud_hide_radio_transmission_hud();

sleep_until(s_e3m5_end_convo == 3, 1);

sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Crimson?  Damn fine work down there today.  Once you're back to the ship, first round's on me.
dprint ("Palmer: Crimson?  Damn fine work down there today.  Once you're back to the ship, first round's on me.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00500', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00500'));

end_radio_transmission();

thread(e3m5_callback_bombingrun());

end


//=============================================================================================================================
//====================================== CATHEDRAL Ep 05 Mission 01 VO scripts ================================================
//=============================================================================================================================

script dormant e5m1_vo_intro()

	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, it's Miller…the Commander isn't in the Ops Center, and she's not answering her personal comm.
	dprint ("Miller: Crimson, it's Miller…the Commander isn't in the Ops Center, and she's not answering her personal comm.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00100'));
	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//	// Miller : I'm doing her job and mine right now.  So bear with me.
//	dprint ("Miller: I'm doing her job and mine right now.  So bear with me.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : No worries, Spartan Miller.  Commander Palmer's busy.  But I'm here.  I could run these Ops	solo, you know.
	dprint ("Roland: No worries, Spartan Miller.  Commander Palmer's busy.  But I'm here.  I could run these Ops solo, you know.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I'm in charge, Roland.  You just be my extra set of eyes.  Please.
	dprint ("Miller: I'm in charge, Roland.  You just be my extra set of eyes.  Please.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_intro_00400'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_playstart()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	hud_play_pip_from_tag (bink\spops\ep5_m1_1_60);
	thread (pip_e5m1_1_subtitles());
	
	// Miller : Crimson, Infinity Science has evac'd their base here due to some power fluctuations that might be related to the planet-wide slipspace conduit-portal-whatever system you've been exploring.
	dprint ("Miller: Crimson, Infinity Science has evac'd their base here due to some power fluctuations that might be related to the planet-wide slipspace conduit-portal-whatever system you've been exploring.");
	dprint ("Miller: It's nice to see them run away BEFORE half of them are dead for once.");
	dprint ("Miller: Science asked for you to have a look around, see if the bad guys are popping up or not.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_playstart_00300', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_playstart_00200', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_playstart_00300', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_playstart_00100_pip'));
		
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end

script static void pip_e5m1_1_subtitles()
	sleep_s (0.29);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_playstart_00100');
	sleep_s (1.07);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_playstart_00200');
	sleep_s (0.22);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_playstart_00300');
end


script dormant e5m1_vo_prometheans1()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "roland_transmission_name" );
		
	// Roland : Oh no!  Prometheans!  Ahhh!
	dprint ("Roland: Oh no!  Prometheans!  Ahhh!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Roland!  Settle down!
	dprint ("Miller: Roland!  Settle down!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : Isn't that how you always say it?
	dprint ("Roland: Isn't that how you always say it?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Tell you what, I've got this right now.  You go see if Captain Lasky needs your help.
	dprint ("Miller: Tell you what, I've got this right now.  You go see if Captain Lasky needs your help.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : I can do a millions thing at once--
	dprint ("Roland: I can do a millions thing at once--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00500')-15);
	
	cui_hud_hide_radio_transmission_hud();
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Shhh!
	dprint ("Miller: Shhh!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_prometheans1_00600'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_sitrep()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Spartan Miller to Infinity Science.  Who's your slipspace conduit big brain?
	dprint ("Miller: Spartan Miller to Infinity Science.  Who's your slipspace conduit big brain?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : That's me, Spartan.  Doctor Boyd.  We're at the jungle facility--
	dprint ("Doctor Boyd: That's me, Spartan.  Doctor Boyd.  We're at the jungle facility--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Crimson's on station, researching your power fluctuations.  What can we do for you?
	dprint ("Miller: Crimson's on station, researching your power fluctuations.  What can we do for you?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Ah!  Great!  We've got some gear that we need readings from, but it's all offline and we can't bring it up remotely.
	dprint ("Doctor Boyd: Ah!  Great!  We've got some gear that we need readings from, but it's all offline and we can't bring it up remotely.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_sitrep_00400'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_turnongear()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Doctor Boyd, send us the coordinates of your gear and I'll have Crimson power it up for you.
	dprint ("Miller: Doctor Boyd, send us the coordinates of your gear and I'll have Crimson power it up for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_turnongear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_turnongear_00100'));
	
	cui_hud_hide_radio_transmission_hud();

	sleep_s(2);
	b_end_player_goal = TRUE;
	sleep_s(1);
	
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );
	
	// Doctor Boyd : There you are.
	dprint ("Doctor Boyd: There you are.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_turnongear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_turnongear_00200'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_gear1on()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : That's one.  Let's get the rest of it.
	dprint ("Miller: That's one.  Let's get the rest of it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gear1on_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gear1on_00100'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_gearallon()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
			
	// Miller : Doctor Boyd, the equipment you requested is active.
	dprint ("Miller: Doctor Boyd, the equipment you requested is active.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gearallon_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gearallon_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : So I see!  Thank you so much…Oh, interesting.  These aren't power fluctuations at all.  These are slipspace signatures.
	dprint ("Doctor Boyd: So I see!  Thank you so much…Oh, interesting.  These aren't power fluctuations at all.  These are slipspace signatures.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gearallon_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gearallon_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Something's traveling through the planet's conduits.  Right towards your team as a matter of fact!
	dprint ("Doctor Boyd: Something's traveling through the planet's conduits.  Right towards your team as a matter of fact!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gearallon_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_gearallon_00300'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_badguys1()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "roland_transmission_name" );
		
	// Roland : Doctor Boyd was right!  Enemies appearing at Crimson's position!
	dprint ("Roland: Doctor Boyd was right!  Enemies appearing at Crimson's position!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_badguys1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_badguys1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Yeah, I see that, Roland.  Handle them, Crimson!
	dprint ("Miller: Yeah, I see that, Roland.  Handle them, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_badguys1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_badguys1_00200'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_defendgear()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;

	start_radio_transmission( "roland_transmission_name" );
		
	// Roland : They seem interested in Doctor Boyd's equipment.
	dprint ("Roland: They seem interested in Doctor Boyd's equipment.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendgear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendgear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Probably don't like us poling around their slipspace network.
	dprint ("Miller: Probably don't like us poling around their slipspace network.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendgear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendgear_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : We need that gear to remain intact! It's currently processing a large amount of data that MAY allow the UNSC to use the slipspace network.
	dprint ("Doctor Boyd: We need that gear to remain intact! It's currently processing a large amount of data that MAY allow the UNSC to use the slipspace network.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendthegear_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendthegear_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander Palmer's right. This is never easy.
	dprint ("Miller: Commander Palmer's right. This is never easy.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendthegear_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendthegear_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Okay, Crimson! Keep the science toys in one piece!
	dprint ("Miller: Okay, Crimson! Keep the science toys in one piece!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendthegear_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_defendthegear_00500'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_turnondevice()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );
		
	// Doctor Boyd : Spartans? My associate Doctor Ruiz suggests you could stop the slipspace raptures to your area by activating a device at this location.
	dprint ("Doctor Boyd: Spartans? My associate Doctor Ruiz suggests you could stop the slipspace raptures to your area by activating a device at this location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefivedead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefivedead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I'll take any chance we've got, Doc. Thanks. Crimson, painting a waypoint for you now.
	dprint ("Miller: I'll take any chance we've got, Doc. Thanks. Crimson, painting a waypoint for you now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefivedead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefivedead_00200'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_baddiesdead()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Did that work?
	dprint ("Miller: Did that work?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : It appears to, yes.
	dprint ("Roland: It appears to, yes.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Nice!  I got Crimson through this thing alive.  That's a good--
	dprint ("Miller: Nice!  I got Crimson through this thing alive.  That's a good--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	// Roland : Slipspace rupture detected.
	dprint ("Roland: Slipspace rupture detected.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : What?!
	dprint ("Miller: What?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_baddiesdead_00500'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_portalopen()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );
		
	// Doctor Boyd : Hello?  Spartans?  Doctor Boyd here.  The systems you protected have paid off.  We've figured out how to activate portals for you.
	dprint ("Doctor Boyd: Hello?  Spartans?  Doctor Boyd here.  The systems you protected have paid off.  We've figured out how to activate portals for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_portalopen_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_portalopen_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Crimson, go have a look.
	dprint ("Miller: Crimson, go have a look.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_portalopen_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_portalopen_00200'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_getinportal()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Confirmed, Doctor Boyd.  There is an open portal at Crimson's location.
	dprint ("Miller: Confirmed, Doctor Boyd.  There is an open portal at Crimson's location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Come on through!
	dprint ("Doctor Boyd: Come on through!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : What?!
	dprint ("Miller: What?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

	hud_play_pip_from_tag (bink\spops\ep5_m1_2_60);
	thread (pip_e5m1_2_subtitles());
	
	// Roland : Oh, jump in.  What's the worst that can happen?
	dprint ("Roland: Oh, jump in.  What's the worst that can happen?");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00400_pip'));
	
	end_radio_transmission();
	
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	
	e5m1_narrative_is_on = FALSE;
end

script static void pip_e5m1_2_subtitles()
	//sleep_s (0.29);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e5m1_getinportal_00400');
end

script dormant e5m1_vo_noboyhere()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : All clear for them.
	dprint ("Miller: All clear for them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Where are all the bad guys?
	dprint ("Miller: Where are all the bad guys?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00100'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end

script dormant e5m1_vo_defend_pause_1()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );
		
	// Doctor Boyd : Okay, hang on a moment... Got just a bit of signal noise I need to clear up...
	dprint ("Doctor Boyd: Okay, hang on a moment... Got just a bit of signal noise I need to clear up...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_waveonedead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_waveonedead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Please, hurry up, Doctor.
	dprint ("Miller: Please, hurry up, Doctor.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_waveonedead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_waveonedead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : There. The equipment is functioning properly again. Should take just a few minutes.
	dprint ("Doctor Boyd: There. The equipment is functioning properly again. Should take just a few minutes.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_waveonedead_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_waveonedead_00300'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end

script dormant e5m1_vo_defend_pause_2()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Doctor Boyd, give me an update. Are you almost done?
	dprint ("Miller: Doctor Boyd, give me an update. Are you almost done?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavetwodead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavetwodead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Good science is thorough, not fast.
	dprint ("Doctor Boyd: Good science is thorough, not fast.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavetwodead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavetwodead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I suggest finding a way to be both today, Doctor!
	dprint ("Miller: I suggest finding a way to be both today, Doctor!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavetwodead_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavetwodead_00300'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end

script dormant e5m1_vo_defend_pause_3()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );
		
	// Doctor Boyd : Well, that doesn't make any sense at all...
	dprint ("Doctor Boyd: Well, that doesn't make any sense at all...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I don't like the sound of that.
	dprint ("Miller: I don't like the sound of that.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : The results the gear is showing are either wildly inaccurate or we've just discovered a new field of slipspace math.
	dprint ("Doctor Boyd: The results the gear is showing are either wildly inaccurate or we've just discovered a new field of slipspace math.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Which one is it, Doctor Boyd?
	dprint ("Miller: Which one is it, Doctor Boyd?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : Keep the gear online a little longer and I'll be able to tell you.
	dprint ("Doctor Boyd: Keep the gear online a little longer and I'll be able to tell you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavethreedead_00500'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end

script dormant e5m1_vo_defend_pause_4()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "boyd_transmission_name" );
		
	// Doctor Boyd : Well, there goes my Nobel...
	dprint ("Doctor Boyd: Well, there goes my Nobel...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Doctor Boyd?
	dprint ("Miller: Doctor Boyd?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : It wasn't a grand discovery, one of the gravitational readouts was dialed by point five percent too much gravitational pressure.
	dprint ("Doctor Boyd: It wasn't a grand discovery, one of the gravitational readouts was dialed by point five percent too much gravitational pressure.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Doctor, I'm sorry, but I've had about enough of this.
	dprint ("Miller: Doctor, I'm sorry, but I've had about enough of this.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "boyd_transmission_name" );

	// Doctor Boyd : One moment. Doctor Ruiz is calling. I'll get back to you.
	dprint ("Doctor Boyd: One moment. Doctor Ruiz is calling. I'll get back to you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_01\e4m1_wavefourdead_00500'));
	
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


script dormant e5m1_vo_lose_one()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// // Miller : Crimson! Watch out!
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_8_00100'));
	cui_hud_hide_radio_transmission_hud();
	
	sleep (30);
	
	// Miller : That's one.
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100'));
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end

script dormant e5m1_vo_lose_two()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		// Miller : Crimson! Oh no!
	dprint ("Miller: Crimson! Oh no!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_9_00100'));
	cui_hud_hide_radio_transmission_hud();
	
	sleep (10);
	
	// Roland : Spartan Miller, emergency.
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
	dprint ("Roland: Spartan Miller, emergency.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00100'));
	cui_hud_hide_radio_transmission_hud();
	
	sleep (10);
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	// Miller : Confirmed.  Target hit and disabled.
	dprint ("Miller: Confirmed.  Target hit and disabled.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00300'));
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end

script dormant e5m1_vo_nice_work()
	sleep_until (e5m1_narrative_is_on == FALSE);
	e5m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		// Miller : Excellent work, Spartans.
	dprint ("Miller: Excellent work, Spartans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_cruiserboom_00300'));
	end_radio_transmission();
	
	e5m1_narrative_is_on = FALSE;
end


	
	
	
	
	
