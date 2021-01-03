#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#precache( "fx", "_t6/misc/fx_equip_light_red" );
#precache( "fx", "_t6/misc/fx_equip_light_green" );

#namespace scrambler;

function init_shared()
{	
	level._effect["scrambler_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["scrambler_friendly_light"] = "_t6/misc/fx_equip_light_green";
	level.scramblerWeapon = GetWeapon( "scrambler" );	
	level.scramblerLength = 30.0;

	// should be kept in sync with the radius in _scrambler.csc
	level.scramblerOuterRadiusSq = 1000 * 1000;
	level.scramblerInnerRadiusSq = 600 * 600;
	
	clientfield::register( "missile", "scrambler", 1, 1, "int" );
}

function createScramblerWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( "scrambler", self.team );
	watcher.onSpawn =&onSpawnScrambler;
	watcher.onDetonateCallback =&scramblerDetonate;
	watcher.onStun = &weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.reconModel = "t5_weapon_scrambler_world_detect";
	watcher.hackable = true;
	watcher.onDamage =&watchScramblerDamage;
}

function onSpawnScrambler( watcher, player ) // self == scrambler
{
	player endon("disconnect");
	self endon( "death" );
	
	self thread weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	player.scrambler = self;
	self SetOwner( player );
	self SetTeam( player.team );
	self.owner = player;
	self clientfield::set( "scrambler", 1 );

	if ( !self util::isHacked() )
	{
		player AddWeaponStat( self.weapon, "used", 1 );
	}

	self thread watchShutdown( player );
	level notify( "scrambler_spawn" );
}

function scramblerDetonate( attacker, weapon )
{
	if ( !isdefined( weapon ) || !weapon.isEmp )
	{
		PlayFX( level._equipment_explode_fx, self.origin );
	}

	if ( self.owner util::IsEnemyPlayer( attacker ) )
	{
		attacker challenges::destroyedEquipment( weapon );
	}

	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	self delete();
}

function watchShutdown( player )
{
	self util::waittill_any( "death", "hacked" );
	level notify( "scrambler_death" );

	if ( isdefined( player ) )
		player.scrambler = undefined;
}

function destroyEnt()
{
	self delete();
}

function watchScramblerDamage( watcher ) // self == scrambler
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

		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		if ( level.teamBased && attacker.team == self.owner.team && attacker != self.owner )
			continue;

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
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
		//	attacker _properks::shotEquipment( self.owner, iDFlags );
			watcher thread weaponobjects::waitAndDetonate( self, 0.0, attacker, weapon );
		}
	}
}

function ownerSameTeam( owner1, owner2 )
{
	if ( !level.teamBased )
	{
		return false;
	}
	
	if ( !isdefined( owner1 ) || !isdefined( owner2 ) )
	{
		return false;
	}

	if ( !isdefined( owner1.team ) || !isdefined( owner2.team ) )
	{
		return false;
	}

	return ( owner1.team == owner2.team );
}

function checkScramblerStun()
{
	scramblers = GetEntArray( "grenade", "classname" );

	if ( isdefined( self.name ) && self.name == "scrambler" )
	{
		return false;
	}

	for ( i = 0; i < scramblers.size; i++ )
	{
		scrambler = scramblers[i];
		
		if ( !IsAlive( scrambler ) )
		{
			continue;
		}

		if ( !isdefined( scrambler.name ) )
		{
			continue;
		}

		if ( scrambler.name != "scrambler" )
		{
			continue;
		}

		if ( ownerSameTeam( self.owner, scrambler.owner ) )
		{
			continue;
		}
		
		// check is cylindrical
		flattenedSelfOrigin = (self.origin[0], self.origin[1], 0 );
		flattenedscramblerOrigin = (scrambler.origin[0], scrambler.origin[1], 0 );
		if ( DistanceSquared( flattenedSelfOrigin, flattenedscramblerOrigin ) < level.scramblerOuterRadiusSq )
		{
			return true;
		}
	}

	return false;
}

/*function watchScramble()//moved from _turret
{
	self endon( "death" );
	self endon( "turret_deactivated" );
	self endon( "turret_carried" );

	if ( self scrambler::checkScramblerStun() )
	{
		self thread scramblerStun( true );
	}

	for ( ;; )
	{
		level util::waittill_any( "scrambler_spawn", "scrambler_death", "hacked", "turret_stun_ended" );
		WAIT_SERVER_FRAME;

		if ( self scrambler::checkScramblerStun() )
		{
			self thread scramblerStun( true );
		}
		else
		{
			self scramblerStun( false );
		}
	}
}*/

/*function watchScramble( watcher )//moved from _weaponobjects
{
	self endon( "death" );
	self endon( "hacked" );

	self util::waitTillNotMoving();

	if ( self scrambler::checkScramblerStun() )
	{
		self thread weaponobjects::stunStart( watcher );
	}
	else
	{
		self stunStop();
	}

	for ( ;; )
	{
		level util::waittill_any( "scrambler_spawn", "scrambler_death", "hacked" );

		if ( isdefined( self.owner ) && self.owner IsEMPJammed() )
		{
			continue;
		}

		if ( self scrambler::checkScramblerStun() )
		{
			self thread weaponobjects::stunStart( watcher );
		}
		else
		{
			self stunStop();
		}
	}
}*/
