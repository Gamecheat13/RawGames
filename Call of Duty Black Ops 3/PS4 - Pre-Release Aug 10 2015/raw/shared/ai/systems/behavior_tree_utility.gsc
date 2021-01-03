                                                                                                                                               	

#namespace BehaviorTreeNetwork;	

// ------------- BehaviorTreeScript ----------- //
function RegisterBehaviorTreeScriptAPIInternal( functionName, functionPtr )
{
	if ( !IsDefined( level._BehaviorTreeScriptFunctions ) )
	{
		level._BehaviorTreeScriptFunctions = [];
	}
	
	// SUMEET TODO - remove the need of ToLower and have the functionNames defined in .gsh
	functionName = ToLower( functionName );

	Assert( IsDefined( functionName ) && IsDefined( functionPtr ), "BT - (RegisterBehaviorTreeScriptAPI) No functionPtr defined or no functionName defined for BehaviorTreeScript." );
	Assert( !IsDefined( level._BehaviorTreeScriptFunctions[functionName] ), "BT - (RegisterBehaviorTreeScriptAPI) functionName is already defined for BehaviorTreeScript." );
	
	level._BehaviorTreeScriptFunctions[functionName] = functionPtr;
}

// ------------- BehaviorTreeAction ----------- //
function RegisterBehaviorTreeActionInternal( actionName, startFuncPtr, updateFuncPtr, terminateFuncPtr )
{	
	if ( !IsDefined( level._BehaviorTreeActions ) )
	{
		level._BehaviorTreeActions = [];
	}

	actionName = ToLower( actionName );
	
	Assert( IsString( actionName ), "BT - actionName for RegisterBehaviorTreeActionInternal is not a string." );
	Assert( !IsDefined(level._BehaviorTreeActions[actionName]), "BT - (RegisterBehaviorTreeActionInternal) actionName " + actionName + " is already registered." );
	
	level._BehaviorTreeActions[actionName] = array();
	
	// BHTN_ACTION_START
	if( IsDefined( startFuncPtr ) )
	{
		Assert( IsFunctionPtr( startFuncPtr ), "BT - BehaviorTreeAction startFuncPtr must be of type functionPtr." );
		level._BehaviorTreeActions[actionName]["bhtn_action_start"] = startFuncPtr;
	}
		 
	// BHTN_ACTION_UPDATE
	if( IsDefined( updateFuncPtr ) )
	{
		Assert( IsFunctionPtr( updateFuncPtr ), "BT - BehaviorTreeAction updateFuncPtr must be of type functionPtr." );
		level._BehaviorTreeActions[actionName]["bhtn_action_update"] = updateFuncPtr;
	}
		
	// BHTN_ACTION_TERMINATE
	if( IsDefined( terminateFuncPtr ) )
	{
		Assert( IsFunctionPtr( terminateFuncPtr ), "BT - BehaviorTreeAction terminateFuncPtr must be of type functionPtr." );
		level._BehaviorTreeActions[actionName]["bhtn_action_terminate"] = terminateFuncPtr;
	}
}

// ------------- utility----------- //
#namespace BehaviorTreeNetworkUtility;

function RegisterBehaviorTreeScriptAPI( functionName, functionPtr )
{
	BehaviorTreeNetwork::RegisterBehaviorTreeScriptAPIInternal( functionName, functionPtr );
}

function RegisterBehaviorTreeAction( actionName, startFuncPtr, updateFuncPtr, terminateFuncPtr )
{
	BehaviorTreeNetwork::RegisterBehaviorTreeActionInternal( actionName, startFuncPtr, updateFuncPtr, terminateFuncPtr );
}

