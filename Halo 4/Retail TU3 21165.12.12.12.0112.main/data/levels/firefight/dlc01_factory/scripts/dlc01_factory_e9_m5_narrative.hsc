//=============================================================================================================================
//============================================ E9M5 FACTORY NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e9m5_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================



// ============================================	MISC SCRIPT	========================================================

script static void vo_e9m5_narrative_in()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Crimson, hope you caught your breath. Because here come the bad guys.
dprint ("Miller: Crimson, hope you caught your breath. Because here come the bad guys.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00100'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_phantoms()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;
//dprint("Play_mus_pve_e09m5_narr_in");
//music_set_state('Play_mus_pve_e09m5_narr_in');

// Miller : Phantoms! Get to cover!
dprint ("Miller: Phantoms! Get to cover!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_phantoms_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_phantoms_00100'));
sleep(10);

// 9-5 Marine 1 : Spartans! Poker Squad here! We could use some backup.
dprint ("9-5 Marine 1: Spartans! Poker Squad here! We could use some backup.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00101'));
sleep(10);

// Miller : Understood, Marines. We'll be with you shortly.
dprint ("Miller: Understood, Marines. We'll be with you shortly.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00102'));
sleep(10);

// Miller : You're pretty popular today, Crimson. Everybody wants your attention.
dprint ("Miller: You're pretty popular today, Crimson. Everybody wants your attention.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_start_00103'));

sleep(12); // wait for a sec

// Roland : Spartan Miller?
dprint ("Roland: Spartan Miller?");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_phantoms_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_phantoms_00101'));
//sleep(10);

// Miller : Hold on a second, Roland.
dprint ("Miller: Hold on a second, Roland.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_phantoms_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_phantoms_00102'));
sleep(5);

sleep(1);  // wait for enemies to actually spawn

//dprint("Play_mus_pve_e09m5_prometheans");
//music_set_state('Play_mus_pve_e09m5_prometheans');

// Miller : Prometheans! Take 'em out, Crimson.
dprint ("Miller: Prometheans! Take 'em out, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_prometheans_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_prometheans_00100'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_garden1()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Poker Squad, how are you holding up?
dprint ("Miller: Poker Squad, how are you holding up?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_1_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_1_00100'));
sleep(10);

// 9-5 Marine 1 : We've got em held off, but could use some help if you can send it.
dprint ("9-5 Marine 1: We've got em held off, but could use some help if you can send it.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_1_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_1_00101'));
sleep(10);

// Miller : Be with you soon, Poker.
dprint ("Miller: Be with you soon, Poker.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_1_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_1_00102'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_garden2()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// 9-5 Marine 1 : Poker to Spartans. It's getting ugly in here.
dprint ("9-5 Marine 1: Poker to Spartans. It's getting ugly in here.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_srcure_area_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_srcure_area_00100'));
sleep(10);

// Miller : Almost there, Poker.
dprint ("Miller: Almost there, Poker.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_srcure_area_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_srcure_area_00101'));
sleep(10);

// Miller : Crimson, move a little quicker. Poker needs assistance ASAP.
dprint ("Miller: Crimson, move a little quicker. Poker needs assistance ASAP.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_srcure_area_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_srcure_area_00102'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_garden3()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Area secured? Nice.
dprint ("Miller: Area secured? Nice.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_open_door_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_open_door_00100'));
sleep(10);

// Miller : Miller to Poker Squad. Crimson's on their way.
dprint ("Miller: Miller to Poker Squad. Crimson's on their way.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_open_door_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_open_door_00101'));
sleep(10);

// 9-5 Marine 1 : Understood, Spartan. Looking forward to the company.
dprint ("9-5 Marine 1: Understood, Spartan. Looking forward to the company.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_open_door_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_open_door_00102'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_poker_squad_greeting()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Poker Squad Leader : Good to see you, Spartans! Welcome to the fun!
dprint ("Poker Squad Leader: Good to see you, Spartans! Welcome to the fun!");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_poker_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_poker_00100'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end





script static void vo_e9m5_donut()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m5_donut");
//music_set_state('Play_mus_pve_e09m5_donut');

// Roland : Spartan Miller -- this is really important. You've got a batch of Marines wandering around.
dprint ("Roland: Spartan Miller -- this is really important. You've got a batch of Marines wandering around.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00100'));
sleep(10);

// Miller : It's Poker Squad. They're just defending-
dprint ("Miller: It's Poker Squad. They're just defending-");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00101'));
sleep(10);

// Roland : No. These tags are for Hawk Squad.
dprint ("Roland: No. These tags are for Hawk Squad.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00102'));
sleep(10);

// Miller : Hawk? They're not assigned to this mission.
dprint ("Miller: Hawk? They're not assigned to this mission.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00103'));
sleep(10);

// Roland : Well, they're there.
dprint ("Roland: Well, they're there.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00104'));
sleep(10);

// Miller : I don't see any... Hey, you're right. What are they doing there?
dprint ("Miller: I don't see any... Hey, you're right. What are they doing there?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00106'));
sleep(10);

// Roland : Dunno. But thought you might like to get a look.
dprint ("Roland: Dunno. But thought you might like to get a look.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00107', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_donut_00107'));

// Miller : Spartan Miller to Hawk Squad.
dprint ("Miller: Spartan Miller to Hawk Squad.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00100'));
sleep(10);

// Miller : Marines?
dprint ("Miller: Marines?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00101'));
sleep(10);

// Miller : Hello?
dprint ("Miller: Hello?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00102'));
sleep(10);

// Miller : No response. Roland?
dprint ("Miller: No response. Roland?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00103'));
sleep(10);

// Roland : I got nothing, Spartan.
dprint ("Roland: I got nothing, Spartan.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_fight_more_00104'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_fight_more()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_donut_end()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Poker Squad, you have the situation in hand?
dprint ("Miller: Poker Squad, you have the situation in hand?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bottom_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bottom_00100'));
sleep(10);

// 9-5 Marine 1 : We do now. Thanks, Spartans.
dprint ("9-5 Marine 1: We do now. Thanks, Spartans.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bottom_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bottom_00101'));
sleep(10);

// Miller : Crimson, fall out to this position. Let's go find Hawk
dprint ("Miller: Crimson, fall out to this position. Let's go find Hawk");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bottom_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bottom_00102'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_interior1()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m5_way_up");
//music_set_state('Play_mus_pve_e09m5way_up');

// Miller : A moment, Crimson.
dprint ("Miller: A moment, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00100'));
sleep(10);

// Miller : Analyzing the maps of this area.
dprint ("Miller: Analyzing the maps of this area.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00101'));
sleep(10);

// Miller : Trying to figure out how Hawk got where they seem to be.
dprint ("Miller: Trying to figure out how Hawk got where they seem to be.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00102'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_interior2_PIP()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Okay. I think I've got it. There's a grav lift that we've never found a way to power on. Let's go have a look down here.
dprint ("Miller: Okay. I think I've got it. There's a grav lift that we've never found a way to power on. Let's go have a look down here.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep9_m5_1_60" );
thread (pip_e9m5_interior2_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00103'));
sleep_s(5);

// Miller : Roland, you got a second?
dprint ("Miller: Roland, you got a second?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00100'));
sleep(10);

// Roland : You have any idea how long a second is for an AI?
dprint ("Roland: You have any idea how long a second is for an AI?");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00101'));
sleep(10);

// Miller : Use Crimson's short range link to check out that control panel for me?
dprint ("Miller: Use Crimson's short range link to check out that control panel for me?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00102'));
sleep(30);

// Roland : Done.
dprint ("Roland: Done.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00103'));
sleep(5);

// Miller : That was quick.
dprint ("Miller: That was quick.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00104'));
sleep(17);

// Roland : For you, sure.
dprint ("Roland: For you, sure.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_podium_00105'));
sleep_s(1);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void pip_e9m5_interior2_subtitles()
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_way_up_00103');
end


script static void vo_e9m5_interior3()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;


// Miller : Crimson, fire it up. Let's see what happens.
dprint ("Miller: Crimson, fire it up. Let's see what happens.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_activate_lift_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_activate_lift_00100'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_up_the_gravlift()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Roland : Hawk's definitely at the top of that thing.
dprint ("Roland: Hawk's definitely at the top of that thing.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_activate_lift_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_activate_lift_00101'));
sleep(10);

// Miller : Climb aboard, Crimson.
dprint ("Miller: Climb aboard, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_activate_lift_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_activate_lift_00102'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_toptags1()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m5_top_of_lift");
//music_set_state('Play_mus_pve_e09m5_top_of_lift');

dprint("ROLAND - 'Triangulating Hawk's IFF locations to your heads up displays.'");
sleep_s(3);

// Miller : Oh no... Hawk…
dprint ("Miller: Oh no... Hawk…");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_top_of_lift_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_top_of_lift_00100'));
sleep(10);

// Roland : Not seeing anyone alive.
dprint ("Roland: Not seeing anyone alive.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_top_of_lift_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_top_of_lift_00101'));
//sleep(10);

// Miller : Crimson, double check. Sweep the area.
/*dprint ("Miller: Crimson, double check. Sweep the area.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_top_of_lift_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_top_of_lift_00102'));*/

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_crawlers()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Roland : Crawlers!
dprint ("Roland: Crawlers!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_crawlers_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_crawlers_00100'));
sleep(10);
/*
// Miller : Crimson, deal with them. I'm going to see what I can pull out of Hawk's IFF tags.
dprint ("Miller: Crimson, deal with them. I'm going to see what I can pull out of Hawk's IFF tags.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_crawlers_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_crawlers_00101'));
*/
end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_activate_easter_egg_tag()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);

	sound_impulse_start ('sound\ui\ui_iff_pickup_spops15_01', NONE, 1);
	sleep_s(2);

b_e9m5_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m5_as_you_fight");
//music_set_state('Play_mus_pve_e09m5_as_you_fight');


// Miller : Okay, got access to recording on a Hawk IFF tag. Playing it now.
dprint ("Miller: Okay, got access to recording on a Hawk IFF tag. Playing it now.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00100'));
sleep(10);
hud_play_pip_from_tag( "bink\Campaign\M60_A_60" );   
// Soundstory
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00101_soundstory', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00101_soundstory'));


//// 9-5 Elite 1 : Press the button!
dprint ("9-5 Elite 1: Press the button!");
cui_hud_show_radio_transmission_hud("incoming_transmission");
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00101');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00101'));
//sleep(10);

//// 9-5 Marine 1 : I don't understand!
dprint ("9-5 Marine 1: I don't understand!");
cui_hud_show_radio_transmission_hud("incoming_transmission");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00102');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00102'));
//sleep(10);

//// 9-5 Elite 1 : Prove you are a Reclaimer or die!
dprint ("9-5 Elite 1: Prove you are a Reclaimer or die!");
cui_hud_show_radio_transmission_hud("incoming_transmission");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00103');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00103'));
//sleep(10);

//// 9-5 Marine 2 : Nothing's happening.
dprint ("9-5 Marine 2: Nothing's happening.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00104');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00104'));
/*sleep(10);

//// 9-5 Elite 1 : (angry roar)
dprint ("9-5 Elite 1: (angry roar)");
cui_hud_show_radio_transmission_hud("incoming_transmission");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00105');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00105'));
sleep(10);

//// 9-5 Marine 2 : (screams as he dies)
dprint ("9-5 Marine 2: (screams as he dies)");
cui_hud_show_radio_transmission_hud("incoming_transmission");
dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00106');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00106'));
sleep(10);*/

// Miller : Roland. Translation.
dprint ("Miller: Roland. Translation.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00107', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00107'));
sleep(10);

// Roland : Elites were here... trying to find Reclaimers. Humans who can operate Forerunner technology.
dprint ("Roland: Elites were here... trying to find Reclaimers. Humans who can operate Forerunner technology.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00108', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00108'));

// Miller : See if you can find where the call bounces from here.
dprint ("Miller: See if you can find where the call bounces from here.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00100'));
sleep(10);

// Roland : This is it. Her call hit here, then bounced off into the Covenant battle net.
dprint ("Roland: This is it. Her call hit here, then bounced off into the Covenant battle net.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00101'));
sleep(10);

sleep_s(3);

// Miller : Running through the other IFF tags, it looks like the Elites were at this for a while.
dprint ("Miller: Running through the other IFF tags, it looks like the Elites were at this for a while.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00100'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_1stBlip()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Roland : Roland, mark one of the panels they were interested in. Crimson get a closer look.
dprint ("Roland: Roland, mark one of the panels they were interested in. Crimson get a closer look.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00101'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_1stActivation()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Roland : Um... something's happening.
dprint ("Roland: Um... something's happening.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_third_panel_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_third_panel_00100'));
sleep(10);

// Miller : Any idea what that panel actually did?
dprint ("Miller: Any idea what that panel actually did?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bad_guys_show_up_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bad_guys_show_up_00100'));
sleep(10);

// Roland : Nope. But it upset the locals pretty good.
dprint ("Roland: Nope. But it upset the locals pretty good.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bad_guys_show_up_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bad_guys_show_up_00101'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_2ndBlip()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Try the others. I want to know what the Elites were after.
dprint ("Miller: Try the others. I want to know what the Elites were after.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_first_panel_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_first_panel_00101'));
sleep(60);

// Roland : There's another panel over there.
dprint ("Roland: There's another panel over there.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bad_guys_show_up_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_bad_guys_show_up_00102'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_2ndActivation()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : That should do it.
dprint ("Miller: That should do it.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_03'));
end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_3rdBlip()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Roland : A final panel located.
dprint ("Roland: A final panel located.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_second_panel_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_second_panel_00100'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end


script static void vo_e9m5_3rdActivation()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Roland... what is this?
dprint ("Miller: Roland... what is this?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00100'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_MapBlip()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : What the hell. Let's do it, Crimson.
dprint ("Miller: What the hell. Let's do it, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_second_panel_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_second_panel_00101'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_outro()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e09m5_third_panel");
//music_set_state('Play_mus_pve_e09m5_third_panel');

// Roland : Looks kinda like Doctor Glassman's map. Let me get him on the line.
dprint ("Roland: Looks kinda like Doctor Glassman's map. Let me get him on the line.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00101'));

// Dr. Glassman : Glassman.
dprint ("Dr. Glassman: Glassman.");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00102'));
sleep(10);

// Roland : Hey, Doc. Got something you oughta see.
dprint ("Roland: Hey, Doc. Got something you oughta see.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00103'));
sleep(10);

// Dr. Glassman : What is this?
dprint ("Dr. Glassman: What is this?");
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00104'));
sleep(10);

// Roland : Well, if you combine it with the map Spartan Thorne found, I think it's the answer to all of our problems…
dprint ("Roland: Well, if you combine it with the map Spartan Thorne found, I think it's the answer to all of our problems…");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_narr_out_00105'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end




script static void vo_e9m5_as_you_fight_RRVBALT()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

dprint("Play_mus_pve_e09m5_as_you_fight");
music_set_state('Play_mus_pve_e09m5_as_you_fight');


// Miller : Okay, got access to recording on a Hawk IFF tag. Playing it now.
dprint ("Miller: Okay, got access to recording on a Hawk IFF tag. Playing it now.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00100'));
sleep(10);

// Soundstory
cui_hud_show_radio_transmission_hud("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100_soundstory', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100_soundstory'));
sleep(10);

//// 9-5 Elite 1 : Press the button!
//dprint ("9-5 Elite 1: Press the button!");
cui_hud_show_radio_transmission_hud("jul_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00101'));
sleep(10);
//
//// Church: Yeah, I have absolutely no idea what you just said.
//dprint ("Church: Yeah, I have absolutely no idea what you just said.");
//cui_hud_show_radio_transmission_hud("incoming_transmission");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100'));
//sleep(10);
//
//// 9-5 Elite 1 : Prove you are a Reclaimer or die!
//dprint ("9-5 Elite 1: Prove you are a Reclaimer or die!");
//cui_hud_show_radio_transmission_hud("jul_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00103', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00103'));
//sleep(10);
//
//// Church: Dude! Listen to me. I don’t speak alien.
//dprint ("Church: Dude! Listen to me. I don’t speak alien.");
//cui_hud_show_radio_transmission_hud("incoming_transmission");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00200', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00200'));
//sleep(10);
//
//// 9-5 Elite 1 : (angry roar)
//dprint ("9-5 Elite 1: (angry roar)");
//cui_hud_show_radio_transmission_hud("jul_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00105', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00105'));
//sleep(10);
//
//// Church: Dude! Listen to me. I don’t speak alien.
//dprint ("Church: Dude! Listen to me. I don’t speak alien.");
//cui_hud_show_radio_transmission_hud("incoming_transmission");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00300', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00300'));
//sleep(10);
//// Church : (screams as he dies)
//dprint ("Church: (screams as he dies)");
//cui_hud_show_radio_transmission_hud("incoming_transmission");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00400', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00400'));
//sleep(10);

// Miller : Roland. Translation.
dprint ("Miller: Roland. Translation.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00107', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00107'));
sleep(10);

// Roland : Elites were here... trying to find Reclaimers. Humans who can operate Forerunner technology.
dprint ("Roland: Elites were here... trying to find Reclaimers. Humans who can operate Forerunner technology.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00108', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_as_you_fight_2_00108'));

// Miller : See if you can find where the call bounces from here.
dprint ("Miller: See if you can find where the call bounces from here.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00100'));
sleep(10);

// Roland : This is it. Her call hit here, then bounced off into the Covenant battle net.
dprint ("Roland: This is it. Her call hit here, then bounced off into the Covenant battle net.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_halsey_stuff_00101'));
sleep(10);

sleep_s(3);

// Miller : Running through the other IFF tags, it looks like the Elites were at this for a while.
dprint ("Miller: Running through the other IFF tags, it looks like the Elites were at this for a while.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00100'));
sleep(10);

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_soundstory_rvbalt()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Running through the other IFF tags, it looks like the Elites were at this for a while.
dprint ("Miller: Running through the other IFF tags, it looks like the Elites were at this for a while.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100_soundstory', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100_soundstory'));
sleep(10);

// Roland : Roland, mark one of the panels they were interested in. Crimson get a closer look.
dprint ("Roland: Roland, mark one of the panels they were interested in. Crimson get a closer look.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00101'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end

script static void vo_e9m5_()
sleep_until(b_e9m5_narrative_is_on == FALSE,1);
b_e9m5_narrative_is_on = TRUE;

// Miller : Running through the other IFF tags, it looks like the Elites were at this for a while.
dprint ("Miller: Running through the other IFF tags, it looks like the Elites were at this for a while.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100_soundstory', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_rvb_church_00100_soundstory'));
sleep(10);

// Roland : Roland, mark one of the panels they were interested in. Crimson get a closer look.
dprint ("Roland: Roland, mark one of the panels they were interested in. Crimson get a closer look.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_05\e09m5_roland_explains_00101'));

end_radio_transmission();
b_e9m5_narrative_is_on = FALSE;
end