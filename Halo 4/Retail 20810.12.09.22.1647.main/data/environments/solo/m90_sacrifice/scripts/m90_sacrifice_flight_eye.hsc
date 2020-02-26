///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// EYE
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
global boolean b_Eye_Complete = FALSE;
global boolean b_eye_beams_off = FALSE;

script dormant f_eye_flight_init()
	dprint("==================================");
	sleep_until ( volume_test_players( tv_flight_eye_init ) , 1);	
		dprint("INIT:::eye");
		set_broadsword_respawns ( true );
		garbage_collect_now();
////		SetSkyObjectOverride("m90_eye_sky");
		wake( nar_flight_eye_init );
		thread(f_eye_init_unsc_ships());
		sleep(1);


		wake(f_load_eye_zoneset);

		sleep(5);
		wake(f_eye_create_slipspace_objects);	// Beams to Cannons	
		wake( f_eye_door_1_init );
		thread ( f_eye_infinity_enter() );	
		wake(f_close_eye_ap_wait);  //Launches Eye Event
		
		
		thread( f_flight_stop_direction_check() );
		f_m90_game_save();
		sleep(30);
		f_spawn_eye_guys();		
		wake( f_eye_death_beams_setup );
		wake ( f_eye_create_power_beams_all );
end

script static void f_eye_flight_cleanup()
		dprint("CLEANUP:::eye flight");
		object_destroy_folder(dms_eye);	
		object_destroy_folder(crs_eye);	
		//ai_erase( sg_eye_flight_turrets );
		ai_erase( sg_eye_all );
		f_clear_eye_blips();		
		wake ( f_trench_eye_device_cleanup );	
		garbage_collect_now();
		
		thread (f_beam_effect_destroy());

end


script dormant f_eye_door_show()

	//	sleep_until(volume_test_players(tv_eye_call_ships), 1);
		sleep_until(object_valid(maya_dm_cannon_01_door_01) and
			object_valid(maya_dm_cannon_01_door_02) and
			object_valid(maya_dm_cannon_02_door_01) and
			object_valid(maya_dm_cannon_02_door_02) and
			object_valid(maya_dm_cannon_03_door_01) and
			object_valid(maya_dm_cannon_03_door_02) and
			object_valid(maya_dm_cannon_04_door_01) and
			object_valid(maya_dm_cannon_04_door_02) 
		
		, 1);
			dprint("start pupett");
			pup_play_show( pup_cannon_1_doors );
end

script static void f_eye_init_unsc_ships()
	thread ( f_eye_ship_5_setup());
	thread ( f_eye_ship_7_setup());
	thread ( f_eye_ship_10_setup());
	thread ( f_eye_ship_13_setup());
	thread ( f_eye_ship_11_setup());
	thread ( f_eye_ship_18_setup());
	thread ( f_eye_ship_16_setup());
	object_cinematic_visibility(sc_unsc_ship_19, TRUE);
	object_cinematic_visibility(sc_unsc_ship_20, TRUE);
	object_cinematic_visibility(sc_unsc_ship_21, TRUE);
	
	thread( pewpew_ship_2_guns(sc_unsc_ship_19));
	thread( pewpew_ship_4_guns(sc_unsc_ship_21));
	thread( f_eye_setup_defense_array () );
	thread(f_unsc_ship_enter_and_die(sc_unsc_ship_9_die, 2.0, ps_unsc_fly_pts.p9, ps_unsc_fly_pts.p0, TRUE));		
	thread(f_unsc_ship_enter_and_die(sc_unsc_ship_15, 0.8, ps_unsc_fly_pts.p17, ps_unsc_fly_pts.p18, TRUE));	
	thread( f_flight_aa_setup() );
	thread( f_flight_unsc_flak_setup() );
	sleep_until(volume_test_players(tv_eye_call_ships));

		//effect_new_at_ai_point (environments\solo\m40_invasion\fx\cannon\fr_cannon_firing.effect, ps_unsc_fly_pts.p2);

		

		sleep_s(.1);
		thread(f_unsc_ship_entrance(sc_unsc_ship_8, 2.5, ps_unsc_fly_pts.p8));
		thread(f_unsc_ship_entrance(sc_unsc_ship_12, 0.75, ps_unsc_fly_pts.p14));
		sleep_s(.1);
		thread(f_unsc_ship_entrance(sc_unsc_ship_6, 2, ps_unsc_fly_pts.p6));
		thread(f_unsc_ship_entrance(sc_unsc_ship_14, 1, ps_unsc_fly_pts.p6));

		sleep_s(.1);
		thread(f_unsc_ship_entrance(sc_unsc_ship_1, 2.5, ps_unsc_fly_pts.p1));

		sleep_s(.1);
		thread(f_unsc_ship_entrance(sc_unsc_ship_4, 1.25, ps_unsc_fly_pts.p4));
		sleep_s(1);
		thread(f_unsc_ship_entrance(sc_unsc_ship_3, 2, ps_unsc_fly_pts.p3));


		sleep_s(2);
		thread(f_unsc_ship_entrance(sc_unsc_ship_2, 2.5, ps_unsc_fly_pts.p2));
		object_set_scale(sc_unsc_ship_2, 2.5, 3);
		
		//sleep_s(2);

		//f_inf_create_guns();

end

global boolean b_ship_5_dead = FALSE;
script static void f_eye_ship_5_setup()
		local long l_timer = timer_stamp( 30 ); 
		thread(f_unsc_ship_entrance(sc_unsc_ship_5, 2.5, ps_unsc_fly_pts.p5));
		thread(pewpew5());
		sleep_until( s_Cannon_Count < 4 or  timer_expired( l_timer ), 1);
		sleep_rand_s(10,16);
		b_ship_5_dead = TRUE;
		thread(pewpew5());
		thread(f_m90_destroy_unsc_ship(sc_unsc_ship_5));
end

global boolean b_ship_7_dead = FALSE;
script static void f_eye_ship_7_setup()
		thread(f_unsc_ship_entrance(sc_unsc_ship_7, 2.5, ps_unsc_fly_pts.p7));
		thread( pewpew7());
		sleep_rand_s(4,7);
		b_ship_7_dead = TRUE;
		thread(f_m90_destroy_unsc_ship(sc_unsc_ship_7));
end


global boolean b_ship_10_dead = FALSE;
script static void f_eye_ship_10_setup()
		thread(f_unsc_ship_entrance(sc_unsc_ship_10, 0.75, ps_unsc_fly_pts.p7));
		thread( pewpew10());
		sleep_rand_s(18,30);
		b_ship_10_dead = TRUE;
		thread(f_m90_destroy_unsc_ship(sc_unsc_ship_10));
end

global boolean b_ship_13_dead = FALSE;
script static void f_eye_ship_13_setup()
		thread(f_unsc_ship_entrance(sc_unsc_ship_13, 1.0, ps_unsc_fly_pts.p14));
		thread( pewpew_ship_2_guns(sc_unsc_ship_13));
		sleep_rand_s(10,60);
		b_ship_13_dead = TRUE;
		thread(f_m90_destroy_unsc_ship(sc_unsc_ship_13));
end

global boolean b_ship_11_dead = FALSE;
script static void f_eye_ship_11_setup()
		thread(f_unsc_ship_entrance(sc_unsc_ship_11, 1.25, ps_unsc_fly_pts.p15));
		thread( pewpew_ship_2_guns(sc_unsc_ship_11));
		sleep_until( s_Cannon_Count < 3 );
		sleep_rand_s(7,12);
		b_ship_11_dead = TRUE;
		thread(f_m90_destroy_unsc_ship(sc_unsc_ship_11));
end

global boolean b_ship_18_dead = FALSE;
script static void f_eye_ship_18_setup()
		thread(f_unsc_ship_entrance(sc_unsc_ship_18, 1.25, ps_unsc_fly_pts.p16));
		thread( pewpew_ship_2_guns(sc_unsc_ship_18));
		//sleep_until( s_Cannon_Count < 2 );
		sleep_rand_s(23,34);
		b_ship_18_dead = TRUE;
		thread(f_m90_destroy_unsc_ship(sc_unsc_ship_18));
end

global boolean b_ship_16_dead = FALSE;
script static void f_eye_ship_16_setup()
		thread(f_unsc_ship_entrance(sc_unsc_ship_16, 1.25, ps_unsc_fly_pts.p1));
		thread( pewpew_ship_2_guns(sc_unsc_ship_16));
		//sleep_until( s_Cannon_Count < 2 );
		sleep_rand_s(36,68);
		b_ship_16_dead = TRUE;
		thread(f_m90_destroy_unsc_ship(sc_unsc_ship_16));
end
//sc_unsc_ship_11

script static void die_ship()
		thread(f_unsc_ship_enter_and_die(sc_unsc_ship_15, 0.8, ps_unsc_fly_pts.p17, ps_unsc_fly_pts.p18, TRUE));		
end

script static void f_unsc_ship_entrance(object o_ship, real r_scale, point_reference p_point )
	object_cinematic_visibility(o_ship, TRUE);
	object_set_scale(o_ship, r_scale, 3);
	object_move_to_point(o_ship, 300, p_point);
end


script static void f_eye_setup_defense_array()

	

	thread( f_unsc_defenses( sc_unsc_defense_array_01, ps_unsc_fly_pts.p10 )  );
	thread( f_unsc_defenses( sc_unsc_defense_array_02, ps_unsc_fly_pts.p11 )  );
	thread( f_unsc_defenses( sc_unsc_defense_array_03, ps_unsc_fly_pts.p12 )  );
	thread( f_unsc_defenses( sc_unsc_defense_array_04, ps_unsc_fly_pts.p13 )  );
	
	thread( f_unsc_defenses( sc_unsc_defense_array_05, ps_unsc_fly_pts.p19 )  );
	thread( f_unsc_defenses( sc_unsc_defense_array_06, ps_unsc_fly_pts.p20 )  );
	thread( f_unsc_defenses( sc_unsc_defense_array_07, ps_unsc_fly_pts.p21 )  );
	thread( f_unsc_defenses( sc_unsc_defense_array_08, ps_unsc_fly_pts.p22 )  );
	thread( f_unsc_defenses( sc_unsc_defense_array_09, ps_unsc_fly_pts.p23 )  );
	
	
	
end


script static void f_unsc_defenses( object_name obj, point_reference p_point )
	object_cinematic_visibility(obj, TRUE);
	object_move_to_point(obj, 0, p_point);
	repeat
		effect_new_at_ai_point (environments\solo\m90_sacrifice\fx\explosion\flak_det.effect, p_point);
		sleep_s( 8,16 );
	until(b_eye_complete);
end

script static void f_unsc_ship_enter_and_die(object_name o_ship, real r_scale, point_reference p_point, point_reference p_die_point, boolean b_destroy )
	local long l_move_thread = -1;
	object_cinematic_visibility(o_ship, TRUE);
	object_set_scale(o_ship, r_scale, 3);
	l_move_thread = thread( f_m90_move_to_object(o_ship, 20, p_point) );
	sleep_s(6);
	thread( f_unsc_ship_explosions( o_ship, p_die_point, b_destroy, l_move_thread ) );

end


script static void f_unsc_ship_explosions( object_name o_ship, point_reference p_point, boolean b_destroy, long kill_move_thread )

	effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_front );
	sleep_s(3);
	kill_thread( kill_move_thread );
	thread( f_m90_rotate_xyz(o_ship, 30, 30, 45, 100, 40, -45) );	
	thread( f_m90_move_to_object(o_ship,30, p_point)) ;

	effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_starboard_1 );	
	effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, o_ship, m_starboard_2 );	
	sleep_s(4);
	effect_new_on_object_marker (environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_starboard_2 );		
	effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, o_ship, m_port_1 );	
	sleep_s(3);
	effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_front );
	effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, o_ship, m_starboard_2 );	
	//sleep(15);
	sleep_s(5);
	if b_destroy then
			f_m90_destroy_unsc_ship(o_ship);
	end

end

script static void f_m90_destroy_unsc_ship(object_name o_ship )
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_front );
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_starboard_1 );
			sleep(5);
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, o_ship, m_port_2 );	
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_starboard_2 );
			sleep(5);
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_starboard_1 );
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_port_1 );
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_front );	
			sleep(5);
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_port_2 );	
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, o_ship, m_starboard_2 );	
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, o_ship, m_front );				
			//f_m90_global_rezin( o_ship , m_front);
			sleep_s(1.5);
			
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_port_2 );	
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_starboard_2 );	

			sleep(2);
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_port_1 );	
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_starboard_1);	
			sleep(2);
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\human_explosion_large.effect, o_ship, m_front );
			sleep(1);
			object_destroy(o_ship);	
end

script static void f_m90_move_to_object(object_name obj, real time,point_reference p_point )
	dprint("move");
	object_move_to_point(obj, time, p_point);
end

script static void f_m90_rotate_xyz(object_name obj, real yaw_time, real pitch_time, real roll_time, real yaw_degrees, real pitch_degrees, real roll_degrees)
	dprint("rotate");
	object_rotate_by_offset (obj, yaw_time,pitch_time,roll_time, yaw_degrees,pitch_degrees,roll_degrees);
end




script static void f_spawn_eye_guys()

	//ai_place(sq_for_eye_turret_plug_h);
	ai_place( sq_for_eye_turret_joined );
	sleep(2);
	ai_place(sq_for_eye_turret_plug);

	ai_place(sq_mega_cannon);
	wake( f_eye_spawn_06 );
	wake( f_eye_spawn_05 );
	wake(f_eye_spawn_group_a);
	wake(f_eye_spawn_group_b);

	sleep(1);
	wake(f_eye_aa_init);
	wake( f_eye_turret_left );
	wake( f_eye_turret_right );

	thread( f_flight_cleanup_goals() );
end



script dormant f_eye_spawn_06()
	sleep_until (volume_test_players(tv_eye_turrets_2nd_half_right) or volume_test_players(tv_eye_turret_right), 1);
		ai_place(sq_for_eye_turret_06);

end

script dormant f_eye_spawn_05()
	sleep_until (volume_test_players(tv_eye_turrets_2nd_half_left) or volume_test_players(tv_eye_turret_left), 1);
		ai_place(sq_for_eye_turret_05);

end

script dormant f_eye_spawn_group_a()
	sleep_until (volume_test_players(tv_eye_turrets_2nd_half_left), 1);
		ai_place(sq_for_eye_turret_03);

end


script dormant f_eye_spawn_group_b()
	sleep_until (volume_test_players(tv_eye_turrets_2nd_half_right), 1);
		ai_place(sq_for_eye_turret_02);		
end


script dormant f_eye_turret_left()
	sleep_until (volume_test_players(tv_eye_turret_left), 1);
		ai_place(sq_for_eye_turret_04);
end


script dormant f_eye_turret_right()
	sleep_until (volume_test_players(tv_eye_turret_right), 1);
		ai_place(sq_for_eye_turret_01);

end

script dormant f_eye_create_slipspace_objects()
		//Create FX pillars for cannons
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_01, fx_beam_cannon_top_01);
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_02, fx_beam_cannon_top_02);
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_03, fx_beam_cannon_top_03);
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_04, fx_beam_cannon_top_04);

		object_create_folder( dms_eye );
		object_create_folder( crs_eye );		
		sleep(1);		
		object_cannot_take_damage( m90_mega_cannon_01 );
		object_cannot_take_damage( m90_mega_cannon_02 );
		object_cannot_take_damage( m90_mega_cannon_03 );
		object_cannot_take_damage( m90_mega_cannon_04 );
		sleep(10);
		//thread( f_eye_init_unsc_ships() );
	//	thread( f_weapon_switch_tutorial());
		
end


global short s_Cannon_Count = 4;
global short s_MAX_Cannons = s_Cannon_Count;

global boolean b_Cannon_Alive_01 = TRUE;
global boolean b_Cannon_Alive_02 = TRUE;
global boolean b_Cannon_Alive_03 = TRUE;
global boolean b_Cannon_Alive_04 = TRUE;
global boolean b_cannon_1_fire  = FALSE;
global boolean b_cannon_2_fire  = FALSE;
global boolean b_cannon_3_fire  = FALSE;
global boolean b_cannon_4_fire  = FALSE;

script dormant f_eye_aa_objective()
		
		thread( f_eye_aa_listener( m90_mega_cannon_01, cr_aa_lock_1,fg_cannon_1, 1 ) );
		thread( f_eye_aa_listener( m90_mega_cannon_03, cr_aa_lock_3,fg_cannon_3, 3 ) );
		thread( f_eye_aa_listener( m90_mega_cannon_02, cr_aa_lock_2,fg_cannon_2, 2 ) );
		thread( f_eye_aa_listener( m90_mega_cannon_04, cr_aa_lock_4,fg_cannon_4, 4 ) );
		
		sleep(60);
		thread( f_objective_set( DEF_R_OBJECTIVE_CANNONS, TRUE, FALSE, TRUE,TRUE ) );
end



script dormant f_eye_aa_init()
	//wake( f_eye_init_cannon_doors );
	sleep(1);
	thread( f_cannon_state_01() );
	//thread( f_eye_cannon_sequence_01() );

	thread( f_cannon_state_02() );
	//thread( f_eye_cannon_sequence_02() );

	thread( f_cannon_state_03() );
	//thread( f_eye_cannon_sequence_03() );

	thread( f_cannon_state_04() );
	//thread( f_eye_cannon_sequence_04() );
	
	//device_set_position_track( m90_mega_cannon_01, 'any:idle', 0.0 );
	//device_set_position_track( m90_mega_cannon_02, 'any:idle', 0.0 );
	//device_set_position_track( m90_mega_cannon_03, 'any:idle', 0.0 );
	//device_set_position_track( m90_mega_cannon_04, 'any:idle', 0.0 );


end

global boolean b_VO_eye_halfway_done = FALSE;

script static void f_eye_aa_listener( device dm, object power, cutscene_flag flag , short cannon_set )

	//f_eye_open_cannon_door_by_num( cannon_set );

	sleep_s( 3 );
	f_blip_flag(flag, "neutralize");	
	sleep_until(object_get_health(power) <= 0, 1);
		dprint("aa destroyed");
		s_Cannon_Count = s_Cannon_Count - 1;
		garbage_collect_now();
		f_unblip_flag(flag);
		
		if ( not ( b_VO_eye_halfway_done ) and s_Cannon_Count <= s_MAX_Cannons / 2 ) then
			dprint("half turrets destroyed");
			b_VO_eye_halfway_done = TRUE;
			thread( nar_eye_defense_update() );
		end

		if ( s_Cannon_Count == 1 ) then

			wake( m90_eye_third_gun );
		end

end

script static void f_eye_destroy_power_all()

	sleep_until( object_valid( cr_eye_energy_lock ), 1);
	sleep_until( object_get_health( cr_eye_energy_lock ) <= 0, 1);
		f_unblip_flag(flag_eye_main_power);
		f_m90_game_save_no_timeout();
		sleep(15);
		wake(f_eye_destroy_power_beams_all);
		sleep(30);
		f_unblip_flag(flag_eye_main_power);
		
		dprint("opening cannon doors");
		b_eye_cannon_doors_open = TRUE;
		wake( f_eye_door_show );
		wake(f_eye_aa_objective);
end
	
script dormant f_eye_destroy_power_beams_all()  //Flashes beams on and off as they are powered off.
	dprint("Power Off Destroy");
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_bottom);
	sleep( 5 );
	
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_01);									//Normal Off  Fade On
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_01, fx_beam_cannon_01);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_02);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_02, fx_beam_cannon_02);	
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_03);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_03, fx_beam_cannon_03);	
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_04);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_04, fx_beam_cannon_04);	
	sleep( 5 );
    
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_01, fx_beam_cannon_01);			//Fade Off Normal On
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_01);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_02, fx_beam_cannon_02);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_02);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_03, fx_beam_cannon_03);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_03);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_04, fx_beam_cannon_04);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_04);
	sleep( 10 );
	
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_01);									//Normal Off  Fade On
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_01, fx_beam_cannon_01);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_02);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_02, fx_beam_cannon_02);	
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_03);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_03, fx_beam_cannon_03);	
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_04);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_04, fx_beam_cannon_04);	
	sleep( 8 );

	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_01, fx_beam_cannon_01);			//Fade Off Normal On
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_01);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_02, fx_beam_cannon_02);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_02);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_03, fx_beam_cannon_03);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_03);
	effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_04, fx_beam_cannon_04);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_04);
	sleep( 5 );

	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_01);									//Turn off all beams
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_02);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_03);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_04);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_01);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_02);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_03);
	effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon_fade.effect, fx_beam_center_04);
	dprint("kill all center beams");
	b_eye_beams_off = TRUE;
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_01);										//Turn off beam end caps
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_02);
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_03);
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_04);
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_01);
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_02);
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_03);
	effect_kill_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_04);
	
	object_destroy (eye_beam1); //Kill sound scenery objects: AUDIO!
	object_destroy (eye_beam2);
	object_destroy (eye_beam3);
	object_destroy (eye_beam4);
	
	dprint("kill beam end caps");

	garbage_collect_now();
end

script dormant f_eye_create_power_beams_all()  //Turns on all center beams at begining of event.
	sleep_s(7);
	//if object_get_health( cr_eye_energy_lock ) > 0 then
		object_create( cr_eye_energy_lock );
		
		//Center beam
		//effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_bottom, fx_beam_center_top);
		dprint("Beam Center");
		
		//Beams from center
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_01, fx_beam_cannon_01);
		dprint("Beam Center 01");
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_02, fx_beam_cannon_02);
		dprint("Beam Center 02");
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_03, fx_beam_cannon_03);
		dprint("Beam Center 03");
		effect_new_between_points(environments\solo\m90_sacrifice\fx\beams\beam_eye_to_cannon.effect, fx_beam_center_04, fx_beam_cannon_04);
		dprint("Beam Center 0");
		
		//Connection points for beams
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_01);
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_02);
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_03);
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_center_04);
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_01);
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_02);
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_03);
		effect_new(environments\solo\m90_sacrifice\fx\beams\beam_eye_cap.effect, fx_beam_cap_cannon_04);
	
		thread( f_eye_destroy_power_all() );
	//end
	


end

script static void f_beam_effect_destroy()
	
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_1a, "fx_beam_center_01");
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_1b, "fx_beam_center_01");
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_1a, "fx_beam_center_01");
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_1b, "fx_beam_center_01");
	
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_2a, "fx_beam_center_01");
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_2b, "fx_beam_center_01");	
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_2a, "fx_beam_center_01");
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_2b, "fx_beam_center_01");	
	
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_3a, "fx_beam_center_01");
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_3b, "fx_beam_center_01");
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_3a, "fx_beam_center_01");
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_3b, "fx_beam_center_01");	
	
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_4a, "fx_beam_center_01");
	effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_4b, "fx_beam_center_01");
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_4a, "fx_beam_center_01");
	effect_kill_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_4b, "fx_beam_center_01");
	
end

script static void f_cannon_state_01()
	sleep_until( object_valid( cr_aa_lock_1), 1);
	sleep_until( object_get_health( cr_aa_lock_1) <= 0, 1);

		effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_01);
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_1a, "fx_beam_center_01");
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_1b, "fx_beam_center_01");
		object_destroy (eye_beam4b); //AUDIO FOR CANNON BEAM TURNS OFF!
		garbage_collect_now();
		//dprint("KILL CANNON_01 BEAM");
		b_Cannon_Alive_01 = FALSE;
end

script static void f_cannon_state_02()
	sleep_until( object_valid( cr_aa_lock_2), 1);
	sleep_until( object_get_health( cr_aa_lock_2) <= 0, 1);

		effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_04);
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_2a, "fx_beam_center_01");
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_2b, "fx_beam_center_01");
		object_destroy (eye_beam1b); //AUDIO FOR CANNON BEAM TURNS OFF!
		garbage_collect_now();
		//dprint("KILL CANNON_02 BEAM");		
		b_Cannon_Alive_02 = FALSE;
end

script static void f_cannon_state_03()
	sleep_until( object_valid( cr_aa_lock_3), 1);
	sleep_until( object_get_health( cr_aa_lock_3) <= 0, 1);

		effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_03);
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_3a, "fx_beam_center_01");
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_3b, "fx_beam_center_01");
		object_destroy (eye_beam2b); //AUDIO FOR CANNON BEAM TURNS OFF!
		garbage_collect_now();
		//dprint("KILL CANNON_03 BEAM");
		b_Cannon_Alive_03 = FALSE;
end

script static void f_cannon_state_04()
	sleep_until( object_valid( cr_aa_lock_4), 1);
	sleep_until( object_get_health( cr_aa_lock_4) <= 0, 1);

		effect_delete_from_flag(environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, fx_beam_cannon_bottom_02);
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_4a, "fx_beam_center_01");
		effect_stop_object_marker (environments\solo\m90_sacrifice\fx\beams\beam_eye_cannon_base.effect, cr_aa_beam_4b, "fx_beam_center_01");
		object_destroy (eye_beam3b); //AUDIO FOR CANNON BEAM TURNS OFF!
		garbage_collect_now();
		//dprint("KILL CANNON_04 BEAM");
		b_Cannon_Alive_04 = FALSE;
end


global long l_pup_id_01 = -1;
global long l_pup_id_02 = -1;
global long l_pup_id_03 = -1;
global long l_pup_id_04 = -1;

script static void f_eye_cleanup_cannon_pups()
	pup_stop_show(l_pup_id_01);
	pup_stop_show(l_pup_id_02);
	pup_stop_show(l_pup_id_03);
	pup_stop_show(l_pup_id_04);
end


global object g_fake_turret_1 = NONE;
global object g_fake_turret_2 = NONE;
global object g_fake_turret_3 = NONE;
global object g_fake_turret_4 = NONE;

script command_script cs_eye_cannon_1
	//sleep_forever();
	g_fake_turret_1 = ai_vehicle_get(ai_current_actor);
	pup_play_show(pup_cannon_1);
	//object_hide( ai_vehicle_get( ai_current_actor ), TRUE );
		sleep_until(volume_test_players(tv_eye_close),1);
			sleep_s(2);
			cs_aim_object ( TRUE,sc_unsc_ship_15 );
			sleep_s(3);
			b_cannon_1_fire = TRUE;
			sleep_s(7);
			cs_aim_object ( TRUE,sc_unsc_ship_15 );
			sleep_s(3);
			b_cannon_1_fire = TRUE;
			sleep_rand_s(8,10);
	repeat
		local short count = 0;
		repeat
		//sleep_s(3);
			if b_Cannon_Alive_01 then
				begin_random_count(1)
						cs_aim ( TRUE,ps_cannon_fire_pts.p3 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p4 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p5 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p6 );
				end
			end
		sleep(45);
		count = count + 1;
		until( count == 5 or b_Cannon_Alive_01 == FALSE or b_Eye_Complete ,1);
			count = 0;
			sleep_s(3);
			b_cannon_1_fire = TRUE;
			sleep_rand_s(6,8);
	
		
	until(b_Cannon_Alive_01 == FALSE or b_Eye_Complete, 1);
	sleep_forever();

end

script command_script cs_eye_cannon_2
	g_fake_turret_2 = ai_vehicle_get(ai_current_actor);
	pup_play_show(pup_cannon_2);
	//object_hide( ai_vehicle_get( ai_current_actor ), TRUE );
	sleep_rand_s(3,5);
	repeat
		local short count = 0;
		repeat

			if b_Cannon_Alive_02 then
				begin_random_count(1)
						cs_aim ( TRUE,ps_cannon_fire_pts.p0 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p13 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p14 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p15 );
				end
			end
			sleep(45);
			count = count + 1;
		until( count == 5 or b_Cannon_Alive_02 == FALSE or b_Eye_Complete ,1);
			count = 0;
		sleep_s(3);
		b_cannon_2_fire = TRUE;
		sleep_rand_s(6,8);
	until(b_Cannon_Alive_02 == FALSE or b_Eye_Complete, 1);
	sleep_forever();

end

script command_script cs_eye_cannon_3
	g_fake_turret_3 = ai_vehicle_get(ai_current_actor);
	pup_play_show(pup_cannon_3);
	//object_hide( ai_vehicle_get( ai_current_actor ), TRUE );
		//first time through shoot at ship
		sleep_until(volume_test_players(tv_eye_close),1);
			cs_aim_object ( TRUE,sc_unsc_ship_9_die );
			sleep_s(3);
			b_cannon_3_fire = TRUE;
			sleep_s(6);
			cs_aim_object ( TRUE,sc_unsc_ship_7 );
			sleep_s(3);
			b_cannon_3_fire = TRUE;
			sleep_s(5);			
			cs_aim_object ( TRUE,sc_unsc_ship_7 );
			sleep_s(3);
			b_cannon_3_fire = TRUE;
			sleep_rand_s(7,9);	
	repeat	
		local short count = 0;
		
		repeat
				if b_Cannon_Alive_03 then
					begin_random_count(1)
							cs_aim ( TRUE,ps_cannon_fire_pts.p1 );
							cs_aim ( TRUE,ps_cannon_fire_pts.p10 );
							cs_aim ( TRUE,ps_cannon_fire_pts.p11 );
							cs_aim ( TRUE,ps_cannon_fire_pts.p12 );
					end
				end
				sleep(45);
				count = count + 1;
			until( count == 5 or b_Cannon_Alive_03 == FALSE or b_Eye_Complete ,1);
				count = 0;
				sleep_s(3);
				b_cannon_3_fire = TRUE;
				sleep_rand_s(6,8);
	until(b_Cannon_Alive_03 == FALSE or b_Eye_Complete, 1);
	sleep_forever();

end

script command_script cs_eye_cannon_4
	g_fake_turret_4 = ai_vehicle_get(ai_current_actor);
	pup_play_show(pup_cannon_4);
	//object_hide( ai_vehicle_get( ai_current_actor ), TRUE );

		sleep_until(volume_test_players(tv_eye_close),1);
			cs_aim ( TRUE,ps_cannon_fire_pts.p2 );
			sleep_s(3);
			cs_aim_object ( TRUE,sc_unsc_ship_9_die );
			sleep_s(3);
			b_cannon_4_fire = TRUE;
			sleep_rand_s(9,10);
			cs_aim_object ( TRUE,sc_unsc_ship_9_die );
			sleep_s(3);
			b_cannon_4_fire = TRUE;
			sleep_rand_s(9,10);
	repeat
		local short count = 0;
		repeat
			if b_Cannon_Alive_04 then
				begin_random_count(1)
						cs_aim ( TRUE,ps_cannon_fire_pts.p2 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p7 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p8 );
						cs_aim ( TRUE,ps_cannon_fire_pts.p9 );
				end
			end
			sleep(45);
			count = count + 1;
		until( count == 5 or b_Cannon_Alive_04 == FALSE or b_Eye_Complete ,1);
		count = 0;

		sleep_s(3);
		b_cannon_4_fire = TRUE;
		sleep_rand_s(6,8);
	until(b_Cannon_Alive_04 == FALSE or b_Eye_Complete, 1);
	sleep_forever();

end

script static void f_eye_cannon_sequence_01()
	
	l_pup_id_01 = pup_play_show(pup_cannon_1);

	repeat
		sleep_rand_s(10,15);
		if b_Cannon_Alive_01 then
			b_cannon_1_fire = TRUE;
			sleep(1);
		end
	until( b_Cannon_Alive_01 == FALSE, 1 );	
	

end

script static void f_eye_cannon_sequence_02()
	
	
	l_pup_id_02 = pup_play_show(pup_cannon_2);
	repeat
		sleep_rand_s(10,15);
		if b_Cannon_Alive_02 then
			b_cannon_2_fire = TRUE;
			sleep(1);
		end
	until( b_Cannon_Alive_02 == FALSE, 1 );	
end

script static void f_eye_cannon_sequence_03()

	l_pup_id_02 = pup_play_show(pup_cannon_3);
	sleep_s(1);
	repeat

		if b_Cannon_Alive_03 then
			b_cannon_3_fire = TRUE;
			sleep(1);
		end
		sleep_rand_s(10,15);
	until( b_Cannon_Alive_03 == FALSE, 1 );	
end

script static void f_eye_cannon_sequence_04()
	l_pup_id_02 = pup_play_show(pup_cannon_4);
	repeat
		sleep_rand_s(10,15);
		if b_Cannon_Alive_04 then
			b_cannon_4_fire = TRUE;
			sleep(1);
		end
	until( b_Cannon_Alive_04 == FALSE, 1 );	
end




script dormant f_eye_init_cannon_doors()

	device_set_position_track( maya_dm_cannon_01_door_01, 'door_closed', 0.0 );
	device_set_position_track( maya_dm_cannon_01_door_02, 'door_closed', 0.0 );
	device_set_position_track( maya_dm_cannon_02_door_01, 'door_closed', 0.0 );
	device_set_position_track( maya_dm_cannon_02_door_02, 'door_closed', 0.0 );		
	device_set_position_track( maya_dm_cannon_03_door_01, 'door_closed', 0.0 );
	device_set_position_track( maya_dm_cannon_03_door_02, 'door_closed', 0.0 );
	device_set_position_track( maya_dm_cannon_04_door_01, 'door_closed', 0.0 );
	device_set_position_track( maya_dm_cannon_04_door_02, 'door_closed', 0.0 );
	//device_animate_position( maya_dm_cannon_01_door_01, 0, 0, 0.1, 0.1, FALSE );			
	//device_animate_position( maya_dm_cannon_01_door_02, 0, 0, 0.1, 0.1, FALSE );			
	//device_animate_position( maya_dm_cannon_02_door_01, 0, 0, 0.1, 0.1, FALSE );			
	//device_animate_position( maya_dm_cannon_02_door_02, 0, 0, 0.1, 0.1, FALSE );			
	//device_animate_position( maya_dm_cannon_03_door_01, 0, 0, 0.1, 0.1, FALSE );			
	//device_animate_position( maya_dm_cannon_03_door_02, 0, 0, 0.1, 0.1, FALSE );			
	//device_animate_position( maya_dm_cannon_04_door_01, 0, 0, 0.1, 0.1, FALSE );			
	//device_animate_position( maya_dm_cannon_04_door_02, 0, 0, 0.1, 0.1, FALSE );			
end



script static void f_eye_open_cannon_door( device dm , real dist, real time )
	device_set_position_track( dm, 'door_idle_01', 0.0 );
	device_animate_position( dm, dist, time, 0.1, 0.1, FALSE );			
end

global boolean b_eye_cannon_doors_open = FALSE;

script static void f_eye_open_cannon_door_by_num( short cannon_set  )

	local  real EYE_DOOR_AMOUNT = 0.75;


	
	if cannon_set == 1 then
		f_eye_open_cannon_door(maya_dm_cannon_01_door_01, EYE_DOOR_AMOUNT, 1.0);
		f_eye_open_cannon_door(maya_dm_cannon_01_door_02, EYE_DOOR_AMOUNT, 1.0);
		
//		thread( f_eye_door_derez(maya_dm_cannon_01_door_01));
//		thread( f_eye_door_derez(maya_dm_cannon_01_door_02));
		dprint("open cannon 1 doors");
	end
	
	if cannon_set == 2 then
		f_eye_open_cannon_door(maya_dm_cannon_02_door_01, EYE_DOOR_AMOUNT, 1.0);
		f_eye_open_cannon_door(maya_dm_cannon_02_door_02, EYE_DOOR_AMOUNT, 1.0);
		dprint("open cannon 2 doors");
//		thread( f_eye_door_derez(maya_dm_cannon_02_door_01));
//		thread( f_eye_door_derez(maya_dm_cannon_02_door_02));
	end
	
	if cannon_set == 3 then
//		thread( f_eye_door_derez(maya_dm_cannon_03_door_01));
//		thread( f_eye_door_derez(maya_dm_cannon_03_door_02));
		f_eye_open_cannon_door(maya_dm_cannon_03_door_01, EYE_DOOR_AMOUNT, 1.0);
		f_eye_open_cannon_door(maya_dm_cannon_03_door_02, EYE_DOOR_AMOUNT, 1.0);
		dprint("open cannon 3 doors");
	end
	
	if cannon_set == 4 then
//		thread( f_eye_door_derez(maya_dm_cannon_04_door_01));
//		thread( f_eye_door_derez(maya_dm_cannon_04_door_02));
		f_eye_open_cannon_door(maya_dm_cannon_04_door_01, EYE_DOOR_AMOUNT, 1.0);
		f_eye_open_cannon_door(maya_dm_cannon_04_door_02, EYE_DOOR_AMOUNT, 1.0);
		dprint("open cannon 4 doors");
	end		
end

script static void f_eye_infinity_enter()
	sleep_until( s_Cannon_Count <= 0 and not b_Eye_Complete );
		//sleep_rand_s(5,8);		
		thread( nar_eye_defense_success() );
		
		sleep_s(1);
		if player_get_first_alive() != NONE then
			thread( f_crash_cinematic_transition() );
		end
	
end


script static void f_eye_door_derez( object_name obj )

		f_m90_global_rezin( obj, fx_derez1 );
		sleep(1);
		f_m90_global_rezin_soft_kill( obj,fx_derez );
end

script static void f_clear_eye_blips()

	f_unblip_flag(fg_cannon_1);
	f_unblip_flag(fg_cannon_2);
	f_unblip_flag(fg_cannon_3);
	f_unblip_flag(fg_cannon_4);
end






script dormant f_eye_door_1_init()
	//object_create(dm_eye_door_1);	
	sleep(1);
	device_set_position_track( dm_eye_door_1, 'any:idle', 0.0 );
	//device_animate_position( dm_eye_door_1, 1.0, 0.1, 0.1, 1.0, TRUE );
	
	//sleep_until (volume_test_players(tv_open_eye_door_1), 1);
		//thread( f_open_eye_door_1());
	thread( f_trench_door_close_setup( dm_eye_door_1, 7, TRUE,  4, tv_flight_eye_init, kill_eye_tunnel ) );
end


script static void f_open_eye_door_1()

		device_animate_position( dm_eye_door_1, 0.0, 1.0, 0.1, 0.1, TRUE );
		sleep_s(10);
		f_close_eye_door_1();
end

script static void f_close_eye_door_1()
		dprint("close eye door");
		device_animate_position( dm_eye_door_1, 1.0, 1.0, 0.1, 0.1, TRUE );
		sleep_s(1);
		f_trench_activate_death_zone( kill_eye_tunnel, TRUE );	
end

script dormant f_eye_save_wait()
	sleep_until (volume_test_players(tv_eye_save), 1);
		dprint("SAVE::: EYE");
		data_mine_set_mission_segment ("m90_flight_eye");
		sleep(1);
		f_m90_game_save_no_timeout();
end

// sets up the eye then waits for the player to get to the right spot before initiating the closing sequence
script dormant f_close_eye_ap_wait()
	// do the setup
	f_setup_eye_piece( maya_ap_eye_large_01, 0.8 );
	f_setup_eye_piece( maya_ap_eye_large_02, 0.99 );	
	f_setup_eye_piece( maya_ap_eye_large_03, 0.8 );
	f_setup_eye_piece( maya_ap_eye_large_04, 0.8 );
	
	f_setup_eye_piece( maya_ap_eye_core_struc_01, 0.5 );
	f_setup_eye_piece( maya_ap_eye_core_struc_02, 0.5 );	
	f_setup_eye_piece( maya_ap_eye_core_struc_03, 0.5 );
	f_setup_eye_piece( maya_ap_eye_core_struc_04, 0.5 );
			
	f_setup_eye_piece( maya_ap_eye_core_plt_s_01, 0.9 );
	f_setup_eye_piece( maya_ap_eye_core_plt_s_02, 0.9 );
	f_setup_eye_piece( maya_ap_eye_core_plt_s_03, 0.9 );
	f_setup_eye_piece( maya_ap_eye_core_plt_s_04, 0.9 );
	f_setup_eye_piece( maya_ap_eye_core_plt_s_05, 0.9 );
	f_setup_eye_piece( maya_ap_eye_core_plt_s_06, 0.9 );
	f_setup_eye_piece( maya_ap_eye_core_plt_s_07, 0.9 );	
	
	// wait for player to get close enough
	sleep_until (volume_test_players(tv_eye_close), 1);

		thread( f_m90_show_chapter_title( title_eye_flight ) );
		thread(f_close_eye_ap());
		wake( f_eye_closed );

		f_m90_update_1_objectives();	
		local long l_timer = timer_stamp( 12 ); 

	sleep_until( dialog_id_played_check(l_dialog_eye_closed) or timer_expired(l_timer), 1 );	
		if object_get_health( cr_eye_energy_lock ) > 0 then
			f_blip_flag(flag_eye_main_power, "neutralize");
		end 
end

script dormant f_eye_closed()
	sleep_until(device_get_position(maya_ap_eye_large_01) < 0.15, 1);
		dprint("eye_closed");
		thread (nar_gate_closing());
		sleep_s(13);
		if object_get_health( cr_eye_energy_lock ) > 0 then
			thread( f_objective_set( DEF_R_OBJECTIVE_GENERATOR, TRUE, FALSE, TRUE,TRUE ) );
		end 
end

script static void f_setup_eye_piece( device dm, real pos )
	device_set_position_track( dm, 'any:idle', 0.0 );	
	device_animate_position( dm, pos, 0, 1.0, 0.0, FALSE );
end

// close the eye when the player first enters the area
script static void f_close_eye_ap()
	local real r_CLOSE_TIME = 10.0;
	
	// play a 2D sound for the giant eye plates closing
	sound_impulse_start('sound\environments\solo\m090\amb_m90_device_machines\add_on_machine_tags\machine_m90_eye_giant_doors_close', NONE, 1);
	
	device_animate_position( maya_ap_eye_large_01, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );		
	device_animate_position( maya_ap_eye_large_02, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_large_03, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_large_04, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	
	device_animate_position( maya_ap_eye_core_struc_01, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_struc_02, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );		
	device_animate_position( maya_ap_eye_core_struc_03, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_struc_04, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	
	device_animate_position( maya_ap_eye_core_plt_s_01, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_plt_s_02, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_plt_s_03, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_plt_s_04, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_plt_s_05, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_plt_s_06, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_eye_core_plt_s_07, 0.0, r_CLOSE_TIME, 0.1, 1.0, FALSE );
	
	sleep_s(6);
	nar_eye_closed();
end

script static void f_flight_random_flack()

	local unit playerx = player_get_first_valid();
	
	repeat
	//\environments\solo\m90_sacrifice\fx\explosion\flak_det.effect
	sleep(1);
	until( b_eye_complete,1 );
end

global long l_aa_thread_1 = -1;
global long l_aa_thread_2 = -1;
global long l_aa_thread_3 = -1;
global long l_aa_thread_4 = -1;

script static void f_flight_aa_setup()
	l_aa_thread_1 = thread( f_flight_aa_single( fx_tracer_mkr_01 ));	
	sleep_rand_s(4,6);
	l_aa_thread_2 = thread( f_flight_aa_single( fx_tracer_mkr_02 ));	
	sleep_rand_s(4,6);
	l_aa_thread_3 = thread( f_flight_aa_single( fx_tracer_mkr_03 ));
	sleep_rand_s(4,6);
	l_aa_thread_4 = thread( f_flight_aa_single( fx_tracer_mkr_04 ));
	sleep_rand_s(4,6);
	thread( f_flight_aa_single( fx_tracer_mkr_05 ));
	sleep_rand_s(4,6);
	thread( f_flight_aa_single( fx_tracer_mkr_06 ));	
	sleep_rand_s(4,6);
	thread( f_flight_aa_single( fx_tracer_mkr_07 ));	
	
	thread( f_flight_aa_single( fx_tracer_mkr_012 ));
	sleep_rand_s(4,6);
	thread( f_flight_aa_single( fx_tracer_mkr_013 ));
	thread( f_flight_aa_single( fx_tracer_mkr_014 ));
	sleep_rand_s(4,6);
	thread( f_flight_aa_single( fx_tracer_mkr_015 ));	
	
	sleep_s(20);
	kill_thread(l_aa_thread_1);
	kill_thread(l_aa_thread_2);
	kill_thread(l_aa_thread_3);
	kill_thread(l_aa_thread_4);
	thread( f_flight_aa_single( fx_tracer_mkr_08 ));
	thread( f_flight_aa_single( fx_tracer_mkr_09 ));	
	sleep_rand_s(2,4);
	thread( f_flight_aa_single( fx_tracer_mkr_010 ));	
	thread( f_flight_aa_single( fx_tracer_mkr_011 ));	
	//sleep_rand_s(4,6);


end

script static void f_flight_unsc_flak_setup()


	
	//repeat
	//\environments\solo\m90_sacrifice\fx\explosion\flak_det.effect
	//effect_new(  environments\solo\m90_sacrifice\fx\explosion\flak_det.effect,   );
	


	thread( f_flight_unsc_flak_single(fx_flak_mkr_01 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_02 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_03 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_04 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_05 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_06 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_07 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_08 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_09 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_10 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_11 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_12 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_13 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_14 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_15 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_16 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_17 ));
	sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18 ));	

	thread( pewpew_ship_2_guns(sc_unsc_ship_8) );
	sleep_s(5);
	thread( pewpew_ship_4_guns(sc_unsc_ship_4) );
	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_1a ));	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_2a ));
		sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_3a ));	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_4a ));	
		sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_5a ));		
	thread( f_flight_unsc_flak_single(fx_flak_mkr_6a ));
		sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_7a ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_8a ));
	sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_9a ));	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_10a ));
		sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_11a ));	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_12a ));	
		sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_13a ));		
	thread( f_flight_unsc_flak_single(fx_flak_mkr_14a ));
		sleep(15);
	thread( f_flight_unsc_flak_single(fx_flak_mkr_15a ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_16a ));
	sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_17a ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a ));
	sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a1 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a2 ));
	sleep(15);		
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a3 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a4 ));
	sleep(15);		
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a5 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a6 ));
	sleep(15);	
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a7 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a8 ));
	sleep(15);		
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a9 ));
	thread( f_flight_unsc_flak_single(fx_flak_mkr_18a10 ));
	sleep(15);	

	//until( b_eye_complete,1 );
	thread( pewpew_ship_4_guns(sc_unsc_ship_1) );
	sleep(1);
end

global boolean b_flight_stop_flack = FALSE;
script static void f_flight_unsc_flak_single( cutscene_flag this_fx_marker )

	repeat		
		effect_new(  environments\solo\m90_sacrifice\fx\explosion\flak_det.effect,  this_fx_marker );
		sleep_rand_s(5,10);
	until( b_eye_complete ,1);
end

script static void f_flight_aa_single( cutscene_flag this_fx_marker )

	repeat		
		effect_new(  environments\solo\m90_sacrifice\fx\explosion\dummy_firing.effect,  this_fx_marker );
		sleep_rand_s(13,17);
	until( b_eye_complete ,1);
end


script static void pewpew_ship_4_guns( object_name ship)
	repeat
	//effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing.effect, sc_unsc_ship_4, "fx_tracer_mkr_unsc_01" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, ship, "m_port_1" );
		sleep_rand_s (5, 8); 
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, ship, "m_port_2" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, ship, "m_starboard_1" );
		sleep_rand_s (5, 8);
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, ship, "m_starboard_2" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, ship, "m_port_2" );
		sleep_rand_s (4, 7); 
	until (b_eye_complete);
end



script static void pewpew5()
	repeat
	//effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing.effect, sc_unsc_ship_4, "fx_tracer_mkr_unsc_01" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_5, "m_port_1" );
		sleep_rand_s (7, 9); 
		if not b_ship_5_dead then
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_5, "m_starboard_2" );
			sleep_rand_s (7, 9); 
		end
	until (b_eye_complete or b_ship_5_dead );
end

script static void pewpew7()
	repeat
	//effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing.effect, sc_unsc_ship_4, "fx_tracer_mkr_unsc_01" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_5, "m_starboard_1" );
		sleep_rand_s (6, 9); 
		if not b_ship_7_dead then
			effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_5, "m_starboard_2" );
			sleep_rand_s (6, 9); 
		end
	until (b_eye_complete or b_ship_7_dead );
end




script static void pewpew10()
	repeat
	//effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing.effect, sc_unsc_ship_4, "fx_tracer_mkr_unsc_01" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_10, "m_port_2" );		
		sleep_rand_s (7, 9);
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_10, "m_starboard_1" );		
		sleep_rand_s (6, 7);  		 
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_10, "m_port_1" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_10, "m_starboard_2" );
		sleep_rand_s (7, 10); 
	until ( b_eye_complete or b_ship_10_dead);
end



script static void pewpew11()
	repeat
	//effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing.effect, sc_unsc_ship_4, "fx_tracer_mkr_unsc_01" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_10, "m_port_2" );		
		sleep_rand_s (8, 10);
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_10, "m_starboard_1" );		
		sleep_rand_s (6, 8);  		 
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, sc_unsc_ship_10, "m_port_1" );
		sleep_rand_s (7, 10); 
	until ( b_eye_complete or b_ship_11_dead);
end

script static void pewpew_ship_2_guns( object_name ship)
	repeat
	//effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing.effect, sc_unsc_ship_4, "fx_tracer_mkr_unsc_01" );
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, ship, "m_port_1" );
		sleep_rand_s (6, 10); 
		effect_new_on_object_marker ( environments\solo\m90_sacrifice\fx\explosion\dummy_firing_UNSC.effect, ship, "m_port_2" );
		sleep_rand_s (6, 10); 
	until (b_eye_complete );
end

script static void f_inf_create_guns()
	ai_place(infinity_guns);
	sleep(1);
	objects_attach(sc_unsc_ship_1, "m_front", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_1), "" );
	objects_attach(sc_unsc_ship_4, "m_front", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_2), "" );
	//objects_attach(infinity, "m_gun_mid_rear_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_3), "" );

	dprint("attached infinity guns");
	sleep(1);
	//load_inf_gunners();
end


/////////////////////////////////////////////////////////////////////////////////////////////////
//DAMAGE FROM BEAMS
/////////////////////////////////////////////////////////////////////////////////////////////////

script static void f_eye_death_beam_damage( trigger_volume the_trig )
	
	if player_valid( player0 ) then
		thread(f_eye_beam_damage_per_player(the_trig, player0));
	end
	
	if player_valid( player1 ) then
		thread(f_eye_beam_damage_per_player(the_trig, player1));
	end
	
	if player_valid( player2 ) then
		thread(f_eye_beam_damage_per_player(the_trig, player2));
	end
	
	if player_valid( player3 ) then
		thread(f_eye_beam_damage_per_player(the_trig, player3));
	end
end

script static void f_eye_beam_damage_per_player(trigger_volume the_trig, player the_player)
	local vehicle the_ship = NONE;
	repeat
		if player_valid( the_player ) then	
			sleep_until (volume_test_object (the_trig, the_player) or b_eye_beams_off, 1);
				if not b_eye_beams_off then
					the_ship = unit_get_vehicle( the_player );
					damage_object(the_ship, "default", 250);
					damage_objects_effect ("objects\vehicles\covenant\storm_wraith\turrets\storm_wraith_mortar\weapon\projectiles\damage_effects\storm_wraith_mortar_round_impact.damage_effect", the_ship);
					thread( f_eye_beam_camera_shake(the_player )  );
					dprint("Hit by a eye beam");
				end
				sleep (10);
		end
	until ( b_eye_beams_off, 1);
end


script dormant f_eye_death_beams_setup()
		thread( f_eye_death_beam_damage(tv_eye_beam_1) );
		thread( f_eye_death_beam_damage(tv_eye_beam_2) );
		thread( f_eye_death_beam_damage(tv_eye_beam_3) );
		thread( f_eye_death_beam_damage(tv_eye_beam_4) );
		thread( f_eye_death_beam_damage(tv_eye_beam_mid) );
		
end


script static void f_eye_beam_camera_shake(player p_player ) 
	camera_shake_player	(p_player, 0.2, 0.2, 0, 1.5, eye_beam_camera_shake);
	player_effect_set_max_rumble_for_player(p_player, 0.8, 0.8);
	sleep_s(0.25);
	player_effect_set_max_rumble_for_player(p_player, 0, 0);
end

/*
script static void load_inf_gunners()
       //ai_place(biggun);
       //sleep(5);
       ai_place (inf_gunners);
       ai_cannot_die (inf_gunners, TRUE);       
      // ai_set_clump (inf_gunners, 5);

      //ai_designer_clump_perception_range (600);
       
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_1), "", ai_get_unit (inf_gunners.gunner_1));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_2), "", ai_get_unit (inf_gunners.gunner_2));

end
*/



//test
script static void rotten_apple()

	thread( f_m90_rotate_xyz(m90_mega_cannon_01, 30, 30, 45, 100, 40, -45) );
end
