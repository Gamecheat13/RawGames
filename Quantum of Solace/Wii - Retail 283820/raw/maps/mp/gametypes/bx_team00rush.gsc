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
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerDisconnect = ::onDropOut;		
	level.onDropOut = ::onDropOut;				
	level.onTeamScore = ::onTeamScore;
	level.onDeathOccurred = ::onDeathOccurred;
	level.onEndGame = ::onEndGame;
	level.doCountdown = true; 
	level.teamBased = true;
	setDvar("g_teamBased", 1);
	level.overridePlayerScore = true;		
											
}




onPrecacheGameType()
{
	rushPrecache();
	precacheString(&"MP_DEFEND_INTELLIGENCE");
	precacheString(&"MP_DEFEND_PLAYER");
}




onStartGameType()
{
	setClientNameMode("auto_change");
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	setMapCenter( maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs ) );
	level.spawnpoints = getentarray("mp_tdm_spawn", "classname");

	
	

	rushInit();

	level.allies_commonstate = "start";
	level.axis_commonstate = "start";
	
	logprint("\n##################### STARTING RUSH() THREAD ##################\n");
	setDvar("g_teamBased", 1);
	level thread rush();
}




onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	
	self.hasGoldenGun = false;
	self spawn( spawnPoint.origin, spawnPoint.angles );

	
	if (isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
		self updatePlayerHUD();

	self.respawn_penalty = 0;
	self.droppedout = false;
}




onTeamScore(event,team,player,victim)
{
	teamPoints = 0;

	switch (event)
	{
		case "kill":
			break;	
		case "battleEvaluation":
			teamPoints = level.requiredKills * level.points["required_kill"];
			break;
		default:
			teamPoints = level.points[event];
			break;
	}
	
	level.teamScores[team] += teamPoints;
    
    if (level.teamScores[team] < 0)
		level.teamScores[team] = 0;

	thread maps\mp\gametypes\_scorefeedback::giveTeamScoreFeedback(team,teamPoints);
}



onDeathOccurred( victim, attacker )
{
	victim.respawn_penalty += 3; 

	
	if (!isDefined(level.currentObjectiveIndex) || (isDefined(level.objectiveDone) && level.objectiveDone))
		return;

	if (isPlayer(attacker))
	{
		attacker_team = attacker.pers["team"];
	}
	else 
	{
		attacker_team = victim.pers["team"];
	}

	victim_team = victim.pers["team"];
	
	if ((victim == attacker || victim_team == attacker_team) && !level.splitscreen)
	{
		maps\mp\gametypes\_globallogic::giveRespawnPenalty(victim);
	}
	
	
	
	switch (level.currentObjectiveIndex)		
	{
		case 3:	
			if (victim != level.target || level.objectiveDone || ( isDefined( level.assassinationReady ) && !level.assassinationReady ) )
				return;

			level.target.dead = true;
			if (isPlayer(attacker))	
			{
				if (victim == attacker || victim_team == attacker_team)	
				{
					
					if (victim_team == "axis")
						objectiveCompleted("target_killed","allies");
					else 
						objectiveCompleted("target_killed","axis");
				}
				else
				{
					if (attacker_team == "axis")
						objectiveCompleted("target_killed","axis");
					else
						objectiveCompleted("target_killed","allies");
				}
			}
			else	
			{
				
				if (victim_team == "axis")
					objectiveCompleted("target_killed","allies");
				else 
					objectiveCompleted("target_killed","axis");
			}
			level notify ("objective_done");
			break;
		case 4: 
			if( isPlayer(attacker) && attacker != victim && attacker_team != victim.pers["team"])		
			{
				beKills = undefined;		

				level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
				
				if (attacker_team == "axis")
				{
					level.axis_be_kills++;
					beKills = level.axis_be_kills;
				}
				else 
				{
					level.allies_be_kills++;
					beKills = level.allies_be_kills;
				}

				killsleft = level.requiredKills - beKills;
				for (i = 0; i < level.players.size; i++)		
				{
					player = level.players[i];
					if (player.pers["team"] == attacker_team) 
					{
						player updatePlayerHUD();
						if (killsleft == 1)
							player iPrintLnBold(&"MP_ONE_CANDIDATE_LEFT");
					}
				}
				if (killsleft == 0)
				{
					objectiveCompleted("battleEvaluation",attacker_team);
					level notify ("objective_done");				
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
	{
		if (self.pers["team"] == "axis")
			self.state = level.axis_commonstate;
		else 
			self.state = level.allies_commonstate;
	}

	if (isDefined(level.objectiveDone) && level.objectiveDone)
		return;
	
	if (self.pers["team"] == "axis")
	{
		if (!isDefined(self.state))
			self.state = level.axis_commonstate;
		be_kills = level.axis_be_kills;
		ggun_count = level.axis_ggun_count;
	}
	else
	{
		if (!isDefined(self.state))
			self.state = level.allies_commonstate;
		be_kills = level.allies_be_kills;
		ggun_count = level.allies_ggun_count;
	}

	
	switch (self.state)
	{
	case "start":
		
		break;

	
	case "find_briefcase":
		self.objDescriptionHUD setText(&"MP_FIND_BRIEFCASE");
		break;
	case "got_briefcase":
		self.objDescriptionHUD setText(&"MP_YOU_GOT_BRIEFCASE");
		break;
	case "extraction_point":
		self.objDescriptionHUD setText(&"MP_GO_EXTRACTION_POINT");
		break;
	case "defend_intel":
		self.objDescriptionHUD setText(&"MP_DEFEND_INTELLIGENCE");
		break;
	case "get_intel_back":
		self.objDescriptionHUD setText(&"MP_GET_INTEL_BACK");
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
	case "defend_player":
		self.objDescriptionHUD setText(&"MP_DEFEND_PLAYER",level.target.name);
		break;

	
	case "eliminate_candidates":
		self.objDescriptionHUD setText(&"MP_ELIMINATE_CANDIDATES",level.requiredKills);
		self.objProgressionHUD setText(be_kills + " / " + level.requiredKills);
		break;

	
	case "assemble_ggun":
		self.objDescriptionHUD setText(&"MP_ASSEMBLE_GOLDEN_GUN");
		self.objProgressionHUD setText(ggun_count + " / 3");
        break;
	}
}






objectiveCompleted(event,winner_team)
{
	level.objectiveCompleted = true;
	maps\mp\gametypes\_globallogic::giveTeamScore(event, winner_team);

	for ( i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player.sessionstate == "playing")
		{
			if (player.pers["team"] == winner_team)
				player iPrintLnBold(&"MP_OBJECTIVE_COMPLETED");
			else 
				player iPrintLnBold(&"MP_OBJECTIVE_FAILED");
		}
	}
}











signalReception()
{
	thread displayGeneralMessage("MP_SIGNAL_INTERCEPTION");

	level.axis_commonstate = "reach_signalzone";
	level.allies_commonstate = "reach_signalzone";

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "reach_signalzone";
		player updatePlayerHUD();
	}

	signalZoneTrigger = level.signalZones[randomInt(level.signalZones.size)];
	signalZoneVisuals = getent(signalZoneTrigger.target,"targetname");
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

}





zoneObjectReceptionThink()
{
	level endon("game_ended");	

	syncTime = 5000; 

	while (!level.objectiveDone)
	{	
		wait (0.10);

		self.alliesNumInside = 0;
		self.axisNumInside = 0;

		for (i = 0 ; i < level.players.size ; i++)
		{
			player = level.players[i];
			
			
			if (!isAlive(player) || player.sessionstate != "playing" || ! player isTouching(self.trigger))
			{
				player.insideZone = false;
				player.state = "reach_signalzone";
				player updatePlayerHUD();
				player.inSync = undefined;
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
				if (!isDefined(player.insideZone) || !player.insideZone)
				{
					player.insideZone = true;
					player iPrintLnBold(&"MP_READY_RECEIVE_SIGNAL");
					level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
				}
				player.inSync = false;
				player.state = "defend_signalzone";
				player updatePlayerHUD();
				if (player.pers["team"] == "axis")
					self.axisNumInside++;
				else
					self.alliesNumInside++;
			}
		}
	}	

	
	maps\mp\gametypes\_teams::regenerateTeamPlayingArrays();
	giveReceptionZoneScores(self);

	
	
	for (i = 0 ; i < level.players.size; i++)
	{
		player = level.players[i];
		completed = false;
		if (player.pers["team"] == "axis")
		{
			if (self.axisNumInside > 0)
				completed = true;
		}
		else if (self.alliesNumInside > 0)
		{
			completed = true;
		}

		if (completed)
			player iPrintLnBold(&"MP_OBJECTIVE_COMPLETED");
		else
			player iPrintLnBold(&"MP_OBJECTIVE_FAILED");

		player.insideZone = undefined;
		player.inSync = undefined;
	}
}





giveReceptionZoneScores(zone)
{
	playersPlaying = level.axisplaying.size + level.alliesplaying.size;
	pointsTotal = level.points["signal_perplayer"] * playersPlaying;

	
	
	
	if (level.splitscreen && level.axisplaying.size == 3 && level.alliesplaying.size == 1)
	{	
		
		if (zone.alliesNumInside == 0)
		{
			axisScore = zone.axisNumInside * 4;
			alliesScore = 0;
		}
		
		else 
		{
			
			if (zone.axisNumInside != 0)
			{
				axisScore = zone.axisNumInside + 1;
				alliesScore = (zone.axisNumInside * 3) - 1;
			}
			
			else 
			{
				axisScore = 0;
				alliesScore = pointsTotal;
			}
		}
	}
	else if(level.splitscreen && level.alliesplaying.size == 3 && level.axisplaying.size == 1)
	{

		
		if (zone.axisNumInside == 0)
		{
			alliesScore = zone.alliesNumInside * 4;
			axisScore = 0;
		}
		
		else 
		{
			
			if (zone.alliesNumInside != 0)
			{
				alliesScore = zone.alliesNumInside + 1;
				axisScore = (zone.alliesNumInside * 3) - 1;
			}
			
			else 
			{
				alliesScore = 0;
				axisScore = pointsTotal;
			}
		}
	}
	
	
	
	else
	{
		axisScore = (zone.axisNumInside * 4) - (zone.alliesNumInside * 2);
		alliesScore = (zone.alliesNumInside * 4) - (zone.axisNumInside * 2);

		
		if (axisScore < 0)
			axisScore = 0;
		if (alliesscore < 0)
			alliesScore = 0;
	}

	
	
	maps\mp\gametypes\_globallogic::_setTeamScore("axis", getTeamScore("axis") + axisScore);
	maps\mp\gametypes\_scorefeedback::giveTeamScoreFeedback("axis",axisScore);
	maps\mp\gametypes\_globallogic::_setTeamScore("allies", getTeamScore("allies") + alliesScore);
	maps\mp\gametypes\_scorefeedback::giveTeamScoreFeedback("allies",alliesScore);
}






intelligenceRetrieval()
{	
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
	intel setOwnerTeam( "any" );
	intel dropOnGround();
	intel thread object_fx(level.glow_fx);
	intel.onPickup = ::onIntelPickup;
	intel.onDrop = ::onIntelDrop;

	
	level.extract = newRushZoneObject("neutral",extractTrigger,level.extractVisuals);
	level.extract setVisibleTeam( "none" );
	level.extract.onEnter = ::onExtractEnter;

	setupObjective(level.timers["short"]);
	
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "find_briefcase";
		player updatePlayerHUD();
	}

	level.axis_commonstate = "find_briefcase";
	level.allies_commonstate = "find_briefcase";

	level waittill("objective_done");

	intel.end = true;


	
	if(intel.firstPickupDone)
	{
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
}





onIntelPickup(carrier) 
{
	carrier_team = carrier.pers["team"];
	level.extract setVisibleTeam( "any" );
	level.extract enableZone();
	level.extract dropOnGround();

	level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_progress");
	
	
	if (!self.firstPickupDone)		
	{
		maps\mp\gametypes\_globallogic::giveTeamScore("intel_gathered", carrier_team);
	}

	self.firstPickupDone = true;
	
	level.extract set2DIcon( "friendly", "mp_bx_hud_waypoint_exit");
	level.extract set3DIcon( "friendly", "mp_bx_hud_waypoint_exit");
	level.extract set2DIcon( "enemy", "mp_bx_hud_waypoint_exit");
	level.extract set3DIcon( "enemy", "mp_bx_hud_waypoint_exit" );
	level.extract setVisibleTeam( "any" );
	level.extract setOwnerTeam( "any" );

	carrier iPrintLnBold(&"MP_YOU_GOT_BRIEFCASE");	
	carrier.state = "extraction_point";
	
	if (carrier_team == "axis")
	{
		level.axis_commonstate = "defend_intel";
		level.allies_commonstate = "get_intel_back";
	}	
	else
	{
		level.axis_commonstate = "get_intel_back";
		level.allies_commonstate = "defend_intel";	
	}

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player != carrier)
		{
			if (player.pers["team"] == carrier_team)
				player.state = "defend_intel";
				
			else
				player.state = "get_intel_back";
			player iPrintLnBold(&"MP_HAS_BRIEFCASE",carrier.name);
		}
		player updatePlayerHUD();
	}
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
		self thread object_fx(level.glow_fx);
		
	}
	level.axis_commonstate = "find_briefcase";
	level.allies_commonstate = "find_briefcase";
}





onExtractenter(player)
{
	if (!player.carryObjects.size)			
		return;

	objectiveCompleted("intel_extracted",player.pers["team"]);
	level notify("objective_done");
}









computerHacking()
{
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
	computer setOwnerTeam( "any" );
	computer allowUse("any");
	computer.onBeginUse = ::onBeginHack;
	computer.onEndUse = ::onEndHack;
	computer enableHints();
	computer thread  object_fx(level.glow_fx);
	
	setupObjective(level.timers["medium"]);

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "hack_computer";
		player updatePlayerHUD();
	}

	level.allies_commonstate = "hack_computer";
	level.axis_commonstate = "hack_computer";

	level waittill("objective_done");


	computer disableHints();
	computer.visuals hide();

	if (!level.objectiveCompleted)
		iPrintLnBold(&"MP_OBJECTIVE_FAILED");	

	computer setVisibleTeam( "none" );
	computer deleteObjPoint();
	
}





onBeginHack(hacker)
{
	self disableHints();
	hacker iPrintLnBold(&"MP_HACKING");
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		
		level thread maps\mp\_utility::playSoundOnPlayers("wii_mp_obj_hack");
		
		if (player != hacker)
			player iPrintLnBold(&"MP_HACK_IN_PROGRESS");
	}
}





onEndHack(hacker,result)
{
	if (result)
	{
		objectiveCompleted("computer_hacked",hacker.pers["team"]);
		level notify ("objective_done");
	}
	else if (isDefined(level.objectiveDone) && !level.objectiveDone)
		self enableHints();
}









assassination()
{
	level.assassinationReady = false;
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
	
	objective_team( level.target.objIDAllies, "allies" );
	objective_team( level.target.objIDAxis, "axis" );
	level.target.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + level.target.entNum, level.target.Origin + offset, "allies", "mp_bx_hud_waypoint_target",1.0,1.0 );
	level.target.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + level.target.entNum, level.target.Origin + offset, "axis", "mp_bx_hud_waypoint_target",1.0,1.0 );

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
	
	level.target iPrintLnBold(&"MP_BEEN_TARGETED");
	level.target.state = "survive";
	
	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player != level.target)
		{
			if (player.pers["team"] == level.target.pers["team"])
				player.state = "defend_player";
			else
				player.state = "dispose_of";
		}
		player updatePlayerHUD();
	}

	if (level.target.pers["team"] == "axis")
	{
		level.allies_commonstate = "dispose_of";
		level.axis_commonstate = "defend_player";
	}
	else
	{
		level.allies_commonstate = "defend_player";
		level.axis_commonstate = "dispose_of";
	}
	
	
	thread displayGeneralMessage("MP_ASSASSINATION");
	
	setupObjective(level.timers["short"]);
	
	level.assassinationReady = true;
	
	level waittill("objective_done");

	if (!level.target.dead)			
	{
		objectiveCompleted("target_survived",level.target.pers["team"]);
	}

	if( !level.target.droppedOutAssasination )
	{
		level.target setVisibleTeam( "none" );
		level.target deleteObjPoint();
	}
}









battleEvaluation()
{
	
	thread displayGeneralMessage("MP_COMBAT_EVALUATION");

	level.requiredKills = getNumberOfTargets();

	
	level.axis_be_kills = 0;
	level.allies_be_kills = 0;

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "eliminate_candidates";
		player updatePlayerHUD();
	}

	level.axis_commonstate = "eliminate_candidates";
	level.allies_commonstate = "eliminate_candidates";

	setupObjective(level.timers["perkill"] * level.requiredKills);

	level waittill("objective_done");

	if (!level.objectiveCompleted)			
		iPrintLnBold(&"MP_OBJECTIVE_FAILED");
}









assemblyGoldenGun()
{
	
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
	p1 setOwnerTeam( "any" );
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
	p2 setOwnerTeam( "any" );
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
	p3 setOwnerTeam( "any" );
	p3 thread object_fx(level.glow_fx);
	p3.onPickup = ::onGoldenGunPickup;
	p3.onEndDrop = ::onGoldenGunEndDrop;

	level.axis_ggun_count = 0;
	level.allies_ggun_count = 0;
	
	setupObjective(level.timers["medium"]);

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		player.state = "assemble_ggun";
		player updatePlayerHUD();
		
	}

	level.axis_commonstate = "assemble_ggun";
	level.allies_commonstate = "assemble_ggun";

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

	level.axis_ggun_count = undefined;
	level.allies_ggun_count = undefined;
	
	p1 setVisibleTeam( "none" );
	p2 setVisibleTeam( "none" );
	p3 setVisibleTeam( "none" );
	
	p1 deleteObjPoint();
	p2 deleteObjPoint();
	p3 deleteObjPoint();
}




onGoldenGunPickup(carrier) 
{
	carrier_team = carrier.pers["team"];
	
	ggun_count = undefined;
	
	if (carrier_team == "axis")
	{
		level.axis_ggun_count++;
		ggun_count = level.axis_ggun_count;
	}
	else
	{
		level.allies_ggun_count++;
		ggun_count = level.allies_ggun_count;
	}

	for (i = 0 ; i < level.players.size ; i++)
	{
		player = level.players[i];
		if (player.pers["team"] == carrier_team)
		{
			player iPrintLnBold(&"MP_FOUND_GOLDEN_GUN_PART");
			player updatePlayerHUD();
		}
	}

	
	if (ggun_count == 3)
	{
		giveGoldenGun(carrier_team);
		objectiveCompleted("goldengun_assembled",carrier_team);
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
		carrier_team = carrier.pers["team"];
		ggun_count = undefined;
		if (carrier_team == "axis")
		{
			level.axis_ggun_count--;
			ggun_count = level.axis_ggun_count;
		}
		else
		{
			level.allies_ggun_count--;
			ggun_count = level.allies_ggun_count;
		}
		
		for (i = 0 ; i < level.players.size ; i++)
		{
			player = level.players[i];
			if (player.pers["team"] == carrier_team)
			{
				player updatePlayerHUD();
			}
		}
		self thread object_fx(level.glow_fx);
	}
}







giveGoldenGun(team)	
{
	for (i = 0 ; i < level.players.size; i++)
	{
		player = level.players[i];
		if (player.pers["team"] == team && player.sessionstate == "playing")
		{
			if (!isDefined(player.hasGoldenGun))
				player.hasGoldenGun = false;

			if (!player.hasGoldenGun)
			{
				
				player.preGoldenGunWeapon = player getCurrentWeapon();
		
				
				player takeWeapon(player.preGoldenGunWeapon,0);

				
				player GiveWeapon( level.golden_gun_weapon );
			}
			else
				player GiveMaxAmmo( level.golden_gun_weapon );

			player SwitchToWeapon( level.golden_gun_weapon );
			player.pers["weapon"] = level.golden_gun_weapon;
			player.hasGoldenGun = true;
			player thread checkGoldenGunAmmo();
		}
	}	
}