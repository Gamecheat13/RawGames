//		Locomotion Tests
//----------------------------

global boolean g_loc_strafe_walk = false;
global boolean g_crouch_turn = false; 
global boolean g_flying = false;

global ai target = "elite_minors";
global ai ai1 = "elite_minors";
global ai ai2 = "elite_minors";
global ai ai3 = "elite_minors";
global ai ai4 = "elite_minors";
global ai ai5 = "elite_minors";
global ai ai6 = "elite_minors";
global ai ai7 = "elite_minors";
global ai ai8 = "elite_minors";
global ai ai9 = "elite_minors";
global ai ai10 = "elite_minors";
global ai ai11 = "elite_minors";
global ai ai12 = "elite_minors";
global ai ai13 = "elite_minors";
global ai ai14 = "elite_minors";

script command_script cs_locomotion_strafe_1
	print("test");
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		if(g_flying == true) then
			cs_fly_to(ps_locomotion_strafe.p0);
			cs_fly_to(ps_locomotion_strafe.p1);
			cs_fly_to(ps_locomotion_strafe.p0);
			cs_fly_to(ps_locomotion_strafe.p1);
			cs_fly_to(ps_locomotion_strafe.p0);
			cs_fly_to(ps_locomotion_strafe.p1);
		end
		
		if(g_flying == false) then
			cs_go_to(ps_locomotion_strafe.p0);
			cs_go_to(ps_locomotion_strafe.p1);
			cs_go_to(ps_locomotion_strafe.p0);
			cs_go_to(ps_locomotion_strafe.p1);
			cs_go_to(ps_locomotion_strafe.p0);
			cs_go_to(ps_locomotion_strafe.p1);
		end
		
	until (false);	//	Adds delay for some reason.
end

script command_script cs_locomotion_strafe_2
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		if(g_flying == true) then
			cs_fly_to(ps_locomotion_strafe.p2);
			cs_fly_to(ps_locomotion_strafe.p3);
			cs_fly_to(ps_locomotion_strafe.p2);
			cs_fly_to(ps_locomotion_strafe.p3);
			cs_fly_to(ps_locomotion_strafe.p2);
			cs_fly_to(ps_locomotion_strafe.p3);
		end
		
		if(g_flying == false) then
			cs_go_to(ps_locomotion_strafe.p2);
			cs_go_to(ps_locomotion_strafe.p3);
			cs_go_to(ps_locomotion_strafe.p2);
			cs_go_to(ps_locomotion_strafe.p3);
			cs_go_to(ps_locomotion_strafe.p2);
			cs_go_to(ps_locomotion_strafe.p3);
		end
	until (false);	//	Adds delay for some reason.
end

script command_script cs_locomotion_strafe_3
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		if(g_flying == true) then
			//	Forwards
			cs_fly_to(ps_locomotion_strafe.p5);
			cs_fly_to(ps_locomotion_strafe.p6);
			cs_fly_to(ps_locomotion_strafe.p7);
			cs_fly_to(ps_locomotion_strafe.p8);
			cs_fly_to(ps_locomotion_strafe.p9);
			cs_fly_to(ps_locomotion_strafe.p10);
			cs_fly_to(ps_locomotion_strafe.p11);
			
			//	And backwards
			cs_fly_to(ps_locomotion_strafe.p11);
			cs_fly_to(ps_locomotion_strafe.p10);
			cs_fly_to(ps_locomotion_strafe.p9);
			cs_fly_to(ps_locomotion_strafe.p8);
			cs_fly_to(ps_locomotion_strafe.p7);
			cs_fly_to(ps_locomotion_strafe.p6);
			cs_fly_to(ps_locomotion_strafe.p5);
		
		end
		
		if(g_flying == false) then
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
		end
	until (false);
end

script static void place_ai(ai newAI, string test)
	if (test == "bunker_enemy") then
		enemy_bunker(newAI);
	end
	if (test == "bunker_friendly") then
		friendly_bunker(newAI);
	end	
	if (test == "stand") then
		ai_place(newAI);
		cs_run_command_script(newAI, firing_range);
	end
	if (test == "crouch") then
		ai_place(newAI);
		cs_run_command_script(newAI, crouch_firing_range);
	end
	if( test == "move_crouch" ) then
		ai_place(newAI);
		cs_run_command_script(newAI, c_move_firing_range);
	end
	if (test == "move") then 
		ai_place(newAI);
		cs_run_command_script(newAI, movement_firing_range);
	end
	if (test == "jump") then
		ai_place(newAI);
		cs_run_command_script(newAI, cs_jump_test);
	end
	if (test == "vault") then
		ai_place(newAI);
		cs_run_command_script(newAI, cs_vault_test);
	end
	if (test == "hoist") then
		ai_place(newAI);
		cs_run_command_script(newAI, cs_hoist_test);
	end
	if (test == "jump_sandbox") then
		ai_place(newAI);
		cs_run_command_script(newAI, jump_test);
	end
	if (test == "sandbox") then
		ai_place(newAI);
		cs_run_command_script(newAI, sandbox_test);
	end
	if (test == "edge") then
		ai_place(newAI);
		cs_run_command_script(newAI, edge_test);
	end
	if (test == "idle") then
		ai_place(newAI);
		cs_run_command_script(newAI, idle_test);
	end
	if (test == "alert") then
		ai_place(newAI);
		cs_run_command_script(newAI, alert_test);
	end
	if( test == "dummy") then
		ai_place(newAI);
		ai_braindead(newAI, true);
	end
	if( test == "phase") then
		ai_place(newAI);
		cs_run_command_script(newAI, phase_test);
	end
end


script command_script weapon_test
	ai_braindead(ai_current_actor, true);
end

script command_script jump_test
	print("jump around!");
	ai_set_objective(ai_get_squad(ai_current_actor), ai_objectives_jumping);
end

script command_script phase_test
	print("phase around!");
	ai_set_objective(ai_get_squad(ai_current_actor), ai_objectives_phasing);
end

script command_script edge_test
	print("I Live on the edge!");
	ai_set_objective(ai_get_squad(ai_current_actor), ai_objectives_edge_case);
end

script command_script idle_test
	print("idle hands");
	ai_set_objective(ai_get_squad(ai_current_actor), ai_objectives_idle);
end

script command_script alert_test
	print("alert-ish");
	ai_set_objective(ai_get_squad(ai_current_actor), ai_objectives_alert);
end

script command_script sandbox_test
	print("eh");
	ai_set_objective(ai_get_squad(ai_current_actor), ai_objectives_0);
end

;=========== aimtest script ======================;

(script command_script firing_range
	(ai_teleport ai_current_actor firing_position.p0)
	
	(cs_move_towards_point moving_firing_position.range 0.05)
	
(print "Firing Forward")
	(sleep 30)
(print "Center Wall Top Left")
	(sleep 90)
	(cs_aim_object 1 center_wall_top_left)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_left)
	(sleep 90)
(print "Center Wall Top Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_center)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_center)
	(sleep 90)
(print "Center Wall Top Right")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_right)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_right)
	(sleep 90)
(print "Center Wall Bottom Left")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_left)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_left)
	(sleep 90)
(print "Center Wall Bottom Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_center)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_center)
	(sleep 90)
(print "Center Wall Bottom Right")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_right)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_right)
	(sleep 90)
(print "Rotating between Targets")

	(sleep 90)
(print "Left Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 left_wall_top_left)	
	(sleep 30)
	(cs_shoot 1 left_wall_top_left)
	(sleep 90)
(print "Right Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 right_wall_top_left)	
	(sleep 30)
	(cs_shoot 1 right_wall_top_left)
	(sleep 90)
(print "Center Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_left)
	(sleep 30)
	(cs_shoot 1 center_wall_top_left)
	(sleep 90)
(print "Above Crate Front")
	(sleep 30)
	(cs_aim_object 1 above_crate_front)			
	(sleep 30)
	(cs_shoot 1 above_crate_front)
	(sleep 90)
(print "Above Crate Back")
	(sleep 30)
	(cs_aim_object 1 above_crate_back)	
	(sleep 30)
	(cs_shoot 1 above_crate_back)
	(sleep 90)
(print "Center Wall Bottom Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_center)			
	(sleep 30)
	(cs_shoot 1 center_wall_bot_center)
	(sleep 90)

	(ai_erase_all)
)

;=========== moveaimtest script ======================;

(script command_script movement_firing_range
	(ai_teleport ai_current_actor moving_firing_position.mid_front)
	(sleep 30)
(print "Move-Back : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(sleep 60)
	(if (= g_flying true)
	(begin
		(cs_fly_to moving_firing_position.mid_back 0.05))
	(begin
		(cs_go_to moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(if (= g_flying true)
	(begin
		(cs_fly_to moving_firing_position.mid_front 0.05))
	(begin
		(cs_go_to moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_mid_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(if (= g_flying true)
	(begin
		(cs_fly_to moving_firing_position.mid_back 0.05))
	(begin
		(cs_go_to moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_mid_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_mid_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(sleep 60)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_bot_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_bot_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_bot_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(sleep 60)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_top_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_top_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)
	(cs_shoot 1 move_top_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_back 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_back 0.05)))
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(if (= g_flying true)
	(begin
		(cs_fly_by moving_firing_position.mid_front 0.05))
	(begin
		(cs_move_towards_point moving_firing_position.mid_front 0.05)))
	(sleep 60)

	(sleep 120)
	(ai_erase_all)
)

;=========== crouch move aimtest script ======================;

(script command_script c_move_firing_range
	(ai_teleport ai_current_actor moving_firing_position.mid_front)
	
	(if (= g_flying true)
	(begin
		(print "Flying units don't crouch")))
	(cs_crouch 1)
	(sleep 30)
(print "Move-Back : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(sleep 60)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(sleep 60)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(sleep 60)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(cs_move_towards_point moving_firing_position.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(cs_move_towards_point moving_firing_position.mid_front 0.05)
	(sleep 60)


	(sleep 120)
	(ai_erase_all)
)

;=============== reset test case =================;

script static void start_over()
	kill_active_scripts();
	ai_erase_all();
	garbage_collect_unsafe();
end

;=========================== melee_test =====================;

script static void elite_sword_melee_test()
	ai_place(elite_minors.energy_sword);
	ai_place(marine_minors);
	ai_cannot_die(marine_minors, 1);
	ai_braindead(marine_minors, 1);
	ai_prefer_target_ai(elite_minors.energy_sword, marine_minors, 1);
end

script static void spartan_sword_melee_test()
	ai_place(spartan_minors.energy_sword);
	ai_place(elite_minors);
	ai_cannot_die(elite_minors, 1);
	ai_braindead(elite_minors, 1);
	ai_prefer_target_ai(spartan_minors, elite_minors, 1);
end

script static void friendly_bunker(ai sq)
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);	
	
	ai_teleport(ai_get_squad(sq), bunker_friendly_position.p0);
	
	ai_set_objective(ai_get_squad(sq), ai_objectives_friendly_bunker);
end

script static void enemy_bunker(ai sq)
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	ai_place(sq);
	
	ai_teleport(ai_get_squad(sq), bunker_enemy_position.p0);
	
	ai_set_objective(ai_get_squad(sq), ai_objectives_enemy_bunker);
end

script command_script cs_vault_test()
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	

	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	
	print  ("Vaulting!");
	if(g_flying == true) then
		cs_fly_to (vault_points.p0, 0.3);
		cs_fly_to (vault_points.p1, 0.3);
	end
	if(g_flying == false) then
		cs_go_to (vault_points.p0, 0.3);
		cs_go_to (vault_points.p1, 0.3);
	end
end

script command_script cs_hoist_test()
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	cs_ignore_obstacles(true);
	

	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	
	print  ("Hoisting!");
	if(g_flying == true) then
		cs_fly_to (vault_points.p2, 0.3);
		cs_fly_to (vault_points.p3, 0.3);
	end
	if(g_flying == false) then
		cs_go_to (vault_points.p2, 0.3);
		cs_go_to (vault_points.p3, 0.3);
	end
end

script command_script cs_jump_test()
	
	ai_teleport(ai_current_actor, ps_jump_test.p0);
	
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	

	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	//ai_braindead (ai_current_actor, true);
	
	print  ("moving while facing destination");
	if(g_flying == true) then
		cs_fly_to (ps_jump_test.p0, 0.3);
		cs_fly_to (ps_jump_test.p1, 0.3);
		cs_fly_to (ps_jump_test.p2, 0.3);
		cs_fly_to (ps_jump_test.p3, 0.3);
		cs_fly_to (ps_jump_test.p4, 0.3);
		cs_fly_to (ps_jump_test.p5, 0.3);
		cs_fly_to (ps_jump_test.p6, 0.3);
		cs_fly_to (ps_jump_test.p7, 0.3);
		cs_fly_to (ps_jump_test.p8, 0.3);
		cs_fly_to (ps_jump_test.p9, 0.3);
		cs_fly_to (ps_jump_test.p10, 0.3);
		cs_fly_to (ps_jump_test.p11, 0.3);
		cs_fly_to (ps_jump_test.p12, 0.3);
		cs_fly_to (ps_jump_test.p13, 0.3);
		cs_fly_to (ps_jump_test.p14, 0.3);
		cs_fly_to (ps_jump_test.p15, 0.3);
		cs_fly_to (ps_jump_test.p16, 0.3);
	end
	
	if(g_flying == false) then
		cs_go_to (ps_jump_test.p0, 0.3);
		cs_go_to (ps_jump_test.p1, 0.3);
		cs_go_to (ps_jump_test.p2, 0.3);
		cs_go_to (ps_jump_test.p3, 0.3);
		cs_go_to (ps_jump_test.p4, 0.3);
		cs_go_to (ps_jump_test.p5, 0.3);
		cs_go_to (ps_jump_test.p6, 0.3);
		cs_go_to (ps_jump_test.p7, 0.3);
		cs_go_to (ps_jump_test.p8, 0.3);
		cs_go_to (ps_jump_test.p9, 0.3);
		cs_go_to (ps_jump_test.p10, 0.3);
		cs_go_to (ps_jump_test.p11, 0.3);
		cs_go_to (ps_jump_test.p12, 0.3);
		cs_go_to (ps_jump_test.p13, 0.3);
		cs_go_to (ps_jump_test.p14, 0.3);
		cs_go_to (ps_jump_test.p15, 0.3);
		cs_go_to (ps_jump_test.p16, 0.3);
	end
	
	sleep(30);
	
	ai_erase (ai_current_actor);
end

;=========== crouch aimtest script ======================;

script command_script crouch_firing_range()
	ai_teleport(ai_current_actor, firing_position.p0);
	
	if(g_flying) then
		cs_fly_to(moving_firing_position.range, 0.05);
	end
	if(g_flying == false) then
		cs_go_to(moving_firing_position.range, 0.05);
	end
	
print("Firing Forward");
	cs_aim_object(true, center_wall_bot_center);
	sleep(90);
	cs_crouch(true);
	sleep(30);
	cs_shoot(true, center_wall_top_left);
	sleep(90);
	
print("Center Wall Top Left");
	
	if(g_crouch_turn == false) then
		// Stand up
		cs_crouch(false);
	end
	cs_aim_object(true, center_wall_top_left);
	sleep(90);
	
	if(g_crouch_turn == false) then
		// Crouch
		print("sitting");
		cs_crouch(true);
		sleep(30);
	end	
	print("shooting");
	cs_aim_object(true, center_wall_top_left);
	sleep(90);
print("Center Wall Top Center");
	if(g_crouch_turn == false) then
		print("standing");
		cs_crouch(false);
	end
	sleep(30);
	print("aiming");
	cs_aim_object(false, center_wall_top_center);
	sleep(90);
	if(g_crouch_turn == false) then
		print("sitting");
		cs_crouch(true);
		sleep(30);
	end
	print("shooting");
	cs_aim_object(false, center_wall_top_center);
	sleep(90);
print("Center Wall Top Right");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, center_wall_top_right);
	sleep(90);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(true, center_wall_top_right);
	sleep(90);
print("Center Wall Bottom Left");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, center_wall_bot_left);
	sleep(90);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(1, center_wall_bot_left);
	sleep(90);
print("Center Wall Bottom Center");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, center_wall_bot_center);
	sleep(90);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(1, center_wall_bot_center);
	sleep(90);
print("Center Wall Bottom Right");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, center_wall_bot_right);
	sleep(90);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(1, center_wall_bot_right);
	sleep(90);
print("Rotating between Targets");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(90);
print("Left Wall Top Left");
	sleep(30);
	cs_aim_object(true, left_wall_top_left);
	sleep(30);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(true, left_wall_top_left);
	sleep(90);
print("Right Wall Top Left");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, right_wall_top_left);
	sleep(30);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(true, right_wall_top_left);
	sleep(90);
print("Center Wall Top Left");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, center_wall_top_left);
	sleep(30);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(true, center_wall_top_left);
	sleep(90);
print("Above Crate Front");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(1, above_crate_front);
	sleep(30);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(1, above_crate_front);
	sleep(90);
print("Above Crate Back");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, above_crate_back);
	sleep(30);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(true, above_crate_back);
	sleep(90);
print("Center Wall Bottom Center");
	if(g_crouch_turn == false) then
		cs_crouch(false);
	end
	sleep(30);
	cs_aim_object(true, center_wall_bot_center);
	sleep(30);
	if(g_crouch_turn == false) then
		cs_crouch(true);
		sleep(30);
	end
	cs_shoot(true, center_wall_bot_center);
	sleep(90);
	ai_erase_all();
end

;=========================== Elite Minor Tests =====================;

script static void elite_minor_0(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.unarmed, test);
end

script static void elite_minor_1(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.assault_carbine, test);
end

script static void elite_minor_2(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.beam_rifle, test);
end

script static void elite_minor_3(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.covenant_carbine, test);
end

script static void elite_minor_4(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.concussion_rifle, test);
end

script static void elite_minor_6(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.needler, test);
end

script static void elite_minor_7(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.plasma_pistol, test);
end

script static void elite_minor_8(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.fuel_rod_cannon, test);
end

script static void elite_minor_29(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.energy_sword, test);
end

script static void elite_minor_16(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.assault_rifle, test);
end

script static void elite_minor_17(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.br, test);
end

script static void elite_minor_18(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.dmr, test);
end

script static void elite_minor_19(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.lmg, test);
end

script static void elite_minor_20(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.magnum, test);
end

script static void elite_minor_21(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.rail_gun, test);
end

script static void elite_minor_22(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.rocket_launcher, test);
end

script static void elite_minor_23(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.shotgun, test);
end

script static void elite_minor_24(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.sniper_rifle, test);
end

script static void elite_minor_25(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.spartan_laser, test);
end

script static void elite_minor_26(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.sticky_detonator, test);
end

script static void elite_minor_14(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.spread_gun, test);
end

script static void elite_minor_31(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.stasis_pistol, test);
end

script static void elite_minor_11(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.forerunner_smg, test);
end

script static void elite_minor_12(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.forerunner_rifle, test);
end

script static void elite_minor_9(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.attach_beam, test);
end

script static void elite_minor_13(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_minors.incineration_cannon, test);
end

;=========================== Elite officer Tests =====================;

script static void elite_officer_0(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.unarmed, test);
end

script static void elite_officer_1(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.assault_carbine, test);
end

script static void elite_officer_2(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.beam_rifle, test);
end

script static void elite_officer_3(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.covenant_carbine, test);
end

script static void elite_officer_4(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.concussion_rifle, test);
end

script static void elite_officer_6(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.needler, test);
end

script static void elite_officer_7(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.plasma_pistol, test);
end

script static void elite_officer_8(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.fuel_rod_cannon, test);
end

script static void elite_officer_29(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.energy_sword, test);
end

script static void elite_officer_16(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.assault_rifle, test);
end

script static void elite_officer_17(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.br, test);
end

script static void elite_officer_18(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.dmr, test);
end

script static void elite_officer_19(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.lmg, test);
end

script static void elite_officer_20(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.magnum, test);
end

script static void elite_officer_21(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.rail_gun, test);
end

script static void elite_officer_22(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.rocket_launcher, test);
end

script static void elite_officer_23(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.shotgun, test);
end

script static void elite_officer_24(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.sniper_rifle, test);
end

script static void elite_officer_25(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.spartan_laser, test);
end

script static void elite_officer_26(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.sticky_detonator, test);
end

script static void elite_officer_14(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.spread_gun, test);
end

script static void elite_officer_31(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.stasis_pistol, test);
end

script static void elite_officer_11(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.forerunner_smg, test);
end

script static void elite_officer_12(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.forerunner_rifle, test);
end

script static void elite_officer_9(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.attach_beam, test);
end

script static void elite_officer_13(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_officers.incineration_cannon, test);
end

;=========================== Elite ranger Tests =====================;

script static void elite_ranger_0(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.unarmed, test);
end

script static void elite_ranger_1(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.assault_carbine, test);
end

script static void elite_ranger_2(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.beam_rifle, test);
end

script static void elite_ranger_3(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.covenant_carbine, test);
end

script static void elite_ranger_4(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.concussion_rifle, test);
end

script static void elite_ranger_6(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.needler, test);
end

script static void elite_ranger_7(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.plasma_pistol, test);
end

script static void elite_ranger_8(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.fuel_rod_cannon, test);
end

script static void elite_ranger_29(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.energy_sword, test);
end

script static void elite_ranger_16(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.assault_rifle, test);
end

script static void elite_ranger_17(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.br, test);
end

script static void elite_ranger_18(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.dmr, test);
end

script static void elite_ranger_19(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.lmg, test);
end

script static void elite_ranger_20(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.magnum, test);
end

script static void elite_ranger_21(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.rail_gun, test);
end

script static void elite_ranger_22(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.rocket_launcher, test);
end

script static void elite_ranger_23(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.shotgun, test);
end

script static void elite_ranger_24(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.sniper_rifle, test);
end

script static void elite_ranger_25(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.spartan_laser, test);
end

script static void elite_ranger_26(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.sticky_detonator, test);
end

script static void elite_ranger_14(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.spread_gun, test);
end

script static void elite_ranger_31(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.stasis_pistol, test);
end

script static void elite_ranger_11(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.forerunner_smg, test);
end

script static void elite_ranger_12(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.forerunner_rifle, test);
end

script static void elite_ranger_9(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.attach_beam, test);
end

script static void elite_ranger_13(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_rangers.incineration_cannon, test);
end

;=========================== Elite general Tests =====================;

script static void elite_general_0(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.unarmed, test);
end

script static void elite_general_1(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.assault_carbine, test);
end

script static void elite_general_2(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.beam_rifle, test);
end

script static void elite_general_3(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.covenant_carbine, test);
end

script static void elite_general_4(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.concussion_rifle, test);
end

script static void elite_general_6(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.needler, test);
end

script static void elite_general_7(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.plasma_pistol, test);
end

script static void elite_general_8(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.fuel_rod_cannon, test);
end

script static void elite_general_29(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.energy_sword, test);
end

script static void elite_general_16(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.assault_rifle, test);
end

script static void elite_general_17(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.br, test);
end

script static void elite_general_18(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.dmr, test);
end

script static void elite_general_19(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.lmg, test);
end

script static void elite_general_20(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.magnum, test);
end

script static void elite_general_21(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.rail_gun, test);
end

script static void elite_general_22(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.rocket_launcher, test);
end

script static void elite_general_23(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.shotgun, test);
end

script static void elite_general_24(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.sniper_rifle, test);
end

script static void elite_general_25(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.spartan_laser, test);
end

script static void elite_general_26(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.sticky_detonator, test);
end

script static void elite_general_14(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.spread_gun, test);
end

script static void elite_general_31(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.stasis_pistol, test);
end

script static void elite_general_11(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.forerunner_smg, test);
end

script static void elite_general_12(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.forerunner_rifle, test);
end

script static void elite_general_9(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.attach_beam, test);
end

script static void elite_general_13(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_generals.incineration_cannon, test);
end

;=========================== Elite zealot Tests =====================;

script static void elite_zealot_0(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.assault_carbine, test);
end

script static void elite_zealot_1(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.assault_carbine, test);
end

script static void elite_zealot_2(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.beam_rifle, test);
end

script static void elite_zealot_3(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.covenant_carbine, test);
end

script static void elite_zealot_4(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.concussion_rifle, test);
end

script static void elite_zealot_6(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.needler, test);
end

script static void elite_zealot_7(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.plasma_pistol, test);
end

script static void elite_zealot_8(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.fuel_rod_cannon, test);
end

script static void elite_zealot_29(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.energy_sword, test);
end

script static void elite_zealot_16(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.assault_rifle, test);
end

script static void elite_zealot_17(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.br, test);
end

script static void elite_zealot_18(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.dmr, test);
end

script static void elite_zealot_19(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.lmg, test);
end

script static void elite_zealot_20(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.magnum, test);
end

script static void elite_zealot_21(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.rail_gun, test);
end

script static void elite_zealot_22(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.rocket_launcher, test);
end

script static void elite_zealot_23(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.shotgun, test);
end

script static void elite_zealot_24(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.sniper_rifle, test);
end

script static void elite_zealot_25(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.spartan_laser, test);
end

script static void elite_zealot_26(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.sticky_detonator, test);
end

script static void elite_zealot_14(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.spread_gun, test);
end

script static void elite_zealot_31(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.stasis_pistol, test);
end

script static void elite_zealot_11(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.forerunner_smg, test);
end

script static void elite_zealot_12(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.forerunner_rifle, test);
end

script static void elite_zealot_9(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.attach_beam, test);
end

script static void elite_zealot_13(string test)
	g_crouch_turn = false; g_flying = false;
	place_ai(elite_zealots.incineration_cannon, test);
end

;=========================== Elite zealot Tests =====================;

script static void jackal_minor_0(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.unarmed, test);
end

script static void jackal_minor_1(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.assault_carbine, test);
end

script static void jackal_minor_2(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.beam_rifle, test);
end

script static void jackal_minor_3(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.covenant_carbine, test);
end

script static void jackal_minor_4(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.concussion_rifle, test);
end

script static void jackal_minor_6(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.needler, test);
end

script static void jackal_minor_7(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.plasma_pistol, test);
end

script static void jackal_minor_8(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.fuel_rod_cannon, test);
end

script static void jackal_minor_29(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.energy_sword, test);
end

script static void jackal_minor_16(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.assault_rifle, test);
end

script static void jackal_minor_17(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.br, test);
end

script static void jackal_minor_18(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.dmr, test);
end

script static void jackal_minor_19(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.lmg, test);
end

script static void jackal_minor_20(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.magnum, test);
end

script static void jackal_minor_21(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.rail_gun, test);
end

script static void jackal_minor_22(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.rocket_launcher, test);
end

script static void jackal_minor_23(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.shotgun, test);
end

script static void jackal_minor_24(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.sniper_rifle, test);
end

script static void jackal_minor_25(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.spartan_laser, test);
end

script static void jackal_minor_26(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.sticky_detonator, test);
end

script static void jackal_minor_14(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.spread_gun, test);
end

script static void jackal_minor_31(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.stasis_pistol, test);
end

script static void jackal_minor_11(string test)	
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.forerunner_smg, test);
end

script static void jackal_minor_12(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.forerunner_rifle, test);
end

script static void jackal_minor_9(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.attach_beam, test);
end

script static void jackal_minor_13(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_minors.incineration_cannon, test);
end

;=========================== Jackal major Tests =====================;

script static void jackal_major_0(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.unarmed, test);
end

script static void jackal_major_1(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.assault_carbine, test);
end

script static void jackal_major_2(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.beam_rifle, test);
end

script static void jackal_major_3(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.covenant_carbine, test);
end

script static void jackal_major_4(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.concussion_rifle, test);
end

script static void jackal_major_6(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.needler, test);
end

script static void jackal_major_7(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.plasma_pistol, test);
end

script static void jackal_major_8(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.fuel_rod_cannon, test);
end

script static void jackal_major_29(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.energy_sword, test);
end

script static void jackal_major_16(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.assault_rifle, test);
end

script static void jackal_major_17(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.br, test);
end

script static void jackal_major_18(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.dmr, test);
end

script static void jackal_major_19(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.lmg, test);
end

script static void jackal_major_20(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.magnum, test);
end

script static void jackal_major_21(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.rail_gun, test);
end

script static void jackal_major_22(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.rocket_launcher, test);
end

script static void jackal_major_23(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.shotgun, test);
end

script static void jackal_major_24(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.sniper_rifle, test);
end

script static void jackal_major_25(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.spartan_laser, test);
end

script static void jackal_major_26(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.sticky_detonator, test);
end

script static void jackal_major_14(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.spread_gun, test);
end

script static void jackal_major_31(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.stasis_pistol, test);
end

script static void jackal_major_11(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.forerunner_smg, test);
end

script static void jackal_major_12(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.forerunner_rifle, test);
end

script static void jackal_major_9(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.attach_beam, test);
end

script static void jackal_major_13(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_majors.incineration_cannon, test);
end

;=========================== Jackal sniper Tests =====================;

script static void jackal_sniper_0(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.unarmed, test);
end

script static void jackal_sniper_1(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.assault_carbine, test);
end

script static void jackal_sniper_2(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.beam_rifle, test);
end

script static void jackal_sniper_3(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.covenant_carbine, test);
end

script static void jackal_sniper_4(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.concussion_rifle, test);
end

script static void jackal_sniper_6(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.needler, test);
end

script static void jackal_sniper_7(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.plasma_pistol, test);
end

script static void jackal_sniper_8(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.fuel_rod_cannon, test);
end

script static void jackal_sniper_29(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.energy_sword, test);
end

script static void jackal_sniper_16(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.assault_rifle, test);
end

script static void jackal_sniper_17(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.br, test);
end

script static void jackal_sniper_18(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.dmr, test);
end

script static void jackal_sniper_19(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.lmg, test);
end

script static void jackal_sniper_20(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.magnum, test);
end

script static void jackal_sniper_21(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.rail_gun, test);
end

script static void jackal_sniper_22(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.rocket_launcher, test);
end

script static void jackal_sniper_23(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.shotgun, test);
end

script static void jackal_sniper_24(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.sniper_rifle, test);
end

script static void jackal_sniper_25(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.spartan_laser, test);
end

script static void jackal_sniper_26(string test)
	g_crouch_turn = true; g_flying = false;
	place_ai(jackal_snipers.sticky_detonator, test);
end

script static void jackal_sniper_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_snipers.spread_gun, test);
end

script static void jackal_sniper_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_snipers.stasis_pistol, test);
end

script static void jackal_sniper_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_snipers.forerunner_smg, test);
end

script static void jackal_sniper_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_snipers.forerunner_rifle, test);
end

script static void jackal_sniper_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_snipers.attach_beam, test);
end

script static void jackal_sniper_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_snipers.incineration_cannon, test);
end

;=========================== Jackal ranger Tests =====================;

script static void jackal_ranger_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.unarmed, test);
end

script static void jackal_ranger_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.assault_carbine, test);
end

script static void jackal_ranger_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.beam_rifle, test);
end

script static void jackal_ranger_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.covenant_carbine, test);
end

script static void jackal_ranger_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.concussion_rifle, test);
end

script static void jackal_ranger_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.needler, test);
end

script static void jackal_ranger_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.plasma_pistol, test);
end

script static void jackal_ranger_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.fuel_rod_cannon, test);
end

script static void jackal_ranger_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.energy_sword, test);
end

script static void jackal_ranger_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.assault_rifle, test);
end

script static void jackal_ranger_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.br, test);
end

script static void jackal_ranger_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.dmr, test);
end

script static void jackal_ranger_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.lmg, test);
end

script static void jackal_ranger_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.magnum, test);
end

script static void jackal_ranger_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.rail_gun, test);
end

script static void jackal_ranger_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.rocket_launcher, test);
end

script static void jackal_ranger_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.shotgun, test);
end

script static void jackal_ranger_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.sniper_rifle, test);
end

script static void jackal_ranger_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.spartan_laser, test);
end

script static void jackal_ranger_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.sticky_detonator, test);
end

script static void jackal_ranger_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.spread_gun, test);
end

script static void jackal_ranger_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.stasis_pistol, test);
end

script static void jackal_ranger_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.forerunner_smg, test);
end

script static void jackal_ranger_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.forerunner_rifle, test);
end

script static void jackal_ranger_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.attach_beam, test);
end

script static void jackal_ranger_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_rangers.incineration_cannon, test);
end

;=========================== Jackal ranger_shield Tests =====================;

script static void jackal_ranger_shield_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.unarmed, test);
end

script static void jackal_ranger_shield_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.assault_carbine, test);
end

script static void jackal_ranger_shield_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.beam_rifle, test);
end

script static void jackal_ranger_shield_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.covenant_carbine, test);
end

script static void jackal_ranger_shield_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.concussion_rifle, test);
end

script static void jackal_ranger_shield_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.needler, test);
end

script static void jackal_ranger_shield_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.plasma_pistol, test);
end

script static void jackal_ranger_shield_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.fuel_rod_cannon, test);
end

script static void jackal_ranger_shield_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.energy_sword, test);
end

script static void jackal_ranger_shield_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.assault_rifle, test);
end

script static void jackal_ranger_shield_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.br, test);
end

script static void jackal_ranger_shield_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.dmr, test);
end

script static void jackal_ranger_shield_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.lmg, test);
end

script static void jackal_ranger_shield_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.magnum, test);
end

script static void jackal_ranger_shield_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.rail_gun, test);
end

script static void jackal_ranger_shield_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.rocket_launcher, test);
end

script static void jackal_ranger_shield_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.shotgun, test);
end

script static void jackal_ranger_shield_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.sniper_rifle, test);
end

script static void jackal_ranger_shield_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.spartan_laser, test);
end

script static void jackal_ranger_shield_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.sticky_detonator, test);
end

script static void jackal_ranger_shield_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.spread_gun, test);
end

script static void jackal_ranger_shield_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.stasis_pistol, test);
end

script static void jackal_ranger_shield_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.forerunner_smg, test);
end

script static void jackal_ranger_shield_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.forerunner_rifle, test);
end

script static void jackal_ranger_shield_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.attach_beam, test);
end

script static void jackal_ranger_shield_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(jackal_ranger_shields.incineration_cannon, test);
end

;=========================== grunt minor Tests =====================;

script static void grunt_minor_0(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.unarmed, test);
end

script static void grunt_minor_1(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.assault_carbine, test);
end

script static void grunt_minor_2(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.beam_rifle, test);
end

script static void grunt_minor_3(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.covenant_carbine, test);
end

script static void grunt_minor_4(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.concussion_rifle, test);
end

script static void grunt_minor_6(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.needler, test);
end

script static void grunt_minor_7(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.plasma_pistol, test);
end

script static void grunt_minor_8(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.fuel_rod_cannon, test);
end

script static void grunt_minor_29(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.energy_sword, test);
end

script static void grunt_minor_16(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.assault_rifle, test);
end

script static void grunt_minor_17(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.br, test);
end

script static void grunt_minor_18(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.dmr, test);
end

script static void grunt_minor_19(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.lmg, test);
end

script static void grunt_minor_20(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.magnum, test);
end

script static void grunt_minor_21(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.rail_gun, test);
end

script static void grunt_minor_22(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.rocket_launcher, test);
end

script static void grunt_minor_23(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.shotgun, test);
end

script static void grunt_minor_24(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.sniper_rifle, test);
end

script static void grunt_minor_25(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.spartan_laser, test);
end

script static void grunt_minor_26(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.sticky_detonator, test);
end

script static void grunt_minor_14(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.spread_gun, test);
end

script static void grunt_minor_31(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.stasis_pistol, test);
end

script static void grunt_minor_11(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.forerunner_smg, test);
end

script static void grunt_minor_12(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.forerunner_rifle, test);
end

script static void grunt_minor_9(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.attach_beam, test);
end

script static void grunt_minor_13(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_minors.incineration_cannon, test);
end

;=========================== grunt imperial Tests =====================;

script static void grunt_imperial_0(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.unarmed, test);
end

script static void grunt_imperial_1(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.assault_carbine, test);
end

script static void grunt_imperial_2(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.beam_rifle, test);
end

script static void grunt_imperial_3(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.covenant_carbine, test);
end

script static void grunt_imperial_4(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.concussion_rifle, test);
end

script static void grunt_imperial_6(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.needler, test);
end

script static void grunt_imperial_7(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.plasma_pistol, test);
end

script static void grunt_imperial_8(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.fuel_rod_cannon, test);
end

script static void grunt_imperial_29(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.energy_sword, test);
end

script static void grunt_imperial_16(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.assault_rifle, test);
end

script static void grunt_imperial_17(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.br, test);
end

script static void grunt_imperial_18(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.dmr, test);
end

script static void grunt_imperial_19(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.lmg, test);
end

script static void grunt_imperial_20(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.magnum, test);
end

script static void grunt_imperial_21(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.rail_gun, test);
end

script static void grunt_imperial_22(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.rocket_launcher, test);
end

script static void grunt_imperial_23(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.shotgun, test);
end

script static void grunt_imperial_24(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.sniper_rifle, test);
end

script static void grunt_imperial_25(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.spartan_laser, test);
end

script static void grunt_imperial_26(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.sticky_detonator, test);
end

script static void grunt_imperial_14(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.spread_gun, test);
end

script static void grunt_imperial_31(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.stasis_pistol, test);
end

script static void grunt_imperial_11(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.forerunner_smg, test);
end

script static void grunt_imperial_12(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.forerunner_rifle, test);
end

script static void grunt_imperial_9(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.attach_beam, test);
end

script static void grunt_imperial_13(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_imperials.incineration_cannon, test);
end

;=========================== grunt ultra Tests =====================;

script static void grunt_ultra_0(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.unarmed, test);
end

script static void grunt_ultra_1(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.assault_carbine, test);
end

script static void grunt_ultra_2(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.beam_rifle, test);
end

script static void grunt_ultra_3(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.covenant_carbine, test);
end

script static void grunt_ultra_4(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.concussion_rifle, test);
end

script static void grunt_ultra_6(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.needler, test);
end

script static void grunt_ultra_7(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.plasma_pistol, test);
end

script static void grunt_ultra_8(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.fuel_rod_cannon, test);
end

script static void grunt_ultra_29(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.energy_sword, test);
end

script static void grunt_ultra_16(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.assault_rifle, test);
end

script static void grunt_ultra_17(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.br, test);
end

script static void grunt_ultra_18(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.dmr, test);
end

script static void grunt_ultra_19(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.lmg, test);
end

script static void grunt_ultra_20(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.magnum, test);
end

script static void grunt_ultra_21(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.rail_gun, test);
end

script static void grunt_ultra_22(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.rocket_launcher, test);
end

script static void grunt_ultra_23(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.shotgun, test);
end

script static void grunt_ultra_24(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.sniper_rifle, test);
end

script static void grunt_ultra_25(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.spartan_laser, test);
end

script static void grunt_ultra_26(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.sticky_detonator, test);
end

script static void grunt_ultra_14(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.spread_gun, test);
end

script static void grunt_ultra_31(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.stasis_pistol, test);
end

script static void grunt_ultra_11(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.forerunner_smg, test);
end

script static void grunt_ultra_12(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.forerunner_rifle, test);
end

script static void grunt_ultra_9(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.attach_beam, test);
end

script static void grunt_ultra_13(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_ultras.incineration_cannon, test);
end

;=========================== grunt space Tests =====================;

script static void grunt_space_0(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.unarmed, test);
end

script static void grunt_space_1(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.assault_carbine, test);
end

script static void grunt_space_2(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.beam_rifle, test);
end

script static void grunt_space_3(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.covenant_carbine, test);
end

script static void grunt_space_4(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.concussion_rifle, test);
end

script static void grunt_space_6(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.needler, test);
end

script static void grunt_space_7(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.plasma_pistol, test);
end

script static void grunt_space_8(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.fuel_rod_cannon, test);
end

script static void grunt_space_29(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.energy_sword, test);
end

script static void grunt_space_16(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.assault_rifle, test);
end

script static void grunt_space_17(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.br, test);
end

script static void grunt_space_18(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.dmr, test);
end

script static void grunt_space_19(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.lmg, test);
end

script static void grunt_space_20(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.magnum, test);
end

script static void grunt_space_21(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.rail_gun, test);
end

script static void grunt_space_22(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.rocket_launcher, test);
end

script static void grunt_space_23(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.shotgun, test);
end

script static void grunt_space_24(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.sniper_rifle, test);
end

script static void grunt_space_25(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.spartan_laser, test);
end

script static void grunt_space_26(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.sticky_detonator, test);
end

script static void grunt_space_14(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.spread_gun, test);
end

script static void grunt_space_31(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.stasis_pistol, test);
end

script static void grunt_space_11(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.forerunner_smg, test);
end

script static void grunt_space_12(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.forerunner_rifle, test);
end

script static void grunt_space_9(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.attach_beam, test);
end

script static void grunt_space_13(string test)
	g_crouch_turn = false; g_flying = false; place_ai(grunt_spaces.incineration_cannon, test);
end

;=========================== knight minor Tests =====================;

script static void knight_minor_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.unarmed, test);
end

script static void knight_minor_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.assault_carbine, test);
end

script static void knight_minor_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.beam_rifle, test);
end

script static void knight_minor_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.covenant_carbine, test);
end

script static void knight_minor_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.concussion_rifle, test);
end

script static void knight_minor_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.needler, test);
end

script static void knight_minor_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.plasma_pistol, test);
end

script static void knight_minor_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.fuel_rod_cannon, test);
end

script static void knight_minor_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.energy_sword, test);
end

script static void knight_minor_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.assault_rifle, test);
end

script static void knight_minor_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.br, test);
end

script static void knight_minor_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.dmr, test);
end

script static void knight_minor_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.lmg, test);
end

script static void knight_minor_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.magnum, test);
end

script static void knight_minor_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.rail_gun, test);
end

script static void knight_minor_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.rocket_launcher, test);
end

script static void knight_minor_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.shotgun, test);
end

script static void knight_minor_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.sniper_rifle, test);
end

script static void knight_minor_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.spartan_laser, test);
end

script static void knight_minor_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.sticky_detonator, test);
end

script static void knight_minor_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.spread_gun, test);
end

script static void knight_minor_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.stasis_pistol, test);
end

script static void knight_minor_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.forerunner_smg, test);
end

script static void knight_minor_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.forerunner_rifle, test);
end

script static void knight_minor_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.attach_beam, test);
end

script static void knight_minor_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_minors.incineration_cannon, test);
end

;=========================== knight battlewagon Tests =====================;

script static void knight_battlewagon_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.unarmed, test);
end

script static void knight_battlewagon_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.assault_carbine, test);
end

script static void knight_battlewagon_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.beam_rifle, test);
end

script static void knight_battlewagon_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.covenant_carbine, test);
end

script static void knight_battlewagon_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.concussion_rifle, test);
end

script static void knight_battlewagon_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.needler, test);
end

script static void knight_battlewagon_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.plasma_pistol, test);
end

script static void knight_battlewagon_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.fuel_rod_cannon, test);
end

script static void knight_battlewagon_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.energy_sword, test);
end

script static void knight_battlewagon_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.assault_rifle, test);
end

script static void knight_battlewagon_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.br, test);
end

script static void knight_battlewagon_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.dmr, test);
end

script static void knight_battlewagon_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.lmg, test);
end

script static void knight_battlewagon_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.magnum, test);
end

script static void knight_battlewagon_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.rail_gun, test);
end

script static void knight_battlewagon_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.rocket_launcher, test);
end

script static void knight_battlewagon_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.shotgun, test);
end

script static void knight_battlewagon_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.sniper_rifle, test);
end

script static void knight_battlewagon_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.spartan_laser, test);
end

script static void knight_battlewagon_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.sticky_detonator, test);
end

script static void knight_battlewagon_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.spread_gun, test);
end

script static void knight_battlewagon_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.stasis_pistol, test);
end

script static void knight_battlewagon_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.forerunner_smg, test);
end

script static void knight_battlewagon_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.forerunner_rifle, test);
end

script static void knight_battlewagon_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.attach_beam, test);
end

script static void knight_battlewagon_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_battlewagons.incineration_cannon, test);
end

;=========================== knight ranger Tests =====================;

script static void knight_ranger_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.unarmed, test);
end

script static void knight_ranger_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.assault_carbine, test);
end

script static void knight_ranger_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.beam_rifle, test);
end

script static void knight_ranger_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.covenant_carbine, test);
end

script static void knight_ranger_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.concussion_rifle, test);
end

script static void knight_ranger_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.needler, test);
end

script static void knight_ranger_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.plasma_pistol, test);
end

script static void knight_ranger_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.fuel_rod_cannon, test);
end

script static void knight_ranger_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.energy_sword, test);
end

script static void knight_ranger_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.assault_rifle, test);
end

script static void knight_ranger_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.br, test);
end

script static void knight_ranger_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.dmr, test);
end

script static void knight_ranger_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.lmg, test);
end

script static void knight_ranger_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.magnum, test);
end

script static void knight_ranger_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.rail_gun, test);
end

script static void knight_ranger_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.rocket_launcher, test);
end

script static void knight_ranger_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.shotgun, test);
end

script static void knight_ranger_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.sniper_rifle, test);
end

script static void knight_ranger_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.spartan_laser, test);
end

script static void knight_ranger_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.sticky_detonator, test);
end

script static void knight_ranger_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.spread_gun, test);
end

script static void knight_ranger_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.stasis_pistol, test);
end

script static void knight_ranger_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.forerunner_smg, test);
end

script static void knight_ranger_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.forerunner_rifle, test);
end

script static void knight_ranger_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.attach_beam, test);
end

script static void knight_ranger_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_rangers.incineration_cannon, test);
end

;=========================== knight commander Tests =====================;

script static void knight_commander_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.unarmed, test);
end

script static void knight_commander_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.assault_carbine, test);
end

script static void knight_commander_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.beam_rifle, test);
end

script static void knight_commander_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.covenant_carbine, test);
end

script static void knight_commander_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.concussion_rifle, test);
end

script static void knight_commander_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.needler, test);
end

script static void knight_commander_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.plasma_pistol, test);
end

script static void knight_commander_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.fuel_rod_cannon, test);
end

script static void knight_commander_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.energy_sword, test);
end

script static void knight_commander_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.assault_rifle, test);
end

script static void knight_commander_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.br, test);
end

script static void knight_commander_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.dmr, test);
end

script static void knight_commander_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.lmg, test);
end

script static void knight_commander_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.magnum, test);
end

script static void knight_commander_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.rail_gun, test);
end

script static void knight_commander_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.rocket_launcher, test);
end

script static void knight_commander_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.shotgun, test);
end

script static void knight_commander_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.sniper_rifle, test);
end

script static void knight_commander_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.spartan_laser, test);
end

script static void knight_commander_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.sticky_detonator, test);
end

script static void knight_commander_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.spread_gun, test);
end

script static void knight_commander_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.stasis_pistol, test);
end

script static void knight_commander_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.forerunner_smg, test);
end

script static void knight_commander_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.forerunner_rifle, test);
end

script static void knight_commander_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.attach_beam, test);
end

script static void knight_commander_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(knight_commanders.incineration_cannon, test);
end

;=========================== pawn minor Tests =====================;

script static void pawn_minor_43(string test)
	g_crouch_turn = true; g_flying = false; place_ai(pawn_minors.statis_pistol_head, test);
end

script static void pawn_minor_42(string test)
	g_crouch_turn = true; g_flying = false; place_ai(pawn_minors.forerunner_smg_head, test);
end

;=========================== pawn prime Tests =====================;

script static void pawn_prime_43(string test)
	g_crouch_turn = true; g_flying = false; place_ai(pawn_primes.statis_pistol_head, test);
end

script static void pawn_prime_42(string test)
	g_crouch_turn = true; g_flying = false; place_ai(pawn_primes.forerunner_smg_head, test);
end

;=========================== pawn sniper Tests =====================;

script static void pawn_sniper_44(string test)
	g_crouch_turn = true; g_flying = false; place_ai(pawn_snipers.pawnsniper_head, test);
end

;=========================== bishop minor Tests =====================;

script static void bishop_minor_0(string test)
	g_crouch_turn = true; g_flying = true; place_ai(bishop_minors, test);
end

;=========================== hunter minor Tests =====================;

script static void hunter_minor_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(hunter_minors, test);
end

;=========================== marine minor Tests =====================;

script static void marine_minor_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.unarmed, test);
end

script static void marine_minor_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.assault_carbine, test);
end

script static void marine_minor_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.beam_rifle, test);
end

script static void marine_minor_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.covenant_carbine, test);
end

script static void marine_minor_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.concussion_rifle, test);
end

script static void marine_minor_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.needler, test);
end

script static void marine_minor_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.plasma_pistol, test);
end

script static void marine_minor_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.fuel_rod_cannon, test);
end

script static void marine_minor_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.energy_sword, test);
end

script static void marine_minor_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.assault_rifle, test);
end

script static void marine_minor_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.br, test);
end

script static void marine_minor_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.dmr, test);
end

script static void marine_minor_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.lmg, test);
end

script static void marine_minor_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.magnum, test);
end

script static void marine_minor_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.rail_gun, test);
end

script static void marine_minor_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.rocket_launcher, test);
end

script static void marine_minor_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.shotgun, test);
end

script static void marine_minor_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.sniper_rifle, test);
end

script static void marine_minor_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.spartan_laser, test);
end

script static void marine_minor_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.sticky_detonator, test);
end

script static void marine_minor_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.spread_gun, test);
end

script static void marine_minor_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.stasis_pistol, test);
end

script static void marine_minor_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.forerunner_smg, test);
end

script static void marine_minor_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.forerunner_rifle, test);
end

script static void marine_minor_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.attach_beam, test);
end

script static void marine_minor_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_minors.incineration_cannon, test);
end

;=========================== marine_jetpack minor Tests =====================;

script static void marine_jetpack_minor_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.unarmed, test);
end

script static void marine_jetpack_minor_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.assault_carbine, test);
end

script static void marine_jetpack_minor_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.beam_rifle, test);
end

script static void marine_jetpack_minor_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.covenant_carbine, test);
end

script static void marine_jetpack_minor_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.concussion_rifle, test);
end

script static void marine_jetpack_minor_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.needler, test);
end

script static void marine_jetpack_minor_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.plasma_pistol, test);
end

script static void marine_jetpack_minor_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.fuel_rod_cannon, test);
end

script static void marine_jetpack_minor_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.energy_sword, test);
end

script static void marine_jetpack_minor_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.assault_rifle, test);
end

script static void marine_jetpack_minor_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.br, test);
end

script static void marine_jetpack_minor_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.dmr, test);
end

script static void marine_jetpack_minor_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.lmg, test);
end

script static void marine_jetpack_minor_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.magnum, test);
end

script static void marine_jetpack_minor_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.rail_gun, test);
end

script static void marine_jetpack_minor_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.rocket_launcher, test);
end

script static void marine_jetpack_minor_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.shotgun, test);
end

script static void marine_jetpack_minor_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.sniper_rifle, test);
end

script static void marine_jetpack_minor_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.spartan_laser, test);
end

script static void marine_jetpack_minor_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.sticky_detonator, test);
end

script static void marine_jetpack_minor_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.spread_gun, test);
end

script static void marine_jetpack_minor_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.stasis_pistol, test);
end

script static void marine_jetpack_minor_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.forerunner_smg, test);
end

script static void marine_jetpack_minor_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.forerunner_rifle, test);
end

script static void marine_jetpack_minor_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.attach_beam, test);
end

script static void marine_jetpack_minor_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(marine_jetpack_minors.incineration_cannon, test);
end

;=========================== spartan minor Tests =====================;

script static void spartan_minor_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.unarmed, test);
end

script static void spartan_minor_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.assault_carbine, test);
end

script static void spartan_minor_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.beam_rifle, test);
end

script static void spartan_minor_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.covenant_carbine, test);
end

script static void spartan_minor_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.concussion_rifle, test);
end

script static void spartan_minor_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.needler, test);
end

script static void spartan_minor_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.plasma_pistol, test);
end

script static void spartan_minor_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.fuel_rod_cannon, test);
end

script static void spartan_minor_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.energy_sword, test);
end

script static void spartan_minor_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.assault_rifle, test);
end

script static void spartan_minor_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.br, test);
end

script static void spartan_minor_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.dmr, test);
end

script static void spartan_minor_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.lmg, test);
end

script static void spartan_minor_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.magnum, test);
end

script static void spartan_minor_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.rail_gun, test);
end

script static void spartan_minor_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.rocket_launcher, test);
end

script static void spartan_minor_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.shotgun, test);
end

script static void spartan_minor_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.sniper_rifle, test);
end

script static void spartan_minor_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.spartan_laser, test);
end

script static void spartan_minor_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.sticky_detonator, test);
end

script static void spartan_minor_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.spread_gun, test);
end

script static void spartan_minor_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.stasis_pistol, test);
end

script static void spartan_minor_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.forerunner_smg, test);
end

script static void spartan_minor_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.forerunner_rifle, test);
end

script static void spartan_minor_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.attach_beam, test);
end

script static void spartan_minor_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_minors.incineration_cannon, test);
end

;=========================== spartan jetpack Tests =====================;

script static void spartan_jetpack_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.unarmed, test);
end

script static void spartan_jetpack_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.assault_carbine, test);
end

script static void spartan_jetpack_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.beam_rifle, test);
end

script static void spartan_jetpack_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.covenant_carbine, test);
end

script static void spartan_jetpack_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.concussion_rifle, test);
end

script static void spartan_jetpack_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.needler, test);
end

script static void spartan_jetpack_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.plasma_pistol, test);
end

script static void spartan_jetpack_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.fuel_rod_cannon, test);
end

script static void spartan_jetpack_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.energy_sword, test);
end

script static void spartan_jetpack_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.assault_rifle, test);
end

script static void spartan_jetpack_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.br, test);
end

script static void spartan_jetpack_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.dmr, test);
end

script static void spartan_jetpack_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.lmg, test);
end

script static void spartan_jetpack_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.magnum, test);
end

script static void spartan_jetpack_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.rail_gun, test);
end

script static void spartan_jetpack_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.rocket_launcher, test);
end

script static void spartan_jetpack_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.shotgun, test);
end

script static void spartan_jetpack_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.sniper_rifle, test);
end

script static void spartan_jetpack_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.spartan_laser, test);
end

script static void spartan_jetpack_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.sticky_detonator, test);
end

script static void spartan_jetpack_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.spread_gun, test);
end

script static void spartan_jetpack_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.stasis_pistol, test);
end

script static void spartan_jetpack_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.forerunner_smg, test);
end

script static void spartan_jetpack_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.forerunner_rifle, test);
end

script static void spartan_jetpack_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.attach_beam, test);
end

script static void spartan_jetpack_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(spartan_jetpack.incineration_cannon, test);
end

;=========================== Masterchief Tests =====================;

script static void masterchief_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.unarmed, test);
end

script static void masterchief_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.assault_carbine, test);
end

script static void masterchief_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.beam_rifle, test);
end

script static void masterchief_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.covenant_carbine, test);
end

script static void masterchief_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.concussion_rifle, test);
end

script static void masterchief_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.needler, test);
end

script static void masterchief_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.plasma_pistol, test);
end

script static void masterchief_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.fuel_rod_cannon, test);
end

script static void masterchief_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.energy_sword, test);
end

script static void masterchief_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.assault_rifle, test);
end

script static void masterchief_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.br, test);
end

script static void masterchief_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.dmr, test);
end

script static void masterchief_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.lmg, test);
end

script static void masterchief_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.magnum, test);
end

script static void masterchief_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.rail_gun, test);
end

script static void masterchief_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.rocket_launcher, test);
end

script static void masterchief_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.shotgun, test);
end

script static void masterchief_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.sniper_rifle, test);
end

script static void masterchief_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.spartan_laser, test);
end

script static void masterchief_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.sticky_detonator, test);
end

script static void masterchief_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.spread_gun, test);
end

script static void masterchief_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.stasis_pistol, test);
end

script static void masterchief_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.forerunner_smg, test);
end

script static void masterchief_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.forerunner_rifle, test);
end

script static void masterchief_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.attach_beam, test);
end

script static void masterchief_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(masterchief.incineration_cannon, test);
end

;=========================== scientist minor Tests =====================;

script static void scientist_minor_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.unarmed, test);
end

script static void scientist_minor_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.assault_carbine, test);
end

script static void scientist_minor_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.beam_rifle, test);
end

script static void scientist_minor_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.covenant_carbine, test);
end

script static void scientist_minor_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.concussion_rifle, test);
end

script static void scientist_minor_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.needler, test);
end

script static void scientist_minor_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.plasma_pistol, test);
end

script static void scientist_minor_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.fuel_rod_cannon, test);
end

script static void scientist_minor_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.energy_sword, test);
end

script static void scientist_minor_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.assault_rifle, test);
end

script static void scientist_minor_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.br, test);
end

script static void scientist_minor_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.dmr, test);
end

script static void scientist_minor_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.lmg, test);
end

script static void scientist_minor_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.magnum, test);
end

script static void scientist_minor_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.rail_gun, test);
end

script static void scientist_minor_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.rocket_launcher, test);
end

script static void scientist_minor_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.shotgun, test);
end

script static void scientist_minor_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.sniper_rifle, test);
end

script static void scientist_minor_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.spartan_laser, test);
end

script static void scientist_minor_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.sticky_detonator, test);
end

script static void scientist_minor_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.spread_gun, test);
end

script static void scientist_minor_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.stasis_pistol, test);
end

script static void scientist_minor_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.forerunner_smg, test);
end

script static void scientist_minor_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.forerunner_rifle, test);
end

script static void scientist_minor_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.attach_beam, test);
end

script static void scientist_minor_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_minors.incineration_cannon, test);
end

;=========================== scientist armed Tests =====================;

script static void scientist_armed_0(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.unarmed, test);
end

script static void scientist_armed_1(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.assault_carbine, test);
end

script static void scientist_armed_2(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.beam_rifle, test);
end

script static void scientist_armed_3(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.covenant_carbine, test);
end

script static void scientist_armed_4(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.concussion_rifle, test);
end

script static void scientist_armed_6(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.needler, test);
end

script static void scientist_armed_7(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.plasma_pistol, test);
end

script static void scientist_armed_8(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.fuel_rod_cannon, test);
end

script static void scientist_armed_29(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.energy_sword, test);
end

script static void scientist_armed_16(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.assault_rifle, test);
end

script static void scientist_armed_17(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.br, test);
end

script static void scientist_armed_18(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.dmr, test);
end

script static void scientist_armed_19(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.lmg, test);
end

script static void scientist_armed_20(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.magnum, test);
end

script static void scientist_armed_21(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.rail_gun, test);
end

script static void scientist_armed_22(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.rocket_launcher, test);
end

script static void scientist_armed_23(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.shotgun, test);
end

script static void scientist_armed_24(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.sniper_rifle, test);
end

script static void scientist_armed_25(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.spartan_laser, test);
end

script static void scientist_armed_26(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.sticky_detonator, test);
end

script static void scientist_armed_14(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.spread_gun, test);
end

script static void scientist_armed_31(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.stasis_pistol, test);
end

script static void scientist_armed_11(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.forerunner_smg, test);
end

script static void scientist_armed_12(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.forerunner_rifle, test);
end

script static void scientist_armed_9(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.attach_beam, test);
end

script static void scientist_armed_13(string test)
	g_crouch_turn = true; g_flying = false; place_ai(scientist_armed.incineration_cannon, test);
end



;=========================== Template Tests =====================;

script static void cov_template_1(string test)
	place_ai(cov_template_1, test);
end

script static void cov_template_2(string test)
	place_ai(cov_template_2, test);
end

script static void cov_template_3(string test)
	place_ai(cov_template_3, test);
end

script static void cov_template_4(string test)
	place_ai(cov_template_4, test);
end

script static void unsc_template_1(string test)
	place_ai(unsc_template_1, test);
end

script static void unsc_template_2(string test)
	place_ai(unsc_template_2, test);
end

script static void pro_template_1(string test)
	place_ai(pro_template_1, test);
end

script static void pro_template_2(string test)
	place_ai(pro_template_2, test);
end

script static void pro_template_3(string test)
	place_ai(pro_template_3, test);
end

script static void pro_template_4(string test)
	place_ai(pro_template_4, test);
end

script static void pro_template_5(string test)
	place_ai(pro_template_5, test);
end

script static void pro_template_6(string test)
	place_ai(pro_template_6, test);
end

script static void pro_template_7(string test)
	place_ai(pro_template_7, test);
end

script static void pro_template_8(string test)
	place_ai(pro_template_8, test);
end

