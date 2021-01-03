#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_globallogic_score;

#using scripts\cp\_challenges;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_killstreaks;

                                     


	
#precache( "string", "COOP_SCORE_NOTIFY_FORMAT" );
#precache( "eventstring", "show_text_notification_image" );	
	
#namespace scoreevents;

function autoexec __init__sytem__() {     system::register("scoreevents",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_start_gametype( &main );
}

function main()
{
	level.scoreEventCallbacks = [];
	level.scoreEventGameEndCallback =&onGameEnd;
	
	registerScoreEventCallback( "playerKilled", &scoreevents::scoreEventPlayerKill );	
	registerScoreEventCallback( "actorKilled", &scoreevents::scoreEventActorKill );
}

function scoreEventTableLookupInt( index, scoreEventColumn )
{
	return int( tableLookup( getScoreEventTableName(), 0, index, scoreEventColumn ) );
}

function scoreEventTableLookup( index, scoreEventColumn )
{
	return tableLookup( getScoreEventTableName(), 0, index, scoreEventColumn );
}


// Process event for all players and display the team score splash screen.
//
function processTeamScoreEvent( event )
{	
	foreach( e_player in level.players )
	{
		scoreevents::processScoreEvent( event, e_player );
	}
	
	if ( isdefined( level.teamScoreUICallback ) )
	{
		level thread [[level.teamScoreUICallback]]( event );
	}
}

function registerScoreEventCallback( callback, func )
{
	if ( !isdefined( level.scoreEventCallbacks[callback] ) )
	{
		level.scoreEventCallbacks[callback] = [];
	}
	level.scoreEventCallbacks[callback][level.scoreEventCallbacks[callback].size] = func;
}

function scoreEventActorKill( data, time )
{
	victim = data.victim;
	attacker = data.attacker;
	time = data.time;
	victim = data.victim;
	meansOfDeath = data.sMeansOfDeath;
	weapon = level.weaponNone;
	
	// Multi-kills enabled in Raids, for now.
	//
	if ( !( level.gametype === "raid" ) )
	{
		return;
	}
	
	if ( !isdefined( attacker ) )
	{
		return;
	}
	
	if ( !IsPlayer( attacker ) )
	{
		return;
	}
	
	if ( isdefined( data.weapon ) )
	{
		weapon = data.weapon;
		weaponClass = util::getWeaponClass( data.weapon );
		killstreak = killstreaks::get_from_weapon( data.weapon );
	}
	
	attacker thread updateMultiKills( weapon, weaponClass, killstreak );
}

function scoreEventPlayerKill( data, time )
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
	meansOfDeath = data.sMeansOfDeath;
	weapon = level.weaponNone;

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
		if ( data.victimWeapon.name == "minigun" )
		{
			processScoreEvent( "killed_death_machine_enemy", attacker, victim, weapon );
		}
		else if ( data.victimWeapon.name == "m32" )
		{
			processScoreEvent( "killed_multiple_grenade_launcher_enemy", attacker, victim, weapon );
		}
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

	if ( is_weapon_valid( meansOfDeath, weapon, weaponClass ) )
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

	if ( ( meansOfDeath == "MOD_MELEE" || meansOfDeath == "MOD_MELEE_ASSASSINATE" ) && !weapon.isRiotshield )
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
			if ( weaponClass == "weapon_sniper" )
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
					if ( pickedUpWeapon.weapon == level.weaponBaseMeleeHeld && ( pickedUpWeapon.sMeansOfDeath == "MOD_MELEE" || pickedUpWeapon.sMeansOfDeath == "MOD_MELEE_ASSASSINATE" ) )
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


	if( isdefined( killstreak ) )
	{
		victim RecordKillModifier("killstreak");
	}

	attacker.cur_death_streak = 0;
	attacker disabledeathstreak();
}

function specificWeaponKill( attacker, victim, weapon, killstreak )
{

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


function is_weapon_valid( meansOfDeath, weapon, weaponClass )
{
	valid_weapon = false;
	
	if ( get_distance_for_weapon( weapon, weaponClass ) == 0 )
		valid_weapon = false;
	else if ( meansOfDeath == "MOD_PISTOL_BULLET" || meansOfDeath == "MOD_RIFLE_BULLET" )
		valid_weapon = true;
	else if ( meansOfDeath == "MOD_HEAD_SHOT" )
		valid_weapon = true;
	else if ( weapon.name == "hatchet" && meansOfDeath == "MOD_IMPACT" )
		valid_weapon = true;

	return valid_weapon;
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
