#using scripts\codescripts\struct;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\table_shared;
#using scripts\shared\scoreevents_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

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

function switch_to_last_non_killstreak_weapon( immediate )
{
	//Check if we were going into last stand
	ball = GetWeapon( "ball" );
	if( isdefined( ball ) && self HasWeapon( ball ) )
	{
		self switchToWeaponImmediate( ball );
		self DisableWeaponCycling();		
	} 
	else if ( ( isdefined( self.lastStand ) && self.lastStand ) )
	{
		if ( isdefined( self.laststandpistol ) && self hasWeapon( self.laststandpistol ) )
		{
			self switchToWeapon( self.laststandpistol );
		}
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
			if( ( isdefined( immediate ) && immediate ) )
				self switchToWeaponImmediate( self.lastNonKillstreakWeapon );
			else
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

function WaitForTimecheck( duration, callback, endCondition1, endCondition2, endCondition3 )
{
	self endon( "hacked" );
	
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

		if ( !item.weapon.isEquipment && !( isdefined( item.destroyedByEmp ) && item.destroyedByEmp ) )
		{
			continue;
		}

		watcher = item.owner weaponobjects::getWatcherForWeapon( item.weapon );

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
	
	ai_tanks = GetEntArray( "talon", "targetname" );
	DestroyEntities( ai_tanks, attacker, team, weapon );

	remoteMissiles = GetEntArray( "remote_missile", "targetname" );
	DestroyEntities( remoteMissiles, attacker, team, weapon );
	
	remoteDrone = GetEntArray( "remote_drone", "targetname" );
	DestroyEntities( remoteDrone, attacker, team, weapon );
	
	script_vehicles = GetEntArray( "script_vehicle", "classname" );
	foreach( vehicle in script_vehicles )
	{
		if( isdefined( team ) && ( vehicle.team == team ) && IsVehicle( vehicle ) )
		{
			if( isdefined( vehicle.DetonateViaEMP ) && ( isdefined( weapon.isEmpKillstreak ) && weapon.isEmpKillstreak ) )
			{
				vehicle [[vehicle.DetonateViaEMP]]( attacker, weapon );
			}
			
			if( isdefined( vehicle.archetype ) )
			{
				if( vehicle.archetype == "raps" )
				{
					vehicle raps::detonate( attacker );	
				}
				else if( vehicle.archetype == "turret" || vehicle.archetype == "rcbomb" )
				{
					vehicle DoDamage( vehicle.health + 1, vehicle.origin, attacker, attacker, "", "MOD_EXPLOSIVE", 0, weapon );
				}
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

	droneStrikes = GetEntArray( "drone_strike", "targetname" );
	foreach( droneStrike in droneStrikes )
	{
		if ( isdefined( team ) && isdefined( droneStrike.team ) )
		{
			if ( droneStrike.team != team )
			{
				continue;
			}
		}
		else if ( droneStrike.owner == attacker )
		{
			continue;
		}

		droneStrike notify( "emp_deployed", attacker );
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
		// HACK: Don't try to explode the escort robot!
		if ( level.robot === robot )
			continue;
		
		if( isdefined( team ) && ( robot.team == team ) )
		{
			if( isplayer( attacker ) )
			{
				scoreevents::processScoreEvent( "destroyed_combat_robot", attacker, robot.owner, weapon );
				LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_COMBAT_ROBOT", attacker.entnum );		
			}			
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
