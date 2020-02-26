// ===============================================================================================================================================
// PERF TESTING SCRIPTS ==========================================================================================================================
// ===============================================================================================================================================

//global cutscene_camera_point testpoints;


script static void gotocampoint(cutscene_camera_point pt, string nm)
	camera_set (pt, 180);
	sleep (210);
	print ( nm );
	sleep (60);
end

script static void camera_flyby
	print ("Start flyby");

	player_camera_control (false);
	player_enable_input (FALSE);
	camera_control (true);

	gotocampoint (test1, "test1");
	gotocampoint (test2, "test2");
	gotocampoint (test3, "test3");
	gotocampoint (test4, "test4");
	gotocampoint (test5, "test5");
	gotocampoint (test6, "test6");
	gotocampoint (test7, "test7");
	gotocampoint (test8, "test8");

	camera_control (false);
	player_camera_control (true);
	player_enable_input (true);

	print ("Flyby complete");
end
