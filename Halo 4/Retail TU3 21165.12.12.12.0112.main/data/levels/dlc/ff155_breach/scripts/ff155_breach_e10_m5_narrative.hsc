//=============================================================================================================================
//============================================ E10M5 BREACH NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================


// ============================================	PUP SCRIPT	========================================================

script static void e10m5_harvester_fire()
	// FX and camera sequence for firing of Harvester
	
	camera_control (true);
	camera_fov = 90;
	fade_in (0, 0, 0, 60);
	camera_pan (blast_01_1, blast_01_2, 200, 100, 0, 30, 0);
	//fx_digger_fire();
	sleep (200);	
	camera_pan (blast_01_2, blast_01_3, 300, 150, 0, 0, 1);
	sleep (298);
	camera_pan (blast_02_1, blast_02_2, 300, 0, 1, 0, 1);
	sleep (90);
	camera_pan (blast_03_1, blast_03_2, 300, 0, 1, 0, 1);
	sleep (90);
	camera_pan (blast_04_1, blast_04_2, 300, 0, 1, 0, 1);
	sleep (120);
	camera_pan (blast_05_1, blast_05_2, 300, 0, 1, 0, 1);
	sleep (120);
	camera_fov = 33;
	camera_pan (blast_06_1, blast_06_2, 300, 0, 1, 0, 1);
	sleep (150);
	camera_fov = 78;
	dprint ("fix camera fov");
	camera_control (false);
	dprint ("return camera control");
	
end


// ============================================	VO SCRIPT	========================================================


script static void vo_e10m5_narr_in()
				dprint("Play_mus_pve_e10m5_narr_in");
music_set_state('Play_mus_pve_e10m5_narr_in');
e10m5_narrative_is_on = TRUE;
// Miller : Commander Palmer, Crimson are back the Harvester. They've got [macguffin].
dprint ("Miller: Commander Palmer, Crimson are back at the Harvester. They've got the power supply.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00100'));
sleep(10);

// Miller : Just have to clear the area and they'll be all set.
dprint ("Miller: Just have to clear the area and they'll be all set.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00101'));
sleep(10);

// Palmer : Understood, Miller.
dprint ("Palmer: Understood, Miller.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00102'));
sleep(10);

// Palmer : Majestic and I are almost to our goal as well.
dprint ("Palmer: Majestic and I are almost to our goal as well.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00103'));
sleep(10);

// Palmer : Dalton, how's the evac going?
dprint ("Palmer: Dalton, how's the evac going?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00104'));
sleep(10);

// Dalton : Rest of the planet's scrambled, Commander.
dprint ("Dalton: Rest of the planet's scrambled, Commander.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00105'));
sleep(10);

// Dalton : You guys are the last ones down there.
dprint ("Dalton: You guys are the last ones down there.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_narr_in_00106'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_head_to_excavator()
e10m5_narrative_is_on = TRUE;
//	thread (pip_e10m5_1_subtitles());
// Miller : Almost home, Crimson. Clear the area between here and the Harvester.
dprint ("Miller: Here we go, Crimson. The final stretch. Clear the area between here and the Harvester.");
start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m5_1_60);
thread (pip_e10m5_headtoexcavator_subtitles());
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_head_to_excavator_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_head_to_excavator_00100'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void pip_e10m5_headtoexcavator_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_head_to_excavator_00100');
end


script static void vo_e10m5_tickingclock()
e10m5_narrative_is_on = TRUE;

// Miller : Just checked the nav data. Requiem’s getting awfully close to her star. Let’s move quickly, Crimson.
dprint ("Miller: Just checked the nav data. Requiem’s getting awfully close to her star. Let’s move quickly, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_tickingclock_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_tickingclock_00100'));
sleep(10);

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_get_in_excavator()
e10m5_narrative_is_on = TRUE;
// Miller : Roland, we’ve got the power source, now Crimson needs to know how to hook it up.
dprint ("Miller: Roland, we’ve got the power source, now Crimson needs to know how to hook it up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_in_excavator_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_in_excavator_00100'));
sleep(10);

// Roland : I'll have you an operating manual shortly.
dprint ("Roland: I'll have you an operating manual shortly.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_in_excavator_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_in_excavator_00101'));
/*sleep(10);

// Miller : Thanks, Roland.
dprint ("Miller: Thanks, Roland.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_in_excavator_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_in_excavator_00102'));*/

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_power_up()
				dprint("Play_mus_pve_e10m5_power_up");
music_set_state('Play_mus_pve_e10m5_power_up');
e10m5_narrative_is_on = TRUE;
// Roland : The power core fits right there, Crimson.
dprint ("Roland: The power core fits right there, Crimson.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_power_up_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_power_up_00100'));
sleep(10);

// Roland : Slot [macguffin] and you can power up the [excavator].
dprint ("Roland: Slot it in and you can power up the Harvester.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_power_up_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_power_up_00101'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_room_opens()
e10m5_narrative_is_on = TRUE;
// Miller : Excellent work!
dprint ("Miller: Excellent work!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_room_opens_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_room_opens_00100'));
sleep(10);

// Miller : Control room's open. Get in there!
dprint ("Miller: Control room's open. Get in there!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_room_opens_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_room_opens_00101'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_enter_room()
e10m5_narrative_is_on = TRUE;
// Miller : Roland? Fire controls?
dprint ("Miller: Roland? Fire controls?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_enter_room_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_enter_room_00100'));
sleep(10);

// Roland : Right there.
dprint ("Roland: Right there.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_enter_room_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_enter_room_00101'));
sleep(10);

// Roland : Not exactly difficult. So easy a Grunt can do it.
dprint ("Roland: Not exactly difficult. So easy a Grunt can do it.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_enter_room_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_enter_room_00102'));
notifylevel ("thedoorishere");
end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_excavator_fires()
				dprint("Play_mus_pve_e10m5_excavator_fires");
music_set_state('Play_mus_pve_e10m5_excavator_fires');
e10m5_narrative_is_on = TRUE;

// Miller : Beautiful!
dprint ("Miller: Beautiful!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00100'));
sleep(10);

// Roland : Mining laser's opened a passage to the cave system.
dprint ("Roland: Mining laser's opened a passage to the cave system.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00101'));
sleep(10);

/*// Miller : Great!
dprint ("Miller: Great!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00102'));
sleep(10);*/

/*// Miller : Roland, tell Captain Lasky we've gained access.
dprint ("Miller: Roland, tell Captain Lasky we've gained access.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00103'));
sleep(10);*/

// Miller : Commander Palmer? We're in.
dprint ("Miller: Commander Palmer? We're in.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00104'));
sleep(10);

// Palmer : Miller--just tell me when you're done--Demarco! Wake up! On your six!
dprint ("Palmer: Miller--just tell me when you're done--Demarco! Wake up! On your six!");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00106_soundstory', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00106_soundstory'));
//sleep(10);
//
//// Palmer : Miller, just tell me when you're done--
//dprint ("Palmer: Miller, just tell me when you're done--");
//cui_hud_show_radio_transmission_hud("palmer_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00106', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00106'));
//sleep(10);
//
//// Palmer : Demarco! Wake up! On your six!
//dprint ("Palmer: Demarco! Wake up! On your six!");
//cui_hud_show_radio_transmission_hud("palmer_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00107', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_excavator_fires_00107'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_head_into_cave()
e10m5_narrative_is_on = TRUE;
// Miller : Let's get in the cave, Crimson.
dprint ("Miller: Let's get in the cave, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_head_into_cave_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_head_into_cave_00100'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_fr_int()
e10m5_narrative_is_on = TRUE;
// Miller : Oh... Look at that.
dprint ("Miller: Oh... Look at that.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_fr_int_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_fr_int_00100'));
sleep(10);

// Roland : I don't see the artifact.
dprint ("Roland: I don't see the artifact.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_fr_int_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_fr_int_00101'));
sleep(10);

// Miller : Good point.
dprint ("Miller: Good point.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_fr_int_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_fr_int_00102'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_clear_area()
e10m5_narrative_is_on = TRUE;
// Miller : Crimson, clear the area while I see if I can find what we're looking for.
dprint ("Miller: Crimson, clear the area. I'll find what yo're looking for.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_clear_area_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_clear_area_00100'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_find_artifact()
e10m5_narrative_is_on = TRUE;
// Miller : That's everyone. Nice work.
dprint ("Miller: That's everyone. Nice work.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_find_artifact_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_find_artifact_00100'));
sleep(10);

// Miller : Looks like this is the path deeper into... whatever this place is. Have a look.
dprint ("Miller: Looks like this is the path deeper into... whatever this place is. Have a look.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_find_artifact_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_find_artifact_00101'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_not_opening()
				dprint("Play_mus_pve_e10m5_not_openin");
music_set_state('Play_mus_pve_e10m5_not_openin');
e10m5_narrative_is_on = FALSE;
// Miller : Roland -- why's the door not opening?
dprint ("Miller: Roland -- why's the door not opening?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00100'));
sleep(10);

/*// Roland : Good question... let me see...
dprint ("Roland: Good question... let me see...");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00101'));
sleep(10);
*/
// Roland : ...looks like power's off to the whole area.
dprint ("Roland: ...looks like power's off to the whole area.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00102'));
sleep(10);

// Miller : Quickly, Roland. Requiem’s not slowing down.
dprint ("Miller: Quickly, Roland. Requiem’s not slowing down.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_not_opening_00103'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_power_source()
e10m5_narrative_is_on = TRUE;
// Roland : Ah! Power source located. Activating that will open the door.
dprint ("Roland: Ah! Power source located. Activating that will open the door.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_power_source_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_power_source_00100'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_powered_up()
e10m5_narrative_is_on = TRUE;
// Roland : Power's on.
dprint ("Roland: Power's on.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_powered_up_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_powered_up_00100'));
sleep(10);

// Miller : Great news. Crimson, let’s move with a purpose.
dprint ("Miller: Great news. Crimson, let’s move with a purpose.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_powered_up_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_powered_up_00101'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_open_artifact_door()
e10m5_narrative_is_on = TRUE;
// Miller : Almost there. We just might make it...
dprint ("Miller: Almost there. We just might make it...");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_open_artifact_door_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_open_artifact_door_00100'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_quiet()
dprint("deprecated");
/*e10m5_narrative_is_on = TRUE;
// Roland : Hey... anyone else notice how it's way too quiet in here.
dprint ("Roland: Hey... anyone else notice how it's way too quiet in here.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_quiet_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_quiet_00100'));
sleep(10);

// Miller : Stay ready for anything, Crimson.
dprint ("Miller: Stay ready for anything.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_quiet_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_quiet_00101'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;*/
end

script static void vo_e10m5_control()
dprint("deprecated");
/*e10m5_narrative_is_on = TRUE;
// Roland : Control panel spotted. Sending Crimson the unlock codes now.
dprint ("Roland: Control panel spotted. Sending Crimson the unlock codes now.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_control_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_control_00101'));

end_radio_transmission();*/
//e10m5_narrative_is_on = FALSE;
end

script static void vo_e10m5_there_it_is()
				dprint("Play_mus_pve_e10m5_there_it_is");
music_set_state('Play_mus_pve_e10m5_there_it_is');
e10m5_narrative_is_on = TRUE;
// Miller : That's it. That's what we're after! Roland, tell Captain Lasky Crimson has reached their artifact.
dprint ("Miller: That's it. That's what we're after! Roland, tell Captain Lasky Crimson has reached their artifact.");
start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag (levels\dlc\shared\binks\ep10_m5_2_60);
thread (pip_e10m5_thereitis_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_there_it_is_00100'));
sleep(10);

// Roland : Done and done.
dprint ("Roland: Done and done.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_there_it_is_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_there_it_is_00103'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void pip_e10m5_thereitis_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_there_it_is_00100');
end


script static void vo_e10m5_kickass()
				dprint("Play_mus_pve_e10m5_kickass");
music_set_state('Play_mus_pve_e10m5_kickass');
e10m5_narrative_is_on = TRUE;
// Miller : Take it offline, Crimson!
dprint ("Miller: Take it offline, Crimson!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00100'));

end_radio_transmission();

sleep_until (LevelEventStatus ("artifactoffline"), 1);

// Roland : Artifact's off the network.
dprint ("Roland: Artifact's off the network.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00101'));
sleep(10);

// Roland : Only Majestic's target remains.
dprint ("Roland: Only Majestic's target remains.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00102'));
sleep(10);

// Roland : I don't think Requiem appreciated that.
dprint ("Roland: And I don't think Requiem appreciated that.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_kickass_00105'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end

script static void vo_e10m5_success()
				dprint("Play_mus_pve_e10m5_success");
music_set_state('Play_mus_pve_e10m5_success');
e10m5_narrative_is_on = TRUE;

// Miller : Commander Palmer, Crimson has their artifact offline!
dprint ("Miller: Commander Palmer, Crimson has their artifact offline!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_palmer_soundstory_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_palmer_soundstory_00100'));
sleep(10);

// Palmer: Acknowledged.
dprint ("Palmer: Acknowledged.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_02'));
sleep(10);

// Palmer: Excellent work.
dprint ("Palmer: Excellent work.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_07'));


end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end



script static void vo_e10m5_ceiling()
				dprint("Play_mus_pve_e10m5_ceiling");
music_set_state('Play_mus_pve_e10m5_ceiling');
e10m5_narrative_is_on = TRUE;
// Roland : Spartan Miller!
dprint ("Roland: Spartan Miller!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00100'));
sleep(10);

// Roland : That whole place is going to come down on Crimson's head!
dprint ("Roland: That whole place is going to come down on Crimson's head!");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00101'));
sleep(10);

// Miller : I noticed, Roland.
dprint ("Miller: I noticed, Roland.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00102'));
sleep(10);

// Miller : Crimson!
dprint ("Miller: Crimson!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00103'));
sleep(10);

// Miller : Move! Now!
dprint ("Miller: Move! Now!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00104'));
sleep(10);

// Miller : Get out of there!
dprint ("Miller: Get out of there!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_ceiling_00105'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_gravity()
e10m5_narrative_is_on = TRUE;
// Miller : Roland?! What's happening?
dprint ("Miller: Roland?! What's happening?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00100'));
sleep(10);

// Roland : Localized gravity fluctuations.
dprint ("Roland: Localized gravity fluctuations.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00101'));
sleep(10);

// Roland : Things could be... weird down there, Crimson. Be careful.
dprint ("Roland: Things could be... weird down there, Crimson. Be careful.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00102'));
sleep(10);

// Miller : Gravity’s just gonna get weirder the closer to the sun we get.
dprint ("Miller: Gravity’s just gonna get weirder the closer to the sun we get.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_gravity_00103'));


end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_running_away()
				dprint("Play_mus_pve_e10m5_running_away");
music_set_state('Play_mus_pve_e10m5_running_away');

e10m5_narrative_is_on = FALSE;
// Roland : Why... is everyone running away?
dprint ("Roland: Why... is everyone running away?");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00100'));
sleep(10);

// Miller : Take the hint, I say.
dprint ("Miller: Take the hint, I say.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00101'));
sleep(10);

// Miller : Move, Crimson!
dprint ("Miller: Move, Crimson!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00102'));
sleep(10);

// Miller : Get out of there!
dprint ("Miller: Get out of there!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_running_away_00103'));
sleep(10);

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_zealots()
				dprint("Play_mus_pve_e10m5_zealots");
music_set_state('Play_mus_pve_e10m5_zealots');
e10m5_narrative_is_on = TRUE;
// Miller : Oh, come on! What the hell?!
dprint ("Miller: Oh, come on! What the hell?!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00100'));
sleep(10);

// Roland : Some of the more religiously devout, it seems.
dprint ("Roland: Some of the more religiously devout, it seems.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00101'));
sleep(10);

// Roland : They'll reactivate the artifact if you give them the chance.
dprint ("Roland: They'll reactivate the artifact if you give them the chance.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00102'));
sleep(10);

// Miller : No way!
dprint ("Miller: No way!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00103'));
sleep(10);

// Miller : Take 'em out, Crimson!
dprint ("Miller: Take 'em out, Crimson!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_zealots_00104'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_get_out()
				dprint("Play_mus_pve_e10m5_get_out");
music_set_state('Play_mus_pve_e10m5_get_out');
e10m5_narrative_is_on = TRUE;
// Roland : That's the last of them!
dprint ("Roland: That's the last of them!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00100'));
sleep(10);

// Miller : Where the hell is Murphy?!
dprint ("Miller: Where the hell is Murphy?!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00101'));
sleep(10);

// Dalton : He should be there! Murphy! Come in!
dprint ("Dalton: He should be there! Murphy! Come in!");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00102'));
sleep(10);

thread (spawn_e10m5_outro_pelican());

// Murphy : Settle down!
dprint ("Murphy: Settle down!");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00103'));
sleep(10);

// Murphy : I didn't go nowhere!
dprint ("Murphy: I didn't go nowhere!");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00104'));
sleep(10);

	f_blip_object (v_pelican, default);

// Murphy : Just had to fall back to keep from getting boarded.
dprint ("Murphy: Just had to fall back to keep from getting boarded.");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_get_out_00105'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end


script static void vo_e10m5_dust_off()
e10m5_narrative_is_on = TRUE;
// Murphy : I've got 'em, Miller! We're on our way out!
dprint ("Murphy: I've got 'em, Miller! We're on our way out!");
start_radio_transmission("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_dust_off_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_dust_off_00100'));
sleep(10);

// Miller : Great work, Crimson! Now hurry home!
dprint ("Miller: Great work, Crimson! Now hurry home!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_dust_off_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_05\e10m5_dust_off_00101'));

end_radio_transmission();
e10m5_narrative_is_on = FALSE;
end

// ============================================	MISC SCRIPT	========================================================