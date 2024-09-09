#include maps\mp\_utility;

main()
{
	PreCacheShellShock("flashbang_mp");
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


monitorFlash()
{
	self endon("disconnect");
	
	self notify("monitorFlash");
	self endon("monitorFlash");
	
	self.flashEndTime = 0;
	
	durationMultiplier = 2.5; // how long the flash lasts

	while(1)
	{
		self waittill( "flashbang", origin, percent_distance, percent_angle, attacker, teamName, extraDuration );
		
		if ( !IsAlive( self ) )
			break;

		if ( IsDefined( self.usingRemote ) )
			continue;

		if( !IsDefined( extraDuration ) )
			extraDuration = 0;

		hurtattacker = false;
		hurtvictim = true;

		// with this being the 9-bang we shouldn't consider angle as a variable because of the multiple blasts
		if ( percent_angle < 0.25 )
			percent_angle = 0.25;
		else if ( percent_angle > 0.8 )
			percent_angle = 1;

		duration = percent_distance * percent_angle * durationMultiplier;
		duration += extraDuration;

		// MW3 stun resistance perk
		if ( IsDefined( self.stunScaler ) )
			duration = duration * self.stunScaler;

		if ( duration < 0.25 )
			continue;

		rumbleduration = undefined;
		if ( duration > 2 )
			rumbleduration = 0.75;
		else
			rumbleduration = 0.25;

		assert(IsDefined(self.pers["team"]));
		if (level.teamBased && IsDefined(attacker) && IsDefined(attacker.pers["team"]) && attacker.pers["team"] == self.pers["team"] && attacker != self)
		{
			if(level.friendlyfire == 0) // no FF
			{
				continue;
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
		else if( IsDefined(attacker) )
		{
			attacker notify( "flash_hit" );
			if( attacker != self )
				attacker maps\mp\gametypes\_missions::processChallenge( "ch_indecentexposure" );
		}

		if ( hurtvictim && IsDefined(self) )
		{
			self thread applyFlash(duration, rumbleduration);

			if ( IsDefined(attacker) && attacker != self )
			{
				attacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "flash" );

				// need this here because there are instances where you can not take damage from a flashbang but still get flashed
				//	since you don't take damage the recon perk won't paint you when it should
				// show the victim on the minimap for N seconds
				victim = self;
				if( IsPlayer( attacker ) && attacker IsItemUnlocked( "specialty_paint" ) && attacker _hasPerk( "specialty_paint" ) )
				{
					if( !victim maps\mp\perks\_perkfunctions::isPainted() )
						attacker maps\mp\gametypes\_missions::processChallenge( "ch_paint_pro" );		

					victim thread maps\mp\perks\_perkfunctions::setPainted();
				}
			}
		}
		if ( hurtattacker && IsDefined(attacker) )
		{
			attacker thread applyFlash(duration, rumbleduration);
		}
	}
}

applyFlash(duration, rumbleduration)
{
	// wait for the highest flash duration this frame,
	// and apply it in the following frame
	
	if (!IsDefined(self.flashDuration) || duration > self.flashDuration)
		self.flashDuration = duration;
	if (!IsDefined(self.flashRumbleDuration) || rumbleduration > self.flashRumbleDuration)
		self.flashRumbleDuration = rumbleduration;
	
	wait .05;
	
	if (IsDefined(self.flashDuration)) {
		self shellshock( "flashbang_mp", self.flashDuration ); // TODO: avoid shellshock overlap
		self.flashEndTime = getTime() + (self.flashDuration * 1000);
	}
	if (IsDefined(self.flashRumbleDuration)) {
		self thread flashRumbleLoop( self.flashRumbleDuration ); //TODO: Non-hacky rumble.
	}
	
	self.flashDuration = undefined;
	self.flashRumbleDuration = undefined;
}


isFlashbanged()
{
	return IsDefined( self.flashEndTime ) && gettime() < self.flashEndTime;
}
