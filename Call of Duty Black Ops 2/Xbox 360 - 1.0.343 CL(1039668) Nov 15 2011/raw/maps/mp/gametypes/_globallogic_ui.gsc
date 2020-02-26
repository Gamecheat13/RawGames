#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	precacheString( &"MP_HALFTIME" );
	precacheString( &"MP_OVERTIME" );
	precacheString( &"MP_ROUNDEND" );
	precacheString( &"MP_INTERMISSION" );
	precacheString( &"MP_SWITCHING_SIDES_CAPS" );
	precacheString( &"MP_FRIENDLY_FIRE_WILL_NOT" );
	precacheString( &"MP_RAMPAGE" );
	precacheString( &"killstreak_notify" ); // LUI event
	precacheString( &"prox_grenade_notify" ); // LUI event

	if ( level.splitScreen )
		precacheString( &"MP_ENDED_GAME" );
	else
		precacheString( &"MP_HOST_ENDED_GAME" );
}

SetupCallbacks()
{
	level.autoassign = ::menuAutoAssign;
	level.spectator = ::menuSpectator;
	level.class = ::menuClass;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
}

hideLoadoutAfterTime( delay )
{
	self endon("disconnect");
	self endon("perks_hidden");
	
	wait delay;
	
	self thread hideAllPerks( 0.4 );

	self notify("perks_hidden");
}

hideLoadoutOnDeath()
{
	self endon("disconnect");
	self endon("perks_hidden");

	self waittill("death");
	
	self hideAllPerks();
	
	self notify("perks_hidden");
}

hideLoadoutOnKill()
{
	self endon("disconnect");
	self endon("death");
	self endon("perks_hidden");

	self waittill( "killed_player" );
	
	self hideAllPerks();
	
	self notify("perks_hidden");
}


freeGameplayHudElems()
{
	// free up some hud elems so we have enough for other things.
	
	// perk icons
	if ( IsDefined( self.perkicon ) )
	{
		for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
		{
			if ( isdefined( self.perkicon[ numSpecialties ] ) )
			{
				self.perkicon[ numSpecialties ] destroyElem();
				self.perkname[ numSpecialties ] destroyElem();
			}
		}
	}
	// Killstreak icons
	if ( isdefined( self.killstreakicon ) )
	{
		if ( isdefined( self.killstreakicon[0] ) )
		{
			self.killstreakicon[0] destroyElem();
		}
		if ( isdefined( self.killstreakicon[1] ) )
		{
			self.killstreakicon[1] destroyElem();
		}
		if ( isdefined( self.killstreakicon[2] ) )
		{
			self.killstreakicon[2] destroyElem();
		}
		if ( isdefined( self.killstreakicon[3] ) )
		{
			self.killstreakicon[3] destroyElem();
		}
		if ( isdefined( self.killstreakicon[4] ) )
		{
			self.killstreakicon[4] destroyElem();
		}
	}
	self notify("perks_hidden"); // stop any threads that are waiting to hide the perk icons
	
	// lower message
	if ( isDefined( self.lowerMessage ) )
		self.lowerMessage destroyElem();
	if ( isDefined( self.lowerTimer ) )
		self.lowerTimer destroyElem();
	
	// progress bar
	if ( isDefined( self.proxBar ) )
		self.proxBar destroyElem();
	if ( isDefined( self.proxBarText ) )
		self.proxBarText destroyElem();
		
	// carry icon
	if ( IsDefined( self.carryIcon ) )
		self.carryIcon destroyElem();
	
	maps\mp\killstreaks\_killstreaks::destroyKillstreakTimers();
}


menuAutoAssign()
{
	teams[0] = "allies";
	teams[1] = "axis";
	assignment = teams[randomInt(2)];
	
	self closeMenus();

	if( isdefined(level.forceAllAllies) && level.forceAllAllies )
	{
		assignment = teams[0];
	}
	else if ( level.teamBased )
	{
		if ( level.console && GetDvarint( "party_autoteams" ) == 1 )
		{
			// after they have spawned in once then we should let the team balancing 
			// code below do the picking otherwise the "auto-assign" wont do anything.
			if( level.allow_teamchange == "1" && self.hasSpawned )
			{
					assignment = "";
			}
			else
			{
				teamNum = getAssignedTeam( self );
				switch ( teamNum )
				{			
					case 1:
						assignment = teams[1];
						break;
						
					case 2:
						assignment = teams[0];
						break;
						
					default:
						assignment = "";
				}
			}
		}
		
		if ( assignment == "" || GetDvarint( "party_autoteams" ) == 0 )
		{	
			playerCounts = self maps\mp\teams\_teams::CountPlayers();
			
			// if teams are equal return the team with the lowest score
			if ( playerCounts["allies"] == playerCounts["axis"] )
			{
				// try to keep online splitscreen players together
				if ( !level.splitscreen && self IsSplitScreen() )
				{
					assignment = self getSplitscreenTeam();
					
					if ( assignment == "" )
						assignment = pickTeamFromScores(teams);
				}
				else 
				{
					assignment = pickTeamFromScores(teams);
				}
			}
			else if( playerCounts["allies"] < playerCounts["axis"] )
			{
				assignment = "allies";
			}
			else
			{
				assignment = "axis";
			}
		}
		
		if ( assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
			self beginClassChoice();
			return;
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
	self.class = undefined;
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
	self notify("end_respawn");
	
	if( isPregame() )
	{
		if( !self is_bot() )
		{
			pclass = self maps\mp\gametypes\_pregame::get_pregame_class();
			
			self closeMenu();
			self closeInGameMenu();
			
			self.selectedClass = true;
			self [[level.class]](pclass);
			self SetClientScriptMainMenu( game[ "menu_class_" + self.pers["team"] ] );
			return;
		}
	}
	
	if( isPregameGameStarted() )
	{
		if( self is_bot() && isDefined( self.pers["class"] ) )
		{
			pclass = self.pers["class"];
			
			self closeMenu();
			self closeInGameMenu();
			
			self.selectedClass = true;
			self [[level.class]](pclass);
			return;
		}
	}

	self beginClassChoice();	
	self SetClientScriptMainMenu( game[ "menu_class_" + self.pers["team"] ] );

}

pickTeamFromScores(teams)
{
	assignment = "allies";
	
	if ( getTeamScore( "allies" ) == getTeamScore( "axis" ) )
		assignment = teams[randomInt(2)];
	else if ( getTeamScore( "allies" ) < getTeamScore( "axis" ) )
		assignment = "allies";
	else
		assignment = "axis";
		
	return assignment;
}

getSplitscreenTeam()
{
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( !IsDefined(level.players[index]) )
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

updateObjectiveText()
{
	if ( SessionModeIsZombiesGame() || (self.pers["team"] == "spectator") )
	{
		self SetClientCGObjectiveText( "" );
		return;
	}

	if( level.scorelimit > 0 ) 
	{
		self SetClientCGObjectiveText( getObjectiveScoreText( self.pers["team"] ) );
	}
	else
	{
		self SetClientCGObjectiveText( getObjectiveText( self.pers["team"] ) );
	}
}


closeMenus()
{
	self closeMenu();
	self closeInGameMenu();
}

beginClassChoice( forceNewChoice )
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	team = self.pers["team"];
		
	if ( level.oldschool || ( GetDvarint( "scr_disable_cac" ) == 1 ) )
	{
		// skip class choice and just spawn.
		
		self.pers["class"] = level.defaultClass;
		self.class = level.defaultClass;

		// open a menu that just sets the ui_team localvar
		//self openMenu( game[ "menu_initteam_" + team ] );
		
		if ( self.sessionstate != "playing" && game["state"] == "playing" )
			self thread [[level.spawnClient]]();
		level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
		self thread maps\mp\gametypes\_spectating::setSpectatePermissionsForMachine();
		
		return;
	}

	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.
	if( level.wagerMatch )
	{
		self openMenu( game["menu_changeclass_wager"] );
	}
	else if( maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() )
	{
		self openMenu( game["menu_changeclass_custom"] );
	}
	else if( GetDvarint( "barebones_class_mode" ) )
	{
		self openMenu( game["menu_changeclass_barebones"] );
	}
	else
	{
		self openMenu( game[ "menu_changeclass_" + team ] );
	}
	//if ( level.rankedMatch )
	//	self openMenu( game[ "menu_changeclass_" + team ] );
	//else
	//	self openMenu( game[ "menu_class_" + team ] );
}

showMainMenuForTeam()
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	team = self.pers["team"];
	
	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.
	
	if( level.wagerMatch )
	{
		self openMenu( game["menu_changeclass_wager"] );
	}
	else if( maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() )
	{
		self openMenu( game["menu_changeclass_custom"] );
	}
	else
	{
		self openMenu( game[ "menu_changeclass_" + team ] );
	}
}

menuAllies()
{
	self closeMenus();
	
	if ( !level.console && level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat) )
	{
			return;
	}
	
	if(self.pers["team"] != "allies")
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "allies";
		else
		{
			self.sessionteam = "none";
			self.ffateam = "allies";
		}

		self SetClientScriptMainMenu( game["menu_class_allies"] );

		self notify("joined_team");
		level notify( "joined_team" );
		self notify("end_respawn");
	}
	
	self beginClassChoice();
}


menuAxis()
{
	self closeMenus();
	
	if ( !level.console && level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat) )
	{
			return;
	}
	
	if(self.pers["team"] != "axis")
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "axis";
		self.team = "axis";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "axis";
		else
		{
			self.sessionteam = "none";
			self.ffateam = "axis";
		}

		self SetClientScriptMainMenu( game["menu_class_axis"] );

		self notify("joined_team");
		level notify( "joined_team" );
		self notify("end_respawn");
	}
	
	self beginClassChoice();
}


menuSpectator()
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
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "spectator";
		if ( !level.teamBased ) 
			self.ffateam = "spectator";

		[[level.spawnSpectator]]();

		self SetClientScriptMainMenu( game["menu_team"] );

		self notify("joined_spectators");
	}
}

menuClass( response )
{
	self closeMenus();
	
	assert( !level.oldschool );
	
	// this should probably be an assert
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	class = self maps\mp\gametypes\_class::getClassChoice( response );

	if( (isDefined( self.pers["class"] ) && self.pers["class"] == class) )
		return;

	self notify ( "changed_class" );
	self maps\mp\gametypes\_gametype_variants::OnPlayerClassChange();
	if( isPregame() )
		self maps\mp\gametypes\_pregame::OnPlayerClassChange( response );

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.class = class;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		supplyStationClassChange = isDefined( self.usingSupplyStation ) && self.usingSupplyStation;
		self.usingSupplyStation = false;

		if ( ( level.inGracePeriod && !self.hasDoneCombat ) || supplyStationClassChange ) // used weapons check?
		{
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
			self maps\mp\killstreaks\_killstreaks::giveOwnedKillstreak();
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
		}

		if ( game["state"] == "playing" )
			self thread [[level.spawnClient]]();
	}

	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();

	self thread maps\mp\gametypes\_spectating::setSpectatePermissionsForMachine();
}


/*
showSafeSpawnMessage()
{
	if ( level.splitscreen )
		return;
	
	// don't show it if they've already asked for a safe spawn
	if ( self.wantSafeSpawn )
		return;
	
	if ( !isdefined( self.safeSpawnMsg ) )
	{
		self.safeSpawnMsg = createFontString( "default", 1.4 );
		self.safeSpawnMsg setPoint( "CENTER", level.lowerTextYAlign, 0, level.lowerTextY + 50 );
		self.safeSpawnMsg setText( &"PLATFORM_PRESS_TO_SAFESPAWN" );
		self.safeSpawnMsg.archived = false;
	}
	self.safeSpawnMsg.alpha = 1;
}
hideSafeSpawnMessage()
{
	if ( !isdefined( self.safeSpawnMsg ) )
		return;
	
	self.safeSpawnMsg.alpha = 0;
}
*/


removeSpawnMessageShortly( delay )
{
	self endon("disconnect");
	
	waittillframeend; // so we don't endon the end_respawn from spawning as a spectator
	
	self endon("end_respawn");
	
	wait delay;
	
	self clearLowerMessage( 2.0 );
}


setObjectiveText( team, text )
{
	game["strings"]["objective_"+team] = text;
	precacheString( text );
}

setObjectiveScoreText( team, text )
{
	game["strings"]["objective_score_"+team] = text;
	precacheString( text );
}

setObjectiveHintText( team, text )
{
	game["strings"]["objective_hint_"+team] = text;
	precacheString( text );
}

getObjectiveText( team )
{
	return game["strings"]["objective_"+team];
}

getObjectiveScoreText( team )
{
	return game["strings"]["objective_score_"+team];
}

getObjectiveHintText( team )
{
	return game["strings"]["objective_hint_"+team];
}

