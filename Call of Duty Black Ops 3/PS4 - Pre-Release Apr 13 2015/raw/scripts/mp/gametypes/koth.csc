#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_challenges;
#using scripts\mp\_medals;
#using scripts\mp\_popups;
#using scripts\mp\_util;








/*QUAKED mp_multi_team_spawn (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Spawns used for use in some multi team game modes to open up other portions of the map for multi team scenarios.*/

#precache( "string", "OBJECTIVES_KOTH" );
#precache( "string", "OBJECTIVES_KOTH_SCORE" );
#precache( "string", "MP_WAITING_FOR_HQ" );
#precache( "string", "MP_KOTH_CAPTURED_BY" );
#precache( "string", "MP_KOTH_CAPTURED_BY_ENEMY" );
#precache( "string", "MP_KOTH_MOVING_IN" );
#precache( "string", "MP_CAPTURING_OBJECTIVE" );
#precache( "string", "MP_KOTH_CONTESTED_BY_ENEMY" );
#precache( "string", "MP_KOTH_AVAILABLE_IN" );
#precache( "string", "MP_CONTROL_KOTH" );
#precache( "string", "MP_CAPTURE_KOTH" );
#precache( "string", "MP_DEFEND_KOTH" );
#precache( "string", "MP_KOTH_AVAILABLE_IN" );
#precache( "string", "MP_HQ_DESPAWN_IN" );
#precache( "string", "MP_HQ_REINFORCEMENTS_IN" );
#precache( "string", "MP_CAPTURING_HQ" );
#precache( "string", "MP_DESTROYING_HQ" );
#precache( "fx", "ui/fx_koth_marker_blue" );
#precache( "fx", "ui/fx_koth_marker_orng" );
#precache( "fx", "ui/fx_koth_marker_neutral" );
#precache( "fx", "ui/fx_koth_marker_contested" );
#precache( "fx", "ui/fx_koth_marker_blue_window" );
#precache( "fx", "ui/fx_koth_marker_orng_window" );
#precache( "fx", "ui/fx_koth_marker_neutral_window" );
#precache( "fx", "ui/fx_koth_marker_contested_window" );
#precache( "objective", "hardpoint" );

function main()
{
	globallogic::init();

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 1000 );
	util::registerNumLives( 0, 100 );
	util::registerRoundSwitch( 0, 9 );
	util::registerRoundWinLimit( 0, 10 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.scoreRoundWinBased = true;
	level.kothStartTime = 0;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.playerSpawnedCB =&koth_playerSpawnedCB;
	level.onRoundSwitch =&onRoundSwitch;
	level.onPlayerKilled =&onPlayerKilled;
	level.onEndGame=&onEndGame;
		
	clientfield::register( "world", "hardpoint", 1, 5, "int" );
	clientfield::register( "world", "hardpointteam", 1, 5, "int" );

	level.zoneAutoMoveTime = GetGametypeSetting( "autoDestroyTime" );
	level.zoneSpawnTime = GetGametypeSetting( "objectiveSpawnTime" );
	level.kothMode = GetGametypeSetting( "kothMode" );
	level.captureTime = GetGametypeSetting( "captureTime" );
	level.destroyTime = GetGametypeSetting( "destroyTime" );
	level.delayPlayer = GetGametypeSetting( "delayPlayer" );
	level.randomZoneSpawn = GetGametypeSetting( "randomObjectiveLocations" );
	level.scorePerPlayer = GetGametypeSetting( "scorePerPlayer" );
		
	level.iconoffset = (0,0,32);
	
	level.onRespawnDelay =&getRespawnDelay;

	globallogic_audio::set_leader_gametype_dialog ( 6, 21, 48, 48 );
	
	game["objective_gained_sound"] = "mpl_flagcapture_sting_friend";
	game["objective_lost_sound"] = "mpl_flagcapture_sting_enemy";
	game["objective_contested_sound"] = "mpl_flagreturn_sting";

	level.lastDialogTime = 0;
	level.zoneSpawnQueue = [];
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "captures", "defends", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "captures", "defends" );

	globallogic_audio::register_dialog_group( "gamemode_objective", false );
	
	/#
		// HQ radio triggers are not scoped to exclude koth right now
		// going to delete them just so if we render triggers we dont see all these
		// TODO in the future is to get them into the automatic game type delete system
		trigs = getentarray("radiotrigger", "targetname");
		foreach( trig in trigs )
		{
			trig delete();
		}
	#/
}


function updateObjectiveHintMessages( defenderTeam, defendMessage, attackMessage )
{
	foreach( team in level.teams )
	{
		if ( defenderTeam == team )
		{
			game["strings"]["objective_hint_" + team] = defendMessage;
		}
		else
		{
			game["strings"]["objective_hint_" + team] = attackMessage;
		}
	}
}

function updateObjectiveHintMessage( message )
{
	foreach( team in level.teams )
	{
		game["strings"]["objective_hint_" + team] = message;
	}
}

function getRespawnDelay()
{
	self.lowerMessageOverride = undefined;

	if ( !isdefined( level.zone.gameobject ) )
		return undefined;
	
	zoneOwningTeam = level.zone.gameobject gameobjects::get_owner_team();
	if ( self.pers["team"] == zoneOwningTeam )
	{
		if ( !isdefined( level.zoneMoveTime ) )
			return undefined;
		
		timeRemaining = (level.zoneMoveTime - gettime()) / 1000;

		if (!level.playerObjectiveHeldRespawnDelay )
			return undefined;

		if ( level.playerObjectiveHeldRespawnDelay >= level.zoneAutoMoveTime )
			self.lowerMessageOverride = &"MP_WAITING_FOR_HQ";				
			
		if ( level.delayPlayer )
		{
			return min( level.spawnDelay, timeRemaining );
		}
		else
		{
			return ceil(timeRemaining);
		}
	}
}

function onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	
	globallogic_score::resetTeamScores();
	
	foreach( team in level.teams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_KOTH" );
	
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_KOTH" );
		}
		else
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_KOTH_SCORE" );
		}
	}
	
	level.objectiveHintPrepareZone = &"MP_CONTROL_KOTH";
	level.objectiveHintCaptureZone = &"MP_CAPTURE_KOTH";
	level.objectiveHintDefendHQ = &"MP_DEFEND_KOTH";
	
	if ( level.zoneSpawnTime )
		updateObjectiveHintMessage( level.objectiveHintPrepareZone );
	else
		updateObjectiveHintMessage( level.objectiveHintCaptureZone );
	
	setClientNameMode("auto_change");
	
	allowed[0] = "koth";

	gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	// TODO: HQ spawnpoints
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	foreach( team in level.teams )
	{
		spawnlogic::add_spawn_points( team, "mp_tdm_spawn" );
		spawnlogic::add_spawn_points( team, "mp_multi_team_spawn" );

		spawnlogic::place_spawn_points( spawning::getTDMStartSpawnName(team) );
	}
	
	spawning::updateAllSpawnPoints();
	
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array( spawning::getTDMStartSpawnName(team) );
	}

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_all = spawnlogic::get_spawnpoint_array( "mp_tdm_spawn" );
	if ( !level.spawn_all.size )
	{
/#
		println("^1No mp_tdm_spawn spawnpoints in level!");
#/
		callback::abort_level();
		return;
	}
	
	
	thread SetupZones();

	updateGametypeDvars();

	thread KothMainLoop();
}


function updateGametypeDvars()
{
	level.playerCaptureLPM = GetGametypeSetting( "maxPlayerEventsPerMinute" );
}

function spawn_first_zone(delay)
{
	// pick next Zone object
	if ( level.randomZoneSpawn == 1 )
	{
		level.zone = GetNextZoneFromQueue();
	}
	else
	{
		level.zone = GetFirstZone();
	}
	
	if ( isdefined( level.zone ) )
	{
		/#print("zone spawned: ("+level.zone.trigOrigin[0]+","+level.zone.trigOrigin[1]+","+level.zone.trigOrigin[2]+")");#/
		
		level.zone spawning::enable_influencers(true);
	}

	level.zone.gameobject.trigger AllowTacticalInsertion( false ); 
	
	return;
}

function spawn_next_zone()
{
	level.zone.gameobject.trigger AllowTacticalInsertion( true ); 

	// pick next Zone object
	if ( level.randomZoneSpawn != 0 )
	{
		level.zone = GetNextZoneFromQueue();
	}
	else
	{
		level.zone = GetNextZone();
	}
	
	if ( isdefined( level.zone ) )
	{
		/#print("zone spawned: ("+level.zone.trigOrigin[0]+","+level.zone.trigOrigin[1]+","+level.zone.trigOrigin[2]+")");#/
		
		level.zone spawning::enable_influencers(true);
	}

	level.zone.gameobject.trigger AllowTacticalInsertion( false ); 
	
	return;
}

function getNumTouching( )
{
	numTouching = 0;
	foreach( team in level.teams )
	{
		numTouching += self.numTouching[team];
	}
	
	return numTouching;
}

function toggleZoneEffects( enabled )
{
	index = 0;
	
	if ( enabled )
	{
		index = self.script_index;
	}
	
	level clientfield::set( "hardpoint", index );
	level clientfield::set( "hardpointteam", 0 );
}

function KothCaptureLoop()
{
	level endon("game_ended");
	level endon("zone_moved");
	level.kothStartTime = gettime();
	
	while( 1 )
	{
		level.zone.gameobject gameobjects::allow_use( "any" );
		level.zone.gameobject gameobjects::set_use_time( level.captureTime );
		level.zone.gameobject gameobjects::set_use_text( &"MP_CAPTURING_OBJECTIVE" );
		
		numTouching = level.zone.gameobject getNumTouching( );

		level.zone.gameobject gameobjects::set_visible_team( "any" );
		level.zone.gameobject gameobjects::set_model_visibility( true );
		level.zone.gameobject gameobjects::must_maintain_claim( false );
		level.zone.gameobject gameobjects::can_contest_claim( true );
		
		level.zone.gameobject.onUse =&onZoneCapture;
		level.zone.gameobject.onBeginUse =&onBeginUse;
		level.zone.gameobject.onEndUse =&onEndUse;

		level.zone toggleZoneEffects( true );

		msg = level util::waittill_any_return( "zone_captured", "zone_destroyed" );
	
		// this happens if it goes from contested to neutral
		if ( msg == "zone_destroyed" )
			continue;
			
		ownerTeam = level.zone.gameobject gameobjects::get_owner_team();

		foreach( team in level.teams )
		{
			updateObjectiveHintMessages( ownerTeam, level.objectiveHintDefendHQ, level.objectiveHintCaptureZone );
		}

		level.zone.gameobject gameobjects::allow_use( "none" );
		
		level.zone.gameobject.onUse = undefined;
		level.zone.gameobject.onUnoccupied =&onZoneUnoccupied;
		level.zone.gameobject.onContested =&onZoneContested;
		level.zone.gameobject.onUncontested =&onZoneUncontested;
			
		level waittill( "zone_destroyed", destroy_team );
		
		if ( !level.kothMode || level.zoneDestroyedByTimer )
			break;
		
		thread forceSpawnTeam( ownerTeam );
		
		if ( isdefined( destroy_team ) )
		{
			level.zone.gameobject gameobjects::set_owner_team( destroy_team );
		}
		else
		{
			level.zone.gameobject gameobjects::set_owner_team( "none" );
		}
	}
}

function KothMainLoop()
{
	level endon("game_ended");
	
	level.zoneRevealTime = -100000;
	
	zoneSpawningInStr = &"MP_KOTH_AVAILABLE_IN";
	if ( level.kothMode )
	{
		zoneDestroyedInFriendlyStr = &"MP_HQ_DESPAWN_IN";
		zoneDestroyedInEnemyStr = &"MP_KOTH_MOVING_IN";
	}
	else
	{
		zoneDestroyedInFriendlyStr = &"MP_HQ_REINFORCEMENTS_IN";
		zoneDestroyedInEnemyStr = &"MP_HQ_DESPAWN_IN";
	}
		
	spawn_first_zone();
	
	while ( level.inPrematchPeriod )
		{wait(.05);};
	
	wait 5;
		
	timerDisplay = [];
	foreach ( team in level.teams )
	{
		timerDisplay[team] = hud::createServerTimer( "objective", 1.4, team );
		timerDisplay[team] hud::setGamemodeInfoPoint();
		timerDisplay[team].label = zoneSpawningInStr;
		timerDisplay[team].font = "extrasmall";
		timerDisplay[team].alpha = 0;
		timerDisplay[team].archived = false;
		timerDisplay[team].hideWhenInMenu = true;
		timerDisplay[team].hideWhenInKillcam = true;
		timerDisplay[team].showplayerteamhudelemtospectator = true;
		timerDisplay[team].y = 150;

		thread hideTimerDisplayOnGameEnd( timerDisplay[team] );
	}
	
	while( 1 )
	{
		sound::play_on_players( "mp_suitcase_pickup" );
		globallogic_audio::flush_group_dialog( "gamemode_objective" );
		globallogic_audio::leader_dialog( 82 );
		
		level.zone.gameobject gameobjects::set_model_visibility( true );
		
		level.zoneRevealTime = gettime();
	
		if ( level.zoneSpawnTime )
		{
			level.zone.gameobject gameobjects::set_visible_team( "any" );
			level.zone.gameobject gameobjects::set_flags( 1 );

			updateObjectiveHintMessage( level.objectiveHintPrepareZone );
			
			foreach( team in level.teams )
			{
				timerDisplay[team].label = zoneSpawningInStr;
				timerDisplay[team] setTimer( level.zoneSpawnTime );
				timerDisplay[team].alpha = 1;
			}

			wait level.zoneSpawnTime;

			level.zone.gameobject gameobjects::set_flags( 0 );
			globallogic_audio::leader_dialog( 84 );
		}

		foreach( team in level.teams )
		{
			timerDisplay[team].alpha = 0;
		}
		
		waittillframeend;
		
		//globallogic_audio::leader_dialog( "obj_capture", undefined, "gamemode_objective" );
		updateObjectiveHintMessage( level.objectiveHintCaptureZone );
		sound::play_on_players( "mpl_hq_cap_us" );

		level.zone.gameobject gameobjects::enable_object();
		level.zone.gameobject.captureCount = 0;
		
		if ( level.zoneAutoMoveTime )
		{
			thread MoveZoneAfterTime( level.zoneAutoMoveTime );
			foreach( team in level.teams )
			{
				timerDisplay[team] setTimer( level.zoneAutoMoveTime );
			}
			
			foreach( team in level.teams )
			{
				timerDisplay[team].label = zoneDestroyedInEnemyStr;	
				timerDisplay[team].alpha = 1;
			}
		}
		else
		{
			level.zoneDestroyedByTimer = false;
		}
	
		KothCaptureLoop();
		
		ownerTeam = level.zone.gameobject gameobjects::get_owner_team();
		
		if ( level.zone.gameobject.captureCount == 1 )
		{
		// Copy touch list so there aren't any threading issues
		touchList = [];
		touchKeys = GetArrayKeys( level.zone.gameobject.touchList[ownerTeam] );
		for ( i = 0 ; i < touchKeys.size ; i++ )
			touchList[touchKeys[i]] = level.zone.gameobject.touchList[ownerTeam][touchKeys[i]];
			thread give_held_credit( touchList );		
		}
		
		level.zone spawning::enable_influencers(false);
		level.zone.gameobject.lastCaptureTeam = undefined;
		level.zone.gameobject gameobjects::disable_object();
		level.zone.gameobject gameobjects::allow_use( "none" );
		level.zone.gameobject gameobjects::set_owner_team( "neutral" );
		level.zone.gameobject gameobjects::set_model_visibility( false );
		level.zone.gameobject gameobjects::must_maintain_claim( false );
		level.zone toggleZoneEffects( false );
	
		level notify("zone_reset");
		
		foreach( team in level.teams )
		{
			timerDisplay[team].alpha = 0;
		}
				
		spawn_next_zone();
		
		wait 0.5;
		
		thread forceSpawnTeam( ownerTeam );
		
		wait 0.5;
	}
}


function hideTimerDisplayOnGameEnd( timerDisplay )
{
	level waittill("game_ended");
	timerDisplay.alpha = 0;
}


function forceSpawnTeam( team )
{
	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if ( !isdefined( player ) )
			continue;
		
		if ( player.pers["team"] == team )
		{
			player notify( "force_spawn" );
			wait .1;
		}
	}
}

function updateTeamClientField()
{
	ownerTeam = self gameobjects::get_owner_team();

	if ( 	self.isContested )
	{
		level clientfield::set( "hardpointteam", 3 );
	}
	else if ( ownerTeam == "neutral" )
	{
		level clientfield::set( "hardpointteam", 0 );
	}
	else
	{
		if ( ownerTeam == "allies" )
			level clientfield::set( "hardpointteam", 1 );
		else
			level clientfield::set( "hardpointteam", 2 );
	}
}

function onBeginUse( player )
{
	ownerTeam = self gameobjects::get_owner_team();

	if ( ownerTeam == "neutral" )
	{
		player thread battlechatter::gametype_specific_battle_chatter( "hq_protect", player.pers["team"] );
	}
	else
	{
		player thread battlechatter::gametype_specific_battle_chatter( "hq_attack", player.pers["team"] );
	}
}


function onEndUse( team, player, success )
{
	player notify( "event_ended" );
}


function onZoneCapture( player )
{
	capture_team = player.pers["team"];
	captureTime = getTime();

	/#print( "zone captured" );#/

	string = &"MP_KOTH_CAPTURED_BY";
	
	level.zone.gameobject.isContested = false;
	level.useStartSpawns = false;

	if ( !isdefined( self.lastCaptureTeam )  || self.lastCaptureTeam != capture_team )
	{
		// Copy touch list so there aren't any threading issues
		touchList = [];
		touchKeys = GetArrayKeys( self.touchList[capture_team] );
		for ( i = 0 ; i < touchKeys.size ; i++ )
			touchList[touchKeys[i]] = self.touchList[capture_team][touchKeys[i]];
		thread give_capture_credit( touchList, string, captureTime, capture_team, self.lastCaptureTeam );
	}

	level.kothCapTeam = capture_team;

	oldTeam = gameobjects::get_owner_team();
	self gameobjects::set_owner_team( capture_team );
	if ( !level.kothMode )
		self gameobjects::set_use_time( level.destroyTime );
	
	foreach( team in level.teams )
	{
		if ( team == capture_team )
		{
			if ( isdefined( self.lastCaptureTeam ) && ( self.lastCaptureTeam != team ) ) // If retaking this point after being contested, don't play VO again
			{
				globallogic_audio::leader_dialog( 85, team, "gamemode_objective" );
				for ( index = 0; index < level.players.size; index++ )
				{
					player = level.players[index];
					
					if ( player.pers["team"] == team )
					{
						if ( player.lastKilltime + 500 > getTime() )
						{
							player challenges::killedLastContester();	
						}
					}
				}
			}
			thread sound::play_on_players( game["objective_gained_sound"], team );
		}
		else
		{
			if ( oldTeam == team ) // Only the team who just lost the point hear the VO
			{
				globallogic_audio::leader_dialog( 83, team, "gamemode_objective" );
			}
			else if ( oldTeam == "neutral" )
			{
				globallogic_audio::leader_dialog( 80, team, "gamemode_objective" );
			}
			thread sound::play_on_players( game["objective_lost_sound"], team );
		}
	}
			
	level thread awardCapturePoints( capture_team, self.lastCaptureTeam );
	self.captureCount++;
	self.lastCaptureTeam = capture_team;
	
	self gameobjects::must_maintain_claim( true );
	
	self updateTeamClientField();
	
	level notify( "zone_captured" );
	level notify( "zone_captured" + capture_team );
	player notify( "event_ended" );
}

function give_capture_credit( touchList, string, captureTime, capture_team, lastCaptureTeam )
{
	wait .05;
	util::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player = touchList[players[i]].player;

		player updateCapsPerMinute( lastCaptureTeam );

		if ( !isScoreBoosting( player ) )
		{
			player challenges::capturedObjective( captureTime );
			if ( level.kothStartTime + 3000 > captureTime && level.kothCapTeam == capture_team ) 
			{
				scoreevents::processScoreEvent( "quickly_secure_point", player );
			}
		
			scoreevents::processScoreEvent( "koth_secure", player );
			player RecordGameEvent("capture");

			level thread popups::DisplayTeamMessageToAll( string, player );

			if( isdefined(player.pers["captures"]) )
			{
				player.pers["captures"]++;
				player.captures = player.pers["captures"];
			}		
				
			if ( level.kothStartTime + 500 > captureTime ) 
			{
				player challenges::immediateCapture();
			}

			demo::bookmark( "event", gettime(), player );
			player AddPlayerStatWithGameType( "CAPTURES", 1 );
		}
		else
		{
			/#
				player IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU CAPTURE CREDIT AS BOOSTING PREVENTION" );
			#/
		}
	}
}

function give_held_credit( touchList, team )
{
	wait .05;
	util::WaitTillSlowProcessAllowed();

	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player = touchList[players[i]].player;
			
		//scoreevents::processScoreEvent( "koth_held", player );

		// do not know if we want the following
		//player RecordGameEvent("held");

	}
}

function onZoneDestroy( player )
{
	destroyed_team = player.pers["team"];

	/#print( "zone destroyed" );#/
	scoreevents::processScoreEvent( "zone_destroyed", player );	
	player RecordGameEvent("destroy");	
	player AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
		
	if( isdefined(player.pers["destructions"]) )
	{
		player.pers["destructions"]++;
		player.destructions = player.pers["destructions"];
	}
	
	destroyTeamMessage = &"MP_HQ_DESTROYED_BY";
	otherTeamMessage = &"MP_HQ_DESTROYED_BY_ENEMY";
	
	if ( level.kothMode )
	{
		destroyTeamMessage = &"MP_KOTH_CAPTURED_BY";
		otherTeamMessage = &"MP_KOTH_CAPTURED_BY_ENEMY";
	}
	
	level thread popups::DisplayTeamMessageToAll( destroyTeamMessage, player );

	foreach( team in level.teams )
	{
		if ( team == destroyed_team )
		{
			globallogic_audio::leader_dialog( "koth_secured", team, "gamemode_objective" );
		}
		else
		{
			globallogic_audio::leader_dialog( "koth_destroyed", team, "gamemode_objective" );	
		}
	}

	level notify( "zone_destroyed", destroyed_team );
	
	if ( level.kothMode )
		level thread awardCapturePoints( destroyed_team );

	player notify( "event_ended" );
}

function onZoneUnoccupied()
{
	level notify( "zone_destroyed" );
	level.kothCapTeam = "neutral";
	level.zone.gameobject.wasLeftUnoccupied = true;
	level.zone.gameobject.isContested = false;

	self updateTeamClientField();
}

function onZoneContested()
{	
	zoneOwningTeam = self gameobjects::get_owner_team();
	self.wasContested = true;
	self.isContested = true;

	self updateTeamClientField();

	foreach( team in level.teams )
	{
		if ( team == zoneOwningTeam )
		{
			thread sound::play_on_players( game["objective_contested_sound"], team );
			globallogic_audio::leader_dialog( 81, team, "gamemode_objective" );
		}
	}
}

function onZoneUncontested( lastClaimTeam )
{	
	assert( lastClaimTeam ==  level.zone.gameobject gameobjects::get_owner_team() );
	
	self.isContested = false;

	self gameobjects::set_claim_team( lastClaimTeam );
	
	self updateTeamClientField();
}

function MoveZoneAfterTime( time )
{
	level endon( "game_ended" );
	level endon( "zone_reset" );
	
	level.zoneMoveTime = gettime() + time * 1000;
	level.zoneDestroyedByTimer = false;
	
	wait time;

	if ( !isdefined( level.zone.gameobject.wasContested ) || level.zone.gameobject.wasContested == false )
	{
		if ( !isdefined( level.zone.gameobject.wasLeftUnoccupied ) || level.zone.gameobject.wasLeftUnoccupied == false )
		{
			zoneOwningTeam = level.zone.gameobject gameobjects::get_owner_team();
			challenges::controlZoneEntirely( zoneOwningTeam );
		}
	}

	level.zoneDestroyedByTimer = true;

	level notify( "zone_moved" );
}


function awardCapturePoints( team, lastCaptureTeam )
{
	level endon( "game_ended" );
	level endon( "zone_destroyed" );
	level endon( "zone_reset" );
	level endon( "zone_moved" );
	
	level notify("awardCapturePointsRunning");
	level endon("awardCapturePointsRunning");
	
	seconds = 1;
	score = 1;

	while ( !level.gameEnded )
	{
		wait seconds;
		hostmigration::waitTillHostMigrationDone();
		
		if ( !level.zone.gameobject.isContested )
		{
			if ( level.scorePerPlayer )
			{
				score = level.zone.gameobject.numTouching[team];
			}
			
			globallogic_score::giveTeamScoreForObjective( team, score );
		}
	}
}


function onSpawnPlayerUnified()
{
	spawning::onSpawnPlayer_Unified();
}

function onSpawnPlayer(predictedSpawn)
{
	spawnpoint = undefined;
	
	if ( !level.useStartSpawns )
	{
		if (isdefined(level.zone))
		{
			if (isdefined(level.zone.gameobject))
			{
				zoneOwningTeam = level.zone.gameobject gameobjects::get_owner_team();
				if ( self.pers["team"] == zoneOwningTeam )
					spawnpoint = spawnlogic::get_spawnpoint_near_team( level.spawn_all, level.zone.gameobject.nearSpawns );
				else if ( level.spawnDelay >= level.zoneAutoMoveTime && gettime() > level.zoneRevealTime + 10000 )
					spawnpoint = spawnlogic::get_spawnpoint_near_team( level.spawn_all );
				else
					spawnpoint = spawnlogic::get_spawnpoint_near_team( level.spawn_all, level.zone.gameobject.outerSpawns );
			}
		}
	}
	
	if ( !isdefined( spawnpoint ) )
	{
		spawnteam = self.pers["team"];
		spawnpoint = spawnlogic::get_spawnpoint_random(level.spawn_start[spawnteam]);
	}
	
	assert( isdefined(spawnpoint) );
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self spawn( spawnpoint.origin, spawnpoint.angles, "koth" );
	}
}


function koth_playerSpawnedCB()
{
	self.lowerMessageOverride = undefined;
}

function CompareZoneIndexes( zone_a, zone_b )
{
	script_index_a = zone_a.script_index;
	script_index_b = zone_b.script_index;
	
	if( !isdefined(script_index_a) && !isdefined(script_index_b) )
	{
		return false;
	}

	if( !isdefined(script_index_a) && isdefined(script_index_b) )
	{
/#
		println( "KOTH: Missing script_index on zone at " + zone_a.origin );
#/
		return true;
	}
	
	if( isdefined(script_index_a) && !isdefined(script_index_b) )
	{
/#
		println( "KOTH: Missing script_index on zone at " + zone_b.origin );
#/
		return false;
	}
	
	if( script_index_a > script_index_b )
	{
		return true;
	}
	
	return false;
}


function getZoneArray()
{
  zones = getentarray( "koth_zone_center", "targetname" );

	if( !isdefined( zones ) )
	{
		return undefined;
	}
	
	swapped = true;
	n = zones.size;
	while ( swapped )
	{
		swapped = false;
		for( i = 0 ; i < n-1 ; i++ )
		{
			if( CompareZoneIndexes(zones[i], zones[i+1]) )
			{
				temp = zones[i];
				zones[i] = zones[i+1];
				zones[i+1] = temp;
				swapped = true;
			}
		}
		n--;
	}
	return zones;
}


function SetupZones()
{
	maperrors = [];

	zones = getZoneArray();
	
//	if ( zones.size < 2 )
//	{
//		maperrors[maperrors.size] = "There are not at least 2 entities with targetname \"zone\"";
//	}
	
	trigs = getentarray("koth_zone_trigger", "targetname");
	for ( i = 0; i < zones.size; i++ )
	{
		errored = false;
		
		zone = zones[i];
		zone.trig = undefined;
		for ( j = 0; j < trigs.size; j++ )
		{
			if ( zone istouching( trigs[j] ) )
			{
				if ( isdefined( zone.trig ) )
				{
					maperrors[maperrors.size] = "Zone at " + zone.origin + " is touching more than one \"zonetrigger\" trigger";
					errored = true;
					break;
				}
				zone.trig = trigs[j];
				break;
			}
		}
		
		if ( !isdefined( zone.trig ) )
		{
			if ( !errored )
			{
				maperrors[maperrors.size] = "Zone at " + zone.origin + " is not inside any \"zonetrigger\" trigger";
				continue;
			}
			
			// possible fallback (has been tested)
			//zone.trig = spawn( "trigger_radius", zone.origin, 0, 128, 128 );
			//errored = false;
		}
		
		assert( !errored );
		
		zone.trigorigin = zone.trig.origin;
		
		visuals = [];
		visuals[0] = zone;
		
		if ( isdefined( zone.target ) )
		{
			otherVisuals = getEntArray( zone.target, "targetname" );
			for ( j = 0; j < otherVisuals.size; j++ )
			{
				visuals[visuals.size] = otherVisuals[j];
			}
		}
		
		objective_name = istring("hardpoint");

		zone.gameObject = gameobjects::create_use_object( "neutral", zone.trig, visuals, (0,0,0), objective_name );
		zone.gameObject gameobjects::disable_object();
		zone.gameObject gameobjects::set_model_visibility( false );
		zone.trig.useObj = zone.gameObject;
		zone setUpNearbySpawns();
		zone createZoneSpawnInfluencer();
	}
	
	if (maperrors.size > 0)
	{
		/#
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		util::error("Map errors. See above");
		#/
		callback::abort_level();
		
		return;
	}
	
	level.zones = zones;
	
	level.prevzone = undefined;
	level.prevzone2 = undefined;
	
	setupZoneExclusions();
	
	return true;
}

function setupZoneExclusions()
{
	if ( !isdefined( level.levelkothDisable ) ) 
		return;
		
/*	foreach( nullZone in level.levelkothDisable ) 
	{
		foreach( zone in level.zones ) 
		{
//			if ( zone.gameObject.trigger istouching( nullZone ) )
			if ( zone.gameObject.trigger istouchingvolume( nullZone.origin, nullZone getmins(), nullZone getmaxs() ) )
			{
				if ( !isdefined( zone.gameObject.exclusions ) )
				{
					zone.gameObject.exclusions = [];
				}
				
				zone.gameObject.exclusions[ zone.gameObject.exclusions.size ] = nullZone;			
			}
		}
	}	
*/

  	foreach( nullZone in level.levelkothDisable )
	{
		mindist = 10000000000;
		foundZone = undefined;
		
		foreach( zone in level.zones ) 
		{
			distance = DistanceSquared( nullZone.origin, zone.origin );
			
			if ( distance < mindist )
			{
				foundZone = zone;
				mindist = distance;
			}
		}
		
		if ( isdefined( foundZone ) )
		{
			if ( !isdefined( foundZone.gameObject.exclusions ) )
			{
				foundZone.gameObject.exclusions = [];
			}
			foundZone.gameObject.exclusions[ foundZone.gameObject.exclusions.size ] = nullZone;
		}
	}

}

function setUpNearbySpawns()
{
	spawns = level.spawn_all;
	
	for ( i = 0; i < spawns.size; i++ )
	{
		spawns[i].distsq = distanceSquared( spawns[i].origin, self.origin );
	}
	
	// sort by distsq
	for ( i = 1; i < spawns.size; i++ )
	{
		thespawn = spawns[i];
		for ( j = i - 1; j >= 0 && thespawn.distsq < spawns[j].distsq; j-- )
			spawns[j + 1] = spawns[j];
		spawns[j + 1] = thespawn;
	}
	
	first = [];
	second = [];
	third = [];
	outer = [];
	
	thirdSize = spawns.size / 3;
	for ( i = 0; i <= thirdSize; i++ )
	{
		first[ first.size ] = spawns[i];
	}
	for ( ; i < spawns.size; i++ )
	{
		outer[ outer.size ] = spawns[i];
		if ( i <= (thirdSize*2) )
			second[ second.size ] = spawns[i];
		else			
			third[ third.size ] = spawns[i];
	}
	
	self.gameObject.nearSpawns = first;
	self.gameObject.midSpawns = second;
	self.gameObject.farSpawns = third;
	self.gameObject.outerSpawns = outer;
}

function GetFirstZone()
{
	zone = level.zones[ 0 ];

	// old linear and "random" systems 
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	level.prevZoneIndex = 0;

	// new shuffled system
	ShuffleZones();
	ArrayRemoveValue( level.zoneSpawnQueue, zone );

	return zone;
}

function GetNextZone()
{
	nextZoneIndex = 	(level.prevZoneIndex + 1) % level.zones.size;
	zone = level.zones[ nextZoneIndex ];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	level.prevZoneIndex = nextZoneIndex;
	
	return zone;
}

function PickRandomZoneToSpawn()
{
	level.prevZoneIndex = randomint( level.zones.size);
	zone = level.zones[ level.prevZoneIndex ];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	
	return zone;
}

function ShuffleZones()
{
	level.zoneSpawnQueue = [];

	spawnQueue = ArrayCopy(level.zones);	
	total_left = spawnQueue.size;
	
	while( total_left > 0 )
	{
		index = randomint( total_left );
		
		valid_zones = 0;
		for( zone = 0; zone < level.zones.size; zone++ )
		{
			if ( !isdefined(spawnQueue[zone]) )
				continue;
				
			if ( valid_zones == index )
			{
				// dont allow the last radio from the previous shuffle to be put first in the next
				if ( level.zoneSpawnQueue.size == 0 && isdefined( level.zone ) && level.zone == spawnQueue[zone] )
					continue;

				level.zoneSpawnQueue[level.zoneSpawnQueue.size] = spawnQueue[zone];
				spawnQueue[zone] = undefined;
				break;
			}
			
			valid_zones++; 
		}
		
		total_left--;
	}
}

// shuffled picking
function GetNextZoneFromQueue()
{
	if ( level.zoneSpawnQueue.size == 0 )
		ShuffleZones();

	assert( level.zoneSpawnQueue.size > 0 );

	next_zone = level.zoneSpawnQueue[0];
	ArrayRemoveIndex( level.zoneSpawnQueue, 0 );
	
	return next_zone;
}

function GetCountOfTeamsWithPlayers(num)
{
	has_players = 0;
	
	foreach( team in level.teams )
	{
		if ( num[team] > 0 )
			has_players++;
	}
	
	return has_players;
}

function GetPointCost( avgpos, origin )
{
	avg_distance = 0;
	total_error = 0;
	distances = [];
	
	foreach( team, position in avgpos )
	{
		distances[team] = Distance(origin, avgpos[team]);
		avg_distance += distances[team];
	}
	
	avg_distance = avg_distance / distances.size;
	
	foreach( team, dist in distances )
	{
		err = (distances[team] - avg_distance);
		total_error += err * err;
	}
	
	return total_error;
}

function PickZoneToSpawn()
{
	// find average of positions of each team
	// (medians would be better, to get rid of outliers...)
	// and find the zone which has the least difference in distance from those two averages
	
	foreach( team in level.teams )
	{	
		avgpos[team] = (0,0,0);
		num[team] = 0;
	}
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isalive( player ) )
		{
			avgpos[ player.pers["team"] ] += player.origin;
			num[ player.pers["team"] ]++;
		}
	}
	
	if ( GetCountOfTeamsWithPlayers(num) <= 1 )
	{
		zone = level.zones[ randomint( level.zones.size) ];
		while ( isdefined( level.prevzone ) && zone == level.prevzone ) // so lazy
			zone = level.zones[ randomint( level.zones.size) ];
		
		level.prevzone2 = level.prevzone;
		level.prevzone = zone;
		
		return zone;
	}
	
	foreach( team in level.teams )
	{	
		if ( num[team] == 0 )
		{
			avgpos[team] = undefined;
		}
		else
		{
			avgpos[team] = avgpos[team] / num[team];
		}
	}
		
	bestzone = undefined;
	lowestcost = undefined;
	for ( i = 0; i < level.zones.size; i++ )
	{
		zone = level.zones[i];
		
		// (purposefully using distance instead of distanceSquared)
		cost = GetPointCost( avgpos, zone.origin );
		
		if ( isdefined( level.prevzone ) && zone == level.prevzone )
		{
			continue;
		}
		if ( isdefined( level.prevzone2 ) && zone == level.prevzone2 )
		{
			if ( level.zones.size > 2 )
				continue;
			else
				cost += 512 * 512;
		}
		
		if ( !isdefined( lowestcost ) || cost < lowestcost )
		{
			lowestcost = cost;
			bestzone = zone;
		}
	}
	assert( isdefined( bestzone ) );
	
	level.prevzone2 = level.prevzone;
	level.prevzone = bestzone;
	
	return bestzone;
}

function onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}


function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || (level.captureTime && !self.touchTriggers.size && !attacker.touchTriggers.size) || attacker.pers["team"] == self.pers["team"] )
		return;

	medalGiven = false;
	scoreEventProcessed = false;
	
	ownerTeam = undefined;
	
	if ( level.captureTime == 0 )
	{
		if ( !isdefined( level.zone ) )
			return;

		ownerTeam = level.zone.gameObject.ownerTeam ;
		
		if ( !isdefined( ownerTeam ) || ownerTeam == "neutral" )
			return;
	}
	
	if ( self.touchTriggers.size || ( level.captureTime == 0 && self IsTouching( level.zone.trig ) ) )
	{
		if ( level.captureTime > 0 )
		{
			triggerIds = getArrayKeys( self.touchTriggers );
			ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		}
		
		if ( ownerTeam != "neutral" )
		{
			attacker.lastKilltime = getTime();
			team = self.pers["team"];
			if ( team == ownerTeam )
			{
				if ( !medalGiven ) 
				{
					attacker medals::offenseGlobalCount();
					attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
					
					medalGiven = true;
				}
				//scoreevents::processScoreEvent( "killed_defender", attacker, undefined, weapon );// TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
				scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, weapon );
				self RecordKillModifier("defending");
				scoreEventProcessed = true;
			}
			else
			{
				if ( !medalGiven ) 
				{
					if( isdefined(attacker.pers["defends"]) )
					{
						attacker.pers["defends"]++;
						attacker.defends = attacker.pers["defends"];
					}

					attacker medals::defenseGlobalCount();
					medalGiven = true;
					attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
					attacker RecordGameEvent("return");
				}
				attacker challenges::killedZoneAttacker( weapon );
				//scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, weapon ); // TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
				scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, weapon );
				self RecordKillModifier("assaulting");
				scoreEventProcessed = true;
			}
		}		
	}	
	
	if ( attacker.touchTriggers.size || ( level.captureTime == 0 && attacker IsTouching( level.zone.trig ) ) )
	{
		if ( level.captureTime > 0 )
		{
			triggerIds = getArrayKeys( attacker.touchTriggers );
			ownerTeam = attacker.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		}
		
		if ( ownerTeam != "neutral" )
		{
			team = attacker.pers["team"];
			if ( team == ownerTeam )
			{
				if ( !medalGiven ) 
				{					
					if( isdefined(attacker.pers["defends"]) )
					{
						attacker.pers["defends"]++;
						attacker.defends = attacker.pers["defends"];
					}

					attacker medals::defenseGlobalCount();
					medalGiven = true;
					attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
					attacker RecordGameEvent("return");
				}
				if ( scoreEventProcessed == false )
				{
					attacker challenges::killedZoneAttacker( weapon );
					//scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, weapon );// TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
					scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, weapon );
					self RecordKillModifier("assaulting");
				}
			}
			else
			{
				if ( !medalGiven ) 
				{
					attacker medals::offenseGlobalCount();
					medalGiven = true;
					attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
				}
				if ( scoreEventProcessed == false )
				{
					//scoreevents::processScoreEvent( "killed_defender", attacker, undefined, weapon );// TFLAME 9/3/12 - Changing these events to "hardpoint_kill" as attacker / defender changes so often in Hardpoint
					scoreevents::processScoreEvent( "hardpoint_kill", attacker, undefined, weapon );
					self RecordKillModifier("defending");
				}
			}		
		}
	}
	
	if ( medalGiven == true )
	{
		if ( level.zone.gameobject.isContested == true ) 
		{
			attacker thread killWhileContesting();
		}
	}
}


function killWhileContesting()
{	
	self notify( "killWhileContesting" );
	self endon( "killWhileContesting" );
	self endon( "disconnect" );
	
	killTime = getTime();
	playerteam = self.pers["team"];
	if ( !isdefined ( self.clearEnemyCount ) )
	{
		self.clearEnemyCount = 0;
	}
	
	self.clearEnemyCount++;
	
	zoneReturn = level util::waittill_any_return( "zone_captured" + playerteam, "zone_destroyed", "zone_captured", "death" );
	
	if ( zoneReturn == "death" || playerteam != self.pers["team"] )
	{
		self.clearEnemyCount = 0;
		return;
	}

	if ( self.clearEnemyCount >= 2 && killTime + 200 > getTime() )
	{
		scoreevents::processScoreEvent( "clear_2_attackers", self );
	}
	self.clearEnemyCount = 0;
}
			
function onEndGame( winningTeam )
{
	for ( i = 0; i < level.zones.size; i++ )
	{
		level.zones[i].gameobject gameobjects::allow_use( "none" );
	}
}

function createZoneSpawnInfluencer()
{
		// this affects both teams
	self spawning::create_influencer( "koth_large", self.gameobject.curOrigin, 0 );
	self spawning::create_influencer( "koth_small", self.gameobject.curOrigin, 0 );

	// turn it off for now
	self spawning::enable_influencers(false);
}

function updateCapsPerMinute(lastOwnerTeam)
{
	if ( !isdefined( self.capsPerMinute ) )
	{
		self.numCaps = 0;
		self.capsPerMinute = 0;
	}
	
	// not including neutral flags as part of the boosting prevention
	// to help with false positives at the start
	if ( !isdefined ( lastOwnerTeam ) || lastOwnerTeam == "neutral" )
		return;
		
	self.numCaps++;
	
	minutesPassed = globallogic_utils::getTimePassed() / ( 60 * 1000 );
	
	// players use the actual time played
	if ( IsPlayer( self ) && isdefined(self.timePlayed["total"]) )
		minutesPassed = self.timePlayed["total"] / 60;
		
	self.capsPerMinute = self.numCaps / minutesPassed;
	if ( self.capsPerMinute > self.numCaps )
		self.capsPerMinute = self.numCaps;
}

function isScoreBoosting( player )
{
	if ( !level.rankedMatch )
		return false;
		
	if ( player.capsPerMinute > level.playerCaptureLPM )
		return true;

	return false;
}
