//=============================================================================================================================
//============================================ E10M2 CAVERNS NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e10m2_narrative_is_on = FALSE;
global boolean e10m2_spartan_start_shooting = FALSE;

// ============================================	PUP SCRIPT	========================================================

script command_script cs_intro_covenant_01_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.covenant_01);
	cs_move_towards (oct_move_covenant_01);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_02_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.covenant_02);
	cs_move_towards (oct_move_covenant_02);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_03_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.covenant_03);
	cs_move_towards (oct_move_covenant_03);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_04_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.covenant_04);
	cs_move_towards (oct_move_covenant_04);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_05_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.covenant_05);
	cs_move_towards (oct_move_covenant_05);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_06_move()
	// grunt one shoots target
	
	cs_shoot_point (true, ps_intro_shoot.covenant_06);
	cs_move_towards (oct_move_covenant_06);
	
	sleep (768);
	
end


script command_script cs_intro_covenant_07_move()
	// grunt one shoots target
	
	//cs_shoot_point (true, ps_intro_shoot.covenant_07);
	cs_move_towards (oct_move_covenant_07);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_08_move()
	// grunt one shoots target
	
	//cs_shoot_point (true, ps_intro_shoot.covenant_08);
	cs_move_towards (oct_move_covenant_08);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_09_move()
	// grunt one shoots target
	
	//cs_shoot_point (true, ps_intro_shoot.covenant_09);
	cs_move_towards (oct_move_covenant_09);
	
	sleep (768);
	
end

script command_script cs_intro_grunt_10_move()
	// grunt one shoots target
	
	//cs_shoot_point (true, ps_intro_shoot.covenant_10);
	cs_move_towards (oct_move_covenant_10);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_11_move()
	// grunt one shoots target
	
	//cs_shoot_point (true, ps_intro_shoot.covenant_11);
	cs_move_towards (oct_move_covenant_11);
	
	sleep (768);
	
end

script command_script cs_intro_covenant_12_move()
	// grunt one shoots target
	
	//cs_shoot_point (true, ps_intro_shoot.covenant_12);
	cs_move_towards (oct_move_covenant_12);
	
	sleep (768);
	
end

// ============================================	VO SCRIPT	========================================================


script static void vo_e10m2_narr_in()
	dprint("Play_mus_pve_e10m2_narr_in");
	music_set_state('Play_mus_pve_e10m2_narr_in');
	e10m2_narrative_is_on = TRUE;

	// Murphy : Miller, there's no way we're landing on that side! Too hot all around!
	dprint ("Murphy: Miller, there's no way we're landing on that side! Too hot all around!");
	start_radio_transmission("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_narr_in_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_narr_in_00100'));
	sleep(10);

	// Miller : Understood, Murphy. Fortunately there is a path to Apex through the caves here.
	dprint ("Miller: Understood, Murphy. Fortunately there is a path to Apex through the caves here.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_narr_in_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_narr_in_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_door_fight()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Marking the entrance for you now. Doesn't look like it will be a nature walk, but it's nothing you can't handle.
	dprint ("Miller: Marking the entrance for you now.");
	start_radio_transmission("miller_transmission_name");
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m2_1_60);
	thread (pip_e10m2_doorfight_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_door_fight_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void pip_e10m2_doorfight_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_door_fight_00100');
end


script static void vo_e10m2_near_door()
	e10m2_narrative_is_on = TRUE;
	hud_play_pip_from_tag (levels\dlc\shared\binks\SP_G07_60);
	// Miller : Looks like the door's sealed up tight, but I've pinged the controls for you.
	dprint ("Miller: Looks like the door's sealed up tight, but I've pinged the controls for you.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_near_door_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_near_door_00100'));
	e10m2_spartan_start_shooting = TRUE;

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_button_fail()
	e10m2_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e10m2_button_fail");
	music_set_state('Play_mus_pve_e10m2_button_fail');
	
	// Miller : Weird. That should work. Give me a second, I'll see what's going on.
	dprint ("Miller: Weird. That should work. Give me a second, I'll see what's going on.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_fail_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_fail_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_badguys()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Roland? You online?
	dprint ("Miller: Roland? You online?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_badguys_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_badguys_00100'));
	sleep(10);

	// Roland : I thought you'd never ask. I can run a hack on the door via Crimson's suit comms if you give me just a second.
	dprint ("Roland: I thought you'd never ask. I can run a hack on the door via Crimson's armor comms if you give me just a second.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_badguys_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_badguys_00101'));
	
	sleep (15);
	hud_play_pip_from_tag (levels\dlc\shared\binks\sp_g02_60);

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end

script static void vo_e10m2_still_firing()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Dalton, is there any way to get Crimson some air support?
	dprint ("Miller: Dalton, is there any way to get Crimson some air support?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00100'));
	sleep(10);

	// Dalton : Depends on what you need.
	dprint ("Dalton: Depends on what you need.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00101'));
	sleep(10);

	// Miller : I’m sending you a list of targets.
	dprint ("Miller: I’m sending you a list of targets.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00102'));
	sleep(10);

	// Dalton : I can make this happen, Miller. Just a moment.
	dprint ("Dalton: I can make this happen, Miller. Just a moment.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_still_firing_00103'));
	
	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end



script static void vo_e10m2_almost_done()
	e10m2_narrative_is_on = TRUE;
						dprint("Play_mus_pve_e10m2_almost_done");
music_set_state('Play_mus_pve_e10m2_almost_done');
	// Miller : Roland? ETA?
	dprint ("Miller: Roland? ETA?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00100'));
	sleep(10);

	// Roland : Just a few... seconds... longer. There ya go, Spartans. Door's unlocked.
	dprint ("Roland: Just a few... seconds... longer.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00101', NONE, 1);
	//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00101'));
	sleep_s(6);  // guesstimate to how long the line will take.

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_all_done()
	e10m2_narrative_is_on = TRUE;

	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	b_end_player_goal = TRUE;
	f_unblip_ai_cui(gr_ff_e10_m2_all);
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	
	// Roland : There ya go, Spartans.
	dprint ("Roland: There ya go, Spartans.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00102'));

	// Roland : Door's unlocked.
	dprint ("Roland: Door's unlocked.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_almost_done_00103'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_enter_cavern()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Hey now -- lotta bad guys in here. Clear the area and I'll find your way through.
	dprint ("Miller: Hey now -- lotta bad guys in here. Clear the area and I'll find your way through.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_enter_cavern_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_enter_cavern_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_back_switch()
	e10m2_narrative_is_on = TRUE;
	

	
// Miller : Crimson, marking the door for you. Head on over.
	dprint ("Miller: Crimson, marking the door for you. Head on over.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_back_switch_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_back_switch_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_door_shut()
	e10m2_narrative_is_on = TRUE;
							dprint("Play_mus_pve_e10m2_door_shut");
music_set_state('Play_mus_pve_e10m2_door_shut');
	// Miller : This way's shut.
	dprint ("Miller: This way's shut.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_door_shut_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_door_shut_00100'));
	sleep(10);

	// Miller : Hang on a second, Crimson. I'll find you an alternate route.
	dprint ("Miller: Hang on a second, Crimson. I'll find you an alternate route.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_door_shut_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_door_shut_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_crimson_fights()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Hrmm, I'm not finding anything...
	dprint ("Miller: Hrmm, I'm not finding anything...");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_crimson_fights_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_crimson_fights_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_crimson_fights_more()
	e10m2_narrative_is_on = TRUE;
	
	// Roland : Covenant still have door controls rigged through this location.
	dprint ("Roland: Covenant still have door controls rigged through this location.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_crimson_fights_more_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_crimson_fights_more_00100'));
	sleep(10);
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------		
	navpoint_track_object_named(e10m2_switch_back_door, "navpoint_activate");
	thread(f_e10_m2_derez_that_switch());
	sleep_s(1);
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	
	// Miller : There you go, Crimson.
	dprint ("Miller: There you go, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_crimson_fights_more_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_crimson_fights_more_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_switch_derez()
	e10m2_narrative_is_on = TRUE;
	
	dprint("Play_mus_pve_e10m2_switch_derez");
	music_set_state('Play_mus_pve_e10m2_switch_derez');
	// Roland : Hey, neat! Appears to be a polymorphic molecular phase storage system.
	dprint ("Roland: Hey, neat! Appears to be a polymorphic molecular phase storage system.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00100'));
	sleep(10);

	// Miller : Which means what?
	dprint ("Miller: Which means what?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00101'));
	sleep(10);

	// Roland : Magic!
	dprint ("Roland: Magic!");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00102'));
	sleep(10);

	// Miller : Roland--
	dprint ("Miller: Roland--");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00103'));
	sleep(10);

	// Roland : Give me a second to figure out their trick.
	dprint ("Roland: Give me a second to figure out their trick.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00104'));
	sleep(10);

	// Miller : Hurry, Roland.
	dprint ("Miller: Hurry, Roland.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00105'));
	sleep(10);
	
	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end

script static void vo_e10m2_roland_question()
dprint("deprecated");
	/*e10m2_narrative_is_on = TRUE;
	
	// Miller : Roland?
	dprint ("Miller: Roland?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\e09m2_third_one_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;*/
end

script static void vo_e10m2_figured_it_out()
	e10m2_narrative_is_on = TRUE;
	
	// Roland : Figured it out.
	dprint ("Roland: Figured it out.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00106', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00106'));
	sleep(10);
	
	// Roland : Crimson needs to find a way to bring power back.
	dprint ("Roland: Crimson needs to find a way to bring power back.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00107', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00107'));
	sleep(10);
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	prepare_to_switch_to_zone_set(e10_m2_dz_2);
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------

//	// Roland : Have a look on the upper ledge.
//	dprint ("Roland: Have a look on the upper ledge.");
//	cui_hud_show_radio_transmission_hud("roland_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00108', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00108'));
//	sleep(10);

	// Roland : Lotta tech running through there, but they're not close enough for me to tell what it is.
	dprint ("Roland: Lotta tech running through there, but they're not close enough for me to tell what it is.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00109', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_derez_00109'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_light_bridge()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Okay. Just need to find a way across this chasm...
	dprint ("Miller: Okay. Just need to sort out a way across this chasm...");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_light_bridge_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_light_bridge_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_switch_bridge()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Almost there, Crimson.
	dprint ("Miller: Almost there, Crimson.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_bridge_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_switch_bridge_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_security_room()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Head on up and let's see if we can get that door open.
	dprint ("Miller: Head on up and let's see if we can get that door open.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_security_room_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_security_room_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_inside_room()
	e10m2_narrative_is_on = TRUE;
									dprint("Play_mus_pve_e10m2_inside_room");
music_set_state('Play_mus_pve_e10m2_inside_room');
	// Miller : Roland, does this stuff make any sense to you?
	dprint ("Miller: Roland, does this stuff make any sense to you?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00100'));
	sleep(10);

	// Roland : Only way to open the door is to cause the circuit holding it shut to overload and break.
	dprint ("Roland: Only way to open the door is to cause the circuit holding it shut to overload and break.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00101'));
	sleep(10);

	// Miller : Hotwire the door?
	dprint ("Miller: Hotwire the door?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00102'));
	sleep(10);

	// Roland : Yep. Marking a point for Crimson. They can start the overload there.
	dprint ("Roland: Yep. Marking a point for Crimson. They can start the overload there.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_inside_room_00103'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_approach_ball_1()

dprint("");
/*// Roland : Activate that, Spartans.
dprint ("Roland: Activate that, Spartans.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_approach_ball1_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_approach_ball1_00100'));

end_radio_transmission();*/

end


script static void vo_e10m2_activate_ball_1()
	e10m2_narrative_is_on = TRUE;
	
	// Roland : Now kick on the power over there and you should be good to go.
	dprint ("Roland: Now kick on the power over there and you should be good to go.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_activate_ball1_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_activate_ball1_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_approach_ball_2()
	e10m2_narrative_is_on = TRUE;
	
	// Roland : Here's the next one.
	dprint ("Roland: Here's the next one.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_roland_repeat_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_roland_repeat_00100'));
	sleep(10);
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	sleep_s(1);
	object_create_anew(e10_m2_lz_03);
	navpoint_track_object_named(e10_m2_lz_03, "navpoint_goto");
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------

	// Miller : Same drill as before, Crimson.
	dprint ("Miller: Same drill as before, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_approach_ball2_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_approach_ball2_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_button_rez()
	e10m2_narrative_is_on = TRUE;
	
	// Roland : Button's back. I have the best plans. They always work.
	dprint ("Roland: Button's back. I have the best plans. They always work.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_rez_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_rez_00100'));
	sleep(10);

	// Miller : Roland, shut it. Crimson, see if the button does what Roland thinks it does.
	dprint ("Miller: Roland, shut it. Crimson, see if the button does what Roland thinks it does.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_rez_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_rez_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_button_door()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Crimson, there's your way through. Get moving. We need that power supply.
	dprint ("Miller: Crimson, there's your way through. Get moving. We need that power supply.");
	start_radio_transmission("miller_transmission_name");
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m2_2_60);
	thread (pip_e10m2_buttondoor_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_door_00100'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void pip_e10m2_buttondoor_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_button_door_00100');
end


script static void vo_e10m2_ppm1()
	e10m2_narrative_is_on = TRUE;
	
	// Miller : Oh, man. That's no good.
	dprint ("Miller: Oh, man. That's no good.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm1_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm1_00100'));
	sleep(10);

	// Roland : Imagine I just used a lot of gravitational science mumbo jumbo. Requiem might get torn apart before it gets the chance to melt in the sun.
	dprint ("Roland: Imagine I just used a lot of gravitational science mumbo jumbo. Requiem might get torn apart before it gets the chance to melt in the sun.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm1_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm1_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


script static void vo_e10m2_ppm2()
	e10m2_narrative_is_on = TRUE;
										dprint("Play_mus_pve_e10m2_ppm2");
music_set_state('Play_mus_pve_e10m2_ppm2');
	// Roland : More quakes.
	dprint ("Roland: More quakes.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm2_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm2_00100'));
	sleep(10);

	// Miller : There's not much we can do about them other than hurry.
	dprint ("Miller: There's not much we can do about them other than hurry.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm2_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_ppm2_00101'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end

script static void vo_e10m2_forerunners_first_arrive()
	e10m2_narrative_is_on = TRUE;

	// Roland : Um, Spartan Miller, I’m detecting significant phasing activity--
	dprint ("Roland: Um, Spartan Miller, I’m detecting significant phasing activity--");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00100'));
	sleep(10);
	
	sleep_s(1);
	ai_place_in_limbo(e10_m2_1st_knights_1);
	sleep_s(1);
	ai_place_in_limbo(e10_m2_1st_knights_2);
	sleep_s(2);
	ai_place_in_limbo(e10_m2_1st_pawns);

	// Miller : Prometheans!
	dprint ("Miller: Prometheans!");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00101'));
	sleep(10);
	
//	end_radio_transmission();
//	e10m2_narrative_is_on = FALSE;
//end
//
//script static void vo_e10m2_forerunners_arrive_2()
//	e10m2_narrative_is_on = TRUE;

	// Miller : They’re pulling out the big guns on this one—you must be making someone nervous.
	dprint ("Miller: They’re pulling out the big guns on this one—you must be making someone nervous.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00102'));
	sleep(10);

	// Miller : Look sharp, Crimson!
	dprint ("Miller: Look sharp, Crimson!");
		cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_forerunners_arrive_00103'));

	end_radio_transmission();
	e10m2_narrative_is_on = FALSE;
end


// ============================================	MISC SCRIPT	========================================================