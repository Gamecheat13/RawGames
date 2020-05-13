//// =============================================================================================================================
//========= CAVERNS E6_M3 RECON FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

global boolean b_e6_m3_exterior_alarm = FALSE;
global boolean b_e6_m3_interior_alarm = FALSE;
global object g_e6m3_sleepy_grunt = NONE;
global boolean b_e6_m3_airstrike_avail = TRUE;
global boolean b_e6_m3_force_start = FALSE;
global boolean b_e6_m3_ext_intro_done = FALSE;
global boolean b_e6_m3_airstrike_fired = FALSE;
global boolean b_e6_m3_airstrike_complete = FALSE;
global boolean b_e6m3_phantom_drop_1_done = FALSE;
global boolean b_e6_m3_cavern_exit_open = FALSE;


/*
script startup e6_m3_caverns_recon()

	dprint("CAVERNS");
	sleep_until( LevelEventStatus("e6_m3") or b_e6_m3_force_start,1 );
		dprint("BEGIN::::: e6 m3 Caverns Recon");
		switch_zone_set("e6_m3_ext_1");
		ai_ff_all = sg_e6_m3_all;


		thread( e6_m3_caverns_setup_main() );

		b_end_player_goal = FALSE;
end
*/


script startup f_e6_m3_startup()
	

	//Wait for start
	if ( f_spops_mission_startup_wait("e6_m3") or b_e6_m3_force_start ) then
	
		dprint( "---------f_e6_m3_startup-----------" );
		wake( f_e6_m3_init );
		
	end
	
end

script static void debug_e10_m3()

	game_set_variant( e10_m3_hillside_blitzkrieg );
end

script dormant f_e6_m3_init()
	f_spops_mission_setup( "e6_m3", "e6_m3_ext_1", sg_e6_m3_all, e6_m3_start_locs, 91 );
		dprint("BEGIN::::: e6 m3 hillside blitzkrieg");


	f_spops_mission_intro_complete( TRUE );
	thread( e6_m3_caverns_setup_main() );

	b_end_player_goal = FALSE;
end

script static short e6_m3_enemy_count()
	ai_living_count( sg_e6_m3_all );
end

script static void debug_e6_m3()

	game_set_variant( e6_m3_caverns_recon );
end



script static void f_zone_num()
	inspect(current_zone_set_fully_active());
end



script static void e6_m3_caverns_setup_main()

		dprint("setup main");
		e6_m3_caverns_creation();
		//sleep(5); 
		wake( e6_m3_caverns_streaming );
		
		//f_add_crate_folder( e6_m3_start_locs );
		//firefight_mode_set_crate_folder_at( e6_m3_start_locs, 91);	

			
		firefight_mode_set_objective_name_at(e6_m3_lz_0 ,51); 
		firefight_mode_set_objective_name_at(e6_m3_lz_1 ,52);		
		firefight_mode_set_squad_at(sg_e6_m3_exterior_intro, 20);
		firefight_mode_set_squad_at(sg_e6_m3_interior_zealots_1, 21);
		thread( e6_m3_remove_other_timeline_items () );
		f_spops_mission_setup_complete( TRUE );
		dm_droppod_4 = dm_e6_m3_water_drop;
		sleep(5);
		wake( e6_m3_caverns_ext_intro_setup ); 
		wake( e6_m3_caverns_interior_setup );
		wake( e6_m3_caverns_ext_outro_setup );
		wake( e6_m3_caverns_exterior_intro_spawns ); 
		wake( e6_m3_caverns_exterior_intro_status );
		wake( e6_m3_caverns_events );
		thread( e6_m3_barrier_objective() );

		
		
		//dm_e6_m3_water_drop;
end

script static void e6_m3_caverns_creation()
	f_add_crate_folder( crs_e6_m3_ext_1 ); 
	f_add_crate_folder( dcs_e6_m3 );
	f_add_crate_folder( eq_e6_m3 );
	f_add_crate_folder( e6_m3_scenery );
	//f_add_crate_folder( dms_e6_m3 );	
	
		
		sleep(1);
		//object_set_physics (e6_m3_cov_base_01, FALSE);
		//object_set_physics (e6_m3_cov_base_02, FALSE);
		object_create(e6_m3_cov_base_02);
		object_create(e6_m3_cov_base_01);
		object_destroy( cr_ff153_caverns_bridge_b );
		object_destroy( cr_ff153_caverns_bridge_a );
		//object_create(cr_e6_m3_pod_top_1);
		//object_create(cr_e6_m3_pod_top_2);
		object_cannot_take_damage(cr_e6_m3_pod_top_1);
		object_cannot_take_damage(cr_e6_m3_pod_top_2);
		object_move_to_point( cr_e6_m3_pod_top_1, 0, ps_e6m3_main.pod1);
		object_move_to_point( cr_e6_m3_pod_top_2, 0, ps_e6m3_main.pod2);
		sleep(1);
		object_set_physics (e6_m3_cov_base_01, TRUE);
		object_set_physics (e6_m3_cov_base_02, TRUE);
end

script static void e6_m3_remove_other_timeline_items()

	if object_valid( e10_m2_base_1 ) then
		object_destroy(e10_m2_base_1);
	end
	
	if object_valid( 	e10_m2_base_2 ) then
		object_destroy(e10_m2_base_2);
		
	end
	
	if object_valid( 	e10_m2_base_3 ) then
		object_destroy(e10_m2_base_3);
	end
	
	if object_valid( 	e10_m2_pod_1 ) then
		object_destroy(e10_m2_pod_1);
	end
	
	if object_valid( 	e10_m2_pod_2 ) then
		object_destroy(e10_m2_pod_2);
	end
	
	if object_valid( 	e10_m2_pod_3 ) then
		object_destroy(e10_m2_pod_3);
	end


	if object_valid( 	e8m3_base_1 ) then
		object_destroy(e8m3_base_1);
	end
	
	if object_valid( 	e8m3_pod_1 ) then
		object_destroy(e8m3_pod_1);
	end
end
script dormant e6_m3_caverns_ext_intro_setup()


	//object_hide(cr_e6_m3_pod_top_1,TRUE);
	thread( f_moving_cruiser() );	
	sleep_s(1);
	object_set_phantom_power(e6_m3_cov_base_01, false);
	object_set_phantom_power(e6_m3_cov_base_02, false);
end

script dormant e6_m3_caverns_exterior_intro_spawns()	
	pup_play_show( pup_e6_m3_elite_comp );
	//firefight_mode_set_squad_at(sg_e6_m3_exterior_intro, 20);
	sleep_until( ( ai_spawn_count(sg_e6_m3_exterior_intro) > 0 and ai_living_count(sg_e6_m3_exterior_intro)<= 4 )   , 1);
		dprint("placing exterior reinforcements");
			
		ai_place_in_limbo (sg_e6_m3_exterior_reinforce);
		thread (f_dlc_load_drop_pod (dm_e6_m3_water_drop, sg_e6_m3_exterior_reinforce, NONE,obj_drop_pod_4));
		//f_dlc_load_drop_pod (object_name dm_drop, ai squad, ai squad2, object_name pod)

		b_e6_m3_ext_intro_done = TRUE;
	sleep_until( ( ai_spawn_count(sg_e6_m3_exterior_all) > 0 and ai_living_count(sg_e6_m3_exterior_all) <= 5 ) , 1);
		f_blip_ai_cui( sg_e6_m3_exterior_all, "navpoint_enemy" );
end

script dormant e6_m3_caverns_events()
	dprint("============");
		wake(e6_m3_caverns_e6_m3_surprise);
    wake( e6_m3_caverns_barrier );                      	                                                                                                                                                                                                             

end

script dormant e6_m3_caverns_barrier()

		sleep_until( volume_test_players( tv_e6_m3_enter_gameplay ) ,1 );
			//dprint("skippy is better than jiff");
			object_create( cr_e6_m3_path_barrier );
			sleep(1);
			object_cannot_take_damage (cr_e6_m3_path_barrier );
			ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e4_m4.scenery", 
			"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
    	thread( e6_m3_airstrike_wait());                                                                                                                                                                                                                                   

end

script dormant e6_m3_caverns_e6_m3_surprise()

		sleep_until( LevelEventStatus("e6_m3_surprise") ,1 );
				dprint("setup surprise");
		    b_wait_for_narrative_hud = TRUE;                                                                                                                                                                                                                                  

end

script static void e6_m3_barrier_objective()

	sleep_until( b_e6_m3_ext_intro_done , 1);  //or volume_test_players(tv_e6_m3_barrier_comp)
		sleep_rand_s( 8,10);
		device_set_power( dc_e6_m3_barrier_comp, 1 );
		f_blip_object(dc_e6_m3_barrier_comp , "activate");
		thread (story_blurb_add("other", "Get us access to a terminal and perhaps we can bring the door down."));
	sleep_until( device_get_position(dc_e6_m3_barrier_comp) > 0.0, 1);
		f_unblip_object(dc_e6_m3_barrier_comp );
		sleep(15);
		device_set_power( dc_e6_m3_barrier_comp, 0 );
		sleep_s(2);
		if ai_living_count(sg_e6_m3_exterior_all) > 0 then
			
			thread (story_blurb_add("other", "Hold out for a little longer while we figure out how to bring down the barrier."));
		end
		local long l_timer = timer_stamp( 120 ); 

	sleep_until( timer_expired(l_timer) or ai_living_count(sg_e6_m3_exterior_all) <= 0, 1 ); 
			sleep_s(3.5);
			thread (story_blurb_add("other", "Barriers down. We should have access now. Proceed with caution."));
			object_destroy( cr_e6_m3_path_barrier );
			sleep_s( 1 );
			f_blip_flag( flg_e6_m3_enter_cave, "default");
	sleep_until( volume_test_players(tv_e6_m3_cave_enter) , 1 );
			f_unblip_flag( flg_e6_m3_enter_cave );
			
	//flg_e6_m3_enter_cave

end

global boolean b_e6m3_test_airstrike = FALSE;


script static void e6_m3_airstrike_wait()
	sleep_until( ( device_get_position(dc_e6_m3_airstrike_comp) > 0.0 and b_e6_m3_airstrike_avail ) or b_e6m3_test_airstrike, 1);
		b_e6_m3_airstrike_fired = TRUE;
		sleep_s(1);
		thread (story_blurb_add("other", "Looks like you just called in an covenant airstrike on your position. I suggest you take cover"));
		sleep_s(5);
		thread( f_tj_special(flg_e6_m3_airstrike_1) );
		sleep(5);
		thread( f_tj_special(flg_e6_m3_airstrike_2) );
		sleep(5);
		thread( f_tj_special(flg_e6_m3_airstrike_3) );
		sleep(15);
		thread( f_tj_special(flg_e6_m3_airstrike_4) );
		sleep(5);
		thread( f_tj_special(flg_e6_m3_airstrike_5) );
		sleep(5);
		thread( f_tj_special(flg_e6_m3_airstrike_6) );				
		sleep(15);
		thread( f_tj_special(flg_e6_m3_airstrike_7) );
		sleep(30);
		b_e6_m3_airstrike_complete = TRUE;
end


script static void f_tj_special (cutscene_flag flag)
  //print ("shake start");
  thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
  ordnance_drop (flag, "default");
  sleep(38);
  effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
  damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
  print ("EXPLOSION");
end

//



script static void f_moving_cruiser()
	sleep_until( object_valid( sc_e6_m3_cruiser_ext ) , 1);
		object_move_to_point(sc_e6_m3_cruiser_ext, 100, ps_e6m3_main.cruiser_1);
	sleep_until( device_get_position(dc_e6_m3_int_term_03) > 0, 1);
		object_move_to_point(sc_e6_m3_cruiser_ext, 75, ps_e6m3_main.cruiser_2);
end



script dormant e6_m3_caverns_exterior_intro_status()
	sleep_until( f_ai_is_aggressive( sg_e6_m3_exterior_all ) or b_e6_m3_exterior_alarm or b_e6_m3_airstrike_fired, 1);
	
	
/*	
		repeat 
			f_e6_m3_alert( sg_e6_m3_exterior_intro );
			sleep(5);
		until ( b_e6_m3_exterior_alarm,1 );
*/

		//f_ai_is_aggressive( sg_e6_m3_exterior_intro );
		print("ALARM!!!!!");
		ai_set_blind (sg_e6_m3_exterior_sleep_grunt, FALSE);
		b_e6_m3_exterior_alarm = TRUE;
		sleep_s(2);

		b_e6_m3_airstrike_avail = FALSE;
		device_set_power( dc_e6_m3_airstrike_comp, 0 );
		if device_get_position( dc_e6_m3_airstrike_comp ) == 0 then
			thread (story_blurb_add("other", "I'm reading an alarm signal. They know you're there.  Prepare for a fight."));
		end		
end



script static boolean f_e6_m3_alert(ai group)

	local object_list l_alert_list = ai_actors (group);
	local short s_list_index = 0;
	local boolean b_alert = FALSE;
	repeat
		//inspect( list_count(l_alert_list));
		//inspect( ai_combat_status(object_get_ai(list_get (l_alert_list, s_list_index))));
			if ( object_get_health (list_get (l_alert_list, s_list_index) )> 0   and ai_combat_status(object_get_ai(list_get (l_alert_list, s_list_index))) > ai_combat_status_definite  )then //and  f_ai_is_aggressive( object_get_ai(list_get (l_alert_list, s_list_index)))  ) then
			//if ( object_get_health (sq_e6_m3_ext_elites_1 )> 0  and f_ai_is_aggressive(sq_e6_m3_ext_elites_1)) then
				//f_blip_object (list_get (l_alert_list, s_list_index), blip_type);
				dprint("========== yep ALARM ================");
				b_alert = TRUE;
		//	else
				//dprint("nope");
				b_e6_m3_exterior_alarm = TRUE;
			end
			
			s_list_index = s_list_index + 1;
	until ( s_list_index >= list_count (l_alert_list), 1);


	b_alert;
end

global boolean b_e6_m3_setting_sleep = FALSE;
script command_script cs_e6_m3_sleepy_grunt()
	sleep_until( ai_in_limbo_count(	ai_current_actor ) <= 0 ,1);
		sleep_until( b_e6_m3_setting_sleep == FALSE, 1);
			b_e6_m3_setting_sleep = TRUE;
		g_e6m3_sleepy_grunt = ai_current_actor;
		pup_play_show( pup_e6_m3_sleep_gruntly );
		sleep(1);
		b_e6_m3_setting_sleep = FALSE;
		ai_set_blind (ai_current_actor, TRUE);
end



////////////////////////////////////////////////////
//	INTERIOR
////////////////////////////////////////////////////

global boolean b_e6_m3_debug_interior = FALSE;

script static void debug_interior_e6m3()
	switch_zone_set("e6_m3_int_1");
	sleep(15);
	b_e6_m3_debug_interior = TRUE;
	wake(e6_m3_caverns_interior_setup);
end

script dormant e6_m3_caverns_interior_setup()

	sleep_until(volume_test_players( start_e6_m3_int_1 ) or b_e6_m3_debug_interior,1);
		b_end_player_goal = true;
		dprint("cross fingers");
		ai_place_in_limbo( sq_e6_m3_int_zealot_surprise );
		//ai_place( sg_e6_m3_interior_zealots_1 );
		wake( e6_m3_caverns_interior_objectives );
		object_create_folder( crs_e6_m3_int_1 );
		object_create_folder( dms_e6_m3_int );
		
end


script dormant e6_m3_caverns_interior_status()
	sleep_until( f_ai_is_aggressive( sg_e6_m3_interior_all ) or b_e6_m3_interior_alarm, 1);
		
		
		print("INTERIOR ALARM!!!!!");
		b_e6_m3_interior_alarm = TRUE;
		
end

script dormant e6_m3_caverns_interior_objectives()

	sleep_until(volume_test_players( tv_e6_m3_side_enter_main ),1);	
			thread (story_blurb_add("other", "You're going to have to do some recon. Try and find a terminal where we can get some info."));
			 local long l_timer = timer_stamp( 120 ); 
			 f_blip_flag( flg_e6_m3_cave_rear, "recon" );
	sleep_until( volume_test_players( tv_e6_m3_area_int_term_02 ) or timer_expired( l_timer ) , 1);
			f_unblip_flag( flg_e6_m3_cave_rear);
			thread (story_blurb_add("other", "Get to that terminal."));
			sleep_s(1);
			f_blip_flag( flg_e6_m3_terminal_2, "activate" );
	sleep_until( device_get_position(dc_e6_m3_int_term_02) > 0 , 1 );
			device_set_position(dm_e10_m3_bridge, 1);	
			f_unblip_flag( flg_e6_m3_terminal_2 );
			//object_create( cr_e6_m3_light_bridge_2 );
			//object_create( cr_e6_m3_light_bridge_1 );
			object_create( cr_ff153_caverns_bridge_b  );
			object_create( cr_ff153_caverns_bridge_a  );
			sleep_s(2);
			ai_place(sg_e6_m3_interior_fore);
			thread (story_blurb_add("other", "Getting location of SPECIAL THING we are looking for. We need to get power to the hardlight system. Hold Tight."));
			sleep_s(8);
			//spawn dudes
			thread (story_blurb_add("other", "Head to this loc it will lead us to our goal."));
			f_blip_flag( flg_e6_m3_cave_upper_ramp, "default" );
	sleep_until(volume_test_players( tv_e6_m3_cavern_upper_big ),1);
			f_unblip_flag( flg_e6_m3_cave_upper_ramp);
	sleep_until(objects_distance_to_object(Players(),dc_e6_m3_int_term_03) <= 20.00, 1);					
			f_blip_flag( flg_e6_m3_terminal_3, "activate" );
	sleep_until( device_get_position(dc_e6_m3_int_term_03) > 0 , 1 );		
			f_unblip_flag( flg_e6_m3_terminal_3 );	
			device_set_position(dm_e10_m3_goal, 1);
			sleep_s(10);
			dprint("GTFO");
			f_blip_flag( flg_e6_m3_main_tunnel_exit, "default" );
	sleep_until(volume_test_players( tv_e6_m3_cavern_main_exit ),1);
		f_unblip_flag( flg_e6_m3_main_tunnel_exit);
		device_set_power(dc_e6_m3_main_door , 1);
		f_blip_object( dc_e6_m3_main_door, "activate" );
	sleep_until( device_get_position(dc_e6_m3_main_door) > 0 , 1 );
		ai_kill(sg_e6_m3_interior_all);
		device_set_power(cavern_front_door, 1);
		device_set_position(cavern_front_door, 1);
		device_set_position(dm_e10_m3_exit, 1);
		b_e6_m3_cavern_exit_open = TRUE;
		f_unblip_object( dc_e6_m3_main_door);

	//
end


////////////////////////////////////////////////////
//	EXTERIOR 2
////////////////////////////////////////////////////

script dormant e6_m3_caverns_ext_outro_setup()

	sleep_until(b_e6_m3_cavern_exit_open,1);	
		//object_set_phantom_power(e6_m3_cov_base_01, TRUE );
		//object_set_phantom_power(e6_m3_cov_base_02, TRUE );	
		
		wake( e6_m3_caverns_ext_outro_objectives );
end

script dormant e6_m3_caverns_ext_outro_objectives()

	sleep_until( b_e6_m3_cavern_exit_open ,1);	
		ai_place( sq_e6_m3_phantom_01 );
		sleep_s(3);
		dprint("==== start exterior 2 ===");
		thread (story_blurb_add("other", "Extraction on the way at this location.  Make sure lz is clear. We don't want them witnessing our super secret phantom"));		
		
		//sleep_s(5);
		//f_blip_flag( flg_e6_m3_extraction, "defend" );
		//door opens
		//hold out for extraction
		sleep_s(15);
		sleep_until(ai_living_count(sg_e6_m3_exterior_2_all) + ai_living_count(sg_e6_m3_exterior_reinforce) <= 5);
			f_blip_ai_cui( sg_e6_m3_exterior_2_all, "navpoint_enemy" );
			f_blip_ai_cui( sg_e6_m3_exterior_reinforce, "navpoint_enemy" );
		sleep_until(ai_living_count(sg_e6_m3_exterior_2_all) <= 0 and ai_living_count(sg_e6_m3_exterior_reinforce) <= 0, 1);
			sleep_s(5);
			f_e6_m3_win();
end


/////////////////////////////////////////
//	DESIGNER ZONE SWITCH
/////////////////////////////////////////
script dormant e6_m3_caverns_streaming()

	sleep_until(volume_test_players( start_e6_m3_int_1 ),1);
		//thread( zoneset_prepare( 3, TRUE) );
	sleep_until(volume_test_players( load_e6_m3_int_1 ),1);
		//thread( zoneset_load( 3, TRUE ) );
		switch_zone_set("e6_m3_int_1");
	sleep_until(  b_e6_m3_cavern_exit_open ,1);		
		switch_zone_set("e6_m3_ext_1");
		
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


script command_script cs_e6_m3_camo_special()

	
	sleep_until(volume_test_players(tv_e6_m3_surprise),1);
		ai_exit_limbo(ai_current_actor);
		ai_set_active_camo( ai_current_actor, TRUE );
		thread( f_e6_m3_flash_camo( ai_current_actor ) );
		cs_move_towards_point ( ps_e6m3_main.p0 , 1.0);
		cs_move_towards_point ( ps_e6m3_main.p1 , 1.0);
		cs_move_towards_point ( ps_e6m3_main.p2 , 1.0);
		cs_move_towards_point ( ps_e6m3_main.p3 , 1.0);
		cs_move_towards_point ( ps_e6m3_main.p4 , 1.0);
		cs_move_towards_point ( ps_e6m3_main.p5 , 1.0);
		cs_move_towards_point ( ps_e6m3_main.p6 , 1.0);
	thread( f_active_camo_manager(ai_current_actor) );
end

script static void f_e6_m3_flash_camo(ai ai_actor)
		sleep_s(1.0);
		ai_set_active_camo( ai_actor, FALSE );
		sleep_s(1.5);
		ai_set_active_camo( ai_actor, TRUE );
end

script static void f_e6_m3_win()

	b_end_player_goal = true;
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end




script static void OnCompleteProtoSpawn()
	dprint("bishop spawned");
	//b_arcade_birth_done = true;
end

script command_script cs_bishop_spawn()
        print("bishop sleeping");
        //ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
end

script command_script cs_e6_m3_phantom_drop()
	dprint("phantom droop");
	local long l_drop_1 = -1;
	local long l_drop_2 = -1;
	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 0 );

	//// watchtower pod cargo
	object_hide(cr_e6_m3_pod_top_1,false);
	object_set_scale( cr_e6_m3_pod_top_1, 0.8, 0 );
	//object_create(cr_e6_m3_pod_top_1);
	object_cannot_take_damage (cr_e6_m3_pod_top_1);
	object_set_physics(cr_e6_m3_pod_top_1, FALSE);
	objects_attach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver) ,"fx_destroyed_phantom", cr_e6_m3_pod_top_1,"lift_up_biped" );
	
	
	//add ai
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver), "dual", sq_e6_m3_ext_re_elite_2, sq_e6m3_phantom_grunts,sq_e6m3_phantom_snipers, none);

	cs_fly_by (ps_e6m3_phantoms.p7);
	cs_fly_by (ps_e6m3_phantoms.p6);
	cs_vehicle_speed (0.75);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p0, ps_e6m3_phantoms.p1,1.5 );
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p0, ps_e6m3_phantoms.p1,0.25 );
	//
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver), "dual"));

	dprint("settle");
	object_set_phantom_power(e6_m3_cov_base_01, TRUE );	
	sleep_s( 1.5 );	
	object_set_physics (cr_e6_m3_pod_top_1, TRUE);
	objects_detach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver),cr_e6_m3_pod_top_1);
	object_set_scale( cr_e6_m3_pod_top_1, 0.93, 90 );
	sleep_s( 3 );
	object_set_scale( cr_e6_m3_pod_top_1, 1, 60 );
	sleep_until(not isthreadvalid(l_drop_1), 1);
		object_can_take_damage (cr_e6_m3_pod_top_1);
		cs_vehicle_speed (0.5);
		cs_fly_by (ps_e6m3_phantoms.p2);
		cs_vehicle_speed (1);
		b_e6m3_phantom_drop_1_done = TRUE;
		cs_fly_by (ps_e6m3_phantoms.p3);
		cs_fly_by (ps_e6m3_phantoms.p4);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e6m3_phantoms.p5);
		sleep_s(5);
	
		ai_erase (sq_e6_m3_phantom_01);
end

script command_script cs_e6_m3_phantom_drop_int_1()
	dprint("phantom droop");
	local long l_drop_1 = -1;

	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30*5);
	//// watchtower pod cargo
	object_create(veh_e6_m3_shade_1);
	sleep(1);
	objects_attach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver) ,"fx_destroyed_phantom", veh_e6_m3_shade_1,"garbage1" );
	
	//add ai
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), "dual", sq_e6_m3_ext_re_elite_2, sq_e6m3_phantom_grunts,sq_e6m3_phantom_snipers, none);

	cs_fly_by (ps_e6m3_phantoms.p8);
	cs_fly_by (ps_e6m3_phantoms.p9);
	cs_vehicle_speed (0.75);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p9, ps_e6m3_phantoms.p1,10 );
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p9, ps_e6m3_phantoms.p11,0.25 );
	//
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), "dual"));

	sleep_s(2);
	objects_detach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver),veh_e6_m3_shade_1);
	sleep(1);
	object_move_to_point(veh_e6_m3_shade_1, 0.75, ps_e6m3_phantoms.pturret);
	sleep_until(not isthreadvalid(l_drop_1), 1);

		cs_vehicle_speed (0.5);
		cs_fly_by (ps_e6m3_phantoms.p11);
		cs_vehicle_speed (1);

		cs_fly_by (ps_e6m3_phantoms.p8);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e6m3_phantoms.p12);
		sleep_s(5);
	
		ai_erase (sq_e6_m3_phantom_01_int);
end

script command_script cs_e6_m3_phantom_drop_boo()
	dprint("phantom droop");
	local long l_drop_1 = -1;
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30*5);



	sleep(1);
	//ai_vehicle_enter(sq_e6m3_phantom_grunts_2,veh_e6_m3_shade_2 );
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_boo.driver), "dual", sq_e6m3_phantom_grunts_2,none,none, none);


	cs_fly_by (ps_e6m3_phantoms.p2);
	//cs_fly_by (ps_e6m3_phantoms.p13);
	cs_vehicle_speed (0.75);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p14, ps_e6m3_phantoms.p13,10 );
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p14, ps_e6m3_phantoms.p13,0.25 );
	
	cs_face(TRUE,ps_e6m3_phantoms.p13);
	//ai_set_blind(ai_current_actor, TRUE);
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_boo.driver), "dual"));
	sleep_until(not isthreadvalid(l_drop_1), 1);
	//sleep(90);
		cs_vehicle_speed (0.25);
		cs_fly_by (ps_e6m3_phantoms.p2);
		ai_set_blind(ai_current_actor, FALSE);
		cs_vehicle_speed (0.4);
		cs_fly_by (ps_e6m3_phantoms.p3);
		cs_vehicle_speed (1);
		cs_face(FALSE,ps_e6m3_phantoms.p13);
		cs_fly_by (ps_e6m3_phantoms.p4);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e6m3_phantoms.p5);
		sleep_s(5);
	
		ai_erase (sq_e6_m3_phantom_boo);

end

script command_script cs_knight_rider()

	dprint("knight cs");
	cs_phase_in();

end

script static void meh()
	ai_place_in_limbo(sg_e6_m3_interior_fore);
	sleep(15);
	ai_place_with_birth(sq_e6_m3_int_bishop_1);
	ai_place_with_birth(sq_e6_m3_int_bishop_2);
	ai_place_with_birth(sq_e6_m3_int_bishop_3);
	ai_place_with_birth(sq_e6_m3_int_bishop_4);
	ai_place_with_birth(sq_e6_m3_int_bishop_5);
	ai_place_with_birth(sq_e6_m3_int_bishop_6);
	ai_place_with_birth(sq_e6_m3_int_bishop_7);
end

/*
global object_name dm_droppod_1 = dm_drop_01;
global object_name dm_droppod_2 = dm_drop_02;
global object_name dm_droppod_3 = dm_drop_03;
global object_name dm_droppod_4 = dm_drop_04;
global object_name dm_droppod_5 = dm_drop_05;
*/

//ai_advance_immediate(sq_e3_knight_ranger);