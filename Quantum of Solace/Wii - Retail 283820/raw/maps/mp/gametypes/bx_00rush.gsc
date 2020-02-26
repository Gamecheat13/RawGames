

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rushcommon;
#include maps\mp\gametypes\_rushobjects;



main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_scorefeedback::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar(level.gameType, 30, 0, 1440);
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar(level.gameType, 100, 0, 500);
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar(level.gameType, 1, 0, 10);
	maps\mp\gametypes\_globallogic::registerNumLivesDvar(level.gameType, 0, 0, 10);
	level.onPrecacheGameType = ::rushPrecache;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerDisconnect = ::onDropOut;		
	level.onDropOut = ::onDropOut;				
	level.onDeathOccurred = ::onDeathOccurred;
	level.onPlayerScore = ::onPlayerScore;
	level.onEndGame = ::onEndGame;
	level.doCountdown = true;
	setDvar("g_teamBased", 0);
}




onStartGameType()
{
	setClientNameMode("auto_change");
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	setMapCenter( maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs ) );
	level.spawnpoints = getentarray("mp_dm_spawn", "classname");

	
	

	rushInit();
	
	level.commonstate = "start";

	logprint("\n##################### STARTING RUSH() THREAD ##################\n");
	setDvar("g_teamBased", 0);
	level thread rush();
}




onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );
	
	self.hasGoldenGun = false;

	self spawn( spawnPoint.origin, spawnPoint.angles );

	
	if (isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
		self updatePlayerHUD();

	self.respawn_penalty = 0;
	self.droppedout = false;
}




onPlayerScore(event,player,victim)
{
	points = 0;

	switch (event)
	{
		
		case "kill":
		case "suicide":
		case "teamkill":
		case "death":
			break;
		case "battleEvaluation":	
			points =  player.battleEvaluationKills * level.points["required_kill"];
			
			break;
		default:					
			points = level.points[event];
			
			break;
	}
	
	curScore = maps\mp\gametypes\_globallogic::_getPlayerScore(player);

	maps\mp\gametypes\_globallogic::_setPlayerScore(player,curScore + points);
	
	player thread maps\mp\gametypes\_scorefeedback::giveScoreFeedback(points);
}




onDeathOccurred( victim, attacker )
{	
	victim.respawn_penalty += 3; 

	
	if (!isDefined(level.currentObjectiveIndex) || (isDefined(level.objectiveDone) && level.objectiveDone))
		return;

	
	if (victim == attacker && !level.splitscreen)
	{
		maps\mp\gametypes\_globallogic::giveRespawnPenalty(victim);
	}
		

	
	
	
	
	
	

	
	switch (level.currentObjectiveIndex)		
	{
		
		case 3:
			if (level.objectiveDone || victim != level.target || ( isDefined( level.assassinationReady ) && !level.assassinationReady ) )
				return;

			level.target.dead = true;
			level.objectiveCompleted = true;
			
			if (victim != attacker && isPlayer(attacker))	
			{
				objectiveCompleted("target_killed",attacker);
			}
			else 
			{
				for (i = 0 ; i < level.players.size ; i++)
				{
					player = level.players[i];
					if (player != level.target && player.sessionstate == "playing")
					{
						player iPrintLnBold(&"MP_OBJECTIVE_COMPLETED");
						maps\mp\gametypes\_globallogic::givePlayerScore("target_killed", player);
					}
				}
				level.target iPrintLnBold(&"MP_OBJECTIVE_FAILED");
			}
			level notify ("objective_done");
			break;

		
		case 4: 
			if( isPlayer(attacker) && attacker != victim)		
			{
				level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
			
				attacker.battleEvaluationKills += 1;
				attacker updatePlayerHUD();
				killsleft = level.requiredKills - attacker.battleEvaluationKills;
				if (killsleft == 0)
				{
					objectiveCompleted("battleEvaluation",attacker);
					level notify ("objective_done");				
				}
				else if (killsleft == 1)
				{
					attacker iPrintLnBold(&"MP_ONE_CANDIDATE_LEFT");
				}
			}
			break;

		default:
			break;
	}
}





rush()
{	
	self waittill("countdown_done");

	level.currentObjectiveIndex	= undefined;

	level endon ("game_ended");

	previousTwo = [];
	previousTwo[0] = -1;
	previousTwo[1] = -1;

	while (1)
	{
		wait(5);	
		
		if(level.splitscreen && !level.game_ready)
			level waittill("game_ready");
			
		
		ok = false;
		while (!ok)
		{
			level.currentObjectiveIndex = randomInt(6);
			if (level.currentObjectiveIndex != previousTwo[0] && level.currentObjectiveIndex != previousTwo[1])
				ok = true;
		}
		previousTwo[1] = previousTwo[0];
		previousTwo[0] = level.currentObjectiveIndex;

		level.objectiveCompleted = false;
		level.objectiveDone = false;

		if (getdvarint("g_rushSpecific") != -1) 
			level.currentObjectiveIndex = getdvarint("g_rushSpecific");

		switch(level.currentObjectiveIndex)
		{
		case 0:
			thread signalReception();
			break;
		case 1:
			thread intelligenceRetrieval();
			break;
		case 2:
			thread computerHacking();
			break;
		case 3:
			thread assassination();
			break;
		case 4:
			thread battleEvaluation();
			break;
		case 5:
			thread assemblyGoldenGun();
			break;
		}
		
		level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_banner");
		
		level waittill("objective_done");
		
		level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_complete");
		
		level.objectiveDone = true;
		clearPlayerHUD();
		
		
		if ( isdefined( level.objPoints ) )
		{
			for ( i = 0; i < level.objPointNames.size; i++ )
			{
				if ( isdefined( level.objPoints[level.objPointNames[i]] ) )
				{
					level.objPoints[level.objPointNames[i]] destroy();
				}
			}
			level.objPoints = [];
			level.objPointNames = [];
		}
	}
}


clearPlayerHUD()
{
	level.objTimerHUD destroyElem();
	for (i = 0 ; i < level.players.size ; i++)
	{
		if(isDefined(level.players[i].sessionstate))
		{
			player = level.players[i];
			player.state = "start";
			player updatePlayerHUD();	
		}

	}
}






updatePlayerHud()
{

	hud_font_scale = level.misc["hud_font_scale"];

	if (isDefined(self.objDescriptionHUD))
		self.objDescriptionHUD setText(" ");
	else
		self.objDescriptionHUD = createFontString("default",hud_font_scale);

	if (isDefined(self.objProgressionHUD))
		self.objProgressionHUD setText(" ");
	else
		self.objProgressionHUD = createFontString("default",hud_font_scale);

	
	
	self.objDescriptionHUD.color = (1,1,1);
	self.objDescriptionHUD setPoint("TOPLEFT",undefined,0,0);

	
	
	self.objProgressionHUD.color = (1,1,1);
	self.objProgressionHUD setPoint("TOPLEFT",undefined,65,25);	

	if (!isDefined(self.state))
		self.state = level.commonstate;

	if (isDefined(level.objectiveDone) && level.objectiveDone)
		return;

	
	switch (self.state)
	{
	case "start":
		
		break;

	
	case "find_briefcase":
		self.objDescriptionHUD setText(&"MP_FIND_BRIEFCASE");
		break;
	case "get_intel_back":
		self.objDescriptionHUD setText(&"MP_GET_INTEL_BACK");
		break;
	case "extraction_point":
		self.objDescriptionHUD setText(&"MP_GO_EXTRACTION_POINT");
		break;


	
	case "reach_signalzone":
		self.objDescriptionHUD setText(&"MP_REACH_SIGNALZONE");
		break;

	case "defend_signalzone":
		self.objDescriptionHUD setText(&"MP_DEFEND_SIGNALZONE");
		break;



	
	case "hack_computer":
		self.objDescriptionHUD setText(&"MP_FIND_HACK_COMPUTER");
		break;

	
	case "survive":
		self.objDescriptionHUD setText(&"MP_SURVIVE");
		break;
	case "dispose_of":
		self.objDescriptionHUD setText(&"MP_DISPOSE_OF",level.target.name);
		break;

	
	case "eliminate_candidates":
		self.objDescriptionHUD setText(&"MP_ELIMINATE_CANDIDATES",level.requiredKills);
		self.objProgressionHUD setText(self.battleEvaluationKills + " / " + level.requiredKills);
		break;


	
	case "assemble_ggun":
		self.objDescriptionHUD setText(&"MP_ASSEMBLE_GOLDEN_GUN");
		self.objProgressionHUD setText(self.ggun_count + " / 3");
                break;
	}
}







objectiveCompleted(event,winner)
{
	level.objectiveCompleted = true;
	maps\mp\gametypes\_globallogic::givePlayerScore(event, winner);
	for ( i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player.sessionstate == "playing")
		{
			if (winner == player)
				player iPrintLnBold(&"MP_OBJECTIVE_COMPLETED");
			else 
				player iPrintLnBold(&"MP_OBJECTIVE_FAILED");
		}
	}
}





signalReception()
{
	thread displayGeneralMessage("MP_SIGNAL_INTERCEPTION");

	logprint("\n******************************* BEGIN OF SIGNALRECEPTION\n");
	level.commonstate = "reach_signalzone";

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "reach_signalzone";
		player updatePlayerHUD();
	}

	signalZoneTrigger = level.signalZones[randomInt(level.signalZones.size)];
	signalZoneVisuals = getent(signalZoneTrigger.target,"targetname");
	signalZoneVisuals.alpha = 0.5;
	signalZone = newRushZoneObject("neutral",signalZoneTrigger, "mp_bx_hud_waypoint_satellite");
	
	signalZone set2DIcon( "friendly", "mp_bx_hud_waypoint_satellite");
	signalZone set3DIcon( "friendly", "mp_bx_hud_waypoint_satellite");
	signalZone set2DIcon( "enemy", "mp_bx_hud_waypoint_satellite");
	signalZone set3DIcon( "enemy", "mp_bx_hud_waypoint_satellite" );
	signalZone setVisibleTeam( "any" );
	signalZone setOwnerTeam( "any" );
	
	
	
	signalZone thread zoneObjectReceptionThink();

	
	
	

	
	signalZoneVisuals show();

	setupObjective(level.timers["short"]);
	level waittill("objective_done");
	
	level.objectiveDone = true;
	signalZoneVisuals hide();
	
	signalZone setVisibleTeam( "none" );
	
	signalZone deleteObjPoint();
	logprint("\n******************************* END OF SIGNALRECEPTION\n");
}





zoneObjectReceptionThink()
{
	level endon("game_ended");	

	self.playersInside = [];
	syncTime = 5000;

	while (!level.objectiveDone)
	{	
		wait (0.10);

		for (i = 0 ; i < level.players.size ; i++)
		{
			player = level.players[i];
			
			
			pos = -1;
			for (j = 0 ; j < self.playersInside.size; j++)
			{
				if (self.playersInside[j] == player)
				{
					pos = j;
					break;
				}
			}
			
			
			if (!isAlive(player) || player.sessionstate != "playing" || ! player isTouching(self.trigger))
			{
				player.inSync = undefined;
				
				if (pos != -1)
				{
					player.state = "reach_signalzone";
					player updatePlayerHUD();
					player.insideZone = undefined;
					
					for (j = pos ; j < self.playersInside.size - 1 ; j++)
					{
						self.playersInside[j] = self.playersInside[j+1];
					}
					self.playersInside[self.playersInside.size - 1] = undefined;
				}
				continue;
			}
	

			
			
			if (!isDefined(player.inSync))
			{
				player.inSync = true;
				player.signalProgress = 0;
				player iPrintLnBold(&"MP_SYNCHING_SATELLITE");
				player thread syncBar(syncTime);
			}

			player.signalProgress += 100;

			if (player.signalProgress >= syncTime)
			{
				
				player.inSync = false;
				if (pos == -1)
				{
					level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
					
					self.playersInside[self.playersInside.size] = player;
					player.insideZone = true;
					player iPrintLnBold(&"MP_READY_RECEIVE_SIGNAL");
					player.state = "defend_signalzone";
					player updatePlayerHUD();
				}
			}
		}
	}	
	

	
	giveReceptionZoneScores(self);

	

	
	
	
	for (i = 0 ; i < level.players.size; i++)
	{
		player = level.players[i];
		if (player.sessionstate == "playing")
		{
			if (isDefined(player.insideZone) && player.insideZone)
			{
				player iPrintLnBold(&"MP_OBJECTIVE_COMPLETED");
			}
			else
			{
				player iPrintLnBold(&"MP_OBJECTIVE_FAILED");
			}
		}
		player.enteredZone = undefined;
		player.insideZone = undefined;
		player.inSync = undefined;
	}
}





giveReceptionZoneScores(zone)
{

	
	if (!zone.playersInside.size)
		return;

	playersPlaying = [];

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player.sessionstate == "playing")
		{
			playersPlaying[playersPlaying.size] = player;
		}
	}

	
	if (!playersPlaying.size)
		return;

	pointsTotal = level.points["signal_perplayer"] * playersPlaying.size;	
	pointsPerPlayer = int(pointsTotal / zone.playersInside.size);			
	logprint("\nminimum points per player: " + pointsPerPlayer);
	extraPoints = pointsTotal % zone.playersInside.size;					
	logprint("\nextra points to distribute: " + extraPoints);
	for (i = 0 ; i < zone.playersInside.size; i++)
	{
		playerInside = zone.playersInside[i];

		
		playerPoints = pointsPerPlayer;

		
		
		if (i < extraPoints)
		{
			playerPoints++;
		}
		
		
		
		
		curScore = maps\mp\gametypes\_globallogic::_getPlayerScore(playerInside);
		maps\mp\gametypes\_globallogic::_setPlayerScore(playerInside,int(curScore + playerPoints));
		playerInside thread maps\mp\gametypes\_scorefeedback::giveScoreFeedback(playerPoints);
	}
}












intelligenceRetrieval()
{	
	logprint("\n******************************* BEGIN OF INTEL\n");
	level endon ("game_ended");

	
	
	thread displayGeneralMessage("MP_INTEL_RETRIEVAL");
	
	
	intelIndex = randomInt(level.intelLocations.size);
	intelTrigger = level.intelLocations[intelIndex];
	extractIndex = getGoodExtractZoneIndex(intelTrigger);
	extractTrigger = level.intelExtracts[extractIndex];

	
	intel = newRushCarryObject("neutral",intelTrigger,level.intelVisuals, "mp_bx_hud_waypoint_briefcase");
	intel set2DIcon( "friendly", "mp_bx_hud_waypoint_briefcase");
	intel set3DIcon( "friendly", "mp_bx_hud_waypoint_briefcase");
	intel set2DIcon( "enemy", "mp_bx_hud_waypoint_briefcase");
	intel set3DIcon( "enemy", "mp_bx_hud_waypoint_briefcase" );
	intel allowCarry( "any" );
	intel setVisibleTeam( "any" );
	intel dropOnGround();
	intel thread object_fx(level.glow_fx);
	intel.onPickup = ::onIntelPickup;
	intel.onDrop = ::onIntelDrop;

	
	level.extract = newRushZoneObject("neutral",extractTrigger,level.extractVisuals, "mp_bx_hud_waypoint_exit");
	level.extract setVisibleTeam( "none" );
	level.extract.onEnter = ::onExtractEnter;

	setupObjective(level.timers["short"]); 
	
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "find_briefcase";
		player updatePlayerHUD();
	}

	level.commonstate = "find_briefcase";

	level waittill("objective_done");

	intel.end = true;

	if(intel.firstPickupDone)
	{
		
		
		logprint(":**SCRIPT**: Deleting obj points of extraction zone");
		level.extract setVisibleTeam( "none" );
		level.extract deleteObjPoint();

	}
	
	
	if (!level.objectiveCompleted)
	{
		intel setDropped();
		iPrintLnBold(&"MP_OBJECTIVE_FAILED");	
	}
	
	intel returnHome();
	level.extract disableZone();
	
	intel setVisibleTeam( "none" );
	

	intel deleteObjPoint();
	logprint("\n******************************* END OF INTEL\n");

}





onIntelPickup(carrier) 
{
	level.extract setVisibleTeam( "any" );
	level.extract enableZone();
	level.extract dropOnGround();

	level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
	
	
	if (!self.firstPickupDone)		
	{
		maps\mp\gametypes\_globallogic::givePlayerScore("intel_gathered", carrier);
		
	}
	self.firstPickupDone = true;

	level.extract set2DIcon( "friendly", "mp_bx_hud_waypoint_exit");
	level.extract set3DIcon( "friendly", "mp_bx_hud_waypoint_exit");
	level.extract set2DIcon( "enemy", "mp_bx_hud_waypoint_exit");
	level.extract set3DIcon( "enemy", "mp_bx_hud_waypoint_exit" );
	level.extract setVisibleTeam( "any" );
	level.extract setOwnerTeam( "any" );


	carrier.state = "extraction_point";
	carrier iPrintLnBold(&"MP_YOU_GOT_BRIEFCASE");	
	
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player != carrier)
		{
			player.state = "get_intel_back";
			player iPrintLnBold(&"MP_HAS_BRIEFCASE",carrier.name);
		}
		player updatePlayerHUD();
	}
	level.commonstate = "get_intel_back";
}





onIntelDrop(carrier)
{

	level.extract setVisibleTeam( "none" );
	level.extract setOwnerTeam( "any" );

	level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
	
	if (level.objectiveCompleted)
		return;

	level.extract disableZone();
	if (!self.end)	
	{
		iPrintLnBold(&"MP_BRIEFCASE_DROPPED");
		for (i = 0 ; i < level.players.size ; i++)
		{
			player = level.players[i];
			player.state = "find_briefcase";
			player updatePlayerHUD();
		}
		level.commonstate = "find_briefcase";
		self thread object_fx(level.glow_fx);
	}
}







onExtractEnter(player)	
{
	if (!player.carryObjects.size)			
			return;
	objectiveCompleted("intel_extracted",player);
	level notify("objective_done");
}









computerHacking()
{
	logprint("\n******************************* BEGIN OF CPU HACK\n");
	thread displayGeneralMessage("MP_COMPUTER_HACKING");

	
	if (getdvarint("g_rushSpecific") == -1)
	{
		level.computerToHack = randomInt(level.computerLocations.size);
	}
	else
	{
		if (!isDefined(level.computerToHack))
			level.computerToHack = 0;
		else
			level.computerToHack++;
		
		if (level.computerToHack == level.computerLocations.size)
		{
			iprintlnbold("*** NOW PICKED EVERY COMPUTER LOCATION AT LEAST ONCE ***");
			level.computerToHack = 0;
		}
	}

	
	computerTrigger = level.computerLocations[level.computerToHack]; 
	computer = newRushUseObject("neutral",computerTrigger,&"MP_HACK_COMPUTER","HINT_ACTIVATE_HOLD", "mp_bx_hud_waypoint_computer");
	computer set2DIcon( "friendly", "mp_bx_hud_waypoint_computer");
	computer set3DIcon( "friendly", "mp_bx_hud_waypoint_computer");
	computer set2DIcon( "enemy", "mp_bx_hud_waypoint_computer");
	computer set3DIcon( "enemy", "mp_bx_hud_waypoint_computer" );
	computer setVisibleTeam( "any" );
	computer allowUse("any");
	computer.onBeginUse = ::onBeginHack;
	computer.onEndUse = ::onEndHack;
	computer enableHints();
	computer thread object_fx(level.glow_fx);

	setupObjective(level.timers["medium"]);

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "hack_computer";
		player updatePlayerHUD();
	}

	level.commonstate = "hack_computer";

	level waittill("objective_done");

	computer disableHints();
	computer.visuals hide();

	if (!level.objectiveCompleted)
		iPrintLnBold(&"MP_OBJECTIVE_FAILED");	
		
	computer setVisibleTeam( "none" );
	computer deleteObjPoint();
	logprint("\n******************************* END OF CPU HACK\n");
}





onBeginHack(hacker)
{
	self disableHints();
	hacker iPrintLnBold(&"MP_HACKING");
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player != hacker)
			player iPrintLnBold(&"MP_HACK_IN_PROGRESS");
			
		level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_hack");
	}
}





onEndHack(hacker,result)
{
	if (result)
	{
		objectiveCompleted("computer_hacked",hacker);
		level notify ("objective_done");
	}
	else if (isDefined(level.objectiveDone) && !level.objectiveDone)
		self enableHints();
}








assassination()
{
	
	level.assassinationReady = false;
	
	logprint("\n******************************* BEGIN OF ASSASSINATION \n");
	level endon ("game_ended");

	
	
	possibleTargets = [];

	while (!possibleTargets.size) 
	{
		wait 0.05;
		for (i = 0 ; i < level.players.size ; i++)
		{	
			player = level.players[i];
			if (player.sessionstate == "playing")
			{
				possibleTargets[possibleTargets.size] = player;
			}
		}
	}

	level.target = possibleTargets[randomInt(possibleTargets.size)];
	level.target.dead = false;		
	level.target.droppedOutAssasination = false;
	
	offset = (0,0,16);
		
	
	level.target.compassIcons = [];
	level.target.objIDAllies = getNextObjID();
	level.target.objIDAxis = getNextObjID();
	level.target.objIDPingFriendly = true;
	level.target.objIDPingEnemy = true;
	objective_add( level.target.objIDAllies, "active", level.target.Origin +offset);
	objective_add( level.target.objIDAxis, "active", level.target.Origin+offset);
	
	level.target.entNum = level.target getEntityNumber();


	objective_team( level.target.objIDAllies, "none" );
	objective_team( level.target.objIDAxis, "none" );
	level.target.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + level.target.entNum, level.target.Origin + offset, "all", undefined,1.0,1.0 );
	level.target.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + level.target.entNum, level.target.Origin + offset, "all", undefined,1.0,1.0 );

	level.target.objPoints["allies"].alpha = 1.0;
	level.target.objPoints["axis"].alpha = 1.0;
	level.target.visibleTeam = "none";
	level.target.type = "playerTarget";
	level.target.ownerTeam = "neutral";
	
	
	level.target set2DIcon( "friendly", "mp_bx_hud_waypoint_target");
	level.target set3DIcon( "friendly", "mp_bx_hud_waypoint_target");
	level.target set2DIcon( "enemy", "mp_bx_hud_waypoint_target");
	level.target set3DIcon( "enemy", "mp_bx_hud_waypoint_target" );
	level.target setVisibleTeam( "any" );
	
	level.target.state = "survive";
        level.target iPrintLnBold(&"MP_BEEN_TARGETED");
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player != level.target)
			player.state = "dispose_of";
		player updatePlayerHUD();
	}
		
	level.commonstate = "dispose_of";

	
	
	
	thread displayGeneralMessage("MP_ASSASSINATION");
	
	setupObjective(level.timers["short"]);
	
	level.assassinationReady = true;
	
	level waittill("objective_done");

	if (!level.target.dead)			
	{
		objectiveCompleted("target_survived",level.target);
	}
	
	if( !level.target.droppedOutAssasination )
	{
		level.target setVisibleTeam( "none" );
		level.target deleteObjPoint();
	}
	logprint("\n******************************* END OF ASSASSINATION\n");
}









battleEvaluation()
{
	
	thread displayGeneralMessage("MP_COMBAT_EVALUATION");

	level.requiredKills = getNumberOfTargets();

	
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.battleEvaluationKills = 0;
		player.state = "eliminate_candidates";
		player updatePlayerHUD();
	}

	level.commonstate = "eliminate_candidates";

	setupObjective(level.timers["perkill"] * level.requiredKills);

	level waittill("objective_done");

	if (!level.objectiveCompleted)			
		iPrintLnBold(&"MP_OBJECTIVE_FAILED");

}





assemblyGoldenGun()
{
	logprint("\n******************************* BEGIN OF GGUN\n");
	
	thread displayGeneralMessage("MP_GOLDEN_GUN");

	
	p1index = randomInt(level.ggunLocations.size);
	p2index = randomInt(level.ggunLocations.size);
	p3index = randomInt(level.ggunLocations.size);

	while (p1index == p2index || p2index == p3index || p1index == p3index)
	{
		p2index = randomInt(level.ggunLocations.size);
		p3index = randomInt(level.ggunLocations.size);
	}

	p1trigger = level.ggunLocations[p1index];
	p2trigger = level.ggunLocations[p2index];
	p3trigger = level.ggunLocations[p3index];

	
	p1 = newRushCarryObject("neutral",p1trigger,level.ggunP1Visuals, "mp_bx_hud_waypoint_golden_gun_p1");
	p1 set2DIcon( "friendly", "mp_bx_hud_waypoint_golden_gun_p1");
	p1 set3DIcon( "friendly", "mp_bx_hud_waypoint_golden_gun_p1");
	p1 set2DIcon( "enemy", "mp_bx_hud_waypoint_golden_gun_p1");
	p1 set3DIcon( "enemy", "mp_bx_hud_waypoint_golden_gun_p1" );
	p1 allowCarry( "any" );
	p1 setVisibleTeam( "any" );
	p1 thread object_fx(level.glow_fx);
	p1.onPickup = ::onGoldenGunPickup;
	p1.onEndDrop = ::onGoldenGunEndDrop;

	
	p2 = newRushCarryObject("neutral",p2trigger,level.ggunP2Visuals, "mp_bx_hud_waypoint_golden_gun_p2");
	p2 set2DIcon( "friendly", "mp_bx_hud_waypoint_golden_gun_p2");
	p2 set3DIcon( "friendly", "mp_bx_hud_waypoint_golden_gun_p2");
	p2 set2DIcon( "enemy", "mp_bx_hud_waypoint_golden_gun_p2");
	p2 set3DIcon( "enemy", "mp_bx_hud_waypoint_golden_gun_p2" );
	p2 allowCarry( "any" );
	p2 setVisibleTeam( "any" );
	p2 thread object_fx(level.glow_fx);
	p2.onPickup = ::onGoldenGunPickup;
	p2.onEndDrop = ::onGoldenGunEndDrop;

	
	p3 = newRushCarryObject("neutral",p3trigger,level.ggunP3Visuals, "mp_bx_hud_waypoint_golden_gun_p3");
	p3 set2DIcon( "friendly", "mp_bx_hud_waypoint_golden_gun_p3");
	p3 set3DIcon( "friendly", "mp_bx_hud_waypoint_golden_gun_p3");
	p3 set2DIcon( "enemy", "mp_bx_hud_waypoint_golden_gun_p3");
	p3 set3DIcon( "enemy", "mp_bx_hud_waypoint_golden_gun_p3" );

	p3 allowCarry( "any" );
	p3 setVisibleTeam( "any" );
	p3 thread object_fx(level.glow_fx);
	p3.onPickup = ::onGoldenGunPickup;
	p3.onEndDrop = ::onGoldenGunEndDrop;

	
	setupObjective(level.timers["medium"]);

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.ggun_count = 0;
		player.state = "assemble_ggun";
		player updatePlayerHUD();
	}

	level.commonstate = "assemble_ggun";

	level waittill("objective_done");

	p1.end = true;
	p2.end = true;
	p3.end = true;

	
	if (!level.objectiveCompleted)			
	{
		
		p1 setDropped();	
		p2 setDropped();	
		p3 setDropped();	
		iPrintLnBold(&"MP_OBJECTIVE_FAILED");
	}

	p1 returnHome();
	p2 returnHome();
	p3 returnHome();

	p1 setVisibleTeam( "none" );
	p2 setVisibleTeam( "none" );
	p3 setVisibleTeam( "none" );
	
	p1 deleteObjPoint();
	p2 deleteObjPoint();
	p3 deleteObjPoint();
	logprint("\n******************************* END OF GGUN\n");
	
}





onGoldenGunPickup(carrier) 
{
	carrier.ggun_count++;
	carrier iPrintLnBold(&"MP_FOUND_GOLDEN_GUN_PART");
	carrier updatePlayerHUD();
	
	
	if (carrier.ggun_count == 3)
	{
		carrier giveGoldenGun(); 
		objectiveCompleted("goldengun_assembled",carrier);
		level notify ("objective_done");
	}
	else
	{
		level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
	}
}





onGoldenGunEndDrop(carrier)
{
	if (!self.end && isDefined(carrier))
	{
		carrier.ggun_count--;
		carrier updatePlayerHUD();
		self thread object_fx(level.glow_fx);
	}
}






giveGoldenGun()
{
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	if (!self.hasGoldenGun)		
	{
		
		self.preGoldenGunWeapon = self getCurrentWeapon();

		
		self takeWeapon(self.preGoldenGunWeapon,0);

		
		self GiveWeapon( level.golden_gun_weapon );
	}
	else
		self GiveMaxAmmo( level.golden_gun_weapon );

	self SwitchToWeapon( level.golden_gun_weapon );
	self.pers["weapon"] = level.golden_gun_weapon;

	
	
	

	self.hasGoldenGun = true;
	self thread checkGoldenGunAmmo();
}



