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
	if ( level.xenon )
		level.xboxlive = getDvarInt( "onlinegame" );
	else
		level.xboxlive = false;

	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );

	gametype_text = getDvar( "ui_gametype_text" );
	if ( !isdefined( gametype_text ) || ( isdefined( gametype_text ) && gametype_text == "" ) )
	{
		switch( level.gametype )
		{
			case "dm":
				setDvar( "ui_gametype_text", "@MP_DEATHMATCH" );
				break;
			case "war":
				setDvar( "ui_gametype_text", "@MP_TEAM_HARDPOINT" );
				break;
			case "sab":
				setDvar( "ui_gametype_text", "@MP_SABOTAGE" );
				break;
			case "sab2":
				setDvar( "ui_gametype_text", "@MP_SABOTAGE_COUNTDOWN" );
				break;
			case "sd":
				setDvar( "ui_gametype_text", "@MP_SEARCH_AND_DESTROY_CLASSIC" );
				break;
			case "sd2":
				setDvar( "ui_gametype_text", "@MP_SEARCH_AND_DESTROY" );
				break;
			case "dom":
				setDvar( "ui_gametype_text", "@MP_DOMINATION" );
				break;
			default:
				setDvar( "ui_gametype_text", "@MP_TEAM_HARDPOINT" );
				break;
		}
	}
	// if custom gametype, obtain its custom name and set ui_gametype_text to it
	customname = getDvar( "ui_customModeName" );
	if ( isdefined( customname ) && customname != "" ) 
		setDvar( "ui_gametype_text", customname );
	
	level.teamBased = false;
	level.doPrematch = false;
	
	level.overrideTeamScore = false;
	level.overridePlayerScore = false;
	
	level.postRoundTime = 4.0;
	
	preCacheMenu( "victory_marines" );
	preCacheMenu( "victory_opfor" );
}

SetupCallbacks()
{
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

	level.onForfeit = ::default_onForfeit;
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
	
	level.endGame = ::endGame;
	
	level.onPrecacheGametype = ::blank;
	level.onStartGameType = ::blank;
	level.onPlayerConnect = ::blank;
	level.onPlayerDisconnect = ::blank;
	level.onPlayerDamage = ::blank;
	level.onPlayerKilled = ::blank;

	level.autoassign = ::menuAutoAssign;
	level.spectator = ::menuSpectator;
	level.class = ::menuClass;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
}


blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

// when a team leaves completely, that team forfeited, team left wins round, ends game
default_onForfeit( team )
{
	level notify ( "forfeit in progress" ); //ends all other forfeit threads attempting to run
	level endon( "forfeit in progress" );	//end if another forfeit thread is running
	level endon( "abort forfeit" );			//end if the team is no longer in forfeit status
	
	if ( team == "allies" )
		announcement( "Allies have 10 seconds before forfeiting" );
	else if ( team == "axis" )
		announcement( "Opposition has 10 seconds before forfeiting" );
	else
		announcement( "Forfeiting in 10 seconds" );
	
	forfeit_delay = 10;						//forfeit wait, for switching teams and such
	wait forfeit_delay;
	
	if ( team == "allies" )
	{
		announcement( &"MP_ALLIES_FORFEITED" );
		//if allies forfeited, then axis gain a score for that round
		axis_score = getTeamScore( "axis" ) + 1;
		setTeamScore( "axis", axis_score );		
		game["axisroundwins"]++;
	}
	else if ( team == "axis" )
	{
		announcement( &"MP_OPFOR_FORFEITED" );
		//if axis forfeited, then allies gain a score for that round
		allies_score = getTeamScore( "allies" ) + 1;
		setTeamScore( "allies", allies_score );
		game["alliesroundwins"]++;
	}
	else
	{
		//shouldn't get here
		assertEx( isdefined( team ), "Forfeited team is not defined" );
		assertEx( 0, "Forfeited team " + team + " is not allies or axis" );
		thread [[level.endGame]]( "tie" );
		return;
	}

	if ( level.teamScores["allies"] == level.teamScores["axis"] )
		winner = "tie";
	else if ( level.teamScores["axis"] > level.teamScores["allies"] )
		winner = "axis";
	else
		winner = "allies";
		
	//exit game, last round, no matter if round limit reached or not
	level.forcedEnd = true;
	thread [[level.endGame]]( winner );
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
		[[level.endGame]]( winner );
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
				
			player playLocalSound( game["sounds"][team+"_last_alive"] );
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
	
	iPrintLn( game["strings"]["score_limit_reached"] );
	[[level.endGame]]( winner );
}


updateGameEvents()
{	
	//Forfeit catch in only team based and objective based gametypes
	if ( level.xboxlive )
	{
		if ( level.gametype == "sd" || level.gametype == "sd2" || level.gametype == "sab" || level.gametype == "sab2" || level.gametype == "dom" )
		{
			// if allies disconnected, and axis still connected, axis wins round and game ends to lobby
			if ( level.lastAliveCount["allies"] && level.playerCount["allies"] < 1 && level.playerCount["axis"] > 0 && game["state"] == "playing" )
			{
				//allies forfeited
				thread [[level.onForfeit]]( "allies" );
				return;
			}
			
			// if axis disconnected, and allies still connected, allies wins round and game ends to lobby
			if ( level.lastAliveCount["axis"] && level.playerCount["axis"] < 1 && level.playerCount["allies"] > 0 && game["state"] == "playing" )
			{
				//axis forfeited
				thread [[level.onForfeit]]( "axis" );
				return;
			}
		}
		if ( level.playerCount["axis"] > 0 && level.playerCount["allies"] > 0 )
			level notify( "abort forfeit" );
	}
	
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
		if ( level.aliveCount["allies"] + level.aliveCount["axis"] == 1 )
		{
			[[level.onOneLeftEvent]]( "all" );
			return;
		}
	}
}


checkMatchStart()
{	
	if ( isDefined ( level.matchStarting ) )
		return;
			
	if ( level.teamBased && (!level.playerCount["allies"] || !level.playerCount["axis"]) )
		return;
	else if ( level.playerCount["allies"] + level.playerCount["axis"] < 2 )
		return;

	level.prematchElement destroyElem();

	matchStartTimer = createServerTimer( "default", 2.0 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.label = &"MP_MATCH_STARTING_IN";
	matchStartTimer setTimer( 6.0 );
	
	level.matchStarting = true;
	
	wait ( 2.0 );
	thread fadeOut( 0, 3.0 );
	wait ( 4.0 );

	game["state"] = "playing";
	map_restart( true );
}


matchStartTimer()
{	
	musicPlay( "bog_a_shantytown" );
	visionSetNaked( "ac130" );

	matchStartText = createServerFontString( "default", 1.65 );
	matchStartText setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( &"MP_MATCH_STARTING_IN" );
	matchStartText.foreground = false;

	matchStartTimer = createServerFontString( "bigfixed", 1.65 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	
	matchStartTimer maps\mp\gametypes\_money::fontPulseInit();

	countTime = int( level.gracePeriod );
	while ( countTime > 0 )
	{
		matchStartTimer setValue( countTime );
		matchStartTimer thread maps\mp\gametypes\_money::fontPulse( level );
		countTime--;
		wait ( 1.0 );
	}
	
	matchStartTimer destroyElem();
	matchStartText destroyElem();
	visionSetNaked( getDvar( "mapname" ), 3.0 );
}


spawnPlayer()
{
	self endon("disconnect");
	self endon("joined_spectators");
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

	self setClientDvar( "cg_thirdPerson", "0" );
	
	if ( game["state"] == "prematch" )
		prematchSpawnPlayer();
	else
		[[level.onSpawnPlayer]]();

	level [[level.updateTeamStatus]]();

	self maps\mp\gametypes\_class::setClass( self.pers["class"] );
	self maps\mp\gametypes\_teams::model( self.pers["class"] );
	self.pers["proficiency"] = self maps\mp\gametypes\_class::getProficiency( self maps\mp\gametypes\_class::getClass() );	
	self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );

	if ( game["state"] != "prematch" )
	{
		if ( level.inGracePeriod )
		{
			self freezeControls( true );
			self disableWeapons();
		}
		else
		{
			self freezeControls( false );
			self enableWeapons();
			if ( !hadSpawned && game["state"] == "playing" )
				thread maps\mp\gametypes\_hud_message::hintMessage( getObjectiveHintText( self.pers["team"] ) );
		}
		
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
	else
	{
		//freeze players during prematch
		if ( level.xboxlive )
			self freezecontrols(true);
	}

//	if ( !hadSpawned && game["state"] == "playing" )
//		thread maps\mp\gametypes\_hud_message::hintMessage( getObjectiveHintText( self.pers["team"] ) );
	
	waittillframeend;
	self notify( "spawned_player" );

//	self thread watchAFK();
}

prematchSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	if ( level.teamBased )
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	else
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );
	
	self spawn( spawnPoint.origin, spawnPoint.angles );

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
	in_spawnSpectator( origin, angles );
}

// spawnSpectator clone without notifies for spawning between respawn delays
respawn_asSpectator( origin, angles )
{
	in_spawnSpectator( origin, angles );
}

// spawnSpectator helper
in_spawnSpectator( origin, angles )
{
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
	//self setClientDvar("cg_thirdPerson", "1");
	
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
		
	//assert( game["state"] != "postgame" );
	
	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level notify ( "game_ended" );
	
	thread maps\mp\gametypes\_missions::roundEnd();
	thread maps\mp\gametypes\_gamestats::processGameStats();
	
	if ( level.xenon )
		setXenonRanks();

	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];	
		player closeMenu();
		player closeInGameMenu();
	}

	updateGameScores( winner );
	level notify ( "update_teamscore_hud" );

	updateWinLossStats( winner );		
	updateLeaderboards();


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
	
	// catching gametype, since DM forceEnd sends winner as player entity, instead of string
	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player closeInGameMenu();
			
		if ( level.teamBased && isdefined( winner ) )
		{
			if ( winner == "axis" )
				player openMenu( "victory_opfor" );
			else if ( winner == "allies" )
				player openMenu( "victory_marines" );
		}
		else
			continue;
	}
	
	if ( level.teamBased && isdefined( winner ) )
		thread announceGameWinner( winner, 4 );
	
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
		
	//wait 6.0;
	wait 10.0; //scoreboard time
	

	/*if ( isDefined( nextmap ) )
		map( nextmap, false );
	else*/
		exitLevel( false );
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
				
			if ( isDefined( player.pers["team"] ) && player.pers["team"] == winningTeam )
				player maps\mp\gametypes\_rank::giveRankXP( "win" );
			else if ( isDefined(player.pers["team"] ) && player.pers["team"] == losingTeam )
				player maps\mp\gametypes\_rank::giveRankXP( "loss" );
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
	sendranks();
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

	return ( false );
}

registerRoundSwitchDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundswitch");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	
	level.roundswitchDvar = dvarString;
	level.roundswitchMin = minValue;
	level.roundswitchMax = maxValue;
	level.roundswitch = getDvarInt( level.roundswitchDvar );
	makeDvarServerInfo( dvarString );
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
		if ( getDvarInt( "party_autoteams" ) == 1 )
		{
			teamNum = getAssignedTeam( self );
			switch ( teamNum )
			{			
				case 1:
					assignment = teams[1];
					break;
					
				case 2:
					assignment = teams[0];
					break;
					
				default:
					assignment = "";
			}
		}
		
		if ( assignment == "" || getDvarInt( "party_autoteams" ) == 0 )
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
		}
		
		
		if( assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
		    if( !isDefined( self.pers["class"] ) || self.pers["class"] == "" )
		    {
			    if( self.pers["team"] == "allies" )
				    self openMenu( game["menu_class_allies"] );
			    else
				    self openMenu( game["menu_class_axis"] );
		    }
			return;
		}
	}

	if( assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.pers["class"] = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["place"] = 0;

	self setclientdvar("ui_allow_classchange", "1");

	if( self.pers["team"] == "allies" )
	{	
		self openMenu(game["menu_class_allies"]);
		self setclientdvar("g_scriptMainMenu", game["menu_class_allies"]);
	}
	else
	{	
		self openMenu(game["menu_class_axis"]);
		self setclientdvar("g_scriptMainMenu", game["menu_class_axis"]);
	}

	self notify("joined_team");
	self notify("end_respawn");
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

		self.pers["team"] = "allies";
		self.pers["class"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self.pers["place"] = 0;

		self setclientdvar("ui_allow_classchange", "1");
		self setclientdvar("g_scriptMainMenu", game["menu_class_allies"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["class"]) || !level.teamBased )
		self openMenu(game["menu_class_allies"]);
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

		self.pers["team"] = "axis";
		self.pers["class"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self.pers["place"] = 0;

		self setclientdvar("ui_allow_classchange", "1");
		self setclientdvar("g_scriptMainMenu", game["menu_class_axis"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["class"]) || !level.teamBased )
		self openMenu(game["menu_class_axis"]);
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
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	class = self maps\mp\gametypes\_class::getClassChoice( response );
	primary = self maps\mp\gametypes\_class::getWeaponChoice( response );

	if( class == "restricted" )
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_class_allies"]);
		else if(self.pers["team"] == "axis")
			self openMenu(game["menu_class_axis"]);

		return;
	}

	if( (isDefined( self.pers["class"] ) && self.pers["class"] == class) && 
		(isDefined( self.pers["primary"] ) && self.pers["primary"] == primary) )
		return;

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;

		if ( level.inGracePeriod && !self.hasDoneCombat ) // used weapons check?
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
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "playing" || game["state"] == "prematch" )
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
	self maps\mp\gametypes\_rank::giveRankXP( event );
//	self maps\mp\gametypes\_money::giveMoney( event );
}


givePlayerScore( event, player, victim )
{
	if ( level.overridePlayerScore )
		return;

	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim );
	
	if ( score == player.pers["score"] )
		return;
	
	player.score = player.pers["score"];

	[[level.updatePlacement]]();
	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


default_onPlayerScore( event, player, victim )
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


initLbStat( dataName, index )
{
	statIdx = self maps\mp\gametypes\_persistence_util::statIndex( "stats", dataName );
	self setLbStatMapping( index, statIdx ); 
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
		checkMatchStart();
		return;
	}

	level updateGameEvents();
}


timeLimitClock()
{
	level endon ( "game_ended" );
	
	if ( game["state"] == "prematch"  || !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showtimer" ) )
		return;

	lastTimeLimit = -1;
	clockType = "";

	while ( level.inGracePeriod )
		wait ( 0.05 );

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
			else if ( timeLeft <= 10 )
			{
				clock = getClock( timeLeft, "tenths", false );
				clock.color = (1,0,0);
				playSoundOnPlayers( "bomb_tick" );
			}
			else if ( timeLeft < 30 )
			{
				clock = getClock( timeLeft, "tenths", false );
				clock.color = (1,1,0);
				if ( timeLeft % 2 )
					playSoundOnPlayers( "bomb_tick" );
			}
			else if ( level.timeLimit != lastTimeLimit )
			{
				lastTimeLimit = level.timeLimit;
				clock = getClock( timeLeft, "seconds", true );
				clock.color = (1,1,1);
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

		if ( level.teamBased )
			level.clock setPoint( "TOPLEFT", undefined, 10, 50 );
		else
			level.clock setPoint( "TOPLEFT", undefined, 10, 32 );
		
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

/*
startRound()
{
	level endon( "game_ended" );

	thread timeLimitClock();

	level.fadeouttime = 1.5; // these are used only in round based modes between rounds
	level.postfadeouttime_matchstart = 3.0; // (used only when "match starting" is displayed)
	level.prefadeintime = 0.5;
	level.fadeintime = 1.0;
	
	thread roundFadeIn();

	level notify( "round_started" );

	level waittill ( "stop_round_end_timer" );
	level.roundTimerStopped = true;
}
*/

gracePeriod()
{
	makeDvarServerInfo( "ui_hud_hardcore", 1 );
	setDvar( "ui_hud_hardcore", 1 );
	level endon( "game_ended" );

	thread matchStartTimer();
	wait ( level.gracePeriod );

	level.inGracePeriod = false;

	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] freezeControls( false );
		level.players[index] enableWeapons();
		level.players[index] thread maps\mp\gametypes\_hud_message::hintMessage( getObjectiveHintText( level.players[index].pers["team"] ) );
	}
	
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
	setDvar( "ui_hud_hardcore", level.hardcoreHud );
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


roundFadeIn()
{
	thread fadeIn(level.prefadeintime, level.fadeintime);
	
	thread lockPlayersUntilFadeInComplete();
	
	wait level.prefadeintime + level.fadeintime;
	
	level notify("fade_in_complete");
	level.fadeInComplete = true;
}


lockPlayersUntilFadeInComplete()
{
	level endon("fade_in_complete");
	
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++) {
		players[i] thread lockPlayerUntilFadeInComplete();
	}
	
	while(1)
	{
		level waittill("connected", player);
		player thread lockPlayerUntilFadeInComplete();
	}
}


lockPlayerUntilFadeInComplete()
{
	if (self.sessionstate != "playing") {
		self waittill("spawned_player");
		if (isdefined(level.fadeInComplete))
			return;
	}
	assert(!isdefined(level.fadeInComplete));
	
	origin = spawn("script_origin", self.origin);
	self linkto(origin);
	
	//self disableWeapons();
	
	level waittill("fade_in_complete");
	
	if (isdefined(self))
		self unlink();
	
	origin delete();

	/*if (!isdefined(self))
		return;

	wait .05;

	self enableWeapons();*/
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
//		playSoundOnPlayers( "AB_mpc_mission_draw", "axis" );
//		playSoundOnPlayers( "US_mpc_mission_draw", "allies" );
		announcement( game["strings"]["round_draw"] );
	}
	else if ( isPlayer( winner ) )
	{
	}
	else if ( winner == "allies" )
	{
		announcement( game["strings"]["allies_win_round"] );
		playSoundOnPlayers( "US_mpc_mission_success", "allies" );
		playSoundOnPlayers( "AB_mpc_mission_fail", "axis" );
	}
	else if ( winner == "axis" )
	{
		announcement( game["strings"]["axis_win_round"] );
		playSoundOnPlayers( "AB_mpc_mission_success", "axis" );
		playSoundOnPlayers( "US_mpc_mission_fail", "allies" );
	}
	else
	{
//		playSoundOnPlayers( "AB_mpc_mission_draw", "axis" );
//		playSoundOnPlayers( "US_mpc_mission_draw", "allies" );
		announcement( game["strings"]["round_draw"] );
	}
}


announceGameWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) )
	{
//		playSoundOnPlayers( "AB_mpc_mission_draw", "axis" );
//		playSoundOnPlayers( "US_mpc_mission_draw", "allies" );
		announcement( game["strings"]["tie"] );
	}
	else if ( isPlayer( winner ) )
	{
	}
	else if ( winner == "allies" )
	{
		announcement( game["strings"]["allies_win"] );
		playSoundOnPlayers( "US_mpc_mission_success", "allies" );
		playSoundOnPlayers( "AB_mpc_mission_fail", "axis" );
	}
	else if ( winner == "axis" )
	{
		announcement( game["strings"]["axis_win"] );
		playSoundOnPlayers( "AB_mpc_mission_success", "axis" );
		playSoundOnPlayers( "US_mpc_mission_fail", "allies" );
	}
	else
	{
//		playSoundOnPlayers( "AB_mpc_mission_draw", "axis" );
//		playSoundOnPlayers( "US_mpc_mission_draw", "allies" );
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


updateLeaderboards()
{
	if ( !level.xboxlive )
		return;

	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
		players[index] sendleaderboards();
}



spawnClient()
{
	assert(	isDefined( self.pers["team"] ) );
	assert(	self.pers["class"] != "" );
	assert(	isDefined( self.pers["class"] )	);
	
	self endon ( "disconnect" );
	self endon ( "end_respawn" );

	if ( game["state"] == "prematch" )
	{
		self thread	[[level.spawnPlayer]]();
		return;
	}

	respawnTime = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" );
	respawnDelay = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "respawndelay" );
	
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
		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);
		return;
	}

	if ( respawnTime && (!level.inGracePeriod || self.hasSpawned) )
	{
		if ( respawnDelay > remainingTime )
		{
			// spawn player into spectator on death during respawn delay, if he switches teams during this time, he will respawn next round
			setLowerMessage( &"MP_WAITING_TO_SPAWN", respawnTime + remainingTime );
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
			wait( respawnDelay );
		}
		else
		{
			setLowerMessage( &"MP_WAITING_TO_SPAWN", level.waveDelay[self.pers["team"]] - (getTime() - level.lastWave[self.pers["team"]]) / 1000 );
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		}

		if ( self.pers["team"] == "allies" )
			level waittill ( "wave_respawn_allies" );
		else if	( self.pers["team"]	== "axis" )
			level waittill ( "wave_respawn_axis" );		
	}
	else if ( respawnDelay && (!level.inGracePeriod || self.hasSpawned) )
	{
		setLowerMessage( &"MP_WAITING_TO_SPAWN", respawnDelay );
		self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		wait( respawnDelay );
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
			game["allies"] = "marines";
		if ( !isDefined( game["axis"] ) )
			game["axis"] = "opfor";
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
		precacheString( &"MP_MATCH_STARTING_IN" );
		precacheString( &"MP_SPAWN_NEXT_ROUND" );
		precacheString( &"MP_WAITING_TO_SPAWN" );
		precacheString( &"MP_ALLIES_FORFEITED");
		precacheString( &"MP_AXIS_FORFEITED");
	
		precacheShader( "white" );
		precacheShader( "black" );
		
		game["strings"]["allies_win"] = &"MP_ALLIES_WIN_MATCH";
		game["strings"]["axis_win"] = &"MP_OPFOR_WIN_MATCH";
		game["strings"]["allies_win_round"] = &"MP_ALLIES_WIN_ROUND";
		game["strings"]["axis_win_round"] = &"MP_OPFOR_WIN_ROUND";
		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";

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
	
	level.hardcoreHud = getDvarInt( "ui_hud_hardcore" );

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
	thread maps\mp\_ac130::init();
	
	if ( level.teamBased )
	{
		thread maps\mp\gametypes\_hud_teamscore::init();
		thread maps\mp\gametypes\_friendicons::init();
	}
	else
	{
		thread maps\mp\gametypes\_hud_playerscore::init();
	}
		
	if ( level.xboxlive )
		thread maps\mp\gametypes\_hud_ranked::init();
		
	thread maps\mp\gametypes\_hud_weapons::init();
	thread maps\mp\gametypes\_hud_message::init();

	if(level.xenon) // Xenon only
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
		setObjectiveText( "allies", &"OBJECTIVES_WAR" );
		setObjectiveText( "axis", &"OBJECTIVES_WAR" );
		
		if ( level.splitscreen )
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_WAR" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_WAR" );
		}
		else
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_WAR_SCORE" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_WAR_SCORE" );
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

	if ( !isDefined( level.timeLimit ) )
		registerTimeLimitDvar( "default", 20, 1, 1440 );
		
	if ( !isDefined( level.scoreLimit ) )
		registerScoreLimitDvar( "default", 100, 1, 500 );

	if ( !isDefined( level.roundLimit ) )
		registerRoundLimitDvar( "default", 1, 0, 10 );

	level.inGracePeriod = true;
	level.gracePeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "graceperiod" );
	if ( level.gracePeriod > 10.0 )
		level.gracePeriod = 10.0;

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
	setTeamScore( "axis", getGameScore( "axis" ) );

	if ( game["state"] == "prematch" )
	{
		level.prematchElement = createServerFontString( "default", 2.0 );
		level.prematchElement setPoint( "TOP", undefined, 0, 30 );
		if ( level.teamBased )
			level.prematchElement setText( &"MP_WAITING_FOR_TEAMS" );
		else
			level.prematchElement setText( &"MP_WAITING_MATCH" );
					
		level.spawnMins = ( 0, 0, 0 );
		level.spawnMaxs = ( 0, 0, 0 );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
		level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
		setMapCenter( level.mapCenter );

		level.spawnpoints = getentarray("mp_dm_spawn", "classname");
		otherspawnpoints = getentarray("mp_tdm_spawn", "classname");
		for (i = 0; i < otherspawnpoints.size; i++)
			level.spawnpoints[level.spawnpoints.size] = otherspawnpoints[i];
		
		allowed[0] = "dm";
		allowed[1] = "tdm";
		maps\mp\gametypes\_gameobjects::main(allowed);

		level.timerStopped = false;
		thread timeLimitClock();
		
		thread maps\mp\gametypes\_dev::init();
		
		return;
	}

	[[level.onStartGameType]]();

	// this must be after onstartgametype for scr_showspawns to work when set at start of game
	thread maps\mp\gametypes\_dev::init();

	thread startGame();
	level thread updateGameTypeDvars();
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

	level notify( "connected", self );

	// only print that we connected if we haven't connected in a previous round
	if( !level.splitscreen && !isdefined( self.pers["score"] ) )
		iPrintLn(&"MP_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	self setClientDvars("ui_score_bar", getDvar( "ui_score_bar" ), 
						"ui_gametype_text", getDvar( "ui_gametype_text" ) );

	if( !isDefined(self.pers["place"] ) )
		self.pers["score"] = 0;
	self.score = self.pers["score"];

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

	if ( level.xboxlive )
	{
		self initLbStat( "kills", 0 );
		self initLbStat( "deaths", 1 );
		self initLbStat( "kill_streak", 2 );
		self initLbStat( "kdratio", 3 );		
		self initLbStat( "wins", 4 );
		self initLbStat( "losses", 5 );
		self initLbStat( "win_streak", 6 );		
		self initLbStat( "wlratio", 7 );
		self initLbStat( "rankxp", 8 );
		self initLbStat( "time_played_total", 9 );
		self initLbStat( "hits", 10 );
		self initLbStat( "misses", 11 );
		self initLbStat( "accuracy", 12 );
	}
		
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

	if ( level.inGracePeriod )
		self disableWeapons();

	self.hasSpawned = false;

	if ( level.numLives )
	{
		self setClientDvars("cg_deadChatWithDead", "1",
							"cg_deadChatWithTeam", "0",
							"cg_deadHearTeamLiving", "0",
							"cg_deadHearAllLiving", "0" );
	}
	else
	{
		self setClientDvars("cg_deadChatWithDead", "0",
							"cg_deadChatWithTeam", "1",
							"cg_deadHearTeamLiving", "1",
							"cg_deadHearAllLiving", "0" );
	}
	
	// When joining a game in progress, if the game is at the post game state (scoreboard) the connecting player should spawn into intermission
	if( game["state"] == "intermission" || game["state"] == "postgame" )
	{
		[[level.spawnIntermission]]();
		self closeMenu();
		self closeInGameMenu();
		return;
	}

	level endon( "intermission" );
	
	if ( !isDefined( self.pers["team"] ) )
	{
		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";
		[[level.spawnSpectator]]();
		[[level.autoassign]]();

		// skips if playing none team based gametypes
		if( level.teamBased )
		{
			// set team and spectate permissions so the map shows waypoint info on connect
			self.sessionteam = self.pers["team"];
			self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
		}
	}
	else if( self.pers["team"] != "spectator" )
	{
		if (self.pers["team"] == "axis" )
			scriptMainMenu = game["menu_class_axis"];
		else
			scriptMainMenu = game["menu_class_allies"];

		self setClientDvar( "ui_allow_classchange", "1" );
		if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
		{
			[[level.spawnSpectator]](); // spawn them as a spectator in case spawnClient doesn't spawn them immediately (perhaps at the start of a prematch round)				
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

	// Don't do knockback if the damage direction was not specified
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

	prof_end( "Callback_PlayerDamage flags/tweaks" );

	// check for completely getting out of the damage
	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{
		// return if helicopter friendly fire is on
		if( level.teamBased && isdefined( level.chopper ) && isdefined( eAttacker ) && eAttacker == level.chopper && eAttacker.team == self.pers["team"] )
		{
			if( level.friendlyfire == 0 )
			{
				prof_end( "Callback_PlayerDamage player" );
				return;
			}
		}
		
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

			if ( isPlayer( eInflictor ) )
				eInflictor maps\mp\gametypes\_persistence_util::statAdd( "stats", "hits", 1 );

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

	// Do debug print if it's enabled
	if(getDvarInt("g_debugDamage"))
		println("client:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage + " hitLoc:" + sHitLoc);

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


Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon( "spawned" );
	self notify( "killed_player" );

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

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self maps\mp\gametypes\_weapons::updateWeaponUsageStats();
	self maps\mp\gametypes\_weapons::dropWeapon();
	self maps\mp\gametypes\_weapons::dropOffhand();

	maps\mp\gametypes\_spawnlogic::deathOccured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;

	if( !isDefined( self.switching_teams ) )
	{
		// if team killed we reset kill streak, but dont count death and death streak
		if ( isPlayer( attacker ) && level.teamBased && ( attacker != self ) && ( self.pers["team"] == attacker.pers["team"] ) )
		{
			self.cur_kill_streak = 0;
		}
		else
		{		
			self incPersStat( "deaths", 1 );
			self.deaths = getPersStat( "deaths" );	
			self updatePersRatio( "kdratio", "kills", "deaths" );
			
			self.cur_kill_streak = 0;		
			self.cur_death_streak++;
			
			if ( self.cur_death_streak > self.death_streak )
			{
				self maps\mp\gametypes\_persistence_util::statSet( "stats", "death_streak", self.cur_death_streak );
				self.death_streak = self.cur_death_streak;
			}
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
				attacker.kills = getPersStat( "kills" );
				attacker updatePersRatio( "kdratio", "kills", "deaths" );
				
				attacker.cur_kill_streak++;
				attacker.cur_death_streak = 0;

				if ( attacker.cur_kill_streak > attacker.kill_streak )
				{
					attacker maps\mp\gametypes\_persistence_util::statSet( "stats", "kill_streak", attacker.cur_kill_streak );
					attacker.kill_streak = attacker.cur_kill_streak;
				}
				
				givePlayerScore( "kill", attacker, self );

				// helicopter score for team
				if( level.teamBased && isdefined( level.chopper ) && isdefined( Attacker ) && Attacker == level.chopper )
					giveTeamScore( "kill", attacker.team,  attacker, self );					
				
				// to prevent spectator gain score for team-spectator after throwing a granade and killing someone before he switched
				if ( level.teamBased && attacker.pers["team"] != "spectator")
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
					
					if ( isdefined( self.attackers ) )
					{
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
			
	prof_begin( "PlayerKilled post constants" );
	self thread maps\mp\gametypes\_missions::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );
	
	logPrint( "K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n" );

	level thread [[level.updateTeamStatus]]();

	body = self clonePlayer( deathAnimDuration );
	thread delayStartRagdoll( body );
	// body startragdoll( 1 );
	self.body = body;
	if ( !isDefined( self.switching_teams ) )
		thread maps\mp\gametypes\_deathicons::addDeathicon( body, self, self.pers["team"], 7.0 );
	
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if ( sWeapon == "artillery_mp" || sWeapon == "claymore_mp" || sWeapon == "none" )
		doKillcam = false;

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// let the player watch themselves die. Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if ( doKillcam && level.killcam  )
		self maps\mp\gametypes\_killcam::killcam( lpattacknum, sWeapon, delay, psOffsetTime, !(level.numLives && !self.pers["lives"]), timeUntilRoundEnd() );

	prof_end( "PlayerKilled post constants" );

	if ( game["state"] != "playing" )
		return;

	// class may be undefined if we have changed teams
	if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
		self thread [[level.spawnClient]]();
}


setSpawnVariables()
{
	resetTimeout();

	// Stop shellshock and rumble
	self StopShellshock();
	self StopRumble( "damage_heavy" );
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

delayStartRagdoll( ent )
{
	wait( 0.2 );
	
	if ( isDefined( ent ) )
	{
		deathAnim = ent getcorpseanim();

		waitTime = 0.0;

		if ( animhasnotetrack( deathAnim, "start_ragdoll" ) )
		{
			times = getnotetracktimes( deathAnim, "start_ragdoll" );
			if ( isDefined( times ) )
				waitTime = times[0];
		}
		else
		{
			waitTime = 0.35 * getanimlength( deathAnim );
		}

		wait( waitTime );

		if ( isDefined( ent ) )
		{
			println( "Ragdolling after " + waitTime + " seconds" );
			ent startragdoll( 1 );
		}
	}
}

