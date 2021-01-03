#using scripts\codescripts\struct;
#using scripts\shared\challenges_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\ammo_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\ai\systems\shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_weapons;

#using scripts\cp\killstreaks\_killstreak_weapons;
#using scripts\cp\killstreaks\_killstreaks;

#using scripts\shared\_burnplayer;
#using scripts\cp\_challenges;
#using scripts\cp\_friendlyfire;
#using scripts\cp\_scoreevents;

#namespace globallogic_actor;

function Callback_ActorSpawned( spawner )
{
	self thread spawner::spawn_think( spawner );
	
	self globallogic_player::resetAttackerList();
}

function Callback_ActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, surfaceNormal )
{
	self endon("death");
		
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();

	eAttacker = globallogic_player::figureOutAttacker( eAttacker );
	
	if ( ((self.health == self.maxhealth)) || !isdefined( self.attackers ) )
	{
		self.attackers = [];
		self.attackerData = [];
		self.attackerDamage = [];
	}
	
	//in friendly fire mode, we can control the amount of damage applied to a friendly actor
	if( IsDefined( level.friendlyFireDisabled ) && !level.friendlyFireDisabled )
	{
		if( IsDefined( level.friendlyfireDamagePercentage ) )
		{
			if ( IsPlayer( eAttacker ) && self.team == eAttacker.team )
			{
				iDamage = int( iDamage * level.friendlyfireDamagePercentage );
				if( iDamage < 1 )
				{
					iDamage = 1;
				}
			}
		}	
	}
	
	if ( isdefined( self.overrideActorDamage ) )
	{
		iDamage = self [[self.overrideActorDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex );
	}
	else if ( isdefined( level.overrideActorDamage ) )
	{
		iDamage = self [[level.overrideActorDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex );
	}
	
	// This is the AI system's override damage callback, it must come last!
	if ( IsDefined( self.aiOverrideDamage ) )
	{
		for ( index = 0; index < self.aiOverrideDamage.size; index++ )
		{
			damageCallback = self.aiOverrideDamage[index];
			iDamage = self [[damageCallback]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex );
		}
	}
	
	assert(isdefined(iDamage), "You must return a value from a damage override function.");

	// Don't do knockback if the damage direction was not specified
	if ( !isdefined( vDir ) )
	{
		iDFlags |= 4;
	}
	
	if ( isdefined(eAttacker) )
	{
		if (  IsPlayer(eAttacker))
		{
			//-- handle friendlyfire functionality
			level thread friendlyfire::friendly_fire_callback( self, iDamage, eAttacker, sMeansOfDeath );
			
			//-- special function for Actor
			if(isdefined(self.playerCausedActorDamage))
			{
				self thread [[self.playerCausedActorDamage]]();
			}
			
			if(isDefined(eAttacker.informMeOnDamageCausedToOtherCB))
			{
				assert (isArray(eAttacker.informMeOnDamageCausedToOtherCB),"This cb should be an array");
				foreach(cb in eAttacker.informMeOnDamageCausedToOtherCB)
				{
					eAttacker thread [[cb]](self,iDamage,iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex );
				}
			}
			
			//eAttacker player_power_gadget::power_gain_event_damage_actor( self );
		}
		else if ( IsAI(eAttacker) )
		{
			// AI do not do melee damage to teammates
			if( self.team == eAttacker.team && sMeansOfDeath == "MOD_MELEE" )
			{
				return;
			}
		}
	}

	self callback::callback(#"on_ai_damage");
	self callback::callback(#"on_actor_damage");

	//-- handle functionality if this damage will kill the actor
	if( self.health > 0 && (self.health - iDamage) <= 0 )
	{
		if ( isdefined( eAttacker ) && IsPlayer( eAttacker.driver ) )
		{
			eAttacker = eAttacker.driver;
		}
		
		if ( IsPlayer( eAttacker ) )
		{
			//eAttacker player_power_gadget::power_gain_event_killed_actor( self, sMeansOfDeath );

			/#println( "player killed enemy with " + weapon.name + " via "+sMeansOfDeath );#/
			if ( self.team != eAttacker.team )
			{			
				//item = self DropScavengerItem( "scavenger_item" );
				//item thread weapons::scavenger_think();
				
				if( sMeansOfDeath == "MOD_MELEE" )
				{
					eAttacker notify( "melee_kill" );					
				}
			}
		}
	}
	
	// check for completely getting out of the damage
	if( !(iDFlags & 2048) )
	{
		if ( level.teamBased && isdefined( eAttacker ) && (eAttacker != self) && self.team == eAttacker.team && !IsPlayer( eAttacker ) ) //only for AI
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
			}
			else if ( level.friendlyfire == 2 ) // attacker takes damage
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
			}
		}

		if ( isdefined(eAttacker) && eAttacker != self )
		{
			if( (!isdefined(eInflictor) || !isai(eInflictor)) )
			{
				if ( iDamage > 0 )
				{
					eAttacker thread damagefeedback::update( sMeansOfDeath, eInflictor, undefined, weapon );
				}
			}
		}		
	}
		
	self globallogic_player::giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );
	
	self FinishActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, surfaceNormal ); 
}


function Callback_ActorKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if ( game["state"] == "postgame" )
		return;

	// Player After Action Report (AAR) kills stat
	if( isdefined( eAttacker ) && isplayer( eAttacker ) )
	{
		eAttacker notify("killed_ai",self,sMeansOfDeath,weapon);
		globallogic_score::incTotalKills( eAttacker.team );
		eAttacker thread globallogic_score::giveKillStats( sMeansOfDeath, weapon, self );
	}
	
	if( isai(eAttacker) && isdefined( eAttacker.script_owner ) )
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

	self callback::callback(#"on_ai_killed");
	self callback::callback(#"on_actor_killed");
	
	// This is the AI system's override killed callback, it must come last!
	if ( IsDefined( self.aiOverrideKilled ) )
	{
		for ( index = 0; index < self.aiOverrideKilled.size; index++ )
		{
			killedCallback = self.aiOverrideKilled[index];
			self [[killedCallback]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
		}
	}

	// Drop ammo pouch.
	if ( IsPlayer( eAttacker ) &&
		( ( ( isdefined( level.overrideAmmoDropAllies ) && level.overrideAmmoDropAllies ) && self.team == "allies" ) ||
		( ( isdefined( level.overrideAmmoDropTeam3 ) && level.overrideAmmoDropTeam3 ) && self.team == "team3" ) ||
		self.team == "axis") )
	{
		self thread ammo::DropAIAmmo();
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
			
			self thread challenges::actorKilled( eInflictor, player, iDamage, sMeansOfDeath, weapon, sHitLoc );
			
			self ActorKilled_AwardAssists( eInflictor, player, weapon, player.team );
			
			//eAttacker thread battlechatter::say_kill_battle_chatter( player, weapon, self );
		}		
	}	
}

function ActorKilled_AwardAssists( eInflictor, eAttacker, weapon, lpattackteam )
{
	pixbeginevent( "ActorKilled assists" );
				
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
