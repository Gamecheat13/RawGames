
script static void ex1()
	//main cinematic script
	dprint("example 01");
	
	chud_show (FALSE);
	fade_in (0, 0, 0, 30);
	
	ai_erase (squads_0);
	ai_erase (squads_1);
	
	ai_place(squads_0);
	ai_place(squads_1);
	
	camera_control (TRUE);
	camera_fov = 50;
	camera_set (cam_01, 1);
	camera_pan (cam_01, cam_01_2, 90, 30, 1, 30, 1);
	//render_depth_of_field_enable (TRUE);
	//render_depth_of_field (5, 5, 1, 0);
	sleep_s (2.5);
	thread (story_blurb_add("vo", "MISSION VO: That Phantom is headed for the Med Station.  You need to take it out."));
	camera_set (cam_02, 1);
	camera_pan (cam_02, cam_02_2, 90, 30, 1, 30, 1);
	sleep_s (2.5);
	//render_depth_of_field (5, 40, 1, 5);
	camera_set (cam_03, 0);
	camera_pan (cam_03, cam_03_2, 90, 30, 1, 30, 1);
	sleep_s (4.0);
	fade_out (0, 0, 0, 60);
 

	sleep_s (6.0);
	camera_fov = 90;
	fade_in (0, 0, 0, 1);
	camera_control (FALSE);
	
end

//script command_script cs_01()
////cs_aim(TRUE, group_cin_1);
//cs_custom_animation(objects\characters\storm_marine\storm_marine.model_animation_graph,"global_injured:unarmed:chest_ground:var1", TRUE );
//
//end
//
//script command_script cs_02()
////cs_aim(TRUE, group_cin_1);
//cs_custom_animation(objects\characters\storm_marine\storm_marine.model_animation_graph,"global_scanning:unarmed:idle", TRUE );
//
//end
//
//script command_script cs_03()
////cs_aim(TRUE, group_cin_1);
//cs_custom_animation(objects\characters\storm_marine\storm_marine.model_animation_graph,"global_typing:idle", TRUE );
//
//end
//

script command_script cs_04()
//cs_aim(TRUE, group_cin_1);
cs_fly_to(group_cin_1.p0);
//cs_fly_to(group_cin_1.p1);
//cs_fly_to(group_cin_1.p2);

end