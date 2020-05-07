/*
	343 Industries - Copyright Microsoft 2011
	Hammer Team AI (BVT) Test Map
	Scripting created by Thomas Coldwell (a-thcold@microsoft.com)
	
	PURPOSE:
	Test a number of different AI/scripting functions that are used frequently by designers.

	TO-ADD:
	- bishop activating forerunner turrets
	- knights using cover is going to be changed soon - talk to rob about cover mechanics
*/

/// VARS
global boolean b_endless_bath = FALSE;



// =================================================================================================
// =================================================================================================
// Startup script
// =================================================================================================
// =================================================================================================
script startup su_test_startup()
	print ("::: AI TEST MAP: Version 2011.09.02.1541 :::");
	print ("::: AI TEST MAP: STARTUP SCRIPT WORKED! :::");

	// Allow 20 AI to work at a time
	ai_lod_full_detail_actors (20);
	print ("::: AI TEST MAP: SET ACTIVE AI TO 20 :::");

	// Run our "start" script
	start();

	// Fade in from Red to noral over 1 second (30 ticks)
	fade_in (255, 0, 0, 30);
end



// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

script static void start()
	print ("::: AI TEST MAP: Game started! :::");
	
	// Check active players
	if (player_count() > 0) then
		print (" player count is GREATER than zero!");
	else
		print (" player count is zero or less!");
	end

	// Wake dormant scripts
	wake (sc_testplayer);
	wake (sc_waitforevent);
	wake (sc_globaltests);
	
	// test event system 1 seconds after starting level
	sleep (30);
	NotifyLevel ("bvt_test");
	
end


// =================================================================================================
// =================================================================================================
// DORMANT SCRIPTS
// =================================================================================================
// =================================================================================================

// trigger volume test (players)
script dormant sc_testplayer()
	sleep_until (volume_test_players (tv_playerspawn), 15);
	print ("Player has spawned!");
end

// event system test
script dormant sc_waitforevent()
	sleep_until ( LevelEventStatus ("bvt_test"), 1);
	print ("LevelEventStatus test worked!  Yay!");
end

// global variable tests (stored in a separate file)
script dormant sc_globaltests()
	sleep (30);
	
	// Test global bool FALSE
	// note that "!bool" format doesn't work
	if (not(b_bvt_bool_f)) then
		print ("Bool_f PASS");
	else
		print ("Bool_f FAIL");
	end
	
	// Test global bool TRUE
	if (b_bvt_bool_t) then
		print ("Bool_t PASS");
	else
		print ("Bool_t FAIL");
	end
	
	// Test global s_bvt_short
	if (s_bvt_short == 0) then
		print ("s_bvt_short PASS");
	else
		print ("s_bvt_short FAIL");
	end
	
	// Test global s_bvt_long
	if (s_bvt_long == 254) then
		print ("s_bvt_short PASS");
	else
		print ("s_bvt_short FAIL");
	end
	
	// Test global s_bvt_string
	if (s_bvt_string == "bvt string test") then
		print ("s_bvt_string PASS");
	else
		print ("s_bvt_string FAIL");
	end
	
end

// =================================================================================================
// =================================================================================================
// Dropship Placement Scripts
// =================================================================================================
// =================================================================================================

// script static void bvt_dropships()
	// ai_place (sq_ds_phantom);
	// ai_place (sq_ds_pelican);
	// ai_place (sq_ds_facing);
	// ai_place (sq_ds_vehicledrop1);
// end



// =================================================================================================
// =================================================================================================
// Boolean Scripts
// =================================================================================================
// =================================================================================================

// Check to see if the current AI is the vehicle driver
// returns TRUE if the AI is the driver
// script static boolean f_ai_is_driver_old( ai mysquad )
	// vehicle_test_seat_unit ( ai_vehicle_get ( mysquad ), phantom_d, mysquad ) or
	// vehicle_test_seat_unit ( ai_vehicle_get ( mysquad ), pelican_p_l05, mysquad );
// end


// A simpler way to check if the current AI is the vehicle driver
// returns TRUE if the AI is the driver
script static boolean f_ai_is_driver( ai mysquad )
	vehicle_driver (ai_vehicle_get (mysquad)) == ai_current_actor;
end


// =================================================================================================
// =================================================================================================
// Command Scripts
// =================================================================================================
// =================================================================================================

// _______________________________________________
//
// "Birthing" bishops and pawns
// _______________________________________________

// Command script to draw attention to what state the AI are in
script static void cs_knight_spawn
	print("knight spawned!");
	//wake (sc_birthing_display);
	wake (cs_pawn_spawn);
	ai_place (sq_fm_knight);
	ai_place (sq_fm_bishop);
end


// CS for bishops that need to be spawned via Knight
script command_script cs_bishop_spawn
	print("bishop ready to be spawned by Knight");
	ai_enter_limbo(ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_bishop, 0);
end

// CS for pawns that need to be spawned from a pawn-spawner
script dormant cs_pawn_spawn
	print("pawn ready to be spawned by spawner");
	ai_place_with_shards(sq_fm_pawns);
	sleep_until(ai_living_count (sq_fm_pawns) > 2, 15);
	print ("Pawns should be spawned.");
	//sleep (30 * 2);
	//ai_erase (sq_fm_bishop);
	//ai_enter_limbo(ai_current_actor);
	//CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_pawn, 1.5);
end

// Generic callback script to run after AI has spawned
script static void OnCompleteProtoSpawn_bishop()
	print("!!!BISHOP spawned from KNIGHT!!!");
end

// Generic callback script to run after AI has spawned
script static void OnCompleteProtoSpawn_pawn()
	print("!!!PAWN spawned from SPAWNER!!!");
end


// _______________________________________________
//
// cs_go_to
// _______________________________________________
script command_script cs_test_infantry_goto
	cs_go_to (pts_goto.p0);
end

script command_script cs_test_infantry_goto2
	cs_go_to (ai_current_squad, true, pts_goto.p0, 0.5);
end

script command_script cs_test_bishop_goto
	cs_fly_to (pts_goto.p0);
end

script command_script cs_test_bishop_goto2
	cs_fly_to (ai_current_squad, true, pts_goto.p0, 0.5);
end


// _______________________________________________
//
// Phasing
// _______________________________________________
script command_script cs_test_phase_attack
	print ("PHASING: Knight Attacking!");
	ai_render_strength = true;
	cs_phase_to_point (pts_phasing.attack);
end


script command_script cs_test_phase_heal
	print ("PHASING: Knight Retreating!  Knight Immortal!");
	ai_cannot_die (ai_current_actor, true);
	cs_phase_to_point (pts_phasing.heal);
	sleep_until (volume_test_object (tv_phase_knights, sq_ph_knightpt), 15);
	print ("PHASING: Knight Successfully Retreated!  Knight no longer immortal!");
	ai_cannot_die (ai_current_actor, false);
	ai_render_strength = false;
end


// _______________________________________________
//
// Combat Suppression
// _______________________________________________

// Combat suppression - SQUAD
script command_script cs_test_combat_sup
	ai_suppress_combat (ai_current_squad, true);
end

// Combat suppression - ACTOR
script command_script cs_test_combat_sup2
	ai_suppress_combat (ai_current_actor, true);
end

// Combat suppression - SPECIFIC
script command_script cs_test_combat_sup3
	ai_suppress_combat (ai_get_squad (ai_current_actor), true);
end

// Try the following in the future:
// object_set_melee_attack_inhibited <object> <bool>
// cs_shoot <bool>

// _______________________________________________
//
// Drop ships (phantoms / pelicans)
// _______________________________________________


// Test cs_fly_to_and_face
script command_script cs_ds_gotoface

	// Exit script if AI is not a driver
	if (not (f_ai_is_driver (ai_current_actor))) then
		cs_run_command_script (ai_current_actor, cs_exit);
	end
	
	cs_vehicle_speed (1);
	cs_vehicle_boost (true);
	
	print ("Phantom Facing N");
	//cs_go_to_and_face (pts_gotoface.p0, pts_gotoface.n);
	cs_fly_to_and_face (pts_gotoface.p0, pts_gotoface.n);
	sleep (30 * 3);
	
	print ("Phantom Facing E");
	//cs_go_to_and_face (pts_gotoface.p0, pts_gotoface.e);
	cs_fly_to_and_face (pts_gotoface.p0, pts_gotoface.e);
	sleep (30 * 3);
	
	print ("Phantom Facing S");
	//cs_go_to_and_face (pts_gotoface.p0, pts_gotoface.s);
	cs_fly_to_and_face (pts_gotoface.p0, pts_gotoface.s);
	sleep (30 * 3);
	
	print ("Phantom Facing W");
	//cs_go_to_and_face (pts_gotoface.p0, pts_gotoface.w);
	cs_fly_to_and_face (pts_gotoface.p0, pts_gotoface.w);
end


// Test cs_face
script command_script cs_ds_face

	// Exit script if AI is not a driver
	if (not (f_ai_is_driver (ai_current_actor))) then
		cs_run_command_script (ai_current_actor, cs_exit);
	end

	cs_vehicle_speed (1);
	cs_vehicle_boost (true);

	print ("Phantom2 moving to face N");
	cs_fly_to (pts_gotoface.s);
	cs_face (true, pts_gotoface.n);
	sleep (30 * 6);

	print ("Phantom2 moving to face E");
	cs_fly_to (pts_gotoface.w);
	cs_face (true, pts_gotoface.e);
	sleep (30 * 6);

	print ("Phantom2 moving to face S");
	cs_fly_to (pts_gotoface.n);
	cs_face (true, pts_gotoface.s);
	sleep (30 * 6);

	print ("Phantom2 moving to face W");
	cs_fly_to (pts_gotoface.e);
	cs_face (true, pts_gotoface.w);
	sleep (30 * 6);
end

// If we don't have any dropships, clean up AI related to dropships
script continuous sc_ds_cleanup()

	if (ai_living_count (sq_ds_infcov) > 0 and ai_living_count (sq_ds_phantom) < 1) then
		ai_erase (sq_ds_infcov);
	end
	
	if (ai_living_count (sq_ds_infhum) > 0 and ai_living_count (sq_ds_pelican) < 1) then
		ai_erase (sq_ds_infhum);
	end
	
	if (ai_living_count (sq_ds_wraith) > 0 and ai_living_count (sq_ds_vehicledrop1) < 1) then
		ai_erase (sq_ds_wraith);
	end
	
	// Only really need to do this once per second
	sleep (30);
end


script continuous sc_endless_bloodbath()
	
	if(b_endless_bath) then
	
		if (ai_living_count (sq_bb_human) == 0) then
			ai_place (sq_bb_human);
		end
		
		if (ai_living_count (sq_bb_covenant) == 0) then
			ai_place (sq_bb_covenant);
		end
		
		if (ai_living_count (sq_bb_forerunner) == 0) then
			ai_place (sq_bb_forerunner);
		end
	
	end
	
	// Only really need to do this once per second
	sleep (30);
end


// Phantom Infantry load and drop off
script command_script cs_bvt_phantom
//	f_blip_ai_until_dead (sq_ds_phantom);

	// Place AI squad to pick up
	ai_place (sq_ds_infcov); 
	
	// Set vehicle speed to fast
	cs_vehicle_speed (1);
	
	// Open vehicle doors
	unit_open (ai_vehicle_get (ai_current_actor));
	
	// Fly to a point
	cs_fly_by (pts_phantom.p0);
	
	// Load all the AI infantry into the dropship
	vehicle_load_magic (ai_vehicle_get (sq_ds_phantom.driver), "phantom_pc_1", ai_get_unit (sq_ds_infcov.grunt));
	vehicle_load_magic (ai_vehicle_get (sq_ds_phantom.driver), "phantom_pc_2", ai_get_unit (sq_ds_infcov.jackal));
	vehicle_load_magic (ai_vehicle_get (sq_ds_phantom.driver), "phantom_pc_3", ai_get_unit (sq_ds_infcov.elite));

	// Fly around a bit
	cs_fly_by (pts_phantom.p1);
	cs_fly_by (pts_phantom.p2);
	cs_fly_by (pts_phantom.p3);
	cs_fly_by (pts_phantom.p4);
	
	//object_set_phantom_power (ai_vehicle_get (sq_ds_phantom.driver), true);
	
	// Unload all the AI from the dropship
	vehicle_unload ((ai_vehicle_get (sq_ds_phantom.driver)), "phantom_pc_1");
	vehicle_unload ((ai_vehicle_get (sq_ds_phantom.driver)), "phantom_pc_2");
	vehicle_unload ((ai_vehicle_get (sq_ds_phantom.driver)), "phantom_pc_3");
	sleep (30 * 2);
	
	// Close the dropship doors
	unit_close (ai_vehicle_get (ai_current_actor));
	
	// Fly Away
	cs_fly_by (pts_phantom.p5);
	
	// Erase the dropship and the infantry squads
	ai_erase (sq_ds_infcov);
	ai_erase (sq_ds_phantom);
end


// Pelican Infantry load and drop off
script command_script cs_bvt_pelican
//	f_blip_ai_until_dead (sq_ds_pelican.driver);
	ai_place (sq_ds_infhum); 
	cs_vehicle_speed (1);
	unit_open (ai_vehicle_get (ai_current_actor));
	cs_fly_by (pts_pelican.p0);
	vehicle_load_magic (ai_vehicle_get (sq_ds_pelican.driver), "pelican_p_r01", ai_get_unit (sq_ds_infhum.trooper));
	cs_fly_by (pts_pelican.p1);
	cs_fly_by (pts_pelican.p2);
	cs_fly_by (pts_pelican.p3);
	cs_fly_by (pts_pelican.p4);
	vehicle_unload ((ai_vehicle_get (sq_ds_pelican.driver)), "pelican_p_r01");
	sleep (30 * 4);
	unit_close (ai_vehicle_get (ai_current_actor));
	cs_fly_by (pts_pelican.p5);
	ai_erase (sq_ds_infhum);
	ai_erase (sq_ds_pelican);
end


// Phantom vehicle load and drop off
script command_script cs_bvt_wraithdrop
	ai_place (sq_ds_wraith);
	cs_vehicle_speed (1);
	cs_fly_by (pts_wraithdrop.p0);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_ds_vehicledrop1.driver), "phantom_lc", ai_vehicle_get_from_spawn_point (sq_ds_wraith.wraith));
	cs_fly_by (pts_wraithdrop.p1);
	cs_fly_by (pts_wraithdrop.p2);
	vehicle_unload ((ai_vehicle_get_from_spawn_point (sq_ds_vehicledrop1.driver)), "phantom_lc");
	sleep (30 * 4);
	cs_fly_by (pts_wraithdrop.p3);
	ai_erase (sq_ds_wraith);
	ai_erase (sq_ds_vehicledrop1);
end


// _______________________________________________
//
// Utility Scripts
// _______________________________________________

script command_script cs_exit
	print ("cs_exit called!");
	sleep (1);
end


// place AI
// ai_place (grav_lift_sq); 
// vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_01.driver), "phantom_pc_1", ai_get_unit (grav_lift_sq.grunt)); 
// vehicle_unload ((ai_vehicle_get_from_spawn_point (lakeside_phantom_01.driver)), "phantom_sc01");
// vehicle_load_magic (ai_vehicle_get_from_spawn_point (pelican_backup_01.driver), "pelican_e", ai_vehicle_get_from_starting_location  (marines_backup_01.hog_driver));
// vehicle_load_magic (ai_vehicle_get_from_spawn_point (pelican_backup_01.driver), "pelican_e", ai_vehicle_get_from_starting_location  (marines_backup_01.hog_gunner));
// vehicle_unload (ai_vehicle_get (pelican_backup_01.driver), "pelican_e");