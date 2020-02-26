init()
{
	level.persistentDataInfo = [];

	maps\mp\gametypes\_class::init();
	maps\mp\gametypes\_rank::init();
	maps\mp\gametypes\_missions::init();

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player setClientDvar("ui_xpText", "1");
		player.enableText = true;
	}
}

// ==========================================
// Script persistent data functions
// These are made for convenience, so persistent data can be tracked by strings.
// They make use of code functions which are prototyped below.

/*
=============
statGet

Returns the value of the named stat
=============
*/
statGet( dataName )
{
	if ( !level.onlineGame )
		return 0;
	
	return self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
}

statGetWithGameType( dataName )
{
	return self statGet( getStatNameWithGameType( dataName ) );
}

getStatNameWithGameType( dataName )
{
	if ( isDefined( level.hardcoreMode ) && level.hardcoreMode )
	{
		prefix = "HC";
	}
	else
	{
		prefix = "";
	}
	
	return prefix + level.gametype + "_" + dataname;
	
}

getStatNumberWithGametype( dataName )
{
	return int(tableLookup( "mp/playerStatsTable.csv", 1, getStatNameWithGameType( dataName ), 0 ));
}


statSetWithGameType( dataName, value )
{
	statNumber = getStatNumberWithGametype( dataName );
	if ( statNumber )
	{
		self setStat( statNumber, value );
	}
}
/*
=============
setStat

Sets the value of the named stat
=============
*/
statSet( dataName, value, includeGameType )
{
	if ( !level.rankedMatch )
		return;
	
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value );
	
	if ( !isDefined( includeGameType ) || includeGameType )
	{
		statSetWithGameType( dataName, value );
	}
	
	self setStatLBByname( dataName, value );
}

/*
=============
statAdd

Adds the passed value to the value of the named stat
=============
*/
statAdd( dataName, value )
{	
	if ( !level.rankedMatch )
		return;

	curValue = self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value + curValue );
	self setStatLBByName( dataName, curValue );
	
	statNumber = getStatNumberWithGametype( dataName );
	if ( statNumber )
	{
		curValue = self getStat( statNumber );
		self setStat( statNumber, value + curValue );
	}

}
