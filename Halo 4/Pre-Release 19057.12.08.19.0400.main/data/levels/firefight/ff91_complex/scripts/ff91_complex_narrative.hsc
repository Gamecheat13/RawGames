// =============================================================================================================================
//============COMPLEX NARRATIVE SCRIPT =======================================================
// =============================================================================================================================


// behold, the greatest narrative script ever to pass through the halls of 343...or 550...or whatever...it will be good anyway.

global object pup_player0 = player0;
global object pup_player1 = player1;
global object pup_player2 = player2;
global object pup_player3 = player3;


script startup sparops_e03_m02_main()
	
	dprint (":::  e3_m2 NARRATIVE SCRIPT  :::");
	
end


script static void ex1()
	//fires e3 m2 Narrative In scene
	
	ai_erase (sq_e3m2_intro_pelican);
	ai_erase (sq_e3m2_intro_marines);
	ai_place (sq_e3m2_intro_marines);
	
	pup_play_show(pup_e3_m2_in);
	
end


script static void ex2()
	//fires e3 m2 Narrative In scene
	
	ai_erase (sq_e4m5_scientists);
//	ai_place (sq_e4m5_scientists);
	
	pup_play_show(pup_e4_m5_in);
	
end


script command_script cs_e3m2_intro()
	// e3m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
//	cs_vehicle_speed (1.0); 
	
	cs_fly_by (ps_e3m2_pelican.p0);

end


// =============================================================================================================================
//=========COMPLEX E3 M2 VO SCRIPTS =======================================================
// =============================================================================================================================

global boolean b_dialog_playing = false;

script static void e3m2_vo_intro()
	// during intro
	
	sleep (90);
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson's on station, Commander
	dprint ("Miller: Crimson's on station, Commander");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00100'));
	
	sleep (30);

	// Palmer : You're coming in hot on Galileo Base.  There's Marines on the ground, but make no mistake, you're the cavalry.
	dprint ("Palmer: You're coming in hot on Galileo Base.  There's Marines on the ground, but make no mistake, you're the cavalry.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00200'));
	
//	sleep (10);
//
//	// e3m3_marine_01 : Infinity!  Where's our backup?!
//	dprint ("e3m3_marine_01: Infinity!  Where's our backup?!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00400', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00400'));
//	
//	sleep (10);
//
//	// Palmer : Settle down, Marine.  Your saviors are here.
//	dprint ("Palmer: Settle down, Marine.  Your saviors are here.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00500', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00500'));

	end_radio_transmission();
	
end


script static void e3m2_vo_playstart()
	// gameplay begins

	b_dialog_playing = true;
	
	start_radio_transmission( "owen_transmission_name" );
		
	// Doctor Owen : Covenant forces are after our computer systems!  They're digging through the signal data that Crimson collected!
	dprint ("Doctor Owen: Covenant forces are after our computer systems!  They're digging through the signal data that Crimson collected!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_intro_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Doctor Owen, shut down the systems while Crimson aids the Marines.
	dprint ("Palmer: Doctor Owen, shut down the systems while Crimson aids the Marines.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

	// Doctor Owen : I…can't.  We're locked away in the safe room underground.
	dprint ("Doctor Owen: I…can't.  We're locked away in the safe room underground.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I've got the schematics on Galileo.  Here are the locations of the power cores for all computer systems.
	dprint ("Miller: I've got the schematics on Galileo.  Here are the locations of the power cores for all computer systems.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00300'));
	cui_hud_hide_radio_transmission_hud();
	
	end_radio_transmission();
	
end
	
	
script static void e3m2_vo_playstart2()

	sleep (10);
	
	// PIP
	start_radio_transmission( "palmer_transmission_name" );
		hud_play_pip_from_tag (bink\spops\ep3_m2_1_60);
	
	// Palmer : Crimson, targets are painted.  Shut 'em down.
	dprint ("Palmer: Crimson, targets are painted.  Shut 'em down.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_playstart_00400_pip'));
	
	end_radio_transmission();
	// end PIP
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_target1down()
	// first target down
	
	
	sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : One power core offline, Commander
	dprint ("Miller: One power core offline, Commander");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Two to go, Crimson, Keep it up.
	dprint ("Palmer: Two to go, Crimson, Keep it up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00200'));
	
	end_radio_transmission();

//	sleep (15);
//
//	
//	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );
//
//	// Doctor Owen : Be careful!  Do you know how much that cost?!
//	dprint ("Doctor Owen: Be careful!  Do you know how much that cost?!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00300'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	
//	sleep (10);
//	
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//
//	// Palmer : Zip it, Doc.  Let the professionals work.
//	dprint ("Palmer: Zip it, Doc.  Let the professionals work.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00400', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target1_00400'));
//	
//	cui_hud_hide_radio_transmission_hud();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_subplot1()
	//first discussion of subplot
	
	sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander Palmer, we've got Covie chatter about Parg Vol in Crimson's area!
	dprint ("Miller: Commander Palmer, we've got Covie chatter about Parg Vol in Crimson's area!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, your mission's to shut down those computers, but if you see that hinge head, you take him down.
	dprint ("Palmer: Crimson, your mission's to shut down those computers, but if you see that hinge head, you take him down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot1_00200'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_target2down()
	//second target down
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
//	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );
//	
//	// Doctor Owen : What was that sound?!
//	dprint ("Doctor Owen: What was that sound?!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target2_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target2_00100'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);
//	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
//
//	// Palmer : Crimson pulling your ass out of the fire, Doc.
//	dprint ("Palmer: Crimson pulling your ass out of the fire, Doc.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target2_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target2_00200'));
//	
//	cui_hud_hide_radio_transmission_hud();
//	sleep (10);


	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : One target to go, Commander.
	dprint ("Miller: One target to go, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target2_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target2_00300'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_target3down()
	//third target down
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : That's all the targets, Commander
	dprint ("Miller: That's all the targets, Commander");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00100'));
	
	end_radio_transmission();

	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_turrets()
	//turrets id'd
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Dalton, you online?
	dprint ("Palmer: Dalton, you online?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : I'm here, Commander
	dprint ("Dalton: I'm here, Commander");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Cycle up Galileo's base defenses remotely.
	dprint ("Palmer: Cycle up Galileo's base defenses remotely.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : One second.
	dprint ("Dalton: One second.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (60);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Can't do it.  Covies jammed the Infinity uplink.
	dprint ("Dalton: Can't do it.  Covies jammed the Infinity uplink.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00600'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Miller.
	dprint ("Palmer: Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00700'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Already on it.  Painting nav points for Crimson now.
	dprint ("Miller: Already on it.  Painting nav points for Crimson now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00800', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_target3_00800'));
	
	end_radio_transmission();
	
	// Miller : There they are, Crimson.
//	dprint ("Miller: There they are, Crimson.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turrets_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turrets_00100'));
//	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_subplot2()
	//second discussion of subplot
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "e3m3_marine_1_transmission_name" );
		
	// e3m3_marine_01 : Spartans?  Hate to interrupt, but we lost eyes on Parg Vol.  Gave us the slip.
	dprint ("e3m3_marine_01: Spartans?  Hate to interrupt, but we lost eyes on Parg Vol.  Gave us the slip.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot2_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Dammit.  Understood, Marine.  We'll find him another time.
	dprint ("Palmer: Dammit.  Understood, Marine.  We'll find him another time.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot2_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_subplot2_00200'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_phantom1()
	//first phantom
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Phantom inbound.
	dprint ("Miller: Phantom inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_phantom1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_phantom1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : See that, Crimson? Stay sharp.
	dprint ("Palmer: See that, Crimson? Stay sharp.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_phantom1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_phantom1_00200'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_banshees1()
	//first banshees
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Comander Palmer, I'm seeing Banshees on a vector towards Crimson's Galileo op.
	dprint ("Dalton: Comander Palmer, I'm seeing Banshees on a vector towards Crimson's Galileo op.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_banshees1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_banshees1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Got it, Dalton.  Eyes toward the sky, Crimson
	dprint ("Palmer: Got it, Dalton.  Eyes toward the sky, Crimson");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_banshees1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_banshees1_00200'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_turret1on()
	//first turret is on
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Well done, Crimson.  Now get the other one up and running
	dprint ("Palmer: Well done, Crimson.  Now get the other one up and running");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turret1on_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turret1on_00100'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_turret2on()
	//second turret on
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : That's both turrets, Commander.  Galileo's on lockdown.
	dprint ("Miller: That's both turrets, Commander.  Galileo's on lockdown.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turret2on_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turret2on_00100'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_turretremind1()
	//first turret reminder
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : This all gets a lot easier if you turn those turrets on, Crimson.
	dprint ("Palmer: This all gets a lot easier if you turn those turrets on, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turretremind1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turretremind1_00100'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_turretremind2()
	//second turret reminder
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson!  Get on those turrets!
	dprint ("Palmer: Crimson!  Get on those turrets!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turretremind2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_turretremind2_00100'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_hunters()
	//hunters attack
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Hunters!
	dprint ("Miller: Hunters!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_hunters_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_hunters_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : You're not clear yet, Crimson.  Take 'em down.
	dprint ("Palmer: You're not clear yet, Crimson.  Take 'em down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_hunters_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_hunters_00200'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void e3m2_vo_alldone()
	//level done
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Doctor Owen?  Still with us?
	dprint ("Palmer: Doctor Owen?  Still with us?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (30);
	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

	// Doctor Owen : Still in the safe room, yes.
	dprint ("Doctor Owen: Still in the safe room, yes.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep3_m2_2_60);
	
	// Palmer : It's safe to come out now.  Get your lab running again, and let's see why the Covvies were so interested in Crimson's data.
	// Palmer : Miller, I want a report from the Marine that let Parg Vol slip away.
	dprint ("Palmer: It's safe to come out now.  Get your lab running again, and let's see why the Covvies were so interested in Crimson's data.");
	dprint ("Palmer: Miller, I want a report from the Marine that let Parg Vol slip away.");
	
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00300', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00400', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00300_pip'));

	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : You got it, Commander.
	dprint ("Miller: You got it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_02\e3m2_alldone_00500'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


//=============================================================================================================================
//============================================ COMPLEX E4 M5 VO SCRIPTS =======================================================
//=============================================================================================================================


script dormant e4m5_vo_intro()

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Crimson, just a heads up that your ride will be there shortly.  Until then, sit back, relax and --
dprint ("Dalton: Crimson, just a heads up that your ride will be there shortly.  Until then, sit back, relax and --");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00100'));

sleep (30);

// Dalton : Hold on! Commander Palmer!  Spartan Miller!  Something's happening at Galileo Base!
dprint ("Dalton: Hold on! Commander Palmer!  Spartan Miller!  Something's happening at Galileo Base!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00200'));

sleep (10);

// Miller : How can -- Commander, Dalton's right.  Galileo's under attack!
dprint ("Miller: How can -- Commander, Dalton's right.  Galileo's under attack!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_intro_00300'));

end_radio_transmission();

end


script dormant e4m5_vo_hunters01

start_radio_transmission( "miller_transmission_name" );

// Miller : Watch out!  Hunters in the area!
dprint ("Miller: Watch out!  Hunters in the area!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hunters01_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hunters01_00100'));

end_radio_transmission();

end


script dormant e4m5_vo_phantoms01()

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Commander Palmer, I'm seeing several dozen Phantoms in the vicinity of Galileo Base.
dprint ("Dalton: Commander Palmer, I'm seeing several dozen Phantoms in the vicinity of Galileo Base.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : That means the bad guys are gonna keep coming.
dprint ("Miller: That means the bad guys are gonna keep coming.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Excellent battle analysis, Miller. I'm making a note for your file.
dprint ("Palmer: Excellent battle analysis, Miller. I'm making a note for your file.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_phantoms01_00300'));

end_radio_transmission();

end


script dormant e4m5_vo_defensedown01()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Wait a second -- Why aren't facility defenses online?
dprint ("Palmer: Wait a second -- Why aren't facility defenses online?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Don't know…I can't bring them up remotely either, Commander.  Working on it.
dprint ("Miller: Don't know…I can't bring them up remotely either, Commander.  Working on it.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown01_00200'));

end_radio_transmission();

end


script dormant e4m5_vo_defensedown02()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Commander Palmer to Galileo Base.  Doctor Owen.
dprint ("Palmer: Commander Palmer to Galileo Base.  Doctor Owen.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Doctor!  Your base defenses are offline!
dprint ("Palmer: Doctor!  Your base defenses are offline!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

// Doctor Owen : They are?  Sonuva -- Doctor Alexander was talking about using the power from the defenses to run a mini-reactor.  I told him not to!
dprint ("Doctor Owen: They are?  Sonuva -- Doctor Alexander was talking about using the power from the defenses to run a mini-reactor.  I told him not to!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Freaking eggheads.
dprint ("Palmer: Freaking eggheads.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_defensedown02_00400'));

end_radio_transmission();

end


script dormant e4m5_vo_gotoswitch()

start_radio_transmission( "miller_transmission_name" );

// Miller : Crimson, looks like turret power has been routed to this location.  If you can make it there, you can activate the defenses.
dprint ("Miller: Crimson, looks like turret power has been routed to this location.  If you can make it there, you can activate the defenses.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_gotoswitch_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_gotoswitch_00100'));

end_radio_transmission();

end


script dormant e4m5_vo_seeswitch()

start_radio_transmission( "miller_transmission_name" );

// Miller : There's the power source, Crimson.
dprint ("Miller: There's the power source, Crimson.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Turn on the base defenses!  Now!
dprint ("Palmer: Turn on the base defenses!  Now!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_seeswitch_00200'));

end_radio_transmission();

end


script dormant e4m5_vo_turretsup()

start_radio_transmission( "miller_transmission_name" );

// Miller : Turrets online, Commander.
dprint ("Miller: Turrets online, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (30);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : That should help keep the skies clear, but the ground's still your problem, Crimson.
dprint ("Palmer: That should help keep the skies clear, but the ground's still your problem, Crimson.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_turretsup_00200'));

end_radio_transmission();

end


script dormant e4m5_vo_anaside()

start_radio_transmission( "miller_transmission_name" );

// Miller : Commander, the Forerunner tech Crimson tapped is paying off.  The whole Covenant net is talking about trying to retrieve the Promethean soul.
dprint ("Miller: Commander, the Forerunner tech Crimson tapped is paying off.  The whole Covenant net is talking about trying to retrieve the Promethean soul.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Okay, so we know what's going on for once.
dprint ("Palmer: Okay, so we know what's going on for once.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00200'));

sleep (30);

// Palmer : Dalton, who have we got close?
dprint ("Palmer: Dalton, who have we got close?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00400'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Looks like Majestic’s your best bet there, Commander.
dprint ("Dalton: Looks like Majestic’s your best bet there, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00500', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00500'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Tell them to saddle up. They're headed out to Galileo base fast as you can get them there. They're picking up a package while Crimson holds down the fort.
dprint ("Palmer: Tell them to saddle up. They're headed out to Galileo base fast as you can get them there. They're picking up a package while Crimson holds down the fort.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00600', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00600'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : On it, Commander.
dprint ("Dalton: On it, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00700', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_anaside_00700'));

end_radio_transmission();

end


script dormant e4m5_vo_reactoroff()

start_radio_transmission( "alexander_transmission_name" );

// Doctor Alexander : Did someone turn off the mini-reactor?
dprint ("Doctor Alexander: Did someone turn off the mini-reactor?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Bullets outweigh science today, Doc.
dprint ("Palmer: Bullets outweigh science today, Doc.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "alexander_transmission_name" );

// Doctor Alexander : Science is going to kill us all!  If you don't restore power to that mini-reactor, its shielding will fail, and wipe Galileo off the map!
dprint ("Doctor Alexander: Science is going to kill us all!  If you don't restore power to that mini-reactor, its shielding will fail, and wipe Galileo off the map!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Why is nothing ever simple?!
dprint ("Palmer: Why is nothing ever simple?!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00400'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Head back here, Crimson.  Hurry!
dprint ("Miller: Head back here, Crimson.  Hurry!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00500', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_reactoroff_00500'));

end_radio_transmission();

end


script dormant e4m5_vo_hurryup()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Pick up the pace, Crimson!
dprint ("Palmer: Pick up the pace, Crimson!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hurryup_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_hurryup_00100'));

end_radio_transmission();

end


script dormant e4m5_vo_almostdead()

start_radio_transmission( "miller_transmission_name" );

// Miller : Crimson!  You're running out of time!
dprint ("Miller: Crimson!  You're running out of time!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_almostdead_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_almostdead_00100'));

end_radio_transmission();

end


script dormant e4m5_vo_toolate()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Crimson!!
dprint ("Palmer: Crimson!!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_toolate_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_toolate_00200'));

end_radio_transmission();

end


script dormant e4m5_vo_enterroom()

start_radio_transmission( "miller_transmission_name" );

// Miller : Ahhh!  Promethean knights!
dprint ("Miller: Ahhh!  Promethean knights!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_enterroom_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_enterroom_00100'));

end_radio_transmission();

end


script dormant e4m5_vo_killthemall()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Put them down, Crimson!
dprint ("Palmer: Put them down, Crimson!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_killthemall_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_killthemall_00100'));

end_radio_transmission();

end


script dormant e4m5_vo_pelican()

start_radio_transmission( "dalton_transmission_name" );

// Dalton : Commander, Majestic's Pelican is inbound.
dprint ("Dalton: Commander, Majestic's Pelican is inbound.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Doctor Owen, prep our prize for transit.
dprint ("Palmer: Doctor Owen, prep our prize for transit.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

// Doctor Owen : On it, Commander.
dprint ("Doctor Owen: On it, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Crimson, you just keep being awesome down there.
dprint ("Palmer: Crimson, you just keep being awesome down there.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_pelican_00400'));

end_radio_transmission();

end


script dormant e4m5_vo_outro()

start_radio_transmission( "miller_transmission_name" );

// Miller : There's Majestic, Commander.
dprint ("Miller: There's Majestic, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Okay.  Doctor Owen, you've got a courier coming your way in the form of a Spartan.
dprint ("Palmer: Okay.  Doctor Owen, you've got a courier coming your way in the form of a Spartan.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (30);
cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

// Doctor Owen : We're ready.
dprint ("Doctor Owen: We're ready.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_05\e4m5_outro_00300'));

end_radio_transmission();

end