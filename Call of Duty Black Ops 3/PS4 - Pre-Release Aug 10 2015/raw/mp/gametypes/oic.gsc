#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
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


// *******************************************************************
//                         main
// *******************************************************************



#precache( "string", "OBJECTIVES_DM" );
#precache( "string", "OBJECTIVES_DM_SCORE" );
#precache( "string", "OBJECTIVES_OIC_HINT" );
#precache( "string", "MPUI_PLAYER_KILLED" );
#precache( "string", "MP_PLUS_ONE_BULLET" );
#precache( "string", "MP_OIC_SURVIVOR_BONUS" );

function main()
{
	//level.livesDoNotReset = true;
	globallogic::init();

	level.pointsPerWeaponKill = GetGametypeSetting( "pointsPerWeaponKill" );
	level.pointsPerMeleeKill = GetGametypeSetting( "pointsPerMeleeKill" );
	level.pointsForSurvivalBonus = GetGametypeSetting( "pointsForSurvivalBonus" );
	
	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 50000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 1, 100 );

	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.giveCustomLoadout =&giveCustomLoadout;
	level.onPlayerKilled =&onPlayerKilled;
	level.onPlayerDamage =&onPlayerDamage;
	level.onWagerAwards =&onWagerAwards;

	gameobjects::register_allowed_gameobject( level.gameType );

	game["dialog"]["gametype"] = "oic_start";
	game["dialog"]["wm_2_lives"] = "oic_2life";
	game["dialog"]["wm_final_life"] = "oic_last";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "pointstowin", "kills", "deaths", "stabs", "survived" );
}

function onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( ( sMeansOfDeath == "MOD_PISTOL_BULLET" ) || ( sMeansOfDeath == "MOD_RIFLE_BULLET" ) || ( sMeansOfDeath == "MOD_HEAD_SHOT" ) )
	{
		//insta-kill		
		iDamage = self.maxhealth + 1;// 999999;
	}
	
	return iDamage;
}

// *******************************************************************
//                   Custom Loadout
// *******************************************************************
function giveCustomLoadout()
{
	weapon = GetWeapon( "pistol_standard" );

	self wager::setup_blank_random_player( true, true, weapon );	
	
	self giveWeapon( weapon );
	self giveWeapon( level.weaponBaseMelee );
	self switchToWeapon( weapon );

	clipAmmo = 1;
	if( isdefined( self.pers["clip_ammo"] ) )
	{
		clipAmmo = self.pers["clip_ammo"];
		self.pers["clip_ammo"] = undefined;
	}
	self SetWeaponAmmoClip( weapon, clipAmmo );

	stockAmmo = 0;
	if( isdefined( self.pers["stock_ammo"] ) )
	{
		stockAmmo = self.pers["stock_ammo"];
		self.pers["stock_ammo"] = undefined;
	}
	self SetWeaponAmmoStock( weapon, stockAmmo );
	
	self setSpawnWeapon( weapon );
	
	self setPerk( "specialty_unlimitedsprint" );
	self setPerk( "specialty_movefaster" );
	
	return weapon;
}


// *******************************************************************
//                     Game Type
// *******************************************************************
function onStartGameType()
{
	setClientNameMode("auto_change");

	util::setObjectiveText( "allies", &"OBJECTIVES_DM" );
	util::setObjectiveText( "axis", &"OBJECTIVES_DM" );

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
	}

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

	// elimination style
	if ( level.roundLimit != 1 && level.numLives )
	{
		level.overridePlayerScore = true;
		level.displayRoundEndText = true;
		level.onEndGame =&onEndGame;
	}
	
	level thread watchElimination();
	
	util::setObjectiveHintText( "allies", &"OBJECTIVES_OIC_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_OIC_HINT" );
}

// *******************************************************************
//                  
// *******************************************************************

function onSpawnPlayer(predictedSpawn)
{
	spawning::onSpawnPlayer(predictedSpawn);
	
	livesLeft = self.pers["lives"];
	if ( livesLeft == 2 )
	{
		self wager::announcer( "wm_2_lives" );
	}
	else if ( livesLeft == 1 )
	{
		self wager::announcer( "wm_final_life" );
	}
}

// *******************************************************************
//                   
// *******************************************************************

function onEndGame( winningPlayer )
{
	if ( isdefined( winningPlayer ) && isPlayer( winningPlayer ) )
		[[level._setPlayerScore]]( winningPlayer, [[level._getPlayerScore]]( winningPlayer ) + 1 );	
}

// *******************************************************************
//                  
// *******************************************************************

function onStartWagerSidebets()
{
	thread saveOffAllPlayersAmmo();
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function saveOffAllPlayersAmmo()
{
	wait 1.0;

	for( playerIndex = 0 ; playerIndex < level.players.size ; playerIndex++ )
	{
		player = level.players[playerIndex];
		if( !isdefined( player ) )
			continue;

		if( player.pers["lives"] == 0 )
			continue;

		currentWeapon = player GetCurrentWeapon();
		player.pers["clip_ammo"] = player GetWeaponAmmoClip( currentWeapon );
		player.pers["stock_ammo"] = player GetWeaponAmmoStock( currentWeapon );
	}
}

function isPlayerEliminated( player )
{
	return isdefined( player.pers["eliminated"] ) && player.pers["eliminated"];
}

function getPlayersLeft()
{
	playersRemaining = [];
	for( playerIndex = 0 ; playerIndex < level.players.size ; playerIndex++ )
	{
		player = level.players[ playerIndex ];
		if( !isdefined( player ) )
			continue;

		if( !IsPlayerEliminated( player ) )
		{
			playersRemaining[ playersRemaining.size ] = player;
		}
	}
	return playersRemaining;
}

function onWagerFinalizeRound()
{
	// Do side bet calculations
	playersLeft = getPlayersLeft();
	lastManStanding = playersLeft[0];
	sideBetPool = 0;
	sideBetWinners = [];
	players = level.players;
	for ( playerIndex = 0 ; playerIndex < players.size ; playerIndex++ )
	{
		if ( isdefined( players[playerIndex].pers["sideBetMade"] ) )
		{
			sideBetPool += GetDvarint( "scr_wagerSideBet" );
			if ( players[playerIndex].pers["sideBetMade"] == lastManStanding.name )
			{
				sideBetWinners[ sideBetWinners.size ] = players[ playerIndex ];
			}
		}
	}

	if( sideBetWinners.size == 0 )
		return;

	sideBetPayout = int( sideBetPool / sideBetWinners.size );
	for ( index = 0 ; index < sideBetWinners.size ; index++ )
	{
		player = sideBetWinners[ index ];
		player.pers["wager_sideBetWinnings"] += sideBetPayout;
	}
}


// *******************************************************************
//                  Bullet Hud Anim
// *******************************************************************

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( isdefined( attacker ) && isPlayer( attacker ) && self != attacker )
	{
		attackerAmmo = attacker getammocount( "pistol_standard" );
		victimAmmo = self getammocount( "pistol_standard" );

		attacker GiveAmmo( 1 );
		attacker thread wager::queue_popup( &"MPUI_PLAYER_KILLED", 0, &"MP_PLUS_ONE_BULLET" );
		attacker playLocalSound( "mpl_oic_bullet_pickup" );
		if ( weapon_utils::isMeleeMOD( sMeansOfDeath ) )
		{
			attacker globallogic_score::givePointsToWin( level.pointsPerMeleeKill );
			if ( attackerAmmo > 0 )
			{
				scoreevents::processScoreEvent( "knife_with_ammo_oic", attacker, self, weapon );
			}
			if ( victimAmmo > attackerAmmo )
			{
				scoreevents::processScoreEvent( "kill_enemy_with_more_ammo_oic", attacker, self, weapon );
			}
		}
		else
		{
			attacker globallogic_score::givePointsToWin( level.pointsPerWeaponKill );
			if ( victimAmmo > attackerAmmo + 1 ) // for the shot they just fired
			{
				scoreevents::processScoreEvent( "kill_enemy_with_more_ammo_oic", attacker, self, weapon );
			}
		}


		if ( self.pers["lives"] == 0 ) 
		{
			scoreevents::processScoreEvent( "eliminate_oic", attacker, self, weapon );
		}
	}
}

function GiveAmmo( amount )
{		
	currentWeapon = self getCurrentWeapon();
	clipAmmo = self GetWeaponAmmoClip( currentWeapon );
	self SetWeaponAmmoClip( currentWeapon, clipAmmo + amount );
}

function shouldReceiveSurvivorBonus()
{
	if ( IsAlive( self ) )
	{
		return true;
	}
	
	if ( self.hasSpawned && ( self.pers["lives"] > 0 ) )
	{
		return true;
	}
	
	return false;
}

function watchElimination()
{
	level endon( "game_ended" );
	
	for ( ;; )
	{
		level waittill( "player_eliminated" );
		players = level.players;
		for ( i = 0 ; i < players.size ; i++ )
		{
			if ( isdefined( players[i] ) && players[i] shouldReceiveSurvivorBonus() )
			{
				players[i].pers["survived"]++;
				players[i].survived = players[i].pers["survived"];
				
				players[i] thread wager::queue_popup( &"MP_OIC_SURVIVOR_BONUS", 10 );
				score = globallogic_score::_getPlayerScore( players[i] );
				scoreevents::processScoreEvent( "survivor", players[i] );
				players[i] globallogic_score::givePointsToWin( level.pointsForSurvivalBonus );
			}
		}
	}
}

function onWagerAwards()
{
	stabs = self globallogic_score::getPersStat( "stabs" );
	if ( !isdefined( stabs ) )
		stabs = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", stabs, 0 );
	
	longshots = self globallogic_score::getPersStat( "longshots" );
	if ( !isdefined( longshots ) )
		longshots = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", longshots, 1 );
	
	bestKillstreak = self globallogic_score::getPersStat( "best_kill_streak" );
	if ( !isdefined( bestKillstreak ) )
		bestKillstreak = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", bestKillstreak, 2 );
}
