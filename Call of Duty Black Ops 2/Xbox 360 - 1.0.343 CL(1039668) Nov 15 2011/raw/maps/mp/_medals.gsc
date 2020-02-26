// some common functions between all the air kill streaks
#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	level.medalInfo = [];
	level.medalCallbacks = [];
	tableName = "mp/medalTable.csv";
	isWagerMatch = ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) );
	if( isWagerMatch )
	{
		tableName = "mp/wagerCpMedalTable.csv";
	}
	
	registerMedalCallback( "playerKilled", maps\mp\_medals::medal_kills );	
		
	// if the column changes in the medalTable.csv 
	// these need to be changed too
	level.numKills = 0;
	level.medalSettings = spawnstruct();
	level.medalSettings.teamColumn = 4;
	level.medalSettings.playerColumn = 5;
	level.medalSettings.hardcoreMedalPopup = 6;

	baseRef = "";
	// unlocks all the challenges in this tier
	for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
	{
		refString = tableLookup( tableName, 0, idx, 1 );
		assert( refString != "MEDALS" );	

		level.medalInfo[refString] = [];
		level.medalInfo[refString]["index"] = idx;
		level.medalInfo[refString]["xp"] = spawnstruct();
		level.medalInfo[refString]["xp"].team = int( tableLookup( tableName, 0, idx, level.medalSettings.teamColumn ) );
		level.medalInfo[refString]["xp"].player = int( tableLookup( tableName, 0, idx, level.medalSettings.playerColumn ) );
		level.medalInfo[refString]["hardcore"] = int( tableLookup( tableName, 0, idx, level.medalSettings.hardcoreMedalPopup ) );
		if( isWagerMatch )
		{
			wagerBetPercent = int( GetDvarint( "scr_wagerBet" ) * 0.01 );
			level.medalInfo[refString]["xp"].team *= wagerBetPercent;
			level.medalInfo[refString]["xp"].player *= wagerBetPercent;
		}
	}
	
	level thread onPlayerConnect();
}

registerMedalCallback(callback, func)
{
	if (!isdefined(level.medalCallbacks[callback]))
		level.medalCallbacks[callback] = [];
	level.medalCallbacks[callback][level.medalCallbacks[callback].size] = func;
}



doMedalCallback( callback, data )
{

	if ( GetDvarint( "disable_medals" ) > 0 )
		return;

	if ( !isDefined( level.medalCallbacks ) )
		return;		
			
	if ( !isDefined( level.medalCallbacks[callback] ) )
		return;
	
	if ( isDefined( data ) ) 
	{
		for ( i = 0; i < level.medalCallbacks[callback].size; i++ )
			thread [[level.medalCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.medalCallbacks[callback].size; i++ )
			thread [[level.medalCallbacks[callback][i]]]();
	}
}



onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.lastKilledBy = undefined;
		player thread hijackCrate();
		player thread hijackTeamCrate();
	}
}


addMedalToQueue( medalName )
{
	size = self.medalNotifyQueue.size;
	self.medalNotifyQueue[size] = spawnStruct();
	self.medalNotifyQueue[size].medalName = medalName;

	self notify( "received award" );
}


giveMedal( medalName, weapon )
{
	self endon("disconnect");

	if( !level.medalsEnabled )
		return;
		
	if( level.wagerMatch && GetDvar( "g_gametype" ) != "cp" )
		return;

	if ( self is_bot() )
		return;
	
	if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
	{
		if ( maps\mp\gametypes\_rank::isRegisteredEvent( medalName ) )
		{
			maps\mp\gametypes\_globallogic_score::givePlayerScore( medalName, self, undefined, weapon );
		}
		return;
	}
	
	waittillframeend;
	
	if ( isdefined ( level.medalInfo[medalName] ) )
	{
		if ( level.teambased )
			xp = level.medalInfo[medalName]["xp"].team;
		else
			xp = level.medalInfo[medalName]["xp"].player;

		if( level.rankedMatch )
		{
			self AddRankXPValue( "medal", xp );
			self AddPlayerStat( "MEDALS", 1 );
		}

		[[level.onMedalAwarded]]( self, medalName, xp );
		
		self thread maps\mp\_properks::medalEarned( medalName, weapon );

		if ( level.hardcoreMode == false || level.medalInfo[medalName]["hardcore"] == 1 )
		{
			addMedalToQueue( medalName );
		}
	}
	else
	{
		/#
		iprintlnbold( "Error: " + medalName + " is not in medalTable.csv" );
		#/
	}
}

isMedal( medalName )
{
	if ( isdefined ( level.medalInfo[medalName] ) )
		return true;
	
	return false;
}



multiKill( killCount, weapon )
{
	assert( killCount > 1 );
	
	self maps\mp\_challenges::multiKill( weapon );

	if ( killCount == 2 )
	{
		self processMedal( "MEDAL_DOUBLE_KILL", weapon, true );
	}
	else if ( killCount == 3 )
	{
		self processMedal( "MEDAL_TRIPLE_KILL", weapon, true );
	}
	else
	{
		self processMedal( "MEDAL_MULTI_KILL", weapon, true );
	}
}


medal_kills( data, time )
{
	victim = data.victim;
	attacker = data.attacker;
	time = data.time;
	level.numKills++;
	victim = data.victim;
	attacker.lastKilledPlayer = victim;
	wasDefusing = data.wasDefusing;
	
	victim.anglesOnDeath = victim getPlayerAngles();
	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();

	if ( isSubStr( data.sMeansOfDeath, "MOD_GRENADE" ) || isSubStr( data.sMeansOfDeath, "MOD_EXPLOSIVE" ) || isSubStr( data.sMeansOfDeath, "MOD_PROJECTILE" ) )
	{
		if ( data.sWeapon == "none" && isdefined( data.victim.explosiveInfo["weapon"] ) )
			data.sWeapon = data.victim.explosiveInfo["weapon"];
		
		if ( data.sWeapon ==  "explosive_bolt_mp"  || data.sWeapon == "sticky_grenade_mp"  )
		{
			if ( isdefined( data.victim.explosiveInfo["stuckToPlayer"] ) && data.victim.explosiveInfo["stuckToPlayer"] == victim ) 
			{
				attacker processMedal( "MEDAL_STUCK_TO_PLAYER", data.sWeapon );
			}
		}
	}
	
	//Ballistic Knives shouldn't give medals for melee kills and should never give headshot medals
	if( IsSubStr( data.sMeansOfDeath, "MOD_IMPACT" ) || 
		IsSubStr( data.sMeansOfDeath, "MOD_HEAD_SHOT" ) ||
		IsSubStr( data.sMeansOfDeath, "MOD_PISTOL_BULLET" ) )
	{
		if ( data.sWeapon ==  "knife_ballistic_mp" )
		{
			level.globalSkewered++;
			attacker processMedal( "MEDAL_SKEWER", data.sWeapon );
		}
	}

	if ( isdefined ( victim.damagedPlayers ) )
	{
		keys = getarraykeys(victim.damagedPlayers);

		for ( i = 0; i < keys.size; i++ )
		{
			key = keys[i];
			if ( key == attacker.clientid )
				continue;

			if ( level.teamBased && time - victim.damagedPlayers[key] < 1000 )
			{
				attacker processMedal( "MEDAL_RESCUER", data.sWeapon );
			}
		}
	}

	if ( data.sWeapon == "hatchet_mp" )
	{
		attacker.pers["tomahawks"]++;
		attacker.tomahawks = attacker.pers["tomahawks"];
		
		attacker processMedal( "MEDAL_BULLS_EYE", data.sWeapon );
		
		if ( isdefined( data.victim.explosiveInfo["projectile_bounced"] ) && data.victim.explosiveInfo["projectile_bounced"] == true )
		{
			level.globalBankshots++;
			attacker processMedal( "MEDAL_BANK_SHOT", data.sWeapon );
		}
	}
	
	if ( isplayer( attacker ) && isplayer( victim ) && attacker != victim  )
	{
		attacker thread updateMultiKills( data.sWeapon );

		if ( level.numKills == 1 )
		{
			attacker processMedal( "MEDAL_FIRST_BLOOD", data.sWeapon );

			if ( isdefined( data.sWeapon ) ) 
			{
				if ( !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( data.sWeapon ) )
					level thread maps\mp\_popups::DisplayTeamMessageToAll( &"MEDAL_FIRST_BLOOD", attacker );
			}
		}

		if ( !level.teambased || victim.team != attacker.team )
		{
			if ( victim maps\mp\killstreaks\_killstreaks::isOneAwayFromKillstreak() )
			{
				level.globalBuzzKills++;
				attacker processMedal( "MEDAL_BUZZ_KILL", data.sWeapon );
			}


			if ( is_weapon_valid( data.sMeansOfDeath, data.sWeapon ) )
			{
				if ( isdefined( victim.vAttackerOrigin ) )
					attackerOrigin = victim.vAttackerOrigin;
				else
					attackerOrigin = attacker.origin;
				distToVictim = distanceSquared( victim.origin, attackerOrigin );
				//weap_min_dmg_range = GetWeaponMinDamageRange( data.sWeapon );
				weap_min_dmg_range = get_distance_for_weapon( data.sWeapon );
				if ( weap_min_dmg_range > 0 && distToVictim > weap_min_dmg_range * weap_min_dmg_range )
				{
					attacker processMedal( "MEDAL_LONG_SHOT", data.sWeapon );
					attacker.pers["longshots"]++;
					attacker.longshots = attacker.pers["longshots"];	
				}
			}
		}	
	}

	attacker.lastKillTime = GetTime();

	if ( level.teambased && isdefined( victim.lastKillTime ) && victim.lastKillTime > GetTime() - 3000 )
	{
		if ( victim.lastkilledplayer != attacker )
		{
			attacker processMedal( "MEDAL_AVENGER", data.sWeapon );
		}
	}

	attackerInChopper = attacker IsInVehicle();

	if ( !isAlive( attacker ) && ( isdefined( attacker.deathtime ) && ( attacker.deathtime + 800 ) < getTime() ) && !attackerInChopper )
	{
		if ( !isdefined( attacker.afterlifeMedalTime ) || attacker.afterlifeMedalTime != attacker.deathTime )
		{
			attacker.afterlifeMedalTime = attacker.deathtime;
			level.globalAfterlifes++;
			attacker processMedal( "MEDAL_AFTERLIFE", data.sWeapon );
		}
	}
	
	if( attacker.cur_death_streak >= GetDvarint( "perk_deathStreakCountRequired" ) )
	{
		level.globalComebacks++;
		attacker processMedal( "MEDAL_COMEBACK", data.sWeapon );
	}
	
	if ( data.sMeansOfDeath == "MOD_MELEE" )
	{
		attacker.pers["stabs"]++;
		attacker.stabs = attacker.pers["stabs"];
		
		vAngles = victim.anglesOnDeath[1];
		pAngles = attacker.anglesOnKill[1];
		angleDiff = AngleClamp180( vAngles - pAngles );

		if ( angleDiff > -30 && angleDiff < 70 )
		{
			level.globalBackstabs++;
			attacker processMedal( "MEDAL_BACK_STABBER", data.sWeapon );
			attacker.pers["backstabs"]++;
			attacker.backstabs = attacker.pers["backstabs"];	
		}
	}
	
	if ( isdefined ( victim.firstTimeDamaged ) && victim.firstTimeDamaged == time )
	{
		if ( maps\mp\gametypes\_missions::getweaponclass( data.sweapon ) == "weapon_sniper" && data.sMeansOfDeath != "MOD_MELEE" )
		{
			attacker processMedal( "MEDAL_ONE_SHOT_KILL", data.sWeapon );
		}
	}

	if ( isdefined ( attacker.lastKilledBy ) )
	{
		if ( attacker.lastKilledBy == victim )
		{
			level.globalPaybacks++;
			attacker processMedal( "MEDAL_PAYBACK", data.sWeapon);
			attacker.lastKilledBy = undefined;
		}	
	}

	if ( isDefined( wasDefusing ) && wasDefusing )
	{
		attacker processMedal( "MEDAL_ANTI_BOMBER", data.sWeapon, true );
	}

	attacker.cur_death_streak = 0;
	attacker disabledeathstreak();
}

setLastKilledBy( attacker )
{
	self.lastKilledBy = attacker;
}


is_weapon_valid( meansOfDeath, weapon )
{
	valid_weapon = false;
	
	if( weapon == "minigun_mp" )
		valid_weapon = false;
	else if ( meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_RIFLE_BULLET" )
		valid_weapon = true;
	else if ( meansOfDeath == "MOD_HEAD_SHOT" )
		valid_weapon = true;
	else if ( get_distance_for_weapon( weapon ) )
		valid_weapon = true;

	return valid_weapon;
}


updatemultikills( weapon )
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateRecentKills" );
	self endon ( "updateRecentKills" );
	if ( !isdefined (self.recentKillCount) )
		self.recentKillCount = 0;
	self.recentKillCount++;
	if ( !isdefined (self.recentGrenadeKillCount) )
		self.recentGrenadeKillCount = 0;

	if ( isdefined( weapon ) )
	{
		if ( weapon == "frag_grenade_mp" || weapon == "sticky_grenade_mp" )
			self.recentGrenadeKillCount++;
	}

	wait ( 1.0 );
	
	if ( self.recentGrenadeKillCount > 1 )
		self maps\mp\_properks::multiGrenadeKill();	

	if ( self.recentKillCount > 1 )
		self multiKill( self.recentKillCount, weapon );
	
	self.recentKillCount = 0;
	self.recentGrenadeKillCount = 0;
}

hijackCrate()
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	for (;;)
	{
		self waittill( "hijacked crate" );
		self processMedal( "MEDAL_HIJACKER" );
	}
}

hijackTeamCrate()
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	for (;;)
	{
		self waittill( "team crate hijacked", crateType );
		level.globalSharePackages++;
		if ( isdefined (crateType.shareStat) )
		{
			self processMedal( crateType.shareStat );
			if ( maps\mp\_challenges::canProcessChallenges() )
			{
				self AddPlayerStat( "MEDAL_SHARE_PACKAGE", 1 );
			}
		}
	}
}

get_distance_for_weapon( weapon )
{
	// this is special for the long shot medal
	// need to do this on a per weapon category basis, to better control it

	distance = 0;

	weap_tokens = StrTok( weapon, "_" );
	switch( weap_tokens[0] )
	{
	// SMG
	case "ak74u":
	case "kiparis":
	case "mac11":
	case "mp5k":
	case "mpl":
	case "pm63":
	case "skorpion":
	case "spectre":
	case "uzi":
		distance = 1250;
		break;

	// AR
	case "ak47":
	case "aug":
	case "commando":
	case "enfield":
	case "famas":
	case "fnfal":
	case "g11":
	case "galil":
	case "m14":
	case "m16":
		distance = 1500;
		break;

	// LMG
	case "hk21":
	case "m60":
	case "rpk":
	case "stoner63":
		distance = 1500;
		break;

	// Sniper
	case "dragunov":
	case "l96a1":
	case "psg1":
	case "wa2000":
		distance = 1750;
		break;

	// Pistol
	case "asp":
	case "cz75":
	case "makarov":
	case "m1911":
	case "python":
		distance = 700;
		break;

	// Shotgun (I hope they aren't getting these :)
	case "hs10":
	case "ithaca":
	case "rottweil72":
	case "spas":
	case "mk":
		distance = 650;
		break;

	// Projectile
	case "knife":
		if( weap_tokens[1] == "ballistic" )
			distance = 500;	
		break;
	case "crossbow":
		if( weap_tokens[1] == "explosive" )
			distance = 1500;
		break;
	case "hatchet":
		distance = 500;
		break;
	
	case "ft":
	case "gl":
	default:
		distance = 0;
		break;
	}

	return distance;
}

execution( weapon )
{
	level.globalExecutions++;
	self processMedal( "MEDAL_EXECUTION", weapon );
}

assisted()
{
	self processMedal( "MEDAL_ASSISTS" );
}

heroic()
{
	self processMedal( "MEDAL_HEROIC" );
}

assistedSuicide( weapon )
{
	self processMedal( "MEDAL_ASSISTED_SUICIDE", weapon );
}

bomber()
{
	if ( isdefined( self.team ) )
	{
		if ( self.team == "allies" )
		{
			level.globalBombsDestroyedByOps++;
		}
		else
		{
			level.globalBombsDestroyedByCommunists++;
		}
	}
	self processMedal( "MEDAL_BOMBER" );
}

hero()
{
	self processMedal( "MEDAL_HERO" );
}

offense( weapon )
{
	level.globalTeamMedals++;
	self processMedal( "MEDAL_OFFENSE_MEDAL", weapon, true );
}

defense( weapon )
{
	level.globalTeamMedals++;
	self processMedal( "MEDAL_DEFENSE_MEDAL", weapon, true );
}

positionSecure()
{
	self processMedal( "MEDAL_POSITION_SECURE" );
}

flagRunner()
{
	self processMedal( "MEDAL_FLAG_RUNNER" );
}

flagCapture()
{
	self processMedal( "MEDAL_FLAG_CAPTURE" );
}

flagReturn()
{
	self processMedal( "MEDAL_FLAG_RETURN" );
}

saboteur()
{
	self processMedal( "MEDAL_SABOTEUR" );
}

destroyerUAV(isSpyPlane, weapon )
{
	if ( isSpyPlane ) 
	{
		self processMedal( "MEDAL_DESTROYER_UAV", weapon, true );
	}
	else
	{
		self processMedal( "MEDAL_DESTROYER_COUNTERUAV", weapon, true );
	}
}

destroyerTurret( weapon )
{
	self processMedal( "MEDAL_DESTROYER_TURRET", weapon, true );
}

destroyerHelicopter( weapon )
{
	self processMedal( "MEDAL_DESTROYER_HELICOPTER", weapon, true );
}

destroyerHelicopterPlayer( weapon )
{
	self processMedal( "MEDAL_DESTROYER_HELICOPTER_PLAYER", weapon, true );
}

destroyerM220Tow( weapon )
{
	self processMedal( "MEDAL_DESTROYER_M220_TOW", weapon, true );
}

destroyerRCBomb()
{
	self processMedal( "MEDAL_DESTROYER_RCBOMB", undefined, true );
}

destroyerQRDrone()
{
	self processMedal( "MEDAL_DESTROYER_QRDRONE", undefined, true );
}

destroyerAiTank()
{
	self processMedal( "MEDAL_DESTROYER_AI_TANK", undefined, true );
}

revives()
{
	level.globalRevives++;
	self processMedal( "MEDAL_REVIVES" );
}

headshot( weapon )
{
	self processMedal( "MEDAL_HEAD_SHOT", weapon );
}


assistAircraftTakedown( weapon )
{
	self processMedal( "MEDAL_AIRCRAFT_ASSIST", weapon );
}

processMedal( medalName, weapon, allowKillstreakWeapon )
{
	if ( ( isdefined( weapon ) ) && ( !isdefined( allowKillstreakWeapon ) || allowKillstreakWeapon == false ) ) 
	{
		// no medals for killstreaks
		if ( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( weapon ) )
			return;
	}
	
	self thread giveMedal( medalName, weapon );
	
	if ( maps\mp\_challenges::canProcessChallenges() )
	{
		self AddPlayerStat( medalName, 1 );
	}
}

