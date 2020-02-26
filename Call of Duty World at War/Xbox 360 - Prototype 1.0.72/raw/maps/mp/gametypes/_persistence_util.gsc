
// ==========================================
// Script persistent data functions
// These are made for convenience, so persistent data can be tracked by strings.
// They make use of code functions which are prototyped below.

/*

Proper usage:

createPersistentDataGroup("headshotmissions", 3, 4); // reserves 3 ints and 4 bytes for persistent headshot mission data
createPersistentData("headshotmissions", "numheadshots", "int"); // uses one int out of the headshot mission data

// The order in which persistent data groups are created, and the number of ints and bytes reserved by them, must not be changed
// or else existing persistent data will become misinterpreted.
// The order in which persistent data within a group is reserved must also not be changed.

n = getPersistentData("numheadshots"); // gets int stored in "numheadshots" slot
setPersistentData("numheadshots", 3); // sets int stored in "numheadshots" slot
incrementPersistentData("numheadshots"); // increments int stored in "numheadshots" slot and returns final value

*/

addPersistenDataBlock( blockName, intBlockOffset, intBlockSize, byteBlockOffset, byteBlockSize )
{
	assert( !isDefined( level.persistentDataInfo[blockName] ) );
	assert( intBlockSize ); // required for version
	assert( byteBlockOffset + byteBlockSize < 2000 );
	assert( intBlockOffset + intBlockSize < 1500 );
		
	dataBlock = spawnStruct();
	
	dataBlock.byteOffset = 0 + byteBlockOffset;
	dataBlock.intOffset = 2000 + intBlockOffset;
	dataBlock.byteSize = byteBlockSize;
	dataBlock.intSize = intBlockSize;
	dataBlock.nextInt = dataBlock.intOffset;
	dataBlock.nextByte = dataBlock.byteOffset;
	dataBlock.dataOffsets = [];
	dataBlock.dataKeys = [];
	
	dataBlock _addPersistentInt( "version" );
	level.persistentDataInfo[blockName] = dataBlock;
	
	return level.persistentDataInfo[blockName];
}


generateCheckSum()
{
	// generates an Adler-32 checksum
	// http://en.wikipedia.org/wiki/Adler-32
	
	chars = "1234567890-_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	charVals = [];
	for ( index = 0; index < chars.size; index++ )
		charVals[chars[index]] = index+26;

	aVal = 1;
	bVal = 0;
	for ( index = 0; index < self.dataKeys.size; index++ )
	{
		dataName = self.dataKeys[index];
		
		for ( charIndex = 0; charIndex < dataName.size; charIndex++ )
		{
			aVal += charVals[dataName[charIndex]];
			if ( aVal > 65521 )	
				aVal -= 65521;
			
			bVal += aVal;
			if ( bVal > 65521 )
				bVal -= 65521;
		}
	}
	
	// note: using signed integers, so left shifting can change the sign of the result
	return ( (bVal << 16) + aVal);
}


checkBounds( byteBlockOffset, byteBlockSize, intBlockOffset, intBlockSize )
{
	keyArray = getArrayKeys( level.persistentDataInfo );
	
	for ( index = 0; index < keyArray.size; index++ )
	{
		dataBlock = level.persistentDataInfo[keyArray[index]];
		
		if ( byteBlockOffset < (dataBlock.byteOffset + dataBlock.byteSize) )
			return false;
		else if ( (byteBlockOffset + byteBlockSize) >= dataBlock.byteOffset )
			return false;
		else if ( intBlockOffset < (dataBlock.intOffset + dataBlock.intSize) )
			return false;
		else if ( (intBlockOffset + intBlockSize) >= dataBlock.intOffset )
			return false;
	}

	return true;
}


/*
=============
statIndex

Returns the index of the named stat, within the named block
=============
*/
statIndex( dataBlock, dataName )
{
	return level.persistentDataInfo[dataBlock] _getDataOffset( dataName );
}


/*
=============
statGet

Returns the value of the named stat, within the named block
=============
*/
statGet( dataBlock, dataName )
{
	return level.persistentDataInfo[dataBlock] _getDataValue( self, dataName );
}

/*
=============
setStat

Sets the value of the named stat, within the named block
=============
*/
statSet( dataBlock, dataName, value )
{
	level.persistentDataInfo[dataBlock] _setDataValue( self, dataName, value );
}

/*
=============
statAdd

Adds the passed value to the value of the named stat, within the named block
=============
*/
statAdd( dataBlock, dataName, value )
{	
	curValue = level.persistentDataInfo[dataBlock] _getDataValue( self, dataName );
	level.persistentDataInfo[dataBlock] _setDataValue( self, dataName, value + curValue );
}


// should be replaced with a code function, but right now it's dev only
toUpper( string )
{
	newString = "";
	
	for ( index = 0; index < string.size; index++ )
	{
		if ( isDefined( level.toUpper[string[index]] ) )
			newString += level.toUpper[string[index]];
		else
			newString += string[index];
	}

	return newString;
}

dumpStatsForMenu()
{
	println( "--- BEGIN STATS MENU DUMP ---" );
	
	dataBlockKeys = getArrayKeys( level.persistentDataInfo );
	for ( dbkIndex = 0; dbkIndex < dataBlockKeys.size; dbkIndex++ )
	{
		dataBlock = level.persistentDataInfo[dataBlockKeys[dbkIndex]];

		dataKeys = getArrayKeys( dataBlock.dataOffsets );
		for ( dkIndex = 0; dkIndex < dataKeys.size; dkIndex++ )
		{
			keyName = dataKeys[dkIndex];
			println( "#define INDEX_" + toUpper( keyName ) + " " + dataBlock.dataOffsets[keyName] );			
		}		

		println( "" );
		println( "onOpen" );
		println( "{" );
		for ( dkIndex = 0; dkIndex < dataKeys.size; dkIndex++ )
		{
			keyName = dataKeys[dkIndex];
			println( "execNow \"statGetInDvar " + dataBlock.dataOffsets[keyName] + " ui_stat_" + keyName + "\"" );
		}
		println( "}" );
	}

	println( "--- END STATS MENU DUMP ---" );
}


// Reserves an int value in this data block entity
_addPersistentInt( dataName )
{
	assert( !isDefined( self.dataOffsets[dataName] ) );
	assert( self.nextInt < self.intOffset + self.intSize );
	
	self.dataOffsets[dataName] = self.nextInt;
	self.dataKeys[self.dataKeys.size] = dataName;
	self.nextInt++;
}


// Reserves a byte value in this data block entity
_addPersistentByte( dataName )
{
	assert( !isDefined( self.dataOffsets[dataName] ) );
	assert( self.nextByte < self.byteOffset + self.nextByte );

	self.dataOffsets[dataName] = self.nextByte;
	self.dataKeys[self.dataKeys.size] = dataName;
	self.nextByte++;
}


// Returns the offset of the named index from a block entity
_getDataOffset( dataName )
{
	return self.dataOffsets[dataName];
}


// Returns the value of the named index from a block entity
_getDataValue( player, dataName )
{
	if ( level.xboxlive )
		return player getStat( self _getDataOffset( dataName ) );
	else
		return 0;
}

// Sets the value of the named index from a block entity
_setDataValue( player, dataName, value )
{
	// integers are signed, so can be in the range -2^31 to 2^31-1
	// bytes are unsigned, so can be in the range 0 to 2^7-1
	assert( self _isInt( dataName ) || (value >= 0 && value < 256) );
	
	if ( level.xboxlive )
	{
		if ( getdvarint("debugStats") != 0 )
			println( "trying to set stat: " + dataName + " (" + self _getDataOffset( dataName ) + ") = " + value );
		player setStat( self _getDataOffset( dataName ), value );
	}
}

// returns true if the named index on this block entity is an int
_isInt( dataName )
{
	return (self.dataOffsets[dataName] >= 2000);
}

// returns true if the named index on this block entity is an byte
_isByte( dataName )
{
	return (self.dataOffsets[dataName] < 2000);
}
