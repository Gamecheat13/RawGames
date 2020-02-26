#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	King of the Hill
	Objective: 	Score points by eliminating other players
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
			
		Capture point:
			targetname		koth_capture_point
			This is the point that teams gain points at by standing around.
			One is required.

		Capture point trigger:
			targetname		koth_capture_trigger
			This needs to be colliding with the koth_capture_point and is then used to determine
			when players are standing in the capture point area.
			If one is not supplied, creates a default trigger_radius at the koth_capture_point origin.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "mi6";
			game["axis"] = "terrorists";

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

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
main()
{
	if ( getdvar("mapname") == "mp_background" )
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 300, 0, 1000 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	maps\mp\gametypes\_globallogic::registerMinPlayersDvar( level.gameType, 2, 2, 12 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );

	registerKothCapturePointReselectionTime( 150 );
	
	level.teamBased = true;
	level.doAutoAssign = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.onPrecacheGametype = ::onPrecacheGametype;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;

	level.team_bond = "allies";
	level.team_terrorists = "axis";
	
	level.winTeamPointMultiplier = 10;
	level.loseTeamPointMultiplier = 10;

	maps\mp\gametypes\_globallogic::findMapCenter();
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
registerKothCapturePointReselectionTime( defaultValue )
{
	dvarString = ("scr_koth_newcapturepointtime");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
getKothCapturePointReselectionTime()
{
	return getDvarFloat( "scr_koth_newcapturepointtime" );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onPrecacheGametype()
{
	precacheShader( "compass_point_neutral" );
	precacheShader( "compass_point_mi6" );
	precacheShader( "compass_point_org" );

	precacheShader( "mp_hud_koth_captured" );
	precacheShader( "mp_hud_koth_neutral" );
	precacheShader( "mp_hud_koth_contested" );
	precacheShader( "mp_hud_koth_mi6" );
	precacheShader( "mp_hud_koth_org" );

	precacheShader( "mp_world_koth_captured" );
	precacheShader( "mp_world_koth_neutral" );
	precacheShader( "mp_world_koth_contested" );
	precacheShader( "mp_world_koth_mi6" );
	precacheShader( "mp_world_koth_org" );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
updateObjectiveHintMessages( alliesObjective, axisObjective )
{
	game["strings"]["objective_hint_allies"] = alliesObjective;
	game["strings"]["objective_hint_axis"  ] = axisObjective;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
		{
			hintText = maps\mp\gametypes\_globallogic::getObjectiveHintText( player.pers["team"] );
			player thread maps\mp\gametypes\_hud_message::hintMessage( hintText );
		}
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onStartGameType()
{
	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_KOTH" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_KOTH" );

	maps\mp\gametypes\_globallogic::setObjectiveMenuText( "allies", "OBJECTIVES_KOTH" );
	maps\mp\gametypes\_globallogic::setObjectiveMenuText( "axis", "OBJECTIVES_KOTH" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_KOTH" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_KOTH" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_KOTH_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_KOTH_SCORE" );
	}
	
	updateObjectiveHintMessages( &"OBJECTIVES_TDM_HINT", &"OBJECTIVES_TDM_HINT" );
	
	setClientNameMode("auto_change");

	maps\mp\gametypes\_spawnlogic::addSpawnPointsWithTeamStarts( "mp_tdm_spawn", "mp_tdm_spawn_allies_start", "mp_tdm_spawn_axis_start" );
	
	allowed[0] = "koth";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.primaryProgressBarHeight = 28;
	level.primaryProgressBarWidth = 280;
	level.primaryProgressBarFontSize = 1.65;
	
	setupCapturePoints();

	thread capturePointActivator();

	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 15 );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onSpawnPlayer()
{
	spawnpoint = undefined;
	
	if ( level.useStartSpawns )
	{
		if (self.pers["team"] == level.team_terrorists)
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( level.spawn_axis_start );
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( level.spawn_allies_start );
	}	
	else if ( isdefined( level.capturePoint ) )
	{
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawnpoints, level.capturePoint.outerSpawns );
	}
	
	if ( !isDefined( spawnpoint ) )
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_generic );
	
	assert( isDefined(spawnpoint) );

	self.lowerMessageOverride = undefined;
	
	self spawn( spawnpoint.origin, spawnpoint.angles );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
pickNewCapturePointToActivate()
{
	newCapturePoint = level.capturePoints[ randomint( level.capturePoints.size ) ];

	if( isDefined( level.capturePoint ) )
	{
		while( newCapturePoint == level.capturePoint && level.capturePoints.size > 1 )
		{
			newCapturePoint = level.capturePoints[ randomint( level.capturePoints.size ) ];
		}
	}

	return newCapturePoint;
}

//--------------------------------------------------------------------------------------
// Thread that runs during the game to pick a new capture point every
// "scr_koth_newcapturepointtime" seconds.
//--------------------------------------------------------------------------------------
capturePointActivator()
{
	level endon( "game_ended" );

	while( game["state"] != "playing" )
	{
		wait 0.05;
	}

	timerDisplay = createServerTimer( "default", 1.4 );
	timerDisplay setPoint( "CENTER", "BOTTOM", 0, -20 );
	timerDisplay.label = &"MPUI_CAPTURE_POINT_CHANGES";
	timerDisplay.alpha = 0;
	timerDisplay.archived = false;
	timerDisplay.hideWhenInMenu = true;

	for( ; ; )
	{
		newCapturePoint = pickNewCapturePointToActivate();
		if( level.capturePoints.size > 1 || !isDefined( level.capturePoint ) )
		{
			if( isDefined( level.capturePoint ) )
			{
				deactivateCapturePoint( level.capturePoint );
			}
			activateCapturePoint( newCapturePoint );
		}

		wait getKothCapturePointReselectionTime() - 10;

		if( level.capturePoints.size > 1 )
		{
			level.kothObjPoint thread maps\mp\gametypes\_objpoints::startFlashing();
			timerDisplay setTimer( 10 );
			timerDisplay.alpha = 1;
			wait 10;
			timerDisplay.alpha = 0;
			level.kothObjPoint maps\mp\gametypes\_objpoints::stopFlashing();
			playSoundOnPlayers( "Tann_MP_48" );
		}
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
deactivateCapturePoint( capturePoint )
{
	capturePoint hide();

	objective_delete( capturePoint.objective_id );

	capturePoint notify( "deactivated" );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
activateCapturePoint( capturePoint )
{
	capturePoint show();

	capturePointIcon = "compass_point_neutral";
	capturePoint.objective_id = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add( capturePoint.objective_id, "active", capturePoint.origin, capturePointIcon );

	origin = capturePoint.origin;
	origin += ( 0, 0, 40 );
	if( !isDefined( level.kothObjPoint ) )
	{
		level.kothObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "capturePoint", origin, "all", "mp_world_koth_neutral", 1.0, 1.0 );
	}

	level.kothObjPoint maps\mp\gametypes\_objpoints::updateOrigin( origin );

	capturePoint.koth_currentState = 0;
	capturePoint.koth_startMI6Time = 0;
	capturePoint.koth_startTerroristTime = 0;

	capturePoint thread capturePointTriggerThink();
	capturePoint thread capturePointScoreThink();

	level.capturePoint = capturePoint;
}

//--------------------------------------------------------------------------------------
// self = player
//--------------------------------------------------------------------------------------
setHudCaptureIcon( icon, isInZone )
{
	if ( isDefined( self.kothHudCaptureIcon ) ) {
		self.kothHudCaptureIcon setShader( icon, 24, 24 );
	} else {
		captureIcon = self createIcon( icon, 24, 24 );
		captureIcon setPoint( "TOPRIGHT", "TOPRIGHT", -100, -2 );
		captureIcon.hideWhenInMenu = false;
		captureIcon.archived = false;
		self.kothHudCaptureIcon = captureIcon;
	}

	self.kothHudCaptureIcon.alpha = 1;
	if ( isDefined( level.kothObjPoint ) ) {
		level.kothObjPoint.alpha = 1;
	}
	
	if ( isInZone ) {
		if( isDefined( level.capturePoint ) && isDefined( level.kothObjPoint ) )
		{
			if ( level.capturePoint.koth_currentState == 1 && ( level.capturePoint.koth_startMI6Time > 0 || level.capturePoint.koth_startTerroristTime > 0 ) ) {
				self.kothHudCaptureIcon.alpha = 0.2 + ( (getTime() % 1000) / 1000 );
				level.kothObjPoint.alpha = 0.2 + ( (getTime() % 1000) / 1000 );
			}
		}
	}
}

//--------------------------------------------------------------------------------------
// Updates the capture bar when a player is capturing a point.
//     self = player
//--------------------------------------------------------------------------------------
updateCaptureBar( capturePoint, forceRemove )
{
	captureTime = 0;
	if( self.pers["team"] == level.team_bond )
	{
		captureTime = capturePoint.koth_startMI6Time;
	}
	else if( self.pers["team"] == level.team_terrorists )
	{
		captureTime = capturePoint.koth_startTerroristTime;
	}
	if( !isDefined( captureTime ) )
		captureTime = 0;

	isInCaptureZone = isDefined( self.isInCaptureZone ) && self.isInCaptureZone;
	if ( forceRemove || !isInCaptureZone || captureTime == 0 || capturePoint.koth_currentState != 1 )
	{
		if ( isDefined( self.captureBar ) )
			self.captureBar destroyElem();

		if ( isDefined( self.captureBarText ) )
			self.captureBarText destroyElem();
		return;
	}
	
	if ( !isDefined( self.captureBar ) )
	{
		self.captureBar = createPrimaryProgressBar();
		
		self.captureBarText = createPrimaryProgressBarText();
		self.captureBarText setText( &"MP_CAPTURING_OBJECTIVE" );
	}
	
	stateChangeTime = capturePoint getCapturePointStateChangeTime();
	self.captureBar updateBar( (getTime() - captureTime) / stateChangeTime );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------

alertPlayersOfStatus( currentStatus )
{
	statusIcon = "mp_hud_koth_neutral";
	worldIcon = "mp_world_koth_neutral";

	if ( currentStatus == 1 ) {
		statusIcon = "mp_hud_koth_contested";
		worldIcon = "mp_world_koth_contested";
	} else if ( currentStatus == 2 ) {
		statusIcon = "mp_hud_koth_mi6";
		worldIcon = "mp_world_koth_mi6";
	} else if ( currentStatus == 3 ) {
		statusIcon = "mp_hud_koth_org";
		worldIcon = "mp_world_koth_org";
	}

	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];
	
		player setHudCaptureIcon( statusIcon, player.isInCaptureZone );

		player updateCaptureBar( self, false );
	}
	
	if ( isDefined( level.kothObjPoint ) ) {
		level.kothObjPoint setShader( worldIcon, level.objPointSize, level.objPointSize );
		level.kothObjPoint setWaypoint( true );
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------

pointCapturedByMI6()
{
	playSoundOnPlayers( "zone_mi6controlled" );

	if( isDefined( level.capturePoint ) )
	{
		objective_icon( level.capturePoint.objective_id, "compass_point_mi6" );
	}
}

pointCapturedByOrg()
{
	playSoundOnPlayers( "zone_terroristcontrolled" );

	if( isDefined( level.capturePoint ) )
	{
		objective_icon( level.capturePoint.objective_id, "compass_point_org" );
	}
}

pointNeutral()
{
	if( isDefined( level.capturePoint ) )
	{
		objective_icon( level.capturePoint.objective_id, "compass_point_neutral" );
	}
}

//--------------------------------------------------------------------------------------
// self = capturePoint
//--------------------------------------------------------------------------------------
getCapturePointStateChangeTime()
{
	if ( self.koth_currentState == 2 || self.koth_currentState == 3 )
	{
		return 500;
	}
	return 5000;
}

//--------------------------------------------------------------------------------------
// Used to display the proper hud items on each players screen so they know if they
// are king of the hill or not.
//    self = capturePoint
//--------------------------------------------------------------------------------------
setupPlayerCapturePointHudItems()
{
/#
	assert( isDefined( self.playersTouching ) && isArray( self.playersTouching ) );
#/
	bondPlayersTouching = self.playersTouching[ level.team_bond ];
	terroristPlayersTouching = self.playersTouching[ level.team_terrorists ];

	areBondInCapturePoint = isDefined( bondPlayersTouching ) && bondPlayersTouching.players.size > 0;
	areTerroristsInCapturePoint = isDefined( terroristPlayersTouching ) && terroristPlayersTouching.players.size > 0;

	stateChangeTime = self getCapturePointStateChangeTime();

	if( areBondInCapturePoint && !areTerroristsInCapturePoint )
	{
		if ( self.koth_startMI6Time == 0 ) {
			self.koth_startMI6Time = getTime();
		}
		if ( self.koth_currentState == 0 ) {
			self.koth_currentState = 1;
		}
		self.koth_startTerroristTime = 0;

		if ( getTime() - self.koth_startMI6Time >= stateChangeTime ) {

			if ( self.koth_currentState == 0 || self.koth_currentState == 1 ) {
				pointCapturedByMI6();
				self.koth_currentState = 2;
				self.koth_startMI6Time = 0;
			}
			else if ( self.koth_currentState == 3 ) {
				pointNeutral();
				self.koth_startMI6Time = 0;
				self.koth_currentState = 1;
			}
		}
	}
	else if( areTerroristsInCapturePoint && !areBondInCapturePoint )
	{
		if ( self.koth_startTerroristTime == 0 ) {
			self.koth_startTerroristTime = getTime();
		}
		if ( self.koth_currentState == 0 ) {
			self.koth_currentState = 1;
		}
		self.koth_startMI6Time = 0;

		if ( getTime() - self.koth_startTerroristTime >= stateChangeTime ) {

			if ( self.koth_currentState == 0 || self.koth_currentState == 1 ) {
				pointCapturedByOrg();
				self.koth_currentState = 3;
				self.koth_startTerroristTime = 0;
			}
			else if ( self.koth_currentState == 2 ) {
				pointNeutral();
				self.koth_startTerroristTime = 0;
				self.koth_currentState = 1;
			}
		}	
	}
	else if( areTerroristsInCapturePoint && areBondInCapturePoint )
	{
		pointNeutral();
		self.koth_startTerroristTime = 0;
		self.koth_startMI6Time = 0;
		self.koth_currentState = 1;
	}

	if ( !areBondInCapturePoint ) {
		self.koth_startMI6Time = 0;
	}
	if ( !areTerroristsInCapturePoint ) {
		self.koth_startTerroristTime = 0;
	}

	alertPlayersOfStatus( self.koth_currentState );
}

//--------------------------------------------------------------------------------------
// Called every frame for each player that is touching the capture point trigger.
// Stores off information about who is touching the capture point so other threads
// can work with that data.
//    self = capturePoint
//--------------------------------------------------------------------------------------
onPlayerTouchingCapturePoint( player )
{
/#
	assert( isDefined( self.numTouching ) && isArray( self.numTouching ) );
	assert( isDefined( self.playersTouching ) && isArray( self.playersTouching ) );
#/
	team = player.pers[ "team" ];

	if( !isDefined( self.numTouching[ team ] ) )
	{
		self.numTouching[ team ] = 0;
	}
	self.numTouching[ team ]++;
	
	player.isInCaptureZone = true;
	
	if( !isDefined( self.playersTouching[ team ] ) )
	{
		self.playersTouching[ team ] = spawnstruct();
		self.playersTouching[ team ].players = [];
	}
	self.playersTouching[ team ].players[ self.playersTouching[ team ].players.size ] = player;
}

//--------------------------------------------------------------------------------------
// Thread that is executed to always check how many people are in the capture point trigger.
//    self = capturePoint
//--------------------------------------------------------------------------------------
capturePointTriggerThink()
{
	level endon( "game_ended" );
	self endon( "deactivated" );

	while( true )
	{
		wait 0.05;

		self.numTouching = [];
		self.playersTouching = [];

		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[ i ];
			player.isInCaptureZone = false;

			if( !isalive( player ) || player.sessionstate != "playing" )
				continue;

			if( !player isTouching( self.trig ) )
				continue;
			
			self onPlayerTouchingCapturePoint( player );
		}

		self setupPlayerCapturePointHudItems();
	}
}

//--------------------------------------------------------------------------------------
// Thread that gives score to those that are king of the hill
//    self = capturePoint
//--------------------------------------------------------------------------------------
capturePointScoreThink()
{
	level endon( "game_ended" );
	self endon( "deactivated" );
	
	seconds = 5;
	
	while ( !level.gameEnded )
	{
		wait seconds;

		if ( self.koth_currentState == 2 ) {
			teamScorePoints( level.team_bond, 5 );
		}
		if ( self.koth_currentState == 3 ) {
			teamScorePoints( level.team_terrorists, 5 );
		}
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
teamScorePoints( team, numPoints )
{
	numPlayersOnTeam = 0;
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];
		
		if ( player.pers["team"] == team )
		{
			numPlayersOnTeam++;
			player thread [[level.onXPEvent]]( "defend" );
			maps\mp\gametypes\_globallogic::givePlayerScore( "defend", player );	
		}
	}

	[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + numPoints );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
setupCapturePoints()
{
	maperrors = [];

	capturePoints = getentarray( "koth_capture_point", "targetname" );
	
	if ( capturePoints.size == 0 )
	{
		maperrors[maperrors.size] = "There is no entity with targetname \"koth_capture_point\"";
	}
	
	trigs = getentarray("koth_capture_trigger", "targetname");
	for ( i = 0; i < capturePoints.size; i++ )
	{
		errored = false;
		
		capturePoint = capturePoints[i];
		// Add a little height to the z for our tests since the origin of the trigger_radius
		// is off by 16 units in z and you can't give script_models a mins/maxs in the editor.
		capturePoint.origin += ( 0, 0, 16 );
		capturePoint.trig = undefined;
		for ( j = 0; j < trigs.size; j++ )
		{
			if ( capturePoint istouching( trigs[j] ) )
			{
				if ( isdefined( capturePoint.trig ) )
				{
					maperrors[maperrors.size] = "Capture point at " + capturePoint.origin + " is touching more than one \"koth_capture_trigger\" trigger";
					errored = true;
					break;
				}
				capturePoint.trig = trigs[j];
				break;
			}
		}

		capturePoint.origin -= ( 0, 0, 16 );
		
		if ( !isdefined( capturePoint.trig ) )
		{
			if ( !errored )
			{
				maperrors[maperrors.size] = "Capture point at " + capturePoint.origin + " is not inside any \"koth_capture_trigger\" trigger";
				continue;
			}
		}
		
		assert( !errored );

		capturePoint setUpNearbySpawns();
		capturePoint hide();
		capturePoint.visibleTeam = "any";
		capturePoint.ownerTeam = "any";

		capturePoint.koth_currentState = 0;
		capturePoint.koth_startMI6Time = 0;
		capturePoint.koth_startTerroristTime = 0;
	}

	if (maperrors.size > 0)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		maps\mp\_utility::error2( maperrors[ 0 ] );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return false;
	}

	level.capturePoints = capturePoints;
	return true;
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
setUpNearbySpawns()
{
	spawns = level.spawnpoints;
	
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
	
	outer = [];
	
	for ( i = 0 ; i < spawns.size; i++ )
	{
		if ( spawns[i].distsq > ( 512 * 512 ) )
		{
			outer[ outer.size ] = spawns[i];
		}
	}
	
	self.outerSpawns = outer;
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || (!self.touchTriggers.size && !attacker.touchTriggers.size) || attacker.pers["team"] == self.pers["team"] )
		return;

	if ( self.touchTriggers.size )
	{
		triggerIds = getArrayKeys( self.touchTriggers );
		ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		if ( ownerTeam != "neutral" )
		{
			team = self.pers["team"];
			if ( team == ownerTeam )
			{
				attacker thread [[level.onXPEvent]]( "assault" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "assault", attacker );
			}
			else
			{
				attacker thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "defend", attacker );
			}
		}		
	}	

	if ( attacker.touchTriggers.size )
	{
		triggerIds = getArrayKeys( attacker.touchTriggers );
		ownerTeam = attacker.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		
		if ( ownerTeam != "neutral" )
		{
			team = attacker.pers["team"];
			if ( team == ownerTeam )
			{
				attacker thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "defend", attacker );
			}
			else
			{
				attacker thread [[level.onXPEvent]]( "assault" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "assault", attacker );
			}		
		}
	}
}

