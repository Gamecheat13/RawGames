#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
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

function isStrStart( string1, subStr )
{
	return ( getSubStr( string1, 0, subStr.size ) == subStr );
}

function isKillStreaksEnabled()
{
	return isdefined( level.killstreaksenabled ) && level.killstreaksenabled;
}

function setUsingRemote( remoteName, set_killstreak_delay_killcam = true )
{
	if ( isdefined( self.carryIcon) )
		self.carryIcon.alpha = 0;
	
	assert( !self isUsingRemote() );
	self.usingRemote = remoteName;

	if ( set_killstreak_delay_killcam )
		self.killstreak_delay_killcam = remoteName; // this is the only place we set directly, do not use killstreaks::set_killstreak_delay_killcam() here
			
	self disableOffhandWeapons();
	self clientfield::set_player_uimodel( "hudItems.remoteKillstreakActivated", 1 );	
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
"Name: ghost_wait_show()"
"Summary: ghosts an entity, waits, then shows the entity; mainly used to hide pops when setting up models poses via setanim"
"Module: Entity"
"CallOn: An entity"
"Example: turret thread ghost_wait_show();"
"SPMP: multiplayer"
@/
function ghost_wait_show( wait_time = 0.1 )
{
	self endon( "death" );
	
	self Ghost();
	wait wait_time;
	self Show();
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