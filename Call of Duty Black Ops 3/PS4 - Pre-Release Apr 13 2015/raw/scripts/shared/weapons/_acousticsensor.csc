#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "fx", "_t6/misc/fx_equip_light_red" );
#precache( "fx", "_t6/misc/fx_equip_light_green" );

#namespace acousticsensor;

function init_shared()
{
	level._effect["acousticsensor_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["acousticsensor_friendly_light"] = "_t6/misc/fx_equip_light_green";
	
	callback::add_weapon_watcher( &createAcousticSensorWatcher );
}

function createAcousticSensorWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "acoustic_sensor", self.team );
	watcher.onSpawn =&onSpawnAcousticSensor;
	watcher.onDetonateCallback =&acousticSensorDetonate;
	watcher.stun = &weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.reconModel = "t5_weapon_acoustic_sensor_world_detect";
	watcher.hackable = true;
	watcher.onDamage =&watchAcousticSensorDamage;
}

function onSpawnAcousticSensor( watcher, player ) // self == acoustic sensor
{
	self endon( "death" );
	
	self thread weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	player.acousticSensor = self;
	self SetOwner( player );
	self SetTeam( player.team );
	self.owner = player;
	
	self PlayLoopSound ( "fly_acoustic_sensor_lp" );
	
    if ( !self util::isHacked() )
	{
		player AddWeaponStat( self.weapon, "used", 1 );
	}

	self thread watchShutdown( player, self.origin );
}

function acousticSensorDetonate( attacker, weapon )
{
	if ( !isdefined( weapon ) || !weapon.isEmp )
	{
		PlayFX( level._equipment_explode_fx, self.origin );
	}
	
	if ( isdefined( attacker ) )
	{
		if ( self.owner util::IsEnemyPlayer( attacker ) )
		{
			attacker challenges::destroyedEquipment( weapon );
			scoreevents::processScoreEvent( "destroyed_motion_sensor", attacker, self.owner, weapon );
		}
	}
	
	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	self destroyEnt();
}

function destroyEnt()
{
	self delete();
}

function watchShutdown( player, origin )
{
	self util::waittill_any( "death", "hacked" );

	if ( isdefined( player ) )
		player.acousticSensor = undefined;
}

function watchAcousticSensorDamage( watcher ) // self == acoustic sensor
{
	self endon( "death" );
	self endon( "hacked" );

	self SetCanDamage( true );
	damageMax = 100;

	if ( !self util::isHacked() )
	{
		self.damageTaken = 0;
	}

	while( true )
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );

		if ( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		if ( level.teamBased && attacker.team == self.owner.team && attacker != self.owner )
			continue;

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		// do damage feedback
		if ( watcher.stunTime > 0 && weapon.doStn )
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

		if ( isPlayer( attacker ) && level.teambased && isdefined( attacker.team ) && self.owner.team == attacker.team && attacker != self.owner )
			continue;

		if ( type == "MOD_MELEE" || weapon.isEmp )
		{
			self.damageTaken = damageMax;
		}
		else
		{
			self.damageTaken += damage;
		}

		if ( self.damageTaken >= damageMax )
		{

			//attacker _properks::shotEquipment( self.owner, iDFlags );
			watcher thread weaponobjects::waitAndDetonate( self, 0.0, attacker, weapon );
			return;
		}
	}
}