//=============================================================================================================================
//============================================ E8M5 MEZZANINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e8m5_narrative_is_on = FALSE;
global boolean b_scan_1 = FALSE;
global boolean b_blip_loc_1 = FALSE;
global boolean b_scan_loc_2 = FALSE;
global boolean b_blip_cover = FALSE;
global boolean b_blip_turrets = FALSE;
global boolean b_blip_weapons = FALSE;
global boolean b_turret_narr = FALSE;
global boolean b_weapon_narr = FALSE;
global boolean b_blip_aa1 = FALSE;
global boolean b_blip_aa2 = FALSE;
global boolean b_aa1_narr = FALSE;
global boolean b_aa2_narr = FALSE;
global boolean b_entered_scan_1 = FALSE;
global boolean b_first_weapons_in = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e8m5_narrative_in()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_narrative_in");
music_set_state('Play_mus_pve_e08m5_narrative_in');

sleep (200);

// Thorne : Commander Palmer, Majestic here.
dprint ("Thorne: Commander Palmer, Majestic here.");
start_radio_transmission("thorne_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_in_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_in_00100'));
sleep(10);

/*// Palmer : Go ahead, Thorne.
dprint ("Palmer: Go ahead, Thorne.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_in_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_in_00101'));
sleep(10);*/

// Thorne : Doctor Glassman's got a favor to ask. Roland says Crimson's in a place to help.
dprint ("Thorne: Doctor Glassman's got a favor to ask. Roland says Crimson's in a place to help.");
cui_hud_show_radio_transmission_hud("thorne_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_in_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_in_00102'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_first_location()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_first_location");
music_set_state('Play_mus_pve_e08m5_first_location');

/*// Palmer : Oh, this should be interesting. What is it, Doc?
dprint ("Palmer: Oh, this should be interesting. What is it, Doc?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00100'));
sleep(10);
*/
// Glassman : Spartan Thorne found a Covenant map... I think I can read it, but--
dprint ("Glassman: Spartan Thorne found a Covenant map... I think I can read it, but--");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00101'));
sleep(-10);

// Thorne : Doctor Glassman wants to know if Crimson can take a look for him?
dprint ("Thorne: Doctor Glassman wants to know if Crimson can take a look for him?");
cui_hud_show_radio_transmission_hud("thorne_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00102'));
sleep(10);

// Palmer : Sure. Why not.
dprint ("Palmer: Sure. Why not.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00103'));
sleep(10);

// Thorne : Location’s right here, Commander.
dprint ("Thorne: Location’s right here, Commander.");
cui_hud_show_radio_transmission_hud("thorne_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00103a', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00103a'));
b_blip_loc_1 = TRUE;
sleep(10);

// Glassman : If I'm reading this map right, that location should be a hub for energy flowing through a forerunner structure.
dprint ("Glassman: If I'm reading this map right, that location should be a hub for energy flowing through a forerunner structure.");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00104'));
end_radio_transmission();
sleep(10);

b_e8m5_narrative_is_on = FALSE;
sleep_until(b_entered_scan_1 == TRUE, 1);
b_e8m5_narrative_is_on = TRUE;

// Miller : I'll run a survey through Crimson's armor sensors. Just a moment.
dprint ("Miller: I'll run a survey through Crimson's armor sensors. Just a moment.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_first_location_00105'));
hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G08_60" );
b_scan_1 = TRUE;

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_suit_scans()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_suit_scans");
music_set_state('Play_mus_pve_e08m5_suit_scans');

// Miller : It checks out, Doctor Glassman.
dprint ("Miller: It checks out, Doctor Glassman.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00100'));
sleep(10);

// Palmer : Okay. So what have we proved?
dprint ("Palmer: Okay. So what have we proved?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00101'));
sleep(10);

// Glassman : Nothing yet. Science requires more than one piece of evidence. Spartan Thorne, can you show them this location?
dprint ("Glassman: Nothing yet. Science requires more than one piece of evidence. Spartan Thorne, can you show them this location?");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00102'));
sleep(10);

// Thorne : Sure thing, Doctor.
dprint ("Thorne: Sure thing, Doctor.");
cui_hud_show_radio_transmission_hud("thorne_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_suit_scans_00103'));
sleep(10);

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_second_location()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_second_location");
music_set_state('Play_mus_pve_e08m5_second_location');

// Glassman : Commander Palmer, can we get another reading at Crimson's new location?
dprint ("Glassman: Commander Palmer, can we get another reading at Crimson's new location?");
start_radio_transmission("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_second_location_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_second_location_00100'));
sleep(10);

// Palmer : Miller.
dprint ("Palmer: Miller.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_second_location_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_second_location_00101'));
sleep(10);

// Miller : Same as before Commander.
dprint ("Miller: Same as before Commander.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_second_location_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_second_location_00102'));
b_scan_loc_2 = TRUE;

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_scout_ships()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_scout_ships");
music_set_state('Play_mus_pve_e08m5_scout_ships');
//hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G04_60" );
// Miller : Covenant craft inbound!
dprint ("Miller: Covenant craft inbound!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_scout_ships_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_scout_ships_00100'));
sleep(10);

// Palmer : Crimson, deal with them. We'll play scientist when you're done.
dprint ("Palmer: Crimson, deal with them. We'll play scientist when you're done.");
start_radio_transmission("palmer_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep8_m5_1_60" );
thread (pip_e8m5_scoutships_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_pip_on_00100'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e8m5_scoutships_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_pip_on_00100');
end


script static void vo_e8m5_pip_on()

dprint("deprecated");

end


script static void vo_e8m5_combat_complete()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_combat_complete");
music_set_state('Play_mus_pve_e08m5_combat_complete');

// Miller : Good work, Crimson.
dprint ("Miller: Good work, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_combat_complete_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_combat_complete_00100'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_two_machines()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_two_machines");
music_set_state('Play_mus_pve_e08m5_two_machines');

// Glassman : Did two massive beams of light just appear near Crimson's position?
dprint ("Glassman: Did two massive beams of light just appear near Crimson's position?");
start_radio_transmission("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00100'));
sleep(10);

// Miller : Yes. Why?
dprint ("Miller: Yes. Why?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00101'));
sleep(10);

// Glassman : Oh this is really amazing. I mean, as advanced as we are, our maps have got nothing on this thing.
dprint ("Glassman: Oh this is really amazing. I mean, as advanced as we are, our maps have got nothing on this thing.");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00102'));
sleep(10);

// Palmer : Doctor, what's the point? What are we doing?
dprint ("Palmer: Doctor, what's the point? What are we doing?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00103'));
sleep(10);

// Glassman : I'm making sure I can read this map correctly so that maybe, if we're lucky, I can get Infinity free of Requiem.
dprint ("Glassman: I'm making sure I can read this map correctly so that maybe, if we're lucky, I can get Infinity free of Requiem.");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_two_machines_00104'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_location()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_location");
music_set_state('Play_mus_pve_e08m5_location');

// Glassman : If it's getting a little hot down there, and if I'm reading tis right, which I think I am, activating this location will give you some respite.
dprint ("Glassman: If it's getting a little hot down there, and if I'm reading tis right, which I think I am, activating this location will give you some respite.");
start_radio_transmission("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00100'));
b_blip_cover = TRUE;
end_radio_transmission();
sleep(10);

// Miller : Right again, Doc.
b_e8m5_narrative_is_on = FALSE;
sleep_until(b_cover_narr == TRUE, 1);
sleep_until(global_narrative_is_on == FALSE, 1);
b_e8m5_narrative_is_on = TRUE;

dprint ("Miller: Right again, Doc.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00101'));
end_radio_transmission();
sleep(10);

// Glassman : Good, good... Thorne, can you show them this location? It will activate a turret defense system. I think.
b_e8m5_narrative_is_on = FALSE;
sleep_until(b_turret_narr == TRUE, 1);
b_e8m5_narrative_is_on = TRUE;

dprint ("Glassman: Good, good... Thorne, can you show them this location? It will activate a turret defense system. I think.");
start_radio_transmission("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00102'));
b_blip_turrets = TRUE;
end_radio_transmission();
sleep(10);

// Palmer : Hell of a magic trick, Doc.
b_e8m5_narrative_is_on = FALSE;
sleep_until(b_weapon_narr == TRUE);
b_e8m5_narrative_is_on = TRUE;

dprint ("Palmer: Hell of a magic trick, Doc.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00103'));
sleep(10);

// Glassman : You want magic tricks? How's this? Thorne, show Commander Palmer these locations.

dprint ("Glassman: You want magic tricks? How's this? Thorne, show Commander Palmer these locations.");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00104'));
b_blip_weapons = TRUE;
end_radio_transmission();
sleep(10);

// Thorne : Heavy weapons?

b_e8m5_narrative_is_on = FALSE;
sleep_until(b_first_weapons_in == TRUE, 1);
b_e8m5_narrative_is_on = TRUE;

dprint ("Thorne: Heavy weapons?");
start_radio_transmission("thorne_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00105'));
sleep(10);

// Glassman : Pretty great, huh?
dprint ("Glassman: Pretty great, huh?");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00106'));
sleep(10);
end_radio_transmission();

b_e8m5_narrative_is_on = FALSE;
sleep_until(b_loc_6_done == TRUE, 1);
b_e8m5_narrative_is_on = TRUE;

// Palmer : Yes... I'm starting to see the usefulness. What else have you got?
dprint ("Palmer: Yes... I'm starting to see the usefulness. What else have you got?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00107', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00107'));
end_radio_transmission();
sleep(10);

// Glassman : Let's see... How about an anti-aircraft gun?
b_e8m5_narrative_is_on = FALSE;
sleep_until(b_aa1_narr == TRUE);
b_e8m5_narrative_is_on = TRUE;

// Palmer : What else have you got?
dprint ("Palmer: What else have you got?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00111', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00111'));
end_radio_transmission();
sleep(10);


dprint ("Glassman: Let's see... How about an anti-aircraft gun?");
start_radio_transmission("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00108', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00108'));
b_blip_aa1 = TRUE;
end_radio_transmission();
sleep(10);

// Miller : This map’s checking out nicely, Doctor Glassman.
b_e8m5_narrative_is_on = FALSE;
sleep_until(b_aa2_narr == TRUE, 1);
b_e8m5_narrative_is_on = TRUE;

dprint ("Miller: This map’s checking out nicely, Doctor Glassman.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00109', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00109'));
sleep(10);

// Glassman : And it's got a twin. I know how you Spartans like to blow things up.

dprint ("Glassman: And it's got a twin. I know how you Spartans like to blow things up.");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00110', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_location_00110'));
b_blip_aa2 = TRUE;

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_locations_activated()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_locations_activated");
music_set_state('Play_mus_pve_e08m5_locations_activated');

// Palmer : Doc, you're five for five. I'm cutting the science short for today.
dprint ("Palmer: Doc, you're five for five. I'm cutting the science short for today.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_locations_activated_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_locations_activated_00100'));
sleep(10);

// Glassman : Understood.
dprint ("Glassman: Understood.");
cui_hud_show_radio_transmission_hud("glassman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_locations_activated_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_locations_activated_00101'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_take_down()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_take_down");
music_set_state('Play_mus_pve_e08m5_take_down');

// Miller : Phantoms down! The AA guns shot them out of the sky!
dprint ("Miller: Phantoms down! The AA guns shot them out of the sky!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_take_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_take_down_00100'));
sleep(10);

// Palmer : Crimson, clean up the garbage they dropped, and you're in the clear.
dprint ("Palmer: Crimson, clean up the garbage they dropped, and you're in the clear.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_take_down_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_take_down_00101'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_clear_base()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_clear_base");
music_set_state('Play_mus_pve_e08m5_clear_base');

// Miller : Secure the base, Crimson.
dprint ("Miller: Secure the base, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_clear_base_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_clear_base_00100'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_covenant_left()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_covenant_left");
music_set_state('Play_mus_pve_e08m5_covenant_left');

// Miller : Almost done. Just a few stragglers.
dprint ("Miller: Almost done. Just a few stragglers.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_covenant_left_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_covenant_left_00100'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e8m5_turrets_operational()

b_e8m5_narrative_is_on = TRUE;

// Miller : All turrets operational.
dprint ("Miller: All turrets operational.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\e3m4_turret3online_00100'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_board_pelican()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_board_pelican");
music_set_state('Play_mus_pve_e08m5_board_pelican');

// Miller : All clear. Fall out to the LZ and come on home.
dprint ("Miller: All clear. Fall out to the LZ and come on home.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_board_pelican_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_board_pelican_00100'));

b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m5_narrative_out()

b_e8m5_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m5_narrative_out");
music_set_state('Play_mus_pve_e08m5_narrative_out');

// Palmer : Nice work today, Crimson. I’ll get you the ribbons for your science fair projects when you're back on Infinity.
dprint ("Palmer: Nice work today, Crimson. I’ll get you the ribbons for your science fair projects when you're back on Infinity.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_out_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_05\e08m5_narrative_out_00100'));
print("I'm done talking");
b_e8m5_narrative_is_on = FALSE;
end_radio_transmission();

end

// ============================================	MISC SCRIPT	========================================================