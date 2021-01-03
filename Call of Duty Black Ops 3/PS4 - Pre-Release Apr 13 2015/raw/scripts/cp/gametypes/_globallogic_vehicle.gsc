#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_weapons;

#using scripts\cp\_scoreevents;
#using scripts\cp\_vehicle;

#namespace globallogic_vehicle;

function Callback_VehicleSpawned( spawner )
{
	self.health = self.healthdefault;
		
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
	
	if( isdefined( level.a_vehicle_types ) )//Check for vehicle type spawn functions
	{
		if( isdefined( level.a_vehicle_types[ self.vehicleType ] ) )
		{
			foreach( func in level.a_vehicle_types[ self.vehicleType ] )
			{
				util::single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ]);
			}
		}
	}
	
	if( isdefined( level.a_vehicle_targetnames ) )//Check for targetname spawn functions
	{
		if( isdefined( spawner ) )
		{
			str_targetname = spawner.targetname;	
		}
		else
		{
			str_targetname = self.targetname;	
		}
		
		if ( isdefined( str_targetname ) && isdefined( level.a_vehicle_targetnames[ str_targetname ] ) )
		{
			foreach( func in level.a_vehicle_targetnames[ str_targetname ] )
			{
				util::single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ]);
			}				
		}
	}
	
	if ( IsSentient( self ) )
	{
		self spawner::spawn_think( spawner );
	}
	else
	{
		vehicle::init( self );
	}
}

function disableDamageFx()
{
	self endon( "death" );
	
	wait( 0.05 );
	self clientfield::set_to_player( "toggle_dnidamagefx", 0 );
}

function Callback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	params = SpawnStruct();
	params.eInflictor = eInflictor;
	params.eAttacker = eAttacker;
	params.iDamage = iDamage;
	params.iDFlags = iDFlags;
	params.sMeansOfDeath = sMeansOfDeath;
	params.weapon = weapon;
	params.vPoint = vPoint;
	params.vDir = vDir;
	params.sHitLoc = sHitLoc;
	params.vDamageOrigin = vDamageOrigin;
	params.psOffsetTime = psOffsetTime;
	params.damageFromUnderneath = damageFromUnderneath;
	params.modelIndex = modelIndex;
	params.partName = partName;
	params.vSurfaceNormal = vSurfaceNormal;

	if ( game["state"] == "postgame" )
		return;

	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;

	// already applied in the Callback_VehicleDamage
	if ( !(1 & iDFlags) )
	{
		// create a class specialty checks; CAC:bulletdamage, CAC:armorvest
		iDamage = loadout::cac_modified_vehicle_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor );
	}
	
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();
	
	assert(isdefined(iDamage), "You must return a value from a damage override function.");

	if ( iDamage == 0 )
	{
		return;
	}
	
	// Don't do knockback if the damage direction was not specified
	if ( !isdefined( vDir ) )
	{
		iDFlags |= 4;
	}
	
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

	if ( IsSentient( self ) )
	{
		self callback::callback( #"on_ai_damage", params );
	}
	
	self callback::callback( #"on_vehicle_damage", params );

	// check for completely getting out of the damage
	if( !(iDFlags & 2048) )
	{
		// This handles direct damage only. Splash is done in VehicleRadiusDamage
		if ( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_GRENADE" )
		{
			iDamage *= weapon.vehicleProjectileDamageScalar;
			iDamage = int(iDamage);
		}
		// Except for splash that we want to modify additionally based on "underneath"
		else if ( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
		{
			iDamage *= GetVehicleUnderneathSplashScalar( weapon );
			iDamage = int(iDamage);
		}
	
		iDamage *= level.vehicleDamageScalar;
		
		if( !isdefined( self.maxhealth ) )
		{
			self.maxhealth = self.healthdefault; // healthdefault if from the GDT
		}
		
		if ( isdefined( self.overrideVehicleDamage ) )
		{
			iDamage = self [[self.overrideVehicleDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
		}
		else if ( isdefined( level.overrideVehicleDamage ) )
		{
			iDamage = self [[level.overrideVehicleDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
		}

		
		if ( iDamage == 0 )
		{
			return;
		}

		iDamage = int(iDamage);
		
		if ( self IsVehicleImmuneToDamage( iDFlags, sMeansOfDeath, weapon ) )
		{
			return;
		}

		if ( isdefined( eAttacker ) && isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;
		
		prevHealthRatio = self.health / self.maxhealth;
		
		if ( level.teamBased && isdefined( eAttacker ) && self.team == eAttacker.team && !IsPlayer( eAttacker ) ) //only for AI
		{
			damageTeamMates = true;
			
			if ( level.friendlyfire == 0 ) // no one takes damage
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
			}
			else if ( level.friendlyfire == 1 ) // the friendly takes damage
			{
				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				damageTeamMates = false;
				
			}
			else if ( level.friendlyfire == 2 ) // attacker takes damage
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;				
			}
			else if ( level.friendlyfire == 3 ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				damageTeamMates = false;			
			}
					
			self globallogic_player::giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );
			
			self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, damageTeamMates );			
		}
		else if( !level.hardcoreMode && isdefined( self.owner ) && isDefined(eAttacker) && isdefined( eAttacker.owner ) && self.owner == eAttacker.owner )//don't allow your killstreaks to kill your other killstreaks
		{
			return;
		}
		else
		{
			if ( !level.teamBased && isdefined( self.targetname ) && self.targetname == "rcbomb" )
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
		
		driver = self GetSeatOccupant( 0 );
		if( IsDefined( driver ) && iDamage > 0 )
		{
			//driver clientfield::set_to_player( "toggle_dnidamagefx", 1 );
			//driver thread disableDamageFx();
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
			if ( level.friendlyfire <= 2 ) // no one takes damage
			{
				if( !AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon ) )
					return;			
			}
			else if ( level.friendlyfire == 3 ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);			
			}
			
			// Make sure at least one point of damage is done
			if ( iDamage < 1 )
				iDamage = 1;
			
			self.lastDamageWasFromEnemy = false;
						
			self finishVehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime);			
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
	
	// Player After Action Report (AAR) kills stat
	if( isdefined( eAttacker ) && isplayer( eAttacker ) )
	{
		globallogic_score::incTotalKills( eAttacker.team );
		eAttacker thread globallogic_score::giveKillStats( sMeansOfDeath, weapon, self );
	}
	
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

	if ( IsSentient( self ) )
	{
		self callback::callback( #"on_ai_killed", params );
	}
	self callback::callback( #"on_vehicle_killed", params );

	// do vehicle killed callback
	// generally this should be used as system callback, and the callback "on_vehicle_killed" callback can be used by level script
	if ( isdefined( self.overrideVehicleKilled ) )
	{
		self [[self.overrideVehicleKilled]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
	}

	player = eAttacker;
	
	if( eAttacker.classname == "script_vehicle" && isdefined( eAttacker.owner ) )
	{
		player = eAttacker.owner;
	}

	if ( isdefined( player ) && isplayer( player ) && !( isdefined( self.disable_score_events ) && self.disable_score_events ) )
	{
		if ( !level.teamBased || (self.team != player.pers["team"]) )
		{
			//Use standard version
			if ( sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_MELEE_ASSASSINATE" )
			{	
				scoreevents::processScoreEvent( "melee_kill" + self.scoretype, player, self, weapon );		
			}
			else			
			{
				scoreevents::processScoreEvent( "kill" + self.scoretype, player, self, weapon );
			}

			self VehicleKilled_AwardAssists( eInflictor, eAttacker, weapon, eAttacker.team );
		}		
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

function VehicleKilled_AwardAssists( eInflictor, eAttacker, weapon, lpattackteam )
{
	pixbeginevent( "VehicleKilled assists" );
				
	if ( isdefined( self.attackers ) )
	{
		for ( j = 0; j < self.attackers.size; j++ )
		{
			player = self.attackers[j];
			
			if ( !isdefined( player ) )
				continue;
			
			if ( player == eAttacker )
				continue;
				
			if ( player.team != lpattackteam )
				continue;
						
			damage_done = self.attackerDamage[player.clientId].damage;
			player thread globallogic_score::processAssist( self, damage_done, self.attackerDamage[player.clientId].weapon, "assist" + self.scoretype );
		}
	}
	
	if ( level.teamBased )
	{
		self globallogic_score::processKillstreakAssists( eAttacker, eInflictor, weapon );
	}
	
	pixendevent(); //"END: PlayerKilled assists" 
}
