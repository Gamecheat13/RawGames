
// =================================================================================================
// =================================================================================================
// Prep Room  / Corner Hall  SCWARNER
// =================================================================================================
// =================================================================================================


global short S_flank_obj = 0;

global short DEF_HALLWAY_OBJ_START 		  	    = 1;
global short DEF_HALLWAY_OBJ_LOOKOUT	   	 	  = 2;
global short DEF_HALLWAY_OBJ_CH	  	 	  			= 3;
global short DEF_HALLWAY_OBJ_CH_SHIELD_ROOM   = 4;
global short DEF_HALLWAY_OBJ_CH_COMBAT  	 	  = 5;
global short DEF_FLANK_OBJ_MAIN_START		 	  	= 6;
global short DEF_FLANK_OBJ_MAIN_ENGAGE	 	 		= 7;
global short DEF_FLANK_OBJ_MAIN_ADVANCE  	 		= 8;
global short DEF_FLANK_OBJ_AIRLOCK 			 	 		= 9;

global short S_hallway_move_grunts = 0;
global short S_elite_retreat = 0;
global short S_hallways2_move_grunts = 0;
global short S_cafe_jackal_gate = 0;
global boolean B_move_hallways_grunts = FALSE;
global boolean B_unlock_airlock = FALSE;
global boolean B_cafe_jackal_move = FALSE;
global boolean B_airlock_1_complete = FALSE;
global boolean B_flank_center_move = FALSE;
global boolean B_flank_doorpastelevator_open = FALSE;
global boolean b_cafe_jackals_crossed = FALSE;
global boolean b_conc_elite_enter = FALSE;

//////////////////////////////////////////////////////////////

script startup f_flank_init()
sleep_until (b_mission_started == TRUE);
	wake(f_flank_main);
end

//====== MAIN FUNCTION
//====== We're going to setup up everything here from Hallways to Flank
//====== These encounters occur between BSP 08 Elevator and BSP 028 Airlock
//====== BSP 030 Beacons is also used at part of the section but for 
//====== framing purposes only (no encounters occur here... yet)

script dormant f_flank_main()
	sleep_until (current_zone_set_fully_active() == S_zoneset_08_elevator_14_elevator_16_lookout, 1);
	
	thread(f_lookout_door_block());
	thread(f_cafe_door_block());
	thread(f_flank_door_block());
	thread(f_check_disable_backtrack());
  thread(f_mus_m10_e02_begin());
	ai_place(ai_hallways);
	ai_place(ai_lookout);
	thread(f_lookout_dialog_check());
	wake(f_door_post_elevator);
	pup_play_show(obs_ships);
	pup_play_show(debris_show);
	sleep_s(1);
	wake(f_door_pre_lookout);
	wake(f_hallways_grunt_move);
	sleep_until(volume_test_players(tv_lookout_spawn), 1);
	ai_place(hallways_lookout_phantom);
	sleep_until(volume_test_players(tv_lookout_vo), 1);
	wake(f_cafe_encounter_start);
	wake(f_hallways_2_encounter_start);
	wake(f_flank_encounter_start);
	wake(f_flank_save);
  wake(f_flank_music_start);
end

//====== f_hallways_2_encounter_start()
//====== This will spawn in the A.I. in the second hallways section
//====== after the 16_18_30 zoneset has been loaded
//====== We also wake f_hallways_2_grunt_move() here which will eventually
//====== close out a task in this objective that allows grunts to move forward 
//====== during the encounter (mostly for staging purposes)

script dormant f_hallways_2_encounter_start()
	dprint("prepping hallways 2");
	sleep_until (current_zone_set_fully_active() == s_zoneset_16_lookout_18_elevator_20_cafe, 1);
	dprint("placing hallways 2");
	ai_place(ai_hallways_2);
	wake(f_hallways_2_grunt_move);
end

//====== f_hallways_2_grunt_move()
//====== This closes a task in obj_hallways (move_gate_grunts) and causes them to start moving down the hall
//====== once the player is in sight of the back

script dormant f_hallways_2_grunt_move()
	sleep_until(volume_test_players(tv_hallways2_gruntmove), 1);
	S_hallways2_move_grunts = 1;
end


//====== f_hallways_grunt_move()
//====== This closes a task in obj_hallways (move_gate_grunts) and causes them to start moving down the hall
//====== The intent is that they are moving away from the player when they come into his view

script dormant f_hallways_grunt_move()
	sleep_until(volume_test_players(tv_open_door_post_elevator), 1);
  S_hallway_move_grunts = 1;  
end

//====== f_cafe_encounter_start()
//====== This will spawn in the A.I. in the Cafe section
//====== after the 16_18_30 zoneset has been loaded
//====== It also calls the f_jackal_reinforce which brings in Jackals from behind
//====== the two doors at the back of the encounter after a specified amount of time in script
//====== also, gamesave.

script dormant f_cafe_encounter_start()
	sleep_until (current_zone_set_fully_active() == S_zoneset_16_lookout_18_elevator_20_cafe, 1);
	game_save_cancel();
	game_save_no_timeout();
	zone_set_trigger_volume_enable("zone_set:24_corner_26_box_28_airlock", FALSE);
	thread(f_flank_preload());
	ai_place(ai_cafe_init);
	//wake(f_jackal_reinforce);
	wake(f_wr_corner_hall);
end

//====== f_flank_encounter_start()
//====== This will spawn in the A.I. in the flank area
//====== once a player has entered the tv_flank_spawn trigger volume

script dormant f_flank_encounter_start()
	sleep_until(volume_test_players(tv_flank_spawn), 1);
	wake(f_flank_center_move);
	S_flank_obj = DEF_FLANK_OBJ_MAIN_START;
	wake(f_flank_spawn);
	sleep_until(volume_test_players(tv_flank_enter)or ai_combat_status(flank_encounter) >= 8, 1);
	S_flank_obj = DEF_FLANK_OBJ_MAIN_ENGAGE;
	wake(f_beacon_main);
  S_flank_obj = DEF_FLANK_OBJ_MAIN_ADVANCE;
  wake(f_wr_airlock);
  game_insertion_point_unlock(1); 


end


//====== f_flank_encounter_start()
//====== This will spawn in the A.I. in the flank area
//====== once a player has entered the tv_flank_spawn trigger volume


script dormant f_flank_spawn()
	sleep_until (current_zone_set_fully_active() == S_zoneset_24_corner_26_box_28_airlock, 1);
	data_mine_set_mission_segment ("m10_Flank");
	ai_place(ai_flank);
	ai_place(ai_flank_2);
//  pup_play_show(elite_spot_player);
	wake(f_pre_beac_airlock_physics);
	sleep_until(volume_test_players(tv_flank_playerpos_far_back));
	pup_play_show(elite_door);
	
end


//====== f_jackal_reinforce()
//====== This function brings in Jackals through the doors behind
//====== the encoutner in the Cafe - this is timed to happen after 

script dormant f_jackal_reinforce()
	//sleep_until (volume_test_players(tv_cafe_opendoors), 1);
	sleep_until(ai_living_count(ai_cafe_init) <= 2);
	ai_place(ai_cafe_reinforce);
	sleep_s(1);
	wake(f_door_ch_door_02);
	wake(f_door_ch_door_01);
	sleep_until (dm_ch_door_02->check_open(), 1);
	if not volume_test_players(tv_cafe_opendoors) then
		local long j_door = pup_play_show(jackals_door);
		sleep_until(not pup_is_playing(j_door));
		b_cafe_jackals_crossed = TRUE;
	end
	b_cafe_jackal_move = 1;
end

//====== f_flank_center_move()
//====== sets a boolean to true so a task making A.I. wait until the player 
//====== shows up closes out

script dormant f_flank_center_move()
	sleep_until(volume_test_players(tv_flank_spawn), 1);
	B_flank_center_move = TRUE;
end

//======= WEAPON RACKS
//======= These functions activate weapon rack machines as soon as players
//======= enter specified volumes.

//======= Activates the big UNSC weapon box in BSP 020 CAFE

script dormant f_wr_corner_hall()
	sleep_until(volume_test_players(tv_corner_hall_spawn) == TRUE, 1);
	game_save_cancel();
	game_save_no_timeout();
	thread(wr_corner_hall_3->open_default());
end

//======= Activates the Battle Rifle Wall Dispensers in BSP 026 Box Room

script dormant f_wr_airlock()
	sleep_until(volume_test_players(tv_airlock_start) == TRUE, 1);	
	thread(wr_flank_br_01->open_default());
	thread(wr_flank_br_02->open_default());
	thread(wr_flank_br_03->open_default());
	thread(wr_flank_br_04->open_default());
			
end

//====== MUSIC FUNCTIONS

script static void f_flank_music()
	sleep_until(ai_living_count (flank_encounter) < 1, 1);
	sleep_until(ai_living_count (flank_encounter) == 0, 1);
	thread(f_music_main_flank_killed_all_enemies());
end


script dormant f_flank_music_start()
  sleep_until (volume_test_players_all (tv_flank_enter), 1);
  thread(f_mus_m10_e02_finish());
  thread(f_mus_m10_e03_begin());
end


script dormant f_flank_music_end()
  sleep_until (volume_test_players_all (tv_flank_music_end), 1);
	thread(f_mus_m10_e03_finish());
end



//====== CHECKPOINT FUNCTIONS

//====== f_flank_save()
//====== This saves the game when the player is at the beginning 
//====== of the flank room

script dormant f_flank_save()
  sleep_until(volume_test_players(tv_flank_spawn), 1);
  game_save_cancel();
	game_save_no_timeout();
end


//DOORS

//====== f_door_post_elevator()
//====== This opens the first door past the elevator once the player has passed through 
//====== a trigger volume (tv_open_door_post_elevator) 
//====== This also sets a boolean to allow narrative to cue a VO off of the door opening

script dormant f_door_post_elevator()
  sleep_until(volume_test_players(tv_open_door_post_elevator), 1);
  sleep_s(1);
	door_post_elevator->open_default();
	B_flank_doorpastelevator_open = TRUE;
end

//====== f_door_pre_lookout()
//====== 

script dormant f_door_pre_lookout()
	sleep_until ( object_valid (door_pre_lookout), 1);
	sleep_until(volume_test_players(tv_open_pre_lookout_door), 1);
	door_pre_lookout->open_default();
	sleep_s(5);
  S_elite_retreat = 1;
end

script dormant f_door_ch_door_01()
	dm_ch_door_02->open_default();
end

script dormant f_door_ch_door_02()
	dm_ch_door_01->open_default();
end

script static void f_door_airlock_1_interior_close()
	door_airlock_1_interior->auto_trigger_close( tv_airlock_inside, TRUE, TRUE, TRUE );
end

script static void f_door_airlock_1_interior()
	door_airlock_1_interior->open_default();
		sleep_until(volume_test_players(tv_airlock_start),1);
		door_airlock_1_interior->auto_trigger_open( tv_airlock_start, FALSE, TRUE, TRUE );
		
end

script dormant f_close_airlock_door()
	sleep_until (volume_test_players_all (tv_front), 1);
		f_door_airlock_1_exterior_close();
end


//=======  PHYSICS FUNCTIONS

script dormant f_pre_beac_airlock_physics()
	object_wake_physics(cr_airlock_01);
	object_wake_physics(cr_airlock_02);
	object_wake_physics(cr_airlock_03);
	object_wake_physics(cr_airlock_04);
	object_wake_physics(cr_airlock_05);
	object_wake_physics(cr_airlock_06);
	object_wake_physics(cr_airlock_07);
	object_wake_physics(cr_airlock_08);
	object_wake_physics(cr_airlock_09);
end

script static void f_lookout_dialog_check()
	sleep_until(ai_living_count(sq_lookout_grunts_01) == 0);
	wake(f_dialog_m10_lookout_combat);
end


script static void f_lookout_door_block()
	sleep_until(volume_test_players(tv_hallways_door_chk) == TRUE, 1);
	volume_teleport_players_not_inside(tv_hallways_door_volume, flg_lookout_tp );
	door_post_elevator->close_speed_wait(1.2, false);
end

script static void f_cafe_door_block()
	sleep_until(current_zone_set_fully_active() == S_zoneset_16_lookout_18_elevator_20_cafe,1);
	sleep_until(object_active_for_script(door_cafe_block),1);
	door_cafe_block->open_instant();
	sleep_until(volume_test_players(tv_cafe_door_chk) == TRUE);
	volume_teleport_players_not_inside(tv_cafe_door_block_in, flg_cafe_tp );
	door_cafe_block->close_speed_wait(0.7, false);
end

script static void f_flank_door_block()
	sleep_until(volume_test_players(tv_flank_doors_chk) == TRUE, 1);
	volume_teleport_players_not_inside(tv_flank_whole, flg_flank_tp );
	thread(dm_ch_door_01->close_default());
	thread(dm_ch_door_02->close_default());
	thread(door_flank_back->open_default());
end

script static void f_check_disable_backtrack()
	sleep_until(volume_test_players("zone_set:24_corner_26_box_28_airlock") == true, 1);
	sleep(30); // Wait a sec to ensure that the zone transition happens before we disable the volume.
	zone_set_trigger_volume_enable("zone_set:24_corner_26_box_28_airlock", false);
end

script static void f_flank_preload()
	sleep_until(volume_test_players("begin_zone_set:24_corner_26_box_28_airlock") == true, 1);
	sleep(1);
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	zone_set_trigger_volume_enable("zone_set:24_corner_26_box_28_airlock", TRUE);
	sleep_until(volume_test_players("zone_set:24_corner_26_box_28_airlock") == true, 1);
	wake(f_jackal_reinforce);
	
	end
	

/// DEFAULT ACME DEBUG COPY N' PASTE TXT!
/// dprint( ">>>> OMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMGOMG" );