#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

#namespace util;

/#
function error(msg)
{
	println("^c*ERROR* ", msg);
	wait .05;	// waitframe

	if (GetDvarString( "debug") != "1")
		assertmsg("This is a forced error - attach the log file");
}
#/

function warning( msg )
{
/#	println( "^1WARNING: " + msg );	#/
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
"SPMP: multiplayer"
@/ 
function within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = VectorNormalize( end_origin - start_origin ); 
	forward = AnglesToForward( start_angles ); 
	dot = VectorDot( forward, normal ); 

	return dot >= fov; 
}

/@
"Name: append_array_struct( <dst>, <src> )"
"Summary: Append the array elements in the <src> (2nd) array struct parameter to the array in the <dst> (1st) array struct parameter."
"Module: Array"
"CallOn: "
"MandatoryArg: <dst> : Destination - Elements from <src>.a[] are appended to <dst>.a[]"
"MandatoryArg: <src> : Source - Elements from <src>.a[] are appended to <dst>.a[]"
"Example: players = spawn_array_struct(); worst_enemies = built_worst_enemies(); append_array_struct( players, worst_enemies ;"
"SPMP: both"
@/ 
function append_array_struct(
	dst_s,         ///< struct.a[]
	src_s )        ///< struct.a[]
{
	for ( i= 0; i < src_s.a.size; i++ )
	{
		dst_s.a[ dst_s.a.size ]= src_s.a[ i ];
	}
}

function getPlant()
{
	start = self.origin + (0, 0, 10);

	range = 11;
	forward = anglesToForward(self.angles);
	forward = VectorScale(forward, range);

	traceorigins[0] = start + forward;
	traceorigins[1] = start;

	trace = bulletTrace(traceorigins[0], (traceorigins[0] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1)
	{
		//println("^6Using traceorigins[0], tracefraction is", trace["fraction"]);
		
		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orientToNormal(trace["normal"]);
		return temp;
	}

	trace = bulletTrace(traceorigins[1], (traceorigins[1] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1)
	{
		//println("^6Using traceorigins[1], tracefraction is", trace["fraction"]);

		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orientToNormal(trace["normal"]);
		return temp;
	}

	traceorigins[2] = start + (16, 16, 0);
	traceorigins[3] = start + (16, -16, 0);
	traceorigins[4] = start + (-16, -16, 0);
	traceorigins[5] = start + (-16, 16, 0);

	besttracefraction = undefined;
	besttraceposition = undefined;
	for(i = 0; i < traceorigins.size; i++)
	{
		trace = bulletTrace(traceorigins[i], (traceorigins[i] + (0, 0, -1000)), false, undefined);

		//ent[i] = spawn("script_model",(traceorigins[i]+(0, 0, -2)));
		//ent[i].angles = (0, 180, 180);
		//ent[i] setmodel("105");

		//println("^6trace ", i ," fraction is ", trace["fraction"]);

		if(!isdefined(besttracefraction) || (trace["fraction"] < besttracefraction))
		{
			besttracefraction = trace["fraction"];
			besttraceposition = trace["position"];

			//println("^6besttracefraction set to ", besttracefraction, " which is traceorigin[", i, "]");
		}
	}
	
	if(besttracefraction == 1)
		besttraceposition = self.origin;
	
	temp = spawnstruct();
	temp.origin = besttraceposition;
	temp.angles = orientToNormal(trace["normal"]);
	return temp;
}

function orientToNormal(normal)
{
	hor_normal = (normal[0], normal[1], 0);
	hor_length = length(hor_normal);

	if(!hor_length)
		return (0, 0, 0);
	
	hor_dir = vectornormalize(hor_normal);
	neg_height = normal[2] * -1;
	tangent = (hor_dir[0] * neg_height, hor_dir[1] * neg_height, hor_length);
	plant_angle = vectortoangles(tangent);

	//println("^6hor_normal is ", hor_normal);
	//println("^6hor_length is ", hor_length);
	//println("^6hor_dir is ", hor_dir);
	//println("^6neg_height is ", neg_height);
	//println("^6tangent is ", tangent);
	//println("^6plant_angle is ", plant_angle);

	return plant_angle;
}

function array_levelthread (ents, process, v, excluders)
{
	exclude = [];
	for (i=0;i<ents.size;i++)
		exclude[i] = false;

	if (isdefined (excluders))
	{
		for (i=0;i<ents.size;i++)
		{
			for (p=0;p<excluders.size;p++)
			{
				if (ents[i] == excluders[p])
					exclude[i] = true;
			}
		}
	}

	for (i=0;i<ents.size;i++)
	{
		if (!exclude[i])
		{
			if (isdefined (v))
				level thread [[process]](ents[i], v);
			else
				level thread [[process]](ents[i]);
		}
	}
}


function deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
	{
		//println("DELETED: ", entities[i].classname);
		entities[i] delete();
	}
}

function get_player_height()
{
	return 70.0; // inches, see bg_pmove.cpp::playerMins/playerMaxs
}


function IsBulletImpactMOD( sMeansOfDeath )
{
	return IsSubStr( sMeansOfDeath, "BULLET" ) || sMeansOfDeath == "MOD_HEAD_SHOT";
}

function waitRespawnButton()
{
	self endon("disconnect");
	self endon("end_respawn");

	while(self useButtonPressed() != true)
		wait .05;
}


function setLowerMessage( text, time, combineMessageAndTimer )
{
	if ( !isdefined( self.lowerMessage ) )
		return;
	
	if ( isdefined( self.lowerMessageOverride ) && text != &"" )
	{
		text = self.lowerMessageOverride;
		time = undefined;
	}
	
	self notify("lower_message_set");
	
	self.lowerMessage setText( text );
	
	if ( isdefined( time ) && time > 0 )
	{
		if ( !isdefined( combineMessageAndTimer ) || !combineMessageAndTimer )
			self.lowerTimer.label = &"";
		else
		{
			self.lowerMessage setText( "" );
			self.lowerTimer.label = text;
		}
		self.lowerTimer setTimer( time );
	}
	else
	{
		self.lowerTimer setText( "" );
		self.lowerTimer.label = &"";
	}
	if( self IsSplitscreen() )
		self.lowerMessage.fontscale = 1.4;
	
	self.lowerMessage fadeOverTime( 0.05 );
	self.lowerMessage.alpha = 1;
	self.lowerTimer fadeOverTime( 0.05 );
	self.lowerTimer.alpha = 1;
}

function setLowerMessageValue( text, value, combineMessage )
{
	if ( !isdefined( self.lowerMessage ) )
		return;
	
	if ( isdefined( self.lowerMessageOverride ) && text != &"" )
	{
		text = self.lowerMessageOverride;
		time = undefined;
	}
	
	self notify("lower_message_set");
	if ( !isdefined( combineMessage ) || !combineMessage )
		self.lowerMessage setText( text );
	else
		self.lowerMessage setText( "" );
	
	if ( isdefined( value ) && value > 0 )
	{
		if ( !isdefined( combineMessage ) || !combineMessage )
			self.lowerTimer.label = &"";
		else
			self.lowerTimer.label = text;
		self.lowerTimer setValue( value );
	}
	else
	{
		self.lowerTimer setText( "" );
		self.lowerTimer.label = &"";
	}
	
	if( self IsSplitscreen() )
		self.lowerMessage.fontscale = 1.4;
	
	self.lowerMessage fadeOverTime( 0.05 );
	self.lowerMessage.alpha = 1;
	self.lowerTimer fadeOverTime( 0.05 );
	self.lowerTimer.alpha = 1;
}

function clearLowerMessage( fadetime )
{
	if ( !isdefined( self.lowerMessage ) )
		return;
	
	self notify("lower_message_set");
	
	if ( !isdefined( fadetime) || fadetime == 0 )
	{
		setLowerMessage( &"" );
	}
	else
	{
		self endon("disconnect");
		self endon("lower_message_set");
		
		self.lowerMessage fadeOverTime( fadetime );
		self.lowerMessage.alpha = 0;
		self.lowerTimer fadeOverTime( fadetime );
		self.lowerTimer.alpha = 0;
		
		wait fadetime;
		
		self setLowerMessage("");
	}
}

function printOnTeam(text, team)
{
	assert( isdefined( level.players ) );
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( ( isdefined(player.pers["team"]) ) && (player.pers["team"] == team) )
			player iprintln(text);
	}
}


function printBoldOnTeam(text, team)
{
	assert( isdefined( level.players ) );
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( ( isdefined(player.pers["team"]) ) && (player.pers["team"] == team) )
			player iprintlnbold(text);
	}
}



function printBoldOnTeamArg(text, team, arg)
{
	assert( isdefined( level.players ) );
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( ( isdefined(player.pers["team"]) ) && (player.pers["team"] == team) )
			player iprintlnbold(text, arg);
	}
}


function printOnTeamArg(text, team, arg)
{
	//assert( isdefined( level.players ) );
	//for ( i = 0; i < level.players.size; i++ )
	//{
	//	player = level.players[i];
	//	if ( ( isdefined(player.pers["team"]) ) && (player.pers["team"] == team) )
	//	{
	//		player iprintln(text, arg);
	//	}
	//}
}


function printOnPlayers( text, team )
{
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if ( isdefined( team ) )
		{
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team))
				players[i] iprintln(text);
		}
		else
		{
			players[i] iprintln(text);
		}
	}
}

function printAndSoundOnEveryone( team, enemyteam, printFriendly, printEnemy, soundFriendly, soundEnemy, printarg )
{
	shouldDoSounds = isdefined( soundFriendly );
	
	shouldDoEnemySounds = false;
	if ( isdefined( soundEnemy ) )
	{
		assert( shouldDoSounds ); // can't have an enemy sound without a friendly sound
		shouldDoEnemySounds = true;
	}
	
	if ( !isdefined( printarg ) )
	{
		printarg = "";
	}
	
	if ( level.splitscreen || !shouldDoSounds )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team && isdefined( printFriendly ) && printFriendly != &"" )
					player iprintln( printFriendly, printarg );
				else if ( isdefined( printEnemy ) && printEnemy != &"" )
				{
					if ( isdefined(enemyteam) && playerteam == enemyteam  )
						player iprintln( printEnemy, printarg );
					else if ( !isdefined(enemyteam) && playerteam != team  )
						player iprintln( printEnemy, printarg );
				}
			}
		}
		if ( shouldDoSounds )
		{
			assert( level.splitscreen );
			level.players[0] playLocalSound( soundFriendly );
		}
	}
	else
	{
		assert( shouldDoSounds );
		if ( shouldDoEnemySounds )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
					{
						if( isdefined( printFriendly ) && printFriendly != &"" )
							player iprintln( printFriendly, printarg );
						player playLocalSound( soundFriendly );
					}
					else if ( (isdefined(enemyteam) && playerteam == enemyteam) || ( !isdefined( enemyteam ) && playerteam != team ) )
					{
						if( isdefined( printEnemy ) && printEnemy != &"" )
							player iprintln( printEnemy, printarg );
						player playLocalSound( soundEnemy );
					}
				}
			}
		}
		else
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
					{
						if( isdefined( printFriendly ) && printFriendly != &"" )
							player iprintln( printFriendly, printarg );
						player playLocalSound( soundFriendly );
					}
					else if ( isdefined( printEnemy ) && printEnemy != &"" )
					{
						if ( isdefined(enemyteam) && playerteam == enemyteam  )
						{
							player iprintln( printEnemy, printarg );
						}
						else if ( !isdefined(enemyteam) && playerteam != team  )
						{
							player iprintln( printEnemy, printarg );
						}
					}
				}
			}
		}
	}
}


function _playLocalSound( soundAlias )
{
	if ( level.splitscreen && !self IsHost() )
		return;

	self playLocalSound( soundAlias );
}


function dvarIntValue( dVar, defVal, minVal, maxVal )
{
	dVar = "scr_" + level.gameType + "_" + dVar;
	if ( GetDvarString( dVar ) == "" )
	{
		SetDvar( dVar, defVal );
		return defVal;
	}
	
	value = getDvarInt( dVar );

	if ( value > maxVal )
		value = maxVal;
	else if ( value < minVal )
		value = minVal;
	else
		return value;
		
	SetDvar( dVar, value );
	return value;
}


function dvarFloatValue( dVar, defVal, minVal, maxVal )
{
	dVar = "scr_" + level.gameType + "_" + dVar;
	if ( GetDvarString( dVar ) == "" )
	{
		SetDvar( dVar, defVal );
		return defVal;
	}
	
	value = getDvarFloat( dVar );

	if ( value > maxVal )
		value = maxVal;
	else if ( value < minVal )
		value = minVal;
	else
		return value;
		
	SetDvar( dVar, value );
	return value;
}

// this function is depricated 
function getOtherTeam( team )
{
	// TODO MTEAM - Need to fix this.
	if ( team == "allies" )
		return "axis";
	else if ( team == "axis" )
		return "allies";
	else // all other teams
		return "allies";
		
	assertMsg( "getOtherTeam: invalid team " + team );
}

function getTeamMask( team )
{
	// this can be undefined on connect
	if ( !level.teambased || !isdefined(team) || !isdefined(level.spawnsystem.iSPAWN_TEAMMASK[team]) )
	 return level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	 
	return level.spawnsystem.iSPAWN_TEAMMASK[team];
}

function getOtherTeamsMask( skip_team )
{
	mask = 0;
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;
			
		mask = mask | getTeamMask( team );
	}
	
	return mask;
}

function wait_endon( waitTime, endOnString, endonString2, endonString3, endonString4 )
{
	self endon ( endOnString );
	if ( isdefined( endonString2 ) )
		self endon ( endonString2 );
	if ( isdefined( endonString3 ) )
		self endon ( endonString3 );
	if ( isdefined( endonString4 ) )
		self endon ( endonString4 );
	
	wait ( waitTime );
	return true;
}

function plot_points( plotpoints, r, g, b, timer )
{
	/#
	lastpoint = plotpoints[ 0 ];
	if( !isdefined( r ) )
		r = 1; 
	if( !isdefined( g ) )
		g = 1; 
	if( !isdefined( b ) )
		b = 1; 
	if( !isdefined( timer ) )
		timer = 0.05; 
	for( i = 1;i < plotpoints.size;i ++ )
	{
		// AE 10-26-09: line function must have changed to Line( <start>, <end>, <color>, <depthTest>, <duration> )
		line( lastpoint, plotpoints[ i ], ( r, g, b ), 1, timer ); 
		//line( lastpoint, plotpoints[ i ], ( r, g, b ), 1, 1, int(timer) ); 
		lastpoint = plotpoints[ i ];	
	}
	#/
}

function registerClientSys(sSysName)
{
	if(!isdefined(level._clientSys))
	{
		level._clientSys = [];
	}
	
	if(level._clientSys.size >= 32)	
	{
		/#error("Max num client systems exceeded.");#/
		return;
	}
	
	if(isdefined(level._clientSys[sSysName]))
	{
		/#error("Attempt to re-register client system : " + sSysName);#/
		return;
	}
	else
	{
		level._clientSys[sSysName] = spawnstruct();
		level._clientSys[sSysName].sysID = ClientSysRegister(sSysName);
	}	
}

function setClientSysState(sSysName, sSysState, player)
{
	if(!isdefined(level._clientSys))
	{
		/#error("setClientSysState called before registration of any systems.");#/
		return;
	}
	
	if(!isdefined(level._clientSys[sSysName]))
	{
		/#error("setClientSysState called on unregistered system " + sSysName);#/
		return;
	}
	
	if(isdefined(player))
	{
		player ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
	}
	else
	{
		ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
		level._clientSys[sSysName].sysState = sSysState;
	}
}

function getClientSysState(sSysName)
{
	if(!isdefined(level._clientSys))
	{
		/#error("Cannot getClientSysState before registering any client systems.");#/
		return "";
	}
	
	if(!isdefined(level._clientSys[sSysName]))
	{
		/#error("Client system " + sSysName + " cannot return state, as it is unregistered.");#/
		return "";
	}
	
	if(isdefined(level._clientSys[sSysName].sysState))
	{
		return level._clientSys[sSysName].sysState;
	}
	
	return "";
}

function clientNotify(event)
{
	if(level.clientscripts)
	{
		if(IsPlayer(self))
		{
			setClientSysState("levelNotify", event, self);
		}
		else
		{
			setClientSysState("levelNotify", event);
		}
	}
}

function getfx( fx )
{
	assert( isdefined( level._effect[ fx ] ), "Fx " + fx + " is not defined in level._effect." );
	return level._effect[ fx ];
}

function struct_arraySpawn()
{
	struct = SpawnStruct();
	struct.array = [];
	struct.lastindex = 0;
	return struct;
}

function structarray_add( struct, object )
{
	assert( !isdefined( object.struct_array_index ) );// can't have elements of two structarrays on these. can add that later if it's needed
	struct.array[ struct.lastindex ] = object;
	object.struct_array_index = struct.lastindex; 
	struct.lastindex ++ ;
}

function structarray_remove( struct, object )
{
	structarray_swaptolast( struct, object ); 
	struct.array[ struct.lastindex - 1 ] = undefined;
	struct.lastindex -- ;
}

function structarray_swaptolast( struct, object )
{
	struct structarray_swap( struct.array[ struct.lastindex - 1 ], object );
}

function structarray_shuffle( struct, shuffle )
{
	for( i = 0;i < shuffle;i ++ )
		struct structarray_swap( struct.array[ i ], struct.array[ randomint( struct.lastindex ) ] );
}

function structarray_swap( object1, object2 )
{
	index1 = object1.struct_array_index;
	index2 = object2.struct_array_index; 
	self.array[ index2 ] = object1;
	self.array[ index1 ] = object2;
	self.array[ index1 ].struct_array_index = index1;
	self.array[ index2 ].struct_array_index = index2;
}

function waittill_either( msg1, msg2 )
{
	self endon( msg1 ); 
	self waittill( msg2 ); 
}

/@
"Name: getClosestFx( <org> , <fxarray> , <dist> )"
"Summary: Returns the closest fx struct created by createfx in < fxarray > to location < org > "
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of createfx structs to check distance on. These are obtained with getfxarraybyID( <fxid> )"
"OptionalArg: <dist> : Minimum distance to check"
"Example: fxstruct = getClosestFx( hallway_tv, fxarray );"
"SPMP: singleplayer"
@/ 
function getClosestFx( org, fxarray, dist )
{
	return compareSizesFx( org, fxarray, dist,&array::closerFunc );
}

function compareSizesFx( org, array, dist, compareFunc )
{
	if( !array.size )
		return undefined;
	if( isdefined( dist ) )
	{
		distSqr = dist * dist;
		struct = undefined;
		keys = getArrayKeys( array );
		for( i = 0; i < keys.size; i ++ )
		{
			newdistSqr = DistanceSquared( array[ keys[ i ] ].v[ "origin" ], org );
			if( [[ compareFunc ]]( newdistSqr, distSqr ) )
				continue;
			distSqr = newdistSqr;
			struct = array[ keys[ i ] ];
		}
		return struct;
	}

	keys = getArrayKeys( array );
	struct = array[ keys[ 0 ] ];
	distSqr = DistanceSquared( struct.v[ "origin" ], org );
	for( i = 1; i < keys.size; i ++ )
	{
		newdistSqr = DistanceSquared( array[ keys[ i ] ].v[ "origin" ], org );
		if( [[ compareFunc ]]( newdistSqr, distSqr ) )
			continue;
		distSqr = newdistSqr;
		struct = array[ keys[ i ] ];
	}
	return struct;
}

function set_dvar_if_unset(
	dvar,
	value,
	reset)
{
	if (!isdefined(reset))
		reset = false;

	if (reset || GetDvarString(dvar)=="")
	{
		SetDvar(dvar, value);
		return value;
	}
	
	return GetDvarString(dvar);
}

function set_dvar_float_if_unset(
	dvar,
	value,
	reset)
{
	if (!isdefined(reset))
		reset = false;

	if (reset || GetDvarString(dvar)=="")
	{
		SetDvar(dvar, value);
	}
	
	return GetDvarFloat(dvar);
}

function set_dvar_int_if_unset(
	dvar,
	value,
	reset)
{
	if (!isdefined(reset))
		reset = false;

	if (reset || GetDvarString(dvar)=="")
	{
		SetDvar(dvar, value);
		return int(value);
	}
	
	return GetDvarInt(dvar);
}

function add_trigger_to_ent(ent) // Self == The trigger volume
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	
	ent._triggers[self GetEntityNumber()] = 1;
}

function remove_trigger_from_ent(ent)	// Self == The trigger volume.
{
	if(!isdefined(ent))
		return;

	if(!isdefined(ent._triggers))
		return;
		
	if(!isdefined(ent._triggers[self GetEntityNumber()]))
		return;
		
	ent._triggers[self GetEntityNumber()] = 0;
}

function ent_already_in_trigger(trig)	// Self == The entity in the trigger volume.
{
	if(!isdefined(self._triggers))
		return false;
		
	if(!isdefined(self._triggers[trig GetEntityNumber()]))
		return false;
		
	if(!self._triggers[trig GetEntityNumber()])
		return false;
		
	return true;	// We're already in this trigger volume.
}

function trigger_thread_death_monitor(ent, ender)
{
	ent waittill("death");
	self endon(ender);
	self remove_trigger_from_ent(ent);
}

function trigger_thread(ent, on_enter_payload, on_exit_payload)	// Self == The trigger.
{
	ent endon("entityshutdown");
	ent endon("death");
	
	if(ent ent_already_in_trigger(self))
		return;
		
	self add_trigger_to_ent(ent);
	
	ender = "end_trig_death_monitor" + self GetEntityNumber() + " " + ent GetEntityNumber();
	self thread trigger_thread_death_monitor(ent, ender);  // If ent dies in trigger, clear trigger off of ent.

//	iprintlnbold("Trigger " + self.targetname + " hit by ent " + ent getentitynumber());
	
	endon_condition = "leave_trigger_" + self GetEntityNumber();
	
	if(isdefined(on_enter_payload))
	{
		self thread [[on_enter_payload]](ent, endon_condition);
	}
	
	while(isdefined(ent) && ent IsTouching(self))
	{
		wait(0.01);
	}

	ent notify(endon_condition);

//	iprintlnbold(ent getentitynumber() + " leaves trigger " + self.targetname + ".");

	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		self thread [[on_exit_payload]](ent);
	}

	if(isdefined(ent))
	{
		self remove_trigger_from_ent(ent);
	}

	self notify(ender);	// Get rid of the death monitor thread.
}

function isOneRound()
{		
	if ( level.roundLimit == 1 )
		return true;

	return false;
}

function isFirstRound()
{
	if ( level.roundLimit > 1 && game[ "roundsplayed" ] == 0 )
		return true;
		
	return false;
}

function isLastRound()
{		
	if ( level.roundLimit > 1 && game[ "roundsplayed" ] >= ( level.roundLimit - 1 ) )
		return true;
		
	return false;
}

function wasLastRound()
{		
	if ( level.forcedEnd )
		return true;
	
	if ( isdefined( level.shouldPlayOvertimeRound ) )
	{
		if ( [[level.shouldPlayOvertimeRound]]() ) // start/keep playing overtime
		{
			level.nextRoundIsOvertime = true;
			return false;
		}
		else if ( isdefined( game["overtime_round"] ) ) // We were in overtime, but shouldn't play another round, we're done
		{
			return true;
		}
	}

	if ( hitRoundLimit() || hitScoreLimit() || hitRoundWinLimit() )
	{
		return true;
	}
		
	return false;
}

function hitRoundLimit()
{
	if( level.roundLimit <= 0 )
		return false;

	return ( getRoundsPlayed() >= level.roundLimit );
}

function anyTeamHitRoundWinLimit()
{
	foreach( team in level.teams )
	{
		if ( getRoundsWon(team) >= level.roundWinLimit )
			return true;
	}
	
	return false;
}

function anyTeamHitRoundLimitWithDraws()
{
	tie_wins = game["roundswon"]["tie"];
	
	foreach( team in level.teams )
	{
		if ( getRoundsWon(team) + tie_wins >= level.roundWinLimit )
			return true;
	}
	
	return false;
}

function getRoundWinLimitWinningTeam()
{
	max_wins = 0;
	winning_team = undefined;
	
	foreach( team in level.teams )
	{
		wins = getRoundsWon(team);
		
		if ( !isdefined( winning_team ) )
		{
			max_wins = wins;
			winning_team = team;
			continue;
		}
		
		if ( wins == max_wins )
		{
			winning_team = "tie";
		}
		else if ( wins > max_wins )
		{
			max_wins = wins;
			winning_team = team;
		}
	}
	
	return winning_team;
}

function hitRoundWinLimit()
{
	if( !isdefined(level.roundWinLimit) || level.roundWinLimit <= 0 )
		return false;

	if ( anyTeamHitRoundWinLimit() )
	{
		//"True" means that we should end the game
		return true;
	}
	
	//No over-time should occur if either team has more rounds won, even if there were rounds that ended in draw.
	// For example, If the round win limit is 5 and one team has one win and 4 draws occur in a row, we want to declare the 
	//team with the victory as the winner and not enter an over-time round.
	if( anyTeamHitRoundLimitWithDraws() )
	{
		//We want the game to have an over-time round if the teams are tied.
		//In a game with a win limit of 3, 3 ties in a row would cause the previous 'if' check to return 'true'.
		// We want to make sure the game doesn't end if that's the case.
		if( getRoundWinLimitWinningTeam() != "tie" )
		{
			return true;
		}
	}
	
	return false;
}


function any_team_hit_score_limit()
{
	foreach( team in level.teams )
	{
		if ( game["teamScores"][team] >= level.scoreLimit )
			return true;
	}
	
	return false;
}


function hitScoreLimit()
{
	if ( level.scoreRoundWinBased )
		return false;
		
	if( level.scoreLimit <= 0 )
		return false;

	if ( level.teamBased )
	{
		if( any_team_hit_score_limit() )
			return true;
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isdefined( player.pointstowin ) && ( player.pointstowin >= level.scorelimit ) )
				return true;
		}
	}
	return false;
}

function get_current_round_score_limit()
{
	return (level.roundScoreLimit * (game[ "roundsplayed" ] + 1));
}

function any_team_hit_round_score_limit()
{
	round_score_limit = get_current_round_score_limit();
	
	foreach( team in level.teams )
	{
		if ( game["teamScores"][team] >= round_score_limit )
			return true;
	}
	
	return false;
}


function hitRoundScoreLimit()
{
	if ( level.roundScoreLimit <= 0 )
		return false;
		
	if ( level.teamBased )
	{
		if( any_team_hit_round_score_limit() )
			return true;
	}
	else
	{
		roundScoreLimit = util::get_current_round_score_limit();

		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isdefined( player.pointstowin ) && ( player.pointstowin >= roundScoreLimit ) )
				return true;
		}
	}
	return false;
}

function getRoundsWon( team )
{
	return game["roundswon"][team];
}

function getOtherTeamsRoundsWon( skip_team )
{
	roundswon = 0;
	
	foreach ( team in level.teams )
	{
		if ( team == skip_team )
			continue;
			
		roundswon += game["roundswon"][team];
	}
	return roundswon;
}

function getRoundsPlayed()
{
	return game["roundsplayed"];
}

function isRoundBased()
{
	if ( level.roundLimit != 1 && level.roundWinLimit != 1 )
		return true;

	return false;
}

function isStrStart( string1, subStr )
{
	return ( getSubStr( string1, 0, subStr.size ) == subStr );
}

function isKillStreaksEnabled()
{
	return isdefined( level.killstreaksenabled ) && level.killstreaksenabled;
}

function isRankEnabled()
{
	return isdefined( level.rankEnabled ) && level.rankEnabled;
}

function setUsingRemote( remoteName )
{
	if ( isdefined( self.carryIcon) )
		self.carryIcon.alpha = 0;
	
	assert( !self isUsingRemote() );
	self.usingRemote = remoteName;

	self disableOffhandWeapons();
	self notify( "using_remote" );
}

function setObjectiveText( team, text )
{
	game["strings"]["objective_"+team] = text;
}

function setObjectiveScoreText( team, text )
{
	game["strings"]["objective_score_"+team] = text;
}

function setObjectiveHintText( team, text )
{
	game["strings"]["objective_hint_"+team] = text;
}

function getObjectiveText( team )
{
	return game["strings"]["objective_"+team];
}

function getObjectiveScoreText( team )
{
	return game["strings"]["objective_score_"+team];
}

function getObjectiveHintText( team )
{
	return game["strings"]["objective_hint_"+team];
}

function registerRoundSwitch( minValue, maxValue )
{
	level.roundSwitch = math::clamp( GetGametypeSetting( "roundSwitch" ), minValue, maxValue );
	level.roundSwitchMin = minValue;
	level.roundSwitchMax = maxValue;
}

function registerRoundLimit( minValue, maxValue )
{
	level.roundLimit = math::clamp( GetGametypeSetting( "roundLimit" ), minValue, maxValue );
	level.roundLimitMin = minValue;
	level.roundLimitMax = maxValue;
}


function registerRoundWinLimit( minValue, maxValue )
{
	level.roundWinLimit = math::clamp( GetGametypeSetting( "roundWinLimit" ), minValue, maxValue );
	level.roundWinLimitMin = minValue;
	level.roundWinLimitMax = maxValue;
}


function registerScoreLimit( minValue, maxValue )
{
	level.scoreLimit = math::clamp( GetGametypeSetting( "scoreLimit" ), minValue, maxValue );
	level.scoreLimitMin = minValue;
	level.scoreLimitMax = maxValue;
	SetDvar( "ui_scorelimit", level.scoreLimit );
}


function registerRoundScoreLimit( minValue, maxValue )
{
	level.roundScoreLimit = math::clamp( GetGametypeSetting( "roundScoreLimit" ), minValue, maxValue );
	level.roundScoreLimitMin = minValue;
	level.roundScoreLimitMax = maxValue;
}


function registerTimeLimit( minValue, maxValue )
{
	level.timeLimit = math::clamp( GetGametypeSetting( "timeLimit" ), minValue, maxValue );
	level.timeLimitMin = minValue;
	level.timeLimitMax = maxValue;
	SetDvar( "ui_timelimit", level.timeLimit );
}


function registerNumLives( minValue, maxValue )
{	
	level.numLives = math::clamp( GetGametypeSetting( "playerNumLives" ), minValue, maxValue );
	level.numLivesMin = minValue;
	level.numLivesMax = maxValue;
}

function getPlayerFromClientNum( clientNum )
{
	if ( clientNum < 0 )
		return undefined;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		if ( level.players[i] getEntityNumber() == clientNum )
			return level.players[i];
	}
	return undefined;
}

function isPressBuild()
{
	buildType = GetDvarString( "buildType" );

	if ( isdefined( buildType ) && buildtype == "press" )
	{
		return true;
	}
	
	return false;
}

function isFlashbanged()
{
	return isdefined( self.flashEndTime ) && gettime() < self.flashEndTime;
}

function DoMaxDamage( origin, attacker, inflictor, headshot, mod ) // self == entity to damage
{
	if ( isdefined( self.damagedToDeath ) && self.damagedToDeath )
	{
		return;
	}

	if ( isdefined( self.maxHealth ) )
	{
		damage = self.maxHealth + 1;
	}
	else
	{
		damage = self.health + 1;
	}

	self.damagedToDeath = true;

	self DoDamage( damage, origin, attacker, inflictor, headshot, mod );
}


/@
"Name: self_delete()"
"Summary: Just calls the delete() script command on self. Reason for this is so that we can use array::thread_all to delete entities"
"Module: Entity"
"CallOn: An entity"
"Example: ai[ 0 ] thread self_delete();"
"SPMP: singleplayer"
@/
function self_delete()
{
	if ( isdefined( self ) )
	{
		self delete();
	}
}


/@
"Name: screen_message_create(<string_message>)"
"Summary: Creates a HUD element at the correct position with the string or string reference passed in."
"Module: Utility"
"CallOn: N/A"
"MandatoryArg: <string_message_1> : A string or string reference to place on the screen."
"OptionalArg: <string_message_2> : A second string to display below the first."
"OptionalArg: <string_message_3> : A third string to display below the second."
"OptionalArg: <n_offset_y>: Optional offset in y direction that should only be used in very specific circumstances."
"OptionalArg: <n_time> : Length of time to display the message."
"Example: screen_message_create( &"LEVEL_STRING" );"
"SPMP: singleplayer"
@/
function screen_message_create( string_message_1, string_message_2, string_message_3, n_offset_y, n_time )
{
	level notify( "screen_message_create" );
	level endon( "screen_message_create" );
	
	// if the mission is failing then do no create this instruction
	// because it can potentially overlap the death/hint string
	if( isdefined( level.missionfailed ) && level.missionfailed )
		return;
	
	// if player is killed then this dvar will be set.
	// SUMEET_TODO - make it efficient next game instead of checking dvar here
	if( GetDvarInt( "hud_missionFailed" ) == 1 )
		return;

	if ( !isdefined( n_offset_y ) )
	{
		n_offset_y = 0;
	}
	
	//handle displaying the first string
	if( !isdefined(level._screen_message_1) )
	{
		//text element that displays the name of the event
		level._screen_message_1 = NewHudElem();
		level._screen_message_1.elemType = "font";
		level._screen_message_1.font = "objective";
		level._screen_message_1.fontscale = 1.8;
		level._screen_message_1.horzAlign = "center";
		level._screen_message_1.vertAlign = "middle";
		level._screen_message_1.alignX = "center";
		level._screen_message_1.alignY = "middle";
		level._screen_message_1.y = -60 + n_offset_y;
		level._screen_message_1.sort = 2;
		
		level._screen_message_1.color = ( 1, 1, 1 );
		level._screen_message_1.alpha = 1;
		
		level._screen_message_1.hidewheninmenu = true;
	}

	//set the text of the element to the string passed in
	level._screen_message_1 SetText( string_message_1 );

	if( isdefined(string_message_2) )
	{
		//handle displaying the first string
		if( !isdefined(level._screen_message_2) )
		{
			//text element that displays the name of the event
			level._screen_message_2 = NewHudElem();
			level._screen_message_2.elemType = "font";
			level._screen_message_2.font = "objective";
			level._screen_message_2.fontscale = 1.8;
			level._screen_message_2.horzAlign = "center";
			level._screen_message_2.vertAlign = "middle";
			level._screen_message_2.alignX = "center";
			level._screen_message_2.alignY = "middle";
			level._screen_message_2.y = -33 + n_offset_y;
			level._screen_message_2.sort = 2;

			level._screen_message_2.color = ( 1, 1, 1 );
			level._screen_message_2.alpha = 1;
			
			level._screen_message_2.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		level._screen_message_2 SetText( string_message_2 );
	}
	else if( isdefined(level._screen_message_2) )
	{
		level._screen_message_2 Destroy();
	}
	
	if( isdefined(string_message_3) )
	{
		//handle displaying the first string
		if( !isdefined(level._screen_message_3) )
		{
			//text element that displays the name of the event
			level._screen_message_3 = NewHudElem();
			level._screen_message_3.elemType = "font";
			level._screen_message_3.font = "objective";
			level._screen_message_3.fontscale = 1.8;
			level._screen_message_3.horzAlign = "center";
			level._screen_message_3.vertAlign = "middle";
			level._screen_message_3.alignX = "center";
			level._screen_message_3.alignY = "middle";
			level._screen_message_3.y = -6 + n_offset_y;
			level._screen_message_3.sort = 2;

			level._screen_message_3.color = ( 1, 1, 1 );
			level._screen_message_3.alpha = 1;
			
			level._screen_message_3.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		level._screen_message_3 SetText( string_message_3 );
	}
	else if( isdefined(level._screen_message_3) )
	{
		level._screen_message_3 Destroy();
	}
	
	if ( isdefined( n_time ) && n_time > 0 )
	{
		wait( n_time );
		
		screen_message_delete();
	}
}

/@
"Name: screen_message_delete()"
"Summary: Deletes the current message being displayed on the screen made using screen_message_create."
"Module: Utility"
"CallOn: N/A"
"Example: screen_message_delete();"
"SPMP: singleplayer"
@/
function screen_message_delete( delay )
{
	if( isdefined( delay ) )
	{
		wait( delay );
	}
	
	if( isdefined(level._screen_message_1) )
	{
		level._screen_message_1 Destroy();
	}
	if( isdefined(level._screen_message_2) )
	{
		level._screen_message_2 Destroy();
	}
	if( isdefined(level._screen_message_3) )
	{
		level._screen_message_3 Destroy();
	}
}




/@
"Name: screen_fade_out( [n_time], [str_shader] )"
"Summary: Fades the screen out.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"OptionalArg: n_time: The time to fade. Defaults to 2 seconds. Can be 0."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"OptionalArg: b_foreground: Set whether the HUD element is in the foreground. Defaults to false."
"OptionalArg: b_force: Force the fade regardless of fade state flag."
"Example: screen_fade_out( 3 );"
"SPMP: singleplayer"
@/
function screen_fade_out( n_time, str_shader, b_foreground = false, b_force = false )
{
	level notify( "_screen_fade" );
	level endon( "_screen_fade" );

	if(!level flag::exists("screen_fade_in_end"))
	{
		level flag::init( "screen_fade_out_start" );
		level flag::init( "screen_fade_out_end" );
		level flag::init( "screen_fade_in_start" );
		level flag::init( "screen_fade_in_end" );
	}
	level flag::clear( "screen_fade_in_end" );
	
	if (!b_force )
	{
		if(level flag::get("screen_fade_out_end"))//already faded out
			return;
	}
		
	if ( !isdefined( n_time ) )
	{
		n_time = 2;
	}
	
	hud = get_fade_hud( str_shader );
	hud.alpha = 0;
	hud.foreground = b_foreground;
	
	
	if ( isdefined( n_time ) && ( n_time > 0 ) )
	{
		hud FadeOverTime( n_time );
		hud.alpha = 1;
		
		level flag::set( "screen_fade_out_start" );
		
		wait n_time;
	}
	else
	{
		hud.alpha = 1;
	}
	
	level flag::clear( "screen_fade_out_start" );
	level flag::set( "screen_fade_out_end" );
}

/@
"Name: screen_fade_in( [n_time], [str_shader] )"
"Summary: Fades the screen in.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"OptionalArg: n_time: The time to fade. Defaults to 2 seconds. Can be 0."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"OptionalArg: b_foreground: Set whether the HUD element is in the foreground. Defaults to false."
"OptionalArg: b_force: Force the fade regardless of fade state flag."
"Example: screen_fade_in( 3 );"
"SPMP: singleplayer"
@/
function screen_fade_in( n_time, str_shader, b_foreground = false, b_force = false )
{
	level notify( "_screen_fade" );
	level endon( "_screen_fade" );

	if(!level flag::exists("screen_fade_in_end"))
	{
		level flag::init( "screen_fade_out_start" );
		level flag::init( "screen_fade_out_end" );
		level flag::init( "screen_fade_in_start" );
		level flag::init( "screen_fade_in_end" );
	}
	level flag::clear( "screen_fade_out_end" );
	
	if(!b_force)
	{
		if(level flag::get("screen_fade_in_end"))//already faded out
			return;
	}


	if ( !isdefined( n_time ) )
	{
		n_time = 2;
	}
	
	hud = get_fade_hud( str_shader );
	hud.alpha = 1;
	hud.foreground = b_foreground;
	
	if ( n_time > 0 )
	{
		hud FadeOverTime( n_time );
		hud.alpha = 0;
		
		level flag::set( "screen_fade_in_start" );
		
		wait n_time;
	}
	
	if ( isdefined( level.fade_hud ) )
	{
		level.fade_hud Destroy();
	}
	
	level flag::clear( "screen_fade_in_start" );
	level flag::set( "screen_fade_in_end" );
}

/@
"Name: screen_fade_to_alpha_with_blur( n_alpha, [n_time], [n_blur], [str_shader] )"
"Summary: Fades the screen in to a specified alpha and blur value.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: n_alpha: The alpha value to fade the hud to."
"MandatoryArg: n_fade_time: The time to fade."
"OptionalArg: n_blur: The blur value."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"Example: screen_fade_to_alpha_with_blur( .3, 4, 1 );"
"SPMP: singleplayer"
@/
function screen_fade_to_alpha_with_blur( n_alpha, n_fade_time, n_blur, str_shader )
{
	Assert( isdefined( n_alpha ), "Must specify an alpha value for screen_fade_to_alpha_with_blur." );
	Assert( IsPlayer( self ), "screen_fade_to_alpha_with_blur can only be called on players!" );
	
	level notify( "_screen_fade" );
	level endon( "_screen_fade" );
	
	hud_fade = get_fade_hud( str_shader );
	hud_fade FadeOverTime( n_fade_time );
	hud_fade.alpha = n_alpha;
	
	if ( isdefined( n_blur ) && ( n_blur >= 0 ) )
	{
		self SetBlur( n_blur, n_fade_time );
	}
	
	wait n_fade_time;
}

/@
"Name: screen_fade_to_alpha( n_alpha, [n_time], [str_shader] )"
"Summary: Fades the screen in to a specified alpha value.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: n_alpha: The alpha value to fade the hud to."
"MandatoryArg: n_fade_time: The time to fade."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"Example: screen_fade_to_alpha( .3 );"
"SPMP: singleplayer"
@/
function screen_fade_to_alpha( n_alpha, n_fade_time, str_shader )
{
	screen_fade_to_alpha_with_blur( n_alpha, n_fade_time, 0, str_shader );
}

/@
"Name: set_screen_fade_timer( [delay] )"
"Summary: Set the timer for screen fade."
"Module: Level"
"CallOn: N/A"
"MandatoryArg: [delay] : The delay in which you want the screen to fade in or out. Default is set to 2 seconds"
"Example: set_screen_fade_timer( 7 );"
"SPMP: singleplayer"
@/
function set_screen_fade_timer( delay )
{
	assert( isdefined( delay ), "You must specify a delay to change the fade screen's fadeTimer." );
	
	level.fade_screen.fadeTimer = delay;
}


function get_fade_hud( str_shader )
{
	/*if ( !isdefined( str_shader ) )
	{
		str_shader = "black";
	}
	
	if ( !isdefined( level.fade_hud ) )
	{
		level.fade_hud = NewHudElem();
		level.fade_hud.x = 0;
		level.fade_hud.y = 0;
		level.fade_hud.horzAlign  = "fullscreen";
		level.fade_hud.vertAlign  = "fullscreen";
		//level.fade_hud.foreground = false; //Arcade Mode compatible
		level.fade_hud.sort = 0;
		level.fade_hud.alpha = 0;
	}
		
	level.fade_hud SetShader( str_shader, 640, 480 );*/
	return level.fade_hud;
}


// button pressed wrappers
function use_button_pressed()
{
	Assert( IsPlayer( self ), "Must call use_button_pressed() on a player." );
	return ( self UseButtonPressed() );
}


/@
"Name: waittill_use_button_pressed()"
"Summary: Waits until the player is pressing their use button."
"Module: Player"
"Example: level.player waittill_use_button_pressed()"
"SPMP: SP"
@/

function waittill_use_button_pressed()
{
	while ( !self use_button_pressed() )
	{
		wait .05;
	}
}