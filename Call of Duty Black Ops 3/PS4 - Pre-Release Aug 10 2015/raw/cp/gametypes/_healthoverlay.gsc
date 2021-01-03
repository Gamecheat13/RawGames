#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_globallogic_player;

#precache( "material", "overlay_low_health" );
#precache( "lui_menu_data", "hudItems.regenDelayProgress" );

#namespace healthoverlay;

// number of states in the regen widget.  This is so we send updates to the UI with the right frequency.


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
	self.lastRegenDelayProgress = 1.0;
	self SetControllerUIModelValue( "hudItems.regenDelayProgress", 1.0 );
	self notify("end_healthregen");
}

function update_regen_delay_progress( duration )
{
	remaining = duration;
	self.lastRegenDelayProgress = 0.0;
	self SetControllerUIModelValue( "hudItems.regenDelayProgress", self.lastRegenDelayProgress );
	while ( remaining > 0 )
	{
		wait duration / 5;
		remaining -= duration / 5;
		self.lastRegenDelayProgress = 1 - ( remaining / duration ) + 0.05; // 0.05 epsilon for float precision
		if ( self.lastRegenDelayProgress > 1 )
		{
			self.lastRegenDelayProgress = 1;
		}
		self SetControllerUIModelValue( "hudItems.regenDelayProgress", self.lastRegenDelayProgress );
	}
}

function player_health_regen()
{
	self endon("end_healthregen");
	self endon("removehealthregen");
	
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
	
	//thread player_breathing_sound(maxhealth * 0.35);
	thread sndHealthLow(maxhealth * 0.2);
	
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
		{
			if ( !isdefined(self.waiting_to_revive) || !self.waiting_to_revive )
			{
				self.lastRegenDelayProgress = 0.0;
				self SetControllerUIModelValue( "hudItems.regenDelayProgress", 0.0 );
			}
			continue;
		}
			
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
			if ( level.healthRegenDisabled )
				continue;

			regenTime = level.playerHealth_RegularRegenDelay;
			
			if ( player HasPerk( "specialty_healthregen" ) )
			{
				regenTime = Int( regenTime / GetDvarfloat( "perk_healthRegenMultiplier" ) );
			}
			
			regenDelayProgress = (gettime() - hurtTime) / regenTime;
			if (regenDelayProgress < 1.0)
			{
				// SJC: if I were a good scripter, I would send this to CSC as a 3 bit integer as a player clientfield
				// this check at least prevents sending the regen delay progress every script frame, when we only care about it every time it's a different 20% bracket.
				if ( !isdefined(self.lastRegenDelayProgress) || ( int( self.lastRegenDelayProgress * 5 ) != int( regenDelayProgress * 5 ) ) )
				{
					self.lastRegenDelayProgress = regenDelayProgress;
					player SetControllerUIModelValue( "hudItems.regenDelayProgress", regenDelayProgress );				
				}
				continue;
			}
			
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

				regenDelayProgress = (gettime() - hurtTime) / veryHurtTime;
				if ( regenDelayProgress >= 1.0 )
				{
					newHealth += regenRate;
				}
				else
				{
					if ( !isdefined(self.lastRegenDelayProgress) || ( int( self.lastRegenDelayProgress * 5 ) != int( regenDelayProgress * 5 ) ) )
					{
						self.lastRegenDelayProgress = regenDelayProgress;
						player SetControllerUIModelValue( "hudItems.regenDelayProgress", regenDelayProgress );				
					}
				}
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

			if ( newHealth != oldhealth )
			{
				self.lastRegenDelayProgress = 1.0;
				player SetControllerUIModelValue( "hudItems.regenDelayProgress", 1.0 );
			}
			
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
function sndHealthLow(healthcap)
{
	self endon("end_healthregen");
	self endon("removehealthregen");
	self.sndHealthLow = false;
	while(1)
	{
		if (self.health <= healthcap && (!( isdefined( self laststand::player_is_in_laststand() ) && self laststand::player_is_in_laststand() )))
		{
			self.sndHealthLow = true;
			self clientfield::set_to_player( "sndHealth", 1 );
			while(self.health <= healthcap )
			{
				wait(.1);
			}
		}	

		if( self.sndHealthLow )
		{
			self.sndHealthLow = false;
			if( !( isdefined( self laststand::player_is_in_laststand() ) && self laststand::player_is_in_laststand() ) )
			{
				self clientfield::set_to_player( "sndHealth", 0 );
			}
		}
		
		wait(.1);
	}
}	
