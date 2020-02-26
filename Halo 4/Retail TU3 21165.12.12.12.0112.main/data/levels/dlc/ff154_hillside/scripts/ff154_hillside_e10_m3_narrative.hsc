//=============================================================================================================================
//============================================ E10M3 HILLSIDE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e10m3_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e10m3_start()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_e10m3_narr_start");
	music_set_state('Play_mus_pve_e10m3_narr_start');
	
	
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Miller, Crimson's heading into ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_start_00100' );
	// Dalton : Have them on the lookout for any survivors?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Have them on ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_start_00101' );
	// Miller : You got it, Dalton.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_start_00102' );
	// Miller : Crimson, you heard that? Eyes open.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson, you heard that? Eyes open.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_start_00103' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_downed_pelican()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_downed_pelican");
	music_set_state('Play_mus_pve_downed_pelican');
	
	// 10-3 Spartan (Male) : Spartans! Good to see you.
	//dprint ("10-3 Spartan (Male): Spartans! Good to see you.");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00100'));
	sleep(10);
	
	// 10-3 Spartan (Male) : Spartan Esposito, Fireteam [NAME].
	//dprint ("10-3 Spartan (Male): Spartan Esposito, Fireteam Forest.");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00101'));
	sleep(10);
	
	
	// 10-3 Spartan (Male) : We got shot down trying to secure the hill.
	//dprint ("10-3 Spartan (Male): We got shot down trying to secure the hill.");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00102'));
	sleep(10);
	
	
	// Miller : Glad to see you're still in one piece, Esposito.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Glad to see you're s...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00103' );
	
	// Miller : [NAME] are joining with Crimson for the duration.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller:Forest] are joining with ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00104' );
	
	// 10-3 Spartan (Male) : Understood, Spartan Miller.
	//dprint ("10-3 Spartan (Male): Understood, Spartan Miller.");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_downed_pelican_00105'));
	
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_to_gate()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_to_gate");
	music_set_state('Play_mus_pve_to_gate');
	
	// Miller : Roland, explain your plan. 
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Roland, explain your plan.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_to_gate_00100' );
	
	// Roland : Crimson needs a power supply for the Harvester, and there's a suitable supply at the top of this mountain.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Crimson needs a ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_to_gate_00101' );
	
	// Miller : Alright, Crimson. Onward and upward.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Alright, Crimson. Onward and upward.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_to_gate_00102' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_secure_gate_enter()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_secure_gate");
	music_set_state('Play_mus_pve_secure_gate');
	
	// Miller : Secure the gate, Spartans.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Secure the gate, Spartans.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_secure_gate_00100' );
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end

script static void vo_e10m3_secure_gate()
	// Miller : Roland, have we got a way through here?

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Roland, have we got a way through here?", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_secure_gate_00101' );
	
	// Roland : Marking it now.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: Marking it now.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_secure_gate_00102' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_basin()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_basin");
	music_set_state('Play_mus_pve_basin');
	
	// Miller : Crimson, be careful with the Ghosts.
	
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson, be careful with the Ghosts.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_basin_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_ghost()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_ghost");
	music_set_state('Play_mus_pve_ghost');

	// 10-3 Spartan (Male) : Wow. Nice moves, Crimson!
	//dprint ("10-3 Spartan (Male): Wow. Nice moves, Crimson!");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_ghost_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_ghost_00100'));
	
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_shields()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_shields");
	music_set_state('Play_mus_pve_shields');
	
	// Roland : The target is in the building behind that shield. 
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: The target is in the building behind that shield. ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_shields_00100' );
	
	// Miller : And that shield is being generated from... these locations.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: And that shield is being generated from... these locations.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_shields_00101' );
	b_e10_m3_generator_blip = TRUE;  // marks blips in mission script
	// Miller : Spartans, there's your targets.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Spartans, there's your targets.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_shields_00102' );
	
	
	// Miller : Take down those generators.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Take down those generators.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_shields_00103' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_first_down()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_first_down");
	music_set_state('Play_mus_pve_first_down');
	
	// 10-3 Spartan (Male) : One generator down, Miller!
	//dprint ("10-3 Spartan (Male): One generator down, Miller!");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_first_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_first_down_00100'));
	sleep(10);

	
	// Miller : Acknowledged, Esposito.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Acknowledged, Esposito.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_first_down_00101' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_first_down_alt()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_first_down_alt");
	music_set_state('Play_mus_pve_first_down_alt');
	
	// Miller : One down, two to go, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: One down, two to go, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_first_down_alt_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_second_down()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_second_down");
	music_set_state('Play_mus_pve_second_down');
	
	// 10-3 Spartan (Male) : That's two.
	//dprint ("10-3 Spartan (Male): That's two.");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_second_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_second_down_00100'));
	sleep(10);
	
	
	// Miller : One generator to go, Spartans.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: One generator to go, Spartans.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_second_down_00101' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_second_down_alt()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_second_down_alt");
	music_set_state('Play_mus_pve_second_down_alt');
	
	// Miller : That's two! Almost there, Crimson.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: That's two! Almost there, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_second_down_alt_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_third_down()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_third_down");
	music_set_state('Play_mus_pve_third_down');
	
	// Miller : That's everything. Shields down!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: That's everything. Shields down!", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_third_down_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_throwing()

sleep_until(e10m3_narrative_is_on == FALSE);
e10m3_narrative_is_on = TRUE;
//dprint("Play_mus_pve_third_down");
music_set_state('Play_mus_pve_throwing');

sleep(10);
// Miller : OK, into the structure. Target’s on your HUD.
dprint ("Miller: OK, into the structure. Target’s on your HUD.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\em10m3_throwing_00100a', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\em10m3_throwing_00100a'));

end_radio_transmission();
e10m3_narrative_is_on = FALSE;

end


script static void vo_e10m3_interior_pt_1()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_interior");
	music_set_state('Play_mus_pve_interior');
	
	// Miller : Roland, what are we looking for?

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Roland, what are we looking for?", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_interior_00100' );
	
	// Roland : That right there.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: That right there.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_interior_00101' );

	e10m3_narrative_is_on = FALSE;
end

script static void vo_e10m3_interior_pt_2()
	e10m3_narrative_is_on = TRUE;
	// Miller : That's a Covenant comm panel.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: That's a Covenant comm panel.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_interior_00102' );
	
	// Roland : Indeed it is. Press the button right in the middle and watch the fun.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: Indeed it is. ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_interior_00103' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_button_pressed()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_button_pressed");
	music_set_state('Play_mus_pve_button_pressed');
	
	// Dalton : Miller, you might want to give Crimson a heads up. Lich inbound.
	//dprint ("Dalton: Miller, you might want to give Crimson a heads up. Lich inbound.");
	spops_radio_transmission_start_dalton();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00100', NONE, 1);
	sleep (60);
	hud_play_pip_from_tag (levels\dlc\shared\binks\sp_g05_60);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00100')-60);
	sleep(10);

	// Roland : Of course there's a Lich inbound.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Of course there's a Lich inbound.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00101' );
	
	// Roland : Why else would I have Crimson trigger the alarm?

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Why else would I have Crimson trigger the alarm?", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00102' );
	
	// Miller : What?!

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: What?!", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00103' );
	
	// Roland : They’re going to steal the Lich’s engine core and use it to power the Harvester.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: They’re going to steal ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00104' );
	
	// Miller : Roland! You could have warned us what your plan was!

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Roland! You ...!", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00105' );
	
	// Roland : You could have asked!

	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: You could have asked!", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00106' );
	
	// Miller : I DID!

	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: I DID!", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_button_pressed_00107' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_fending_waves()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_fending_waves");
	music_set_state('Play_mus_pve_fending_waves');
	
	// Roland : The Lich will deploy its troops, then fall back and pepper the area with turret fire.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: The Lich will deploy its troops, ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_fending_waves_00100' );
	
	// Roland : That's when they're most vulnerable to a boarding action by Crimson.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: That's when they're ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_fending_waves_00101' );
	
	// Roland : A boarding action, given Crimson's record, that has a 93% chance of survivability.

	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: A boarding action, ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_fending_waves_00102' );
	
	// Miller : Roland, this kind of plan is unacceptable--

	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Miller: Roland, this kind of plan is unacceptable--", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_fending_waves_00102' );
	
	// Roland : Trust me. I've thought of everything.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: Trust me. I've thought of everything.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_fending_waves_00104' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_right()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_right");
	music_set_state('Play_mus_pve_right');
	
	// Roland : Hey, look at that. The Lich is right where Roland said it would be.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Hey, look at that. ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_right_00100' );
	
	// Roland : Miller, you should really apologize to the super genius AI.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Miller, you should really ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_right_00101' );
	
	// Miller : Crimson, I can’t say I think it’s sane, but it’s the only move we’ve got. Get onboard the Lich by any means necessary.
	//dprint ("Miller: Crimson, I can’t say I think it’s sane, but it’s the only move we’ve got. Get onboard the Lich by any means necessary.");
	spops_radio_transmission_start_miller();
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m3_1_60);
	thread (pip_e10m3_right_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_right_00102'));

	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void pip_e10m3_right_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_right_00102');
end


script static void vo_e10m3_jetpacks()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_jetpacks");
	music_set_state('Play_mus_pve_jetpacks');
	
	// 10-3 Spartan (Male) : Infinity, I've located some jet packs. Could help Crimson get onboard.
	//dprint ("10-3 Spartan (Male): Infinity, I've located some jet packs. Could help Crimson get onboard.");
	spops_radio_transmission_start_esposito();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_jetpacks_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_jetpacks_00100'));
	sleep(10);

	
	// Miller : Thanks, Esposito.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Thanks, Esposito.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_jetpacks_00101' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_jetpacks_alt()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_jetpacks_alt");
	music_set_state('Play_mus_pve_jetpacks_alt');
	
	// Roland : Listen, if they're having a hard time, there's always jet packs.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: Listen, ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_jetpacks_alt_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end

script static void vo_e10m3_onboard()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_onboard");
	music_set_state('Play_mus_pve_onboard');
	
	// Roland : Okay, here comes the hard part.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Okay, here comes the hard part.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_onboard_00100' );
	
	// Miller : Now's the hard part?

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Now's the hard part?", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_onboard_00101' );
	
	// Roland : I just tried to override the Lich's security locks, but nothing doing.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: I just tried to ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_onboard_00102' );
	
	// Roland : Crimson needs to get to the engine core rather than the cockpit.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Crimson needs to ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_onboard_00103' );
	
	// Roland : I'll mark it for you.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_, 0, 0, "Roland: I'll mark it for you.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_onboard_00104' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_take_core()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_take_core");
	music_set_state('Play_mus_pve_take_core');
	
	// Roland : There you go, Crimson. Grab that core.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: There you go, Crimson. Grab that core.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_take_core_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_core_taken()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_core_taken");
	music_set_state('Play_mus_pve_core_taken');
	
	// Miller : Roland, now that they've separated the core from the Lich…

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Roland, now that …", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_core_taken_00100' );
	
	// Roland : The Lich is wildly unstable, yeah. I suggest getting off of there, pronto.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: The Lich is wildly ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_core_taken_00101' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_lich_explodes()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_lich_explodes");
	music_set_state('Play_mus_pve_lich_explodes');
	
	// Roland : You have to admit... that was pretty awesome.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: You have to admit... that was pretty awesome.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_lich_explodes_00100' );
	
	// Miller : Awesome' isn't one of our criteria in planning Ops, Roland.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Awesome' isn't ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_lich_explodes_00101' );
	
	// Roland : Maybe it ought to be? Crimson handled it nicely.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Maybe it ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_lich_explodes_00102' );
	
	// Miller : Roland... just be quiet for a minute, okay? Let me think.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Roland... ", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_lich_explodes_00103' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_get_down_hill()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_get_down_hill");
	music_set_state('Play_mus_pve_get_down_hill');
	
	// Miller : Dalton, can we get anybody in to pull Crimson out?

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Dalton, ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_get_down_hill_00100' );
	
	// Dalton : Still way too hot. There's more Pelicans down since last we talked.
	//dprint ("Dalton: Still way too hot. There's more Pelicans down since last we talked.");
	spops_radio_transmission_start_dalton();
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_get_down_hill_00101', NONE, 1);
	//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_get_down_hill_00101'));
	sleep(10);
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Still way too hot...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_get_down_hill_00101' );
	
	// Miller : Okay, Crimson. Back down the hill. We'll get you out through the caves.
	//dprint ("Miller: Okay, Crimson. Back down the hill. We'll get you out through the caves.");
	spops_radio_transmission_start_miller();
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m3_2_60);
	thread (pip_e10m3_getdownhill_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_get_down_hill_00102'));

	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void pip_e10m3_getdownhill_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_get_down_hill_00102');
end


script static void vo_e10m3_downhill_fight()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_downhill_fight");
	music_set_state('Play_mus_pve_downhill_fight');
	
	// Miller : Keep going, Crimson. You're almost there.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Keep going, Crimson. You're almost there.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_fight_down_hill_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_cavern_door()
	e10m3_narrative_is_on = TRUE;
	dprint("Play_mus_pve_cavern_door");
	music_set_state('Play_mus_pve_cavern_door');
	
	// Miller : Return to the caves.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Return to the caves.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_cavern_door_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end


script static void vo_e10m3_game_out()
	e10m3_narrative_is_on = TRUE;
	//dprint("Play_mus_pve_game_out");
	music_set_state('Play_mus_pve_game_out');
	
	// Miller : We'll get you out on the other side, same way you came in.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 00, "Miller: We'll get you out ...", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_game_out_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end

script static void vo_e10m3_jetpacks_rvbalt()
	e10m3_narrative_is_on = TRUE;

	// Georgia : Cool! Jetpacks! That’ll help us get on that ship or mine name isn’t Agent Georgia.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, 0, 00, "Georgia : Cool! Jetpacks! That’ll help us get on that ship or mine name isn’t Agent Georgia.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_rvb_georgia_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end

script static void vo_e10m3_sky_is_falling_01()
	e10m3_narrative_is_on = TRUE;

	
	// Miller : We'll get you out on the other side, same way you came in.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 00, "Miller: Requiem’s still moving towards the sun, but we’re okay for now... ", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m03_skyfall_00100' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end

script static void vo_e10m3_sky_is_falling_02()
	e10m3_narrative_is_on = TRUE;

	
	// Miller : Those quakes are just going to get worse the closer to the sun we get. Move quick, Spartans.

	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 00, "Miller: Those quakes are just going to get worse the closer to the sun we get. Move quick, Spartans.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m03_skyfall_00101' );
	
	spops_radio_transmission_end_all();
	e10m3_narrative_is_on = FALSE;
end

// ============================================	MISC SCRIPT	========================================================