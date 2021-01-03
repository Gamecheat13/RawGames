#using scripts\codescripts\struct;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\table_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	  

#namespace killstreaks;

function is_killstreak_weapon( weapon )
{
	if ( weapon == level.weaponNone || weapon.notKillstreak )
	{
		return false;
	}

	if ( weapon.isSpecificUse || is_weapon_associated_with_killstreak( weapon ) )
	{
		return true;
	}

	return false;
}

function is_weapon_associated_with_killstreak( weapon )
{
	return isdefined( level.killstreakWeapons[weapon] );
}

function switch_to_last_non_killstreak_weapon()
{
	//Check if we were going into last stand
	if ( ( isdefined( self.lastStand ) && self.lastStand ) && isdefined( self.laststandpistol ) && self hasWeapon( self.laststandpistol ) )
	{
		self switchToWeapon( self.laststandpistol );
	}
	else if( isdefined( self.lastNonKillstreakWeapon ) && self hasWeapon(self.lastNonKillstreakWeapon) )
	{
		if ( self.lastNonKillstreakWeapon.isHeroWeapon )
		{
			if ( self.lastNonKillstreakWeapon.gadget_heroversion_2_0 )
			{
				if ( self.lastNonKillstreakWeapon.isGadget && self GetAmmoCount( self.lastNonKillstreakWeapon ) > 0 )
				{
					slot = self GadgetGetSlot( self.lastNonKillstreakWeapon );
					
					if ( self ability_player::gadget_is_in_use( slot ) )
					{
						return self switchToWeapon( self.lastNonKillstreakWeapon );						
					}
				}				
			}
			else
			{
				if ( self GetAmmoCount( self.lastNonKillstreakWeapon ) > 0 )
				{
					return self switchToWeapon( self.lastNonKillstreakWeapon );
				}				
			}
			
			// cycle
			self switchToWeapon();
			return true;
		}
		else
		{
			self switchToWeapon( self.lastNonKillstreakWeapon );
		}
	}
	else if( isdefined( self.lastDroppableWeapon ) && self hasWeapon(self.lastDroppableWeapon) )
	{
		self switchToWeapon( self.lastDroppableWeapon );
	}
	else
	{
		return false;
	}
		
	return true;
}

function get_killstreak_weapon( killstreak )
{
	if( !isdefined( killstreak ) )
	{
		return level.weaponNone;
	}

	Assert( isdefined(level.killstreaks[killstreak]) );
	
	return level.killstreaks[killstreak].weapon;
}

function isHeldInventoryKillstreakWeapon( killstreakWeapon )
{
	switch( killstreakWeapon.name )
	{
	case "inventory_minigun":
	case "inventory_m32":
		return true;
	}

	return false;
}

function should_not_timeout( killstreak )
{
/#
	assert( isdefined(killstreak), "Can not register a killstreak without a valid type name.");
	assert( isdefined(level.killstreaks[killstreak]), "Killstreak needs to be registered before calling register_dev_dvar.");

	if ( isdefined( level.killstreaks[killstreak].devTimeoutDvar ) )
			return GetDvarInt( level.killstreaks[killstreak].devTimeoutDvar );
#/

	return false;	
}

function WaitForTimeout( killstreak, duration, callback, endCondition1, endCondition2, endCondition3 )
{
	if( isdefined( endCondition1 ) )
		self endon( endCondition1 );
	if( isdefined( endCondition2 ) )
		self endon( endCondition2 );
	if( isdefined( endCondition3 ) )
		self endon( endCondition3 );
	
	hostmigration::MigrationAwareWait( duration );
	
	if (killstreaks::should_not_timeout(killstreak))
	{
		return;
	}		

	self notify( "timed_out" );
	self [[ callback ]]();
}

function WaitForTimecheck( duration, callback, endCondition1, endCondition2, endCondition3 )
{
	if( isdefined( endCondition1 ) )
		self endon( endCondition1 );
	if( isdefined( endCondition2 ) )
		self endon( endCondition2 );
	if( isdefined( endCondition3 ) )
		self endon( endCondition3 );
	
	hostmigration::MigrationAwareWait( duration );
	
	self notify( "time_check" );
	self [[ callback ]]();
}

function EMP_IsEMPd()
{
	if( isdefined( level.enemyEMPActiveFunc ) )
	{
		return self [[ level.enemyEMPActiveFunc ]]();
	}
	
	return false;
}

function WaitTillEMP( onEmpdCallback, arg )
{
	self endon ( "death" );
	self endon ( "delete" );
	
	self waittill( "emp_deployed", attacker );
	
	if( isdefined( onEmpdCallback ) )
	{
		[[ onEmpdCallback ]]( attacker, arg );
	}
}

function HasUav( team_or_entnum )
{
	return level.activeUAVs[ team_or_entnum ] > 0;
}

function HasSatellite( team_or_entnum )
{
	return level.activeSatellites[ team_or_entnum ] > 0;
}

function DestroyOtherTeamsEquipment( attacker, weapon )
{
	if( level.teamBased )
	{
		foreach( team in level.teams )
		{
			if( team == attacker.team )
			{
				continue;
			}
				
			DestroyEquipment( attacker, team, weapon );
			DestroyTacticalInsertions( attacker, team );
		}
	}
	
	DestroyEquipment( attacker, "free", weapon );
	DestroyTacticalInsertions( attacker, "free" );
}

function DestroyEquipment( attacker, team, weapon )
{
	for( i = 0; i < level.missileEntities.size; i++ )
	{
		item = level.missileEntities[i];

		if ( !isdefined( item.weapon ) )
		{
			continue;
		}

		if ( !isdefined( item.owner ) )
		{
			continue;
		}

		if ( isdefined( team ) && item.owner.team != team ) 
		{
			continue;
		}
		else if ( item.owner == attacker )
		{
			continue;
		}

		if ( !item.weapon.isEquipment && item.weapon.name != "proximity_grenade" )
		{
			continue;
		}

		watcher = item.owner getWatcherForWeapon( item.weapon );

		if ( !isdefined( watcher ) )
		{
			continue;
		}

		watcher thread weaponobjects::waitAndDetonate( item, 0.0, attacker, weapon );
	}
}

function DestroyTacticalInsertions( attacker, victimTeam )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];

		if ( !isdefined( player.tacticalInsertion ))
		{
			continue;
		}

		if ( level.teamBased && player.team != victimTeam )
		{
			continue;
		}

		if ( attacker == player )
		{
			continue;
		}

		player.tacticalInsertion thread tacticalinsertion::fizzle();
	}
}

function GetWatcherForWeapon( weapon )
{
	if ( !isdefined( self ) )
	{
		return undefined;
	}

	if ( !IsPlayer( self ) )
	{
		return undefined;
	}

	for ( i = 0; i < self.weaponObjectWatcherArray.size; i++ )
	{
		if ( self.weaponObjectWatcherArray[i].weapon != weapon )
		{ 
			continue;
		}

		return ( self.weaponObjectWatcherArray[i] );
	}

	return undefined;
}

function DestroyOtherTeamsActiveVehicles( attacker, weapon )
{
	if( level.teamBased )
	{
		foreach( team in level.teams)
		{
			if( team == attacker.team )
			{
				continue;
			}
				
			DestroyActiveVehicles( attacker, team, weapon );
		}
	}
	
	DestroyActiveVehicles( attacker, undefined, weapon );
}

function DestroyActiveVehicles( attacker, team, weapon )
{
	targets = Target_GetArray();
	DestroyEntities( targets, attacker, team, weapon );

	rcbombs = GetEntArray( "rcbomb", "targetname" );
	DestroyEntities( rcbombs, attacker, team, weapon );

	remoteMissiles = GetEntArray( "remote_missile", "targetname" );
	DestroyEntities( remoteMissiles, attacker, team, weapon );
	
	remoteDrone = GetEntArray( "remote_drone", "targetname" );
	DestroyEntities( remoteDrone, attacker, team, weapon );
	
	script_vehicles = GetEntArray( "script_vehicle", "classname" );
	foreach( vehicle in script_vehicles )
	{
		if( isdefined( team ) && ( vehicle.team == team ) && IsVehicle( vehicle ) )
		{
			if( isdefined( vehicle.archetype ) )
			{
				if( vehicle.archetype == "raps" )
				{
					vehicle raps::detonate( attacker );	
				}
				else if( vehicle.archetype == "turret" )
				{
					vehicle DoDamage( vehicle.health + 1, vehicle.origin, attacker, attacker, "", "MOD_EXPLOSIVE", 0, weapon );
				}
			}
			else if ( isdefined( vehicle.DetonateViaEMP ) )
			{
				vehicle [[vehicle.DetonateViaEMP]]( attacker );
			}
		}
	}
	
	planeMortars = GetEntArray( "plane_mortar", "targetname" );
	foreach( planeMortar in planeMortars )
	{
		if ( isdefined( team ) && isdefined( planeMortar.team ) )
		{
			if ( planeMortar.team != team )
			{
				continue;
			}
		}
		else if ( planeMortar.owner == attacker )
		{
			continue;
		}

		planeMortar notify( "emp_deployed", attacker );
	}


	satellites = GetEntArray( "satellite", "targetname" );
	foreach( satellite in satellites )
	{
		if ( isdefined( team ) && isdefined( satellite.team ) )
		{
			if ( satellite.team != team )
			{
				continue;
			}
		}
		else if ( satellite.owner == attacker )
		{
			continue;
		}

		satellite notify( "emp_deployed", attacker );
	}

	robots = GetAIArchetypeArray( "robot" );
	foreach( robot in robots )
	{
		if( isdefined( team ) && ( robot.team == team ) )
		{
			robot Kill();
		}
	}
	
	if ( isdefined ( level.missile_swarm_owner ) ) 
	{
		if ( level.missile_swarm_owner util::IsEnemyPlayer( attacker ) )
		{
			level.missile_swarm_owner notify( "emp_destroyed_missile_swarm", attacker );
		}
	}
}

function DestroyEntities( entities, attacker, team, weapon )
{
	meansOfDeath = "MOD_EXPLOSIVE";

	damage = 5000;
	direction_vec = ( 0, 0, 0 );
	point = ( 0, 0, 0 );
	modelName = "";
	tagName = "";
	partName = "";

	foreach( entity in entities )
	{
		if ( isdefined( team ) && isdefined( entity.team ) )
		{
			if ( entity.team != team )
			{
				continue;
			}
		}
		else if ( isdefined( entity.owner ) && ( entity.owner == attacker ) )
		{
			continue;
		}

		entity notify( "damage", damage, attacker, direction_vec, point, meansOfDeath, tagName, modelName, partName, weapon );
	}
}

function init_damage_per_weapon_table( table_name )
{	
	level._killstreakDamagePerWeapon = table::load( table_name, "ScoreStreakHeader", true );
}

function get_hardpoint_type_override( hardpointType )
{
	if ( ( isdefined( self.useVTOL ) && self.useVTOL ) && hardpointType == "supply_drop" )
	{
		hardpointType = "supply_drop_vtol";
	}
	
	return hardpointType;
}

function get_max_health( hardpointType )
{
	hardpointType = get_hardpoint_type_override( hardpointType );

	if ( isdefined( level._killstreakDamagePerWeapon[hardpointType] ) )
    {
		if ( isdefined( level._killstreakDamagePerWeapon[hardpointType]["HealthValue"] ) )
		{
			return level._killstreakDamagePerWeapon[hardpointType]["HealthValue"];
		}
    }
	
	return undefined;
}

function get_low_health( hardpointType )
{
	hardpointType = get_hardpoint_type_override( hardpointType );

	if ( isdefined( level._killstreakDamagePerWeapon[hardpointType] ) )
    {
		if ( isdefined( level._killstreakDamagePerWeapon[hardpointType]["LowHealth"] ) )
		{
			return level._killstreakDamagePerWeapon[hardpointType]["LowHealth"];
		}
    }
	
	return undefined;
}

function get_weapon_damage( hardpointType, maxhealth, attacker, weapon, type, damage, flags, chargeShotLevel )
{
	hardpointType = get_hardpoint_type_override( hardpointType );

	weapon_damage = undefined;
	
	if ( isdefined( level._killstreakDamagePerWeapon[hardpointType] ) )
    {
		if ( isdefined( weapon ) )
		{
			shotsToKill = level._killstreakDamagePerWeapon[hardpointType][weapon.rootweapon.name];
		
			if ( isdefined( shotsToKill ) )
			{			
				if ( shotsToKill < 0 )
				{
					// not handled here
				}
				else if ( shotsToKill > 0 )
				{
					if ( isdefined( chargeShotLevel ) && chargeShotLevel > 0 )
					{
						// chargeShotLevel should be betweek 0 and 1.
						// 1 = full charge
						// > 0 = fraction of charge
						shotsToKill = shotsToKill / chargeShotLevel;
					}
					
					weapon_damage = maxhealth / shotsToKill + 1;
				}
				else
				{
					// immune
					weapon_damage = 0;
				}
			}
		}		
		
		if ( !isdefined( weapon_damage ) )
		{
			if ( type == "MOD_RIFLE_BULLET" || type == "MOD_PISTOL_BULLET" )
			{
				hasFMJ =  isdefined( attacker ) && isPlayer( attacker ) && attacker HasPerk( "specialty_armorpiercing" );
				
				if ( hasFMJ )
				{
					clipsToKill = level._killstreakDamagePerWeapon[hardpointType]["ClipsToKillFMJ"];					
				}
				else
				{
					clipsToKill = level._killstreakDamagePerWeapon[hardpointType]["ClipsToKill"];					
				}
				
				if ( isdefined( clipsToKill ) )
				{
					if ( clipsToKill < 0 )
					{
						// not handled here
					}
					else if ( clipsToKill > 0 )
					{
						clipSize = 10;
						
						if ( isdefined( weapon ) )
						{
							clipSize = weapon.rootweapon.clipSize;							
						}						
						
						weapon_damage = maxhealth / clipSize / clipsToKill + 1;
					}
					else
					{
						// immune
						weapon_damage = 0;
					}
				}				
			}
			else if ( type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" || type == "MOD_EXPLOSIVE" )
			{
				rocketsToKill = level._killstreakDamagePerWeapon[hardpointType]["Rockets"];		
				
   				if ( isdefined( rocketsToKill ) )
				{
					if ( rocketsToKill < 0 )
					{
						// not handled here
					}
					else if ( rocketsToKill > 0 )
					{
						weapon_damage = maxhealth / rocketsToKill + 1;
					}
					else
					{
						// immune
						weapon_damage = 0;
					}
				}
			}
			else
			{
				// not handled here
			}
		}
    }
	
	return weapon_damage;
}