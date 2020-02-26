// MikeD (3/20/2007): This script file is used for debug menus
#include maps\_utility;
createmenu_init()
{
/#
	level.menu_sys = [];
	level.menu_sys["current_menu"] = SpawnStruct();
#/
}

//----------------------------------------------------------//
// add_menu( <menu_name>, <title> )					//
//		Creates a menu										//
//----------------------------------------------------------//
// self 		- n/a										//
// menu_name 	- The registered name used for reference	//
// title 		- Name of menu when it's displayed			//
//----------------------------------------------------------//
add_menu( menu_name, title )
{
/#
	if( IsDefined( level.menu_sys[menu_name] ) )
	{
		println( "^1level.menu_sys[" + menu_name + "] already exists, change the menu_name" );
		return;
	}

	level.menu_sys[menu_name] = SpawnStruct();
	level.menu_sys[menu_name].title = "none";

	level.menu_sys[menu_name].title = title;
#/
}

//----------------------------------------------------------//
// add_menuoptions( menu_name, option_text, func )			//
//		Adds a menu option to the given menu				//
//----------------------------------------------------------//
// self 		- n/a										//
// menu_name	- What menu (reference) to add the option to//
// option_text	- Text to display for the option			//
// func			- The function to use when this option is	//
//				activated									//
// key			- The key used in order to start the func	//
//----------------------------------------------------------//
add_menuoptions( menu_name, option_text, func, key )
{
/#
	if( !IsDefined( level.menu_sys[menu_name].options ) )
	{
		level.menu_sys[menu_name].options = [];
	}

	num = level.menu_sys[menu_name].options.size;
	level.menu_sys[menu_name].options[num] = option_text;
	level.menu_sys[menu_name].function[num] = func;

	if( IsDefined( key ) )
	{
		if( !IsDefined( level.menu_sys[menu_name].func_key ) )
		{
			level.menu_sys[menu_name].func_key = [];
		}

		level.menu_sys[menu_name].func_key[num] = key;
	}
#/
}

//------------------------------------------------------------------------------------------//
// add_menu_child( parent_menu, child_menu, child_title, [child_number_override], [func] )	//
//		Adds a menu option to the given menu												//
//------------------------------------------------------------------------------------------//
// self 					- n/a															//
// parent_menu				- The parent menu (reference) name for the child menu			//
// child_menu				- The child menu (reference) name								//
// child_title				- The name displayed when the child menu is enabled				//
// child_number_override	- Force this child to be a specific option #					//
// func						- Optional function to run when this child menu is activated	//
//------------------------------------------------------------------------------------------//
add_menu_child( parent_menu, child_menu, child_title, child_number_override, func )
{
/#
	if( !IsDefined( level.menu_sys[child_menu] ) )
	{
		add_menu( child_menu, child_title );
	}

	level.menu_sys[child_menu].parent_menu = parent_menu;

	if( !IsDefined( level.menu_sys[parent_menu].children_menu ) )
	{
		level.menu_sys[parent_menu].children_menu = [];
	}

	if( !IsDefined( child_number_override ) )
	{
		size = level.menu_sys[parent_menu].children_menu.size;
	}
	else
	{
		size = child_number_override;
	}

	level.menu_sys[parent_menu].children_menu[size] = child_menu;

	if( IsDefined( func ) )
	{
		if( !IsDefined( level.menu_sys[parent_menu].children_func ) )
		{
			level.menu_sys[parent_menu].children_func = [];
		}

		level.menu_sys[parent_menu].children_func[size] = func;
	}
#/
}

set_no_back_menu( menu_name )
{
/#
	level.menu_sys[menu_name].no_back = true;
#/
}

//--------------------------------------//
// enable_menu( menu_name )				//
// 		Enables the specified menu		//
//--------------------------------------//
// self 		- n/a					//
// menu_name	- The menu to enable	//
//--------------------------------------//
enable_menu( menu_name )
{
/#
	// Destroy the current menu
	disable_menu( "current_menu" );

	if( IsDefined( level.menu_cursor ) )
	{
		level.menu_cursor.y = 130;
		level.menu_cursor.current_pos = 0;
	}

	// Set the title
	level.menu_sys["current_menu"].title = set_menu_hudelem( level.menu_sys[menu_name].title, "title" );

	// Set the Options
	level.menu_sys["current_menu"].menu_name = menu_name;

	back_option_num = 0; // Used for the "back" option
	if( IsDefined( level.menu_sys[menu_name].options ) )
	{
		options = level.menu_sys[menu_name].options;
		for( i = 0; i < options.size; i++ )
		{
			text = ( i + 1 ) + ". " + options[i];
			level.menu_sys["current_menu"].options[i] = set_menu_hudelem( text, "options", 20 * i );
			back_option_num = i;
		}
	}

	// If a parent_menu is specified, automatically put a "Back" option in.
	if( IsDefined( level.menu_sys[menu_name].parent_menu ) && !IsDefined( level.menu_sys[menu_name].no_back ) )
	{
		back_option_num++;
		text = ( back_option_num + 1 ) + ". " + "Back";
		level.menu_sys["current_menu"].options[back_option_num] = set_menu_hudelem( text, "options", 20 * back_option_num );
	}
#/
}

//--------------------------------------//
// disable_menu( menu_name )			//
// 		Disables the specified menu		//
//--------------------------------------//
// self 		- n/a					//
// menu_name	- The menu to disable	//
//--------------------------------------//
disable_menu( menu_name )
{
/#
	if( IsDefined( level.menu_sys[menu_name] ) )
	{
		if( IsDefined( level.menu_sys[menu_name].title ) )
		{
			level.menu_sys[menu_name].title Destroy();
		}
	
		if( IsDefined( level.menu_sys[menu_name].options ) )
		{
			options = level.menu_sys[menu_name].options;
			for( i = 0; i < options.size; i++ )
			{
				options[i] Destroy();
			}
		}
	}

	level.menu_sys[menu_name].title = undefined;
	level.menu_sys[menu_name].options = [];
#/
}

//------------------------------------------------------//
// set_menu_hudelem( text, [type], [y_offset] )			//
//		Creates a unified menu hudelem					//
//------------------------------------------------------//
// self 	- n/a										//
// text 	- The text to be displayed					//
// type		- Determines the type of hudelem to create 	//
//			  (title or normal)							//
// y_offset	- Sets how far to move the menu downward	//
//------------------------------------------------------//
set_menu_hudelem( text, type, y_offset )
{
/#
	x = 10;
	y = 100;
	if( IsDefined( type ) && type == "title" )
	{
		scale = 2;
	}
	else // Default to Options
	{
		scale = 1.3;
		y = y + 30;
	}

	if( !IsDefined( y_offset ) )
	{
		y_offset = 0;
	}

	y = y + y_offset;

	return set_hudelem( text, x, y, scale  );
#/
}

//------------------------------------------------------//
// set_hudelem( [text], x, y, [scale], [alpha] )		//
//		Actually creates the hudelem					//
//------------------------------------------------------//
// self		- n/a										//
// text		- The text to be displayed					//
// x		- Sets the x position of the hudelem		//
// y		- Sets the y position of the hudelem		//
// scale	- Sets the scale of the hudelem				//
// alpha	- Sets the alpha of the hudelem				//
//------------------------------------------------------//
set_hudelem( text, x, y, scale, alpha, sort, debug_hudelem )
{
/#
	if( !IsDefined( alpha ) )
	{
		alpha = 1;
	}

	if( !IsDefined( scale ) )
	{
		scale = 1;
	}

	if( !IsDefined( sort ) )
	{
		sort = 20;
	}



	if( IsDefined( level.player ) && !IsDefined( debug_hudelem ) )
	{
		hud = NewClientHudElem( level.player );
	}
	else
	{
		hud = NewDebugHudElem();
		hud.debug_hudelem = true;
	}
	hud.location = 0;
	hud.alignX = "left";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.fontScale = scale;
	hud.sort = sort;
	hud.alpha = alpha;
	hud.x = x;
	hud.y = y;
	hud.og_scale = scale;

	if( IsDefined( text ) )
	{
		hud SetText( text );
	}

	return hud;
#/
}

//------------------------------------------------------//
// menu_input()											//
//		This is the main menu input loop, it catches	//
//		the user input and determines what it will do	//
//		next with the menus								//
//------------------------------------------------------//
//	self 	- level										//
//------------------------------------------------------//
menu_input()
{
/#
	while( 1 )
	{
		// Notify from button_loop
		level waittill( "menu_button_pressed", keystring );

		menu_name = level.menu_sys["current_menu"].menu_name;

		// Move Menu Cursor
		if( keystring == "dpad_up" || keystring == "uparrow" )
		{
			if( level.menu_cursor.current_pos > 0 )
			{
				level.menu_cursor.y = level.menu_cursor.y - 20;
				level.menu_cursor.current_pos--;
			}
			else if( level.menu_cursor.current_pos == 0 )
			{
				// Go back to the Bottom.
				level.menu_cursor.y = ( level.menu_cursor.y + ( ( level.menu_sys["current_menu"].options.size - 1 ) * 20 ) );
				level.menu_cursor.current_pos = level.menu_sys["current_menu"].options.size - 1;
			}
			
			wait( 0.1 );
			continue;
		}
		else if( keystring == "dpad_down" || keystring == "downarrow" )
		{
			if( level.menu_cursor.current_pos < level.menu_sys["current_menu"].options.size - 1 )
			{
				level.menu_cursor.y = level.menu_cursor.y + 20;
				level.menu_cursor.current_pos++;
			}
			else if( level.menu_cursor.current_pos == level.menu_sys["current_menu"].options.size - 1 )
			{
				// Go back to the top.
				level.menu_cursor.y = ( level.menu_cursor.y + ( level.menu_cursor.current_pos * -20 ) );
				level.menu_cursor.current_pos = 0;
			}
			wait( 0.1 );
			continue;
		}
		else if( keystring == "button_a" || keystring == "enter" )
		{
			key = level.menu_cursor.current_pos;
		}
		else // If the user is on the PC and using 1-0 for menu selecting.
		{
			key = int( keystring ) - 1;
		}
	
		if( key > level.menu_sys[menu_name].options.size )
		{
			continue;
		}
		else if( IsDefined( level.menu_sys[menu_name].parent_menu ) && key == level.menu_sys[menu_name].options.size )
		{
			// This is if the "back" key is hit.
			level notify( "disable " + menu_name );
			level enable_menu( level.menu_sys[menu_name].parent_menu );
		}
		else if( IsDefined( level.menu_sys[menu_name].function ) && IsDefined( level.menu_sys[menu_name].function[key] ) )
		{
//			level.menu_sys["current_menu"].options[key] thread hud_font_scaler( 1.1 );
			level.menu_sys["current_menu"].options[key] thread hud_selector( level.menu_sys["current_menu"].options[key].x, level.menu_sys["current_menu"].options[key].y );

			if( IsDefined( level.menu_sys[menu_name].func_key ) && IsDefined( level.menu_sys[menu_name].func_key[key] ) && level.menu_sys[menu_name].func_key[key] == keystring )
			{
				error_msg = level [[level.menu_sys[menu_name].function[key]]]();
			}
			else
			{
				error_msg = level [[level.menu_sys[menu_name].function[key]]]();
			}

			level thread hud_selector_fade_out();

			if( IsDefined( error_msg ) )
			{
				level thread selection_error( error_msg, level.menu_sys["current_menu"].options[key].x, level.menu_sys["current_menu"].options[key].y );
			}
		}

		if( !IsDefined( level.menu_sys[menu_name].children_menu ) )
		{
			println( "^1 " + menu_name + " Menu does not have any children menus, yet" );
			continue;
		}
		else if( !IsDefined( level.menu_sys[menu_name].children_menu[key] ) )
		{
			println( "^1 " + menu_name + " Menu does not have a number " + key + " child menu, yet" );
			continue;
		}
		else if( !IsDefined( level.menu_sys[level.menu_sys[menu_name].children_menu[key]] ) )
		{
			println( "^1 " + level.menu_sys[menu_name].options[key] + " Menu does not exist, yet" );
			continue;
		}

		if( IsDefined( level.menu_sys[menu_name].children_func ) && IsDefined( level.menu_sys[menu_name].children_func[key] ) )
		{
			func = level.menu_sys[menu_name].children_func[key];
			error_msg = [[func]]();

			if( IsDefined( error_msg ) )
			{
				level thread selection_error( error_msg, level.menu_sys["current_menu"].options[key].x, level.menu_sys["current_menu"].options[key].y );
				continue;
			}
		}

		level enable_menu( level.menu_sys[menu_name].children_menu[key] );

		wait( 0.1 );
	}
#/
}

force_menu_back( waittill_msg )
{
/#
	if( IsDefined( waittill_msg ) )
	{
		level waittill( waittill_msg );
	}

	wait( 0.1 );
	menu_name = level.menu_sys["current_menu"].menu_name;
	key = level.menu_sys[menu_name].options.size;
	key++;

	if( key == 1 )
	{	
		key = "1";
	}
	else if( key == 2 )
	{	
		key = "2";
	}
	else if( key == 3 )
	{	
		key = "3";
	}
	else if( key == 4 )
	{	
		key = "4";
	}
	else if( key == 5 )
	{	
		key = "5";
	}
	else if( key == 6 )
	{	
		key = "6";
	}
	else if( key == 7 )
	{	
		key = "7";
	}
	else if( key == 8 )
	{	
		key = "8";
	}
	else if( key == 9 )
	{	
		key = "9";
	}

	level notify( "menu_button_pressed", key );
#/
}

//--------------------------------------------------------------//
// list_menu( list, x, y, scale, func )							//
//		Displays a scrollable list next to the select option	//
//--------------------------------------------------------------//
// self		- n/a												//
// list		- List of text to display							//
// x		- Sets the x position of the list					//
// y		- Sets the y position of the list					//
// scale	- Sets the scale of the text						//
// func		- Runs this function with the given selection during//
//			  scrolling											//
//--------------------------------------------------------------//
list_menu( list, x, y, scale, func, sort, start_num )
{
/#
	if( !IsDefined( list ) || list.size == 0 )
	{
		return -1;
	}

	hud_array = [];
	space_apart = 15;

	// Since we reduced the total amount of hudelems, I had to do this a different way.
//	for( i = 0; i < list.size; i++ )
//	{
//		alpha = 1 / ( i + 1 );
//
//		if( alpha < 0.3 )
//		{
//			alpha = 0;
//		}
//
//		hud = set_hudelem( list[i], x, y + ( i * space_apart ), scale, alpha, sort );
//		hud_array = maps\_utility::array_add( hud_array, hud );
//	}

	for( i = 0; i < 5; i++ )
	{
		if( i == 0 )
		{
			alpha = 0.3;
		}
		else if( i == 1 )
		{
			alpha = 0.6;
		}
		else if( i == 2 )
		{
			alpha = 1;
		}
		else if( i == 3 )
		{
			alpha = 0.6;
		}
		else
		{
			alpha = 0.3;
		}

		hud = set_hudelem( list[i], x, y + ( ( i - 2 ) * space_apart ), scale, alpha, sort );
		hud_array = maps\_utility::array_add( hud_array, hud );
	}

	if( IsDefined( start_num ) )
	{
		new_move_list_menu( hud_array, list, start_num );
	}

	current_num = 0;
	old_num = 0;
	selected = false;

	level.menu_list_selected = false;

	if( IsDefined( func ) )
	{
		[[func]]( list[current_num] );
	}

	while( true )
	{
		level waittill( "menu_button_pressed", key );

		level.menu_list_selected = true;
		if( any_button_hit( key, "numbers" ) )
		{
			break;
		}
		else if( key == "downarrow" || key == "dpad_down" )
		{
			if( current_num >= list.size - 1 )
			{
				continue;
			}

			current_num++;
//			move_list_menu( hud_array, "down", space_apart, current_num );
			new_move_list_menu( hud_array, list, current_num );
		}
		else if( key == "uparrow" || key == "dpad_up" )
		{
			if( current_num <= 0 )
			{
				continue;
			}

			current_num--;
//			move_list_menu( hud_array, "up", space_apart, current_num );	
			new_move_list_menu( hud_array, list, current_num );		
		}
		else if( key == "enter" || key == "button_a" )
		{
			selected = true;
			break;
		}
		else if( key == "end" || key == "button_b" )
		{
			selected = false;
			break;
		}

		level notify( "scroll_list" ); // Only used for special functions

		if( current_num != old_num )
		{
			old_num = current_num;

			if( IsDefined( func ) )
			{
				[[func]]( list[current_num] );
			}
		}

		wait( 0.1 );
	}

	for( i = 0; i < hud_array.size; i++ )
	{
		hud_array[i] Destroy();
	}

	if( selected )
	{
		return current_num;
	}
#/
}

new_move_list_menu( hud_array, list, num )
{
/#
	for( i = 0; i < hud_array.size; i++ )
	{
		if( IsDefined( list[i + (num - 2)] ) )
		{
			text = list[i + (num - 2)];
		}
		else
		{
			text = "";
		}

		hud_array[i] SetText( text );

//		hud_array[i] MoveOverTime( time );

//		if( side_movement )
//		{
//			hud_array[i].x = hud_array[i].x + movement;
//		}
//		else
//		{
//			hud_array[i].y = hud_array[i].y + movement;
//		}

//		temp = i - num;
//		if( temp < 0 )
//		{
//			temp = temp * -1;
//		}
		
//		alpha = 1 / ( temp + 1 );

//		if( alpha < ( 1 / num_of_fades ) )
//		{
//			alpha = min_alpha;
//		}

// MikeD (2/12/2008): FadeOvertime causes bugs.
//		if( !IsDefined( hud_array[i].debug_hudelem ) )
//		{
//			hud_array[i] FadeOverTime( time );
//		}
//		hud_array[i].alpha = alpha;	
	}
#/
}

//------------------------------------------------------------------//
// move_list_menu( hud_array, dir, space, num, min_alpha )			//
//		Scrolls the list menu up/down								//
//------------------------------------------------------------------//
// self			- n/a												//
// hud_array	- Array of text that is listed						//
// dir			- Direction to scroll the list, "up" or "down"		//
// space		- How much space to move the text					//
// num			- Gives the current list number, so it can fade		//
//				properly											//
//------------------------------------------------------------------//
move_list_menu( hud_array, dir, space, num, min_alpha, num_of_fades )
{
/#
	if( !IsDefined( min_alpha ) )
	{
		min_alpha = 0;
	}

	if( !IsDefined( num_of_fades ) )
	{
		num_of_fades = 3;
	}

	side_movement = false;
	time = 0.1;
	if( dir == "right" )
	{
		side_movement = true;
		movement = space;
	}
	else if( dir == "left" )
	{
		side_movement = true;
		movement = space * -1;
	}
	else if( dir == "up" )
	{
		movement = space;
	}
	else // down
	{
		movement = space * -1;
	}

	for( i = 0; i < hud_array.size; i++ )
	{
		hud_array[i] MoveOverTime( time );

		if( side_movement )
		{
			hud_array[i].x = hud_array[i].x + movement;
		}
		else
		{
			hud_array[i].y = hud_array[i].y + movement;
		}

		temp = i - num;
		if( temp < 0 )
		{
			temp = temp * -1;
		}
		
		alpha = 1 / ( temp + 1 );

		if( alpha < ( 1 / num_of_fades ) )
		{
			alpha = min_alpha;
		}

// MikeD (2/12/2008): FadeOvertime causes bugs.
		if( !IsDefined( hud_array[i].debug_hudelem ) )
		{
			hud_array[i] FadeOverTime( time );
		}
		hud_array[i].alpha = alpha;		
	}
#/
}

hud_selector( x, y )
{
/#
	if( IsDefined( level.hud_selector ) )
	{
		level thread hud_selector_fade_out();
	}

	level.menu_cursor.alpha = 0;

	level.hud_selector = set_hudelem( undefined, x - 10, y, 1 );
	level.hud_selector SetShader( "white", 125, 20 );
	level.hud_selector.color = ( 1, 1, 0.5 );
	level.hud_selector.alpha = 0.5;
	level.hud_selector.sort = 10;
#/
}

hud_selector_fade_out( time )
{
/#
	if( !IsDefined( time ) )
	{
		time = 0.25;
	}

	level.menu_cursor.alpha = 0.5;

	hud = level.hud_selector;
	level.hud_selector = undefined;

// MikeD (2/12/2008): FadeOvertime causes bugs.
	if( !IsDefined( hud.debug_hudelem ) )
	{
		hud FadeOverTime( time );
	}
	hud.alpha = 0;
	wait( time + 0.1 );
	hud Destroy();
#/
}

selection_error( msg, x, y )
{
/#
	hud = set_hudelem( undefined, x - 10, y, 1 );
	hud SetShader( "white", 125, 20 );
	hud.color = ( 0.5, 0, 0 );
	hud.alpha = 0.7;

	error_hud = set_hudelem( msg, x + 125, y, 1 );
	error_hud.color = ( 1, 0, 0 );

// MikeD (2/12/2008): FadeOvertime causes bugs.
	if( !IsDefined( hud.debug_hudelem ) )
	{
		hud FadeOverTime( 3 );
	}
	hud.alpha = 0;

// MikeD (2/12/2008): FadeOvertime causes bugs.
	if( !IsDefined( error_hud.debug_hudelem ) )
	{
		error_hud FadeOverTime( 3 );
	}
	error_hud.alpha = 0;

	wait( 3.1 );
	hud Destroy();
	error_hud Destroy();
#/
}

hud_font_scaler( mult )
{
/#
	self notify( "stop_fontscaler" );
	self endon( "death" );
	self endon( "stop_fontscaler" );

	og_scale = self.og_scale;

	if( !IsDefined( mult ) )
	{
		mult = 1.5;
	}

	self.fontscale = og_scale * mult;
	dif = og_scale - self.fontscale;
	time = 1;

	dif /= time * 20;

	for( i = 0; i < time * 20; i++ )
	{
		self.fontscale += dif;
		wait( 0.05 );
	}
#/
}

menu_cursor()
{
/#
	level.menu_cursor = set_hudelem( undefined, 0, 130, 1.3 );
	level.menu_cursor SetShader( "white", 125, 20 );
	level.menu_cursor.color = ( 1, 0.5, 0 );	
	level.menu_cursor.alpha = 0.5;
	level.menu_cursor.sort = 1; // Put behind everything
	level.menu_cursor.current_pos = 0;
#/
}

help_menu( menu_name, help_list, pc_binds, xenon_binds )
{
/#
	if( IsDefined( level.hud_array ) && IsDefined( level.hud_array[menu_name] ) )
	{
		return;
	}

	shader_width = 120;
	shader_height = 80;
	x = 640 - shader_width;
	y = 480 - shader_height - 25;
	hud = new_hud( "rotate_hud", undefined, x, y, 1 );
	hud SetShader( "white", shader_width, shader_height );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	if( level.xenon )
	{
		new_hud( "rotate_hud", "(Hold LTrig) Rotate Help:", x + 5, y + 10, 1 );
	}
	else
	{
		new_hud( "rotate_hud", "NumPad Rotate Help:", x + 5, y + 10, 1 );
	}

	y += 23;

	if( level.xenon )
	{
		new_hud( "rotate_hud", "Y/A", x + 5, y, 1 );
		new_hud( "rotate_hud", "X/B", x + 5, y + 30, 1 );
		new_hud( "rotate_hud", "BUMPERS", x + 5, y + 40, 1 );
		new_hud( "rotate_hud", "R3", x + 5, y + 50, 1 );
		new_hud( "rotate_hud", "L3", x + 5, y + 60, 1 );
	}
	else
	{
		new_hud( "rotate_hud", "8/2", x + 5, y + 20, 1 );
		new_hud( "rotate_hud", "4/6", x + 5, y + 30, 1 );
		new_hud( "rotate_hud", "7/9", x + 5, y + 40, 1 );
		new_hud( "rotate_hud", "5", x + 5, y + 50, 1 );
		new_hud( "rotate_hud", "0", x + 5, y + 60, 1 );
	}

//	new_hud( "rotate_hud", "- Pitch", x + 60, y + 10, 1 );
	new_hud( "rotate_hud", "- Pitch", x + 60, y + 20, 1 );
	new_hud( "rotate_hud", "- Yaw", x + 60, y + 30, 1 );
	new_hud( "rotate_hud", "- Roll", x + 60, y + 40, 1 );
	new_hud( "rotate_hud", "- Reset", x + 60, y + 50, 1 );
	new_hud( "rotate_hud", "- Zero Out", x + 60, y + 60, 1 );
#/
}

new_hud( hud_name, msg, x, y, scale )
{
/#
	if( !IsDefined( level.hud_array ) )
	{
		level.hud_array = [];
	}

	if( !IsDefined( level.hud_array[hud_name] ) )
	{
		level.hud_array[hud_name] = [];
	}

	hud = set_hudelem( msg, x, y, scale );
	level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
	return hud;
#/
}

remove_hud( hud_name )
{
/#
	if( !IsDefined( level.hud_array[hud_name] ) )
	{
		return;
	}

	huds = level.hud_array[hud_name];
	for( i = 0; i < huds.size; i++ )
	{
		destroy_hud( huds[i] );
	}

	level.hud_array[hud_name] = undefined;
#/
}

destroy_hud( hud )
{
/#
	if( IsDefined( hud ) )
	{
		hud Destroy();
	}
#/
}

set_menus_pos_by_num( hud_array, num, x, y, space, min_alpha, num_of_fades )
{
/#
	if( !IsDefined( min_alpha ) )
	{
		min_alpha = 0.1;
	}

	if( !IsDefined( num_of_fades ) )
	{
		num_of_fades = 3;
	}

	for( i = 0; i < hud_array.size; i++ )
	{
		temp = i - num;
		hud_array[i].y = y + ( temp * space );

		if( temp < 0 )
		{
			temp = temp * -1;
		}
		
		alpha = 1 / ( temp + 1 );

		if( alpha < ( 1 / num_of_fades ) )
		{
			alpha = min_alpha;
		}

		hud_array[i].alpha = alpha;		
	}
#/
}

move_menus( hud_array, x_shift, y_shift, num, min_alpha, num_of_fades )
{
/#
	if( !IsDefined( min_alpha ) )
	{
		min_alpha = 0.1;
	}

	if( !IsDefined( num_of_fades ) )
	{
		num_of_fades = 3;
	}

	time = 0.1;
	for( i = 0; i < hud_array.size; i++ )
	{
		if( !IsDefined( hud_array[i] ) )
		{
			continue;
		}

		hud_array[i] MoveOverTime( time );

		hud_array[i].x = hud_array[i].x + x_shift;
		hud_array[i].y = hud_array[i].y + y_shift;

		temp = i - num;
		if( temp < 0 )
		{
			temp = temp * -1;
		}
		
		alpha = 1 / ( temp + 1 );

		if( alpha < ( 1 / num_of_fades ) )
		{
			alpha = min_alpha;
		}

// MikeD (2/12/2008): FadeOvertime causes bugs.
		if( !IsDefined( hud_array[i].debug_hudelem ) )
		{
			hud_array[i] FadeOverTime( time );
		}
		hud_array[i].alpha = alpha;		
	}
#/
}

create_hud_list( list, x, y, space_apart, scale, alignX )
{
/#
	if( !IsDefined(	space_apart ) )
	{
		space_apart = 15;
	}

	if( !IsDefined( alignX ) )
	{
		alignX = "center";
	}

	hud_array = [];
	for( i = 0; i < list.size; i++ )
	{
		alpha = 1 / ( i + 1 );

		if( alpha < 0.3 )
		{
			alpha = 0.1;
		}

		hud = set_hudelem( list[i], x, y + ( i * space_apart ), scale, alpha );
		hud.alignX = alignX;
		hud_array = maps\_utility::array_add( hud_array, hud );
	}

	return hud_array;
#/
}

popup_box( x, y, width, height, time, color, alpha )
{
/#
	if( !IsDefined( alpha ) )
	{
		alpha = 0.5;
	}

	if( !IsDefined( color ) )
	{
		color = ( 0, 0, 0.5 );
	}

	if( IsDefined( level.player ) )
	{
		hud = NewClientHudElem( level.player );
	}
	else
	{
		hud = NewDebugHudElem();
		hud.debug_hudelem = true;
	}
	hud.alignX = "left";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.sort = 30;
	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.color = color;

	if( IsDefined( level.player ) )
	{
		hud.background = NewClientHudElem( level.player );
	}
	else
	{
		hud.background = NewDebugHudElem();
		hud.debug_hudelem = true;
	}
	hud.background.alignX = "left";
	hud.background.alignY = "middle";
	hud.background.foreground = 1;
	hud.background.sort = 25;
	hud.background.x = x + 2;
	hud.background.y = y + 2;
	hud.background.alpha = 0.75;
	hud.background.color = ( 0, 0, 0 );

	hud SetShader( "white", 0, 0 );
	hud ScaleOverTime( time, width, height );

	hud.background SetShader( "white", 0, 0 );
	hud.background ScaleOverTime( time, width, height );

	wait( time );

	return hud;
#/
}

destroy_popup()
{
/#
	self.background ScaleOverTime( 0.25, 0, 0 );
	self ScaleOverTime( 0.25, 0, 0 );

	wait( 0.1 );

	if( IsDefined( self.background ) )
	{
		self.background Destroy();
	}

	if( IsDefined( self ) )
	{
		self Destroy();
	}
#/
}

//------------//
// Dialog Box //
//------------//
dialog_text_box( dialog_msg, dialog_msg2, word_length )
{
/#
	bg1_shader_width = 300;
	bg1_shader_height = 100;

	x = 320;
	y = 100;

	hud = new_hud( "dialog_box", undefined, x - ( bg1_shader_width * 0.5 ), y, 1 );
	hud SetShader( "white", bg1_shader_width, bg1_shader_height );
	hud.alignY = "top";
	hud.color = ( 0, 0, 0.2 );
	hud.alpha = 0.85;
	hud.sort = 20;

	hud = new_hud( "dialog_box", dialog_msg, x - ( bg1_shader_width * 0.5 ) + 10, y + 10, 1.25 );
	hud.sort = 25;

	if( IsDefined( dialog_msg2 ) )
	{
		hud = new_hud( "dialog_box", dialog_msg2, x - ( bg1_shader_width * 0.5 ) + 10, y + 30, 1.1 );
		hud.sort = 25;
	}

	bg2_shader_width = bg1_shader_width - 20;
	bg2_shader_height = 20;
	y = 150;
	hud = new_hud( "dialog_box", undefined, x - ( bg2_shader_width * 0.5 ), y, 1 );
	hud SetShader( "white", bg2_shader_width, bg2_shader_height );
	hud.alignY = "top";
	hud.color = ( 0, 0, 0 );
	hud.alpha = 0.85;
	hud.sort = 30;
	cursor_x = x - ( bg2_shader_width * 0.5 ) + 2;
	cursor_y = y + 8;

	if( level.xenon )
	{
		hud = new_hud( "dialog_box", "Ok [A]", x - 50, y + 30, 1.25 );
		hud.alignX = "center";
		hud.sort = 25;
	
		hud = new_hud( "dialog_box", "Cancel [Y]", x + 50, y + 30, 1.25 );
		hud.alignX = "center";
		hud.sort = 25;
	}
	else
	{
		hud = new_hud( "dialog_box", "Ok [enter]", x - 50, y + 30, 1.25 );
		hud.alignX = "center";
		hud.sort = 25;
	
		hud = new_hud( "dialog_box", "Cancel [end]", x + 50, y + 30, 1.25 );
		hud.alignX = "center";
		hud.sort = 25;
	}

//	test_alphabet_space();

	result = dialog_text_box_input( cursor_x, cursor_y, word_length );
	remove_hud( "dialog_box" );

	return result;
#/
}

dialog_text_box_input( cursor_x, cursor_y, word_length )
{
/#
	level.dialog_box_cursor = new_hud( "dialog_box", "|", cursor_x, cursor_y, 1.25 );
	level.dialog_box_cursor.sort = 75;
	level thread dialog_text_box_cursor();

	dialog_text_box_buttons();

	hud_word = new_hud( "dialog_box", "", cursor_x, cursor_y, 1.25 );
	hud_word.sort = 75;

	hud_letters = [];
	word = "";
	while( 1 )
	{
		level waittill( "dialog_box_button_pressed", button );

		if( button == "end" || button == "button_y" )
		{
			word = "-1";
			break;
		}
		else if( button == "enter" || button == "kp_enter" || button == "button_a" )
		{
			break;
		}
		else if( button == "backspace" || button == "del" )
		{
			new_word = "";
			for( i = 0; i < word.size - 1; i++ )
			{
				new_word = new_word + word[i];
			}
			word = new_word;
		}
		else
		{
			if( word.size < word_length )
			{
				word = word + button;
			}
		}

		hud_word SetText( word );

		x = cursor_x;
		for( i = 0; i < word.size; i++ )
		{
			x += get_letter_space( word[i] );
		}

		level.dialog_box_cursor.x = x;

		wait( 0.05 );
	}

	level notify( "stop_dialog_text_box_cursor" );
	level notify( "stop_dialog_text_input" );

	return word;
#/
}

dialog_text_box_buttons()
{
/#
	clear_universal_buttons( "dialog_text_buttons" );

	mod_button = undefined;

	add_universal_button( "dialog_box", "_" );
	add_universal_button( "dialog_box", "0" );
	add_universal_button( "dialog_box", "1" );
	add_universal_button( "dialog_box", "2" );
	add_universal_button( "dialog_box", "3" );
	add_universal_button( "dialog_box", "4" );
	add_universal_button( "dialog_box", "5" );
	add_universal_button( "dialog_box", "6" );
	add_universal_button( "dialog_box", "7" );
	add_universal_button( "dialog_box", "8" );
	add_universal_button( "dialog_box", "9" );
	add_universal_button( "dialog_box", "a" );
	add_universal_button( "dialog_box", "b" );
	add_universal_button( "dialog_box", "c" );
	add_universal_button( "dialog_box", "d" );
	add_universal_button( "dialog_box", "e" );
	add_universal_button( "dialog_box", "f" );
	add_universal_button( "dialog_box", "g" );
	add_universal_button( "dialog_box", "h" );
	add_universal_button( "dialog_box", "i" );
	add_universal_button( "dialog_box", "j" );
	add_universal_button( "dialog_box", "k" );
	add_universal_button( "dialog_box", "l" );
	add_universal_button( "dialog_box", "m" );
	add_universal_button( "dialog_box", "n" );
	add_universal_button( "dialog_box", "o" );
	add_universal_button( "dialog_box", "p" );
	add_universal_button( "dialog_box", "q" );
	add_universal_button( "dialog_box", "r" );
	add_universal_button( "dialog_box", "s" );
	add_universal_button( "dialog_box", "t" );
	add_universal_button( "dialog_box", "u" );
	add_universal_button( "dialog_box", "v" );
	add_universal_button( "dialog_box", "w" );
	add_universal_button( "dialog_box", "x" );
	add_universal_button( "dialog_box", "y" );
	add_universal_button( "dialog_box", "z" );

	add_universal_button( "dialog_box", "enter" );
	add_universal_button( "dialog_box", "kp_enter" );
	add_universal_button( "dialog_box", "end" );
	add_universal_button( "dialog_box", "backspace" );
	add_universal_button( "dialog_box", "del" );

	if( level.xenon )
	{
		add_universal_button( "dialog_box", "button_a" );
		add_universal_button( "dialog_box", "button_y" );
	}

	level thread universal_input_loop( "dialog_box", "stop_dialog_text_input", undefined, mod_button );
#/
}

dialog_text_box_cursor()
{
/#
	level endon( "stop_dialog_text_box_cursor" );

	while( 1 )
	{
		level.dialog_box_cursor.alpha = 0;
		wait( 0.5 );
		level.dialog_box_cursor.alpha = 1;
		wait( 0.5 );
	}
#/
}

get_letter_space( letter )
{
/#
	if( letter == "m" || letter == "w" || letter == "_" )
	{
		space = 10;
	}
	else if( letter == "e" || letter == "h" || letter == "u" || letter == "v" || letter == "x" || letter == "o" )
	{
		space = 7;
	}
	else if( letter == "f" || letter == "r" || letter == "t" )
	{
		space = 5;
	}
	else if( letter == "i" || letter == "l" )
	{
		space = 4;
	}
	else if( letter == "j" )
	{
		space = 3;
	}
	else
	{
		space = 6;
	}

	return space;
#/
}

//test_alphabet_space()
//{
//	x = 20;
//	y = 300;
//
//	letters = [];
//	spaces = [];
//	letters[letters.size] = "0";
//	letters[letters.size] = "1";
//	letters[letters.size] = "2";
//	letters[letters.size] = "3";
//	letters[letters.size] = "4";
//	letters[letters.size] = "5";
//	letters[letters.size] = "6";
//	letters[letters.size] = "7";
//	letters[letters.size] = "9";
//	letters[letters.size] = "a";
//	letters[letters.size] = "b";
//	letters[letters.size] = "c";
//	letters[letters.size] = "d";
//	letters[letters.size] = "e";
//	letters[letters.size] = "f";
//	letters[letters.size] = "g";
//	letters[letters.size] = "h";
//	letters[letters.size] = "i";
//	letters[letters.size] = "j";
//	letters[letters.size] = "k";
//	letters[letters.size] = "l";
//	letters[letters.size] = "m";
//	letters[letters.size] = "n";
//	letters[letters.size] = "o";
//	letters[letters.size] = "p";
//	letters[letters.size] = "q";
//	letters[letters.size] = "r";
//	letters[letters.size] = "s";
//	letters[letters.size] = "t";
//	letters[letters.size] = "u";
//	letters[letters.size] = "v";
//	letters[letters.size] = "w";
//	letters[letters.size] = "x";
//	letters[letters.size] = "y";
//	letters[letters.size] = "z";
//
//	for( i = 0; i < letters.size; i++ )
//	{
//		hud = new_hud( "dialog_box", letters[i], x, y, 1.25 );
//
//		if( letters[i] == "m" || letters[i] == "w" )
//		{
//			x += 10;
//		}
//		else if( letters[i] == "e" || letters[i] == "h" || letters[i] == "u" || letters[i] == "v" || letters[i] == "x" )
//		{
//			x += 7;
//		}
//		else if( letters[i] == "f" || letters[i] == "r" || letters[i] == "t" )
//		{
//			x += 5;
//		}
//		else if( letters[i] == "i" || letters[i] == "l" )
//		{
//			x += 4;
//		}
//		else if( letters[i] == "j" )
//		{
//			x += 3;
//		}
//		else
//		{
//			x += 6;
//		}
//	}
//}

//-----------------//
// Universal Input //
//-----------------//
add_universal_button( button_group, name )
{
/#
	if( !IsDefined( level.u_buttons[button_group] ) )
	{
		level.u_buttons[button_group] = [];
	}

	if( array_check_for_dupes( level.u_buttons[button_group], name ) )
	{
		level.u_buttons[button_group][level.u_buttons[button_group].size] = name;
	}	
#/
}

clear_universal_buttons( button_group )
{
/#
	level.u_buttons[button_group] = [];
#/
}

universal_input_loop( button_group, end_on, use_attackbutton, mod_button, no_mod_button )
{
/#
	level endon( end_on );

	if( !IsDefined( use_attackbutton ) )
	{
		use_attackbutton = false;
	}

	notify_name = button_group + "_button_pressed";
	buttons = level.u_buttons[button_group];
	level.u_buttons_disable[button_group] = false;

	while( 1 )
	{
		if( level.u_buttons_disable[button_group] )
		{
			wait( 0.05 );
			continue;
		}

		if( IsDefined( mod_button ) && !level.player ButtonPressed( mod_button ) )
		{
			wait( 0.05 );
			continue;
		}
		else if( IsDefined( no_mod_button ) && level.player ButtonPressed( no_mod_button ) )
		{
			wait( 0.05 );
			continue;
		}


		if( use_attackbutton && level.player AttackButtonPressed() )
		{
			level notify( notify_name, "fire" );
			wait( 0.1 );
			continue;
		}

		for( i = 0; i < buttons.size; i++ )
		{
			if( level.player ButtonPressed( buttons[i] ) )
			{
				level notify( notify_name, buttons[i] );
				wait( 0.1 );
				break;
			}
		}

		wait( 0.05 );
	}
#/
}

disable_buttons( button_group )
{
/#
	level.u_buttons_disable[button_group] = true;
#/
}

enable_buttons( button_group )
{
/#
	wait( 1 );
	level.u_buttons_disable[button_group] = false;
#/
}

any_button_hit( button_hit, type  )
{
/#
	buttons = [];
	if( type == "numbers" )
	{
		buttons[0] = "0";
		buttons[1] = "1";
		buttons[2] = "2";
		buttons[3] = "3";
		buttons[4] = "4";
		buttons[5] = "5";
		buttons[6] = "6";
		buttons[7] = "7";
		buttons[8] = "8";
		buttons[9] = "9";
	}
	else
	{
		buttons = level.buttons;
	}

	for( i = 0; i < buttons.size; i++ )
	{
		if( button_hit == buttons[i] )
		{
			return true;
		}
	}

	return false;
#/
}