init()
{
	precacheShader("overlay_low_health");
	
	level.healthOverlayCutoff = 0.55; // getting the dvar value directly doesn't work right because it's a client dvar GetDvarfloat( "hud_healthoverlay_pulseStart");
	
	regenTime = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "healthregentime" );
	
	level.playerHealth_RegularRegenDelay = regenTime * 1000;
	
	level.healthRegenDisabled = (level.playerHealth_RegularRegenDelay <= 0);
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerDisconnect();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self notify("end_healthregen");
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self notify("end_healthregen");
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread playerHealthRegen();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
		self notify("end_healthregen");
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	self notify("end_healthregen");
}

playerHealthRegen()
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

	if( maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() )
	{
		regenRate = player maps\mp\gametypes\_customClasses::getHealthRegenModifier();
		useTrueRegen = true;
	}
	veryHurt = false;
	
	player.breathingStopTime = -10000;
	
	thread playerBreathingSound(maxhealth * 0.35);
	thread playerHeartbeatSound(maxhealth * 0.35);
	
	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;
	
	for (;;)
	{
		wait (0.05);

		if( isDefined( player.regenRate ) )
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
			else if( maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() )
			{
				regenTime = player maps\mp\gametypes\_customClasses::getHealthRegenTime();
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
				if ( veryHurt )
				{
					self maps\mp\gametypes\_missions::healthRegenerated();
					self maps\mp\_properks::healthRegenerated();
				}

				self maps\mp\gametypes\_globallogic_player::resetAttackerList();
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
				player decayPlayerDamages( change );
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

decayPlayerDamages( decay )
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

playerBreathingSound(healthcap)
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
playerHeartbeatSound(healthcap)
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
