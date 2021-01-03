#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_spectating;

#using scripts\zm\_util;

#precache( "string", "MP_HALFTIME" );
#precache( "string", "MP_OVERTIME" );
#precache( "string", "MP_ROUNDEND" );
#precache( "string", "MP_INTERMISSION" );
#precache( "string", "MP_SWITCHING_SIDES_CAPS" );
#precache( "string", "MP_FRIENDLY_FIRE_WILL_NOT" );
#precache( "string", "MP_RAMPAGE" );
#precache( "string", "MP_ENDED_GAME" );
#precache( "string", "MP_HOST_ENDED_GAME" );
#precache( "eventstring", "medal_received" );
#precache( "eventstring", "killstreak_received" );
#precache( "eventstring", "player_callout" );
#precache( "eventstring", "score_event" );
#precache( "eventstring", "rank_up" ); 
#precache( "eventstring", "gun_level_complete" ); 
#precache( "eventstring", "challenge_complete" ); 
#precache( "eventstring", "hud_update_survival_team" );	

#namespace globallogic_ui;

function autoexec __init__sytem__() {     system::register("globallogic_ui",&__init__,undefined,undefined);    }

function __init__()
{
}

function SetupCallbacks()
{
	level.autoassign =&menuAutoAssign;
	level.spectator =&menuSpectator;
	level.curClass =&menuClass;
	level.teamMenu =&menuTeam;
}

function freeGameplayHudElems()
{
	// free up some hud elems so we have enough for other things.
	
	// perk icons
	if ( isdefined( self.perkicon ) )
	{
		for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
		{
			if ( isdefined( self.perkicon[ numSpecialties ] ) )
			{
				self.perkicon[ numSpecialties ] hud::destroyElem();
				self.perkname[ numSpecialties ] hud::destroyElem();
			}
		}
	}

	if ( isdefined( self.perkHudelem ) )
	{
		self.perkHudelem hud::destroyElem();
	}
	
	// Killstreak icons
	if ( isdefined( self.killstreakicon ) )
	{
		if ( isdefined( self.killstreakicon[0] ) )
		{
			self.killstreakicon[0] hud::destroyElem();
		}
		if ( isdefined( self.killstreakicon[1] ) )
		{
			self.killstreakicon[1] hud::destroyElem();
		}
		if ( isdefined( self.killstreakicon[2] ) )
		{
			self.killstreakicon[2] hud::destroyElem();
		}
		if ( isdefined( self.killstreakicon[3] ) )
		{
			self.killstreakicon[3] hud::destroyElem();
		}
		if ( isdefined( self.killstreakicon[4] ) )
		{
			self.killstreakicon[4] hud::destroyElem();
		}
	}
	
	// lower message
	if ( isdefined( self.lowerMessage ) )
		self.lowerMessage hud::destroyElem();
	if ( isdefined( self.lowerTimer ) )
		self.lowerTimer hud::destroyElem();
	
	// progress bar
	if ( isdefined( self.proxBar ) )
		self.proxBar hud::destroyElem();
	if ( isdefined( self.proxBarText ) )
		self.proxBarText hud::destroyElem();
		
	// carry icon
	if ( isdefined( self.carryIcon ) )
		self.carryIcon hud::destroyElem();
	
	//_killstreaks::destroyKillstreakTimers();
}

function teamPlayerCountsEqual( playerCounts )
{
	count = undefined;
	
	foreach( team in level.teams )
	{
		if ( !isdefined( count ) )
		{
			count = playerCounts[team];
			continue;
		}
		if ( count != playerCounts[team] )
			return false;
	}
	
	return true;
}

function teamWithLowestPlayerCount( playerCounts, ignore_team )
{
	count = 9999;
	lowest_team = undefined;
	
	foreach( team in level.teams )
	{
		if ( count > playerCounts[team] )
		{
			count = playerCounts[team];
			lowest_team = team;
		}
	}
	
	return lowest_team;
}

function menuAutoAssign( comingFromMenu )
{
	teamKeys = GetArrayKeys( level.teams );
	assignment = teamKeys[randomInt(teamKeys.size)];
	
	self closeMenus();

	if( isdefined(level.forceAllAllies) && level.forceAllAllies )
	{
		assignment = "allies";
	}
	else if ( level.teamBased )
	{
		if ( GetDvarint( "party_autoteams" ) == 1 )
		{
			// after they have spawned in once then we should let the team balancing 
			// code below do the picking otherwise the "auto-assign" wont do anything.
			if( level.allow_teamchange == "1" && ( self.hasSpawned || comingFromMenu ) )
			{
					assignment = "";
			}
			else
			{
				// TODO MTEAM changed the getAssignedTeam function to directly return a name instead of an index
				//					  This entire swich statement can be removed after the next exe on 5/1/2012
				//						just use the default case: 
				team = getAssignedTeam( self );
				switch ( team )
				{			
					// LEGACY - Remove when new exes are checked in
					case 1:
						assignment = teamKeys[1];
						break;
						
					// LEGACY - Remove when new exes are checked in
					case 2:
						assignment = teamKeys[0];
						break;
					
					// LEGACY - Remove when new exes are checked in
					case 3:
						assignment = teamKeys[2];
						break;
					
					// LEGACY - Remove when new exes are checked in
					case 4:
						// if they are supposed to be a spectator just set the clientscriptmainmenu and return
						if ( !isdefined( level.forceAutoAssign ) || !level.forceAutoAssign )
						{   
							self SetClientScriptMainMenu( game[ "menu_start_menu" ] );
							return;
						}
					default:
					{
						assignment = ""; 
						if( isdefined( level.teams[team] )  )
						{
							assignment = team;
						}
						else if ( team == "spectator" && (!level.forceAutoAssign) )
						{   
							self SetClientScriptMainMenu( game[ "menu_start_menu" ] );
							return;
						}
					}
				}
			}
		}
		
		if ( assignment == "" || GetDvarint( "party_autoteams" ) == 0 )
		{	
			if ( SessionModeIsZombiesGame() )
			{
				assignment = "allies";
			}
			/*else
			{
				playerCounts = self _teams::CountPlayers();
			
				// if teams are equal return the team with the lowest score
				if ( teamPlayerCountsEqual( playerCounts )  )
				{
					// try to keep online splitscreen players together
					if ( !level.splitscreen && self IsSplitScreen() )
					{
						assignment = self getSplitscreenTeam();
					
						if ( assignment == "" )
							assignment = pickTeamFromScores(teamKeys);
					}
					else 
					{
						assignment = pickTeamFromScores(teamKeys);
					}
				}
				else
				{
					assignment = teamWithLowestPlayerCount( playerCounts, "none" );
				}
			}
			*/
		}

		// matchmaking vs. bots
 		/*
		if ( !SessionModeIsZombiesGame() && level.rankedMatch && GetDvarInt( "party_autoteams" ) == 0 )
 		{
 			host = util::getHostPlayerForBots();
 			assert( isdefined( host ) );
 
 			if ( !isdefined( host.pers[ "team" ] ) )
 			{
 				host.pers[ "team" ] = teamKeys[randomInt(teamKeys.size)];
 				host.team = host.pers[ "team" ];
 			}
 
 			if ( host != self )
			{
 				assert( isdefined( host.pers[ "team" ] ) );
 
 				if ( self util::is_bot() )
 				{
	 				playerCounts = self _teams::CountPlayers();
					assignment = teamWithLowestPlayerCount( playerCounts, host.pers[ "team" ] );
 				}
 				else
 				{
 					assignment = host.pers[ "team" ];
 				}
 			}
 		}
		*/
		
		if ( assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
			self beginClassChoice();
			return;
		}
	}
	else
	{
		if ( GetDvarint( "party_autoteams" ) == 1 )
		{
			// after they have spawned in once then we should let the random team assignment logic handle itself.
			if( level.allow_teamchange != "1" || ( !self.hasSpawned && !comingFromMenu ) )
			{
				team = getAssignedTeam( self );	
				if( isdefined( level.teams[team] )  )
				{
					assignment = team;
				}
				else if ( team == "spectator" && (!level.forceAutoAssign) )
				{   
					self SetClientScriptMainMenu( game[ "menu_start_menu" ] );
					return;
				}
			}
		}	
	}

	if ( assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.curClass = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self updateObjectiveText();

	if ( level.teamBased )
		self.sessionteam = assignment;
	else
	{
		self.sessionteam = "none";
		self.ffateam = assignment;
	}
	
	if ( !isAlive( self ) )
		self.statusicon = "hud_status_dead";
	
	self notify("joined_team");
	level notify( "joined_team" );
	self callback::callback( #"on_joined_team" );
	self notify("end_respawn");
	
	self beginClassChoice();	
	self SetClientScriptMainMenu( game[ "menu_start_menu" ] );

}

function teamScoresEqual( )
{
	score = undefined;
	
	foreach( team in level.teams )
	{
		if ( !isdefined( score ) )
		{
			score = getTeamScore(team);
			continue;
		}
		if ( score != getTeamScore(team) )
			return false;
	}
	
	return true;
}

function teamWithLowestScore()
{
	score = 99999999;
	lowest_team = undefined;
	
	foreach( team in level.teams )
	{
		if ( score > getTeamScore(team ) )
			lowest_team = team;
	}
	
	return lowest_team;
}

function pickTeamFromScores(teams)
{
	assignment = "allies";
	
	if ( teamScoresEqual() )
		assignment = teams[randomInt(teams.size)];
	else
		assignment = teamWithLowestScore();
		
	return assignment;
}

function getSplitscreenTeam()
{
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( !isdefined(level.players[index]) )
			continue;
			
		if ( level.players[index] == self )
			continue;
			
		if ( !(self IsPlayerOnSameMachine( level.players[index] )) )
			continue;
			
		team = level.players[index].sessionteam;

		// going to assume first non-spectator 
		if ( team != "spectator" )
			return team;
	}
	
	return "";
}

function updateObjectiveText()
{
	if ( SessionModeIsZombiesGame() || (self.pers["team"] == "spectator") )
	{
		self SetClientCGObjectiveText( "" );
		return;
	}

	if( level.scorelimit > 0 ) 
	{
		self SetClientCGObjectiveText( util::getObjectiveScoreText( self.pers["team"] ) );
	}
	else
	{
		self SetClientCGObjectiveText( util::getObjectiveText( self.pers["team"] ) );
	}
}


function closeMenus()
{
	self closeInGameMenu();
}

function beginClassChoice( forceNewChoice )
{
	assert( isdefined( level.teams[self.pers["team"]] ) );
	
	team = self.pers["team"];
		
	if ( level.disableCAC == 1 )
	{
		// skip class choice and just spawn.
		
		self.pers["class"] = level.defaultClass;
		self.curClass = level.defaultClass;

		// open a menu that just sets the ui_team localvar
		//self openMenu( game[ "menu_initteam_" + team ] );
		
		if ( self.sessionstate != "playing" && game["state"] == "playing" )
			self thread [[level.spawnClient]]();
		level thread globallogic::updateTeamStatus();
		self thread spectating::setSpectatePermissionsForMachine();
		
		return;
	}

	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.
	self openMenu( game[ "menu_changeclass_" + team ] );

	//if ( level.rankedMatch )
	//	self openMenu( game[ "menu_changeclass_" + team ] );
	//else
	//	self openMenu( game[ "menu_start_menu" ] );
}

function showMainMenuForTeam()
{
	assert( isdefined( level.teams[self.pers["team"]] ) );
	
	team = self.pers["team"];
	
	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.
	
	self openMenu( game[ "menu_changeclass_" + team ] );
}

function menuTeam( team )
{
	self closeMenus();
	
	if ( !level.console && level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat) )
	{
			return;
	}
	
	if(self.pers["team"] != team)
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = team;
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = team;
		self.team = team;
		self.pers["class"] = undefined;
		self.curClass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = team;
		else
		{
			self.sessionteam = "none";
			self.ffateam = team;
		}

		self SetClientScriptMainMenu( game[ "menu_start_menu" ] );

		self notify("joined_team");
		level notify( "joined_team" );
		self callback::callback( #"on_joined_team" );
		self notify("end_respawn");
	}
	
	self beginClassChoice();
}

function menuSpectator()
{
	self closeMenus();
	
	if(self.pers["team"] != "spectator")
	{
		if(isAlive(self))
		{
			self.switching_teams = true;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.pers["class"] = undefined;
		self.curClass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "spectator";
		if ( !level.teamBased ) 
			self.ffateam = "spectator";

		[[level.spawnSpectator]]();
		
		self thread globallogic_player::spectate_player_watcher();

		self SetClientScriptMainMenu( game[ "menu_start_menu" ] );

		self notify("joined_spectators");
	}
}

function menuClass( response )
{
	self closeMenus();
/*	
	// this should probably be an assert
	if(!isdefined(self.pers["team"]) || !(isdefined( level.teams[self.pers["team"]] ) ) )
		return;

	class = undefined;//self _class::getClassChoice( response );

	if( (isdefined( self.pers["class"] ) && self.pers["class"] == class) )
		return;

	self notify ( "changed_class" );
//	self _gametype_variants::OnPlayerClassChange();

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		supplyStationClassChange = isdefined( self.usingSupplyStation ) && self.usingSupplyStation;
		self.usingSupplyStation = false;

		if ( ( level.inGracePeriod && !self.hasDoneCombat ) || supplyStationClassChange ) // used weapons check?
		{
			self _class::setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self _class::giveLoadout( self.pers["team"], self.pers["class"] );
	//		self _killstreaks::giveOwnedKillstreak();
		}
		else if ( !level.splitScreen )
		{
			notifyData = spawnstruct();
			
			self DisplayGameModeMessage( game["strings"]["change_class"], "uin_alert_slideout" );
		}
	}
	else
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;
			
		if ( self.sessionstate != "spectator" )
		{
			if ( self IsInVehicle() )
				return;

			if ( self IsRemoteControlling() )
				return;
	
			if ( self IsWeaponViewOnlyLinked() )
				return false;
		}

		if ( game["state"] == "playing" )
		{
			timePassed = undefined;
			
			if ( isdefined( self.respawnTimerStartTime ) )
			{
				timePassed = (gettime() - self.respawnTimerStartTime) / 1000;
			}
			
			self thread [[level.spawnClient]](timePassed);
			
			self.respawnTimerStartTime = undefined;
			
		}
	}

	level thread globallogic::updateTeamStatus();

	self thread spectating::setSpectatePermissionsForMachine();*/
}


/*
function showSafeSpawnMessage()
{
	if ( level.splitscreen )
		return;
	
	// don't show it if they've already asked for a safe spawn
	if ( self.wantSafeSpawn )
		return;
	
	if ( !isdefined( self.safeSpawnMsg ) )
	{
		self.safeSpawnMsg = hud::createFontString( "default", 1.4 );
		self.safeSpawnMsg hud::setPoint( "CENTER", level.lowerTextYAlign, 0, level.lowerTextY + 50 );
		self.safeSpawnMsg setText( &"PLATFORM_PRESS_TO_SAFESPAWN" );
		self.safeSpawnMsg.archived = false;
	}
	self.safeSpawnMsg.alpha = 1;
}
function hideSafeSpawnMessage()
{
	if ( !isdefined( self.safeSpawnMsg ) )
		return;
	
	self.safeSpawnMsg.alpha = 0;
}
*/


function removeSpawnMessageShortly( delay )
{
	self endon("disconnect");
	
	waittillframeend; // so we don't endon the end_respawn from spawning as a spectator
	
	self endon("end_respawn");
	
	wait delay;
	
	self util::clearLowerMessage( 2.0 );
}

