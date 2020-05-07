//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m60_rescue (E3 DEMO!)
//	Insertion Points:	(or ice3)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

/*script dormant f_e3_demo

	sleep_until (volume_test_players (e3_air_spawn), 1);
	
	print (":  : Spawn Ambient Air :  :");
	
	ai_place (sq_e3_amb_air);
	
	wake (f_e3_elite);
	
end

script dormant f_e3_elite

		sleep_until (volume_test_players (e3_elite_spawn), 1);
		
		cinematic_show_letterbox (FALSE);
		player_disable_movement (TRUE);
		
		ai_place (sq_e3_elite);
		
		wake (f_e3_pawn);
		
end

script dormant f_e3_pawn

	sleep_until (volume_test_players (e3_pawn_spawn), 1);
	thread (e3_pawn_thread());
	
//	ai_place (sq_e3_pawn_1.p4);
//	ai_place (sq_e3_pawn_1.p5);

//	wake (f_e3_knight_2);

end

script static void e3_pawn_thread()

	thread (e3_pawn_1());
	sleep (30);
	thread (e3_pawn_2());
	thread (e3_pawn_3());

	wake (f_e3_knight_2);

end

script static void e3_pawn_1()

	object_create (e3_pawn_1);
	object_move_to_point (e3_pawn_1, 1, e3_pawn_1.p0);
	object_move_to_point (e3_pawn_1, .5, e3_pawn_1.p1);
	object_move_to_point (e3_pawn_1, .5, e3_pawn_1.p2);
	sleep (30 * 2);
	object_move_to_point (e3_pawn_1, .5, e3_pawn_1.p3);
	object_move_to_point (e3_pawn_1, .5, e3_pawn_1.p4);
	object_move_to_point (e3_pawn_1, 1, e3_pawn_1.p5);
	//object_rotate_to_point (e3_pawn_1, 1, 1, 1, e3_pawn_1.p5);
	object_destroy (e3_pawn_1);
	//ai_place (sq_e3_pawn_1.p1);
	object_create (e3_fr_rifle);

end

script static void e3_pawn_2()

	object_create (e3_pawn_2);
	object_move_to_point (e3_pawn_2, 2, e3_pawn_2.p0);
	object_move_to_point (e3_pawn_2, 1, e3_pawn_2.p1);
	object_move_to_point (e3_pawn_2, 1, e3_pawn_2.p2);
	object_move_to_point (e3_pawn_2, 1, e3_pawn_2.p5);
	//object_rotate_to_point (e3_pawn_1, 1, 1, 1, e3_pawn_1.p5);
	object_destroy (e3_pawn_2);
	//ai_place (sq_e3_pawn_1.p3);

end

script static void e3_pawn_3()
	
	object_move_to_point (e3_pawn_3, 1, e3_pawn_3.p0);
	object_move_to_point (e3_pawn_3, 1, e3_pawn_3.p1);
	object_move_to_point (e3_pawn_3, .5, e3_pawn_3.p2);
	object_destroy (e3_pawn_3);
//	ai_place (sq_e3_pawn_1.p2);
	
end

script dormant f_e3_knight_2

	sleep_until (volume_test_players (e3_knight_2_spawn), 1);
	ai_place (sq_e3_knight_2);
	sleep_until (ai_living_count (sq_e3_knight_2) < 1);
//	cs_go_to (sq_e3_bishop_1, TRUE, e3_bishop_escape.p0);
	
	wake (f_e3_knight_3);
	
end

script dormant f_e3_knight_3

	sleep_until (volume_test_players (e3_knight_3_spawn), 1);
	
	sleep (30 * 2);
	
	ai_place (sq_e3_knight_3.p1);
	sleep (30);
	ai_place (sq_e3_knight_3.p2);
	
	sleep_until (ai_living_count (sq_e3_knight_3.p1) < 1);
	
	ai_place (sq_e3_bishop_2);

	wake (f_e3_vignette);

end

script dormant f_e3_vignette

	sleep_until (volume_test_players (trig_trail_vig), 1);
	ai_place (sq_enc_2_vig_fore);
	ai_place (sq_enc_2_vig_marine);
	sleep (30 * 5);
	effect_new_at_ai_point ("fx\reach\test\chad\explosions\gritty_explosion.effect", ps_vig_pt.p0);
	ai_kill (sq_enc_2_vig_fore);
	ai_kill (sq_enc_2_vig_marine);
	object_create (xray_drop);

	sleep_until ((object_get_health (xray_drop)) == 0);
	
	sleep (30 * 6);
	
	ai_place (sq_e3_xray_spook.p1);
	
	sleep (30 * 2);
	
	ai_place (sq_e3_xray_spook.p2);
	ai_place (sq_e3_vig_pawn);
	
	sleep (30);
	
	ai_place (sq_e3_xray_spook.p3);
	
	sleep (15);
	
	ai_place (sq_e3_xray_spook.p4);
	
	sleep (5);
	
	ai_place (sq_e3_xray_spook.p5);
	
	sleep (30 * 10);
	
	fade_out (0, 0, 0, 120);
	
end	


;==================================================================================================
; COMMAND SCRIPTS
;==================================================================================================

script command_script e3_banshee_1

	ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_fly_to (e3_banshee_1.p0);
	cs_fly_to (e3_banshee_1.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_banshee_1.p2);
	ai_erase (ai_current_actor);

end

script command_script e3_banshee_2

	ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_fly_to (e3_banshee_2.p0);
	cs_fly_to (e3_banshee_2.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_banshee_2.p2);
	ai_erase (ai_current_actor);

end

script command_script e3_phantom

	ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_vehicle_speed (1.5);
	thread (e3_phantom_shake());
	cs_fly_to (e3_phantom.p0);
	cs_fly_to (e3_phantom.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_phantom.p2);
	ai_erase (ai_current_actor);

end

script command_script e3_phantom_2

	ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_vehicle_speed (1.5);
	cs_fly_to (e3_phantom_2.p0);
	cs_fly_to (e3_phantom_2.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_phantom_2.p2);
	ai_erase (ai_current_actor);

end

script command_script e3_phantom_3

	ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_vehicle_speed (1.5);
	cs_fly_to (e3_phantom_3.p0);
	cs_fly_to (e3_phantom_3.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_phantom_3.p2);
	ai_erase (ai_current_actor);

end

script static void e3_phantom_shake()

	sleep (30 * 7);
	camera_shake_player (player0, 1, 1, 1, 3);

end

script command_script e3_elite

	cs_custom_animation(objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph, "combat:sword:point", TRUE );
	cs_custom_animation(objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph, "combat:sword:go_berserk", TRUE );
	ai_place (sq_e3_knight_1);
	print (":  : Placing Knight 1 :  :");
	cs_custom_animation(objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph, "combat:sword:melee:var3", TRUE );
//	cs_custom_animation(objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph, "combat:sword:melee:var4", TRUE );
	
end

script command_script e3_knight_1

	cs_phase_in();
	sleep (30 * 2);
	print (":  : Shooting Elite :  :");
	cs_shoot (TRUE, (ai_get_object(sq_e3_knight_1)));
	sleep (30);
	print (":  : Stop Shooting :  :");
	cs_shoot (FALSE, (ai_get_object(sq_e3_knight_1)));
	ai_kill (sq_e3_elite);
	sleep (30 * 2);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", FALSE);
	sleep (30 * 2);
	cs_phase_to_point (e3_phase_1.p0);
	player_disable_movement (FALSE);
	cinematic_show_letterbox (FALSE);
	ai_erase (ai_current_actor);
	
end

script command_script e3_knight_2

	cs_phase_in();
	sleep (30 * 2);
//	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	ai_place (sq_e3_bishop_1);
//	cs_shoot_point (TRUE, e3_knight_shoot.p0);
//	print (":  : Shooting One :  :");
//	sleep (30 * 3);
//	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", FALSE);
//	cs_shoot_point (TRUE, e3_knight_shoot.p1);
//	print (":  : Shooting Two :  :");
//	sleep (30 * 3);
//	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", FALSE);
//	sleep (30 * 10);
//	ai_kill (ai_current_actor);
	
end

script command_script e3_knight_spook_1

	cs_phase_in();
	sleep (30);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);

end

script command_script e3_knight_spook_2

	cs_phase_in();
	sleep (30);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:sword_flick", TRUE);

end

script command_script e3_pawn_spook_1

	cs_go_to (e3_pawn_spook.p0);
	
end

script command_script e3_pawn_spook_2

	cs_go_to (e3_pawn_spook.p1);
	
end

script command_script e3_pawn_spook_3

	cs_go_to (e3_pawn_spook.p2);
	
end

script command_script e3_pawn_spook_4

	cs_go_to (e3_pawn_spook.p3);
	
end

*/