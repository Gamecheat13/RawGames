#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace tiger_tank;

function autoexec __init__sytem__() {     system::register("tiger_tank",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "vehicle", "tiger_tank_retreat_fx",	1, 1, "int" );
	clientfield::register( "vehicle", "tiger_tank_disable_sfx",	1, 1, "int" );
}










	







class cTigerTank
{
	var m_str_state;
	var m_str_state_last;
	var m_n_health;
	var m_vehicle;
	var m_ai_gunner;
	var m_n_time_last_damaged;
	var m_n_time_since_last_retreat;
	var m_n_times_retreated;
	var m_n_time_turret_last_fired;
	var m_a_states;
	var m_a_nodes;
	var m_n_distance_to_enemy;
	var m_e_target;
	var m_b_retreat_override;
	var m_e_lookat;
	var m_n_last_random_goal_index;
	var m_vehicle_dead;
	
	constructor()
	{
		m_str_state = "none";  // this should only be used as initial state
		m_str_state_last = ""; // this should only be used as initial state

		m_n_time_turret_last_fired = 0;
		m_n_times_retreated = 0;
		m_b_retreat_override = false;
		m_n_last_random_goal_index = -1;
		m_e_target = undefined;
		m_vehicle_dead = false;
		
		// REGISTER STATES
		// attack 
		register_state_func( "attack", "attack_moving", 100, &state_attack_moving, &state_attack_moving_validate );
		
		// retreat
		register_state_func( "retreat", "retreat", 100, &state_retreat, &always_true );

		// idle
		register_state_func( "idle", "idle", 100, &state_idle, &always_true );		
		
		// initialize flags
		self flag::init( "firing" );
		self flag::init( "moving" );
	}
	
	destructor()
	{
		
	}
	
	function tiger_tank_setup( vehicle, str_gunner_name )  // self = vehicle
	{	
		if ( IsDefined( str_gunner_name ) )
		{
			sp_gunner = GetEnt( str_gunner_name, "targetname" );
			
			ai_gunner = spawner::simple_spawn_single( sp_gunner );
			
			set_ai_gunner( ai_gunner );
		}
		
		set_ai_vehicle( vehicle );
	}
	
	function retreat_override()
	{
		if ( m_n_times_retreated < 2 )
		{	
			m_b_retreat_override = true;
			self notify( "state_changed" );
		};
	}
	
	function disable_sfx( n_state )
	{
		if ( IsDefined( m_vehicle ) )
		{
			m_vehicle clientfield::set( "tiger_tank_disable_sfx", n_state );
		}
	}
	
	function start_think()
	{	
		self endon( "stop_think" );
		
		if ( !m_vehicle_dead )
		{
			if ( IsDefined( m_vehicle ) )
			{
				// start threads
				self thread track_target();
				wait 0.1;	// Wait to acquire the first target before start thinking.
				
				self thread state_think();
				
				
				wait 3;	// Give the tank time to target first before start attacking.
				
				self thread fire_turret();		
				self thread fire_gunner();
			}
		}
	}
	
	function stop_think()
	{
		self notify( "stop_think" );
		self notify( "state_changed" );		
	}
	
	function delete_gunner()
	{	
		if ( IsDefined( m_ai_gunner ) )
		{		
			m_ai_gunner Delete();
			m_ai_gunner = undefined;
		};
	}
	
	function delete_ai()
	{
		stop_think();
		
		if ( IsDefined( m_vehicle ) )
		{		
			m_vehicle Delete();
			m_vehicle = undefined;
		};
		
		if ( IsDefined( m_ai_gunner ) )
		{		
			m_ai_gunner Delete();
			m_ai_gunner = undefined;
		};
	}
	
	function set_ai_vehicle( vehicle )
	{
		m_vehicle = vehicle;
		m_vehicle SetNearGoalNotifyDist( 120 );
		
		Target_Set( m_vehicle, ( 0, 0, 60 ) );
		
		// set up turret firing parameters
		const FIRE_TIME_MIN = 0.75;
		const FIRE_TIME_MAX = 1.5;
		const BURST_WAIT_MIN = 0.25;
		const BURST_WAIT_MAX = 0.75;
		
		m_vehicle turret::set_burst_parameters( FIRE_TIME_MIN, FIRE_TIME_MAX, BURST_WAIT_MIN, BURST_WAIT_MAX, 1 );
		m_vehicle SetOnTargetAngle( 1, 0 );
		m_vehicle set_field_of_view();
		
		// if vehicle is sentient, initialize vehicle scripts (death watchers, fx, etc.)
		if ( IsSentient( m_vehicle ) )
		{
			self thread vehicle_death();
		}
		
		if ( IsDefined( m_ai_gunner ) )
		{
			setup_ai_gunner();
		}
		
		// start threads
		self thread damage_watcher();
		self thread show_state_info();
				
		m_e_lookat = GetEnt( "street_lookat", "targetname" );
		m_vehicle SetLookAtEnt( m_e_lookat );
	}
	
	function set_ai_gunner( ai_gunner )
	{
		m_ai_gunner = ai_gunner;
	}
	
	function setup_ai_gunner()
	{
		if ( IsDefined( m_ai_gunner ) )
		{
			m_ai_gunner thread vehicle::get_in( m_vehicle, "gunner1", true );
			
			self thread disable_mg_turret_on_gunner_death();	
		}
	}
	
	function fire_turret()
	{
		self endon( "death" );
		self endon( "stop_think" );
		m_vehicle endon( "death" );
		
		while ( true )
		{			
			if ( IsDefined( m_e_target ) )
			{
				v_target_offset = ( 0, 0, 53 );
				v_target_origin = m_e_target.origin + v_target_offset;
			
				m_n_distance_to_enemy = Distance( m_vehicle.origin, m_e_target.origin );
				
				m_vehicle util::waittill_any_timeout(2, "turret_on_target" );
				
				if ( can_hit_target( v_target_origin ) && m_n_distance_to_enemy > 620 )
				{
					m_vehicle FireWeapon( 0, m_e_target, v_target_offset );
				}
				else
				{
					m_vehicle ClearTurretTarget();
				}
			}
			else
			{
				m_vehicle ClearTurretTarget();
			}
	
			wait RandomFloatRange( 4, 8 );
		}
	}
	
	function fire_gunner()
	{
		self endon( "death" );
		self endon( "stop_think" );
		m_vehicle endon( "death" );
		
		while ( true )
		{		
			if ( IsDefined( m_e_target ) )
			{			
				if ( IsDefined( m_ai_gunner ) && IsAlive( m_ai_gunner ) )
				{
					m_vehicle thread turret::shoot_at_target( get_gunner_target(), -1, ( 0, 0, 0 ), 1, false );
				}
				
				wait RandomFloatRange( 2, 3 );
				
				m_vehicle turret::disable( 1 );
				
				wait RandomFloatRange( 4, 6 );
			}
			else
			{
				wait 0.1; // Sleep for a while if no target.
			}
		}
	}
	
	function track_target()
	{
		self endon( "death" );
		self endon( "stop_think" );
		m_vehicle endon( "death" );
		
//		BYU: I commented out the scripted targets because there is a studio note to make the tank
//		more aggressive but this could be changed again.
//		
//		a_e_tank_target = GetEntArray( "so_tank_target", "targetname" );
//		
//		// Scripted to hit predetermined targets first before moving on to player
//		foreach ( e_tank_target in a_e_tank_target )
//		{
//			m_e_target = e_tank_target;
//			m_vehicle SetTargetEntity( e_tank_target );
//			wait RandomFloatRange( 6, 6.5 );
//		}
		
		while ( true )
		{
			m_e_target = get_closest_target();
			
			if ( IsDefined( m_e_target ) )
			{
				m_vehicle SetTargetEntity( m_e_target );
			}
			else
			{
				m_vehicle ClearTurretTarget();
				m_vehicle ClearTargetEntity();
			}
			
			wait RandomFloatRange( 4, 5 );
		}
	}
	
	function state_think()
	{
		self endon( "death" );
		self endon( "stop_think" );
		m_vehicle endon( "death" );
		
		while ( true )
		{
			b_has_target = has_valid_target();
			
			if ( b_has_target )
			{
				b_should_retreat = should_retreat();
				
				if ( b_should_retreat )
				{
					str_type = "retreat";
				}
				else if ( m_b_retreat_override )
				{
					m_b_retreat_override = false;
					str_type = "retreat";
				}
				else 
				{
					str_type = "attack";
				}
			}
			else 
			{
				str_type = "idle";
			}
			
			str_next_state = select_behavior_from_type( str_type );
			
			update_state( str_type, str_next_state );
			
			wait 0.1;  // delay in case any behaviors return early
		}
	}
	
	function damage_watcher()
	{
		self endon( "death" );
		self endon( "stop_think" );
		m_vehicle endon( "death" );
		
		while ( true )
		{
			m_vehicle waittill( "damage" );
			
			m_n_time_last_damaged = GetTime();
			
			if ( should_retreat() )
			{
				debug_print( "cTigerTank: damage interrupt!" );
				self notify( "state_interrupt" );
			}
		}
	}
	
	function update_state( str_type, str_next_state )
	{		
		self endon( "state_interrupt" );
		
		if ( m_str_state != str_next_state )
		{
			self notify( "state_changed" );
			
			Assert( IsDefined( m_a_states[ str_type ][ str_next_state ] ), "cTigerTank - update_state: '" + str_type + "' type state '" + str_next_state + "' is not valid!" );
			
			m_str_state_last = m_str_state;
			m_str_state = str_next_state;
		}
		
		[[ m_a_states[ str_type ][ str_next_state ].func_state ]]();		
	}
	
	// state functions
	function state_idle()
	{
		self endon( "state_changed" );
		
		debug_print( "cTigerTank: idle" );
		
		m_vehicle turret::disable( 0 );
		stop_gunner_firing();
		
		while ( !has_valid_target() )
		{
			wait 0.5;
		}
	}
	
	function state_attack_moving_validate()
	{
		return true;
	}
	
	// goal: move towards target while firing
	function state_attack_moving()
	{
		self endon( "state_changed" );
		
		debug_print( "cTigerTank: attack moving" );
		
		if ( IsDefined( m_e_target ) )
		{		
			v_to_target = VectorNormalize( m_e_target.origin - m_vehicle.origin ) * 900;
			
			s_goal = find_best_goal_position_around_target( m_vehicle.origin + v_to_target );
			
			n_distance_to_new_goal = Distance( m_vehicle.origin, s_goal.origin );
			
			v_dir = AnglesToForward( s_goal.angles ) * 200;
			m_e_lookat.origin = s_goal.origin + v_dir;
				
			send_vehicle_to_position( s_goal.origin, true, true );
	
			n_action_wait = RandomFloatRange( 2.5, 3 );
					
			wait n_action_wait; // time out (next action)
			
			nd_random_goal = get_random_goal();
			
			n_distance_to_new_goal = Distance( m_vehicle.origin, nd_random_goal.origin );
	
			send_vehicle_to_position( nd_random_goal.origin, true, true );
			
			n_action_wait = RandomFloatRange( 3.5, 4 );
			
			wait n_action_wait; // time out (next action)
		}
		else
		{
			wait 3; // since there is no target, wait a few seconds and move on to the next action.
		}
	}	
	
	function state_retreat()
	{
		self endon( "state_changed" );
		
		debug_print( "cTigerTank: retreat" );
		
		m_n_last_random_goal_index = -1;
		
		nd_goal = get_retreat_goal();
		
		if ( IsDefined( nd_goal ) )
		{
			debug_print( "cTigerTank: retreating!" );
			
			show_point_with_text( nd_goal.origin, "RETREAT", ( 0, 0, 1 ), 200 );
				
			m_vehicle clientfield::set( "tiger_tank_retreat_fx", 1 );
				
			m_n_time_since_last_retreat = GetTime();
			send_vehicle_to_position( nd_goal.origin, true, !true, !true );
			
			stop_movement();
			
			self wait_till_moving_complete();
			
			m_vehicle clientfield::set( "tiger_tank_retreat_fx", 0 );
		}
		else 
		{
			debug_print( "cTigerTank: retreat failed!" );
		}
	}
	
	// utility functions
	function has_valid_target()
	{
		a_targets = m_vehicle turret::_get_potential_targets( 0 );
		
		b_has_target = ( a_targets.size > 0 );
		
		return b_has_target;
	}
	
	function get_closest_target()
	{
		a_targets = m_vehicle turret::_get_potential_targets( 0 );
		e_closest = undefined;
		
		if ( a_targets.size > 0 )
		{		
			a_targets_closest = ArraySort( a_targets, m_vehicle.origin, true );
			
			foreach ( e_target in a_targets_closest )
			{
				if ( Distance2D( e_target.origin, m_vehicle.origin) > m_vehicle.radius )
				{
					e_closest = e_target;
				}
			}
		}
		
		return e_closest;
	}
	
	function get_targets()
	{
		a_targets = m_vehicle turret::_get_potential_targets( 0 );
		
		return a_targets;
	}
	
	function select_behavior_from_type( str_type )
	{
		Assert( IsDefined( m_a_states[ str_type ] ), "cTigerTank: select_behavior_from_type found no state type named '" + str_type + "'!" );
		
		a_valid_behaviors = get_valid_behaviors( str_type );
		
		// optionally filter out previous behavior for variety, if possible
		if ( ( a_valid_behaviors.size > 1 ) && IsInArray( a_valid_behaviors, m_str_state ) )
		{
			ArrayRemoveValue( a_valid_behaviors, m_str_state, false );
		}
		
		str_behavior = select_behavior_from_chance( str_type, a_valid_behaviors );
		
		return str_behavior;
	}
	
	function get_valid_behaviors( str_type )
	{
		a_behaviors = GetArrayKeys( m_a_states[ str_type ] );
		a_valid_behaviors = [];		
		
		// filter all invalid behaviors
		for ( i = 0; i < a_behaviors.size; i++ )
		{
			if ( [[ m_a_states[ str_type ][ a_behaviors[ i ] ].func_validate ]]() )
			{
				if ( !isdefined( a_valid_behaviors ) ) a_valid_behaviors = []; else if ( !IsArray( a_valid_behaviors ) ) a_valid_behaviors = array( a_valid_behaviors ); a_valid_behaviors[a_valid_behaviors.size]=a_behaviors[ i ];;
			}
		}	

		Assert( a_valid_behaviors.size, "cTigerTank: get_valid_behaviors could not find a valid behavior for type '" + str_type + "'!" );
		
		return a_valid_behaviors;		
	}
	
	function select_behavior_from_chance( str_type, a_behaviors )
	{
		// find range for roll
		n_chance_max = 0;
		
		for ( i = 0; i < a_behaviors.size; i++ )
		{
			n_chance_max += m_a_states[ str_type ][ a_behaviors[ i ] ].n_chance;
			
			m_a_states[ str_type ][ a_behaviors[ i ] ].n_chance_temp = n_chance_max;  // store temp value here
		}
		
		// roll
		n_roll = RandomIntRange( 0, n_chance_max );
		
		// select a behavior from roll
		for ( j = 0; j < a_behaviors.size; j++ )
		{
			if ( n_roll < m_a_states[ str_type ][ a_behaviors[ j ] ].n_chance_temp )
			{
				str_behavior = a_behaviors[ j ];
				break;
			}
		}
		
		Assert( IsDefined( str_behavior ), "cTigerTank: select_behavior_from_chance found no valid behavior!" );  // sanity check
		
		return str_behavior;
	}
	
	function register_state_func( str_type, str_state, n_chance, func_state, func_validate )
	{
		Assert( IsDefined( str_type ), "cTigerTank: register_state_func - str_type is missing!" );
		Assert( IsDefined( str_state ), "cTigerTank: register_state_func - str_state is missing!" );
		Assert( IsDefined( n_chance ), "cTigerTank: register_state_func - n_chance is missing!" );
		Assert( IsDefined( func_state ), "cTigerTank: register_state_func - func_state is missing!" );
		Assert( IsDefined( func_validate ), "cTigerTank: register_state_func - func_validate is missing!" );
		
		if ( !IsDefined( m_a_states ) )
		{
			m_a_states = [];
		}
		
		if ( !IsDefined( m_a_states[ str_type ] ) )
		{
			m_a_states[ str_type ] = [];
		}
		
		Assert ( !IsDefined( m_a_states[ str_type ][ str_state ] ), "cTigerTank: register_state_func found duplicate state registration for state type '" + str_type + "', named '" + str_state + "'!" );
		
		m_a_states[ str_type ][ str_state ] = SpawnStruct();
		
		m_a_states[ str_type ][ str_state ].n_chance = n_chance;
		m_a_states[ str_type ][ str_state ].func_state = func_state;
		m_a_states[ str_type ][ str_state ].func_validate = func_validate;
	}
	
	function wait_till_moving_complete()
	{
		self endon( "death" );
		m_vehicle endon( "death" );
		
		self flag::wait_till_clear( "moving" );
	}	
	
	function stop_movement()
	{		
		m_vehicle SetVehGoalPos( m_vehicle.origin, true, !true );
		m_vehicle CancelAIMove();		
		
		self flag::clear( "moving" );
	}
	
	function send_vehicle_to_position( v_target, b_stop_at_goal, b_slow_down = false, b_notify_within_engagement_distance = false, n_timeout = 20 )
	{
		self flag::set( "moving" );
		
		b_can_path = m_vehicle SetVehGoalPos( v_target, b_stop_at_goal, 1 );
		
		if ( b_can_path ) 
		{
			if ( b_slow_down ) 
			{
				m_vehicle SetSpeed( 10 );
			}				
			
			if ( b_notify_within_engagement_distance )
			{
				self thread _notify_within_engagement_distance();
			}
		
			self thread goal_position_show( v_target );
			
			str_result = m_vehicle util::waittill_any_timeout( n_timeout, "near_goal", "goal", "within_engagement_distance" );	
			
			m_vehicle ClearVehGoalPos();
			m_vehicle CancelAIMove();	
			
			goal_position_hide();
			
			if ( ( str_result === "timeout" ) )
			{
				debug_print( "cTigerTank: send_vehicle_to_position timed out" );
			}
			
			if ( b_slow_down ) 
			{
				// resume speed
				n_speed_max = m_vehicle GetMaxSpeed() / 17.6;
				m_vehicle SetSpeed( n_speed_max );
			}				
			
			self flag::clear( "moving" );
		}
	}
	
	function find_best_goal_position_around_target( v_target, n_search_radius_max, n_search_radius_min )
	{			
		a_position_name = Array( "street", "street_0", "street_1", "street_2" );		
		str_next_position = a_position_name[ m_n_times_retreated ];
		
		m_a_nodes = GetVehicleNodeArray( str_next_position, "script_noteworthy" );
			
		Assert( m_a_nodes.size, "cTigerTank: find_best_goal_position_around_target found no tank_path_nodes!" );
	
		s_best = array::get_closest( v_target, m_a_nodes );  // note: we don't have a code function that sorts VehicleNodes by distance
	
		return s_best;
	}
	
	function vehicle_death()  // self = vehicle
	{
		str_deathmodel = m_vehicle.deathmodel;
		
		m_vehicle waittill( "death" );
		
		m_vehicle_dead = true;
		
		stop_think();
		
		if ( IsDefined( m_vehicle ) )
		{
			// HACK: figure out how to play death fx since they're not accessible on sentient AI
			m_death = util::spawn_model( str_deathmodel, m_vehicle.origin, m_vehicle.angles );
			BadPlace_Box( "", 0, m_vehicle.origin, m_vehicle.radius, "neutral" );
			
			m_vehicle ai::set_ignoreme( true );
			m_vehicle ai::set_ignoreall( true );
			
			m_vehicle Hide();
			
			delete_gunner();
			
			wait 2; // Ruoyao said give the system 2 second to go through the assist scoring logic before deleting the vehicle.
			
			m_vehicle Delete();
			m_vehicle = undefined;
		};
	}
	
	function disable_mg_turret_on_gunner_death()
	{
		self endon( "death" );
		m_vehicle endon( "death" );
		
		m_ai_gunner waittill( "death" );
		
		stop_gunner_firing();
	}
	
	function _notify_within_engagement_distance()
	{
		self endon( "death" );
		self endon( "state_changed" );
		m_vehicle endon( "death" );
		m_vehicle endon( "goal" );
		m_vehicle endon( "near_goal" );
		
		while ( Distance( m_vehicle.origin, m_e_target.origin ) > 900 )
		{
			wait 0.25;
		}
		
		debug_print( "cTigerTank: notify - within_engagement_distance" );
		m_vehicle notify( "within_engagement_distance" );
	}
	
	function always_true()
	{
		return true;
	}
	
	function always_false()
	{
		return false;
	}
	
	function get_retreat_goal()
	{
		a_locations = Array( "street_0_retreat", "street_1_retreat", "street_2_retreat" );
		
		str_next_position = a_locations[ m_n_times_retreated ];
		
		m_a_nodes = GetVehicleNodeArray( str_next_position, "script_noteworthy" );
		
		nd_goal = array::get_farthest( m_vehicle.origin, m_a_nodes );
		
		m_n_times_retreated++;
		
		if ( m_n_times_retreated == 1 )
		{
			level notify( "tiger_tank_first_retreat" );
		}
		
		return nd_goal;
	}
	
	function get_random_goal()
	{
		a_locations = Array( "street", "street_0", "street_1", "street_2" );
		
		str_next_position = a_locations[ m_n_times_retreated ];
		
		m_a_nodes = GetVehicleNodeArray( str_next_position, "script_noteworthy" );
		
		n_random_goal_index = RandomInt( m_a_nodes.size );
		
		// try again if the current random index equals the last pick
		while ( n_random_goal_index == m_n_last_random_goal_index )
		{
			n_random_goal_index = RandomInt( m_a_nodes.size );
		}
		
		m_n_last_random_goal_index = n_random_goal_index;
			
		nd_goal = m_a_nodes[ n_random_goal_index ];
				
		return nd_goal;
	}
	
	function should_retreat()
	{
		if ( m_n_times_retreated < 2 )
		{			
			const TIME_FROM_LAST_DAMAGE_MAX = 5;
			
			n_current_time = GetTime();
			
			if ( IsDefined( m_n_time_last_damaged )  )
			{			
				n_time_since_last_damage = ( n_current_time - m_n_time_last_damaged ) * 0.001;
				
				if ( n_time_since_last_damage < TIME_FROM_LAST_DAMAGE_MAX )
				{
					b_retreat_from_damage = true;
				}
				else
				{				
					b_retreat_from_damage = false;
				}
			}
			else
			{
				b_retreat_from_damage = false;
			}
			
			b_retreat_from_low_health = ( get_vehicle_health_percentage() < 0.7 );
			b_retreated_recently = IsDefined( m_n_time_since_last_retreat ) && ( ( ( n_current_time - m_n_time_since_last_retreat ) * 0.001 ) < 5 );
			
			b_should_retreat = ( b_retreat_from_damage && b_retreat_from_low_health && !b_retreated_recently );
			
			return b_should_retreat;
		}
		else
		{
			return false;
		}
	}
	
	function get_vehicle_health_percentage()
	{
		return ( m_vehicle.health / m_vehicle.healthdefault );
	}
	
	function debug_print( str_text )
	{
		/#
			if ( GetDvarInt( "debug_tiger_tank", 0 ) )
			{
				iprintlnbold( str_text );
			}
		#/
	}
	
	function show_state_info()
	{
		self endon( "death" );
		m_vehicle endon( "death" );
		
		const DEBUG_FRAME_TIME = 2;
		
		while ( true )
		{
			if ( GetDvarInt( "debug_tiger_tank", 0 ) )
			{
				print_debug_3d( "STATE: " + m_str_state, 0, DEBUG_FRAME_TIME );
				print_debug_3d( "FIRING: " + self flag::get( "firing" ), 1, DEBUG_FRAME_TIME );
				print_debug_3d( "MOVING: " + self flag::get( "moving" ), 2, DEBUG_FRAME_TIME );
			}
			
			wait 0.1;
		}
	}
	
	function can_hit_target( v_target )
	{
		v_start = m_vehicle GetTagOrigin( "tag_barrel" );
		
		b_trace_passed = BulletTracePassed( v_start, v_target, false, m_vehicle );
		
		return b_trace_passed;
	}
	
	function print_debug_3d( str_text, n_offset_lines, n_duration )
	{
		const TEXT_SCALE = 1.5;
		const ALPHA = 1;
		
		v_offset = ( 0, 0, 120 ) + ( 0, 0, ( n_offset_lines * 25 ) );
		
		/# Print3D( ( m_vehicle.origin + v_offset ), str_text, ( 1, 1, 1 ), ALPHA, TEXT_SCALE, n_duration ); #/
	}
	
	function break_if_in_debug_mode()
	{
		/#
		if ( GetDvarInt( "debug_tiger_tank", 0 ) > 1 )
		{
			DebugBreak();
		}
		#/
	}
	
	function goal_position_show( v_goal )
	{
		self endon( "death" );
		self endon( "goal_position_hide" );
		
		/# 
			const DURATION = 1;
			
			while ( true )
			{
				show_point_with_text( v_goal, "GOAL", ( 1, 1, 1 ), DURATION );
				
				wait 0.05;
			}
		#/
	}
	
	function goal_position_hide()
	{
		/#
			self notify( "goal_position_hide" );
		#/
	}
	
	function show_point_with_text( v_goal, str_text, v_color, n_duration )
	{
		/#
		const ALPHA = 1;
		const SCALE = 1.5;		
		
		if ( GetDvarInt( "debug_tiger_tank", 0 ) )
		{
			DebugStar( v_goal, n_duration, v_color );
			Print3D( v_goal + ( 0, 0, 40 ), str_text, v_color, ALPHA, SCALE, n_duration );
		}
		#/
	}
	
	function set_field_of_view()  // self = vehicle
	{
		self.fovcosine = 0;  // 180 degrees
	}
	
	function stop_gunner_firing()
	{
		m_vehicle turret::disable( 1 );
		m_vehicle notify( "turret_disabled" + 1 );  // HACK: send this notify to kill shoot_at_target thread
	}
	
	function get_gunner_target()
	{
		// design intention: turret and gunner should NOT fire at the same target in co-op, if possible
		a_potential_targets = get_targets();
		
		if ( IsDefined( m_e_target ) )
		{
			ArrayRemoveValue( a_potential_targets, m_e_target );
		}
		
		if ( a_potential_targets.size > 0 )
		{
			e_gunner_target = ArraySort( a_potential_targets, m_vehicle.origin, true )[ 0 ];
		}
		else 
		{
			e_gunner_target = m_e_target;  // only one target, so MG and turret fire at the same thing
		}
		
		return e_gunner_target;
	}
}

