#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Team VIP
	Objective: 	Score points for your team by eliminating VIP Players
	Map ends:	When one team reaches the score limit, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirementss
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
			
			
	TODO:
	//setup last alive messaging3
	//need to give player score for killing vip so it shows up at the end
	
			
			
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

	if ( isUsingMatchRulesData() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();		
	}
	else
	{
		registerRoundSwitchDvar( level.gameType, 0, 0, 9 );
		registerTimeLimitDvar( level.gameType, 10 );
		registerScoreLimitDvar( level.gameType, 6 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	level.teamBased = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.axis_vips = 0;
	level.allies_vips = 0;
	level.scoreLimitOverride = true;
	level.scoreLimit = 100;//setting this super high in case we check the score before the grace period is over.
	level.tvip_teamScores = [];
	level.tvip_teamScores["allies"] = 0;
	level.tvip_teamScores["axis"] = 0;
	
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	game["dialog"]["gametype"] = "tm_death";
	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	
	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_tvip_roundswitch", 0 );
	registerRoundSwitchDvar( "tvip", 0, 0, 9 );
	SetDynamicDvar( "scr_tvip_roundlimit", 1 );
	registerRoundLimitDvar( "tvip", 1 );		
	SetDynamicDvar( "scr_tvip_winlimit", 1 );
	registerWinLimitDvar( "tvip", 1 );			
	SetDynamicDvar( "scr_tvip_halftime", 0 );
	registerHalfTimeDvar( "tvip", 0 );
		
	SetDynamicDvar( "scr_tvip_promode", 0 );	
}

onPrecacheGameType()
{
	precacheShader("hud_vip_icon");
}


onStartGameType()
{
	setClientNameMode("auto_change");

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	setObjectiveText( "allies", &"OBJECTIVES_TVIP" );
	setObjectiveText( "axis", &"OBJECTIVES_TVIP" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_TVIP" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_TVIP" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_TVIP_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_TVIP_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_TVIP_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_TVIP_HINT" );
	
	initSpawns();
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_rank::registerScoreInfo( "vipkiller", 200 );
	maps\mp\gametypes\_rank::registerScoreInfo( "vipkill", 200 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 20 );
	
	//registerWatchDvar( "scorelimit", 1 );
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
	
	thread setScoreLimit();
}

initSpawns()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}


getSpawnPoint()
{
	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;
}

onSpawnPlayer()
{		
	if( !gameFlag( "graceperiod_done" ) && self.deaths < 1  )
	{
		self setupVIP();
		
		if( self.pers["team"] == "axis" )
		{
			level.axis_vips++;
		}
		else if( self.pers["team"] == "allies" )
		{
			level.allies_vips++;
		}
	}
	
}

onNormalDeath( victim, attacker, lifeId )
{

}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId )
{
	//self is player who has died
	
	if( !isdefined( self.is_vip ) )
	{
		return;
	}
	
	//normal death
	if( IsDefined( attacker ) && self != attacker && isplayer( attacker ) )
	{
		value = maps\mp\gametypes\_rank::getScoreInfoValue( "vipkiller" );
	/*
	player thread maps\mp\gametypes\_hud_message::SplashNotify( "flag_capture", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
	player incPlayerStat( "flagscaptured", 1 );
	
	player thread maps\mp\_matchdata::logGameEvent( "capture", player.origin );
	*/
		maps\mp\gametypes\_gamescore::givePlayerScore( "vipkiller", attacker, self, true );
		attacker thread [[level.onXPEvent]]( "vipkiller" );
		attacker thread maps\mp\gametypes\_rank::xpEventPopup( "VIP KILL" );
		
		//give the team a point
		level.tvip_teamScores[ attacker.team ]++;
		updateTeamScores();	
		if( isdefined( attacker.is_vip ) )
		{
			maps\mp\gametypes\_gamescore::givePlayerScore( "vipkill", attacker, self, true );
			attacker thread [[level.onXPEvent]]( "vipkill" );
		}
	}
	//player changed teams manually
	else if( isdefined( self.wasswitchingteamsforonplayerkilled ) )
	{
		
		if( self.pers["team"] == "axis" )
		{
			level.axis_vips--;
		}
		else if( self.pers["team"] == "allies" )
		{
			level.allies_vips--;
		}
		
		//need to lower the overall score limit if it is already set
		if( isdefined( level.scoreLimitSet ) )
		{
			if( level.axis_vips < level.allies_vips )
			{
				scorelimit = level.axis_vips;
			}
			else
			{
				scorelimit = level.allies_vips;
			}
			
			level.scoreLimit = scorelimit;
		}
		
	}
	else //if( IsDefined( attacker ) && self == attacker ) //sMeansOfDeath == "MOD_SUICIDE" )
	{
		//give the vip kill to the other team. the player was killed by suicide, car explosion or falling
		self updateScoresForNonNormalDeath();
	}
	
	self.is_vip = undefined;
	

}

updateTeamScores()
{
	game["teamScores"]["axis"] = level.tvip_teamScores["axis"];
	setTeamScore( "axis", level.tvip_teamScores["axis"] );
	game["teamScores"]["allies"] = level.tvip_teamScores["allies"];
	setTeamScore( "allies", level.tvip_teamScores["allies"] );
	
	checkScore();
}

checkScore()
{
	if ( level.tvip_teamScores["axis"] == level.scoreLimit )
	{
		level.finalKillCam_winner = "axis";
		level thread maps\mp\gametypes\_gamelogic::endGame( "axis", game["strings"]["allies_eliminated"] );			
	}
	else if ( level.tvip_teamScores["allies"] == level.scoreLimit )
	{
		level.finalKillCam_winner = "allies";
		level thread maps\mp\gametypes\_gamelogic::endGame( "axis", game["strings"]["axis_eliminated"] );			
	}
}


onTimeLimit()
{
	level.finalKillCam_winner = "none";
	if ( game["status"] == "overtime" )
	{
		winner = "forfeit";
	}
	else if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
	{
		winner = "overtime";
	}
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
	{
		level.finalKillCam_winner = "axis";
		winner = "axis";
	}
	else
	{
		level.finalKillCam_winner = "allies";
		winner = "allies";
	}
	
	thread maps\mp\gametypes\_gamelogic::endGame( winner, game["strings"]["time_limit_reached"] );
}



setupVIP()
{
		self.is_vip = true;
		
		self thread setupVIPModel();
		
		if ( level.splitscreen )
		{
			self.carryIcon = createIcon( "hud_vip_icon", 33, 33 );
			self.carryIcon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -78 );
			self.carryIcon.alpha = 0.75;
		}
		else
		{
			self.carryIcon = createIcon( "hud_vip_icon", 50, 50 );
			self.carryIcon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -65 );
			self.carryIcon.alpha = 0.75;
		}		
		self.carryIcon.hidewheninmenu = true;
		self thread hideCarryIconOnGameEnd();
		self thread hideCarryIconOnDeath();
		self thread removeVIPonDisconnect();
}

setupVIPModel()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	while( 1 )
	{
		thread removeVIPonDeath();
			
		if ( level.inGracePeriod && !self.hasDoneCombat )
			self waittill( "giveLoadout" );
		else
			self waittill( "spawned_player" );
		
		//change player model to juggernaut for testing
		[[game[self.team + "_model"]["JUGGERNAUT"]]]();
		
		self thread maps\mp\killstreaks\_juggernaut::juggernautSounds();
		
		//give the player portable radar
		self setPerk( "specialty_radarjuggernaut", true, false );	

		portable_radar = spawn( "script_model", self.origin );
		portable_radar.team = self.team;

		portable_radar makePortableRadar( self );
		self.personalRadar = portable_radar;

		self thread maps\mp\killstreaks\_juggernaut::radarMover( portable_radar );
				
	}
	
}

removeVIPonDeath()
{
	self endon( "disconnect" );
	
	self waittill( "death" );
	
	self unsetPerk( "specialty_radarjuggernaut", true );

	if ( isDefined( self.personalRadar ) )
	{
		self notify( "jugdar_removed" );
		level maps\mp\gametypes\_portable_radar::deletePortableRadar( self.personalRadar );
		self.personalRadar = undefined;	
	}
}

removeVIPonDisconnect()
{
	self waittill( "disconnect" );
	self updateScoresForNonNormalDeath();

}

updateScoresForNonNormalDeath( )
{
	if( !isdefined( self.is_vip ) )
	{
		return;
	}
	
	opposing_team = getOtherTeam( self.team );
	level.tvip_teamScores[ opposing_team ]++;
	updateTeamScores();	
}


hideCarryIconOnGameEnd()
{
	self endon( "disconnect" );
	level waittill( "game_ended" );
	
	if ( isDefined( self.carryIcon ) )
		self.carryIcon.alpha = 0;
}

hideCarryIconOnDeath()
{
	self endon( "disconnect" );
	
	self waittill( "death" );
	
	if ( isDefined( self.carryIcon ) )
		self.carryIcon.alpha = 0;
}

setScoreLimit()
{
	gameFlagWait( "graceperiod_done" );
	
	if( level.axis_vips < level.allies_vips )
	{
		scorelimit = level.axis_vips;
	}
	else
	{
		scorelimit = level.allies_vips;
	}
	
	level.scoreLimit = scorelimit;
	level.scoreLimitSet = true;
}

// need to get the last living vip
// then give him the warning
// this is not hooked up yet
onOneLeftEvent( team )
{
	lastPlayer = getLastLivingPlayer( team );

	lastPlayer thread giveLastOnTeamWarning();
}

giveLastOnTeamWarning()
{
	self endon("death");
	self endon("disconnect");
	level endon( "game_ended" );
		
	self waitTillRecoveredHealth( 3 );
	
	otherTeam = getOtherTeam( self.pers["team"] );
	level thread teamPlayerCardSplash( "callout_lastteammemberalive", self, self.pers["team"] );
	level thread teamPlayerCardSplash( "callout_lastenemyalive", self, otherTeam );
	level notify ( "last_alive", self );	
}