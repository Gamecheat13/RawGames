#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\load_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\string_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\coop;

                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

#namespace util;






#precache( "lui_menu", "CPHintText" );
#precache( "lui_menu_data", "hint_text_line" );

/@
"Name: add_gametype()"
"Summary: dummy - Rex looks for these to populate the gametype pulldown"
"SPMP: COOP"
@/ 
function add_gametype( gt )
{
}


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

function plot_points( plotpoints, r=1, g=1, b=1, server_frames=1 )
{
	/#
	lastpoint = plotpoints[ 0 ];
	server_frames = int( server_frames );//Make sure this is an int

	for( i = 1;i < plotpoints.size;i ++ )
	{
		// AE 10-26-09: line function must have changed to Line( <start>, <end>, <color>, <depthTest>, <duration> )
		line( lastpoint, plotpoints[ i ], ( r, g, b ), 1, server_frames );
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
"Summary: Creates a HUD element at the correct position with the string or string reference passed in. Shows on all players screens in a co-op game."
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
"Name: screen_message_create_client(<string_message>)"
"Summary: Creates a HUD element at the correct position with the string or string reference passed in, for a specific client."
"Module: Utility"
"CallOn: Player, specific client to recieve the screen message"
"MandatoryArg: <string_message_1> : A string or string reference to place on the screen."
"OptionalArg: <string_message_2> : A second string to display below the first."
"OptionalArg: <string_message_3> : A third string to display below the second."
"OptionalArg: <n_offset_y>: Optional offset in y direction that should only be used in very specific circumstances."
"OptionalArg: <n_time> : Length of time to display the message."
"Example: level.players[0] screen_message_create( &"LEVEL_STRING" );"
"SPMP: co-op"
@/
function screen_message_create_client( string_message_1, string_message_2, string_message_3, n_offset_y, n_time ) // self = player
{
	self notify( "screen_message_create" );
	self endon( "screen_message_create" );
	self endon( "death" );
	
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
	if( !isdefined(self._screen_message_1) )
	{
		//text element that displays the name of the event
		self._screen_message_1 = NewClientHudElem( self );
		self._screen_message_1.elemType = "font";
		self._screen_message_1.font = "objective";
		self._screen_message_1.fontscale = 1.8;
		self._screen_message_1.horzAlign = "center";
		self._screen_message_1.vertAlign = "middle";
		self._screen_message_1.alignX = "center";
		self._screen_message_1.alignY = "middle";
		self._screen_message_1.y = -60 + n_offset_y;
		self._screen_message_1.sort = 2;
		
		self._screen_message_1.color = ( 1, 1, 1 );
		self._screen_message_1.alpha = 1;
		
		self._screen_message_1.hidewheninmenu = true;
	}

	//set the text of the element to the string passed in
	self._screen_message_1 SetText( string_message_1 );

	if( isdefined(string_message_2) )
	{
		//handle displaying the first string
		if( !isdefined(self._screen_message_2) )
		{
			//text element that displays the name of the event
			self._screen_message_2 = NewClientHudElem( self );
			self._screen_message_2.elemType = "font";
			self._screen_message_2.font = "objective";
			self._screen_message_2.fontscale = 1.8;
			self._screen_message_2.horzAlign = "center";
			self._screen_message_2.vertAlign = "middle";
			self._screen_message_2.alignX = "center";
			self._screen_message_2.alignY = "middle";
			self._screen_message_2.y = -33 + n_offset_y;
			self._screen_message_2.sort = 2;

			self._screen_message_2.color = ( 1, 1, 1 );
			self._screen_message_2.alpha = 1;
			
			self._screen_message_2.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		self._screen_message_2 SetText( string_message_2 );
	}
	else if( isdefined(self._screen_message_2) )
	{
		self._screen_message_2 Destroy();
	}
	
	if( isdefined(string_message_3) )
	{
		//handle displaying the first string
		if( !isdefined(self._screen_message_3) )
		{
			//text element that displays the name of the event
			self._screen_message_3 = NewClientHudElem( self );
			self._screen_message_3.elemType = "font";
			self._screen_message_3.font = "objective";
			self._screen_message_3.fontscale = 1.8;
			self._screen_message_3.horzAlign = "center";
			self._screen_message_3.vertAlign = "middle";
			self._screen_message_3.alignX = "center";
			self._screen_message_3.alignY = "middle";
			self._screen_message_3.y = -6 + n_offset_y;
			self._screen_message_3.sort = 2;

			self._screen_message_3.color = ( 1, 1, 1 );
			self._screen_message_3.alpha = 1;
			
			self._screen_message_3.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		self._screen_message_3 SetText( string_message_3 );
	}
	else if( isdefined(self._screen_message_3) )
	{
		self._screen_message_3 Destroy();
	}
	
	if ( isdefined( n_time ) && n_time > 0 )
	{
		wait( n_time );
		
		self screen_message_delete_client();
	}
}

/@
"Name: screen_message_delete_client()"
"Summary: Deletes the current message being displayed on the client's screen made using screen_message_create_client."
"Module: Utility"
"CallOn: N/A"
"Example: level.players[0] screen_message_delete_client();"
"SPMP: co-op"
@/
function screen_message_delete_client( delay )
{
	self endon( "death" );
	
	if( isdefined( delay ) )
	{
		wait( delay );
	}
	
	if( isdefined(self._screen_message_1) )
	{
		self._screen_message_1 Destroy();
	}
	if( isdefined(self._screen_message_2) )
	{
		self._screen_message_2 Destroy();
	}
	if( isdefined(self._screen_message_3) )
	{
		self._screen_message_3 Destroy();
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
	level lui::screen_fade_out( n_time, str_shader );
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
	level lui::screen_fade_in( n_time, str_shader );
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

function get_fade_hud( str_shader )
{
	if ( !isdefined( str_shader ) )
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
		
	level.fade_hud SetShader( str_shader, 640, 480 );
	return level.fade_hud;
}

/@
"Name: missionFailedWrapper( fail_hint, shader, iWidth, iHeight, fDelay, x, y, b_count_as_death = true )"
"Summary: Call when you want the player to fail the mission."
"Module: Utility"
"CallOn: player or level entity"
"MandatoryArg:"
"OptionalArg: [fail_reason] : Localized string for the reason the player failed the mission."
"OptionalArg: [fail_hint] : Localized hint for how they can not fail the mission next time."
"OptionalArg: [shader] 	  : Special fail icon Shader/Icon."
"OptionalArg: [iWidth] 	  : Shader/Icon width."
"OptionalArg: [iHeight]	  :	Shader/Icon height."
"OptionalArg: [fDelay] 	  : Delay to show the Shader/Icon."
"OptionalArg: [b_count_as_death] : Count again player stats for deaths."
"Example: _utility::missionFailedWrapper();"
"SPMP: singleplayer"
@/
function missionfailedwrapper( fail_reason, fail_hint, shader, iWidth, iHeight, fDelay, x, y, b_count_as_death = true )
{
	if( level.missionfailed )
	{
		return;
	}

	if ( isdefined( level.nextmission ) )
	{
		return;  // don't fail the mission while the game is on it's way to the next mission.
	}
		
	if ( GetDvarString( "failure_disabled" ) == "1" )
	{
		return;
	}

	// delete any existing in-game instructions created by screen_message_create() functionality
	screen_message_delete();

	if( isdefined( fail_hint ) )
	{
		SetDvar( "ui_deadquote", fail_hint );
	}
	
	if( isdefined( shader ) )
	{
		GetPlayers()[0] thread load::special_death_indicator_hudelement( shader, iWidth, iHeight, fDelay, x, y );
	}
	
	level.missionfailed = true;
	// TODO: Why did this stop working?
	// level flag::set( "missionfailed" );

	if ( b_count_as_death )
	{
	//	GetPlayers()[0] inc_general_stat( "deaths" );
	}
	
	coop::fadeOutAndLoadCheckpoint( fail_reason, fail_hint );
}

/@
"Name: missionfailedwrapper_nodeath( fail_hint, shader, iWidth, iHeight, fDelay, x, y )"
"Summary: Call when you want the player to fail the mission but not count towards player death stats."
"Module: Utility"
"CallOn: player or level entity"
"MandatoryArg:"
"OptionalArg: [fail_reason] : Localized string for the reason the player failed the mission."
"OptionalArg: [fail_hint] : Localized hint for how they can not fail the mission next time."
"OptionalArg: [shader] 	  : Special fail icon Shader/Icon."
"OptionalArg: [iWidth] 	  : Shader/Icon width."
"OptionalArg: [iHeight]	  :	Shader/Icon height."
"OptionalArg: [fDelay] 	  : Delay to show the Shader/Icon."
"Example: _utility::missionfailedwrapper_nodeath();"
"SPMP: singleplayer"
@/
function missionfailedwrapper_nodeath( fail_reason, fail_hint, shader, iWidth, iHeight, fDelay, x, y )
{
	missionfailedwrapper( fail_reason, fail_hint, shader, iWidth, iHeight, fDelay, x, y, false );
}

function helper_message( message, delay, str_abort_flag )
{
	level notify( "kill_helper_message" );
	level endon( "kill_helper_message" );

	helper_message_delete();

	level.helper_message = message;

	util::screen_message_create( message );

	if( !isdefined(delay) )
	{
		delay = 5;
	}

	start_time = GetTime();
	while( 1 )
	{
		time = GetTime();
		dt = ( time - start_time ) / 1000;
		if( dt >= delay )
		{
			break;
		}

		if( isdefined(str_abort_flag) && (level flag::get(str_abort_flag) == true) )
		{
			break;
		}

		wait( 0.01 );
	}
	

	if( isdefined(level.helper_message) )
	{
		util::screen_message_delete();
	}

	level.helper_message = undefined;
}

function helper_message_delete()
{
	if( isdefined(level.helper_message) )
	{
		util::screen_message_delete();
	}
	level.helper_message = undefined;
}

/@
"Name: show_hit_marker()"
"Summary: Displays hit marker on player HUD. Use this when custom scripting script models or brushes that need damage feedback."
"Module: HUD"
"CallOn: Player"
"Example: player show_hit_marker();"
@/
function show_hit_marker()  // self = player
{
	if ( IsDefined( self ) && IsDefined( self.hud_damagefeedback ) )  // hud_damagefeedback declared in _damagefeedback.gsc
	{
		self.hud_damagefeedback SetShader( "damage_feedback", 24, 48 );
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback FadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}	
}

/@
"Name: init_hero(name, func_init, arg1, arg2, arg3, arg4, arg5 )"
"Summary: a function that can spawn or grab an entity and turn it into a hero character."
"Module: Level"
"CallOn: N/A"
"OptionalArg: func_init, arg1, arg2, arg3, arg4, arg5"
"Example: init_hero(woods, ::equip_wooods, primary_gun, secondary_gun);
"SPMP: singleplayer"
@/

function init_hero( name, func_init, arg1, arg2, arg3, arg4, arg5, b_show_in_ev = true )
{
	if ( !isdefined( level.heroes ) )
	{
		level.heroes = [];
	}

	name = ToLower( name );

	ai_hero = GetEnt( name + "_ai", "targetname", true );
	if ( !IsAlive( ai_hero ) )
	{
		ai_hero = GetEnt( name, "targetname", true );
		
		if ( !IsAlive( ai_hero ) )
		{
			spawner = GetEnt( name, "targetname" );
			if ( !( isdefined( spawner.spawning ) && spawner.spawning ) )
			{
				spawner.count++;
				ai_hero = spawner::simple_spawn_single( spawner );
				
				Assert( isdefined( ai_hero ), "Failed to spawn hero '" + name + "'." );
				
				spawner notify( "hero_spawned", ai_hero );
			}
			else
			{
				// Another thread is already spawning this hero, just wait for that one
				spawner waittill( "hero_spawned", ai_hero );
			}
		}
	}
	
	level.heroes[ name ] = ai_hero;
	ai_hero.animname = name;
	ai_hero.is_hero = true;
	ai_hero.enableTerrainIk = 1; //enable IK on Heros
	
	if ( IsDefined( ai_hero.script_friendname ) )
	{
		if( ai_hero.script_friendname == "none" )
		{
			ai_hero.propername = "";
		}
		else
		{
			ai_hero.propername = ai_hero.script_friendname;
		}
	}
	else
	{
		ai_hero.propername = name;
	}
	
	ai_hero util::magic_bullet_shield();

	ai_hero thread _hero_death( name );

	if ( IsDefined( func_init ) )
	{
		util::single_thread( ai_hero, func_init, arg1, arg2, arg3, arg4, arg5 );
	}

	if ( isdefined( level.customHeroSpawn ) )
	{
		ai_hero [[level.customHeroSpawn]]();
	}
	
	if( b_show_in_ev )
	{
		ai_hero thread oed::enable_thermal();
	}
	
	return ai_hero;
}

/@
"Name: init_heroes(a_hero_names, func_init, arg1, arg2, arg3, arg4, arg5 )"
"Summary: a function that takes an array of targetname string and set them up as hero characters"
"Module: Level"
"CallOn: N/A"
"OptionalArg: func_init, arg1, arg2, arg3, arg4, arg5"
"Example: init_hero( a_pow_heroes, ::equip_pow_heroes, primary_gun, secondary_gun);
"SPMP: singleplayer"
@/

function init_heroes( a_hero_names, func, arg1, arg2, arg3, arg4, arg5 )
{
	a_heroes = [];
	foreach ( str_hero in a_hero_names )
	{
		if ( !isdefined( a_heroes ) ) a_heroes = []; else if ( !IsArray( a_heroes ) ) a_heroes = array( a_heroes ); a_heroes[a_heroes.size]=init_hero( str_hero, func, arg1, arg2, arg3, arg4, arg5 );;
	}

	return a_heroes;
}


function _hero_death( str_name )
{
	self endon( "unmake_hero" );
	self waittill( "death" );
	
	if ( isdefined( self ) )
	{
		AssertMsg( "Hero '" + str_name + "' died." );
	}

	unmake_hero( str_name );
}

/@
"Name: unmake_hero()"
"Summary: Removes the AI from the hero list and stops hero behaviors running on the AI such as magic_bullet_shield."
"Module: AI"
"CallOn: Friendly AI"
"Example: unmake_hero( "hendricks" );"
"SPMP: singleplayer"
@/
function unmake_hero( str_name )
{
	ai_hero = level.heroes[ str_name ];
	
	level.heroes = array::remove_index( level.heroes, str_name, true );
	
	// Do this last, as the _hero_death thread will be killed by it.
	if ( IsAlive( ai_hero ) )
	{
		ai_hero util::stop_magic_bullet_shield();
		ai_hero notify( "unmake_hero" );
	}
}

/@
"Name: get_heroes()"
"Summary: Returns an array of all heroes currently in the level."
"Module: AI"
"Example: heroes = get_heroes();"
"SPMP: singleplayer"
@/
function get_heroes()
{
	return level.heroes;
}


/@
"Name: get_hero( str_name )"
"Summary: Returns a hero, or tries to spawn one if he doesn't exist"
"Module: Level"
"Example: level.ai_hendricks = get_hero( "hendricks" );"
"SPMP: singleplayer"
@/
function get_hero( str_name )
{
	if ( !isdefined( level.heroes ) )
	{
		level.heroes = [];
	}
	
	if ( isdefined( level.heroes[ str_name ] ) )
	{
		return level.heroes[ str_name ];
	}
	else
	{
		return init_hero( str_name );
	}
}

/@
"Name: is_hero()"
"Summary: Returns true if the AI is a hero, false if he is not."
"Module: AI"
"CallOn: Friendly AI"
"Example: ai_friendly is_hero();"
"SPMP: singleplayer"
@/
function is_hero()
{
	return ( isdefined( self.is_hero ) && self.is_hero );
}

function init_streamer_hints( number_of_zones )
{
	clientfield::register( "world", "force_streamer", 1, GetMinBitCountForNum( number_of_zones ), "int" );
}

/@
"Name: clear_streamer_hint()"
"Summary: Clear all streamer hints."
"CallOn: NA"
"Example: util::clear_streamer_hint()"
@/
function clear_streamer_hint()
{
	level flag::wait_till( "all_players_connected" );
	level clientfield::set( "force_streamer", 0 );
}

/@
"Name: set_streamer_hint( <n_zone>, [b_clear_previous = true] )"
"Summary: Force the streamer to load a particular zone that you've set up in client script."
"CallOn: NA"
"MandatoryArg: <n_zone> : Integer of the zone you've defined"
"OptionalArg: [b_clear_previous] : Clears all previous streamer hints that script has asked for"
"Example: util::set_streamer_hint( STREAMER_LEVEL_START )"
@/
function set_streamer_hint( n_zone, b_clear_previous = true )
{
	level notify( "set_streamer_hint" );
	level endon( "set_streamer_hint" );
	
	level util::streamer_wait();
	
	Assert( n_zone > 0, "Streamer hint zone values must be > 0." );
	
	level flagsys::set( "streamer_loading" );
	
	level flag::wait_till( "all_players_connected" );
	
	if ( b_clear_previous )
	{
		level clientfield::set( "force_streamer", 0 );
		util::wait_network_frame();
	}
	
	level clientfield::set( "force_streamer", n_zone );
	
	if( !isdefined( level.b_wait_for_streamer_default ) )
	{
		level.b_wait_for_streamer_default = 1;
		// Don't wait in dev builds
		/# 
			level.b_wait_for_streamer_default = 0;
		#/
	}
	
	if ( !GetDvarInt( "scr_streamer_wait", level.b_wait_for_streamer_default ) )
	{
		return;
	}
	
	foreach ( player in level.players )
	{
		player thread _streamer_hint_wait( n_zone );
	}
	
	/#
	
	n_timeout = GetTime() + ( 15 * 1000 );
	
	#/
	
	array::wait_till( level.players, "streamer" + n_zone, 15 );
	level flagsys::clear( "streamer_loading" );
	
	/#
	
	if ( GetTime() >= n_timeout )
	{
		PrintTopRightln( "FORCE STREAMER TIMEOUT - " + string::rfill( GetTime(), 6, "0" ), ( 1, 0, 0 ) );
	}
	else
	{	
		PrintTopRightln( "FORCE STREAMER DONE - " + string::rfill( GetTime(), 6, "0" ), ( 1, 1, 1 ) );
	}
	
	#/
}

function _streamer_hint_wait( n_zone )
{
	self endon( "disconnect" );
	level endon( "set_streamer_hint" );
	self waittillmatch( "streamer", n_zone );
	self notify( "streamer" + n_zone );
}

/@
"Name: teleport_players_igc( <str_spots>, [coop_sort] )"
"Summary: Teleport players after a shared IGC. Functions similarly to skipto::teleport."
"CallOn: NA"
"MandatoryArg: <str_spots> : The name of the spawn point.  Follows same ules as skipto system (using script_objective KVP)."
"OptionalArg: [coop_sort] : Specific which player gets which spot with the script_int KVP"
"Example: util::teleport_players_igc( "after_intro_igc" )"
@/
function teleport_players_igc( str_spots, coop_sort )
{
	// Don't teleport the players if it's a solo game
	if( level.players.size <= 1 )
	{
		return;	
	}
	
	// Grab the skipto points. if this skipto is the entrypoint into the level or needs each player in a particular spot, sort them for coop placement
	a_spots = skipto::get_spots( str_spots, coop_sort );

	// make sure there are enough points skipto spots for the players
	assert( a_spots.size >= ( level.players.size - 1 ), "Need more teleport positions for players!" );

	// set up each player
	// ***SKIPS level.players[ 0 ]***
	// This allows scene animation to place Player 0 where he needs to be without a pop
	for ( i = 0; i < level.players.size - 1; i++ )
	{
		// Set the players' origin to each skipto point
		level.players[i+1] SetOrigin( a_spots[i].origin );

		if ( isdefined( a_spots[i].angles ) )
		{
			// Set the players' angles to face the right way.
			level.players[i+1] SetPlayerAngles( a_spots[i].angles );
		}
	}
}

/@
"Name: set_low_ready( b_lowready )"
"Summary: Sets the player to low ready, hides the hud and everything else that should happen when in low ready mode
"CallOn: Player"
"MandatoryArg: <b_lowready> : True will set the player to low ready. False will turn off low ready"
"Example: e_player util::set_low_ready( true )"
@/
function set_low_ready( b_lowready )
{
	self SetLowReady( b_lowready );
	
	self SetClientUIVisibilityFlag( "weapon_hud_visible", !b_lowready );
	
	self AllowJump( !b_lowready );
	self AllowSprint( !b_lowready );
	self AllowDoubleJump( !b_lowready );
	
	oed::enable_ev( !b_lowready );
	oed::enable_tac_mode( !b_lowready );
}

/@
"Name: CleanupActorCorpses()"
"Summary: Delete corpses of actors in the level
"Example: CleanupActorCorpses()"
@/
function CleanupActorCorpses()
{
	foreach (corpse in GetCorpseArray())
	{
		if (isActorCorpse(corpse))
		{
			corpse Delete();
		}
	}
}

/@
"Name: set_level_start_flag( <str_flag> )"
"Summary: Tells the level to hold a black screen until this flag is set."
"CallOn: NA"
"MandatoryArg: <str_flag> : flag to wait for"
"Example: util::set_level_start_flag( "start_level" )"
@/
function set_level_start_flag( str_flag )
{
	level.str_level_start_flag = str_flag;
	
	if ( !flag::exists( str_flag ) )
	{
		level flag::init( level.str_level_start_flag );
	}
}

/@
"Name: set_player_start_flag( <str_flag> )"
"Summary: Tells the player to hold a black screen when connecting until this flag is set."
"CallOn: NA"
"MandatoryArg: <str_flag> : flag to wait for"
"Example: util::set_level_start_flag( "start_player" )"
@/
function set_player_start_flag( str_flag )
{
	level.str_player_start_flag = str_flag;
}

/@
"Name: set_rogue_controlled( b_state )"
"Summary: Sets the enemy AI to be controlled by an enemy Cyber Soldier.  Used in special cases, it disables the use of certain cyber core abilities."
"Module: AI"
"CallOn: Enemy AI"
"OptionalArg: <b_state> : boolean value that toggles the rogue controlled state, defaults to true"
"Example: set_rogue_controlled( true );"
"SPMP: singleplayer"
@/
function set_rogue_controlled( b_state = true )
{
	if( b_state )
	{
		self cybercom::cybercom_AIOptOut( "cybercom_hijack" );
		self cybercom::cybercom_AIOptOut( "cybercom_iffoverride" );
	}
	else
	{
		self cybercom::cybercom_AIClearOptOut( "cybercom_hijack" );
		self cybercom::cybercom_AIClearOptOut( "cybercom_iffoverride" );
	}
}

/@
"Name: init_breath_fx()"
"Summary: will need to init fx in the main level init to use so clienfields get registered."
"CallOn: Level"
"Example: util::init_breath_fx();"
@/
function init_breath_fx()
{
	clientfield::register( "toplayer", "player_cold_breath", 1, 1, "int" );
	clientfield::register( "actor", "ai_cold_breath", 			1, 1, "counter" );
}

/@
"Name: player_frost_breath( b_true )"
"Summary: Plays a breath effect on player camera"
"CallOn: Player"
"Example: array::thread_all( level.activeplayers, &util::player_frost_breath, true );"
@/
function player_frost_breath( b_true ) //self = player
{
	self clientfield::set_to_player( "player_cold_breath", b_true );
}	

/@
"Name: ai_frost_breath( b_true )"
"Summary: Plays a breath effect on actor tag j_jaw"
"CallOn: Actors"
"Example: spawner::add_global_spawn_function( "allies", &util::ai_frost_breath );"
@/
function ai_frost_breath() // self = ai spawned
{
	self endon( "death" );
	
	if( ( self.archetype === "human" ) )
	{
		wait( RandomFloatRange( 1, 3 ) ); //wait for ai to be spawned for client and dont breath right away.
		
		self clientfield::increment( "ai_cold_breath" );
	}
}


/@
"Name: show_hint_text"
"Summary: Displays hint text for an amount of time. Can be turned off by sending a notify, or by calling hide_hint_text()."
"MandatoryArg: <str_text_to_show> : The text to display."
"OptionalArg: <b_should_blink> : Should this menu flash on and off?"
"OptionalArg: <str_turn_off_notify> : The use this notify to turn off the hint text."
"OptionalArg: <n_display_time> : Override how many seconds the text is displayed for."	
"Example: show_hint_text( "Your help text here!", "notify_hide_help_text" );"
@/
function show_hint_text(str_text_to_show, b_should_blink=false, str_turn_off_notify="notify_turn_off_hint_text", n_display_time=4.0)
{
	self endon ("notify_turn_off_hint_text");
	self endon( "hint_text_removed" );
	
	// Hide any help text which might already be up.
	if ( isdefined(self.hint_menu_handle) )
	{
		hide_hint_text(false);
	}
	
	// Show the help text as a LUI menu.
	self.hint_menu_handle = self OpenLUIMenu( "CPHintText" );
    self SetLUIMenuData( self.hint_menu_handle, "hint_text_line", str_text_to_show );
	
    // Play the blink anim inside the LUImenu if it's meant to flash
    if (b_should_blink)
    {
    	lui::play_animation(self.hint_menu_handle, "blinking");
    }
    else
    {
    	lui::play_animation(self.hint_menu_handle, "display_noblink");
    }
    
    if( n_display_time != -1 )
    {
    	// Listen for hide or death notify. This interrupts the normal wait timer.
		// This thread will also ensure the LUImenu is closed when the text has been displayed for the intended amount of time.
		self thread hide_hint_text_listener(n_display_time);
		
		// Fade the hint text out after specified time if not interrupted.
		// Note: the above thread will close the LUImenu when the desired time has elapsed.
		self thread fade_hint_text_after_time(n_display_time, str_turn_off_notify);
    }   
}

/@
"Name: hide_hint_text"
"Summary: Hides any help text which may be on screen."
@/
function hide_hint_text(b_fade_before_hiding=true)
{
	self endon( "hint_text_removed" );
	
	if ( isdefined(self.hint_menu_handle) )
	{
		if (b_fade_before_hiding)
		{
			lui::play_animation(self.hint_menu_handle, "fadeout");
			util::waittill_any_timeout(0.75,  "kill_hint_text", "death");
		}
		
		self CloseLUIMenu(self.hint_menu_handle);
		self.hint_menu_handle = undefined;
	}
	
	// Terminate hint text threads listening for remove help text notify.
	self notify("hint_text_removed");
}

// Fade out hint text before its luimenu is destroyed.
// If a notify to hide hint text is passed, this will fade out the hint text as well.
function fade_hint_text_after_time(n_display_time, str_turn_off_notify)
{
	self endon( "hint_text_removed" );
	self endon( "death" );
	self endon( "kill_hint_text" );
	
	util::waittill_any_timeout(n_display_time - 0.75, str_turn_off_notify);
	
	hide_hint_text(true);
}

// Listens for a notify to turn off the help text.
function hide_hint_text_listener(n_time)
{
	// Stop listening for turn off on death or when the hint text has been removed:
	self endon( "hint_text_removed" );
	self endon( "disconnect" );
	
	util::waittill_any_timeout(n_time,  "kill_hint_text", "death");
	
	hide_hint_text(false);
}

// Displays an event message.
function show_event_message(player_handle, str_message)
{
	player_handle LUINotifyEvent( &"comms_event_message", 1, str_message );
	// Event messsage sound effect should go here
}

/@
"Name: init_interactive_gameobject( trigger, str_objective, str_hint_text , func_on_use , a_keyline_objects )"
"Summary: Returns a gameobject with all necessary parameters for CP."
"Module: Utility"
"MandatoryArg: <trigger> : The trigger for the gameobject. Must be some type of use trigger"
"MandatoryArg: <str_objective> : The objective for the gameobject. This determines what icon and text appears on the object. 'Waypoint Type' of the objective should be '3D Prompt'. "
"MandatoryArg: <str_hint_text> : A string for the trigger's use prompt."
"OptionalArg: <func_on_use> : Function to run when the gameobject is used. Passes in the player who triggered the gameobject as the first parameter. Gameobject becomes 'self' in the specified function"
"OptionalArg: <a_keyline_objects> : An entity or array of entities to be keylined"
@/
function init_interactive_gameobject( trigger, str_objective, str_hint_text , func_on_use , a_keyline_objects )
{
	trigger SetHintString( str_hint_text );
	trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
	
	if( !isdefined( a_keyline_objects ) )
	{
		a_keyline_objects = [];
	}
	else
	{
		if ( !isdefined( a_keyline_objects ) ) a_keyline_objects = []; else if ( !IsArray( a_keyline_objects ) ) a_keyline_objects = array( a_keyline_objects );;
		
		foreach( mdl in a_keyline_objects )
		{
			mdl oed::enable_keyline( true );
		}
	}
	
	game_object = gameobjects::create_use_object( "any", trigger, a_keyline_objects, ( 0, 0, 0 ), str_objective );
	game_object gameobjects::allow_use( "any" );
	game_object gameobjects::set_use_time( 0.5 );
	game_object gameobjects::set_owner_team( "allies" );
	game_object gameobjects::set_visible_team( "any" );
	game_object.single_use = false;
		
	// Set origin/angles so it can be used as an objective target.
	game_object.origin = game_object.origin;
	game_object.angles = game_object.angles;
	
	if ( isdefined( func_on_use ) )
	{
		game_object.onUse = func_on_use;
	}
	
	return game_object;
}

