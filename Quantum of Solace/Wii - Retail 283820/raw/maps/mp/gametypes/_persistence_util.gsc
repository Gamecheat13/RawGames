







addPersistenDataBlock( blockName, intBlockOffset, intBlockSize, byteBlockOffset, byteBlockSize )
{
	assert( !isDefined( level.persistentDataInfo[blockName] ) );
	assert( intBlockSize ); 
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
	
	return (bVal * 65536 + aVal);
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



statGet( dataBlock, dataName )
{
	return level.persistentDataInfo[dataBlock] _getDataValue( self, dataName );
}


statSet( dataBlock, dataName, value )
{
	level.persistentDataInfo[dataBlock] _setDataValue( self, dataName, value );
}


statAdd( dataBlock, dataName, value )
{	
	curValue = level.persistentDataInfo[dataBlock] _getDataValue( self, dataName );
	level.persistentDataInfo[dataBlock] _setDataValue( self, dataName, value + curValue );
}



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




_addPersistentInt( dataName )
{
	assert( !isDefined( self.dataOffsets[dataName] ) );
	assert( self.nextInt < self.intOffset + self.intSize );
	
	self.dataOffsets[dataName] = self.nextInt;
	self.dataKeys[self.dataKeys.size] = dataName;
	self.nextInt++;
}


_addPersistentByte( dataName )
{
	assert( !isDefined( self.dataOffsets[dataName] ) );
	assert( self.nextByte < self.byteOffset + self.nextByte );

	self.dataOffsets[dataName] = self.nextByte;
	self.dataKeys[self.dataKeys.size] = dataName;
	self.nextByte++;
}


_getDataOffset( dataName )
{
	return self.dataOffsets[dataName];
}


_getDataValue( player, dataName )
{
	if ( level.xboxlive )
	{
		stat = self _getDataOffset( dataName );
		if ( isDefined( stat ) )
		{
			return player getStat( stat );
		}
		else
		{
			return 0;
		}
	}
	else
	{
		return 0;
	}
}


_setDataValue( player, dataName, value )
{
	if( !isDefined( self ) || !isDefined( self.dataOffsets[dataName] ) )
		return;
	assert( value >= 0 );
	assert( (self _isInt( dataName ) || value <= 255) );
	
	if ( level.xboxlive && game["state"] == "playing" )
		player setStat( self _getDataOffset( dataName ), value );
}


_isInt( dataName )
{
	return (self.dataOffsets[dataName] >= 2000);
}


_isByte( dataName )
{
	return (self.dataOffsets[dataName] < 2000);
}
