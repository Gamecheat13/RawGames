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


/*
script static void test_rev()
	ai_place (elite);
	//ai_vehicle_enter_immediate (rev_elite_01, revenant_01, "revenant_d");
	//ai_vehicle_enter_immediate (grunt, revenant_01, "wraith_g");	
	ai_braindead (elite, true);
end
*/

script static void test_cruiser()

	ai_place (gunners);
	print( "go!" );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_a" ), "", ai_get_object( gunners.spawn_points_0 ) );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_b" ), "", ai_get_object( gunners.spawn_points_1 ) );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_c" ), "", ai_get_object( gunners.spawn_points_2 ) );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_d" ), "", ai_get_object( gunners.spawn_points_3 ) );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_e" ), "", ai_get_object( gunners.spawn_points_4 ) );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_f" ), "", ai_get_object( gunners.spawn_points_5 ) );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_g" ), "", ai_get_object( gunners.spawn_points_6 ) );
	vehicle_load_magic( object_at_marker( turret_cruiser, "cruiser_turret_h" ), "", ai_get_object( gunners.spawn_points_7 ) );

end
