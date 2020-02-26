#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

/*
	Team Defender
	Objective: 	Score points for your team by eliminating players on the opposing team.
				Team with flag scores double kill points.
				First corpse spawns the flag.
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
*/


main()
{	
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerRoundSwitch( 0, 9 );
	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 10000 );
	registerRoundLimit( 0, 10 );
	registerNumLives( 0, 10 );
	
	level.matchRules_enemyFlagRadar = true;		
	level.matchRules_damageMultiplier = 0;
	level.matchRules_vampirism = 0;	
	
	setSpecialLoadouts();

	level.teamBased = true;
	level.initGametypeAwards = ::initGametypeAwards;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onRoundSwitch = ::onRoundSwitch;
	
	precacheShader( "waypoint_targetneutral" );	

	game["dialog"]["gametype"] = "team_def";	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	
	game["dialog"]["got_flag"] = "ctf_wetake";
	game["dialog"]["enemy_got_flag"] = "ctf_theytake";
	game["dialog"]["dropped_flag"] = "ctf_wedrop";
	game["dialog"]["enemy_dropped_flag"] = "ctf_theydrop";

	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}


onPrecacheGameType()
{
	precacheString( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
	precacheString( &"MP_NEUTRAL_FLAG_DROPPED_BY" );
	PreCacheString( &"MP_GRABBING_FLAG" );
	
	precacheString( &"OBJECTIVES_TDEF_ATTACKER_HINT" );
	precacheString( &"OBJECTIVES_TDEF_DEFENDER_HINT" );		
	precacheString( &"OBJECTIVES_TDEF" );	
	precacheString( &"OBJECTIVES_TDEF_SCORE" );	
	precacheString( &"OBJECTIVES_TDEF_HINT" );		
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

	setObjectiveText( "allies", &"OBJECTIVES_TDEF" );
	setObjectiveText( "axis", &"OBJECTIVES_TDEF" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_TDEF" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_TDEF" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_TDEF_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_TDEF_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_TDEF_ATTACKER_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_TDEF_ATTACKER_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = level.gameType;
	allowed[1] = "tdm";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	if ( !isOneRound() )
	{
		level.displayRoundEndText = true;
		if( isScoreRoundBased() )
		{
			maps\mp\gametypes\_globallogic_score::resetTeamScores();
		}
	}

	tdef();	
}


tdef()
{	
	level.icon2D["allies"] = maps\mp\teams\_teams::getTeamFlagIcon( "allies" );
	level.icon2D["axis"] = maps\mp\teams\_teams::getTeamFlagIcon( "axis" );
	precacheShader( level.icon2D["axis"] );
	precacheShader( level.icon2D["allies"] );
	
	level.carryFlag["allies"] = maps\mp\teams\_teams::getTeamFlagCarryModel( "allies" );
	level.carryFlag["axis"] = maps\mp\teams\_teams::getTeamFlagCarryModel( "axis" );
	level.carryFlag["neutral"] = maps\mp\teams\_teams::getTeamFlagModel( "neutral" );
	precacheModel( level.carryFlag["allies"] );
	precacheModel( level.carryFlag["axis"] );
	precacheModel( level.carryFlag["neutral"] );
	
	level.iconEscort3D = "waypoint_defend_flag";
	level.iconEscort2D = "waypoint_defend_flag";
	precacheShader( level.iconEscort3D );
	precacheShader( level.iconEscort2D );

	level.iconKill3D = "waypoint_kill";
	level.iconKill2D = "waypoint_kill";
	precacheShader( level.iconKill3D );
	precacheShader( level.iconKill2D );
	
	level.iconCaptureFlag3D = "waypoint_grab_red";
	level.iconCaptureFlag2D = "waypoint_grab_red";
	precacheShader( level.iconCaptureFlag3D );
	precacheShader( level.iconCaptureFlag2D );	
	
	precacheShader( "waypoint_flag_friendly" );
	precacheShader( "waypoint_flag_enemy" );
	
	level.gameFlag = undefined;	
}


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || attacker.team == self.team )
		return;
		
	victim = self;
	
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );
	
	//	we got the flag	- give bonus
	if ( isDefined( level.gameFlag ) && level.gameFlag maps\mp\gametypes\_gameobjects::getOwnerTeam() == attacker.team )
	{
		//	I'm the carrier
		if ( isDefined( attacker.carryFlag ) )
		{
			attacker AddPlayerStat( "KILLSASFLAGCARRIER", 1 );
		}
		//	someone else is
		else
		{
			//	give flag carrier a bonus for kills achieved by team
			maps\mp\_scoreevents::processScoreEvent( "team_assist", level.gameFlag.carrier, undefined, undefined, true );
		}
		
		//maps\mp\_scoreevents::processScoreEvent( "kill_bonus", attacker );	
		
		score *= 2;
	}
	//	no flag yet		- create it
	else if ( !isDefined( level.gameFlag ) && canCreateFlagAtVictimOrigin( victim ) )
	{
		level.gameFlag = createFlag( victim );
		
		score += maps\mp\gametypes\_rank::getScoreInfoValue( "MEDAL_FIRST_BLOOD" );								
	}
	//	killed carrier	- give bonus
	else if ( isDefined( victim.carryFlag ) )
	{
		killCarrierBonus = maps\mp\gametypes\_rank::getScoreInfoValue( "kill_carrier" );
		
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"MP_KILLED_FLAG_CARRIER", attacker );
		maps\mp\_scoreevents::processScoreEvent( "kill_flag_carrier", attacker, undefined, undefined, true );
		attacker recordgameevent("kill_carrier");	
		attacker AddPlayerStat( "FLAGCARRIERKILLS", 1 );
		attacker notify( "objective", "kill_carrier" );
		
		score += killCarrierBonus;			
	}

	attacker maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( attacker.team, score );
	
	otherTeam = getOtherTeam( attacker.team );
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][otherTeam] )
		attacker.finalKill = true;
}


onDrop( player )
{
	// get the time when they dropped it
	if( IsDefined( player ) && IsDefined( player.tdef_flagTime ) )
	{
		flagTime = int( GetTime() - player.tdef_flagTime );
		player AddPlayerStat( "HOLDINGTEAMDEFENDERFLAG", flagTime );
		
		if ( ( flagTime/100 ) / 60 < 1 )
			flagMinutes = 0;
		else
			flagMinutes = int( ( flagTime/100 ) / 60 );
		
		player AddPlayerStatWithGameType( "DESTRUCTIONS", flagMinutes );
		
		player.tdef_flagTime = undefined;
		player notify( "dropped_flag" );
	}

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );

	self.currentCarrier = undefined;

	self maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
	self maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconCaptureFlag2D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconCaptureFlag3D );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCaptureFlag2D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCaptureFlag3D );

	if ( isDefined( player ) )
	{
 		if ( isDefined( player.carryFlag ) )
			player detachFlag();
		
		printAndSoundOnEveryone( team, undefined, &"MP_NEUTRAL_FLAG_DROPPED_BY", &"MP_NEUTRAL_FLAG_DROPPED_BY", "mp_war_objective_lost", "mp_war_objective_lost", player );	
	}
	else
	{
		playSoundOnPlayers( "mp_war_objective_lost", team );
		playSoundOnPlayers( "mp_war_objective_lost", otherTeam );
	}

	maps\mp\gametypes\_globallogic_audio::leaderDialog( "dropped_flag", team);
	maps\mp\gametypes\_globallogic_audio::leaderDialog( "enemy_dropped_flag", otherTeam );
}


onPickup( player )
{
	self notify ( "picked_up" );

	// get the time when they picked it up
	player.tdef_flagTime = GetTime();
	player thread watchForEndGame();

	score = maps\mp\gametypes\_rank::getScoreInfoValue( "capture" );
	assert( isDefined( score ) );	

	team = player.team;
	otherTeam = getOtherTeam( team );
			
	//	flag carrier class?  (do before attaching flag)
	if ( isDefined( level.tdef_loadouts ) && isDefined( level.tdef_loadouts[team] ) )
		player thread applyFlagCarrierClass(); // attaches flag
	else
		player attachFlag();
		
	self.currentCarrier = player;	
	player.carryIcon setShader( level.icon2D[team], player.carryIcon.width, player.carryIcon.height );	
	
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconEscort2D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconEscort2D );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconKill3D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconKill3D );
	
	maps\mp\gametypes\_globallogic_audio::leaderDialog( "got_flag", team );
	maps\mp\gametypes\_globallogic_audio::leaderDialog( "enemy_got_flag", otherTeam );	

	level thread maps\mp\_popups::DisplayTeamMessageToAll( &"MP_CAPTURED_THE_FLAG", player );
	maps\mp\_scoreevents::processScoreEvent( "flag_capture", player, undefined, undefined, true );
	player recordgameevent("pickup");
	player AddPlayerStatWithGameType( "CAPTURES", 1 );
	player notify( "objective", "captured" );

	printAndSoundOnEveryone( team, undefined, &"MP_NEUTRAL_FLAG_CAPTURED_BY", &"MP_NEUTRAL_FLAG_CAPTURED_BY", "mp_obj_captured", "mp_enemy_obj_captured", player );
	
	//	give a capture bonus to the capturing team if the flag is changing hands
	if ( self.currentTeam == otherTeam )
		player maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( team, score );
	self.currentTeam = team;
	
	//	activate portable radar on flag for the opposing team
	if ( level.matchRules_enemyFlagRadar )
		self thread flagAttachRadar( otherTeam );	
}


applyFlagCarrierClass()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	//	remove placement item if carrying
	if ( IsDefined( self.isCarrying ) && self.isCarrying == true )
	{
		self notify( "force_cancel_placement" );
		wait( 0.05 );
	}	
	
	//	set the gamemodeloadout for giveLoadout() to use
	self.pers["gamemodeLoadout"] = level.tdef_loadouts[self.team];	
	
	//	set faux TI to respawn in place
	spawnPoint = spawn( "script_model", self.origin );
	spawnPoint.angles = self.angles;
	spawnPoint.playerSpawnPos = self.origin;
	spawnPoint.notTI = true;		
	self.setSpawnPoint = spawnPoint;
			
	//	spawnPlayer() calls giveLoadout() passing the player's class
	//	save their chosen class and override their current and last class 
	//	- both so killstreaks don't get reset
	//	- this is automatically set back to chosen class within giveLoadout()
	self.gamemode_chosenClass = self.class;				
	self.pers["class"] = "gamemode";
	self.pers["lastClass"] = "gamemode";
	self.class = "gamemode";
	self.lastClass = "gamemode";		
		
	//	attach flag after faux spawn (model may change for sniper or juggernaut loadout)
	self thread waitAttachFlag();
}


waitAttachFlag()
{
	level endon( "game_ende" );
	self endon( "disconnect" );
	self endon( "death" );
	
	self waittill( "spawned_player" );
	self attachFlag();
}


watchForEndGame()
{
	self endon( "dropped_flag" );
	self endon( "disconnect" );

	level waittill( "game_ended" );

	if( IsDefined( self ) )
	{
		if( IsDefined( self.tdef_flagTime ) )
		{
			flagTime = int( GetTime() - self.tdef_flagTime );
			self AddPlayerStat( "HOLDINGTEAMDEFENDERFLAG", flagTime );
			
			if ( ( flagTime/100 ) / 60 < 1 )
				flagMinutes = 0;
			else
				flagMinutes = int( (flagTime/100)/60 );

			self AddPlayerStatWithGameType( "DESTRUCTIONS", flagMinutes );
		}
	}
}


canCreateFlagAtVictimOrigin( victim )
{
	mineTriggers = getEntArray( "minefield", "targetname" );
	hurtTriggers = getEntArray( "trigger_hurt", "classname" );
	radTriggers = getEntArray( "radiation", "targetname" );
		
	for ( index = 0; index < radTriggers.size; index++ )
	{
		if ( victim isTouching( radTriggers[index] ) )
			return false;
	}

	for ( index = 0; index < mineTriggers.size; index++ )
	{
		if ( victim isTouching( mineTriggers[index] ) )
			return false;
	}

	for ( index = 0; index < hurtTriggers.size; index++ )
	{
		if ( victim isTouching( hurtTriggers[index] ) )
			return false;
	}	
	
	return true;
}


createFlag( victim )
{	
	//	flag
	visuals[0] = spawn( "script_model", victim.origin );
	visuals[0] setModel( level.carryFlag["neutral"] );
	
	//	trigger	
	trigger = spawn( "trigger_radius", victim.origin, 0, 96, 72);	
	
	gameFlag = maps\mp\gametypes\_gameobjects::createCarryObject( "neutral", trigger, visuals, (0,0,85) );
	gameFlag maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	
	gameFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	gameFlag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCaptureFlag2D );
	gameFlag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCaptureFlag3D );
	gameFlag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconCaptureFlag2D );
	gameFlag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconCaptureFlag3D );

	gameFlag maps\mp\gametypes\_gameobjects::setCarryIcon( level.icon2D["axis"] ); //temp, manually changed after picked up
	
	gameFlag.allowWeapons = true;
	gameFlag.onPickup = ::onPickup;
	gameFlag.onPickupFailed = ::onPickup;
	gameFlag.onDrop = ::onDrop;
	
	gameFlag.oldRadius = 96;	
	gameFlag.currentTeam = "none";
	gameFlag.requiresLOS = true;
	
	//	set it as flag trigger when on ground
	level.favorCloseSpawnEnt = gameFlag.trigger;
	level.favorCloseSpawnScalar = 3;	
	
	//	for this mode, the flag's home position is wherever its last safe position was, not where it was initially created
	gameFlag thread updateBasePosition();
	
	return gameFlag;
}


updateBasePosition()
{
	level endon( "game_ended" );
	
	while( true )
	{
		if ( isDefined( self.safeOrigin ) )
		{
			self.baseOrigin = self.safeOrigin;
			self.trigger.baseOrigin = self.safeOrigin;
			self.visuals[0].baseOrigin = self.safeOrigin;
		}			
		wait( 0.05 );
	}
}


attachFlag()
{
	self attach( level.carryFlag[self.team], "J_spine4", true );
	self.carryFlag = level.carryFlag[self.team];
	
	//	set it as flag carrier when carried
	level.favorCloseSpawnEnt = self;	
}


detachFlag()
{
	self detach( self.carryFlag, "J_spine4" );
	self.carryFlag = undefined;		
	
	//	set it as flag trigger when on ground
	level.favorCloseSpawnEnt = level.gameFlag.trigger;	
}


flagAttachRadar( team )
{
	level endon("game_ended");
	self  endon( "dropped" );	
}


getFlagRadarOwner( team )
{
	level endon("game_ended");
	self  endon( "dropped" );
	
	while ( true )
	{	
		foreach( player in level.players )
		{
			if ( isAlive( player ) && player.team == team )
				return player;
		}
		wait( 0.05 );
	}
}


flagRadarMover()
{
	level endon("game_ended");
	self  endon( "dropped" );
	self.portable_radar endon( "death" );
	
	for( ;; )
	{
		self.portable_radar MoveTo( self.currentCarrier.origin, .05 );
		wait (0.05);
	}
}


flagWatchRadarOwnerLost()
{
	level endon("game_ended");
	self  endon( "dropped" );
	
	radarTeam = self.portable_radar.team;
	
	self.portable_radar.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	//	make a new one
	flagAttachRadar( radarTeam );
}

onRoundEndGame( roundWinner )
{
	winner = maps\mp\gametypes\_globallogic::determineTeamWinnerByGameStat( "roundswon" );
	
	return winner;
}

onSpawnPlayerUnified()
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod )
	{
		level.useStartSpawns = false;
	}
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}


onSpawnPlayer(predictedSpawn)
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;

	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	
	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		
		if ( !spawnPoints.size )
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sab_spawn_" + spawnteam + "_start" );
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "tdm" );
	}
	pixendevent();
}


onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}

initGametypeAwards()
{
}


setSpecialLoadouts()
{
}