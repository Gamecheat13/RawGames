global object hKnight_1 = ai_get_unit(knight_1.knight);
script startup qbr_knightjungle_mission()
	wake(prep_vignette);
	wake(audio_main);
end
script dormant prep_vignette()
	print("prep vignette");
	ai_place(knight_1);
	sleep(60);
	hKnight_1 = ai_get_unit(knight_1.knight);
	sleep_until(volume_test_players(tvingette_go),1);
	sleep(300);
	sleep_until(ai_living_count (knight_1) < 1);
	ai_place(knight_2);	
	print("knight in pipe");
	sleep(120);
	ai_place(bishop);
end

script dormant fallback()
	ai_set_objective(knight_2, ai_knight_z4);
	sleep(300);
	ai_set_objective(knight_2, ai_knight_z5);
end

script dormant advance()
ai_set_objective(knight_2, ai_knight_z4);
ai_set_objective(knight_1, ai_knight_z4);
sleep(150);
sleep_until(volume_test_players(tadvance_go),1);
ai_set_objective(knight_1, ai_knight_z3);
sleep(150);
ai_set_objective(knight_2, ai_knight_z3);
end

script static void KnightRezzed()
	print("get up");
end

script static void OnCompleteBishopSpawn()
	print("I LIVE. RUN COWARD!");
	ai_set_objective(knight_1, ai_knight_z3);
	wake(fallback);
	sleep_until(ai_living_count(bishop) < 1);
	wake(advance);
	
	// CreateDynamicTask(TT_RESURRECT, FT_COMPANION, hKnight_1, KnightRezzed, 0);
end

script command_script cs_bishop_spawn
	print("bishop sleeping");
  ai_enter_limbo(ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteBishopSpawn, 0);
end

script command_script cs_Knight2_phase
	print("Knight 2");
	cs_phase_to_point(PhasePointSet1.p0);
end

script dormant audio_main()
	//print("amb_qbrknightjungle_a01_loop");
	sound_looping_start("sound\storm\ambience\qbr\amb_qbrknightjungle_a01_loop", NONE, 1.0);
	
	sleep_until(volume_test_players(tvingette_go),1);
	
	//print("amb_qbrknightjungle_a02_loop");
	sound_looping_stop("sound\storm\ambience\qbr\amb_qbrknightjungle_a01_loop");
	sound_looping_start("sound\storm\ambience\qbr\amb_qbrknightjungle_a02_loop", NONE, 1.0);
	
	sleep_until(ai_living_count (knight_1) < 1 and
	            ai_living_count (knight_2) < 1 and
	            ai_living_count (bishop)   < 1);
	
	//print("amb_qbrknightjungle_a01_loop");
	sound_looping_stop("sound\storm\ambience\qbr\amb_qbrknightjungle_a02_loop");
	sound_looping_start("sound\storm\ambience\qbr\amb_qbrknightjungle_a01_loop", NONE, 1.0);
end