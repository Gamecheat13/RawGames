#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_rank;

#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\_teamops;

    
                                     

#namespace scoreevents;

function autoexec __init__sytem__() {     system::register("scoreevents",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
}

function init()
{
	level.scoreEventCallbacks = [];
	level.scoreEventGameEndCallback =&onGameEnd;
	
	registerScoreEventCallback( "playerKilled", &scoreevents::scoreEventPlayerKill );	
}
function scoreEventTableLookupInt( index, scoreEventColumn )
{
	return int( tableLookup( getScoreEventTableName(), 0, index, scoreEventColumn ) );
}

function scoreEventTableLookup( index, scoreEventColumn )
{
	return tableLookup( getScoreEventTableName(), 0, index, scoreEventColumn );
}

function getScoreEventColumn( gameType )
{
	columnOffset = getColumnOffsetForGametype( gameType );
	assert( columnOffset >= 0 );
	if ( columnOffset >= 0 )
	{
		columnOffset += 0;
	}
	return columnOffset;	
}

function getXPEventColumn( gameType )
{
	columnOffset = getColumnOffsetForGametype( gameType );
	assert( columnOffset >= 0 );
	if ( columnOffset >= 0 )
	{
		columnOffset += 1;
	}
	return columnOffset;	
}

function getColumnOffsetForGametype( gameType )
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

	for ( gameModeColumn = 14; ; gameModeColumn += 2 )
	{
		column_header = TableLookupColumnForRow( level.scoreEventTableID, 0, gameModeColumn );
		if ( column_header == "" )
		{
			gameModeColumn = 14;
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
		
function getScoreEventTableID()
{
	scoreInfoTableLoaded = false;
	scoreInfoTableID = TableLookupFindCoreAsset( getScoreEventTableName() );
		
	if ( isdefined( scoreInfoTableID ) )
	{
		scoreInfoTableLoaded = true;
	}
	assert( scoreInfoTableLoaded, "Score Event Table is not loaded: " + getScoreEventTableName() );
	return scoreInfoTableID;
}

function registerScoreEventCallback( callback, func )
{
	if ( !isdefined( level.scoreEventCallbacks[callback] ) )
	{
		level.scoreEventCallbacks[callback] = [];
	}
	level.scoreEventCallbacks[callback][level.scoreEventCallbacks[callback].size] = func;
}

function scoreEventPlayerKill( data, time )
{
	victim = data.victim;
	attacker = data.attacker;
	time = data.time;
	level.numKills++;
	attacker.lastKilledPlayer = victim;
	wasDefusing = data.wasDefusing;
	wasPlanting = data.wasPlanting;
	victimWasOnGround = data.victimOnGround;
	attackerWasOnGround = data.attackerOnGround;
	meansOfDeath = data.sMeansOfDeath;
	attackerTraversing = data.attackerTraversing;
	attackerWallRunning = data.attackerWallRunning;
	attackerDoubleJumping = data.attackerDoubleJumping;	
	attackerSliding = data.attackerSliding;	
	victimWasWallRunning = data.victimWasWallRunning;
	victimWasDoubleJumping = data.victimWasDoubleJumping;
	attackerSpeedburst = data.attackerSpeedburst;
	victimSpeedburst = data.victimSpeedburst;
	victimCombatEfficieny = data.victimCombatEfficieny;
	attackerflashbackTime = data.attackerflashbackTime;
	victimflashbackTime = data.victimflashbackTime;
	victimSpeedburstLastOnTime = data.victimSpeedburstLastOnTime;
	victimCombatEfficiencyLastOnTime = data.victimCombatEfficiencyLastOnTime;
	victimVisionPulseActivateTime = data.victimVisionPulseActivateTime;
	attackerVisionPulseActivateTime = data.attackerVisionPulseActivateTime;
	victimVisionPulseActivateTime = data.victimVisionPulseActivateTime;
	attackerVisionPulseArray = data.attackerVisionPulseArray;
	victimVisionPulseArray = data.victimVisionPulseArray;
	attackerVisionPulseOriginArray = data.attackerVisionPulseOriginArray;
	victimVisionPulseOriginArray = data.victimVisionPulseOriginArray;
	attackerVisionPulseOrigin = data.attackerVisionPulseOrigin;
	victimVisionPulseOrigin = data.victimVisionPulseOrigin;

	attackerShotVictim = ( meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_HEAD_SHOT" );
	

	weapon = level.weaponNone;
	inflictor =	data.eInflictor;
	
	if ( isdefined( data.weapon ) )
	{
		weapon = data.weapon;
		weaponClass = util::getWeaponClass( data.weapon );
		killstreak = killstreaks::get_from_weapon( data.weapon );
	}

	victim.anglesOnDeath = victim getPlayerAngles();

	if ( meansOfDeath == "MOD_GRENADE" || meansOfDeath == "MOD_GRENADE_SPLASH" || meansOfDeath == "MOD_EXPLOSIVE"  || meansOfDeath == "MOD_EXPLOSIVE_SPLASH" ||  meansOfDeath == "MOD_PROJECTILE" || meansOfDeath == "MOD_PROJECTILE_SPLASH" )
	{
		if ( weapon == level.weaponNone && isdefined( data.victim.explosiveInfo["weapon"] ) )
			weapon = data.victim.explosiveInfo["weapon"];
	}

	if ( level.teamBased )
	{	
		attacker.lastKillTime = time;
		if ( isdefined( victim.lastKillTime ) && ( victim.lastKillTime > time - 3000 ) )
		{
			if ( isdefined( victim.lastkilledplayer ) && victim.lastkilledplayer util::IsEnemyPlayer( attacker ) == false && attacker != victim.lastkilledplayer )
			{
				processScoreEvent( "kill_enemy_who_killed_teammate", attacker, victim, weapon );
				victim RecordKillModifier("avenger");
			}
		}
		
		if ( isdefined( victim.damagedPlayers ) )
		{
			keys = getarraykeys(victim.damagedPlayers);
	
			for ( i = 0; i < keys.size; i++ )
			{
				key = keys[i];
				if ( key == attacker.clientid )
					continue;
				
				if ( !isdefined( victim.damagedPlayers[key].entity ) )
					continue;
				
				if ( attacker util::IsEnemyPlayer( victim.damagedPlayers[key].entity ) )
					continue;
	
				if ( ( time - victim.damagedPlayers[key].time ) < 1000 )
				{
					processScoreEvent( "kill_enemy_injuring_teammate", attacker, victim, weapon );
					if ( isdefined( victim.damagedPlayers[key].entity ) )
					{
						victim.damagedPlayers[key].entity.lastRescuedBy = attacker;
						victim.damagedPlayers[key].entity.lastRescuedTime = time;
					}
					victim RecordKillModifier("defender");
				}
			}
		}
	}

	if ( !isdefined( killstreak ) )
	{
		if ( victimWasDoubleJumping == true  )
		{
			processScoreEvent( "kill_enemy_that_is_in_air", attacker, victim, weapon );
		}

		if ( attackerDoubleJumping == true )
		{
			processScoreEvent( "kill_enemy_while_in_air", attacker, victim, weapon );
		}

		if ( victimWasWallRunning == true )
		{
			processScoreEvent( "kill_enemy_that_is_wallrunning", attacker, victim, weapon );
		}

		if ( attackerWallRunning == true )
		{
			processScoreEvent( "kill_enemy_while_wallrunning", attacker, victim, weapon );
		}

		if ( attackerSliding == true )
		{
			processScoreEvent( "kill_enemy_while_sliding", attacker, victim, weapon );
		}

		if ( attackerTraversing == true )
		{
			processScoreEvent( "traversal_kill", attacker, victim, weapon );
		}

		if ( attackerSpeedburst == true )
		{
			processScoreEvent( "speed_burst_kill", attacker, victim, weapon );
		}
		
		if ( victimSpeedburstLastOnTime > time - 50 )
		{
			processScoreEvent( "kill_enemy_who_is_speedbursting", attacker, victim, weapon );
		}

		if ( victimCombatEfficiencyLastOnTime > time - 50 )
		{
			processScoreEvent( "kill_enemy_who_is_using_focus", attacker, victim, weapon );
		}			

		if ( attackerflashbackTime != 0 && attackerflashbackTime > time - 3000 )
		{
			processScoreEvent( "flashback_kill", attacker, victim, weapon );
		}

		if ( victimflashbackTime != 0 && victimflashbackTime > time - 3000 )
		{
			processScoreEvent( "kill_enemy_who_has_flashbacked", attacker, victim, weapon );
		}

		if ( victimVisionPulseActivateTime != 0 && victimVisionPulseActivateTime > time - 6000 )
		{
			gadgetWeapon = getWeapon("gadget_vision_pulse");
			for ( i = 0; i < victimVisionPulseArray.size; i++ )
			{
				player = victimVisionPulseArray[i];
				if ( player == attacker )
				{	
					gadget = GetWeapon( "gadget_vision_pulse" );
					
					if ( victimVisionPulseActivateTime + 300 > time - gadgetWeapon.gadget_pulse_duration )
					{
						distanceToPulse = distance( victimVisionPulseOriginArray[i], victimVisionPulseOrigin );
						
						ratio = distanceToPulse / gadgetWeapon.gadget_pulse_margin;
						timing = ratio * gadgetWeapon.gadget_pulse_duration;
						if ( victimVisionPulseActivateTime + 300 > time - timing )
						{
							break;	
						}
					}
					
					processScoreEvent( "kill_enemy_that_pulsed_you", attacker, victim, weapon );
					break;
				}
			}
		}

		if ( attackerVisionPulseActivateTime != 0 && attackerVisionPulseActivateTime > time - 6000 )
		{
			gadgetWeapon = getWeapon("gadget_vision_pulse");
			for ( i = 0; i < attackerVisionPulseArray.size; i++ )
			{
				player = attackerVisionPulseArray[i];
				if ( player == victim )
				{	
					gadget = GetWeapon( "gadget_vision_pulse" );
					
					if ( attackerVisionPulseActivateTime > time - gadgetWeapon.gadget_pulse_duration )
					{
						distanceToPulse = distance( attackerVisionPulseOriginArray[i], attackerVisionPulseOrigin );
						
						ratio = distanceToPulse / gadgetWeapon.gadget_pulse_margin;
						timing = ratio * gadgetWeapon.gadget_pulse_duration;
						if ( attackerVisionPulseActivateTime > time - timing )
						{
							break;	
						}
					}
					
					processScoreEvent( "vision_pulse_kill", attacker, victim, weapon );
					break;
				}
			}
		}
	}

	switch ( weapon.name )
	{
		case "hatchet":
			{
				attacker.pers["tomahawks"]++;
				attacker.tomahawks = attacker.pers["tomahawks"];
		
				processScoreEvent( "hatchet_kill", attacker, victim, weapon );
		
				if ( isdefined( data.victim.explosiveInfo["projectile_bounced"] ) && data.victim.explosiveInfo["projectile_bounced"] == true )
				{
					level.globalBankshots++;

					processScoreEvent( "bounce_hatchet_kill", attacker, victim, weapon );
				}
			}
			break;
		case "supplydrop":
		case "inventory_supplydrop":
			{
				if ( meansOfDeath == "MOD_HIT_BY_OBJECT" || meansOfDeath == "MOD_CRUSH" )
				{
					processScoreEvent( "kill_enemy_with_care_package_crush", attacker, victim, weapon );
				}
				else
				{
					processScoreEvent( "kill_enemy_with_hacked_care_package", attacker, victim, weapon );
				}
			}
			break;

	}

	if ( isdefined(  data.victimWeapon ) )
	{
		if ( !isdefined( killstreak ) )
		{
			killedHeroWeaponEnemy( attacker, victim, weapon, data.victimWeapon );
		}
		
		if ( data.victimWeapon.name == "minigun" )
		{
			processScoreEvent( "killed_death_machine_enemy", attacker, victim, weapon );
		}
		else if ( data.victimWeapon.name == "m32" )
		{
			processScoreEvent( "killed_multiple_grenade_launcher_enemy", attacker, victim, weapon );
		}
		
		if ( data.victimWeapon.inventorytype == "hero" )
		{
			processScoreEvent( "end_enemy_specialist_weapon", attacker, victim, weapon );
		}
	}
	
	if ( weapon.name == "frag_grenade" )
	{
		attacker updateSingleFragMultiKill( victim, weapon, weaponClass, killstreak );
	}
	
	attacker thread updateMultiKills( weapon, weaponClass, killstreak );

	if ( level.numKills == 1 )
	{
		victim RecordKillModifier("firstblood");
		processScoreEvent( "first_kill", attacker, victim, weapon );
	}
	else
	{
		if ( isdefined( attacker.lastKilledBy ) )
		{
			if ( attacker.lastKilledBy == victim )
			{
				level.globalPaybacks++;
				processScoreEvent( "revenge_kill", attacker, victim, weapon );
				attacker AddWeaponStat( weapon, "revenge_kill", 1 );
				victim RecordKillModifier("revenge");
				attacker.lastKilledBy = undefined;
			}	
		}
		if ( victim killstreaks::is_an_a_killstreak() )
		{
			level.globalBuzzKills++;
			processScoreEvent( "stop_enemy_killstreak", attacker, victim, weapon );
			victim RecordKillModifier("buzzkill");
		}
		if ( isdefined( victim.lastManSD ) && victim.lastManSD == true )
		{
			processScoreEvent( "final_kill_elimination", attacker, victim, weapon );
			if ( isdefined( attacker.lastManSD ) && attacker.lastManSD == true )
			{
				processScoreEvent( "elimination_and_last_player_alive", attacker, victim, weapon );
			}
		}
	}

	if ( is_weapon_valid( meansOfDeath, weapon, weaponClass, killstreak ) )
	{
		if ( isdefined( victim.vAttackerOrigin ) )
			attackerOrigin = victim.vAttackerOrigin;
		else
			attackerOrigin = attacker.origin;
		distToVictim = distanceSquared( victim.origin, attackerOrigin );
		weap_min_dmg_range = get_distance_for_weapon( weapon, weaponClass );
		if ( distToVictim > weap_min_dmg_range )
		{
			attacker challenges::longDistanceKill();
			if ( weapon.name == "hatchet" )
			{
				attacker challenges::longDistanceHatchetKill();
			}
			processScoreEvent( "longshot_kill", attacker, victim, weapon );
			attacker AddWeaponStat( weapon, "longshot_kill", 1 );
			attacker.pers["longshots"]++;
			attacker.longshots = attacker.pers["longshots"];	
			victim RecordKillModifier("longshot");
		}
	}

	if ( isAlive( attacker ) )
	{
		if ( attacker.health < ( attacker.maxHealth * 0.35 ) ) 
		{
			attacker.lastKillWhenInjured = time;
			processScoreEvent( "kill_enemy_when_injured", attacker, victim, weapon );

			attacker AddWeaponStat( weapon, "kill_enemy_when_injured", 1 );
			if ( attacker hasPerk( "specialty_bulletflinch" ) )
			{
				attacker AddPlayerStat( "perk_bulletflinch_kills", 1 );
			}
		}
	}
	else
	{
		if ( isdefined( attacker.deathtime ) && ( ( attacker.deathtime + 800 ) < time ) && !attacker IsInVehicle() )
		{
			level.globalAfterlifes++;
			processScoreEvent( "kill_enemy_after_death", attacker, victim, weapon );
			victim RecordKillModifier("posthumous");
		}
	}
	
	if( attacker.cur_death_streak >= 3 )
	{
		level.globalComebacks++;
		processScoreEvent( "comeback_from_deathstreak", attacker, victim, weapon );
		victim RecordKillModifier("comeback");
	}

	if ( isdefined( victim.beingMicrowavedBy ) && weapon.name != "microwave_turret" ) 
	{
		if ( victim.beingMicrowavedBy != attacker && ( attacker util::IsEnemyPlayer( victim.beingMicrowavedBy ) == false ) ) 
		{ 
			scoreGiven = processScoreEvent( "microwave_turret_assist", victim.beingMicrowavedBy, victim, weapon );
			if ( isdefined ( scoreGiven ) && isdefined ( victim.beingMicrowavedBy ) )
			{
				victim.beingMicrowavedBy challenges::earnedMicrowaveAssistScore( scoreGiven );
			}
		}
		else
		{
			attacker challenges::killWhileDamagingWithHPM();
		}
	}

	if ( weapon_utils::isMeleeMOD( meansOfDeath ) && !weapon.isRiotShield )
	{
		attacker.pers["stabs"]++;
		attacker.stabs = attacker.pers["stabs"];
		
		vAngles = victim.anglesOnDeath[1];
		pAngles = attacker.anglesOnKill[1];
		angleDiff = AngleClamp180( vAngles - pAngles );

		if ( angleDiff > -30 && angleDiff < 70 )
		{
			level.globalBackstabs++;
			processScoreEvent( "backstabber_kill", attacker, victim, weapon );
			attacker AddWeaponStat( weapon, "backstabber_kill", 1 );
			attacker.pers["backstabs"]++;
			attacker.backstabs = attacker.pers["backstabs"];	
		}
	}
	else 
	{
		if ( isdefined ( victim.firstTimeDamaged ) && victim.firstTimeDamaged == time )
		{
			if ( isdefined( weaponClass ) && weaponClass == "weapon_sniper" )
			{
				attacker thread updateOneShotMultiKills( victim, weapon, victim.firstTimeDamaged );
				attacker AddWeaponStat( weapon, "kill_enemy_one_bullet", 1 );
			}
		}
		if ( isdefined( attacker.tookWeaponFrom[ weapon ] ) && isdefined( attacker.tookWeaponFrom[ weapon ].previousOwner ) )
		{
			pickedUpWeapon = attacker.tookWeaponFrom[ weapon ];
			if ( pickedUpWeapon.previousOwner == victim )
			{
				processScoreEvent( "kill_enemy_with_their_weapon", attacker, victim, weapon );
				attacker AddWeaponStat( weapon, "kill_enemy_with_their_weapon", 1 );
				if ( isdefined( pickedUpWeapon.weapon ) && isdefined( pickedUpWeapon.sMeansOfDeath ) )
				{
					if ( pickedUpWeapon.weapon == level.weaponBaseMeleeHeld && weapon_utils::isMeleeMOD( pickedUpWeapon.sMeansOfDeath ) )
					{
						attacker AddWeaponStat( level.weaponBaseMeleeHeld, "kill_enemy_with_their_weapon", 1 );
					}
				}				
			}
		}
	}

	if ( wasDefusing )
	{
		processScoreEvent( "killed_bomb_defuser", attacker, victim, weapon );
	}
	else if ( wasPlanting )
	{
		processScoreEvent( "killed_bomb_planter", attacker, victim, weapon );
	}
	
	specificWeaponKill( attacker, victim, weapon, killstreak );
	heroWeaponKill( attacker, victim, weapon );	

	if( isdefined( killstreak ) )
	{
		victim RecordKillModifier("killstreak");
	}

	attacker.cur_death_streak = 0;
	attacker disabledeathstreak();
}

function heroWeaponKill( attacker, victim, weapon )
{
	if ( !isdefined( weapon ) )
	{
		return;
	}

	switch( weapon.name ) 
	{
		case "hero_minigun":
			event = "minigun_kill";
			break;
		case "hero_flamethrower":
			event = "flamethrower_kill";
			break;
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
			event = "lightninggun_kill";
			break;
		case "hero_chemicalgelgun":
			event = "gelgun_kill";
			break;
		case "hero_pineapplegun":
			event = "pineapple_kill";
			break;
		case "hero_armblade": 
			event = "armblades_kill";
			break;
		case "hero_bowlauncher": 
		case "hero_bowlauncher2": 
		case "hero_bowlauncher3": 
		case "hero_bowlauncher4": 
			event = "bowlauncher_kill";
			break;
		case "hero_gravityspikes":
			event = "gravityspikes_kill";
			break;
		case "hero_annihilator":
			event = "annihilator_kill";
			break;		
		default:
			return;
	}

	processScoreEvent( event, attacker, victim, weapon );
}

function killedHeroWeaponEnemy( attacker, victim, weapon, victim_weapon )
{	
	if ( !isdefined( victim_weapon ) )
	{
		return;
	}

	switch( victim_weapon.name ) 
	{
		case "hero_minigun":
			event = "killed_minigun_enemy";
			break;
		case "hero_flamethrower":
			event = "killed_flamethrower_enemy";
			break;
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
			event = "killed_lightninggun_enemy";
			break;
		case "hero_chemicalgelgun":
			event = "killed_gelgun_enemy";
			break;
		case "hero_pineapplegun":
			event = "killed_pineapple_enemy";
			break;
		case "hero_armblade": 
			event = "killed_armblades_enemy";
			break;
		case "hero_bowlauncher": 
		case "hero_bowlauncher2": 
		case "hero_bowlauncher3": 
		case "hero_bowlauncher4": 
			event = "killed_bowlauncher_enemy";
			break;
		case "hero_gravityspikes":
			event = "killed_gravityspikes_enemy";
			break;
		case "hero_annihilator":
			event = "killed_annihilator_enemy";
			break;		
		default:
			return;
	}

	processScoreEvent( event, attacker, victim, weapon );
}

function specificWeaponKill( attacker, victim, weapon, killstreak )
{
	switchWeapon = weapon.name;

	if ( isdefined( killstreak ) ) 
	{
		switchWeapon = killstreak;
	}
	switch( switchWeapon ) 
	{
		case "remote_missile":
			event = "remote_missile_kill";
			break;
		case "autoturret":
			event = "sentry_gun_kill";
			break;
		case "planemortar":
			event = "plane_mortar_kill";
			break;
		case "ai_tank_drop":
			event = "aitank_kill";
			break;
		case "microwaveturret":
			event = "microwave_turret_kill";
			break;
		case "raps":
			event = "raps_kill";
			break;
		case "sentinel":
			event = "sentinel_kill";
			break;
		case "combat_robot":
			event = "combat_robot_kill";
			break;
		case "rcbomb":
			event = "hover_rcxd_kill";
			break;
		case "helicopter_gunner":
			event = "vtol_mothership_kill";
			break;
		case "helicopter_comlink":
			event = "helicopter_comlink_kill";
			break;
		default:
			return;
	}

	processScoreEvent( event, attacker, victim, weapon );
}

function multiKill( killCount, weapon )
{
	assert( killCount > 1 );
	
	self challenges::multiKill( killCount, weapon );

	if ( killCount > 8 ) 
	{
		processScoreEvent( "multikill_more_than_8", self, undefined, weapon );
	}
	else
	{
		processScoreEvent( "multikill_" + killCount, self, undefined, weapon );
	}
	self RecordMultiKill( killCount );
}


function is_weapon_valid( meansOfDeath, weapon, weaponClass, killstreak )
{
	valid_weapon = false;
	
	if ( isdefined( killstreak ) ) 
		valid_weapon = false;
	else if ( get_distance_for_weapon( weapon, weaponClass ) == 0 )
		valid_weapon = false;
	else if ( meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_RIFLE_BULLET" )
		valid_weapon = true;
	else if ( meansOfDeath == "MOD_HEAD_SHOT" )
		valid_weapon = true;
	else if ( weapon.name == "hatchet" && meansOfDeath == "MOD_IMPACT" )
		valid_weapon = true;

	return valid_weapon;
}


function updateSingleFragMultiKill( victim, weapon, weaponClass, killstreak )
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateSingleFragMultiKill" );
	self endon ( "updateSingleFragMultiKill" );
	
	if ( !isdefined (self.recent_SingleFragMultiKill) || self.recent_SingleFragMultiKillID != victim.explosiveinfo["damageid"] )
		self.recent_SingleFragMultiKill = 0;
	
	self.recent_SingleFragMultiKillID = victim.explosiveinfo["damageid"];
	self.recent_SingleFragMultiKill++;
	
	self waitTillTimeoutOrDeath( 0.05 );
	
	if ( self.recent_SingleFragMultiKill >= 2 )
	{
		processScoreEvent( "frag_multikill", self, victim, weapon );
	}

	self.recent_SingleFragMultiKill = 0;
}
	
function updatemultikills( weapon, weaponClass, killstreak )
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateRecentKills" );
	self endon ( "updateRecentKills" );

	baseWeapon = GetWeapon( GetRefFromItemIndex( GetBaseWeaponItemIndex( weapon ) ) );

	if ( !isdefined (self.recentKillCount) )
	{
		self.recentKillCount = 0;
	}

	if ( !isdefined( self.recentKillCountWeapon ) || self.recentKillCountWeapon != baseWeapon )
	{
		self.recentKillCountSameWeapon = 0;
		self.recentKillCountWeapon = baseWeapon;
	}

	if (!isdefined(killstreak))
	{
		self.recentKillCountSameWeapon++;
		self.recentKillCount++;
	}
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
	
	if ( !isdefined (self.recentAnihilatorCount) )
		self.recentAnihilatorCount = 0;
	if ( !isdefined (self.recentMiniGunCount) )
		self.recentMiniGunCount = 0;
	if ( !isdefined (self.recentBowLauncherCount) )
		self.recentBowLauncherCount = 0;
	if ( !isdefined (self.recentLightningGunCount) )
		self.recentLightningGunCount = 0;
	if ( !isdefined (self.recentGravitySpikesCount) )
		self.recentGravitySpikesCount = 0;

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
	
	if ( isdefined( weapon.isHeroWeapon ) && weapon.isHeroWeapon == true )
	{
		switch( weapon.name )
		{
		case "hero_annihilator":
			self.recentAnihilatorCount++;
			break;
		case "hero_minigun":
			self.recentMiniGunCount++;
			break;
		case "hero_bowlauncher":
		case "hero_bowlauncher2": 
		case "hero_bowlauncher3": 
		case "hero_bowlauncher4": 
			self.recentBowLauncherCount++;
			break;
		case "hero_gravityspikes":
			self.recentGravitySpikesCount++;
			break;
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
			self.recentLightningGunCount++;
			break;
		}
	}
	
	if ( isdefined ( killstreak ) ) 
	{
		switch( killstreak ) 
		{
		case "remote_missile":
			self.recentRemoteMissileKillCount++;
			break;
		case "rcbomb":
			self.recentRCBombKillCount++;
			break;
		case "inventory_m32":
		case "m32":
			self.recentMGLKillCount++;
			break;
		}
	}

	if ( self.recentKillCountSameWeapon == 2 )
	{
		self AddWeaponStat( weapon, "multikill_2", 1 );
	}
	else if ( self.recentKillCountSameWeapon == 3 )
	{
		self AddWeaponStat( weapon, "multikill_3", 1 );
	}
	
	self waitTillTimeoutOrDeath( 4.0 );

	if ( self.recent_LMG_SMG_KillCount >= 3 )
		self challenges::multi_LMG_SMG_Kill();	

	if ( self.recentRCBombKillCount >= 2 )
		self challenges::multi_RCBomb_Kill();	

	if ( self.recentMGLKillCount >= 3 )
		self challenges::multi_MGL_Kill();	

	if ( self.recentRemoteMissileKillCount >= 3 )
		self challenges::multi_RemoteMissile_Kill();	
	
	if ( self.recentAnihilatorCount >= 3 )
	{
		processScoreEvent( "annihilator_multikill", self, undefined, weapon );
	}
	if ( self.recentMiniGunCount >= 3 )
	{
		processScoreEvent( "minigun_multikill", self, undefined, weapon );
	}
	if ( self.recentBowLauncherCount >= 3 )
	{
		processScoreEvent( "bowlauncher_multikill", self, undefined, weapon );
	}
	if ( self.recentGravitySpikesCount >= 3 )
	{
		processScoreEvent( "gravityspikes_multikill", self, undefined, weapon );
	}
	if ( self.recentLightningGunCount >= 3 )
	{
		processScoreEvent( "lightninggun_multikill", self, undefined, weapon );
	}	

	if ( self.recentKillCount > 1 )
		self multiKill( self.recentKillCount, weapon );
	
	self.recentKillCount = 0;
	self.recentKillCountSameWeapon = 0;
	self.recentKillCountWeapon = undefined;
	self.recent_LMG_SMG_KillCount = 0;
	self.recentRemoteMissileKillCount = 0;
	self.recentRemoteMissileAttackerKillCount = 0;
	self.recentRCBombKillCount = 0;
	self.recentMGLKillCount = 0;
	self.recentAnihilatorCount = 0;
	self.recentMiniGunCount = 0;
	self.recentBowLauncherCount = 0;
	self.recentGravitySpikesCount = 0;
	self.recentLightningGunCount = 0;
}

function waitTillTimeoutOrDeath( timeout )
{
	self endon( "death" );
	wait( timeout );
}

function updateoneshotmultikills( victim, weapon, firstTimeDamaged )
{
	self endon( "death" );
	self endon( "disconnect" );
	self notify( "updateoneshotmultikills" + firstTimeDamaged );
	self endon( "updateoneshotmultikills" + firstTimeDamaged );
	if ( !isdefined( self.oneshotmultikills ) )
	{
		self.oneshotmultikills = 0;
	}

	self.oneshotmultikills++;
	wait( 1.0 );
	if ( self.oneshotmultikills > 1 )
	{
		processScoreEvent( "kill_enemies_one_bullet", self, victim, weapon );
	}
	else
	{
		processScoreEvent( "kill_enemy_one_bullet", self, victim, weapon );
	}
	self.oneshotmultikills = 0;
}

function get_distance_for_weapon( weapon, weaponClass )
{
	// this is special for the long shot medal
	// need to do this on a per weapon category basis, to better control it

	distance = 0;
	
	if( !isdefined( weaponClass ) )
	{
		return 0;
	}
	
	switch ( weaponClass )
	{
		case "weapon_smg":
			distance = 1250 * 1250;
			break;

		case "weapon_assault":
			distance = 1500 * 1500;
			break;

		case "weapon_lmg":
			distance = 1500 * 1500;
			break;

		case "weapon_sniper":
			distance = 1750 * 1750;
			break;

		case "weapon_pistol":
			distance = 700 * 700;
			break;
			
		case "weapon_cqb":
			distance = 650 * 650;
			break;


		case "weapon_special":
			{
				if( weapon == level.weaponBallisticKnife )
				{
					distance = 1500 * 1500;	
				}
			}
			break;
		case "weapon_grenade":
			if ( weapon.name == "hatchet" ) 
			{
				distance = 2500 * 2500;
			}
			break;
		default:
			distance = 0;
			break;
	}

	return distance;
}


function onGameEnd( data )
{
	player = data.player;
	winner = data.winner;
	
	if ( isdefined( winner ) ) 
	{	
		if ( level.teambased )
		{
			if ( winner != "tie" && player.team == winner )
			{
				processScoreEvent( "won_match", player );
				return;
			}
		}
		else
		{
			placement = level.placement["all"];
			topThreePlayers = min( 3, placement.size );
			
			for ( index = 0; index < topThreePlayers; index++ )
			{
				if ( level.placement["all"][index] == player )
				{
					processScoreEvent( "won_match", player );
						return;
				}
			}
		}
	}
	processScoreEvent( "completed_match", player );
}