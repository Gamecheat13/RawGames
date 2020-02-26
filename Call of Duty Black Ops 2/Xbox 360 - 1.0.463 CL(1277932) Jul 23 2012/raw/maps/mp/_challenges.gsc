// some common functions between all the air kill streaks
#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	if ( !isdefined( level.ChallengesCallbacks ) )
	{
		level.ChallengesCallbacks = [];
	}		
	
	registerChallengesCallback( "playerKilled", ::challengeKills );	
	registerChallengesCallback( "gameEnd", ::challengeGameEnd );
	level thread onPlayerConnect();
	
	foreach( team in level.teams )
	{
		initTeamChallenges( team );
	}
}

canProcessChallenges()
{
/#	
	if ( GetDvarIntDefault( "scr_debug_challenges", 0 ) ) 
		return true;
#/

	if ( ( level.rankedMatch || level.wagerMatch ) && !level.leagueMatch ) 
	{
		return true;
	}
	
	return false;
}

initTeamChallenges( team )
{
	if ( !isdefined( game["challenge"] ) ) 
	{
		game["challenge"] = [];
	}
	
	if ( !isdefined ( game["challenge"][team] ) )
	{
		game["challenge"][team] = [];
		game["challenge"][team]["plantedBomb"] = false;
		game["challenge"][team]["destroyedBombSite"] = false;
		game["challenge"][team]["capturedFlag"] = false;
	}
	game["challenge"][team]["allAlive"] = true;
}

registerChallengesCallback(callback, func)
{
	if (!isdefined(level.ChallengesCallbacks[callback]))
		level.ChallengesCallbacks[callback] = [];
	level.ChallengesCallbacks[callback][level.ChallengesCallbacks[callback].size] = func;
}

doChallengeCallback( callback, data )
{
	if ( !isDefined( level.ChallengesCallbacks ) )
		return;		
			
	if ( !isDefined( level.ChallengesCallbacks[callback] ) )
		return;
	
	if ( isDefined( data ) ) 
	{
		for ( i = 0; i < level.ChallengesCallbacks[callback].size; i++ )
			thread [[level.ChallengesCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.ChallengesCallbacks[callback].size; i++ )
			thread [[level.ChallengesCallbacks[callback][i]]]();
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread initChallengeData();
		player thread spawnWatcher();
	}
}

initChallengeData()
{	
	self.pers["bulletStreak"] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["stickExplosiveKill"] = 0;
	
	self.explosiveInfo = [];
}



challengeKills( data, time )
{
	victim = 		data.victim;
	player = 		data.attacker;
	attacker = 		data.attacker;
	time = 			data.time;
	victim = 		data.victim;
	weapon = 		data.sWeapon;
	time = 			data.time;
	inflictor =		data.eInflictor;
	meansOfDeath = 	data.sMeansOfDeath;
	wasPlanting = 	data.wasPlanting;
	wasDefusing = 	data.wasDefusing;


	if ( !canProcessChallenges() ) 
		return;

	if ( !isdefined( data.sWeapon ))
		return;
	
	if ( !isdefined( player ) || !isplayer( player ) )
		return;

// need to make it no ai controlled killstreak weapons
//	if( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( data.sWeapon )  )
//	 	return;

	weaponClass = WeaponClass( weapon );

	game["challenge"][victim.team]["allAlive"] = false;
		
	if ( level.teambased ) 
	{
		if ( player.team == victim.team )
			return;
	}
	else 
	{
		if ( player == victim )
			return;
	}
	

	//// this doesnt work
	//if ( level.teambased )
	//{
	//	if ( maps\mp\killstreaks\_radar::teamHasSpyplane( player.team ) ) 
	//	{
	//		player addChallengeStat( "KILLSTREAK_KILLS_U2", 1 );
	//	}
	//	if ( maps\mp\killstreaks\_radar::teamHasSatellite( player.team ) ) 
	//	{
	//		player addChallengeStat( "KILLSTREAK_KILLS_SATELLITE", 1 );
	//	}
	//	if ( level.activeCounterUAVs[player.team] > 0 )
	//	{
	//		player addChallengeStat( "KILLSTREAK_KILLS_COUNTER_U2", 1 );
	//	} 
	//}
	//else
	//{
	//	if ( isdefined( player.hasSpyplane) && player.hasSpyplane == true ) 
	//	{
	//		player addChallengeStat( "KILLSTREAK_KILLS_U2", 1 );
	//	}
	//	if ( isdefined( player.hasSatellite ) && player.hasSatellite == true ) 
	//	{
	//		player addChallengeStat( "KILLSTREAK_KILLS_SATELLITE", 1 );
	//	}
	//	if ( isdefined( player.entnum ) && isdefined( level.activeCounterUAVs[player.entnum] ) && level.activeCounterUAVs[player.entnum] > 0 ) 
	//	{
	//		player addChallengeStat( "KILLSTREAK_KILLS_COUNTER_U2", 1 );
	//	}
	//}

	if ( victim maps\mp\_flashgrenades::isFlashbanged() )
	{
		player addChallengeStat( "kill_flashed_enemy", 1 );
	}
	if ( isdefined( victim.concussionEndTime ) && victim.concussionEndTime > gettime() )
	{
		player addChallengeStat( "kill_concussed_enemy", 1 );
	}
	if ( isdefined( player.lastStunnedBy ) ) 
	{
		if ( player.lastStunnedBy == victim && player.lastStunnedTime + 5000 > time )
		{
			player addChallengeStat( "kill_enemy_who_shocked_you", 1 );
		}
	}
	if ( isdefined( victim.lastStunnedBy ) && victim.lastStunnedTime + 5000 > time ) 
	{
		player addChallengeStat( "kill_shocked_enemy", 1 );
		
		if ( victim.lastStunnedBy == player ) 
		{
			if ( data.sMeansOfDeath == "MOD_MELEE" )
			{
				player addChallengeStat( "shock_enemy_then_stab_them", 1 );
			}
		}
	}

	if ( player.mantleTime + 5000 > time ) 
	{
		player addChallengeStat( "mantle_then_kill", 1 );
	}
	
	if ( isdefined( player.tookweaponfrom ) && isdefined( player.tookweaponfrom[weapon] ) )
	{
		if ( level.teambased )
		{
			if ( player.tookweaponfrom[weapon].team != player.team )
			{
				player.pickedUpWeaponKills[weapon]++;
				player addChallengeStat( "kill_enemy_with_picked_up_weapon", 1 );
			}
		}
		else
		{
			player.pickedUpWeaponKills[weapon]++;
			player addChallengeStat( "kill_enemy_with_picked_up_weapon", 1 );
		}
		if ( player.pickedUpWeaponKills[weapon] >= 5 ) 
		{
			player.pickedUpWeaponKills[weapon] = 0;
			player addChallengeStat( "killstreak_5_picked_up_weapon", 1 );
		}
	}


	if ( isdefined( data.victim.explosiveInfo["originalowner"] ) && isplayer( data.victim.explosiveInfo["originalowner"] ) ) 
	{
		originalOwner = data.victim.explosiveInfo["originalowner"];
		if (  data.victim.explosiveInfo["damageExplosiveKill"] == true )
		{
			if ( level.teambased ) 
			{
				if ( originalOwner.team != attacker.team ) 
				{
					player addChallengeStat( "kill_enemy_shoot_their_explosive", 1 );
				}
				
			}
			else
			{
				if( originalOwner != attacker ) 
				{
					player addChallengeStat( "kill_enemy_shoot_their_explosive", 1 );
				}
			}
		}
	}
	
	if ( data.attackerStance == "crouch" )
	{
		player addChallengeStat( "kill_enemy_while_crouched", 1 );
	}
	else if ( data.attackerStance == "prone" )
	{
		player addChallengeStat( "kill_enemy_while_prone", 1 );
	}

	if ( data.victimStance == "prone" )
	{
		player addChallengeStat( "kill_prone_enemy", 1 );
	}

	if ( data.sMeansOfDeath == "MOD_HEAD_SHOT" || data.sMeansOfDeath == "MOD_PISTOL_BULLET" || data.sMeansOfDeath == "MOD_RIFLE_BULLET" )
	{
		player genericBulletKill( data, victim, weapon );
	}
	
	if ( level.teamBased )
	{
		if ( level.playerCount[victim.pers["team"]] > 3 && player.pers["killed_players"].size >= level.playerCount[victim.pers["team"]] )
			player addChallengeStat( "kill_every_enemy", 1 );
	}

	switch( weaponClass )
	{
		case "weapon_pistol":
		{
			if ( data.sMeansOfDeath == "MOD_HEAD_SHOT" )
			{
				player.pers["pistolHeadshot"]++;
				if ( player.pers["pistolHeadshot"] >= 10 )
				{
					player.pers["assaultRifleHeadshot"] = 0;
					player addChallengeStat( "pistolHeadshot_10_onegame", 1 );
					
				}
			}
		}
		break;
		case "weapon_assault":
		{
			if ( data.sMeansOfDeath == "MOD_HEAD_SHOT" )
			{
				player.pers["assaultRifleHeadshot"]++;
				if ( player.pers["assaultRifleHeadshot"] >= 10 )
				{
					player.pers["assaultRifleHeadshot"] = 0;
					player addChallengeStat( "headshot_assault_10_onegame", 1 );
				}
			}
		}
		break;
		case "weapon_lmg":
		case "weapon_smg":
		{
		}
		break;
		case "weapon_sniper":
		{
			if ( isdefined ( victim.firstTimeDamaged ) && victim.firstTimeDamaged == time )
			{
				player addChallengeStat( "kill_enemy_one_bullet_sniper", 1 );
			}
		}
		break;
		case "weapon_cqb":
		{
			if ( isdefined ( victim.firstTimeDamaged ) && victim.firstTimeDamaged == time )
			{
				player addChallengeStat( "kill_enemy_one_bullet_shotgun", 1 );
			}
		}
		break;
	}

	switch( weapon )
	{
		case "hatchet_mp":
			if ( isdefined ( inflictor.lastWeaponBeforeToss ) ) 
			{
				if ( inflictor.lastWeaponBeforeToss == level.riotshield_name ) 
				{
					player addChallengeStat( "hatchet_kill_with_shield_equiped", 1 );
				}
			}
			break;
		case "claymore_mp":
			player addChallengeStat( "kill_with_claymore", 1 );
			if ( inflictor maps\mp\gametypes\_weaponobjects::isHacked() )
			{
				player addChallengeStat( "kill_with_hacked_claymore", 1 );
			}
			break;
		case "satchel_charge_mp":
			player addChallengeStat( "kill_with_c4", 1 );
			break;
		case "destructible_car_mp":
			player addChallengeStat( "kill_enemy_withcar", 1 );
			break;
		case "sticky_grenade_mp":
			{
				if ( isdefined( victim.explosiveInfo["stuckToPlayer"] ) && victim.explosiveInfo["stuckToPlayer"] == victim ) 
				{
					attacker.pers["stickExplosiveKill"]++;
					if ( attacker.pers["stickExplosiveKill"] >= 5 ) 
					{
						attacker.pers["stickExplosiveKill"] = 0;
						player addChallengeStat( "stick_explosive_kill_5_onegame", 1 );
					}
				}
			}
			// fall through
		case "frag_grenade_mp":
			{
				player notify( "lethalGrenadeKill" );
				if ( isdefined( data.victim.explosiveInfo["cookedKill"] ) && data.victim.explosiveInfo["cookedKill"] == true )
				{
					player addChallengeStat( "kill_with_cooked_grenade", 1 );
				}
				if ( isdefined( data.victim.explosiveInfo["throwbackKill"] ) && data.victim.explosiveInfo["throwbackKill"] == true )
				{
					player addChallengeStat( "kill_with_tossed_back_lethal", 1 );
				}
			}
			break;
		case "knife_held_mp":
		case "knife_mp":
		case "knife_ballistic_mp":
			{
				player bladeKill();
			}
	}
	
	//if ( level.teamBased )
	//{
	//	if ( level.playerCount[data.victim.pers["team"]] > 3 && player.pers["killed_players"].size >= level.playerCount[data.victim.pers["team"]] )
	//	{
	//		player addChallengeStat( "KILLS_ENTIRE_TEAM", 1 );

	//		player.pers["killed_players"] = [];
	//	}
	//}
	//
	//if ( isHighestScoringPlayer( victim ) && victim.score > 1 )
	//{
	//	player addChallengeStat( "KILLS_MVP", 1 );
	//}
	//
	//
	//if ( isdefined( wasDefusing ) && wasDefusing == true )
	//{
	//	switch ( level.gameType )
	//	{
	//	case "sab":
	//		{
	//			player addChallengeStat( "GM_SAB_DEFUSER_KILLS", 1 );
	//		}
	//	break;
	//	case "sd":
	//		{
	//			if ( level.hardcoreMode ) 
	//			{
	//				player addChallengeStat( "GM_HCSD_DEFUSER_KILLS", 1 );
	//			}
	//			else
	//			{
	//				player addChallengeStat( "GM_SD_DEFUSER_KILLS", 1 );
	//			}
	//		}
	//		break;
	//	case "dem":
	//		{
	//			player addChallengeStat( "GM_DEM_DEFUSER_KILLS", 1 );
	//		}
	//		break;
	//	}
	//}
	//
	//if ( isdefined( wasPlanting ) && wasPlanting == true )
	//{
	//	switch ( level.gameType )
	//	{
	//	case "sab":
	//		{
	//			player addChallengeStat( "GM_SAB_PLANTER_KILLS", 1 );
	//		}
	//	break;
	//	case "sd":
	//		{
	//			if ( level.hardcoreMode ) 
	//			{
	//				player addChallengeStat( "GM_HCSD_PLANTER_KILLS", 1 );
	//			}
	//			else
	//			{
	//				player addChallengeStat( "GM_SD_PLANTER_KILLS", 1 );
	//			}
	//		}
	//		break;
	//	case "dem":
	//		{
	//			player addChallengeStat( "GM_DEM_PLANTER_KILLS", 1 );
	//		}
	//		break;
	//	}
	//}
}


genericBulletKill( data, victim, weapon ) 
{
	if ( !canProcessChallenges() ) 
		return;

	player = self;
	time = data.time;
	
	if ( player.pers["lastBulletKillTime"] == time )
		player.pers["bulletStreak"]++;
	else
		player.pers["bulletStreak"] = 1;
	
	player.pers["lastBulletKillTime"] = time;

	//if ( player.pers["bulletStreak"] == 2 )
	//	player addChallengeStat( "KILLS_BULLET_MULTI", 1 );		

	if ( data.victim.iDFlagsTime == time )
	{
		if ( data.victim.iDFlags & level.iDFLAGS_PENETRATION )
			player addChallengeStat( "kill_enemy_through_wall", 1 );		
	}
	
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
			
		if ( players[i] == player )
			continue;

		if ( players[i].score < 1 )
			continue;

		if ( team != "all" && players[i].pers["team"] != team )
			continue;
		// tied for first is no longer counted
		if ( players[i].score >= highScore )
			return false;
	}
	
	return true;
}

spawnWatcher()
{
	self endon("disconnect");
	self.pers["stickExplosiveKill"] = 0;
	self.pers["pistolHeadshot"] = 0;
	self.pers["assaultRifleHeadshot"] = 0;
	self.pers["killNemesis"] = 0;
	while(1)
	{
		self waittill("spawned_player");
		self.pers["longshotsPerLife"] = 0;

		self thread watchForDTP();
		self thread watchForMantle();
	}
}

watchForDTP()
{
	self.dtpTime = 0;
	while(1)
	{
		self waittill( "dtp_end" );
		self.dtpTime = getTime() + 4000;
	}
}


watchForMantle()
{
	self.mantleTime = 0;
	while(1)
	{
		self waittill( "mantle_start", mantleEndTime );
		self.mantleTime = mantleEndTime;
	}
}



destroyed_car()
{
	if ( !canProcessChallenges() ) 
		return;

	if ( !isdefined( self ) || !isplayer( self ) )
		return;

	self addChallengeStat( "destroy_car", 1 );	
}


killedNemesis()
{
	if ( !canProcessChallenges() ) 
		return;

	self.pers["killNemesis"]++;
	if ( self.pers["killNemesis"] >= 5 )
	{
		self.pers["killNemesis"] = 0;
		self addChallengeStat( "kill_nemesis", 1 );	
	}
}

longDistanceHatchetKill()
{
	if ( !canProcessChallenges() ) 
		return;

	self addChallengeStat( "long_distance_hatchet_kill", 1 );	
}

longDistanceKill()
{
	if ( !canProcessChallenges() ) 
		return;

	self.pers["longshotsPerLife"]++;
	if ( self.pers["longshotsPerLife"] >= 3 )
	{
		self.pers["longshotsPerLife"] = 0;
		self addChallengeStat( "longshot_3_onelife", 1 );	
	}
}



challengeRoundEnd( data )
{
	if ( !canProcessChallenges() ) 
		return;

	player = data.player;
	winner = data.winner;
	
	if ( endedEarly( winner ) )
		return;
	
	winnerScore = game["teamScores"][winner];
	loserScore = getLosersTeamScores( winner );
	
	switch ( level.gameType )
	{
		case "tdm":
			{
			}
			break;
		case "dm":
			{
			}
			break;
		case "sab":
			{
			}
			break;
		case "sd":
			{
			}
			break;
		case "ctf":
			{
			}
			break;
		case "dom":
			{
			}
			break;
		case "koth":
			{
			}
			break;
		case "hq":
			{
			}
			break;
		case "dem":
			{
			}
			break;
		default:
			break;
	}
}

roundEnd( winner )
{
	if ( !canProcessChallenges() ) 
		return;

	wait(0.05);
	data = spawnstruct();
	data.time = getTime();
	if ( level.teamBased )
	{
		if ( isdefined( winner ) && isdefined( level.teams[winner] ) ) 
		{
			data.winner = winner;
		}
	}
	else
	{
		if ( isdefined( winner ) ) 
		{
			data.winner = winner;
		}
	}
	
	
	for ( index = 0; index < level.placement["all"].size; index++ )
	{
		data.player = level.placement["all"][index];
		data.place = index;

		doChallengeCallback( "roundEnd", data );
	}		
}

gameEnd(winner )
{
	if ( !canProcessChallenges() ) 
		return;

	wait(0.05);
	data = spawnstruct();
	data.time = getTime();
	if ( level.teamBased )
	{
		if ( isdefined( winner ) && isdefined( level.teams[winner] ) ) 
		{ 
			data.winner = winner;
		}
	}
	else
	{
		if ( isdefined( winner ) && isplayer( winner) ) 
		{
			data.winner = winner;
		}
	}
	
	
	for ( index = 0; index < level.placement["all"].size; index++ )
	{
		data.player = level.placement["all"][index];
		data.place = index;

		doChallengeCallback( "gameEnd", data );
	}		
}

getFinalKill( player )
{
	if ( !canProcessChallenges() ) 
		return;

	player addChallengeStat( "get_final_kill", 1 );
}

destroyRCBombWithHatchet( player )
{
	if ( !canProcessChallenges() ) 
		return;

	player addChallengeStat( "destroy_rcbomb_with_hatchet", 1 );
}

killedFlagCarrier()
{
	if ( !canProcessChallenges() ) 
		return;

	//self addChallengeStat( "GM_CTF_FLAG_CARRIER_KILLS", 1 );
}

killedBombCarrier()
{
	if ( !canProcessChallenges() ) 
		return;

	switch ( level.gameType )
	{
			case "sab":
				//self addChallengeStat( "GM_SAB_BOMB_CARRIER_KILLS", 1 );
				break;
			case "sd":
				{	
					if ( level.hardcoreMode ) 
					{
						//self addChallengeStat( "GM_HCSD_BOMB_CARRIER_KILLS", 1 );							
					}
					else
					{
						//self addChallengeStat( "GM_SD_BOMB_CARRIER_KILLS", 1 );
					}
				}
				break;
	}
	
}

dominated( team )
{
	if ( !canProcessChallenges() ) 
		return;

	//teamCompletedChallenge( team, "GM_DOM_DOMINATE" );
}

destroyedEquipment()
{
	if ( !canProcessChallenges() ) 
		return;

	self addChallengeStat( "destroy_equipment", 1 );
}

destroyedTacticalInsert()
{
	if ( !canProcessChallenges() ) 
		return;

	if ( !isdefined( self.pers["tacticalInsertsDestroyed"] ) )
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
	}
	self.pers["tacticalInsertsDestroyed"]++;
	if ( self.pers["tacticalInsertsDestroyed"] >= 5 ) 
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
		self addChallengeStat( "destroy_5_tactical_inserts", 1 );
	}
}

bladeKill()
{
	if ( !canProcessChallenges() ) 
		return;

	if ( !isdefined( self.pers["bladeKills"] ) )
	{
		self.pers["bladeKills"] = 0;
	}
	self.pers["bladeKills"]++;
	if ( self.pers["bladeKills"] >= 15 ) 
	{
		self.pers["bladeKills"] = 0;
		self addChallengeStat( "kill_15_with_blade", 1 );
	}
}
		
destroyedExplosive()
{
	if ( !canProcessChallenges() ) 
		return;

	self addChallengeStat( "destroy_equipment", 1 );
}

assisted()
{
	if ( !canProcessChallenges() ) 
		return;

	self addChallengeStat( "assist", 1 );
}



teamCompletedChallenge( team, challenge ) 
{	
	if ( !canProcessChallenges() ) 
		return;

	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if (isdefined( players[i].team ) && players[i].team == team )
		{		
			players[i] addChallengeStat( challenge, 1 );
		}
	}	
}

endedEarly( winner )
{
	if ( !canProcessChallenges() ) 
		return;

	if ( level.hostForcedEnd )
		return true;
	
	if ( !isdefined( winner ) ) 
		return true;

	if ( level.teambased ) 
	{	
		if ( winner == "tie" )
			return true;
	}

	return false;
}

getLosersTeamScores( winner )
{
	teamScores = 0;
	
	foreach ( team in level.teams )
	{
		if ( team == winner )
			continue;
			
		teamScores += game["teamScores"][team];
	}
	
	return teamScores;
}

didLoserFailChallenge( winner, challenge )
{
	foreach ( team in level.teams )
	{
		if ( team == winner )
			continue;

		if ( game["challenge"][team][challenge] )
			return false;
	}
	
	return true;
}

challengeGameEnd( data )
{
	if ( !canProcessChallenges() ) 
		return;

	player = data.player;
	winner = data.winner;
	
	if ( endedEarly( winner ) )
		return;

	//player addChallengeStat( "BASIC_COMPLETE_MATCHES_PLAYED", 1 );

	if ( !level.teambased ) 
		return;
	
	gameLength = game["timepassed"] / 1000;

	roundsWon = maps\mp\_utility::getRoundsWon( winner );
	roundsWonLosers = maps\mp\_utility::getOtherTeamsRoundsWon( winner );
	roundsPlayed = maps\mp\_utility::getRoundsPlayed();
	
	winnerScore = game["teamScores"][winner];
	loserScore = getLosersTeamScores( winner );
	
	switch ( level.gameType )
	{
		case "ctf":
		{
		}
		break;
		case "sab":
		{
		}
		break;
		case "sd":
		{
		}
		break;
		case "dem":
		{
		}	
		break;
		default:
			break;
	}	
}

multiKill( killCount, weapon )
{
	if ( !canProcessChallenges() ) 
		return;

	//self addChallengeStat( "BASIC_MULTI_KILLS", 1 );

	if ( killCount >= 3 )
	{
		if ( self.health < ( self.maxHealth * 0.25 ) && self.health > 0 ) 
		{
			self addChallengeStat( "multikill_3_near_death", 1 );
		}
	}
}

multi_LMG_SMG_Kill()
{
	if ( !canProcessChallenges() ) 
		return;

	self addChallengeStat( "multikill_3_lmg_or_smg_hip_fire", 1 );
}

fullClipNoMisses( weaponClass, weapon )
{
	//if ( !canProcessChallenges() ) 
	//	return;

	//player = self;
	//switch( weaponClass )
	//{
	//	case "weapon_pistol":
	//	{
	//		player addChallengeStat( "KILLS_NO_MISSES_PISTOL", 1 );
	//	}
	//	break;
	//	case "weapon_smg":
	//	{
	//		player addChallengeStat( "KILLS_NO_MISSES_SMG", 1 );
	//	}
	//	break;
	//	case "weapon_assault":
	//	{
	//		player addChallengeStat( "KILLS_NO_MISSES_ASSAULT", 1 );
	//	}
	//	break;
	//	case "weapon_lmg":
	//	{
	//		player addChallengeStat( "KILLS_NO_MISSES_LMG", 1 );
	//	}
	//	break;
	//	case "weapon_sniper":
	//	{
	//		player addChallengeStat( "KILLS_NO_MISSES_SNIPER", 1 );
	//	}
	//	break;
	//	case "weapon_cqb":
	//	{
	//		clipSize = WeaponClipSize(weapon);
	//		if ( isdefined ( clipSize ) && clipSize == 2 )
	//		{
	//			player addChallengeStat( "KILLS_NO_MISSES_CQB", 1 );
	//		}
	//	}
	//	break;
	//}
}


earnedKillstreak( killstreak )
{
	//if ( !canProcessChallenges() ) 
	//	return;

	//statNameForKillstreak = "";
	//switch( killstreak )
	//{
	//	case "killstreak_spyplane":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_U2";
	//	break;
	//	case "killstreak_supply_drop":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_SUPPLY_DROP";
	//	break;
	//	case "killstreak_auto_turret_drop":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_SENTRY_GUN";
	//	break;
	//	case "killstreak_tow_turret_drop":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_SAM_TURRET";
	//	break;
	//	case "killstreak_mortar":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_MORTAR";
	//	break;
	//	case "killstreak_napalm":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_NAPALM";
	//	break;
	//	case "killstreak_spyplane_direction":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_SATELLITE";
	//	break;
	//	case "killstreak_helicopter_comlink":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_COMLINK";
	//	break;
	//	case "killstreak_helicopter_gunner":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_CHOPPER_GUNNER";
	//	break;
	//	case "killstreak_counteruav":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_COUNTER_U2";
	//	break;
	//	case "killstreak_airstrike":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_AIRSTRIKE";
	//	break;
	//	case "killstreak_helicopter_player_firstperson":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_GUNSHIP";
	//	break;
	//	case "killstreak_dogs":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_DOGS";
	//	break;
	//	case "killstreak_m220_tow_drop":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_M220";
	//	break;
	//	case "killstreak_rcbomb":
	//		statNameForKillstreak = "KILLSTREAK_EARNED_RCBOMB";
	//	break;			
	//}
	//
	//if ( statNameForKillstreak != "" )
	//{
	//	self addChallengeStat( "KILLSTREAK_EARNED", 1 );
	//	self addChallengeStat( statNameForKillstreak, 1 );
	//}
}

destroyedHelicopter( attacker, weapon )
{
	if ( !canProcessChallenges() ) 
		return;

	attacker addChallengeStat( "destroy_helicopter", 1 );
}

scavengedGrenade()
{
	self endon("disconnect");
	self endon("death");
	self notify("scavengedGrenade");
	self endon("scavengedGrenade");

	for(;;)
	{
		self waittill( "lethalGrenadeKill" );	
		self addChallengeStat( "kill_with_resupplied_lethal_grenade", 1 );
	}
}

stunnedTankWithEMPGrenade( attacker )
{
	attacker addChallengeStat( "stun_aitank_wIth_emp_grenade", 1 );
}


playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc, attackerStance )
{
/#	print(level.gameType);	#/
	self.anglesOnDeath = self getPlayerAngles();
	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();
	if ( !isdefined( sWeapon ) )
		sWeapon = "none";
	
	self endon("disconnect");

	data = spawnstruct();

	data.victim = self;
	data.victimStance = self getStance();
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.attackerStance = attackerStance;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;
	data.time = gettime();
	data.wasPlanting = data.victim.isplanting;
	if ( !isdefined( data.wasPlanting ) ) 
	{
		data.wasPlanting = false;
	}
	data.wasDefusing = data.victim.isdefusing;
	if ( !isdefined( data.wasDefusing ) ) 
	{
		data.wasDefusing = false;
	}	
	data.victimWeapon = data.victim.currentWeapon;
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerOnGround = data.attacker isOnGround();
		if ( !isdefined( data.attackerStance ) ) 
		{
			data.attackerStance = data.attacker getStance();
		}
	}
	else
	{
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
	
	level thread doChallengeCallback( "playerKilled", data );
	level thread maps\mp\_scoreevents::doScoreEventCallback( "playerKilled", data );
}

weaponIsKnife( weapon ) 
{
	if ( weapon == "knife_held_mp" || weapon == "knife_mp" || weapon == "knife_ballistic_mp" )
	{
		return true;
	}

	return false;
}


addChallengeStat( name, count )
{	
/#
	if ( GetDvarIntDefault( "scr_debug_challenges", 0 ) ) 
	{
		self iprintln( "***CHALLENGES***" + name + "\n" );
	}
#/
	self AddPlayerStat( name, count );
}

