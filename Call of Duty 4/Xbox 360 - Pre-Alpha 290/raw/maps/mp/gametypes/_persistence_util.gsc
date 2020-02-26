
// ==========================================
// Script persistent data functions
// These are made for convenience, so persistent data can be tracked by strings.
// They make use of code functions which are prototyped below.

/*
=============
statGet

Returns the value of the named stat, within the named block
=============
*/
statGet( dataBlock, dataName )
{
	if ( !level.xboxlive )
		return 0;
	
	return self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
}

/*
=============
setStat

Sets the value of the named stat, within the named block
=============
*/
statSet( dataBlock, dataName, value )
{
	if ( !level.xboxlive )
		return;
	
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value );	
}

/*
=============
statAdd

Adds the passed value to the value of the named stat, within the named block
=============
*/
statAdd( dataBlock, dataName, value )
{	
	if ( !level.xboxlive )
		return;

	curValue = self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value + curValue );
}
