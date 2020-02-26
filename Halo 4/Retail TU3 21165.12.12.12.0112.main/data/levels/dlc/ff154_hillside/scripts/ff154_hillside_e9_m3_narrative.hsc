//=============================================================================================================================
//============================================ E9M3 HILLSIDE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e9m3_narrative_is_on = FALSE;


// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================



// ============================================	MISC SCRIPT	========================================================


script static void vo_e9m3_narrative_in()
dprint("Play_mus_pve_e09m3_narrative_in");
music_set_state('Play_mus_pve_e09m3_narrative_in');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Spartan Dalton, Fireteam Crimson is in position. Where's the package I requisitioned?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Spartan Dalton, Fireteam Crimson is in position. Where's the package I requisitioned?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_scorpion_tanks_00100' );
	// Dalton : Pelicans are on station, Miller. They've got your package in tow.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Pelicans are on station, Miller. They've got your package in tow.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_scorpion_tanks_00101' );
	// Miller : Great timing, Dalton. Crimson, your rides await.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Great timing, Dalton. Crimson, your rides await.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_scorpion_tanks_00102' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_science_bases()
dprint("Play_mus_pve_e09m3_science_bases");
music_set_state('Play_mus_pve_e09m3_science_bases');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Doctor Halsey routed her transmissions through a facility part way up Apex. Only way through is up the middle, Crimson. Have at it.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Doctor Halsey routed her transmissions through a facility part way up Apex. Only way through is up the middle, Crimson. Have at it.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_science_bases_00100' );
	// Glassman : I'm here, Spartan.
	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, 0, 10, "Glassman: I'm here, Spartan.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_science_bases_00101' );
	// Miller : Crimson's on the ground and rolling, Doctor.
//	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Crimson's on the ground and rolling, Doctor.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_science_bases_00102' );
	// Glassman : Got it. Watching the datafeed now.
//	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, 0, 0, "Glassman: Got it. Watching the datafeed now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_science_bases_00103' );
	// Miller : Crimson, I'm marking targets for you now.
	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Crimson, I'm marking targets for you now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_science_bases_00104' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_crawlers()

dprint("deprecated");
	
end

script static void vo_e9m3_before_ghosts()

dprint("deprecated");
	
end

script static void vo_e9m3_ghosts_arrive()
dprint("deprecated");

end

script static void vo_e9m3_phantom_trouble()
dprint("Play_mus_pve_e09m3_phantom_trouble");
music_set_state('Play_mus_pve_e09m3_phantom_trouble');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Dalton : Miller, that Phantom's not leaving the area. Can Crimson convince it to bug out?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Miller, that Phantom's not leaving the area. Can Crimson convince it to bug out?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_phantom_trouble_00100' );
	
	// Miller : Could do that, sure. Crimson, take care of Dalton's problem Phantom?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Could do that, sure. Crimson, take care of Dalton's problem Phantom?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_phantom_trouble_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_watchers()

dprint("deprecated");

end

script static void vo_e9m3_shield_is_up()

dprint("Play_mus_pve_e09m3_shield_is_up");
music_set_state('Play_mus_pve_e09m3_shield_is_up');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	//Miller : Lighting up the shield controls for you.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller : Lighting up the shield controls for you.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00100' );
	e9m3_narrative_is_on = FALSE;


end
/*
	// Roland : I'll mark it for you.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_, 0, 0, "Roland: I'll mark it for you.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_onboard_00104' );
	
	// Roland : Marking it now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: Marking it now.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_secure_gate_00102' );
	
*/

script static void vo_e9m3_button_pressed()
dprint("Play_mus_pve_e09m3_button_pressed");
music_set_state('Play_mus_pve_e09m3_button_pressed');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;

	// Miller: The shields should be weak enough to bring down now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: The shields should be weak enough to bring down now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00300' );
	/*
	// Miller : Alright, Crimson. Brute force it. Shoot it till it breaks.
	dprint ("Miller: Alright, Crimson. Brute force it. Shoot it till it breaks.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00104'));
*/
/*
	//Miller : I thought that would bring the shields down. Roland?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: I thought that would bring the shields down. Roland?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00101' );
	// Roland : Hey hey.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland : Hey hey.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00102' );
	// Roland : Looks like the Covies learned their lesson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Looks like the Covies learned their lesson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00103' );
	// Roland : Just a moment while I check...
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: I'll try to crack the shields through Crimson's short range comms.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00104' );
	// Roland : Take just a second.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: Take just a second.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00105' );
	*/
	e9m3_narrative_is_on = FALSE;
end


script static void vo_e9m3_area_secure()
dprint("Play_mus_pve_e09m3_area_secure");
music_set_state('Play_mus_pve_e09m3_area_secure');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	/*
	// Roland : Looks like the Covies learned their lesson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Looks like the Covies learned their lesson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00103' );
	
	// Roland : Roland: I'll try to crack the shields through Crimson's short range comms.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: I'll try to crack the shields through Crimson's short range comms.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00104' );
	*/
	
	// Roland : Can't turn the shields off, but I can weaken them enough that Crimson should be able to bring 'em down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland : Can't turn the shields off, but I can weaken them enough that Crimson should be able to bring 'em down.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_areasecure_00100' );
	
	//Miller : Lighting up the shield controls for you.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller : Lighting up the shield controls for you.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shieldup_00100' );
	
	/*
	// Roland : Marking it now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland: Marking it now.", 'sound\dialog\storm_multiplayer\pve\ep_10_mission_03\e10m3_secure_gate_00102' );
	
	// Miller : Do it, Roland. Crimson, blast your way through.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Do it, Roland. Crimson, blast your way through.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_area_secure_00101' );
	*/
	e9m3_narrative_is_on = FALSE;
end

script static void vo_e9m3_fallback()
dprint("Play_mus_pve_e09m3_fallback");
music_set_state('Play_mus_pve_e09m3_fallback');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Dalton, Crimson could use a Scorpion refresh
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Dalton, Crimson could use a Scorpion refresh.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_fallback_00100' );
	
	// Dalton : Got it, Miller. Dropping them in now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: Got it, Miller. Dropping them in now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_fallback_00101' );
	e9m3_narrative_is_on = FALSE;
	
end


script static void vo_e9m3_1sttrace()
dprint("Play_mus_pve_e09m3_1sttrace");
music_set_state('Play_mus_pve_e09m3_1sttrace');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : The location where Halsey routed her communications is up ahead.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: The location where Halsey routed her communications is up ahead.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_1sttrace_00100' );
	
	e9m3_narrative_is_on = FALSE;
	
end


script static void vo_e9m3_cannon()

dprint("deprecated");
	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
			vo_glo15_miller_waypoint_01();
			// Miller: setting a waypoint
			// temp til a better replacement gets re-added
	
	e9m3_narrative_is_on = FALSE;
end

script static void vo_e9m3_didnt_work()

dprint("deprecated");

end

script static void vo_e9m3_roland_plan()

dprint("deprecated");
end

script static void vo_e9m3_dont_activate()

dprint("deprecated");

end

script static void vo_e9m3_shooting_shield()
dprint("Play_mus_pve_e09m3_shooting_shield");
music_set_state('Play_mus_pve_e09m3_shooting_shield');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : That shield's only gonna come down if you use the Scorpion's big gun.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: That shield's only gonna come down if you use the Scorpion's big gun.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shooting_shield_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_shield_down()
	
	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	
	// Miller : Nicely done.
	dprint ("Miller: Nicely done.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_04', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_04'));
	sleep(10);
	
	// Miller : Roll on, Crimson.
	dprint ("Miller: Roll on, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_01'));
	sleep(10);
	
	// Miller : Marking your target now.
	dprint ("Miller: Marking your target now.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_02', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_02'));
	
	end_radio_transmission();
	e9m3_narrative_is_on = false;
	
end

script static void vo_e9m3_hilltop_az()
dprint("Play_mus_pve_e09m3_hilltop_az");
music_set_state('Play_mus_pve_e09m3_hilltop_az');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : There's a terminal inside that building where-
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: There's a terminal inside that building where-", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_hilltop_az_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_ambush()
dprint("Play_mus_pve_e09m3_ambush");
music_set_state('Play_mus_pve_e09m3_ambush');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Ambush!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Ambush!", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_ambush_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_toomanybaddies()
dprint("Play_mus_pve_e09m3_toomanybaddies");
music_set_state('Play_mus_pve_e09m3_ambush');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Worry about the bad guys first and play detective second.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller : Worry about the bad guys first and play detective second.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_toomanybaddies_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_behind_you()
dprint("Play_mus_pve_e09m3_behind_you");
music_set_state('Play_mus_pve_e09m3_behind_you');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Careful, Spartans! They're boxing you in!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Careful, Spartans! They're boxing you in!", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_behind_you_00100' );
	
	e9m3_narrative_is_on = FALSE;
	
end

script static void vo_e9m3_tracecall()
dprint("Play_mus_pve_e09m3_tracecallu");
music_set_state('Play_mus_pve_e09m3_tracecall');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;

	// Roland : Crimson, access the marked terminal.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland : Crimson, access the marked terminal.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_tracecall_00100' );
	

	e9m3_narrative_is_on = FALSE;
	
end

script static void vo_e9m3_tracecall_02()

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short', cr_e9m3_terminal, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short'));

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;

// Miller : Roland, what can you see?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Roland, what can you see?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_tracecall_00101' );
	// Miller : More signal bouncing. But the bounces are getting shorter. Next one's just at the top of Apex.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: More signal bouncing. But the bounces are getting shorter. Next one's just at the top of Apex.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_tracecall_00102' );
	
	e9m3_narrative_is_on = FALSE;
	
end



script static void vo_e9m3_shield_control()
dprint("Play_mus_pve_e09m3_shield_control");
music_set_state('Play_mus_pve_e09m3_shield_control');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Hold on. I'm looking for a way to bring that shield down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Hold on. I'm looking for a way to bring that shield down.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shield_control_00100' );
	sleep_s(2);
	// Miller : I'm not finding anything on your side. But there does appear to be a side path. Let me mark that for you.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: I'm not finding anything on your side. But there does appear to be a side path. Let me mark that for you.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_shield_control_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_traveling_line_1()
dprint("Play_mus_pve_e09m3_traveling_lines");
music_set_state('Play_mus_pve_e09m3_traveling_lines');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Right there, Crimson, through the pass.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Right there, Crimson, through the pass.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_traveling_lines_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_traveling_line_2()
dprint("Play_mus_pve_e09m3_traveling_lines");
music_set_state('Play_mus_pve_e09m3_traveling_lines');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Straight up that hill.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Straight up that hill.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_traveling_lines_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_traveling_line_3()
dprint("Play_mus_pve_e09m3_traveling_lines");
music_set_state('Play_mus_pve_e09m3_traveling_lines');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Almost there, Spartans.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Almost there, Spartans.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_traveling_lines_00102' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_traveling_line_4()
dprint("Play_mus_pve_e09m3_traveling_lines");
music_set_state('Play_mus_pve_e09m3_traveling_lines');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Looking good. Keep it up.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Looking good. Keep it up.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_traveling_lines_00103' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_complications_phantoms()
dprint("Play_mus_pve_e09m3_complications_phantoms");
music_set_state('Play_mus_pve_e09m3_complications_phantoms');


	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Dalton : Miller, you've got Phantoms inbound on Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: Miller, you've got Phantoms inbound on Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_complications_phantoms_00100' );
	
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_complications_ghosts()
dprint("Play_mus_pve_e09m3_complications_ghosts");
music_set_state('Play_mus_pve_e09m3_complications_ghosts');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Keep an eye out for those Ghosts.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Keep an eye out for those Ghosts.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_complications_ghosts_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_complications_turrets()

dprint("deprecated");

end


script static void vo_e9m3_watchers_1()
dprint("Play_mus_pve_e09m3_watchers_crawlers");
music_set_state('Play_mus_pve_e09m3_watchers_crawlers');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : You've got several Watchers in the area.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: You've got several Watchers in the area.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_watchers_crawlers_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_crawlers_1()
dprint("Play_mus_pve_e09m3_watchers_crawlers");
music_set_state('Play_mus_pve_e09m3_watchers_crawlers');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Be advised, heavy Crawler presence.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Be advised, heavy Crawler presence.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_watchers_crawlers_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_covenant_incoming()
dprint("Play_mus_pve_e09m3_covenant_incoming");
music_set_state('Play_mus_pve_e09m3_covenant_incoming');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Crimson, the whole place is crawling. I can shout out warnings, or you can just cut to the chase and dump ammo in every direction at once.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson, the whole place is crawling. I can shout out warnings, or you can just cut to the chase and dump ammo in every direction at once.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_covenant_incoming_00100' );
	e9m3_narrative_is_on = FALSE;

end


script static void vo_e9m3_cant_fit()
dprint("Play_mus_pve_e09m3_cant_fit");
music_set_state('Play_mus_pve_e09m3_cant_fit');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : The Scorpions aren't going to fit through there. You'll need to proceed on foot from here.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: The Scorpions aren't going to fit through there. You'll need to proceed on foot from here.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_cant_fit_00100' );
	e9m3_narrative_is_on = FALSE;

end


script static void vo_e9m3_secure_area()
dprint("Play_mus_pve_e09m3_secure_area");
music_set_state('Play_mus_pve_e09m3_secure_area');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Dalton, how big a space do you need cleared to bring Crimson a new ride?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Dalton, how big a space do you need cleared to bring Crimson a new ride?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_secure_area_00100' );
	// Dalton : Passing you a waypoint now. Secure that space and I'm good.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Passing you a waypoint now. Secure that space and I'm good.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_secure_area_00101' );
	// Miller : Get to it, Spartans. Give Dalton's people room to work.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Get to it, Spartans. Give Dalton's people room to work.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_secure_area_00102' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_area_secured()
dprint("Play_mus_pve_e09m3_area_secured");
music_set_state('Play_mus_pve_e09m3_area_secured');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : All clear, Dalton.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: All clear, Dalton.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_area_secured_00100' );
	// Dalton : So I see. Scorpions en route.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: So I see. Scorpions en route.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_area_secured_00101' );
	e9m3_narrative_is_on = FALSE;

end


script static void vo_e9m3_into_caves()
dprint("Play_mus_pve_e09m3_into_caves");
music_set_state('Play_mus_pve_e09m3_into_caves');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Into the caves, Crimson. Let's root out anybody hiding inside.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Into the caves, Crimson. Let's root out anybody hiding inside.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_into_caves_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_secure_plateau()
dprint("Play_mus_pve_e09m3_secure_plateau");
music_set_state('Play_mus_pve_e09m3_secure_plateau');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Crimson, secure the area while I get you an exact location on the next terminal you're hunting.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Crimson, secure the area while I get you an exact location on the next terminal you're hunting.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_plateau_00100' );
	
	e9m3_narrative_is_on = FALSE;

end


script static void vo_e9m3_battle_chatter_wraiths()
dprint("Play_mus_pve_e09m3_battle_chatter");
music_set_state('Play_mus_pve_e09m3_battle_chatter');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : You've got Wraiths on the ground, Crimson!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: You've got Wraiths on the ground, Crimson!", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_battle_chatter_00100' );
	// Miller : Take out the Wraiths first! They're your biggest problem right now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Take out the Wraiths first! They're your biggest problem right now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_battle_chatter_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_battle_chatter_knights()
dprint("Play_mus_pve_e09m3_battle_chatter");
music_set_state('Play_mus_pve_e09m3_battle_chatter');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Promethean Knights on the field. We've seen them tear through Scorpion armor before, so be careful!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Promethean Knights on the field. We've seen them tear through Scorpion armor before, so be careful!", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_battle_chatter_00102' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_battle_chatter_phantoms()
dprint("Play_mus_pve_e09m3_battle_chatter");
music_set_state('Play_mus_pve_e09m3_battle_chatter');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Crimson, take those Phantoms out of the sky with the Scorpion's cannon.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson, take those Phantoms out of the sky with the Scorpion's cannon.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_battle_chatter_00103' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_almost_there()
dprint("Play_mus_pve_e09m3_almost_there");
music_set_state('Play_mus_pve_e09m3_almost_there');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : You're doing it, Crimson. You've almost got it.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: You're doing it, Crimson. You've almost got it.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_almost_there_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_few_more()
dprint("Play_mus_pve_e09m3_few_more");
music_set_state('Play_mus_pve_e09m3_few_more');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Just a few stragglers. Finish 'em off!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Just a few stragglers. Finish 'em off!", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_few_more_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_all_clear()
dprint("Play_mus_pve_e09m3_all_clear");
music_set_state('Play_mus_pve_e09m3_all_clear');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : That does it! Perfect!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: That does it! Perfect!", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_all_clear_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_terminal_there()
dprint("Play_mus_pve_e09m3_terminal_there");
music_set_state('Play_mus_pve_e09m3_terminal_there');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
		// Miller : Roland? Can you verify this is the terminal we're looking for?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Roland? Can you verify this is the terminal we're looking for?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_terminal_there_00100' );
		// Roland : Sure is.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 20, "Roland : Sure is.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_terminal_there_00101' );

	e9m3_narrative_is_on = FALSE;

end



script static void vo_e9m3_end_mission()
dprint("Play_mus_pve_e09m3_end_mission");
music_set_state('Play_mus_pve_e09m3_end_mission');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short'));

	// Roland : Got it. Last bounce Halsey made is to the area the Spartans are calling Lockup.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland : Got it. Last bounce Halsey made is to the area the Spartans are calling Lockup.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_activated_00100' );

	// Miller : So we get there and we find her?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: So we get there and we find her?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_activated_00101' );
	
	// Roland : That'd be real neat, yeah.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 0, "Roland : That'd be real neat, yeah.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_activated_00102' );
	
	// Dalton, I'm sending you coordinates where I need Crimson delivered. Crimson... get ready. We're in the home stretch.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Dalton, I'm sending you coordinates where I need Crimson delivered. Crimson... get ready. We're in the home stretch.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_activated_00103' );
	
	
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_blow_tanks()
dprint("Play_mus_pve_e09m3_blow_tanks");
music_set_state('Play_mus_pve_e09m3_blow_tanks');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Crimson, Scorpions aren't cheap. Try not to blow them up?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson, Scorpions aren't cheap. Try not to blow them up?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_blow_tanks_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_hardcare()
dprint("Play_mus_pve_e09m3_hardcore");
music_set_state('Play_mus_pve_e09m3_hardcore');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Be careful with the equipment, Spartans. We don't have an unlimited supply of these things.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Be careful with the equipment, Spartans. We don't have an unlimited supply of these things.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_hardcare_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_another_scorpion()
dprint("Play_mus_pve_e09m3_another_scorpion");
music_set_state('Play_mus_pve_e09m3_another_scorpion');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Dalton, can we get another Scorpion on the ground?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Dalton, can we get another Scorpion on the ground?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_another_scorpion_00100' );
	// Dalton : Indeed. En route now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: Indeed. En route now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_another_scorpion_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_another_scorpion_02()
dprint("Play_mus_pve_e09m3_another_scorpion_02");
music_set_state('Play_mus_pve_e09m3_another_scorpion_02');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Dalton : Miller, I've got another Scorpion on station for Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Miller, I've got another Scorpion on station for Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_new_scorpion_00100' );
	// Miller : Thanks for the delivery, Dalton.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Thanks for the delivery, Dalton.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_new_scorpion_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_air_support()
dprint("Play_mus_pve_e09m3_air_support");
music_set_state('Play_mus_pve_e09m3_air_support');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Dalton : We can offer a bit of air support, Crimson. Try to stay clear of the flak.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: We can offer a bit of air support, Crimson. Try to stay clear of the flak.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_air_support_00100' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_big_tank()
dprint("Play_mus_pve_e09m3_big_tank");
music_set_state('Play_mus_pve_e09m3_big_tank');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : No need to hoof it, Crimson. Dalton?
	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: No need to hoof it, Crimson. Dalton?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_big_tank_00100' );
	// Dalton : Scorpion on it's way.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: Scorpion on it's way.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_big_tank_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_locked_down()
dprint("Play_mus_pve_e09m3_locked_down");
music_set_state('Play_mus_pve_e09m3_locked_down');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller : Area secured. Dalton, you've got a safe drop spot if you need one.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller : Area secured. Dalton, you've got a safe drop spot if you need one.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_locked_down_00100' );
	// Dalton : Acknowledged, Miller.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: Acknowledged, Miller.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_locked_down_00101' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_get_squished()
dprint("Play_mus_pve_e09m3_get_squished");
music_set_state('Play_mus_pve_e09m3_get_squished');

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Dalton : Miller, my people can't give Crimson their new toy if they're going to stand in the way.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Miller, my people can't give Crimson their new toy if they're going to stand in the way.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_get_squished_00100' );
	// Miller : Stop screwing around, Crimson. Move.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Stop screwing around, Crimson. Move.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m3_get_squished_00101' );
	e9m3_narrative_is_on = FALSE;

end


script static void vo_e9m3_activated_01()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Roland: Good to go, Spartans.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Good to go, Spartans.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_activated_00300' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_activated_02()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller: Take out the shield, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Take out the shield, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_activated_00301' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_g_weak_01()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller: The shields should be weak enough to bring down now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: The shields should be weak enough to bring down now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00300' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_g_weak_02()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller: Looks like the shields are weak enough to take down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Looks like the shields are weak enough to take down.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00301' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_g_weak_03()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller: You can bring those shields down now, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: You can bring those shields down now, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00301' );
	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_gunners()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	
	vo_glo15_miller_phantom_01();
	// Miller: Phantom on approach
	sleep(30);
	
	// Roland: Mind a spot of tactical advice, Crimson?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Mind a spot of tactical advice, Crimson?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_gunners_00300' );
	
	// Roland: Shoot the door gunner.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: Shoot the door gunner.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_gunners_00301' );
	
	// Roland: They値l be less likely to, you know, shoot you first.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: They値l be less likely to, you know, shoot you first.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_gunners_00302' );

	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_additional_gunner()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller: Target the turret on the side of the Phantom.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Target the turret on the side of the Phantom.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_gunners_hint_00300' );
	
	// Miller: If you take him out, you値l increase your chance of survival.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Miller: If you take him out, you値l increase your chance of survival.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_gunners_hint_00301' );


	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_additional_shield_controls()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Miller: I値l mark the shield control system for you, Crimson. Roland, can you work your magic?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: I値l mark the shield control system for you, Crimson. Roland, can you work your magic?", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_shield_00300' );
	
	// Roland: You know it.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland: You know it.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_shield_00301' );


	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_additional_shield_controls_activated()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	// Roland : Good to go, Spartans.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, 0, 10, "Roland : Good to go, Spartans.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_activated_00300' );
	
	// Miller : Take out the shield, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller : Take out the shield, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_activated_00301' );


	e9m3_narrative_is_on = FALSE;

end


script static void vo_e9m3_multiple_shields_weak()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	

	// Miller : The shields should be weak enough to bring down now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller : The shields should be weak enough to bring down now.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00300' );

// Miller : Looks like the shields are weak enough to take down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller : Looks like the shields are weak enough to take down.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00301' );

// Miller : You can bring those shields down now, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller : You can bring those shields down now, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00302' );

	e9m3_narrative_is_on = FALSE;

end

script static void vo_e9m3_multiple_shields_weak_2()

	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = TRUE;
	
// Miller : You can bring those shields down now, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller : You can bring those shields down now, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_09_mission_03\e09m03_g_weak_00302' );

	e9m3_narrative_is_on = FALSE;

end
