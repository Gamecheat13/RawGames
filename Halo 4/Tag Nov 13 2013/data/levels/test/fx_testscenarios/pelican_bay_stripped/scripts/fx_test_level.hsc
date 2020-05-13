//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					fx test level
//	Insertion Points:
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

//global ai chop_tortoise = NONE;

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

//script startup m40_invasion()
//		
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
//	if b_encounters then
//		wake (diff_vehicle_health);
//	end
//
//	// ============================================================================================
//	// STARTING THE GAME
//
//	// ============================================================================================
//	if (b_game_emulate or ((b_editor != 1) and (player_count() > 0))) then
//		// if true, start the game
//		start();
//		// else just fade in, we're in edit mode
//	elseif b_debug then
//				print (":::  editor mode  :::");
//				fade_in (0, 0, 0, 0);
//	end
//	
//end

// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

//script static void start()
//	// Figure out what insertion point to use
//	// Set these in init.txt or editor_init.txt to work on various areas quickly
//	if (game_insertion_point_get() == 0) then
//		ins_cavern();
//	elseif (game_insertion_point_get() == 1) then
//		ins_fodder();
//	elseif (game_insertion_point_get() == 2) then
//		ins_lakeside();
//	elseif (game_insertion_point_get() == 12) then
//		ins_cliffside();
//	elseif (game_insertion_point_get() == 3) then
//		ins_prechopper();
//	elseif (game_insertion_point_get() == 4) then
//		ins_chopper();
//	elseif (game_insertion_point_get() == 11) then
//		ins_waterfall();
//	elseif (game_insertion_point_get() == 5) then
//		ins_jackal();
//	elseif (game_insertion_point_get() == 6) then
//		ins_citadel();
//	elseif (game_insertion_point_get() == 7) then
//		ins_powercave();
//	elseif (game_insertion_point_get() == 8) then
//		ins_librarian();
//	elseif (game_insertion_point_get() == 9) then
//		ins_ordnance();
//	elseif (game_insertion_point_get() == 10) then
//		ins_epic();
//	end
//end

// =================================================================================================
// =================================================================================================
// CAVERN
// =================================================================================================
// =================================================================================================

script static void tort_test_doors()
	object_set_physics (test_mammoth_01, true);
	sleep (30 * 1);
	custom_animation_hold_last_frame (test_mammoth_01, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);
	sleep (30 * 7.5);
	print ("front door effects");
	effect_new_on_object_marker (objects\vehicles\human\storm_mammoth\fx\moving_parts\outrig_contact.effect, test_mammoth_01, "fx_front_bay_door");
	effect_new_on_object_marker (objects\vehicles\human\storm_mammoth\fx\moving_parts\baydoor_contact.effect, test_mammoth_01, "fx_l_f_outrig_clamp"); 
	effect_new_on_object_marker (objects\vehicles\human\storm_mammoth\fx\moving_parts\outrig_contact.effect, test_mammoth_01, "fx_l_b_outrig_clamp"); 
	effect_new_on_object_marker (objects\vehicles\human\storm_mammoth\fx\moving_parts\baydoor_contact.effect, test_mammoth_01, "fx_r_f_outrig_clamp"); 
	effect_new_on_object_marker (objects\vehicles\human\storm_mammoth\fx\moving_parts\outrig_contact.effect, test_mammoth_01, "fx_r_b_outrig_clamp"); 
	sleep (30 * 2.5);	
	effect_new_on_object_marker (objects\vehicles\human\storm_mammoth\fx\moving_parts\baydoor_contact.effect, test_mammoth_01, "fx_rear_bay_door");
	print ("rear door effects"); 
//	effect_new_at_ai_point (	environments\solo\m40_invasion\fx\rockwall_burst\rockwall_burst.effect, cav_pelican_dies_pt.p18);
end

script static void tort_test_doors_2()
	object_set_physics (test_mammoth_01, true);
	sleep (30 * 1);
	custom_animation_hold_last_frame (test_mammoth_01, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);
	sleep (30 * 7.5);
	print ("door effects");
	effect_new_at_ai_point (objects\vehicles\human\storm_mammoth\fx\moving_parts\baydoor_contact.effect, fx_marker_sp.p0);
	effect_new_at_ai_point (objects\vehicles\human\storm_mammoth\fx\moving_parts\outrig_contact.effect, fx_marker_sp.p1);
//	effect_new_at_ai_point (	environments\solo\m40_invasion\fx\rockwall_burst\rockwall_burst.effect, cav_pelican_dies_pt.p18);
end

//
//e:\corinth\midnight\main\tags\objects\vehicles\human\storm_mammoth\fx\moving_parts\baydoor_contact.effect
//e:\corinth\midnight\main\tags\objects\vehicles\human\storm_mammoth\fx\moving_parts\outrig_contact.effect
//
//fx_rear_bay_door
//fx_front_bay_door
//fx_l_f_outrig_clamp
//fx_l_b_outrig_clamp
//fx_r_f_outrig_clamp
//fx_r_b_outrig_clamp
