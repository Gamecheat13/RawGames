//=============================================================================================================================
//============================================ E6M4 VORTEX NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e6m4_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e6m4_exterior_vortex()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_exterior_vortex");
music_set_state('Play_mus_pve_e06m4_exterior_vortex');

// Palmer : Fireteam Switchback, you're on Covenant dig detail. Miller's sending you the coordinates now.
dprint ("Palmer: Fireteam Switchback, you're on Covenant dig detail. Miller's sending you the coordinates now.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_exterior_vortex_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_exterior_vortex_00100'));
sleep(10);

// Switchback Leader (Female) : Acknowledged, Commander.
dprint ("Switchback Leader (Female): Acknowledged, Commander.");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_switchback_female");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_exterior_vortex_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_exterior_vortex_00101'));
sleep(10);

// Palmer : Crimson, your job is to take out this Covie munitions depot. Lots of explosions. Should be good fun.
dprint ("Palmer: Crimson, your job is to take out this Covie munitions depot. Lots of explosions. Should be good fun.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_exterior_vortex_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_exterior_vortex_00102'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_lifts_off()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_lifts_off");
music_set_state('Play_mus_pve_e06m4_lifts_off');

// Miller : Murphy, you gonna be okay up there?
dprint ("Miller: Murphy, you gonna be okay up there?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_lifts_off_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_lifts_off_00100'));
sleep(10);

// Murphy : Aw, yeah. I'm having fun here! More than enough flak to go around.
dprint ("Murphy: Aw, yeah. I'm having fun here! More than enough flak to go around.");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_lifts_off_001001', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_lifts_off_001001'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_bad_guys()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_bad_guys");
music_set_state('Play_mus_pve_e06m4_bad_guys');

// Palmer : Contact! Get to cover, Crimson.
dprint ("Palmer: Contact! Get to cover, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_bad_guys_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_bad_guys_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_take_hill_2()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_take_hill_2");
music_set_state('Play_mus_pve_e06m4_take_hill_2');

// Palmer : Crimson, you can take that hill. Get to it.
dprint ("Palmer: Crimson, you can take that hill. Get to it.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_take_hill_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_take_hill_00100'));
sleep(10);

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m4_take_hill()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_take_hill");
music_set_state('Play_mus_pve_e06m4_take_hill');

// Miller : First munitions depot located and marked.
dprint ("Miller: First munitions depot located and marked.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_take_hill_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_take_hill_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_destroy_thing()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_destroy_thing");
music_set_state('Play_mus_pve_e06m4_destroy_thing');

// Miller : Be advised, Crimson, the plasma in those caches is volatile stuff. Give it a nudge, and it'll blow.
dprint ("Miller: Be advised, Crimson, the plasma in those caches is volatile stuff. Give it a nudge, and it'll blow.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_pat_on_head()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_pat_on_head");
music_set_state('Play_mus_pve_e06m4_pat_on_head');

// Palmer : Not exactly subtle, Crimson, but you get the job done. Now let's do it a few more times.
dprint ("Palmer: Not exactly subtle, Crimson, but you get the job done. Now let's do it a few more times.");
start_radio_transmission("palmer_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep6_m4_1_60" );
thread (pip_e6m4_patonhead_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_pat_on_head_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e6m4_patonhead_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_pat_on_head_00100');
end


script static void vo_e6m4_unsc_gear()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_unsc_gear");
music_set_state('Play_mus_pve_e06m4_unsc_gear');

// Miller : Commander, there's UNSC inventory transponders near Crimson's position.
dprint ("Miller: Commander, there's UNSC inventory transponders near Crimson's position.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_unsc_gear_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_unsc_gear_00100'));
sleep(10);

// Palmer : Really? Let's take a look.
dprint ("Palmer: Really? Let's take a look.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_unsc_gear_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_unsc_gear_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_to_cave()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_to_cave");
music_set_state('Play_mus_pve_e06m4_to_cave');
/*
// Miller : Yep. That's UNSC gear alright. Stuff down there tagged for distribution to Marines, Army… there's even some Spartan gear.
dprint ("Miller: Yep. That's UNSC gear alright. Stuff down there tagged for distribution to Marines, Army… there's even some Spartan gear.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00100'));
sleep(10);
*/
// Palmer : Crimson, I'd appreciate if you taught the Covies that our toys don't belong to them.
dprint ("Palmer: Crimson, I'd appreciate if you taught the Covies that our toys don't belong to them.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m4_to_cave_2()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_to_cave");
music_set_state('Play_mus_pve_e06m4_to_cave');

// Miller : Commander, the crate manifests are showing lots of weapons unaccounted for.
dprint ("Miller: Commander, the crate manifests are showing lots of weapons unaccounted for.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100'));
sleep(10);

// Miller : Might be worth having a look around that central structure, and see if anything’s stored there.
dprint ("Miller: Might be worth having a look around that central structure, and see if anything’s stored there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100_1', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100_1'));
//sleep(10);
/*
// Palmer : Crimson, I'd appreciate if you taught the Covies that our toys don't belong to them.
dprint ("Palmer: Crimson, I'd appreciate if you taught the Covies that our toys don't belong to them.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00101'));
*/
b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_to_cave_3()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_to_cave");
music_set_state('Play_mus_pve_e06m4_to_cave');

// Miller : Yep. That's UNSC gear alright. Stuff down there tagged for distribution to Marines, Army… there's even some Spartan gear.
dprint ("Miller: Yep. That's UNSC gear alright. Stuff down there tagged for distribution to Marines, Army… there's even some Spartan gear.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00100'));
sleep(10);
/*
// Palmer : Crimson, I'd appreciate if you taught the Covies that our toys don't belong to them.
dprint ("Palmer: Crimson, I'd appreciate if you taught the Covies that our toys don't belong to them.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_to_cave_00101'));
*/
b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_hostiles_cleared()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_hostiles_cleared");
music_set_state('Play_mus_pve_e06m4_hostiles_cleared');

// Palmer : Let's get a proper inventory, then we'll scuttle this batch.
dprint ("Palmer: Let's get a proper inventory, then we'll scuttle this batch.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_hostiles_cleared_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_hostiles_cleared_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_get_scan()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_get_scan");
music_set_state('Play_mus_pve_e06m4_get_scan');
hud_play_pip_from_tag (levels\dlc\shared\binks\SP_G08_60);
// Miller : Crimson, stand near the crates so I can use your armor's sensors to collect data.
dprint ("Miller: Crimson, stand near the crates so I can use your armor's sensors to collect data.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_get_scan_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_get_scan_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_if_player_leaves()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_if_player_leaves");
music_set_state('Play_mus_pve_e06m4_if_player_leaves');

// Miller : Crimson, stop moving around so much. You're screwing up the scans.
dprint ("Miller: Crimson, stop moving around so much. You're screwing up the scans.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_if_player_leaves_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_if_player_leaves_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_central_structure()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_central_structure");
music_set_state('Play_mus_pve_e06m4_central_structure');

// Miller : Commander, the crate manifests list lots of weapons unaccounted for.
dprint ("Miller: Commander, the crate manifests list lots of weapons unaccounted for.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100'));
sleep(10);


// Palmer : Might be worth having a look around that central structure, and see if anything's stored there.
dprint ("Palmer: Might be worth having a look around that central structure, and see if anything's stored there.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100_1', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00100_1'));
sleep(10);

/*// Palmer : Let's go, Crimson.
dprint ("Palmer: Let's go, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_05'));

*/

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m4_central_structure_2()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_central_structure_2");
music_set_state('Play_mus_pve_e06m4_central_structure');

// Miller : Locked up tight, but I've ID'd another munitions pile. Marking it for you now.
dprint ("Miller: Locked up tight, but I've ID'd another munitions pile. Marking it for you now.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_central_structure_00103'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m4_destroy_thing_1()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_destroy_thing_1");
music_set_state('Play_mus_pve_e06m4_destroy_thing_1');

// Miller : There's the next munitions pile. Same as before, Crimson
dprint ("Miller: There's the next munitions pile. Same as before, Crimson");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_thing_destroyed_1()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_thing_destroyed_1");
music_set_state('Play_mus_pve_e06m4_thing_destroyed_1');

// Dalton : Commander? Dalton here. There's a lot of air traffic near Crimson's location. But it's headed away.
dprint ("Dalton: Commander? Dalton here. There's a lot of air traffic near Crimson's location. But it's headed away.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00100'));
sleep(10);

// Palmer : I see we've put the fear of Spartans into them. Keep it up, Crimson.
dprint ("Palmer: I see we've put the fear of Spartans into them. Keep it up, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_destroy_thing_2()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_destroy_thing_2");
music_set_state('Play_mus_pve_e06m4_destroy_thing_2');

// Miller : Marking the next munitions pile for you.
dprint ("Miller: Marking the next munitions pile for you.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00102'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_thing_destroyed_2()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_thing_destroyed_2");
music_set_state('Play_mus_pve_e06m4_thing_destroyed_2');

// Miller : Perfect. There's one more pile in the open. I'll mark the waypoint now.
dprint ("Miller: Perfect. There's one more pile in the open. I'll mark the waypoint now.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00102'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_destroy_thing_3()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_destroy_thing_3");
music_set_state('Play_mus_pve_e06m4_destroy_thing_3');

// Miller : There's the last of the munitions, Crimson. Light it up.
dprint ("Miller: There's the last of the munitions, Crimson. Light it up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_destroy_thing_00103'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_thing_destroyed_3()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_thing_destroyed_3");
music_set_state('Play_mus_pve_e06m4_thing_destroyed_3');

// Miller : That's all of the munitions caches. At least, out in the open.
dprint ("Miller: That's all of the munitions caches. At least, out in the open.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00103'));
sleep(10);

// Palmer : Excellent job, everyone.
dprint ("Palmer: Excellent job, everyone.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_thing_destroyed_00104'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m4_bad_guys_remaining()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_bad_guys_remaining");
music_set_state('Play_mus_pve_e06m4_bad_guys_remaining');

// Palmer : Miller, dust up the last of the ground forces, then let's see if they've hidden anything inside that central structure.
dprint ("Palmer: Miller, dust up the last of the ground forces, then let's see if they've hidden anything inside that central structure.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_bad_guys_remaining_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_bad_guys_remaining_00100'));
sleep(10);

// Miller : You got it, Commander.
dprint ("Miller: You got it, Commander.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_bad_guys_remaining_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_bad_guys_remaining_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_no_bad_guys()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_no_bad_guys");
music_set_state('Play_mus_pve_e06m4_no_bad_guys');

// Palmer : Miller, let's see if they've hidden anything inside that central structure.
dprint ("Palmer: Miller, let's see if they've hidden anything inside that central structure.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_no_bad_guys_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_no_bad_guys_00100'));
sleep(10);

// Miller : You got it, Commander.
dprint ("Miller: You got it, Commander.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_no_bad_guys_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_no_bad_guys_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_structure_opening()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_structure_opening");
music_set_state('Play_mus_pve_e06m4_structure_opening');

// Miller : There's movement.
dprint ("Miller: There's movement.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_structure_opening_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_structure_opening_00100'));
sleep(10);

// Palmer : Careful, Crimson.
dprint ("Palmer: Careful, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_04'));

/*
// Palmer : Be ready, Crimson.
dprint ("Palmer: Be ready, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_structure_opening_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_structure_opening_00101'));
*/
b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_clear_structure()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_clear_structure");
music_set_state('Play_mus_pve_e06m4_clear_structure');

// Palmer : Clear antying in your way, Spartans.
dprint ("Palmer: Clear antying in your way, Spartans.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_clear_structure_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_clear_structure_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_interface()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_interface");
music_set_state('Play_mus_pve_e06m4_interface');

// Palmer : Have a look around. There has to be some way to open this tin can up.
dprint ("Palmer: Have a look around. There has to be some way to open this tin can up.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_interface_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_interface_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_terminal_accessed()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_terminal_accessed");
music_set_state('Play_mus_pve_e06m4_terminal_accessed');

// Miller : That did it! Structure's open.
dprint ("Miller: That did it! Structure's open.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00100'));
sleep(10);
			
        
// Miller : That's weird. When the structure opened, Crimson's sensors…
dprint ("Miller: That's weird. When the structure opened, Crimson's sensors…");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00101'));
sleep(10);

// Palmer : Spit it out.
dprint ("Palmer: Spit it out.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00102'));
sleep(10);

// Miller : Everything's fine now. I'll keep an eye on it.
dprint ("Miller: Everything's fine now. I'll keep an eye on it.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_terminal_accessed_00103'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_vehicle_callout()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_vehicle_callout");
music_set_state('Play_mus_pve_e06m4_vehicle_callout');

// Miller : There’s a lot of Covie vehicles around. Grab a ride.
dprint ("Miller: There’s a lot of Covie vehicles around. Grab a ride.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_vehicle_callout_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_vehicle_callout_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m4_activity_in_structure_1()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_activity_in_structure_1");
music_set_state('Play_mus_pve_e06m4_activity_in_structure');

// Miller : Looks like a lot of activity deeper in the structure.
dprint ("Miller: Looks like a lot of activity deeper in the structure.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_activity_in_structure_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_activity_in_structure_00100'));
sleep(10);

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_activity_in_structure()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_activity_in_structure");
music_set_state('Play_mus_pve_e06m4_activity_in_structure');

// Palmer : Anything else on the armor sensors?
dprint ("Palmer: Anything else on the armor sensors?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_activity_in_structure_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_activity_in_structure_00101'));
sleep(10);

// Miller : Not yet. Keeping an eye on it.
dprint ("Miller: Not yet. Keeping an eye on it.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_activity_in_structure_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_activity_in_structure_00102'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_eliminate_hostiles()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_eliminate_hostiles");
music_set_state('Play_mus_pve_e06m4_eliminate_hostiles');

// Miller : Considerable resistence.
dprint ("Miller: Considerable resistence.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_eliminate_hostiles_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_eliminate_hostiles_00100'));
sleep(10);

// Palmer : Well, now I'm just curious as hell about what's so important in there.
dprint ("Palmer: Well, now I'm just curious as hell about what's so important in there.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_eliminate_hostiles_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_eliminate_hostiles_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_investigate_central_structure()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_investigate_central_structure");
music_set_state('Play_mus_pve_e06m4_investigate_central_structure');

// Miller : Commander, I've found the location of that mysterious reading. Placing a waypoint for Crimson.
dprint ("Miller: Commander, I've found the location of that mysterious reading. Placing a waypoint for Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_investigate_central_structure_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_investigate_central_structure_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_nukes()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_nukes");
music_set_state('Play_mus_pve_e06m4_nukes');

// Palmer : Tell me that's not what I think it is.
dprint ("Palmer: Tell me that's not what I think it is.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_nukes_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_nukes_00100'));
sleep(10);

// Miller : A stockpile of stolen UNSC nukes?
dprint ("Miller: A stockpile of stolen UNSC nukes?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_nukes_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_nukes_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_immediate_evac()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_immediate_evac");
music_set_state('Play_mus_pve_e06m4_immediate_evac');

// Palmer : Miller, send down a disposal team -
dprint ("Palmer: Miller, send down a disposal team -");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_immediate_evac_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_immediate_evac_00100'));
sleep(10);

// Miller : Commader, that won't be necessary. Those nukes have all had their warheads stripped. The Covies took them somewhere else.
dprint ("Miller: Commader, that won't be necessary. Those nukes have all had their warheads stripped. The Covies took them somewhere else.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_immediate_evac_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_immediate_evac_00101'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_switchback()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_switchback");
music_set_state('Play_mus_pve_e06m4_switchback');

// Switchback Leader (Female) : Switchback to Infinity!
dprint ("Switchback Leader (Female): Switchback to Infinity!");
start_radio_transmission("e8_m2_spartan_switchback_female");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00100'));
sleep(10);

// Palmer : Go ahead, Switchback.
dprint ("Palmer: Go ahead, Switchback.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00101'));
sleep(10);

// Switchback Leader (Female) : Covies have a Harvester down here! Encountering massive resistance. Request backup!
dprint ("Switchback Leader (Female): Covies have a Harvester down here! Encountering massive resistance. Request backup!");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_switchback_female");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00102'));
sleep(10);

// Palmer : Crimson, you're the closest responder. Fall out and help Switchback.
dprint ("Palmer: Crimson, you're the closest responder. Fall out and help Switchback.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep6_m4_2_60" );
thread (pip_e6m4_switchback_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00103'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e6m4_switchback_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00103');
end


script static void vo_e6m4_switchback_RVBALT()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_switchback");
music_set_state('Play_mus_pve_e06m4_switchback');

// Sarge: This is Corporal Switchback to Infinity!
dprint ("Sarge: This is Corporal Switchback to Infinity!");
//start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_rvb_sarge_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_rvb_sarge_00100'));
sleep(10);

// Palmer : Go ahead, Switchback.
dprint ("Palmer: Go ahead, Switchback.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00101'));
sleep(10);

// Sarge: Hey Infinity is your Slipspace drive running? Because you better go catch it!
dprint ("Sarge: Hey Infinity is your Slipspace drive running? Because you better go catch it!");
//cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_rvb_sarge_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_rvb_sarge_00200'));
sleep(10);

// Palmer : Crimson, you're the closest responder. Fall out and help Switchback.
dprint ("Palmer: Crimson, you're the closest responder. Fall out and help Switchback.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep6_m4_2_60" );
thread (pip_e6m4_switchback_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_switchback_00103'));
sleep(10);

// Griff: Baba booey! Baba booey!
dprint ("Griff: Baba booey! Baba booey!");
//cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_rvb_grif_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_rvb_grif_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_wraith()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_wraith");
music_set_state('Play_mus_pve_e06m4_wraith');

// Miller : Wraith, closing on your position!
dprint ("Miller: Wraith, closing on your position!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_wraith_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_wraith_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_harder_end()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_harder_end");
music_set_state('Play_mus_pve_e06m4_harder_end');

// Miller : Those Wraiths are trouble, Crimson. Best if you neutralize them before moving on.
dprint ("Miller: Those Wraiths are trouble, Crimson. Best if you neutralize them before moving on.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_harder_end_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_harder_end_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_ghost()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_ghost");
music_set_state('Play_mus_pve_e06m4_ghost');

// Miller : Tracking multiple Ghost signatures in your area, Crimson. Keep an eye out.
dprint ("Miller: Tracking multiple Ghost signatures in your area, Crimson. Keep an eye out.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_ghost_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_ghost_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_special_acknowledgement()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_special_acknowledgement");
music_set_state('Play_mus_pve_e06m4_special_acknowledgement');

// Palmer : No extra credit for getting ahead of yourself. Just make sure you get ALL of the targets.
dprint ("Palmer: No extra credit for getting ahead of yourself. Just make sure you get ALL of the targets.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_special_acknowledgement_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_special_acknowledgement_00100'));
sleep(10);

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e6m4_special_acknowledgement_2()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_special_acknowledgement_2");
music_set_state('Play_mus_pve_e06m4_special_acknowledgement');

// Palmer : Apparently you've got it all figured out down there. I suppose you can find your own way home too?
dprint ("Palmer: Apparently you've got it all figured out down there. I suppose you can find your own way home too?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_special_acknowledgement_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_special_acknowledgement_00101'));
sleep(10);

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_objective_complete()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_objective_complete");
music_set_state('Play_mus_pve_e06m4_objective_complete');

// Palmer : Alright, since you're all about overachieving, let's see what else is on the menu.
dprint ("Palmer: Alright, since you're all about overachieving, let's see what else is on the menu.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_objective_complete_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_objective_complete_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e6m4_compliment_player()

b_e6m4_narrative_is_on = TRUE;
dprint("Play_mus_pve_e06m4_compliment_player");
music_set_state('Play_mus_pve_e06m4_compliment_player');

// Palmer : Glad I don't have to clean up after you, Crimson. Messy but effective.
dprint ("Palmer: Glad I don't have to clean up after you, Crimson. Messy but effective.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_compliment_player_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_compliment_player_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end

// ============================================	MISC SCRIPT	========================================================


script static void vo_e6m4_snipers()
b_e6m4_narrative_is_on = TRUE;

// Miller : Snipers!
dprint ("Miller: Snipers!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_snipers_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_snipers_01'));
	
sleep(10);

// Palmer : Find some cover!
dprint ("Palmer: Find some cover!");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_cover_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_cover_01'));
	
sleep(30 * 3);

// Palmer : Neutralize all targets.
dprint ("Palmer: Neutralize all targets.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_04'));
	
end_radio_transmission();
b_e6m4_narrative_is_on = FALSE;
end

script static void vo_e6m4_open_structure()
b_e6m4_narrative_is_on = TRUE;

// Miller : That's all of them.
dprint ("Miller: That's all of them.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_02'));
sleep(20);
	
// Palmer : Roll on, Crimson.
dprint ("Palmer: Roll on, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_keepitup_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_keepitup_01'));
sleep(20);
	
// Miller : Setting a waypoint.
dprint ("Miller: Setting a waypoint.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_01'));
	
end_radio_transmission();
b_e6m4_narrative_is_on = FALSE;
end

script static void vo_e6m4_ordnance()
b_e6m4_narrative_is_on = TRUE;
		
// Miller : Hunters!
dprint ("Miller: Hunters!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hunters_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hunters_01'));
sleep(10);		

// Palmer : Dalton.
dprint ("Palmer: Dalton.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_dalton_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_dalton_01'));
sleep(30 * 1.5);
		
// Dalton : Ordinance inbound on Crimson's position now.
dprint ("Dalton: Ordinance inbound on Crimson's position now.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_01'));
sleep(30);

// Palmer : Roger that.
dprint ("Palmer: Roger that.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_01'));

end_radio_transmission();
b_e6m4_narrative_is_on = FALSE;
end

script static void vo_e6m4_ovrride_system()

b_e6m4_narrative_is_on = TRUE;

// Miller: I’ve traced an override system for the doors to the central structure. Marking it for Crimson.
dprint ("Miller: I’ve traced an override system for the doors to the central structure. Marking it for Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_trace_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_04\e06m4_trace_00100'));

b_e6m4_narrative_is_on = FALSE;
end_radio_transmission();

end