#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Deathmatch
	Objective: 	Score points by eliminating other players
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_wager_spawn
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
			game["axis"] = "nva";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals
*/


main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 5000 );
	registerRoundLimit( 0, 10 );
	registerRoundWinLimit( 0, 10 );
	registerNumLives( 0, 10 );

	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerDamage = ::onPlayerDamage;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onWagerAwards = ::onWagerAwards;

	game["dialog"]["gametype"] = "sstones_start";
	game["dialog"]["wm_humiliation"] = "boost_gen_08";
	game["dialog"]["wm_humiliated"] = "sstones_bank_00";
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	
	PrecacheString( &"MP_HUMILIATION" );
	PrecacheString( &"MP_HUMILIATED" );
	PrecacheString( &"MP_BANKRUPTED" );
	PrecacheString( &"MP_BANKRUPTED_OTHER" );
	
	PrecacheShader( "hud_acoustic_sensor" );
	PrecacheShader( "hud_us_stungrenade" );
	
	setscoreboardcolumns( "score", "kills", "deaths", "tomahawks", "humiliated" ); 
}

giveCustomLoadout()
{
	self notify( "sas_spectator_hud" );	

	defaultWeapon = "crossbow_mp";

	self maps\mp\gametypes\_wager::setupBlankRandomPlayer( true, true, defaultWeapon );
	

	self giveWeapon( defaultWeapon );
	self SetWeaponAmmoClip( defaultWeapon, 1 );
	self SetWeaponAmmoStock( defaultWeapon, 3 );

	secondaryWeapon = "knife_ballistic_mp";
	self giveWeapon( secondaryWeapon );
	self SetWeaponAmmoStock( secondaryWeapon, 2 );

	offhandPrimary = "hatchet_mp";
	self setOffhandPrimaryClass( offhandPrimary );
	self giveWeapon( offhandPrimary );
	self SetWeaponAmmoClip( offhandPrimary, 1 );
	self SetWeaponAmmoStock( offhandPrimary, 1 );
	
	self giveWeapon( "knife_mp" );

	self switchToWeapon( defaultWeapon );
	self setSpawnWeapon( defaultWeapon );
	
	self.pers["hasRadar"] = true;
	self.hasSpyplane = true;
	
	return defaultWeapon;
}

onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( ( sWeapon == "crossbow_mp" ) && ( sMeansOfDeath == "MOD_IMPACT" ) )
	{
		if ( IsDefined( eAttacker ) && IsPlayer( eAttacker ) )
		{
			if ( !IsDefined( eAttacker.pers["sticks"] ) )
				eAttacker.pers["sticks"] = 1;
			else
				eAttacker.pers["sticks"]++;
			eAttacker.sticks = eAttacker.pers["sticks"];
		}
	}
	
	return iDamage;
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{	
	if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self )
	{
		if ( sWeapon == "hatchet_mp" )
		{
			self.pers["humiliated"]++;
			self.humiliated = self.pers["humiliated"];
						
			maps\mp\gametypes\_globallogic_score::_setPlayerScore( self, 0 );
			attacker thread maps\mp\gametypes\_wager::queueWagerPopup( &"MP_HUMILIATION", 0, &"MP_BANKRUPTED_OTHER", "wm_humiliation" );
		}
	}
	else
	{
		self.pers["humiliated"]++;
		self.humiliated = self.pers["humiliated"];
		maps\mp\gametypes\_globallogic_score::_setPlayerScore( self, 0 );
		self thread maps\mp\gametypes\_wager::queueWagerPopup( &"MP_HUMILIATED", 0, &"MP_BANKRUPTED", "wm_humiliated" );
	}
}

onStartGameType()
{
	SetDvar( "scr_xpscale", 0 );
	
	setClientNameMode("auto_change");

	setObjectiveText( "allies", &"OBJECTIVES_SAS" );
	setObjectiveText( "axis", &"OBJECTIVES_SAS" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_SAS" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_SAS" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_SAS_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_SAS_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_SAS_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_SAS_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	newSpawns = GetEntArray( "mp_wager_spawn", "classname" );
	if (newSpawns.size > 0)
	{
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_wager_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_wager_spawn" );
	}
	else
	{
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	}

	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );

	// use the new spawn logic from the start
	level.useStartSpawns = false;
	
	allowed[0] = "sas";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	level.displayRoundEndText = false;
	
	if ( IsDefined( game["roundsplayed"] ) && game["roundsplayed"] > 0 )
	{
		game["dialog"]["gametype"] = undefined;
		game["dialog"]["offense_obj"] = undefined;
		game["dialog"]["defense_obj"] = undefined;
	}
}


onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer(predictedSpawn)
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "sas" );
	}
}

onWagerAwards()
{
	tomahawks = self maps\mp\gametypes\_globallogic_score::getPersStat( "tomahawks" );
	if ( !IsDefined( tomahawks ) )
		tomahawks = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", tomahawks, 0 );
	
	sticks = self maps\mp\gametypes\_globallogic_score::getPersStat( "sticks" );
	if ( !IsDefined( sticks ) )
		sticks = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", sticks, 1 );
	
	bestKillstreak = self maps\mp\gametypes\_globallogic_score::getPersStat( "best_kill_streak" );
	if ( !IsDefined( bestKillstreak ) )
		bestKillstreak = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", bestKillstreak, 2 );
}

