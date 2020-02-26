/*
	Acquisition
	Objective: 	Score points by holding onto the flag
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_dm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["opfor"] = "opfor";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

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

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "aq", 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "aq", 50, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "aq", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "aq", 0, 0, 10 );

	level.overridePlayerScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
}


onStartGameType()
{
	level.compassflag = "compass_flag_neutral";
	level.hudflag = "compass_flag_neutral";
	precacheShader(level.compassflag);
	precacheShader(level.hudflag);
	precacheModel("prop_flag_neutral");
	precacheModel("prop_flag_neutral_carry");
	game["headicon_carrier"] = "headicon_carrier";
	precacheHeadIcon(game["headicon_carrier"]);

	setClientNameMode("auto_change");

	if ( level.teamBased )
	{
		maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_AQ_TEAM" );
		maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_AQ_TEAM" );
		
		if ( level.splitscreen )
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_AQ_TEAM" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_AQ_TEAM" );
		}
		else
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_AQ_SCORE_TEAM" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_AQ_SCORE_TEAM" );
		}
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_AQ_HINT_TEAM" );
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_AQ_HINT_TEAM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_AQ" );
		maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_AQ" );

		if ( level.splitscreen )
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_AQ" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_AQ" );
		}
		else
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_AQ_SCORE" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_AQ_SCORE" );
		}
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_AQ_HINT" );
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_AQ_HINT" );
	}

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	level.spawnpoints = getentarray("mp_dm_spawn", "classname");

	allowed[0] = "dom";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.QuickMessageToAll = true;

	minefields = [];
	minefields = getentarray("minefield", "targetname");
	trigger_hurts = [];
	trigger_hurts = getentarray("trigger_hurt", "classname");

	level.flag_returners = minefields;
	for(i = 0; i < trigger_hurts.size; i++)
		level.flag_returners[level.flag_returners.size] = trigger_hurts[i];

	thread carryFlag();
	thread updateGametypeDvars();
}


onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	self spawn( spawnPoint.origin, spawnPoint.angles );
}


updateGametypeDvars()
{
}


carryFlag()
{
	
}


attachFlag()
{
	if (isdefined(self.flagAttached))
		return;

	//put icon on screen
	self.flagAttached = newClientHudElem(self);
	self.flagAttached.x = 30;
	self.flagAttached.y = 95;
	self.flagAttached.alignX = "center";
	self.flagAttached.alignY = "middle";
	self.flagAttached.horzAlign = "left";
	self.flagAttached.vertAlign = "top";

	iconSize = 40;

	flagModel = "prop_flag_neutral_carry";
	self.flagAttached setShader(level.hudflag, iconSize, iconSize);

	self attach(flagModel, "J_Spine4", true);
}


detachFlag(flag)
{
	if (!isdefined(self.flagAttached))
		return;

	flagModel = "prop_flag_neutral_carry";
	self detach(flagModel, "J_Spine4");

	self.flagAttached destroy();
}

