
#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
       

#namespace statemachine;

function create( name, owner, change_notify = "change_state" )
{
	state_machine = SpawnStruct();
	state_machine.name = name;
	state_machine.states = [];
	state_machine.previous_state = undefined;
	state_machine.current_state = undefined;
	state_machine.next_state = undefined;
	state_machine.change_note = change_notify;

	if ( isdefined( owner ) )
	{
		state_machine.owner = owner;
	}
	else
	{
		state_machine.owner = level;
	}

	if ( !isdefined( state_machine.owner.state_machines ) )
	{
		state_machine.owner.state_machines = [];
	}

	state_machine.owner.state_machines[ state_machine.name ] = state_machine;

	return state_machine;
}

function clear()
{
	foreach( state in self.states )
	{
		state.connections_notify = undefined;
		state.connections_utility = undefined;
	}

	self.states = undefined;
	self.previous_state = undefined;
	self.current_state = undefined;
	self.next_state = undefined;
	self.owner = undefined;

	self notify( "_cancel_connections" );
}

// self == state_machine
function add_state( name, enter_func, update_func, exit_func, reenter_func )
{
	// Setup the state
	if ( !IsDefined( self.states[ name ] ) )
	{
		self.states[ name ] = SpawnStruct();
	}

	self.states[ name ].name = name;
	self.states[ name ].enter_func = enter_func;
	self.states[ name ].exit_func = exit_func;
	self.states[ name ].update_func = update_func;
	self.states[ name ].reenter_func = reenter_func;
	self.states[ name ].connections_notify = [];
	self.states[ name ].connections_utility = [];
	self.states[ name ].owner = self;

	// Pass back so we can add connections
	return self.states[ name ];
}

function get_state( name )
{
	return self.states[ name ];
}

// self == state_machine
// interrupt connection: when the notify is received on the owner entity, and checkfunc passes (if defined), the connection is taken
// interrupt connection are meant to be interruptive state transition, "when X happens, do Y immediately"
// one notify string should only have one connection, otherwise the state transition becomes unpredictable.
// checkfunc will be called as: connectionValid = ownerEntity checkfunc( from_state_name, to_state_name, connection_struct, notify_params );
function add_interrupt_connection( from_state_name, to_state_name, on_notify, checkfunc )
{
	from_state = get_state( from_state_name );
	to_state = get_state( to_state_name );

	connection = SpawnStruct();
	connection.to_state = to_state;
	connection.type = 0;
	connection.on_notify = on_notify;
	connection.checkfunc = checkfunc;

	from_state.connections_notify[ on_notify ] = connection;

	return from_state.connections_notify[ from_state.connections_notify.size - 1 ];
}

// self == state_machine
// utility connection: the connection only happens from evaluate_connections().
// evaluate_connections() calls checkfunc on all utility connections, collect all the ones with positive scores, and choose the highest one. if all scores are zero or negative, no connection will be taken.
// utility connection are meant to use as behavioral state transition, "what do I do next?"
// if checkfunc is defined, it will be called as: connectionScore = ownerEntity checkfunc( from_state_name, to_state_name, connection_struct );
// if checkfunc is not defined, connectionScore will be DEFAULT_CONNECTION_SCORE
function add_utility_connection( from_state_name, to_state_name, checkfunc, defaultScore )
{
	from_state = get_state( from_state_name );
	to_state = get_state( to_state_name );

	connection = SpawnStruct();
	connection.to_state = to_state;
	connection.type = 1;
	connection.checkfunc = checkfunc;
	connection.score = defaultScore;
	if ( !isdefined( connection.score ) )
	{
		connection.score = 100;
	}

	if ( !isdefined( from_state.connections_utility ) ) from_state.connections_utility = []; else if ( !IsArray( from_state.connections_utility ) ) from_state.connections_utility = array( from_state.connections_utility ); from_state.connections_utility[from_state.connections_utility.size]=connection;;

	return from_state.connections_utility[ from_state.connections_utility.size - 1 ];
}

// self == state_machine
function set_state( name, state_params )
{
	// Find the state
	state = self.states[ name ];

	if ( !isdefined( self.owner ) )
	{
		return true;
	}

	// Make sure we found a valid state
	if ( !isdefined( state ) )
	{
		AssertMsg( "Could not find state named " + name + " in statemachine: " + self.name );
	}

	reenter = ( self.current_state === state );

	// If no current state then assume we are setting the first state
	if ( isdefined( self.current_state ) )
	{
		self.next_state = state;

		// Run the exit function for previous state
		if ( isdefined( self.current_state.exit_func ) )
		{
			self.owner [[ self.current_state.exit_func ]]( self.current_state.state_params );
		}

		if ( !reenter )
		{
			self.previous_state = self.current_state;
		}
		self.current_state.state_params = undefined;
	}

	if ( !isdefined( state_params ) )
	{
		state_params = SpawnStruct();
	}
	state.state_params = state_params;

	// Run reenter function 
	if ( isdefined( state.reenter_func ) && reenter )
	{
		shouldReenter = self.owner [[ state.reenter_func ]]( state.state_params );
	}
	
	if ( !reenter || shouldReenter === true )
	{
		// End any currently running update threads
		self.owner notify( self.change_note );

		// All checks passed switch states
		self.current_state = state;

		self threadNotifyConnections( self.current_state );

		// Run the enter function for the new state
		if ( isdefined( self.current_state.enter_func ) )
		{
			self.owner [[ self.current_state.enter_func ]]( self.current_state.state_params );
		}

		// Finally...thread the update function for the current state
		if ( isdefined( self.current_state.update_func ) )
		{
			self.owner thread [[ self.current_state.update_func ]]( self.current_state.state_params );
		}
	}

	return true;
}

function threadNotifyConnections( state )
{
	self notify( "_cancel_connections" );

	// Thread any notify connections
	foreach( connection in state.connections_notify )
	{
		assert( connection.type == 0 );
		self.owner thread connection_on_notify( self, connection.on_notify, connection );
	}
}

function connection_on_notify( state_machine, notify_name, connection )
{
	self endon( state_machine.change_note );
	self endon( "_cancel_connections" );

	while ( 1 )
	{
		self waittill( notify_name, param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15 );
		params = SpawnStruct();
		params.notify_param = [];
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param0;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param1;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param2;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param3;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param4;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param5;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param6;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param7;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param8;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param9;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param10;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param11;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param12;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param13;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param14;;
		if ( !isdefined( params.notify_param ) ) params.notify_param = []; else if ( !IsArray( params.notify_param ) ) params.notify_param = array( params.notify_param ); params.notify_param[params.notify_param.size]=param15;;

		connectionValid = true;
		if ( isdefined( connection.checkfunc ) )
		{
			connectionValid = self [[connection.checkfunc]]( self.current_state, connection.to_state.name, connection, params );
		}

		if ( connectionValid )
		{
			state_machine thread set_state( connection.to_state.name, params );
		}
	}
}

// self == statemachine
// the responsibility to call evaluate_connections() function is on current state's update function
// if function eval_func is not defined, connection with highest positive connectionScore will be taken
// if function eval_func is defined, it will be called as: bestConnection = ownerEntity [[eval_func]]( connectionArray, scoreArray, state ); it's the eval_func responsibility to choose and return a connection. undefined means no connection will be taken.
function evaluate_connections( eval_func, params )
{
	assert( isdefined( self.current_state ) );

	connectionArray = [];
	scoreArray = [];

	best_connection = undefined;
	best_score = -1;

	foreach ( connection in self.current_state.connections_utility )
	{
		assert( connection.type == 1 );

		score = connection.score;
		if ( isdefined( connection.checkfunc ) )
		{
			score = self.owner [[ connection.checkfunc ]]( self.current_state.name, connection.to_state.name, connection );
		}

		if ( score > 0 )
		{
			if ( !isdefined( connectionArray ) ) connectionArray = []; else if ( !IsArray( connectionArray ) ) connectionArray = array( connectionArray ); connectionArray[connectionArray.size]=connection;;
			if ( !isdefined( scoreArray ) ) scoreArray = []; else if ( !IsArray( scoreArray ) ) scoreArray = array( scoreArray ); scoreArray[scoreArray.size]=score;;

			if ( score > best_score )
			{
				best_connection = connection;
				best_score = score;
			}
		}
	}

	if ( isdefined( eval_func ) && connectionArray.size > 0 )
	{
		best_connection = self.owner [[eval_func]]( connectionArray, scoreArray, self.current_state );
	}

	if ( isdefined( best_connection ) )
	{
		self thread set_state( best_connection.to_state.name, params );
	}
}

function debugOn()
{
	dvarVal = GetDvarInt( "statemachine_debug" );

	return dvarVal;
}

