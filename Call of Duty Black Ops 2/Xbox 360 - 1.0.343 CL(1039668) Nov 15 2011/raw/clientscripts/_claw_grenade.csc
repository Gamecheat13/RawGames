// _explosive_bolt.csc
// Sets up clientside behavior for the explosive bolt

main()
{
	level._effect["claw_red_light"] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_red_os" );
	level._effect["claw_green_light"] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_grn_os" );
}

//PARAMETER CLEANUP
spawned( localClientNum /*, play_sound, bool_monkey_bolt*/ ) // self == the crossbow bolt
{
	player = GetLocalPlayer( localClientNum );
	self.fxTagName = "tag_origin";

	self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 0.4, level._effect["claw_green_light"], level._effect["claw_red_light"] );
}

loop_local_sound( localClientNum, alias, interval, fx, fx2 ) // self == the crossbow bolt
{
	self endon( "entityshutdown" );

	// also playing the blinking light fx with the sound
	fxToPlay = fx;
	
	// keep same as that in bigdog_combat's MagicGrenade
	fuseTime = 4.0;

	while(1)
	{
		self PlaySound( localClientNum, alias );
		PlayFXOnTag( localClientNum, fxToPlay, self, self.fxTagName );

		wait(interval);
		fuseTime -= interval;
		
		interval = (interval / 1.1);

		if (interval < .1)
		{
			interval = .1;
		}
		
		// switch to red light
		if (fuseTime < 1.0 && fxToPlay == fx )
		{
			fxToPlay = fx2;
		}
	}
}
