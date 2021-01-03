#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\trigger_shared;
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
"Name: append_array_struct( <dst>, <src> )"
"Summary: Append the array elements in the <src> (2nd) array struct parameter to the array in the <dst> (1st) array struct parameter."
"Module: Array"
"CallOn: "
"MandatoryArg: <dst> : Destination - Elements from <src>.a[] are appended to <dst>.a[]"
"MandatoryArg: <src> : Source - Elements from <src>.a[] are appended to <dst>.a[]"
"Example: players = append_array_struct(); worst_enemies = built_worst_enemies(); append_array_struct( players, worst_enemies ;"
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

function brush_delete()
{
	num = self.v[ "exploder" ];
	
	if( isdefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}
	else
	{
		wait( .05 );// so it disappears after the replacement appears
	}

	if( !isdefined( self.model ) )
	{
		return;
	}


	assert( isdefined( self.model ) );

	if( !isdefined( self.v[ "fxid" ] ) || self.v[ "fxid" ] == "No FX" )
	{
		self.v[ "exploder" ] = undefined;
	}
		
	waittillframeend;// so it hides stuff after it shows the new stuff
	self.model delete();
}

function brush_show()
{
	if( isdefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}
	
	assert( isdefined( self.model ) );
	
	self.model show();
	self.model solid();
}

function brush_throw()
{
	if( isdefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}

	ent = undefined;
	
	if( isdefined( self.v[ "target" ] ) )
	{
		ent = getent( self.v[ "target" ], "targetname" );
	}

	if( !isdefined( ent ) )
	{
		self.model delete();
		return;
	}

	self.model show();

	startorg = self.v[ "origin" ];
	startang = self.v[ "angles" ];
	org = ent.origin;


	temp_vec = ( org - self.v[ "origin" ] );
	x = temp_vec[ 0 ];
	y = temp_vec[ 1 ];
	z = temp_vec[ 2 ];

	self.model rotateVelocity( ( x, y, z ), 12 );

	self.model moveGravity( ( x, y, z ), 12 );
	
	self.v[ "exploder" ] = undefined;
	wait( 6 );
	self.model delete();
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

function playSoundOnPlayers( sound, team )
{
	assert( isdefined( level.players ) );
	
	if ( level.splitscreen )
	{	
		if ( isdefined( level.players[0] ) )
			level.players[0] playLocalSound(sound);
	}
	else
	{
		if ( isdefined( team ) )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if ( isdefined( player.pers["team"] ) && (player.pers["team"] == team))
					player playLocalSound(sound);
			}
		}
		else
		{
			for ( i = 0; i < level.players.size; i++ )
				level.players[i] playLocalSound(sound);
		}
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

function set_dvar_if_unset( dvar, value, reset)
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

function set_dvar_float_if_unset( dvar, value, reset)
{
	if (!isdefined(reset))
		reset = false;

	if (reset || GetDvarString(dvar)=="")
	{
		SetDvar(dvar, value);
	}
	
	return GetDvarFloat(dvar);
}

function set_dvar_int_if_unset( dvar, value, reset)
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


function anyTeamHitScoreLimit()
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
		if( anyTeamHitScoreLimit() )
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

function getRemoteName()
{
	assert( self isUsingRemote() );
	
	return self.usingRemote;	
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
"Name: get_array_of_closest( <org> , <array> , <excluders> , <max>, <maxdist> )"
"Summary: Returns an array of all the entities in < array > sorted in order of closest to farthest."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on."
"OptionalArg: <excluders> : Array of entities to exclude from the check."
"OptionalArg: <max> : Max size of the array to return"
"OptionalArg: <maxdist> : Max distance from the origin to return acceptable entities"
"Example: allies_sort = get_array_of_closest( originFC1.origin, allies );"
"SPMP: singleplayer"
@/
function get_array_of_closest( org, array, excluders, max, maxdist )
{
	// pass an array of entities to this function and it will return them in the order of closest
	// to the origin you pass, you can also set max to limit how many ents get returned
	
	if(!isdefined(max))max=array.size;
	if(!isdefined(excluders))excluders=[];

	maxdists2rd = undefined;
	if ( isdefined( maxdist ) )
	{
		maxdists2rd = maxdist * maxdist;
	}

	// return the array, reordered from closest to farthest
	dist = [];
	index = [];
	for ( i = 0; i < array.size; i++ )
	{
		if ( !isdefined( array[ i ] ) )
		{
			continue;
		}
		
		if ( IsInArray( excluders, array[ i ] ) )
		{
			continue;
		}

		if ( IsVec( array[i] ) )
		{
			length = DistanceSquared( org, array[ i ] );
		}
		else
		{
			length = DistanceSquared( org, array[ i ].origin );
		}

		if ( isdefined( maxdists2rd ) && maxdists2rd < length )
		{
			continue;
		}

		dist[ dist.size ] = length;
		index[ index.size ] = i;
	}

	for ( ;; )
	{
		change = false;
		for ( i = 0; i < dist.size - 1; i++ )
		{
			if ( dist[ i ] <= dist[ i + 1 ] )
			{
				continue;
			}
			
			change = true;
			temp = dist[ i ];
			dist[ i ] = dist[ i + 1 ];
			dist[ i + 1 ] = temp;
			temp = index[ i ];
			index[ i ] = index[ i + 1 ];
			index[ i + 1 ] = temp;
		}
		
		if ( !change )
		{
			break;
		}
	}

	newArray = [];
	if ( max > dist.size )
	{
		max = dist.size;
	}
	
	for ( i = 0; i < max; i++ )
	{
		newArray[ i ] = array[ index[ i ] ];
	}
	
	return newArray;
}
