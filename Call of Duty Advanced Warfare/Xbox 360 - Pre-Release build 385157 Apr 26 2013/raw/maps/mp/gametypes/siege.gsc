#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
	Siege
	Objective: 	
	Map ends:	
	Respawning:	

	Level requirementss
	------------------
		Start Spawnpoints:
			classname		
			
		Spawnpoints:
			classname			

		Spectator Spawnpoints:
			classname		
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
*/

/*QUAKED mp_siege_spawn (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
These are split into 4 groups.  Players spawn near friendlies in a different group each spawn.*/

/*QUAKED mp_siege_spawn_postup (1.0 1.0 0.0) (-16 -16 0) (16 16 72)
Enemies will periodically spawn in these OP post up spots.*/

/*QUAKED mp_siege_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn in the Siege target at one of these positions at the start of a round.*/

/*QUAKED mp_siege_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from Siege target at one of these positions at the start of a round.*/


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
		registerTimeLimitDvar( level.gameType, 8 );
		
		registerScoreLimitDvar( level.gameType, 6000 );
		setOverrideWatchDvar( "scorelimit", 6000 );
		
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );	
		
		SetDynamicDvar( "scr_game_allowkillcam", 0 );
	}
	
	initAiBaseLoadout();

	level.teamBased = true;
	level.QuickMessageToAll = true;
	level.scoreLimitOverride = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.getTeamAssignment = ::getTeamAssignment;
	level.onSpawnPlayer = ::onSpawnPlayer;	
	level.onTimeLimit = ::onTimeLimit;	
	
	game["dialog"]["gametype"] = "siege";
	//game["dialog"]["offense_obj"] = "siege_hint";			
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	
	SetDynamicDvar( "scr_siege_scorelimit", 6000 );
	registerScoreLimitDvar( "siege", 6000 );
	
	SetDynamicDvar( "scr_game_allowkillcam", 0 );
	
	SetDynamicDvar( "scr_siege_roundswitch", 0 );
	registerRoundSwitchDvar( "siege", 0, 0, 9 );
	SetDynamicDvar( "scr_siege_roundlimit", 1 );
	registerRoundLimitDvar( "siege", 1 );		
	SetDynamicDvar( "scr_siege_winlimit", 1 );
	registerWinLimitDvar( "siege", 1 );			
	SetDynamicDvar( "scr_siege_halftime", 0 );
	registerHalfTimeDvar( "siege", 0 );
		
	SetDynamicDvar( "scr_siege_promode", 0 );
}


onPrecacheGameType()
{	
	precacheString( &"OBJECTIVES_SIEGE" );	
	precacheString( &"OBJECTIVES_SIEGE_SCORE" );	
	precacheString( &"OBJECTIVES_SIEGE_HINT" );	
}


onStartGameType()
{
	setClientNameMode("auto_change");

	setObjectiveText( "allies", &"OBJECTIVES_SIEGE" );
	setObjectiveText( "axis", &"OBJECTIVES_SIEGE" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_SIEGE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_SIEGE" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_SIEGE_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_SIEGE_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_SIEGE_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_SIEGE_HINT" );
	
	game["strings"]["objective_completed"] = &"GAME_OBJECTIVECOMPLETED";	
	precacheString( game["strings"]["objective_completed"] );	
	
	game["strings"]["objective_failed"] = &"GAME_OBJECTIVEFAILED";	
	precacheString( game["strings"]["objective_failed"] );

	initSpawns();
	
	allowed[0] = level.gameType;
	allowed[1] = "siege";	
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 5 );	
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "execution", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "avenger", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defender", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "posthumous", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "revenge", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "double", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "triple", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "multi", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "buzzkill", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "firstblood", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "comeback", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "longshot", 5 );	
	
	maps\mp\gametypes\_rank::registerScoreInfo( "team_restock", 50 );
	
	init();
}

initSpawns()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_siege_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_siege_spawn_axis_start" );

	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_siege_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_siege_spawn" );		
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}


init()
{
	//	ai
	level thread initAI();
	
	//	goals
	level.siege_startGoal = getEnt( "siege_startGoal", "targetname" );	
	level.siege_startGoal.objId = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( level.siege_startGoal.objId, "invisible", (0,0,0) );
	objective_icon( level.siege_startGoal.objId, "objpoint_siege" );
		
	level.siege_endGoal = getEnt( "siege_endGoal", "targetname" );
	level.siege_endGoal thread watchArrive();
	
	//	spawns
	spawnTriggers = getEntArray( "siege_spawnTrigger", "targetname" );
	
	level.siege_zones = [];
	level.siege_zoneIndex = -1;
	level.siege_spawnIndex = -1;
	
	foreach( spawnTrigger in spawnTriggers )
	{
		zone = spawnStruct();
		zone.trigger = spawnTrigger;
		zone.index = spawnTrigger.script_index;
		zone.spawns = [];
		targets = getEntArray( spawnTrigger.target, "targetname" );
		foreach( target in targets )
		{
			if ( target.classname == "mp_siege_spawn" )
				zone.spawns[zone.spawns.size] = target;
			else if ( target.classname == "script_origin" )
				zone.goal = target;
		}
		zone thread monitorZone();
		
		level.siege_zones[zone.index] = zone;
	}
	
	//	zone tracking
	level thread updateGoal();
	
	//	pickups
	pickups = getEntArray( "pickup", "targetname" );
	foreach( pickupNode in pickups )
	{
		trigger = spawn( "trigger_radius", (0,0,0), 0, 32, 32 );
		visuals[0] = spawn( "script_model", (0,0,0) );
		visuals[0] setModel( "com_deploy_ballistic_vest_friend_world" );
		
		pickup = maps\mp\gametypes\_gameobjects::createUseObject( "allies", trigger, visuals, (0,0,16) );
		
		//	we don't need these
		_objective_delete( pickup.objIDAllies );
		_objective_delete( pickup.objIDAxis );		
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.objPoints["allies"] );
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.objPoints["axis"] );		
		
		pickup maps\mp\gametypes\_gameobjects::setUseTime( 0 );
		pickup.onUse = ::onPickup;	
	
		pos = pickupNode.origin + (0,0,14);
		pickup.curOrigin = pos;
		pickup.trigger.origin = pos;
		pickup.visuals[0].origin = pos;
		
		pickup maps\mp\gametypes\_gameobjects::allowUse( "friendly" );	
		
		pickup thread pickupBounce();
	}
	
	//	timeout
	level thread timoutWarning();
}


//
//	SPAWNING
//


getTeamAssignment()
{
	if ( IsBot( self ) )
		assignment = "axis";
	else
		assignment = "allies";
	
	return assignment;
}


getSpawnPoint()
{
	spawnPoints = [];
	
	if ( self.team == "axis" )
	{
		if ( level.siege_zoneIndex != -1 )
			spawnPoints = level.siege_zones[level.siege_zoneIndex].spawns;
		else
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_siege_spawn_axis_start" );
	}
	else
	{
		if ( level.siege_spawnIndex != -1 )
			spawnPoints = level.siege_zones[level.siege_spawnIndex].spawns;
		else
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_siege_spawn_allies_start" );			
	}
		
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	
	return spawnPoint;
}


onSpawnPlayer()
{				
	level notify ( "spawned_player" );
	
	if ( isBot( self ) )
		aiPreSpawn();
	
	if ( !level.siege_began && self.team == "allies" )
		self thread onSpawnFinished();
}


onSpawnFinished()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	
	self waittill( "spawned_player" );
	
	//	wait for prematch to finish
	gameFlagWait( "prematch_done" );
	
	//	hold players until initial AI are created
	if ( !level.siege_began && self.team == "allies" )
	{
		self _disableWeapon();
		anchor = spawn( "script_origin", self.origin );
		self playerLinkTo( anchor );
		
		level waittill( "siege_begin" );
		
		self unlink();
		self _enableWeapon();
		anchor delete();
	}
}


//
//	AI
//


initAI()
{
	level endon( "game_ended" );
	level.siege_began = false;
	
	//	time needed for bot system initialization?
	wait( 3 );
	
	//	override _playerlogic::Callback_PlayerConnect() call to bot think
	level.bot_funcs["think"] = maps\mp\gametypes\_globallogic::blank;
	
	//	AI lists
	level.siege_ai = [];
	level.siege_ai["grunt"] = [];
	level.siege_ai["guard"] = [];
	level.siege_ai["hunter"] = [];
	
	//	create initial 3
	level thread createAI( "grunt" );
	level thread createAI( "guard" );
	level thread createAI( "hunter" );
	
	//	wait for prematch to finish
	gameFlagWait( "prematch_done" );
	
	//	wait for all initial AI to be created
	while ( ( level.siege_ai["grunt"].size + level.siege_ai["guard"].size + level.siege_ai["hunter"].size ) < 3 )
		wait( 0.05 );

	//	notify
	level notify( "siege_begin" );
	level.siege_began = true;	
	
	//	adds / removes appropriate number and type of enemies 
	//	depending on how many players are connected
	level thread monitorEnemyNumbers();
}


createAI( type )
{		
	ai = AddTestClient();	
	
	while( !isdefined( ai ) )
		wait( 0.05 );	
	
	ai.pers[ "isBot" ] = true;
	ai.equipment_enabled = true;
	ai.bot_team = "axis";	
	ai.siege_type = type;
	
	while( !isdefined( ai.pers["team"] ) )
		wait( 0.05 );	
	
	wait( 0.5 );	
	ai notify( "menuresponse", "changeclass", "gamemode" );	
	
	ai.class = "gamemode";
	ai.pers["gamemodeLoadout"] = level.siege_loadouts["bot"];
	
	if ( type == "grunt" )
		ai.ai_update = ::update_grunt;
	else if ( type == "guard" )
		ai.ai_update = ::update_guard;
	else if ( type == "hunter" )
		ai.ai_update = ::update_hunter;
	
	ai thread aiUpdate();
	
	//	add to pool
	level.siege_ai[type][level.siege_ai[type].size] = ai;
}


aiRespawn()
{	
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );	
	
	//	remove jugg
	if ( self isJuggernaut() )
	{
		self notify( "lost_juggernaut" );
		wait( 0.05 );
	}	
	
	//	remove old TI if it exists
	if ( isDefined ( self.setSpawnpoint ) )
		self maps\mp\perks\_perkfunctions::deleteTI( self.setSpawnpoint );		
	
	//	set faux TI to respawn at	
	spawnPoint = getSpawnPoint();
	setSpawnPoint = spawn( "script_model", spawnPoint.origin );
	setSpawnPoint.angles = spawnPoint.angles;
	setSpawnPoint.playerSpawnPos = spawnPoint.origin;
	setSpawnPoint.notTI = true;		
	self.setSpawnPoint = setSpawnPoint;
	
	//	faux spawn
	self notify( "faux_spawn" );
	self thread maps\mp\gametypes\_playerlogic::spawnPlayer( true );	
}


//	happens before giveLoadout()
aiPreSpawn()
{
	weapon = undefined;
	if ( self.siege_type == "grunt" )
	{
		if ( cointoss() )
			weapon = "iw5_usp45";
		else
			weapon = "iw5_44magnum";		
	}
	else if ( self.siege_type == "guard" )
	{
		if ( cointoss() )
			weapon = "iw5_mp9";
		else
			weapon = "iw5_spas12";		
	}
	else if ( self.siege_type == "hunter" )
	{
		if ( cointoss() )
			weapon = "iw5_barrett";
		else
			weapon = "iw5_acr";		
	}	
	
	self.pers["gamemodeLoadout"]["loadoutPrimary"] = weapon;
}


aiUpdate()
{
	level endon( "game_ended" );	
	
	while( true )
	{
		self waittill( "spawned_player" );
			
		self thread [[ self.ai_update ]]();
	}
}


update_grunt()
{
	level endon( "game_ended" );
	self endon( "death" );		
	
	self botSetDifficulty( "recruit" );
	
	//	JDS TODO: bots not stabbing anymore?  add this back when they do
	//self SetWeaponAmmoClip( self.primaryWeapon, weaponClipSize( self.primaryWeapon ) );
	//self SetWeaponAmmoStock( self.primaryWeapon, 0 );	
	
	//	go after the closest person
	while ( true )
	{		
		closestPlayer = undefined;
		closestDistance = 999999;
		foreach( player in level.players )
		{
			if ( isAlive( player ) && player.team == "allies" )
			{
				dist = distance( player.origin, self.origin );
				if ( dist < closestDistance )
				{
					closestPlayer = player;
					closestDistance = dist;
				}
			}
		}
				
		if ( isDefined( closestPlayer ) )
		{
			targetDistance = randomIntRange( 250, 400 );
			if ( closestDistance > targetDistance && self isWeaponEnabled() )
				self _disableWeapon();
			else if ( closestDistance < targetDistance && !self isWeaponEnabled() )
				self _enableWeapon();
			
			self BotClearScriptGoal();
			self BotSetScriptGoal( closestPlayer.origin, targetDistance-100, "guard" );
			
			result = self waittill_any_timeout( 1, "goal", "bad_path" );
			if ( result == "goal" && !self isWeaponEnabled() )
				self _enableWeapon();
		}
		else
			wait( 1 );
	}		
}


update_guard()
{
	level endon( "game_ended" );
	self endon( "death" );		
	
	self setMoveSpeedScale( 0.75 );
	self botSetDifficulty( "regular" );
	
	//	protect the trigger to next zone
	while ( true )
	{			
		targetDistance = randomIntRange( 150, 300 );
		
		if ( level.siege_zoneIndex == -1 )
			goal = level.siege_startGoal;
		else
			goal = level.siege_zones[level.siege_zoneIndex].goal;
		
		self BotClearScriptGoal();
		self BotSetScriptGoal( goal.origin, targetDistance, "guard" );
				
		wait( 1 );
	}
}


update_hunter()
{
	level endon( "game_ended" );
	self endon( "death" );		
	
	self setMoveSpeedScale( 0.6 );
	self botSetDifficulty( "regular" );
	
	//	protect the trigger two zones ahead to catch sprinters
	while ( true )
	{			
		targetDistance = randomIntRange( 200, 500 );
		
		if ( level.siege_zoneIndex == -1 )
			goal = level.siege_zones[0].goal;
		else if ( level.siege_zoneIndex + 1 < level.siege_zones.size-1 )
			goal = level.siege_zones[level.siege_zoneIndex+1].goal;
		else
			goal = level.siege_zones[level.siege_zoneIndex].goal;		
		
		self BotClearScriptGoal();
		self BotSetScriptGoal( goal.origin, targetDistance, "guard" );
				
		wait( 1 );
	}	
}


//
//	TRIGGERS
//


updateGoal()
{
	level endon( "game_ended" );
	
	while( true )
	{
		if ( level.siege_zoneIndex == -1 )
		{
			if ( !isDefined( level.siege_startGoal.siege_headIcon ) )
			{
				level.siege_startGoal.siege_headIcon = level.siege_startGoal maps\mp\_entityheadIcons::setHeadIcon( "allies", "objpoint_siege", (0,0,0), 4, 4, undefined, undefined, undefined, true, undefined, false );
				objective_position( level.siege_startGoal.objId, level.siege_startGoal.origin );
				objective_state( level.siege_startGoal.objId, "active" );
				level.siege_startGoal.siege_headIcon.alpha = 0.4;
			}
			
			foreach( zone in level.siege_zones )
			{
				if ( isDefined( zone.goal.siege_headIcon ) )
					zone.goal.siege_headIcon destroy();
			}			
		}
		else
		{
			if ( isDefined( level.siege_startGoal.siege_headIcon ) )
				level.siege_startGoal.siege_headIcon destroy();	

			foreach( zone in level.siege_zones )
			{
				if ( level.siege_zoneIndex == zone.index && !isDefined( zone.goal.siege_headIcon ) )
				{
					zone.goal.siege_headIcon = zone.goal maps\mp\_entityheadIcons::setHeadIcon( "allies", "objpoint_siege", (0,0,0), 4, 4, undefined, undefined, undefined, true, undefined, false );
					objective_position( level.siege_startGoal.objId, zone.goal.origin );
					objective_state( level.siege_startGoal.objId, "active" );
					zone.goal.siege_headIcon.alpha = 0.4;
				}
				else if ( level.siege_zoneIndex != zone.index && isDefined( zone.goal.siege_headIcon ) )
					zone.goal.siege_headIcon destroy();
			}
		}
		wait( 0.05 );
	}
}


monitorZone()
{
	level endon( "game_ended" );
	
	numTouching = [];	
	while ( true )
	{
		//	tally 
		//	JDS TODO: optimize with single, external tracker for all trigger states
		numTouching["axis"] = [];
		numTouching["allies"] = [];
		foreach ( player in level.players )
		{
			if ( isAlive( player ) && player isTouching( self.trigger ) )
			{
				numTouching[player.team][numTouching[player.team].size] = player;
			}
		}			
		
		//	activate next zone
		if ( level.siege_zoneIndex < self.index )
		{
			if ( numTouching["allies"].size )
			{
				level.siege_zoneIndex = self.index;	
				
				if ( level.siege_zoneIndex-2 > -1 )
					level.siege_spawnIndex = level.siege_zoneIndex-2;
				else 
					level.siege_spawnIndex = -1;					
			}
		}
		//	fall back to previous zone
		else if ( level.siege_zoneIndex == self.index )
		{ 			
			if ( !numTouching["allies"].size && ( level.siege_spawnIndex == -1 || self.index-1 > level.siege_spawnIndex+2 ) )
				level.siege_zoneIndex = self.index-1;	
		}		
		//	clear out enemy stragglers
		else if ( level.siege_zoneIndex > self.index )
		{
			if ( !numTouching["allies"].size && numTouching["axis"].size )
			{
				foreach( enemy in numTouching["axis"] )
					//RadiusDamage( enemy.origin, 2, 500, 500, undefined, "MOD_TRIGGER_HURT" );
					enemy thread aiRespawn();
			}
		}
		
		wait( 0.05 );		
	}	
}


watchArrive()
{
	level endon( "game_ended" );
	
	while( true )
	{
		self waittill( "trigger", player );
		if ( player.team == "allies" && ( !isDefined( player.heliType ) && !isDefined( player.tankType ) ) )
		{
			level thread maps\mp\gametypes\_gamelogic::endGame( "allies", game["strings"]["objective_completed"] );
			break;
		}
	}
}


onPickup( player )
{	
	//	announce		
	maps\mp\gametypes\_gamescore::givePlayerScore( "team_restock", player, undefined, true );
	player thread maps\mp\gametypes\_rank::giveRankXP( "team_restock" );
	if ( !player rankingEnabled() )
	{
		score = maps\mp\gametypes\_rank::getScoreInfoValue( "team_restock" );
		player thread maps\mp\gametypes\_rank::xpPointsPopup( score, 0, (1,1,0.5), 0 );	
	}	
	player teamPlayerCardSplash( "callout_team_restock", player, player.team );		
		
	//	reward
	foreach ( teamMate in level.players )
	{
		if ( teamMate.team == "allies" && isAlive( teamMate ) )
		{
			teamMate playLocalSound( "ammo_crate_use" );
			teamMate thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_TEAM_RESTOCK" );
			
			weaponList = teamMate GetWeaponsListAll();
			foreach ( weaponName in weaponList )
				teamMate giveMaxAmmo( weaponName );		

			teamMate.health = teamMate.maxHealth;			
		}
	}
	
	//	remove
	level thread removePickup( self );
}


removePickup( pickup )
{
	pickup notify( "deleted" );
	wait( 0.05 );
	pickup.trigger = undefined;	
	pickup.visuals[0] delete();
}


//	might reuse this during a "hold the point" objective
/*
rewardResupplyStart()
{		
	//	no doubles, remove old crates
	rewardResupplyStop();
		
	//	needs to happen after stop, stop notifies "siege_reward_resupply"
	level endon( "game_ended" );
	level endon( "siege_reward_resupply" );			
	
	firstDrop = true;
	owner = getHighestDefconPlayer();	
	foreach( drop in level.siege_drops )
	{
		while ( currentActiveVehicleCount() >= maxVehiclesAllowed() || level.fauxVehicleCount + 1 >= maxVehiclesAllowed() )
			wait( 0.1 );		
		
		if ( firstDrop )
		{			
			//	announce
			//	JDS TODO: make a generic script to handle messaging / scoring for rewards
			owner thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_EARNED_CAREPACKAGE" );	
			maps\mp\gametypes\_gamescore::givePlayerScore( "siege_reward", owner, undefined, true, true );
			owner thread maps\mp\gametypes\_rank::giveRankXP( "siege_reward" );	
			if ( !owner rankingEnabled() )
			{
				score = maps\mp\gametypes\_rank::getScoreInfoValue( "siege_reward" );
				owner thread maps\mp\gametypes\_rank::xpPointsPopup( score, 0, (1,1,0.5), 0 );	
			}			
			owner teamPlayerCardSplash( "callout_earned_carepackage", owner );			
			owner thread leaderDialog( "allies_friendly_airdrop_assault_inbound", owner.team );
			playSoundOnPlayers( "mp_war_objective_taken", owner.team );		

			//	track it
			firstDrop = false;
		}
		
		incrementFauxVehicleCount();
		level thread maps\mp\killstreaks\_airdrop::doFlyBy( owner, drop.origin, randomFloat( 360 ), "airdrop_siege", 0, "supply" );			
	}		
}

*/


//
//	UTILS
//


initAiBaseLoadout()
{	
	//	bot
	level.siege_loadouts["bot"]["loadoutPrimary"] = "none";
	level.siege_loadouts["bot"]["loadoutPrimaryAttachment"] = "none";
	level.siege_loadouts["bot"]["loadoutPrimaryAttachment2"] = "none";
	level.siege_loadouts["bot"]["loadoutPrimaryCamo"] = "none";
	level.siege_loadouts["bot"]["loadoutPrimaryReticle"] = "none";
	
	level.siege_loadouts["bot"]["loadoutSecondary"] = "none";
	level.siege_loadouts["bot"]["loadoutSecondaryAttachment"] = "none";
	level.siege_loadouts["bot"]["loadoutSecondaryAttachment2"] = "none";
	level.siege_loadouts["bot"]["loadoutSecondaryCamo"] = "none";
	level.siege_loadouts["bot"]["loadoutSecondaryReticle"] = "none";
	
	level.siege_loadouts["bot"]["loadoutEquipment"] = "specialty_null";
	level.siege_loadouts["bot"]["loadoutOffhand"] = "none";
	
	level.siege_loadouts["bot"]["loadoutPerk1"] = "specialty_null";
	level.siege_loadouts["bot"]["loadoutPerk2"] = "specialty_null";
	level.siege_loadouts["bot"]["loadoutPerk3"] = "specialty_null";
	level.siege_loadouts["bot"]["loadoutPerk4"] = "specialty_null";
	level.siege_loadouts["bot"]["loadoutPerk5"] = "specialty_null";
	level.siege_loadouts["bot"]["loadoutPerk6"] = "specialty_null";
	
	level.siege_loadouts["bot"]["loadoutActiveAbility"] = "specialty_null";
	level.siege_loadouts["bot"]["loadoutPassiveAbility"] = "specialty_null";
	
	level.siege_loadouts["bot"]["loadoutStreakType"] = "assault";
	level.siege_loadouts["bot"]["loadoutKillstreak1"] = "none";
	level.siege_loadouts["bot"]["loadoutKillstreak2"] = "none";
	level.siege_loadouts["bot"]["loadoutKillstreak3"] = "none";	
	level.siege_loadouts["bot"]["loadoutKillstreak4"] = "none";	
	
	//level.siege_loadouts["bot"]["loadoutDeathstreak"] = "specialty_null";		

	level.siege_loadouts["bot"]["loadoutJuggernaut"] = false;
}


synchEnemies( type, number )
{
	if ( level.siege_ai[type].size > number )
	{
		numToRemove = level.siege_ai[type].size - number;
		for( i=0; i<numToRemove; i++ )
		{
			RadiusDamage( level.siege_ai[type][i].origin, 2, 500, 500, undefined, "MOD_TRIGGER_HURT" );
			wait( 0.1 );
			kick( level.siege_ai[type][i] getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE" );
		}
		wait( 0.5 );
		
		level.siege_ai[type] = array_removeUndefined( level.siege_ai[type] );
	}
	else if ( level.siege_ai[type].size < number )
	{
		numToAdd = number - level.siege_ai[type].size;
		for( i=0; i<numToAdd; i++ )
		{
			level thread createAI( type );
		}		
	}
}


monitorEnemyNumbers()
{
	level endon( "game_ended" );
	
	while( true )
	{
		numPlayers = 0;
		foreach( player in level.players )
		{
			if ( player.team == "allies" )
				numPlayers++;
		}	
		
		switch( numPlayers )
		{
			case 1:
			{
				synchEnemies( "grunt", 1 );
				synchEnemies( "guard", 1 );
				synchEnemies( "hunter", 0 );
				break;
			}
			case 2:
			{
				synchEnemies( "grunt", 2 );
				synchEnemies( "guard", 1 );
				synchEnemies( "hunter", 1 );					
				break;
			}
			case 3:
			{
				synchEnemies( "grunt", 3 );
				synchEnemies( "guard", 2 );
				synchEnemies( "hunter", 2 );					
				break;
			}
			case 4:
			{
				synchEnemies( "grunt", 3 );
				synchEnemies( "guard", 3 );
				synchEnemies( "hunter", 3 );					
				break;
			}
			case 5:
			{
				synchEnemies( "grunt", 4 );
				synchEnemies( "guard", 4 );
				synchEnemies( "hunter", 3 );					
				break;
			}
			case 6:
			{
				synchEnemies( "grunt", 4 );
				synchEnemies( "guard", 4 );
				synchEnemies( "hunter", 4 );					
				break;
			}
		}		
		
		wait( 2 );
	}
}


pickupBounce()
{
	level endon( "game_ended" );
	self endon( "deleted" );
	
	bottomPos = self.curOrigin;
	topPos = self.curOrigin + (0,0,12);
	
	while( true )
	{
		self.visuals[0] moveTo( topPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );
		
		self.visuals[0] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );	
		
		wait( 0.5 );		
	}
}


timoutWarning()
{
	level endon( "game_ended" );
	
	notifyOneMinute = false;
	notifyThirtySeconds = false;	
	
	while( true )
	{
		timeRemaining = maps\mp\gametypes\_gamelogic::getTimeRemaining();
		
		if ( timeRemaining < 63000 && !notifyOneMinute )
		{
			notifyOneMinute = true;
			level thread leaderDialog( "one_minute_left", "allies" );
		}
		else if ( timeRemaining < 33000 && !notifyThirtySeconds ) 
		{
			notifyThirtySeconds = true;
			level thread leaderDialog( "thirty_seconds_left", "allies" );
			
			break;
		}
		
		wait( 1 );
	}
}


onTimeLimit()
{
	level.finalKillCam_winner = "axis";
	level thread maps\mp\gametypes\_gamelogic::endGame( "axis", game["strings"]["objective_failed"] );		
}
