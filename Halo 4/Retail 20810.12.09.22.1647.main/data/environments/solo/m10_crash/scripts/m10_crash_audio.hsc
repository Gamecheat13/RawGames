
; =================================================================================================
; =================================================================================================
; *** GLOBALS ***
; =================================================================================================
; =================================================================================================
global looping_sound amb_current = "";

global boolean b_audio_debug = false;

script static void audio_print(string s)
	if b_audio_debug then
		print (s);
	end
end

script static void sleep_until_observatory_assassination_started()
	sleep_until ((ai_strength (ai_observatory_init) < 1) or player_action_test_grenade_trigger() or player_action_test_primary_trigger()  ,1);
end

script startup f_audio_main()
	sleep_until( b_mission_started == TRUE );
	
	audio_print("f_audio_main");
	wake(f_amb_m10_a01_pod_exit);
	wake(f_amb_m10_a01_exit);
	wake(f_amb_m10_a02_exit);
	wake(f_amb_m10_a04_exit);
	wake(f_amb_m10_a05_exit);
	wake(f_amb_m10_a06_halfway);
	
	// HACK - this is here until I can get an explicit hook from another script (patridu)
	wake(f_music_beacon_deck_exited_first_airlock);
	
	wake(f_amb_m10_enter_rooms_cryo);
	wake(f_amb_m10_enter_rooms_armory);
	wake(f_amb_m10_enter_rooms_hallways);
	wake(f_amb_m10_enter_rooms_observatory);
	wake(f_amb_m10_enter_rooms_lookout);
	wake(f_amb_m10_enter_rooms_airlock);
	wake(f_amb_m10_enter_rooms_maintenance);
	wake(f_amb_m10_enter_rooms_pod_chase);
	
	thread (sfx_campaign_enter());
	thread(f_music_state_controller());
	
	thread (load_music_for_zone_set());
end

// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m10_music_progression = 0;
global long s_music_zone_set_thread_id = 0;


script static void load_music_for_zone_set()
	sleep_until(b_m10_music_progression > 0 or current_zone_set_fully_active() == S_zoneset_00_cryo_02_hallway_04_armory, 1);
	
	music_start('Play_mus_m10_start');
	
	// cryo room
	sleep_until(b_m10_music_progression > 10 or volume_test_players (tv_music_r01_cryo_room), 1);
	if b_m10_music_progression <= 10 then
		// starts regions 1, 2, 3
		s_music_zone_set_thread_id = thread (f_zone_set_00_cryo_02_hallway_04_armory());
	end
	
	sleep_until(b_m10_music_progression > 15 or volume_test_players (tv_music_r04_hallway_elevator_lobby), 1);
	if (s_music_zone_set_thread_id != 0) then
		kill_thread (s_music_zone_set_thread_id);
		s_music_zone_set_thread_id = 0;
	end
	if b_m10_music_progression <= 15 then
		music_set_state('Play_mus_m10_r04_hallway_elevator_lobby');
	end
		
	sleep_until(b_m10_music_progression > 20 or volume_test_players (tv_music_r07_observatory), 1);
	if (s_music_zone_set_thread_id != 0) then
		kill_thread (s_music_zone_set_thread_id);
		s_music_zone_set_thread_id = 0;
	end
	if b_m10_music_progression <= 20 then
		sound_set_state('Set_State_M10_Observatory');
		music_set_state('Play_mus_m10_r07_observatory');
	end
	
	sleep_until(b_m10_music_progression > 25 or volume_test_players (tv_music_r08_elevator_lobby_top), 1);
	if (s_music_zone_set_thread_id != 0) then
		kill_thread (s_music_zone_set_thread_id);
		s_music_zone_set_thread_id = 0;
	end
	if b_m10_music_progression <= 25 then
		music_set_state('Play_mus_m10_r08_elevator_lobby_top');
	end

	sleep_until(b_m10_music_progression > 30 or volume_test_players (tv_music_r10_elevator_lobby_bottom), 1);
	if (s_music_zone_set_thread_id != 0) then
		kill_thread (s_music_zone_set_thread_id);
		s_music_zone_set_thread_id = 0;
	end
	if b_m10_music_progression <= 30 then
		sound_set_state('Set_State_M10_Elevator_Lobby_Bottom');
		music_set_state('Play_mus_m10_r10_elevator_lobby_bottom');
	end	

	// RALLY POINT BRAVO	
	sleep_until(b_m10_music_progression > 40 or volume_test_players (tv_music_r09_lookout), 1);
	if b_m10_music_progression <= 40 then
		music_set_state('Play_mus_m10_r09_lookout');
	end
	
	sleep_until(b_m10_music_progression > 50 or volume_test_players (tv_music_r11_cafe), 1);
	if b_m10_music_progression <= 50 then
		music_set_state('Play_mus_m10_r11_cafe');
	end
	
	sleep_until(b_m10_music_progression > 60 or volume_test_players (tv_music_r12_preparation_chamber), 1);
	if b_m10_music_progression <= 60 then
		music_set_state('Play_mus_m10_r12_preparation_chamber');
	end

	sleep_until(b_m10_music_progression > 60 or volume_test_players (tv_music_r13_corner_room), 1);
	if b_m10_music_progression <= 60 then
		music_set_state('Play_mus_m10_r13_corner_room');
	end
	
		sleep_until(b_m10_music_progression > 60 or volume_test_players (tv_amb_m10_c05_b), 1);
	if b_m10_music_progression <= 60 then
		music_set_state('Play_mus_m10_r14_box_room');
	end
	
	sleep_until(b_m10_music_progression > 60 or volume_test_players (tv_music_r15_airlock_a), 1);
	if b_m10_music_progression <= 60 then
		music_set_state('Play_mus_m10_r15_airlock_a');
	end
	
	sleep_until(b_m10_music_progression > 70 or volume_test_players (tv_music_r16_beacons), 1);
	if b_m10_music_progression <= 70 then
		if (s_music_zone_set_thread_id != 0) then
			kill_thread (s_music_zone_set_thread_id);
			s_music_zone_set_thread_id = 0;
		end
		sound_set_state('Set_State_M10_Beacons');
		// 16, 15
		s_music_zone_set_thread_id = thread (f_zone_set_28_airlock_30_beacons());
	end
	
	sleep_until(b_m10_music_progression > 80 or volume_test_players (tv_music_r17_broken_floor), 1);
	if b_m10_music_progression <= 80 then
		// 17, 18, 19
		if (s_music_zone_set_thread_id != 0) then
			kill_thread (s_music_zone_set_thread_id);
			s_music_zone_set_thread_id = 0;
		end
		s_music_zone_set_thread_id = thread (f_zone_set_28_airlock_32_broken());
	end
	
	// sleep_until(b_m10_music_progression > 100 or volume_test_players (tv_music_r20_vehicle_bay), 1);
	// thread(kill_music_thread());
	// if b_m10_music_progression <= 100 then
		// music_stop('Stop_mus_m10'); 
	// end

end

; =================================================================================================
; *** MUSIC ENCOUNTER HOOKS ***
; =================================================================================================
script static void f_mus_m10_e01_begin()
	dprint("f_mus_m10_e01");
	music_set_state('Play_mus_m10_e01_obervatory');
end

script static void f_mus_m10_e02_begin()
	dprint("f_mus_m10_e02");
	music_set_state('Play_mus_m10_e03_hallways');
end

script static void f_mus_m10_e03_begin()
	dprint("f_mus_m10_e03");
	music_set_state('Play_mus_m10_e05_flank_room');
end

script static void f_mus_m10_e04_begin()
	dprint("f_mus_m10_e04");
	music_set_state('Play_mus_m10_e07_beacon');
end

script static void f_mus_m10_e05_begin()
	dprint("f_mus_m10_e05");
	music_set_state('Play_mus_m10_e09_maintenance_upper');
end

script static void f_mus_m10_e06_begin()
	dprint("f_mus_m10_e06");
	music_set_state('Play_mus_m10_e11_maintenance_lower');
end

script static void f_mus_m10_e01_finish()
	dprint("f_mus_m10_e01");
	music_set_state('Play_mus_m10_e02_obervatory_end');
end

script static void f_mus_m10_e02_finish()
	dprint("f_mus_m10_e02");
	music_set_state('Play_mus_m10_e04_hallways_end');
end

script static void f_mus_m10_e03_finish()
	dprint("f_mus_m10_e03");
	music_set_state('Play_mus_m10_e06_flank_room_end');
end

script static void f_mus_m10_e04_finish()
	dprint("f_mus_m10_e04");
	music_set_state('Play_mus_m10_e08_beacon_end');
end

script static void f_mus_m10_e05_finish()
	dprint("f_mus_m10_e05");
	music_set_state('Play_mus_m10_e10_maintenance_upper_end');
end

script static void f_mus_m10_e06_finish()
	dprint("f_mus_m10_e06");
	music_set_state('Play_mus_m10_e12_maintenance_lower_end');
end

; =================================================================================================
; *** MUSIC ZONESET HOOKS ***
; =================================================================================================
script static void f_zone_set_00_cryo_02_hallway_04_armory()
	music_set_state('Play_mus_m10_r01_cryo_room');
	
	sleep_until (volume_test_players(tv_amb_m10_a02), 1);
	music_set_state('Play_mus_m10_r02_hallways_cryo');

	sleep_until (volume_test_players(tv_amb_m10_a05), 1);
	music_set_state('Play_mus_m10_r03_armory');
end

script static void f_zone_set_28_airlock_30_beacons()
	music_set_state('Play_mus_m10_r16_beacons');
	
	sleep_until( volume_test_players(vo_airlock_return), 1);
	music_set_state('Play_mus_m10_r15_airlock_b');
end

script static void f_zone_set_28_airlock_32_broken()
	music_set_state('Play_mus_m10_r17_broken_floor');
	
	sleep_until (volume_test_players(tv_amb_m10_e05_lower), 1);
	music_set_state('Play_mus_m10_r18_maintenance');
	
	sleep_until (volume_test_players(tv_music_m10_explosionalley_hall1), 1);
	music_set_state('Play_mus_m10_r19_hallway_maintenance');
end

script static void f_sfx_insertion_reset( short s_index )
	
	if s_index == DEF_INSERTION_INDEX_CINEMATIC then
		sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_cinematic', NONE, 1.0);
	end
	if s_index == DEF_INSERTION_INDEX_CRYO then
		sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_cryo', NONE, 1.0);
	end
	if s_index == DEF_INSERTION_INDEX_LAB then
		sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_lab', NONE, 1.0);
	end
	if s_index == DEF_INSERTION_INDEX_ELEVATOR_ICS then
		sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_elevator_ics', NONE, 1.0);
	end
	if s_index == DEF_INSERTION_INDEX_OBSERVATORY then
		sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_observatory', NONE, 1.0);
		// m_m10_music_observatory_after_elevator_ics
		dprint("observatory music set");
  end
  if s_index == DEF_INSERTION_INDEX_FLANK then
  	sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_flank', NONE, 1.0);
  	// m_m10_music_observatory_hallway_1
		dprint("flank music set");
  end
  if s_index == DEF_INSERTION_INDEX_BEACONS then
  	sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_beacon', NONE, 1.0);
  	// m_m10_music_beacon_beginning
		dprint("beacons music set");
  end
  if s_index == DEF_INSERTION_INDEX_BROKEN then
  	sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_broken', NONE, 1.0);
  	// m_m10_music_escape_broken_floor
		dprint("broken floor music set");
  end
  if s_index == DEF_INSERTION_INDEX_EXPLOSIONALLEY then
  	sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_explosionalley', NONE, 1.0);
  	// m_m10_music_observatory_hallway_1
		dprint("explosion alley music set");
	end
	if s_index == DEF_INSERTION_INDEX_VEHICLEBAY then
	  sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_vehiclebay', NONE, 1.0);
	  // sound\environments\solo\m010\music\events\m_m10_music_escape_hallway_2
		dprint("vehicle bay music set");
	end
	if s_index == DEF_INSERTION_INDEX_SPACE then
		sound_impulse_start ('sound\environments\solo\m010\insertion_points\m_m10_insertion_point_jumpdebris', NONE, 1.0);
		// m_m10_music_escape_into_space
		dprint("jump debris music set");
	end
	
end

; =================================================================================================
; *** PLACEHOLDER ***
; =================================================================================================
script static void sfx_unsc_ship_destroy()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\streaming\m10_ship_destroy', NONE, 1);
end

script static void sfx_unsc_canister_explode_maintenance_hall(object canister_2)
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', canister_2, 1);
end

//************************************
// FUEL CANISTERS IN MAINTENANCE HALL
//************************************

script static void sfx_unsc_canister_explode_maintenance_hall_1()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', fuel_can_u_1, 1);
end

script static void sfx_unsc_canister_explode_maintenance_hall_2()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', grunt_killer, 1);
end

script static void sfx_unsc_canister_explode_maintenance_hall_3()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', cr_maintenance_fuel_can_05, 1);
end

script static void sfx_unsc_canister_explode_maintenance_hall_4()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', cr_maintenance_fuel_can_03, 1);
end

script static void sfx_unsc_canister_explode_maintenance_hall_5()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', fuel_can_u_2, 1);
end

script static void sfx_unsc_canister_explode_maintenance_hall_6()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', fuel_can_u_3, 1);
end

script static void sfx_unsc_canister_explode_maintenance_hall_7()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\explode\m10_vehicle_bay_explosions05', grunt_killer2, 1);
end

//************************************
//    Cryotube Gravity Generators
//************************************

script static void f_sfx_activating_gravity_generators()
	sound_impulse_start ('sound\environments\solo\m010\device_machines\cryotube\m10_gravity_generator', NONE, 1);
end

script static void sfx_cryo_exit()
	audio_print("[sfx] cryo exit");
	sound_impulse_start ('sound\environments\solo\m010\placeholder\doors\m_m10_cyro_chamber_exit', NONE, 1);
	sound_impulse_start ('sound\environments\solo\m010\device_machines\mach_m10_amb_cryotube_manual_release', NONE, 1);
end

script static void sfx_observatory_visor()
	audio_print("[sfx] observatory visor");
	sound_impulse_start ('sound\environments\solo\m010\placeholder\doors\m_m10_open_visor', NONE, 1);
end

//************************************
//    Doors
//************************************
script static void sfx_door_close()
	audio_print("[sfx] door close");
	sound_impulse_start ('sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_door_close', NONE, 1);
end

script static void sfx_weapon_rack_open()
	audio_print("[sfx] weapon rack open");
	sound_impulse_start ('sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_weapon_rack_open', NONE, 1);
end

script static void sfx_weapon_rack_close()
	audio_print("[sfx] weapon rack close");
	sound_impulse_start ('sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_weapon_rack_close', NONE, 1);
end

script static sound sfx_airlock_high_to_low()
	audio_print("[sfx] airlock high to low");
	sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_airlock_high_to_low;
end

script static sound sfx_airlock_low_to_high()
	audio_print("[sfx] airlock low to high");
	sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_airlock_low_to_high;
end

//************************************
//    Elevators
//************************************
script static void sfx_elevator_door_open( object target)
	sound_impulse_start ('sound\environments\solo\m010\device_machines\doors\m10_door_elevator_open', target, 1);
end

script static void sfx_elevator_double_door( object target)
	sound_impulse_start ('sound\environments\solo\m010\device_machines\doors\m10_double_door_elevator', target, 1);
end

//************************************
//   Other
//************************************

script static sound sfx_zero_g_breach()
	audio_print("[sfx] zero g breach");
	sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_zero_g_breach;
end

script static void sfx_ship_fly_by()
	audio_print("[sfx] ship fly by");
	sound_impulse_start ('sound\environments\solo\m010\placeholder\flyby\m_m10_placeholder_ship_fly_by', NONE, 1);
end

script static looping_sound sfx_rumble_low()
	sound\environments\solo\m010\placeholder\rumble\m_m10_placeholder_low_rumble;
end

script static looping_sound sfx_rumble_med()
	// XXX medium/high destruction rumble; beacon escape; broken floor
	sound\environments\solo\m010\placeholder\rumble\m_m10_placeholder_medium_rumble;
end

script static looping_sound sfx_rumble_high()
	// XXX high destruction rumble; maintenance
	sound\environments\solo\m010\placeholder\rumble\m_m10_placeholder_high_rumble;
end

script static looping_sound sfx_elevator_rumble()
	sound\environments\solo\m010\placeholder\rumble\m_m10_placeholder_elevator_rumble;
end

script static sound sfx_didact_pre_scan()
	sound\environments\solo\m010\fx\events\m10_fx_didact_scan_in;
end

script static sound sfx_didact_scan()
	sound\environments\solo\m010\fx\events\m10_fx_didact_scan;
end

script static sound sfx_hall_shake()
	// XXX temp
	sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_medium_01;
end

script static sound sfx_breaking_hallway()
	audio_print("[sfx] breaking hallway");
	//sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_escape_destruction_event_1', NONE, 1);
	music_state = 19;
	
	// XXX tag needs to return time
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_breaking_hallway;
end

script static sound sfx_broken_path_blocker()
	audio_print("[sfx] broken path blocker");
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_broken_path_blocker;
end

script static sound sfx_broken_room_destruction()
	audio_print("[sfx] broken room destruction");
	// XXX tag needs to return time
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_broken_room_destruction;
end

script static sound sfx_fud_explosion()
	audio_print("[sfx] fud explosion");
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_fud_explosion;
end

script static sound sfx_podchase_ship_explosion()
	audio_print("[sfx] podchase ship explosion");
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_ship_explosion;
end

script static sound sfx_maintenance_ramp_near_destruction()
	audio_print("[sfx] sfx_maintenance_ramp_near_destruction");
	// XXX tag needs to return time
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_maintenance_destruction;
end

script static sound sfx_maintenance_ramp_far_destruction()
	audio_print("[sfx] sfx_maintenance_ramp_far_destruction");
	// XXX tag needs to return time
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_maintenance_destruction;
end

script static sound sfx_vehicle_bay_destruction()
	audio_print("[sfx] vehicle bay destruction");
	// XXX tag needs to return time
	sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_vehicle_bay_destruction;
end

script static sound sfx_accelerator_in_position()
	audio_print("[sfx] accelerator in position");
	sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_accelerator_in_position;
end

script static sound sfx_beacon_doors_opening()
	audio_print("[sfx] beacon doors opening");
	sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_beacon_doors_opening;
end

script static sound sfx_beacon_destroyed()
	audio_print("[sfx] beacon destroyed");
	sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_beacon_destroyed;
end

script static sound sfx_beacon_launching()
	audio_print("[sfx] beacon launching");
	sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_beacon_launching;
end

script static void sfx_subcryo_alarm_start()
	audio_print("[sfx] subcryo alarm start");
	// object_create( m_m10_alarm_sub_cryo_hall_01 );
	// object_create( m_m10_alarm_sub_cryo_hall_02 );
end

script static void sfx_subcryo_alarm_stop()
	audio_print("[sfx] subcryo alarm stop");
	// object_destroy( m_m10_alarm_sub_cryo_hall_01 );
	// object_destroy( m_m10_alarm_sub_cryo_hall_02 );
end

script static void sfx_brokenroom_alarm_start()
	audio_print("[sfx] brokenroom alarm start");
	// object_create( m_m10_alarm_broken_room_01 );
	// object_create( m_m10_alarm_broken_room_02 );
end

script static void sfx_brokenroom_alarm_stop()
	audio_print("[sfx] brokenroom alarm stop");
	// object_destroy( m_m10_alarm_broken_room_01 );
	// object_destroy( m_m10_alarm_broken_room_02 );
end

script static void sfx_maintenance_alarm_start()
	audio_print("[sfx] maintenance alarm start");
	// object_create( m_m10_alarm_maintenance_01 );
	// object_create( m_m10_alarm_maintenance_02 );
	// object_create( m_m10_alarm_maintenance_03 );
end

script static void sfx_maintenance_alarm_stop()
	audio_print("[sfx] maintenance alarm stop");
	// object_destroy( m_m10_alarm_maintenance_01 );
	// object_destroy( m_m10_alarm_maintenance_02 );
	// object_destroy( m_m10_alarm_maintenance_03 );
end

script static void sfx_maintenance_hall_alarm_start()
	audio_print("[sfx] maintenance hall alarm start");
	// object_create( m_m10_alarm_maint_hall_01 );
	// object_create( m_m10_alarm_maint_hall_02 );
end

script static void sfx_maintenance_hall_alarm_stop()
	audio_print("[sfx] maintenance hall alarm stop");
	// object_destroy( m_m10_alarm_maint_hall_01 );
	// object_destroy( m_m10_alarm_maint_hall_02 );
end

script static void sfx_vehiclebay_alarm_start()
	audio_print("[sfx] vehiclebay alarm start");
	// object_create( m_m10_alarm_vehiclebay_01 );
	// object_create( m_m10_alarm_vehiclebay_02 );
end

script static void sfx_vehiclebay_alarm_stop()
	audio_print("[sfx] vehiclebay alarm stop");
	// object_destroy( m_m10_alarm_vehiclebay_01 );
	// object_destroy( m_m10_alarm_vehiclebay_02 );
end

// new alarms
global short S_end_alarm_state											= 0;
global short DEF_S_END_ALARM_STATE_AIRLOCK 					= 1;
global short DEF_S_END_ALARM_STATE_BROKEN_ROOM			= 2;
global short DEF_S_END_ALARM_STATE_MAINTENANCE 			= 3;
global short DEF_S_END_ALARM_STATE_EXPLOSION_ALLEY 	= 4;
global short DEF_S_END_ALARM_STATE_BLACKOUT					= 5;

script static void sfx_end_alarm_set( short s_state )
static looping_sound snd_alarm = NONE;

	if ( s_state > S_end_alarm_state ) then

		if ( snd_alarm != NONE ) then
			sound_looping_stop( snd_alarm );
			snd_alarm = NONE;
		end
	
		if ( s_state == DEF_S_END_ALARM_STATE_AIRLOCK ) then
			dprint( "sfx_end_alarm_set: DEF_S_END_ALARM_STATE_AIRLOCK" );
			snd_alarm = sound\storm\states\siren_intensity\set_state_airlock;
		end
		if ( s_state == DEF_S_END_ALARM_STATE_BROKEN_ROOM ) then
			dprint( "sfx_end_alarm_set: DEF_S_END_ALARM_STATE_BROKEN" );
			snd_alarm = sound\storm\states\siren_intensity\set_state_broken_destruction;
		end
		if ( s_state == DEF_S_END_ALARM_STATE_MAINTENANCE ) then
			dprint( "sfx_end_alarm_set: DEF_S_END_ALARM_STATE_MAINTENANCE" );
			snd_alarm = sound\storm\states\siren_intensity\set_state_maintenance_destruction;
		end
		if ( s_state == DEF_S_END_ALARM_STATE_EXPLOSION_ALLEY ) then
			dprint( "sfx_end_alarm_set: DEF_S_END_ALARM_STATE_EXPLOSION_ALLEY" );
			snd_alarm = sound\storm\states\siren_intensity\set_state_explosion_alley;
		end
		if ( s_state == DEF_S_END_ALARM_STATE_BLACKOUT ) then
			dprint( "sfx_end_alarm_set: DEF_S_END_ALARM_STATE_BLACKOUT" );
			snd_alarm = sound\storm\states\siren_intensity\set_state_black_out;
		end
		
		if ( snd_alarm != NONE ) then
			sound_looping_start( snd_alarm, NONE, 1.0 );
		end

	end

end

; =================================================================================================
; *** MUSIC ***
; =================================================================================================
script static void f_music_observatory_doors_opening()
	// sleep_until (LevelEventStatus("music observatory doors opening"), 1);
	
	// sound_impulse_start ('sound\environments\solo\m010\music\events\m10_music_stinger01_start', NONE, 1);
	
	// NEW for OYO
	audio_print("f_music_observatory_doors_opening");
	music_set_state('play_mus_m10_v06_observation_deck');
end

script static void f_music_observatory_first_pod_landed()
	// sleep_until (LevelEventStatus("music first pod landed"), 1);
	
	// audio_print("[music] stop stinger01");
	// sound_impulse_stop ('sound\environments\solo\m010\music\events\m10_music_stinger01_stop');
	
	// audio_print("[music] start action01");
	// sound_looping_start ('sound\environments\solo\m010\music\m10_music_action01', NONE, 1.0);
	
	// f_music_set_state_combat();
	
	// NEW for OYO
	//sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_observatory_covenant_fleet_attaches', NONE, 1.0);
	music_state = 20;
end

script static void f_music_observatory_combat_finished()
	// sleep_until (LevelEventStatus("activate power objective complete"), 1);
	f_music_set_state_idle();
end

script static void f_music_pre_flank()
	// sleep_until (volume_test_players(tv_pre_flank_spawn), 1);
	f_music_set_state_zoomed();
end

script static void f_music_main_flank()
	// sleep_until (volume_test_players(tv_main_flank_spawn), 1);
	f_music_set_state_combat();
end

script static void f_music_main_flank_killed_all_enemies()
	// go back to idle state after player kills this ai squad
	// sleep_until (
	// 	(ai_living_count(sq_prep_mid_boss) == 0) and
	// 	(ai_living_count(sq_prep_left) == 0) and
	// 	(ai_living_count(sq_prep_right) == 0), 
	// 1);
	f_music_set_state_idle();
end

script static void f_music_beacon_deck_reached_first_airlock()
	// sleep_until (volume_test_players(tv_music_beacon_deck_airlock), 1);
	audio_print("[music] stop action01");
	sound_looping_stop ('sound\environments\solo\m010\music\m10_music_action01');
end

// HACK - change this to a static function once we get a call from the mission scripts (patridu)
script dormant f_music_beacon_deck_exited_first_airlock()
	sleep_until(volume_test_players(tv_amb_exited_first_beacon_deck_airlock), 1);
	audio_print("[music] start action02");
	sound_looping_start ('sound\environments\solo\m010\music\m10_music_action02', NONE, 1.0);
end

script static void f_music_beacon_deck_launched_first_beacons()
	// sleep_until (LevelEventStatus("music beacons launching"), 1);
	audio_print("[music] launched first beacons - no op");
end

script static void f_music_beacon_deck_beacon_objective_complete()
	// sleep_until (LevelEventStatus("music launch beacon objective complete"), 1);
	audio_print("[music] stop action02");
	sound_looping_stop ('sound\environments\solo\m010\music\m10_music_action02');
end

script static void f_music_beacon_deck_cortana_vo_finished()
	// sleep_until (LevelEventStatus("music cortana done talking at beacon"), 1);
	audio_print("[music] start action03");
	sound_looping_start ('sound\environments\solo\m010\music\m10_music_action03', NONE, 1.0);
	
	// NEW
	//sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_escape_leave_beacon_deck', NONE, 1.0);
	music_state = 111;
	music_track = DEF_MUSIC_TRACK_ESCAPE_LEAVE_BEACON_DECK;
end

script static void f_music_vehicle_bay_destruction_start()
	// sleep_until (LevelEventStatus("music vehicle bay destruction start"), 1);
	audio_print("[music] stop action03");
	sound_looping_stop ('sound\environments\solo\m010\music\m10_music_action03');
end

// --- NEW for OYO ---
script static void f_music_observatory_get_cortana_requests_pull()
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_cortana_requests_pull', NONE, 1.0);
	music_state = 21;
	NotifyLevel("music_observatory_cortana_requested_pull");
end

script static void f_music_beacon_about_to_launch()
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_about_to_launch', NONE, 1.0);
	music_state = 22;
end

script static void f_music_beacon_launch_failure()
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_launch_fail', NONE, 1.0);
	music_state = 23;
end
// --- NEW for OYO ---

; =================================================================================================
; *** MUSIC INTERNAL ***
; =================================================================================================
script static void f_music_set_state_combat()
	audio_print("[music] Set State - Combat");
	sound_impulse_start('sound\environments\solo\set_state_combat', NONE, 1.0);
end

script static void f_music_set_state_idle()
	audio_print("[music] Set State - Idle");
	sound_impulse_start('sound\environments\solo\set_state_idle', NONE, 1.0);
end

script static void f_music_set_state_zoomed()
	audio_print("[music] Set State - Zoomed");
	sound_impulse_start('sound\environments\solo\set_state_zoomed', NONE, 1.0);
end

script static void f_music_action01()
	sound_looping_start ('sound\environments\solo\m010\music\m10_music_action01', NONE, 1.0);
end

; =================================================================================================
; *** AMBIENCES ***
; =================================================================================================
script dormant f_amb_m10_a01_pod_exit()
	sleep_until(LevelEventStatus("cryo objective complete"), 1);
	sound_impulse_start('sound\environments\solo\m010\ambience\events\amb_m10_a01_script_01_start', NONE, 1.0);
	audio_print("[amb] amb_m10_a01_script_01_start");
	// music_set_state('Play_mus_m10_r01_cryo_room');
end

script dormant f_amb_m10_a01_exit()
	sleep_until(volume_test_players(tv_amb_m10_a01_exit), 1);
	sound_impulse_start('sound\environments\solo\m010\ambience\events\amb_m10_a01_exit_stinger', NONE, 1.0);
	audio_print("[amb] amb_m10_a01_exit_stinger");
end

script dormant f_amb_m10_a02_exit()
	sleep_until(volume_test_players(tv_amb_m10_a02_exit), 1);
	sound_impulse_start('sound\environments\solo\m010\ambience\events\amb_m10_a03_script_start', NONE, 1.0);
	audio_print("[amb] amb_m10_a03_script_start");
end

script dormant f_amb_m10_a04_exit()
	sleep_until(volume_test_players(tv_amb_m10_a04_exit), 1);
	sound_impulse_start('sound\environments\solo\m010\ambience\events\amb_m10_a05_explosion_start', NONE, 1.0);
	audio_print("[amb] amb_m10_a05_explosion_start");
end

script dormant f_amb_m10_a05_exit()
	sleep_until(volume_test_players(tv_amb_m10_a05_exit), 1);
	sound_impulse_start('sound\environments\solo\m010\ambience\events\amb_m10_a06_explosion_start', NONE, 1.0);
	audio_print("[amb] amb_m10_a06_explosion_start");
end

script dormant f_amb_m10_a06_halfway()
	sleep_until(volume_test_players(tv_amb_m10_a06_halfway), 1);
	sound_impulse_start('sound\environments\solo\m010\ambience\events\amb_m10_a06_script_01_start', NONE, 1.0);
	audio_print("[amb] amb_m10_a06_script_01_start");
end

script static void f_trigger_ambience(trigger_volume tv, looping_sound amb_tag, string debug_text)
	repeat
	  // If a zoneset change left a loop running,
	  // and we're the thread owning that loop
	  // don't retrigger
	  if amb_current != amb_tag then
		   sleep_until(volume_test_players(tv), 1);
		   amb_current = amb_tag;
		   sound_looping_start(amb_tag, NONE, 1.0);
		   audio_print("[ set to current ]");
		   audio_print(debug_text);
		// else
		   // audio_print("[ ignoring (already current) ]");
		   // audio_print(debug_text);
		end
		sleep_until(volume_test_players(tv) == false, 1);
		sound_looping_stop(amb_tag);
		// audio_print(debug_text);
		sleep(30 * 1);
	until (false);
end

script static sound sfx_rumble_cryo()
	//sleep_until(b_fud_rumble_small == TRUE, 1);
	//sleep_s(1.470);
	//f_screenshake_event_low( -0.25, -1, -1, sound\environments\solo\m010\placeholder\rumble\events\m_m10_rumble_cryo );
	//sound\environments\solo\m010\scripted\events\m10_cryo_screenshake;
	sound\environments\solo\m010\scripted\events\m10_lab_exp_call_ahead;
end

script static sound sfx_rumble_lab()
	sound\environments\solo\m010\placeholder\rumble\events\m_m10_rumble_lab;
end

script static sound sfx_rumble_hall()
	//sleep_until(volume_test_players(tv_fud_rumble), 1);
	//sleep_s(2.2);
	//f_screenshake_event_med( -0.25, -1, -2.5, sound\environments\solo\m010\placeholder\rumble\events\m_m10_rumble_hall );
	sound\environments\solo\m010\placeholder\rumble\events\m_m10_rumble_hall;
end

script dormant f_amb_m10_enter_rooms_cryo()
	dprint("f_amb_m10_enter_rooms_cryo woke up");
	sleep_until (current_zone_set() == S_zoneset_00_cryo_02_hallway_04_armory);
	
	sleep_until (volume_test_players(tv_amb_m10_a01), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_01', NONE, 1.0);
	// music_set_state('Play_mus_m10_r02_hallways_cryo');
	
	sleep_until (volume_test_players(tv_amb_m10_a02), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_02', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a03), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_03', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a03_stairs), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_03_stairs', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a04), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_04', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a05), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_05', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a10), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_09', NONE, 1.0);
end

script dormant f_amb_m10_enter_rooms_armory()
	dprint("f_amb_m10_enter_rooms_armory woke up");
	// sleep_until (current_zone_set() == S_zoneset_04_armory_06_hallway);
	
	sleep_until (volume_test_players(tv_amb_m10_a06), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_06', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a07_outer), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_07_outer', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a07), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_07', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a08), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_08', NONE, 1.0);
	
	sleep_until (volume_test_players(tv_amb_m10_a09), 1);
	sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_09', NONE, 1.0);
end

script dormant f_amb_m10_enter_rooms_hallways()
  dprint("f_amb_m10_enter_rooms_hallways woke up");
	
  sleep_until (volume_test_players(tv_amb_m10_a10), 1);
  sound_impulse_start ('sound\environments\solo\m010\ambience\events\amb_m10_enter_room_10', NONE, 1.0);
end

// defines
global short DEF_MUSIC_TRACK_OBSERVATORY_AFTER_ELEVATOR_ICS = 1;
global short DEF_MUSIC_TRACK_OBSERVATORY_AIRLOCK 						= 2;
global short DEF_MUSIC_TRACK_BEACON_BEGINNING 							= 3;
global short DEF_MUSIC_TRACK_ESCAPE_LEAVE_BEACON_DECK 			= 4;


global short music_track = 0;
global short music_state = 0;

script static void f_music_state_controller()
	dprint ("starting music state_controller");
	repeat
		sleep_until(music_state != sound_music_current_state);

		if (music_track != sound_music_current_track) then

			if (music_track == DEF_MUSIC_TRACK_OBSERVATORY_AFTER_ELEVATOR_ICS) then
				dprint("music track: DEF_MUSIC_TRACK_OBSERVATORY_AFTER_ELEVATOR_ICS");
				sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_after_elevator_ics', NONE, 1.0);
			end
			if (music_track == DEF_MUSIC_TRACK_OBSERVATORY_AIRLOCK) then
				dprint("music track: DEF_MUSIC_TRACK_OBSERVATORY_AIRLOCK");
				sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_airlock', NONE, 1.0);
			end
			if (music_track == DEF_MUSIC_TRACK_BEACON_BEGINNING) then
				dprint("music track: DEF_MUSIC_TRACK_BEACON_BEGINNING");
				sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_beginning', NONE, 1.0);
			end
			if (music_track == DEF_MUSIC_TRACK_ESCAPE_LEAVE_BEACON_DECK) then
				dprint("music track: DEF_MUSIC_TRACK_ESCAPE_LEAVE_BEACON_DECK");
				sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_escape_leave_beacon_deck', NONE, 1.0);
			end

			sound_music_current_track = music_track;
		end

		if (music_state == 1) then
			dprint("state 1");
			//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_after_elevator_ics', NONE, 1.0);
		end
		if (music_state == 2) then
			dprint("music 2");
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_activate_switch', NONE, 1.0);
		end
		if (music_state == 3) then
			dprint("music 3");
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_elevator_switch', NONE, 1.0);
		end
		if (music_state == 4) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_pull_cortana', NONE, 1.0);
			dprint("music 4");
		end
		if (music_state == 5) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_hallway_1', NONE, 1.0);
			dprint("music 5");
		end
		if (music_state == 6) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_hallway_2', NONE, 1.0);
			dprint("music 6");
		end
		if (music_state == 7) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_activate', NONE, 1.0);
			dprint("music 7");
		end
		if (music_state == 8) then
			sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_beacon_activate_magnetic_accelerator', NONE, 1.0);
			dprint("music 8");
		end
		if (music_state == 9) then
			sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_beacon_launch_success', NONE, 1.0);
			dprint("music 9");
		end
		if (music_state == 10) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_after_air_lock', NONE, 1.0);
			dprint("music 10");
		end
		if (music_state == 11) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_intense_interior_battle', NONE, 1.0);
			dprint("music 11");
		end
		if (music_state == 12) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_broken_floor', NONE, 1.0);
			dprint("music 12");
		end
		if (music_state == 13) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_explosion_vignette', NONE, 1.0);
			dprint("music 13");
		end
		if (music_state == 14) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_hallway_2', NONE, 1.0);
			dprint("music 14");
		end
		if (music_state == 15) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_hallway_3', NONE, 1.0);
			dprint("music 15");
		end
		if (music_state == 16) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_hallway_4', NONE, 1.0);
			dprint("music 16");
		end
		if (music_state == 17) then
			// this is probably the only old event still being used
			music_set_state('Play_m_m10_music_escape_door_opening');
			// sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_door_opening', NONE, 1.0);
			dprint("music 17");
		end
		if (music_state == 18) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_into_space', NONE, 1.0);
			dprint("music 18");
		end
		if (music_state == 19) then
			sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_escape_destruction_event_1', NONE, 1);
			dprint("music 19");
		end
		if (music_state == 20) then
			sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_observatory_covenant_fleet_attaches', NONE, 1.0);
			dprint("music 20");
		end
		if (music_state == 21) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_cortana_requests_pull', NONE, 1.0);
			dprint("music 21");
		end
		if (music_state == 22) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_about_to_launch', NONE, 1.0);
			dprint("music 22");
		end
		if (music_state == 23) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_launch_fail', NONE, 1.0);
			dprint("music 23");
		end
		if (music_state == 24) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_assassination', NONE, 1.0);
			dprint("music 24");
		end
		/*
		if (music_state == 24) then
			sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_pre_blackout', NONE, 1.0);
			dprint("music 17");
		end
		*/

		sound_music_current_state = music_state;

	until (FALSE);
end

script static void f_music_m10_tweak01()
	dprint("f_music_m10_tweak01");
	music_set_state('Play_mus_m10_t01_tweak');
end

script static void f_music_m10_tweak02()
	dprint("f_music_m10_tweak02");
	music_set_state('Play_mus_m10_t02_tweak');
end

script static void f_music_m10_tweak03()
	dprint("f_music_m10_tweak03");
	music_set_state('Play_mus_m10_t03_tweak');
end

script static void f_music_m10_tweak04()
	dprint("f_music_m10_tweak04");
	music_set_state('Play_mus_m10_t04_tweak');
end

script static void f_music_m10_tweak05()
	dprint("f_music_m10_tweak05");
	music_set_state('Play_mus_m10_t05_tweak');
end

script static void f_music_m10_tweak06()
	dprint("f_music_m10_tweak06");
	music_set_state('Play_mus_m10_t06_tweak');
end

script static void f_music_m10_tweak07()
	dprint("f_music_m10_tweak07");
	music_set_state('Play_mus_m10_t07_tweak');
end

script static void f_music_m10_tweak08()
	dprint("f_music_m10_tweak08");
	music_set_state('Play_mus_m10_t08_tweak');
end

script static void f_music_m10_tweak09()
	dprint("f_music_m10_tweak09");
	music_set_state('Play_mus_m10_t09_tweak');
end

script static void f_music_m10_tweak10()
	dprint("f_music_m10_tweak10");
	music_set_state('Play_mus_m10_t10_tweak');
end

script dormant f_amb_m10_enter_rooms_observatory()
	dprint("f_amb_m10_enter_rooms_observatory woke up");
	
	sleep_until (volume_test_players(tv_amb_m10_b01), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_after_elevator_ics', NONE, 1.0);
	music_track = DEF_MUSIC_TRACK_OBSERVATORY_AFTER_ELEVATOR_ICS;
	music_state = 1;
	dprint("m_m10_music_observatory_after_elevator_ics");
	
	sleep_until_observatory_assassination_started();
	music_state = 24;
	dprint("m_m10_music_observatory_assassination");
	
	sleep_until (device_get_position(obs_plinth_control) != 0, 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_activate_switch', NONE, 1.0);
	music_state = 2;
	dprint("m_m10_music_observatory_activate_switch");
	
	// open observatory doors now controlled by m10_observatory_windows.frame_event_list
	// sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_observatory_opening_blast_shield', NONE, 1.0);
	
	// see f_dialog_observatory_get_cortana for 
		// m_m10_music_observatory_cortana_requests_pull
	
	//sleep_until (device_get_position(elevator_button_close) != 0, 1);
	sleep_until(device_get_position(door_elevator_1_top) == 1, 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_elevator_switch', NONE, 1.0);
	music_state = 3;
	//sound_impulse_start ('sound\environments\solo\m010\device_machine\m_m10_sfx_observatory_elevator_switch', elevator_button_close, 1.0);
	dprint("m_m10_music_observatory_elevator_switch");
end

script static void f_music_observatory_pull_cortana()
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_pull_cortana', NONE, 1.0);
	music_state = 4;
	dprint("m_m10_music_observatory_pull_cortana");
end

script dormant f_amb_m10_enter_rooms_lookout()
	sleep_until (current_zone_set() == S_zoneset_08_elevator_14_elevator_16_lookout);
	dprint("f_amb_m10_enter_rooms_lookout woke up");
	
	
	sleep_until (volume_test_players(tv_music_m10_lookout_staircase), 1);
	sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_hallway_1', NONE, 1.0);
	music_state = 5;
	dprint("m_m10_music_observatory_elevator_switch");
	
	sleep_until (current_zone_set() == S_zoneset_16_lookout_18_elevator_20_cafe);
	sleep_until (volume_test_players(tv_music_r11_cafe), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_hallway_2', NONE, 1.0);
	music_state = 6;
	dprint("m_m10_music_observatory_hallway_2");
end

script dormant f_amb_m10_enter_rooms_airlock()
	sleep_until (current_zone_set() == S_zoneset_24_corner_26_box_28_airlock);
	dprint("f_amb_m10_enter_rooms_airlock woke up");
	
	sleep_until (volume_test_players_all (tv_airlock_inside), 1);
	// this is the stop call
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_observatory_airlock', NONE, 1.0);
	music_track = DEF_MUSIC_TRACK_OBSERVATORY_AIRLOCK;
	music_state = 99;
	dprint("m_m10_music_observatory_airlock");
	
	sleep_until( dialog_id_valid_check(L_dialog_beacon_enter) );
	// starts beacon music
	music_track = DEF_MUSIC_TRACK_BEACON_BEGINNING;
	music_state = 100;
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_beginning', NONE, 1.0);
	dprint("m_m10_music_beacon_beginning");
	
	sleep_until (device_get_position(missile_control_switch) != 0, 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_beacon_activate', NONE, 1.0);
	music_state = 7;
	dprint("m_m10_music_beacon_activate");
	
	// see f_dialog_beacon_launch_beacon_01 for 
		// m_m10_music_beacon_about_to_launch
		// m_m10_music_beacon_launch_fail

	// see f_beacon_main for
		// m_m10_music_beacon_activate_magnetic_accelerator
		
	// see f_music_beacon_deck_cortana_vo_finished for
		// m_m10_music_escape_leave_beacon_deck
end

script static void f_music_m10_music_beacon_activate_magnetic_accelerator()
	//sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_beacon_activate_magnetic_accelerator', NONE, 1.0);
	music_state = 8;
end

script static void f_music_m10_beacon_launch_success()
	//sound_impulse_start('sound\environments\solo\m010\music\events\m_m10_music_beacon_launch_success', NONE, 1.0);
	music_state = 9;
end

script dormant f_amb_m10_enter_rooms_maintenance()

	// [brendanw 06/28/2012] 28_airlock_32_broken has been eliminated
	//sleep_until (current_zone_set() == S_zoneset_28_airlock_32_broken, 1);
	sleep_until (current_zone_set() == S_zoneset_32_broken_34_maintenance, 1);
	dprint("f_amb_m10_enter_rooms_maintenance woke up");
	
	sleep_until (volume_test_players (tv_amb_m10_e03_a), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_after_air_lock', NONE, 1.0);
	music_state = 10;
	dprint("m_m10_music_escape_after_air_lock");
	
	// see sfx_breaking_hallway for
		// sound\environments\solo\m010\music\events\m_m10_music_escape_destruction_event_1
		
	sleep_until (volume_test_players (tv_amb_m10_e05_upper) or volume_test_players_all (tv_amb_m10_e05_lower), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_intense_interior_battle', NONE, 1.0);
	music_state = 11;
	dprint("m_m10_music_escape_intense_interior_battle");
	
	sleep_until (volume_test_players (tv_amb_m10_e05_broken_floor), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_broken_floor', NONE, 1.0);
	music_state = 12;
	dprint("m_m10_music_escape_broken_floor");
	
	sleep_until (volume_test_players (tv_explosionalley_area), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_explosion_vignette', NONE, 1.0);
	music_state = 13;
	dprint("m_m10_music_escape_explosion_vignette");
	
	sleep_until (volume_test_players (tv_music_m10_explosionalley_hall1), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_hallway_2', NONE, 1.0);
	music_state = 14;
	dprint("m_m10_music_escape_hallway_2");
	
	sleep_until (volume_test_players (tv_music_m10_explosionalley_hall2), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_hallway_3', NONE, 1.0);
	music_state = 15;
	dprint("m_m10_music_escape_hallway_3");
	
	sleep_until (volume_test_players (tv_amb_m10_e07), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_hallway_4', NONE, 1.0);
	music_state = 16;
	dprint("m_m10_music_escape_hallway_4");
	
	sleep_until( volume_test_players(tv_vehiclebay_airlock_area), 1 );
	//music_state == 24;
	music_state = 17;
	sound_impulse_start ('sound\environments\solo\m010\scripted\events\m10_exp_alley_transition', NONE, 1.0);
	dprint("m_m10_music_escape_exit --------------------------------------------------------");
	
	//sleep_until (object_valid(dm_maintenance_hall_door01), 1);
	//sleep_until (not dm_maintenance_hall_door01->check_close(), 1);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_door_opening', NONE, 1.0);
	//dprint("m_m10_music_escape_door_opening");
end

script dormant f_amb_m10_enter_rooms_pod_chase()
	sleep_until (current_zone_set() == S_zoneset_40_debris_42_skybox);
	//sound_impulse_start ('sound\environments\solo\m010\music\events\m_m10_music_escape_into_space', NONE, 1.0);
	music_state = 18;
	dprint("f_amb_m10_enter_rooms_pod_chase woke up");
end

; =================================================================================================
; *** SFX MISSION HOOKS ***
; =================================================================================================
// === sfx_brokenfloor_destruction_pre::: Plays all sfx leading up to destruction
//		min pre time = 4.0 to 5.0 seconds
//		look at time = 3.0
//		total max time = 6.5 to 7.5
script static void sfx_brokenfloor_destruction_pre( real r_time )

	if ( not f_brokenfloor_destruction_started() ) then
		sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_brokenfloor_destruction_pre_a', NONE, 1);
		sleep_s( r_time / 4 );
		if ( not f_brokenfloor_destruction_started() ) then
			sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_brokenfloor_destruction_pre_b', NONE, 1);
			sleep_s( r_time / 4 );
			if ( not f_brokenfloor_destruction_started() ) then
				sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_brokenfloor_destruction_pre_c', NONE, 1);
				sleep_s( r_time / 4 );
			end
		end
	end

end

// === sfx_maintenance_destruction_pre::: Plays all sfx leading up to destruction
//		min pre time = 3.5 to 5.25 seconds
//		look at time = 5.5
//		total max time = 9.0 to 10.75
script static void sfx_maintenance_destruction_pre( real r_time )

	if ( not f_B_maintenance_destruction_started() ) then
		sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_maintenance_destruction_pre_a', NONE, 1);
		sleep_s( r_time / 4 );
		if ( not f_B_maintenance_destruction_started() ) then
			sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_maintenance_destruction_pre_b', NONE, 1);
			sleep_s( r_time / 4 );
			if ( not f_B_maintenance_destruction_started() ) then
				sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_maintenance_destruction_pre_c', NONE, 1);
				sleep_s( r_time / 4 );
			end
		end
	end

end

// === sfx_vehiclebay_destruction_pre::: Plays all sfx leading up to destruction
//		min pre time = 2.5 to 3.5 seconds
//		look at time = 4.0
//		total max time = 6.5 to 7.5
script static void sfx_vehiclebay_destruction_pre( real r_time )
/*
	if ( not f_vehiclebay_destruction_started() ) then
		sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_vehiclebay_destruction_pre_a', NONE, 1);
		sleep_s( r_time / 4 );
		if ( not f_vehiclebay_destruction_started() ) then
			sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_vehiclebay_destruction_pre_b', NONE, 1);
			sleep_s( r_time / 4 );
			if ( not f_vehiclebay_destruction_started() ) then
				sound_impulse_start('sound\environments\solo\m010\placeholder\destruction\m_m10_placeholder_vehiclebay_destruction_pre_c', NONE, 1);
				sleep_s( r_time / 4 );
			end
		end
	end
*/
	print("nop");
end

script static void sfx_explosion_alley_destruction( short s_sfx_state )
static short s_state_current = 0;

	if ( s_sfx_state > s_state_current ) then
		s_state_current = s_sfx_state;
		if ( s_sfx_state == 1 ) then
			f_screenshake_event_med(-0.5, -1, -0.25, 'sound\environments\solo\m010\scripted\events\m10_exp_alley_a.sound' );
		end
		if ( s_sfx_state == 2 ) then
			f_screenshake_event_med(-0.0, -1, -0.25, 'sound\environments\solo\m010\scripted\events\m10_exp_alley_b.sound' );
		end
		if ( s_sfx_state == 3 ) then
			f_screenshake_event_med(-0.0, -1, -0.25, 'sound\environments\solo\m010\scripted\events\m10_exp_alley_c.sound' );
		end
		if ( s_sfx_state == 4 ) then
			f_screenshake_event_med(-0.0, -1, -0.25, 'sound\environments\solo\m010\scripted\events\m10_exp_alley_d.sound' );
		end
		if ( s_sfx_state == 5 ) then
			f_screenshake_event_high(-0.0, -1, -0.25, 'sound\environments\solo\m010\scripted\events\m10_exp_alley_e.sound' );
		end
		if ( s_sfx_state == 6 ) then
			f_screenshake_event_high(-0.0, -1, -0.25, 'sound\environments\solo\m010\scripted\events\m10_exp_alley_f.sound' );
		end
	end

end

global boolean B_sfx_blackout_complete = FALSE;

script static void sfx_vehiclebay_blackout()
	dprint( "sfx_vehiclebay_blackout UPDATED" );

	f_screenshake_event_very_high( -0.925, 7, -3.0, sound\environments\solo\m010\scripted\events\m10_exp_alley_blackout );
	print("UPDATED RUMBLE HERE");
	B_sfx_blackout_complete = TRUE;
	
end

// -------------------------------------------------------------------------------------------------
// SFX: ZONE SET: SETUP
// -------------------------------------------------------------------------------------------------



; =================================================================================================
; *** TEMP for OYO ***
; =================================================================================================
script static void f_flank_play_demon_vo(ai kamikazeeGrunt)
	sound_impulse_start('sound\storm\characters\grunt\vo\npc_grunt_vo_demon', ai_get_object(kamikazeeGrunt), 1);
end
