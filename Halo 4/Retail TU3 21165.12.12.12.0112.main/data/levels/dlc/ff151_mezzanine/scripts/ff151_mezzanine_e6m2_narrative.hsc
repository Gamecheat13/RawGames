//=============================================================================================================================
//============================================ E6M2 MEZZANINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e6m2_narrative_is_on = FALSE;


// ============================================	PUP SCRIPT	========================================================


// ============================================	VO SCRIPT	========================================================


script static void vo_e6m2_requiem_exterior()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_requiem_exterior");
	music_set_state('Play_mus_pve_e06m2_requiem_exterior');
		// Sangheli Radio Voice : --Nnse-kooree-koocha nee-ey-mawoo.
		dprint ("Sangheli Radio Voice: --Nnse-kooree-koocha nee-ey-mawoo.");
		start_radio_transmission("jul_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00100c', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00100c'));
		sleep(10);

	// Roland : Covie battlenet thinks Crimson's Phantom still belongs to them. They're ordering it to land at a secure facility.
	dprint ("Roland: Covie battlenet thinks Crimson's Phantom still belongs to them. They're ordering it to land at a secure facility.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00100'));
	sleep(10);
	
	// Miller : Lieutenant Murphy, play along for now.
	dprint ("Miller: Lieutenant Murphy, play along for now.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00101'));
	sleep(10);
	
	// Murphy : Roger that.
	dprint ("Murphy: Roger that.");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_roger_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_roger_01'));
	
	sleep_until( f_spops_mission_start_complete(), 1 );
	sleep (30);
	
	//hud_play_pip_from_tag (bink\spops\ep1_m1_1_60);
	// Palmer : Crimson, if the battlenet considers that location important, I'd like to know why. Have a look around.
	dprint ("Palmer: Crimson, if the battlenet considers that location important, I'd like to know why. Have a look around.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	hud_play_pip_from_tag( "levels\dlc\shared\binks\ep6_m2_1_60" );
	thread (pip_e6m2_exterior_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00102'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void pip_e6m2_exterior_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_patrol_phantoms_00102');
end


script static void vo_e6m2_begin_attack()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_begin_attack");
	music_set_state('Play_mus_pve_e06m2_begin_attack');
		
	// Roland : Guys? I think they know Crimson's not Covenant.
	dprint ("Roland: Guys? I think they know Crimson's not Covenant.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_covenant_attack_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_covenant_attack_00100'));
	sleep(10);
	
	// Palmer : Handle it, Crimson.
	dprint ("Palmer: Handle it, Crimson.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_covenant_attack_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_covenant_attack_00101'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_gets_close()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_gets_close");
	music_set_state('Play_mus_pve_e06m2_gets_close');
	
	// Roland : Hey, that's UNSC gear. What's it doing here?
	dprint ("Roland: Hey, that's UNSC gear. What's it doing here?");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_too_close_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_too_close_00100'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_covenant_cleanedout()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_covenant_cleanedout");
	music_set_state('Play_mus_pve_e06m2_covenant_cleanedout');

	// Miller : Commander Palmer, there's a comm relay near Crimson's position. Could be worth a look.
	dprint ("Miller: Commander Palmer, there's a comm relay near Crimson's position. Could be worth a look.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00100'));
	sleep(10);
	
	// Palmer : Light the way, miller.
	dprint ("Palmer: Light the way, miller.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00101'));
	//sleep(10);
	
/*	// Miller : Those controls are your way inside.
	dprint ("Miller: Those controls are your way inside.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00102'));
	sleep(10);*/
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_head_inside()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_head_inside");
	music_set_state('Play_mus_pve_e06m2_head_inside');

	// Miller : Structure's open. That where our computer is?
	dprint ("Miller: Structure's open. That where our computer is?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_head_inside_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_head_inside_00100'));
	sleep(10);
	
	// Roland : Yup. Go get 'em, Crimson.
	dprint ("Roland: Yup. Go get 'em, Crimson.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_head_inside_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_head_inside_00101'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_stragglers_cleared()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_stragglers_cleared");
	music_set_state('Play_mus_pve_e06m2_stragglers_cleared');

/*	// Roland : I've marked the computer system in question.
	dprint ("Roland: I've marked the computer system in question.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_stragglers_cleared_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_stragglers_cleared_00100'));
	sleep(10);
	*/
	// Miller : What have we got, Roland?
	dprint ("Miller: What have we got, Roland?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00100'));
	sleep(10);
	
	// Roland : Standard Covie encryption, with a hardware lock. Crimson, open it up for me?
	dprint ("Roland: Standard Covie encryption, with a hardware lock. Crimson, open it up for me?");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00101'));
	sleep(10);

	e6m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e6m2_showing_data()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_showing_data");
	music_set_state('Play_mus_pve_e06m2_showing_data');
	hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G01_60" );
	
	// Roland : Awesome. I'll transit a worm into the Covie system through Crimson's short range… and we're in business!
	dprint ("Roland: Awesome. I'll transit a worm into the Covie system through Crimson's short range… and we're in business!");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00102'));
	sleep(10);

/*	// Roland : Oh nice. This is covering supply routes, systems planning…
	dprint ("Roland: Oh nice. This is covering supply routes, systems planning…");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00103'));
	sleep(10);*/

	// Palmer : Good find. Pass everything we get to Infinity Command.
	dprint ("Palmer: Good find. Pass everything we get to Infinity Command.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00104'));
	sleep(10);
	
/*	// Palmer : Miller, get Crimson an extraction point.
	dprint ("Palmer: Miller, get Crimson an extraction point.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00105'));
	sleep(10);*/

	
	end_radio_transmission();	
	e6m2_narrative_is_on = FALSE;
end

	
script static void vo_e6m2_special_door()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_door_callout");
	music_set_state('Play_mus_pve_e06m2_door_callout');

	// Miller : Right through that door, Crimson.
	dprint ("Miller: Right through that door, Crimson.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_door_callout_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_door_callout_00100'));
	
	end_radio_transmission();	
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_reinforcements_inbound()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_reinforcements_inbound");
	music_set_state('Play_mus_pve_e06m2_reinforcements_inbound');

	// Miller : Bad guys inbound.
	dprint ("Miller: Bad guys inbound.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_reinforcements_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_reinforcements_00100'));
	
	// Miller : You've got this one, Spartans.
	dprint ("Miller: You've got this one, Spartans.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_first_patrol_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_first_patrol_00100'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end



script static void vo_e6m2_second_computer()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_showing_data");
	music_set_state('Play_mus_pve_e06m2_second_computer');
	
	
	// Miller : Actually, Commander... Looking at Roland's data, there's other comm nodes nearby. Redundant systems.
	dprint ("Miller: Actually, Commander... Looking at Roland's data, there's other comm nodes nearby. Redundant systems.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00106', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00106'));
	sleep(10);
	
	// Miller : We could get an ear in them too.
	dprint ("Miller: We could get an ear in them too.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00107', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00107'));
	sleep(10);
	
	// Palmer : I love it. Make it happen.
	dprint ("Palmer: I love it. Make it happen.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00108', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_activiate_first_00108'));
	sleep(10);
	
	
	// Miller : There's the second computer.
	dprint ("Miller: There's the second computer.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00100'));
	sleep(10);
	
	f_blip_object_cui (e6m2_covcpu_02, "navpoint_activate");
	
	// Miller : Crimson, release the hardware lock for Roland.
	dprint ("Miller: Crimson, release the hardware lock for Roland.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00101'));
	sleep(10);

	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_second_computer_opened()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_second_computer_opened");
	music_set_state('Play_mus_pve_e06m2_second_computer_opened');
	
	// Palmer : Roland. Work your magic.
	dprint ("Palmer: Roland. Work your magic.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00102'));
	sleep(10);
	hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G02_60" );
	sleep_s(4);
	// Roland : Hey presto! Worm installed. Oh, look at that. Detailed troop movements.
	dprint ("Roland: Hey presto! Worm installed. Oh, look at that. Detailed troop movements.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00103'));
	sleep(10);
	
	// Miller : Good stuff. Keep rolling, Crimson.
	dprint ("Miller: Good stuff. Keep rolling, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00104'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end
	
	
script static void vo_e6m2_second_patrol()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_second_patrol");
	music_set_state('Play_mus_pve_e06m2_second_patrol');
	
	// Miller : More covies in the way. Take them out!
	dprint ("Miller: More covies in the way. Take them out!");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_second_computer_00105'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_third_computer()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_third_computer");
	music_set_state('Play_mus_pve_e06m2_third_computer');

	// Palmer : Where's my last target, Miller?
	dprint ("Palmer: Where's my last target, Miller?");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00100'));
	sleep(10);

	// Miller : Marking it now.
	dprint ("Miller: Marking it now.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00101'));
	
	f_blip_object_cui (e6m2_covcpu_03, "navpoint_activate");
	
//	// Palmer : Crimson, clear the bad guys.
//	dprint ("Palmer: Crimson, clear the bad guys.");
//	start_radio_transmission("palmer_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00102', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00102'));
//	sleep(10);
	
//	// Palmer : Get to that computer.
//	dprint ("Palmer: Get to that computer.");
//	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00103', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00103'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_button_pushed()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_button_pushed");
	music_set_state('Play_mus_pve_e06m2_button_pushed');
	hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G03_60" );
	// Roland : Installing the worm, and… Uh oh.
	dprint ("Roland: Installing the worm, and… Uh oh.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00100'));
	sleep(10);
	
	// Palmer : Explain. Now.
	dprint ("Palmer: Explain. Now.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00101'));
	sleep(10);
	
	hud_play_pip_from_tag("levels\dlc\shared\binks\SP_G09_60");
	// Roland : Um, the whole system went into lockdown. Aaaand they're sending in reinforcements.
	dprint ("Roland: Um, the whole system went into lockdown. Aaaand they're sending in reinforcements.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	thread (e6m2_cov_alarm()); //PLAY ALARM AUDIO DURING VO LINE
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00102'));
	sleep(10);
	
	// Miller : Roland, get the worm back up and running. Crimson, prep for incoming.
	dprint ("Miller: Roland, get the worm back up and running. Crimson, prep for incoming.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_button_pushed_00103'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_destroy_terminals()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_destroy_terminals");
	music_set_state('Play_mus_pve_e06m2_destroy_terminals');

	// Roland : The lockdown is controlled by two terminals. Disabling them should let me back in.
	dprint ("Roland: The lockdown is controlled by two terminals. Disabling them should let me back in.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00100'));
	sleep(10);

	// Palmer : Should or will?
	dprint ("Palmer: Should or will?");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00101'));
	sleep(10);
	
	// Roland : A 90% chance of will.
	dprint ("Roland: A 90% chance of will.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00102'));
	sleep(10);
	
	// Palmer : I'll take it. Crimson, destroy those terminals and take out any Covenant resistance in the way.
	dprint ("Palmer: I'll take it. Crimson, destroy those terminals and take out any Covenant resistance in the way.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_destroy_terminals_00103'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_comm_down()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_comm_down");
	music_set_state('Play_mus_pve_e06m2_comm_down');
	
	// Roland : One down.
	dprint ("Roland: One down.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00100'));
	sleep(10);
	
	// Miller : Hit the last terminal!
	dprint ("Miller: Hit the last terminal!");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00101'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_drop_forces()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_drop_forces");
	music_set_state('Play_mus_pve_e06m2_drop_forces');

	// Murphy : Crimson. Murphy. I'm trying to keep Covies off of ya, but one slipped through. Heads up?
	dprint ("Murphy: Crimson. Murphy. I'm trying to keep Covies off of ya, but one slipped through. Heads up?");
	start_radio_transmission("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_forces_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_forces_00100'));
	sleep(10);
	
	// Miller : Thanks, Murphy.
	dprint ("Miller: Thanks, Murphy.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_forces_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_forces_00101'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_turret_callout()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_turret_callout");
	music_set_state('Play_mus_pve_e06m2_turret_callout');
	
	// Miller : Crimson, there's four shade turrets arranged along the structure. Might be useful for defense.
	dprint ("Miller: Crimson, there's four shade turrets arranged along the structure. Might be useful for defense.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_shade_turret_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_shade_turret_00100'));
	sleep(10);
	
	// Palmer : Sounds like a damn fine plan to me, Miller.
	dprint ("Palmer: Sounds like a damn fine plan to me, Miller.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_shade_turret_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_shade_turret_00101'));
	sleep(10);
	
	// Palmer : Crimson, get to those turrets.
	dprint ("Palmer: Crimson, get to those turrets.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_shade_turret_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_shade_turret_00102'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_never_got_gear()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_never_got_gear");
	music_set_state('Play_mus_pve_e06m2_never_got_gear');
	
	// Miller : Is that... That's UNSC gear, isn't it?
	dprint ("Miller: Is that... That's UNSC gear, isn't it?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_no_gear_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_no_gear_00100'));
	sleep(10);
	
	// Palmer : Thieving freaks... Crimson, see if you can find anything useful.
	dprint ("Palmer: Thieving freaks... Crimson, see if you can find anything useful.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_no_gear_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_no_gear_00101'));
	
	end_radio_transmission();
	f_blip_flag (fl_e6m2_unscrack01, ammo);
	
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_remind_gear()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_remind_gear");
	music_set_state('Play_mus_pve_e06m2_remind_gear');

	// Roland : Crimson, don't forget you might have something useful in that UNSC gear the Covies lifted.
	dprint ("Roland: Crimson, don't forget you might have something useful in that UNSC gear the Covies lifted.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_no_gear_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_no_gear_00102'));
	
	end_radio_transmission();
	f_blip_flag (fl_e6m2_unscrack01, ammo);
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_drops_banshee_1()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_drops_banshee_1");
	music_set_state('Play_mus_pve_e06m2_drops_banshee_1');
	
	// Miller : Banshee! Eyes to the sky, Crimson.
	dprint ("Miller: Banshee! Eyes to the sky, Crimson.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_banshee_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_banshee_00100'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_drops_banshee_2()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_drops_banshee_2");
	music_set_state('Play_mus_pve_e06m2_drops_banshee_2');

	// Miller : Be advised, another Banshee in your air space.
	dprint ("Miller: Be advised, another Banshee in your air space.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_banshee_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_banshee_00101'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_before_terminals()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_before_terminals");
	music_set_state('Play_mus_pve_e06m2_before_terminals');

	// Palmer : Very thorough, Spartans. Now, take out those terminals so Roland can work.
	dprint ("Palmer: Very thorough, Spartans. Now, take out those terminals so Roland can work.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_kills_covenant_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_kills_covenant_00100'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_terminals_destroyed()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_terminals_destroyed");
	music_set_state('Play_mus_pve_e06m2_terminals_destroyed');

	// Roland : Boom! That did it. I'm back in!
	dprint ("Roland: Boom! That did it. I'm back in!");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00102'));
	sleep(10);
	
	// Roland : Commander Palmer, worm's functional on all three channels. Tap is active. Hot and cold running information.
	dprint ("Roland: Commander Palmer, worm's functional on all three channels. Tap is active. Hot and cold running information.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00103'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_following_destruction()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_following_destruction");
	music_set_state('Play_mus_pve_e06m2_following_destruction');
	
	// Miller : Crimson, clear an area for Murphy to land.
	dprint ("Miller: Crimson, clear an area for Murphy to land.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_terminal_destruction_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_terminal_destruction_00100'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_finally_dead()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_finally_dead");
	music_set_state('Play_mus_pve_e06m2_finally_dead');
	
	// Miller : Murphy, Crimson's clear for pick up.
	dprint ("Miller: Murphy, Crimson's clear for pick up.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_convenant_dead_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_convenant_dead_00100'));
	sleep(10);
	
	// Murphy : On it, Spartan!
	dprint ("Murphy: On it, Spartan!");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_convenant_dead_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_convenant_dead_00101'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_excellent()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_excellent");
	music_set_state('Play_mus_pve_e06m2_excellent');
	
	//hud_play_pip_from_tag (bink\spops\ep1_m2_2_60);
	// Palmer : Excellent work, Crimson. Sorry I've been away for a bit, but it looks like Miller has things well in hand. I'm going to review the data we're pulling down and I'll be back in touch with you shortly.
	dprint ("Palmer: Excellent work, Crimson. Sorry I've been away for a bit, but it looks like Miller has things well in hand. I'm going to review the data we're pulling down and I'll be back in touch with you shortly.");
	start_radio_transmission("palmer_transmission_name");
	hud_play_pip_from_tag( "levels\dlc\shared\binks\ep6_m2_2_60" );
	thread (pip_e6m2_excellent_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_out_00101'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void pip_e6m2_excellent_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_out_00101');
end


script static void vo_e6m2_new_ending()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e06m2_new_ending");
	music_set_state('Play_mus_pve_e06m2_new_ending');
	
		// Murphy : Looks like you guys could use a hand!
		dprint ("Murphy: Looks like you guys could use a hand!");
		cui_hud_show_radio_transmission_hud("murphy_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_newending_00100', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_newending_00100'));
		sleep(10);
		
		// Murphy : Crimson, I can take care of those comms for ya! Stand back!
		dprint ("Murphy: Crimson, I can take care of those comms for ya! Stand back!");
		cui_hud_show_radio_transmission_hud("murphy_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_newending_00101', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_newending_00101'));
		sleep(10);
		
		// Palmer : Lieutenant Murphy’s quite the over achiever.
		dprint ("Palmer: Lieutenant Murphy’s quite the over achiever.");
		cui_hud_show_radio_transmission_hud("palmer_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_newending_00102', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_newending_00102'));
		
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


// ============================================	GLOBAL VO SCRIPT	========================================================

script static void vo_e6m2_global_palmer_phantom_01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	// Palmer : Phantom on approach.
	dprint ("Palmer: Phantom on approach.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_phantom_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_phantom_01'));
		
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_palmer_fewmore_08()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	// Palmer : I'm still seeing targets down there.
	dprint ("Palmer: I'm still seeing targets down there.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_08', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_08'));
		
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_palmer_fewmore_03()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	// Palmer : Few more to go.
	dprint ("Palmer: Few more to go.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_03', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_03'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_miller_droppod_01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	start_radio_transmission("miller_transmission_name");
	// Miller : Drop pod incoming!
	dprint ("Miller: Drop pod incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100'));

	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_palmer_droppod_01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
		
	// Palmer : Eyes up!
	dprint ("Palmer: Eyes up!");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_09', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_09'));
	
	// Palmer : Covenant inbound!
	dprint ("Palmer: Covenant inbound!");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_05', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_05'));

	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_palmer_hunters_01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	// Palmer : Hunters!
	dprint ("Palmer: Hunters!");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hunters_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hunters_01'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_miller_reinforcements_01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	// Miller : Reinforcements!
	dprint ("Miller: Reinforcements!");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_01'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_miller_few_more_07()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	// Miller : Mop up the last of them.
	dprint ("Miller: Mop up the last of them.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_07', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_07'));
	
	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


script static void vo_e6m2_global_miller_sniper()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	// Miller : Sniper!
	dprint ("Miller: Sniper!");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_1_00100'));

	end_radio_transmission();
	e6m2_narrative_is_on = FALSE;
end


//-------------------------------------------------Extra/Not Used------------------------------------------------------//

script static void e6m2_cov_alarm()
	//sleep_s (2);
	//dprint ( "================ PLAY ALARM! ==================" );
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\scripted\amb_mezzanine_e6m2_cov_alarm', e6m2_covalarm_emitter, 1 ); //Covenant Alarm
end

script static void vo_e6m2_clear_covenant()
sleep_until (e6m2_narrative_is_on == FALSE, 1);
e6m2_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m2_clear_covenant");
music_set_state('Play_mus_pve_e06m2_clear_covenant');

// Miller : Stay focused, Crimson. More bad guys.
dprint ("Miller: Stay focused, Crimson. More bad guys.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_clear_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_clear_00100'));

e6m2_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m2_thanksroland()
sleep_until (e6m2_narrative_is_on == FALSE, 1);
e6m2_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m2_drops_thanksroland");
music_set_state('Play_mus_pve_e06m2_thanksroland');

// Miller : Thanks, Roland.
dprint ("Miller: Thanks, Roland.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_stragglers_cleared_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_stragglers_cleared_00101'));
	
e6m2_narrative_is_on = FALSE;
end_radio_transmission();
end


script static void vo_e6m2_button_approached()
sleep_until (e6m2_narrative_is_on == FALSE, 1);
e6m2_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m2_button_approached");
music_set_state('Play_mus_pve_e06m2_button_approached');

// Miller : Have at it, Crimson.
dprint ("Miller: Have at it, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_third_computer_00104'));

e6m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m2_covenant_waypoint()
sleep_until (e6m2_narrative_is_on == FALSE, 1);
sleep (1);
dprint("Play_mus_pve_e06m2_covenant_waypoint");
music_set_state('Play_mus_pve_e06m2_covenant_waypoint');

//// Miller : Commander Palmer, there's a comm relay near Crimson's position. Could be worth a look.
//dprint ("Miller: Commander Palmer, there's a comm relay near Crimson's position. Could be worth a look.");
//cui_hud_show_radio_transmission_hud("miller_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00100', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00100'));
//sleep(10);
//
//// Palmer : Light the way, miller.
//dprint ("Palmer: Light the way, miller.");
//cui_hud_show_radio_transmission_hud("palmer_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00101', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00101'));
//sleep(10);
//
//// Miller : Those controls are your way inside.
//dprint ("Miller: Those controls are your way inside.");
//cui_hud_show_radio_transmission_hud("miller_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00102', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_waypoint_00102'));
//sleep(10);
//
//e6m2_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m2_boards_phantom()
sleep_until (e6m2_narrative_is_on == FALSE, 1);
e6m2_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m2_boards_phantom");
music_set_state('Play_mus_pve_e06m2_boards_phantom');

// Murphy : Infinity, I'm outbound with Crimson.
dprint ("Murphy: Infinity, I'm outbound with Crimson.");
start_radio_transmission("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_out_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_phantom_out_00100'));

e6m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m2_extraction_point()
sleep_until (e6m2_narrative_is_on == FALSE, 1);
e6m2_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m2_extraction_point");
music_set_state('Play_mus_pve_e06m2_extraction_point');

// Murphy : Not to complain, but this does need to be a quick pick up. Can Crimson be on station and waiting?
dprint ("Murphy: Not to complain, but this does need to be a quick pick up. Can Crimson be on station and waiting?");
start_radio_transmission("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_extraction_point_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_extraction_point_00100'));
sleep(10);

// Palmer : Crimson, show the Marine how fast Spartans can be.
dprint ("Palmer: Crimson, show the Marine how fast Spartans can be.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_extraction_point_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_extraction_point_00101'));
sleep(10);

// Palmer : Get to the extraction point, double time.
dprint ("Palmer: Get to the extraction point, double time.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_extraction_point_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_extraction_point_00102'));

e6m2_narrative_is_on = FALSE;
end_radio_transmission();

end
