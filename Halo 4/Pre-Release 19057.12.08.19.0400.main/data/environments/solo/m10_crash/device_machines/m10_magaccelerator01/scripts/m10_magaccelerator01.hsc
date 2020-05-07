//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()
	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );
end


global boolean b_beat_it = FALSE;
global boolean move_the_beacon = FALSE;
global boolean attach_player_to_obj = FALSE;
global boolean player_playing_push_anim = FALSE;

global boolean player_holding_action = FALSE;
global boolean player_pushing_stick = FALSE;

global boolean b_player_must_hold_action = TRUE;
global boolean b_player_must_push_stick = FALSE;

// rumble
static long L_rumble_ID = 0;
static long L_rumble_main_thread = 0;
static long L_rumble_scale_thread = 0;
static real r_rumble_bonus_mod_max = 1.0;

// device machine stop test
static short ts = 0;			// time start
static short te = 0;			// time end
static short td = 0;			// time delta
static real datt = 8;		// device animatation time total
static real satt = 0;			// static device animatation time total	
static real dsp = 0;			// device stop percentage
static real dat = 0.3;			// device animation time
static real dat_plus = 0.6;			// device animation time

static long mag_thread_id = 0;			// mag_thread_id
static long idle_anim_thread_id = 0;			// idle anim thread id;
static long push_anim_thread_id = 0;			// push anim thread id;
static boolean is_sliding = FALSE;
static boolean is_pushing = FALSE;
static boolean is_attached = FALSE;
static boolean is_ending = FALSE;
		
script static instanced void mag_stuck(cutscene_camera_point camera_1, device switch, player player_num)
	// HAX: replaced with mag cam 2 in narrative layer
	mag_thread_id = thread (mag_stuck_main(camera_1, switch, player_num));
end

script static instanced void mag_rumble_thread()
	if ( L_rumble_ID == 0 ) then
		if ( L_rumble_scale_thread == 0 ) then
			L_rumble_scale_thread = thread( mag_rumble_scale() );
		end
	
		repeat
		
			if ( player_pushing_stick ) then
				sleep_until( device_get_position(this) != 0.0, 1 );
				L_rumble_ID = f_screenshake_rumble_global_add_low( 0.5, NONE );
				sleep_until( not player_pushing_stick, 1 );
			else
				sleep_until( device_get_position(this) == 0.0, 1 );
				thread( mag_rumble_end() );
				sleep_until( player_pushing_stick, 1 );
			end
		
		until( FALSE, 1 );
	
	end
end

script static instanced void mag_rumble_end()

	if ( L_rumble_ID != 0 ) then
		thread( f_screenshake_rumble_global_remove(L_rumble_ID, -1, 0.125) );
		L_rumble_ID = 0;
	end
	
	if ( L_rumble_main_thread != 0 ) then
		kill_thread( L_rumble_main_thread );
		L_rumble_main_thread = 0;
	end
	
	if ( L_rumble_scale_thread != 0 ) then
		kill_thread( L_rumble_scale_thread );
		L_rumble_scale_thread = 0;
		f_screenshake_rumble_intensity_mod_set( 1.0 );
	end
	
end
script static instanced void mag_rumble_scale()
static real r_position = 0.0;

	repeat
		sleep_until( device_get_position(this) != 0.0, 1 );
	
		r_position = device_get_position( this );
	
		f_screenshake_rumble_intensity_mod_set( 1.0 + (r_rumble_bonus_mod_max * (r_position/dat)) );
	
		sleep_until( device_get_position(this) != r_position, 1 );
	
	until( device_get_position(this) >= dat, 1 );
	f_screenshake_rumble_intensity_mod_set( 1.0 );
	
	L_rumble_scale_thread = 0;

end

script static instanced void mag_stuck_main(cutscene_camera_point camera_1, device switch, player player_num)
static boolean b_started_music = FALSE;

	satt = datt;
	
	thread (check_player_inputs_per_frame(player_num));
	
	thread (end_pushing_sequence(switch, player_num));		
	thread (pushing_forward_fx());
	thread (sliding_backward_fx(player_num));
	
	sleep (1);
		
	repeat
		device_set_power (switch, 1);
		// show them where to go
		f_blip_object (switch, "activate");
	
		// wait until player hits switch again	
		sleep_until(device_get_position (switch) == 1, 1);

		// turn off switch
		device_set_power (switch, 0);
		
		// turn off blip after switch has been interacted with
		f_unblip_object (switch);
		
		// show training
		chud_show_screen_training (player_num, "m10_mag_tutorial");
		
		// attach the player here
		thread (attach_player_cam(camera_1, player_num));
		attach_player(player_num, switch);
		
		repeat 
			print ("started push loop");
			
			// play the idle anims until input occurs
			idle_anim_thread_id = thread (play_idle_beacon_anims_on_player(player_num));
		
			// wait until player is pressing forward
			sleep_until (player_pushing_stick or not(player_holding_action), 1);
			
			// kill the idle anim thread, get ready to push or leave
			kill_thread (idle_anim_thread_id);
			is_sliding = FALSE;

			// the player pushed forward, turn off training			
			chud_show_screen_training (player_num, "");	
			
			if (player_holding_action) then

				// play the push anims now
				push_anim_thread_id = thread (play_push_beacon_anims_on_player(player_num));
				is_pushing = TRUE;

				// start the push rumble
				if ( L_rumble_main_thread == 0 ) then
					L_rumble_main_thread = thread( mag_rumble_thread() );
				end
						
				// end time
				te = game_tick_get();
				
				// get delta after first time though to rewind
				if (ts != 0) then
					td = te - ts;												// all in frames
					datt = ((datt * 30) + (td)) / 30;		// convert to seconds
			
					// set this back to default if over
					if (datt > satt) then
						datt = satt;
					end
				end

				// begin time
				ts = game_tick_get();
			
				// play the beacon anims
				device_animate_position( this, dat, datt, 1, 0.1, 0 );

				// wait until the player is not pressing forward
				sleep_until ( not(player_pushing_stick) or not(player_holding_action), 1);
				
				// end time
				te = game_tick_get();
			
				// get delta
				td = te - ts;												// all in frames
				datt = ((datt * 30) - (td)) / 30;		// convert to seconds
				
				// check value
				print ("td:");
				inspect (td);
				// check value
				print ("datt:");
				inspect (datt);		
		
				dsp = device_get_position (this);
						
				// check the percentage
				print ("dsp:");
				inspect (dsp);
				
				// stop the aniamtion where ever it is, instantly.
				device_animate_position( this, dsp, 0, 0, 0, 1 );
				print ("beacon stopped");

				// begind rewinding the animation
				if (dsp != 1.0) then
					ts = game_tick_get();
					device_animate_position( this, 0, satt - datt, 1, 0.1, 0 );
				end
		
				// kill the thread that plays the push anim
				kill_thread (push_anim_thread_id);
				is_pushing = FALSE;
			end
		until (not(player_holding_action), 1);
		
		thread( mag_rumble_end() );
		
		// then kill the player anims, probably a push or idle anim
		unit_stop_custom_animation (player_num);
				
		//sleep (1);
		player_stopped_pushing(player_num, switch);
		
		// detach the player here
		detach_player_cam(player_num);
		
	until (dsp == dat, 1);
end

script static instanced void pushing_forward_fx()
	repeat
		if (is_pushing or is_ending) then
			print ("playing push fx");
			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", this, "left_sparks");
			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", this, "right_sparks");
		end
	until (dsp > 0.5, 10);
end

script static instanced void sliding_backward_fx(player player_num)
	repeat
		if (is_sliding) then
			print ("playing slide fx");
			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_chief_foot.effect", player_num, "left_sparks");
			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_chief_foot.effect", player_num, "right_sparks");
		end
	until (dsp > 0.5, 10);
end

script static instanced void end_pushing_sequence(device switch, player player_num)
		sleep_until (device_get_position (this) >= dat, 1);
		
		kill_thread(mag_thread_id);
		kill_thread (push_anim_thread_id);
		kill_thread (idle_anim_thread_id);
		
		is_pushing = FALSE;
		is_sliding = FALSE;
		
		// force the rumble to shutdown if it's still going
		thread( mag_rumble_end() );
		
		thread( f_screenshake_event_med(-0.25, -1, -0.25, sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_accelerator_in_position) );
			
		//dprint("::: magnetic accelerator is in position sound:::");

		player_action_test_reset();

		device_set_position_immediate (switch, 0);
		device_set_position (switch, 0);
		device_set_power (switch, 0);

		f_unblip_object (switch);
		
		device_animate_position( this, dat, 0.75, 1, 0, 0 );	
	
		player_finished_pushing(player_num, switch);
		
		// detach the player here
		detach_player_cam(player_num);
end

script static instanced void play_push_beacon_anims_on_player(player player_num)
	unit_stop_custom_animation (player_num);
		
	repeat		
			player_playing_push_anim = TRUE;
			custom_animation (player0, "objects\characters\storm_masterchief\storm_masterchief", "m10_push_lock_loop", true);
			sleep_until (unit_get_custom_animation_time (player_num),1);
			player_playing_push_anim = FALSE;	
	until (not(player_holding_action), 1);
end

script static instanced void play_idle_beacon_anims_on_player(player player_num)
	unit_stop_custom_animation (player_num);
		
	repeat
		if (device_get_position (this) < 0.05) then
			is_sliding = FALSE;
			player_playing_push_anim = TRUE;
			custom_animation (player0, "objects\characters\storm_masterchief\storm_masterchief", "m10_push_lock_idle", true);
			sleep_until (unit_get_custom_animation_time (player_num),1);
			player_playing_push_anim = FALSE;		
		else
			player_playing_push_anim = TRUE;
			custom_animation (player0, "objects\characters\storm_masterchief\storm_masterchief", "m10_push_lock_recede", true);
			is_sliding = TRUE;
			
			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", player_num, "left_foot");
			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", player_num, "right_foot");
			sleep_until (unit_get_custom_animation_time (player_num),1);
			player_playing_push_anim = FALSE;		
		end
	until (not(player_holding_action), 1);
end

script static instanced void check_player_inputs_per_frame(player player_num)
	repeat
		player_action_test_reset();
		//inspect (player_pushing_stick);
		player_pushing_stick = ( unit_action_test_move_relative_all_directions(player_num) or (not b_player_must_push_stick) );
		player_holding_action = ( player_action_test_context_primary() or (not b_player_must_hold_action) );
	until (dsp > 0.5, 1);
end

//script static instanced void moving_beacon(player player_num)	
//	repeat
//		sleep_until(attach_player_to_obj == TRUE, 1);
//
//		sleep_until (player_pushing_stick == TRUE, 1);
//
//		move_the_beacon = true;
//		
//		sound_impulse_start( 'sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_accelerator_start', NONE, 1);
//		sleep_until (player_pushing_stick == FALSE , 1);
//		
//		move_the_beacon = false;
//		
//		sound_impulse_start( 'sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_accelerator_stop', NONE, 1);
//	until (dsp == 0.5, 1);
//end

script static instanced void attach_player(player player_num, device switch)	
		player_playing_push_anim = TRUE;
		custom_animation (player0, "objects\characters\storm_masterchief\storm_masterchief", "m10_push_lock_start", true);
		sleep_until (unit_get_custom_animation_time (player_num),1);
		objects_attach (this, "loop_point", player0,"");
		player_playing_push_anim = FALSE;
end

script static instanced void player_stopped_pushing(player player_num, device switch)	
		player_playing_push_anim = TRUE;
		custom_animation (player0, "objects\characters\storm_masterchief\storm_masterchief", "m10_push_lock_stop_left", true);
		sleep_until (unit_get_custom_animation_time (player_num),1);
		player_playing_push_anim = FALSE;		
			
		//dprint ("detach");
		device_set_position_immediate (switch, 0);
end

script static instanced void player_finished_pushing(player player_num, device switch)	

		static real anim_time_to_drop = 0.6;
		//objects_detach (this, player_num);
		
		unit_stop_custom_animation (player_num);
	
		player_playing_push_anim = TRUE;
		custom_animation (player0, "objects\characters\storm_masterchief\storm_masterchief", "m10_push_lock_end", true);
		sleep (30);
		objects_detach (this, player_num);
		device_animate_position( this, dat_plus, anim_time_to_drop, 1, 0, 0 );
		sleep_s(anim_time_to_drop);
		device_animate_position( this, 1, 3, 1, 0, 0 );
		
		is_ending = TRUE;
				
		sleep_until (unit_get_custom_animation_time (player_num),1);
		player_playing_push_anim = FALSE;		

		//dprint ("final");
		device_set_position_immediate (switch, 0);
		
		is_ending = FALSE;
end

script static instanced void attach_player_cam(cutscene_camera_point camera_1, player player_num)

		//dprint("player attached");
		sleep (10);
		objects_attach (this, "starting_point", player0,"");
		sleep (1);
		objects_detach(this, player0);
		camera_control (TRUE);
	
		// hide crosshair		
		hud_show_crosshair (FALSE);
			
		is_attached = TRUE;	
					
		camera_set (camera_1, 20);
	
		sleep (11);
end

script static instanced void detach_player_cam(player player_num)
		objects_detach (this, player_num);
		camera_control (FALSE);
		is_attached = FALSE;	
		
		// show crosshair		
		hud_show_crosshair (TRUE);
end

//script static instanced void camera_mover(cutscene_camera_point camera_1, cutscene_camera_point camera_2, cutscene_camera_point camera_3)
//	static short trans_time = 360;
//		if (device_get_position(this) > 0.15) then
//			camera_pan (camera_2, camera_3, trans_time / 2, 10, 1, 10, 1);
//		else
//			camera_pan (camera_1, camera_3, trans_time, 10, 1, 10, 1);	
//		end
//end


script static instanced void ready()

	device_animate_position( this, 1, 2.5, 0.1, 0.1, TRUE );
	
end 

script static instanced void instant_ready()

	device_animate_position( this, 1, 0, 0.1, 0.1, TRUE );
	
end 

script static instanced void get_stuck()

	device_animate_position( this, 0.25, 1, 0.1, 0.1, TRUE );
	sleep_s(0.5);
	device_animate_position( this, 0.01, 1, 0.1, 0.1, TRUE );
	sleep_s(1);
	device_animate_position( this, 0.10, 1, 0.1, 0.1, TRUE );
	device_animate_position( this, 0.00, 1, 0.1, 0.1, TRUE );
	sleep_s(0.5);
	
end

script static instanced boolean check_clamp_down()
	device_get_position(this) == 1.0;
end

script static instanced boolean check_clamp_up()
	device_get_position(this) == 0.0;
end
