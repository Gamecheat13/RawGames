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
			game["axis"] = "opfor";
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

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "koth", 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "koth", 50, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "koth", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "koth", 0, 0, 10 );
	
	level.overridePlayerScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
}

onStartGameType()
{
	precacheShader("field_radio");
	precacheShader("field_radio_conflict");
	precacheModel("me_satellitedish");
	precacheShader("objective_hq");
	precacheShader("objectiveA");
	precacheShader("objectiveB");
	precacheShader("objective");
	precacheShader("objpoint_A");
	precacheShader("objpoint_B");
	precacheShader("objpoint_star");
	precacheShader("objpoint_radio");

	setClientNameMode("auto_change");

	if ( level.teamBased )
	{
		maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_KOTH_TEAM" );
		maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_KOTH_TEAM" );
		
		if ( level.splitscreen )
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_KOTH_TEAM" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_KOTH_TEAM" );
		}
		else
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_KOTH_SCORE_TEAM" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_KOTH_SCORE_TEAM" );
		}
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_KOTH_HINT_TEAM" );
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_KOTH_HINT_TEAM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_KOTH" );
		maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_KOTH" );

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
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_KOTH_HINT" );
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_KOTH_HINT" );
	}
	
	level.spawnpoints = getentarray("mp_dm_spawn", "classname");
	if(!level.spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < level.spawnpoints.size; i++)
		level.spawnpoints[i] placeSpawnpoint();

	thread maps\mp\gametypes\_dev::init();
	
	allowed[0] = "koth";
	maps\mp\gametypes\_gameobjects::main(allowed);

	kothRadios();
	thread processRadioMovement();
	thread processRadioOwnership();
	thread processScoring();	
	thread updateGametypeDvars();
}

onSpawnPlayer()
{
	spawnpointname = "mp_dm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}


updateScore( event )
{
	if ( !isDefined( level.radioowner ) || level.radioowner != self )
		return;
		
	self [[level.updatePlayerScore]]( event );

	if ( level.teamBased )
		[[level.updateTeamScore]]( self.pers["team"], event );
		
	[[level.checkScoreLimit]]();
}


updateGametypeDvars()
{
}


kothRadios()
{
	wait 0.05;
	
	level.radioradius = 120;
	
	if(!isdefined(level.radios))
		level.radios = getentarray("koth_hardpoint", "targetname");
	
	if (level.radios.size == 0)
		maps\mp\_utility::error("^1No KOTH hardpoints were found in the map.");
	
	for(i = 0; i < level.radios.size; i++)
	{
		radio = level.radios[i];
		
		radio setmodel("me_satellitedish");
		radio hide();

		if((!isdefined(radio.script_radius)) || (radio.script_radius <= 0))
			radio.radius = level.radioradius;
		else
			radio.radius = radio.script_radius;
	}
}

processRadioMovement()
{
	objPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "radio", (0,0,0), "all", "objpoint_star" );
	for(;;)
	{
		level.radio = level.radios[randomint(level.radios.size)];
	
		while(isdefined(level.radio.last))
			level.radio = level.radios[randomint(level.radios.size)];
	
		for(i = 0; i < level.radios.size; i++)
			level.radios[i].last = undefined;
		
		level.radio.last = true;
		level.radio show();
		objective_add( 0, "current", level.radio.origin, "objective" );
		objPoint thread maps\mp\gametypes\_objpoints::updateOrigin( level.radio.origin );

		wait 180;

		level.radio hide();
	}
}

processRadioOwnership()
{
	for(;;)
	{
//		playersinrange = getPlayersInRange(level.radio);
//
//		for(i = 0; i < playersinrange.size; i++)
//		{
//			player = playersinrange[i];
//
//			if(!isdefined(player.hud_radio))
//			{
//				player.hud_radio = newClientHudElem(player);
//				player.hud_radio.x = 30;
//				player.hud_radio.y = 95;
//				player.hud_radio.alignX = "center";
//				player.hud_radio.alignY = "middle";
//				player.hud_radio.horzAlign = "left";
//				player.hud_radio.vertAlign = "top";
//				player.hud_radio setShader("field_radio", 40, 32);
//			}
//		}

		livingplayers = [];
		playersinrange = [];
		playersoutofrange = [];
	
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
				livingplayers[livingplayers.size] = player;
		}
	
		for(i = 0; i < livingplayers.size; i++)
		{
			player = livingplayers[i];
			
			if((distance(player.origin, level.radio.origin) <= level.radio.radius) && (distance((0, 0, player.origin[2]), (0, 0, level.radio.origin[2])) <= 72))
				playersinrange[playersinrange.size] = player;
			else
				playersoutofrange[playersoutofrange.size] = player;
		}

		if(playersinrange.size == 1)
		{
			level.radioowner = playersinrange[0];
			radio_icon = "field_radio";
		}
		else
		{
			level.radioowner = undefined;
			radio_icon = "field_radio_conflict";
		}

		for(i = 0; i < playersinrange.size; i++)
		{
			player = playersinrange[i];

			if(!isdefined(player.hud_radio))
			{
				player.hud_radio = newClientHudElem(player);
				player.hud_radio.x = 30;
				player.hud_radio.y = 95;
				player.hud_radio.alignX = "center";
				player.hud_radio.alignY = "middle";
				player.hud_radio.horzAlign = "left";
				player.hud_radio.vertAlign = "top";
			}

			player.hud_radio setShader(radio_icon, 40, 32);
		}

		for(i = 0; i < playersoutofrange.size; i++)
		{
			player = playersoutofrange[i];

			if(isdefined(player.hud_radio))
				player.hud_radio destroy();
		}

		wait .05;
	}		
}

processScoring()
{
	level endon ( "game_ended" );
	while( !isDefined( level.mapEndTime ) )
	{
		if(isdefined(level.radioowner))
			[[level._setPlayerScore]]( level.radioowner, [[level._getPlayerScore]]( level.radioowner ) + 1 );
		
		wait 1;
	}
}

getPlayersInRange(target)
{
	livingplayers = [];
	playersinrange = [];

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			livingplayers[livingplayers.size] = player;
	}

	for(i = 0; i < livingplayers.size; i++)
	{
		player = livingplayers[i];
		
		if((distance(player.origin, target.origin) <= target.radius) && (distance((0, 0, player.origin[2]), (0, 0, target.origin[2])) <= 72))
			playersinrange[playersinrange.size] = player;
	}
	
	return playersinrange;
}

isInRange(target)
{
	if((distance(self.origin, target.origin) <= target.radius) && (distance((0, 0, self.origin[2]), (0, 0, target.origin[2])) <= 72))
		return true;
	else
		return false;
}
