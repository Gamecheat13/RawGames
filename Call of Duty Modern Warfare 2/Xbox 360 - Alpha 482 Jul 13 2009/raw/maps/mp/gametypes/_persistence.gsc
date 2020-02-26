#include maps\mp\_utility;

init()
{
	level.persistentDataInfo = [];

	maps\mp\gametypes\_class::init();
	maps\mp\gametypes\_rank::init();
	maps\mp\gametypes\_missions::init();
	maps\mp\gametypes\_playercards::init();
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
	return self GetPlayerData( dataName );
}

/*
=============
statSet

Sets the value of the named stat
=============
*/
statSet( dataName, value )
{
	if ( !self rankingEnabled() )
		return;
	
	self SetPlayerData( dataName, value );
}

/*
=============
statAdd

Adds the passed value to the value of the named stat
=============
*/
statAdd( dataName, value )
{	
	if ( !self rankingEnabled() )
		return;
	
	curValue = self GetPlayerData( dataName );
	self SetPlayerData( dataName, value + curValue );
}


statGetChild( parent, child )
{
	return self GetPlayerData( parent, child );
}


statSetChild( parent, child, value )
{
	if ( !self rankingEnabled() )
		return;
	
	self SetPlayerData( parent, child, value );
}


statAddChild( parent, child, value )
{
	if ( !self rankingEnabled() )
		return;
	
	curValue = self GetPlayerData( parent, child );
	self SetPlayerData( parent, child, curValue + value );
}