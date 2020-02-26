//=============================================================================================================================
//============================================ E9M2 MEZZANINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e9m2_narrative_is_on = FALSE;
global boolean b_third_is_ready = FALSE;

// ============================================	PUP SCRIPT	========================================================

script command_script cs_intro_grunt_1_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.grunt_1);
	cs_move_towards (oct_move_grunt_1);
	
	sleep (450);
	
end

script command_script cs_intro_grunt_2_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.grunt_2);
	cs_move_towards (oct_move_grunt_2);
	
	sleep (450);
	
end

script command_script cs_intro_grunt_3_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.grunt_3);
	cs_move_towards (oct_move_grunt_3);
	
	sleep (450);
	
end

script command_script cs_intro_grunt_4_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.grunt_4);
	cs_move_towards (oct_move_grunt_4);
	
	sleep (450);
	
end

script command_script cs_intro_grunt_5_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.grunt_5);
	cs_move_towards (oct_move_grunt_5);
	
	sleep (450);
	
end

script command_script cs_intro_jackal_1_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.jackal_1);
	cs_move_towards (oct_move_jackal_1);
	
	sleep (450);
	
end

// ============================================	VO SCRIPT	========================================================


script static void vo_e9m2_narr_in()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_narr_in");
	music_set_state('Play_mus_pve_e09m2_narr_in');


		// Miller : Roland, Crimson's at the coordinates you provided. Where do we start?
dprint ("Miller: Roland, Crimson's at the coordinates you provided. Where do we start?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_vortex_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_vortex_00100'));
sleep(10);

// Roland : Find me a comm terminal and I can tell you.
dprint ("Roland: Find me a comm terminal and I can tell you.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_vortex_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_vortex_00101'));
sleep(10);

// Miller : Hear that, Crimson? Don't let anything stand in your way.
dprint ("Miller: Hear that, Crimson? Don't let anything stand in your way.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_vortex_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_vortex_00102'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_clear_area()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_clear_area");
	music_set_state('Play_mus_pve_e09m2_clear_area');

		// Miller : Crimson, clear the area of Covies. Roland, help me get eyes on the comms terminals we're after.
dprint ("Miller: Crimson, clear the area of Covies. Roland, help me get eyes on the comms terminals we're after.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_clear_area_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_clear_area_00100'));


	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_while_fighting()
dprint("deprecated");
//	b_e9m2_narrative_is_on = TRUE;
///*	dprint("Play_mus_pve_e09m2_while_fighting");
//	music_set_state('Play_mus_pve_e09m2_while_fighting');
//
//	// Miller : Dalton, you online?
//	dprint ("Miller: Dalton, you online?");
//	start_radio_transmission("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00100', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00100'));
//	sleep(10);*/
//
////	// Miller : Dalton, you online?
////	dprint ("Miller: Dalton, you online?");
////	cui_hud_show_radio_transmission_hud("miller_transmission_name");
////	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00100', NONE, 1);
////	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00100'));
////	sleep(10);
//
//	// Dalton : As always. What's up?
//	dprint ("Dalton: As always. What's up?");
//	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00101', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00101'));
//	sleep(10);
//	
//	// Miller : You ferry any ONI operatives on Requiem?
//	dprint ("Miller: You ferry any ONI operatives on Requiem?");
//	cui_hud_show_radio_transmission_hud("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00102', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00102'));
//	sleep(10);
//
//	// Dalton : Not that they've told me. Why? What'd you hear?
//	dprint ("Dalton: Not that they've told me. Why? What'd you hear?");
//	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00103', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00103'));
//	sleep(10);
//
//	// Miller : Couple Marines at [Courtyard] Base claim to have seen some.
//	dprint ("Miller: Couple Marines at [Courtyard] Base claim to have seen some.");
//	cui_hud_show_radio_transmission_hud("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00104', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00104'));
//	sleep(10);
//
//	// Dalton : You ask Roland?
//	dprint ("Dalton: You ask Roland?");
//	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00105', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00105'));
//	sleep(10);
//
//	// Roland : No ONI ops have been cleared through Infinity Command.
//	dprint ("Roland: No ONI ops have been cleared through Infinity Command.");
//	cui_hud_show_radio_transmission_hud("roland_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00106', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00106'));
//	sleep(10);
//
//	// Roland : Sorry. Couldn't help but overhear -- because I was eavesdropping, mostly.
//	dprint ("Roland: Sorry. Couldn't help but overhear -- because I was eavesdropping, mostly.");
//	cui_hud_show_radio_transmission_hud("roland_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00107', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_while_fighting_00107'));
//
//	b_e9m2_narrative_is_on = FALSE;
//	end_radio_transmission();
end


script static void vo_e9m2_covie_data()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_covie_data");
	music_set_state('Play_mus_pve_e09m2_covie_data');
	
	// Miller : Roland, how's the search going?
dprint ("Miller: Roland, how's the search going?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_covie_data_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_covie_data_00100'));
sleep(10);

// Roland : There's a few uplinks in the area. I dunno. Try that one
dprint ("Roland: There's a few uplinks in the area. I dunno. Try that one");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_covie_data_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_covie_data_00101'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_save_it()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_save_it");
	music_set_state('Play_mus_pve_e09m2_save_it');

// Miller : Crimson, if you could be a dear and power on that comm terminal, I could get some work done.
dprint ("Miller: Crimson, if you could be a dear and power on that comm terminal, I could get some work done.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_save_it_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_save_it_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	device_set_power (dc_e9_m2_map1, 1);
	b_92_switch_first_terminal = TRUE;
	f_new_objective (ch_9_2_2);
	//cinematic_set_title (ch_9_2_2);
	sleep_s(1);
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
end


script static void vo_e9m2_blow_up()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_blow_up");
	music_set_state('Play_mus_pve_e09m2_blow_up');

	// Miller : Crimson -- take out the archive.
	//dprint ("Miller: Crimson -- take out the archive.");
	//start_radio_transmission("miller_transmission_name");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_blow_up_00100', NONE, 1);
	//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_blow_up_00100'));
	//sleep(10);
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	device_set_power (dc_e9_m2_map1, 1);
	b_92_switch_first_terminal = TRUE;
	f_new_objective (ch_9_2_2);
	//cinematic_set_title (ch_9_2_2);
	sleep_s(1);
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------

	// Miller : If ONI wanted to hide it from us, it's a safe bet we don't want Covies getting hold of it either.
	//dprint ("Miller: If ONI wanted to hide it from us, it's a safe bet we don't want Covies getting hold of it either.");
	//cui_hud_show_radio_transmission_hud("miller_transmission_name");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_blow_up_00101', NONE, 1);
	//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_blow_up_00101'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_destroyed()
dprint("deprecated");
/*	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_ndestroyed");
	music_set_state('Play_mus_pve_e09m2_destroyed');

	// Miller : Nice work, Crimson. Enemy denied.
	dprint ("Miller: Nice work, Crimson. Enemy denied.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_destroyed_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_destroyed_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();*/
end

script static void vo_e9m2_another_archive_new()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_another_archive");
	music_set_state('Play_mus_pve_e09m2_another_archive');
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short', cr_e9_m2_map1, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short'));
// Roland : Okay, Halsey's comm traffic was definitely routed through this area.
dprint ("Roland: Okay, Halsey's comm traffic was definitely routed through this area.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_another_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_another_00100'));
sleep(10);

// Miller : Can you tell where it bounced from here?
dprint ("Miller: Can you tell where it bounced from here?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_another_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_another_00101'));
sleep(10);

// Roland : Yep. Right over there. She bounced her signal around this area a few times
dprint ("Roland: Yep. Right over there. She bounced her signal around this area a few times");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_another_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_another_00102'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_another_archive()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_another_archive");
	music_set_state('Play_mus_pve_e09m2_another_archive');
/*
	// Roland : Crimson, there's another archive down there that's also off the Infinity network.
	dprint ("Roland: Crimson, there's another archive down there that's also off the Infinity network.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_another_archive_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_another_archive_00100'));
	sleep(10);

	// Miller : Mark it, Roland.
	dprint ("Miller: Mark it, Roland.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_another_archive_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_another_archive_00101'));
	sleep(10);*/
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	sleep_s(1);
	object_create_anew(sc_e9_m2_lz2);
	navpoint_track_object_named(sc_e9_m2_lz2, "navpoint_goto");
	sleep_s(1);
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------

	// Miller : Crimson, let's make sure that's secure as well.
/*	dprint ("Miller: Crimson, let's make sure that's secure as well.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_another_archive_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_another_archive_00102'));*/

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_blow_up_another()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_blow_up_another");
	music_set_state('Play_mus_pve_e09m2_blow_up_another');


	// Roland : If you would do the honors and open a channel, Crimson?
dprint ("Roland: If you would do the honors and open a channel, Crimson?");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_blow_it_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_blow_it_00100'));
	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_two_down()
	b_e9m2_narrative_is_on = TRUE;	
	dprint("Play_mus_pve_e09m2_two_down");
	music_set_state('Play_mus_pve_e09m2_two_down');
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short', cr_e9_m2_map2, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short'));
	
	// Miller : Well?
dprint ("Miller: Well?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00100'));
sleep(10);

// Roland : Halsey's a tricky old lady, I'll give her that.
dprint ("Roland: Halsey's a tricky old lady, I'll give her that.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00101'));
sleep(10);

// Roland : She bounced her call through a dozen comm terminals in the area, but the one she keeps coming back to is there.
dprint ("Roland: She bounced her call through a dozen comm terminals in the area, but the one she keeps coming back to is there.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00102'));
sleep(10);

// Roland : If I can get direct access, maybe I can untie the knot.
dprint ("Roland: If I can get direct access, maybe I can untie the knot.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00103'));
sleep(10);

// Miller : Go to it, Crimson.
dprint ("Miller: Go to it, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_two_down_00104'));

	b_third_is_ready = TRUE;
	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_third_one()
	dprint("deprecated");
	/*b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_third_one");
	music_set_state('Play_mus_pve_e09m2_third_one');

	// Roland : Hey -- there's a third archive that's off the network. But…
	dprint ("Roland: Hey -- there's a third archive that's off the network. But…");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00100'));
	sleep(10);

	// Miller : Roland?
	dprint ("Miller: Roland?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00101'));
	sleep(10);

	// Roland : Well, it was just on the network. I only saw it because it blinked off.
	dprint ("Roland: Well, it was just on the network. I only saw it because it blinked off.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00102'));
	sleep(10);

	// Miller : Go get a look, Crimson.
	dprint ("Miller: Go get a look, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00103'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();*/
end


script static void vo_e9m2_third_archive()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_third_archive");
	music_set_state('Play_mus_pve_e09m2_third_archive');



// Roland : Okay, Crimson! One more time!
dprint ("Roland: Okay, Crimson! One more time!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_third_archive_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_third_archive_00100'));
sleep(10);

// Roland : Very difficult, so pay close attention. It requires pressing a button.
dprint ("Roland: Very difficult, so pay close attention. It requires pressing a button.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_third_archive_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_third_archive_00101'));
sleep(10);

// Miller : Roland…
dprint ("Miller: Roland…");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_third_archive_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_third_archive_00102'));
	
	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_hold_position()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_hold_position");
	music_set_state('Play_mus_pve_e09m2_hold_position');

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short'));

	// Miller : Roland? What's taking so long?
dprint ("Miller: Roland? What's taking so long?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00100'));
sleep(10);

// Roland : Three layers of 64-zettabyte encryption.
dprint ("Roland: Three layers of 64-zettabyte encryption.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00101'));
sleep(10);

// Roland : Maybe you'd like to  grab a pen and paper to help with the math instead of asking why I'm taking so long?
dprint ("Roland: Maybe you'd like to  grab a pen and paper to help with the math instead of asking why I'm taking so long?");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00102'));
sleep(10);

// Miller : Just try to hurry.
dprint ("Miller: Just try to hurry.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_hold_position_00103'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_done_yet()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_done_yet");
	music_set_state('Play_mus_pve_e09m2_done_yet');

	// Miller : I think we've got their attention.
dprint ("Miller: I think we've got their attention.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_done_yet_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_done_yet_00100'));
sleep(10);

// Miller : Promethean activity is increasing.
dprint ("Miller: Promethean activity is increasing.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_done_yet_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_done_yet_00101'));
sleep(10);

// Miller : Hang in there, Crimson.
dprint ("Miller: Hang in there, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_done_yet_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_done_yet_00102'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_all_clear()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_all_clear");
	music_set_state('Play_mus_pve_e09m2_all_clear');

// Roland : Done!
dprint ("Roland: Done!");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_all_clear_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_all_clear_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end


script static void vo_e9m2_archive_destroyed()
dprint("deprecated");
/*	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_archive_destroyed");
	music_set_state('Play_mus_pve_e09m2_archive_destroyed');

	// Miller : Archive's offline. Nice work, Crimson.
	dprint ("Miller: Archive's offline. Nice work, Crimson.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_archive_destroyed_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_archive_destroyed_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();*/
end


script static void vo_e9m2_so()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_so");
	music_set_state('Play_mus_pve_e09m2_so');

	// Miller : What did you find, Roland?
dprint ("Miller: What did you find, Roland?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_so_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_so_00100'));
sleep(10);

// Roland : Halsey's comm signal bounced from here to the vacation destination known as Lockup.
dprint ("Roland: Halsey's comm signal bounced from here to the vacation destination known as Lockup.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_so_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_so_00101'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end

script static void vo_e9m2_help_me()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_so");
	music_set_state('Play_mus_pve_e09m2_so');

// Miller : Crimson, the Promethean count is increasing.
dprint ("Miller: Crimson, the Promethean count is increasing.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_bad_guys_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_bad_guys_00100'));
sleep(10);

// Miller : They're popping up faster than you're putting them down.
dprint ("Miller: They're popping up faster than you're putting them down.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_bad_guys_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_bad_guys_00101'));
sleep(10);

// Miller : Dalton! Crimson needs the ground cleared and a ride home.
dprint ("Miller: Dalton! Crimson needs the ground cleared and a ride home.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_bad_guys_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_bad_guys_00102'));
sleep(10);

// Dalton : Can do.
dprint ("Dalton: Can do.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\glo_dalton_confirm_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\glo_dalton_confirm_01'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end

script static void vo_e9m2_get_out()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_so");
	music_set_state('Play_mus_pve_e09m2_so');

// Roland : Crimson, if you move to this location, you should stay reasonably safe as long as Dalton's people don't drop bombs on you.
dprint ("Roland: Crimson, if you move to this location, you should stay reasonably safe as long as Dalton's people don't drop bombs on you.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_get_out_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_get_out_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end

script static void vo_e9m2_incoming()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_so");
	music_set_state('Play_mus_pve_e09m2_so');

// Miller : Incoming!
dprint ("Miller: Incoming!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_boom_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_boom_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end

script static void vo_e9m2_end()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_so");
	music_set_state('Play_mus_pve_e09m2_so');


// Miller : You're clear, Crimson! Run to the LZ!
dprint ("Miller: You're clear, Crimson! Run to the LZ!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_end_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_end_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end

script static void vo_e9m2_lz()
	b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_so");
	music_set_state('Play_mus_pve_e09m2_so');


// Miller : Everybody onboard. We're headed to Lockup.
dprint ("Miller: Everybody onboard. We're headed to Lockup.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_lz_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_v2_lz_00100'));

	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();
end

script static void vo_e9m2_archive_glassman()
dprint("deprecated");
	/*b_e9m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e09m2_archive_glassman");
	music_set_state('Play_mus_pve_e09m2_archive_glassman');

	// Dr. Glassman : Hello?
	dprint ("Dr. Glassman: Hello?");
	start_radio_transmission("incoming_transmission");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00100'));
	sleep(10);

	// Miller : Hello? Who is this?
	dprint ("Miller: Hello? Who is this?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00101'));
	sleep(10);

	// Dr. Glassman : It's Doctor Glassman. I have a job that Captain Lasky suggested Crimson could help with.
	dprint ("Dr. Glassman: It's Doctor Glassman. I have a job that Captain Lasky suggested Crimson could help with.");
	cui_hud_show_radio_transmission_hud("incoming_transmission");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00102'));
	sleep(10);

	// Miller : Did he now?
	dprint ("Miller: Did he now?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00103'));
	sleep(10);

	// Miller : Crimson, stand by while I see what we can do to help Doctor Glassman.
	dprint ("Miller: Crimson, stand by while I see what we can do to help Doctor Glassman.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	hud_play_pip_from_tag( "levels\dlc\shared\binks\ep9_m2_2_60" );
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_glassman_00104'));
	
	b_e9m2_narrative_is_on = FALSE;
	end_radio_transmission();*/
end

// ============================================	NEW SCRIPT	========================================================




