#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
/*
	Bloodshed
	Objective: 	Capture flags to gain points
	Map ends:	When one team reaches the score limit, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirementss
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
*/

/*QUAKED mp_tdm_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if ( isUsingMatchRulesData() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();		
	}
	else
	{
		registerRoundSwitchDvar( level.gameType, 0, 0, 9 );
		registerTimeLimitDvar( level.gameType, 10 );
		registerScoreLimitDvar( level.gameType, 10 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	game["dialog"]["gametype"] = "tm_death";
	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	
	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_bloodshed_roundswitch", 0 );
	registerRoundSwitchDvar( "bloodshed", 0, 0, 9 );
	SetDynamicDvar( "scr_bloodshed_roundlimit", 1 );
	registerRoundLimitDvar( "bloodshed", 1 );		
	SetDynamicDvar( "scr_bloodshed_winlimit", 1 );
	registerWinLimitDvar( "bloodshed", 1 );			
	SetDynamicDvar( "scr_bloodshed_halftime", 0 );
	registerHalfTimeDvar( "bloodshed", 0 );
		
	SetDynamicDvar( "scr_bloodshed_promode", 0 );	
}


onStartGameType()
{
	setClientNameMode("auto_change");

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	setObjectiveText( "allies", &"OBJECTIVES_BLOODSHED" );
	setObjectiveText( "axis", &"OBJECTIVES_BLOODSHED" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_BLOODSHED" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_BLOODSHED" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_BLOODSHED_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_BLOODSHED_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_BLOODSHED_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_BLOODSHED_HINT" );
			
	initSpawns();
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 10 );

	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 150 );
	maps\mp\gametypes\_rank::registerScoreInfo( "return", 150 );

	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend_assist", 10 );

	maps\mp\gametypes\_rank::registerScoreInfo( "assault", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault_assist", 10 );
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread bloodshed();
}
	
initSpawns()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}


getSpawnPoint()
{
	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnscoring::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;
}


onNormalDeath( victim, attacker, lifeId )
{
	if( !isdefined( level.capturePoint[ attacker.team ] ) || isdefined( level.capturePoint[ attacker.team ] ) && level.capturePoint[attacker.team ].inPlay == false )
	{
		//TODO: if the victim origin is not valid and we are not going to spawn a flag don't give extra points to the attacker.
		thread spawnObjectivePoint( victim, attacker );
		attacker thread maps\mp\gametypes\_rank::giveRankXP( "firstblood", maps\mp\gametypes\_rank::getScoreInfoValue( "firstblood" ) );
		maps\mp\gametypes\_gamescore::givePlayerScore( "firstblood", attacker );
	}
	else
	{
		attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) );
		maps\mp\gametypes\_gamescore::givePlayerScore( "kill", attacker );
	}
}


onTimeLimit()
{
	level.finalKillCam_winner = "none";
	if ( game["status"] == "overtime" )
	{
		winner = "forfeit";
	}
	else if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
	{
		winner = "overtime";
	}
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
	{
		level.finalKillCam_winner = "axis";
		winner = "axis";
	}
	else
	{
		level.finalKillCam_winner = "allies";
		winner = "allies";
	}
	
	thread maps\mp\gametypes\_gamelogic::endGame( winner, game["strings"]["time_limit_reached"] );
}

bloodshed()
{
	SetDvarIfUninitialized( "scr_bloodshed_reset_timer", 10 );

	level.capturePoint = [];
		
	game["flagmodels"] = [];
	game["flagmodels"]["neutral"] = "prop_flag_neutral";

	game["flagmodels"]["allies"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
	game["flagmodels"]["axis"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
	
	level.icon2D["allies"] = maps\mp\gametypes\_teams::getTeamFlagIcon( "allies" );
	level.icon2D["axis"] = maps\mp\gametypes\_teams::getTeamFlagIcon( "axis" );
	
	precacheModel( game["flagmodels"]["neutral"] );
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	
	precacheShader( level.icon2D["axis"] );
	precacheShader( level.icon2D["allies"] );
	

	
	precacheString( &"MP_SECURING_POSITION" );

	//thread displayHUD( "axis" );	
	//thread displayHUD( "allies" );	
	level.flag_hud_icons = [];
	level.flag_hud_icons[ "axis" ] = createFlagIcon( "axis" );
	level.flag_hud_icons[ "allies" ] = createFlagIcon( "allies" );
	
	gameFlagWait( "prematch_done" );
	
	//thread leaderDialogBothTeams( "td_hint", "axis", "td_hint", "allies" );
	
	//thread displaySeverString( "axis", 5, "Firstblood Drops a Flag", -60 );
	//thread displaySeverString( "allies", 5, "Firstblood Drops a Flag", -60 );
}

//----Objective Points ----//

spawnObjectivePoint( victim, attacker )
{
	team = attacker.team;

	flag_origin = setOriginOnGround( victim.origin );
	
	if( !IsDefined( flag_origin ) )
	{
		return;
	}
	
	capture_point = undefined;
	
	//If the capture point was already created, just move it to the new location.
	if( isdefined( level.capturePoint[ team ] ) )
	{
		capture_point = capturePointSetPosition( team, flag_origin );
	}
	//Otherwise, create the capture point (we only create the capture point once).
	else
	{
		capture_point = capturePointCreate( team, flag_origin );
	}
	
	level notify( "bloodshed_flag_dropped" );
	
	//thread displaySeverString( victim.team, 5, "Your flag has been dropped", -90 );
	//thread displaySeverString( victim.team, 5, "Defend it", -65 );
	//thread displaySeverString( attacker.team, 5, "Enemy flag has been dropped", -90 );
	//thread displaySeverString( attacker.team, 5, "Capture it", -65 );
	
	thread leaderDialog( "flag_dropped", victim.team, "status" );
	thread leaderDialog( "enemy_flag_dropped", attacker.team, "status" );
	
	thread playSoundOnPlayers(  "mp_last_stand", victim.team );
	
	level.flag_hud_icons[ victim.team ].alpha = 0;//turn off the hud flag for the team who just dropped the flag

	capture_point.inPlay = true;
	
	capture_point maps\mp\gametypes\_gameobjects::allowUse( "any" );
	//capture_point maps\mp\gametypes\_gameobjects::setTeamUseTime( "friendly", 10.0 );
	//capture_point maps\mp\gametypes\_gameobjects::setTeamUseTime( "enemy", 10.0 );
	
	//label = domFlag maps\mp\gametypes\_gameobjects::getLabel();
	//domFlag.label = label;
	capture_point maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_captureneutral");
	capture_point maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_captureneutral" );
	capture_point maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_defend");
	capture_point maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend");
	capture_point maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

	
	//TODO: need to spawn the fx
	traceStart = capture_point.visuals[0].origin + (0,0,32);
	traceEnd = capture_point.visuals[0].origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );

	upangles = vectorToAngles( trace["normal"] );
	capture_point.baseeffectforward = anglesToForward( upangles );
	capture_point.baseeffectright = anglesToRight( upangles );
	
	capture_point.baseeffectpos = trace["position"];
}

setOriginOnGround( origin )
{
	traceStart = origin + (0,0,32);
	traceEnd = origin + (0,0,-128);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
	if( trace[ "fraction" ] == 1 )
	{
		//trace ended without hitting anything
		return undefined;
	}
	else
	{
		return trace["position"];
	}
}


onUse( player )
{
	team = player.pers["team"];
	oldTeam = getOtherTeam( team );
	self.captureTime = getTime();
	
	//If the user of the flag is on the same team (the user is about to score a point for their team).
	if (self.ownerTeam == player.pers["team"])
	{
		//self resetFlagBaseEffect();
		thread playSoundOnPlayers( "mp_enemy_obj_captured", team );
		thread playSoundOnPlayers( "mp_lose_flag", oldteam );
		
		thread leaderDialog( "enemy_flag_captured", team, "status" );
		thread leaderDialog( "flag_captured", oldTeam, "status" );
		
		player notify( "objective", "captured" );
		self thread giveFlagCaptureXP( self.touchList[team] );
		
		score = 1;
		player maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( player.pers["team"], score );
	}
	//Else the user of the flag is about to reset the flag for their team.
	else
	{
		thread playSoundOnPlayers( "mp_obj_returned", team );
		thread playSoundOnPlayers( "mp_obj_returned", oldteam );
		
		thread leaderDialog( "flag_returned", team, "status" );
		thread leaderDialog( "enemy_flag_returned", oldTeam, "status" );
		
		self thread giveFlagResetXP( self.touchList[team] );
	}
	self capturePointReset();
}

onBeginUse( player )
{
	team = player.pers["team"];
	
	//If the user of the flag is on the same team (the user is starting to score a point for their team).
	if (self.ownerTeam == player.pers["team"])
	{
		//TODO:check touchlist - check if it's already set
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_capture" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_capture" );
		
		//Warning to the other team that the enemy is about to score.
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_defend_yellow" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend_yellow" );
		
		//"Your team is taking the enemy flag."
		thread leaderDialog( "capturing_a", team, "status" );
		//"The enemy is taking your flag."
		thread leaderDialog( "enemy_taking_b", getOtherTeam(team ), "status" );
	}
	//Else the user of the flag is starting to reset the flag for their team.
	else
	{
		//TODO:check touchlist - check if it's already set
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_capture" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_capture" );
		
		//Showing that your teammates are starting to reset your flag.
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_defend_flag" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend_flag" );
		
		//"Your team is resetting its own flag."
		thread leaderDialog( "securing_b", team, "status" );
		//"Your enemies are resetting their team's flag."
		thread leaderDialog( "losing_a", getOtherTeam(team ), "status" );
	}
}

onUseUpdate( team, progress, change )
{
	
}

onEndUse( team, player, success )
{
	//TODO:make sure no one else is using before swapping
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_captureneutral" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_captureneutral" );
	
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_defend");
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend");
	
	//self.visuals[0] setModel( game["flagmodels"][team] );
}

capturePointCreate( team, flag_origin )
{
	//used to create the first two flags in the match
	trigger = spawn( "trigger_radius", flag_origin, 0, 128, 128 );
	visuals[0] = spawn( "script_model", trigger.origin );
	visuals[0].angles = trigger.angles;

	visuals[0] setModel( game["flagmodels"][ team ] );

	capture_point = maps\mp\gametypes\_gameobjects::createUseObject( team, trigger, visuals, (0,0,100) );
	capture_point maps\mp\gametypes\_gameobjects::setUseTime( 10.0 );
	//capture_point maps\mp\gametypes\_gameobjects::setUseText( &"MP_SECURING_POSITION" );		//See below: now using separate Use Text for each team.
	capture_point maps\mp\gametypes\_gameobjects::setTeamUseText( "enemy", &"MP_RETURNING_FLAG" );
	capture_point maps\mp\gametypes\_gameobjects::setTeamUseText( "friendly", &"MP_CAPTURING_OBJECTIVE" );
	capture_point.onUse = ::onUse;
	capture_point.onBeginUse = ::onBeginUse;
	capture_point.onUseUpdate = ::onUseUpdate;
	capture_point.onEndUse = ::onEndUse;
	level.capturePoint[ team ] = capture_point;
	
	return capture_point;
}

capturePointSetPosition( team, flag_origin )
{
	capture_point = level.capturePoint[ team ];
	
	capture_point.visuals[0] show();
	capture_point.curOrigin = flag_origin;
	capture_point.trigger.origin = flag_origin;
	capture_point.visuals[0].origin = flag_origin;
	foreach( point in capture_point.objpoints )
	{
		point maps\mp\gametypes\_objpoints::updateOrigin( ( flag_origin[0], flag_origin[1], flag_origin[2] + 100 )  );
	}
	//update compass doesn't update the position unless it's a carryobj
	objective_position( capture_point.objIDAxis, flag_origin );
	objective_position( capture_point.objIDAllies, flag_origin );
	
	return capture_point;
}
	
capturePointReset()
{
	level.capturePointResetTimer = getDvarInt( "scr_bloodshed_reset_timer", 10 );
	
	//just moving the capture point since we should only ever have 2 in the game.
	self.visuals[0] hide();
	self.curOrigin = (0,0,1000);
	self.trigger.origin = (0,0,1000);
	self.visuals[0].origin = (0,0,1000);
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );		
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	
	//displayStartTimer( "match_starting_in", 5 );
	thread displaySeverString( self.ownerteam, level.capturePointResetTimer, "Next Kill Drops Enemy Flag in:", -75, true );
	thread displaySeverString( getOtherTeam( self.ownerteam ) , level.capturePointResetTimer, "Next Death Drops Your Flag in:", -50, true );
	
	
	
	level.flag_hud_icons[ getOtherTeam( self.ownerteam ) ].alpha = 1;//put the hud icon up on the team who will spawn a flag on death.
	thread displayHUDFlagTimer( level.capturePointResetTimer, getOtherTeam( self.ownerteam ) );
	wait level.capturePointResetTimer;
	thread playSoundOnPlayers( "mp_war_objective_taken", self.ownerteam );
	thread playSoundOnPlayers( "mp_war_objective_lost", getOtherTeam( self.ownerteam ) );
	
	

	                          
	self.inPlay = false;
	// team flag on next bloodshed
}


//----SCORING----//
giveFlagCaptureXP( touchList )
{
	level endon ( "game_ended" );
	
	players = getArrayKeys( touchList );
	for ( index = 0; index < players.size; index++ )
	{
		player = touchList[players[index]].player;
		player thread maps\mp\gametypes\_hud_message::SplashNotify( "capture", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
		player thread updateCPM();
		player thread maps\mp\gametypes\_rank::giveRankXP( "capture", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) * player getCapXPScale() );
		printLn( maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) * player getCapXPScale() );
		maps\mp\gametypes\_gamescore::givePlayerScore( "capture", player );
		
		//player incPlayerStat( "pointscaptured", 1 );
		//player incPersStat( "captures", 1 );
		player maps\mp\gametypes\_persistence::statSetChild( "round", "captures", player.pers["captures"] );
		
		if ( player != self )
			player notify( "objective", "assistedCapture" );
	}
	
	player = self maps\mp\gametypes\_gameobjects::getEarliestClaimPlayer();

	//level thread teamPlayerCardSplash( "callout_securedposition" + self.label, player );

	player thread maps\mp\_matchdata::logGameEvent( "capture", player.origin );
}


//See onPickup() in ctf.gsc for reference on using SplashNotify and player thread [[level.onXPEvent]]( "return" ).
giveFlagResetXP( touchlist )
{
	level endon ( "game_ended" );
	
	players = getArrayKeys( touchList );
	for ( index = 0; index < players.size; index++ )
	{
		player = touchList[players[index]].player;
		player thread maps\mp\gametypes\_hud_message::SplashNotify( "flagreturn", maps\mp\gametypes\_rank::getScoreInfoValue( "return" ) );
		player thread updateCPM();
		player thread maps\mp\gametypes\_rank::giveRankXP( "return", maps\mp\gametypes\_rank::getScoreInfoValue( "return" ) * player getCapXPScale() );
		printLn( maps\mp\gametypes\_rank::getScoreInfoValue( "return" ) * player getCapXPScale() );
		maps\mp\gametypes\_gamescore::givePlayerScore( "return", player );
		
		//player incPlayerStat( "pointscaptured", 1 );
		//player incPersStat( "captures", 1 );
		player maps\mp\gametypes\_persistence::statSetChild( "round", "captures", player.pers["captures"] );
		
		if ( player != self )
			player notify( "objective", "assistedCapture" );
	}
	
	player = self maps\mp\gametypes\_gameobjects::getEarliestClaimPlayer();

	//level thread teamPlayerCardSplash( "callout_securedposition" + self.label, player );

	player thread maps\mp\_matchdata::logGameEvent( "return", player.origin );
}


//Caps per minute
updateCPM()
{
	if ( !isDefined( self.CPM ) )
	{
		self.numCaps = 0;
		self.CPM = 0;
	}
	
	self.numCaps++;
	
	if ( getMinutesPassed() < 1 )
		return;
		
	self.CPM = self.numCaps / getMinutesPassed();
}

getCapXPScale()
{
	if ( self.CPM < 4 )
		return 1;
	else
		return 0.25;
}


//---- UI ----//


displayStartTimer_Internal( countTime, matchStartTimer )
{
	waittillframeend; // wait till cleanup of previous start timer if multiple happen at once
	//visionSetNaked( "mpIntro", 0 );
	
	while ( countTime > 0 && !level.gameEnded )
	{
		matchStartTimer thread maps\mp\gametypes\_hud::fontPulse( level );
		wait ( matchStartTimer.inFrames * 0.05 );
		matchStartTimer setValue( countTime );
		//if ( countTime == 0 )
			//visionSetNaked( "", 0 );	// Disable override
		countTime--;
		wait ( 1 - (matchStartTimer.inFrames * 0.05) );
	}
}

displayStartTimer( duration, offset, team )
{

	matchStartTimer = createServerFontString( "hudbig", .75, team );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, offset + 15 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer maps\mp\gametypes\_hud::fontPulseInit();

	countTime = int( duration );
	
	displayStartTimer_Internal( countTime, matchStartTimer );

	matchStartTimer destroyElem();
}

displaySeverString( team, display_time, text, offset, timer )
{
	display = createServerFontString( "hudbig", .75, team );
	display setPoint( "CENTER", "CENTER", 0, offset );
	display.sort = 1001;
	display.color = (1,1,1);
	display.foreground = false;
	display.hidewheninmenu = true;
	if( isdefined( timer ) )
	{
		thread displayStartTimer( display_time, offset, team );
	}
	display settext( text  );
	
	wait display_time;
	//level common_scripts\utility::waittill_any_timeout( display_time, "bloodshed_flag_dropped" );
	
	display destroyElem();
}

displayHUD( team )
{
	//
	
	//Players team
	display = createServerFontString( "objective", 1, team );
	display setPoint( "LEFT", "LEFT", 0, -20 );
	display.sort = 1001;
	display.color = (1,1,1);
	display.foreground = false;
	display.hidewheninmenu = true;
	display settext( "Enemy Flag:" );
	
	//Enemies team flag
	display2 = createServerFontString( "objective", 1, team );
	display2 setPoint( "LEFT", "LEFT", 0, 0 );
	display2.sort = 1001;
	display2.color = (1,1,1);
	display2.foreground = false;
	display2.hidewheninmenu = true;
	display2 settext( "Your Flag:"  );
	
}

createFlagIcon( team )
{
	icon = level.icon2D[ team ];
	

	if ( level.splitscreen )
	{
		flag_hud_icon = createServerIcon( icon, 33, 33, team );
		flag_hud_icon setPoint( "TOP LEFT", "TOP LEFT", -50, -78 );
	}
	else
	{
		flag_hud_icon = createServerIcon( icon, 50, 50, team );
		flag_hud_icon setPoint( "TOP LEFT", "TOP LEFT", 100, 10 );
	}		
	
	flag_hud_icon.hidewheninmenu = true;
	//self thread hideCarryIconOnGameEnd();		
	//displayHUDFlagTimer( 5, team );

	return flag_hud_icon;
}

playTickingSound( count, team )
{	
	for( i = 0; i < count; i++ )
	{
		if( i >= count - 5 )
		{
			//only play if there is less than 5 seconds left
			thread playSoundOnPlayers( "ui_mp_suitcasebomb_timer", team );
		}
		
		wait 1;
	}
}

displayHUDFlagTimer( duration, team )
{
	matchStartTimer = createServerFontString( "objective", 2, team );
	//matchStartTimer setPoint( "CENTER", "CENTER", 0, offset + 15 );
	matchStartTimer setPoint( "TOP LEFT", "TOP LEFT", 120, 18 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,0,0);
	matchStartTimer.glowcolor = ( 0,0,0 );
	matchStartTimer.glowalpha = 1;
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer maps\mp\gametypes\_hud::fontPulseInit();

	countTime = int( duration );
	
	//matchStartTimer setValue( duration );
	thread playTickingSound( countTime, team  );
	displayStartTimer_Internal( countTime, matchStartTimer );

	matchStartTimer destroyElem();
}