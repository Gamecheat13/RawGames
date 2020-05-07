//=============================================================================================================================
//============================================ VALHALLA NARRATIVE SCRIPT ===================================================
//=============================================================================================================================


// behold, the 2nd greatest narrative script ever to pass through the halls of 343....


script startup sparops_e03_m03_main()
	
	dprint (":::  NARRATIVE SCRIPT  :::");
	
end


script static void ex1()
	//fires e1 m2 Narrative In scene
	
	ai_erase (squads_0);
	ai_erase (squads_1);
	ai_place (squads_0);
	ai_place (squads_1);
	
	pup_play_show(e1_m4_narrative_in);
	
end


script static void ex4()
	// play the e4 m2 narrative In
	
	object_destroy (e4m2_hog_1);
	object_destroy (e4m2_hog_2);
	ai_erase (sq_e4m2_marines);
	ai_place (sq_e4m2_marines);
	
	pup_play_show (pup_e4m2_in);
	
end


script command_script cs_e3m3_intro()
	// e3m3 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
//	cs_vehicle_speed (1.0); 
	
	cs_fly_by (ps_e3m3_in.p0);

end


script static void e3m3_narrative_in()
	//plays Ep 3 Mission 3 narrative in
	
	camera_control (true);
	fade_in (0, 0, 0, 90);
	
	camera_fov = 65;
	camera_pan (e3m3_in_01_1, e3m3_in_01_2, 300, 0, 1, 250, 0);
	
	sleep (120);
	ai_place (sq_e3m3_pelican);
	
	sleep (120);
	camera_fov = 65;
	camera_pan (e3m3_in_02_1, e3m3_in_02_2, 280, 0, 1, 0, 1);
	
	sleep (120);
	camera_fov = 33;
	ai_erase (sq_e3m3_pelican);
	camera_pan (e3m3_in_03_1, e3m3_in_03_2, 280, 0, 1, 0, 1);
	
	sleep (180);
	fade_out (0, 0, 0, 90);
	
	sleep (90);
	camera_fov = 78;
	fade_in (0, 0, 0, 1);
	camera_control (false);
	
	//signaling the end of the vignette
	b_wait_for_narrative = false;
	
end


script static void e3m4_narrative_in()
	// fires Ep 3 Mission 4 narrative in
	
//	camera_control (true);
//	fade_in (0, 0, 0, 90);
//	
//	camera_fov = 65;
//	camera_pan (e3m4_in_01_1, e3m4_in_01_2, 300, 0, 1, 0, 1);
//	sleep (210);
//	
//	camera_fov = 65;
//	camera_pan (e3m4_in_02_1, e3m4_in_02_2, 280, 0, 1, 0, 1);
//	sleep (250);
//	
//	fade_out (0, 0, 0, 30);
//	sleep (90);
//	
//	camera_fov = 78;
//	fade_in (0, 0, 0, 1);
//	camera_control (false);
	
	//signaling the end of the vignette
	b_wait_for_e3m4narrative = false;
	
end


script static void ex2()
	//fires e3 m3 Narrative In scene
	
	ai_erase (sq_e3m3_pelican);
	
	thread (e3m3_narrative_in());
	
end


script command_script cs_e3m4_mantis_pelican_1()
	// pelican leaves in cutscene
	
	cs_vehicle_speed (1.0);

	cs_fly_to (ps_e3m4_mantis.p1);
	
end


script command_script cs_e3m4_mantis_pelican_2()
	// pelican leaves in cutscene
	
	cs_vehicle_speed (1.0);

	cs_fly_to (ps_e3m4_mantis.p2);
	
end


script command_script cs_e3m4_mantis_pelican_3()
	// pelican leaves in cutscene
	
	cs_vehicle_speed (1.0);

	cs_fly_to (ps_e3m4_mantis.p3);
	
end


script command_script cs_e3m4_mantis_pelican_4()
	// pelican leaves in cutscene
	
	cs_vehicle_speed (1.0);

	cs_fly_to (ps_e3m4_mantis.p4);
	
end


script static void e3m4_mantis_4p()
	// plays 4 player mantis drop scene
	
	camera_control (true);
	fade_in (0, 0, 0, 60);
	
	camera_fov = 22;
	camera_pan (e3m4_mantis_01_1, e3m4_mantis_01_2, 300, 0, 1, 0, 1);
	
	ai_place (sq_e3m4_mantis_pelican_1);
	object_create (e3m4_scene_mantis_1);
	objects_attach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_1.spawn_points_0)), "pelican_sc_01", e3m4_scene_mantis_1, "nav_point");

	sleep (60);
	
	ai_place (sq_e3m4_mantis_pelican_2);
	object_create (e3m4_scene_mantis_2);
	objects_attach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_2.spawn_points_0)), "pelican_sc_01", e3m4_scene_mantis_2, "nav_point");
	sleep (15);
	
	ai_place (sq_e3m4_mantis_pelican_3);
	object_create (e3m4_scene_mantis_3);
	objects_attach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_3.spawn_points_0)), "pelican_sc_01", e3m4_scene_mantis_3, "nav_point");
	sleep (15);
	
	ai_place (sq_e3m4_mantis_pelican_4);
	object_create (e3m4_scene_mantis_4);
	objects_attach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_4.spawn_points_0)), "pelican_sc_01", e3m4_scene_mantis_4, "nav_point");
	sleep (90);
	
	camera_fov = 33;
	camera_pan (e3m4_mantis_02_1, e3m4_mantis_02_2, 300, 0, 1, 0, 1);
	
	sleep (105);
	
	camera_fov = 90;
	camera_pan (e3m4_mantis_03_1, e3m4_mantis_03_2, 85, 10, 0.5, 0, 1);
	objects_detach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_1.spawn_points_0)), e3m4_scene_mantis_1);
	
	sleep (50);
	objects_detach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_2.spawn_points_0)), e3m4_scene_mantis_2);
	
	sleep (30);
	objects_detach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_3.spawn_points_0)), e3m4_scene_mantis_3);
	objects_detach ((ai_vehicle_get_from_spawn_point (sq_e3m4_mantis_pelican_4.spawn_points_0)), e3m4_scene_mantis_4);
	
	fade_in (0, 0, 0, 1);
	camera_fov = 78;
	camera_control (false);
	
	ai_erase (sq_e3m4_mantis_pelican_1);
	object_create_anew (e3m4_scene_mantis_1);
	ai_erase (sq_e3m4_mantis_pelican_2);
	object_create_anew (e3m4_scene_mantis_2);
	ai_erase (sq_e3m4_mantis_pelican_3);
	object_create_anew (e3m4_scene_mantis_3);
	ai_erase (sq_e3m4_mantis_pelican_4);
	object_create_anew (e3m4_scene_mantis_4);
	
	fade_in (0, 0, 0, 1);
	camera_fov = 78;
	camera_control (false);
	
end


//=============================================================================================================================
//======================================= VALHALLA Ep 03 Mission 03 VO scripts ================================================
//=============================================================================================================================


script dormant e3m3_vo_intro()
	// intro
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
//	// Miller : Comms are online.  Good morning, Crimson
//	dprint ("Miller: Comms are online.  Good morning, Crimson");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00100'));
//
//	// Miller : Commander, Crimson's on approach to Mountain's last known location.  Boots on the ground in 30.
//	dprint ("Miller: Commander, Crimson's on approach to Mountain's last known location.  Boots on the ground in 30.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00200'));

//	// Palmer : Got it, Miller.
//	dprint ("Palmer: Got it, Miller.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00300'));

	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Crimson, straight-up rescue op here.  You're aiding Mountain Squad, a science attaché that got shot down following our mystery signal.
	dprint ("Palmer: Crimson, straight-up rescue op here.  You're aiding Mountain Squad, a science attaché that got shot down following our mystery signal.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00400'));
	
	sleep (15);

	// Palmer : As of last transmission, they're under heavy fire.  Land as close as you can, then double-time it to their position.
	dprint ("Palmer: As of last transmission, they're under heavy fire.  Land as close as you can, then double-time it to their position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_intro_00500'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_playstart()
	//gameplay starts
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller, paint Mountain's last known for Crimson.  And--
	dprint ("Palmer: Miller, paint Mountain's last known for Crimson.  And--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_playstart_00100_soundstory', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_playstart_00100_soundstory'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_topelican()
	//get to pelican
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson, do you read?
	dprint ("Palmer: Crimson, do you read?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_topelican_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_topelican_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Something's jamming our signal.
	dprint ("Miller: Something's jamming our signal.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_topelican_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_topelican_00200'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_atpelican()
	//at the pelican
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "e3m3_marine_1_transmission_name" );
	
	// e3m3_marine_01 : Look!
	dprint ("e3m3_marine_01: Look!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_atpelican_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_atpelican_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "e3m3_marine_2_transmission_name" );

	// e3m3_marine_02 : Holy --.  Man, are we glad to see you!
	dprint ("e3m3_marine_02: Holy --.  Man, are we glad to see you!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_atpelican_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_atpelican_00200'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_clearsite()
	//clear the site
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "e3m3_marine_1_transmission_name" );
	
	// e3m3_marine_01 : Our whole plan here, if you don't mind me saying, is shoot anything that moves.  If you've got better tactics, I'm willing to follow 'em!
	dprint ("e3m3_marine_01: Our whole plan here, if you don't mind me saying, is shoot anything that moves.  If you've got better tactics, I'm willing to follow 'em!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_clearsite_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_clearsite_00100'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
	
end


script dormant e3m3_vo_savedmarines()
	//saved the marines
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "e3m3_marine_1_transmission_name" );
	
	// e3m3_marine_01 : I don't know what we'd have done if you didn't show up.
	dprint ("e3m3_marine_01: I don't know what we'd have done if you didn't show up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_savedmarines_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_savedmarines_00100'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_getcovloot()
	//get the Covenant loot
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "e3m3_marine_2_transmission_name" );
	
	// e3m3_marine_02 : Covvies have a signal jammer set up over there.  We didn't know if Infinity heard any of our distress calls.
	dprint ("e3m3_marine_02: Covvies have a signal jammer set up over there.  We didn't know if Infinity heard any of our distress calls.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_getcovloot_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_getcovloot_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "e3m3_marine_1_transmission_name" );

	// e3m3_marine_01 : Hell, now that we've got backup, I think we can take it.
	dprint ("e3m3_marine_01: Hell, now that we've got backup, I think we can take it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_getcovloot_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_getcovloot_00200'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_targetshield()
	//target the shield
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "e3m3_marine_2_transmission_name" );
	
	// e3m3_marine_02 : Covenant jammers are behind those shields.
	dprint ("e3m3_marine_02: Covenant jammers are behind those shields.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_targetshield_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_targetshield_00100'));
	
	end_radio_transmission();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "e3m3_marine_1_transmission_name" );
//
//	// e3m3_marine_01 : Let's get 'em!
//	dprint ("e3m3_marine_01: Let's get 'em!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_targetshield_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_targetshield_00200'));
//	
//	cui_hud_hide_radio_transmission_hud();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_shieldsdown()
	//shields are down
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "e3m3_marine_1_transmission_name" );
	
	// e3m3_marine_01 : Shield's down!
	dprint ("e3m3_marine_01: Shield's down!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shieldsdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shieldsdown_00100'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_destroyjammers()
	//destroy the jammers
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "e3m3_marine_2_transmission_name" );
	
	// e3m3_marine_02 : There're the jammers!  Get 'em!
	dprint ("e3m3_marine_02: There're the jammers!  Get 'em!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_destroyjammers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_destroyjammers_00100'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_1jammerdown()
	// one jammer is down
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : IFF tags are back.
	dprint ("Miller: IFF tags are back.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_1jammerdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_1jammerdown_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson?  Respond.
	dprint ("Palmer: Crimson?  Respond.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_1jammerdown_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_1jammerdown_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I see the IFF too, but I don't hear anything.
	dprint ("Palmer: I see the IFF too, but I don't hear anything.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_1jammerdown_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_1jammerdown_00300'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_2jammerdown()
	// one jammer is down
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson, there you are!
	dprint ("Palmer: Crimson, there you are!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_2jammerdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_2jammerdown_00100'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_marinesalive()
	//marines survived
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Good work pulling Mountain out of the fire.
	dprint ("Palmer: Good work pulling Mountain out of the fire.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesalive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesalive_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "e3m3_marine_1_transmission_name" );

	// e3m3_marine_01 : Couldn't have done it on our own, Commander.
	dprint ("e3m3_marine_01: Couldn't have done it on our own, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesalive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesalive_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, as long as you're there, you can help Mountain complete their mission.
	dprint ("Palmer: Crimson, as long as you're there, you can help Mountain complete their mission.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesalive_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesalive_00300'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_marinesdead()
	//marines are dead
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Shame Mountain couldn't make it.  At least you're still on your feet, so you can finish their mission for them.
	dprint ("Palmer: Shame Mountain couldn't make it.  At least you're still on your feet, so you can finish their mission for them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesdead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_marinesdead_00100'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_findcontrols()
	//find the controls
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Infinity Science wants a look inside one of those towers.  Get those shields offline while I go round up our resident signal expert.
	dprint ("Palmer: Infinity Science wants a look inside one of those towers.  Get those shields offline while I go round up our resident signal expert.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_findcontrols_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_findcontrols_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	
	light_up_shields();
	
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Crimson, I'm painting waypoints for the shield generators.
	dprint ("Miller: Crimson, I'm painting waypoints for the shield generators.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_findcontrols_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_findcontrols_00200'));
	
	end_radio_transmission();
	
	b_end_player_goal = TRUE;
	e3m3_narrative_is_on = FALSE;
	notifylevel ("e3_m3_switch_2");
end

script static void e3_m3_switch1()
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	// first switch done

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : That's one.
	dprint ("Miller: That's one.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100'));
	
	end_radio_transmission();
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_shielddown2()
	//second shield down
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, Crimson has the shields down.
	dprint ("Miller: Commander, Crimson has the shields down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00100'));
	
	cui_hud_hide_radio_transmission_hud();
		
	enemies_dead_1();
	

	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Good work.  Bringing our expert online now.  She likes to take charge, but my advice is that you ignore her as I'm the one who signs your paychecks.
	dprint ("Palmer: Good work.  Bringing our expert online now.  She likes to take charge, but my advice is that you ignore her as I'm the one who signs your paychecks.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Are you there, Doctor?
	dprint ("Palmer: Are you there, Doctor?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "halsey_transmission_name" );

	// Halsey : Yes.  Have they reached the location of interest?
	dprint ("Halsey: Yes.  Have they reached the location of interest?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_shielddown_2_00400'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_entertower()
	//enter the towers
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : On their way now.
	dprint ("Palmer: On their way now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_entertower_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_entertower_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, head for the waypoint.
	dprint ("Palmer: Crimson, head for the waypoint.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_entertower_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_entertower_00200'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_halsey()
	//Halsey discussion
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : What should they be looking for, Doctor?
	dprint ("Palmer: What should they be looking for, Doctor?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "halsey_transmission_name" );

	// Halsey : Their armor sees enough.  I'm watching the environment scans.
	dprint ("Halsey: Their armor sees enough.  I'm watching the environment scans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : So what do you see?
	dprint ("Palmer: So what do you see?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "halsey_transmission_name" );

	// Halsey : There.  That location.  I need a closer look.
	dprint ("Halsey: There.  That location.  I need a closer look.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Miller, light it up.
	dprint ("Palmer: Miller, light it up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00500'));
	
	navpoint_track_object_named(fore_water_base_thing, "navpoint_goto");
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep3_m3_1_60);

	// Palmer : Crimson, get close.  Don't touch anything.
	dprint ("Palmer: Crimson, get close.  Don't touch anything.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00600', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_halsey_00600_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_activatetech()
	//activated the tech
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "halsey_transmission_name" );
	
	// Halsey : I suggest activating the device.
	dprint ("Halsey: I suggest activating the device.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00100'));
	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//
//	// Palmer : Why?  What will it do?
//	dprint ("Palmer: Why?  What will it do?");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00200'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "halsey_transmission_name" );
//
//	// Halsey : It's operating on the same harmonic array as the artifact--
//	dprint ("Halsey: It's operating on the same harmonic array as the artifact--");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00300'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//
//	// Palmer : Classified, Doctor
//	dprint ("Palmer: Classified, Doctor");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00400', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00400'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "halsey_transmission_name" );

	// Halsey : It's either the source of the signal we're tracking, or it's the destination.  I suggest activating it and finding out.
	dprint ("Halsey: It's either the source of the signal we're tracking, or it's the destination.  I suggest activating it and finding out.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	
	// PIP
	hud_play_pip_from_tag (bink\spops\ep3_m3_2_60);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Hmmm.
	// Palmer : Crimson.  Do it.
	dprint ("Palmer: Hmmm.");
	dprint ("Palmer: Crimson.  Do it.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00600', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00700', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_activatetech_00600_pip'));

	b_wait_for_narrative_hud = false;
	end_radio_transmission();
	// end PIP
	
	notifylevel ("e3_m3_switch_3");
	e3m3_narrative_is_on = FALSE;
end


script dormant e3m3_vo_lightshow()
	//for the lightshow
	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Oh, wow!
	dprint ("Miller: Oh, wow!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Doctor Halsey what the hell is that?!
	dprint ("Palmer: Doctor Halsey what the hell is that?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "halsey_transmission_name" );

	// Halsey : Oh my!  I'll need some of Roland's cycles for translating, but it looks like navigation data.  Communications protocols.
	dprint ("Halsey: Oh my!  I'll need some of Roland's cycles for translating, but it looks like navigation data.  Communications protocols.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "halsey_transmission_name" );

	// Halsey : This is going to take some time to sort through.
	dprint ("Halsey: This is going to take some time to sort through.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander!  We don't have
	dprint ("Miller: Commander!  We don't have");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Explain.
	dprint ("Palmer: Explain.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00600'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Covenant forces approaching Crimson's position!  Lots of them!
	dprint ("Miller: Covenant forces approaching Crimson's position!  Lots of them!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00700'));
	
	enemies_dead();	
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep3_m3_3_60);

	// Palmer : Crimson, fall back to Mountain's Pelican.  There should be armaments there to help you.
	dprint ("Palmer: Crimson, fall back to Mountain's Pelican.  There should be armaments there to help you.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00800', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00800_pip'));
	
	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I'll get Dalton on the line, and we'll be back with you momentarily
	dprint ("Palmer: I'll get Dalton on the line, and we'll be back with you momentarily");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00900', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_03\e3m3_lightshow_00900'));
	
	end_radio_transmission();
	
	e3m3_narrative_is_on = FALSE;
end


//=============================================================================================================================
//======================================= VALHALLA Ep 03 Mission 04 VO scripts ================================================
//=============================================================================================================================


script dormant e3m4_vo_playstart()
	//gameplay starts
	e3m4_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Heavy Covenant forces headed toward Crimson's position, Commander Palmer.
	dprint ("Miller: Heavy Covenant forces headed toward Crimson's position, Commander Palmer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_playstart_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_playstart_00100'));
	
	end_radio_transmission();
	
	e3m4_narrative_is_on = FALSE;
	
end


script dormant e3m4_vo_marinereveal()
	//marine reveal
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Marines have retrieved turrets from the Pelican and deployed--
	dprint ("Miller: Marines have retrieved turrets from the Pelican and deployed--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_marinereveal_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_marinereveal_00100'));
	
	end_radio_transmission();
	
	e3m4_narrative_is_on = FALSE;
	
end


script dormant e3m4_vo_marineshot()
	//marine is shot
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Sniper fire!  Marine down!
	dprint ("Miller: Sniper fire!  Marine down!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_marineshot_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_marineshot_00100'));
	
	end_radio_transmission();
	
	e3m4_narrative_is_on = FALSE;
end


script dormant e3m4_vo_hellbreaks()
	//all hell breaks loose
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson!  Get those turrets activated!  Now!
	dprint ("Palmer: Crimson!  Get those turrets activated!  Now!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00100'));
	
	sleep_s (1);
	f_new_objective (e3_m4_d_3);
	b_wait_for_narrative_hud = false;
//	f_power_up_switches_e3_m4();
	NotifyLevel ("start_turrets");
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I need a proper assessment on enemy forces, Miller.
	dprint ("Palmer: I need a proper assessment on enemy forces, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Considerable, Commander.
	dprint ("Miller: Considerable, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00300'));
	
	end_radio_transmission();

	e3m4_narrative_is_on = FALSE;
	
end


script dormant e3m4_vo_turret1online()
	//first turret is Online
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : That'll help Crimson.  Go get the other two.
	dprint ("Palmer: That'll help Crimson.  Go get the other two.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret1online_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret1online_00100'));
	
	end_radio_transmission();
	
end


script dormant e3m4_vo_turret2online()
	//turret 2 Online

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson's got the second turret active, Commander.
	dprint ("Miller: Crimson's got the second turret active, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret2online_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret2online_00100'));
	
	end_radio_transmission();
	
end


script dormant e3m4_vo_turret3online()
	//turret 3 is Online
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : All turrets operational.
	dprint ("Miller: All turrets operational.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Dalton!
	dprint ("Palmer: Dalton!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Online, Commander.
	dprint ("Dalton: Online, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : You have that emergency dispatch ready yet?
	dprint ("Palmer: You have that emergency dispatch ready yet?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00600'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Prepped and loading as fast as we can, Commander.  Pelicans aren't exactly rated for--
	dprint ("Dalton: Prepped and loading as fast as we can, Commander.  Pelicans aren't exactly rated for--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00700'));
	
	cui_hud_hide_radio_transmission_hud();
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Don't bore me with facts, Dalton.  Just make it happen.
	dprint ("Palmer: Don't bore me with facts, Dalton.  Just make it happen.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00800', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_hellbreaks_00800'));
	
	sleep_s (1);
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

//	// Palmer : Dalton?  Status?
//	dprint ("Palmer: Dalton?  Status?");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00200'));

	// Dalton : Heading out of the hangar bay now.
	dprint ("Dalton: Heading out of the hangar bay now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00300'));
	
	end_radio_transmission();
	
end



script dormant e3m4_vo_phantomunits()
	//units coming from the phantom
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Incoming!
	dprint ("Miller: Incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_phantomunits_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_phantomunits_00100'));
	
	end_radio_transmission();
	
end


script dormant e3m4_vo_phantomwraith()
	//units coming from the phantom
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Wraith on the field.  Watch out, Crimson.
	dprint ("Palmer: Wraith on the field.  Watch out, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_phantomwraith_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_phantomwraith_00100'));
	
	end_radio_transmission();
	
end


script dormant e3m4_vo_mantisdrop()
	//for mantis drop
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Time to even the odds, I think.  Crimson, here're some new toys.  Enjoy.
	dprint ("Palmer: Time to even the odds, I think.  Crimson, here're some new toys.  Enjoy.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_mantisdrop_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_mantisdrop_00100'));
	
	end_radio_transmission();
	e3m4_narrative_is_on = FALSE;
end


script dormant e3m4_vo_airincoming()
	//incoming aircraft
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Heavy Covenant air support incoming, Commander.
	dprint ("Miller: Heavy Covenant air support incoming, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_airincoming_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_airincoming_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, eyes on the sky.
	dprint ("Palmer: Crimson, eyes on the sky.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_airincoming_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_airincoming_00200'));
	
	end_radio_transmission();
	
end


script dormant e3m4_vo_covcruiser()
	//incoming Covie cruiser
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Commander Palmer, my pilots are reporting there's a Covenant Cruiser inbound on Crimson's position.
	dprint ("Dalton: Commander Palmer, my pilots are reporting there's a Covenant Cruiser inbound on Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_covcruiser_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_covcruiser_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Oh, crap.
	dprint ("Palmer: Oh, crap.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_covcruiser_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_covcruiser_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	thread (shipboom01());

	// Miller : Confirmed sighting, Commander.  They're moving on Crimson.
	dprint ("Miller: Confirmed sighting, Commander.  They're moving on Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_covcruiser_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_covcruiser_00300'));
	
	end_radio_transmission();
	
	e3m4_narrative_is_on = FALSE;
	
end


script dormant e3m4_vo_extractask()
	//ask for extract
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Dalton!  I need a Pelican to extract Crimson.  We can leave the Mantises behind.
	dprint ("Palmer: Dalton!  I need a Pelican to extract Crimson.  We can leave the Mantises behind.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_extractask_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_extractask_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Commander, that's a suicide run.  I won't get a bird within a hundred klicks.
	dprint ("Dalton: Commander, that's a suicide run.  I won't get a bird within a hundred klicks.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_extractask_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_extractask_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I need solutions, not excuses, Dalton
	dprint ("Palmer: I need solutions, not excuses, Dalton");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_extractask_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_extractask_00300'));
	
	end_radio_transmission();
	
	e3m4_narrative_is_on = FALSE;
end


script dormant e3m4_vo_wayout()
	//there's a way out
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander?  I think I've got a way to retrieve Crimson.
	dprint ("Miller: Commander?  I think I've got a way to retrieve Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

//	// Palmer : Show me.
//	dprint ("Palmer: Show me.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00200'));

	// Palmer : Fantastic.  Make it happen.
//	dprint ("Palmer: Fantastic.  Make it happen.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00300'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, hold out just a little longer.  Help is on its way.
	dprint ("Palmer: Crimson, hold out just a little longer.  Help is on its way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wayout_00400'));
	
	end_radio_transmission();
	
	e3m4_narrative_is_on = FALSE;
end


script dormant e3m4_vo_frigate()
	//UNSC frigate arrives
		sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "e3m4_frigatecaptain_transmission_name" );
	
	// e3m4_frigate_captain : Commander Palmer, we're on station.
	dprint ("e3m4_frigate_captain: Commander Palmer, we're on station.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_frigate_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_frigate_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Fire at will, Captain.
	dprint ("Palmer: Fire at will, Captain.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_frigate_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_frigate_00200'));
	
	end_radio_transmission();
	
	e3m4_narrative_is_on = FALSE;
end


script dormant e3m4_vo_wrapup()
	//all done
	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Nice work down there, Crimson.  We'll have you a ride home shortly.
	dprint ("Palmer: Nice work down there, Crimson.  We'll have you a ride home shortly.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander Palmer!  Solid intel on Parg Vol's location.
	dprint ("Miller: Commander Palmer!  Solid intel on Parg Vol's location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Show me.
	dprint ("Palmer: Show me.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	hud_play_pip_from_tag (bink\Spops\EP3_M4_1_60);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : All right.  Scratch that, Crimson.  You're not coming home.  You're going hunting.  I'll be back in touch shortly.
	dprint ("Palmer: All right.  Scratch that, Crimson.  You're not coming home.  You're going hunting.  I'll be back in touch shortly.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_wrapup_00400_pip'));
	
	end_radio_transmission();
	// end PIP
	e3m4_narrative_is_on = FALSE;

end


//=============================================================================================================================
//======================================= VALHALLA Ep 04 Mission 02 VO scripts ================================================
//=============================================================================================================================


script dormant e4m2_vo_intro()

	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : Crimson and Majestic are online, Commander Palmer.
	dprint ("Miller: Crimson and Majestic are online, Commander Palmer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Listen up, Spartans.  You're both dispatched to locations where Jul 'Mdama is rallying troops.
	dprint ("Palmer: Listen up, Spartans.  You're both dispatched to locations where Jul 'Mdama is rallying troops.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : No cute little competitions today.  You're on the ground to work.
	dprint ("Palmer: No cute little competitions today.  You're on the ground to work.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : Just the point the way, Commander.
	dprint ("DeMarco: Just the point the way, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_intro_00400'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;

end


script dormant e4m2_vo_waterfronttower()

	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : Commander, we've got word Jul 'Mdama is at the waterfront tower.
	dprint ("Miller: Commander, we've got word Jul 'Mdama is at the waterfront tower.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_waterfronttower_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_waterfronttower_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Get over there, Crimson!  If he's there, this is our chance.
	dprint ("Palmer: Get over there, Crimson!  If he's there, this is our chance.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_waterfronttower_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_waterfronttower_00200'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_majesticreport()

	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Majestic, report.
	dprint ("Palmer: Majestic, report.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticreport_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticreport_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );

	// DeMarco : Nothing terribly exciting here, Commander.  Just a few hundred Covies and five little Spartans.
	dprint ("DeMarco: Nothing terribly exciting here, Commander.  Just a few hundred Covies and five little Spartans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticreport_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticreport_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "thorne_transmission_name" );

	// Thorne : We're doing fine, Commander.  The Marines are holding their own for once.
	dprint ("Thorne: We're doing fine, Commander.  The Marines are holding their own for once.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticreport_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticreport_00300'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_julportal()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	sleep_s (1);
//	object_create_anew (lakeside_fx);

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Commander!  Energy surge from the waterfront tower!
	dprint ("Miller: Commander!  Energy surge from the waterfront tower!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (20);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Cause?
	dprint ("Palmer: Cause?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Reads like a small slipspace rupture…and it's gone.
	dprint ("Miller: Reads like a small slipspace rupture…and it's gone.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Crimson, get ready.  No telling what 'Mdama's up to in there.
	dprint ("Palmer: Crimson, get ready.  No telling what 'Mdama's up to in there.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_julportal_00400'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_checkportal()

	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;

//	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//
//	// Miller : Where are all the bad guys?
//	dprint ("Miller: Where are all the bad guys?");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00100'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (30);
	start_radio_transmission( "demarco_transmission_name" );
	
	// DeMarco : Commander Palmer?  This is weird.  We had the Covies cornered--
	dprint ("DeMarco: Commander Palmer?  This is weird.  We had the Covies cornered--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : And now they're gone?
	dprint ("Palmer: And now they're gone?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "demarco_transmission_name" );
	
	// DeMarco : How'd you know?
	dprint ("DeMarco: How'd you know?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : I'm a mind reader.
	dprint ("Palmer: I'm a mind reader.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_checkportal_00500'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_placeoffline()

	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Whatever happened here, it's all offline now.
	dprint ("Miller: Whatever happened here, it's all offline now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_placeoffline_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_placeoffline_00100'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_majesticfind()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, Palmer.  Majestic says they found something.
	dprint ("Miller: Commander, Palmer.  Majestic says they found something.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Go ahead, Majestic.
	dprint ("Palmer: Go ahead, Majestic.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "grant_transmission_name" );
	
	// Grant : Commander, it's Grant.  The Covies didn't disappear.  I…Commander?  I think they teleported.  This might be a transit system and Crimson could be at a similar location.
	dprint ("Grant: Commander, it's Grant.  The Covies didn't disappear.  I…Commander?  I think they teleported.  This might be a transit system and Crimson could be at a similar location.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : A transit system would explain the slipspace reading earlier.
	dprint ("Miller: A transit system would explain the slipspace reading earlier.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "grant_transmission_name" );
	
	// Grant : Systems are busted, but there's coordinates left behind.  I'll send them to Science Team.
	dprint ("Grant: Systems are busted, but there's coordinates left behind.  I'll send them to Science Team.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_majesticfind_00500'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_othertower()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Crimson, I want you to get a look at the canyon tower's systems.  If they're similar to what's at waterfront tower, you may be able to follow Jul.
	dprint ("Palmer: Crimson, I want you to get a look at the canyon tower's systems.  If they're similar to what's at waterfront tower, you may be able to follow Jul.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_othertower_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_othertower_00100'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_underattack()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Canyon tower is under attack, Commander.  As soon as Crimson started heading that way, the Covies went nuts.
	dprint ("Miller: Canyon tower is under attack, Commander.  As soon as Crimson started heading that way, the Covies went nuts.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_underattack_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_underattack_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Miller, some days I hate being right all the time.
	dprint ("Palmer: Miller, some days I hate being right all the time.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_underattack_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_underattack_00200'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_stillon()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Looks like the systems here are still functional.
	dprint ("Miller: Looks like the systems here are still functional.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Can you dial in the coordinates Majestic recovered?
	dprint ("Palmer: Can you dial in the coordinates Majestic recovered?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : I think so.
	dprint ("Miller: I think so.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Crimson, I'm highlighting what look like the relevant controls.
	dprint ("Miller: Crimson, I'm highlighting what look like the relevant controls.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Fire it up, Crimson.
	dprint ("Palmer: Fire it up, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_stillon_00500'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_hurryup1()

	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Crimson, let's get a move on.  Activate the controls.
	dprint ("Palmer: Crimson, let's get a move on.  Activate the controls.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_hurryup1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_hurryup1_00100'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_hurrup2()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Come onnnn, Crimson.  My coffee's getting cold waiting for you.
	dprint ("Palmer: Come onnnn, Crimson.  My coffee's getting cold waiting for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_hurryup2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_hurryup2_00100'));
	
	end_radio_transmission();
	
	e4m2_narrative_is_on = FALSE;
end


script dormant e4m2_vo_getinthere()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Commander!  Something's happening!
	dprint ("Miller: Commander!  Something's happening!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	notifylevel ("iseeit");
	
	// Palmer : Use your words, Miller.
	dprint ("Palmer: Use your words, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Crimson, this object activated when you entered those coordinates.  It's a slipspace rupture, just like I read with 'Mdama people.
	dprint ("Miller: Crimson, this object activated when you entered those coordinates.  It's a slipspace rupture, just like I read with 'Mdama people.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	hud_play_pip_from_tag (bink\Spops\EP4_M2_1_60);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : They've got portals now.  Fantastic.  Crimson, get in there.  See where it goes.  We'll find you on the other end.
	dprint ("Palmer: They've got portals now.  Fantastic.  Crimson, get in there.  See where it goes.  We'll find you on the other end.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_getinthere_00400_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e4m2_narrative_is_on = FALSE;
end