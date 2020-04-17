#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_scorefeedback::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gametype, 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gametype, 100, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gametype, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gametype, 0, 0, 10 );

	level.teamBased = true;
	setDvar("g_teamBased", 1);
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerScore = ::onPlayerScore;
}


onStartGameType()
{
	setDvar("g_teamBased", 1);

	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_TDM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_TDM" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_TDM_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_TDM_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	setMapCenter( maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs ) );
	
	level.spawnpoints = getentarray("mp_tdm_spawn", "classname");

	
	

	level.points = [];
	level.points["kill"] = 1;
	level.points["teamkill"] = -1;
	level.points["death"] = 0;
	level.points["suicide"] = 0;
	
	
	setDvar("respawn_delay", 10);
	setDvar("respawn_delay_inc", 5);
	setDvar("respawn_delay_max", 30);
}


onSpawnPlayer()
{
	self.usingObj = undefined;

	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	
	self spawn( spawnPoint.origin, spawnPoint.angles );
}


onDeathOccurred( victim, attacker )
{
	attacker_team = attacker.pers["team"];
	victim_team = victim.pers["team"];
	
	if ((victim == attacker || victim_team == attacker_team) && !level.splitscreen)
	{
		maps\mp\gametypes\_globallogic::giveRespawnPenalty(victim);
	}
}


onPlayerScore(event,attacker,victim)
{
	points = level.points[event];
	if (!isDefined(points))
		points = 0;

	curScore = maps\mp\gametypes\_globallogic::_getPlayerScore(attacker);
	maps\mp\gametypes\_globallogic::_setPlayerScore(attacker,curScore + points);
	attacker thread maps\mp\gametypes\_scorefeedback::giveScoreFeedback(points);
}

