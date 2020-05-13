
script startup forts_ai_test_mission()
	wake(start_charlie_scout);
	wake(start_alpha_stand);
	wake(start_bravo_stand);
	wake(start_charlie_stand);
end
script dormant start_charlie_scout()
	print("Charlie Scout");
	sleep_until (volume_test_players (trigger_charlie_skirmish), 1);
	print("Target Sighted");
	sleep(90);
	ai_set_objective(charlie_pawn_scout, obj_charlie_stand);
	wake(start_charlie_skirmish);
end
script dormant start_charlie_skirmish()
	print("W.L.T.D.O? Charlie");
	ai_place(charlie_pawn_skirmish);
	sleep_until (ai_living_count (charlie_pawn_skirmish) < 6);
	print("Pull Back");
	wake(start_alpha_skirmish);
        ai_set_objective(charlie_pawn_skirmish, obj_charlie_stand);
	sleep(450);
	ai_place(charlie_turret_skirmish);
	ai_place(charlie_bishop_skirmish);
	ai_set_objective(charlie_pawn_skirmish, obj_start_skirmish);
	ai_set_objective(charlie_pawn_scout, obj_start_skirmish);
	ai_set_objective(charlie_bishop_skirmish, obj_start_skirmish);
	print("Push Forward");
	sleep_until (volume_test_players (trigger_charlie_stand), 1);
	print("Pull Back");
        ai_set_objective(charlie_pawn_scout, obj_charlie_stand);
        ai_set_objective(charlie_pawn_skirmish, obj_charlie_stand);
        ai_set_objective(charlie_bishop_skirmish, obj_charlie_stand);
	sleep(300);
	sleep_until (volume_test_players (trigger_charlie_skirmish), 1);
        ai_set_objective(charlie_pawn_skirmish, obj_charlie_skirmish);	
end
script dormant start_alpha_stand()
	ai_place(alpha_bishop);
	sleep_until (volume_test_players (trigger_alpha_stand), 1);
	print("Alpha Knight");
	ai_place(Alpha_Knight);
	ai_set_objective(alpha_pawn_skirmish, obj_alpha_stand);
	sleep(60);
	wake(start_alpha_harass);
end
script dormant start_alpha_skirmish()
	print("W.L.T.D.O? Alpha");
	ai_place(alpha_pawn_skirmish);
	sleep(300);
	ai_set_objective(alpha_pawn_skirmish, obj_start_skirmish);
	sleep_until (ai_living_count (alpha_pawn_skirmish) < 3 or volume_test_players (trigger_alpha_stand), 1);
	ai_set_objective(alpha_pawn_skirmish, obj_alpha_stand);

end

script dormant start_alpha_harass()
	sleep_until (ai_living_count (alpha_pawn) < 3 or ai_living_count (alpha_bishop) < 2 or ai_living_count (alpha_pawn_skirmish) < 3);
	print("Alpha Harass");
	ai_place(alpha_bishop_2);
	ai_place(bravo_turret);
	ai_set_objective(alpha_knight, obj_bravo_stand);
	ai_set_objective(alpha_bishop, obj_bravo_stand);
	ai_set_objective(alpha_bishop_2, obj_bravo_stand);
	ai_set_objective(alpha_pawn, obj_bravo_stand);
end
script dormant start_bravo_stand()
	print("Bravo Stand");
	wake(start_bravo_skirmish);
end
script dormant start_bravo_skirmish()
	sleep_until (volume_test_players (trigger_bravo_skirmish), 1);
	ai_place(bravo_pawn_skirmish);
	ai_place(bravo_bishop);
	ai_place(bravo_pawn);
	print("Bravo skirmish");
	ai_set_objective(bravo_pawn_skirmish, obj_bravo_harass);
	ai_set_objective(bravo_knight, obj_bravo_harass);
	sleep(400);
	print("Bravo Stand");
	ai_set_objective(bravo_pawn_skirmish, obj_bravo_stand);
	ai_set_objective(bravo_knight, obj_bravo_stand);

end
script dormant start_charlie_stand()
	ai_place(charlie_knight);
	sleep_until (volume_test_players (trigger_charlie_stand), 1);
	print("Charlie Stand");
	ai_place(charlie_bishop);
	ai_place(charlie_pawn);
	ai_place(charlie_pawn_sniper);
end

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
	CreateDynamicTask(TT_INTERACT, FT_COMPANION, ai_vehicle_get(ai_current_actor), OnTurretActivated, 1);
end

script static void OnCompleteProtoSpawn()
	print("I LIVE. RUN COWARD!");
end

script command_script cs_proto_spawn
	print("pawn sleeping");
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 1);
end

script command_script cs_bishop_spawn
	print("bishop sleeping");
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
end


