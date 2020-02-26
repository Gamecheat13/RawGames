#include clientscripts\mp\_utility;

#insert raw\maps\mp\_clientflags.gsh;

init()
{	
	level._client_flag_callbacks["scriptmover"][CLIENT_FLAG_COUNTERUAV] = ::spawned;
}

spawned( localClientNum, set )
{
	if ( !IsDefined( level.counteruavs ) )
	{
		level.counteruavs = [];
	}

	if ( !IsDefined( level.counteruavs[localClientNum] ) )
	{
		level.counteruavs[localClientNum] = 0;
	}
		
	player = GetLocalPlayer( localClientNum );
	assert( IsDefined( player ) );

	if ( set )
	{
		level.counteruavs[localClientNum]++;
		self thread counteruav_think( localClientNum );
		player SetEnemyGlobalScrambler( true );
	}
	else
	{
		self notify( "counteruav_off" );
	}
}

counteruav_think( localClientNum )
{
	self waittill_any( "entityshutdown", "counteruav_off" );

	level.counteruavs[localClientNum]--;

	if ( level.counteruavs[localClientNum] < 0 )
	{
		// reference counting gone bad
		level.counteruavs[localClientNum] = 0;
	}

	player = GetLocalPlayer( localClientNum );
	assert( IsDefined( player ) );

	if ( level.counteruavs[localClientNum] == 0 )
	{
		player SetEnemyGlobalScrambler( 0 );
	}
}