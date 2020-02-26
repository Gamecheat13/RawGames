// _explosive_bolt.csc
// Sets up clientside behavior for the explosive bolt

main()
{
	level._effect["crossbow_enemy_light"] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_red_os" );
	level._effect["crossbow_friendly_light"] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_grn_os" );
	//SetDvarFloat("snd_crossbow_bolt_timer_interval", 0.4); 
	//SetDvarFloat("snd_crossbow_bolt_timer_divisor", 1.4); 

	PrintLn( "crossbow_enemy_light :" + level._effect["crossbow_enemy_light"] );
	PrintLn( "crossbow_friendly_light :" + level._effect["crossbow_friendly_light"] );
}


spawned( localClientNum, play_sound, bool_monkey_bolt ) // self == the crossbow bolt
{
	PrintLn("explosive bolt spawned");
	player = GetLocalPlayer( localClientNum );
	enemy = false;
	self.fxTagName = "tag_origin";
	
	if( !IsDefined( bool_monkey_bolt ) ) // WWilliams (8/14/10): new condition for the upgraded zombie crossbow. 
	{
		bool_monkey_bolt = false; // WWilliams (8/14/10): set the value to false to keep old scripts from breaking
	}

	if ( self.team != player.team )
	{
		enemy = true;
	}

	if ( enemy && bool_monkey_bolt == false )
	{
		if( play_sound )
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 0.3, level._effect["crossbow_enemy_light"] );
		}
		else
		{
			PlayFXOnTag( localClientNum, level._effect["crossbow_enemy_light"], self, self.fxTagName );
		}
	}
	else if( bool_monkey_bolt == true ) 
	{
		// WWilliams (8/14/10): this should make it so all zombie players see a red light for the upgraded zombie crossbow
		if( play_sound )
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 0.3, level._effect["crossbow_enemy_light"] );
		}
		else
		{
			PlayFXOnTag( localClientNum, level._effect["crossbow_enemy_light"], self, self.fxTagName );
		}
	}
	else
	{
		if( play_sound )
		{
			self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 0.3, level._effect["crossbow_friendly_light"] );
		}
		else
		{
			PlayFXOnTag( localClientNum, level._effect["crossbow_friendly_light"], self, self.fxTagName );
		}
	}
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
