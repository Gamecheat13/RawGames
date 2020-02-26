//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: DIALOG ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// INTEGRATED -----------------------------------------------------------------------------------------------------------------------------------------------
script dormant f_e7m1_dialog_portal_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
local sound snd_sound_story = 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_dead_covenant_00101_soundstory';
local long l_timer = 0;

	// music
	spops_audio_music_event( 'Play_mus_pve_e07m1_dialog_portal_start', "Play_mus_pve_e07m1_dialog_portal_start" );
					
	l_dialog_id = dialog_start_foreground( "e7m1_dialog_portal_start", l_dialog_id, f_e7m1_objective() <= DEF_E7M1_OBJECTIVE_PORTAL, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
	
		// play the sound story
		l_timer = game_tick_get() + sound_max_time( snd_sound_story );
		sound_impulse_start( snd_sound_story, NONE, 1 );
	
		// subtitles
		// mark the objective after delay
		thread( f_e7m1_objective(DEF_E7M1_OBJECTIVE_PORTAL, 0.75) );
// Miller : The hell was that?
dprint ("Miller: Marking the next target for you now.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");

sleep_s(1);

// Lasky : Captain Lasky to all hands! Battle stations! This is not a drill!
dprint ("Lasky: Captain Lasky to all hands! Battle stations! This is not a drill!");
cui_hud_show_radio_transmission_hud("lasky_transmission_name");
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_dead_covenant_00102');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_dead_covenant_00102'));
sleep_s(.5);

// Miller : The hell was that?
dprint ("Miller: The hell was that?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_dead_covenant_00103');
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_dead_covenant_00103'));

		end_radio_transmission();
		
		// wait for the sound story to finish
		sleep_until( timer_expired(l_timer), 1 );
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 13, f_e7m1_objective() < DEF_E7M1_OBJECTIVE_ABORT, sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_takeout_portal_00100, FALSE, NONE, 0.0, "", "MILLER: Crimson, I'm going to try and figure out what's going on, be right back.", FALSE );
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

script dormant f_e7m1_dialog_abort_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// music
	spops_audio_music_event( 'Play_mus_pve_e07m1_dialog_abort_start', "Play_mus_pve_e07m1_dialog_abort_start" );
					
	l_dialog_id = dialog_start_foreground( "e7m1_dialog_abort_start", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_soundstory_00100', FALSE, NONE, 0.0, "", "PALMER: Commander Palmer to all Spartan Fireteams. Infinity has been boarded. Every fireteam that can hear this transmission, fall back to Infinity and help with defense. Palmer out.", FALSE);
		thread( f_e7m1_objective(DEF_E7M1_OBJECTIVE_EXIT, 0.5) );
		
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_takeout_portal_00101_soundstory', FALSE, NONE, 0.0, "", "MILLER: Crimson. I'm canceling your op and bringing you home.", FALSE );
 
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_exit_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// music
	spops_audio_music_event( 'Play_mus_pve_e07m1_dialog_exit_start', "Play_mus_pve_e07m1_dialog_exit_start" );

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_exit_start", l_dialog_id, f_e7m1_barriers_deactivated_cnt() == 0, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, f_e7m1_barriers_deactivated_cnt() == 0, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_which_way_00100', FALSE, NONE, 0.0, "", "MILLER: Marking the quickest way out of that mess for you, Crimson.", FALSE );
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		f_e7m1_objective( DEF_E7M1_OBJECTIVE_EXIT_BLIP );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_barrier_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// music
	spops_audio_music_event( 'Play_mus_pve_e07m1_dialog_barrier_start', "Play_mus_pve_e07m1_dialog_barrier_start" );
	
	l_dialog_id = dialog_start_foreground( "e7m1_dialog_barrier_start", l_dialog_id, f_e7m1_barriers_deactivated_cnt() == 0, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		// [NNN] Split the line up
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, f_e7m1_barriers_deactivated_cnt() == 0, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_destroy_generator_00100', FALSE, NONE, 0.0, "", "MILLER: Looks like we got lucky. You came up behind these shields. Pop the generators and those walls will come right down.", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		if ( f_e7m1_barriers_deactivated_cnt() == 0 ) then
			thread( f_e7m1_objective(DEF_E7M1_OBJECTIVE_BARRIER_BLIP, 0.25) );
		end

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_lz_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
local boolean b_generator_destroyed = f_e7m1_barriers_generators_destroyed_cnt();
	
	// music
	spops_audio_music_event( 'Play_mus_pve_e07m1_dialog_lz_start', "Play_mus_pve_e07m1_dialog_lz_start" );

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_lz_start", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, B_e7m1_objective_barrier_blipped and b_generator_destroyed, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_shield_down_00100', FALSE, NONE, 0.0, "", "MILLER: Great!", FALSE );
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		f_e7m1_objective( DEF_E7M1_OBJECTIVE_LZ_BLIP );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_keep_moving()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	// music
	spops_audio_music_event( 'Play_mus_pve_e07m1_dialog_keep_moving', "Play_mus_pve_e07m1_dialog_keep_moving" );

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_keep_moving", l_dialog_id, ai_living_count(sq_e7m1_phantom_ally_02) <= 0, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		if ( ai_living_count(sq_e7m1_phantom_ally_02) <= 0 ) then
	 		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		end
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, ai_living_count(sq_e7m1_phantom_ally_02) <= 0, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_keep_going_00100', FALSE, NONE, 0.0, "", "MILLER: Murphy, you able to reach Crimson's position?", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 1, ai_living_count(sq_e7m1_phantom_ally_02) <= 0, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_keep_going_00101', FALSE, NONE, 0.0, "", "MURPHY: I need 'em a little further down the hill, Spartan.", FALSE);
		if ( ai_living_count(sq_e7m1_phantom_ally_02) <= 0 ) then
	 		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		end
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 2, ai_living_count(sq_e7m1_phantom_ally_02) <= 0, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_keep_going_00102', FALSE, NONE, 0.0, "", "MILLER: Hear that Crimson? Move!", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_phantom()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
local long l_blip_thread = 0;
local long l_timer = 0;

	// music
	l_dialog_id = dialog_start_foreground( "e7m1_dialog_phantom", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
	
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00100', FALSE, NONE, 0.0, "", "MURPHY: Hey! I found something!", FALSE);
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00101', FALSE, NONE, 0.0, "", "MILLER: Murphy?", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
			// blip the drop location
			l_blip_thread = spops_blip_auto_flag_distance( flg_e7m1_objective_mantis_drop, "default", R_e7m1_objective_mech_drop_distance, FALSE );

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00102', FALSE, NONE, 0.0, "", "MURPHY: Crimson, here's the coordinates where I'm gonna drop your present.", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 3, objects_distance_to_flag(Players(),flg_e7m1_objective_mantis_drop) > R_e7m1_objective_mech_drop_distance, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00103', FALSE, NONE, 0.0, "", "MURPHY: Get on over there.", FALSE);

			sleep_until( B_e7m1_phantom_ally_drop_in_position, 1 );
			// drop warning
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 4, objects_distance_to_flag(Players(), flg_e7m1_objective_mantis_drop) <= R_e7m1_objective_mech_drop_warn_distance, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06', FALSE, NONE, 0.0, "", "MILLER: Heads up!", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
			// give warning time
			l_timer = timer_stamp( 5.0 );
			sleep_until( timer_expired(l_timer) or (objects_distance_to_flag(Players(), flg_e7m1_objective_mantis_drop) > R_e7m1_objective_mech_drop_warn_distance) or object_recent_damage(vh_e7m1_phantom_ally) > 0.01, 1 );

			// final warning
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 4, objects_distance_to_flag(Players(), flg_e7m1_objective_mantis_drop) <= R_e7m1_objective_mech_drop_warn_distance, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_08', FALSE, NONE, 0.0, "", "MURPHY: Dropping!", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
			l_timer = timer_stamp( 1.0 );
			sleep_until( timer_expired(l_timer) or (objects_distance_to_flag(Players(), flg_e7m1_objective_mantis_drop) > R_e7m1_objective_mech_drop_warn_distance), 1 );
			B_e7m1_phantom_ally_drop_in_ready = TRUE;
			
			// wait for drop
			sleep_until( object_at_marker(vh_e7m1_phantom_ally, "phantom_lc") == NONE, 1 );
			// shut off blip
			kill_thread( l_blip_thread );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 5, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00104', FALSE, NONE, 0.0, "", "MURPHY: There ya go! Have fun, Crimson!", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_phantom_02()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_phantom_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sleep_s( 1.0 );
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00105', FALSE, NONE, 0.0, "", "MILLER: Murphy! Watch out!", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
			// start phantom combat
			B_e7m1_phantom_fight_start = TRUE;
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00106_soundstory', FALSE, NONE, 0.0, "", "MURPHY: Already seen it, Spartan Miller. I can handle a single Phantom.  Aw hell, they got me outmanned and outgunned.", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	// chain clear LZ dialog
	wake( f_e7m1_dialog_clear_lz );

end

script dormant f_e7m1_dialog_murphy_lose()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_murphy_lose", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_loses_00100', FALSE, NONE, 0.0, "", "MURPHY: This is no good, Infinity! Phantom can’t take any more!", FALSE);
		
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_loses_00101', FALSE, NONE, 0.0, "", "Miller: Murphy! Get out of there!", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_loses_00102', FALSE, NONE, 0.0, "", "MURPHY: Sorry, Crimson. You’re on your own!", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_clear_lz()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_clear_lz", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sleep_s( 1.0 );

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_clearlz_00100', FALSE, NONE, 0.0, "", "MURPHY: Crimson, clear me a landing spot and I'll clear the skies!", FALSE);
		f_e7m1_objective( DEF_E7M1_OBJECTIVE_LZ_CLEAR );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_jet_pack()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_jet_pack", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
	sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_jet_pack_00100', FALSE, NONE, 0.0, "", "MILLER: Whoa, Crimson! Those turrets will pick you out of the sky if you go jet packing. Safer and faster just to stay on the ground.", FALSE);
	sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

script dormant f_e7m1_dialog_lz_cleared()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	l_dialog_id = dialog_start_foreground( "e7m1_dialog_lz_cleared", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
	sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_clear_00100', FALSE, NONE, 0.0, "", "MILLER: Nice work, Crimson!", FALSE);
	sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_phantom_help()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_phantom_help", l_dialog_id, f_e7m1_ai_phantom_enemy_turrets_active(), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 0, f_e7m1_ai_phantom_enemy_turrets_active(), 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphyhelp_00100', FALSE, NONE, 0.0, "", "MURPHY: Crimson, little help up here?", FALSE );
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, f_e7m1_ai_phantom_enemy_turrets_active() , 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphyhelp_00101', FALSE, NONE, 0.0, "", "MILLER: Crimson, do what you can to get that Phantom off Murphy’s tail.", FALSE );
		f_e7m1_objective( DEF_E7M1_OBJECTIVE_PHANTOM_HELP );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 2, f_e7m1_ai_phantom_enemy_turrets_active() and ((object_get_health(bpd_e7m1_mantis_01) > 0.0) or (object_get_health(bpd_e7m1_mantis_02) > 0.0)), 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphyhelp_00102', FALSE, NONE, 0.0, "", "MILLER: Spartans, use the Mantis’s firepower to help Murphy!", FALSE );
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_phantom_enemy_complete()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_phantom_enemy_complete", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 0, (object_get_health(vh_e7m1_phantom_enemy) <= 0.0), 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_wins_00100', FALSE, NONE, 0.0, "", "MURPHY: Boom!", FALSE);
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_wins_00101', FALSE, NONE, 0.0, "", "MILLER: Murphy! That was amazing!", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_wins_00102', FALSE, NONE, 0.0, "", "MURPHY: And only ever so slightly worse for the wear.", FALSE);
			
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 3, not B_e7m1_objective_lz_cleared, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_wins_00103', FALSE, NONE, 0.0, "", "MURPHY: How's that LZ coming, Crimson?", FALSE);
			
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_phantom_ally_abort()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_phantom_ally_abort", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_loses_00100', FALSE, NONE, 0.0, "", "MURPHY: This is no good, Infinity! Phantom can't take any more!", FALSE );
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_loses_00101', FALSE, NONE, 0.0, "", "MILLER: Murphy! Get out of there!", FALSE );
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_murphy_loses_00102', FALSE, NONE, 0.0, "", "MURPHY: Sorry, Crimson. You're on your own.", FALSE );
			sleep_s( 1.0 );

			// fail
			player_camera_control( FALSE );
			player_enable_input( FALSE );
			fade_out( 0, 0, 0, 30 );
			//dprint( "mission failed" );
			cui_load_screen( 'ui\in_game\pve_outro\mission_failed.cui_screen' );
			sleep_s( 1.0 );
			b_game_lost = TRUE;
			f_spops_mission_end_complete( FALSE );
			
			// keep it locked in this dialog so no others play
			sleep_until( FALSE, 1 );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_lz_pickup_01()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	sleep_s( 1.0 );
	l_dialog_id = dialog_start_foreground( "e7m1_dialog_lz_pickup_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_clear_00100b', FALSE, NONE, 0.0, "", "Murphy, you're clear for pickup.", FALSE);
			f_e7m1_objective( DEF_E7M1_OBJECTIVE_PICKUP );
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_clear_00101', FALSE, NONE, 0.0, "", "MURPHY: On my way.", FALSE);
			
			sleep_until( B_e7m1_phantom_pickup_ready, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_clear_00102', FALSE, NONE, 0.0, "", "MURPHY: All aboard.", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_all_serence()
	//dprint( "f_e7m1_dialog_all_serence" );

	// music
	spops_audio_music_event( 'Play_mus_pve_e07m1_dialog_all_serence', "Play_mus_pve_e07m1_dialog_all_serence" );
	
	// MILLER: Bad news getting worse. Covenant ships are inbound on Infinity. How fast do you think you can get here?
	sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, 0, 10, "MILLER: Bad news getting worse. Covenant ships are inbound on Infinity. How fast do you think you can get here?", 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_all_serence_00100' );
	sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	// MURPHY: Flying this crate as fast as I can, Spartan! Only way we'll get there faster is for Crimson to get out and push!
	spops_narrative_line( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, 0, 0, "MURPHY: Flying this crate as fast as I can, Spartan! Only way we'll get there faster is for Crimson to get out and push!", 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_all_serence_00101' );
	
	// increment variable to track when end is complete
	S_e7m1_outro_events = S_e7m1_outro_events + 1;

end

script static void f_e7m1_dialog_ordnance( short s_level )
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	local boolean b_played = FALSE;
	static boolean b_played_01 = FALSE;
	static boolean b_played_02 = FALSE;
	static boolean b_played_03 = FALSE;
	//dprint( "f_e7m1_dialog_ordnance" );

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_ordnance", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		
		if ( (s_level == 1) and (not b_played_01) ) then
			b_played_01 = TRUE;
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_00100', FALSE, NONE, 0.0, "", "Miller: Dalton, you online?", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_00101', FALSE, NONE, 0.0, "", "Miller : Roland, comms with Dalton are down. What ordnance have we got packed for launch planetside?", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_00102', FALSE, NONE, 0.0, "", "Roland : Not a whole lot, but there are a few things in the chute.", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 3, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_00103', FALSE, NONE, 0.0, "", "Roland : I’ll send 'em Crimson’s way now.", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		end
		if ( (s_level == 2) and (not b_played_02) ) then
			b_played_02 = TRUE;
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_more_lz_00100', FALSE, NONE, 0.0, "", "Miller : Roland, anything else you can send Crimson’s way?", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_more_lz_00102', FALSE, NONE, 0.0, "", "Roland : Pickings are slim, but we’ve got a few leftovers I can send down.", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_more_lz_00103', FALSE, NONE, 0.0, "", "Roland : Sending it.", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		end
		if ( (s_level == 3) and (not b_played_03) ) then
			b_played_03 = TRUE;
			sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_last_lz_00100', FALSE, NONE, 0.0, "", "Miller : Roland, is there anything else in the supplies?", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_last_lz_00101', FALSE, NONE, 0.0, "", "Roland : Sending the last of it.", FALSE);
			sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
		end
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_under_attack_01()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_under_attack_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep1_00100', FALSE, NONE, 0.0, "", "Miller : Roland, sitrep on our invaders?", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep1_00101', FALSE, NONE, 0.0, "", "Roland : Prometheans appearing all over the ship.", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep1_00102', FALSE, NONE, 0.0, "", "Roland : No means to stop them at the moment.", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_under_attack_02()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_under_attack_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep2_00100', FALSE, NONE, 0.0, "", "Roland : Spartan Miller, you’ve got Prometheans near Ops Command.", FALSE);
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep2_00101', FALSE, NONE, 0.0, "", "Miller : Acknowledged, Roland. I’ve got my sidearm in hand.", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_under_attack_03()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_under_attack_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep3_00100', FALSE, NONE, 0.0, "", "Miller : Roland, any update?", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep3_00101', FALSE, NONE, 0.0, "", "Roland : Rather grim.", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep3_00102', FALSE, NONE, 0.0, "", "Roland : Multiple casualties across all decks.", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 3, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_sitrep3_00103', FALSE, NONE, 0.0, "", "Roland : Just get Crimson back here as fast as you can.", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_camo_changer_detected()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	l_dialog_id = dialog_start_foreground( "e7m1_camo_changer_detected", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_camo_emitter_00100', FALSE, NONE, 0.0, "", "Roland : Spartan Miller, I’ve detected an unknown Forerunner device.", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_camo_emitter_00101', FALSE, NONE, 0.0, "", "Miller : Crimson, keep an eye on it.", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_camo_emitter_changed_enemy()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	l_dialog_id = dialog_start_foreground( "e7m1_camo_emitter_changed_enemy", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		sound_looping_start ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla', NONE, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_enemies_camo_00104', FALSE, NONE, 0.0, "", "Miller : Roland, did the Covenant just disappear?", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_enemies_camo_00105', FALSE, NONE, 0.0, "", "Roland : Yep. Some kind of active camo emitter.", FALSE);
		sound_looping_stop ( 'sound\dialog\storm_multiplayer\pve\global_dialog_15\loops\sfx_command_center_walla' );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end





/*
// NOTE: ALREADY IN: f_e7m1_dialog_phantom - ThFrench
script dormant f_e7m1_dialog_phantom_01()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_phantom_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00104', FALSE, NONE, 0.0, "", "MURPHY: There ya go! Have fun, Crimson!", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// NOTE: CURRENTLY NOT DOING BOMBING RUN
script dormant f_e7m1_dialog_bombin_run()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_bombin_run", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_bombin_run_00100', FALSE, NONE, 0.0, "", "MILLER: Dalton, are you online? Could use some air support for Crimson.", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_bombin_run_00101', FALSE, NONE, 0.0, "", "MILLER: Dalton?", FALSE);

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_bombin_run_00102', FALSE, NONE, 0.0, "", "MURPHY: Spartan Miller, I got an open channel to some broadsword pilots on patrol.", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 3, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_bombin_run_00103', FALSE, NONE, 0.0, "", "MURPHY: Want me to send them your way?", FALSE);

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 4, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_bombin_run_00104', FALSE, NONE, 0.0, "", "MILLER: Excellent. Sending you coordinates now, Murphy.", FALSE);
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 5, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_bombin_run_00105', FALSE, NONE, 0.0, "", "MILLER: Have them blanket the area.", FALSE);

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 6, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_bombin_run_00106', FALSE, NONE, 0.0, "", "MURPHY: You got it.", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_phantom_03()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_phantom_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00108', FALSE, NONE, 0.0, "", "MILLER: Murphy!", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00109_soundstory', FALSE, NONE, 0.0, "", "MURPHY: Don't worry about me. I'll set this thing to autopilot and man the gun myself!", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// ALREADY IN f_e7m1_dialog_lz_pickup_01 -ThFrench
script dormant f_e7m1_dialog_lz_pickup_02()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_lz_pickup_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_lz_clear_00102', FALSE, NONE, 0.0, "", "MURPHY: All aboard.", FALSE);

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e7m1_dialog_murphy_overwhelmed()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e7m1_dialog_murphy_overwhelmed", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       


			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00107', FALSE, NONE, 0.0, "", "MURPHY: Aw hell, they think they got me outmanned and outgunned?", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00108', FALSE, NONE, 0.0, "", "Miller: Murphy!", FALSE);
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_07_mission_01\e07m1_phantom_00109_soundstory', FALSE, NONE, 0.0, "", "MURPHY: I'll set this thing to autopilot and man the gun myself!", FALSE);


	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

*/

