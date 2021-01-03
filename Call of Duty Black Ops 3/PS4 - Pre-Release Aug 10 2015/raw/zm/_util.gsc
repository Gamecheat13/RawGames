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

function isStrStart( string1, subStr )
{
	return ( getSubStr( string1, 0, subStr.size ) == subStr );
}

function isKillStreaksEnabled()
{
	return isdefined( level.killstreaksenabled ) && level.killstreaksenabled;
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
