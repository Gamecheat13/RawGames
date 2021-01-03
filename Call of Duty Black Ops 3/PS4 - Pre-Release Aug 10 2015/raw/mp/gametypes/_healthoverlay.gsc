#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic_player;

#precache( "material", "overlay_low_health" );

#namespace healthoverlay;

function autoexec __init__sytem__() {     system::register("healthoverlay",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	
	callback::on_joined_team( &end_health_regen );
	callback::on_joined_spectate( &end_health_regen );
	callback::on_spawned( &player_health_regen );
	callback::on_disconnect( &end_health_regen );
	callback::on_player_killed( &end_health_regen );
}

function init()
{
	level.healthOverlayCutoff = 0.55; // getting the dvar value directly doesn't work right because it's a client dvar GetDvarfloat( "hud_healthoverlay_pulseStart");
	
	regenTime = level.playerHealthRegenTime;
	
	level.playerHealth_RegularRegenDelay = regenTime * 1000;
	
	level.healthRegenDisabled = (level.playerHealth_RegularRegenDelay <= 0);
}

function end_health_regen()
{
	self notify("end_healthregen");
}

function player_health_regen()
{
	self endon("end_healthregen");
	
	if ( self.health <= 0 )
	{
		assert( !isalive( self ) );
		return;
	}
	
	maxhealth = self.health;
	oldhealth = maxhealth;
	player = self;
	health_add = 0;
	
	regenRate = 0.1; // 0.017;

	useTrueRegen = false;

	veryHurt = false;
	
	player.breathingStopTime = -10000;
	
	thread player_breathing_sound(maxhealth * 0.35);
	thread player_heartbeat_sound(maxhealth * 0.35);
	
	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;
	
	for (;;)
	{
		{wait(.05);};

		if( isdefined( player.regenRate ) )
		{
			regenRate = player.regenRate;
			useTrueRegen = true;
		}

		if (player.health == maxhealth)
		{
			veryHurt = false;
			self.atBrinkOfDeath = false;
			continue;
		}
					
		if (player.health <= 0)
			return;

		if ( isdefined(player.laststand) && player.laststand )
			continue;
			
		wasVeryHurt = veryHurt;
		ratio = player.health / maxHealth;
		if (ratio <= level.healthOverlayCutoff)
		{
			veryHurt = true;
			self.atBrinkOfDeath = true;
			if (!wasVeryHurt)
			{
				hurtTime = gettime();
			}
		}
			
		if (player.health >= oldhealth)
		{
			regenTime = level.playerHealth_RegularRegenDelay;
			
			if ( player HasPerk( "specialty_healthregen" ) )
			{
				regenTime = Int( regenTime / GetDvarfloat( "perk_healthRegenMultiplier" ) );
			}
			
			if (gettime() - hurttime < regenTime)
				continue;
			
			if ( level.healthRegenDisabled )
				continue;

			if (gettime() - lastSoundTime_Recover > regenTime)
			{
				lastSoundTime_Recover = gettime();
//    changing to notify to enable voice specfic hurt sounds.
//				self playLocalSound("chr_breathing_better");
				self notify ("snd_breathing_better");	
			}
	
			if (veryHurt)
			{
				newHealth = ratio;
				veryHurtTime = 3000;

				if ( player HasPerk( "specialty_healthregen" ) )
				{
					veryHurtTime = Int( veryHurtTime / GetDvarfloat( "perk_healthRegenMultiplier" ) );
				}

				if (gettime() > hurtTime + veryHurtTime)
					newHealth += regenRate;
			}
			else
			{
				if( useTrueRegen )
				{
					newHealth = ratio + regenRate;
				}
				else
				{
					newHealth = 1;
				}
			}

			//println("client:  " + self getEntityNumber() + " newHealth:  " + newHealth + " oldHealth:  " + oldhealth + " regen rate:  " + regenRate );

							
			if ( newHealth >= 1.0 )
			{
				//if ( veryHurt )
				//{
				//	self _properks::healthRegenerated();
				//}

				self globallogic_player::resetAttackerList();
				newHealth = 1.0;
			}
				
			if (newHealth <= 0)
			{
				// Player is dead			
				return;
			}
			
			player setnormalhealth (newHealth);
			change = player.health - oldhealth;		
			if ( change > 0 )
			{
				player decay_player_damages( change );
			}
			oldhealth = player.health;
			continue;
		}

		oldhealth = player.health;
			
		health_add = 0;
		hurtTime = gettime();
		player.breathingStopTime = hurtTime + 6000;
	}
}

function decay_player_damages( decay )
{
	if ( !isdefined( self.attackerDamage ) )
		return;
		
	for ( i = 0; i < self.attackerDamage.size; i++ )
	{
		if ( !isdefined( self.attackerDamage[i] ) || !isdefined( self.attackerDamage[i].damage ) )
			continue;
			
		self.attackerDamage[i].damage -= decay;
		if ( self.attackerDamage[i].damage < 0 )
			self.attackerDamage[i].damage = 0; 
	}
}

function player_breathing_sound(healthcap)
{
	self endon("end_healthregen");
	
	wait (2);
	player = self;
	for (;;)
	{
		wait (0.2);
		if (player.health <= 0)			
			return;
		
		// no breathing sounds when using remote
		if ( player util::isUsingRemote() )
			continue;
		
		// Player still has a lot of health so no breathing sound
		if (player.health >= healthcap)
			continue;
		
		if ( level.healthRegenDisabled && gettime() > player.breathingStopTime )
			continue;
			
//    changing to notify to enable voice specfic hurt sounds.
//		player playLocalSound("chr_breathing_hurt");
		player notify ("snd_breathing_hurt");

		wait .784;
		wait (0.1 + randomfloat (0.8));
	}
}
function player_heartbeat_sound(healthcap)
{
	self endon("end_healthregen");
	self.hearbeatwait = .2;	
	wait (2);
	player = self;
	for (;;)
	{
		wait (0.2);
		if (player.health <= 0)			
			return;
		
		// no heartbeat sounds when using remote
		if ( player util::isUsingRemote() )
		{
			continue;
		}
		
		// Player still has a lot of health so no hearbeat sound
		if (player.health >= healthcap)
		{
			self.hearbeatwait = .3;
			continue;
		}	
			
		
		if ( level.healthRegenDisabled && gettime() > player.breathingStopTime )
		{
			self.hearbeatwait = .3;
			continue;
		}
			
		player playLocalSound("mpl_player_heartbeat");

		wait (self.hearbeatwait);
		//println ("snd heart wait =" + self.hearbeatwait);
		
		if (self.hearbeatwait <= .6)
		{
			self.hearbeatwait = (self.hearbeatwait + .1);
			//println ("snd heart new wait =" + self.hearbeatwait);
		}		
	}
}	
