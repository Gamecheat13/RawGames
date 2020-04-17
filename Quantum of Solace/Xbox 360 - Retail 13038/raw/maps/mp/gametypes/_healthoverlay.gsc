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
		//self thread maps\_gameskill::playerHealthRegen();
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
	self notify("blurview_stop");
}

blurView( blur, timer )
{
	self notify( "blurview_stop" );
	self endon( "blurview_stop" );
	setblur( self, blur, timer );			//ramp up blur
	wait( timer );
	setblur( self, 0, timer );			//ramp down blur
}


playerHealthRegen()
{
	self endon("end_healthregen");

	wait (0.05);	// ensure that changes to playertype have had time to take effect

	oldhealth = self.maxhealth;
	player = self;
	health_add = 0;
	
	regenRate = 0.1; // 0.017;
	veryHurt = false;
	
	thread playerBreathingSound(0.35);

	if ( !(level.playerHealth_RegularRegenDelay) )
		return;
		
	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;
	
	for (;;)
	{
		wait (0.05);
		if (player.health == player.maxhealth)
		{
			veryHurt = false;
			continue;
		}

		if (player.health <= 0)
			return;

		wasVeryHurt = veryHurt;
		ratio = player.health / player.maxhealth;
		if (ratio <= level.healthOverlayCutoff)
		{
			veryHurt = true;
			if (!wasVeryHurt)
			{
				hurtTime = gettime();
				level.hurtTime = hurtTime;
				thread blurView( 4, 3 );
			}
		}

		if (player.health > player.maxhealth)
		{
			// just became a hero; don't play "breathing_better"
			player.maxhealth = player.health;
			oldhealth = player.maxhealth;
			continue;
		}
			
		if (player.health >= oldhealth)
		{
			if (gettime() - hurttime < level.playerHealth_RegularRegenDelay)
				continue;

			if (gettime() - lastSoundTime_Recover > level.playerHealth_RegularRegenDelay)
			{
				lastSoundTime_Recover = gettime();
				self playLocalSound("breathing_better");
			}
	
			if (veryHurt)
			{
				newHealth = ratio;
				if (gettime() > hurtTime + 3000)
					newHealth += regenRate;
			}
			else
				newHealth = 1;
							
			if (newHealth > 1.0)
				newHealth = 1.0;
				
			if (newHealth <= 0)
			{
				// Player is dead
				return;
			}
			
			player setnormalhealth (newHealth);
			oldhealth = player.health;
			continue;
		}

		oldhealth = player.health;
			
		health_add = 0;
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
			
		// Player still has a lot of health so no breathing sound
		if (player.health >= player.maxhealth * healthcap)
			continue;

		player playLocalSound("breathing_hurt");
		wait .784;
		wait (0.1 + randomfloat (0.8));
	}
}
