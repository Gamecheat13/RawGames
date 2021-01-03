#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_decoy;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

                                            
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       




#namespace sensor_grenade;

function init_shared()
{
	level.isplayerTrackedFunc =&isPlayerTracked;
	callback::add_weapon_watcher( &createSensorGrenadeWatcher );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function createSensorGrenadeWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "sensor_grenade", self.team );
	watcher.headicon = false;
	watcher.onSpawn =&onSpawnSensorGrenade;
	watcher.onDetonateCallback =&sensorGrenadeDestroyed;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 0;
	watcher.reconModel = "t6_wpn_motion_sensor_world_detect";
	watcher.onDamage =&watchsensorGrenadeDamage;

	watcher.enemyDestroy = true;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function onSpawnSensorGrenade( watcher, player ) // self == sensor sensor
{
	self endon( "death" );
	
	self thread weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	self SetOwner( player );
	self SetTeam( player.team );
	self.owner = player;
	
	self PlayLoopSound ( "wpn_sensor_nade_lp" );
	
	self hacker_tool::registerWithHackerTool( level.equipmentHackerToolRadius, level.equipmentHackerToolTimeMs );

	player AddWeaponStat( self.weapon, "used", 1 );

	self thread watchForStationary( player );
	self thread watchForExplode( player );

	self thread watch_for_decoys( player );
}

function watchForStationary( owner )
{
	self endon( "death" );
	self endon( "hacked" );
	self endon( "explode" );
	owner endon( "death" );
	owner endon( "disconnect" );

	self waittill("stationary" );

	checkForTracking( self.origin );
}

function watchForExplode( owner )
{
	self endon( "hacked" );
	self endon( "delete" );
	owner endon( "death" );
	owner endon( "disconnect" );
	
	self waittill( "explode", origin );

	checkForTracking( origin + ( 0,0,1) );
}

function checkForTracking( origin )
{
	if ( isdefined ( self.owner ) == false )
		return;

	players = level.players;
	foreach( player in level.players )
	{
		if ( player util::IsEnemyPlayer( self.owner ) )
		{
			if ( ! ( player hasPerk ("specialty_nomotionsensor") ) && 
			     ! ( player hasPerk ("specialty_sengrenjammer") && player clientfield::get( "sg_jammer_active" ) )  )
			{
				if ( DistanceSquared( player.origin, origin ) < 750 * 750 ) 
				{
					trace = bullettrace( origin, player.origin + (0,0,12), false, player );
					if ( trace["fraction"] == 1 )
					{
						self.owner trackSensorGrenadeVictim( player );
					}
				}
			}
		}
	}
}

function trackSensorGrenadeVictim( victim )
{
	if ( !isdefined( self.sensorGrenadeData ) )
	{
		self.sensorGrenadeData = [];
	}
	
	if ( !isdefined( self.sensorGrenadeData[victim.clientid] ) )
	{
		self.sensorGrenadeData[victim.clientid] = getTime();
	}
}

function isPlayerTracked( player, time ) 
{
	playerTracked = false;
	if ( isdefined ( self.sensorGrenadeData ) && isdefined( self.sensorGrenadeData[player.clientid] ) )
	{
		if ( self.sensorGrenadeData[player.clientid] + 10000 > time )
		{
			playerTracked = true;
		}
	}
	return playerTracked;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function sensorGrenadeDestroyed( attacker, weapon )
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
	
	PlaySoundAtPosition ( "wpn_sensor_nade_explo", self.origin );
	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchSensorGrenadeDamage( watcher ) // self == sensor grenade
{
	self endon( "death" );
	self endon( "hacked" );

	self SetCanDamage( true );
	damageMax = 1;

	if ( !self util::isHacked() )
	{
		self.damageTaken = 0;
	}

	while( true )
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );

		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		if ( level.teambased && IsPlayer( attacker ) )
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

		if ( type == "MOD_MELEE" || weapon.isEmp )
		{
			self.damageTaken = damageMax;
		}
		else
		{
			self.damageTaken += damage;
		}

		if( self.damageTaken >= damageMax )
		{
			watcher thread weaponobjects::waitAndDetonate( self, 0.0, attacker, weapon );
			return;
		}
	}
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************






function watch_for_decoys( owner )
{
	self waittill("stationary" );

	players = level.players;
	foreach( player in level.players )
	{
		if ( player util::IsEnemyPlayer( self.owner ) )
		{
			if ( IsAlive(player) && player hasPerk ("specialty_decoy") )
			{
				if ( DistanceSquared( player.origin, self.origin ) < 240 * 240 )
				{
					player thread watch_decoy( self );
				}
			}
		}
	}

}

function get_decoy_spawn_loc() 
{
	// this needs to be much more intelligent
	return self.origin - 240 * AnglesToForward(self.angles);
}

function watch_decoy( sensor_grenade )
{
	origin = self get_decoy_spawn_loc(); 
	decoy_grenade = sys::Spawn( "script_model", origin );
	decoy_grenade.angles = -1 * self.angles; 
	{wait(.05);};

	decoy_grenade.initial_velocity = -1 * self GetVelocity();

	decoy_grenade thread decoy::simulate_weapon_fire(self);

	wait 15; 

	decoy_grenade notify( "done");
	decoy_grenade notify( "death_before_explode");
	
	decoy_grenade delete();
}





