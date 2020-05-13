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



script startup f_test_turret_spawn
	ai_place (my_lich_sq);
//	ai_vehicle_enter_immediate (my_lich_sq.guy1, lichy, "pelican_p_l05");
	
	print ("lich squad placed");

end

script static void my_lich_grav()
                repeat
                                print ("GRAV LIFT GOING UP");
                                lichy->grav_lift_down_active (false);
                                lichy->grav_lift_up_active (true);
                                sleep_s (10);
                                print ("GRAV LIFT GOING DOWN");
                                lichy->grav_lift_up_active (false);
                                lichy->grav_lift_down_active (true);
                                sleep_s (10);
								until (1 == 0);
end
script static void my_lich_explode()
                sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) == 0.0);
                effect_new_on_object_marker( objects\vehicles\covenant\storm_lich\fx\lich_explosion\main_explosion.effect, lichy, "power_core" );
end

script static void my_lich_fly()
	repeat
		cs_fly_by (my_lich_sq, true, my_lich_pt.p0);
		cs_fly_by (my_lich_sq, true, my_lich_pt.p1);
		cs_fly_by (my_lich_sq, true, my_lich_pt.p2);
	until (1 == 0);
		end
