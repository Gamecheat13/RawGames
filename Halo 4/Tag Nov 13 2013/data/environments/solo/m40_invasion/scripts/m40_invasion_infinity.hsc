//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m40_invasion_infinity
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================
global short s_infinity_progress = 0;
global boolean b_infinity_at_ordnance = false;
global boolean b_infinity_at_epic = false;
global boolean b_infinity_at_epic_end = false;
// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

/*
script static void uuu()
	object_move_to_point (infinity, 10, pts_infinity_path.p0);
end

script static void m40_infinity_main()
	print ("inf");
		
	thread (f_track_infinity_movement());	
	sleep_s(3);	
	object_create (infinity);
	//sleep(1);
	object_set_scale ( infinity, 0.01, 0 );
	//
	print ("infinity, 0.01, 0 ");
	object_set_scale ( infinity, 0.5, 7 * 30 );
	print ("infinity, 0.5, 7 * 30, sleeping 30");
	sleep(30);
	object_set_scale ( infinity, 1.0, 13 * 30 );
	print ("infinity, 1.0, 13 * 30");
	wake( m40_ord_epic_flock_controller );
	//object_set_scale (infinity, 0.01, 0);
	//object_set_scale (infinity, 1, 5);
	sleep_until (volume_test_players (tv_ord_spawn_infinity), 1);
		wake(f_smooth_inf_turn);
		object_move_to_point (infinity, 20, pts_infinity_path.p0);
		
		thread (rotate_xyz(infinity, 5,5,5, -5,0,0));
		object_move_to_point (infinity, 8, pts_infinity_path.p0_fullstop);
		//p0_fullstop
		dprint("inf prog = 5");
		s_infinity_progress = 5;
		
		sleep_until( (b_ord_moveout and b_ord_hog_2_dropped ) or s_objcon_ord >= 10, 1);	
			thread (rotate_xyz(infinity, 35,35,35, -150,0,0));
			object_move_to_point (infinity, 20, pts_infinity_path.p2);
			s_infinity_progress = 8;
			thread(f_inf_create_guns());
			object_move_to_point (infinity, 15, pts_infinity_path.p3);
			b_infinity_at_ordnance = true;
		sleep_until(s_infinity_progress == 10, 1);	
			b_fire_ordnance_training = false;
			
			if ai_living_count(sq_cov_ord_wraith_leader.general) > 0 then
				sleep_s(18);
			else
				sleep_s(5);
			end
			b_infinity_at_ordnance = false;
			thread (rotate_xyz(infinity, 45,45,45, -90,0,0));
			object_move_to_point (infinity, 45, pts_infinity_path.p5);
			b_infinity_at_epic = true;
		sleep_until(s_infinity_progress == 20, 1);			
			object_move_to_point (infinity, 15, pts_infinity_path.p6);	
			b_infinity_at_epic = false;
			b_infinity_at_epic_end = true;
end

script dormant f_smooth_inf_turn()
	dprint("f_smooth_inf_turn");
	sleep_s(2);
	thread(camera_shake_all_coop_players ( 0.3, 0.11, 9, 2));
	sleep_s(8);
	dprint("s_infinity_progress = 3");
	s_infinity_progress = 3;
	thread(camera_shake_all_coop_players ( 0.5, 0.33, 10, 5));
	thread (rotate_xyz(infinity, 10,10,10, -10,0,0));
	
end

script static void f_track_infinity_movement()
	sleep_until(volume_test_players(tv_infinity_moveup_1) or s_objcon_ord >= 50, 1);
		s_infinity_progress = 10;
		
	sleep_until(volume_test_players(tv_infinity_moveup_2), 1);
		s_infinity_progress = 20;
end


script static void rotate_xyz(object obj, real yaw_time, real pitch_time, real roll_time, real yaw_degrees, real pitch_degrees, real roll_degrees)
	object_rotate_by_offset (obj, yaw_time,pitch_time,roll_time, yaw_degrees,pitch_degrees,roll_degrees);
end


script dormant m40_ord_epic_flock_controller()


	
	sleep_until( s_infinity_progress >= 3 , 1 );
		flock_create(flocks_inf_falcons);
 	sleep_until( s_infinity_progress >= 8 , 1 );
		flock_destroy(flocks_inf_falcons);
		flock_create(flocks_ord_falcons);
		flock_create(flocks_ord_banshees);
 	sleep_until( s_infinity_progress >= 10 , 1 );
 		flock_destroy(flocks_ord_falcons);
 		flock_destroy(flocks_ord_banshees);
	 	flock_create(flocks_epic_falcons);
	 	flock_create(flocks_epic_banshee);
	 	flock_create(flocks_epic_phantoms);
	 	flock_create(flocks_epic_phantoms_far);

end

script static void f_inf_create_guns()
	ai_place(infinity_guns);
	sleep(1);
	objects_attach(infinity, "m_gun_mid_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_1), "" );
	objects_attach(infinity, "m_gun_mid_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_2), "" );
	objects_attach(infinity, "m_gun_mid_rear_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_3), "" );
	objects_attach(infinity, "m_gun_mid_rear_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_4), "" );
	objects_attach(infinity, "m_gun_fore_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_5), "" );
	objects_attach(infinity, "m_gun_fore_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_6), "" );
	objects_attach(infinity, "m_gun_aft_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_7), "" );
	objects_attach(infinity, "m_gun_aft_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_8), "" );
	dprint("attached infinity guns");
	sleep(10);
	load_inf_gunners();
end



script static void load_inf_gunners()


       //ai_place(biggun);
       //sleep(5);
       ai_place (inf_gunners);
       //(ai_place sq_sky_frigate01_left_gunners)
       ai_cannot_die (inf_gunners, TRUE);
       //(ai_cannot_die sq_sky_frigate01_left_gunners TRUE)
       
       //ai_set_clump (sq_sky_frigate01_right_gunners, 1);

       //ai_designer_clump_perception_range (600);
       
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_1), "", ai_get_unit (inf_gunners.gunner_1));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_2), "", ai_get_unit (inf_gunners.gunner_2));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_3), "", ai_get_unit (inf_gunners.gunner_3));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_4), "", ai_get_unit (inf_gunners.gunner_4));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_5), "", ai_get_unit (inf_gunners.gunner_5));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_6), "", ai_get_unit (inf_gunners.gunner_6));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_7), "", ai_get_unit (inf_gunners.gunner_7));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_8), "", ai_get_unit (inf_gunners.gunner_8));
       //vehicle_load_magic (object_at_marker dm_sky_frigate01b "turret_right_bottom02") "" (ai_get_object sq_sky_frigate01_right_gunners/bottom02))
       //(vehicle_load_magic (object_at_marker dm_sky_frigate01b "turret_left_bottom01") "" (ai_get_object sq_sky_frigate01_left_gunners/bottom01))
       //(vehicle_load_magic (object_at_marker dm_sky_frigate01b "turret_left_bottom02") "" (ai_get_object sq_sky_frigate01_left_gunners/bottom02))
end

global boolean b_fire_ordnance_training = true;

script command_script cs_ord_inf_gun()
	
	
	repeat
		begin_random
			begin
				cs_shoot_point(true, pts_ord_infinity_fire.p1);
				sleep_rand_s(1.0,2);
				cs_shoot_point(false, pts_ord_infinity_fire.p1);
			end
		
			begin
				if b_fire_ordnance_training then
					cs_shoot_point(true, pts_ord_infinity_fire.p0);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.p0);
				end
			end
		
			begin
				cs_shoot_point(true, pts_ord_infinity_fire.p2);
				sleep_rand_s(1.0,2);
				cs_shoot_point(false, pts_ord_infinity_fire.p2);
			end
			
			begin
				if b_fire_ordnance_training then
					cs_shoot_point(true, pts_ord_infinity_fire.p3);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.p3);
				end
			end
		
			begin
				cs_shoot_point(true, pts_ord_infinity_fire.p4);
				sleep_rand_s(1.0,2);
				cs_shoot_point(false, pts_ord_infinity_fire.p4);
			end
		
			begin
				if b_fire_ordnance_training then
					cs_shoot_point(true, pts_ord_infinity_fire.p5);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.p5);
				end
			end

			begin
				cs_shoot_point(true, pts_ord_infinity_fire.p6);
				sleep_rand_s(1.0,2);
				cs_shoot_point(false, pts_ord_infinity_fire.p6);
			end
		
			begin
				if b_fire_ordnance_training then
					cs_shoot_point(true, pts_ord_infinity_fire.p7);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.p7);
				end
			end
			
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget);
				end			
		end

	until(b_fire_ordnance_training == false);
	

		if ai_living_count(sq_cov_ord_wraith_leader.general) > 0 then
			begin_random
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget);
					sleep_rand_s(1.5,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget);
				end
				
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget4);
					sleep_rand_s(1.5,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget4);
				end
				
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget2);
					sleep_rand_s(1.5,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget2);
				end
				
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget3);
					sleep_rand_s(1.5,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget3);
				end
				
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget4);
					sleep_rand_s(1.5,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget4);
				end
				
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget2);		
					sleep_rand_s(1.5,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget2);
				end
				
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pMainTarget);
					sleep_rand_s(1,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pMainTarget);
				end
			
			
			end //end random
			
			if ai_living_count(sq_cov_ord_wraith_leader.general) > 0 then			
				
				f_kill_leader_ord();
			end
		
		end // end of living
		
		
	sleep_until(b_infinity_at_epic == true);		
		repeat
			begin_random
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pe1);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pe1);
				end
			
				begin
						cs_shoot_point(true, pts_ord_infinity_fire.pe0);
						sleep_rand_s(1.0,2);
						cs_shoot_point(false, pts_ord_infinity_fire.pe0);
				end
			
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pe2);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pe2);
				end
				
				begin
						cs_shoot_point(true, pts_ord_infinity_fire.pe3);
						sleep_rand_s(1.0,2);
						cs_shoot_point(false, pts_ord_infinity_fire.pe3);
				end
			
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pe4);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pe4);
				end
			
				begin
						cs_shoot_point(true, pts_ord_infinity_fire.pe5);
						sleep_rand_s(1.0,2);
						cs_shoot_point(false, pts_ord_infinity_fire.pe5);
				end
	
				begin
					cs_shoot_point(true, pts_ord_infinity_fire.pe6);
					sleep_rand_s(1.0,2);
					cs_shoot_point(false, pts_ord_infinity_fire.pe6);
				end
			
				begin
						cs_shoot_point(true, pts_ord_infinity_fire.pe7);
						sleep_rand_s(1.0,2);
						cs_shoot_point(false, pts_ord_infinity_fire.pe7);
				end
			end
	
		until( b_infinity_at_epic_end == true );		
		
end

//
*/


