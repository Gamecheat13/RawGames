//=============================================================================================================================
//============================================ E7M2 ENGINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e7m2_leavehangardudes = FALSE;
global boolean b_e7m2_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================



script static void vo_e7m2_intro_1()

b_e7m2_narrative_is_on = TRUE;

// Miller : Careful!  Ship's defenses can't pick you out of the crowd
dprint ("Miller: Careful!  Ship's defenses can't pick you out of the crowd");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00100'));
sleep(10);

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m2_intro_2()

b_e7m2_narrative_is_on = TRUE;

// Murphy : It's okay!  I got this!
dprint ("Murphy: It's okay!  I got this!");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00200'));
sleep(10);


b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m2_intro_3()

b_e7m2_narrative_is_on = TRUE;

// Murphy : Oh hell!
dprint ("Murphy: Oh hell!");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00300'));
sleep(10);

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m2_intro_4()

b_e7m2_narrative_is_on = TRUE;
// Miller : Crimson!
dprint ("Miller: Crimson!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_intro_00400'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_playstart()
//dprint("Play_mus_pve_e07m2_playstart");
//music_set_state('Play_mus_pve_e07m2_playstart');
b_e7m2_narrative_is_on = TRUE;

// e07m2_marine_01 : Hell of an entrance, Spartans!
dprint ("e07m2_marine_01: Hell of an entrance, Spartans!");
start_radio_transmission("e07m2_marine_01_transmission_name");
hud_play_pip_from_tag("levels\dlc\shared\binks\sp_g10_60"); // 
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_playstart_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_playstart_00100'));
sleep(10);

/*// e07m2_marine_02 : Good to see you all the same!
dprint ("e07m2_marine_02: Good to see you all the same!");
cui_hud_show_radio_transmission_hud("e07m2_marine_02_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_playstart_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_playstart_00200'));
sleep(10);*/

// Miller : Crimson, help the marines secure that hangar.
dprint ("Miller: Crimson, help the marines secure that hangar.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_playstart_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_playstart_00300'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_murphy()
//dprint("Play_mus_pve_e07m2_murphy");
//music_set_state('Play_mus_pve_e07m2_murphy');
b_e7m2_narrative_is_on = TRUE;

// Miller : Murphy, are you there?
dprint ("Miller: Murphy, are you there?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00100'));
sleep(10);

// Murphy : Still in one piece, Spartan.  Just pinned in here real good.
dprint ("Murphy: Still in one piece, Spartan.  Just pinned in here real good.");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00200'));
sleep(10);

// Miller : Hang tight, Murphy.
dprint ("Miller: Hang tight, Murphy.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00300'));
sleep(10);

// Miller : Roland, send an extraction team in for Murphy.
dprint ("Miller: Roland, send an extraction team in for Murphy.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00400'));
sleep(10);

// Miller : Roland?  Roland you there?
dprint ("Miller: Roland?  Roland you there?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00500'));
sleep(10);

// Miller : Grrr.  Comms are offline across the board.
dprint ("Miller: Grrr.  Comms are offline across the board.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_murphy_00600'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_hangarphantom()

b_e7m2_narrative_is_on = TRUE;

// Miller : Phantoms entering the hangar.
dprint ("Miller: Phantoms entering the hangar.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarphantom_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarphantom_00100'));
sleep(10);

// Miller : Hold them off while I find a way to seal the bay.
dprint ("Miller: Hold them off while I find a way to seal the bay.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarphantom_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarphantom_00200'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_hitcontrols()

//dprint("Play_mus_pve_e07m2_hitcontrols");
//music_set_state('Play_mus_pve_e07m2_hitcontrols');
b_e7m2_narrative_is_on = TRUE;

// Miller : Crimson, here's hangar bay controls.  Hit them to seal the doors.
dprint ("Miller: Crimson, here's hangar bay controls.  Hit them to seal the doors.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hitcontrols_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hitcontrols_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_dontwork()
//dprint("Play_mus_pve_e07m2_dontwork");
//music_set_state('Play_mus_pve_e07m2_dontwork');

b_e7m2_narrative_is_on = TRUE;

// Miller : Oh, come on!  Why aren't they working?  Is everything on this ship busted?
dprint ("Miller: Oh, come on!  Why aren't they working?  Is everything on this ship busted?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_dontwork_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_dontwork_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_moreincoming()

b_e7m2_narrative_is_on = TRUE;

// Miller : Crimson, hold off the new arrivals.  I'm trying everything I can up here to get systems back online.
dprint ("Miller: Crimson, hold off the new arrivals.  I'm trying everything I can up here to get systems back online.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_moreincoming_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_moreincoming_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_palmerone()
//dprint("Play_mus_pve_e07m2_palmerone");
//music_set_state('Play_mus_pve_e07m2_palmerone');
b_e7m2_narrative_is_on = TRUE;

// Miller : Okay…here…I think this--
dprint ("Miller: Okay…here…I think this--");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00100'));
sleep(10);

// Palmer : Watch your flank, Marine!
dprint ("Palmer: Watch your flank, Marine!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00200_soundstory', NONE, 1);
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00200');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00200'));
sleep(10);

//// Palmer : I know you're not a Spartan:  Spartans shoot straight!
dprint ("Palmer: I know you're not a Spartan:  Spartans shoot straight!");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00300');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00300'));
sleep(10);

//// Miller : Commander Palmer!
//dprint ("Miller: Commander Palmer!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00400');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00400'));
sleep(10);
//
//// Palmer : Miller?  Is that you?
//dprint ("Palmer: Miller?  Is that you?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00500');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00500'));
sleep(10);
//
//// Miller : Just got comms working again.
//dprint ("Miller: Just got comms working again.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00600');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00600'));
sleep(10);
//
//// Palmer : Nice job.  Whole ship's been silent for the last few.
//dprint ("Palmer: Nice job.  Whole ship's been silent for the last few.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00700');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00700'));
sleep(10);

// Miller : Roland?  You there?
dprint ("Miller: Roland?  You there?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00800', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00800'));
sleep(10);

// Roland : Kind of busy, Spartan.
dprint ("Roland: Kind of busy, Spartan.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00900', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmerone_00900'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_gettoserver()
//dprint("Play_mus_pve_e07m2_gettoserver");
//music_set_state('Play_mus_pve_e07m2_gettoserver');
b_e7m2_narrative_is_on = TRUE;

// Miller : Roland, Crimson can't close the doors to bay -- (number)
dprint ("Miller: Roland, Crimson can't close the doors to bay -- (number)");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00100'));
sleep(10);

// Roland : Doctor Halsey's artifcact is causing some ship-wide craziness.
dprint ("Roland: Doctor Halsey's artifcact is causing some ship-wide craziness.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00200'));
sleep(10);

// Roland : Go power cycle the engineering level server room.  See if that helps.
dprint ("Roland: Go power cycle the engineering level server room.  See if that helps.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00300'));
/*sleep(10);

// Miller : Will it help?
dprint ("Miller: Will it help?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00400'));
sleep(10);

// Roland : It won't hurt.
dprint ("Roland: It won't hurt.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoserver_00500'));*/

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_serverarrive()

b_e7m2_narrative_is_on = TRUE;

sleep (30);

// Miller : Crimson, you can activate that lift to gain access to the server hallway.
dprint ("Miller: Crimson, you can activate that lift to gain access to the server hallway.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverarrive_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverarrive_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_liftraised()
//dprint("Play_mus_pve_e07m2_liftraised");
//music_set_state('Play_mus_pve_e07m2_liftraised');


b_e7m2_narrative_is_on = TRUE;

// Miller : Marking the way to the server room now.
dprint ("Miller: Marking the way to the server room now.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_liftraised_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_liftraised_00100'));

f_blip_object (mc_6, default);
e7m2_leavehangardudes = TRUE;

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_morebadguys()
//dprint("Play_mus_pve_e07m2_morebadguys");
//music_set_state('Play_mus_pve_e07m2_morebadguys');

b_e7m2_narrative_is_on = TRUE;

// Miller : Oh hell, they're coming from everywhere now.  Take 'em out as you go.
dprint ("Miller: Oh hell, they're coming from everywhere now.  Take 'em out as you go.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_morebadguys_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_morebadguys_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_palmertwo()
//dprint("Play_mus_pve_e07m2_palmertwo");
//music_set_state('Play_mus_pve_e07m2_palmertwo');
b_e7m2_narrative_is_on = TRUE;

// Palmer : Miller, I'm en route to Captain Lasky's position, but comms are still choppy.  Can you reach him?
dprint ("Palmer: Miller, I'm en route to Captain Lasky's position, but comms are still choppy.  Can you reach him?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmertwo_00100_soundstory', NONE, 1);
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmertwo_00100');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmertwo_00100'));
sleep(10);

//// Miller : One second.  Spartan Miller to Captain Lasky.  Captain?
dprint ("Miller: One second.  Spartan Miller to Captain Lasky.  Captain?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmertwo_00200');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmertwo_00200'));
sleep(10);
//
//// Miller : No reply. Sorry Commander.
dprint ("Miller: No reply. Sorry Commander.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmertwo_00300');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_palmertwo_00300'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_secureroom()

b_e7m2_narrative_is_on = TRUE;

// Miller : Crimson, take out the stragglers. You need time to do this power cycle.
dprint ("Miller: Crimson, take out the stragglers. You need time to do this power cycle.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_secureroom_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_secureroom_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_roomclear()
//dprint("Play_mus_pve_e07m2_silence");
//music_set_state('Play_mus_pve_e07m2_silence');
b_e7m2_narrative_is_on = TRUE;

//// Miller : Hrmmm... Roland's right.
//dprint ("Miller: Hrmmm... Roland's right.");
//start_radio_transmission("miller_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_roomclear_00100', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_roomclear_00100'));
//sleep(10);
//
//// Miller : Servers are offline. Marking the power controls for you now.
//dprint ("Miller: Servers are offline. Marking the power controls for you now.");
//cui_hud_show_radio_transmission_hud("miller_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_roomclear_00200', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_roomclear_00200'));
//sleep(10);

// Miller : Marking the power controls for you now.
dprint ("Miller: Marking the power controls for you now.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_roomclear_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_roomclear_00300'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_cyclebegun()
//dprint("Play_mus_pve_e07m2_cyclebegun");
//music_set_state('Play_mus_pve_e07m2_cyclebegun');

b_e7m2_narrative_is_on = TRUE;

// Miller : Servers are coming online…Should be just a minute more.
dprint ("Miller: Servers are coming online…Should be just a minute more.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_cyclebegun_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_cyclebegun_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_knightsappear()

b_e7m2_narrative_is_on = TRUE;

// Miller : Promethean Knights!
dprint ("Miller: Promethean Knights!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_knightsappear_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_knightsappear_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_defendroom()

b_e7m2_narrative_is_on = TRUE;

// Miller : Take 'em out, Crimson.
dprint ("Miller: Take 'em out, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_defendroom_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_defendroom_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_serverprogress1()
b_e7m2_narrative_is_on = TRUE;
// Miller : Servers are 25% online.
dprint ("Miller: Servers are 25% online.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00100'));
b_e7m2_narrative_is_on = FALSE;
//end_radio_transmission();
end

script static void vo_e7m2_serverprogress2()
b_e7m2_narrative_is_on = TRUE;
// Miller : Servers are at 50 and climbing.
dprint ("Miller: Servers are at 50 and climbing.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00200'));
b_e7m2_narrative_is_on = FALSE;
//end_radio_transmission();
end

script static void vo_e7m2_serverprogress3()
b_e7m2_narrative_is_on = TRUE;
// Miller : Reboot's almost done, Crimson.  Just a little longer.
dprint ("Miller: Reboot's almost done, Crimson.  Just a little longer.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00300'));
b_e7m2_narrative_is_on = FALSE;
//end_radio_transmission();
end

script static void vo_e7m2_serverprogress4()
b_e7m2_narrative_is_on = TRUE;
// Miller : Servers are back online!
dprint ("Miller: Servers are back online!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_serverprogress_00400'));
b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();
end


script static void vo_e7m2_datalink()
//dprint("Play_mus_pve_e07m2_datalink");
//music_set_state('Play_mus_pve_e07m2_datalink');

b_e7m2_narrative_is_on = TRUE;

// Miller : One last step.
dprint ("Miller: One last step.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_datalink_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_datalink_00100'));
sleep(10);

// Miller : This is the ship-wide data link. Activate it, and we’re done here.
dprint ("Miller: This is the ship-wide data link. Activate it, and we’re done here.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_datalink_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_datalink_00200'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_linkactive()
//dprint("Play_mus_pve_e07m2_linkactive");
//music_set_state('Play_mus_pve_e07m2_linkactive');
b_e7m2_narrative_is_on = TRUE;

// Miller : Awesome!  Roland!  Power cycle worked.  Hangar controls are back online.
dprint ("Miller: Awesome!  Roland!  Power cycle worked.  Hangar controls are back online.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00100'));
sleep(10);

// Miller : Can you seal the bay for us?
dprint ("Miller: Can you seal the bay for us?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00200'));
sleep(10);

// Roland : Nothing doing, Spartan.  After a power cycle, the controls have to be activated locally.
dprint ("Roland: Nothing doing, Spartan.  After a power cycle, the controls have to be activated locally.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00300'));
sleep(10);

// Miller : Okay, Crimson.  Get moving back to the hangar.
dprint ("Miller: Okay, Crimson.  Get moving back to the hangar.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_linkactive_00400'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_backtohangar()
//dprint("Play_mus_pve_e07m2_infinityblow");
//music_set_state('Play_mus_pve_e07m2_infinityblow');
b_e7m2_narrative_is_on = TRUE;

// Roland : Spartan Miller, I need Crimson's help.
dprint ("Roland: Spartan Miller, I need Crimson's help.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00100'));
sleep(10);

// Miller : They aren't done sealing up the hangar bay yet.
dprint ("Miller: They aren't done sealing up the hangar bay yet.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00200'));
sleep(10);

// Roland : This is important.
dprint ("Roland: This is important.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00300'));
sleep(10);

// Miller : How important?
dprint ("Miller: How important?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00400'));
sleep(10);



// Roland : "Infinity might blow up if they don't fix this problem real soon" important.
dprint ("Roland: Infinity might blow up if they don't fix this problem real soon important.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00500'));
sleep(10);

// Miller : Be quick, Spartans.
dprint ("Miller: Be quick, Spartans.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_backtohangar_00600'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_hangarreturn()
//dprint("Play_mus_pve_e07m2_hangarreturn");
//music_set_state('Play_mus_pve_e07m2_hangarreturn');

b_e7m2_narrative_is_on = TRUE;

// Miller : More?  Come on!
dprint ("Miller: More?  Come on!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarreturn_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarreturn_00100'));
sleep(10);

// Miller : Alright.  You got this, Crimson.
dprint ("Miller: Alright.  You got this, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarreturn_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_hangarreturn_00200'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_gettoengine()
//dprint("Play_mus_pve_e07m2_gettoengine");
//music_set_state('Play_mus_pve_e07m2_infinityblow');
b_e7m2_narrative_is_on = TRUE;

// Miller : All clear!  Now close those doors!  Roland, you had an emergency?
dprint ("Miller: All clear!  Now close those doors!  Roland, you had an emergency?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoengine_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoengine_00100'));
sleep(10);

// Roland : Yeah.  Crimson.  Engine room.  NOW.
dprint ("Roland: Yeah.  Crimson.  Engine room.  NOW.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoengine_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_gettoengine_00200'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_endpip()

b_e7m2_narrative_is_on = TRUE;

// Miller : Your work's not done yet.  Get moving towards the engine room.
dprint ("Miller: Your work's not done yet.  Get moving towards the engine room.");
start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep7_m2_1_60" );
thread (pip_e7m2_endpip_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_endpip_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e7m2_endpip_subtitles()
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_endpip_00100');
end


script static void vo_e7m2_infinity_01()

b_e7m2_narrative_is_on = TRUE;

// Infinity System Voice : Attention. Spartan Fireteams Kodiak and Avalanche, proceed to Fore Armory Twelve-Seven. All other mission parameters are suspended.
dprint ("Infinity System Voice: Attention. Spartan Fireteams Kodiak and Avalanche, proceed to Fore Armory Twelve-Seven. All other mission parameters are suspended.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_infinity_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_infinity_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m2_infinity_02()

b_e7m2_narrative_is_on = TRUE;

// Infinity System Voice : Covenant boarding parties detected in Translight Deck 19 Dash 7, Hangar Bay 4. Action teams are ordered to respond immediately.
dprint ("Infinity System Voice: Covenant boarding parties detected in Translight Deck 19 Dash 7, Hangar Bay 4. Action teams are ordered to respond immediately.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_infinity_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_infinity_00101'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m2_infinity_03()

b_e7m2_narrative_is_on = TRUE;

// Infinity System Voice : All Infinity crew with access to Forerunner assets: In the event of any non-standard activity, local area should be evacuated and event must be reported to Infinity Ops immediately.
dprint ("Infinity System Voice: All Infinity crew with access to Forerunner assets: In the event of any non-standard activity, local area should be evacuated and event must be reported to Infinity Ops immediately.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_infinity_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_infinity_00102'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end



// ============================================	MISC SCRIPT	========================================================



script static void vo_e7m2_phanton_hanger_01()

b_e7m2_narrative_is_on = TRUE;

// Miller: Crimson, the doors can’t close until that Phantom’s out of there.
dprint ("Miller: Crimson, the doors can’t close until that Phantom’s out of there.");
start_radio_transmission("miller_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_phanton_hanger_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_phanton_hanger_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m2_enter_serverroom()

b_e7m2_narrative_is_on = TRUE;

// Miller: Marking the server room door.
dprint ("Miller: Marking the server room door.");
start_radio_transmission("miller_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_enter_serverroom_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_enter_serverroom_00100'));

b_e7m2_narrative_is_on = FALSE;
end_radio_transmission();

end