//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_03
// =================================================================================================
// =================================================================================================
// variables
global boolean b_cortana_removed = FALSE;
// functions

// SPIRE_03
script dormant f_spire_03_init()
	dprint( "::: f_spire_03_init :::" );
	wake( f_spire_03_deinit );
	kill_volume_disable(kill_sp03_bot);
	kill_volume_disable(kill_soft_sp03_top);
	kill_volume_disable(kill_sp03_top);
	kill_volume_disable(kill_soft_sp03_high);
	kill_volume_disable(kill_sp03_high);
	
	sleep_until(volume_test_players(tv_spire_03_enter) or f_spire_03_INT_Zone_Active(), 1);
	
	thread(f_sp03_door_enter());

	
	sleep_until( f_spire_03_INT_Zone_Active() and (not f_spire_state_complete(DEF_SPIRE_03)), 1 );
	s_flight_state = S_DEF_FLIGHT_STATE_THIRD_COMPLETE();
	dprint("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
	dprint("game insertion point unlock 5");
	dprint("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
	game_insertion_point_unlock(5);
	//objectives_show_up_to(3);
	data_mine_set_mission_segment ("m70_spire_03"); 
	player_set_profile( profile_coop_respawn );
	
	wake(f_spire_03_main);
	// initialize modules
	wake( f_spire_03_AI_init );
	wake( f_spire_03_FX_init );
	wake( f_spire_03_audio_init );
//	wake( f_spire_03_narrative_init );

	// initialize sub modules
	end

// === f_spire_03_INT_Deinit::: Deinitialize
script dormant f_spire_03_deinit()
	dprint( "::: f_spire_03_INT_Deinit :::" );
	sleep_until( f_spire_state_complete(DEF_SPIRE_03) and (not f_spire_03_INT_Zone_Active()), 1 );
	// deinitialize sub modules
	sleep_forever( f_spire_03_init );
	sleep_forever(f_spire_03_main);
	sleep_forever(f_spire_03_objectives);
	//sleep_forever(f_spire_03_INT_control_room_init);
	//sleep_forever(f_spire_03_INT_control_room_switch_init);
	sleep_forever(f_spire_03_didact_attack);
	
	// deinitialize modules
	wake( f_spire_03_AI_deinit );
	wake( f_spire_03_FX_deinit );
	wake( f_spire_03_audio_deinit );
//	wake( f_spire_03_narrative_deinit );

end

// === f_spire_03_INT_Zone_Active::: Checks if the current zone set is for this area
script static boolean f_spire_03_INT_Zone_Active()
	( current_zone_set_fully_active() >= DEF_S_ZONESET_SPIRE_03_INT_A ) and ( current_zone_set_fully_active() <= DEF_S_ZONESET_SPIRE_03_EXIT );
end

 script dormant f_spire_03_main()
	//xxx start grav_lift_01
	//effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, fx_14_gravlift_1_start, fx_14_gravlift_1_end);
	//objectives_show_up_to(4);
	thread(f_sp03_fx_grav_lift_01());
	thread(f_sp03_teleport_not_in_gravlift(tv_sp03_grav_01_teleport, flg_sp03_gravlift_01));
	//xxx
	wake(f_spire_03_objectives);
	wake(f_spire_03_checkpoints);
	wake(f_sp03_bottom_kill_volumes);
	wake(f_sp03_top_kill_volumes);
	thread(f_sp03_zone_loads_top());
	thread(f_sp03_end_hallway_doors());
	sleep_until(volume_test_players(tv_spire_03_bottom_start), 1);
	
	
	//xxx start grav_lift_02
	thread(f_sp03_fx_grav_lift_02());
	thread(f_sp03_teleport_not_in_gravlift(tv_sp03_grav_02_teleport, flg_sp03_gravlift_02));
	//effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, fx_14_gravlift_2_start, fx_14_gravlift_2_end);
	//xxx
	wake( f_spire_03_top_object_cleanup);
	//xxx
	garbage_collect_unsafe();
	wake(f_spire_03_bridge_bottom);
	wake(f_spire_03_didact_attack);
	
	wake(f_spire_03_bottom_object_cleanup);
	wake(f_spire_03_top_object_spawn);
	sleep_until(volume_test_players(tv_spire_03_top_start), 1);

	wake( f_spire_03_INT_control_room_init );	

end

script static void f_sp03_zone_loads_top()
	sleep_until(volume_test_players(tv_spire_03_top_start) and not volume_test_players(tv_sp03_grav_lift_02), 1);
	sleep_s(3);
	
	zoneset_prepare_and_load( DEF_S_ZONESET_SPIRE_03_INT_C );	
end

script static void f_sp03_teleport_not_in_gravlift(trigger_volume tv_gravlift, cutscene_flag flg_gravlift)
	sleep_until(volume_test_players(tv_gravlift), 1);
	sleep_s(2);
	volume_teleport_players_not_inside(tv_gravlift, flg_gravlift);
end

script dormant f_spire_03_objectives()

	f_spire_state_set ( DEF_SPIRE_03, DEF_R_OBJECTIVE_SPIRE_03_ENTER());
	f_objective_set( DEF_R_OBJECTIVE_SPIRE_03_START(), FALSE, TRUE, FALSE, TRUE );
	
	sleep_until(volume_test_players(tv_spire_03_bottom_start), 1);
	
	f_spire_state_set ( DEF_SPIRE_03, DEF_SPIRE_STATE_INTERIOR_START());
	f_objective_set( DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR(), FALSE, TRUE, FALSE, TRUE );
	
	sleep_until(volume_test_players(tv_spire_03_top_start), 1);
	
	f_objective_set( DEF_R_OBJECTIVE_SPIRE_03_TOP_FLOOR(), FALSE, TRUE, FALSE, TRUE );
	
	sleep_until(volume_test_players(tv_sp03_hallway_teleport), 1);
	
	f_objective_set( DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_ENTER(), FALSE, TRUE, FALSE, TRUE );
	render_default_lighting = 0;
end

script dormant f_spire_03_didact_attack()
	sleep_until(volume_test_players(tv_spire_03_bottom_start) or volume_test_players(tv_sp03_bridge_fall_02), 1);
	sleep_s(1);
	pup_play_show(pup_bridge_fall_01);
	sleep_until(volume_test_players(tv_sp03_bridge_fall_02) or volume_test_players(tv_sp03_bridge_fall_03), 1);
	pup_play_show(pup_bridge_fall_02);
	sleep_until(volume_test_players(tv_sp03_bridge_fall_03) or not volume_test_players(tv_sp03_bridge_fall_04), 1);
	pup_play_show(pup_bridge_fall_03);
	sleep_until(not volume_test_players(tv_sp03_bridge_fall_04), 1);
	sleep_s(0.25);
	if game_is_cooperative() or game_difficulty_get_real() == "easy" then 
	sleep_s(0.25);		
	end
	pup_play_show(pup_bridge_fall_04);
	
end

// -------------------------------------------------------------------------------------------------
// spire_03_INT: Control Room
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_spire_03_INT_control_room_init::: Init
script dormant f_spire_03_INT_control_room_init()
	sleep_until(( current_zone_set_fully_active() >= DEF_S_ZONESET_SPIRE_03_INT_D ), 1);
	dprint( "::: f_spire_03_INT_control_room_init :::" );
	objectives_finish(4);
	// initialize sub modules
	wake( f_spire_03_INT_control_room_switch_init );
	wake( f_spire_03_INT_control_room_floor_init );

	// this music trigger should fire when you insert cortana into the plinth and start the sequence of her going rampant
	pup_play_show(cortana_fail_spires);

end

// -------------------------------------------------------------------------------------------------
// spire_03_INT: Control Room: Switch
// -------------------------------------------------------------------------------------------------
// variables
//global boolean <t>_spire_03_INT_<NAME> = <VALUE>;
global boolean b_fail_pick_up_cortana = FALSE;

script dormant f_spire_03_INT_control_room_switch_init()
	local long l_pup_fail_id = 0;
	//local long l_pup_id = 0;
	dprint( "::: f_spire_03_INT_control_room_switch_start :::" );
	// create the switch
  object_create(  top_spire_switch_01 );
  object_create(  top_spire_switch_02 );
  sleep_until(object_valid(top_spire_switch_01) and object_valid(top_spire_switch_02), 1);
  device_set_position(top_spire_switch_01, 0);
  device_set_position(top_spire_switch_02, 0);
  device_set_power ( top_spire_switch_01, 1 );
  device_set_power ( top_spire_switch_02, 0 );
  f_objective_set( DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_ENTER(), FALSE, TRUE, FALSE, TRUE );
  thread(f_m70_objective_complete(ct_obj_spire_03));
  // set the objective
  f_blip_object( top_spire_switch_01, "recon");
  
  sleep_until( (device_get_position(top_spire_switch_01) > 0.0), 1 );
	f_unblip_object( top_spire_switch_01 );
	l_pup_fail_id = pup_play_show(pup_cortana_fail_test);
	pup_play_show(pup_spire_ships);
	
  device_set_power ( top_spire_switch_01, 0 );
	
	sleep_until(b_fail_pick_up_cortana , 1);
	
	device_set_power ( top_spire_switch_02, 1 );
	f_blip_object( top_spire_switch_02, "recon");
	
	sleep_until( (device_get_position(top_spire_switch_02) > 0.0), 1 );
	
	f_unblip_object( top_spire_switch_02 );
	
	pup_play_show(pup_fail_plinth_remove);
	
	sleep_until(b_cortana_removed, 1);
  
  device_set_power ( top_spire_switch_02, 0.0 );
  
	object_destroy( top_spire_switch_01 );
  object_destroy( top_spire_switch_02 );

  wake( f_dlg_spire_03_take_charge );

	// wait for the right dialog moment
	sleep_until( dialog_id_played_check(L_dlg_spire_03_take_charge) and (not pup_is_playing(l_pup_fail_id)), 1 );
	game_save();
	thread(f_m70_objective_set(ct_obj_lich));
	// set spire state complete
	f_spire_state_set( DEF_SPIRE_03, DEF_SPIRE_STATE_COMPLETE() );
	
end

script static void f_spawn_orb
	// HACK: for some reason the particle effect gets culled from the zoneset and the bitmap is not loaded in the zoneset
	// maybe because of a leak in the seamps. so here we force the bitmap to always be loaded
	local any_tag hack = "fx\bitmaps\2d\tech\tell_ring_reticule_02.bitmap";
	sleep(26);
	effect_new("objects\characters\storm_cortana\fx\orb\cor_orb_persistant_ramp",cortana_orb_flag);
	b_fail_pick_up_cortana = TRUE;
end

// -------------------------------------------------------------------------------------------------
// spire_03_INT: Control Room: FLOOR
// -------------------------------------------------------------------------------------------------

// functions
// === f_spire_03_INT_control_room_floor_init::: Init
script dormant f_spire_03_INT_control_room_floor_init()

	sleep_until( object_valid(dm_sp03_control_room_floor), 1 );
	dprint( "::: f_spire_03_INT_control_room_floor_init :::" );
	device_set_position_track( dm_sp03_control_room_floor, 'any:idle', 0.0 );
	
	sleep_until( object_active_for_script(dm_sp03_control_room_floor), 1 );
	dm_sp03_control_room_floor->speed_set_open( 10.0 );
	dm_sp03_control_room_floor->speed_set_close( 7.5 );
	
	
	// setup trigger
	wake ( f_spire_03_INT_control_room_floor_trigger );
	
end

// === f_spire_03_INT_control_room_floor_trigger::: Trigger
script dormant f_spire_03_INT_control_room_floor_trigger()
	sleep_until( f_spire_state_complete(DEF_SPIRE_03), 1 );
	dprint( "::: f_spire_03_INT_control_room_floor_trigger :::" );

	wake( f_spire_03_INT_control_room_floor_action );

end

// === f_spire_03_INT_control_room_floor_action::: Open
script dormant f_spire_03_INT_control_room_floor_action()
	sleep_until( object_valid(dm_sp03_control_room_floor) and object_active_for_script(dm_sp03_control_room_floor), 1 );
	dprint( "::: f_spire_03_INT_control_room_floor_action :::" );

	sleep_s( 0.125 );
	// open the floor
	//sound_impulse_start('sound\environments\solo\m070\amb_m70_final\amb_m70_machines\machine_m70_spire3_end_elevator', dm_sp03_control_room_floor, 1); // play audio for lowering floor
	dm_sp03_control_room_floor->open();
	
	// setup auto close
	dm_sp03_control_room_floor->auto_trigger_close( tv_sp03_control_room_floor_area, TRUE, FALSE, TRUE );
	
end



//================================================
// SPIRE_03_DOORS
//================================================
// :: SPIRE_03_DOORS_MAIN

script static void f_sp03_door_enter()
	dprint("f_sp03_door_enter");
	sleep_until(volume_test_players(tv_sp03_hallway_teleport), 1);
	sleep(1);
	sleep_until(not volume_test_players(tv_dm_sp03_int_door_01), 1);
	
	device_set_power(dm_sp03_int_door_01, 0);
	
	sleep_until(device_get_position(dm_sp03_int_door_01) == 0, 1);
	
	thread(f_flight_blip_clear_all());
	if game_is_cooperative() then
		volume_teleport_players_not_inside(tv_sp03_hallway_check, flag_sp03_hallway_teleport);
		sleep(15);
	end
	
	zoneset_prepare_and_load( DEF_S_ZONESET_SPIRE_03_INT_A );
	
	game_save();
	
	device_set_power(dm_sp03_int_door_02, 1);
	thread(f_flight_blip_clear_all());
end


script static void f_sp03_end_hallway_doors()
	sleep_until(volume_test_players(tv_sp03_hallway_end_teleport), 1);
	sleep(1);
	sleep_until(not volume_test_players(tv_dm_sp03_int_door_03), 1);
	
	device_set_power(dm_sp03_int_door_03, 0);
	
	sleep_until(device_get_position(dm_sp03_int_door_03) == 0, 1);
	
	if game_is_cooperative() then
		volume_teleport_players_not_inside(tv_sp03_hallway_end_check, flag_sp03_end_hallway_teleport);
		sleep(15);
	end
	
	ai_erase_all();

	zoneset_prepare_and_load( DEF_S_ZONESET_SPIRE_03_INT_D );
	
	game_save();
	
	device_set_power(dm_sp03_int_door_04, 1);

	sleep_until(g_activate_spires, 1);
	
	device_set_power(dm_sp03_int_door_04, 0);
		
	sleep_until(device_get_position(dm_sp03_int_door_04) == 0, 1);
		
	volume_teleport_players_not_inside(tv_sp03_control_room_floor_area, flag_sp03_end_control_room_teleport);
end

// ===============================================
// SPIRE_03_LIGHT_BRIDGES
// ===============================================

// :: BOTTOM_BRIDGES
script dormant f_spire_03_bridge_bottom()
	dprint("f_spire_03_light_bridge_bottom");
	
	//xxx
	//wake(f_bridge_destroy_temp);
	sleep_s(2);
	wake(f_spire_03_bot_bridge_01);
	wake(f_spire_03_bot_bridge_02);
	wake(f_spire_03_bot_bridge_03);
	wake(f_spire_03_bot_bridge_04);
	wake(f_spire_03_bot_bridge_05);
	wake(f_spire_03_bot_bridge_06);
	wake(f_spire_03_bot_bridge_07);
end


script dormant f_sp03_set_transition_blocker()
	sleep_until(object_valid(dm_path_blocker_01), 1);
	
	device_set_position_track(dm_path_blocker_01, "any:idle", 0);
	sleep_until(volume_test_players(tv_spire_03_top_start), 1);
	sleep_s(2);
	sleep_until(not volume_test_players(tv_sp03_grav_lift_02), 1);
	
	sleep_s(2);
	
	device_animate_position(dm_path_blocker_01, 1, 4, 0.1, 0.1, TRUE );
	
end
// :: TOP_BRIDGES
script static void f_spire_03_light_bridge_top()
	dprint("f_spire_03_light_bridge_top");
//	thread(f_spire_03_create_light_bridge(ps_sp03_bridge_top.bridge_08_a, ps_sp03_bridge_top.bridge_08_b, cr_sp03_bridge_08));
//	thread(f_spire_03_create_light_bridge(ps_sp03_bridge_top.bridge_09_a, ps_sp03_bridge_top.bridge_09_b, cr_sp03_bridge_09));
//	thread(f_spire_03_create_light_bridge(ps_sp03_bridge_top.bridge_10_a, ps_sp03_bridge_top.bridge_10_b, cr_sp03_bridge_10));
//	thread(f_spire_03_create_light_bridge(ps_sp03_bridge_top.bridge_11_a, ps_sp03_bridge_top.bridge_11_b, cr_sp03_bridge_11));
//	thread(f_spire_03_create_light_bridge(ps_sp03_bridge_top.bridge_12_a, ps_sp03_bridge_top.bridge_12_b, cr_sp03_bridge_12));
//	thread(f_spire_03_create_light_bridge(ps_sp03_bridge_top.bridge_13_a, ps_sp03_bridge_top.bridge_13_b, cr_sp03_bridge_13));
//	thread(f_spire_03_create_light_bridge(ps_sp03_bridge_top.bridge_14_a, ps_sp03_bridge_top.bridge_14_b, cr_sp03_bridge_14));
end

//xxx
script dormant f_bridge_destroy_temp()
object_destroy(sc_sp03_bot_bridge_01);
object_destroy(sc_sp03_bot_bridge_02);
object_destroy(sc_sp03_bot_bridge_03);
object_destroy(sc_sp03_bot_bridge_04);
object_destroy(sc_sp03_bot_bridge_05);
object_destroy(sc_sp03_bot_bridge_06);
object_destroy(sc_sp03_bot_bridge_07);
end

// :: SPIRE_03_CREATE_BRIDGES
script dormant f_spire_03_bot_bridge_01()
	//sleep_until(volume_test_players(tv_sp03_bot_bridge_01) or object_valid(sc_sp03_bot_bridge_01), 1);
	f_sp03_create_bridge(sc_sp03_bot_bridge_01);
end

script dormant f_spire_03_bot_bridge_02()
//	sleep_until(volume_test_players(tv_sp03_bot_bridge_02) or object_valid(sc_sp03_bot_bridge_02) or f_sp03_bot_bridge_02_ai_gate(), 1);
	f_sp03_create_bridge(sc_sp03_bot_bridge_02);
end

script dormant f_spire_03_bot_bridge_03()
	//sleep_until(volume_test_players(tv_sp03_bot_bridge_03) or object_valid(sc_sp03_bot_bridge_03) or f_sp03_bot_bridge_03_ai_gate(), 1);
	f_sp03_create_bridge(sc_sp03_bot_bridge_03);
end

script dormant f_spire_03_bot_bridge_04()
	//sleep_until(volume_test_players(tv_sp03_bot_bridge_04) or object_valid(sc_sp03_bot_bridge_04) or f_sp03_bot_bridge_04_ai_gate(), 1);
	f_sp03_create_bridge(sc_sp03_bot_bridge_04);
end

script dormant f_spire_03_bot_bridge_05()
//	sleep_until(volume_test_players(tv_sp03_bot_bridge_05) or object_valid(sc_sp03_bot_bridge_05) or f_sp03_bot_bridge_05_ai_gate(), 1);
	f_sp03_create_bridge(sc_sp03_bot_bridge_05);
end

script dormant f_spire_03_bot_bridge_06()
//	sleep_until(volume_test_players(tv_sp03_bot_bridge_06) or object_valid(sc_sp03_bot_bridge_06), 1);
	f_sp03_create_bridge(sc_sp03_bot_bridge_06);
end

script dormant f_spire_03_bot_bridge_07()
	//sleep_until(volume_test_players(tv_sp03_bot_bridge_07) or object_valid(sc_sp03_bot_bridge_07) or f_sp03_bot_bridge_07_ai_gate(), 1);
	f_sp03_create_bridge(sc_sp03_bot_bridge_07);
end

script static void f_sp03_create_bridge(object_name bridge)
	if not object_valid(bridge) then
		object_create(bridge);
	end
end
/*
// :: SPIRE_03_BRIDGE_GATES
script static boolean f_sp03_bot_bridge_02_ai_gate()
	//ai_task_count(obj_sp03_bottom.fallback) != 0 and
	//ai_living_count(sg_sp03_bot_front) != 0;
	sleep(0);
end

script static boolean f_sp03_bot_bridge_03_ai_gate()
sleep_s(0);
	//ai_task_count(obj_sp03_bottom.gate_mid_right) == 0 and
	 //ai_living_count(sg_sp03_bot_right) != 0;
end

script static boolean f_sp03_bot_bridge_04_ai_gate()
sleep_s(0);
//	ai_task_count(obj_sp03_bottom.gate_mid_left) == 0 and
// ai_living_count(sg_sp03_bot_left) != 0;
end

script static boolean f_sp03_bot_bridge_05_ai_gate()
sleep_s(0);
	//ai_task_count(obj_sp03_bottom.gate_reinforcements) != 0 and
	// ai_living_count(sg_sp03_bot_back_left) != 0;
end

script static boolean f_sp03_bot_bridge_07_ai_gate() 
	ai_living_count(sg_sp03_bot_hunter) != 0;
end


*/
// ======================================
// SPIRE_03_GRAV_LIFTS
// ======================================

// :: SPIRE_03_GRAV_LIFT_01
script static void f_spire_03_gravlift_01()
	dprint("f_spire_03_gravlift_01");
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_01, player0));
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_01, player1));
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_01, player2));
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_01, player3));
end

// :: SPIRE_03_GRAV_LIFT_01
script static void f_spire_03_gravlift_02()
	dprint("f_spire_03_gravlift_02");
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_02, player0));
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_02, player1));
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_02, player2));
	thread(f_spire_03_remove_velocity(tv_sp03_grav_lift_02, player3));
end

// :: SPIRE_03_REMOVE_VELOCITY
script static void f_spire_03_remove_velocity(trigger_volume tv_gravlift, player p_player)
	dprint("f_spire_03_gravlift_killvelocity");
	sleep_until(volume_test_object(tv_gravlift, p_player), 1);
	repeat
	
	if not volume_test_object(tv_gravlift, p_player) then
		object_set_velocity (p_player, 0 );
	end
	
	until(not volume_test_object(tv_gravlift, p_player));
end

// -------------------------------------------------------------------------------------------------
// spire_03_INT: CHECKPOINTS
// -------------------------------------------------------------------------------------------------

script dormant f_spire_03_checkpoints()
	dprint("Spire_03_checkpoints");
	game_save_no_timeout();
	wake(f_spire_03_checkpoints_bottom);
	sleep_s(10);
	wake(f_spire_03_checkpoints_top);
end

script dormant f_spire_03_checkpoints_bottom()
	dprint("f_spire_03_checkpoints_bottom");
	thread(f_spire_03_checkpoints_no_timeout(tv_spire_03_bottom_start, "checkpoint_spire03_start"));
	thread(f_spire_03_checkpoints_no_timeout(tv_spire_03_bottom_mid, "checkpoint_spire03_mid"));
	thread(f_spire_03_checkpoints_no_timeout(tv_spire_03_bottom_back, "checkpoint_spire03_back"));
	thread(f_spire_03_checkpoints_no_timeout(tv_sp03_bottom_tw06, "checkpoint_spire03_hunter"));
end

script dormant f_spire_03_checkpoints_top()
	dprint("f_spire_03_checkpoints_top");
	sleep_until(volume_test_players(tv_spire_03_top_start), 1);
	game_save_no_timeout();
	sleep_until(volume_test_players(tv_sp03_top_front), 1);
	game_save_no_timeout();
	sleep_until(volume_test_players(tv_sp03_top_mid), 1);
	game_save_no_timeout();
	sleep_until(volume_test_players(tv_sp03_top_back), 1);
	repeat
		sleep_s(15);
		game_save_no_timeout();
	until(volume_test_players(tv_sp03_hallway_teleport), 1);
	game_save_no_timeout();
end

script static void f_spire_03_checkpoints_no_timeout(trigger_volume tv_save, string str_debug)
	sleep_until(volume_test_players(tv_save), 1);
	//game_save_no_timeout();
	checkpoint_no_timeout( TRUE, "str_debug" );
end



script dormant f_spire_03_top_object_spawn()
	dprint("f_spire_03_crate_spawn");
	sleep_until( volume_test_players(tv_sp03_bot_cleanup),1);
	object_create_folder(spire_03_top_cover_crates);
	object_create_folder(spire_03_top_weapon_crates);
	object_create_folder(spire_03_top_mc_crates);
	object_create(v_sp03_bansh_player_01);
	object_create(v_sp03_bansh_01);
	object_create(v_sp03_bansh_player_02);
	object_create(v_sp03_shade_mid_right);
	object_create(v_sp03_shade_mid_left);
	object_wake_physics(v_sp03_bansh_player_01);
	object_wake_physics(v_sp03_bansh_01);
	object_wake_physics(v_sp03_bansh_player_02);
end

script dormant f_spire_03_top_object_cleanup()
	dprint("f_spire_03_crate_spawn");
	
	object_destroy_folder(spire_03_top_cover_crates);
	object_destroy_folder(spire_03_top_weapon_crates);
	object_destroy_folder(spire_03_top_mc_crates);
	
end

script dormant f_spire_03_bottom_object_cleanup()
	dprint("f_spire_03_crate_spawn");
	sleep_until( volume_test_players(tv_sp03_bot_cleanup),1);
	object_destroy_folder(spire_03_bot_cover_crates);
	object_destroy_folder(spire_03_bot_weapon_crates);
	object_destroy_folder(spire_03_bot_mc_crates);
	ai_erase(sg_sp03_bot_all);
	garbage_collect_now();
end


//xxx
//cheevo
script dormant f_m70_cheevo()
	if game_difficulty_get_real() >= heroic then
		sleep_until(volume_test_object(tv_explore_the_floor, ai_get_object(sq_sp03_bot_hunter_01) ) or volume_test_object(tv_explore_the_floor, ai_get_object(sq_sp03_bot_hunter_02) ), 1);
		submit_incident_with_cause_player ( "achieve_m70_special" ,player0);
		submit_incident_with_cause_player ( "achieve_m70_special" ,player1);
		submit_incident_with_cause_player ( "achieve_m70_special" ,player2);
		submit_incident_with_cause_player ( "achieve_m70_special" ,player3);
		
		//achievement_grant_to_all_players("m70_special");
	else
		dprint("difficulty to low");
	end
end

script dormant f_sp03_bottom_kill_volumes()
sleep_until(volume_test_players(tv_spire_03_bottom_start), 1);
sleep_s(1);
sleep_until(not volume_test_players(tv_sp03_grav_lift_01), 1);
kill_volume_enable(kill_sp03_bot);
end

script dormant f_sp03_top_kill_volumes()
sleep_until(volume_test_players(tv_spire_03_top_start), 1);
sleep_s(1);
sleep_until(not volume_test_players(tv_sp03_grav_lift_02), 1);
kill_volume_enable(kill_soft_sp03_high);
kill_volume_enable(kill_sp03_high);
kill_volume_enable(kill_soft_sp03_top);
kill_volume_enable(kill_sp03_top);

end

script static void f_grav_lift_02_gaze_correct()
	if player_valid(player0()) then
		f_grav_lift_gaze_lock(tv_grav_lift_02_gaze_lock, ps_grav_gaze.p0, player0());
	end
	
	if player_valid(player1()) then
		f_grav_lift_gaze_lock(tv_grav_lift_02_gaze_lock, ps_grav_gaze.p0, player1());
	end

	if player_valid(player2()) then
		f_grav_lift_gaze_lock(tv_grav_lift_02_gaze_lock, ps_grav_gaze.p0, player2());
	end

	if player_valid(player3()) then
		f_grav_lift_gaze_lock(tv_grav_lift_02_gaze_lock, ps_grav_gaze.p0, player3());
	end

end

script static void f_grav_lift_01_gaze_correct()
	if player_valid(player0()) then
		f_grav_lift_gaze_lock(tv_grav_lift_01_gaze_lock, ps_grav_gaze.p1, player0());
	end
	
	if player_valid(player1()) then
		f_grav_lift_gaze_lock(tv_grav_lift_01_gaze_lock, ps_grav_gaze.p1, player1());
	end

	if player_valid(player2()) then
		f_grav_lift_gaze_lock(tv_grav_lift_01_gaze_lock, ps_grav_gaze.p1, player2());
	end

	if player_valid(player3()) then
		f_grav_lift_gaze_lock(tv_grav_lift_01_gaze_lock, ps_grav_gaze.p1, player3());
	end

end

script static void f_grav_lift_gaze_lock(trigger_volume tv_lift, point_reference p_point, player p_player)
	dprint("start test");
	//player_control_clamp_gaze(player0(),ps_grav_gaze.p0, 25 );
	sleep_until(volume_test_object(tv_lift, p_player) or object_get_health(p_player) <= 0, 1);
	
	if object_get_health(p_player) > 0 then
		player_control_lock_gaze (p_player, p_point, 150);
		sleep(40);
		player_control_unlock_gaze(p_player);
	end
	
	
end



script static void test1()
dprint("TEST");
	//player_control_clamp_gaze(player0(),ps_grav_gaze.p0, 25 );
	sleep_until(volume_test_object(tv_grav_lift_02_gaze_lock, player0()), 1);
	player_control_lock_gaze (player0(), ps_grav_gaze.p0, 100);
	sleep(40);
	player_control_unlock_gaze(player0());
end