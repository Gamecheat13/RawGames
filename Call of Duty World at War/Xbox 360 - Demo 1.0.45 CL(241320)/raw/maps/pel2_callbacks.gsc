onFirstPlayerConnect()
{
	level waittill( "connecting_first_player", player );

	// put any calls here that you want to happen when the FIRST player connects to the game
	println( "First player connected to game." );
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	
		// put any calls here that you want to happen when the player connects to the game
		println( "Player connected to game." );
		
		player SetWeaponAmmoStock( "colt", 80 );
		player setthreatbiasgroup( "players" );
		
		// TODO
		//pel2_util::players_speed_set( level.current_player_speed );
		//player allowsprint( false );
		
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" );
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println( "Player disconnected from the game." );
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "spawned_player" );
		
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println("Player spawned in to game at " + self.origin);
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill( "killed_player" );

		// put any calls here that you want to happen when the player gets killed
		println( "Player killed at " + self.origin );
		
	}
}	