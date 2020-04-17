#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	War
	Objective: 	Score points for your team by eliminating players on the opposing team
	Map ends:	When one team reaches the score limit, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "opfor";
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

/*QUAKED mp_tdm_spawn (1.0 1.0 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

main()
{	
	if(getdvar("mapname") == "mp_background")
		return;

	precacheShader( "compassping_death" );	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "tdm", 10, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "tdm", 100, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "tdm", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "tdm", 0, 0, 10 );

	level.teamBased = true;
	level.doAutoAssign = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	
	level.winTeamPointMultiplier = 40;
	level.loseTeamPointMultiplier = 40;

	maps\mp\gametypes\_globallogic::findMapCenter();
}


onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_TDM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_TDM" );

	maps\mp\gametypes\_globallogic::setObjectiveMenuText( "allies", "OBJECTIVES_TDM" );
	maps\mp\gametypes\_globallogic::setObjectiveMenuText( "axis", "OBJECTIVES_TDM" );
	
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

	maps\mp\gametypes\_spawnlogic::addSpawnPointsWithTeamStarts( "mp_tdm_spawn", "mp_tdm_spawn_allies_start", "mp_tdm_spawn_axis_start" );
	
	allowed[0] = "war";
	allowed[1] = "hardpoint";
	allowed[2] = "tdm";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread updateGametypeDvars();
}


onSpawnPlayer()
{
	self.usingObj = undefined;

	if ( level.xboxlive )
	{
		spawns = self getstat( 2000 ) + 1;
		self setstat( 2000, spawns );
	}

	/*spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );*/
	
	if ( level.useStartSpawns )
	{
		if (self.pers["team"] == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}	
	else
	{
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_generic );
	}
	
	assert( isDefined(spawnpoint) );

	self spawn( spawnpoint.origin, spawnpoint.angles );
}


updateGametypeDvars()
{
}


