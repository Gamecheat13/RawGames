//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m20_tower
//	Insertion Points:	start or icr		- Beginning
//										icl							- Clearing
//										igy							- Graveyard
//										ifi							- Field
//										igpe						- Guardpost Exterior
//										igpi						- Guardpost Interior
//										ibr							- Bridge
//										icy							- Courtyard
//										iat							- Atrium
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global boolean b_final_switch_flipped = FALSE;

global boolean b_tv_crater_loc_01 = FALSE;
global boolean b_tv_crater_loc_02 = FALSE;
global boolean b_tv_crater_loc_03 = FALSE;
global boolean b_tv_crater_loc_04 = FALSE;
global boolean b_crater_blip_on = FALSE;
global boolean b_field_blip_on = FALSE;
global boolean b_field_weapon_check = FALSE;
global boolean b_player_sees_towers = FALSE;
global boolean b_vista_zone_visited = FALSE;
global boolean b_bridge_phantom_01_gone = FALSE;
global boolean b_courtyard_airlock = FALSE;
global boolean b_airlock_banshees_destroyed = FALSE;
global boolean b_br_phantom_safe_to_leave = FALSE;

global boolean b_obj_pause_0_give = FALSE;
global boolean b_obj_pause_0 = FALSE;
global boolean b_obj_pause_1 = FALSE;
global boolean b_obj_pause_2 = FALSE;
global boolean b_obj_pause_3 = FALSE;
global boolean b_obj_pause_4 = FALSE;
global boolean b_obj_pause_5 = FALSE;
global boolean b_obj_pause_6 = FALSE;
global boolean b_obj_pause_7 = FALSE;

global short s_crater_phantom_volumes = 0;

global short s_objcon_bridge = 0;
global short s_objcon_gpe = 0;
global short s_objcon_courtyard_ghosts = 0;
global short s_objcon_bridge_banshee = 0;
global short s_objcon_courtyard = 0;
global short s_tutorial_stop = 0;


// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m020_tower()

	if b_debug then
		print_difficulty();
		print ("::: M20 - TOWER :::");
	end

	f_loadout_set ("exterior");

	if b_encounters then
			wake (f_crater_main);
			wake (f_vista_main);
			wake (f_drive_main);
			wake (f_field_main);
			wake (f_gp_ext_main);

			wake (f_bridge_main);

			wake (f_dm_gun_door);
			wake (f_dm_courty_door);
			wake (f_dm_gpi_door);
			wake (f_dm_gpe_door);

			wake (f_dm_scanner);
			wake (f_dm_scanner_red);
			wake (f_dm_scanner_green);
			wake (f_dm_bridge_elevator);
			wake (f_dm_atrium_elevator);
			wake (f_dm_flush_core);
			wake (f_dm_blue_column_1);
			wake (f_dm_blue_column_2);
			wake (f_dm_blue_column_3);
			wake (f_dm_blue_column_4);
						
			ai_allegiance (player, human);
			ai_allegiance (player, forerunner);
			
			thread (f_achievements (player0));
			thread (f_achievements (player1));
			thread (f_achievements (player2));
			thread (f_achievements (player3));
			
			wake (f_objectives_controller);
						
	end

	
// ============================================================================================
// STARTING THE GAME
// ============================================================================================
	if (b_game_emulate or ((b_editor != 1) and (player_count() > 0))) then
		// if true, start the game
		start();
		// else just fade in, we're in edit mode
	elseif b_debug then
		print (":::  editor mode  :::");
		fade_in (0, 0, 0, 0); 
		//start();

	end

end

// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

script static void start()

	// Figure out what insertion point to use
	// Set these in init.txt or editor_init.txt to work on various areas quickly
	if game_insertion_point_get() == 0 then
		ins_crater();
	end
	
	if game_insertion_point_get() == 1 then
		ins_clearing();
	end
	
	if game_insertion_point_get() == 2 then
		ins_graveyard();
	end
	
	if game_insertion_point_get() == 3 then
		ins_field();
	end
	
	if game_insertion_point_get() == 4 then
		ins_gp_ext();
	end
	
	if game_insertion_point_get() == 5 then
		ins_gp_int();
	end

	if game_insertion_point_get() == 6 then
		ins_bridge();
	end

	if game_insertion_point_get() == 7 then
		ins_courtyard();
	end

	if game_insertion_point_get() == 8 then
		ins_atrium();
	end

end



// ========================================
// ACHIEVEMENTS
// ========================================
script static void f_achievements(player p_player)
	
	dprint ("waiting for the midnight launch");
	
	sleep_until(
	
	object_valid (veh_vista_warthog_01) and
	unit_get_vehicle (p_player) == veh_vista_warthog_01 and
	get_time_is_time(-1, -1, -1, 0, 0, -1) == TRUE and
	vehicle_in_air_ticks(veh_vista_warthog_01) > 30
	
	or
	
	object_valid (veh_vista_warthog_02) and
	unit_get_vehicle (p_player) == veh_vista_warthog_02 and
	get_time_is_time(-1, -1, -1, 0, 0, -1) == TRUE and
	vehicle_in_air_ticks(veh_vista_warthog_02) > 30
	
	or
	
	object_valid (wreckage_hog_01) and
	unit_get_vehicle (p_player) == wreckage_hog_01 and
	get_time_is_time(-1, -1, -1, 0, 0, -1) == TRUE and
	vehicle_in_air_ticks(wreckage_hog_01) > 30	
	
	or
	
	object_valid (wreckage_hog_02) and
	unit_get_vehicle (p_player) == wreckage_hog_02 and
	get_time_is_time(-1, -1, -1, 0, 0, -1) == TRUE and
	vehicle_in_air_ticks(wreckage_hog_02) > 30
		
	or
	
	object_valid (field_ghost_01) and
	unit_get_vehicle (p_player) == field_ghost_01 and
	get_time_is_time(-1, -1, -1, 0, 0, -1) == TRUE and
	vehicle_in_air_ticks(field_ghost_01) > 30	
		
	or
	
	object_valid (field_ghost_02) and
	unit_get_vehicle (p_player) == field_ghost_02 and
	get_time_is_time(-1, -1, -1, 0, 0, -1) == TRUE and
	vehicle_in_air_ticks(field_ghost_02) > 30
		
	, 1);	
		
	//achievement_grant_to_player (p_player, "m20_special");
	submit_incident_with_cause_player ("achieve_m20_special", p_player);
	dprint ("Midnight Launch Achievement Unlocked!");

end



// =================================================================================================
// =================================================================================================
// CRATER 
// =================================================================================================
// =================================================================================================

script dormant f_crater_main()
	sleep_until (b_mission_started == TRUE, 1);

	dprint ("::: crater start :::");
	
	data_mine_set_mission_segment (m20_crater_start);
	
	wake (f_kill_crater_enemies);
	wake (f_weapon_check);
	wake (f_player_weapon_exit);
	wake (f_crater_unblip_01);
	wake (f_crater_unblip_02);
	wake (f_crater_fire);
	wake (crater_loc_check_01);
	wake (crater_loc_check_02);
	wake (crater_loc_check_03);
	wake (crater_loc_check_04);
	wake (f_crater_volume_blip);
	
	thread (f_cv_skybox_switcher());

	pup_play_show ("pup_dying_elite");
	pup_play_show ("pup_dying_grunt");
	
	sleep (30*9);
	cui_hud_set_new_objective (objective_1);
	objectives_show_up_to (0);
	
	//start lost blip timer
	wake (f_crater_blip_time);
	
end


//CRATER TO VISTA SKYBOX SWITCHER
script static void f_cv_skybox_switcher()
	SetSkyObjectOverride("craterskybox");
	
	repeat
	sleep_until (volume_test_players (tv_skybox_change_vista), 1);
		dprint ("switching to vista skybox");
		SetSkyObjectOverride("");
		
	sleep_until (volume_test_players (tv_skybox_change_crater), 1);
		dprint ("switching to crater skybox");
		SetSkyObjectOverride("craterskybox");
		
	until (1 == 0);

end


//spawn and kill the enemies strewn about the crater wreckage
script dormant f_kill_crater_enemies()
	ai_place (sq_crater_dead);
	ai_kill_silent (sq_crater_dead);

end


//change dying elite and grunt to not say active dialog
script command_script f_elite_dying()
	cs_enable_dialogue (FALSE);

end

script command_script f_grunt_dying()
	cs_enable_dialogue (FALSE);

end


//FIRE DAMAGE VOLUMES
script dormant f_crater_fire()
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_01 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_02 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_03 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_04 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_05 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_06 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_07 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_08 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_09 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_10 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_11 ));
	thread (f_do_fire_damage_on_trigger( tv_crater_fire_12 ));

end


//CHECK FOR IF PLAYER HAS PICKED UP A WEAPON
script dormant f_weapon_check()
	dprint ("waiting for player to pick up a weapon");
	sleep_until (
	volume_test_players (tv_wep_01) or
	volume_test_players (tv_wep_02) or
	volume_test_players (tv_wep_03) or
	volume_test_players (tv_wep_04) or
	volume_test_players (tv_wep_05) or
	volume_test_players (tv_wep_06) or
	volume_test_players (tv_wep_07) or
	volume_test_players (tv_wep_08) or
	volume_test_players (tv_wep_09) or
	volume_test_players (tv_wep_10) or
	volume_test_players (tv_wep_11) or
	volume_test_players (tv_wep_12) or
	volume_test_players (tv_wep_13) or
	volume_test_players (tv_wep_14) or
	volume_test_players (tv_wep_15) or
	volume_test_players (tv_wep_16) or
	volume_test_players (tv_wep_17) or
	volume_test_players (tv_wep_18)
	,1);
	dprint ("player has picked up a weapon");
	b_field_weapon_check = TRUE;

end

//CHECK IF PLAYER HAS PICKED UP A WEAPON WHEN THEY EXIT CRATER
script dormant f_player_weapon_exit()
	sleep_until (volume_test_players (tv_wep_check), 1);
	if b_field_weapon_check == FALSE then
	dprint ("player is leaving without a weapon!");
	wake (f_dialog_m20_ammo_check);
	else dprint ("player has a weapon");
	end

end


// =================================================================================================
// AFTER PLAYER ENTERS 3 OF THE 4 AREAS OF INTEREST, BLIP EXIT
// =================================================================================================

//CHECK TO SEE WHERE PLAYER IS IN CRATER
script dormant crater_loc_check_01()
	sleep_until (volume_test_players (tv_crater_loc_01));
	dprint ("reached location 1");
	b_tv_crater_loc_01 = true;
	s_crater_phantom_volumes = s_crater_phantom_volumes + 1;

end

script dormant crater_loc_check_02()
	sleep_until (volume_test_players (tv_crater_loc_02));
	dprint ("reached location 2");
	b_tv_crater_loc_02 = true;
	s_crater_phantom_volumes = s_crater_phantom_volumes + 1;

end

script dormant crater_loc_check_03()
	sleep_until (volume_test_players (tv_crater_loc_03));
	dprint ("reached location 3");
	b_tv_crater_loc_03 = true;
	s_crater_phantom_volumes = s_crater_phantom_volumes + 1;

end

script dormant crater_loc_check_04()
	sleep_until (volume_test_players (tv_crater_loc_04));
	dprint ("reached location 4");
	b_tv_crater_loc_04 = true;
	s_crater_phantom_volumes = s_crater_phantom_volumes + 1;

end


//=====================================================
// BLIP/UNBLIP EXIT
//=====================================================

//BLIP EXIT AFTER TIME
script dormant f_crater_blip_time()
	dprint ("exit blip timer: starting...");
	sleep_s (220);
	
	if not volume_test_players (tv_cliff_blip_off) then
		sleep_forever (f_crater_volume_blip);
		game_save_no_timeout();
		dprint ("starting exit blip dialog...");
		
		//NARRATIVE DIALOG: (CORTANA CALLS OUT THE BLIP)
		wake (f_dialog_m20_crevice);
	
	else
		dprint ("player is no longer in crater, skipping dialog...");

	end

end


//BLIP EXIT WHEN 3 OF 4 VOLUMES HAVE BEEN VISITED
script dormant f_crater_volume_blip()
	dprint ("waiting for player to explore before blipping exit...");
	sleep_until (s_crater_phantom_volumes == 3, 1);

	if not volume_test_players (tv_cliff_blip_off) then
		sleep_forever (f_crater_blip_time);
		game_save_no_timeout();
		dprint ("starting exit blip dialog...");
		
		//NARRATIVE DIALOG: (CORTANA CALLS OUT THE BLIP)
		wake (f_dialog_m20_crevice);
	
	else
		dprint ("player is no longer in crater, skipping dialog...");

	end
	
end

//GLOBAL BLIP EXIT (triggered from dialog script)
script dormant f_crater_blip_exit()
	b_crater_blip_on = TRUE;	
	dprint ("blipping exit...");
	f_blip_flag (flag_crater_blip, "default");
	
	sleep_until (volume_test_players (tv_cliff_blip_off), 1);
	if (b_crater_blip_on == TRUE) then 
		f_unblip_flag (flag_crater_blip);
		b_crater_blip_on = FALSE;
	end
	
end

//UNBLIP EXIT
script dormant f_crater_unblip_01()
	sleep_until (volume_test_players (tv_cliff_blip_off), 1);
	dprint ("TERMINATING BLIP SYSTEM 01");
	sleep_forever (f_crater_blip_exit);
	sleep_forever (f_crater_volume_blip);
	sleep_forever (f_crater_blip_time);
		
	if (b_crater_blip_on == TRUE) then 
		f_unblip_flag (flag_crater_blip);
		b_crater_blip_on = FALSE;
	end
	
	player_set_profile (default_coop_respawn);
	dprint ("players now respawn with weapons");

end

script dormant f_crater_unblip_02()
	sleep_until (volume_test_players (tv_exit_crater), 1);
	dprint ("TERMINATING BLIP SYSTEM 02");
	sleep_forever (f_crater_blip_exit);
	sleep_forever (f_crater_volume_blip);
	sleep_forever (f_crater_blip_time);
	
	if (b_crater_blip_on == TRUE) then 
		f_unblip_flag (flag_crater_blip);
		b_crater_blip_on = FALSE;
	end
	
end


// =================================================================================================
// =================================================================================================
// VISTA
// =================================================================================================
// =================================================================================================

script dormant f_vista_main()
	sleep_until (volume_test_players (tv_begin_vista), 1);
	dprint ("::: vista start :::");
					
	thread (f_tower_anim());
	wake (f_vista_save);
	wake (destroy_vista_warthogs);
	
end

//PLAY TOWER ANIMATION
script static void f_tower_anim()
	dprint ("TOWERS READY TO TRIGGER");
	
	repeat
	dprint ("waiting on player to enter vista");
	sleep_until (
	(current_zone_set() == s_zoneset_vista or
	current_zone_set() == s_zoneset_to_wreckage or
	current_zone_set() == s_zoneset_wreckage_a) and
	object_valid (tower1) == TRUE and
	object_valid (tower2) == TRUE and
	object_valid (tower3)	== TRUE
	,1);

	if b_vista_zone_visited == FALSE then
		pup_play_show ("pup_towers");
		b_vista_zone_visited = TRUE;
		wake (f_player_sees_towers);
		dprint ("player's first time: playing start anim");
	else 
		pup_play_show ("pup_towers_idle");
		dprint ("player is returning: playing idle anim");
	end

	dprint ("waiting for player to leave vista");

	sleep_until (
	current_zone_set() != s_zoneset_vista and
	current_zone_set() != s_zoneset_to_wreckage and
	current_zone_set() != s_zoneset_wreckage_a
	, 1);
	dprint ("player has left vista, resetting tower anim");
	until (1 == 0);
	
end

//PLAYER SEES TOWERS
script dormant f_player_sees_towers()
	sleep_until (
	volume_test_players (tv_towers_animate_01) or
	volume_test_players (tv_towers_animate_02)
	, 1);
	b_player_sees_towers  = TRUE;

end


//VISTA SAVE
script dormant f_vista_save()
	sleep_until (volume_test_players (tv_vista_force_save), 1);
	game_save_no_timeout();

end


//BLOW UP WARTHOGS
script dormant destroy_vista_warthogs()
	sleep_until (volume_test_players (tv_vista_force_save), 1);
	
	sleep_until (
	object_valid (vista_warthog_explode_01) == TRUE and
	object_valid (vista_warthog_explode_02) == TRUE and
	object_valid (vista_warthog_explode_03)	== TRUE
	,1);
		
	dprint ("BLOWING UP WARDOGS");
	object_damage_damage_section (vista_warthog_explode_01, mainhull, 50000);
	object_damage_damage_section (vista_warthog_explode_02, mainhull, 50000);
	object_damage_damage_section (vista_warthog_explode_03, mainhull, 50000);
	
	//blow up crates inside ship wreckage
	sleep_until (object_valid (vista_crate_01) == TRUE, 1);
	damage_object (vista_crate_01, default, 1000);
	
end


// =================================================================================================
// =================================================================================================
// DRIVE
// =================================================================================================
// =================================================================================================

script dormant f_drive_main()
	sleep_until (volume_test_players (tv_begin_wreckage), 1);
	dprint ("this is the driving section");
	wake (f_amb_crates_01);
	wake (f_drive_fire_damage);
	thread (f_drive_ember_fx_on());

//WRECKAGE DRIVE SAVES
	sleep_until(volume_test_players (tv_wreckage_save_01), 1);
	game_save_no_timeout();	

end

//EMBER EFFECTS
script static void f_drive_ember_fx_on()
	repeat
		if
			volume_test_players (tv_drive_ember_fx_01) or
			volume_test_players (tv_drive_ember_fx_02) or
			volume_test_players (tv_drive_ember_fx_03)
		then
			dprint ("playing ember fx");
			effect_attached_to_camera_new (environments\solo\m020\fx\embers\embers_ambient_floating.effect);
			sleep (30);
		else
			dprint ("stopping ember fx");
			effect_attached_to_camera_stop (environments\solo\m020\fx\embers\embers_ambient_floating.effect);
			sleep (30);
		end
	until (volume_test_players (tv_gp_int_encounter_01), 1);
	
end


//scripted fire damage volumes
script dormant f_drive_fire_damage()
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_01 ));
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_02 ));
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_03 ));
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_04 ));
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_05 ));
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_06 ));
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_07 ));
	thread (f_do_fire_damage_on_trigger( tv_drive_fire_08 ));	

end


script dormant f_amb_crates_01()
	sleep_until (volume_test_players (tv_amb_crates_01), 1);
		object_create (amb_crate_01);
		sleep (10);
		object_wake_physics (amb_crate_01);
	
		object_create (amb_crate_02);
		sleep (10);
		object_wake_physics (amb_crate_02);
	
		object_create (amb_crate_03);
		sleep (10);
		object_wake_physics (amb_crate_03);
	
	sleep_until (volume_test_players (tv_amb_crates_02), 1);
		object_create (amb_crate_04);
		sleep (10);
		object_wake_physics (amb_crate_04);

	sleep_until (volume_test_players (tv_amb_crates_03), 1);
		object_create (amb_crate_08);
		sleep (10);
		object_wake_physics (amb_crate_08);
			
	sleep_until (volume_test_players (tv_amb_crates_04), 1);
		object_create (amb_crate_06);
		sleep (10);
		object_wake_physics (amb_crate_06);
		
end


// =================================================================================================
// =================================================================================================
// FIELD
// =================================================================================================
// =================================================================================================

//Spawn entire field
script dormant f_field_main()

	dprint (":: ENABLING BEGIN FIELD ZONE TRIGGER ::");

	
//enable zone set trigger that lets you go backwards from field now that you're there
	sleep_until (volume_test_players ("zone_set:09_field:*"), 1);
	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);

//BEGIN ALL FIELD EVENTS
	sleep_until(volume_test_players (tv_field_encounter), 1);
	data_mine_set_mission_segment (m20_field);
	effect_attached_to_camera_stop (environments\solo\m020\fx\embers\embers_ambient_floating.effect);
	
	wake (f_field_saves);
	wake (field_end_transition);
	wake (f_field_trans_elite);
	wake (f_field_grunts);
	
	dprint ("SPAWNING FIELD ENCOUNTERS");
	ai_place (sg_field_master);
	ai_place (sq_field_04_sniper);
	
	sleep_until(volume_test_players (tv_field_save_01), 1);
	wake (field_enemies_dead);
	wake (field_players_lost);
	wake (f_unblip_field);
	
	dprint ("PLAY MUSIC!");
	thread (f_mus_m20_e01_begin());

end


//FIELD SAVES
script dormant f_field_saves()
	sleep_until(volume_test_players (tv_field_save_01), 1);
	game_save_no_timeout();

	sleep_until(volume_test_players (tv_field_mid), 1);
	game_save_no_timeout();
	
	sleep_until(volume_test_players
 (tv_field_blip_off), 1);
	game_save_no_timeout();
	
end


//field grunts
script dormant f_field_grunts()
	sleep_until (ai_living_count (sq_field_front_grunts) <= 1);
	dprint ("GRUNT GET IN GHOST");
	ai_vehicle_enter (sq_field_front_grunts, field_ghost_01);

end



//FIELD PHANTOM 01
script command_script cs_field_phantom_01()
	cs_ignore_obstacles ( ai_current_actor, 1);
	
//Phantom Loading/Unloading
	f_load_phantom( field_phantom_01, left, sg_phantom_left_master, none, none, none);
	
	wake (phantom_01_ignore_player);
	wake (field_enemies_see_you);
	
	sleep (30*1);
	
	f_unload_phantom( field_phantom_01, left );

	pup_play_show ("pup_elite_orders_2");
	
//Phantom Flies Away
		cs_vehicle_speed (0.8);
		print ("speed changed");
  	sleep (30*9);
 
    cs_fly_by (ps_phantom_01.p1);
    cs_fly_by (ps_phantom_01.p2);
    cs_fly_by (ps_phantom_01.p3);
        
    cs_vehicle_speed (1);
    
    cs_fly_by (ps_phantom_01.p4);
    cs_fly_by (ps_phantom_01.p5);
        
    object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 270 );
    
    dprint ("flying to last point");
    cs_fly_by (ps_phantom_01.p6);
    
    dprint ("destroying...");
    object_destroy( ai_vehicle_get( ai_current_actor ) );

end

script dormant phantom_01_ignore_player()
//FIRST PHANTOM DOESN'T IMMEDIATELY START SHOOTING AT PLAYER
	print ("sleepy-time enemies");
	
	//wait until squad is spawned
	sleep_until( 
		ai_living_count(sq_phantom_elite_left) > 0 and
		ai_living_count(sq_field_front_grunts) > 0 and
		ai_living_count(sq_phantom_jackals_left) > 0
	, 1);
	
	print ("waiting for player action");
	
	//wait until squad takes damage or player moves forward
	sleep_until(
		volume_test_players (tv_field_see_player) or
		ai_strength (sq_phantom_elite_left) < 1	or
		ai_strength (sq_field_front_grunts) < 1	or
		ai_strength (sq_phantom_jackals_left) < 1
	, 1);
	
	print ("enemies awake!");
	ai_set_deaf (field_phantom_01, 0);
	ai_set_blind (field_phantom_01, 0);
	
	sleep_until(volume_test_players (tv_field_mid), 1);
	print ("phantom 1 sleeps again");
	ai_set_deaf (field_phantom_01, 1);
	ai_set_blind (field_phantom_01, 1);
	
end

script dormant field_enemies_see_you()
//if player waits for 5 seconds, phantom starts shooting at you
	sleep_until(volume_test_players (tv_field_wrongway), 1);
	print ("countdown...");
	sleep (30*6);
	print ("enemies see you!");
	ai_set_deaf (field_phantom_01, 0);
	ai_set_blind (field_phantom_01, 0);

end


//FIELD PHANTOM 02
script command_script cs_field_phantom_02()
	cs_ignore_obstacles ( ai_current_actor, 1);
	
//Phantom Loading/Unloading
	f_load_phantom( field_phantom_02, right, sq_field_04, none, none, none);
	sleep (30*3);
	f_unload_phantom( field_phantom_02, right );

//Phantom Flies Away
		cs_vehicle_speed (0.6);
  	sleep (30*4);
  	  	
  	ai_set_deaf (field_phantom_02, 0);
		ai_set_blind (field_phantom_02, 0);
  	
    cs_fly_by (ps_phantom_02.p0);
    cs_vehicle_speed (1);
    cs_fly_by (ps_phantom_02.p1);
    cs_fly_by (ps_phantom_02.p2);
    
    cs_vehicle_speed (1);
    
    cs_fly_by (ps_phantom_01.p4);
    cs_fly_by (ps_phantom_01.p5);
        
    object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 300 );
    
    cs_fly_by (ps_phantom_01.p6);
    
   	object_destroy( ai_vehicle_get( ai_current_actor ) );

end


//FIELD PHANTOM 03
script command_script cs_field_phantom_03()
//Phantom Loading/Unloading
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed (0.5);
	
	f_load_phantom( field_phantom_03, left, sg_field_end_master, none, none, none);
	
	cs_fly_by (ps_phantom_03.p0);
	
	sleep (30*3);
	f_unload_phantom( field_phantom_03, left );
	
//Phantom Flies Away
		cs_vehicle_speed (0.5);
  	sleep (30*18);
    cs_fly_by (ps_phantom_03.p0);
    cs_vehicle_speed (1);
    cs_fly_by (ps_phantom_03.p1);
    cs_fly_by (ps_phantom_03.p2);
    cs_fly_by (ps_phantom_03.p3);
    cs_fly_by (ps_phantom_03.p4);
    cs_fly_by (ps_phantom_03.p5);
		
    cs_vehicle_speed (0.6);

    object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 300 );
		
    cs_fly_by (ps_phantom_03.p6);
		
   	object_destroy( ai_vehicle_get( ai_current_actor ) );

end


//REAR FIELD ELITE REACTS WHEN YOU GET NEAR
script dormant rear_elite_react
	sleep_until (volume_test_players (tv_end_elite), 1);
	
	pup_play_show ("pup_elite_orders_1");
	
end


//==================================
// BLIP FIELD EXIT
//==================================

//ALL FIELD ENEMIES DEAD
script dormant field_enemies_dead()
	sleep_until ((ai_living_count (sg_field_master) == 0), 1);
	dprint ("ALL FIELD ENEMIES DEAD");
	
	wake (f_dialog_m20_cathedral_reveal);
	
	sleep (30*2);
	
	game_save_no_timeout();
	
 sleep (30*3);
	
	wake (blip_field_exit);
	sleep_forever (field_players_lost);
	
end

//PLAYER TRIED TO GO BACKWARD
script dormant field_players_lost()
	dprint ("WAITING FOR PLAYER TO BECOME LOST");
	sleep_until(volume_test_players (tv_field_wrongway), 1);
	sleep_until(volume_test_players (tv_field_wrongway_02), 1);
	dprint ("PLAYER IS LOST IN FIELD");
	
	wake (blip_field_exit);
	sleep_forever (field_enemies_dead);

end

//BLIP THE FIELD EXIT
script dormant blip_field_exit()
	f_blip_flag (flag_field_exit, "default");
	b_field_blip_on = TRUE;
		
end

//UNBLIP THE FIELD EXIT
script dormant f_unblip_field()
	sleep_until(volume_test_players (tv_field_blip_off), 1);
	dprint ("FIELD BLIPS DISABLED");
	
	sleep_forever (field_enemies_dead);
	sleep_forever (field_players_lost);
	
	if (b_field_blip_on == TRUE) then 
	f_unblip_flag (flag_field_exit);
	b_field_blip_on = FALSE;
	end

end


//SPAWN ENDING ELITE ZEALOT
script dormant f_field_trans_elite()
	sleep_until (volume_test_players (tv_end_elite), 1);
	ai_place (sq_field_end_zealot);

end

script command_script field_trans_elite()
	cs_go_to (ps_field_trans_elite.p3);

end


//SPAWN ENDING TRANSITION GRUNTS
script dormant field_end_transition()
	sleep_until(volume_test_players (tv_to_gpe_spawn), 1);
		dprint ("spawning transition grunts");
		ai_place (sq_to_gpe_grunts);

	sleep_until(
		volume_test_players (tv_field_trans_dialog) or
		ai_living_count (sq_to_gpe_grunts) <= 0
	, 1);
		sleep (30);
		wake (m20_guardpostex_covenant_c);
	
end


//SPAWN THE EVENT
script dormant field_the_event()
	sleep_until(volume_test_players (tv_field_the_event), 1);
	
	if game_difficulty_get_real() == "legendary" then
		ai_place (field_event_phantom);
		dprint ("an advanced sniper party is lost, finding a safe place to land...");
	else
		dprint ("an advanced sniper party found their target");
	end

end

script command_script field_the_event_squad()
	object_set_variant (ai_vehicle_get( ai_current_actor ), ("no_turrets") );
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed (0.4);
	
	cs_fly_by (ps_field_event.p0);
	
	sleep (30*3);
	
	cs_fly_by (ps_field_event.p1);
	cs_fly_by (ps_field_event.p2);
	cs_fly_to_and_face (ps_field_event.p3, ps_field_event.p5);
	
	f_load_phantom (field_event_phantom, right, sq_field_the_event_01, sq_field_the_event_02, none, none);
	f_load_phantom (field_event_phantom, left, sq_field_the_event_03, sq_field_the_event_04, none, none);
	
	sleep (30*2);
	
	f_unload_phantom (field_event_phantom, right);
	f_unload_phantom (field_event_phantom, left);
	
	sleep (30*2);
	
	wake (f_test_field_event_dead);
	
	cs_fly_to_and_face (ps_field_event.p3, ps_field_event.p2);
	
	cs_vehicle_speed (0.6);
	
	cs_fly_to (ps_phantom_01.p2);
	cs_fly_by (ps_phantom_01.p3);
  
  cs_vehicle_speed (1);
    
  cs_fly_by (ps_phantom_01.p4);
  cs_fly_by (ps_phantom_01.p5);
  dprint ("SCALING");
  object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 300 );
  
  cs_fly_by (ps_phantom_01.p6);

	object_destroy( ai_vehicle_get( ai_current_actor ) );

end

script dormant f_test_field_event_dead()
	dprint ("waiting for event death");
	sleep_until (
		ai_living_count (sq_field_the_event_01) <= 0 and
		ai_living_count (sq_field_the_event_02) <= 0 and
		ai_living_count (sq_field_the_event_03) <= 0 and
		ai_living_count (sq_field_the_event_04) <= 0 and
		volume_test_players_all (tv_event_test)
		, 1);	
		dprint ("an elite team of snipers has met their end");
	
	if
		ai_living_count (sq_field_the_event_01) <= 0 and
		ai_living_count (sq_field_the_event_02) <= 0 and
		ai_living_count (sq_field_the_event_03) <= 0 and
		ai_living_count (sq_field_the_event_04) <= 0 and
		volume_test_players_all (tv_event_test)
	then
		dprint ("rejoice and be glad, for your reward is great...");
		object_create (gpe_event_crate_01);
		object_create (gpe_event_crate_02);
		object_create (gpe_event_crate_03);
		object_create (gpe_event_crate_04);
	else
		dprint ("for cowardice, your only reward will be death...");
	end
		
end


// =================================================================================================
// =================================================================================================
// CATHEDRAL EXTERIOR
// =================================================================================================
// =================================================================================================

script dormant f_gp_ext_main()
	sleep_until (b_mission_started == TRUE, 1);
	dprint ("::: guardpost exterior start :::");
	
	zone_set_trigger_volume_enable ("begin_zone_set:13_cathedral_int:*", FALSE);
	zone_set_trigger_volume_enable ("zone_set:13_cathedral_int:*", FALSE);

	wake (f_spawn_guardpost_ext);
	wake (f_jackal_alert);

	b_insertion_fade_in = TRUE;

end


script dormant f_spawn_guardpost_ext()
	sleep_until (volume_test_players (tv_guardpost_ext), 1);
	data_mine_set_mission_segment (m20_guardpost_ext);
	
	wake (f_gpe_objcon);
	wake (f_kill_all_field_encounters);
	thread (cathedral_ext_enemy_cleanup());

	dprint ("::: SPAWN FIRST ENEMIES :::");	

	ai_place (sg_gpe_start);
	ai_place (sg_gpe_center);
	
	game_save_no_timeout();
	
	//SPAWN SIDE ENEMIES
	sleep_until (volume_test_players (tv_gp_center), 1);
	ai_place (sg_gpe_structure);
	ai_place (sg_gpe_sides);
	
	//SPAWN UPPER ENEMIES
	sleep_until (volume_test_players (tv_gp_struct), 1);
	game_save_no_timeout();
	ai_place (sg_gpe_top);
	
	wake (f_aa_vignette);

end


//delete all field enemies once players reach cathedral ext
script dormant f_kill_all_field_encounters()
	local real r_distance = 8.0;
	f_ai_garbage_erase( sq_field_front_grunts, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_field_01, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_field_04, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_field_04_sniper, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_field_end_turret, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_field_06, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_phantom_elite_left, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_phantom_jackals_left, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	f_ai_garbage_erase( sq_field_08, r_distance, -1, -1, -1, TRUE, TRUE, FALSE );
	
end


script static void cathedral_ext_enemy_cleanup()
	sleep_until (volume_test_players (tv_gp_center), 1);
	dprint ("attempting to clean up exterior front");
	f_ai_garbage_erase (sq_gpe_start, 10, -1, -1, -1, FALSE);
	f_ai_garbage_erase (sq_gpe_start_elite, 10, -1, -1, -1, FALSE);
	
	sleep_until (volume_test_players (tv_gs_gpe_structure), 1);
	dprint ("attempting to clean up exterior center");
	f_ai_garbage_erase (sq_gpe_center, 10, -1, -1, -1, FALSE);
	f_ai_garbage_erase (sq_elite_mid, 10, -1, -1, -1, FALSE);
	
	sleep_until (volume_test_players (tv_gp_struct), 1);
	dprint ("attempting to clean up exterior sides");
	f_ai_garbage_erase (sq_sides_left_front, 10, -1, -1, -1, FALSE);
	f_ai_garbage_erase (sq_sides_right_front, 10, -1, -1, -1, FALSE);

end



//JACKAL ALERTS OTHERS TO YOUR PRESENCE
script dormant f_jackal_alert()
	sleep_until (volume_test_players (tv_jackal_alert_spawn), 1);
	ai_place (sq_jackal_alert);
	
	sleep (30*2);
	cui_hud_set_new_objective (objective_2);
	objectives_show_up_to (1);
	
end

script command_script cs_jackal_alert()
	dprint ("jackal spawned");
	ai_magically_see_object (sq_jackal_alert, player0);
	ai_magically_see_object (sq_jackal_alert, player1);
	ai_magically_see_object (sq_jackal_alert, player2);
	ai_magically_see_object (sq_jackal_alert, player3);
	
	cs_look_player (TRUE);
	sleep (30*3);
	cs_go_to (ps_jackal_alert.p1);
	dprint ("jackal moved to point");
	sleep (30*1);
	dprint ("jackal erased");
	ai_erase (sq_jackal_alert);
		
end


//OBJCON
script dormant f_gpe_objcon()
 	sleep_until (volume_test_players (tv_obj_sniper_move), 1);
  dprint  ("::: Objcon Cathedral 50 :::");
	s_objcon_gpe = 50;

end


//ELITE MOVE FORWARD
script command_script elite_advance_and_tease()
	sleep_until (volume_test_players (tv_gp_struct), 1);
	
	cs_move_towards_point (ps_stealth_elite.p0, 0.1);
	
	sleep_until (volume_test_players (tv_elite_pup_play), 1);

	local long show = pup_play_show ("pup_elite_taunt");
	sleep_until(not pup_is_playing(show),1);
	
	cs_run_command_script (sq_guardpost_ext_elite, elite_cloaks);
	
end

//ELITE CLOAKS
script command_script elite_cloaks()
	sleep (30*1);
	ai_set_active_camo (sq_guardpost_ext_elite, TRUE);
	dprint ("elite SHOULD BE invisible!");
	
	cs_move_towards_point (ps_stealth_elite.p1, 0.1);
	cs_face_player (TRUE);
	
//ELITE DE-CLOAKS
	sleep_until (volume_test_players (tv_elite_invisible) or ai_living_count (sg_gpe_top) == 1 or unit_get_shield (sq_guardpost_ext_elite) < 0.75, 1);

	ai_set_active_camo (sq_guardpost_ext_elite, FALSE);
	dprint ("elite is visible!");
	
	pup_play_show ("pup_elite_taunt");

end


//TEST ELITE POSITION FOR AA DROP
global real my_x = 0;
global real my_y = 0;
global real my_z = 0;

script static void get_pos(object guy)
	repeat
		my_x = object_get_x (guy);
		my_y = object_get_y (guy);
		my_z = object_get_z (guy);
	until (object_get_health(guy) <= 0, 1);
	
end

//PLAYER PICKS UP ACTIVE CAMO AA
script dormant f_aa_vignette()
	print ("::: BEGIN AA VIGNETTE :::");
	
	thread (get_pos(sq_guardpost_ext_elite.spawn_points_0));

	sleep_until (object_get_health(sq_guardpost_ext_elite.spawn_points_0) <= 0, 1);

	object_move_by_offset (crate_fake_aa,0, my_x - object_get_x (crate_fake_aa), my_y - object_get_y (crate_fake_aa), (my_z - object_get_z (crate_fake_aa)) + 0.5);

	sleep (1);
	
	if (not volume_test_object (tv_elite_aa_drop, crate_fake_aa)) then
		object_move_to_flag (crate_fake_aa, 0, flag_aa_drop);

	end
	
	object_wake_physics (crate_fake_aa);
		
	//WAIT UNTIL ALL UPPER ENEMIES ARE DEAD
	sleep_until (
		ai_living_count (sq_guardpost_ext_door) <= 0 and
		ai_living_count (sq_guardpost_ext_elite) <= 0 and
		ai_living_count (sq_guardpost_ext_door_jackals) <= 0	
	, 1);

	if 
		(object_valid(crate_fake_aa)) 
	then
		thread (get_pos(crate_fake_aa)); 
	else
		object_create_anew(crate_fake_aa);
		object_move_to_flag (crate_fake_aa, 0, flag_aa_drop);
	end

	sleep (2);
	object_move_by_offset (equip_camo_vignette,0, my_x - object_get_x (equip_camo_vignette), my_y - object_get_y (equip_camo_vignette), (my_z - object_get_z (equip_camo_vignette)) + 0.5);

	f_blip_object (equip_camo_vignette, "default");


	object_wake_physics (equip_camo_vignette);

	thread (camo_drop_fail_safe());

	thread (f_mus_m20_e01_finish());
	wake (f_dialog_m20_camo_drop);

	object_destroy(crate_fake_aa);

	dprint ("ready to open door");

	sleep_until ( 
		unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment") or
		unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment") or
		unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment") or
		unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
	, 1);

	f_unblip_object (equip_camo_vignette);
	
	wake(f_dialog_m20_camo_pickup);
	
	//REPLACE 'FAKE' AA WITH CORRECT ONE THE INSTANT PLAYERS PICK IT UP
	if unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment") then
		unit_set_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo.equipment", FALSE, TRUE, TRUE);
	end
	
	if unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment") then
		unit_set_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo.equipment", FALSE, TRUE, TRUE);
	end
	
	if unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment") then
		unit_set_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo.equipment", FALSE, TRUE, TRUE);
	end
	
	if unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment") then
		unit_set_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo.equipment", FALSE, TRUE, TRUE);
	end
	
	wake (field_the_event);
	
	thread (f_aa_tutorial(player0));
	thread (f_aa_tutorial(player1));
	thread (f_aa_tutorial(player2));
	thread (f_aa_tutorial(player3));
	
	sleep (30*2);
	
	thread (f_cathedral_door_ext());
	
end

//IF ELITE DIES OUTSIDE OF VOLUME, DROP THE AA ON UPPER PLATFORM
script static void camo_drop_fail_safe()
repeat
	if (not volume_test_object (tv_elite_aa_drop, equip_camo_vignette)) then
		object_move_to_flag (equip_camo_vignette, 0, flag_aa_drop);
	end
	until (unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment"), 1);

end

//AA TUTORIAL DISPLAY
script static void f_aa_tutorial(player p_player)
	sleep_until (unit_has_equipment (p_player, "objects\equipment\storm_active_camo\storm_active_camo.equipment"), 1);
	sleep (30*1);
	chud_show_screen_training (p_player, "training_equipment"); 
	sleep (30*6);
	chud_show_screen_training (p_player, "");

end


//TO CATHEDRAL INTERIOR AIRLOCK
script static void f_cathedral_door_ext()
	dprint ("opening cathedral door");
	
	thread (f_cath_door_open_check());
		
	dm_gpi_airlock_door_01->open();
	dm_gpi_airlock_door_01->auto_trigger_close( tv_guardpost_int, FALSE, TRUE, TRUE );
	
	sleep_until( dm_gpi_airlock_door_01->check_close(), 1 );
	dprint ("door has closed");
	
	wake(f_dialog_m20_cathedral_signal);
	
	zone_set_trigger_volume_enable ("begin_zone_set:13_cathedral_int:*", TRUE);
	
	sleep (30*3);
	
	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	
	//SWITCH ZONESET
	zone_set_trigger_volume_enable ("zone_set:13_cathedral_int:*", TRUE); 
	dprint ("ZONESET HAS CHANGED");
	
	//ERASE ALL PREVIOUS SQUADS
	ai_erase (sg_gpe_start);
	ai_erase (sg_gpe_center);
	ai_erase (sg_gpe_sides);
	ai_erase (sg_sides_right_ramp);
	ai_erase (sg_sides_left_ramp);
	ai_erase (sg_sides_left_grass);
	ai_erase (sg_sides_right_grass);
	ai_erase (sg_sides_left_front);
	ai_erase (sg_sides_right_front);
	ai_erase (sg_gpe_structure);
	ai_erase (sg_gpe_top);
	
	//UNLOCKS INSERTION POINT IN MENU ONCE PLAYER HAS REACHED THIS POINT
	game_insertion_point_unlock(5);
	
	game_save_no_timeout();
	sleep (30*2);
	wake (f_gp_int_main);
	
end

//safety loop to make sure first ci airlock door opens if players return to field and come back
script static void f_cath_door_open_check()
	repeat
		dprint ("waiting for door to become invalid...");
		sleep_until (not object_valid (dm_gpi_airlock_door_01) );
		dprint ("door is now invalid");
		kill_script (f_cathedral_door_ext);
		
		sleep (30*3);
		
		dprint ("waiting for door to become valid...");
		sleep_until (object_valid (dm_gpi_airlock_door_01) );
		
		dprint ("door is now valid - opening...");
		thread (f_cathedral_door_ext());
		
		sleep (30*3);
	
	until (volume_test_players (tv_gp_int_encounter_01) );
		dprint ("disabling first airlock door check script");

end


// =================================================================================================
// =================================================================================================
// BRIDGE
// =================================================================================================
// =================================================================================================

script dormant f_bridge_main()
	dprint ("::: bridge start :::");
	b_insertion_fade_in = TRUE;
	
	zone_set_trigger_volume_enable ("begin_zone_set:15_bridge", FALSE);
	zone_set_trigger_volume_enable ("zone_set:15_bridge", FALSE);
		
	zone_set_trigger_volume_enable ("begin_zone_set:17_courtyard", FALSE);
	zone_set_trigger_volume_enable ("zone_set:17_courtyard", FALSE);
	
end


//OPEN DOOR AND BEGIN BRIDGE ENCOUNTER - LOADS FROM GUARDPOST INTERIOR SCRIPT
script static void f_start_bridge_encounter()
	sleep_until (volume_test_players (tv_door_to_bridge_open), 1);
	
	data_mine_set_mission_segment (m20_bridge);
	
	wake (f_bridge_start);
	
	dm_to_bridge_door_new->open();
	dm_to_bridge_door_new->auto_trigger_close( tv_bridge_door_close, TRUE, TRUE, TRUE );
	
	wake (f_kill_squad_vo_line);
	
	sleep_until (volume_test_players (tv_bridge_awake), 1);	
	dprint ("PLAY MUSIC!");
	thread (f_mus_m20_e04_begin());
	
	dprint ("PLAY MUSIC!");
	thread (f_mus_m20_e05_begin());
	
	sleep (30*1);
	cui_hud_set_new_objective (objective_5);
	objectives_show_up_to (2);	
	
end

//DISABLE THE CORTANA LINE ABOUT SQUADS BELOW IF THEY KILL THEM OR DROP DOWN
script dormant f_kill_squad_vo_line()
	sleep_until (
		volume_test_players (tv_bridge_awake) or
		ai_living_count (sq_bridge_start_jackals) < 2 or
		ai_living_count (sq_bridge_start_grunts) < 2 or
		ai_living_count (sq_bridge_start_grunt_patrol) < 1
	, 1);
	
	sleep_forever (f_dialog_m20_bridge_elevator);
	sleep_forever (m20_bridge_elevator);
	
end


//START THE BRIDGE ENCOUNTERS
script dormant f_bridge_start()
	dprint  ("::: bridge SPAWN :::");
	ai_place (sq_br_phantom_1);
	
	ai_place (sg_bridge_firsthalf_front);
	ai_place (sq_bridge_firsthalf_2);
	
	ai_place (sg_bridge_banshee_01);
	ai_place (sg_bridge_banshee_02);
	
	wake (f_bridge_phantoms);
	wake (bridge_switch_watcher);
	wake (f_spawn_bridge_2);
	wake (f_bridge_objcon);
	wake (f_bridge_under);
	wake (bridge_doors_open);
	wake (player_banshee_hijack);
	wake (bridge_blind_deaf);
	wake (f_spawn_middle_elite);
	wake (f_bridge_halfway_checkpoint);
	wake (f_bridge_save_center);
	
	thread (bridge_enemy_cleanup());
	
	game_save_no_timeout();
	
	sleep (30*2);
	
//	wake (f_dialog_m20_phantom_on_approach_02);

end

//bridge garbage cleanup
script static void bridge_enemy_cleanup()
local real r_distance = 8.0;
	sleep_until (volume_test_players (tv_enemy_cleanup_01), 1);
	dprint ("attempting to clean up bridge front");
	f_ai_garbage_erase( sq_bridge_start_jackals, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_start_grunts, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_start_grunt_patrol, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );

	sleep_until (volume_test_players (tv_enemy_cleanup_02), 1);
	dprint ("attempting to clean up bridge first middle");
	f_ai_garbage_erase( sq_bridge_firsthalf_1a, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_firsthalf_1e, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_firsthalf_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_firsthalf_under, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	//f_ai_garbage_erase( sq_br_phantom_1, 15, -1, -1, -1, FALSE, TRUE, FALSE );

	sleep_until (volume_test_players (tv_enemy_cleanup_03), 1);
	dprint ("attempting to clean up bridge second middle");
	f_ai_garbage_erase( sq_bridge_middle_main_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_middle_main_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_middle_main_3, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_middle_top_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_middle_top_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_middle_elite_02, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	//f_ai_garbage_erase( sq_br_phantom_2, 15, -1, -1, -1, FALSE, TRUE, FALSE );

	sleep_until (volume_test_players (tv_enemy_cleanup_04), 1);
	dprint ("attempting to clean up bridge end front");
	f_ai_garbage_erase( sq_bridge_middle_main_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_middle_main_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_middle_main_3, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	
	f_ai_garbage_erase( sq_bridge_end_front, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_end_front_st, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_bridge_end_middle_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	//f_ai_garbage_erase( sq_br_phantom_3, 15, -1, -1, -1, FALSE, TRUE, FALSE );

end


//BRIDGE ELEVATOR
script dormant bridge_switch_watcher()
	sleep_until (volume_test_players (tv_bridge_elevator), 1);
	dprint ("::: Going Down :::");
	dm_bridge_elevator->animate();

end


script dormant f_bridge_objcon()
	wake (f_obj_bridge_banshee);
 	sleep_until (volume_test_players (tv_br_firsthalf_front), 1);
  dprint  ("::: Objcon Bridge 10 :::");
	s_objcon_bridge = 10;
	
	sleep_until (volume_test_players (tv_br_objcon_15), 1);
  dprint  ("::: Objcon Bridge 15 :::");
	s_objcon_bridge = 15;
	
	sleep_until (volume_test_players (tv_br_firsthalf_middle), 1);
  dprint  ("::: Objcon Bridge 20 :::");
	s_objcon_bridge = 20;
	
	sleep_until (volume_test_players (tv_br_firsthalf_rear), 1);
  dprint  ("::: Objcon Bridge 30 :::");
	s_objcon_bridge = 30;
	
	sleep_until (volume_test_players (tv_br_firsthalf_end), 1);
  dprint  ("::: Objcon Bridge 35 :::");
	s_objcon_bridge = 35;
	
	sleep_until (volume_test_players (tv_bridge_middle_end), 1);
  dprint  ("::: Objcon Bridge 40 :::");
	s_objcon_bridge = 40;

end


//FIRST ENEMIES WAIT BEFORE SEEING PLAYER
script dormant bridge_blind_deaf()
	dprint ("ENEMIES CAN'T SEE YOU");
	ai_disregard (player0, TRUE);
	ai_disregard (player1, TRUE);
	ai_disregard (player2, TRUE);
	ai_disregard (player3, TRUE);
	
	sleep_until(
		volume_test_players (tv_bridge_elevator)
		or volume_test_players (tv_bridge_awake)
		or ai_strength (sg_bridge_firsthalf_front) < 1
		or ai_strength (sg_bridge_firsthalf_middle) < 1
	, 1);

	dprint ("ENEMIES SEE YOU!");
	ai_disregard (player0, FALSE);
	ai_disregard (player1, FALSE);
	ai_disregard (player2, FALSE);
	ai_disregard (player3, FALSE);
	
	ai_set_blind (sq_br_phantom_1, FALSE);
	ai_set_deaf (sq_br_phantom_1, FALSE);

end


//CHECKPOINT AT HALFWAY GAP
script dormant f_bridge_halfway_checkpoint()
	sleep_until (volume_test_players (tv_objcon_banshee_1), 1);
	game_save_no_timeout();
	
	//sleep_until (volume_test_players (tv_br_snipers_open), 1);
	sleep_until (volume_test_players (tv_bridge_end_02), 1);
	game_save_no_timeout();
	
end


//GAME SAVE CENTER BRIDGE
script dormant f_bridge_save_center()
	sleep_until (volume_test_players (tv_bridge_end_02), 1);
	dprint ("waiting for center enemies to die before saving...");
	
	sleep_until (
			ai_living_count (sq_bridge_middle_main_1) < 1 and
			ai_living_count (sq_bridge_middle_main_2) < 1 and
			ai_living_count (sq_bridge_middle_main_3) < 1 and
			ai_living_count (sq_bridge_middle_top_1) < 1 and
			ai_living_count (sq_bridge_middle_top_2) < 1
	,1);
	
	dprint ("all center enemies dead");
	dprint ("setting banshees to blind/deaf");
	
	ai_set_blind (sq_bridge_banshee_1, TRUE);
	ai_set_blind (sq_bridge_banshee_2, TRUE);
	ai_set_blind (sq_bridge_banshee_3, TRUE);
	ai_set_blind (sq_bridge_banshee_4, TRUE);
	ai_set_deaf (sq_bridge_banshee_1, TRUE);
	ai_set_deaf (sq_bridge_banshee_2, TRUE);
	ai_set_deaf (sq_bridge_banshee_3, TRUE);
	ai_set_deaf (sq_bridge_banshee_4, TRUE);
	
	game_save_no_timeout();
	dprint ("watch for CHECKPOINT");
	
	sleep (30*10);
	
	ai_set_blind (sq_bridge_banshee_1, FALSE);
	ai_set_blind (sq_bridge_banshee_2, FALSE);
	ai_set_blind (sq_bridge_banshee_3, FALSE);
	ai_set_blind (sq_bridge_banshee_4, FALSE);
	ai_set_deaf (sq_bridge_banshee_1, FALSE);
	ai_set_deaf (sq_bridge_banshee_2, FALSE);
	ai_set_deaf (sq_bridge_banshee_3, FALSE);
	ai_set_deaf (sq_bridge_banshee_4, FALSE);

	dprint ("banshees no longer blind/deaf");
	
end


//SPAWN UNDER BRIDGE
script dormant f_bridge_under()
 	sleep_until (volume_test_players (tv_bridge_under_1), 1);
  dprint  ("::: Spawn Under #1 :::");
	ai_place (sq_bridge_firsthalf_under);

end

//SPAWN MIDDLE ELITE
script dormant f_spawn_middle_elite()
 	sleep_until (volume_test_players (tv_middle_end_elite), 1);
	ai_place (sq_bridge_middle_elite_02);

end


//SPAWN PHANTOMS
script dormant f_bridge_phantoms()
	sleep_until (volume_test_players (tv_phantom_spawn_02), 1);
	ai_place (sq_br_phantom_2);
	
	sleep_until (volume_test_players (tv_bridge_end_02), 1);
	ai_place (sq_br_phantom_3);

end



// =================================================================================================
// BRIDGE PHANTOMS FLY
// =================================================================================================

//DECORATIVE
script command_script phantom_fly_0()
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed (1);
	
	cs_fly_by (ps_br_phantom_0.p0);
	cs_fly_by (ps_br_phantom_0.p1);
	cs_fly_by (ps_br_phantom_0.p2);
	cs_fly_by (ps_br_phantom_0.p3);
	ai_erase (sq_br_phantom_0);

end

//PHANTOM 01 DROPS FRONT SQUAD
script command_script phantom_fly_1()
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed (0.5);

	f_load_phantom (sq_br_phantom_1, left, sq_bridge_firsthalf_1e, sq_bridge_firsthalf_1a, none, none);

	sleep (30 * 2);

	cs_fly_by (ps_br_phantom_1.p0);
	cs_fly_by (ps_br_phantom_1.p1);
	cs_fly_to_and_face (ps_br_phantom_1.p3, ps_br_phantom_1.p4);
	cs_fly_to_and_face (ps_br_phantom_1.p3, ps_br_phantom_1.p4);

	f_unload_phantom( sq_br_phantom_1, left );
	
	sleep (30*5);
	
	if
		ai_spawn_count (sq_br_phantom_2) <= 0
	then
		dprint ("safe to take off");
		cs_fly_to_and_face (ps_br_phantom_1.p2, ps_br_phantom_1.p5);
	else
		dprint ("ship nearby, waiting to take off...");
		sleep_until (b_br_phantom_safe_to_leave == TRUE);
			dprint ("safe to leave.  leaving now...");
			cs_fly_to_and_face (ps_br_phantom_1.p2, ps_br_phantom_1.p5);
	end
	
	cs_vehicle_speed (0.8);
	
	b_bridge_phantom_01_gone = TRUE;
	
	cs_fly_by (ps_br_phantom_1.p5);
	cs_fly_by (ps_br_phantom_1.p6);
	
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.4, 560 );
	
	cs_fly_by (ps_br_phantom_1.p7);
	cs_vehicle_speed (0.5);
	cs_fly_by (ps_br_phantom_1.p8);
	cs_fly_by (ps_br_phantom_1.p9);
	
	ai_erase (sq_br_phantom_1);

end

//PHANTOM 02 DROPS MIDDLE SQUAD
script command_script phantom_fly_2()
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed (0.6);
			
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 60 );
	
	sleep (30 * 1);

	cs_fly_by (ps_br_phantom_2.p7);
	
	if 
		b_bridge_phantom_01_gone == (TRUE)
	then
		dprint ("first phantom has left, take lower point");
		cs_fly_by (ps_br_phantom_2.p8);
	else
		dprint ("first phantom has not left, take higher point");
		cs_fly_by (ps_br_phantom_2.p0);
	end
	
	cs_fly_by (ps_br_phantom_2.p1);
	
	b_br_phantom_safe_to_leave = TRUE;
	
	cs_fly_by (ps_br_phantom_2.p2);
	
	ai_set_blind (sq_br_phantom_2, FALSE);
	ai_set_deaf (sq_br_phantom_2, FALSE);
	
	cs_fly_to_and_face (ps_br_phantom_2.p3, ps_br_phantom_2.p9);
	
	f_load_phantom (sq_br_phantom_2, left, sq_bridge_middle_main_1, sq_bridge_middle_main_3, none, none);
	
	sleep (10);
	
	f_unload_phantom( sq_br_phantom_2, left );
	
	sleep_until (volume_test_players (tv_phantom_02_leaves)
	or ai_strength (sq_br_phantom_2.gunner01) < 1
	or ai_strength (sq_br_phantom_2.gunner02) < 1, 1);
	
	sleep (30 * 1);
	
	cs_fly_by (ps_br_phantom_2.p4);
	cs_fly_by (ps_br_phantom_2.p5);
	cs_fly_by (ps_br_phantom_2.p6);
	
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.4, 560 );
	
	cs_fly_by (ps_br_phantom_1.p8);
	cs_fly_by (ps_br_phantom_1.p9);
	
	ai_erase (sq_br_phantom_2);

end

//PHANTOM 03 DROPS BACK SQUAD
script command_script phantom_fly_3()
	cs_ignore_obstacles (TRUE);
		
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 60 );
	
	cs_fly_by (ps_br_phantom_3.p7);
	cs_fly_by (ps_br_phantom_3.p0);
	cs_fly_by (ps_br_phantom_3.p1);
	cs_fly_by (ps_br_phantom_3.p2);
	cs_fly_to_and_face (ps_br_phantom_3.p3, ps_br_phantom_3.p4);
	
	ai_set_blind (sq_br_phantom_3, FALSE);
	ai_set_deaf (sq_br_phantom_3, FALSE);
	
	cs_fly_to (ps_br_phantom_3.p3);
	cs_fly_to_and_dock (ps_br_phantom_3.p3, ps_br_phantom_3.p4, 3);
	//ai_braindead (sq_br_phantom_3, TRUE);
			
	sleep (30 * 2);
	
	f_load_phantom (sq_br_phantom_3, right, sg_bridge_end_elite, sg_bridge_end_middle, none, none);
	
	sleep (10);
	
	f_unload_phantom( sq_br_phantom_3, right );
		
	sleep (30 * 10);
	
	cs_vehicle_speed (0.6);
	
	cs_fly_to_and_face (ps_br_phantom_3.p5, ps_br_phantom_3.p6);
	cs_fly_by (ps_br_phantom_3.p6);
	
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.4, 560 );
	
	cs_fly_by (ps_br_phantom_1.p7);
	cs_fly_by (ps_br_phantom_1.p8);
	cs_fly_by (ps_br_phantom_1.p9);
		
	ai_erase (sq_br_phantom_3);

end



// =================================================================================================
// BRIDGE BANSHEES FLY
// =================================================================================================

script command_script banshee_fly_1()
	print ("banshee 1 spawn");
	
	
	
	if game_difficulty_get_real() == "easy" or game_difficulty_get_real() == "normal" then 
	unit_set_current_vitality (unit_get_vehicle (sq_bridge_banshee_1), 80, 0);
	print ("------- banshee spawn 1");
	end
	
	unit_set_current_vitality (unit_get_vehicle (sq_bridge_banshee_1), 180, 0);
		
	cs_fly_by (ps_banshee_bridge_01.p0);
	cs_fly_by (ps_banshee_bridge_01.p1);
	cs_fly_by (ps_banshee_bridge_01.p5);
	
	//sleep (30*10);
	
	print ("BANSHEE 1 CAN SEE U");
	ai_set_deaf (sq_bridge_banshee_1, 0);
	ai_set_blind (sq_bridge_banshee_1, 0);
end

script command_script banshee_fly_2()
	print ("banshee 2 spawn");
	
	if game_difficulty_get_real() == "easy" or game_difficulty_get_real() == "normal" then 
	unit_set_current_vitality (unit_get_vehicle (sq_bridge_banshee_2), 80, 0);
	print ("----------- banshee spawn 2");
	end
	
	unit_set_current_vitality (unit_get_vehicle (sq_bridge_banshee_2), 180, 0);
	
	cs_fly_by (ps_banshee_bridge_02.p0);
	cs_fly_by (ps_banshee_bridge_02.p1);
	cs_fly_by (ps_banshee_bridge_02.p2);
	cs_fly_by (ps_banshee_bridge_02.p3);
	cs_fly_by (ps_banshee_bridge_02.p4);
	
	print ("BANSHEE 2 CAN SEE U");
	ai_set_deaf (sq_bridge_banshee_2, 0);
	ai_set_blind (sq_bridge_banshee_2, 0);
end


//IF PLAYER HIJACKS BANSHEE, SPAWN MORE
script dormant player_banshee_hijack()
	dprint( "Waiting for Banshee hijack" );
	sleep_until (player_in_vehicle (ai_vehicle_get_from_squad (sq_bridge_banshee_1,0)) or player_in_vehicle (ai_vehicle_get_from_squad (sq_bridge_banshee_2,0)));
	local long banshee_tut_01 = thread (f_banshee_tutorial(player0));
	local long banshee_tut_02 = thread (f_banshee_tutorial(player1));
	local long banshee_tut_03 = thread (f_banshee_tutorial(player2));
	local long banshee_tut_04 = thread (f_banshee_tutorial(player3));
	
	dprint ("SPAWNING 3RD BANSHEE");
	ai_place (sq_bridge_banshee_3);
	sleep_until (ai_living_count (sg_all_bridge_banshees) <= 1);
	
	dprint ("SPAWNING 4TH BANSHEE");
	ai_place (sq_bridge_banshee_4);
	
	sleep_until(b_courtyard_airlock == TRUE, 1);
	kill_thread(banshee_tut_01);
	kill_thread(banshee_tut_02);
	kill_thread(banshee_tut_03);
	kill_thread(banshee_tut_04);
	
end

//extra banshees fly in
script command_script f_br_banshee_03()
	cs_fly_by (ps_banshee_bridge_03.p0);
	cs_fly_by (ps_banshee_bridge_03.p1);

end

script command_script f_br_banshee_04()
	cs_fly_by (ps_banshee_bridge_04.p0);

end


//diaplay banshee tutorial
script static void f_banshee_tutorial(player p_player)
	sleep (30*6);
	sleep_until (unit_in_vehicle (p_player), 1);
	chud_show_screen_training (p_player, "training_bansheeboost"); 
	sleep (30*3);
	chud_show_screen_training (p_player, "");
	sleep (30*3);
		
	sleep_until (unit_in_vehicle (p_player), 1);
	chud_show_screen_training (p_player, "training_firebansheebomb"); 
	sleep (30*3);
	chud_show_screen_training (p_player, "");
	sleep (30*3);
		
	sleep_until (unit_in_vehicle (p_player), 1);
	chud_show_screen_training (p_player, "training_bansheetrick"); 
	sleep (30*3);
	chud_show_screen_training (p_player, "");
	sleep (30*3);

end	
	

//BRIDGE END SPAWN TRIGGERS
script dormant spawn_bridge_3()
	sleep_until (volume_test_players (tv_br_firsthalf_rear), 1);
	//ai_place (sq_br_phantom_3);
	dprint ("::: SPAWN Phantom Drop :::");

	sleep_until (volume_test_players (tv_bridge_end_01), 1);
		ai_place (sg_bridge_end_front_st);
		ai_place (sg_bridge_end_front);
		ai_place (sg_bridge_end_under);
		dprint ("::: SPAWN Bridge End 01 :::");
		
	sleep_until (volume_test_players (tv_bridge_end_02), 1);
		//ai_place (sg_bridge_end_elite);
		//ai_place (sg_bridge_end_middle);
		dprint ("::: SPAWN Bridge End 02 :::");

	sleep_until (volume_test_players (tv_bridge_end_03), 1);
		ai_place (sg_bridge_end_back);
		dprint ("::: SPAWN Bridge End 03 :::");

end


script dormant f_spawn_bridge_2()
	sleep_until (volume_test_players (tv_bridge_2), 1);
	ai_place (sg_bridge_middle);
	
	dprint ("::: bridge middle :::");
	
	wake (spawn_bridge_3);
	
end


//BRIDGE TO_COURTYARD AIRLOCK TRANSITION
script dormant bridge_doors_open()
	sleep_until (volume_test_players (tv_bridge_door_01), 1);
	
	dm_door_to_courtyard_01->open();
	dm_door_to_courtyard_01->auto_trigger_close( tv_to_courtyard_doors, FALSE, TRUE, TRUE );
		
	//END BRIDGE MUSIC
	thread (f_mus_m20_e04_finish());
	thread (f_mus_m20_e05_finish());
	
	sleep_until (dm_door_to_courtyard_01->check_close(), 1);
	
	
	//teleport players if not in airlock
	if
		not volume_test_object (tv_bridge_airlock_check, player0)
	then
		object_teleport (player0, bridge_hall_teleport_0);
	end
	
	if
		not volume_test_object (tv_bridge_airlock_check, player1)
	then
		object_teleport (player1, bridge_hall_teleport_1);
	end
	
	if
		not volume_test_object (tv_bridge_airlock_check, player2)
	then
		object_teleport (player2, bridge_hall_teleport_2);
	end
	
	if
		not volume_test_object (tv_bridge_airlock_check, player3)
	then
		object_teleport (player3, bridge_hall_teleport_3);
	end
	
	
	//play letterbox title
	thread (m20_courtyard_entrance());
	
	b_courtyard_airlock = TRUE;
	
	//DESTROY ALL BANSHEES IN AIRLOCK
	thread (destroy_all_banshees());
	
	sleep_until (b_airlock_banshees_destroyed == TRUE);
		
	dprint (":: PREPARE TO SWITCH TO COURTYARD ::");
	zone_set_trigger_volume_enable ("begin_zone_set:17_courtyard", TRUE);
	
	sleep (30*3);

	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	dprint ("finished streaming");
	
	//SWITCH ZONESET
	zone_set_trigger_volume_enable ("zone_set:17_courtyard", TRUE);
	dprint ("ZONESET HAS CHANGED");

	sleep_until (volume_test_players (tv_door_courtyard), 1);
	
	//BEGIN COURTYARD
	wake (f_courtyard_main);
	
	game_save_no_timeout();
	
	courtyard_door->open();
	
	dprint ("PLAY MUSIC!");
	thread (f_mus_m20_e06_begin());
	
	courtyard_door->auto_trigger_close( tv_court_door_close, TRUE, TRUE, TRUE );
	
	sleep_until( courtyard_door->check_close(), 1 );
	dprint ("door has closed");

end


//BLOW UP ANY BANSHEES IN AIRLOCK
script static void destroy_all_banshees()
	if
		unit_in_vehicle_type (player0, 30)
	then
		unit_exit_vehicle (player0);
	end
	
	if
		unit_in_vehicle_type (player1, 30)
	then
		unit_exit_vehicle (player1);
	end
	
	if
		unit_in_vehicle_type (player2, 30)
	then
		unit_exit_vehicle (player2);
	end
	
	if
		unit_in_vehicle_type (player3, 30)
	then
		unit_exit_vehicle (player3);
	end
	
	sleep_until (not (unit_in_vehicle (player0))
	and
	not (unit_in_vehicle (player1))
	and
	not (unit_in_vehicle (player2))
	and
	not (unit_in_vehicle (player3))
	);

	sleep (10);

	repeat

	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 0), "hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 0), "canopy", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 0), "wing_right", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 0), "wing_left", 500);

	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 1), "hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 1), "canopy", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 1), "wing_right", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 1), "wing_left", 500);

	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 2), "hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 2), "canopy", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 2), "wing_right", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 2), "wing_left", 500);
	
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 3), "hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 3), "canopy", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 3), "wing_right", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 3), "wing_left", 500);
	
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 4), "hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 4), "canopy", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 4), "wing_right", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 4), "wing_left", 500);
	
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 5), "hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 5), "canopy", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 5), "wing_right", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30), 5), "wing_left", 500);
	
	print ("Destroying Banshees");

	until (list_count(volume_return_objects_by_campaign_type (tv_bridge_airlock_check, 30)) == 0, 1);

	print ("ALL BANSHEES DESTROYED");
	b_airlock_banshees_destroyed = TRUE;

end


// =================================================================================================
// =================================================================================================
// COURTYARD
// =================================================================================================
// =================================================================================================

script dormant f_courtyard_main()
	dprint ("::: courtyard start :::");
		
	data_mine_set_mission_segment (m20_courtyard);
	
	// By order of tholmes, all effects in this area are now under strict curfew.
	effects_perf_armageddon = true;
	
	wake (f_spawn_courtyard);
	wake (f_spawn_court_hall);
	wake (f_spawn_court_hall_sides);
	wake (f_kill_center_hall_spawn);
	wake (f_courtyard_end);
	wake (f_court_flank_spawn_adjust);
	wake (kill_side_encounters);
	wake (courtyard_phantom_arrives);
	wake (f_objcon_courtyard);
	wake (last_stand_enemies);
	thread (courtyard_enemy_cleanup());
	
	dprint ("DISABLING TERMINUS AIRLOCK TRIGGERS");
	zone_set_trigger_volume_enable ("begin_zone_set:19_terminus:*", FALSE); 
	zone_set_trigger_volume_enable ("zone_set:19_terminus:*", FALSE); 
	
	b_insertion_fade_in = TRUE;

end


//SPAWN COURTYARD
script dormant f_spawn_courtyard()
	dprint ("SPAWNING COURTYARD...");
	ai_place (sg_cy_center);
	ai_place (sg_cy_right);
	ai_place (sg_cy_left);
	ai_place (sg_cy_front);
	ai_place (sq_courtyard_ghost_1);
	ai_place (sq_courtyard_ghost_2);
	ai_place (sq_cy_phantom_start_01);
	ai_place (sq_cy_phantom_start_02);
		
end

//CLEAN UP ENEMY SPAWNS IN COURTYARD
script static void courtyard_enemy_cleanup()
local real r_distance = 10.0;
dprint ("loaded enemy cleanup script");

	sleep_until (volume_test_players (tv_gs_courtyard_time), 1);
	dprint ("attempting to clean up courtyard front");
	f_ai_garbage_erase( sq_courtyard_front_01, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_front_02, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	
		
	sleep_until (
	volume_test_players (tv_court_hall) or
	volume_test_players (tv_court_right_safe_spawn)
	, 1);
	dprint ("attempting to clean up courtyard front and sides");

	f_ai_garbage_erase( sq_courtyard_front_01, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_front_02, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_center, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_right, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_left, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_left_sniper, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_ghost_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_ghost_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	
	
	sleep_until (
	volume_test_players (tv_hall_right_main) or
	volume_test_players (tv_hall_left_main) or
	volume_test_players (tv_court_right_safe_spawn)
	, 1);
	dprint ("attempting to clean up courtyard hall center");

	f_ai_garbage_erase( sq_court_hall_grunts, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_court_hall_elite, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_end_g, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_courtyard_end_e, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	

	sleep_until (
	volume_test_players (tv_hall_right_save) or
	volume_test_players (tv_hall_left_save)
	, 1);
	dprint ("attempting to clean up mid courtyard hall sides");

	f_ai_garbage_erase( sq_hall_left_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_right_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_left_ramp, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_right_ramp, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_left_main, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_right_main, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_middle_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_middle_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_jackal_left_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_jackal_left_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_jackal_right_1, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );
	f_ai_garbage_erase( sq_hall_jackal_right_2, r_distance, -1, -1, -1, FALSE, TRUE, FALSE );	

		
end

//COURTYARD OBJCON
script dormant f_objcon_courtyard()
	sleep_until (volume_test_players (tv_objcon_cy_front), 1);
	dprint ("::: OBJCON CY FRONT :::");
	s_objcon_courtyard = 10;
	
	sleep_until (volume_test_players (tv_court_elite_break), 1);
	dprint ("::: OBJCON ELITE BREAKS :::");
	s_objcon_courtyard = 40;

end

//SPAWN END
script dormant f_courtyard_end()
	sleep_until (volume_test_players (tv_court_end), 1);
	dprint ("SPAWN END");
	ai_place (sg_courtyard_end);
	
end

//SPAWN COURTYARD HALL
script dormant f_spawn_court_hall()
	sleep_until (
	volume_test_players (tv_court_hall), 1);
	
	game_save_no_timeout();
	
	ai_place (sq_court_hall_elite);
	ai_place (sq_court_hall_grunts);
	
	wake (f_swort_elite_berserk);
	
end

//IF PLAYERS TAKE FAR RIGHT SNEAK ROUTE, ADJUST SPAWNS
script dormant f_court_flank_spawn_adjust()
	sleep_until (volume_test_players (tv_court_right_safe_spawn), 1);
	dprint ("player took flank route, adjusting encounters...");
	
	sleep_forever (f_spawn_court_hall_sides);
	sleep_forever (spawn_court_hall_right);
	sleep_forever (f_spawn_court_hall);
	sleep_forever (spawn_court_hall_right);
	sleep_forever (courtyard_phantom_arrives);

	ai_place (courtyard_phantom_01);
	ai_place (sq_hall_right_main);
	ai_place (sq_hall_jackal_right_1);
	ai_place (sq_hall_jackal_right_2);
		
	wake (spawn_court_hall_left);

end

//SPAWN COURTYARD HALL SIDES	
script dormant f_spawn_court_hall_sides()
	sleep_until (
	volume_test_players (tv_court_hall_back) or
	volume_test_players (tv_force_hall_spawn)
	, 1);
	
	ai_place (sg_hall_left_right);
	
	wake (spawn_court_hall_left);
	wake (spawn_court_hall_right);
	
end

//if player bypasses middle hall, kill its spawn
script dormant f_kill_center_hall_spawn()
	sleep_until (
		volume_test_players (tv_force_hall_spawn) or
		volume_test_players (tv_court_right_safe_spawn)
	, 1);
	sleep_forever (f_spawn_court_hall);

end


//ELITE GOES BERSERK
script dormant f_swort_elite_berserk()
	sleep_until (ai_living_count (sq_court_hall_grunts) <= 2);
	dprint ("BURZURK!");
	ai_berserk (sq_court_hall_elite, TRUE);

end

//FIRST PHANTOM DEPARTS
script command_script f_cy_phantom_start_01()
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed (0.2);

	sleep (30*2.5);

	cs_fly_to_and_face (ps_cy_phantom_start_01.p0, ps_cy_phantom_start_01.p1);
	
	cs_vehicle_speed (0.6);

	cs_fly_by (ps_cy_phantom_start_01.p1);

	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 300 );

	cs_fly_by (ps_cy_phantom_start_01.p2);

	object_destroy( ai_vehicle_get( ai_current_actor ) );

end


//SECOND PHANTOM DEPARTS
script command_script f_cy_phantom_start_02()
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed (0.8);

	sleep (30*12);

	cs_fly_to_and_face (ps_cy_phantom_01.p2, ps_cy_phantom_01.p1);

	cs_fly_by (ps_cy_phantom_01.p7);
	cs_fly_by (ps_cy_phantom_01.p5);
	cs_fly_by (ps_cy_phantom_01.p0);
	cs_fly_by (ps_cy_phantom_01.p8);

	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 300 );

	cs_fly_by (ps_cy_phantom_01.p9);

	object_destroy( ai_vehicle_get( ai_current_actor ) );

end


//SPAWN HALLS
script dormant spawn_court_hall_left()
	sleep_until (volume_test_players (tv_hall_left_main), 1);
	ai_place (sq_hall_left_main);
	
	sleep_until (volume_test_players (tv_hall_left_jackal), 1);
	ai_place (sq_hall_jackal_left_1);
	ai_place (sq_hall_jackal_left_2);
	
	sleep_until (volume_test_players (tv_hall_left_save), 1);
	game_save_no_timeout();

end

script dormant spawn_court_hall_right()
	sleep_until (volume_test_players (tv_hall_right_main), 1);
	ai_place (sq_hall_right_main);
	
	sleep_until (volume_test_players (tv_hall_right_jackal), 1);
	ai_place (sq_hall_jackal_right_1);
	ai_place (sq_hall_jackal_right_2);
	
	sleep_until (volume_test_players (tv_hall_right_save), 1);
	game_save_no_timeout();

end


//SPAWN COURTYARD PHANTOM
script dormant courtyard_phantom_arrives()
	sleep_until (volume_test_players (tv_courtyard_phantom), 1);
	ai_place (courtyard_phantom_01);

end

//COURTYARD PHANTOM FLIES IN
script command_script courtyard_phantom_01()
	dprint ("ENTER PHANTOM");

	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 180 );
 
	cs_fly_by (ps_cy_phantom_01.p0);
	cs_fly_by (ps_cy_phantom_01.p1);
	cs_fly_by (ps_cy_phantom_01.p2);
	cs_fly_to (ps_cy_phantom_01.p3);
	cs_fly_to_and_face (ps_cy_phantom_01.p3, ps_cy_phantom_01.p4);
	
	dprint ("PHANTOM IS BLIND");
	ai_set_deaf (courtyard_phantom_01, TRUE);
	ai_set_blind (courtyard_phantom_01, TRUE);
	
	f_load_phantom( courtyard_phantom_01, "left", sq_last_stand_elites, none, none, none);
	f_load_phantom( courtyard_phantom_01, "chute", sq_last_stand_hunter_01, sq_last_stand_hunter_02, none, none);
	
	sleep (10);
	
	f_unload_phantom( courtyard_phantom_01, "left" );
	f_unload_phantom( courtyard_phantom_01, "chute" );
		
	unit_only_takes_damage_from_players_team (sq_last_stand_hunter_01.unit_01, TRUE);
	unit_only_takes_damage_from_players_team (sq_last_stand_hunter_02.unit_02, TRUE);

	sleep_until (volume_test_players (tv_courtyard_phantom_leaves)
	or ai_strength (courtyard_phantom_01) < 1, 1);
		dprint ("PHANTOM SEES YOU");
		
		ai_set_deaf (courtyard_phantom_01, FALSE);
		ai_set_blind (courtyard_phantom_01, FALSE);
		
		sleep (30*2);
		cs_fly_by (ps_cy_phantom_01.p5);
		cs_fly_by (ps_cy_phantom_01.p6);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 180 );
		
		sleep (30*1);
		object_destroy( ai_vehicle_get( ai_current_actor ) );

end


//SPAWN LAST STAND ENEMIES
script dormant last_stand_enemies()
	sleep_until (volume_test_players (tv_courtyard_phantom_leaves), 1);
	
	//place last stand squads and then kills them
	ai_place (sq_spawn_kill);
	ai_kill_silent (sq_spawn_kill);
	
	dprint ("SPAWN LAST STAND SENTINELS");
	ai_place (sq_last_stand_sentinels);
	ai_allegiance (player, forerunner);
	wake (last_stand_save);

end


//ONCE PLAYERS REACH THE TOP TIER, KILL THE ENEMY SPAWNERS ON BOTH SIDES SO THEY CAN'T GO BACK AROUND
script dormant kill_side_encounters()
	sleep_until (volume_test_players (tv_courtyard_phantom_leaves), 1);
	sleep_forever (spawn_court_hall_right);
	sleep_forever (spawn_court_hall_left);
	sleep_forever (f_spawn_court_hall);
	
end


//LAST STAND SAVE & STOP MUSIC
script dormant last_stand_save()
	sleep_until (volume_test_players (tv_last_stand_dialog), 1);
	wake (f_dialog_m20_last_stand);
		
	sleep_until (
		ai_living_count (sq_last_stand_elites) <= 0 and
		ai_living_count (sg_last_stand_hunters) <= 0
	);
	
	game_save_no_timeout();
	
	sleep (30*2);
	
	thread (f_mus_m20_e06_finish());
	
	sleep (30*1);
		
	f_blip_flag (flag_court_door_blip, "default");	
	wake (f_end_sentinel_warp);
	wake (m20_atrium_ent);
		
	dprint ("Terminus Door Unlocked");
	wake (terminus_airlock);
	
end

script dormant f_end_sentinel_warp()
	//sleep_until (ai_living_count (sq_last_stand_sentinels) < 5);
	ai_kill (sq_last_stand_sentinels.spawn_points_0);
	sleep (30);
	ai_kill (sq_last_stand_sentinels.spawn_points_1);
	sleep (30);
	ai_kill (sq_last_stand_sentinels.spawn_points_2);
	sleep (30);
	ai_kill (sq_last_stand_sentinels.spawn_points_3);
	sleep (30);
	ai_kill (sq_last_stand_sentinels.spawn_points_4);

end


//TERMINUS TRANSITION AIRLOCK
script dormant terminus_airlock()
	sleep_until (volume_test_players (tv_terminus_door_open), 1); 
	
	f_unblip_flag (flag_court_door_blip);
	
	atrium_door_01->open();
	atrium_door_01->auto_trigger_close( tv_atrium_airlock, FALSE, TRUE, TRUE );
	
	sleep_until( atrium_door_01->check_close(), 1 );
	dprint ("door has closed");
	
	//ERASE ALL PREVIOUS SQUADS
	ai_erase (sg_courtyard);
	ai_erase (sg_cy_front);
	ai_erase (sg_cy_center);
	ai_erase (sg_cy_right);
	ai_erase (sg_cy_left);
	ai_erase (sg_courtyard_end);
	ai_erase (sg_hall_left_right);
	ai_erase (sg_last_stand_sentinels);
	ai_erase (sg_last_stand_hunters);
	ai_erase (sg_last_stand_elites);	
	
	zone_set_trigger_volume_enable ("begin_zone_set:19_terminus:*", TRUE); 
	dprint ("TERMINUS AIRLOCK BEGIN ZONE");
	
	sleep (30*3);
	
	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);

	zone_set_trigger_volume_enable ("zone_set:19_terminus:*", TRUE); 
	dprint ("TERMINUS AIRLOCK ZONE SWITCH");
		
	data_mine_set_mission_segment (m20_atrium);

	dprint ("waking terminus main");
	wake (f_terminus_main);
	
end


// =================================================================================================
// =================================================================================================
// TERMINUS
// =================================================================================================
// =================================================================================================

script dormant f_terminus_main()
	
	dprint ("::: terminus start :::");
	
	zone_set_trigger_volume_enable ("begin_zone_set:terminus_to_cin_m21:*", FALSE); 
	zone_set_trigger_volume_enable ("zone_set:terminus_to_cin_m21:*", FALSE); 
	
	wake (f_tower_elevator_start);
	wake (f_terminus_devices);
	wake (m20_atrium_waypoint);
	
	ai_place (sq_ambient_sentinels);
	ai_place (sq_curtain_sentinels);
	
	game_save_no_timeout();
	
	cui_hud_set_new_objective (objective_7);
	objectives_finish (3);
	objectives_show_up_to (4);	
	atrium_door_02->open();
	atrium_door_02->auto_trigger_close( tv_atrium_airlock_close, TRUE, TRUE, TRUE );
	
	sleep_until( atrium_door_02->check_close(), 1 );
	
	// Initiate loading of final cinematic resources
	if (not editor_mode()) then
		zone_set_trigger_volume_enable("begin_zone_set:terminus_to_cin_m21:*", TRUE);
		sleep_until(current_zone_set() == s_zoneset_terminus_to_cin_m21 and not PreparingToSwitchZoneSet(), 1);
	end
	
	zone_set_trigger_volume_enable("zone_set:terminus_to_cin_m21:*", TRUE);
end



//SPAWN AND MOVE AMBIENT SENTINELS
script command_script ambient_sentinel_1
	
	repeat
	
		cs_fly_to (ps_sentinel_flight_loops.p0);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops.p4);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops.p1);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops.p2);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops.p0);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops.p5);
	
	until (1 == 0);

end

script command_script ambient_sentinel_2
	repeat
		cs_fly_to (ps_sentinel_flight_loops2.p1);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops2.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops2.p2);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops2.p7);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops2.p5);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops2.p10);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops2.p8);
	until (1 == 0);

end

script command_script ambient_sentinel_3
	repeat
		cs_fly_to (ps_sentinel_flight_loops3.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops3.p0);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops3.p10);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops3.p7);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops3.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops3.p8);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops3.p4);
	until (1 == 0);

end

script command_script ambient_sentinel_4
	repeat
		cs_fly_to (ps_sentinel_flight_loops4.p1);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops4.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops4.p10);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops4.p4);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops4.p2);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops4.p8);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops4.p9);
	until (1 == 0);

end

script command_script ambient_sentinel_5
	repeat
		cs_fly_to (ps_sentinel_flight_loops5.p4);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops5.p6);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops5.p10);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops5.p4);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops5.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops5.p1);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops5.p0);
	until (1 == 0);

end


script command_script ambient_sentinel_6
	sleep (30*2);
	cs_fly_by (ps_sentinel_flight_loops6.p0);
	cs_fly_by (ps_sentinel_flight_loops6.p1);
	cs_fly_by (ps_sentinel_flight_loops6.p2);
	
	repeat
		cs_fly_to (ps_sentinel_flight_loops6.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops6.p4);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops6.p5);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops6.p2);
		sleep (random_range (5, 45));
	until (1 == 0);

end

script command_script ambient_sentinel_7
	sleep (30*3);
	cs_fly_by (ps_sentinel_flight_loops7.p0);
	cs_fly_by (ps_sentinel_flight_loops7.p1);
	cs_fly_by (ps_sentinel_flight_loops7.p2);
	
	repeat
		cs_fly_to (ps_sentinel_flight_loops7.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops7.p5);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops7.p4);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops7.p2);
		sleep (random_range (5, 45));
	until (1 == 0);

end

script command_script ambient_sentinel_8
	sleep (15);
	cs_fly_by (ps_sentinel_flight_loops8.p0);
	cs_fly_by (ps_sentinel_flight_loops8.p1);
	cs_fly_by (ps_sentinel_flight_loops8.p2);
	
	repeat
		cs_fly_to (ps_sentinel_flight_loops8.p3);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops8.p5);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops8.p4);
		sleep (random_range (5, 45));
		cs_fly_to (ps_sentinel_flight_loops8.p2);
		sleep (random_range (5, 45));
	until (1 == 0);

end



//OPEN THE TERMINUS CURTAINS
script dormant f_terminus_devices()
	dprint (":: PRESENTING... TERMINUS! ::");
	
	sleep (30*1);
	
	//start curtains parting
	thread (term_curtain_01a());
	thread (term_curtain_01b());
	
	sleep (30*2);
	
	thread (term_curtain_02a());
	thread (term_curtain_02b());
	
	sleep (30*2);
	
	thread (term_curtain_03a());
	thread (term_curtain_03b());
	
	sleep (30*2);
	
	thread (term_curtain_04a());
	thread (term_curtain_04b());
	
	sleep (30*2);
	
	thread (term_curtain_05a());
	thread (term_curtain_05b());
		
end

script static void term_curtain_01a()
	term_curtain_01a->open();
	term_curtain_01a->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_01b()
	term_curtain_01b->open();
	term_curtain_01b->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_02a()
	term_curtain_02a->open();
	term_curtain_02a->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_02b()
	term_curtain_02b->open();
	term_curtain_02b->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_03a()
	term_curtain_03a->open();
	term_curtain_03a->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_03b()
	term_curtain_03b->open();
	term_curtain_03b->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_04a()
	term_curtain_04a->open();
	term_curtain_04a->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_04b()
	term_curtain_04b->open();
	term_curtain_04b->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_05a()
	term_curtain_05a->open();
	term_curtain_05a->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end

script static void term_curtain_05b()
	term_curtain_05b->open();
	term_curtain_05b->auto_trigger_close( tv_tower_elevator, TRUE, TRUE, FALSE );

end


//TOWER ELEVATOR
script dormant f_tower_elevator_start()
	sleep_until (volume_test_players (tv_obj_tower), 1);
	sleep (30*5);
		
	dm_terminus_lift->open();
	thread (f_tower_elevator_go());

	sleep_until (volume_test_players (tv_ending_cine), 1);
	dprint ("ENTERING ENDING CINEMATIC");
	//fade_out (0, 0, 0, 120);
	wake (cutscene_m21_tower);

end


script static void f_tower_elevator_go()
	sleep_until (volume_test_players_all (tv_tower_elevator), 1);
	sleep (30*2);
	
	dm_terminus_lift->auto_trigger_close( tv_tower_elevator, FALSE, TRUE, TRUE );
	dprint ("::: going up :::");

end


// =================================================================================================
// =================================================================================================
// DEBUG
// =================================================================================================
// =================================================================================================

script static void dprint (string s)
	if b_debug then
		print (s);
	end

end

script dormant f_obj_bridge_banshee()
	sleep_until (volume_test_players (tv_objcon_banshee_1), 1);
	dprint ("::: Banshee Follow 1 :::");
	s_objcon_bridge_banshee = 1;
	
	sleep_until (volume_test_players (tv_objcon_banshee_2), 1);
	dprint ("::: Banshee Follow 2 :::");
	s_objcon_bridge_banshee = 2;

end




// =================================================================================================
// =================================================================================================
// OBJECTIVES
// =================================================================================================
// =================================================================================================

//OBJECTIVE DISPLAY
script dormant f_objectives_controller()
	objectives_set_string (0, objective_1); 
	objectives_set_string (1, objective_2); 
	//objectives_set_string (2, objective_3);
	//objectives_set_string (2, objective_4);
	//objectives_set_string (2, objective_5);
	objectives_set_string (2, objective_5);
	objectives_set_string (3, objective_6);
	objectives_set_string (4, objective_7);
	print ("Objectives Controller Go");

end