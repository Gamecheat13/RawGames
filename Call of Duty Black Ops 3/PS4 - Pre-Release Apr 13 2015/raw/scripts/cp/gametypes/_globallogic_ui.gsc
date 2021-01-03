#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spectating;

#using scripts\cp\_util;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\teams\_teams;

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
#precache( "eventstring", "client_rank_up" ); 
#precache( "eventstring", "weapon_unlocked" );
#precache( "eventstring", "token_unlocked" );
#precache( "eventstring", "gun_level_complete" ); 
#precache( "eventstring", "challenge_complete" ); 

#namespace globallogic_ui;

//REGISTER_SYSTEM( "globallogic_ui", &__init__, undefined )

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

	assignment = "allies";

	if ( level.teamBased )
	{	
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
	
	if ( level flagsys::get( "level_has_skiptos" ) && !level flagsys::get( "kill_fullscreen_black" ) && !GetDvarInt( "art_review", 0 ) )
	{
		self thread fullscreen_black();
	}
	
	prevclass = self savegame::get_player_data(savegame::get_mission_name() + "_class",undefined);
	if ( IsDefined(prevclass) && !GetDvarInt( "force_cac", 0 ) )
	{
		// we've already selected a class - skip class choice and just spawn.
		self.pers["class"] = prevclass;
		self.curClass = prevclass;

		{wait(.05);};
		
		if ( self.sessionstate != "playing" && game["state"] == "playing" )
			self thread [[level.spawnClient]]();
		level thread globallogic::updateTeamStatus();
		self thread spectating::set_permissions_for_machine();
		
		return;
	}
		
	if ( level.disableClassSelection == 1 || GetDvarint( "migration_soak" ) == 1 )
	{
		// skip class choice and just spawn.
		
		self.pers["class"] = level.defaultClass;
		self.curClass = level.defaultClass;

		// open a menu that just sets the ui_team localvar
		//self openMenu( game[ "menu_initteam_" + team ] );
		
		{wait(.05);};
		
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

function fullscreen_black()
{
	self endon( "disconnect" );
	
	self.fullscreen_black_menu = self OpenLUIMenu( "FullscreenBlack", true );
	
	self thread fullscreen_black_freeze_controls();
		
	level flagsys::wait_till( "kill_fullscreen_black" );
	
	self.fullscreen_black_menu = self GetLUIMenu( "FullscreenBlack" );
	self CloseLUIMenu( self.fullscreen_black_menu );
	self.fullscreen_black_menu = undefined;
}

function fullscreen_black_freeze_controls()
{
	self endon( "disconnect" );
	self flagsys::wait_till( "loadout_given" );
	
	if ( isdefined( self.fullscreen_black_menu ) )
	{
		self FreezeControls( true );
		self DisableWeapons();
	}
	
	level flagsys::wait_till( "kill_fullscreen_black" );
	
	self EnableWeapons();
	self FreezeControls( false );	
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

function menuClass( response )
{
	self closeMenus();
	
	// this should probably be an assert
	if(!isdefined(self.pers["team"]) || !(isdefined( level.teams[self.pers["team"]] ) ) )
		return;

	//-- mobile armory handles these changes within the system
	if( flagsys::get( "mobile_armory_in_use" ) )
	{
		return;	
	}
	
	playerclass = self loadout::getClassChoice( response );

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
		self savegame::set_player_data(savegame::get_mission_name() + "_class",playerClass);
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
		self savegame::set_player_data(savegame::get_mission_name() + "_class",playerClass);
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

