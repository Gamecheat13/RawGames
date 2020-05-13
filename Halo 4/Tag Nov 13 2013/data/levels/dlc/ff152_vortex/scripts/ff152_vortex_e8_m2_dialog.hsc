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

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script dormant f_e8_m2_dialog_intro()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_intro" );
					
	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_intro", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: Inbound...", FALSE );
		dialog_line_radio( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: Got some enemies inbound.", FALSE );
		dialog_line_radio( l_dialog_id, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: Sorry for the hot drop but...", FALSE );
		dialog_line_radio( l_dialog_id, 3, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: This is the only spot we could find away from those artillery.", FALSE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_e8_m2_dialog_start()
	dprint( "f_e8_m2_dialog_start" );

	L_e8_m2_dialog_start = dialog_start_foreground( "e8_m2_dialog_start", L_e8_m2_dialog_start, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
	
		// wake the UNSC greeting
		wake( f_e8_m2_dialog_unsc_greet );
		
		sleep_s( 0.5 );
		f_e8_m2_ai_pelican_01_state( "GO" );
		dialog_line_radio( L_e8_m2_dialog_start, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: We're going to back out of the area...", FALSE );
		
		f_e8_m2_ai_pelican_01_state( "WARTHOG" );
		dialog_line_radio( L_e8_m2_dialog_start, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: Things are just a bit tight in here for us to sit around.", FALSE );
		
		sleep_until( f_e8_m2_ai_pelican_01_state() == "LEAVING", 1 );
		dialog_line_radio( L_e8_m2_dialog_start, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: Good luck down there.", FALSE );
		dialog_line_radio( L_e8_m2_dialog_start, 3, TRUE, NONE, FALSE, NONE, 0.0, "", "PELICAN: We will rendezvous back here when you're d...", FALSE );
		f_e8_m2_ai_pelican_01_state( "EXPLODE" );
		
	L_e8_m2_dialog_start = dialog_end( L_e8_m2_dialog_start, TRUE, TRUE, "" );

end

script dormant f_e8_m2_dialog_unsc_greet()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	sleep_s( 1.0 );
	l_dialog_id = dialog_start_background( "e8_m2_dialog_unsc_greet", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       
		dialog_line_npc( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "SPARTANS: Let's push 'em back boys!", FALSE );
		dialog_line_npc( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "SPARTANS: WOOP WOOP!", FALSE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

script dormant f_e8_m2_dialog_artillery_soldiers_info()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_artillery_soldiers_info" );

	sleep_s( 1.0 );
	l_dialog_id = dialog_start_background( "e8_m2_dialog_marine_artillery", l_dialog_id, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_KNOWN, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		if ( objects_distance_to_players(ai_actors(gr_e8_m2_lz_unsc)) <= 5.0 ) then
			// XXX grab nearest SPARTAN and make him say this
			dialog_line_npc( l_dialog_id, 0, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_KNOWN, NONE, FALSE, NONE, 0.0, "", "[3D] SPARTAN: There are artillery emplacements just along the ridgeline.", FALSE );
		else
			dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_KNOWN, NONE, FALSE, NONE, 0.0, "", "SPARTAN: There are artillery emplacements just along the ridgeline.", FALSE );
		end
		f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_KNOWN );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_e8_m2_dialog_artillery_infinity_info()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_artillery_infinity_info" );
					
	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_infinity_warn", l_dialog_id, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
		dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN, NONE, FALSE, NONE, 0.0, "", "INFINITY: We’ve never seen this type of ARTILLERY before.", FALSE );
		dialog_line_radio( l_dialog_id, 1, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN, NONE, FALSE, NONE, 0.0, "", "INFINITY: They appear to be a mix of Covenant and Forerunner design.", FALSE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_e8_m2_dialog_artillery_near()
static boolean b_playing = FALSE;
	dprint( "f_e8_m2_dialog_artillery_near" );
	
	if ( not b_playing ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_playing = TRUE;
		
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_near", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
		
			if ( f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_NEAR ) then

				dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_NEAR, NONE, FALSE, NONE, 0.0, "", "INFINITY: There's an artillery...", FALSE );
				f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_NEAR );
				dialog_line_radio( l_dialog_id, 1, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_NEAR, NONE, FALSE, NONE, 0.0, "", "INFINITY: Take it out.", FALSE );

			elseif ( f_e8_m2_artillery_living_cnt() == 1 ) then
				dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Let’s hurry up and take this one out so we can get you guys home!", FALSE );
			end
		
		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
	
		b_playing = FALSE;
	end

end

script static void f_e8_m2_dialog_artillery_tough()
static boolean b_triggered = FALSE;
	dprint( "f_e8_m2_dialog_artillery_tough" );

	if ( (f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH) and (not b_triggered) ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_triggered = TRUE;

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_tough", l_dialog_id, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );                       
			dprint( "f_e8_m2_dialog_artillery_tough: A" );
			dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH, NONE, FALSE, NONE, 0.0, "", "INFINITY: The shields for those things seem to be too tough.", FALSE );
			dprint( "f_e8_m2_dialog_artillery_tough: B" );
			dialog_line_radio( l_dialog_id, 1, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH, NONE, FALSE, NONE, 0.0, "", "INFINITY: We’re detecting some POWER CORES around the ARTILLERY that get really hot when they fire.", FALSE );

			if ( f_e8_m2_artillery_state() == DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH ) then
				dprint( "f_e8_m2_dialog_artillery_tough: C" );
				f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK );
			end

			dialog_line_radio( l_dialog_id, 2, f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK, NONE, FALSE, NONE, 0.0, "", "INFINITY: Try taking those out.", FALSE );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end

end

script static void f_e8_m2_dialog_artillery_core_attacked( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )
static boolean b_triggered = FALSE;
	dprint( "f_e8_m2_dialog_artillery_core_attacked" );

	if ( (not b_triggered) and (f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_triggered = TRUE;
						
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_core_attacked", l_dialog_id, (f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
			dialog_line_radio( l_dialog_id, 0, (f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED), NONE, FALSE, NONE, 0.0, "", "INFINITY: That's it!", FALSE );
			dialog_line_radio( l_dialog_id, 1, (f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED) and (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS), NONE, FALSE, NONE, 0.0, "", "INFINITY: Damaging those POWER CORES seem to be affecting the ARTILLERY.", FALSE );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end

end

script static void f_e8_m2_dialog_artillery_core_destroyed()
static boolean b_playing = FALSE;
static long l_timer = 0;
	dprint( "f_e8_m2_dialog_artillery_core_destroyed" );

	if ( (not b_playing) and timer_expired(l_timer) ) then
		static long l_dialog_id = DEF_DIALOG_ID_NONE();
		static short s_played_cnt = 0;
		b_playing = TRUE;
						
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_core_destroyed", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );

			if ( s_played_cnt == 0 ) then
				dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Keep it up <DESTROYED FIRST>.", FALSE );
			else
				begin_random_count(1)			
					dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Keep it up <RANDOM A>.", FALSE );
					dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Keep it up <RANDOM B>.", FALSE );
					dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Keep it up <RANDOM C>.", FALSE );
				end
			end

			if ( dialog_id_active_check(l_dialog_id) ) then
				l_timer = timer_stamp( 10.0 );
			end

		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

		s_played_cnt = s_played_cnt + 1;

		b_playing = FALSE;
	end

end

script static void f_e8_m2_dialog_artillery_destabilized( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )
static boolean b_triggered = FALSE;
	dprint( "f_e8_m2_dialog_artillery_destabilized" );

	if ( (not b_triggered) and (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) ) then
		dprint( "f_e8_m2_dialog_artillery_destabilized: A" );
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_triggered = TRUE;
						
		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_destabilized", l_dialog_id, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
			dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED, NONE, FALSE, NONE, 0.0, "", "INFINITY: The destroying the cores seems to have destabilizing the ARTILLERY when they fires.", FALSE );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end

end

script static void f_e8_m2_dialog_artillery_cores_destroyed( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )
static boolean b_playing = FALSE;
	dprint( "f_e8_m2_dialog_artillery_cores_destroyed" );

	if ( not b_playing ) then
		static long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_playing = TRUE;

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_cores_destroyed", l_dialog_id, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
			if ( f_e8_m2_artillery_killed_cnt() == 0 ) then
				dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: That's all the cores <FIRST>!", FALSE );
			else
				begin_random_count(1)			
					dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: That's all the cores <RANDOM A>!", FALSE );
					dialog_line_radio( l_dialog_id, 0, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: That's all the cores <RANDOM B>!", FALSE );
				end
			end
		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

		b_playing = FALSE;
	end

end

script static void f_e8_m2_dialog_artillery_dangerous( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )
static boolean b_playing = FALSE;
static short s_play_cnt = 0;
	dprint( "f_e8_m2_dialog_artillery_dangerous" );

	// wait to trigger
	sleep_until( (objects_distance_to_object(Players(), obj_artillery) <= R_e8m2_artilleray_explosion_warning_range) or (object_get_health(obj_artillery) <= 0.0), 1 );

	if ( (not b_playing) and (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS) ) then
		b_playing = TRUE;
						
		L_e8_m2_dialog_artillery_dangerous = dialog_start_foreground( "e8_m2_dialog_artillery_dangerous", L_e8_m2_dialog_artillery_dangerous, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );                       
			if ( s_play_cnt == 0 ) then
				dialog_line_radio( L_e8_m2_dialog_artillery_dangerous, 0, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: Back off.", FALSE );
				dialog_line_radio( L_e8_m2_dialog_artillery_dangerous, 1, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: You don’t want to be nearby when the ARTILLERY it explodes.", FALSE );
			else
				dialog_line_radio( L_e8_m2_dialog_artillery_dangerous, 0, f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, NONE, FALSE, NONE, 0.0, "", "INFINITY: You're too close to the artillery.", FALSE );
			end
			if ( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS ) then
				sleep_s( 1.0 );
			end
		L_e8_m2_dialog_artillery_dangerous = dialog_end( L_e8_m2_dialog_artillery_dangerous, FALSE, FALSE, "" );

		s_play_cnt = s_play_cnt + 1;
		b_playing = FALSE;
	end

end

script static void f_e8_m2_dialog_artillery_destroyed()
static boolean b_playing = FALSE;
	dprint( "f_e8_m2_dialog_artillery_destroyed" );

	if ( not b_playing ) then
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
		b_playing = TRUE;

		l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_destroyed", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
			if ( f_e8_m2_artillery_living_cnt() == 0 ) then
				dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Great job!", FALSE );
				dialog_line_radio( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: That was the last of them.", FALSE );
			elseif ( f_e8_m2_artillery_killed_cnt() == 1 ) then
				dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: One down!", FALSE );
			else
				dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Another artillery destroyed!", FALSE );
			end

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

		if ( (f_e8_m2_artillery_living_cnt() == 1) and (not b_switch_last) ) then
			dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: The enemy is moving to the final artillery!", FALSE );
		elseif ( (f_e8_m2_artillery_living_cnt() == 0) and (not b_switch_lz) ) then
			dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: The enemy swarming on the final artillery!", FALSE );
		elseif ( not b_switch_first ) then
			dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: The enemy is shifting to another artillery!", FALSE );
		end

		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

		b_playing = FALSE;
	end

end




script dormant f_e8_m2_dialog_rendezvous_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e8_m2_dialog_rendezvous_start" );
					
	l_dialog_id = dialog_start_foreground( "e8_m2_dialog_artillery_complete", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );                       
		dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: PELICAN inbound.", FALSE );
		dialog_line_radio( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Rendezvous back at the LZ.", FALSE );
		f_e8_m2_rendezvous_state( DEF_E8M2_RENDEZVOUS_STATE_START );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
