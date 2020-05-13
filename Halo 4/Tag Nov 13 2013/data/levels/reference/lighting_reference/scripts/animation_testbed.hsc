script static void pawn_navtest()
	print  ("NAV TEST!");
	cs_run_command_script (pawn_squad, climb_test);
end

script command_script climb_test()
	
	print  ("GO GO PAWN!!!");
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	

	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	
	print  ("moving to p0");
	cs_go_to (navpoints.p0, 0.01);
	print  ("moving to p1");
	cs_go_to (navpoints.p1, 0.01);
	print  ("moving to p2");
	cs_go_to (navpoints.p2, 0.01);
	print  ("moving to p3");
	cs_go_to (navpoints.p3, 0.01);
	print  ("moving to p4");
	cs_go_to (navpoints.p4, 0.01);
	print  ("moving to p5");
	cs_go_to (navpoints.p5, 0.01);
	print  ("moving to p6");
	cs_go_to (navpoints.p6, 0.01);
	print  ("moving to p7");
	cs_go_to (navpoints.p7, 0.01);
	print  ("moving to p8");
	cs_go_to (navpoints.p8, 0.01);
	print  ("moving to p9");
	cs_go_to (navpoints.p9, 0.01);
	print  ("moving to p0");
	cs_go_to (navpoints.p0, 0.01);

	print  ("DONE!!!");
end

script static void pawn_jumptest()
	print  ("JUMP TEST!");
	cs_run_command_script (pawn_squad, jump_test);
end

script command_script jump_test()
	
	print  ("GO GO PAWN!!!");
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	

	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	
	print  ("moving to p0");
	cs_go_to (jump.p0, 0.01);
	print  ("moving to p1");
	cs_go_to (jump.p1, 0.01);
	print  ("moving to p2");
	cs_go_to (jump.p2, 0.01);

	print  ("DONE!!!");
end