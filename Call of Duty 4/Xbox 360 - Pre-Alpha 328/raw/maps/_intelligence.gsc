#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

//need to be able to save select dvar in menu (spending points while in the menu)
//need to be able to save select dvar from script (dvars track which items are found)


main()
{
	//assert_if_identical_origins();
	
	
	level.intel_items = create_array_of_intel_items();
	println ("intelligence.gsc:             intelligence items:", level.intel_items.size);
	
	level.table_origins = create_array_of_origins_from_table();
	
	initialize_intel();
	
	level.not_recently_loaded = true;
	thread player_death_monitor();
}

player_death_monitor()
{
	while ( 1 )
	{
		if ( ( issaverecentlyloaded() ) && ( level.not_recently_loaded ) )
		{
			level.not_recently_loaded = false;
			remove_found_intel();
		}
		wait .1;
	}
}

remove_found_intel()
{
	for (i=0;i<level.intel_items.size;i++)
	{
		if ( level.intel_items[i] check_item_found() )
		{
			trigger = level.intel_items[ i ];
			trigger.item hide();
			trigger trigger_off();
		}
	}
}

initialize_intel()
{
	for (i=0;i<level.intel_items.size;i++)
	{
		trigger = level.intel_items[ i ];
		origin = trigger.origin;
		level.intel_items[i].num = get_nums_from_origins( origin ); 
		level.intel_items[i].dvarstring = get_dvar_string( level.intel_items[i].num ); 
		level.intel_items[i].bitOffset = get_bit_offset( level.intel_items[i].num ); 
		
		
		if ( level.intel_items[i] check_item_found() )
		{
			trigger.item hide();
			trigger trigger_off();
			level.intel_items[i].found = true;
		}
		else
		{
			level.intel_items[i] thread wait_for_pickup();
		}
	}
}

get_dvar_string ( num )
{
	// dvarString needs to be looked up from the stats table
	//intel_table_lookup( get_col, with_col, with_data )
	dvarString = intel_table_lookup( 1, 0, num );
	
	return dvarString;
}

get_bit_offset ( num )
{
	// bitOffset needs to be looked up from the stats table
	//intel_table_lookup( get_col, with_col, with_data )
	bitOffset = int ( intel_table_lookup( 2, 0, num ) );
	
	return bitOffset;
}

check_item_found()
{
	curValue = getDvarInt( self.dvarString );
	
	//println ( "dvarString " + dvarString );
	//println ( "curValue " + curValue );
	//println ( "bitOffset " + bitOffset );
	
	//(x & y) returns y if y is in x
	return ( (curValue & self.bitOffset) == self.bitOffset );
}

create_array_of_intel_items()
{
	intelligence_items = getentarray ("intelligence_item", "targetname");
	for (i=0;i<intelligence_items.size;i++)
	{
		println ( intelligence_items[ i ].origin );
		intelligence_items[i].item = getent(intelligence_items[i].target, "targetname");
		intelligence_items[i].found = false;
	}
	return intelligence_items;
}

create_array_of_origins_from_table()
{
	//tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	origins = [];
	for (num=1;num<65;num++)
	{
		location = tablelookup( "maps/_intel_items.csv", 0, num, 4 );
		if ( isdefined ( location ) && ( location != "undefined" ) )
		{
			locArray = strTok( location, "," );
			assert( locArray.size == 3 );
			for (i=0;i<locArray.size;i++)
				locArray[i] = int ( locArray[i] );
			origins [ num ] = (locArray[0], locArray[1], locArray[2]);
		}
		else 
			origins [ num ] = undefined;
	}
	return origins;
}

wait_for_pickup()
{
	self setHintString (&"SCRIPT_INTELLIGENCE_PICKUP");
	self usetriggerrequirelookat();
	
	self waittill("trigger");
	
	
	self.found = true;
	self trigger_off();
	save_that_item_is_found();
	give_points();
	self intel_feedback();
}

save_that_item_is_found()
{
	// dvarString needs to be looked up from the stats table
	//intel_table_lookup( get_col, with_col, with_data )
	dvarString = intel_table_lookup( 1, 0, self.num );
	
	curValue = getDvarInt( dvarString );
	
	// bitOffset needs to be looked up from the stats table
	bitOffset = int ( intel_table_lookup( 2, 0, self.num ) );
	
	// make sure we haven't already found this item
	assert( (curValue & bitOffset) != bitOffset );

	curValue = (curValue | bitOffset);	//add the bit to the dvar
	
	setDvar( dvarString, curValue );  //make setSavedDvar
	
	
	//(x & y) returns y if y is in x
	return ( (curValue & bitOffset) == bitOffset );
}


give_points()
{
	curValue = getDvarInt( "scr_intel_points" );
	
	curValue += 1;
	
	setDvar( "scr_intel_points", curValue ); //make setSavedDvar
}



get_nums_from_origins( origin )
{
	for (i=1;i<level.table_origins.size+1;i++)
	{
		if ( !isdefined ( level.table_origins [ i ] ) )
			continue;
		if ( distancesquared( origin, level.table_origins[ i ] ) < 25 )
			return i;
	}
	assertmsg( "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file" );
		
	//tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	/*
	return_value = tablelookup( "maps/_intel_items.csv", 4, origin, 0 );//column 0 is the number and column 3 is the origin
	assertex( isdefined( return_value ), "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file");
	if (return_value == "" )
		assertmsg( "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file" );
	if (return_value == "undefined" )
		assertmsg( "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file" );
	return return_value;
	*/
}



intel_table_lookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;	
}






intel_feedback()
{
	self.item hide();
	level thread maps\_utility::play_sound_in_space("intelligence_pickup",self.item.origin);
	
	fade_in_time = .25;
	wait_time = 3.75;
	fade_out_time = 1;

	//pnts_print = createFontString( "default", 1.5 );
	//pnts_print setup_hud_elem();
	//pnts_print.y = -75;

	//pnts_print.label = &"SCRIPT_INTELLIGENCE_PTS";
	//pnts_print setValue ( 20 );
	
	remaining_print = createFontString( "default", 1.5 );
	remaining_print setup_hud_elem();
	remaining_print.y = -60;

	remaining_print.label = &"SCRIPT_INTELLIGENCE_OF_THIRTY";
	
	//if ( level.intelligence_items_remaining == 1)
	//	remaining_print.label = &"SCRIPT_INTELLIGENCE_ONEREMAINING";
	//else
	//	remaining_print.label = &"SCRIPT_INTELLIGENCE_REMAINING";
	
	intel_found = getDvarInt( "scr_intel_points" );
	remaining_print setValue ( intel_found );

	//pnts_print FadeOverTime( fade_in_time );
	//pnts_print.alpha = .95;
	
	remaining_print FadeOverTime( fade_in_time );
	remaining_print.alpha = .95;
	wait fade_in_time;
	
	wait wait_time;
	
	//pnts_print FadeOverTime( fade_out_time );
	//pnts_print.alpha = 0;
	remaining_print FadeOverTime( fade_out_time );
	remaining_print.alpha = 0;
	wait fade_out_time;
	
	//pnts_print Destroy();
	remaining_print Destroy();
}

setup_hud_elem()
{	
	self.color = ( 1, 1, 1 );
	self.alpha = 0;
	self.x = 0;
	self.alignx = "center";
	self.aligny = "middle";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	self.foreground = true;
}


/*
main()
{
	intelligence_items = getentarray ("intelligence_item", "targetname");
	level.intelligence_items_found = 0;
	level.intelligence_items_total = intelligence_items.size;
	println ("intelligence.gsc:             intelligence items:", level.intelligence_items_total);

	for (i=0;i<intelligence_items.size;i++)
	{
		intelligence_items[i].item = getent(intelligence_items[i].target, "targetname");
		intelligence_items[i].used = 0;
		intelligence_items[i] thread intel_think();
	}
}


intel_think ()
{
	self setHintString (&"SCRIPT_INTELLIGENCE_PICKUP");
	self usetriggerrequirelookat();
	
	self waittill("trigger");
	
	level.intelligence_items_found++;
	level.intelligence_items_remaining = ( level.intelligence_items_total - level.intelligence_items_found );
	
	//level.player thread updatePlayerScore ( 10 );
	
	thread intel_feedback();
	
	self.used = 1;
	self.item hide();
	self trigger_off();
}
*/

assert_if_identical_origins()
{
	//tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	origins = [];
	for (i=1;i<65;i++)
	{
		location = tablelookup( "maps/_intel_items.csv", 0, i, 4 );
		locArray = strTok( location, "," );
		//assert( locArray.size == 3 );
		for (i=0;i<locArray.size;i++)
			locArray[i] = int ( locArray[i] );
		origins [ i ] = (locArray[0], locArray[1], locArray[2]);
		
		
		//if ( distancesquared( first.origin, second.origin ) < 4 );
	}
	
	for (i=0;i<origins.size;i++)
	{
		if ( ! isdefined ( origins [ i ] ) )
			continue;
		if ( origins [ i ] == "undefined" )
			continue;
		for (j=0;j<origins.size;j++)
		{
			if ( ! isdefined ( origins [ j ] ) )
				continue;
			if ( origins [ j ] == "undefined" )
				continue;
			if ( i == j )
				continue;
			if ( origins [ i ] == origins[ j ] )
				assertmsg( "intel items in maps/_intel_items.csv with identical origins (" + origins[ i ] + ") " );
		}
	}
}