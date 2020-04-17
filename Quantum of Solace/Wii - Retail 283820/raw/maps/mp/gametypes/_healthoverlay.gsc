init()
{
	precacheShader("overlay_low_health");

	level.healthOverlayCutoff = 0.35;
	
	regenTime = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "healthregentime" );

	level.playerHealth_RegularRegenDelay = regenTime * 1000;

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
		setblur(self,0,1);		
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	self notify("end_healthregen");
	self notify("blurview_stop");
}

blurView( blur, timer )
{
	self notify( "blurview_stop" );
	self endon( "blurview_stop" );
	setblur( self, blur, timer );			
	wait( timer );
	setblur( self, 0, timer );			
}


playerHealthRegen()
{
	self endon("end_healthregen");

	wait (0.05);	

	oldhealth = self.maxhealth;
	player = self;

	isHurt = false;
	veryHurt = false;
	
	thread playerBreathingSound(0.35);

	if ( !(level.playerHealth_RegularRegenDelay) )
		return;
		
	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;

	for (;;)
	{
		wait (0.1);

		regenTime = player getregentime();
		regenTime *= 1000;
		regenRate = player getregenscale();
		regenRate *= 0.1;
		regenLin = player getregenlin();

		if (player.health == player.maxhealth)
		{
			isHurt = false;
			veryHurt = false;
			continue;
		}

		if (player.health <= 0)
			return;
		
		ratio = player getnormalhealth();
		
		wasHurt = isHurt;
		if ( ratio < 1.0 )
		{
			isHurt = true;
			if (!wasHurt)
			{
				hurtTime = gettime();
				level.hurtTime = hurtTime;
			}
			
			wasVeryHurt = veryHurt;
			if (ratio <= level.healthOverlayCutoff)
			{
				veryHurt = true;
				if (!wasVeryHurt)
				{
					thread blurView( 4, 3 );
				}
			}
		}

		if (player.health > player.maxhealth)
		{
			
			player.maxhealth = player.health;
			oldhealth = player.maxhealth;
			continue;
		}
			
		if (player.health >= oldhealth)
		{
			if ((gettime() - hurttime) < regenTime)
				continue;

			if (gettime() - lastSoundTime_Recover > level.playerHealth_RegularRegenDelay)
			{
				lastSoundTime_Recover = gettime();
				self playLocalSound("breathing_better");
			}
	
			if (isHurt)
			{
				newHealth = ratio;

				nonLinHealth = (1.0 - newHealth);
				nonLinHealth *= regenRate;
				nonLinHealth *= (1.0 - regenLin);

				if ( nonLinHealth >= 0 )
					newHealth += nonLinHealth;
				
				newHealth += regenRate * regenLin;
				
				if ( newHealth - ratio < 0.01 && regenRate != 0 )
					newHealth += 0.01;
			}
			else
				newHealth = 1;
							
			if (newHealth > 1.0)
				newHealth = 1.0;
				
			if (newHealth <= 0)
			{
				
				return;
			}
			
			player setnormalhealth (newHealth);
			oldhealth = player.health;
			continue;
		}

		oldhealth = player.health;
		hurtTime = gettime();
		level.hurtTime = hurtTime;
		thread blurView( 2.5, 0.8 );
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
			
		
		if (player.health >= player.maxhealth * healthcap)
			continue;

		player playLocalSound("breathing_hurt");
		wait .784;
		wait (0.1 + randomfloat (0.8));
	}
}
