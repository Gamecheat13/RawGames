//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m40_invasion
//	Insertion Points:	start (or ica)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================
script startup m40_invasion()
	wake (qbr_main_script);

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

	
//	if b_debug then 
//		print_difficulty(); 
//	end
//	
//	if b_debug then 
//		print ("::: M40 - INVASION :::");
//	end
//	
//	f_loadout_set ("default");
//	

//
	// ============================================================================================
	// STARTING THE GAME

	// ============================================================================================
	
//	if (b_game_emulate or ((b_editor != 1) and (player_count() > 0))) then
//		// if true, start the game
//		start();
//		// else just fade in, we're in edit mode
//	elseif b_debug then
				print (":::  QBR SCENARIO  :::");
//				fade_in (0, 0, 0, 0);
//	end
//	
end

// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================


// =================================================================================================
// =================================================================================================
// CAVERN
// =================================================================================================
// =================================================================================================

script dormant qbr_main_script()
	object_create (qbr_tort_hog_01);
	object_create (qbr_tort_hog_02);
	object_create (qbr_gauss_turret_01);		
	object_create (qbr_gauss_turret_02);
	object_create (qbr_gauss_turret_03);
	object_create (qbr_gauss_turret_04);
//	ai_place (qbr_marines_hog_02);
	print  ("AI/objects spawned");
end

script static void rs_hog()
//	ins_chopper();
	print  ("hog driving scripts running");
	ai_place (qbr_marines_hog_01);
//	cs_run_command_script (qbr_marines_hog_01, qbr_marines_hog_01_cs);
//	cs_run_command_script (qbr_marines_hog_02, qbr_marines_hog_02_cs);
end

script static void rs_turret()
//	ins_chopper();
	print  ("turret scripts running");
	ai_place (qbr_marines_gauss_01);
	ai_vehicle_enter_immediate (qbr_marines_gauss_01, qbr_gauss_turret_01);
	cs_run_command_script (qbr_marines_gauss_01, qbr_marines_gauss_01_cs);
//	cs_run_command_script (qbr_marines_hog_02, qbr_marines_hog_02_cs);
end

script static void rs_scale()
//	ins_chopper();
	print  ("scale actions running");
	ai_place (qbr_marines_hog_03);
	object_create (qbr_tort_hog_03);
//	cs_run_command_script (qbr_marines_hog_02, qbr_marines_hog_02_cs);
end


script command_script qbr_marines_hog_01_cs()
	cs_go_to (qbr_pts.p0);
	print  ("marines trying to go to");
end

script command_script qbr_marines_hog_02_cs()
	cs_go_to (qbr_pts.p1);
	print  ("marines 2 trying to go to");
end

script command_script qbr_marines_gauss_01_cs()
	repeat
//		cs_shoot_point (true, qbr_pts.p2);
//		cs_shoot_point (true, qbr_pts.p3);
		cs_shoot_point (true, qbr_pts.p4);
//		cs_shoot_point (true, qbr_pts.p5);
	until (1 == 0);
		print  ("gauss marine is firing");
end
