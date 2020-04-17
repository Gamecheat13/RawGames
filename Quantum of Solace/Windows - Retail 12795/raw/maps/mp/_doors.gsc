init()
{
	//TODO: singleplayer supports more flags & key/value pairs that we may want to add
	level.door_trigger_radius = 50;
	level.door_trigger_height = 4 * level.door_trigger_radius;
	
	level.door_flag_manual_close = 2;
	level.door_flag_spawn_open	 = 256;

	//TODO: this currently needs to be added manually by the builder, should probably
	// be automatically added when a door is spawned
	doors = GetEntArray( "door", "targetname" );

	if ( !IsDefined( doors ) )
		return;

	for ( i = 0; i < doors.size; i++ )
	{
		door = doors[i];
		
		if ( !IsDefined( door.script_door_id ) )
			continue;

		door doorInit();

		door thread doorThink();
	}
}


doorInit()
{
	// spawn flags
	if ( !IsDefined( self.spawnflags ) )
		self.spawnflags = 0;

	if ( self.spawnflags & level.door_flag_manual_close )
		self.manual_close = true;
	else
		self.manual_close = false;

	// open trigger
	self.trigger = Spawn ( "trigger_radius", self.origin, 0, level.door_trigger_radius, level.door_trigger_height );
	self.trigger SetHintString( &"SCRIPT_OPEN_DOOR" );
	self.trigger SetCursorHint( "HINT_DOOR" );
	self.trigger SetUseable( true );

	// open or closed state
	if ( self.spawnflags & level.door_flag_spawn_open )
		self doorOpen();
	else
		self.state = "closed";
}


doorThink()
{
	for ( ;; )
	{
		wait( 0.05 );

		if ( self.state == "closed" )
			self doorClosedThink();

		else if ( self.state == "open" )
			self doorOpenThink();

		//drawOrigin( self.origin );
	}
}


doorClosedThink()
{
	players = getPlayers();

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] IsTouching( self.trigger ) && players[i] UseButtonPressed() )
		{
			self doorOpen( players[i] );
			wait( 1.0 );
			break;
		}
	}
}


doorOpenThink()
{
	if ( self.manual_close == true )
		self doorManualCloseThink();
	else 
		self doorAutoCloseThink();
}


doorAutoCloseThink()
{
	players = getPlayers();

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] IsTouching( self.close_trigger ) )
			return;
	}

	self doorClose();
}


doorManualCloseThink()
{
	self.close_trigger SetHintString( &"SCRIPT_CLOSE_DOOR" );
	self.close_trigger SetCursorHint( "HINT_DOOR" );
	self.close_trigger SetUseable( true );

	players = getPlayers();

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] IsTouching( self.close_trigger ) && players[i] UseButtonPressed() )
		{
			self doorClose();
			break;
		}
	}
}


doorOpen( player )
{
	self.state = "open";
	self.trigger SetUseable( false );

	//TODO: may want to resize this trigger for manual vs. auto door closing
	self.close_trigger = Spawn ( "trigger_radius", self.origin, 0, level.door_trigger_radius * 2, level.door_trigger_height );

	if ( IsDefined( player ) )
		dot = VectorDot( AnglesToRight(player.angles), VectorNormalize(self.origin - player.origin) );
	else
		dot = 0;

	//TODO: angle may be derived from key/value pair from map
	rotate = 90;

	if ( dot > 0)
		rotate = -90;

	self.close_rotate = 0 - rotate;

	doorRotate( rotate );
}


doorClose()
{
	//TODO: manually closing the doors may kill players
	self.state = "closed";
	self.trigger SetUseable( true );
	self.close_trigger delete();
	
	doorRotate( self.close_rotate );
}


doorRotate( rotation )
{
	self RotateYaw( rotation, 1.0, 0.0, 1.0 );
	self waittill( "rotatedone" );     
}


// returns players that are playing
getPlayers()
{
	players = [];

	all_players = getentarray( "player", "classname" );

	for ( i = 0; i < all_players.size; i++ )
	{
		player = all_players[i];

		if ( player.sessionstate != "playing" )
			continue;

		players[ players.size ] = player;
	}

	return players;
}


drawOrigin( origin )
{
	red	  = ( 1, 0, 0 );
	green = ( 0, 1, 0 );
	blue  = ( 0, 0, 1 );

	line( origin + (16, 0, 0), origin + (-16, 0, 0), red, 1  );
	line( origin + (0, 16, 0), origin + (0, -16, 0), green, 1 );
	line( origin + (0, 0, 16), origin + (0, 0, -16), blue, 1 );
}
