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

/*QUAKED mp_wager_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onWagerAwards = ::onWagerAwards;

	game["dialog"]["gametype"] = "gg_start_00";
	//game["dialog"]["offense_obj"] = "generic_boost";
	//game["dialog"]["defense_obj"] = "generic_boost";
	game["dialog"]["wm_promoted"] = "gg_promote";
	game["dialog"]["wm_humiliation"] = "boost_gen_08";
	game["dialog"]["wm_humiliated"] = "boost_gen_09";
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	
	PrecacheString( &"MPUI_PLAYER_KILLED" );
	PrecacheString( &"MP_GUN_NEXT_LEVEL" );
	PrecacheString( &"MP_GUN_PREV_LEVEL" );
	PrecacheString( &"MP_GUN_PREV_LEVEL_OTHER" );
	PrecacheString( &"MP_HUMILIATION" );
	PrecacheString( &"MP_HUMILIATED" );
	
	PrecacheItem( "minigun_wager_mp" );
	PrecacheItem( "m32_wager_mp" );
	
	addGunToProgression( "knife_ballistic_mp" );
	addGunToProgression( "judge_mp" );
	addGunToProgression( "beretta93r_dw_mp" );
	addGunToProgression( "ksg_mp" );
	addGunToProgression( "srm1216_mp" );
	addGunToProgression( "insas_mp" );
	addGunToProgression( "evoskorpion_mp" );
	addGunToProgression( "saritch_mp" );
	addGunToProgression( "hk416_mp" );
	addGunToProgression( "xm8_mp" );
	addGunToProgression( "mk48_mp" );
	addGunToProgression( "qbb95_mp" );
	addGunToProgression( "svu_mp" );
	addGunToProgression( "dsr50_mp" );
	addGunToProgression( "usrpg_mp" );
	addGunToProgression( "crossbow_mp" );
	addGunToProgression( "m32_wager_mp" );
	addGunToProgression( "minigun_wager_mp" );
	addGunToProgression( "ballista_fastreload_mp" );
	
	registerTimeLimit( 0, 1440 );
	registerScoreLimit( level.gunProgression.size, level.gunProgression.size );
	registerRoundLimit( 0, 10 );
	registerRoundWinLimit( 0, 10 );
	registerNumLives( 0, 10 );
	
	level.onPlayerScore = ::blank;

	setscoreboardcolumns( "score", "kills", "deaths", "stabs", "humiliated" ); 
}

addGunToProgression( gunName, altName )
{
	if ( !IsDefined( level.gunProgression ) )
		level.gunProgression = [];
	
	newWeapon = SpawnStruct();
	newWeapon.names = [];
	newWeapon.names[newWeapon.names.size] = gunName;
	if ( IsDefined( altName ) )
		newWeapon.names[newWeapon.names.size] = altName;
	level.gunProgression[level.gunProgression.size] = newWeapon;
}

giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	chooseRandomBody = false;
	if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
		chooseRandomBody = true;

	if ( !IsDefined( self.gunProgress ) )
		self.gunProgress = 0;

	currentWeapon = level.gunProgression[self.gunProgress].names[0];

	self maps\mp\gametypes\_wager::setupBlankRandomPlayer( takeAllWeapons, chooseRandomBody, currentWeapon );
	self DisableWeaponCycling();
	
	self giveWeapon( currentWeapon );
	self switchToWeapon( currentWeapon );
	self giveWeapon( "knife_mp" );
	
	if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
		self setSpawnWeapon( currentWeapon );
	
	if ( IsDefined( takeAllWeapons ) && !takeAllWeapons )
		self thread takeOldWeapons( currentWeapon );
	else
		self EnableWeaponCycling();
		
	return currentWeapon;
}

takeOldWeapons( currentWeapon )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "weapon_change", newWeapon );
		if ( newWeapon != "none" )
			break;
	}
	
	weaponsList = self GetWeaponsList();
	for ( i = 0 ; i < weaponsList.size ; i++ )
	{
		if ( ( weaponsList[i] != currentWeapon ) && ( weaponsList[i] != "knife_mp" ) )
			self TakeWeapon( weaponsList[i] );
	}
	
	self EnableWeaponCycling();
}

promotePlayer( weaponUsed )
{
	self endon( "disconnect" );
	self endon( "cancel_promotion" );
	level endon( "game_ended" );
	
	wait 0.05; // If you suicide simultaneously, you shouldn't get the promotion
	for ( i = 0 ; i < level.gunProgression[self.gunProgress].names.size ; i++ )
	{
		if ( weaponUsed == level.gunProgression[self.gunProgress].names[i] || (weaponUsed == "explosive_bolt_mp" && level.gunProgression[self.gunProgress].names[i] == "crossbow_mp" ) )
		{
			if ( self.gunProgress < level.gunProgression.size-1 )
			{
				self.gunProgress++;
				if ( IsAlive( self ) )
					self thread giveCustomLoadout( false, true );
				self thread maps\mp\gametypes\_wager::queueWagerPopup( &"MPUI_PLAYER_KILLED", 0, &"MP_GUN_NEXT_LEVEL" );
			}
			score = maps\mp\gametypes\_globallogic_score::_getPlayerScore( self );
			if ( score < level.gunProgression.size )
				maps\mp\gametypes\_globallogic_score::_setPlayerScore( self, score + 1 );
			return;
		}
	}
}

demotePlayer()
{
	self endon( "disconnect" );
	self notify( "cancel_promotion" );
	if ( self.gunProgress > 0 )
	{
		score = maps\mp\gametypes\_globallogic_score::_getPlayerScore( self );
		maps\mp\gametypes\_globallogic_score::_setPlayerScore( self, score - 1 );
		self.gunProgress--;
		if ( IsAlive( self ) )
			self thread giveCustomLoadout( false, true );
	}
	self.pers["humiliated"]++;
	self.humiliated = self.pers["humiliated"];
	self thread maps\mp\gametypes\_wager::queueWagerPopup( &"MP_HUMILIATED", 0, &"MP_GUN_PREV_LEVEL", "wm_humiliated" );
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( sMeansOfDeath == "MOD_SUICIDE" )
	{
		self thread demotePlayer();
		return;
	}
	
	if ( IsDefined( attacker ) && IsPlayer( attacker ) )
	{
		if ( attacker == self )
		{
			self thread demotePlayer();
			return;
		}
		
		if ( sMeansOfDeath == "MOD_MELEE" )
		{
			self thread demotePlayer();
			attacker thread maps\mp\gametypes\_wager::queueWagerPopup( &"MP_HUMILIATION", 0, &"MP_GUN_PREV_LEVEL_OTHER", "wm_humiliation" );
			return;
		}
		
		attacker thread promotePlayer( sWeapon );
	}
}

onStartGameType()
{
	SetDvar( "scr_xpscale", 0 );
	SetDvar( "ui_weapon_tiers", level.gunProgression.size );
	makedvarserverinfo( "ui_weapon_tiers", level.gunProgression.size );
	
	setClientNameMode("auto_change");

	setObjectiveText( "allies", &"OBJECTIVES_GUN" );
	setObjectiveText( "axis", &"OBJECTIVES_GUN" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_GUN" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_GUN" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_GUN_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_GUN_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_GUN_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_GUN_HINT" );

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
	
	allowed[0] = "gun";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
	
	level.displayRoundEndText = false;
	level.QuickMessageToAll = true;
}

onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
	self thread infiniteAmmo();
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
		self spawn( spawnPoint.origin, spawnPoint.angles, "gun" );
		self thread infiniteAmmo();
	}
}

infiniteAmmo()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	for ( ;; )
	{
		wait( 0.1 );
		
		weapon = self GetCurrentWeapon();
		
		self GiveMaxAmmo( weapon );
	}
}

onWagerAwards()
{
	stabs = self maps\mp\gametypes\_globallogic_score::getPersStat( "stabs" );
	if ( !IsDefined( stabs ) )
		stabs = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", stabs, 0 );
	
	headshots = self maps\mp\gametypes\_globallogic_score::getPersStat( "headshots" );
	if ( !IsDefined( headshots ) )
		headshots = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", headshots, 1 );
	
	bestKillstreak = self maps\mp\gametypes\_globallogic_score::getPersStat( "best_kill_streak" );
	if ( !IsDefined( bestKillstreak ) )
		bestKillstreak = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", bestKillstreak, 2 );
}
