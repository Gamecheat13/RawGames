// =================================================================================================
// =================================================================================================
// =================================================================================================
//	NARRATIVE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// === IsNarrativeFlagSetOnAllPlayer: Checks if a narrative flag has been set on all players matching a state
//			[short] s_narrative_flag_index = Flag index
//			[boolean] b_state = State to test
//						[optional] DEFAULT == TRUE
//	RETURNS:  [boolean] TRUE; if all valid players flags match that state
script static boolean IsNarrativeFlagSetOnAllPlayer( short s_narrative_flag_index, boolean b_state )

	( (not player_is_in_game(player0)) or (GetNarrativeFlag(player0,s_narrative_flag_index) == b_state) )
	and
	( (not player_is_in_game(player1)) or (GetNarrativeFlag(player1,s_narrative_flag_index) == b_state) )
	and
	( (not player_is_in_game(player2)) or (GetNarrativeFlag(player2,s_narrative_flag_index) == b_state) )
	and
	( (not player_is_in_game(player3)) or (GetNarrativeFlag(player3,s_narrative_flag_index) == b_state) );
	
end
script static boolean IsNarrativeFlagSetOnAllPlayer( short s_narrative_flag_index )
	IsNarrativeFlagSetOnAllPlayer( s_narrative_flag_index, TRUE );
end

// =================================================================================================
// =================================================================================================
// DOMAIN TERMINALS
// =================================================================================================
// =================================================================================================
global object obj_narrative_pup_player = NONE;
global object obj_narrative_pup_terminal = NONE;

// === f_narrative_domain_terminal_setup: Sets up and manages a domain terminal
//			[short] s_terminal_id = Domain terminal index
//			[object_name] obj_terminal = Terminal crate object
//			[object_name] obj_button = button (device control) that the player interacts with
//	RETURNS:  [void]
script static void f_narrative_domain_terminal_setup( short s_terminal_id, object_name obj_terminal, object_name obj_button )
local boolean b_active = FALSE;

	if ( editor_mode() ) then
		SetNarrativeFlagOnLocalPlayers( s_terminal_id, FALSE );
	end

	repeat
	
		// wait for the object to become valid
		sleep_until( object_valid(obj_terminal) and object_valid(obj_button), 1 );
		
		// check if it should be active
		b_active = f_narrative_domain_terminal_active( s_terminal_id );
		
		// setup
		if ( b_active and (f_narrative_domain_terminal_sphere(obj_terminal) != NONE) ) then
			//dprint( "f_narrative_domain_terminal_setup: ACTIVATE!!!!!!!" );
			f_narrative_domain_terminal_sphere_phase( obj_terminal, TRUE, FALSE );
			device_set_power( device(obj_button), 1.0 );
		else
			//dprint( "f_narrative_domain_terminal_setup: DEACTIVATE!!!!!!!" );
			device_set_power( device(obj_button), 0.0 );
			f_narrative_domain_terminal_sphere_phase( obj_terminal, FALSE, FALSE );
		end
		
		//dprint( "f_narrative_domain_terminal_setup!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
		
		// wait to reset checks
		sleep_until( (not object_valid(obj_terminal)) or (not object_valid(obj_button)) or ((f_narrative_domain_terminal_sphere(obj_terminal) != NONE) and (b_active != f_narrative_domain_terminal_active(s_terminal_id))), 1 );
		
	until( FALSE, 1 );
	//dprint( "f_narrative_domain_terminal_setup: EXIT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );

end

// === f_narrative_domain_terminal_interact: Sets up and manages a domain terminal
//			[short] s_terminal_id = Domain terminal index
//			[object_name] obj_terminal = Terminal crate object
//			[device] dc_button = button (device control) that the player interacts with
//			[unit] u_activator = player who pressed the button
//			[u_activator] sid_pup = name of the puppeteer
//	RETURNS:  [void]
script static void f_narrative_domain_terminal_interact( short s_terminal_id, object_name obj_terminal, device dc_button, unit u_activator, string_id sid_pup )
	local long l_pup_id = -1;

	// wait for input
	device_set_power( dc_button, 0.0 );

	// set user
	obj_narrative_pup_player = u_activator;
	obj_narrative_pup_terminal = obj_terminal;

	// prep player
	object_cannot_die( u_activator, TRUE );

	// play the pup
	l_pup_id = pup_play_show( sid_pup );
	sleep_until( not pup_is_playing(l_pup_id), 1 );

	// reset player
	object_cannot_die( u_activator, FALSE );

	// phase out the terminal sphere
	sleep_s( 0.125 );
	thread( f_narrative_domain_terminal_sphere_phase(obj_terminal, FALSE, TRUE) );

	// wait for terminal to vanish
	sleep_until( f_narrative_domain_terminal_sphere(obj_terminal) == NONE, 1 );

	// check for first domain
 	if ( f_narrative_domain_terminal_first() ) then
		wake( f_dialog_global_my_first_domain ); 
	end

	// set the variable
	SetNarrativeFlagWithFanfareMessageForAllPlayers( s_terminal_id, TRUE );
	
end

// === f_narrative_domain_terminal_pressed: Call back when the button is pressed in the ICS
//			[object] obj_terminal = Terminal crate object
//	RETURNS:  [void]
script static void f_narrative_domain_terminal_pressed( object obj_terminal )
	dprint( "f_narrative_domain_terminal_pressed" );
	
end

// === f_narrative_domain_terminal_active: Checks to see if a terminal should be active
//			[short] s_terminal_id = ID for the terminal
//	RETURNS:  [boolean] TRUE; the terminal should be active, FALSE; the terminal should not be active
script static boolean f_narrative_domain_terminal_active( short s_terminal_id )

	( player_is_in_game(player0) and (GetNarrativeFlag(player0,s_terminal_id) == FALSE) )
	or
	( player_is_in_game(player1) and (GetNarrativeFlag(player1,s_terminal_id) == FALSE) )
	or
	( player_is_in_game(player2) and (GetNarrativeFlag(player2,s_terminal_id) == FALSE) )
	or
	( player_is_in_game(player3) and (GetNarrativeFlag(player3,s_terminal_id) == FALSE) );
	
end


// === f_narrative_domain_terminal_sphere: Gets the sphere object off of a terminal
//			[object] obj_terminal = Terminal crate object
//	RETURNS:  [object] 
script static object f_narrative_domain_terminal_sphere( object obj_terminal )
	object_at_marker( obj_terminal, 'dissolve' );
end

script static void f_narrative_domain_terminal_sphere_phase( object obj_terminal, boolean b_phase_in, boolean b_destroy )
local object obj_sphere = f_narrative_domain_terminal_sphere( obj_terminal );
	
	// play fx
	if ( obj_sphere != NONE ) then
		if ( b_phase_in ) then
			object_dissolve_from_marker( obj_sphere, 'phase_in', 'fx_dissolve_back' );
		else
			object_dissolve_from_marker( obj_sphere, 'phase_out', 'fx_dissolve_back' );
		end
	end

	// wait for fx to finish
	if ( obj_sphere != NONE ) then
		sleep_s( 1.75 );
	end

	// destroy
	if ( b_destroy and (obj_sphere != NONE) ) then
		object_destroy( obj_sphere );
	end

end

script static boolean f_narrative_domain_terminal_first()
	(
		player_is_in_game( player0 )
		and
		(
			( GetNarrativeFlag( player0, 0 ) == FALSE )
			and
			( GetNarrativeFlag( player0, 1 ) == FALSE )
			and
			( GetNarrativeFlag( player0, 2 ) == FALSE )
			and
			( GetNarrativeFlag( player0, 3 ) == FALSE )
			and
			( GetNarrativeFlag( player0, 4 ) == FALSE )
			and
			( GetNarrativeFlag( player0, 5 ) == FALSE )
			and
			( GetNarrativeFlag( player0, 6 ) == FALSE )
		)
	)
	or
	(
		player_is_in_game( player1 )
		and
		(
			( GetNarrativeFlag( player1, 0 ) == FALSE )
			and
			( GetNarrativeFlag( player1, 1 ) == FALSE )
			and
			( GetNarrativeFlag( player1, 2 ) == FALSE )
			and
			( GetNarrativeFlag( player1, 3 ) == FALSE )
			and
			( GetNarrativeFlag( player1, 4 ) == FALSE )
			and
			( GetNarrativeFlag( player1, 5 ) == FALSE )
			and
			( GetNarrativeFlag( player1, 6 ) == FALSE )
		)
	)
	or
	(
		player_is_in_game( player2 )
		and
		(
			( GetNarrativeFlag( player2, 0 ) == FALSE )
			and
			( GetNarrativeFlag( player2, 1 ) == FALSE )
			and
			( GetNarrativeFlag( player2, 2 ) == FALSE )
			and
			( GetNarrativeFlag( player2, 3 ) == FALSE )
			and
			( GetNarrativeFlag( player2, 4 ) == FALSE )
			and
			( GetNarrativeFlag( player2, 5 ) == FALSE )
			and
			( GetNarrativeFlag( player2, 6 ) == FALSE )
		)
	)
	or
	(
		player_is_in_game( player3 )
		and
		(
			( GetNarrativeFlag( player3, 0 ) == FALSE )
			and
			( GetNarrativeFlag( player3, 1 ) == FALSE )
			and
			( GetNarrativeFlag( player3, 2 ) == FALSE )
			and
			( GetNarrativeFlag( player3, 3 ) == FALSE )
			and
			( GetNarrativeFlag( player3, 4 ) == FALSE )
			and
			( GetNarrativeFlag( player3, 5 ) == FALSE )
			and
			( GetNarrativeFlag( player3, 6 ) == FALSE )
		)
	);
 	
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// TEMPORARY STORY BLURB DISPLAYS
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// ct_title = The name of the Chapter Title you want to appear.
// r_time = The time you want the message to be displayed (in seconds).  This is usually the Fade In Time, Display Time and Fade Out Time of the Chapter Title added together.
// b_cinematicstart = set this to TRUE if you want to take control away from the player and have cinematic bars come down on the screen.
// b_cinematicend = set this to TRUE if you want to return control to the player and remove the cinematic bars from the screen.
// -------------------------------------------------------------------------------------------------
// Example use displaying three sequential chapter headings while the player can't move:
// 
// script dormant storybyte01()
//		sleep_until(volume_test_players (trigger_volume_name), 1);
//		storyblurb_display (ct_title01, 7, TRUE, FALSE);
//		storyblurb_display (ct_title02, 9, FALSE, FALSE);
//		storyblurb_display (ct_title03, 5, FALSE, TRUE);	
// end	
// -------------------------------------------------------------------------------------------------
script static void storyblurb_display (cutscene_title ct_title, real r_time, boolean b_cinematicstart, boolean b_cinematicend)	
	
	if b_cinematicstart then 
		chud_cinematic_fade (0, 30);
		player_disable_movement (TRUE);
		cinematic_show_letterbox (TRUE);
	end
 
	cinematic_set_title (ct_title);
	sleep_s (r_time);
	
	if b_cinematicend then
		chud_cinematic_fade (1, 30);
		cinematic_show_letterbox (FALSE);
		player_disable_movement (FALSE);
	end

end

// =================================================================================================
// =================================================================================================
// Story Blurbs
// =================================================================================================
// =================================================================================================
script static void story_blurb_add(string type, string content)	
	if (type == "cutscene") then
		thread (story_blurb_add_cutscene(content));
	end	

	if (type == "vo") then
		thread (story_blurb_add_vo(content));
	end
	
	if (type == "domain") then
		thread (story_blurb_add_domain(content));
	end
	
	if (type == "other") then
		thread (story_blurb_add_other(content));
	end
		
end

script static void story_blurb_clear()
	clear_all_text();
end

script static void story_blurb_add_vo(string content)
 	 	// Fonts:
 	 	// Assign the font to use. Valid options are: terminal, body, title, super_large,
		// large_body, split_screen_hud, full_screen_hud, English_body, 
  	// hud_number, subtitle, main_menu. Default is “subtitle”

		set_text_defaults();
		
		// color, scale, life, font
    set_text_lifespan(30 * 5);
		set_text_color(1, 0.22, 0.77, 0.0);
		set_text_font(arame_regular_16);                                                                  
		set_text_scale(1.5);
		
		// alignments
		set_text_alignment(bottom);
		set_text_margins( 0.05, 0.0, 0.05, 0.1 );	// l,t,r,b        
		set_text_indents(0,0); 
		set_text_justification(center);
		set_text_wrap(1, 1);
				
		// shadow
		set_text_shadow_style(drop);							// Sets the drop shadow type. Options are drop, outline, none.
		set_text_shadow_color(1, 0, 0, 0);

		// display the text!
		show_text(content);
end

script static void story_blurb_add_cutscene(string content)
 	 	// Fonts:
 	 	// Assign the font to use. Valid options are: terminal, body, title, super_large,
		// large_body, split_screen_hud, full_screen_hud, English_body, 
  	// hud_number, subtitle, main_menu. Default is “subtitle”

		set_text_defaults();
		
		// color, scale, life, font
    set_text_lifespan(30 * 5);
		set_text_color(1, 1, 0.745, 0.137);
		set_text_font(arame_regular_16);                                                                  
		set_text_scale(1.3);
		
		// alignments
		set_text_alignment(bottom);
		set_text_margins(0.05, 0.0, 0.05, 0.05);	// l,r,t,b        
		set_text_indents(0,0); 
		set_text_justification(center);
		set_text_wrap(1, 1);
				
		// shadow
		set_text_shadow_style(drop);							// Sets the drop shadow type. Options are drop, outline, none.
		set_text_shadow_color(1, 0, 0, 0);

		// display the text!
		show_text(content);
end

script static void story_blurb_add_domain(string content)
 	 	// Fonts:
 	 	// Assign the font to use. Valid options are: terminal, body, title, super_large,
		// large_body, split_screen_hud, full_screen_hud, English_body, 
  	// hud_number, subtitle, main_menu. Default is “subtitle”

		set_text_defaults();
		
		// color, scale, life, font
    set_text_lifespan(30 * 5);
		set_text_color(1, 0.9, 0.0, 0.9);
		set_text_font(arame_regular_16);                                                                  
		set_text_scale(1.5);
		
		// alignments
		set_text_alignment(bottom);
		set_text_margins(0.05, 0.0, 0.05, 0.2);	// l,r,t,b        
		set_text_indents(0,0); 
		set_text_justification(center);
		set_text_wrap(1, 1);
				
		// shadow
		set_text_shadow_style(drop);							// Sets the drop shadow type. Options are drop, outline, none.
		set_text_shadow_color(1, 0, 0, 0);

		// display the text!
		show_text(content);
end

script static void story_blurb_add_other(string content)
 	 	// Fonts:
 	 	// Assign the font to use. Valid options are: terminal, body, title, super_large,
		// large_body, split_screen_hud, full_screen_hud, English_body, 
  	// hud_number, subtitle, main_menu. Default is “subtitle”

		set_text_defaults();
		
		// color, scale, life, font
    set_text_lifespan(30 * 5);
		set_text_color(1, 1, 1, 1);
		set_text_font(arame_regular_16);                                                                  
		set_text_scale(1.2);
		
		// alignments
		set_text_alignment(bottom);
		set_text_margins(0.05, 0.0, 0.05, 0.25);	// l,r,t,b        
		set_text_indents(0,0); 
		set_text_justification(center);
		set_text_wrap(1, 1);
				
		// shadow
		set_text_shadow_style(drop);							// Sets the drop shadow type. Options are drop, outline, none.
		set_text_shadow_color(1, 0, 0, 0);

		// display the text!
		show_text(content);
end


// =================================================================================================
// =================================================================================================
// Picture in Picture
// =================================================================================================
// =================================================================================================
script static void pip_on()
		set_text_defaults();
		
		// color, scale, life, font
    set_text_lifespan(30 * 20);
		set_text_color(1, 0, .78, .89);
		set_text_font(terminal);                                                                  
		set_text_scale(3.0);
		
		// alignments
		set_text_alignment(bottom);
		set_text_indents(0,0); 
		set_text_justification(right);
		set_text_wrap(1, 1);
				
		// shadow
		set_text_shadow_style(drop);							// Sets the drop shadow type. Options are drop, outline, none.
		set_text_shadow_color(0, 0, 0, 0);

		// faked PIP for now
		set_text_margins(0, 0, 0.02, 0.26);  
		show_text("**************");
		set_text_margins(0, 0, 0.02, 0.22);  
		show_text("*----++++----*");
		set_text_margins(0, 0, 0.02, 0.18);  
		show_text("*---++++++---*");
		set_text_margins(0, 0, 0.02, 0.14);  
		show_text("*---++++++---*");
		set_text_margins(0, 0, 0.02, 0.10);  
		show_text("*---++++++---*");
		set_text_margins(0, 0, 0.02, 0.06);  
		show_text("*----++++----*");
		set_text_margins(0, 0, 0.02, 0.02);  
		show_text("**************");
end

script static void pip_off()
		clear_all_text();                                                               
end

// =================================================================================================
// =================================================================================================
// Play temp BINK Cutscene
// =================================================================================================
// =================================================================================================
global boolean play_temp_bink_cutscene_bool = 0;

script static void play_temp_bink_cutscene(string cutscene_name, real time_to_wait)
	fade_out_for_player (player0);
	fade_out_for_player (player1);
	fade_out_for_player (player2);
	fade_out_for_player (player3);

	player_action_test_reset();

	player_enable_input (0);
	camera_control (1);

	thread (play_temp_bink_cutscene_wait_length(time_to_wait));	
	
	play_bink_movie(cutscene_name);
	
	sleep_until(play_temp_bink_cutscene_bool 	OR player_action_test_primary_trigger()
																		 					OR player_action_test_jump()	
																		 					OR player_action_test_melee()
																		 					OR player_action_test_start()
																		 					OR player_action_test_context_primary()
																		 					OR player_action_test_equipment()
																		 					OR player_action_test_back()
																		 					OR player_action_test_rotate_weapons()
																		 					OR player_action_test_cancel()
																		 					OR player_action_test_grenade_trigger()
		, 1);
	
	play_temp_bink_cutscene_bool = 0;
			
	player_enable_input (1);
	camera_control (0);
	
	fade_in_for_player (player0);
	fade_in_for_player (player1);
	fade_in_for_player (player2);
	fade_in_for_player (player3);
end


script static void play_temp_bink_cutscene_wait_length(real time_to_wait)
	sleep_s(time_to_wait);
	play_temp_bink_cutscene_bool = 1;
end

// =================================================================================================
// =================================================================================================
// Cinematic Text
// =================================================================================================
// =================================================================================================
script static void cinematic_text(string content, real time_to_display)
 	 	// Fonts:
 	 	// Assign the font to use. Valid options are: terminal, body, title, super_large,
		// large_body, split_screen_hud, full_screen_hud, English_body, 
  	// hud_number, subtitle, main_menu. Default is “subtitle”

		set_text_defaults();
		
		// color, scale, life, font
    set_text_lifespan(30 * time_to_display);
		set_text_color(1, 1, 1, 1);
		set_text_font(arame_regular_23);                                                                  
		set_text_scale(1.0);
		
		// alignments
		set_text_alignment(center);
		set_text_margins(0.05, 0.0, 0.05, 0.0);	// l,r,t,b        
		set_text_indents(0,0); 
		set_text_justification(center);
		set_text_wrap(1, 1);
				
		// shadow
		set_text_shadow_style(drop);							// Sets the drop shadow type. Options are drop, outline, none.
		set_text_shadow_color(1, 0, 0, 0);

		// display the text!
		show_text(content);
end

// =================================================================================================
// =================================================================================================
// Playing Cinematics
// =================================================================================================
// =================================================================================================

	
script static void f_cinematic_play( string_ID st_cinematic_name, zone_set zoneset_ID, short s_cinematic_ins, short s_play_ins )

	dprint( "*** INSERTION POINT: CINEMATIC ***" );
  
  cinematic_enter( st_cinematic_name, TRUE );
   
  if ( s_cinematic_ins != -1 ) then
	  cinematic_suppress_bsp_object_creation( TRUE );

	  switch_zone_set( zoneset_ID );
	  sleep( 1 );
	  sleep_until( current_zone_set_fully_active() == s_cinematic_ins, 1 );
	  sleep( 1 );

	  cinematic_suppress_bsp_object_creation( FALSE );
  end
    
  f_start_mission( st_cinematic_name );
  cinematic_exit_no_fade( st_cinematic_name, TRUE ); 
    
	dprint( "Cinematic exited!" ); 
 
  if ( s_play_ins != -1 ) then
		game_insertion_point_set( s_play_ins );
	end
 
end


// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================

script dormant f_waypoint_global_equipment_unlock()
	dprint("WAYPOINT CHECK THREADED");
	
	/*wake(f_waypoint_equipment_unlock_active_shield);

	wake(f_waypoint_equipment_unlock_active_camo);

	wake(f_waypoint_equipment_unlock_forerunner_vision);
	
	wake(f_waypoint_equipment_unlock_hologram);

	wake(f_waypoint_equipment_unlock_jet_pack);

	wake(f_waypoint_equipment_unlock_auto_turret);

	wake(f_waypoint_equipment_unlock_thruster_pack);*/

end
/*

script dormant f_waypoint_equipment_unlock_active_shield()

	sleep_until ( 
		 unit_has_equipment (player0, "objects\equipment\storm_active_shield\storm_active_shield_pve.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_active_shield\storm_active_shield_pve.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_active_shield\storm_active_shield_pve.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_active_shield\storm_active_shield_pve.equipment")
	, 1);	
			if IsNarrativeFlagSetOnAnyPlayer(52) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 52, TRUE );
					dprint("Active Shield acquired");
			end
end

script dormant f_waypoint_equipment_unlock_active_camo()
		dprint("ACTIVE CAMO CHECK THREADED");
		
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo.equipment")	
		or unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo.equipment")	
		or unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo.equipment")	
	, 1);	

	
			if IsNarrativeFlagSetOnAnyPlayer(51) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 51, TRUE );
	
					
			end								
end

script dormant f_waypoint_equipment_unlock_forerunner_vision()

	sleep_until ( 
		unit_has_equipment (player0, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
	, 1);		
	
			if IsNarrativeFlagSetOnAnyPlayer(49) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 49, TRUE );
					dprint("Forerunner Vision acquired");
					
			end
end
	
script dormant f_waypoint_equipment_unlock_hologram()

	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_hologram\storm_hologram.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_hologram\storm_hologram.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_hologram\storm_hologram.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_hologram\storm_hologram.equipment")
	, 1);		
			if IsNarrativeFlagSetOnAnyPlayer(53) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 53, TRUE );
					dprint("Hologram acquired");
			end
end

script dormant f_waypoint_equipment_unlock_jet_pack()

	sleep_until (  unit_has_equipment (player0, "objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment")
	, 1);		
			if IsNarrativeFlagSetOnAnyPlayer(50) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 50, TRUE );
					dprint("Jet Pack acquired");

			end
end

script dormant f_waypoint_equipment_unlock_auto_turret()

	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment")
	, 1);					
			if IsNarrativeFlagSetOnAnyPlayer(54) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 54, TRUE );
					dprint("Auto Turret acquired");

			end
end

script dormant f_waypoint_equipment_unlock_thruster_pack()

	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
	, 1);	
				
			if IsNarrativeFlagSetOnAnyPlayer(55) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 55, TRUE );
					dprint("Thruster Pack acquired");
	
			end
end*/