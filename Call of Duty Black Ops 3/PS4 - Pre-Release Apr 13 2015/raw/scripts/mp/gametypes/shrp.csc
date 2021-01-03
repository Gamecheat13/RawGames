#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_persistence;
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

#precache( "material", "perk_times_two" );
#precache( "string", "OBJECTIVES_SHRP" );
#precache( "string", "OBJECTIVES_SHRP_SCORE" );
#precache( "string", "OBJECTIVES_SHRP_HINT" );
#precache( "string", "MP_SHRP_WEAPONS_CYCLED" );
#precache( "string", "MP_SHRP_PENULTIMATE_RND" );
#precache( "string", "MP_SHRP_PENULTIMATE_MULTIPLIER" );
#precache( "string", "MP_SHRP_RND" );
#precache( "string", "MP_SHRP_FINAL_MULTIPLIER" );
#precache( "string", "MP_SHRP_COUNTDOWN" );

function main()
{
	globallogic::init();

	level.pointsPerWeaponKill = GetGametypeSetting( "pointsPerWeaponKill" );
	level.pointsPerMeleeKill = GetGametypeSetting( "pointsPerMeleeKill" );
	level.shrpWeaponTimer = GetGametypeSetting( "weaponTimer" );
	level.shrpWeaponNumber = GetGametypeSetting( "weaponCount" );
	
	util::registerTimeLimit( level.shrpWeaponNumber * level.shrpWeaponTimer / 60, level.shrpWeaponNumber * level.shrpWeaponTimer / 60 );
	util::registerScoreLimit( 0, 50000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.onPlayerKilled =&onPlayerKilled;
	level.onWagerAwards =&onWagerAwards;

	game["dialog"]["gametype"] = "ss_start";
	
	level.giveCustomLoadout =&giveCustomLoadout;
	
	game["dialog"]["wm_weapons_cycled"] = "ssharp_cycle_01";
	game["dialog"]["wm_final_weapon"] = "ssharp_fweapon";
	game["dialog"]["wm_bonus_rnd"] = "ssharp_2multi_00";
	game["dialog"]["wm_shrp_rnd"] = "ssharp_sround";
	game["dialog"]["wm_bonus0"] = "boost_gen_05";
	game["dialog"]["wm_bonus1"] = "boost_gen_05";
	game["dialog"]["wm_bonus2"] = "boost_gen_05";
	game["dialog"]["wm_bonus3"] = "boost_gen_05";
	game["dialog"]["wm_bonus4"] = "boost_gen_05";
	game["dialog"]["wm_bonus5"] = "boost_gen_05";
	
	globallogic::setvisiblescoreboardcolumns( "pointstowin", "kills", "deaths", "stabs", "x2score" ); 
}

function onStartGameType()
{
	SetDvar( "scr_disable_weapondrop", 1 );
	SetDvar( "scr_xpscale", 0 );
	SetDvar( "ui_guncycle", 0 );
	//makeDvarServerInfo( "ui_guncycle", 0 );
	
	setClientNameMode("auto_change");

	util::setObjectiveText( "allies", &"OBJECTIVES_SHRP" );
	util::setObjectiveText( "axis", &"OBJECTIVES_SHRP" );

	attach_compatibility_init();

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_SHRP" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_SHRP" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_SHRP_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_SHRP_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_SHRP_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_SHRP_HINT" );

	allowed[0] = "shrp";
	gameobjects::main(allowed);

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
	
	
	// Toughness
	wager::add_powerup( "specialty_bulletflinch", "perk", &"PERKS_TOUGHNESS", "perk_warrior" );

	// Lightweight 
	wager::add_powerup( "specialty_movefaster", "perk", &"PERKS_LIGHTWEIGHT", "perk_lightweight" );
	wager::add_powerup( "specialty_fallheight", "perk", &"PERKS_LIGHTWEIGHT", "perk_lightweight" );

	// Extreme conditioning
	wager::add_powerup( "specialty_longersprint", "perk", &"PERKS_EXTREME_CONDITIONING", "perk_marathon" );

	// x2 Score Multiplier
	wager::add_powerup( 2, "score_multiplier", &"PERKS_SCORE_MULTIPLIER", "perk_times_two" );
	
	level.gunCycleTimer = hud::createServerTimer( "extrasmall", 1.2 );
	level.gunCycleTimer.horzAlign = "user_left";
	level.gunCycleTimer.vertAlign = "user_top";
	level.gunCycleTimer.x = 10;
	level.gunCycleTimer.y = 123;
	level.gunCycleTimer.alignX = "left";
	level.gunCycleTimer.alignY = "top";
	level.gunCycleTimer.label = &"MP_SHRP_COUNTDOWN";
	level.gunCycleTimer.alpha = 0;
	level.gunCycleTimer.hideWhenInKillcam = true;
	
	level.displayRoundEndText = false;
	level.QuickMessageToAll = true;
	level thread chooseRandomGuns();
	level thread clearPowerupsOnGameEnd();
}

function attach_compatibility_init()
{
	level.attach_compatible = [];
	
	set_attachtable_id();

	for( i = 0; i < 33; i++ )
	{
		itemRow = tableLookupRowNum( level.attachTableID, 9, i );
		
		if ( itemRow > -1 )
		{
			name = tableLookupColumnForRow( level.attachTableID, itemRow, 4 );
			
			level.attach_compatible[name] = [];
			
			compatible = tableLookupColumnForRow( level.attachTableID, itemRow, 11 );
			
			level.attach_compatible[name] = strTok( compatible, " " );
			
		}
	}
}

function set_attachtable_id()
{
	if ( !isdefined( level.attachTableID ) )
	{
		level.attachTableID = "gamedata/weapons/common/attachmentTable.csv";
	}
}

function getRandomWeaponNameFromProgression()
{	
	weaponIDKeys = GetArrayKeys( level.tbl_weaponIDs );
	numWeaponIDKeys = weaponIDKeys.size;
	gunProgressionSize = 0;
	if ( isdefined( level.gunProgression ) ) 
	{
		size = level.gunProgression.size;

	}
/#
	debug_weapon =  GetDvarString( "scr_shrp_debug_weapon" );
#/

	allowProneBlock = true;
	players = GetPlayers();

	foreach( player in players )
	{
		if ( player GetStance() == "prone" )
		{
			allowProneBlock = false;
			break;
		}
	}
	
	while ( true )
	{
		randomIndex = RandomInt( numWeaponIDKeys + gunProgressionSize );
		baseWeaponName = "";
		weaponName = "";
		
		if ( randomIndex < numWeaponIDKeys )
		{
			id = array::random( level.tbl_weaponIDs );
			if ( ( id[ "group" ] != "weapon_launcher" ) && ( id[ "group" ] != "weapon_sniper" ) && ( id[ "group" ] != "weapon_lmg" ) && ( id[ "group" ] != "weapon_assault" ) && ( id[ "group" ] != "weapon_smg" ) && ( id[ "group" ] != "weapon_pistol" ) && ( id[ "group" ] != "weapon_cqb" ) && ( id[ "group" ] != "weapon_special" ) )
				continue;
				
			if ( id[ "reference" ] == "weapon_null" )
				continue;
							
			baseWeaponName = id[ "reference" ];
			attachmentList = id[ "attachment" ];
			if ( baseWeaponName == "m32" )
				baseWeaponName = "m32_wager";
			if ( baseWeaponName == "minigun" )
				baseWeaponName = "minigun_wager";
			if ( baseWeaponName == "riotshield" )
				continue;
				
			weaponName = addRandomAttachmentToWeaponName( baseWeaponName, attachmentList );

			weapon = GetWeapon( weaponName );
			if ( !allowProneBlock && weapon.blocksProne )
				continue;
		}
		else
		{
			baseWeaponName = level.gunProgression[randomIndex - numWeaponIDKeys].names[0];
			weaponName = level.gunProgression[randomIndex - numWeaponIDKeys].names[0];
		}
		
		if ( !isdefined( level.usedBaseWeapons ) )
		{
			level.usedBaseWeapons = [];
			level.usedBaseWeapons[0] = "fhj18";
		}
		skipWeapon = false;
		for ( i = 0 ; i < level.usedBaseWeapons.size ; i++ )
		{
			if ( level.usedBaseWeapons[i] == baseWeaponName )
			{
				skipWeapon = true;
				break;
			}
		}
		if ( skipWeapon )
			continue;
		level.usedBaseWeapons[level.usedBaseWeapons.size] = baseWeaponName;
/#
		if ( debug_weapon != "" )
		{
			weaponName = debug_weapon;	
		}
#/
		return weaponName;
	}
}

function addRandomAttachmentToWeaponName( baseWeaponName, attachmentList )
{
	if ( !isdefined( attachmentList ) )
		return baseWeaponName;
		
	attachments = StrTok( attachmentList, " " );
	ArrayRemoveValue( attachments, "dw" ); // dw weapon madness in the statstable
	if ( attachments.size <= 0 )
		return baseWeaponName;
		
	attachments[attachments.size] = "";
	attachment = array::random( attachments );
	if ( attachment == "" )
		return baseWeaponName;
		
	if( IsSubStr( attachment, "_" ) )
	{
		
		attachment = StrTok( attachment, "_" )[0];
	}
	
	//iprintlnbold( baseWeaponName+attachment );
	
	if ( isdefined( level.attach_compatible[attachment] ) && level.attach_compatible[attachment].size > 0 )
	{
		attachment2 = level.attach_compatible[attachment][randomInt(level.attach_compatible[attachment].size)];
	
		//iprintlnbold( baseWeaponName+attachment+"+"+attachment2 );
	
		contains = false;
		for ( i=0; i<attachments.size; i++ )
		{
			if( isdefined( attachment2 ) && attachments[i] == attachment2 )
			{
				contains = true;
				break;			
			}
		}
					
		if ( contains )
		{
			if ( attachment < attachment2 )
				return baseWeaponName+attachment+"+"+attachment2;
			
			return baseWeaponName+attachment2+"+"+attachment;
		}
	}
	
	return baseWeaponName+attachment;
}

function waitLongDurationWithHostMigrationPause( nextGunCycleTime, duration )
{
	endtime = gettime() + duration * 1000;
	totalTimePassed = 0;
	
	while ( gettime() < endtime )
	{
		hostmigration::waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		if ( isdefined( level.hostMigrationTimer ) )
		{
			SetDvar( "ui_guncycle", 0 );
			
			timePassed = hostmigration::waitTillHostMigrationDone();
			
			totalTimePassed += timePassed;
			endtime += timePassed;
			
/#
			println("[SHRP] timePassed = " + timePassed);
			println("[SHRP] totatTimePassed = " + totalTimePassed);
			println("[SHRP] level.discardTime = " + level.discardTime);
#/			
			SetDvar( "ui_guncycle", nextGunCycleTime + totalTimePassed );
		}
	}
	
	hostmigration::waitTillHostMigrationDone();
	
	return totalTimePassed;
}


function gunCycleWaiter( nextGunCycleTime, waitTime )
{
	continueCycling = true;
	SetDvar( "ui_guncycle", nextGunCycleTime );
	level.gunCycleTimer setTimer( waitTime );
	level.gunCycleTimer.alpha = 1;
		
	// Initial wait
	timePassed = waitLongDurationWithHostMigrationPause ( nextGunCycleTime, ( nextGunCycleTime - GetTime() ) / 1000 - 6 );
	nextGunCycleTime += timePassed;

	// Last 6 seconds countdown
	for ( i = 6 ; i > 1 ; i-- )
	{
		for ( j = 0 ; j < level.players.size ; j++ )
			level.players[j] playLocalSound( "uin_timer_wager_beep" );
		timePassed = waitLongDurationWithHostMigrationPause ( nextGunCycleTime, ( nextGunCycleTime - GetTime() ) / 1000 / i );
		nextGunCycleTime += timePassed;
	}
	
	for ( i = 0 ; i < level.players.size ; i++ )
	{
		level.players[i] playLocalSound( "uin_timer_wager_last_beep" );
	}
	if ( ( nextGunCycleTime - GetTime() ) > 0 )
		wait ( ( nextGunCycleTime - GetTime() ) / 1000 );
	
	// Next weapon
	level.shrpRandomWeapon = GetWeapon( getRandomWeaponNameFromProgression() );
	
	for ( i = 0 ; i < level.players.size ; i++ )
	{			
		level.players[i] notify( "remove_planted_weapons" );
		level.players[i] giveCustomLoadout( false, true );
	}
	
	return continueCycling;
}

function chooseRandomGuns()
{
	level endon( "game_ended" );
	level thread awardMostPointsMedalGameEnd();
	waitTime = level.shrpWeaponTimer;
	lightningWaitTime = 15;
	
	level.shrpRandomWeapon = GetWeapon( getRandomWeaponNameFromProgression() );
	
	if ( level.inPrematchPeriod )
		level waittill( "prematch_over" );
		
	gunCycle = 1;
	numGunCycles = int( level.timeLimit * 60 / waitTime + 0.5 );
		
	while( true )
	{
		nextGunCycleTime = gettime() + waitTime * 1000;
		isPenultimateRound = false;
		isSharpshooterRound = ( gunCycle == numGunCycles-1 );
		for ( i = 0 ; i < level.players.size ; i++ )
		{
			level.players[i].currentGunCyclePoints = 0;
		}
		level.currentGunCycleMaxPoints = 0;
		gunCycleWaiter( nextGunCycleTime, waitTime );
		for ( i = 0 ; i < level.players.size ; i++ )
		{
			player = level.players[i];
			
			if ( gunCycle + 1 == numGunCycles )
				player wager::announcer( "wm_final_weapon" );
			else
				player wager::announcer( "wm_weapons_cycled" );
			
			player checkAwardMostPointsThisCycle();
		}
		if ( isPenultimateRound )
		{
			level.sharpshooterMultiplier = 2;
			for ( i = 0 ; i < level.players.size ; i++ )
				level.players[i] thread wager::queue_popup( &"MP_SHRP_PENULTIMATE_RND", 0, &"MP_SHRP_PENULTIMATE_MULTIPLIER", "wm_bonus_rnd" );
		}
		else if ( isSharpshooterRound )
		{
			lastMultiplier = level.sharpshooterMultiplier;
			if ( !isdefined( lastMultiplier ) )
				lastMultiplier = 1;
			level.sharpshooterMultiplier = 2;
			SetDvar( "ui_guncycle", 0 );
			level.gunCycleTimer.alpha = 0;
			for ( i = 0 ; i < level.players.size ; i++ )
				level.players[i] thread wager::queue_popup( &"MP_SHRP_RND", 0, &"MP_SHRP_FINAL_MULTIPLIER", "wm_shrp_rnd" );
			break;
		}
		else
		{
			level.sharpshooterMultiplier = 1;
		}
		gunCycle++;
	}
}

function checkAwardMostPointsThisCycle() 
{
	if ( isdefined ( self.currentGunCyclePoints ) && self.currentGunCyclePoints > 0 )
	{
		if ( self.currentGunCyclePoints == level.currentGunCycleMaxPoints )
		{
			scoreevents::processScoreEvent( "most_points_shrp", self );
		}
	}
}

function awardMostPointsMedalGameEnd()
{
	level waittill( "game_end" );
	
	for ( i = 0 ; i < level.players.size ; i++ )
	{
		level.players[i] checkAwardMostPointsThisCycle();
	}
}


function giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	chooseRandomBody = false;
	if ( !isdefined( alreadySpawned ) || !alreadySpawned )
		chooseRandomBody = true;
	self wager::setup_blank_random_player( takeAllWeapons, chooseRandomBody, level.shrpRandomWeapon );
	self DisableWeaponCycling();
	
	self giveWeapon( level.shrpRandomWeapon );
	self switchToWeapon( level.shrpRandomWeapon );
	self giveWeapon( level.weaponBaseMelee );
	
	if ( !isdefined( alreadySpawned ) || !alreadySpawned )
		self setSpawnWeapon( level.shrpRandomWeapon );
	
	if ( isdefined( takeAllWeapons ) && !takeAllWeapons )
		self thread takeOldWeapons();
	else
		self EnableWeaponCycling();
		
	return level.shrpRandomWeapon;
}

function takeOldWeapons()
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
		if ( ( weaponsList[i] != level.shrpRandomWeapon ) && ( weaponsList[i] != level.weaponBaseMelee ) )
			self TakeWeapon( weaponsList[i] );
	}
	
	self EnableWeaponCycling();
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{		
	if ( isdefined( attacker ) && IsPlayer( attacker ) && ( attacker != self ) )
	{		
		// Track Sharpshooter kills
		if ( isdefined( level.sharpshooterMultiplier ) && ( level.sharpshooterMultiplier == 2 ) )
		{
			if ( !isdefined( attacker.pers["x2kills"] ) )
				attacker.pers["x2kills"] = 1;
			else
				attacker.pers["x2kills"]++;
			attacker.x2Kills = attacker.pers["x2kills"];
		}
		else if ( isdefined( level.sharpshooterMultiplier ) && ( level.sharpshooterMultiplier == 3 ) )
		{
			if ( !isdefined( attacker.pers["x3kills"] ) )
				attacker.pers["x3kills"] = 1;
			else
				attacker.pers["x3kills"]++;
			attacker.x2Kills = attacker.pers["x3kills"];
		}
		
		if ( isdefined( self.scoreMultiplier ) && self.scoreMultiplier >= 2 )
		{
			scoreevents::processScoreEvent( "kill_x2_score_shrp", attacker, self, weapon );
		}
		
		// Give next bonus
		currentBonus = attacker.currentBonus;
		if ( !isdefined( currentBonus ) )
			currentBonus = 0;
		if ( currentBonus < level.powerupList.size )
		{
			attacker wager::give_powerup( level.powerupList[currentBonus] );
			attacker thread wager::announcer( "wm_bonus"+currentBonus );
			if ( level.powerupList[currentBonus].type == "score_multiplier" && attacker.scoreMultiplier == 2 ) 
			{
				scoreevents::processScoreEvent( "x2_score_shrp", attacker, self, weapon );
			}
			currentBonus++;
			attacker.currentBonus = currentBonus;
		}
		
		if ( currentBonus >= level.powerupList.size ) // Play FX for kills with max bonus
		{
			if ( isdefined( attacker.powerups ) && isdefined( attacker.powerups.size ) && ( attacker.powerups.size > 0 ) )
			{
				attacker thread wager::pulse_powerup_icon( attacker.powerups.size-1 );
			}
		}
		
		// Give score with multiplier
		scoreMultiplier = 1;
		if ( isdefined( attacker.scoreMultiplier ) )
			scoreMultiplier = attacker.scoreMultiplier;
		
		if ( isdefined( level.sharpshooterMultiplier ) )
			scoreMultiplier *= level.sharpshooterMultiplier;
			
		scoreIncrease = attacker.pointstowin;
		for ( i = 1 ; i <= scoreMultiplier ; i++ )
		{			
			if ( weapon_utils::isMeleeMOD( sMeansOfDeath ) && level.shrpRandomWeapon != level.weaponBaseMelee && level.shrpRandomWeapon.isRiotShield )
			{
				attacker globallogic_score::givePointsToWin( level.pointsPerMeleeKill );
				if ( i != 1 )
				{
					scoreevents::processScoreEvent( "kill", attacker, self, weapon );
					scoreevents::processScoreEvent( "wager_melee_kill", attacker, self, weapon );
				}
			}
			else
			{
				attacker globallogic_score::givePointsToWin( level.pointsPerWeaponKill );
				if ( !isdefined( attacker.currentGunCyclePoints ) )
                {
	                attacker.currentGunCyclePoints = 0;
                }
				attacker.currentGunCyclePoints += level.pointsPerWeaponKill;
				if ( level.currentGunCycleMaxPoints < attacker.currentGunCyclePoints )
				{
					level.currentGunCycleMaxPoints = attacker.currentGunCyclePoints;
				}
				if ( i != 1 )
				{
					scoreevents::processScoreEvent( "kill", attacker, self, weapon );
				}
			}
		}
		scoreIncrease = attacker.pointstowin - scoreIncrease;
		if ( scoreMultiplier > 1 || ( isdefined( level.sharpshooterMultiplier ) && level.sharpshooterMultiplier > 1 ) )
		{
			attacker playLocalSound( "uin_alert_cash_register" );
			attacker.pers["x2score"] += scoreIncrease;
			attacker.x2score = attacker.pers["x2score"];
		}
	}
	
	self.currentBonus = 0;
	self.scoreMultiplier = 1;
	self wager::clear_powerups();
}

function onSpawnPlayerUnified()
{
	spawning::onSpawnPlayer_Unified();
	self thread infiniteAmmo();
}

function onSpawnPlayer(predictedSpawn)
{
	spawnPoints = spawnlogic::get_team_spawnpoints( self.pers["team"] );
	spawnPoint = spawnlogic::get_spawnpoint_dm( spawnPoints );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "shrp" );
		self thread infiniteAmmo();
	}
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
	x2kills = self globallogic_score::getPersStat( "x2kills" );
	if ( !isdefined( x2kills ) )
		x2kills = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", x2kills, 0 );
	
	headshots = self globallogic_score::getPersStat( "headshots" );
	if ( !isdefined( headshots ) )
		headshots = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", headshots, 1 );
	
	bestKillstreak = self globallogic_score::getPersStat( "best_kill_streak" );
	if ( !isdefined( bestKillstreak ) )
		bestKillstreak = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", bestKillstreak, 2 );
}

function clearPowerupsOnGameEnd()
{
	level waittill( "game_ended" );
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		player wager::clear_powerups();
	}
}