#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	// hack to allow maps with no scripts to run correctly
	if ( !isDefined( level.tweakablesInitialized ) )
		maps\mp\gametypes\_tweakables::init();
		
	maps\mp\gametypes\_battlechatter_mp::init();
	
	level.splitscreen = isSplitScreen();
	level.xenon = (getdvar("xenonGame") == "true");
	level.ps3 = (getdvar("ps3Game") == "true");

	level.bx = (getdvar("BxGame") == "true"); //GEBE

	if ( level.xenon || level.bx )
		level.xboxlive = getDvarInt( "onlinegame" );
	else
		level.xboxlive = false;

	//Find out if we are online and in a ranked match for stats and leaderboards
	level.onlineGame = getDvarInt( "onlinegame" );
	level.rankedMatch = ( level.onlineGame && !getDvarInt( "xblive_privatematch" ) );

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
		case "as":
			setDvar( "ui_gametype_text", "@MPUI_ASSASSINATION" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_ASSASSINATION_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_ASSASSINATION_INST_MI6" );
			break;
		case "koth":
			setDvar( "ui_gametype_text", "@MPUI_KING_OF_THE_HILL" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_ASSASSINATION_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_ASSASSINATION_INST_MI6" );
			break;
		case "os":
			setDvar( "ui_gametype_text", "@MPUI_ARCADE_MODE" );
			setDvar( "ui_gametype_text_instr", "@MPUI_DEATHMATCH_INST" );
			break;
		case "vs":
			setDvar( "ui_gametype_text", "@MPUI_BOND_VERSUS" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_BOND_VERSUS_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_BOND_VERSUS_INST_MI6" );
			break;
		case "be":
			setDvar( "ui_gametype_text", "@MPUI_BOND_ESCAPE" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_BOND_VERSUS_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_BOND_VERSUS_INST_MI6" );
			break;
		default:
			setDvar( "ui_gametype_text", "@MPUI_TEAM_DEATHMATCH" );
			setDvar( "ui_gametype_text_instr_org", "@MPUI_TEAM_DEATHMATCH_INST_ORG" );
			setDvar( "ui_gametype_text_instr_mi6", "@MPUI_TEAM_DEATHMATCH_INST_MI6" );
			break;
	}
	
	level.teamBased = false;
	level.doPrematch = false;
	level.doCountdown = true;
	level.countdownTime = 10;
	dvarCountdownTime = getdvar( "scr_countdownTime" );
	if( dvarCountdownTime != "" )
		level.countdownTime = int( dvarCountdownTime );
	level.spawnPlayerWithDefaultLoadout = true;

	level.overrideTeamScore = false;
	level.overridePlayerScore = false;

	level.doClass = true;
	level.doHero = true;
	level.doAutoAssign = false;
	level.allowClassChange = true;
	
	// true = level.roundLimit of 2 means one side (axis or allies) has to win 2 rounds
	// false = level.roundLimit of 2 means 2 rounds regardless of who wins
	level.useRoundLimitAsWinsPerTeam = true;
	
	level.postRoundTime = 4.0;
	
	registerDvars();

	level.oldschool = ( level.gametype == "os" );
	if ( level.oldschool )
	{
		logString( "game mode: oldschool" );
	
		setDvar( "jump_height", 64 );
		setDvar( "jump_slowdownEnable", 0 );
		setDvar( "bg_fallDamageMinHeight", 256 );
		setDvar( "bg_fallDamageMaxHeight", 512 );
		level.doClass = false;
		level.doHero = false;
		level.allowClassChange = false;
		level.spawnClient = maps\mp\gametypes\os::spawnClient;
	}	
	else
	{
		// remove our oldschool pickups in the maps
		maps\mp\gametypes\os::deletePickups();
		return;
	}

	// Austin (2/4/08) Hack to remove weapons meant for spy 
	if ( level.gametype != "spy" )
	{
		spyWeapons = getentarray( "spy_weapon_spawn", "targetname" );

		for ( i = 0; i < spyWeapons.size; i++ )
		{
			spyWeapons[i] delete();
		}
	}
}

registerDvars()
{
	if ( getdvar( "scr_oldschool" ) == "" )
		setdvar( "scr_oldschool", "0" );
		
	makeDvarServerInfo( "scr_oldschool" );
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
	
	level.onXPEvent = ::onXPEvent;
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
	level.onPlayerKilled = ::blank;
	level.onDeathOccurred = ::blank;
	level.onPlayerTeamAssigned = ::blank;
	level.onRoundEnded = ::blank;
	

	level.autoassign = ::menuAutoAssign;
	level.spectator = ::menuSpectator;
	level.class = ::menuClass;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
	level.setupCharacterOptions = ::setupCharacterOptions;
	
	level.pointMultiplier = 10;
}


blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
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
		//&"MP_DRAW"
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
				
			//player playLocalSound( game["sounds"][team+"_last_alive"] );
		}
	}
}


default_onTimeLimit()
{
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

	playSoundOnPlayers( "Tann_MP_12" );
	setdvar( "g_roundEndReason", "timelimit" );

	iPrintLn( game["strings"]["time_limit_reached"] );
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


default_onScoreLimit()
{
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

	playSoundOnPlayers( "Tann_MP_1" );
	setdvar( "g_roundEndReason", "scorelimit" );

	iPrintLn( game["strings"]["score_limit_reached"] );
	[[level.endGame]]( winner );
}


updateGameEvents()
{
	if ( !level.numLives )
		return;

	if ( level.teamBased )
	{
		// if both allies and axis were alive and now they are both dead in the same instance
		if ( level.lastAliveCount["allies"] && !level.aliveCount["allies"] && level.lastAliveCount["axis"] && !level.aliveCount["axis"] )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}

		// if allies were alive and now they are not
		if ( level.lastAliveCount["allies"] && !level.aliveCount["allies"] )
		{
			[[level.onDeadEvent]]( "allies" );
			return;
		}

		// if axis were alive and now they are not
		if ( level.lastAliveCount["axis"] && !level.aliveCount["axis"] )
		{
			[[level.onDeadEvent]]( "axis" );
			return;
		}

		// one ally left
		if ( level.lastAliveCount["allies"] > 1 && level.aliveCount["allies"] == 1 )
		{
			[[level.onOneLeftEvent]]( "allies" );
			return;
		}

		// one axis left
		if ( level.lastAliveCount["axis"] > 1 && level.aliveCount["axis"] == 1 )
		{
			[[level.onOneLeftEvent]]( "axis" );
			return;
		}
	}
	else
	{
		// everyone is dead
		if ( (level.lastAliveCount["allies"] || level.lastAliveCount["axis"]) && (!level.aliveCount["allies"] && !level.aliveCount["axis"]) )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}

		// last man standing
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

setPlayerMainMenuToIngame()
{
	ingameMenu = game["menu_ingame"];

	if( isDefined( self.pers["team"] ) && self.pers["team"] != "" )
	{
		if( self.pers["team"] == "allies" )
		{
			ingameMenu = game["menu_ingame_allies"];
		}
		else if( self.pers["team"] == "axis" )
		{
			ingameMenu = game["menu_ingame_axis"];
		}
	}

	self setclientdvar("g_scriptMainMenu", ingameMenu);
}

setPlayerMainMenuToClassSelect()
{
	self setclientdvar("g_scriptMainMenu", game["menu_class"] );
}

doLoadout()
{
	self.pers["proficiency"] = self maps\mp\gametypes\_class::getProficiency( self maps\mp\gametypes\_class::getClass() );	
	self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
}

setObjectiveTextDvar( dvarName, useMenuText )
{
	if( !isDefined( useMenuText ) )
		useMenuText = false;

	team = self.pers["team"];
	if( isDefined( self.isBond ) && self.isBond )
	{
		team = "bond";
		if( !isDefined( getObjectiveMenuText( team ) ) )
		{
			team = self.pers["team"];
		}
	}
	if( level.scorelimit > 0 && !useMenuText )
	{
		if ( level.splitScreen )
			self setclientdvar( dvarName, getObjectiveScoreText( team ) );
		else
			self setclientdvar( dvarName, getObjectiveScoreText( team ), level.scorelimit );
	}
	else
	{
		if( useMenuText )
		{
			self setclientdvar( dvarName, getObjectiveMenuText( team ) );
		}
		else
		{
			self setclientdvar( dvarName, getObjectiveText( team ) );
		}
	}
}

spawnPlayer()
{
	self endon("disconnect");
	self endon("joined_spectators");

	if( level.doClass )
	{
		bValid = self maps\mp\gametypes\_class::validateLoadout( self.pers["team"], self.pers["class"] );
		if ( !bValid )
		{
			// The loadout we tried to give them isn't valid, first try the last normal settings, if they're available.
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

			// If that failed, force the default loadout on them.
			if( !bValid )
			{
				menuClass( maps\mp\gametypes\_globallogic::getDefaultLoadout() );
				bValid = self maps\mp\gametypes\_class::validateLoadout( self.pers["team"], self.pers["class"] );
				if ( game["state"] == "prematch" || game["state"] == "countdown"  )
				{
					self openMenu( game["menu_warmup"] );
					return;
				}
				else
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
	if( level.oldschool )
		self.maxhealth = 200;
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.afk = false;
	self.pers["lives"]--;
	
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;


	if ( game["state"] == "prematch" || level.forcedEnd || game["state"] == "postgame" )
		prematchSpawnPlayer();
	else
		[[level.onSpawnPlayer]]();

	level [[level.updateTeamStatus]]();

	if( level.doClass )
		self maps\mp\gametypes\_class::setClass( self.pers["class"] );

	self maps\mp\gametypes\_teams::model( self.pers["skin"] );

	if( isDefined( self.pers["team"] ) && self.pers["team"] != "" )
	{
		self setPlayerMainMenuToIngame();
		self setclientdvar( "cl_validloadout", "1" );
	}

	if( level.oldschool )
	{
		self maps\mp\gametypes\os::giveLoadout();
	}
	else
	{
		self [[level.doLoadout]]();
	}

	if ( game["state"] != "prematch" )
	{
		self setObjectiveTextDvar( "cg_objectiveText" );
		self setObjectiveTextDvar( "cl_objective_text", true );
	}

	if ( game["state"] == "countdown" )
	{
		// happens on a map_restart
		if( !isdefined(level.countdownEnd) )
			level waittill("countdown_start");

		self freezeControls( true );
		if( level.doClass )
		{
			self setPlayerMainMenuToClassSelect();
		}

		self setClientDvar( "cl_match_warmup", "1" );

		level waittill("countdown_done");

		self setPlayerMainMenuToIngame();
		self setClientDvar( "cl_match_warmup", "0" );

		self freezeControls( false );
	}

	maps\mp\gametypes\_cinematic::addClient(self);

	maps\mp\gametypes\_cinematic::waitForCinematic(self.pers["team"]);

	if ( !hadSpawned && game["state"] == "playing" )
		thread maps\mp\gametypes\_hud_message::hintMessage( getObjectiveHintText( self.pers["team"] ) );
	
	waittillframeend;
	self notify( "spawned_player" );

	self setClientDvar( "ui_team_name", self.pers["team"] );

//	self thread watchAFK();

	if ( game["state"] == "postgame" )
	{
		//assert( !level.intermission );
		// We're in the victory screen, but before intermission
		self freezePlayerForRoundEnd();
	}
}


freezePlayerForRoundEnd()
{
//	self clearLowerMessage();

	self ClearAnimScriptEvent();

	self closeMenu();
	self closeInGameMenu();

	self freezeControls( true );
	//	self disableWeapons();
}


prematchSpawnPlayer()
{
	[[level.spawnSpectator]]();
}


watchAFK()
{
	afkTimeThreshold = 15; // a player who does nothing for 15 seconds is considered afk
	
	self.afk = false;
	
	// we don't care about people being AFK if this isn't an elimination based gametype
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
			(self.origin != oldorigin) || // if they have moved, they are not afk
			(self getPlayerAngles() != oldangles) || // if they are looking in a different direction, they are not afk
			(self playerADS() > 0 || self playerADS() != oldads) // if they are ADS, or have changed from being ADS previously, they are not afk
		) {
			afkTime = 0;

			if (self.afk) {
				self.afk = false;
				[[level.updateTeamStatus]]();
			}

			// if they move even once, ever, they are no longer AFK for the rest of the round.
			// this is in case they decide to camp or hide somewhere, we don't want them to lose the round for it.
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

	if ( game["state"] != "prematch" || game["state"] != "countdown" ) {
		self setPlayerMainMenuToIngame();
		self openMenu( game["menu_warmup"] );
	}

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

// returns the best guess of the exact time until the scoreboard will be displayed and player control will be lost.
// returns undefined if time is not known
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

endGame( winner )
{
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" )
		return;

	//visionSetNaked( "mp_postmatch", 2.0 );

	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level notify ( "game_ended" );
	
	thread maps\mp\gametypes\_missions::roundEnd();
	thread maps\mp\gametypes\_gamestats::processGameStats();
	
		
	updateLeaderboards();
	
	if ( level.xenon || level.ps3 || level.bx ) //GEBE
		setXenonRanks();

	
	
	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player freezePlayerForRoundEnd();

		player setClientDvar( "cg_everyoneHearsEveryone", "1" );
		if ( isDefined( winner ) && isPlayer( winner ) ) {
			player setClientDvar( "ui_winner_name", winner.name );
		}

		player awardMoney( winner );
		
		player.pers["lastScore"] = player.score;
	}

	updateGameScores( winner );
	level notify ( "update_teamscore_hud" );

	updateWinLossStats( winner );		
	updateLeaderboards();

	if ( level.roundLimit != 1 && !level.forcedEnd )
	{
		game["roundsplayed"]++;

		thread announceRoundWinner( winner, 4 );

		players = getEntArray( "player", "classname" );
		for ( index = 0; index < players.size; index++ )
		{
			player = players[index];

			if ( isdefined( winner ) )
			{
				if ( level.teamBased ) {
					if ( winner == "axis" )
						player openMenu( game["menu_victory_org"] );
					else if ( winner == "allies" )
						player openMenu( game["menu_victory_mi6"] );
					else if ( winner == "tie" )
						player openMenu( game["menu_victory_draw"] );
				} else {
					player openMenu( game["menu_victory_freeforall"] );
				}
			}
			else {
				player openMenu( game["menu_victory_draw"] );
				continue;
			}
		}
		
		wait 6;

		wait ( level.roundEndDelay );

		if ( !hitRoundLimit() )
		{
			// Close the round summary screen
			players = getEntArray( "player", "classname" );
			for ( index = 0; index < players.size; index++ )
			{
				player = players[index];

				player closeMenu();
				player closeInGameMenu();
			}

			level [[level.onRoundEnded]]();
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
	
	// catching gametype, since DM forceEnd sends winner as player entity, instead of string
	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		player closeMenu();
		player closeInGameMenu();
	}
	
	thread announceGameWinner( winner, 2 );

	if ( level.roundLimit == 1 ) {
		wait 4;

		players = getEntArray( "player", "classname" );
		for ( index = 0; index < players.size; index++ )
		{
			player = players[index];

			if ( isdefined( winner ) )
			{
				if ( level.teamBased ) {
					if ( winner == "axis" )
						player openMenu( game["menu_victory_org"] );
					else if ( winner == "allies" )
						player openMenu( game["menu_victory_mi6"] );
					else if ( winner == "tie" )
						player openMenu( game["menu_victory_draw"] );
				} else {
					player openMenu( game["menu_victory_freeforall"] );
				}
			}
			else {
				player openMenu( game["menu_victory_draw"] );
				continue;
			}
		}

		wait 6;	
	}

	wait level.postRoundTime;

	//regain players array since some might've disconnected during the wait above
	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player closeInGameMenu();
		player spawnIntermission();
	}

	/*nextmap = undefined;
	if ( !level.skipVote )
		nextmap = maps\mp\gametypes\_votemap::holdVote();

	// show scoreboard
	players = getEntArray( "player", "classname" );
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
	
		player closeMenu();
		player closeInGameMenu();
	}*/
		
	wait 12.0;
	

	/*if ( isDefined( nextmap ) )
		map( nextmap, false );
	else*/
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
	giveEndOfRoundAchievements();
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

giveEndOfRoundAchievements()
{
	players = getEntArray( "player", "classname" );
	highestScore = 0;
	bestPlayer = undefined;
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if( player.score > highestScore && players.size > 1 )
		{
			bestPlayer = player;
			highestScore = player.score;
		}

		player maps\mp\gametypes\_persistence_util::statAdd( "stats", "games_played", 1 );
		gamesPlayed = player maps\mp\gametypes\_persistence_util::statGet( "stats", "games_played" );

		if( gamesPlayed >= 100 )
		{
			println( "giving achievement: PLAYED_100_GAMES" );
			player giveAchievement( "PLAYED_100_GAMES" );
		}			
	}
	if( isDefined(bestPlayer) )
	{
		println( "giving achievement: BEST_PLAYER" );
		bestPlayer giveAchievement( "BEST_PLAYER" );
	}
}

awardMoney( winner )
{
	money = 0;
	
	score = self.score - self.pers["lastScore"];
	
	if( level.gametype == "dm" || level.gametype == "os" || level.gametype == "as" || level.gametype == "vs" ) {
		money = score * level.pointMultiplier;
	} else {
		//be, koth, tdm 
		if ( winner == self.pers["team"] )
		{
			money = score * level.winTeamPointMultiplier;
		}
		else
		{
			money = score * level.loseTeamPointMultiplier;
		}
	}
	
	
	printLn( "giving money = " + money );
	
	self maps\mp\gametypes\_persistence_util::statAdd( "stats", "money", money);
	playerMoney = self maps\mp\gametypes\_persistence_util::statGet( "stats", "money" );
	printLn( "player money = " + playerMoney );
	self setclientdvar( "ui_credits", money );
	if( playerMoney >= 1000 )
	{
		printLn( "giving achievement: 10_000_MONEY" );
		self giveAchievement( "10_000_MONEY" );
	}
	if( playerMoney >= 10000 )
	{
		printLn( "giving achievement: 100_000_MONEY" );
		self giveAchievement( "100_000_MONEY" );
	}
	if( playerMoney >= 100000 )
	{
		printLn( "giving achievement: 1_000_000_MONEY" );
		self giveAchievement( "1_000_000_MONEY" );
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
	sendranks();
}


getHighestScoringPlayer()
{
	players = getEntArray( "player", "classname" );
	winner = undefined;
	tie = false;
	
	for( i = 0; i < players.size; i++ )
	{
	
		println( "Player " + i + " score: " + players[i].score );
		
		if ( !isDefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;
			
		if ( !isDefined( winner ) || players[i].score > winner.score )
		{
			println( "Player " + i + " wins " );
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			println( "Tie occured" );
			tie = true;
		}
	}
	
	if ( tie || !isDefined( winner ) )
	{
		println( "Winner undefined" );
		return undefined;
	}
	else
	{
		println( "Winner defined" );
		return winner;
}
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

	if ( !level.useRoundLimitAsWinsPerTeam )
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

	clampValue = true;
/#
	clampValue = false;
#/
	if( clampValue )
	{
		if ( getDvarInt( dvarString ) > maxValue )
			setDvar( dvarString, maxValue );
		else if ( getDvarInt( dvarString ) < minValue )
			setDvar( dvarString, minValue );
	}

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
	makeDvarServerInfo( dvarString );
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

updateRoundsLeftDvar()
{
	for( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];
		player setClientDvar( "ui_roundsleft", level.roundLimit - game["roundsplayed"] );
	}
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
			updateRoundsLeftDvar();
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

getDefaultLoadout()
{
	return "class/default_mp/primary/saf45_mp/sidearm/p99_mp/gren/flash_grenade_mp=1/skin/SKIN_GENERIC_ONE";
}

menuAutoAssign()
{
	teams[0] = "allies";
	teams[1] = "axis";
	assignment = teams[randomInt(2)];

	if ( level.teamBased )
	{
		playerCounts = maps\mp\gametypes\_teams::CountPlayers();
	
		// if teams are equal return the team with the lowest score
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
	
		if( isDefined( self.pers["team"] ) && assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
		    menuClass( maps\mp\gametypes\_globallogic::getDefaultLoadout() );
			if( !isDefined( self.pers["class"] ) || self.pers["class"] == "" )
		    {
				self openMenu( game["menu_class"] );
				self setPlayerMainMenuToClassSelect();
				self setclientdvar( "cl_validloadout", "0" );
		    }
			return;
		}
	}

	if( isDefined( self.pers["team"] ) && assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self [[level.setupCharacterOptions]]( assignment );
	self.pers["team"] = assignment;
	self.pers["class"] = undefined;
	self.pers["skin"] = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["place"] = 0;

	if( level.spawnPlayerWithDefaultLoadout || level.gametype == "vs" )
	{
		// Set a default class
		menuClass( maps\mp\gametypes\_globallogic::getDefaultLoadout() );
	}

	if ( game["state"] == "prematch" || game["state"] == "countdown" || level.gametype == "os" )
	{
		self openMenu( game["menu_warmup"] );
	}
	else
	{
		if (self.pers["team"] == "allies")
		{
			self openMenu( game["menu_class_allies"] );
		}
		else
		{
			self openMenu( game["menu_class_axis"] );
		}
	}

	self setPlayerMainMenuToIngame();
    self setclientdvar( "cl_validloadout", "0" );

	self notify("joined_team");
	self notify("end_respawn");
}

setupCharacterOptions( team )
{
	// This is the default version.  Specific game types may wish to override this with something more specific.
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


menuAllies()
{
	if(self.pers["team"] != "allies")
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
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
		self setclientdvar("g_scriptMainMenu", game["menu_class_allies"]);
		self setclientdvar( "cl_validloadout", "0" );

		self notify("joined_team");
		self notify("end_respawn");
		
		if(!isdefined(self.pers["class"]) || !level.teamBased )
		{
			self openMenu(game["menu_class_allies"]);
		}
	}  
}


menuAxis()
{
	if(self.pers["team"] != "axis")
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
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
		self setclientdvar("g_scriptMainMenu", game["menu_class_axis"]);
		self setclientdvar( "cl_validloadout", "0" );

		self notify("joined_team");
		self notify("end_respawn");
    
		if(!isdefined(self.pers["class"]) || !level.teamBased )
		{
			self openMenu(game["menu_class_axis"]);
		}
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

		self setclientdvar("g_scriptMainMenu", game["menu_team"]);

		self notify("joined_spectators");
	}
}

menuClass(response)
{	
	if ( game["state"] == "intermission" )
		return;
	
	// this should probably be an assert
	//if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
	//	return;

	team = self.pers["team"];

	//class = self maps\mp\gametypes\_class::getClassChoice( response );
	//primary = self maps\mp\gametypes\_class::getWeaponChoice( response );
	//explosive = self maps\mp\gametypes\_class::getExplosiveChoice( response );
	//gadget = self maps\mp\gametypes\_class::getGadgetChoice( response );

	class = self maps\mp\gametypes\_class::getResponseToken( response, "class", "/" );
	primary = self maps\mp\gametypes\_class::getResponseToken( response, "primary", "/" );
	sidearm = self maps\mp\gametypes\_class::getResponseToken( response, "sidearm", "/" );
	explosive = self maps\mp\gametypes\_class::getResponseToken( response, "gren", "/" );
	skin = self maps\mp\gametypes\_class::getResponseToken( response, "skin", "/" );
	gadget1 = self maps\mp\gametypes\_class::getResponseToken( response, "gadget1", "/" );
	gadget2 = self maps\mp\gametypes\_class::getResponseToken( response, "gadget2", "/" );
	// just assign them a fixed "type" for now
	if (team == "axis")
	{
		type = 30;
	}
	else
	{
		type = 10;
	}

	if (skin != "")
	{
		isThisPlayerBond = isDefined( level.player_bond ) && level.player_bond == self;
		if( !isThisPlayerBond )
		{
		self.pers["skin"] = skin;
		}
	}

	// make sure we have a skin
	if (!isDefined( self.pers["skin"] ))
		self.pers["skin"] = "SKIN_GENERIC_ONE";

	if( class == "restricted" )
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_class_allies"]);
		else if(self.pers["team"] == "axis")
			self openMenu(game["menu_class_axis"]);

		return;
	}

	if ( self.sessionstate == "playing" )
	{
		//if( (isDefined( self.pers["class"] ) && self.pers["class"] == class) && 
		//	(isDefined( self.pers["primary"] ) && self.pers["primary"] == primary) )
		//	return;

		self.pers["class"] = class;
		self.pers["primary"] = primary;
		self.pers["sidearm"] = sidearm;
		self.pers["weapon"] = undefined;
		self.pers["explosive"] = explosive;
		self.pers["type"] = type;
		self.pers["gadget1"] = gadget1;
		self.pers["gadget2"] = gadget2;
		if ( (level.inGracePeriod || self.canAssignLoadout == true ) && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) ) // used weapons check?
		{
			self.canAssignLoadout = false;
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
		self.pers["primary"] = primary;
		self.pers["sidearm"] = sidearm;
		self.pers["weapon"] = undefined;
		self.pers["explosive"] = explosive;
		self.pers["type"] = type;
		self.pers["gadget1"] = gadget1;
		self.pers["gadget2"] = gadget2;

		if( level.oldschool )
		{
			self thread maps\mp\gametypes\os::spawnClient();
			self.canAssignLoadout = false;
		}
		else
		{
			if ( game["state"] == "countdown" || game["state"] == "playing" || game["state"] == "prematch" )
			{
				self thread [[level.spawnClient]]();
				self.canAssignLoadout = false;
			}
		}
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

//	players[0] notify ( "update_ranked_hud" );

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
		
//		players[i] notify ( "update_ranked_hud" );
	}
}


onXPEvent( event )
{
	// AUSTIN (1/9/08) - Disable XP & Rank for now
	//self maps\mp\gametypes\_rank::giveRankXP( event );
//	self maps\mp\gametypes\_money::giveMoney( event );
}


givePlayerScore( event, player, victim, sMeansOfDeath )
{
	if ( level.overridePlayerScore )
		return;

	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim, sMeansOfDeath );
	
	if ( score == player.pers["score"] )
		return;

	player maps\mp\gametypes\_persistence_util::statAdd( "stats", "score", (player.pers["score"] - score) );
	
	player.score = player.pers["score"];

	[[level.updatePlacement]]();
	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


default_onPlayerScore( event, player, victim, sMeansOfDeath )
{
	player.pers["score"] += 1;
}


_setPlayerScore( player, score )
{
	if ( score == player.pers["score"] )
		return;

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

_multiplyScore( player, multiplier )
{
	score = player.pers["score"];
	score = score * multiplier;
	
	if ( score == player.pers["score"] )
		return;
		
	player maps\mp\gametypes\_persistence_util::statAdd( "stats", "score", (score - player.pers["score"]) );
	
	player.pers["score"] = score;
	player.score = player.pers["score"];

	[[level.updatePlacement]]();
	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


giveTeamScore( event, team, player, victim )
{
	if ( level.overrideTeamScore )
		return;
		
	teamScore = level.teamScores[team];
	[[level.onTeamScore]]( event, team, player, victim );
	
	if ( teamScore == level.teamScores[team] )
		return;

	setTeamScore( team, getGameScore( team ) );
	//println( "setting teamscore" );

	level notify ( "update_teamscore_hud" );
	thread checkScoreLimit();
}


_setTeamScore( team, teamScore )
{
	if ( teamScore == level.teamScores[team] )
		return;

	level.teamScores[team] = teamScore;

	setTeamScore( team, getGameScore( team ) );
	//println( "setting teamscore" );

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
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute

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
}


timeLow()
{
	playSoundOnPlayers( "Tann_MP_9" );
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
	twoMinuteMusicPlayed = false;

	while ( game["state"] == "playing" )
	{
		if ( level.timerStopped || level.timeLimit == 0 ) // change hud elems if timer is stopped or no time limit
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
/*
			else if ( timeLeft <= 10 )
			{
				clock = getClock( timeLeft, "tenths", false );
				//playSoundOnPlayers( "bomb_tick" );
				if( !criticalSoundPlayed )
				{
					criticalSoundPlayed = true;
					[[level.timeCritical]]();
				}
			}
			else if ( timeLeft <= 30 )
			{
				clock = getClock( timeLeft, "tenths", false );
				if( !lowSoundPlayed )
				{
					lowSoundPlayed = true;
					[[level.timeLow]]();
				}
			}
*/
			else if ( timeLeft <= 60 )
			{
				clock = getClock( timeLeft, "tenths", false );
				if( !lowSoundPlayed )
				{
					lowSoundPlayed = true;
					[[level.timeLow]]();
				}
			}
			else if ( timeLeft <= 120 )
			{
				clock = getClock( timeLeft, "seconds", false );
				if ( !twoMinuteMusicPlayed )
				{
					twoMinuteMusicPlayed = true;
					playSoundOnPlayers( "music_finaltwominutes" );
				}
			}
			else if ( level.timeLimit != lastTimeLimit )
			{
				lastTimeLimit = level.timeLimit;
				clock = getClock( timeLeft, "seconds", true );
			}
		}

		wait ( 1.0 );
	}
}


getClock( timeLeft, type, forceTimer )
{
	if ( !isDefined( level.clock ) )
	{
		level.clock = createServerTimer( "default", 1.5 );
		level.clock.type = type;
		level.clock.foreground = true;

		level.clock setPoint( "TOPRIGHT", undefined, -2  , 98 );
		
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
	level.timePassed = 0;

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
	thread gameTimer();
	thread timeLimitClock();

	thread maps\mp\gametypes\_spawnlogic::spawnSightChecks();

	if ( level.gracePeriod > 0 )
		thread gracePeriod();

	thread maps\mp\gametypes\_missions::roundBegin();	
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
		// Players on a team but without a weapon show as dead since they can not get in this round
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
	// fade out each player's screen at the end of the round
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
	fader.sort = 1000; // on top of everything except "match starting"
	
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
	fader.sort = 1000; // on top of everything except "match starting"
	
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
		playSoundOnPlayers( "music_end_generic", "axis" );
		playSoundOnPlayers( "music_end_generic", "allies" );
		//announcement( game["strings"]["round_draw"] );
	}
	else if ( isPlayer( winner ) )
	{
		playSoundOnPlayers( "music_end_generic" );
	}
	else if ( winner == "allies" )
	{
		//announcement( game["strings"]["allies_win_round"] );
		playSoundOnPlayers( "music_end_win", "allies" );
		playSoundOnPlayers( "music_end_lose", "axis" );
	}
	else if ( winner == "axis" )
	{
		//announcement( game["strings"]["axis_win_round"] );
		playSoundOnPlayers( "music_end_win", "axis" );
		playSoundOnPlayers( "music_end_lose", "allies" );
	}
	else
	{
		playSoundOnPlayers( "music_end_generic", "axis" );
		playSoundOnPlayers( "music_end_generic", "allies" );
		//announcement( game["strings"]["round_draw"] );
	}
}


announceGameWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) )
	{
		playSoundOnPlayers( "music_end_generic", "axis" );
		playSoundOnPlayers( "music_end_generic", "allies" );
		//announcement( game["strings"]["tie"] );
	}
	else if ( isPlayer( winner ) )
	{
		playSoundOnPlayers( "music_end_generic" );
	}
	else if ( winner == "allies" )
	{
		//announcement( game["strings"]["allies_win"] );
		playSoundOnPlayers( "music_end_win", "allies" );
		playSoundOnPlayers( "music_end_lose", "axis" );
		
		if ( level.gameType == "koth" || level.gameType == "be" || level.gameType == "tdm" )
		{
			playSoundOnPlayers( "Tann_MP_13" );
		}
		else if ( level.gameType == "vs" )
		{
			playSoundOnPlayers( "Tann_MP_14" );
		}
	}
	else if ( winner == "axis" )
	{
		//announcement( game["strings"]["axis_win"] );
		playSoundOnPlayers( "music_end_win", "axis" );
		playSoundOnPlayers( "music_end_lose", "allies" );

		if ( level.gameType == "koth" || level.gameType == "be" || level.gameType == "vs" || level.gameType == "tdm" )
		{
			playSoundOnPlayers( "Tann_MP_15" );
		}
	}
	else
	{
		playSoundOnPlayers( "music_end_generic", "axis" );
		playSoundOnPlayers( "music_end_generic", "allies" );
		//announcement( game["strings"]["tie"] );
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

	// increment our game specific win stats here?
	if( level.gametype == "koth" )
	{
		winner maps\mp\gametypes\_persistence_util::statAdd( "stats", "koth_games_won", 1 );
		kothGamesWon = winner maps\mp\gametypes\_persistence_util::statGet( "stats", "koth_games_won" );
		if( kothGamesWon >=5 )
		{
			winner giveAchievement( "WON_5_KOTH_MATCHES" );
		}
	}
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


spawnClient()
{
	assert(	isDefined( self.pers["team"] ) );
	assert( isDefined( self.pers["skin"] ) );

	if( !level.oldschool )
	{
		assert(	isDefined( self.pers["class"] )	);
		assert( self.pers["skin"] != "" );
		assert(	self.pers["class"] != "" );
	}	
	self endon ( "disconnect" );
	self endon ( "end_respawn" );

	self setClientDvar( "cl_match_warmup", "0" );

	if ( game["state"] == "prematch" )
	{
		self thread	[[level.spawnPlayer]]();
		return;
	}

	respawnTime = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" );
	respawnDelay = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "respawndelay" );

// Let's ignore these values we just got if this is VS and the player is on Team Bond
	if ( level.gametype == "vs" && self.pers["team"] == level.team_bond )
	{
		respawnDelay = 0;
		respawnTime = 0;
	}

	// TODO
	//respawnDelay += suicide or teamkill penalty
	
	if ( respawnTime )
		remainingTime = (level.waveDelay[self.pers["team"]] - (getTime() - level.lastWave[self.pers["team"]]) / 1000);
	else
		remainingTime = 0;

	if ( level.numLives )
	{
		// disallow spawning for late comers
		if ( !level.inGracePeriod && !self.hasSpawned )
			self.canSpawn = false;
		else if ( !self.pers["lives"] )
			self.canSpawn = false;
	}

	if ( !self.canSpawn )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;

		// respawn next round text
		setLowerMessage( &"MP_SPAWN_NEXT_ROUND" );
		self thread	[[level.spawnSpectator]]();
		return;
	}

	//if the player joined a match post the pre-game screen and hasn't spawned yet and isn't in a mode that has numlives set, spawn them
	if( !self.hasSpawned && !level.numLives )
	{
		self setLowerMessage( "" );
		self thread	[[level.spawnPlayer]]();	
		return;
	}
	
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
		// defaults if not defined in level script
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
			else if ( level.numLives )
				game["state"] = "prematch";
			else
				game["state"] = "playing";
		}
	
		precacheStatusIcon( "hud_status_dead" );
		precacheStatusIcon( "hud_status_connecting" );
		
		precacheRumble( "damage_heavy" );

		precacheString( &"PLATFORM_PRESS_TO_SPAWN" );
		precacheString( &"MP_WAITING_MATCH" );
		precacheString( &"MP_WAITING_FOR_TEAMS" );
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
		precacheString( game["strings"]["allies_mission_accomplished"] );
		precacheString( game["strings"]["axis_mission_accomplished"] );
		precacheString( game["strings"]["allies_eliminated"] );
		precacheString( game["strings"]["axis_eliminated"] );
		precacheString( game["strings"]["enemies_eliminated"] );

		[[level.onPrecacheGameType]]();
		
		game["gamestarted"] = true;
	}

	if( game["state"] != "prematch" && level.doCountdown )
	{
		game["state"] = "countdown";
	}

	if(!isdefined(game["timepassed"]))
		game["timepassed"] = 0;

	if(!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;
	if(!isdefined(game["alliesroundwins"]))
		game["alliesroundwins"] = 0;	
	if(!isdefined(game["axisroundwins"]))
		game["axisroundwins"] = 0;
	if(!isdefined(game["playercount"]))
		game["playercount"] = [];
	
	level.skipVote = false;
	level.gameEnded = false;
	level.teamScores["allies"] = 0;
	level.teamScores["axis"] = 0;
	level.teamSpawnPoints["axis"] = [];
	level.teamSpawnPoints["allies"] = [];

	level.objIDStart = 0;
	level.forcedEnd = false;

	// this gets set to false when someone takes damage or a gametype-specific event happens.
	level.useStartSpawns = true;

	thread maps\mp\gametypes\_persistence::init();
	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\mp\gametypes\_shellshock::init();
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\mp\gametypes\_grenadeindicators::init();
	thread maps\mp\gametypes\_objpoints::init();
	thread maps\mp\gametypes\_gamestats::init();
	//thread maps\mp\gametypes\_votemap::init();
	thread maps\mp\gametypes\_gameobjects::init();
	thread maps\mp\gametypes\_spawnlogic::init();
	//thread maps\mp\gametypes\_revive::init();
	//thread maps\mp\gametypes\_oldschool::init();
	
	if ( level.teamBased )
	{
		thread maps\mp\gametypes\_hud_teamscore::init();
		thread maps\mp\gametypes\_friendicons::init();
	}
	else
	{
		thread maps\mp\gametypes\_hud_playerscore::init();
	}
		
	//if ( level.xboxlive )
		//thread maps\mp\gametypes\_hud_ranked::init();
		
	thread maps\mp\gametypes\_hud_weapons::init();
	thread maps\mp\gametypes\_hud_message::init();

	if(level.xenon || level.bx ) // Xenon only //GEBE
		thread maps\mp\gametypes\_richpresence::init();
	else // PC only
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
	// Grace period lasts after a countdown if we are doing one
	if( isDefined( level.countdownTime ) )
	{
		level.gracePeriod += level.countdownTime;
	}
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

	if ( !isDefined( level.vision ) )
		level.vision = [];

	if ( !isDefined( level.vision["allies"] ) )
		level.vision["allies"] = getDvar( "mapname" );

	if ( !isDefined( level.vision["axis"] ) )
		level.vision["axis"] = getDvar( "mapname" );

	visionSetAllied( level.vision["allies"], 0.0 );
	visionSetAxis( level.vision["axis"], 0.0 );

	if ( game["state"] == "prematch" )
	{
		if( prematch() )
		{
			map_restart(true);
			return;
		}
	}

	setdvar( "g_roundEndReason", "" );

	[[level.onStartGameType]]();

	// this must be after onstartgametype for r_showSpawnPoints to work when set at start of game
	thread maps\mp\gametypes\_dev::init();

	if ( game["state"] == "countdown" )
	{
		countdown();
	}

	// Play gametype announcement
	switch( level.gametype )
	{
		case "dm":
			playSoundOnPlayers( "Tann_MP_7" );
			break;
		case "tdm":
			playSoundOnPlayers( "Tann_MP_6" );
		  	break;
		case "as":
			playSoundOnPlayers( "Tann_MP_4A" );
			break;
		case "koth":
			playSoundOnPlayers( "Tann_MP_46" );
			break;
		case "os":
			playSoundOnPlayers( "Tann_MP_3B" );
			break;
		case "vs":
			playSoundOnPlayers( "Tann_MP_5" );
			break;
		case "be":
			playSoundOnPlayers( "Tann_MP_2" );		
			break;
		default:
			break;
	}

	game["state"] = "playing";

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
		//visionSetNaked( "mp_prematch", 0 );

		prematchElement = createServerFontString( "default", 2.0 );
		prematchElement setPoint( "CENTER", "CENTER", 0, 110 );
		prematchElement setText( &"MP_WAITING_FOR_PLAYERS" );

		allowed = [];
		//allowed[0] = level.gametype;
		maps\mp\gametypes\_gameobjects::main(allowed);

		level.timerStopped = false;
		thread timeLimitClock();

		thread maps\mp\gametypes\_dev::init();

		// wait for min players
		while(1)
		{
			hasmin = hasMinPlayers();

			prematchElement setText( &"MP_WAITING_FOR_PLAYERS", " (" + level.numplayers + "/" + level.minplayers + ")" );

			if( hasmin && !level.forcedEnd )
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
	matchStartTimer = createServerFontString( "bigfixed", 1.4 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 160 );
	matchStartTimer.sort = 1001;
	//matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = true;
	matchStartTimer.hidewheninmenu = true;

//	matchStartTimer maps\mp\gametypes\_hud::fontPulseInit();

	prematchPeriod = 0;
	if ( !level.splitscreen )
		prematchPeriod = 5; // maps\mp\gametypes\_tweakables::getTweakableValue( "game", "graceperiod" ); // TODO rename to prematch and update files to match

//	if ( prematchPeriod > 2.0 )
//		prematchPeriod = prematchPeriod + (randomFloat( 2 ) - 1); // live host obfuscation

	countTime = int( prematchPeriod );

	if( isDefined( level.countdownTime ) )
	{
		countTime = level.countdownTime;
	}

	level.countdownEnd = gettime() + (countTime * 1000);
	level notify("countdown_start");

	if ( countTime >= 2 )
	{
		while ( countTime > 0 && !level.gameEnded )
		{
			matchStartTimer setValue( countTime );
//			matchStartTimer thread maps\mp\gametypes\_hud::fontPulse( level );
			if ( countTime <= 10 )
			{
				playSoundOnPlayers( "timer" );
			}
			countTime--;
			wait ( 1.0 );
		}
	}

	matchStartTimer destroyElem();

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

	// only print that we connected if we haven't connected in a previous round
	if( !level.splitscreen && !isdefined( self.pers["score"] ) )
		iPrintLn(&"MP_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	self setClientDvar( "ui_score_bar", getDvar( "ui_score_bar" ) );
	self setClientDvar( "ui_gametype_text", getDvar( "ui_gametype_text" ) );
	self SetClientDvar( "cg_rival", "-1" );
	self setClientDvar( "ui_roundsleft", level.roundLimit - game["roundsplayed"] );
	self setClientDvar( "ui_allies_score", level.teamScores["allies"] );
	self setClientDvar( "ui_axis_score", level.teamScores["axis"] );
	self setClientDvar( "ui_player_whois_bond", "" );

	// Set client dvars for player selection.
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

	if( !isDefined(self.pers["place"] ) ) {
		self.pers["score"] = 0;
		self.pers["lastScore"] = 0;
	}
	self.score = self.pers["score"];

	if ( !isDefined( self.attackers ) )
		self.attackers = [];

	self initPersStat( "deaths" );
	self.deaths = self getPersStat( "deaths" );

	self initPersStat( "suicides" );
	self.suicides = self getPersStat( "suicides" );

	self initPersStat( "kills" );
	self.kills = self getPersStat( "kills" );

	self initPersStat( "headshots" );
	self.headshots = self getPersStat( "headshots" );

	self initPersStat( "assists" );
	self.assists = self getPersStat( "assists" );

	self initPersStat( "teamkills" );
	self.teamkills = self getPersStat( "teamkills" );

	self.cur_kill_streak = 0;
	self.cur_death_streak = 0;
	self.death_streak = self maps\mp\gametypes\_persistence_util::statGet( "stats", "death_streak" );
	self.kill_streak = self maps\mp\gametypes\_persistence_util::statGet( "stats", "kill_streak" );
	self.canAssignLoadout = false;

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
		//self setClientDvar( "cg_deadChatWithTeam", "0" );
		self setClientDvar( "cg_deadHearTeamLiving", "0" );
		self setClientDvar( "cg_deadHearAllLiving", "0" );
	}
	else
	{
		self setClientDvar( "cg_deadChatWithDead", "0" );
		//self setClientDvar( "cg_deadChatWithTeam", "1" );
		self setClientDvar( "cg_deadHearTeamLiving", "1" );
		self setClientDvar( "cg_deadHearAllLiving", "0" );
	}
	
	if( game["state"] == "intermission" )
	{
		[[level.spawnIntermission]]();
		return;
	}

	level endon( "intermission" );
	
	self setClientDvar( "cg_everyoneHearsEveryone", "0" );
	self setclientdvar( "cg_disableCustomLoadouts", 0 );
	self setcamera();

	self [[level.overrideTeam]]();

	if ( level.gametype == "os" )
	{
		self.pers["class"] = "default_mp";
		self.class = self.pers["class"];
	}

	if ( !isDefined( self.pers["team"] ) )
	{
		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";
		[[level.spawnSpectator]]();
		
		// TODO: if ranked match, autoassign always
		if ( level.doAutoAssign || !level.teamBased /*&& level.consol*/ )
		{
			[[level.autoassign]]();
			self.canAssignLoadout = true;
		}
		else
		{
			self setclientdvar( "g_scriptMainMenu", game["menu_team"] );
			self openMenu( game["menu_team"] );
		}

		// set team and spectate permissions so the map shows waypoint info on connect
		if( level.teamBased )
		{
			self.sessionteam = self.pers["team"];
		}
		else
		{
			self.sessionteam = "none";
		}
		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
	}
	else if( self.pers["team"] != "spectator" )
	{
		if (self.pers["team"] == "axis" )
			scriptMainMenu = game["menu_class_axis"];
		else
			scriptMainMenu = game["menu_class_allies"];

		if( !level.allowClassChange )
			self setClientDvar( "ui_allow_classchange", "0" );
		else 
			self setClientDvar( "ui_allow_classchange", "1" );

		if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
		{
			[[level.spawnSpectator]](); // spawn them as a spectator in case spawnClient doesn't spawn them immediately (perhaps at the start of a prematch round)				
			self thread [[level.spawnClient]]();				
		}
		else
		{
			if( !level.doAutoAssign )
			{
				self openMenu( scriptMainMenu );
			}
		}
	}

	if( self.pers["team"] != "spectator" )
	{
		self setMenuSkinBasedOnTeam();

		if( !level.allowClassChange )
			self setClientDvar( "ui_allow_classchange", "0" );
		else 
			self setClientDvar( "ui_allow_classchange", "1" );

		self [[level.onPlayerTeamAssigned]]();
	}
	if( game["state"] == "prematch" )
	{
		self setPlayerMainMenuToIngame();
	}
}

// self = player
setMenuSkinBasedOnTeam()
{
/#
	assert( isDefined( self ) );
#/
	isNonTeamGameMode = level.gametype == "os" || level.gametype == "dm" || level.gametype == "as";
	if( !isDefined( self.pers["team"] ) || self.pers["team"] == "" || isNonTeamGameMode )
	{
		self setClientDvar( "cl_menu_skin", "default" );
		if(self.pers["team"] == "allies")
			self setClientDvar( "hud_stance_team_index", 1 );
		else if(self.pers["team"] == "axis")
			self setClientDvar( "hud_stance_team_index", 2 );
		return;
	}

	menuSkin = "default";
	if( self.pers["team"] == "allies" )
	{	
		if( isDefined( self.isBond ) && self.isBond )
		{
			menuSkin = "bond";
			self setClientDvar( "hud_stance_team_index", 0 );
		}
		else
		{
			menuSkin = "mi6";
			self setClientDvar( "hud_stance_team_index", 1 );
		}
	}
	else if( self.pers["team"] == "axis" )
	{
		menuSkin = "org";
		self setClientDvar( "hud_stance_team_index", 2 );
	}
	self setClientDvar( "cl_menu_skin", menuSkin );
}

Callback_PlayerDisconnect()
{
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

	// Don't do knockback if the damage direction was not specified
	if( !isDefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	friendly = false;

	if ( (level.teamBased && (self.health == self.maxhealth)) || !isDefined( self.attackers ) )
		self.attackers = [];

	println("DEBUG MOD MSG(HURT): " + sMeansOfDeath );
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_QK_NORMAL" )
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

	// check for completely getting out of the damage
	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{
		if( level.teamBased && isPlayer( eAttacker ) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]) )
		{
			prof_begin( "Callback_PlayerDamage player" );
			if(level.friendlyfire == 0)
			{
				if (sWeapon != "artillery_mp") 
				{
					 // in case of artillery, we will do shellshock/rumble as usual.
					self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, 0 ); // 0 damage so we only get shellshock for concussion grenades
					prof_end( "Callback_PlayerDamage player" );
					return;
				}
			}
			else if(level.friendlyfire == 1)
			{
				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
			}
			else if(level.friendlyfire == 2)
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}
			else if(level.friendlyfire == 3)
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}

			friendly = true;

			// Shellshock/Rumble
			self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, iDamage );
			self PlayRumbleOnEntity( "damage_heavy" );
			
			prof_end( "Callback_PlayerDamage player" );
			
			if ( level.friendlyfire == 0 && sWeapon == "artillery_mp" )
				return;
		}
		else
		{
			prof_begin( "Callback_PlayerDamage world" );
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			if ( level.teamBased && isDefined( eAttacker ) && isPlayer( eAttacker ) )
			{
				if(!isdefined(self.attackers[eAttacker.clientid]))
					self.attackers[eAttacker.clientid] = iDamage;
				else
					self.attackers[eAttacker.clientid] += iDamage;
			}

			if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( sWeapon ) )
				eAttacker maps\mp\gametypes\_weapons::checkHit( sWeapon );

			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

			// Shellshock/Rumble
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

	// Play pain sound
	self playLocalSound( "generic_pain" );

	// Do debug print if it's enabled
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
	//in case we were killed by something in the environment like a gas canister
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

scoreDeath( attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpattackGuid = "";
	lpattackname = "";
	lpselfteam = "";
	lpselfguid = self getGuid();
	lpattackerteam = "";

	lpattacknum = -1;

	if( isPlayer( attacker ) )
	{
		lpattackGuid = attacker getGuid();
		lpattackname = attacker.name;

		if ( attacker == self ) // killed himself
		{
			prof_begin( "PlayerKilled suicide" );

			doKillcam = false;

			// switching teams
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
						self incPersStat( "suicides", 1 );
						self.suicides = self getPersStat( "suicides" );
					}
				}
			}
			else
			{
				self thread [[level.onXPEvent]]( "suicide" );
				self incPersStat( "suicides", 1 );
				self.suicides = self getPersStat( "suicides" );

				scoreSub = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "suicidepointloss" );
				_setPlayerScore( self, _getPlayerScore( self ) - scoreSub );
			}
			
			if( isDefined( self.friendlydamage ) )
				self iPrintLn(&"MP_FRIENDLY_FIRE_WILL_NOT");

			prof_end( "PlayerKilled suicide" );
		}
		else
		{
			prof_begin( "PlayerKilled attacker" );

			lpattacknum = attacker getEntityNumber();

			doKillcam = true;
			
			if( level.teamBased && self.pers["team"] == attacker.pers["team"] ) // killed by a friendly
			{
				attacker thread [[level.onXPEvent]]( "teamkill" );

				attacker incPersStat( "teamkills", 1 );
				attacker.teamkills = attacker getPersStat( "teamkills" );

				scoreSub = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "teamkillpointloss" );
				_setPlayerScore( attacker, _getPlayerScore( attacker ) - scoreSub );
				
				// TODO: repeated teamkiller tweakable here
			}
			else
			{
				prof_begin( "PlayerKilled stats and xp" );
				if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
				{
					attacker incPersStat( "headshots", 1 );
					attacker.headshots = attacker getPersStat( "headshots" );
					attacker thread [[level.onXPEvent]]( "headshot" );
				}
				else
				{
					attacker thread [[level.onXPEvent]]( "kill" );
				}

				attacker incPersStat( "kills", 1 );
				attacker.kills = attacker getPersStat( "kills" );
				attacker updatePersRatio( "kdratio", "kills", "deaths" );

				println( "Kills set as: " + attacker.kills );
				totalKills = attacker maps\mp\gametypes\_persistence_util::statGet( "stats", "kills" );
				if( totalKills >= 1000 )
				{
					println( "giving achievement: 1000_KILLS" );
					attacker giveAchievement( "1000_KILLS" );
				}

				// record our quick kill stats and award achievements
				if( sMeansOfDeath == "MOD_QK_NORMAL" )
				{
					attacker maps\mp\gametypes\_persistence_util::statAdd( "stats", "quick_kills", 1 );
					numQuickKills = attacker maps\mp\gametypes\_persistence_util::statGet( "stats", "quick_kills" );
					if( numQuickKills >= 7 )
					{
						attacker giveAchievement( "7_QUICK_KILLS" );
					}
				}

				attacker.cur_kill_streak++;
				attacker.cur_death_streak = 0;

				if ( attacker.cur_kill_streak > attacker.kill_streak )
				{
					attacker maps\mp\gametypes\_persistence_util::statSet( "stats", "kill_streak", attacker.cur_kill_streak );
					attacker.kill_streak = attacker.cur_kill_streak;
				}
				
				givePlayerScore( "kill", attacker, self, sMeansOfDeath );
				if ( level.teamBased )
					giveTeamScore( "kill", attacker.pers["team"],  attacker, self );

				scoreSub = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "deathpointloss" );
				_setPlayerScore( self, _getPlayerScore( self ) - scoreSub );
				
				level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );
				prof_end( "PlayerKilled stats and xp" );
	
				if ( level.teamBased )
				{
					prof_begin( "PlayerKilled assists" );
					// old version:
					/*for(i = 0; i < level.clientid; i++)
					{
						if ( !isDefined( self.attackers[i] ) )
							continue;
	
						if ( i == attacker.clientid )
							continue;
	
						if ( self.attackers[i] < (self.attackers.size / 2) ) // this doesn't make sense! why would we compare damage done to half the number of attackers?
							continue;
	
						players = getentarray("player", "classname");
						for(j = 0; j < players.size; j++)
						{
							player = players[j];
							if(player.clientid != i)
								continue;
	
							player thread [[level.onXPEvent]]( "assist" );
							player incPersStat( "assists", 1 );
							player.assists = player getPersStat( "assists" );
						}
					}*/
					
					assert( isdefined( level.players ) );
					if ( !isdefined( level.players ) ) // failsafe
						level.players = [];
					
					for ( j = 0; j < level.players.size; j++ )
					{
						player = level.players[j];
						clientid = player.clientid;
						
						if ( !isdefined( self.attackers[clientid] ) )
							continue;

						if ( player == attacker )
							continue;
						
						player thread [[level.onXPEvent]]( "assist" );
						player incPersStat( "assists", 1 );
						player.assists = player getPersStat( "assists" );
					}
					
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

		// even if the attacker isn't a player, it might be on a team
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

	logPrint( "K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n" );
	return lpattacknum;
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon( "spawned" );
	self notify( "killed_player" );

	level thread triggerVoicePipe(attacker, self);
	
	println( "Death occurred!!!!!!!!!!!!!!!!!!!!" );
	if ( isDefined( attacker ) && level.doHero )
	{
		attacker [[level.giveHeroPoints]]( 1 );
	}

	if(self.sessionteam == "spectator")
		return;

	if ( game["state"] == "postgame" )
		return;

	if ( game["state"] == "prematch" )
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

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	println( "Death occurred before obituary" );
	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	// do our golden gun kill achievement
	// should probably do this in the game mode script, but we don't know MOD?
	if( level.gametype == "as" )
	{
		vipPlayer = maps\mp\gametypes\as::getVipPlayer();
		if( isDefined( vipPlayer ) )
		{
			if( sMeansOfDeath == "MOD_MELEE" && self == maps\mp\gametypes\as::getVipPlayer() )
			{
				attacker giveAchievement( "MELEE_GOLDEN_GUN_HOLDER" );
			}
		}
	}

	if( sMeansOfDeath == "MOD_PISTOL_BULLET"	||
		sMeansOfDeath == "MOD_RIFLE_BULLET"		||
		sMeansOfDeath == "MOD_GRENADE"			||
		sMeansOfDeath == "MOD_GRENADE_SPLASH"	||
		sMeansOfDeath == "MOD_PROJECTILE"		||
		sMeansOfDeath == "MOD_PROJECTILE_SPLASH"||
		sMeansOfDeath == "MOD_HEAD_SHOT"		  )
	{
		if( attacker isInCover() )
		{
			attacker maps\mp\gametypes\_persistence_util::statAdd( "stats", "COVER_KILLS", 1 );
			attackerCoverKills = attacker maps\mp\gametypes\_persistence_util::statGet( "stats", "COVER_KILLS" );
			println( "PlayerKilled:  COVER KILL" );
			if( attackerCoverKills >= 100 )
			{
				attacker giveAchievement( "COVER_KILL_100" );
			}
			if( attacker isBlindAiming() )
			{
				attacker maps\mp\gametypes\_persistence_util::statAdd( "stats", "BLIND_FIRE_KILLS", 1 );
				attackerBlindFireKills = attacker maps\mp\gametypes\_persistence_util::statGet( "stats", "BLIND_FIRE_KILLS" );
				println( "PlayerKilled:  BLIND FIRE KILL" );
				if( attackerBlindFireKills >= 10 )
				{
					attacker giveAchievement( "BLIND_FIRE_10" );
				}
			}
		}
	}

	[[level.onDeathOccurred]]( self, attacker );

	println( "Death occurred before dropWeapon" );
	if ( self getPlayerType() == 1 && shouldDropWeapon() )
	{
		self maps\mp\gametypes\_weapons::dropWeapon();
		self maps\mp\gametypes\_weapons::dropOffhand();
	}

	println( "Death occurred before level.doHero" );
	if( level.doHero )
	{
		if( self getPlayerType() != 1 )
		{
			self setPlayerType( 1 ); // Default MP Playertype
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

	println( "Death occurred before deathOccured (self, attacker)" );
	maps\mp\gametypes\_spawnlogic::deathOccured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;

	if( !isDefined( self.switching_teams ) )
	{
		self incPersStat( "deaths", 1 );
		self.deaths = getPersStat( "deaths" );
		self updatePersRatio( "kdratio", "kills", "deaths" );

		self.cur_kill_streak = 0;		
		self.cur_death_streak++;
		
		if ( self.cur_death_streak > self.death_streak )
		{
			println( "Death occurred before statSet ( death_streak )" );
			self maps\mp\gametypes\_persistence_util::statSet( "stats", "death_streak", self.cur_death_streak );
			self.death_streak = self.cur_death_streak;
		}
	}	
	
	prof_end( "PlayerKilled pre constants" );

	lpattacknum = self scoreDeath( attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );
	doKillcam = lpattacknum != -1;

	prof_begin( "PlayerKilled post constants" );
	self thread maps\mp\gametypes\_missions::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );

	level thread [[level.updateTeamStatus]]();

	// Play death sound
	self playSound( "generic_death" );

	body = self clonePlayer( deathAnimDuration );
	self.body = body;

	if ( !isDefined( self.switching_teams ) )
	{
		thread maps\mp\gametypes\_deathicons::addDeathicon( body, self, self.pers["team"], 7.0 );
	}

	//iprintln("Means of death: ", sMeansOfDeath, ", sWeapon: ", sWeapon, ", vDir: ", vDir);
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
		body thread waitDoRagdoll( (deathAnimDuration / 1000) / 2.0 );	// maybe use deathAnimDuration?
	}

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if ( sWeapon == "artillery_mp" || sWeapon == "claymore_mp" || sWeapon == "proxmine_mp" || sWeapon == "none" )
		doKillcam = false;

	delay = (deathAnimDuration / 1000) + 0.5;
	delay = min(delay, 2);
	//iprintln("Our deathAnimDuration is this: ", deathAnimDuration, "\n");
	//delay = 2.7;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// let the player watch themselves die. Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if ( doKillcam && level.killcam  )
		self maps\mp\gametypes\_killcam::killcam( lpattacknum, sWeapon, delay, psOffsetTime, !(level.numLives && !self.pers["lives"]), timeUntilRoundEnd() );

	prof_end( "PlayerKilled post constants" );

	if ( game["state"] != "playing" )
		return;

	// class may be undefined if we have changed teams
	if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
	{
		self thread [[level.spawnClient]]();
	}
}


waitDoRagdoll( duration )
{
	if ( duration > 0 )
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

	// Stop shellshock and rumble
	self StopShellshock();
	self StopRumble( "damage_heavy" );

	// Make sure HUD is on, could've been disabled by the Bond VS intro
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

setObjectiveMenuText( team, text )
{
	// This is the objective string that is for the menu and
	// since the menu system localizes a string with the "@"
	// symbol at the beginning, we need to prepend that here.
	game["strings"]["objective_menu_"+team] = "@" + text;
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

getObjectiveMenuText( team )
{
	return game["strings"]["objective_menu_"+team];
}

getObjectiveScoreText( team )
{
	return game["strings"]["objective_score_"+team];
}

getObjectiveHintText( team )
{
	return game["strings"]["objective_hint_"+team];
}

findMapCenter()
{
	minimapEnts = getentarray( "minimap_corner", "targetname" );
	if( minimapEnts.size != 2 )
	{
		return;
	}

	mins = minimapEnts[ 0 ].origin;
	maxs = minimapEnts[ 1 ].origin;

	if( mins[ 0 ] > maxs[ 0 ] )
	{
		temp = mins;
		mins = maxs;
		maxs = temp;
	}

	center = maps\mp\gametypes\_spawnlogic::findBoxCenter( mins, maxs );
	setMapCenter( center );
}
