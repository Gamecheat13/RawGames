#include clientscripts\mp\_utility_code;

/#
error( message )
{
	println( "^c * ERROR * ", message );
	wait 0.05;
 }
#/
// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to( IE: can't do 5.struct_array_index ) 
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object


OnFinalizeInitialization_Callback(func)
{
	clientscripts\mp\_callbacks::AddCallback( "on_finalize_initialization", func );
}


getstruct( name, type )
{
	if(!isdefined( level.struct_class_names ) )
		return undefined;
	
	array = level.struct_class_names[ type ][ name ];
	if( !IsDefined( array ) )
	{
	/#	println("**** Getstruct returns undefined on " + name + " : " + " type.");	#/
		return undefined; 
	}

	if( array.size > 1 )
	{
		assertMsg( "getstruct used for more than one struct of type " + type + " called " + name + "." );
		return undefined; 
	}
	return array[ 0 ];
}

getstructarray( name, type )
{
	assert( isdefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

	array = level.struct_class_names[type][name]; 
	if(!isdefined( array ) )
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

registerSystem(sSysName, cbFunc)
{
	if(!isdefined(level._systemStates))
	{
		level._systemStates = [];
	}
	
	if(level._systemStates.size >= 32)	
	{
		/#error("Max num client systems exceeded.");#/
		return;
	}
	
	if(isdefined(level._systemStates[sSysName]))
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
	
	if(!isdefined(level.localPlayers))
	{
		while(!isdefined(level.localPlayers))
		{
			wait(0.01);
		}
	}
	
	while (localClient < level.localPlayers.size)
	{
		waitforclient(localClient);
		localClient++;
	}
}

// this function will stall until the client has received a snapshot
waitforclient(client)
{
	while(!clienthassnapshot(client))
	{
		wait(0.01);
	}
}

waittill_string( msg, ent )
{
	if ( msg != "death" )
		self endon ("death");

	ent endon ( "die" );
	self waittill ( msg );
	ent notify ( "returned", msg );
}

waittill_dobj(localClientNum)
{
	while( isdefined( self ) && !(self hasdobj(localClientNum)) )
	{
		wait(0.01);
	}
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
waittill_any_return( string1, string2, string3, string4, string5, string6 )
{
	if ((!IsDefined (string1) || string1 != "death") &&
		(!IsDefined (string2) || string2 != "death") &&
		(!IsDefined (string3) || string3 != "death") &&
		(!IsDefined (string4) || string4 != "death") &&
		(!IsDefined (string5) || string5 != "death") &&
		(!IsDefined (string6) || string6 != "death"))
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

	ent waittill ("returned", msg);
	ent notify ("die");
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


//-- Arrays --//

/@
"Name: array( a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z )"
"Module: Array"
"Summary: Returns an array containing all values passed in."
"OptionalArg: Takes up to 26 arguments."
"Example: my_array = array(guy1, guy2, guy19);"
"SPMP: singleplayer"
@/
array(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
{
	array = [];
	if ( IsDefined( a ) ) array[ 0] = a; else return array;
	if ( IsDefined( b ) ) array[ 1] = b; else return array;
	if ( IsDefined( c ) ) array[ 2] = c; else return array;
	if ( IsDefined( d ) ) array[ 3] = d; else return array;
	if ( IsDefined( e ) ) array[ 4] = e; else return array;
	if ( IsDefined( f ) ) array[ 5] = f; else return array;
	if ( IsDefined( g ) ) array[ 6] = g; else return array;
	if ( IsDefined( h ) ) array[ 7] = h; else return array;
	if ( IsDefined( i ) ) array[ 8] = i; else return array;
	if ( IsDefined( j ) ) array[ 9] = j; else return array;
	if ( IsDefined( k ) ) array[10] = k; else return array;
	if ( IsDefined( l ) ) array[11] = l; else return array;
	if ( IsDefined( m ) ) array[12] = m; else return array;
	if ( IsDefined( n ) ) array[13] = n; else return array;
	if ( IsDefined( o ) ) array[14] = o; else return array;
	if ( IsDefined( p ) ) array[15] = p; else return array;
	if ( IsDefined( q ) ) array[16] = q; else return array;
	if ( IsDefined( r ) ) array[17] = r; else return array;
	if ( IsDefined( s ) ) array[18] = s; else return array;
	if ( IsDefined( t ) ) array[19] = t; else return array;
	if ( IsDefined( u ) ) array[20] = u; else return array;
	if ( IsDefined( v ) ) array[21] = v; else return array;
	if ( IsDefined( w ) ) array[22] = w; else return array;
	if ( IsDefined( x ) ) array[23] = x; else return array;
	if ( IsDefined( y ) ) array[24] = y; else return array;
	if ( IsDefined( z ) ) array[25] = z;
	return array;
}

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

/*setFootstepEffect(name, fx)
{
	assert(isdefined(name), "Need to define the footstep surface type.");
	assert(isdefined(fx), "Need to define the " + name + " effect.");
	if (!isdefined(level._optionalStepEffects))
		level._optionalStepEffects = [];
	level._optionalStepEffects[level._optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
}*/

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

// This function differs from trigger_thread in that it does not end on entityshutdown
// and it will always call the on_exit_payload even if the ent is not defined.
// Use cases are on players where you want the exit to be called even if the player goes into killcam
local_player_trigger_thread_always_exit( ent, on_enter_payload, on_exit_payload)
{
	if(ent ent_already_in_trigger(self))
		return;
		
	add_trigger_to_ent(ent, self);

	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	
	while(isdefined(ent) && ent istouching(self) && ent issplitscreenhost() )
	{
		wait(0.01);
	}

	if(isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}

	if(isdefined(ent))
	{
		remove_trigger_from_ent(ent, self);
	}
}

friendNotFoe( localClientIndex )
{
	team = GetLocalPlayerTeam(localClientIndex);
	
	// using the player team to determine team base games
	if ( team == "free" )
	{
		player = GetLocalPlayer(localClientIndex);
		if ( IsDefined(player) && self getowner(localClientIndex) == player )
			return true;
	}
	else if ( self.team == team )
	{
		return true;
	}
	
	return false;
}

local_player_entity_thread( localClientNum, entity, func, arg1, arg2, arg3, arg4 )
{
	entity endon("entityshutdown");
	
	entity waittill_dobj( localClientNum );
	
	single_thread(entity, func, localClientNum, arg1, arg2, arg3, arg4);
}

/@
"Name: local_players_entity_thread( <entity> , <func> , <arg1> , <arg2> , <arg3>, <arg4> )"
"Summary: Threads the < func > function on entity on all local players when the dobj becomes valid. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: <entity> : entity to thread the process"
"MandatoryArg: <func> : pointer to a script function.  Function must have the first parameter of localCientNum"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"Example: local_players_entity_thread( chopper, ::spawn_fx );"
"SPMP: mp"
@/ 
local_players_entity_thread( entity, func, arg1, arg2, arg3, arg4 )
{
	players = level.localPlayers;
	for (i = 0; i < players.size; i++)
	{
		players[i] thread local_player_entity_thread( i, entity, func, arg1, arg2, arg3, arg4 );
	}
}

/@
"Name: is_true(<check>)"
"Summary: For boolean checks when undefined should mean 'false'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_true( self.is_linked ) { //do stuff }"
"SPMP: both"
@/
is_true(check)
{
	return(IsDefined(check) && check);
}

/@
"Name: is_false(<check>)"
"Summary: For boolean checks when undefined should mean 'true'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_false( self.is_linked ) { //do stuff }"
"SPMP: both"
@/
is_false(check)
{
	return(IsDefined(check) && !check);
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

debug_line( from, to, color, time )
{
/#
	level.debug_line = GetDvarIntDefault( "scr_debug_line", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.debug_line ) && level.debug_line == 1.0 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		Line( from, to, color, 1, 1, time);
	}
#/

}

debug_star( origin, color, time )
{
/#
	level.debug_star = GetDvarIntDefault( "scr_debug_star", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.debug_star ) && level.debug_star == 1.0 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		if ( !IsDefined(color) )
		{
			color = (1,1,1);
		}
		debugstar( origin, time, color );
	}
#/
}

initUtility()
{
	level.IsDemoPlaying = IsDemoPlaying();
	level.localPlayers = [];
	WaitForClient( 0 );
	level.localPlayers = GetLocalPlayers();
}

serverTime()
{
	for (;;)
	{
		level.serverTime = getServerTime( 0 );
		wait( 0.01 );
	}
}

serverWait( localClientNum, seconds, waitBetweenChecks ) 
{
	if ( level.isDemoPlaying && seconds != 0 )
	{
		if ( !isdefined( waitBetweenChecks ) ) 
			waitBetweenChecks = 0.2;

		waitCompletedSuccessfully = false;
		startTime = level.serverTime;
		lastTime = startTime;
		endTime = startTime + (seconds * 1000);

		while( level.serverTime < endTime && level.serverTime >= lastTime )
		{
			lastTime = level.serverTime;
			wait( waitBetweenChecks );
		}

		if ( lastTime < level.serverTime )
			waitCompletedSuccessfully = true;
	}
	else
	{
		waitrealtime( seconds );
		waitCompletedSuccessfully = true;
	}
	
	return waitCompletedSuccessfully;
}

isPlayerViewLinkedToEntity(localClientNum)
{
	if ( self IsDriving( localClientNum ) )
		return true;
		
	if ( self IsLocalPlayerWeaponViewOnlyLinked( ) )
		return true;

	return false;
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

GetClientField(field_name)
{
	if(self == level)
	{
		return CodeGetWorldClientField(field_name);
	}
	else
	{
		return CodeGetClientField(self, field_name);
	}
}

GetClientFieldToPlayer( field_name )
{
	return CodeGetPlayerStateClientField( self, field_name );
}

isGrenadeLauncherWeapon( weapon )
{
	if(GetSubStr( weapon,0,2 ) == "gl_")
	{
		return true;
	}
	
	switch( weapon )
	{
	case "xm25_mp":
	case "china_lake_mp":		// we still using this for BO2?
		return true;
	default:
		return false;
	}
}

isDumbRocketLauncherWeapon( weapon )
{
	// should switch these out with code calls
	switch( weapon )
	{
	case "rpg_mp":
	case "m220_tow_mp":
	case "usrpg_mp":
	case "ai_tank_drone_rocket_mp":			
		return true;
	default:
		return false;
	}
}

isGuidedRocketLauncherWeapon( weapon )
{
	// should switch these out with code calls
	switch( weapon )
	{
	case "fhj18_mp":
	case "m72_law_mp":
	case "smaw_mp":
	case "javelin_mp":
	case "m202_flash_mp":
		return true;
	default:
		return false;
	}
}

isRocketLauncherWeapon( weapon )
{
	if(isDumbRocketLauncherWeapon(weapon))
	{
		return true;
	}
	
	if(isGuidedRocketLauncherWeapon(weapon))
	{
		return true;
	}
	
	return false;
}

isLauncherWeapon( weapon )
{
	if(isRocketLauncherWeapon(weapon))
	{
		return true;
	}
	
	if(isGrenadeLauncherWeapon(weapon))
	{
		return true;
	}
	
	return false;
}