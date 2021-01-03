    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod_util;

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

// AREA DEFEND STATES












	
#precache( "fx", "zombie/fx_portal_keeper_spawn_zod_zmb" ); // keeper spawn vfx
#precache( "fx", "zombie/fx_keeper_ambient_torso_zod_zmb" ); // keeper personal fire vfx

#namespace zm_zod_defend_areas;


	
class cAreaDefend
{
	// entities
	var m_t_use; // use-trigger
	var m_s_centerpoint; // struct that counts as the centerpoint for the defend area
	
	// state / stats
	var m_n_state; // unavailable, in progress, completed
	var m_n_defend_radius; // defend radius - a player must be within this radius to contribute to the defend progress
	var m_n_defend_radius_sq; // defend radius squared - use to avoid frequent multiplication
	var m_n_rumble_radius; // rumble radius
	var m_n_rumble_radius_sq; // rumble radius squared - use to avoid frequent multiplication
	var m_e_defend_volume; // defend volume - if defined, will be used instead of the radius check
	var m_e_rumble_volume; // rumble volume - if defined, will be used instead of the radius check
	
	var m_n_defend_duration; // duration required to defend, for 100% of players within radius
	var m_n_defend_current_progress; // how much of the defend event has been completed?
	var m_n_defend_progress_per_update_interval; // how much to add to progress every update tick (assuming all players are within the defend area)
	var m_n_defend_grace_duration; // grace duration before reset
	var m_n_defend_grace_remaining; // grace duration remaining
	
	var m_b_started;
	
	// strings
	var m_str_spawn;
	var m_str_area_defend_unavailable;
	var m_str_area_defend_available;
	var m_str_area_defend_in_progress;
	
	// hud
	var m_str_luimenu_progress; // name of the luimenu for the progress state (defend event is progressing, and player is within the defend area)
	var m_str_luimenu_return; // name of the luimenu for the return state (defend event is progressing, and player is outside the defend area)
	var m_str_luimenu_succeeded; // name of the luimenu to play post-success
	var m_str_luimenu_failed; // name of the luimenu to play post-failure

	// funcs
	var m_func_trigger_visibility; // usetrigger visibility thread
	var m_func_prereq; // external func that is called as a pre-requisite to starting the defend event (if returns false, defend event doesn't start)
	var m_func_start; // external func that is called when the defend-area event begins
	var m_func_succeed; // external func that is called when the defend-area event succeeds
	var m_func_fail; // external func that is called when the defend-area event fails (resets)
	var m_arg1; // argument that will be passed to externally called functions
		
	// players
	var m_triggerer; // player who initiated the defend event
	var m_a_players_involved; // list of any players who have been involved in the most recent attempt to take the defend area (used for hud notification)
	
	// spawns
	var m_a_defend_event_zombies; // zombies spawned specifically for the defend event
	var m_a_e_zombie_spawners; // spawners for defend event zombies
	var m_e_spawn_points; // structs where the defend event zombies can teleport in
	
	function init( str_centerpoint, str_spawn )
	{			
		m_s_centerpoint								= struct::get( str_centerpoint, "targetname" );
		m_str_spawn									= str_spawn; // save this so we can repopulate the spawn struct array when we need to
		
		m_n_defend_duration							= 15;
		m_n_defend_current_progress					= 0;
		m_n_defend_progress_per_update_interval		= ( 100 / m_n_defend_duration ) * 0.1;
		m_n_defend_grace_duration					= 5;
		m_n_defend_grace_remaining					= m_n_defend_grace_duration;
		
		m_n_defend_radius							= 220;
		m_n_defend_radius_sq						= m_n_defend_radius * m_n_defend_radius;
		m_n_rumble_radius							= m_n_defend_radius;
		m_n_rumble_radius_sq						= m_n_rumble_radius * m_n_rumble_radius;

		m_str_area_defend_unavailable				= &"ZM_ZOD_DEFEND_AREA_UNAVAILABLE";
		m_str_area_defend_available					= &"ZM_ZOD_DEFEND_AREA_AVAILABLE";
		m_str_area_defend_in_progress				= &"ZM_ZOD_DEFEND_AREA_IN_PROGRESS";

		m_func_trigger_visibility					= &ritual_start_prompt_and_visibility;
		m_func_trigger_thread						= &usetrigger_think;
	
		populate_spawn_points();
	
		m_n_state = 0;
		m_b_started = false;
		update_usetrigger_hintstring();
	}

	// need to call this repeatedly each time the defend area is available to start again	
	function populate_spawn_points()
	{
		m_a_e_zombie_spawners						= GetEntArray( "ritual_zombie_spawner", "targetname" ); // get the special ritual spawner
		a_s_spawn_points							= struct::get_array( m_str_spawn, "targetname" );
		foreach( s_spawn_point in a_s_spawn_points )
		{
			// have to create deletable ents so we can end the effect TODO: find better way of doing this
			e_deletable_spawn_point = Spawn( "script_model", s_spawn_point.origin );
			e_deletable_spawn_point SetModel( "tag_origin" );
			e_deletable_spawn_point.origin = s_spawn_point.origin;
			e_deletable_spawn_point.angles = s_spawn_point.angles;
			if ( !isdefined( m_e_spawn_points ) ) m_e_spawn_points = []; else if ( !IsArray( m_e_spawn_points ) ) m_e_spawn_points = array( m_e_spawn_points ); m_e_spawn_points[m_e_spawn_points.size]=e_deletable_spawn_point;;
		}
	}
	
	function set_trigger_visibility_function( func_trigger_visibility )
	{
		m_func_trigger_visibility = func_trigger_visibility;
	}
		
	function set_external_functions( func_prereq, func_start, func_succeed, func_fail, arg1 )
	{
		m_func_prereq = func_prereq;
		m_func_start = func_start;
		m_func_succeed = func_succeed;
		m_func_fail = func_fail;
		m_arg1 = arg1;
	}
	
	function set_luimenus( str_luimenu_progress, str_luimenu_return, str_luimenu_succeeded, str_luimenu_failed )
	{
		m_str_luimenu_progress = str_luimenu_progress;
		m_str_luimenu_return = str_luimenu_return;
		m_str_luimenu_succeeded = str_luimenu_succeeded;
		m_str_luimenu_failed = str_luimenu_failed;
	}
	
	function set_volumes( str_defend_volume, str_rumble_volume )
	{
		m_e_defend_volume = GetEnt( str_defend_volume, "targetname" );
		m_e_rumble_volume = GetEnt( str_rumble_volume, "targetname" );
		
		Assert( isdefined( m_e_defend_volume ), "cAreaDefend->set_volumes - m_e_defend_volume is undefined!" );
		Assert( isdefined( m_e_rumble_volume ), "cAreaDefend->set_volumes - m_e_rumble_volume is undefined!" );
	}

	function set_duration( n_duration )
	{
		m_n_defend_duration = n_duration;
		m_n_defend_progress_per_update_interval		= ( 100 / m_n_defend_duration ) * 0.1;
	}
	
	function start()
	{
		ritual_start_dims = (110,110,128);
		
		// Create the use trigger.
		//
		m_t_use = zm_zod_util::spawn_trigger_box( m_s_centerpoint.origin, m_s_centerpoint.angles, ritual_start_dims, true );
		m_t_use.o_defend_area = self;
		m_t_use.prompt_and_visibility_func = m_func_trigger_visibility;
		
		m_b_started = true;
		update_usetrigger_hintstring();
		self thread usetrigger_think();
	}
	
	// lets the availability of the ritual trigger be turned off and on; sets the state and updates the hintstring
	function set_availability( b_is_available )
	{
		// only update availability if the ritual is not in progress or completed
		if( b_is_available && ( m_n_state == 0 ) )
		{
			m_n_state = 1;
		}
		else if( !b_is_available && ( m_n_state == 1 ) )
		{
			m_n_state = 0;
		}
		
		update_usetrigger_hintstring();
	}
	
	function ritual_start_message_internal( player )
	{
		if( !m_b_started )
		{
			return &"";
		}
		
		switch( m_n_state )
		{
			case 0:
				return m_str_area_defend_unavailable;
			case 1:
				return m_str_area_defend_available;
			default:
				return &"";
		}
	}
	
	function ritual_start_visible_internal( player )
	{
		if ( ( isdefined( player.beastmode ) && player.beastmode ) )
		{
			return false;
		}
		
		if( m_b_started )
		{
			switch( m_n_state )
			{
				case 0:
				case 1:
					return true;
				default:
					break;
			}
		}
			
		return false;
	}
	
	function ritual_start_prompt_and_visibility( player )
	{
		b_is_visible = [[self.stub.o_defend_area]]->ritual_start_visible_internal( player );
		
		if ( b_is_visible )
		{
			str_msg = [[self.stub.o_defend_area]]->ritual_start_message_internal( player );
			self SetHintString( str_msg );
		}
		else
		{
			self SetHintString( &"" );		
		}
		
		return b_is_visible;
	}
	
	// updates all use-trigger strings to match current state of the trap
	function update_usetrigger_hintstring()
	{
		if ( isdefined( m_t_use ) )
		{
			m_t_use zm_unitrigger::run_visibility_function_for_all_triggers();
		}
	}

	function usetrigger_think() // self = object
	{
		self endon( "area_defend_completed" );

		while( true )
		{
			m_t_use waittill( "trigger", e_triggerer ); // wait until someone uses the trigger
			
			if( e_triggerer zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
			{
				continue;
			}
		
			if( !zm_utility::is_player_valid( e_triggerer, true, true ) ) // ensure valid player
			{
				continue;
			}

			if( m_n_state != 1 ) // ensure the ritual is available
			{			
				continue;			
			}
			
			if( isdefined( m_func_prereq ) && ( [[ m_func_prereq ]]( m_arg1 ) == false ) )
			{
				continue;
			}
			
			// start the area defend sequence
			m_n_state = 2;
			m_triggerer = e_triggerer; // store the player who initiated the ritual
			update_usetrigger_hintstring();
			[[ m_func_start ]]( m_arg1 ); // call external custom func for location-specific effects
			self thread activate_spawnpoint_vfx( true ); // play standard vfx for the defend
			self thread progress_think(); // progress thread
			// don't spawn the teleported zombies - need to get through today's playtest
			self thread monitor_defend_event_zombies(); // spawns zombies that are specifically for the defend event
			
			while( m_n_state != 1 )
			{
				wait 1.0;
			}
		}
	}

	// TODO: move the vfx to the client - putting them here now to get in quickly for a playtest
	function activate_spawnpoint_vfx( b_on = true )
	{
		foreach( s_spawn_point in m_e_spawn_points )
		{
			if( b_on )
			{
				s_spawn_point.vfx_ref = PlayFXOnTag( level._effect[ "keeper_spawn" ], s_spawn_point, "tag_origin" );
			}
			else
			{
				s_spawn_point Delete(); // delete temp struct to kill effect
			}
		}
		
		if( !b_on )
		{
			m_e_spawn_points = []; // reset array
		}
	}

	// applies the current increase rate based on the number of players in the area, and eventually ends with success (the area defend is completed) or failure (the area defend resets)
	function progress_think()
	{
		/# PrintLn( "cAreaDefend progress_think()" ); #/
		m_n_defend_current_progress = 0;
		m_n_defend_grace_remaining = m_n_defend_grace_duration;
		m_a_players_involved = [];

		// continue tracking progress until the defend has completed, or the grace period has run out
		while( ( m_n_defend_current_progress < 100 ) && ( m_n_defend_grace_remaining > 0 ) )
		{
			a_players = GetPlayers();
			a_players_in_defend_area = get_players_in_defend_area();
			n_players_in_defend_area = a_players_in_defend_area.size;
			
			foreach( player in a_players )
			{
				if( player.sessionstate == "spectator" )
				{
					continue;
				}
				
				if( is_player_in_defend_area( player ) )
				{
					// player is entering the defend area for the first time
					if( !isdefined( player.is_in_defend_area ) )
					{
						player thread zm_zod_util::set_rumble_to_player( 4 );
						array::add( m_a_players_involved, player, false ); // add to array of involved players, don't allow dupes
						player.is_in_defend_area = true;
//						player.defend_area_luimenu_status = player OpenLUIMenu( m_str_luimenu_progress );
					}

					// player is returning to defend area from outside
					if( !player.is_in_defend_area )
					{
						player thread zm_zod_util::set_rumble_to_player( 4 );
						player.is_in_defend_area = true;
						self reset_hud( player ); // close the LUI Menu and undefine it
//						player.defend_area_luimenu_status = player OpenLUIMenu( m_str_luimenu_progress );
					}
					
					if( isdefined( player.defend_area_luimenu_status ) )
					{
						// update bar whenever player is in defend area
//						player SetLUIMenuData( player.defend_area_luimenu_status, "frac", ( m_n_defend_current_progress / AREA_DEFEND_COMPLETED_VALUE ) );
					}
				}
				else if ( zm_utility::is_player_valid( player, true, true ) )
				{
					// player is exiting the defend area
					if( isdefined( player.is_in_defend_area ) && player.is_in_defend_area )
					{
						player thread zm_zod_util::set_rumble_to_player( 0 );
						player.is_in_defend_area = false;
						self reset_hud( player ); // close the LUI Menu and undefine it
						player.defend_area_luimenu_status = player OpenLUIMenu( m_str_luimenu_return );
					}
				}
			}
			
			// update capture progress based on the portion of players within the defend area
			n_current_progress_rate = get_progress_rate( n_players_in_defend_area, a_players.size );
			m_n_defend_current_progress += n_current_progress_rate;

			if( n_current_progress_rate > 0 )
			{
				m_n_defend_current_progress = math::clamp( m_n_defend_current_progress, 0, 100 );
				m_n_defend_grace_remaining = m_n_defend_grace_duration;
			}
			else // no progress = no players in the defend area
			{
				m_n_defend_grace_remaining -= 0.1;
			}
		
			wait 0.1;
		}

		if( m_n_defend_current_progress == 100 ) // success!
		{
			defend_succeeded();
		}
		else // failure (reset)
		{
			defend_failed();
		}
	}
	
	function monitor_defend_event_zombies()
	{
		m_a_defend_event_zombies = [];
	
		while ( m_n_state == 2 )
		{
			// remove dead from the defender zombies
			m_a_defend_event_zombies = array::remove_dead( m_a_defend_event_zombies, false );
			
			// vary additional spawns with level when early on
			n_defend_event_zombie_limit = 4;
			if( level.round_number < 4 )
			{
				n_defend_event_zombie_limit = 6;
			}
			else if( level.round_number < 6 )
			{
				n_defend_event_zombie_limit = 5;
			}
			
			//if we have less than capture zombies max, spawn in one
			if ( m_a_defend_event_zombies.size < n_defend_event_zombie_limit )
			{
				//grab spawn point
				s_spawn_point = get_unused_spawn_point();
				
				ai = zombie_utility::spawn_zombie( m_a_e_zombie_spawners[0], "defend_event_zombie", s_spawn_point  );

				if( !isdefined( ai ) )
				{
					/# PrintLn( "zm_zod_defend_areas - ai from spawn_zombie not defined" ); #/
					continue;
				}
				
				ai thread init_defend_event_zombie( s_spawn_point );
				
				//add ai to the capture array
				array::add( m_a_defend_event_zombies, ai, false );
			}
			
			wait level.zombie_vars["zombie_spawn_delay"];
		}
	}
	
	function init_defend_event_zombie( s_spawn_point )
	{
		self endon( "death" );
		
		self.script_string = "find_flesh";
		self setPhysParams( 15, 0, 72 );  // since _zm_spawner calls aren't run, set this manually
		self.ignore_enemy_count = true;  // don't count towards ai limit
		self.no_powerups = true; // defenders don't drop powerups
		self.deathpoints_already_given = true;
		self.exclude_distance_cleanup_adding_to_total = true;
		
		// Let spawning callbacks complete before calling "find_flesh"
		util::wait_network_frame();

		PlayFXOnTag( level._effect[ "fire_head" ], self, "j_spineupper" );
		
		// slowest a capture zombie should ever be is "run" speed
		if ( self.zombie_move_speed === "walk" )
		{
			self zombie_utility::set_zombie_run_cycle( "run" );
		}
		
		find_flesh_struct_string = "find_flesh";
		self notify( "zombie_custom_think_done", find_flesh_struct_string );
	}

	function get_unused_spawn_point()
	{	
		a_valid_spawn_points = [];
		
		b_all_points_used = false;
		
		while ( !a_valid_spawn_points.size )
		{
			foreach ( s_spawn_point in m_e_spawn_points )
			{
				if ( !IsDefined( s_spawn_point.spawned_zombie ) || b_all_points_used )
				{
					s_spawn_point.spawned_zombie = false;
				}
				
				if ( !s_spawn_point.spawned_zombie )
				{
					array::add( a_valid_spawn_points, s_spawn_point, false );
				}
			}
			
			if ( !a_valid_spawn_points.size )
			{
				b_all_points_used = true;
			}
		}
	
		s_spawn_point = array::random( a_valid_spawn_points );	
		
		s_spawn_point.spawned_zombie = true;
		
		return s_spawn_point;
	}
	
	function defend_succeeded()
	{
		/# PrintLn( "cAreaDefend defend_succeeded()" ); #/
		m_n_state = 3;
		kill_all_defend_event_zombies(); // ritual destroys all keepers in the level
		self thread activate_spawnpoint_vfx( false ); // deactivate the vfx by deleting the spawn points
		self thread ritual_nuke(); // ritual destroys all zombies in the level
		
		zm_unitrigger::unregister_unitrigger( m_t_use );
		m_t_use = undefined;

		foreach( player in m_a_players_involved )
		{
			player thread zm_zod_util::set_rumble_to_player( 5 );
			player.is_in_defend_area = undefined;
			self thread defend_succeeded_hud( player );
			player zm_score::add_to_player_score( 1000 );
		}

		[[ m_func_succeed ]]( m_arg1 ); // call external custom func for location-specific effects
		self notify( "area_defend_completed" );
	}

	function defend_failed()
	{
		/# PrintLn( "cAreaDefend defend_failed()" ); #/
		m_n_state = 1;
		update_usetrigger_hintstring();
		kill_all_defend_event_zombies();
		self thread activate_spawnpoint_vfx( false ); // deactivate the vfx by deleting the spawn points
		self thread populate_spawn_points(); // repopulate the spawn points since the defend failed and we want to be able to restart it

		foreach( player in m_a_players_involved )
		{
			player thread zm_zod_util::set_rumble_to_player( 0 );
			player.is_in_defend_area = undefined;
			self thread defend_failed_hud( player );
		}
		
		[[ m_func_fail ]]( m_arg1 ); // call external custom func for location-specific effects
	}

	function kill_all_defend_event_zombies()
	{
		foreach( zombie in m_a_defend_event_zombies )
		{
			if ( IsAlive( zombie ) )
			{
				zombie Kill();
			}
		}
	}
	
	function get_progress_rate( n_players_in_defend_area, n_players_total )
	{
		n_current_update_rate = ( n_players_in_defend_area / n_players_total ) * m_n_defend_progress_per_update_interval;
		return n_current_update_rate;
	}
	
	function get_state()
	{
		return m_n_state;
	}

	
	function get_players_in_defend_area()
	{
		a_players_in_defend_area = [];
	
		foreach ( player in GetPlayers() )
		{
			if( is_player_in_defend_area( player ) )
			{
				array::add( a_players_in_defend_area, player );
			}
		}
	
		return a_players_in_defend_area;
	}

	function is_player_in_defend_area( player )
	{
		if( isdefined( m_e_defend_volume ) )
		{
			if ( zm_utility::is_player_valid( player, true, true ) && ( player IsTouching( m_e_defend_volume ) ) )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		if ( zm_utility::is_player_valid( player, true, true ) && ( Distance2DSquared( player.origin, m_s_centerpoint.origin ) < m_n_defend_radius_sq ) && ( player.origin[ 2 ] > ( m_s_centerpoint.origin[ 2 ] + -20 ) ) )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	function get_current_progress()
	{
		return ( m_n_defend_current_progress / 100 );
	}
	
	function defend_succeeded_hud( player )
	{
		self reset_hud( player );
		
		if( player.sessionstate == "spectator" )
		{
			return;
		}

//		player.defend_area_luimenu_status = player OpenLUIMenu( m_str_luimenu_succeeded );
//		player lui::play_animation( player.defend_area_luimenu_status, "Ascent" );
		
		wait 3;
		
		self reset_hud( player );
	}
	
	function defend_failed_hud( player )
	{
		self reset_hud( player );
		
		if( player.sessionstate == "spectator" )
		{
			return;
		}
		
//		player.defend_area_luimenu_status = player OpenLUIMenu( m_str_luimenu_failed );
//		player lui::play_animation( player.defend_area_luimenu_status, "Descent" );
		
		wait 3;
		
		self reset_hud( player );
	}
	
	function reset_hud( player )
	{
		if( player.sessionstate == "spectator" )
		{
			return;
		}
		
		if( isdefined( player.defend_area_luimenu_status ) )
		{
			progress_menu_status = player GetLUIMenu( m_str_luimenu_progress );
			return_menu_status = player GetLUIMenu( m_str_luimenu_return );

			if( isdefined( progress_menu_status ) || isdefined( return_menu_status ) )
			{
				player CloseLUIMenu( player.defend_area_luimenu_status );
				player.defend_area_luimenu_status = undefined;
			}
		}
	}


	// kill them all!
	function ritual_nuke()
	{
		location = m_s_centerpoint.origin;
	
		level thread ritual_success_flash();
	
		wait( 0.5 );
	
		zombies = GetAiTeamArray( level.zombie_team );
		zombies = ArraySort( zombies, location );
		zombies_nuked = [];
	
		// Mark them for death
		for (i = 0; i < zombies.size; i++)
		{
			// unaffected by nuke
			if ( ( isdefined( zombies[i].ignore_nuke ) && zombies[i].ignore_nuke ) )
			{
				continue;
			}
	
			// already going to die
			if ( IsDefined(zombies[i].marked_for_death) && zombies[i].marked_for_death )
			{
				continue;
			}
	
			// check for custom damage func
			if ( IsDefined(zombies[i].nuke_damage_func) )
			{
				zombies[i] thread [[ zombies[i].nuke_damage_func ]]();
				continue;
			}
			
			if( zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
			{
				continue;
			}
	
			zombies[i].marked_for_death = true;
			zombies[i].nuked = true;
			zombies_nuked[ zombies_nuked.size ] = zombies[i];
		}
	
		for (i = 0; i < zombies_nuked.size; i++)
		{
			wait (randomfloatrange(0.1, 0.7));
			if( !IsDefined( zombies_nuked[i] ) )
			{
				continue;
			}
	
			if( zm_utility::is_magic_bullet_shield_enabled( zombies_nuked[i] ) )
			{
				continue;
			}
	
			if( i < 5 && !( ( isdefined( zombies_nuked[i].isdog ) && zombies_nuked[i].isdog ) ) )
			{
				zombies_nuked[i] thread zombie_death::flame_death_fx();
			}
	
			if( !( ( isdefined( zombies_nuked[i].isdog ) && zombies_nuked[i].isdog ) ) )
			{
				if ( !( isdefined( zombies_nuked[i].no_gib ) && zombies_nuked[i].no_gib ) )
				{
					zombies_nuked[i] zombie_utility::zombie_head_gib();
				}
				zombies_nuked[i] playsound ("evt_nuked");
			}
	
			zombies_nuked[i] dodamage( zombies_nuked[i].health + 666, zombies_nuked[i].origin );

			// incrementing zombie_total causes a progression break if called during a special round; for now, not doing this increment during it			
			if( !( level flag::get( "special_round" ) ) )
			{
				level.zombie_total++; // get the zombie back so it can spawn again; players can still kill it to get the points - we're just clearing the level for a post-ritual moment of reprieve
			}
		}
	}

	function ritual_success_flash()
	{
		fadetowhite = newhudelem();
	
		fadetowhite.x = 0;
		fadetowhite.y = 0;
		fadetowhite.alpha = 0;
	
		fadetowhite.horzAlign = "fullscreen";
		fadetowhite.vertAlign = "fullscreen";
		fadetowhite.foreground = true;
		fadetowhite SetShader( "white", 640, 480 );
	
		// Fade into white
		fadetowhite FadeOverTime( 0.2 );
		fadetowhite.alpha = 0.8;
	
		wait 0.5;
		fadetowhite FadeOverTime( 1.0 );
		fadetowhite.alpha = 0;
	
		wait 1.1;
		fadetowhite destroy();
	}

}
