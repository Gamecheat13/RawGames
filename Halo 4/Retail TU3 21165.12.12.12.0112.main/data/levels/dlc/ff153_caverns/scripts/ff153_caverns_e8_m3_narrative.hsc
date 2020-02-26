//=============================================================================================================================
//============================================ E8M3 CAVERNS NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e8m3_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e8m3_assist_marines()
e8m3_narrative_is_on = TRUE;
dprint("Play_mus_pve_e08m3_assist_marines");
music_set_state('Play_mus_pve_e08m3_assist_marines');

// Miller : Fireteam Lancer, sitrep?
dprint ("Miller: Fireteam Lancer, sitrep?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_assist_marines_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_assist_marines_00100'));
sleep(10);

// 8-2 Spartan : Found a nest of Covies hiding in the caves. Wouldn’t mind a hand in clearing them out.
dprint ("8-2 Spartan: Found a nest of Covies hiding in the caves. Wouldn’t mind a hand in clearing them out.");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_assist_marines_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_assist_marines_00101'));
sleep(10);

// Palmer : Good find, Lancer. Crimson’s happy to help.
dprint ("Palmer: Good find, Lancer. Crimson’s happy to help.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_assist_marines_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_assist_marines_00102'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_cloaking_down()

dprint("Play_mus_pve_e08m3_cloaking_down");
music_set_state('Play_mus_pve_e08m3_cloaking_down');

e8m3_narrative_is_on = TRUE;

// Murphy : "Crimson is on the ground!"
dprint ("Murphy: Crimson is on the ground!");
start_radio_transmission("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_dropping_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_dropping_01'));
sleep(10);

// 8-2 Spartan : Covies have hooked active cammo to their shield generators.
dprint ("8-2 Spartan: Covies have hooked active cammo to their shield generators.");
start_radio_transmission("e8_m2_spartan_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00100'));
sleep(10);

// 8-2 Spartan : We can’t get in the cave until that shield comes down.
dprint ("8-2 Spartan: We can’t get in the cave until that shield comes down.");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00101'));
sleep(10);

// Palmer : Crimson, secure the area. Miller—
dprint ("Palmer: Crimson, secure the area. Miller—");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00102')-15);
//sleep(10);

// Miller : Already looking for a way to find those generators.
dprint ("Miller: Already looking for a way to find those generators.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_cloaking_down_00103'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_while_fighting()
e8m3_narrative_is_on = TRUE;
sound_impulse_start ('sound\environments\multiplayer\dlc1_caverns\fx\e08m3_sos_sfx_01', NONE, 1);
sleep_s(1);

// Miller : Hang on.. Commander Palmer. Remember that Morse code SOS? I just saw it again.
dprint ("Miller: Hang on.. Commander Palmer. Remember that Morse code SOS? I just saw it again.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_while_fighting_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_while_fighting_00100'));
sleep(10);

// Palmer : Unless you’ve got a solution to that mystery, I need you on bringing down the generators.
dprint ("Palmer: Unless you’ve got a solution to that mystery, I need you on bringing down the generators.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_while_fighting_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_while_fighting_00101'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_take_down_generators()
e8m3_narrative_is_on = TRUE;
// Miller : And, I’ve got it! The active cammo on the generators is controlled by that guy right there!
dprint ("Miller: And, I’ve got it! The active cammo on the generators is controlled by that guy right there!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_take_down_generators_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_take_down_generators_00100'));
sleep(10);
b_blip_leader = TRUE;

// Palmer : Take him out, Crimson!
dprint ("Palmer: Take him out, Crimson!");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_take_down_generators_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_take_down_generators_00101'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_target_down()

dprint("Play_mus_pve_e08m3_target_down");
music_set_state('Play_mus_pve_e08m3_target_down');

e8m3_narrative_is_on = TRUE;
// Miller : Target down! Shields are visible.
dprint ("Miller: Target down! Shields are visible.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_target_down_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_target_down_00100'));
sleep(10);

// Palmer : Crimson, kindly exercise extreme force on those shield generators.
dprint ("Palmer: Crimson, kindly exercise extreme force on those shield generators.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_target_down_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_target_down_00101'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_the_beach()

dprint("Play_mus_pve_e08m3_the_beach");
music_set_state('Play_mus_pve_e08m3_the_beach');

e8m3_narrative_is_on = TRUE;
// 8-2 Spartan : Crimson did it! Shield’s down!
dprint ("8-2 Spartan: Crimson did it! Shield’s down!");
start_radio_transmission("e8_m2_spartan_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_the_beach_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_the_beach_00100'));
sleep(10);

// Palmer : Lancer, Crimson’s got point. Follow them into the caves.
dprint ("Palmer: Lancer, Crimson’s got point. Follow them into the caves.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_the_beach_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_the_beach_00101'));
sleep(10);

// 8-2 Spartan : Affirmative, Commander!
dprint ("8-2 Spartan: Affirmative, Commander!");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_the_beach_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_the_beach_00102'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_make_noise()
e8m3_narrative_is_on = TRUE;
hud_play_pip_from_tag (levels\dlc\shared\binks\SP_G09_60);
// Miller : Looks like the door is shut tight. Lots of movement behind it though.
dprint ("Miller: Looks like the door is shut tight. Lots of movement behind it though.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_make_noise_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_make_noise_00100'));
sleep(10);

// Palmer : Crimson, get their attention and maybe they’ll come out to play.
dprint ("Palmer: Crimson, get their attention and maybe they’ll come out to play.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_make_noise_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_make_noise_00101'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_covenant_beach()


dprint("Play_mus_pve_e08m3_covenant_beach");
music_set_state('Play_mus_pve_e08m3_covenant_beach');

e8m3_narrative_is_on = TRUE;

// Miller : It worked! Covenant incoming!
dprint ("Miller: It worked! Covenant incoming!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_beach_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_beach_00100'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_into_cavern()
e8m3_narrative_is_on = TRUE;
// Miller : All clear to head inside the cavern. But keep your guard up.
dprint ("Miller: All clear to head inside the cavern. But keep your guard up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_into_cavern_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_into_cavern_00100'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_sos_again()
e8m3_narrative_is_on = TRUE;
sound_impulse_start ('sound\environments\multiplayer\dlc1_caverns\fx\e08m3_sos_sfx_01', NONE, 1);
sleep_s(1);
// Miller : Commander, whatever’s sending that Morse code, it’s in this cave.
dprint ("Miller: Commander, whatever’s sending that Morse code, it’s in this cave.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_sos_again_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_sos_again_00100'));
sleep(10);

// Palmer : Crimson, keep your eyes open.
dprint ("Palmer: Crimson, keep your eyes open.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_sos_again_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_sos_again_00101'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_found_spartans()
e8m3_narrative_is_on = TRUE;

dprint("Play_mus_pve_e08m3_found_spartans");
music_set_state('Play_mus_pve_e08m3_found_spartans');

// Miller : Commander, Crimson’s found something! It's Switchback!
dprint ("Miller: Commander, Crimson’s found something! It's Switchback!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00100'));
sleep(10);

// Palmer : Switchback?!
dprint ("Palmer: Switchback?!");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00101'));
sleep(10);

// Switchback Spartan (Male) : Commander Palmer, am I glad to hear your voice again. We’ve been sending SOS for awhile now.
dprint ("Switchback Spartan (Male): Commander Palmer, am I glad to hear your voice again. We’ve been sending SOS for awhile now.");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_switchback_male");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00102'));
sleep(10);

// Palmer : Spartan Gale. Where’s Spartan Costabile?
dprint ("Palmer: Spartan Gale. Where’s Spartan Costabile?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00103'));
sleep(10);

// Switchback Spartan (Male) : Covie got her, Commander
dprint ("Switchback Spartan (Male): Covie got her, Commander");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_switchback_male");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00104'));
sleep(10);

// Palmer : Understood, Spartan. What do you say we return the favor?
dprint ("Palmer: Understood, Spartan. What do you say we return the favor?");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00105'));
sleep(10);

// Switchback Spartan (Male) : Sounds like a hell of a plan, Commander.
dprint ("Switchback Spartan (Male): Sounds like a hell of a plan, Commander.");
cui_hud_show_radio_transmission_hud("e8_m2_spartan_switchback_male");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_found_spartans_00106'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end

script static void vo_e8m3_power_source()

dprint("Play_mus_pve_e08m3_power_source");
music_set_state('Play_mus_pve_e08m3_power_source');

e8m3_narrative_is_on = TRUE;

// Miller : Commander Palmer, call from Poker Squad. The marines have a wounded Elite, offering information if they let him live.
dprint ("Miller: Commander Palmer, call from Poker Squad. The marines have a wounded Elite, offering information if they let him live.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00100'));
sleep(10);

// Palmer : Depends how good the info is, I suppose.
dprint ("Palmer: Depends how good the info is, I suppose.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00101'));
sleep(10);

// Miller : He’s offering up a Covie listening post.
dprint ("Miller: He’s offering up a Covie listening post.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00102'));
sleep(10);

// Palmer : Listening post... That would explain how they’ve seen us coming recently...
dprint ("Palmer: Listening post... That would explain how they’ve seen us coming recently...");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00103'));
sleep(10);

// Palmer : Fine. Have Poker check it out, then make the deal.
dprint ("Palmer: Fine. Have Poker check it out, then make the deal.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00104'));
sleep(10);

// Miller : Aye, Commander.
dprint ("Miller: Aye, Commander.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_wounded_00105'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_detect_power_backwall()
e8m3_narrative_is_on = TRUE;
// Miller : Marking the power source for that shield wall now, Commander. Marking its control switch for Crimson.
dprint ("Miller: Marking the power source for that shield wall now, Commander.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_detect_power_backwall_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_detect_power_backwall_00100'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_flips_switch()
e8m3_narrative_is_on = TRUE;

// Palmer : Let's go, Crimson.
dprint ("Palmer: Let's go, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_05'));
sleep(10);

// Miller : Crimson, be careful you don't know what’s on the other side of that door.
dprint ("Miller: Crimson, be careful you don't know what’s on the other side of that door.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_flips_switch_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_flips_switch_00100'));


end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_covenant_prometheans()
e8m3_narrative_is_on = TRUE;
// Palmer : We have Covenant and Prometheans inbound, Crimson!
dprint ("Palmer: We have Covenant and Prometheans inbound, Crimson!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_prometheans_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_prometheans_00100'));
sleep(10);

// Palmer : Hold your ground and clear this position before moving on.
dprint ("Palmer: Hold your ground and clear this position before moving on.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_prometheans_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_prometheans_00101'));


end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_buffer()
e8m3_narrative_is_on = TRUE;

// Palmer : Miller, any thoughts on how to deactivate that power source?
dprint ("Palmer: Miller, any thoughts on how to deactivate that power source?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_prometheans_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_covenant_prometheans_00102'));
sleep(10);

// Miller : Just a moment...
dprint ("Miller: Just a moment...");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_buffer_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_buffer_00100'));



end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_power_location()
e8m3_narrative_is_on = TRUE;

// Miller : Looks like shield power is being routed through this location.
dprint ("Miller: Looks like shield power is being routed through this location.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_power_loc_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_power_loc_00100'));
sleep(10);

// Palmer : Crimson, hit it.
dprint ("Palmer: Crimson, hit it.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_power_location_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_power_location_00101'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_shut_down_power()


dprint("Play_mus_pve_e08m3_shut_down_power");
music_set_state('Play_mus_pve_e08m3_shut_down_power');

e8m3_narrative_is_on = TRUE;
// Miller : The shield wall's dropped, Commander!
dprint ("Miller: The shield wall's dropped, Commander!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_shut_down_power_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_shut_down_power_00100'));
sleep(10);

// Palmer : Time to go, Spartans. Head for the exit.
dprint ("Palmer: Time to go, Spartans. Head for the exit.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_shut_down_power_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_shut_down_power_00101'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_dropships()
e8m3_narrative_is_on = TRUE;
// Miller : Dropships inbound!
dprint ("Miller: Dropships inbound!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00100'));
sleep(10);

// Palmer : Clear the ground and we can get you out of there, Crimson.
dprint ("Palmer: Clear the ground and we can get you out of there, Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00101'));


end_radio_transmission();
e8m3_narrative_is_on = FALSE;

sleep_until(b_bring_in_murphy == TRUE);

e8m3_narrative_is_on = TRUE;

// Miller : There’s your ride home, Spartans.
dprint ("Miller: There’s your ride home, Spartans.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m4_pelican_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m4_pelican_00100'));
sleep(10);

// Murphy: I got your back Crimson!
dprint ("Murphy: I got your back Crimson!");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00101_1', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00101_1'));
sleep(10);

// Palmer : Excellent work.
dprint ("Palmer: Excellent work.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_07'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void vo_e8m3_switchback_home()
e8m3_narrative_is_on = TRUE;

dprint("Play_mus_pve_e08m3_switchback_home");
music_set_state('Play_mus_pve_e08m3_switchback_home');

// Miller : Pelican outbound with Fireteams Crimson and Switchback onboard, Commander Palmer.
dprint ("Miller: Pelican outbound with Fireteams Crimson and Switchback onboard, Commander Palmer.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_dropships_00102'));

// Palmer : Crimson, great work with Lancer. You guys brought Switchback home, and that is damn good work, folks.
dprint ("Palmer: Crimson, great work with Lancer. You guys brought Switchback home, and that is damn good work, folks.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ( 'sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_switchback_home_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_switchback_home_00100'));

end_radio_transmission();
e8m3_narrative_is_on = FALSE;
end


script static void pip_e8m3_switchbackhome_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_08_mission_03\e08m3_switchback_home_00100');
end


// ============================================	MISC SCRIPT	========================================================
