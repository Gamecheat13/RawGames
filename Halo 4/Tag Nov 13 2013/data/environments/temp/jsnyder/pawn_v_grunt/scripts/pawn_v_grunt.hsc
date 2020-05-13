
global short end_game = 0;

script startup pawn_v_grunt()



	local short round_num = 1;
	repeat
		reset_round();
		player_action_test_reset();
		sleep_until(player_action_test_jump(),1);
		
		begin_round(round_num);

		garbage_collect_unsafe();
		
		display_score(round_num);
		round_num = round_num + 1;
	until (1 == end_game, 1);
	
	sleep_s(12);
	
	final_results();
	
end

script static void reset_round()
	object_teleport (player0, start_point);
	player_disable_movement (1);
	unit_add_equipment (player0, none, true, true);
end

script static void player_free()
	player_disable_movement (0);
end

script static void begin_round(short round)
	set_text_lifespan (30);
	set_text_scale (5);
	set_text_color (255, 255, 0, 0);
	set_text_font(arame_regular_23); 
	
	// alignments
	set_text_alignment(center);
	set_text_margins(0.05, 0.0, 0.05, 0.0);	// l,r,t,b        
	set_text_indents(0,0); 
	set_text_justification(center);
	set_text_wrap(1, 1);
		
	show_text ("5");
	sleep_s(1);
	show_text ("4");
	sleep_s(1);
	show_text ("3");
	sleep_s(1);
	show_text ("2");
	sleep_s(1);
	show_text ("1");
	sleep_s(1);
	set_text_color (255, 0, 255, 0);
	show_text ("BEGIN");
	player_free();
	
	if (round == 1) then
		unit_add_equipment (player0, magnum, true, true);
		ai_place(grunts1);
		ai_place(grunts2);
		ai_place(grunts3);
		ai_kamikaze_disable (grunts1,1);
		ai_kamikaze_disable (grunts2,1);
		ai_kamikaze_disable (grunts3,1);
						
		thread (score_tracker(lil_obj, 1));
		
		sleep_until (ai_living_count (grunts1) == 0 and ai_living_count (grunts2) == 0 and ai_living_count (grunts3) == 0, 1);
	elseif (round == 2) then
		unit_add_equipment (player0, magnum, true, true);
		ai_place(pawns1);
		ai_place(pawns2);
		ai_place(pawns3);
						
		thread (score_tracker(lil_obj, 0));
		
		sleep_until (ai_living_count (pawns1) == 0 and ai_living_count (pawns2) == 0 and ai_living_count (pawns3) == 0, 1);
	elseif (round == 3) then
		unit_add_equipment (player0, br, true, true);
		ai_place(grunts1);
		ai_place(grunts2);
		ai_place(grunts3);
		ai_kamikaze_disable (grunts1,1);
		ai_kamikaze_disable (grunts2,1);
		ai_kamikaze_disable (grunts3,1);
						
		thread (score_tracker(lil_obj, 1));
		
		sleep_until (ai_living_count (grunts1) == 0 and ai_living_count (grunts2) == 0 and ai_living_count (grunts3) == 0, 1);
	elseif (round == 4) then
		unit_add_equipment (player0, br, true, true);
		ai_place(pawns1);
		ai_place(pawns2);
		ai_place(pawns3);
						
		thread (score_tracker(lil_obj, 0));
		
		sleep_until (ai_living_count (pawns1) == 0 and ai_living_count (pawns2) == 0 and ai_living_count (pawns3) == 0, 1);
	elseif (round == 5) then
		unit_add_equipment (player0, light_rifle, true, true);
		ai_place(grunts1);
		ai_place(grunts2);
		ai_place(grunts3);
		ai_kamikaze_disable (grunts1,1);
		ai_kamikaze_disable (grunts2,1);
		ai_kamikaze_disable (grunts3,1);
						
		thread (score_tracker(lil_obj, 1));
		
		sleep_until (ai_living_count (grunts1) == 0 and ai_living_count (grunts2) == 0 and ai_living_count (grunts3) == 0, 1);
	elseif (round == 6) then
		unit_add_equipment (player0, light_rifle, true, true);
		ai_place(pawns1);
		ai_place(pawns2);
		ai_place(pawns3);
						
		thread (score_tracker(lil_obj, 0));
		
		sleep_until (ai_living_count (pawns1) == 0 and ai_living_count (pawns2) == 0 and ai_living_count (pawns3) == 0, 1);
	elseif (round == 7) then
		unit_add_equipment (player0, dmr, true, true);
		ai_place(grunts1);
		ai_place(grunts2);
		ai_place(grunts3);
		ai_kamikaze_disable (grunts1,1);
		ai_kamikaze_disable (grunts2,1);
		ai_kamikaze_disable (grunts3,1);
						
		thread (score_tracker(lil_obj, 1));
		
		sleep_until (ai_living_count (grunts1) == 0 and ai_living_count (grunts2) == 0 and ai_living_count (grunts3) == 0, 1);
	elseif (round == 8) then
		unit_add_equipment (player0, dmr, true, true);
		ai_place(pawns1);
		ai_place(pawns2);
		ai_place(pawns3);
						
		thread (score_tracker(lil_obj, 0));
		
		sleep_until (ai_living_count (pawns1) == 0 and ai_living_count (pawns2) == 0 and ai_living_count (pawns3) == 0, 1);
	else
		end_game = 1;
	end
end

global long total_grunt_score = 0;
global long total_pawn_score = 0;
global long total_score = 0;
global long round_score = 0;

script static void score_tracker(ai tracked_task, boolean is_grunt_round)
	local long prev_kill_tick = game_tick_get();
	local long delta_tick = 0;

	local short body_count = ai_living_count(tracked_task);
	local short body_count_prev = ai_living_count(tracked_task);
	
	local long current_score = 1000;
		
	repeat
		body_count = ai_living_count(tracked_task);
		
		if (body_count_prev != body_count) then
			print ("update score");
			
			delta_tick = game_tick_get() - prev_kill_tick;
			
			current_score = current_score - delta_tick;
			
			// body update
			body_count_prev = body_count;
			prev_kill_tick = game_tick_get();
		end
	until (ai_living_count(tracked_task) == 0, 1);

	round_score = current_score;
	total_score = total_score + round_score;
	
	if (is_grunt_round) then
		total_grunt_score = total_grunt_score + current_score;
	else
		total_pawn_score = total_pawn_score + current_score;
	end
	
end

script static void display_score(short round_num)
	set_text_lifespan (3.5 * 30);
	set_text_margins(0, 0, 0.00, 0.5); 
	set_text_color (255, 255, 0, 0);
	show_text ("ROUND");
	sleep_s(1);
	set_text_color (255, 0, 255, 0);	
	set_text_margins(0.05, 0.0, 0.05, 0.0);	// l,r,t,b  
	show_text (string(round_score));
	sleep_s(4);

	set_text_lifespan (3.5 * 30);
	set_text_margins(0, 0, 0.00, 0.5); 
	set_text_color (255, 255, 0, 0);
	
	if (round_num == 1 or round_num == 3 or round_num == 5 or round_num == 7) then
		show_text ("GRUNT TOTAL");
	else
		show_text ("PAWN TOTAL");
	end
	
	sleep_s(1);
	set_text_margins(0.05, 0.0, 0.05, 0.0);	// l,r,t,b  
	set_text_color (255, 0, 255, 0);	
	
	if (round_num == 1 or round_num == 3 or round_num == 5 or round_num == 7) then
		show_text (string(total_grunt_score));
	else
		show_text (string(total_pawn_score));
	end

	sleep_s(3);
end

script static void final_results()

	set_text_scale (3);
	set_text_lifespan (5 * 30);
	set_text_margins(0, 0, 0.00, 0.8); 
	set_text_color (255, 255, 0, 0);
	show_text ("GRUNT TOTAL");

	if (total_grunt_score >= total_pawn_score) then
		set_text_color (255, 0, 255, 0);	
	else 
		set_text_color (255, 255, 0, 0);	
	end
	set_text_margins(0.00, 0.0, 0.00, 0.4);	// l,r,t,b  
	show_text (string(total_grunt_score));

	set_text_scale (3);
	set_text_margins(0, 0, 0.00, -0.3); 
	set_text_color (255, 255, 0, 0);
	show_text ("PAWN TOTAL");

	if (total_grunt_score <= total_pawn_score) then
		set_text_color (255, 0, 255, 0);	
	else 
		set_text_color (255, 255, 0, 0);	
	end
	
	set_text_margins(0.00, 0.0, 0.00, -0.7);	// l,r,t,b  
	show_text (string(total_pawn_score));
	
end