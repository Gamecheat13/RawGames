#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using_animtree ( "mp_trophy_system" );








	
#precache( "fx", "weapon/fx_trophy_flash" );
#precache( "fx", "weapon/fx_trophy_detonation" );
#precache( "fx", "weapon/fx_trophy_radius_indicator" );
#precache( "triggerstring", "MP_TROPHY_SYSTEM_PICKUP" );
#precache( "triggerstring", "MP_TROPHY_SYSTEM_DESTROY" );
#precache( "triggerstring", "MP_TROPHY_SYSTEM_HACKING" );
	
#namespace trophy_system;

function init_shared()
{
	level.trophyLongFlashFX = "weapon/fx_trophy_flash";
	level.trophyDetonationFX = "weapon/fx_trophy_detonation";
	level.fx_trophy_radius_indicator = "weapon/fx_trophy_radius_indicator";
	
	trophyDeployAnim = %o_trophy_deploy;
	trophySpinAnim = %o_trophy_spin;
	
	level thread register();
	
	callback::on_spawned( &createTrophySystemWatcher );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function register()
{
	clientfield::register( "missile", "trophy_system_state", 1, 2, "int" );
	clientfield::register( "scriptmover", "trophy_system_state", 1, 2, "int" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function createTrophySystemWatcher() // self == player
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "trophy_system", self.team );
	
	watcher.onDetonateCallback =&trophySystemDetonate;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.hackable = true;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.ownerGetsAssist = true;
	watcher.ignoreDirection = true;
	watcher.activationDelay = 0.1;
	watcher.headIcon = false;

	watcher.enemyDestroy = true;

	watcher.onSpawn =&onTrophySystemSpawn;
	watcher.onDamage =&watchTrophySystemDamage;
	watcher.onDestroyed =&onTrophySystemSmashed;

	watcher.onStun =&weaponobjects::weaponStun;
	watcher.stunTime = 1;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function onTrophySystemSpawn( watcher, player ) // self == trophy system
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );
	self endon( "death" );
	self UseAnimTree( #animtree );
	self weaponobjects::onSpawnUseWeaponObject( watcher, player );	
	self.trophySystemStationary = false;

	moveState = self util::waitTillRollingOrNotMoving();
	
	if ( moveState == "rolling" )
	{
		self SetAnim( %o_trophy_deploy, 1.0 );
		self clientfield::set( "trophy_system_state", 1 );
		
		self util::waitTillNotMoving();
	}
	
	self.trophySystemStationary = true;
	
	player AddWeaponStat( self.weapon, "used", 1 );	
		    
	self.ammo = player ammo_get( self.weapon );
	self thread trophyActive( player );
	self thread trophyWatchHack();
	
	self SetAnim( %o_trophy_deploy, 0.0 );
	self SetAnim( %o_trophy_spin, 1.0 );
	self clientfield::set( "trophy_system_state", 2 );
	
	self playsound("wpn_trophy_deploy_start");
	
	self PlayLoopSound( "wpn_trophy_spin", 0.25 );

	self setReconModelDeployed();
}

function setReconModelDeployed() // self == trophy system
{
	if ( isdefined( self.reconModelEntity ) )
	{
		self.reconModelEntity clientfield::set( "trophy_system_state", 2 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophyWatchHack() // self == trophy system
{
	self endon( "death" );

	self waittill( "hacked", player );
	
	self clientfield::set( "trophy_system_state", 0 );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function onTrophySystemSmashed( attacker ) // self == trophy system
{
	PlayFX( level._effect["tacticalInsertionFizzle"], self.origin );
	self playsound ("dst_trophy_smash");

	if( isdefined( level.playEquipmentDestroyedOnPlayer ) )
	{
		self.owner [[level.playEquipmentDestroyedOnPlayer]]( );
	}

	if ( isdefined(attacker) && self.owner util::IsEnemyPlayer( attacker ) )
	{
		attacker challenges::destroyedEquipment();
		scoreevents::processScoreEvent( "destroyed_trophy_system", attacker, self.owner );
	}

	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophyActive( owner ) // self == trophy system
{
	owner endon( "disconnect" );
	self endon( "death" );
	self endon( "hacked" );

	while( true )
	{
		if ( !isdefined( self ) )
		{
			return;
		}
		
		tac_inserts = tacticalinsertion::getTacticalInsertions();

		if (( level.missileEntities.size < 1 && tac_inserts.size < 1 ) || isdefined( self.disabled ))
		{
			wait( .05 );
			continue;
		}

		for ( index=0; index < level.missileEntities.size; index++ )
		{
			wait( .05 ); // only handle 1 missile per frame
			
			if ( !isdefined( self ) )
			{
				return;
			}

			grenade = level.missileEntities[index];
			
			if ( !isdefined(grenade) )
				continue;
			
			if ( grenade == self )
				continue;

			if ( !grenade.weapon.destroyableByTrophySystem )
			{
				continue;
			}
			
			if ( grenade.weapon.isTacticalInsertion )
			{
				// tagTMR<NOTE>: trophy systems will attack the scriptmover not the invisible ET_MISSILE for tac inserts
				continue;
			}

			switch( grenade.model )
			{
				case "t6_wpn_grenade_supply_projectile":
					continue;
			}

			if ( grenade.weapon == self.weapon )
			{
				if ( self.trophySystemStationary == false && grenade.trophySystemStationary == true ) 
				{
					continue;	
				}
			}
			
			if ( !isdefined( grenade.owner ) )
			{
				grenade.owner = GetMissileOwner( grenade );
			}

			if ( isdefined( grenade.owner ))
			{
				if ( level.teamBased )
				{
					if ( grenade.owner.team == owner.team )
					{
						continue;
					}
				}
				else
				{
					if ( grenade.owner == owner )
					{
						continue;
					}
				}

				grenadeDistanceSquared = DistanceSquared( grenade.origin, self.origin );
			
				if ( grenadeDistanceSquared < ( 512 * 512 ))
				{
					if ( BulletTracePassed( grenade.origin, self.origin + (0,0,29), false, self, grenade, false, true ) )
					{
						playFX( level.trophyLongFlashFX, self.origin + (0,0,15), ( grenade.origin - self.origin ), AnglesToUp( self.angles ) );
						
						// projectileExplode deletes the missile ent 
						// so need to update index on shuffled-down level.missileEntities[]
						owner thread projectileExplode( grenade, self );
						index--;

						//Eckert - Plays sound when destroying projectile/grenade
						self playsound ( "wpn_trophy_alert" );
						
						if ( GetDvarint( "player_sustainAmmo" ) == 0 )
						{
							self.ammo--;
							if ( self.ammo <= 0 )
							{
								self thread trophySystemDetonate();
							}
						}
						
					}
				}
			}
		}

		// handle tac inserts seperately
		for ( index=0; index < tac_inserts.size; index++ )
		{
			wait( .05 ); // only handle 1 missile per frame

			if ( !isdefined( self ) )
			{
				return;
			}
			
			tac_insert = tac_inserts[index];

			if ( !isdefined( tac_insert ))
			{
				continue;
			}
			
			if ( isdefined( tac_insert.owner ))
			{
				if ( level.teamBased )
				{
					if ( tac_insert.owner.team == owner.team )
					{
						continue;
					}
				}
				else
				{
					if ( tac_insert.owner == owner )
					{
						continue;
					}
				}

				grenadeDistanceSquared = DistanceSquared( tac_insert.origin, self.origin );
			
				if ( grenadeDistanceSquared < ( 512 * 512 ))
				{
					// tagTMR<NOTE>: use tac insert scriptmover as ignore ent so bullet trace doesn't fail on the model
					if ( BulletTracePassed( tac_insert.origin, self.origin + (0,0,29), false, tac_insert ))
					{
						playFX( level.trophyLongFlashFX, self.origin + (0,0,15), ( tac_insert.origin - self.origin ), AnglesToUp( self.angles ) );
						
						// projectileExplode deletes the missile ent 
						// so need to update index on shuffled-down level.missileEntities[]
						owner thread trophyDestroyTacInsert( tac_insert, self );
						index--;

						//Eckert - Plays sound when destroying projectile/tac_insert
						self playsound ( "wpn_trophy_alert" );
						
						self.ammo--;
						if ( self.ammo <= 0 )
						{
							self thread trophySystemDetonate();
						}
					}
				}
			}
		}
	}

}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function projectileExplode( projectile, trophy ) // self == trophy owning player
{
	self endon( "death" );
	
	projPosition = projectile.origin;

	playFX( level.trophyDetonationFX, projPosition );
	projectile notify ( "trophy_destroyed" );

	trophy RadiusDamage( projPosition, 128, 105, 10, self );
		
	scoreevents::processScoreEvent( "trophy_defense", self );
	self AddPlayerStat( "destroy_explosive_with_trophy", 1 );
	self AddWeaponStat( trophy.weapon, "CombatRecordStat", 1 );
	
	projectile delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophyDestroyTacInsert( tacInsert, trophy )  // self == trophy system owner 
{
	self endon( "death" );

	tacPos = tacInsert.origin;
	playFX( level.trophyDetonationFX, tacInsert.origin );

	tacInsert thread tacticalinsertion::tacticalInsertionDestroyedByTrophySystem( self, trophy );
	trophy RadiusDamage( tacPos, 128, 105, 10, self );
		
	scoreevents::processScoreEvent( "trophy_defense", self );
	self AddPlayerStat( "destroy_explosive_with_trophy", 1 );
	self AddWeaponStat( trophy.weapon, "CombatRecordStat", 1 );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trophySystemDetonate(attacker, weapon, target)
{
	if ( !isdefined( weapon ) || !weapon.isEmp )
	{
		PlayFX( level._equipment_explode_fx_lg, self.origin );
	}

	if ( isdefined(attacker) && self.owner util::IsEnemyPlayer( attacker ) )
	{
		attacker challenges::destroyedEquipment( weapon );
		scoreevents::processScoreEvent( "destroyed_trophy_system", attacker, self.owner, weapon );
	}

	PlaySoundAtPosition ( "exp_trophy_system", self.origin );
	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchTrophySystemDamage( watcher ) // self == trophy system
{
	self endon( "death" );
	self endon( "hacked" );

	self SetCanDamage( true );
	damageMax = 20;

	if ( !self util::isHacked() )
	{
		self.damageTaken = 0;
	}

	self.maxhealth = 10000;
	self.health = self.maxhealth;

	self setmaxhealth( self.maxhealth );

	attacker = undefined;

	while( true )
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );

		attacker = self [[ level.figure_out_attacker ]]( attacker );

		if( !isplayer( attacker ))
		{
			continue;
		}

		if ( level.teambased )
 		{
			// if we're not hardcore and the team is the same, do not destroy
			if( !level.hardcoreMode && self.owner.team == attacker.pers["team"] && self.owner != attacker )
			{
				continue;
			}
		}

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		// do damage feedback
		if ( watcher.stunTime > 0 && weapon.doStun )
		{
			self thread weaponobjects::stunStart( watcher, watcher.stunTime ); 
		}

		if ( weapon.doDamageFeedback )
		{
			// if we're not on the same team then show damage feedback
			if ( level.teambased && self.owner.team != attacker.team )
			{
				if ( damagefeedback::doDamageFeedback( weapon, attacker ) )
					attacker damagefeedback::update();
			}
			// for ffa just make sure the owner isn't the same
			else if ( !level.teambased && self.owner != attacker )
			{
				if ( damagefeedback::doDamageFeedback( weapon, attacker ) )
					attacker damagefeedback::update();
			}
		}

		if ( type == "MOD_MELEE" || weapon.isEmp || weapon.destroysEquipment )
		{
			self.damageTaken = damageMax;
		}
		else
		{
			self.damageTaken += damage;
		}

		if( self.damageTaken >= damageMax )
		{
			watcher thread weaponobjects::waitAndDetonate( self, 0.05, attacker, weapon );
			return;
		}
	}
}

function ammo_scavenger( weapon )
{	
	self ammo_reset();
}

function ammo_reset()
{
	self._trophy_system_ammo1 = undefined;
	self._trophy_system_ammo2 = undefined;
}

function ammo_get( weapon )
{
	totalAmmo = weapon.ammoCountEquipment;
		
	if ( isdefined( self._trophy_system_ammo1 ) && !self util::isHacked() )
    {
		totalAmmo = self._trophy_system_ammo1;
		self._trophy_system_ammo1 = undefined;
		
		if ( isdefined( self._trophy_system_ammo2 ) )
		{
			self._trophy_system_ammo1 = self._trophy_system_ammo2;
			self._trophy_system_ammo2 = undefined;
		}
    }
	
	return totalAmmo;
}

function ammo_weapon_pickup( ammo )
{
	if ( isdefined( ammo ) )
	{
		if ( isdefined( self._trophy_system_ammo1 ) )
		{
			self._trophy_system_ammo2 = self._trophy_system_ammo1;
			self._trophy_system_ammo1 = ammo;
		}
		else
		{
			self._trophy_system_ammo1 = ammo;
		}
	}
}

function ammo_weapon_hacked( ammo )
{
	self ammo_weapon_pickup( ammo );
}