//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// SPIRE_02
// =================================================================================================
// =================================================================================================
//SPIRE_02_FUNCTION_INDEX
// SPIRE_02_VARIABLES
// SPIRE_02_FUNCTIONS
// :: SPIRE_02_CLEANUP
// :: SPIRE_02_ZONE_ACTIVE
// SPIRE_02_MAIN
// SPIRE_02_CHECKPOINTS
// SPIRE_02_OBJECTIVE_BLIPS
// SPIRE_02_CORES
// SPIRE_02_CORE_CHECKS
// SP02_CORE_DEVICE_FUNCTIONS
// SPIRE_02_CORE_DESTROYED_ORDER
// SPIRE_02_CORE_DYNAMIC_COVER
// SPIRE_02_EXIT
// SPIRE_02_DOORS
// =========================
// SPIRE_02_VARIABLES
// =========================

global short S_SP02_OBJ_CON														= 0;
global short S_SP02_FIRST_CORE												= 0;
global short S_SP02_SECOND_CORE												= 0;
global short S_SP02_CORES_ACTIVE											= 0;
global short S_SP02_CORES_DESTROYED										= 0;

script static short S_DEF_OBJ_CON_SP02_START()			1; end
script static short S_DEF_OBJ_CON_SP02_TWO_CORE()		2; end
script static short S_DEF_OBJ_CON_SP02_ONE_CORE()		3; end
script static short S_DEF_OBJ_CON_SP02_ZERO_CORE()	4; end
script static short S_DEF_OBJ_CON_SP02_COMPLETE()		5; end

script static short DEF_SP02_CORE_01()			1; end
script static short DEF_SP02_CORE_02()			2; end
script static short DEF_SP02_CORE_03()			3; end


global boolean b_spire_02_button_active = FALSE;

//=============================
// SPIRE_02_FUNCTIONS
//=============================

script dormant f_spire_02_init()
	dprint( "::: f_spire_02_init :::" );
	wake(f_spire_02_cleanup);

	sleep_until( f_spire_02_Zone_Active() and (not f_spire_state_complete(DEF_SPIRE_02)) and f_spire_state_active(DEF_SPIRE_02), 1 );

	wake(f_spire_02_main);
end


// :: SPIRE_02_CLEANUP
script dormant f_spire_02_Cleanup()
	sleep_until( f_spire_state_complete(DEF_SPIRE_02) and (f_spire_state_active(DEF_SPIRE_02)), 1 );
	dprint( "::: f_spire_02_Cleanup :::" );

	sleep_forever( f_spire_02_main );

	wake(f_spire_02_AI_deinit);
end

// :: SPIRE_02_ZONE_ACTIVE
script static boolean f_spire_02_INT_Zone_Active()
	( current_zone_set_fully_active() >= DEF_S_ZONESET_SPIRE_02_INT_A ) and ( current_zone_set_fully_active() <= DEF_S_ZONESET_SPIRE_02_INT_B );
end

script static boolean f_spire_02_Zone_Active()
	(current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_02_EXT) or  f_spire_02_INT_Zone_Active();
end



// =======================
// SPIRE_02_MAIN
// =======================

script dormant f_spire_02_main()
	dprint("f_spire_02_INT_main_init");
	
	
//TODO: MAKE A CHECK FOR SPIRE CONDITIONS FIRST AND SECOND STAGING
//f_check_first_spire() 
//S_SPIRE_FIRST = S_SPIRE_TWO;
	thread(f_sp02_door_enter());
	sleep_until(f_spire_02_INT_Zone_Active(), 1);

	if f_check_first_spire(DEF_SPIRE_01) then 
		s_flight_state = S_DEF_FLIGHT_STATE_SECOND_COMPLETE();
			dprint("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
			dprint("game insertion point unlock 4");
			dprint("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
		game_insertion_point_unlock(4);
	else
		s_flight_state = S_DEF_FLIGHT_STATE_START_COMPLETE();
		dprint("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
		dprint("game insertion point unlock 3");
		dprint("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
		game_insertion_point_unlock(3);
	end
	data_mine_set_mission_segment ("m70_spire_02"); 
	player_set_profile( profile_coop_respawn );
	garbage_collect_now();
	
	wake( spire_02_doors );
	wake(f_spire_02_checkpoints);
	wake(f_spire_02_AI_init);

	
	game_save();
	f_spire_02_core_button();

	//objectives_show_up_to(2);
/*
	if f_check_first_spire(DEF_SPIRE_02) then
			objectives_show_up_to(2);
	elseif f_check_first_spire(DEF_SPIRE_01) then
			objectives_show_up_to(3);
	end
*/
	sleep_s(0.25);
	wake(f_sp02_core_start);
	wake(f_sp02_blip_cores);
	wake(f_core_destroyed_order);
	
	thread(f_sp02_checkpoint_combat());
	
	S_SP02_OBJ_CON = S_DEF_OBJ_CON_SP02_START();
	
	sleep_until(S_SP02_CORES_DESTROYED >= 1, 1);

	S_SP02_OBJ_CON = S_DEF_OBJ_CON_SP02_TWO_CORE();
	
	sleep_until(S_SP02_CORES_DESTROYED >= 2, 1);
	
	S_SP02_OBJ_CON = S_DEF_OBJ_CON_SP02_ONE_CORE();
	
	sleep_until(S_SP02_CORES_DESTROYED >= 3, 1);
	
	S_SP02_OBJ_CON = S_DEF_OBJ_CON_SP02_ZERO_CORE();
	
	wake(f_sp02_blip_exit);
	
	if f_check_first_spire(DEF_SPIRE_02) then
			objectives_finish(2);
	elseif f_check_first_spire(DEF_SPIRE_01) then
			objectives_finish(3);
	end
	
	thread(f_sp02_door_exit());
	thread(f_checkpoint_comander());
	
	if game_difficulty_get() >= "Legendary" then
		thread(f_knight_attack_check());
	end
	
	sleep_until(volume_test_players(tv_sp02_int_to_ext), 1);

	S_SP02_OBJ_CON = S_DEF_OBJ_CON_SP02_COMPLETE();
	
	f_spire_state_set ( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE());
	
	sleep(15);
	
end



script static void f_spire_02_core_button()
	sleep_until(b_spire_02_button_active and object_valid(dc_sp02_core_control), 1);
	dprint("f_spire_02_core_button");
	
	device_group_set_immediate ( dg_sp02_core_control, 1);
	device_set_position_immediate(dc_sp02_core_control, 0);
	
	sleep_until(device_get_position( dc_sp02_core_control ) != 0, 1);
	
	device_group_set_immediate ( dg_sp02_core_control, 0);
	f_unblip_flag (flg_spire02_switch);
	local long show_sp02_switch = pup_play_show("pup_sp02_switch");
	sleep_until(not pup_is_playing (show_sp02_switch), 1);
	game_save_no_timeout();
end


//===============================
// SPIRE_02_CHECKPOINTS
//===============================

script dormant f_spire_02_checkpoints()
	
	dprint("Spire_03_checkpoints");
	//checkpoint_no_timeout( TRUE, "SPIRE_02_START" );
	game_save_no_timeout();
	sleep_until(S_SP02_OBJ_CON == S_DEF_OBJ_CON_SP02_TWO_CORE(), 1);
	
	//checkpoint_no_timeout( TRUE, "SPIRE_02_FIRST_CORE_DESTROYED" );
	game_save_no_timeout();
	sleep_until(S_SP02_OBJ_CON == S_DEF_OBJ_CON_SP02_ONE_CORE(), 1);
	
	//checkpoint_no_timeout( TRUE, "SPIRE_02_SECOND_CORE_DESTROYED" );
	game_save_no_timeout();
	sleep_until(S_SP02_OBJ_CON == S_DEF_OBJ_CON_SP02_ZERO_CORE(), 1);
	
	//checkpoint_no_timeout( TRUE, "SPIRE_02_LAST_CORE_GONE" );
	game_save_no_timeout();
	sleep_until(S_SP02_OBJ_CON == S_DEF_OBJ_CON_SP02_COMPLETE(), 1);
	game_save_no_timeout();
	//checkpoint_no_timeout( TRUE, "SPIRE_02_SPIRE_02_COMPLETE" );
end

//===============================
// SPIRE_02_OBJECTIVE_BLIPS
//===============================

script dormant f_sp02_blip_cores()
	dprint("f_sp02_blip_cores");
	thread(f_sp02_core_blip( DEF_SP02_CORE_01(), cr_sp02_core_01) );
	thread(f_sp02_core_blip( DEF_SP02_CORE_02(), cr_sp02_core_02) );
	thread(f_sp02_core_blip( DEF_SP02_CORE_03(), cr_sp02_core_03) );
	wake(f_sp02_core_nudge);
end

script static void f_sp02_core_blip( short core_number, object_name obj_core )
	sleep_until(f_sp02_core_valid(core_number), 1);
	sleep(30);
	sleep_until(volume_test_players(f_core_trigger(core_number)) or S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE(), 1);
	
	if S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE() then
		sleep_s(4);
	end
	
	sleep_s(3);
	if f_sp02_core_valid(core_number) then
		if core_number ==  DEF_SP02_CORE_01() then
			f_blip_object(obj_core, "destroy");
		elseif core_number ==  DEF_SP02_CORE_02() then
			f_blip_object(obj_core, "destroy");
		elseif core_number ==  DEF_SP02_CORE_03() then
			f_blip_object(obj_core, "destroy");
		end
	end	
end

script dormant f_sp02_core_nudge()
	dprint("START NUDGE");
	sleep_until(object_valid(cr_sp02_core_01) and object_valid(cr_sp02_core_02) and object_valid(cr_sp02_core_03), 1);
	sleep_s(45);
	if S_SP02_CORES_ACTIVE == 0 then
		f_blip_object(cr_sp02_core_02, "destroy");
	end
	sleep_until(S_SP02_CORES_DESTROYED >= 1, 1);
	sleep_s(45);	
	if S_SP02_CORES_ACTIVE < 2 then
		if object_valid(cr_sp02_core_02) then
			f_blip_object(cr_sp02_core_02, "destroy");
		elseif object_valid(cr_sp02_core_03) then
			f_blip_object(cr_sp02_core_03, "destroy");
		elseif object_valid(cr_sp02_core_01) then
			f_blip_object(cr_sp02_core_01, "destroy");
		end
	end
end

script dormant f_sp02_blip_exit()
	sleep_s(3);
	f_blip_flag(flg_sp02_exit, "recon");
	sleep_until( volume_test_players(tv_spire02_objective_start) or volume_test_players(tv_sp02_hallway_check), 1) ;
	f_unblip_flag(flg_sp02_exit);
end

//=======================================
// SPIRE_02_CORES
//=======================================

script dormant f_sp02_core_start()
	dprint("f_sp02_core_start");
	wake(f_nar_knight_callouts);
	thread(f_sp02_core(DEF_SP02_CORE_02(), sg_core_02_knights));
	sleep_s(real_random_range(0.5, 1));
	thread(f_sp02_core(DEF_SP02_CORE_03(), sg_core_03_knights));
	sleep_s(real_random_range(0.5, 1));
	thread(f_sp02_core(DEF_SP02_CORE_01(), sg_core_01_knights ));
	//wake(f_sp02_core_01_start);
	sleep_s(1.5);
	wake(f_sp02_create_core_effect);
	
end

script dormant f_sp02_core_01_start()
	sleep_until(volume_test_players(tv_spire02_core_01) or volume_test_players_lookat( tv_spire02_core_01, 20, 20) or S_SP02_CORES_DESTROYED > 0, 1);
	thread(f_sp02_core(DEF_SP02_CORE_01(), sg_core_01_knights ));
end

script static void f_sp02_core(short core_number, ai core_gaurd)
	dprint("f_sp02_core");
	
	f_sp02_core_activate(core_number); //ACTIVATE CORE
	
	sleep_until(f_sp02_core_valid(core_number), 1);
	
	sleep_s(2);
	
	sleep_until(volume_test_players(f_core_trigger(core_number)) or not f_sp02_core_valid(core_number), 1);
	
		if f_sp02_core_valid(core_number) then 
			S_SP02_CORES_ACTIVE = S_SP02_CORES_ACTIVE + 1;
		end
	
	sleep_s(2);
	
	sleep_until( f_sp02_core_open_check( core_number, core_gaurd ) or not f_sp02_core_valid(core_number), 1);
	
		if f_sp02_core_valid(core_number) then 
			sleep_s(2);
			f_sp02_core_open( core_number ); //REVEAL CORE
		end	
		
	sleep_until (not f_sp02_core_valid(core_number), 1);
	thread(f_sp02_remove_core_effect());
	sleep(15);	
	thread(f_sp02_core_destroy( core_number)); //DESTROY CORE
	dprint("A CORE HAS BEEN DEFEATED");
	S_SP02_CORES_DESTROYED = (S_SP02_CORES_DESTROYED + 1); //INCREASE CORE DEATH COUNT
end


script dormant f_sp02_create_core_effect()
	dprint("f_sp02_add_core_effect");
	sleep_until(f_sp02_core_valid(DEF_SP02_CORE_01()), 1);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_11_spirebeam_center);

	sleep_until(f_sp02_core_valid(DEF_SP02_CORE_02()), 1);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_11_spirebeam_left);

	sleep_until(f_sp02_core_valid(DEF_SP02_CORE_03()), 1);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_11_spirebeam_right);

end

script static void f_sp02_remove_core_effect()
	if not f_sp02_core_valid(DEF_SP02_CORE_01()) then
		effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_11_spirebeam_center);
	elseif not f_sp02_core_valid(DEF_SP02_CORE_02()) then
  	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_11_spirebeam_left);
	elseif not f_sp02_core_valid(DEF_SP02_CORE_03()) then
		effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_11_spirebeam_right);

	end
end

   

//=============================================
// SPIRE_02_CORE_CHECKS
//=============================================

script static boolean f_sp02_core_open_check( short core_number, ai core_gaurd)
	volume_test_players(f_core_trigger(core_number)) and
	ai_living_count(core_gaurd) <= 0 and
	f_sp02_core_valid(core_number);
end


script static boolean f_sp02_core_valid(short core_number)
	if core_number == DEF_SP02_CORE_01() then
		object_valid(cr_sp02_core_01);
	elseif core_number == DEF_SP02_CORE_02() then
		object_valid(cr_sp02_core_02);
	elseif core_number == DEF_SP02_CORE_03() then
		object_valid(cr_sp02_core_03);
	end
end



//============================================
// SP02_CORE_DEVICE_FUNCTIONS
//============================================

script static void f_sp02_core_activate(short core_number)
	if core_number == DEF_SP02_CORE_01() then
		m70_spire2_core_01->f_sp02_cores_activate( cr_sp02_core_01, flg_sp02_core_01_up );	
	elseif core_number == DEF_SP02_CORE_02() then
		m70_spire2_core_02->f_sp02_cores_activate( cr_sp02_core_02, flg_sp02_core_02_up );
	elseif core_number == DEF_SP02_CORE_03() then
		m70_spire2_core_03->f_sp02_cores_activate( cr_sp02_core_03, flg_sp02_core_03_up );
	end
end

script static void f_sp02_core_open(short core_number)
	if core_number == DEF_SP02_CORE_01() then
		m70_spire2_core_01->f_sp02_cores_open( cr_sp02_core_01 );
	elseif core_number == DEF_SP02_CORE_02() then
		m70_spire2_core_02->f_sp02_cores_open(  cr_sp02_core_02 );
	elseif core_number == DEF_SP02_CORE_03() then
		m70_spire2_core_03->f_sp02_cores_open( cr_sp02_core_03 );
	end
end

script static void f_sp02_core_destroy(short core_number)
	if core_number == DEF_SP02_CORE_01() then
		f_sp02_core_close_core_01();
	elseif core_number == DEF_SP02_CORE_02() then
		f_sp02_core_close_core_02();
	elseif core_number == DEF_SP02_CORE_03() then
		f_sp02_core_close_core_03();
	end
end

script static void f_sp02_core_close_core_01()
	repeat
		sleep_until(not volume_test_players(tv_spire02_core_01_pstuck), 1);
		m70_spire2_core_01->f_sp02_cores_close();
		sleep_until(m70_spire2_core_01->f_sp02_core_check_close(), 1);
		sleep_s(0.5);
		if not volume_test_players(tv_spire02_core_01_pstuck) then
			m70_spire2_core_01->f_sp02_cores_deactivate();
			sleep_until(m70_spire2_core_01->f_sp02_core_check_destroyed(), 1);
		else
			m70_spire2_core_01->f_sp02_cores_reopen();
			sleep_until(m70_spire2_core_01->f_sp02_core_check_open(), 1);
		end
	until(m70_spire2_core_01->f_sp02_core_check_destroyed(), 1);
end

script static void f_sp02_core_close_core_02()
	repeat
		sleep_until(not volume_test_players(tv_spire02_core_02_pstuck), 1);
		m70_spire2_core_02->f_sp02_cores_close();
		sleep_until(m70_spire2_core_02->f_sp02_core_check_close(), 1);
		sleep_s(0.5);
		if not volume_test_players(tv_spire02_core_02_pstuck) then
			m70_spire2_core_02->f_sp02_cores_deactivate();
			sleep_until(m70_spire2_core_02->f_sp02_core_check_destroyed(), 1);
		else
			m70_spire2_core_02->f_sp02_cores_reopen();
			sleep_until(m70_spire2_core_02->f_sp02_core_check_open(), 1);
		end
	until(m70_spire2_core_02->f_sp02_core_check_destroyed(), 1);
end

script static void f_sp02_core_close_core_03()
	repeat
		sleep_until(not volume_test_players(tv_spire02_core_03_pstuck), 1);
		m70_spire2_core_03->f_sp02_cores_close();
		sleep_until(m70_spire2_core_03->f_sp02_core_check_close(), 1);
		sleep_s(0.5);
		if not volume_test_players(tv_spire02_core_03_pstuck) then
			m70_spire2_core_03->f_sp02_cores_deactivate();
			sleep_until(m70_spire2_core_03->f_sp02_core_check_destroyed(), 1);
		else
			m70_spire2_core_03->f_sp02_cores_reopen();
			sleep_until(m70_spire2_core_03->f_sp02_core_check_open(), 1);
		end
	until(m70_spire2_core_03->f_sp02_core_check_destroyed(), 1);
end

script static boolean f_core_device_check_open( short core_number)
	if core_number == DEF_SP02_CORE_01() then
		m70_spire2_core_01->f_sp02_core_check_open();
	elseif core_number == DEF_SP02_CORE_02() then 
		m70_spire2_core_02->f_sp02_core_check_open();
	elseif core_number == DEF_SP02_CORE_03() then
		m70_spire2_core_03->f_sp02_core_check_open();
	end
end

script static boolean f_core_device_check_close( short core_number)
	if core_number == DEF_SP02_CORE_01() then
		m70_spire2_core_01->f_sp02_core_check_close();
	elseif core_number == DEF_SP02_CORE_02() then 
		m70_spire2_core_02->f_sp02_core_check_close();
	elseif core_number == DEF_SP02_CORE_03() then
		m70_spire2_core_03->f_sp02_core_check_close();
	end
end

script static trigger_volume f_core_trigger(short core_number)
	if core_number == DEF_SP02_CORE_01() then
		tv_spire02_core_01;
	elseif core_number == DEF_SP02_CORE_02() then 
		tv_spire02_core_02;
	elseif core_number == DEF_SP02_CORE_03() then
		tv_spire02_core_03;
	end
end


//=============================================
// SPIRE_02_CORE_DESTROYED_ORDER
//=============================================

script dormant f_core_destroyed_order()
	dprint("f_core_destroyed_order");
	wake(f_sp02_core_first_destroyed_check);
	wake(f_sp02_core_second_destroyed_check);
end

script dormant f_sp02_core_first_destroyed_check()
	dprint("f_sp02_core_first_destroyed_check");
	sleep_until(S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_TWO_CORE(), 1);
	
	if not f_sp02_core_valid( DEF_SP02_CORE_01() ) then
	
		S_SP02_FIRST_CORE = DEF_SP02_CORE_01();
		
	elseif not f_sp02_core_valid( DEF_SP02_CORE_02() ) then
	
		S_SP02_FIRST_CORE = DEF_SP02_CORE_02();
		
	elseif not f_sp02_core_valid( DEF_SP02_CORE_03() ) then
	
		S_SP02_FIRST_CORE = DEF_SP02_CORE_03();
		
	end
end

script dormant f_sp02_core_second_destroyed_check()
	dprint("f_sp02_core_second_destroyed_check");
	sleep_until(S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE(), 1);
	
	if not f_sp02_core_valid( DEF_SP02_CORE_01() ) and S_SP02_FIRST_CORE != DEF_SP02_CORE_01() then
	
		S_SP02_SECOND_CORE = DEF_SP02_CORE_01();
		
	elseif not f_sp02_core_valid( DEF_SP02_CORE_02() ) and S_SP02_FIRST_CORE != DEF_SP02_CORE_02() then
	
		S_SP02_SECOND_CORE = DEF_SP02_CORE_02();
		
	elseif not f_sp02_core_valid( DEF_SP02_CORE_03() ) and S_SP02_FIRST_CORE != DEF_SP02_CORE_03() then
	
		S_SP02_SECOND_CORE = DEF_SP02_CORE_03();
		
	end

end




//==========================
// SPIRE_02_EXIT
//==========================
//object_active_for_script(door_to_airlock_two_scene_maya)

script static void f_spire_02_exit()
	dprint("f_spire02_exit");
	sleep_until((current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_02_EXT), 1);
	
	if f_check_first_spire(DEF_SPIRE_02) then 
		s_flight_state = S_DEF_FLIGHT_STATE_SECOND();
	else
		s_flight_state = S_DEF_FLIGHT_STATE_THIRD();
	end
	sleep(15);
	
	f_spires_exit_clear_pelican();
	object_create(flight_pelican_sp02);
	thread(f_pelican_disable_extra_seats( flight_pelican_sp02, flight_pelican_sp02));
	sleep(15);
	thread(f_spire_exit_respawn_pelican( flight_pelican_sp02, flight_pelican_sp02, tv_sp02_pelican));
	sleep_s(4);
	thread(f_sp02_blip_pelican());
end


//===============================
// SPIRE_02_DOORS
//===============================

script dormant spire_02_doors()
	dprint("f_sp02_door_enter");
	//wake(f_sp02_int_door_03_auto);
	//sleep_until(volume_test_players(tv_sp02_int_door_enter), 1);
	//thread(f_sp02_int_door_04_auto());	
end



script static void f_sp02_door_enter()
	dprint("f_sp02_door_enter");
	sleep_until(volume_test_players(tv_sp02_halway_teleport), 1);
	
	sleep(1);
	sleep_until(not volume_test_players(tv_dm_sp02_int_door_01), 1);
	
	device_set_power(dm_sp02_int_door_01, 0);
	
	sleep_until(device_get_position(dm_sp02_int_door_01) == 0, 1);
	
	if game_is_cooperative() then
		volume_teleport_players_not_inside(tv_sp02_hallway_check, flag_sp02_hallway);
		sleep(15);
	end
	
	zoneset_prepare_and_load( DEF_S_ZONESET_SPIRE_02_INT_B );
	
	game_save();
	
	device_set_power(dm_sp02_int_door_03, 1);
	
	sleep_until(device_get_position( dc_sp02_core_control ) != 0, 1);
	
	sleep(1);
	sleep_until(not volume_test_players(tv_dm_sp02_int_door_03), 1);
	
	device_set_power(dm_sp02_int_door_03, 0);
	
	sleep_until(device_get_position(dm_sp02_int_door_03) == 0, 1);
	
	volume_teleport_players_inside(tv_sp02_hallway_check, flag_spire02_enter_teleport);
	
end



script static void f_sp02_door_exit()
	dprint("f_sp02_door_exit");
	
	device_set_power(dm_sp02_int_door_03, 1);

	sleep_until(volume_test_players(tv_sp02_halway_teleport), 1);
	sleep(1);
	sleep_until(not volume_test_players(tv_dm_sp02_int_door_03), 1);
	
	device_set_power(dm_sp02_int_door_03, 0);
	
	sleep_until(device_get_position(dm_sp02_int_door_03) == 0, 1);
	
	if game_is_cooperative() then
		volume_teleport_players_not_inside(tv_sp02_hallway_check, flag_sp02_hallway);
	end
	
	zoneset_prepare_and_load( DEF_S_ZONESET_SPIRE_02_EXT );
	
	game_save();
	
	thread( f_spire_02_exit() );

	device_set_power(dm_sp02_int_door_01, 1);
	
	sleep_until(vehicle_test_players(), 1);	
	sleep(1);
	sleep_until(not volume_test_players(tv_dm_sp02_int_door_01), 1);
	
	device_set_power(dm_sp02_int_door_01, 0);
	
	sleep_until(device_get_position(dm_sp02_int_door_01) == 0, 1);
			
	volume_teleport_players_inside(tv_sp02_hallway_check, flag_pelican_exit_spire02);
	f_unblip_flag(flg_sp02_exit);
end

//knight attack
//if game_difficulty_get() >= "legendary" then
global boolean b_knight_attack = FALSE;

script static boolean f_knight_attack_gate()
	volume_test_players(tv_ka_01) and volume_test_players(tv_ka_02);
end

script static void f_knight_attack_check()
		sleep_until(ai_living_count(sg_sp02_all) <= 0);
		sleep_s(1);
		sleep_until(f_knight_attack_gate() or volume_test_players(tv_spire02_objective_start), 1);
			sleep_s(5);
			if f_knight_attack_gate() then
				thread(f_knight_attack());
			end
end

script static void f_knight_attack()
	dprint("f_knight_attack");
	
	thread(f_knight_attack_l());
	thread(f_knight_attack_r());
	sleep_s(2);
	sleep_until(ai_living_count(sg_knight_attack) == 0 or volume_test_players(tv_spire02_commander), 1);
	
	if ai_living_count(sg_knight_attack) <= 0  then
		object_create(sp02_ee_01);
		object_create(sp02_ee_02);
		object_create(sp02_ee_03);
		object_create(sp02_ee_04);
		object_create(sp02_ee_05);
		object_create(sp02_ee_06);
		object_create(sp02_ee_07);
		object_create(sp02_ee_08);
		object_create(sp02_ee_09);
		object_create(sp02_ee_10);
		object_create(sp02_ee_11);
		object_create(sp02_ee_12);
	else
		ai_kill(sg_knight_attack);
	end
end

script static void f_knight_attack_r()
	ai_place_in_limbo(sq_ka_r_knight_01);
	sleep_s(0.75);
	ai_place_in_limbo(sq_ka_r_knight_02);
	sleep_s(0.5);
	ai_place_in_limbo(sq_ka_r_rang);
	sleep_s(0.25);
	ai_place_in_limbo(sq_ka_r_com);
end

script static void f_knight_attack_l()
	ai_place_in_limbo(sq_ka_l_knight_01);
	sleep_s(0.75);
	ai_place_in_limbo(sq_ka_l_knight_02);
	sleep_s(0.5);
	ai_place_in_limbo(sq_ka_l_rang);
	sleep_s(0.25);
	ai_place_in_limbo(sq_ka_l_com);
end


script dormant f_nar_knight_callouts()
	sleep_until(ai_living_count(sg_core_01_knights) > 0 or ai_living_count(sg_core_02_knights) > 0 or ai_living_count(sg_core_03_knights) > 0, 1);
	sleep_s(0.3);
	sound_impulse_start(sound\dialog\mission\global\global_chatter_00164,"none", 1 );
	sleep_until(ai_is_shooting(sq_sp02_core_01_knight_02) or ai_is_shooting(sq_sp02_core_02_knight_02) or ai_is_shooting(sq_sp02_core_03_knight_02), 1);
	sleep_s(0.25);
	sound_impulse_start(sound\dialog\mission\global\global_chatter_00157,"none", 1 );
end
/*
script dormant f_sp02_phantom_blip()
	dprint("f_sp02_phantom_blip");
	if not f_sp02_core_valid(DEF_SP02_CORE_01()) then
		ai_place(sq_sp02_core_01_blip);
		sleep_s(1.25);
		ai_place(sq_sp02_core_01_blip);
	elseif not f_sp02_core_valid(DEF_SP02_CORE_02()) then
		ai_place(sq_sp02_core_02_blip);
		sleep_s(1.25);
		ai_place(sq_sp02_core_02_blip);
	elseif not f_sp02_core_valid(DEF_SP02_CORE_03()) then
		ai_place(sq_sp02_core_03_blip);
		sleep_s(1.25);
		ai_place(sq_sp02_core_03_blip);
	end
end
*/


script static void f_sp02_checkpoint_combat()
	sleep_until(S_SP02_CORES_DESTROYED > 0, 1);
	sleep_s(7);
	local real save_on_squad_kill  = (ai_living_count(sg_sp02_all) * 0.65);
	sleep_until(ai_living_count(sg_sp02_all) <= save_on_squad_kill, 1);
	checkpoint_no_timeout( TRUE, "CORE COMBAT CHECKPOINT" );
	sleep_until(S_SP02_CORES_DESTROYED > 1, 1);
	sleep_s(7);
	save_on_squad_kill  = (ai_living_count(sg_sp02_all) * 0.65);
	sleep_until(ai_living_count(sg_sp02_all) <= save_on_squad_kill, 1);
	checkpoint_no_timeout( TRUE, "CORE COMBAT CHECKPOINT" );
end

script static void f_checkpoint_comander()
	sleep_until(volume_test_players(tv_spire02_objective_start), 1);
	checkpoint_no_timeout( TRUE, "COMMANDER CHECKPOINT" );

end
/*
//xxxx

// =================================================================================================
// =================================================================================================
// *** DIDACT WARNINGS and RAMPENCY BLIPS ***
// =================================================================================================
// =================================================================================================
static boolean b_rampancy_blip_active = FALSE;

script static void f_spire_02_rampancy_blip_random( real r_time_min, real r_time_max, short s_select_min, short s_select_max, short s_range_min, short s_range_max )
static boolean b_flag_blip_01 = FALSE;
static boolean b_flag_blip_02 = FALSE;
static boolean b_flag_blip_03 = FALSE;
static boolean b_flag_blip_04 = FALSE;
static boolean b_flag_blip_05 = FALSE;
static boolean b_flag_blip_06 = FALSE;
static boolean b_flag_blip_07 = FALSE;
static boolean b_flag_blip_08 = FALSE;
static boolean b_flag_blip_09 = FALSE;
static boolean b_flag_blip_10 = FALSE;
static boolean b_flag_blip_11 = FALSE;
static boolean b_flag_blip_12 = FALSE;
static boolean b_flag_blip_13 = FALSE;
static boolean b_flag_blip_14 = FALSE;
static boolean b_flag_blip_15 = FALSE;
static boolean b_flag_blip_16 = FALSE;
static boolean b_flag_blip_17 = FALSE;
static boolean b_flag_blip_18 = FALSE;
static boolean b_flag_blip_19 = FALSE;
static boolean b_flag_blip_20 = FALSE;
//static boolean b_flag_blip_21 = FALSE;
//static boolean b_flag_blip_22 = FALSE;
//static boolean b_flag_blip_23 = FALSE;
//static boolean b_flag_blip_24 = FALSE;
//static boolean b_flag_blip_25 = FALSE;
//static boolean b_flag_blip_26 = FALSE;
//static boolean b_flag_blip_27 = FALSE;
//static boolean b_flag_blip_28 = FALSE;
//static boolean b_flag_blip_29 = FALSE;
//static boolean b_flag_blip_30 = FALSE;

local boolean b_shutdown = FALSE;
local short s_random_min = 0;
local short s_random_max = 0;
local long l_timer = 0;

//dprint( "f_spire_02_rampancy_blip_random: START" );

	repeat
	
		sleep_until( (l_timer <= game_tick_get()) or (not b_rampancy_blip_active), 1 );
			
		b_shutdown = not b_rampancy_blip_active;
		s_random_min = random_range( s_select_min, s_select_max );
		s_random_max = s_random_min + random_range( s_range_min, s_range_max );
		
		dprint( "----------" );
		inspect( s_random_min );
		inspect( s_random_max );
		
	
		b_flag_blip_01 = f_rampancy_blip_flag( sp02_flag_rampancy_01, b_flag_blip_01, 1, s_random_min, s_random_max );
		b_flag_blip_02 = f_rampancy_blip_flag( sp02_flag_rampancy_02, b_flag_blip_02, 2, s_random_min, s_random_max );
		b_flag_blip_03 = f_rampancy_blip_flag( sp02_flag_rampancy_03, b_flag_blip_03, 3, s_random_min, s_random_max );
		b_flag_blip_04 = f_rampancy_blip_flag( sp02_flag_rampancy_04, b_flag_blip_04, 4, s_random_min, s_random_max );
		b_flag_blip_05 = f_rampancy_blip_flag( sp02_flag_rampancy_05, b_flag_blip_05, 5, s_random_min, s_random_max );
		b_flag_blip_06 = f_rampancy_blip_flag( sp02_flag_rampancy_06, b_flag_blip_06, 6, s_random_min, s_random_max );
		b_flag_blip_07 = f_rampancy_blip_flag( sp02_flag_rampancy_07, b_flag_blip_07, 7, s_random_min, s_random_max );
		b_flag_blip_08 = f_rampancy_blip_flag( sp02_flag_rampancy_08, b_flag_blip_08, 8, s_random_min, s_random_max );
		b_flag_blip_09 = f_rampancy_blip_flag( sp02_flag_rampancy_09, b_flag_blip_09, 9, s_random_min, s_random_max );
		b_flag_blip_10 = f_rampancy_blip_flag( sp02_flag_rampancy_10, b_flag_blip_10, 10, s_random_min, s_random_max );
		b_flag_blip_11 = f_rampancy_blip_flag( sp02_flag_rampancy_11, b_flag_blip_11, 11, s_random_min, s_random_max );
		b_flag_blip_12 = f_rampancy_blip_flag( sp02_flag_rampancy_12, b_flag_blip_12, 12, s_random_min, s_random_max );
		b_flag_blip_13 = f_rampancy_blip_flag( sp02_flag_rampancy_13, b_flag_blip_13, 13, s_random_min, s_random_max );
		b_flag_blip_14 = f_rampancy_blip_flag( sp02_flag_rampancy_14, b_flag_blip_14, 14, s_random_min, s_random_max );
		b_flag_blip_15 = f_rampancy_blip_flag( sp02_flag_rampancy_15, b_flag_blip_15, 15, s_random_min, s_random_max );
		b_flag_blip_16 = f_rampancy_blip_flag( sp02_flag_rampancy_16, b_flag_blip_16, 16, s_random_min, s_random_max );
		b_flag_blip_17 = f_rampancy_blip_flag( sp02_flag_rampancy_17, b_flag_blip_17, 17, s_random_min, s_random_max );
		b_flag_blip_18 = f_rampancy_blip_flag( sp02_flag_rampancy_18, b_flag_blip_18, 18, s_random_min, s_random_max );
		b_flag_blip_19 = f_rampancy_blip_flag( sp02_flag_rampancy_19, b_flag_blip_19, 19, s_random_min, s_random_max );
		b_flag_blip_20 = f_rampancy_blip_flag( sp02_flag_rampancy_20, b_flag_blip_20, 20, s_random_min, s_random_max );


		l_timer = game_tick_get() + seconds_to_frames( real_random_range(r_time_min,r_time_max) );
	
	until( b_shutdown, 1 );

//dprint( "f_spire_02_rampancy_blip_random: END" );

end

script static boolean f_rampancy_blip_flag( cutscene_flag flg_flag, boolean b_blip_state, short s_index, short s_selection_min, short s_selection_max )

	if ( ((s_index >= s_selection_min) and (s_index <= s_selection_max)) or (not b_rampancy_blip_active) ) then
	
		if ( (not b_blip_state) and (b_rampancy_blip_active) ) then
			f_blip_flag( flg_flag, default );
			//dprint( "BLIP" );
			b_blip_state = TRUE;
		elseif ( b_blip_state ) then
			f_unblip_flag( flg_flag );
			//dprint( "UNBLIP" );
			b_blip_state = FALSE;
		end
	
	end	

	// RETURN
	b_blip_state;
end

script dormant f_sp02_rampancy_blips_start()
  sleep_s( 1 );
  b_rampancy_blip_active = TRUE;

	effect_attached_to_camera_new (fx\library\characters\cortana\rampancy\rampancy_glitch.effect );
	thread( f_spire_02_rampancy_blip_random(0.25, 1.0, 1, 5, 1, 3) );
	sleep_s( 0.5 );

	thread( f_spire_02_rampancy_blip_random(0.125, 1.0, 1, 7, 2, 3) );
	thread( f_spire_02_rampancy_blip_random(0.25, 0.75, 1, 10, 2, 3) );
	sleep_s( 2 );

	effect_attached_to_camera_new (fx\library\characters\cortana\rampancy\rampancy_glitch.effect );
	thread( f_spire_02_rampancy_blip_random(0.125, 0.5, 1, 15, 3, 5) );
	thread( f_spire_02_rampancy_blip_random(0.125, 0.5, 1, 15, 3, 5) );
	thread( f_spire_02_rampancy_blip_random(0.25, 0.75, 1, 20, 3, 5) );
	sleep_s( 1 );

	effect_attached_to_camera_new (fx\library\characters\cortana\rampancy\rampancy_glitch.effect );
	thread( f_spire_02_rampancy_blip_random(0.125, 0.5, 1, 20, 3, 7) );
	thread( f_spire_02_rampancy_blip_random(0.125, 0.5, 1, 20, 3, 7) );
	thread( f_spire_02_rampancy_blip_random(0.25, 0.75, 1, 25, 3, 7) );
	thread( f_spire_02_rampancy_blip_random(0.25, 0.75, 1, 25, 3, 7) );
	sleep_s( 0.5 );

	effect_attached_to_camera_new (fx\library\characters\cortana\rampancy\rampancy_glitch.effect );
	thread( f_spire_02_rampancy_blip_random(0.125, 0.5, 1, 25, 3, 7) );
	thread( f_spire_02_rampancy_blip_random(0.125, 0.5, 1, 25, 3, 7) );
	thread( f_spire_02_rampancy_blip_random(0.25, 0.75, 1, 30, 3, 7) );
	thread( f_spire_02_rampancy_blip_random(0.25, 0.75, 1, 30, 3, 10) );
	thread( f_spire_02_rampancy_blip_random(0.25, 0.75, 1, 30, 3, 10) );
	sleep_s( 0.25 );
	effect_attached_to_camera_new (fx\library\characters\cortana\rampancy\rampancy_glitch.effect );

	b_rampancy_blip_active = FALSE;
		
	f_cortana_rampancy_01();
end

script dormant f_sp02_rampancy_02()
	effect_attached_to_camera_new (fx\library\characters\cortana\rampancy\rampancy_glitch.effect );
	sound_impulse_start(sound\storm\characters\knight\vo\npc_storm_knight_vo_combat_any_go_berserk, player_get(0), 1 ); 
	sleep_s(0.75);
	effect_attached_to_camera_new (fx\library\characters\cortana\rampancy\rampancy_glitch.effect );	
	f_cortana_rampancy_02();
end

//Knight Scream all around the player =============================================================
script static void f_rampancy_scream()
  
	dprint( ":::scream:::" );
end

//Cortana comments on the blips01 =================================================================
script static void f_cortana_rampancy_01()
  sleep_s( 2 );
  storyblurb_display (ch_spire02_04, 5, FALSE, TRUE );
end


//Cortana comments on the blips02 =================================================================
script static void f_cortana_rampancy_02()
  sleep_s( 2 );
  storyblurb_display (ch_spire02_05, 5, FALSE, TRUE );
end


//Play Didact Scan FX =============================================================================
script static void f_sp02_rampancy_scan01()
  sleep_s( 2 );
	effect_new (environments\solo\m10_crash\fx\scan\didact_scan.effect, flag_didact01_scan );
	effect_new (environments\solo\m10_crash\fx\scan\didact_scan.effect, flag_didact02_scan );
end
