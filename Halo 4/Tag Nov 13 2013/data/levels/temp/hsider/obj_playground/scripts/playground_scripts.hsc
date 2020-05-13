
	
script command_script run_crates()

	repeat
		print("Point 0");
		cs_go_to(cratewalk.p0);
		print("Point 1");
		cs_go_to(cratewalk.p1);
		print("Point 2");
		cs_go_to(cratewalk.p2);
		print("Point 3");
		cs_go_to(cratewalk.p3);
		print("back...");
	until(false);
end

script static void fly_you_fools()
		ai_flee_target(civ,player_get_first_alive());
end

//script static void blipit(string_id name)
//	navpoint_track_object(itm,true);
//	/navpoint_track_object_named(itm,name);
//end