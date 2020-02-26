#include clientscripts\_utility_code; 
#include clientscripts\_fx; 

#insert raw\common_scripts\utility.gsh;

/#
error( message )
{
	println( "^c * ERROR * ", message );
	wait 0.05;
 }
#/
	
// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to( IE: can't do 5.struct_array_index ) 
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object



getstruct( name, type )
{
	if(!IsDefined( level.struct_class_names ) )
		return undefined;
	
	array = level.struct_class_names[ type ][ name ];
	if( !IsDefined( array ) )
	{
		/#println("**** Getstruct returns undefined on " + name + " : " + " type.");#/
		return undefined; 
	}

	if( array.size > 1 )
	{
		assertMsg( "getstruct used for more than one struct of type " + type + " called " + name + "." );
		return undefined; 
	}
	return array[ 0 ];
}

/@
"Name: getstructarray( <name> , <type )"
"Summary: gets an array of script_structs"
"Module: Array"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <type>: "
"Example: fxemitters = getstructarray( "streetlights" , "targetname" )"
"SPMP: singleplayer"
@/
getstructarray( name, type )
{
	assert( IsDefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

	array = level.struct_class_names[type][name]; 
	if(!IsDefined( array ) )
	{
		return []; 
	}
	else
	{
		return array; 
	}
}

/@
"Name: play_sound_in_space( <clientNum>, <alias> , <origin>  )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: Level"
"MandatoryArg: <clientNum> : local client to hear the sound."
"MandatoryArg: <alias> : Sound alias to play"
"MandatoryArg: <origin> : Origin of the sound"
"Example: play_sound_in_space( "siren", level.speaker.origin );"
"SPMP: singleplayer"
@/ 
play_sound_in_space( localClientNum, alias, origin)
{
	PlaySound( localClientNum, alias, origin); 
}

//-- Vectors --//

vector_compare(vec1, vec2)
{
	return (abs(vec1[0] - vec2[0]) < .001) && (abs(vec1[1] - vec2[1]) < .001) && (abs(vec1[2] - vec2[2]) < .001);
}

/@
"Name: array_func( <array>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
"Summary: Runs the < func > function on every entity in the < array > array. The item will become "self" in the specified function. Each item is run through the function sequentially."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : array of entities to run through <func>"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: array_func( GetAIArray( "allies" ), ::set_ignoreme, false );"
"SPMP: sp"
@/ 
array_func(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	if (!IsDefined( entities ))
	{
		return;
	}

	if (IsArray(entities))
	{
		if (entities.size)
		{
			keys = GetArrayKeys( entities );
			for (i = 0; i < keys.size; i++)
			{
				single_func(entities[keys[i]], func, arg1, arg2, arg3, arg4, arg5);
			}
		}
	}
	else
	{
		single_func(entities, func, arg1, arg2, arg3, arg4, arg5);
	}
}


/@
"Name: single_func( <entity>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
"Summary: Runs the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: "
"MandatoryArg: <entity> : the entity to run through <func>"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: single_func( guy, ::set_ignoreme, false );"
"SPMP: sp"
@/ 
single_func(entity, func, arg1, arg2, arg3, arg4, arg5)
{
	if (IsDefined(arg5))
	{
		entity [[ func ]](arg1, arg2, arg3, arg4, arg5);
	}
	else if (IsDefined(arg4))
	{
		entity [[ func ]](arg1, arg2, arg3, arg4);
	}
	else if (IsDefined(arg3))
	{
		entity [[ func ]](arg1, arg2, arg3);
	}
	else if (IsDefined(arg2))
	{
		entity [[ func ]](arg1, arg2);
	}
	else if (IsDefined(arg1))
	{
		entity [[ func ]](arg1);
	}
	else
	{
		entity [[ func ]]();
	}
}


/@
"Name: array_thread( <entities> , <func> , <arg1> , <arg2> , <arg3> )"
"Summary: Threads the < func > function on every entity in the < entities > array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities> : array of entities to thread the process"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: array_thread( GetAIArray( "allies" ), ::set_ignoreme, false );"
"SPMP: both"
@/ 
array_thread( entities, func, arg1, arg2, arg3, arg4, arg5 )
{
	if (!IsDefined( entities ))
	{
		return;
	}

	if (IsArray(entities))
	{
		if (entities.size)
		{
			keys = GetArrayKeys( entities );
			for (i = 0; i < keys.size; i++)
			{
				single_thread(entities[keys[i]], func, arg1, arg2, arg3, arg4, arg5);
			}
		}
	}
	else
	{
		single_thread(entities, func, arg1, arg2, arg3, arg4, arg5);
	}
}


/@
"Name: single_thread( <entity>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
"Summary: Threads the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: "
"MandatoryArg: <entity> : the entity to thread <func> on"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: single_func( guy, ::special_ai_think, "some_string", 345 );"
"SPMP: sp"
@/ 
single_thread(entity, func, arg1, arg2, arg3, arg4, arg5)
{
	if (IsDefined(arg5))
	{
		entity thread [[ func ]](arg1, arg2, arg3, arg4, arg5);
	}
	else if (IsDefined(arg4))
	{
		entity thread [[ func ]](arg1, arg2, arg3, arg4);
	}
	else if (IsDefined(arg3))
	{
		entity thread [[ func ]](arg1, arg2, arg3);
	}
	else if (IsDefined(arg2))
	{
		entity thread [[ func ]](arg1, arg2);
	}
	else if (IsDefined(arg1))
	{
		entity thread [[ func ]](arg1);
	}
	else
	{
		entity thread [[ func ]]();
	}
}

//-- Arrays --//


/@
"Name: add_to_array( <array> , <ent>, <allow_dupes> )"
"Summary: Adds <ent> to <array> and returns the new array.  Will not add the new value if undefined."
"Module: Array"
"CallOn: "
"MandatoryArg:	<array> The array to add <ent> to."
"MandatoryArg:	<ent> The entity to be added."
"OptionalArg:	<allow_dupes> If true, will not add the new value if it already exists."
"Example: nodes = add_to_array( nodes, new_node );"
"SPMP: singleplayer"
@/ 
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
	else if (allow_dupes || !IsInArray(array, ent))
	{
		array[ array.size ] = ent;
	}

	return array; 
}

/@
"Name: array_delete( <array> )"
"Summary: Delete all the elements in an array"
"Module: Array"
"MandatoryArg: <array> : The array whose elements to delete."
"Example: array_delete( GetAIArray( "axis" ) );"
"SPMP: singleplayer"
@/ 
array_delete( array )
{
	for( i = 0; i < array.size; i++ )
	{
		array[ i ] delete();
	}
}

/@
"Name: array_randomize( <array> )"
"Summary: Randomizes the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array to be randomized."
"Example: roof_nodes = array_randomize( roof_nodes );"
"SPMP: singleplayer"
@/ 
array_randomize( array )
{
	for( i = 0; i < array.size; i++ )
	{
		j = RandomInt( array.size ); 
		temp = array[ i ];
		array[ i ] = array[ j ];
		array[ j ] = temp;
	}

	return array; 
}

/@
"Name: array_reverse( <array> )"
"Summary: Reverses the order of the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array to be reversed."
"Example: patrol_nodes = array_reverse( patrol_nodes );"
"SPMP: singleplayer"
@/ 
array_reverse( array )
{
	array2 = [];
	for( i = array.size - 1; i >= 0; i-- )
	{
		array2[ array2.size ] = array[ i ];
	}

	return array2;
}


/@
"Name: array_exclude( <array> , <arrayExclude> )"
"Summary: Returns an array excluding all members of < arrayExclude > "
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array containing all items"
"MandatoryArg: <arrayExclude> : Arary containing all items to remove"
"Example: newArray = array_exclude( array1, array2 );"
"SPMP: singleplayer"
@/ 
array_exclude( array, arrayExclude )// returns "array" minus all members of arrayExclude
{
	newarray = ArrayCopy(array);
	for( i = 0;i < arrayExclude.size;i++ )
	{
		ArrayRemoveValue( newarray, arrayExclude[ i ] );
	}

	return newarray;
}

array_notify( ents, notifier )
{
	for( i = 0;i < ents.size;i++ )
		ents[ i ] notify( notifier );
}

/@
"Name: array_wait( <array>, <msg>, <timeout> )"
"Summary: waits for every entry in the <array> to recieve the <msg> notify, die, or timeout"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <msg>: the msg each array entity will wait on"
"OptionalArg: <timeout>: timeout to kill the wait prematurely"
"Example: array_wait( guys, "at the hq" );"
"SPMP: singleplayer"
@/
array_wait(array, msg, timeout)
{	
	keys = getarraykeys(array);	
	structs = [];

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		structs[ key ] = spawnstruct();
		structs[ key ]._array_wait = true;	

		structs[ key ] thread array_waitlogic1( array[ key ], msg, timeout );
	}

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		if( IsDefined( array[ key ] ) && structs[ key ]._array_wait)
		{
			structs[ key ] waittill( "_array_wait" );	
		}
	}
}

array_waitlogic1( ent, msg, timeout )
{
	self array_waitlogic2( ent, msg, timeout );	

	self._array_wait = false;
	self notify( "_array_wait" );
}

array_waitlogic2( ent, msg, timeout )
{
	ent endon( msg );
	ent endon( "death" );

	if( isdefined( timeout ) )
	{
		wait timeout;
	}
	else
	{
		ent waittill( msg );
	}
}

// MikeD (3/20/2007): Checks the array if the "single" already exists, if so it returns false.
array_check_for_dupes( array, single )
{
	for( i = 0; i < array.size; i++ )
	{
		if( array[i] == single )
		{
			return false;
		}
	}

	return true;
}

// Lucas (5/22/2008) added an array_swap for easy quicksorting
array_swap( array, index1, index2 )
{
	assert( index1 < array.size, "index1 to swap out of range" );
	assert( index2 < array.size, "index2 to swap out of range" );

	temp = array[index1];
	array[index1] = array[index2];
	array[index2] = temp;

	return array;
}

/@
"Name: random( <array> )"
"Summary: returns a random element from the passed in array "
"Module: Array"
"Example: random_spawner = random( event_1_spawners );"
"MandatoryArg: <array> : the array from which to pluck a random element"
"SPMP: singleplayer"
@/ 
random( array )
{
	return array [ randomint( array.size ) ];
}

registerSystem(sSysName, cbFunc)
{
	if(!IsDefined(level._systemStates))
	{
		level._systemStates = [];
	}
	
	if(level._systemStates.size >= 32)	
	{
		/#error("Max num client systems exceeded.");#/
		return;
	}
	
	if(IsDefined(level._systemStates[sSysName]))
	{
		/#error("Attempt to re-register client system : " + sSysName);#/
		return;
	}
	else
	{
		level._systemStates[sSysName] = spawnstruct();
		level._systemStates[sSysName].callback = cbFunc;
	}	
}

loop_sound_Delete( ender, entId )
{
//	ent endon( "death" ); 
	self waittill( ender ); 
	deletefakeent(0, entId); 
}

loop_fx_sound( clientNum, alias, origin, ender )
{
	entId = spawnfakeent(clientNum);

	if( IsDefined( ender ) )
	{
		thread loop_sound_Delete( ender, entId ); 
		self endon( ender ); 
	}
	
	setfakeentorg(clientNum, entId, origin);
	playloopsound( clientNum, entId, alias ); 
}

waitforallclients()
{
	localClient = 0;
	while (localClient < level.localPlayers.size)
	{
		waitforclient(localClient);
		localClient++;
	}
}

waitforclient(client)
{
	while(!clienthassnapshot(client))
	{
		wait(0.01);
	}
	//syncsystemstates(client);	
}

waittill_string( msg, ent )
{
	if ( msg != "death" )
		self endon ("death");

	ent endon ( "die" );
	self waittill ( msg );
	ent notify ( "returned", msg );
}

/@
"Name: waittill_any_return( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for any of the the specified notifies and return which one it got."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: which_notify = guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: singleplayer"
@/
waittill_any_return( string1, string2, string3, string4, string5, string6, string7 )
{
	if ((!IsDefined (string1) || string1 != "death") &&
		(!IsDefined (string2) || string2 != "death") &&
		(!IsDefined (string3) || string3 != "death") &&
		(!IsDefined (string4) || string4 != "death") &&
		(!IsDefined (string5) || string5 != "death") &&
		(!IsDefined (string6) || string6 != "death") &&		
		(!IsDefined (string7) || string7 != "death"))
		self endon ("death");

	ent = SpawnStruct();

	if (IsDefined(string1))
		self thread waittill_string(string1, ent);

	if (IsDefined(string2))
		self thread waittill_string(string2, ent);

	if (IsDefined(string3))
		self thread waittill_string(string3, ent);

	if (IsDefined(string4))
		self thread waittill_string(string4, ent);

	if (IsDefined(string5))
		self thread waittill_string(string5, ent);

	if (IsDefined(string6))
		self thread waittill_string(string6, ent);
	
	if (IsDefined(string7))
		self thread waittill_string(string7, ent);	

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

/@
"Name: waittill_any_array_return( <a_notifies> )"
"Summary: Waits for any of the the specified notifies and return which one it got."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<a_notifies> array of notifies to wait on"
"Example: str_which_notify = guy waittill_any_array_return( array( "goal", "pain", "near_goal", "bulletwhizby" ) );"
"SPMP: both"
@/
waittill_any_array_return( a_notifies )
{
	if ( IsInArray( a_notifies, "death" ) )
	{
		self endon("death");
	}
		
	s_tracker = SpawnStruct();
	
	foreach ( str_notify in a_notifies )
	{
		if ( IsDefined( str_notify ) )
		{
			self thread waittill_string( str_notify, s_tracker );
		}
	}

	s_tracker waittill( "returned", msg );
	s_tracker notify( "die" );
	return msg;
}


/@
"Name: waittill_any( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for any of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: singleplayer"
@/
waittill_any( string1, string2, string3, string4, string5 )
{
	assert( IsDefined( string1 ) );

	if ( IsDefined( string2 ) )
		self endon( string2 );

	if ( IsDefined( string3 ) )
		self endon( string3 );

	if ( IsDefined( string4 ) )
		self endon( string4 );

	if ( IsDefined( string5 ) )
		self endon( string5 );

	self waittill( string1 );
}

/@
"Name: waittill_multiple( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for all of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: guy waittill_multiple( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: singleplayer"
@/
waittill_multiple( string1, string2, string3, string4, string5 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;

	if (IsDefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (IsDefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (IsDefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (IsDefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (IsDefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

/@
"Name: within_fov( <start_origin> , <start_angles> , <end_origin> , <fov> )"
"Summary: Returns true if < end_origin > is within the players field of view, otherwise returns false."
"Module: Vector"
"CallOn: "
"MandatoryArg: <start_origin> : starting origin for FOV check( usually the players origin )"
"MandatoryArg: <start_angles> : angles to specify facing direction( usually the players angles )"
"MandatoryArg: <end_origin> : origin to check if it's in the FOV"
"MandatoryArg: <fov> : cosine of the FOV angle to use"
"Example: qBool = within_fov( level.player.origin, level.player.angles, target1.origin, cos( 45 ) );"
"SPMP: singleplayer"
@/ 
within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = VectorNormalize( end_origin - start_origin ); 
	forward = AnglesToForward( start_angles ); 
	dot = VectorDot( forward, normal ); 

	return dot >= fov; 
}

// IMPORTANT: make sure you precache the fx itself via LoadFx in your level GSC
setFootstepEffect(name, fx, species)
{
	assert(IsDefined(name), "Need to define the footstep surface type.");
	assert(IsDefined(fx), "Need to define the footstep effect.");

	if( !IsDefined(species) )
		species = "human";

	level._effect[species]["step_" + name] = fx;
}

getExploderId( ent )
{
	if(!IsDefined(level._exploder_ids))
	{
		level._exploder_ids = [];
		level._exploder_id = 1;
	}

	if(!IsDefined(level._exploder_ids[ent.v["exploder"]]))
	{
		level._exploder_ids[ent.v["exploder"]] = level._exploder_id;
		level._exploder_id ++;
	}

	return level._exploder_ids[ent.v["exploder"]];
}

reportExploderIds()
{
	if(!IsDefined(level._exploder_ids))
		return;
		
	keys = GetArrayKeys( level._exploder_ids ); 

	//println("Client Exploder dictionary : ");
	//for( i = 0; i < keys.size; i++ )
	//{
	//	println(keys[i] + " : " + level._exploder_ids[keys[i]]);
	//}
	
}

initLocalPlayers()
{
	level.localPlayers = getLocalPlayers();
}

init_exploders()
{
	//println("*** Init exploders...");	
	script_exploders = []; 

	ents = GetStructArray( "script_brushmodel", "classname" ); 
	//println("Client : s_bm " + ents.size);
	
	smodels = GetStructArray( "script_model", "classname" ); 
	//println("Client : sm " + smodels.size);

	for( i = 0; i < smodels.size; i++ )
	{
		ents[ents.size] = smodels[i]; 
	}

	for( i = 0; i < ents.size; i++ )
	{
		if( IsDefined( ents[i].script_prefab_exploder ) )
		{
			ents[i].script_exploder = ents[i].script_prefab_exploder; 
		}
	}

	potentialExploders = GetStructArray( "script_brushmodel", "classname" ); 
	//println("Client : Potential exploders from script_brushmodel " + potentialExploders.size);
	
	for( i = 0; i < potentialExploders.size; i++ )
	{
		if( IsDefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder; 
		}
			
		if( IsDefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i]; 
		}
	}

	potentialExploders = GetStructArray( "script_model", "classname" ); 
	//println("Client : Potential exploders from script_model " + potentialExploders.size);
	
	for( i = 0; i < potentialExploders.size; i++ )
	{
		if( IsDefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder; 
		}

		if( IsDefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i]; 
		}
	}

	// Also support script_structs to work as exploders
	for( i = 0; i < level.struct.size; i++ )
	{
		if( IsDefined( level.struct[i].script_prefab_exploder ) )
		{
			level.struct[i].script_exploder = level.struct[i].script_prefab_exploder; 
		}

		if( IsDefined( level.struct[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = level.struct[i]; 
		}
	}

	if( !IsDefined( level.createFXent ) )
	{
		level.createFXent = []; 
	}
	
	acceptableTargetnames = []; 
	acceptableTargetnames["exploderchunk visible"] = true; 
	acceptableTargetnames["exploderchunk"] = true; 
	acceptableTargetnames["exploder"] = true; 
	
	exploder_id = 1;
	
	for( i = 0; i < script_exploders.size; i++ )
	{
		exploder = script_exploders[i]; 
		ent = createExploder( exploder.script_fxid ); 
		ent.v = []; 
		
		//if(!IsDefined(exploder.origin))
		//{
		//	println("************** NO EXPLODER ORIGIN." + i);
		//}
		
		ent.v["origin"] = exploder.origin; 
		ent.v["angles"] = exploder.angles; 
		ent.v["delay"] = exploder.script_delay; 
		ent.v["firefx"] = exploder.script_firefx; 
		ent.v["firefxdelay"] = exploder.script_firefxdelay; 
		ent.v["firefxsound"] = exploder.script_firefxsound; 
		ent.v["firefxtimeout"] = exploder.script_firefxtimeout; 
		ent.v["trailfx"] = exploder.script_trailfx; 
		ent.v["trailfxtag"] = exploder.script_trailfxtag; 
		ent.v["trailfxdelay"] = exploder.script_trailfxdelay; 
		ent.v["trailfxsound"] = exploder.script_trailfxsound; 
		ent.v["trailfxtimeout"] = exploder.script_firefxtimeout; 
		ent.v["earthquake"] = exploder.script_earthquake; 
		ent.v["rumble"] = exploder.script_rumble; 
		ent.v["damage"] = exploder.script_damage; 
		ent.v["damage_radius"] = exploder.script_radius; 
		ent.v["repeat"] = exploder.script_repeat; 
		ent.v["delay_min"] = exploder.script_delay_min; 
		ent.v["delay_max"] = exploder.script_delay_max; 
		ent.v["target"] = exploder.target; 
		ent.v["ender"] = exploder.script_ender; 
		ent.v["physics"] = exploder.script_physics; 
		ent.v["type"] = "exploder"; 
//		ent.v["worldfx"] = true; 

		if( !IsDefined( exploder.script_fxid ) )
		{
			ent.v["fxid"] = "No FX"; 
		}
		else
		{
			ent.v["fxid"] = exploder.script_fxid; 
		}
		ent.v["exploder"] = exploder.script_exploder; 
	//	assert( IsDefined( exploder.script_exploder ), "Exploder at origin " + exploder.origin + " has no script_exploder" ); 

		if( !IsDefined( ent.v["delay"] ) )
		{
			ent.v["delay"] = 0; 
		}

		// MikeD( 4/14/2008 ): Attempt to use the fxid as the sound reference, this way Sound can add sounds to anything
		// without the scripter needing to modify the map
		if( IsDefined( exploder.script_sound ) )
		{
			ent.v["soundalias"] = exploder.script_sound; 
		}
		else if( ent.v["fxid"] != "No FX"  )
		{
			if( IsDefined( level.scr_sound ) && IsDefined( level.scr_sound[ent.v["fxid"]] ) )
			{
				ent.v["soundalias"] = level.scr_sound[ent.v["fxid"]]; 
			}
		}		

		fixup_set = false;

		if(IsDefined(ent.v["target"]))
		{					
			ent.needs_fixup = exploder_id;
			exploder_id++;
			fixup_set = true;
			
/*			temp_ent = GetEnt(0, ent.v["target"], "targetname" ); 
 * if( IsDefined( temp_ent ) )
			{
				org = temp_ent.origin; 
			}
			else */
			{
				temp_ent = GetStruct( ent.v["target"], "targetname" ); 
				if (isDefined(temp_ent) )
				{
					org = temp_ent.origin; 
				}
			}

			if(IsDefined(org))
			{
				ent.v["angles"] = VectorToAngles( org - ent.v["origin"] ); 	
			}
			//else		
			//{
					//println("*** Client : Exploder " + exploder.script_fxid + " Failed to find target ");
			//}
			
			if(IsDefined(ent.v["angles"]))
			{
				ent set_forward_and_up_vectors();
			}
			//else
			//{
				//println("*** Client " + exploder.script_fxid + " has no angles.");
			//}

		}
		
		
		// this basically determines if its a brush/model exploder or not
		if( (isDefined(exploder.classname) && exploder.classname == "script_brushmodel") || IsDefined( exploder.model ) )
		{
			//if(IsDefined(exploder.model))
			//{
				//println("*** exploder " + exploder_id + " model " + exploder.model);
			//}
			ent.model = exploder; 
			//ent.model.disconnect_paths = exploder.script_disconnectpaths; 
			if(fixup_set == false)
			{
				ent.needs_fixup = exploder_id;
				exploder_id++;
			}
		}
		
		if( IsDefined( exploder.targetname ) && IsDefined( acceptableTargetnames[exploder.targetname] ) )
		{
			ent.v["exploder_type"] = exploder.targetname; 
		}
		else
		{
			ent.v["exploder_type"] = "normal"; 
		}		
	}

	level.createFXexploders = [];

	for(i = 0; i < level.createFXent.size;i ++ )
	{
		ent = level.createFXent[i];
		
		if(ent.v["type"] != "exploder")
			continue;
			
		ent.v["exploder_id"] = getExploderId( ent );
		
		if(!IsDefined(level.createFXexploders[ent.v["exploder"]]))
		{
			level.createFXexploders[ent.v["exploder"]] = [];
		}
		
		level.createFXexploders[ent.v["exploder"]][level.createFXexploders[ent.v["exploder"]].size] = ent;
		
	}
	
	reportExploderIds();	
	
	
//	println("*** Client : " + script_exploders.size + " exploders.");
	
}


playfx_for_all_local_clients( fx_id, pos, forward_vec, up_vec )
{
	
	localPlayers = level.localPlayers;
	
	if( IsDefined( up_vec ) )
	{
		for(i = 0; i < localPlayers.size; i ++)
		{
			playfx( i, fx_id, pos, forward_vec, up_vec ); 	
		}		
	}
	else if( IsDefined( forward_vec ) )
	{
		for(i = 0; i < localPlayers.size; i ++)
		{
			playfx( i, fx_id, pos, forward_vec ); 	
		}		
	}
	else
	{
		for(i = 0; i < localPlayers.size; i ++)
		{
			playfx( i, fx_id, pos ); 	
		}		
	}
}

play_sound_on_client( sound_alias )
{
	players = level.localPlayers;

	PlaySound( 0, sound_alias, players[0].origin );
}

loop_sound_on_client( sound_alias, min_delay, max_delay, end_on )
{
	players = level.localPlayers;

	if( IsDefined( end_on ) )
	{
		level endon( end_on );
	}

	for( ;; )
	{
		play_sound_on_client( sound_alias );
		wait( min_delay + RandomFloat( max_delay ) );
	}
}

add_listen_thread( wait_till, func, param1, param2, param3, param4, param5 )
{
	level thread add_listen_thread_internal( wait_till, func, param1, param2, param3, param4, param5 );
}

add_listen_thread_internal( wait_till, func, param1, param2, param3, param4, param5 )
{
	for( ;; )
	{
		level waittill( wait_till );
		single_thread(level, func, param1, param2, param3, param4, param5);
	}
}

addLightningExploder(num)
{
	if (!isdefined(level.lightningExploder))
	{
		level.lightningExploder = [];
		level.lightningExploderIndex = 0;
	}
		
	level.lightningExploder[level.lightningExploder.size] = num;
}

// AE 5-15-09: moved these is_"vehicle" functions from _vehicle
/@
"Name: is_plane()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Returns a bool for if the vehicle is a plane."
"Example: if( vehicle is_plane() )"
"SPMP: singleplayer"
@/ 
is_plane() // self == vehicle
{
	// this is an exposed value from the gdt entry for the vehicle
	if(self.vehicleclass == "plane")
	{
		return true;
	}
	return false;
}

/@
"Name: is_boat()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Returns a bool for if the vehicle is a boat."
"Example: if( vehicle is_boat() )"
"SPMP: singleplayer"
@/ 
is_boat() // self == vehicle
{
	// this is an exposed value from the gdt entry for the vehicle
	if(self.vehicleclass == "boat")
	{
		return true;
	}
	return false;
}

/@
"Name: is_mig()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Returns a bool for if the vehicle is a mig."
"Example: if( vehicle is_mig() )"
"SPMP: singleplayer"
@/ 
is_mig() // self == vehicle
{
	// this is based on the vehicletype of the vehicle itself
	if(self.vehicletype == "plane_mig17" || self.vehicletype == "plane_mig21")
	{
		return true;
	}
	return false;
}

/@
"Name: is_helicopter()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Returns a bool for if the vehicle is a helicopter."
"Example: if( vehicle is_helicopter() )"
"SPMP: singleplayer"
@/ 
is_helicopter() // self == vehicle
{
	// this is an exposed value from the gdt entry for the vehicle
	if(self.vehicleclass == "helicopter")
	{
		return true;
	}
	return false;
}

/@
"Name: is_tank()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Returns a bool for if the vehicle is a tank."
"Example: if( vehicle is_tank() )"
"SPMP: singleplayer"
@/ 
is_tank() // self == vehicle
{
	// this is an exposed value from the gdt entry for the vehicle
	if(self.vehicleclass == "tank")
	{
		return true;
	}
	return false;
}

/@
"Name: is_artillery()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Returns a bool for if the vehicle is an artillery."
"Example: if( vehicle is_artillery() )"
"SPMP: singleplayer"
@/ 
is_artillery() // self == vehicle
{
	// this is an exposed value from the gdt entry for the vehicle
	if(self.vehicleclass == "artillery")
	{
		return true;
	}
	return false;
}

/@
"Name: is_4wheel()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Returns a bool for if the vehicle is a 4 wheel."
"Example: if( vehicle is_4wheel() )"
"SPMP: singleplayer"
@/ 
is_4wheel() // self == vehicle
{
	// this is an exposed value from the gdt entry for the vehicle
	if(self.vehicleclass == "4 wheel")
	{
		return true;
	}
	return false;
}

add_trigger_to_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	
	ent._triggers[trig getentitynumber()] = 1;
}

remove_trigger_from_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
		return;
		
	if(!isdefined(ent._triggers[trig getentitynumber()]))
		return;
		
	ent._triggers[trig getentitynumber()] = 0;
}

ent_already_in_trigger(trig)
{
	if(!isdefined(self._triggers))
		return false;
		
	if(!isdefined(self._triggers[trig getentitynumber()]))
		return false;
		
	if(!self._triggers[trig getentitynumber()])
		return false;

	return true;	// We're already in this trigger volume.
}

trigger_thread(ent, on_enter_payload, on_exit_payload)
{
	ent endon("entityshutdown");
	ent endon("death");
	
	if(ent ent_already_in_trigger(self))
		return;
		
	add_trigger_to_ent(ent, self);

//	iprintlnbold("Trigger " + self.targetname + " hit by ent " + ent getentitynumber());
	
	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	
	while(isdefined(ent) && ent istouching(self))
	{
		wait(0.01);
	}

	if(ent IsPlayer())
	{
		while(!ClientHasSnapshot(0))
		{
			wait(0.01);	// save restore case...
		}		
	}

//	iprintlnbold(ent getentitynumber() + " leaves trigger " + self.targetname + ".");

	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}

	if(isdefined(ent))
	{
		remove_trigger_from_ent(ent, self);
	}
}

remove_triggers_from_ent( ent )
{
	if( IsDefined( ent._triggers ) )
	{
		ent._triggers = [];
	}
}

/@
"Name: notify_delay( <notify_string> , <delay> )"
"Summary: Notifies self the string after waiting the specified delay time"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <notify_string> : The string to notify"
"MandatoryArg: <delay> : Time to wait( in seconds ) before sending the notify."
"Example: vehicle notify_delay( "start_to_smoke", 3.5 );"
"SPMP: singleplayer"
@/ 
notify_delay( sNotifyString, fDelay )
{
	assert( IsDefined( self ) );
	assert( IsDefined( sNotifyString ) );
	assert( IsDefined( fDelay ) );
	assert( fDelay > 0 );

	self endon( "death" );
	wait fDelay;
	if( !IsDefined( self ) )
	{
		return;
	}
	self notify( sNotifyString );
}

////////////////////////////// Callbacks ////////////////////////////////////////////

OnPlayerConnect_Callback(func)
{
	clientscripts\_callbacks::AddCallback("on_player_connect", func);
}

/////////////////////////////////////////////////////////////////////////////////////

set_player_viewmodel(viewmodel)
{
	level.player_viewmodel = viewmodel;
}

spawn_player_arms()
{
	arms = Spawn(self GetLocalClientNumber(), self GetOrigin() + ( 0, 0, -1000 ), "script_model");

	if (IsDefined(level.player_viewmodel))
	{
		// level specific viewarms
		arms SetModel(level.player_viewmodel);
	}
	else
	{
		// default viewarms
		arms SetModel("c_usa_cia_masonjr_viewhands");  // updated default viewarms to match _loadout.gsc - TravisJ 12/13/2011
	}

	return arms;
}

/@
"Name: get_eye()"
"Summary: Get eye position accurately even on a player when linked to an entity."
"Module: Utility"
"CallOn: Player or AI"
"Example: eye_pos = player get_eye();"
"SPMP: singleplayer"
@/
get_eye()
{
	if (self IsPlayer())
	{
		linked_ent = self GetLinkedEnt();
		if (IsDefined(linked_ent) && (GetDvarInt("cg_cameraUseTagCamera") > 0))
		{
			camera = linked_ent GetTagOrigin("tag_camera");
			if (IsDefined(camera))
			{
				return camera;
			}
		}
	}

	pos = self GetEye();
	return pos;
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

waittill_either( msg1, msg2 )
{
	self endon( msg1 ); 
	self waittill( msg2 ); 
}

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
		case "helicopter":
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

getDvarFloatDefault( dvarName, defaultValue)
{
	value=getDvar(dvarName);
	if (value!= "")
	{
		return float(value);
	}	
	return defaultValue;
}	

getDvarIntDefault( dvarName, defaultValue)
{
	value=getDvar(dvarName);
	if (value!= "")
	{
		return int(value);
	}	
	return defaultValue;
}	

isDumbRocketLauncherWeapon( weapon )
{
	// should switch these out with code calls
	switch( weapon )
	{
	case "rpg_sp":
	case "m220_tow_sp":
	case "usrpg_sp":
	case "metalstorm_launcher":			
		return true;
	default:
		return false;
	}
}