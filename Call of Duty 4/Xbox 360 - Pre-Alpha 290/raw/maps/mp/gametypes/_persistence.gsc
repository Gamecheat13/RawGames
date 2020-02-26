#include maps\mp\gametypes\_persistence_util;

init()
{
	level.persistentDataInfo = [];

	maps\mp\gametypes\_class::init();
	maps\mp\gametypes\_rank::init();
	maps\mp\gametypes\_missions::init();

	level thread onPlayerConnect();
	level thread onPlayerSpawned();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player setClientDvar("ui_xpText", "1");
		player.enableText = true;

//		player checkPersistentDataVersion();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
	}
}

/*
checkPersistentDataVersion()
{
	if ( !level.xboxlive )
		return;
		
	keyArray = getArrayKeys( level.persistentDataInfo );
	for ( index = 0; index < keyArray.size; index++ )
	{
		dataBlock = level.persistentDataInfo[keyArray[index]];
		if ( dataBlock _getDataValue( self, "version" ) != dataBlock.version )
		{
			println( "restting player data" );
			dataKeys = getArrayKeys( dataBlock.dataOffsets );
			for ( keyIndex = 0; keyIndex < dataKeys.size; keyIndex++ )
				dataBlock _setDataValue( self, dataKeys[keyIndex], 0 );
			
			dataBlock _setDataValue( self, "version", dataBlock.version );
		}
	}
}
*/