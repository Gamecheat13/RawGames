//// =============================================================================================================================
//========= CAVERNS e10_m3 RECON FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================



global boolean b_e10_m3_force_start = FALSE;
global boolean b_e10_m3_rendevous_complete = FALSE;
global boolean b_e10_m3_theark_init = FALSE;
global boolean b_e10_m3_reached_theark_obj = FALSE;
global boolean b_e10_m3_artifact_retrieved = FALSE;
global short 	s_e10_m3_ark_generator_count = 3;
global short 	s_e10_m3_hs_core_count = 5;
global boolean b_e10_m3_intro_ghost_flee = FALSE;
global short s_objcon_e10_m3 = 0;
global boolean b_e10_m3_door_open = FALSE;
global boolean b_e10_m3_door_fight_complete = FALSE;
global boolean b_e10_m3_obj_1_dead = FALSE;
global boolean b_e10_m3_obj_2_dead = FALSE;
global boolean b_e10_m3_obj_3_dead = FALSE;
global boolean b_e10_m3_door_reinforced = FALSE;
global boolean b_e10_m3_forerunner_spawn_done = FALSE;
global boolean b_e10_m3_lich_beacon = FALSE;
global boolean b_e10_m3_fore_struct_open = FALSE;
global boolean b_e10_m3_get_artifact = FALSE;
global boolean b_e10_m3_win = FALSE;
global boolean b_ics_button_touch_start = FALSE;
global boolean b_ics_button_touch_end	= FALSE;

/// LICH GLOBALS
global boolean b_e10_m3_lich_in_play = FALSE;
global boolean b_e10_m3_lich_attacking = FALSE;
global boolean b_e10_m3_lich_position_b_rdy = FALSE;
global boolean b_e10_m3_lich_position_b = FALSE;
global boolean b_e10_m3_lich_position_c_rdy = FALSE;
global boolean b_e10_m3_lich_position_c = FALSE;
global boolean b_e10_m3_move_lich_down = FALSE;
global boolean b_e10_m3_lich_wounded = FALSE;
global boolean b_e10_m3_lich_dead = FALSE;
global boolean b_e10_m3_lich_ready = FALSE;
global boolean b_e10_m3_sit_stable = FALSE;
//global boolean b_e10_m3_player_on_lich = FALSE;
global boolean b_e10_m3_player0_on_lich = FALSE;
global boolean b_e10_m3_player1_on_lich = FALSE;
global boolean b_e10_m3_player2_on_lich = FALSE;
global boolean b_e10_m3_player3_on_lich = FALSE;


global boolean b_e10_m3_generator_blip = FALSE;


script startup f_e10_m3_startup()
	
	//move into main script please
		kill_volume_disable( kill_e10_m3_lich_wipe  );	
	//Wait for start
	if ( f_spops_mission_startup_wait("e10_m3") or b_e10_m3_force_start ) then	
		dprint( "---------f_e10_m3_startup-----------" );
		wake( f_e10_m3_init );	
		f_spops_mission_setup( "e10_m3", "e10_m3_hills_up", sg_e10_m3_all_enemies, e10_m3_start_locs, 91 );	
	end
	
end

script static void debug_e10_m3()

	game_set_variant( e10_m3_hillside_blitzkrieg );
end

script dormant f_e10_m3_init()
	///fade_out (0,0,0,1);
	sleep_until(f_spops_mission_ready_complete(), 1);
	dprint("===== f_spops_mission_ready_complete");
	if editor_mode() then
		sleep_s (1);
	else	
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
	end
	
		dprint("BEGIN::::: e10 m3 hillside blitzkrieg");

	
	f_spops_mission_intro_complete( TRUE );

	
	thread( e10_m3_blitzkrieg_setup_main() );
	sleep_until( f_spops_mission_start_complete(), 1 );
	dprint("===== f_spops_mission_start_complete");
	b_end_player_goal = FALSE;
	b_wait_for_narrative_hud = TRUE;
	ai_allegiance ( forerunner, covenant );
	ai_allegiance ( covenant, forerunner );
end

script static void f_zone_num()
	inspect(current_zone_set_fully_active());
end

//b_end_player_goal = TRUE;


script static void e10_m3_blitzkrieg_setup_main()

		//dprint("setup main");

		wake( e10_m3_streaming );
		f_add_crate_folder( e10_m3_scenery );
		//f_add_crate_folder( e10_m3_start_locs );
		f_add_crate_folder( veh_e10_m3 );
		f_add_crate_folder( wps_e10_m3 );
		f_add_crate_folder( dms_e10_m3 );
		//f_add_crate_folder( eq_e10_m3 );
		f_add_crate_folder( crs_e10_m3_hillside );
		f_add_crate_folder( crs_e10_m3_hillside_pelicans );
		firefight_mode_set_crate_folder_at( e10_m3_start_locs, 91);	
		firefight_mode_set_crate_folder_at( e10_m3_respawn_locs_1, 92 );
		firefight_mode_set_crate_folder_at( e10_m3_respawn_locs_2, 93 );	
		firefight_mode_set_crate_folder_at( e10_m3_respawn_locs_3, 94 );		
		firefight_mode_set_crate_folder_at( e10_m3_respawn_theark, 95 );
		firefight_mode_set_crate_folder_at( e10_m3_respawn_lich, 96 );		
		firefight_mode_set_crate_folder_at( e10_m3_respawn_begin, 97 );
		firefight_mode_set_crate_folder_at( e10_m3_respawn_locs_end, 98 );
		firefight_mode_set_objective_name_at( e10_m3_lz_0 ,51 ); 	
		f_spops_mission_setup_complete( TRUE );
		dprint("===== f_spops_mission_setup_complete");
		//fade_in (0,0,0,30);
		thread( e10_m3_hillside_pelicans_smoke() );
		//dm_droppod_5 = dm_e10_m3_hillside_door;
		//dm_droppod_4 = dm_e10_m3_hillside_mid;
		
		
		
		
		sleep(5);
		thread( f_e10_m3_music_start() );
		thread( f_e10_m3_event0_start() );
		wake( f_e10_m3_objcon_controller );
		thread( e10_m3_creation() );
		thread( e10_m3_spawns_init() );
		wake( e10_m3_hillside_up_objectives );
		wake( e10_m3_hillside_down_init );
		wake( e10_m3_events );
		thread( e10_m3_theark_init() );
		thread( e10_m3_close_big_door_now() );
		thread( e10_m3_ghost_intro_flee() );
		thread( e10_m3_lichencounter_init() );
		thread( e10_m3_forerunner_int_init() );
		thread( e10_m3_cup_o_mearl_grey() );
		wake( e10_m3_fight_begin );
end


/////////////////////////////////////////
//  Hillside Up
/////////////////////////////////////////



script static void e10_m3_spawns_init()
	//ai_place( sg_e10_m3_dead_grunt );
	pup_play_show(pup_e10_m3_dead_grunt);
	thread( e10_m3_marine_manager() );
	wake( e10_m3_hillside_intro_spawns );
	sleep_s(1);
	wake( e10_m3_hillside_item_respawns ) ;	
end

script dormant e10_m3_hillside_item_respawns()

	thread(f_e10_m3_veh_respawn(veh_e10_m3_goose_02));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_01));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_04));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_06));	
	//thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_08));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_09));

end

script dormant e10_m3_basin_item_respawns()

	thread(f_e10_m3_veh_respawn(veh_e10_m3_goose_01));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_goose_03));
	//thread(f_e10_m3_veh_respawn(veh_e10_m3_goose_04));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_goose_05));
	
	//thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_02));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_03));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_05));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_07));
	thread(f_e10_m3_veh_respawn(veh_e10_m3_wardog_10));	
	
			
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_01));	
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_02));	
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_03));	
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_04));	
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_05));	
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_06));	
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_07));	
	thread(f_e10_m3_aa_respawn(eq_e10_m3_jp_08));	
	
	thread(f_e10_m3_veh_respawn(veh_e10_m3_ghost_01));	
	thread(f_e10_m3_veh_respawn(veh_e10_m3_ghost_02));
end

//  spops_blip_object( eq_e10_m3_jp_01, TRUE, "jetpack" );

script dormant e10_m3_events()
	//dprint("============");
	
	thread( vo_e10m3_start() );

	sleep_until( LevelEventStatus("end_e10_m3_1") ,1 );
		//dprint("event complete");
		sleep(1);
		sleep_until( not e10m3_narrative_is_on , 1);
			f_new_objective("e10_m3_enter_hillside");
			thread( e10_m3_start_door() );
end

global boolean b_e10_m3_earl_grey = FALSE;

script static void e10_m3_cup_o_mearl_grey()
	sleep_until( object_valid(cr_e10_m3_tea_cup) , 1);
	sleep_until( object_get_health( cr_e10_m3_tea_cup ) <= 0 , 1 );
		if s_objcon_e10_m3 < 20 then
			//dprint("i'm a little tea cup short and stout");
			b_e10_m3_earl_grey = TRUE;
			effect_new( environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, flg_e10_m3_exit_button);
		end
end

script static void e10_m3_start_door()
	//e10_m3_activate_button_sequence(dc_e10_m3_start_door );
	e10_m3_activate_button_sequence_forerunner( dc_e10_m3_start_door, dm_e10_m3_barrier_door, TRUE, flg_e10_m3_barrier_switch );
		e10_m3_open_start_door();
		thread( e10_m3_spartan_rendevous() );
		sleep_s(7);   
		object_destroy( sn_e10_m3_start_door );
end

script static void e10_m3_open_start_door()
	//object_move_by_offset( sn_e10_m3_start_door , 5, 0,0,5);
	sleep_s(0.5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e7m1_cov_barrier_down', sn_e10_m3_start_door, 1 ); //AUDIO!
	//object_set_function_variable(sn_e10_m3_start_door, shield_alpha, 1, 2);   
	object_dissolve_from_marker(sn_e10_m3_start_door, hard_kill, center);
	sleep_s(1);
	object_set_physics (sn_e10_m3_start_door, false);
	//center

end



script static void e10_m3_spartan_rendevous()
	vo_glo15_palmer_waypoint_01();
	spops_blip_flag( flg_e10_m3_rendevous, TRUE, "default" );
	f_new_objective("e10_m3_rendevous");
	thread( f_e10_m3_event0_stop() );
	thread( f_e10_m3_event1_start() );

	sleep_until( objects_distance_to_flag( Players(),flg_e10_m3_rendevous) < 6 or s_objcon_e10_m3 >= 15 ,1 );
		thread( vo_e10m3_downed_pelican() );
		spops_unblip_flag( flg_e10_m3_rendevous);
		//dprint("event complete");
		sleep_s(10);
		b_e10_m3_rendevous_complete = true;

end

script dormant e10_m3_hillside_up_objectives()
	sleep_until( b_e10_m3_rendevous_complete ,1 );
		//sleep_s(4);
		f_create_new_spawn_folder (97);
		sleep_until( not e10m3_narrative_is_on, 1);
			thread( vo_e10m3_to_gate() );
			sleep(1);
		sleep_until( not e10m3_narrative_is_on, 1);
		
		f_new_objective("e10_m3_uphill");
		spops_blip_flag(flg_e10_m3_hillside_step_1, TRUE, "default" );
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_hillside_step_1) < 15 or s_objcon_e10_m3 >= 20,1 ); 
		spops_unblip_flag( flg_e10_m3_hillside_step_1 );				
		spops_blip_flag( flg_e10_m3_hillside_mid ,TRUE, "recon" );
	sleep_until( s_objcon_e10_m3 > 15 ,1 );
		spops_unblip_flag( flg_e10_m3_hillside_mid );
		sleep_s(1);
		
		spops_blip_flag( flg_e10_m3_hillside_outpost ,TRUE, "recon" );		

	sleep_until( s_objcon_e10_m3 >= 30 ,1 );	
		sleep_s(1);
		spops_unblip_flag( flg_e10_m3_hillside_outpost );		
		spops_blip_flag( flg_e10_m3_hillside_door ,TRUE, "recon" );		
	sleep_until( s_objcon_e10_m3 >= 35 ,1 );	
		//sleep_s(5);
		vo_e10m3_secure_gate_enter();
		f_clear_spops_objectives();
		f_new_objective("e10_m3_defeat_forces");
		spops_unblip_flag( flg_e10_m3_hillside_door );
	sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 0 and b_e10_m3_door_drop_2_done,1 );//b_e10_m3_door_reinforced
		thread( f_e10_m3_event2_stop() );

		sleep_s(4);
		vo_e10m3_secure_gate();
		sleep(1);
	sleep_until( not e10m3_narrative_is_on, 1);		
		device_set_power( dc_e10_m3_hillside_door, 1 );
		b_e10_m3_door_fight_complete = TRUE;
		f_new_objective("e10_m3_open_gate");
		//e10_m3_activate_button_sequence( dc_e10_m3_hillside_door );

		e10_m3_activate_button_sequence_forerunner( dc_e10_m3_hillside_door, dm_e10_m3_main_door, TRUE, flg_e10_m3_door );
			//dprint("door open"); 
			thread( e10_m3_door_switch() );
			b_e10_m3_theark_init = TRUE;
			thread( f_e10_m3_event3_start() );
			
			//gmurphy 10815 -- starting up function to block players from getting out of the BSP
			thread (f_e10_m3_basin_door_teleport());
			
			e10_m3_open_big_door();
			sleep_s( 1 );
			f_new_objective("e10_m3_enter_basin");
			spops_blip_flag(flg_e10_m3_basin_enter, TRUE, "default" );	
			//spops_blip_flag( flg_e10_m3_theark , TRUE, "recon" );

			
end

script static void e10_m3_door_switch()
			device_set_power(dm_hillside_door_switch, 1);
			device_set_position( dm_hillside_door_switch, 1 );
			sleep_until( device_get_position( dm_hillside_door_switch ) >= 0.999 , 1);
			device_set_power(dm_hillside_door_switch, 0);
end

script dormant e10_m3_fight_begin()

	sleep_until ( volume_test_players(tv_e10_m3_intro_encounter), 1 );
		thread( f_e10_m3_event1_stop() );
		thread( f_e10_m3_event2_start() );	
	

end

script dormant e10_m3_hillside_intro_spawns()
	ai_place(sg_e10_m3_hillside_up);
	sleep_s(1);
	thread(e10_m3_intro_shade_get_on_it() );
	sleep_until( ( ai_spawn_count(sg_e10_m3_hillside_up) > 0 and ai_living_count(sg_e10_m3_hillside_up)<= 4 )   , 1);
		//dprint("placing exterior reinforcements");
			
		//#/// thread( e10_m3_door_droppod() );
		
		ai_place( sq_e10_me_cov_phantom_door_1 );
		//f_dlc_load_drop_pod (object_name dm_drop, ai squad, ai squad2, object_name pod)
		//ai_set_objective(sg_e10_m3_hillside_up_reinforce, e10_m3_enemy_hillside_obj );

	sleep_until(  b_e10_m3_door_drop_1_done  and ( ai_living_count(sg_e10_m3_hillside_up_reinforce)  +  ai_living_count(sg_e10_m3_hillside_up) <= 4 )   , 1);		
		
		ai_place( sq_e10_me_cov_phantom_door_2 );
		sleep(1);
		b_e10_m3_door_reinforced = TRUE;
	sleep_until( b_e10_m3_door_drop_2_done  and ( ai_living_count(sg_e10_m3_hillside_up_reinforce)  +   ai_living_count(sg_e10_m3_hillside_up) <= 3 )  , 1);
		vo_glo15_miller_few_more_07();
		f_blip_ai_cui( sg_e10_m3_hillside_up, "navpoint_enemy" );
		f_blip_ai_cui( sg_e10_m3_hillside_up_reinforce, "navpoint_enemy" );
end


script static void e10_m3_intro_shade_get_on_it()

	ai_vehicle_enter( sq_e10_3_hs_grunts_3, veh_e10_m3_shade_hs_1 );
	ai_vehicle_enter( sq_e10_3_hs_grunts_2, veh_e10_m3_shade_hs_2 );
	//ai_vehicle_enter( sq_e10_m3_ark_shade_grunt_3, veh_e10_m3_shade_3 );
end

script static void e10_m3_creation()
	
		object_create( dc_e10_m3_hillside_door );
		device_set_power(dc_e10_m3_hillside_door, 0 );
		object_create( dc_e10_m3_theark );
		device_set_power( dc_e10_m3_theark, 0 );		
		object_create( dc_e10_m3_start_door );		
		object_create( dc_e10_m3_exit_door );

		device_set_power( dc_e10_m3_exit_door, 0 );
		e10_3_hide_lichy();

end

script static void e10_3_hide_lichy()
	sleep_until( object_valid( lichy ),1 );
		//dprint("hiding lich");
		object_hide ( lichy, true );
		object_set_physics ( lichy, false );
		object_cannot_die( lichy, true );
end




script static void e10_m3_marine_manager()

	ai_place( sq_e10_m3_spartan_1 );
	
	if game_coop_player_count() < 3 then
		ai_place( sq_e10_m3_spartan_2 );		
	end
	
	sleep(1);
	
	ai_cannot_die( sq_e10_m3_spartan_1, TRUE );
	ai_cannot_die( sq_e10_m3_spartan_2, TRUE );
	
	sleep_s(1);
	thread( e10_m3_goose_squad_update() );
	thread( e10_m3_filler_squad_update() );
end

script static void e10_m3_close_big_door_now()
	//object_move_by_offset( sn_e10_m3_big_door , 0, 0,0,-5);
	//device_set_position( dm_hillside_basin_door, 0 );
	device_set_position_immediate ( dm_hillside_basin_door, 0 );
	b_e10_m3_door_open = FALSE;
end

script static void e10_m3_close_big_door()
	//object_move_by_offset( sn_e10_m3_big_door , 0, 0,0,-5);
	//device_set_position( dm_hillside_basin_door, 0 );
	device_set_position ( dm_hillside_basin_door, 0 );
	sleep_until( device_get_position(dm_hillside_basin_door) == 0, 1 );
		b_e10_m3_door_open = FALSE;
end

script static void e10_m3_open_big_door()
	//object_move_by_offset( sn_e10_m3_big_door , 5, 0,0,5);
	device_set_position( dm_hillside_basin_door, 0.99 );
	sleep_until( device_get_position(dm_hillside_basin_door) >= 0.95, 1 );
	b_e10_m3_door_open = TRUE;
end

script static boolean e10_m3_intro_grunt_active()
	volume_test_objects( tv_e10_m3_intro_encounter, ( ai_actors( sq_e10_3_hs_grunts_3 ) ));
end



////////////////////////////////////////////////////
//	THEARK
////////////////////////////////////////////////////

script static void debug_theark()
	b_e10_m3_theark_init = TRUE;
	s_objcon_e10_m3 = 30;
	e10_m3_open_big_door();

end


script static void e10_m3_theark_init()

	sleep_until( b_e10_m3_theark_init , 1 );
		dprint("===INIT=== THE ARK");
		garbage_collect_now();
		sleep(1);
		//object_create_folder(veh_e10_m3_basin );
		//sleep(2);
		object_create_folder(crs_e10_m3_ark);
		sleep(5);
		object_set_physics(cr_struct_barr_01, false);
		object_set_physics(cr_struct_barr_02, false);
		object_set_physics(cr_struct_barr_03, false);
		sleep(3);
		object_create( e10_m3_structure_dome );
		object_create( e10_m3_structure_skylight );
		//object_create( e10_m3_interior_shield );
		sleep(1);
		thread( e10_m3_theark_objectives ());
		thread( e10_m3_theark_initial_spawns() );
		sleep(1);
		flock_create(e10_m3_flocks);
		
		wake( e10_m3_basin_occupations );
		thread(f_103_rvb_interact() );
		sleep_s(1);
		object_create_folder( eq_e10_m3 );
		sleep_s(1);
		object_create_folder(veh_e10_m3_basin );
		sleep_s(1);
		thread( e10_m3_int_shade_get_on_it() );
		wake( e10_m3_basin_item_respawns );
end


script static void e10_m3_ghost_intro_flee()
	sleep_until( volume_test_players( tv_e10_m3_tunnel_trans ) );

		//dprint("flee ghost grunts");
		b_e10_m3_intro_ghost_flee = TRUE;
		//sleep_s(3);
		//thread( vo_e10m3_basin() );
end


script static void e10_m3_theark_initial_spawns()
	ai_place( sq_e10_m3_ghost_intro_grunts );
	sleep(1);
	ai_place( sq_e10_m3_ark_ghost_elite, 2 );
	ai_place( sq_e10_m3_ark_ghost_elite_2, 2 );	
	
	if game_coop_player_count() > 2 then
		ai_place( sq_e10_m3_ark_ghost_elite_3, 2 );		
	else
		ai_place( sq_e10_m3_ark_ghost_elite_3, 1 );	
	end
	
	sleep(2);
	ai_place( sg_e10_m3_ark_shades );
	
	sleep(15);
	
	sleep_until( ai_living_count(sg_e10_m3_all_enemies) <= 5 and s_e10_m3_ark_generator_count <= 0);
			//thread( e10_m3_close_big_door() );
			//vo_glo15_miller_few_more_04();
			f_blip_ai_cui(sg_e10_m3_all_enemies, "navpoint_enemy");			
	sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 0,1 );	
			thread( f_e10_m3_event3_stop() );
			thread( e10_m3_close_big_door() );
		  ai_place( sq_e10_me_cov_phant_structure ) ;	
		  sleep(5);
		  thread( spops_ai_population_extra_cnt_phantom( sq_e10_me_cov_phant_structure ) );		
		  sleep(30);
		  ai_place( sq_e10_me_cov_phant_escort_1 );
		  sleep( 30);
		  ai_place( sq_e10_me_cov_phant_escort_2 );
		  
	sleep_until ( not b_e10_m3_door_open, 1 );
		volume_teleport_players_not_inside_with_vehicles(  tv_e10_m3_teleport_basin,  flg_e10_m3_teleport_in );
			sleep_s(1);
			prepare_to_switch_to_zone_set( "e10_m3_bowl_fore" );
			dprint("+++waiting for prepare zone set+++");
	sleep_until( not PreparingToSwitchZoneSet(), 1 );
			dprint("+++finished prepare zone set+++");
			object_destroy( e10_m3_structure_dome );
			thread( f_e10_m3_event4_start() );
			b_e10_m3_fore_struct_open = TRUE;
			sleep(1);
			object_set_physics(cr_struct_barr_01, TRUE);
			object_set_physics(cr_struct_barr_02, TRUE);
			object_set_physics(cr_struct_barr_03, TRUE);
			
end

script static void e10_m3_int_shade_get_on_it()

	ai_vehicle_enter( sq_e10_m3_ark_shade_grunt_1, veh_e10_m3_shade_1 );
	ai_vehicle_enter( sq_e10_m3_ark_shade_grunt_2, veh_e10_m3_shade_2 );
	ai_vehicle_enter( sq_e10_m3_ark_shade_grunt_3, veh_e10_m3_shade_3 );
end

script static void e10_m3_theark_objectives()
	
	sleep_until( volume_test_players(tv_e10_m3_theark_entrance) ,1 );
		spops_unblip_flag( flg_e10_m3_basin_enter );
		f_create_new_spawn_folder (95);
		spops_blip_flag( flg_e10_m3_theark , TRUE, "recon" );
	sleep_until( volume_test_players(tv_e10_m3_theark) ,1 );
		spops_unblip_flag( flg_e10_m3_basin_enter );
		thread( vo_e10m3_shields() );
		sleep_until( b_e10_m3_generator_blip , 1 );
			b_e10_m3_reached_theark_obj = TRUE;
				
			spops_unblip_flag( flg_e10_m3_theark);
			thread(e10_m3_theark_destroy_gens());	
			
			f_new_objective("e10_m3_destroy_shield_gens");
			

end



script static void e10_m3_theark_destroy_gens()
	//dprint("destroy geneators");
	thread(e10_m3_ark_generator_setup( cr_e10_m3_ark_gen_1 ));
	thread(e10_m3_ark_generator_setup( cr_e10_m3_ark_gen_2 ));
	thread(e10_m3_ark_generator_setup( cr_e10_m3_ark_gen_3 ));

	sleep_until( s_e10_m3_ark_generator_count <= 0 , 1);
		//dprint("all generators destroyed");

end


script static void e10_m3_generator_vo()

	 if s_e10_m3_ark_generator_count == 2  then
	 	if not e10m3_narrative_is_on then
	 		thread( vo_e10m3_first_down() );
	  end
	 elseif s_e10_m3_ark_generator_count == 1 then
	 	if not e10m3_narrative_is_on then
	 		thread( vo_e10m3_second_down() );
	  end	 
	 else
	 	//if not e10m3_narrative_is_on then
	 		sleep_until(  b_e10_m3_fore_struct_open and not e10m3_narrative_is_on,1 );	
		 		vo_e10m3_third_down();
		 		//sleep(30);
		 		////vo_e10m3_throwing();
	  //end
	 end

end

script static void e10_m3_ark_generator_setup( object_name gen )
	
	ai_object_set_team( gen, covenant );
	ai_object_enable_targeting_from_vehicle( gen, TRUE );
	ai_object_set_targeting_bias( gen, 0.5 ); 

	
	if object_get_health(gen) > 0 then
		//f_blip_object(gen, "neutralize");
		spops_blip_object( gen, true, "neutralize_health" );
	end
	
	sleep_until( object_get_health(gen) <= 0 ,1 );
		s_e10_m3_ark_generator_count = s_e10_m3_ark_generator_count - 1;
		//dprint("ark generator destroyed");
		//f_unblip_object(gen);
		spops_blip_object( gen, false );
		
		if gen == cr_e10_m3_ark_gen_1 then
			sleep(3);
			object_destroy(cr_e10_m3_ark_gen_1_bub);
			b_e10_m3_obj_1_dead = TRUE;
			thread( e10_m3_generator_vo() );
		end
		
		if gen == cr_e10_m3_ark_gen_2 then
			sleep(3);
			object_destroy(cr_e10_m3_ark_gen_2_bub);
			b_e10_m3_obj_2_dead = TRUE;
			thread( e10_m3_generator_vo() );
		end
		
		if gen == cr_e10_m3_ark_gen_3 then
			sleep(3);
			object_destroy(cr_e10_m3_ark_gen_3_bub);
			b_e10_m3_obj_3_dead = TRUE;
			thread( e10_m3_generator_vo() );
		end
end

////////////////////////////////////////////////////
//	FORERUNNER INTERIOR
////////////////////////////////////////////////////

script static void debug_hs_forerunner_interior()

	ai_erase_all();
	sleep(5);
	ai_erase_all();
	s_objcon_e10_m3 = 50;
	b_e10_m3_fore_struct_open = TRUE;
	thread( debug_e10m3_phantom_interior());
	//e10_m3_forerunner_int_init();
end


script static void debug_e10m3_phantom_interior()

		  ai_place( sq_e10_me_cov_phant_structure ) ;	
		  sleep(5);
		  thread( spops_ai_population_extra_cnt_phantom( sq_e10_me_cov_phant_structure ) );		
		  sleep(15);
		  ai_place( sq_e10_me_cov_phant_escort_1 );
		  sleep( 15);
		  ai_place( sq_e10_me_cov_phant_escort_2 );
			sleep_s( 6 );
			//dprint("barrier comes down");
			
			object_destroy( e10_m3_structure_dome );

			//object_destroy( e10_m3_shield_left );

end

script static void e10_m3_forerunner_int_init()
	//sleep_until( b_e10_m3_fore_struct_open , 1);
	sleep_until( current_zone_set_fully_active() == 8, 1 );
		dprint("==INIT== FORERUNNER INTERIOR");
		garbage_collect_now();
		sleep(1);
		thread(e10_m3_forerunner_interior_objectives());
		object_create( wp_e10_m3_sniper_1 );
		object_create( wp_e10_m3_sniper_2 );
		thread( e10_m3_unsc_marines_storm_struct() );
end


global long l_e10_m3_structure_blip = -1;
script static void e10_m3_forerunner_interior_objectives()
		//dprint("story bits");
	e10m3_narr_clear_wait();	
	vo_e10m3_throwing();
	l_e10_m3_structure_blip = spops_blip_auto_flag_trigger( flg_e10_m3_structure, "default", tv_e10_m3_structure_all, FALSE );
	//spops_blip_flag(flg_e10_m3_structure);
	//
	spops_blip_auto_flag_trigger( flg_e10_m3_structure_int, "default", tv_e10_me_structure_int_blip, TRUE, l_e10_m3_structure_blip );
	f_new_objective("e10_m3_enter_struct");
		thread( e10_m3_interior_fore_spawns() );
	sleep_until( volume_test_players(tv_e10_m3_structure_entrance), 1);
		spops_unblip_flag(flg_e10_m3_structure);
		f_new_objective("e10_m3_defeat_fore");
		
	sleep_until( b_e10_m3_forerunner_spawn_done and ai_living_count(sg_e10_m3_all_enemies) <= 0 , 1);
		thread( f_e10_m3_event4_stop() );
		kill_thread( l_e10_m3_structure_blip );
		sleep_s(3);		
		
	 	vo_e10m3_interior_pt_1();
		sleep(1);
		sleep_until( not e10m3_narrative_is_on, 1);
		f_clear_spops_objectives();
		f_new_objective("e10_m3_call_in_lich");
		//e10_m3_activate_button_sequence( dc_e10_m3_theark );
		thread( vo_e10m3_interior_pt_2() );
		e10_m3_activate_button_sequence_comm();		
		
			b_e10_m3_lich_beacon = TRUE;
			sleep_until( not e10m3_narrative_is_on, 1);
				thread( vo_e10m3_button_pressed() );			
end

script static void e10_m3_unsc_marines_storm_struct()

	sleep_until( volume_test_objects(tv_e10_m3_structure_dropoff, ai_actors(sq_e10_m3_spartan_1)) ,1 );
		if b_e10_m3_fore_struct_open and not b_e10_m3_lich_beacon then
			dprint("dumping ai");
			ai_vehicle_exit(sq_e10_m3_spartan_1);
			sleep_s(1);
			cs_run_command_script(sq_e10_m3_spartan_1.boomer, cs_e10_m3_unsc_rush_struct);
			cs_run_command_script(sq_e10_m3_spartan_1.brobee, cs_e10_m3_unsc_rush_struct);
		end
end

script command_script cs_e10_m3_unsc_rush_struct()

	ai_vehicle_exit(ai_current_actor);

	begin_random_count(1)
		cs_go_to_and_face ( ps_e10_m3_theark.p14,ps_e10_m3_theark.pface);
		cs_go_to_and_face ( ps_e10_m3_theark.p15,ps_e10_m3_theark.pface);
		cs_go_to_and_face ( ps_e10_m3_theark.p16,ps_e10_m3_theark.pface);
		cs_go_to_and_face ( ps_e10_m3_theark.p17,ps_e10_m3_theark.pface);
		cs_go_to_and_face ( ps_e10_m3_theark.p18,ps_e10_m3_theark.pface);
		cs_go_to_and_face ( ps_e10_m3_theark.p19,ps_e10_m3_theark.pface);
		cs_go_to_and_face ( ps_e10_m3_theark.p20,ps_e10_m3_theark.pface);
	end
	
end

script static void e10_m3_interior_fore_spawns()
	dprint("kill forerunners");
	//ai_place(sg_e10_m3_fore_bowl);
	ai_place_in_limbo( sq_e10_m3_for_knight_1 );
	sleep(10);
	ai_place_in_limbo( sq_e10_m3_for_rang_1 );
	ai_place_with_birth( sq_e10_m3_for_bish_1 );
	ai_place_with_birth( sq_e10_m3_for_bish_2 );
	ai_place_with_birth( sq_e10_m3_for_bish_3 );
	//sleep_s( 10 );
	thread( e10_m3_crazy_train() );
	//sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 8,1 );	
		//ai_place( sq_e10_me_cov_phantom_2 ) ;
		sleep_s(3);
	sleep_until( ai_living_count(sq_e10_m3_for_knight_1) + ai_living_count(sq_e10_m3_for_rang_1)  <= 3,1 );
	
		ai_place_in_limbo( sq_e10_m3_for_knight_2 );
		if game_coop_player_count() >= 3 then
			sleep_until(ai_living_count(sq_e10_3_hs_grunts_2) + ai_living_count(sq_e10_3_hs_grunts_1) <= 2 ,1);
				ai_place_in_limbo( sq_e10_m3_for_rang_2 );
		end
		sleep_s(3);
		b_e10_m3_forerunner_spawn_done = TRUE;
	sleep_until( ai_living_count(sg_e10_m3_all_enemies) <= 3, 1);
			vo_glo15_miller_few_more_02();
			f_blip_ai_cui(sg_e10_m3_all_enemies, "navpoint_enemy");
end

script static void e10_m3_crazy_train()
	sleep_until( s_objcon_e10_m3 >= 53,1 );
	sleep_until( ai_living_count(sg_e10_m3_fore_bowl_bishop) <= 0,1 );
		if object_get_health(sq_e10_m3_for_knight_1.abe) > 0 then
			ai_advance_immediate(sq_e10_m3_for_knight_1.abe);
			sleep_s( 5 );
		end
		if object_get_health(sq_e10_m3_for_knight_1.bee) > 0 then
			ai_advance_immediate(sq_e10_m3_for_knight_1.bee);
			sleep_s( 5 );
		end

		if object_get_health(sq_e10_m3_for_knight_1.see) > 0 then
			ai_advance_immediate(sq_e10_m3_for_knight_1.see);
			sleep_s( 5 );
		end

end




////////////////////////////////////////////////////
//	LICH FIGHT
////////////////////////////////////////////////////

script static void e10_m3_lichencounter_init()

	sleep_until( b_e10_m3_lich_ready, 1 );
		dprint("===INIT=== lich INIT");
		
		e10_3_hide_lichy();
		thread( e10_m3_lich_init());
		thread( e10_m3_lich_events() );
		thread( e10_m3_lich_battle_spawn() );
		f_create_new_spawn_folder (96);
		s_objcon_e10_m3 = 55;
		garbage_collect_now();
		object_destroy( veh_e10_m3_shade_hs_1 );
		object_destroy( veh_e10_m3_shade_hs_2 );
end

script static void debug_lich_init()

	b_e10_m3_lich_ready = TRUE;   //FOR DEBUG, should be TRUE already in normal playthrough
end

script static void debug_lich_wounded()
	if not editor_mode() then
		switch_zone_set("e10_m3_bowl");
	end
	b_e10_m3_lich_ready = 1;
	b_e10_m3_lich_in_play = TRUE;
	b_e10_m3_lich_attacking = TRUE;
	debug_e10_m3_lich_down = TRUE;		
	//sleep(5);
end

script static void e10_m3_lich_init()

//lich coords -41.021751, -209.261093, 56.800842
	object_set_physics (lichy, true);
	//object_hide (lichy, false);
  ai_place( sq_e10_m3_banshee_1 );

  ai_place( sq_e10_m3_banshee_2 );
  ai_place( sq_e10_m3_banshee_3 );

  ai_place( sq_e10_m3_banshee_4 );	
  sleep_s(2.0);  
	ai_place (sq_e10_m3_cov_lich);
	thread( f_e10_m3_event5_start() );
		  		  
  sleep_s(3.5);
  ai_place( sq_e10_me_cov_phant_escort_1 );
  sleep( 30);
  ai_place( sq_e10_me_cov_phant_escort_2 );
  sleep(15);

		  
end
//flg_e10_m3_lich_front
script static void e10_m3_lich_events()
	sleep_until( b_e10_m3_lich_in_play,1);
		//dprint("Lich in play");		
	sleep_until( b_e10_m3_lich_attacking,1);			
			thread( vo_e10m3_fending_waves() );	
			sleep_s(5);
			f_new_objective("e10_m3_fight_lich");				
	sleep_until(b_e10_m3_lich_wounded, 1);
		dprint("lich_wounded");
		e10m3_narr_clear_wait();
		thread( vo_e10m3_right() );
		sleep(1);
	sleep_until(b_e10_m3_sit_stable, 1);
		f_new_objective( "e10_m3_board_lich" );
		spops_blip_flag(flg_e10_m3_lich_front);
		thread( e10_m3_blip_jetpacks() );
	sleep_until( e10_m3_any_player_on_lich(), 1);		

		thread(e10_m3_lich_power_core());
		thread( f_e10_m3_event6_stop() );
		thread( f_e10_m3_event7_start() );
		e10m3_narr_clear_wait();
		thread( vo_e10m3_onboard() );
		sleep_s(3);		
		spops_unblip_flag(flg_e10_m3_lich_front);
		


	e10m3_narr_clear_wait();		
			thread( vo_e10m3_take_core() );
			sleep(1);
	e10m3_narr_clear_wait()	;
			spops_blip_object( dc_e10_m3_lich_powercore, TRUE, "recover" );//spops_blip_object( dc_e10_m3_lich_powercore, TRUE, "recover" );//e10m3_oct_nuke //flg_e10_m3_lich_core_damage
			//spops_blip_flag( flg_e10_m3_lich_core_damage, TRUE, "recover" );
			f_new_objective( "e10_m3_take_core" );
	sleep_until( b_e10_m3_lich_dead, 1);
	e10m3_narr_clear_wait();
			thread( vo_e10m3_lich_explodes() );
			sleep(1);
	//sleep_until( not e10m3_narrative_is_on, 1);
	e10m3_narr_clear_wait();		
			thread( vo_e10m3_get_down_hill() );
end
		
		
		
			
			// I think you should stop looking at my monitor. Go outside. Get some fresh air.  Write a song.
			//
			//Listen to the new Pinback album. It's really good.
global long l_lich_sit_pup = -1;
global boolean debug_e10_m3_lich_down = FALSE;

script command_script cs_e10_m3_ark_lich()
	object_set_scale( lichy, 0.1, 0 );
	
	sleep(1);
	object_move_to_point( lichy, 0, ps_e10_m3_lich.pstart);
	//object_move_to_point( lichy, 0, ps_e10_m3_lich_move.pdock_hill_high);  //TEMP
	//sleep(1);
	object_hide (lichy, false);
	object_set_scale( lichy, 1, 30 * 8 );
	cs_vehicle_speed (1);	
	ai_disregard(ai_actors(ai_current_actor), TRUE);	
	object_cannot_take_damage ( object_at_marker( lichy, "power_core" ) );
	thread( e10_m3_player_on_the_lich_setup() );
	
	if not debug_e10_m3_lich_down then
	
		thread( e10_m3_lich_blip() );
		
		cs_fly_by (ps_e10_m3_lich_move.p_in);
		
		b_e10_m3_lich_in_play = TRUE;
		cs_fly_by (ps_e10_m3_lich_move.p_mid_enter);
		thread( e10_m3_load_lich_gunners() );
	
		cs_vehicle_speed (0.5);	
		cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill_high, ps_e10_m3_lich_move.pface_forward, 3);
		
		cs_vehicle_speed (0.4);
		//sleep_s(10);
		cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill_high, ps_e10_m3_lich_move.pface_rear, 0.5);
		cs_vehicle_speed (0.2);
	
		b_e10_m3_lich_attacking = TRUE;
		garbage_collect_now();
		cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill, ps_e10_m3_lich_move.pface_rear, 0.3);
		thread( e10_m3_lich_ranger_spawner() );
		
	
		sleep_until( b_e10_m3_lich_position_b and e10_m3_lich_ranger_clear(), 1);
			cs_vehicle_speed (0.5);
			cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill_high, ps_e10_m3_lich_move.pface_rear, 3);///
			cs_vehicle_speed (0.3);
			cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill_b, ps_e10_m3_lich_move.pface_forward, 3);
				
			cs_vehicle_speed (0.2);
			cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill_b, ps_e10_m3_lich_move.pface_forward, 1);
			dprint("In Position B");
			b_e10_m3_lich_position_b_rdy = TRUE;	
			thread( f_e10_m3_event5_stop() );
			thread( f_e10_m3_event6_start() );
		sleep_until( b_e10_m3_lich_position_c and e10_m3_lich_ranger_clear(), 1);
			cs_vehicle_speed (0.5);
			cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill_high, ps_e10_m3_lich_move.pface_forward, 3);///
			cs_vehicle_speed (0.3);
			cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill, ps_e10_m3_lich_move.pface_rear, 3);
	
			cs_vehicle_speed (0.2);
			cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hill, ps_e10_m3_lich_move.pface_rear, 1);
			b_e10_m3_lich_position_c_rdy = TRUE;		
		
		sleep_until( b_e10_m3_move_lich_down, 1);
	end
	
		
	sleep_s(3);
	b_e10_m3_lich_attacking = FALSE;
	cs_vehicle_speed (0.75);
	cs_fly_by (ps_e10_m3_lich_move.p0);
	cs_vehicle_speed (0.3);
	b_e10_m3_lich_wounded = TRUE;
	cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hurt_high, ps_e10_m3_lich_move.phurt_face, 3);
	cs_vehicle_speed (0.15);
	cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hurt_high, ps_e10_m3_lich_move.phurt_face, 2);
	cs_vehicle_speed (0.1);
	cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hurt, ps_e10_m3_lich_move.phurt_face, 0.50);
	cs_vehicle_speed (0.1);
	b_e10_m3_sit_stable = TRUE;
	dprint("docking");
	cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hurt, ps_e10_m3_lich_move.phurt_face, 3);
	ai_braindead(ai_current_actor, TRUE);
	dprint("movingtopoint");
	object_move_to_point( lichy, 2, ps_e10_m3_lich_move.pdock_hurt );
	//cs_fly_to_and_dock (ps_e10_m3_lich_move.pdock_hurt, ps_e10_m3_lich_move.phurt_face, 0.25);
	dprint("play sit lich pup");

	l_lich_sit_pup = pup_play_show( pup_lich_sit_pup );
	cs_vehicle_speed (0.5);
	
	
	//ai_braindead( ai_current_actor, TRUE );
	sleep_forever();

end

script static void e10_m3_lich_blip()
	sleep_s(3);
	spops_blip_ai( sq_e10_m3_cov_lich, TRUE, "enemy_vehicle" );
	thread( f_e10_m3_stinger_lich() );
	sleep_until(b_e10_m3_lich_attacking);
		spops_blip_ai( sq_e10_m3_cov_lich, FALSE );
end

script static void e10_m3_load_lich_gunners()
	ai_place(sg_e10_m3_lich_gunners);
  sleep(5);
  //ai_vehicle_enter_immediate (sg_e10_m3_lich_gunners.gunner_1, (object_get_turret (lichy, 0))); //top right
 	ai_vehicle_enter_immediate (sg_e10_m3_lich_gunners.gunner_1, (object_get_turret (lichy, 1)));   // bottom right
 	sleep(5);
  ai_vehicle_enter_immediate (sg_e10_m3_lich_gunners.gunner_2, (object_get_turret (lichy, 2)));   // top left
  //ai_vehicle_enter_immediate (sg_e10_m3_lich_gunners.gunner_2, (object_get_turret (lichy, 3)));   // bottom left  
end

//f_blip_object(object_get_turret (lichy, 3), "default");

script static void e10_m3_lich_power_core()
	e10_m3_attach_core();
	dprint("===core attached===");
	//spops_blip_object (object_at_marker (lichy, "power_core"), TRUE, "neutralize_health");
	//f_blip_object (cr_e10_m3_lich_power_core, "recover");
	//spops_blip_object( dc_e10_m3_lich_powercore, TRUE, "recover" );
	sleep_until ( device_get_position( dc_e10_m3_lich_powercore ) > 0 and g_ics_player != NONE, 1);  //and g_ics_player != NONE;
		object_destroy(cr_e10_m3_lich_power_core);
		object_create( e10m3_nuke );
		sleep(1);
		dprint("action for pup");
		local long show = pup_play_show(pup_pull_core);
			dprint("start pull pup");
		object_can_take_damage (  lichy );
		//localized shake
		device_set_power( dc_e10_m3_lich_powercore, 0 );
		sleep(1);
	sleep_until ( not pup_is_playing( show ), 1 );		
		//spops_unblip_object(object_at_marker (lichy, "power_core"));
		//object_can_take_damage (object_at_marker( lichy, "power_core_shield" ));
		object_enable_damage_section ( lichy , "power_core_shield", 100 );
		damage_object (lichy, power_core_shield, 1000); 
		spops_unblip_object( dc_e10_m3_lich_powercore );//spops_unblip_object(dc_e10_m3_lich_powercore);flg_e10_m3_lich_core_damage
		//spops_unblip_flag( flg_e10_m3_lich_core_damage );//spops_unblip_object(dc_e10_m3_lich_powercore);
		g_ics_player = NONE;
		//sleep_s(2);
		
		//object_can_take_damage ( object_at_marker( lichy, "power_core" ) );
		
		b_e10_m3_artifact_retrieved = TRUE;
	
		sleep(1);
		thread( e1_m3_lich_exit_blip() );
		damage_objects( object_at_marker (lichy, "power_core"), "body", 1000);
		damage_objects( object_at_marker (lichy, "power_core"), "default", 1000);
		sleep(15);
		damage_objects( cr_e10_m3_fake_core, "body", 1000);
		damage_objects( cr_e10_m3_fake_core, "default", 1000);
		object_set_health(cr_e10_m3_fake_core, 0 );
		thread(f_e10_m3_core_attach_setup());
		/////sleep_until( FALSE , 1 );
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) <= 0, 1);
		//sleep_s(5);
		if e10_m3_any_player_on_lich() then
			sleep_rand_s( 6,7 );
		else
			sleep_s(1);
		end
		pup_stop_show( l_lich_sit_pup );
		sleep(1);
		local long l_pup_die = pup_play_show (lich_dying_pup);
		sleep(15);
			
		//dprint("playing dying lich pup");
		sleep_until( not pup_is_playing ( l_pup_die ), 1 );
			b_e10_m3_lich_in_play = FALSE;
			sleep_s(0.25);
			e10_m3_lich_destruction();
			
end
///f_blip_object( dc_e10_m3_lich_powercore, "default" )
script static void e10_m3_attach_core()
	//object_create(cr_e10_m3_fake_core);
	//object_cannot_take_damage (  lichy );
	//object_cannot_take_damage (object_at_marker( lichy, "power_core_shield" )); 
	object_disable_damage_section ( lichy ,"power_core_shield" );
	object_create( dc_e10_m3_lich_powercore );
	object_create( cr_e10_m3_lich_power_core );
	object_create( e10m3_oct_nuke);
	sleep(2);
	device_set_power(dc_e10_m3_lich_powercore, 1);
	objects_attach( cr_e10_m3_lich_power_core, "m_center", dc_e10_m3_lich_powercore,"" );
	objects_attach(lichy, "pc_fx_1", e10m3_oct_nuke, "" );
	sleep(1);
	objects_attach(  e10m3_oct_nuke,"", cr_e10_m3_lich_power_core, "lich_power_core_mkr" );
end
//spops_blip_object( e10m3_oct_nuke, TRUE, "recover" );
//global damage DMG_explosion_small = 	objects\weapons\grenade\storm_frag_grenade\damage_effects\storm_frag_grenade_explosion.damage_effect;

//levels\dlc\ff154_hillside\effects\lich_invis_damage.damage_effect
script static void rar()
//
	//damage_new( DMG_explosion_small, flg_e10_m3_lich_core_damage );
	//damage_new( DMG_explosion_lich_core, meh_flg );
	damage_object (lichy, power_core_shield, 1000); 

end
//objects_attach( cr_e10_m3_lich_power_core, "m_center", e10m3_nuke,"" );

script static void e10_m3_player_on_the_lich_setup()

	if player_valid( player0 ) then
		thread(e10_m3_player_on_the_lich(player0));
	end
	
	if player_valid( player1 ) then	
		thread(e10_m3_player_on_the_lich(player1));
	end
	
	if player_valid( player2 ) then	
		thread(e10_m3_player_on_the_lich(player2));
	end
	
	if player_valid( player3 ) then	
		thread(e10_m3_player_on_the_lich(player3));
	end
end

script static void e10_m3_player_on_the_lich(player p_player)

	repeat
		sleep_until( volume_test_objects( kill_e10_m3_lich_wipe, p_player ), 1);			
			dprint("player on lich");
			if p_player == player0 and player_valid ( player0 ) then
				b_e10_m3_player0_on_lich = TRUE;
				dprint("player0 on lich");
			end
			
			if p_player == player1 and player_valid ( player1 ) then
				b_e10_m3_player1_on_lich = TRUE;
			end			

			if p_player == player2 and player_valid ( player2 ) then
				b_e10_m3_player2_on_lich = TRUE;
			end
			
			if p_player == player3 and player_valid ( player3 ) then
				b_e10_m3_player3_on_lich = TRUE;
			end	
								
		sleep_until( not volume_test_objects( kill_e10_m3_lich_wipe, p_player ), 1);
			dprint("player0 not on lich");
			if p_player == player0 then
				b_e10_m3_player0_on_lich = FALSE;
				dprint("player0 not on lich");
			end
			
			if p_player == player1 then
				b_e10_m3_player1_on_lich = FALSE;
			end			

			if p_player == player2  then
				b_e10_m3_player2_on_lich = FALSE;
			end
			
			if p_player == player3  then
				b_e10_m3_player3_on_lich = FALSE;
			end	
	until( s_objcon_e10_m3 >= 65, 1 );

end

script static boolean e10_m3_get_player_on_the_lich(player p_player)

		local boolean b_on = FALSE;		
			//dprint("player on lich");
			if p_player == player0 and player_valid ( player0 ) then
				b_on = b_e10_m3_player0_on_lich;
			end
			
			if p_player == player1 and player_valid ( player1 ) then
				b_on = b_e10_m3_player1_on_lich;
			end			

			if p_player == player2 and player_valid ( player2 ) then
				b_on = b_e10_m3_player2_on_lich;
			end
			
			if p_player == player3 and player_valid ( player3 ) then
				b_on = b_e10_m3_player3_on_lich;
			end	
			b_on;	
end			

script static boolean e10_m3_any_player_on_lich()
	local boolean b_on = FALSE;
	if b_e10_m3_player0_on_lich or b_e10_m3_player1_on_lich or b_e10_m3_player2_on_lich or b_e10_m3_player3_on_lich then
		b_on = TRUE;
	end
	b_on;
end
//volume_test_objects( tv_comp_enter_core, player0 )
script static void e1_m3_lich_exit_blip()
	spops_blip_flag( flg_e10_m3_lich_exit , TRUE, "default"  );
	thread (camera_shake_all_coop_players_10_3( .1, .7, 1, 0.1, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound'));
	thread( vo_e10m3_core_taken() );
	sleep_s(3);
	f_new_objective( "e10_m3_exit_lich" );
	sleep_until( not e10_m3_any_player_on_lich() or s_objcon_e10_m3 >= 65, 1 );
		sleep_s(5);
		thread( f_e10_m3_event7_stop() );

		spops_unblip_flag( flg_e10_m3_lich_exit );
		f_new_objective( "e10_m3_escape" );
end

script static void e10_m3_lich_destruction()
	//cs_vehicle_speed ( lichy, 0.5);
	//sleep_rand_s( 4,6 );
	kill_volume_enable( kill_e10_m3_lich_wipe);
	
	//#//ai_place( sq_e10_me_cov_phantom_blow );
	//
	object_create(lich_octopus);
	sleep(1);
	//cs_fly_to_and_face( sq_e10_m3_cov_lich.pilot, true, ps_e10_m3_lich_move.pdeath ,ps_e10_m3_lich_move.pdeath_face );
	objects_attach (lichy, "", lich_octopus, "");
	objects_detach (lichy, lich_octopus);	
	sleep(30);
	kill_volume_disable( kill_e10_m3_lich_wipe  );
	local long l_pup_crash = 	pup_play_show ( lich_crash_pup );
	//b_e10_m3_artifact_retrieved = TRUE;
	sleep_until( not pup_is_playing ( l_pup_crash ), 1 );
		
		kill_volume_disable( kill_e10_m3_lich_wipe  );
		sleep_s(6);

		b_e10_m3_lich_dead = TRUE;
end

script static void e10_m3_lich_ranger_spawner()
	sleep_until(ai_living_count( sg_e10_m3_lich_encounter ) - e10_m3_lich_gunner_count() <= 6 and  ( ai_living_count( sq_e10_m3_ark_ghost_elite_3 ) + ai_living_count( sq_e10_m3_ark_ghost_elite_2 ) ) <= 3, 1);
		garbage_collect_now();
		sleep_s(2);
		ai_place(sq_e10_m3_ark_rang_elites_1, 1);
		sleep_s(1.5);
		ai_place(sq_e10_m3_ark_rang_elites_2, 2);
		sleep_s(5);
	//sleep_until(ai_living_count( sg_e10_m3_lich_encounter ) - e10_m3_lich_gunner_count() <= 5 , 1);sg_e10_m3_all_enemies
	sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 9 and  ( ai_living_count( sq_e10_m3_ark_ghost_elite_3 ) + ai_living_count( sq_e10_m3_ark_ghost_elite_2 ) ) <= 1, 1);
		garbage_collect_now();
		thread( e10_m3_lich_chute_batch_1_a() );

	sleep_s(6);
	sleep_until(ai_living_count( sg_e10_m3_all_enemies ) - e10_m3_lich_gunner_count() <= 6  and b_e10_m3_chute_1_a_done, 1);
		
		inspect(ai_living_count( sg_e10_m3_all_enemies ) - e10_m3_lich_gunner_count());
		//dprint("spawing xtra rangers");
		ai_place(sq_e10_m3_ark_rang_elites_3, 2);
		sleep_s(3);
	sleep_until(ai_living_count( sg_e10_m3_all_enemies ) - e10_m3_lich_gunner_count() <= 5 , 1);
		ai_place(sq_e10_m3_ark_rang_elites_4);
		sleep_s(2);
		thread( e10_m3_lich_chute_batch_1_b() );
		sleep_s(7);

		thread( e10_m3_lich_chute_batch_2() );
end

script static void e10_m3_lich_battle_spawn()
	sleep_until( b_e10_m3_lich_wounded , 1 );
		//dprint("spawning lich crew");
		ai_place(sg_e10_m3_ark_lich_battle);
end

global boolean b_e10_m3_lich_ghost_drop_done = FALSE;

script static void e10_m3_lich_chute_batch_2()
	sleep_until(e10_m3_non_lich_enemy_count() <= 6 and b_e10_m3_lich_position_b_rdy, 1);
		ai_place(sq_e10_m3_ark_rang_elites_5, 2);
		ai_place(sq_e10_m3_ark_rang_elites_6, 2);
		sleep_s(6);
	sleep_until(e10_m3_non_lich_enemy_count() <= 8, 1);
		e10_m3_open_chute_down( true );
		sleep_s(2);	
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_scrubs.a4, 1, 1.5, 10, true );
	  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a3, 1, 1.5, 10, true );
	  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_scrubs.a4, 1, 1.5, 10, true );
	  lichy->grav_lift_drop_unit( sq_e10_m3_ark_general_1.1, 1, 1.5, 10, true );
	  //lichy->grav_lift_drop_unit( sq_e10_m3_ark_general_1.2, 1, 1.5, 10, true );
	  sleep_s( 2 );
	  e10_m3_open_chute_down( false); 
		sleep_s( 3 );  
		
	sleep_until(e10_m3_non_lich_enemy_count() <= 8 , 1);		
		ai_place(sq_e10_m3_ark_rang_elites_5, 1);
		ai_place(sq_e10_m3_ark_rang_elites_6, 2);
		sleep_s(4);
	sleep_until(e10_m3_non_lich_enemy_count() <= 8 , 1);
		ai_place(sq_e10_me_cov_phant_lich_drop);
		e10_m3_open_chute_down( true );
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_1.billy, 1, 5, 10, true );
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_1.pilgrim, 1, 2, 10, true );
		e10_m3_open_chute_down( false);
		b_e10_m3_lich_position_c = TRUE;  	
		sleep_s( 6 );
		
	sleep_until( ai_living_count( sq_e10_m3_ark_hunters_1 ) <= 1 and e10_m3_non_lich_enemy_count() <= 5 and b_e10_m3_lich_ghost_drop_done and b_e10_m3_lich_position_c_rdy, 1);
		
		if game_coop_player_count() < 4 then
			ai_place(sq_e10_m3_ark_rang_elites_1, 1);
			ai_place(sq_e10_m3_ark_rang_elites_2, 1);
		else
			//sleep_until( e10_m3_non_lich_enemy_count()  <= 4 , 1 );
				ai_place(sq_e10_m3_ark_rang_elites_1, 2);
				sleep_s(1.5);
				ai_place(sq_e10_m3_ark_rang_elites_2, 2);
		end
		sleep_s(5);
	sleep_until( e10_m3_non_lich_enemy_count() <= 9 , 1 );
		e10_m3_open_chute_down( true );
	//sleep_until( ai_living_count( sq_e10_m3_ark_general_1 ) <= 3 );
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_2.kilgore, 1, 5, 10, true );
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_2.trout, 1, 2, 10, true );
		
		if game_coop_player_count() == 4 then
			lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a4, 4, 1.5, 10, true );
			lichy->grav_lift_drop_unit( sq_e10_m3_ark_general_1.2, 1, 1.5, 10, true );
		end
		
		e10_m3_open_chute_down( false); 


	sleep_until( e10_m3_non_lich_enemy_count()  <= 3 );
		vo_glo15_miller_few_more_01();
		f_blip_ai_cui(sq_e10_m3_ark_hunters_1, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_hunters_2, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_grunt_rockets, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_rang_elites_1, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_rang_elites_2, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_rang_elites_3, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_rang_elites_4, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_rang_elites_5, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_rang_elites_6, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_general_1, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_general_2, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_ghost_elite, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_ghost_elite_2, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_ghost_elite_3, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_grunt_scrubs, "navpoint_enemy");
		f_blip_ai_cui(sq_e10_m3_ark_grunt_mixed, "navpoint_enemy");
		
	sleep_until( e10_m3_non_lich_enemy_count()  <= 1 );
		b_e10_m3_move_lich_down = TRUE;
end

global boolean b_e10_m3_chute_1_a_done = FALSE;

script static void e10_m3_lich_chute_batch_1_a()
	e10_m3_open_chute_down( true );
	sleep_s(1);	
	lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_mixed.a1, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_mixed.a3, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_mixed.a3, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_mixed.a4, 1, 1, 10, true );
	e10_m3_open_chute_down( false);  	
	b_e10_m3_chute_1_a_done = TRUE;
end

script static void e10_m3_lich_chute_batch_1_b()
	e10_m3_open_chute_down( true );
	sleep_s(1);	
	lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_scrubs.a1, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a1, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_scrubs.a2, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a2, 1, 1, 10, true );
	e10_m3_open_chute_down( false);  	
	dprint("Go to Position B");
	b_e10_m3_lich_position_b = TRUE;
end


script static boolean e10_m3_lich_ranger_clear()

	not volume_test_objects(kill_e10_m3_lich_wipe,( ai_actors(sg_e10_m3_ark_rangers) )  );

end

////////////////////////////////////////////////////
//	HILLSIDE DOWN
////////////////////////////////////////////////////

script static void debug_hs_down_e10_m3()
	ai_erase(sg_e10_m3_all_enemies);
	sleep(5);
	//s_objcon_e10_m3 = 68;
	ai_erase(sg_e10_m3_all_enemies);
	wake( e10_m3_hillside_down_init );
	
	b_e10_m3_lich_dead = TRUE;
	b_e10_m3_artifact_retrieved = TRUE;
	switch_zone_set("e10_m3_hills_down");

	thread( e10_m3_open_start_door() );
	thread( e10_m3_open_big_door() );
end

script dormant e10_m3_hillside_down_init()

	//sleep_until( b_e10_m3_lich_dead ,1 );
	sleep_until( current_zone_set_fully_active() == 4, 1 );
		dprint("==== HILLSIDE DOWN INIT ====");
		s_objcon_e10_m3 = 60;
		wake( f_e10_m3_objcon_controller_down );
		thread( e10_m3_door_switch() );
		thread(e10_m3_hillside_down_objectives() );
	//	thread( start_camera_shake_loop( "medium", "medium", coldant_camera_shake_medium_medium));
		thread( e10_m3_down_early_spawns() );
		thread( e10_m3_down_spawns());
		
		//sq_e10_m3_spartan_1
		sleep_s(1);
		ai_set_objective(sq_e10_m3_spartan_1, e10_m3_unsc_veh_obj_dwn);
		ai_set_objective(sq_e10_m3_spartan_2, e10_m3_unsc_veh_obj_dwn);
end



script static void e10_m3_hillside_down_objectives()
		//ai_place( sq_e10_m3_hunters );
		thread( f_e10_m3_event8_start() );
		spops_blip_flag(flg_e10_m3_basin_enter, TRUE, "default" );
	sleep_until(s_objcon_e10_m3 >= 65 or objects_distance_to_flag(Players(),flg_e10_m3_basin_enter) <= 11, 1);	
		spops_unblip_flag( flg_e10_m3_basin_enter );	
		spops_blip_flag(flg_e10_m3_hillside_door, TRUE, "default" );
	sleep_until(s_objcon_e10_m3 >= 70 or objects_distance_to_flag(Players(),flg_e10_m3_hillside_door) <= 11, 1);
		
		spops_unblip_flag( flg_e10_m3_hillside_door );
		spops_blip_flag(flg_e10_m3_hillside_mid, TRUE, "default" );

	sleep_until( s_objcon_e10_m3 >= 80 or  objects_distance_to_flag(Players(),flg_e10_m3_hillside_mid) <= 10 ,1 ); 
		
		spops_unblip_flag( flg_e10_m3_hillside_mid );
		spops_blip_flag(flg_e10_m3_hillside_step_1, TRUE, "default" );
	sleep_until( s_objcon_e10_m3 >= 90 or objects_distance_to_flag(Players(),flg_e10_m3_hillside_step_1) <= 10,1 ); 

		spops_unblip_flag( flg_e10_m3_hillside_step_1 );
		spops_blip_flag(flg_e10_m3_hillside_startend, TRUE, "default" );

	sleep_until( s_objcon_e10_m3 >= 110 or objects_distance_to_flag(Players(),flg_e10_m3_hillside_startend) <= 10 ,1 );
		spops_unblip_flag( flg_e10_m3_hillside_startend );
		//thread( e10_m3_exit_win() );
	//sleep_until( ai_living_count(sg_e10_m3_hillside_down) <= 2 ,1 ); //
		e10m3_narr_clear_wait();
			vo_e10m3_cavern_door();
			spops_blip_flag(flg_e10_m3_cavern_exit, TRUE, "default" );
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_cavern_exit) <= 10 ,1 ); 
			e10m3_narr_clear_wait();
			vo_e10m3_game_out();	
		
		spops_unblip_flag( flg_e10_m3_cavern_exit );
		//#e10_m3_activate_button_sequence( dc_e10_m3_exit_door );
		e10_m3_activate_button_sequence_forerunner( dc_e10_m3_exit_door, dm_e10_m3_exit_door, FALSE, flg_e10_m3_exit_button );
		//sleep_until( not e10m3_narrative_is_on, 1);
		thread( f_e10_m3_event8_stop() );		
		thread( f_e10_m3_music_stop() );	
				//	sleep(1);
	//	sleep_until( not e10m3_narrative_is_on, 1);				
			f_e10_m3_win();
end



script static void e10_m3_down_early_spawns()

	ai_place( sq_e10_m3_cov_phantom_chase_1 );
	sleep(3);
	ai_place( sq_e10_m3_cov_phantom_chase_2 );	
	sleep(5);
	ai_place( sq_e10_m3_cov_phantom_chase_3 );

	sleep(1);
	//thread( e10_m3_phantom_twitch() );
	
	thread( e10_m3_door_droppod());
	sleep_s(2);
	thread( e10_m3_mid_droppod());
	
end

script static void e10_m3_down_spawns()
	
	ai_place( sq_e10_m3_turrets_1 );
	sleep(20);
	//ai_place( sq_e10_m3_turrets_2 );
	//sleep(20);
	//ai_place( sq_e10_m3_turrets_3 );
	
	//ai_place_in_limbo( sq_e10_m3_for_commander_1 );
	//ai_place_in_limbo( sq_e10_m3_for_commander_2 );
	sleep_until( s_objcon_e10_m3  >= 90 );
		//ai_place_in_limbo( sq_e10_m3_for_knights );

		
end


script static void e10_m3_door_droppod()
		ai_place (sq_e10_3_hs_grunts_1);
		//thread (f_dlc_load_drop_pod (dm_e10_m3_hillside_door, sq_e10_3_hs_grunts_1, NONE,obj_drop_pod_4));
		sleep_s(1);
		ai_set_objective(sq_e10_3_hs_grunts_1, e10_m3_enemy_hillside_obj);

end

script static void e10_m3_mid_droppod()
		//ai_place_in_limbo (sq_e10_3_hs_grunts_2);
		//sq_e10_3_hs_grunts_3
		ai_place( sq_e10_3_hs_grunts_3, 2);
		//thread (f_dlc_load_drop_pod (dm_e10_m3_hillside_mid, sq_e10_3_hs_grunts_2, NONE, obj_drop_pod_5));
		sleep_s(1);
		ai_set_objective(sq_e10_3_hs_grunts_2, e10_m3_enemy_hillside_obj);

end





global boolean b_e10_m3_forerunner_zone_loaded = FALSE;
//
/////////////////////////////////////////
//	DESIGNER ZONE SWITCH
/////////////////////////////////////////
script dormant e10_m3_streaming()


	sleep_until( b_e10_m3_fore_struct_open ,1);//and not b_e10_m3_door_open
		//e10_m3_close_big_door();
		sleep(1);
		//dprint("switch zone set:: e10_m3_bowl_fore ") ;
	//sleep_until( not b_e10_m3_door_open, 1, 30*6 );
		//sleep(1);
		//volume_teleport_players_not_inside_with_vehicles(  tv_e10_m3_teleport_basin,  flg_e10_m3_teleport_in );
		//sleep(15);
		switch_zone_set("e10_m3_bowl_fore");
		sleep(1);
		object_destroy_folder( crs_e10_m3_hillside_pelicans );
		b_e10_m3_forerunner_zone_loaded = TRUE;
	sleep_until(b_e10_m3_lich_beacon ,1);
		prepare_to_switch_to_zone_set( "e10_m3_bowl" );
		sleep_s(2);
			dprint("+++waiting for prepare zone set+++");
	sleep_until( not PreparingToSwitchZoneSet(), 1 );
			dprint("+++finished prepare zone set+++");
		spops_blip_flag( flg_e10_m3_structure_2, TRUE, "default" );
		sleep_s(2);
		//dprint("switch zone set:: e10_m3_bowl ") ;
		//e10_m3_close_big_door();
		sleep(1);
		switch_zone_set("e10_m3_bowl");

		sleep(3);
	sleep_until( objects_distance_to_flag( Players(),flg_e10_m3_structure_2) <= 30 , 1 );
		sleep_s(2); 
		spops_unblip_flag( flg_e10_m3_structure_2 );
		sleep_s(1);
		b_e10_m3_lich_ready = TRUE;

	sleep_until( b_e10_m3_lich_dead , 1 );
		prepare_to_switch_to_zone_set( "e10_m3_hills_down" );
		sleep_s(2);
			dprint("+++waiting for prepare zone set+++");
	sleep_until( not PreparingToSwitchZoneSet(), 1 );
			dprint("+++finished prepare zone set+++");
		//dprint("switch zone set:: e10_m3_hills_down ") ;
		switch_zone_set("e10_m3_hills_down");
		sleep(1);
		object_create_folder_anew( crs_e10_m3_hillside_pelicans );
		sleep_s(2);
		e10_m3_open_big_door();

end

script static void e10_m3_hillside_pelicans_smoke()
	effect_new(levels\dlc\ff154_hillside\fx\smoke\smoke_column.effect, fx_e10m3_p_1_a);
	effect_new(levels\dlc\ff154_hillside\fx\smoke\smoke_column_sml.effect,fx_e10m3_p_1_b );
	effect_new(levels\dlc\ff154_hillside\fx\smoke\smoke_column_sml.effect,fx_e10m3_p_1_c );
	
	effect_new(levels\dlc\ff154_hillside\fx\smoke\smoke_column.effect, fx_e10m3_p_2_a);
	effect_new(levels\dlc\ff154_hillside\fx\smoke\smoke_column_sml.effect, fx_e10m3_p_2_b);
	
	effect_new(levels\dlc\ff154_hillside\fx\smoke\smoke_column.effect, fx_e10m3_p_3_a);
	effect_new(levels\dlc\ff154_hillside\fx\smoke\smoke_column_sml.effect,fx_e10m3_p_3_b );
	

end


script static void e10_m3_prepare_zoneset_fore()
	//dprint("prep zone switch");
	prepare_to_switch_to_zone_set( "e10_m3_bowl" );
end

//prepare_to_switch_to_zone_set( l_zoneset_id );

////////////////////////////////////////////////////
//	command script
///////////////////////////////////////////////////



script command_script cs_e10_m3_lich_jumper()

	unit_falling_damage_disable ( ai_current_actor, true );

end

script command_script cs_e10_m3_lich_grunt_jumper()

	//unit_falling_damage_disable ( ai_current_actor, true );
	//cs_go_to(ps_e10_m3_lich.p0, 0.2);
	//dprint("got to point");
	sleep(1);
end

script static void e10_m3_open_chute_down( boolean bopen)

	lichy->grav_lift_down_active( bopen );

end



script static void f_e10_m3_win()
	b_e10_m3_win = TRUE;
	b_end_player_goal = true;
	//device_set_position( dm_e10_m3_exit, 1 );
	//sleep(30);
	fade_out (0,0,0,60);
	//thread( vo_e10m3_game_out() );
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end


script command_script cs_knight_rider()
	//dprint("knight cs");
	cs_phase_in();
end



script command_script cs_e10_m3_intro_ghost1()
	//cs_abort_on_damage( TRUE );
	cs_face( TRUE,ps_e10_m3_hillside.p0 );
	//cs_abort_on_alert( TRUE );
	sleep_until( b_e10_m3_intro_ghost_flee or s_objcon_e10_m3 >= 50 or f_ai_is_aggressive( ai_current_actor ), 1 );
	
		//dprint("ghost run1");
	//sleep_rand_s(0.25, 1 );
	cs_vehicle_boost( TRUE );
	cs_vehicle_speed( 1 );
	cs_go_by(ps_e10_m3_hillside.p0, ps_e10_m3_hillside.p1);
	cs_face( FALSE,ps_e10_m3_hillside.p0 );
	cs_go_by(ps_e10_m3_hillside.p1, ps_e10_m3_hillside.p3);
	cs_go_by(ps_e10_m3_hillside.p2, ps_e10_m3_hillside.p2);
	cs_go_by(ps_e10_m3_hillside.p3,ps_e10_m3_hillside.p7);
	ai_set_objective(ai_current_actor, e10_m3_enemy_veh_obj );
end

script command_script cs_e10_m3_intro_ghost2()
	//cs_abort_on_damage( TRUE );
	cs_face(TRUE, ps_e10_m3_hillside.p4 );
	sleep_until( b_e10_m3_intro_ghost_flee or s_objcon_e10_m3 >= 50 or f_ai_is_aggressive( ai_current_actor ), 1 );
	
	//sleep_rand_s(0.25, 1 );	
	//dprint("ghost run2");
	cs_vehicle_boost( TRUE );
	cs_vehicle_speed( 1 );
	cs_go_by(ps_e10_m3_hillside.p4, ps_e10_m3_hillside.p5);
	cs_face( FALSE, ps_e10_m3_hillside.p4 );
	cs_go_by(ps_e10_m3_hillside.p5, ps_e10_m3_hillside.p6);
	cs_go_by(ps_e10_m3_hillside.p6, ps_e10_m3_hillside.p7);
	ai_set_objective(ai_current_actor, e10_m3_enemy_veh_obj );
end



script static short e10_m3_non_lich_enemy_count()
	ai_living_count( sg_e10_m3_all_enemies ) - e10_m3_lich_gunner_count();
end

script static short e10_m3_non_lich_encounter_enemy_count()
	ai_living_count( sg_e10_m3_lich_encounter ) - e10_m3_lich_gunner_count();
end

script static void e10_m3_enemy_count()

	inspect( ai_living_count( sg_e10_m3_all_enemies ) );
end

script static short e10_m3_lich_gunner_count()

	ai_living_count( sg_e10_m3_lich_gunners );
end

global  object dead_grunt = NONE;

script command_script cs_kill_me()
	dead_grunt = ai_get_object(ai_current_actor );
	
	thread(e10_m3_watch_grunt_death());
	//inspect( unit_get_health( unit( dead_grunt ) ) );
	sleep(1);
	ai_kill_silent(ai_current_actor);	
	sleep(15);
	
end

script static void e10_m3_watch_grunt_death()
	
	sleep_until( unit_get_health( unit( dead_grunt ) ) <= 0 ,1 );
		object_set_persistent( dead_grunt, TRUE); 
			//dprint("dead");
end

script command_script cs_tea_time()
		cs_abort_on_damage(TRUE);
		repeat
			if b_e10_m3_earl_grey then
				cs_crouch ( TRUE );
				sleep_rand_s(0.5,0.75);
				cs_crouch ( FALSE );
				sleep_rand_s(0.5,1.25);
			end
		until ( s_objcon_e10_m3 > 0, 1 );
		cs_crouch ( FALSE );
end

script command_script cs_tea_time_watch()
		cs_abort_on_damage(TRUE);
		cs_aim_object(TRUE, ai_get_object( sg_e10_m3_dead_grunt));
		sleep_until ( s_objcon_e10_m3 > 0, 1 );

		sleep(3);
		//
		cs_aim(TRUE,  ps_e10_m3_hillside.p9);
		//cs_go_to_vehicle(veh_e10_m3_wardog_06);
		//cs_aim_object(TRUE, veh_e10_m3_wardog_01);
		cs_go_to(ps_e10_m3_hillside.p8);
		//cs_go_to_vehicle(veh_e10_m3_wardog_01);
		cs_face_object (TRUE , veh_e10_m3_wardog_01 );
		vehicle_flip(veh_e10_m3_wardog_01);
		//cs_face_object (FALSE , veh_e10_m3_wardog_01 );
end
/////////////////////////////////////////
//  OBJCON
/////////////////////////////////////////

script dormant f_e10_m3_objcon_controller()
	dprint("============= HILLSIDE CONTROLLER ======================");
	thread(f_e10_m3_objcon_10());
	thread(f_e10_m3_objcon_15());
	thread(f_e10_m3_objcon_20());
	thread(f_e10_m3_objcon_25());
	thread(f_e10_m3_objcon_30());
	thread(f_e10_m3_objcon_35());
	thread(f_e10_m3_objcon_37());
	
	thread(f_e10_m3_objcon_40());
	thread(f_e10_m3_objcon_45());
	thread(f_e10_m3_objcon_47());
	thread(f_e10_m3_objcon_50());
	thread(f_e10_m3_objcon_53());
	thread(f_e10_m3_objcon_54());
	thread(f_e10_m3_objcon_55());
	thread(f_e10_m3_objcon_58());
end


script dormant f_e10_m3_objcon_controller_down()

	thread(f_e10_m3_objcon_60());
	thread(f_e10_m3_objcon_65());
	thread(f_e10_m3_objcon_67());
	thread(f_e10_m3_objcon_70());
	thread(f_e10_m3_objcon_80());
	thread(f_e10_m3_objcon_90());
	thread(f_e10_m3_objcon_100());
	thread(f_e10_m3_objcon_110());

end

script static void f_e10_m3_objcon_10()


	sleep_until (volume_test_players (tv_e10_m3_objcon_10) or s_objcon_e10_m3 >= 10, 1);
		if s_objcon_e10_m3 <= 10 then
			s_objcon_e10_m3 = 10;
			dprint("s_objcon_e10_m3 = 10 ");
		end
end
script static void f_e10_m3_objcon_15()


	sleep_until (volume_test_players (tv_e10_m3_objcon_15) or s_objcon_e10_m3 >= 15, 1);
		if s_objcon_e10_m3 <= 15 then
			s_objcon_e10_m3 = 15;
			dprint("s_objcon_e10_m3 = 15 ");
		end
		f_create_new_spawn_folder (94);
end


script static void f_e10_m3_objcon_20()


	sleep_until (volume_test_players (tv_e10_m3_objcon_20) or s_objcon_e10_m3 >= 20, 1);
		if s_objcon_e10_m3 <= 20 then
			s_objcon_e10_m3 = 20;
			dprint("s_objcon_e10_m3 = 20 ");
		end

		f_create_new_spawn_folder (92);
		sleep_rand_s( 1,4 );
		thread (camera_shake_all_coop_players_10_3( .1, .7, 1, 0.1, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound'));
		sleep_s(1);
		e10m3_narr_clear_wait();
		vo_e10m3_sky_is_falling_01();
end


script static void f_e10_m3_objcon_25()


	sleep_until (volume_test_players (tv_e10_m3_objcon_25) or s_objcon_e10_m3 >= 25, 1);
		if s_objcon_e10_m3 <= 25 then
			s_objcon_e10_m3 = 25;
			dprint("s_objcon_e10_m3 = 25 ");
		end

end

script static void  f_e10_m3_objcon_30()


	sleep_until (volume_test_players (tv_e10_m3_objcon_30) or s_objcon_e10_m3 >= 30, 1);
		if s_objcon_e10_m3 <= 30 then
			s_objcon_e10_m3 = 30;
			dprint("s_objcon_e10_m3 = 30 ");
		end
		f_create_new_spawn_folder (93);
		thread( e10_m3_perf_saver() );
end

script static void  f_e10_m3_objcon_35()


	sleep_until (volume_test_players (tv_e10_m3_objcon_35) or s_objcon_e10_m3 >= 35, 1);
		if s_objcon_e10_m3 <= 35 then
			s_objcon_e10_m3 = 35;
			dprint("s_objcon_e10_m3 = 35 ");
		end
		
end

script static void  f_e10_m3_objcon_37()


	sleep_until (s_objcon_e10_m3 >= 37 or b_e10_m3_door_open , 1);
		if s_objcon_e10_m3 <= 37 then
			s_objcon_e10_m3 = 37;
			dprint("s_objcon_e10_m3 = 37 ");
		end
		//ai_set_objective(sg_e10_m3_unsc, e10_m3_unsc_veh_bowl_obj);
		
		ai_set_objective(sq_e10_m3_spartan_1, e10_m3_unsc_veh_bowl_obj);
		ai_set_objective(sq_e10_m3_spartan_2, e10_m3_unsc_veh_bowl_obj);
end

script static void  f_e10_m3_objcon_40()


	sleep_until (volume_test_players (tv_e10_m3_objcon_40) or s_objcon_e10_m3 >= 40 , 1);
		if s_objcon_e10_m3 <= 40 then
			s_objcon_e10_m3 = 40;
			dprint("s_objcon_e10_m3 = 40 ");
		end
end

script static void  f_e10_m3_objcon_45()

	//fighting ghosts and clearing generators
	sleep_until (volume_test_players (tv_e10_m3_objcon_45) or s_objcon_e10_m3 >= 45, 1);
		if s_objcon_e10_m3 <= 45 then
			s_objcon_e10_m3 = 45;
			dprint("s_objcon_e10_m3 = 45 ");
		end
end

script static void  f_e10_m3_objcon_47()

	//fighting ghosts and clearing generators
	sleep_until (volume_test_players (tv_e10_m3_objcon_65) or s_objcon_e10_m3 >= 47, 1);
		if s_objcon_e10_m3 <= 47 then
			s_objcon_e10_m3 = 47;
			dprint("s_objcon_e10_m3 = 47 ");
		end
end
//

script static void  f_e10_m3_objcon_50()

	//structure opened , incoming phantom drops
	sleep_until ( s_objcon_e10_m3 >= 50 or b_e10_m3_fore_struct_open, 1);
		if s_objcon_e10_m3 <= 50 then
			s_objcon_e10_m3 = 50;
			dprint("s_objcon_e10_m3 = 50 ");
		end
end




script static void  f_e10_m3_objcon_53()

	//fighting forerunners , interior
	sleep_until ( volume_test_players (tv_e10_m3_objcon_53) , 1);
		if s_objcon_e10_m3 <= 53 then
			s_objcon_e10_m3 = 53;
			dprint("s_objcon_e10_m3 = 53 ");
		end
end

script static void  f_e10_m3_objcon_54()

	//fighting forerunners , interior
	sleep_until ( volume_test_players (tv_e10_m3_objcon_54) , 1);
		if s_objcon_e10_m3 <= 54 then
			s_objcon_e10_m3 = 54;
			dprint("s_objcon_e10_m3 = 54 ");
		end
end

script static void  f_e10_m3_objcon_55()

	//got see the lich come in
	sleep_until ( s_objcon_e10_m3 >= 55 or b_e10_m3_lich_beacon, 1);
		if s_objcon_e10_m3 <= 55 then
			s_objcon_e10_m3 = 55;
			dprint("s_objcon_e10_m3 = 55 ");
		end
end

script static void  f_e10_m3_objcon_56()

	//lich drop
	sleep_until ( s_objcon_e10_m3 >= 56 or b_e10_m3_lich_in_play, 1);
		if s_objcon_e10_m3 <= 56 then
			s_objcon_e10_m3 = 56;
			dprint("s_objcon_e10_m3 = 56 ");
		end
end

script static void  f_e10_m3_objcon_58()

	//lich wounded
	sleep_until ( s_objcon_e10_m3 >= 58 or b_e10_m3_lich_wounded, 1);
		if s_objcon_e10_m3 <= 58 then
			s_objcon_e10_m3 = 58;
			dprint("s_objcon_e10_m3 = 58 ");
		end
end

///////////////////////////////////////////////
//  Hillside Down ObjCon
//////////////////////////////////////////////



script static void f_e10_m3_objcon_60()

	sleep_until ( s_objcon_e10_m3 >= 60, 1);//b_e10_m3_artifact_retrieved or 
		if s_objcon_e10_m3 <= 60 then
			s_objcon_e10_m3 = 60;
			dprint("s_objcon_e10_m3 = 60 ");
		end
end

script static void f_e10_m3_objcon_65()

	sleep_until (volume_test_players (tv_e10_m3_objcon_65) or s_objcon_e10_m3 >= 65, 1);
		if s_objcon_e10_m3 <= 65 then
			s_objcon_e10_m3 = 65;
			dprint("s_objcon_e10_m3 = 65 ");
		end
end

script static void f_e10_m3_objcon_67()

	sleep_until (volume_test_players (tv_e10_m3_objcon_45) or s_objcon_e10_m3 >= 67, 1);
		if s_objcon_e10_m3 <= 67 then
			s_objcon_e10_m3 = 67;
			dprint("s_objcon_e10_m3 = 67 ");
		end
end

script static void f_e10_m3_objcon_70()

	sleep_until (volume_test_players (tv_e10_m3_objcon_70) or s_objcon_e10_m3 >= 70, 1);
		if s_objcon_e10_m3 <= 70 then
			s_objcon_e10_m3 = 70;
			dprint("s_objcon_e10_m3 = 70 ");
		end
		
		//location 2 forerunner gate
		f_create_new_spawn_folder (93);
		
		e10m3_narr_clear_wait();
				//thread( vo_e10m3_downhill_fight() );
		sleep_rand_s( 1,4 );
		thread (camera_shake_all_coop_players_10_3( .2, .7, 1, 0.1, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound'));				

end

script static void f_e10_m3_objcon_80()

	sleep_until (volume_test_players (tv_e10_m3_objcon_80) or s_objcon_e10_m3 >= 80, 1);
		if s_objcon_e10_m3 <= 80 then
			s_objcon_e10_m3 = 80;
			dprint("s_objcon_e10_m3 = 80 ");
		end
		f_ai_garbage_kill( sq_e10_m3_turrets_1, 5, 22.5, 30, -1, FALSE );
		ai_place( sq_e10_m3_turrets_2 );
		sleep(45);
		ai_place( sq_e10_3_hs_grunts_end );	
		//location 1 mid hill
		f_create_new_spawn_folder (92);
end


script static void  f_e10_m3_objcon_90()

	sleep_until (volume_test_players (tv_e10_m3_objcon_90) or s_objcon_e10_m3 >= 90, 1);
		if s_objcon_e10_m3 <= 90 then
			s_objcon_e10_m3 = 90;
			dprint("s_objcon_e10_m3 = 90 ");
		end
		//ai_place( sq_e10_m3_turrets_3 );
		sleep_rand_s( 0,2 );
		thread (camera_shake_all_coop_players_10_3( .2, .7, 1, 0.1,'sound\storm\multiplayer\pve\events\spops_rumble_high.sound'));
		sleep_s(1);
		e10m3_narr_clear_wait();
		vo_e10m3_sky_is_falling_02();		
end

script static void  f_e10_m3_objcon_100()


	sleep_until (volume_test_players (tv_e10_m3_objcon_15) or s_objcon_e10_m3 >= 100, 1);
		if s_objcon_e10_m3 <= 100 then
			s_objcon_e10_m3 = 100;
			dprint("s_objcon_e10_m3 = 100 ");
		end
		
		f_ai_garbage_kill( sq_e10_m3_turrets_2, 5, 22.5, 30, -1, FALSE );
		//location 3 goose crase
		f_create_new_spawn_folder (94);
end

script static void  f_e10_m3_objcon_110()

	sleep_until (volume_test_players (tv_e10_m3_objcon_110) or s_objcon_e10_m3 >= 110, 1);
		if s_objcon_e10_m3 <= 110 then
			s_objcon_e10_m3 = 110;
			dprint("s_objcon_e10_m3 = 110 ");
		end
		f_create_new_spawn_folder (98);
		//sleep_until( not e10m3_narrative_is_on, 1);
			//vo_e10m3_cavern_door();
		sleep_rand_s( 0,2 );
		thread (camera_shake_all_coop_players_10_3( .2, .7, 1, 0.1, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound'));
				
end

global boolean b_e10_m3_door_drop_1_done = false;
global boolean b_e10_m3_door_drop_2_done = false;

script command_script cs_e10_m3_phantom_door_1()


	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_1.driver), TRUE );
		f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_1.driver), "dual", sq_e10_3_hs_grunts_3_r, sq_e10_3_hs_grunts_5_r  , sq_e10_3_hs_elite_4_r, sq_e10_3_hs_elite_4_r);	

	cs_fly_by (ps_e10_m3_phantoms.p22);

	cs_fly_by (ps_e10_m3_phantoms.p14);
	thread( e10_m3_phantom_door_1_blip(ai_current_actor));
	//spops_blip_ai( ai_current_actor, TRUE, "enemy_vehicle" );
	ai_set_objective( sq_e10_3_hs_grunts_3_r, e10_m3_enemy_hillside_obj);
	ai_set_objective( sq_e10_3_hs_grunts_5_r, e10_m3_enemy_hillside_obj);
	ai_set_objective( sq_e10_3_hs_elite_2_r, e10_m3_enemy_hillside_obj);
	ai_set_objective( sq_e10_3_hs_elite_4_r, e10_m3_enemy_hillside_obj);
	//cs_fly_by (ps_e10_m3_phantoms.p10);	
	cs_vehicle_speed (0.75);
	cs_fly_by (ps_e10_m3_phantoms.p11);
	cs_fly_to_and_dock( ps_e10_m3_phantoms.p19, ps_e10_m3_phantoms.p21,3 );//p11
	cs_vehicle_speed (0.3);
	cs_fly_to_and_dock( ps_e10_m3_phantoms.p19, ps_e10_m3_phantoms.p20,0.25 );  //p12

	local long l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_1.driver), "dual"));	

	cs_vehicle_speed (0.5);
	spops_unblip_ai( ai_current_actor );
	sleep_until(not isthreadvalid(l_drop_1), 1);
	thread( e10_m3_perf_saver() );
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_1.driver), FALSE );
	b_e10_m3_door_drop_1_done = TRUE;
		//ai_set_objective( sq_e10_3_hs_grunts_1, e10_m3_theark_obj);
		//ai_set_objective( sq_e10_3_hs_grunts_2, e10_m3_theark_obj);
		cs_vehicle_speed (1.0);
		cs_fly_by (ps_e10_m3_phantoms.p13);
		//cs_vehicle_speed (1);

		//cs_fly_by (ps_e10_m3_phantoms.p8);

		cs_fly_by (ps_e10_m3_phantoms.p10);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 4 );
		cs_fly_by (ps_e10_m3_phantoms.p9);
		sleep_s(4);
	
		ai_erase (sq_e10_me_cov_phantom_door_1);

end

script command_script cs_e10_m3_phantom_door_2()


	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_2.driver), TRUE );
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_2.driver), "dual",  sq_e10_3_hs_elite_3_r, sq_e10_3_hs_elite_3_r,sq_e10_3_hs_grunts_4_r, sq_e10_3_hs_elite_2_r);	

	cs_fly_by (ps_e10_m3_phantoms.p22);

	cs_fly_by (ps_e10_m3_phantoms.p14);
	thread( e10_m3_phantom_door_2_blip(ai_current_actor));
	//spops_blip_ai( ai_current_actor, TRUE, "enemy_vehicle" );
	ai_set_objective( sq_e10_3_hs_grunts_4_r, e10_m3_enemy_hillside_obj);
	ai_set_objective( sq_e10_3_hs_elite_3_r, e10_m3_enemy_hillside_obj);
	ai_set_objective( sq_e10_3_hs_elite_2_r, e10_m3_enemy_hillside_obj);
	//cs_fly_by (ps_e10_m3_phantoms.p10);	
	cs_vehicle_speed (0.75);
	cs_fly_by (ps_e10_m3_phantoms.p11);

	
	cs_fly_to_and_dock( ps_e10_m3_phantoms.p19, ps_e10_m3_phantoms.p21,3 );//p11
	cs_vehicle_speed (0.3);
	cs_fly_to_and_dock( ps_e10_m3_phantoms.p19, ps_e10_m3_phantoms.p20,0.25 );  //p12	
	spops_unblip_ai( ai_current_actor );
	local long l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_2.driver), "dual"));	

	cs_vehicle_speed (0.5);
	sleep_until(not isthreadvalid(l_drop_1), 1);
		thread( e10_m3_perf_saver() );
		b_e10_m3_door_drop_2_done = TRUE;
		object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_door_2.driver), FALSE );
		cs_vehicle_speed (1.0);
		cs_fly_by (ps_e10_m3_phantoms.p13);
		//cs_vehicle_speed (1);s

		//cs_fly_by (ps_e10_m3_phantoms.p8);

		cs_fly_by (ps_e10_m3_phantoms.p10);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 4 );
		cs_fly_by (ps_e10_m3_phantoms.p9);
		sleep_s(4);
	
		ai_erase (sq_e10_me_cov_phantom_door_2);

end

script static void e10_m3_phantom_door_1_blip(ai a_actor)
	vo_glo15_dalton_phantom_02();
	spops_blip_ai( a_actor, TRUE, "enemy_vehicle" );
end

script static void e10_m3_phantom_door_2_blip(ai a_actor)
	vo_glo15_dalton_phantom_01();
	spops_blip_ai( a_actor, TRUE, "enemy_vehicle" );
end


script command_script cs_e10_m3_phant_structure()


	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);

	//f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_structure.driver), "right", sq_e10_3_hs_grunts_2, sq_e10_3_hs_grunts_1,NONE, NONE);	
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_structure.driver), "right", sq_e10_3_hs_grunts_2, sq_e10_3_hs_grunts_1,NONE, NONE);	
	//cs_fly_by (ps_e10_m3_phantoms.p0);

	cs_fly_by (ps_e10_m3_phantoms.p8);
	thread( e10_m3_phant_structure_blip( ai_current_actor ) );

	cs_vehicle_speed (0.5);
	cs_fly_by (ps_e10_m3_phantoms.p4);	
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e10_m3_phantoms.p3, ps_e10_m3_phantoms.p5,0.25 );
	spops_blip_ai( sq_e10_me_cov_phant_structure, FALSE );
	local long l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_structure.driver), "right"));	
	
	/*
	if any_players_in_vehicle() then
		ai_grunt_kamikaze(sq_e10_3_hs_grunts_1);
	
		ai_grunt_kamikaze(sq_e10_3_hs_grunts_2);
	end
	*/
	cs_vehicle_speed (0.5);
	sleep_until(not isthreadvalid(l_drop_1), 1);
		
		ai_set_objective( sq_e10_3_hs_grunts_1, e10_m3_theark_obj);
		ai_set_objective( sq_e10_3_hs_grunts_2, e10_m3_theark_obj);
		if any_players_in_vehicle() then
			ai_grunt_kamikaze(sq_e10_3_hs_grunts_1);
		
			ai_grunt_kamikaze(sq_e10_3_hs_grunts_2);
		end
		cs_vehicle_speed (0.75);
		cs_fly_by (ps_e10_m3_phantoms.p8);
		cs_vehicle_speed (1.0);
		cs_fly_by (ps_e10_m3_phantoms.p0);
		//cs_vehicle_speed (1);

		
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 3 );
		cs_fly_by (ps_e10_m3_phantoms.p7);
		sleep_s(3);
	
		ai_erase (sq_e10_me_cov_phant_structure);

end

script static void e10_m3_phant_structure_blip(ai a_actor)
	//e10m3_narr_clear_wait();
	//sleep_s(1);
		//vo_glo_phantom_04();
		spops_blip_ai( a_actor, TRUE, "enemy_vehicle" );
end

script command_script cs_e10_m3_phant_escort_1()
	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e10_m3_escorts.escort_1 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);

	
	if b_e10_m3_lich_ready then
		//dprint("lich escort 1");
		//cs_fly_by (ps_e10_m3_escorts.p0);	

		thread( e10_m3_phantom_load_playload_ghost(ai_vehicle_get( ai_current_actor ), sq_e10_m3_ark_ghost_elite_3.ghost_a, sq_e10_m3_ark_ghost_elite_3.ghost_b ) );

		sleep(1);

		cs_fly_by (ps_e10_m3_escorts.p21);
		cs_vehicle_speed (0.5);
		//ai_set_objective(sq_e10_3_hs_grunts_5_r, e10_m3_theark_obj );
		//ai_set_objective(sq_e10_m3_ark_rang_elites_1, e10_m3_theark_obj );
		cs_fly_to_and_dock( ps_e10_m3_escorts.p22, ps_e10_m3_escorts.p4,2 );
		//f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_escort_1.driver), "dual");	
		vehicle_unload( unit_get_vehicle( sq_e10_m3_ark_ghost_elite_3.ghost_a ), "phantom_sc01" );
		vehicle_unload( unit_get_vehicle( sq_e10_m3_ark_ghost_elite_3.ghost_b ), "phantom_sc02" );
		sleep_s(5);
		cs_vehicle_speed (1);
		cs_fly_by (ps_e10_m3_escorts.p24);
		cs_fly_by (ps_e10_m3_escorts.p20);
		
		cs_fly_by (ps_e10_m3_escorts.p5);
		cs_fly_by (ps_e10_m3_escorts.p11);
		cs_fly_by (ps_e10_m3_escorts.p9);

		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_escorts.p18);
		sleep_s(5);
	
		ai_erase (sq_e10_me_cov_phant_escort_1);

	else
		cs_fly_by (ps_e10_m3_escorts.p0);	
		cs_fly_by (ps_e10_m3_escorts.p1);
		cs_fly_by (ps_e10_m3_escorts.p2);
		cs_fly_by (ps_e10_m3_escorts.p3);
		cs_fly_by (ps_e10_m3_escorts.p4);
		cs_fly_by (ps_e10_m3_escorts.p5);


		cs_fly_by (ps_e10_m3_escorts.p6);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_escorts.p7);
		sleep_s(5);
	
		ai_erase (sq_e10_me_cov_phant_escort_1);
	end
	
	

end

script command_script cs_e10_m3_phant_escort_2()
	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e10_m3_escorts.escort_2 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);


	if b_e10_m3_lich_ready then
		//dprint("lich escort 2");

		sleep(1);

		thread( e10_m3_phantom_load_playload_ghost(ai_vehicle_get( ai_current_actor ), sq_e10_m3_ark_ghost_elite_2.ghost_a, sq_e10_m3_ark_ghost_elite_2.ghost_b ) );
		cs_fly_by (ps_e10_m3_escorts.p9);
		cs_vehicle_speed (0.5);
		//ai_set_objective(sq_e10_m3_ark_rang_elites_1, e10_m3_theark_obj );
		cs_fly_to_and_dock( ps_e10_m3_escorts.p23, ps_e10_m3_escorts.p5,2 );
		
		//f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_escort_2.driver), "dual");	
		vehicle_unload( unit_get_vehicle( sq_e10_m3_ark_ghost_elite_2.ghost_a ), "phantom_sc01" );
		vehicle_unload( unit_get_vehicle( sq_e10_m3_ark_ghost_elite_2.ghost_b ), "phantom_sc02" );
		sleep_rand_s(4,7);
		cs_vehicle_speed (1);
		cs_fly_by (ps_e10_m3_escorts.p12);
		cs_fly_by (ps_e10_m3_escorts.p3);
		cs_fly_by (ps_e10_m3_escorts.p16);
		//cs_fly_by (ps_e10_m3_escorts.p16);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_escorts.p19);
		sleep_s(5);	
		ai_erase (sq_e10_me_cov_phant_escort_2);
	else
		cs_fly_by (ps_e10_m3_escorts.p8);	
		cs_fly_by (ps_e10_m3_escorts.p9);
		cs_fly_by (ps_e10_m3_escorts.p10);
		cs_fly_by (ps_e10_m3_escorts.p11);
		cs_fly_by (ps_e10_m3_escorts.p12);
		cs_fly_by (ps_e10_m3_escorts.p13);
		cs_fly_by (ps_e10_m3_escorts.p14);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_escorts.p15);
		sleep_s(5);
	
		ai_erase (sq_e10_me_cov_phant_escort_2);
	end
	
	

end


script command_script cs_e10_m3_banshee_escort_1()
	//cs_vehicle_speed_instantaneous ( 1.0 );
	cs_vehicle_boost( TRUE );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e10_m3_banshee.bansh_1 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	
		cs_fly_by (ps_e10_m3_banshee.p18);	
		cs_fly_by (ps_e10_m3_banshee.p17);
		//cs_fly_by (ps_e10_m3_banshee.p2);
		//cs_fly_by (ps_e10_m3_banshee.p3);

		cs_fly_by (ps_e10_m3_banshee.p19);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_banshee.p10);
		sleep_s(5);
	
		ai_erase (sq_e10_m3_banshee_1);	
end

script command_script cs_e10_m3_banshee_escort_2()
	//cs_vehicle_speed_instantaneous ( 1.0 );
	cs_vehicle_boost( TRUE );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e10_m3_banshee.bansh_2 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	
		cs_fly_by (ps_e10_m3_banshee.p12);	
		cs_fly_by (ps_e10_m3_banshee.p11);
		//cs_fly_by (ps_e10_m3_banshee.p2);
		//cs_fly_by (ps_e10_m3_banshee.p3);

		cs_fly_by (ps_e10_m3_banshee.p16);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_banshee.p6);
		sleep_s(5);
	
		ai_erase (sq_e10_m3_banshee_2);	
end

script command_script cs_e10_m3_banshee_escort_3()
	//cs_vehicle_speed_instantaneous ( 1.0 );
	cs_vehicle_boost( TRUE );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e10_m3_banshee.bansh_3 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	
		cs_fly_by (ps_e10_m3_banshee.p2);	
		cs_fly_by (ps_e10_m3_banshee.p20);
		cs_fly_by (ps_e10_m3_banshee.p21);
		cs_fly_by (ps_e10_m3_banshee.p7);
		//cs_fly_by (ps_e10_m3_banshee.p2);
		//cs_fly_by (ps_e10_m3_banshee.p3);

		cs_fly_by (ps_e10_m3_banshee.p19);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_banshee.p5);
		sleep_s(5);
	
		ai_erase (sq_e10_m3_banshee_3);	
end


script command_script cs_e10_m3_banshee_escort_4()
	//cs_vehicle_speed_instantaneous ( 1.0 );
	cs_vehicle_boost( TRUE );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e10_m3_banshee.bansh_4 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	
		cs_fly_by (ps_e10_m3_banshee.p0);	
		cs_fly_by (ps_e10_m3_banshee.p14);
		//cs_fly_by (ps_e10_m3_banshee.p2);
		//cs_fly_by (ps_e10_m3_banshee.p3);

		cs_fly_by (ps_e10_m3_banshee.p16);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_banshee.p4);
		sleep_s(5);
	
		ai_erase (sq_e10_m3_banshee_4);	
end

script command_script cs_e10_m3_phant_lich_1()
	cs_vehicle_speed_instantaneous ( 1.0 );
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_lich_drop.driver), TRUE );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e10_m3_escorts.lich_drop );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);


		//dprint("lich escort 2");

		sleep(1);

		thread( e10_m3_phantom_load_playload_ghost(ai_vehicle_get( ai_current_actor ), sq_e10_m3_ark_ghost_elite.ghost_a, sq_e10_m3_ark_ghost_elite.ghost_b ) );
		cs_fly_by (ps_e10_m3_escorts.p25);
		cs_vehicle_speed (0.5);
		ai_set_objective(sq_e10_m3_ark_rang_elites_1, e10_m3_theark_obj );
		cs_fly_to_and_dock( ps_e10_m3_escorts.ghost_drop, ps_e10_m3_escorts.p22,2 );
		
		//f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_escort_2.driver), "dual");	
		vehicle_unload( unit_get_vehicle( sq_e10_m3_ark_ghost_elite.ghost_a ), "phantom_sc01" );
		vehicle_unload( unit_get_vehicle( sq_e10_m3_ark_ghost_elite.ghost_b ), "phantom_sc02" );
		b_e10_m3_lich_ghost_drop_done = TRUE;
		object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phant_lich_drop.driver), FALSE );
		sleep_rand_s(4,7);
		cs_vehicle_speed (1);
		cs_fly_by (ps_e10_m3_escorts.p26);
		//cs_fly_by (ps_e10_m3_escorts.p16);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 4 );
		cs_fly_by (ps_e10_m3_escorts.p15);
		sleep_s(4);	
		ai_erase (sq_e10_me_cov_phant_lich_drop);

	
	

end

global object o_the_core_1 = NONE;
global object o_the_core_2 = NONE;
global object o_the_core_3 = NONE;
global object o_the_core_4 = NONE;
global object p_core_carrier = NONE;

script static void f_e10_m3_core_attach_setup()

	if player_valid( player0() )then
		f_e10_m3_core_attach_loop( player0 );
	end
	
	if player_valid( player1() ) then
		f_e10_m3_core_attach_loop( player1 );
	end
	
	if player_valid( player2() ) then
		f_e10_m3_core_attach_loop( player2 );
	end		

	if player_valid( player3() ) then
		f_e10_m3_core_attach_loop( player3 );
	end
end

script static void f_e10_m3_core_attach_loop(player p_player)

	repeat
		sleep_until( object_get_health( p_player ) > 0 , 1 );
			//dprint("player is alive attach core");
			thread( f_e10_m3_core_attach_to_player(p_player) );
		sleep_until( object_get_health( p_player ) <= 0 , 1 );
			//dprint("player is dead");
	 	 sleep(15);
	until( b_e10_m3_win , 1 );

end

script static void f_e10_m3_core_attach_to_player(player p_player)
	//dprint("attach bomb");
	if player_valid( p_player )then
		if p_player == player0 then
			object_create_anew( cr_e10_m3_core_1 );
			sleep(1);
			//o_the_core_1 = cr_e10_m3_core_1;
			objects_attach (p_player, "package", cr_e10_m3_core_1, "m_attach_player" );
		end
		
		if p_player == player1  then
			object_create_anew( cr_e10_m3_core_2 );
			sleep(1);
			//o_the_core_2 = cr_e10_m3_core_2;
			objects_attach ( p_player, "package", cr_e10_m3_core_2, "m_attach_player" );
		end
		
		if p_player == player2  then
			object_create_anew( cr_e10_m3_core_3 );
			sleep(1);
			//o_the_core_3 = cr_e10_m3_core_3;
			objects_attach (p_player, "package", cr_e10_m3_core_3, "m_attach_player" );
		end		
	
		if p_player == player3  then
			object_create_anew( cr_e10_m3_core_4 );
			sleep(1);
			//o_the_core_4 = cr_e10_m3_core_4;
			objects_attach ( p_player, "package", cr_e10_m3_core_4, "m_attach_player" );
		end
	end

	sleep(1);

end



global boolean b_e10_m3_phantom_twitch = FALSE;

script static void e10_m3_phantom_twitch()

	repeat
		b_e10_m3_phantom_twitch = FALSE;
		sleep_rand_s(6,9);
		b_e10_m3_phantom_twitch = TRUE;
		sleep_rand_s(6,9);
	until( s_objcon_e10_m3 >= 90 );


end

script command_script cs_e10_m3_phantom_chase_1()


	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);



end

script command_script cs_e10_m3_phantom_chase_2()

	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);

end

script command_script cs_e10_m3_phantom_chase_3()


	cs_vehicle_speed ( 0.5);
	//object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	//object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	
	

	cs_fly_to_and_dock( ps_e10_m3_chase.p17, ps_e10_m3_chase.p0,3 );
	sleep_until( s_objcon_e10_m3 >= 100 , 1);
		///sleep_s(1.5);
		cs_vehicle_speed ( 0.8);
		cs_face( TRUE, ps_e10_m3_chase.p19 );
		cs_fly_by(ps_e10_m3_chase.p18);
		cs_fly_to(ps_e10_m3_chase.p19);
		cs_face(FALSE, ps_e10_m3_chase.p19);
		sleep_s(5);
		//ai_set_objective(ai_current_actor, e10_m3_phantom_chase_obj);

end

//ai_advance_immediate(sq_e3_knight_ranger);


script static void e10_m3_activate_button_sequence_comm( )
	
	f_blip_flag( flg_e10_m3_lich_beacon, "activate");
	device_set_power( dc_e10_m3_theark, 1 );
	device_set_power( dm_e10_m3_call_lich , 1);
	sleep_until( device_get_position( dc_e10_m3_theark ) > 0 and g_ics_player != NONE,1);
		local long show = pup_play_show(  pup_e10_m3_call_lich );
		device_set_power( dc_e10_m3_theark, 0 );
		sleep(1);
	sleep_until ( not pup_is_playing( show ), 1 );
		g_ics_player = NONE;
		sleep(10);
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm_e10_m3_call_lich, 1 ); //AUDIO!
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\scripted\amb_hillside_e10m3_cov_alarm', dc_e10_m3_theark, 1 ); //Covenant Alarm Audio!
		device_set_position( dm_e10_m3_call_lich, 1 );
		
		f_unblip_flag( flg_e10_m3_lich_beacon );
				
		sleep_until(device_get_position(dm_e10_m3_call_lich) == 1, 1);
				object_hide(dm_e10_m3_call_lich, TRUE);

end

script static void e10_m3_activate_button_sequence_forerunner( device dc, device holo, boolean b_dissolve, cutscene_flag cf_blip )
	local long show = -1;
	f_blip_flag( cf_blip, "activate");
	device_set_power( dc, 1 );
	device_set_power( holo, 1 );
	sleep_until( device_get_position( dc ) > 0 and g_ics_player != NONE, 1);
		if dc == dc_e10_m3_start_door then
			dprint("starting opening pup");
			show = pup_play_show ( pup_e10_m3_barrier );
		elseif dc == dc_e10_m3_exit_door then
			dprint("exit pup");
			show = pup_play_show ( pup_e10_m3_exit );
		else
			show = pup_play_show ( pup_e10_m3_gate );
		end
		
		device_set_power( dc, 0 );
		sleep(1);
	sleep_until ( not pup_is_playing( show ), 1 );
		g_ics_player = NONE;
		//sleep(10);
		dprint("starting hologram");
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e10m3_hillside_panel_hologram_mnde842', holo, 1 ); //AUDIO!
		device_set_position( holo, 1 );
		
		f_unblip_flag( cf_blip );
		
		if b_dissolve then
			sleep_until(device_get_position(holo) == 1, 1);
				sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', holo, 1 ); //AUDIO!
				object_dissolve_from_marker(holo, phase_out, panel);
		end
		

end

script static void f_activator_get( object trigger, unit activator )
	//dprint( "f_activator_get s" );
	g_ics_player = activator;
end


global boolean b_e10_m3_goose_squad_in_veh = TRUE;
global boolean b_e10_m3_filler_squad_in_veh = FALSE;

script static void e10_m3_goose_squad_update()


	repeat
		if ai_vehicle_count (sg_e10_m3_unsc_goose ) > 0 then
			b_e10_m3_goose_squad_in_veh = TRUE;
		else
			b_e10_m3_goose_squad_in_veh = FALSE;
		end
		sleep_s(1);
	until( FALSE, 1);
end

script static void e10_m3_filler_squad_update()
	repeat
		if ai_vehicle_count ( sq_e10_m3_unsc_filler ) > 0 then
			b_e10_m3_filler_squad_in_veh = TRUE;
		else
			b_e10_m3_filler_squad_in_veh = FALSE;
		end
		sleep_s(1);	

	until( FALSE, 1);
end

//script static short bah()
	//f_ability_player_cnt('objects\equipment\storm_jet_pack\storm_jet_pack.equipment');
//end

script static void e10_m3_blip_jetpacks()
	//dprint("get ready jetpacks");
	if player_valid( player0 ) then
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_01, player0) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_02, player0) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_03, player0) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_04, player0) );

	end
	
	
	if player_valid( player1 ) then
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_01, player1) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_02, player1) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_03, player1) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_04, player1) );
	end
	
	if player_valid( player2 ) then
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_05, player2) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_06, player2) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_07, player2) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_08, player2) );
	end
	
	if player_valid( player3 ) then
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_05, player3) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_06, player3) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_07, player3) );
		thread( e10_m3_blip_jetpack(eq_e10_m3_jp_08, player3) );
	end
end
//
global boolean b_e10_m3_jetpack_vo = FALSE;
script static void e10_m3_blip_jetpack( object_name jetpack, player p_player)

	if f_ability_player_cnt('objects\equipment\storm_jet_pack\storm_jet_pack.equipment') < player_count() then
		//dprint("snack packs");
		sleep(1);
	end
	
	repeat
		//spops_blip_object( jetpack, TRUE, "jetpack" );
		
		//navpoint_track_object_for_player ( player0, jetpack, TRUE );
		if ( not unit_has_equipment(p_player, 'objects\equipment\storm_jet_pack\storm_jet_pack.equipment') ) and not e10_m3_get_player_on_the_lich(p_player) then
			
			if not b_e10_m3_jetpack_vo then
				b_e10_m3_jetpack_vo = TRUE;
				e10m3_narr_clear_wait();
				
				if b_103_rvb_interact then
					vo_e10m3_jetpacks_rvbalt();
				else
					vo_e10m3_jetpacks();
				end
			end
			//
			navpoint_track_object_for_player_named ( p_player, jetpack, "navpoint_jetpack" );
			
			
			
			
			//sleep_until( objects_distance_to_object ( p_player,jetpack  ) < 1 and objects_distance_to_object ( p_player,jetpack  ) > 0 or unit_has_equipment(p_player, 'objects\equipment\storm_jet_pack\storm_jet_pack.equipment',1 );
			sleep_until( unit_has_equipment(p_player, 'objects\equipment\storm_jet_pack\storm_jet_pack.equipment') or b_e10_m3_artifact_retrieved  or objects_distance_to_object ( Players(),jetpack  ) < 2 or e10_m3_get_player_on_the_lich(p_player),1 );
				navpoint_track_object_for_player ( p_player, jetpack, FALSE );
			sleep_until( objects_distance_to_object ( p_player,jetpack  ) > 3,1 );
		else
			//dprint("player has jetpack");
			sleep_s(4);
		end
	until( b_e10_m3_artifact_retrieved ,1 );
end

//navpoint_track_object_for_player ( player0, eq_e10_m3_jp_01, TRUE );
//navpoint_track_object_for_player_named ( player0, eq_e10_m3_jp_01, "navpoint_jetpack" );
//navpoint_track_object_for_player ( player0, eq_e10_m3_jp_01, FALSE );
//eq_e10_m3_jp_01  //navpoint_jetpack
//objects_distance_to_object <object_list> <object>
 //spops_blip_object( eq_e10_m3_jp_01, TRUE, "jetpack" );


script static void f_e10_m3_veh_respawn (object_name veh)
	//print ("veh respawn");
	
	//object_create (veh);
	//print ("players aren't looking repsawning veh");
	//ai_object_set_team (veh, player);
	//object_set_allegiance (veh, player);
	
	repeat
		sleep_until (object_get_health (veh) <= 0, 1);
		//print ("veh dead, respawning when players aren't looking");
		sleep_s(5);
		//sleep_until (not volume_test_players_lookat (tv_veh_respawn, 20, 20) and not volume_test_players_lookat (tv_veh_respawn2, 10, 10), 1);
			object_create_anew (veh);
			//print ("players aren't looking repsawning veh");
			ai_object_set_team (veh, player);
			object_set_allegiance (veh, player);
	until (b_game_ended, 1);
	
end


script static void f_e10_m3_aa_respawn (object_name aa)
	//print ("aa respawn");
		
	repeat
		sleep_until ( not object_valid (aa) , 1);
		//print ("aa, respawning when players aren't looking");
		sleep_s(5);
		//sleep_until (not volume_test_players_lookat (tv_veh_respawn, 20, 20) and not volume_test_players_lookat (tv_veh_respawn2, 10, 10), 1);
			object_create_anew (aa);
		//	print ("players aren't looking repsawning veh");

	until (b_game_ended, 1);
	
end

script static void e10_m3_phantom_load_playload_ghost (vehicle vphantom, ai ghost_driver_1, ai ghost_driver_2)
	//print ("spawning payload");
	ai_place_in_limbo  (ghost_driver_1);
	ai_place_in_limbo  (ghost_driver_2);

	vehicle_load_magic( vphantom, "phantom_sc01", unit_get_vehicle(ghost_driver_1));
	vehicle_load_magic( vphantom, "phantom_sc02", unit_get_vehicle(ghost_driver_2));
	ai_exit_limbo (ghost_driver_1);
	ai_exit_limbo (ghost_driver_2);
end

script static void	f_load_phantom_dual_10_3( unit u_phantom, ai ai_squad_01, ai ai_squad_02, ai ai_squad_03,ai ai_squad_04, boolean b_ai_place )

							
	f_load_phantom_seat_10_3( ai_squad_01, u_phantom, "phantom_p_lf", b_ai_place );
	f_load_phantom_seat_10_3( ai_squad_02, u_phantom, "phantom_p_rf", b_ai_place );
	f_load_phantom_seat_10_3( ai_squad_03, u_phantom, "phantom_p_lb", b_ai_place );
	f_load_phantom_seat_10_3( ai_squad_04, u_phantom, "phantom_p_rb", b_ai_place );
end

script static void f_load_phantom_seat_10_3( ai ai_squad, unit u_phantom, unit_seat_mapping usm_seat, boolean b_ai_place )
	if ( b_ai_place ) then
		ai_place( ai_squad );
	end
	if ( ai_squad != NONE ) then
		ai_vehicle_enter_immediate ( ai_squad, u_phantom, usm_seat );
	end
end

global boolean b_e10_m3_basin_a_occupied = FALSE;
global boolean b_e10_m3_basin_b_occupied = FALSE;
global boolean b_e10_m3_basin_c_occupied = FALSE;
global boolean b_e10_m3_basin_d_occupied = FALSE;
global boolean b_e10_m3_basin_e_occupied = FALSE;

script dormant e10_m3_basin_occupations()

	thread(e10_m3_basin_a_occupied());
	thread(e10_m3_basin_b_occupied());
	thread(e10_m3_basin_c_occupied());
	thread(e10_m3_basin_d_occupied());
	thread(e10_m3_basin_e_occupied());

end

script static void e10_m3_basin_a_occupied()

	repeat
		if volume_test_objects(tv_e10_m3_basin_a , ( ai_actors(sg_e10_m3_all_enemies) ) ) then
			b_e10_m3_basin_a_occupied = TRUE;
		else
			b_e10_m3_basin_a_occupied = FALSE;
		end
		sleep_s(1);
	until(b_e10_m3_lich_wounded, 1);

end

script static void e10_m3_basin_b_occupied()

	repeat
		if volume_test_objects(tv_e10_m3_basin_b , ( ai_actors(sg_e10_m3_all_enemies) ) ) then
			b_e10_m3_basin_b_occupied = TRUE;
		else
			b_e10_m3_basin_b_occupied = FALSE;
		end
		sleep_s(1.1);
	until(b_e10_m3_lich_wounded, 1);

end

script static void e10_m3_basin_c_occupied()

	repeat
		if volume_test_objects(tv_e10_m3_basin_c , ( ai_actors(sg_e10_m3_all_enemies) ) ) then
			b_e10_m3_basin_c_occupied = TRUE;
		else
			b_e10_m3_basin_c_occupied = FALSE;
		end
		sleep_s(1);
	until(b_e10_m3_lich_wounded, 1);

end

script static void e10_m3_basin_d_occupied()

	repeat
		if volume_test_objects(tv_e10_m3_basin_d , ( ai_actors(sg_e10_m3_all_enemies) ) ) then
			b_e10_m3_basin_d_occupied = TRUE;
		else
			b_e10_m3_basin_d_occupied = FALSE;
		end
		sleep_s(1.1);
	until(b_e10_m3_lich_wounded, 1);

end

script static void e10_m3_basin_e_occupied()

	repeat
		if volume_test_objects(tv_e10_m3_basin_e , ( ai_actors(sg_e10_m3_all_enemies) ) ) then
			b_e10_m3_basin_e_occupied = TRUE;
		else
			b_e10_m3_basin_e_occupied = FALSE;
		end
		sleep_s(1);
	until(b_e10_m3_lich_wounded, 1);

end


global boolean b_e10_m3_perf_saver_on = FALSE;
global long l_perf_timer = -1; 

script static void e10_m3_perf_saver()
	l_perf_timer = timer_stamp(10);
	
	if not b_e10_m3_perf_saver_on then
		b_e10_m3_perf_saver_on = TRUE;
		effects_perf_armageddon = TRUE;

	sleep_until( timer_expired(l_perf_timer) or ai_living_count(sg_e10_m3_all_enemies ) <= 10, 1);
		b_e10_m3_perf_saver_on = FALSE;
		effects_perf_armageddon = FALSE;
	end
end


script static boolean e10m3_narr_clear()
	not e10m3_narrative_is_on and not global_narrative_is_on;
end

script static void e10m3_narr_clear_wait()
	sleep_until( e10m3_narr_clear(), 1 );
end

global boolean b_103_rvb_interact = false;
 
script static void f_103_rvb_interact()

  object_create (e10_m3_rvb);
  sleep_until(object_valid(e10_m3_rvb), 1);
  sleep_until (object_get_health (e10_m3_rvb) < 1, 1);
                
  object_cannot_take_damage (e10_m3_rvb);                
	//play stinger
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);  
  b_103_rvb_interact = true;
 
end



script static void camera_shake_all_coop_players_10_3 ( real attack, real intensity, short duration, real decay, sound shake_sound)

	// play the sound
	if (shake_sound != NONE) then
		sound_impulse_start(shake_sound, NONE, 1);
	end
	
	if ( player_valid( player0 ) ) then
		player_effect_set_max_rotation_for_player (player0, (intensity*3), (intensity*3), (intensity*3));
		player_effect_set_max_rumble_for_player (player0, 1, 1);
		player_effect_start_for_player (player0, intensity, attack);
	end

	if ( player_valid( player1) )  then
		player_effect_set_max_rotation_for_player (player1, (intensity*3), (intensity*3), (intensity*3));
		player_effect_set_max_rumble_for_player (player1, 1, 1);	
		player_effect_start_for_player (player1, intensity, attack);
	end
		
	if ( player_valid( player2 )  ) then	
		player_effect_set_max_rotation_for_player (player2, (intensity*3), (intensity*3), (intensity*3));
		player_effect_set_max_rumble_for_player (player2, 1, 1);
		player_effect_start_for_player (player2, intensity, attack);
	end
	
	if ( player_valid( player3 ) ) then		
		player_effect_set_max_rotation_for_player (player3, (intensity*3), (intensity*3), (intensity*3));	
		player_effect_set_max_rumble_for_player (player3, 1, 1);
		player_effect_start_for_player (player3, intensity, attack);
	end
	
	sleep (duration * 30);
	if ( player_valid( player0 ) )  then	
		player_effect_stop_for_player (player0, decay);
		player_effect_set_max_rumble_for_player (player0, 0, 0);
	end
	
	if (player_valid( player1 ) ) then
		player_effect_set_max_rumble_for_player (player1, 0, 0);
		player_effect_stop_for_player (player1, decay);
	end
	
	if ( player_valid( player2 ) ) then
		player_effect_set_max_rumble_for_player (player2, 0, 0);
		player_effect_stop_for_player (player2, decay);
	end
	
	if ( player_valid( player3 ) ) then
		player_effect_set_max_rumble_for_player (player3, 0, 0);
		player_effect_stop_for_player (player3, decay);
	end

end

script static void f_new_objective_not_pause_screen (string_id objective_text)

	if editor_mode() then
		cinematic_set_title (new_obj);
	end
	
	f_objective_complete();
	f_pause_screen_complete_objectives();
	sleep(15);
	//print ("new objective HUD");
	cui_hud_set_new_objective (objective_text);


end


//bug 10815 and 10813 gmurphy fixes
//set up a function that waits until the basin door is closed, teleports players out of the area by the door and creates a scenery object that blocks Players 
//then it sleeps until the door is open and destroys the scenery object 

script static void f_e10_m3_basin_door_teleport
	print ("basin door teleport start");
	
	//disables the soft ceiling
	soft_ceiling_enable("e10_m3_basin_blocker", false);
	print ("ceiling disabled");
	
	//sleep until the door is closed
	sleep_until (device_get_position (dm_hillside_basin_door) > 0, 2);
	sleep_until (device_get_position (dm_hillside_basin_door) <= 0, 2);
	//sleep_until (not b_e10_m3_door_open, 2);
	//teleport players away
	volume_teleport_players_inside_with_vehicles (tv_e10_m3_basin_teleport, flg_e10_m3_teleport_in);
	print ("players teleported from basin");
	
	//enable the blocker so players can't get outside the structure volume 
	soft_ceiling_enable("e10_m3_basin_blocker", true);
	print ("ceiling enabled");
	
	//sleep until the door starts opening again
	sleep_until (device_get_position (dm_hillside_basin_door) > 0, 2);
	//sleep_until (b_e10_m3_door_open, 2);
	//disable the invisible blocker
	soft_ceiling_enable("e10_m3_basin_blocker", false);
	print ("ceiling disabled");

end

/*
script static void yarr()
	turret_open_close
end

*/