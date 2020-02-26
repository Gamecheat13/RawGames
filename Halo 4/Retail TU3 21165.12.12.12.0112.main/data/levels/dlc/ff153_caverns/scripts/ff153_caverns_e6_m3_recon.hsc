//// =============================================================================================================================
//========= CAVERNS E6_M3 RECON FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

global boolean b_e6_m3_exterior_alarm = FALSE;
global boolean b_e6_m3_interior_alarm = FALSE;
global object g_e6m3_sleepy_grunt = NONE;
global boolean b_e6_m3_airstrike_avail = TRUE;
global boolean b_e6_m3_ext_intro_done = FALSE;
global boolean b_e6_m3_airstrike_fired = FALSE;
global boolean b_e6_m3_airstrike_complete = FALSE;
global boolean b_e6m3_phant_drop_tower_done = FALSE;
global boolean b_e6_m3_cavern_exit_open = FALSE;
global boolean b_e6m3_phantom_boo_done = FALSE;
global boolean b_e6m3_exterior_2_final_spawn_done = FALSE;
global boolean b_e6m3_exterior_intro_rein_coming = FALSE;
global boolean b_e6m3_ext_intro_wave_1_done = FALSE;
global boolean b_e6m3_main_door_done = FALSE;

global boolean b_e6_m3_goal_found = FALSE;
global boolean b_e6_m3_goal_ready = FALSE;
global boolean b_e6m3_plans_retrieved = FALSE;
global boolean b_e6_m3_interior_phantom_ignored = FALSE;
global boolean b_e6_m3_light_bridge_activated = FALSE;
global boolean b_e6_m3_phantom_int_done = FALSE;
global boolean b_e6_m3_side_barrier_down = FALSE;
global boolean b_e6_m3_interior_loaded = FALSE;
global boolean b_e6_m3_pickup_ready = FALSE;
global boolean b_e6_m3_interior_phantom_start = FALSE;
global boolean b_e6_m3_interior_fore_cleared = FALSE;



global boolean b_e6_m3_force_start = FALSE;
global boolean b_debug_no_intro = FALSE;
global boolean b_e6_m3_start_gameplay = FALSE;

script startup f_e6_m3_startup()
	
	//Wait for start
	if ( f_spops_mission_startup_wait("e6_m3") or b_e6_m3_force_start ) then	
		dprint( "---------f_e6_m3_startup-----------" );
		
		sleep(1);
		wake( f_e6_m3_init );		
	end
	
end



script dormant f_e6_m3_init()
	local long l_pup_intro = -1;
	f_spops_mission_setup( "e6_m3", "e6_m3_ext_1", sg_e6_m3_all, e6_m3_start_locs, 91 );
	
	e6_m3_caverns_setup_main();
	sleep(60);
	sleep_until (f_spops_mission_ready_complete(), 1);
	
	
	

	if  not b_debug_no_intro then
		pup_disable_splitscreen (TRUE);
		l_pup_intro = pup_play_show( e6_m3_intro );
		
		sleep(2);
		thread( vo_e6m3_narr_in() );
		sleep_until( not pup_is_playing(l_pup_intro ), 1) ;
		pup_disable_splitscreen (FALSE);
			ai_erase(braindead);
	else
		object_destroy(grunt_e6m3_sleep);
	end
	
	dprint("BEGIN::::: e6 m3 recon");
	f_spops_mission_intro_complete( TRUE );
	
	sleep_until (f_spops_mission_start_complete(), 1); 
		//b_end_player_goal = TRUE;	
	
	thread( f_e6_m3_music_start() );
	ai_place( sq_phantom_unsc_in );
	sleep(1);
	b_end_player_goal = FALSE;
	fade_in(0, 0, 0, 30);
	
	b_e6_m3_start_gameplay = TRUE;
	ai_allegiance ( forerunner, covenant );
	ai_allegiance ( covenant, forerunner );
end




script static void e6_m3_caverns_setup_main()

		dprint("setup main");
		e6_m3_caverns_creation();
		//sleep(5); 
		wake( e6_m3_caverns_streaming );
		
		//f_add_crate_folder( e6_m3_start_locs );
		//firefight_mode_set_crate_folder_at( e6_m3_start_locs, 91);	


		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_1, 92 );
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_2, 93 );	
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_3, 94 );		
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_3_5, 89 );	
		
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_4, 95 );
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_5, 96 );
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_5_5, 99 );
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_6, 97 );
		firefight_mode_set_crate_folder_at( e6_m3_respawn_locs_7, 98 );
					
		firefight_mode_set_objective_name_at( e6_m3_lz_0 ,51 ); 
		firefight_mode_set_objective_name_at( e6_m3_lz_1 ,52 );		
		firefight_mode_set_squad_at( sg_e6_m3_exterior_intro, 20 );
		//firefight_mode_set_squad_at( sg_e6_m3_interior_fore_bishop, 20 );
		
		firefight_mode_set_squad_at( sq_e6_m3_int_grunts_4, 21 );
		thread( e6_m3_remove_other_timeline_items () );
		
		f_spops_mission_setup_complete( TRUE );
		//dm_droppod_4 = dm_e6_m3_water_drop;
		dm_droppod_4 = dm_e6_m3_drop_2;
		sleep(5);
		
		wake( e6_m3_caverns_interior_setup );
		wake( e6_m3_caverns_ext_outro_setup );
		wake( e6_m3_caverns_exterior_intro_spawns ); 
		wake( e6_m3_caverns_exterior_intro_status );
		wake( e6_m3_caverns_events );
		thread( e6_m3_barrier_objective() );		

end




script static void e6_m3_caverns_creation()
	f_add_crate_folder( crs_e6_m3_ext_1 ); 
	f_add_crate_folder( dcs_e6_m3 );
	f_add_crate_folder( eq_e6_m3 );
	f_add_crate_folder( e6_m3_scenery );
	f_add_crate_folder( wpns_e6_m3 );
	f_add_crate_folder( dms_e6_m3 );	
	f_add_crate_folder( e6m3_veh_plasma );		
	sleep(1);

	//object_create(e6_m3_cov_base_02);
	//object_create(e6_m3_cov_base_01);
	object_create(veh_e6_m3_shade_2);

	object_cannot_take_damage(cr_e6_m3_pod_top_1);
	object_cannot_take_damage(cr_e6_m3_pod_top_2);
	thread( e6_m3_setup_towers() );
	//sleep(1);

				
//	e6_m3_cov_base_01->top_object(cr_e6_m3_pod_top_1 );
end

script static void e6_m3_setup_towers()
	object_create_anew( e6_m3_cov_base_01 );
	object_create_anew( e6_m3_cov_base_02 );
	object_create_anew( cr_e6_m3_pod_top_1 );
	sleep( 1 );
	sleep_until( object_active_for_script(e6_m3_cov_base_01) and object_valid(cr_e6_m3_pod_top_1), 1 );
		e6_m3_cov_base_01->top_object( cr_e6_m3_pod_top_1 );
		object_cannot_take_damage(cr_e6_m3_pod_top_1);
		object_cannot_take_damage(cr_e6_m3_pod_top_2);
		object_move_to_point( cr_e6_m3_pod_top_1, 0, ps_e6m3_main.pod1);
		object_move_to_point( cr_e6_m3_pod_top_2, 0, ps_e6m3_main.pod2);
		object_set_physics (cr_e6_m3_pod_top_1, FALSE);
		object_set_physics (cr_e6_m3_pod_top_2, FALSE);
		object_set_physics (e6_m3_cov_base_01, TRUE);
		object_set_physics (e6_m3_cov_base_02, TRUE);
		object_hide(cr_e6_m3_pod_top_1,TRUE);
		object_hide(cr_e6_m3_pod_top_2,TRUE);
		e6_m3_cov_base_02->lift_disable();
end
//e6_m3_cov_base_01->lift_enable();
script static void e6_m3_remove_other_timeline_items()

	if object_valid( 	e8m3_base_1 ) then
		//object_hide(e8m3_base_1, TRUE);
		//object_set_physics(e8m3_base_1, FALSE);
		dprint("word");
	end
	
	if object_valid( 	e8m3_pod_1 ) then
		object_hide(e8m3_pod_1, TRUE);
		object_set_physics(e8m3_pod_1, FALSE);
		//dprint("up");
	end
	//dprint("derp");
end

script dormant e6_m3_caverns_ext_intro_setup()
	thread( f_moving_cruiser() );	
	sleep_s(1);
	//object_set_phantom_power( e6_m3_cov_base_01, false );
	//object_set_phantom_power( e6_m3_cov_base_02, false );
	object_set_phantom_power(e8m3_base_1, false);	
	thread( e6_m3_take_out_sleepers_init () );
	//thread( e6_m3_watchtower_watcher( , e8m3_base_1) );
	thread( e6_m3_watchtower_watcher( cr_e6_m3_pod_top_1, e6_m3_cov_base_01) );
	thread( e6_m3_airstrike_wait() );  
end

script static void e6_m3_watchtower_watcher( object_name tower_top, object_name tower_base)
	sleep_until( object_get_health( tower_top ) <= 0 );
		//object_set_phantom_power( tower_base, false );
end

global short s_e6m3_sleep_intro_count = 3;


script static void e6_m3_take_out_sleepers_init()
	dprint(" ====== wait for sleepy");
	ai_actor_dialogue_enable(sg_e6_m3_exterior_sleep_grunt, FALSE );
	sleep_until(volume_test_players( tv_e6_m3_sleep_callout ), 1);
		
		dprint("====== hey sleepy heads");
		if not b_e6_m3_exterior_alarm then
			thread( vo_e6m3_take_out());
			thread( f_e6_m3_event1_start() );
			sleep_s(2.5);
			//dprint("====== blip wtf guys");
			thread( e6_m3_take_out_sleepers( sq_e6_m3_ext_grunt_5_intro.mister_snuggles,flg_e6_m3_snuggles ) );
			thread( e6_m3_take_out_sleepers( sq_e6_m3_ext_grunt_2_intro.mister_sniffles ,  flg_e6_m3_sniffles));
			thread( e6_m3_take_out_sleepers( sq_e6_m3_ext_grunt_2_intro.mister_lazybones , flg_e6_m3_lazybones) );
			
			sleep_until( s_e6m3_sleep_intro_count	== 0 ,1 );
				if not b_e6_m3_exterior_alarm then
					sleep_until( not b_narrative_is_on ,1 );
					sleep_s(1);
						vo_e6m3_stealth();
				end	
		end			
end



//spops_blip_flag( flg_e6_m3_snuggles, TRUE, "neutralize" );	
script static void e6_m3_take_out_sleepers( ai sleepy_head, cutscene_flag flag_blip )
		if not b_e6_m3_exterior_alarm then
			spops_blip_flag( flag_blip, TRUE, "neutralize" );	
			//navpoint_object_set_vertical_offset( ai_get_object( sleepy_head ), 10 );		
			//spops_blip_ai( sleepy_head, TRUE, "neutralize", NONE, 10.0 );
			sleep_until( object_get_health(sleepy_head) <= 0 or b_e6_m3_exterior_alarm,1 );
			
				if not b_e6_m3_exterior_alarm then
					s_e6m3_sleep_intro_count = s_e6m3_sleep_intro_count - 1;	
				end
				spops_blip_flag( flag_blip, FALSE, "neutralize" );
		end
		
end


script dormant e6_m3_caverns_exterior_intro_spawns()	
	pup_play_show( pup_e6_m3_elite_comp );
	//firefight_mode_set_squad_at(sg_e6_m3_exterior_intro, 20);
	//sleep_until( ( ai_spawn_count(sg_e6_m3_exterior_intro) > 0 and ai_living_count(sg_e6_m3_exterior_intro)<= 5 )   , 1);
	sleep_until( ( ai_spawn_count(sg_e6_m3_exterior_intro) > 0 and ai_living_count(sg_e6_m3_all)<= 3 )   , 1);
		sleep_until( e6m3_narr_clear(), 1);
		vo_glo15_miller_few_more_06();
		f_blip_ai_cui( sg_e6_m3_all, "navpoint_enemy" );
		
	sleep_until( ai_living_count(sg_e6_m3_all) <= 0  , 1);
		b_e6m3_ext_intro_wave_1_done = TRUE;
		thread( f_e6_m3_event2_stop() );
	sleep_until( b_e6m3_main_door_done  , 1);	
		sleep_s(1.5);	
		ai_place(sq_e6_m3_phantom_intro);
		b_e6m3_exterior_intro_rein_coming = TRUE;
		
		sleep_s(8);
			thread(f_e6_m3_event3_start());
			thread( vo_glo15_miller_phantom_01() );
			hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G04_60" );
		sleep_s(3);
		
		f_new_objective("e6_m3_clear_resist");
	sleep_until( b_e6_m3_ext_intro_done and ai_living_count(sg_e6_m3_all) <= 3  , 1);
		//sleep_until( e6m3_narr_clear(), 1);
		
		
end


script dormant e6_m3_caverns_events()
	dprint("============");
		wake(e6_m3_caverns_e6_m3_surprise);
    wake( e6_m3_caverns_barrier );                      	                                                                                                                                                                                                             
		wake( e6_m3_caverns_ext_intro_setup );
		wake( e6_m3_exterior_objectives );
end

script dormant e6_m3_exterior_objectives()

sleep_until( b_e6_m3_start_gameplay, 1 );
	f_new_objective("e6_m3_recon");
	
end

script dormant e6_m3_caverns_barrier()

		sleep_until( volume_test_players( tv_e6_m3_enter_gameplay ) ,1 );
			//dprint("skippy is better than jiff");
			//f_new_objective_not_pause_screen_6_3("e6_m3_recon2");
			f_new_objective("e6_m3_recon2");
			object_create( cr_e6_m3_path_barrier );
			sleep(1);
			object_cannot_take_damage (cr_e6_m3_path_barrier );
			ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e4_m4.scenery", 
			"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
    	//thread( e6_m3_airstrike_wait() );                                                                                                                                                                                                                                   
			f_create_new_spawn_folder (92);
end

script dormant e6_m3_caverns_e6_m3_surprise()

		sleep_until( LevelEventStatus("e6_m3_surprise") ,1 );
				dprint("setup surprise");
		    b_wait_for_narrative_hud = TRUE;                                                                                                                                                                                                                                  

end

script static void e6_m3_barrier_objective()
	//sleep_until( volume_test_players( tv_e6_m3_nook_blip ), 1 );
		//if not b_e6_m3_exterior_alarm then
		//	spops_blip_flag( flg_e6_m3_nook, TRUE, "recon" );
		//end
		//thread( e6_m3_reached_nook() );
	sleep_until( b_e6m3_ext_intro_wave_1_done , 1 );
	
	sleep_until( e6m3_narr_clear(), 1);	
		sleep_s( 3 );
		vo_glo15_miller_attaboy_07();
		sleep(10);
		vo_e6m3_doorwaychatter_01();	
		f_new_objective( "e6_m3_open_door" );
	//e6_m3_activate_button_sequence( cavern_fdoor_dc );
	e6_m3_activate_button_sequence_main_dummy();
		b_e6m3_main_door_done = TRUE;
	sleep_until( e6m3_narr_clear(), 1);
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e6m3_jammed_door', cavern_front_door_button, 1 ); //AUDIO!
		effect_new( environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, flg_e6_m3_main_switch);
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_low', cavern_front_door_button, 1 ); //SCREEN SHAKE AUDIO!
		thread (camera_shake_all_coop_players_6_3( .1, .2, 1, 0.1, NONE));
		sleep_s( 2 );
		effect_new( environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, flg_e6_m3_main_switch);
		vo_e6m3_doorwaychatter_02();		
		
	//sleep_s( 5 );
	//PHANTOM INCOMING!!!
	sleep_until( b_e6_m3_ext_intro_done and ai_living_count(sg_e6_m3_all) <= 3, 1 );
			sleep_until( e6m3_narr_clear() , 1 );
			vo_glo15_miller_few_more_07();
			f_blip_ai_cui( sg_e6_m3_all, "navpoint_enemy" );	
	sleep_until( b_e6_m3_ext_intro_done and ai_living_count(sg_e6_m3_all) <= 0, 1 );
		thread(f_e6_m3_event3_stop());
		
		sleep_until( e6m3_narr_clear() , 1 );
		vo_glo15_palmer_all_clear_02();
		sleep(15);
		vo_e6m3_addl();
		
		
		spops_blip_flag( flg_e6_m3_nook, TRUE, "recon" );
		f_new_objective("e6_m3_find_way");
		//vo_glo15_miller_move_06 need to thread this off when enemines are at 0 and player not in volume //vo_glo15_palmer_waypoint_01
	sleep_until( volume_test_players(tv_e6_m3_nook), 1);
		sleep_s(1);
		spops_unblip_flag(flg_e6_m3_nook);		
		sleep_s(1);
		sleep_until( e6m3_narr_clear(), 1);		
			vo_e6m3_doorwaychatter_03();
			
		f_new_objective("e6_m3_shut_down_barr");
		//object_create( dm_e6_m3_barrier_switch );  //automagically
		sleep(1);
		e6_m3_activate_button_sequence_barrier();
		//e6_m3_activate_button_sequence( dc_e6_m3_barrier_comp, dm_e6_m3_barrier_switch, TRUE );

			sleep(10);
			hud_play_pip_from_tag (levels\dlc\shared\binks\sp_g02_60);
			local long l_timer = timer_stamp( 5 );
			/*
	sleep_until( ai_living_count(sg_e6_m3_all) <= 0 , 1 );
		//vo_glo15_palmer_all_clear_02();
	sleep_until( ai_living_count(sg_e6_m3_all) <= 0 and timer_expired(l_timer), 1 ); 
	*/
		sleep_until( e6m3_narr_clear(), 1);	
			//vo_glo15_palmer_all_clear_02();
			sleep_s(3);
			thread( e6_m3_side_barrier_off() );
			sleep_s(1);
			thread (vo_e6m3_doorwaychatter_05());
			sleep_s(1);
			f_clear_spops_objectives();
			f_new_objective("e6_m3_proceed_inside");
			sleep(10);
			
			/*
			sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_cov_shield_off_mnde875', cr_e6_m3_path_barrier, 1 ); //AUDIO!
			object_set_function_variable(cr_e6_m3_path_barrier, shield_alpha, 1, 3);
			sleep(15);
			object_set_physics (cr_e6_m3_path_barrier, false);
			sleep_s(3);
			object_destroy( cr_e6_m3_path_barrier );
			b_e6_m3_side_barrier_down = TRUE;
			*/
			sleep_s( 0.75 );
			f_blip_flag( flg_e6_m3_enter_cave, "default");
			f_create_new_spawn_folder (93);
	sleep_until( volume_test_players(tv_e6_m3_cave_enter) , 1 );
			f_unblip_flag( flg_e6_m3_enter_cave );
			
	//flg_e6_m3_enter_cave

end

script static void e6_m3_side_barrier_off()
			sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_cov_shield_off_mnde875', cr_e6_m3_path_barrier, 1 ); //AUDIO!
			object_set_function_variable(cr_e6_m3_path_barrier, shield_alpha, 1, 3);
			sleep(15);
			object_set_physics (cr_e6_m3_path_barrier, false);
			sleep_s(3);
			object_destroy( cr_e6_m3_path_barrier );
			b_e6_m3_side_barrier_down = TRUE;

end
//cavern_fdoor_dc
//effect_new( environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, flg_e10_m3_exit_button);


global boolean b_e6m3_test_airstrike = FALSE;


script static void e6_m3_airstrike_wait()

	object_create( dm_e6_m3_airstrike_switch );
	device_set_power( dc_e6_m3_airstrike_comp, 1 );
	sleep_until( ( device_get_position(dc_e6_m3_airstrike_comp) > 0.0 and b_e6_m3_airstrike_avail ) or b_e6m3_test_airstrike, 1);
		local long show = pup_play_show( pup_e6_m3_airstrike );
		
		thread( e6_m3_switch_helper(dm_e6_m3_airstrike_switch, show) );
		
		b_e6_m3_airstrike_fired = TRUE;
		
		sleep_until (not pup_is_playing(show), 1);
		sleep_s(0.5);
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_high', NONE, 1 ); //AUDIO!
		thread (camera_shake_all_coop_players_6_3( .2, .7, 1, 0.1, NONE));
		sleep_s(0.75);
		//sound\storm\states\siren_intensity\set_state_explosion_alley
		//
		
		thread( f_e6_m3_stinger_airstrike() );
		thread( e6_m3_perf_saver() );
		//sound_looping_start( sound\storm\states\siren_intensity\set_state_explosion_alley, NONE, 1.0 );
		vo_e6m3_airstrike_switch();
		//thread (story_blurb_add("other", "Looks like you just called in an covenant airstrike on your position. I suggest you take cover"));
		sleep_s(1);
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
		sleep(10);
		thread( f_tj_special(flg_e6_m3_airstrike_8) );
		thread( f_tj_special(flg_e6_m3_airstrike_9) );
		sleep(5);
		thread( f_tj_special(flg_e6_m3_airstrike_10) );
		sound_looping_stop( sound\storm\states\siren_intensity\set_state_explosion_alley );
		b_e6_m3_airstrike_complete = TRUE;
end

script static void e6_m3_switch_helper( device halo, long show)
	sleep_until ( not pup_is_playing( show ), 1 );
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm_e6_m3_airstrike_switch, 1 ); //AUDIO!
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\scripted\spops_scripted_caverns_airstrike_alarm_mnde8580', airstrike_alarm_sfx, 1 ); //PLAY AIRSTRIKE ALARM AUDIO!
		device_set_position( dm_e6_m3_airstrike_switch, 1 );
	sleep_until( device_get_position( dm_e6_m3_airstrike_switch ) == 1,1 );
		object_hide( halo, TRUE );
end

script static void f_tj_special (cutscene_flag flag)
  //print ("shake start");
  sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //AUDIO!
  thread (camera_shake_all_coop_players_6_3( .1, .7, 1, 0.1,NONE));
  ordnance_drop (flag, "default");
  sleep(38);
  effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
  damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
  print ("EXPLOSION");
end

//effect_new (objects\vehicles\covenant\storm_lich\fx\lich_gravlift\lich_gravlift.effect, flag);
// effect_new_on_object_marker ( objects\vehicles\covenant\storm_lich\fx\lich_gravlift\lich_gravlift.effect <object> <string_id> )
//

script static void f_moving_cruiser()
	sleep_until( object_valid( sc_e6_m3_cruiser_ext ) , 1);
		dprint("cruiser is valid");
		object_cinematic_visibility(sc_e6_m3_cruiser_ext, TRUE);
		//object_cinematic_visibility(sc_e6_m3_cruiser_ext0, TRUE);
		object_move_to_point(sc_e6_m3_cruiser_ext, 200, ps_e6m3_main.cruiser_1);
	sleep_until( object_valid( dc_e6_m3_int_term_03 ) and device_get_position(dc_e6_m3_int_term_03) > 0, 1);
		
		object_move_to_point(sc_e6_m3_cruiser_ext, 75, ps_e6m3_main.cruiser_2);
end


script dormant e6_m3_caverns_comp_alert()

	sleep_until( volume_test_players(  tv_e6_m3_comp_alert ),1);
	
		if object_get_health(sq_e6_m3_ext_elites_2) > 0 then
			b_e6_m3_exterior_alarm = TRUE;
		end

end


script dormant e6_m3_caverns_exterior_intro_status()
	wake( e6_m3_caverns_comp_alert );
	sleep_until( f_ai_is_aggressive( sg_e6_m3_exterior_intro ) or b_e6_m3_exterior_alarm or b_e6_m3_airstrike_fired, 1);
	
	if f_ai_is_aggressive( sg_e6_m3_exterior_intro ) then
		dprint("alarm because someone is aggressive");
		
		if f_ai_is_aggressive( sq_e6_m3_ext_grunt_1_intro ) then
			dprint("alarm because sq_e6_m3_ext_grunt_1_intro is aggressive");
		end
		if f_ai_is_aggressive( sq_e6_m3_ext_grunt_2_intro ) then
			dprint("alarm because sq_e6_m3_ext_grunt_2_intro is aggressive");
		end		
		if f_ai_is_aggressive( sq_e6_m3_ext_grunt_3_intro ) then
			dprint("alarm because sq_e6_m3_ext_grunt_3_intro is aggressive");
		end
		if f_ai_is_aggressive( sq_e6_m3_ext_grunt_4_intro ) then
			dprint("alarm because sq_e6_m3_ext_grunt_4_intro is aggressive");
		end		
		if f_ai_is_aggressive( sq_e6_m3_ext_grunt_5_intro ) then
			dprint("alarm because sq_e6_m3_ext_grunt_5_intro is aggressive");
		end		
		if f_ai_is_aggressive( sq_e6_m3_ext_elites_1 ) then
			dprint("alarm because sq_e6_m3_ext_elites_1 is aggressive");
		end		
		if f_ai_is_aggressive( sq_e6_m3_ext_elites_2 ) then
			dprint("alarm because sq_e6_m3_ext_elites_2 is aggressive");		
			sleep_s(1);				
		end	
		if f_ai_is_aggressive( sq_e6_m3_ext_commander_1 ) then
			dprint("alarm because sq_e6_m3_ext_commander_1 is aggressive");
		end	
	end
/*	
		repeat 
			f_e6_m3_alert( sg_e6_m3_exterior_intro );
			sleep(5);
		until ( b_e6_m3_exterior_alarm,1 );
*/
		if not b_e6_m3_airstrike_fired then
			object_hide( dm_e6_m3_airstrike_switch, TRUE );
		end
		
		ai_actor_dialogue_enable(sg_e6_m3_exterior_sleep_grunt, TRUE );
		//f_ai_is_aggressive( sg_e6_m3_exterior_intro );
		print("ALARM!!!!!");
		thread( e6_m3_perf_saver() );
		b_e6_m3_exterior_alarm = TRUE;
		thread( f_e6_m3_event1_stop() );
		thread( f_e6_m3_event2_start() );
		sleep_s(2);
		ai_berserk( sq_e6_m3_ext_elites_2, TRUE );
		//ai_set_blind (sg_e6_m3_exterior_sleep_grunt, FALSE);
		b_e6_m3_airstrike_avail = FALSE;
		//object_destroy( dm_e6_m3_airstrike_switch );
		device_set_power( dc_e6_m3_airstrike_comp, 0 );
		if device_get_position( dc_e6_m3_airstrike_comp ) == 0 then
			//thread (story_blurb_add("other", "I'm reading an alarm signal. They know you're there.  Prepare for a fight."));
			sleep_until( e6m3_narr_clear() , 1);
				thread( vo_e6m3_alarm() );
		end		
end

global boolean b_e6_m3_perf_saver_on = FALSE;
global long l_perf_timer = -1; 

script static void e6_m3_perf_saver()
	l_perf_timer = timer_stamp(10);
	
	if not b_e6_m3_perf_saver_on then
		b_e6_m3_perf_saver_on = TRUE;
		effects_perf_armageddon = TRUE;

	sleep_until( timer_expired(l_perf_timer) or ai_living_count(sg_e6_m3_all ) <= 9, 1);
		b_e6_m3_perf_saver_on = FALSE;
		effects_perf_armageddon = FALSE;
	end
end

script static void e6_m3_unblind( ai gruntly )
	sleep_s(2.5);	
	if unit_get_health( gruntly ) > 0 then
		//dprint("I CAN SEE!");
		ai_set_blind (gruntly, FALSE);
	end	
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


//////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////
//	INTERIOR
////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


global boolean b_e6_m3_debug_interior = FALSE;

script static void debug_interior_e6m3()
	switch_zone_set("e6_m3_int_1");
	sleep(15);
	b_e6_m3_debug_interior = TRUE;
	wake(e6_m3_caverns_interior_setup);

end

script static void e6_m3_destroy_bridges()
	sleep_until( object_valid(cr_ff153_caverns_bridge_b) , 1 );
		object_destroy( cr_ff153_caverns_bridge_b );
		object_destroy( light_bridge_audio_b ); //AUDIO!
	sleep_until( object_valid(cr_ff153_caverns_bridge_a) , 1 );
		object_destroy( cr_ff153_caverns_bridge_a );
		object_destroy( light_bridge_audio_a ); //AUDIO!
end

script dormant e6_m3_caverns_interior_setup()

	sleep_until(b_e6_m3_interior_loaded or b_e6_m3_debug_interior,1);
	
		thread( e6_m3_camo_surprise() );
		//ai_place( sg_e6_m3_interior_zealots_1 );
		wake( e6_m3_caverns_interior_objectives_1 );
		wake( e6_m3_caverns_interior_objectives_2 );
		wake( e6_m3_caverns_interior_objectives_3 );
		object_create_folder( crs_e6_m3_int_1 );
		//object_create_folder( dms_e6_m3_int );
		thread( e6_m3_interior_spawns() );
		thread( e6_m3_destroy_bridges() );
		thread( e6_m3_shard_fortress() );
		object_create( veh_e6_m3_ban_1 );
		object_create( veh_e6_m3_ban_2 );
		object_create( cr_e6_m3_bashee_wall );
		object_create( e6_m3_grav_lift_1_off );
		object_create( e6_m3_grav_lift_2_off );
		sleep(5);
		thread( e6_m3_banshee_barrier( veh_e6_m3_ban_1 ));
		thread( e6_m3_banshee_barrier( veh_e6_m3_ban_2 ));
		
end


script dormant e6_m3_caverns_interior_status()
	sleep_until( f_ai_is_aggressive( sg_e6_m3_interior_all ) or b_e6_m3_interior_alarm, 1);				
		//print("INTERIOR ALARM!!!!!");
		b_e6_m3_interior_alarm = TRUE;
		
end

script dormant e6_m3_caverns_interior_objectives_1()

	sleep_until(volume_test_players( tv_e6_m3_too_quiet ),1);	
		thread( vo_e6m3_secret_path() );
		thread(f_e6_m3_event4_start());
end

script dormant e6_m3_caverns_interior_objectives_2()
	sleep_until(volume_test_players( tv_e6_m3_side_enter_main ) or volume_test_players( tv_e6_m3_dropdown_low ),1);	
			 f_blip_flag( flg_e6_m3_dropdown, "recon" );
			 f_create_new_spawn_folder (94);
			 object_create(dm_e6_m3_bridge_switch );
end

script dormant e6_m3_caverns_interior_objectives_3()
	sleep_until( volume_test_players( tv_e6_m3_dropdown_low ) or volume_test_players( tv_e6_m3_dropdown_high ) or volume_test_players( tv_e6_m3_area_int_term_02 ) , 1);
			thread( f_e6_m3_event5_start() );
			f_unblip_flag( flg_e6_m3_dropdown);
		sleep_until ( e6m3_narr_clear(),1);
				vo_glo15_miller_waypoint_01();	
				//e6_m3_explore_interior
				//f_new_objective("e6_m3_activate_bridges");
				f_new_objective("e6_m3_investigate");
			 	f_blip_flag( flg_e6_m3_cave_rear, "recon" );
			 	sleep_s(1.5);
			 	vo_glo15_miller_contacts_01();
	sleep_until( volume_test_players( tv_e6_m3_area_int_term_02 ) or b_e6_m3_fortress_fight_begin, 1);
			b_e6_m3_activate_all_stealthlots = TRUE;
			f_unblip_flag( flg_e6_m3_cave_rear);
			f_new_objective("e6_m3_eliminate");
	//	if ai_living_count(sg_e6_m3_interior_fore) > 0 then
		//		sleep_until ( e6m3_narr_clear(),1);
		//		vo_glo15_palmer_fewmore_06();		
		//end
			//thread (story_blurb_add("other", "Get to that terminal."));
	sleep_until( ai_living_count( sg_e6_m3_interior_fore ) <= 3 , 1 );
			if ai_living_count(sg_e6_m3_interior_fore)   > 0 then	
				sleep_until ( e6m3_narr_clear(),1);	
				vo_glo15_miller_few_more_03();	
				sleep_s(1);
				f_blip_ai_cui( sg_e6_m3_interior_fore, "navpoint_enemy" );
				//f_blip_ai_cui( sg_e6_m3_interior_grunts_intro, "navpoint_enemy" );
			end	
	sleep_until( ai_living_count(sg_e6_m3_interior_fore) <= 0 , 1 );
		sleep_until ( e6m3_narr_clear(),1);
			sleep_s(2.0);
			vo_e6m3_lightbridgegonow();	
			f_new_objective("e6_m3_activate_bridges");	
			sleep_s(1);			
			sleep(1);
		e6_m3_activate_button_sequence_forerunner( dc_e6_m3_int_term_02, dm_e6_m3_bridge_switch,flg_e6_m3_lightbridge );
			thread( f_e6_m3_event6_stop() );
			sleep(60);
			thread( e6_m3_cleanup_turrets( ));

			
			spops_ai_garbage_kill( sg_e6_m3_interior_grunts_intro, 15, 15 );
			//sleep_s(5);
			//device_set_power( dis_e6_m3_banshee_1, 1 );
			//device_set_power( dis_e6_m3_banshee_2, 1 );
			thread( e6_m3_turn_on_grav_lifts() );
			object_create( cr_ff153_caverns_bridge_b  );
			if not object_valid( light_bridge_audio_b ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BRIDGE AUDIO!
				sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_hardlight_bridge_on_mnde861', cr_ff153_caverns_bridge_b, 1 ); //AUDIO!
				object_create( light_bridge_audio_b );
			end
			object_create( cr_ff153_caverns_bridge_a  );
			if not object_valid( light_bridge_audio_a ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BRIDGE AUDIO!
				sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_hardlight_bridge_on_mnde861', cr_ff153_caverns_bridge_a, 1 ); //AUDIO!
				object_create( light_bridge_audio_a );
			end
			thread( e6_m3_mancannon( cr_e6_m3_mancannon, cr_e6_m3_mancannon_effect ) );
			//thread( vo_e6m3_switch_moved() );
			thread ( e6_m3_interior_light_bridge_vo() );
			sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_cov_shield_off_mnde875', cr_e6_m3_bashee_wall, 1 ); //AUDIO!
			object_set_function_variable(cr_e6_m3_bashee_wall, shield_alpha, 1, 2);
			sleep_s(2);
			thread( f_e6_m3_event7_start() );
			b_e6_m3_light_bridge_activated = true;

			object_destroy( cr_e6_m3_bashee_wall );
		//	thread( vo_e6m3_switch_ambush() );
			f_create_new_spawn_folder (95);
			//thread (story_blurb_add("other", "Getting location of SPECIAL THING we are looking for. We need to get power to the hardlight system. Hold Tight."));
			sleep_s(6);
			thread( e6_m3_tower_handholding_blipage() );
			
			f_new_objective("e6_m3_get_to_info_terminal");
			//thread (story_blurb_add("other", "Head to this loc it will lead us to our goal."));
			//f_blip_flag( flg_e6_m3_cave_upper_ramp, "default" );
	sleep_until(volume_test_players( tv_e6_m3_cavern_upper_big ),1);
			f_create_new_spawn_folder (96);
			sleep(5);
	sleep_until(volume_test_players( tv_e6_m3_tower_mid ),1);		
			f_create_new_spawn_folder (99);
		//	f_unblip_flag( flg_e6_m3_cave_upper_ramp);		
		sleep(5);
	sleep_until(volume_test_players( tv_e6_m3_tower_main ), 1);					
			b_e6_m3_goal_found = TRUE;
	sleep_until( b_e6_m3_interior_fore_cleared, 1 );
			thread( f_e6_m3_event7_stop() );
			sleep_s(2);
			if objects_distance_to_flag(Players(), flg_e6_m3_tower ) > 40 then
				vo_e6m3_near_terminal();
			else
			 vo_e6m3_near_terminal_close() ;
			end
			
			f_new_objective("e6_m3_get_secrets");
			b_e6_m3_goal_ready = TRUE;
			spops_unblip_flag( flg_e6_m3_tower );
			object_create(dm_e6_m3_goal_switch);
			sleep(1);
			e6_m3_activate_button_sequence_forerunner( dc_e6_m3_int_term_03, dm_e6_m3_goal_switch, flg_e6_m3_goal );
				//sleep(15);
				//hud_play_pip_from_tag (levels\dlc\shared\binks\sp_g01_60);
				thread( vo_e6m3_soundstory() );
				sleep(1);
				spops_ai_garbage_kill( sq_e6_m3_int_bishop_sharders, 5, 5 );
				thread( f_e6_m3_event8_start() );
				
				b_e6m3_plans_retrieved = TRUE;
				f_create_new_spawn_folder (97);
				spops_ai_garbage_kill( sg_e6_m3_interior_zealots_1, 5, 10 );
				
				
				sleep_s(3);
				f_clear_spops_objectives();
				f_new_objective("e6_m3_get_exit_cave");
				
				
				//sleep_s(15);		
				dprint("GTFO");
				local long l_timer = timer_stamp( 20 ); 
				
	sleep_until( timer_expired(l_timer) or volume_test_players( tv_e6_m3_cavern_exit_interior ) or b_e6_m3_phantom_int_done or volume_test_players( tv_e6_m3_cavern_main_exit ), 1 ); 
		spops_blip_flag(flg_e6_m3_main_tunnel_exit);
		
	sleep_until(volume_test_players( tv_e6_m3_cavern_main_exit ),1);
		thread( e6_m3_interior_covies() );
		spops_unblip_flag( flg_e6_m3_main_tunnel_exit);
	sleep_until( b_e6_m3_phantom_int_done, 1 );
		sleep_s(6);
		f_clear_spops_objectives();
		f_new_objective("e6_m3_open_door");
		
		e6_m3_activate_button_sequence_main_exit();
		sleep(5);
		//e6_m3_activate_button_sequence( cavern_fdoor_dc_in, cavern_fdoor_button_in, FALSE );
		local long l_timer_2 = timer_stamp( 12 );  
		sleep_until( not PreparingToSwitchZoneSet() or timer_expired(l_timer_2), 1 );
		
		switch_zone_set( "e6_m3_ext_2" );	

		//spops_zoneset_prepare_and_load("e6_m3_ext_2");
			device_set_power(cavern_front_door, 1);
			device_set_position(cavern_front_door, 1);
			
			b_e6_m3_cavern_exit_open = TRUE;
		
			f_create_new_spawn_folder (98);
	//
end

script static void e6_m3_turn_on_grav_lifts()
		object_destroy( e6_m3_grav_lift_1_off );
		object_destroy ( e6_m3_grav_lift_2_off );
		object_create( e6_m3_grav_lift_1_on );
		object_create (e6_m3_grav_lift_2_on );
end

script static void e6_m3_cleanup_turrets()

		if ai_living_count( sq_e6_m3_int_turret_2_2) > 0 then
			object_dissolve_from_marker( ai_vehicle_get( sq_e6_m3_int_turret_2_2.xcom ), 'incineration', 'fx_glow' );
		end
		if ai_living_count( sq_e6_m3_int_turret_2_1 ) > 0 then
			object_dissolve_from_marker( ai_vehicle_get( sq_e6_m3_int_turret_2_1.xero ), 'incineration', 'fx_glow' );
		end
		
		sleep_s(5);
		ai_erase(sq_e6_m3_int_turret_2_2);
		ai_erase(sq_e6_m3_int_turret_2_1);
		//f_ai_garbage_kill( sq_e6_m3_int_turret_2_2, 0.5, 0.5, -1, -1, FALSE );
		//f_ai_garbage_kill( sq_e6_m3_int_turret_2_1, 0.5, 0.5, -1, -1, FALSE );

end

script static void e6_m3_interior_covies()
	//sleep_until(e6m3_narr_clear(), 1);
		//vo_e6m3_fight_out();
	sleep_until(e6m3_narr_clear(), 1);
		//sleep_s(5);
		vo_e6m3_fight_waves();	
end

script static void e6_m3_interior_light_bridge_vo()
	sleep_until(e6m3_narr_clear(), 1);
		vo_e6m3_switch_moved();

end

script static void e6_m3_camo_surprise()
	sleep_until(volume_test_players(tv_e6_m3_surprise),1);
		thread(f_e6_m3_event4_stop());
			ai_place( sq_e6_m3_int_grunts_3 );
			sleep(2);
			ai_place( sq_e6_m3_int_grunts_5 );
			sleep(2);
			ai_place( sq_e6_m3_int_grunts_6 );
		sleep_until( e6m3_narr_clear(), 1 );
			thread( vo_e6m3_zealots() );
			
			ai_place( sg_e6_m3_interior_zealots_1 );
			sleep(45);			
			
			ai_place( sq_e6_m3_int_zealot_surprise );
			thread( f_e6_m3_stinger_zealot());

end

//ai_is_attacking( sq_e6_m3_int_zealot_surprise );
script static void e6_m3_interior_spawns()

		b_end_player_goal = true;
		dprint("placing zealots by tagobo");
		
		sleep_until( b_e6_m3_light_bridge_activated , 1 );
			ai_place( sq_e6_m3_sniper_top );
			sleep_s( 2 );
			ai_place_in_limbo(sq_e6_m3_int_ranger_1_tower);
			sleep(15);
			ai_place_in_limbo(sq_e6_m3_int_ranger_4);
			ai_place_in_limbo(sq_e6_m3_int_ranger_7);
			sleep(2);
			ai_place_in_limbo(sq_e6_m3_int_ranger_5);
			sleep(15);
			ai_place_in_limbo(sq_e6_m3_int_ranger_3);
			
			sleep(25);
			ai_place_in_limbo(sq_e6_m3_int_ranger_6_a);
			sleep(4);
			ai_place_in_limbo(sq_e6_m3_int_ranger_6_b);
			sleep(8);
			ai_place_in_limbo(sq_e6_m3_int_ranger_6_c);
			sleep(15);
			ai_place_in_limbo(sq_e6_m3_int_ranger_2);
			sleep(15);
			ai_place_in_limbo(sq_e6_m3_int_ranger_8);
			
			ai_place_with_birth(sq_e6_m3_int_bishop_1);
			ai_place_with_birth(sq_e6_m3_int_bishop_2);
			ai_place_with_birth(sq_e6_m3_int_bishop_3);
			ai_place_with_birth(sq_e6_m3_int_bishop_4);

			
			wake( e6_m3_interior_turrets_defend );
			sleep_s( 10 );
			wake( e6_m3_interior_for_defend_fill );
			
		sleep_until( b_e6m3_plans_retrieved , 1 );
			dprint("PLANS RETRIEVED");
			spops_ai_garbage_kill( sg_e6_m3_interior_zealots_1, 20, 20 );
			sleep(1);
			//thread(e6_m3_interior_phantom_reinforcer());
			sleep(2);
			ai_place( sq_e6_m3_int_fore_commander );
			sleep_s(5);
			thread( e6_m3_perf_saver() );
			thread(e6_m3_boo_loader());
			sleep_s(5);
			thread( e6_m3_interior_interior_knight_filler() );

	sleep_until( b_e6_m3_cavern_exit_open , 1 );
		spops_ai_garbage_kill( sg_e6_m3_interior_fore, 20, 22.5);
		spops_ai_garbage_kill( sg_e6_m3_interior_zeal_intro, 20, 22.5 );
		spops_ai_garbage_kill( sg_e6_m3_interior_zealots_1, 20, 22.5 );
		spops_ai_garbage_kill( sq_e6_m3_jackals_snipers_2, 20, 22.5 );
		spops_ai_garbage_kill( sq_e6_m3_jackals_1, 20, 22.5 );
		spops_ai_garbage_kill( sg_e6_m3_interior_grunts_intro, 15, 20 );
		//spops_ai_garbage_kill( sq_e6_m3_int_grunts_rockets, 20, 22.5 );
		
		//ai_set_objective(sg_e6_m3_interior_zealots_1, obj_e6_m3_ext_1 );
		ai_set_objective(sq_e6_m3_jackals_1, obj_e6_m3_ext_2 );
		ai_set_objective(sq_e6_m3_int_grunts, obj_e6_m3_ext_2 );
		ai_set_objective(sq_e6_m3_int_grunts_2, obj_e6_m3_ext_2 );
		ai_set_objective(sg_e6_m3_interior_zealots_1, obj_e6_m3_ext_2 );
		ai_set_objective(sg_e6_m3_interior_zeal_intro, obj_e6_m3_ext_2 );
		ai_set_objective(sg_e6_m3_interior_fore, obj_e6_m3_ext_2 );
		ai_set_objective(sq_e6_m3_int_grunts_rockets, obj_e6_m3_ext_2 );
		ai_set_objective( sg_e6_m3_interior_grunts_intro , obj_e6_m3_ext_2 );

end

global boolean b_e6_m3_fortress_fight_begin = FALSE;
script static void e6_m3_shard_fortress()

	sleep_until( volume_test_players( tv_e6_m3_fortress_shard ), 1 );
		//ai_vehicle_exit ( sg_e6_m3_interior_grunts_intro );
		thread( f_e6_m3_event5_stop() );
		f_create_new_spawn_folder (89);
		ai_place(sq_e6_m3_int_bishop_sharders);
		ai_place(sq_e6_m3_int_bishop_sharders_2);
		sleep_s(1);
		ai_place_in_limbo(sq_e6_m3_int_knight_intro);
		ai_place_with_shards(sq_e6_m3_int_turret_2_1);
		sleep(5);
		ai_place_with_shards(sq_e6_m3_int_turret_2_2);
		thread( f_e6_m3_event6_start() );
	
		sleep_s(2);
		//thread( vo_glo15_miller_prometheans_01() );
		ai_place_in_limbo(sq_e6_m3_int_fore_knights_3);
		sleep_until(e6m3_narr_clear(), 1);
			 vo_e6m3_switch_ambush();	
			 b_e6_m3_fortress_fight_begin = TRUE;			
end

global boolean b_e6_m3_tower_reserves = FALSE;

script dormant e6_m3_interior_for_defend_fill()

			sleep_until( ai_living_count( sg_e6_m3_interior_fore ) <= 5,1 );
				ai_place_in_limbo( sq_e6_m3_int_ranger_2_tower );
				
				//sleep_s(2);
				b_e6_m3_tower_reserves = TRUE;
			sleep_until( ai_living_count( sg_e6_m3_interior_fore ) <= 3,1 );
					if ai_living_count(sq_e6_m3_int_ranger_1_tower ) == 0 then
						ai_place_in_limbo( sq_e6_m3_int_ranger_1_tower );		
					elseif 	ai_living_count(sq_e6_m3_int_ranger_4 )	== 0 then
						ai_place_in_limbo( sq_e6_m3_int_ranger_4 );
					elseif  	ai_living_count(sq_e6_m3_int_ranger_5 )	== 0 then
						ai_place_in_limbo( sq_e6_m3_int_ranger_5 );
					elseif  	ai_living_count(sq_e6_m3_int_ranger_7 )	== 0 then
						ai_place_in_limbo( sq_e6_m3_int_ranger_7 );
					elseif  	ai_living_count(sq_e6_m3_int_ranger_8 )	== 0 then
						ai_place_in_limbo( sq_e6_m3_int_ranger_8 );
					end
			
			sleep_s(1);
			ai_place( sq_e6_m3_int_ranger_9	);
			sleep_s(4);
			
			sleep_until( ai_living_count( sg_e6_m3_interior_fore ) <= 4 ,1 );//or b_e6_m3_goal_found
					
					sleep_until( e6m3_narr_clear(), 1 );
						sleep_s( 3 );
						vo_glo15_miller_few_more_04();
						f_blip_ai_cui( sg_e6_m3_interior_fore, "navpoint_enemy" );
			sleep_until( ai_living_count( sg_e6_m3_interior_fore ) <= 0,1 );
					b_e6_m3_interior_fore_cleared = TRUE;
end

script dormant e6_m3_interior_turrets_defend()

		dprint("no");
		//ai_place(sq_e6_m3_int_turret_1);
end

script dormant e6_m3_interior_for_defend_bishop()
	sleep_until(volume_test_players( tv_e6_m3_tower ) or ai_living_count( sg_e6_m3_interior_fore ) <= 5, 1);
		ai_place( sq_e6_m3_int_bishop_guards );	
	
end

script static void e6_m3_interior_interior_knight_filler()
//	sleep_until( b_e6_m3_phantom_int_done or , 1 );
		//dprint("phantom done dropping");
	//sleep_until(  ai_living_count( sg_e6_m3_interior_all ) + ai_living_count( sg_e6_m3_reinforce_all ) <= 4 , 1);
		sleep_until( spops_ai_population() <= 12, 1);
			if not b_e6_m3_cavern_exit_open then			
					dprint("spawning knights 1 ");
					ai_place_in_limbo(sq_e6_m3_int_fore_knights);					
			end					
			sleep_s(1);
			thread( e6_m3_perf_saver() );
	sleep_until( ai_living_count( sg_e6_m3_interior_all ) + ai_living_count( sg_e6_m3_reinforce_all )  <= 5, 1);			
			if not b_e6_m3_cavern_exit_open then	
				dprint("spawning knights 2 and 3 ");
				ai_place_in_limbo(sq_e6_m3_int_fore_knights_2);

			end

end

script static void e6_m3_interior_phantom_reinforcer()

	sleep_until(sleep_until( ai_living_count( sg_e6_m3_interior_all ) <= 11 , 1));
			if not b_e6_m3_cavern_exit_open then
				dprint("spawning phantom interior");
				ai_place( sq_e6_m3_phantom_01_int );
				sleep(3);
				spops_ai_population_extra_cnt_phantom( sq_e6_m3_phantom_01_int );
			else
				dprint("didn't added interior phantom");
				b_e6_m3_interior_phantom_ignored = TRUE;
			end

end
//
////////////////////////////////////////////////////
//	EXTERIOR 2
////////////////////////////////////////////////////

script static void 	debug_exterior_2()

	thread(e6_m3_boo_loader());
	device_set_power(cavern_front_door, 1);
	device_set_position(cavern_front_door, 1);
	b_e6_m3_cavern_exit_open = TRUE;
end

script dormant e6_m3_caverns_ext_outro_setup()

		thread( e6_m3_phantom_spawns() );		
		wake( e6_m3_caverns_ext_outro_objectives );
end

script dormant e6_m3_caves_out_vo()
 	sleep_until( e6m3_narr_clear(), 1 );			
		vo_e6m3_exfil();
		f_new_objective("e6_m3_clear_area");
		sleep_s(3);
		wake( e6_m3_extraction_blip );
end

script dormant e6_m3_caverns_ext_outro_objectives()

	sleep_until( b_e6_m3_cavern_exit_open ,1);	
		//ai_place( sq_e6_m3_phantom_01 );

		dprint("==== start exterior 2 ===");
		//thread (story_blurb_add("other", "Extraction on the way at this location.  Make sure lz is clear. We don't want them witnessing our super secret phantom"));		
		

		//door opens
		//hold out for extraction
		sleep_s(13);
		sleep_until(b_e6m3_exterior_2_final_spawn_done and ai_living_count(sg_e6_m3_all) <= 3);
			sleep_until( e6m3_narr_clear(), 1 );	
				vo_glo15_miller_few_more_02();
				f_blip_ai_cui( sg_e6_m3_all, "navpoint_enemy" );
			//f_blip_ai_cui( sg_e6_m3_reinforce_all, "navpoint_enemy" );
		sleep_until(ai_living_count(sg_e6_m3_all) <= 0 , 1);
			thread( f_e6_m3_event8_stop() );
			sleep_s(2);
			 sleep_until( e6m3_narr_clear(), 1 );			 
				vo_glo15_miller_attaboy_03();
		sleep_until( e6m3_narr_clear(), 1 );
			sleep_s(2);
			
			ai_place( sq_phantom_unsc_out );
			//sleep_s(5);
			
			//sleep_until(b_e6_m3_pickup_ready, 1);
			sleep_until( b_e6_m3_pickup_ready, 1);
			
			sleep_until( object_valid(dm_e6m3_grav_lift) ,1 );
			sleep(1);
			spops_blip_object( dm_e6m3_grav_lift, TRUE, "default" );
			sleep_until( (objects_distance_to_object(Players(),dm_e6m3_grav_lift) <= 0.45 and objects_distance_to_object(Players(),dm_e6m3_grav_lift) >= 0.1 )  or volume_test_players( tv_e6_m3_win ), 1);
			thread( f_e6_m3_music_stop());
			
			f_e6_m3_win();
end

script static void e6_m3_int_shade_get_on_it()

	ai_vehicle_enter( sq_e6_m3_int_grunts, veh_e6_m3_shade_1 );
	ai_vehicle_enter( sq_e6_m3_int_grunts_2, veh_e6_m3_shade_1 );
end

script dormant e6_m3_extraction_blip()
		f_blip_flag( flg_e6_m3_extraction, "default" );
		sleep_until(objects_distance_to_flag( Players(),flg_e6_m3_extraction ) <= 20.00, 1);	
			f_unblip_flag( flg_e6_m3_extraction );
end

script static void e6_m3_boo_loader()

	//sleep_until( ai_living_count(sg_e6_m3_all) <= 10 or b_e6_m3_cavern_exit_open, 1);
		dprint("boo loader");
		ai_place(sq_e6_m3_phantom_boo);
end

script static void e6_m3_phantom_spawns()
	sleep_until(b_e6m3_phantom_boo_done and ai_living_count( sg_e6_m3_all) <= 6, 1);
		sleep_s(4);
		ai_place( sq_e6_m3_phantom_01 );
		dprint("phantom 1 pod");
		

	sleep_until(b_e6m3_phant_drop_tower_done and ai_living_count( sg_e6_m3_all ) <= 4 , 1);
		thread( e6_m3_clear_int_grunts() );
	
		dprint("phantom 2 heavy");
		thread( e6_m3_heavy_droppod() );

		sleep_s(2);
	sleep_until(ai_living_count( sg_e6_m3_all ) <= 5 , 1 );
		ai_place( sq_e6_m3_phantom_02 );
		sleep_s(5);
		//b_e6m3_exterior_2_final_spawn_done = TRUE;
end

script static void e6_m3_clear_int_grunts()
	sleep_until(b_e6m3_phant_drop_tower_done, 1);
		spops_ai_garbage_kill( sq_e6_m3_int_grunts, 12, 12);
		spops_ai_garbage_kill( sq_e6_m3_int_grunts_2, 12, 12 );
end

script static void e6_m3_heavy_droppod()

		ai_place_in_limbo (sq_e6_m3_jackals_1);
		ai_place_in_limbo (sq_e6_m3_jackals_2);
		ai_place_in_limbo (sq_e6_m3_grunts_dropped);
		//thread (f_dlc_load_drop_pod (dm_e6_m3_drop_2, sq_e6_m3_grunts_dropped, sg_e6_m3_jackals,obj_drop_pod_2));
		thread (f_dlc_load_drop_pod (dm_e6_m3_drop_2, sq_e6_m3_jackals_1, sq_e6_m3_jackals_2,obj_drop_pod_2));



		ai_set_objective(sq_e6_m3_jackals_1, obj_e6_m3_ext_2);
		
		ai_set_objective(sq_e6_m3_jackals_snipers_1, obj_e6_m3_ext_2);
		ai_set_objective(sq_e6_m3_jackals_snipers_2, obj_e6_m3_ext_2);
		ai_set_objective( sq_e6_m3_grunts_dropped, obj_e6_m3_ext_2 );
		ai_set_objective(sq_e6_m3_jackals_2, obj_e6_m3_ext_2);
		sleep_s(1);
		thread( vo_glo15_dalton_droppods_02() );

		sleep_s(11);

		thread (f_dlc_load_drop_pod (dm_e6_m3_drop_2, sq_e6_m3_grunts_dropped, NONE,obj_drop_pod_2));

end

/////////////////////////////////////////
//	DESIGNER ZONE SWITCH
/////////////////////////////////////////
script dormant e6_m3_caverns_streaming()

	sleep_until(b_e6_m3_side_barrier_down,1);
		prepare_to_switch_to_zone_set( "e6_m3_int_1" );
	sleep_until(volume_test_players( tv_start_e6_m3_int_1 ),1);
	local long l_timer = timer_stamp( 8 );  
	sleep_until( not PreparingToSwitchZoneSet() or timer_expired(l_timer), 1 );
		switch_zone_set("e6_m3_int_1");
		sleep(1);
		b_e6_m3_interior_loaded = TRUE;
	sleep_until( b_e6_m3_front_door_ics_done, 1 );
		prepare_to_switch_to_zone_set( "e6_m3_ext_2" );
	//sleep_until(  b_e6_m3_cavern_exit_open ,1);		
		//switch_zone_set("e6_m3_ext_2");

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

global boolean b_e6_m3_activate_all_stealthlots = FALSE;

script command_script cs_active_camo_use_wait()
	local object obj_actor = ai_get_object( ai_current_actor );
	if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
		dprint( "cs_active_camo_use: ENABLED" );
		thread( f_active_camo_manager(ai_current_actor) );
		sleep_until( objects_distance_to_object(Players(),obj_actor) <= 15 or b_e6_m3_activate_all_stealthlots or f_ai_is_aggressive( ai_current_actor ), 1 );
		dprint("leaving dumb stealth");
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
		sleep_until( (unit_get_health(ai_actor) <= 0.0) or   objects_distance_to_object(Players(),obj_actor) <= 6.5  or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.1), 3 );
		if ( unit_get_health(ai_actor) > 0.0 ) then
			ai_set_active_camo( ai_actor, FALSE );
			dprint( "f_active_camo_manager: DISABLED" ); 
		end
		
		// manage resetting
		if ( unit_get_health(ai_actor) > 0.0 ) then
			l_timer = timer_stamp( 2.5, 5.0 );
			sleep_until( (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and unit_has_weapon_readied(ai_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (objects_distance_to_object(Players(),obj_actor) >= 4.0) and (not objects_can_see_object(Players(),obj_actor,25.0))), 1 );
		end
		if ( unit_get_health(ai_actor) > 0.0 ) then
			dprint( "f_active_camo_manager: RESET" ); 
		end
	
	until ( unit_get_health(ai_actor) <= 0.0, 1 );

end



script command_script cs_e6_m3_camo_special()
	
		sleep(1);
		//ai_exit_limbo(ai_current_actor);
		ai_set_active_camo( ai_current_actor, TRUE );
		
		
		//thread( f_e6_m3_flash_camo( ai_current_actor ) );
		cs_move_towards_point ( ps_e6m3_main.p1 , 1.0);
		cs_face( TRUE,ps_e6m3_main.p13 );
		sleep(15);
		cs_face( FALSE,ps_e6m3_main.p13);
		sleep(15);
		ai_set_active_camo( ai_current_actor, FALSE );
		
		/*
		cs_move_towards_point ( ps_e6m3_main.p5 , 1.0);
		cs_abort_on_damage( TRUE );
		cs_move_towards_point ( ps_e6m3_main.p6 , 1.0);
		cs_face( FALSE,ps_e6m3_main.p6);
		*/
		
	thread( f_active_camo_manager(ai_current_actor) );
end


script command_script cs_e6_m3_camo_special_d_1()
	
		//sleep(1);
		//ai_exit_limbo(ai_current_actor);
		ai_set_active_camo( ai_current_actor, TRUE );
		
		
		//thread( f_e6_m3_flash_camo( ai_current_actor ) );
		//cs_move_towards_point ( ps_e6m3_main.p0 , 1.0);
		cs_face( TRUE,ps_e6m3_main.p0 );
		//sleep(15);
		//cs_face( FALSE,ps_e6m3_main.p1);
		
		cs_move_towards_point ( ps_e6m3_main.p0 , 1.0);
		//cs_abort_on_damage( TRUE );
		cs_face( TRUE,ps_e6m3_main.p2 );
		cs_move_towards_point ( ps_e6m3_main.p2 , 1.0);
		cs_face( TRUE,ps_e6m3_main.p7 );
		begin_random_count(1)
			cs_move_towards_point ( ps_e6m3_main.p7 , 1.0);
			cs_move_towards_point ( ps_e6m3_main.p10 , 1.0);
			cs_move_towards_point ( ps_e6m3_main.p11 , 1.0);
		//cs_abort_on_damage( TRUE );
		end
		cs_face( TRUE,ps_e6m3_main.p1);
		sleep_s(3);
		cs_run_command_script(ai_current_actor, cs_active_camo_use_wait);
	//thread( f_active_camo_manager(ai_current_actor) );
end

script command_script cs_e6_m3_camo_special_d_2()
	
		//sleep(1);
		//ai_exit_limbo(ai_current_actor);
		ai_set_active_camo( ai_current_actor, TRUE );
		sleep(15);
		ai_teleport(ai_current_actor,ps_e6m3_main.p12);
		
		//thread( f_e6_m3_flash_camo( ai_current_actor ) );
		//cs_move_towards_point ( ps_e6m3_main.p0 , 1.0);
		cs_face( TRUE,ps_e6m3_main.p6 );
		//sleep(15);
		//cs_face( FALSE,ps_e6m3_main.p1);
		
		cs_move_towards_point ( ps_e6m3_main.p5 , 1.0);
		//cs_abort_on_damage( TRUE );
		begin_random_count(1)
			cs_move_towards_point ( ps_e6m3_main.p4 , 1.0);
			cs_move_towards_point ( ps_e6m3_main.p8 , 1.0);
			cs_move_towards_point ( ps_e6m3_main.p9 , 1.0);
		end
		//cs_abort_on_damage( TRUE );
		cs_face( FALSE,ps_e6m3_main.p4);
		cs_face( TRUE,ps_e6m3_main.p1);
		sleep_s(3);
		cs_run_command_script(ai_current_actor, cs_active_camo_use_wait);
	//thread( f_active_camo_manager(ai_current_actor) );
end


script static void f_e6_m3_flash_camo(ai ai_actor)
		sleep_s(1.5);
		ai_set_active_camo( ai_actor, FALSE );
		sleep_s(1);
		ai_set_active_camo( ai_actor, TRUE );
end

script static void f_e6_m3_win()

	b_end_player_goal = true;
	fade_out (0,0,0,45);
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
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver), TRUE );
	//// watchtower pod cargo
	object_hide(cr_e6_m3_pod_top_1,false);
	object_set_scale( cr_e6_m3_pod_top_1, 0.8, 0 );
	object_cannot_take_damage (cr_e6_m3_pod_top_1);
	object_set_physics(cr_e6_m3_pod_top_1, FALSE);
	objects_attach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver) ,"fx_destroyed_phantom", cr_e6_m3_pod_top_1,"lift_up_biped" );
	
	
	//add ai
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver), "dual", sq_e6_m3_ext_re_elite_2, sq_e6_m3_ext_commander_3,sq_e6m3_phantom_snipers, sq_e6_m3_ext_elites_2);
	sleep(1);
	ai_set_objective(sq_e6_m3_ext_re_elite_2, obj_e6_m3_ext_2 );
	ai_set_objective(sq_e6m3_phantom_grunts, obj_e6_m3_ext_2 );
	ai_set_objective(sq_e6m3_phantom_grunts_3, obj_e6_m3_ext_2 );
	ai_set_objective(sq_e6_m3_ext_elites_2, obj_e6_m3_ext_2 );
	
	cs_fly_by (ps_e6m3_phantoms.p7);
	thread( e6_m3_phantom_drop_callout( ai_current_actor)) ;
	cs_vehicle_speed (0.75);
	cs_fly_by (ps_e6m3_phantoms.p6);
	cs_vehicle_speed (0.4);
	
	cs_fly_to_and_dock( ps_e6m3_phantoms.p0, ps_e6m3_phantoms.p1,1.5 );
	cs_vehicle_speed (0.05);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p0, ps_e6m3_phantoms.p1,0.02 );
	//
	spops_unblip_ai( ai_current_actor );
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver), "dual"));

	dprint("settle");
	//object_set_phantom_power(e6_m3_cov_base_01, TRUE );	
	sleep_s( 1.5 );	
	

	object_set_physics (cr_e6_m3_pod_top_1, TRUE);
	objects_detach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver),cr_e6_m3_pod_top_1);
	object_set_scale( cr_e6_m3_pod_top_1, 0.93, 90 );
	sleep_s(1);
	thread( e6m3_tower_drop_helper() );
	sleep_s( 2 );
			
	object_set_scale( cr_e6_m3_pod_top_1, 1, 60 );
	sleep_until(not isthreadvalid(l_drop_1), 1);
		
		sleep_s( 3 );	
		object_can_take_damage (cr_e6_m3_pod_top_1);
		cs_vehicle_speed (0.5);
		cs_fly_by (ps_e6m3_phantoms.p2);
		cs_vehicle_speed (1);
		b_e6m3_phant_drop_tower_done = TRUE;
		object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01.driver), FALSE );
		cs_fly_by (ps_e6m3_phantoms.p3);
		cs_fly_by (ps_e6m3_phantoms.p4);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e6m3_phantoms.p5);
		sleep_s(5);
	
		ai_erase (sq_e6_m3_phantom_01);
end


script static void e6_m3_phantom_drop_callout(ai phant)
	sleep(15);
	sleep_until( e6m3_narr_clear(), 1 );
		sleep_s(2);
		vo_glo15_dalton_phantom_02();
		spops_blip_ai( phant, TRUE, "enemy_vehicle" );
	sleep_until( e6m3_narr_clear(), 1 );
		sleep_s(3.5);
	thread( vo_glo15_miller_reinforcements_02() );
end	
	
script static void e6m3_tower_drop_helper()
		//dprint("mommas little helper");
	sleep_until( e6m3_narr_clear(), 1 );
		//object_move_to_point(cr_e6_m3_pod_top_1, 1, ps_e6m3_main.tower_top);
end

script command_script cs_e6_m3_phantom_drop_int_1()
	dprint("phantom droop");
	local long l_drop_1 = -1;
	b_e6_m3_interior_phantom_start = TRUE;
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), TRUE );
	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ), 0 , ps_e6m3_phantoms.p12 );
	
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30*2.5);
	//// watchtower pod cargo
	object_create(veh_e6_m3_shade_1);
	sleep(1);
	objects_attach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver) ,"fx_destroyed_phantom", veh_e6_m3_shade_1,"garbage1" );
	
	//add ai
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), "dual", sq_e6_m3_int_grunts_2, sq_e6_m3_int_grunts, NONE, sq_e6_m3_jackals_snipers_2);
	sleep(1);

	ai_set_objective(sq_e6_m3_jackals_snipers_2, obj_e6_m3_int_2 );
	ai_set_objective(sq_e6_m3_int_grunts, obj_e6_m3_int_2 );
	ai_set_objective(sq_e6_m3_int_grunts_2, obj_e6_m3_int_2 );	
	cs_fly_by (ps_e6m3_phantoms.p8);
	
	if e6m3_narr_clear() then
		thread( vo_glo15_palmer_contacts_07() );
	end
	
	spops_blip_ai( ai_current_actor, TRUE, "enemy_vehicle" );
	cs_vehicle_speed (0.9);
	cs_fly_by (ps_e6m3_phantoms.p11);
	cs_vehicle_speed (0.5);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p9, ps_e6m3_phantoms.p21,10 );
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p9, ps_e6m3_phantoms.p11,0.25 );
	//
	spops_unblip_ai( ai_current_actor );
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), "dual"));

	sleep_s(2);
	objects_detach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver),veh_e6_m3_shade_1);
	sleep(1);
	thread( e6_m3_rotate_this());
	object_move_to_point(veh_e6_m3_shade_1, 0.75, ps_e6m3_phantoms.pturret);

	sleep_until(not isthreadvalid(l_drop_1), 1);
		b_e6_m3_phantom_int_done = TRUE;
		//f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), "left", sq_e6_m3_int_grunts_rockets, sq_e6_m3_jackals_1, NONE, NONE);
		thread( e6_m3_int_shade_get_on_it() );
		object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), FALSE );
		//sleep_s(5);
		//ai_set_objective(sq_e6_m3_jackals_1, obj_e6_m3_int_push );
		//ai_set_objective(sq_e6_m3_int_grunts_rockets, obj_e6_m3_int_push );
		cs_vehicle_speed (0.75);
		if volume_test_players(tv_e6_m3_tower) then
			cs_fly_to( ps_e6m3_phantoms.pdump_2 );
			sleep_s(3);
		end
		cs_vehicle_speed (0.5);

		//cs_fly_to_and_dock( ps_e6m3_phantoms.pdump_2, ps_e6m3_phantoms.p20,0.25 );
		//f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_01_int.driver), "left");
		//sleep_s(2);
		local short spot_count = 0;
		cs_vehicle_speed (0.7);
		repeat
			begin_random
			
				begin
					sleep_rand_s( 1, 3 );
					cs_fly_to_and_face( ps_e6m3_phantoms.p11, ps_e6m3_phantoms.p20);
					spot_count = spot_count + 1 ;
				end
				
				begin
					sleep_rand_s( 1, 3 );
					cs_fly_to_and_face( ps_e6m3_phantoms.p26, ps_e6m3_phantoms.p20);
					spot_count = spot_count + 1 ;
				end
				
				
				begin
					sleep_rand_s( 1, 3 );
					cs_fly_to_and_face( ps_e6m3_phantoms.p28, ps_e6m3_phantoms.p20);
					spot_count = spot_count + 1 ;
				end
				
				begin
					sleep_rand_s( 1, 3 );
					cs_fly_to_and_face( ps_e6m3_phantoms.p29, ps_e6m3_phantoms.p20);
					spot_count = spot_count + 1 ;
				end
			end
			sleep_s(1);
		until( ( not volume_test_players(tv_e6_m3_tower) and spot_count > 2 ) or e6m3_chin_gun_is_gone(ai_vehicle_get( ai_current_actor )) or e6_m3_phantom_int_gunners_dead(),1 );
		
		//sleep_until( not volume_test_players(tv_e6_m3_tower), 1);
			sleep_rand_s( 1, 4 );
			cs_fly_by (ps_e6m3_phantoms.p11);
			cs_vehicle_speed (1);
	
			cs_fly_by (ps_e6m3_phantoms.p8);
			object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
			cs_fly_by (ps_e6m3_phantoms.p12);
			sleep_s(5);
		
			ai_erase (sq_e6_m3_phantom_01_int);
end

script static boolean e6_m3_phantom_int_gunners_dead()
	if ai_living_count(sq_e6_m3_phantom_01_int.gunner_1) + ai_living_count(sq_e6_m3_phantom_01_int.gunner_2) == 0 then
		TRUE;
	else
		FALSE;
	end
end

script static void e6_m3_rotate_this()
 object_rotate_by_offset(veh_e6_m3_shade_1, 0.25, 0.25,0.25,0,15,0);
end;

global object e6_m3_phantom_hunter = NONE;
global boolean b_e6_m3_phantom_hunter_drop = FALSE;

script command_script cs_e6_m3_phantom_heavy()
	dprint("phantom droop");
	local long l_drop_1 = -1;
	local long l_drop_2 = -1;
	local long l_pup_1 = -1;
	local long l_pup_2 = -1;
	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 0 );
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver), TRUE );
	ai_place( sq_e6_m3_hunter_1 );
	e6_m3_phantom_hunter = sq_e6_m3_hunter_1.magic;
	pup_play_show(pup_e6_m3_phantom_hunter);
	sleep(1);
	e6_m3_phantom_hunter = sq_e6_m3_hunter_1.johnson;
	pup_play_show(pup_e6_m3_phantom_hunter);
	
	objects_attach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver) ,"small_cargo01", sq_e6_m3_hunter_1.magic,"" );
	objects_attach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver) ,"small_cargo02", sq_e6_m3_hunter_1.johnson,"" );
//
	//add ai
	//f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver), "dual", sq_e6_m3_ext_commander_2, sq_e6m3_phantom_grunts, sq_e6_m3_jackals_carb, NONE);
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver), "dual", sq_e6_m3_ext_commander_2, sq_e6_m3_jackals_carb, NONE , NONE);
	sleep(1);
	ai_set_objective(sq_e6_m3_ext_commander_2, obj_e6_m3_ext_2 );
	ai_set_objective(sq_e6m3_phantom_grunts, obj_e6_m3_ext_2 );
	ai_set_objective(sq_e6_m3_jackals_carb, obj_e6_m3_ext_2 );
	cs_fly_by (ps_e6m3_phantoms.p7);
	thread( vo_glo15_dalton_phantom_01() );
	spops_blip_ai( ai_current_actor, TRUE, "enemy_vehicle" );
	cs_vehicle_speed (0.75);
	cs_fly_by (ps_e6m3_phantoms.p6);
	cs_vehicle_speed (0.4);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p17, ps_e6m3_phantoms.p18,1.5 );
	cs_vehicle_speed (0.20);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p17, ps_e6m3_phantoms.p18,0.25 );
	//
	spops_unblip_ai( ai_current_actor );
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver), "dual"));

	dprint("settle");


	objects_detach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver) , sq_e6_m3_hunter_1.magic );
	objects_detach(ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver) , sq_e6_m3_hunter_1.johnson );
	b_e6_m3_phantom_hunter_drop = TRUE;
	thread(f_e6_m3_stinger_hunters() );

	
	sleep(1);
	pup_stop_show( l_pup_1 );
	pup_stop_show( l_pup_2 );
	//vehicle_unload( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver), "phantom_sc01" );

	sleep_until(not isthreadvalid(l_drop_1), 1);
		thread( vo_glo15_miller_hunters_01() );
		object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_02.driver), FALSE );	
		b_e6m3_exterior_2_final_spawn_done = TRUE;
		b_e6_m3_phantom_hunter_drop = TRUE;
		cs_vehicle_speed (0.5);
		cs_fly_by (ps_e6m3_phantoms.p2);
		cs_vehicle_speed (1);
		cs_fly_by (ps_e6m3_phantoms.p3);
		cs_fly_by (ps_e6m3_phantoms.p4);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e6m3_phantoms.p5);
		sleep_s(5);
	
		ai_erase (sq_e6_m3_phantom_02);
end

script command_script cs_e6_m3_phantom_intro_rein()
	//dprint("phantom droop");
	local long l_drop_1 = -1;
	local long l_drop_2 = -1;

	cs_vehicle_speed_instantaneous ( 1.0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.25, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ), 0, ps_e6m3_main.phantom_intro);
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30*4);
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_intro.driver), TRUE );	

	//add ai
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_intro.driver), "dual", sq_e6_m3_ext_commander_2, sq_e6_m3_ext_re_grnt_1,sq_e6_m3_ext_re_elite_2, sq_e6_m3_ext_elites_1);
	
	sleep(1);	
	ai_set_objective(sq_e6_m3_ext_commander_2, obj_e6_m3_ext_1 );
	ai_set_objective(sq_e6_m3_ext_re_grnt_1, obj_e6_m3_ext_1 );
	ai_set_objective(sq_e6_m3_ext_re_elite_2, obj_e6_m3_ext_1 );
	//ai_set_objective(sq_e6_m3_ext_re_zeal_1, obj_e6_m3_ext_1 );
	//cs_fly_by (ps_e6m3_phantoms.p7);
	
	cs_fly_by (ps_e6m3_phantoms.p27);
	spops_blip_ai( ai_current_actor, TRUE, "enemy_vehicle" );
	cs_vehicle_speed (0.75);
	cs_fly_by (ps_e6m3_phantoms.p6);
	
	cs_vehicle_speed (0.4);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p16, ps_e6m3_phantoms.p1,1.5 );
	cs_vehicle_speed (0.20);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p16, ps_e6m3_phantoms.p1,0.25 );
	//
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_intro.driver), "dual"));

	dprint("settle");
	//sleep_s(2);
	spops_unblip_ai( ai_current_actor);
	sleep_until(not isthreadvalid(l_drop_1), 1);
		b_e6_m3_ext_intro_done = TRUE;
		object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_intro.driver), FALSE );	
		cs_vehicle_speed (0.5);
		cs_fly_by (ps_e6m3_phantoms.p2);
		cs_vehicle_speed (1);
		cs_fly_by (ps_e6m3_phantoms.p3);
		cs_fly_by (ps_e6m3_phantoms.p4);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e6m3_phantoms.p5);
		sleep_s(5);
	
		ai_erase (sq_e6_m3_phantom_intro);
end

script command_script cs_e6_m3_phantom_drop_boo()
	dprint("phantom droop");
	local long l_drop_1 = -1;
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	sleep(1);
	object_move_to_point( ai_vehicle_get( ai_current_actor ),0,ps_e6m3_phantoms.p27 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30*5 );
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_boo.driver), true );

	//-84.211334, 206.168716, 21.919395
	sleep(1);
	//ai_vehicle_enter(sq_e6m3_phantom_grunts_2,veh_e6_m3_shade_2 );
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_boo.driver), "dual", sq_e6m3_phantom_grunts_2,none,none, none);
	ai_set_objective(sq_e6m3_phantom_grunts_2, obj_e6_m3_ext_2 );

	//cs_fly_by (ps_e6m3_phantoms.p2);
	//cs_fly_by (ps_e6m3_phantoms.p13);
	//cs_vehicle_speed (0.75);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p16, ps_e6m3_phantoms.p13,10 );
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e6m3_phantoms.p16, ps_e6m3_phantoms.p13,0.25 );
	
	cs_face(TRUE,ps_e6m3_phantoms.p13);
	//ai_set_blind(ai_current_actor, TRUE);
	l_drop_1 = thread(f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_boo.driver), "dual"));
	sleep_until(not isthreadvalid(l_drop_1), 1);
		
	cs_fly_to_and_dock( ps_e6m3_phantoms.p14, ps_e6m3_phantoms.p13,0.25 );

	sleep_until( b_e6_m3_cavern_exit_open  , 1);
		sleep(90);
		cs_vehicle_speed (0.25);
		cs_fly_by (ps_e6m3_phantoms.p2);
		ai_set_blind(ai_current_actor, FALSE);
		cs_vehicle_speed (0.4);
		b_e6m3_phantom_boo_done = TRUE;
		object_cannot_die( ai_vehicle_get_from_spawn_point (sq_e6_m3_phantom_boo.driver), FALSE );
		cs_fly_by (ps_e6m3_phantoms.p3);
		cs_vehicle_speed (1);
		cs_face(FALSE,ps_e6m3_phantoms.p13);
		cs_fly_by (ps_e6m3_phantoms.p4);
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 5 );
		cs_fly_by (ps_e6m3_phantoms.p5);
		sleep_s(5);
	
		ai_erase (sq_e6_m3_phantom_boo);

end



script command_script cs_e6_m3_phantom_in()
	dprint("phantom in");

	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_phantom_unsc_in.driver), true );


	cs_vehicle_speed (0.30);
	sleep_until( b_e6_m3_start_gameplay, 1 );
	sleep_s(4);
	cs_face(TRUE,ps_e6m3_phantoms.p21);
	cs_fly_by (ps_e6m3_phantoms.p22);

	cs_face(TRUE,ps_e6m3_phantoms.p23);		
	cs_fly_by (ps_e6m3_phantoms.p23);
	cs_face(FALSE,ps_e6m3_phantoms.p23);		
	cs_vehicle_speed (0.6);


	cs_fly_by (ps_e6m3_phantoms.p24);
	cs_vehicle_speed (1);
	//cs_face(FALSE,ps_e6m3_phantoms.p13);
	//cs_fly_by (ps_e6m3_phantoms.p4);
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 30 * 7 );
	cs_fly_by (ps_e6m3_phantoms.p25);
	sleep_s(7);

	ai_erase (sq_phantom_unsc_in);

end


script command_script cs_e6_m3_phantom_out()
	dprint("phantom out");
	
	sleep(1);
	 
	object_cannot_die( ai_vehicle_get_from_spawn_point (sq_phantom_unsc_out.driver), true );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.1, 0 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1, 30*3);
	cs_vehicle_speed (1);
	thread( e6_m3_phantom_out_vo_objective(ai_current_actor) );
	cs_fly_by (ps_e6m3_phantom_out.p0);
	spops_blip_ai ( ai_current_actor , TRUE, "default" );
	//sleep_s(3);
	
	cs_fly_by (ps_e6m3_phantom_out.p1);
	
	cs_vehicle_speed (0.6);
	cs_fly_to_and_dock( ps_e6m3_phantom_out.pout_stop, ps_e6m3_phantom_out.p3,10 );
	
	cs_vehicle_speed (0.25);
	cs_fly_to_and_dock( ps_e6m3_phantom_out.pout_stop, ps_e6m3_phantom_out.p3,0.2 );
	
	spops_unblip_ai ( ai_current_actor );
	thread(e6_m3_attach_phantom_grav());
	b_e6_m3_pickup_ready = TRUE;
	ai_braindead( ai_current_actor, TRUE );
	sleep_until( FALSE, 1 );
end

script static void e6_m3_phantom_out_vo_objective(ai murph)
	thread( vo_e6m3_pickup() );
	sleep_s(3);
	//spops_blip_ai ( murph , TRUE, "default" );
	
	sleep_until(e6m3_narr_clear(), 1);
		f_new_objective("e6_m3_leave");
end

script static void e6_m3_attach_phantom_grav()

	effect_new_on_object_marker ( objects\vehicles\covenant\storm_lich\fx\lich_gravlift\lich_gravlift.effect, ai_vehicle_get_from_spawn_point (sq_phantom_unsc_out.driver), "lift_direction" );
	//object_hide( cr_e6m3_grav_lift, FALSE );
	object_create( dm_e6m3_grav_lift );
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_green_beam_init_mnde8298', dm_e6m3_grav_lift, m_sound, 1 ); //AUDIO!
	sleep_until(object_valid(dm_e6m3_grav_lift),1);
	//dprint("physics active");
		sleep(2);
		objects_attach(ai_vehicle_get_from_spawn_point (sq_phantom_unsc_out.driver) ,"lift_direction", dm_e6m3_grav_lift,"m_end" );
								
end
/*
script static void e6_m3_pickup_pewpew()


	
	repeat
			if e6_m3_is_landingpod_alive() then
				cs_aim_object(TRUE, e8m3_pod_1);
				cs_shoot(TRUE, e8m3_pod_1);
			end
	until( not e6_m3_is_landingpod_alive, 1);
end
*/
///////////////////////////////
// UTILITY
//////////////////////////////
script static short e6_m3_enemy_count()
	ai_living_count( sg_e6_m3_all );
end

script static void debug_e6_m3()
	dprint("debug mission");
	game_set_variant( e6_m3_caverns_recon );
end

script static void f_zone_num()
	inspect(current_zone_set_fully_active());
end

script command_script cs_knight_rider()
	//dprint("knight cs");
	cs_phase_in();

end

script command_script cs_knight_rider_charge()
	//dprint("knight cs charge");
	cs_phase_in();
	sleep_rand_s( 0, 2 );
	ai_advance_immediate(ai_current_actor);
end


script static void debug_wipe()
	ai_erase_all();
	sleep_s(2);
	ai_erase_all();
end



script static void haha()

	repeat
		unit_action_test_reset (player0);
		if unit_action_test_cancel  ( player0 ) then
			dprint("crouch");
		end
	until( false, 15 );
	

end

global boolean b_e6m3_enemycounter = FALSE;
script static void debug_e6m3_enemy_count()
	b_e6m3_enemycounter = TRUE;
	repeat		
		if ai_living_count( sg_e6_m3_all ) > 20 then
			dprint("===");
			dprint("WARNING AI COUNT LARGE:");
			inspect( ai_living_count( sg_e6_m3_all ) );
			//dprint("===");
			sleep_s(4);
		else
			dprint("===");
			dprint("AI COUNT:");
			inspect( ai_living_count( sg_e6_m3_all ) );
			//dprint("===");		
		end
	
		sleep_s(4);
	until( not b_e6m3_enemycounter, 1 );
end


script static void e6_m3_activate_button_sequence_main_dummy()
	
	f_blip_object( cavern_fdoor_dc, "activate");
	device_set_power( cavern_fdoor_dc, 1 );
	sleep_until( device_get_position( cavern_fdoor_dc ) > 0 and g_ics_player != NONE ,1 );
		//sleep(5);
		local long show = pup_play_show( pup_e6_m3_main_dummy );    
		device_set_power( cavern_fdoor_dc, 0 );
		f_unblip_object( cavern_fdoor_dc);
	
 sleep_until ( not pup_is_playing( show ), 1 );
	g_ics_player = NONE;
end

global boolean b_e6_m3_front_door_ics_done = FALSE;

script static void e6_m3_activate_button_sequence_main_exit()
	
	spops_blip_flag( flg_e6_m3_main_exit, TRUE, "activate");
	device_set_power( cavern_fdoor_dc_in, 1 );
	sleep_until( device_get_position( cavern_fdoor_dc_in ) > 0 and g_ics_player != NONE, 1 );
		wake( e6_m3_caves_out_vo ) ;
		local long show = pup_play_show(  pup_e6_m3_main_exit );    
		device_set_power( cavern_fdoor_dc_in, 0 );
		spops_unblip_flag( flg_e6_m3_main_exit );	
		
 		sleep_until ( not pup_is_playing( show ), 1 );
 			device_set_position( cavern_fdoor_button_in, 1 );
 			g_ics_player = NONE;
 			b_e6_m3_front_door_ics_done = TRUE;
//e6_m3_activate_button_sequence( cavern_fdoor_dc_in, cavern_fdoor_button_in, FALSE );
end

script static void e6_m3_activate_button_sequence_barrier( )  
	
	spops_blip_flag( flg_e6_m3_barrier, TRUE, "activate");
	device_set_power( dc_e6_m3_barrier_comp, 1 );
	
	sleep_until( device_get_position( dc_e6_m3_barrier_comp ) > 0 and g_ics_player != NONE,1);
		local long show = pup_play_show(  pup_e6_m3_barrier );
		device_set_power( dc_e6_m3_barrier_comp, 0 );
	sleep_until ( not pup_is_playing( show ), 1 );
		spops_unblip_flag( flg_e6_m3_barrier );
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm_e6_m3_barrier_switch, 1 ); //AUDIO!
		device_set_position( dm_e6_m3_barrier_switch, 1 );
		sleep(1);
	sleep_until(device_get_position(dm_e6_m3_barrier_switch) == 1, 1);
		object_hide(dm_e6_m3_barrier_switch, TRUE);
			
		g_ics_player = NONE;
		//e6_m3_activate_button_sequence( dc_e6_m3_barrier_comp, dm_e6_m3_barrier_switch, TRUE );
end




script static void e6_m3_activate_button_sequence_forerunner( device dc, device holo, cutscene_flag flg )
	local long show = -1;
	spops_blip_flag( flg, TRUE, "activate");
	device_set_power( dc, 1 );
		
	sleep_until( device_get_position( dc ) > 0 and g_ics_player != NONE ,1);
		if dc == dc_e6_m3_int_term_02 then
			show = pup_play_show ( pup_e6_m3_light_bridge );
		else
			thread(e6_m3_interior_phantom_reinforcer());
			show = pup_play_show ( pup_e6_m3_goal_extract );
		end
		device_set_power( dc, 0 );
	sleep_until ( not pup_is_playing( show ), 1 );
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_switchforlightbridge_mnde861', holo, 1 ); //AUDIO!
		device_set_position( holo, 1 );
		
		spops_unblip_flag( flg);
	sleep_until(device_get_position(holo) == 1, 1);
		device_set_power( holo, 0 );
		object_dissolve_from_marker(holo, phase_out, panel);
		g_ics_player = NONE;
end


global boolean b_e6_m3_blip_upper_ramp_on = FALSE;
global boolean b_e6_m3_blip_towermid_on = FALSE;
global boolean b_e6_m3_blip_towermain_on = FALSE;
global boolean b_e6_m3_clear_once = FALSE;
global long l_e6_m3_breadcrumb = -1;

script static void e6_m3_tower_handholding_blipage()
	l_e6_m3_breadcrumb = spops_blip_auto_flag_trigger( flg_e6_m3_cave_upper_ramp, "default", tv_e6_m3_bc_all, FALSE );
	spops_blip_auto_flag_trigger( flg_e6_m3_tower_mid, "default", tv_e6_m3_bc_begin, TRUE, l_e6_m3_breadcrumb );
	spops_blip_auto_flag_trigger( flg_e6_m3_tower, "default", tv_e6_m3_bc_mid, TRUE, l_e6_m3_breadcrumb );

	sleep_until(b_e6_m3_goal_ready,5);
		kill_thread(l_e6_m3_breadcrumb);
/*
	repeat

		if not volume_test_players(tv_e6_m3_cavern_upper_big) and
			not volume_test_players(tv_e6_m3_tower_mid) and
			not volume_test_players(tv_e6_m3_tower_main) then
			
			if not b_e6_m3_blip_upper_ramp_on then
			 b_e6_m3_blip_upper_ramp_on = TRUE;
			 spops_blip_flag( flg_e6_m3_cave_upper_ramp );
			end
			
		elseif volume_test_players(tv_e6_m3_cavern_upper_big) and
			not volume_test_players(tv_e6_m3_tower_mid) and
			not volume_test_players(tv_e6_m3_tower_main) then
			
			spops_unblip_flag( flg_e6_m3_cave_upper_ramp );
			
			if not b_e6_m3_blip_towermid_on then
			 b_e6_m3_blip_towermid_on = TRUE;
			 spops_blip_flag(flg_e6_m3_tower_mid );
			end			
			
		elseif volume_test_players(tv_e6_m3_cavern_upper_big) and
			volume_test_players(tv_e6_m3_tower_mid) and
			not volume_test_players( tv_e6_m3_tower_main ) or volume_test_players( tv_e6_m3_tower_main ) then
			sleep(5);
			spops_unblip_flag( flg_e6_m3_cave_upper_ramp );
			spops_unblip_flag( flg_e6_m3_tower_mid );
			
			if not b_e6_m3_blip_towermain_on then
			 b_e6_m3_blip_towermain_on = TRUE;
			 spops_blip_flag( flg_e6_m3_tower );
			end	
			
		else

			if not b_e6_m3_clear_once and b_e6_m3_goal_ready then
				b_e6_m3_clear_once = TRUE;
				sleep_s(1);
				dprint("clearing all flags, near goal");
				spops_unblip_flag( flg_e6_m3_cave_upper_ramp );
				spops_unblip_flag( flg_e6_m3_tower_mid );
				spops_unblip_flag( flg_e6_m3_tower );		
			end
		end		 
		
	until( b_e6_m3_goal_ready, 22);
*/
	dprint("goal blip loop existed");
end




script static void f_uplink_activator_get( object trigger, unit activator )
	dprint("uplink");
	g_ics_player = activator;
end

script static void f_extract_activator_get( object trigger, unit activator )
	dprint("extract");
	g_ics_player = activator;
end

script static void f_airstrike_activator_get( object trigger, unit activator )
	dprint("airstrike");
	g_ics_player = activator;
end


script static void e6_m3_banshee_barrier( object_name veh)
	sleep_until( object_valid( veh ) ,1 );
	repeat

			sleep_until( volume_test_objects ( tv_e6_m3_vehicle_barrier, veh) , 1 );
				 //dprint("object in volume");
				 if volume_test_objects ( tv_e6_m3_vehicle_barrier, veh ) then
				 	damage_objects(veh, "hull", 10000 );
				 	//dprint("hurt 1");
				 end

	until( not object_valid( veh ), 1 );
end

script static boolean e6m3_chin_gun_is_gone (vehicle vh_phantom)
	if(object_at_marker(vh_phantom, "chin_gun") == none)then
		true;
	else
		false;
	end
end

script static boolean e6m3_narr_clear()
	not b_narrative_is_on and not global_narrative_is_on;
end

script static void e6_m3_mancannon( object_name crate, object_name crate_fx  )
	object_create( crate );
	object_create( crate_fx );
	sleep(1);

	effect_new_on_object_marker ( levels\multi\wraparound\fx\energy\wrp_launchpad_energy_rt.effect, crate_fx, "marker_man_cannon_mp_invisible_base" );

	
end

script static void camera_shake_all_coop_players_6_3 ( real attack, real intensity, short duration, real decay, sound shake_sound)

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


script static void f_new_objective_not_pause_screen_6_3 (string_id objective_text)

	if editor_mode() then
		cinematic_set_title (new_obj);
	end
	print ("new objective HUD");
	f_objective_complete();
	f_pause_screen_complete_objectives();
	sleep(15);
	cui_hud_set_new_objective (objective_text);


end
/*
script static void f_complete_objective_6_3 (string_id objective_text)

	if editor_mode() then
		cinematic_set_title (obj_complete_text);
	end
	print ("objective complete HUD");
	cui_hud_set_objective_complete (obj_complete_text);


end
*/
//f_ai_garbage_kill( sg_right, 5, 22.5, 30, -1, FALSE );

/*
global object_name dm_droppod_1 = dm_drop_01;
global object_name dm_droppod_2 = dm_drop_02;
global object_name dm_droppod_3 = dm_drop_03;
global object_name dm_droppod_4 = dm_drop_04;
global object_name dm_droppod_5 = dm_drop_05;
*/

//ai_advance_immediate(sq_e3_knight_ranger);


/*
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
*/