#using scripts\codescripts\struct;

#using scripts\shared\damagefeedback_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\callbacks_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\gametypes\_damagefeedback;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_weapons;

#namespace globallogic_vehicle;

function Callback_VehicleSpawned( spawner )
{
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
	// already applied in the Callback_VehicleDamage
	/*if ( !(level.iDFLAGS_RADIUS & iDFlags) )
	{
		// create a class specialty checks; CAC:bulletdamage, CAC:armorvest
		iDamage = _class::cac_modified_vehicle_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor );
	}*/
	
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();
	
	if ( game["state"] == "postgame" )
		return;
	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;
	
	
	// Don't do knockback if the damage direction was not specified
	if( !isdefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
	
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
	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
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
		iDamage *= self GetVehDamageMultiplier(sMeansOfDeath);
		iDamage = int(iDamage);
		
		if ( isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;

		if( !isdefined( self.maxhealth ) )
		{
			self.maxhealth = self.healthdefault; // healthdefault if from the GDT
		}
		
		prevHealthRatio = self.health / self.maxhealth;
		
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

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, true);
			}
			else if ( level.friendlyfire == 1 ) // the friendly takes damage
			{
				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, false);
			}
			else if ( level.friendlyfire == 2 ) // no one takes damage
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, true);
			}
			else if ( level.friendlyfire == 3 ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, false);
			}
			
			friendly = true;
		}
		else
		{
			if ( !level.teamBased && isdefined( self.targetname ) && self.targetname == "rcbomb" )
			{
				// allow the rc bomb to be damaged by owners in FFA games (DT 75676)
			}
			else if ( isdefined( self.owner ) && isdefined( eAttacker ) && self.owner == eAttacker ) 
				return;

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
			
			self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, false);

			if ( level.gameType == "hack" && !weapon.isEmp )
			{
				iDamage = 0;
			}
		}

		if ( isdefined(eAttacker) && eAttacker != self )
		{
			if( damagefeedback::doDamageFeedback( weapon, eInflictor ) )
			{
				if ( iDamage > 0 )
					eAttacker thread damagefeedback::update( sMeansOfDeath, eInflictor );
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
		lpselfnum = self getEntityNumber();
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
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();
	
	if ( game["state"] == "postgame" )
		return;
	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;
	
	friendly = false;

	// check for completely getting out of the damage
	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
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
	params = SpawnStruct();
	params.eInflictor = eInflictor;
	params.eAttacker = eAttacker;
	params.iDamage = iDamage;
	params.sMeansOfDeath = sMeansOfDeath;
	params.weapon = weapon;
	params.vDir = vDir;
	params.sHitLoc = sHitLoc;
	params.psOffsetTime = psOffsetTime;
	
	if ( game["state"] == "postgame" )
		return;
	
	if( IsAI(eAttacker) && isdefined( eAttacker.script_owner ) )
	{
		// if the person who called the dogs in switched teams make sure they don't
		// get penalized for the kill
		if ( eAttacker.script_owner.team != self.team )
			eAttacker = eAttacker.script_owner;
	}
		
	if ( isdefined( eAttacker ) && isdefined( eAttacker.onKill ) )
	{
		eAttacker [[eAttacker.onKill]]( self );
	}
	
	if ( isdefined(eInflictor) )
	{
		self.damageInflictor = eInflictor;
	}
	
	self callback::callback( #"on_vehicle_killed", params );
	
	// do vehicle killed callback
	// generally this should be used as system callback, and the callback "on_vehicle_killed" callback can be used by level script
	if ( isdefined( self.overrideVehicleKilled ) )
	{
		self [[self.overrideVehicleKilled]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
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
