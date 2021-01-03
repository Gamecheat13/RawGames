#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_emp;

                              

#namespace challenges;

function autoexec __init__sytem__() {     system::register("challenges",&__init__,undefined,undefined);    }

function __init__()
{
	challenges::init_shared();
	
	callback::on_start_gametype( &start_gametype );	
}

function start_gametype()
{
	if ( !isdefined( level.ChallengesCallbacks ) )
	{
		level.ChallengesCallbacks = [];
	}
	
	waittillframeend;
	
	
	if ( isdefined ( level.scoreEventGameEndCallback ) )
	{
		challenges::registerChallengesCallback( "gameEnd",level.scoreEventGameEndCallback );
	}
	
	if ( canProcessChallenges() )
	{
		challenges::registerChallengesCallback( "playerKilled",&challengeKills );	
		challenges::registerChallengesCallback( "gameEnd",&challengeGameEnd );
		challenges::registerChallengesCallback( "roundEnd",&challengeRoundEnd );
	}

	callback::on_connect( &on_player_connect );
	
	foreach( team in level.teams )
	{
		initTeamChallenges( team );
	}
}

function challengeKills( data, time )
{
	victim = 				data.victim;
	player = 				data.attacker;
	attacker = 				data.attacker;
	time = 					data.time;
	victim = 				data.victim;
	weapon = 				data.weapon;
	time = 					data.time;
	inflictor =				data.eInflictor;
	meansOfDeath = 			data.sMeansOfDeath;
	wasPlanting = 			data.wasPlanting;
	wasDefusing = 			data.wasDefusing;
	lastWeaponBeforeToss =	data.lastWeaponBeforeToss;
	ownerWeaponAtLaunch = 	data.ownerWeaponAtLaunch;
	
	if ( !isdefined( data.weapon ) )
	{
		return;
	}
	
	if ( !isdefined( player ) || !isplayer( player ) || ( weapon == level.weaponNone ) )
	{
		return;
	}

	weaponClass = util::getWeaponClass( weapon );

	game["challenge"][victim.team]["allAlive"] = false;
		
	if ( level.teambased ) 
	{
		if ( player.team == victim.team )
		{
			return;
		}
	}
	else 
	{
		if ( player == victim )
		{
			return;
		}
	}	

	if ( isDamageFromPlayerControlledAITank( player, inflictor, weapon ) ) 
	{
		player AddPlayerStat( "kill_with_remote_control_ai_tank", 1 );
	}
		
	if ( weapon.name == "auto_gun_turret" )
	{
		if ( isdefined ( inflictor ) ) 
		{
			if ( !isdefined( inflictor.killCount ) )
			{
				inflictor.killcount = 0;
			}
			inflictor.killcount++;
			if ( inflictor.killcount >= 5 ) 
			{
				inflictor.killcount = 0;
				player AddPlayerStat( "killstreak_5_with_sentry_gun", 1 );
			}
		}

		if ( isDamageFromPlayerControlledSentry( player, inflictor, weapon ) )
		{
			player AddPlayerStat( "kill_with_remote_control_sentry_gun", 1 );
		}
	}

	if ( weapon.name == "minigun" || weapon.name == "inventory_minigun" )
	{
		player.deathMachineKills++;
		
		if ( player.deathMachineKills >= 5 )
		{
			player.deathMachineKills = 0;
			player AddPlayerStat( "killstreak_5_with_death_machine", 1 );
		}
	}
	
	if ( data.wasLockingOn && weapon.name == "chopper_minigun" )
	{
		player AddPlayerStat( "kill_enemy_locking_on_with_chopper_gunner", 1 );
	}

	if ( isdefined( level.isKillstreakWeapon ) )
	{
		if ( [[level.isKillstreakWeapon]]( weapon ) )
		{
			return;
		}
	}
	
	attacker notify( "killed_enemy_player", time, weapon );
	
	if ( ( isdefined (player.primaryLoadoutWeapon ) && weapon == player.primaryLoadoutWeapon ) 
		||  ( isdefined (player.primaryLoadoutAltWeapon ) && weapon == player.primaryLoadoutAltWeapon ) )
	{
		if ( player IsBonusCardActive( 0, player.class_num ) )
		{
			player AddBonusCardStat( 0, "kills", 1, player.class_num );
			player AddPlayerStat( "kill_with_loadout_weapon_with_3_attachments", 1 );
		}
		if ( isdefined( player.secondaryWeaponKill ) && player.secondaryWeaponKill == true )
		{
			player.primaryWeaponKill = false;
			player.secondaryWeaponKill = false;
			if ( player IsBonusCardActive( 2, player.class_num ) )
			{
				player AddBonusCardStat( 2, "kills", 1, player.class_num );
				player AddPlayerStat( "kill_with_both_primary_weapons", 1 );
			}
		}
		else
		{
			player.primaryWeaponKill = true;
		}
	}
	else if ( ( isdefined( player.secondaryLoadoutWeapon ) && weapon == player.secondaryLoadoutWeapon )
		         || ( isdefined( player.secondaryLoadoutAltWeapon ) && weapon == player.secondaryLoadoutAltWeapon ) )
	{
		if ( player IsBonusCardActive( 1, player.class_num ) )
		{
			player AddBonusCardStat( 1, "kills", 1, player.class_num );
		}
		if ( isdefined( player.primaryWeaponKill ) && player.primaryWeaponKill == true )
		{
			player.primaryWeaponKill = false;
			player.secondaryWeaponKill = false;
			if ( player IsBonusCardActive( 2, player.class_num ) )
			{
				player AddBonusCardStat( 2, "kills", 1, player.class_num );
				player AddPlayerStat( "kill_with_both_primary_weapons", 1 );
			}
		}
		else
		{
			player.secondaryWeaponKill = true;
		}
	}
	if ( player IsBonusCardActive( 5, player.class_num )
		|| player IsBonusCardActive( 4, player.class_num ) 
		|| player IsBonusCardActive( 3, player.class_num ) )
	{
		player AddPlayerStat( "kill_with_2_perks_same_category", 1 );
	}

	baseWeapon = GetWeapon( GetRefFromItemIndex( GetBaseWeaponItemIndex( weapon ) ) );
	
	if ( isdefined( player.weaponKills[ baseWeapon ] ) )
	{
		player.weaponKills[ baseWeapon ]++;
		if ( player.weaponKills[ baseWeapon ] == 5 )
		{
			player AddWeaponStat( baseWeapon, "killstreak_5", 1 );
		}
		if ( player.weaponKills[ baseWeapon ] == 10 )
		{
			player AddWeaponStat( baseWeapon, "killstreak_10", 1 );
		}
	}
	else
	{
		player.weaponKills[ baseWeapon ] = 1;
	}
	
	attachmentName = player GetWeaponOptic( weapon );
	
	if ( isdefined( attachmentName ) && attachmentName != "" )
	{
		if ( isdefined( player.attachmentKills[ attachmentName ] ) )
		{
			player.attachmentKills[ attachmentName ]++;
			if ( player.attachmentKills[ attachmentName ] == 5 )
			{
				player AddWeaponStat( weapon, "killstreak_5_attachment", 1 );
			}
		}
		else
		{
			player.attachmentKills[ attachmentName ] = 1;
		}
	}

	assert( isdefined ( level.activePlayerCounterUAVs[ player.entNum ] ) );
	assert( isdefined ( level.activePlayerUAVs[ player.entNum ] ) );
	assert( isdefined ( level.activePlayerSatellites[ player.entNum ] ) );
	
	if (  level.activePlayerUAVs[ player.entNum ] > 0 ) 
	{
		player AddPlayerStat( "kill_while_uav_active", 1 );
	}
	if (  level.activePlayerCounterUAVs[ player.entNum ] > 0 ) 
	{
		player AddPlayerStat( "kill_while_cuav_active", 1 );
	}
	if ( level.activePlayerSatellites[ player.entNum ] > 0 ) 
	{
		player AddPlayerStat( "kill_while_satellite_active", 1 );
	}

	if ( isdefined( attacker.tacticalInsertionTime ) && attacker.tacticalInsertionTime + 5000 > time )
	{
		player AddPlayerStat( "kill_after_tac_insert", 1 );
		player addWeaponStat( level.weaponTacticalInsertion, "CombatRecordStat", 1 );
	}
	
	// tracking for anti cheat
	if ( isdefined( victim.tacticalInsertionTime ) && victim.tacticalInsertionTime + 5000 > time )
	{
		player addWeaponStat( level.weaponTacticalInsertion, "headshots", 1, player.class_num );
	}

	if ( isdefined ( level.isplayerTrackedFunc ) ) 
	{
		if ( attacker [[ level.isplayerTrackedFunc ]]( victim, time ) )
		{
			attacker AddPlayerStat( "kill_enemy_revealed_by_sensor", 1 );
			attacker addWeaponStat( GetWeapon( "sensor_grenade" ), "CombatRecordStat", 1 );
		}
	}	

	if( player EMP::HasActiveEMP() )
	{
		player AddPlayerStat( "kill_while_emp_active", 1 );
	}
	
	if ( isdefined( player.flakJacketClaymore[ victim.clientid ] ) &&  player.flakJacketClaymore[ victim.clientid ] == true )
	{
		player AddPlayerStat( "survive_claymore_kill_planter_flak_jacket_equipped", 1 );
	}
	
	if ( isdefined( player.dogsActive ) )
	{
		if ( weapon.name != "dog_bite" )
		{
			player.dogsActiveKillstreak++;
			if ( player.dogsActiveKillstreak > 5 )
			{
				player AddPlayerStat( "killstreak_5_dogs", 1 );
			}
		}
	}

	isStunned = false;

	if ( victim util::isFlashbanged() )
	{
		if ( isdefined( victim.lastFlashedBy ) && victim.lastFlashedBy == player )
		{
			player AddPlayerStat( "kill_flashed_enemy", 1 );
			player AddWeaponStat( GetWeapon( "flash_grenade" ), "CombatRecordStat", 1 );
		}
		isStunned = true;
	}
	if ( isdefined( victim.concussionEndTime ) && victim.concussionEndTime > gettime() )
	{
		if ( isdefined( victim.lastConcussedBy ) && victim.lastConcussedBy == player )
		{
			player AddPlayerStat( "kill_concussed_enemy", 1 );
			player AddWeaponStat( GetWeapon( "concussion_grenade" ), "CombatRecordStat", 1 );
		}

		isStunned = true;
	}
	if ( isdefined( player.lastStunnedBy ) ) 
	{
		if ( player.lastStunnedBy == victim && player.lastStunnedTime + 5000 > time )
		{
			player AddPlayerStat( "kill_enemy_who_shocked_you", 1 );
		}
	}
	if ( isdefined( victim.lastStunnedBy ) && victim.lastStunnedTime + 5000 > time ) 
	{
		isStunned = true;
		if ( victim.lastStunnedBy == player ) 
		{
			player AddPlayerStat( "kill_shocked_enemy", 1 );
			player AddWeaponStat( GetWeapon( "proximity_grenade" ), "CombatRecordStat", 1 );
			
			if ( weapon_utils::isMeleeMOD( data.sMeansOfDeath ) )
			{
				player AddPlayerStat( "shock_enemy_then_stab_them", 1 );
			}
		}
	}

	if ( isdefined( player.tookweaponfrom ) && isdefined( player.tookweaponfrom[weapon] ) && isdefined( player.tookWeaponFrom[ weapon ].previousOwner ) )
	{
		if ( level.teambased )
		{
			if ( player.tookweaponfrom[weapon].previousOwner.team != player.team )
			{
				player.pickedUpWeaponKills[weapon]++;
				player AddPlayerStat( "kill_enemy_with_picked_up_weapon", 1 );
			}
		}
		else
		{
			player.pickedUpWeaponKills[weapon]++;
			player AddPlayerStat( "kill_enemy_with_picked_up_weapon", 1 );
		}
		if ( player.pickedUpWeaponKills[weapon] >= 5 ) 
		{
			player.pickedUpWeaponKills[weapon] = 0;
			player AddPlayerStat( "killstreak_5_picked_up_weapon", 1 );
		}
	}


	if ( isdefined( victim.explosiveInfo["originalOwnerKill"] ) && victim.explosiveInfo["originalOwnerKill"] == true )
	{
		if ( victim.explosiveInfo["damageExplosiveKill"] == true )
		{
			player AddPlayerStat( "kill_enemy_shoot_their_explosive", 1 );
		}
	}
	
	if ( data.attackerStance == "crouch" )
	{
		player AddPlayerStat( "kill_enemy_while_crouched", 1 );
	}
	else if ( data.attackerStance == "prone" )
	{
		player AddPlayerStat( "kill_enemy_while_prone", 1 );
	}

	if ( data.victimStance == "prone" )
	{
		player AddPlayerStat( "kill_prone_enemy", 1 );
	}

	if ( data.sMeansOfDeath == "MOD_HEAD_SHOT" || data.sMeansOfDeath == "MOD_PISTOL_BULLET" || data.sMeansOfDeath == "MOD_RIFLE_BULLET" )
	{
		player genericBulletKill( data, victim, weapon );
	}
	
	if ( level.teamBased )
	{
		if ( ( !isDefined( player.pers["kill_every_enemy"] ) ) &&  ( level.playerCount[victim.pers["team"]] > 3 && player.pers["killed_players"].size >= level.playerCount[victim.pers["team"]] ) )
		{
			player AddPlayerStat( "kill_every_enemy", 1 );
			player.pers["kill_every_enemy"] = true;
		}
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
					player.pers["pistolHeadshot"] = 0;
					player AddPlayerStat( "pistolHeadshot_10_onegame", 1 );
					
				}
			}
		}
		break;
		case "weapon_assault":
		{
			if ( data.sMeansOfDeath == "MOD_HEAD_SHOT" )
			{
				player.pers["assaultRifleHeadshot"]++;
				
				if ( player.pers["assaultRifleHeadshot"] >= 5 )
				{
					player.pers["assaultRifleHeadshot"] = 0;
					player AddPlayerStat( "headshot_assault_5_onegame", 1 );
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
				player AddPlayerStat( "kill_enemy_one_bullet_sniper", 1 );
				player AddWeaponStat( weapon, "kill_enemy_one_bullet_sniper", 1 );
				if ( !isdefined( player.pers[ "one_shot_sniper_kills" ] ) )
				{
					player.pers[ "one_shot_sniper_kills" ] = 0;
				}
				player.pers[ "one_shot_sniper_kills" ]++;
				if ( player.pers[ "one_shot_sniper_kills" ] == 10 )
				{
					player AddPlayerStat( "kill_10_enemy_one_bullet_sniper_onegame", 1 );
				}
			}
		}
		break;
		case "weapon_cqb":
		{
			if ( isdefined ( victim.firstTimeDamaged ) && victim.firstTimeDamaged == time )
			{
				player AddPlayerStat( "kill_enemy_one_bullet_shotgun", 1 );
				player AddWeaponStat( weapon, "kill_enemy_one_bullet_shotgun", 1 );
				if ( !isdefined( player.pers[ "one_shot_shotgun_kills" ] ) )
				{
					player.pers[ "one_shot_shotgun_kills" ] = 0;
				}
				player.pers[ "one_shot_shotgun_kills" ]++;
				if ( player.pers[ "one_shot_shotgun_kills" ] == 10 )
				{
					player AddPlayerStat( "kill_10_enemy_one_bullet_shotgun_onegame", 1 );
				}				
			}
		}
		break;
	}
	
	
	if ( weapon_utils::isMeleeMOD( data.sMeansOfDeath ) )
	{
		if ( WeaponHasAttachment( weapon, "tacknife" ) ) 
		{
			player AddPlayerStat( "kill_enemy_with_tacknife", 1 );
			player bladeKill();
		}
		else if ( weapon == level.weaponBallisticKnife )
		{
			player bladeKill();
			player AddWeaponStat( weapon, "ballistic_knife_melee", 1 );
		}
		else if ( weapon == level.weaponBaseMelee || weapon == level.weaponBaseMeleeHeld )
		{
			player bladeKill();
		}
		else if ( weapon.isRiotShield )
		{
			if ( victim.lastFireTime + 3000 > time ) 
			{
				player AddWeaponStat( weapon, "shield_melee_while_enemy_shooting", 1 );
			}
		}
	}
	else
	{
		if ( isdefined ( ownerWeaponAtLaunch ) )
		{
			if ( WeaponHasAttachment( ownerWeaponAtLaunch, "stackfire" ) )
			{
				player AddPlayerStat( "KILL_CROSSBOW_STACKFIRE", 1 );
			}
		}
		    				
		if ( weapon == level.weaponBallisticKnife )
		{
			player bladeKill();
			if ( isdefined( player.retreivedBlades ) && player.retreivedBlades > 0 )
			{
				player.retreivedBlades--;
				player AddWeaponStat( weapon, "kill_retrieved_blade", 1 );
			}
		}
	}
	lethalGrenadeKill = false;
	switch ( weapon.name )
	{
		case "bouncingbetty":
			lethalGrenadeKill = true;
			player notify( "lethalGrenadeKill" );
			break;
		case "hatchet":
			player bladeKill();
			lethalGrenadeKill = true;
			player notify( "lethalGrenadeKill" );
			if ( isdefined ( lastWeaponBeforeToss ) ) 
			{
				if ( lastWeaponBeforeToss.isRiotShield ) 
				{
					player AddWeaponStat( lastWeaponBeforeToss, "hatchet_kill_with_shield_equiped", 1 );
					player AddPlayerStat( "hatchet_kill_with_shield_equiped", 1 );
				}
			}
			break;
		case "claymore":
			lethalGrenadeKill = true;
			player notify( "lethalGrenadeKill" );
			player AddPlayerStat( "kill_with_claymore", 1 );
			if ( data.wasHacked )
			{
				player AddPlayerStat( "kill_with_hacked_claymore", 1 );
			}
			break;
		case "satchel_charge":
			lethalGrenadeKill = true;
			player notify( "lethalGrenadeKill" );
			player AddPlayerStat( "kill_with_c4", 1 );
			break;
		case "destructible_car":
			player AddPlayerStat( "kill_enemy_withcar", 1 );
			{
				if ( isdefined( inflictor.destroyingWeapon ) )
				{
					player AddWeaponStat( inflictor.destroyingWeapon, "kills_from_cars", 1 );
				}
			}
			break;
		case "sticky_grenade":
			{
				lethalGrenadeKill = true;
				player notify( "lethalGrenadeKill" );
				if ( isdefined( victim.explosiveInfo["stuckToPlayer"] ) && victim.explosiveInfo["stuckToPlayer"] == victim ) 
				{
					attacker.pers["stickExplosiveKill"]++;
					if ( attacker.pers["stickExplosiveKill"] >= 5 ) 
					{
						attacker.pers["stickExplosiveKill"] = 0;
						player AddPlayerStat( "stick_explosive_kill_5_onegame", 1 );
					}
				}
			}
			break;
		case "frag_grenade":
			{
				lethalGrenadeKill = true;
				player notify( "lethalGrenadeKill" );
				if ( isdefined( data.victim.explosiveInfo["cookedKill"] ) && data.victim.explosiveInfo["cookedKill"] == true )
				{
					player AddPlayerStat( "kill_with_cooked_grenade", 1 );
				}
				if ( isdefined( data.victim.explosiveInfo["throwbackKill"] ) && data.victim.explosiveInfo["throwbackKill"] == true )
				{
					player AddPlayerStat( "kill_with_tossed_back_lethal", 1 );
				}
			}
			break;
	}

	if ( lethalGrenadeKill ) 
	{
		if ( player IsBonusCardActive( 6, player.class_num ) )
		{
			player AddBonusCardStat( 6, "kills", 1, player.class_num );
			if ( !isdefined( player.pers["dangerCloseKills"] ) )
			{
				player.pers["dangerCloseKills"] = 0;
			}
			player.pers["dangerCloseKills"]++;
			if ( player.pers["dangerCloseKills"] == 5 ) 
			{
				player AddPlayerStat( "kill_with_dual_lethal_grenades", 1 );
			}
		}
	}


	player perkKills( victim, isStunned, time );

}

