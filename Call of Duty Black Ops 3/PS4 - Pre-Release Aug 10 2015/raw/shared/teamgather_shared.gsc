
#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace teamgather;






	// 2

#precache( "triggerstring", "TEAM_GATHER_HOLD_FOR_TEAM_ENTER" );
#precache( "string", "TEAM_GATHER_TEAM_STEALTH_ENTER" );
#precache( "string", "TEAM_GATHER_PLAYERS_READY" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_1" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_2" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_3" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_4" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_5" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_6" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_7" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_8" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_9" );
#precache( "string", "TEAM_GATHER_TIME_REMAINING_10" );
#precache( "string", "TEAM_GATHER_TEAM_EVENT_ABORTED" );
#precache( "string", "TEAM_GATHER_PLAYER_STARTING_EVENT" );
#precache( "string", "TEAM_GATHER_NUM_PLAYERS" );
#precache( "string", "TEAM_GATHER_HOLD_TO_GO_NOW" );
#precache( "string", "TEAM_GATHER_GATHER_SUCCESS" );
#precache( "string", "TEAM_GATHER_START_IN_1" );
#precache( "string", "TEAM_GATHER_START_IN_2" );
#precache( "string", "TEAM_GATHER_START_IN_3" );
#precache( "string", "TEAM_GATHER_START_IN_4" );
#precache( "string", "TEAM_GATHER_START_IN_5" );
#precache( "string", "TEAM_GATHER_START_IN_6" );
#precache( "string", "TEAM_GATHER_START_IN_7" );
#precache( "string", "TEAM_GATHER_START_IN_8" );
#precache( "string", "TEAM_GATHER_START_IN_9" );
#precache( "string", "TEAM_GATHER_START_IN_10" );

	// 42*4

	// 10




	// "t7_hud_waypoints_beacon"
	// "t7_hud_minimap_beacon_key"

#precache( "material", "T7_hud_prompt_press_64" );
#precache( "material", "T7_hud_prompt_press_64" );

//#precache( "fx", "_t6/misc/fx_ui_flagbase_pmc" );



//*****************************************************************************
//*****************************************************************************

class cTeamGather
{
	var e_gameobject;

	var	n_font_scale;
	var	v_font_color;

	var	m_gather_fx;
	
	var m_e_interact_entity;

	var	m_teamgather_complete;
	var	m_success;

	var m_num_players;
	var	m_num_players_ready;
	
	var m_v_interact_position;
	var m_v_interact_angles;
	
	var	m_v_gather_position;
	
	var	m_e_player_leader;			// Player who started the teamgather event
	
	constructor()
	{
		e_gameobject = undefined;
		n_font_scale = 2.0;
		v_font_color = ( 1.0, 1.0, 1.0 );

		m_teamgather_complete = false;

		m_num_players = 0;
		m_num_players_ready = 0;
		
		m_gather_fx = undefined;

		m_teamgather_complete = false;
		m_success = false;
	}

	destructor()
	{
	}

	//*******************************************************
	//*******************************************************
	function cleanup()
	{
		cleanup_floor_effect();
		e_gameobject gameobjects::destroy_object( true, true );
	}

	//*******************************************************
	//*******************************************************
	function create_teamgather_event( v_interact_pos, v_interact_angles, v_gather_pos, e_interact_entity )
	{
		m_v_interact_position = v_interact_pos;
		m_v_interact_angles = v_interact_angles;

		m_e_interact_entity = e_interact_entity;

		m_v_gather_position = v_gather_pos;
		
		// Create the interact gameobject
		e_gameobject = setup_gameobject( v_interact_pos, undefined, &"TEAM_GATHER_HOLD_FOR_TEAM_ENTER", m_e_interact_entity );
		e_gameobject.c_teamgather = self;

		// Wait for the interact to be triggered by a player
		e_gameobject waittill( "player_interaction" );

		// Disable the interaction gameobject
		e_gameobject gameobjects::disable_object();
		
		// Add Team Action Advertisement over the door

		// Change color of the door

		// Spawn the indicator effect on the ground
		spawn_floor_effect();

		// Highlight Interact Entity - ON
		interact_entity_highlight( true );

		// MAIN - Wait for the results of the gather, BLOCKING
		b_success = gather_players();
		
		// End - Cleanup gather effect on the floor
		cleanup_floor_effect();

		// Highlight Interact Entity - OFF
		interact_entity_highlight( false );

		// How did it go?
		if( ( isdefined( b_success ) && b_success ) )
		{
			teamgather_success();
		}
		else
		{
			teamgather_failure();
		}

		return( b_success );
	}

	//*******************************************************
	//*******************************************************
	function teamgather_success()
	{
		if( (0) > 0 )
		{
			x_off = 0;
			y_off = 180;
			a_players = get_players_playing();

			for( i=0; i<a_players.size; i++ )
			{
				e_player = a_players[i];
				e_player.success_hud_elem = e_player __create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, &"TEAM_GATHER_GATHER_SUCCESS" );
			}
		
			wait( (0) );

			for( i=0; i<a_players.size; i++ )
			{
				e_player = a_players[i];
				e_player.success_hud_elem Destroy();
			}
		}
	}

	//*******************************************************
	//*******************************************************
	function teamgather_failure()
	{
		x_off = 0;
		y_off = 180;
		a_players = get_players_playing();

		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			e_player.failure_hud_elem = e_player __create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, &"TEAM_GATHER_TEAM_EVENT_ABORTED" );
		}
		
		wait( (0) );

		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			e_player.failure_hud_elem Destroy();
		}
	}

	//*******************************************************
	//*******************************************************
	function setup_gameobject( v_pos, STR_MODEL, STR_USE_HINT, e_los_ignore_me )
	{
		n_radius = 48;

		// Setup a USE Trigger
		e_trigger = spawn( "trigger_radius_use", v_pos, 0, n_radius, 30 );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger SetTeamForTrigger( "none" );
		e_trigger UseTriggerRequireLookAt();
		e_trigger SetCursorHint( "HINT_NOICON" );
	
		// You can add multiple models into the gameobjects model array, each with their own relative offset
		gobj_model_offset = ( 0, 0, 0 );
		if( IsDefined(STR_MODEL) )
		{
			gobj_visuals[0] = spawn( "script_model", v_pos + gobj_model_offset );
			gobj_visuals[0] setModel( STR_MODEL );
		}
		else
		{
			gobj_visuals = [];
		}
	
		// This is the LUA objective name, defined in the gametype LUA script
		// CP currently only uses coop
		// It defines the look and style of the LUA icons
		//gobj_objective_name = &"bomb";
		gobj_objective_name = undefined;

		// Create the gameobject
		gobj_team = "allies";
		gobj_trigger = e_trigger;
		gobj_offset = ( 0, 0, -5 );
		e_object = gameobjects::create_use_object( gobj_team, gobj_trigger, gobj_visuals, gobj_offset, gobj_objective_name );

		// Setup gameobject params
		e_object gameobjects::allow_use( "any" );
		e_object gameobjects::set_use_time( 0.0 );						// How long the progress bar takes to complete
		e_object gameobjects::set_use_text( "" );
		e_object gameobjects::set_use_hint_text( STR_USE_HINT );
		e_object gameobjects::set_visible_team( "any" );				// How can see the gameobject

		// Setup gameobject callbacks
		e_object.onUse = &onUseGameobject;
	
		// OLD STYLE OBJECTIVES
		e_object gameobjects::set_3d_icon( "friendly", "T7_hud_prompt_press_64" );
		e_object gameobjects::set_3d_icon( "enemy", "T7_hud_prompt_press_64" );
		e_object gameobjects::set_2d_icon( "friendly", "T7_hud_prompt_press_64" );
		e_object gameobjects::set_2d_icon( "enemy", "T7_hud_prompt_press_64" );

		e_object thread gameobjects::hide_icon_distance_and_los( (1,1,1), 42*20, true, e_los_ignore_me );

		return( e_object );
	}
	

	//*******************************************************
	//*******************************************************
	// Called when gameobject has been "used"
	function onUseGameobject( player )
	{
		//iprintlnbold( "Starting Team Gather" );
		self.c_teamgather.m_e_player_leader = player;
		self notify( "player_interaction" );
	}

	//*******************************************************
	//*******************************************************
	// self = class
	function spawn_floor_effect()
	{
		if( !( isdefined( 0 ) && 0 ) )
		{
			return;
		}

		v_pos = m_v_gather_position;

		// Make sure the gather position is on the plane of the floor
		v_start = ( v_pos[0], v_pos[1], v_pos[2]+20 );
		v_end = ( v_pos[0], v_pos[1], v_pos[2]-94 );
		trace = BulletTrace( v_start, v_end, 0, undefined );
				
		v_floor_pos = trace[ "position" ];

		m_gather_fx = spawnFx( "", v_floor_pos );
		triggerFx( m_gather_fx );
	}

	//*******************************************************
	//*******************************************************
	// self = class
	function cleanup_floor_effect()
	{
		if( !( isdefined( 0 ) && 0 ) )
		{
			return;
		}

		if( IsDefined(m_gather_fx) )
		{
			m_gather_fx Delete();
			m_gather_fx = undefined;
		}
	}
	
	//*******************************************************
	//*******************************************************
	// self = class
	function interact_entity_highlight( highlight_object )
	{
		if( IsDefined(m_e_interact_entity) )
		{
			if( ( isdefined( highlight_object ) && highlight_object ) )
			{
				m_e_interact_entity clientfield::set( "teamgather_material", 1 );
			}
			else
			{
				m_e_interact_entity clientfield::set( "teamgather_material", 0 );
			}
		}
	}

	//*******************************************************
	// Wait for players to gather at the team gather position
	//*******************************************************
	// self = class
	function gather_players()
	{
		start_player_timer( 10 );

		create_player_huds();

		// Wait for the gather players function to finish
		b_success = teamgather_main_update();

		return( b_success );
	}


	//******************************************************
	//******************************************************
	// self = class
	function create_player_huds()
	{
		// Display HUD for the players
		a_players = get_players_playing();

		// Flow goes straight to Success if just 1 player
		if( a_players.size <= 1 )
		{
			return;
		}
		
		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			if( e_player == self.m_e_player_leader )
			{
				self thread display_hud_player_leader( e_player );
			}
			else
			{
				self thread display_hud_player_team_member( e_player );
			}
		}
	}

	//******************************************************
	//******************************************************
	function is_teamgather_complete()
	{
		return( self.m_teamgather_complete );
	}

	//******************************************************
	//******************************************************
	function set_teamgather_complete( success )
	{
		self.m_teamgather_complete = true;
		self.m_success = success;
	}
	
	//******************************************************
	// UPDATE
	//******************************************************
	// self = class
	function teamgather_main_update()
	{
		// While there's time remaing in the teamgather
		while( !is_teamgather_complete() )
		{
			// Check if the team are in the gather radius
			update_players_in_radius( false );

			// If all players out of position, trigger failure
			if( m_num_players_ready == 0 )
			{
				set_teamgather_complete( false );
				break;
			}

			// If all the players are in position for, trigger success
			if( ( m_num_players > 0 ) && ( m_num_players_ready >= m_num_players) )
			{
				if( players_in_position( true ) )
				{
					set_teamgather_complete( true );
					break;
				}
			}
			else
			{
				players_in_position( false );
			}

			// Update time remaining
			time_remaining = get_time_remaining();
			if( time_remaining <= 0 )
			{
				set_teamgather_complete( true );
				break;
			}

			{wait(.05);};
		}

		// Check for success
		if( m_success == true )
		{
			// Teleport any players out of position into the event area
			update_players_in_radius( true );
		}
		else
		{
			
		}

		// Cleanup
		a_players = get_players_playing();
		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			if( ( isdefined( e_player.in_gather_position ) && e_player.in_gather_position ) )
			{
				e_player util::_enableWeapon();
			}
			e_player.in_gather_position = undefined;
		}

		return( m_success );
	}

	//******************************************************
	//******************************************************
	// self = class
	function players_in_position( in_position )
	{
		if( ( isdefined( in_position ) && in_position ) )
		{
			if( !IsDefined(self.in_position_start_time) )
			{
				self.in_position_start_time = gettime();
			}

			time = gettime();
			dt = ( time - self.in_position_start_time ) / 1000;
			if( dt >= (0.0) )
			{
				return( true );
			}
		}
		else
		{
			self.in_position_start_time = undefined;
		}

		return( false );
	}

	//******************************************************
	//******************************************************
	// self = class
	function update_players_in_radius( force_player_into_position )
	{
		// Setup
		a_players = get_players_playing();
		m_num_players = a_players.size;

		for( i=0; i<a_players.size; i++ )
		{
			a_players[i].in_gather_position = undefined;
		}
					
		// Update players radius check and weapon state every frame
		m_num_players_ready = 0;
		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];

			// Update players gather status
			e_player.in_gather_position = is_player_in_gather_position( e_player );

			// If force into position flag is set, make sure he's in position
			if( ( isdefined( force_player_into_position ) && force_player_into_position ) && !( isdefined( e_player.in_gather_position ) && e_player.in_gather_position ) )
			{
				teleport_player_into_position( e_player );
			}

			// If the player is in position, lower his weapon is down
			if( ( isdefined( e_player.in_gather_position ) && e_player.in_gather_position ) )
			{
				e_player player_lowready_state( true );
				m_num_players_ready++;
			}

			// If not in position, lower his weapon
			else
			{
				e_player player_lowready_state( false );

				// If its a team member and they aren't in position, they can use the X button to zoom into position
				if( e_player != m_e_player_leader )
				{
					team_member_zoom_button_check( e_player );
				}
			}
		}
	}

	//******************************************************
	//******************************************************
	// self = class
	function is_player_in_gather_position( e_player )
	{
		player_valid = true;

		// Basic 2d check to see if player is in range
		n_dist = Distance2D( e_player.origin, m_v_gather_position );
		if( n_dist > (42*5) )
		{
			player_valid = false;
		}
		else
		{
			v_start_pos = ( e_player.origin[0], e_player.origin[1],e_player.origin[2]+32 );
			v_end_pos = ( m_v_gather_position[0], m_v_gather_position[1], m_v_gather_position[2] );

			// If below the point, reject
			if( (e_player.origin[2] - v_end_pos[2]) < -64 )
			{
				player_valid = false;
			}

			// Cast a ray to the floor to check no geo is blocking
			v_trace = BulletTrace( v_start_pos, v_end_pos, 0, undefined );
			v_trace_pos = v_trace[ "position" ];
			dz = abs( v_trace_pos[2] - m_v_gather_position[2] );
			if( dz > 64 )
			{
				player_valid = false;
			}
		}

		return( player_valid);
	}
	
	//******************************************************
	//******************************************************
	// self = player
	function player_lowready_state( lower_weapon )
	{
		// Lower weapon
		if( lower_weapon )
		{
			if( self util::isWeaponEnabled() )
			{
				self util::_disableWeapon();
			}
		}
		// Raise weapon
		else
		{
			if( !(self util::isWeaponEnabled()) )
			{
				self util::_enableWeapon();
			}
		}
	}

	//******************************************************
	//******************************************************
	// self = class
	function team_member_zoom_button_check( e_player )
	{
		// Did the player request to zoom into position?
		if( (e_player UseButtonPressed()) )
		{
			teleport_player_into_position( e_player );
		}
	}

	//******************************************************
	//******************************************************
	// self = class
	function teleport_player_into_position( e_player )
	{
		a_players = get_players_playing();

		// Keep on creating potential spawn positions until we find one that works
		while( 1 )
		{
			x_offset =  RandomFloatRange( -( (42*5) - 42 ), ( (42*5) - 42 ) );
			y_offset =  RandomFloatRange( -( (42*5) - 42 ), ( (42*5) - 42 ) );
			e_player.zoom_pos = ( m_v_gather_position[0]+x_offset, m_v_gather_position[1]+y_offset, m_v_gather_position[2] );

			// Need to be away from other players
			reject = false;
			for( i=0; i<a_players.size; i++ )
			{
				if( e_player != a_players[i] )
				{
					dist = Distance2D( e_player.origin, a_players[i].origin );
					if( dist < (42*2) )
					{
						reject = true;
						break;
					}
				}
			}

			// Make sure its not ahead to the interact position
			if( !reject )
			{
				v_forward = AnglesToForward( m_v_interact_angles );
				v_dir = vectornormalize( e_player.zoom_pos - m_v_interact_position );
				dp = vectordot( v_forward, v_dir );

				// 0.0 = parallel, -ve is safe
				if( dp > -0.5 )		// -0.5
				{
					//iprintlnbold( "Player DP REJECTION" );
					reject = true;
				}
			}

			if( reject )
			{
				break;
			}

			if( !positionWouldTelefrag( e_player.zoom_pos ) )
			{
				break;
			}
		}

		// Reposition the player
		e_player SetOrigin( e_player.zoom_pos );

		// Look at the gather position
		v0 = ( self.m_v_interact_position[0], self.m_v_interact_position[1], self.m_v_interact_position[2] );
		v1 = ( e_player.zoom_pos[0], e_player.zoom_pos[1], self.m_v_interact_position[2] );
		v_dir = vectornormalize( v0 - v1 );
		v_angles =  VectorToAngles( v_dir );

		//level thread teamgather::mike_debug_line( self.m_v_interact_position, e_player.zoom_pos );

		e_player SetPlayerAngles( v_angles );
	}

	//******************************************************
	//******************************************************
	// self = class
	function display_hud_player_leader( e_player )
	{
		e_player endon( "disconnect" );
		
		y_start = 180;

		x_off = 0;
		y_off = y_start;
		gather_hud_elem = e_player __create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, &"TEAM_GATHER_TEAM_STEALTH_ENTER" );

		x_off = 0;
		y_off = y_start + 100;
		ready_hud_elem = e_player __create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "" );

		x_off = -45;
		y_off = y_start + 130;
		execute_hud_elem = e_player __create_client_hud_elem( "left", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "" );

		a_time_remaining = array(  "0", &"TEAM_GATHER_TIME_REMAINING_1", &"TEAM_GATHER_TIME_REMAINING_2", &"TEAM_GATHER_TIME_REMAINING_3", &"TEAM_GATHER_TIME_REMAINING_4",
										&"TEAM_GATHER_TIME_REMAINING_5", &"TEAM_GATHER_TIME_REMAINING_6", &"TEAM_GATHER_TIME_REMAINING_7", &"TEAM_GATHER_TIME_REMAINING_8",
										&"TEAM_GATHER_TIME_REMAINING_9", &"TEAM_GATHER_TIME_REMAINING_10" );

		while( !is_teamgather_complete() )
		{
			// Create the text for the number of players ready
			// TODO - TEXT WARNING
			ready_hud_elem setText( &"TEAM_GATHER_PLAYERS_READY", m_num_players_ready, m_num_players );
			 
			// Create the text for the time remaining
			time_remaining = get_time_remaining_in_seconds();
			execute_hud_elem setText( a_time_remaining[ time_remaining ] );

			{wait(.05);};
		}

		gather_hud_elem Destroy();
		ready_hud_elem Destroy();
		execute_hud_elem Destroy();
	}

	//******************************************************
	//******************************************************
	// self = class
	function display_hud_player_team_member( e_player )
	{
		e_player endon( "disconnect" );

		y_start = 180;

		x_off = 0;
		y_off = y_start;

		// TODO - TEXT WARNING
		starting_hud_elem = e_player __create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "" );
		starting_hud_elem setText( &"TEAM_GATHER_PLAYER_STARTING_EVENT", self.m_e_player_leader );	// self.m_e_player_leader.playername
				
		x_off = -118;
		y_off = y_start + 40;
		gathered_hud_elem = e_player __create_client_hud_elem( "left", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "" );
		
		x_off = -118 + 172;
		y_off = y_start + 40;
		start_in_hud_elem = e_player __create_client_hud_elem( "left", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "" );

		x_off = 0;
		y_off = y_start + 80;
		go_hud_elem = e_player __create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "" );

		a_start_in = array(  "0", &"TEAM_GATHER_START_IN_1", &"TEAM_GATHER_START_IN_2", &"TEAM_GATHER_START_IN_3", &"TEAM_GATHER_START_IN_4",
								  &"TEAM_GATHER_START_IN_5", &"TEAM_GATHER_START_IN_6", &"TEAM_GATHER_START_IN_7", &"TEAM_GATHER_START_IN_8",
								  &"TEAM_GATHER_START_IN_9", &"TEAM_GATHER_START_IN_10" );
																						
		while( !is_teamgather_complete() )
		{
			// Display num players gathered
			// TODO - TEXT WARNING
			gathered_hud_elem setText( &"TEAM_GATHER_NUM_PLAYERS", int(m_num_players_ready), int(m_num_players) );

			// Display start in time
			time_remaining = get_time_remaining_in_seconds();
			start_in_hud_elem setText( a_start_in[ time_remaining ] );

			// Can the player use X to teleport to position?
			if( ( isdefined( e_player.in_gather_position ) && e_player.in_gather_position ) )
			{
				go_hud_elem setText( "" );
			}
			else
			{
				go_hud_elem setText( &"TEAM_GATHER_HOLD_TO_GO_NOW" );
			}

			{wait(.05);};
		}

		starting_hud_elem Destroy();
		gathered_hud_elem Destroy();
		start_in_hud_elem Destroy();
		go_hud_elem Destroy();
	}

	//******************************************************
	//******************************************************
	// self = the player
	function __create_client_hud_elem( alignX, alignY, horzAlign, vertAlign, xOffset, yOffset, fontScale, color, str_text )
	{
		hud_elem = NewClientHudElem( self );
		hud_elem.elemType = "font";
		hud_elem.font = "objective";
		hud_elem.alignX = alignX;
		hud_elem.alignY = alignY;
		hud_elem.horzAlign = horzAlign;
		hud_elem.vertAlign = vertAlign;
		hud_elem.x += xOffset;
		hud_elem.y += yOffset;
		hud_elem.foreground = true;
		hud_elem.fontScale = fontScale;
		hud_elem.alpha = 1;
		hud_elem.color = color;
		hud_elem.hidewheninmenu = true;
		hud_elem SetText( str_text );
		return hud_elem;
	}

	//******************************************************
	//******************************************************
	// self = class
	function start_player_timer( total_time )
	{
		self.e_gameobject.start_time = gettime();
		self.e_gameobject.total_time = total_time;
	}
	
	//******************************************************
	//******************************************************
	// self = class
	function get_time_remaining()
	{
		time = gettime();
		dt = ( time - self.e_gameobject.start_time ) / 1000;
		time_remaining = self.e_gameobject.total_time - dt;
		return( time_remaining );
	}

	//******************************************************
	//******************************************************
	// self = class
	function get_time_remaining_in_seconds()
	{
		time_remaining = int ( get_time_remaining() );
		time_remaining += 1;
		if( time_remaining > 10 )
		{
			time_remaining = 10;
		}

		if( time_remaining > 10 )
		{
			time_remaining = 10;
		}
		else if( time_remaining < 1 )
		{
			time_remaining = 1;
		}

		return( time_remaining );
	}

	//******************************************************
	// Returns an array of "playing" players
	//******************************************************
	function get_players_playing()
	{
		a_players = [];

		a_all_players = getplayers();
		for( i=0; i<a_all_players.size; i++ )
		{
			e_player = a_all_players[i];
			if( e_player.sessionstate == "playing" )
			{
				a_players[a_players.size] = e_player;
			}
		}
		
		return( a_players );
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

function setup_teamgather( v_interact_pos, v_interact_angles, e_interact_entity )
{
	// Calculate the gather position
	v_forward = AnglesToForward( v_interact_angles );
	v_gather_pos = v_interact_pos + ( v_forward * -100.0 );

	// Cast a ray to clip the gather positon to the floor
	v_start = ( v_gather_pos[0], v_gather_pos[1], v_gather_pos[2] + 20 );
	v_end = ( v_gather_pos[0], v_gather_pos[1], v_gather_pos[2] - 100 );
	v_trace = BulletTrace( v_start, v_end, 0, undefined );
	v_floor_pos = v_trace[ "position" ];

	v_gather_pos = ( v_gather_pos[0], v_gather_pos[1], v_floor_pos[2]+10 );

	c_teamgather = new cTeamGather();
	success = [[ c_teamgather ]]->create_teamgather_event( v_interact_pos, v_interact_angles, v_gather_pos, e_interact_entity );

	// Return the player if successful
	if( success )
	{
		e_player = c_teamgather.m_e_player_leader;
	}
	else
	{
		e_player = undefined;
	}

	// TODO: Clean up the class, there is no delete() available....
	[[ c_teamgather ]]->cleanup();

	return( e_player );
}

//*****************************************************************************
//*****************************************************************************
// *** DEBUG ***
function mike_debug_line( v1, v2 )
{
	level notify("hello mike");
	self endon( "hello mike" );	

	while( 1 )
	{

/#
		line( v1, v2, (0,0,1) );
#/

		wait( 0.1 );
	}
}

