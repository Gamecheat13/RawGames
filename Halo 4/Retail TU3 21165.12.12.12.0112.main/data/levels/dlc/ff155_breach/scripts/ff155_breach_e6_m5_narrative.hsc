// =============================================================================================================================
//============================================ E6M5 BREACH NARRATIVE SCRIPT ================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e6m5_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e6m5_entrance_roach()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	dprint("Play_mus_pve_e6m5_entrance_roach");
	music_set_state('Play_mus_pve_e6m5_entrance_roach');
	e6m5_narrative_is_on = TRUE;
	// Miller : Crimson is inbound on Switchback's position, Commander. Looks disabled, but can’t confirm.
	dprint ("Miller: Crimson is inbound on Switchback's position, Commander. Looks disabled, but can’t confirm.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_entrance_roach_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_entrance_roach_00100'));
	sleep(10);
	
	// Palmer : Dalton? A little air support, please?
	dprint ("Palmer: Dalton? A little air support, please?");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_entrance_roach_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_entrance_roach_00101'));
	sleep(10);
	
	// Dalton : You got it, Commander.
	dprint ("Dalton: You got it, Commander.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_entrance_roach_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_entrance_roach_00102'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_collect_crimson()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Palmer : Murphy, hold position in the sky. Be ready to collect Crimson.
	dprint ("Palmer: Murphy, hold position in the sky. Be ready to collect Crimson.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_collect_crimson_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_collect_crimson_00100'));
	sleep(10);
	
	// Murphy : Ready to go when ya need me, Commander Palmer.
	dprint ("Murphy: Ready to go when ya need me, Commander Palmer.");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_collect_crimson_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_collect_crimson_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end

script static void vo_e6m5_harvester()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	
	// Miller : They’ve reached the Harvester, Commander.
	dprint ("Miller: They’ve reached the Harvester, Commander.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_harvester_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_harvester_00100'));
	
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end

script static void vo_e6m5_find_tags()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	dprint("Play_mus_pve_e6m5_find_tags");
	music_set_state('Play_mus_pve_e6m5_find_tags');
	e6m5_narrative_is_on = TRUE;
	// Palmer : Any luck reaching Switchback Leader, Miller?
	dprint ("Palmer: Miller, any luck reaching Switchback Leader?");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_find_tags_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_find_tags_00100'));
	sleep(10);
	
	// Miller : I’ve got a lock on their IFFs. They’re near the Harvester but there’s no movement and no radio contact.
	dprint ("Miller: I’ve got a lock on their IFFs. They’re near the Harvester but there’s no movement and no radio contact.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_find_tags_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_find_tags_00101'));
	sleep(10);
	
	// Palmer : Crimson, track those IFFs and either bring Switchback home, or collect the heads of the Covies responsible.
	dprint ("Palmer: Crimson, track those IFFs and either bring Switchback home, or collect the heads of the Covies responsible.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_find_tags_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_find_tags_00102'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_first_iff()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	dprint("Play_mus_pve_e6m5_first_iff");
	music_set_state('Play_mus_pve_e6m5_first_iff');
	//sound_impulse_start ('sound\ui\ui_iff_pickup_spops15_01', NONE, 1);
	sleep_s(2);
	e6m5_narrative_is_on = TRUE;
	// Miller : That's a Switchback tag…
	dprint ("Miller: That's a Switchback tag…");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_first_iff_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_first_iff_00100'));
	sleep(10);
	
	// Palmer : …but there's no one here. No record. Not even a body.
	dprint ("Palmer: …but there's no one here. No record. Not even a body.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_first_iff_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_first_iff_00101'));

	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_second_iff()
	sleep_until (e6m5_narrative_is_on == false, 1);
	//sound_impulse_start ('sound\ui\ui_iff_pickup_spops15_01', NONE, 1);
	sleep_s(2);
	e6m5_narrative_is_on = TRUE;
	// Miller : Checks out. Switchback. Again, nothing.
	dprint ("Miller: Checks out. Switchback. Again, nothing.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_second_iff_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_second_iff_00100'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_third_iff()
	sleep_until (e6m5_narrative_is_on == false, 1);
	//sound_impulse_start ('sound\ui\ui_iff_pickup_spops15_01', NONE, 1);
	sleep_s(2);
	e6m5_narrative_is_on = TRUE;
	// Palmer : Okay. This is weird.
	dprint ("Palmer: Okay. This is weird.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_third_iff_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_third_iff_00100'));
	sleep(10);
	
		// Palmer : Keep looking, Crimson.
	dprint ("Palmer: Keep looking, Crimson.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_first_iff_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_first_iff_00102'));
	
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_fourth_iff()
	sleep_until (e6m5_narrative_is_on == false, 1);
	//sound_impulse_start ('sound\ui\ui_iff_pickup_spops15_01', NONE, 1);
	sleep_s(2);
	e6m5_narrative_is_on = TRUE;
	// Miller : That's the last one, Commander.
	dprint ("Miller: That's the last one, Commander.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_fourth_iff_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_fourth_iff_00100'));
	sleep(10);
	
	// Palmer : We have four blank IFFs and zero bodies… What am I missing, Miller?
	dprint ("Palmer: We have four blank IFFs and zero bodies… What am I missing, Miller?");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_fourth_iff_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_fourth_iff_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_where_switchback()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Palmer : Crimson, Keep an eye out for any other sign of Switchback and make sure the Covenant don't reactivate the Harvester.
	dprint ("Palmer: Crimson, Keep an eye out for any other sign of Switchback and make sure the Covenant don't reactivate the Harvester.");
	start_radio_transmission("palmer_transmission_name");
	hud_play_pip_from_tag (levels\dlc\shared\binks\ep6_m5_1_60);
	thread (pip_e6m5_whereswitchback_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_where_switchback_00100'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void pip_e6m5_whereswitchback_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_where_switchback_00100');
end


script static void vo_e6m5_hold_covenant()

dprint("deprecated");

end


script static void vo_e6m5_distract_covenant()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Miller : The only way to disable this thing for sure is to get inside.
	dprint ("Miller: The only way to disable this thing for sure is to get inside.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_distract_covenant_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_distract_covenant_00100'));
	sleep(10);
	
	// Palmer : Let's invite the Covies inside out to play. Just need something big and explosive to get their attention…
	dprint ("Palmer: Let's invite the Covies out to play. Just need something big and explosive to get their attention…");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_distract_covenant_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_distract_covenant_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_blow_leg()
	sleep_until (e6m5_narrative_is_on == false, 1);

	dprint("Play_mus_pve_e6m5_blow_leg");
	music_set_state('Play_mus_pve_e6m5_blow_leg');
	e6m5_narrative_is_on = TRUE;
/*	// Palmer : Here’s a weak spot on the digger’s leg. Hit it.
	dprint ("Palmer: Here’s a weak spot on the digger’s leg. Hit it.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00100'));
	sleep(10);*/
	
	// Miller : If we blow a few of these computers, it should get their attention. Marking one.
	dprint ("Miller: If we blow a few of these computers, it should get their attention. Marking one.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00101'));
	sleep(10);
	end_radio_transmission();

end

script static void vo_e6m5_blow_leg2()
	// Palmer : That'll do. Crimson, light it up!
	dprint ("Palmer: That'll do. Crimson, light it up!");
	start_radio_transmission("palmer_transmission_name");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00102'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end

script static void vo_e6m5_blow_computer()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
		
	// Miller : If we blow a few of these computers, it should get their attention. Marking one.
	dprint ("Miller: If we blow a few of these computers, it should get their attention. Marking one.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00101'));
	sleep(10);
	
	// Palmer : That'll do. Crimson, light it up!
	dprint ("Palmer: That'll do. Crimson, light it up!");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_blow_leg_00102'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end

script static void vo_e6m5_after_explosion()
	sleep_until (e6m5_narrative_is_on == false, 1);


	dprint("Play_mus_pve_e6m5_after_explosion");
	music_set_state('Play_mus_pve_e6m5_after_explosion');
	e6m5_narrative_is_on = TRUE;
	// Miller : Digger's opening. You got their attention alright!
	dprint ("Miller: Harvester's opening. You got their attention alright!");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_after_explosion_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_after_explosion_00100'));
	sleep(10);
	
	// Palmer : Prepare a welcoming party, Crimson!
	dprint ("Palmer: Prepare a welcoming party, Crimson!");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_after_explosion_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_after_explosion_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_go_inside()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Miller : You're good to head inside.
	dprint ("Miller: You're good to head inside.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_go_inside_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_go_inside_00100'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_cleans_up()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Miller : Area is clear.
	dprint ("Miller: Area is clear.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_cleans_up_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_cleans_up_00100'));
	sleep(10);
	
	// Palmer : Head inside Crimson.
	dprint ("Palmer: Move in, Crimson.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_cleans_up_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_cleans_up_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_digger_offline()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Palmer : Miller, where's the control center?
	dprint ("Palmer: Miller, where's the control center?");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_digger_offline_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_digger_offline_00100'));
	sleep(10);
	
	// Miller : Right over there.
	dprint ("Miller: Right over there.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_digger_offline_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_digger_offline_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_ensure_digger()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Miller : Digger is down but it won’t take much to get it back in working order.
	dprint ("Miller: Digger is down but it won’t take much to get it back in working order.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_ensure_digger_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_ensure_digger_00100'));
	sleep(10);
	
	// Palmer : Crimson, make sure it can't be brought back to life.
	dprint ("Palmer: Crimson, make sure it can't be brought back to life.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_ensure_digger_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_ensure_digger_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_clear_covenant()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Palmer : Take out all the Covenant. Nobody’s starting this thing back up.
	dprint ("Palmer: Take out all the Covenant. Nobody’s starting this thing back up.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_clear_covenant_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_clear_covenant_00100'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_controls_down()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	dprint("Play_mus_pve_e6m5_controls_down");
	music_set_state('Play_mus_pve_e6m5_controls_down');
	e6m5_narrative_is_on = TRUE;
	// Palmer : Enthusiasm, Crimson, I like it. Fall out. Murphy, prep for pickup.
	dprint ("Palmer: Enthusiasm, Crimson, I like it. Fall out. Murphy, prep for pickup.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_controls_down_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_controls_down_00100'));
	sleep(10);
	
	// Murphy : You got it, Commander.
	dprint ("Murphy: You got it, Commander.");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_controls_down_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_controls_down_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_the_lz()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Miller : A few more Prometheans, late to the party!
	dprint ("Miller: A few more Prometheans, late to the party!");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_the_lz_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_the_lz_00100'));
	sleep(10);
	
	// Palmer : Nothing Crimson can't handle.
	dprint ("Palmer: Nothing Crimson can't handle.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_the_lz_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_the_lz_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_covenant_cleared()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	// Miller : Murphy, Crimson’s ready for pickup
	dprint ("Miller: Murphy, Crimson’s ready for pickup");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_get2LZ_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_get2LZ_00100'));
	sleep(10);
	
	// Murphy : On station and ready to fly.
	dprint ("Murphy: On station and ready to fly.");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_get2LZ_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_get2LZ_00101'));
	
		// Palmer: Crimson, get to the LZ. We’ll figure out this Switchback thing once you’re home.
	dprint ("Palmer: Crimson, get to the LZ. We’ll figure out this Switchback thing once you’re home.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_get2LZ_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_get2LZ_00102'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


script static void vo_e6m5_crimson_phantom()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	dprint("Play_mus_pve_e6m5_crimson_phantom");
	music_set_state('Play_mus_pve_e6m5_crimson_phantom');
	e6m5_narrative_is_on = TRUE;
	// Miller : Digger's offline for good, Commander.
	dprint ("Miller: Harvester's offline for good, Commander.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_crimson_phantom_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_crimson_phantom_00100'));
	sleep(10);
	
	// Palmer : Good to hear. Still... what the hell happened to Switchback? We’re missing something.
	dprint ("Palmer: Good to hear. Still... what the hell happened to Switchback? We’re missing something.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_crimson_phantom_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_05\e06m5_crimson_phantom_00101'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end


// ============================================	MISC SCRIPT	========================================================

script static void vo_e6m5_kill_em_all()
	sleep_until (e6m5_narrative_is_on == false, 1);
	
	e6m5_narrative_is_on = TRUE;
	
	// Palmer : I'm still seeing targets down there.
	dprint ("Palmer: I'm still seeing targets down there.");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_08', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_08'));
	
	// Palmer : Take them out.
	dprint ("Palmer: Take them out.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");	
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_06', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_06'));
	
	end_radio_transmission();
	e6m5_narrative_is_on = FALSE;
end