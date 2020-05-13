/// VARS
//global boolean b_endless_bath = FALSE;

// Run our "start" script
script startup su_test_startup()	
	print ("Mission has loaded.");
	start();

end

//==================================================================
//===================    Start the Dormat Scripts===================
//==================================================================

script static void start()
	// Wake dormant scripts
	wake (phantom1);
	print ("Get the party started");
	//wake (phantom1);
	//wake (sc_test_birthers);
end

script dormant phantom1
	sleep_until (volume_test_players (trigger_start), 1);
	print ("Place the flyer 1!"); 
	ai_place (phantom_1_flyer);
	ai_place (phantom_2_flyer);
	//phantom1_flight;
	//cs_fly_by (ph_1_pts.p0);
end

script dormant phantom3
	sleep (30 * 11);
	print ("Place the colliding drop ships!!!"); 
	ai_place (phantom_3_flyer);
	sleep (30 * 15);
	damage_object (unit_get_vehicle(phantom_3_flyer.splode), engine_right, 10000);
	damage_object (unit_get_vehicle(phantom_3_flyer.splode), engine_left, 10000);
	damage_object (unit_get_vehicle(phantom_3_flyer.splode), hull, 10000);

end

script dormant pelican1
	print ("Why isn't this blowing up"); 
	ai_place (hm_drop_1);
	sleep (30 * 1);
	//ai_erase (hm_drop_1);
end

script command_script phantom1_flight
	print ("hover over point1");
	wake (phantom3);
	cs_fly_to (ph_1_pts.p0);
	sleep (30 * 5);
	cs_fly_to (ph_1_pts.p1);
	//sleep (30 * 7);
	cs_fly_to (ph_1_pts.p2);
	sleep (30 * 7);
	damage_object (unit_get_vehicle(ai_current_actor), engine_right, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), engine_left, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), hull, 10000);
	//wake (phantom3);
	wake (pelican1);
end

script command_script phantom2_flight
	print ("hover over point1");
	cs_fly_by (ph_2_pts.p0);
	cs_fly_by (ph_2_pts.p1);
	cs_fly_to (ph_2_pts.p2);
	sleep (30 * 9);
	cs_fly_by (ph_2_pts.p3);
	cs_fly_to (ph_2_pts.p4);
end

script command_script phantom3_flight
	print ("Ship 1 of Flyer is going to go collide!!!!");
	cs_vehicle_speed_instantaneous (50*5);
	cs_fly_to (ph_3_pts.p2);
	//sleep (1);
	//damage_object (unit_get_vehicle(ai_current_actor), engine_right, 10000);
	//damage_object (unit_get_vehicle(ai_current_actor), engine_left, 10000);
	//damage_object (unit_get_vehicle(ai_current_actor), hull, 10000);

end

script command_script pelican1_flight
	print ("Why isn't it blowing up?!!!!");
	cs_vehicle_speed_instantaneous (50*5);
	cs_fly_by (pl_1_pts.p1);
	//sleep (1);
end