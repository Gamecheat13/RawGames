/*
	Tag
	Objective: 	Score points by being "it"; kill the "it" player to become "it"
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

/* TODO:
 - change objective text displayed in score screen (spawnPlayer())
 - status icon in scoreboard for "it" player
 - resolve issue with gametypeobjectname thing - no MGs or anything will be available!
*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "tag", 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "tag", 100, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "tag", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "tag", 0, 0, 10 );

	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
	
	level.onPlayerScore = ::onPlayerScore;
}


onStartGameType()
{
	game["headicon_tagged"] = "headicon_tag_it"; // (temp)
	precacheHeadIcon(game["headicon_tagged"]);

	if ( level.teamBased )
	{
		maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_TAG_TEAM" );
		maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_TAG_TEAM" );
		
		if ( level.splitscreen )
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TAG_TEAM" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TAG_TEAM" );
		}
		else
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TAG_SCORE_TEAM" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TAG_SCORE_TEAM" );
		}
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_TAG_HINT_TEAM" );
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_TAG_HINT_TEAM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_TAG" );
		maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_TAG" );

		if ( level.splitscreen )
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TAG" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TAG" );
		}
		else
		{
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TAG_SCORE" );
			maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TAG_SCORE" );
		}
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_TAG_HINT" );
		maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_TAG_HINT" );
	}
	
	//level.hudtaggedicon = "compass_flag_german";
	//precacheShader(level.hudtaggedicon);
	level.hudtaggedoverlay = "overlay_tag_it";
	precacheShader(level.hudtaggedoverlay);

	setClientNameMode("auto_change");

	level.spawnpoints = getentarray("mp_dm_spawn", "classname");
	if(!level.spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < level.spawnpoints.size; i++)
		level.spawnpoints[i] placeSpawnpoint();

	allowed[0] = "tag";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.QuickMessageToAll = true;

	level.someoneTagged = false;
	level.taggedOverlayAlpha = .35;
	level.taggedOverlayAlphaFlash = .85;

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


onPlayerDisconnect()
{
	if (self isTagged())
		setTaggedPlayer(undefined);
}


onPlayerScore( event, player, victim )
{
	if ( event == "kill" && player isTagged() )
		player.pers["score"] += 1;
}


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if( isPlayer( attacker ) )
	{
		if( attacker == self ) // killed himself
			setTaggedPlayer(undefined); // suicide: no longer tagged
		else if ( self isTagged() || !level.someoneTagged )
			setTaggedPlayer( attacker ); // tag transferred
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		if ( self isTagged() )
			setTaggedPlayer(undefined); // no longer tagged
	}
}


updateGametypeDvars()
{
}


isTagged()
{
	return ( level.someoneTagged && isdefined(self) && isdefined(self.tagged) && self.tagged );
}


setTaggedPlayer(player)
{
	if (level.someoneTagged)
	{
		if (isdefined(player) && player == level.taggedPlayer)
			return;

		level.taggedPlayer.tagged = false;
		level.taggedPlayer.headicon = "";

		if ( isDefined( level.taggedHudOverlay ) )
			level.taggedHUDOverlay destroy();

		level.someoneTagged = false;
		level.taggedPlayer = undefined;
	}

	level notify("tagged_player_changed");
	
	if (isdefined(player) && isPlayer(player))
	{
		level.someoneTagged = true;
		level.taggedPlayer = player;
		level.taggedPlayer.tagged = true;
		level.taggedPlayer.headicon = game["headicon_tagged"];

		// add HUD icon
		/*level.taggedHUDIcon = newClientHudElem(level.taggedPlayer);
		level.taggedHUDIcon.x = 30;
		level.taggedHUDIcon.y = 95;
		level.taggedHUDIcon.alignX = "center";
		level.taggedHUDIcon.alignY = "middle";
		level.taggedHUDIcon.horzAlign = "left";
		level.taggedHUDIcon.vertAlign = "top";
		iconSize = 40;
		level.taggedHUDIcon setShader(level.hudtaggedicon, iconSize, iconSize);*/
		
		// overlay
		overlay = newClientHudElem(level.taggedPlayer);
		overlay.archived = false;
		overlay.x = 0;
		overlay.y = 0;
		/*if (level.splitscreen) {
			scrnsize = 427;//getdvarint("scr_screensize");
			overlay setshader (level.hudtaggedoverlay, scrnsize, int((scrnsize*3)/4));
		}
		else*/
		overlay setshader (level.hudtaggedoverlay, 640, 480);
		overlay.alignX = "left";
		overlay.alignY = "top";
		overlay.horzAlign = "fullscreen";
		overlay.vertAlign = "fullscreen";
		//overlay.sort = 20;
		
		overlay thread flashOverTime();
		
		level.taggedHUDOverlay = overlay;

		//thread awardTagPoints();
	}
}


flashOverTime()
{
	level endon("tagged_player_changed");
	
	self.alpha = level.taggedOverlayAlphaFlash;
	self fadeOverTime(1.5);
	self.alpha = level.taggedOverlayAlpha;
	wait(1.5);
	
	while(1)
	{
		wait(5.0);
		
		self fadeOverTime(1);
		self.alpha = level.taggedOverlayAlphaFlash;
		wait(1);
		
		self fadeOverTime(1);
		self.alpha = level.taggedOverlayAlpha;
		wait(1);
	}
}
