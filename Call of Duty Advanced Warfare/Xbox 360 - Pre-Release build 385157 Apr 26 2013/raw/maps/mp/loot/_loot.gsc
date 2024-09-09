#include maps\mp\_utility;

GenerateLoot()
{
	NAME_COLUMN		= 0;
	TYPE_COLUMN		= 1;
	IDX_COLUMN		= 2;
	RARITY_COLUMN	= 3;
	BONUS_STAT_COLUMN_1	= 4;
	BONUS_STAT_COLUMN_2	= 5;
	BONUS_STAT_COLUMN_3	= 6;
	
	num_loot_items = GetLootCount();
	Print( "we have " + num_loot_items + " loot items\n" );
	
	foreach ( player in level.players )
	{
		if( !player rankingEnabled() )
			continue;
		
		if( isBot( player ) )
			continue;
		
		keys = GetArrayKeys( player.stats );
	
		loot_idx = RandomInt( num_loot_items );
		loot_name = GetLootEntryColumn( loot_idx, NAME_COLUMN );
		Print( player.name + " is rolling for loot item " + loot_name + " " + loot_idx + "\n" );
		rarity = GetLootEntryColumn( loot_idx, RARITY_COLUMN );
		rarity = int(rarity) + 2;
		bonus = [];
		bonus[bonus.size] = GetLootEntryColumn( loot_idx, BONUS_STAT_COLUMN_1 );
		bonus[bonus.size] = GetLootEntryColumn( loot_idx, BONUS_STAT_COLUMN_2 );
		bonus[bonus.size] = GetLootEntryColumn( loot_idx, BONUS_STAT_COLUMN_3 );
		
		Print( "chance for getting is 1 / " + ( rarity ) + "\n" );
		max_roll = 100 - 1;
		
		num_rolls = 1;
		foreach( b in bonus )
		{
			if( b == "" )
				continue;
			
			if( !isdefined( player.stats[ "stats_" + b ] ) || !isdefined( player.stats[ "stats_" + b ].value ))
				continue;
			
			num_rolls += player.stats[ "stats_" + b ].value;
			if( player.stats[ "stats_" + b ].value > 0 )
				print( player.stats[ "stats_" + b ].value + " bonus rolls for stats_" + b );
		}
		
		while( num_rolls > 0 )
		{
			roll = RandomInt( max_roll );
			Print( "roll is " + roll + " vs " + (max_roll - ( max_roll / rarity )) + "\n" );
			
			if ( roll > max_roll - ( max_roll / rarity ) )
			{
				Print("success\n");
				GrantLoot( player, loot_idx );
				break;
			}
			else
				Print("fail\n");
			num_rolls--;
		}
	}
	//loot factors
	//loot manifest
	//game mode
	//team win / lose
	//match strength?
	//player stats
	//scoreboard position
	
}


GetLootEntryColumn( index, column )
{
	return TableLookupByRow( "mp/loot.csv", index, column );
}

GetLootCount()
{
	line_num = -1;	
	lootName = "temp";
	while( lootName != "" )
	{
		line_num++;
		lootName = GetLootEntryColumn( line_num, 0 );
	}
	
	return line_num;
}


//all loot is known ahead of time (tool time)

//loot manifest layout csv (duh)
/*
 * 0	type 			- 	[ weapon / equipment / cammo pattern / title / emblem part / gear(hats) ]
 * 1	idx				-	index into data table (points to the override which knows what its base is
 * 2	rarity			- 	[ 0 - 10 ] success is ( 1 / R ) kinda. so 1/2 1/3 1/4 1/5 1/6 1/7 1/8 1/9 1/10 1/100			1 / ( 10 ^ ( rarity + 1 ) ?
 * 3	bonus stat str 	-	[ string index into the player.stats structure ]
 * 4	bonus stat str 	-	[ string index into the player.stats structure ]
 * 5	bonus stat str 	-	[ string index into the player.stats structure ]
 */
 
 //note on rarity we need to know expected player counts and games per hour