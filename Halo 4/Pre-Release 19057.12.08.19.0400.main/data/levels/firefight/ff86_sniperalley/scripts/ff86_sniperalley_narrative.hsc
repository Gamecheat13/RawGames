//=============================================================================================================================
//============================================ SNIPERALLEY NARRATIVE SCRIPT ===================================================
//=============================================================================================================================

global boolean e2m4_narrative_is_on = FALSE;

// behold, the 2nd greatest narrative script ever to pass through the halls of 343....


script startup sparops_e02_m04_main()
	
	dprint (":::  NARRATIVE SCRIPT  :::");
	
end

script static void ex1()
	//fires e1 m2 Narrative In scene
	
	ai_erase (squads_1);
	ai_erase (squads_2);
	ai_erase (squads_3);
	ai_place (squads_1);
	ai_place (squads_2);
	ai_place (squads_3);
	
	pup_play_show(e1_m2_narrative_in);

	vo_play_intro();
	
end


script static void ex2()
	//fires for e2 m4 intro
	
	ai_erase (sq_e2m4_pelican);
	ai_erase (squads_2);
	ai_erase (squads_3);
	ai_place (squads_2);
	ai_place (squads_3);
	
	pup_play_show (e1m2_narrative_in);
	
end


script command_script cs_e2m4_pelican_in()
	//fly e2m4 pelican in

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it’s avoiding things for no reason
	
 	cs_fly_by (point_e2m4_pelican_in.p0);
  
end


script command_script cs_e4m1_pelican_in()
	//fly e4m1 pelican in

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it’s avoiding things for no reason
	
 	cs_fly_to (ps_e4m1_pelican.p0);
 	cs_vehicle_speed (0.4);
 	cs_fly_to_and_face (ps_e4m1_pelican.p1, ps_e4m1_pelican.p2);
  
end


script command_script cs_e4m1_enter_turret()
	//tells unit to enter cinematic turret
	
	cs_go_to_vehicle (veh_pup_shade_01);
	
end


//=============================================================================================================================
//==================================== SNIPER ALLEY Ep 01 Mission 02 VO scripts ===============================================
//=============================================================================================================================


script static void vo_play_intro()
	// stand-in to play VO
	
	sleep_s (1);
	
//	// Miller : Comms open, Commander Palmer.
//	dprint ("Miller: Comms open, Commander Palmer.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00100'));
//
//	// Palmer : Thanks, Miller.
//	dprint ("Palmer: Thanks, Miller.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00200'));

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, good work yesterday.  Moving you up to something a little tougher today.
	dprint ("Palmer: Crimson, good work yesterday.  Moving you up to something a little tougher today.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00300'));
	
	sleep (10);

	// Palmer : Inserting you into a Covenant-held area the Marines have been throwing themselves against to no avail.  Short version of your to-do list:  if it moves, shoot it.
	dprint ("Palmer: Inserting you into a Covenant-held area the Marines have been throwing themselves against to no avail.  Short version of your to-do list:  if it moves, shoot it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_intro_00400'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_playstarts()
	//play when gameplay starts
	
	sleep(15);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Where's that shield coming from?
	dprint ("Miller: Where's that shield coming from?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : One moment.
	dprint ("Miller: One moment.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (60);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : There's a lot of power being pulled from the planet.
	dprint ("Miller: There's a lot of power being pulled from the planet.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Weird.
	dprint ("Miller: Weird.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson doesn't need a Science Team report, Miller.  They just need a target to shoot.
	dprint ("Palmer: Crimson doesn't need a Science Team report, Miller.  They just need a target to shoot.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP ON
	hud_play_pip_from_tag (bink\Spops\EP1_M2_1_60);
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Right, Commander.
	// Miller : Have a look in this area, Crimson.  See what you can find.
	dprint ("Miller: Right, Commander.");
	dprint ("Miller: Have a look in this area, Crimson.  See what you can find.");
	
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00600', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00700', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1block_00600_pip'));
	
	end_radio_transmission();

// PIP OFF
	
end


script static void vo_e1m2_shielddown()
	//play when shield is destroyed

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : There we go.  Shield's down.
	dprint ("Miller: There we go.  Shield's down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield1down_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_whataretheydoing()
	//play for Covenant question
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : What the hell are the Covenant doing?
	dprint ("Palmer: What the hell are the Covenant doing?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : They've got some gear…it…
	dprint ("Miller: They've got some gear…it…");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00200'));

	cui_hud_hide_radio_transmission_hud();
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Spit it out, Miller
	dprint ("Palmer: Spit it out, Miller");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00300'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : They're siphoning power from the structures.
	dprint ("Miller: They're siphoning power from the structures.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00400'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Give me a minute.
	dprint ("Miller: Give me a minute.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00500'));

	cui_hud_hide_radio_transmission_hud();
	sleep (40);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Palmer : While Miller's working his science, Crimson, you continue clearing the area.
	dprint ("Palmer: While Miller's working his science, Crimson, you continue clearing the area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_backstory_00600'));
	
	end_radio_transmission();

	
end


script static void vo_e1m2_powerlines()
	//play about power lines
	
	thread (story_blurb_add("vo", "no longer used"));
	
	cui_hud_hide_radio_transmission_hud();
	
end


script static void vo_e1m2_secondshield()
	//play when see second shield
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Same as before, Crimson.  Find a way through that shield
	dprint ("Miller: Same as before, Crimson.  Find a way through that shield");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield2block_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield2block_00100'));
	
	end_radio_transmission();
	
	thread(e1_m2_vo_secondshield_callback());
	
end


script static void vo_e1m2_2ndshielddown()
	//play when second shield down
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Good job, Crimson.  Covenant's primary power siphon is just ahead.  Let's go shut it down.
	dprint ("Miller: Good job, Crimson.  Covenant's primary power siphon is just ahead.  Let's go shut it down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield2down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_shield2down_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_computerhint()
	//hint to  use computer
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, get a look at that computer.  Let's see what the Covies have got on their drive.
	dprint ("Miller: Crimson, get a look at that computer.  Let's see what the Covies have got on their drive.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_getcomputer_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_getcomputer_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_powerlocale()
	//play when computer is used
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Interesting.  Commander Palmer?  There's a Covenant archaeological team operating nearby.
	dprint ("Miller: Interesting.  Commander Palmer?  There's a Covenant archaeological team operating nearby.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_computeron_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_computeron_00100'));
	
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : We'll worry about that later.  Right now, I want Crimson securing this canyon.
	dprint ("Palmer: We'll worry about that later.  Right now, I want Crimson securing this canyon.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_computeron_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_computeron_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_securegenerator()
	//tell to secure area around generator
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander Palmer?  Crimson's reached the target.
	dprint ("Miller: Commander Palmer?  Crimson's reached the target.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Once again, Spartans do in 24 minutes what Marines can't do in 24 hours.
	dprint ("Palmer: Once again, Spartans do in 24 minutes what Marines can't do in 24 hours.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Dalton, I need a decent-sized explosive launched from Infinity on Crimson's mark.
	dprint ("Palmer: Dalton, I need a decent-sized explosive launched from Infinity on Crimson's mark.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : I can arrange that, Commander.
	dprint ("Dalton: I can arrange that, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, secure the area near the generator.  You're going to be Dalton's eyes on this one.
	dprint ("Palmer: Crimson, secure the area near the generator.  You're going to be Dalton's eyes on this one.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00500'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_marktarget()
	//tell to mark bomb target

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson's got the area secure, Commander.
	dprint ("Miller: Crimson's got the area secure, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_areasecure_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_areasecure_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Would you be so kind as to paint a target on the generator for Spartan Dalton?
	dprint ("Palmer: Would you be so kind as to paint a target on the generator for Spartan Dalton?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_areasecure_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_areasecure_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_targetpainted()
	// when target has been painted

	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Got it.
	dprint ("Dalton: Got it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_painted_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_painted_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Bombs away.  Oh.  Crimson, I'd get to cover if I were you.
	dprint ("Dalton: Bombs away.  Oh.  Crimson, I'd get to cover if I were you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_painted_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_painted_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_getsafe()
	//get to a safe area

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson!  Move it!  Get to the safe area!  Now!
	dprint ("Miller: Crimson!  Move it!  Get to the safe area!  Now!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_gettosafe_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_gettosafe_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m2_targethit()
	//target is hit
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Impact on target, Commander.
	dprint ("Dalton: Impact on target, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_targethit_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_targethit_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Confirming..., all power to the area is gone.
	dprint ("Miller: Confirming..., all power to the area is gone.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_targethit_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_targethit_00200'));
	
	cui_hud_hide_radio_transmission_hud();

	sleep (10);
	
	// PIP ON 
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\Spops\EP1_M2_2_60);

	// Palmer : Well done, everyone.  Crimson, head to the extraction point and come on home.
	dprint ("Palmer: Well done, everyone.  Crimson, head to the extraction point and come on home.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_targethit_00300', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_targethit_00300_pip'));
	
	end_radio_transmission();
	// PIP OFF
end


//=============================================================================================================================
//======== SNIPER ALLEY Ep 02 Mission 04 VO scripts ===============================================
//=============================================================================================================================


script dormant vo_e2m4_intro()
	// gameplay starts
	sleep_until(e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : What the hell brought them down?
	dprint ("Palmer: What the hell brought them down?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00220', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00220'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : AA guns in the area.
	dprint ("Miller: AA guns in the area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00230', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00230'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Sitrep, Miller!  Is anyone alive down there?
	dprint ("Palmer: Sitrep, Miller!  Is anyone alive down there?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00100'));
	
	end_radio_transmission();

	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_playstart()
	// gameplay starts
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : All Crimson IFF tags are active.  They're in one piece, Commander Palmer.
	dprint ("Miller: All Crimson IFF tags are active.  They're in one piece, Commander Palmer.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : But they’ve got bad guys inbound!
	dprint ("Miller: But they’ve got bad guys inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00210', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00210'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Dalton!
	dprint ("Palmer: Dalton!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00300'));

//	// Dalton : Online, commander.
//	dprint ("Dalton: Online, commander.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00400', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00400'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Hold back all other air traffic from near Crimson's coordinates until they can take those AA guns offline.  Gargarin will have to wait.
	dprint ("Palmer: Hold back all other air traffic from near Crimson's coordinates until they can take those AA guns offline.  Gargarin will have to wait.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	
	b_end_player_goal = TRUE;
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Consider it done.
	dprint ("Dalton: Consider it done.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_playstart_00600'));
	
	end_radio_transmission();
	
	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_aaguns()
	// instruct to take out AA guns
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;
	
	sleep (51);
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Miller, paint the target for Crimson.
	dprint ("Palmer: Miller, paint the target for Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_aaguns_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_aaguns_00100'));
	
	sleep_s(1);
	b_end_player_goal = TRUE;
	sleep_s(1);
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Closest gun to their position is lit.
	dprint ("Miller: Closest gun to their position is lit.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_aaguns_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_aaguns_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep2_m4_1_60);
	
	// Palmer : Get moving, Crimson.  Take down the AA guns.
	dprint ("Palmer: Get moving, Crimson.  Take down the AA guns.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_aaguns_00300', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_aaguns_00300_pip'));
	
	end_radio_transmission();
	
	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_gun01arrive()
	// arrive at gun 1
	sleep_until(e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson has reached the first gun, Commander.
	dprint ("Miller: Crimson has reached the first gun, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun01arrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun01arrive_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Shut it down, Crimson.
	dprint ("Palmer: Shut it down, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun01arrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun01arrive_00200'));
	end_radio_transmission();
	
	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_gun01down()
	// gun 1 is down
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : That's one gun down.  Move on to the next one, Crimson.
	dprint ("Palmer: That's one gun down.  Move on to the next one, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun01down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun01down_00100'));
	
	end_radio_transmission();
	
	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_gun02target()
	// gun 2 is objectives_clear
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander, I've got a lock on a second gun near Crimson's position.
	dprint ("Miller: Commander, I've got a lock on a second gun near Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02target_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02target_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Paint it, Miller
	dprint ("Palmer: Paint it, Miller");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02target_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02target_00200'));

	//flag to set when 1st gun is down, time passed
	b_end_player_goal = TRUE;
	sleep_s(2);
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Done.
	dprint ("Miller: Done.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02target_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02target_00300'));
	e2m4_narrative_is_on = FALSE;
	
	end_radio_transmission();
	
end


script dormant vo_e2m4_hunters01()
	// hunters 1
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : More Covies inbound on Crimson's position.
	dprint ("Miller: More Covies inbound on Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters01_00100'));
	
	end_radio_transmission();
	sleep (10);
	
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//	// Palmer : I'm willing to bet they already noticed, Miller.  But thank you all the same.
//	dprint ("Palmer: I'm willing to bet they already noticed, Miller.  But thank you all the same.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters01_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters01_00200'));
//	cui_hud_hide_radio_transmission_hud();
	
	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_gun02arrive()
	// arrive at gun 2
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : There's your second AA gun, Crimson.
	dprint ("Palmer: There's your second AA gun, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02arrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02arrive_00100'));
	
	end_radio_transmission();
	
	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_gun02down()
	// gun 2 down
	sleep_until(e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson destroyed the target, Commander.
	dprint ("Miller: Crimson destroyed the target, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Excellent.  Dalton, the air corridor is open again.
	dprint ("Palmer: Excellent.  Dalton, the air corridor is open again.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Thanks, Commander.
	dprint ("Dalton: Thanks, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, let's get moving in Gargarin's direction.
	dprint ("Palmer: Crimson, let's get moving in Gargarin's direction.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_gun02down_00400'));
	
	end_radio_transmission();
	
	e2m4_narrative_is_on = FALSE;
end


script dormant vo_e2m4_hunters02()
	// second round of Hunters
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : More Covenant inbound, Crimson. Not that I want to belabor the obvious, mind you.
	dprint ("Miller: More Covenant inbound, Crimson. Not that I want to belabor the obvious, mind you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Miller, your attention to detail's one of the few things I truly like about you.  Never stop.
	dprint ("Palmer: Miller, your attention to detail's one of the few things I truly like about you.  Never stop.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00200'));
	
	end_radio_transmission();
	
//	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//	// Miller : They brought Hunters this time!
//	dprint ("Miller: They brought Hunters this time!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00210', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00210'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
	
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//	// Palmer : Crimson, show Miller how unimpressed you are by a couple of Hunters.
//	dprint ("Palmer: Crimson, show Miller how unimpressed you are by a couple of Hunters.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00220', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_hunters02_00220'));
//	cui_hud_hide_radio_transmission_hud();
	
	e2m4_narrative_is_on = FALSE;
end

script dormant vo_e2_m4_clean_up_baddies()
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Half way done. Clean out the stragglers, Crimson. No reason to leave anybody behind.
	dprint ("Palmer: Half way done. Clean out the stragglers, Crimson. No reason to leave anybody behind.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_cleanup_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_cleanup_00200'));
	
	end_radio_transmission();

	e2m4_narrative_is_on = FALSE;
end

script dormant vo_e2m4_allclear()
	// level done
	sleep_until (e2m4_narrative_is_on == FALSE);
	e2m4_narrative_is_on = TRUE;
	
	sleep (41);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson's in the clear, Commander.  Still no word from Science Base.
	dprint ("Miller: Crimson's in the clear, Commander.  Still no word from Science Base.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : They're also pretty close to a transit tunnel if I'm reading this map right.
	dprint ("Miller: They're also reasonably close to a transit tunnel if I'm reading this map right.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Yes, Commander.  They could hoof it from here to the science team's last known locale pretty easily.
	dprint ("Miller: Yes, Commander.  They could hoof it from here to the science team's last known locale pretty easily.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	hud_play_pip_from_tag (bink\spops\ep2_m4_2_60);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : There it is then, Crimson.  Off you go.
	dprint ("Palmer: There it is then, Crimson.  Off you go.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_04\e2m4_allclear_00400_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e2m4_narrative_is_on = FALSE;
end	



// =============================================================================================================================
//====== SNIPER ALLEY Ep 04 Mission 01 VO scripts ===============================================
// =============================================================================================================================

script static void vo_e4m1_intro()
	// intro scene
	
	//// Miller : Telemetry -- online.  Spartan tags -- online.  Comms -- online.  The Op is live, Commander Palmer.
	//dprint ("Miller: Telemetry -- online.  Spartan tags -- online.  Comms -- online.  The Op is live, Commander Palmer.");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00100', NONE, 1);
	//sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00100'));
	
	
	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	sleep (55);
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, we're going to knock some heads together today, and see what we can find out about Jul M'dama.
	dprint ("Palmer: Crimson, we're going to knock some heads together today, and see what we can find out about Jul M'dama.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00200'));
	
	sleep (20);
	
	// Palmer : This hinge head freak's been killing good soldiers on Requiem, including the Spartans of Castle team.
	dprint ("Palmer: This hinge head freak's been killing good soldiers on Requiem, including the Spartans of Castle team.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00300'));
	
	sleep (20);
	
	// Palmer : Today…we're taking the first step towards getting revenge.
	dprint ("Palmer: Today…we're taking the first step towards getting revenge.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_intro_00400'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_playstart()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	// PIP
	start_radio_transmission( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep4_m1_1_60);
	
	// Palmer : Infinity Science has finally figured out why Covenant comm traffic is so low on Requiem.  Turns out the Covies are channeling most of their comms through a Forerunner subnet.
	dprint ("Palmer: Infinity Science has finally figured out why Covenant comm traffic is so low on Requiem.  Turns out the Covies are channeling most of their comms through a Forerunner subnet.");
	dprint ("Palmer: So with the help of the geeks, we're going to tap their party line and listen in.");
	dprint ("Palmer: Miller, show Crimson where to go.");
	
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_playstart_00100', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_playstart_00200', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_playstart_00300', NONE, 1);
	
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_playstart_00100_pip'));
	
	cui_hud_hide_radio_transmission_hud();	
	// end PIP
	
	sleep (15);
	
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Waypoint's up.
	dprint ("Miller: Waypoint's up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_playstart_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_playstart_00400'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_turrets01()


	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, keep an eye on those turrets.
	dprint ("Miller: Crimson, keep an eye on those turrets.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_turrets01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_turrets01_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Miller, we need to discuss your fascination with telling Crimson what's shooting at them.
	dprint ("Palmer: Miller, we need to discuss your fascination with telling Crimson what's shooting at them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_turrets01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_turrets01_00200'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_gotospire()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Infinity Science says this is the spot where we can activate the comm tap.
	dprint ("Miller: Infinity Science says this is the spot where we can activate the comm tap.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotospire_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotospire_00100'));
	
	end_radio_transmission();

//commenting extra dialog that plays during down time

//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//	
//	// Palmer : Do the geeks have any tips on activating the ancient alien technology, or do they just hope Crimon's got the magic touch?
//	dprint ("Palmer: Do the geeks have any tips on activating the ancient alien technology, or do they just hope Crimon's got the magic touch?");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotospire_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotospire_00200'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
//	
//	// Miller : Science is putting together an instruction manual now, Commander.
//	dprint ("Miller: Science is putting together an instruction manual now, Commander.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotospire_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotospire_00300'));
//	
//	cui_hud_hide_radio_transmission_hud();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_raisepylons()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : You see anything, Crimson?
	dprint ("Palmer: You see anything, Crimson?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_raisepylons_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_raisepylons_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Here's what Science believes is the switch.
	dprint ("Miller: Here's what Science believes is the switch.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_raisepylons_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_raisepylons_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Do it.  Let's see if the eggheads know what they're talking about.
	dprint ("Palmer: Do it.  Let's see if the eggheads know what they're talking about.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_raisepylons_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_raisepylons_00300'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_pylonsraised()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson has activated some pylons, Commander.  If Science Team's right, they'll serve to eavesdrop on the Covies.
	dprint ("Miller: Crimson has activated some pylons, Commander.  If Science Team's right, they'll serve to eavesdrop on the Covies.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pylonsraised_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pylonsraised_00100'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_gotopillars()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Get up there, Crimson.  I want to hear what the Covenant has to say.
	dprint ("Palmer: Get up there, Crimson.  I want to hear what the Covenant has to say.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotopillars_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_gotopillars_00100'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_hackcomms()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, I'm sending you targets to activate.  Science Team believes they'll allow us to listen in freely.
	dprint ("Miller: Crimson, I'm sending you targets to activate.  Science Team believes they'll allow us to listen in freely.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hackcomms_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hackcomms_00100'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_hearstuff()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	// e4m1_elite01 : (blarga blarga sangheili)
	dprint ("e4m1_elite01: (blarga blarga sangheili)");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hearstuff_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hearstuff_00100'));
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Blarga blarga etc.  Right.  Miller, send the comm traffic over to Intel.  Crimson, fall back to the extraction point.  Good work down there.
	dprint ("Palmer: Blarga blarga etc.  Right.  Miller, send the comm traffic over to Intel.  Crimson, fall back to the extraction point.  Good work down there.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hearstuff_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hearstuff_00200'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_covdroppods()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Commander Palmer, be advised that Covenant drop pods are inbound on multiple Fireteam positions!
	dprint ("Dalton: Commander Palmer, be advised that Covenant drop pods are inbound on multiple Fireteam positions!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Got a few coming down near Crimson right now!
	dprint ("Miller: Got a few coming down near Crimson right now!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Dalton, why didn't we see these sooner?
	dprint ("Palmer: Dalton, why didn't we see these sooner?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Unclear, Commander.  Working on it right now.
	dprint ("Dalton: Unclear, Commander.  Working on it right now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_covdroppods_00400'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_dropship01()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson!  There's a phantom heading your way.
	dprint ("Miller: Crimson!  There's a phantom heading your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Dalton!  What the hell, man?  You're usually on it with the air space policing.
	dprint ("Palmer: Dalton!  What the hell, man?  You're usually on it with the air space policing.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Commander, Covenant aircraft are just popping in and out.  I don't know what's going on.
	dprint ("Dalton: Commander, Covenant aircraft are just popping in and out.  I don't know what's going on.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Well, figure it out!
	dprint ("Palmer: Well, figure it out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_dropship01_00400'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_hunters01()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Hunters!
	dprint ("Miller: Hunters!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hunters01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_hunters01_00100'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_afterhunters()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Commander, I'm running diagnostics as fast as I can, and they're reading all green lights.  Best guess is the Covies have a jamming system on one of the ships.
	dprint ("Dalton: Commander, I'm running diagnostics as fast as I can, and they're reading all green lights.  Best guess is the Covies have a jamming system on one of the ships.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_afterhunter01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_afterhunter01_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Commander Palmer to all Fireteams:  Be advised that Covenant aircraft may be hiding in plain sight.  Don't rely solely on your gear down there.  Use your eyes, people.
	dprint ("Palmer: Commander Palmer to all Fireteams:  Be advised that Covenant aircraft may be hiding in plain sight.  Don't rely solely on your gear down there.  Use your eyes, people.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_afterhunter01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_afterhunter01_00200'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_pelicanarrive()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Pelican inbound, Crimson.
	dprint ("Miller: Pelican inbound, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pelicanarrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pelicanarrive_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Commander!  I think I've sourced the origin point for the Covenant jammer.  It's actually pretty close to Crimson's extraction point.
	dprint ("Dalton: Commander!  I think I've sourced the origin point for the Covenant jammer.  It's actually pretty close to Crimson's extraction point.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pelicanarrive_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pelicanarrive_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Nice, Dalton.
	dprint ("Palmer: Nice, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pelicanarrive_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_pelicanarrive_00300'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_lichdownspelican()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander!  Pelican down!  Pelican down!
	dprint ("Miller: Commander!  Pelican down!  Pelican down!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Sonuva -- Commander, that Lich is the source of the jamming.
	dprint ("Dalton: Sonuva -- Commander, that Lich is the source of the jamming.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : I'm sorry.  I didn't see it until it was too late.
	dprint ("Dalton: I'm sorry.  I didn't see it until it was too late.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Apologize later, Dalton.  Scramble Longswords and bring that Lich down.
	dprint ("Palmer: Apologize later, Dalton.  Scramble Longswords and bring that Lich down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Yes, Commander.
	dprint ("Dalton: Yes, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lichdownspelican_00500'));
	
	end_radio_transmission();

	e4m1_narrative_is_on = false;

end


script static void vo_e4m1_aadownspelican()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander!  Pelican down!  Pelican down!
	dprint ("Miller: Commander!  Pelican down!  Pelican down!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : A defense system activated -- something built into the planet.
	dprint ("Miller: A defense system activated -- something built into the planet.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Dalton, Crimson's weapons won't touch those guns.  I need bombs on those targets!
	dprint ("Palmer: Dalton, Crimson's weapons won't touch those guns.  I need bombs on those targets!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : On it, Commander.
	dprint ("Dalton: On it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Hey, I've found the source of the Covenant jamming.  There's a Lich hovering about three klicks south of Crimson's position.
	dprint ("Dalton: Hey, I've found the source of the Covenant jamming.  There's a Lich hovering about three klicks south of Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Scramble Longswords and bring that Lich down.
	dprint ("Palmer: Scramble Longswords and bring that Lich down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00600'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Dalton : Yes, Commander.
	dprint ("Dalton: Yes, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_aadownspelican_00700'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_morebads01()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander, more bad guys headed for Crimson.  It's bad news down there.
	dprint ("Miller: Commander, more bad guys headed for Crimson.  It's bad news down there.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_morebads01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_morebads01_00100'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_holdposition()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson!  Hold position!  We'll get you out of there, but it might be a while.
	dprint ("Palmer: Crimson!  Hold position!  We'll get you out of there, but it might be a while.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_holdposition_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_holdposition_00100'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_unscflyover()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Commander, Longsword Group Eta is on station.
	dprint ("Dalton: Commander, Longsword Group Eta is on station.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_unscflyover_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_unscflyover_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : I want that Lich out of the sky, Dalton.
	dprint ("Palmer: I want that Lich out of the sky, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_unscflyover_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_unscflyover_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Aye, Commander.
	dprint ("Dalton: Aye, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_unscflyover_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_unscflyover_00300'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_keepholding()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Keep it together, Crimson.  You're doing fine.
	dprint ("Palmer: Keep it together, Crimson.  You're doing fine.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_keepholding_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_keepholding_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Longswords have eyes on our Lich, Commander.
	dprint ("Dalton: Longswords have eyes on our Lich, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_keepholding_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_keepholding_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Tell them not to waste any time.
	dprint ("Palmer: Tell them not to waste any time.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_keepholding_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_keepholding_00300'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_soundstory()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Longswords have Lich locked.
	dprint ("Dalton: Longswords have Lich locked.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (60);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Exchanging fire.  Lich has hit one Longsword.
	dprint ("Dalton: Exchanging fire.  Lich has hit one Longsword.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Pilot ejecting.  Rest of the wing are breaking away.
	dprint ("Dalton: Pilot ejecting.  Rest of the wing are breaking away.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Coming around for another pass.
	dprint ("Dalton: Coming around for another pass.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (90);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Lich is hit.
	dprint ("Dalton: Lich is hit.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Trying to evade.
	dprint ("Dalton: Trying to evade.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00600'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Longswords are hitting her hard, Commander.
	dprint ("Dalton: Longswords are hitting her hard, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00700'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (90);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Almost.
	dprint ("Dalton: Almost.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00800', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00800'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (60);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Almost.
	dprint ("Dalton: Almost.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00900', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_00900'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (120);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : They did it, Commander!  The Lich is down!
	dprint ("Dalton: They did it, Commander!  The Lich is down!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01000', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01000'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Good.  Get a new ride inbound on Crimson's position.
	dprint ("Palmer: Good.  Get a new ride inbound on Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (20);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Miller?  How are things looking?
	dprint ("Palmer: Miller?  How are things looking?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : The team looks to have it all under control, Commander.
	dprint ("Miller: The team looks to have it all under control, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_soundstory_01300'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = FALSE;

end


script static void vo_e4m1_lightshow()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Good news all around, Commander.  Firing solution in place for those turrets.  Light show inbound.
	dprint ("Dalton: Good news all around, Commander.  Firing solution in place for those turrets.  Light show inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Target hit.  Miller, can you confirm?
	dprint ("Dalton: Target hit.  Miller, can you confirm?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Confirmed.  Target hit and disabled.
	dprint ("Miller: Confirmed.  Target hit and disabled.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Nice one, Dalton.
	dprint ("Palmer: Nice one, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_lightshow_00400'));
	
	end_radio_transmission();
	
	e4m1_narrative_is_on = false;

end


script static void vo_e4m1_2ndpelican()

	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;
	
	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : New ride home is on station, Commander.
	dprint ("Dalton: New ride home is on station, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Thanks, Dalton.
	dprint ("Palmer: Thanks, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Commander…Intel's got a live stream translation on the comm towers.  Covies are mad as hell about losing that Lich.
	dprint ("Miller: Commander…Intel's got a live stream translation on the comm towers.  Covies are mad as hell about losing that Lich.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Good for them.  I'm pretty mad out the lives we lost.
	dprint ("Palmer: Good for them.  I'm pretty mad out the lives we lost.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : And they're talking about Jul 'Mdama as well.  He's after something called "Didact's Gift."
	dprint ("Miller: And they're talking about Jul 'Mdama as well.  He's after something called 'Didact's Gift.'");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep4_m1_2_60);
	
	// Palmer : Miller, have Intel send everything straight to me and Captain Lasky.  Crimson, come on home.
	dprint ("Palmer: Miller, have Intel send everything straight to me and Captain Lasky.  Crimson, come on home.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00600', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_01\e4m1_2ndpelican_00600_pip'));
	
	end_radio_transmission();
	// end PIP

	e4m1_narrative_is_on = FALSE;

end