#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Running Man
	Objective: Hunters kill runners as fast as they can. Runners try to stay alive for as long as possible.
	Round ends: when all runners are dead or the time limit is reached.
	Map ends: when both teams have a turn as Hunters/Runners.
	Respawning:	no respawning - one life to live.

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_sd_spawn_attacker
			Allied players spawn from these. Place at least 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_sd_spawn_defender
			Axis players spawn from these. Place at least 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
			
	Level script requirements
	-------------------------
		Team Definitions:
			game["attackers"] = "allies";
			game["defenders"] = "axis";
			This sets which team is attacking and which team is defending. Attackers are Hunters, defenders are Runners.
*/

/*QUAKED mp_tdm_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/


main()
{
	if(getdvar("mapname") == "mp_background")
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if (isUsingMatchRulesData())
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();
	}
	else
	{
		registerScoreLimitDvar(level.gameType, 1000);
		registerTimeLimitDvar(level.gameType, 3);
		registerRoundLimitDvar(level.gameType, 2);
		registerWinLimitDvar(level.gameType, 2);
		registerRoundSwitchDvar(level.gameType, 1, 0, 9);
		registerNumLivesDvar(level.gameType, 1);
		registerHalfTimeDvar(level.gameType, 0);

		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	//Setting up the special Running Man classes.
	setSpecialLoadouts();

	//Running Man specific variables. It seems that these variables are reinitialized at the start of a new round.
	//Does this mean this main() gets recalled at the beginning of each round?
	level.round1_score = 0;		//Stores the Defenders' score from Round 1.
	level.test_int0 = 0;
	level.test_int1 = 0;


	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onNormalDeath = ::onNormalDeath;
	level.onDeadEvent = ::onDeadEvent;
	level.onOneLeftEvent = ::onOneLeftEvent;
	level.onTimeLimit = ::onTimeLimit;

	if (level.matchRules_damageMultiplier || level.matchRules_vampirism)
	{
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;
	}

	game["dialog"]["gametype"] = "tm_death";

	if (getDvarInt("g_hardcore"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}
	else if (getDvarInt("camera_thirdPerson"))
	{
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	}
	else if (getDvarInt("scr_diehard"))
	{
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	}
	else if (getDvarInt("scr_" + level.gameType + "_promode"))
	{
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	}

	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
	
	//Setting remote UAV time to infinite.
	//SetDvar("scr_remoteUAVFlyTime", 9999);
}


initializeMatchRules()
{
	//set common values
	setCommonRulesFromMatchRulesData();
	
	//set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar("scr_runningman_scorelimit", 0);
	registerScoreLimitDvar("runningman", 0);
	
	SetDynamicDvar("scr_runningman_timelimit", 3);
	registerTimeLimitDvar("runningman", 3);
	
	SetDynamicDvar("scr_runningman_roundlimit", 2);		//2 rounds, each team gets a turn being attacker.
	registerRoundLimitDvar("runningman", 2);
	
	SetDynamicDvar("scr_runningman_winlimit", 2);
	registerWinLimitDvar("runningman", 2);
	
	SetDynamicDvar("scr_runningman_roundswitch", 1);		//Teams switch sides every round.
	registerRoundSwitchDvar("runningman", 1, 1, 1);
	
	SetDynamicDvar("scr_runningman_numlives", 1);			//One life to live.
	registerNumLivesDvar("runningman", 1);

	SetDynamicDvar("scr_runningman_halftime", 0);
	registerHalfTimeDvar( "runningman", 0 );

	SetDynamicDvar("scr_runningman_promode", 0);
}

//onStartGameType is called at the beginning of each round.
onStartGameType()
{
	//if( inOvertime() )
	//	game["switchedsides"] = !game["switchedsides"];
	
	setClientNameMode("auto_change");

	if (!isdefined(game["switchedsides"]))
		game["switchedsides"] = false;

	if (game["switchedsides"])
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	//If it's the first round, the Attackers' score will be set to zero.
	//If it's Round 2, the Attackers' score will be set to the Defenders' score from the previous round.
	SetTeamScore(game["attackers"], game["teamScores"][game["attackers"]]);

	setObjectiveText(game["attackers"], &"OBJECTIVES_RUNNINGMAN_ATTACKER");
	setObjectiveText(game["defenders"], &"OBJECTIVES_RUNNINGMAN_DEFENDER");
	
	if (level.splitscreen)
	{
		setObjectiveScoreText(game["attackers"], &"OBJECTIVES_RUNNINGMAN_ATTACKER_SCORE");
		setObjectiveScoreText(game["defenders"], &"OBJECTIVES_RUNNINGMAN_DEFENDER_SCORE");
	}
	else
	{
		setObjectiveScoreText(game["attackers"], &"OBJECTIVES_RUNNINGMAN_ATTACKER_SCORE");
		setObjectiveScoreText(game["defenders"], &"OBJECTIVES_RUNNINGMAN_DEFENDER_SCORE");
	}
	setObjectiveHintText(game["attackers"], &"OBJECTIVES_RUNNINGMAN_ATTACKER_HINT");
	setObjectiveHintText(game["defenders"], &"OBJECTIVES_RUNNINGMAN_DEFENDER_HINT");

	initSpawns();
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	
	maps\mp\gametypes\_rank::registerScoreInfo("win", 2);
	maps\mp\gametypes\_rank::registerScoreInfo("loss", 1);
	maps\mp\gametypes\_rank::registerScoreInfo("tie", 1.5);

	maps\mp\gametypes\_rank::registerScoreInfo("kill", 1000);
	maps\mp\gametypes\_rank::registerScoreInfo("headshot", 1000);
	maps\mp\gametypes\_rank::registerScoreInfo("assist", 200);

	thread runningman();
}

initSpawns()
{
	level.spawnMins = (0, 0, 0);
	level.spawnMaxs = (0, 0, 0);
	
	//Using Search & Destroy spawn points for Running Man.
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints("mp_sd_spawn_attacker");
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints("mp_sd_spawn_defender");
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins, level.spawnMaxs);
	setMapCenter(level.mapCenter);
}


//Running man uses the same getSpawnPoint as Search & Destroy because players only spawn once per round using S&D spawn points.
getSpawnPoint()
{
	//everyone is a gamemode class in Running Man, no class selection
	self.pers["class"] = "gamemode";
	self.pers["lastClass"] = "";
	self.class = self.pers["class"];
	self.lastClass = self.pers["lastClass"];

	//Determining which spawnpoints, allies or axis, this player should be spawned from.
	if (self.pers["team"] == game["attackers"])
	{
		spawnPointName = "mp_sd_spawn_attacker";
	}
	else
	{
		spawnPointName = "mp_sd_spawn_defender";
	}


	spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray(spawnPointName);
	assert(spawnPoints.size);
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnPoints);

	return spawnpoint;
}


onSpawnPlayer()
{
	//Give the player the team-specific class.
	//Because each player's self.pers["team"] does not change between rounds, I have to check if each player's self.pers["team"] == game["attackers"]
	//game["attackers"] and game["defenders"] is what changes between rounds.
	if (self.pers["team"] == game["attackers"])
	{
		//Hunters
		self.pers["gamemodeLoadout"] = level.runningman_loadouts["allies"];
	}
	else
	{
		//Runners
		self.pers["gamemodeLoadout"] = level.runningman_loadouts["axis"];
		
//		if (IsPlayer(self))
//		{
//			self lockPlayerForRemoteUAVLaunch();
//			self setUsingRemote( "remote_uav" );
//			
//			remoteUAV = createRemoteUAV( self.lifeId, self, "remote_uav", self.origin + (0, 0, 64), self.angles );
//			if ( isDefined( remoteUAV ) )
//			{
//				self thread remoteUAV_Ride( self.lifeId, remoteUAV, "remote_uav" );
//				return true;
//			}
//		}
	}
	//self.pers["gamemodeLoadout"] = level.runningman_loadouts[self.pers["team"]];

	//onSpawnPlayer() is called before giveLoadout() so wait until it is done then override weapons.
	self thread waitLoadoutDone();

	level notify("spawned_player");
}


waitLoadoutDone()
{	
	level endon( "game_ended" );
	self endon( "disconnect" );

	level waittill( "player_spawned" );

	//Based on oic.gsc, you have to take all weapons after the player has spawned.
	//If you are a Runner...
	if (self.pers["team"] == game["defenders"])
	{
		//Take all weapons away and give back some perks.
		//self takeAllWeapons();
		self TakeWeapon("iw5_acr_mp");
		//self givePerk( "specialty_marathon", false );
		//self givePerk( "specialty_detectexplosive", false );
		//self givePerk( "specialty_quieter", false );
		
		self.moveSpeedScaler = 1.3;
		self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
	}
}


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId)
{
	//if (IsPlayer(self))
	//{
	//	self SetClientDvar("ui_carrying_bomb", false);
	//}
	
	thread checkAllowSpectating();
}


onNormalDeath(victim, attacker, lifeId)
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );

	team = victim.team;

	//Gives team points for each players' kills. We won't need this for Running Man because score is based on how long runners last.
	//attacker maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], score );
	
	//I'm commenting out part of the if-condition because I want the last kill to always count as the final kill regardless of score.
	if (game["state"] == "postgame")// && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]])
	{
		attacker.finalKill = true;
	}
}


onDeadEvent( team )
{
	//If everyone is dead...
	if (team == "all")
	{
		game["roundsPlayed"]++;

		//If we've just played one round, we are about to start the second and final round of Running Man.
		if (game["roundsPlayed"] == 1)//getWatchedDvar("roundlimit") == 1)
		{
			runningman_endGame("halftime", game["strings"][game["attackers"] + "_eliminated"]);
		}
		//Else-if we've just played the last round and the game should end for good.
		else if (game["roundsPlayed"] == 2)
		{
			if (game["teamScores"][game["attackers"]] > game["teamScores"][game["defenders"]])
			{
				runningman_endGame(game["attackers"],game["strings"][game["attackers"] + "_eliminated"]);
			}
			else if (game["teamScores"][game["attackers"]] < game["teamScores"][game["defenders"]])
			{
				runningman_endGame(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
			}
			//If the scores are tied.
			else
			{
				runningman_endGame("tie", game["strings"][game["attackers"] + "_eliminated"]);
			}
		}
		else
		{
			//Uh oh, there shouldn't be any other rounds!!!
			AssertMsg("Everyone's dead but the game isn't ending!");
		}
	}
	
	
	//If all the attackers are dead (Defenders should get max points for the round).
	else if (team == game["attackers"])
	{
		game["roundsPlayed"]++;

		//If we've just played one round, we are about to start the second and final round of Running Man.
		if (game["roundsPlayed"] == 1)//getWatchedDvar("roundlimit") == 1)
		{
			//Awarding the Defenders a full round's worth of points (as if they survived for a whole round).
			//Hack: we need this score_mod because the Defenders will get an additional point at the end if all Attackers die when they already have at least 1 point.
			score_mod = 0;
			if (game["teamScores"][game["defenders"]] > 0)
			{
				score_mod = 1;
			}
			game["teamScores"][game["defenders"]] += Int((60 * getWatchedDvar("timelimit"))) - Int(getTimePassed()/1000) - score_mod;// - (Int(getTimePassed()/1000) % 1));
			
			runningman_endGame("halftime", game["strings"][game["attackers"] + "_eliminated"]);
		}
		//Else-if we've just played the last round and the game should end for good.
		else if (game["roundsPlayed"] == 2)
		{
			//Awarding the Defenders a full round's worth of points (as if they survived for a whole round).
			//Hack: we need this score_mod because the Defenders will get an additional point at the end if all Attackers die when they already have at least 1 point.
			score_mod = 0;
			if (game["teamScores"][game["defenders"]] > 0)
			{
				score_mod = 1;
			}
			game["teamScores"][game["defenders"]] += Int((60 * getWatchedDvar("timelimit"))) - Int(getTimePassed()/1000) - score_mod;// - (Int(getTimePassed()/1000) % 1));
			
			if (game["teamScores"][game["attackers"]] > game["teamScores"][game["defenders"]])
			{
				runningman_endGame(game["attackers"], game["strings"][game["attackers"] + "_eliminated"]);
			}
			else if (game["teamScores"][game["attackers"]] < game["teamScores"][game["defenders"]])
			{
				runningman_endGame(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
			}
			//If the scores are tied.
			else
			{
				runningman_endGame("tie", game["strings"][game["attackers"] + "_eliminated"]);
			}
		}
		else
		{
			//Uh oh, there shouldn't be any other rounds!!!
			AssertMsg("All Attackers are dead but the game isn't ending!");
		}
	}
	
	
	//If all the defenders are dead...
	else if ( team == game["defenders"] )
	{
		game["roundsPlayed"]++;

		//If we've just played one round, we are about to start the second and final round of Running Man.
		if (game["roundsPlayed"] == 1)//getWatchedDvar("roundlimit") == 1)
		{
			runningman_endGame("halftime", game["strings"][game["defenders"] + "_eliminated"]);
		}
		//Else-if we've just played the last round and the game should end for good.
		else if (game["roundsPlayed"] == 2)
		{
			if (game["teamScores"][game["attackers"]] > game["teamScores"][game["defenders"]])
			{
				runningman_endGame(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
			}
			else if (game["teamScores"][game["attackers"]] < game["teamScores"][game["defenders"]])
			{
				runningman_endGame(game["defenders"], game["strings"][game["defenders"] + "_eliminated"]);
			}
			//If the scores are tied.
			else
			{
				runningman_endGame("tie", game["strings"][game["defenders"] + "_eliminated"]);
			}
		}
		else
		{
			//Uh oh, there shouldn't be any other rounds!!!
			AssertMsg("All Defenders are dead but the game isn't ending!");
		}
	}
}


onOneLeftEvent(team)
{
	lastPlayer = getLastLivingPlayer(team);

	lastPlayer thread giveLastOnTeamWarning();
}


onTimeLimit()
{
	//It's the end of a round, increment game["roundsPlayed"].
	game["roundsPlayed"]++;
	
	//If we've just played one round, we are about to start the second and final round of Running Man.
	if (game["roundsPlayed"] == 1)//getWatchedDvar("roundlimit") == 1)
	{
		runningman_endGame("halftime", game["strings"]["time_limit_reached"]);
	}
	//Else-if we've just played the last round and the game should end for good.
	else if (game["roundsPlayed"] == 2)
	{
		if (game["teamScores"][game["attackers"]] > game["teamScores"][game["defenders"]])
		{
			runningman_endGame(game["attackers"], game["strings"]["time_limit_reached"]);
		}
		else if (game["teamScores"][game["attackers"]] < game["teamScores"][game["defenders"]])
		{
			runningman_endGame(game["defenders"], game["strings"]["time_limit_reached"]);
		}
		//If the scores are tied.
		else
		{
			runningman_endGame("tie", game["strings"]["time_limit_reached"]);
		}
	}
	else
	{
		//Uh oh, there shouldn't be any other rounds!!!
	}
	
	//If the round has reached the time limit, that means some defenders went the distance. Defenders win the round.
}


checkAllowSpectating()
{
	wait(0.05);

	update = false;
	if (!level.aliveCount[game["attackers"]])
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( !level.aliveCount[game["defenders"]])
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = true;
	}
	if (update)
	{
		maps\mp\gametypes\_spectating::updateSpectateSettings();
	}
}


runningman_endGame(winningTeam, endReasonText)
{
	level.finalKillCam_winner = winningTeam;

	//Saving the Defender team's score.
	//level.round1_score = game["teamScores"][game["defenders"]];
	
	//Saving the Defenders' score in game["roundsWon"]["defenders"].
	//game["roundsWon"]["defenders"] = game["teamScores"][game["defenders"]];

	//level.round1_score = maps\mp\gametypes\_gamescore::_getteamscore(game["defenders"]);

	thread maps\mp\gametypes\_gamelogic::endGame(winningTeam, endReasonText);
}


giveLastOnTeamWarning()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");

	self waitTillRecoveredHealth(3);

	otherTeam = getOtherTeam(self.pers["team"]);
	level thread teamPlayerCardSplash("callout_lastteammemberalive", self, self.pers["team"]);
	level thread teamPlayerCardSplash("callout_lastenemyalive", self, otherTeam);
	level notify("last_alive", self);
	//Challenge for being the last man alive in SD.
	//self maps\mp\gametypes\_missions::lastManSD();
}


updateRmanScores()
{
	level endon("game_ended");

	//gameFlagWait("prematch_done");
	level waittill("graceperiod_done");
	
	while (!level.gameEnded)
	{
		maps\mp\gametypes\_gamescore::giveTeamScoreForObjective(game["defenders"], 1);
		wait(1.0);
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}


//Checks whether the first-round Defenders have no chance of winning because the second-round Defenders have more points in the second round.
check_no_hope()
{
	//You should check whether the second-round Defenders have a higher score than the Attackers (who were Defenders in the previous round).
	//In this case, the current Defenders would have won because there is no 3rd round for the current Attackers to regain the lead.
	while (!level.gameEnded)
	{
		//Note: game["roundsPlayed"] == 1 means the first round has finished either via death or time limit, thus we are in round 2.
		if (game["teamScores"][game["attackers"]] < game["teamScores"][game["defenders"]] && game["roundsPlayed"] == 1)
		{
			runningman_endGame(game["defenders"], game["strings"]["round_win"]);
		}
		wait(1);
	}
}


runningman()
{
	thread updateRmanScores();
	//assertex(game["teamScores"][game["defenders"]] < 7, "Gah!");

	thread check_no_hope();

	//while (1)
	//{
		//Displaying a test variables.
		//thread displayServerString(game["defenders"], 1, "level.test_int0: " + level.test_int0, -50);
		//thread displayServerString(game["attackers"], 1, "level.test_int0: " + level.test_int0, -50);
		//thread displayServerString(game["defenders"], 1, "level.test_int1: " + level.test_int1, -60);
		//thread displayServerString(game["attackers"], 1, "level.test_int1: " + level.test_int1, -60);

		//Displaying team scores.
		//thread displayServerString(game["defenders"], 1, "defenders' score: " + game["teamScores"][game["defenders"]], -50);
		//thread displayServerString(game["attackers"], 1, "defenders' score: " + game["teamScores"][game["defenders"]], -50);
		//thread displayServerString(game["defenders"], 1, "attackers' score: " + game["teamScores"][game["attackers"]], -65);
		//thread displayServerString(game["attackers"], 1, "attackers' score: " + game["teamScores"][game["attackers"]], -65);

		//Displaying level.round1_score.
		//thread displayServerString(game["defenders"], 1, "level.round1_score: " + level.round1_score, -50);
		//thread displayServerString(game["attackers"], 1, "level.round1_score: " + level.round1_score, -65);

		//wait(1);
	//}
}


displayServerString( team, display_time, text, offset)//, timer )
{
	display = createServerFontString("hudbig", .75, team);
	display setPoint("CENTER", "CENTER", 0, offset);
	display.sort = 1001;
	display.color = (1,1,1);
	display.foreground = false;
	display.hidewheninmenu = true;
	//if(isdefined(timer))
	//{
	//	thread displayStartTimer(display_time, offset, team);
	//}
	display settext(text);

	wait display_time;
	//level common_scripts\utility::waittill_any_timeout( display_time, "bloodshed_flag_dropped" );

	display destroyElem();
}


//Stealing from infect.gsc.
setSpecialLoadouts()
{
	//////////////////////////////////////////////////////////
	//GUN GAME
	/*
	level.runningman_loadouts["axis"]["loadoutPrimary"] = "iw5_acr";	//  can't use "none" for primary, this is replaced on spawn anyway
	level.runningman_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
	level.runningman_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
	level.runningman_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
	level.runningman_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
	level.runningman_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
	
	level.runningman_loadouts["axis"]["loadoutSecondary"] = "none";
	level.runningman_loadouts["axis"]["loadoutSecondaryAttachment"] = "none";
	level.runningman_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
	level.runningman_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
	level.runningman_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
	level.runningman_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
	
	level.runningman_loadouts["axis"]["loadoutEquipment"] = "specialty_null";
	level.runningman_loadouts["axis"]["loadoutOffhand"] = "none";
	
	level.runningman_loadouts["axis"]["loadoutPerk1"] = "specialty_null";
	level.runningman_loadouts["axis"]["loadoutPerk2"] = "specialty_null";
	level.runningman_loadouts["axis"]["loadoutPerk3"] = "specialty_null";
	
	level.runningman_loadouts["axis"]["loadoutDeathstreak"] = "specialty_null";
	
	level.runningman_loadouts["axis"]["loadoutJuggernaut"]	= false;
	
	//	FFA games don't have teams, but players are allowed to choose team on the way in
	//	just for character model and announcer voice variety.  Same loadout for both.	
	level.runningman_loadouts["allies"] = level.runningman_loadouts["axis"];
	*/
	//////////////////////////////////////////////////////////



	//Defenders
	//Here we use "axis" explicitly because we don't want the team loadouts to change between rounds.
	//(Also game["defenders"] hasn't been defined in the <map>.gsc at this point anyways so using game["defenders"] here would throw an SRE).
	if ( isUsingMatchRulesData() && GetMatchRulesData( "defaultClasses", "axis", 0, "class", "inUse" ) )
	{
		level.runningman_loadouts["axis"] = getMatchRulesSpecialClass( "axis", 0 );
		level.runningman_loadouts["axis"]["loadoutStreakType"] = "assault";
		level.runningman_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak3"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak4"] = "none";
	}
	else
	{
		level.runningman_loadouts["axis"]["loadoutPrimary"] = "iw5_acr";
		level.runningman_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
		level.runningman_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.runningman_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.runningman_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.runningman_loadouts["axis"]["loadoutPrimaryReticle"] = "none";

		level.runningman_loadouts["axis"]["loadoutSecondary"] = "none";
		level.runningman_loadouts["axis"]["loadoutSecondaryAttachment"] = "none";
		level.runningman_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.runningman_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.runningman_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.runningman_loadouts["axis"]["loadoutSecondaryReticle"] = "none";

		level.runningman_loadouts["axis"]["loadoutEquipment"] = "none";
		level.runningman_loadouts["axis"]["loadoutOffhand"] = "smoke_grenade_mp";

		level.runningman_loadouts["axis"]["loadoutPerks"][0] = "specialty_class_extremeconditioning";
		level.runningman_loadouts["axis"]["loadoutPerks"][1] = "specialty_null";
		level.runningman_loadouts["axis"]["loadoutPerks"][2] = "specialty_null";
		level.runningman_loadouts["axis"]["loadoutPerks"][3] = "specialty_null";
		level.runningman_loadouts["axis"]["loadoutPerks"][4] = "specialty_null";
		level.runningman_loadouts["axis"]["loadoutPerks"][5] = "specialty_null";
		
		level.runningman_loadouts["axis"]["loadoutStreakType"] = "assault";
		level.runningman_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak3"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak4"] = "none";

		level.runningman_loadouts["axis"]["loadoutDeathstreak"] = "specialty_null";	

		level.runningman_loadouts["axis"]["loadoutJuggernaut"] = false;
	}


	//Attackers
	//Here we use "allies" explicitly because we don't want the team loadouts to change between rounds.
	//(Also game["attackers"] hasn't been defined in the <map>.gsc at this point anyways so using game["attackers"] here would throw an SRE).
	if ( isUsingMatchRulesData() && GetMatchRulesData( "defaultClasses", "allies", 0, "class", "inUse" ) )
	{
		level.runningman_loadouts["allies"] = getMatchRulesSpecialClass( "allies", 0 );			
	}
	else
	{
		level.runningman_loadouts["allies"]["loadoutPrimary"] = "iw5_msr";
		level.runningman_loadouts["allies"]["loadoutPrimaryAttachment"] = "heartbeat";
		level.runningman_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.runningman_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_bulletpenetration";
		level.runningman_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.runningman_loadouts["allies"]["loadoutPrimaryReticle"] = "none";

		level.runningman_loadouts["allies"]["loadoutSecondary"] = "none";
		level.runningman_loadouts["allies"]["loadoutSecondaryAttachment"] = "none";
		level.runningman_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.runningman_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.runningman_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.runningman_loadouts["allies"]["loadoutSecondaryReticle"] = "none";

		level.runningman_loadouts["allies"]["loadoutEquipment"] = "none";
		level.runningman_loadouts["allies"]["loadoutOffhand"] = "none";

		//level.runningman_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		//level.runningman_loadouts["allies"]["loadoutPerk2"] = "specialty_quickdraw";
		//level.runningman_loadouts["allies"]["loadoutPerk3"] = "specialty_fastreload";
		level.runningman_loadouts["allies"]["loadoutPerks"][0] = "specialty_class_quickdraw";
		level.runningman_loadouts["allies"]["loadoutPerks"][1] = "specialty_class_scavenger";
		level.runningman_loadouts["allies"]["loadoutPerks"][2] = "specialty_null";
		level.runningman_loadouts["allies"]["loadoutPerks"][3] = "specialty_null";
		level.runningman_loadouts["allies"]["loadoutPerks"][4] = "specialty_null";
		level.runningman_loadouts["allies"]["loadoutPerks"][5] = "specialty_null";
		
		level.runningman_loadouts["axis"]["loadoutStreakType"] = "assault";
		level.runningman_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak3"] = "none";
		level.runningman_loadouts["axis"]["loadoutKillstreak4"] = "none";

		level.runningman_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";

		level.runningman_loadouts["allies"]["loadoutJuggernaut"] = false;
	}
}
