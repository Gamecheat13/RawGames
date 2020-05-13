;=============== reset test case =================;
global ai friendlyAI1 = null_squad;
global ai friendlyAI2 = null_squad;
global ai friendlyAI3 = null_squad;
global ai friendlyAI4 = null_squad;
global ai friendlyAI5 = null_squad;
global ai friendlyAI6 = null_squad;

global ai enemyAI1 = null_squad;
global ai enemyAI2 = null_squad;
global ai enemyAI3 = null_squad;
global ai enemyAI4 = null_squad;
global ai enemyAI5 = null_squad;
global ai enemyAI6 = null_squad;

global unit_seat_mapping seatDriver = warthog_d;
global unit_seat_mapping seatGunner = warthog_g;
global unit_seat_mapping seatPassenger1 = warthog_p;
global unit_seat_mapping seatPassenger2 = warthog_d;
global unit_seat_mapping seatPassenger3 = warthog_d;
global unit_seat_mapping seatPassenger4 = warthog_d;

global ai vehicleAI1 = null_squad;
global ai vehicleAI2 = null_squad;
global ai vehicleAI3 = null_squad;
global ai vehicleAI4 = null_squad;
global ai vehicleAI5 = null_squad;
global ai vehicleAI6 = null_squad;

global unit vehicleUnit = null_vehicle;
global vehicle veh = null_vehicle;

script static void start_over()
	kill_active_scripts();
	object_destroy(hog_chaingun);
	object_destroy(hog_gauss);
	object_destroy(hog_rocket);
	object_destroy(banshee);
	object_destroy(ghost);
	object_destroy(scorpion);
	object_destroy(wraith);
	object_destroy(mongoose);
	garbage_collect_unsafe();
	ai_erase_all();
end

script static void Boarding_Helper(ai driver, ai hijacker, object_name objName, unit_seat_mapping driverSeat, unit_seat_mapping hijackerSeat)
	Boarding_Helper_Helper(driver, hijacker, objName, driverSeat, hijackerSeat, spawn_points.right);
	Boarding_Helper_Helper(driver, hijacker, objName, driverSeat, hijackerSeat, spawn_points.left);
	Boarding_Helper_Helper(driver, hijacker, objName, driverSeat, hijackerSeat, spawn_points.back);
end

script static void Boarding_Helper_Helper(ai driver, ai hijacker, object_name objName, unit_seat_mapping driverSeat, unit_seat_mapping hijackerSeat, point_reference point)
	object_create(objName);
	object_teleport_to_ai_point(objName, spawn_points.vehicle_p0);
	
	veh = vehicle(objName);
	
	sleep(2);
	ai_place (driver);
	ai_vehicle_enter_immediate (driver, veh, driverSeat);
	sleep(2);
	ai_braindead(driver, true);
	sleep_until(vehicle_test_seat ( veh, driverSeat) );
	vehicle_hover(veh, true);
	ai_place (hijacker);
	
	ai_teleport(hijacker, point);
	sleep(1);
	unit_board_vehicle(hijacker, "warthog_b_d");
	//cs_go_to_vehicle (hijacker, 1, veh, hijackerSeat);
	
	sleep(30 * 12);
	vehicle_hover(veh, false);
	sleep(30*2);
	ai_erase(driver);
	ai_erase(hijacker);
	object_destroy(veh);
	garbage_collect_unsafe();
end

script static void Fire_Helper(ai driver, unit_seat_mapping driverSeat, 
							ai gunner unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName)
	
	object_create(objName);
	ai_place(driver);	
	ai_place(gunner);
	ai_place(passenger1);
	ai_place(passenger2);
	ai_place(passenger3);
	ai_place(passenger4);
	
	veh = vehicle(objName);
	
	object_teleport_to_ai_point(veh, spawn_points.vehicle_p1);
	
	ai_vehicle_enter_immediate(driver, veh, driverSeat);	
	ai_vehicle_enter_immediate(gunner, veh, gunnerSeat);
	ai_vehicle_enter_immediate(passenger1, veh, passenger1Seat);
	ai_vehicle_enter_immediate(passenger2, veh, passenger2Seat);
	ai_vehicle_enter_immediate(passenger3, veh, passenger3Seat);
	ai_vehicle_enter_immediate(passenger4, veh, passenger4Seat);
	
	ai_braindead(driver, true);
	cs_run_command_script(gunner, standing_vehicle);
	cs_run_command_script(passenger1, standing_vehicle);					
	cs_run_command_script(passenger2, standing_vehicle);					
	cs_run_command_script(passenger3, standing_vehicle);					
	cs_run_command_script(passenger4, standing_vehicle);					
end

script static void Flip_Helper(ai driver, unit_seat_mapping driverSeat, object_name objName, point_reference sp)
	object_create(objName);
	ai_place(driver);
	
	veh = vehicle(objName);
	
	object_teleport_to_ai_point(veh, sp);
		
	//ai_set_objective(ai_get_squad(driver), ai_objectives_4);
	
	ai_vehicle_enter_immediate(driver, veh, driverSeat);	
	
	sleep(30 * 6);
	
	ai_vehicle_enter_immediate(driver, veh, driverSeat);	
	
end

script static void Enter_Helper(ai driver, unit_seat_mapping driverSeat, 
							ai gunner unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName)
	object_create(objName);
	ai_place(driver);
	ai_teleport(driver, spawn_points.left);	
	ai_place(gunner);
	ai_teleport(gunner, spawn_points.back);
	ai_place(passenger1);
	ai_teleport(passenger1, spawn_points.right);
	ai_place(passenger2);
	ai_teleport(passenger2, spawn_points.back_left);
	ai_place(passenger3);
	ai_teleport(passenger3, spawn_points.back_right);
	ai_place(passenger4);
	ai_teleport(passenger4, spawn_points.front);
	
	veh = vehicle(objName);
	object_teleport_to_ai_point(veh, spawn_points.vehicle_p0);
	
	sleep(30);
	
	cs_go_to_vehicle(driver, true, veh, driverSeat);
	cs_go_to_vehicle(gunner, true, veh, gunnerSeat);
	cs_go_to_vehicle(passenger1, true, veh, passenger1Seat);
	cs_go_to_vehicle(passenger2, true, veh, passenger2Seat);
	cs_go_to_vehicle(passenger3, true, veh, passenger3Seat);
	cs_go_to_vehicle(passenger4, true, veh, passenger4Seat);
	
	ai_braindead(driver, true);	
	ai_braindead(gunner, true);
	ai_braindead(passenger1, true);
	ai_braindead(passenger2, true);
	ai_braindead(passenger3, true);
	ai_braindead(passenger4, true);
end

script static void Exit_Helper(ai driver, unit_seat_mapping driverSeat, 
							ai gunner unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName)
	object_create(objName);
	ai_place(driver);	
	ai_place(gunner);
	ai_place(passenger1);
	ai_place(passenger2);
	ai_place(passenger3);
	ai_place(passenger4);
	
	veh = vehicle(objName);
	object_teleport_to_ai_point(veh, spawn_points.vehicle_p0);
	
	ai_vehicle_enter_immediate(driver, veh, driverSeat);	
	ai_vehicle_enter_immediate(gunner, veh, gunnerSeat);
	ai_vehicle_enter_immediate(passenger1, veh, passenger1Seat);
	ai_vehicle_enter_immediate(passenger2, veh, passenger2Seat);
	ai_vehicle_enter_immediate(passenger3, veh, passenger3Seat);
	ai_vehicle_enter_immediate(passenger4, veh, passenger4Seat);
	
	sleep(30);
	
	ai_vehicle_exit(driver, driverSeat);	
	ai_vehicle_exit(gunner, gunnerSeat);
	ai_vehicle_exit(passenger1, passenger1Seat);
	ai_vehicle_exit(passenger2, passenger2Seat);
	ai_vehicle_exit(passenger3, passenger3Seat);
	ai_vehicle_exit(passenger4, passenger4Seat);
end

script static void Pathing_Helper(ai driver, unit_seat_mapping driverSeat, 
							ai gunner unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName, boolean airborne)
	object_create(objName);
	ai_place(driver);
	ai_teleport(driver, spawn_points.left);	
	ai_place(gunner);
	ai_teleport(gunner, spawn_points.back);
	ai_place(passenger1);
	ai_teleport(passenger1, spawn_points.right);
	ai_place(passenger2);
	ai_teleport(passenger2, spawn_points.back_left);
	ai_place(passenger3);
	ai_teleport(passenger3, spawn_points.back_right);
	ai_place(passenger4);
	ai_teleport(passenger4, spawn_points.front);
	
	veh = vehicle(objName);
	object_teleport_to_ai_point(veh, spawn_points.vehicle_p0);
	
	cs_go_to_vehicle(driver, 1, veh, driverSeat);
	cs_go_to_vehicle(gunner, 1, veh, gunnerSeat);
	cs_go_to_vehicle(passenger1, 1, veh, passenger1Seat);
	cs_go_to_vehicle(passenger2, 1, veh, passenger2Seat);
	cs_go_to_vehicle(passenger3, 1, veh, passenger3Seat);
	cs_go_to_vehicle(passenger4, 1, veh, passenger4Seat);
	
	cs_enable_moving(driver, true);
	if(airborne == true) then
		ai_set_objective(ai_get_squad(driver), ai_objectives_5);
	else
		ai_set_objective(ai_get_squad(driver), ai_objectives_3);
	end
	
	
end

;=========== aimtest script ======================;

(script command_script standing_vehicle

(print "Firing Above")
	(sleep 60)
(print "Above back left side")
	(sleep 60)
	(cs_aim_object true veh_above_left_back)	
	(sleep 60)
	(cs_shoot 1 veh_above_left_back)
	(sleep 60)
(print "Above right front")
	(sleep 60)
	(cs_aim_object 1 veh_above_right_front)	
	(sleep 60)
	(cs_shoot 1 veh_above_right_front)
	(sleep 60)
(print "Above left front")
	(sleep 60)
	(cs_aim_object 1 veh_above_left_front)	
	(sleep 60)
	(cs_shoot 1 veh_above_left_front)
	(sleep 60)
(print "Above back right side")
	(sleep 60)
	(cs_aim_object 1 veh_above_right_back)	
	(sleep 60)
	(cs_shoot 1 veh_above_right_back)
	(sleep 60)
(print "Above middle mid")
	(sleep 60)
	(cs_aim_object 1 veh_above_mid_mid)	
	(sleep 60)
	(cs_shoot 1 veh_above_mid_mid)
	(sleep 60)
(print "Above middle back")
	(sleep 60)
	(cs_aim_object 1 veh_above_mid_back)	
	(sleep 60)
	(cs_shoot 1 veh_above_mid_back)
	(sleep 60)
(print "Rotating around Targets")


(print "Right Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 right_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 right_wall_back_crnr)
	(sleep 60)
(print "Front Right")
	(sleep 60)
	(cs_aim_object 1 front_right)	
	(sleep 60)
	(cs_shoot 1 front_right)
	(sleep 60)
(print "Front Left")
	(sleep 60)
	(cs_aim_object 1 front_left)	
	(sleep 60)
	(cs_shoot 1 front_left)
	(sleep 60)
(print "Left Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 left_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 left_wall_back_crnr)
	(sleep 60)
(print "Right Bottom Back Wall")
	(sleep 60)
	(cs_aim_object 1 right_bot_back)	
	(sleep 60)
	(cs_shoot 1 right_bot_back)
	(sleep 60)
(print "Front Right Bottom")
	(sleep 60)
	(cs_aim_object 1 front_right_bot)	
	(sleep 60)
	(cs_shoot 1 front_right_bot)
	(sleep 60)
(print "Front Left Bottom")
	(sleep 60)
	(cs_aim_object 1 front_left_bot)	
	(sleep 60)
	(cs_shoot 1 front_left_bot)
	(sleep 60)
(print "Back Left Bottom")
	(sleep 60)
	(cs_aim_object 1 left_bot_back)	
	(sleep 60)
	(cs_shoot 1 left_bot_back)
	(sleep 60)
(print "Back Right Bottom")
	(sleep 60)
	(cs_aim_object 1 right_bot_back)	
	(sleep 60)
	(cs_shoot 1 right_bot_back)
	(sleep 60)
(print "Right Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 right_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 right_wall_back_crnr)
	(sleep 60)
(print "Left Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 left_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 left_wall_back_crnr)
	(sleep 60)
(print "Front Left")
	(sleep 60)
	(cs_aim_object 1 front_left)	
	(sleep 60)
	(cs_shoot 1 front_left)
	(sleep 60)
(print "Front Left Bottom")
	(sleep 60)
	(cs_aim_object 1 front_left_bot)	
	(sleep 60)
	(cs_shoot 1 front_left_bot)
	(sleep 60)
(print "Front Right")
	(sleep 60)
	(cs_aim_object 1 front_right)	
	(sleep 60)
	(cs_shoot 1 front_right)
	(sleep 60)
(print "Front Right Bottom")
	(sleep 60)
	(cs_aim_object 1 front_right_bot)	
	(sleep 60)
	(cs_shoot 1 front_right_bot)
	(sleep 60)

	(ai_erase_all)
)

script static void SetFriendly(string name)
	if(name == "marines_rifle") then
		friendlyAI1 = marines_rifle.spawn_points_0;
		friendlyAI2 = marines_rifle.spawn_points_1;
		friendlyAI3 = marines_rifle.spawn_points_2;
		friendlyAI4 = marines_rifle.spawn_points_3;
		friendlyAI5 = marines_rifle.spawn_points_4;
		friendlyAI6 = marines_rifle.spawn_points_5;
	end
	if(name == "marines_pistol") then
		friendlyAI1 = marines_pistol.spawn_points_0;
		friendlyAI2 = marines_pistol.spawn_points_1;
		friendlyAI3 = marines_pistol.spawn_points_2;
		friendlyAI4 = marines_pistol.spawn_points_3;
		friendlyAI5 = marines_pistol.spawn_points_4;
		friendlyAI6 = marines_pistol.spawn_points_5;
	end
	if(name == "marines_missile") then
		friendlyAI1 = marines_missile.spawn_points_0;
		friendlyAI2 = marines_missile.spawn_points_1;
		friendlyAI3 = marines_missile.spawn_points_2;
		friendlyAI4 = marines_missile.spawn_points_3;
		friendlyAI5 = marines_missile.spawn_points_4;
		friendlyAI6 = marines_missile.spawn_points_5;
	end
		if(name == "spartans_rifle") then
		friendlyAI1 = spartans_rifle.spawn_points_0;
		friendlyAI2 = spartans_rifle.spawn_points_1;
		friendlyAI3 = spartans_rifle.spawn_points_2;
		friendlyAI4 = spartans_rifle.spawn_points_3;
		friendlyAI5 = spartans_rifle.spawn_points_4;
		friendlyAI6 = spartans_rifle.spawn_points_5;
	end
	if(name == "spartans_pistol") then
		friendlyAI1 = spartans_pistol.spawn_points_0;
		friendlyAI2 = spartans_pistol.spawn_points_1;
		friendlyAI3 = spartans_pistol.spawn_points_2;
		friendlyAI4 = spartans_pistol.spawn_points_3;
		friendlyAI5 = spartans_pistol.spawn_points_4;
		friendlyAI6 = spartans_pistol.spawn_points_5;
	end
	if(name == "spartans_missile") then
		friendlyAI1 = spartans_missile.spawn_points_0;
		friendlyAI2 = spartans_missile.spawn_points_1;
		friendlyAI3 = spartans_missile.spawn_points_2;
		friendlyAI4 = spartans_missile.spawn_points_3;
		friendlyAI5 = spartans_missile.spawn_points_4;
		friendlyAI6 = spartans_missile.spawn_points_5;
	end
	if(name == "elites_rifle") then
		friendlyAI1 = elites_rifle.spawn_points_0;
		friendlyAI2 = elites_rifle.spawn_points_1;
		friendlyAI3 = elites_rifle.spawn_points_2;
		friendlyAI4 = elites_rifle.spawn_points_3;
		friendlyAI5 = elites_rifle.spawn_points_4;
		friendlyAI6 = elites_rifle.spawn_points_5;
	end
	if(name == "elites_pistol") then
		friendlyAI1 = elites_pistol.spawn_points_0;
		friendlyAI2 = elites_pistol.spawn_points_1;
		friendlyAI3 = elites_pistol.spawn_points_2;
		friendlyAI4 = elites_pistol.spawn_points_3;
		friendlyAI5 = elites_pistol.spawn_points_4;
		friendlyAI6 = elites_pistol.spawn_points_5;
	end
	if(name == "elites_missile") then
		friendlyAI1 = elites_missile.spawn_points_0;
		friendlyAI2 = elites_missile.spawn_points_1;
		friendlyAI3 = elites_missile.spawn_points_2;
		friendlyAI4 = elites_missile.spawn_points_3;
		friendlyAI5 = elites_missile.spawn_points_4;
		friendlyAI6 = elites_missile.spawn_points_5;
	end
	if(name == "grunts_pistol") then
		friendlyAI1 = grunts_pistol.spawn_points_0;
		friendlyAI2 = grunts_pistol.spawn_points_1;
		friendlyAI3 = grunts_pistol.spawn_points_2;
		friendlyAI4 = grunts_pistol.spawn_points_3;
		friendlyAI5 = grunts_pistol.spawn_points_4;
		friendlyAI6 = grunts_pistol.spawn_points_5;
	end
	if(name == "grunts_missile") then
		friendlyAI1 = grunts_missile.spawn_points_0;
		friendlyAI2 = grunts_missile.spawn_points_1;
		friendlyAI3 = grunts_missile.spawn_points_2;
		friendlyAI4 = grunts_missile.spawn_points_3;
		friendlyAI5 = grunts_missile.spawn_points_4;
		friendlyAI6 = grunts_missile.spawn_points_5;
	end
	if(name == "jackals_rifle") then
		friendlyAI1 = jackals_rifle.spawn_points_0;
		friendlyAI2 = jackals_rifle.spawn_points_1;
		friendlyAI3 = jackals_rifle.spawn_points_2;
		friendlyAI4 = jackals_rifle.spawn_points_3;
		friendlyAI5 = jackals_rifle.spawn_points_4;
		friendlyAI6 = jackals_rifle.spawn_points_5;
	end
	if(name == "jackals_pistol") then
		friendlyAI1 = jackals_pistol.spawn_points_0;
		friendlyAI2 = jackals_pistol.spawn_points_1;
		friendlyAI3 = jackals_pistol.spawn_points_2;
		friendlyAI4 = jackals_pistol.spawn_points_3;
		friendlyAI5 = jackals_pistol.spawn_points_4;
		friendlyAI6 = jackals_pistol.spawn_points_5;
	end
end

script static void SetEnemy(string name)
	if(name == "marines_rifle") then
		enemyAI1 = marines_rifle.spawn_points_0;
		enemyAI2 = marines_rifle.spawn_points_1;
		enemyAI3 = marines_rifle.spawn_points_2;
		enemyAI4 = marines_rifle.spawn_points_3;
		enemyAI5 = marines_rifle.spawn_points_4;
		enemyAI6 = marines_rifle.spawn_points_5;
	end
	if(name == "marines_pistol") then
		enemyAI1 = marines_pistol.spawn_points_0;
		enemyAI2 = marines_pistol.spawn_points_1;
		enemyAI3 = marines_pistol.spawn_points_2;
		enemyAI4 = marines_pistol.spawn_points_3;
		enemyAI5 = marines_pistol.spawn_points_4;
		enemyAI6 = marines_pistol.spawn_points_5;
	end
	if(name == "marines_missile") then
		enemyAI1 = marines_missile.spawn_points_0;
		enemyAI2 = marines_missile.spawn_points_1;
		enemyAI3 = marines_missile.spawn_points_2;
		enemyAI4 = marines_missile.spawn_points_3;
		enemyAI5 = marines_missile.spawn_points_4;
		enemyAI6 = marines_missile.spawn_points_5;
	end
		if(name == "spartans_rifle") then
		enemyAI1 = spartans_rifle.spawn_points_0;
		enemyAI2 = spartans_rifle.spawn_points_1;
		enemyAI3 = spartans_rifle.spawn_points_2;
		enemyAI4 = spartans_rifle.spawn_points_3;
		enemyAI5 = spartans_rifle.spawn_points_4;
		enemyAI6 = spartans_rifle.spawn_points_5;
	end
	if(name == "spartans_pistol") then
		enemyAI1 = spartans_pistol.spawn_points_0;
		enemyAI2 = spartans_pistol.spawn_points_1;
		enemyAI3 = spartans_pistol.spawn_points_2;
		enemyAI4 = spartans_pistol.spawn_points_3;
		enemyAI5 = spartans_pistol.spawn_points_4;
		enemyAI6 = spartans_pistol.spawn_points_5;
	end
	if(name == "spartans_missile") then
		enemyAI1 = spartans_missile.spawn_points_0;
		enemyAI2 = spartans_missile.spawn_points_1;
		enemyAI3 = spartans_missile.spawn_points_2;
		enemyAI4 = spartans_missile.spawn_points_3;
		enemyAI5 = spartans_missile.spawn_points_4;
		enemyAI6 = spartans_missile.spawn_points_5;
	end
	if(name == "elites_rifle") then
		enemyAI1 = elites_rifle.spawn_points_0;
		enemyAI2 = elites_rifle.spawn_points_1;
		enemyAI3 = elites_rifle.spawn_points_2;
		enemyAI4 = elites_rifle.spawn_points_3;
		enemyAI5 = elites_rifle.spawn_points_4;
		enemyAI6 = elites_rifle.spawn_points_5;
	end
	if(name == "elites_pistol") then
		enemyAI1 = elites_pistol.spawn_points_0;
		enemyAI2 = elites_pistol.spawn_points_1;
		enemyAI3 = elites_pistol.spawn_points_2;
		enemyAI4 = elites_pistol.spawn_points_3;
		enemyAI5 = elites_pistol.spawn_points_4;
		enemyAI6 = elites_pistol.spawn_points_5;
	end
	if(name == "elites_missile") then
		enemyAI1 = elites_missile.spawn_points_0;
		enemyAI2 = elites_missile.spawn_points_1;
		enemyAI3 = elites_missile.spawn_points_2;
		enemyAI4 = elites_missile.spawn_points_3;
		enemyAI5 = elites_missile.spawn_points_4;
		enemyAI6 = elites_missile.spawn_points_5;
	end
	if(name == "grunts_pistol") then
		enemyAI1 = grunts_pistol.spawn_points_0;
		enemyAI2 = grunts_pistol.spawn_points_1;
		enemyAI3 = grunts_pistol.spawn_points_2;
		enemyAI4 = grunts_pistol.spawn_points_3;
		enemyAI5 = grunts_pistol.spawn_points_4;
		enemyAI6 = grunts_pistol.spawn_points_5;
	end
	if(name == "grunts_missile") then
		enemyAI1 = grunts_missile.spawn_points_0;
		enemyAI2 = grunts_missile.spawn_points_1;
		enemyAI3 = grunts_missile.spawn_points_2;
		enemyAI4 = grunts_missile.spawn_points_3;
		enemyAI5 = grunts_missile.spawn_points_4;
		enemyAI6 = grunts_missile.spawn_points_5;
	end
	if(name == "jackals_rifle") then
		enemyAI1 = jackals_rifle.spawn_points_0;
		enemyAI2 = jackals_rifle.spawn_points_1;
		enemyAI3 = jackals_rifle.spawn_points_2;
		enemyAI4 = jackals_rifle.spawn_points_3;
		enemyAI5 = jackals_rifle.spawn_points_4;
		enemyAI6 = jackals_rifle.spawn_points_5;
	end
	if(name == "jackals_pistol") then
		enemyAI1 = jackals_pistol.spawn_points_0;
		enemyAI2 = jackals_pistol.spawn_points_1;
		enemyAI3 = jackals_pistol.spawn_points_2;
		enemyAI4 = jackals_pistol.spawn_points_3;
		enemyAI5 = jackals_pistol.spawn_points_4;
		enemyAI6 = jackals_pistol.spawn_points_5;
	end
end

script static void StartTest(string test)
	if(test == "warthog_chaingun_fire") then
		Firetest_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_chaingun);
	end
	if(test == "warthog_chaingun_enter") then
		Enter_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_chaingun);
	end
	if(test == "warthog_chaingun_exit") then
		Exit_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_chaingun);
	end
	if(test == "warthog_chaingun_boarding") then
		Boarding_Warthog(friendlyAI1, enemyAI1, hog_chaingun);
	end
	if(test == "warthog_chaingun_pathing") then
		Pathing_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_chaingun);
	end
	if(test == "warthog_chaingun_flip") then
		Flip_Warthog(friendlyAI1, hog_chaingun);
	end
	if(test == "warthog_gauss_fire") then
		Firetest_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_gauss);
	end
	if(test == "warthog_gauss_enter") then
		Enter_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_gauss);
	end
	if(test == "warthog_gauss_exit") then
		Exit_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_gauss);
	end
	if(test == "warthog_gauss_boarding") then
		Boarding_Warthog(friendlyAI1, enemyAI1, hog_gauss);
	end
	if(test == "warthog_gauss_pathing") then
		Pathing_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_gauss);
	end
	if(test == "warthog_gauss_flip") then
		Flip_Warthog(friendlyAI1, hog_gauss);
	end
	if(test == "warthog_rocket_fire") then
		Firetest_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_rocket);
	end
	if(test == "warthog_rocket_enter") then
		Enter_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_rocket);
	end
	if(test == "warthog_rocket_exit") then
		Exit_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_rocket);
	end
	if(test == "warthog_rocket_boarding") then
		Boarding_Warthog(friendlyAI1, enemyAI1, hog_rocket);
	end
	if(test == "warthog_rocket_pathing") then
		Pathing_Warthog(friendlyAI1, friendlyAI2, friendlyAI3, hog_rocket);
	end
	if(test == "warthog_rocket_flip") then
		Flip_Warthog(friendlyAI1, hog_rocket);
	end
	if(test == "wraith_fire") then
		Firetest_Wraith(friendlyAI1, friendlyAI2);
	end
	if(test == "wraith_enter") then
		Enter_Wraith(friendlyAI1, friendlyAI2);
	end
	if(test == "wraith_exit") then
		Exit_Wraith(friendlyAI1, friendlyAI2);
	end
	if(test == "wraith_boarding") then
		Boarding_Wraith(friendlyAI1, enemyAI1);
	end
	if(test == "wraith_hijack") then
		Hijack_Wraith(friendlyAI1, enemyAI1);
	end
	if(test == "wraith_pathing") then
		Pathing_Wraith(friendlyAI1, friendlyAI2);
	end
	if(test == "wraith_flip") then
		Flip_Wraith(friendlyAI1);
	end
	if(test == "scorpion_fire") then
		Firetest_scorpion(friendlyAI1, friendlyAI2, friendlyAI3, friendlyAI4, friendlyAI5, friendlyAI6);
	end
	if(test == "scorpion_enter") then
		Enter_scorpion(friendlyAI1, friendlyAI2, friendlyAI3, friendlyAI4, friendlyAI5, friendlyAI6);
	end
	if(test == "scorpion_exit") then
		Exit_scorpion(friendlyAI1, friendlyAI2, friendlyAI3, friendlyAI4, friendlyAI5, friendlyAI6);
	end
	if(test == "scorpion_boarding") then
		Boarding_scorpion(friendlyAI1, enemyAI1);
	end
	if(test == "scorpion_pathing") then
		Pathing_scorpion(friendlyAI1, friendlyAI2, friendlyAI3, friendlyAI4, friendlyAI5, friendlyAI6);
	end
	if(test == "scorpion_flip") then 
		Flip_scorpion(friendlyAI1);
	end
	if(test == "ghost_fire") then
		Firetest_ghost(friendlyAI1);
	end
	if(test == "ghost_enter") then
		Enter_ghost(friendlyAI1);
	end
	if(test == "ghost_exit") then
		Exit_ghost(friendlyAI1);
	end
	if(test == "ghost_boarding") then
		Boarding_ghost(friendlyAI1, enemyAI1);
	end
	if(test == "ghost_hijack") then
		Hijack_ghost(friendlyAI1, enemyAI1);
	end
	if(test == "ghost_pathing") then
		Pathing_ghost(friendlyAI1);
	end
	if(test == "ghost_flip") then
		Flip_ghost(friendlyAI1);
	end
	if(test == "banshee_enter") then
		Enter_banshee(friendlyAI1);
	end
	if(test == "banshee_exit") then
		Exit_banshee(friendlyAI1);
	end
	if(test == "banshee_boarding") then
		Boarding_banshee(friendlyAI1, enemyAI1);
	end
	if(test == "banshee_hijack") then
		Hijack_banshee(friendlyAI1, enemyAI1);
	end
	if(test == "banshee_pathing") then
		Pathing_banshee(friendlyAI1);
	end
	if(test == "banshee_flip" ) then
		Flip_Banshee(friendlyAI1);
	end
	if(test == "mongoose_fire") then
		Firetest_mongoose(friendlyAI1, friendlyAI2);
	end
	if(test == "mongoose_enter") then
		Enter_mongoose(friendlyAI1, friendlyAI2);
	end
	if(test == "mongoose_exit") then
		Exit_mongoose(friendlyAI1, friendlyAI2);
	end
	if(test == "mongoose_boarding") then
		Boarding_mongoose(friendlyAI1, enemyAI1);
	end
	if(test == "mongoose_pathing") then
		Pathing_mongoose(friendlyAI1, friendlyAI2);
	end
	if(test == "mongoose_flip") then
		Flip_mongoose(friendlyAI1);
	end
end

;========================================== Warthog test =========================================;

script static void Firetest_Warthog(ai driver, ai passenger, ai gunner, object_name objName)
	Fire_Helper(driver, warthog_d, gunner, warthog_g, passenger, warthog_p, null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, objName);
end

;===================== Enter tests ================;

script static void Enter_Warthog(ai driver, ai passenger, ai gunner, object_name objName)
	Enter_Helper(driver, warthog_d, gunner, warthog_g, passenger, warthog_p, null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, objName);
end

;===================== Exit tests ================;

script static void Exit_Warthog(ai driver, ai passenger, ai gunner, object_name objName)
	Exit_Helper(driver, warthog_d, gunner, warthog_g, passenger, warthog_p, null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, objName);
end

;===================== Boarding tests ================;

script static void Boarding_Warthog(ai driver, ai hijacker, object_name objName)
	Boarding_Helper	(driver, hijacker, objName, warthog_d, warthog_b_d);
	Boarding_Helper	(driver, hijacker, objName, warthog_p, warthog_b_p);
	Boarding_Helper	(driver, hijacker, objName, warthog_g, warthog_h);
end

;===================== Pathing tests ================;

script static void Pathing_warthog(ai driver, ai passenger, ai gunner, object_name objName)
	Pathing_Helper(driver, warthog_d, gunner, warthog_g, passenger, warthog_p, null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, objName, false);
end

;===================== Flip tests ================;
script static void Flip_warthog(ai driver, object_name objName)
	Flip_Helper(driver, warthog_d, objName, spawn_points.warthog_flip);
end

;========================================== Wraith test =========================================;

;===================== Fire tests ================;

script static void Firetest_Wraith(ai driver, ai gunner)
	Fire_Helper(driver, wraith_d, gunner, wraith_g, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, wraith);
end

;===================== Enter test ================;

script static void Enter_Wraith(ai driver, ai gunner)
	Enter_Helper(driver, wraith_d, gunner, wraith_g, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, wraith);
end

;===================== Exit test ================;

script static void Exit_Wraith(ai driver, ai gunner)
	Exit_Helper(driver, wraith_d, gunner, wraith_g, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, wraith);
end

;===================== Boarding test ================;

script static void Boarding_Wraith(ai driver, ai hijacker)
	Boarding_Wraith_Helper(driver, hijacker, wraith_b_l);
end

script static void Boarding_Wraith_Helper(ai driver, ai hijacker, unit_seat_mapping seat)
	Boarding_Helper	(driver, hijacker, wraith, wraith_d, seat);
end

;===================== Hijack test ================;

script static void Hijack_Wraith(ai driver, ai hijacker)	
	Boarding_Helper	(driver, hijacker, wraith, wraith_d, wraith_d);
end

;===================== Pathing test ================;

script static void Pathing_wraith(ai driver, ai gunner)
	Pathing_Helper(driver, wraith_d, gunner, wraith_g, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, wraith, false);
end

;===================== Flip test ================;

script static void Flip_wraith(ai driver)
	Flip_Helper(driver, wraith_d, wraith, spawn_points.wraith_flip);
end


;=================================================Scorpion test ==============================================;

script static void Firetest_Scorpion(ai driver, ai gunner, ai passenger1, ai passenger2, ai passenger3, ai passenger4)
	Fire_Helper(driver, scorpion_d, gunner, scorpion_g, passenger1, scorpion_p_lf,  passenger2, scorpion_p_lb, passenger3, scorpion_p_rf, passenger4, scorpion_p_rb, scorpion);
end

;===================== Enter Scorpion test ================;

script static void Enter_Scorpion(ai driver, ai gunner, ai passenger1, ai passenger2, ai passenger3, ai passenger4)
	Enter_Helper(driver, scorpion_d, gunner, scorpion_g, passenger1, scorpion_p_lf,  passenger2, scorpion_p_lb, passenger3, scorpion_p_rf, passenger4, scorpion_p_rb, scorpion);
end

;===================== Exit Scorpion test ================;

script static void Exit_Scorpion(ai driver, ai gunner, ai passenger1, ai passenger2, ai passenger3, ai passenger4)
	Exit_Helper(driver, scorpion_d, gunner, scorpion_g, passenger1, scorpion_p_lf,  passenger2, scorpion_p_lb, passenger3, scorpion_p_rf, passenger4, scorpion_p_rb, scorpion);
end

;===================== Boarding Scorpion test ================;

script static void Boarding_Scorpion(ai driver, ai hijacker)
	Board_Scorpion_Helper(driver, hijacker, scorpion_b_d_l);
	Board_Scorpion_Helper(driver, hijacker, scorpion_b_b);
	Board_Scorpion_Helper(driver, hijacker, scorpion_b_d_r);
end

script static void Board_Scorpion_Helper(ai driver, ai hijacker, unit_seat_mapping HiJackerSeat)
	Boarding_Helper	(driver, hijacker, scorpion, scorpion_d, HijackerSeat);
	Boarding_Helper	(driver, hijacker, scorpion, scorpion_g, HijackerSeat);
end

;===================== Pathing Scorpion test ================;

script static void Pathing_Scorpion(ai driver, ai gunner, ai passenger1, ai passenger2, ai passenger3, ai passenger4)
	Pathing_Helper(driver, scorpion_d, gunner, scorpion_g, passenger1, scorpion_p_rf,  passenger2, scorpion_p_rb, passenger3, scorpion_p_lf, passenger4, scorpion_p_lb, scorpion, false);
end

;===================== Flip Scorpion test ================;

script static void Flip_Scorpion(ai driver)
	Flip_Helper(driver, scorpion_d, scorpion, spawn_points.scorpion_flip);
end

;==================================== Ghost tests =================================;

;===================== Fire tests ================;

script static void Firetest_ghost(ai driver)
	Fire_Helper(driver, ghost_d, null_squad, warthog_d, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, ghost);
end

;===================== Enter Ghost test ================;

script static void Enter_Ghost(ai driver)
	Enter_Helper(driver, ghost_d, null_squad, warthog_d, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, ghost);
end

;===================== Exit Ghost test ================;

script static void Exit_Ghost(ai driver)
	Exit_Helper(driver, ghost_d, null_squad, warthog_d, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, ghost);
end

;===================== Board Ghost test ================;

script static void Boarding_Ghost(ai driver, ai hijacker)
	Boarding_Helper	(driver, hijacker, ghost, ghost_d, ghost_b_d_b);
	Boarding_Helper	(driver, hijacker, ghost, ghost_d, ghost_b_d_r);
	Boarding_Helper	(driver, hijacker, ghost, ghost_d, ghost_b_d_l);
end

;===================== Hijack Ghost test ================;

script static void Hijack_Ghost(ai driver, ai hijacker)
	Boarding_Helper	(driver, hijacker, ghost, ghost_d, ghost_d);
end

;===================== Pathing Ghost test ================;

script static void Pathing_Ghost(ai driver)
	Pathing_Helper(driver, ghost_d, null_squad, warthog_d, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, ghost, false);
end

;===================== Flip Ghost test ================;

script static void Flip_Ghost(ai driver)
	Flip_Helper(driver, ghost_d, ghost, spawn_points.ghost_flip);
end


;========================================= Banshee test ==========================================;

;===================== Enter Banshee test ================;

script static void Enter_Banshee(ai driver)
	Enter_Helper(driver, Banshee_d, null_squad, warthog_d, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, banshee);
end

;===================== Exit Banshee test ================;

script static void Exit_Banshee(ai driver)
	Exit_Helper(driver, Banshee_d, null_squad, warthog_d, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, banshee);
end

;===================== Board Banshee test ================;

script static void Boarding_Banshee(ai driver, ai hijacker)
	Boarding_Helper(driver, hijacker, Banshee, Banshee_d, banshee_b_d_r);
	Boarding_Helper(driver, hijacker, Banshee, Banshee_d, banshee_b_d_l);
end

;===================== Hijack Banshee test ================;

script static void Hijack_Banshee(ai driver, ai hijacker)
	Boarding_Helper	(driver, hijacker, Banshee, Banshee_d, banshee_d);
end

;===================== Pathing Banshee test ================;

script static void Pathing_Banshee(ai driver)
	Pathing_Helper(driver, Banshee_d, null_squad, warthog_d, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, banshee, true);
end

;===================== Flip Banshee test ================;

script static void Flip_Banshee(ai driver)
	object_create(banshee);
	ai_place(driver);
	
	veh = vehicle(banshee);
	
	//object_teleport_to_ai_point(veh, spawn_points.warthog_flip);
	object_set_orientation_direct(veh,1.5,-3.5,2.5,90.0,140.0,0.0);
		
	ai_set_objective(ai_get_squad(driver), ai_objectives_4);

	sleep(150);
	
	ai_vehicle_enter(driver, banshee);
end

;========================================= Mongoose tests ===========================================;
;===================== Fire tests ================;

script static void Firetest_Mongoose(ai driver, ai passenger)
	Fire_Helper(driver, mongoose_d, passenger, mongoose_p, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, mongoose);
end

;===================== Enter test ================;

script static void Enter_Mongoose(ai driver, ai passenger)
	Enter_Helper(driver, mongoose_d, passenger, mongoose_p, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, mongoose);
end

;===================== Exit test ================;

script static void Exit_Mongoose(ai driver, ai passenger)
	Exit_Helper(driver, mongoose_d, passenger, mongoose_p, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, mongoose);
end

;===================== Boarding test ================;

script static void Boarding_Mongoose(ai driver, ai hijacker)
	Boarding_Helper	(driver, hijacker, Mongoose, Mongoose_d, Mongoose_b_d_l);
	Boarding_Helper	(driver, hijacker, Mongoose, Mongoose_p, Mongoose_b_d_r);
end

;===================== Pathing test ================;

script static void Pathing_Mongoose(ai driver, ai passenger)
	Pathing_Helper(driver, mongoose_d, passenger, mongoose_p, null_squad, warthog_d,  null_squad, warthog_d, null_squad, warthog_d, null_squad, warthog_d, mongoose, false);
end

;===================== Flip Ghost test ================;

script static void Flip_Mongoose(ai driver)
	Flip_Helper(driver, mongoose_d, mongoose, spawn_points.mongoose_flip);
end