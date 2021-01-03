// Created and Implemented by Sumeet Jakatdar
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                         	                                                                           	                                                                                   	       



	
#namespace BehaviorStateMachine;

// ------------- Behavior State Machine Script API registration ----------- //
function RegisterBSMScriptAPIInternal( functionName, scriptFunction )
{
	if ( !IsDefined( level._bsmscriptfunctions ) )
	{
		level._bsmscriptfunctions = [];
	}
	
	// SUMEET TODO - remove the need of ToLower and have the functionNames defined in .gsh
	functionName = ToLower( functionName );

	Assert( IsDefined( scriptFunction ) && IsDefined( scriptFunction ), "BT - (RegisterBSMScriptAPI) No functionPtr defined or no functionName defined for BSMScript." );
	Assert( !IsDefined( level._bsmscriptfunctions[functionName] ), "BT - (RegisterBSMScriptAPI) functionName is already defined for BSMScript." );
	
	level._bsmscriptfunctions[functionName] = scriptFunction;
}

/*

class BehaviorState
{
	var stateName;
	
	var asmStateName;
	
	var initFunc;
	var updateFunc;
	var terminateFunc;
	
	var connections;
	
	constructor()
	{
		connections = [];
	}
	
	destructor()
	{
		
	}
	
	function GetConnections()
	{
		return connections;
	}
}

class BehaviorConnection
{
	var connectionName;
	var toState;
	var conditionFunc;
	var endOfStateConnection;
	
	var asmState;
	
	constructor()
	{
		toState = NULL;
	}
	
	destructor()
	{
		
	}
}
	
class BSM
{
	var stateMachineName;
	var states;
	var miscData;
	
	var currentState;
	var previousState;
		
	constructor()
	{
		states = [];
	}
	
	destructor()
	{
		
	}
	
	function AddState( stateName, asmStateName, initFunc, updateFunc, terminateFunc )
	{
		assert( !IsDefined( states[stateName] ), "BSM - State is already defined " + stateName );
		
		states[stateName] = new BehaviorState();
		
		states[stateName].initFunc = initFunc;
		states[stateName].updateFunc = updateFunc;
		states[stateName].terminateFunc = terminateFunc;		
		
		states[stateName].asmStateName = asmStateName;		
		states[stateName].stateName = stateName;
	}
	
	function AddConnection( connectionName, fromState, toState, conditionFunc, endOfStateConnection, asmState )
	{
		assert( IsDefined( states[fromState] ), "BSM - State is not defined " + fromState );
		assert( IsDefined( states[toState] ), "BSM - State is not defined " + toState );
		assert( !IsDefined( states[fromState].connections[connectionName] ), "BSM - Connection is already defined " + connectionName );
		
		states[fromState].connections[connectionName] = new BehaviorConnection();
		
		states[fromState].connections[connectionName].toState = toState;
		states[fromState].connections[connectionName].conditionFunc = conditionFunc;
		states[fromState].connections[connectionName].connectionName = connectionName;
		states[fromState].connections[connectionName].endOfStateConnection = endOfStateConnection;
		
		states[fromState].connections[connectionName].asmState = asmState;
	}
	
	function GetStates()
	{
		return states;
	}
}

function CreateBSM( archetypeName, stateMachineName )
{
	if( !IsDefined( level.__BSMs ) )
	{
		level.__BSMs = [];
	}
	
	if( !IsDefined( level.__BSMs[archetypeName] ) )
	{
		level.__BSMs[archetypeName] = [];
	}  
	
	assert( !IsDefined( level.__BSMs[archetypeName][stateMachineName] ) );
	
	newStateMachine = new BSM();	
	newStateMachine.stateMachineName = stateMachineName;
	
	level.__BSMs[archetypeName][stateMachineName] = newStateMachine;
		
	return level.__BSMs[archetypeName][stateMachineName];
}

function StartBSM( entity, stateMachineName )
{
	assert( IsDefined( level.__BSMs[entity.archetype][stateMachineName] ) );
	
	stateMachine = level.__BSMs[entity.archetype][stateMachineName];
	
	assert( !IsDefined( stateMachine.currentState ) );
	assert( !IsDefined( stateMachine.previousState ) );
			
	// go through the states, find the first fit
	foreach ( state in stateMachine.states )
	{
		if( !IsDefined( state.initFunc ) )
		{
			if( IsDefined( state.asmStateName ) )
		    {
				newState = state;
				break;
			}
		}
		else
		{
			validState = [[state.initFunc]]( entity );
			
			if( validState )
			{
				// found one state which has a valid ASM, set it as a current substate
				if( IsDefined( state.asmStateName ) )
			    {
					newState = state;				
					break;
				}
			}
		}		   
	}
	
	if( IsDefined( newState ) )
	{
		stateMachine.currentState = newState;
		AnimationStateNetworkUtility::RequestState( entity, newState.asmStateName );
		return BHTN_RUNNING;
	}
	
	return BHTN_SUCCESS;
}

function UpdateBSM( entity, stateMachineName )
{
	assert( IsDefined( level.__BSMs[entity.archetype][stateMachineName] ) );
	
	stateMachine = level.__BSMs[entity.archetype][stateMachineName];
		
	assert( IsDefined( stateMachine.currentState ) );
	
	// run the update function for the current state
	currentStateUpdatedResult = true;
	if( IsDefined( stateMachine.currentState.updateFunc ) )
	{
		currentStateUpdatedResult = [[stateMachine.currentState.updateFunc]]( entity );
	}
	
	// We have a valid running state, go through all the connections ( if there are any )	
	connections = [[stateMachine.currentState]]->GetConnections();
	
	if( !connections.size )
	{
		if( entity ASMGetStatus() == ASM_STATE_COMPLETE )
		{
			TerminateBSM( entity, stateMachineName );
			return BHTN_SUCCESS;
		}
	}
	else 
	{
		nextValidState = undefined;
		
		foreach ( connection in connections )
		{
			// execute endOfStateConnection only when current state is complete or is not valid anymore
			if( IS_TRUE( connection.endOfStateConnection ) 
			   && ( entity ASMGetStatus() != ASM_STATE_COMPLETE || !currentStateUpdatedResult )
			  )
			{
				/#RecordEntText( "EndOfStateConnection :" + connection.connectionName, entity, RED, "Animscript" );#/
				continue;
			}
			
			if( IsDefined( connection.conditionFunc ) )
		    {					
				// check if the connection is valid
				validConnection = [[connection.conditionFunc]]( entity );

				if( !IsDefined( validConnection ) )
					validConnection = true;
				
				// Connection is valid, check if the toState has any condition associated with it, and execute it
				if( validConnection )
				{
					/#RecordEntText( "Connection :" + connection.connectionName, entity, GREEN, "Animscript" );#/
						
					if( !IsDefined( stateMachine.states[connection.toState].initFunc ) )
					{						
				   		nextValidState = stateMachine.states[connection.toState];
				   		break;
					}
					else 
					{
						validToState = [[stateMachine.states[connection.toState].initFunc]]( entity );
						
						if( validToState )
						{							
							nextValidState = stateMachine.states[connection.toState];	
							break;
						}
						else
						{
							/#RecordEntText( "ToState :" + stateMachine.states[connection.toState].stateName, entity, RED, "Animscript" );#/
						}
					}
				}
				else
				{
					/#RecordEntText( "Connection :" + connection.connectionName, entity, RED, "Animscript" );#/
				}
			}
			else
			{
				/#RecordEntText( "Connection :" + connection.connectionName, entity, GREEN, "Animscript" );#/
					
				if( !IsDefined( stateMachine.states[connection.toState].initFunc ) )
				{						
			   		nextValidState = stateMachine.states[connection.toState];
			   		break;
				}
				else 
				{
					validToState = [[stateMachine.states[connection.toState].initFunc]]( entity );
					
					if( validToState )
					{							
						nextValidState = stateMachine.states[connection.toState];	
						break;
					}
					else
					{
						/#RecordEntText( "ToState :" + stateMachine.states[connection.toState].stateName, entity, RED, "Animscript" );#/
					}
				}
			}
		}
		
		// found a validNextState with ValidConnection, go there now
		if( IsDefined( nextValidState ) )
		{
			// found a new valid state, execute terminateFunc of the current state
			if( IsDefined( stateMachine.currentState.terminateFunc ) )
			{
				[[stateMachine.currentState.terminateFunc]]( entity );
			}
			
			/#RecordEntText( "ToState :" + stateMachine.states[connection.toState].stateName, entity, GREEN, "Animscript" );#/
				
			stateMachine.previousState = stateMachine.currentState;
			stateMachine.currentState = nextValidState;
			
			assert( IsDefined( nextValidState.asmStateName ) );
			
			AnimationStateNetworkUtility::RequestState( entity, nextValidState.asmStateName );
						
			return BHTN_RUNNING;	
		}
		else
		{
			/#RecordEntText( "ToState :" + stateMachine.states[connection.toState].stateName, entity, RED, "Animscript" );#/
		}
	}

	// if there is no better connection, just update the current substate
	if( entity ASMGetStatus() == ASM_STATE_COMPLETE )
	{
		TerminateBSM( entity, stateMachineName );
		return BHTN_SUCCESS;
	}
	else
	{
		/#RecordEntText( "CurrentState :" + stateMachine.currentState.stateName, entity, BLUE, "Animscript" );#/
	}
	
	return BHTN_RUNNING;		
}

function TerminateBSM( entity, stateMachineName )
{
	assert( IsDefined( level.__BSMs[entity.archetype][stateMachineName] ) );	
	
	stateMachine = level.__BSMs[entity.archetype][stateMachineName];
	
	// state machine is terminating and returning control to behavior tree, call terminateFunc of the current state
	if( IsDefined(  stateMachine.currentState ) && IsDefined( stateMachine.currentState.terminateFunc ) )
	{
		[[stateMachine.currentState.terminateFunc]]( entity );
	}
	
	stateMachine.currentState = undefined;
	stateMachine.previousState = undefined;
	
	return BHTN_SUCCESS;
}

*/