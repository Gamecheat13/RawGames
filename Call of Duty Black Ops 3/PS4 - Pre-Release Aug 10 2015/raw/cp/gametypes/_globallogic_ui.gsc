#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\string_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

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

#precache( "menu", "InitialBlack" );

#namespace globallogic_ui;

//REGISTER_SYSTEM( "globallogic_ui", &__init__, undefined )

function init()
{
	callback::add_callback( #"on_player_spawned", &on_player_spawn);
	clientfield::register( "clientuimodel", "hudItems.playerInCombat", 1, 1, "int" );
	clientfield::register( "clientuimodel", "playerAbilities.repulsorIndicatorDirection", 1, 2, "int" );
	clientfield::register( "clientuimodel", "playerAbilities.repulsorIndicatorIntensity", 1, 2, "int" );
	clientfield::register( "clientuimodel", "playerAbilities.proximityIndicatorDirection", 1, 2, "int" );
	clientfield::register( "clientuimodel", "playerAbilities.proximityIndicatorIntensity", 1, 2, "int" );
}

function on_player_spawn()
{
	self thread watch_player_in_combat();
}

function IsAnyAITargettingPlayer( playerEnt )
{
	ais = GetAITeamArray( "axis" ); 
	ais = ArrayCombine( ais, GetAITeamArray( "team3" ), false, false ); // sometimes enemy AI is on team 3 as well
    
    foreach( ai in ais )
    {
		if ( IsActor( ai ) )
		{
			if( ai.enemy === playerEnt )
				return true;
		}
    }
    
    return false;
}
                                
function IsAnyAIAwareOfPlayer( playerEnt )
{
	ais = GetAITeamArray( "axis" ); 
	ais = ArrayCombine( ais, GetAITeamArray( "team3" ), false, false ); // sometimes enemy AI is on team 3 as well
    
    foreach( ai in ais )
    {
		if ( IsActor( ai ) )
		{
			if( ai.enemy === playerEnt )
				return true;
        
			// Has seen the player recently?
			if( ai SeeRecently( playerEnt, 4 ) ) 
				return true;
        
			// Has known about player recently?
			if( ai LastKnownTime( playerEnt ) < 4 * 1000 ) 
				return true;
		}
    }
    
    return false;
}

function IsPlayerHurt( playerEnt )
{
	return playerEnt.health < playerEnt.maxhealth;
}

function watch_player_in_combat()
{
	self endon("kill_watch_player_in_combat");
	self endon( "disconnect" );
	
	while( true )
	{
		if ( IsPlayerHurt( self ) || IsAnyAITargettingPlayer( self ) || IsAnyAIAwareOfPlayer( self ) )
		{
			self clientfield::set_player_uimodel( "hudItems.playerInCombat", 1 );
			self.lastTargetedTime = gettime();
		}
		else
		{
			if ( !isDefined( self.lastTargetedTime ) || ( gettime() - self.lastTargetedTime > 4000 ) ) 
			{
				self clientfield::set_player_uimodel( "hudItems.playerInCombat", 0 );
			}
		}

		wait( 0.5 );
	}
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

	self.sessionteam = assignment;
	
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

function beginClassChoice()
{
	assert( isdefined( level.teams[self.pers["team"]] ) );
	
	team = self.pers["team"];
	
	if ( !GetDvarInt( "art_review", 0 ) )
	{
		self thread fullscreen_black();
	}
	
	if ( !GetDvarInt( "force_cac", 0 ) )
	{
		prevclass = self savegame::get_player_data( savegame::get_mission_name() + "_class", undefined );
		prevHeroWeapons = self savegame::get_player_data( savegame::get_mission_name() + "hero_weapon", undefined );
	
		if ( isdefined( prevclass )
		    || ( isdefined( level.disableClassSelection ) && level.disableClassSelection )
		    || ( isdefined( self.disableClassSelection ) && self.disableClassSelection )
		    || GetDvarint( "migration_soak" ) == 1 )
		{
			self.curClass = (isdefined(prevclass)?prevclass:level.defaultClass);
			self.pers[ "class" ] = self.curClass;
			
			if( isDefined( prevHeroWeapons ) )
			{
				self.heroWeapons = prevHeroWeapons;
			}
	
			{wait(.05);};
			
			if ( self.sessionstate != "playing" && game[ "state" ] == "playing" )
			{
				self thread [[ level.spawnClient ]]();
			}
			
			globallogic::updateTeamStatus();
			self thread spectating::set_permissions_for_machine();
			
			return;
		}
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
	
	self CloseMenu( "InitialBlack" );
	self OpenMenu( "InitialBlack" );
	
	self Hide();
	
	{wait(.05);};
	
	if ( isdefined( level.str_level_start_flag ) || isdefined( level.str_player_start_flag ) )
	{
		init_start_flags();
	
		self thread fullscreen_black_freeze_controls();
		
		if ( isdefined( level.str_level_start_flag ) )
		{
			level flag::wait_till( level.str_level_start_flag );
		}
		
		if ( isdefined( level.str_player_start_flag ) )
		{
			self flag::wait_till( level.str_player_start_flag );
		}
	}
	
	self Show();
	
	self flagsys::set( "kill_fullscreen_black" );
	
	level util::clientnotify( "sndOn" );
	
	/#
		PrintTopRightln( "KILL INITIAL BLACKSCREEN: PLAYER " + self GetEntityNumber(), ( 1, 1, 1 ) );
	#/

	util::wait_network_frame(); // Give time for other menus to come up before closing this one	
	self CloseMenu( "InitialBlack" );
}

function init_start_flags()
{
	if ( isdefined( level.str_player_start_flag ) && !self flag::exists( level.str_player_start_flag ) )
	{
		self flag::init( level.str_player_start_flag );
	}
	
	if ( isdefined( level.str_level_start_flag ) && !level flag::exists( level.str_level_start_flag ) )
	{
		level flag::init( level.str_level_start_flag );
	}
}

function fullscreen_black_freeze_controls()
{
	self endon( "disconnect" );
	self flagsys::wait_till( "loadout_given" );
	
	self FreezeControls( true );
	wait 0.1;	// Several other scripts unfreeze controls when spawning, need to wait
	waittillframeend;
	self FreezeControls( true );
	
	self flagsys::wait_till( "kill_fullscreen_black" );
	
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
		
		self.sessionteam = team;

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
	if ( !isdefined( self.pers[ "team" ] ) || !( isdefined( level.teams[ self.pers[ "team" ]] ) ) )
	{
		return;
	}

	//-- mobile armory handles these changes within the system
	if ( flagsys::get( "mobile_armory_in_use" ) )
	{
		return;
	}
	
	playerclass = "";
	
	if ( response == "cancel" )
	{
		prevclass = self savegame::get_player_data( savegame::get_mission_name() + "_class", undefined );
		
		if ( isdefined( prevclass ) )
		{
			playerclass = prevclass;
		}
		else
		{
			playerclass = level.defaultClass;
		}
	}
	else
	{	
		playerclass = self loadout::getClassChoice( response );
	}

	if( (isdefined( self.pers["class"] ) && self.pers["class"] == playerclass) )
		return;

	self.pers["changed_class"] = true;
	self notify ( "changed_class" );
	waittillframeend;
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

	globallogic::updateTeamStatus();

	self thread spectating::set_permissions_for_machine();
	self notify("class_changed");
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

// weakpoint helpers
#precache( "eventstring", "weakpoint_update" );

function destroyWeakpointWidget( entityNumber, precachedBoneName )
{
	LUINotifyEvent( &"weakpoint_update", 3, 0, entityNumber, precachedBoneName );
}

function createWeakpointWidget( entityNumber, precachedBoneName, closeStateMaxDistance = undefined, mediumStateMaxDistance = undefined )
{
	if ( !isdefined( closeStateMaxDistance ) )
	{
		closeStateMaxDistance = GetDVarInt( "ui_weakpointIndicatorNear" );
	}
	
	if ( !isdefined( mediumStateMaxDistance ) )
	{
		mediumStateMaxDistance = GetDVarInt( "ui_weakpointIndicatorMedium" );
	}
	
	LUINotifyEvent( &"weakpoint_update", 5, 1, entityNumber, precachedBoneName, closeStateMaxDistance, mediumStateMaxDistance );
}

function triggerWeakpointDamage( entityNumber, precachedBoneName )
{
	LUINotifyEvent( &"weakpoint_update", 3, 2, entityNumber, precachedBoneName );
}

function triggerWeakpointRepulsed( entityNumber, precachedBoneName )
{
	LUINotifyEvent( &"weakpoint_update", 3, 3, entityNumber, precachedBoneName );
}