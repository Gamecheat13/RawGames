#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	
	if ( !isDefined( level.tweakablesInitialized ) )
		maps\mp\gametypes\_tweakables::init();
		
	maps\mp\gametypes\_battlechatter_mp::init();
	
	level.splitscreen = isSplitScreen();
	
	maps\mp\gametypes\_tweakables::setTweakableValue( "game", "allowkillcam", 0 );	 

	
	
	setdvar("genmsg_enabled",false);
	
	level.xenon = (getdvar("xenonGame") == "true");
	level.wii = (getdvar("wiiGame") == "true");
	level.ps3 = (getdvar("ps3Game") == "true");
	level.timeLimitCalled = 0;

	if ( level.xenon )
		level.xboxlive = getDvarInt( "onlinegame" );
	else
		level.xboxlive = false;

	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );

	switch( level.gametype )
	{
		case "dm":
			setDvar( "ui_gametype_text", "@MPUI_DEATHMATCH" );
			setDvar( "ui_gametype_text_instr", "@MPUI_DEATHMATCH_INST" );
			break;
		case "tdm":
		  	setDvar( "ui_gametype_text", "@MPUI_TEAM_DEATHMATCH" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_TEAM_DEATHMATCH_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_TEAM_DEATHMATCH_INST_MI6" );
		  	break;
		case "ih":
			setDvar( "ui_gametype_text", "@MPUI_INTELLIGENCE_HUNT" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_INTELLIGENCE_HUNT_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_INTELLIGENCE_HUNT_INST_MI6" );
			break;
		case "br":
			setDvar( "ui_gametype_text", "@MPUI_BOMBING_RUN" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_BOMBING_RUN_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_BOMBING_RUN_INST_ORG" );
			break;
		case "rec":
			setDvar( "ui_gametype_text", "@MPUI_RECRUITMENT" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_RECRUITMENT_RECRUITMENT_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_RECRUITMENT_RECRUITMENT_INST_MI6" );
			break;
		case "tc":
			setDvar( "ui_gametype_text", "@MPUI_TERRITORY_CONTROL" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_TERRITORY_CONTROL_ORG_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_TERRITORY_CONTROL_ORG_INST_MI6" );
			break;
		case "as":
			setDvar( "ui_gametype_text", "@MPUI_ASSASSINATION" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_ASSASSINATION_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_ASSASSINATION_INST_MI6" );
			break;
		case "tas":
			setDvar( "ui_gametype_text", "@MPUI_TEAM_ASSASSINATION" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_TEAM_ASSASSINATION_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_TEAM_ASSASSINATION_INST_MI6" );
			break;
		case "ttc":
			setDvar( "ui_gametype_text", "@MPUI_TEAM_TERRITORY_CONTROL" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_TEAM_TERRITORY_CONTROL_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_TEAM_TERRITORY_CONTROL_INST_MI6" );
			break;
		case "vs":
			setDvar( "ui_gametype_text", "@MPUI_BOND_VERSUS" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_BOND_VERSUS_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_BOND_VERSUS_INST_MI6" );
			break;
		default:
			setDvar( "ui_gametype_text", "@MPUI_TEAM_TERRITORY_CONTROL" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_TEAM_TERRITORY_CONTROL_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_TEAM_TERRITORY_CONTROL_INST_MI6" );
			break;
	}
	
	level.teamBased = false;
	level.doPrematch = false;
	level.doCountdown = false;		

	level.overrideTeamScore = false;
	level.overridePlayerScore = false;

	level.doClass = true;
	level.doHero = true;
	
	level.postRoundTime = 4.0;

	
	if ( level.gametype != "spy" )
	{
		spyWeapons = getentarray( "spy_weapon_spawn", "targetname" );

		for ( i = 0; i < spyWeapons.size; i++ )
		{
			spyWeapons[i] delete();
		}
	}

	level.game_ready = true;

	if (getdvar("g_endgame") == "0")
		level.game_ready = false;

	setDvar("g_endgame", "0");

	
	if ( level.splitscreen )
		level thread waitForReadyState();

	level thread maps\mp\_pickup::init();
	
	level.changemap = false;
	level.changemode = false;
	level.restartgame = false;
}

waitForReadyState()
{
	setDvar( "splitscreen_numClientsReady", 0 ); 
	for(;;)
	{
		wait (1);
		
		if ( getDvar("splitscreen_numClientsReady") == getDvar("splitscreen_numClientsPlaying") )
		{
			
			setDvar("splitscreen_gameStarted", 1);
			level.game_ready = true;
			level notify("game_ready");
			break;
		}
	}
}

SetupCallbacks()
{
	level.overrideTeam = ::overrideTeam;
	level.doLoadout = ::doLoadout;
	level.spawnPlayer = ::spawnPlayer;
	level.spawnClient = ::spawnClient;
	level.spawnSpectator = ::spawnSpectator;
	level.spawnIntermission = ::spawnIntermission;
	level.updateTeamStatus = ::updateTeamStatus;
	level.onPlayerScore = ::default_onPlayerScore;
	level.onTeamScore = ::default_onTeamScore;
	level.updatePlacement = ::updatePlacement;
	
	level.onXPEvent = ::blank;
	level.waveSpawnTimer = ::waveSpawnTimer;
	
	level.onSpawnPlayer = ::blank;
	level.onSpawnSpectator = ::default_onSpawnSpectator;
	level.onSpawnIntermission = ::default_onSpawnIntermission;

	level.onTimeLimit = ::default_onTimeLimit;
	level.onScoreLimit = ::default_onScoreLimit;
	level.onDeadEvent = ::default_onDeadEvent;
	level.onOneLeftEvent = ::default_onOneLeftEvent;
	level.giveTeamScore = ::giveTeamScore;
	level.givePlayerScore = ::givePlayerScore;

	level._setTeamScore = ::_setTeamScore;
	level._setPlayerScore = ::_setPlayerScore;

	level._getTeamScore = ::_getTeamScore;
	level._getPlayerScore = ::_getPlayerScore;

	level.timeLow = ::timeLow;
	level.timeCritical = ::timeCritical;
	
	level.endGame = ::endGame;
	
	level.onPrecacheGametype = ::blank;
	level.onStartGameType = ::blank;
	level.onPlayerConnect = ::blank;
	level.onPlayerDisconnect = ::blank;
	level.onPlayerDamage = ::blank;
	level.onPlayerKilled = ::onPlayerKilled; 
	level.onDeathOccurred = ::blank;

	level.autoassign = ::menuAutoAssign;
	level.spectator = ::menuSpectator;
	level.class = ::menuClass;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
	level.setupCharacterOptions = ::setupCharacterOptions;
}


blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}



onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if (!isDefined(level.killstreaks))
		return;

	maps\mp\gametypes\_killstreaks::printKillStreak(attacker);
}


default_onDeadEvent( team )
{
	if ( team == "allies" )
	{
		announcement( &"MP_ALLIES_ELIMINATED" );
		thread [[level.endGame]]( "axis" );
	}
	else if ( team == "axis" )
	{
		announcement( &"MP_OPFOR_ELIMINATED" );
		thread [[level.endGame]]( "allies" );
	}
	else
	{
		
		thread [[level.endGame]]( "tie" );
	}
}


default_onOneLeftEvent( team )
{
	if ( !level.teamBased )
	{
		announcement( &"MP_ENEMIES_ELIMINATED" );
		
		winner = getHighestScoringPlayer();
		thread [[level.endGame]]( winner );
	}
	else
	{
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( !isAlive( player ) )
				continue;
				
			if ( !isDefined( player.pers["team"] ) || player.pers["team"] != team )
				continue;
				
			
		}
	}
}


default_onScoreLimit()
{
	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( level.teamScores["allies"] == level.teamScores["axis"] )
		{
			winner = "tie";
			iPrintLn( &"MPBXUI_SCORE_LIMIT_TEAM_TIE" );
		}
		else if ( level.teamScores["axis"] > level.teamScores["allies"] )
		{
			winner = "axis";
			iPrintLn( &"MPBXUI_SCORE_LIMIT_TEAM_VICTORY", &"MPBXUI_AXIS");
		}
		else
		{
			winner = "allies";
			iPrintLn( &"MPBXUI_SCORE_LIMIT_TEAM_VICTORY", &"MPBXUI_ALLIES");
		}
	}
	else
	{
		winner = getHighestScoringPlayer();
		if ( isDefined( winner ) )
			iPrintLn( &"MPBXUI_SCORE_LIMIT_PLAYER_VICTORY", winner.name);
		else
			iPrintLn( &"MPBXUI_SCORE_LIMIT_PLAYER_TIE" );
	}

	wait( 0.1 );

	[[level.endGame]]( winner );
}



forceEnd()
{
	if ( level.forcedEnd )
		return;

	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( level.teamScores["allies"] == level.teamScores["axis"] )
			winner = "tie";
		else if ( level.teamScores["axis"] > level.teamScores["allies"] )
			winner = "axis";
		else
			winner = "allies";
	}
	else
	{
		winner = getHighestScoringPlayer();
	}
	
	level.forcedEnd = true;
	[[level.endGame]]( winner );
}

default_onTimeLimit()
{

	if(level.timeLimitCalled == 1)
	{
		logprint("ignore multiple on time limit\n");
		return;
	}
	
	level.timeLimitCalled = 1;
	
	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( level.teamScores["allies"] == level.teamScores["axis"] )
		{
			winner = "tie";
			iPrintLn( &"MPBXUI_TIME_LIMIT_TEAM_TIE" );
		}
		else if ( level.teamScores["axis"] > level.teamScores["allies"] )
		{
			winner = "axis";
			iPrintLn( &"MPBXUI_TIME_LIMIT_TEAM_VICTORY", &"MPBXUI_AXIS");
		}
		else
		{
			winner = "allies";
			iPrintLn( &"MPBXUI_TIME_LIMIT_TEAM_VICTORY", &"MPBXUI_ALLIES");
		}
	}
	else
	{
		winner = getHighestScoringPlayer();
		if ( isDefined( winner ) )
			iPrintLn( &"MPBXUI_TIME_LIMIT_PLAYER_VICTORY", winner.name);
		else
			iPrintLn( &"MPBXUI_TIME_LIMIT_PLAYER_TIE" );
	}

	
	updateRatings();

	wait( 0.1 );

	[[level.endGame]]( winner );
}


updateGameEvents()
{
	if ( !level.numLives )
		return;

	if ( level.teamBased )
	{
		
		if ( level.lastAliveCount["allies"] && !level.aliveCount["allies"] && level.lastAliveCount["axis"] && !level.aliveCount["axis"] )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}

		
		if ( level.lastAliveCount["allies"] && !level.aliveCount["allies"] )
		{
			[[level.onDeadEvent]]( "allies" );
			return;
		}

		
		if ( level.lastAliveCount["axis"] && !level.aliveCount["axis"] )
		{
			[[level.onDeadEvent]]( "axis" );
			return;
		}

		
		if ( level.lastAliveCount["allies"] > 1 && level.aliveCount["allies"] == 1 )
		{
			[[level.onOneLeftEvent]]( "allies" );
			return;
		}

		
		if ( level.lastAliveCount["axis"] > 1 && level.aliveCount["axis"] == 1 )
		{
			[[level.onOneLeftEvent]]( "axis" );
			return;
		}
	}
	else
	{
		
		if ( (level.lastAliveCount["allies"] || level.lastAliveCount["axis"]) && (!level.aliveCount["allies"] && !level.aliveCount["axis"]) )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}

		
		if ( ( level.aliveCount["allies"] + level.aliveCount["axis"] == 1 ) && ( (getTime() - level.startTime) > 300 ) )
		{
			[[level.onOneLeftEvent]]( "all" );
			return;
		}
	}
}


overrideTeam()
{
}


doLoadout()
{
	self.pers["proficiency"] = self maps\mp\gametypes\_class::getProficiency( self maps\mp\gametypes\_class::getClass() );	
	self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
}

spawnPlayer()
{
	self endon("disconnect");
	self endon("joined_spectators");

	revived = self maps\mp\gametypes\_revive::wasRevived();

	

	if( level.doClass )
	{
		bValid = self maps\mp\gametypes\_class::validateLoadout( self.pers["team"], self.pers["class"] );
		if ( !bValid )
		{
			
			if ( isDefined( self.pers["oldtype"] ) )
			{
				self.pers["type"] = self.pers["oldtype"];
				self.pers["primary"] = self.pers["oldprimary"];
				self.pers["explosive"] = self.pers["oldexplosive"];
				self.pers["gadget"] = self.pers["oldgadget"];
				self setClientDvar( "ui_char", self.pers["type"] );
				self setClientDvar( "ui_weap", self.pers["primary"] );
				self setClientDvar( "ui_exp", self.pers["explosive"] );
				self setClientDvar( "ui_gad", self.pers["gadget"] );
				bValid = self maps\mp\gametypes\_class::validateLoadout( self.pers["team"], self.pers["class"] );
			}

			
			if( !bValid )
			{
				
				if (self.pers["team"] == "allies")
					self openMenu( game["menu_class_allies"] );
				else
					self openMenu( game["menu_class_axis"] );

				self setclientdvar( "scr_info", "^1Invalid choice." );
				return;
			}
		}
	}

	
	if ( level.splitscreen && !level.game_ready )
	{
		preSplitElement = createFontString( "default", 2.0 );
		preSplitElement setPoint( "TOP", undefined, 0, 30 );
		preSplitElement setText( &"MP_WAITING_FOR_PLAYERS_READY" );
		self freezeControls(true); 	
		level waittill("game_ready");
		self freezeControls(false);	
		preSplitElement destroyElem();
	}
		

	self notify("spawned");
	self notify("end_respawn");

	self setSpawnVariables();

	if ( level.teamBased )
		self.sessionteam = self.pers["team"];
	else
		self.sessionteam = "none";

	hadSpawned = self.hasSpawned;

	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" );
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.afk = false;
	self.pers["lives"]--;


	
	
	
	
	
	
	if ( game["state"] == "prematch")
		prematchSpawnPlayer();
	else
	{
		
		
		
		
		
		
		
		
		[[level.onSpawnPlayer]]();			
	}



	level [[level.updateTeamStatus]]();

	if ( !revived )
	{
		if( level.doClass )
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
		
		if ( self.pers["skin"] == "SKIN_GENERIC_ONE" )
			self.pers["skin"] = "SKIN_MI6_00";
		self maps\mp\gametypes\_teams::model( self.pers["skin"] );
	}

	if( isDefined( self.pers["team"] ) && self.pers["team"] != "" )
	{
		if (self.pers["team"] == "allies")
			self setclientdvar("g_scriptMainMenu", game["menu_changeclass_allies"]);
		else
			self setclientdvar("g_scriptMainMenu", game["menu_changeclass_axis"]);
	    self setclientdvar( "cl_validloadout", "1" );
	  }
	
	
	
	
	if (level.gametype == "bx_faceoff")
	{
		if (!self.overrideLoadout)
			self [[level.doLoadout]]();	
	}
	else
	{
		self [[level.doLoadout]]();
	}
	
	

	
	
	
	if ( game["state"] == "countdown" )
	{
		
		if( !isdefined(level.countdownEnd) )
			level waittill("countdown_start");

		self freezeControls( true );

		self spinIn( level.countdownEnd );

		level waittill("countdown_done");

		self freezeControls( false );
	}

	maps\mp\gametypes\_cinematic::addClient(self);

	maps\mp\gametypes\_cinematic::waitForCinematic(self.pers["team"]);

	if ( game["state"] != "prematch" )
	{
		if( level.scorelimit > 0 )
		{
			if ( level.splitScreen )
				self setclientdvar( "cg_objectiveText", getObjectiveScoreText( self.pers["team"] ) );
			else
				self setclientdvar( "cg_objectiveText", getObjectiveScoreText( self.pers["team"] ), level.scorelimit );
		}
		else
		{
			self setclientdvar( "cg_objectiveText", getObjectiveText( self.pers["team"] ) );
		}
	}

	
	
	
	
	waittillframeend;
	self notify( "spawned_player" );

	self setClientDvar( "ui_team_name", self.pers["team"] );



	if ( game["state"] == "postgame" )
	{
		
		
		self freezePlayerForRoundEnd();
	}
}


freezePlayerForRoundEnd()
{


	self ClearAnimScriptEvent();

	self closeMenu();
	self closeInGameMenu();

	self freezeControls( true );
	
}


prematchSpawnPlayer()
{
	[[level.spawnSpectator]]();
}


watchAFK()
{
	afkTimeThreshold = 15; 
	
	self.afk = false;
	
	
	if ( level.spawnType != "elimination" )
		return;
	
	interval = 1;
	afkTime = 0;

	while(1)
	{
		oldorigin = self.origin;
		oldangles = self getPlayerAngles();
		oldads = self playerADS();
		
		wait interval;
		
		if (
			(self.origin != oldorigin) || 
			(self getPlayerAngles() != oldangles) || 
			(self playerADS() > 0 || self playerADS() != oldads) 
		) {
			afkTime = 0;

			if (self.afk) {
				self.afk = false;
				[[level.updateTeamStatus]]();
			}

			
			
			break;
		}
		else
		{
			afkTime += interval;
			if (afkTime >= afkTimeThreshold)
			
			if (!self.afk) {
				self.afk = true;
				[[level.updateTeamStatus]]();
			}
		}
	}
}


spawnSpectator( origin, angles )
{
	self notify("spawned");
	self notify("end_respawn");

	self setSpawnVariables();
	
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	maps\mp\gametypes\_spectating::setSpectatePermissions();

	[[level.onSpawnSpectator]]( origin, angles );
	self setClientDvar("cg_objectiveText", "");
	self setClientDvar("cg_thirdPerson", "1");
	
	level [[level.updateTeamStatus]]();
}


waveSpawnTimer()
{
	level endon( "intermission" );
	level endon( "game_ended" );

	while ( game["state"] == "playing" )
	{
		time = getTime();
		
		if ( time - level.lastWave["allies"] > (level.waveDelay["allies"] * 1000) )
		{
			level notify ( "wave_respawn_allies" );
			level.lastWave["allies"] = time;
		}

		if ( time - level.lastWave["axis"] > (level.waveDelay["axis"] * 1000) )
		{
			level notify ( "wave_respawn_axis" );
			level.lastWave["axis"] = time;
		}
		
		wait ( 0.05 );
	}
}


default_onSpawnSpectator( origin, angles)
{
	if( isDefined( origin ) && isDefined( angles ) )
	{
		self spawn(origin, angles);
		return;
	}
	
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);
}


spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	self setSpawnVariables();

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	[[level.onSpawnIntermission]]();
}


default_onSpawnIntermission()
{
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}



timeUntilRoundEnd()
{
	if ( level.gameEnded )
	{
		timePassed = (getTime() - level.gameEndTime) / 1000;
		timeRemaining = level.postRoundTime - timePassed;
		
		if ( timeRemaining < 0 )
			return 0;
		
		return timeRemaining;
	}
	
	if ( level.timeLimit <= 0 )
		return undefined;
	
	timePassed = (getTime() - level.startTime)/1000;
	timeRemaining = (level.timeLimit * 60) - timePassed;
	
	return timeRemaining + level.postRoundTime;
}


updateRatings()
{
	isonline = getDvarInt("onlinegame");
	isfriendgame = getDvarInt("friendgame");
	logprint("isonline :" + isonline + "\n");
	logprint("isfriendgame :" + isfriendgame + "\n");
	
	if(isonline == 1 && isfriendgame == 0)
	{
		
		updateperformance();
		startTime = getTime();
		curTime = getTime();
		setDvar( "ratingupdate", 0); 
		while((getDvarInt( "ratingupdate" ) != 1) && (( curTime - startTime ) <  2000)  )
		{
			logprint("LOOP OF DOOM! -" + (curTime - startTime) + "-\n");
			wait 0.01;
			curTime = getTime();
		}
	}
}

endGame( winner )
{
	
	if ( game["state"] == "postgame" )
		return;

	visionSetNaked( "mp_postmatch", 2.0 );
	
	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level notify ( "game_ended" );
	
	thread maps\mp\gametypes\_missions::roundEnd();
	thread maps\mp\gametypes\_gamestats::processGameStats();
	
	updateLeaderboards();

	if ( level.xenon || level.ps3 || level.wii )
		setXenonRanks();

	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player freezePlayerForRoundEnd();

		player setClientDvar( "cg_everyoneHearsEveryone", "1" );	
	}

	updateGameScores( winner );
	level notify ( "update_teamscore_hud" );

	updateWinLossStats( winner );		
	updateLeaderboards();
		
	
	if ( level.splitscreen )
		setDvar("g_endgame", "1");

	if ( level.roundLimit != 1 && !level.forcedEnd )
	{
		game["roundsplayed"]++;

		thread announceRoundWinner( winner, 4 );

		wait ( level.roundEndDelay );

		if ( !hitRoundLimit() )
		{
			game["state"] = "playing";
			map_restart( true );
			return;
		}
		
		setTeamScore( "allies", getGameScore( "allies" ) );
		setTeamScore( "axis", getGameScore( "axis" ) );

		if ( getGameScore( "allies" ) == getGameScore( "axis" ) )
			winner = "tie";
		else if ( getGameScore( "allies" ) > getGameScore( "axis" ) )
			winner = "allies";
		else
			winner = "axis";
	}
	
	
	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player closeInGameMenu();
		
		if ( isdefined( winner ) )
		{
		
		}
		else
			continue;
	}
	
	if ( isdefined( winner ) )
		thread announceGameWinner( winner, 4 );
	
	wait level.postRoundTime;
	
	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player closeInGameMenu();
		player spawnIntermission();
	}

	















	wait 6.0;
	exitLevel( false );
}


updateLeaderboards()
{
	if ( !level.xboxlive )
		return;

	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
		players[index] sendleaderboards();
}



updateGameScores( winner )
{
	if ( level.teamBased )
	{
		if ( winner == "allies" )
		{
			winningTeam = "allies";
			losingTeam = "axis";
		}
		else if ( winner == "axis" )
		{
			winningTeam = "axis";
			losingTeam = "allies";
		}
		else
		{
			winningTeam = "tie";
			losingTeam = "tie";
		}
		
		if ( winningTeam != "tie" )
			game[winningTeam+"roundwins"]++;

		players = getEntArray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( winningTeam == "tie" )
				continue;
				
			
		}
	}
	else
	{
		if ( !isDefined ( winner ) )
			return;
		else
			winner.pers["roundwins"]++;
	}
}


setXenonRanks()
{
	players = getentarray( "player", "classname" );
	highscore = undefined;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if(!isdefined(player.score))
			continue;

		if(!isdefined(highscore) || player.score > highscore)
			highscore = player.score;
	}

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if(!isdefined(player.score))
			continue;

		if(highscore <= 0)
		{
			rank = 0;
		}
		else
		{
			rank = int(player.score * 10 / highscore);
			if(rank < 0)
				rank = 0;
		}

		if( player.pers["team"] == "allies" )
			setPlayerTeamRank(player, 0, rank);
		else if( player.pers["team"] == "axis" )
			setPlayerTeamRank(player, 1, rank);
		else if( player.pers["team"] == "spectator" )
			setPlayerTeamRank(player, 2, rank);
	}
	
}


getHighestScoringPlayer()
{
	players = getEntArray( "player", "classname" );
	winner = undefined;
	tie = false;
	
	for( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;
			
		if ( !isDefined( winner ) || players[i].score > winner.score )
		{
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			tie = true;
		}
	}
	
	if ( tie || !isDefined( winner ) )
		return undefined;
	else
		return winner;
}


checkTimeLimit()
{
	if ( game["state"] != "playing" )
		return;
		
	if ( level.timeLimit <= 0 )
		return;
		
	if ( level.timePassed < (level.timeLimit * 60) )
		return;
		
	[[level.onTimeLimit]]();
}


checkScoreLimit()
{
	if ( game["state"] != "playing" )
		return;

	if( level.scoreLimit <= 0 )
		return;

	if ( level.teamBased )
	{
		if( level.teamScores["allies"] < level.scoreLimit && level.teamScores["axis"] < level.scoreLimit )
			return;
	}
	else
	{
		if ( !isPlayer( self ) )
			return;

		if ( self.score < level.scoreLimit )
			return;
	}

	[[level.onScoreLimit]]();
}


hitRoundLimit()
{
	if( level.roundLimit <= 0 )
		return ( false );

	if ( game["alliesroundwins"] >= level.roundLimit || game["axisroundwins"] >= level.roundLimit )
		return ( true );

	if ( level.gameType == "as" || level.gameType == "vs" )
		if ( game["roundsplayed"] >= level.roundLimit )
			return ( true );

	return ( false );
}


registerRoundLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundlimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	
	level.roundLimitDvar = dvarString;
	level.roundlimitMin = minValue;
	level.roundlimitMax = maxValue;
	level.roundLimit = getDvarInt( level.roundLimitDvar );
	makeDvarServerInfo( dvarString );
}


registerMinPlayersDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_minplayers");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );

	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );

	level.minPlayersDvar = dvarString;
	level.minPlayersMin = minValue;
	level.minPlayersMax = maxValue;
	level.minPlayers = getDvarInt( level.minPlayersDvar );
	makeDvarServerInfo( dvarString );
}


registerScoreLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_scorelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.scoreLimitDvar = dvarString;	
	level.scorelimitMin = minValue;
	level.scorelimitMax = maxValue;
	level.scoreLimit = getDvarInt( level.scoreLimitDvar );
	makeDvarServerInfo( dvarString );
}


registerTimeLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_timelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarFloat( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarFloat( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.timeLimitDvar = dvarString;	
	level.timelimitMin = minValue;
	level.timelimitMax = maxValue;
	level.timelimit = getDvarFloat( level.timeLimitDvar );
}


registerNumLivesDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_numlives");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.numLivesDvar = dvarString;	
	level.numLivesMin = minValue;
	level.numLivesMax = maxValue;
	level.numLives = getDvarInt( level.numLivesDvar );
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "numlives" ) )
		level.numLives = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "numlives" );
}


getValueInRange( value, minValue, maxValue )
{
	if ( value > maxValue )
		return maxValue;
	else if ( value < minValue )
		return minValue;
	else
		return value;
}

updateGameTypeDvars()
{
	level endon ( "game_ended" );
	
	while ( game["state"] == "playing" )
	{
		roundlimit = getValueInRange( getDvarInt( level.roundLimitDvar ), level.roundLimitMin, level.roundLimitMax );
		if ( roundlimit != level.roundlimit )
		{
			level.roundlimit = roundlimit;
			level notify ( "update_roundlimit" );
		}

		timeLimit = getValueInRange( getDvarFloat( level.timeLimitDvar ), level.timeLimitMin, level.timeLimitMax );
		if ( timeLimit != level.timeLimit )
		{
			level.timeLimit = timeLimit;
			level notify ( "update_timelimit" );
		}
		thread checkTimeLimit();

		scoreLimit = getValueInRange( getDvarInt( level.scoreLimitDvar ), level.scoreLimitMin, level.scoreLimitMax );
		if ( scoreLimit != level.scoreLimit )
		{
			level.scoreLimit = scoreLimit;
			level notify ( "update_scorelimit" );
		}
		thread checkScoreLimit();
		
		wait 1;
	}
}


menuAutoAssign()
{
	teams[0] = "allies";
	teams[1] = "axis";
	assignment = teams[randomInt(2)];

	if ( level.teamBased )
	{
		playerCounts = maps\mp\gametypes\_teams::CountPlayers();
	
		
		if ( playerCounts["allies"] == playerCounts["axis"] )
		{
			if( getTeamScore( "allies" ) == getTeamScore( "axis" ) )
				assignment = teams[randomInt(2)];
			else if ( getTeamScore( "allies" ) < getTeamScore( "axis" ) )
				assignment = "allies";
			else
				assignment = "axis";
		}
		else if( playerCounts["allies"] < playerCounts["axis"] )
		{
			assignment = "allies";
		}
		else
		{
			assignment = "axis";
		}
		
		self [[level.setupCharacterOptions]]( assignment );
	
		if( assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
		    if( !isDefined( self.pers["class"] ) || self.pers["class"] == "" )
		    {
				  	if( self.pers["team"] == "allies" )
					    self openMenu( game["menu_class_allies"] );
				  	else
					    self openMenu( game["menu_class_axis"] );

					if (self.pers["team"] == "allies")
						self setclientdvar("g_scriptMainMenu", game["menu_changeclass_allies"]);
					else
						self setclientdvar("g_scriptMainMenu", game["menu_changeclass_axis"]);
					self setclientdvar( "cl_validloadout", "0" );  
					}
		    else
			{
			if (self.pers["team"] == "allies")
				self openMenu( game["menu_changeclass_allies"] );
			else
				self openMenu( game["menu_changeclass_axis"] );
			}
			return;
		}
	}

	if( assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		if ( level.teambased )
		self suicide();
	}

	self [[level.setupCharacterOptions]]( assignment );
	self.pers["team"] = assignment;
	self.pers["class"] = undefined;
	self.pers["skin"] = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["place"] = 0;

	self setclientdvar("ui_allow_classchange", "1");

		if( self.pers["team"] == "allies" )
		{	
			self openMenu(game["menu_class_allies"]);
			self setclientdvar("g_scriptMainMenu", game["menu_changeclass_allies"]); 
			self setclientdvar( "cl_validloadout", "0" );
		}
		else
		{	
			self openMenu(game["menu_class_axis"]);
			self setclientdvar("g_scriptMainMenu", game["menu_changeclass_axis"]); 
			self setclientdvar( "cl_validloadout", "0" ); 
		}

	self notify("joined_team");
	self notify("end_respawn");
}

setupCharacterOptions( team )
{
	
	bSet = false;
	if ( level.teambased )
	{
		if ( team == "axis" )
		{
			self setclientdvar("ui_axis", 1 );
			self setclientdvar("ui_axis_hero", 1);
			self setclientdvar("ui_ally", 0 );
			self setclientdvar("ui_ally_hero", 0);

			self setClientDvar( "ui_char", 30 );
			self setClientDvar( "ui_weap", 2 );
			self setClientDvar( "ui_exp", 0 );
			self setClientDvar( "ui_gad", 0 );
			bSet = true;
		}
		else
		if ( team == "allies" )
		{
			self setclientdvar("ui_axis", 0 );
			self setclientdvar("ui_axis_hero", 0 );
			self setclientdvar("ui_ally", 1 );
			self setclientdvar("ui_ally_hero", 1 );

			self setClientDvar( "ui_char", 10 );
			self setClientDvar( "ui_weap", 0 );
			self setClientDvar( "ui_exp", 0 );
			self setClientDvar( "ui_gad", 0 );
			bSet = true;
		}		
	}
	if( !bSet )
	{
		self setClientDvar( "ui_ally_hero", 1 );
		self setClientDvar( "ui_axis_hero", 1 );
		self setClientDvar( "ui_ally", 1 );
		self setClientDvar( "ui_axis", 1 );
			
		self setClientDvar( "ui_char", 10 );
		self setClientDvar( "ui_weap", 0 );
		self setClientDvar( "ui_exp", 0 );
		self setClientDvar( "ui_gad", 0 );
	}
}


CountPlayersBXsplit()
{
	
	players = getentarray("player", "classname");
	allies = 0;
	axis = 0;
	for(i = 0; i < players.size; i++)
	{
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies") && players[i] isclientplaying() )
			allies++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis") && players[i] isclientplaying() )
			axis++;
	}
	players["allies"] = allies;
	players["axis"] = axis;
	return players;
}


AutoBalanceBXSplit()
{
	

	players = getentarray("player", "classname");
	playerCounts = CountPlayersBXsplit();
	total = playerCounts["allies"] + playerCounts["axis"];

	readyPlayers = 0;
	for(i = 0; i < players.size; i++)
	{
		if ( isDefined( players[i].selectedClass ) && players[i] isclientplaying() )
			readyPlayers++;
	}

	
	if ( readyPlayers >= total - 1 )
	{
		for(i = 0; i < players.size; i++)
		{
			
			playerCounts = CountPlayersBXsplit();
	
			
			if ( players[i] == self )
				continue;
	
			
			if ( playerCounts["allies"] == 0 )
			{
				
				if( players[i].pers["team"] == "axis" && !isDefined( players[i].selectedClass ) && players[i] isclientplaying() )
				{
					players[i] closeMenu();
					players[i] closeInGameMenu();
					players[i] menuAllies();
				}
			}
			else if ( playerCounts["axis"] == 0 )
			{
				
				if( players[i].pers["team"] == "allies" && !isDefined( players[i].selectedClass ) && players[i] isclientplaying() )
				{
					players[i] closeMenu();
					players[i] closeInGameMenu();
					players[i] menuAxis();
				}
			}
			else
				break;
		}
	}

	
	playerCounts = maps\mp\gametypes\_teams::CountPlayers();

	
	
	for(i = 0; i < players.size; i++)
	{
		
		if( players[i] isclientplaying() )
			continue;

		
		if( playerCounts["allies"] < playerCounts["axis"] && players[i].pers["team"] == "axis" )
		{
			players[i] closeMenu();
			players[i] closeInGameMenu();
			players[i] menuAllies();
		}
		else if( playerCounts["allies"] > playerCounts["axis"] && players[i].pers["team"] == "allies" )
		{

			players[i] closeMenu();
			players[i] closeInGameMenu();
			players[i] menuAxis();
		}
	}	
}

menuAllies()
{
	
	if ( level.teambased && level.splitscreen )
	{
		
		if ( isDefined( self.selectedClass ) )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_axis"]);
			return;
		}
		else
		{
			

			players = getentarray("player", "classname");
			playerCounts = CountPlayersBXsplit();
			total = playerCounts["allies"] + playerCounts["axis"];

			readyAllies = 0;
			for(i = 0; i < players.size; i++)
			{
				if ( players[i].pers["team"] == "allies" && isDefined( players[i].selectedClass ) && players[i] isclientplaying() )
					readyAllies++;
			}

			if ( readyAllies >= total - 1 )
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu(game["menu_changeclass_axis"]);
				return;
			}
		}
	}

	if(self.pers["team"] != "allies")
	{
		
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			if( level.teambased )
			self suicide();
		}

		self [[level.setupCharacterOptions]]( "allies" );

		self.pers["team"] = "allies";
		self.pers["class"] = undefined;
		self.pers["skin"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self.pers["place"] = 0;

		self setclientdvar("ui_allow_classchange", "1");
		self setclientdvar("g_scriptMainMenu", game["menu_changeclass_allies"]);
		self setclientdvar( "cl_validloadout", "0" );

		self notify("joined_team");
		self notify("end_respawn");
		
		self openMenu(game["menu_class_allies"]);
	}
}


menuAxis()
{
	
	if ( level.teambased && level.splitscreen )
	{
		
		if ( isDefined( self.selectedClass ) )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_allies"]);
			return;
		}
		else
		{
			

			players = getentarray("player", "classname");
			playerCounts = CountPlayersBXsplit();
			total = playerCounts["allies"] + playerCounts["axis"];

			readyAxis = 0;
			for(i = 0; i < players.size; i++)
			{
				if ( players[i].pers["team"] == "axis" && isDefined( players[i].selectedClass ) && players[i] isclientplaying() )
					readyAxis++;
			}

			if ( readyAxis >= total - 1 )
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu(game["menu_changeclass_allies"]);
				return;
			}
		}
	}

	if(self.pers["team"] != "axis")
	{
		
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			if( level.teambased )
			self suicide();
		}

		self [[level.setupCharacterOptions]]( "axis" );

		self.pers["team"] = "axis";
		self.pers["class"] = undefined;
		self.pers["skin"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self.pers["place"] = 0;

		self setclientdvar("ui_allow_classchange", "1");

		self notify("joined_team");
		self notify("end_respawn");
		
		self setclientdvar("g_scriptMainMenu", game["menu_changeclass_axis"]);
		self setclientdvar( "cl_validloadout", "0" );  
    
		self openMenu(game["menu_class_axis"]);
	}
}


menuSpectator()
{
	if(self.pers["team"] != "spectator")
	{
		if(isAlive(self))
		{
			self.switching_teams = true;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.pers["class"] = undefined;
		self.pers["skin"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self.pers["place"] = 0;

		self.sessionteam = "spectator";
		self setclientdvar("ui_allow_classchange", "0");
		[[level.spawnSpectator]]();
		
		

		self notify("joined_spectators");
	}
}

menuClass(response)
{
	
	if ( level.teambased && level.splitscreen && !level.game_ready )
		self AutoBalanceBXSplit();

	if ( game["state"] == "intermission" )
		return;
	
	
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	team = self.pers["team"];

	class = self maps\mp\gametypes\_class::getResponseToken( response, "class", "/" );
	sidearm = self maps\mp\gametypes\_class::getResponseToken( response, "sidearm", "/" );

	
	if (team == "axis")
	{
		type = 30;
	}
	else
	{
		type = 10;
	}

	
	if (!isDefined( self.pers["skin"] ))
		self.pers["skin"] = "SKIN_MI6_00";

	if( class == "restricted" )
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_class_allies"]);
		else if(self.pers["team"] == "axis")
			self openMenu(game["menu_class_axis"]);

		return;
	}

	if( (isDefined( self.pers["class"] ) && self.pers["class"] == class) && self.pers["sidearm"] == sidearm ) 
		return;

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.pers["sidearm"] = sidearm;
		self.pers["weapon"] = undefined;
		self.pers["type"] = type;

		if ( level.inGracePeriod && !self.hasDoneCombat ) 
		{
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.pers["proficiency"] = self maps\mp\gametypes\_class::getProficiency( self maps\mp\gametypes\_class::getClass() );	
			self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
		}
	}
	else
	{
		if ( !isDefined( self.pers["class"] ) || self.pers["class"] == "" )
			self thread maps\mp\_utility::printJoinedTeam(self.pers["team"]);
			
		self.pers["class"] = class;
		self.pers["sidearm"] = sidearm;
		self.pers["weapon"] = undefined;
		self.pers["type"] = type;

		if ( game["state"] == "playing" || game["state"] == "prematch" || game["state"] == "countdown") 
			self thread [[level.spawnClient]]();
	}

	level [[level.updateTeamStatus]]();

	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}


updatePlacement()
{
	players = getentarray("player", "classname");

	if ( !players.size )
		return;

	for( i = 1; i < players.size; i++ )
	{
		player = players[i];
		for ( j = i - 1; j >= 0 && players[j].score < player.score; j-- )
			players[j + 1] = players[j];
		players[j + 1] = player;
	}

	lastPlace = 1;
	lastScore = players[0].score;

	if ( players[0].score )
		players[0].pers["place"] = lastPlace;
	else
		players[0].pers["place"] = 0;



	for ( i = 1; i < players.size; i++ )
	{
		if ( !players[i].score )
		{
			players[i].pers["place"] = 0;
			continue;
		}
		
		if ( players[i].score != lastScore )
		{
			lastPlace++;
			lastScore = players[i].score;
			players[i].pers["place"] = lastPlace;
		}
		else
		{
			players[i].pers["place"] = lastPlace;
		}
		

	}
}


onXPEvent( event )
{
	


}


givePlayerScore( event, player, victim )
{
	if ( level.overridePlayerScore )
		return;

	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim );
	
	
	
	
	

	
	
	

	
}


default_onPlayerScore( event, player, victim )
{
	player.pers["score"] += 1;
}


_setPlayerScore( player, score )
{
	if ( score == player.pers["score"] )
		return;

	
	if (score < 0)
		score = 0;

	player.pers["score"] = score;
	player.score = player.pers["score"];

	
	[[level.updatePlacement]]();
	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


_getPlayerScore( player )
{
	return player.pers["score"];
}


giveTeamScore( event, team, player, victim )
{
    if ( level.overrideTeamScore )
		return;
          
    teamScore = level.teamScores[team];
    [[level.onTeamScore]] ( event, team, player, victim );
    
    setTeamScore( team, getGameScore(team) );

    level notify ( "update_teamscore_hud" );
    thread checkScoreLimit();
}
 
_setTeamScore( team, teamScore )
{
    if ( teamScore == level.teamScores[team] )
		return;
 
    
    if (teamScore < 0)
		teamScore = 0;
 
    level.teamScores[team] = teamScore;
 
    setTeamScore( team, getGameScore( team ) );
 
    level notify ( "update_teamscore_hud" );
    thread checkScoreLimit();
}

_getTeamScore( team )
{
	return level.teamScores[team];
}


default_onTeamScore( event, team, player, victim )
{
	level.teamScores[team] += 1;
	setTeamScore( team, level.teamScores[team] );
}


initPersStat( dataName )
{
	if( !isDefined( self.pers[dataName] ) )
		self.pers[dataName] = 0;
}

getPersStat( dataName )
{
	return self.pers[dataName];
}

incPersStat( dataName, increment )
{
	self.pers[dataName] += increment;
	self maps\mp\gametypes\_persistence_util::statAdd( "stats", dataName, increment );
}

updatePersRatio( ratio, num, denom )
{
	numValue = self maps\mp\gametypes\_persistence_util::statGet( "stats", num );
	denomValue = self maps\mp\gametypes\_persistence_util::statGet( "stats", denom );
	if ( denomValue == 0 )
		denomValue = 1;
		
	self maps\mp\gametypes\_persistence_util::statSet( "stats", ratio, int( (numValue * 1000) / denomValue ) );		
}

updateTeamStatus()
{
	level endon ( "game_ended" );
	wait 0;	

	if ( game["state"] == "postgame" )
		return;

	resetTimeout();

	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;

	level.lastAliveCount["allies"] = level.aliveCount["allies"];
	level.lastAliveCount["axis"] = level.aliveCount["axis"];
	level.aliveCount["allies"] = 0;
	level.aliveCount["axis"] = 0;

	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( isDefined( player.pers["team"] ) && (player.pers["team"] != "spectator") && isdefined(player.pers["class"]) && (player.pers["class"] != "") )
		{
			level.playerCount[player.pers["team"]]++;
		
			if ( level.numLives )
			{
				if ( player.sessionstate == "playing" || (player.canSpawn && player.pers["lives"]) )
					level.aliveCount[player.pers["team"]]++;
			}
			else if( player.sessionstate == "playing" && !player.afk )
			{
				level.aliveCount[player.pers["team"]]++;
			}
		}
	}

	if( level.aliveCount["allies"] )
		level.everExisted["allies"] = true;
	if( level.aliveCount["axis"] )
		level.everExisted["axis"] = true;

	if ( game["state"] == "prematch" )
	{
		return;
	}

	level updateGameEvents();
}


timeCritical()
{
	playSoundOnPlayers( "GEN_Brit_CLOW_TME_01", "allies" );
	playSoundOnPlayers( "GEN_Terr_CLOW_TME_01", "axis" );
}


timeLow()
{
	playSoundOnPlayers( "GEN_Brit_CLOW_TME_03", "allies" );
	playSoundOnPlayers( "GEN_Terr_CLOW_TME_02", "axis" );
}


timeLimitClock()
{
	level endon ( "game_ended" );
	
	if ( game["state"] == "prematch"  || !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showtimer" ) )
		return;

	lastTimeLimit = -1;
	clockType = "";
	lowSoundPlayed = false;
	criticalSoundPlayed = false;

	while ( game["state"] == "playing" )
	{
		if ( level.timerStopped || level.timeLimit == 0 ) 
		{
			if ( isdefined( level.clock ) && level.clock.alpha != 0 )
				level.clock.alpha = 0;
					
			lastTimeLimit = -1;
		}
		else
		{	
			if ( isdefined( level.clock ) && level.clock.alpha != 1 )
				level.clock.alpha = 1;
					
			timeLeft = int((level.timeLimit * 60) - level.timePassed);

			if ( timeLeft <= 0 )
			{
				return;
			}
			else if ( timeLeft <= 10 )
			{
				clock = getClock( timeLeft, "tenths", false );
				
				if( !criticalSoundPlayed )
				{
					criticalSoundPlayed = true;
					[[level.timeCritical]]();
				}
			}
			else if ( timeLeft < 30 )
			{
				clock = getClock( timeLeft, "tenths", false );
				if( !lowSoundPlayed )
				{
					lowSoundPlayed = true;
					[[level.timeLow]]();
				}
			}
			else if ( level.timeLimit != lastTimeLimit )
			{
				lastTimeLimit = level.timeLimit;
				clock = getClock( timeLeft, "tenths", true );
			}
		}

		wait ( 1.0 );
	}
}


getClock( timeLeft, type, forceTimer )
{
	if ( !isDefined( level.clock ) )
	{
		level.clock = createServerTimer( "default", 1.75 );
		level.clock.type = type;
		level.clock.foreground = true;

		level.clock setPoint( "TOPLEFT", undefined, 0, 25 );
		
		if ( isDefined( level.hud_scoreBar ) )
		{
			level.clock setParent( level.hud_scoreBar );
			level.clock setPoint( "LEFT", "LEFT", 0, -3 );
		}
		
		if ( level.clock.type == "tenths" )
			level.clock setTenthsTimer( timeLeft );
		else
			level.clock setTimer( timeLeft );
		
		return level.clock;
	}
	else if ( level.clock.type != type || forceTimer )
	{
		level.clock.type = type;
		
		if ( type == "tenths" )
			level.clock setTenthsTimer( timeLeft );
		else
			level.clock setTimer( timeLeft );
	}
	
	return level.clock;
}


gameTimer()
{
	level endon ( "game_ended" );
	
	level.startTime = getTime();
	

	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped )
		{
			level.timePassed += 1;
			game["timepassed"] += 1.0;
		}
		wait ( 1.0 );
	}
}


startGame()
{
	level.timerStopped = false;


	thread maps\mp\gametypes\_spawnlogic::spawnSightChecks();

	if ( level.gracePeriod > 0 )
		thread gracePeriod();

	thread maps\mp\gametypes\_missions::roundBegin();	

	level.timePassed = 0;

	if (level.splitscreen)
		level waittill("game_ready");

	thread gameTimer();

	if (level.gametype != "bx_00rush" && level.gametype != "bx_team00rush")	
		thread timeLimitClock();
}


gracePeriod()
{
	level endon( "game_ended" );

	wait ( level.gracePeriod );

	level.inGracePeriod = false;

	if ( game["state"] != "playing" )
		return;

	if ( level.numLives )
	{
		
		players = getEntArray( "player", "classname" );

		for( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( !player.hasSpawned || !player.canSpawn )
			{
				if( player.sessionteam != "spectator" && !isAlive( player ) )
					player.statusicon = "hud_status_dead";
			}
		}
	}
}



fadeOutPlayers()
{
	
	timeremaining = level.roundEndDelay - (gettime() - level.roundEndTime);
	
	fadeouttime = level.fadeouttime;
	postfadeouttime = 0;
	if (game["state"] == "prematch_restart")
		postfadeouttime = level.postfadeouttime_matchstart;
	
	totalfadeouttime = fadeouttime + postfadeouttime;
	
	if (timeremaining > totalfadeouttime) {
		wait timeremaining - totalfadeouttime;
		timeremaining = totalfadeouttime;
	}
	
	if (timeremaining <= postfadeouttime) {
		thread fadeOut(1, 0.1);
	}
	else {
		startFade = (totalfadeouttime - timeremaining) / fadeouttime;
		thread fadeOut(startFade, timeremaining - postfadeouttime);
	}
}



fadeOut(startFade, fadeTime)
{
	fader = newHudElem();
	fader.x = 0;
	fader.y = 0;
	fader setshader ("black", 640, 480);
	fader.alignX = "left";
	fader.alignY = "top";
	fader.horzAlign = "fullscreen";
	fader.vertAlign = "fullscreen";
	fader.sort = 1000; 
	
	fader.alpha = 0;
	fader fadeOverTime(fadeTime);
	fader.alpha = 1;
}
fadeIn(preFadeTime, fadeTime)
{
	fader = newHudElem();
	fader.x = 0;
	fader.y = 0;
	fader setshader ("black", 640, 480);
	fader.alignX = "left";
	fader.alignY = "top";
	fader.horzAlign = "fullscreen";
	fader.vertAlign = "fullscreen";
	fader.sort = 1000; 
	
	fader.alpha = 1;
	
	wait preFadeTime;
	
	fader fadeOverTime(fadeTime);
	fader.alpha = 0;
}


announceRoundWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) )
	{


		announcement( game["strings"]["round_draw"] );
	}
	else if ( isPlayer( winner ) )
	{
	}
	else if ( winner == "allies" )
	{
		announcement( game["strings"]["allies_win_round"] );


	}
	else if ( winner == "axis" )
	{
		announcement( game["strings"]["axis_win_round"] );


	}
	else
	{



		announcement( game["strings"]["round_draw"] );
	}
}


announceGameWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) )
	{


		if ( level.gameType == "as" )
			announcement( "Round Limit Reached" );
		else
			announcement( game["strings"]["tie"] );
	}
	else if ( isPlayer( winner ) )
	{
	}
	else if ( winner == "allies" )
	{
		announcement( game["strings"]["allies_win"] );


	}
	else if ( winner == "axis" )
	{
		announcement( game["strings"]["axis_win"] );


	}
	else
	{


		if ( level.gameType == "as" )
			announcement( "Round Limit Reached" );
		else
			announcement( game["strings"]["tie"] );
	}
}

updateWinStats( winner )
{
	println( "setting winner: " + winner maps\mp\gametypes\_persistence_util::statGet( "stats", "wins" ) );
	winner maps\mp\gametypes\_persistence_util::statAdd( "stats", "wins", 1 );
	winner updatePersRatio( "wlratio", "wins", "losses" );
	winner maps\mp\gametypes\_persistence_util::statAdd( "stats", "cur_win_streak", 1 );
	
	cur_win_streak = winner maps\mp\gametypes\_persistence_util::statGet( "stats", "cur_win_streak" );
	if ( cur_win_streak > winner maps\mp\gametypes\_persistence_util::statGet( "stats", "win_streak" ) )
		winner maps\mp\gametypes\_persistence_util::statSet( "stats", "win_streak", cur_win_streak );
}


updateLossStats( loser )
{	
	loser maps\mp\gametypes\_persistence_util::statAdd( "stats", "losses", 1 );
	loser updatePersRatio( "wlratio", "wins", "losses" );
	loser maps\mp\gametypes\_persistence_util::statSet( "stats", "cur_win_streak", 0 );	
}


updateWinLossStats( winner )
{
	if ( level.roundLimit > 1 && !hitRoundLimit() )
		return;
		
	players = getentarray( "player", "classname" );

	if ( !isDefined( winner ) || ( isDefined( winner ) && !isPlayer( winner ) && winner == "tie" ) )
	{
		return;
	} 
	else if ( isPlayer( winner ) )
	{

		updateWinStats( winner );
		
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] == winner )
				continue;
			updateLossStats( players[i] );
		}		
	}
	else
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;
			else if ( players[i].pers["team"] == winner )
				updateWinStats( players[i] );
			else
				updateLossStats( players[i] );
		}
	}
}








giveRespawnPenalty(player)
{
	respawn_delay = int(getdvar("respawn_delay"));			
	respawn_delay_inc = int(getdvar("respawn_delay_inc"));	
	respawn_delay_max = int(getdvar("respawn_delay_max"));	

	if (!isDefined(respawn_delay) || !isDefined(respawn_delay_inc) || !isDefined(respawn_delay_max))
		return;
	
	if (!isDefined(player.respawn_penalty))
		player.respawn_penalty = 0;
	
	if (player.respawn_penalty == 0)
		player.respawn_penalty = respawn_delay;
	else if (player.respawn_penalty < respawn_delay_max)
		player.respawn_penalty += respawn_delay_inc;
}



spawnClient()
{
	assert(	isDefined( self.pers["team"] ) );
	assert( isDefined( self.pers["skin"] ) );
	assert(	isDefined( self.pers["class"] )	);
	assert( self.pers["skin"] != "" );
	assert(	self.pers["class"] != "" );
	
	self endon ( "disconnect" );
	self endon ( "end_respawn" );

	if ( game["state"] == "prematch" )
	{
		self thread	[[level.spawnPlayer]]();
		return;
	}

	respawnTime = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" );
	respawnDelay = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "respawndelay" );


	if ( level.gametype == "vs" && self.pers["team"] == level.team_bond )
	{
		respawnDelay = 0;
		respawnTime = 0;
	}

	
	if (isDefined(self.respawn_penalty))
		respawnDelay += self.respawn_penalty;
	
	if ( respawnTime )
		remainingTime = (level.waveDelay[self.pers["team"]] - (getTime() - level.lastWave[self.pers["team"]]) / 1000);
	else
		remainingTime = 0;

	if (isDefined(level.inkillcamtime)) 
	{
		respawnDelay -= level.inkillcamtime;
		if (respawnDelay < 0)
			respawnDelay = 0;
	}

	if ( level.numLives )
	{
		
		if ( !level.inGracePeriod && !self.hasSpawned )
			self.canSpawn = false;
		else if ( !self.pers["lives"] )
			self.canSpawn = false;
	}

	if ( !self.canSpawn )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;

		
		setLowerMessage( &"MP_SPAWN_NEXT_ROUND" );
		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);
		return;
	}

	self maps\mp\gametypes\_revive::waitForRevive();

	if ( respawnTime && (!level.inGracePeriod || self.hasSpawned) )
	{
		if ( respawnDelay > remainingTime )
		{
			setLowerMessage( &"MP_WAITING_TO_SPAWN", respawnTime + remainingTime );
			wait( respawnDelay );
		}
		else
		{
			setLowerMessage( &"MP_WAITING_TO_SPAWN", level.waveDelay[self.pers["team"]] - (getTime() - level.lastWave[self.pers["team"]]) / 1000 );
		}

		if ( self.pers["team"] == "allies" )
			level waittill ( "wave_respawn_allies" );
		else if	( self.pers["team"]	== "axis" )
			level waittill ( "wave_respawn_axis" );		
	}
	
	else if ( respawnDelay && (!level.inGracePeriod || self.hasSpawned) )
	{
		setLowerMessage( &"MP_WAITING_TO_SPAWN", respawnDelay );
		wait ( respawnDelay );
	}

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "forcerespawn" ) == 0 && self.hasSpawned && !respawnTime )
	{
		setLowerMessage( &"PLATFORM_PRESS_TO_SPAWN" );
		self waitRespawnButton();
	}
		
	self setLowerMessage( "" );
	self thread	[[level.spawnPlayer]]();
}


Callback_StartGameType()
{
	if ( !isDefined( game["gamestarted"] ) )
	{
		
		if ( !isDefined( game["allies"] ) )
			game["allies"] = "mi6";
		if ( !isDefined( game["axis"] ) )
			game["axis"] = "terrorists";
		if ( !isDefined( game["attackers"] ) )
			game["attackers"] = "allies";
		if (  !isDefined( game["defenders"] ) )
			game["defenders"] = "axis";

		if ( !isDefined( game["state"] ) )
		{
			if( level.doPrematch )
				game["state"] = "prematch";
			else if ( level.doCountdown )		
				game["state"] = "countdown";
			else if ( level.numLives )
				game["state"] = "prematch";
			else
				game["state"] = "playing";
		}
	
		precacheStatusIcon( "hud_status_dead" );
		precacheStatusIcon( "hud_status_connecting" );
		
		precacheRumble( "damage_heavy" );

		precacheString( &"PLATFORM_PRESS_TO_SPAWN" );
		precacheString( &"MP_YOUWEREKILLED");
		precacheString( &"MP_YOUKILLED");
		precacheString( &"MP_KILLED");
		precacheString( &"MP_WAITING_MATCH" );
		precacheString( &"MP_WAITING_FOR_TEAMS" );
		precacheString( &"MP_MATCH_STARTING_IN" );
		precacheString( &"MP_SPAWN_NEXT_ROUND" );
		precacheString( &"MP_WAITING_TO_SPAWN" );
	
		precacheShader( "white" );
		precacheShader( "black" );
		
		game["strings"]["allies_win"] = &"MP_ALLIES_WIN_MATCH";
		game["strings"]["axis_win"] = &"MP_OPFOR_WIN_MATCH";
		game["strings"]["allies_win_round"] = &"MP_ALLIES_WIN_ROUND";
		game["strings"]["axis_win_round"] = &"MP_OPFOR_WIN_ROUND";
		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";

		game["strings"]["bond_eliminated"] = &"MP_BOND_ELIMINATED";
		game["strings"]["terrorists_eliminated"] = &"MP_TERRORISTS_ELIMINATED";
		game["strings"]["bond_survived"] = &"MP_BOND_SURVIVED";

		game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
		game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
		game["strings"]["match_starting_in"] = &"MP_MATCH_STARTING_IN";
		game["strings"]["allies_mission_accomplished"] = &"MP_ALLIES_MISSION_ACCOMPLISHED";
		game["strings"]["axis_mission_accomplished"] = &"MP_OPFOR_MISSION_ACCOMPLISHED";
		game["strings"]["allies_eliminated"] = &"MP_ALLIES_ELIMINATED";
		game["strings"]["axis_eliminated"] = &"MP_OPFOR_ELIMINATED";
		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
		game["strings"]["allies_bomb_defused"] = &"MP_ALLIES_BOMB_DEFUSED";

		game["sounds"]["allies_last_alive"] = "us_mpc_inform_last_alive";
		game["sounds"]["axis_last_alive"] = "ab_mpc_inform_last_alive";

		precacheString( game["strings"]["allies_win"] );
		precacheString( game["strings"]["axis_win"] );
		precacheString( game["strings"]["allies_win_round"] );
		precacheString( game["strings"]["axis_win_round"] );
		precacheString( game["strings"]["tie"] );
		precacheString( game["strings"]["round_draw"] );
		precacheString( game["strings"]["waiting_for_teams"] );
		precacheString( game["strings"]["match_starting"] );
		precacheString( game["strings"]["match_starting_in"] );
		precacheString( game["strings"]["allies_mission_accomplished"] );
		precacheString( game["strings"]["axis_mission_accomplished"] );
		precacheString( game["strings"]["allies_eliminated"] );
		precacheString( game["strings"]["axis_eliminated"] );
		precacheString( game["strings"]["enemies_eliminated"] );

		[[level.onPrecacheGameType]]();
		
		game["gamestarted"] = true;
	}

	if(!isdefined(game["timepassed"]))
		game["timepassed"] = 0;

	if(!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;
	if(!isdefined(game["alliesroundwins"]))
		game["alliesroundwins"] = 0;	
	if(!isdefined(game["axisroundwins"]))
		game["axisroundwins"] = 0;
	
	level.skipVote = false;
	level.gameEnded = false;
	level.teamScores["allies"] = 0;
	level.teamScores["axis"] = 0;
	level.teamSpawnPoints["axis"] = [];
	level.teamSpawnPoints["allies"] = [];

	level.objIDStart = 0;
	level.forcedEnd = false;

	
	level.useStartSpawns = true;

	thread maps\mp\gametypes\_persistence::init();
	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	
	thread maps\mp\gametypes\_shellshock::init();
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\mp\gametypes\_grenadeindicators::init();
	thread maps\mp\gametypes\_objpoints::init();
	thread maps\mp\gametypes\_gamestats::init();
	

	thread maps\mp\gametypes\_rushobjects::init(); 	
	thread maps\mp\gametypes\_killstreaks::init();	

	thread maps\mp\gametypes\_spawnlogic::init();
	thread maps\mp\gametypes\_revive::init();
	
	if ( level.teamBased )
	{
		thread maps\mp\gametypes\_hud_teamscore::init();
		thread maps\mp\gametypes\_friendicons::init();
	}
	else
	{
		thread maps\mp\gametypes\_hud_playerscore::init();
	}
		
	
		
		
	thread maps\mp\gametypes\_hud_weapons::init();
	thread maps\mp\gametypes\_hud_message::init();

	if(level.xenon) 
		thread maps\mp\gametypes\_richpresence::init();
	else 
		thread maps\mp\gametypes\_quickmessages::init();

	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;
	level.aliveCount["allies"] = 0;
	level.aliveCount["axis"] = 0;
	level.lastAliveCount["allies"] = 0;
	level.lastAliveCount["axis"] = 0;
	level.everExisted["allies"] = false;
	level.everExisted["axis"] = false;

	if ( level.teamBased )
	{
		setObjectiveText( "allies", &"OBJECTIVES_TDM" );
		setObjectiveText( "axis", &"OBJECTIVES_TDM" );
		
		if ( level.splitscreen )
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_TDM" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_TDM" );
		}
		else
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_TDM_SCORE" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_TDM_SCORE" );
		}
		setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
		setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );
	}
	else
	{
		setObjectiveText( "allies", &"OBJECTIVES_DM" );
		setObjectiveText( "axis", &"OBJECTIVES_DM" );

		if ( level.splitscreen )
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
		}
		else
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
		}
		setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
		setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );
	}

	if ( !isDefined( level.minPlayers ) )
		registerMinPlayersDvar( "default", 2, 2, 24 );

	if ( !isDefined( level.timeLimit ) )
		registerTimeLimitDvar( "default", 20, 1, 1440 );
		
	if ( !isDefined( level.scoreLimit ) )
		registerScoreLimitDvar( "default", 100, 1, 500 );

	if ( !isDefined( level.roundLimit ) )
		registerRoundLimitDvar( "default", 1, 0, 10 );

	level.inGracePeriod = true;
	level.gracePeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "graceperiod" );
	level.roundEndDelay = 7;

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" ) )
	{
		level.waveDelay["allies"] = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" );
		level.waveDelay["axis"] = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" );
		level.lastWave["allies"] = 0;
		level.lastWave["axis"] = 0;
		
		level thread [[level.waveSpawnTimer]]();
	}

	setTeamScore( "allies", getGameScore( "allies" ) );
	setTeamScore( "axis", getGameScore("axis") );

	if ( game["state"] == "prematch" )
	{
		if( prematch() )
		{
			map_restart(true);
			return;
		}
	}

	if ( !isDefined( level.vision ) )
		level.vision = [];

	if ( !isDefined( level.vision["allies"] ) )
		level.vision["allies"] = "mp_default_mi6";

	if ( !isDefined( level.vision["axis"] ) )
		level.vision["axis"] = "mp_default_terrorist";

	visionSetAllied( level.vision["allies"], 0.0 );
	visionSetAxis( level.vision["axis"], 0.0 );

	if ( game["state"] == "countdown" )
	{
		[[level.onStartGameType]]();

		
		thread maps\mp\gametypes\_dev::init();

		countdown();

		game["state"] = "playing";
	}
	else
	{
		[[level.onStartGameType]]();

		
		thread maps\mp\gametypes\_dev::init();

		game["state"] = "playing";
	}

	thread startGame();
	level thread updateGameTypeDvars();
}


hasMinPlayers()
{
	if( getDvarInt("skip_prematch") )
		return true;

	players = getentarray("player", "classname");
	level.numplayers = players.size;
	level.minplayers = getDvarInt(level.minPlayersDvar);

	return( level.numplayers >= level.minplayers );
}


prematch()
{
	waited = 0;

	if( !hasMinPlayers() )
	{
		waited = 1;
		visionSetNaked( "mp_prematch", 0 );

		prematchElement = createServerFontString( "default", 2.0 );
		prematchElement setPoint( "TOP", undefined, 0, 30 );
		prematchElement setText( &"MP_WAITING_FOR_PLAYERS" );

		allowed = [];
		
		maps\mp\gametypes\_gameobjects::main(allowed);

		level.timerStopped = false;
		thread timeLimitClock();

		thread maps\mp\gametypes\_dev::init();

		
		while(1)
		{
			hasmin = hasMinPlayers();

			prematchElement setText( &"MP_WAITING_FOR_PLAYERS", " (" + level.numplayers + "/" + level.minplayers + ")" );

			if( hasmin )
				break;

			wait 0.01;
		}

		wait(1.0);
		thread fadeOut( 0, 1.0 );
		wait(1.0);

		prematchElement destroyElem();

		level.numplayers = undefined;
		level.minplayers = undefined;
	}

	game["state"] = "playing";

	return waited;
}


countdown()
{
	matchStartText = createServerFontString( "bigfixed", 1.5 );
	matchStartText setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( game["strings"]["waiting_for_teams"] );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;

	matchStartText setText( game["strings"]["match_starting_in"] );

	matchStartTimer = createServerFontString( "bigfixed", 2.2 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;

	matchStartTimer maps\mp\gametypes\_hud::fontPulseInit();

	countTime = 0;

	
	
	if (!level.splitscreen)
		countTime = int( maps\mp\gametypes\_tweakables::getTweakableValue("game","countdowntime") );

	level.countdownEnd = gettime() + (countTime * 1000);
	level notify("countdown_start");

	if ( countTime >= 2 )
	{
		while ( countTime > 0 && !level.gameEnded )
		{
			matchStartTimer setValue( countTime );
			matchStartTimer thread maps\mp\gametypes\_hud::fontPulse( level );
			countTime--;
			wait ( 1.0 );
		}
	}

	matchStartTimer destroyElem();
	matchStartText destroyElem();

	level notify("countdown_done");
	level.countdownEnd = undefined;
}


getGameScore( team )
{
	if ( level.roundLimit != 1 )
		return game[team+"roundwins"];
	else
		return level.teamScores[team];
}


Callback_PlayerConnect()
{
	thread dummy();

	self.statusicon = "hud_status_connecting";
	self waittill( "begin" );
	waittillframeend;
	self.statusicon = "";

	if( level.doClass )
		self thread maps\mp\gametypes\_class::heroPointsTick();

	level notify( "connected", self );

	
	if( !level.splitscreen && !isdefined( self.pers["score"] ) ) 
	{
		iPrintLn(&"MP_CONNECTED", self);
	}

	self [[level.onPlayerConnect]](); 

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	self setClientDvar( "ui_score_bar", getDvar( "ui_score_bar" ) );
	self setClientDvar( "ui_gametype_text", getDvar( "ui_gametype_text" ) );
	self SetClientDvar( "cg_rival", "-1" );

	
	if( isDefined(self.pers["team"]) )
	{
		self [[level.setupCharacterOptions]]( self.pers["team"] );
	}
	else
	{
		self [[level.setupCharacterOptions]]( "any" );
	}

	if( level.doHero )
	{
		if( !isDefined(self.pers["HeroPoints"]) )
		{
			self.pers["HeroPoints"] = 0;
		}
		self [[level.setupHeroAccess]](); 
	}

	if( !isDefined(self.pers["place"] ) )
		self.pers["score"] = 0;
	self.score = self.pers["score"];

	if ( !isDefined( self.attackers ) )
		self.attackers = [];

	
	
	self.deaths = 0;

	
	
	self.suicides = 0;	

	
	
	self.kills = 0;

	
	
	self.headshots = 0;
	
	
	
	self.assists = 0;
	
	
	
	self.teamkills = 0;

	self.cur_kill_streak = 0;
	self.cur_death_streak = 0;
	self.death_streak = self maps\mp\gametypes\_persistence_util::statGet( "stats", "death_streak" );
	self.kill_streak = self maps\mp\gametypes\_persistence_util::statGet( "stats", "kill_streak" );

	if( !isDefined(self.pers["place"] ) )
		self.pers["place"] = 0;

	if( !isDefined(self.pers["roundwins"] ) )
		self.pers["roundwins"] = 0;

	self.pers["lives"] = level.numLives;

	if ( level.numLives )
	{
		if ( !level.inGracePeriod )
			self.canSpawn = false;
		else
			self.canSpawn = true;
	}
	else
		self.canSpawn = true;

	self.hasSpawned = false;

	if ( level.numLives )
	{
		self setClientDvar( "cg_deadChatWithDead", "1" );
		
		self setClientDvar( "cg_deadHearTeamLiving", "0" );
		self setClientDvar( "cg_deadHearAllLiving", "0" );
	}
	else
	{
		self setClientDvar( "cg_deadChatWithDead", "0" );
		
		self setClientDvar( "cg_deadHearTeamLiving", "1" );
		self setClientDvar( "cg_deadHearAllLiving", "0" );
	}
	
	if( game["state"] == "intermission" )
	{
		[[level.spawnIntermission]]();
		return;
	}

	level endon( "intermission" );

	self [[level.overrideTeam]]();

	if ( !isDefined( self.pers["team"] ) || level.gametype == "rec" )  
	{
		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";
		[[level.spawnSpectator]]();
		
		
			[[level.autoassign]]();

		
		self.sessionteam = self.pers["team"];
		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
	}
	else if( self.pers["team"] != "spectator" )
	{
		if (self.pers["team"] == "axis" )
			scriptMainMenu = game["menu_class_axis"];
		else
			scriptMainMenu = game["menu_class_allies"];

		if( level.gametype == "vs" )
			self setClientDvar( "ui_allow_classchange", "0" );
		else 
			self setClientDvar( "ui_allow_classchange", "1" );

		if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
		{
			[[level.spawnSpectator]](); 
			self thread [[level.spawnClient]]();				
		}
		else
		{
			self openMenu( scriptMainMenu );
		}
	}
}


Callback_PlayerDisconnect()
{
	if( !level.splitscreen )
		iPrintLn( &"MP_DISCONNECTED", self );

	if( isDefined( self.pers["team"] ) )
	{
		if( self.pers["team"] == "allies" )
			setPlayerTeamRank( self, 0, 0 );
		else if( self.pers["team"] == "axis" )
			setPlayerTeamRank( self, 1, 0 );
		else if( self.pers["team"] == "spectator" )
			setPlayerTeamRank( self, 2, 0 );
	}
	
	[[level.onPlayerDisconnect]]();
	
	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
	
	level [[level.updateTeamStatus]]();
}


Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( game["state"] == "postgame" )
		return;

	if(self.sessionteam == "spectator")
		return;

	if ( isDefined( self.canDoCombat ) && !self.canDoCombat )
		return;

	if ( isDefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;

	prof_begin( "Callback_PlayerDamage flags/tweaks" );

	self.lastHitPos = vPoint;

	
	if( !isDefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	friendly = false;

	if ( (level.teamBased && (self.health == self.maxhealth)) || !isDefined( self.attackers ) )
		self.attackers = [];

	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	if ( sMeansOfDeath != "MOD_HEAD_SHOT" && game["state"] != "prematch" )
	{
		if ( maps\mp\gametypes\_tweakables::getTweakableValue( "game", "onlyheadshots" ) )
			return;
	}
	
	if ( isdefined( level.tweakPlayerDamage ) )
	{
		iDamage = self [[level.tweakPlayerDamage]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon);

		if (iDamage == 0)
			return;
	}

	self thread [[level.onPlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	
	prof_end( "Callback_PlayerDamage flags/tweaks" );

	
	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{
		if( level.teamBased && isPlayer( eAttacker ) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]) )
		{
			prof_begin( "Callback_PlayerDamage player" );
			if(level.friendlyfire == 0)
			{
				if (sWeapon != "artillery_mp") 
				{
					 
					self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, 0 ); 
					prof_end( "Callback_PlayerDamage player" );
					return;
				}
			}
			else if(level.friendlyfire == 1)
			{
				
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
			}
			else if(level.friendlyfire == 2)
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				
				if(iDamage < 1)
					iDamage = 1;

				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}
			else if(level.friendlyfire == 3)
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}

			friendly = true;

			
			self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, iDamage );
			self PlayRumbleOnEntity( "damage_heavy" );
			
			prof_end( "Callback_PlayerDamage player" );
			
			if ( level.friendlyfire == 0 && sWeapon == "artillery_mp" )
				return;
		}
		else
		{
			prof_begin( "Callback_PlayerDamage world" );
			
			if(iDamage < 1)
				iDamage = 1;

			if ( level.teamBased && isDefined( eAttacker ) && isPlayer( eAttacker ) )
			{
				if(!isdefined(self.attackers[eAttacker.clientid]))
					self.attackers[eAttacker.clientid] = iDamage;
				else
					self.attackers[eAttacker.clientid] += iDamage;
			}

			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

			
			self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, iDamage );
			self PlayRumbleOnEntity( "damage_heavy" );

			self thread maps\mp\gametypes\_missions::playerDamaged(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );

			prof_end( "Callback_PlayerDamage world" );
		}

		if ( isdefined(eAttacker) && eAttacker != self )
			eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
		
		self.hasDoneCombat = true;
	}

	if ( isdefined(eAttacker) && eAttacker != self && !friendly )
		level.useStartSpawns = false;

	if ( game["state"] == "prematch" )
		return;

	prof_begin( "Callback_PlayerDamage log" );

	
	if(getDvarInt("g_debugDamage"))
		println("client:" + self getEntityNumber() + " health:" + self.health + " damage:" + iDamage + " hitLoc:" + sHitLoc);

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}

	prof_end( "Callback_PlayerDamage log" );
}


triggerVoicePipe(playera, playerb)
{
	
	if ( !isPlayer(playera) || !isPlayer(playerb) )
	{
		return;
	}
	
	
	playera endon("disconnect");
	playerb endon("disconnect");
	
	
	if(playera == playerb)
	{
		return;
	}
	
	/#
	if(getDvarInt("xenon_voiceDebug") == 1)
	{
		iprintln("Enabling voice between ", playera ," and ", playerb, "\n");
	}
	#/
	
	enablevoicepipe( playera, playerb );
	wait getDvarInt( "cg_VoicePipesDuration" );
	
	/#
	if(getDvarInt("xenon_voiceDebug") == 1)
	{
		iprintln("Disabling voice between ", playera ," and ", playerb, "\n");
	}
	#/
	
	disablevoicepipe( playera, playerb );
}


Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon( "spawned" );
	self notify( "killed_player" );

	level thread triggerVoicePipe(attacker, self);
	
	
	if ( isDefined( attacker ) && level.doHero )
	{
		attacker [[level.giveHeroPoints]]( 1 );
	}

	if(self.sessionteam == "spectator")
		return;

	if ( game["state"] == "postgame" )
		return;

	if ( game["state"] == "prematch") 
	{
		self.sessionstate = "dead";
		self.statusicon = "hud_status_dead";

		body = self clonePlayer( deathAnimDuration );

		self.switching_teams = undefined;
		self.joining_team = undefined;
		self.leaving_team = undefined;

		wait 2;
		
		if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
			self thread [[level.spawnClient]]();

		return;
	}
	
	prof_begin( "PlayerKilled pre constants" );

	
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	[[level.onDeathOccurred]]( self, attacker );

	
	if (  shouldDropWeapon() )
	{
		self maps\mp\gametypes\_weapons::dropWeapon();
		
	}

	if( level.doHero )
	{
		if( self getPlayerType() != 1 )
		{
			self setPlayerType( 1 ); 
			maps\mp\gametypes\_class::setupHeroAccessAll();
			if ( isDefined( attacker ) )
			{
				attacker [[level.giveHeroPoints]]( 2 );
			}
		}
		else
		{
			if ( isDefined( attacker ) )
			{	
				attacker [[level.giveHeroPoints]]( 1 );
			}
		}
	}

	maps\mp\gametypes\_spawnlogic::deathOccured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;

	if( !isDefined( self.switching_teams ) || !level.teambased)
	{
		
		
		self.deaths += 1; 

		self.cur_kill_streak = 0;		
		self.cur_death_streak++;
		
		if ( self.cur_death_streak > self.death_streak )
		{
			self maps\mp\gametypes\_persistence_util::statSet( "stats", "death_streak", self.cur_death_streak );
			self.death_streak = self.cur_death_streak;
		}
	}
	
	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpattackGuid = "";
	lpattackname = "";
	lpselfteam = "";
	lpselfguid = self getGuid();
	lpattackerteam = "";

	lpattacknum = -1;
	
	prof_end( "PlayerKilled pre constants" );

	if( isPlayer( attacker ) )
	{
		lpattackGuid = attacker getGuid();
		lpattackname = attacker.name;

		if ( attacker == self ) 
		{
			prof_begin( "PlayerKilled suicide" );
			
			doKillcam = false;

			givePlayerScore("suicide", attacker, self);

			
			if ( isDefined( self.switching_teams ) )
			{
				if ( !level.teamBased && ((self.leaving_team == "allies" && self.joining_team == "axis") || (self.leaving_team == "axis" && self.joining_team == "allies")) )
				{
					playerCounts = maps\mp\gametypes\_teams::CountPlayers();
					playerCounts[self.leaving_team]--;
					playerCounts[self.joining_team]++;
				
					if( (playerCounts[self.joining_team] - playerCounts[self.leaving_team]) > 1 )
					{
						self thread [[level.onXPEvent]]( "suicide" );
						
						
						self.suicides += 1;
					}
				}
			}
			else
			{
				self thread [[level.onXPEvent]]( "suicide" );
				
				
				self.suicides += 1;

				
				
				
			}
			
			if( isDefined( self.friendlydamage ) )
				self iPrintLn(&"MP_FRIENDLY_FIRE_WILL_NOT");

			prof_end( "PlayerKilled suicide" );
		}
		else
		{
			prof_begin( "PlayerKilled attacker" );
			
			
			
			
			if (level.splitscreen)
			{
				attacker iPrintLn(&"MP_YOUKILLED",self);
				self	 iPrintLn(&"MP_YOUWEREKILLED",attacker);
			}

			lpattacknum = attacker getEntityNumber();
			
			doKillcam = false; 
			
			if( level.teamBased && self.pers["team"] == attacker.pers["team"] ) 
			{
				attacker thread [[level.onXPEvent]]( "teamkill" );

				
				
				attacker.teamkills += 1;

				givePlayerScore("teamkill",attacker,self);
				
				
				
				
			}
			else
			{
				prof_begin( "PlayerKilled stats and xp" );
				if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
				{
					
					
					attacker.headshots += 1;
					
					attacker thread [[level.onXPEvent]]( "headshot" );
				}
				else
				{
					attacker thread [[level.onXPEvent]]( "kill" );
				}

				
				
				attacker.kills += 1;

				attacker.cur_kill_streak++;
				attacker.cur_death_streak = 0;

				if ( attacker.cur_kill_streak > attacker.kill_streak )
				{
					attacker maps\mp\gametypes\_persistence_util::statSet( "stats", "kill_streak", attacker.cur_kill_streak );
					attacker.kill_streak = attacker.cur_kill_streak;
				}
				
				givePlayerScore( "kill", attacker, self );
				if ( level.teamBased )
					giveTeamScore( "kill", attacker.pers["team"],  attacker, self );

				
				
				
				level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );
				prof_end( "PlayerKilled stats and xp" );
	
				if ( level.teamBased )
				{ 
					prof_begin( "PlayerKilled assists" );
					
					
					
					
					
					prof_begin( "PlayerKilled assists" );
				}
				level thread maps\mp\gametypes\_gamestats::updateKill( attacker, self, sWeapon );
			}
			
			prof_end( "PlayerKilled attacker" );
		}
	}
	else
	{
		prof_begin( "PlayerKilled world" );
		
		doKillcam = false;
		
		killedByEnemy = false;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";

		
		if ( isDefined( attacker ) && isDefined( attacker.team ) && (attacker.team == "axis" || attacker.team == "allies") )
		{
			if ( attacker.team != self.pers["team"] ) 
			{
				killedByEnemy = true;
				if ( level.teamBased )
					giveTeamScore( "kill", attacker.team, attacker, self );
			}
		}
		prof_end( "PlayerKilled world" );
	}

	prof_begin( "PlayerKilled post constants" );
	self thread maps\mp\gametypes\_missions::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );

	logPrint( "K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n" );

	level thread [[level.updateTeamStatus]]();

	self playSound( "generic_death" ); 

	body = self clonePlayer( deathAnimDuration );
	self.body = body;
	if ( !isDefined( self.switching_teams ) || !level.teambased)
	{
		thread maps\mp\gametypes\_deathicons::addDeathicon( body, self, self.pers["team"], 7.0 );
		maps\mp\gametypes\_revive::onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	}

	
	
	if ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE" || sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_PROXMINE" )
	{
		if( getDvar( "grenade_explosive_scale" ) == "" )
			setDvar( "grenade_explosive_scale", 1.0 );

		hitpos = self.origin;
		if( isDefined(self.lastHitPos) )
			hitpos = self.lastHitPos;

		body startragdoll(0, hitpos, 50, 500, getDvarFloat("grenade_explosive_scale"));
	}
	else if ( sMeansOfDeath == "MOD_FALLING" )
	{
		body startragdoll();
	}
	else
	{
		body thread waitDoRagdoll( 2 );	
	}
	

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	doKillcam = false; 

	delay = (deathAnimDuration / 1000) + 0.5;
	delay = min(delay, 2);
	
	
	wait delay;	

	level.inkillcamtime = 0;
	if ( doKillcam && level.killcam)
		self maps\mp\gametypes\_killcam::killcam( lpattacknum, sWeapon, delay, psOffsetTime, !(level.numLives && !self.pers["lives"]), timeUntilRoundEnd() );
	
	prof_end( "PlayerKilled post constants" );

	if ( game["state"] != "playing" )
		return;

	
	if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
		self thread [[level.spawnClient]]();
}


waitDoRagdoll( duration )
{
	if ( duration )
		wait duration;

	self startragdoll();
}


Callback_PlayerLastStand( eInflictor, attacker, deathAnimDuration )
{
	self takeallweapons();
	self giveWeapon( "beretta_mp" );
	self thread lastStandTimer( 10 );
}


lastStandTimer( delay )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	wait delay;
	self suicide();
}


shouldDropWeapon()
{
	if( !IsDefined( self.dropWeaponOnDeath ) )
	{
		return true;
	}

	return self.dropWeaponOnDeath;
}


setSpawnVariables()
{
	self clearAnimScriptEvent();

	resetTimeout();

	
	self StopShellshock();
	self StopRumble( "damage_heavy" );

	
	self setClientDvar( "ui_hud_showGPS", "1" );
	self setClientDvar( "ui_hud_showscore", "1" );
	self setClientDvar( "ui_hud_showweaponinfo", "1" );
	self setClientDvar( "ui_hud_showstanceicon", "1" );
	self setClientDvar( "ui_3dwaypointtext", "1" );
}

dummy()
{
	waittillframeend;

	if( isDefined( self ) )
		level notify( "connecting", self );
}


setObjectiveText( team, text )
{
	game["strings"]["objective_"+team] = text;
	precacheString( text );
}

setObjectiveScoreText( team, text )
{
	game["strings"]["objective_score_"+team] = text;
	precacheString( text );
}

setObjectiveHintText( team, text )
{
	game["strings"]["objective_hint_"+team] = text;
	precacheString( text );
}

getObjectiveText( team )
{
	return game["strings"]["objective_"+team];
}

getObjectiveScoreText( team )
{
	return game["strings"]["objective_score_"+team];
}

getObjectiveHintText( team )
{
	return game["strings"]["objective_hint_"+team];
}
