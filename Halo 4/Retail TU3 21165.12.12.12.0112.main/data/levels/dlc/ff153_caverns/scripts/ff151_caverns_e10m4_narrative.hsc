//=============================================================================================================================
//============================================ E10M4 CAVERNS NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e10m4_narrative_is_on = FALSE;


// ============================================	PUP SCRIPT	========================================================


// ============================================	VO SCRIPT	========================================================


script static void vo_e10m4_narr_in()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	dprint("Play_mus_pve_e10m4_narr_in");
	music_set_state('Play_mus_pve_e10m4_narr_in');
	e10m4_narrative_is_on = TRUE;
	// Miller : Almost home, Crimson.
	dprint ("Miller: Almost home, Crimson.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00100'));
	sleep(10);
	
	// Dalton : Miller, there's several Pelicans down in Crimson's area.
	dprint ("Dalton: Miller, there's several Pelicans down in Crimson's area.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00101'));
	sleep(10);
	
	// Dalton : We have to get the guns offline if we're going to safely evacuate anyone from that corner of the planet.
	dprint ("Dalton: We have to get the guns offline if we're going to safely evacuate anyone from that corner of the planet.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00102'));
	sleep(10);
	
	// Miller : You got it, Dalton. Crimson, clear the area.
	dprint ("Miller: You got it, Dalton. Crimson, clear the area.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m4_1_60);
	thread (pip_e10m4_narrin_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00103'));
	sleep(10);
	
	// Miller : Feel free to use any toys you find that got left behind.
	dprint ("Miller: Feel free to use any toys you find that got left behind.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00104'));
	sleep(10);
	
	// Miller : We don't have time to send in cleanup teams.
	dprint ("Miller: We don't have time to send in cleanup teams.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00105'));
	sleep(10);
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void pip_e10m4_narrin_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_start_00103');
end


script static void vo_e10m4_shield_blocking()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e10m4_shield_blocking");
	music_set_state('Play_mus_pve_e10m4_shield_blocking');
	f_blip_object (e10m4_covshield, default);
	
	// Miller : Where did that shield come from? Roland, any thoughts?
	dprint ("Miller: Where did that shield come from? Roland, any thoughts?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00100'));
	sleep(10);
	
	// Roland : Oh, I don't have to shut up now?
	dprint ("Roland: Oh, I don't have to shut up now?");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00101'));
	sleep(10);
	
	// Miller : Roland.
	dprint ("Miller: Roland.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00102'));
	sleep(10);
	
	// Roland : No idea where the shield's originating from. But I can tell you that freaky beam thingy is what's powering the big guns.
	dprint ("Roland: No idea where the shield's originating from. But I can tell you that freaky beam thingy is what's powering the big guns.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00103'));
	sleep(10);
	
	// Roland : Give me a moment to sort it out.
	dprint ("Roland: Give me a moment to sort it out.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00104'));
	sleep(10);
	
	// Roland : I promise to be quiet while I do it.
	dprint ("Roland: I promise to be quiet while I do it.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00105'));
	sleep(10);
	
	// Miller : Crimson, hold down the area.
	dprint ("Miller: Crimson, hold down the area.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00106', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00106'));
	sleep(10);
	
	// Miller : We'll have an answer to you shortly.
	dprint ("Miller: We'll have an answer to you shortly.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00107', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_shield_blocking_00107'));
	
	end_radio_transmission();
	f_unblip_object (e10m4_covshield);
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_grab_toys()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Crimson, just a reminder that those Pelicans have useful supplies onboard.
	dprint ("Miller: Crimson, just a reminder that those Pelicans have useful supplies onboard.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_toys_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_toys_00100'));
	sleep(10);
		
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_in_a_mantis()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Nice! A Mantis should give the Covies some trouble.
	dprint ("Miller: Nice! A Mantis should give the Covies some trouble.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_mantis_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_mantis_00100'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_how_going_roland()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e10m4_how_going_roland");
	music_set_state('Play_mus_pve_e10m4_how_going_roland');
	
	// Miller : Roland, any update on that shield?
	dprint ("Miller: Roland, any update on that shield?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00100'));
	sleep(10);
	
	// Roland : Something in the area is messing up Crimson's armor sensors.
	dprint ("Roland: Something in the area is messing up Crimson's armor sensors.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00101'));
	sleep(10);
	
	// Roland : It's making it difficult to sort out the data.
	dprint ("Roland: It's making it difficult to sort out the data.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00102'));
	sleep(10);
	
	// Roland : I've got some theories…
	dprint ("Roland: I've got some theories…");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00103'));
	sleep(10);
	
	// Miller : Any you'd care to share?
	dprint ("Miller: Any you'd care to share?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00104'));
	sleep(10);
	
	// Roland : Not yet.
	dprint ("Roland: Not yet.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_roland_update_00105'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_hang_on_orbs()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	// Roland : Okay... Now. Now I have an idea.
	dprint ("Roland: Okay... Now. Now I have an idea.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00100'));
	sleep(10);
	
	// Miller : Shoot.
	dprint ("Miller: Shoot.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00101'));
	sleep(10);
	
	// Roland : Exactly the plan.
	dprint ("Roland: Exactly the plan.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00102'));
	sleep(10);
	
	// Roland : Shoot these.
	dprint ("Roland: Shoot these.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00103'));
	sleep(10);
	
	f_blip_object_cui (e10m4_core01->shell_outer_object(), "navpoint_healthbar_neutralize");
	f_blip_object_cui (e10m4_core02->shell_outer_object(), "navpoint_healthbar_neutralize");
	object_can_take_damage (e10m4_core01);
	object_can_take_damage (e10m4_core02);
	effect_kill_object_marker( levels\dlc\ff152_vortex\crates\forerunner_spherebase\forerunner_spherebase\fx\spherebase_shield.effect, e10m4_core01, core_pos);
	effect_kill_object_marker( levels\dlc\ff152_vortex\crates\forerunner_spherebase\forerunner_spherebase\fx\spherebase_shield.effect, e10m4_core02, core_pos);
	
	// Roland : And the shield should go with them.
	dprint ("Roland: And the shield should go with them.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00105'));
	sleep(10);
	
	// Miller : Do it, Crimson. We need to get at the anti-air power supply.
	dprint ("Miller: Do it, Crimson. We need to get at the anti-air power supply..");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00106', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_orbs_00106'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_one_orb_destroyed()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : One down. Any effect?
	dprint ("Miller: One down. Any effect?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_one_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_one_down_00100'));
	sleep(10);
	
	// Roland : Definitely.
	dprint ("Roland: Definitely.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_one_down_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_one_down_00101'));
	sleep(10);
	
	// Roland : The shield's at half power.
	dprint ("Roland: The shield's at half power.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_one_down_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_one_down_00102'));
	sleep(10);
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_two_orb_destroyed()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	// Miller : One more to go.
	dprint ("Miller: One more to go.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_two_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_two_down_00100'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_third_orb_destroyed()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e10m4_how_destroyed");
	music_set_state('Play_mus_pve_e10m4_how_destroyed');

	// Roland : That did it.
	dprint ("Roland: That did it.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00100'));
	sleep(10);
	
	// Roland : Guns offline.
	dprint ("Roland: Guns offline.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00101'));
	sleep(10);
	
	// Roland : Shield down.
	dprint ("Roland: Shield down.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00102'));
	sleep(10);
	
	// Roland : Pretty good plan, I'd say.
	dprint ("Roland: Pretty good plan, I'd say.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00103'));
	sleep(10);
	
	// Roland : Maybe not the most exciting…
	dprint ("Roland: Maybe not the most exciting…");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00104'));
	sleep(10);
	
	// Miller : It was great work, Roland. You too, Crimson.
	dprint ("Miller: It was great work, Roland. You too, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_three_down_00105'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end



script static void vo_e10m4_door_is_locked()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Roland…
	dprint ("Miller: Roland…");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_locked_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_locked_00100'));
	sleep(10);
	
	// Roland : That's a big locked door is what that is.
	dprint ("Roland: That's a big locked door is what that is.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_locked_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_locked_00101'));
	sleep(10);
	
	// Roland : Already looking for a way through.
	dprint ("Roland: Already looking for a way through.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_locked_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_locked_00102'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_way_through()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	// Roland : Got it. Crimson, marking the door override for you now.
	dprint ("Roland: Got it. Crimson, marking the door override for you now.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_exit_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_exit_00100'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_skyfall()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH(), -0.2, .8, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound' );
	sleep (30);
	
	// Miller: The quakes are getting worse. We haven’t got a lot of time left here.
	dprint ("Miller: The quakes are getting worse. We haven’t got a lot of time left here.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_skyfall_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_skyfall_00100'));
	sleep(10);
		// Miller: Crimson, you’ve got to move. Those quakes are Requiem trying to tear itself apart with you still on it.
	dprint ("Miller: Crimson, you’ve got to move. Those quakes are Requiem trying to tear itself apart with you still on it.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_skyfall_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_skyfall_00101'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_clear_the_breach()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Dalton, Crimson's almost in position.
	dprint ("Miller: Dalton, Crimson's almost in position.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00100'));
	sleep(10);
	
	// Dalton : Got ya, Miller.
	dprint ("Dalton: Got ya, Miller.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00101'));
	sleep(10);
	
	// Dalton : Pelican's inbound, but it has to take the long way around with all those guns still firing.
	dprint ("Dalton: Pelican's inbound, but it has to take the long way around with all those guns still firing.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00102'));
	sleep(10);
	
	// Miller : Crimson will have the beach clear by the time your pilot gets there.
	dprint ("Miller: Crimson will have the beach clear by the time your pilot gets there.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_beach_00103'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_pelican_arrives()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
		
	// Dalton : Miller, Crimson's ride is on station.
	dprint ("Dalton: Miller, Crimson's ride is on station.");
	start_radio_transmission("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_pelican_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_pelican_00100'));
	sleep(10);
	
	// Miller : Good work so far, Crimson. Let's get the power supply back to the Harvester and get the hell off this planet.
	dprint ("Miller: Good work so far, Crimson. Let's get the power supply back to the Harvester and get the hell off this planet.");
	start_radio_transmission("miller_transmission_name");
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m4_2_60);
	thread (pip_e10m4_pelicanarrives_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_end_00100'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void pip_e10m4_pelicanarrives_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_04\e10m4_end_00100');
end


// ============================================	VO GLOBALS SCRIPT	========================================================

script static void vo_e10m4_global_miller_phantom_01()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Phantom on approach.
	dprint ("Miller: Phantom on approach.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_phantom_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_phantom_01'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_global_miller_waypoint_01()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Setting a waypoint.
	dprint ("Miller: Setting a waypoint.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_01'));

	// Miller : Get moving.
	dprint ("Miller: Get moving.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_05', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_05'));
		
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_miller_few_more_03()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Few more to go.
	dprint ("Miller: Few more to go.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_03', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_03'));
	
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_global_miller_few_more_01()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : You've still got some stragglers out there.
	dprint ("Miller: You've still got some stragglers out there.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_01'));
		
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_globals_miller_crawlers_01()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	start_radio_transmission("miller_transmission_name");
	
	// Miller : Crawlers!
	dprint ("Miller: Crawlers!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crawlers_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crawlers_01'));
		
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_globals_miller_droppod_01()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	
	// Miller : Drop pod incoming!
	dprint ("Miller: Drop pod incoming!");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100'));
		
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end


script static void vo_e10m4_globals_miller_droppod_02()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;
	start_radio_transmission("miller_transmission_name");
	
	// Miller : Heads up!
	dprint ("Miller: Heads up!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06'));

	// Miller : Additional targets inbound!
	dprint ("Miller: Additional targets inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_03', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_03'));
		
	end_radio_transmission();
	e10m4_narrative_is_on = FALSE;
end