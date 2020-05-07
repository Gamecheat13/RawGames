//=============================================================================================================================
//============================================ TEMPLE NARRATIVE SCRIPT ========================================================
//=============================================================================================================================

global boolean e2m5_narrative_is_on = FALSE;

// behold, the greatest narrative script ever to pass through the halls of 343...or 550...or whatever...it will be good anyway.

script startup sparops_e02_m05_main()
	
	dprint (":::  e2_m5 NARRATIVE SCRIPT  :::");
	
end

script static void e2m5_pup_narrative_in()
	// Ep 2 Mission 5 narrative in
	
	camera_control (true);

	fade_in (0, 0, 0, 120);
	
	camera_fov = 44;
	camera_pan (e2m5_in_01_1, e2m5_in_01_2, 300, 0, 1, 0, 1);
	sleep (300);
	
	camera_fov = 55;
	camera_pan (e2m5_in_02_1, e2m5_in_02_2, 300, 0, 1, 0, 1);
	sleep (210);
	
	fade_out (0, 0, 0, 90);
	sleep (91);
	
	camera_fov = 78;
	camera_control (false);
	//fade_in (0, 0, 0, 1);
	
	e2m5_narrativein_done = TRUE;
end

script static void e2m5_pup_narrative_out()

	ai_erase (sq_e2m5_out_marines);
	ai_place (sq_e2m5_out_marines);
	ai_erase (sq_e2m5_out_pelican1);
	ai_place (sq_e2m5_out_pelican1);
	
	pup_play_show(e2m5_narrative_out);

end


script command_script cs_e2m5_outro()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_vehicle_speed (.2); 
	
	cs_fly_by (ps_e2m5_pelican.p0);

end

//=============================================================================================================================
//==================================== TEMPLE Ep 02 Mission 05 VO scripts =====================================================
//=============================================================================================================================

//============================================	E2M5 Opening VO	===============================================================

script static void e2m5_tts_playstart()
	// gameplay has started
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	
	sleep (30 * 10);
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Awfully quiet down there. No sign of Gagarin or any hostile forces.
	dprint ("Miller: Awfully quiet down there. No sign of Gagarin or any hostile forces.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_playstart_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_playstart_00100'));

	sleep_until (e2m5_narrativein_done == TRUE);
	sleep (30 * 1);
	
	cui_hud_hide_radio_transmission_hud();
	
	// PIP
	hud_play_pip_from_tag (bink\spops\ep2_m5_1_60);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Yeah, but we know how that always goes.  Stay sharp, Crimson.
	dprint ("Palmer: Yeah, but we know how that always goes.  Stay sharp, Crimson.");
	// subtitle
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_playstart_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_playstart_00200_pip'));
	
	cui_hud_hide_radio_transmission_hud();
	// end PIP
		
	sleep (30 * 5);
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Here's a waypoint to Gagarin Team's last known location.
	dprint ("Miller: Here's a waypoint to Gagarin Team's last known location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_waypoints_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_waypoints_00100'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	f_blip_flag (e2m5_fl_backroom, default);
	thread (e2m5_afklolz());
	e2m5_narrative_is_on = FALSE;
	sleep (30 * 1);
	f_new_objective (e1_m4_objective_01);
end


script static void e2m5_tts_1stcpucallout()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson. Get a look at that computer.
	dprint ("Palmer: Crimson. Get a look at that computer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iffintro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iffintro_00100'));
	
	end_radio_transmission();
	
	device_set_power (e2m5_dogtag_01, 1);
	f_blip_flag (e2m5_fl_dogtag, default);
	e2m5_narrative_is_on = FALSE;
end

script static void e2m5_takingtoolong01()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : This is taking longer than I thought.
	dprint ("Miller: This is taking longer than I thought.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_3_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_3_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : What are you even doing?
	dprint ("Palmer: What are you even doing?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Crimson, go have a look.
	dprint ("Palmer: Crimson, go have a look.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00200'));
	
	end_radio_transmission();

	e2m5_narrative_is_on = FALSE;
end


//============================================	E2M5 1st IFF Playback	===============================================================

script static void e2m5_tts_iff01playback()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Let’s see what it recorded from the experiments here.
	dprint ("Palmer: Let’s see what it recorded from the experiments here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff01_00100'));
	
	cui_hud_hide_radio_transmission_hud();

	if (e2m5_rvb_is_on == TRUE)	then
		sleep (30 * 2);
		
		// RvB_Caboose : What does this button do?
		dprint ("RvB_Caboose: What does this button do?");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00200', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00200'));

		// RvB_Church : Caboose, don't touch anything.
		dprint ("RvB_Church: Caboose, don't touch anything.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00300', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00300'));

		// RvB_Caboose : But I'm great at buttons.
		dprint ("RvB_Caboose: But I'm great at buttons.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00400', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00400'));

		// RvB_Caboose : Hey look at that explosion.
		dprint ("RvB_Caboose: Hey look at that explosion.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00500', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff01_00500'));	
		
	else
		sleep (30 * 1);

		// SoundStory : [e2m5_scientist_01] Are you sure about this? We haven't run enough tests.[e2m5_scientist_02] AAAGGGHH! Nooooooo!
		dprint ("SoundStory: [e2m5_scientist_01] Are you sure about this? We haven't run enough tests.[e2m5_scientist_02] AAAGGGHH! Nooooooo!");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff01_00200_soundstory', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff01_00200_soundstory'));
		
	end
	sleep (30 * 2);
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Well that's no good.
	dprint ("Palmer: Well that's no good.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff01_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff01_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Commander, Crimson's near something that wasn't active before.
	dprint ("Miller: Commander, Crimson's near something that wasn't active before.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Yes, and?
	dprint ("Palmer: Yes, and?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Science believes Gagarin team activated it.
	dprint ("Miller: Science believes Gagarin team activated it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00110', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00110'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Then Crimson’s gonna turn it off. Get to it.
	dprint ("Palmer: Then Crimson’s gonna turn it off. Get to it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00120', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00120'));
	
	end_radio_transmission();

	e2m5_obj_shutdown2_threaded();
	
	e2m5_narrative_is_on = FALSE;
end


script static void e2m5_tts_unsctech()

	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
// Palmer : UNSC tech's all still in place.
	dprint ("Palmer: UNSC tech's all still in place.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_unscstuff_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_unscstuff_00100'));
	
	end_radio_transmission();

	e2m5_narrative_is_on = FALSE;
end


//============================================	E2M5 First Set of Switches	===============================================================

script static void e2m5_tts_hurryup01()
	
// hurry up on the switches
	sleep_until (e2m5_narrative_is_on == FALSE);
	if (e2m5_switchesdown < 2)	then
		
		e2m5_narrative_is_on = TRUE;
		
		start_radio_transmission( "palmer_transmission_name" );
	
		// Palmer : Go head and flip those switches, Crimson.
		dprint ("Palmer: Go head and flip those switches, Crimson.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheshurry_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheshurry_00100'));
	
		e2m5_narrative_is_on = FALSE;	
	
	else	(sleep (30 * 1));
	end
	
	end_radio_transmission();
	
end


script static void e2m5_tts_hurryup02()
// really hurry up on switches
	sleep_until (e2m5_narrative_is_on == FALSE);
	if (e2m5_switchesdown < 2)	then
	
	e2m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, do I have to send someone else down?  Someone with a PHd in light switches, maybe?
	dprint ("Palmer: Crimson, do I have to send someone else down?  Someone with a PHd in light switches, maybe?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheshurryup_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheshurryup_00100'));
	
	end_radio_transmission();

	e2m5_narrative_is_on = FALSE;	
	
	else	(sleep (30 * 1));
	end
end


script static void e2m5_tts_badguys01()
	// first wave of baddies
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	
	// PIP
	start_radio_transmission( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep2_m5_2_60);
	
	// Palmer : See, I told you there'd be things to shoot.  Happy Birthday, Crimson.
	dprint ("Palmer: See, I told you there'd be things to shoot.  Happy Birthday, Crimson.");
	// subtitle
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_badguys01_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_badguys01_00100_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e2m5_narrative_is_on = FALSE;
end

//============================================	E2M5 First Set of Switches Hit	===============================================================

script static void e2m5_tts_2switcheson()
	// switches are all on
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	thread (e2m5_objcomplete_threaded());
	sleep (30 * 2);
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Well?
	dprint ("Palmer: Well?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Everything seems okay.
	dprint ("Miller: Everything seems okay.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	//	Palmer : What's Science say?
	dprint ("Palmer: What's Science say?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00300'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : All clear for them.
	dprint ("Miller: All clear for them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00400'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	

	e2m5_narrative_is_on = FALSE;
	sleep (10);
	e2m5_whatssciencesay = TRUE;
end


script static void e2m5_tts_enemycallout_01()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	
	start_radio_transmission( "miller_transmission_name" );
	
// Miller : Lots of activity nearby. Be ready for anything, Crimson.
	dprint ("Miller: Lots of activity nearby. Be ready for anything, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_3_00100'));
	
	end_radio_transmission();

	sleep (30 * 2);
	f_blip_flag (e2m5_fl_encounterflag01, navpoint_goto);
	e2m5_narrative_is_on = FALSE;
	sleep_until (volume_test_players (e2m5_tv_enemycalloout01), 1);
	sleep (30 * 1);
	f_unblip_flag (e2m5_fl_encounterflag01);
end


script static void e2m5_tts_anothertag()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	sleep (30 * 2);

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander – there’s another one of Gagarin’s computers.
	dprint ("Miller: Commander – there’s another one of Gagarin’s computers.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Have a look, Crimson.
	dprint ("Palmer: Have a look, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00200'));
	
	end_radio_transmission();

	device_set_power (e2m5_dogtag_02, 1);
	f_blip_flag (e2m5_fl_dogtag02, default);
	e2m5_narrative_is_on = FALSE;
end


//============================================	E2M5 Second IFF Tag Playback	===============================================================

script static void e2m5_tts_iff02()
	// second IFF recording_kill
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	
	if (e2m5_rvb_is_on == TRUE)	then
		// RvB_Church : Oh great!  You broke it!
		dprint ("RvB_Church: Oh great!  You broke it!");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff02_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff02_00100'));

		// RvB_Caboose : The fire broke it!  Oh see. Oh great, now I'm on fire, too now. Awesome.
		dprint ("RvB_Caboose: The fire broke it!  Oh see. Oh great, now I'm on fire, too now. Awesome.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff02_00200', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff02_00200'));
		
	else	
		// SoundStory : [e2m5_scientist_03] Turn it off!  Turn it off!  [e2m5_scientist_04] It's too late!
		dprint ("SoundStory: [e2m5_scientist_03] Turn it off!  Turn it off! [e2m5_scientist_04] It's too late!");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02_00100_soundstory', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02_00100_soundstory'));


	end
	sleep (30 * 2);	
	
	cui_hud_hide_radio_transmission_hud();
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : What the hell happened down there?
	dprint ("Palmer: What the hell happened down there?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00300'));
	
	end_radio_transmission();

	e2m5_narrative_is_on = FALSE;
end

script static void e2m5_tts_badguys02()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : More bad guys!
	dprint ("Miller: More bad guys!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_1_00100'));
	
	end_radio_transmission();

	e2m5_narrative_is_on = FALSE;
end

script static void e2m5_tts_anythingelse()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	
	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Miller, is there anything else Gagarin Team turned on?
	dprint ("Palmer: Miller, is there anything else Gagarin Team turned on?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_2ndlocale_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_2ndlocale_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : There's a power reading that wasn't there last time Crimson was in house.  Painting a waypoint on it now.
	dprint ("Miller: There's a power reading that wasn't there last time Crimson was in house.  Painting a waypoint on it now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_2ndlocale_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_2ndlocale_00200'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	
	e2m5_narrative_is_on = FALSE;
end

//============================================	E2M5 Second Switch Hit	===============================================================
script static void e2m5_tts_nicework()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );

// Palmer : Nice work, Crimson.
	dprint ("Palmer: Nice work, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_2_00100'));
	
	end_radio_transmission();

	e2m5_narrative_is_on = FALSE;
end

script static void e2m5_tts_moreenemiescallout()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watch out for the Crawlers. They're everywhere.
	dprint ("Miller: Watch out for the Crawlers. They're everywhere.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_4_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Where's the cannon fodder, Miller?
	dprint ("Palmer: Where's the cannon fodder, Miller?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_9_00100'));
	
	end_radio_transmission();
	sleep (30 * 1);
	
	f_blip_flag (e2m5_fl_encounterflag01, default);
	e2m5_narrative_is_on = FALSE;
	f_blip_ai_cui (e2m5_ff_all, "navpoint_enemy");
	sleep_until (volume_test_players (e2m5_tv_enemycalloout01), 1);
	sleep (30 * 1);
	f_unblip_flag (e2m5_fl_encounterflag01);
end


script static void e2m5_tts_iff03seen()
	// close to IFF 3
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	thread (e2m5_objcomplete_threaded());
	f_unblip_flag (e2m5_fl_encounterflag01);
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Show 'em where to go, Miller.
	dprint ("Palmer: Show 'em where to go, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_2portalsopen_00400'));
	
	end_radio_transmission();
	
	device_set_power (e2m5_dogtag_03, 1);
	f_blip_flag (e2m5_fl_dogtag03, default);
	
	e2m5_narrative_is_on = FALSE;
end

//============================================	E2M5 Third IFF Playback	===============================================================

script static void e2m5_tts_iff03()
	// IFF 3 recording_kill
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Let’s see what it’s got.
	dprint ("Palmer: Let’s see what it’s got.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff03seen_00110', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff03seen_00110'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	
	if (e2m5_rvb_is_on == TRUE)	then
		// RvB_Grif : Hey Simmons, what do you think this machine does?
		dprint ("RvB_Grif: Hey Simmons, what do you think this machine does?");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00100', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00100'));

		// RvB_Simmons : How would I know?  It's a forty-foot seemless monolith with one massive holographic button.
		dprint ("RvB_Simmons: How would I know?  It's a forty-foot seemless monolith with one massive holographic button.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00200', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00200'));

		// RvB_Simmons : It could be anything from a giant microwave oven to a weapon with enough power to--
		dprint ("RvB_Simmons: It could be anything from a giant microwave oven to a weapon with enough power to--");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00300', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00300'));

		////3434343434343434343434	SCIENTIST SCREAM SFX NEEDED HERE	////34343434343343434343434343434
	
		// RvB_Simmons : Hey. Is that Caboose?
		dprint ("RvB_Simmons: Hey. Is that Caboose?");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00400', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00400'));

		// RvB_Grif : Probably.  He's on fire.
		dprint ("RvB_Grif: Probably.  He's on fire.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00500', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\rvb_e2m5_iff03_00500'));
	
	else
		
		// SoundStory : [e2m5_scientist_05] I don't know what all the fuss is about.  [e2m5_scientist_06] We're turning on dormant technology we don't know the first thing about.  We're like monkeys hammering on a nuclear bomb because we like the sound it makes. What was that?  [e2m5_scientist_05] I don't know--
		dprint ("SoundStory: [e2m5_scientist_05] I don't know what all the fuss is about.  [e2m5_scientist_06] We're turning on dormant technology we don't know the first thing about.  We're like monkeys hammering on a nuclear bomb because we like the sound it makes. What was that?  [e2m5_scientist_05] I don't know--");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff03_00100_soundstory', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff03_00100_soundstory'));
		
	end
	
		sleep (30 * 3);
		
	cui_hud_hide_radio_transmission_hud();
	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Alright, Crimson.  Shut it all down and I'll get a team of professionals to go in and figure out what Gargarin turned on.
	dprint ("Palmer: Alright, Crimson.  Shut it all down and I'll get a team of professionals to go in and figure out what Gargarin turned on.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff03_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff03_00500'));
	
	end_radio_transmission();
	
	e2m5_narrative_is_on = FALSE;
end

//============================================	E2M5 Third Set of Switches Start	===============================================================

script static void e2m5_tts_switchesping02()
	// ping the second switches
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Looks like there are four sources of power for this piece.  Marking them for you now, Crimson.
	dprint ("Miller: Looks like there are four sources of power for this piece.  Marking them for you now, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switchesping02_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switchesping02_00100'));
	
	end_radio_transmission();
	
	thread (e2m5_obj_shutdown2_threaded());
	e2m5_narrative_is_on = FALSE;
end

script static void e2m5_tts_almostthere()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Almost there...
	dprint ("Miller: Almost there...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_7_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_7_00200'));
	
	end_radio_transmission();

	e2m5_narrative_is_on = FALSE;
end


//============================================	E2M5 Third Set of Switches Hit	===============================================================

script static void e2m5_tts_clearallenemies
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	thread (e2m5_objcomplete_threaded());
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : That did it!
	dprint ("Miller: That did it!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_7_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Crimson, finish clearing the area, and we’ll get you a ride out.
	dprint ("Palmer: Crimson, finish clearing the area, and we’ll get you a ride out.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_clearout_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_clearout_00100'));
	
	end_radio_transmission();

	f_new_objective (e2m5_cleanup);
	e2m5_narrative_is_on = FALSE;
end

script static void e2m5_tts_lastenemiescallout()
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : There's still some Prometheans left to clear out. Marking them now.
	dprint ("Miller: There's still some Prometheans left to clear out. Marking them now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_5_00100'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	f_blip_ai_cui (sq_e2m5_1kni_04, "navpoint_enemy");
	sleep (30 * 2);
	f_blip_ai_cui (sq_e2m5_10paw_02, "navpoint_enemy");
	e2m5_narrative_is_on = FALSE;
end

//============================================	E2M5 All Enemies Cleared	===============================================================

script static void e2m5_tts_gettolz()
	// get to the Landing Zone
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	thread (e2m5_objcomplete_threaded());
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : It's all clear down there, Commander.
	dprint ("Miller: It's all clear down there, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_gettolz_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_gettolz_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	hud_play_pip_from_tag (bink\spops\ep2_m5_3_60);
	
	// Palmer : Good work, Crimson.  Fall back to the LZ.  Marines are headed your way to hold down the fort until another science team can be brought in.
	dprint ("Palmer: Good work, Crimson.  Fall back to the LZ.  Marines are headed your way to hold down the fort until another science team can be brought in.");
	// subtitle
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_gettolz_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_gettolz_00200_pip'));
	
	end_radio_transmission();
	// end PIP

	thread (e2m5_obj_lz_threaded());
	b_wait_for_narrative_hud = FALSE;
	e2m5_narrative_is_on = FALSE;
end

//============================================	E2M5 Ending Puppeteer VO	===============================================================

script static void e2m5_tts_out()
	// for e2m5 outro
	sleep_until (e2m5_narrative_is_on == FALSE);
	e2m5_narrative_is_on = TRUE;	
	thread (e2m5_objcomplete_threaded());
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, I've been thinking.
	dprint ("Miller: Commander, I've been thinking.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Oh, do tell.
	dprint ("Palmer: Oh, do tell.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Maybe the same thing that happened to Doctor Glassman happened to Gargarin Team?
	dprint ("Miller: Maybe the same thing that happened to Doctor Glassman happened to Gargarin Team?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00300'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : That's above your pay grade, Miller.
	dprint ("Palmer: That's above your pay grade, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_out_00400'));
	
	end_radio_transmission();
	
	sleep (30 * 2);
	e2m5_narrative_is_on = FALSE;
end

//============================================	E2M5 Unused VO	===============================================================

//old dialogue

	//	Miller : So no Covenant raiding parties.
	//	dprint ("Miller: So no Covenant raiding parties.");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_unscstuff_00200', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_unscstuff_00200'));

	//	Palmer : Not that Prometheans have been known to swipe human tech either.
	//	dprint ("Palmer: Not that Prometheans have been known to swipe human tech either.");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_unscstuff_00300', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_unscstuff_00300'));

	//	Palmer : Yes, and?
	//	dprint ("Palmer: Yes, and?");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00200', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_pingswitches_00200'));
	
	//	Palmer : Well?
	//	dprint ("Palmer: Well?");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00100', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00100'));

	//	Miller : Everything seems okay.
	//	dprint ("Miller: Everything seems okay.");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00200', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_switcheson_00200'));
	
	//	Palmer : Have a look, Crimson.
	//	dprint ("Palmer: Have a look, Crimson.");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00200', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00200'));
	
	//	Palmer : What the hell happened down there?
	//	dprint ("Palmer: What the hell happened down there?");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00300', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_iff02seen_00300'));
	
	//	Miller : It's all clear down there, Commander.
	//	dprint ("Miller: It's all clear down there, Commander.");
	//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_gettolz_00100', NONE, 1);
	//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_05\e2m5_gettolz_00100'));
