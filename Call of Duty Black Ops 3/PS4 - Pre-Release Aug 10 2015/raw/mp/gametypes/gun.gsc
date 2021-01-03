#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_wager;

#using scripts\mp\_util;

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
			load::main();

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

#precache( "string", "OBJECTIVES_GUN" );
#precache( "string", "OBJECTIVES_GUN_SCORE" );
#precache( "string", "OBJECTIVES_GUN_HINT" );
#precache( "string", "MPUI_PLAYER_KILLED" );
#precache( "string", "MP_GUN_NEXT_LEVEL" );
#precache( "string", "MP_GUN_PREV_LEVEL" );
#precache( "string", "MP_GUN_PREV_LEVEL_OTHER" );
#precache( "string", "MP_HUMILIATION" );
#precache( "string", "MP_HUMILIATED" );

function main()
{
	globallogic::init();

	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onPlayerKilled =&onPlayerKilled;
	level.onWagerAwards =&onWagerAwards;
	level.onEndGame = &onEndGame;

	game["dialog"]["gametype"] = "gg_start";
	//game["dialog"]["offense_obj"] = "generic_boost";
	//game["dialog"]["defense_obj"] = "generic_boost";
	game["dialog"]["wm_promoted"] = "gg_promote";
	game["dialog"]["wm_humiliation"] = "mpl_wager_humiliate";
	game["dialog"]["wm_humiliated"] = "sns_hum";
	
	level.giveCustomLoadout =&giveCustomLoadout;
	
	level.setBacksPerDemotion = GetGametypeSetting( "setbacks" );
	
	gameobjects::register_allowed_gameobject( level.gameType );

	//use this variable for assigning cusom game lists
	gunList = GetGametypeSetting( "gunSelection" );
	if ( gunList == 3 )
	{
		gunList = RandomIntRange( 0, 3 );
	}
	
	switch ( gunList )
	{
	case 0:
		//Normal List
		addGunToProgression( "pistol_standard" );
		addGunToProgression( "shotgun_pump+fastads" );
		addGunToProgression( "smg_standard" );
		addGunToProgression( "ar_standard+mms" );
		addGunToProgression( "lmg_light+rangefinder" );
		addGunToProgression( "sniper_powerbolt+vzoom" );
		addGunToProgression( "smaw" );
		addGunToProgression( "knife_ballistic" );
		break;
			
	case 1:
		//Close Quarters
		addGunToProgression( "pistol_standard" );
		addGunToProgression( "shotgun_pump+fastads" );		
		addGunToProgression( "smg_standard" );
		addGunToProgression( "ar_standard+mms" );
		addGunToProgression( "lmg_light+rangefinder" );
		addGunToProgression( "sniper_powerbolt+vzoom" );
		addGunToProgression( "smaw" );
		addGunToProgression( "knife_ballistic" );
		break;
		
	case 2:
		//Marksman
		addGunToProgression( "pistol_standard" );
		addGunToProgression( "shotgun_pumps+fastads" );
		addGunToProgression( "smg_standard" );
		addGunToProgression( "ar_standard+mms" );
		addGunToProgression( "lmg_light+rangefinder" );
		addGunToProgression( "sniper_powerbolt+vzoom" );
		addGunToProgression( "smaw" );
		addGunToProgression( "knife_ballistic" );
		break;		
	}
	
	util::registerTimeLimit( 0, 1440 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	globallogic::setvisiblescoreboardcolumns( "pointstowin", "kills", "deaths", "stabs", "humiliated" ); 
}

function addGunToProgression( weaponName )
{
	if ( !isdefined( level.gunProgression ) )
		level.gunProgression = [];
	
	newWeapon = SpawnStruct();
	newWeapon.weapons = [];
	newWeapon.weapons[newWeapon.weapons.size] = GetWeapon( weaponName );

	level.gunProgression[level.gunProgression.size] = newWeapon;
}

function giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	chooseRandomBody = false;
	if ( !isdefined( alreadySpawned ) || !alreadySpawned )
		chooseRandomBody = true;

	if ( !isdefined( self.gunProgress ) )
		self.gunProgress = 0;

	currentWeapon = level.gunProgression[self.gunProgress].weapons[0];

	self wager::setup_blank_random_player( takeAllWeapons, chooseRandomBody, currentWeapon );
	self DisableWeaponCycling();
	
	self giveWeapon( currentWeapon );
	self switchToWeapon( currentWeapon );
	self giveWeapon( level.weaponBaseMelee );

	if ( !isdefined( alreadySpawned ) || !alreadySpawned )
		self setSpawnWeapon( currentWeapon );
	
	if ( isdefined( takeAllWeapons ) && !takeAllWeapons )
		self thread takeOldWeapons( currentWeapon );
	else
		self EnableWeaponCycling();
		
	return currentWeapon;
}

function takeOldWeapons( currentWeapon )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "weapon_change", newWeapon );
		if ( newWeapon != level.weaponNone )
			break;
	}
	
	weaponsList = self GetWeaponsList();
	for ( i = 0 ; i < weaponsList.size ; i++ )
	{
		if ( ( weaponsList[i] != currentWeapon ) && ( weaponsList[i] != level.weaponBaseMelee ) )
			self TakeWeapon( weaponsList[i] );
	}
	
	self EnableWeaponCycling();
}

function promotePlayer( weaponUsed )
{
	self endon( "disconnect" );
	self endon( "cancel_promotion" );
	level endon( "game_ended" );
	
	{wait(.05);}; // If you suicide simultaneously, you shouldn't get the promotion
	
	for ( i = 0 ; i < level.gunProgression[self.gunProgress].weapons.size ; i++ )
	{
		if ( weaponUsed == level.gunProgression[self.gunProgress].weapons[i] )
		{
			if ( self.gunProgress < level.gunProgression.size-1 )
			{
				self.gunProgress++;
				if ( IsAlive( self ) )
					self thread giveCustomLoadout( false, true );
				self thread wager::queue_popup( &"MPUI_PLAYER_KILLED", 0, &"MP_GUN_NEXT_LEVEL" );
			}			
			pointsToWin = self.pers["pointstowin"];
			if ( pointsToWin < level.scorelimit )
			{
				self globallogic_score::givePointsToWin( level.gunGameKillScore );
				scoreevents::processScoreEvent( "kill_gun", self );				
			}
			self.lastPromotionTime = getTime();
			return;
		}
	}
}

function demotePlayer()
{
	self endon( "disconnect" );
	self notify( "cancel_promotion" );
	
	startingGunProgress = self.gunProgress;
	for ( i = 0 ; i < level.setBacksPerDemotion ; i++ )
	{
		if ( self.gunProgress <= 0 )
		{
			break;
		}
		self globallogic_score::givePointsToWin( level.gunGameKillScore * -1 );
		self.gunProgress--;
	}
	if ( ( startingGunProgress != self.gunProgress ) && IsAlive( self ) )
		self thread giveCustomLoadout( false, true );
	self.pers["humiliated"]++;
	self.humiliated = self.pers["humiliated"];
	self thread wager::queue_popup( &"MP_HUMILIATED", 0, &"MP_GUN_PREV_LEVEL", "wm_humiliated" );
	self PlayLocalSound( game["dialog"]["wm_humiliation"] );
	self globallogic_audio::leader_dialog_on_player( "wm_humiliated" );
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( ( sMeansOfDeath == "MOD_SUICIDE" ) || ( sMeansOfDeath == "MOD_TRIGGER_HURT" ) )
	{
		self thread demotePlayer();
		return;
	}
	
	if ( isdefined( attacker ) && IsPlayer( attacker ) )
	{
		if ( attacker == self )
		{
			self thread demotePlayer();
			return;
		}

		if ( isdefined( attacker.lastPromotionTime ) && attacker.lastPromotionTime + 3000 > getTime() )
		{
			scoreevents::processScoreEvent( "kill_in_3_seconds_gun", attacker, self, weapon );
		}
		
		if ( weapon_utils::isMeleeMOD( sMeansOfDeath ) )
		{
			if ( globallogic::isTopScoringPlayer( self ) )
			{
				scoreevents::processScoreEvent( "knife_leader_gun", attacker, self, weapon );
			}
			else
			{
				scoreevents::processScoreEvent( "humiliation_gun", attacker, self, weapon );
			}
			attacker PlayLocalSound( game["dialog"]["wm_humiliation"] );
						
			self thread demotePlayer();
		}
		else
		{
			attacker thread promotePlayer( weapon );
		}
	}
}

function onStartGameType()
{
	level.gunGameKillScore = rank::getScoreInfoValue( "kill_gun" );
	util::registerScoreLimit( level.gunProgression.size * level.gunGameKillScore, level.gunProgression.size * level.gunGameKillScore );
	
	SetDvar( "scr_xpscale", 0 );
	SetDvar( "ui_weapon_tiers", level.gunProgression.size );
	//makeDvarServerInfo( "ui_weapon_tiers", level.gunProgression.size );
	
	setClientNameMode("auto_change");

	util::setObjectiveText( "allies", &"OBJECTIVES_GUN" );
	util::setObjectiveText( "axis", &"OBJECTIVES_GUN" );

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_GUN" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_GUN" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_GUN_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_GUN_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_GUN_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_GUN_HINT" );

	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	
	newSpawns = GetEntArray( "mp_wager_spawn", "classname" );
	if (newSpawns.size > 0)
	{
		spawnlogic::add_spawn_points( "allies", "mp_wager_spawn" );
		spawnlogic::add_spawn_points( "axis", "mp_wager_spawn" );
	}
	else
	{
		spawnlogic::add_spawn_points( "allies", "mp_dm_spawn" );
		spawnlogic::add_spawn_points( "axis", "mp_dm_spawn" );
	}
	
	spawning::updateAllSpawnPoints();
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	// use the new spawn logic from the start
	level.useStartSpawns = false;
	
		
	level.displayRoundEndText = false;
	level.QuickMessageToAll = true;
}

function onSpawnPlayer(predictedSpawn)
{
	spawning::onSpawnPlayer(predictedSpawn);
	self thread infiniteAmmo();
}

function infiniteAmmo()
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

function onWagerAwards()
{
	stabs = self globallogic_score::getPersStat( "stabs" );
	if ( !isdefined( stabs ) )
		stabs = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", stabs, 0 );
	
	headshots = self globallogic_score::getPersStat( "headshots" );
	if ( !isdefined( headshots ) )
		headshots = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", headshots, 1 );
	
	bestKillstreak = self globallogic_score::getPersStat( "best_kill_streak" );
	if ( !isdefined( bestKillstreak ) )
		bestKillstreak = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", bestKillstreak, 2 );
}

function onEndGame( winningPlayer )
{
	if ( isDefined( winningPlayer ) && isPlayer( winningPlayer ) )
		[[level._setPlayerScore]]( winningPlayer, [[level._getPlayerScore]]( winningPlayer ) + level.gunGameKillScore );	
}