
// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M10
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
global long ms_1_thread = 0;
global long ms_10_thread = 0;
global long sec_1_thread = 0;
global long sec_10_thread = 0;
global long min_1_thread = 0;
global long min_10_thread = 0;
global long hours_1_thread = 0;
global long hours_10_thread = 0;
global long days_1_thread = 0;
global long days_10_thread = 0;
global long days_100_thread = 0;
global boolean b_objective_1_complete = FALSE;
global boolean b_objective_2_complete = FALSE;
global boolean b_objective_3_complete = FALSE;
global boolean b_objective_4_complete = FALSE;
global boolean b_objective_5_complete = FALSE;
global boolean b_objective_6_complete = FALSE;
global boolean b_objective_7_complete = FALSE;
global boolean b_objective_8_complete = FALSE;
global boolean b_objective_9_complete = FALSE;
global boolean b_objective_10_complete = FALSE;
global boolean b_objective_11_complete = FALSE;
global boolean b_objective_12_complete = FALSE;
global boolean b_missile_control_elite_dead = TRUE;
global boolean b_used_fud_holgoram = FALSE;
global boolean b_get_objective_beacon = FALSE;
global boolean b_fud_active = FALSE;

///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////
script startup m10_narrative_startup()
	sleep_until( b_mission_started == TRUE );
	
	objectives_set_string(0, obj_menu_int_alert);
	objectives_set_string(1, obj_menu_destroy_cruiser);
	objectives_set_string(2, obj_menu_escape_fud);
	
	print ("m10_narrative_startup");
	thread (chiefs_record_main());
	thread (star_map_main());
	thread (fud_holo_main());
	thread (start_cryo_clock());
	thread (cryo_room_monitors());
	thread (m10_missile_launched());
	//thread (m10_vo_airlock_return());
	thread (m10_vo_planet_reveal());
	thread (fud_intrustion_loop());
	wake (m10_achievement_unlock);
	
	wake(m10_elevator_in_sight);
	//wake(m10_post_second_elevator);
	wake(m10_lookout_post);
	wake(m10_cafe_vo);
	wake(m10_beacon_launch_beacon);
	wake(m10_kill_zone);
	//wake(m10_beacon_prep);
	wake(m10_start_observatory_pip);
	object_destroy(fud_switch_02);
	object_destroy(fud_switch_03);
	object_destroy(fud_switch_04);
	object_destroy(fud_switch_05);
	object_destroy(history_switch_02);
	
	thread(m10_hull_integrity_30());
	thread(m10_hull_integrity_25());
	thread(m10_hull_integrity_10());
	thread(m10_system_depressurization());
	
end

script static void cryo_room_monitors()
		sleep_until( object_valid(cryo_monitor), 1 );
	
		object_set_permutation (cryo_monitor, "","default");
		
		sleep_until(objects_distance_to_object (player0, cryo_monitor) < 4, 1);
		
		object_set_permutation (cryo_monitor, "","active");
end

///////////////////////////////////////////////////////////////////////////////////
// FUD Halogram
///////////////////////////////////////////////////////////////////////////////////


script static void fud_intrustion_loop()
	dprint("fud_intrustion_loop THREADED");
///MWG : Adding a sleep until object valid to prevent debug spew
	sleep_until(object_valid(fud_switch) or object_valid(fud_switch_02) or object_valid(fud_switch_03) or object_valid(fud_switch_04) or object_valid(fud_switch_05));
	sleep_until(objects_distance_to_object (player0, fud_switch) < 4, 1);
	sleep_s(5);
	if ( (objects_distance_to_object(player0, fud_switch) < 4) or (objects_distance_to_object(player0, fud_switch_02) < 4) or (objects_distance_to_object(player0, fud_switch_03) < 4) or (objects_distance_to_object(player0, fud_switch_04) < 4) or (objects_distance_to_object(player0, fud_switch_05) < 4)) and  b_fud_active == FALSE then
	dprint("intrustion fired");
		sound_impulse_start( 'sound\dialog\mission\m10\m10_fud_hologram_00105', fud_switch, 1 );
		print("System Voice: Intrusion alert.");
		sleep_s(2);
		sound_impulse_start( 'sound\dialog\mission\m10\m10_fud_hologram_00105', fud_switch, 1 );
		print("System Voice: Intrusion alert.");
			 if b_fud_active == FALSE then
							thread(fud_intrustion_loop());
			 end
	end
	
	
end

script static void fud_holo_main()

	sleep_until( object_valid(halogram), 1 );
	
	static short holo_state = 0;
	
	repeat 
		sleep_until (device_get_position(fud_switch) != 0);
		local long show = pup_play_show (fud_hud_button);
		sleep_until(not pup_is_playing(show),1);
		b_fud_active = TRUE;
		//sound_impulse_stop(m10_fud_hologram_00105);
		dialog_end_interrupt(l_dlg_m80_intrusion_alert);
		kill_script(fud_intrustion_loop);
		object_destroy(fud_switch);
		object_set_variant (halogram, "guns_offline");
		thread (f_dialog_FUDhologram( holo_state ));
		holo_state = holo_state + 1;
		sleep_s(4);
		b_fud_active = FALSE;
		thread(fud_intrustion_loop());
		object_create(fud_switch_02);
		device_set_position_immediate(fud_switch_02, 0);
		
		sleep_until (device_get_position(fud_switch_02) != 0);
	//	pup_play_show (fud_hud_button);
	//	sound_impulse_stop(m10_fud_hologram_00105);
		b_fud_active = TRUE;
		dialog_end_interrupt(l_dlg_m80_intrusion_alert);
		kill_script(fud_intrustion_loop);
		object_destroy(fud_switch_02);
		object_set_variant (halogram, "grav_online");
		thread (f_dialog_FUDhologram( holo_state ));
		holo_state = holo_state + 1;
		sleep_s(4);
		b_fud_active = FALSE;
		thread(fud_intrustion_loop());
		object_create(fud_switch_03);
		device_set_position_immediate(fud_switch_03, 0);

		sleep_until (device_get_position(fud_switch_03) != 0);
	//	pup_play_show (fud_hud_button);
	//	sound_impulse_stop(m10_fud_hologram_00105);
		b_fud_active = TRUE;
		dialog_end_interrupt(l_dlg_m80_intrusion_alert);
		kill_script(fud_intrustion_loop);
		object_destroy(fud_switch_03);
		object_set_variant (halogram, "propul_offline");
		thread (f_dialog_FUDhologram( holo_state ));
		holo_state = holo_state + 1;
		sleep_s(4);
		b_fud_active = FALSE;
		thread(fud_intrustion_loop());
		object_create(fud_switch_04);
		device_set_position_immediate(fud_switch_04, 0);

		sleep_until (device_get_position(fud_switch_04) != 0);
	//	pup_play_show (fud_hud_button);
		b_fud_active = TRUE;
		//sound_impulse_stop(m10_fud_hologram_00105);
		dialog_end_interrupt(l_dlg_m80_intrusion_alert);
		kill_script(fud_intrustion_loop);
		object_destroy(fud_switch_04);
		object_set_variant (halogram, "hull_compromised");
		thread (f_dialog_FUDhologram( holo_state ));
		holo_state = holo_state + 1;
		sleep_s(4);
		b_fud_active = FALSE;
		thread(fud_intrustion_loop());
		object_create(fud_switch_05);
		device_set_position_immediate(fud_switch_04, 0);
		
		sleep_until (device_get_position(fud_switch_05) != 0);
	//	pup_play_show (fud_hud_button);
		//sound_impulse_stop(m10_fud_hologram_00105);
		b_fud_active = TRUE;
		dialog_end_interrupt(l_dlg_m80_intrusion_alert);
		kill_script(fud_intrustion_loop);
		object_destroy(fud_switch_05);
		object_set_variant (halogram, "life_support");
		thread (f_dialog_FUDhologram( holo_state ));
		holo_state = holo_state + 1;
		sleep_s(4);
		b_fud_active = FALSE;
		thread(fud_intrustion_loop());
		object_create(fud_switch);
		device_set_position_immediate(fud_switch, 0);
		
		holo_state = 0;
	until (1 == 0, 1);	
	
end

global sound SND_FUDhologram_active = NONE;
script static void f_dialog_FUDhologram_play( sound snd_sound, real r_time, string str_dprint )
	// kill previous sound if it's playing
	if ( SND_FUDhologram_active != NONE ) then
		sound_impulse_stop( SND_FUDhologram_active );
		SND_FUDhologram_active = NONE;
	end

	// XXX set the target to the object in the room
	sound_impulse_start( snd_sound, halogram, 1 );
	SND_FUDhologram_active = snd_sound;

	dprint( str_dprint );
	sleep_s( r_time );
	if ( SND_FUDhologram_active == snd_sound ) then
		SND_FUDhologram_active = NONE;
	end
end

script static void f_dialog_FUDhologram( short s_index )
static long l_thread = 0;
	//dprint( "::: f_dialog_FUDhologram :::" );

	// kill the thread
	if ( l_thread != 0 ) then
		kill_thread( l_thread );
		l_thread = 0;
	end
	
	// play the indexed sound
	if ( s_index == 0 ) then
	sleep_s(1);
		l_thread = thread( f_dialog_FUDhologram_play('sound\dialog\mission\m10\m10_fud_hologram_00100', sound_impulse_time('sound\dialog\mission\m10\m10_fud_hologram_00100'), "System Voice : Weapon systems offline.") );
		b_used_fud_holgoram = TRUE;
	end
	if ( s_index == 1 ) then
	sleep_s(1);
		l_thread = thread( f_dialog_FUDhologram_play('sound\dialog\mission\m10\m10_fud_hologram_00101', sound_impulse_time('sound\dialog\mission\m10\m10_fud_hologram_00101'), "System Voice : Gravity controls online.") );
	end
	if ( s_index == 2 ) then
	sleep_s(1);
		l_thread = thread( f_dialog_FUDhologram_play('sound\dialog\mission\m10\m10_fud_hologram_00102', sound_impulse_time('sound\dialog\mission\m10\m10_fud_hologram_00102'), "System Voice : Ship Propulsion offline.") );
	end
	if ( s_index == 3 ) then
	sleep_s(1);
		l_thread = thread( f_dialog_FUDhologram_play('sound\dialog\mission\m10\m10_fud_hologram_00103', sound_impulse_time('sound\dialog\mission\m10\m10_fud_hologram_00103'), "System Voice : Bow hull integrity compromised.") );
	end
	if ( s_index == 4 ) then
	sleep_s(1);
		l_thread = thread( f_dialog_FUDhologram_play('sound\dialog\mission\m10\m10_fud_hologram_00104', sound_impulse_time('sound\dialog\mission\m10\m10_fud_hologram_00104'), "System Voice : Life support online.") );
	end
	if ( s_index == 5 ) then
	sleep_s(1);
		l_thread = thread( f_dialog_FUDhologram_play('sound\dialog\mission\m10\m10_fud_hologram_00105', sound_impulse_time('sound\dialog\mission\m10\m10_fud_hologram_00105'), "System Voice : Intrusion alert.") );
	end
end

///////////////////////////////////////////////////////////////////////////////////
// Interactive Star Map
///////////////////////////////////////////////////////////////////////////////////

script static void star_map_main()
	// XXX ADDED TO PREVENT IT FROM RUNNING WHEN THE OBJECTS ARE NOT LOADED - THFRENCH
		sleep_until (object_valid(star_switch));
		local long fud_show = -1;
	
		device_group_set_immediate (fud_star_power, 1 );
		sleep_until (device_get_position(star_switch) != 0);
		//pup_play_show (star_map_button);
		device_group_set_immediate (fud_star_power, 0 );
		sleep(30);
		object_create (fud_star_map);
		fud_show = pup_play_show(ps_fud_star_map);
		sleep_until( pup_is_playing( fud_show ) == FALSE, 1 );		
		device_set_position_immediate(star_switch, 0);
		thread (star_map_main());

	
end

script static void star_map_anims()
	pup_play_show(ps_fud_star_map);
end


///////////////////////////////////////////////////////////////////////////////////
// Chief's Record
///////////////////////////////////////////////////////////////////////////////////
script static void chiefs_record_main()
	// XXX ADDED TO PREVENT IT FROM RUNNING WHEN THE OBJECTS ARE NOT LOADED - THFRENCH
	print("::RECORD INITIATED::");
	sleep_until( object_valid(history_switch));
	print("::RECORD SHOULD BE ON::");
	static short record_state = 0;
	
	repeat 
		sleep_until (device_get_position(history_switch) != 0);
		object_destroy(history_switch);
		local long record_show = pup_play_show (chief_record_button);
		sleep_until(not pup_is_playing(record_show),1);
		object_create(chief_record);
		object_set_permutation (chief_record, "","default");
		thread (f_dialog_servicerecord( record_state ));
		record_state = record_state + 1;
		sleep_s(7);
		object_create(history_switch_02);
		device_set_position_immediate(history_switch_02, 0);
		
		sleep_until (device_get_position(history_switch_02) != 0);
	//	pup_play_show (chief_record_button);
		object_destroy(history_switch_02);
		object_set_permutation (chief_record, "","slide_1");
		thread (f_dialog_servicerecord( record_state ));
		record_state = record_state + 1;
		sleep_s(19);
		object_create(history_switch_02);
		device_set_position_immediate(history_switch_02, 0);

		sleep_until (device_get_position(history_switch_02) != 0);
	//	pup_play_show (chief_record_button);
		object_destroy(history_switch_02);
		object_set_permutation (chief_record, "","slide_2");
		thread (f_dialog_servicerecord( record_state ));
		record_state = record_state + 1;
		sleep_s(25);
		object_create(history_switch_02);
		device_set_position_immediate(history_switch_02, 0);
		
		sleep_until (device_get_position(history_switch_02) != 0);
//		pup_play_show (chief_record_button);
		object_destroy(history_switch_02);
		object_set_permutation (chief_record, "","slide_3");
		thread (f_dialog_servicerecord( record_state ));
		record_state = record_state + 1;
		sleep_s(23);
		object_create(history_switch_02);
		device_set_position_immediate(history_switch_02, 0);
		
		sleep_until (device_get_position(history_switch_02) != 0);
//		pup_play_show (chief_record_button);
		object_destroy(history_switch_02);
		object_set_permutation (chief_record, "","slide_4");
		thread (f_dialog_servicerecord( record_state ));
		record_state = record_state + 1;
		sleep_s(12);
		object_create(history_switch_02);
		device_set_position_immediate(history_switch_02, 0);
		
		sleep_until (device_get_position(history_switch_02) != 0);
	//	pup_play_show (chief_record_button);
		object_destroy(history_switch_02);
		//object_set_permutation (chief_record, "","slide_6");
		thread (f_dialog_servicerecord( record_state ));
		record_state = record_state + 1;
		sleep_s(19);
		object_create(history_switch);
		device_set_position_immediate(history_switch, 0);
		record_state = 0;

		
	until (1 == 0, 1);	
end


script static void f_dialog_servicerecord( short s_index )
static long l_thread = 0;
	//dprint( "::: f_dialog_servicerecord :::" );

	// kill the thread
	if ( l_thread != 0 ) then
		kill_thread( l_thread );
		l_thread = 0;
	end
	
	// play the indexed sound
	if ( s_index == 0 ) then
	sleep_s(1);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00130', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00130'), "This is the service record for Spartan John One-One-Seven.") );
	  sleep_s(5);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00131', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00131'), "Would you like to continue?") );
	end
	if ( s_index == 1 ) then
	sleep_s(1);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00124', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00124'), "Frigate Pillar of Autumn discovers Forerunner Halo Installation 04, and deploys Spartan 117 to protect  UNSC AI Cortana. Chief uncovers a Covenant plot to fire the weapon, and sacrifices the Autumn to destroy the Halo ring.") );
	end
	if ( s_index == 2 ) then
	sleep_s(1);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00125', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00125'), "Pursuing the Covenant flagship after an attack on Earth, Spartan one one seven arrives at Halo Installation 05 to find the Covenant erupting into civil war. After preventing the Covenant from firing the ring, one one seven followed them back to Earth in search of a Forerunner installation that can activate all the galaxy’s Halos.") );
	end
	if ( s_index == 3 ) then
	sleep_s(1);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00126', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00126'), "The Covenant arrive at Earth, and open a portal to the Ark, an extragalactic Forerunner installation that can fire the Halo Array. Spartan one one seven unites a joint Covenant/UNSC team to pursue the Covenant to the Ark, where he successfully destroys the Installation and prevents the rings from being used.") );
	end
	if ( s_index == 4 ) then
	sleep_s(1);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00127', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00127'), "When Spartan one one seven attempts to escape from the Ark aboard the UNSC Forward Unto Dawn, the slipspace portal that the ship is passing through collapses.") );
	end
	if ( s_index == 5 ) then
	sleep_s(1);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00122', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00122'), "Aboard the aft section of the Dawn, Spartan 117 is placed into cryo sleep pending recovery by UNSC forces. AI Cortana to remain active as long as is technically feasible.") );
	  sleep_s(16);
	  l_thread = thread( f_dialog_servicerecord_play('sound\dialog\mission\m10\m10_servicerecord_00123', sound_impulse_time('sound\dialog\mission\m10\m10_servicerecord_00123'), "End of service record.") );
	end

end

global sound SND_servicerecord_active = NONE;
script static void f_dialog_servicerecord_play( sound snd_sound, real r_time, string str_dprint )

	// kill previous sound if it's playing
	if ( SND_servicerecord_active != NONE ) then
		sound_impulse_stop( SND_servicerecord_active );
		SND_servicerecord_active = NONE;
	end

	// XXX set the target to the object in the room
	sound_impulse_start( snd_sound, service_record, 1 );
	SND_servicerecord_active = snd_sound;
		
	dprint( str_dprint );
	sleep_s( r_time );
	if ( SND_servicerecord_active == snd_sound ) then
		SND_servicerecord_active = NONE;
	end

end

///////////////////////////////////////////////////////////////////////////////////
// CRYOCLOCK (the impossible)
///////////////////////////////////////////////////////////////////////////////////
script static void start_cryo_clock()
	// XXX ADDED TO PREVENT IT FROM RUNNING WHEN THE OBJECTS ARE NOT LOADED - THFRENCH
	sleep_until( object_valid(sec_1), 1 );


	static short ms_init_10 = 5;
	static short sec_init_1 = 5;
	static short sec_init_10 = 5;
	static short min_init_1 = 8;
	static short min_init_10 = 5;
	static short hour_init_1 = 3;
	static short hour_init_10 = 2;
	static short day_init_1 = 2;
	static short day_init_10 = 4;
	static short day_init_100 = 3;
	static short year_init_1 = 3;
	static short year_init_10 = 0;
	static short year_init_100 = 0;
	
	thread (set_cryo_clock_init_num(ms_10, ms_init_10));
	thread (set_cryo_clock_init_num(sec_1, sec_init_1));
	thread (set_cryo_clock_init_num(sec_10, sec_init_10));
	thread (set_cryo_clock_init_num(min_1, min_init_1));
	thread (set_cryo_clock_init_num(min_10, min_init_10));
	thread (set_cryo_clock_init_num(hour_1, hour_init_1));
	thread (set_cryo_clock_init_num(hour_10, hour_init_10));
	thread (set_cryo_clock_init_num(day_1, day_init_1));
	thread (set_cryo_clock_init_num(day_10, day_init_10));
	thread (set_cryo_clock_init_num(day_100, day_init_100));
	thread (set_cryo_clock_init_num(year_1, year_init_1));
	thread (set_cryo_clock_init_num(year_10, year_init_10));
	thread (set_cryo_clock_init_num(year_100, year_init_100));
	
	// ms
	ms_1_thread = thread (set_cryo_clock_num_ms_1(ms_1));
	ms_10_thread = thread (set_cryo_clock_num_ms_10(ms_10, sec_init_1));
		
	// seconds
	sec_1_thread = thread (set_cryo_clock_num_sec_1(sec_1, 1, sec_init_1));
	sec_10_thread = thread (set_cryo_clock_num_sec_10(sec_10, 10, sec_init_10));
	
	// minutes
	min_1_thread = thread (set_cryo_clock_num_min_1(min_1, 60, min_init_1));
	min_10_thread = thread (set_cryo_clock_num_min_10(min_10, 600, min_init_10));
		
	// hours
	hours_1_thread = thread (set_cryo_clock_num_hour_1(hour_1, 3600, hour_init_1, hour_init_10));
	hours_10_thread = thread (set_cryo_clock_num_hour_10(hour_10, 36000, hour_init_10));
	
	// days
	days_1_thread = thread (set_cryo_clock_num_day_1(day_1, 86400, day_init_1));
	days_10_thread = thread (set_cryo_clock_num_day_10(day_10, 864000, day_init_10, 34));	// careful with this one
	days_100_thread = thread (set_cryo_clock_num_day_100(day_100, 8640000, day_init_100));	
	
end

script static void set_cryo_clock_init_num(object num, short init)
		if (init == 0) then
				object_set_permutation (num, "","0");
		end
		
		if (init == 1) then
				object_set_permutation (num, "","1");
		end
		
		if (init == 2) then
				object_set_permutation (num, "","2");
		end
		
		if (init == 3) then
				object_set_permutation (num, "","3");
		end

		if (init == 4) then
				object_set_permutation (num, "","4");
		end
		
		if (init == 5) then
				object_set_permutation (num, "","5");
		end
		
		if (init == 6) then
				object_set_permutation (num, "","6");
		end
		
		if (init == 7) then
				object_set_permutation (num, "","7");
		end
		
		if (init == 8) then
				object_set_permutation (num, "","8");
		end

		if (init == 9) then
				object_set_permutation (num, "","9");
		end		
end

script static void set_cryo_clock_num_ms_1(object num)
				
	repeat 
		begin_random 
			object_set_permutation (num, "","0"); 
			object_set_permutation (num, "","1");
			object_set_permutation (num, "","2"); 
			object_set_permutation (num, "","3");
			object_set_permutation (num, "","4"); 
			object_set_permutation (num, "","5");
			object_set_permutation (num, "","6"); 
			object_set_permutation (num, "","7");
			object_set_permutation (num, "","8"); 
			object_set_permutation (num, "","9");
		end
	until (1 == 0, 1);

end

script static void set_cryo_clock_num_ms_10(object num, short init)
	
	static short current_time = 0;
	current_time = init;

	// set up the first time through	
	current_time = current_time + 1;

	if (current_time == 0 or current_time >= 10) then
			object_set_permutation (num, "","0");
			current_time = 0;		
			NotifyLevel( "start seconds one" );
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			object_set_permutation (num, "","4");
	end
	
	if (current_time == 5) then
			object_set_permutation (num, "","5");
	end		

	if (current_time == 6) then
			object_set_permutation (num, "","6");
	end		
	
	if (current_time == 7) then
			object_set_permutation (num, "","7");
	end		
	
		if (current_time == 8) then
			object_set_permutation (num, "","8");
	end		
	
	if (current_time == 9) then
			object_set_permutation (num, "","9");
	end			
				
	// clock loop				
	repeat 	
		current_time = current_time + 1;
		
		if (current_time == 0 or current_time >= 10) then
				object_set_permutation (num, "","0");
				current_time = 0;		
				NotifyLevel( "start seconds one" );
		end
		
		if (current_time == 1) then
				object_set_permutation (num, "","1");
		end
		
		if (current_time == 2) then
				object_set_permutation (num, "","2");
		end
		
		if (current_time == 3) then
				object_set_permutation (num, "","3");
		end
	
		if (current_time == 4) then
				object_set_permutation (num, "","4");
		end
		
		if (current_time == 5) then
				object_set_permutation (num, "","5");
		end		
	
		if (current_time == 6) then
				object_set_permutation (num, "","6");
		end		
		
		if (current_time == 7) then
				object_set_permutation (num, "","7");
		end		
		
			if (current_time == 8) then
				object_set_permutation (num, "","8");
		end		
		
		if (current_time == 9) then
				object_set_permutation (num, "","9");
		end			

	until (1 == 0, 3);

end

script static void set_cryo_clock_num_sec_1(object num, long loop_time, short init)
	
	static short current_time = 0;
	current_time = init;
		
	// set up the first time through	
	sleep_until( LevelEventStatus( "start seconds one" ), 1 );
	current_time = current_time + 1;
	
	if (current_time == 0 or current_time == 10) then
			object_set_permutation (num, "","0");
			current_time = 0;
			NotifyLevel( "start seconds tens" );		
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			object_set_permutation (num, "","4");
	end
	
	if (current_time == 5) then
			object_set_permutation (num, "","5");
	end
	
	if (current_time == 6) then
			object_set_permutation (num, "","6");
	end
	
	if (current_time == 7) then
			object_set_permutation (num, "","7");
	end
	
	if (current_time == 8) then
			object_set_permutation (num, "","8");
	end

	if (current_time == 9) then
			object_set_permutation (num, "","9");
	end		
			
	repeat 
		current_time = current_time + 1;
			
		if (current_time == 0 or current_time == 10) then
				object_set_permutation (num, "","0");
				current_time = 0;
				NotifyLevel( "start seconds tens" );		
		end
		
		if (current_time == 1) then
				object_set_permutation (num, "","1");
		end
		
		if (current_time == 2) then
				object_set_permutation (num, "","2");
		end
		
		if (current_time == 3) then
				object_set_permutation (num, "","3");
		end

		if (current_time == 4) then
				object_set_permutation (num, "","4");
		end
		
		if (current_time == 5) then
				object_set_permutation (num, "","5");
		end
		
		if (current_time == 6) then
				object_set_permutation (num, "","6");
		end
		
		if (current_time == 7) then
				object_set_permutation (num, "","7");
		end
		
		if (current_time == 8) then
				object_set_permutation (num, "","8");
		end

		if (current_time == 9) then
				object_set_permutation (num, "","9");
		end		
		
	until (1 == 0, 30 * loop_time);

end

script static void set_cryo_clock_num_sec_10(object num, long loop_time, short init)
	
	static short current_time = 0;
	current_time = init;

	// set up the first time through	
	sleep_until( LevelEventStatus( "start seconds tens" ), 1 );
	current_time = current_time + 1;

	if (current_time == 0 or current_time == 6) then
			object_set_permutation (num, "","0");
			current_time = 0;		
			NotifyLevel( "start minutes one" );
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			object_set_permutation (num, "","4");
	end
	
	if (current_time == 5) then
			object_set_permutation (num, "","5");
	end		
				
	// clock loop				
	repeat 	
		current_time = current_time + 1;
		
		if (current_time == 0 or current_time == 6) then
				object_set_permutation (num, "","0");
				current_time = 0;		
				NotifyLevel( "start minutes one" );
		end
		
		if (current_time == 1) then
				object_set_permutation (num, "","1");
		end
		
		if (current_time == 2) then
				object_set_permutation (num, "","2");
		end
		
		if (current_time == 3) then
				object_set_permutation (num, "","3");
		end

		if (current_time == 4) then
				object_set_permutation (num, "","4");
		end
		
		if (current_time == 5) then
				object_set_permutation (num, "","5");
		end


	until (1 == 0, 30 * loop_time);

end

script static void set_cryo_clock_num_min_1(object num, long loop_time, short init)
	
	static short current_time = 0;
	current_time = init;
	
	// first time through

	sleep_until( LevelEventStatus( "start minutes one" ), 1 );
	current_time = current_time + 1;
		
	if (current_time == 0 or current_time == 10) then
				object_set_permutation (num, "","0");
				current_time = 0;
				NotifyLevel( "start minutes tens" );

	end
		
	if (current_time == 1) then
				object_set_permutation (num, "","1");
	end
		
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			object_set_permutation (num, "","4");
	end
	
	if (current_time == 5) then
			object_set_permutation (num, "","5");
	end
	
	if (current_time == 6) then
			object_set_permutation (num, "","6");
	end
	
	if (current_time == 7) then
			object_set_permutation (num, "","7");
	end
	
	if (current_time == 8) then
			object_set_permutation (num, "","8");
	end

	if (current_time == 9) then
			object_set_permutation (num, "","9");
	end		
	
	// clock loop	
	repeat 
		current_time = current_time + 1;
	
		if (current_time == 0 or current_time == 10) then
				object_set_permutation (num, "","0");
				current_time = 0;
				NotifyLevel( "start minutes tens" );
		end
		
		if (current_time == 1) then
				object_set_permutation (num, "","1");
		end
		
		if (current_time == 2) then
				object_set_permutation (num, "","2");
		end
		
		if (current_time == 3) then
				object_set_permutation (num, "","3");
		end

		if (current_time == 4) then
				object_set_permutation (num, "","4");
		end
		
		if (current_time == 5) then
				object_set_permutation (num, "","5");
		end
		
		if (current_time == 6) then
				object_set_permutation (num, "","6");
		end
		
		if (current_time == 7) then
				object_set_permutation (num, "","7");
		end
		
		if (current_time == 8) then
				object_set_permutation (num, "","8");
		end

		if (current_time == 9) then
				object_set_permutation (num, "","9");
		end		
		
	until (1 == 0, 30 * loop_time);

end

script static void set_cryo_clock_num_min_10(object num, long loop_time, short init)
	
	static short current_time = 0;
	current_time = init;
	
	// set up the first time through	
	sleep_until( LevelEventStatus( "start minutes tens" ), 1 );
	current_time = current_time + 1;
	
	if (current_time == 0 or current_time == 6) then
			object_set_permutation (num, "","0");
			current_time = 0;
			NotifyLevel( "start hours ones" );
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			object_set_permutation (num, "","4");
	end
	
	if (current_time == 5) then
			object_set_permutation (num, "","5");
	end
	
	// clock loop
	repeat 
		current_time = current_time + 1;

		if (current_time == 0 or current_time == 6) then
				object_set_permutation (num, "","0");
				current_time = 0;
				NotifyLevel( "start hours ones" );
		end
		
		if (current_time == 1) then
				object_set_permutation (num, "","1");
		end
		
		if (current_time == 2) then
				object_set_permutation (num, "","2");
		end
		
		if (current_time == 3) then
				object_set_permutation (num, "","3");
		end

		if (current_time == 4) then
				object_set_permutation (num, "","4");
		end
		
		if (current_time == 5) then
				object_set_permutation (num, "","5");
		end
			
	until (1 == 0, 30 * loop_time);

end

script static void set_cryo_clock_num_hour_1(object num, long loop_time, short init, short ten_accum_init)
	
	static short current_time = 0;
	static short ten_accum = 0;
	static short loop_accum = 0;
		
	current_time = init;
	ten_accum = ten_accum_init;

	// set up the first time through	
	sleep_until( LevelEventStatus( "start hours ones" ), 1 );
	current_time = current_time + 1;
	
	if (current_time == 0 or current_time == 10) then
			object_set_permutation (num, "","0");
			current_time = 0;
			ten_accum = ten_accum + 1;
			NotifyLevel( "start hours tens" );
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			if (ten_accum == 2) then
				object_set_permutation (num, "","0");
				current_time = 0;
				ten_accum = 0;
				NotifyLevel( "start hours tens" );
			else
				object_set_permutation (num, "","4");
			end		
	end
	
	if (current_time == 5 ) then
			object_set_permutation (num, "","5");
	end
	
	if (current_time == 6) then
			object_set_permutation (num, "","6");
	end
	
	if (current_time == 7) then
			object_set_permutation (num, "","7");
	end
	
	if (current_time == 8) then
			object_set_permutation (num, "","8");
	end

	if (current_time == 9) then
			object_set_permutation (num, "","9");
	end		
			
	// clock loop
	repeat 
		loop_accum = loop_accum + 1;
		
		if (loop_accum == loop_time) then
			loop_accum = 0;
			current_time = current_time + 1;
		
			if (current_time == 0 or current_time == 10) then
					object_set_permutation (num, "","0");
					current_time = 0;
					ten_accum = ten_accum + 1;
					NotifyLevel( "start hours tens" );
			end
			
			if (current_time == 1) then
					object_set_permutation (num, "","1");
			end
			
			if (current_time == 2) then
					object_set_permutation (num, "","2");
			end
			
			if (current_time == 3) then
					object_set_permutation (num, "","3");
			end
	
			if (current_time == 4) then
					if (ten_accum == 2) then
						object_set_permutation (num, "","0");
						current_time = 0;
						ten_accum = 0;
						NotifyLevel( "start hours tens" );
					else
						object_set_permutation (num, "","4");
					end		
			end
			
			if (current_time == 5 ) then
					object_set_permutation (num, "","5");
			end
			
			if (current_time == 6) then
					object_set_permutation (num, "","6");
			end
			
			if (current_time == 7) then
					object_set_permutation (num, "","7");
			end
			
			if (current_time == 8) then
					object_set_permutation (num, "","8");
			end
	
			if (current_time == 9) then
					object_set_permutation (num, "","9");
			end			
		end	
	until (1 == 0, 30);

end

script static void set_cryo_clock_num_hour_10(object num, long loop_time, short init)
	
	static short current_time = 0;
	static short loop_accum = 0;
	current_time = init;

	// set up the first time through	
	sleep_until( LevelEventStatus( "start hours tens" ), 1 );
	current_time = current_time + 1;
	
	if (current_time == 0 or current_time == 3) then
			object_set_permutation (num, "","0");
			current_time = 0;
			NotifyLevel( "start days ones" );
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
			
	// clock loop
	repeat 
		loop_accum = loop_accum + 1;

		if (loop_accum == loop_time) then
			loop_accum = 0;			
			current_time = current_time + 1;
	
			if (current_time == 0 or current_time == 3) then
					object_set_permutation (num, "","0");
					current_time = 0;
					NotifyLevel( "start days ones" );
			end
			
			if (current_time == 1) then
					object_set_permutation (num, "","1");
			end
			
			if (current_time == 2) then
					object_set_permutation (num, "","2");
			end
		end
	until (1 == 0, 30);

end

script static void set_cryo_clock_num_day_1(object num, long loop_time, short init)
	
	static short current_time = 0;
	static short loop_accum = 0;
	current_time = init;

	// set up the first time through	
	sleep_until( LevelEventStatus( "start days ones" ), 1 );
	current_time = current_time + 1;
	
	if (current_time == 0 or current_time == 10) then
			object_set_permutation (num, "","0");
			current_time = 0;
			NotifyLevel( "start days tens" );
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			object_set_permutation (num, "","4");
	end
	
	if (current_time == 5) then
			object_set_permutation (num, "","5");
	end
	
	if (current_time == 6) then
			object_set_permutation (num, "","6");
	end
	
	if (current_time == 7) then
			object_set_permutation (num, "","7");
	end
	
	if (current_time == 8) then
			object_set_permutation (num, "","8");
	end

	if (current_time == 9) then
			object_set_permutation (num, "","9");
	end		
	// clock loop
	repeat 
		loop_accum = loop_accum + 1;
		
		if (loop_accum == loop_time) then
			loop_accum = 0;
			current_time = current_time + 1;
	
			if (current_time == 0 or current_time == 10) then
					object_set_permutation (num, "","0");
					current_time = 0;
					NotifyLevel( "start days tens" );
			end
			
			if (current_time == 1) then
					object_set_permutation (num, "","1");
			end
			
			if (current_time == 2) then
					object_set_permutation (num, "","2");
			end
			
			if (current_time == 3) then
					object_set_permutation (num, "","3");
			end
	
			if (current_time == 4) then
					object_set_permutation (num, "","4");
			end
			
			if (current_time == 5) then
					object_set_permutation (num, "","5");
			end
			
			if (current_time == 6) then
					object_set_permutation (num, "","6");
			end
			
			if (current_time == 7) then
					object_set_permutation (num, "","7");
			end
			
			if (current_time == 8) then
					object_set_permutation (num, "","8");
			end
	
			if (current_time == 9) then
					object_set_permutation (num, "","9");
			end
		end	
	until (1 == 0, 30);

end

script static void set_cryo_clock_num_day_10(object num, long loop_time, short init, short ten_accum_init)
	
	static short current_time = 0;
	static short loop_accum = 0;
	current_time = init;
	
	static short ten_accum = 0;
	ten_accum = ten_accum_init;
	
	// set up the first time through	
	sleep_until( LevelEventStatus( "start days tens" ), 1 );
	current_time = current_time + 1;

	if (current_time == 0 or current_time == 10) then
			object_set_permutation (num, "","0");
			current_time = 0;
			ten_accum = ten_accum + 1;
			NotifyLevel( "start days hundreds" );
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end
	
	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end

	if (current_time == 4) then
			object_set_permutation (num, "","0");
	end
	
	if (current_time == 5 ) then
			if (ten_accum == 36) then
				object_set_permutation (num, "","0");
				current_time = 0;
				ten_accum = 0;
				NotifyLevel( "start days hundreds" );
			else
				object_set_permutation (num, "","5");
			end		
	end
	
	if (current_time == 6) then
			object_set_permutation (num, "","6");
	end
	
	if (current_time == 7) then
			object_set_permutation (num, "","7");
	end
	
	if (current_time == 8) then
			object_set_permutation (num, "","8");
	end

	if (current_time == 9) then
			object_set_permutation (num, "","9");
	end		

	// clock loop
	repeat 
		loop_accum = loop_accum + 1;

		if (loop_accum == loop_time) then
				loop_accum = 0;		
				current_time = current_time + 1;
		
				if (current_time == 0 or current_time == 10) then
						object_set_permutation (num, "","0");
						current_time = 0;
						ten_accum = ten_accum + 1;
						NotifyLevel( "start days hundreds" );
				end
				
				if (current_time == 1) then
						object_set_permutation (num, "","1");
				end
				
				if (current_time == 2) then
						object_set_permutation (num, "","2");
				end
				
				if (current_time == 3) then
						object_set_permutation (num, "","3");
				end
		
				if (current_time == 4) then
						object_set_permutation (num, "","0");
				end
				
				if (current_time == 5 ) then
						if (ten_accum == 36) then
							object_set_permutation (num, "","0");
							current_time = 0;
							ten_accum = 0;
							NotifyLevel( "start days hundreds" );
						else
							object_set_permutation (num, "","5");
						end		
				end
				
				if (current_time == 6) then
						object_set_permutation (num, "","6");
				end
				
				if (current_time == 7) then
						object_set_permutation (num, "","7");
				end
				
				if (current_time == 8) then
						object_set_permutation (num, "","8");
				end
		
				if (current_time == 9) then
						object_set_permutation (num, "","9");
				end		
			end
	until (1 == 0, 30);

end

script static void set_cryo_clock_num_day_100(object num, long loop_time, short init)
	
	static short current_time = 0;
	static short loop_accum = 0;

	current_time = init;

	// set up the first time through	
	sleep_until( LevelEventStatus( "start days hundreds" ), 1 );
	current_time = current_time + 1;

	if (current_time == 0 or current_time == 3) then
			object_set_permutation (num, "","0");
			current_time = 0;
	end
	
	if (current_time == 1) then
			object_set_permutation (num, "","1");
	end
	
	if (current_time == 2) then
			object_set_permutation (num, "","2");
	end

	if (current_time == 3) then
			object_set_permutation (num, "","3");
	end
					
	repeat 
		loop_accum = loop_accum + 1;
		
		if (loop_accum == loop_time) then
			loop_accum = 0;
			current_time = current_time + 1;
	
			if (current_time == 0 or current_time == 3) then
					object_set_permutation (num, "","0");
					current_time = 0;
			end
			
			if (current_time == 1) then
					object_set_permutation (num, "","1");
			end
			
			if (current_time == 2) then
					object_set_permutation (num, "","2");
			end
	
			if (current_time == 3) then
					object_set_permutation (num, "","3");
			end		
		end	
	until (1 == 0, 30);

end

///////////////////////////////////////////////////////////////////////////////////
// Stop the CRYOCLOCK (so sad)
///////////////////////////////////////////////////////////////////////////////////
script static void stop_cryo_clock()
	kill_thread (ms_1_thread);
	kill_thread (ms_10_thread);
	kill_thread (sec_1_thread);
	kill_thread (sec_10_thread);
	kill_thread (min_1_thread);
	kill_thread (min_10_thread);
	kill_thread (hours_1_thread);
	kill_thread (hours_10_thread);
	kill_thread (days_1_thread);
	kill_thread (days_10_thread);
	kill_thread (days_100_thread);
end

// =================================================================================================
// =================================================================================================
// NARRATIVE BEATS
// =================================================================================================
// =================================================================================================


script dormant maw_opens_description()

	dprint("d");

end

script dormant m10_elevator_in_sight()
	sleep_until( volume_test_players(m10_elevator_in_sight), 1);
	dprint("vo_planet_reveal");
				wake(f_dialog_m10_elevator_in_sight);
end

script dormant m10_observ_atmosphere_breach()
		thread(f_dialog_m10_observ_atmosphere_breach());
end

script dormant m10_observatory_get_objective_beacon_main()
sleep_until( volume_test_players(observatory_exit), 1);
	kill_script(m10_observ_stragglers);
	sleep_forever(m10_observ_stragglers);
	 if b_osb_line_fired == FALSE then
			wake(f_dialog_observatory_get_objective_beacon_main);
			wake(m10_observ_atmosphere_breach);
			b_osb_line_fired = true;
	 end
end



script static void m10_observ_stragglers()
		sleep_s(120);
		wake(f_dialog_m10_observ_stragglers);
end


script dormant m10_observatory_get_objective_beacon_alt()
		sleep_until( volume_test_players(observatory_front_windows), 1);
		kill_script(m10_observ_stragglers);
		sleep_forever(m10_observ_stragglers);
		 if b_osb_line_fired == FALSE then
					wake(f_dialog_observatory_get_objective_beacon_alt);
					wake(m10_observ_atmosphere_breach);
				b_osb_line_fired = true;
	 	 end
			
end


/*script dormant m10_post_second_elevator()
	     	sleep_until( volume_test_players(post_second_elevator), 1);
				wake(f_dialog_m10_post_second_elevator);
end
*/
script dormant m10_lookout_post()
	
	sleep_until(volume_test_players(lookout_post), 1);
  wake(f_dialog_lookout_post);
  
end

script dormant m10_cafe_vo()
	
	sleep_until(volume_test_players(m10_cafe_vo), 1);
  wake(f_dialog_m10_cafe);
  
end


script dormant m10_beacon_prep()
	
	sleep_until(volume_test_players(m10_beacon_prep), 1);
 // wake(f_dialog_beacon_prep);
  
end



script dormant m10_kill_zone()
   sleep_until(volume_test_players(m10_kill_zone), 1);
	dprint("beacon_launch_beacon");
				wake(f_dialog_kill_zone);
end



script dormant m10_beacon_launch_beacon()
   sleep_until(volume_test_players(beacon_launch_beacon), 1);
	dprint("beacon_launch_beacon");
				wake(f_dialog_beacon_launch_beacon);
end

script dormant m10_beacon_controls()
	sleep_until((unit_get_health(sq_3_elite) <= 0) and (device_get_position( missile_control_switch ) == 0), 1);
	dprint("m10_beacon_controls");
		wake(f_dialog_near_missile_room);
			//	wake(f_dialog_beacon_controls);

end


script static void m10_kill_objective_4()
		sleep_until (object_valid (obs_plinth_control), 1);
		kill_script(m10_objective_4_nudge);

end

script dormant m10_start_observatory_pip()
	
///MWG : Adding a sleep until object valid to kill debug spew
	sleep_until(object_valid(obs_plinth_control));
	
	sleep_until (device_get_position(obs_plinth_control) != 0, 1);
			sleep_s(1);
		hud_play_pip_from_tag( bink\campaign\M10_B_60 );
end


script static void m10_missile_launched()
		sleep_until (object_valid (missile_control_switch), 1);
		sleep_until (device_get_position(missile_control_switch) > 0.0, 1 );
		wake(f_dialog_missile_launched);

end

script static void m10_vo_planet_reveal()
	  sleep_until( volume_test_players(vo_planet_reveal), 1);
	dprint("vo_planet_reveal");
				wake(f_dialog_vo_planet_reveal);
end

/*script static void m10_vo_airlock_return()
	sleep_until( volume_test_players(vo_airlock_return), 1);
	dprint("vo_airlock_return");
				wake(f_dialog_vo_airlock_return);
end*/

script static void m10_system_depressurization()
	sleep_until( volume_test_players(m10_system_depressurization), 1);
	dprint("m10_system_depressurization");
				thread(f_dialog_system_depressurization());
end

script static void m10_hull_integrity_30()
	sleep_until( volume_test_players(vo_airlock_return), 1);
	dprint("m10_hull_integrity_30");
				thread(f_dialog_m10_hull_integrity_30());
end

script static void m10_hull_integrity_25()
	sleep_until( volume_test_players(m10_hull_integrity_25), 1);
	dprint("m10_hull_integrity_25");
				thread(f_dialog_m10_hull_integrity_25());
end

script static void m10_hull_integrity_15()
	sleep_until( volume_test_players(m10_hull_integrity_15), 1);
	dprint("m10_hull_integrity_15");
				thread(f_dialog_m10_hull_integrity_15());
end

script static void m10_hull_integrity_10()
	sleep_until( volume_test_players(m10_hull_integrity_10), 1);
	dprint("m10_hull_integrity_10)");
				thread(f_dialog_m10_hull_integrity_10());
				wake( f_dialog_Breakhall01_Action );
end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================


script static void m10_objective_1_nudge()
			dprint("Nudge 1 fired");
			sleep_s(300);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m10_objective_1());
			end
			if b_objective_1_complete == FALSE then
					thread(m10_objective_1_nudge());
			end
end

script static void m10_objective_2_nudge()
			dprint("Nudge 2 fired");
			sleep_s(300);
			if b_objective_2_complete == FALSE then
						thread(f_dialog_m10_objective_2());
			end
			if b_objective_2_complete == FALSE then
						thread(m10_objective_2_nudge());
			end
end

script static void m10_objective_3_nudge()
			dprint("Nudge 3 fired");
			sleep_s(300);
			if b_objective_3_complete == FALSE then
						thread(f_dialog_m10_objective_3());
			end
			if b_objective_3_complete == FALSE then
				thread(m10_objective_3_nudge());
			end
end


script static void m10_objective_4_nudge()
			dprint("Nudge 4 fired");
			sleep_s(300);
			if b_objective_4_complete == FALSE then
						thread(f_dialog_m10_objective_4());
			end
			if b_objective_4_complete == FALSE then
					thread(m10_objective_4_nudge());
			end
end

script static void m10_objective_5_nudge()
			dprint("Nudge 5 fired");
			sleep_s(300);
			if b_objective_5_complete == FALSE then
						thread(f_dialog_m10_objective_5());
			end
			if b_objective_5_complete == FALSE then
					thread(m10_objective_5_nudge());
			end
end


script static void m10_objective_6_nudge()
			dprint("Nudge 6 fired");
			sleep_s(180);
			if b_objective_6_complete == FALSE then
						thread(f_dialog_m10_objective_6());
			end
			if b_objective_6_complete == FALSE then
					thread(m10_objective_6_nudge());
			end
end

script static void m10_objective_7_nudge()
			dprint("Nudge 7 fired");
			sleep_s(300);
			if b_objective_7_complete == FALSE then
						thread(f_dialog_m10_objective_7());
			end
			if b_objective_7_complete == FALSE then
						thread(m10_objective_7_nudge());
			end
end

script static void m10_objective_8_nudge()
			dprint("Nudge 8 fired");
			sleep_s(300);
			if b_objective_8_complete == FALSE then
						thread(f_dialog_m10_objective_8());
			end
			if b_objective_8_complete == FALSE then
						thread(m10_objective_8_nudge());
			end
					
end

script static void m10_objective_9_nudge()
			dprint("Nudge 9 fired");
			sleep_s(300);
			if b_objective_9_complete == FALSE then
						thread(f_dialog_m10_objective_9());
			end
			if b_objective_9_complete == FALSE then
						thread(m10_objective_9_nudge());
			end
end

script static void m10_objective_10_nudge()
			dprint("Nudge 10 fired");
			sleep_s(300);
			if b_objective_10_complete == FALSE then
						thread(f_dialog_m10_objective_10());
			end
			if b_objective_10_complete == FALSE then
					thread(m10_objective_10_nudge());
			end
end


// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================


script static void f_waypoint_equipment_unlock()

		wake(f_waypoint_global_equipment_unlock);
end

//Cheevo

script dormant m10_achievement_unlock()
	sleep_until(object_valid(history_switch));
	sleep_until (device_get_position(history_switch) != 0);
	submit_incident_with_cause_player (achieve_m10_special, player0);
	submit_incident_with_cause_player (achieve_m10_special, player1);
	submit_incident_with_cause_player (achieve_m10_special, player2);
	submit_incident_with_cause_player (achieve_m10_special, player3);
	dprint("ACHIEVEMENT UNLOCKED");
end