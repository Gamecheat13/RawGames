// provides methods for setting and using rival players

init()
{
	thread onPlayerConnect();
}


onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player );
		player clearRival();
		player thread onPlayerDisconnect();
	}
}


onPlayerDisconnect()
{
	self waittill( "disconnect" );
	clearRivals( self );
}


setRivalIcon( headicon )
{
	level.rival["headicon"] = headicon;
}


setRival( rival_player )
{
	self.rival = rival_player;
	self updateHud();
}


clearRival()
{
	self.rival = undefined;
	self updateHud();
}


clearRivals( rival )
{
	// clears this rival for all players
	players = getentarray( "player", "classname" );

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] isRival( rival ) )
		{
			players[i] clearRival();
		}
	}
}


isRival( player )
{
	if( IsDefined( self.rival ) && self.rival == player )
	{
		return true;
	}

	return false;
}


updateHud()
{
	if ( IsDefined( self.rival ) )
	{
		self SetClientDvar( "cg_rival", self.rival GetEntityNumber() );
	}
	else
	{
		self SetClientDvar( "cg_rival", "-1" );
	}
}
