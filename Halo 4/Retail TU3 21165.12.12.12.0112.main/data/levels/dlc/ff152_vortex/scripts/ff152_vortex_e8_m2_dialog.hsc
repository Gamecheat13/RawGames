//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global long L_e8_m2_dialog_start = 																DEF_DIALOG_ID_NONE();
global long L_e8_m2_dialog_artillery_dangerous = 									DEF_DIALOG_ID_NONE();
global long L_e8_m2_dialog_artillery_cores_destroyed = 						DEF_DIALOG_ID_NONE();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script dormant f_e8_m2_dialog_intro()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_intro" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_dialog_intro', "Play_mus_pve_e08m2_dialog_intro" );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_intro", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );
	b_e8m2_narrative_is_on = TRUE;
	
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00100', FALSE, NONE, 0.0, "", "Palmer : Majestic, hang tight. We’re about to deal with your artillery trouble.", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00101', FALSE, NONE, 0.0, "", "Demarco : Understood, Commander.", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00102', FALSE, NONE, 0.0, "", "Miller: Commander, the Covies were ready for us. Like they knew we were coming.", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00104', FALSE, NONE, 0.0, "", "Palmer: Don’t be paranoid, Miller.", FALSE );
		

	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_e8_m2_dialog_start()
	dprint( "f_e8_m2_dialog_start" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_dialog_start', "Play_mus_pve_e08m2_dialog_start" );

	L_e8_m2_dialog_start = dialog_start_foreground( "e8_m2_dialog_start", L_e8_m2_dialog_start, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
	b_e8m2_narrative_is_on = TRUE;
		
		// blip speaking pelican
		spops_blip_object( vh_e8_m2_pelican_lz_01, TRUE, "ally_vehicle" );
		
		// auto blip other pelican
		spops_blip_auto_object_recent_damage( vh_e8_m2_pelican_lz_02, "defend_health" );
		
		sleep_s( 0.5 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, L_e8_m2_dialog_start, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_murphy_dropping_02', FALSE, NONE, 0.0, "", "Murphy: Droppin Crimson in the fire.", FALSE );
		
		sleep_until( b_e8m2_pelican_intro_deployed, 1 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, L_e8_m2_dialog_start, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_spartans_warthogs_00100', FALSE, NONE, 0.0, "", "Dalton : Dalton to Commander Palmer. Fireteam Kodiak is on station. Warthogs deployed.", FALSE );
		//spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, L_e8_m2_dialog_start, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_spartans_warthogs_00101', FALSE, NONE, 0.0, "", "Palmer : Acknowledged, Dalton. Tell your people to be careful--", FALSE );

		// wait for pelican to die
		sleep_until( b_e8m2_pelican_intro_destroyed, 1 );
		spops_blip_object( vh_e8_m2_pelican_lz_01, FALSE );
		sleep_s( 1.0 );

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, L_e8_m2_dialog_start, 3, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_shot_down_00100', FALSE, NONE, 0.0, "", "Murphy : Covies hit Kodiak’s Pelican! They’re down!", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, L_e8_m2_dialog_start, 4, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_shot_down_00101', FALSE, NONE, 0.0, "", "Dalton : Fall back, Murphy. Crimson will call when they need a ride home.", FALSE );
		
	b_e8m2_narrative_is_on = FALSE;
	L_e8_m2_dialog_start = dialog_end( L_e8_m2_dialog_start, TRUE, TRUE, "" );

end

script dormant f_e8_m2_dialog_spartans_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_spartans_start", l_dialog_id, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
	b_e8m2_narrative_is_on = TRUE;
		sleep_s( 0.5 );

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_switchback_greeting_00100', FALSE, NONE, 0.0, "", "Kodiak Leader: Crimson! How’s it going? Ready to knock some Covie heads together?", FALSE );
		
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

script dormant f_e8_m2_dialog_artillery_pointed_out()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_artillery_pointed_out" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_pointed_out', "Play_mus_pve_e08m2_artillery_pointed_out" );

	sleep_s( 1.0 );
	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_pointed_out", l_dialog_id, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_NEAR, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
	b_e8m2_narrative_is_on = TRUE;

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_KNOWN, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_00100', FALSE, NONE, 0.0, "", "Miller: Commander, I’ve identified the artillery emplacements hitting Majestic’s position. They're spread along the ridge line.", FALSE );
		f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_KNOWN );

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_04', FALSE, NONE, 0.0, "", "Miller: Neutralize all targets.", FALSE );
		f_e8_m2_objective( R_e8_m2_objective_destroy_artillery );

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_NEAR, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_00101', FALSE, NONE, 0.0, "", "Palmer: Lined up in a neat little row for you, Crimson. They make it too easy.", FALSE );

	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_e8_m2_dialog_artillery_near_final()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
local object obj_artillery = NONE;
dprint( "f_e8_m2_dialog_artillery_near_final" );
	
	// get the final artillery target
	if ( object_get_health(obj_e8m2_artillery_01) > 0.0 ) then
		obj_artillery = obj_e8m2_artillery_01;
	end
	if ( object_get_health(obj_e8m2_artillery_02) > 0.0 ) then
		obj_artillery = obj_e8m2_artillery_02;
	end
	if ( object_get_health(obj_e8m2_artillery_03) > 0.0 ) then
		obj_artillery = obj_e8m2_artillery_03;
	end

	sleep_until( objects_distance_to_object(Players(),obj_artillery) <= R_e8m2_artillery_blip_range, 1 );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_near_final', "Play_mus_pve_e08m2_artillery_near_final" );
	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_near_final", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
	b_e8m2_narrative_is_on = TRUE;
	
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, (f_e8_m2_artillery_living_cnt() == 1), 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00100', FALSE, NONE, 0.0, "", "Palmer: Alright, Crimson. Step it up. Take out that final piece of artillery.", FALSE );
	
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

// XXX integrate
script static void f_e8_m2_dialog_artillery_nudge()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
static short s_nudge_cnt = 0;
	dprint( "f_e8_m2_dialog_artillery_nudge" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_nudge', "Play_mus_pve_e08m2_artillery_nudge" );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_nudge", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
	b_e8m2_narrative_is_on = TRUE;

		if ( s_nudge_cnt == 0 ) then

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00101', FALSE, NONE, 0.0, "", "Demarco: Commander! Not to be rude, but how much longer are we gonna have shells raining down on our heads?", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00102', FALSE, NONE, 0.0, "", "Palmer: Crimson’s working on it, Demarco.", FALSE );

		else

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00102', FALSE, NONE, 0.0, "", "Demarco: Commander…", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00103', FALSE, NONE, 0.0, "", "Palmer: Demarco. Settle. Crimson’s working on it.", FALSE );

		end
		s_nudge_cnt = s_nudge_cnt + 1;
		
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

// XXX integrate
script static void f_e8_m2_dialog_core_nudge()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
static short s_nudge_cnt = 0;
	dprint( "f_e8_m2_dialog_core_nudge" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_core_nudge', "Play_mus_pve_e08m2_core_nudge" );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_core_nudge", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
	b_e8m2_narrative_is_on = TRUE;

		if ( s_nudge_cnt == 0 ) then
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00100', FALSE, NONE, 0.0, "", "Palmer: Keep hitting that conduit, Crimson!", FALSE );
		elseif ( s_nudge_cnt == 1 ) then
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00101', FALSE, NONE, 0.0, "", "Palmer: Don't leave this job half done, Crimson.", FALSE );
		else
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00102', FALSE, NONE, 0.0, "", "Palmer: Bring the conduit down, Crimson. Now!", FALSE );
		end		
		
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script static void f_e8_m2_dialog_artillery_tough()
static boolean b_triggered = FALSE;
	dprint( "f_e8_m2_dialog_artillery_tough" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_tough', "Play_mus_pve_e08m2_artillery_tough" );

	if ( (S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH) and (not b_triggered) ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_triggered = TRUE;

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_tough", l_dialog_id, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
			b_e8m2_narrative_is_on = TRUE;
			
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00100', FALSE, NONE, 0.0, "", "Miller: Commander, that shield isn't going to come down with what Crimson is carrying. But there’s an energy conduit nearby that heats up whenever the artillery fires.", FALSE );
			


			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00101', FALSE, NONE, 0.0, "", "Palmer: Power source, eh? Try hitting the conduit, Crimson.", FALSE );
			
			if ( S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH ) then
				f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK );
			end
		
		b_e8m2_narrative_is_on = FALSE;
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end

end

script static void f_e8_m2_dialog_artillery_core_attacked( short s_index )
static boolean b_triggered = FALSE;
	dprint( "f_e8_m2_dialog_artillery_core_attacked" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_core_attacked', "Play_mus_pve_e08m2_core_attacked" );

	if ( (not b_triggered) and (S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_index_state(s_index) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_triggered = TRUE;
						
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_core_attacked", l_dialog_id, (S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_index_state(s_index) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
		b_e8m2_narrative_is_on = TRUE;
		
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, (S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_index_state(s_index) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED), 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00100', FALSE, NONE, 0.0, "", "Palmer: I'm no scientist, but I'd say that did something.", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, (S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_index_state(s_index) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS), 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00101', FALSE, NONE, 0.0, "", "Miller: Ah! I get it! Without the conduits, the gun overloads!", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 2, (S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_index_state(s_index) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS), 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00102', FALSE, NONE, 0.0, "", "Palmer: Keep hitting the conduit, Crimson!", FALSE );

		b_e8m2_narrative_is_on = FALSE;
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end

end

script static void f_e8_m2_dialog_artillery_core_destroyed( object obj_artillery )
static boolean b_playing = FALSE;
static long l_timer = 0;
	dprint( "f_e8_m2_dialog_artillery_core_destroyed" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_core_destroyed', "Play_mus_pve_e08m2_artillery_core_destroyed" );

	if ( (not b_playing) and timer_expired(l_timer) ) then
		static long l_dialog_id = DEF_DIALOG_ID_NONE();
		static short s_played_cnt = 0;
		b_playing = TRUE;

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_core_destroyed", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		if ( dialog_foreground_id_active_check(l_dialog_id) ) then
			b_e8m2_narrative_is_on = TRUE;
		end

			if ( (s_played_cnt == 0) and dialog_foreground_id_active_check(l_dialog_id) ) then
			
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00100', FALSE, NONE, 0.0, "", "Miller: Conduit destroyed!", FALSE );

				// NNN Shouldn't say firing because it might not be firing at that time, maybe "but that artillery appears to still be active"
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, object_get_health(obj_artillery) > 0.0, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00101', FALSE, NONE, 0.0, "", "Palmer: But that artillery is still firing.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 2, object_get_health(obj_artillery) > 0.0, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00102', FALSE, NONE, 0.0, "", "Miller: Looks like the artillery is destabilizing.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 3, object_get_health(obj_artillery) > 0.0, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00103', FALSE, NONE, 0.0, "", "Palmer: So if Crimson hits the other conduit…", FALSE );

				// NNN Not painting a new waypoint, all the cores for one are active at once
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 3, object_get_health(obj_artillery) > 0.0, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00104', FALSE, NONE, 0.0, "", "Miller: That’s what I’m thinking too. Painting a waypoint now.", FALSE );
			
			// NNN need random celebrations
			//else
				//begin_random_count(1)			
				//	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_, l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Keep it up <RANDOM A>.", FALSE );
				//	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_, l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Keep it up <RANDOM B>.", FALSE );
				//	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_, l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Keep it up <RANDOM C>.", FALSE );
				//end
			end

			if ( dialog_id_active_check(l_dialog_id) ) then
				l_timer = timer_stamp( 30.0 );
			end

			// increment played count
			if ( dialog_foreground_id_active_check(l_dialog_id) ) then
				s_played_cnt = s_played_cnt + 1;
			end

		if ( dialog_foreground_id_active_check(l_dialog_id) ) then
			b_e8m2_narrative_is_on = FALSE;
		end
		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

		b_playing = FALSE;
	end

end


script static void f_e8_m2_dialog_artillery_cores_destroyed( short s_index )
static boolean b_playing = FALSE;
	dprint( "f_e8_m2_dialog_artillery_cores_destroyed" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_cores_destroyed', "Play_mus_pve_e08m2_artillery_cores_destroyed" );

	if ( not b_playing ) then
		b_playing = TRUE;

		L_e8_m2_dialog_artillery_cores_destroyed = dialog_start_foreground( "e8_m2_dialog_artillery_cores_destroyed", L_e8_m2_dialog_artillery_cores_destroyed, f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
		b_e8m2_narrative_is_on = TRUE;
			if ( f_e8_m2_artillery_killed_cnt() == 0 ) then
// NNN, split line and move "uhh..." on into f_e8_m2_dialog_artillery_destabilized 

				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, L_e8_m2_dialog_artillery_cores_destroyed, 0, f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_core_destroyed_00100', FALSE, NONE, 0.0, "", "Miller: That's the last conduit. Uh... you may want to back away, Crimson. When that artillery fires again, it’s gonna be a mess.", FALSE );

			// XXX need random celebrations
//			else
//				begin_random_count(1)			
//					spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_, L_e8_m2_dialog_artillery_cores_destroyed, 0, f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: That's all the cores <RANDOM A>!", FALSE );
//					spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_, L_e8_m2_dialog_artillery_cores_destroyed, 0, f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: That's all the cores <RANDOM B>!", FALSE );
//				end
			end
		b_e8m2_narrative_is_on = FALSE;
		L_e8_m2_dialog_artillery_cores_destroyed = dialog_end( L_e8_m2_dialog_artillery_cores_destroyed, FALSE, FALSE, "" );

		b_playing = FALSE;
	end
end

script static void f_e8_m2_dialog_artillery_destabilized( short s_index )
static short s_triggered = 0;
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_artillery_destabilized" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_destabilized', "Play_mus_pve_e08m2_artillery_destabilized" );

	if ( (s_triggered == 1) and (f_e8_m2_artillery_index_state(1) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) and (f_e8_m2_artillery_index_state(2) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) and (f_e8_m2_artillery_index_state(3) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) ) then
		s_triggered = 2;
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_destabilized", l_dialog_id, f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_great_job_00100', FALSE, NONE, 0.0, "", "Palmer: You make this look so easy, Crimson.", FALSE );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end


	if ( (s_triggered == 0) and (f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) ) then
		dprint( "f_e8_m2_dialog_artillery_destabilized: A" );
		s_triggered = 1;

		// NNN Need to split previous line and move second half down here		
		/*
		
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_destabilized", l_dialog_id, f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_, l_dialog_id, 0, f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED, NONE, FALSE, NONE, 0.0, "", "INFINITY: The destroying the cores seems to have destabilizing the ARTILLERY when they fires.", FALSE );
		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
		*/			

	end

end

script static void f_e8_m2_dialog_artillery_dangerous( short s_index, object obj_artillery )
static boolean b_playing = FALSE;
static short s_play_cnt = 0;
	dprint( "f_e8_m2_dialog_artillery_dangerous" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_dangerous', "Play_mus_pve_e08m2_artillery_dangerous" );

	if ( (not b_playing) and (object_get_health(obj_artillery) > 0.0) ) then
		b_playing = TRUE;
	
		// wait to trigger
		sleep_until( (objects_distance_to_object(Players(), obj_artillery) <= R_e8m2_artillery_explosion_warning_range) or (object_get_health(obj_artillery) <= 0.0), 1 );
						
		L_e8_m2_dialog_artillery_dangerous = dialog_start_foreground( "e8_m2_dialog_artillery_dangerous", L_e8_m2_dialog_artillery_dangerous, object_get_health(obj_artillery) > 0.0, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
		b_e8m2_narrative_is_on = TRUE;
		
			if ( (objects_distance_to_object(Players(), obj_artillery) <= R_e8m2_artillery_explosion_warning_range) and (object_get_health(obj_artillery) > 0.0) ) then

				if ( s_play_cnt == 0 ) then
					spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, L_e8_m2_dialog_artillery_dangerous, 0, object_get_health(obj_artillery) > 0.0, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_move_away_00100', FALSE, NONE, 0.0, "", "Palmer: Crimson! Fall back before that gun tries to fire again!", FALSE );
				end
				
				if ( object_get_health(obj_artillery) > 0.0 ) then
					local long l_timer = timer_stamp( 2.5 );
					sleep_until( timer_expired(l_timer) or (objects_distance_to_object(Players(), obj_artillery) > R_e8m2_artillery_explosion_warning_range), 1 );
				end
	
				s_play_cnt = s_play_cnt + 1;

			end

		b_e8m2_narrative_is_on = FALSE;
		L_e8_m2_dialog_artillery_dangerous = dialog_end( L_e8_m2_dialog_artillery_dangerous, FALSE, FALSE, "" );

		b_playing = FALSE;
	end

end

script static void f_e8_m2_dialog_artillery_destroyed()
static boolean b_playing = FALSE;
	dprint( "f_e8_m2_dialog_artillery_destroyed" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_destroyed', "Play_mus_pve_e08m2_artillery_destroyed" );

	if ( not b_playing ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_playing = TRUE;

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_destroyed", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		b_e8m2_narrative_is_on = TRUE;

			if ( f_e8_m2_artillery_living_cnt() == 0 ) then
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00101', FALSE, NONE, 0.0, "", "Palmer: Majestic, all clear. You owe Crimson a round once you’re all home.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00102', FALSE, NONE, 0.0, "", "Demarco: Happy to pay the debt, Commander. Tell them we said thanks.", FALSE );

			elseif ( f_e8_m2_artillery_killed_cnt() == 1 ) then				
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_explodes_00100', FALSE, NONE, 0.0, "", "Miller: Success!", FALSE );
				
				// NNN split lines
				// XXX first line check killed == 1
				// XXX second line check living > 0
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, f_e8_m2_artillery_killed_cnt() == 1, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_explodes_00101', FALSE, NONE, 0.0, "", "Palmer: Alright, one down. Hit the rest of the emplacements, Crimson.", FALSE );

			else
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00100', FALSE, NONE, 0.0, "", "Palmer: That's two.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, 1, f_e8_m2_artillery_living_cnt() > 0, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00101', FALSE, NONE, 0.0, "", "Demarco: How many more to go, Commander?", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 2, f_e8_m2_artillery_living_cnt() == 1, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00102', FALSE, NONE, 0.0, "", "Palmer: Just one, Demarco. Relax.", FALSE );

			end

		b_e8m2_narrative_is_on = FALSE;
		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

		b_playing = FALSE;
	end

end
				
script static void f_e8_m2_dialog_ai_switch()
static boolean b_playing = FALSE;
static boolean b_switch_first = FALSE;
static boolean b_switch_last = FALSE;
static boolean b_switch_lz = FALSE;

	if ( not b_playing ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_playing = TRUE;

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_ai_switch", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		b_e8m2_narrative_is_on = TRUE;
//			s_artillery_killed = f_e8_m2_artillery_killed_cnt();

			if ( (f_e8_m2_artillery_living_cnt() == 2) and (not b_switch_first) ) then
				b_switch_first = TRUE;

				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, f_e8_m2_artillery_living_cnt() > 0, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_next_artillery_00100', FALSE, NONE, 0.0, "", "Miller: Covenant are falling back to the next artillery.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, f_e8_m2_artillery_living_cnt() > 1, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_next_artillery_00101', FALSE, NONE, 0.0, "", "Palmer: Stay on their heels, Crimson.", FALSE );
	
			end

			if ( (f_e8_m2_artillery_living_cnt() == 1) and (not b_switch_last) ) then
				b_switch_last = TRUE;

				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, f_e8_m2_artillery_living_cnt() == 1, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_swarm_last_artillery_00100', FALSE, NONE, 0.0, "", "Miller: Covenant massing at the final artillery.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, f_e8_m2_artillery_living_cnt() == 1, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_swarm_last_artillery_00101', FALSE, NONE, 0.0, "", "Palmer: If they want to go down with the ship, sink 'em.", FALSE );
	
			end

/*
			if ( (s_artillery_living == 0) and (not b_switch_lz) ) then
				b_switch_lz = TRUE;
				
				// NNN I had the wrong context in here before. we need a line about the LZ being attacked (where the Pelican still is)
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_last_artillery_00100', FALSE, NONE, 0.0, "", "Miller: They're falling back to the next artillery emplacement!", FALSE );
	
			end
*/

		b_e8m2_narrative_is_on = FALSE;
		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

		b_playing = FALSE;
	end

end

script dormant f_e8_m2_dialog_rendezvous_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_rendezvous_start" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_rendezvous_start', "Play_mus_pve_e08m2_rendezvous_start" );

	sleep_s( 1.0 );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_rendezvous_start", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
	b_e8m2_narrative_is_on = TRUE;

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, not volume_test_players_all(tv_e8_m2_lz_area), 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_fall_back_00100', FALSE, NONE, 0.0, "", "Palmer: Fallback! Secure the LZ so Murphy can pull you out of there.", FALSE );
		f_e8_m2_rendezvous_state( DEF_E8M2_RENDEZVOUS_STATE_START );
		
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e8_m2_dialog_rendezvous_fight()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_rendezvous_fight" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_rendezvous_fight', "Play_mus_pve_e08m2_rendezvous_fight" );
	
	sleep_s( 1.0 );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_rendezvous_fight", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
	b_e8m2_narrative_is_on = TRUE;

		local boolean b_at_lz = ( f_e8_m2_rendezvous_state() == DEF_E8M2_RENDEZVOUS_STATE_AT_LZ );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, b_at_lz, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00100', FALSE, NONE, 0.0, "", "Palmer: Bring Crimson home, Miller.", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, b_at_lz, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00101', FALSE, NONE, 0.0, "", "Miller: You got it, Commander. Murphy, Crimson’s ready for pickup.", FALSE );
		sleep_until( S_e8_m2_ai_phantom_lz_delivering > 0, 1 );
		hud_play_pip_from_tag( levels\dlc\shared\binks\SP_G04_60 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 1, not f_e8_m2_ai_phantom_lz_complete(), 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00102', FALSE, NONE, 0.0, "", "Murphy: Actually, Spartans, you got Phantoms in the area.", FALSE );
		
		// setup unload detection dialog
		wake( f_e8_m2_dialog_rendezvous_unload );
		
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e8_m2_dialog_rendezvous_unload()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_rendezvous_unload" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_rendezvous_unload', "Play_mus_pve_e08m2_rendezvous_unload" );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_rendezvous_unload", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
		sleep_until( S_e8_m2_ai_phantom_lz_dropping > 0, 1 );
		b_e8m2_narrative_is_on = TRUE;

		B_e8_m2_ai_phantom_lz_drop_ready = TRUE;		
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_incoming_00100', FALSE, NONE, 0.0, "", "Miller: He’s right, Commander. Phantom dropping reinforcements!", FALSE );
	
		//spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_incoming_00101', FALSE, NONE, 0.0, "", "Palmer: You’d think after we killed the first thousand of these goons they’d give up. Crimson, second verse, same as the first.", FALSE );
		// XXX split line and add when last line fires
		f_e8_m2_objective( R_e8_m2_objective_lz_finale_clear );
		thread( f_e8_m2_ordnance_drop(f_e8_m2_artillery_killed_cnt(), 0) );
	
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_e8_m2_dialog_complete_win()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_complete_win" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_complete_win', "Play_mus_pve_e08m2_complete_win" );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_complete_win", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );                       
	b_e8m2_narrative_is_on = TRUE;

		sleep_s( 1.0 );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_down_00100', FALSE, NONE, 0.0, "", "Miller: Phantom down! Air is clear! Come on down, Murphy.", FALSE );
		
		// start murphy coming back in
		ai_place( sq_e8m2_lz_murphy );

		//cui_hud_show_radio_transmission_hud( "incoming_transmission" );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_down_00101', FALSE, NONE, 0.0, "", "Murphy: On my way.", FALSE );
		sleep_s( 1.0 );

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_new_situation_00100', FALSE, NONE, 0.0, "", "8-2 Spartan: Infinity, Fireteam Lancer. We've got a situation in [HILLSIDE]. Covenant nest in the hills.", FALSE );
		cui_hud_show_radio_transmission_hud("palmer_transmission_name");
		hud_play_pip_from_tag( "levels\dlc\shared\binks\ep8_m2_1_60" );
		dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_new_situation_00101');
		sleep( sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_new_situation_00101') );
		//spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 3, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_new_situation_00101', FALSE, NONE, 0.0, "", "Palmer: Acknowledged, Lancer. Spartans, looks like there’s one more quick job before you get to come home.", FALSE );

		dprint( "WHAT? NO DRINKS???" );

	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_e8_m2_dialog_phantom()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
static boolean b_playing = FALSE;
static boolean b_strange = FALSE;
static long l_timer = 0;
	dprint( "f_e8_m2_dialog_phantom" );
	
	// phantom incoming dialog
	if ( (not b_playing) and (f_e8_m2_artillery_living_cnt() > 0) and (not dialog_foreground_active_check()) ) then
		b_playing = TRUE;

		spops_audio_music_event( 'Play_mus_pve_e08m2_phantom_first', "Play_mus_pve_e08m2_phantom_first" );

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_phantom", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
		b_e8m2_narrative_is_on = TRUE;
	
			// [NNN] temporarily hooked up generic - THFRENCH
			if ( timer_expired(l_timer) ) Then
				l_timer = timer_stamp( 45.0 );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_2_00100', FALSE, NONE, 0.0, "", "Dalton : Phantoms near Crimson's location, Commander.", FALSE );
			end
	
		b_e8m2_narrative_is_on = FALSE;
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
		b_playing = FALSE;
	end
	
	if ( (not b_strange) and (f_e8_m2_artillery_killed_cnt() > 0) ) then
		b_strange = TRUE;
		wake( f_e8_m2_dialog_strange );
	end

end

script dormant f_e8_m2_dialog_strange()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_strange" );
	spops_audio_music_event( 'play_mus_pve_e08m2_strange', "play_mus_pve_e08m2_strange" );

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_strange", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       

			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00100', FALSE, NONE, 0.0, "", "Miller: Oh, strange.", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00101', FALSE, NONE, 0.0, "", "Palmer: Elaborate, Miller.", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 3, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00102', FALSE, NONE, 0.0, "", "Miller: Just a second after I directed Crimson to the artillery, the Covenant made for it as well.", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 4, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00103', FALSE, NONE, 0.0, "", "Palmer: Could be a coincidence…", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 5, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00104', FALSE, NONE, 0.0, "", "Miller: Yeah...", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 6, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00105', FALSE, NONE, 0.0, "", "Palmer: It’s so not a coincidence, is it?", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 7, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00106', FALSE, NONE, 0.0, "", "Miller: I’ll keep an eye on it.", FALSE );
			
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e8_m2_dialog_phantom_kamikaze()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_phantom_kamikaze" );
	spops_audio_music_event( 'play_mus_pve_e08m2_phantom_kamikaze', "play_mus_pve_e08m2_phantom_kamikaze" );

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_phantom_kamikaze", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );        
		               
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, f_e8_m2_ai_phantom_finale_check(), 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_phantom_01', FALSE, NONE, 0.0, "", "Palmer: Phantom on approach.", FALSE );
			B_e8_m2_phantom_kamikaze_start = TRUE;
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 2, f_e8_m2_ai_phantom_finale_check(), 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_cover_01', FALSE, NONE, 0.0, "", "Palmer: Find some cover!", FALSE );
			
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_e8_m2_dialog_mop_up()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_mop_up" );

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_mop_up", l_dialog_id, f_e8_m2_ai_enemy_cnt() > 0, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );      
		                 
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, f_e8_m2_ai_enemy_cnt() > 0, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_07', FALSE, NONE, 0.0, "", "Miller: Mop up the last of them.", FALSE );

		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_e8_m2_dialog_complete_fail()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_complete_fail" );

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_complete_fail", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );       
		                
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: YOU FAIL, THE PELICAN BLEW UP!!!", FALSE );
			
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_e8_m2_dialog_ordnance( short s_level )
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_ordnance" );

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_ordnance", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );       

		  if ( s_level == 1 ) Then
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_1_00100', FALSE, NONE, 0.0, "", "Palmer: Dalton, send Crimson supplies.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_5_00200', FALSE, NONE, 0.0, "", "Dalton: I can arrange that, Commander.", FALSE );
		  end

		  if ( s_level == 2 ) Then
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_dropping_supplies_00101', FALSE, NONE, 0.0, "", "Miller: I'm having Dalton drop some extra gear for you now.", FALSE );
		  end
		
		  if ( s_level == 3 ) Then
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_dropping_supplies_00101', FALSE, NONE, 0.0, "", "Miller: I'm having Dalton drop some extra gear for you now.", FALSE );
				spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, 2, cr_e8m2_rvb->interacted(), 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_rvb_caboose_00100', FALSE, NONE, 0.0, "", "Caboose: Six crates of elbow grease and headlight fluid inbound now!", FALSE );
		  end
			
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_e8_m2_dialog_artillery_fire()
static long l_timer = 0;
static short s_index = random_range( 0, 3 );

	if ( timer_expired(l_timer) and (not dialog_foreground_active_check()) ) Then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		
		l_timer = timer_stamp( 15.0 );
		
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_complete_fail", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );       
		                
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, s_index == 0, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_07', FALSE, NONE, 0.0, "", "Miller: Inbound!", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, s_index == 1, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_06', FALSE, NONE, 0.0, "", "Palmer: Heads up!", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, s_index == 2, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_07', FALSE, NONE, 0.0, "", "Palmer: Inbound!", FALSE );
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, s_index == 3, 'sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06', FALSE, NONE, 0.0, "", "Miller: Heads up!", FALSE );
			
			// inc index
			s_index = s_index + 1;
			if ( s_index > 3 ) Then
				s_index = 0;
			end
			
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
	end

end




/*
script static void f_e8_m2_dialog_kill_all()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_kill_all" );

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_kill_all", l_dialog_id, (f_e8_m2_ai_enemy_cnt() > 0) and (f_e8_m2_ai_enemy_cnt() > spops_ai_mop_up_cnt()), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );  
		                     
			spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 1, (f_e8_m2_ai_enemy_cnt() > 0) and (f_e8_m2_ai_enemy_cnt() > spops_ai_mop_up_cnt()), NONE, FALSE, NONE, 0.0, "", "INFINITY: MOP UP!!!", FALSE );

		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
*/

/*
script dormant f_e8_m2_dialog_start_cleared_lz()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_start_cleared_lz" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_start_cleared_lz', "Play_mus_pve_e08m2_start_cleared_lz" );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_start_cleared_lz", l_dialog_id, S_e8m2_artillery_state < DEF_E8M2_ARTILLERY_STATE_KNOWN, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
	b_e8m2_narrative_is_on = TRUE;

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, S_e8m2_artillery_state < DEF_E8M2_ARTILLERY_STATE_KNOWN, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_clear_covies_00100', FALSE, NONE, 0.0, "", "Miller: Area’s clear, Commander.", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, S_e8m2_artillery_state < DEF_E8M2_ARTILLERY_STATE_KNOWN, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_clear_covies_00101', FALSE, NONE, 0.0, "", "Palmer: Then it’s time to hit those emplacements.", FALSE );

	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
*/
/*
script dormant f_e8_m2_dialog_artillery_infinity_info()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_artillery_infinity_info" );
	spops_audio_music_event( 'Play_mus_pve_e08m2_artillery_infinity_info', "Play_mus_pve_e08m2_artillery_infinity_info" );
				
	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_infinity_warn", l_dialog_id, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
	b_e8m2_narrative_is_on = TRUE;
	
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 0, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_doesnt_know_00100', FALSE, NONE, 0.0, "", "Palmer: Miller, best place to hit that artillery?", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 1, S_e8m2_artillery_state <= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_doesnt_know_00101', FALSE, NONE, 0.0, "", "Miller: Looking now. It's a mix of Covenant and Forerunner tech... Give me just a minute.", FALSE );
		
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
*/
/*
script dormant f_e8_m2_dialog_pelican_circling()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_pelican_circling" );

	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_pelican_circling", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
	b_e8m2_narrative_is_on = TRUE;

		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, 0, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_circling_00100', FALSE, NONE, 0.0, "", "Miller: Phantom’s still circling, trying to lock the area down.", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, 1, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_circling_00101', FALSE, NONE, 0.0, "", "Murphy: He ain’t trying anything. He’s damn well doing it.", FALSE );
		spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, 2, TRUE, 'sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_phantom_00100', FALSE, NONE, 0.0, "", "Palmer: Crimson, get that Phantom off Murphy's tail!", FALSE );
		
		
	b_e8m2_narrative_is_on = FALSE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
*/
