#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Bot Wars
	Objective: 	Capture all the flags by touching them
	Map ends:	When one team captures all the flags, or time limit is reached
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
			targetname      flag_primary or flag_secondary
			Flags that need to be captured to win. Primary flags take time to capture; secondary flags are instant.
		
		Flag Descriptors:
			classname       script_origin
			targetname      flag_descriptor
			Place one flag descriptor close to each flag. Use the script_linkname and script_linkto properties to say which flags
			it can be considered "adjacent" to in the level. For instance, if players have a primary path from flag1 to flag2, and 
			from flag2 to flag3, flag2 would have a flag_descriptor with these properties:
			script_linkname flag2
			script_linkto flag1 flag3
			
			Set scr_domdebug to 1 to see flag connections and what spawnpoints are considered connected to each flag.

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

/*QUAKED mp_dom_spawn (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_a (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_b (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_c (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_dom_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

#define DEFEND	0
#define CAPTURE 1
#define SCOREBOARD_MAX_PLAYERS	4

main()
{
	if(GetDvar( "mapname") == "mp_background")
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 1000 );
	registerRoundLimit( 0, 10 );
	registerRoundWinLimit( 0, 10 );
	registerRoundSwitch( 0, 9 );
	registerNumLives( 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.scoreRoundBased = ( GetGametypeSetting( "roundscorecarry" ) == false );
	level.teamBased = false;
	level.overrideTeamScore = true;
	level.overridePlayerScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onEndGame= ::onEndGame;
	level.gamemodeSpawnDvars = ::dom_gamemodeSpawnDvars;
	level.onRoundEndGame = ::onRoundEndGame;

	game["dialog"]["gametype"] = "dom_start";
	game["dialog"]["gametype_hardcore"] = "hcdom_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";
	level.lastDialogTime = 0;
		
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths" , "captures", "defends"); 
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


onStartGameType()
{	
	setObjectiveText( "allies", &"OBJECTIVES_DOM" );
	setObjectiveText( "axis", &"OBJECTIVES_DOM" );
	
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DOM" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DOM" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DOM_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DOM_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_DOM_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_DOM_HINT" );
	
	level.flagBaseFXid = [];
	level.flagBaseFXid[ "allies" ] = loadfx( "misc/fx_ui_flagbase_gold_t5" );
	level.flagBaseFXid[ "axis"   ] = loadfx( "misc/fx_ui_flagbase_gold_t5" );

	setClientNameMode("auto_change");

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dom_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dom_spawn_axis_start" );
	
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_all = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn" );
	level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_axis_start" );
	level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_allies_start" );
	
	flagSpawns = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_flag_a" );
	//assert( flagSpawns.size > 0 );
	
	level.startPos["allies"] = level.spawn_allies_start[0].origin;
	level.startPos["axis"] = level.spawn_axis_start[0].origin;
	
	allowed[0] = "dom";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
		
	if ( !isOneRound() && isScoreRoundBased() )
	{
		maps\mp\gametypes\_globallogic_score::resetTeamScores();
	}
		
	updateGametypeDvars();
	bwars_init();
	level thread bwars_update_scores();
	bwars_spawns_update();
}


onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer(predictedSpawn)
{
	spawnpoint = undefined;
	
	spawnteam = self.pers["team"];
	// TODO MTEAM - how to handle sideswitch
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	self player_world_icon_init();
	self player_hud_init();
		
	if ( !level.useStartSpawns )
	{
		flagsOwned = 0;
		enemyFlagsOwned = 0;
		myTeam = self.pers["team"];
		for ( i = 0; i < level.flags.size; i++ )
		{
			team = level.flags[i] getFlagTeam();
			if ( team == myTeam )
				flagsOwned++;
			else if ( team != "neutral"  && team != myTeam )
				enemyFlagsOwned++;
		}
		
		if ( flagsOwned == level.flags.size )
		{
			// own all flags! pretend we don't own the last one we got, so enemies can spawn there
			enemyBestSpawnFlag = level.bestSpawnFlag[ getOtherTeam( self.pers["team"] ) ];
			
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getSpawnsBoundingFlag( enemyBestSpawnFlag ) );
		}
		else if ( flagsOwned > 0 )
		{
			// spawn near any flag we own that's nearish something we can capture
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getBoundaryFlagSpawns( myTeam ) );
		}
		else
		{
			// own no flags!
			bestFlag = undefined;
			if ( enemyFlagsOwned > 0 && enemyFlagsOwned < level.flags.size )
			{
				// there should be an unowned one to use
				bestFlag = getUnownedFlagNearestStart( spawnteam );
			}
			if ( !isdefined( bestFlag ) )
			{
				// pretend we still own the last one we lost
				bestFlag = level.bestSpawnFlag[ self.pers["team"] ];
			}
			level.bestSpawnFlag[ self.pers["team"] ] = bestFlag;
			
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, bestFlag.nearbyspawns );
		}
	}
	
	if ( !isdefined( spawnpoint ) )
	{
		if ( spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}
	
	//spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
	
	assert( isDefined(spawnpoint) );
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self spawn(spawnpoint.origin, spawnpoint.angles, "dom");
	}
}

onEndGame( winningTeam )
{
}

onRoundEndGame( roundWinner )
{
	if ( level.roundScoreCarry == false ) 
	{
		[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
		[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	
		if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
			winner = "tie";
		else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
	}
	else
	{
        axisScore = [[level._getTeamScore]]( "axis" );
	    alliedScore = [[level._getTeamScore]]( "allies" );

		if ( axisScore == alliedScore )
		{
			winner = "tie";
		}
		else if ( axisScore > alliedScore )
		{
			winner = "axis";
		}
		else
		{
			winner = "allies";
		}

	}
	
	return winner;
}

updateGametypeDvars()
{
	level.flagCaptureTime = GetGametypeSetting( "captureTime" );
	level.flagCaptureLPM = dvarFloatValue( "maxFlagCapturePerMinute", 3, 0, 10 );
	level.playerCaptureLPM = dvarFloatValue( "maxPlayerCapturePerMinute", 2, 0, 10 );
	level.playerCaptureMax = dvarFloatValue( "maxPlayerCapture", 1000, 0, 1000 );
	level.playerOffensiveMax = dvarFloatValue( "maxPlayerOffensive", 16, 0, 1000 );
	level.playerDefensiveMax = dvarFloatValue( "maxPlayerDefensive", 16, 0, 1000 );
}

bwars_init()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;
	
	PrecacheModel( "mp_flag_green" );
	PrecacheModel( "mp_flag_red" );
	PrecacheModel( "mp_flag_neutral" );
	
	precacheString( &"MP_CAPTURING_FLAG" );
	precacheString( &"MP_LOSING_FLAG" );
	//precacheString( &"MP_LOSING_LAST_FLAG" );
	precacheString( &"MP_DOM_YOUR_FLAG_WAS_CAPTURED" );
	precacheString( &"MP_DOM_ENEMY_FLAG_CAPTURED" );
	precacheString( &"MP_DOM_NEUTRAL_FLAG_CAPTURED" );

	precacheString( &"MP_ENEMY_FLAG_CAPTURED_BY" );
	precacheString( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
	precacheString( &"MP_FRIENDLY_FLAG_CAPTURED_BY" );
	precacheString( &"MP_DOM_FLAG_A_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_B_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_C_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_D_CAPTURED_BY" );	
	precacheString( &"MP_DOM_FLAG_E_CAPTURED_BY" );	

	triggers = GetEntArray( "flag_primary", "targetname" );

	if ( !triggers.size )
	{
		printLn( "^1Not enough domination flags found in level!" );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	level.bwars_flags = [];
	
	foreach( trigger in triggers )
	{
		visuals = trigger flag_model_init();

		flag = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, ( 0, 0, 100 ) );
		Objective_Delete( flag.objIDAllies );
		maps\mp\gametypes\_gameobjects::releaseObjID( flag.objIDAllies );
		
		flag maps\mp\gametypes\_gameobjects::allowUse( "any" );
		flag maps\mp\gametypes\_gameobjects::setUseTime( level.flagCaptureTime );
		flag maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
		flag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

		flag flag_compass_init();

		flag.onUse = ::onUse;
		flag.onBeginUse = ::onBeginUse;
		flag.onUseUpdate = ::onUseUpdate;
		flag.onEndUse = ::onEndUse;

		level.bwars_flags[ level.bwars_flags.size ] = flag;
	}
}

player_hud_init()
{
	if ( IsDefined( self.bwars_hud ) )
	{
		return;
	}

	self.bwars_hud = [];

	x = -40;
	y = 300;

	for( i = 0; i < SCOREBOARD_MAX_PLAYERS; i++ )
	{
		hud = NewClientHudElem( self );

		hud.alignX = "left";
		hud.alignY = "middle";
		hud.foreground = 1;
		hud.fontScale = 1.5;
		hud.alpha = .8;
		hud.x = x;
		hud.y = y;
		hud.hidewhendead = 1;
		hud.hidewheninkillcam = 1;

		hud.score = NewClientHudElem( self );

		hud.score.alignX = "left";
		hud.score.alignY = "middle";
		hud.score.foreground = 1;
		hud.score.fontScale = 1.5;
		hud.score.alpha = .8;
		hud.score.x = x + 125;
		hud.score.y = y;
		hud.score.hidewhendead = 1;
		hud.score.hidewheninkillcam = 1;
		
		self.bwars_hud[ self.bwars_hud.size ] = hud;

		y += 15;
	}

	level bwars_scoreboard_update();
}

player_hud_update( names, scores )
{
	if ( !IsDefined( self.bwars_hud ) )
	{
		return;
	}

	for( i = 0; i < SCOREBOARD_MAX_PLAYERS; i++ )
	{
		self.bwars_hud[i] SetText( names[i] );

		if ( names[i] == "" )
		{
			self.bwars_hud[i].score SetText( "" );
		}
		else
		{
			self.bwars_hud[i].score SetValue( scores[i] );
		}

		if ( names[i] == self.name )
		{
			self.bwars_hud[i].color = ( 1, 0.84, 0 );
			self.bwars_hud[i].score.color = ( 1, 0.84, 0 );
		}
		else
		{
			self.bwars_hud[i].color = ( 1, 1, 1 );
			self.bwars_hud[i].score.color = ( 1, 1, 1 );
		}
	}
}

bubblesort_players()
{
	players = GET_PLAYERS();

	while( true )
	{
		swapped = false;
		
		for ( i = 1; i < players.size; i++ )
		{
			if ( players[i-1].score < players[i].score )
			{
				t = players[i-1];
				players[i-1] = players[i];
				players[i] = t;

				swapped = true;
			}
		}

		if ( !swapped )
		{
			break;
		}
	}

	return players;
}

bwars_scoreboard_update()
{
	names = [];
	scores = [];

	players = bubblesort_players();

	for( i = 0; i < SCOREBOARD_MAX_PLAYERS; i++ )
	{
		if ( players.size > i )
		{
			names[i] = players[i].name;
			scores[i] = players[i].score;
		}
		else
		{
			names[i] = "";
			scores[i] = -1;
		}
	}

	foreach( player in players )
	{
		player player_hud_update( names, scores );
	}
}

flag_model_init()
{
	visuals = [];

	visuals[DEFEND] = Spawn( "script_model", self.origin );
	visuals[DEFEND].angles = self.angles;
	visuals[DEFEND] SetModel( "mp_flag_neutral" );
	visuals[DEFEND] SetInvisibleToAll();
	
	visuals[CAPTURE] = Spawn( "script_model", self.origin );
	visuals[CAPTURE].angles = self.angles;
	visuals[CAPTURE] SetModel( "mp_flag_neutral" );
	visuals[CAPTURE] SetVisibleToAll();

	return visuals;
}

flag_model_update()
{
	owner = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	self.visuals[DEFEND] SetModel( "mp_flag_green" );
	self.visuals[DEFEND] SetInvisibleToAll();
	self.visuals[DEFEND] SetVisibleToPlayer( owner );
	
	self.visuals[CAPTURE] SetModel( "mp_flag_red" );
	self.visuals[CAPTURE] SetVisibleToAll();
	self.visuals[CAPTURE] SetInvisibleToPlayer( owner );
}

flag_compass_init()
{
	self.compass_icons = [];
	self.compass_icons[ DEFEND ] = maps\mp\gametypes\_gameobjects::getNextObjID();
	self.compass_icons[ CAPTURE ] = maps\mp\gametypes\_gameobjects::getNextObjID();

	label = self maps\mp\gametypes\_gameobjects::getLabel();

	Objective_Add( self.compass_icons[ DEFEND ], "active", self.curOrigin );
	Objective_Icon( self.compass_icons[ DEFEND ], "compass_waypoint_defend" + label );
	Objective_SetInvisibleToAll( self.compass_icons[ DEFEND ] );

	Objective_Add( self.compass_icons[ CAPTURE ], "active", self.curOrigin );
	Objective_Icon( self.compass_icons[ CAPTURE ], "compass_waypoint_captureneutral" + label );
	Objective_SetVisibleToAll( self.compass_icons[ CAPTURE ] );
}

flag_compass_update()
{
	label = self maps\mp\gametypes\_gameobjects::getLabel();
	owner = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	Objective_Icon( self.compass_icons[ DEFEND ], "compass_waypoint_defend" + label );
	Objective_State( self.compass_icons[ DEFEND ], "active" );
	Objective_SetInvisibleToAll( self.compass_icons[ DEFEND ] );
	Objective_SetVisibleToPlayer( self.compass_icons[ DEFEND ], owner );

	Objective_Icon( self.compass_icons[ CAPTURE ], "compass_waypoint_capture" + label );
	Objective_State( self.compass_icons[ CAPTURE ], "active" );
	Objective_SetVisibleToAll( self.compass_icons[ CAPTURE ] );
	Objective_SetInvisibleToPlayer( self.compass_icons[ CAPTURE ], owner );
}

player_world_icon_init()
{
	if ( IsDefined( self.bwars_icons ) )
	{
		return;
	}

	self.bwars_icons = [];

	foreach( flag in level.bwars_flags )
	{
		icon = NewClientHudElem( self );

		icon.flag = flag;
		icon.x = flag.curOrigin[0];
		icon.y = flag.curOrigin[1];
		icon.z = flag.curOrigin[2] + 100;
		icon.fadeWhenTargeted = true;
		icon.archived = false;
		icon.alpha = 1;

		self.bwars_icons[ self.bwars_icons.size ] = icon;
	}

	self player_world_icon_update();
}

player_world_icon_update()
{
	assert( IsDefined( self.bwars_icons ) );

	foreach( icon in self.bwars_icons )
	{
		label = icon.flag maps\mp\gametypes\_gameobjects::getLabel();
		owner = icon.flag maps\mp\gametypes\_gameobjects::getOwnerTeam();

		if ( IsString( owner ) && owner == "neutral" )
		{
			icon SetWaypoint( true, "waypoint_captureneutral" + label );
		}
		else if ( owner == self )
		{
			icon SetWaypoint( true, "waypoint_defend" + label );
		}
		else
		{
			icon SetWaypoint( true, "waypoint_capture" + label );
		}
	}
}

world_icon_update()
{
	players = GET_PLAYERS();

	foreach( player in players )
	{
		player player_world_icon_update();
	}
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
}

onUseUpdate( team, progress, change )
{
}

statusDialog( dialog, team )
{
	time = getTime();
	if ( getTime() < level.lastStatus[team] + 6000 )
		return;
		
	thread delayedLeaderDialog( dialog, team );
	level.lastStatus[team] = getTime();	
}

statusDialogEnemies( dialog, friend_team )
{
	foreach ( team in level.teams )
	{
		if ( team == friend_team )
			continue;
			
		statusDialog( dialog, team );
	}
}

onEndUse( team, player, success )
{

}


resetFlagBaseEffect()
{
/*
	// once these get setup we never change them
	if ( isdefined( self.baseeffect ) )
		return;
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	triggerFx( self.baseeffect );
*/
}

onUse( player )
{
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( player );
	self maps\mp\gametypes\_gameobjects::allowUse( "enemy" );

	self flag_compass_update();
	self flag_model_update();
	level world_icon_update();
	level bwars_spawns_update();
		
//	self resetFlagBaseEffect();
	
	//level.useStartSpawns = false;
/*
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

	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s", gettime(), "dom_capture", label, team );

	if ( oldTeam == "neutral" )
	{
		thread printAndSoundOnEveryone( team, undefined, &"", &"", "mp_war_objective_taken", undefined, "" );
		
		thread playSoundOnPlayers( "mus_dom_captured"+"_"+level.teamPostfix[team] );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{

			statusDialog( "secure_all", team );
			statusDialogEnemies( "lost_all", team );
		}
		else
		{
			statusDialog( "secured"+self.label, team );
			statusDialogEnemies( "lost"+self.label, team );
		}
	}
	else
	{
		thread printAndSoundOnEveryone( team, oldTeam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "" );
		
//		thread delayedLeaderDialogBothTeams( "obj_lost", oldTeam, "obj_taken", team );

//		thread playSoundOnPlayers( "mus_dom_captured"+"_"+level.teamPostfix[team] );
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
	}

	if ( dominated_challenge_check() ) 
	{
		maps\mp\_challenges::dominated( team );
	}
	self update_spawn_influencers( team );
	level change_dom_spawns();
*/
}

give_capture_credit( touchList, string )
{
	wait .05;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	self updateCapsPerMinute();
	
	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player_from_touchlist = touchList[players[i]].player;
		player_from_touchlist updateCapsPerMinute();
		if ( !isScoreBoosting( player_from_touchlist, self ) )
		{
			maps\mp\_scoreevents::processScoreEvent( "position_secure", player_from_touchlist );
			if( isdefined(player_from_touchlist.pers["captures"]) )
			{
				player_from_touchlist.pers["captures"]++;
				player_from_touchlist.captures = player_from_touchlist.pers["captures"];
			}

			maps\mp\_demo::bookmark( "event", gettime(), player_from_touchlist );
			player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );

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


bwars_update_scores()
{
	while ( !level.gameEnded )
	{
		foreach( flag in level.bwars_flags )
		{
			owner = flag maps\mp\gametypes\_gameobjects::getOwnerTeam();

			if ( IsPlayer( owner ) )
			{
				owner.score += 1; 
			}
		}

		level bwars_scoreboard_update();
		
		players = GET_PLAYERS();

		foreach( player in players )
		{
			player maps\mp\gametypes\_globallogic::checkScoreLimit();
		}
		
		wait ( 5.0 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}

onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	game["switchedsides"] = !game["switchedsides"];

	if ( level.roundScoreCarry == false ) 
	{
		[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
		[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	}
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
}



getTeamFlagCount( team )
{
	score = 0;
	for (i = 0; i < level.flags.size; i++) 
	{
		if ( level.domFlags[i] maps\mp\gametypes\_gameobjects::getOwnerTeam() == team )
			score++;
	}	
	return score;
}

getFlagTeam()
{
	return self.useObj maps\mp\gametypes\_gameobjects::getOwnerTeam();
}

getBoundaryFlags()
{
	// get all flags which are adjacent to flags that aren't owned by the same team
	bflags = [];
	for (i = 0; i < level.flags.size; i++)
	{
		for (j = 0; j < level.flags[i].adjflags.size; j++)
		{
			if (level.flags[i].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() != level.flags[i].adjflags[j].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() )
			{
				bflags[bflags.size] = level.flags[i];
				break;
			}
		}
	}
	
	return bflags;
}

getBoundaryFlagSpawns(team)
{
	spawns = [];
	
	bflags = getBoundaryFlags();
	for (i = 0; i < bflags.size; i++)
	{
		if (isdefined(team) && bflags[i] getFlagTeam() != team)
			continue;
		
		for (j = 0; j < bflags[i].nearbyspawns.size; j++)
			spawns[spawns.size] = bflags[i].nearbyspawns[j];
	}
	
	return spawns;
}

getSpawnsBoundingFlag( avoidflag )
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		flag = level.flags[i];
		if ( flag == avoidflag )
			continue;
		
		isbounding = false;
		for (j = 0; j < flag.adjflags.size; j++)
		{
			if ( flag.adjflags[j] == avoidflag )
			{
				isbounding = true;
				break;
			}
		}
		
		if ( !isbounding )
			continue;
		
		for (j = 0; j < flag.nearbyspawns.size; j++)
			spawns[spawns.size] = flag.nearbyspawns[j];
	}
	
	return spawns;
}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team, or that are adjacent to flags owned by the given team.
getOwnedAndBoundingFlagSpawns(team)
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			// add spawns near this flag
			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
		else
		{
			for (j = 0; j < level.flags[i].adjflags.size; j++)
			{
				if ( level.flags[i].adjflags[j] getFlagTeam() == team )
				{
					// add spawns near this flag
					for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
						spawns[spawns.size] = level.flags[i].nearbyspawns[s];
					break;
				}
			}
		}
	}
	
	return spawns;
}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team
getOwnedFlagSpawns(team)
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			// add spawns near this flag
			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
	}
	
	return spawns;
}

flagSetup()
{
	maperrors = [];
	descriptorsByLinkname = [];

	// (find each flag_descriptor object)
	descriptors = getentarray("flag_descriptor", "targetname");
	
	flags = level.flags;
	
	for (i = 0; i < level.domFlags.size; i++)
	{
		closestdist = undefined;
		closestdesc = undefined;
		for (j = 0; j < descriptors.size; j++)
		{
			dist = distance(flags[i].origin, descriptors[j].origin);
			if (!isdefined(closestdist) || dist < closestdist) {
				closestdist = dist;
				closestdesc = descriptors[j];
			}
		}
		
		if (!isdefined(closestdesc)) {
			maperrors[maperrors.size] = "there is no flag_descriptor in the map! see explanation in dom.gsc";
			break;
		}
		if (isdefined(closestdesc.flag)) {
			maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + closestdesc.script_linkname + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
			continue;
		}
		flags[i].descriptor = closestdesc;
		closestdesc.flag = flags[i];
		descriptorsByLinkname[closestdesc.script_linkname] = closestdesc;
	}
	
	if (maperrors.size == 0)
	{
		// find adjacent flags
		for (i = 0; i < flags.size; i++)
		{
			if (isdefined(flags[i].descriptor.script_linkto))
				adjdescs = strtok(flags[i].descriptor.script_linkto, " ");
			else
				adjdescs = [];
			for (j = 0; j < adjdescs.size; j++)
			{
				otherdesc = descriptorsByLinkname[adjdescs[j]];
				if (!isdefined(otherdesc) || otherdesc.targetname != "flag_descriptor") {
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to \"" + adjdescs[j] + "\" which does not exist as a script_linkname of any other entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
					continue;
				}
				adjflag = otherdesc.flag;
				if (adjflag == flags[i]) {
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to itself";
					continue;
				}
				flags[i].adjflags[flags[i].adjflags.size] = adjflag;
			}
		}
	}
	
	// assign each spawnpoint to nearest flag
	spawnpoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn" );
	for (i = 0; i < spawnpoints.size; i++)
	{
		if (isdefined(spawnpoints[i].script_linkto)) {
			desc = descriptorsByLinkname[spawnpoints[i].script_linkto];
			if (!isdefined(desc) || desc.targetname != "flag_descriptor") {
				maperrors[maperrors.size] = "Spawnpoint at " + spawnpoints[i].origin + "\" linked to \"" + spawnpoints[i].script_linkto + "\" which does not exist as a script_linkname of any entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
				continue;
			}
			nearestflag = desc.flag;
		}
		else {
			nearestflag = undefined;
			nearestdist = undefined;
			for (j = 0; j < flags.size; j++)
			{
				dist = distancesquared(flags[j].origin, spawnpoints[i].origin);
				if (!isdefined(nearestflag) || dist < nearestdist)
				{
					nearestflag = flags[j];
					nearestdist = dist;
				}
			}
		}
		nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
	}
	
	if (maperrors.size > 0)
	{
		/#
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		maps\mp\_utility::error("Map errors. See above");
		#/
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		
		return;
	}
}

createFlagSpawnInfluencers()
{
	ss = level.spawnsystem;

	for (flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if ( level.domFlags[flag_index] == self )
			break;
	}
	
	ABC = [];
	ABC[0] = "A";
	ABC[1] = "B";
	ABC[2] = "C";
	
	// domination: owned flag influencers
	self.owned_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ss.dom_owned_flag_influencer_radius[flag_index],
							 ss.dom_owned_flag_influencer_score[flag_index],
							 0,
							 "dom_owned_flag_" + ABC[flag_index] + ",r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ss.dom_owned_flag_influencer_score_curve) );
	
	// domination: un-owned inner flag influencers
	self.neutral_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ss.dom_unowned_flag_influencer_radius,
							 ss.dom_unowned_flag_influencer_score,
							 0,
							 "dom_unowned_flag,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ss.dom_owned_flag_influencer_score_curve) );
		
	// domination: enemy flag influencers
	self.enemy_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ss.dom_enemy_flag_influencer_radius[flag_index],
							 ss.dom_enemy_flag_influencer_score[flag_index],
							 0,
							 "dom_enemy_flag_" + ABC[flag_index] + ",r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ss.dom_enemy_flag_influencer_score_curve) );
	
	
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
		
		setinfluencerteammask(self.owned_flag_influencer, getTeamMask(team) );
		setinfluencerteammask(self.enemy_flag_influencer, getOtherTeamsMask(team) );	
	}
}

dom_gamemodeSpawnDvars(reset_dvars)
{
	ss = level.spawnsystem;

	// domination: owned flag influencers
	ss.dom_owned_flag_influencer_score = [];
	ss.dom_owned_flag_influencer_radius = [];
	
	ss.dom_owned_flag_influencer_score[0] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_A_influencer_score", "10", reset_dvars);
	ss.dom_owned_flag_influencer_radius[0] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_A_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);
	ss.dom_owned_flag_influencer_score[1] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_B_influencer_score", "10", reset_dvars);
	ss.dom_owned_flag_influencer_radius[1] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_B_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);
	ss.dom_owned_flag_influencer_score[2] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_C_influencer_score", "10", reset_dvars);
	ss.dom_owned_flag_influencer_radius[2] = set_dvar_float_if_unset("scr_spawn_dom_owned_flag_C_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);
	
	ss.dom_owned_flag_influencer_score_curve = set_dvar_if_unset("scr_spawn_dom_owned_flag_influencer_score_curve", "constant", reset_dvars);
	
	// domination: enemy flag influencers
	ss.dom_enemy_flag_influencer_score = [];
	ss.dom_enemy_flag_influencer_radius = [];
	
	ss.dom_enemy_flag_influencer_score[0] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_A_influencer_score", "-10", reset_dvars);
	ss.dom_enemy_flag_influencer_radius[0] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_A_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);
	ss.dom_enemy_flag_influencer_score[1] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_B_influencer_score", "-10", reset_dvars);
	ss.dom_enemy_flag_influencer_radius[1] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_B_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);
	ss.dom_enemy_flag_influencer_score[2] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_C_influencer_score", "-10", reset_dvars);
	ss.dom_enemy_flag_influencer_radius[2] = set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_C_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);

	ss.dom_enemy_flag_influencer_score_curve = set_dvar_if_unset("scr_spawn_dom_enemy_flag_influencer_score_curve", "constant", reset_dvars);
	
	// domination: un-owned inner flag influencers
	ss.dom_unowned_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_dom_unowned_flag_influencer_score", "-500", reset_dvars);
	ss.dom_unowned_flag_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dom_unowned_flag_influencer_score_curve", "constant", reset_dvars);
	ss.dom_unowned_flag_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dom_unowned_flag_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);
}

bwars_spawns_update()
{
	maps\mp\gametypes\_spawnlogic::clearSpawnPoints();	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dom_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dom_spawn" );
	
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
}

dominated_challenge_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;

	for ( i = 0 ; i < num_flags ; i++ )
	{
		flag_team = level.flags[i] getFlagTeam();

		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		else
		{
			return false;
		}

		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) )
			return false;
	}

	return true;
}
//This function checks to see if one team owns all three flags
dominated_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;

	for ( i = 0 ; i < num_flags ; i++ )
	{
		flag_team = level.flags[i] getFlagTeam();

		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		
		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) )
			return false;
	}

	return true;
}

updateCapsPerMinute()
{
	if ( !isDefined( self.capsPerMinute ) )
	{
		self.numCaps = 0;
		self.capsPerMinute = 0;
	}
	
	self.numCaps++;
	
	minutesPassed = maps\mp\gametypes\_globallogic_utils::getTimePassed() / ( 60 * 1000 );
	
	// players use the actual time played
	if ( IsPlayer( self ) && IsDefined(self.timePlayed["total"]) )
		minutesPassed = self.timePlayed["total"] / 60;
		
	self.capsPerMinute = self.numCaps / minutesPassed;
	if ( self.capsPerMinute > self.numCaps )
		self.capsPerMinute = self.numCaps;
}

isScoreBoosting( player, flag )
{
	if ( !level.rankedMatch )
		return false;
		
	if ( player.capsPerMinute > level.playerCaptureLPM )
		return true;
			
	if ( flag.capsPerMinute > level.flagCaptureLPM )
	  return true;
	  
	if ( player.numCaps > level.playerCaptureMax )
		return true;
			
 return false;
}