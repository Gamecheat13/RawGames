#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Resistance
	Objective: 	Attacking team capture all the flags by touching them.
	Map ends:	When attacking team captures all the flags, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of owned flags, teammates and 
			enemies at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.
			Optionally, give a spawnpoint a script_linkto to specify which flag it "belongs" to (see Flag Descriptors).

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Flags:
			classname       trigger_radius
			targetname      res_flag_primary or flag_secondary
			Flags that need to be captured to win. Primary flags take time to capture; secondary flags are instant.
		
	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
*/

/*QUAKED mp_res_spawn_axis (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_res_spawn_allies (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_res_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_res_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(GetDvar( "mapname") == "mp_background")
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic_utils::registerRoundSwitchDvar( level.gameType, 1, 0, 9 );
	maps\mp\gametypes\_globallogic_utils::registerTimeLimitDvar( "res", 5, 0, 3 );
	maps\mp\gametypes\_globallogic_utils::registerScoreLimitDvar( "res", 2, 0, 1000 );
	maps\mp\gametypes\_globallogic_utils::registerRoundLimitDvar( "res", 3, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerRoundWinLimitDvar( "res", 0, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerNumLivesDvar( "res", 0, 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onEndGame= ::onEndGame;
	level.gamemodeSpawnDvars = ::res_gamemodeSpawnDvars;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onTimeLimit = ::onTimeLimit;
	level.getTimeLimitDvarValue = ::getTimeLimitDvarValue;

	game["dialog"]["gametype"] = "res_start";
	game["dialog"]["gametype_hardcore"] = "hcres_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";
	level.lastDialogTime = 0;

	level.iconoffset = (0,0,100);

	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "kills", "deaths" , "captures", "defends"); 
}


onPrecacheGameType()
{
	precacheShader( "compass_waypoint_captureneutral" );
	precacheShader( "compass_waypoint_capture" );
	precacheShader( "compass_waypoint_defend" );
	precacheShader( "compass_waypoint_captureneutral_a" );
	precacheShader( "compass_waypoint_capture_a" );
	precacheShader( "compass_waypoint_defend_a" );
	precacheShader( "compass_waypoint_captureneutral_b" );
	precacheShader( "compass_waypoint_capture_b" );
	precacheShader( "compass_waypoint_defend_b" );
	precacheShader( "compass_waypoint_captureneutral_c" );
	precacheShader( "compass_waypoint_capture_c" );
	precacheShader( "compass_waypoint_defend_c" );
	precacheShader( "compass_waypoint_captureneutral_d" );
	precacheShader( "compass_waypoint_capture_d" );
	precacheShader( "compass_waypoint_defend_d" );
	precacheShader( "compass_waypoint_captureneutral_e" );
	precacheShader( "compass_waypoint_capture_e" );
	precacheShader( "compass_waypoint_defend_e" );

	precacheShader( "waypoint_captureneutral" );
	precacheShader( "waypoint_capture" );
	precacheShader( "waypoint_defend" );
	precacheShader( "waypoint_captureneutral_a" );
	precacheShader( "waypoint_capture_a" );
	precacheShader( "waypoint_defend_a" );
	precacheShader( "waypoint_captureneutral_b" );
	precacheShader( "waypoint_capture_b" );
	precacheShader( "waypoint_defend_b" );
	precacheShader( "waypoint_captureneutral_c" );
	precacheShader( "waypoint_capture_c" );
	precacheShader( "waypoint_defend_c" );
	precacheShader( "waypoint_captureneutral_d" );
	precacheShader( "waypoint_capture_d" );
	precacheShader( "waypoint_defend_d" );
	precacheShader( "waypoint_captureneutral_e" );
	precacheShader( "waypoint_capture_e" );
	precacheShader( "waypoint_defend_e" );
	
}


onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		// overtime! team that's ahead in kills gets to defend.
		aheadTeam = getBetterTeam();
		if ( aheadTeam != game["defenders"] )
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		else
		{
			level.halftimeSubCaption = "";
		}
		level.halftimeType = "overtime";
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

getBetterTeam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
		if ( isDefined( team ) && (team == "allies" || team == "axis") )
		{
			kills[ team ] += player.kills;
			deaths[ team ] += player.deaths;
		}
	}
	
	if ( kills["allies"] > kills["axis"] )
		return "allies";
	else if ( kills["axis"] > kills["allies"] )
		return "axis";
	
	// same number of kills

	if ( deaths["allies"] < deaths["axis"] )
		return "allies";
	else if ( deaths["axis"] < deaths["allies"] )
		return "axis";
	
	// same number of deaths
	
	if ( randomint(2) == 0 )
		return "allies";
	return "axis";
}

onStartGameType()
{	
	if ( !isDefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	level.usingExtraTime = false;

	game["strings"]["flags_capped"] = &"MP_TARGET_DESTROYED";

	maps\mp\gametypes\_globallogic_ui::setObjectiveText( game["attackers"], &"OBJECTIVES_RES_ATTACKER" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveText( game["defenders"], &"OBJECTIVES_RES_DEFENDER" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_RES_ATTACKER" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_RES_DEFENDER" );
	}
	else
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_RES_ATTACKER_SCORE" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_RES_DEFENDER_SCORE" );
	}
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( game["attackers"], &"OBJECTIVES_RES_ATTACKER_HINT" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( game["defenders"], &"OBJECTIVES_RES_DEFENDER_HINT" );
	
	level.objectiveHintPrepareHQ = &"MP_CONTROL_HQ";
	level.objectiveHintCaptureHQ = &"MP_CAPTURE_HQ";
	level.objectiveHintDefendHQ = &"MP_DEFEND_HQ";
	precacheString( level.objectiveHintPrepareHQ );
	precacheString( level.objectiveHintCaptureHQ );
	precacheString( level.objectiveHintDefendHQ );
	
	level.flagBaseFXid = [];
	level.flagBaseFXid[ "allies" ] = loadfx( "misc/fx_ui_flagbase_gold_t5" );
	level.flagBaseFXid[ "axis"   ] = loadfx( "misc/fx_ui_flagbase_gold_t5" );

	setClientNameMode("auto_change");

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_res_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_res_spawn_axis_start" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_axis = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_res_spawn_axis" );
	level.spawn_allies = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_res_spawn_allies" );
	level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_res_spawn_axis_start" );
	level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_res_spawn_allies_start" );
	
	level.startPos["allies"] = level.spawn_allies_start[0].origin;
	level.startPos["axis"] = level.spawn_axis_start[0].origin;
	
	allowed[0] = "res";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
		
	hud_createFlagProgressBar();
	
	updateGametypeDvars();
	createTimerDisplay();
	
	thread resFlagsInit();
	
	level.overtime = false;
	overtime = false;

	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
		overtime = true;
		
	if ( overtime )
		setupNextFlag( int(level.resFlags.size / 2) );
	else
		setupNextFlag(0);
	
	level.overtime = overtime;
	
	if ( level.flagActivateDelay )
		updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintPrepareHQ );
	else
		updateObjectiveHintMessages( level.objectiveHintCaptureHQ, level.objectiveHintCaptureHQ );


	//thread updateResScores();
	//level change_res_spawns();
	maps\mp\gametypes\_spawnlogic::clearSpawnPoints();	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_res_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_res_spawn_axis" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
}


onSpawnPlayerUnified()
{
	if ( level.useStartSpawns && !level.inGracePeriod )
	{
		level.useStartSpawns = false;
	}

	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();	
}

onSpawnPlayer(predictedSpawn)
{
	spawnpoint = undefined;
	
	if ( !isdefined( spawnpoint ) )
	{
		if (self.pers["team"] == game["defenders"])
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self spawn(spawnpoint.origin, spawnpoint.angles, "res");
	}
}

onEndGame( winningTeam )
{
	for ( i = 0; i < level.resFlags.size; i++ )
	{
		level.resFlags[i] maps\mp\gametypes\_gameobjects::allowUse( "none" );
	}
}

onRoundEndGame( roundWinner )
{
	if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
		winner = "tie";
	else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	
	return winner;
}

res_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );
	
	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}

onTimeLimit()
{
	if ( level.teamBased )
	{
//		bombZonesLeft = 0;
//		
//		for ( index = 0; index < level.bombZones.size; index++ )
//		{
//			if ( !isDefined( level.bombZones[index].bombExploded ) || !level.bombZones[index].bombExploded )
//				bombZonesLeft++;
//		}
//		if ( bombZonesLeft == 0 )
//		{
//			res_endGame( game["attackers"], game["strings"]["target_destroyed"] );
//		}
//		else 
		{
			res_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
		}
	}
	else
		res_endGame( undefined, game["strings"]["time_limit_reached"] );
}

getTimeLimitDvarValue()
{
	timeLimit = maps\mp\gametypes\_globallogic_utils::getValueInRange( getDvarFloat( level.timeLimitDvar ), level.timeLimitMin, level.timeLimitMax );
	if ( level.usingExtraTime )
	{
		flagCount = 0;
		
		if ( isdefined( level.currentFlag ) )
		{
			flagCount += level.currentFlag.orderIndex;
		}
		return timeLimit + level.extraTime * flagCount;
	}
	return timeLimit;
}

updateGametypeDvars()
{
	level.flagCaptureTime = dvarFloatValue( "flagcapturetime", 30, 0, 100 );
	level.flagDecayTime = dvarFloatValue( "flagdecaytime", 30, 0, 100 );
	level.flagActivateDelay = dvarFloatValue( "flagactivatedelay", 30, 0, 240 );
	level.flaginactiveresettime = dvarFloatValue( "flaginactiveresettime", 10, 0, 60 );
	level.flagInactiveDecay = dvarIntValue( "flaginactivedecay", 1, 0, 1 );
	level.extraTime = dvarFloatValue( "extratime", 2.5, 0, 300 );
	level.flagCaptureGracePeriod = dvarFloatValue( "flagcapturegraceperiod", 999, 0, 3000 );
	level.playerOffensiveMax = dvarFloatValue( "maxPlayerOffensive", 16, 0, 1000 );
	level.playerDefensiveMax = dvarFloatValue( "maxPlayerDefensive", 16, 0, 1000 );
}

resFlagsInit()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;
	
	game["flagmodels"] = [];
	game["flagmodels"]["neutral"] = "mp_flag_neutral";

	if ( game["allies"] == "marines" || game["allies"] == "seals" )
		game["flagmodels"]["allies"] = "mp_flag_allies_1";
	else if ( game["allies"] == "rebels" )
		game["flagmodels"]["allies"] = "mp_flag_allies_3";
	else
		game["flagmodels"]["allies"] = "mp_flag_allies_2";
	
	if ( game["axis"] == "russian" || game["axis"] == "pmc" ) 
		game["flagmodels"]["axis"] = "mp_flag_axis_1";
	else if ( game["axis"] == "tropas" )
		game["flagmodels"]["axis"] = "mp_flag_axis_3";
	else
		game["flagmodels"]["axis"] = "mp_flag_axis_2";
	
	precacheModel( game["flagmodels"]["neutral"] );
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	

	precacheString( &"MP_TIME_EXTENDED" );
	precacheString( &"MP_CAPTURING_FLAG" );
	precacheString( &"MP_LOSING_FLAG" );
	precacheString( &"MP_RES_YOUR_FLAG_WAS_CAPTURED" );
	precacheString( &"MP_RES_ENEMY_FLAG_CAPTURED" );
	precacheString( &"MP_RES_NEUTRAL_FLAG_CAPTURED" );

	precacheString( &"MP_ENEMY_FLAG_CAPTURED_BY" );
	precacheString( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
	precacheString( &"MP_FRIENDLY_FLAG_CAPTURED_BY" );
	
	// purposefully using dom strings here as there is no need to duplicate
	precacheString( &"MP_DOM_FLAG_A_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_B_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_C_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_D_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_E_CAPTURED_BY" );	

	primaryFlags = getEntArray( "res_flag_primary", "targetname" );
	
	if ( (primaryFlags.size) < 2 )
	{
		printLn( "^1Not enough Resistance flags found in level!" );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	
	level.flags = [];
	for ( index = 0; index < primaryFlags.size; index++ )
		level.flags[level.flags.size] = primaryFlags[index];
	
	level.resFlags = [];
	for ( index = 0; index < level.flags.size; index++ )
	{
		trigger = level.flags[index];
		if ( isDefined( trigger.target ) )
		{
			visuals[0] = getEnt( trigger.target, "targetname" );
		}
		else
		{
			visuals[0] = spawn( "script_model", trigger.origin );
			visuals[0].angles = trigger.angles;
		}

		visuals[0] setModel( game["flagmodels"][game["defenders"]] );
			
		resFlag = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals, level.iconoffset );
		resFlag maps\mp\gametypes\_gameobjects::allowUse( "none" );
		resFlag maps\mp\gametypes\_gameobjects::setUseTime( level.flagCaptureTime );
		resFlag maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
		resFlag maps\mp\gametypes\_gameobjects::setDecayTime( level.flagDecayTime );
		label = resFlag maps\mp\gametypes\_gameobjects::getLabel();	
		resFlag.label = label;
		resFlag maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		resFlag.onUse = ::onUse;
		resFlag.onBeginUse = ::onBeginUse;
		resFlag.onUseUpdate = ::onUseUpdate;
		resFlag.onUseClear = ::onUseClear;
		resFlag.onEndUse = ::onEndUse;
		resFlag.claimGracePeriod = level.flagCaptureGracePeriod;
		resFlag.decayProgress = level.flagInactiveDecay;
		
		traceStart = visuals[0].origin + (0,0,32);
		traceEnd = visuals[0].origin + (0,0,-32);
		trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
		upangles = vectorToAngles( trace["normal"] );
		resFlag.baseeffectforward = anglesToForward( upangles );
		resFlag.baseeffectright = anglesToRight( upangles );
		
		resFlag.baseeffectpos = trace["position"];
		
		// legacy spawn code support
		level.flags[index].useObj = resFlag;
		level.flags[index].nearbyspawns = [];
		
		resFlag.levelFlag = level.flags[index];
		
		level.resFlags[level.resFlags.size] = resFlag;
	}
	
	sortFlags();
	
	// level.bestSpawnFlag is used as a last resort when the enemy holds all flags.
	level.bestSpawnFlag = [];
	level.bestSpawnFlag[ "allies" ] = getUnownedFlagNearestStart( "allies", undefined );
	level.bestSpawnFlag[ "axis" ] = getUnownedFlagNearestStart( "axis", level.bestSpawnFlag[ "allies" ] );
	
	for ( index = 0; index < level.resFlags.size; index++ )
	{
		level.resFlags[index] createFlagSpawnInfluencers();
	}
	
	flagSetup();
	
}

sortFlags()
{
	flagOrder["_a"] = 0;
	flagOrder["_b"] = 1;
	flagOrder["_c"] = 2;
	flagOrder["_d"] = 3;
	flagOrder["_e"] = 4;
	
	for ( i = 0; i < level.resFlags.size; i++ )
	{
		 level.resFlags[i].orderIndex = flagOrder[level.resFlags[i].label];
		 assert(isdefined(level.resFlags[i].orderIndex));
	}
	
	for ( i = 1; i < level.resFlags.size; i++ )
	{
   for ( j = 0; j <level.resFlags.size - i; j++ ) 
   {
	   if ( level.resFlags[j].orderIndex > level.resFlags[j+1].orderIndex )
	   {
       temp = level.resFlags[j]; 
		   level.resFlags[j] = level.resFlags[j + 1]; 
		   level.resFlags[j + 1] = temp;
	   }
   }
  }
}

setupNextFlag(flagIndex)
{
	prevFlagIndex = flagIndex - 1;
	
	if ( prevFlagIndex >= 0 )
	{
		thread hideFlag( prevFlagIndex );
	}
	
	if ( flagIndex < level.resFlags.size && !level.overtime )
	{
		thread showFlag( flagIndex );
	}
	else
	{
		hud_hideFlagProgressBar();
	}
}

createTimerDisplay()
{
	flagSpawningInStr = &"MP_HQ_AVAILABLE_IN";
	
	precacheString( flagSpawningInStr );

	level.locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	level.timerDisplay = [];
	level.timerDisplay["allies"] = createServerTimer( "objective", 1.4, "allies" );
	level.timerDisplay["allies"] setPoint( "TOPCENTER", "TOPCENTER", 0, 0 );
	level.timerDisplay["allies"].label = flagSpawningInStr;
	level.timerDisplay["allies"].alpha = 0;
	level.timerDisplay["allies"].archived = false;
	level.timerDisplay["allies"].hideWhenInMenu = true;
	
	level.timerDisplay["axis"  ] = createServerTimer( "objective", 1.4, "axis" );
	level.timerDisplay["axis"  ] setPoint( "TOPCENTER", "TOPCENTER", 0, 0 );
	level.timerDisplay["axis"  ].label = flagSpawningInStr;
	level.timerDisplay["axis"  ].alpha = 0;
	level.timerDisplay["axis"  ].archived = false;
	level.timerDisplay["axis"  ].hideWhenInMenu = true;
	
	thread hideTimerDisplayOnGameEnd( level.timerDisplay["allies"] );
	thread hideTimerDisplayOnGameEnd( level.timerDisplay["axis"  ] );
}

hideTimerDisplayOnGameEnd( timerDisplay )
{
	level waittill("game_ended");
	timerDisplay.alpha = 0;
}

showFlag(flagIndex)
{
	assert( flagIndex < level.resFlags.size );
	resFlag = level.resFlags[flagIndex];
	label = resFlag.label;	
	
	resFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	resFlag maps\mp\gametypes\_gameobjects::setModelVisibility( true );

	level.currentFlag = resFlag;

	if ( level.flagActivateDelay )
	{
		hud_hideFlagProgressBar();
		
		nextObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_next_hq", resFlag.curOrigin + level.iconoffset, "all", "waypoint_targetneutral" );
		nextObjPoint setWayPoint( true, "waypoint_targetneutral" );
		objective_position( level.locationObjID, resFlag.curOrigin );
		objective_icon( level.locationObjID, "waypoint_targetneutral" );
		objective_state( level.locationObjID, "active" );

		updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintDefendHQ );
		
		flagSpawningInStr = &"MP_HQ_AVAILABLE_IN";
		level.timerDisplay["allies"].label = flagSpawningInStr;
		level.timerDisplay["allies"] setTimer( level.flagActivateDelay );
		level.timerDisplay["allies"].alpha = 1;
		level.timerDisplay["axis"  ].label = flagSpawningInStr;
		level.timerDisplay["axis"  ] setTimer( level.flagActivateDelay );
		level.timerDisplay["axis"  ].alpha = 1;

		wait level.flagActivateDelay;

		maps\mp\gametypes\_objpoints::deleteObjPoint( nextObjPoint );
		objective_state( level.locationObjID, "invisible" );
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "hq_online" );

		hud_showFlagProgressBar();
	}
	
	level.timerDisplay["allies"].alpha = 0;
	level.timerDisplay["axis"  ].alpha = 0;
	
	resFlag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" + label );
	resFlag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
	resFlag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" + label );
	resFlag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" + label );
	
	if ( level.overtime )
	{
		resFlag maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		resFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		resFlag maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
		resFlag maps\mp\gametypes\_gameobjects::setDecayTime( level.flagCaptureTime );
	}
	else 
	{
		resFlag maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
	}
	
	resFlag resetFlagBaseEffect();
	
}

hideFlag( flagIndex )
{
	assert( flagIndex < level.resFlags.size );
	resFlag = level.resFlags[flagIndex];
	resFlag maps\mp\gametypes\_gameobjects::allowUse( "none" );
	resFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	resFlag maps\mp\gametypes\_gameobjects::setModelVisibility( false );
	
}

getUnownedFlagNearestStart( team, excludeFlag )
{
	best = undefined;
	bestdistsq = undefined;
	for ( i = 0; i < level.flags.size; i++ )
	{
		flag = level.flags[i];
		
		if ( flag getFlagTeam() != "neutral" )
			continue;
		
		distsq = distanceSquared( flag.origin, level.startPos[team] );
		if ( (!isDefined( excludeFlag ) || flag != excludeFlag) && (!isdefined( best ) || distsq < bestdistsq) )
		{
			bestdistsq = distsq;
			best = flag;
		}
	}
	return best;
}

onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	SetDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 1 );	
	self.didStatusNotify = false;
	if ( ownerTeam == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	if ( ownerTeam == "neutral" )
	{
		
		if( getTime() - level.lastDialogTime > 5000 )
		{
			otherTeam = getOtherTeam( player.pers["team"] );
			statusDialog( "securing"+self.label, player.pers["team"] );
			//statusDialog( "losing"+self.label, otherTeam );
			level.lastDialogTime = getTime();
		}
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
		return;
	}
		
	

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
}


onUseUpdate( team, progress, change )
{
	if ( progress > 0.05 && change && !self.didStatusNotify )
	{
		ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
		if( getTime() - level.lastDialogTime > 10000 )
		{
			statusDialog( "losing"+self.label, ownerTeam );
			statusDialog( "securing"+self.label, team );
			level.lastDialogTime = getTime();
		}

		self.didStatusNotify = true;
	}
			
	hud_setflagProgressBar( progress );
}

onUseClear( )
{	
	hud_setflagProgressBar( 0 );
}

statusDialog( dialog, team )
{
	time = getTime();
	if ( getTime() < level.lastStatus[team] + 6000 )
		return;
		
	thread delayedLeaderDialog( dialog, team );
	level.lastStatus[team] = getTime();	
}


onEndUse( team, player, success )
{
	SetDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 0 );

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
}


resetFlagBaseEffect()
{
	// once these get setup we never change them
	if ( isdefined( self.baseeffect ) )
		return;
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	triggerFx( self.baseeffect );
}

onUse( player )
{
	team = player.pers["team"];
	oldTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	label = self maps\mp\gametypes\_gameobjects::getLabel();
	
	player logString( "flag captured: " + self.label );
	
//	self resetFlagBaseEffect();
	
	setupNextFlag(self.orderIndex + 1);
	
	if ( (self.orderIndex + 1) == level.resFlags.size || level.overtime )
	{
		setGameEndTime( 0 );
		wait 1;
		res_endGame( player.team, game["strings"]["flags_capped"] );
	}
	else
	{
	
		level.useStartSpawns = false;
		
		assert( team != "neutral" );
	
		if( getTimeLimitDvarValue() > 0 && level.extraTime )
		{
			level.usingExtraTime = true;
			if ( !level.hardcoreMode )
				iPrintLn( &"MP_TIME_EXTENDED" );
		}

		string = &"";
		switch ( label ) 
		{
			case "_a":
			string = &"MP_DOM_FLAG_A_CAPTURED_BY";
			break;
			case "_b":
				string = &"MP_DOM_FLAG_B_CAPTURED_BY";
			break;
			case "_c":
				string = &"MP_DOM_FLAG_C_CAPTURED_BY";
			break;
			case "_d":
				string = &"MP_DOM_FLAG_D_CAPTURED_BY";
			break;
			case "_e":
				string = &"MP_DOM_FLAG_E_CAPTURED_BY";
			break;
			default:
			break;
		}
		assert ( string != &"" );
		
		// Copy touch list so there aren't any threading issues
		touchList = [];
		touchKeys = GetArrayKeys( self.touchList[team] );
		for ( i = 0 ; i < touchKeys.size ; i++ )
			touchList[touchKeys[i]] = self.touchList[team][touchKeys[i]];
		thread give_capture_credit( touchList, string );
	
		thread printAndSoundOnEveryone( team, oldTeam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "" );
		
		if ( getTeamFlagCount( team ) == level.flags.size )
		{
	
			statusDialog( "secure_all", team );
			statusDialog( "lost_all", oldTeam );
		}
		else
		{	
			statusDialog( "secured"+self.label, team );
	
			statusDialog( "lost"+self.label, oldTeam );
		}
		
		level.bestSpawnFlag[ oldTeam ] = self.levelFlag;
	
	//	if ( dominated_challenge_check() ) 
	//	{
	//		maps\mp\_challenges::dominated( team );
	//	}
		self update_spawn_influencers( team );
		//level change_res_spawns();
		
	//	[[level._setTeamScore]]( game["attackers"], [[level._getTeamScore]]( game["attackers"] ) + 1 );
	}
}

give_capture_credit( touchList, string )
{
	wait .05;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	//self updateCapsPerMinute();
	
	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player_from_touchlist = touchList[players[i]].player;
		//player_from_touchlist updateCapsPerMinute();
		//if ( !isScoreBoosting( player_from_touchlist, self ) )
		{
			maps\mp\gametypes\_globallogic_score::givePlayerScore( "capture", player_from_touchlist );
			if( isdefined(player_from_touchlist.pers["captures"]) )
			{
				player_from_touchlist.pers["captures"]++;
				player_from_touchlist.captures = player_from_touchlist.pers["captures"];
			}
			player_from_touchlist maps\mp\_medals::positionSecure();
			player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );
	
			if ( isdefined( player_from_touchlist.thisPlayerIsInLastStand ) && player_from_touchlist.thisPlayerIsInLastStand == true )
				player_from_touchlist maps\mp\_medals::heroic();
		}

		level thread maps\mp\_popups::DisplayTeamMessageToAll( string, player_from_touchlist );
	}
}

delayedLeaderDialog( sound, team )
{
	wait .1;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	maps\mp\gametypes\_globallogic_audio::leaderDialog( sound, team );
}

delayedLeaderDialogBothTeams( sound1, team1, sound2, team2 )
{
	wait .1;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	maps\mp\gametypes\_globallogic_audio::leaderDialogBothTeams( sound1, team1, sound2, team2 );
}

//updateResScores()
//{
//	// disable score limit check to allow both axis and allies score to be processed
//	level.endGameOnScoreLimit = false;
//	//level.playingActionMusic = false;			
//
//	while ( !level.gameEnded )
//	{
//		numOwnedFlags = 0;
//		
//		numFlags = getTeamFlagCount( "allies" );
//		numOwnedFlags += numFlags;
//		if ( numFlags )
//			[[level._setTeamScore]]( "allies", [[level._getTeamScore]]( "allies" ) + numFlags );
//
//		numFlags = getTeamFlagCount( "axis" );
//		numOwnedFlags += numFlags;
//		if ( numFlags )
//			[[level._setTeamScore]]( "axis", [[level._getTeamScore]]( "axis" ) + numFlags );
//
//
//		level.endGameOnScoreLimit = true;
//		maps\mp\gametypes\_globallogic::checkScoreLimit();
//		level.endGameOnScoreLimit = false;
//		onScoreCloseMusic ();
//		
//		// end the game if people aren't playing
//		timePassed = maps\mp\gametypes\_globallogic_utils::getTimePassed();
//		if ( (((timePassed / 1000) > 120 && numOwnedFlags < 2) || ((timePassed / 1000) > 300 && numOwnedFlags < 3)) && ( GameModeIsMode( level.GAMEMODE_PUBLIC_MATCH ) ) )
//		{
//			thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["time_limit_reached"] );
//			return;
//		}
//		
//		wait ( 5.0 );
//		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
//	}
//}

onScoreCloseMusic ()
{
	axisScore = [[level._getTeamScore]]( "axis" );
	alliedScore = [[level._getTeamScore]]( "allies" );
	scoreLimit = level.scoreLimit;
	scoreThreshold = scoreLimit * .1;
	scoreDif = abs(axisScore - alliedScore);
	scoreThresholdStart = abs(scoreLimit - scoreThreshold);
	scoreLimitCheck = scoreLimit - 10;
	
	if( !IsDefined( level.playingActionMusic ) )
	    level.playingActionMusic = false;
	
	if (alliedScore > axisScore)
	{
		currentScore = alliedScore;
	}		
	else
	{
		currentScore = axisScore;
	}	
	if( GetDvarint( "debug_music" ) > 0 )
	{
			println ("Music System Resistance - scoreDif " + scoreDif);
			println ("Music System Resistance - axisScore " + axisScore);
			println ("Music System Resistance - alliedScore " + alliedScore);
			println ("Music System Resistance - scoreLimit " + scoreLimit);							
			println ("Music System Resistance - currentScore " + currentScore);
			println ("Music System Resistance - scoreThreshold " + scoreThreshold);								
			println ("Music System Resistance - scoreDif " + scoreDif);
			println ("Music System Resistance - scoreThresholdStart " + scoreThresholdStart);									
	}
	if ( scoreDif <= scoreThreshold && scoreThresholdStart <= currentScore && (level.playingActionMusic != true))
	{
		//play some action music
		thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
		thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();
	}	
	else
	{
		return;
	}	
}	

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( self.touchTriggers.size && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		triggerIds = getArrayKeys( self.touchTriggers );
		ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		team = self.pers["team"];
		
		if ( team == ownerTeam )
		{
			if ( !IsDefined( attacker.res_offends ) )
				attacker.res_offends = 0;
				
			attacker.res_offends++;
			
			if ( level.playerOffensiveMax >= attacker.res_offends )
			{
				if ( !isdefined( sWeapon ) || !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) )
				{
					attacker maps\mp\_medals::offense( sWeapon );
					attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
				}
	
				maps\mp\gametypes\_globallogic_score::givePlayerScore( "assault", attacker );
			}
		}
		else
		{
			if ( !IsDefined( attacker.res_defends ) )
				attacker.res_defends = 0;

			attacker.res_defends++;
			
			if ( level.playerDefensiveMax >= attacker.res_defends )
			{
				if ( !isdefined( sWeapon ) || !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) )
				{
					attacker maps\mp\_medals::defense( sWeapon );
					attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
				}
	
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}
	
				maps\mp\gametypes\_globallogic_score::givePlayerScore( "defend", attacker );
			}
		}
	}
}

getTeamFlagCount( team )
{
	score = 0;
	for (i = 0; i < level.flags.size; i++) 
	{
		if ( level.resFlags[i] maps\mp\gametypes\_gameobjects::getOwnerTeam() == team )
			score++;
	}	
	return score;
}

getFlagTeam()
{
	return self.useObj maps\mp\gametypes\_gameobjects::getOwnerTeam();
}

updateObjectiveHintMessages( alliesObjective, axisObjective )
{
	game["strings"]["objective_hint_allies"] = alliesObjective;
	game["strings"]["objective_hint_axis"  ] = axisObjective;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
		{
			hintText = maps\mp\gametypes\_globallogic_ui::getObjectiveHintText( player.pers["team"] );
			player DisplayGameModeMessage( hintText, "uin_alert_slideout" );
		}
	}
}

//getBoundaryFlags()
//{
//	// get all flags which are adjacent to flags that aren't owned by the same team
//	bflags = [];
////	for (i = 0; i < level.flags.size; i++)
////	{
////		for (j = 0; j < level.flags[i].adjflags.size; j++)
////		{
////			if (level.flags[i].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() != level.flags[i].adjflags[j].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() )
////			{
////				bflags[bflags.size] = level.flags[i];
////				break;
////			}
////		}
////	}
//	
//	return bflags;
//}

//getBoundaryFlagSpawns(team)
//{
//	spawns = [];
//	
//	bflags = getBoundaryFlags();
//	for (i = 0; i < bflags.size; i++)
//	{
//		if (isdefined(team) && bflags[i] getFlagTeam() != team)
//			continue;
//		
//		for (j = 0; j < bflags[i].nearbyspawns.size; j++)
//			spawns[spawns.size] = bflags[i].nearbyspawns[j];
//	}
//	
//	return spawns;
//}

//getSpawnsBoundingFlag( avoidflag )
//{
//	spawns = [];
//
//	for (i = 0; i < level.flags.size; i++)
//	{
//		flag = level.flags[i];
//		if ( flag == avoidflag )
//			continue;
//		
//		isbounding = false;
//		for (j = 0; j < flag.adjflags.size; j++)
//		{
//			if ( flag.adjflags[j] == avoidflag )
//			{
//				isbounding = true;
//				break;
//			}
//		}
//		
//		if ( !isbounding )
//			continue;
//		
//		for (j = 0; j < flag.nearbyspawns.size; j++)
//			spawns[spawns.size] = flag.nearbyspawns[j];
//	}
//	
//	return spawns;
//}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team, or that are adjacent to flags owned by the given team.
//getOwnedAndBoundingFlagSpawns(team)
//{
//	spawns = [];
//
//	for (i = 0; i < level.flags.size; i++)
//	{
//		if ( level.flags[i] getFlagTeam() == team )
//		{
//			// add spawns near this flag
//			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
//				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
//		}
//		else
//		{
//			for (j = 0; j < level.flags[i].adjflags.size; j++)
//			{
//				if ( level.flags[i].adjflags[j] getFlagTeam() == team )
//				{
//					// add spawns near this flag
//					for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
//						spawns[spawns.size] = level.flags[i].nearbyspawns[s];
//					break;
//				}
//			}
//		}
//	}
//	
//	return spawns;
//}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team
//getOwnedFlagSpawns(team)
//{
//	spawns = [];
//
//	for (i = 0; i < level.flags.size; i++)
//	{
//		if ( level.flags[i] getFlagTeam() == team )
//		{
//			// add spawns near this flag
//			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
//				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
//		}
//	}
//	
//	return spawns;
//}

flagSetup()
{
//	maperrors = [];
//	descriptorsByLinkname = [];
//
//	// (find each flag_descriptor object)
//	descriptors = getentarray("flag_descriptor", "targetname");
//	
//	flags = level.flags;
//	
//	for (i = 0; i < level.resFlags.size; i++)
//	{
//		closestdist = undefined;
//		closestdesc = undefined;
//		for (j = 0; j < descriptors.size; j++)
//		{
//			dist = distance(flags[i].origin, descriptors[j].origin);
//			if (!isdefined(closestdist) || dist < closestdist) {
//				closestdist = dist;
//				closestdesc = descriptors[j];
//			}
//		}
//		
//		if (!isdefined(closestdesc)) 
//		{
//			maperrors[maperrors.size] = "there is no flag_descriptor in the map! see explanation in dom.gsc";
//			break;
//		}
//		if (isdefined(closestdesc.flag)) 
//		{
//			maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + closestdesc.script_linkname + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
//			continue;
//		}
//		flags[i].descriptor = closestdesc;
//		closestdesc.flag = flags[i];
//		descriptorsByLinkname[closestdesc.script_linkname] = closestdesc;
//	}
//	
//	if (maperrors.size == 0)
//	{
//		// find adjacent flags
//		for (i = 0; i < flags.size; i++)
//		{
//			if (isdefined(flags[i].descriptor.script_linkto))
//				adjdescs = strtok(flags[i].descriptor.script_linkto, " ");
//			else
//				adjdescs = [];
//			for (j = 0; j < adjdescs.size; j++)
//			{
//				otherdesc = descriptorsByLinkname[adjdescs[j]];
//				if (!isdefined(otherdesc) || otherdesc.targetname != "flag_descriptor") {
//					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to \"" + adjdescs[j] + "\" which does not exist as a script_linkname of any other entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
//					continue;
//				}
//				adjflag = otherdesc.flag;
//				if (adjflag == flags[i]) {
//					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to itself";
//					continue;
//				}
//				flags[i].adjflags[flags[i].adjflags.size] = adjflag;
//			}
//		}
//	}
//	
//	// assign each spawnpoint to nearest flag
//	spawnpoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_res_spawn" );
//	for (i = 0; i < spawnpoints.size; i++)
//	{
//		if (isdefined(spawnpoints[i].script_linkto)) {
//			desc = descriptorsByLinkname[spawnpoints[i].script_linkto];
//			if (!isdefined(desc) || desc.targetname != "flag_descriptor") {
//				maperrors[maperrors.size] = "Spawnpoint at " + spawnpoints[i].origin + "\" linked to \"" + spawnpoints[i].script_linkto + "\" which does not exist as a script_linkname of any entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
//				continue;
//			}
//			nearestflag = desc.flag;
//		}
//		else {
//			nearestflag = undefined;
//			nearestdist = undefined;
//			for (j = 0; j < flags.size; j++)
//			{
//				dist = distancesquared(flags[j].origin, spawnpoints[i].origin);
//				if (!isdefined(nearestflag) || dist < nearestdist)
//				{
//					nearestflag = flags[j];
//					nearestdist = dist;
//				}
//			}
//		}
//		nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
//	}
//	
//	if (maperrors.size > 0)
//	{
//		println("^1------------ Map Errors ------------");
//		for(i = 0; i < maperrors.size; i++)
//			println(maperrors[i]);
//		println("^1------------------------------------");
//		
//		maps\mp\_utility::error("Map errors. See above");
//		maps\mp\gametypes\_callbacksetup::AbortLevel();
//		
//		return;
//	}
}

createFlagSpawnInfluencers()
{
	ss = level.spawnsystem;

	for (flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if ( level.resFlags[flag_index] == self )
			break;
	}
	
	ABC = [];
	ABC[0] = "A";
	ABC[1] = "B";
	ABC[2] = "C";
	ABC[3] = "D";
	ABC[4] = "E";
	
	// Resistance: owned flag influencers
	self.owned_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ss.res_owned_flag_influencer_radius[flag_index],
							 ss.res_owned_flag_influencer_score[flag_index],
							 0,
							 "res_owned_flag_" + ABC[flag_index] + ",r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ss.res_owned_flag_influencer_score_curve) );
	
	// Resistance: un-owned inner flag influencers
	self.neutral_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ss.res_unowned_flag_influencer_radius,
							 ss.res_unowned_flag_influencer_score,
							 0,
							 "res_unowned_flag,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ss.res_owned_flag_influencer_score_curve) );
		
	// Resistance: enemy flag influencers
	self.enemy_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ss.res_enemy_flag_influencer_radius[flag_index],
							 ss.res_enemy_flag_influencer_score[flag_index],
							 0,
							 "res_enemy_flag_" + ABC[flag_index] + ",r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ss.res_enemy_flag_influencer_score_curve) );
	
	
	// default it to neutral
	self update_spawn_influencers("neutral");
}

update_spawn_influencers( team )
{
	assert(isdefined(self.neutral_flag_influencer));
	assert(isdefined(self.owned_flag_influencer));
	assert(isdefined(self.enemy_flag_influencer));
	
	if ( team == "neutral" )
	{
		enableinfluencer(self.neutral_flag_influencer, true);
		enableinfluencer(self.owned_flag_influencer, false);
		enableinfluencer(self.enemy_flag_influencer, false);
	}
	else
	{
		enableinfluencer(self.neutral_flag_influencer, false);
		enableinfluencer(self.owned_flag_influencer, true);
		enableinfluencer(self.enemy_flag_influencer, true);
	}
	
	if ( team == "allies" )
	{
		setinfluencerteammask(self.owned_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_ALLIES );
		setinfluencerteammask(self.enemy_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_AXIS );
	}
	else
	{
		setinfluencerteammask(self.owned_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_AXIS );
		setinfluencerteammask(self.enemy_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_ALLIES );
	}
	
}

res_gamemodeSpawnDvars()
{
	ss = level.spawnsystem;

	// Resistance: owned flag influencers
	ss.res_owned_flag_influencer_score = [];
	ss.res_owned_flag_influencer_radius = [];
	
	ss.res_owned_flag_influencer_score[0] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_A_influencer_score", "10");
	ss.res_owned_flag_influencer_radius[0] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_A_influencer_radius", "" + 15.0*get_player_height());
	ss.res_owned_flag_influencer_score[1] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_B_influencer_score", "10");
	ss.res_owned_flag_influencer_radius[1] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_B_influencer_radius", "" + 15.0*get_player_height());
	ss.res_owned_flag_influencer_score[2] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_C_influencer_score", "10");
	ss.res_owned_flag_influencer_radius[2] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_C_influencer_radius", "" + 15.0*get_player_height());
	ss.res_owned_flag_influencer_score[3] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_D_influencer_score", "10");
	ss.res_owned_flag_influencer_radius[3] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_D_influencer_radius", "" + 15.0*get_player_height());
	ss.res_owned_flag_influencer_score[4] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_E_influencer_score", "10");
	ss.res_owned_flag_influencer_radius[4] = set_dvar_float_if_unset("scr_spawn_res_owned_flag_E_influencer_radius", "" + 15.0*get_player_height());
	
	ss.res_owned_flag_influencer_score_curve = set_dvar_if_unset("scr_spawn_res_owned_flag_influencer_score_curve", "constant");
	
	// Resistance: enemy flag influencers
	ss.res_enemy_flag_influencer_score = [];
	ss.res_enemy_flag_influencer_radius = [];
	
	ss.res_enemy_flag_influencer_score[0] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_A_influencer_score", "-10");
	ss.res_enemy_flag_influencer_radius[0] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_A_influencer_radius", "" + 15.0*get_player_height());
	ss.res_enemy_flag_influencer_score[1] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_B_influencer_score", "-10");
	ss.res_enemy_flag_influencer_radius[1] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_B_influencer_radius", "" + 15.0*get_player_height());
	ss.res_enemy_flag_influencer_score[2] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_C_influencer_score", "-10");
	ss.res_enemy_flag_influencer_radius[2] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_C_influencer_radius", "" + 15.0*get_player_height());
	ss.res_enemy_flag_influencer_score[3] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_D_influencer_score", "-10");
	ss.res_enemy_flag_influencer_radius[3] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_D_influencer_radius", "" + 15.0*get_player_height());
	ss.res_enemy_flag_influencer_score[4] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_E_influencer_score", "-10");
	ss.res_enemy_flag_influencer_radius[4] = set_dvar_float_if_unset("scr_spawn_res_enemy_flag_E_influencer_radius", "" + 15.0*get_player_height());

	ss.res_enemy_flag_influencer_score_curve = set_dvar_if_unset("scr_spawn_res_enemy_flag_influencer_score_curve", "constant");
	
	// Resistance: un-owned inner flag influencers
	ss.res_unowned_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_res_unowned_flag_influencer_score", "-500");
	ss.res_unowned_flag_influencer_score_curve =	set_dvar_if_unset("scr_spawn_res_unowned_flag_influencer_score_curve", "constant");
	ss.res_unowned_flag_influencer_radius =	set_dvar_float_if_unset("scr_spawn_res_unowned_flag_influencer_radius", "" + 15.0*get_player_height());
}

hud_createFlagProgressBar()
{
	//level.captureProgressHUD = createPrimaryProgressBar();
	level.attackersCaptureProgressHUD = createTeamProgressBar( game["attackers"] );
	level.defendersCaptureProgressHUD = createTeamProgressBar( game["defenders"] );
	
	hud_hideFlagProgressBar();
}

hud_hideFlagProgressBar()
{
	hud_setflagProgressBar( 0 );
	
	level.attackersCaptureProgressHUD hideElem();
	level.defendersCaptureProgressHUD hideElem();
}

hud_showFlagProgressBar()
{
	level.attackersCaptureProgressHUD showElem();
	level.defendersCaptureProgressHUD showElem();
}

hud_setflagProgressBar( value )
{
	if ( value < 0.0 )
		value = 0.0;
	if ( value > 1.0 )
	  value = 1.0;
		
	level.attackersCaptureProgressHUD updateBar(value);
	level.defendersCaptureProgressHUD updateBar(value);
}
