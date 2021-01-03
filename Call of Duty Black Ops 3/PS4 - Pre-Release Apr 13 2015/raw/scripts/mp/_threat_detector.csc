#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

                                            
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace threat_detector;


function autoexec __init__sytem__() {     system::register("threat_detector",&__init__,undefined,undefined);    }		

function __init__()
{
	clientfield::register( "missile", "threat_detector", 1, 1, "int" );
	callback::add_weapon_watcher( &createThreatDetectorWatcher );
}

function createThreatDetectorWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "threat_detector", self.team );
	watcher.headicon = false;
	watcher.onSpawn =&onSpawnThreatDetector;
	watcher.onDetonateCallback =&threatDetectorDestroyed;
	watcher.stun = &weaponobjects::weaponStun;
	watcher.stunTime = 0;
	watcher.reconModel = "t6_wpn_motion_sensor_world_detect";
	watcher.onDamage =&watchThreatDetectorDamage;

	watcher.enemyDestroy = true;
}

function onSpawnThreatDetector( watcher, player )
{
	self endon( "death" );
	
	self thread weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	self SetOwner( player );
	self SetTeam( player.team );
	self.owner = player;
	
	self PlayLoopSound( "wpn_sensor_nade_lp" );
	self hacker_tool::registerWithHackerTool( level.equipmentHackerToolRadius, level.equipmentHackerToolTimeMs );

	player AddWeaponStat( self.weapon, "used", 1 );

	self thread watchForStationary( player );
}

function watchForStationary( owner )
{
	self endon( "death" );
	self endon( "hacked" );
	self endon( "explode" );
	owner endon( "death" );
	owner endon( "disconnect" );

	self waittill("stationary" );
	self clientfield::set( "threat_detector", 1 );
}

function trackSensorGrenadeVictim( victim )
{
	if( !isdefined( self.sensorGrenadeData ) )
	{
		self.sensorGrenadeData = [];
	}
	
	if ( !isdefined( self.sensorGrenadeData[victim.clientid] ) )
	{
		self.sensorGrenadeData[victim.clientid] = getTime();
	}
	
	self clientfield::set_to_player( "threat_detected", 1 );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function threatDetectorDestroyed( attacker, weapon )
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
function watchThreatDetectorDamage( watcher ) // self == sensor grenade
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
