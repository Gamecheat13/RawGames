#include clientscripts\mp\_utility;


is_valid_type_for_callback(type)
{
	switch(type)
	{
		case "actor":
		case "vehicle":
		case "player":
		case "NA":
		case "general":
		case "missile":
		case "scriptmover":
		case "turret":
		case "plane":
		{
			return true;
		}
		default:
		{
			return false;
		}
	}
}


register_clientflag_callback(type, flag, function)
{
	if(!is_valid_type_for_callback(type))
	{
		AssertMsg(type + " is not a valid entity type to have a callback function registered.");
		return;
	}	
	
	if(IsDefined(level._client_flag_callbacks[type][flag]))
	{
		//reregistering the same function
		if(level._client_flag_callbacks[type][flag] == function)
		{
			return;
		}

		/#
		PrintLn("*** Free client flags for type " + type);
		
		free = "";
		
		for(i = 0; i < 16; i ++)
		{
			if(!IsDefined(level._client_flag_callbacks[type][i]))
			{
				free += i + " ";
			}
		}
		
		if(free == "")
		{
			free = "No free flags.";
		}
		
		PrintLn("*** " + free);
		#/
		AssertMsg("Flag " + flag + " is already registered for ent type " + type + ".  Please use a different flag number.  See console for list of free flags for this type.");
		return;
	}
	
	level._client_flag_callbacks[type][flag] = function;
}



/@
"Name: ignore_triggers( <timer> )"
"Summary: Makes the entity that this is threaded on not able to set off triggers for a certain length of time."
"Module: Utility"
"CallOn: an entity"
"Example: guy thread ignore_triggers( 0.2 );"
"SPMP: singleplayer"
@/ 
ignore_triggers( timer )
{
	// ignore triggers for awhile so others can trigger the trigger we're in.
	self endon( "death" ); 
	self.ignoreTriggers = true; 
	if( IsDefined( timer ) )
	{
		wait( timer ); 
	}
	else
	{
		wait( 0.5 ); 
	}
	self.ignoreTriggers = false; 
}




/@
"Name: clamp(val, val_min, val_max)"
"Summary: Clamps a value between a min and max value."
"Module: Math"
"MandatoryArg: val: the value to clamp."
"MandatoryArg: val_min: the min value to clamp to."
"MandatoryArg: val_max: the mac value to clamp to."
"Example: clamped_val = clamp(8, 0, 5); // returns 5	*	clamped_val = clamp(-1, 0, 5); // returns 0"
"SPMP: both"
@/ 
clamp(val, val_min, val_max)
{
	if (val < val_min)
	{
		val = val_min;
	}
	else if (val > val_max)
	{
		val = val_max;
	}

	return val;
}



is_mature()
{
	if ( level.onlineGame )
		return true;

	return IsMatureContentEnabled();
}

is_german_build()
{
	if( GetDvar( "language" ) == "german" )
	{
		return true;
	}
	return false;
}




////////////////////////////// Callbacks ////////////////////////////////////////////

Callback(event,clientNum)
{
	if (IsDefined(level._callbacks) && IsDefined(level._callbacks[event]))
	{
		for (i = 0; i < level._callbacks[event].size; i++)
		{
			callback = level._callbacks[event][i];
			if (IsDefined(callback))
			{
				self thread [[callback]](clientNum);
			}
		}
	}
}


OnPlayerConnect_Callback(func)
{
	clientscripts\mp\_callbacks::AddCallback("on_player_connect", func);
}


