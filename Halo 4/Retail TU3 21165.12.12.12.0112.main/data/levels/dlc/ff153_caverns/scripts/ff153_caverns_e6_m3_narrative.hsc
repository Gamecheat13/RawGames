//=============================================================================================================================
//============================================ E6M3 CAVERNS NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_narrative_is_on = FALSE;



// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e6m3_narr_in()
b_narrative_is_on = TRUE;
				dprint("Play_mus_pve_e6m3_narr_in");
			 music_set_state('Play_mus_pve_e6m3_narr_in');
			 
sleep (60);			 
			 
// Palmer : Crimson, the data collected from those Covie computers has tipped us off to a central intel center. I’d like you to poke around.
dprint ("Palmer: Crimson, the data collected from those Covie computers has tipped us off to a central intel center. I’d like you to poke around.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00101'));
sleep(30);

// Murphy : Dropping you at the edge of the base, Crimson. See ya on the other side.
dprint ("Murphy: Dropping you at the edge of the base, Crimson. See ya on the other side.");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00102'));
//sleep(10);

//// Palmer : Miller, get a bead on the intel center.
//dprint ("Palmer: Miller, get a bead on the intel center.");
//cui_hud_show_radio_transmission_hud("palmer_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00103', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00103'));
//sleep(10);
//
//// Miller : Working on it, Commander.
//dprint ("Miller: Working on it, Commander.");
//cui_hud_show_radio_transmission_hud("miller_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00104', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_narr_in_00104'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_take_out()
b_narrative_is_on = TRUE;
// Palmer : Look at that. Little jerks are sleeping on the job. Quick and quiet, Crimson. Get the drop on them.
dprint ("Palmer: Look at that. Little jerks are sleeping on the job. Quick and quiet, Crimson. Get the drop on them.");
start_radio_transmission("palmer_transmission_name");
hud_play_pip_from_tag (levels\dlc\shared\binks\ep6_m3_1_60);
thread (pip_e6m3_takeout_subtitles());
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_take_out_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_take_out_00100'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void pip_e6m3_takeout_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_take_out_00100');
end


script static void vo_e6m3_stealth()
b_narrative_is_on = TRUE;
// Miller : Yeah! They didn't even know what hit them. Good work, Crimson!
dprint ("Miller: Yeah! They didn't even know what hit them. Good work, Crimson!");
start_radio_transmission("miller_transmission_name");

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_stealth_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_stealth_00100'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_airstrike_switch()
b_narrative_is_on = TRUE;
				dprint("Play_mus_pve_e6m3_airstrike_switch");
			 music_set_state('Play_mus_pve_e6m3_airstrike_switch');
// Palmer : Crimson, hitting that switch signaled an airstrike from a Covenant cruiser. Stay indoors. You don't want to be caught dancing in this rain. And maybe don’t just go pressing every single switch you find, yeah?
dprint ("Palmer: Crimson, hitting that switch signaled an airstrike from a Covenant cruiser. Stay indoors. You don't want to be caught dancing in this rain. And maybe don’t just go pressing every single switch you find, yeah?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_airstrike_switch_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_airstrike_switch_00100'));


end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_alarm()
b_narrative_is_on = TRUE;
// Palmer : Looks like we get to do this the old fashioned way, Spartans. Run and gun.
dprint ("Palmer: Looks like we get to do this the old fashioned way, Spartans. Run and gun.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_alarm_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_alarm_00100'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_shielded_path()
b_narrative_is_on = TRUE;
				dprint("Play_mus_pve_e6m3_shielded_path");
			 music_set_state('Play_mus_pve_e6m3_shielded_path');
// Palmer : Crimson, take a look around. There must be a way to bring those shields down.
dprint ("Palmer: Crimson, take a look around. There must be a way to bring those shields down.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_shielded_path_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_shielded_path_00100'));
sleep(10);

// Miller : Commander, there's a terminal along the walls of the structure. Marking it for Crimson.
dprint ("Miller: Commander, there's a terminal along the walls of the structure. Marking it for Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_shielded_path_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_shielded_path_00101'));
sleep(10);

// Palmer : Good find, Miller.
dprint ("Palmer: Good find, Miller.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_shielded_path_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_shielded_path_00102'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_switch_moved()
b_narrative_is_on = TRUE;
// Miller : Commander Palmer, the whole structure is lighting up.
dprint ("Miller: Commander Palmer, the whole structure is lighting up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switch_moved_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switch_moved_00100'));
sleep(10);

// Palmer : Crimson, looks like flipping the switch got you a bit more than you asked for, but I'm sure you can handle it. Stick with the course and find that intel.
dprint ("Palmer: Crimson, looks like flipping the switch got you a bit more than you asked for, but I'm sure you can handle it. Stick with the course and find that intel.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
hud_play_pip_from_tag (levels\dlc\shared\binks\ep6_m3_2_60);
thread (pip_e6m3_switchmoved_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switch_moved_00101'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void pip_e6m3_switchmoved_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switch_moved_00101');
end


script static void vo_e6m3_switch_not_moved()
b_narrative_is_on = TRUE;
// Palmer : Beautiful work, Crimson Should be smooth sailing right to the terminal, right?
dprint ("Palmer: Beautiful work, Crimson Should be smooth sailing right to the terminal, right?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switched_not_moved_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switched_not_moved_00100'));
sleep(10);

// Miller : It'd be nice for a change, yeah.
dprint ("Miller: It'd be nice for a change.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switched_not_moved_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switched_not_moved_00101'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_switch_ambush()
b_narrative_is_on = TRUE;
// Miller : Incoming. Crimson's stirred up the locals.
dprint ("Miller: Incoming. Crimson's stirred up the locals.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switch_ambush_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_switch_ambush_00100'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_secret_path()
b_narrative_is_on = TRUE;
// Palmer : It's quiet. I don't like it when it's quiet.
dprint ("Palmer: It's quiet. I don't like it when it's quiet.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_secret_path_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_secret_path_00100'));


end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_zealots()
b_narrative_is_on = TRUE;
// Miller : There's movement all over the place, but no visual.
dprint ("Miller: There's movement all over the place, but no visual.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_zealots_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_zealots_00100'));
sleep(10);

// Palmer : Active cammo. Keep your guard up, Crimson.
dprint ("Palmer: Active cammo. Keep your guard up, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_zealots_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_zealots_00101'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_near_terminal()
b_narrative_is_on = TRUE;
// Miller : Got a lock on our intel terminal's location!
dprint ("Miller: Got a lock on our intel terminal's location!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00100'));
sleep(10);

// Palmer : Mark it. Crimson, get a look.
dprint ("Palmer: Mark it. Crimson, get a look.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00101'));
sleep(10);

// Palmer : Excellent. Let's see what the Covenant are up to.
dprint ("Palmer: Excellent. Let's see what the Covenant are up to.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00102'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_near_terminal_close()
b_narrative_is_on = TRUE;

// Palmer : Excellent. Let's see what the Covenant are up to.
dprint ("Palmer: Excellent. Let's see what the Covenant are up to.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_near_terminal_00102'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end

script static void vo_e6m3_soundstory()
b_narrative_is_on = TRUE;
				dprint("Play_mus_pve_e6m3_soundstory");
			 music_set_state('Play_mus_pve_e6m3_soundstory');
			 hud_play_pip_from_tag (levels\dlc\shared\binks\SP_G01_60);
			 
// Miller : Extracting intelligence, Commander.
dprint ("Miller: Extracting intelligence, Commander.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_soundstory_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_soundstory_00100'));
sleep(10);

// Palmer : Excellent. Run it through translation and give me the highlights. Crimson, time to catch your ride out of there.
dprint ("Palmer: Excellent. Run it through translation and give me the highlights. Crimson, time to catch your ride out of there.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_soundstory_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_soundstory_00101'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_fight_out()
b_narrative_is_on = TRUE;
// Palmer : Apparently the Covies aren't too pleased we stole their secrets, Crimson. They're not going to make this easy for you.
dprint ("Palmer: Apparently the Covies aren't too pleased we stole their secrets, Crimson. They're not going to make this easy for you.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_out_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_out_00100'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_fight_waves()
b_narrative_is_on = TRUE;
				dprint("Play_mus_pve_e6m3_fight_waves");
			 music_set_state('Play_mus_pve_e6m3_fight_waves');
// Palmer : Doing good, Crimson. What have we got, Miller?
dprint ("Palmer: Doing good, Crimson. What have we got, Miller?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00100'));
sleep(10);

// Miller : Covenant are engaged in an archeological dig…
dprint ("Miller: Covenant are engaged in an archeological dig…");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00101'));
sleep(10);

// Palmer : We have got to get these guys a new hobby.
dprint ("Palmer: We have got to get these guys a new hobby.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00102'));
sleep(10);

// Miller : Fireteam Switchback is available to investigate.
dprint ("Miller: Fireteam Switchback is available to investigate.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00103'));
sleep(10);

// Palmer : Contact Switchback's Operator. Let them know I want eyes on that dig.
dprint ("Palmer: Contact Switchback's Operator. Let them know I want eyes on that dig.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00104'));
sleep(10);

// Miller : Consider it done.
dprint ("Miller: Consider it done.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00105'));


end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_exfil()
b_narrative_is_on = TRUE;

sleep(10);

// Miller : Commander? There's something else coming down the translator pipe. A Covie supply depot very close to Crimson's position.
dprint ("Miller: Commander? There's something else coming down the translator pipe. A Covie supply depot very close to Crimson's position.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_fight_waves_00106'));
sleep(10);
// Palmer : Murphy, we're going to borrow a little more of your time.
dprint ("Palmer: Lieutenant Murphy, we're going to borrow a little more of your time.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_exfil_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_exfil_00100'));
sleep(10);

// Murphy : Happy to help, Commander Palmer. I can pick up Crimson just as soon as they've cleared me a landing spot.
dprint ("Murphy: Happy to oblige, Commander Palmer. I can pick up Crimson just as soon as they've cleared me a landing spot.");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_exfil_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_exfil_00101'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void vo_e6m3_pickup()
b_narrative_is_on = TRUE;
				dprint("Play_mus_pve_e6m3_pickup");
			 music_set_state('Play_mus_pve_e6m3_pickup');
// Murphy : Comin' in for you, Crimson!
dprint ("Murphy: Comin' in for you, Crimson!");
start_radio_transmission("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_pickup_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_pickup_00100'));
sleep(10);

// Palmer : Good work, everyone. Murphy, set a course for the supply depot. Crimson, reload and ready up. This day's not over yet.
dprint ("Palmer: Good work, everyone. Murphy, set a course for the supply depot. Crimson, reload and ready up. This day's not over yet.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
hud_play_pip_from_tag (levels\dlc\shared\binks\ep6_m3_3_60);
thread (pip_e6m3_pickup_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_pickup_00101'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end


script static void pip_e6m3_pickup_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_pickup_00101');
end


script static void vo_e6m3_doorwaychatter_01()
b_narrative_is_on = TRUE;
				

		// Miller : Head for the door, Crimson.
		dprint ("Miller: Head for the door, Crimson.");
		start_radio_transmission("miller_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00100', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00100'));
		

end_radio_transmission();
b_narrative_is_on = FALSE;
end

script static void vo_e6m3_doorwaychatter_02()
b_narrative_is_on = TRUE;

		// Miller : Looks like it isn't opening... Have a look around. There has to be another way in.
		dprint ("Miller: Looks like it isn't opening... Have a look around. There has to be another way in.");
		start_radio_transmission("miller_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00101', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00101'));
		

end_radio_transmission();
b_narrative_is_on = FALSE;
end

script static void vo_e6m3_doorwaychatter_03()
b_narrative_is_on = TRUE;

		// Miller : Path's blocked here. Check that console. I'll see if there's a way to bring that barrier down.
		dprint ("Miller: Path's blocked here. Check that console. I'll see if there's a way to bring that barrier down.");
		start_radio_transmission("miller_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00103', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00103'));
		

end_radio_transmission();
b_narrative_is_on = FALSE;
end

script static void vo_e6m3_doorwaychatter_04()
b_narrative_is_on = TRUE;

		// Miller : Sorry, Crimson. Still working on it...
		dprint ("Miller: Sorry, Crimson. Still working on it...");
		start_radio_transmission("miller_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00104', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00104'));
		

end_radio_transmission();
b_narrative_is_on = FALSE;
end

script static void vo_e6m3_doorwaychatter_05()
b_narrative_is_on = TRUE;

		// Miller : That should do it. Barrier's down!
		dprint ("Miller: That should do it. Barrier's down!");
		start_radio_transmission("miller_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00105', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_doorwaychatter_00105'));
		

end_radio_transmission();
b_narrative_is_on = FALSE;
end

script static void vo_e6m3_lightbridgegonow()
b_narrative_is_on = TRUE;

		// Miller : Crimson, there's a control panel here. Looks like it's rigged into a Forerunner light bridge system.
		dprint ("Miller: Crimson, there's a control panel here. Looks like it's rigged into a Forerunner light bridge system.");
		start_radio_transmission("miller_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_lightbridgegonow_00100', NONE, 1);
		sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_lightbridgegonow_00100'));
		

end_radio_transmission();
b_narrative_is_on = FALSE;
end





// ============================================	MISC SCRIPT	========================================================

script static void vo_e6m3_addl()
b_narrative_is_on = TRUE;
// Miller : Crimson, I think I’ve found you another way inside. Making it now.
dprint ("Miller: Crimson, I think I’ve found you another way inside. Making it now.");
start_radio_transmission("miller_transmission_name");

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_addl_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_03\e06m3_addl_00100'));

end_radio_transmission();
b_narrative_is_on = FALSE;
end

