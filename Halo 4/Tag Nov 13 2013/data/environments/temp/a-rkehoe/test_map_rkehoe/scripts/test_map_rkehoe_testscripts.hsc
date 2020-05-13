
global boolean b_endless_bath = FALSE;
//global boolean b_donut_left_door_button_hit = FALSE;

// Run our "start" script
script startup su_test_startup()	
	start();
	//sc_test_birthers();

end

//========================================================================
//========================================================================
//=========================== Wake Up Scripts ============================
//========================================================================
//========================================================================
script static void start()
	// Wake dormant scripts
	print ("Press the Button to get out of the room.");
	wake (wtf);
	wake (press_button);
	wake (cs_pawn_spawn);
	wake (objective_blip);
	wake (open_door);
	wake (open_door1);
	wake (open_door2);
	//wake (title);
end

script static void sc_test_birthers()
	ai_place (sq_bishop);
	print ("Pawn spawn birthing.");
	sleep_until(ai_living_count (sq_pawns) > 2, 15);
	ai_erase (sq_bishop);
	print("Say goodbye to the Bishop.");
	
end

// CS for pawns that need to be spawned from a pawn-spawner
script dormant cs_pawn_spawn
	print("Pawns are ready to be spawned from the Bishop");
	ai_place_with_shards(sq_pawns);
	//sleep (30 * 2);
	ai_erase (sq_bishop);
	//ai_enter_limbo(ai_current_actor);
	//CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_pawn, 1.5);

end


//========================================================================
//========================================================================
//========================Drop ship =================================
//========================================================================
//========================================================================
script dormant wtf()
	sleep_until (volume_test_players (location_wtf), 1);
	ai_place (fly);
	f_unblip_flag (blip_test2);
end	

script command_script cs_bvt_phantom

	 f_load_phantom (fly, "left", fly_pick_up, none, none, none);
	
	// Fly to a point
	cs_fly_by (pts_phantom.p0);

	// Fly to a point
	cs_fly_by (pts_phantom.p1);
	
	// Load all the AI infantry into the dropship
	//vehicle_load_magic (ai_vehicle_get (fly.driver), "phantom_pc_1", ai_get_unit (fly_pick_up.grunt1));
	//vehicle_load_magic (ai_vehicle_get (fly.driver), "phantom_pc_2", ai_get_unit (fly_pick_up.grunt2));
	//vehicle_load_magic (ai_vehicle_get (fly.driver), "phantom_pc_3", ai_get_unit (fly_pick_up.grunt3));
	
	// Fly to a point
	cs_fly_by (pts_phantom.p2);
	
	sleep (30 * 2);
	
	cs_fly_by (pts_phantom.p3);
	
	// Unload all the AI from the dropship
	f_unload_phantom (fly, left);
	cs_fly_by (pts_phantom.p4);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 300 ); //Shrink size over time
	ai_erase (fly);

	sleep (30 * 2);
	
end

//========================================================================
//========================================================================
//=======================Device Control Buttons===========================
//========================================================================
//========================================================================
script dormant objective_blip()
	f_blip_flag (blip_test, "activate");
	f_blip_flag (blip_test2, "neutralize_a");
	sleep_until (device_get_position (button01) > 0, 1);
	print ("Device Activated");
	f_unblip_flag (blip_test);
	sc_test_birthers();
	//wake (cs_pawn_spawn);
end
	
script dormant press_button()
	print ("The Button is awake, Now Press it!");
	device_set_power (button01, 1);
	sleep_until (device_get_position (button01) > 0, 1);
	print ("User has activated the Device!");
	wake (title);
	//f_blip_flag (blip_test, "default");
	//ai_place (def_warthog);
end

//Chapter titles
//Set the text color to: 151, 222, 252
//Justification: Top, Vertical Justification: Top, Font: Title Font 
script dormant title()
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	cinematic_set_title (bvt_string);
	hud_stop_global_animtion (screen_fade_out);
	sleep (30 * 5);	
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);

end

//========================================================================
//========================================================================
//Scripts to open the device_machine doors
//========================================================================
//========================================================================
script dormant open_door()
	device_set_power (button01, 1);
	sleep_until (device_get_position (button01) > 0, 1);
	door_machine->open();
	//door_machine1->open();
	sleep (30 * 9); 
	door_machine->close();
end

script dormant open_door1()
	device_set_power (button01, 1);
	sleep_until (device_get_position (button01) > 0, 1);
	door_machine1->open();
	sleep (30 * 9); 
	door_machine1->close();
end

script dormant open_door2()
	device_set_power (button01, 1);
	sleep_until (device_get_position (button01) > 0, 1);
	door_machine2->open();
	sleep (30 * 9); 
	door_machine2->close();
end