#include clientscripts\mp\_utility_code;

/*
=============
///ScriptDocBegin
"Name: getstructarray( <name> , <type )"
"Summary: gets an array of script_structs"
"Module: Array"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <type>: "
"Example: fxemitters = getstructarray( "streetlights" , "targetname" )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

error( message )
{
	println( "^c * ERROR * ", message );
	wait 0.05;
 }

// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to( IE: can't do 5.struct_array_index ) 
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object



getstruct( name, type )
{
	if(!isdefined( level.struct_class_names ) )
		return undefined;
	
	array = level.struct_class_names[ type ][ name ];
	if( !IsDefined( array ) )
	{
		println("**** Getstruct returns undefined on " + name + " : " + " type.");
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
	assertEx( isdefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

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

 /* 
 ============= 
///ScriptDocBegin
"Name: play_sound_in_space( <clientNum>, <alias> , <origin>  )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: Level"
"MandatoryArg: <clientNum> : local client to hear the sound."
"MandatoryArg: <alias> : Sound alias to play"
"MandatoryArg: <origin> : Origin of the sound"
"Example: play_sound_in_space( "siren", level.speaker.origin );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
play_sound_in_space( localClientNum, alias, origin)
{
	PlaySound( localClientNum, alias, origin); 
}

vectorScale( vector, scale )
{
	vector = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
	return vector;
}

vector_multiply( vec, dif )
{
	vec = ( vec[ 0 ] * dif, vec[ 1 ] * dif, vec[ 2 ] * dif );
	return vec; 
}

/* 
 ============= 
///ScriptDocBegin
"Name: array_thread( <entities> , <process> , <var1> , <var2> , <var3> )"
"Summary: Threads the < process > function on every entity in the < entities > array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities> : array of entities to thread the process"
"MandatoryArg: <process> : pointer to a script function"
"OptionalArg: <var1> : parameter 1 to pass to the process"
"OptionalArg: <var2> : parameter 2 to pass to the process"
"OptionalArg: <var3> : parameter 3 to pass to the process"
"Example: array_thread( getaiarray( "allies" ), ::set_ignoreme, false );"
"SPMP: both"
///ScriptDocEnd
 ============= 
*/ 
array_thread( entities, process, var1, var2, var3 )
{
	keys = getArrayKeys( entities );
	
	if ( isdefined( var3 ) )
	{
		for( i = 0 ; i < keys.size ; i ++ )
			entities[ keys[ i ] ] thread [[ process ]]( var1, var2, var3 );
			
		return;
	}

	if ( isdefined( var2 ) )
	{
		for( i = 0 ; i < keys.size ; i ++ )
			entities[ keys[ i ] ] thread [[ process ]]( var1, var2 );
			
		return;
	}

	if ( isdefined( var1 ) )
	{
		for( i = 0 ; i < keys.size ; i ++ )
			entities[ keys[ i ] ] thread [[ process ]]( var1 );
			
		return;
	}

	for( i = 0 ; i < keys.size ; i ++ )
		entities[ keys[ i ] ] thread [[ process ]]();
}

registerSystem(sSysName, cbFunc)
{
	if(!isdefined(level._systemStates))
	{
		level._systemStates = [];
	}
	
	if(level._systemStates.size >= 32)	
	{
		error("Max num client systems exceeded.");
		return;
	}
	
	if(isdefined(level._systemStates[sSysName]))
	{
		error("Attempt to re-register client system : " + sSysName);
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

waitforclient(client)
{
	while(!clienthassnapshot(client))
	{
		wait(0.01);
	}
	syncsystemstates(client);	
}

/* 
 ============= 
///CScriptDocBegin
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
///CScriptDocEnd
 ============= 
 */ 
within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = VectorNormalize( end_origin - start_origin ); 
	forward = AnglesToForward( start_angles ); 
	dot = VectorDot( forward, normal ); 

	return dot >= fov; 
}


/* 
============= 
///CScriptDocBegin
"Name: add_to_array( <array> , <ent> )"
"Summary: Adds < ent > to < array > and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : The array to add < ent > to."
"MandatoryArg: <ent> : The entity to be added."
"Example: nodes = add_to_array( nodes, new_node );"
"SPMP: singleplayer"
///CScriptDocEnd
============= 
*/ 
add_to_array( array, ent )
{
	if( !IsDefined( ent ) )
		return array; 

	if( !IsDefined( array ) )
		array[ 0 ] = ent;
	else
		array[ array.size ] = ent;

	return array; 
}

setFootstepEffect(name, fx)
{
	assertEx(isdefined(name), "Need to define the footstep surface type.");
	assertEx(isdefined(fx), "Need to define the " + name + " effect.");
	if (!isdefined(level._optionalStepEffects))
		level._optionalStepEffects = [];
	level._optionalStepEffects[level._optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
}