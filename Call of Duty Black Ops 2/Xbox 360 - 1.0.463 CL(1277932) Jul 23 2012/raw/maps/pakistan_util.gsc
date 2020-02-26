#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_skipto;
#include maps\_scene;
#include maps\_turret;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
Flags
-------------------------------------------------------------------------------------------*/
init_flags()
{
	// section 1
	flag_init( "player_inside_sewer" );
	flag_init( "market_done" );
	flag_init( "brute_force_logic_done" );
	flag_init( "frogger_perk_active" ); 
	flag_init( "frogger_started" );
	flag_init( "frogger_done" );
	flag_init( "bus_started" );
	flag_init( "bus_dam_done" );
	flag_init( "pakistan_introscreen_show" );
	flag_init( "intruder_perk_used" );
	flag_init( "brute_force_perk_used" );
	flag_init( "lockbreaker_used" );
	flag_init( "player_hiding_underwater" );
	flag_init( "drone_attacks_player" );
	flag_init( "helicopter_dead" );
	
	// section 2
	flag_init( "anthem_grapple_complete" );
	flag_init( "anthem_voice_analysis_complete" );
	flag_init( "anthem_facial_recognition_complete" );
	flag_init( "anthem_guard_tower_reached" );
	flag_init( "anthem_surveillance_complete" );
	flag_init( "anthem_player_in_interference" );
	flag_init( "anthem_harper_start_tracking" );
	flag_init( "spotlight_jump_down_enter" );
	flag_init( "anthem_harper_drop" );
	flag_init( "anthem_harper_stand" );
	flag_init( "anthem_start_soldiers_exit" );
	flag_init( "rooftop_open_entrance" );
	flag_init( "rooftop_close_entrance" );
	flag_init( "rooftop_open_exit" );
	flag_init( "tower_melee_complete" );
	flag_init( "rooftop_meeting_harper_hide" );
	flag_init( "rooftop_meeting_harper_pursue" );
	flag_init( "rooftop_meeting_harper_slide" );
	flag_init( "rooftop_meeting_harper_observe" );
	flag_init( "rooftop_meeting_convoy_start" );
	flag_init( "drone_detection_end" );
	flag_init( "roof_meeting_defalco_identified" );
	flag_init( "railyard_melee_ready" );
	flag_init( "railyard_melee_start" );
	flag_init( "trainyard_melee_finished" );
	flag_init( "railyard_drone_meeting_room_entered" );
	flag_init( "railyard_train_enter" );
	flag_init( "railyard_drone_meeting_ready" );
	flag_init( "railyard_millibar_meeting_ready" );
	flag_init( "railyard_player_millibar_approach" );
	flag_init( "railyard_player_millibar_start" );
	flag_init( "railyard_harper_millibar_approach" );
	flag_init( "underground_millibar_on" );
	flag_init( "trainyard_elevator_escape_ready" );
	flag_init( "trainyard_elevator_escape_start" );
	flag_init( "claw_start_ready" );
	flag_init( "claw_start" );
	flag_init( "claw_pip_on" );
	flag_init( "claw_end" );
	flag_init( "claw_battle_end" );
	flag_init( "drone_player_detected" );
	flag_init( "garage_exited" );
	flag_init( "claw_suicide_target_reached" );
	flag_init( "claw2_obj1_reached" );
	flag_init( "claw2_obj2_reached" );
	flag_init( "claw_switch_done" );
	flag_init( "id_ready" );
	
	flag_init( "anthem_harper_vo_id" );
	flag_init( "anthem_harper_vo_surveillance" );
	flag_init( "anthem_harper_vo_interference" );
	flag_init( "anthem_harper_vo_take_cover" );
	flag_init( "anthem_harper_vo_drone_meeting_drone" );
	flag_init( "anthem_harper_vo_millibar_meeting_start" );
	flag_init( "rooftop_meeting_defalco_vo_start" );
	flag_init( "salazar_vo_claw_positioned" );
	flag_init( "millibar_vo_started" );
	flag_init( "millibar_vo_discovery" );
	flag_init( "claw_start_vo_done" );
	
	// section 3
	flag_init( "section_3_started" );
	flag_init( "vehicle_switched" );
	flag_init( "vehicle_switch_fade_in_started" );
	flag_init( "cannot_switch" );
	flag_init( "stop_drone_speed_control" );
	flag_init( "debug_di_blockade" );
	flag_init( "vehicle_can_switch" );
	flag_init( "player_cannot_get_hurt" );
	flag_init( "st_salazar_clear" );
	flag_init( "heli_crash_ready" );
	flag_init( "escape_bosses_end" );
}

/* ------------------------------------------------------------------------------------------
Objectives
-------------------------------------------------------------------------------------------*/
//	List all level objectives
setup_objectives()
{
	// section 1
	level.OBJ_INTERACT_LOCK_BREAKER			= register_objective( &"" );  // claw flamethrower!
	level.OBJ_INTERACT_BRUTE_FORCE			= register_objective( &"" );  // claw support during frogger!
	level.OBJ_INTERACT_INTRUDER				= register_objective( &"" );  // soc-t boost!
	level.OBJ_GET_TO_BASE					= register_objective( &"PAKISTAN_SHARED_OBJ_GET_TO_BASE" );
	level.OBJ_NAME2							= register_objective( &"pakistan_OBJ_NAME2" );
	level.OBJ_BUS_ESCAPE					= register_objective( &"" );  // hint only
	level.OBJ_HIDE							= register_objective( &"" );  // marker only

	// section 2
	level.OBJ_ID_MENENDEZ 					= register_objective( &"PAKISTAN_SHARED_OBJ_ID_MENENDEZ" );
	level.OBJ_RECORD_MENENDEZ				= register_objective( &"PAKISTAN_SHARED_OBJ_RECORD_MENENDEZ" );
	level.OBJ_SURVEIL_MENENDEZ				= register_objective( &"PAKISTAN_SHARED_OBJ_SURVEIL_MENENDEZ" );
	level.OBJ_CLEAR_RAILYARD                = register_objective( &"PAKISTAN_SHARED_OBJ_CLEAR_RAILYARD" );
	
	// section 3
	level.OBJ_ESCAPE						= register_objective( &"PAKISTAN_SHARED_OBJ_ESCAPE" );
	level.OBJ_BLOCKADE						= register_objective( &"PAKISTAN_SHARED_OBJ_BLOCKADE" );
	level.OBJ_EVAC_POINT					= register_objective( &"" );
	level.OBJ_EVAC							= register_objective( &"PAKISTAN_SHARED_OBJ_EVAC" );
	level.OBJ_RAM							= register_objective( &"" );
}

/* ------------------------------------------------------------------------------------------
Skipto Cleanup
-------------------------------------------------------------------------------------------*/
// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_cleanup()
{
	load_gumps_pakistan();
	
	// section 1
	if ( level.skipto_point == "intro" )
	{
		return;
	}
	
	if ( level.script == "pakistan" && !is_after_skipto( "dev_sewer_interior_no_perk" ) )
	{
		flag_set( "intro_anim_done" );  // can't reinitialize due to _scene system loading before _load::main; won't be set in pakistan_2 or pakistan_3
	}
	
	if ( ( level.skipto_point == "market" ) || ( level.skipto_point == "dev_market_perk" ) )
	{
		return;
	}
	
	if ( level.skipto_point == "car_smash" )
	{
		return;
	}
	
	if ( ( level.skipto_point == "market_exit" ) || ( level.skipto_point == "dev_market_exit_perk" ) || ( level.skipto_point == "dev_market_exit_no_perk" ) )
	{
		return;
	}
	
	flag_set( "market_done" );
	
	if ( level.script == "pakistan" )
	{
		frogger_set_dvars();
	}
	
	if ( ( level.skipto_point == "frogger" ) || ( level.skipto_point == "dev_frogger_claw_support" ) )
	{
		return;
	}
	
	if ( level.skipto_point == "bus_street" )
	{
		return;
	}
	
	if ( level.skipto_point == "bus_dam" )
	{
		return;
	}
	
	if ( level.skipto_point == "alley" )
	{
		return;
	}
	
	if ( level.skipto_point == "anthem_approach" )
	{
		return;
	}
		
	if ( level.skipto_point == "sewer_exterior" )
	{
		return;
	}
	
	if ( ( level.skipto_point == "sewer_interior" ) || ( level.skipto_point == "dev_sewer_interior_perk" ) || ( level.skipto_point == "dev_sewer_interior_no_perk" ) )
	{
		return;
	}
	
	// section 2	
	if ( level.skipto_point == "anthem" )
	{
		return;
	}
	
	if ( level.skipto_point == "roof_meeting" )
	{
		return;
	}
	
	if ( level.skipto_point == "claw" )
	{
		return;
	}
	
	// section 3
	if ( level.skipto_point == "escape_intro" )
	{
		return;
	}
	
	if ( level.skipto_point == "escape_battle" )
	{
		return;
	}
	
	if ( level.skipto_point == "escape_bosses" )
	{
		return;
	}
	
	if ( level.skipto_point == "warehouse" )
	{
		return;
	}
	
	if ( level.skipto_point == "hangar" )
	{
		return;
	}
	
	if ( level.skipto_point == "standoff" )
	{
		return;
	}
}

frogger_set_dvars()
{
	SetSavedDvar( "phys_ragdoll_buoyancy", 1 );  // enables ragdoll corpses to float	
	SetSavedDvar( "phys_maxFloatTime", 20000 ); // in ms. make buoyant objects float longer
	SetSavedDvar( "phys_buoyancyFloatHeightOffset", -2 );  // offsets how high objects should float out of the water
	
	wait_network_frame();
	level.player SetClientDvar( "dynEnt_spawnedLimit", 50 );  // normal limit = 50. Doesn't count ragdoll bodies or dyn ents in Radiant	
}

// Load the right gump for the skipto
load_gumps_pakistan()
{
	screen_fade_out( 0 );
	
	if ( level.script == "pakistan" )
	{
		if ( is_after_skipto( "market" ) )
		{
			// load 2nd gump
		}
		else
		{
			// load 1st gump
		}
	}
	else if ( level.script == "pakistan_2" )
	{
		if ( is_after_skipto( "roof_meeting" ) )
		{
			load_gump( "pakistan_2_gump_escape" );
		}
		else
		{
			load_gump( "pakistan_2_gump_anthem" );
		}
	}
	else if ( level.script == "pakistan_3" )
	{
		if ( is_after_skipto( "warehouse" ) )
		{
			load_gump( "pakistan_3_gump_escape_end" );
		}
		else if ( is_after_skipto( "escape_battle" ) )
		{
			load_gump( "pakistan_3_gump_escape" );
		}
		else
		{
			load_gump( "pakistan_3_gump_escape_intro" );
		}
	}
	
	screen_fade_in( 0 );
}

/* ------------------------------------------------------------------------------------------
Other Scripts for the Level
-------------------------------------------------------------------------------------------*/

//Wraps script for mission fail
mission_fail( str_dead_quote_ref )
{
	SetDvar( "ui_deadquote", str_dead_quote_ref );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}

//Sets up hud elements for identifying Menendez/Defalco
create_hud_id()
{
	hud_id["signal_indicator"] = NewHudElem();
	hud_id["signal_indicator"] SetText( "[ ]" );
	hud_id["signal_indicator"].horzAlign = "center";
	hud_id["signal_indicator"].vertAlign = "middle";
	hud_id["signal_indicator"].alignX = "center";
	hud_id["signal_indicator"].alignY = "middle";
	hud_id["signal_indicator"].y = -3;
	hud_id["signal_indicator"].font = "bigfixed";
	hud_id["signal_indicator"] thread hud_signal_indicator_blink();
	
	hud_id["scanning_label"] = NewHudElem();
	hud_id["scanning_label"] SetText( "SCANNING" );
	hud_id["scanning_label"].horzAlign = "center";
	hud_id["scanning_label"].vertAlign = "middle";
	hud_id["scanning_label"].alignX = "center";
	hud_id["scanning_label"].alignY = "middle";
	hud_id["scanning_label"].y = -23;
	hud_id["scanning_label"].x = 75;
	hud_id["scanning_label"].font = "bigfixed";
	
	hud_id["scan_bar"] = NewHudElem();
	hud_id["scan_bar"] SetText( ".    .    ." );
	hud_id["scan_bar"].horzAlign = "center";
	hud_id["scan_bar"].vertAlign = "middle";
	hud_id["scan_bar"].alignX = "center";
	hud_id["scan_bar"].alignY = "middle";
	hud_id["scan_bar"].y = -8;
	hud_id["scan_bar"].x = 75;
	hud_id["scan_bar"].font = "bigfixed";
	
	hud_id["voice_analysis_label"] = NewHudElem();
	hud_id["voice_analysis_label"] SetText( "VOICE ANALYSIS:" );
	hud_id["voice_analysis_label"].horzAlign = "center";
	hud_id["voice_analysis_label"].vertAlign = "middle";
	hud_id["voice_analysis_label"].alignX = "center";
	hud_id["voice_analysis_label"].alignY = "middle";
	hud_id["voice_analysis_label"].y = -58;
	hud_id["voice_analysis_label"].x = 79;
	hud_id["voice_analysis_label"].font = "big";
	
	hud_id["voice_analysis_status"] = NewHudElem();
	hud_id["voice_analysis_status"] SetText( "ACTIVE" );
	hud_id["voice_analysis_status"].horzAlign = "center";
	hud_id["voice_analysis_status"].vertAlign = "middle";
	hud_id["voice_analysis_status"].alignX = "center";
	hud_id["voice_analysis_status"].alignY = "middle";
	hud_id["voice_analysis_status"].y = -58;
	hud_id["voice_analysis_status"].x = 118;
	hud_id["voice_analysis_status"].font = "big";
	
	hud_id["facial_recognition_label"] = NewHudElem();
	hud_id["facial_recognition_label"] SetText( "FACIAL RECOGNITION:" );
	hud_id["facial_recognition_label"].horzAlign = "center";
	hud_id["facial_recognition_label"].vertAlign = "middle";
	hud_id["facial_recognition_label"].alignX = "center";
	hud_id["facial_recognition_label"].alignY = "middle";
	hud_id["facial_recognition_label"].y = -43;
	hud_id["facial_recognition_label"].x = 70;
	hud_id["facial_recognition_label"].font = "big";
	
	hud_id["facial_recognition_status"] = NewHudElem();
	hud_id["facial_recognition_status"] SetText( "READY" );
	hud_id["facial_recognition_status"].horzAlign = "center";
	hud_id["facial_recognition_status"].vertAlign = "middle";
	hud_id["facial_recognition_status"].alignX = "center";
	hud_id["facial_recognition_status"].alignY = "middle";
	hud_id["facial_recognition_status"].y = -43;
	hud_id["facial_recognition_status"].x = 118;
	hud_id["facial_recognition_status"].font = "big";
	
	return hud_id;
}

//Cleans up hud for identifying Menendez/Defalco
destroy_hud_id()
{
	self["signal_indicator"] notify( "hud_signal_indicator_destroy" );
	
	self["signal_indicator"] Destroy();
	self["scanning_label"] Destroy();
	self["scan_bar"] Destroy();
	self["voice_analysis_label"] Destroy();
	self["voice_analysis_status"] Destroy();
	self["facial_recognition_label"] Destroy();
	self["facial_recognition_status"] Destroy();
}

//Sets up hud elements for surveilling Menendez
create_hud_surveillance()
{
	hud_surveillance["signal_indicator"] = NewHudElem();
	hud_surveillance["signal_indicator"] SetText( "[ ]" );
	hud_surveillance["signal_indicator"].horzAlign = "center";
	hud_surveillance["signal_indicator"].vertAlign = "middle";
	hud_surveillance["signal_indicator"].alignX = "center";
	hud_surveillance["signal_indicator"].alignY = "middle";
	hud_surveillance["signal_indicator"].y = -3;
	hud_surveillance["signal_indicator"].font = "bigfixed";
	hud_surveillance["signal_indicator"].fontScale = 1.5;
	
	hud_surveillance["scanning_label"] = NewHudElem();
	hud_surveillance["scanning_label"] SetText( "RECORDING" );
	hud_surveillance["scanning_label"].horzAlign = "center";
	hud_surveillance["scanning_label"].vertAlign = "middle";
	hud_surveillance["scanning_label"].alignX = "center";
	hud_surveillance["scanning_label"].alignY = "middle";
	hud_surveillance["scanning_label"].y = -23;
	hud_surveillance["scanning_label"].x = 75;
	hud_surveillance["scanning_label"].font = "bigfixed";
	
	hud_surveillance["scan_bar"] = NewHudElem();
	hud_surveillance["scan_bar"] SetText( ".    .    ." );
	hud_surveillance["scan_bar"].horzAlign = "center";
	hud_surveillance["scan_bar"].vertAlign = "middle";
	hud_surveillance["scan_bar"].alignX = "center";
	hud_surveillance["scan_bar"].alignY = "middle";
	hud_surveillance["scan_bar"].y = -8;
	hud_surveillance["scan_bar"].x = 75;
	hud_surveillance["scan_bar"].font = "bigfixed";
	
	hud_surveillance["data_label"] = NewHudElem();
	hud_surveillance["data_label"] SetText( "DATA CAPTURED:" );
	hud_surveillance["data_label"].horzAlign = "center";
	hud_surveillance["data_label"].vertAlign = "middle";
	hud_surveillance["data_label"].alignX = "center";
	hud_surveillance["data_label"].alignY = "middle";
	hud_surveillance["data_label"].y = -42;
	hud_surveillance["data_label"].x = 66;
	hud_surveillance["data_label"].font = "big";
	hud_surveillance["data_label"].fontScale = 1.25;
	
	hud_surveillance["data_gathered"] = NewHudElem();
	hud_surveillance["data_gathered"].value = 0;
	hud_surveillance["data_gathered"] SetValue( hud_surveillance["data_gathered"].value );
	hud_surveillance["data_gathered"].horzAlign = "center";
	hud_surveillance["data_gathered"].vertAlign = "middle";
	hud_surveillance["data_gathered"].alignX = "center";
	hud_surveillance["data_gathered"].alignY = "middle";
	hud_surveillance["data_gathered"].y = -42;
	hud_surveillance["data_gathered"].x = 115;
	hud_surveillance["data_gathered"].font = "big";
	hud_surveillance["data_gathered"].fontScale = 1.25;
	
	hud_surveillance["data_units"] = NewHudElem();
	hud_surveillance["data_units"] SetText( "TB" );
	hud_surveillance["data_units"].horzAlign = "center";
	hud_surveillance["data_units"].vertAlign = "middle";
	hud_surveillance["data_units"].alignX = "center";
	hud_surveillance["data_units"].alignY = "middle";
	hud_surveillance["data_units"].y = -42;
	hud_surveillance["data_units"].x = 128;
	hud_surveillance["data_units"].font = "big";
	hud_surveillance["data_units"].fontScale = 1.25;
	
	return hud_surveillance;
}

//Cleans up hud for surveilling Menendez
destroy_hud_surveillance()
{
	self["signal_indicator"] Destroy();
	self["scanning_label"] Destroy();
	self["scan_bar"] Destroy();
	self["data_label"] Destroy();
	self["data_gathered"] Destroy();
	self["data_units"] Destroy();
}

//Makes hud indicator blink for id interface.
//Self is the hud indicator element
hud_signal_indicator_blink()
{
	self endon( "hud_signal_indicator_destroy" );
	
	self.blink = false;
	self.blinkSpeed = 2.0;
	str_interp_direction = "down";
	
	while( true )
	{
		while( self.blink )
		{	
			if( self.alpha == 0.0 )
			{
				str_interp_direction = "up";
				level.player thread play_sound_on_entity( "soundalias evt_pak_surv_cursor_beep" );
			}
			else if (self.alpha == 1.0)
			{
				str_interp_direction = "down";
			}
			
			//Full blink interps alpha from 1.0 to 0.0 and back to 1.0 (i.e. 2.0 total alpha change per blink).
			//Blink speed divided by frame time converts from seconds for full blink to frames. Total alpha change
			//per blink divided by frames per blink determines how much alpha change needed per frame at current
			//blink speed.
			n_alpha_step_size = 2.0 / (self.blinkSpeed / 0.05);
			
			if( str_interp_direction == "up" )
			{
				self.alpha = Min( self.alpha + n_alpha_step_size, 1.0 );
			}
			else
			{
				self.alpha = Max( self.alpha - n_alpha_step_size, 0.0 );
			}
			
			//Run max once per frame
			wait 0.05;
		}
		
		self.alpha = 1.0;
		
		//Run max once per frame
		wait 0.05;
	}
}

id_think( ai_target, n_view_angle_max, n_view_angle_min, wait_for_flag = false )
{
	level endon( "stop_id" );
	
	is_analyzing_voice_match = true;
	
	//Maximum player view angle from our target's position used for calculations.  Based on allowed head look when player linked at id position.
	n_player_view_angle_max = Cos( n_view_angle_max );
	
	//Minimum player view angle from our target's position.  At this angle or less the player has found Menendez.
	n_player_view_angle_min = Cos( n_view_angle_min );
	
	n_signal_indicator_blink_speed_max = 2.0;
	n_signal_indicator_blink_speed_step = n_signal_indicator_blink_speed_max / n_player_view_angle_min;
	n_signal_indicator_color_red_max = 1.0;
	n_signal_indicator_color_red_step = n_signal_indicator_color_red_max / n_player_view_angle_min;
	
	n_facial_recognition_time_start = undefined;
	
	level.hud_id = create_hud_id();
	level.hud_id["signal_indicator"].alpha = 1.0;
	level.hud_id["signal_indicator"].blink = true;
	level.hud_id["signal_indicator"].color = (n_signal_indicator_color_red_max, 1.0, 0.0);
	
	flag_clear( "anthem_facial_recognition_complete" );
	level.hud_id thread id_status_info_think();
	level.player thread play_sound_on_entity( "play evt_pak_surv_cursor_good" );
	
	if( !wait_for_flag )
	{
		flag_set( "id_ready" );
	}
	else
	{
		flag_clear( "id_ready" );
	}
	
	while( is_analyzing_voice_match )
	{
		//Find angle between direction player is looking and their position relative to our target. Closer it is to 0
		//the more closely the player is looking in the direction of our target.
		n_player_view_angle = level.player get_dot_direction( ai_target GetEye(), false, true, "forward", true );
		
		if( n_player_view_angle <= n_player_view_angle_min )
		{	
			if( flag( "anthem_voice_analysis_complete" ) )
			{
				flag_clear( "anthem_voice_analysis_complete" );
				n_facial_recognition_time_start = undefined;
				level notify( "stop_facial_recognition" );
				level.player notify( "stop soundevt_surv_scan_dude" );
				
				level.hud_id["scan_bar"] SetText( "           " );
				level.hud_id["scanning_label"] SetText( "SCANNING" );
				level.hud_id["scanning_label"].color = ( 0.5, 0.5, 0.0 );
				level.hud_id["facial_recognition_status"] SetText( "READY" );
				level.hud_id["facial_recognition_status"].color = ( 0.5, 0.5, 0.0 );
				level.hud_id thread id_status_info_think();
			}
			
			level.hud_id["signal_indicator"].blinkSpeed = n_signal_indicator_blink_speed_step * (1.0 - n_player_view_angle);
			level.hud_id["signal_indicator"].color = (n_signal_indicator_color_red_step * (1.0 - n_player_view_angle), 1.0, 0.0);
		}
		else if( flag( "id_ready" ) && !IsDefined( n_facial_recognition_time_start ) )
		{
			flag_set( "anthem_voice_analysis_complete" );
			level.player notify( "stop soundevt_surv_scanning_lp" );
			
			level.hud_id["signal_indicator"].color = ( 0.0, 1.0, 0.0 );
			level.hud_id["signal_indicator"].blink = false;
			level.hud_id thread launch_facial_recognition();
			
			n_facial_recognition_time_start = GetTime();
		}
		else if( flag( "id_ready" ) && GetTime() - n_facial_recognition_time_start >= 5000 )
		{
			is_analyzing_voice_match = false;
		}
		
		//Run max once per frame
		wait 0.05;
	}
}

stop_id()
{
	level notify( "stop_id" );
	level notify( "stop_facial_recognition" );
	
	level.player notify( "stop soundevt_surv_scanning_lp" );
	level.hud_id destroy_hud_id();
}

//HACK: Intended as a mock up to illustrate what's happening during the ID event.
id_status_info_think()
{	
	level endon( "stop_id" );
	
	self["scanning_label"].color = ( 1.0, 1.0, 0.0 );
	self["voice_analysis_status"].color = ( 0.0, 1.0, 0.0 );
	self["facial_recognition_status"].color = ( 1.0, 1.0, 0.0 );
	
	level.player thread play_loop_sound_on_entity( "evt_surv_scanning_lp" );
	level.player thread play_sound_on_entity( "evt_surv_startup" );
	
	while( !flag( "anthem_voice_analysis_complete" ) )
	{
		self["scan_bar"] SetText( ".          " );
		wait 0.1;
		self["scan_bar"] SetText( ".    .     " );
		wait 0.1;
		self["scan_bar"] SetText( ".    .    ." );
		wait 0.1;
		self["scan_bar"] SetText( "     .    ." );
		wait 0.1;
		self["scan_bar"] SetText( "          ." );
		wait 0.1;
	}
}

surveillance_think( ai_target )
{
	level endon( "stop_surveillance" );
	
	//Maximum angle between player view and Menendez position considered within line of sight
	n_los_angle_max = Cos( 12.0 );
	
	//Minimum angle between player view and Menendez position considered within line of sight
	n_los_angle_min = Cos( 3.0 );
	
	//Range of line of sight between max and min
	n_los_angle_range = n_los_angle_min - n_los_angle_max;
	
	//Maximum distance between player and Menendez
	n_dist_to_menendez_max = 2200.0;
	
	//Minimum distance between player and Menendez
	n_dist_to_menendez_min = 500.0;
	
	//Range of distance between min and max
	n_dist_to_menendez_range = n_dist_to_menendez_max - n_dist_to_menendez_min;
	
	//Angle increment per unit of distance between player and Menendez for interpolating line of sight
	n_los_angle_step = n_los_angle_range / n_dist_to_menendez_range;
	
	level.str_hud_current_state = "recording";
	
	level.hud_surveillance = create_hud_surveillance();
	level.hud_surveillance["signal_indicator"].color = ( 0.0, 1.0, 0.0 );
	level.hud_surveillance["scanning_label"].color = ( 0.0, 1.0, 0.0 );
	
	if( !IsDefined( level.recorded_data ) )
	{
		level.recorded_data = 0;
	}
	
	level.hud_surveillance["data_gathered"] SetValue( level.recorded_data );
	
	level.player thread play_sound_on_entity( "evt_pak_surv_cursor_starting" );
	level.hud_surveillance thread hud_surveillance_recording();
	init_interference_triggers();
	
	//TODO: C. Ayers: Change this client flag call to use a .gsh definition
	level.menendez SetClientFlag( 3 );
	
	while( true )
	{
		//Find angle between direction player is looking and their position relative to Menendez. Closer it is to 0
		//the more closely the player is looking in the direction of Menendez.
		n_player_view_angle = level.player get_dot_direction( ai_target GetEye(), false, true, "forward", true );
		
		//Angle between player view and Menendez's position considered line of sight adjusted for distance
		n_los_angle_constraint = n_los_angle_max + (n_los_angle_step * (Distance( level.player GetEye(), ai_target GetEye() ) - n_dist_to_menendez_min));
		n_los_angle_constraint = Min( n_los_angle_constraint, Cos( 0.5 ) );
		
		if( flag( "anthem_player_in_interference" ) )
		{
			if( level.str_hud_current_state != "interference" )
			{
				surveillance_state_change_cleanup( level.str_hud_current_state );
				level.hud_surveillance["signal_indicator"].color = ( 1.0, 1.0, 0.0 );
				level.hud_surveillance thread hud_surveillance_interference();
				level.str_hud_current_state = "interference";
				level clientnotify( "surv_OFF" );
			}
		}
		else if( is_menendez_los( n_player_view_angle, n_los_angle_constraint ) )
		{	
			if( level.str_hud_current_state != "recording" )
			{
				surveillance_state_change_cleanup( level.str_hud_current_state );
				level.hud_surveillance["signal_indicator"].color = ( 0.0, 1.0, 0.0 );
				level.hud_surveillance thread hud_surveillance_recording();
				level.str_hud_current_state = "recording";
				level clientnotify( "surv_ON" );
			}
		}
		else
		{
			if( level.str_hud_current_state != "no target" )
			{
				surveillance_state_change_cleanup( level.str_hud_current_state );
				level.hud_surveillance["signal_indicator"].color = ( 1.0, 0.0, 0.0 );
				level.hud_surveillance thread hud_surveillance_no_target();
				level.str_hud_current_state = "no target";
				level clientnotify( "surv_OFF" );
			}
		}
		
		//Run max once per frame
		wait 0.05;
	}
}

stop_surveillance()
{
	level notify( "stop_surveillance" );
	//TODO: C. Ayers: Change this client flag call to use a .gsh definition
	level.menendez ClearClientFlag( 3 );
	surveillance_state_change_cleanup( level.str_hud_current_state );
	level.player notify( "anthem_surveillance_complete" );
	level.hud_surveillance destroy_hud_surveillance();
}

surveillance_state_change_cleanup( str_hud_current_state )
{
	level notify( "hud_surveillance_state_change" );
	
	switch( str_hud_current_state )
	{
		case "interference":
			level.player stop_loop_sound_on_entity( "evt_pak_surv_interference_lp" );
			break;
		case "no target":
			level.player stop_loop_sound_on_entity( "evt_pak_surv_notarget_lp" );
			break;
	}
}

is_menendez_los( n_player_view_angle, n_los_angle_constraint )
{
	v_trace_pos = BulletTrace( level.player GetEye(), level.menendez GetEye(), false, level.player, true, true )["position"];
	
	if( n_player_view_angle > n_los_angle_constraint && v_trace_pos == level.menendez GetEye() )
	{
		return true;
	}
	else
	{
		return false;
	}
}

//HACK: Handles hud logic for recording state
hud_surveillance_recording()
{
	level endon( "hud_surveillance_state_change" );
	
	self["scanning_label"] SetText( "RECORDING" );
	self["scanning_label"].color = ( 0.0, 1.0, 0.0 );
	self["scanning_label"].alpha = 1.0;

	level.player thread play_sound_on_entity( "evt_pak_surv_cursor_good" );
	
	while( true )
	{
		level.recorded_data = level.recorded_data + 2;
		self["data_gathered"] SetValue( level.recorded_data );
		
		self["scan_bar"] SetText( ".          " );
		wait 0.1;
		self["scan_bar"] SetText( ".    .     " );
		wait 0.1;
		self["scan_bar"] SetText( ".    .    ." );
		wait 0.1;
		self["scan_bar"] SetText( "     .    ." );
		wait 0.1;
		self["scan_bar"] SetText( "          ." );
		wait 0.1;
	}
}

//HACK: Handles hud logic for interference state
hud_surveillance_interference()
{
	level endon( "hud_surveillance_state_change" );
	
	self["scanning_label"] SetText( "INTERFERENCE" );
	self["scanning_label"].color = ( 1.0, 1.0, 0.0 );
	self["scanning_label"].alpha = 1.0;
	self["scan_bar"] SetText( ".    .    ." );
	
	level.player thread play_sound_on_entity( "evt_pak_surv_cursor_bad" );
	level.player thread play_loop_sound_on_entity( "evt_pak_surv_interference_lp" );
	
	while( true )
	{
		wait 0.05;
	}
}

//HACK: Handles hud logic for no target state
hud_surveillance_no_target()
{
	level endon( "hud_surveillance_state_change" );
	
	self["scanning_label"] SetText( "NO TARGET" );
	self["scanning_label"].color = ( 1.0, 0.0, 0.0 );
	self["scan_bar"] SetText( "           " );
	str_blink_interp_direction = "down";

	level.player thread play_sound_on_entity( "evt_pak_surv_cursor_bad" );
	level.player thread play_loop_sound_on_entity( "evt_pak_surv_notarget_lp" );
	
	while( true )
	{
		if( self["scanning_label"].alpha == 0.0 )
		{
			str_blink_interp_direction = "up";
		}
		else if( self["scanning_label"].alpha == 1.0 )
		{
			str_blink_interp_direction = "down";
		}
		
		if( str_blink_interp_direction == "up" )
		{
			self["scanning_label"].alpha = self["scanning_label"].alpha + 0.1;
		}
		else if( str_blink_interp_direction == "down" )
		{
			self["scanning_label"].alpha = self["scanning_label"].alpha - 0.1;
		}
		
		wait 0.05;
	}
}

//Sets up triggers for interference system during surveillance event
init_interference_triggers()
{
	array_thread( GetEntArray( "sound_interference_trigger", "targetname" ), ::interference_trigger_think );
}

//Listens for players activating interference triggers
interference_trigger_think()
{
	level endon( "anthem_surveillance_complete" );
	
	while( true )
	{
		self waittill( "trigger" );
		self thread trigger_thread( level.player, ::push_interference_trigger, ::pop_interference_trigger );
	}
}

//Pushes a newly activated interference trigger onto the stack
push_interference_trigger( ent, endon_string )
{
	flag_set( "anthem_player_in_interference" );
	
	if( !IsDefined( level.a_interference_trigger_stack ) )
	{
		level.a_interference_trigger_stack = [];
	}
	
	level.a_interference_trigger_stack[level.a_interference_trigger_stack.size] = self;
}

//Pops previously activated interference triggers off the stack
pop_interference_trigger( ent )
{
	ArrayRemoveValue( level.a_interference_trigger_stack, self );
	
	if( level.a_interference_trigger_stack.size == 0 )
	{
		flag_clear( "anthem_player_in_interference" );
	}
}

//Run on HUD array for facial recognition state
launch_facial_recognition()
{
	level endon( "stop_facial_recognition" );
	
	self["scan_bar"] SetText( "           " );
	self["scanning_label"] SetText( "ANALYZING" );
	self["scanning_label"].color = ( 0.0, 1.0, 0.0 );
	self["facial_recognition_status"] SetText( "ACTIVE" );
	self["facial_recognition_status"].color = ( 0.0, 1.0, 0.0 );
	
	level.player thread play_sound_on_entity( "evt_pak_surv_cursor_starting" );
	level.player thread play_loop_sound_on_entity( "evt_surv_scan_dude" );
	
	wait 1.0;
	self["scan_bar"] SetText( ".          " );
	wait 1.0;
	self["scan_bar"] SetText( ".    .     " );
	wait 1.0;
	level.player notify( "stop soundevt_surv_scan_dude" );
	level.player thread play_sound_on_entity( "evt_surv_scan_affirm" );
	self["scan_bar"] SetText( ".    .    ." );
	wait 2.0;
	
	self destroy_hud_id();
	flag_set( "anthem_facial_recognition_complete" );
}

run_anim_to_idle( str_start_scene, str_idle_scene )
{
	run_scene( str_start_scene );
	self thread run_scene( str_idle_scene );
}

run_anim_on_flag( str_flag, str_scene_name )
{
	flag_wait( str_flag );
	
	self run_scene( str_scene_name );
}

// prints only when a dvar is active and in dev executable
debug_print_line( str_text )
{
	/#
	str_val = GetDvar( "pakistan_debug" );
	if ( IsDefined( str_val ) && ( str_val != "" ) )
	{
		iprintln( str_text );
	}
	#/
}

spotlight_search_path( e_start_pos, n_speed = 384, do_face = false, do_loop = true, e_target = undefined )
{
	self endon( "stop_searching" );
	
	e_current_pos = e_start_pos;
	e_previous_pos = undefined;
	
	if( !IsDefined( e_target ) )
	{
		e_target = Spawn( "script_origin", e_current_pos.origin );
	}
	
	n_target_time = Distance2DSquared( e_target.origin, e_current_pos.origin ) / (n_speed * n_speed);
	
	if( n_target_time <= 0 )
	{
		n_target_time = 0.05;
	}
	
	if( do_face )
	{
		self SetLookAtEnt( e_target );
	}
	
	self set_turret_target( e_target, undefined, 0 );
	
	while( true )
	{	
		e_target MoveTo( e_current_pos.origin, n_target_time );
		e_target waittill( "movedone" );
		
		if( IsDefined( e_current_pos.script_int ) )
		{
			wait e_current_pos.script_int;
		}
		
		if( IsDefined( e_current_pos.target ) )
		{
			e_previous_pos = e_current_pos;
			e_current_pos = GetEnt( e_current_pos.target, "targetname" );
		}
		else if( do_loop )
		{
			e_previous_pos = e_current_pos;
			e_current_pos = e_start_pos;
		}
		else
		{
			break;
		}
		
		n_target_time = Distance2DSquared( e_previous_pos.origin, e_current_pos.origin ) / (n_speed * n_speed);
		wait 0.05;
	}
	
	self notify( "search_done" );
}

// gets trigger, then waits for it to be triggered; if player can see trigger location, play fx anim (and run optional function)
play_fx_anim_on_trigger( str_targetname, str_notify, func_on_notify )
{
	t_fx_anim = get_ent( str_targetname, "targetname", true );
	
	b_is_damage_trigger = ( t_fx_anim.classname == "trigger_damage" );
	
	const n_dot = 0.7;
	b_trace = true;
	
	b_played_fx_anim = false;
	while ( !b_played_fx_anim )
	{
		t_fx_anim trigger_wait();  // not waiting for trigger notify since 'look' flag will send multiple times
		
		// check if player is looking if it's not a damage trigger; otherwise just play it (all other triggers)
		b_should_play_anim = ( !b_is_damage_trigger ) || ( level.player is_looking_at( t_fx_anim, n_dot, b_trace ) );
		
		if ( b_should_play_anim )
		{
			level notify( str_notify );  // start fx anim
			debug_print_line( str_targetname + " sending level notify: " + str_notify );
			b_played_fx_anim = true;
			
			// if optional function exists, run it now
			if ( IsDefined( func_on_notify ) )
			{
				self thread [[ func_on_notify ]](); 
			}
		}
	}
	
	// 'look' triggers may be targeting origin; clean that up too
	if ( IsDefined( t_fx_anim.target ) )
	{
		e_lookat_target = get_ent( t_fx_anim.target, "targetname" );
		
		if ( IsDefined( e_lookat_target ) )
		{
			e_lookat_target Delete();	
		}		
	}	
	
	t_fx_anim Delete(); // clean up trigger
}

is_underwater()
{
	return self._swimming.is_underwater;
}

run_swimming_sheeting()
{
	// how long to show sheeting after coming out of water.
	const sheeting_time_s = 3.0;
	
	assert( isdefined(self._swimming), "must first call _swimming::main" );
	if ( !isdefined( self._swimming ) )
	{
		return;
	}
	
	while ( true )
	{
		// pluhr got into water
		while ( !( self is_underwater() ) )
		{
			wait 1.0;
		}
		
		// pluhr got out of water.
		while ( self is_underwater() )
		{
			wait 0.5;
		}
		
		// show the sheeting.
		self SetWaterSheeting( 1, sheeting_time_s );
		self SetWaterDrops( 50 );
		
		// wait x time or until the player starts swimming again
		time_waited_s = 0.0;
		while ( time_waited_s < sheeting_time_s && !(self is_underwater()) )
		{
			wait 0.5;
			time_waited_s += 0.5;
		}
		
		// hide water drops.
		self SetWaterDrops( 0 );
	}
}

watch_player_rain_water_sheeting()
{	
	level.b_turn_off_sheeting_already_running = false;
	
	while( 1 )
	{
		trigger = trigger_wait( "water_sheeting_trigger" );

		level.player SetWaterSheeting( 1 );
		level.player SetWaterDrops( 50 );
		
		if( !level.b_turn_off_sheeting_already_running )
		{
			trigger thread watch_to_turn_off_water_sheeting();
			level.b_turn_off_sheeting_already_running = true;
		}
		
		wait 1;
	}
}

watch_to_turn_off_water_sheeting()
{
	while( level.player IsTouching( self ) )
	{
		wait 0.05;
	}
	
	level.b_turn_off_sheeting_already_running = false;
	level.player SetWaterSheeting( 0 );
	level.player SetWaterDrops( 0 );
}
