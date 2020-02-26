//=============================================================================================================================
//============================================ COMPLEX NARRATIVE SCRIPT =======================================================
//=============================================================================================================================


// behold, the greatest narrative script ever to pass through the halls of 343...or 550...or whatever...it will be good anyway.

global boolean e4m5_narrative_is_on = FALSE;


script static void e4_m5_pup_intro()
	//fires e4 m5 Narrative In scene
	
	//ai_erase (sq_e4m5_scientists);
//	ai_place (sq_e4m5_scientists);
	
	pup_play_show(pup_e4_m5_in);
	
end


script static void e4_m5_pup_outro()

	pup_play_show (pup_e4_m5_out);
	
end


//=============================================================================================================================
//============================================ COMPLEX E4 M5 VO SCRIPTS =======================================================
//=============================================================================================================================

script static void vo_e4m5_intro()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep (30 * 2);
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Crimson, just a heads up that your ride will be there shortly.  Until then, sit back, relax and --
	dprint ("Dalton: Crimson, just a heads up that your ride will be there shortly.  Until then, sit back, relax and --");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00100'));
	
	sleep (10);

	// Dalton : Hold on! Commander Palmer!  Spartan Miller!  Something's happening at Galileo Base!
	dprint ("Dalton: Hold on! Commander Palmer!  Spartan Miller!  Something's happening at Galileo Base!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00200'));

	sleep_until (e4m5_narrativein_done == TRUE);
	sleep (30 * 2);
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : How can -- Commander, Dalton's right.  Galileo's under attack!
	dprint ("Miller: How can -- Commander, Dalton's right.  Galileo's under attack!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00300'));
	
	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_phantoms01()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep ( 30 * 2);
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Commander Palmer, I'm seeing several dozen Phantoms in the vicinity of Galileo Base.
	dprint ("Dalton: Commander Palmer, I'm seeing several dozen Phantoms in the vicinity of Galileo Base.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : That means the bad guys are gonna keep coming.
	dprint ("Miller: That means the bad guys are gonna keep coming.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Excellent battle analysis, Miller. I'm making a note for your file.
	dprint ("Palmer: Excellent battle analysis, Miller. I'm making a note for your file.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00300'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_phantoms02()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep ( 30 * 3);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Watch out, Crimson. Another Phantom incoming.
	dprint ("Miller: Watch out, Crimson. Another Phantom incoming.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00200'));
	
	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_phantoms03()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep ( 30 * 3);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, Phantom!
	dprint ("Miller: Crimson, Phantom!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00300'));
	
	end_radio_transmission();

	thread (vo_e4m5_defensedown01());
end

script static void vo_e4m5_defensedown01()
	
	sleep (30 * 2);
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Wait a second -- Why aren't facility defenses online?
	dprint ("Palmer: Wait a second -- Why aren't facility defenses online?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Don't know…I can't bring them up remotely either, Commander.  Working on it.
	dprint ("Miller: Don't know…I can't bring them up remotely either, Commander.  Working on it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00200'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end

script static void vo_e4m5_phantoms04()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep ( 30 * 3);
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There’s another Phantom!
	dprint ("Miller: There’s another Phantom!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00400'));
	
	end_radio_transmission();

	thread (vo_e4m5_defensedown02());
end


script static void vo_e4m5_defensedown02()
	
	sleep (30 * 1);

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Commander Palmer to Galileo Base.  Doctor Owen.
	dprint ("Palmer: Commander Palmer to Galileo Base.  Doctor Owen.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Doctor!  Your base defenses are offline!
	dprint ("Palmer: Doctor!  Your base defenses are offline!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

	// Doctor Owen : They are?  Sonuva -- Doctor Alexander was talking about using the power from the defenses to run a mini-reactor.  I told him not to!
	dprint ("Doctor Owen: They are?  Sonuva -- Doctor Alexander was talking about using the power from the defenses to run a mini-reactor.  I told him not to!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00300'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Freaking eggheads.
	dprint ("Palmer: Freaking eggheads.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00400'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_phantoms05()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep ( 30 * 2);
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : More Phantoms!
	dprint ("Miller: More Phantoms!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00100'));
	
	end_radio_transmission();
	
	sleep (30 * 1);
	
	f_blip_object (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_08.driver), default);

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_phantoms06()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep ( 30 * 3);
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watch out, Crimson!
	dprint ("Miller: Watch out, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00600'));
	
	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_phantoms07()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	sleep ( 30 * 3);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : How many are there?!
	dprint ("Miller: How many are there?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_genericphantom_00500'));
	
	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_hunters01
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watch out!  Hunters in the area!
	dprint ("Miller: Watch out!  Hunters in the area!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hunters01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hunters01_00100'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_gotoswitch()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	sleep (30 * 1);

	// PIP	
	hud_play_pip_from_tag (bink\spops\ep4_m5_1_60);
	thread (pip_e4m5_1_subtitles());
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson, looks like turret power has been routed to this location.  If you can make it there, you can activate the defenses.
	dprint ("Miller: Crimson, looks like turret power has been routed to this location.  If you can make it there, you can activate the defenses.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_gotoswitch_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_gotoswitch_00100_pip'));
	
	end_radio_transmission();
	// end PIP
	
	e4m5_narrative_is_on = FALSE;	
end

script static void pip_e4m5_1_subtitles()
	//sleep_s (1.04);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_gotoswitch_00100');
end


script static void vo_e4m5_seeswitch()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There's the power source, Crimson.
	dprint ("Miller: There's the power source, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Turn on the base defenses!  Now!
	dprint ("Palmer: Turn on the base defenses!  Now!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00200'));

	end_radio_transmission();

	sleep (30 * 1);
	b_wait_for_narrative_hud = FALSE;
	
	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_turretsup()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Turrets online, Commander.
	dprint ("Miller: Turrets online, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : That should help keep the skies clear, but the ground's still your problem, Crimson.
	dprint ("Palmer: That should help keep the skies clear, but the ground's still your problem, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00200'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_anaside()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, the Forerunner tech Crimson tapped is paying off.  The whole Covenant net is talking about trying to retrieve the Promethean soul.
	dprint ("Miller: Commander, the Forerunner tech Crimson tapped is paying off.  The whole Covenant net is talking about trying to retrieve the Promethean soul.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Okay, so we know what's going on for once.
	dprint ("Palmer: Okay, so we know what's going on for once.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00200'));

	sleep (30);

	// Palmer : Dalton, who have we got close?
	dprint ("Palmer: Dalton, who have we got close?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00400'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Looks like Majestic’s your best bet there, Commander.
	dprint ("Dalton: Looks like Majestic’s your best bet there, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00500'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Tell them to saddle up. They're headed out to Galileo base fast as you can get them there. They're picking up a package while Crimson holds down the fort.
	dprint ("Palmer: Tell them to saddle up. They're headed out to Galileo base fast as you can get them there. They're picking up a package while Crimson holds down the fort.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00600'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : On it, Commander.
	dprint ("Dalton: On it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00700'));

	end_radio_transmission();

	sleep (30 * 2);
	thread (vo_e4m5_reactoroff());
end


script static void vo_e4m5_reactoroff()
	
	start_radio_transmission( "alexander_transmission_name" );
	
	// Doctor Alexander : Did someone turn off the mini-reactor?
	dprint ("Doctor Alexander: Did someone turn off the mini-reactor?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Bullets outweigh science today, Doc.
	dprint ("Palmer: Bullets outweigh science today, Doc.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "alexander_transmission_name" );

	// Doctor Alexander : Science is going to kill us all!  If you don't restore power to that mini-reactor, its shielding will fail, and wipe Galileo off the map!
	dprint ("Doctor Alexander: Science is going to kill us all!  If you don't restore power to that mini-reactor, its shielding will fail, and wipe Galileo off the map!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00300'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Why is nothing ever simple?!
	dprint ("Palmer: Why is nothing ever simple?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00400'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);

	b_wait_for_narrative_hud = FALSE;

	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Head back here, Crimson.  Hurry!
	dprint ("Miller: Head back here, Crimson.  Hurry!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00500'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_hurryup()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Pick up the pace, Crimson!
	dprint ("Palmer: Pick up the pace, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hurryup_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hurryup_00100'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_almostdead()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson!  You're running out of time!
	dprint ("Miller: Crimson!  You're running out of time!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_almostdead_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_almostdead_00100'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_toolate()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson!!
	dprint ("Palmer: Crimson!!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_toolate_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_toolate_00200'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_enterroom()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Ahhh!  Promethean knights!
	dprint ("Miller: Ahhh!  Promethean knights!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_enterroom_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_enterroom_00100'));

	end_radio_transmission();

	thread (vo_e4m5_killthemall());
end


script static void vo_e4m5_killthemall()

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Put them down, Crimson!
	dprint ("Palmer: Put them down, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_killthemall_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_killthemall_00100'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end

script static void vo_e4m5_fore_veh_callout()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander --
	dprint ("Miller: Commander --");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I see it too. Crimson, heavy enemy movement, coming your way. Ready up.
	dprint ("Palmer: I see it too. Crimson, heavy enemy movement, coming your way. Ready up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00200'));
	
	end_radio_transmission();

	f_blip_flag (fl_e4m5_calloutflag01, "navpoint_goto");
	e4m5_narrative_is_on = FALSE;
	sleep (30 * 20);
	f_unblip_flag (fl_e4m5_calloutflag01);
end

script static void vo_e4m5_cleanupfore()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson, clear out all remaining Promethean targets.
	dprint ("Palmer: Crimson, clear out all remaining Promethean targets.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_prometheans_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_prometheans_00100'));
	
	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_forestragglers()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : You’ve still got some Promethean stragglers, Crimson. Take ‘em down.
	dprint ("Palmer: You’ve still got some Promethean stragglers, Crimson. Take ‘em down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_prometheans_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_prometheans_00200'));
	
	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_pelican()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Commander, Majestic's Pelican is inbound.
	dprint ("Dalton: Commander, Majestic's Pelican is inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Doctor Owen, prep our prize for transit.
	dprint ("Palmer: Doctor Owen, prep our prize for transit.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

	// Doctor Owen : On it, Commander.
	dprint ("Doctor Owen: On it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00300'));

	cui_hud_hide_radio_transmission_hud();

	sleep (30 * 1);

	// PIP	
	hud_play_pip_from_tag (bink\spops\ep4_m5_2_60);
	thread (pip_e4m5_2_subtitles());
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, you just keep being awesome down there.
	dprint ("Palmer: Crimson, you just keep being awesome down there.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00400_pip'));

	end_radio_transmission();
	// end PIP
	sleep (30 * 1);
	e4m5_narrative_is_on = FALSE;
end

script static void pip_e4m5_2_subtitles()
	sleep_s (1.07);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00400');
end


script static void vo_e4m5_killforerunners()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Lots of activity nearby. Be ready for anything, Crimson.
	dprint ("Miller: Lots of activity nearby. Be ready for anything, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_3_00100'));
	
	end_radio_transmission();
	e4m5_narrative_is_on = FALSE;
end


script static void vo_e4m5_outro()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There's Majestic, Commander.
	dprint ("Miller: There's Majestic, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Okay.  Doctor Owen, you've got a courier coming your way in the form of a Spartan.
	dprint ("Palmer: Okay.  Doctor Owen, you've got a courier coming your way in the form of a Spartan.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

	// Doctor Owen : We're ready.
	dprint ("Doctor Owen: We're ready.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00300'));

	end_radio_transmission();

	e4m5_narrative_is_on = FALSE;
end

script static void e4m5_callout_01()
	sleep_until (e4m5_narrative_is_on == FALSE);
	e4m5_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Look out, there's a Phantom headed your way!
	dprint ("Miller: Look out, there's a Phantom headed your way!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_7_00100'));
	
	sleep (30 * 1);
	f_blip_object (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_01.driver), default);
	
	end_radio_transmission();
	
	e4m5_narrative_is_on = FALSE;
end