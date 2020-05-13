(script continuous spawn_gymStorm

	(sleep_until (volume_test_players spawn_gymstormgrunts) 1)

		(ai_place gymStormGrunt_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count gymStormGrunt_squad) 0))
	
	(sleep (* 30 1))
)
(script continuous spawn_gymJackal

	(sleep_until (volume_test_players spawn_gymjackals) 1)

		(ai_place gymJackal_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count gymJackal_squad) 0))
	
	(sleep (* 30 1))
)
(script continuous spawn_gymElite

	(sleep_until (volume_test_players spawn_gymElites) 1)

		(ai_place gymElite_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count gymElite_squad) 0))
	
	(sleep (* 30 1))
)
(script continuous spawn_gymPawn

	(sleep_until (volume_test_players spawn_gympawns) 1)

		(ai_place gymPawn_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count gymPawn_squad) 0))
	
	(sleep (* 30 1))
)
(script continuous spawn_gymHunter

	(sleep_until (volume_test_players spawn_gymhunters) 1)

		(ai_place gymHunter_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count gymHunter_squad) 0))
	
	(sleep (* 30 1))
)
(script continuous spawn_gymKnight

	(sleep_until (volume_test_players spawn_gymknights) 1)

		(ai_place gymKnight_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count gymKnight_squad) 0))
	
	(sleep (* 30 1))
)
(script continuous spawn_gymBishop

	(sleep_until (volume_test_players spawn_gymbishops) 1)

		(ai_place gymBishop_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count gymBishop_squad) 0))
	
	(sleep (* 30 1))
)
(script continuous spawn_BishopTurret

	(sleep_until (volume_test_players spawn_turret) 1)

		(ai_place turret_squad)


	(sleep 1)
	
		
	(sleep_until (= (ai_living_count turret_squad) 0))
	
	(sleep (* 30 1))
)


script static void OnTurretActivated(long taskIndex, long taskType, unit targetObj)
	ActivateTurret(object_get_ai(vehicle_driver(targetObj)), targetObj);
end


script static void ActivateTurret(ai turretPilot, unit turretVeh)
	print("Turret Activated");
	ai_object_set_team (turretPilot, player);
	unit_open (turretVeh);
	object_can_take_damage (ai_vehicle_get_from_spawn_point(turretPilot));
	ai_braindead (turretPilot, false);
	ai_disregard (ai_actors (turretPilot), false);
	unit_set_current_vitality (turretVeh, 30, 0);
	sleep_until (object_get_health (turretVeh) <= 0, 1);
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point(turretPilot));
	print ("Turret Destroyed");
	ai_braindead (turretPilot, true);
	ai_disregard (ai_actors (turretPilot), true);
	unit_close (turretVeh);
	CreateDynamicTask(0, 0, turretVeh, OnTurretActivated, 0);
end

script command_script cs_stay_in_turret
	print("Initializing Turret.");
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	
	ai_place (ai_current_actor);
	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	ai_braindead (ai_current_actor, true);
	
	CreateDynamicTask(0, 0, ai_vehicle_get(ai_current_actor), OnTurretActivated, 0);
end

script static void OnCompleteProtoSpawn()
	print("I LIVE. RUN COWARD!");
end

script command_script cs_proto_spawn
	print("pawn sleeping");
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
end

script command_script cs_bishop_spawn
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
end

script command_script cs_knight_phase_spawn()
	cs_phase_in();
	print("holy shit! that knight just came out of the ground!");
end

script command_script cs_move_test()
	
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
	cs_go_to (move_test.p0, 0.5);
	cs_go_to (move_test.p1, 0.5);
	cs_go_to (move_test.p2, 0.5);
	cs_go_to (move_test.p3, 0.5);
	cs_go_to (move_test.p4, 0.5);
	cs_go_to (move_test.p5, 0.5);
	cs_go_to (move_test.p6, 0.5);
	cs_go_to (move_test.p7, 0.5);
	cs_go_to (move_test.p8, 0.5);
	cs_go_to (move_test.p9, 0.0);
	cs_go_to_and_face(move_test.p9, look_test.p0);
	sleep(30);

	print  ("moving while facing north");
	cs_aim( TRUE, look_test.p0 );
	cs_face( TRUE, look_test.p0 );
	cs_shoot_point( TRUE, look_test.p0 );
	cs_go_to (move_test.p0, 0.5);
	cs_go_to (move_test.p1, 0.5);
	cs_go_to (move_test.p2, 0.5);
	cs_go_to (move_test.p3, 0.5);
	cs_go_to (move_test.p4, 0.5);
	cs_go_to (move_test.p5, 0.5);
	cs_go_to (move_test.p6, 0.5);
	cs_go_to (move_test.p7, 0.5);
	cs_go_to (move_test.p8, 0.5);
	cs_go_to (move_test.p9, 0.0);
	cs_go_to_and_face(move_test.p9, look_test.p1);
	sleep(30);

	print  ("moving while facing east");
	cs_aim( TRUE, look_test.p1 );
	cs_face( TRUE, look_test.p1 );
	cs_shoot_point( TRUE, look_test.p1 );
	cs_go_to (move_test.p0, 0.5);
	cs_go_to (move_test.p1, 0.5);
	cs_go_to (move_test.p2, 0.5);
	cs_go_to (move_test.p3, 0.5);
	cs_go_to (move_test.p4, 0.5);
	cs_go_to (move_test.p5, 0.5);
	cs_go_to (move_test.p6, 0.5);
	cs_go_to (move_test.p7, 0.5);
	cs_go_to (move_test.p8, 0.5);
	cs_go_to (move_test.p9, 0.0);
	sleep(30);

	ai_erase (ai_current_actor);

end

script static void elite_move_test()
	print  ("go go eites!");
	ai_place (gymElite_squad, 1);
	cs_run_command_script (gymElite_squad, cs_move_test);
end

script static void grunt_move_test()
	print  ("go go grunts!");
	ai_place (gymStormGrunt_squad, 1);
	cs_run_command_script (gymStormGrunt_squad, cs_move_test);
end

script static void knight_move_test()
	print  ("go go Knights!");
	ai_place (gymKnight_squad, 1);
	cs_run_command_script (gymKnight_squad, cs_move_test);
end

script static void pawn_move_test()
	print  ("go go Pawns!");
	ai_place (gymPawn_squad, 1);
	cs_run_command_script (gymPawn_squad, cs_move_test);
end




script command_script cs_dir_change_test_setup()
	
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	

	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	
	print  ("moving while facing destination");
	cs_aim( TRUE, look_test.p2 );
	cs_face( TRUE, look_test.p2 );
	cs_shoot_point( TRUE, look_test.p2 );
	cs_go_to (move_test.p12);
	cs_go_to (move_test.p10);
	cs_go_to (move_test.p12);
	cs_go_to (move_test.p11);
	cs_go_to (move_test.p12);
end

script command_script cs_dir_change_center()
	cs_go_to (move_test.p12);
end

script command_script cs_dir_change_a()
	
	cs_aim( TRUE, look_test.p2 );
	cs_face( TRUE, look_test.p2 );
	cs_shoot_point( TRUE, look_test.p2 );
	cs_go_to (move_test.p10);
end

script command_script cs_dir_change_b()
	
	cs_aim( TRUE, look_test.p2 );
	cs_face( TRUE, look_test.p2 );
	cs_shoot_point( TRUE, look_test.p2 );
	cs_go_to (move_test.p11);
end

script command_script cs_dir_change_c()
	
	cs_aim( TRUE, look_test.p1 );
	cs_face( TRUE, look_test.p1 );
	cs_shoot_point( TRUE, look_test.p1 );
	cs_go_to (move_test.p10);
end

script command_script cs_dir_change_d()
	
	cs_aim( TRUE, look_test.p1 );
	cs_face( TRUE, look_test.p1 );
	cs_shoot_point( TRUE, look_test.p1 );
	cs_go_to (move_test.p11);
end

script static void elite_ping_pong()
	print  ("go go eites!");
	ai_place (gymElite_squad, 1);
	cs_run_command_script (gymElite_squad, cs_dir_change_test_setup);
	sleep(140);
	
	static short s_counter = 0;
	static short s_sleep = 30;
	
	cs_run_command_script (gymElite_squad, cs_dir_change_center);
	sleep(s_sleep);
	
	repeat
		s_counter = 0;

		repeat
			cs_run_command_script (gymElite_squad, cs_dir_change_b);
			sleep(s_sleep);
			cs_run_command_script (gymElite_squad, cs_dir_change_a);
			sleep(s_sleep);
			s_counter = s_counter + 1;
		until(s_counter > 4, 4);

		cs_run_command_script (gymElite_squad, cs_dir_change_center);
		sleep(10);

		repeat
			cs_run_command_script (gymElite_squad, cs_dir_change_c);
			sleep(s_sleep);
			cs_run_command_script (gymElite_squad, cs_dir_change_d);
			sleep(s_sleep);
			s_counter = s_counter + 1;
		until(s_counter > 8, 4);
	
		s_sleep = s_sleep - 5;

	until(s_sleep < 5, 4);


	ai_erase (gymElite_squad);
end

script static void grunt_ping_pong()
	print  ("go go grunts!");
	ai_place (gymStormGrunt_squad, 1);
	cs_run_command_script (gymStormGrunt_squad, cs_dir_change_test_setup);
	sleep(140);
	
	static short s_counter = 0;
	static short s_sleep = 30;
	
	cs_run_command_script (gymStormGrunt_squad, cs_dir_change_center);
	sleep(s_sleep);
	
	repeat
		s_counter = 0;

		repeat
			cs_run_command_script (gymStormGrunt_squad, cs_dir_change_b);
			sleep(s_sleep);
			cs_run_command_script (gymStormGrunt_squad, cs_dir_change_a);
			sleep(s_sleep);
			s_counter = s_counter + 1;
		until(s_counter > 4, 4);

		cs_run_command_script (gymStormGrunt_squad, cs_dir_change_center);
		sleep(10);

		repeat
			cs_run_command_script (gymStormGrunt_squad, cs_dir_change_c);
			sleep(s_sleep);
			cs_run_command_script (gymStormGrunt_squad, cs_dir_change_d);
			sleep(s_sleep);
			s_counter = s_counter + 1;
		until(s_counter > 8, 4);
	
		s_sleep = s_sleep - 5;

	until(s_sleep < 5, 4);


	ai_erase (gymStormGrunt_squad);
end
script static void knight_jump_test()
	print  ("jump knights!");
	ai_place (knight_jumpers, 1);
	cs_run_command_script (knight_jumpers, cs_jump_test_1);
end
script static void pawn_jump_test()
	print  ("jump pawns!");
	ai_place (pawn_jumpers, 1);
	cs_run_command_script (pawn_jumpers, cs_jump_test_1);
end
script static void elite_jump_test()
	print  ("jump elites!");
	ai_place (elite_jumpers, 2);
	cs_run_command_script (elite_jumpers, cs_jump_test_1);
end
script static void grunt_jump_test()
	print  ("jump grunts!");
	ai_place (grunt_jumpers, 2);
	cs_run_command_script (grunt_jumpers, cs_jump_test_1);
end
script static void jackal_jump_test()
	print  ("jump jackals!");
	ai_place (jackal_jumpers, 2);
	cs_run_command_script (jackal_jumpers, cs_jump_test_1);
end
script static void marine_jump_test()
	print  ("jump marines!");
	ai_place (marine_jumpers, 1);
	cs_run_command_script (marine_jumpers, cs_jump_test_1);
end
script command_script cs_go_berserk()
  print("berserk prep");
	 cs_abort_on_alert( FALSE );
	 cs_abort_on_damage( FALSE ); 
 	ai_berserk( ai_current_actor, TRUE );	
  print("grrrreat!");
end
script static void spawn_pawns()
	print("here come the pawns");
	ai_place_with_shards(spawning_pawns, 1);
end
script command_script cs_stow_it()
	cs_stow(TRUE);		
end

script command_script cs_jump_test_1()
	
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
	cs_go_to (jump_test_1.p0, 0.3);
	cs_go_to (jump_test_1.p1, 0.3);
	cs_go_to (jump_test_1.p2, 0.3);
	cs_go_to (jump_test_1.p3, 0.3);
	cs_go_to (jump_test_1.p4, 0.3);
	sleep(30);
	
	ai_erase (ai_current_actor);
end

script static void chief_test_slow()
	print  ("chief slow");
	ai_place (masterchief_test, 1);
	cs_run_command_script (masterchief_test, cs_chief_test_slow);
end
script command_script cs_chief_test_slow()
	
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	

	
	print  ("move slow");
	cs_move_towards_point (chief_test.p0, 2);

	sleep(30);
	
	ai_erase (ai_current_actor);
end