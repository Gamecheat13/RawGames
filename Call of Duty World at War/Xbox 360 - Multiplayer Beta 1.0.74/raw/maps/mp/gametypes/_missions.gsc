#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	if ( !mayProcessChallenges() )
		return;
	
	level.missionCallbacks = [];

	precacheString(&"MP_CHALLENGE_COMPLETED");

	registerMissionCallback( "playerKilled", ::ch_kills );	
	registerMissionCallback( "playerKilled", ::ch_vehicle_kills );		
	registerMissionCallback( "playerHardpoint", ::ch_hardpoints );
	registerMissionCallback( "playerAssist", ::ch_assists );
	registerMissionCallback( "roundEnd", ::ch_roundwin );
	registerMissionCallback( "roundEnd", ::ch_roundplayed );
	registerMissionCallback( "playerGib", ::ch_gib );	
	registerMissionCallback( "warHero", ::ch_warHero );	
	registerMissionCallback( "trapper", ::ch_trapper );	
	registerMissionCallback( "youtalkintome", ::ch_youtalkintome );	
	registerMissionCallback( "medic", ::ch_medic );	
	
	level thread onPlayerConnect();
}

mayProcessChallenges()
{
	/#
	if ( getDvarInt( "debug_challenges" ) )
		return true;
	#/
	
	return level.rankedMatch;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player thread initMissionData();
		player thread monitorBombUse();
		player thread monitorSprintDistance();
		player thread monitorDriveDistance();
		player thread monitorFallDistance();
		player thread monitorLiveTime();	
		player thread monitorStreaks();
		player thread monitorPerkUsage();
		player thread monitorGameEnded();
		player thread monitorFlaredOrTabuned();
		player thread monitorDestroyedTank();
		player thread monitorImmobilizedTank();
	}
}

// round based tracking
initMissionData()
{
	self.pers["radar_mp"] = 0;
	self.pers["artillery_mp"] = 0;
	self.pers["dogs_mp"] = 0;
	self.pers["kamikaze_mp"] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["bulletStreak"] = 0;
	self.explosiveInfo = [];
}

registerMissionCallback(callback, func)
{
	if (!isdefined(level.missionCallbacks[callback]))
		level.missionCallbacks[callback] = [];
	level.missionCallbacks[callback][level.missionCallbacks[callback].size] = func;
}


getChallengeStatus( name )
{
//	return self getStat( int(tableLookup( statsTable, 7, name, 2 )) ); // too slow, instead we store the challenge status at the beginning of the game
	if ( isDefined( self.challengeData[name] ) )
		return self.challengeData[name];
	else
		return 0;
}

getChallengeLevels( baseName )
{
	if ( isDefined( level.challengeInfo[baseName] ) )
		return level.challengeInfo[baseName]["levels"];
		
	assertex( isDefined( level.challengeInfo[baseName + "1" ] ), "Challenge name " + baseName + " not found!" );
	if (!isDefined (level.challengeInfo[baseName + "1" ] ) )
		return -1;
	
	return level.challengeInfo[baseName + "1"]["levels"];
}

isStrStart( string1, subStr )
{
	return ( getSubStr( string1, 0, subStr.size ) == subStr );
}

processChallenge( baseName, progressInc )
{
	if ( !mayProcessChallenges() )
		return;
	
	numLevels = getChallengeLevels( baseName );
	
	if ( numLevels < 0 ) 
		return;
		
	if ( numLevels > 1 )
		missionStatus = self getChallengeStatus( (baseName + "1") );
	else
		missionStatus = self getChallengeStatus( baseName );

	if ( !isDefined( progressInc ) )
		progressInc = 1;
	
	/#
	if ( getDvarInt( "debug_challenges" ) )
		println( "CHALLENGE PROGRESS - " + baseName + ": " + progressInc );
	#/
	
	if ( progressInc == 1 ) 
	{
		if ( numLevels > 1 && basename.size > 3 )
		{
			newLength = basename.size - 1;
			persRefString = getSubStr( baseName, 0, newLength );
		}
		else
		{
			persRefString = baseName;
		}	
		
		persRefString = "pers_" + persRefString;
	
		self setStatLBByName( persRefString, progressInc );
	}
	
	if ( !missionStatus || missionStatus == 255 )
		return;
		
	assertex( missionStatus <= numLevels, "Mini challenge levels higher than max: " + missionStatus + " vs. " + numLevels );
	
	if ( numLevels > 1 )
		refString = baseName + missionStatus;
	else
		refString = baseName;
		
	progress = self getStat( level.challengeInfo[refString]["statid"] );

	/*
	if ( isStrStart( refString, "ch_marksman_" ) || isStrStart( refString, "ch_expert_" ) )
		progressInc = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	*/
	
	progress += progressInc;
	
	self setStat( level.challengeInfo[refString]["statid"], progress );

	if ( progress >= level.challengeInfo[refString]["maxval"] )
	{
		self thread challengeNotify( level.challengeInfo[refString]["name"], level.challengeInfo[refString]["desc"] );

		if ( level.challengeInfo[refString]["camo"] != "" )
			self maps\mp\gametypes\_rank::unlockCamo( level.challengeInfo[refString]["camo"] );

		if ( level.challengeInfo[refString]["attachment"] != "" )
			self maps\mp\gametypes\_rank::unlockAttachment( level.challengeInfo[refString]["attachment"] );

		self setStatLBByName( level.challengeInfo[refString]["fullname"], 1 );
		
		if ( missionStatus == numLevels )
		{
			missionStatus = 255;
			self maps\mp\gametypes\_globallogic::incPersStat( "challenges", 1 );
		}
		else
			missionStatus += 1;

		if ( numLevels > 1 )
			self.challengeData[baseName + "1"] = missionStatus;
		else
			self.challengeData[baseName] = missionStatus;

		// prevent bars from running over
		self setStat( level.challengeInfo[refString]["statid"], level.challengeInfo[refString]["maxval"] );

		self setStat( level.challengeInfo[refString]["stateid"], missionStatus );
		self maps\mp\gametypes\_rank::giveRankXP( "challenge", level.challengeInfo[refString]["reward"] );
		
	}
}


// check if all challenges in a tier are completed
// Don't know what this does - looks like it was never called anywhere
// DRoche - MGordon
tierCheck( tierID )
{
	challengeNames = getArrayKeys( level.challengeInfo );
	for ( index = 0; index < challengeNames.size; index++ )
	{
		challengeInfo = level.challengeInfo[challengeNames[index]];

		if ( challengeInfo["tier"] != tierID )
			continue;
			
		// multi level
		if ( challengeInfo["level"] > 1 )
			continue;
		
		// undefined means it's locked
		if ( !isDefined( self.challengeData[challengeNames[index]] ) )
			return false;
		
		// 255 means it's not completed
		if ( self.challengeData[challengeNames[index]] != 255 )
			return false;
	}

	return true;
}

// Again - we can tidy this up by removing the description
// DRoche + MGordon
challengeNotify( challengeName, challengeDesc )
{
	notifyData = spawnStruct();
	notifyData.titleText = &"MP_CHALLENGE_COMPLETED";
	notifyData.notifyText = challengeName;
//	notifyData.notifyText2 = challengeDesc;
	notifyData.sound = "mp_challenge_complete";
	
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}


ch_assists( data )
{
	player = data.player;
	player processChallenge( "ch_assists_" );
}


ch_hardpoints( data )
{
	player = data.player;
	player.pers[data.hardpointType]++;

	if ( data.hardpointType == "radar_mp" )
	{
// UAV doesn't seem to be used anymore
// DRoche + MGordon
		player processChallenge( "ch_uav" );
		player processChallenge( "ch_exposed_" );

		if ( player.pers[data.hardpointType] >= 3 )
			player processChallenge( "ch_nosecrets" );
	}
	else if ( data.hardpointType == "artillery_mp" )
	{
//Diarmaid cannot spell artillery		
		player processChallenge( "ch_artillary" );

//Diarmaid still cannot spell artillery		
		if ( player.pers[data.hardpointType] >= 2 )
			player processChallenge( "ch_heavyartillary" );
	}
	else if ( data.hardpointType == "dogs_mp" )	
	{
		player processChallenge( "ch_dogs" );

		if ( player.pers[data.hardpointType] >= 2 )
			player processChallenge( "ch_rabid" );
	}
	else if ( data.hardpointType == "kamikaze_mp" )	
	{
//		player processChallenge( "ch_chopper" );
//
//		if ( player.pers[data.hardpointType] >= 2 )
//			player processChallenge( "ch_airsuperiority" );
	}
}


ch_vehicle_kills( data )
{
	if ( !isDefined( data.attacker ) || !isPlayer( data.attacker ) )
		return;

	player = data.attacker;
	
	// this isdefined check should not be needed... find out where these mystery explosions are coming from
	if ( isDefined( data.sWeapon ) && data.sWeapon == "artillery_mp" )
	{
//Diarmaid still cannot spell Artillery
		player processChallenge( "ch_artillaryvet_" );
		
//Diarmaid still cannot spell Artillery again		
		if( !isDefined( player.pers["artillaryStreak"] ) )
			player.pers["artillaryStreak"] = 0;
		
//Diarmaid still cannot spell Artillery FFS
			player.pers["artillaryStreak"]++;
//		if ( player.pers["artillaryStreak"] >= 5 )
//			player processChallenge( "ch_majorstrike" );
	}
}	


clearIDShortly( expId )
{
	self endon ( "disconnect" );
	
	self notify( "clearing_expID_" + expID );
	self endon ( "clearing_expID_" + expID );
	
	wait ( 3.0 );
	self.explosiveKills[expId] = undefined;
}

killedBestEnemyPlayer()
{
	if ( !isdefined( self.pers["countermvp_streak"] ) )
		self.pers["countermvp_streak"] = 0;
	
	self.pers["countermvp_streak"]++;
	
	if ( self.pers["countermvp_streak"] >= 10 )
		self processChallenge( "ch_countermvp" );
}


isHighestScoringPlayer( player )
{
	if ( !isDefined( player.score ) || player.score < 1 )
		return false;

	players = level.players;
	if ( level.teamBased )
		team = player.pers["team"];
	else
		team = "all";

	highScore = player.score;

	for( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;

		if ( team != "all" && players[i].pers["team"] != team )
			continue;
		
		if ( players[i].score > highScore )
			return false;
	}
	
	return true;
}


getWeaponClass( weapon )
{
	tokens = strTok( weapon, "_" );
	weaponClass = tablelookup( "mp/statstable.csv", 4, tokens[0], 2 );
// This needs to be removed - it no longer exists
// DRoche + MGordon
//	if ( isMG( weapon ) )
//		weaponClass = "weapon_mg";
	return weaponClass;
}

ch_kills( data, time )
{
	data.victim playerDied();


	if ( !isDefined( data.attacker ) || !isPlayer( data.attacker ) )
		return;
	
	player = data.attacker;
	
	if ( isDefined( data.eInflictor ) && isDefined( level.chopper ) && data.eInflictor == level.chopper )
		return;
	if ( data.sWeapon == "artillery_mp" )
		return;
	
	time = data.time;
	
	if ( player isAtBrinkOfDeath() )
	{
		player.brinkOfDeathKillStreak++;
		if ( player.brinkOfDeathKillStreak >= 3 )
		{
			player processChallenge( "ch_thebrink" );
		}
	}
	
	if ( player.cur_kill_streak == 10 )
		player processChallenge( "ch_fearless" );
	
	if ( player isFlared() )
	{
		if ( player hasPerk ("specialty_shades") ) 
		{
			if ( isdefined( player.lastFlaredby ) && data.victim == player.lastFlaredby )
			player processChallenge( "ch_shades" );
		}
		else
		{
			player processChallenge( "ch_blindfire" );
		}
	}
	
	if ( player isPoisoned() )
	{
		if ( player hasPerk ("specialty_gas_mask") ) 
		{
			if ( isdefined( player.lastPoisonedBy ) &&  data.victim == player.lastPoisonedBy )
			player processChallenge( "ch_gasmask" );
		}
		else
		{
			player processChallenge( "ch_slowbutsure" );
		}
	}
	
	if ( player isInSecondChance() )
		player processChallenge( "ch_downnotout_" );
		
	if ( level.teamBased )
	{
		if ( level.playerCount[data.victim.pers["team"]] > 3 && player.pers["killed_players"].size >= level.playerCount[data.victim.pers["team"]] )
			player processChallenge( "ch_tangodown" );
	
		if ( level.playerCount[data.victim.pers["team"]] > 3 && player.killedPlayersCurrent.size >= level.playerCount[data.victim.pers["team"]] )
			player processChallenge( "ch_extremecruelty" );
	}

	if ( player.pers["killed_players"][data.victim.name] == 5 )
		player processChallenge( "ch_rival" );

	if ( isdefined( player.tookWeaponFrom[ data.sWeapon ] ) )
	{
		if ( player.tookWeaponFrom[ data.sWeapon ] == data.victim && data.sMeansOfDeath != "MOD_MELEE" )
			player processChallenge( "ch_cruelty" );
	}
	
	if ( data.victim.score > 0 )
	{
		if ( level.teambased )
		{
			victimteam = data.victim.pers["team"];
			if ( isdefined( victimteam ) && victimteam != player.pers["team"] )
			{
				if ( isHighestScoringPlayer( data.victim ) && level.players.size >= 6 )
					player killedBestEnemyPlayer();
			}
		}
		else
		{
			if ( isHighestScoringPlayer( data.victim ) && level.players.size >= 4 )
			{
				player killedBestEnemyPlayer();
			}
		}
	}

	if ( data.sWeapon == "dog_bite_mp" )
		data.sMeansOfDeath = "MOD_DOGS";
	else if ( data.sWeapon == "artillery_mp" )
		data.sMeansOfDeath = "MOD_ARTILLERY";
		
	
	if ( !isdefined(data.victim.diedOnVehicle) && isdefined(data.victim.diedOnTurret))
		player processChallenge( "ch_turrethunter_" );	
	
	// vehicle challenges
	if ( isStrStart( data.sWeapon, "panzer") || isStrStart( data.sWeapon, "t34") )
	{
		if ( data.sMeansOfDeath == "MOD_CRUSH" )
		{
			if (isStrStart( data.sWeapon, "panzer"))
			{
				player setStatLBByName( "panzer", 1, "Road Kills With");
				data.victim setStatLBByName( "panzer", 1, "Road Kills By");
			}
			else if ( isStrStart( data.sWeapon, "t34") ) 
			{
				player setStatLBByName( "t34", 1, "Road Kills With");
				data.victim setStatLBByName( "t34", 1, "Road Kills By");
			}
		}
		else if ( isSubStr ( data.sWeapon, "_gunner_mp" ) )
			player processChallenge( "ch_expert_gunner_" );
		else if ( data.sWeapon == "sherman_gunner_mp_FLM" ) // This doesn't exist anymore DRoche
			player processChallenge( "ch_expert_turret_flame_" ); // This doesn't exist anymore Droche
		else if ( isSubStr ( data.sWeapon, "_turret_mp" ) )
			player processChallenge( "ch_behemouth_" );
		else if ( ( data.sWeapon == "panzer4_mp_explosion_mp" || data.sWeapon == "t34_mp_explosion_mp" ) && !isdefined(data.victim.diedOnVehicle) )
			player processChallenge( "ch_tankbomb" );
			
		if ( isDefined( data.victim.explosiveInfo["damageTime"] ) && data.victim.explosiveInfo["damageTime"] == time )
		{	
			expId = time + "_" + data.victim.explosiveInfo["damageId"];
			if ( !isDefined( player.explosiveKills[expId] ) )
			{
				player.explosiveKills[expId] = 0;
			}
			player thread clearIDShortly( expId );
			
			player.explosiveKills[expId]++;
			
// This would be a good stat like a killstreak - DRoche + MGordon
			if ( player.explosiveKills[expId] > 2 )
				player processChallenge( "ch_gotem" );
		}
	}
	else if ( data.sMeansOfDeath == "MOD_PISTOL_BULLET" || data.sMeansOfDeath == "MOD_RIFLE_BULLET" )
	{
		weaponClass = getWeaponClass( data.sWeapon );
		ch_bulletDamageCommon( data, player, time, weaponClass );
		
		clipCount = player GetWeaponAmmoClip( data.sWeapon );

// This challenge holds less value now that we have shotguns - DRoche + MGordon		
		if ( clipCount == 0 )
			player processChallenge( "ch_desperado" );

		if ( weaponClass == "weapon_pistol" )
			player processChallenge( "ch_marksman_pistol_" );
		
		if ( isSubStr( data.sWeapon, "silenced_mp" ) )
			player processChallenge( "ch_supressor_" );			
		else if ( isSubStr( data.sWeapon, "flash_mp" ) )
			player processChallenge( "ch_invisible_" );		

// Let's have this with a table-lookup in future - DRoche + MGordon		
//assault			
		if ( isStrStart( data.sWeapon, "gewehr43_" ) )
			player processChallenge( "ch_marksman_g43_" );
		else if ( isStrStart( data.sWeapon, "svt40_" ) )
			player processChallenge( "ch_marksman_svt40_" );
		else if ( isStrStart( data.sWeapon, "m1garand_" ) )
			player processChallenge( "ch_marksman_m1garand_" );
		else if ( isStrStart( data.sWeapon, "m1carbine_" ) )
			player processChallenge( "ch_marksman_m1a1_" );
		else if ( isStrStart( data.sWeapon, "stg44_" ) )
			player processChallenge( "ch_marksman_stg44_" );
//smg			
		else if ( isStrStart( data.sWeapon, "thompson_" ) )
			player processChallenge( "ch_marksman_thompson_" );
		else if ( isStrStart( data.sWeapon, "type100smg_" ) )
			player processChallenge( "ch_marksman_type100smg_" );
		else if ( isStrStart( data.sWeapon, "mp40_" ) )
			player processChallenge( "ch_marksman_mp40_" );
		else if ( isStrStart( data.sWeapon, "ppsh_" ) )
			player processChallenge( "ch_marksman_ppsh_" );
//lmg			
		else if ( isStrStart( data.sWeapon, "type99lmg_" ) || isStrStart( data.sWeapon, "type99_lmg_" ) )
			player processChallenge( "ch_marksman_type99lmg_" );
		else if ( isStrStart( data.sWeapon, "fg42_" ) )
			player processChallenge( "ch_marksman_fg42_" );
		else if ( isStrStart( data.sWeapon, "30cal_" ) )
			player processChallenge( "ch_marksman_30cal" );
		else if ( isStrStart( data.sWeapon, "mg42_" ) )
			player processChallenge( "ch_marksman_mg42" );
		else if ( isStrStart( data.sWeapon, "dp28_" ) )
			player processChallenge( "ch_marksman_dp28" );
		else if ( isStrStart( data.sWeapon, "bar_" ) )
			player processChallenge( "ch_marksman_bar" );
//shotgun
		else if ( isStrStart( data.sWeapon, "shotgun" ) )
			player processChallenge( "ch_marksman_shotgun_" );
		else if ( isStrStart( data.sWeapon, "doublebarreledshotgun" ) )
			player processChallenge( "ch_marksman_dbshotty_" );
//bold action rifles
		else if ( isStrStart( data.sWeapon, "mosinrifle_" ) )
			player processChallenge( "ch_marksman_mosinrifle_" );
		else if ( isStrStart( data.sWeapon, "springfield_" ) )
			player processChallenge( "ch_marksman_springfield_" );
		else if ( isStrStart( data.sWeapon, "kar98k_" ) )
			player processChallenge( "ch_marksman_kar98k_" );
		else if ( isStrStart( data.sWeapon, "type99rifle_" ) )
			player processChallenge( "ch_marksman_type99rifle_" );
	}
	else if ( isSubStr( data.sMeansOfDeath, "MOD_GRENADE" ) || isSubStr( data.sMeansOfDeath, "MOD_EXPLOSIVE" ) || isSubStr( data.sMeansOfDeath, "MOD_PROJECTILE" ) )
	{
		if ( isStrStart( data.sWeapon, "molotov_" ) || isStrStart( data.sWeapon, "napalmblob_" ) )
			player processChallenge( "ch_bartender_" );
		else if ( isStrStart( data.sWeapon, "frag_grenade_short_" ) )
			player processChallenge( "ch_martyrdom_" );
		else if ( isSubStr( data.sWeapon, "gl_" ) )
			player processChallenge( "ch_launchspecialist_" );

		// this isdefined check should not be needed... find out where these mystery explosions are coming from
		if ( isDefined( data.victim.explosiveInfo["damageTime"] ) && data.victim.explosiveInfo["damageTime"] == time )
		{
			if ( data.sWeapon == "none" )
				data.sWeapon = data.victim.explosiveInfo["weapon"];
			
			expId = time + "_" + data.victim.explosiveInfo["damageId"];
			if ( !isDefined( player.explosiveKills[expId] ) )
			{
				player.explosiveKills[expId] = 0;
			}
			player thread clearIDShortly( expId );
			
			player.explosiveKills[expId]++;
			
			if ( isStrStart( data.sWeapon, "frag_" ) || isStrStart( data.sWeapon, "sticky_" ))
			{
				if ( player.explosiveKills[expId] > 1 )
				{	
					player processChallenge( "ch_multifrag" );
					if ( isdefined( data.victim.explosiveInfo["stuckToPlayer"] ) && data.victim.explosiveInfo["stuckToPlayer"] ) 
						player processChallenge( "ch_specialdelivery" );
				}
				
				if ( isStrStart( data.sWeapon, "frag_" ) )
				{
					player processChallenge( "ch_grenadekill_" );
						if ( data.victim.explosiveInfo["throwbackKill"] )
							player processChallenge( "ch_hotpotato_" );
				}							
				else 
					player processChallenge( "ch_stickykill_" );
				
				if ( data.victim.explosiveInfo["cookedKill"] )
					player processChallenge( "ch_masterchef_" );
				
				if ( data.victim.explosiveInfo["suicideGrenadeKill"] )
					player processChallenge( "ch_miserylovescompany_" );
			}
			else if ( isStrStart( data.sWeapon, "satchel_" ) )
			{
				player processChallenge( "ch_satchel_" );

				if ( player.explosiveKills[expId] > 1 )
					player processChallenge( "ch_multimine" );

				if ( data.victim.explosiveInfo["returnToSender"] )
					player processChallenge( "ch_returntosender" );				
				
				if ( data.victim.explosiveInfo["counterKill"] )
					player processChallenge( "ch_countersatchel_" );
				
				if ( data.victim.explosiveInfo["bulletPenetrationKill"] )
					player processChallenge( "ch_howthe" );

				if ( data.victim.explosiveInfo["chainKill"] )
					player processChallenge( "ch_dominos" );
			}
			else if ( isStrStart( data.sWeapon, "mine_bouncing_betty_mp" ) )
			{
// should be Bouncing Betty - DRoche + MGordon
				player processChallenge( "ch_shoebox_" );

				if ( player.explosiveKills[expId] > 1 )
					player processChallenge( "ch_multimine" );

				if ( data.victim.explosiveInfo["returnToSender"] )
					player processChallenge( "ch_returntosender" );				

				if ( data.victim.explosiveInfo["counterKill"] )
					player processChallenge( "ch_countershoebox_" );
				
				if ( data.victim.explosiveInfo["bulletPenetrationKill"] )
					player processChallenge( "ch_howthe" );

				if ( data.victim.explosiveInfo["chainKill"] )
					player processChallenge( "ch_dominos" );
					
				if ( data.victim.explosiveInfo["ohnoyoudontKill"] )
					player processChallenge( "ch_ohnoyoudont" );
			}
			else if ( data.sWeapon == "explodable_barrel" )
			{
				player processChallenge( "ch_barrelbomb_" );
			}
			else if ( data.sWeapon == "destructible_car" )
			{
				player processChallenge( "ch_carbomb_" );
			}
//			else if ( isStrStart( data.sWeapon, "bazooka_" ) )
//			{
//				if ( player.explosiveKills[expId] > 1 )
//					player processChallenge( "ch_multirpg" );
//			}
		}
	}
	else if ( isStrStart( data.sMeansOfDeath, "MOD_MELEE" ) || isStrStart( data.sMeansOfDeath, "MOD_BAYONET" ) )
	{
		if ( isStrStart( data.sMeansOfDeath, "MOD_BAYONET" ) )
			player processChallenge( "ch_bayonet_" );
		else	
			player processChallenge( "ch_knifevet_" );
				
		vAngles = data.victim.anglesOnDeath[1];
		pAngles = player.anglesOnKill[1];
		angleDiff = AngleClamp180( vAngles - pAngles );
		if ( abs(angleDiff) < 30 )
			player processChallenge( "ch_backstabber" );
	}
	else if ( isSubStr( data.sMeansOfDeath,	"MOD_BURNED" ) )
	{
		if ( isStrStart( data.sWeapon, "molotov_" ) || isStrStart( data.sWeapon, "napalmblob_" ) )
			player processChallenge( "ch_bartender_" );
		if ( isStrStart( data.sWeapon, "m2_flamethrower_" ) )
			player processChallenge( "ch_pyro_" );
	}
	else if ( isSubStr( data.sMeansOfDeath,	"MOD_IMPACT" ) )
	{
		if ( isStrStart( data.sWeapon, "frag_" ) )
			player processChallenge( "ch_thinkfast" );
		else if ( isSubStr( data.sWeapon, "gl_" ) )
			player processChallenge( "ch_launchspecialist_" );
		else if ( isStrStart( data.sWeapon, "molotov_" ) || isStrStart( data.sWeapon, "napalmblob_" ) )
			player processChallenge( "ch_bartender_" );
		else if ( isStrStart( data.sWeapon, "tabun_" ) || isStrStart( data.sWeapon, "signal_" ) )
			player processChallenge( "ch_thinkfastspecial" );
	}
	else if ( data.sMeansOfDeath == "MOD_HEAD_SHOT" )
	{
		weaponClass = getWeaponClass( data.sWeapon );
		
		ch_bulletDamageCommon( data, player, time, weaponClass );
	
		switch ( weaponClass )
		{
			case "weapon_smg":
				player processChallenge( "ch_expert_smg_" );
				break;
			case "weapon_lmg":
				player processChallenge( "ch_expert_lmg_" );
				break;
			case "weapon_hmg":
				player processChallenge( "ch_expert_hmg_" );
				break;
			case "weapon_assault":
				player processChallenge( "ch_expert_assault_" );
				break;
			case "weapon_sniper":
				player processChallenge( "ch_expert_boltaction_" );
				break;
			case "weapon_pistol":
				player processChallenge( "ch_expert_pistol_" );
				player processChallenge( "ch_marksman_pistol_" );
				
				break;
		}

		clipCount = player GetWeaponAmmoClip( data.sWeapon );
		

// Combine this with the calls above to simplify the code - DRoche + MGordon
		if ( clipCount == 0 )
			player processChallenge( "ch_desperado" );
			
		if ( isSubStr( data.sWeapon, "silenced_mp" ) )
			player processChallenge( "ch_supressor_" );			
		else if ( isSubStr( data.sWeapon, "flash_mp" ) )
			player processChallenge( "ch_invisible_" );		
		
/// Assault
		if ( isStrStart( data.sWeapon, "gewehr43_" ) )
		{
			player processChallenge( "ch_expert_g43_" );
			player processChallenge( "ch_marksman_g43_" );
		}
		else if ( isStrStart( data.sWeapon, "svt40_" ) )
		{
			player processChallenge( "ch_expert_svt40_" );
			player processChallenge( "ch_marksman_svt40_" );
		}
		else if ( isStrStart( data.sWeapon, "m1garand_" ) )
		{
			player processChallenge( "ch_expert_m1garand_" );
			player processChallenge( "ch_marksman_m1garand_" );
		}
		else if ( isStrStart( data.sWeapon, "stg44_" ) )
		{
			player processChallenge( "ch_expert_stg44_" );
			player processChallenge( "ch_marksman_stg44_" );
		}
		else if ( isStrStart( data.sWeapon, "m1carbine_" ) )
		{
			player processChallenge( "ch_expert_m1a1_" );
			player processChallenge( "ch_marksman_m1a1_" );
		}
/// SMG
		else if ( isStrStart( data.sWeapon, "thompson_" ) )
		{
			player processChallenge( "ch_expert_thompson_" );
			player processChallenge( "ch_marksman_thompson_" );
		}
		else if ( isStrStart( data.sWeapon, "type100smg_" ) )
		{
			player processChallenge( "ch_expert_type100smg_" );
			player processChallenge( "ch_marksman_type100smg_" );
		}
		else if ( isStrStart( data.sWeapon, "mp40_" ) )
		{
			player processChallenge( "ch_expert_mp40_" );
			player processChallenge( "ch_marksman_mp40_" );
		}
		else if ( isStrStart( data.sWeapon, "ppsh_" ) )
		{
			player processChallenge( "ch_expert_ppsh_" );
			player processChallenge( "ch_marksman_ppsh_" );
		}
//LMGS
		else if ( isStrStart( data.sWeapon, "type99lmg_" )  || isStrStart( data.sWeapon, "type99_lmg_" ) )
		{
			player processChallenge( "ch_expert_type99lmg_" );
			player processChallenge( "ch_marksman_type99lmg_" );
		}
		else if ( isStrStart( data.sWeapon, "fg42_" ) )
		{
			player processChallenge( "ch_expert_fg42_" );
			player processChallenge( "ch_marksman_fg42_" );
		}
		else if ( isStrStart( data.sWeapon, "dp28_" ) )
		{
			player processChallenge( "ch_expert_dp28_" );
			player processChallenge( "ch_marksman_dp28" );
		}
		else if ( isStrStart( data.sWeapon, "bar_" ) )
		{
			player processChallenge( "ch_expert_bar_" );
			player processChallenge( "ch_marksman_bar" );
		}
//HMGS
		else if ( isStrStart( data.sWeapon, "30cal_" ) )
		{
			player processChallenge( "ch_expert_30cal_" );
			player processChallenge( "ch_marksman_30cal" );
		}
		else if ( isStrStart( data.sWeapon, "mg42_" ) )
		{
			player processChallenge( "ch_expert_mg42_" );
			player processChallenge( "ch_marksman_mg42" );
		}
//SHOTGUNS	
		else if ( isStrStart( data.sWeapon, "shotgun" ) )
		{
			player processChallenge( "ch_expert_shotgun_" );
			player processChallenge( "ch_marksman_shotgun_" );
		}
		else if ( isStrStart( data.sWeapon, "doublebarreledshotgun" ) )
		{
			player processChallenge( "ch_expert_dbshotty_" );
			player processChallenge( "ch_marksman_dbshotty_" );
		}
// bolt action rifles		
		else if ( isStrStart( data.sWeapon, "kar98k_" ) )
		{
			player processChallenge( "ch_expert_kar98k_" );
			player processChallenge( "ch_marksman_kar98k_" );
		}
		else if ( isStrStart( data.sWeapon, "mosinrifle_" ) )
		{
			player processChallenge( "ch_expert_mosinrifle_" );
			player processChallenge( "ch_marksman_mosinrifle_" );
		}
		else if ( isStrStart( data.sWeapon, "springfield_" ) )
		{
			player processChallenge( "ch_expert_springfield_" );
			player processChallenge( "ch_marksman_springfield_" );
		}
		else if ( isStrStart( data.sWeapon, "ptrs41_" ) )
		{
			player processChallenge( "ch_expert_ptrs41_" );
		}
		else if ( isStrStart( data.sWeapon, "type99rifle_" ) )
		{
			player processChallenge( "ch_expert_type99rifle_" );
			player processChallenge( "ch_marksman_type99rifle_" );
		}		
	}
	
	if ( data.sWeapon == "dog_bite_mp" )
	{
		player processChallenge( "ch_dogvet_" );
	}
	if ( isDefined( data.victim.isPlanting ) && data.victim.isPlanting )
		player processChallenge( "ch_bombplanter" );		

	if ( isDefined( data.victim.isDefusing ) && data.victim.isDefusing )
		player processChallenge( "ch_bombdefender" );

	if ( isDefined( data.victim.isBombCarrier ) && data.victim.isBombCarrier )
		player processChallenge( "ch_bombdown" );
}


// This is not really Bullet Damage but a Bullet Kill - DRoche + MGordon
ch_bulletDamageCommon( data, player, time, weaponClass )
{	
	if ( player.pers["lastBulletKillTime"] == time )
		player.pers["bulletStreak"]++;
	else
		player.pers["bulletStreak"] = 1;
	
	player.pers["lastBulletKillTime"] = time;

	if ( ( !data.victimOnGround ) )
		player processChallenge( "ch_hardlanding" );
	
	assert( data.attacker == player );
	if ( !data.attackerOnGround )
		player.pers["midairStreak"]++;
	
	if ( player.pers["midairStreak"] == 2 )
		player processChallenge( "ch_airborne" );

	if ( player.pers["bulletStreak"] == 2 && weaponClass == "weapon_sniper" )
		player processChallenge( "ch_collateraldamage" );
	
	if ( weaponClass == "weapon_pistol" )
	{
		if ( isdefined( data.victim.attackerData ) && isdefined( data.victim.attackerData[player.clientid] ) )
		{
			if ( data.victim.attackerData[player.clientid] )
				player processChallenge( "ch_fastswap" );
		}
	}
	
	if ( data.victim.iDFlagsTime == time )
	{
		if ( data.victim.iDFlags & level.iDFLAGS_PENETRATION )
			player processChallenge( "ch_xrayvision_" ); 
	}
	
	// This looks fishy ch_downnotout_ is possibly processed twice - DRoche + MGordon
	if ( data.attackerInLastStand )
	{
		player processChallenge( "ch_downnotout_" );
	}
	else if ( data.attackerStance == "crouch" )
	{
		player processChallenge( "ch_crouchshot_" );
	}
	else if ( data.attackerStance == "prone" )
	{
		player processChallenge( "ch_proneshot_" );

	}
// This is CoD4 and can be removed - DRoche + MGordon	
	if ( isSubStr( data.sWeapon, "_silencer_" ) )
		player processChallenge( "ch_stealth_" ); 
}

ch_roundplayed( data )
{
	player = data.player;
	
	if ( isdefined( level.lastLegitimateAttacker ) && player == level.lastLegitimateAttacker )
		player processChallenge( "ch_theedge_" );
	
	if ( player.wasAliveAtMatchStart )
	{
		deaths = player.pers[ "deaths" ];
		kills = player.pers[ "kills" ];

		kdratio = 1000000;
		if ( deaths > 0 )
			kdratio = kills / deaths;
		
		if ( kdratio >= 5.0 && kills >= 5.0 )
		{
			player processChallenge( "ch_starplayer" );
		}
		
		if ( deaths == 0 && maps\mp\gametypes\_globallogic::getTimePassed() > 5 * 60 * 1000 )
			player processChallenge( "ch_flawless" );
		
		
		if ( player.score > 0 )
		{
			switch ( level.gameType )
			{
				case "dm": 
					if ( ( data.place < 4 ) && ( level.placement["all"].size > 3 ) && ( game["dialog"]["gametype"] == "freeforall" ) ) 
						player processChallenge( "ch_victor_ffa_" );
					break;
			}
		}
	}
}


ch_roundwin( data )
{
	if ( !data.player.wasAliveAtMatchStart )
	{
		return;
	}
	
	player = data.player;
	
// Would have been nice to record hardcore modes in here separately
	
	if ( isdefined( data.tie ) )
	{
		if ( data.tie )
		{
			player setStatLBByName( level.gameType, 1, "ties" );
			player setStatLBByName( getdvar( "mapname" ), 1, "ties" );
			return;
		}
	}
	
	if (IsDefined(data.winner))
	{
		if ( !data.winner )
		{
			player setStatLBByName( level.gameType, 1, "losses" );
			player setStatLBByName( getdvar( "mapname" ), 1, "losses" );
			return;
		}
	}
	else
	{
		return;
	}
	
	
	if ( player.wasAliveAtMatchStart )
	{
		player setStatLBByName( level.gameType, 1, "wins" );
		player setStatLBByName( getdvar( "mapname" ), 1, "wins" );
		print(level.gameType);
		switch ( level.gameType )
		{
			case "tdm":
				{
					if ( level.hardcoreMode )
					{  
						player processChallenge( "ch_teamplayer_hc_" );
						if ( data.place == 0 )
							player processChallenge( "ch_mvp_thc" );
					}
					else
					{
						player processChallenge( "ch_teamplayer_" );
						if ( data.place == 0 )
							player processChallenge( "ch_mvp_tdm" );
					}
				}
				break;
			case "sab":
				player processChallenge( "ch_victor_sab_" );
				break;
			case "sd":
				player processChallenge( "ch_victor_sd_" );
				break;
			case "ctf":
				player processChallenge( "ch_victor_ctf_" );
				break;
			case "dom":
				player processChallenge( "ch_victor_dom_" );
				break;
			case "twar":
				{
					player processChallenge( "ch_victor_war_" );
				}
				break;
			case "koth":
			case "hq":
				player processChallenge( "ch_victor_hq_" );
				break;
			default:
				break;
		}
	}
}

/*
char *modNames[MOD_NUM] =
{
	"MOD_UNKNOWN",
	"MOD_PISTOL_BULLET",
	"MOD_RIFLE_BULLET",
	"MOD_GRENADE",
	"MOD_GRENADE_SPLASH",
	"MOD_PROJECTILE",
	"MOD_PROJECTILE_SPLASH",
	"MOD_MELEE",
	"MOD_HEAD_SHOT",
	"MOD_CRUSH",
	"MOD_TELEFRAG",
	"MOD_FALLING",
	"MOD_SUICIDE",
	"MOD_TRIGGER_HURT",
	"MOD_EXPLOSIVE",
	"MOD_IMPACT",
};

static const char *g_HitLocNames[] =
{
	"none",
	"helmet",
	"head",
	"neck",
	"torso_upper",
	"torso_lower",
	"right_arm_upper",
	"left_arm_upper",
	"right_arm_lower",
	"left_arm_lower",
	"right_hand",
	"left_hand",
	"right_leg_upper",
	"left_leg_upper",
	"right_leg_lower",
	"left_leg_lower",
	"right_foot",
	"left_foot",
	"gun",
};

*/

// ==========================================
// Callback functions

playerDamaged( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	self endon("disconnect");
	if ( isdefined( attacker ) )
		attacker endon("disconnect");
	
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();

	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;
	
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerInLastStand = isDefined( data.attacker.lastStand );
		data.attackerOnGround = data.attacker isOnGround();
		data.attackerStance = data.attacker getStance();
	}
	else
	{
		data.attackerInLastStand = false;
		data.attackerOnGround = false;
		data.attackerStance = "stand";
	}
	
	doMissionCallback("playerDamaged", data);
}

playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	print(level.gameType);
	self.anglesOnDeath = self getPlayerAngles();
	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();
	
	self endon("disconnect");

	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;
	data.time = gettime();
	
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerInLastStand = isDefined( data.attacker.lastStand );
		data.attackerOnGround = data.attacker isOnGround();
		data.attackerStance = data.attacker getStance();
	}
	else
	{
		data.attackerInLastStand = false;
		data.attackerOnGround = false;
		data.attackerStance = "stand";
	}
	
	waitAndProcessPlayerKilledCallback( data );
	
	data.attacker notify( "playerKilledChallengesProcessed" );
}

waitAndProcessPlayerKilledCallback( data )
{
	if ( isdefined( data.attacker ) )
		data.attacker endon("disconnect");
	
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();
	
	doMissionCallback( "playerKilled", data );
}

playerAssist()
{
	data = spawnstruct();

	data.player = self;

	doMissionCallback( "playerAssist", data );
}


useHardpoint( hardpointType )
{
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();
	
	data = spawnstruct();

	data.player = self;
	data.hardpointType = hardpointType;

	doMissionCallback( "playerHardpoint", data );
}


roundBegin()
{
	doMissionCallback( "roundBegin" );
}

roundEnd( winner )
{
	data = spawnstruct();
	
	if ( level.teamBased )
	{
		team = "allies";
		for ( index = 0; index < level.placement[team].size; index++ )
		{
			data.player = level.placement[team][index];
			data.winner = (team == winner);
			data.place = index;
// Should this "roundend" signify a tie ? MGordon
			data.tie = ( ( winner == "tie" ) || ( winner == "roundend" ) );

			doMissionCallback( "roundEnd", data );
		}
		team = "axis";
		for ( index = 0; index < level.placement[team].size; index++ )
		{
			data.player = level.placement[team][index];
			data.winner = (team == winner);
			data.place = index;
// Should this "roundend" signify a tie ? MGordon
			data.tie = ( ( winner == "tie" ) || ( winner == "roundend" ) );

			doMissionCallback( "roundEnd", data );
		}
	}
	else
	{
		for ( index = 0; index < level.placement["all"].size; index++ )
		{
			data.player = level.placement["all"][index];
			data.winner = (isdefined( winner) && (data.player == winner));
			data.place = index;

			doMissionCallback( "roundEnd", data );
		}		
	}
}

doMissionCallback( callback, data )
{
	if ( !mayProcessChallenges() )
		return;
	
	if ( getDvarInt( "disable_challenges" ) > 0 )
		return;

	if ( !isDefined( level.missionCallbacks ) )
		return;		
			
	if ( !isDefined( level.missionCallbacks[callback] ) )
		return;
	
	if ( isDefined( data ) ) 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]();
	}
}

monitorDriveDistance()
{
	self endon("disconnect");
	
	while(1)
	{
		if ( !player_is_driver() )
			self waittill("vehicle_driver");
		
		self.drivenDistanceThisDrive = 0;
		self monitorSingleDriveDistance();
		
		self processChallenge( "ch_roadtrip", int(self.drivenDistanceThisDrive) );

		self setStatLBByName( "tank", int(self.inVehicleTime), "Time Spent In");
	}
}

monitorSingleDriveDistance()
{
	self endon("disconnect");
	self endon("death");
	
	prevpos = self.origin;
	lengthOfCheck = 10; //seconds
	count = 0;
	waittime = .5;
	self.inVehicleTime = 0;
	self.currentTank = undefined;
	
	while( ( ( count * waittime) < lengthOfCheck ) && player_is_driver() )
	{
		wait( waittime );

		self.drivenDistanceThisDrive += distance( self.origin, prevpos );
		prevpos = self.origin;
		
		count++;
	}
	self.inVehicleTime = count * waittime;
}

monitorSprintDistance()
{
	self endon("disconnect");
	
// Would be good to store this in the blob as a total ever	- DRoche + MGordon
	while(1)
	{
		self waittill("sprint_begin");
		
		self.sprintDistThisSprint = 0;
		self monitorSingleSprintDistance();

		self processChallenge( "ch_marathon", int(self.sprintDistThisSprint) );
	}
}

monitorSingleSprintDistance()
{
	self endon("disconnect");
	self endon("death");
	self endon("sprint_end");
	
	prevpos = self.origin;
	while(1)
	{
		wait .1;

		self.sprintDistThisSprint += distance( self.origin, prevpos );
		prevpos = self.origin;
	}
}

monitorFallDistance()
{
	self endon("disconnect");

	self.pers["midairStreak"] = 0;
	
// Longest drop and total distance dropped would also be good in the blob - DRoche + MGordon
	
	while(1)
	{
		if ( !isAlive( self ) )
		{
			self waittill("spawned_player");
			continue;
		}
		
		if ( !self isOnGround() )
		{
			self.pers["midairStreak"] = 0;
			highestPoint = self.origin[2];
			while( !self isOnGround() )
			{
				if ( self.origin[2] > highestPoint )
					highestPoint = self.origin[2];
				wait .05;
			}
			self.pers["midairStreak"] = 0;

			falldist = highestPoint - self.origin[2];
			if ( falldist < 0 )
				falldist = 0;
			
			if ( falldist / 12.0 > 15 && isAlive( self ) )
				self processChallenge( "ch_basejump" );
				
			if (( falldist / 12.0 > 20 && isAlive( self ) ) && ( self depthinwater() > 2 )  )
			{
				self processChallenge( "ch_swandive" );
			}
			if ( falldist / 12.0 > 30 && !isAlive( self ) )
				self processChallenge( "ch_goodbye" );
			
			//println( "You fell ", falldist / 12.0, " feet");
		}
		wait .05;
	}
}

lastManSD()
{
	if ( !mayProcessChallenges() )
		return;

	if ( !self.wasAliveAtMatchStart )
		return;
	
	if ( self.teamkillsThisRound > 0 )
		return;
	
	self processChallenge( "ch_lastmanstanding" );
}

// The logic for this is a little funky - may erroneously allow this to be triggered if it's not the last flag.
// lastCapKiller is not cleared excepting death and spawn - DRoche + MGordon
ch_warHero( player )
{
	if ( !mayProcessChallenges() )
		return;
	self processChallenge( "ch_warhero" );
}	

ch_trapper( player )
{	
	if ( !mayProcessChallenges() )
		return;
	self processChallenge( "ch_trapper" );
}

// This might be better if it timed out rather than being when the player > 99 Health - DRoche + MGordon
ch_youtalkintome( player )
{	
	if ( !mayProcessChallenges() )
		return;
	self processChallenge( "ch_youtalkintome" );
}

ch_medic( player )
{	
	if ( !mayProcessChallenges() )
		return;
	self processChallenge( "ch_medic_" );
}

monitorBombUse()
{
	self endon("disconnect");
	
	while(1)
	{
		result = self waittill_any_return( "bomb_planted", "bomb_defused" );
		
		if ( !isDefined( result ) )
			continue;
			
		if ( result == "bomb_planted" )
		{
		}
		else if ( result == "bomb_defused" )
			self processChallenge( "ch_hero" );
	}
}


monitorLiveTime()
{
	for ( ;; )
	{
		self waittill ( "spawned_player" );
		
		self thread survivalistChallenge();
	}
}

survivalistChallenge()
{
	self endon("death");
	self endon("disconnect");
	
	wait 5 * 60;
	
	self processChallenge( "ch_survivalist" );
}

// This is most likely deprecated - DRoche + MGordon
monitorStreaks()
{
	self endon ( "disconnect" );

	self.pers["airstrikeStreak"] = 0;
	self.pers["meleeKillStreak"] = 0;

	self thread monitorMisc();

	for ( ;; )
	{
		self waittill ( "death" );
		
		self.pers["meleeKillStreak"] = 0;
	}
}


monitorPerkUsage()
{
	self endon ( "disconnect" );
	for ( ;; )
	{
		self.perkSpawnTime = gettime();
		self waittill("spawned");
		deathTime = gettime();
		self waittill ( "death" );

		perksUsageDuration = 0;
		if (deathTime > self.perkSpawnTime)
			perksUsageDuration = int ( ( deathTime - self.perkSpawnTime ) / ( 1000 ) );
		if (isdefined (self.specialty))
		{
			for (i = 0; i < self.specialty.size; i++)
			{
				self setStatLBByName( self.specialty[i], perksUsageDuration );
			}
		}
	}
}

monitorGameEnded()
{
	level waittill( "game_ended" );
	players = get_players();	
	roundEndTime = gettime();

	for (i=0; i < players.size; i++)
	{
		// perks used in the game
		perksUsageDuration = 0;
		if (roundEndTime > players[i].perkSpawnTime)
			perksUsageDuration = int ( ( roundEndTime - players[i].perkSpawnTime ) / ( 1000 ) );
		if (isdefined (self.specialty))
		{
			for (j = 0; j < self.specialty.size; j++)
			{
				players[i] setStatLBByName( self.specialty[j], perksUsageDuration );
			}
		}
		
		mapname = getdvar ("mapname");
		
		mapname2 = mapname + "2";
		mapname3 = mapname + "3";
		if ( isdefined( mapname ) && mapname != "" )
		{
			players[i] setStatLBByName( mapname2, players[i].pers["summary"]["xp"], "Xp Earned" );
			players[i] setStatLBByName( mapname2, players[i].pers["kills"], "Total Kills On" );
			players[i] setStatLBByName( mapname2, players[i].pers["deaths"], "Total Deaths On" );
			players[i] setStatLBByName( mapname2, players[i].pers["best_kill_streak"], "Longest Kill Streak On" );
			
			players[i] setStatLBByName( mapname2, 1, "Plays On" );
			
			if ( isdefined ( players[i].squadid ) )
			{
				if ( players[i].squadid == 0 )
				{
					players[i] setStatLBByName( mapname2, players[i].timePlayed["total"], "Time as Lone Wolf" );
				}
				else 
				{
					players[i] setStatLBByName( mapname2, players[i].timePlayed["total"], "Time In Squad" );
				}
			}
		}	
	}
}

monitorFlaredOrTabuned()
{
	self endon ( "disconnect" );
	for ( ;; )
	{
		self waittill ( "flared_or_tabuned_death", attacker, isFlared, isPoisoned );
				
		if ( isPlayer (attacker) && attacker != self ) 
		{
			if ( isFlared ) 
				attacker processChallenge( "ch_flare_" );
			if ( isPoisoned )
				attacker processChallenge( "ch_tabun_" );
		}
	}
}

monitorDestroyedTank()
{
	self endon( "disconnect" );
	for ( ;; )
	{
		self waittill ("destroyed_vehicle", weaponUsed, occupantEnt );
		
		if ( game["dialog"]["gametype"] == "freeforall" || occupantEnt.pers["team"] != self.pers["team"] ) 
		{
			self setStatLBByName( "tank", 1, "destroyed");
		
			if ( weaponUsed == "tankGun" )
				self processChallenge( "ch_tankvtank_" );
			else if ( isStrStart ( weaponUsed, "bazooka_" ) )
				self processChallenge( "ch_antitankrockets_" );
			else if ( isStrStart ( weaponUsed, "satchel_charge" ) )
				self processChallenge( "ch_antitankdemolitions_" );
			else if ( isStrStart ( weaponUsed, "sticky_grenade" ) )
				self processChallenge( "ch_tanksticker_" );
		}
	}
}

monitorImmobilizedTank()
{
	self endon( "disconnect" );
	for ( ;; )
	{
		self waittill ("immobilized_tank"); 
		self processChallenge( "ch_immobilizer_" );
	}
}

monitorMisc()
{
	self thread monitorMiscSingle( "destroyed_explosive" );
	self thread monitorMiscSingle( "begin_artillery" );
	self thread monitorMiscSingle( "destroyed_car" );
	self thread monitorMiscSingle( "selfdefense_dog" );
	self thread monitorMiscSingle( "death_dodger" );
	self thread monitorMiscSingle( "dog_handler" );
	
	self waittill("disconnect");
	
	// make sure the threads end when we disconnect.
	// (this allows one disconnect waittill instead of 4 disconnect endons)
	self notify( "destroyed_explosive" );
	self notify( "begin_artillery" );
	self notify( "destroyed_car" );
	self notify( "selfdefense_dog" );
	self notify( "death_dodger" );
	self notify( "dog_handler" );
}

monitorMiscSingle( waittillString )
{
	// don't need to endon disconnect because we will get the notify we're waiting for when we disconnect.
	// avoiding the endon disconnect saves a lot of script variables (5 * 4 threads * 64 players = 1280)
	
	while(1)
	{
		self waittill( waittillString );
		
		if ( !isDefined( self ) )
			return;
		
		monitorMiscCallback( waittillString );
	}
}

monitorMiscCallback( result )
{
	assert( isDefined( result ) );
	switch( result )
	{
// This may not be used - DRoche + MGordon
		case "begin_artillery":
			self.pers["airstrikeStreak"] = 0;
		break;

		case "destroyed_explosive":
			self processChallenge( "ch_backdraft_" );
		break;

		case "selfdefense_dog":
			self processChallenge( "ch_selfdefense" );
		break;

		case "destroyed_car":
			self processChallenge( "ch_vandalism_" );
		break;
		
		case "death_dodger":
			self processChallenge( "ch_deathdodger_" );
		break;
		case "dog_handler":
			self processChallenge( "ch_dogvet_" );
	}
}


healthRegenerated()
{
	if ( !isalive( self ) )
		return;
	
	if ( !mayProcessChallenges() )
		return;
	
	self thread resetBrinkOfDeathKillStreakShortly();
	
	if ( isdefined( self.lastDamageWasFromEnemy ) && self.lastDamageWasFromEnemy )
	{
		// TODO: this isn't always getting incremented when i regen
		self.healthRegenerationStreak++;
		if ( self.healthRegenerationStreak >= 5 )
		{
			self processChallenge( "ch_invincible" );
		}
	}
}

resetBrinkOfDeathKillStreakShortly()
{
	self endon("disconnect");
	self endon("death");
	self endon("damage");
	
	wait 1;
	
	self.brinkOfDeathKillStreak = 0;
}

playerSpawned()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.capturingLastFlag = false;
	self.lastCapKiller = false;
}

playerDied()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.lastCapKiller = false;
}

isAtBrinkOfDeath()
{
	ratio = self.health / self.maxHealth;
	return (ratio <= level.healthOverlayCutoff);
}

ch_gib( victim )
{
	
	//waiting on place to put it in the menu
	if ( !isDefined( victim.lastattacker ) || !isPlayer( victim.lastattacker ) )
		return;
	
	player = victim.lastattacker;

	if ( player == victim)
		return;
	
	if ( game["dialog"]["gametype"] != "freeforall" )
	{
		if ( victim.pers["team"] == player.pers["team"] )
			return;
	}
	
		
	player processChallenge( "ch_gib_" );
}

player_is_driver()
{
	if ( !isalive(self) )
		return false;
		
	vehicle = self GetVehicleOccupied();
	
	if ( IsDefined( vehicle ) )
	{
		seat = vehicle GetOccupantSeat( self );
		
		if ( isdefined(seat) && seat == 0 )
			return true;
	}
	
	return false;
}