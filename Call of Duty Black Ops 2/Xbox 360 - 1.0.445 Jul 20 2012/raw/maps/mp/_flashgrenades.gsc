#include maps\mp\_utility;

main()
{
	precacheShellshock("flashbang");
	level.sound_flash_start = "";
	level.sound_flash_loop = "";
	level.sound_flash_stop = "";
}


startMonitoringFlash()
{
	self thread monitorFlash();
}


stopMonitoringFlash(disconnected)
{
	self notify("stop_monitoring_flash");
}


flashRumbleLoop( duration )
{
	self endon("stop_monitoring_flash");
	
	self endon("flash_rumble_loop");
	self notify("flash_rumble_loop");
	
	goalTime = getTime() + duration * 1000;
	
	while ( getTime() < goalTime )
	{
		self PlayRumbleOnEntity( "damage_heavy" );
		wait( 0.05 );
	}
}


monitorFlash_Internal(amount_distance, amount_angle, attacker, direct_on_player)
{
	hurtattacker = false;
	hurtvictim = true;
	
	if ( amount_angle < 0.5 )
	{
		amount_angle = 0.5;
	}
	else if ( amount_angle > 0.8 )
	{
		amount_angle = 1;
	}

	duration = amount_distance * amount_angle * 6;
	
	if ( duration < 0.25 )
	{
		return;
	}
		
	rumbleduration = undefined;
	
	if ( duration > 2 )
	{
		rumbleduration = 0.75;
	}
	else
	{
		rumbleduration = 0.25;
	}
	
	assert(isdefined(self.team));
	
	if (level.teamBased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
	{
		if(level.friendlyfire == 0) // no FF
		{
			return;
		}
		else if(level.friendlyfire == 1) // FF
		{
		}
		else if(level.friendlyfire == 2) // reflect
		{
			duration = duration * .5;
			rumbleduration = rumbleduration * .5;
			hurtvictim = false;
			hurtattacker = true;
		}
		else if(level.friendlyfire == 3) // share
		{
			duration = duration * .5;
			rumbleduration = rumbleduration * .5;
			hurtattacker = true;
		}
	}
	
	if ( self hasPerk ("specialty_flashprotection") )
	{
		// do a little bit, not a complete negation
		duration *= 0.1;
		rumbleduration *= 0.1;
	}

	if (hurtvictim)
	{
		// No flashbang effect if in vehicle
		if ( self mayApplyScreenEffect() || (!direct_on_player && (self IsRemoteControlling()) ) )
		{
			if( self != attacker )
			{
				attacker AddWeaponStat( "flash_grenade_mp", "hits", 1 );
				attacker AddWeaponStat( "flash_grenade_mp", "used", 1 );
			}
			self thread applyFlash(duration, rumbleduration);
		}
	}
	
	if (hurtattacker)
	{
		// No flashbang effect if in vehicle
		if ( attacker mayApplyScreenEffect() )
			attacker thread applyFlash(duration, rumbleduration);
	}
}

monitorFlash()
{
	self endon("disconnect");
	self.flashEndTime = 0;
	while(1)
	{
		self waittill( "flashbang", amount_distance, amount_angle, attacker );
		
		if ( !isalive( self ) )
		{
			continue;
		}
	
		self monitorFlash_Internal(amount_distance, amount_angle, attacker, true);
	}
}

monitorRCBombFlash()
{
	self endon("death");
	self.flashEndTime = 0;
	while(1)
	{
		self waittill( "flashbang", amount_distance, amount_angle, attacker );
		
		driver = self getseatoccupant(0);
		
		if ( !IsDefined(driver) || !isalive( driver ) )
		{
			continue;
		}

		driver monitorFlash_Internal(amount_distance, amount_angle, attacker, false);
	}
}

applyFlash(duration, rumbleduration)
{
	// wait for the highest flash duration this frame,
	// and apply it in the following frame
	
	if (!isdefined(self.flashDuration) || duration > self.flashDuration)
	{
		self.flashDuration = duration;
	}
	
	if (!isdefined(self.flashRumbleDuration) || rumbleduration > self.flashRumbleDuration)
	{
		self.flashRumbleDuration = rumbleduration;
	}
	
	self thread playFlashSound( duration );
	
	wait .05;
	
	if (isdefined(self.flashDuration)) 
	{
		self shellshock( "flashbang", self.flashDuration, false ); // TODO: avoid shellshock overlap
		self.flashEndTime = getTime() + (self.flashDuration * 1000);
	}
	
	if (isdefined(self.flashRumbleDuration)) {
		self thread flashRumbleLoop( self.flashRumbleDuration ); //TODO: Non-hacky rumble.
	}

	self.flashDuration = undefined;
	self.flashRumbleDuration = undefined;
}

playFlashSound( duration )
{	
	self endon( "death" );
	self endon( "disconnect" );

	flashSound = spawn ("script_origin",(0,0,1));
	flashSound.origin = self.origin;
	flashSound linkTo( self );
	flashSound thread deleteEntOnOwnerDeath( self );
	
	flashSound playsound( level.sound_flash_start );
	flashSound playLoopSound ( level.sound_flash_loop );
	if ( duration > 0.5 )
		wait( duration - 0.5 );
	flashSound playsound( level.sound_flash_start );
	flashSound StopLoopSound( .5);
    wait(0.5);

    flashSound notify ( "delete" );
	flashSound delete();
}

deleteEntOnOwnerDeath( owner )
{
	self endon( "delete" );
	owner waittill( "death" );
	self delete();	
}


isFlashbanged()
{
	return isDefined( self.flashEndTime ) && gettime() < self.flashEndTime;
}
