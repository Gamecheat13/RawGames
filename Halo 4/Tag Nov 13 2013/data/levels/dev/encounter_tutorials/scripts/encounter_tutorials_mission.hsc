script command_script cs_phase_test
	cs_phase_to_point (ps_phase.p0);
	cs_pause (0.5);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	sleep_until ((unit_get_shield (ai_current_actor) < 0.5), 1);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	cs_run_command_script (ai_current_actor, cs_knight_sideline_fight);
end

script command_script cs_knight_sideline_fight
	cs_phase_to_point (ps_phase.p1);
end 

script command_script cs_shoot_test
	print("shoot test start.");
	cs_shoot_point(true, ps_shoot.p0);
	sleep(300);
	print("shoot test end.");
end

//----------------------------
//		Locomotion Tests
//----------------------------

global boolean g_loc_strafe_walk = false;
global boolean g_loc_strafe_crouch = false;

script command_script cs_locomotion_strafe_1
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		cs_go_to(ps_locomotion_strafe.p0);
		cs_go_to(ps_locomotion_strafe.p1);
		cs_go_to(ps_locomotion_strafe.p0);
		cs_go_to(ps_locomotion_strafe.p1);
		cs_go_to(ps_locomotion_strafe.p0);
		cs_go_to(ps_locomotion_strafe.p1);
	until (false);	//	Adds delay for some reason.
end

script command_script cs_locomotion_strafe_2
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		cs_go_to(ps_locomotion_strafe.p2);
		cs_go_to(ps_locomotion_strafe.p3);
		cs_go_to(ps_locomotion_strafe.p2);
		cs_go_to(ps_locomotion_strafe.p3);
		cs_go_to(ps_locomotion_strafe.p2);
		cs_go_to(ps_locomotion_strafe.p3);
	until (false);	//	Adds delay for some reason.
end

script command_script cs_locomotion_strafe_3
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		//	Forwards
		cs_go_to(ps_locomotion_strafe.p5);
		cs_go_to(ps_locomotion_strafe.p6);
		cs_go_to(ps_locomotion_strafe.p7);
		cs_go_to(ps_locomotion_strafe.p8);
		cs_go_to(ps_locomotion_strafe.p9);
		cs_go_to(ps_locomotion_strafe.p10);
		cs_go_to(ps_locomotion_strafe.p11);
		
		//	And backwards
		cs_go_to(ps_locomotion_strafe.p11);
		cs_go_to(ps_locomotion_strafe.p10);
		cs_go_to(ps_locomotion_strafe.p9);
		cs_go_to(ps_locomotion_strafe.p8);
		cs_go_to(ps_locomotion_strafe.p7);
		cs_go_to(ps_locomotion_strafe.p6);
		cs_go_to(ps_locomotion_strafe.p5);
	until (false);
end


//----------------------------
//		Avoidance Tests
//----------------------------

global long g_avoid_sync_ref_count = 0;

script command_script cs_locomotion_avoid_1b
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p0);
		cs_go_to(ps_locomotion_avoid.p1);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_2b
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p2);
		cs_go_to(ps_locomotion_avoid.p7);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_3b
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p4);
		cs_go_to(ps_locomotion_avoid.p5);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_4b
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p6);
		cs_go_to(ps_locomotion_avoid.p3);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_1
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p1);
		cs_go_to(ps_locomotion_avoid.p0);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_2
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p7);
		cs_go_to(ps_locomotion_avoid.p2);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_3
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p5);
		cs_go_to(ps_locomotion_avoid.p4);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_4
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		g_avoid_sync_ref_count = g_avoid_sync_ref_count + 1;
		cs_go_to(ps_locomotion_avoid.p3);
		cs_go_to(ps_locomotion_avoid.p6);
		g_avoid_sync_ref_count = g_avoid_sync_ref_count - 1;
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_avoid_center
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		cs_go_to(ps_locomotion_avoid.p8);
		sleep_until(g_avoid_sync_ref_count == 0);
	until (false);
end


script command_script cs_locomotion_face_player
	if g_loc_strafe_crouch == true then
		cs_crouch(true);
	end
	
	repeat
		cs_aim_player(true);
		sleep(200);
	until (false);
end

//--------------------------------
//	Tutorial Activation Triggers
//--------------------------------

//script continuous Spawn?
//	sleep_until(volume_test_players(X) >= 1);
//	ai_place(Y);
//	sleep(1);
//	sleep_until(ai_living_count(Y) == 0);
//	sleep(30);
//end


//-----------------------------------
//			Random Tests
//-----------------------------------

script command_script cs_bishop_movement_test
	cs_move_towards_point(ps_bishop_movement.p0, 0.5);
	cs_move_towards_point(ps_bishop_movement.p1, 0.5);
	cs_move_towards_point(ps_bishop_movement.p2, 0.5);
	cs_move_towards_point(ps_bishop_movement.p3, 0.5);
end

script command_script cs_lich_test
	cs_shoot_point(true, ps_lich_test.p0);
	print("1");
	sleep_s(10);
	print("2");
end