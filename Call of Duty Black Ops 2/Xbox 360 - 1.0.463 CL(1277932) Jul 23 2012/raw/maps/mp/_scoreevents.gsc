#include maps\mp\_utility;
#include common_scripts\utility;

#insert raw\maps\mp\_scoreevents.gsh;

init()
{
	level.scoreEventCallbacks = [];
	registerScoreEventCallback( "playerKilled", maps\mp\_scoreEvents::scoreEventPlayerKill );	
}
scoreEventTableLookupInt( index, scoreEventColumn )
{
	return int( tableLookup( SCORE_EVENT_TABLE_NAME, 0, index, scoreEventColumn ) );
}

scoreEventTableLookup( index, scoreEventColumn )
{
	return tableLookup( SCORE_EVENT_TABLE_NAME, 0, index, scoreEventColumn );
}

getScoreEventColumn( gameType )
{
	columnOffset = getColumnOffsetForGametype( gameType );
	assert( columnOffset >= 0 );
	if ( columnOffset >= 0 )
	{
		columnOffset += SCORE_EVENT_GAMETYPE_COLUMN_SCORE;
	}
	return columnOffset;	
}

getXPEventColumn( gameType )
{
	columnOffset = getColumnOffsetForGametype( gameType );
	assert( columnOffset >= 0 );
	if ( columnOffset >= 0 )
	{
		columnOffset += SCORE_EVENT_GAMETYPE_COLUMN_XP;
	}
	return columnOffset;	
}

getColumnOffsetForGametype( gameType )
{
	foundGameMode = false;
	if ( !isdefined ( level.scoreEventTableID ) ) 
	{
		level.scoreEventTableID = getScoreEventTableID();
	}

	assert( isdefined ( level.scoreEventTableID ) );
	if ( !isdefined ( level.scoreEventTableID ) ) 
	{
		return -1;
	}

	for ( gameModeColumn = SCORE_EVENT_GAMETYPE_SCORE; ; gameModeColumn += SCORE_EVENT_GAMETYPE_COLUMN_COUNT )
	{
		column_header = TableLookupColumnForRow( level.scoreEventTableID, 0, gameModeColumn );
		if ( column_header == "" )
		{
			gameModeColumn = SCORE_EVENT_GAMETYPE_SCORE;
			break;
		}
		
		if ( column_header == level.gameType + " score" )
		{
			foundGameMode = true;
			break;
		}
	}
	
	assert( foundGameMode, "Could not find gamemode in scoreInfo.csv:" + gameType );
	return gameModeColumn;
}
		
getScoreEventTableID()
{
	scoreInfoTableLoaded = false;
	scoreInfoTableID = TableLookupFindCoreAsset( SCORE_EVENT_TABLE_NAME );
		
	if ( IsDefined( scoreInfoTableID ) )
	{
		scoreInfoTableLoaded = true;
	}
	assert( scoreInfoTableLoaded, "Score Event Table is not loaded: " + SCORE_EVENT_TABLE_NAME );
	return scoreInfoTableID;
}


processScoreEvent( event, player, victim, weapon, addDemoBookmark )
{
	if ( !isplayer(player) )
	{
		AssertMsg("processScoreEvent called on non player entity" );				
		return;
	}
	if ( isdefined ( victim ) ) 
	{
		victim resetPlayerMomentumOnDeath( event );
	}
	
	if ( maps\mp\gametypes\_rank::isRegisteredEvent( event ) ) 
	{
		allowPlayerScore = false;
		
		if ( !isdefined( weapon ) || maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( weapon ) == false ) 
		{	
			allowPlayerScore = true;
		}
		else
		{
			allowPlayerScore = maps\mp\gametypes\_rank::killstreakWeaponsAllowedScore( event );
		}

		if (allowPlayerScore )
		{
			maps\mp\gametypes\_globallogic_score::givePlayerScore( event, player, victim, weapon, undefined );
		}
	}
	
	if ( level.rankedMatch && IsDefined( victim ) && !victim is_bot() && !level.leagueMatch)
	{
		player AddRankXp( event, weapon );
	}


	// need to add this to call
	allowKillstreakWeapon = false;
	if ( isMedal( event ) ) 
	{
		player maps\mp\_medals::processMedal( event, weapon, allowKillstreakWeapon, addDemoBookmark ); 
	}
	else
	{
		if ( isDefined( addDemoBookmark ) && addDemoBookmark )
			maps\mp\_demo::bookmark( "score_event", gettime(), player );
	}
}

setScoreInfoStat( type )
{
	
	if ( maps\mp\_challenges::canProcessChallenges() == true )
	{
		if ( isDefined( level.scoreInfo[type]["setDDLStat"] ) && level.scoreInfo[type]["setDDLStat"] == true )
		{
			return true;
		}
	}

	return false;
}


doScoreEventCallback( callback, data )
{

	if ( !isDefined( level.scoreEventCallbacks ) )
		return;		
			
	if ( !isDefined( level.scoreEventCallbacks[callback] ) )
		return;
	
	if ( isDefined( data ) ) 
	{
		for ( i = 0; i < level.scoreEventCallbacks[callback].size; i++ )
			thread [[level.scoreEventCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.scoreEventCallbacks[callback].size; i++ )
			thread [[level.scoreEventCallbacks[callback][i]]]();
	}
}


registerScoreEventCallback( callback, func )
{
	if ( !isdefined( level.scoreEventCallbacks[callback] ) )
	{
		level.scoreEventCallbacks[callback] = [];
	}
	level.scoreEventCallbacks[callback][level.scoreEventCallbacks[callback].size] = func;
}



scoreEventPlayerKill( data, time )
{
	victim = data.victim;
	attacker = data.attacker;
	time = data.time;
	level.numKills++;
	victim = data.victim;
	attacker.lastKilledPlayer = victim;
	wasDefusing = data.wasDefusing;
	wasPlanting = data.wasPlanting;
	wasOnGround = data.victimOnGround;
	if ( isdefined ( data.sWeapon ) )
	{
		weaponClass = getWeaponClass( data.sweapon );
		killstreak = getKillstreakFromWeapon( data.sweapon );
	}

	victim.anglesOnDeath = victim getPlayerAngles();

	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();

	if ( isSubStr( data.sMeansOfDeath, "MOD_GRENADE" ) || isSubStr( data.sMeansOfDeath, "MOD_EXPLOSIVE" ) || isSubStr( data.sMeansOfDeath, "MOD_PROJECTILE" ) )
	{
		if ( data.sWeapon == "none" && isdefined( data.victim.explosiveInfo["weapon"] ) )
			data.sWeapon = data.victim.explosiveInfo["weapon"];
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
				processScoreEvent( "kill_enemy_injuring_teammate", attacker, victim, data.sWeapon );
				victim recordKillModifier("defender");
			}
		}
	}


	if  (level.teamBased && isdefined( victim.lastAttackedShieldPlayer )  ) 
	{
		if ( victim.lastAttackedShieldPlayer.pers["team"] == attacker.pers["team"] && isDefined( victim.lastAttackedShieldTime ) )
		{
			if ( time - victim.lastAttackedShieldTime < 4000 )
			{
				processScoreEvent( "kill_enemy_shooting_teamshield", attacker, victim, data.sWeapon, true );
			}
		}
	}

	if ( data.sWeapon == "hatchet_mp" )
	{
		attacker.pers["tomahawks"]++;
		attacker.tomahawks = attacker.pers["tomahawks"];
		
		processScoreEvent( "hatchet_kill", attacker, victim, data.sWeapon, true );
		
		if ( isdefined( data.victim.explosiveInfo["projectile_bounced"] ) && data.victim.explosiveInfo["projectile_bounced"] == true )
		{
			level.globalBankshots++;

			processScoreEvent( "bounce_hatchet_kill", attacker, victim, data.sWeapon, true );
		}
	}

	if ( data.sWeapon == "knife_ballistic_mp" && ( data.sMeansOfDeath == "MOD_PISTOL_BULLET" ||  data.sMeansOfDeath == "MOD_HEAD_SHOT" ) )
	{
		processScoreEvent( "ballistic_knife_kill", attacker, victim, data.sWeapon, true );
	}

	if ( data.sWeapon == "supplydrop_mp" || data.sWeapon == "inventory_supplydrop_mp" )
	{
		if ( data.sMeansOfDeath == "MOD_HIT_BY_OBJECT" || data.sMeansOfDeath == "MOD_CRUSH" )
		{
			processScoreEvent( "kill_enemy_with_care_package_crush", attacker, victim, data.sWeapon, true );
		}
		else
		{
			processScoreEvent( "kill_enemy_with_hacked_care_package", attacker, victim, data.sWeapon, true );
		}
	}

	if ( isdefined(  data.victimWeapon ) )
	{
		if ( data.victimWeapon == "minigun_mp" )
		{
			processScoreEvent( "killed_death_machine_enemy", attacker, victim, data.sWeapon, true );
		}
		else if ( data.victimWeapon == "m32_mp" )
		{
			processScoreEvent( "killed_multiple_grenade_launcher_enemy", attacker, victim, data.sWeapon, true );
		}
	}
	
	if ( isplayer( attacker ) && isplayer( victim ) && attacker != victim  )
	{
		attacker thread updateMultiKills( data.sWeapon, weaponClass, killstreak );

		if ( level.numKills == 1 )
		{
			victim recordKillModifier("firstblood");
			processScoreEvent( "first_kill", attacker, victim, data.sWeapon, true );
		}

		if ( !level.teambased || victim.team != attacker.team )
		{
			if ( victim maps\mp\killstreaks\_killstreaks::isOnAKillstreak() )
			{
				level.globalBuzzKills++;
				processScoreEvent( "stop_enemy_killstreak", attacker, victim, data.sWeapon, true );
				victim recordKillModifier("buzzkill");
			}


			if ( is_weapon_valid( data.sMeansOfDeath, data.sWeapon, weaponClass ) )
			{
				if ( isdefined( victim.vAttackerOrigin ) )
					attackerOrigin = victim.vAttackerOrigin;
				else
					attackerOrigin = attacker.origin;
				distToVictim = distanceSquared( victim.origin, attackerOrigin );
				weap_min_dmg_range = get_distance_for_weapon( data.sWeapon, weaponClass );
				if ( weap_min_dmg_range > 0 && distToVictim > weap_min_dmg_range * weap_min_dmg_range )
				{
					
					attacker maps\mp\_challenges::longDistanceKill();
					if ( data.sWeapon == "hatchet_mp" )
					{
						attacker maps\mp\_challenges::longDistanceHatchetKill();
					}
					processScoreEvent( "longshot_kill", attacker, victim, data.sWeapon, true );
					attacker.pers["longshots"]++;
					

					attacker.longshots = attacker.pers["longshots"];	
					victim recordKillModifier("longshot");
				}
			}
		}	
	}

	attacker.lastKillTime = GetTime();

	if ( level.teambased && isdefined( victim.lastKillTime ) && victim.lastKillTime > GetTime() - 3000 )
	{
		if ( victim.lastkilledplayer IsEnemyPlayer( attacker ) == false && attacker != victim.lastkilledplayer )
		{
			processScoreEvent( "kill_enemy_who_killed_teammate", attacker, victim, data.sWeapon );
			victim recordKillModifier("avenger");
		}
	}

	attackerInChopper = attacker IsInVehicle();

	if ( !isAlive( attacker ) && ( isdefined( attacker.deathtime ) && ( attacker.deathtime + 800 ) < getTime() ) && !attackerInChopper )
	{
		if ( !isdefined( attacker.afterlifeMedalTime ) || attacker.afterlifeMedalTime != attacker.deathTime )
		{
			attacker.afterlifeMedalTime = attacker.deathtime;
			level.globalAfterlifes++;
			processScoreEvent( "kill_enemy_after_death", attacker, victim, data.sWeapon );
			victim recordKillModifier("posthumous");
		}
	}
	
	if( attacker.cur_death_streak >= GetDvarint( "perk_deathStreakCountRequired" ) )
	{
		level.globalComebacks++;
		processScoreEvent( "comeback_from_deathstreak", attacker, victim, data.sWeapon, true );
		victim recordKillModifier("comeback");
	}
	
	if ( isdefined( victim.lastManSD ) && victim.lastManSD == true )
	{
		processScoreEvent( "final_kill_elimination", attacker, victim, data.sWeapon, true );
		if ( isdefined( attacker.lastManSD ) && attacker.lastManSD == true )
		{
			processScoreEvent( "elimination_and_last_player_alive", attacker, victim, data.sWeapon, true );
		}
	}

	if ( isdefined ( victim.beingMicrowavedBy ) && data.sWeapon != "microwave_turret_mp" ) 
	{
		if ( victim.beingMicrowavedBy != attacker ) 
		{
			processScoreEvent( "microwave_turret_assist", victim.beingMicrowavedBy, victim, data.sWeapon );
		}
	}

	if ( attacker.health < ( attacker.maxHealth * 0.25 ) && attacker.health > 0 ) 
	{
		processScoreEvent( "kill_enemy_when_injured", attacker, victim, data.sWeapon, true );
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
			processScoreEvent( "backstabber_kill", attacker, victim, data.sWeapon, true );
			attacker.pers["backstabs"]++;
			attacker.backstabs = attacker.pers["backstabs"];	
		}
	}
	
	if ( isdefined ( victim.firstTimeDamaged ) && victim.firstTimeDamaged == time )
	{
		if ( weaponClass == "weapon_sniper" && data.sMeansOfDeath != "MOD_MELEE" )
		{
			processScoreEvent( "kill_enemy_one_bullet", attacker, victim, data.sWeapon, true );
		}
	}

	if ( isdefined ( attacker.lastKilledBy ) )
	{
		if ( attacker.lastKilledBy == victim )
		{
			level.globalPaybacks++;
			processScoreEvent( "revenge_kill", attacker, victim, data.sWeapon );
			victim recordKillModifier("revenge");
			attacker.lastKilledBy = undefined;
		}	
	}

	if ( isDefined( wasDefusing ) && wasDefusing )
	{
		processScoreEvent( "killed_bomb_defuser", attacker, victim, data.sWeapon, true );
	}
	if ( isDefined( wasPlanting ) && wasPlanting )
	{
		processScoreEvent( "killed_bomb_planter", attacker, victim, data.sWeapon, true );
	}
	
	if ( isdefined( attacker.tookWeaponFrom[ data.sWeapon ] ) )
	{
		if ( attacker.tookWeaponFrom[ data.sWeapon ] == victim && data.sMeansOfDeath != "MOD_MELEE" )
			processScoreEvent( "kill_enemy_with_their_weapon", attacker, victim, data.sWeapon, true );
	}

	specificWeaponKill( attacker, victim, data.sWeapon, killstreak );

	if ( isdefined( attacker.dtpTime ) && attacker.dtpTime + 5000 > time )
	{
		processScoreEvent( "kill_enemy_recent_dive_prone", attacker, self, data.sWeapon, true );
	}

	if(  maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( data.sWeapon ) )
		victim recordKillModifier("killstreak");


	attacker.cur_death_streak = 0;
	attacker disabledeathstreak();
}

specificWeaponKill( attacker, victim, weapon, killstreak )
{
	addDemoBookmark = true;
	switchWeapon = weapon;

	if ( isDefined( killstreak ) ) 
	{
		switchWeapon = killstreak;
	}
	switch( switchWeapon ) 
	{
		case "crossbow_mp":
		case "explosive_bolt_mp":
			event = "crossbow_kill";
			break;
		case "rcbomb_mp":
			event = "rcxd_kill";
			break;
		case "remote_missile_mp":
			event = "remote_missile_kill";
			break;
		case "missile_drone_mp":
			event = "missile_drone_kill";
			break;
		case "autoturret_mp":
			event = "sentry_gun_kill";
			break;
		case "planemortar_mp":
			event = "plane_mortar_kill";
			break;
		case "minigun_mp": 
			event = "death_machine_kill";
			break;
		case "m32_mp":
			event = "multiple_grenade_launcher_kill";
			break;
		case "qrdrone_mp":
			event = "qrdrone_kill";
			break;
		case "ai_tank_drop_mp":
			event = "aitank_kill";
			break;
		case "helicopter_guard_mp":
			event = "helicopter_guard_kill";
			break;
		case "straferun_mp":
			event = "strafe_run_kill";
			break;
		case "remote_mortar_mp":
			event = "remote_mortar_kill";
			break;
		case "helicopter_player_gunner_mp":
			event = "helicopter_gunner_kill";
			break;
		case "dogs_mp":
			event = "dogs_kill";
			break;
		case "missile_swarm_mp":
			event = "missile_swarm_kill";
			break;
		case "helicopter_comlink_mp":
			event = "helicopter_comlink_kill";
			break;
		case "microwaveturret_mp":
			event = "microwave_turret_kill";
			break;
		default:
			break;
	}

	if ( isdefined( event ) ) 
	{
		processScoreEvent( event, attacker, victim, weapon, addDemoBookmark );
	}


}

multiKill( killCount, weapon )
{
	assert( killCount > 1 );
	
	self maps\mp\_challenges::multiKill( killCount, weapon );

	if ( killCount > 8 ) 
	{
		processScoreEvent( "multikill_more_than_8", self, undefined, weapon, true );
	}
	else
	{
		processScoreEvent( "multikill_" + killCount, self, undefined, weapon, true );
	}
	self recordmultikill( killCount );
}

is_weapon_valid( meansOfDeath, weapon, weaponClass )
{
	valid_weapon = false;
	
	if( weapon == "minigun_mp" )
		valid_weapon = false;
	else if ( meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_RIFLE_BULLET" )
		valid_weapon = true;
	else if ( meansOfDeath == "MOD_HEAD_SHOT" )
		valid_weapon = true;
	else if ( get_distance_for_weapon( weapon, weaponClass ) )
		valid_weapon = true;

	return valid_weapon;
}


updatemultikills( weapon, weaponClass, killstreak )
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateRecentKills" );
	self endon ( "updateRecentKills" );
	if ( !isdefined (self.recentKillCount) )
		self.recentKillCount = 0;
	self.recentKillCount++;

	if ( !isdefined (self.recent_LMG_SMG_KillCount) )
		self.recent_LMG_SMG_KillCount = 0;
	if ( !isdefined (self.recentRemoteMissileKillCount) )
		self.recentRemoteMissileKillCount = 0;
	if ( !isdefined (self.recentRemoteMissileAttackerKillCount) )
		self.recentRemoteMissileAttackerKillCount = 0;
	if ( !isdefined (self.recentRCBombKillCount) )
		self.recentRCBombKillCount = 0;
	if ( !isdefined (self.recentRCBombAttackerKillCount) )
		self.recentRCBombAttackerKillCount = 0;
	if ( !isdefined (self.recentMGLKillCount) )
		self.recentMGLKillCount = 0;

	if ( isdefined( weaponClass ) )
	{
		if ( weaponClass == "weapon_lmg" || weaponClass == "weapon_smg" )
		{
			if ( self PlayerAds() < 1.0 ) 
			{
				self.recent_LMG_SMG_KillCount++;
			}
		}
	}
	if ( isdefined ( killstreak ) ) 
	{
		switch( killstreak ) 
		{
		case "remote_missile_mp":
			self.recentRemoteMissileKillCount++;
			break;
		case "rcbomb_mp":
			self.recentRCBombKillCount++;
			break;
		case "mgl_mp":
			self.recentMGLKillCount++;
			break;
		}
	}

	wait ( 4.0 );

	if ( self.recent_LMG_SMG_KillCount >= 3 )
		self maps\mp\_challenges::multi_LMG_SMG_Kill();	

	if ( self.recentKillCount > 1 )
		self multiKill( self.recentKillCount, weapon );
	
	self.recentKillCount = 0;
	self.recent_LMG_SMG_KillCount = 0;
	self.recentRemoteMissileKillCount = 0;
	self.recentRemoteMissileAttackerKillCount = 0;
	self.recentRCBombKillCount = 0;
	self.recentMGLKillCount = 0;
}

get_distance_for_weapon( weapon, weaponClass )
{
	// this is special for the long shot medal
	// need to do this on a per weapon category basis, to better control it

	distance = 0;
	
	switch ( weaponClass )
	{
		case "weapon_smg":
			distance = 1250;
			break;

		case "weapon_assault":
			distance = 1500;
			break;

		case "weapon_lmg":
			distance = 1500;
			break;

		case "weapon_sniper":
			distance = 1750;
			break;

		case "weapon_pistol":
			distance = 700;
			break;
			
		case "weapon_cqb":
			distance = 650;
			break;


		case "weapon_special":
			{
				if( weapon == "knife_ballistic_mp" )
				{
					distance = 1500;	
				}
				else if ( weapon == "crossbow_mp" )
				{
					distance = 1500;
				}
				else if ( weapon == "metalstorm_mp" )
				{
					distance = 1750;
				}
			}
			break;
		case "weapon_grenade":
			if ( weapon ==  "hatchet_mp" ) 
			{
				distance = 2500;
			}
			break;
		default:
			distance = 0;
			break;
	}

	return distance;
}


decrementLastObituaryPlayerCountAfterFade() 
{
	level endon( "reset_obituary_count" );
	wait( SCORE_EVENT_OBITUARY_CENTERTIME );
	level.lastObituaryPlayerCount--;
	assert( level.lastObituaryPlayerCount >= 0 );
}


