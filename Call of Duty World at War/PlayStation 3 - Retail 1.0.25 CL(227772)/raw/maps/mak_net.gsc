main()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player ); 

		player thread onPlayerDisconnect(); 
		player thread onPlayerSpawned(); 
		player thread onPlayerKilled(); 
	
		// put any calls here that you want to happen when the player connects to the game
		println( "Player connected to game." ); 
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" ); 

	// Delete the intro viewhands
	if( IsDefined( self.viewhands ) )
	{
		self.viewhands Delete();
	}
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println( "Player disconnected from the game." ); 
}

onPlayerSpawned()
{
	self endon( "disconnect" ); 
	
	for( ;; )
	{
		self waittill( "spawned_player" ); 
		self SetThreatBiasGroup( "players" ); 	
			
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println( "Player spawned in to game at " + self.origin ); 

		// Do any init stuff here
		if( IsDefined( level.player_speed ) )
		{
			self maps\mak::set_player_speed( level.player_speed );
		}
		self maps\mak::set_onplayer_attribs();
	}
}

onPlayerKilled()
{
	self endon( "disconnect" ); 
	
	for( ;; )
	{
		self waittill( "killed_player" ); 

		// put any calls here that you want to happen when the player gets killed
		println( "Player killed at " + self.origin ); 
		
	}
}
