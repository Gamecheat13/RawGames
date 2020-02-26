// _explosive_bolt.csc
// Sets up clientside behavior for the explosive bolt

main()
{
	level._effect["dart_light"] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_red_os" );

	/#
	PrintLn( "dart_light :" + level._effect["dart_light"] );
	#/
}


spawned( localClientNum ) // self == the titus dart
{
	/#PrintLn("titus dart spawned");#/
	player = GetLocalPlayer( localClientNum );
	enemy = false;
	self.fxTagName = "tag_origin";
		
	if ( self.team != player.team )
	{
		enemy = true;
	}

	self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 0.3, level._effect["dart_light"] );
}

loop_local_sound( localClientNum, alias, interval, fx ) // self == the crossbow bolt
{
	self endon( "entityshutdown" );

	// also playing the blinking light fx with the sound

	while(1)
	{
		self PlaySound( localClientNum, alias );
		PlayFXOnTag( localClientNum, fx, self, self.fxTagName );

		wait(interval);
		interval = (interval / 1.2);

		if (interval < .1)
		{
			interval = .1;
		}	
	}
}
