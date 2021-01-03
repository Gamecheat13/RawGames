#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\zm\_bb;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\gametypes\_damagefeedback;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_weapons;

#using scripts\zm\_challenges;

#namespace globallogic_actor;

function Callback_ActorSpawned( spawner )
{
	self thread spawner::run_spawn_functions();
	bb::LogAISpawn(self, spawner);
}

function Callback_ActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal )
{
	if ( game["state"] == "postgame" )
		return;
	
	if ( self.team == "spectator" )
		return;
	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;

	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();

	eAttacker = globallogic_player::figureOutAttacker( eAttacker );
	
	// Don't do knockback if the damage direction was not specified
	if( !isdefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
	
	friendly = false;

	if ( ((self.health == self.maxhealth)) || !isdefined( self.attackers ) )
	{
		self.attackers = [];
		self.attackerData = [];
		self.attackerDamage = [];
	}

	if ( globallogic_utils::isHeadShot( weapon, sHitLoc, sMeansOfDeath, eInflictor ) )
		sMeansOfDeath = "MOD_HEAD_SHOT";
	
	if ( level.onlyHeadShots )
	{
		if ( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" )
			return;
		else if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
			iDamage = 150;
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
		if ( isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;
		
		prevHealthRatio = self.health / self.maxhealth;
		
		if ( level.teamBased && isPlayer( eAttacker ) && (self != eAttacker) && (self.team == eAttacker.pers["team"]) )
		{
			if ( level.friendlyfire == 0 ) // no one takes damage
			{
				return;
			}
			else if ( level.friendlyfire == 1 ) // the friendly takes damage
			{
				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self globallogic_player::giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );

				self finishActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal);
			}
			else if ( level.friendlyfire == 2 ) // no one takes damage
			{
				return;
			}
			else if ( level.friendlyfire == 3 ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self globallogic_player::giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );

				self finishActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal);
			}
			
			friendly = true;
		}
		else
		{
			// no damage from the dogs owner unless in hardcore
			if ( isdefined( eAttacker ) && isdefined( self.script_owner ) && eAttacker == self.script_owner && !level.hardcoreMode )
			{
				return;
			}
			
			// dogs with the same owner can not damage each other
			if ( isdefined( eAttacker ) && isdefined( self.script_owner ) && isdefined( eAttacker.script_owner ) && eAttacker.script_owner == self.script_owner )
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
			
			self.lastDamageWasFromEnemy = (isdefined( eAttacker ) && (eAttacker != self));
			
			self globallogic_player::giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );

			self finishActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal);

		}

		if ( isdefined(eAttacker) && eAttacker != self )
		{
			if ( !isdefined( eInflictor ) || !isai( eInflictor ) )
			{
				if ( iDamage > 0 )
					eAttacker thread damagefeedback::updateDamageFeedback( sMeansOfDeath, eInflictor);
			}
		}
	}

	/#
	// Do debug print if it's enabled
	if(GetDvarint( "g_debugDamage"))
		println("actor:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage  + sHitLoc + ";" + boneIndex + "\n");
	#/
	if(1) // self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfteam = self.team;
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

		logPrint("AD;" + lpselfnum + ";" + lpselfteam + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
	
}


function Callback_ActorKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if ( game["state"] == "postgame" )
		return;	
	
	if( isai(attacker) && isdefined( attacker.script_owner ) )
	{
		// if the person who called the dogs in switched teams make sure they don't
		// get penalized for the kill
		if ( attacker.script_owner.team != self.team )
			attacker = attacker.script_owner;
	}
		
	if( attacker.classname == "script_vehicle" && isdefined( attacker.owner ) )
		attacker = attacker.owner;

	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		if ( !level.teamBased || (self.team != attacker.pers["team"]) )
		{
			level.globalKillstreaksDestroyed++;
			attacker AddWeaponStat( GetWeapon( "dogs" ), "destroyed", 1 );

			attacker challenges::killedDog();
		}		
	}
}

function Callback_ActorCloned( original )
{
	DestructServerUtils::CopyDestructState( original, self );
	GibServerUtils::CopyGibState( original, self );
}
