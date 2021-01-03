#using scripts\shared\array_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_spectating;

#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;

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

#namespace globallogic_ui;

function init()
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
	
	killstreaks::destroy_killstreak_timers();
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
			else if ( bot::is_bot_comp_stomp() )
			{
				host = util::getHostPlayerForBots();
				assert( isdefined( host ) );

				if ( !isdefined( host.team ) || host.team == "spectator" )
				{
					host.team = array::random( teamKeys );
				}

				if ( !self util::is_bot() )
				{
					assignment = host.team;
				}
				else
				{
					assignment = util::getOtherTeam( host.team );
				}
			}
			else
			{
				playerCounts = self teams::count_players();
			
				// if teams are equal return the team with the lowest score
				if ( teamPlayerCountsEqual( playerCounts )  )
				{
					// try to keep online splitscreen players together
					if ( !level.splitscreen && self IsSplitScreen() )
					{
						assignment = self get_splitscreen_team();
					
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
		}

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
		self.switchedTeamsResetGadgets = true;
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
	callback::callback( #"on_joined_team" );
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

function get_splitscreen_team()
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
	if ( (self.pers["team"] == "spectator") )
	{
		self SetClientCGObjectiveText( "" );
		return;
	}

	if( level.scorelimit > 0 || level.roundScoreLimit > 0 ) 
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
		
	if ( level.disableClassSelection == 1 || GetDvarint( "migration_soak" ) == 1 )
	{
		// skip class choice and just spawn.
		
		self.pers["class"] = level.defaultClass;
		self.curClass = level.defaultClass;

		// open a menu that just sets the ui_team localvar
		//self openMenu( game[ "menu_initteam_" + team ] );
		
		if ( self.sessionstate != "playing" && game["state"] == "playing" )
			self thread [[level.spawnClient]]();
		level thread globallogic::updateTeamStatus();
		self thread spectating::set_permissions_for_machine();
		
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
			self.switchedTeamsResetGadgets = true;
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

		if ( !level.rankedMatch && !level.leagueMatch )
		{
			self.sessionstate = "spectator";
		}
		
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
		callback::callback( #"on_joined_team" );
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
			self.switchedTeamsResetGadgets = true;
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
		callback::callback( #"on_joined_spectate" );
	}
}

function menuClass( response, forcedClass )
{
	self closeMenus();
	
	// this should probably be an assert
	if(!isdefined(self.pers["team"]) || !(isdefined( level.teams[self.pers["team"]] ) ) )
		return;

	if ( !isdefined( forcedClass ) )
		playerclass = self loadout::getClassChoice( response );
	else
		playerClass = forcedClass;

	if( (isdefined( self.pers["class"] ) && self.pers["class"] == playerclass) )
		return;

	self.pers["changed_class"] = true;
	self notify ( "changed_class" );

	//The player selected the class they are currently using
	if( isdefined(self.curClass) && self.curClass == playerclass )
	{
		self.pers["changed_class"] = false;
	}

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = playerClass;
		self.curClass = playerclass;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		supplyStationClassChange = isdefined( self.usingSupplyStation ) && self.usingSupplyStation;
		self.usingSupplyStation = false;

		if ( ( level.inGracePeriod && !self.hasDoneCombat ) || supplyStationClassChange ) // used weapons check?
		{
			self loadout::setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self loadout::giveLoadout( self.pers["team"], self.pers["class"] );
			self killstreaks::give_owned();
		}
		else if ( !( self IsSplitScreen() ) )
		{
			self IPrintLnBold( game["strings"]["change_class"] );
		}
	}
	else
	{
		self.pers["class"] = playerclass;
		self.curClass = playerclass;
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

	self thread spectating::set_permissions_for_machine();
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

