//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice
//	Insertion Points:	crash
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


script startup m90_arcade()		
	
	
	sleep_until( volume_test_players( tv_arcade_starter ),5 );
	//wake( f_arcade_starter );
	wake (f_arcade_controller);

end

script dormant f_arcade_controller()
	sleep_until ( volume_test_players( tv_start_door ), 1 );
	print("arcade spawn startup");
	ai_place (sg_arcade_1);
	
	sleep_until ( volume_test_players( tv_arcade_door_1 ), 1 );
	print("arcade door 1");
	ai_place (sg_arcade_2);
	game_save();
	device_set_position (arcade_door_1, 1);


	
	sleep_until ( volume_test_players( tv_arcade_door_2 ), 1 );
	print("arcade door 2");
	game_save();
	ai_place (sg_arcade_3);
	ai_place (sg_arcade_4);
	device_set_position (arcade_door_2, 1);
	
	wake (f_jump_save);
	
	sleep_until ( volume_test_players( tv_hallway_save ), 1 );
	game_save();
	
end

script dormant f_jump_save()
	sleep_until ( volume_test_players( tv_jump_save), 1 );
	
	print("I'll save you");
	
	cheat_deathless_player = 1;
	
	
	sleep_until ( volume_test_players( tv_jump_save_end), 1 );
	cheat_deathless_player = 0;
		print("I will no longer save you");
end

script dormant f_temp()
	print("I'll pawn you");
	//object_create (pawn_1);
	//object_move_by_offset (pawn_1, 10, 0, -10, 0);

end


// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================
