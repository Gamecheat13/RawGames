global ai friendlyAI1 = marines_rifle.spawn_points_0;
global ai friendlyAI2 = marines_rifle.spawn_points_1;
global ai friendlyAI3 = marines_rifle.spawn_points_2;
global ai friendlyAI4 = marines_rifle.spawn_points_3;
global ai friendlyAI5 = marines_rifle.spawn_points_4;
global ai friendlyAI6 = marines_rifle.spawn_points_5;
global ai friendlyAI7 = marines_rifle.spawn_points_6;
global ai friendlyAI8 = marines_rifle.spawn_points_7;
global ai friendlyAI9 = marines_rifle.spawn_points_8;
global ai friendlyAI10 = marines_rifle.spawn_points_9;
global ai friendlyAI11 = marines_rifle.spawn_points_10;
global ai friendlyAI12 = marines_rifle.spawn_points_11;
global ai friendlyAI13 = marines_rifle.spawn_points_12;
global ai friendlyAI14 = marines_rifle.spawn_points_13;
global ai friendlyAI15 = marines_rifle.spawn_points_14;

global ai enemyAI1 = elites_rifle.spawn_points_0;
global ai enemyAI2 = elites_rifle.spawn_points_1;
global ai enemyAI3 = elites_rifle.spawn_points_2;
global ai enemyAI4 = elites_rifle.spawn_points_3;
global ai enemyAI5 = elites_rifle.spawn_points_4;
global ai enemyAI6 = elites_rifle.spawn_points_5;
global ai enemyAI7 = elites_rifle.spawn_points_6;
global ai enemyAI8 = elites_rifle.spawn_points_7;

global unit_seat_mapping seatDriver = phantom_d;
global unit_seat_mapping seatGunner = phantom_d;
global unit_seat_mapping seatPassenger1 = phantom_p_lb;
global unit_seat_mapping seatPassenger2 = phantom_p_lf;
global unit_seat_mapping seatPassenger3 = phantom_p_ml_f;
global unit_seat_mapping seatPassenger4 = phantom_p_ml_b;

global ai vehicleAI1 = marines_rifle.spawn_points_0;
global ai vehicleAI2 = marines_rifle.spawn_points_1;
global ai vehicleAI3 = marines_rifle.spawn_points_2;
global ai vehicleAI4 = marines_rifle.spawn_points_3;
global ai vehicleAI5 = marines_rifle.spawn_points_4;
global ai vehicleAI6 = marines_rifle.spawn_points_5;

global unit vehicleUnit = "shade_anti_air";
global vehicle veh = "shade_anti_air";
global unit_seat_mapping null_seat = "shade_d";
global ai sq = marines_rifle;

script static void start_over()
	object_destroy("phantom");
	object_destroy("shade_anti_air");
	object_destroy("shade_flak_cannon");
	object_destroy("shade_plasma_cannon");
	object_destroy("lich");
	object_destroy("cov_drop_pod_large");
	object_destroy("plasma_turret");
	object_destroy("plasma_turret_watchtower");
	object_destroy("plasma_turret_nodetach");
	kill_active_scripts();
	ai_erase_all();
end

script static void Boarding_Helper(ai driver, ai hijacker, object_name objName, unit_seat_mapping driverSeat, unit_seat_mapping hijackerSeat)
	Boarding_Helper_Helper(driver, hijacker, objName, driverSeat, hijackerSeat, spawn_points.right);
	Boarding_Helper_Helper(driver, hijacker, objName, driverSeat, hijackerSeat, spawn_points.left);
	Boarding_Helper_Helper(driver, hijacker, objName, driverSeat, hijackerSeat, spawn_points.back);
end

script static void Fire_Helper(ai driver, unit_seat_mapping driverSeat, 
							ai gunner unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName)
	
	object_create_anew(objName);
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

script static void Enter_Helper(ai driver, unit_seat_mapping driverSeat, 
							ai gunner unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName)
	object_create_anew(objName);
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

script static void Exit_Helper(ai driver,  unit_seat_mapping driverSeat, 
							ai gunner,     unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName)
	Exit_Helper(driver, driverSeat, gunner, gunnerSeat, passenger1, passenger1Seat, passenger2, passenger2Seat, passenger3, passenger3Seat, passenger4, passenger4Seat, objName, spawn_points.vehicle_p0);
end

script static void Exit_Helper(ai driver,  unit_seat_mapping driverSeat, 
							ai gunner,     unit_seat_mapping gunnerSeat, 
							ai passenger1, unit_seat_mapping passenger1Seat, 
							ai passenger2, unit_seat_mapping passenger2Seat,
							ai passenger3, unit_seat_mapping passenger3Seat,
							ai passenger4, unit_seat_mapping passenger4Seat,
							object_name objName, point_reference point)
	object_create_anew(objName);
	ai_place(driver);	
	ai_place(gunner);
	ai_place(passenger1);
	ai_place(passenger2);
	ai_place(passenger3);
	ai_place(passenger4);
	
	veh = vehicle(objName);
	object_teleport_to_ai_point(veh, point);
	
	ai_vehicle_enter_immediate(driver, veh, driverSeat);	
	ai_vehicle_enter_immediate(gunner, veh, gunnerSeat);
	ai_vehicle_enter_immediate(passenger1, veh, passenger1Seat);
	ai_vehicle_enter_immediate(passenger2, veh, passenger2Seat);
	ai_vehicle_enter_immediate(passenger3, veh, passenger3Seat);
	ai_vehicle_enter_immediate(passenger4, veh, passenger4Seat);
	
	sleep(60);
	
	ai_vehicle_exit(driver, driverSeat);	
	ai_vehicle_exit(gunner, gunnerSeat);
	ai_vehicle_exit(passenger1, passenger1Seat);
	ai_vehicle_exit(passenger2, passenger2Seat);
	ai_vehicle_exit(passenger3, passenger3Seat);
	ai_vehicle_exit(passenger4, passenger4Seat);
end

script static void Boarding_Helper_Helper(ai driver, ai hijacker, object_name objName, unit_seat_mapping driverSeat, unit_seat_mapping hijackerSeat, point_reference point)
	object_create_anew(objName);
	object_teleport_to_ai_point(objName, spawn_points.vehicle_p0);
	
	veh = vehicle(objName);
	
	sleep(2);
	ai_place (driver);
	ai_vehicle_enter_immediate (driver, veh, driverSeat);
	sleep(2);
	sleep_until(vehicle_test_seat ( veh, driverSeat) );
	ai_braindead(driver, true);
	ai_place (hijacker);
	
	ai_teleport(hijacker, point);
	sleep(1);
	unit_board_vehicle(hijacker, "warthog_b_d");
	//cs_go_to_vehicle (hijacker, 1, veh, hijackerSeat);
	
	sleep(30 * 12);
	ai_erase(driver);
	ai_erase(hijacker);
	object_destroy(veh);
	garbage_collect_unsafe();
end

script static void SetFriendly(string name)
	if(name == "marines_rifle") then
		print("marines_rifle");
		friendlyAI1 = marines_rifle.spawn_points_0;
		friendlyAI2 = marines_rifle.spawn_points_1;
		friendlyAI3 = marines_rifle.spawn_points_2;
		friendlyAI4 = marines_rifle.spawn_points_3;
		friendlyAI5 = marines_rifle.spawn_points_4;
		friendlyAI6 = marines_rifle.spawn_points_5;
		friendlyAI7 = marines_rifle.spawn_points_6;
		friendlyAI8 = marines_rifle.spawn_points_7;
		friendlyAI9 = marines_rifle.spawn_points_8;
		friendlyAI10 = marines_rifle.spawn_points_9;
		friendlyAI11 = marines_rifle.spawn_points_10;
		friendlyAI12 = marines_rifle.spawn_points_11;
		friendlyAI13 = marines_rifle.spawn_points_12;
		friendlyAI14 = marines_rifle.spawn_points_13;
		friendlyAI15 = marines_rifle.spawn_points_14;
	end
	if(name == "marines_pistol") then
		print("marines_pistol");
		friendlyAI1 = marines_pistol.spawn_points_0;
		friendlyAI2 = marines_pistol.spawn_points_1;
		friendlyAI3 = marines_pistol.spawn_points_2;
		friendlyAI4 = marines_pistol.spawn_points_3;
		friendlyAI5 = marines_pistol.spawn_points_4;
		friendlyAI6 = marines_pistol.spawn_points_5;
		friendlyAI7 = marines_pistol.spawn_points_6;
		friendlyAI8 = marines_pistol.spawn_points_7;
		friendlyAI9 = marines_pistol.spawn_points_8;
		friendlyAI10 = marines_pistol.spawn_points_9;
		friendlyAI11 = marines_pistol.spawn_points_10;
		friendlyAI12 = marines_pistol.spawn_points_11;
		friendlyAI13 = marines_pistol.spawn_points_12;
		friendlyAI14 = marines_pistol.spawn_points_13;
		friendlyAI15 = marines_pistol.spawn_points_14;
	end
	if(name == "marines_missile") then
		print("marines_missile");
		friendlyAI1 = marines_missile.spawn_points_0;
		friendlyAI2 = marines_missile.spawn_points_1;
		friendlyAI3 = marines_missile.spawn_points_2;
		friendlyAI4 = marines_missile.spawn_points_3;
		friendlyAI5 = marines_missile.spawn_points_4;
		friendlyAI6 = marines_missile.spawn_points_5;
		friendlyAI7 = marines_missile.spawn_points_6;
		friendlyAI8 = marines_missile.spawn_points_7;
		friendlyAI9 = marines_missile.spawn_points_8;
		friendlyAI10 = marines_missile.spawn_points_9;
		friendlyAI11 = marines_missile.spawn_points_10;
		friendlyAI12 = marines_missile.spawn_points_11;
		friendlyAI13 = marines_missile.spawn_points_12;
		friendlyAI14 = marines_missile.spawn_points_13;
		friendlyAI15 = marines_missile.spawn_points_14;
	end
	if(name == "spartans_rifle") then
		print("spartans_rifle");
		friendlyAI1 = spartans_rifle.spawn_points_0;
		friendlyAI2 = spartans_rifle.spawn_points_1;
		friendlyAI3 = spartans_rifle.spawn_points_2;
		friendlyAI4 = spartans_rifle.spawn_points_3;
		friendlyAI5 = spartans_rifle.spawn_points_4;
		friendlyAI6 = spartans_rifle.spawn_points_5;
		friendlyAI7 = spartans_rifle.spawn_points_6;
		friendlyAI8 = spartans_rifle.spawn_points_7;
		friendlyAI9 = spartans_rifle.spawn_points_8;
		friendlyAI10 = spartans_rifle.spawn_points_9;
		friendlyAI11 = spartans_rifle.spawn_points_10;
		friendlyAI12 = spartans_rifle.spawn_points_11;
		friendlyAI13 = spartans_rifle.spawn_points_12;
		friendlyAI14 = spartans_rifle.spawn_points_13;
		friendlyAI15 = spartans_rifle.spawn_points_14;
	end
	if(name == "spartans_pistol") then
		print("spartans_pistol");
		friendlyAI1 = spartans_pistol.spawn_points_0;
		friendlyAI2 = spartans_pistol.spawn_points_1;
		friendlyAI3 = spartans_pistol.spawn_points_2;
		friendlyAI4 = spartans_pistol.spawn_points_3;
		friendlyAI5 = spartans_pistol.spawn_points_4;
		friendlyAI6 = spartans_pistol.spawn_points_5;
		friendlyAI7 = spartans_pistol.spawn_points_6;
		friendlyAI8 = spartans_pistol.spawn_points_7;
		friendlyAI9 = spartans_pistol.spawn_points_8;
		friendlyAI10 = spartans_pistol.spawn_points_9;
		friendlyAI11 = spartans_pistol.spawn_points_10;
		friendlyAI12 = spartans_pistol.spawn_points_11;
		friendlyAI13 = spartans_pistol.spawn_points_12;
		friendlyAI14 = spartans_pistol.spawn_points_13;
		friendlyAI15 = spartans_pistol.spawn_points_14;
	end
	if(name == "spartans_missile") then
		print("spartans_missile");
		friendlyAI1 = spartans_missile.spawn_points_0;
		friendlyAI2 = spartans_missile.spawn_points_1;
		friendlyAI3 = spartans_missile.spawn_points_2;
		friendlyAI4 = spartans_missile.spawn_points_3;
		friendlyAI5 = spartans_missile.spawn_points_4;
		friendlyAI6 = spartans_missile.spawn_points_5;
		friendlyAI7 = spartans_missile.spawn_points_6;
		friendlyAI8 = spartans_missile.spawn_points_7;
		friendlyAI9 = spartans_missile.spawn_points_8;
		friendlyAI10 = spartans_missile.spawn_points_9;
		friendlyAI11 = spartans_missile.spawn_points_10;
		friendlyAI12 = spartans_missile.spawn_points_11;
		friendlyAI13 = spartans_missile.spawn_points_12;
		friendlyAI14 = spartans_missile.spawn_points_13;
		friendlyAI15 = spartans_missile.spawn_points_14;
	end
	if(name == "elites_rifle") then
		print("elites_rifle");
		friendlyAI1 = elites_rifle.spawn_points_0;
		friendlyAI2 = elites_rifle.spawn_points_1;
		friendlyAI3 = elites_rifle.spawn_points_2;
		friendlyAI4 = elites_rifle.spawn_points_3;
		friendlyAI5 = elites_rifle.spawn_points_4;
		friendlyAI6 = elites_rifle.spawn_points_5;
		friendlyAI7 = elites_rifle.spawn_points_6;
		friendlyAI8 = elites_rifle.spawn_points_7;
		friendlyAI9 = elites_rifle.spawn_points_8;
		friendlyAI10 = elites_rifle.spawn_points_9;
		friendlyAI11 = elites_rifle.spawn_points_10;
		friendlyAI12 = elites_rifle.spawn_points_11;
		friendlyAI13 = elites_rifle.spawn_points_12;
		friendlyAI14 = elites_rifle.spawn_points_13;
		friendlyAI15 = elites_rifle.spawn_points_14;
	end
	if(name == "elites_pistol") then
		print("elites_pistol");
		friendlyAI1 = elites_pistol.spawn_points_0;
		friendlyAI2 = elites_pistol.spawn_points_1;
		friendlyAI3 = elites_pistol.spawn_points_2;
		friendlyAI4 = elites_pistol.spawn_points_3;
		friendlyAI5 = elites_pistol.spawn_points_4;
		friendlyAI6 = elites_pistol.spawn_points_5;
		friendlyAI7 = elites_pistol.spawn_points_6;
		friendlyAI8 = elites_pistol.spawn_points_7;
		friendlyAI9 = elites_pistol.spawn_points_8;
		friendlyAI10 = elites_pistol.spawn_points_9;
		friendlyAI11 = elites_pistol.spawn_points_10;
		friendlyAI12 = elites_pistol.spawn_points_11;
		friendlyAI13 = elites_pistol.spawn_points_12;
		friendlyAI14 = elites_pistol.spawn_points_13;
		friendlyAI15 = elites_pistol.spawn_points_14;
	end
	if(name == "elites_missile") then
		print("elites_missile");
		friendlyAI1 = elites_missile.spawn_points_0;
		friendlyAI2 = elites_missile.spawn_points_1;
		friendlyAI3 = elites_missile.spawn_points_2;
		friendlyAI4 = elites_missile.spawn_points_3;
		friendlyAI5 = elites_missile.spawn_points_4;
		friendlyAI6 = elites_missile.spawn_points_5;
		friendlyAI7 = elites_missile.spawn_points_6;
		friendlyAI8 = elites_missile.spawn_points_7;
		friendlyAI9 = elites_missile.spawn_points_8;
		friendlyAI10 = elites_missile.spawn_points_9;
		friendlyAI11 = elites_missile.spawn_points_10;
		friendlyAI12 = elites_missile.spawn_points_11;
		friendlyAI13 = elites_missile.spawn_points_12;
		friendlyAI14 = elites_missile.spawn_points_13;
		friendlyAI15 = elites_missile.spawn_points_14;
	end
	if(name == "grunts_pistol") then
		print("grunts_pistol");
		friendlyAI1 = grunts_pistol.spawn_points_0;
		friendlyAI2 = grunts_pistol.spawn_points_1;
		friendlyAI3 = grunts_pistol.spawn_points_2;
		friendlyAI4 = grunts_pistol.spawn_points_3;
		friendlyAI5 = grunts_pistol.spawn_points_4;
		friendlyAI6 = grunts_pistol.spawn_points_5;
		friendlyAI7 = grunts_pistol.spawn_points_6;
		friendlyAI8 = grunts_pistol.spawn_points_7;
		friendlyAI9 = grunts_pistol.spawn_points_8;
		friendlyAI10 = grunts_pistol.spawn_points_9;
		friendlyAI11 = grunts_pistol.spawn_points_10;
		friendlyAI12 = grunts_pistol.spawn_points_11;
		friendlyAI13 = grunts_pistol.spawn_points_12;
		friendlyAI14 = grunts_pistol.spawn_points_13;
		friendlyAI15 = grunts_pistol.spawn_points_14;
	end
	if(name == "grunts_missile") then
		print("grunts_missile");
		friendlyAI1 = grunts_missile.spawn_points_0;
		friendlyAI2 = grunts_missile.spawn_points_1;
		friendlyAI3 = grunts_missile.spawn_points_2;
		friendlyAI4 = grunts_missile.spawn_points_3;
		friendlyAI5 = grunts_missile.spawn_points_4;
		friendlyAI6 = grunts_missile.spawn_points_5;
		friendlyAI7 = grunts_missile.spawn_points_6;
		friendlyAI8 = grunts_missile.spawn_points_7;
		friendlyAI9 = grunts_missile.spawn_points_8;
		friendlyAI10 = grunts_missile.spawn_points_9;
		friendlyAI11 = grunts_missile.spawn_points_10;
		friendlyAI12 = grunts_missile.spawn_points_11;
		friendlyAI13 = grunts_missile.spawn_points_12;
		friendlyAI14 = grunts_missile.spawn_points_13;
		friendlyAI15 = grunts_missile.spawn_points_14;
	end
	if(name == "jackals_rifle") then
		print("jackals_rifle");
		friendlyAI1 = jackals_rifle.spawn_points_0;
		friendlyAI2 = jackals_rifle.spawn_points_1;
		friendlyAI3 = jackals_rifle.spawn_points_2;
		friendlyAI4 = jackals_rifle.spawn_points_3;
		friendlyAI5 = jackals_rifle.spawn_points_4;
		friendlyAI6 = jackals_rifle.spawn_points_5;
		friendlyAI7 = jackals_rifle.spawn_points_6;
		friendlyAI8 = jackals_rifle.spawn_points_7;
		friendlyAI9 = jackals_rifle.spawn_points_8;
		friendlyAI10 = jackals_rifle.spawn_points_9;
		friendlyAI11 = jackals_rifle.spawn_points_10;
		friendlyAI12 = jackals_rifle.spawn_points_11;
		friendlyAI13 = jackals_rifle.spawn_points_12;
		friendlyAI14 = jackals_rifle.spawn_points_13;
		friendlyAI15 = jackals_rifle.spawn_points_14;
	end
	if(name == "jackals_pistol") then
		print("jackals_pistol");
		friendlyAI1 = jackals_pistol.spawn_points_0;
		friendlyAI2 = jackals_pistol.spawn_points_1;
		friendlyAI3 = jackals_pistol.spawn_points_2;
		friendlyAI4 = jackals_pistol.spawn_points_3;
		friendlyAI5 = jackals_pistol.spawn_points_4;
		friendlyAI6 = jackals_pistol.spawn_points_5;
		friendlyAI7 = jackals_pistol.spawn_points_6;
		friendlyAI8 = jackals_pistol.spawn_points_7;
		friendlyAI9 = jackals_pistol.spawn_points_8;
		friendlyAI10 = jackals_pistol.spawn_points_9;
		friendlyAI11 = jackals_pistol.spawn_points_10;
		friendlyAI12 = jackals_pistol.spawn_points_11;
		friendlyAI13 = jackals_pistol.spawn_points_12;
		friendlyAI14 = jackals_pistol.spawn_points_13;
		friendlyAI15 = jackals_pistol.spawn_points_14;
	end
	if(name == "hunters") then
		print("hunters");
		friendlyAI1 = hunters.spawn_points_0;
		friendlyAI2 = hunters.spawn_points_1;
		friendlyAI3 = hunters.spawn_points_2;
		friendlyAI4 = hunters.spawn_points_3;
		friendlyAI5 = hunters.spawn_points_4;
		friendlyAI6 = hunters.spawn_points_5;
		friendlyAI7 = hunters.spawn_points_6;
		friendlyAI8 = hunters.spawn_points_7;
		friendlyAI9 = hunters.spawn_points_8;
		friendlyAI10 = hunters.spawn_points_9;
		friendlyAI11 = hunters.spawn_points_10;
		friendlyAI12 = hunters.spawn_points_11;
		friendlyAI13 = hunters.spawn_points_12;
		friendlyAI14 = hunters.spawn_points_13;
		friendlyAI15 = hunters.spawn_points_14;
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
	if(test == "phantom_exit") then
		Exit_Phantom();
	end
	if(test == "pelican_exit") then
		Exit_Pelican();
	end
	if(test == "pelican_enter") then
		Enter_Pelican();
	end
	if(test == "shade_anti_air_fire") then
		Firetest_shade(friendlyAI1, shade_anti_air);
	end
	if(test == "shade_flak_cannon_fire") then
		Firetest_shade(friendlyAI1, shade_flak_cannon);
	end
	if(test == "shade_plasma_cannon_fire") then
		Firetest_shade(friendlyAI1, shade_plasma_cannon);
	end
	if(test == "shade_anti_air_exit") then
		Exit_shade(friendlyAI1, shade_anti_air);
	end
	if(test == "shade_flak_cannon_exit") then
		Exit_shade(friendlyAI1, shade_flak_cannon);
	end
	if(test == "shade_plasma_turret_exit") then
		Exit_shade(friendlyAI1, shade_plasma_cannon);
	end
	if(test == "shade_anti_air_turret_enter") then
		Enter_shade(friendlyAI1, shade_anti_air);
	end
	if(test == "shade_flak_turret_enter") then
		Enter_shade(friendlyAI1, shade_flak_cannon);
	end
	if(test == "shade_plasma_cannon_enter") then
		Enter_shade(friendlyAI1, shade_plasma_cannon);
	end
	if(test == "large_cov_drop_pod_exit") then
		Exit_Large_Cov_Drop_Pod(friendlyAI1, friendlyAI2, friendlyAI3, friendlyAI4, friendlyAI5, friendlyAI6, cov_drop_pod_large);
	end
	if(test == "plasma_turret_fire") then
		Firetest_Plasma_Turret(friendlyAI1, plasma_turret);
	end
	if(test == "plasma_turret_watchtower_fire") then
		Firetest_Plasma_Turret(friendlyAI1, plasma_turret_watchtower);
	end
	if(test == "plasma_turret_no_detach_fire") then
		Firetest_Plasma_Turret(friendlyAI1, plasma_turret_nodetach);
	end
	if(test == "plasma_turret_enter") then
		Enter_Plasma_Turret(friendlyAI1, plasma_turret);
	end
	if(test == "plasma_turret_watchtower_enter") then
		Enter_Plasma_Turret(friendlyAI1, plasma_turret_watchtower);
	end
	if(test == "plasma_turret_no_detach_enter") then
		Enter_Plasma_Turret(friendlyAI1, plasma_turret_nodetach);
	end
	if(test == "plasma_turret_exit") then
		Exit_Plasma_Turret(friendlyAI1, plasma_turret);
	end
	if(test == "plasma_turret_watchtower_exit") then
		Exit_Plasma_Turret(friendlyAI1, plasma_turret_watchtower);
	end
	if(test == "plasma_turret_no_detach_exit") then
		Exit_Plasma_Turret(friendlyAI1, plasma_turret_nodetach);
	end
end

;=========== aimtest script ======================;

(script command_script standing_vehicle

(print "Firing Above")
	(sleep 60)
(print "Above back left side")
	(sleep 60)
	(cs_aim_object 1 veh_above_left_back)	
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

;==================================== shade tests =================================;

;===================== Fire tests ================;

script static void Firetest_shade(ai driver, object_name objName)
	Fire_Helper(null_squad, null_seat, driver, shade_d, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, objName);
end

;===================== Enter shade test ================;

script static void Enter_shade(ai driver, object_name objName)
	Enter_Helper(null_squad, null_seat, driver, shade_d, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, objName);
end

;===================== Exit shade test ================;

script static void Exit_shade(ai driver, object_name objName)
	Exit_Helper(null_squad, null_seat, driver, shade_d, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, objName);
end

;==================================== plasma turret tests =================================;

;===================== Fire tests ================;

script static void Firetest_Plasma_Turret(ai driver, object_name objName)
	Fire_Helper(null_squad, null_seat, driver, turret_g, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, objName);
end

;===================== Enter shade test ================;

script static void Enter_Plasma_Turret(ai driver, object_name objName)
	Enter_Helper(null_squad, null_seat, driver, turret_g, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, objName);
end

;===================== Exit shade test ================;

script static void Exit_Plasma_Turret(ai driver, object_name objName)
	Exit_Helper(null_squad, null_seat, driver, turret_g, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, null_squad, null_seat, objName);
end

;==================================== Large Cov Drop Tests ===============================

script static void Exit_Large_Cov_Drop_Pod(ai passenger1, ai passenger2, ai passenger3, ai passenger4, ai passenger5, ai passenger6, object_name objName)
	Exit_Helper(
		passenger1, drop_pod_large_p_1, 
		passenger2, drop_pod_large_p_1_b, 
		passenger3, drop_pod_large_p_2_t, 
		passenger4, drop_pod_large_p_2_b, 
		passenger5, drop_pod_large_p_3_t, 
		passenger6, drop_pod_large_p_3_b, 
		objName,
		spawn_points.vehicle_air);
end

//=============Phantom Tests=================//

script static void Exit_Phantom()
	object_create_anew(phantom);
	ai_place(friendlyAI1);	
	ai_place(friendlyAI2);
	ai_place(friendlyAI3);
	
	veh = vehicle(phantom);
	object_teleport_to_ai_point(veh, spawn_points.vehicle_air);
	
	//Put the driver in the seat and he will load everyone
	ai_vehicle_enter_immediate(friendlyAI1, veh, phantom_d);
	ai_vehicle_enter_immediate(friendlyAI2, veh, phantom_g);
	ai_vehicle_enter_immediate(friendlyAI3, veh, phantom_g);
	cs_run_command_script(friendlyAI1, cs_phantom);
end

script command_script cs_phantom()
	cs_ignore_obstacles( ai_current_actor, TRUE );
	sq = ai_get_squad(ai_current_actor);
	ai_set_blind (ai_current_actor, TRUE);
	ai_set_deaf (ai_current_actor, TRUE);
	
	f_load_phantom( sq, "left", friendlyAI4, friendlyAI7, friendlyAI10, friendlyAI13 );
	f_load_phantom( sq, "right", friendlyAI5, friendlyAI8, friendlyAI11, friendlyAI14 );
	f_load_phantom( sq, "chute", friendlyAI6, friendlyAI9, friendlyAI12, friendlyAI15 );
	
	sleep( 30 * 2.0 );	
	cs_fly_to( ps_phantom_dropoff.p0 );
	
	f_unload_phantom( sq, "left" );
	f_unload_phantom( sq, "right" );
	f_unload_phantom( sq, "chute" );
	
	sleep( 30 * 2.0 );
	cs_fly_to( ps_phantom_dropoff.p2 );
	sleep( 30 * 3.0 );
	ai_erase_all();
end

//=============Pelican Tests=================//

script static void Exit_Pelican()
	object_create_anew(Pelican);
	ai_place(friendlyAI1);	
	ai_place(friendlyAI2);
	ai_place(friendlyAI3);
	ai_place(friendlyAI4);
	ai_place(friendlyAI5);
	ai_place(friendlyAI6);
	ai_place(friendlyAI7);
	
	veh = vehicle(Pelican);
	object_teleport_to_ai_point(veh, ps_phantom_dropoff.p1);
	
	//Put the driver in the seat and he will load everyone
	ai_vehicle_enter_immediate(friendlyAI1, veh, Pelican_d);
	//ai_vehicle_enter_immediate(friendlyAI2, veh, Pelican_g);
	//ai_vehicle_enter_immediate(friendlyAI3, veh, Pelican_g);
	cs_run_command_script(friendlyAI1, cs_Pelican);
end

script static void Enter_Pelican()
	object_create_anew(Pelican);
	ai_place(friendlyAI1);	
	ai_place(friendlyAI2);
	ai_place(friendlyAI3);
	ai_place(friendlyAI4);
	ai_place(friendlyAI5);
	ai_place(friendlyAI6);
	ai_place(friendlyAI7);
	ai_place(friendlyAI8);
	ai_place(friendlyAI9);
	ai_place(friendlyAI10);
	ai_place(friendlyAI11);
	ai_place(friendlyAI12);
	ai_place(friendlyAI13);
	
	veh = vehicle(Pelican);
	object_teleport_to_ai_point(veh, ps_phantom_dropoff.p4);
	
	//Put the driver in the seat and he will load everyone
	ai_vehicle_enter_immediate(friendlyAI1, veh, Pelican_d);
	//ai_vehicle_enter_immediate(friendlyAI2, veh, Pelican_g);
	//ai_vehicle_enter_immediate(friendlyAI3, veh, Pelican_g);
	cs_run_command_script(friendlyAI1, cs_Pelican1);
end

script command_script cs_Pelican()
	cs_ignore_obstacles( ai_current_actor, TRUE );
	sq = ai_get_squad(ai_current_actor);
	ai_set_blind (ai_current_actor, TRUE);
	ai_set_deaf (ai_current_actor, TRUE);
	
	//f_load_Pelican( sq, "left", friendlyAI4, friendlyAI7);
	//f_load_Pelican( sq, "right", friendlyAI5, friendlyAI8);
	ai_vehicle_enter_immediate(friendlyAI2, pelican);
	ai_vehicle_enter_immediate(friendlyAI3, pelican);
	ai_vehicle_enter_immediate(friendlyAI4, pelican);
	ai_vehicle_enter_immediate(friendlyAI5, pelican);
	ai_vehicle_enter_immediate(friendlyAI6, pelican);
	ai_vehicle_enter_immediate(friendlyAI7, pelican);
	
	sleep( 30 * 2.0 );	
	cs_fly_to( ps_phantom_dropoff.p1 );
	
	sleep(120);
	f_unload_pelican_all(pelican);
	
	sleep( 30 * 2.0 );
	cs_fly_to( ps_phantom_dropoff.p2 );
	sleep( 30 * 3.0 );
	ai_erase_all();
end

script command_script cs_Pelican1()
	cs_ignore_obstacles( ai_current_actor, TRUE );
	sq = ai_get_squad(ai_current_actor);
	ai_set_blind (ai_current_actor, TRUE);
	ai_set_deaf (ai_current_actor, TRUE);

	vehicle_hover(pelican, true);
	sleep(1);	
	custom_animation_hold_last_frame (pelican, "objects\vehicles\human\storm_pelican\storm_pelican.model_animation_graph", "vehicle:door_open_close", false);
	sleep(60);
	
	ai_vehicle_enter(friendlyAI2, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI3, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI4, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI5, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI6, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI7, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI8, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI9, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI10, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI11, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI12, pelican);
	sleep(60);
	ai_vehicle_enter(friendlyAI13, pelican);
	
	sleep( 30 * 2.0 );
	
	vehicle_hover(pelican, false);
	cs_fly_to( ps_phantom_dropoff.p2 );
	sleep( 30 * 3.0 );
	ai_erase_all();
end

script command_script cs_jump_out()
	cs_go_to(ps_phantom_dropoff.p3, 0.3);
end

; =================================================================================================
; GLOBAL_PELICAN.HSC
; HOW TO USE:
; 	1. Open your scenario in Sapien
;	2. In the menu bar, open the "Scenarios" menu, then select "Add Mission Script"
;	3. Point the dialogue to this file: main\data\globals\global_pelican.hsc
; =================================================================================================
global boolean b_debug_pelican = true;

script static void	f_load_pelican(vehicle pelican, string load_side, ai load_squad_01, ai load_squad_02)
	// place ai 
	ai_place(load_squad_01);
	ai_place(load_squad_02);
	sleep(1);
	
	if(load_side == "left") then
		begin
			if (b_debug_pelican) then
				print("load pelican left...");
			end
			ai_vehicle_enter_immediate(load_squad_01, pelican);
			ai_vehicle_enter_immediate(load_squad_02, pelican);
		end
	end
	if(load_side == "right") then
		begin
			if(b_debug_pelican) then
				print("load pelican right...");
			end
			ai_vehicle_enter_immediate(load_squad_01, pelican, "pelican_p_r01");
			ai_vehicle_enter_immediate(load_squad_02, pelican, "pelican_p_r02");
		end
	end
	if(load_side == "dual") then
		begin
			if(b_debug_pelican) then
				print("load pelican dual...");
			end
			ai_vehicle_enter_immediate(load_squad_01, pelican, "pelican_p_l01");
			ai_vehicle_enter_immediate(load_squad_01, pelican, "pelican_p_r01");
		end
	end
end

script static void f_unload_pelican_all (vehicle pelican)
	vehicle_hover(pelican, true);
	sleep(1);
	vehicle_hover(pelican, false);
	custom_animation_hold_last_frame (pelican, "objects\vehicles\human\storm_pelican\storm_pelican.model_animation_graph", "vehicle:door_open_close", false);
	sleep(60);
		cs_run_command_script(friendlyAI2, cs_jump_out);
	cs_run_command_script(friendlyAI3, cs_jump_out);
	cs_run_command_script(friendlyAI4, cs_jump_out);
	cs_run_command_script(friendlyAI5, cs_jump_out);
	cs_run_command_script(friendlyAI6, cs_jump_out);
	cs_run_command_script(friendlyAI7, cs_jump_out);
	cs_run_command_script(friendlyAI8, cs_jump_out);
	cs_run_command_script(friendlyAI9, cs_jump_out);
	cs_run_command_script(friendlyAI10, cs_jump_out);
	cs_run_command_script(friendlyAI11, cs_jump_out);
	cs_run_command_script(friendlyAI12, cs_jump_out);
	cs_run_command_script(friendlyAI13, cs_jump_out);
	begin_random
		begin
			vehicle_unload(pelican, "pelican_p_l01");
			sleep(random_range(10, 20));
		end
		begin
			vehicle_unload(pelican, "pelican_p_l03");
			sleep(random_range(10, 20));
		end
		begin
			vehicle_unload(pelican, "pelican_p_r");
			sleep(random_range(10, 20));
		end
		begin
			vehicle_unload(pelican, "pelican_p_r01");
			sleep(random_range(10, 20));
		end
		begin
			vehicle_unload(pelican, "pelican_p_r02");
			sleep(random_range(10, 20));
		end
		begin
			vehicle_unload(pelican, "pelican_p_r03");
			sleep(random_range(10, 20));
		end
		begin
			vehicle_unload(pelican, "pelican_p_r04");
			sleep(random_range(10, 20));
		end
		begin
			vehicle_unload(pelican, "pelican_p_r05");
			sleep(random_range(10, 20));
		end
	end		
	cs_run_command_script(friendlyAI2, cs_jump_out);
	cs_run_command_script(friendlyAI3, cs_jump_out);
	cs_run_command_script(friendlyAI4, cs_jump_out);
	cs_run_command_script(friendlyAI5, cs_jump_out);
	cs_run_command_script(friendlyAI6, cs_jump_out);
	cs_run_command_script(friendlyAI7, cs_jump_out);
	cs_run_command_script(friendlyAI8, cs_jump_out);
	cs_run_command_script(friendlyAI9, cs_jump_out);
	cs_run_command_script(friendlyAI10, cs_jump_out);
	cs_run_command_script(friendlyAI11, cs_jump_out);
	cs_run_command_script(friendlyAI12, cs_jump_out);
	cs_run_command_script(friendlyAI13, cs_jump_out);
	sleep(360);
	custom_animation_hold_last_frame (pelican, "objects\vehicles\human\storm_pelican\storm_pelican.model_animation_graph", "vehicle:door_open_close", true);
	unit_stop_custom_animation(pelican);
end

; new pelican global scripts =======================================================================================================================================

script static void f_load_pelican_cargo (vehicle pelican, string load_type, ai load_squad_01, ai load_squad_02)	 
	if (load_type == "large") then
		ai_place(load_squad_01);
		sleep(1);
		vehicle_load_magic(pelican, "pelican_lc", ai_vehicle_get_from_squad(load_squad_01, 0));
	end
	if (load_type == "small") then
		ai_place(load_squad_01);
		ai_place(load_squad_02);
		sleep(1);
	end
end

script static void f_unload_pelican_cargo(vehicle pelican, string load_type)
	vehicle_unload(pelican, "pelican_lc");
end

 