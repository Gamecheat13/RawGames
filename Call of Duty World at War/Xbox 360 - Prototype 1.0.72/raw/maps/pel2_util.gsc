// guzzo's peleliu 2 util file for various purposes

#include maps\_utility;




//////////////
//
// wrapper for using _spawner script spawn
//
////////////////////////
simple_spawn( name )
{
	
	spawners = getEntArray( name, "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
	
}



/////////////
//
// sets up players for starts
//
///////////////////

start_teleport_players( start_name )
{
	
	// grab all players
	players = get_players();

	
	// Grab the starting point, could be a ent, node, vector, whatever.
	starts = getentarray( start_name, "targetname");
	assertex( starts.size >= players.size, "Need more start positions for players!" ); 
	

	// set up each player, make sure there are four points to start from
	for (i = 0; i < players.size; i++)
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}	
	
}

///////////////////
//
// sets up ai for starts
//
///////////////////////////////

start_teleport_ai( start_name )
{
	
	// grab all friendly ai
	friendly_ai = getentarray( "friendly_squad_ai", "script_noteworthy" );

	
	// Grab the starting point, could be a ent, node, vector, whatever.
	ai_starts = getentarray( start_name +"_ai", "targetname");
	assertex( ai_starts.size >= friendly_ai.size, "Need more start positions for ai!" ); 
	
	for (i = 0; i < friendly_ai.size; i++)
	{
		// Set the ai's origin to each start point
		friendly_ai[i] teleport( ai_starts[i].origin );
	
	}	
	
}


set_player_chain( name )
{

	chain_node = getnode( name, "targetname" );
	assertex( isdefined( chain_node ), "chain_node isn't defined!" );
	
	get_random_player() setfriendlychain( chain_node );
	
}




// TODO, might not need this, as i can just do get_specific_ai( "test" ).size

///////////////////
//
//  return the number of guys alive with the given script_noteworthy
//
///////////////////////////////

//get_specific_ai_count( name )
//{
//
//	guys = getentarray( name, "script_noteworthy" );
//	
//	
//	guy_count = 0;
//	
//	for( i = 0; i < guys.size; i++ )
//	{
//	
//		if( isalive( guys[i] ) )
//		{
//			guy_count++;
//		}
//		
//	}	
//	
//	return guy_count;
//
//}





///////////////////
//
//  return an array of guys alive with the given script_noteworthy
//
///////////////////////////////

get_specific_ai( name )
{

	guys = getentarray( name, "script_noteworthy" );
	
	ai_array = [];
	
	for( i = 0; i < guys.size; i++ )
	{
	
		if( isalive( guys[i] ) )
		{
			
			ai_array = array_add ( ai_array, guys[i] );
			
		}
		
	}	
	
	return ai_array;

}





///////////////////////////////////
//////////////////////////////////
// debug stuff
//
///////////////////////////////////
///////////////////////////////////








///////////////////
//
// sets up hud elements
//
////////////////////////

setup_guzzo_hud()
{
/#
	level.event_info = NewHudElem(); 
	level.event_info.alignX = "right"; 
	level.event_info.x = 110; 
	level.event_info.y = 245;
	
	level.extra_info = NewHudElem(); 
	level.extra_info.alignX = "right"; 
	level.extra_info.x = 100; 
	level.extra_info.y = 262;
	
	level.ai_info = NewHudElem(); 
	level.ai_info.alignX = "right"; 
	level.ai_info.x = 100; 
	level.ai_info.y = 277;

	level.center_info = NewHudElem(); 
	level.center_info.alignX = "center"; 
	level.center_info.x = 335; 
	level.center_info.y = 90;
	level.center_info.fontscale = 2;
#/
}



/////////////////
//
// to display text quickly and easily. uses center_info hud_elem
//
//////////////////////////////

quick_text( text, how_long )
{
/#

	if( !isdefined( how_long ) )
	{
		how_long = 2;	
	}

	level thread quick_text_thread( text, how_long );
#/	
}



// ***used internally
// sets text on center_info hud element, waits, then deletes it
quick_text_thread( text, how_long )
{
/#
	// stop other quick_texts that might be going
	level notify( "stop_quick_text" );
	
	level endon( "stop_quick_text" );

	level.center_info setText( text );
	
	wait ( how_long );
	
	level.center_info setText( "" );
#/
}


// flashes test on center_info hud element
flash_center_text( text )
{
/#	
	level thread hud_fade( level.center_info, text );
#/	
}

// ***used internally
// fades in hud_elem by setting its alpha increasingly higher
hud_fade( hud_elem, text )
{
/#
	flash_count = 0;

	hud_elem.alpha = 0;
	hud_elem setText( text );

	// fade up the text
	while( 1 )
	{

		if( ( hud_elem.alpha + 0.05 ) >= 1 )
		{
			hud_elem.alpha = 0;
			
			flash_count++;
			
			// stop displaying text after a certain number of flashes
			if( ( flash_count ) > 5 )
			{
				break;	
			}
			
		}

		hud_elem.alpha = hud_elem.alpha + 0.05;
		maps\_spawner::waitframe();

	}

#/
}

// sets specified text on specified hud element
set_hud_text( hud_elem, text )
{
/#
	hud_elem setText( text );
#/
}



//get_alive_ai( name )
//{
//	
//	guys = getentarray( name, "script_noteworthy" );
//	
//	for( i = 0; i < guys.size; i++ )
//	{
//	
//		if( isalive( guys[i] ) )
//		{
//			return guys[i];
//		}
//		
//	}	
//	
//}




///////////
//
// show w/ big text the amount of guys alive with the specified script_noteworthy
//
//////////////////////////
show_alive_ai_count( name )
{
/#
	while( 1 )
	{
	
		quick_text( get_specific_ai( "dudes" ).size + name + " are alive", 1  );
		
		wait 1.1;
	
		
	}
#/	
}




//////////////
//
// count all alive axis and show the # on the level.ai_info hud_elem
//
/////////////////////
debug_ai()
{
/#
	while( 1 )
	{
	
		//set_hud_text( level.event_info, "total_friends: " + level.totalfriends );
		//set_hud_text( level.extra_info, "maxfriendlies: " + level.maxfriendlies );
		
		//total_ai = GetAiArray( "axis", "allies" );
		axis_ai = GetAiArray( "axis" );
		set_hud_text( level.ai_info, "total axis: " + axis_ai.size );
	
		wait 1.5;
	
	}
#/
}





