#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include maps\_load_common;

#insert raw\common_scripts\utility.gsh;

/*   Level variables used in file
level.default_skipto	 - String 						- Only set manually in set_default_skipto.  Sets which skipto will be called when level loads naturally.
level.skipto_arrays		 - Array of Arrays    - The first index is by skipto name, the corresponding array holds the skipto name, skipto function, skipto loc string, and the event/logic func for level progression
level.skipto_functions - Array of Functions - The skipto functions for the level that set up each skipto
level.skipto_point		 - String 						- The name of the skipto point used on current level load called from Rex, the in game devgui, or other tools
*/

/@
"Name: add_skipto_construct( <skipto> )"
"Summary: Returns the parameters as a string indexed array, used in the utility logic later on"
@/
add_skipto_construct( msg, func, loc_string, optional_func )
{
	array = [];
	array[ "name" ] = msg;
	array[ "skipto_func" ] = func;
	array[ "skipto_loc_string" ] = loc_string;
	array[ "logic_func" ] = optional_func;
    return array;
}


/@
"Name: add_skipto_assert( <skipto> )"
"Summary: Asserts if skiptos aren't added after _load::main, since critical logic is called then, and defines level.skipto_function array if it's not defined"
@/
add_skipto_assert()
{
   	assert( !isdefined( level._loadStarted ), "Can't create skiptos after _load" );
	if ( !isdefined( level.skipto_functions ) )
		level.skipto_functions = [];
}

level_has_skipto_points()
{
	return level.skipto_functions.size > 1;
}

/@
"Name: is_default_skipto()"
"Summary: Returns true if you're playing from the default skipto.  Returns true if it is the first skipto or if it matches a skipto set by set_default_skipto"
"Module: Utility"
"Example: if ( is_default_skipto() )"
"SPMP: singleplayer"
@/
is_default_skipto()
{
	if ( IsDefined( level.default_skipto ) && level.default_skipto == level.skipto_point )
		return true;

	if ( level_has_skipto_points() )
		return level.skipto_point == level.skipto_functions[ 0 ][ "name" ];

	return false;
}


/@
"Name: is_first_skipto()"
"Summary: Returns true if it is the first skipto point in the list of skiptos."
"Module: Utility"
"Example: if ( is_first_skipto() )"
"SPMP: singleplayer"
@/
is_first_skipto()
{
	if ( !level_has_skipto_points() )
		return true;

	return level.skipto_point == level.skipto_functions[ 0 ][ "name" ];
}

/@
"Name: is_after_skipto( <skipto_name> )"
"Summary: returns true if the current skipto point is chronologically after the passed in skipto point."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <name>: "
"Example: "
"SPMP: singleplayer"
@/

is_after_skipto( skipto_name )
{
	hit_current_skipto = false;

	if( level.skipto_point == skipto_name )
		return false;

	for ( i = 0; i < level.skipto_functions.size; i++ )
	{
		if ( level.skipto_functions[ i ][ "name" ] == skipto_name )
		{
			hit_current_skipto = true;
			continue;
		}
		if( level.skipto_functions[ i ][ "name" ] == level.skipto_point )
			return hit_current_skipto;
	}
}

	// Shows the skipto name, only called when a skipto other than the default is used
indicate_skipto( skipto )
{
	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "top";
	hudelem.x = 0;
	hudelem.y = 80;
//	hudelem.label = "Loading from skipto: " + skipto;
	hudelem SetText( skipto );
	hudelem.alpha = 0;
	hudelem.fontScale = 3;
	wait( 1 );
	hudelem FadeOverTime( 1 );
	hudelem.alpha = 1;
	wait( 5 );
	hudelem FadeOverTime( 1 );
	hudelem.alpha = 0;
	wait( 1 );
	hudelem Destroy();
}

	// Called in _load, the main skipto functionality
handle_skiptos()
{
	if (!isdefined(GetDvar("skipto")) )
	{
		SetDvar("skipto", "");
	}
	
 	if ( !isdefined( level.skipto_functions ) )
		level.skipto_functions = [];

	// TFLAME - 3/22/11 - I dont think this does anything in our engine, IW had some "popupmenu" but we don't support that
	/*
	/#
		PrecacheMenu( "skipto" );
	#/
	*/

	skipto = ToLower( GetDvar( "skipto" ) );

	// find the skipto that matches the one the dvar is set to, and execute it
	names = get_skipto_names();
	

	if ( IsDefined( level.skipto_point ) )
	{
		skipto = level.skipto_point;
	}

	// first try to find the skipto based on the dvar
	skipto_index = 0;
	for ( i = 0; i < names.size; i++ )
	{
		if ( skipto == names[ i ] )
		{
			skipto_index = i;
			level.skipto_point = names[ i ];
			break;
		}
	}
		
	// If it doesn't match or there is no dvar, revert to the default
	if ( !IsDefined( level.skipto_point ) )
	{
		if ( IsDefined( level.default_skipto ) )
		{
			level.skipto_point = level.default_skipto;
		}
		else if ( level_has_skipto_points() )
		{
			level.skipto_point = level.skipto_functions[ 0 ][ "name" ];
		}
		
		if ( !IsDefined( level.skipto_point ) )
		{
			return;
		}

		// make sure to set the skipto_index since it is used to pick the right logic structure later
		for ( i = 0; i < names.size; i++ )
		{
			if ( level.skipto_point == names[ i ] )
			{
				skipto_index = i;
				break;
			}
		}
	}
	
	wait_for_first_player();

	waittillframeend;// skiptos happen at the end of the first frame, so threads in the mission have a chance to run and init stuff
	thread skipto_menu(); // thread that waits for the devgui or button combo to display the skipto selection menu, then opens it
	
	if ( !is_default_skipto() )
	{
		// save the dvar so the skipto works again after dying
		SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "", true );
	}

	skipto_array = level.skipto_arrays[ level.skipto_point ];
   
  	// TFLAME - 3/22/11 - If it's not the default skipto, display the skipto name
	if ( !is_default_skipto() )
	{
		if ( IsDefined( skipto_array[ "skipto_loc_string" ] ) )
		{
			thread indicate_skipto( skipto_array[ "skipto_loc_string" ] );
		}
		else
		{
			thread indicate_skipto( level.skipto_point );
		}
	}

	if ( IsDefined( level.func_skipto_cleanup ) )
	{
		[[ level.func_skipto_cleanup ]]();
	}
	
	if ( IsDefined( skipto_array[ "skipto_func" ] ) )
	{
		[[ skipto_array[ "skipto_func" ] ]]();
	}
	
	// If we are at the default, set the skipto dvar to include all of the skipto names, I assume this was originally done for reference
	if ( is_default_skipto() )
	{
		string = get_string_for_skiptos( names );
		SetDvar( "skipto", string ); 
	}
	
	level thread dev_skipto_warning();

	waittillframeend;// let the frame finish for all ai init type stuff that goes on in skipto points

	previously_run_logic_functions = [];

	// TFLAME - 3/22/11 - If the first skipto called doesn't have a logic_func, return out as it's a dev skipto (according to our scripting guidelines)
	if ( !isdefined( level.skipto_functions[skipto_index][ "logic_func" ] ) )
	{
		return;
	}
	
	// run each logic function in order
	logic_function_progression = build_logic_function_progression();
	logic_function_starting_index = get_logic_function_starting_index(skipto_index, logic_function_progression);
	
	
	for ( i = logic_function_starting_index; i < logic_function_progression.size; i++ )  //run through logic_function_progression
	{
		next_logic_func = logic_function_progression[i];
		if ( already_ran_function( next_logic_func, previously_run_logic_functions ) )  // have I already ran the logic func?
			continue;
		[[ next_logic_func ]]();						// run my logic func!
		previously_run_logic_functions[ previously_run_logic_functions.size ] = next_logic_func;  //store this as a run func
	}
	
}

already_ran_function( func, previously_run_logic_functions )
{
	for (i=0; i< previously_run_logic_functions.size; i++)
	{
		if ( func == previously_run_logic_functions[i] )
		{
			return true;
		}
	}
	return false;
}

// returns a string that includes all of the skipto names
get_string_for_skiptos( names )
{
	string = " ** No skiptos have been set up for this map with maps\_utility::add_skipto().";
	if ( names.size )
	{
		string = " ** ";
		for ( i = names.size - 1; i >= 0; i-- )
		{
			string = string + names[ i ] + " ";
		}
	}

	SetDvar( "skipto", string );
	return string;
}

// TFLAME - 3/21/11 - Creates some hudelem, not sure which one yet
create_skipto( skipto, index )
{
	alpha = 1;
	color = ( 0.9, 0.9, 0.9 );
	if ( index != -1 )
	{
		const middle = 5;
		if ( index != middle )
		{
			alpha = 1 - ( abs( middle - index ) / middle );
		}
		else
		{
			color = ( 1, 1, 0 );
		}
	}

	if ( alpha == 0 )
	{
		alpha = 0.05;
	}

	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 80;
	hudelem.y = 80 + index * 18;
	hudelem SetText( skipto );
	hudelem.alpha = 0;
	hudelem.foreground = true;
	hudelem.color = color;

	hudelem.fontScale = 1.75;
	hudelem FadeOverTime( 0.5 );
	hudelem.alpha = alpha;
	return hudelem;
}

// thread that waits for the devgui or button combo to display the skipto selection menu, then opens it
skipto_menu()
{


	for ( ;; )
	{
		if ( isdefined(GetDvarInt( "debug_skipto" )) && GetDvarInt( "debug_skipto" ) )
		{
				// TFLAME - 3/21/11 - unsupported code API
			SetDvar( "debug_skipto", 0 );
			SetSavedDvar( "hud_drawhud", 1 );
			get_players()[0] allowjump(false); // TFLAME - 3/22/11 - Looks bad to jump when selecting in a menu
			display_skiptos();
			get_players()[0] allowjump(true);
		}
		if ( GetDvarInt( "debug_start" ) )
		{
				// TFLAME - 3/21/11 - unsupported code API
			SetDvar( "debug_start", 0 );
			SetSavedDvar( "hud_drawhud", 1 );
			get_players()[0] allowjump(false); // TFLAME - 3/22/11 - Looks bad to jump when selecting in a menu
			display_skiptos();
			get_players()[0] allowjump(true);
		}
		wait( 0.05 );
	}

}


skipto_nogame()
{
	guys = getaiarray();
	guys = array_combine(guys, getspawnerarray() );
	for (i=0; i< guys.size; i++)
	{
		guys[i] delete();
	}
}


get_skipto_names()
{
	names = [];
	for ( i = 0; i < level.skipto_functions.size; i++ )
	{
		names[ names.size ] = level.skipto_functions[ i ][ "name" ];
	}
	return names;
}


// TFLAME - 3/21/11 - Displays the skipto menu
display_skiptos()
{
	if ( level.skipto_functions.size <= 0 )
		return;

	names = get_skipto_names();
	names[ names.size ] = "default";
	names[ names.size ] = "cancel";

	elems = skipto_list_menu();
	
	// Available skiptos:
	title = create_skipto( "Selected skipto:", -1 );
	title.color = ( 1, 1, 1 );
	strings = [];

	for ( i = 0; i < names.size; i++ )
	{
		s_name = names[ i ];
		skipto_string = "[" + names[ i ] + "]";
	

	  if( s_name != "cancel" && s_name != "default" && s_name != "no_game" )
		{
				skipto_string += " -> ";
    		if (IsDefined( level.skipto_arrays[ s_name ][ "skipto_loc_string" ] ) )
    		{
    			
    				// TFLAME - 3/21/11 - Can't combine strings and localized strings in our engine so can't do this right now
    			//skipto_string += level.skipto_arrays[ s_name ][ "skipto_loc_string" ];
    		}
		}

		strings[ strings.size ] = skipto_string;
	}

	selected = names.size - 1;
	up_pressed = false;
	down_pressed = false;
	
	found_current_skipto = false;
	
	while( selected > 0 )
	{
	    if( names[ selected ] == level.skipto_point )
	    {
	        found_current_skipto = true;
	        break;
	    }
	    selected--;
	}
	
	if( !found_current_skipto )
	{
	    selected = names.size - 1;
	}

	skipto_list_settext( elems, strings, selected );
	old_selected = selected;
	
	for ( ;; )
	{
		if ( old_selected != selected )
		{		
			skipto_list_settext( elems, strings, selected );
			old_selected = selected;
		}

		if ( !up_pressed )
		{
			if ( get_players()[0] ButtonPressed( "UPARROW" ) || get_players()[0] ButtonPressed( "DPAD_UP" ) || get_players()[0] ButtonPressed( "APAD_UP" ) )
			{
				up_pressed = true;
				selected--;
			}
		}
		else
		{
			if ( !get_players()[0] ButtonPressed( "UPARROW" ) && !get_players()[0] ButtonPressed( "DPAD_UP" ) && !get_players()[0] ButtonPressed( "APAD_UP" ) )
			{
				up_pressed = false;
			}
		}


		if ( !down_pressed )
		{
			if ( get_players()[0] ButtonPressed( "DOWNARROW" ) || get_players()[0] ButtonPressed( "DPAD_DOWN" ) || get_players()[0] ButtonPressed( "APAD_DOWN" ) )
			{
				down_pressed = true;
				selected++;
			}
		}
		else
		{
			if ( !get_players()[0] ButtonPressed( "DOWNARROW" ) && !get_players()[0] ButtonPressed( "DPAD_DOWN" ) && !get_players()[0] ButtonPressed( "APAD_DOWN" ) )
			{
				down_pressed = false;
			}
		}

		if ( selected < 0 )
		{
			selected = names.size - 1;
		}

		if ( selected >= names.size )
		{
			selected = 0;
		}

		if ( get_players()[0] ButtonPressed( "BUTTON_B" ) )
		{
			skipto_display_cleanup( elems, title );
			break;
		}

		if ( get_players()[0] ButtonPressed( "kp_enter" ) || get_players()[0] ButtonPressed( "BUTTON_A" ) || get_players()[0] ButtonPressed( "enter" ) )
		{
			if ( names[ selected ] == "cancel" )
			{
				skipto_display_cleanup( elems, title );
				break;
			}


			SetDvar( "skipto", names[ selected ] );
			// TFLAME - 3/21/11 - unsuppoted code API.  As far as I can tell it just reset the level 
			//get_players()[0] OpenPopupMenu( "skipto" );
			fastrestart();
		}
		wait( 0.05 );
	}
}

skipto_list_menu()
{
	hud_array = [];
	for ( i = 0; i < 11; i++ )
	{
		hud = create_skipto( "", i );
		hud_array[ hud_array.size ] = hud;
	}

	return hud_array;
}

// handles the updating of the skipto menu selection(s)
skipto_list_settext( hud_array, strings, num )
{
	for ( i = 0; i < hud_array.size; i++ )
	{
		index = i + ( num - 5 );
		if ( IsDefined( strings[ index ] ) )
		{
			text = strings[ index ];
		}
		else
		{
			text = "";
		}

		hud_array[ i ] SetText( text );
	}

}

skipto_display_cleanup( elems, title )
{
	title Destroy();
	for ( i = 0; i < elems.size; i++ )
	{
		elems[ i ] Destroy();
	}
}

dev_skipto_warning()
{
	if ( !is_current_skipto_dev() )
	{
		return;
	}
	
	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "top";
	hudelem.x = 0;
	hudelem.y = 70;
	hudelem SetText( "This skipto is for development purposes only!  The level may not progress from this point.");
	hudelem.alpha = 1;
	hudelem.fontScale = 1.8;
	hudelem.color = (1,0.55,0);
	wait( 7 );
	hudelem FadeOverTime( 1 );
	hudelem.alpha = 0;
	wait( 1 );
	hudelem Destroy();
	
}

is_current_skipto_dev()
{
	substr = ToLower(GetSubStr(level.skipto_point, 0, 4)); 
	if( substr == "dev_")
	{
		return true;
	}	
	return false;
}

is_no_game_skipto()
{
	if (!isdefined(level.skipto_point))
		return false;
  return IsSubStr( level.skipto_point, "no_game" );
}

do_no_game_skipto() // currently call this after 442
{
  if ( !is_no_game_skipto() )
	    return;
	    
	// we want ufo/noclip to hit triggers in no_game
	level.stop_load = true;
	// SRS 11/25/08: LDs can run a custom setup function for their levels to get back some
	//  selected script calls (loadout, vision, etc).  be careful, this function is not threaded!
	if ( IsDefined( level.custom_no_game_setupFunc ) )
	{
		level [[ level.custom_no_game_setupFunc ]]();
	}
	
	thread maps\_radiant_live_update::main();
	maps\_loadout::init_loadout();
	maps\_anim::init(); 
	maps\_busing::businit(); 
	maps\_music::music_init();
	maps\_global_fx::main();


	maps\_hud_message::init();
	thread maps\_ingamemenus::init(); 

	/#
	thread maps\_debug::mainDebug(); 
	#/

  level thread all_players_connected();
	level thread all_players_spawned();
	level thread maps\_endmission::main(); 
	
	array_thread( GetEntArray( "water", "targetname" ), maps\_load_common::waterThink );
	thread maps\_interactive_objects::main(); 
	thread maps\_audio::main(); 
	
	maps\_hud::init();
	maps\_swimming::main();
	
	// devgui hotness
	/#
	thread maps\_dev::init();
	#/
		
	maps\_turret::init_turrets();
	
	level waittill( "eternity" );
}

// Return a chronological array of level logic functions passed in through add_skipto
build_logic_function_progression()
{
	logic_function_progression = [];
	for ( i=0; i < level.skipto_functions.size; i++ ) 
	{
		skipto_array = level.skipto_functions[ i ];      
		if ( !isdefined( skipto_array[ "logic_func" ] ) )
			continue;
		ARRAY_ADD(logic_function_progression, skipto_array[ "logic_func" ]);
	}
	return logic_function_progression;
}

// Find the index within the logic functions we should start at.
get_logic_function_starting_index(skipto_index, logic_function_progression)
{
	starting_logic_func = level.skipto_functions[skipto_index][ "logic_func" ];
	for (i=0; i< logic_function_progression.size; i++)
	{
		if (starting_logic_func == logic_function_progression[i])
		{
			return i;
		}
	}
}