#include maps\mp\gametypes\_persistence_util;

init()
{
	level.persistentDataInfo = [];

	addPersistenDataBlock( "stats", 300, 100, 300, 100 );
	initStats();
	
	addPersistenDataBlock( "missions", 500, 100, 500, 100 );

	maps\mp\gametypes\_class::init();
	maps\mp\gametypes\_rank::init();
	maps\mp\gametypes\_missions::init();

	level thread onPlayerConnect();
	level thread onPlayerSpawned();
	
	buildToUpperArray(); // remove when code "toupper()" exists
	dumpStatsForMenu();
}


initStats()
{
	dataBlock = level.persistentDataInfo["stats"];
	dataBlock _addPersistentInt( "rankxp" );
	dataBlock _addPersistentInt( "score" );
	dataBlock _addPersistentInt( "kills" );
	dataBlock _addPersistentInt( "kill_streak" );	
	dataBlock _addPersistentInt( "deaths" );
	dataBlock _addPersistentInt( "death_streak" );
	dataBlock _addPersistentInt( "assists" );
	dataBlock _addPersistentInt( "headshots" );
	dataBlock _addPersistentInt( "teamkills" );
	dataBlock _addPersistentInt( "suicides" );
	dataBlock _addPersistentInt( "time_played_allies" );
	dataBlock _addPersistentInt( "time_played_opfor" );
	dataBlock _addPersistentInt( "time_played_other" );
	dataBlock _addPersistentInt( "time_played_total" );
	dataBlock _addPersistentInt( "kdratio" );
	dataBlock _addPersistentInt( "wins" );
	dataBlock _addPersistentInt( "losses" );
	dataBlock _addPersistentInt( "win_streak" );
	dataBlock _addPersistentInt( "cur_win_streak" );	
	dataBlock _addPersistentInt( "wlratio" );
	dataBlock _addPersistentInt( "hits" );
	dataBlock _addPersistentInt( "misses" );
	dataBlock _addPersistentInt( "total_shots" );
	dataBlock _addPersistentInt( "accuracy" );
	dataBlock.checkSum = dataBlock generateCheckSum();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player setClientDvar("ui_xpText", "1");
		player.enableText = true;

		player initScrollingText();
		
		player checkPersistentDataVersion();
		
		player maps\mp\gametypes\_missions::missionHUD();
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


initScrollingText()
{
	self.scrollingTextBuffer = [];
	self.scrollingTextDelay = 0.5;
	self.scrollingTextOn = false;
}

addScrollingTextElement()
{
	elementIndex = self.scrollingTextBuffer.size;
	self.scrollingTextBuffer[elementIndex] = newClientHudElem( self );
	self.scrollingTextBuffer[elementIndex].index = elementIndex;
	self.scrollingTextBuffer[elementIndex].addTime = getTime();
	
	self.scrollingTextBuffer[elementIndex].horzAlign = "center";
	self.scrollingTextBuffer[elementIndex].vertAlign = "middle";
	self.scrollingTextBuffer[elementIndex].alignX = "center";
	self.scrollingTextBuffer[elementIndex].alignY = "middle";
	self.scrollingTextBuffer[elementIndex].x = 0;
	self.scrollingTextBuffer[elementIndex].y = -75;
	self.scrollingTextBuffer[elementIndex].font = "default";
	self.scrollingTextBuffer[elementIndex].fontscale = 2;
	self.scrollingTextBuffer[elementIndex].archived = false;
	self.scrollingTextBuffer[elementIndex].color = (0.33,1,0.33);
	self.scrollingTextBuffer[elementIndex].alpha = 0;
	
	return ( self.scrollingTextBuffer[elementIndex] );
}

removeScrollingTextElement( element, delay )
{
	self endon("disconnect");

	element endon ( "death" );
	
	elementIndex = element.index;
	
	self.scrollingTextBuffer[elementIndex] = self.scrollingTextBuffer[self.scrollingTextBuffer.size-1];
	self.scrollingTextBuffer[elementIndex].index = elementIndex;

	self.scrollingTextBuffer[self.scrollingTextBuffer.size-1] = undefined;

	wait ( delay );	
	element destroy();
}

displayScrollingText()
{
	self endon("disconnect");

	self.scrollingTextOn = true;
	while ( self.scrollingTextBuffer.size )
	{
		displayIndex = 0;
		addTime = self.scrollingTextBuffer[0].addTime;
		for ( index = 0; index < self.scrollingTextBuffer.size; index++ )
		{
			if ( self.scrollingTextBuffer[index].addTime < addTime )
			{
				addTime = self.scrollingTextBuffer[index].addTime;
				displayIndex = index;
			}
		}
		
		self.scrollingTextBuffer[displayIndex].alpha = 1;
		self.scrollingTextBuffer[displayIndex] moveOverTime(2);
		self.scrollingTextBuffer[displayIndex] fadeOverTime(2);
		self.scrollingTextBuffer[displayIndex].alpha = 0;
		self.scrollingTextBuffer[displayIndex].y = self.scrollingTextBuffer[displayIndex].y - 100;
		self thread removeScrollingTextElement( self.scrollingTextBuffer[displayIndex], 3.0 );
		
		wait ( self.scrollingTextDelay );
	}
	self.scrollingTextOn = false;
}

addScrollingText( value, color )
{
	element = addScrollingTextElement();
	element setText( value );
	element.color = color;

	if ( !self.scrollingTextOn )
		thread displayScrollingText();
}

addScrollingNumber( value, label, color )
{
	element = addScrollingTextElement();
	element setValue( value );
	element.color = color;
	if ( isDefined( label ) )
	element.label = label;

	if ( !self.scrollingTextOn )
		thread displayScrollingText();
}


checkPersistentDataVersion()
{
	if ( !level.xboxlive )
		return;
		
	keyArray = getArrayKeys( level.persistentDataInfo );
	for ( index = 0; index < keyArray.size; index++ )
	{
		dataBlock = level.persistentDataInfo[keyArray[index]];
		if ( dataBlock _getDataValue( self, "version" ) != dataBlock.checkSum )
		{
			println( "restting player data" );
			dataKeys = getArrayKeys( dataBlock.dataOffsets );
			for ( keyIndex = 0; keyIndex < dataKeys.size; keyIndex++ )
				dataBlock _setDataValue( self, dataKeys[keyIndex], 0 );
			
			dataBlock _setDataValue( self, "version", dataBlock.checkSum );
		}
	}
}

buildToUpperArray()
{
	level.toUpper = [];
	level.toUpper["a"] = "A";
	level.toUpper["b"] = "B";
	level.toUpper["c"] = "C";
	level.toUpper["d"] = "D";
	level.toUpper["e"] = "E";
	level.toUpper["f"] = "F";
	level.toUpper["g"] = "G";
	level.toUpper["h"] = "H";
	level.toUpper["i"] = "I";
	level.toUpper["j"] = "J";
	level.toUpper["k"] = "K";
	level.toUpper["l"] = "L";
	level.toUpper["m"] = "M";
	level.toUpper["n"] = "N";
	level.toUpper["o"] = "O";
	level.toUpper["p"] = "P";
	level.toUpper["q"] = "Q";
	level.toUpper["r"] = "R";
	level.toUpper["s"] = "S";
	level.toUpper["t"] = "T";
	level.toUpper["u"] = "U";
	level.toUpper["v"] = "V";
	level.toUpper["w"] = "W";
	level.toUpper["x"] = "X";
	level.toUpper["y"] = "Y";
	level.toUpper["z"] = "Z";
}