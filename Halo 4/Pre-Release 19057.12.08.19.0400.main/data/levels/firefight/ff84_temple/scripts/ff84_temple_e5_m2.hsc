//									ai_living_count(e5m2_ff_all)
//                  game_set_variant "e5_m2_temple_recover"


//=============================================================================================================================
//============================================ TEMPLE E5_M2 FIREFIGHT SCRIPT ==================================================
//=============================================================================================================================

global ai ai_ff_allies_1 = e5m2_ff_team_unsc;
global boolean e5m2_phantom_path_clear = false;	// air traffic control
global boolean b_e5m2_shielddoor = false;				// prevents redundant objective text
global boolean e5m3_conch = false;							// WHOEVER HOLDS THE CONCH GETS TO SPEAK
global boolean e5m2_interior_door_open = false; // what it says
global boolean e5m2_shield_wall_intact  = true; // what it says
global boolean b_e5m3_north_snipers = false;		// used in sniper aio's to prevent them from being outranged
global boolean b_e5m3_south_snipers = false;		// used in sniper aio's to prevent them from being outranged
global boolean b_e5m3_goto1 = false;						// used to advance faux goto objective in encounter ext1
global short e5m3_civilian_state = 0; 					// used to gate ai_objective tasks
global short s_e5m2_phantom_1_load_state = 0;		// used to load many squads into phantom
global short s_e5m2_phantom_2_load_state = 0;		// used to load many squads into phantom
global short s_e5m3_combat_progress	= 0;				// used in several aio's to get mobs moving around appropriately
global short s_e5m3_blitz = 0;									// controls blitzrush aio

script startup temple_e5_m2

//Start the intro
               	sleep_until(LevelEventStatus ("e5_m2_startup"), 1);
                print ("******************STARTING e5_m3*********************");
                switch_zone_set(e5_m2);
  							ai_ff_all = e5m2_ff_all;
  							ai_ff_allies_1 = e5m2_ff_team_unsc;
                //is vignette playing = true;  //dunno if I need this or not, greg had it tho so I'm leaving this here placeholder
								thread(f_music_e5m2_start());
								thread(f_start_player_intro_e5_m3());

//start the first starting event – The first event script needs to be started early or it won’t kick off properly
                //thread (f_start_events_blah());
                print ("starting e5_m2");

//start all the rest of the event scripts – This script starts all of the scripts that wait for events
                //thread (f_start_all_events_blah());


	firefight_mode_set_player_spawn_suppressed(true);
	
// =============================================================================================================================
//================================================== GLOBALS ===================================================================
// =============================================================================================================================

	f_add_crate_folder(e5m2_camera);
	f_add_crate_folder(e5m2_temple_doors);					//
	f_add_crate_folder(e5m2_controls);							//
	f_add_crate_folder(e5m2_machineguns);						//
	f_add_crate_folder(e5m2_static_pallets);
	f_add_crate_folder(e5m2_lz_01);
	f_add_crate_folder(e5m2_lz_02);
	f_add_crate_folder(e5m2_lz_03);
	f_add_crate_folder(e5m2_lz_04);
	f_add_crate_folder(e5m2_lz_05);
	f_add_crate_folder(e5m2_props);									//	
	f_add_crate_folder(e5m2_other);									//	
	f_add_crate_folder(e5m2_weaponracks);						//
	f_add_crate_folder(e5m2_drop_rails);						//
	f_add_crate_folder(e5m2_loose_gear);						//
	f_add_crate_folder(e5m2_ammo_boxes);						//
	f_add_crate_folder(e5m3_cruiser);
	
//set spawn folder names: 90-99
	firefight_mode_set_crate_folder_at(e5m2_spawn_points_01, 90); 					// east wing
	firefight_mode_set_crate_folder_at(e5m2_spawn_points_02, 91); 					// entry to temple
	firefight_mode_set_crate_folder_at(e5m2_spawn_points_03, 92); 					// upper plat
	firefight_mode_set_crate_folder_at(e5m2_spawn_points_04, 93); 					// entry to temple, facing out

//	objectives: ids 50-65(+?)
	firefight_mode_set_objective_name_at(e5m2_lz_01, 50); 
	firefight_mode_set_objective_name_at(e5m2_lz_02, 51); 
	firefight_mode_set_objective_name_at(e5m2_lz_03, 53); 
	firefight_mode_set_objective_name_at(e5m2_lz_04, 54); 
	firefight_mode_set_objective_name_at(e5m2_lz_05, 55);
	firefight_mode_set_objective_name_at(e5m2_door_barrier, 56);
	firefight_mode_set_objective_name_at(e5m2_device_control, 57); 					// invisible control on interior door

// firefight squads: ids 1-24(+?)
	
	//initially placed																											// initial headcount of 6 for phantoms		--6
	firefight_mode_set_squad_at(e5m2_foes_ext1_bridge_alphas, 1);						// 2 elites 															--8
	firefight_mode_set_squad_at(e5m2_foes_ext1_bridge_betas, 2);						// 5 grunts																--13

	//initial dropship
	firefight_mode_set_squad_at(e5m2_foes_ext1_stage_guard, 3);							// 1 elite, 2 jax													--16
	firefight_mode_set_squad_at(e5m2_foes_ext1_east_init, 4);								// 1 elite, 2 jax													--19
	
	//first add'l dropship
	firefight_mode_set_squad_at(e5m2_foes_ext1_west_door_guard, 5);					
	firefight_mode_set_squad_at(e5m2_foes_ext1_west_door_add, 6); 					
	
	//phantoms:
	firefight_mode_set_squad_at(e5m2_phantom_1a, 17);												// in and out
	firefight_mode_set_squad_at(e5m2_phantom_2a, 18);												// hangs out and blasts
	firefight_mode_set_squad_at(e5m2_phantom_3, 19);												// the one with gunners

	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_1a, 20);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_1b, 21);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_2a, 22);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_2b, 23);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_3a, 24);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_3b, 25);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_4a, 26);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_4b, 27);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_5a, 28);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_5b, 29);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_6a, 40);	
	firefight_mode_set_squad_at(e5m2_foes_blitz_wave_6b, 41);	
	
	firefight_mode_set_squad_at(e5m2_foes_ext2_hunter_1, 30);	
	firefight_mode_set_squad_at(e5m2_foes_ext2_hunter_2, 31);	
	firefight_mode_set_squad_at(e5m2_foes_ext2_snipers, 32);	
	firefight_mode_set_squad_at(sq_e5m2_ext2_first_pod_1, 33);
	firefight_mode_set_squad_at(sq_e5m2_ext2_first_pod_2, 34);
	firefight_mode_set_squad_at(sq_e5m2_ext2_2nd_pod_1, 35);
	firefight_mode_set_squad_at(sq_e5m2_ext2_2nd_pod_2, 36);
	firefight_mode_set_squad_at(sq_e5m2_ext2_3rd_pod_1, 37);
	firefight_mode_set_squad_at(sq_e5m2_ext2_3rd_pod_2, 38);
	
	dm_droppod_1= e5m2_droprail_01;
	dm_droppod_2= e5m2_droprail_02;
	dm_droppod_3= e5m2_droprail_03;
	dm_droppod_4= e5m2_droprail_04;
	dm_droppod_5=	e5m2_droprail_05;
	
	firefight_mode_set_player_spawn_suppressed(false);
	
	kill_volume_disable(kill_e4_m1_kill_players_door);
	kill_volume_disable(kill_v1);
	
	effects_distortion_enabled = 0;
	b_no_pod_blips = true;
end


script static void f_start_player_intro_e5_m3
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep (5);
		firefight_mode_set_player_spawn_suppressed(false);
		fade_out (0,0,0,1);
		object_destroy (e5m2_shell);
		f_start_player_intro_e5m2();
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30); 	//loadout screen or 8 secs, whichever first  
    ai_enter_limbo (e5m2_ff_all); 																					//- all the mission AI should enter limbo for the vignette
    object_destroy (e5m2_shell);
		intro_vignette_e5_m3();
	end
	firefight_mode_set_player_spawn_suppressed(false);
	sleep_until (b_players_are_alive(), 1); 
	ai_exit_limbo (e5m2_ff_all); 
	fade_in (0,0,0,30);
end

script static void intro_vignette_e5_m3
	cinematic_start();
	print ("_____________starting vignette__________________");
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e5m3_vin_sfx_intro', NONE, 1);
	//sleep_s (8);
	
	thread(f_music_e5m2_vignette_start());
	
// play the puppeteer
	pup_play_show (e5m3_narrative_in);
	
	wake(vo_e5m3_shank);
			// e5m3_marine1 : Infinity, this is Warbird Leader.  No sign of Covies down here.
			// e5m3_marine1 : HRRRKKKK
		
	sleep_until(b_e5m3_nin_done == true);
	
	cinematic_stop();
	
	thread(f_music_e5m2_vignette_finish(), 1);
	
// wait until the puppeteer is complete
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);
	f_start_player_intro_e5m2();
end


script static void f_start_player_intro_e5m2

	thread(e5m2_shield_barrier_down());
	thread(e5m2_barrier_kill());
	thread(e5m2_spawn_bridge());
	thread(e5m2_first_bonobo_event());
	thread(e5m3_vo_wontopen());
	thread(e5m2_enc1_blip_lasties());
	thread(e5m2_place_marines());
	thread(e5m2_marinehelp());
	thread(e5m2_hackshields());
	thread(e5m3_int_door_arrival());
	thread(e5m2_enable_panel());
	thread(seek_player());
	thread(f_e5m2_paradrop_1());
	thread(f_e5m2_paradrop_2());
	thread(e5m3_drop_blitz_wind_down());
	thread(e5m2_enc1_clean_house());


	sleep(5);

	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	b_end_player_goal = TRUE;																			//advance objectives to spawn everything
	ai_place(e5m2_phantom_4);																				
	ai_place(e5m2_phantom_5);																				
	sleep (30);
	
	object_destroy_folder(e5m2_camera);
	thread(f_music_e5m2_intro_vo_start());
	print("-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0- intro");
	wake(vo_e5m3_intro);
			// Miller : Crimson, Marines from Warbird Company are touching down on --
			// Dalton : Miller, heads up!  You've got a Covenant cruiser inbound on Crimson's location.
			// Miller : Sonuva -- Thanks, Dalton.
			// Miller : Crimson, looks like the Covies are mad we broke their portal toy.  Get ready to repel invaders.
			// ONCALLBACK: Set Objective (f_new_objective(e5m2_objective_text_01); // "Repel the Covenant Invaders")
	sleep(30);
	thread(f_music_e5m2_intro_vo_finish());
end
//==temp text================
// =======================================================================================================================
//
//					::::::::::: :::::::::: ::::    ::::  :::::::::       ::::::::::: :::::::::: :::    ::: ::::::::::: 
//					    :+:     :+:        +:+:+: :+:+:+ :+:    :+:          :+:     :+:        :+:    :+:     :+:     
//					    +:+     +:+        +:+ +:+:+ +:+ +:+    +:+          +:+     +:+         +:+  +:+      +:+     
//					    +#+     +#++:++#   +#+  +:+  +#+ +#++:++#+           +#+     +#++:++#     +#++:+       +#+     
//					    +#+     +#+        +#+       +#+ +#+                 +#+     +#+         +#+  +#+      +#+     
//					    #+#     #+#        #+#       #+# #+#                 #+#     #+#        #+#    #+#     #+#     
//					    ###     ########## ###       ### ###                 ###     ########## ###    ###     ###     
//
// =======================================================================================================================

script static void  e5m2_first_bonobo_event
	sleep_until (LevelEventStatus("e5m2_goal1_event1"), 1);
	thread(f_music_e5m2_first_bonobo_event());
	sleep(30 * 3);
	object_cannot_take_damage(e5m2_door_barrier);
	object_set_function_variable(e5m2_door_barrier, shield_on, 1, 1);
	sleep_forever();
end
script static void e5m3_intro_callback
	f_new_objective(e5m2_objective_text_01);
						//Repel the Covenant Invaders
	sleep(30 * 6);
	thread(f_music_e5m2_convo_fightstart_vo());
	thread(e5m2_convo_fightstart());
end
script static void e5m3_vo_wontopen
	sleep_until (LevelEventStatus("e5m3_vo_wontopen"), 1);
	thread(f_music_e5m2_wont_open_vo());
	sleep(30 * 3);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_wontopen);
			// Doctor Boyd : Hello!  Infinity?!
			// Miller : Doctor Boyd?  Where are you?
			// Doctor Boyd : Still in the safe room.  The door won't open!
			// Miller : Jeez…along with everything else…
			// Miller : Crimson, see if you can lend Doctor Boyd a hand.
	sleep_forever();
end

script static void e5m3_wontopen_callback
	print ("e5m3_wontopen_callback");
	thread(f_new_objective(e5m2_objective_text_03));
	// (note: conch reset in narrative script, not here, in order to avoid stomping on last line)
	thread(f_music_e5m2_wontopen_callback());
end


script static void e5m3_opendoor_callback
	print ("e5m3_opendoor_callback");
	e5m3_conch = false;
	b_wait_for_narrative_hud = false;													// return HUD blips 
	thread(e5m2_objective_3a_maybe());												// if player hasn't already interacted with panel, give objective
	thread(f_music_e5m2_opendoor_callback());
end

script dormant e5m2_vo_dooropen
	sleep_until(e5m3_conch == false);
	sleep(20);
	wake(vo_e5m3_dooropen);
	thread(f_music_e5m2_dooropen_vo());
			// Doctor Boyd : Oh, thank you!
			// removed: // Miller : Doctor Body, follow the Marines.  They'll get you to an evac point.
end

script static void e5m3_dooropen_callback
	print ("e5m3_dooropen_callback");
	e5m3_conch = false;
	sleep (30);
	thread(e5m3_blitz_shake_and_vo());
	thread(f_music_e5m2_dooropen_callback());
end

script static void e5m2_vo_lottadropships
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_lottadropships);
			// Roland : Well, that's a lot of drop ships.
			// Miller : Is that what I sound like?
	thread(e5m2_start_blitz());
	thread(f_music_e5m2_lottadropships_vo());
end

script static void e5m3_lottadropships_callback
	print ("e5m3_lottadropships_callback");
	e5m3_conch = false;
	sleep (30);
end

script dormant e5m3_vo_phantom
print (" ");
//vo_e5m3_phantom()
			// Miller : Crimson!  Phantom inbound!
end

script dormant e5m3_vo_hunters
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	thread(f_music_e5m2_hunters_vo());
	wake(vo_e5m3_hunters);
		// Miller : Oh hell, it's the kitchen sink today, isn't it?  Here come Hutners!
end

script static void e5m3_hunters_callback
	print ("e5m3_hunters_callback");
	e5m3_conch = false;
	sleep (30);
end

script dormant e5m3_vo_millerplan
	print (" ");
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
//vo_e5m3_millerplan()
			// Miller : Fireteam Shadow, this is Spartan Miller in Ops.  I'm filling in for Commander Palmer, so apologies to your team's handler, uh, Spartan Carmichael, for going over his head here.
			// Shadow Leader : This is Shadow leader.  Go ahead, Miller.
			// Miller : Got a job for you.  Infiltrate a Covenant cruiser and destroy her power core.  I'm sending you coordinates now.
			// Roland : Spartan Miller!  Is that a good idea?
			// Miller : It's my only idea right now, Roland.  Shadow's the closest Fireteam with air transport.
			// Shadow Leader : We can help you out there.  Give us a few to get over to those grid squares.
end

script static void e5m3_vo_afterawhile
	print (" ");
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	sleep(30 * 3);
	wake(vo_e5m3_afterawhile);
			// Shadow Leader : Shadow Miller, we're inbound on the Covenant Cruiser.  We're going to kick the door in and surprise them in ten.
			// Miller : Understood, Miller.  Keep me informed.
end


script static void e5m3_vo_oncruiser
	print (" ");
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	sleep(30);
  wake(vo_e5m3_oncruiser);
			// Shadow Leader : Shadow Leader to Spartan Miller.  Sorry for the delay, sir.  We're meeting heavy resistance in the Cruiser.  Seems they don't want their spaceship blown up.
			// Miller : Understood, Shadow Leader.  Keep me informed.
end

script static void e5m3_hunter_checker
	sleep_until (LevelEventStatus("e5m2_ext2_almost_done"), 1);
	sleep(30* 8);
	sleep_until(ai_living_count(sg_e5m2_ext2_hunters) <= 1);
	thread(e5m3_vo_cruiserhit());
end

script static void e5m3_vo_cruiserhit
	print (" ");
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	sleep(30 * 2);
	wake(vo_e5m3_cruiserhit);
			// Shadow Leader : Miller!  Shadow Leader!  Cruiser power core is hit1  Overload in progress!  We're evacing now.  Expect a light show wihtin 30.
			// Miller : Hot damn, good work, Shadow Leader!
			// Miller : Crimson!  Hold out just a bit longer!  Your troubles are over.
end

script dormant e5m3_vo_evacorder
	print (" ");
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	//vo_e5m3_evacorder()
			// Miller : This is Spartan Miller to Marine unit Warbird.  I need your men to evacuate the area.  You're going to have a cruiser coming down on your heads in a few minutes.
			// e5m3_marine3 : Understood, Infinity.  Warbirds!  Fall out!
end

script static void e5m3_cruiserboom
	print ("BOOM ");
	sleep(30);
	
	thread(cruiser_amb_crash_1());
	sleep(30 * 4);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_cruiserboom);
			// Miller : Shadow Leader!  Was your team clear?!...Shadow Leader!
			// Shadow Leader : We're here, Infinity.  And all in one piece.
			// Miller : Excellent work, Spartans.
end

script static void e5m3_vo_cruiserboom_callback
	sleep(27);
	e5m3_conch = false;
	sleep(3);
	wake(e5m3_vo_wrapup);
end

script dormant e5m3_vo_wrapup
sleep(3);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_wrapup);
	thread(f_music_e5m2_wrapup_vo_1());
			// Roland : Spartan Miller, distress call from Forward Base Magma.  They've been under attack for some time and would appreciate backup.
			// Miller : Crimson, you're closest to them.  Hope you weren't planning on catching your breath.
			// Miller : Dalton, I need a quick ride for Crimson to Magma's position.
			// Dalton : I can arrange that.  Sorry about earlier, Miller.
			// Miller : We'll talk about it later.
end

script static void e5m3_wrapup_callback
	print ("e5m3_wrapup_callback");
	e5m3_conch = false;
	b_wait_for_narrative_hud = false;
	sleep (10);
	fade_out (0,0,0,30);
	player_control_fade_out_all_input (30);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	b_end_player_goal = true;
end

script static void e5m3_generic_callback
	e5m3_conch = false;
end

script dormant e5m3_vo_pelican
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_pelican);
	thread(f_music_e5m2_pelican_vo());
			// Dalton : Pelican's on station.
			// Miller : There's your ride, Crimson.  All aboard.  Let's go save the world for, what, the third time today?
end

script static void e5m3_pelican_callback
	print ("e5m3_pelican_callback");
	e5m3_conch = false;
	sleep (30);
end

//== Exterior, Before =========================
// ==============================================================================================================
//
//		    ______      __            _                  ____       ____               
//		   / ____/_  __/ /____  _____(_)____  _____     / __ )___  / __/____  ________ 
//		  / __/  | |/_/ __/ _ \/ ___/ // __ \/ ___/    / __  / _ \/ /_ / __ \/ ___/ _ \
//		 / /___ _>  </ /_/  __/ /  / // /_/ / /  _    / /_/ /  __/ __// /_/ / /  /  __/
//		/_____//_/|_|\__/\___/_/  /_/ \____/_/  ( )  /_____/\___/_/   \____/_/   \___/ 
//		                                        |/                                     
//
// ==============================================================================================================

script static void e5m2_spawn_bridge
	sleep_until (volume_test_players (trigger_volume_opening), 1);
	thread(f_music_e5m2_spawn_bridge());
	thread(e5m3_cruiser_init());
	print("<><><><><><><><> bridge spawning");
	ai_place (e5m2_foes_ext1_bridge_alphas);
	ai_place (e5m2_foes_ext1_bridge_betas);
	print("<><><><><><><><> bridge should have spawned");
	sleep_forever();
end

script command_script e5m2_ext1_ranger_1																		// run path so player can spot covenant, but cov doesn't spot player
//	print("<><><><><><><><><><> Ranger 1 putzing about");
	sleep(30 * 1);
	cs_abort_on_damage(true);
	cs_go_to_and_face(e5m2_ext1_ranger_points.p0, e5m2_ranger_look_ats.p0); 	// right rail
	sleep(30 * 1);
	cs_abort_on_alert(true);
	sleep(30 * 1);
	cs_go_to_and_face(e5m2_ext1_ranger_points.p1, e5m2_ranger_look_ats.p1); 	//middle forefront
end

script command_script e5m2_ext1_ranger_2																		// run path so player can spot covenant, but cov doesn't spot player
//	print("<><><><><><><><><><> Ranger 2 putzing about");										
	sleep(30 * 2);
	cs_abort_on_damage(true);
	cs_go_to_and_face(e5m2_ext1_ranger2_points.p0, e5m2_ranger_look_ats.p3);	//
	cs_go_to_and_face(e5m2_ext1_ranger2_points.p1, e5m2_ranger_look_ats.p3);	//between pylons
	sleep(30 * 1);
	cs_go_to_and_face(e5m2_ext1_ranger2_points.p2, e5m2_ranger_look_ats.p4);	//between pylons, checking other corner
	cs_abort_on_alert(true);
	sleep(30 * 1);
	cs_go_to_and_face(e5m2_ext1_ranger2_points.p3, e5m2_ranger_look_ats.p0);
	cs_go_to_and_face(e5m2_ext1_ranger2_points.p4, e5m2_ranger_look_ats.p0);
	cs_go_to_and_face(e5m2_ext1_ranger2_points.p5, e5m2_ranger_look_ats.p1);	//run around, to forefront
end

script static void e5m2_place_marines
		sleep_until(LevelEventStatus("e5m2_spawn_marines"), 1);
		thread(f_music_e5m2_place_marines());
		print(".................................attempting to spawn marines");
		ai_place (e5m2_ally_marine_1);
		ai_place (e5m2_ally_marine_2);
		ai_place (e5m2_cmmdo_playfighter);
		sleep(15);
		ai_cannot_die(e5m2_cmmdo_playfighter, true);
//		unit_only_takes_damage_from_players_team (e5m2_cmmdo_playfighter, true);
		ai_cannot_die(e5m2_ally_marine_1, true);
		ai_cannot_die(e5m2_ally_marine_2, true);
		ai_object_set_targeting_bias (e5m2_cmmdo_playfighter, 1);
		sleep_forever();
end

script command_script e5m2_marine_init_orders
	cs_aim_object (true, e5m2_cmmdo_playfighter);
	cs_enable_moving(true);
end

script static void e5m2_convo_fightstart
	wake(vo_e5m3_fightstart);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	thread(f_music_e5m2_convo_fightstart_vo());
			// Miller : Dalton, what can you do for backup?
			// Dalton : Not a lot with the air support they're bringing to the party.
			// Miller : Is that a -- Oh no.  Spartans, be advised, you've got a Covenant Cruiser on your position.
end

script static void e5m3_fightstart_callback
	e5m3_conch = false;
	thread(e5m3_blip_cruiser());
end
//////////////////////// Get to the barrier event ------------
script static void e5m2_marinehelp
	sleep_until (LevelEventStatus("e5m2_vo_marinehelp"), 1);
	print("-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0 e5m2_vo_marinehelp event received");
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_marinehelp);
	thread(f_music_e5m2_marinehelp());
			// e5m3_marine2 : Infinity!  Warbird!  We've got problems!  Camouflaged Elites!  We can't see 'em -- HUURRGGG
			// Miller : Aw, hell.  Crimson!  Double time it to Warbird's position!
end

script static void e5m3_marinehelp_callback 										//called from inside narrative script
	e5m3_conch = false;
	wake(e5m2_shieldblock);
	thread(f_e5m2_goto1_trigger());
	thread(f_e5m2_goto1_kill());
	sleep(15);
	if(b_e5m2_shielddoor == false)then														// if players aren't already in position 
		thread(f_new_objective(e5m2_objective_text_01a));						// play objective
		thread(f_blip_object_cui (e5m2_lz_01, "navpoint_goto"));		// blip goto location on shield door
//		f_blip_object_cui (e5m2_door_barrier, "navpoint_healthbar_destroy");		// blip goto location on shield door
//		navpoint_track_object_named (e5m2_door_barrier, "navpoint_healthbar_destroy"); 
//		object_create_anew (e5m2_door_barrier)
	end
end
//////////////////////// Get to the barrier event end ------------

//////////////////////// Upon arrival to the barrier -------------
script dormant e5m2_shieldblock
	sleep_until(b_e5m3_goto1 == true);
	thread(f_music_e5m2_shielddoor());
	b_e5m2_shielddoor = true;																			// prevents objective text from displaying if players are already there
	sleep(5);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	thread(f_music_e5m2_shielddoor_vo());
	thread(f_blip_object_cui (e5m2_lz_01, ""));										// remove blip
	ai_place(e5m2_marine_3);
	vo_e5m3_shieldblock();
			// Miller : Warbird, Infinity.  There's a shield system between Crimson and you.
			// e5m3_marine3 : That shield's Covenant-deployed, sir.  We can't bring it down.  They've boxed us in!
	//thread(e5m2_vo_carrier());																	// 8-12-12 removed per Josh's request
	thread(e5m2_vo_shadow1());																		// 8-12-12 promoted to accomodate above change
	sleep(15);
	sleep_forever();
end

script static void f_e5m2_goto1_trigger
	sleep_until (volume_test_players (trigger_volume_shield_door), 1);
	b_e5m3_goto1 = true;
end
script static void f_e5m2_goto1_kill
	sleep_until (s_e5m3_combat_progress == 4);
	b_e5m3_goto1 = true;
end

script static void e5m3_shieldblock_callback
	e5m3_conch = false;			
	sleep(30);
	thread(f_new_objective(e5m2_objective_text_01b));						
				// ELIMINATE REMAINING COVENANT FORCES
end
//////////////////////// Upon arrival to the barrier end -------------

script static void e5m2_vo_carrier
	sleep(30 * 5);
	if(ai_living_count(e5m2_ff_all) > 5)then			// if we're winding down, skip this. Need time for more critical lines
			sleep_until(e5m3_conch == false);
			e5m3_conch = true;
			wake(vo_e5m3_carrier);
			thread(f_music_e5m2_carrier_vo());
				// Miller : I need to remove a carrier from the sky over Crimson's location.
				// Dalton : I'm sorry, man.  Carriers are tied up outside the shell.  I've got nobody in there.
	end
end

script static void e5m3_carrier_callback
	sleep(30 * 2);
	e5m3_conch = false;			
	thread(e5m2_vo_shadow1());
end

script static void e5m2_vo_shadow1
	sleep(30 * 12);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_millerplan);
			// Miller : Fireteam Shadow, this is Spartan Miller in Ops.  I'm filling in for Commander Palmer, so apologies to your team's handler, uh, Spartan Carmichael, for going over his head here.
			// Shadow Leader : This is Shadow leader.  Go ahead, Miller.
			// Miller : Got a job for you.  Infiltrate a Covenant cruiser and destroy her power core.  I'm sending you coordinates now.
			// Roland : Spartan Miller!  Is that a good idea? 
			// Miller : It's my only idea right now, Roland.  Shadow's the closest Fireteam with air transport. 
			// Shadow Leader : We can help you out there.  Give us a few to get over to those grid squares.
end

script static void e3m5_shadow1_callback
	e5m3_conch = false;
end

script static void e5m2_enc1_blip_lasties 
	sleep_until (LevelEventStatus("e5m2_enc1_blip_lasties"), 1);
	s_e5m3_combat_progress = 4;																					// last few
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	kill_volume_enable(kill_v1);																				// tjp 8-18-12
	vo_glo_remainingcov_03();
	kill_volume_disable(kill_v1);																				// tjp 8-18-12
	sleep(30 * 3);
	e5m3_conch = false;
	f_blip_object_cui (e5m2_cmmdo_playfighter, "");
	sleep(30);
	ai_cannot_die(e5m2_cmmdo_playfighter, false);
//	unit_only_takes_damage_from_players_team (e5m2_cmmdo_playfighter, false);
	sleep(30 * 4);
	f_blip_object_cui (e5m2_cmmdo_playfighter, "");
	ai_cannot_die(e5m2_cmmdo_playfighter, false);
end

script static void e5m2_enc1_clean_house
	sleep_until (LevelEventStatus("e5m2_enc1_clean_house"), 1);
	s_e5m3_combat_progress = 5;																						// last two, seek player
end

////////////////////////// Hack the shields event
script static void e5m2_hackshields
	sleep_until (LevelEventStatus("e5m2_vo_hackshields"), 1);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	sleep(20);
	wake(vo_e5m3_hackshields);
	thread(f_music_e5m2_hackshields());
			// Miller : Roland, got any ideas on those Covenant shields?
			// Roland : Turn them off?
			// Miller : Nobody seems real sure how to do that, Roland.
			// Roland : Ah!  I see…hmm…Well, Crimson's armor sensors show the shields operating on a frequency in the upper --
			// Miller : Can you do it or not?!
			// Roland : Yep.  It's a simple enough hack to make them vulnerable to small arms fire.
			// Roland : There you go Crimson; blast away.
end

script static void e5m3_hackshields_callback
	object_can_take_damage(e5m2_door_barrier);
	e5m3_conch = false;			
	sleep(30);	
	b_end_player_goal = TRUE;												//advance objectives
	thread(f_new_objective(e5m2_objective_text_01c));
				//"Destroy the Covenant Shield Barrier"
end

script static void e5m2_shield_barrier_down
	sleep_until(object_get_shield(e5m2_door_barrier) == 0);
	thread(e5m2_spawn_commandos());

	sleep(18);
	thread(f_music_e5m2_shield_barrier_down());
	ai_cannot_die(e5m2_ally_marine_1, false);
	ai_cannot_die(e5m2_ally_marine_2, false);
		object_destroy(e5m2_door_barrier);
		print("////////////////////////////////////////////");
		print("////////////////////////////////////////////");
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	wake(vo_e5m3_marinefight);
	thread(f_music_e5m2_marinefight_vo());
			// e5m3_marine3 : Oh, man, Spartans!  Is it ever good to see you!
			// Roland : Covenant comm chatter about the "Silent Blade" operating in this area.  Special Ops team, apparently.
			// Miller : Keep your eyes sharp, Crimson.  Heavy active camo use by Covenant forces.
	sleep_forever();
end

script static void e5m3_marinefight_callback
	print ("e5m3_marinefight_callback");
	e5m3_conch = false;
	thread(f_new_objective(e5m2_objective_text_02));			
							//"Eliminate The Covenant Spec Ops Team"		
end

script static void f_e5m2_paradrop_1															
	sleep_until (LevelEventStatus("e5m3_phant_1"), 1);

	s_e5m3_combat_progress = 1;																						// first dropship reinforcement
	print("<><><><> ----- phantom_1 spawning ----<><><><>");
	ai_place (e5m2_phantom_1, 1);
	print("<><><><> ----- phantom_1 spawned ----<><><><>");
	ai_place_in_limbo (e5m2_ext1_west_door_guard, 5);
	ai_place_in_limbo (e5m2_ext1_west_door_add, 3);
	ai_place_in_limbo (e5m2_ext1_west_nest, 2);
	sleep(3);
	print("<><><><> ----- waiting til phantom ready ----<><><><>");
	sleep_until(s_e5m2_phantom_1_load_state == 1);												// wait til phantom ready
	
	ai_exit_limbo(e5m2_ext1_west_door_guard);
	ai_vehicle_enter_immediate(e5m2_ext1_west_door_guard, e5m2_phantom_1, "phantom_p_lf");
	ai_exit_limbo(e5m2_ext1_west_door_add);
	ai_vehicle_enter_immediate(e5m2_ext1_west_door_add, e5m2_phantom_1, "phantom_p_rb");
	ai_exit_limbo(e5m2_ext1_west_nest);
	ai_vehicle_enter_immediate(e5m2_ext1_west_nest, e5m2_phantom_1, "phantom_p_rf");
	
	sleep(4);
	
	s_e5m2_phantom_1_load_state = 2;
	
	print("<><><><> ------------------------ phantom_1 loaded and ready to go --------------------------------<><><><>");
	
end


script static void f_e5m2_paradrop_2
	sleep_until (LevelEventStatus("e5m3_phant_2"), 1);

	s_e5m3_combat_progress = 3;																						// second dropship reinforcement

	ai_place (e5m2_phantom_2, 1);
	
	ai_place_in_limbo (e5m2_ext1_dropship_squad_a, 4);
	ai_place_in_limbo (e5m2_ext1_dropship_squad_b, 3);
	ai_place_in_limbo (e5m2_ext1_dropship_squad_c, 3);
	
	sleep_until(s_e5m2_phantom_2_load_state == 1);												// wait til phantom ready
	
	ai_exit_limbo(e5m2_ext1_dropship_squad_a);
	ai_vehicle_enter_immediate(e5m2_ext1_dropship_squad_a, e5m2_phantom_2, "phantom_p_lf");
	ai_exit_limbo(e5m2_ext1_dropship_squad_b);
	ai_vehicle_enter_immediate(e5m2_ext1_dropship_squad_b, e5m2_phantom_2, "phantom_p_rb");
	ai_exit_limbo(e5m2_ext1_dropship_squad_c);
	ai_vehicle_enter_immediate(e5m2_ext1_dropship_squad_c, e5m2_phantom_2, "phantom_p_rf");
	
	sleep(4);
	
	s_e5m2_phantom_2_load_state = 2;
	
end

script static void f_e3m5_door_guard_swap
	s_e5m3_combat_progress = 2;
end

//== Interior Encounters ============================
// ==============================================================================================================
//		
//		    ____       __            _                ______                              __                
//		   /  _/____  / /____  _____(_)____  _____   / ____/____  _________  __  ______  / /____  __________
//		   / / / __ \/ __/ _ \/ ___/ // __ \/ ___/  / __/  / __ \/ ___/ __ \/ / / / __ \/ __/ _ \/ ___/ ___/
//		 _/ / / / / / /_/  __/ /  / // /_/ / /     / /___ / / / / /__/ /_/ / /_/ / / / / /_/  __/ /  (__  ) 
//		/___//_/ /_/\__/\___/_/  /_/ \____/_/     /_____//_/ /_/\___/\____/\__,_/_/ /_/\__/\___/_/  /____/  
//		                                                                                                    
// ==============================================================================================================

script static void e5m2_barrier_kill
	sleep_until (volume_test_players (trigger_volume_barrier), 1);
	thread(f_music_e5m2_barrier_kill());
	e5m2_shield_wall_intact = false;
	sleep(15);
	sleep_forever();
end
//////////////////////// marine 3
script command_script e5m2_marine_3_init
	wake(e5m2_marine_3_death_spiral);
end
script dormant e5m2_marine_3_death_spiral
	cs_go_to(e5m2_marine_3, true, doomed_pts.p0);
	repeat
		sleep(5);
		unit_set_current_vitality(e5m2_marine_3, .002 *(object_get_maximum_vitality(e5m2_marine_1, true)), 0);
		sleep(2);
		inspect(unit_get_health(e5m2_marine_3));
		sleep(13);
	until (ai_living_count(e5m2_ally_marine_3) == 0);
	print("=====marine 3 KIA======");
end
//////////////////////// marine 3 /end

script static void e5m2_spawn_commandos
		thread(f_music_e5m2_spawn_commandos());
		sleep(30 * 1);
		ai_place (e5m2_foes_cmmdo_w_guard);
		sleep(30 * 1);
		ai_place (e5m2_foes_cmmdo_e_guard);
		sleep(30 * 1);
		ai_place (e5m2_foes_cmmdo_bulwark);
		sleep(30 * 1);
		ai_place (e5m2_foes_cmmdo_general);
		ai_set_active_camo(e5m2_foes_cmmdo_w_guard, true);
		ai_set_active_camo(e5m2_foes_cmmdo_e_guard, true);
		ai_set_active_camo(e5m2_foes_cmmdo_bulwark, true);
		thread(e5m2_commando_add_trigger());
		thread(e5m2_commando_add_by_pop());
		thread(e5m3_vo_afterawhile());
		thread(e5m3_blitz_almost_done());
		thread(e5m3_blitz_nearly_done());
		thread(e5m3_specop_seek());
end

script static void e5m2_commando_add_trigger
	sleep_until	(volume_test_players(trigger_spawn_cmmndo_adds), 1);
	thread(e5m2_deres_door());
	if(s_e5m3_combat_progress < 6)then
		ai_place(e5m2_foes_cmmdo_adds);	
		s_e5m3_combat_progress = 6;
	end
end

script static void e5m2_commando_add_by_pop
	sleep_until	(ai_living_count(e5m2_ff_team_commandos) < 3);
	thread(e5m2_deres_door());
	if(s_e5m3_combat_progress < 6)then
		ai_place(e5m2_foes_cmmdo_adds);	
		s_e5m3_combat_progress = 6;
	end
end

script static void e5m3_specop_seek
	sleep_until (LevelEventStatus("e5m3_specop_seek"), 1);
	s_e5m3_combat_progress = 7;																						// last one, seek player
end

script command_script cs_e5m2_comaddo_1
	cs_go_to(commando_adds.p0);
	ai_set_active_camo(e5m2_cmmdo_add1, true);
	cs_go_to(commando_adds.p3);
end
script command_script cs_e5m2_comaddo_2
	cs_go_to(commando_adds.p1);
	cs_go_to(commando_adds.p4);
end
script command_script cs_e5m2_comaddo_3
	cs_go_to(commando_adds.p2);
	ai_set_active_camo(e5m2_cmmdo_add3, true);
	cs_go_to(commando_adds.p5);
end
script command_script cs_e5m2_playfighter_elite
	sleep(30 * 3);																												// allow marines to aquire as target
end

script static void e5m2_deres_door()
	if(object_valid(e5m2_temple_door) == true )then
		print("------------------------- dissolving");
		object_dissolve_from_marker(e5m2_temple_door, phase_out, "dissolve");
		sleep(30 * 5);
		object_destroy(e5m2_temple_door);
		print("------------------------- dissolved");
	end
end

script static void e5m3_int_door_arrival																// called at END OF LOCATION ARRIVAL objective
	sleep_until (LevelEventStatus("e5m3_int_door_arrival"), 1);
	thread(f_music_e5m2_int_door_arrival());
	thread(e5m2_deres_door());
	b_wait_for_narrative_hud = true;																			// suppress HUD blip until VO plays
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	sleep(30);
	wake(vo_e5m3_opendoor);
			// Miller : There's the safe room door.  Doctor Boyd, stand back.
	thread(f_music_e5m2_opendoor_vo());
end

script command_script e5m2_scientist_a
	object_set_variant(e5m2_scientist_1, scientist_01);
end

script static void e5m2_enable_panel 
	sleep_until (LevelEventStatus ("e5m3_flipswitch"), 1);
	thread(f_music_e5m2_enable_panel());
	object_create(e5m2_door_dm);
	device_set_power (e5m2_device_control, 1);
	device_set_position_track( e5m2_door_dm, "any:idle", 0.0 );
	thread (e5m2_panel_accessed());
	//f_new_objective (e5m1_obj_switch);
end

script static void e5m2_objective_3a_maybe 															// if player hasn't already interacted with panel, give objective
	if(e5m2_interior_door_open == false)then
				thread(f_new_objective(e5m2_objective_text_03a));
									// "Open the Safe Room"
				thread(f_music_e5m2_objective_3a_maybe());
	end
end

script static void e5m2_panel_accessed
	b_wait_for_narrative_hud = false;	
	sleep_until (LevelEventStatus ("e5m3_flipswutch"), 1);
	thread(f_music_e5m2_panel_accessed());
	e5m2_interior_door_open = true;
	object_destroy (e5m2_device_control);
	device_set_position_track( e5m2_door_dm, "any:active", 0.0 );
	device_animate_position( e5m2_door_dm, 1, 3, 1.0, 1.0, TRUE );
	thread(e5m2_open_interior_doors());
	sleep (30 * 6);
	object_dissolve_from_marker(e5m2_door_dm, phase_out, panel);
	sleep (30 * 6);
	object_destroy (e5m2_door_dm);
end

script static void e5m2_open_interior_doors  
	thread(f_music_e5m2_open_interior_doors());
	ai_place (e5m2_ally_scientists);
	device_set_position_track( e5m2_interior_door, "any:idle", 0.0 );
	device_animate_position( e5m2_interior_door, 1, 3.5, 1.0, 1.0, TRUE );
	//insert_door_audio_here
	//////////////////////////////////////////////////
	b_wait_for_narrative_hud = true;								// this initial bit is to suppress drop pod blips
	b_end_player_goal = TRUE;												// advance objectives
	sleep(30 * 2);
	b_wait_for_narrative_hud = false;
	object_immune_to_friendly_damage(ai_actors(e5m2_ally_scientists), true);
	///////////////////////////////////////////////
	sleep(30 * 2);
	thread(f_music_e5m2_dooropen_vo());
	wake(e5m2_vo_dooropen);
	sleep_forever();
end

script static void e5m3_blitz_shake_and_vo										// called from e5m3_dooropen_callback
	//rumble
	thread(camera_shake_all_coop_players (.4, .4, 3, 1.8));
	sleep (30);
	//vo
	thread(f_music_e5m2_blitz_shake_and_vo());
	thread(e5m2_vo_lottadropships());
	e5m3_civilian_state = 1;																		// send marines to panic room
	sleep(4);
	if(ai_living_count(e5m2_ally_marine_1) > 0)then
		cs_go_to_and_face(e5m2_ally_marine_1, true, panic_room_pts.p1, panic_room_pts.p3);
		ai_set_task(e5m2_marine_1, "aio_marine", "task_panic_room");
	end
	if(ai_living_count(e5m2_ally_marine_2) > 0)then
		sleep(30 *2);
		cs_go_to_and_face(e5m2_ally_marine_2, true, panic_room_pts.p1, panic_room_pts.p3);
		ai_set_task(e5m2_marine_2, "aio_marine", "task_panic_room");
	end
end

script static void e5m2_start_blitz 
	
	sleep(30);
	thread(f_music_e5m2_start_blitz());
	thread(f_new_objective(e5m2_objective_text_04));						// play objective
				// "Defend Against the Covenant Onslaught"
	b_wait_for_narrative_hud = true;														// this initial bit is to suppress drop pod blips
	sleep(30);
	b_wait_for_narrative_hud = false;
	sleep(3);
	f_blip_object_cui (e5m2_lz_02, "navpoint_defend");
	sleep(1);
	b_wait_for_narrative_hud = true;
	wake(e5m2_reenable_blips);
	sleep(30 *6);
	thread(camera_shake_all_coop_players (.4, .4, 3, 1.8));
	thread(e5m2_blitz_done());
	thread(e5m2_ext2_start());
	thread(e5m2_ext2_2());
	thread(e5m2_ext2_3());
	thread(e5m2_ext2_4());
	sleep_forever();
end

script dormant e5m2_reenable_blips
	sleep_until (LevelEventStatus("e5m2_reenable_blips"), 1);
	thread(f_music_e5m2_reenable_blips());
	b_wait_for_narrative_hud = false;
	sleep(15);
	thread(f_new_objective(e5m2_objective_text_01b));						// play objective
				// "Eliminate the Remaining Covenant"
	sleep_forever();
end

script command_script e5m2_blitzers_task_1
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_1a, aio_blitzrush);
end

script command_script e5m2_blitzers_task_2
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_1b, aio_blitzrush);
end

script command_script e5m2_blitzers_task_3
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_2a, aio_blitzrush);
end

script command_script e5m2_blitzers_task_4
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_2b, aio_blitzrush);
end

script command_script e5m2_blitzers_task_5
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_3a, aio_blitzrush);
end

script command_script e5m2_blitzers_task_6
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_3b, aio_blitzrush);
end

script command_script e5m2_blitzers_task_7
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_4a, aio_blitzrush);
end

script command_script e5m2_blitzers_task_8
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_4b, aio_blitzrush);
end

script command_script e5m2_blitzers_task_9
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_5a, aio_blitzrush);
end

script command_script e5m2_blitzers_task_10
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_6a, aio_blitzrush);
end

script command_script e5m2_blitzers_task_11
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_6b, aio_seek_player);
end

script command_script e5m2_blitzers_task_12
	sleep(30 * 5);
	ai_set_objective (e5m2_foes_blitz_wave_5b, aio_seek_player);
end

script command_script e5m2_ext2_relay_1a
	sleep(30 * 5);
	ai_set_task (sq_e5m2_ext2_first_pod_1, aio_exterior_end, ne_door_stage_ramps );
	print("................relay_1a");
end

script command_script e5m2_ext2_relay_2a
	sleep(30 * 5);
	ai_set_task (sq_e5m2_ext2_2nd_pod_1, aio_exterior_end, nw_buttress );
	print("................relay_2a");
end

script command_script e5m2_ext2_relay_3a
	sleep(30 * 5);
	ai_set_task (sq_e5m2_ext2_3rd_pod_1, aio_exterior_end, gunner_bunker );
	print("................relay_3a");
end

script static void f_e5m3_blitz_task_dead
	s_e5m3_blitz = s_e5m3_blitz + 1;
	print("s_e5m3_blitz == :");
	inspect(s_e5m3_blitz);
end

script static void e5m3_blitz_almost_done 
	sleep_until (LevelEventStatus("e5m3_blitz_almost_done"), 1);
	sleep(40);
	thread(e5m3_vo_oncruiser());
end

script static void e5m3_blitz_nearly_done											// TOTALLY DIFFERENT THAN 'ALMOST' DONE
	sleep_until (LevelEventStatus("e5m3_blitz_nearly_done"), 1);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	thread(e5m3_cleanup_objective_after_delay());
	sleep(30);
	vo_glo_remainingcov_02();
	f_blip_object_cui (e5m2_lz_02, "");
	e5m3_conch = false;
end

script static void e5m3_cleanup_objective_after_delay
	sleep(30 * 4);
	thread(f_new_objective(e5m2_objective_text_01b));						// play objective
						//"Eliminate the Remaining Covenant"
end

script static void e5m2_blitz_done

	sleep_until (LevelEventStatus("e5m2_blitz_done"), 1);
	thread(f_music_e5m2_blitz_done());

	sleep(30 * 2);
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	vo_glo_incoming_03();
						// Miller : Don't relax yet. You've got more hostiles headed your way.
	e5m3_conch = false;					
	sleep(20);
	thread(f_new_objective(e5m2_objective_text_05));						// play objective
			// "Clear an LZ Outside the Structure"
	e5m3_civilian_state = 2;																		// send civilians to exit hallway
	thread(e5m2_ext2_almost_done());
	thread(e5m2_all_combat_done());
	thread(e5m3_hunter_checker());
	if(ai_living_count(e5m2_ally_scientists) > 0)then
//	print ("==============================================================");
//	print ("=================scientist told to kindly move his ass========");
//	print ("==============================================================");	
		ai_set_task(e5m2_scientist_1, "aio_marine", "task_scientist");
		cs_go_to_and_face(e5m2_scientist_1, true, scientist_hall.p0, scientist_hall.p1);
	end
end

//== Exterior, After=========================
// ==============================================================================================================
//			
//			    ______      __            _                  ___    ______           
//			   / ____/_  __/ /____  _____(_)____  _____     /   |  / __/ /____  _____
//			  / __/  | |/_/ __/ _ \/ ___/ // __ \/ ___/    / /| | / /_/ __/ _ \/ ___/
//			 / /___ _>  </ /_/  __/ /  / // /_/ / /  _    / ___ |/ __/ /_/  __/ /    
//			/_____//_/|_|\__/\___/_/  /_/ \____/_/  ( )  /_/  |_/_/  \__/\___/_/     
//			                                        |/                               
//
// ==============================================================================================================

script static void e5m2_ext2_start
	sleep_until (LevelEventStatus("e5m3_ext2_start"), 1);
	s_e5m3_combat_progress = 10;
	thread(f_music_e5m2_ext2_start());
	thread(e5m3_snipers_north());
end
script static void e5m2_ext2_2												// reinforcements
	sleep_until (LevelEventStatus("e5m3_ext2_2"), 1);
	s_e5m3_combat_progress = 11;
end
script static void e5m2_ext2_3												// gunner nest
	sleep_until (LevelEventStatus("e5m3_ext2_3"), 1);
	s_e5m3_combat_progress = 12;
end
script static void e5m2_ext2_4												// hunters
	sleep_until (LevelEventStatus("e5m3_ext2_4"), 1);
	s_e5m3_combat_progress = 13;
end
script static void e5m3_snipers_north
	if(volume_test_players (tv_sniper_north) == true)then
		b_e5m3_north_snipers = true;
	else
		b_e5m3_north_snipers = false;
	end
	sleep(30);
	thread(e5m3_snipers_south());
end
script static void e5m3_snipers_south
	if(volume_test_players (tv_sniper_south) == true)then
		b_e5m3_south_snipers = true;
	else
		b_e5m3_south_snipers = false;
	end
	sleep(30);
	thread(e5m3_snipers_north());	
end
script static void e5m2_hunters_vo_play
	sleep(10);
	sleep_until (LevelEventStatus("e5m3_hunters"), 1);
	wake(e5m3_vo_hunters);
	thread(f_music_e5m2_hunters_play_vo());
end

script command_script e5m3_civilian_dustoff_a					//marine 1
	cs_go_to_and_face(dustoff.p0, dustoff.p1);
	sleep_forever();
end
script command_script e5m3_civilian_dustoff_b					//marine 2
	cs_go_to_and_face(dustoff.p2, dustoff.p3);
	sleep_forever();
end
script command_script e5m3_civilian_dustoff_c					//scientist
	cs_go_to_and_face(dustoff.p4, dustoff.p0);
	sleep_forever();
end

script static void e5m2_ext2_almost_done
	sleep_until (LevelEventStatus("e5m2_ext2_almost_done"), 1);
	thread(f_music_e5m2_ext2_almost_done());
	sleep_until(e5m3_conch == false);
	e5m3_conch = true;
	sleep(30);
	vo_glo_cleararea_01();
	thread(f_music_e5m2_wrapup_vo_2());
	sleep(30 * 4);
	e5m3_conch = false;
	thread(f_new_objective(e5m2_objective_text_01b));		// play objective
				//"Eliminate the Remaining Covenant"
	sleep(30);
	sleep_forever();
end

script static void e5m2_all_combat_done
	sleep(10);
	sleep_until (LevelEventStatus("e5m2_all_combat_done"), 1);
	thread(f_music_e5m2_all_combat_done());
	sleep(30 * 3);
	thread(e5m3_cruiserboom());
	
	print ("==============================================================");
	print ("=================combat all done =============================");
	print ("==============================================================");
	
	e5m3_civilian_state = 3;														// send civilians to wait for pelican
	
	thread(f_music_e5m2_finish());
end

// crash cruiser
script static void cruiser_amb_crash_1
	thread (e5m3_cruiser_rotate());
	thread (e5m3_cruiser_fall());
	thread(e5m3_blip_cruiser());
end

script static void e5m3_blip_cruiser
	navpoint_track_object_named (cov_cruiser, "navpoint_enemy_vehicle");
	sleep(30 * 5);
	navpoint_track_object_named (cov_cruiser, "");
end

script static void e5m3_cruiser_init
	object_move_to_point (cov_cruiser, 180, cruiser.cruiser);
end

script static void e5m3_cruiser_rotate
	sleep(30 * 2);
	object_rotate_to_point (cov_cruiser, 50, 50, 50, cruiser.p0);
	object_rotate_to_point (cov_cruiser, 50, 50, 50, cruiser.p1);
end

script static void e5m3_cruiser_fall()
	thread (cruiser_fall_fx());
	sleep (30 * 2);
	object_move_to_point (cov_cruiser, 42, cruiser.p0);
////	effect_new_at_ai_point ("environments\solo\m10_crash\fx\explosions\explosion_cov_cruiser.effect", cruiser.p0);
	object_move_to_point (cov_cruiser, 42, cruiser.p1);
////	effect_new_at_ai_point ("environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect", cruiser.f1);
	object_move_to_point (cov_cruiser, 42, cruiser.p2);
end

script static void cruiser_fall_fx()
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explode_lg_02.effect", cov_cruiser, fx_damage_01);
	print (":  : Boom Cruiser 1-1 :  :");
	thread(camera_shake_all_coop_players (.4, .4, 3, 1.8));
	sleep (30 * 2);
	effect_new_on_object_marker_loop ("environments\solo\m60_rescue\fx\explosion\cruiser_damage_smoke.effect", cov_cruiser, fx_smoke_03);
	print (":  : Boom Cruiser 1-2 :  :");
	sleep (30 * 2);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", cov_cruiser, cruiser_turret_f);
	print (":  : Boom Cruiser 1-3 :  :");
	sleep (30);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", cov_cruiser, cruiser_turret_e);
	print (":  : Boom Cruiser 1-4 :  :");
	sleep (15);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", cov_cruiser, cruiser_turret_d);
	print (":  : Boom Cruiser 1-5 :  :");
	sleep (5);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", cov_cruiser, cruiser_turret_c);
	print (":  : Boom Cruiser 1-6 :  :");
	sleep (30 * 5);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explode_lg_02.effect", cov_cruiser, fx_damage_02);
	print (":  : Boom Cruiser 1-7 :  :");
	thread(camera_shake_all_coop_players (.4, .4, 3, 1.8));
	sleep (30 * 3);
	effect_new_on_object_marker_loop ("environments\solo\m60_rescue\fx\explosion\cruiser_damage_smoke.effect", cov_cruiser, fx_smoke_01);
	
end

//== Ancillary======================
// ========================================================================================================		
//		     ___      .__   __.   ______  __   __       __          ___      .______     ____    ____ 
//		    /   \     |  \ |  |  /      ||  | |  |     |  |        /   \     |   _  \    \   \  /   / 
//		   /  ^  \    |   \|  | |  ,----'|  | |  |     |  |       /  ^  \    |  |_)  |    \   \/   /  
//		  /  /_\  \   |  . `  | |  |     |  | |  |     |  |      /  /_\  \   |      /      \_    _/   
//		 /  _____  \  |  |\   | |  `----.|  | |  `----.|  `----./  _____  \  |  |\  \----.   |  |     
//		/__/     \__\ |__| \__|  \______||__| |_______||_______/__/     \__\ | _| `._____|   |__|     
//		                                                                                              
// ========================================================================================================

script command_script cs_e5m2_phantom_1()
	sleep(4);
	if 	( 	(ai_vehicle_count(e5m2_ff_phantoms) 	> 1) and
					(ai_vehicle_count(e5m2_veh_phantom_4) > 0) 
			)then		//user probably cheated, but just in case
		print("<><><><><><><><><><><><><><><><><><><><><><><> phantom_1 cleared for takeoff");
	else
		sleep_until( (e5m2_phantom_path_clear == true)  or (ai_vehicle_count(e5m2_ff_phantoms) < 2) );
	end
	s_e5m2_phantom_1_load_state = 1;																		// allows load-in script to advance
	e5m2_phantom_path_clear = false; 																		// gives the go-ahead for other phantoms to fly in
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_get_object(ai_current_squad), TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(5);
	sleep_until(s_e5m2_phantom_1_load_state == 2);											// wait for load-in script to call back
	sleep(2);
	s_e5m2_phantom_1_load_state = 0;																		// reset var
	//cs_fly_by (ps_ff_phantom_08.p0);
	cs_fly_to(ps_ff_phantom_08.p1);
	cs_fly_to(ps_ff_phantom_08.p2);
	cs_fly_to_and_face (ps_ff_phantom_08.p3, ps_ff_phantom_facing.p2);
	sleep (15);

	f_unload_phantom (ai_current_squad, "dual");
	
	sleep (30 * 3.5);
	cs_fly_to (ps_ff_phantom_08.p4);
	cs_fly_by (ps_ff_phantom_08.p5);
	cs_fly_by (ps_ff_phantom_08.p6);
	cs_fly_by (ps_ff_phantom_08.p7);
	e5m2_phantom_path_clear = true; 																		// gives the go-ahead for other phantoms to fly in
	sleep (30 * 1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30);	//Shrink size over time (making it quick because it shouldn't be seen)
	sleep(5);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	//object_destroy(ai_vehicle_get_from_spawn_point(ph_e3m5_center_gunship.spawn_points_0), "hull",5000)
	sleep(5);
	e5_m3_phantom_despawn_hack(ai_current_squad);
end

script command_script cs_e5m2_phantom_1a()
	sleep(4);
	if 	( 	(ai_vehicle_count(e5m2_ff_phantoms) 	> 1) and
					(ai_vehicle_count(e5m2_veh_phantom_4) > 0) 
			)then		//user probably cheated, but just in case
		print("<><><><><><><><><><><><><><><><><><><><><><><> phantom_1 cleared for takeoff");
	else
		sleep_until( (e5m2_phantom_path_clear == true)  or (ai_vehicle_count(e5m2_ff_phantoms) < 2) );
	end
	e5m2_phantom_path_clear = false; 																		// gives the go-ahead for other phantoms to fly in
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_get_object(ai_current_squad), TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(2);
	cs_fly_to(ps_ff_phantom_08.p1);
	cs_fly_to(ps_ff_phantom_08.p2);
	cs_fly_to_and_face (ps_ff_phantom_08.p3, ps_ff_phantom_facing.p2);
	sleep (15);

	f_unload_phantom (ai_current_squad, "dual");
	
	sleep (30 * 3.5);
	cs_fly_to (ps_ff_phantom_08.p4);
	cs_fly_by (ps_ff_phantom_08.p5);
	cs_fly_by (ps_ff_phantom_08.p6);
	cs_fly_by (ps_ff_phantom_08.p7);
	e5m2_phantom_path_clear = true; 																		// gives the go-ahead for other phantoms to fly in
	sleep (30 * 1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30);	//Shrink size over time (making it quick because it shouldn't be seen)
	sleep(5);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e5_m3_phantom_despawn_hack(ai_current_squad);
end

script command_script cs_e5m2_phantom_2()
	sleep_until( (e5m2_phantom_path_clear == true)  or (ai_vehicle_count(e5m2_ff_phantoms) < 2) );
	e5m2_phantom_path_clear = false; 																		// gives the go-ahead for other phantoms to fly in
	s_e5m2_phantom_2_load_state = 1;																		// allows load-in script to advance
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_get_object(ai_current_squad), TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep_until(s_e5m2_phantom_2_load_state == 2);											// wait for load-in script to call back
	sleep(2);
	s_e5m2_phantom_2_load_state = 0;																		// reset var

	cs_fly_to(ps_ff_phantom_08.p1);
	cs_fly_to(ps_ff_phantom_08.p2);
	cs_fly_to_and_face (ps_ff_phantom_08.p3, ps_ff_phantom_facing.p2);
	sleep (30 * 1);

	f_unload_phantom (ai_current_squad, "dual");
	
	sleep (30 * 3.5);
	//firing sequence
	cs_face (true, ps_ff_phantom_facing.center);
	sleep(30 * 1);
	ai_set_blind (ai_current_squad, FALSE);
	cs_enable_targeting(true);
	cs_fly_to_and_face (ps_ff_phantom_08.p0, ps_ff_phantom_facing.left);
	sleep(30 * 3);
	cs_fly_to_and_face (ps_ff_phantom_08.p8, ps_ff_phantom_facing.right);
	sleep(30 * 3);
	cs_fly_to_and_face (ps_ff_phantom_08.p0, ps_ff_phantom_facing.left);
	sleep(30 * 3);
	cs_fly_to_and_face (ps_ff_phantom_08.p3, ps_ff_phantom_facing.center);
	sleep(30 * 8);
	cs_enable_targeting(false);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(30 * 1);
		//fly-out
	cs_fly_to_and_face (ps_ff_phantom_08.p5, ps_ff_phantom_08.p7);
	cs_fly_to_and_face (ps_ff_phantom_08.p6, ps_ff_phantom_08.p7);
	cs_fly_by (ps_ff_phantom_08.p7);
	e5m2_phantom_path_clear = true; 																		// gives the go-ahead for other phantoms to fly in
	sleep (30 * 1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30);  //Shrink size over time (making it quick because it shouldn't be seen)
	sleep(5);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e5_m3_phantom_despawn_hack(ai_current_squad);
end

script command_script cs_e5m2_phantom_2a()
	sleep_until( (e5m2_phantom_path_clear == true)  or (ai_vehicle_count(e5m2_ff_phantoms) < 2) );
	e5m2_phantom_path_clear = false; 																		// gives the go-ahead for other phantoms to fly in
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_get_object(ai_current_squad), TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_to(ps_ff_phantom_08.p1);
	cs_fly_to(ps_ff_phantom_08.p2);
	cs_fly_to_and_face (ps_ff_phantom_08.p3, ps_ff_phantom_facing.p2);
	sleep (30 * 1);

	f_unload_phantom (ai_current_squad, "dual");
	
	sleep (30 * 3.5);
	//firing sequence
	cs_face (true, ps_ff_phantom_facing.center);
	sleep(30 * 1);
	ai_set_blind (ai_current_squad, FALSE);
	cs_enable_targeting(true);
	cs_fly_to_and_face (ps_ff_phantom_08.p0, ps_ff_phantom_facing.left);
	sleep(30 * 3);
	cs_fly_to_and_face (ps_ff_phantom_08.p8, ps_ff_phantom_facing.right);
	sleep(30 * 3);
	cs_fly_to_and_face (ps_ff_phantom_08.p0, ps_ff_phantom_facing.left);
	sleep(30 * 3);
	cs_fly_to_and_face (ps_ff_phantom_08.p3, ps_ff_phantom_facing.center);
	sleep(30 * 8);
	cs_enable_targeting(false);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(30 * 1);
		//fly-out
	cs_fly_to_and_face (ps_ff_phantom_08.p5, ps_ff_phantom_08.p7);
	cs_fly_to_and_face (ps_ff_phantom_08.p6, ps_ff_phantom_08.p7);
	cs_fly_by (ps_ff_phantom_08.p7);
	e5m2_phantom_path_clear = true; 																		// gives the go-ahead for other phantoms to fly in
	sleep (30 * 1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30);  //Shrink size over time (making it quick because it shouldn't be seen)
	sleep(5);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e5_m3_phantom_despawn_hack(ai_current_squad);
end

script command_script cs_e5m2_opening_phantom()
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_get_object(ai_current_squad), TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep_until (volume_test_players (trigger_volume_opening), 1);
		
	cs_fly_to_and_face (e5m2_first_phantom.p0, e5m2_first_phantom.p1);
	sleep (30 * 1);
	f_unload_phantom (ai_current_squad, "dual");
	sleep (30 * 3.5);
	cs_face(true, e5m2_first_phantom.p2);
	sleep (30 * 1);
	ai_set_blind (ai_current_squad, FALSE);
	cs_enable_targeting(true);
	sleep (30 * 3);
	cs_fly_to_and_face (e5m2_first_phantom.p5, e5m2_first_phantom.p3);
	sleep(30 * 5);
	cs_fly_to_and_face (e5m2_first_phantom.p4, e5m2_first_phantom.p2);
	sleep(30 * 3);
	cs_fly_to_and_face (e5m2_first_phantom.p5, e5m2_first_phantom.p3);
	sleep(30 * 5);
	cs_fly_to_and_face (e5m2_first_phantom.p4, e5m2_first_phantom.p2);
	sleep(30 * 10);
	cs_fly_to_and_face (e5m2_first_phantom.p6, e5m2_first_phantom.p3);
	e5m2_phantom_path_clear = true; 																		// gives the go-ahead for other phantoms to fly in
	cs_enable_targeting(false);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(30 * 1);
	//fly-out
	cs_fly_to_and_face (e5m2_first_phantom.p7, e5m2_first_phantom.p8);
	cs_fly_to_and_face (e5m2_first_phantom.p9, e5m2_first_phantom.p11);
	cs_fly_to_and_face (e5m2_first_phantom.p10, e5m2_first_phantom.p11);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30);  //Shrink size over time (making it quick because it shouldn't be seen)
	sleep(5);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep (5);
	e5_m3_phantom_despawn_hack(ai_current_squad);
end

script command_script cs_e5m2_bkg_phantom_4
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_get_object(ai_current_squad), TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	sleep_until (volume_test_players (trigger_spartan_box), 1);
	cs_fly_to_and_face (e5m2_bkg_phantom_4.p0, ps_ff_phantom_facing.p0);
//	cs_fly_to_and_face (e5m2_bkg_phantom_4.p1, e5m2_bkg_phantom_4.p6);
//	cs_fly_by (e5m2_bkg_phantom_4.p0);
	cs_fly_by (e5m2_bkg_phantom_4.p1);
	//cs_fly_to_and_face (e5m2_bkg_phantom_4.p2, e5m2_bkg_phantom_4.p5);
	cs_fly_by (e5m2_bkg_phantom_4.p2);
	cs_fly_by (e5m2_bkg_phantom_4.p3);
	cs_fly_by (e5m2_bkg_phantom_4.p4);
	cs_fly_to (e5m2_bkg_phantom_4.p5);

	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30); //Shrink size over time (making it quick because it shouldn't be seen)
	sleep(5);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e5_m3_phantom_despawn_hack(ai_current_squad);
	
end

script command_script cs_e5m2_bkg_phantom_5
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_get_object(ai_current_squad), TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep_until (volume_test_players (trigger_volume_opening), 1);
	cs_fly_by (e5m2_bkg_phantom_5.p0);
	cs_fly_to_and_face (e5m2_bkg_phantom_5.p1, e5m2_bkg_phantom_5.p3);
	cs_fly_to_and_face (e5m2_bkg_phantom_5.p2, e5m2_bkg_phantom_5.p4);
	cs_fly_by (e5m2_bkg_phantom_5.p4);
	cs_fly_to (e5m2_bkg_phantom_5.p5);

	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30); //Shrink size over time (making it quick because it shouldn't be seen)
	sleep(5);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e5_m3_phantom_despawn_hack(ai_current_squad);
end


script static void e5_m3_phantom_despawn_hack(ai phantom)
	sleep(30);
	print("----=-=-=-=-----trying to ai_kill phantom");
	if(ai_living_count(phantom) > 0) then
		print("----=-=-=-=-----phantom alive, trying to erase");
		//ai_erase (ai_get_squad(phantom));
		ai_erase (phantom);
		print("----=-=-=-=-----tried to erase, ==--=-=-=-=-=-=-=-=---=====");
		sleep(2);
		e5_m3_phantom_despawn_hack(phantom);
	else
		print("----=-=-=-=-----phantom presumed dead, sleeping forever");
		sleep_forever();
	end
end

script static void e5m3_drop_blitz_wind_down
	sleep_until(LevelEventStatus("e5m2_blitz_wind_down"), 1);
	s_e5m3_combat_progress = 9;
	ai_set_objective(e5m2_ff_all, aio_seek_player);
	print("<> <> <> <> <> <> <> <> <> <> <> seek_player called");
end

script static void seek_player
	sleep_until(LevelEventStatus("seek_player"), 1);
	print("<> <> <> <> <> <> <> <> <> <> <> seek_player called");
	ai_set_objective(e5m2_ff_all, aio_seek_player);
end

script static void drop_pod_twist_test(object_name pod, object_name rail, short degree) 
// drop_pod_twist_test(drop_pod_lg_02, e5m2_droprail_02, 0) 
	// e5m2_droprail_02 position: 37.872810, -6.267796, 2.243511
	// e5m2_droprail_01 37.922535, 11.436625, 0.888014
	//local object_name pod = drop_pod_lg_02;
	//local object_name rail = e5m2_droprail_02;
	local ai squad = drop_pod_test;
	object_create_anew (pod);
	object_hide (pod, true);
	SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 0.0); // make sure the thrusters are off (I think this is unnecessary, but never hurts to be sure)
	object_create_anew (rail);
	device_set_position (device(rail), 1);
	objects_attach (rail, "", vehicle(pod), "");
	object_set_scale (pod, 0.1, 1);
	sleep (2);
	ai_place(squad);
	ai_vehicle_enter_immediate (squad, vehicle(pod));
	if vehicle_test_seat (vehicle(pod), "") == false then
		print ("no seats taken, the squad didn't get put into the drop pod :(");
	else
		print ("squad teleported into drop pod");
	end
	
	object_hide (pod, false);
	object_set_scale (pod, 1.0, 60);
	sleep (10);
	sleep_until (device_get_position (device(rail)) >= 0.75, 1); // close to end of anim
	object_rotate_by_offset (rail, 1, 0, 0, (-1 *(degree)), 0, 0); // spin!
	SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 0.5);								// turn on the thrusters at half power to hover
	sleep_until (device_get_position (device(rail)) == 1, 1);
	device_set_power (device(rail), 0);
	unit_open (vehicle(pod));
	ai_vehicle_exit (squad);
	sleep (30 * 3);
	device_set_power (device(rail), 1);
	object_rotate_by_offset (rail, 1, 0, 0, (degree), 0, 0);
	sleep (1);
	SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 1.0); // turn on the thrusters at full power
	device_set_position (device(rail), 0);
	sleep_until (device_get_position (device(rail)) == 0, 1, (30 * 5));
	object_set_scale (pod, 0.01, 30);
	sleep (60);
		objects_detach (rail, vehicle(pod));
	object_destroy (rail);
	object_destroy (pod);
//print ("done with drop pod");
//	object_destroy (pod_name);
end

global object g_ics_player = none;

script static void f_push_fore_switch (object control, unit player)
//script static void f_push_fore_switch (unit player)
	print ("pushing the forerunner switch");
	
	g_ics_player = player;
	pup_play_show (e5m3_pushbutton);

end
