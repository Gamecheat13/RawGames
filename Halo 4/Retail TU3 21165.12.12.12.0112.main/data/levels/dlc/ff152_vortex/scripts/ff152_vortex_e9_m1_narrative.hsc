//=============================================================================================================================
//============================================ E9M1 VORTEX NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e9m1_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e9m1_narr_in()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_narr_in");
music_set_state('Play_mus_pve_e09m1_narr_in');

//// Miller : Commander Palmer, comms are open.
//dprint ("Miller: Commander Palmer, comms are open.");
//start_radio_transmission("miller_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00100', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00100'));

sleep(70);

// Palmer : Infinity Commander Sarah Palmer to all Spartans.
dprint ("Palmer: Infinity Commander Sarah Palmer to all Spartans.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00101'));
sleep(10);

// Palmer : Doctor Catherine Halsey has been abducted by Jul 'Mdama's forces.
dprint ("Palmer: Doctor Catherine Halsey has been abducted by Jul 'Mdama's forces.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00102'));
sleep(10);

// Palmer : Every fireteam is being reassigned to find her.
dprint ("Palmer: Every fireteam is being reassigned to find her.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00103'));
sleep(10);

// Palmer : Good luck, and good hunting. Palmer out.
dprint ("Palmer: Good luck, and good hunting. Palmer out.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_narr_in_00104'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e9m1_comms()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_comms");
music_set_state('Play_mus_pve_e09m1_comms');

// Miller : Crimson, Doctor Halsey was relaying transmissions through this location before she was snatched. You're here to help trace the call.
dprint ("Miller: Crimson, Doctor Halsey was relaying transmissions through this location before she was snatched. You're here to help trace the call.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_comms_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_comms_00100'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_start_there()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_start_there");
music_set_state('Play_mus_pve_e09m1_start_there');

// Miller : Spartan Miller to Doctor Truman.
dprint ("Miller: Spartan Miller to Doctor Truman.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00100'));
sleep(10);

// Dr. Truman : Truman, Infinity Science.
dprint ("Dr. Truman: Truman, Infinity Science.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00101'));
sleep(10);

// Miller : Doc, I've got a team of Spartans on location in [Vortex]. You have those coordinates ready?
dprint ("Miller: Doc, I've got a team of Spartans on location in [Vortex]. You have those coordinates ready?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00102alt', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00102alt'));
sleep(10);

// Dr. Truman : Yes. Sending them to you now.
dprint ("Dr. Truman: Yes. Sending them to you now.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_start_there_00103'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_badguys()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_badguys");
music_set_state('Play_mus_pve_e09m1_badguys');

// Miller : Clear that position, Crimson.
dprint ("Miller: Clear that position, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_secure_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_secure_00105'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e9m1_more_badguys()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_more_badguys");
music_set_state('Play_mus_pve_e09m1_more_badguys');
hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G04_60" );
// Dalton : Miller, you've got a Phantom headed Crimson's way.
dprint ("Dalton: Miller, you've got a Phantom headed Crimson's way.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_more_badguys_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_more_badguys_00100'));
sleep(10);

// Miller : Thanks, Dalton. What do these guys think they're gonna do that the last batch couldn't?
dprint ("Miller: Thanks, Dalton. What do these guys think they're gonna do that the last batch couldn't?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_more_badguys_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_more_badguys_00101'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_locked()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_locked");
music_set_state('Play_mus_pve_e09m1_locked');

// Miller : Area's secure. What are we looking for, Doctor Truman?
dprint ("Miller: Area's secure. What are we looking for, Doctor Truman?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_locked_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_locked_00100'));
sleep(10);

// Dr. Truman : It's behind those doors.
dprint ("Dr. Truman: It's behind those doors.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_locked_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_locked_00101'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_door_derez()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_door_derez");
music_set_state('Play_mus_pve_e09m1_door_derez');

// Miller : That's... odd.
dprint ("Miller: That's... odd.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_door_derez_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_door_derez_00100'));
sleep(10);

// Dr. Truman : Indeed. As if the structure is responding to Crimson…
dprint ("Dr. Truman: Indeed. As if the structure is responding to Crimson…");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_door_derez_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_door_derez_00101'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_listen_comms()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_listen_comms");
music_set_state('Play_mus_pve_e09m1_listen_comms');

// Miller : Doctor Truman. Which of these devices is the comm relay you're after?
dprint ("Miller: Doctor Truman. Which of these devices is the comm relay you're after?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listen_comms_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listen_comms_00100'));
sleep(10);

// Dr. Truman : Right here, Crimson.
dprint ("Dr. Truman: Right here, Crimson.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listen_comms_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listen_comms_00101'));
/*sleep(10);

// Miller : Fire it up, Crimson.
dprint ("Miller: Fire it up, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listen_comms_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listen_comms_00102'));*/

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_listeng_in()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_listeng_in");
music_set_state('Play_mus_pve_e09m1_listeng_in');

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short', vortex_floaters, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\sfx_halsey_readout_short'));

// Sangheli Radio Voice : The Didact's Hand is moving forces to Librarian's Rest. He demands all troops fall back to that location.
dprint ("Sangheli Radio Voice: The Didact's Hand is moving forces to Librarian's Rest. He demands all troops fall back to that location.");
start_radio_transmission("jul_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00100'));
sleep(10);

/*// Miller : Roland? You online? I need a rapid translation.
dprint ("Miller: Roland? You online? I need a rapid translation.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00101'));
sleep(10);*/

// Roland : A call to arms. 'Mdama wants everyone to meet at Librarian's Rest, but doesn't include coordinates.
dprint ("Roland: A call to arms. 'Mdama wants everyone to meet at Librarian's Rest, but doesn't include coordinates.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00102'));
sleep(10);

/*// Roland : Not the most informative of party invites.
dprint ("Roland: Not the most informative of party invites.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00103'));
sleep(10);*/

/*// Miller : Doctor Truman? Librarian's Rest?
dprint ("Miller: Doctor Truman? Librarian's Rest?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00104'));
sleep(10);*/

// Dr. Truman : Not familiar with it.
dprint ("Dr. Truman: Not familiar with it.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_listening_in_00105'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_kill_time()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_kill_time");
music_set_state('Play_mus_pve_e09m1_kill_time');
/*
// Dr. Truman : Spartan Miller, if you'll give me a moment, I'm going to try and make sense of this system's communication logs.
dprint ("Dr. Truman: Spartan Miller, if you'll give me a moment, I'm going to try and make sense of this system's communication logs.");
start_radio_transmission("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00100'));
sleep(10);*/

// Roland: You want I should take a look at these comm logs? I could track Doctor Halsey’s transmissions through this system.

dprint ("Roland: You want I should take a look at these comm logs? I could track Doctor Halsey’s transmissions through this system.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00200'));
sleep(10);

// Miller: Have at it, Roland.
dprint ("Miller: Have at it, Roland.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00201', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00201'));
sleep(10);

sleep_s(2);

// Roland: Got it. I know where Halsey’s call was routed next. Some Marines are near that location right now.
dprint ("Roland: Got it. I know where Halsey’s call was routed next. Some Marines are near that location right now.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_when_ready_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_when_ready_00100'));
sleep(10);

/*// Miller: Nice work, Roland. Tell the Marines they’ll have company just as soon as Crimson’s done here.
dprint ("Miller: Nice work, Roland. Tell the Marines they’ll have company just as soon as Crimson’s done here.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_when_ready_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_when_ready_00101'));
*sleep(10);*/

// Dr. Truman : I might be able to track Doctor Halsey's transmissions through here, and give us a hint as to the location of Librarian's Rest.
dprint ("Dr. Truman: I might be able to track Doctor Halsey's transmissions through here, and give us a hint as to the location of Librarian's Rest.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00101'));
sleep(10);

// Miller : Have at it, Doc.
dprint ("Miller: Have at it, Doc.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_kill_time_00102'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_prometheans()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_prometheans");
music_set_state('Play_mus_pve_e09m1_prometheans');

// Miller : Prometheans. Everywhere! Hold position, Spartans! Fend them off!
dprint ("Miller: Prometheans. Everywhere! Hold position, Spartans! Fend them off!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_prometheans_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_prometheans_00100'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_power_source()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_power_source");
music_set_state('Play_mus_pve_e09m1_power_source');

// Miller : Crimson, there's a sudden power spike nearby. Marking it for you now. Let's go get a look.
dprint ("Miller: Crimson, there's a sudden power spike nearby. Marking it for you now. Let's go get a look.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_source_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_source_00100'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_alt_fight()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_alt_fight");
music_set_state('Play_mus_pve_e09m1_alt_fight');

// Miller : You doing okay, Crimson? Dalton, send in some ordnance.
dprint ("Miller: You doing okay, Crimson? Dalton, send in some ordnance.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_alt_fight_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_alt_fight_00100'));
sleep(10);

// Dalton : You got it. Delivery pod away.
dprint ("Dalton: You got it. Delivery pod away.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_alt_fight_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_alt_fight_00101'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_closer_look()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_closer_look");
music_set_state('Play_mus_pve_e09m1_closer_look');

// Miller : Crimson, there's the source of the power spike. Doctor Truman, any thoughts?
dprint ("Miller: Crimson, there's the source of the power spike. Doctor Truman, any thoughts?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00100'));
sleep(10);

markpowersource_1();

// Dr. Truman : No idea why it would suddenly activate, no.
dprint ("Dr. Truman: No idea why it would suddenly activate, no.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00101'));
sleep(10);

// Roland : Heya, Doc Truman? You probably can't see it, what with your boring biological eyeballs and all, but that power source is modulating at a frequency matching the encryption key on the comm stream you're trying to crack.
dprint ("Roland: Heya, Doc Truman? You probably can't see it, what with your boring biological eyeballs and all, but that power source is modulating at a frequency matching the encryption key on the comm stream you're trying to crack.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00102'));
sleep(10);

// Miller : Roland, don't be rude.
dprint ("Miller: Roland, don't be rude.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00103'));
sleep(10);

// Dr. Truman : He's right though... It's almost as if they're connected.
dprint ("Dr. Truman: He's right though... It's almost as if they're connected.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00104'));
sleep(10);

// Dr. Truman : I'm going to take a closer look at this.
dprint ("Dr. Truman: I'm going to take a closer look at this.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_closer_look_00105'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

object_destroy (dc_power_source_1);

end

script static void vo_e9m1_turrets_02()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_turrets");
music_set_state('Play_mus_pve_e09m1_turrets');

// Roland : Crimson, you’ve got a power source there that should activate a defense system.
dprint ("Roland: Crimson, you’ve got a power source there that should activate a defense system.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00200'));
sleep(10);

// Miller: Turn their toys against them? Good plan, Roland. Make it happen, Crimson.
dprint ("Miller: Turn their toys against them? Good plan, Roland. Make it happen, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00201', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00201'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e9m1_turrets()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_turrets");
music_set_state('Play_mus_pve_e09m1_turrets');

// Miller : Crimson, what did you do? Why did those turrets just come online?
dprint ("Miller: Crimson, what did you do? Why did those turrets just come online?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00100'));
sleep(10);

// Roland : Crimson didn't do anything.
dprint ("Roland: Crimson didn't do anything.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00101'));
sleep(10);

//sleep_until (LevelEventStatus ("heretheycome"), 1);

// Miller : And they're shooting the bad guys instead of us? That's... weird.
dprint ("Miller: And they're shooting the bad guys instead of us? That's... weird.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_turrets_00102'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_hold_them_off()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_hold_them_off");
music_set_state('Play_mus_pve_e09m1_hold_them_off');

// Miller : Doctor Truman, any luck?
dprint ("Miller: Doctor Truman, any luck?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00100'));
sleep(10);

// Dr. Truman : This is weird. It looks like someone is trying to help me decrypt the comm stream.
dprint ("Dr. Truman: This is weird. It looks like someone is trying to help me decrypt the comm stream.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00101'));
sleep(10);

// Miller : Roland? Are you helping Doctor Truman?
dprint ("Miller: Roland? Are you helping Doctor Truman?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00102'));
sleep(10);

// Roland : Nope. But she's right. There's a secondary encryption cracker working from the inside out.
dprint ("Roland: Nope. But she's right. There's a secondary encryption cracker working from the inside out.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00103'));
sleep(10);

// Roland : Something is definitely helping her along.
dprint ("Roland: Something is definitely helping her along.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00104'));
sleep(10);

// Miller : Keep an eye on it for me, Roland.
dprint ("Miller: Keep an eye on it for me, Roland.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00105'));
sleep(10);

// Roland : Will do.
dprint ("Roland: Will do.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_hold_them_off_00106'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_weird()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_weird");
music_set_state('Play_mus_pve_e09m1_weird');

// Dr. Truman : Spartan Miller, the encryption is ninety-nine percent cracked.
dprint ("Dr. Truman: Spartan Miller, the encryption is ninety-nine percent cracked.");
start_radio_transmission("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_weird_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_weird_00100'));
sleep(10);

// Miller : How long till you're done?
dprint ("Miller: How long till you're done?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_weird_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_weird_00101'));
sleep(10);

// Dr. Truman : No. It's stuck at ninety nine. But the frequency modulation that Roland identified is stalled as well.
dprint ("Dr. Truman: No. It's stuck at ninety nine. But the frequency modulation that Roland identified is stalled as well.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_weird_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_weird_00102'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_power_up()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_power_up");
music_set_state('Play_mus_pve_e09m1_power_up');

// Roland : Doc, what do you think would happen if Crimson flips the breaker there and opens up that power source?
dprint ("Roland: Doc, what do you think would happen if Crimson flips the breaker there and opens up that power source?");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_up_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_up_00100'));
sleep(10);

// Miller : Is that wise?
dprint ("Miller: Is that wise?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_up_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_up_00103'));
sleep(10);

// Roland : Sure. Why not?
dprint ("Roland: Sure. Why not?");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_up_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_power_up_00104'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_sentinels()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_sentinels");
music_set_state('Play_mus_pve_e09m1_sentinels');

// Dr. Truman : Sentinels?!
dprint ("Dr. Truman: Sentinels?!");
start_radio_transmission("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_sentinels_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_sentinels_00100'));
sleep(10);

// Roland : I think I know what was helping crack the comm stream.
dprint ("Roland: I think I know what was helping crack the comm stream.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_sentinels_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_sentinels_00101'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_allies()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_allies");
music_set_state('Play_mus_pve_e09m1_allies');

// Miller : Crimson! I think the Sentinels are helping you?
dprint ("Miller: Crimson! I think the Sentinels are helping you?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_allies_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_allies_00100'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_follow_sentinels()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_sentinels");
music_set_state('Play_mus_pve_e09m1_sentinels');

// Miller : Where are they going?
dprint ("Miller: Where are they going?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_follow_sentinels_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_follow_sentinels_00100'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_beam_on()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_beam_on");
music_set_state('Play_mus_pve_e09m1_beam_on');

// Miller : Doctor Truman! Analysis?
dprint ("Miller: Doctor Truman! Analysis?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_beam_on_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_beam_on_00100'));
sleep(10);

// Dr. Truman : Massive energy output. It's a data stream, but too much too fast to analyze
dprint ("Dr. Truman: Massive energy output. It's a data stream, but too much too fast to analyze");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_beam_on_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_beam_on_00101'));
/*sleep(10);

// Roland : There's several octillion geopbytes of data flying out of there every millisecond. I can't even get viable samples of the stuff.
dprint ("Roland: There's several octillion geopbytes of data flying out of there every millisecond. I can't even get viable samples of the stuff.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_beam_on_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_beam_on_00102'));*/

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e9m1_backup()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_backup");
music_set_state('Play_mus_pve_e09m1_backup');

// Miller : Roland, what about our trace on the Halsey comms?

dprint ("Miller: Roland, what about our trace on the Halsey comms?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00200'));
sleep(10);

// Roland : Good to go any time. Boa Squad’s ready and waiting for Crimson’s help.

dprint ("Roland : Good to go any time. Boa Squad’s ready and waiting for Crimson’s help.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00201', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00201'));
sleep(10);

// Miller : Tell the Marines Crimson are inbound. Spartans, get to the LZ. Let’s see where this trace leads 

dprint ("Miller : Tell the Marines Crimson are inbound. Spartans, get to the LZ. Let’s see where this trace leads ");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00202', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00202'));
sleep(10);


/*// Dalton : Miller.
dprint ("Dalton: Miller.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00100'));
sleep(10);

// Miller : Go ahead, Dalton.
dprint ("Miller: Go ahead, Dalton.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00101'));
sleep(10);

// Dalton : We've got marine squad Boa calling for backup. Crimson's the closest team to their location, if you can spare them.
dprint ("Dalton: We've got marine squad Boa calling for backup. Crimson's the closest team to their location, if you can spare them.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00102a', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00102a'));
sleep(10);

// Miller : You got a ride for them?
dprint ("Miller: You got a ride for them?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00103'));
sleep(10);

// Dalton : Already on station.
dprint ("Dalton: Already on station.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00104'));
sleep(10);

// Miller : Doctor Truman, you keep an eye on that databeam.
dprint ("Miller: Doctor Truman, you keep an eye on that databeam.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00105'));
sleep(10);

// Dr. Truman : Of course.
dprint ("Dr. Truman: Of course.");
cui_hud_show_radio_transmission_hud("e9_m1_truman_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00106'));
sleep(10);
*/
// Miller : Crimson, prep for pickup.
dprint ("Miller: Crimson, prep for pickup.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00107', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_backup_00107'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end



script static void vo_e9m1_extradialog_01()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_sentinels");
music_set_state('Play_mus_pve_e09m1_sentinels');

// Miller : They’ve gotten inside, Crimson! Watch out!
dprint ("Miller: They’ve gotten inside, Crimson! Watch out!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00100'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e9m1_extradialog_02()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_sentinels");
music_set_state('Play_mus_pve_e09m1_sentinels');

// Miller : They're flanking you!
dprint ("Miller: They're flanking you!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00101'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e9m1_extradialog_03()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_sentinels");
music_set_state('Play_mus_pve_e09m1_sentinels');


// Miller : Crimson, the defense turrets are under attack. Clear them off.
dprint ("Miller: Crimson, the defense turrets are under attack. Clear them off.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00102'));
b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e9m1_extradialog_04()

b_e9m1_narrative_is_on = TRUE;
dprint("Play_mus_pve_e09m1_sentinels");
music_set_state('Play_mus_pve_e09m1_sentinels');

// Miller : Defense turret down! Not destroyed though... You should be able to reactivate it.
dprint ("Miller: Defense turret down! Not destroyed though... You should be able to reactivate it.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_extradialog_00103'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_Librarian_transmission()

b_e9m1_narrative_is_on = TRUE;


// Librarian: ...to the Absolute Record...
dprint ("Librarian: ...to the Absolute Record...");

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_Librarian_transmission_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_01\e09m1_Librarian_transmission_00100'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end





script static void vo_ready_to_fly()

b_e9m1_narrative_is_on = TRUE;


// Murphy: Holding position until you're ready to fly, Crimson.
dprint ("Murphy: Holding position until you're ready to fly, Crimson.");

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_pickup_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_pickup_01'));

b_e9m1_narrative_is_on = FALSE;
end_radio_transmission();

end

// ============================================	MISC SCRIPT	========================================================