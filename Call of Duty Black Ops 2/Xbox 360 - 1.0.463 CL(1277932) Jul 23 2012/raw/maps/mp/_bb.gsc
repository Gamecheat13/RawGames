#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	level thread onPlayerConnect();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		player thread onPlayerSpawned();
		//player thread onPlayerDisconnect();
		player thread onPlayerDeath();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onPlayerSpawned()
{
	self endon("disconnect");

	self._bbData = [];

	for(;;)
	{
		self waittill( "spawned_player" );

		// lives
		self._bbData[ "score" ] = 0;
		self._bbData[ "momentum" ] = 0;
		self._bbData[ "spawntime" ] = GetTime();

		// weapons
		self._bbData[ "shots" ] = 0;
		self._bbData[ "hits" ] = 0;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onPlayerDisconnect()
{
	for(;;)
	{
		self waittill( "disconnect" );
		self commitSpawnData();
		break;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onPlayerDeath()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "death" );
		self commitSpawnData();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
commitSpawnData() // self == player
{
	/#
	assert( isDefined( self._bbData ));
	#/
	if ( !isDefined( self._bbData ))
	{
		return;
	}

	bbprint( "mpplayerlives", "gametime %d spawnid %d lifescore %d lifemomentum %d lifetime %d name %s",
				GetTime(),
				getplayerspawnid( self ),
				self._bbData[ "score" ],
				self._bbData[ "momentum" ],
				(GetTime() - self._bbData[ "spawntime" ] ),
				self.name );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
commitWeaponData( spawnid, currentWeapon, time0 ) // self == player
{
	/#
	assert( isDefined( self._bbData ));
	#/
	if ( !isDefined( self._bbData ))
	{
		return;
	}

	time1 = GetTime();

	bbPrint( "mpweapons", "spawnid %d name %s duration %d shots %d hits %d", 
				spawnid, 
				currentWeapon, 
				time1 - time0, 
				self._bbData["shots"], 
				self._bbData["hits"] );

	self._bbData[ "shots" ] = 0;
	self._bbData[ "hits" ] = 0;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
bbAddToStat( statName, delta )
{
	if ( isDefined( self._bbData ) && isDefined( self._bbData[ statName ]))
	{
		self._bbData[ statName ] += delta;
	}
}