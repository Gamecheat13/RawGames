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
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
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
	
	//PrecacheItem( "m202_flash_wager_mp" );
	
	PrecacheString( &"MPUI_PLAYER_KILLED" );
	PrecacheString( &"MP_GUN_NEXT_LEVEL" );
	PrecacheString( &"MP_GUN_PREV_LEVEL" );
	PrecacheString( &"MP_GUN_PREV_LEVEL_OTHER" );
	PrecacheString( &"MP_HUMILIATION" );
	PrecacheString( &"MP_HUMILIATED" );
	
	addGunToProgression( "python_speed_mp" );
	addGunToProgression( "makarovdw_mp" );
	addGunToProgression( "spas_mp" );
	addGunToProgression( "ithaca_mp" );
	addGunToProgression( "mp5k_mp" );
	addGunToProgression( "skorpiondw_mp" );
	addGunToProgression( "ak74u_mp" );
	addGunToProgression( "m14_mp" );
	addGunToProgression( "m16_mp" );
	addGunToProgression( "famas_mp" );
	addGunToProgression( "aug_mp" );
	addGunToProgression( "hk21_mp" );
	addGunToProgression( "m60_mp" );
	addGunToProgression( "l96a1_mp" );
	addGunToProgression( "wa2000_mp" );
	//addGunToProgression( "m202_flash_wager_mp" );
	addGunToProgression( "rpg_mp" );
	addGunToProgression( "m72_law_mp" );
	addGunToProgression( "china_lake_mp" );
	addGunToProgression( "crossbow_explosive_mp", "explosive_bolt_mp" );
	addGunToProgression( "knife_ballistic_mp" );
	
	maps\mp\gametypes\_globallogic_utils::registerTimeLimitDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_globallogic_utils::registerScoreLimitDvar( level.gameType, level.gunProgression.size, 0, 5000 );
	maps\mp\gametypes\_globallogic_utils::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerRoundWinLimitDvar( level.gameType, 0, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	
	setscoreboardcolumns( "kills", "deaths", "stabs", "humiliated" ); 
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
	self maps\mp\gametypes\_wager::setupBlankRandomPlayer( takeAllWeapons, chooseRandomBody );
	self DisableWeaponCycling();
	
	if ( !IsDefined( self.gunProgress ) )
		self.gunProgress = 0;
	
	currentWeapon = level.gunProgression[self.gunProgress].names[0];
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
		if ( weaponUsed == level.gunProgression[self.gunProgress].names[i] )
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
	SetDvar( "scr_disable_cac", 1 );
	makedvarserverinfo( "scr_disable_cac", 1 );
	SetDvar( "scr_disable_weapondrop", 1 );
	SetDvar( "scr_game_perks", 0 );
	level.killstreaksenabled = 0;
	level.hardpointsenabled = 0;	
	SetDvar( "scr_xpscale", 0 );
	SetDvar( "ui_allow_teamchange", 0 );
	makedvarserverinfo( "ui_allow_teamchange", 0 );
	SetDvar( "ui_weapon_tiers", level.gunProgression.size );
	makedvarserverinfo( "ui_weapon_tiers", level.gunProgression.size );
	
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "allies", &"OBJECTIVES_GUN" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "axis", &"OBJECTIVES_GUN" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_GUN" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_GUN" );
	}
	else
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_GUN_SCORE" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_GUN_SCORE" );
	}
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "allies", &"OBJECTIVES_GUN_HINT" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "axis", &"OBJECTIVES_GUN_HINT" );

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
