#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;



main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_scorefeedback::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 100, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerScore = ::onPlayerScore;
	level.onDeathOccurred = ::onDeathOccurred;
	level.doCountdown = true;
	setDvar("g_teamBased", 0);
}


onStartGameType()
{
	setClientNameMode("auto_change");
	setDvar("g_teamBased", 0);

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_DM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_DM" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	setMapCenter( maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs ) );

	level.spawnpoints = getentarray("mp_dm_spawn", "classname");

	
	
	
	level.QuickMessageToAll = true;

	level.points = [];
	level.points["kill"] = 1;
	level.points["teamkill"] = -1;
	level.points["death"] = -1;
	level.points["suicide"] = -1;
	
	
	setDvar("respawn_delay", 10);
	setDvar("respawn_delay_inc", 5);
	setDvar("respawn_delay_max", 30);
}


onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	self spawn( spawnPoint.origin, spawnPoint.angles );
	self.respawn_penalty = 0;
}


onPlayerScore(event,attacker,victim)
{
	logprint("\n*** event is: " + event);
	points = level.points[event];
	if (!isDefined(points))
		points = 0;

	curScore = maps\mp\gametypes\_globallogic::_getPlayerScore(attacker);
	maps\mp\gametypes\_globallogic::_setPlayerScore(attacker,curScore + points);
	attacker thread maps\mp\gametypes\_scorefeedback::giveScoreFeedback(points);
}


onDeathOccurred(victim,attacker)
{
	if (victim == attacker && !level.splitscreen)
		maps\mp\gametypes\_globallogic::giveRespawnPenalty(victim);
}
