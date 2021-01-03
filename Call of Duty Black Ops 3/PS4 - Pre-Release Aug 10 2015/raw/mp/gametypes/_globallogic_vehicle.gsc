#using scripts\codescripts\struct;

#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_loadout;

#using scripts\mp\_vehicle;

#namespace globallogic_vehicle;

function Callback_VehicleSpawned( spawner )
{
	self.health = self.healthdefault;
		
	if ( IsSentient( self ) )
	{
		self spawner::spawn_think( spawner );
	}
	else
	{
		vehicle::init( self );
	}
		
	if ( isdefined( level.vehicle_main_callback ) )
	{
		if( isdefined( level.vehicle_main_callback[ self.vehicleType ] ) )
		{
			self thread [[level.vehicle_main_callback[ self.vehicleType ]]]();
		}
		else if( isdefined( self.scriptVehicleType ) && isdefined( level.vehicle_main_callback[ self.scriptVehicleType ] ) )
		{
			self thread [[level.vehicle_main_callback[ self.scriptVehicleType ]]]();
		}
	}
}

function Callback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	selfEntNum = self getEntityNumber(); // need to cache off as "self" will become a removed entity after finishVehicleDamage executes.
	eAttackerNotSelf = ( isdefined( eAttacker ) && ( eAttacker != self ) );
	eAttackerIsNotOwner = ( isdefined( eAttacker ) && isdefined( self.owner ) && ( eAttacker != self.owner ) );
	tryToDoDamageFeedback = !isdefined( self.noDamageFeedback ) || !self.noDamageFeedback;

	// already applied in the Callback_VehicleDamage
	if ( !(1 & iDFlags) )
	{
		// create a class specialty checks; CAC:bulletdamage, CAC:armorvest
		iDamage = loadout::cac_modified_vehicle_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor );
	}
	
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();
	
	if ( game["state"] == "postgame" )
	{
		// at the end of a game, all vehicles should explode without any game logic firing off
		self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, false);
		return;
	}
	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;
	
	
	if ( isdefined( self.overrideVehicleDamage ) )
	{
		iDamage = self [[self.overrideVehicleDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
	}
	else if ( isdefined( level.overrideVehicleDamage ) )
	{
		iDamage = self [[level.overrideVehicleDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
	}

	assert(isdefined(iDamage), "You must return a value from a damage override function.");

	if( iDamage == 0 )
		return;
			
	// Don't do knockback if the damage direction was not specified
	if( !isdefined( vDir ) )
		iDFlags |= 4;
	
	friendly = false;

	if ( ( isdefined( self.maxhealth ) && (self.health == self.maxhealth)) || !isdefined( self.attackers ) )
	{
		self.attackers = [];
		self.attackerData = [];
		self.attackerDamage = [];
	}

	// explosive barrel/car detection
	if ( weapon == level.weaponNone && isdefined( eInflictor ) )
	{
		if ( isdefined( eInflictor.targetname ) && eInflictor.targetname == "explodable_barrel" )
			weapon = GetWeapon( "explodable_barrel" );
		else if ( isdefined( eInflictor.destructible_type ) && isSubStr( eInflictor.destructible_type, "vehicle_" ) )
			weapon = GetWeapon( "destructible_car" );
	}


	// check for completely getting out of the damage
	if( !(iDFlags & 2048) )
	{
		if ( self IsVehicleImmuneToDamage( iDFlags, sMeansOfDeath, weapon ) )
		{
			return;
		}

		// This handles direct damage only. Splash is done in VehicleRadiusDamage
		if ( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_GRENADE" )
		{
			iDamage *= weapon.vehicleProjectileDamageScalar;
			iDamage = int(iDamage);
			
			if ( iDamage == 0 )
			{
				return;
			}
		}
		// Except for splash that we want to modify additionally based on "underneath"
		else if ( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
		{
			iDamage *= GetVehicleUnderneathSplashScalar( weapon );
			iDamage = int(iDamage);
			
			if ( iDamage == 0 )
			{
				return;
			}
		}
	
		iDamage *= level.vehicleDamageScalar;
		iDamage = int(iDamage);
		
		if ( isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;
		
		if( !IsDefined( self.maxhealth ) )
		{
			self.maxhealth = self.healthdefault; // healthdefault if from the GDT
		}
		
		prevHealthRatio = self.health / self.maxhealth;
		
		//add some damage indicators
		//driver = self GetSeatOccupant( 0 );
		//if( IsPlayer( driver ) && driver IsRemoteControlling() )
		//{
		//	damagePct = iDamage / self.maxhealth;
		//	damagePct = int( max( damagePct, 3 ) );
		//	driver AddToDamageIndicator( damagePct, vDir );
		//}
		
		if ( isdefined( self.owner ) && IsPlayer(self.owner) )
		{
			team = self.owner.pers["team"];
		}
		else
		{
			team = self vehicle::vehicle_get_occupant_team();
		}
		
		if ( level.teamBased && isPlayer( eAttacker ) && (team == eAttacker.pers["team"]) )
		{
			if ( level.friendlyfire == 0 ) // no one takes damage
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;

				self.lastDamageWasFromEnemy = false;
			}
			else if ( level.friendlyfire == 1 ) // the friendly takes damage
			{
				self.lastDamageWasFromEnemy = false;				
			}
			else if ( level.friendlyfire == 2 ) // no one takes damage
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;

				self.lastDamageWasFromEnemy = false;
			}
			else if ( level.friendlyfire == 3 ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);

				self.lastDamageWasFromEnemy = false;	
			}
			
			// Make sure at least one point of damage is done
			if ( iDamage < 1 )
				iDamage = 1;
				
			self globallogic_player::giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );

			self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, false);
			
			friendly = true;
		}
		else if( !level.hardcoreMode && isdefined( self.owner ) && isdefined( eAttacker ) && isdefined( eAttacker.owner ) && ( self.owner == eAttacker.owner )  && ( self != eAttacker ) )
		{
			//don't allow your killstreaks to kill your other killstreaks
			return;
		}
		else
		{
			if ( !level.teamBased && isdefined( self.archetype ) && self.archetype == "raps" )
			{
				// allow raps to be damaged by owners in FFA games
			}
			else if ( !level.teamBased && isdefined( self.targetname ) && self.targetname == "rcbomb" )
			{
				// allow the rc bomb to be damaged by owners in FFA games (DT 75676)
			}
			else if ( isdefined( self.owner ) && isdefined( eAttacker ) && self.owner == eAttacker ) 
			{
				return;
			}

			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;
		
			if ( issubstr( sMeansOfDeath, "MOD_GRENADE" ) && isdefined( eInflictor ) && isdefined( eInflictor.isCooked ) )
				self.wasCooked = getTime();
			else
				self.wasCooked = undefined;
			
			attacker_seat = undefined;
			if ( isdefined( eAttacker ) )
				attacker_seat = self GetOccupantSeat( eAttacker );
	
			self.lastDamageWasFromEnemy = (isdefined( eAttacker ) && !isdefined(attacker_seat));
			
			self globallogic_player::giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );

			self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, false);

			// IMPORTANT NOTE: "self" is a removed entity from here on out!!!
			
			if ( level.gameType == "hack" && !weapon.isEmp )
			{
				iDamage = 0;
			}
		}

		if ( eAttackerNotSelf && ( eAttackerIsNotOwner || ( isdefined( self.selfDestruct ) && !self.selfDestruct ) ) )
		{
			if ( tryToDoDamageFeedback )
			{
				dofeedback = true;
				if( isdefined( self.damageTaken ) && isdefined( self.maxhealth ) && self.damageTaken > self.maxhealth )
					dofeedback = false;
				
				if( ( isdefined( self.shuttingDown ) && self.shuttingDown ) )
					dofeedback = false;
				
				if ( dofeedback && damagefeedback::doDamageFeedback( weapon, eInflictor ) )
				{   
					if ( iDamage > 0 )
						eAttacker thread damagefeedback::update( sMeansOfDeath, eInflictor );
				}
			}
		}
	}
 
	/#
	// Do debug print if it's enabled
	if(GetDvarint( "g_debugDamage"))
		println("actor:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage + " hitLoc:" + sHitLoc);	
	#/
	if(1) // self.sessionstate != "dead")
	{
		lpselfnum = selfEntNum;
		lpselfteam = "";
		lpattackerteam = "";

		if(isPlayer(eAttacker)) 
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		logPrint("VD;" + lpselfnum + ";" + lpselfteam + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
	
}

function Callback_VehicleRadiusDamage( eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime )
{
	// create a class specialty checks; CAC:bulletdamage, CAC:armorvest
	iDamage = loadout::cac_modified_vehicle_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor );
	fInnerDamage = loadout::cac_modified_vehicle_damage( self, eAttacker, fInnerDamage, sMeansOfDeath, weapon, eInflictor );
	fOuterDamage = loadout::cac_modified_vehicle_damage( self, eAttacker, fOuterDamage, sMeansOfDeath, weapon, eInflictor );
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();
	
	if ( game["state"] == "postgame" )
		return;
	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;
	
	friendly = false;

	// check for completely getting out of the damage
	if( !(iDFlags & 2048) )
	{
	  if ( self IsVehicleImmuneToDamage( iDFlags, sMeansOfDeath, weapon ) )
	  {
	  	return;
	  }
	  
		// THIS HANDLES SPLASH DAMAGE ONLY. SPLASH IS DONE IN VehicleRadiusDamage
		if ( sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE" )
		{
			scalar = weapon.vehicleProjectileSplashDamageScalar;
			iDamage = int(iDamage * scalar);
			fInnerDamage = (fInnerDamage * scalar);
			fOuterDamage = (fOuterDamage * scalar);
			
			if ( fInnerDamage == 0 )
			{
				return;
			}
			if ( iDamage < 1 )
			{
				iDamage = 1;
			}
		}
		
		occupant_team = self vehicle::vehicle_get_occupant_team();
			
		if ( level.teamBased && isPlayer( eAttacker ) && (occupant_team == eAttacker.pers["team"]) )
		{
			if ( level.friendlyfire == 0 ) // no one takes damage
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			else if ( level.friendlyfire == 1 ) // the friendly takes damage
			{
				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			else if ( level.friendlyfire == 2 ) // Attacker will take damage from artillery
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			else if ( level.friendlyfire == 3 ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
			}
			
			friendly = true;
		}
		else if( !level.hardcoreMode && isdefined( self.owner ) && isdefined( eAttacker.owner ) && self.owner == eAttacker.owner )//don't allow your killstreaks to kill your other killstreaks
		{
			return;
		}
		else
		{
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;
		
			self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);
		}
	}
}

function Callback_VehicleKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	if ( game["state"] == "postgame" && ( !isdefined( self.selfDestruct ) || !self.selfDestruct ) )	
		return;
	
	// do vehicle killed callback
	// generally this should be used as system callback, and the callback "on_vehicle_killed" callback can be used by level script
	if ( isdefined( self.overrideVehicleKilled ) )
	{
		self [[self.overrideVehicleKilled]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
	}
	
	if( isdefined( self.overrideVehicleDeath ) )
	{
		self [[self.overrideVehicleDeath]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
	}
}

function vehicleCrush()
{
	self endon("disconnect");
	
	if(isdefined( level._effect ) && isdefined( level._effect["tanksquish"] ) )
	{
		PlayFX( level._effect["tanksquish"], self.origin + (0, 0, 30));
	}

	self playsound( "chr_crunch" );
}

// damage going through this function will have already passed through the
// GetVehicleProjectileSplashScalar so keep that in mind when adjusting values
function GetVehicleUnderneathSplashScalar( weapon )
{
	if ( isdefined( self ) && isdefined( self.ignore_vehicle_underneath_splash_scalar ) )
		return 1.0;

	if ( weapon.name == "satchel_charge" ) 
	{
		// canceling all splash scaling done by the other function
		scale = 10.0;
		
		// making it really deadly
		scale *= 3.0;
	}
	else 
	{
		scale = 1.0;
	}
	
	return scale;
}

function AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon )
{
	if (isdefined( self.allowFriendlyFireDamageOverride ) )
	{
		return [[self.allowFriendlyFireDamageOverride]](eInflictor, eAttacker, sMeansOfDeath, weapon );
	}
	
	return false;
}