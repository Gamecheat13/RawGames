//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice
//	Insertion Points:Coldant
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short composer_core_count = 2;
global boolean b_cold_left_core_active = TRUE;
global boolean b_cold_right_core_active = TRUE;
global boolean b_cold_outside_shield_active = TRUE;
global boolean b_cold_inside_shield_active = TRUE;
global boolean b_cold_mancs_active = FALSE;
global boolean b_coldant_active = FALSE;
global boolean b_coldant_gameplay_active = FALSE;
global boolean b_coldant_complete = FALSE;
global short s_cold_shield_pieces = 2;
global short s_objcon_cold_left = 0;
global short s_objcon_cold_right = 0;
global boolean b_coldant_pier_active = FALSE;
global boolean b_coldant_composer_fire = FALSE;
global object g_ics_player = NONE;
global device g_ics_plinth2 = NONE;
global device g_ics_plinth3 = NONE;
global boolean b_debug_skip_intro = FALSE;
global boolean b_cold_main_plinth_ready = FALSE;
global boolean b_cold_left_plinth_ready = FALSE;
global boolean b_cold_right_plinth_ready = FALSE;
global boolean b_cold_left_plinth_blip = FALSE;
global boolean b_cold_right_plinth_blip = FALSE;
global boolean b_cold_right_ascend = FALSE;
global boolean b_cold_left_ascend = FALSE;
global boolean b_cold_main_plinth_finished = FALSE;
global boolean b_cold_main_plinth_shard_done = FALSE;
// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m90_coldant()		

	wake ( f_coldant_starter );	
end

script dormant f_coldant_starter()
	local long l_cold_intro_pup = -1;
	sleep_until( b_walls_complete , 4 );
	sleep_until (volume_test_players( tv_coldant_init ),1);	
		thread (fx_didact_back_glow());
		data_mine_set_mission_segment ("m90_coldant");
		dprint (":: Coldant Start ::");
		garbage_collect_now();
		f_jump_cleanup_eye_ap();
		wake( nar_coldant_init );
		//thread( f_cold_shield_kill());
		zone_set_trigger_volume_enable( "zone_set:final", FALSE);
		set_broadsword_respawns ( false );	
		f_m90_loadout_set( 2 );  //power weapons
		garbage_collect_now();
		sleep(1);
		object_create_folder( crs_composer);
		object_create_folder( crs_comp_weapons);
		object_create_folder( crs_jump_comp_weapons);
		//object_create_folder( crs_comp_mc );
		object_create_folder( crs_comp_plinths );
		object_create(dc_comp_switch_front);
		object_create(dc_comp_switch_right);
		object_create(dc_comp_switch_left);
		object_create( comp_shield_octopus );
		object_create(dc_left_bridge);
		//object_destroy( maya_script_composer_shield_right );
		//object_destroy( maya_script_composer_shield_left );
		wake( f_jump_coldant_aa );
		//object_create( sn_coldant_didact_core );
		object_hide( maya_scripted_m90_composerbridge_crate, TRUE);
		//object_hide( didact_bridge, TRUE ); //Hide final light bridge sound scenery: AUDIO!
		object_destroy ( didact_bridge );
		//dprint ( "------------------------- DIDACT BRIDGE IS OFF! ----------------------------" );
		b_coldant_gameplay_active = TRUE;
		sleep(5);
		device_set_power ( dc_comp_switch_front, 0 );
		device_set_power ( dc_comp_switch_right, 0 );
		device_set_power ( dc_comp_switch_left, 0 );
		thread( f_cold_composer_cloud() );
		wake (f_comp_door_control);
		wake ( f_cold_intro_nar );
		b_coldant_active = TRUE;		

		wake( f_cold_didact_pup );
		thread( f_composer_init_coldant() );
		//object_create(sn_cold_finale_earth);
		//object_create( dc_comp_switch_front );
		wake( f_coldant_platforms );
		if not object_valid( f_cold_front_door ) then
			object_create( f_cold_front_door );
		end
		//wake ( f_cold_timmy_d );
//		wake( f_cold_setup_left_bridge );
		wake( f_cold_plinth_init );
		sleep(1);


	sleep_until ( b_cold_intro_done , 1 );
	//sleep_until (volume_test_players(tv_comp_raise_plinth),1);
	
//		thread( f_jump_clear_super_jump_clamps() );
		pup_stop_show(g_jump_show1);
		pup_stop_show(g_jump_show2);
		pup_stop_show(g_jump_show3);
		pup_stop_show(g_jump_show4);
		//volume_teleport_players_not_inside ( tv_cold_main, flag_coldant_teleport_in );
		f_m90_game_save_no_timeout();
		f_m90_set_normal_g();	
		//wake ( f_jump_cleanup_harvestors );
		//wake( f_jump_tube_cleanup );
		//thread( nar_coldant_switch() );		
		thread(f_comp_close_door_safe());
		dprint ("waiting for door trigger to be hit");
		sleep_until (volume_test_players (tv_coldant_door_close), 1);
		dprint ("door trigger hit");
		sleep(1);
		zone_set_trigger_volume_enable( "zone_set:final", TRUE);
		sleep_until( object_valid ( cr_plinth_main ) and object_valid ( dc_comp_switch_front ) , 1 );
		dprint ("activating plinth");
		f_cold_activate_plinth( cr_plinth_main, dc_comp_switch_front, dc_comp_switch_front, false, true );
		dprint ("plinth should be activated");
		//sleep_s(3);
		f_unblip_flag ( flag_cold_didact );
		sleep( 5 );
		
		wake( f_coldant_pier_mc_effects );	
		

		device_set_power ( dc_comp_switch_front, 1 );			

		//sleep(20);
		

	
	sleep_until( device_get_position( dc_comp_switch_front ) > 0.0, 1 );
		device_set_power ( dc_comp_switch_front, 0 );
		sleep( 15 );
		b_cold_main_plinth_ready = TRUE;

		f_unblip_object ( dc_comp_switch_front );
		
		if not b_debug_skip_intro then
			//thread( nar_coldant_mancannons_on() );
			l_cold_intro_pup = pup_play_show( cortana_splinter1 );
		end
		
		
		f_unblip_flag ( flag_cold_didact );
		

	sleep_until(not pup_is_playing(l_cold_intro_pup), 1 );
		f_unblip_flag ( flag_cold_didact );
		sleep(30);
		g_composer_state = 2;
		wake ( f_plinth_sequence );
		
		wake ( f_coldant_left_spawn );
		wake ( f_coldant_right_spawn);
		wake ( f_coldant_pier_spawn );
		wake( f_cold_pier_top_save );
		wake( f_coldant_platforms_activate );
		wake( f_comp_cores_all_disabled );		
		b_cold_mancs_active = TRUE;
		wake( f_coldant_main_cannons_on );
		wake(m90_plinth_to_beam);

//Bridges are left in so the build a nav mesh
//Delete them if necessary
		if object_valid( cr_cold_bridge_left )then
			dprint("left bridge is there?");
			//sleep(10);
			object_destroy(cr_cold_bridge_left);
		end
		
		if object_valid( cr_cold_bridge_right )then
			dprint("right bridge is there?");
			//sleep(10);
			object_destroy(cr_cold_bridge_right);
		end
		
		
		//sleep (30 * 2);
		wake( f_coldant_update );

		sleep_s( 5 );
		f_cold_activate_plinth( cr_plinth_main, dc_comp_switch_front,dc_comp_switch_front, true, false );
		b_cold_main_plinth_ready = FALSE;
		//f_objective_set(r_index, b_new_msg, b_new_blip, b_complete_msg, b_complete_unblip )
		thread( f_objective_set( DEF_R_OBJECTIVE_DESTROY_SHIELDS, TRUE, FALSE, TRUE,TRUE ) );
		//object_destroy( sn_cold_cortana_main );
		//device_animate_position(  dm_plinth_main , 0.0 , 1, 0.1, 0.0, TRUE );
		sleep(1);
		garbage_collect_now();
		f_m90_game_save_no_timeout();
end

script static void f_cold_cleanup()
		sleep(2);
		dprint("COLDANT CLEANUP");
		b_coldant_complete = TRUE;
		f_cold_maelstrom_kill();
		object_destroy_folder( crs_composer);
		object_destroy_folder( crs_comp_weapons);
		object_destroy_folder( crs_jump_comp_weapons);
//		object_destroy_folder( crs_comp_mc );
		object_destroy_folder( crs_comp_plinths );
		object_destroy( f_cold_front_door );
//		object_destroy(cr_composer_beam_earth);


		object_destroy (dm_coldant_grav_push);
		object_destroy (dm_coldant_grav_lift);


end






global long l_didact_loop_pup = -1;
global boolean b_stop_didact_loop_pup = FALSE;

script dormant f_cold_didact_pup()
	l_didact_loop_pup = pup_play_show( pup_cold_composing_didact );
/*	sleep_until(b_stop_didact_loop_pup ,1);
		dprint("stopping didact looping");
		pup_stop_show( l_didact_loop_pup );
*/
end



global boolean b_cold_intro_done = FALSE;

script dormant f_cold_intro_nar()
	local real r_sound_time = 0;
	
	
	sleep_until (volume_test_players(tv_cold_start_diag_intro) ,1);
		//inspect( sound_impulse_time( 'sound\dialog\mission\m90\m90_eye_00100' ) );
	dprint("start nar intro");
				f_blip_flag ( flag_cold_main_end, "default");
				wake( f_cold_blip_ultimate_goal );
				f_m90_update_3_objectives();
				
				if not b_debug_skip_intro then
					nar_coldant_intro();
					sleep_s(8);
				end
				thread( f_objective_set( DEF_R_OBJECTIVE_CORTANA_IN, TRUE, FALSE, TRUE,TRUE ) );
				b_cold_intro_done = TRUE;	
end

script dormant f_cold_blip_ultimate_goal()

	
	sleep_until (volume_test_players(tv_cold_main_plinth) ,1);
				f_unblip_flag ( flag_cold_main_end);
				f_blip_flag ( flag_cold_didact, "default");
end

//dc_comp_switch_front
script static void f_cold_activate_plinth( object_name plinth, device control, object_name blip_object, boolean b_reverse,boolean b_activate )
//		device_animate_position(  dm , 0.90 , 1, 0.1, 0.0, TRUE );

//		sleep_until( device_get_position(  dm  ) >= 0.90 );
//			dprint("a");

	if b_reverse then
		device_set_power ( control, 0 );
		object_destroy(control);
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\amb_m90_dm_plinth_close', plinth, 1 ); //AUDIO!
		object_move_by_offset(plinth,1.0,0,0,-0.37 );


	else
		//object_move_by_offset(plinth,0.5,0,0,0.405 );
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\amb_m90_dm_plinth_open', plinth, 1 ); //AUDIO!
		object_move_by_offset(plinth,0.5,0,0,0.37 );
		sleep(3);
		sleep_until(not pup_is_playing(g_show_splinter2),1);
		if b_activate then
			device_set_power ( control, 1 );
			f_blip_object (  blip_object , "activate" );
		end
	end
end

script dormant f_cold_plinth_init()
	sleep_until( object_valid(cr_plinth_main) and object_valid(cr_plinth_left) and  object_valid(cr_plinth_right), 1);
		object_move_by_offset(cr_plinth_main,1.0,0,0,-0.37 );
		object_move_by_offset(cr_plinth_left,1.0,0,0,-0.37 );
		object_move_by_offset(cr_plinth_right,1.0,0,0,-0.37 );
end










// =================================================================================================
// =================================================================================================
// *** CORE SHIELDING ***
// =================================================================================================
// =================================================================================================
script static void f_comp_right_shield_fall()

//	object_move_by_offset ( maya_script_composer_shield_right, 7, 0, 0, -80 );
//	object_destroy(maya_script_composer_shield_right);
	//pup_play_show(pup_composer_shield_right);
	sleep(1);
end

script static void f_comp_left_shield_fall()
//	object_move_by_offset ( maya_script_composer_shield_left, 7, 0, 0, -80 );
//	object_destroy(maya_script_composer_shield_left);
	//pup_play_show(pup_composer_shield_left);
	sleep(1);
end









// =================================================================================================
// =================================================================================================
// *** LEFT PLATFORM ***
// =================================================================================================
// =================================================================================================

script static void debug_left_spawn()
	object_create(dc_left_bridge);
	object_destroy(cr_cold_bridge_left);
	object_create_folder( crs_composer );
	object_create_folder( crs_comp_weapons );
	wake( f_coldant_left_spawn );

end

script dormant f_coldant_left_spawn()
		sleep_until (volume_test_players(tv_land_left) or (volume_test_players(tv_land_left_2)),1);
			
			wake( f_cold_left_objcon );
			wake( f_cold_left_save_pre_tower );
			dprint("spawn sg_left");
			garbage_collect_now();
			ai_place ( sg_left );
			ai_place ( sg_left_bottle_neck );

			thread( f_mus_m90_e07_start() );	
			sleep(3);
			if object_valid( cr_cold_bridge_left )then
				dprint("left bridge is there?");
				//sleep(10);
				object_destroy(cr_cold_bridge_left);
			end
			wake( f_cold_left_spawn_bottom_bishop );
			sleep(1);
			f_m90_game_save_no_timeout();		
			//wake (f_left_play_save);
																																																																//if they jump the wall advance
		sleep_until(volume_test_players(tv_left_spawn_2nd_wave) or (ai_spawn_count(sg_left) > 0 and ai_living_count(sg_left) < 3) or volume_test_players(tv_cold_left_bridge));
				ai_place_in_limbo ( sg_left_2nd_wave );
			dprint("spawn left 2nd wave");
			//garbage_collect_now();
			wake( f_cold_left_save_room );
			sleep(5);
			f_m90_game_save();
																															//if they jump the wall advance
		sleep_until (volume_test_players(tv_cold_left_bridge) or volume_test_players( tv_cold_left_top_clear ),1);
			b_cold_left_ascend = TRUE;			
			thread( f_cold_left_bridge_press() );
			f_m90_game_save();
																									//if they jump the wall advance
		sleep_until( b_cold_left_bridge_activated or volume_test_players( tv_cold_left_top_clear ), 1 );	
			//sleep_rand_s(1,2);
			ai_place_in_limbo ( sg_left_ranger_1 );

			sleep_s(0.25);
			ai_place_in_limbo( sq_left_knight_top_res );			
			//garbage_collect_now();
			
	//sleep_until( volume_test_players( tv_cold_left_top ) );	
		//dprint("==== spawn command =====");	


	sleep_until( (ai_living_count( sg_left_ranger_1 ) <= 1 and ai_living_count( sq_left_command_res ) == 0 )or volume_test_players( tv_cold_left_top_mid ) );
			dprint("==== spawn bw =====");	
			sleep_s(2);
			ai_place_in_limbo (  sq_left_command_bw );
			//sleep_s(5);
	sleep_until( ai_living_count( sg_left_ranger_1 ) <= 0 or object_get_shield( ai_get_object( sq_left_command_bw ) ) <= 0.30 );

			if  (not  b_cold_right_core_active ) or ( game_is_cooperative() or difficulty_legendary() ) then
				dprint("==== spawn command =====");	
				ai_place_in_limbo ( sq_left_command_cmdr_bp );
				sleep(15);
				ai_place_with_birth( sq_left_command_bish );
			end
			
			sleep(60);
			b_cold_left_top_all_spawned = TRUE;
		
end

///ai_in_limbo_count

script dormant f_cold_left_spawn_bottom_bishop()

sleep_until( ai_living_count( sq_left_bw_1 ) == 0 or ai_living_count( sq_left_bw_2 ) == 0 );
	print("spawning mid fight bishop");
		ai_place_with_birth( sq_left_bottom_bishop );

end




script dormant f_cold_left_objcon()
		sleep_until (volume_test_players(tv_cold_left_objcon_20) ,1);
			if s_objcon_cold_left <= 20 then 
				s_objcon_cold_left = 20;
				dprint("s_objcon_cold_left = 20 ");
			end
end
 
script dormant f_cold_left_save_pre_tower()
		sleep_until (volume_test_players(tv_left_play_save_2) ,1);
			f_m90_game_save();
end 

script dormant f_cold_left_save_room()
		sleep_until (volume_test_players(tv_cold_left_room_save) ,1);
			f_m90_game_save();
end 

 
// =================================================================================================
// =================================================================================================
// *** RIGHT PLATFORM PAWNLANDIA ***
// =================================================================================================
// =================================================================================================

script static void debug_right_spawn()
	b_coldant_gameplay_active = TRUE;
	wake( f_coldant_right_spawn );
	object_create(dc_right_bridge);
	object_destroy(cr_cold_bridge_right);
end

script dormant f_coldant_right_spawn()

		sleep_until (volume_test_players(tv_land_right) or (volume_test_players(tv_land_right_2)),1);
			garbage_collect_now();
			thread( f_mus_m90_e05_start() );
			wake( f_coldant_right_bridge );
			wake( f_cold_tower_hammer );
			wake( f_cold_tower_setup );
			s_objcon_cold_right = 10;
			wake( f_cold_right_pawn_shard_bottom );
			sleep(1);
			wake( f_cold_right_pawn_culler );
			sleep(2);
			//ai_place ( sg_right );
			ai_place( sq_right_start_bishop );
			if object_valid( cr_cold_bridge_right )then
				dprint("make sure right bridge isn't there");
				//sleep(10);
				object_destroy(cr_cold_bridge_right);
			end			
			if  ( volume_test_players(tv_land_right) ) then
				ai_place( sq_right_pawn_intro.spawn_formations_1 );
			else
				ai_place( sq_right_pawn_intro.spawn_formations_0 );
			end
			
			ai_place( sq_right_start_bishop_2 );
			ai_place( sq_right_start_bishop_3 );
			wake( f_cold_right_save_room );
			wake( f_cold_right_save_intro );
			//ai_place_with_shards ( sq_right_pawns_left, 3 );
			sleep(3);
			
			//wake (f_right_play_save);	
			
			f_m90_game_save_no_timeout();	
		sleep_until( volume_test_players(tv_cold_right_center)  or ai_living_count(sq_right_pawn_intro) == 0 or ai_body_count(obj_right.main) > 0 or volume_test_players(tv_right_spawn_2nd_wave)  or volume_test_players(tv_cold_right_mid), 2 ); //
			dprint("sharding hallway");
			ai_place_with_shards ( sq_right_pawns_right, 3 );
		sleep_until( volume_test_players(tv_right_spawn_2nd_wave) or volume_test_players(tv_cold_right_mid),2 );
			dprint("spawn right 2nd wave");
			garbage_collect_now();
			sleep(3);
			
			



			//ai_place( sq_right_snipers_1 );
			sleep(1);
			ai_place( sq_right_snipers_2 );
			sleep(1);
			ai_place ( sq_right_snipers_3 );
			sleep(1);	
			ai_place( sq_right_platform_pawns_2 );			
			sleep(1);
			wake( f_cold_right_pawn_shard_mid );
			sleep(1);
			f_m90_game_save_no_timeout();
		sleep_until( volume_test_players(tv_cold_right_ascend) or volume_test_players(tv_cold_right_top_clear), 1);
			b_cold_right_ascend = TRUE;
			thread( f_cold_right_bridge_press() );
			s_objcon_cold_right = 30;
			ai_place ( sg_cold_right_com_bridge );			
		sleep_until( b_cold_right_bridge_activated or volume_test_players(tv_cold_right_top_clear), 1);		
			dprint("==== spawn command =====");
			ai_place ( sg_cold_right_command );

			//ai_place ( sq_right_pawn_command );
			//ai_place ( sq_right_pawn_command_2 );
			garbage_collect_now();
			sleep(2);
			wake( f_cold_right_spawn_commander );
			wake ( f_cold_right_pawn_shard_command );
			//ai_place( sg_right_3rd_wave );
			sleep(2);
			f_m90_game_save();
			sleep(60);
			
		sleep_until( volume_test_players(tv_cold_plinth_right) , 1);
			s_objcon_cold_right = 50;
			garbage_collect_now();
		
end


script dormant f_cold_right_pawn_culler()
		sleep_until( volume_test_players(tv_cold_right_mid) or volume_test_players(tv_cold_right_top_clear), 1);
				//f_ai_garbage_kill( ai ai_squad, real r_distance_min, real r_see_degrees, long l_delay_squad, long l_delay_unit, boolean b_garbage_squad )
				f_ai_garbage_kill( sg_right, 5, 22.5, 30, -1, FALSE );
		sleep_until( volume_test_players(tv_cold_right_top_clear), 1);
				f_ai_garbage_kill( sg_right_2nd_wave, 5, 22.5, 15, -1, FALSE );

end


script dormant f_cold_right_spawn_commander()
		
		if  ( not b_cold_left_core_active ) or  game_is_cooperative() or difficulty_legendary()  then
				sleep_until( ai_spawn_count( sg_cold_right_command ) > 0 and ai_living_count( sg_cold_right_command ) <= 3, 1  );
					dprint("==== spawn commander =====");	
					ai_place_in_limbo ( sg_right_commander );
					sleep(30);
					ai_place_with_birth ( sq_right_bishop_comm );
					b_cold_right_top_all_spawned = TRUE;
		else
				b_cold_right_top_all_spawned = TRUE;
		end

end

script dormant f_cold_right_save_room()
		sleep_until (volume_test_players(tv_cold_right_room_save) ,1);
			garbage_collect_now();
			f_m90_game_save_no_timeout();
end 

script dormant f_cold_right_save_intro()
		sleep_until( ai_spawn_count( sq_right_pawn_intro ) > 0 and ai_living_count( sq_right_pawn_intro ) <= 0  , 1);
			garbage_collect_now();
			f_m90_game_save_no_timeout();
end

script dormant f_cold_right_pawn_shard_bottom()
	sleep_until( volume_test_players(tv_cold_right_center)  or ai_living_count(sq_right_pawn_intro) == 2, 2);
	
	//tv_cold_right_shard
		dprint( "adding pawnz");
		ai_place_with_shards ( sq_right_bottom_shard, 3 );
end

script dormant f_cold_right_pawn_shard_mid()
	sleep_until( ai_living_count(sg_cold_right_snipe) <= 1 or volume_test_players(tv_cold_right_shard) or volume_test_players(tv_cold_right_mid), 2);
	
	//tv_cold_right_shard
		dprint( "adding pawnz");
		ai_place_with_shards ( sq_right_pawns_left, 3 );
end

global boolean b_coldant_right_bridge = FALSE;

script dormant f_coldant_right_bridge()
	sleep_until( volume_test_players(tv_cold_right_bridge ) );
		b_coldant_right_bridge = TRUE;
		s_objcon_cold_right = 40;
		//ai_place_with_shards ( sq_right_pawns_reserve, 3 );
end

global boolean b_cold_right_top_shard_spawned = FALSE;
global long l_right_pawns_shard = -1;
script dormant f_cold_right_pawn_shard_command()
	sleep_until( ai_living_count( sg_cold_right_command ) <= 5  , 1);
		dprint( "adding pawnz");
		l_right_pawns_shard = ai_place_with_shards ( sq_right_pawns_reserve_2, 3 );
		
		sleep_s(2);
		b_cold_right_top_shard_spawned = TRUE;
		sleep_s(10);
		
		//safety in case bishop died before sharding and it doesn't break clearing out the top
		DestroyDynamicTask(l_right_pawns_shard);
end

script dormant f_cold_tower_setup()

	thread( f_cold_tower_listen(cr_cold_tower_1) );
	thread( f_cold_tower_listen(cr_cold_tower_2) );
	thread( f_cold_tower_listen(cr_cold_tower_3) );
	thread( f_cold_tower_listen(cr_cold_tower_4) );
	thread( f_cold_tower_listen(cr_cold_tower_5) );
	thread( f_cold_tower_listen(cr_cold_tower_6) );
	thread( f_cold_tower_listen(cr_cold_tower_7) );
	thread( f_cold_tower_listen(cr_cold_tower_8) );
end

global short s_cold_tower_count = 0;
script static void f_cold_tower_listen( object_name tower )
	sleep_until( object_get_health(tower) <= 0  , 1);
		dprint("tower destroyed");
		s_cold_tower_count = s_cold_tower_count + 1;
		

end


script dormant f_cold_tower_hammer()
	sleep_until( s_cold_tower_count >= 8 , 1 );
	
		if b_coldant_gameplay_active then
			effect_new_on_object_marker (objects\characters\storm_pawn\fx\pawn_phase_in.effect, cr_cold_weapon_holder_td, "m_weapon_large" );
			//wake ( f_cold_timmy_d );
			//sleep(5);
			dprint("BEHOLD THE POWER AND MIGHT OF 'COLD TIMMY D' !!!!");		
			//object_hide( wp_cold_timmy_d ,false);
			if not object_valid( cr_cold_weapon_holder_td ) then
				object_create(cr_cold_weapon_holder_td);
			end
			object_create( wp_cold_timmy_d );
			sleep(1);
			//object_hide( wp_cold_timmy_d , true );
			objects_attach(   cr_cold_weapon_holder_td, "m_weapon_large",   wp_cold_timmy_d, "");		
		end
end

// =================================================================================================
// =================================================================================================
// *** PIER PLATFORM ***
// =================================================================================================
// =================================================================================================
global boolean b_coldant_pier_force_turrets = FALSE;

script static void debug_pier_spawn()
	wake( f_spawn_early_pier );
	wake( f_coldant_pier_spawn );
	object_create ( cr_comp_left_to_pier_inv );
	object_create ( cr_comp_right_to_pier_inv );
end

script dormant f_cold_pier_bishops_controller()
	ai_place( sq_pier_bishops );
	ai_place( sq_pier_pawn_early );
	ai_place( sq_pier_pawn_early_2 );
	sleep( 2 );
//	sleep_until( not f_ai_is_idle( sq_pier_bishops ) or b_coldant_pier_force_turrets, 2 );
		//dprint("bishops are alert : spawn turrets");

			
end



script dormant f_cold_pier_top_save()
	sleep_until( object_get_health (sq_pier_master_mind_turret) <= 0 and volume_test_players ( tv_cold_pier_save ), 1 );
		f_m90_game_save_no_timeout();
end
// early group of forerunners spawn on pier after one of the shields is brought down
global boolean b_pier_activated = FALSE;

script dormant f_spawn_early_pier()
	if not b_pier_activated then
		dprint("::::: EARLY pier INIT:::::");
		wake( f_cold_pier_bishops_controller );
		wake( f_coldant_pier_intro );
		b_pier_activated = TRUE;
	else
		dprint(" EARLY PIER SPAWNS ALREADY DONE???");
	end
end

script dormant f_coldant_pier_intro()
	dprint("WAITING sg_pier_intro");
	sleep_until( volume_test_players ( tv_cold_right_rear ) or volume_test_players ( tv_cold_left_rear ), 1 );
		dprint(" ::::SPAWN PIER INTRO:::");
		ai_place( sg_pier_intro );	
end

script dormant f_coldant_pier_spawn()
		sleep_until (volume_test_players(tv_land_pier) or (volume_test_players(tv_land_pier_2)),1);	
			wake( f_cold_pier_controller );	
			wake( f_coldant_pier_engage );
			wake(m90_transition_platform);
			wake( f_cold_pier_culler );
			//g_composer_state = 4;
			ai_lod_full_detail_actors (20);
			b_coldant_pier_force_turrets = TRUE;
			garbage_collect_now();	
			//f_m90_game_save();
			//sleep(2);
			cs_run_command_script (sq_pier_bishops, cs_push_alert);
			ai_place (sq_pier_bishop_master_mind);	
			
			sleep(1);
			wake( f_cold_pier_shard_controller );	


			f_m90_game_save_no_timeout();			
			sleep_s( 5 );
			ai_place_with_shards (sq_pier_master_mind_turret);
			sleep(3);

end

script command_script cs_push_alert()
			dprint("alert!!!!");
			cs_force_combat_status (3);
end

global long l_coldant_pier_pawns_1 = -1;
global long l_coldant_pier_pawns_2 = -1;
global short s_pier_pawn_1_count = 0;
global short s_pier_pawn_2_count = 0;
global short s_pier_pawn_total_count = 0;

script dormant f_cold_pier_shard_controller()

	repeat
		if b_coldant_pier_active then
			if ai_living_count( sg_pier_bishops ) > 0 then
				if l_coldant_pier_pawns_1 == -1 and s_pier_pawn_1_count < 1 and s_pier_pawn_total_count < 4 then
						thread(f_cold_pier_shard_watcher( 1 ));
				end
				
				if l_coldant_pier_pawns_2 == -1 and s_pier_pawn_2_count < 2 and s_pier_pawn_total_count < 4 then
					thread(f_cold_pier_shard_watcher( 2 ));
				end		
		
			end		
		end
		
		sleep( 30 );
	until( b_coldant_composer_fire == TRUE, 1 );
end

script static void f_cold_pier_shard_watcher( short spawn_loc )

	if spawn_loc == 1 then
		dprint("shard spawn loc 1");
		garbage_collect_now();
		s_pier_pawn_1_count = s_pier_pawn_1_count + 1;
		s_pier_pawn_total_count = s_pier_pawn_total_count + 1;
		l_coldant_pier_pawns_1 = ai_place_with_shards ( sq_pier_pawn_1, 3 );
		sleep_s( 2 );
		sleep_until ( volume_test_objects ( tv_pier_spawn_2nd_wave, (ai_actors (sq_pier_pawn_1))) );
			dprint("waiting for sq_pier_pawn_1 to spawn" );
			sleep_s( 1 );
		sleep_until( ai_living_count( sq_pier_pawn_1 ) < 2 );			
			dprint("resetting pawn 1");
			sleep_rand_s( 4,6 );
			l_coldant_pier_pawns_1 = -1;
	end
	
	if spawn_loc == 2 then
		dprint("shard spawn loc 2");
		garbage_collect_now();
		s_pier_pawn_2_count = s_pier_pawn_2_count + 1;
		s_pier_pawn_total_count = s_pier_pawn_total_count + 1;
		l_coldant_pier_pawns_2 = ai_place_with_shards ( sq_pier_pawn_2, 2 );
		sleep_s( 2 );
		sleep_until ( volume_test_objects ( tv_pier_spawn_2nd_wave, (ai_actors (sq_pier_pawn_2))) );
			dprint("waiting for sq_pier_pawn_2 to spawn" );
			sleep_s( 1 );
		sleep_until( ai_living_count( sq_pier_pawn_2 ) < 2 );
			dprint("resetting pawn 2");
			sleep_rand_s( 5,8 );
			l_coldant_pier_pawns_2 = -1;		
	end


end

script dormant f_cold_pier_controller()
	dprint("init:pier controller");
	repeat
		if volume_test_players( tv_cold_rear ) then
			b_coldant_pier_active = TRUE;
			 
			 if (object_get_health( sq_pier_master_mind_turret ) > 0 ) then
			 		
					ai_set_blind ( sq_pier_master_mind_turret , false );
			 end
			 
		else
			b_coldant_pier_active = FALSE;
			
			if (object_get_health (sq_pier_master_mind_turret ) > 0 ) then
					//dprint("blind_turret");
					ai_set_blind ( sq_pier_master_mind_turret , true );
			 end
			 
		end
	until( b_coldant_composer_fire == TRUE, 15 );
end

global boolean b_coldant_pier_engage = FALSE;

script dormant f_coldant_pier_engage()

	sleep_until( volume_test_players( tv_land_pier_2 ) or volume_test_players( tv_land_pier ) , 1 );
		dprint("pier enaged");
		b_coldant_pier_engage = TRUE;
end


script dormant f_cold_pier_culler()
		sleep_until( volume_test_players(tv_pier_top) , 1);
				//f_ai_garbage_kill( sg_pier_all, 50, 30, 15, -1, FALSE );
				f_ai_garbage_kill( sg_pier_all, 40, 22.5, 15, -1, FALSE );
				f_ai_garbage_kill( sq_pier_pawn_early, 40, 22.5, 15, -1, FALSE );
				f_ai_garbage_kill( sq_pier_pawn_early_2, 40, 22.5, 15, -1, FALSE );
end
// =================================================================================================
// =================================================================================================
// *** FINALE ***
// =================================================================================================
// =================================================================================================

script static void debug_finale_cold()
	wake(f_coldant_finale_fight);
end

script dormant f_coldant_finale_fight()
		sleep_until (volume_test_players(tv_cold_main) ,1);	
			dprint("final fight");
			garbage_collect_now();
			//ai_place(sg_cold_finale);
			f_cold_finale_spawn();

			sleep(60);

end





script static void f_cold_finale_spawn()

	sleep( 1 );
	ai_place_in_limbo( sq_final_commander);
	sleep( 1 );	
	ai_place_in_limbo( sq_final_commander_2);
	if volume_test_players( tv_main_landing ) then
		ai_place_in_limbo( sq_final_knight.spawn_left );
	else
		ai_place_in_limbo( sq_final_knight.spawn_right );
	end
	sleep( 1 );

	//ai_place( sq_final_bw );	
end

// =================================================================================================
// =================================================================================================
// *** CORE SHIELDING CONTROLLERS ***
// =================================================================================================
// =================================================================================================
global boolean b_pup_first_shield_done = false;
global long pup_show_left = -1;
global long pup_show_right = -1;
global long g_show_splinter2 = -1;
static boolean raise_right = true;
static boolean raise_left = true;

//USED IN PUPPET SHOW
global boolean g_cortana_splinter32 = false;

global object g_ics_player_left = none;
global object g_ics_player_right = none;

script static void f_cold_shield_controller()

sleep(1);
end

script static void nicklebackisthebestbandevaromg()

	ai_place_in_limbo(sq_pier_bishop_master_mind);
	sleep(30);
	
	if ai_spawn_count(sq_pier_bishop_master_mind) > 0 then
		dprint("sq_pier_bishop_master_mind spawn");
	else
		dprint("sq_pier_bishop_master_mind NOT spawned");
	end
	
	if ai_living_count(sq_pier_bishop_master_mind) > 0 then
		dprint("sq_pier_bishop_master_mind lving");
	else
		dprint("sq_pier_bishop_master_mind NOT lving");
	end
	
	if volume_test_objects(tv_pier_top, ai_actors(sq_pier_bishop_master_mind)) then
		dprint("we are fucked");
	end
end

global boolean b_cold_left_top_all_spawned = FALSE;
global boolean b_cold_left_switch_ready = FALSE;
global boolean b_cold_right_switch_ready = FALSE;

script dormant f_left_complete()

	sleep_until ( b_cold_left_top_all_spawned, 3 );
		sleep_s(2);
		dprint("waiting for top to be clear...");
		local long l_safety_timer = timer_stamp( 300 ); 
	//possible an enemy is getting stuck in geo...safety timer in case to stop prog blocker
	//birth bishop has been moved to its own group because if orphaned the volume test would give back a false positive
	sleep_until ( (  (not (volume_test_objects( tv_cold_left_top_clear, ai_actors( sg_left_all ) )) and ai_living_count( sq_left_command_bish ) <= 0 ) or timer_expired(l_safety_timer)), 1 );//
		sleep(1);
		dprint("====waiting for safety=====");
		sleep_s(1);
	sleep_until ( volume_test_players( tv_cold_left_top_clear) , 1 );
		sleep_s(2);
		dprint("top is clear");
		b_cold_left_plinth_blip = TRUE;
		f_cold_activate_plinth( cr_plinth_left, dc_comp_switch_left, dc_comp_switch_left, false, true );
		b_cold_left_switch_ready = TRUE;

end


script dormant f_right_complete()
	local boolean b_save_game = FALSE;
	
	sleep_until ( b_cold_right_top_all_spawned and b_cold_right_top_shard_spawned, 3 );
		sleep_s(2);
		dprint("waiting for top to be clear...");
		local long l_safety_timer = timer_stamp( 300 ); 
		//possible an enemy is getting stuck in geo...safety timer in case to stop prog blocker
	sleep_until ( (not ( volume_test_objects( tv_cold_right_top_clear, ai_actors( sg_right_all ) )) and ai_living_count( sq_right_bishop_comm ) <= 0 )or  timer_expired(l_safety_timer) ,1) ;
		sleep(1);
		dprint("=====waiting for safety======");
		sleep_s(1);
	sleep_until ( volume_test_players( tv_cold_right_top_clear) , 1 );
		sleep_s(2);
		b_cold_right_plinth_blip = TRUE;
		f_cold_activate_plinth( cr_plinth_right , dc_comp_switch_right, dc_comp_switch_right, false, true );
		b_cold_right_switch_ready = TRUE;
end


script dormant f_plinth_sequence()

	wake(f_left_complete);
	wake(f_right_complete);

	// wait until any of the two buttons is pressed
	sleep_until( device_get_position( dc_comp_switch_left )>0 or device_get_position( dc_comp_switch_right )>0, 1 );

	if device_get_position( dc_comp_switch_left )>0 then
		// left button was pressed first
		g_ics_plinth2 = dc_comp_switch_left;
		g_ics_plinth3 = dc_comp_switch_right;
		ai_kill(sg_left_all);
		b_cold_left_plinth_ready = true;
		g_ics_player=g_ics_player_left;
	else
		// right button was pressed first
		g_ics_plinth2 = dc_comp_switch_right;
		g_ics_plinth3 = dc_comp_switch_left;
		ai_kill(sg_right_all); 
		b_cold_right_plinth_ready = true;
		g_ics_player=g_ics_player_right;
	end

	local boolean turn_on_plinth3 = device_get_power(g_ics_plinth3)>0;
	device_set_power ( g_ics_plinth2, 0 );
	device_set_power ( g_ics_plinth3, 0 );
	f_unblip_object ( dc_comp_switch_right);
	f_unblip_object ( dc_comp_switch_left);

	thread( f_mus_m90_e05_finish() );
	thread( f_mus_m90_e07_finish() );

	g_show_splinter2 = pup_play_show(cortana_splinter2);
	sleep_until(not pup_is_playing(g_show_splinter2),1);
	b_pup_first_shield_done = true;
	thread( f_cold_set_composer_state_3() );
	wake( f_spawn_early_pier );

	if g_ics_plinth2==dc_comp_switch_right then
		b_cold_right_core_active=false;
	else
		b_cold_left_core_active=false;
	end
	thread( f_coldant_pier_mancannon_update() );
	composer_core_count = 1;
	garbage_collect_now();
	f_m90_game_save_no_timeout();

	if turn_on_plinth3 then
		device_set_position ( g_ics_plinth3, 0 );
		device_set_power ( g_ics_plinth3, 1 );
		f_blip_object ( g_ics_plinth3, "activate");
	end

	sleep_until( device_get_position( g_ics_plinth3 )>0, 1 );
	device_set_power ( g_ics_plinth3, 0 );
	f_unblip_object ( g_ics_plinth3);

	if g_ics_plinth3==dc_comp_switch_left then
		ai_kill(sg_left_all); 
		b_cold_left_plinth_ready = true;
		g_ics_player=g_ics_player_left;
		if player_valid(player0) and g_ics_player!=player0 then
			object_teleport_to_ai_point(player0,plinth_teleport_left.p0);
		end
		if player_valid(player1) and g_ics_player!=player1 then
			object_teleport_to_ai_point(player1,plinth_teleport_left.p1);
		end
		if player_valid(player2) and g_ics_player!=player2 then
			object_teleport_to_ai_point(player2,plinth_teleport_left.p2);
		end
		if player_valid(player3) and g_ics_player!=player3 then
			object_teleport_to_ai_point(player3,plinth_teleport_left.p3);
		end
	else
		ai_kill(sg_right_all); 
		b_cold_right_plinth_ready = true;
		g_ics_player=g_ics_player_right;
		if player_valid(player0) and g_ics_player!=player0 then
			object_teleport_to_ai_point(player0,plinth_teleport_right.p0);
		end
		if player_valid(player1) and g_ics_player!=player1 then
			object_teleport_to_ai_point(player1,plinth_teleport_right.p1);
		end
		if player_valid(player2) and g_ics_player!=player2 then
			object_teleport_to_ai_point(player2,plinth_teleport_right.p2);
		end
		if player_valid(player3) and g_ics_player!=player3 then
			object_teleport_to_ai_point(player3,plinth_teleport_right.p3);
		end
	end

	music_set_state('Play_mus_m90_v12_cortana_splinter_3');
	local long show=pup_play_show(cortana_splinter3);
	sleep_until(not pup_is_playing(show),1);
	thread( f_maelstrom_shield_strip() );
	b_cold_right_core_active=false;
	b_cold_left_core_active=false;
	thread( f_coldant_pier_mancannon_update() );
	composer_core_count = 0;
	garbage_collect_now();
	f_m90_game_save_no_timeout();

end


script static void f_cold_quick_plinths()

	b_cold_right_top_all_spawned = TRUE;
	b_cold_left_top_all_spawned = TRUE;
	b_cold_right_top_shard_spawned = TRUE;
end
			
global boolean b_cold_right_top_all_spawned = FALSE;
				
script static void debug_cold_sides()

	if game_is_cooperative() then
		dprint("cooperative");
	end

	if volume_test_objects( tv_cold_right_top_clear, ai_actors( sg_right_all )) then
		dprint("top not right clear...");
	else
		dprint("top right clear...");
	end

	if volume_test_objects( tv_cold_left_top_clear, ai_actors( sg_left_all )) then
		dprint("top left not clear...");
	else
		dprint("top leftclear...");
	end

end				
				
script static void f_cold_set_composer_state_3()
	//sleep_s(0.25);
	g_composer_state = 3;
end

script static void f_cold_destroy_shield()
//sleep(1);
	//dprint("s");
	if b_pup_first_shield_done then
		if object_valid(dc_comp_switch_right) then
			if g_ics_plinth3 == dc_comp_switch_right then
				wake( f_cold_destroy_right );
			end
		end
	
		if object_valid( dc_comp_switch_left ) then
			//dprint("h");
			if g_ics_plinth3 == dc_comp_switch_left then
				//dprint("it");
				wake ( f_cold_destroy_left );
			end
		end
	else
		if object_valid(dc_comp_switch_right) then
			if g_ics_plinth2 == dc_comp_switch_right then
				wake( f_cold_destroy_right );
			end
		end
	
		if object_valid( dc_comp_switch_left ) then
			//dprint("h");
			if g_ics_plinth2 == dc_comp_switch_left then
				//dprint("it");
				wake ( f_cold_destroy_left );
			end
		end	
	end


end

script dormant f_cold_destroy_right()
	//sleep_s(3);
	thread( f_comp_drop_shield());
	thread( f_comp_right_shield_fall());	
end


script dormant f_cold_destroy_left()
	//sleep_s(3);
	//object_destroy( sn_cold_cortana_left );
	thread( f_comp_drop_shield());
	thread( f_comp_left_shield_fall());	
end

script static void f_cold_destroy_beam()
	if b_pup_first_shield_done then
		if g_ics_plinth3 == dc_comp_switch_right then
			wake( f_cold_destroy_right_beam );
		end
		if g_ics_plinth3 == dc_comp_switch_left then
			//dprint("it");
			wake ( f_cold_destroy_left_beam );
		end
	else
		if g_ics_plinth2 == dc_comp_switch_right then
			wake( f_cold_destroy_right_beam );
		end
		if g_ics_plinth2 == dc_comp_switch_left then
			//dprint("it");
			wake ( f_cold_destroy_left_beam );
		end
	end
end


script static void f_comp_drop_shield()

	
	s_cold_shield_pieces = s_cold_shield_pieces - 1;
	inspect(s_cold_shield_pieces);
	if s_cold_shield_pieces > 0 then
		b_cold_outside_shield_active = FALSE;
		dprint("drop outside ring");
	else
		b_cold_inside_shield_active = FALSE;
		dprint("drop inside ring");
		//effect_kill_from_flag (environments\solo\m90_sacrifice\fx\shields\composer_shield.effect, fx_16_composer_shield);
		//object_set_function_variable(dm_composer_shield, shield_state, 1, 5); // Turn off over period of 5 seconds
		thread(f_fx_deactivate_shield());
	end
end

script dormant f_cold_destroy_left_beam()
	thread(f_fx_deactivate_beam(dm_composerbeam2));
	object_destroy (didact_beam2); //Killing sound scenery: AUDIO!
	//dprint ( "DIDACT BEAM 2 IS OFF!" );
	//effect_kill_from_flag (environments\solo\m90_sacrifice\fx\beams\composer_beams.effect, fx_16_composer_beam1); 
	//effect_kill_from_flag (environments\solo\m90_sacrifice\fx\shields\composer_shield_wisps.effect, fx_16_composer_shieldwisp);
	//object_set_function_variable(dm_composerbeam1, beam_state, 1, 5); // Turn off over period of 5 seconds, do when beam1 is deactivated
	interpolator_start ('ei_cannon_off');
end		

	//object_set_function_variable(dm_composerbeam1, beam_state, 0, 5); // Turn off over period of 5 seconds, do when beam1 is deactivated
	//object_set_function_variable(dm_composerbeam2, beam_state, 0, 5); // Turn off over period of 5 seconds, do when beam2 is deactivated
	//object_set_function_variable(composer_shield, shield_state, 0, 5); // Turn off over period of 5 seconds



script dormant f_cold_destroy_right_beam()
	thread(f_fx_deactivate_beam(dm_composerbeam1));
	object_destroy (didact_beam1); //Killing sound scenery: AUDIO!
	//dprint ( "DIDACT BEAM 1 IS OFF!" );
	//object_set_function_variable(dm_composerbeam2, beam_state, 1, 5); // Turn off over period of 5 seconds, do when beam2 is deactivated
	//effect_kill_from_flag (environments\solo\m90_sacrifice\fx\beams\composer_beams.effect, fx_16_composer_beam); 
	//effect_kill_from_flag (environments\solo\m90_sacrifice\fx\shields\composer_shield_wisps.effect, fx_16_composer_shieldwisp1);
	interpolator_start  ( 'wi_cannon_off' );
end	




script static void f_core_entry_hit()
	damage_players(objects\characters\monitor\damage_effects\first_hit.damage_effect);
	camera_shake_all_coop_players( 0.2, 0.2, 1, 0.1, core_hit_camera_shake);
end

script static void f_maelstrom_shield_strip( )
	thread(f_coldant_maelstrom_shield_strip_players_one_time());
	//thread(f_coldant_maelstrom_shield_strip_players());
	sleep(60);
	f_m90_game_save_no_timeout();
	wake(f_dialog_m90_maelstrom_vignette_over);
end

script static void test_composer
	object_destroy(composer);
	sleep(1);
	pup_play_show( pup_composer );
end

script static void test_splinter1
	g_ics_player = player0;
	pup_play_show( cortana_splinter1 );
end

script static void test_splinter_reset
	//object_create( maya_script_composer_shield_right );
	//object_create( maya_script_composer_shield_left );
	//object_create(cr_comp_beam_r_red);
	////object_create(cr_comp_beam_base_r_red);
	//object_create(cr_comp_beam_l_red);
	//object_create(cr_comp_beam_base_l_red);
//	object_destroy(cr_composer_beam_earth);
//	object_destroy(cr_composer_beam_slip);
	//object_destroy (es_comp_maelstrom);	

	b_pup_first_shield_done = FALSE;
end

script static void test_splinter2
	if raise_right then
		f_cold_activate_plinth( cr_plinth_right, dc_comp_switch_right, dc_comp_switch_right, false, true );
		raise_right = false;
	end

	g_ics_player = player0;
	g_ics_plinth2 = dc_comp_switch_right;
	pup_play_show( cortana_splinter2 );
end

script static void test_splinter3l
	if raise_left then
		f_cold_activate_plinth( cr_plinth_left, dc_comp_switch_left, dc_comp_switch_left, false, true );
		raise_left=false;
	end
	b_pup_first_shield_done = true;

	g_ics_player=player0;
	g_ics_plinth3=dc_comp_switch_left;
	pup_play_show(pup_cold_composing_didact);
	pup_play_show( cortana_splinter3 );
end

script static void test_splinter3r
	//static boolean raise = true;
	
	if raise_right then
		f_cold_activate_plinth( cr_plinth_right, dc_comp_switch_right, dc_comp_switch_right, false, true );
		raise_right = false;
	end
	b_pup_first_shield_done = true;

	g_ics_player = player0;
	g_ics_plinth3 = dc_comp_switch_right;
	pup_play_show(pup_cold_composing_didact);
	pup_play_show( cortana_splinter3 );
end

script static void temp_up()
	f_cold_activate_plinth( cr_plinth_left, dc_comp_switch_left, dc_comp_switch_left, false,true );
end
//	------------------------------------------------------------------------------------------------
//	***	OBJECTIVES ***	----------------------------------------------------------------------------
//	------------------------------------------------------------------------------------------------



script static void vd ()

		thread( f_objective_set( DEF_R_OBJECTIVE_DESTROY_CORE, TRUE, FALSE, TRUE, TRUE ) );
		sleep_s(6);
		thread( f_objective_set( DEF_R_OBJECTIVE_ALRIGHT_MESSAGE, TRUE, FALSE, FALSE, TRUE ) );
end

//	------------------------------------------------------------------------------------------------
//	***	CORES DISABLED ***	----------------------------------------------------------------------------
//	------------------------------------------------------------------------------------------------

script static void fm90_debug_end()
	wake(f_comp_cores_all_disabled);
	composer_core_count = 0;
end

script dormant f_comp_cores_all_disabled()
	// tracks health of Composer Locks, allows access to Composer Core. 
	sleep_until ((composer_core_count == 0), 5);
		wake( f_coldant_finale_fight );
		wake( f_cold_finale_blip_hack );
		wake(f_comp_enter_core);
		//device_set_position ( dc_comp_switch_front, 0 );
		//device_set_power ( dc_comp_switch_front, 1 );

		thread( f_objective_set( DEF_R_OBJECTIVE_DESTROY_CORE, TRUE, FALSE, TRUE, TRUE ) );
		//sleep_s(6);
		

	sleep_until( ai_spawn_count(sg_cold_finale) > 0 and ai_living_count(sg_cold_finale) <= 0);
		f_unblip_flag ( flag_cold_main_end );
		sleep( 1 );
		f_m90_game_save_no_timeout();
		sleep(60);

		//thread( f_coldant_create_bridge() );
		sleep_s(3);
		thread( stop_camera_shake_loop());
		sleep(1);
		thread( start_camera_shake_loop( "heavy", "short", coldant_camera_shake_heavy_short));		
end

script static void f_composer_start_firing()
		b_coldant_composer_fire = TRUE;
		thread( start_camera_shake_loop( "medium", "medium", coldant_camera_shake_medium_medium));
		dprint ("All Beams Deactivated. Enter Core Now."); 
		//object_create(cr_composer_beam_earth);
		//object_create(cr_composer_beam_slip);
		//object_create (es_comp_maelstrom);
		//g_composer_state = 3;
		sleep(1);

		sleep(30);
		thread( f_cold_maelstrom());
end


script dormant f_comp_enter_core()
		
		b_coldant_gameplay_active = FALSE;
		/// THIS WILL BLOCK CONTINUATION
		f_cold_find_ics_activator();
		
		
		f_unblip_flag ( fg_comp_bridge_end );
		thread( stop_camera_shake_loop());
		data_mine_set_mission_segment ("m90_ending");
		dprint("FOUND ICS PERSON");
		//pup_stop_show( l_didact_loop_pup );	
		ins_cin_92();
end

script dormant f_comp_start_ics()
		f_unblip_flag (fg_comp_bridge_end);

		hud_play_global_animtion (screen_fade_in);
	
		hud_stop_global_animtion (screen_fade_in);

		pup_grief_counter = 9;
		if g_ics_player==list_get(players(),0) then
		  pup_grief_counter = 0;
		elseif g_ics_player==list_get(players(),1) then
		  pup_grief_counter = 1;
		elseif g_ics_player==list_get(players(),2) then
		  pup_grief_counter = 2;
		elseif g_ics_player==list_get(players(),3) then
		  pup_grief_counter = 3;
		end

		// this music trigger should happen right after coming out of the cinematic
		thread(f_music_m90_v13_vs_didact_1());
		
		game_save_immediate();
		sleep(1);
		thread(f_coldant_maelstrom_shield_strip_players());
		fade_out(0,0,0,0);
		f_bomb_icon( false );

		f_clear_equipment();
		sleep(3);
		//SetObjectRealVariable(maya_scripted_m90_composerbridge_crate,VAR_OBJ_LOCAL_A,1);
		
		//make sure that we still have a valid player since we grabbed a player before the cinematic started
		// pup_grief_counter is the index of g_ics_player + 100 for each time that player failed
		g_ics_player = list_get(players(),pup_grief_counter%10);
		if pup_grief_counter>=500 or not player_valid(unit(g_ics_player)) then
			// you have failed me for the last time (picking a new player)
			pup_grief_counter = ((pup_grief_counter+1)%10)%list_count(players());
			g_ics_player = list_get(players(),pup_grief_counter);
		end
		pup_grief_counter = pup_grief_counter+100;
		
		sleep(1);
		fade_in(0,0,0,10);
		music_set_state("Play_mus_m90_v08_didact_vs_chief");
		local long show = pup_play_show( pup_didact_ics );
		sleep_until(not pup_is_playing(show),1);
		sleep(1);
		if g_kill_player == 0 then
			dprint("player is alive, continuing");
			//object_destroy(es_comp_maelstrom);
			// Fade to & from white represents brightness of Core, and HDR adjustment of visor to light. 
//		fade_out(1,1,1,0);
		
//		sleep(2);
		dprint("deleting composer");
		
			//fade_in(1,1,1,30);
			//wake( f_space_end_init );
		
			b_cold_mancs_active = FALSE;
			b_coldant_active = FALSE;

		////////////////////////////////////////
		// MIDNIGHT KISS
		////////////////////////////////////////
			thread( f_cold_cleanup() );
			f_m90_update_4_objectives();
			
			// MN-97919 - Need more White Screen time between Bomb Vignette moment and 093 Kiss Cinematic - 1.5 seconds
			sleep_s(1.5);
			
			ins_cin_93();

		else
			if g_kill_player == 2 then
				sleep(30); // died during crawling - allows 1 second for killcam
			end
			if ( is_skull_active(skull_iron) and not game_is_cooperative() ) then 
				map_reset();
			else
				game_revert();
			end
		end
end

global boolean b_cold_ics_started_first_move = FALSE;
//global boolean b_cold_ics_start_failure_ = FALSE;
script static void f_coldant_ics_start_timer()
	sleep_s(120);
	if b_cold_ics_started_first_move then
		sleep(1);
	end
end

global boolean b_coldant_ics_pull_up = FALSE;
script static void f_coldant_ics_death_timer()
	local long l_timer = timer_stamp( 30 ); 

	sleep_until( timer_expired(l_timer), 1 ); 
		if not b_coldant_ics_pull_up then
			dprint("fail");
			g_kill_player = 1;
			if not game_is_cooperative() then
				unit_kill( unit( g_ics_player ) );
				sleep(10);
				fade_out(0,0,0,30);
				sleep(30);
				if is_skull_active(skull_iron) then 
					map_reset();
				else
					game_revert();
				end
			else
				game_revert();
			end
		else
			dprint("player moved");
		end

end


script static void f_cold_find_ics_activator()
	dprint("*** waiting to catch ics starter ***");
	g_ics_player = player_get_first_valid();
	sleep_until (volume_test_players ( tv_comp_enter_core ) , 1);
		if ( volume_test_objects( tv_comp_enter_core, player0 ) ) then
			dprint("player0 activates ics");
			g_ics_player = player0;
		elseif ( volume_test_objects( tv_comp_enter_core, player1 ) ) then
			dprint("player1 activates ics");
			g_ics_player = player1;
		elseif ( volume_test_objects( tv_comp_enter_core, player2 ) ) then
			dprint("player2 activates ics");
			g_ics_player = player2;
		elseif ( volume_test_objects( tv_comp_enter_core, player3 ) ) then
			dprint("player3 activates ics");
			g_ics_player = player3;
		end
		

end



script static void f_coldant_create_bridge()
	dprint("move elevator");

	object_hide( maya_scripted_m90_composerbridge_crate,FALSE);
	//object_hide( didact_bridge, FALSE ); //Unhide final light bridge sound scenery: AUDIO!
	if not object_valid( didact_bridge ) then
		object_create( didact_bridge );
		//dprint ( "----------------- DIDACT BRIDGE LIVES! --------------------" );
	end
	SetObjectRealVariable(maya_scripted_m90_composerbridge_crate,VAR_OBJ_LOCAL_B,1);
	SetObjectRealVariable(maya_scripted_m90_composerbridge_crate,VAR_OBJ_LOCAL_A,1);



end


script static void f_coldant_grav_lift() 

	wake( f_coldant_final_rampancy );
	sleep_s(5);
	thread( f_objective_set( DEF_R_OBJECTIVE_ALRIGHT_MESSAGE, FALSE, FALSE, FALSE, TRUE ) );
	sleep_s(4);
 	wake( f_coldant_final_lift);
	wake( f_coldant_bridge_wait );
	
 	object_create( dm_coldant_grav_push );
 	sleep(1);
 	object_create( dm_coldant_grav_lift );
 	f_cold_grav_lift_effect();

end
	



script dormant f_coldant_final_rampancy()

	hud_set_rampancy_intensity(player0, 0.9);
	hud_set_rampancy_intensity(player1, 0.9);
	hud_set_rampancy_intensity(player2, 0.9);
	hud_set_rampancy_intensity(player3, 0.9); 
	sleep_s(2);
	hud_set_rampancy_intensity(player0, 0.4);
	hud_set_rampancy_intensity(player1, 0.4);
	hud_set_rampancy_intensity(player2, 0.4);
	hud_set_rampancy_intensity(player3, 0.4); 
	sleep_s(2);	
	hud_set_rampancy_intensity(player0, 0.1);
	hud_set_rampancy_intensity(player1, 0.1);
	hud_set_rampancy_intensity(player2, 0.1);
	hud_set_rampancy_intensity(player3, 0.1);
	sleep_s(1);	
	hud_set_rampancy_intensity(player0, 0);
	hud_set_rampancy_intensity(player1, 0);
	hud_set_rampancy_intensity(player2, 0);
	hud_set_rampancy_intensity(player3, 0);	

end

script dormant f_coldant_bridge_wait()

	sleep_until(volume_test_players(tv_cold_final_lift),1);
		f_coldant_create_bridge();
end

script dormant f_coldant_final_lift()
	//repeat


		f_blip_flag( fg_comp_bridge_start, "default" );
	sleep_until( volume_test_players( tv_cold_final_lift ) , 1 );
	
	//sleep_until( volume_test_players( tv_cold_final_lift ) );
		f_unblip_flag(fg_comp_bridge_start);
		//object_destroy( dm_coldant_grav_lift );
		sleep(15);
		f_blip_flag (fg_comp_bridge_end, "default");
end

script dormant f_cold_finale_blip_hack()
		//repeat
		dprint("final blips");
	if ( volume_test_players( tv_cold_right ) ) then
		dprint("right blip");
		f_blip_flag(flag_right_to_main, "default");
	end
	
	if ( volume_test_players( tv_cold_left)) then	
		dprint("left blip");
		f_blip_flag(flag_left_to_main, "default");
	end	
		
	sleep_until( volume_test_players( tv_cold_main ) , 1 );	
	
		f_unblip_flag( flag_right_to_main );
		f_unblip_flag( flag_left_to_main );
		f_blip_flag ( flag_cold_main_end, "default");
		sleep_until ( ai_spawn_count(sg_cold_finale) > 0 and ai_living_count(sg_cold_finale) <= 0 );
			sleep(5);
			f_unblip_flag ( flag_cold_main_end );
			thread( f_coldant_grav_lift());
end

// =================================================================================================
// =================================================================================================
// GENERAL SCRIPTS
// =================================================================================================
// =================================================================================================

////////////////////////////////////////////////////
///  ENTRANCE DOOR
///////////////////////////////////////////////////



script static void f_comp_open_door()
	device_set_position ( f_cold_front_door, 1 );
end

script static void f_comp_close_door()
	device_set_position ( f_cold_front_door, 0 );
end

script static void f_comp_close_door_safe()

	sleep_until (volume_test_players (tv_coldant_door_close), 1);
	
	f_unblip_flag ( flag_cold_main_end);
	wake ( f_jump_cleanup_harvestors );
	wake( f_jump_tube_cleanup );
	
	volume_teleport_players_not_inside (tv_coldant_door_close, flag_coldant_teleport_in);

	device_set_position ( f_cold_front_door, 0 );
	
	sleep_until (device_get_position (f_cold_front_door) == 0);
	
	object_destroy_folder( crs_jump_comp_weapons);
end

script dormant f_comp_door_control()
	sleep_until ( volume_test_players( tv_comp_open_door ), 1 );
		thread(f_comp_open_door());
	
end

script dormant f_comp_save_pre_pier_right()
	sleep_until ( volume_test_players( tv_cold_right_pre_pier_save ) , 1 );
		f_m90_game_save();	
end

script dormant f_comp_save_pre_pier_left()
	sleep_until ( volume_test_players( tv_cold_left_pre_pier_save ), 1 );
		f_m90_game_save();		
end

script dormant f_coldant_platforms()
	sleep_until( object_valid(maya_script_landing_left_a) ,1 );
	sleep_until( object_valid(maya_script_landing_left_b) ,1 );
	sleep_until( object_valid(maya_script_landing_main_a) ,1 );
	sleep_until( object_valid(maya_script_landing_main_b) ,1 );
	sleep_until( object_valid(maya_script_landing_pier_a) ,1 );
	sleep_until( object_valid(maya_script_landing_pier_b) ,1 );
	sleep_until( object_valid(maya_script_landing_right_a) ,1 );
	sleep_until( object_valid(maya_script_landing_right_b) ,1 );
	dprint("landing pads valid");
	object_hide( maya_script_landing_left_a, TRUE );
	object_hide( maya_script_landing_left_b, TRUE );
	object_hide( maya_script_landing_main_a, TRUE );
	object_hide( maya_script_landing_main_b, TRUE );
	object_hide( maya_script_landing_pier_a, TRUE );
	object_hide( maya_script_landing_pier_b, TRUE );
	object_hide( maya_script_landing_right_a, TRUE );
	object_hide( maya_script_landing_right_b, TRUE );			
	thread( f_coldant_move_platform( maya_script_landing_left_a, TRUE ) );
	thread( f_coldant_move_platform( maya_script_landing_left_b, TRUE ) );
	thread( f_coldant_move_platform( maya_script_landing_main_a, TRUE ) );
	thread( f_coldant_move_platform( maya_script_landing_main_b, TRUE ) );
	thread( f_coldant_move_platform( maya_script_landing_pier_a, TRUE ) );
	thread( f_coldant_move_platform( maya_script_landing_pier_b, TRUE ) );
	thread( f_coldant_move_platform( maya_script_landing_right_a, TRUE ) );
	thread( f_coldant_move_platform( maya_script_landing_right_b, TRUE ) );


end

script static void f_coldant_move_platform( object_name platform, boolean b_hide )
	if b_hide then
		object_move_by_offset( platform, 0.01, 0, 0, -100 );	
	else
		object_move_by_offset( platform, 0.01, 0, 0, 100 );	
	end
	
end

script dormant f_coldant_platforms_activate()
	thread( f_coldant_platform_wait( tv_cold_mc_main_left , maya_script_landing_left_a ) );
	thread( f_coldant_platform_wait( tv_cold_mc_main_right , maya_script_landing_right_a ) );
	thread( f_coldant_platform_wait( tv_cold_mc_left_main , maya_script_landing_main_a ) );
	thread( f_coldant_platform_wait( tv_cold_mc_left_pier , maya_script_landing_pier_a ) );
	thread( f_coldant_platform_wait( tv_cold_mc_pier_left , maya_script_landing_left_b ) );
	thread( f_coldant_platform_wait( tv_cold_mc_pier_right , maya_script_landing_right_b ) );
	thread( f_coldant_platform_wait( tv_cold_mc_right_pier , maya_script_landing_pier_b ) );
	thread( f_coldant_platform_wait( tv_cold_mc_right_main , maya_script_landing_main_b ) );
end

script static void f_coldant_platform_wait( trigger_volume tv , object_name platform )

	sleep_until( volume_test_players ( tv ) , 1 );
		dprint("activating platform");
		thread( f_coldant_rezin( platform ) );

end

script static void f_coldant_rezin( object_name platform)
	sleep_s(0.75);
	sleep( 2 );
	thread( f_coldant_move_platform( platform, FALSE ) );
	sleep( 1 );
	object_dissolve_from_marker( platform, hard_kill, m_platform );
	//object_hide( platform, FALSE );
end





////////////////////////////////////////////////////
///  WAYPOINT UPDATER
///////////////////////////////////////////////////

global cutscene_flag fg_cold_curret_blip_flag = flag_empty;
global cutscene_flag fg_cold_curret_blip_flag_2 = flag_empty;
global cutscene_flag fg_cold_curret_blip_flag_3 = flag_empty;
///holy crap yep this is what i made to control blips dynamically...probably only works well for 1 player have to figure out co-op
script dormant f_coldant_update()

	repeat
		sleep( 1 );
		if ( b_cold_left_core_active  /* and not( volume_test_players( tv_core_right ) or volume_test_players( tv_core_left  ))*/ ) then
			if ( (not volume_test_players( tv_cold_right ) and b_cold_right_core_active == TRUE )  ) then
			
			
				if b_cold_left_ascend then
					fm90_unblip_flag ( flag_cold_left_tower );
					sleep(1);
					if b_cold_left_plinth_blip then
						fm90_unblip_flag ( flag_left_to_composer );
					else
						if not volume_test_players( tv_cold_left_top_clear ) then
							fm90_blip_flag ( flag_left_to_composer, "default" );
						else
							fm90_unblip_flag ( flag_left_to_composer );
						end
					end
				else
					fm90_unblip_flag ( flag_left_to_composer );
					sleep(1);
					fm90_blip_flag ( flag_cold_left_tower, "default" );
					
				end
			
			else
				if   (not volume_test_players( tv_cold_left ) ) then
					fm90_unblip_flag ( flag_left_to_composer );
					fm90_unblip_flag ( flag_cold_left_tower );
				end
			end			
		else
			fm90_unblip_flag ( flag_left_to_composer );
		end
		
		if ( b_cold_left_core_active and not b_cold_right_core_active ) then
			if ( volume_test_players( tv_cold_right ) ) then
					fm90_blip_flag ( flag_right_to_pier, "default" );				
			else
					fm90_unblip_flag ( flag_right_to_pier);
			end
			
			if ( volume_test_players( tv_cold_rear ) ) then
					fm90_blip_flag ( flag_pier_to_left, "default" );				
			else
					fm90_unblip_flag ( flag_pier_to_left);
			end			

			if ( volume_test_players( tv_cold_left ) or volume_test_players( tv_cold_main )) then
				if b_cold_left_ascend then
					fm90_unblip_flag ( flag_cold_left_tower );
					sleep(1);
					if b_cold_left_plinth_blip then
						fm90_unblip_flag ( flag_left_to_composer );
					else
						if not volume_test_players( tv_cold_left_top_clear ) then
							fm90_blip_flag ( flag_left_to_composer, "default" );
						else
							fm90_unblip_flag ( flag_left_to_composer );
						end
					end
					
				else
					fm90_unblip_flag ( flag_left_to_composer );
					sleep(1);	
					fm90_blip_flag ( flag_cold_left_tower, "default" );
					
				end
			end
			
		end
		

		if ( b_cold_right_core_active ) then
			if ( (not volume_test_players( tv_cold_left ) and b_cold_left_core_active == TRUE )  ) then
				
				if b_cold_right_ascend then
					fm90_unblip_flag ( flag_cold_right_tower );
					sleep(1);
					if b_cold_right_plinth_blip then
						fm90_unblip_flag ( flag_right_to_composer );
					else
						if not volume_test_players( tv_cold_right_top_clear ) then
							fm90_blip_flag ( flag_right_to_composer, "default" );
						else
							fm90_unblip_flag ( flag_right_to_composer );
						end
					end
					
				else
					fm90_unblip_flag ( flag_right_to_composer );
					sleep(1);
					fm90_blip_flag ( flag_cold_right_tower, "default" );
					
				end

			else
				if  ( not volume_test_players( tv_cold_right ) ) then
					fm90_unblip_flag ( flag_right_to_composer );
					fm90_unblip_flag ( flag_cold_right_tower );
				end
			end	
		else

			fm90_unblip_flag ( flag_right_to_composer );
		end

		if ( b_cold_right_core_active and not b_cold_left_core_active ) then
			if ( volume_test_players( tv_cold_left ) ) then
				//dprint("huh");
					fm90_blip_flag ( flag_left_to_pier, "default" );				
			else
					fm90_unblip_flag ( flag_left_to_pier);
			end

			if ( volume_test_players( tv_cold_right ) or volume_test_players( tv_cold_main )) then
				if b_cold_right_ascend then
					fm90_unblip_flag ( flag_cold_right_tower );
					sleep(1);
					if b_cold_right_plinth_blip then
							fm90_unblip_flag ( flag_right_to_composer );
					else
						if not volume_test_players( tv_cold_right_top_clear ) then
							fm90_blip_flag ( flag_right_to_composer, "default" );
						else
							fm90_unblip_flag ( flag_right_to_composer );
						end
					end
					
				else
					fm90_unblip_flag ( flag_right_to_composer );
					sleep(1);
					fm90_blip_flag ( flag_cold_right_tower, "default" );
				
				end
			end
	
			
			if ( volume_test_players( tv_cold_rear ) ) then
					fm90_blip_flag ( flag_pier_to_right, "default" );				
			else
					fm90_unblip_flag ( flag_pier_to_right);
			end			
			
		end

		if not b_cold_left_core_active and not b_cold_right_core_active then
			fm90_unblip_flag ( flag_right_to_pier );
			fm90_unblip_flag ( flag_left_to_pier );
			
			
			if ( volume_test_players( tv_cold_rear ) ) then
					fm90_blip_flag ( flag_pier_to_left, "default" );	
					fm90_blip_flag ( flag_pier_to_right, "default" );					
			else
					fm90_unblip_flag ( flag_pier_to_left);
					fm90_unblip_flag ( flag_pier_to_right);
			end	
			
		end
	until( b_coldant_active == FALSE, 15 );
	


end

script static void f_coldant_clearall_blips()
	f_unblip_flag ( flag_pier_to_right);
	f_unblip_flag ( flag_pier_to_left);
	f_unblip_flag ( flag_left_to_pier);
	f_unblip_flag ( flag_right_to_pier);
	f_unblip_flag ( flag_right_to_composer );
	f_unblip_flag ( flag_left_to_composer);

end



//	------------------------------------------------------------------------------------------------
//	***	MANCANNON CONTROL ***	----------------------------------------------------------------------
//	------------------------------------------------------------------------------------------------

script static void f_coldant_pier_mancannon_update()

	if b_cold_left_core_active == FALSE and b_cold_right_core_active == FALSE then
		dprint("destroying to pier mcs");
		object_destroy ( cr_comp_left_to_pier_inv );
		object_destroy ( cr_comp_right_to_pier_inv );
		sleep(1);
		f_cold_mancannon_fx( cr_comp_left_to_pier_inv , FALSE );
		f_cold_mancannon_fx( cr_comp_right_to_pier_inv , FALSE );

		object_create(cr_comp_left_to_main_inv);
		object_create(cr_comp_right_to_main_inv);	
		sleep(1);
		f_cold_mancannon_fx( cr_comp_left_to_main_inv , TRUE );
		f_cold_mancannon_fx( cr_comp_right_to_main_inv , TRUE );

		wake( f_coldant_main_cannons_off );		

	elseif b_cold_left_core_active == TRUE and b_cold_right_core_active == FALSE then
		dprint("creating right to pier mcs");
		object_create ( cr_comp_right_to_pier_inv );
		sleep(1);
		f_cold_mancannon_fx( cr_comp_right_to_pier_inv , TRUE );
	elseif b_cold_left_core_active == FALSE and b_cold_right_core_active == TRUE then
		dprint("creating left to pier mcs");
		object_create ( cr_comp_left_to_pier_inv );

		sleep(1);
		f_cold_mancannon_fx( cr_comp_left_to_pier_inv , TRUE );
	end
end

script dormant f_coldant_pier_mc_effects()

	object_create(cr_comp_pier_invis_right);
	object_create(cr_comp_pier_invis_left);
	

	sleep(1 );
	f_cold_mancannon_fx( cr_comp_pier_invis_left , TRUE );
	f_cold_mancannon_fx( cr_comp_pier_invis_right , TRUE );	


end
	
script dormant f_coldant_main_cannons_on()
//		object_destroy( cr_comp_plat1_left_off );
//		object_destroy( cr_comp_plat1_right_off );	
		object_create( cr_comp_plat1_right_inv );	
		object_create( cr_comp_plat1_left_inv );
		sleep(1);
		f_cold_mancannon_fx( cr_comp_plat1_right_inv , TRUE );
		f_cold_mancannon_fx( cr_comp_plat1_left_inv , TRUE );	
		//object_create( es_comp_plat1_left );
		//object_create( es_comp_plat1_right );
		//object_create( cr_comp_main_to_right_base );
		//object_create( cr_comp_main_to_left_base );
end


script dormant f_coldant_main_cannons_off()
//		object_create( cr_comp_plat1_left_off );
//		object_create( cr_comp_plat1_right_off );	
		object_destroy( cr_comp_plat1_right_inv );	
		object_destroy( cr_comp_plat1_left_inv );	
		f_cold_mancannon_fx( cr_comp_plat1_right_inv , FALSE );
		f_cold_mancannon_fx( cr_comp_plat1_left_inv , FALSE );	
		//object_destroy( es_comp_plat1_left );
		//object_destroy( es_comp_plat1_right );
		//object_destroy( cr_comp_main_to_right_base );
		//object_destroy( cr_comp_main_to_left_base );
end



		


//	------------------------------------------------------------------------------------------------
//	***	COMBAT CONTROL ***	----------------------------------------------------------------------------
//	------------------------------------------------------------------------------------------------







global boolean b_stop_shield_strip = FALSE;
script static void f_coldant_maelstrom_shield_strip_players()
	//b_stop_shield_strip = TRUE;
	repeat
		if player_valid(player0) then
			object_set_shield (player0(),0);
			object_set_shield_stun_infinite (player0());
		end
		//object_set_shield_stun (player0(),999999);
		if player_valid(player1) then
			object_set_shield (player1(),0);
			object_set_shield_stun_infinite (player1());
		end
		//object_set_shield_stun (player1(),999999);
		if player_valid(player2) then
			object_set_shield (player2(),0);
			object_set_shield_stun_infinite (player2());
		end
		//object_set_shield_stun (player2(),999999);
		if player_valid(player3) then
			object_set_shield (player3(),0);
			object_set_shield_stun_infinite (player3());
		end
		//object_set_shield_stun (player3(),999999);
	until( b_coldant_complete or b_stop_shield_strip,5);		
end


script static void f_coldant_maelstrom_shield_strip_players_one_time()

		if player_valid(player0) then
			object_set_shield (player0(),0);
		end

		if player_valid(player1) then
			object_set_shield (player1(),0);
		end

		if player_valid(player2) then
			object_set_shield (player2(),0);

		end

		if player_valid(player3) then
			object_set_shield (player3(),0);
		end
	
end

script static void f_coldant_maelstrom_shield_restore_players()
		b_stop_shield_strip = TRUE;
		sleep(5);
		object_set_shield (player0(),1);
		object_set_shield_stun (player0(),0);
		object_set_shield (player1(),1);
		object_set_shield_stun (player1(),0);
		object_set_shield (player2(),1);
		object_set_shield_stun (player2(),0);
		object_set_shield (player3(),1);
		object_set_shield_stun (player3(),0);
				
end

script command_script cs_shield_strip_knight()
		cs_phase_in();
		
		//object_set_shield (ai_get_object( ai_current_actor ),0);
		//object_set_shield_stun (ai_get_object( ai_current_actor ),9999);
		
end

//////////////////////////////
// ENDING
/////////////////////////////
script dormant f_m90_ending()

		nar_m90_end();
		b_M90_COMPLETE = TRUE;
end







global boolean b_Composer_Init = FALSE;
global long l_pup_composer = -1;

script static void f_composer_init_jump()
	b_Composer_Init = TRUE;	
	dprint("starting composer show");
	l_pup_composer = pup_play_show(pup_composer);
end

script static void f_composer_init_coldant()
	if not b_Composer_Init then
		dprint("we must be inserting to coldant, starting composer");
		l_pup_composer = pup_play_show(pup_composer);
		g_composer_state = 1;
	end

end

script static void zip_it_cortana()
	b_debug_skip_intro = TRUE;
end

script static void debug_left_bridge()
	object_create( dc_left_bridge );
	f_cold_left_bridge_press();
end



global boolean b_cold_left_bridge_activated = FALSE;
global boolean b_cold_right_bridge_activated = FALSE;

script static void f_cold_left_bridge_press()
			f_blip_flag( flag_left_bridge_button, "activate" );
	sleep_until( device_get_position( dc_left_bridge ) > 0.0, 1 );	
		dprint("press button");
		f_unblip_flag( flag_left_bridge_button );
		pup_play_show( pup_bridge_left );

end

script static void f_cold_right_bridge_press()
			f_blip_flag( flag_right_bridge_button, "activate" );
	sleep_until( device_get_position( dc_right_bridge ) > 0.0, 1 );	
		dprint("press button");
		f_unblip_flag( flag_right_bridge_button );
		pup_play_show( pup_bridge_right );
	
end

script static void f_cold_plinth_explosion()
	//effect_new_on_object_marker( environments\solo\m90_sacrifice\fx\explosion\cortana_plinth_explode.effect ,cortana, fx_pedestal );
	sleep(3);
	dprint("plinth explosions");
	thread(f_core_entry_hit());
	if g_ics_plinth3 == dc_comp_switch_right then
		effect_new( environments\solo\m90_sacrifice\fx\explosion\cortana_plinth_explode.effect, flag_explosion_plinth_right );
		effect_new_on_ground( environments\solo\m90_sacrifice\fx\explosion\plinth_explosion_decal.effect, cr_plinth_right );
		
		//object_destroy(cr_plinth_right);
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\amb_m90_dm_plinth_derez', cr_plinth_right, 1 ); //AUDIO!
		object_dissolve_from_marker( cr_plinth_right, soft_kill, m_control );
		sleep_s(4);
		object_destroy(cr_plinth_right);
	else
		effect_new( environments\solo\m90_sacrifice\fx\explosion\cortana_plinth_explode.effect, flag_explosion_plinth_left );
		effect_new_on_ground( environments\solo\m90_sacrifice\fx\explosion\plinth_explosion_decal.effect, cr_plinth_left );
		
		//object_destroy(cr_plinth_left);
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\amb_m90_dm_plinth_derez', cr_plinth_left, 1 ); //AUDIO!
		object_dissolve_from_marker( cr_plinth_left, soft_kill, m_control );
		
		sleep_s(4);
		object_destroy(cr_plinth_left);
	end
	
	//sleep(15);
	
end

script static void f_cold_mancannon_fx( object_name crate , boolean b_on )

	if b_on then
		effect_new_on_object_marker ( levels\multi\wraparound\fx\energy\wrp_launchpad_energy_rt.effect, crate, "marker_man_cannon_mp_invisible_base" );
	else
		effect_stop_object_marker ( levels\multi\wraparound\fx\energy\wrp_launchpad_energy_rt.effect, crate, "marker_man_cannon_mp_invisible_base" );
	end
	
end
script static void f_cold_grav_lift_effect()
	dprint(":::::::::::::::-------------f_cold_grav_lift_effect()");
	//effect_new ( levels\multi\wraparound\fx\energy\wrp_launchpad_energy_rt.effect,flag_comp_gravlift  );
	
	//script static void f_drop_down_effects()

	//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flag_comp_gravlift);
	effect_new(environments\solo\m90_sacrifice\fx\energy\m90_cortana_gravlift.effect, flag_comp_gravlift);
	
	effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, flag_comp_gravlift, flag_gravlift_top);

end

script static void f_cold_composer_cloud()
	//dprint("MAL STRUUMMMMMM");
	effect_new( environments\solo\m90_sacrifice\fx\radiation\radiation_cloud.effect, flag_cold_didact );
	//effect_new( environments\solo\m90_sacrifice\fx\radiation\composer_radiation.effect, flag_cold_didact );

end

script static void f_cold_maelstrom()
	dprint("MAL STRUUMMMMMM");
	//effect_new( environments\solo\m90_sacrifice\fx\radiation\radiation_cloud.effect, flag_cold_didact );
	effect_new( environments\solo\m90_sacrifice\fx\radiation\composer_radiation.effect, flag_cold_didact );
	f_radiation_particles_on( TRUE );
end

script static void f_cold_maelstrom_all()
	dprint("MAL STRUUMMMMMM");
	effect_new( environments\solo\m90_sacrifice\fx\radiation\radiation_cloud.effect, flag_cold_didact );
	effect_new( environments\solo\m90_sacrifice\fx\radiation\composer_radiation.effect, flag_cold_didact );
	f_radiation_particles_on( TRUE );
end

script static void f_cold_maelstrom_kill()
	dprint("KILL MAL STRUUMMMMMM");
	//effect_kill_from_flag( environments\solo\m90_sacrifice\fx\radiation\radiation_cloud.effect, flag_cold_didact );
	//effect_kill_from_flag( environments\solo\m90_sacrifice\fx\radiation\composer_radiation.effect, flag_cold_didact );
	
	f_radiation_particles_on( FALSE );
end




	
		
		////////////////////////////////////
//	SPACE END
//  CHIEF IN SPACE
////////////////////////////////////


script dormant f_space_end_init()
	local long l_pup_space = -1;
	dprint("f_space_end_init");
	thread( f_coldant_maelstrom_shield_restore_players() );
	player_disable_movement ( TRUE );
	//object_create(space_pelican);
	pup_player0 = player_get_first_valid();
	inspect( pup_player0 );
	sleep(90);
	inspect( pup_player0 );
	hud_show( FALSE );
	cinematic_start();
	l_pup_space = pup_play_show( pup_space_float );
 	dprint("---- fade in ----");
 	dprint("---- CHIEF in SPAAACE ----");
 	sleep(30);
 	fade_in (0, 0, 0, 30);
 	
 sleep_until( pup_is_playing( l_pup_space ) == FALSE, 1 );
 	fade_out(1,1,1,0 );
	cinematic_stop();
 	dprint("space float finished");	
 		// Calls the M90 ending cinematic in the narrative script after player has pressed "the button". Includes mission complete script. 
		nar_m90_end();
		
		
	//dprint("M90 mission complete");
	//b_M90_COMPLETE = TRUE;
	player_disable_movement (FALSE);
end