//=============================================================================================================================
//============================================ E7M5 ENGINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e7m5_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e7m5_clean_stragglers()

b_e7m5_narrative_is_on = TRUE;

// Miller : We've got the ship on lockdown, the guns firing, and the engine room secure. Time to clean up the stragglers, Crimson.
dprint ("Miller: We've got the ship on lockdown, the guns firing, and the engine room secure. Time to clean up the stragglers, Crimson.");
start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep7_m5_1_60" );
thread (pip_e7m5_stragglers_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_clean_stragglers_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e7m5_stragglers_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_clean_stragglers_00100');
end


script static void vo_e7m5_clear_area()

b_e7m5_narrative_is_on = TRUE;

// Miller : Clear the area of bad guys and move on.
dprint ("Miller: Clear the area of bad guys and move on.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_clear_area_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_clear_area_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_into_halls()

b_e7m5_narrative_is_on = TRUE;

// Miller : Let's get out in the halls and clear them as well.
dprint ("Miller: Let's get out in the halls and clear them as well.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_into_halls_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_into_halls_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_server_room()
//dprint("Play_mus_pve_e07m1_erver_room");
//music_set_state('Play_mus_pve_erver_room');
b_e7m5_narrative_is_on = TRUE;

// Roland : Spartan Miller, there's another -- admittedly pitiful -- attempt to get back into the server room.
dprint ("Roland: Spartan Miller, there's another -- admittedly pitiful -- attempt to get back into the server room.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_server_room_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_server_room_00100'));
sleep(10);

// Miller : Crimson, let's go show our friends why that's a bad idea.
dprint ("Miller: Crimson, let's go show our friends why that's a bad idea.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_server_room_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_server_room_00101'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_secure_server()

b_e7m5_narrative_is_on = TRUE;

// Miller : Give em hell, Crimson!
dprint ("Miller: Give em hell, Crimson!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_secure_server_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_secure_server_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_towards_hangar()
//dprint("Play_mus_pve_e07m1_towards_hangar");
//music_set_state('Play_mus_pve_towards_hangar');
b_e7m5_narrative_is_on = TRUE;

// Miller : Back out in the halls, Crimson. Lets head back towards the hangar.
dprint ("Miller: Back out in the halls, Crimson. Lets head back towards the hangar.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00100'));
sleep(10);

/*// Roland : Spartan Miller, there's a massive reduction in enemy forces in Crimson's area.
dprint ("Roland: Spartan Miller, there's a massive reduction in enemy forces in Crimson's area.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00101'));
sleep(10);

// Miller : Because Crimson have shot most of them!
dprint ("Miller: Because Crimson have shot most of them!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00102'));
sleep(10);

// Roland : That is one possible explanation.
dprint ("Roland: That is one possible explanation.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_towards_hangar_00103'));*/

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_open_bulkhead()

b_e7m5_narrative_is_on = TRUE;

// Miller : Crimson, open those doors to get access to the hangar hallway.
dprint ("Miller: Crimson, open those doors to get access to the hangar hallway.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_open_bulkhead_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_open_bulkhead_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_hunters()

b_e7m5_narrative_is_on = TRUE;

// Miller : Hunters!
dprint ("Miller: Hunters!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_00100'));
//sleep(10);

/*// Roland : And there's the OTHER possible explanation for where all the bad guys went. They were running, Spartan Miller.
dprint ("Roland: And there's the OTHER possible explanation for where all the bad guys went. They were running, Spartan Miller.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_00101'));
sleep(10);

// Miller : Well, Crimson's not going to run!
dprint ("Miller: Well, Crimson's not going to run!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_00102'));*/

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_hunters_down()

b_e7m5_narrative_is_on = TRUE;

// Miller : See? Nothing to worry about. Let's get back to the hangar bay and confirm lockdown.
dprint ("Miller: See? Nothing to worry about. Let's get back to the hangar bay and confirm lockdown.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_hunters_down_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_entering_hangar()
//dprint("Play_mus_pve_e07m1_hangar_hunters");
//music_set_state('Play_mus_pve_e07m1_hangar_hunters');
b_e7m5_narrative_is_on = TRUE;

// Miller : All quiet. Crimson wins the day.
dprint ("Miller: All quiet. Crimson wins the day.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00100'));
sleep(10);

// Roland : Spartan?
dprint ("Roland: Spartan?");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00101'));
sleep(10);

// Miller : Excellent work as ever, Spartans.
dprint ("Miller: Excellent work as ever, Spartans.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00102'));
sleep(10);

// Roland : Spartan Miller.
dprint ("Roland: Spartan Miller.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00103'));
sleep(10);

// Miller : What is it, Rol-- HUNTERS?!
dprint ("Miller: What is it, Rol-- HUNTERS?!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00104'));
sleep(10);

// Roland : Lots of them.
dprint ("Roland: Lots of them.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_entering_hangar_00105'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_kill_them()

b_e7m5_narrative_is_on = TRUE;

// Miller : Crimson, I know this looks nuts, but you can do this.
dprint ("Miller: Crimson, I know this looks nuts, but you can do this.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_kill_them_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_kill_them_00100'));
sleep(10);

// Roland : They can?!
dprint ("Roland: They can?!");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_kill_them_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_kill_them_00101'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_they_fight()

b_e7m5_narrative_is_on = TRUE;

// Roland : Spartan Miller, I admire your optimism, but Crimson's worse than outnumbered.
dprint ("Roland: Spartan Miller, I admire your optimism, but Crimson's worse than outnumbered.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_they_fight_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_they_fight_00100'));
sleep(10);

// Miller : Crimson, I'm marking the safety override controls for the hangar shielding. You can cut this fight short.
dprint ("Miller: Crimson, I'm marking the safety override controls for the hangar shielding. You can cut this fight short.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_they_fight_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_they_fight_00102'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_overrides_down()
//dprint("Play_mus_pve_e07m1_overrides_down");
//music_set_state('Play_mus_pve_e07m1_overrides_down');
b_e7m5_narrative_is_on = TRUE;

// Miller : Okay, now fall back to the control room and open the hangar doors!
dprint ("Miller: Okay, now fall back to the control room and open the hangar doors!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_overrides_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_overrides_down_00100'));
sleep(10);

// Roland : You're spacing them?! genius tactical work, Spartan Miller!
dprint ("Roland: You're spacing them?! genius tactical work, Spartan Miller!");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_overrides_down_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_overrides_down_00101'));
sleep(10);

// Miller : Thanks, Roland.
dprint ("Miller: Thanks, Roland.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_overrides_down_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_overrides_down_00102'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_doors_activated()
//dprint("Play_mus_pve_e07m1_activated");
//music_set_state('Play_mus_pve_e07m1_activated');
b_e7m5_narrative_is_on = TRUE;

// Roland : Hangar doors are opening. Here comes the massive atmospheric loss.
dprint ("Roland: Hangar doors are opening. Here comes the massive atmospheric loss.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_doors_activated_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_doors_activated_00100'));
sleep(10);

// Miller : Don’t worry, Crimson! Your mag boots will keep you from being pulled out with the Hunters.
dprint ("Miller: Don’t worry, Crimson! Your mag boots will keep you from being pulled out with the Hunters.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_doors_activated_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_doors_activated_00101'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_we_win()

b_e7m5_narrative_is_on = TRUE;

// Roland : Hangar's clear. Sealing the doors and normalizing life support in the area.
dprint ("Roland: Hangar's clear. Sealing the doors and normalizing life support in the area.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_we_win_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_we_win_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_safety_override()

b_e7m5_narrative_is_on = TRUE;

// Miller : Crimson, you don't have to go toe to toe with these guys. I've got a solution to make this way easier on you.
dprint ("Miller: Crimson, you don't have to go toe to toe with these guys. I've got a solution to make this way easier on you.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_safety_override_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_safety_override_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_open_door()

b_e7m5_narrative_is_on = TRUE;

// Miller : Just turning off the safety override wasn't enough. You'll need to open the hangar doors for the plan to work.
dprint ("Miller: Just turning off the safety override wasn't enough. You'll need to open the hangar doors for the plan to work.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_open_door_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_open_door_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_shot_up()

b_e7m5_narrative_is_on = TRUE;

// Miller : That was really something else, Crimson.
dprint ("Miller: That was really something else, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_shot_up_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_shot_up_00100'));
sleep(10);

// Roland : Even for Spartans, the dedication to shooting things was... impressive.
dprint ("Roland: Even for Spartans, the dedication to shooting things was... impressive.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_shot_up_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_shot_up_00101'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_you_win()
//dprint("Play_mus_pve_e07m1_you_win");
//music_set_state('Play_mus_pve_e07m1_you_win');
b_e7m5_narrative_is_on = TRUE;

// Miller : That's that. Crimson, you've got that corner of Infinity secured. Great work. We're gonna win this thing yet.
dprint ("Miller: That's that. Crimson, you've got that corner of Infinity secured. Great work. We're gonna win this thing yet.");
start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep7_m5_2_60" );
thread (pip_e7m5_win_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_you_win_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e7m5_win_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_you_win_00100');
end


script static void vo_e7m5_infinity_01()
//dprint("Play_mus_pve_e07m1_you_win");
//music_set_state('Play_mus_pve_e07m1_you_win');
b_e7m5_narrative_is_on = TRUE;

// Infinity System Voice : Alert. Hull breach on multiple decks. 5% incursion rate. Secured decks, please indicate status to Infinity Ops immediately.
dprint ("Infinity System Voice: Alert. Hull breach on multiple decks. 5% incursion rate. Secured decks, please indicate status to Infinity Ops immediately.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_infinity_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_infinity_00100'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m5_infinity_02()
//dprint("Play_mus_pve_e07m1_you_win");
//music_set_state('Play_mus_pve_e07m1_you_win');
b_e7m5_narrative_is_on = TRUE;

// Infinity System Voice : Spartan Fireteam Lancer. Please report to Translight Deck 19 Dash 7. for reinforcement of Fireteam Crimson.
dprint ("Infinity System Voice: Spartan Fireteam Lancer. Please report to Translight Deck 19 Dash 7. for reinforcement of Fireteam Crimson.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_infinity_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_infinity_00101'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m5_infinity_03()
//dprint("Play_mus_pve_e07m1_you_win");
//music_set_state('Play_mus_pve_e07m1_you_win');
b_e7m5_narrative_is_on = TRUE;

// Infinity System Voice : After-action procedures should not be initiated until Condition Yellow status is confirmed.Attention all crew heads.
dprint ("Infinity System Voice: After-action procedures should not be initiated until Condition Yellow status is confirmed.Attention all crew heads.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_infinity_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_05\e07m5_infinity_00102'));

b_e7m5_narrative_is_on = FALSE;
end_radio_transmission();

end



// ============================================	MISC SCRIPT	========================================================