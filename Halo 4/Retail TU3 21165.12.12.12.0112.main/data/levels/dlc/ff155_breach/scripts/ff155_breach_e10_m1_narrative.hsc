//============================================ E10M1 BREACH NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e10m1_narrative_is_on = FALSE;


// ============================================	PUP SCRIPT	========================================================


// ============================================	VO SCRIPT	========================================================



script static void vo_e10m1_narr_in()
	dprint("Play_mus_pve_e10m1_narr_in");
	music_set_state('Play_mus_pve_e10m1_narr_in');
	e10m1_narrative_is_on = TRUE;
	
	sleep_s(4);
	
	dprint ("Roland: Let's be quick about this, yeah? Please?");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_narr_in_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_narr_in_00100'));
	sleep(10);

	dprint ("Miller: Roland, are you nervous?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_narr_in_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_narr_in_00101'));
	sleep(10);
	hud_play_pip_from_tag (levels\dlc\shared\binks\SP_G07_60);
	dprint ("Roland: We’re all going to be in the heart of a star real soon if Crimson and Majestic don't succeed. So, yeah I'm nervous.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_narr_in_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_narr_in_00102'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_skyfall()
	e10m1_narrative_is_on = TRUE;

  
	dprint ("Miller: Like Roland said, we need to be be quick.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_skyfall_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_skyfall_00100'));
	sleep(10);
	
	dprint ("Miller: Requiem is moving towards this system’s sun. The only way to get Infinity free of Requiem is to find the artifacts anchoring us here. Majestic’s got one, you’re chasing the other one.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_skyfall_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_skyfall_00101'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

	

script static void vo_e10m1_covenant()
	e10m1_narrative_is_on = TRUE;



	dprint ("Miller: Crimson, looks like we've got some true believers staying behind while the rest of the Covies evacuate. Push through them and get to Doctor Glassman’s coordinates ASAP.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_covenant_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_covenant_00100'));
	sleep(10);

// Murphy: Fangs out, Crimson!
dprint ("Murphy: Fangs out, Crimson!");
start_radio_transmission("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_readyfordanger_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_readyfordanger_01'));



	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_big_rock()
	e10m1_narrative_is_on = TRUE;
	dprint("Play_mus_pve_e10m1_big_rock");
	music_set_state('Play_mus_pve_e10m1_big_rock');
	

	dprint ("Miller: You've reached the coordinates... Doctor Glassman, you online?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00100'));
	sleep(10);

	dprint ("Dr. Glassman: I'm here, yes.");
	cui_hud_show_radio_transmission_hud("glassman_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00101'));
	sleep(10);

	dprint ("Miller: Crimson's where you said they should be.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00102'));
	sleep(10);

	dprint ("Miller: All they've found is a big rock.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00103'));
	sleep(10);

	dprint ("Dr. Glassman: The artifact is inside that rock wall.");
	cui_hud_show_radio_transmission_hud("glassman_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00104'));
	sleep(10);

	// Miller : Inside? Oh sonuva-- Crimson. That dig you stopped the other day? I think I just figured out what they were after.
	dprint ("Miller: Inside? Oh sonuva-- Crimson. That dig you stopped the other day? I think I just figured out what they were after.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m1_1_60);
	thread (pip_e10m1_bigrock_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00105'));

	end_radio_transmission();	
	e10m1_narrative_is_on = FALSE;
end


script static void pip_e10m1_bigrock_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_big_rock_00105');
end


script static void vo_e10m1_get_inside()
	e10m1_narrative_is_on = TRUE;
	
	// Miller : Let's get inside the [digger] and fire it up again. We'll finish what they started.
	dprint ("Miller: Let's get inside the [digger] and fire it up again. We'll finish what they started.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_get_inside_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_get_inside_00100'));
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_shield()
	e10m1_narrative_is_on = TRUE;
	
	// Miller : Can't see a way to bring that shield down aside from brute forcing it.
	dprint ("Miller: Can't see a way to bring that shield down aside from brute forcing it.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_shield_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_shield_00100'));
	sleep(10);
	
		// Miller : Dalton, Crimson could use some fire power.
	dprint ("Miller: Dalton, Crimson could use some fire power.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00100'));
	sleep(10);

	// Dalton : How strong? Rocket launchers? Spartan lasers?
	dprint ("Dalton: How strong? Rocket launchers? Spartan lasers?");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00101'));
	sleep(10);
	
	//GAMEPLAY STUFF ----------------------------------------------------------------------------------------------------------------
	ai_place(e10m1_phantom_1);
	//GAMEPLAY STUFF ----------------------------------------------------------------------------------------------------------------

	// Miller : I was thinking something more along the lines of air support.
	dprint ("Miller: I was thinking something more along the lines of air support.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00102'));
	sleep(10);

//	// Dalton : Roger that. Pelican inbound.
//	dprint ("Dalton: Roger that. Pelican inbound.");
//	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00103', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_shield_00103'));
	
	// Dalton : Miller, there’s anti-air stationed near Crimson’s position.
	dprint ("Dalton: Miller, there’s anti-air stationed near Crimson’s position.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00100'));
	sleep(10);

	// Miller : Get a pilot on station, the corridor will be clear shortly.
	dprint ("Miller: Get a pilot on station, the corridor will be clear shortly.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00103'));
	sleep(10);
	
	dprint ("Miller: Crimson, move in on the anti-air. Find a way to bring it down.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_take_out_guns_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_take_out_guns_00100'));
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

//script static void vo_e10m1_pelican_shield()
//	dprint("deprecated");
//end

//script static void vo_e10m1_aa_fire()
//	e10m1_narrative_is_on = TRUE;
//	
//	// Dalton : Miller, there’s anti-air stationed near Crimson’s position.
//	dprint ("Dalton: Miller, there’s anti-air stationed near Crimson’s position.");
//	start_radio_transmission("dalton_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00100', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00100'));
//	sleep(10);
//
//	// Dalton : If you want air support, you need to clear the skies.
//	dprint ("Dalton: If you want air support, you need to clear the skies.");
//	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00101', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00101'));
//	sleep(10);
//
//	// Miller : That can be arranged.
//	dprint ("Miller: That can be arranged.");
//	cui_hud_show_radio_transmission_hud("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00102', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00102'));
//	sleep(10);
//
//	// Miller : Get a pilot on station, the corridor will be clear shortly.
//	dprint ("Miller: Get a pilot on station, the corridor will be clear shortly.");
//	cui_hud_show_radio_transmission_hud("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00103', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_aa_fire_00103'));
//
//	end_radio_transmission();
//	e10m1_narrative_is_on = FALSE;
//end

//script static void vo_e10m1_take_out_guns()
//	e10m1_narrative_is_on = TRUE;
//	
//	dprint ("Miller: Crimson, move in on the anti-air. Find a way to bring it down.");
//	start_radio_transmission("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_take_out_guns_00100', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_take_out_guns_00100'));
//	
//	end_radio_transmission();
//	e10m1_narrative_is_on = FALSE;
//end

//script static void vo_e10m1_break_guns()
//	e10m1_narrative_is_on = TRUE;
//	
//	dprint ("Miller: Okay... I'm not seeing an off switch around here.");
//	start_radio_transmission("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00100', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00100'));
//	sleep(10);
//
//	dprint ("Miller: Fine, we do this the old fashioned way.");
//	cui_hud_show_radio_transmission_hud("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00101', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00101'));
//
//	end_radio_transmission();
//	e10m1_narrative_is_on = FALSE;
//end

script static void vo_e10m1_guns_no_damage()
	e10m1_narrative_is_on = TRUE;
	
	dprint("Play_mus_pve_e10m1_no_damage");
	music_set_state('Play_mus_pve_e10m1_no_damage');

	dprint ("Miller: Roland, the anti-air looks to be shielded.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00101'));
	sleep(10);

	// Roland : Agreed. I bet you want an idea for how to bring them down.
	dprint ("Roland: Agreed. I bet you want an idea for how to bring them down.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00102'));
	sleep(10);

	// Miller : Wouldn't mind one.
	dprint ("Miller: Wouldn't mind one.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00103'));
	sleep(10);

	// Roland : Yeah... me too. Give me a second here.
	dprint ("Roland: Yeah... me too. Give me a second here.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00104'));
//	sleep(10);
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_guns_no_damage2()
	e10m1_narrative_is_on = TRUE;

	// Roland : Heh. Whatever Covie set up those shields forgot to change the default remote deactivation code.
	dprint ("Roland: Heh. Whatever Covie set up those shields forgot to change the default remote deactivation code.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00105'));
	sleep(10);

	// Roland : If I broadcast that... boom. No more shields.
	
	dprint ("Roland: If I broadcast that... boom. No more shields.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00106', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00106'));
	sleep(10);
	
	//GAMEPLAY STUFF ----------------------------------------------------------------------------------------------------------------
	object_set_function_variable(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret), shield_alpha, 1, 2);
	object_set_function_variable(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret), shield_alpha, 1, 2);
	sleep_s(2);
	effect_kill_object_marker(levels\dlc\shared\effects\fr_turret_shield.effect, ai_vehicle_get(e10m1_turret_1.turret), fx_life_source);
	effect_kill_object_marker(levels\dlc\shared\effects\fr_turret_shield.effect, ai_vehicle_get(e10m1_turret_2.turret), fx_life_source);
	//GAMEPLAY STUFF END -------------------------------------------------------------------------------------------------------------

	// Miller : Well done, Roland. Crimson, hit those guns!
	dprint ("Miller: Well done, Roland. Crimson, hit those guns!");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00107', NONE, 1);
	//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_guns_no_damage_00107'));
	
	//GAMEPLAY STUFF ----------------------------------------------------------------------------------------------------------------
	sleep_s(0.1);
	object_can_take_damage(ai_vehicle_get(e10m1_turret_1.turret));
	object_can_take_damage(ai_vehicle_get(e10m1_turret_2.turret));
	f_blip_object_cui(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret), "navpoint_healthbar_neutralize");
	f_blip_object_cui(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret), "navpoint_healthbar_neutralize");
	thread(f_e10m1_turret_1_dead());
	thread(f_e10m1_turret_2_dead());
	//GAMEPLAY STUFF END -------------------------------------------------------------------------------------------------------------

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_hey_dalton()
	e10m1_narrative_is_on = TRUE;

	// Miller : Dalton, do the AA guns stop you from sending ordnance?
	dprint ("Miller: Dalton, do the AA guns stop you from sending ordnance?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00102'));
	sleep(10);

	// Dalton : They do not. Sending Crimson some big guns right now.
	dprint ("Dalton: They do not. Sending Crimson some big guns right now.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00103'));
	sleep(10);
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	sleep_s(2);
	ordnance_drop(f_e10_m1_pod_1, "storm_rocket_launcher");
	sleep_s(0.5);
	ordnance_drop(f_e10_m1_pod_2, "storm_rocket_launcher");
	sleep_s(0.25);
	ordnance_drop(f_e10_m1_pod_3, "storm_rocket_launcher");
	ordnance_show_nav_markers(TRUE);
	//GAMEPLAY STUFF END --------------------------------------------------------------------------------------------------------------

	// Miller : Alright, Crimson. Brute force it. Shoot it till it breaks.
	dprint ("Miller: Alright, Crimson. Brute force it. Shoot it till it breaks.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_break_guns_00104'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_nice_work()
	e10m1_narrative_is_on = TRUE;
	
	// Miller : Good stuff, Crimson. Two guns down.
	dprint ("Miller: Good stuff, Crimson. Two guns down.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_nice_work_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_nice_work_00100'));
	sleep(10);

	// Dalton : Still one more on the upper ridge.
	dprint ("Dalton: Still one more on the upper ridge.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_nice_work_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_nice_work_00101'));
	sleep(10);

	// Miller : Acknowledged, Dalton. Crimson’s on it.
	dprint ("Miller: Acknowledged, Dalton. Crimson’s on it.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_nice_work_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_nice_work_00102'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_back_to_digger()
	e10m1_narrative_is_on = TRUE;
	
	// Miller : Gun's down! Excellent, Crimson! Fall back to [digger].
	dprint ("Miller: Gun's down! Excellent, Crimson! Fall back to [digger].");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00100'));
	sleep(10);
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_call_in_pelican()
	e10m1_narrative_is_on = TRUE;
	
	dprint("Play_mus_pve_e10m1_call_in_pelican");
	music_set_state('Play_mus_pve_e10m1_call_in_pelican');
	
	dprint ("Miller: Dalton! Air corridor is clear.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00101'));
	sleep(10);

//	// Dalton : Affirmative, Miller.
//	dprint ("Dalton: Affirmative, Miller.");
//	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00102', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00102'));
//	sleep(10);

	// Dalton : Dalton to Lt. Murphy. You’ve got a green light.
	dprint ("Dalton: Dalton to Lt. Murphy. You’ve got a green light.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00103'));
	sleep(10);
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	//ai_place(e10m1_pelican_door);
	pup_play_show(e10_m1_pelican_shoots_digger);
	//GAMEPLAY STUFF END ------------------------------------------------------------------------------------------------------------

	// Murphy : Affirmative, Infinity.
	dprint ("Murphy: Affirmative, Infinity.");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_back_to_digger_00104'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_pelican_blasts()
	e10m1_narrative_is_on = TRUE;
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------	
	f_new_objective(e10_m1_obj_2);
	thread(f_e10_m1_inside_digger());
	ai_place(sq_e10m1_guard_inside_1);
	ai_place(sq_e10m1_guard_inside_2);
	ai_place(sq_e10m1_guard_inside_3);
	ai_place(sq_e10m1_guard_inside_4);
	ai_place(sq_e10m1_guard_inside_5);
	ai_place(sq_e10m1_guard_inside_6);
	//GAMEPLAY STUFF END -------------------------------------------------------------------------------------------------------------
	
	// Murphy : Boom! Shield's down!
	dprint ("Murphy: Boom! Shield's down!");
	start_radio_transmission("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00100'));
	sleep(10);

	// Dalton : Excellent!
/*	dprint ("Dalton: Excellent!");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00101'));
	sleep(10);

	// Miller : Thanks, Murphy.
	dprint ("Miller: Thanks, Murphy.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00102'));
	sleep(10);

	// Murphy : Any time, Spartans.
	dprint ("Murphy: Any time, Spartans.");
	cui_hud_show_radio_transmission_hud("incoming_transmission");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00103'));
	sleep(10);*/

	// Miller : Crimson, get inside [digger] and let's see what we've got to work with.
	dprint ("Miller: Crimson, get inside [digger] and let's see what we've got to work with.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pelican_blasts_00104'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_crimson_digger()
	e10m1_narrative_is_on = TRUE;
	
	dprint("Play_mus_pve_e10m1_crimson_digger");
	music_set_state('Play_mus_pve_e10m1_crimson_digger');
	
	// 10-1 Male Scientist 1 : Spartans! Look! Spartans!
	dprint ("10-1 Male Scientist 1: Spartans! Look! Spartans!");
	start_radio_transmission("e10_m1_scientist1_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_crimson_digger_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_crimson_digger_00100'));
	sleep(10);

	// Miller : Science team?! Crimson! Get them out of there!
	dprint ("Miller: Science team?! Crimson! Get them out of there!");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_crimson_digger_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_crimson_digger_00101'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_scientists_free()
	e10m1_narrative_is_on = TRUE;

	// Miller : All clear. Set Science Team free.
	dprint ("Miller: All clear. Set Science Team free.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_crimson_diggernew_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_crimson_diggernew_00101'));
	sleep(10);
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end



script static void vo_e10m1_free()
	e10m1_narrative_is_on = TRUE;
	
	dprint("Play_mus_pve_e10m1_free");
	music_set_state('Play_mus_pve_e10m1_free');
	
	// 10-1 Male Scientist 1 : They were trying to make us fix the Harvester. But the power supply is destroyed.
	dprint ("10-1 Male Scientist 1: They were trying to make us fix the Harvester. But the power supply is destroyed.");
	start_radio_transmission("e10_m1_scientist1_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00100'));
	sleep(10);

	// 10-1 Male Scientist 1 : There’s nothing we could do.
	dprint ("10-1 Male Scientist 1: There’s nothing we could do.");
	cui_hud_show_radio_transmission_hud("e10_m1_scientist1_transmission_name ");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00102'));
	sleep(10);

	// Miller : Doctor, we're going to get you a ride out of here, sit tight.
	dprint ("Miller: Doctor, we're going to get you a ride out of here, sit tight.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00103'));
	sleep(10);

	// Miller : Crimson, check the power supply.
	dprint ("Miller: Crimson, check the power supply.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00103a', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00103a'));
	sleep(10);

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_look_at_power()
	e10m1_narrative_is_on = TRUE;
	
	// Miller : Hrmm... that doesn’t look good.
	dprint ("Miller: Hrmm... that doesn’t look good.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00103b', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00103b'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_free_02()
	e10m1_narrative_is_on = TRUE;

	// Dalton : Miller, we need room to pick up the big brains.
	dprint ("Dalton: Miller, we need room to pick up the big brains.");
	start_radio_transmission("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00104a', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00104a'));
	sleep(10);

	// Miller : Affirmative, Dalton. Crimson, clear the area outside the Harvester and clear some space for Dalton's people.
	dprint ("Miller: Affirmative, Dalton. Crimson, clear the area outside the Harvester and clear some space for Dalton's people.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00104b', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_free_00104b'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_clearing_lz()
	e10m1_narrative_is_on = TRUE;
	
	dprint("Play_mus_pve_e10m1_clearing_lz");
	music_set_state('Play_mus_pve_e10m1_clearing_lz');
	
	// Miller : Roland, where the hell are we going to find a Covenant Harvester power supply?
	dprint ("Miller: Roland, where the hell are we going to find a Covenant Harvester power supply?");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00100'));
	sleep(10);

	// Roland : I think I know, but it's not close.
	dprint ("Roland: I think I know, but it's not close.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00101'));
	sleep(10);

	// Miller : What do you have in mind, Roland?
	dprint ("Miller: What do you have in mind, Roland?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00102'));
	sleep(10);

	// Roland : Can Crimson get a ride?
	dprint ("Roland: Can Crimson get a ride?");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00103alt', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00103alt'));
	sleep(10);

	// Dalton : That they can.
	dprint ("Dalton: That they can.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00104'));
	
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------
	ai_place(e10m1_pelican_end);
	//GAMEPLAY STUFF----------------------------------------------------------------------------------------------------------------

	// Miller : Spartans, move to the evac zone.
	dprint ("Miller: Spartans, move to the evac zone.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_clearing_lz_00105'));

	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void vo_e10m1_pickup()
	e10m1_narrative_is_on = TRUE;
	
	// Murphy : On station and ready for pickup, Spartans.
	dprint ("Murphy: On station and ready for pickup, Spartans.");
	start_radio_transmission("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pickup_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pickup_00100'));
	sleep(10);
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_load_up()
	e10m1_narrative_is_on = TRUE;

	// Miller : Load up, Crimson. Let's go. Roland, tell me more about what we're chasing after...
	dprint ("Miller: Load up, Crimson. Let's go. Roland, tell me more about what we're chasing after...");
	start_radio_transmission("miller_transmission_name");
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m1_2_60);
	thread (pip_e10m1_loadup_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pickup_00200'));
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end


script static void pip_e10m1_loadup_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_pickup_00200');
end


script static void vo_e10m1_one_down()
	e10m1_narrative_is_on = TRUE;

	// Roland : One down.
	dprint ("Roland: One down.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_02\e06m2_comm_down_00100'));
	sleep(10);
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10m1_shields_up()
	e10m1_narrative_is_on = TRUE;

	// Miller: Roland, shield’s still up.
	dprint ("Miller: Roland, shield’s still up.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00100'));
	sleep(10);
	
		// Roland: Working on it.
	dprint ("Roland: Working on it.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00101'));
	
	
	end_radio_transmission();
	e10m1_narrative_is_on = FALSE;
end

script static void vo_e10_m2_miller_reinforcements_01()
	global_narrative_is_on = TRUE;

	// Miller : Reinforcements!
	dprint ("Miller: Reinforcements!");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_01'));
	sleep(10);

	// Miller : Take them out.
	dprint ("Miller: Take them out.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_06', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_06'));
	
	end_radio_transmission();
	global_narrative_is_on = FALSE;
end

script static void vo_e10_m2_roland_shield()
	global_narrative_is_on = TRUE;

	// Roland : Success! Shield down!
	dprint("Roland: Success! Shield down!");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00100'));

	end_radio_transmission();
	global_narrative_is_on = FALSE;
end
