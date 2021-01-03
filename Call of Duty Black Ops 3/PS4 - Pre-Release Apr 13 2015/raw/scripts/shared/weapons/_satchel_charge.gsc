#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "fx", "weapon/fx_c4_light_orng" );
#precache( "fx", "weapon/fx_c4_light_blue" );

#namespace satchel_charge;

function init_shared()
{
	level._effect["satchel_charge_enemy_light"] = "weapon/fx_c4_light_orng";
	level._effect["satchel_charge_friendly_light"] = "weapon/fx_c4_light_blue";
	
	callback::add_weapon_watcher( &createSatchelWatcher );
}

function createSatchelWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "satchel_charge", self.team );
	watcher.altDetonate = true;
	watcher.watchForFire = true;
	watcher.hackable = true;
	watcher.hackerToolRadius = level.equipmentHackerToolRadius;
	watcher.hackerToolTimeMs = level.equipmentHackerToolTimeMs;
	watcher.headIcon = true;
	watcher.onDetonateCallback =&satchelDetonate;
	watcher.onSpawn =&satchelSpawn;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 1;
	watcher.altWeapon = GetWeapon( "satchel_charge_detonator" );
	watcher.reconModel = "wpn_t7_c4_world_detect";
	watcher.ownerGetsAssist = true;
	watcher.detonateStationary = true;
	watcher.detonationDelay = GetDvarFloat( "scr_satchel_detonation_delay", 0.0 );
	watcher.detonationSound = "wpn_claymore_alert";
	watcher.proximityAlarmActivateSound = "uin_c4_enemy_detection_alert";
}

function satchelDetonate( attacker, weapon )
{
	if ( IsDefined( weapon ) && weapon.isValid )
	{
		if ( isdefined( attacker ) )
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) )
			{
				attacker challenges::destroyedExplosive( weapon );
				scoreevents::processScoreEvent( "destroyed_c4", attacker, self.owner, weapon );
			}
		}
	}
	
	weaponobjects::weaponDetonate( attacker, weapon );
}

function satchelSpawn( watcher, owner )
{
	self endon( "death" );
	
	self thread weaponobjects::onSpawnUseWeaponObject( watcher, owner );
	
	self playloopsound( "uin_c4_air_alarm_loop" );
	
	self util::waittill_notify_or_timeout( "stationary", 10 );
	delayTimeSec = self.weapon.proximityalarmactivationdelay / 1000;
	
	if ( delayTimeSec > 0 )
	{
		wait( delayTimeSec );
	}
	self stoploopsound( 0.1 );
}