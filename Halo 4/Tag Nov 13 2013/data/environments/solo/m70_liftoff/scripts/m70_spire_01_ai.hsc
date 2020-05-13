//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
// 
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_01_INT_AI
// =================================================================================================
// =================================================================================================
// variables
global boolean b_tw1_spawn_snipers     = false;
global boolean b_tw1_spawn_start       = false;
global boolean b_gondola_spawn_knights = false;
global boolean b_tw2_spawn_start 			 = false;
global boolean b_sp01_bishop_attack = FALSE;
//clean out old
global boolean B_obj_con_bridge = FALSE;
global boolean b_player_is_on_tower = FALSE;
global boolean b_player_is_on_tower_2 = FALSE;
global boolean b_ranger_be_at_switch = FALSE;
global boolean b_ranger_be_at_tower = FALSE;
global boolean b_ranger_be_at_start = TRUE;
global boolean b_airspace_invaded_tower_1 = FALSE;


// functions
// === f_spire_01_INT_AI_init::: Initialize
script dormant f_spire_01_AI_init()
	dprint( "::: f_spire_01_INT_AI_init :::" );

	// initialize modules
	sleep_until(f_spire_01_INT_Zone_Active(), 1);
	// initialize sub modules
	wake(f_spire_01_INT_ai_main);
	//wake( f_spire_01_INT_AI_CCC_init );

end

// === f_spire_01_INT_AI_deinit::: Deinitialize
script dormant f_spire_01_AI_deinit()
	dprint( "::: f_spire_01_INT_AI_deinit :::" );
	// kill functions
	sleep_forever( f_spire_01_AI_init );
end


//SPIRE 01
script dormant f_spire_01_INT_ai_main()

	sleep_until (volume_test_players (tv_sp01_tw1_start_sniper) or b_tw1_spawn_snipers, 1);	
	
	wake(f_spire01_nar_gondola_fire);
	
	wake(f_tower_1_spawn_controller);
	
	
	
	sleep_until(b_sp01_tower_1_spawn_exit == TRUE);
	
	wake(f_tower_1_spawn_exit);
	
	//sleep_until(volume_test_players (tv_gondola_spawn_knights) or b_gondola_spawn_knights, 1 );
	sleep_until(b_gondola_spawn_knights, 1 );
	
	ai_erase (sg_tower_1_starter);
	ai_erase (sg_tower_1_c);
	ai_erase (sg_tower_1_exit);
	
	
	wake(f_sp01_gondola_01);
	sleep_s(1.5);
	wake(f_sp01_tower_2_ranger);
	sleep_until(volume_test_players(tv_sp01_tw2_start) or b_tw2_spawn_start, 1 );
	//xxx
	//tower2
	wake(f_tower_2_spawn_controller);
	wake(f_sp01_bishop_controller);
	
	sleep_until(b_sp01_tower_2_spawn_exit, 1 );
	
	wake(f_sp01_tw02_spawn_exit);	
	//sleep_until(B_GONDOLA_ACTIVE, 1 );
	//wake(f_sp01_tw01_spawn_end_main);
	
end

script dormant f_sp01_bishop_controller()
	dprint("f_sp01_bishop_controller");
	sleep_until(b_sp01_bishop_attack, 1 );
	
	if not b_sp01_deactivated then
		ai_place(sq_end_bishop_01);
		ai_place(sq_end_bishop_02);
	else
		dprint("blah blah why is this spawning");
		ai_place(sq_end_bishop_01);
		ai_place(sq_end_bishop_02);
		ai_place(sq_end_bishop_04);
	end
	
end


//sg_sp01_exit_bishops
script dormant f_spawning_bridge_control

		sleep_until (ai_living_count (sg_tower_1_starter) <= 19);
		sleep_until (not volume_test_players (tv_bridge_safe_to_spawn), 1);
		ai_place (sq_tower_1_c_1);
		
		sleep_until (ai_living_count (sg_tower_1_starter) <= 18);
		sleep_until (not volume_test_players (tv_bridge_safe_to_spawn), 1);
		ai_place (sq_tower_1_c_2);		
		
		sleep_until (ai_living_count (sg_tower_1_starter) <= 16);
		sleep_until (not volume_test_players (tv_bridge_safe_to_spawn), 1);
		ai_place (sq_tower_1_c_3);
		
		sleep_until ((ai_living_count (sg_tower_1_starter ) +  ai_living_count (sg_tower_1_switch )) <= 19);
		sleep_until (not volume_test_players (tv_bridge_safe_to_spawn), 1);
		ai_place (sq_tower_1_jackal_re);
		
end

script dormant f_tower_1_spawn_controller()
	sleep_s (2);
	//ai_place (sq_tower_1_turrets);
	ai_place(sq_tower_1_sniper_1);
	ai_place(sq_tower_1_sniper_2);
	ai_place(sq_tower_1_sniper_3);
	sleep_until(ai_living_count(sg_tower_1_snipers) < 3 or volume_test_players (tv_spawn_tower_1_start) or b_tw1_spawn_start, 1);
	if ai_living_count(sg_tower_1_snipers) < 3 then
		ai_place(sq_tower_1_sniper_4);
	end
	sleep_until (volume_test_players (tv_spawn_tower_1_start) or b_tw1_spawn_start, 1);	
	ai_place (sg_tower_1_a);
	ai_place (sg_tower_1_b);
	ai_place (sg_tower_1_switch);
	//ai_place (sg_tower_1_snipers);
	//xxx combat checkpoint
	thread(f_sp01_checkpoint_combat(sg_sp01_tw01));
	
	wake (f_spawning_bridge_control);
	wake (f_player_tower_1_checker);
	wake (f_airspace_tower_1_checker);
	wake (f_spawning_bridge_control);
end

script dormant f_player_tower_1_checker

	sleep_until (volume_test_players (tv_player_tower_1), 1);
	b_player_is_on_tower = true;

end

script dormant f_player_tower_2_checker

	sleep_until (volume_test_players (tv_player_on_tower_2), 1);
	b_player_is_on_tower_2 = true;

end

script dormant f_airspace_tower_1_checker
	
	sleep_until (volume_test_players (tv_airspace_tower_1), 1);
	b_airspace_invaded_tower_1 = true;
	
end

script dormant f_tower_1_spawn_exit()
	dprint ("spawn exit");
	sleep_s(0.75);
	//ai_place (sg_tower_1_exit);
	ai_place_in_limbo (sq_tw1_exit_knights_01);
	ai_place_in_limbo (sq_tw1_exit_knights_02);
	ai_place_in_limbo (sq_tw1_exit_knight);
		ai_allow_resurrect(sq_tw1_exit_knight, false);
	if ( ai_living_count(sg_tower_1_starter) + ai_living_count(sg_tower_1_exit) ) <= 14 then
		ai_place(sq_tw1_exit_pawn_03);
	end
end

script static void f_sp01_pup_gondola_ride_02()
	pup_play_show(pup_sp01_gondola_ride_02);
end

script static void f_sp01_tower_1_exit_pawns_pup_1()
	pup_play_show(pup_sp01_gondola_pawns_01);
end

script static void f_sp01_tower_1_exit_pawns_pup_2()	
	pup_play_show(pup_sp01_gondola_pawns_02);
end

script dormant f_spire01_nar_gondola_fire()
	if f_check_first_spire(DEF_SPIRE_01) then
		sleep_until( ai_is_shooting(sg_sp01_tw01),1);
		sleep_s(0.5);
		wake(f_dlg_spire_01_gondola_taking_fire);
	end
end

//=====================================================
//SPAWN TOWER 01
//=====================================================


//SWITCH KNIGHT
script static void f_switch_knight( ai knight, ai elite)
	ai_enter_limbo(knight); 
	repeat
		if ai_living_count(elite) < 1 then
			sleep_s(1.25);
			cs_queue_command_script(knight, cs_phase_in_on_spawn);
			ai_exit_limbo(knight);
		end
		sleep_s(3);
	until(b_sp01_tower_1_spawn_exit == TRUE or ai_in_limbo_count(knight) < 1); 
	if ai_in_limbo_count(knight) > 1 then
		ai_erase(knight); //kill knight if he is in limbo
	end
end

//EXIT
script dormant f_sp01_tw01_spawn_exit()
	dprint("f_sp01_tw01_spawn_exit");
	ai_place(sg_sp01_tw01_exit);
end

script command_script cs_turret

	sleep (3);
	AutomatedTurretActivate(ai_vehicle_get_from_spawn_point (sq_tower_1_turrets.turret_1));
	AutomatedTurretActivate(ai_vehicle_get_from_spawn_point (sq_tower_1_turrets.turret_2));

end

script command_script cs_turret_2

	sleep (3);
	AutomatedTurretActivate(ai_vehicle_get_from_spawn_point (sq_tower_2_turrets.turret_1));
	AutomatedTurretActivate(ai_vehicle_get_from_spawn_point (sq_tower_2_turrets.turret_2));

end

//=====================================================
//SPAWN GONDOLA TRANSITION FIGHT
//=====================================================
script dormant f_sp01_gondola_01()
dprint("f_sp01_gondola_01");

	ai_place_in_limbo(sq_gondola_knight_01);
	ai_allow_resurrect(sq_gondola_knight_01, false);
	sleep_s(0.75);
	if (ai_living_count(sq_tw1_exit_knight) + ai_living_count(sq_gondola_knight_01)) <= 1 then 
		ai_place_in_limbo(sq_gondola_knight_02);
		ai_allow_resurrect(sq_gondola_knight_02, false);
	end
	game_save_no_timeout();
end

script static boolean f_tower_2_ranger_valid()
 ai_living_count(sq_gondola_knight_01) + ai_living_count(sq_gondola_knight_02) + ai_living_count(sq_tw1_exit_knight) == 0;
end

// TOWER 2 ranger
script dormant f_sp01_tower_2_ranger()
	sleep_until(f_tower_2_ranger_valid() or b_tw2_spawn_start, 1);
	sleep_s(0.25);
	ai_place_in_limbo(sq_tower_2_ranger);
end



//=====================================================
//SPAWN TOWER 2
//=====================================================
script dormant f_tower_2_spawn_controller()
	dprint("Tower 2 Spawn");
	//ai_place(sg_tower_2_starter);
	ai_place(sq_tower_2_a_1);
	ai_place(sq_tower_2_a_2);
	ai_place_in_limbo(sq_tower_2_battlewagon);
	ai_place(sq_tower_2_bishop_01);
	ai_place(sq_tower_2_bishop_02);
	ai_place_with_shards(sq_tower_2_d_1);
	
	//xxx combat checkpoint
	thread(f_sp01_checkpoint_combat(sg_sp01_tw02));

	wake (f_spawning_bridge_control_2);
	wake (f_ranger_phase_to);
	wake (f_ranger_shooting);
	wake (f_tw2_bishop_spawn);
end



//ai_cannot_die (object_get_ai (pup_current_puppet), TRUE);
script dormant f_spawning_bridge_control_2()
//not volume_test_players (tv_bridge_safe_to_spawn_2)
		sleep_until (ai_living_count (sg_tower_2_starter) <= 16, 1);
		ai_place_with_shards(sq_tower_2_b_1);
		ai_place_with_shards(sq_tower_2_b_2);
		ai_place(sq_tower_2_bishop_03);	
		sleep_until (ai_living_count (sg_tower_2_starter) <= 16, 1);
		ai_place_with_shards (sq_tower_2_c_1);
		ai_place_with_shards (sq_tower_2_c_2);
		
end

script dormant f_tw2_bishop_spawn()
	sleep_until(ai_living_count(sq_tower_2_bishop_01) + ai_living_count(sq_tower_2_bishop_02) < 2, 1);
	ai_place(sq_tower_2_bishop_03);
end

script dormant f_ranger_re

		sleep (30 * 2);
		//sleep_until (ai_living_count (sq_tower_2_ranger) < 1);
		sleep_until ( not sp01_gondola_moving, 1);
		//if b_ranger_be_at_start == true then
		
			sleep(30 * 2);
			ai_place_in_limbo (sq_tower_2_ranger_re);
			b_ranger_be_at_start = false;
			b_ranger_be_at_tower = true;	
			
			sleep_until (volume_test_players (tv_ranger_move), 1);

			sleep (30 * 5);
			cs_phase_to_point (sq_tower_2_ranger_re, true, ps_ranger.switch);
			b_ranger_be_at_tower = false;
			b_ranger_be_at_switch = true;
		//end 
		
		
end


script dormant f_sp01_tw02_spawn_exit()
	dprint("f_sp01_tw02_spawn_exit");
	sleep_s(3);
	sleep_until(volume_test_players_lookat(tv_spire01_tw02_see_gondola, 16, 16), 1);
	ai_place_in_limbo(sq_tw2_knight);
	ai_allow_resurrect(sq_tw2_knight, false);
	ai_place_in_limbo(sq_tw2_exit_commander);
	ai_allow_resurrect(sq_tw2_exit_commander, false);
	//ai_place(sg_sp01_tw02_exit);
end

script dormant f_sp01_tw01_spawn_end_main()
	dprint("f_sp01_tw01_spawn_end_main");
	ai_place(sg_sp01_end_main);
	ai_set_active_camo(sg_sp01_end_main, TRUE);
end

//Command Scripts Turrets
script command_script cs_unstealth()
	ai_set_active_camo(sg_sp01_end_main, FALSE);
	ai_berserk(ai_current_actor, TRUE);
end


script dormant f_ranger_shooting()
	sleep_until(ai_is_shooting(sq_tower_2_ranger), 1);
	thread(f_dialog_m70_callout_look_out());
end

script dormant f_ranger_phase_to
	if game_difficulty_get() == "legendary" then
		wake (f_ranger_re);
	end
	sleep_until (volume_test_players (tv_player_on_tower_2), 1);
	b_ranger_be_at_start = false;
	b_ranger_be_at_tower = true;	
	
	cs_phase_to_point (sq_tower_2_ranger, true, ps_ranger.other_tower);
	sleep_until (volume_test_players (tv_ranger_move), 1);
	sleep (30 * 5);
	cs_phase_to_point (sq_tower_2_ranger, true, ps_ranger.switch);
	b_ranger_be_at_tower = false;
	b_ranger_be_at_switch = true;

end

script command_script cs_berserk()
	ai_berserk(ai_current_actor, TRUE);
end


script command_script cs_sp01_bishop_end_01()
	cs_move_towards_point(ps_end_bishop.p0, 1);	
end

script command_script cs_sp01_bishop_end_02()
	cs_move_towards_point(ps_end_bishop.p1, 1);	
end

script command_script cs_sp01_bishop_end_03()
	cs_move_towards_point(ps_end_bishop.p2, 1);
end

script command_script cs_sp01_bishop_end_04()
	cs_move_towards_point(ps_end_bishop.p3, 1);
end

script command_script cs_sp01_bishop_end_05()
	cs_move_towards_point(ps_end_bishop.p4, 1);
end

script command_script cs_sp01_bishop_end_06()
	cs_move_towards_point(ps_end_bishop.p5, 1);
end

script command_script cs_sp01_bishop_end_07()
	cs_move_towards_point(ps_end_bishop.p6, 1);
end

script command_script cs_just_phase_in

	cs_phase_in_blocking();
	
end



