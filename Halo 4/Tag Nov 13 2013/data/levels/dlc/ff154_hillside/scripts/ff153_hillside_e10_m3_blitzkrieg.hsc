//// =============================================================================================================================
//========= CAVERNS e10_m3 RECON FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================



global boolean b_e10_m3_force_start = FALSE;
global boolean b_e10_m3_rendevous_complete = FALSE;

global boolean b_e10_m3_theark_init = FALSE;
global boolean b_e10_m3_reached_theark_obj = FALSE;
global boolean b_e10_m3_get_artifact = FALSE;
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
global boolean b_e10_m3_artifact_spawn_done = FALSE;
/// LICH GLOBALS
global boolean b_e10_m3_lich_in_play = FALSE;
global boolean b_e10_m3_move_lich_down = FALSE;
global boolean b_e10_m3_lich_wounded = FALSE;
global boolean b_e10_m3_lich_dead = FALSE;



script startup f_e10_m3_startup()
	
	//move into main script please
		kill_volume_disable( kill_e10_m3_lich_wipe  );	
	//Wait for start
	if ( f_spops_mission_startup_wait("e10_m3") or b_e10_m3_force_start ) then	
		dprint( "---------f_e10_m3_startup-----------" );
		wake( f_e10_m3_init );		
	end
	
end

script static void debug_e10_m3()

	game_set_variant( e10_m3_hillside_blitzkrieg );
end

script dormant f_e10_m3_init()
	f_spops_mission_setup( "e10_m3", "e10_m3_hills_up", sg_e10_m3_all_enemies, e10_m3_start_locs, 91 );
		dprint("BEGIN::::: e10 m3 hillside blitzkrieg");
		//switch_zone_set("e10_m3_hills_up");
		//ai_ff_all = sg_e10_m3_all_enemies;	

	f_spops_mission_intro_complete( TRUE );
		thread( e10_m3_blitzkrieg_setup_main() );

		b_end_player_goal = FALSE;
end

script static void f_zone_num()
	inspect(current_zone_set_fully_active());
end

//b_end_player_goal = TRUE;


script static void e10_m3_blitzkrieg_setup_main()

		dprint("setup main");
		
		//sleep(5); 
		wake( e10_m3_streaming );
		f_add_crate_folder( e10_m3_scenery );
		//f_add_crate_folder( e10_m3_start_locs );
		f_add_crate_folder( veh_e10_m3 );
		f_add_crate_folder( dms_e10_m3 );
		f_add_crate_folder( eq_e10_m3 );
		f_add_crate_folder( crs_e10_m3_hillside );
	//	firefight_mode_set_crate_folder_at( e10_m3_start_locs, 91);	
		firefight_mode_set_crate_folder_at( e10_m3_respawn_locs_1, 92);
		firefight_mode_set_crate_folder_at( e10_m3_respawn_locs_2, 93);	
		firefight_mode_set_crate_folder_at( e10_m3_respawn_locs_3, 94);		
		firefight_mode_set_crate_folder_at( e10_m3_respawn_theark, 95);
		
		firefight_mode_set_objective_name_at(e10_m3_lz_0 ,51); 	
		f_spops_mission_setup_complete( TRUE );
		dm_droppod_5 = dm_e10_m3_hillside_door;
		sleep(5);

		wake( f_e10_m3_objcon_controller );
		thread( e10_m3_creation() );
		thread( e10_m3_spawns_init());
		wake( e10_m3_hillside_up_objectives );
		wake( e10_m3_hillside_down_init );
		wake( e10_m3_events );
		thread( e10_m3_theark_init() );
		thread( e10_m3_close_big_door() );
		thread( e10_m3_ghost_intro_flee() );
end


/////////////////////////////////////////
//  Hillside Up
/////////////////////////////////////////

script static void e10_m3_spawns_init()
	thread( e10_m3_marine_manager() );
	wake( e10_m3_hillside_intro_spawns );
end

script dormant e10_m3_events()
	dprint("============");
	sleep_until( LevelEventStatus("end_e10_m3_1") ,1 );
		dprint("event complete");
		sleep_s(10);
		b_e10_m3_rendevous_complete = true;

end

script dormant e10_m3_hillside_up_objectives()
	sleep_until( b_e10_m3_rendevous_complete ,1 );
		sleep_s(5);
		f_blip_flag( flg_e10_m3_hillside_mid ,"recon" );
	sleep_until( s_objcon_e10_m3 > 15 ,1 );
		f_unblip_flag( flg_e10_m3_hillside_mid );
		sleep_s(1);
		f_blip_flag( flg_e10_m3_hillside_door ,"recon" );
		
	sleep_until( s_objcon_e10_m3 > 20 ,1 );	
		sleep_s(5);
		f_unblip_flag( flg_e10_m3_hillside_door );
	sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 0 and b_e10_m3_door_reinforced,1 );
		sleep_s(5);
		device_set_power( dc_e10_m3_hillside_door, 1 );
		b_e10_m3_door_fight_complete = TRUE;
		f_blip_object(dc_e10_m3_hillside_door, "activate" );
		device_set_power(dc_e10_m3_hillside_door, 1);
	sleep_until( device_get_position ( dc_e10_m3_hillside_door ) > 0.0 ,1 ); 
		dprint("door open"); 
		f_unblip_object(dc_e10_m3_hillside_door);                                                                                                                                                                                                                                 
		device_set_power(dc_e10_m3_hillside_door, 0);
		b_e10_m3_theark_init = TRUE;
		e10_m3_open_big_door();

end

script dormant e10_m3_hillside_intro_spawns()	
	ai_place(sg_e10_m3_hillside_up);
	sleep_until( ( ai_spawn_count(sg_e10_m3_hillside_up) > 0 and ai_living_count(sg_e10_m3_hillside_up)<= 3 )   , 1);
		dprint("placing exterior reinforcements");
			
		ai_place_in_limbo (sg_e10_m3_hillside_up_reinforce);
		thread (f_dlc_load_drop_pod (dm_e10_m3_hillside_door, sg_e10_m3_hillside_up_reinforce, NONE,obj_drop_pod_4));
		//f_dlc_load_drop_pod (object_name dm_drop, ai squad, ai squad2, object_name pod)
		ai_set_objective(sg_e10_m3_hillside_up_reinforce, e10_m3_enemy_hillside_obj );
		sleep(1);
		b_e10_m3_door_reinforced = TRUE;
	sleep_until( ( ai_spawn_count(sg_e10_m3_all_enemies) > 0 and ai_living_count(sg_e10_m3_all_enemies) <= 4 ) , 1);
		f_blip_ai_cui( sg_e10_m3_all_enemies, "navpoint_enemy" );
end


script static void e10_m3_creation()
	
		object_create( dc_e10_m3_hillside_door );
		device_set_power(dc_e10_m3_hillside_door, 0);
		object_create( dc_e10_m3_theark );
		device_set_power(dc_e10_m3_theark, 0);		
		object_hide (lichy, true);
		object_set_physics (lichy, false);
		object_cannot_die(lichy, true);

end

script static void e10_m3_fore_defense_activate(device dm, ai a_squad, object_name core )

	e10_m3_aperture_open( dm );
	sleep_s(3.0);
	object_create(core);
	//object_set_health (core, 0.4 );
	sleep(1);
	f_blip_object(core, "neutralize");
	object_move_by_offset( core, 1.5, 0,0, 1 );

	if a_squad != NONE then
		ai_place( a_squad );
	end
		
		sleep_until( object_get_health( core ) <= 0 , 1);
			f_unblip_object(core);
			s_e10_m3_hs_core_count = s_e10_m3_hs_core_count - 1;
			sleep(30);
			if a_squad != NONE then
				ai_erase( a_squad );
			end


end

script static void e10_m3_aperture_open( device dm )

	//device_animate_position(  dm , 1 , 3.0, 0.1, 0.0, TRUE );
	device_set_position( dm, 1 );

end

script static void e10_m3_aperture_close( device dm )

	//device_animate_position(  dm , 1 , 3.0, 0.1, 0.0, TRUE );
	device_set_position( dm, 0 );

end


script static void e10_m3_marine_manager()

	ai_place( sq_e10_m3_spartan_1 );
	
	if game_coop_player_count() < 3 then
		ai_place( sq_e10_m3_spartan_2 );		
	end

end

script static void e10_m3_close_big_door()
	object_move_by_offset( sn_e10_m3_big_door , 0, 0,0,-5);
end
script static void e10_m3_open_big_door()
	object_move_by_offset( sn_e10_m3_big_door , 5, 0,0,5);
	b_e10_m3_door_open = TRUE;
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
		dprint("===== THEARK ====");
		object_create_folder(crs_e10_m3_ark);
		sleep(1);
		thread( e10_m3_theark_objectives ());
		thread( e10_m3_theark_initial_spawns() );
		sleep(1);

		thread( e10_m3_lich_battle_spawn() );
end


script static void e10_m3_ghost_intro_flee()
	sleep_until( volume_test_players( tv_e10_m3_tunnel_trans ) );

		dprint("flee ghost grunts");
		b_e10_m3_intro_ghost_flee = TRUE;
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
	
	sleep(15);
	
	sleep_until( ai_living_count(sg_e10_m3_all_enemies) <= 3 and s_e10_m3_ark_generator_count <= 0);
			sleep_s( 8 );
				thread( m10_m3_lich_init());
end

script static void e10_m3_theark_objectives()
	sleep_until( volume_test_players(tv_e10_m3_theark_entrance) ,1 );
		f_blip_flag( flg_e10_m3_theark , "recon" );
	sleep_until( volume_test_players(tv_e10_m3_theark) ,1 );
		f_unblip_flag( flg_e10_m3_theark);	
		b_e10_m3_reached_theark_obj = TRUE;
		thread(e10_m3_theark_destroy_gens());

end



script static void e10_m3_theark_destroy_gens()
	dprint("destroy geneators");
	thread(e10_m3_ark_generator_setup( cr_e10_m3_ark_gen_1 ));
	thread(e10_m3_ark_generator_setup( cr_e10_m3_ark_gen_2 ));
	thread(e10_m3_ark_generator_setup( cr_e10_m3_ark_gen_3 ));
	
	sleep_until( s_e10_m3_ark_generator_count <= 0 , 1);
		dprint("all generators destroyed");

end

script static void e10_m3_ark_generator_setup( object_name gen )
	if object_get_health(gen) > 0 then
		f_blip_object(gen, "neutralize");
	end
	
	sleep_until( object_get_health(gen) <= 0 ,1 );
		s_e10_m3_ark_generator_count = s_e10_m3_ark_generator_count - 1;
		dprint("ark generator destroyed");
		f_unblip_object(gen);
		
		if gen == cr_e10_m3_ark_gen_1 then
			sleep(3);
			object_destroy(cr_e10_m3_ark_gen_1_bub);
			b_e10_m3_obj_1_dead = TRUE;
		end
		
		if gen == cr_e10_m3_ark_gen_2 then
			sleep(3);
			object_destroy(cr_e10_m3_ark_gen_2_bub);
			b_e10_m3_obj_2_dead = TRUE;
		end
		
		if gen == cr_e10_m3_ark_gen_3 then
			sleep(3);
			object_destroy(cr_e10_m3_ark_gen_3_bub);
			b_e10_m3_obj_3_dead = TRUE;
		end
end

////////////////////////////////////////////////////
//	HILLSIDE DOWN
////////////////////////////////////////////////////

script static void debug_hs_down_e10_m3()
	ai_erase(sg_e10_m3_all_enemies);
	sleep(5);
	s_objcon_e10_m3 = 50;
	ai_erase(sg_e10_m3_all_enemies);
	wake( e10_m3_hillside_down_init );
	
	b_e10_m3_lich_dead = TRUE;
end

script dormant e10_m3_hillside_down_init()

	sleep_until( b_e10_m3_lich_dead ,1 );
		dprint("==== HILLSIDE DOWN INIT ====");
		ai_set_objective(sg_e10_m3_unsc, e10_m3_unsc_veh_obj_dwn);
		wake( f_e10_m3_objcon_controller_down );
		thread(e10_m3_artifact_objectives());
end

script static void e10_m3_artifact_objectives()
		dprint("story bits");
		sleep_s(10);
		b_e10_m3_get_artifact = TRUE;
		thread( e10_m3_down_fore_spawns() );
		
	sleep_until( b_e10_m3_artifact_spawn_done and ai_living_count(sg_e10_m3_all_enemies) <= 0 , 1);
		sleep_s(5);		
		f_blip_object(dc_e10_m3_theark, "activate" );
		device_set_power(dc_e10_m3_theark, 1);
	sleep_until( device_get_position ( dc_e10_m3_theark ) > 0.0 ,1 ); 
		f_unblip_object( dc_e10_m3_theark );
		device_set_power(dc_e10_m3_theark, 0);
		b_e10_m3_artifact_retrieved = TRUE;
		sleep_s(5);
		thread(e10_m3_hillside_down_objectives() );
		//ai_place(sg_e10_m3_fore_turrets);
end

script static void e10_m3_hillside_down_objectives()
		ai_place( sq_e10_m3_hunters );
		f_blip_flag(flg_e10_m3_hillside_mid, "default" );
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_hillside_mid) < 35 ,1 ); 
		//ai_place(sq_e10_m3_turrets_1);
		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_5,sq_e10_m3_turrets_1, cr_e10_m2_core_1));
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_hillside_mid) < 12 ,1 ); 
		f_unblip_flag( flg_e10_m3_hillside_mid );
		f_blip_flag(flg_e10_m3_hillside_step_1, "default" );
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_hillside_step_1) < 35,1 ); 
		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_2,sq_e10_m3_turrets_2, cr_e10_m2_core_2) );
		sleep(15);
		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_1,NONE, cr_e10_m2_core_3));
		sleep(30);
		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_3,NONE, cr_e10_m2_core_4));
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_hillside_step_1) < 12,1 ); 
		f_unblip_flag( flg_e10_m3_hillside_step_1 );
		f_blip_flag(flg_e10_m3_hillside_startend, "default" );
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_hillside_startend) < 35 ,1 ); 
		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_4,sq_e10_m3_turrets_3, cr_e10_m2_core_5) );
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_hillside_startend) < 12 ,1 );
		f_unblip_flag( flg_e10_m3_hillside_startend );
	
	sleep_until( ai_living_count(sg_e10_m3_all_enemies) <= 0  and s_e10_m3_hs_core_count == 0 ,1 ); //
		f_blip_flag(flg_e10_m3_cavern_exit, "default" );
	sleep_until( objects_distance_to_flag(Players(),flg_e10_m3_cavern_exit) < 6 ,1 ); 
		f_unblip_flag( flg_e10_m3_cavern_exit );

		f_e10_m3_win();
end

script static void e10_m3_down_fore_spawns()
	dprint("kill forerunners");
	//ai_place(sg_e10_m3_fore_bowl);
	ai_place_in_limbo( sq_e10_m3_for_bw );
	ai_place_in_limbo( sq_e10_m3_for_knight );
	ai_place_with_birth( sq_e10_m3_for_bish_1 );
	ai_place_with_birth( sq_e10_m3_for_bish_2 );
	ai_place_with_birth( sq_e10_m3_for_bish_3 );
	sleep_s( 10 );
	thread( e10_m3_crazy_train() );
	sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 8,1 );	
		ai_place( sq_e10_me_cov_phantom_2 ) ;
	sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 2,1 );
		ai_place_in_limbo( sq_e10_m3_for_knight );
		ai_place_in_limbo( sq_e10_m3_for_com_1 );
		sleep_s(3);
		b_e10_m3_artifact_spawn_done = TRUE;
end

script static void e10_m3_crazy_train()
	sleep_until( ai_living_count(sg_e10_m3_fore_bowl_bishop) <= 0,1 );
		if object_get_health(sq_e10_m3_for_bw.abe) > 0 then
			ai_advance_immediate(sq_e10_m3_for_bw.abe);
			sleep_s( 5 );
		end
		if object_get_health(sq_e10_m3_for_bw.bee) > 0 then
			ai_advance_immediate(sq_e10_m3_for_bw.bee);
			sleep_s( 5 );
		end

		if object_get_health(sq_e10_m3_for_bw.see) > 0 then
			ai_advance_immediate(sq_e10_m3_for_bw.see);
			sleep_s( 5 );
		end

end

script static void e10_m3_down_cov_spawns()
	dprint("kill forerunners");
	//ai_place(sg_e10_m3_fore_bowl);
	//ai_place_in_limbo();
	
	sleep_until( ai_living_count( sg_e10_m3_all_enemies ) <= 3,1 );
end
//
/////////////////////////////////////////
//	DESIGNER ZONE SWITCH
/////////////////////////////////////////
script dormant e10_m3_streaming()

	sleep_until(b_e10_m3_lich_dead ,1);
		//thread( zoneset_prepare( 3, TRUE) );
		sleep(60);
		switch_zone_set("e10_m3_hills_down");

/*	sleep_until(volume_test_players( load_e10_m3_int_1 ),1);
		//thread( zoneset_load( 3, TRUE ) );
		switch_zone_set("e10_m3_int_1");
	sleep_until(  b_e10_m3_cavern_exit_open ,1);		
		switch_zone_set("e10_m3_ext_1");
*/

end

////////////////////////////////////////////////////
//	command script
///////////////////////////////////////////////////

script command_script cs_active_camo_use()
	if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
		dprint( "cs_active_camo_use: ENABLED" );
		thread( f_active_camo_manager(ai_current_actor) );
	end
end

script command_script cs_e10_m3_lich_jumper()

	unit_falling_damage_disable ( ai_current_actor, true );

end

script command_script cs_e10_m3_lich_grunt_jumper()

	//unit_falling_damage_disable ( ai_current_actor, true );
	//cs_go_to(ps_e10_m3_lich.p0, 0.2);
	dprint("got to point");
end

script static void e10_m3_open_chute_down( boolean bopen)

	lichy->grav_lift_down_active( bopen );

end

script static void f_active_camo_manager( ai ai_actor )
 local long l_timer = 0;
 local object obj_actor = ai_get_object( ai_actor );
	//dprint( "cs_active_camo_use: ENABLED" );

	repeat
	
		// activate camo
		if ( unit_get_health(ai_actor) > 0.0 ) then
			ai_set_active_camo( ai_actor, TRUE );
			dprint( "f_active_camo_manager: ACTIVE" ); 
		end
		
		// disable camo
		sleep_until( (unit_get_health(ai_actor) <= 0.0) or (objects_distance_to_object(Players(),obj_actor) <= 4.00) or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.1), 1 );
		if ( unit_get_health(ai_actor) > 0.0 ) then
			ai_set_active_camo( ai_actor, FALSE );
			dprint( "f_active_camo_manager: DISABLED" ); 
		end
		
		// manage resetting
		if ( unit_get_health(ai_actor) > 0.0 ) then
			l_timer = timer_stamp( 5.0, 10.0 );
			sleep_until( (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and unit_has_weapon_readied(ai_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (objects_distance_to_object(Players(),obj_actor) >= 4.0) and (not objects_can_see_object(Players(),obj_actor,25.0))), 1 );
		end
		if ( unit_get_health(ai_actor) > 0.0 ) then
			dprint( "f_active_camo_manager: RESET" ); 
		end
	
	until ( unit_get_health(ai_actor) <= 0.0, 1 );

end



script static void f_e10_m3_flash_camo(ai ai_actor)
		sleep_s(1.0);
		ai_set_active_camo( ai_actor, FALSE );
		sleep_s(1.5);
		ai_set_active_camo( ai_actor, TRUE );
end

script static void f_e10_m3_win()

	b_end_player_goal = true;
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end


script command_script cs_knight_rider()
	dprint("knight cs");
	cs_phase_in();
end



////////////////////////
//  LICH
///////////////////////

script static void m10_m3_lich_init()

//lich coords -41.021751, -209.261093, 56.800842
	object_set_physics (lichy, true);
	//object_hide (lichy, false);
	ai_place (sq_e10_m3_cov_lich);

end

script command_script cs_e10_m3_ark_lich()
	object_set_scale( lichy, 0.1, 0 );
	sleep(1);
	object_hide (lichy, false);
	object_set_scale( lichy, 1, 30 * 10 );
	ai_disregard(ai_actors(ai_current_actor), TRUE);
	cs_fly_by (ps_e10_m3_theark.p11);
	cs_fly_by (ps_e10_m3_theark.p8);
	thread( e10_m3_load_lich_gunners() );
	cs_vehicle_speed (0.5);	
	cs_fly_to_and_dock (ps_e10_m3_theark.p12, ps_e10_m3_theark.p9, 3);
	
	cs_vehicle_speed (0.2);
	//sleep_s(10);
	b_e10_m3_lich_in_play = TRUE;
	cs_fly_to_and_dock (ps_e10_m3_theark.p12, ps_e10_m3_theark.p11, 0.25);
	thread( e10_m3_lich_ranger_spawner() );
	sleep_until( b_e10_m3_move_lich_down, 1);
	sleep_s(3);
	b_e10_m3_lich_in_play = FALSE;
	cs_vehicle_speed (0.75);
	cs_fly_by (ps_e10_m3_theark.p0);
	cs_vehicle_speed (0.3);
	b_e10_m3_lich_wounded = TRUE;
	cs_fly_to_and_dock (ps_e10_m3_theark.p1, ps_e10_m3_theark.p13, 3);
	cs_vehicle_speed (0.15);
	cs_fly_to_and_dock (ps_e10_m3_theark.p1, ps_e10_m3_theark.p2, 2);
	cs_vehicle_speed (0.05);
	cs_fly_to_and_dock (ps_e10_m3_theark.p1, ps_e10_m3_theark.p2, 0.25);
	cs_vehicle_speed (0.5);
	thread(e10_m3_lich_power_core());
	sleep_forever();
		dprint("wot?");
end

script static void e10_m3_load_lich_gunners()
	ai_place(sg_e10_m3_lich_gunners);
  sleep(1);
  ai_vehicle_enter_immediate (sg_e10_m3_lich_gunners.gunner_1, (object_get_turret (lichy, 0)));
  ai_vehicle_enter_immediate (sg_e10_m3_lich_gunners.gunner_2, (object_get_turret (lichy, 1)));
end

script static void e10_m3_lich_power_core()
	f_blip_object (object_at_marker (lichy, "power_core"), "neutralize");
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) <= 0, 1);
		//localized shake
		sleep_rand_s( 2,4 );
		local long l_pup_die = pup_play_show (lich_dying_pup);
		sleep(15);
		f_unblip_object(object_at_marker (lichy, "power_core"));
		
		sleep_until( not pup_is_playing ( l_pup_die ), 1 );
			sleep_s(1);
			e10_m3_lich_destruction();
end

script static void e10_m3_lich_destruction()
	//cs_vehicle_speed ( lichy, 0.5);
	kill_volume_enable( kill_e10_m3_lich_wipe);
	ai_place( sq_e10_me_cov_phantom_1 );
	cs_fly_to_and_face( sq_e10_m3_cov_lich.pilot, true, ps_e10_m3_theark.p6 ,ps_e10_m3_theark.p7 );
	objects_attach (lichy, "", lich_octopus, "");
	objects_detach (lichy, lich_octopus);	
	sleep(30);
	kill_volume_disable( kill_e10_m3_lich_wipe  );
	local long l_pup_crash = 	pup_play_show (lich_crash_pup);
		
		sleep_until( not pup_is_playing ( l_pup_crash ), 1 );
			b_e10_m3_lich_dead = TRUE;
		kill_volume_disable( kill_e10_m3_lich_wipe  );
end



script command_script cs_e10_m3_intro_ghost1()
	//cs_abort_on_damage( TRUE );
	cs_face( TRUE,ps_e10_m3_hillside.p0 );
	sleep_until( b_e10_m3_intro_ghost_flee or s_objcon_e10_m3 >= 40, 1 );
	
		dprint("ghost run1");
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
	sleep_until( b_e10_m3_intro_ghost_flee or s_objcon_e10_m3 >= 40, 1 );
	
	//sleep_rand_s(0.25, 1 );	
	dprint("ghost run2");
	cs_vehicle_boost( TRUE );
	cs_vehicle_speed( 1 );
	cs_go_by(ps_e10_m3_hillside.p4, ps_e10_m3_hillside.p5);
	cs_face( FALSE, ps_e10_m3_hillside.p4 );
	cs_go_by(ps_e10_m3_hillside.p5, ps_e10_m3_hillside.p6);
	cs_go_by(ps_e10_m3_hillside.p6, ps_e10_m3_hillside.p7);
	ai_set_objective(ai_current_actor, e10_m3_enemy_veh_obj );
end

script static void e10_m3_lich_ranger_spawner()

	ai_place(sq_e10_m3_ark_rang_elites_1);
	ai_place(sq_e10_m3_ark_rang_elites_2, 2);
	sleep_s(6);
	thread( e10_m3_lich_chute_batch_1() );

	sleep(1);
	sleep_until(ai_living_count( sg_e10_m3_lich_encounter ) - e10_m3_lich_gunner_count() <= 4 , 1);
		inspect(ai_living_count( sg_e10_m3_lich_encounter ) - e10_m3_lich_gunner_count());
		dprint("spawing xtra rangers");
		ai_place(sq_e10_m3_ark_rang_elites_3, 2);
	sleep_until(ai_living_count( sg_e10_m3_lich_encounter ) - e10_m3_lich_gunner_count() <= 4 , 1);
		ai_place(sq_e10_m3_ark_rang_elites_4);
		thread( e10_m3_lich_chute_batch_1() );
		sleep_s(5);
		thread( e10_m3_lich_chute_batch_2() );
end

script static void e10_m3_lich_battle_spawn()
	sleep_until( b_e10_m3_lich_wounded , 1 );
		ai_place(sg_e10_m3_ark_lich_battle);
end

script static void e10_m3_lich_chute_batch_2()
	sleep_until(e10_m3_non_lich_enemy_count() <= 4 , 1);
		e10_m3_open_chute_down( true );
		sleep_s(2);


	
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a1, 1, 1, 10, true );
	  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a2, 1, 1, 10, true );
	  lichy->grav_lift_drop_unit( sq_e10_m3_ark_general_1.1, 1, 1, 10, true );
	  lichy->grav_lift_drop_unit( sq_e10_m3_ark_general_1.2, 1, 1, 10, true );
		sleep_s( 3 );  
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_1.billy, 1, 2, 10, true );
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_1.pilgrim, 1, 2, 10, true );
		e10_m3_open_chute_down( false);  	
		sleep_s( 6 );
	sleep_until( ai_living_count( sq_e10_m3_ark_general_1 ) <= 1 );
		e10_m3_open_chute_down( true );
		ai_place(sq_e10_m3_ark_rang_elites_1, 2);
		ai_place(sq_e10_m3_ark_rang_elites_2, 2);
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a1, 1, 1, 10, true );	
	sleep_until( ai_living_count( sq_e10_m3_ark_general_1 ) <= 3 );
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_2.kilgore, 1, 2, 10, true );
		lichy->grav_lift_drop_unit( sq_e10_m3_ark_hunters_2.trout, 1, 2, 10, true );
		e10_m3_open_chute_down( false);  	


	sleep_until( e10_m3_non_lich_enemy_count()  <= 1 );
	b_e10_m3_move_lich_down = TRUE;
end

script static void e10_m3_lich_chute_batch_1()
	e10_m3_open_chute_down( true );
	sleep_s(2);	
	lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a1, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a2, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a3, 1, 1, 10, true );
  lichy->grav_lift_drop_unit( sq_e10_m3_ark_grunt_rockets.a4, 1, 1, 10, true );
	e10_m3_open_chute_down( false);  	

end

script static short e10_m3_non_lich_enemy_count()
	ai_living_count( sg_e10_m3_all_enemies ) - e10_m3_lich_gunner_count();
end

script static void e10_m3_enemy_count()

	inspect( ai_living_count( sg_e10_m3_all_enemies ) );
end

script static short e10_m3_lich_gunner_count()

	ai_living_count( sg_e10_m3_lich_gunners );
end




/////////////////////////////////////////
//  OBJCON
/////////////////////////////////////////

script dormant f_e10_m3_objcon_controller()

	thread(f_e10_m3_objcon_10());
	thread(f_e10_m3_objcon_15());
	thread(f_e10_m3_objcon_20());
	thread(f_e10_m3_objcon_37());
	thread(f_e10_m3_objcon_30());
	thread(f_e10_m3_objcon_40());
	thread(f_e10_m3_objcon_45());
	thread(f_e10_m3_objcon_50());
end


script dormant f_e10_m3_objcon_controller_down()

	thread(f_e10_m3_objcon_60());
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
end
script static void f_e10_m3_objcon_20()


	sleep_until (volume_test_players (tv_e10_m3_objcon_20) or s_objcon_e10_m3 >= 20, 1);
		if s_objcon_e10_m3 <= 20 then
			s_objcon_e10_m3 = 20;
			dprint("s_objcon_e10_m3 = 20 ");
		end
end


script static void  f_e10_m3_objcon_30()


	sleep_until (volume_test_players (tv_e10_m3_objcon_30) or s_objcon_e10_m3 >= 30, 1);
		if s_objcon_e10_m3 <= 30 then
			s_objcon_e10_m3 = 30;
			dprint("s_objcon_e10_m3 = 30 ");
		end
end

script static void  f_e10_m3_objcon_37()


	sleep_until (s_objcon_e10_m3 >= 37 or b_e10_m3_door_open, 1);
		if s_objcon_e10_m3 <= 37 then
			s_objcon_e10_m3 = 37;
			dprint("s_objcon_e10_m3 = 37 ");
		end
end

script static void  f_e10_m3_objcon_40()


	sleep_until (volume_test_players (tv_e10_m3_objcon_40) or s_objcon_e10_m3 >= 40 , 1);
		if s_objcon_e10_m3 <= 40 then
			s_objcon_e10_m3 = 40;
			dprint("s_objcon_e10_m3 = 40 ");
		end
end

script static void  f_e10_m3_objcon_45()


	sleep_until (volume_test_players (tv_e10_m3_objcon_45) or s_objcon_e10_m3 >= 45, 1);
		if s_objcon_e10_m3 <= 45 then
			s_objcon_e10_m3 = 45;
			dprint("s_objcon_e10_m3 = 45 ");
		end
end

script static void  f_e10_m3_objcon_50()


	sleep_until (volume_test_players (tv_e10_m3_objcon_50) or s_objcon_e10_m3 >= 50, 1);
		if s_objcon_e10_m3 <= 50 then
			s_objcon_e10_m3 = 50;
			dprint("s_objcon_e10_m3 = 50 ");
		end
end





///////////////////////////////////////////////
//  Hillside Down ObjCon
//////////////////////////////////////////////



script static void f_e10_m3_objcon_60()

	sleep_until ( b_e10_m3_get_artifact or s_objcon_e10_m3 >= 60, 1);
		if s_objcon_e10_m3 <= 60 then
			s_objcon_e10_m3 = 60;
			dprint("s_objcon_e10_m3 = 60 ");
		end
end

script static void f_e10_m3_objcon_70()

	sleep_until (volume_test_players (tv_e10_m3_objcon_15) or s_objcon_e10_m3 >= 70, 1);
		if s_objcon_e10_m3 <= 70 then
			s_objcon_e10_m3 = 70;
			dprint("s_objcon_e10_m3 = 70 ");
		end
end

script static void f_e10_m3_objcon_80()

	sleep_until (volume_test_players (tv_e10_m3_objcon_20) or s_objcon_e10_m3 >= 80, 1);
		if s_objcon_e10_m3 <= 80 then
			s_objcon_e10_m3 = 80;
			dprint("s_objcon_e10_m3 = 80 ");
		end
end


script static void  f_e10_m3_objcon_90()

	sleep_until (volume_test_players (tv_e10_m3_objcon_30) or s_objcon_e10_m3 >= 90, 1);
		if s_objcon_e10_m3 <= 90 then
			s_objcon_e10_m3 = 90;
			dprint("s_objcon_e10_m3 = 90 ");
		end
end

script static void  f_e10_m3_objcon_100()

	sleep_until (s_objcon_e10_m3 >= 100 , 1);
		if s_objcon_e10_m3 <= 100 then
			s_objcon_e10_m3 = 100;
			dprint("s_objcon_e10_m3 = 100 ");
		end
end

script static void  f_e10_m3_objcon_110()

	sleep_until (volume_test_players (tv_e10_m3_objcon_40) or s_objcon_e10_m3 >= 110 , 1);
		if s_objcon_e10_m3 <= 110 then
			s_objcon_e10_m3 = 110;
			dprint("s_objcon_e10_m3 = 110 ");
		end
end


script command_script cs_e10_m3_phantom_blow()


	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 3);
	
	//cs_fly_by (ps_e10_m3_phantoms.p0);
	cs_fly_by (ps_e10_m3_phantoms.p1);
	cs_fly_by (ps_e10_m3_phantoms.p2);
	
	damage_objects (ai_vehicle_get(ai_current_actor), "body", 100000);		
	damage_objects (ai_vehicle_get(ai_current_actor), "default", 100000);	
	damage_objects (ai_vehicle_get(ai_current_actor), "hull", 100000);	
end

script command_script cs_e10_m3_phantom_artifact()


	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30 * 5);
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_2.driver), "dual", sq_e10_3_hs_grunts_2, sq_e10_3_hs_grunts_1,NONE, none);	
	//cs_fly_by (ps_e10_m3_phantoms.p0);

	cs_fly_by (ps_e10_m3_phantoms.p8);

	cs_vehicle_speed (0.5);
	cs_fly_by (ps_e10_m3_phantoms.p4);	
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e10_m3_phantoms.p3, ps_e10_m3_phantoms.p5,0.25 );
	local long l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e10_me_cov_phantom_2.driver), "dual"));	
	cs_vehicle_speed (0.5);
	sleep_until(not isthreadvalid(l_drop_1), 1);
		ai_set_objective( sq_e10_3_hs_grunts_1, e10_m3_theark_obj);
		ai_set_objective( sq_e10_3_hs_grunts_2, e10_m3_theark_obj);
		cs_vehicle_speed (1.0);
		cs_fly_by (ps_e10_m3_phantoms.p0);
		//cs_vehicle_speed (1);

		//cs_fly_by (ps_e10_m3_phantoms.p8);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e10_m3_phantoms.p7);
		sleep_s(5);
	
		ai_erase (sq_e10_me_cov_phantom_2);

end
//ai_advance_immediate(sq_e3_knight_ranger);

script static short bah()
	f_ability_player_cnt('objects\equipment\storm_jet_pack\storm_jet_pack.equipment') ;
end

script static void bar()

	b_e10_m3_lich_dead = TRUE;
	ai_place(sg_e10_m3_fore_bowl);
end

script static void bust()
			ai_place_in_limbo (sg_e10_m3_hillside_up_reinforce);
			thread (f_dlc_load_drop_pod (dm_e10_m3_hillside_door, sg_e10_m3_hillside_up_reinforce, NONE,obj_drop_pod_4));
end

script static void hate()

		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_2,sq_e10_m3_turrets_2, cr_e10_m2_core_2) );
		sleep(15);
		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_1,NONE, cr_e10_m2_core_3));
		sleep(30);
		thread( e10_m3_fore_defense_activate( dm_e10_m3_ap_3,NONE, cr_e10_m2_core_4));
end