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
		case "mg42":
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



/* 
============= 
///ScriptDocBegin
"Name: ignore_triggers( <timer> )"
"Summary: Makes the entity that this is threaded on not able to set off triggers for a certain length of time."
"Module: Utility"
"CallOn: an entity"
"Example: guy thread ignore_triggers( 0.2 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
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




/*
=============
///ScriptDocBegin
"Name: giveachievement_wrapper( <achievment>, [all_players] )"
"Summary: Gives an Achievement to the specified player"
"Module: Coop"
"MandatoryArg: <achievment>: The code string for the achievement"
"OptionalArg: [all_players]: If true, then give everyone the achievement"
"Example: player giveachievement_wrapper( "MAK_ACHIEVEMENT_RYAN" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
giveachievement_wrapper( achievement, all_players )
{
	if ( achievement == "" )
	{
		return;
	}

	//no chieves in coopEPD(public demo)
//T6todo	if ( isCoopEPD() )
//T6todo	{
//T6todo		return;
//T6todo	}

/*
//T6todo
	if( !( maps\_cheat::is_cheating() ) && ! ( flag("has_cheated") ) )
	{
		if( IsDefined( all_players ) && all_players )
		{
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				players[i] GiveAchievement( achievement );
			}
		}
		else
		{
			if( !IsPlayer( self ) )
			{
				println( "^1self needs to be a player for _utility::giveachievement_wrapper()" );
				return;
			}

			self GiveAchievement( achievement );
		}
	}
*/	
}



/* 
============= 
///ScriptDocBegin
"Name: array_remove( <ents> , <remover> )"
"Summary: Returns < ents > array minus < remover > "
"Module: Array"
"CallOn: "
"MandatoryArg: <ents> : array to remove < remover > from"
"MandatoryArg: <remover> : entity to remove from the array"
"Example: ents = array_remove( ents, guy );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
array_remove( ents, remover, keepArrayKeys )
{
	newents = []; 
	// if this array is a simple numbered array - array keys will return the array in a reverse order
	// causing the array that is returned from this function to be flipped, that is an un expected 
	// result, which is why we're counting down in the for loop instead of the usual counting up
	keys = getArrayKeys( ents );

	//GLocke 2/28/08 - added ability to keep array keys from previous array
	if(IsDefined(keepArrayKeys))
	{
		for( i = keys.size - 1; i >= 0; i-- )
		{
			if( ents[ keys[ i ] ] != remover )
			{
				newents[ keys[i] ] = ents[ keys[ i ] ];
			}
		}

		return newents;
	}

	// Returns array with index of ints
	for( i = keys.size - 1; i >= 0; i-- )
	{
		if( ents[ keys[ i ] ] != remover )
		{
			newents[ newents.size ] = ents[ keys[ i ] ];
		}
	}

	return newents; 
}



/* 
============= 
///ScriptDocBegin
"Name: is_in_array( <aeCollection> , <eFindee> )"
"Summary: Returns true if < eFindee > is an entity in array < aeCollection > . False if it is not. "
"Module: Array"
"CallOn: "
"MandatoryArg: <aeCollection> : array of entities to search through"
"MandatoryArg: <eFindee> : entity to check if it's in the array"
"Example: qBool = is_in_array( eTargets, vehicle1 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
is_in_array( aeCollection, eFindee )
{
	for( i = 0; i < aeCollection.size; i++ )
	{
		if( aeCollection[ i ] == eFindee )
		{
			return( true ); 
		}
	}

	return( false ); 
}


/* 
============= 
///ScriptDocBegin
"Name: add_to_array( <array> , <ent>, <allow_dupes> )"
"Summary: Adds <ent> to <array> and returns the new array.  Will not add the new value if undefined."
"Module: Array"
"CallOn: "
"MandatoryArg:	<array> The array to add <ent> to."
"MandatoryArg:	<ent> The entity to be added."
"OptionalArg:	<allow_dupes> If true, will not add the new value if it already exists."
"Example: nodes = add_to_array( nodes, new_node );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
add_to_array( array, ent, allow_dupes )
{
	if( !IsDefined( ent ) )
	{
		return array; 
	}

	if (!IsDefined(allow_dupes))
	{
		allow_dupes = true;
	}

	if( !IsDefined( array ) )
	{
		array[ 0 ] = ent;
	}
	else if (allow_dupes || !is_in_array(array, ent))
	{
		array[ array.size ] = ent;
	}

	return array; 
}