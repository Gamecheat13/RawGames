InitStructs()
{
	level.struct = [];
}

CreateStruct()
{
	struct = spawnstruct();
	level.struct[level.struct.size] = struct;
	return struct;
}

//please don't ever call this from script - it's only for radiant live
FindStruct( position )
{
	for( i = 0; i < level.struct.size; i++ )
	{
		if( DistanceSquared( level.struct[i].origin, position ) < 1 )
		{
			return level.struct[i];
		}
	}
	return undefined;
}
