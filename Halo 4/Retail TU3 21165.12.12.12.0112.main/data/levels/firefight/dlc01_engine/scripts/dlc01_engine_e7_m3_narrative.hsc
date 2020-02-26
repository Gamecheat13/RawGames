//=============================================================================================================================
//============================================ E7M3 ENGINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_e7m3_narrative_is_on = FALSE;
global boolean e7m3_blipdoor01 = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================


script static void vo_e7m3_playstart()
//dprint("Play_mus_pve_e07m3_playstart");
//music_set_state('Play_mus_pve_e07m3_playstart');
b_e7m3_narrative_is_on = TRUE;

// Roland : We've got bad guys all over the ship, but now we've got them in the engine room, too.
dprint ("Roland: We've got bad guys all over the ship, but now we've got them in the engine room, too.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_playstart_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_playstart_00100'));
sleep(10);

// Roland : They're yelling about holy technology and death to the heathens.
dprint ("Roland: They're yelling about holy technology and death to the heathens.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_playstart_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_playstart_00200'));
sleep(10);

// Miller : Get moving, Crimson.  You're the only people I can count on in that corner of the ship.
dprint ("Miller: Get moving, Crimson.  You're the only people I can count on in that corner of the ship.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep7_m3_1_60" );
thread (pip_e7m3_playstart_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_playstart_00400'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e7m3_playstart_subtitles()
	dialog_play_subtitle ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_playstart_00400');
end


script static void vo_e7m3_firstalert()
//dprint("Play_mus_pve_e07m3_firstalert");
//music_set_state('Play_mus_pve_e07m3_firstalert');
b_e7m3_narrative_is_on = TRUE;

// Miller : Uh oh. Covies have infiltrated the server room again. We just got that place sorted.  I don't want them opening the bay doors again--
dprint ("Miller: Uh oh. Covies have infiltrated the server room again. We just got that place sorted.  I don't want them opening the bay doors again--");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_firstalert_00700', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_firstalert_00700'));
sleep(10);

// Roland : But bad guys in the engine room want to blow us all up.
// dprint ("Roland: But bad guys in the engine room want to blow us all up.");
// cui_hud_show_radio_transmission_hud("roland_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_firstalert_00800', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_firstalert_00800'));
// sleep(10);

// Miller : Crimson you have to be quick.  I'm changing your waypoint.  Get to the server room, NOW.
dprint ("Miller: Crimson you have to be quick.  I'm changing your waypoint.  Get to the server room, NOW.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_firstalert_00900', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_firstalert_00900'));

e7m3_blipdoor01 = TRUE;
f_blip_object (dm_door_6, default);
b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_getintheserver()
dprint("Play_mus_pve_e7m3_getintheserver");
music_set_state('Play_mus_pve_e7m3_getintheserver');
b_e7m3_narrative_is_on = TRUE;

// Miller : Server room is right there.
dprint ("Miller: Server room is right there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_getintheserver_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_getintheserver_00100'));
sleep(10);

//	// Miller : Looks like the door's sealed up tight, but I've pinged the controls for you.
//	dprint ("Miller: Looks like the door's sealed up tight, but I've pinged the controls for you.");
//	start_radio_transmission("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_near_door_00100', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_02\e10m2_near_door_00100'));


b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_enterserver()
//dprint("Play_mus_pve_e07m3_enterserver");
//music_set_state('Play_mus_pve_e07m3_enterserver');
b_e7m3_narrative_is_on = TRUE;

// Miller : Roland, is that what it looks like?
dprint ("Miller: Roland, is that what it looks like?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00100'));
sleep(10);

// Roland : Warhead.  Havok class.  On the up side, we've solved the mystery of where those stolen warheads went.
dprint ("Roland: Warhead.  Havok class.  On the up side, we've solved the mystery of where those stolen warheads went.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00200'));
sleep(10);

// Miller : Crimson, secure the room.
dprint ("Miller: Crimson, secure the room.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00300'));
sleep(10);

// Miller : Roland, can you disarm that warhead?
dprint ("Miller: Roland, can you disarm that warhead?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00400'));
sleep(10);

// Roland : Spartan Miller; I'm good, but I'm not telekinetic.
// dprint ("Roland: Spartan Miller; I'm good, but I'm not telekinetic.");
// cui_hud_show_radio_transmission_hud("roland_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00500', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00500'));
// sleep(10);

// Roland : There's no remote detonator on the device for me to hack.
dprint ("Roland: There's no remote detonator on the device for me to hack.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00600'));
sleep(10);

// Roland : Crimson's got to do things the old-fashioned way.
dprint ("Roland: Crimson's got to do things the old-fashioned way.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00700', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_enterserver_00700'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_duringfight()

b_e7m3_narrative_is_on = TRUE;

// Roland : Spartan Miller, I've got all the security feeds on the ship.
dprint ("Roland: Spartan Miller, I've got all the security feeds on the ship.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_duringfight_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_duringfight_00100'));
sleep(10);

// Roland : It worries me I couldn't see they had this nuke.
dprint ("Roland: It worries me I couldn't see they had this nuke.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_duringfight_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_duringfight_00200'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_fightending()
//dprint("Play_mus_pve_e07m3_fightending");
//music_set_state('Play_mus_pve_e07m3_fightending');
b_e7m3_narrative_is_on = TRUE;

// e7m3_marine_01 : Sargent Velasco to all channels! Engine room's overrun! We're not going to be able to hold this place together too much longer!
dprint ("e7m3_marine_01: Sargent Velasco to all channels! Engine room's overrun! We're not going to be able to hold this place together too much longer!");
cui_hud_show_radio_transmission_hud("e7m3_marine_01_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00100_soundstory', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00100_soundstory'));
sleep(10);

//// e07m3_marine_01 : Sargeant Velasco to all channels!  Engine room's overrun!
//dprint ("e07m3_marine_01: Sargeant Velasco to all channels!  Engine room's overrun!");
//start_radio_transmission("incoming_transmission");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00100', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00100'));
//sleep(10);
//
//// e07m3_marine_01 : We're not going to be able to hold this place together too much longer!
//dprint ("e07m3_marine_01: We're not going to be able to hold this place together too much longer!");
//cui_hud_show_radio_transmission_hud("incoming_transmission");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00200', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00200'));
//sleep(10);

// Miller : Keep it together, Marine!  Spartans are on their way!
dprint ("Miller: Keep it together, Marine!  Spartans are on their way!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00300'));
sleep(10);

// e07m3_marine_01 : Well, they'd better hurry.  The hinge-heads are bringing --
dprint ("e07m3_marine_01: Well, they'd better hurry.  The hinge-heads are bringing --");
cui_hud_show_radio_transmission_hud("e7m3_marine_01_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00400'));
sleep(10);

// Miller : Crimson, anything you can do to get the server room secured QUICKLY is much appreciated.
// dprint ("Miller: Crimson, anything you can do to get the server room secured QUICKLY is much appreciated.");
// cui_hud_show_radio_transmission_hud("miller_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00500', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00500'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_fightending_RVBALT()
dprint("Play_mus_pve_e07m1_fightending");
music_set_state('Play_mus_pve_e07m1_fightending');
b_e7m3_narrative_is_on = TRUE;

// Simmons: Private Simmons to Command! There was a huge firefight down here and the engine is all shot up! I need maintenance ASAP!
dprint ("Simmons: Private Simmons to Command! There was a huge firefight down here and the engine is all shot up! I need maintenance ASAP!");
//cui_hud_show_radio_transmission_hud("e7_m3_private_simmons_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_rvb_simmons_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_rvb_simmons_00100'));
sleep(10);


// Miller : Keep it together, Marine!  Spartans are on their way!
dprint ("Miller: Keep it together, Marine!  Spartans are on their way!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00300'));
sleep(10);

// Simmons: Oh great! More people with guns. I’m sure THAT will fix the engine.
dprint ("Simmons: Oh great! More people with guns. I’m sure THAT will fix the engine.");
//cui_hud_show_radio_transmission_hud("e7_m3_private_simmons_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_rvb_simmons_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_rvb_simmons_00200'));
sleep(10);

// Miller : Crimson, anything you can do to get the server room secured QUICKLY is much appreciated.
// dprint ("Miller: Crimson, anything you can do to get the server room secured QUICKLY is much appreciated.");
// cui_hud_show_radio_transmission_hud("miller_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00500', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_fightending_00500'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_disarmbomb()

b_e7m3_narrative_is_on = TRUE;

// Miller : Room's clear.
dprint ("Miller: Room's clear.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00100'));
sleep(10);

// Roland : Crimson, I'm sending disarm instructions to your HUD.
dprint ("Roland: Crimson, I'm sending disarm instructions to your HUD.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00200'));
sleep(10);

// Roland : Very primitive timer in the wiring.
// dprint ("Roland: Very primitive timer in the wiring.");
// cui_hud_show_radio_transmission_hud("roland_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00300', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00300'));
// sleep(10);

// Roland : Lucky for us, they hadn't primed it yet.
dprint ("Roland: Lucky for us, they hadn't primed it yet.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmbomb_00400'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_disarmed()
//dprint("Play_mus_pve_e07m3_disarmed");
//music_set_state('Play_mus_pve_e07m3_disarmed');
b_e7m3_narrative_is_on = TRUE;

// Miller : Did it work?  Are we okay?
dprint ("Miller: Did it work?  Are we okay?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmed_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmed_00100'));
sleep(10);

// Roland : Everything in the area wasn't reduced to its component molecules, so I'm gonna say…yes?
dprint ("Roland: Everything in the area wasn't reduced to its component molecules, so I'm gonna say…yes?");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmed_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmed_00200'));
sleep(10);

// Miller : Back on the road to the engine room then.  Let's go, Spartan!
dprint ("Miller: Back on the road to the engine room then.  Let's go, Spartan!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmed_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_disarmed_00300'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_2ndbomb1()

b_e7m3_narrative_is_on = TRUE;
start_radio_transmission( "miller_transmission_name" );
	
// Miller : There's a weird power reading nearby...
dprint ("Miller: There's a weird power reading nearby...");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00100'));
sleep(10);

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end
script static void vo_e7m3_2ndbomb2()

b_e7m3_narrative_is_on = TRUE;
start_radio_transmission( "roland_transmission_name" );
	
// Roland : Another nuke!  Why didn't I see it before?
dprint ("Roland: Another nuke!  Why didn't I see it before?");
//start_radio_transmission("roland_transmission_name");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbomb_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbomb_00100'));
sleep(10);

// Miller : Crimson, same drill.  Disarm that explosive!
dprint ("Miller: Crimson, same drill.  Disarm that explosive!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbomb_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbomb_00200'));
sleep(10);

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_2ndbomb3()

b_e7m3_narrative_is_on = TRUE;
start_radio_transmission( "roland_transmission_name" );
	
// Roland : Make it quick, okay?  There's a timer on this one, and it's primed.
dprint ("Roland: Make it quick, okay?  There's a timer on this one, and it's primed.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbomb_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbomb_00300'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_2ndbombfight()

b_e7m3_narrative_is_on = TRUE;

// Roland : Spartan Miller, I'm sincerely concerned about my inability to spot these threats.
dprint ("Roland: Spartan Miller, I'm sincerely concerned about my inability to spot these threats.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbombfight_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbombfight_00100'));
sleep(10);

// Roland : I see everything on the ship at all times.  Why can't I see this?
dprint ("Roland: I see everything on the ship at all times.  Why can't I see this?");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbombfight_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndbombfight_00200'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_2nddisarmed()
//dprint("Play_mus_pve_e07m3_2nddisarmed");
//music_set_state('Play_mus_pve_e07m3_2nddisarmed');
b_e7m3_narrative_is_on = TRUE;

// Miller : That did it!  Excellent work, Crimson.
dprint ("Miller: That did it!  Excellent work, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00100'));
sleep(10);

// Roland : Spartan Miller, I know why I couldn't see the bombs.
dprint ("Roland: Spartan Miller, I know why I couldn't see the bombs.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00200'));
sleep(10);

// Roland : They've been outfitted with active camouflage.
dprint ("Roland: They've been outfitted with active camouflage.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00300'));
sleep(10);

// Miller : How can you tell?
dprint ("Miller: How can you tell?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00400'));
sleep(10);

// Roland : Because when Crimson killed the Elite holding the remote, they appeared on my sensors.
dprint ("Roland: Because when Crimson killed the Elite holding the remote, they appeared on my sensors.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00500'));
sleep(10);

// Roland : Marking them now.
// dprint ("Roland: Marking them now.");
// cui_hud_show_radio_transmission_hud("roland_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00600', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00600'));
// sleep(10);


// Roland : Timers are all active.  They're set to all blow at once.
// dprint ("Roland: Timers are all active.  They're set to all blow at once.");
// cui_hud_show_radio_transmission_hud("roland_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00800', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00800'));
// sleep(10);

// Miller : Crimson!  Move!
dprint ("Miller: Crimson!  Move!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00900', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2nddisarmed_00900'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e07m3_1stnuke()
dprint("Play_mus_pve_e07m3_1stnuke_00100");
music_set_state('Play_mus_pve_e07m3_1stnuke_0010');
b_e7m3_narrative_is_on = TRUE;

// Miller : Nuke’s disarmed.
dprint ("Miller: Nuke’s disarmed.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_1stnuke_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_1stnuke_00100'));
sleep(10);

// Roland : It’s possible there’s others.
dprint ("Roland: It’s possible there’s others.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_1stnuke_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_1stnuke_00101'));

// Miller : Keep looking, Crimson.
dprint ("Miller: Keep looking, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_1stnuke_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_1stnuke_00102'));
sleep(10);

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e07m3_2ndnuke()
dprint("Play_mus_pve_e07m3_2ndnuke_00100");
music_set_state('Play_mus_pve_e07m3_2ndnuke_0010');
b_e7m3_narrative_is_on = TRUE;

// Roland : There’s another nuke.
dprint ("Roland: There’s another nuke.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndnuke_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndnuke_00100'));
sleep(10);

// Miller : Shut it down, Crimson.
dprint ("Miller: Shut it down, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndnuke_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_2ndnuke_00101'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e07m3_3rdnuke1()
dprint("Play_mus_pve_e07m3_3rdnuke_00100");
music_set_state('Play_mus_pve_e07m3_3rdnuke_0010');
b_e7m3_narrative_is_on = TRUE;

// Roland : Another havoc located. Marking it.
dprint ("Roland: Another havoc located. Marking it.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_3rdnuke_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_3rdnuke_00100'));
sleep(10);

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end
script static void vo_e07m3_3rdnuke2()
dprint("Play_mus_pve_e07m3_3rdnuke_00100");
music_set_state('Play_mus_pve_e07m3_3rdnuke_0010');
b_e7m3_narrative_is_on = TRUE;

// Miller : Nuke’s disarmed.
dprint ("Miller: Nuke’s disarmed.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_3rdnuke_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_3rdnuke_00101'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e07m3_4thnuke1()
dprint("Play_mus_pve_e07m3_4thnuke_00100");
music_set_state('Play_mus_pve_e07m3_4thnuke_0010');
b_e7m3_narrative_is_on = TRUE;

// Roland : Spartan Miller, there’s another nuke.
dprint ("Roland: Spartan Miller, there’s another nuke.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_4thnuke_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_4thnuke_00100'));
sleep(10);

// Miller : Get it, Crimson.
dprint ("Miller: Get it, Crimson.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_4thnuke_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_4thnuke_00101'));
sleep(10);

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e07m3_4thnuke2()
b_e7m3_narrative_is_on = TRUE;

// Roland : That’s it. Nuke disarmed.
dprint ("Roland: That’s it. Nuke disarmed.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_4thnuke_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_4thnuke_00102'));

// Miller : Excellent work!
dprint ("Miller: Excellent work!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_5thnuke_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_5thnuke_00100'));


b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e07m3_5thnuke()
dprint("Play_mus_pve_e07m3_5thnuke_00100");
music_set_state('Play_mus_pve_e07m3_5thnuke_00100');

b_e7m3_narrative_is_on = TRUE;

// Roland : Another havoc located. Marking it.
dprint ("Roland: Another havoc located. Marking it.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_5thnuke_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_5thnuke_00100'));


b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_nukeprogress_1()
//dprint("Play_mus_pve_e07m3_nukeprogress_1");
//music_set_state('Play_mus_pve_e07m3_nukeprogress_1');
b_e7m3_narrative_is_on = TRUE;

// Miller : That's one.  Keep it up.
// dprint ("Miller: That's one.  Keep it up.");
// start_radio_transmission("miller_transmission_name");
// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00100', NONE, 1);
// sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00100'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_nukeprogress_2()

b_e7m3_narrative_is_on = TRUE;

// Miller : Good work, Crimson.  Keep going.
dprint ("Miller: Good work, Crimson.  Keep going.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00200'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_nukeprogress_3()

b_e7m3_narrative_is_on = TRUE;

// Miller : Third one disarmed.  Almost there.
dprint ("Miller: Third one disarmed.  Almost there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00300'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_nukeprogress_4()

b_e7m3_narrative_is_on = TRUE;

// Miller : We've almost got this!  One to go!
dprint ("Miller: We've almost got this!  One to go!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00400', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00400'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_nukeprogress_5()

b_e7m3_narrative_is_on = TRUE;

// Miller : That's it!
dprint ("Miller: That's it!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00500'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_nukeprogress_6()

b_e7m3_narrative_is_on = TRUE;

// Roland : Confirmed.  All warheads disarmed!
dprint ("Roland: Confirmed.  All warheads disarmed!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_nukeprogress_00600'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_clearroom()

b_e7m3_narrative_is_on = TRUE;

// Miller : Secure the room, Crimson.
dprint ("Miller: Secure the room, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_clearroom_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_clearroom_00100'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e7m3_ending()
//dprint("Play_mus_pve_e07m1_ending");
//music_set_state('Play_mus_pve_e07m1_ending');
b_e7m3_narrative_is_on = TRUE;

// Miller : Roland, engine room's secured.  Who else could use Crimson's help?
dprint ("Miller: Roland, engine room's secured.  Who else could use Crimson's help?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_ending_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_ending_00100'));
sleep(10);

// Roland : Actually, the engine room could.  It's secure, but there's reinforcements en route.
dprint ("Roland: Actually, the engine room could.  It's secure, but there's reinforcements en route.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_ending_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_ending_00200'));
sleep(10);

// Miller : Hear that, Spartans?  Fortify positions as quickly as possible.  More bad guys headed your way.
dprint ("Miller: Hear that, Spartans?  Fortify positions as quickly as possible.  More bad guys headed your way.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep7_m3_2_60" );
thread (pip_e7m3_ending_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_ending_00300'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void pip_e7m3_ending_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_ending_00300');
end


script static void vo_e7m3_infinity_01()

b_e7m3_narrative_is_on = TRUE;

// Infinity System Voice : Attention. Spartan Fireteam Lancer, move to reinforce Fireteams Avalanche and Kodiak in Fore Armory Twelve-Seven.
dprint ("Infinity System Voice: Attention. Spartan Fireteam Lancer, move to reinforce Fireteams Avalanche and Kodiak in Fore Armory Twelve-Seven.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_infinity_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_infinity_00100'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_infinity_02()

b_e7m3_narrative_is_on = TRUE;


// Infinity System Voice : Warning. An unregistered fissile material has been detected on this deck. EOD teams have been alerted. Local crews are advised to move to minimum safe distance.
dprint ("Infinity System Voice: Warning. An unregistered fissile material has been detected on this deck. EOD teams have been alerted. Local crews are advised to move to minimum safe distance.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_infinity_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_infinity_00102'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e7m3_infinity_03()

b_e7m3_narrative_is_on = TRUE;


// Infinity System Voice : Priority alert. Covenant forces detected across Translight Engineering Bays. All available reaction teams are to respond immediately.
dprint ("Infinity System Voice: Priority alert. Covenant forces detected across Translight Engineering Bays. All available reaction teams are to respond immediately.");
start_radio_transmission("incoming_transmission");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_infinity_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_03\e07m3_infinity_00101'));

b_e7m3_narrative_is_on = FALSE;
end_radio_transmission();

end

// ============================================	MISC SCRIPT	========================================================