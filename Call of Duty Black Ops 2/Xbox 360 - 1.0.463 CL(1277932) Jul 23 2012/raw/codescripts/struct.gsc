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
// Search in each of the arrays for our desired struct
//	It is done this way because we have deleted the level.struct array
//	We are sacrificing performance in Radiant LiveUpdate in exchange
//	for freeing up variables in the game
FindStruct( position )
{
	foreach ( key, _ in level.struct_class_names )
	{
		foreach ( val, s_array in level.struct_class_names[ key ] )
		{
			foreach ( struct in s_array )	
			{
				if( DistanceSquared( struct.origin, position ) < 1 )
				{
					return struct;
				}
			}
		}
	}
}