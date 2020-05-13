script startup the_bishopclub_mission()
	wake(start_BishopManifestation);
end
script dormant start_BishopManifestation()
	print("spawn ready");
	sleep_until (volume_test_players (trigger_bm), 1);
	ai_place(knight_bm);
end
script command_script cs_knight_phase
	cs_phase_to_point(phase_to.p0);
	sleep(90);
	cs_die(1);
end

script command_script cs_bishop_spawn
	print("bishop sleeping");
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
end

script static void OnCompleteProtoSpawn()
	print("I LIVE. RUN COWARD!");
end

