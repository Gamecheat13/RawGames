// =============================================================================================================================
//============================================ E8M1 HILLSIDE NARRATIVE SCRIPT ================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e8m1_narrative_is_on = FALSE;


// ============================================	PUP SCRIPT	========================================================



//============================================	VO SCRIPT	========================================================


script static void vo_e8m1_secure_area()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_secure_area");
	music_set_state('Play_mus_pve_e08m1_secure_area');
	
	e8m1_narrative_is_on = TRUE;
	// Miller : Spartans don't leave unfinished business. So it's back to [HILLSIDE] to [7-1 REFERENCE].
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Spartans don't leave unfinished business.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_secure_area_00100' );
	// Miller : So it's back to [HILLSIDE] to [7-1 REFERENCE].
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: So it's back to Apex.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_secure_area_00101' );
	// Miller : Once the area's clear, Marine Squad Lancer's scheduled to babysit.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Once the area's clear,  Fireteam Lancer's scheduled to babysit.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_secure_area_00102' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_portal_problems()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_portal_problems");
	music_set_state('Play_mus_pve_e08m1_portal_problems');

	e8m1_narrative_is_on = TRUE;
	// Miller : Looks like the Covies were expecting us to come back. They've got portals, set up for bringing more troops in. Let's take them down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Looks like the Covies knew we were coming. Let's take them down.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_portal_problems_00100' );
	e8m1_narrative_is_on = FALSE;
	
end
	
	//after seeing ghosts
script static void vo_e8m1_ghost_resistance()

	dprint("Play_mus_pve_e08m1_ghost_resistance");
	music_set_state('Play_mus_pve_e08m1_ghost_resistance');
	
	e8m1_narrative_is_on = TRUE;
	// Miller : Ghosts getting in the way. Take them out!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Ghosts getting in the way. Take them out!", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_ghost_resistance_00100' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_defeat_camp()


	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_defeat_camp");
	music_set_state('Play_mus_pve_e08m1_defeat_camp');

	e8m1_narrative_is_on = TRUE;
	// Palmer : Miller, I'm back. Status?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: Miller, I'm back. Status?", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_defeat_camp_00100' );
	// Miller : Crimson's on the march, Commander. Just about to clear out a Covenant camp.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson's on the march, Commander. Just about to clear out a Covenant camp.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_defeat_camp_00101' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_blow_cave()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_blow_cave");
	music_set_state('Play_mus_pve_e08m1_blow_cave');

	e8m1_narrative_is_on = TRUE;
	// Palmer : Miller, did you just lead Crimson to a dead end?
//	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: Miller, did you just lead Crimson to a dead end?", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_blow_cave_00100' );
	// Miller : Hold on… I’ve located a maintenance panel for the shields. If Crimson can overload the fusion coils, the whole thing will go down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Hold on… I’ve located a maintenance panel for the shields. If Crimson can overload the fusion coils, the whole thing will go down.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_blow_barrier_00101' );
	// Palmer : Crimson, do like the man says.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: Crimson, do like the man says.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_blow_barrier_00102' );
	// Miller : Marking the panel!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Marking the panel!", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_blow_barrier_00103' );
	e8m1_narrative_is_on = FALSE;

end

script static void vo_e8m1_run_away()
	sleep_until (e8m1_narrative_is_on == false, 1);


	e8m1_narrative_is_on = TRUE;
	// Miller : Heat signature increasing. Move, Crimson! It’s gonna blow!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Heat signature increasing. Move, Crimson! It’s gonna blow!", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_run_away_00100' );
	e8m1_narrative_is_on = FALSE;

end

script static void vo_e8m1_shield_down()
	sleep_until (e8m1_narrative_is_on == false, 1);


	e8m1_narrative_is_on = TRUE;
	// Miller : That did it! Shield down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: That did it! Shield down.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_shield_down_00100' );
	e8m1_narrative_is_on = FALSE;

end


//about to blow the barrier
script static void vo_e8m1_door_alternative()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_door_alternative");
	music_set_state('Play_mus_pve_e08m1_door_alternative');

	e8m1_narrative_is_on = TRUE;
	// Miller : Crimson, what you're looking for is right through there.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson, what you're looking for is right through there.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_door_alternative_00100' );
	e8m1_narrative_is_on = FALSE;

end

//after blowing the barrier
script static void vo_e8m1_go_through()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_go_through");
	music_set_state('Play_mus_pve_e08m1_go_through');

	e8m1_narrative_is_on = TRUE;
	// Miller : The first of the portals is just through this passage.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: The first of the portals is just through this passage.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_go_through_00100' );
	// Palmer : Eyes sharp, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Eyes sharp, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_go_through_00101' );
	e8m1_narrative_is_on = FALSE;

end

//after seeing the portal
script static void vo_e8m1_turn_off_first()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_turn_off_first");
	music_set_state('Play_mus_pve_e08m1_turn_off_first');

	e8m1_narrative_is_on = TRUE;
	// Miller : There's the first portal.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: There's the first portal.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_turn_off_first_00100' );
	// Palmer : Shut it down!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Shut it down!", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_turn_off_first_00101' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_hop_in()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_hop_in");
	music_set_state('Play_mus_pve_e08m1_hop_in');

	e8m1_narrative_is_on = TRUE;
	// Palmer : Stop screwing around. 
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Stop screwing around.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_hop_in_00100' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_comes_through()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_comes_through");
	music_set_state('Play_mus_pve_e08m1_comes_through');

	e8m1_narrative_is_on = TRUE;
	// Miller : Take out the stragglers.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Take out the stragglers.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_comes_through_00100' );
	e8m1_narrative_is_on = FALSE;

end

//after disabling the first portal
script static void vo_e8m1_other_portal()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_other_portal");
	music_set_state('Play_mus_pve_e08m1_other_portal');

	e8m1_narrative_is_on = TRUE;
	// Miller : The second and third portals are up ahead.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: The second and third portals are up ahead.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_other_portal_00100' );
	// Palmer : Let's get to it.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Let's get to it.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_other_portal_00101' );
	e8m1_narrative_is_on = FALSE;

end

//seeing one of the covenant encampments
script static void vo_e8m1_more_encampments()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_more_encampments");
	music_set_state('Play_mus_pve_e08m1_more_encampments');

	e8m1_narrative_is_on = TRUE;
	// Miller : Covenant are pretty well dug in. You'll have to root them out, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Covenant are pretty well dug in. You'll have to root them out, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_more_encampments_00100' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_more_ghosts()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_more_ghosts");
	music_set_state('Play_mus_pve_e08m1_more_ghosts');

	e8m1_narrative_is_on = TRUE;
	// Miller : More Ghost patrols trying to make trouble.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: More Ghost patrols trying to make trouble.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_more_ghosts_00100' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_second_portal()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_second_ortal");
	music_set_state('Play_mus_pve_e08m1_second_portal');

	e8m1_narrative_is_on = TRUE;
	// Miller : Crimson, be advised there's a shade turret near the next portal.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Crimson, be advised there's a shade turret near the next portal.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_second_portal_00100' );
	e8m1_narrative_is_on = FALSE;

end

//after second portal is down
script static void vo_e8m1_second_portal_shut_down()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_second_portal_shut_down");
	music_set_state('Play_mus_pve_e08m1_second_portal_shut_down');

	e8m1_narrative_is_on = TRUE;
	// Miller : Second portal’s down.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Second portal’s down.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_second_portal_00101a' );
	// Palmer : Nicely done.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: Nicely done.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_second_portal_00101' );
	// Miller : Marking the next terminal's location now.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: Marking the next terminal's location now.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_second_portal_00102' );
	e8m1_narrative_is_on = FALSE;

end

//snipers
script static void vo_e8m1_sniper_warning()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_sniper_warning");
	music_set_state('Play_mus_pve_e08m1_sniper_warning');

	e8m1_narrative_is_on = TRUE;
	// Miller : Snipers guarding the portal.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Snipers guarding the portal.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sniper_warning_00100' );
	// Palmer : Take your time, Crimson. Don't get your heads blown off.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Take your time, Crimson. Don't get your heads blown off.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sniper_warning_00101' );
	e8m1_narrative_is_on = FALSE;

end

//after third portal
script static void vo_e8m1_third_portal()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_third_portal");
	music_set_state('Play_mus_pve_e08m1_third_portal');

	e8m1_narrative_is_on = TRUE;
	// Miller : That's the last of the portals.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: That's the last of the portals.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_third_portal_00100' );
	// Palmer : Then let's clean up these Covenant and--
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Then let's clean up these Covenant and--", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_third_portal_00101' );
	// Dalton : Dalton to Commander Palmer. You've got a wraith inbound on Crimson's position.
	hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G09_60" );
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 10, "Dalton: Dalton to Commander Palmer. You've got a wraith inbound on Crimson's position.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_third_portal_00102' );
	// Palmer : I see it. Thanks, Dalton. Crimson, ready up.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: I see it. Thanks, Dalton. Crimson, ready up.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_third_portal_00103' );
	e8m1_narrative_is_on = FALSE;

end

//after the wraith
script static void vo_e8m1_mark_forerunner()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_mark_forerunner");
	music_set_state('Play_mus_pve_e08m1_mark_forerunner');

	e8m1_narrative_is_on = TRUE;
	// Palmer : Miller, we set for the babysitters?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: Miller, we set for the babysitters?", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_mark_foreunner_00100' );
	// Miller : Yes. Fireteam Lancer's ready to move in as soon as we give them the sign.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Yes. Fireteam Lancer's ready to move in as soon as we give them the sign.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_mark_foreunner_00101' );
	// Palmer : Crimson, mark a landing area for Lancer.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Crimson, mark a landing area for Lancer.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_mark_foreunner_00102' );
	e8m1_narrative_is_on = FALSE;

end

//clean up stragglers
script static void vo_e8m1_clean_up()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_clean_up");
	music_set_state('Play_mus_pve_e08m1_clean_up');

	e8m1_narrative_is_on = TRUE;
	// Miller : Got a few stragglers left to clean up.
	//spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Got a few stragglers left to clean up.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_clean_up_00100' );
	// Palmer : Take 'em out and head to the LZ, Crimson.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Take 'em out and head to the LZ, Crimson.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_clean_up_00101' );
	e8m1_narrative_is_on = FALSE;

end

script static void vo_e8m1_clean_up_02()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_clean_up");
	music_set_state('Play_mus_pve_e08m1_clean_up');

	e8m1_narrative_is_on = TRUE;
	// Palmer : Don't leave any behind, Spartans.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 0, "Palmer: Don't leave any behind, Spartans.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_clean_up_00102' );
	e8m1_narrative_is_on = FALSE;

end

//end of gameplay
script static void vo_e8m1_to_lz()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_to_lz");
	music_set_state('Play_mus_pve_e08m1_to_lz');

	e8m1_narrative_is_on = TRUE;
	// Miller : That's the last one. Time to head home. Dalton, Crimson's ride ready?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: That's the last one. Time to head home. Dalton, Crimson's ride ready?", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_to_lz_00100' );
	// Dalton : On station and ready to fly.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, 0, 0, "Dalton: On station and ready to fly.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_to_lz_00101' );
	e8m1_narrative_is_on = FALSE;
	
end

//pip maybe?
script static void vo_e8m1_off_back()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_off_back");
	music_set_state('Play_mus_pve_e08m1_off_back');

	e8m1_narrative_is_on = TRUE;
	// Demarco : Majestic to Infinity! We've got some over-excited Covies shelling our position. Any chance we could get them off our backs?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, 0, 0, "Demarco: Majestic to Infinity! We've got some over-excited Covies shelling our position. Any chance we could get them off our backs?", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_off_back_00100' );
	e8m1_narrative_is_on = FALSE;

end


script static void vo_e8m1_help_majestic()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_help_majestic");
	music_set_state('Play_mus_pve_e08m1_help_majestic');

	e8m1_narrative_is_on = TRUE;
	
	// Palmer : That can be arranged, Majestic. Ready for more work, Crimson? Let's go give majestic a hand.
	dprint ("Palmer: That can be arranged, Majestic. Ready for more work, Crimson? Let's go give majestic a hand.");
	spops_radio_transmission_start_palmer();
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep8_m1_1_60);
	thread (pip_e8m1_helpmajestic_subtitles());
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_help_majestic_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_help_majestic_00100'));
	
	spops_radio_transmission_end_all();
	e8m1_narrative_is_on = FALSE;
	
end


script static void pip_e8m1_helpmajestic_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_help_majestic_00100');
end


script static void vo_e8m1_sos()
	sleep_until (e8m1_narrative_is_on == false, 1);
	dprint("Play_mus_pve_e08m1_sos");
	music_set_state('Play_mus_pve_e08m1_sos');

	e8m1_narrative_is_on = TRUE;
	// Miller : Weird... Commander, did you see that?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Weird... Commander, did you see that?", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sos_00100' );
	// Palmer : I missed it. Educate me.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: I missed it. Educate me.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sos_00101' );
	// Miller : There was a blip on a low end Covie frequency – something turning on and off in a pattern... then gone.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: There was a blip on a low end Covie frequency – something turning on and off in a pattern... then gone.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sos_00102' );
	// Palmer : Pattern?
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: Pattern?", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sos_00103' );
	// Miller : Let me check... Morse code. An S-O-S.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "Miller: Let me check... Morse code. An S-O-S.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sos_00104' );
	// Palmer : Covies don’t use Morse code, Miller.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, 0, 10, "Palmer: Covies don’t use Morse code, Miller.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sos_00105' );
	// Miller: I’ll keep an eye out to see if it happens again.
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 0, "Miller: I’ll keep an eye out to see if it happens again.", 'sound\dialog\storm_multiplayer\pve\ep_08_mission_01\e08m1_sos_00106' );
	e8m1_narrative_is_on = FALSE;

end



// ============================================	MISC SCRIPT	========================================================