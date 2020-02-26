#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_statemachine.gsh;

create_state_machine( name, owner, change_notify = "change_state" )
{
	state_machine = SpawnStruct();
	state_machine.name = name;
	state_machine.states = [];
	state_machine.current_state = undefined;
	state_machine.next_state = undefined;
	state_machine.change_note = change_notify;
	
	if ( IsDefined( owner ) )
		state_machine.owner = owner;
	else
		state_machine.owner = level;		
	
	
	if (!isDefined(state_machine.owner.state_machines))
		state_machine.owner.state_machines = [];
	
	
	state_machine.owner.state_machines[state_machine.owner.state_machines.size] = state_machine;
	
	return state_machine;
}

// self == state_machine
add_state( name, enter_func, exit_func, update_func, can_enter_func, can_exit_func )
{
	// Setup the state
	state = SpawnStruct();
	state.name = name;
	state.enter_func = enter_func;
	state.exit_func = exit_func;
	state.update_func = update_func;
	state.can_enter_func = can_enter_func;
	state.can_exit_func = can_exit_func;	
	state.connections = [];
	
	// Add to the states list
	self.states[ self.states.size ] = state;
	
	// Pass back so we can add connections
	return state;
}

// self == state
add_connection( name, to_state, priority, check_func, param1, param2 )
{
	// setup connection
	connection = SpawnStruct();
	connection.to_state = to_state;
	connection.check_func = check_func;
	connection.param1 = param1;
	connection.param2 = param2;	
	connection.priority = priority;
	
	// Add to connections list
	self.connections[ self.connections.size ] = connection;
}

// self == state
add_connection_by_type( to_state, priority, type, compare_type, param1 )
{
	// setup connection
	connection = SpawnStruct();
	connection.to_state = to_state;		
	connection.priority = priority;
	connection.type = type;
	connection.param1 = param1;
	connection.param2 = compare_type;
	
	switch ( type )
	{
		case CONNECTION_TYPE_ENEMY_DIST:
		{
			connection.check_func = ::connection_enemy_dist;
			break;
		}
			
		case CONNECTION_TYPE_ENEMY_VISIBLE:
		{
			connection.check_func = ::connection_enemy_visible;
			break;
		}

		case CONNECTION_TYPE_ENEMY_VALID:
		{
			connection.check_func = ::connection_enemy_valid;
			break;
		}
			
		case CONNECTION_TYPE_ENEMY_ANGLE:
		{
			connection.check_func = ::connection_enemy_angle;
			break;
		}
			
		case CONNECTION_TYPE_ENEMY_HEALTH_PCT:
		{
			connection.check_func = ::connection_enemy_health_pct;
			break;
		}
			
		case CONNECTION_TYPE_HEALTH_PCT:
		{
			connection.check_func = ::connection_health_pct;
			break;
		}			

		case CONNECTION_TYPE_ON_NOTIFY:
		{
			break;
		}
			
		case CONNECTION_TYPE_TIMER:
		{
			break;			
		}
			
		default:
			AssertMsg( "Unknown Connection Type: " + type );
	}
	
	// Add to connections list
	self.connections[ self.connections.size ] = connection;
}

// self == state_machine
set_state( name )
{
	// Find the state
	state = undefined;
	for ( i = 0; i < self.states.size; i++ )
	{
		if ( self.states[i].name == name )
		{
			state = self.states[i];
			break;
		}
	}
	
	// Make sure we found a valid state
	if ( !IsDefined( state ) )
		AssertMsg( "Could not find state named " + name + " in statemachine: " + self.name );
	
	// If no current state then assume we are setting the first state
	if ( !IsDefined( self.current_state ) )
	{
		self.current_state = state;
		
		// run the enter function
		if ( IsDefined( self.current_state.enter_func ) )
		{
			self.owner [[ self.current_state.enter_func ]]();
		}
		
		// Thread the update function
		if ( IsDefined( self.current_state.update_func ) )
		{
			self.owner thread [[ self.current_state.update_func]]();
		}

		// Thread any notify connections
		for ( j = 0; j < self.current_state.connections.size; j++ )
		{
			if ( IsDefined( self.current_state.connections[j].type ) )
			{
				if ( self.current_state.connections[j].type == CONNECTION_TYPE_ON_NOTIFY )
				{
					if ( IsDefined( self.owner ) )
					{
						self.owner thread connection_on_notify( self, self.current_state.connections[j].param1, self.current_state.connections[j] );
					}				
				}
				else if ( self.current_state.connections[j].type == CONNECTION_TYPE_TIMER )
				{
					self.owner thread connection_timer( self, self.current_state.connections[j].param1, self.current_state.connections[j] );					
				}
			}	
		}
	}
	else	
	{
		// We are currently in a state...check to see if we can exit this state
		if ( IsDefined( self.current_state.can_exit_func ) )
		{
			if ( !self.owner [[ self.current_state.can_exit_func ]]() )
				return;
		}
		
		// Check to see if we can enter the new state
		if ( IsDefined( state.can_enter_func ) )
		{
			if ( !self.owner [[ state.can_enter_func ]]() )
				return;			
		}
		
		// All checks passed switch states
		previous_state = self.current_state;
		self.current_state = state;
		
		// Run the exit function for previous state
		if ( IsDefined( previous_state.exit_func ) )
		{
			self.owner [[ previous_state.exit_func ]]();
		}
		
		// Run the enter function for the new state
		if ( IsDefined( self.current_state.enter_func ) )
		{
			self.owner [[ self.current_state.enter_func ]]();
		}
		
		// End any currently running update threads
		self.owner notify( self.change_note );

		// Thread any notify connections
		for ( j = 0; j < self.current_state.connections.size; j++ )
		{
			if ( IsDefined( self.current_state.connections[j].type ) )
			{
				if ( self.current_state.connections[j].type == CONNECTION_TYPE_ON_NOTIFY )
				{
					if ( IsDefined( self.owner ) )
					{
						self.owner thread connection_on_notify( self, self.current_state.connections[j].param1, self.current_state.connections[j] );
					}				
				}
				else if ( self.current_state.connections[j].type == CONNECTION_TYPE_TIMER )
				{
					if ( IsDefined( self.owner ) )
					{
						self.owner thread connection_timer( self, self.current_state.connections[j].param1, self.current_state.connections[j] );
					}					
				}
			}	
		}		
		
		// Finally...thread the update function for the current state
		if ( IsDefined( self.current_state.update_func ) )
		{
			self.owner thread [[ self.current_state.update_func ]]();
		}
	}
}

update_state_machine( dt )
{
	self.owner endon( "death" );
	self endon( "stop_state_machine_" + self.name );
	
	// If an update rate wasn't specified assume every frame
	if ( !IsDefined( dt ) )
		dt = 0.05;
	
	while ( 1 )
	{
		Assert( IsDefined( self.current_state ), "Trying to update statemachine: " + self.name + " but it has no current state." );
		
		// Check connections
		best_priority = -1;
		best_connection = undefined;
		connections = self.current_state.connections;
		for ( i = 0; i < connections.size; i++ )
		{
			// Check to see if this is a "user" defined check connection
			if ( IsDefined( connections[i].check_func ) )
			{
				if ( self.owner [[ connections[i].check_func ]]( connections[i].param1, connections[i].param2 ) )
				{
					if ( connections[i].priority > best_priority )
					{
						best_priority = connections[i].priority;
						best_connection = connections[i];
					}
				}
			}
		}
		
		if ( IsDefined( best_connection ) )
		{
			self set_state( best_connection.to_state );
		}

		if( debugOn() == 1 )
		{
			/#
				Print3d( self.owner.origin, "["+ self.name + "] State: " + self.current_state.name, ( 1, 1, 1 ), 1, 2, 1 );
			#/
		}
		else
		if( debugOn() == 2 )
		{
		/#
			for(i=0;i<self.owner.state_machines.size;i++)
			{
				machine = self.owner.state_machines[i];
				Print3d( machine.owner.origin +(0,0,30*i), "["+ machine.name + "] State: " + machine.current_state.name, ( 1, 1, 1 ), 1, 2, 1 );
			}
		#/
		}
		
		wait( dt );
	}
}

debugOn()
{
	dvarVal = GetDvarInt( "statemachine_debug" );
	
	return dvarVal;
}

//---------------------------------------------------------
// 
// Some Useful Generic Connections
//
//---------------------------------------------------------
connection_enemy_dist( check_dist, compare_type )
{
	if ( !IsDefined( self.enemy ) )
		return false;
	
	dist = Distance( self.origin, self.enemy.origin );
	
	if ( compare_type == LESS_THAN )
		return dist < check_dist;
	else if ( compare_type == GREATER_THAN )
		return dist > check_dist;
	else if ( compare_type == EQUAL_TO )
		return dist == check_dist;
	else if ( compare_type == LESS_THAN_OR_EQUAL_TO )
		return dist <= check_dist;
	else if ( compare_type == GREATER_THAN_OR_EQUAL_TO )
		return dist >= check_dist;

	return false;
}

connection_enemy_visible( trace_height_offset, compare_type )
{
	if ( !IsDefined( self.enemy ) )
		return false;
	
//	if ( !IsDefined( trace_height_offset ) )
//		trace_height_offset = 0;
//	
//	start = self.origin + ( 0, 0, trace_height_offset );
//	end = self.enemy.origin + ( 0, 0, trace_height_offset );
//	
//	return ( compare_type == TRUE ? BulletTracePassed( start, end, true, self ) : !BulletTracePassed( start, end, true, self ) );

	if ( IsDefined( self.maxsightdistance ) )
	{
		//return ( compare_type == TRUE ? self VehCanSee( self.enemy ) && Distance2D( self.origin, self.enemy.origin ) < self.maxsightdistance : !self VehCanSee( self.enemy ) || Distance2D( self.origin, self.enemy.origin ) > self.maxsightdistance );		
		
		if ( compare_type == TRUE )
		{
			if ( self VehCanSee( self.enemy ) && Distance2D( self.origin, self.enemy.origin ) < self.maxsightdistance )
				return true;
			else
				return false;
		}
		else
		{
			if ( !self VehCanSee( self.enemy ) || Distance2D( self.origin, self.enemy.origin ) > self.maxsightdistance )
				return true;
			else
				return false;			
		}
	}
	
	return ( compare_type == TRUE ? self VehCanSee( self.enemy ) : !self VehCanSee( self.enemy ) );	
}

connection_enemy_valid( param1, param2 )
{
	return IsDefined( self.enemy );
}

connection_enemy_angle( check_angle, compare_type )
{
	if ( !IsDefined( self.enemy ) )
		return false;	
	
	forward = AnglesToForward( self.angles );
	vec_to_enemy = VectorNormalize( self.enemy.origin - self.origin );
	
	dot = VectorDot( forward, vec_to_enemy );
	angle = ACos( dot );

	if ( compare_type == LESS_THAN )
		return angle < check_angle;
	else if ( compare_type == GREATER_THAN )
		return angle > check_angle;
	else if ( compare_type == EQUAL_TO )
		return angle == check_angle;
	else if ( compare_type == LESS_THAN_OR_EQUAL_TO )
		return angle <= check_angle;
	else if ( compare_type == GREATER_THAN_OR_EQUAL_TO )
		return angle >= check_angle;
	
	return false;
}

connection_on_notify(state_machine, notify_name, connection )
{
	self endon( state_machine.change_note );

	while( 1 )
	{
		self waittill( notify_name, param );
		state_machine thread set_state( connection.to_state );
	}
}

connection_enemy_health_pct( check_pct, compare_type )
{
	if ( !IsDefined( self.enemy ) )
		return false;

	health_pct = ( self.enemy.health / self.enemy.maxhealth ) * 100;

	if ( compare_type == LESS_THAN )
		return health_pct < check_pct;
	else if ( compare_type == GREATER_THAN )
		return health_pct > check_pct;
	else if ( compare_type == EQUAL_TO )
		return health_pct == check_pct;
	else if ( compare_type == LESS_THAN_OR_EQUAL_TO )
		return health_pct <= check_pct;
	else if ( compare_type == GREATER_THAN_OR_EQUAL_TO )
		return health_pct >= check_pct;
	
	return false;	
}


connection_health_pct( check_pct, compare_type )
{
	health_pct = ( self.health / self.maxhealth ) * 100;

	if ( compare_type == LESS_THAN )
		return health_pct < check_pct;
	else if ( compare_type == GREATER_THAN )
		return health_pct > check_pct;
	else if ( compare_type == EQUAL_TO )
		return health_pct == check_pct;
	else if ( compare_type == LESS_THAN_OR_EQUAL_TO )
		return health_pct <= check_pct;
	else if ( compare_type == GREATER_THAN_OR_EQUAL_TO )
		return health_pct >= check_pct;
	
	return false;	
}

connection_timer( state_machine, time, connection )
{
	self endon( state_machine.change_note );
	
	wait( time );
	state_machine thread set_state( connection.to_state );
}







