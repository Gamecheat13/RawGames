#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	level.missionCallbacks = [];
	
	level thread onPlayerConnect();

	if ( mayProcessChallenges() )
	{
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
		
	}
}

mayProcessChallenges()
{
	return false;
	/#
	if ( GetDvarint( "debug_challenges" ) )
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
		player thread monitorDriveDistance();
		player thread monitorFallDistance();
		player thread monitorLiveTime();	
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
	self.pers["lastBulletKillTime"] = 0;
	//self.pers["bulletStreak"] = 0;
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
	if ( isDefined( self.challengeData[name] ) )
		return self.challengeData[name];
	else
		return 0;
}

getChallengeLevels( baseName )
{
	if ( isDefined( level.challengeInfo[baseName] ) )
		return level.challengeInfo[baseName]["levels"];
		
//	assert( isDefined( level.challengeInfo[baseName + "1" ] ), "Challenge name " + baseName + " not found!" );
	if (!isDefined (level.challengeInfo[baseName + "1" ] ) )
		return -1;
	
	return level.challengeInfo[baseName + "1"]["levels"];

}

processChallenge( baseName, progressInc, weaponNum, challengeType )
{
	if ( !mayProcessChallenges() )
		return;
	
	numLevels = getChallengeLevels( baseName );
	
	if ( numLevels < 0 ) 
		return;
		
	
	if ( isDefined( weaponNum ) && isDefined( challengeType ) )
	{
		missionStatus = self getdstat( "WeaponStats", weaponNum, "challengeState", challengeType );
		
		//activate challenge if not active yet
		if ( !missionStatus )
		{
			missionStatus = 1;
			self setDStat( "WeaponStats", weaponNum, "challengeState", challengeType, missionStatus );
		}
	}
	else
	{
		if ( numLevels > 1 )
			missionStatus = self getChallengeStatus( (baseName + "1")  );
		else
			missionStatus = self getChallengeStatus( baseName );
	}

	if ( !isDefined( progressInc ) )
	{
		progressInc = 1;
	}
	
	/#
	if ( GetDvarint( "debug_challenges" ) )
		println( "CHALLENGE PROGRESS - " + baseName + ": " + progressInc );
	#/
	
	if ( !missionStatus || missionStatus == 255 )
		return;
		
	assert( missionStatus <= numLevels, "Mini challenge levels higher than max: " + missionStatus + " vs. " + numLevels );
	
	if ( numLevels > 1 )
		refString = baseName + missionStatus;
	else
		refString = baseName;
		
	if ( isDefined( weaponNum ) && isDefined( challengeType ) )
	{
		progress = self getdstat( "WeaponStats", weaponNum, "challengeprogress", challengeType );
	}
	else
	{
		progress = self getdstat( "ChallengeStats", refString, "challengeprogress" );
	}

	/*
	if ( isStrStart( refString, "ch_marksman_" ) || isStrStart( refString, "ch_expert_" ) )
		progressInc = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	*/
	
	progress += progressInc;
	
	if ( isDefined( weaponNum ) && isDefined( challengeType ) )
	{
		self setdstat( "WeaponStats", weaponNum, "challengeprogress", challengeType, progress );
	}
	else
	{
		self setdstat( "ChallengeStats", refString, "challengeprogress", progress );
	}

	if ( progress >= level.challengeInfo[refString]["maxval"] )
	{
		if ( !isDefined( weaponNum ) )
		{
			weaponNum = 0; // weapon_null
		}
		self thread milestoneNotify( level.challengeInfo[refString]["tier"], level.challengeInfo[refString]["index"], weaponNum, level.challengeInfo[refString]["tier"] );

	
		if ( missionStatus == numLevels )
		{
			missionStatus = 255;
			self maps\mp\gametypes\_globallogic_score::incPersStat( "challenges", 1 );
		}
		else
			missionStatus += 1;

		if ( numLevels > 1 )
			self.challengeData[baseName + "1"] = missionStatus;
		else
			self.challengeData[baseName] = missionStatus;

		// prevent bars from running over
		if ( isDefined( weaponNum ) && isDefined( challengeType ) )
		{
			self setdstat( "WeaponStats", weaponNum, "challengeprogress", challengeType, level.challengeInfo[refString]["maxval"] );
			self setdstat( "WeaponStats", weaponNum, "challengestate", challengeType, missionStatus );
		}
		else
		{
			self setdstat( "ChallengeStats", refString, "challengeprogress", level.challengeInfo[refString]["maxval"] );
			self setdstat( "ChallengeStats", refString, "challengestate", missionStatus );
		}

		self AddRankXPValue( "challenge", level.challengeInfo[refString]["reward"] );
		self maps\mp\gametypes\_rank::incCodPoints( level.challengeInfo[refString]["cpreward"] );
		
	}
}

milestoneNotify( index, itemIndex, type, tier )
{
	level.globalChallenges++;
	
	if ( !isDefined( type ) )
	{
		type = "global";
	}
	size = self.pers["challengeNotifyQueue"].size;
	self.pers["challengeNotifyQueue"][size] = [];
	self.pers["challengeNotifyQueue"][size]["tier"] = tier;
	self.pers["challengeNotifyQueue"][size]["index"] = index;
	self.pers["challengeNotifyQueue"][size]["itemIndex"] = itemIndex;
	self.pers["challengeNotifyQueue"][size]["type"] = type;
		
	self notify( "received award" );
}


ch_assists( data )
{
	player = data.player;
	player processChallenge( "ch_assists_" );
}


ch_hardpoints( data )
{
	player = data.player;
	if (!isdefined (player.pers[data.hardpointType]))
		player.pers[data.hardpointType] = 0;
	player.pers[data.hardpointType]++;

	if ( data.hardpointType == "radar_mp" )
	{
		// radar inbound
		player processChallenge( "ch_uav" );
		player processChallenge( "ch_exposed_" );

		if ( player.pers[data.hardpointType] >= 3 )
			player processChallenge( "ch_nosecrets" );
	}
	else if ( data.hardpointType == "artillery_mp" )
	{	
		player processChallenge( "ch_artillery" );

		if ( player.pers[data.hardpointType] >= 2 )
			player processChallenge( "ch_heavyartillery" );
	}
	else if ( data.hardpointType == "dogs_mp" )	
	{
		player processChallenge( "ch_dogs" );

		if ( player.pers[data.hardpointType] >= 2 )
			player processChallenge( "ch_rabid" );
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
		player processChallenge( "ch_artilleryvet_" );
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
	return weaponClass;
}

// This is for bullet weapons (assumed to be 0 - 64 )
processKillsChallengeForWeapon( weaponName, player, challengeClassName )
{
		for ( weaponNum = 0; weaponNum < 64; weaponNum++ )
		{
			if ( isDefined( level.tbl_weaponIDs[ weaponNum ] ) &&
			 isStrStart( weaponName, level.tbl_weaponIDs[ weaponNum ][ "reference" ] ) )
			{
				player processChallenge( "ch_" + challengeClassName + "_" + level.tbl_weaponIDs[ weaponNum ][ "reference" ] + "_", 1, weaponNum, challengeClassName );
				return;
			}
		}
		
		//assert( 0, "No challenge information found for weapon " + weaponName );
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
	
	if ( player.pers["cur_kill_streak"] == 10 )
		player processChallenge( "ch_fearless" );
	
	if ( player isFlared() )
	{
		if ( player hasPerk ("specialty_flashprotection") ) 
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
		if ( player hasPerk ("specialty_proximityprotection") ) 
		{
			if ( isdefined( player.lastPoisonedBy ) &&  data.victim == player.lastPoisonedBy )
			player processChallenge( "ch_gasmask" );
		}
		else
		{
			player processChallenge( "ch_slowbutsure" );
		}
	}
	
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
		if ( isSubStr ( data.sWeapon, "_gunner_mp" ) )
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
		//ch_bulletKillCommon( data, player, time, weaponClass );
		
		clipCount = player GetWeaponAmmoClip( data.sWeapon );

// This challenge holds less value now that we have shotguns - DRoche + MGordon		
		if ( clipCount == 0 )
			player processChallenge( "ch_desperado" );

		if ( weaponClass == "weapon_pistol" )
			player processChallenge( "ch_marksman_pistol_" );
		
		if ( isSubStr( data.sWeapon, "silencer_mp" ) )
			player processChallenge( "ch_silencer_" );			
			
		processKillsChallengeForWeapon( data.sWeapon, player, "marksman" );
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
			else if ( isStrStart( data.sWeapon, "claymore_" ) )
			{
				player processChallenge( "ch_claymore_" );

				if ( player.explosiveKills[expId] > 1 )
					player processChallenge( "ch_multimine" );

				if ( data.victim.explosiveInfo["returnToSender"] )
					player processChallenge( "ch_returntosender" );				

				if ( data.victim.explosiveInfo["counterKill"] )
					player processChallenge( "ch_counterclaymore_" );
				
				if ( data.victim.explosiveInfo["bulletPenetrationKill"] )
					player processChallenge( "ch_howthe" );

				if ( data.victim.explosiveInfo["chainKill"] )
					player processChallenge( "ch_dominos" );
					
				if ( data.victim.explosiveInfo["ohnoyoudontKill"] )
					player processChallenge( "ch_ohnoyoudont" );
			}
			else if ( data.sWeapon == "explodable_barrel_mp" )
			{
				player processChallenge( "ch_barrelbomb_" );
			}
			else if ( data.sWeapon == "destructible_car_mp" )
			{
				player processChallenge( "ch_carbomb_" );
			}
		}
	}
	else if ( isStrStart( data.sMeansOfDeath, "MOD_MELEE" )  )
	{

		player processChallenge( "ch_knifevet_" );
				
		if ( data.attackerInLastStand )
			player processChallenge( "ch_downnotout_" );
		
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
		
		//ch_bulletKillCommon( data, player, time, weaponClass );
	
		switch ( weaponClass )
		{
			case "weapon_smg":
				player processChallenge( "ch_expert_smg_" );
				break;
			case "weapon_lmg":
//				player processChallenge( "ch_expert_lmg_" );
				break;
			case "weapon_hmg":
//				player processChallenge( "ch_expert_hmg_" );
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
			
		if ( isSubStr( data.sWeapon, "silencer_mp" ) )
			player processChallenge( "ch_silencer_" );			
			
		processKillsChallengeForWeapon( data.sWeapon, player, "expert" );
		processKillsChallengeForWeapon( data.sWeapon, player, "marksman" );
		
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


ch_bulletKillCommon( data, player, time, weaponClass )
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
		player processChallenge( "ch_silencer_" ); 
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
		
		if ( deaths == 0 && maps\mp\gametypes\_globallogic_utils::getTimePassed() > 5 * 60 * 1000 )
			player processChallenge( "ch_flawless" );
		
		
		if ( player.score > 0 )
		{
			switch ( level.gameType )
			{
				case "dm": 
					if ( ( data.place < 4 ) && ( level.placement["all"].size > 3 ) && ( game["dialog"]["gametype"] == "ffa_start" ) ) 
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
			return;
		}
	}
	
	if (IsDefined(data.winner))
	{
		if ( !data.winner )
		{
			return;
		}
	}
	else
	{
		return;
	}
	
	
	if ( player.wasAliveAtMatchStart )
	{
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
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

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

playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc, attackerStance )
{
	print(level.gameType);
	self.anglesOnDeath = self getPlayerAngles();
	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();
	if ( !isdefined( sWeapon ) )
		sWeapon = "none";
	
	self endon("disconnect");

	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.attackerStance = attackerStance;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;
	data.time = gettime();
	data.wasPlanting = data.victim.isplanting;
	data.wasDefusing = data.victim.isdefusing;
	
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerInLastStand = isDefined( data.attacker.lastStand );
		data.attackerOnGround = data.attacker isOnGround();
		if ( !isdefined( data.attackerStance ) ) 
		{
			data.attackerStance = data.attacker getStance();
		}
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
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	level thread doMissionCallback( "playerKilled", data );
	level thread maps\mp\_medals::doMedalCallback( "playerKilled", data );
	level thread maps\mp\_properks::doProPerkCallback( "playerKilled", data );
	level thread maps\mp\_challenges::doChallengeCallback( "playerKilled", data );
}

playerAssist()
{
	data = spawnstruct();

	data.player = self;

	doMissionCallback( "playerAssist", data );
}


useKillstreak( hardpointType )
{
	wait .05;
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	data = spawnstruct();

	data.player = self;
	data.hardpointType = hardpointType;

	doMissionCallback( "playerHardpoint", data );
}


roundBegin()
{
	doMissionCallback( "roundBegin" );
	setMatchFlag( "enable_popups", 1 );
	setSlowMotion( 1, 1, 0 );
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
	
	if ( GetDvarint( "disable_challenges" ) > 0 )
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
		if ( !maps\mp\_vehicles::player_is_driver() )
			self waittill("vehicle_driver");
		
		self.drivenDistanceThisDrive = 0;
		self monitorSingleDriveDistance();
		
		self processChallenge( "ch_roadtrip", int(self.drivenDistanceThisDrive) );
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
	
	while( ( ( count * waittime) < lengthOfCheck ) && maps\mp\_vehicles::player_is_driver() )
	{
		wait( waittime );

		self.drivenDistanceThisDrive += distance( self.origin, prevpos );
		prevpos = self.origin;
		
		count++;
	}
	self.inVehicleTime = count * waittime;
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
		
		if ( !self isOnGround() && !self isOnLadder() )
		{
			self.pers["midairStreak"] = 0;
			highestPoint = self.origin[2];
			while( !self isOnGround() && !self isOnLadder() )
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
			
			/#
			if ( GetDvarint( "debug_challenges" ) )
				println( "You fell ", falldist / 12.0, " feet");
			#/
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
		self waittill( "bomb_defused" );
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
	}
}

monitorGameEnded()
{
	level waittill( "game_ended" );
	players = GET_PLAYERS();	
	roundEndTime = gettime();
	
	// this stuff is kept in here for future reference - no longer used but useful
	// for future stats gathering MGordon
	
	/*
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
		
		mapname = GetDvar ("mapname");
		
		mapname2 = mapname + "2";
		mapname3 = mapname + "3";
		if ( isdefined( mapname ) && mapname != "" )
		{
			players[i] setStatLBByName( mapname2, players[i].pers["summary"]["xp"], "Xp Earned" );
			players[i] setStatLBByName( mapname2, players[i].pers["kills"], "Total Kills On" );
			players[i] setStatLBByName( mapname2, players[i].pers["deaths"], "Total Deaths On" );
			players[i] setStatLBByName( mapname2, players[i].pers["best_kill_streak"], "Longest Kill Streak On" );
			
			players[i] setStatLBByName( mapname2, 1, "Plays On" );
			
		}	
	}*/
	
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
		
		if ( game["dialog"]["gametype"] == "ffa_start" || occupantEnt.pers["team"] != self.pers["team"] ) 
		{
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
	
	if ( game["dialog"]["gametype"] != "ffa_start" )
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
