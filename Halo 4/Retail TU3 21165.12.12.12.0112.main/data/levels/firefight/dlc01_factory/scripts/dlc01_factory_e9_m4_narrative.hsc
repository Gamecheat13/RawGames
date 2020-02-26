//=============================================================================================================================
//============================================ E9M4 FACTORY NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

//global boolean b_e9m4_narrative_is_on = FALSE;  // declared in Main scenario mission script file

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================



// ============================================	MISC SCRIPT	========================================================

script static void vo_e9m4_narrative_in()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;
//dprint("Play_mus_pve_e09m4_narr_in");
//music_set_state('Play_mus_pve_e09m4_narr_in');


// Palmer : Miller, I'm in the field, but you've got this?
dprint ("Palmer: Miller, I'm in the field, but you've got this?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_narr_in_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_narr_in_00100'));
sleep(10);


// Miller : We're not leaving here until the UNSC owns this place.
dprint ("Miller: We're not leaving here until the UNSC owns this place.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_narr_in_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_narr_in_00102'));
sleep(10);

// Miller: Roland, what about our trace on the Halsey comms?
dprint ("Miller: Roland, what about our trace on the Halsey comms?.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00200'));
sleep(10);

// Roland: Working on it
dprint ("Roland: Working on it");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00101'));


end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_secure_area()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;


// Miller : Unleash hell, Crimson.
dprint ("Miller: Unleash hell, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_secure_area_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_secure_area_00100'));


end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_surprise()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : Crimson! Movement!
dprint ("Miller: Crimson! Movement!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_surprise_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_surprise_00100'));


end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_ghosts()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;


// Miller : Watch out for the Ghosts, Crimson.
dprint ("Miller: Watch out for the Ghosts, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_ghosts_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_ghosts_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_clear_donut()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : We're keeping this march going, Crimson. Secure the area.
dprint ("Miller: We're keeping this march going, Crimson. Secure the area.");
start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep9_m4_1_60" );
thread (pip_e9m4_cleardonut_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_clear_donut_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end


script static void pip_e9m4_cleardonut_subtitles()
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_clear_donut_00100');
end


script static void vo_e9m4_marine_iff()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m4_marine_iff");
//music_set_state('Play_mus_pve_e09m4_marine_iff');


// Dalton : Miller?
dprint ("Dalton: Miller?");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00100'));
sleep(10);

// Miller : Go ahead, Dalton.
dprint ("Miller: Go ahead, Dalton.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00101'));
sleep(10);

// Dalton : One of my pilots just picked up a half dozen Marine IFF tags. Weak signal, but worth investigating.
dprint ("Dalton: One of my pilots just picked up a half dozen Marine IFF tags. Weak signal, but worth investigating.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00102'));
sleep(10);

// Miller : Agreed. Thanks, Dalton.
dprint ("Miller: Agreed. Thanks, Dalton.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00103'));
sleep(10);

// Miller : Crimson, passing the waypoint along to you now.
dprint ("Miller: Crimson, passing the waypoint along to you now.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_iff_00104'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_more_ghosts()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : Watch out, Crimson. More Ghosts.
dprint ("Miller: Watch out, Crimson. More Ghosts.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_more_ghosts_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_more_ghosts_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_wraiths()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : There's the IFF tags... but there's no Marines here.
dprint ("Miller: There's the IFF tags... but there's no Marines here.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_wraiths_appear()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m4_wraiths_appearn");
//music_set_state('Play_mus_pve_e09m4_wraiths_appear');

// Miller : Dammit! This was a trap!
dprint ("Miller: Dammit! This was a trap!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00100'));
sleep(10);

// Miller : Dalton.
dprint ("Miller: Dalton.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_dalton_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_dalton_01'));

// Dalton : Pelican's on station but that LZ's too hot.
dprint ("Dalton: Pelican's on station but that LZ's too hot.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_02'));

// Miller : Crimson.
dprint ("Miller: Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crimson_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crimson_01'));

thread(vo_glo15_miller_few_more_04());  // Miller : Neutralize all targets.

// NO WRAITHS AT START. HAVE TO HACK IN OTHER LINES TO MAKE THIS WORK
/*
// Miller : Crimson, deal with those Wraiths! Dalton, we need reenforcements.
dprint ("Miller: Crimson, deal with those Wraiths! Dalton, we need reenforcements.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00101'));
sleep(10);

// Dalton : Love to. But I need Crimson to clear a landing space-
dprint ("Dalton: Love to. But I need Crimson to clear a landing space-");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00102'));
sleep(10);

// Miller : They're working on it. Keep your Pelicans on station.
dprint ("Miller: They're working on it. Keep your Pelicans on station.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_wraiths_appear_00103'));
*/
end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_one_down()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : That's one Wraith down!
dprint ("Miller: That's one Wraith down!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_one_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_one_down_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_another_down()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : Great! Keep it up, Crimson!
dprint ("Miller: Great! Keep it up, Crimson!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_another_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_another_down_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_more_down()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : There's another one!
dprint ("Miller: There's another one!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_more_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_more_down_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_more_down_02()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : Yes! Another Wraith down!
dprint ("Miller: Yes! Another Wraith down!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_more_down_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_more_down_00101'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_one_to_go()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

// Miller : One Wraith to go. Dalton, get your people in position!
dprint ("Miller: One Wraith to go. Dalton, get your people in position!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_one_to_go_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_one_to_go_00100'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end

script static void vo_e9m4_area_secured()
sleep_until(b_e9m4_narrative_is_on == FALSE,1);
b_e9m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m4_area_secured");
//music_set_state('Play_mus_pve_e09m4_area_secured');


// Miller : Well done, Crimson! All clear to land, Dalton.
dprint ("Miller: Well done, Crimson! All clear to land, Dalton.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00100'));
sleep(10);

// Dalton : You got it. Thanks much, Crimson. I -- uh oh.
dprint ("Dalton: You got it. Thanks much, Crimson. I -- uh oh.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00101'));
sleep(10);

// Miller : What is it?
dprint ("Miller: What is it?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00102'));
sleep(10);

// Dalton : Covie air traffic. Lots of it, inbound on Crimson's position.
dprint ("Dalton: Covie air traffic. Lots of it, inbound on Crimson's position.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00103'));
sleep(10);

// Miller : I see it. Crimson, we're not done here yet. Prep to resist invasion.
dprint ("Miller: I see it. Crimson, we're not done here yet. Prep to resist invasion.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_04\e09m4_area_secured_00104'));

end_radio_transmission();
b_e9m4_narrative_is_on = FALSE;
end
