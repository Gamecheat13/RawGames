#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scoreevents_shared;


#using scripts\cp\_objectives;
#using scripts\cp\_scoreevents;

#using scripts\cp\gametypes\_persistence;
#using scripts\cp\gametypes\_globallogic;

#using scripts\cp\sidemissions\_sm_zone_mgr;
#using scripts\cp\sidemissions\_sm_ui;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       


	
#precache( "string", "COOP_SMUI_MISSION_COMPLETE" );
#precache( "string", "COOP_SMUI_MISSION_FAILED" );

#namespace sidemission_type_base;

class cSideMissionBase
{
	var m_a_str_vo_hints;
	
	constructor()
	{
		m_a_str_vo_hints = [];
		
//		level thread watch_respawn_notify();
		level thread _wait_for_completion();
	}
	
	destructor()
	{
		
	}
	
	// Call when the sidemission ends in success
	function sidemission_success()
	{		
		level notify ( "sidemission_objective_complete", true );
	}
	
	// Call when the sidemission ends in failure
	function sidemission_fail( str_reason )
	{
		level notify ( "sidemission_objective_complete", false, str_reason );	
	}
	
	function _wait_for_completion()
	{
		level.gameEndMessage1 = &"COOP_SMUI_MISSION_FAILED";
		level.gameEndMessage2 = undefined;
		
		level waittill( "sidemission_objective_complete", b_success, str_reason );
		
		sm_ui::temp_vo_kill_all();
		sm_ui::hud_objective_remove_all();
		
		if ( b_success )
		{
			level.gameEndMessage1 = &"COOP_SMUI_MISSION_COMPLETE";
			
			for ( index = 0; index < level.players.size; index++ )
			{
				level.players[index] persistence::set_after_action_report_stat( "matchWon", 1 );
			}
		}
		else
		{
			level.gameEndMessage2 = str_reason;
			for ( index = 0; index < level.players.size; index++ )
			{
				level.players[index] persistence::set_after_action_report_stat( "matchWon", 0 );
			}
		}
		
		globallogic::endGame( "allies", str_reason );
	}
	
	function show_mission_complete( e_player, str_msg )
	{
		complete_elem = e_player sm_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, 0, 3.0, (1.0,1.0,1.0) );
		complete_elem SetText(str_msg);
		
		wait 5.0;
		
		complete_elem Destroy();
	}
	
	// SideMission-specific spawn locations (for enemies and objects) should be placed by structs with the
	// 		targetname of "sm_location".
	function get_structs_for_sm_element( str_raidelement )
	{
		a_structs = struct::get_array( "sm_location", "targetname" );
		
		a_sm_structs = [];
		
//		level flag::wait_till( "zones_initialized" );
		
		foreach ( struct in a_structs )
		{
			Assert( IsDefined( struct.script_string ), "cSideMissionBase: script_string missing on sm_location struct at " + struct.origin );
			
//			get_zone_from_position( struct );
			
			if ( IsInArray( StrTok( struct.script_string, " " ), str_raidelement ) )
			{
// TODO: uncomment the if check, removed while sidemission maps are zoned
//				if ( !IsDefined( struct.zone ) || zone_mgr::zone_is_enabled( struct.zone ) )
//				{
					if ( !isdefined( a_sm_structs ) ) a_sm_structs = []; else if ( !IsArray( a_sm_structs ) ) a_sm_structs = array( a_sm_structs ); a_sm_structs[a_sm_structs.size]=struct;;
//				}
			}
		}
		
//		/#
//			str_forced_section = GetDvarString( "raid_force_objective_section" );
//			if ( IsDefined( str_forced_section ) && zone_mgr::is_valid_section( str_forced_section ) )
//			{
//				a_sm_structs = get_sm_locations_in_section( str_forced_section, str_raidelement );
//			}
//		#/
		
		return a_sm_structs;
	}
	
	function get_sm_locations_in_section( str_section, str_type )
	{
		Assert( IsDefined( str_section ), "get_sm_locations_in_section() requires str_section input!" );
		
		a_structs = struct::get_array( "sm_location", "targetname" );
		a_found = [];
		
		level flag::wait_till( "zones_initialized" );
		
		foreach ( struct in a_structs )
		{
			get_zone_from_position( struct );
			
			if ( zone_mgr::is_zone_in_section( struct.zone, str_section ) )
			{
				if ( !IsDefined( str_type ) || ( ToLower( str_type ) == ToLower( struct.script_string ) ) )  // using ToLower for objectives like HVT
				{
					array::add( a_found, struct, false );
				}
			}
		}
		
		return a_found;
	}
	
	function get_zone_from_position( struct )
	{
		if ( !IsDefined( struct.zone ) )
		{
			struct.zone = zone_mgr::get_zone_from_position( struct.origin + ( 0, 0, 5 ), true );
			
			Assert( IsDefined( struct.zone ), "cSideMissionBase: zone could not be found for '" + struct.script_string + "' raid loc struct at origin " + struct.origin );
		}
	}
	
	function get_area_name_from_point( v_point )
	{
		s_center = struct::get( "map_centerpoint" );
		v_north = AnglesToForward( s_center.angles );
		v_east = AnglesToRight( s_center.angles );
		v_center = s_center.origin;
		
		n_center_size_sq = s_center.radius * s_center.radius;
		
		if ( Distance2DSquared( v_point, v_center ) < n_center_size_sq )
		{
			return "the center building";
		} else {
			n_east_amt = VectorDot( v_point - v_center, v_east );
			n_north_amt = VectorDot( v_point - v_center, v_north );
			if ( abs( n_east_amt ) > abs( n_north_amt ) )
			{
				if ( n_east_amt > 0 )
				{
					return "the food court";
				} else {
					return "the carousel";
				}
			} else {
				if ( n_north_amt > 0 )
				{
					return "the movie theater";
				} else {
					return "the subway";
				}
			}
		}
	}
	
//--------------------------------------------------------------------------------------------------------
// Reach SM Location objective

	function objective_reach_space( str_loc_name, s_goto_struct, v_offset )
	{
		assert( IsDefined( str_loc_name ), "The name of the location for the Side Mission must be passed in to cSideMissionBase::objective_reach_space()" );
		assert( IsDefined( s_goto_struct ), "struct must be passed in to cSideMissionBase::objective_reach_space() to mark where the distance waypoint is placed" );
		assert( IsDefined( s_goto_struct.radius ), "The struct passed into cSideMissionBase::objective_reach_space() must have .radius defined" );
		
		n_reach_obj_id = sm_ui::hud_objective_register( "Reach " + str_loc_name );
		sm_ui::hud_objective_set( n_reach_obj_id );		
		
		v_pos = ( IsDefined( v_offset ) ? s_goto_struct.origin + v_offset : s_goto_struct.origin );
		
		hud_waypoint = sm_ui::create_objective_waypoint( "waypoint_targetneutral", v_pos, 0 );
		hud_waypoint SetWayPoint( true, "waypoint_targetneutral", true, false );
		
		is_near = false;
		while ( !is_near )
		{
			foreach ( player in level.players )
			{
				if ( DistanceSquared( v_pos, player.origin ) < (s_goto_struct.radius * s_goto_struct.radius) )
				{
					is_near = true;
					break;
				}
				
				util::wait_network_frame();
			}
			
			util::wait_network_frame();
		}

		hud_waypoint Destroy();
		sm_ui::hud_objective_complete( n_reach_obj_id );
	}
	
//--------------------------------------------------------------------------------------------------------
// TODO: remove this from the base object and create as its own
// Interact Logic (progress bar attached to an action)

	function wait_for_interact( t_use_trig, str_hint_string, n_interact_time, str_score_event, str_halfway_vo, str_start_vo, str_interact_sound_type )
	{
		t_use_trig SetHintString( str_hint_string );
		progress_bar = undefined;
		sndEnt = undefined;
		
		while ( true )
		{
			t_use_trig waittill( "trigger", e_triggerer );
			
			if( isdefined( str_start_vo ) )
			{
				e_triggerer PlaySoundToPlayer( str_start_vo, e_triggerer );
			}
			
			if( isdefined( str_interact_sound_type ) )
			{
				if( !isdefined( sndEnt ) )
				{
					sndEnt = spawn( "script_origin", t_use_trig.origin );
				}
				t_use_trig playsound( "evt_interact_" + str_interact_sound_type + "_start" );
				sndEnt playloopsound( "evt_interact_" + str_interact_sound_type + "_loop" );
			}
			
			foreach ( player in level.players )
			{
				if ( player != e_triggerer )
				{
					t_use_trig SetHintStringForPlayer( player, "Already in use by " + e_triggerer.name );
				}
			}
			
			b_distance_failure = false;
			n_planting_time = 0;
			
			while( n_planting_time < n_interact_time && e_triggerer UseButtonPressed() && Distance2DSquared( t_use_trig.origin, e_triggerer.origin ) < (64 * 64) )
			{
				n_planting_time += 0.05;
				
				if( !IsDefined( progress_bar ) )
				{
					progress_bar = e_triggerer hud::createPrimaryProgressBar();
					progress_bar thread _interact_bar_update( n_interact_time );
					e_triggerer DisableWeapons();
				}
				
				if ( IsDefined( str_halfway_vo ) )
				{
					if ( n_planting_time > (0.5 * n_interact_time ) )
					{
						sm_ui::temp_vo( str_halfway_vo );
						str_halfway_vo = undefined;
					}
				}
				
				t_use_trig notify( "interacting", n_planting_time / n_interact_time );
				
				{wait(.05);};
			}
			
			e_triggerer EnableWeapons();
			
			if ( isdefined(progress_bar) )
			{
				progress_bar notify( "kill_bar" );
				progress_bar hud::destroyElem();
			}
			
			if ( n_planting_time >= n_interact_time )
			{
				if ( IsDefined( str_score_event ) )
				{
					scoreevents::processScoreEvent( str_score_event, e_triggerer );
				}
				
				if( isdefined( str_interact_sound_type ) )
				{
					t_use_trig playsound( "evt_interact_" + str_interact_sound_type + "_end" );
					
					if( isdefined( sndEnt ) )
					{
						sndEnt delete();
						sndEnt = undefined;
					}
				}
				break;
			}
			else
			{
				foreach ( player in level.players )
				{
					t_use_trig SetHintStringForPlayer( player, str_hint_string );
				}
			}
		}
		
		t_use_trig SetHintString( "" );
	}
	
	function _interact_bar_update( n_interact_time )
	{
		self endon( "kill_bar" );
		self hud::updateBar( 0.01, 1 / n_interact_time  );
	}
}

function clear_jumpto()
{
	/#
	level.sm_a_v_jumpto_origin = undefined;
	level.sm_a_v_jumpto_angles = undefined;
	#/
}

function set_jumpto( v_origin, str_debug_command )
{
	/#
	
	while ( !IsDefined( level.players ) || level.players.size == 0 )
	{
		wait ( 1 );
	}
	
	// DevGui Option
	//--------------
	if ( IsDefined( str_debug_command ) )
	{		
		AddDebugCommand( "devgui_cmd \"Sidemission/Objective:2/Jumpto:2/" + str_debug_command + "\" \"set sidemission_jumpto " + str_debug_command + "\" \n" );
	}
	
	// Find Best Points Around Objective
	//----------------------------------
	n_radius = 128;
	n_angular_interval = 12;
	n_angular_shift = 0;
	n_radius_vec = ( 0, n_radius, 0 );
	
	if ( !IsDefined( level.sm_a_v_jumpto_origin ) )
	{
		level.sm_a_v_jumpto_origin[ 0 ][ 0 ] = 0;
		level.sm_a_v_jumpto_angles[ 0 ][ 0 ] = 0;
		
		level.sm_a_n_jumpto_current = [];
	}
	
	n_current_jumpto = 0;
	was_just_created = false;
	
	if ( !IsDefined( level.sm_a_v_jumpto_origin[ str_debug_command ] ) || !IsDefined( level.sm_a_v_jumpto_origin[ str_debug_command ][ n_current_jumpto ] ) )
	{
		level.sm_a_v_jumpto_origin[ str_debug_command ][ n_current_jumpto ] = 0;
		was_just_created = true;
	}
	
	while ( IsDefined( level.sm_a_v_jumpto_origin[ str_debug_command ][ n_current_jumpto ] ) && !( isdefined( was_just_created ) && was_just_created ) )
	{
		n_current_jumpto++;
	}
	
	a_v_jumpto_origins = [];
	a_v_jumpto_angles = [];
	
	while ( a_v_jumpto_origins.size < level.players.size )
	{
		rotated_vec = RotatePoint( n_radius_vec, ( 0, n_angular_shift, 0 ) );
		n_angular_shift += n_angular_interval;

		if ( n_angular_shift >= 360 )
		{
			n_angular_shift = 0;
		}

		v_origin_test = ( v_origin + rotated_vec );		
		trace = BulletTrace( v_origin_test, v_origin_test + ( 0, 0, -999 ), false, undefined );
		
		v_origin_jumpto = trace[ "position" ];

		if ( BulletTracePassed( v_origin, v_origin_jumpto + ( 0, 0, 32 ), true, undefined ) // Can See
					&& abs( v_origin[ 2 ] - v_origin_jumpto[ 2 ] ) < 64 ) // Within Player Height
		{			
			if ( !isdefined( a_v_jumpto_origins ) ) a_v_jumpto_origins = []; else if ( !IsArray( a_v_jumpto_origins ) ) a_v_jumpto_origins = array( a_v_jumpto_origins ); a_v_jumpto_origins[a_v_jumpto_origins.size]=v_origin_jumpto;;
			if ( !isdefined( a_v_jumpto_angles ) ) a_v_jumpto_angles = []; else if ( !IsArray( a_v_jumpto_angles ) ) a_v_jumpto_angles = array( a_v_jumpto_angles ); a_v_jumpto_angles[a_v_jumpto_angles.size]=( 0, VectorToAngles( v_origin - v_origin_jumpto )[1], 0 );;
		}
		
		if ( n_angular_shift == 0 )
		{
			// Did full rotation and didn't find valid points
			foreach ( index, player in level.players )
			{
				if ( !isdefined( a_v_jumpto_origins ) ) a_v_jumpto_origins = []; else if ( !IsArray( a_v_jumpto_origins ) ) a_v_jumpto_origins = array( a_v_jumpto_origins ); a_v_jumpto_origins[a_v_jumpto_origins.size]=v_origin + ( 0, 0, index * 64 );;
				if ( !isdefined( a_v_jumpto_angles ) ) a_v_jumpto_angles = []; else if ( !IsArray( a_v_jumpto_angles ) ) a_v_jumpto_angles = array( a_v_jumpto_angles ); a_v_jumpto_angles[a_v_jumpto_angles.size]=( 0, 0, 0 );;			
			}
			
			break;
		}

		{wait(.05);};
	}
	
	level.sm_a_v_jumpto_origin[ str_debug_command ][ n_current_jumpto ] = a_v_jumpto_origins;
	level.sm_a_v_jumpto_angles[ str_debug_command ][ n_current_jumpto ] = a_v_jumpto_angles;
	
	#/
}
