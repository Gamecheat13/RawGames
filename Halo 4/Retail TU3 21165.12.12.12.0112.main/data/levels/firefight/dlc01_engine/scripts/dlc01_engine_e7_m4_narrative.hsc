//=============================================================================================================================
//============================================ E7M4 ENGINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e7m4_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================

script static void vo_e7m4_playstart()

//dprint("Play_mus_pve_e07m4_seal_engine");
//music_set_state('Play_mus_pve_e07m4_seal_engine');

b_e7m4_narrative_is_on = TRUE;

// Miller : Crimson, I'm marking emergency bulkhead door releases. If you can reach these, you can seal up the engine room so tight the Covies will never be able to get in.
dprint ("Miller: Crimson, I'm marking emergency bulkhead door releases. If you can reach these, you can seal up the engine room so tight the Covies will never be able to get in.");
start_radio_transmission("miller_transmission_name");

	// REMembER TO UNCOMMENT WHEN WE HAVE IT
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep7_m4_1_60" );
thread (pip_e7m4_playstart_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_playstart_00100'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e7m4_playstart_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_playstart_00100');
end


// ============================================	VO SCRIPT	========================================================

script static void vo_e7m4_rolandsayshello()


b_e7m4_narrative_is_on = TRUE;

// Roland : Spartan Miller, bad guys are headed for the engine room.
dprint ("Roland: Spartan Miller, bad guys are headed for the engine room.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_rolandsayshello_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_rolandsayshello_00100'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_lockprogress()

//dprint("Play_mus_pve_e07m4_e7m4_lockprogress");
//music_set_state('Play_mus_pve_e7m4_lockprogress');
b_e7m4_narrative_is_on = TRUE;

// Miller : That's one door secure.  Move on to the next.
dprint ("Miller: That's one door secure.  Move on to the next.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00100'));

// Miller : That'll keep them out for awhile.  Get the others sealed.
dprint ("Miller: That'll keep them out for awhile.  Get the others sealed.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00200'));
sleep(10);

// Miller : You're on a roll, Crimson.  Keep it up.
dprint ("Miller: You're on a roll, Crimson.  Keep it up.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00300'));
sleep(10);

// Miller : Excellent work.  Engine room's nearly locked down.
dprint ("Miller: Excellent work.  Engine room's nearly locked down.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00400'));
sleep(10);

// Miller : One more to go!  Great work.
dprint ("Miller: One more to go!  Great work.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00500'));
sleep(10);

//dprint("Play_mus_pve_e07m4_e7m4_lockdone");
//music_set_state('Play_mus_pve_e7m4_lockdone');
// Miller : That's it!  Last one!
dprint ("Miller: That's it!  Last one!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00600'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end

// ============	VO DOOR COUNTER	====================
// DO NOT DELETE BECAUSE THE ABOVE DOOR SWITCH VO NEEDS SEPARATION
// =================================================
script static void vo_e7m4_lockprogress1()
//dprint("Play_mus_pve_e07m4_e7m4_lockprogress");
//music_set_state('Play_mus_pve_e7m4_lockprogress');
b_e7m4_narrative_is_on = TRUE;

// Miller : That's one door secure.  Move on to the next.
dprint ("Miller: That's one door secure.  Move on to the next.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00100'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();
end

script static void vo_e7m4_lockprogress2()
b_e7m4_narrative_is_on = TRUE;

// Miller : You're on a roll, Crimson.  Keep it up.
dprint ("Miller: You're on a roll, Crimson.  Keep it up.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00300'));
sleep(10);
b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();
end

script static void vo_e7m4_lockprogress3()
b_e7m4_narrative_is_on = TRUE;

// Miller : Excellent work.  Engine room's nearly locked down.
dprint ("Miller: Excellent work.  Engine room's nearly locked down.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00400'));
sleep(10);

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m4_lockprogress4()
b_e7m4_narrative_is_on = TRUE;

// Miller : One more to go!  Great work.
dprint ("Miller: One more to go!  Great work.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00500'));
sleep(10);

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m4_lockprogress5()
b_e7m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e07m4_e7m4_lockdone");
//music_set_state('Play_mus_pve_e7m4_lockdone');
// Miller : That's it!  Last one!
dprint ("Miller: That's it!  Last one!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00600'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_gotocore()
//dprint("Play_mus_pve_e07m4_e7m4_gotocore");
//music_set_state('Play_mus_pve_e7m4_gotocore');
b_e7m4_narrative_is_on = TRUE;

// Roland : Spartan Miller!  Infinity's aft defenses are offline!
dprint ("Roland: Spartan Miller!  Infinity's aft defenses are offline!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00100'));
sleep(10);

// Miller : What?  How?
dprint ("Miller: What?  How?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00200'));
sleep(10);

// Roland : Weapon cooling systems are deactivated.
dprint ("Roland: Weapon cooling systems are deactivated.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00300'));
sleep(10);

// Roland : Weapons overheated and safety protocols kicked in.
dprint ("Roland: Weapons overheated and safety protocols kicked in.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00400'));
sleep(10);

// Roland : We're defenseless.
dprint ("Roland: We're defenseless.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00500'));
sleep(10);

// Miller : Crimson, aft weapon control is just off the engine room.
dprint ("Miller: Crimson, aft weapon control is just off the engine room.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00600'));
sleep(10);

// Miller : I'm sending you to help.
dprint ("Miller: I'm sending you to help.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00700', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_gotocore_00700'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_incore()

b_e7m4_narrative_is_on = TRUE;
//dprint("Play_mus_pve_e07m4_e7m4_incore");
//music_set_state('Play_mus_pve_e7m4_incore');

// Miller : Roland, what are those?
dprint ("Miller: Roland, what are those?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_incore_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_incore_00100'));
sleep(10);

// Roland : Jammers. They're blocking the hardware comm systems in here, causing the cooling system to malfunction.
dprint ("Roland: Jammers. They're blocking the hardware comm systems in here, causing the cooling system to malfunction.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_incore_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_incore_00200'));
sleep(10);

// Miller : Clear 'em, Crimson!
dprint ("Miller: Clear 'em, Crimson!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_incore_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_incore_00300'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_1stoverride()

b_e7m4_narrative_is_on = TRUE;

// Miller : One down.  Two to go.
dprint ("Miller: One down.  Two to go.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_1stoverride_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_1stoverride_00100'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_2ndoverride()

b_e7m4_narrative_is_on = TRUE;

// Miller : That's two!
dprint ("Miller: That's two!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00100'));
sleep(10);

// Roland : One to go!
dprint ("Roland: One to go!");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00200'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_3rdoverride()
//dprint("Play_mus_pve_e07m4_e7m4_3rdoverride");
//music_set_state('Play_mus_pve_e7m4_3rdoverride');
b_e7m4_narrative_is_on = TRUE;

// Roland : That's all three overrides.
dprint ("Roland: That's all three overrides.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00100'));
sleep(10);

// Miller : The guns are still not firing.
dprint ("Miller: The guns are still not firing.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00200'));
sleep(10);

// Roland : So I noticed.
dprint ("Roland: So I noticed.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00300'));
sleep(10);

// Roland : Trying to find out why, but you humans are awful at writing technical manuals.
dprint ("Roland: Trying to find out why, but you humans are awful at writing technical manuals.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00400'));
sleep(10);

// Roland : A moment, please.
dprint ("Roland: A moment, please.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_3rdoverride_00500'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_hunters()
//dprint("Play_mus_pve_e07m4_e7m4_hunters");
//music_set_state('Play_mus_pve_e7m4_hunters');
b_e7m4_narrative_is_on = TRUE;

// Roland : Spartan!  Hunters have entered the area!
dprint ("Roland: Spartan!  Hunters have entered the area!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_hunters_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_hunters_00100'));
sleep(10);

// Miller : You can take them, Crimson!
dprint ("Miller: You can take them, Crimson!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_hunters_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_hunters_00200'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_enablecore()
//dprint("Play_mus_pve_e07m4_e7m4_enablecore");
//music_set_state('Play_mus_pve_e7m4_enablecore');
b_e7m4_narrative_is_on = TRUE;

// Roland : Got it!  Marking the controls for Crimson now.
dprint ("Roland: Got it!  Marking the controls for Crimson now.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_enablecore_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_enablecore_00100'));
sleep(10);

// Miller : And these will bring the guns back online?
dprint ("Miller: And these will bring the guns back online?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_enablecore_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_enablecore_00200'));
sleep(10);

// Roland : Yes!  Why would I tell Crimson to press buttons that don't do anything?!
dprint ("Roland: Yes!  Why would I tell Crimson to press buttons that don't do anything?!");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_enablecore_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_enablecore_00300'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_online()
//dprint("Play_mus_pve_e07m4_e7m4_gunsonline");
//music_set_state('Play_mus_pve_e07m4_e7m4_gunsonline');
b_e7m4_narrative_is_on = TRUE;

// Roland : See?  Worked perfectly.
dprint ("Roland: See?  Worked perfectly.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00100'));
sleep(10);

// Roland : Guns are back online.
dprint ("Roland: Guns are back online.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00200'));
sleep(10);

// Roland : Enjoy the fireworks, Crimson.
dprint ("Roland: Enjoy the fireworks, Crimson.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00300'));
sleep(10);

// Miller : Yeah!
dprint ("Miller: Yeah!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_online_00400'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_ending()
//dprint("Play_mus_pve_e07m4_e7m4_ending");
//music_set_state('Play_mus_pve_e07m4_e7m4_ending');
b_e7m4_narrative_is_on = TRUE;

// Miller : You’re really knocking some heads together, Crimson! Let’s take down the rest of these freaks and call it a day.
dprint ("Miller: You’re really knocking some heads together, Crimson! Let’s take down the rest of these freaks and call it a day.");
start_radio_transmission("miller_transmission_name");

		// REMembER TO UNCOMMENT WHEN WE HAVE IT
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep7_m4_2_60" );
thread (pip_e7m4_ending_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_ending_00100'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e7m4_ending_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_ending_00100');
end


script static void vo_e7m4_infinity_01()

b_e7m4_narrative_is_on = TRUE;


// Infinity System Voice : Warning. Aft defensive controls off-line. Aft-defensive controls off-line.
dprint ("Infinity System Voice: Warning. Aft defensive controls off-line. Aft-defensive controls off-line.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_infinity_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_infinity_00100'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_infinity_02()

b_e7m4_narrative_is_on = TRUE;


// Infinity System Voice : Fore Armory Twelve Seven has been secured. Fireteams are being redirected to additional action stations.
dprint ("Infinity System Voice: Fore Armory Twelve Seven has been secured. Fireteams are being redirected to additional action stations.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_infinity_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_infinity_00101'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m4_infinity_03()

b_e7m4_narrative_is_on = TRUE;


// Infinity System Voice : Translight crews are advised that fissile materials have been addressed in the area. All hands may now return to Translight decks.
dprint ("Infinity System Voice: Translight crews are advised that fissile materials have been addressed in the area. All hands may now return to Translight decks.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_infinity_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_infinity_00102'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end



script static void vo_e7m4_getintheserver_01()

b_e7m4_narrative_is_on = TRUE;


// Miller: Crimson, server room is right there.
dprint ("Miller: Crimson, server room is right there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_getintheserver_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_getintheserver_00100'));

b_e7m4_narrative_is_on = FALSE;
end_radio_transmission();

end



// ============================================	MISC SCRIPT	========================================================