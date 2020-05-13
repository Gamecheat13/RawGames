//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash
//	Insertion Points:	start (or icr)	- Beginning
//										ila							- Lab / Armory
//										iob							- Observation Deck
//										ifl							- Flank / Prep Room
//										ibe							- Beacon
//										ibr							- Broken Floor
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================


// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script static void fuck()
	print ("fuck");

	// unit_open(ass);

	// custom_animation_hold_last_frame (ass, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false); 


	// ai_place_in_limbo(squads_0);

	// object_create_anew(asshole);

	// ai_exit_limbo(squads_0);

	ai_vehicle_enter(squads_0, ass);
	// ai_vehicle_enter_immediate(squads_0, asshole, phantom_d);

	// ai_place (squads_1);
	// dprint ("wraith is spawned");
	//sleep (30 * 2);
	//vehicle_load_magic (ai_vehicle_get_from_spawn_point (squads_0.driver), "phantom_lc", ai_vehicle_get_from_squad (squads_1, 0)); 
	
	// ai_place(squads_1);
	// ai_vehicle_enter(squads_0, hog);
	print ("shit");
end

script startup test_platforms()
		print("le fuck");
end

script command_script cs_test_platforms_ai()
                object_set_gravity( ai_get_object(ai_current_actor), 0.4, FALSE );
end

script command_script cs_flyguy()

	// ai_vehicle_enter(squads_0, asshole, banshee_d);
	//ai_place (squads_1);
	//dprint ("wraith is spawned");
	// sleep (30 * 2);
	//vehicle_load_magic (ai_vehicle_get_from_spawn_point (squads_0.driver), "phantom_lc", ai_vehicle_get_from_squad (squads_1, 0)); 

	cs_fly_to (mtest.p0);
	
	// ai_place(squads_1);
	// ai_vehicle_enter(squads_0, hog);
	print ("flyguy done");

		
//		print(">>> p0");
//                cs_fly_by (mtest.p0);
//		print("<<< p0");

		// print("flew to");
end

script command_script cs_direct()
		print("fuck you fuckball");

		ai_path_ignore_object_obstacle(squads_0, ass);
                cs_go_to (mtest.p0);
		print("went to");
                cs_go_to (mtest.p1);
		print("went to");
end
