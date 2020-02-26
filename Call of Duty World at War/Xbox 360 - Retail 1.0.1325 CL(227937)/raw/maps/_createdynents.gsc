#include common_scripts\utility;
#include maps\_utility;

main()
{
	if( GetDvar( "propman" ) != "1" )
	{
		return;
	}

	if( !IsDefined( level.xenon ) )
	{
		level.xenon = ( GetDvar( "xenonGame" ) == "true" );
	}

	if( !IsDefined( level.script ) )
	{
		level.script = ToLower( GetDvar( "mapname" ) );	
	}

	// SCRIPTER_MOD
	// JesseS (3/20/2007): going to assume this is a debug script and only player one can
	// do stuff in here, players[0] assigned to be player1
	//if( !IsDefined( level.debug_player ) )
	//{
		players = get_players();
		level.debug_player = players[0];
	//}

	PrecacheShader( "white" );

	// Player does not need any weapons.
	level.debug_player TakeAllWeapons();

	// Setup the default save path/files
	level set_default_path();

	// Display the cursor, copied from _createfx
	level set_crosshair();

	// Load the models into arrays so they can be accessed.
	level setup_models();

	// Setup and enable the menu system.
	level setup_menus();

	// Setup the buttons that will be used in the menu system.
	level setup_menu_buttons();

	// Capture button input.
	level thread menu_input();
}

set_crosshair()
{
	// setup "crosshair"
	crossHair = newHudElem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "middle";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 1;
	crossHair.x = 320;
	crossHair.y = 233;
	crossHair setText(".");
}

//--------------//
// Setup Models //
//--------------//
setup_models()
{
	dyn_ents = GetEntArray( "script_model", "classname" );

	if( dyn_ents.size == 0 )
	{
		level thread model_error( "Cannot find any dyn_ent models to use for \"Dyn_Ents Mode\"", 300 );
	}

	for( i = 0; i < dyn_ents.size; i++ )
	{
		if( IsDefined( dyn_ents[i].targetname ) )
		{
			dyn_ents[i].og_origin = dyn_ents[i].origin;
			add_to_dyn_ent_group( dyn_ents[i].targetname );
		}

		dyn_ents[i] add_dyn_ent_model();
	}

	// For Props
	models = GetEntArray( "script_model", "classname" );

	if( models.size == 0 )
	{
		level thread model_error( "Cannot find any script_models to use for \"Misc Model Mode\"", 320 );
	}

	for( i = 0; i < models.size; i++ )
	{
		models[i] add_script_modelnames();
	}
}

model_error( msg, y )
{
	hud = set_hudelem( msg, 320, y, 2 );
	hud.alignX = "center";
	hud.color = ( 1, 0, 0 );

	wait( 10 );

	hud FadeOverTime( 3 );
	hud.alpha = 0;

	wait( 10 );
	hud Destroy();
}

// Stores the name of the group into an array.
add_to_dyn_ent_group( dyn_ent_name )
{
	if( !IsDefined( level.dyn_ent_groups ) )
	{
		level.dyn_ent_groups = [];
	}

	if( !check_for_dupes( level.dyn_ent_groups, dyn_ent_name ) )
	{
		return;
	}

	level.dyn_ent_groups[level.dyn_ent_groups.size] = dyn_ent_name;
}

// Stores entity into the "all_objects" array
add_to_all_objects()
{
	if( !IsDefined( level.all_objects ) )
	{
		level.all_objects = [];
	}

	if( !check_for_dupes( level.all_objects, self ) )
	{
		return;
	}

	level.all_objects[level.all_objects.size] = self;
}

remove_from_all_objects()
{
	if( !IsDefined( level.all_objects ) || level.all_objects.size < 1 )
	{	
		return;
	}

	level.all_objects = maps\_utility::array_remove( level.all_objects, self );	
}

// Stores the model name into an array.
add_dyn_ent_model()
{
	if( !IsDefined( level.dyn_ent_modelnames ) )
	{
		level.dyn_ent_modelnames = [];
	}

	self add_to_all_objects();

	if( !check_for_dupes( level.dyn_ent_modelnames, self.model ) )
	{
		return;
	}

	level.dyn_ent_modelnames[level.dyn_ent_modelnames.size] = self.model;
}

// Stores the model name into an array.
add_script_modelnames()
{
	if( !IsDefined( level.script_modelnames ) )
	{
		level.script_modelnames = [];
	}

	if( !check_for_dupes( level.script_modelnames, self.model ) )
	{
		return;
	}

	self.is_misc_model = true;
	level.script_modelnames[level.script_modelnames.size] = self.model;
}

// Stores the model into the array.
add_misc_model()
{
	if( !IsDefined( level.misc_models ) )
	{
		level.misc_models = [];
	}

	if( !check_for_dupes( level.misc_models, self ) )
	{
		return;
	}

	self.is_misc_model = true;
	level.misc_models[level.misc_models.size] = self;
}

remove_misc_model()
{
	if( !IsDefined( level.misc_models ) || level.misc_models.size < 1 )
	{
		return;
	}

	level.misc_models = maps\_utility::array_remove( level.misc_models, self );	
}

// Checks the array if the "single" already exists, if so it returns false.
check_for_dupes( array, single )
{
	for( i = 0; i < array.size; i++ )
	{
		if( array[i] == single )
		{
			return false;
		}
	}

	return true;
}

//--------------//
// Menu Section //
//--------------//

// Sets up the menus
setup_menus()
{
	level.menu_sys = [];
	level.menu_sys["current_menu"] = SpawnStruct();

	// Root Menu
	add_menu( "choose_mode", "Choose Mode:" );
		add_menuoptions( "choose_mode", "Dyn_Ent Mode" );
		add_menuoptions( "choose_mode", "Misc Model Mode" );

		add_menu_child( "choose_mode", "dyn_ent_mode", "Dyn_Ent Mode:", undefined );
			add_menuoptions( "dyn_ent_mode", "Shooter Mode" );
				// Shooter Mode
				add_menu_child( "dyn_ent_mode", "shooter_mode", "Dyn_Ent->Shooter Mode:", undefined, ::shooter_mode );
					add_menuoptions( "shooter_mode", "Spawn Model", ::spawn_dyn_model );
					add_menuoptions( "shooter_mode", "Drop Selected", ::drop_model );
					add_menuoptions( "shooter_mode", "Shoot Selected", ::shoot_model );
					add_menuoptions( "shooter_mode", "Spray Selected", ::spray_model );
					add_menuoptions( "shooter_mode", "Reset Selected", ::undo_shooter_mode );
					add_menuoptions( "shooter_mode", "Save" );
					// Save Menu
					add_menu_child( "shooter_mode", "save_menu", "Dyn_Ent->Save:", 5 );
						add_menuoptions( "save_menu", "Save All", ::save_all_dyn_ents );
//						add_menuoptions( "save_menu", "Save All As...", ::save_all_as_shooter_models );

			add_menuoptions( "dyn_ent_mode", "Group Mode" );
				// Group Mode
				add_menu_child( "dyn_ent_mode", "group_mode", "Dyn_Ent->Group Mode:", undefined, ::group_mode );
					add_menuoptions( "group_mode", "Select Group", ::select_group );
					add_menuoptions( "group_mode", "Plant Bomb", ::group_plant_bomb );
					add_menuoptions( "group_mode", "Reset Group", ::reset_group );
					add_menuoptions( "group_mode", "Save" );
					// Save Menu
					add_menu_child( "group_mode", "group_save_menu", "Dyn_Ent->Group Save:", 3 );
						add_menuoptions( "group_save_menu", "Save Selected Group", ::save_selected_group );
		//				add_menuoptions( "save_menu", "Save All As...", ::save_all_as_shooter_models );

			add_menuoptions( "dyn_ent_mode", "Select Mode" );
				// Select Mode
				add_menu_child( "dyn_ent_mode", "select_mode", "Dyn_Ent->Select:", undefined, ::select_mode );
					add_menuoptions( "select_mode", "Grab", ::select_grab );
					add_menuoptions( "select_mode", "Copy", ::select_copy );
					add_menuoptions( "select_mode", "Hop", ::select_hop );
					add_menuoptions( "select_mode", "Save" );
						// Grab Menu
						add_menu_child( "select_mode", "select_grab_menu", "Dyn_Ent->Grab:" );
						set_no_back_menu( "select_grab_menu" );
							add_menuoptions( "select_grab_menu", "Drop", ::selected_drop );
							add_menuoptions( "select_grab_menu", "Shoot", ::selected_shoot );
							add_menuoptions( "select_grab_menu", "Reset", ::selected_reset );
							add_menuoptions( "select_grab_menu", "Delete", ::selected_delete );
							add_menuoptions( "select_grab_menu", "Back", ::selected_back );
			
						// Copy Menu
						add_menu_child( "select_mode", "select_copy_menu", "Dyn_Ent->Copy:" );
						set_no_back_menu( "select_copy_menu" );
							add_menuoptions( "select_copy_menu", "Drop", ::selected_drop );
							add_menuoptions( "select_copy_menu", "Shoot", ::selected_shoot );
							add_menuoptions( "select_copy_menu", "Delete", ::selected_delete );
							add_menuoptions( "select_copy_menu", "Back", ::selected_back );

						add_menu_child( "select_mode", "select_save_menu", "Dyn_Ent->Save Selected:", 3, ::selected_save );
							add_menuoptions( "select_save_menu", "Highlight", ::selected_save_highlight );
							add_menuoptions( "select_save_menu", "Save Selected", ::save_dyn_ent_highlighted );

		// Prop Mode
		add_menu_child( "choose_mode", "prop_mode_menu", "Misc_Model Mode:", undefined, ::prop_mode );
				add_menuoptions( "prop_mode_menu", "Spawn Model", ::spawn_prop );
				add_menuoptions( "prop_mode_menu", "Place Model", ::place_prop );
				add_menuoptions( "prop_mode_menu", "Place Copy", ::place_prop_copy );
				add_menuoptions( "prop_mode_menu", "Select Mode" );
				add_menuoptions( "prop_mode_menu", "Rotate Mode" );
				add_menuoptions( "prop_mode_menu", "Save All", ::save_all_misc_models );

				// Select Mode
				add_menu_child( "prop_mode_menu", "select_prop_mode", "Misc_Model->Select Mode:", 3, ::select_prop_mode );
					add_menuoptions( "select_prop_mode", "Move" );
					add_menuoptions( "select_prop_mode", "Copy" );
					add_menuoptions( "select_prop_mode", "Save" );
//						// Move Menu
						add_menu_child( "select_prop_mode", "move_prop_menu", "Misc_Model->Move Selected:", undefined, ::prop_move );
						set_no_back_menu( "move_prop_menu" );
							add_menuoptions( "move_prop_menu", "Place Model", ::place_prop );
							add_menuoptions( "move_prop_menu", "Copy Model", ::place_prop_copy );
							add_menuoptions( "move_prop_menu", "Back", ::selected_back );
			
						// Copy Menu
						add_menu_child( "select_prop_mode", "copy_prop_menu", "Misc_Model->Copy Selected:", undefined, ::prop_copy );
						set_no_back_menu( "copy_prop_menu" );
							add_menuoptions( "copy_prop_menu", "Place Model", ::place_prop );
							add_menuoptions( "copy_prop_menu", "Place Copy", ::place_prop_copy );
							add_menuoptions( "copy_prop_menu", "Back", ::selected_back );

						add_menu_child( "select_prop_mode", "misc_model_select_save_menu", "Misc_Model->Save Selected:", 2, ::selected_misc_model_save );
							add_menuoptions( "misc_model_select_save_menu", "Highlight", ::selected_save_highlight );
							add_menuoptions( "misc_model_select_save_menu", "Save Selected", ::save_misc_model_highlighted );

				// Rotate Mode
				add_menu_child( "prop_mode_menu", "rotate_prop_mode", "Misc_Model->Rotate Mode:", 4, ::rotate_prop_mode );
					add_menuoptions( "rotate_prop_mode", "Highlight", ::selected_rotate_highlight );

	enable_menu( "choose_mode" );
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
	if( IsDefined( level.menu_sys[menu_name] ) )
	{
		println( "^1level.menu_sys[" + menu_name + "] already exists, change the menu_name" );
		return;
	}

	level.menu_sys[menu_name] = SpawnStruct();
	level.menu_sys[menu_name].title = "none";

	level.menu_sys[menu_name].title = title;
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
}

set_no_back_menu( menu_name )
{
	level.menu_sys[menu_name].no_back = true;
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
set_hudelem( text, x, y, scale, alpha )
{
	if( !IsDefined( alpha ) )
	{
		alpha = 1;
	}

	if( !IsDefined( scale ) )
	{
		scale = 1;
	}

	hud = NewHudElem();
	hud.location = 0;
	hud.alignX = "left";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.fontScale = scale;
	hud.sort = 20;
	hud.alpha = alpha;
	hud.x = x;
	hud.y = y;
	hud.og_scale = scale;

	if( IsDefined( text ) )
	{
		hud SetText( text );
	}

	return hud;
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
			wait( 0.1 );
			continue;
		}
		else if( keystring == "button_a" || keystring == "enter" )
		{
			key = level.menu_cursor.current_pos;
		}
//		else if( key == "backspace" ) // 360 must use the back menu selection.
//		{
//			if( IsDefined( level.menu_sys[menu_name].no_back ) && level.menu_sys[menu_name].no_back )
//			{
//				key = level.menu_sys[menu_name].options.size - 1;
//			}
//			else
//			{
//				key = level.menu_sys[menu_name].options.size;
//			}
//		}
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
//		else
//		{
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
//		}

		wait( 0.1 );
	}
}

force_menu_back()
{
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
list_menu( list, x, y, scale, func )
{
	hud_array = [];
	space_apart = 15;
	for( i = 0; i < list.size; i++ )
	{
		alpha = 1 / ( i + 1 );

		if( alpha < 0.3 )
		{
			alpha = 0.1;
		}

		hud = set_hudelem( list[i], x, y + ( i * space_apart ), scale, alpha );
		hud_array = maps\_utility::array_add( hud_array, hud );
	}

	current_num = 0;
	old_num = 0;
	selected = false;

	[[func]]( list[current_num] );
	while( true )
	{
		level waittill( "menu_button_pressed", key );

		if( any_button_hit( key, "numbers" ) )
		{
			break;
		}
		else if( key == "downarrow" || key == "dpad_down" )
		{
			if( current_num >= hud_array.size - 1 )
			{
				continue;
			}

			current_num++;
			move_list_menu( hud_array, "down", space_apart, current_num );
		}
		else if( key == "uparrow" || key == "dpad_up" )
		{
			if( current_num <= 0 )
			{
				continue;
			}

			current_num--;
			move_list_menu( hud_array, "up", space_apart, current_num );			
		}
		else if( key == "enter" || key == "button_a" )
		{
			selected = true;
			break;
		}

		level notify( "scroll_list" ); // Only used for special functions

		if( current_num != old_num )
		{
			old_num = current_num;
			[[func]]( list[current_num] );
		}
	}

	for( i = 0; i < hud_array.size; i++ )
	{
		hud_array[i] Destroy();
	}

	if( selected )
	{
		return current_num;
	}
}

//------------------------------------------------------------------//
// move_list_menu( hud_array, dir, space, num )						//
//		Scrolls the list menu up/down								//
//------------------------------------------------------------------//
// self			- n/a												//
// hud_array	- Array of text that is listed						//
// dir			- Direction to scroll the list, "up" or "down"		//
// space		- How much space to move the text					//
// num			- Gives the current list number, so it can fade		//
//				properly											//
//------------------------------------------------------------------//
move_list_menu( hud_array, dir, space, num )
{
	time = 0.1;
	if( dir == "up" )
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
		hud_array[i].y = hud_array[i].y + movement;

		temp = i - num;
		if( temp < 0 )
		{
			temp = temp * -1;
		}
		
		alpha = 1 / ( temp + 1 );

		if( alpha < 0.3 )
		{
			alpha = 0.1;
		}

		hud_array[i] FadeOverTime( time );
		hud_array[i].alpha = alpha;		
	}
}

hud_selector( x, y )
{
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
}

hud_selector_fade_out( time )
{
	if( !IsDefined( time ) )
	{
		time = 0.25;
	}

	level.menu_cursor.alpha = 0.5;

	hud = level.hud_selector;
	level.hud_selector = undefined;

	hud FadeOverTime( time );
	hud.alpha = 0;
	wait( time + 0.1 );
	hud Destroy();
}

selection_error( msg, x, y )
{
	hud = set_hudelem( undefined, x - 10, y, 1 );
	hud SetShader( "white", 110, 20 );
	hud.color = ( 0.5, 0, 0 );
	hud.alpha = 0.7;

	error_hud = set_hudelem( msg, x + 110, y, 1 );
	error_hud.color = ( 1, 0, 0 );

	hud FadeOverTime( 3 );
	hud.alpha = 0;

	error_hud FadeOverTime( 3 );
	error_hud.alpha = 0;

	wait( 3.1 );
	hud Destroy();
	error_hud Destroy();
}


hud_font_scaler( mult )
{
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
}

draw_model_axis()
{
	range = 16;
	forward = AnglesToForward( self.angles );
	forward = VectorScale( forward, range );
	right = AnglesToRight( self.angles );
	right = VectorScale( right, range );
	up = AnglesToUp( self.angles );
	up = VectorScale( up, range );
	Line( self.origin, self.origin + forward, ( 0, 1, 0 ), 1 );
	Line( self.origin, self.origin + up, ( 0, 0, 1 ), 1 );
	Line( self.origin, self.origin + right, ( 1, 0, 0 ), 1 );
}

rotate_model()
{
	self endon( "stop_move_selected_object" );
	self endon( "unlink_selected_object" );
	self endon( "death" );

	rate = 2;

	while( 1 )
	{
		level waittill( "menu_button_pressed", key );
		if( key == "kp_rightarrow" )
		{
			self DevAddYaw( rate );
		}
		else if( key == "kp_leftarrow" )
		{
			self DevAddYaw( rate * -1 );
		}
		else if( key == "kp_uparrow" )
		{
			self DevAddPitch( rate * -1 );
		}
		else if( key == "kp_downarrow" )
		{
			self DevAddPitch( rate );
		}
		else if( key == "kp_home" )
		{
			self DevAddRoll( rate * -1 );
		}
		else if( key == "kp_pgup" )
		{
			self DevAddRoll( rate );
		}
		wait( 0.01 );
	}
}

enable_rotate_hud()
{
	if( IsDefined( level.hud_array ) && IsDefined( level.hud_array["rotate_hud"] ) )
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

	y += 3;

	if( level.xenon )
	{
		new_hud( "rotate_hud", "Y/A", x + 5, y + 20, 1 );
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
}

disable_rotate_hud()
{
	remove_hud( "rotate_hud" );
}

//--------------//
// Shooter Mode //
//--------------//
shooter_mode()
{
	level thread shooter_mode_thread();
}

shooter_mode_thread()
{
	enable_rotate_hud();

	level waittill( "disable shooter_mode" );
	level notify( "stop_shooter_mode" );

	disable_rotate_hud();
	
	selected_delete();
}

spawn_dyn_model()
{
	y = level.menu_sys["current_menu"].options[0].y;

	if( !IsDefined( level.dyn_ent_modelnames ) )
	{
		return;
	}

	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	list_menu( level.dyn_ent_modelnames, 180, y, 1.3, ::spawn_selected_object );

	arrow_hud Destroy();
}

spawn_selected_object( model_name, with_trace )
{
	if( IsDefined( level.selected_object ) )
	{
		level.selected_object Delete();
	}

	if( !IsDefined( level.selected_object_dist ) )
	{
		level.selected_object_dist = 48;
	}
	level thread selected_object_dist();

	forward = AnglesToforward( level.debug_player GetPlayerAngles() );
	vector = level.debug_player GetEye() + VectorScale( forward, level.selected_object_dist );
	level.selected_object = Spawn( "script_model", vector );
	level.selected_object SetModel( model_name );

//	level.selected_object LinkTo( level.debug_player );
	level.selected_object thread move_selected_object( with_trace );
}

selected_object_dist()
{
	level notify( "stop_selected_object_dist" );
	level endon( "stop_selected_object_dist" );

	while( 1 )
	{
		level waittill( "menu_button_pressed", key );
		if( key == "-" )
		{
			level.selected_object_dist -= 8;
			if( level.selected_object_dist < 24 )
			{
				level.selected_object_dist = 24;
			}
			wait( 0.1 );
		}
		else if( key == "=" )
		{
			level.selected_object_dist += 8;
			if( level.selected_object_dist > 512 )
			{
				level.selected_object_dist = 512;
			}
			wait( 0.1 );
		}
	}
}

move_selected_object( with_trace )
{
	self notify( "stop_move_selected_object" );
	self endon( "stop_move_selected_object" );
	self endon( "unlink_selected_object" );
	self endon( "death" );

	if( !IsDefined( with_trace ) )
	{
		with_trace = false;
	}

//	self thread model_info_update();
	self thread rotate_model();

	while( true )
	{
		forward = AnglesToforward( level.debug_player GetPlayerAngles() );

		if( with_trace )
		{
			vector = level.debug_player GetEye() + VectorScale( forward, 5000 );
			trace = BulletTrace( level.debug_player GetEye(), vector, false, self );

			if( trace["fraction"] == 1 )
			{
				wait( 0.1 );
				continue;
			}
			else
			{
				vector = trace["position"];
			}

			// Since with_trace is only for misc_model mode, we can add an origin offset.
			vector = vector + ( 0, 0, level.misc_model_z_offset );
		}
		else
		{
			vector = level.debug_player GetEye() + VectorScale( forward, level.selected_object_dist );
		}

		if( vector != self.origin )
		{
			self MoveTo( vector, 0.1 );
			self waittill( "movedone" );
//			wait( 0.1 );
//			waittillframeend;
		}
		else
		{
			wait( 0.05 );
		}
	}
}

drop_model( selected )
{
	if( !selected_object_check() )
	{
		return "ERROR: MODEL NOT SELECTED!";
	}

	level.selected_object notify( "unlink_selected_object" );
	level.selected_object MoveGravity( ( 0, 0, 0 ), 1 );


	level.selected_object store_shooter_model();
	level.undo_shooter_model = level.selected_object;
	level.selected_object = undefined;
}

shoot_model()
{
	level endon( "stop_shooter_mode" );

	if( !selected_object_check() )
	{
		return "ERROR: MODEL NOT SELECTED!";
	}

	shoot_model_hud();

	current_power_hud = set_hudelem( "Current Power:", 215, 422, 1.2 );
	current_power_value = set_hudelem( "0", 300, 422, 1.2 );

	level.shooter_max_power = 1000;
	level thread shoot_model_think( current_power_value );

	max_power_hud = set_hudelem( "Max Power:", 215, 435, 1.2 );
	max_power_value = set_hudelem( level.shooter_max_power, 300, 435, 1.2 );
	
	wait( 0.2 );
	while( 1 )
	{
		level waittill( "menu_button_pressed", key );
		if( any_button_hit( key, "numbers" ) )
		{
			break;
		}
		else if( key == "downarrow" || key == "dpad_down" )
		{
			level.shooter_max_power -= 50;
			if( level.shooter_max_power < 50 )
			{
				level.shooter_max_power = 50;
			}
			max_power_value SetText( level.shooter_max_power );
			max_power_value thread hud_font_scaler();
		}
		else if( key == "uparrow" || key == "dpad_up" )
		{
			level.shooter_max_power += 50;
			if( level.shooter_max_power > 5000 )
			{
				level.shooter_max_power = 5000;
			}
			max_power_value SetText( level.shooter_max_power );
			max_power_value thread hud_font_scaler();
		}
		else if( key == "button_b" || key == "end" )
		{
			break;
		}

		wait( 0.05 );
	}

	level notify( "stop_shoot_model_think" );
	level notify( "stop_attackbutton_hold_think" );

	max_power_hud Destroy();
	max_power_value Destroy();

	current_power_hud Destroy();
	current_power_value Destroy();

	if( IsDefined( level.shoot_model_background ) )
	{
		level.shoot_model_background Destroy();
	}

	if( IsDefined( level.shoot_model_power_bar ) )
	{
		level.shoot_model_power_bar Destroy();
	}

	remove_hud( "shoot_model_hud" );
}

shoot_model_hud()
{
	x = 0;
	y = 400;
	hud = new_hud( "shoot_model_hud", undefined, x, y, 1 );
	hud SetShader( "white", 170, 35 );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	if( level.xenon )
	{
		new_hud( "shoot_model_hud", "FIRE", x + 5, y + 10, 1 );
		new_hud( "shoot_model_hud", "UP/DOWN", x + 5, y + 20, 1 );
		new_hud( "shoot_model_hud", "B", x + 5, y + 30, 1 );
	}
	else
	{	
		new_hud( "shoot_model_hud", "FIRE", x + 5, y + 10, 1 );
		new_hud( "shoot_model_hud", "UP/DOWN", x + 5, y + 20, 1 );
		new_hud( "shoot_model_hud", "END", x + 5, y + 30, 1 );
	}

	new_hud( "shoot_model_hud", "- Shoot Object", x + 60, y + 10, 1 );
	new_hud( "shoot_model_hud", "- Adjust Max Power", x + 60, y + 20, 1 );
	new_hud( "shoot_model_hud", "- Quit", x + 60, y + 30, 1 );
}

shoot_model_think( current_power_value )
{
	level endon( "stop_shoot_model_think" );
	// Figure out power to throw.
	level thread attackbutton_hold_think();

	level.shoot_model_background = set_hudelem( undefined, 215, 400, 1 );
	level.shoot_model_background SetShader( "white", 210, 30 );
	level.shoot_model_background.color = ( 0.2, 0.2, 0.5 );
	level.shoot_model_background.alpha = 0.5;

	level waittill( "attack_button_held" );

	level.shoot_model_power_bar = set_hudelem( undefined, 220, 400, 1 );
	level.shoot_model_power_bar.sort = 50;
	power = power_bar_scaler( level.shoot_model_power_bar, current_power_value );
	
	level.selected_object notify( "unlink_selected_object" );
	forward = AnglesToforward( level.debug_player GetPlayerAngles() );

	velocity = VectorScale( forward, level.shooter_max_power * power );
	level.selected_object MoveGravity( velocity, 1 );

	level.selected_object store_shooter_model();
	level.undo_shooter_model = level.selected_object;
	level.selected_object = undefined;

	wait( 1 );
	level notify( "button_pressed", "1" ); // Forces it to go back.
}

power_bar_scaler( hud, current_power_value )
{
	max = 200;
//	min = 0;
	current = 0;
	increase = true;
	increment = 0.02;

	segments = 10;
	time = 1.0;
	time_inc = time / segments;
	og_time_inc = time_inc;

	while( 1 )
	{
		wait( 0.05 );

		if( current + increment > 1 )
		{
			increase = false; 
		}
		else if( current - increment < 0 )
		{
			increase = true; 
		}

		if( increase )
		{
			current += increment;
		}
		else
		{
			current -= increment;
		}

		power = level.shooter_max_power * current;

// Draw the trajectory
		time_inc = og_time_inc;	
		forward = AnglesToForward( level.debug_player GetPlayerAngles() );		
		velocity = VectorScale( forward, power );
		sub_vel = VectorScale( velocity, time_inc );
		start_pos = level.selected_object.origin;
		gravity = GetDvarInt( "g_gravity" );
		for( i = 1; i < segments + 1; i++ )
		{
			pos = start_pos + VectorScale( sub_vel, i );
			pos = pos - ( 0, 0, ( 0.5 * gravity * ( time_inc * time_inc ) ) );
			print3d( pos, ".", ( 1, 1, 0 ) );
			time_inc += og_time_inc;
		}
// End Drawing trajectory

		current_power_value SetText( power );
		hud SetShader( "white", int( current * max ), 20 );
		hud.alpha = 0.7;

		if( !level.attack_button_held )
		{
			level thread display_final_shooting_trajectory( og_time_inc, segments, power );
			return current;
		}
	}
}

display_final_shooting_trajectory( time_inc, segments, power )
{
	og_time_inc = time_inc;

	forward = AnglesToForward( level.debug_player GetPlayerAngles() );		
	velocity = VectorScale( forward, power );
	sub_vel = VectorScale( velocity, time_inc );
	start_pos = level.selected_object.origin;
	gravity = GetDvarInt( "g_gravity" );
	old_pos = start_pos;
	pos_array = [];
	for( i = 1; i < segments + 1; i++ )
	{
		pos = start_pos + VectorScale( sub_vel, i );
		pos_array[pos_array.size] = pos - ( 0, 0, ( 0.5 * gravity * ( time_inc * time_inc ) ) );
//		print3d( pos, ".", ( 1, 1, 0 ), 1 );
		time_inc += og_time_inc;
	}

	timer = GetTime() + 3000;
	while( GetTime() < timer )
	{
		for( i = 0; i < pos_array.size; i++ )
		{
			print3d( pos_array[i], ".", ( 0, 1, 0 ) );
		}
		wait( 0.05 );
	}
}

selected_object_check()
{
	if( !IsDefined( level.selected_object ) )
	{
		return false;	
	}
	return true;
}

undo_shooter_mode()
{
	if( !IsDefined( level.undo_shooter_model ) )
	{
		return "ERROR: MODEL NOT FOUND!";
	}

	if( IsDefined( level.selected_object ) )
	{
		level.selected_object Delete();
	}

	level.undo_shooter_model remove_shooter_model();
	level.selected_object = level.undo_shooter_model;
	level.undo_shooter_model = undefined;

	level.selected_object thread move_selected_object();
}

spray_model()
{
	if( !IsDefined( level.selected_object ) )
	{
		return "ERROR: Model is not Selected!";
	}

	level.spray = [];

	level.spray["model"] = level.selected_object.model;
	level.selected_object Delete();

	level.spray["rate"] = 0.25;
	level.spray["power"] = 1000;

	spray_buttons();
	spray_hud();

	level thread spray_trajectory();

	while( 1 )
	{
		level waittill( "spray_button_pressed", key );

		if( key == "fire" ) // Plant the bomb at this location
		{
			do_spray_model();
			
			wait( level.spray["rate"] - 0.1 ); // - 0.1 cause the button delay is that long.
		}
		else if( key == "uparrow" || key == "dpad_up" )
		{
			level.spray["power"] += 50;

			if( level.spray["power"] > 5000 )
			{
				level.spray["power"] = 5000;
			}

			level.spray_hud["power"] SetText( level.spray["power"] );
			level.spray_hud["power"] thread hud_font_scaler();
			wait( 0.05 );
		}
		else if( key == "downarrow" || key == "dpad_down" )
		{
			level.spray["power"] -= 50;

			if( level.spray["power"] < 50 )
			{
				level.spray["power"] = 50;
			}

			level.spray_hud["power"] SetText( level.spray["power"] );
			level.spray_hud["power"] thread hud_font_scaler();
			wait( 0.05 );
		}
		else if( key == "leftarrow" || key == "dpad_left" )
		{
			level.spray["rate"] -= 0.05;

			if( level.spray["rate"] < 0.25 )
			{
				level.spray["rate"] = 0.25;
			}

			level.spray_hud["rate"] SetText( level.spray["rate"] );
			level.spray_hud["rate"] thread hud_font_scaler();
			wait( 0.05 );
		}
		else if( key == "rightarrow" || key == "dpad_right" )
		{
			level.spray["rate"] += 0.05;

			if( level.spray["rate"] > 1 )
			{
				level.spray["rate"] = 1;
			}

			level.spray_hud["rate"] SetText( level.spray["rate"] );
			level.spray_hud["rate"] thread hud_font_scaler();
			wait( 0.05 );
		}
		else if( key == "end" || key == "button_b" ) // Quit out of this.
		{
			break;
		}
	}

//	if( IsDefined( level.planted_bomb ) )
//	{
//		level.planted_bomb Delete();
//	}

	level notify( "stop_spray" );

	remove_hud( "spray_hud" );
}

do_spray_model()
{
	forward = AnglesToForward( level.debug_player GetPlayerAngles() );
	vector = level.debug_player GetEye() + VectorScale( forward, 48 );
	object = Spawn( "script_model", vector );
	object SetModel( level.spray["model"] );

	velocity = VectorScale( forward, level.spray["power"] );

	object MoveGravity( velocity, 1 );

	object store_shooter_model();
}

spray_trajectory()
{
	level endon( "stop_spray" );

	segments = 10;
	time = 1.0;
	time_inc = time / segments;
	og_time_inc = time_inc;

	while( 1 )
	{
		// Draw the trajectory
		time_inc = og_time_inc;	
		forward = AnglesToForward( level.debug_player GetPlayerAngles() );
		velocity = VectorScale( forward, level.spray["power"] );
		sub_vel = VectorScale( velocity, time_inc );
		start_pos = level.debug_player GetEye() + VectorScale( forward, 48 );;
		gravity = GetDvarInt( "g_gravity" );
		for( i = 1; i < segments + 1; i++ )
		{
			pos = start_pos + VectorScale( sub_vel, i );
			pos = pos - ( 0, 0, ( 0.5 * gravity * ( time_inc * time_inc ) ) );
			print3d( pos, ".", ( 1, 1, 0 ) );
			time_inc += og_time_inc;
		}
		// End Drawing trajectory
		wait( 0.05 );
	}
}

spray_hud()
{
	level.spray_hud = [];

	x = 0;
	y = 400;
	hud = new_hud( "spray_hud", undefined, x, y, 1 );
	hud SetShader( "white", 145, 58 );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	// Spray Stats
	hud = new_hud( "spray_hud", "Model:", 319, 385, 1.2 );
	hud.alignX = "right";
	level.spray_hud["model"] = new_hud( "spray_hud", level.spray["model"], 321, 385, 1.2 );
	level.spray_hud["model"].alignX = "left";

	hud = new_hud( "spray_hud", "Rate:", 319, 400, 1.2 );
	hud.alignX = "right";
	level.spray_hud["rate"] = new_hud( "spray_hud", level.spray["rate"], 321, 400, 1.2 );
	level.spray_hud["rate"].alignX = "left";

	hud = new_hud( "spray_hud", "Power:", 319, 415, 1.2 );
	hud.alignX = "right";
	level.spray_hud["power"] = new_hud( "spray_hud", level.spray["power"], 321, 415, 1.2 );
	level.spray_hud["power"].alignX = "left";

	if( level.xenon )
	{
		new_hud( "spray_hud", "FIRE", x + 5, y + 10, 1 );
		new_hud( "spray_hud", "LEFT/RIGHT", x + 5, y + 20, 1 );
		new_hud( "spray_hud", "UP/DOWN", x + 5, y + 30, 1 );
		new_hud( "spray_hud", "B", x + 5, y + 40, 1 );
	}
	else
	{
		new_hud( "spray_hud", "FIRE", x + 5, y + 10, 1 );
		new_hud( "spray_hud", "LEFT/RIGHT", x + 5, y + 20, 1 );
		new_hud( "spray_hud", "UP/DOWN", x + 5, y + 30, 1 );
		new_hud( "spray_hud", "END", x + 5, y + 40, 1 );
	}

	new_hud( "spray_hud", "- Spray Object", x + 60, y + 10, 1 );
	new_hud( "spray_hud", "- Inc/Dec Rate", x + 60, y + 20, 1 );
	new_hud( "spray_hud", "- Inc/Dec Power", x + 60, y + 30, 1 );
	new_hud( "spray_hud", "- Quit", x + 60, y + 40, 1 );
}

spray_buttons()
{
	clear_universal_buttons( "spray" );

	if( level.xenon )
	{
		add_universal_button( "spray", "dpad_up" );
		add_universal_button( "spray", "dpad_down" );
		add_universal_button( "spray", "dpad_left" );
		add_universal_button( "spray", "dpad_right" );
		add_universal_button( "spray", "button_b" );
	}

	add_universal_button( "spray", "end" );
	add_universal_button( "spray", "uparrow" );
	add_universal_button( "spray", "downarrow" );
	add_universal_button( "spray", "leftarrow" );
	add_universal_button( "spray", "rightarrow" );

	level thread universal_input_loop( "spray", "stop_spray", true );
}

//-----------------//
// Universal Input //
//-----------------//
add_universal_button( button_group, name )
{
	if( !IsDefined( level.u_buttons[button_group] ) )
	{
		level.u_buttons[button_group] = [];
	}

	if( check_for_dupes( level.u_buttons[button_group], name ) )
	{
		level.u_buttons[button_group][level.u_buttons[button_group].size] = name;
	}	
}

clear_universal_buttons( button_group )
{
	level.u_buttons[button_group] = [];
}

universal_input_loop( button_group, end_on, use_attackbutton, mod_button, no_mod_button )
{
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

		if( IsDefined( mod_button ) && !level.debug_player ButtonPressed( mod_button ) )
		{
			wait( 0.05 );
			continue;
		}
		else if( IsDefined( no_mod_button ) && level.debug_player ButtonPressed( no_mod_button ) )
		{
			wait( 0.05 );
			continue;
		}


		if( use_attackbutton && level.debug_player AttackButtonPressed() )
		{
			level notify( notify_name, "fire" );
			wait( 0.1 );
			continue;
		}

		for( i = 0; i < buttons.size; i++ )
		{
			if( level.debug_player ButtonPressed( buttons[i] ) )
			{
				level notify( notify_name, buttons[i] );
				wait( 0.1 );
				break;
			}
		}

		wait( 0.05 );
	}
}

disable_buttons( button_group )
{
	level.u_buttons_disable[button_group] = true;
}

enable_buttons( button_group )
{
	wait( 1 );
	level.u_buttons_disable[button_group] = false;
}

//------------//
// Group Mode //
//------------//

group_mode()
{
	level thread group_mode_thread();
}

group_mode_thread()
{
	level waittill( "disable group_mode" );
	
	// Clean up
	level notify( "stop_select_group" );
	level.dyn_ent_selected_group = undefined;
}

select_group()
{
	level.dyn_ent_selected_group = undefined;

	y = level.menu_sys["current_menu"].options[0].y;

	if( !IsDefined( level.dyn_ent_groups ) )
	{
		return;
	}

	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	selected = list_menu( level.dyn_ent_groups, 180, y, 1.3, ::select_group_highlight );

	if( !IsDefined( selected ) )
	{
		level notify( "stop_select_group" );
	}
	else
	{
		level.dyn_ent_selected_group = level.dyn_ent_groups[selected];
	}

	arrow_hud Destroy();
}

select_group_highlight( group_name )
{
	dyn_ents = GetEntArray( group_name, "targetname" );
	for( i = 0; i < dyn_ents.size; i++ )
	{
		dyn_ents[i] thread group_highlight_thread();
	}
}

group_highlight_thread()
{
	level endon( "scroll_list" );
	level endon( "stop_select_group" );

	while( 1 )
	{
		self draw_model_axis();
		wait( 0.05 );
	}
}

group_plant_bomb()
{
	if( !IsDefined( level.dyn_ent_selected_group ) )
	{
		return "ERROR: Group not selected!";
	}

	level.plant_bomb_radius = 256;
	level.plant_bomb_power = 1000;
	level.plant_bomb_z = 0;

	plant_bomb_buttons();
	plant_bomb_hud();

	while( 1 )
	{
		level waittill( "plantbomb_button_pressed", key );

//		// CONTINUE FROM HERE!
		if( key == "fire" ) // Plant the bomb at this location
		{
//			if( IsDefined( level.planted_bomb ) )
//			{
//				wait( 0.2 );
//				continue;
//			}

			plant_bomb();
			wait( 0.2 );
		}
		else if( key == "enter" || key == "button_x" )
		{
			detonate_bomb();
			break;
		}
		else if( key == "del" || key == "button_y" )
		{
			if( IsDefined( level.planted_bomb ) )
			{
				level.planted_bomb Delete();
			}
			level.plant_bomb_radius = 256;
			level.plant_bomb_power = 1000;
			level.plant_bomb_z = 0;
			break;
		}
		else if( key == "=" || key == "dpad_right" )
		{
			level.plant_bomb_radius += 16;
			wait( 0.05 );
		}
		else if( key == "-" || key == "dpad_left" )
		{
			level.plant_bomb_radius -= 16;
			wait( 0.05 );
		}
		else if( key == "pgup" || key == "button_rshldr" )
		{
			level.plant_bomb_z += 8;
			wait( 0.05 );
		}
		else if( key == "pgdn" || key == "button_lshldr" )
		{
			level.plant_bomb_z -= 8;
			wait( 0.05 );
		}
		else if( key == "uparrow" || key == "dpad_up" )
		{
			level.plant_bomb_power += 50;
			wait( 0.05 );
		}
		else if( key == "downarrow" || key == "dpad_down" )
		{
			level.plant_bomb_power -= 50;
			wait( 0.05 );
		}
		else if( key == "end" || key == "button_b" ) // Quit out of this.
		{
			break;
		}
	}

	if( IsDefined( level.planted_bomb ) )
	{
		level.planted_bomb Delete();
	}

	remove_hud( "plant_bomb" );
}

plant_bomb()
{
	if( IsDefined( level.planted_bomb ) )
	{
		level.planted_bomb Delete();
	}

	forward = AnglesToforward( level.debug_player GetPlayerAngles() );
	vector = level.debug_player GetEye() + VectorScale( forward, 5000 );
	trace = BulletTrace( level.debug_player GetEye(), vector, false, undefined );

	if( trace["fraction"] == 1 )
	{
		return;
	}

	spawn_bomb( trace["position"] );
}

spawn_bomb( vector )
{
	bomb = Spawn( "script_origin", vector + ( 0, 0, -20 ) );

	level.planted_bomb = bomb;

	bomb thread draw_bomb();
}

draw_bomb()
{
	self endon( "death" );

	ents = GetEntArray( level.dyn_ent_selected_group, "targetname" );
	for( i = 0; i < ents.size; i++ )
	{
		ents[i] thread draw_trajectory();
	}

	og_z = self.origin[2];
	z = og_z;

	while( 1 )
	{
		z = og_z + level.plant_bomb_z;
		self.origin = ( self.origin[0], self.origin[1], z );
		self draw_sphere( level.plant_bomb_radius, 16, "pitch" );
		self draw_sphere( level.plant_bomb_radius, 16, "yaw");
		self draw_sphere( level.plant_bomb_radius, 16, "roll" );
		self draw_bomb_axis();
		print3d( self.origin, "Bomb", ( 1, 0, 0 ), 1, 1 );
		radius = "Radius: " + level.plant_bomb_radius;
		print3d( self.origin + ( 0, 0, -12), radius, ( 1, 0, 0 ), 1, 1 );
		power = "Power: " + level.plant_bomb_power;
		print3d( self.origin + ( 0, 0, -24), power, ( 1, 0, 0 ), 1, 1 );
		z = "Z: " + ( self.origin[2] - og_z );
		print3d( self.origin + ( 0, 0, -36), z, ( 1, 0, 0 ), 1, 1 );
		wait( 0.05 );
	}
}

draw_bomb_axis()
{
	Line( self.origin + ( -16, 0, 0 ), self.origin + ( 16, 0, 0 ), ( 1, 1, 0 ), 1 );
	Line( self.origin + ( 0, -16, 0 ), self.origin + ( 0, 16, 0 ), ( 1, 1, 0 ), 1 );
	Line( self.origin + ( 0, 0, -16 ), self.origin + ( 0, 0, 16 ), ( 1, 1, 0 ), 1 );
}

draw_sphere( radius, segments, axis )
{
	self endon( "death" );

	if( !IsDefined( axis ) )
	{
		axis = "yaw";
	}

	points = [];

	add_angles = 360 / segments;
	angles = ( 0, 0, 0 );

	if( axis == "pitch" )
	{
		for( i = 0; i < segments; i++ )
		{
			angles = angles + ( add_angles, 0, 0 );
			forward = AnglesToForward( angles );
			points[i] = self.origin + VectorScale( forward, radius );
		}		
	}
	else if( axis == "roll" )
	{
		angles = angles + ( 0, 90, 0 ); // Since we're using anglestoforward
		for( i = 0; i < segments; i++ )
		{
			angles = angles + ( add_angles, 0, 0 );
			forward = AnglesToForward( angles );
			points[i] = self.origin + VectorScale( forward, radius );
		}
	}
	else // yaw
	{
		for( i = 0; i < segments; i++ )
		{
			angles = angles + ( 0, add_angles, 0 );
			forward = AnglesToForward( angles );
			points[i] = self.origin + VectorScale( forward, radius );
		}
	}

	for( i = 0; i < points.size; i++ )
	{
		if( i == ( points.size - 1 ) )
		{
			Line( points[i], points[0], ( 1, 0, 0 ), 1 );
		}
		else
		{
			Line( points[i], points[i + 1], ( 1, 0, 0 ), 1 );
		}
	}
}

detonate_bomb()
{
	level notify( "bomb_detonated" );

	// RadiusDamage!!
	temp_radius_damage( level.planted_bomb.origin, level.plant_bomb_radius, level.plant_bomb_power, level.plant_bomb_power * 0.1 );
	level.planted_bomb Delete();
}

temp_radius_damage( origin, radius, max_dmg, min_dmg )
{
	ents = GetEntArray( level.dyn_ent_selected_group, "targetname" );
	for( i = 0; i < ents.size; i++ )
	{
		dist = Distance( origin, ents[i].origin );
		if( dist > radius )
		{
			continue;
		}

		forward = VectorNormalize( ents[i].origin - origin );

//		points = fOuterDamage + ((fInnerDamage - fOuterDamage) * (1.f - dist / radius));
		power = min_dmg + ( ( max_dmg - min_dmg ) * ( 1.0 - dist / radius ) );

		forward = VectorScale( forward, power );
//		level thread draw_trajectory( ents[i].origin, forward + ents[i].origin );
		ents[i] MoveGravity( forward, 1 );
	}
}

draw_trajectory()
{
	level.planted_bomb endon( "death" );
	level endon( "bomb_detonated" );
	segments = 10;
	time = 1.0;
	time_inc = time / segments;
	og_time_inc = time_inc;
	while( 1 )
	{
		dist = Distance( level.planted_bomb.origin, self.origin );
		if( dist < level.plant_bomb_radius )
		{
			max_dmg = level.plant_bomb_power;
			min_dmg = level.plant_bomb_power * 0.1;
			forward = VectorNormalize( self.origin - level.planted_bomb.origin );
	
			power = min_dmg + ( ( max_dmg - min_dmg ) * ( 1.0 - dist / level.plant_bomb_radius ) );

			time_inc = og_time_inc;			
			velocity = VectorScale( forward, power );
			sub_vel = VectorScale( velocity, time_inc );
			start_pos = self.origin;
			gravity = GetDvarInt( "g_gravity" );
			old_pos = start_pos;
			for( i = 1; i < segments + 1; i++ )
			{
				pos = start_pos + VectorScale( sub_vel, i );
				pos = pos - ( 0, 0, ( 0.5 * gravity * ( time_inc * time_inc ) ) );
				line( old_pos, pos, ( 0, 1, 0 ) );
				old_pos = pos;
				time_inc += og_time_inc;
//				self debug_fake_move_gravity( velocity, time );
			}


		}
		wait( 0.05 );
	}
}

plant_bomb_hud()
{
	x = 0;
	y = 400;
	hud = new_hud( "plant_bomb", undefined, x, y, 1 );
	hud SetShader( "white", 170, 72 );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	if( level.xenon )
	{
		new_hud( "plant_bomb", "Fire", x + 5, y + 10, 1 );		
		new_hud( "plant_bomb", "X", x + 5, y + 20, 1 );
		new_hud( "plant_bomb", "Y", x + 5, y + 30, 1 );
		new_hud( "plant_bomb", "BUMPERS", x + 5, y + 40, 1 );
		new_hud( "plant_bomb", "RIGHT/LEFT", x + 5, y + 50, 1 );
		new_hud( "plant_bomb", "UP/DOWN", x + 5, y + 60, 1 );
	}
	else
	{
		new_hud( "plant_bomb", "Fire", x + 5, y + 10, 1 );
		new_hud( "plant_bomb", "Enter", x + 5, y + 20, 1 );
		new_hud( "plant_bomb", "Delete", x + 5, y + 30, 1 );
		new_hud( "plant_bomb", "PGUP/PGDN", x + 5, y + 40, 1 );
		new_hud( "plant_bomb", "-/+", x + 5, y + 50, 1 );
		new_hud( "plant_bomb", "UP/DOWN", x + 5, y + 60, 1 );
	}

	new_hud( "plant_bomb", "- Place Bomb", x + 60, y + 10, 1 );
	new_hud( "plant_bomb", "- Detonate Bomb", x + 60, y + 20, 1 );
	new_hud( "plant_bomb", "- Delete Bomb", x + 60, y + 30, 1 );
	new_hud( "plant_bomb", "- Raise/Lower Bomb", x + 60, y + 40, 1 );
	new_hud( "plant_bomb", "- Inc/Dec Radius", x + 60, y + 50, 1 );
	new_hud( "plant_bomb", "- Inc/Dec Power", x + 60, y + 60, 1 );
}

remove_hud( hud_name )
{
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
}

new_hud( hud_name, msg, x, y, scale )
{
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
}

plant_bomb_buttons()
{
	clear_universal_buttons( "plantbomb" );

	if( level.xenon )
	{
		add_universal_button( "plantbomb", "dpad_up" );		// Bomb Power
		add_universal_button( "plantbomb", "dpad_down" );	// Bomb Power
		add_universal_button( "plantbomb", "dpad_left" );	// Bomb Radius
		add_universal_button( "plantbomb", "dpad_right" );	// Bomb Radius
		add_universal_button( "plantbomb", "button_b" );	// Quit
		add_universal_button( "plantbomb", "button_x" );	// Detonate
		add_universal_button( "plantbomb", "button_y" );	// Delete
		add_universal_button( "plantbomb", "button_lshldr" );// Bomb Z
		add_universal_button( "plantbomb", "button_rshldr" );// Bomb Z
	}

	add_universal_button( "plantbomb", "enter" ); 		// detonate bomb
	add_universal_button( "plantbomb", "end" );			// Quit
	add_universal_button( "plantbomb", "-" );			// Bomb Radius
	add_universal_button( "plantbomb", "=" );			// Bomb Radius
	add_universal_button( "plantbomb", "pgup" );		// Bomb Z
	add_universal_button( "plantbomb", "pgdn" );		// Bomb Z
	add_universal_button( "plantbomb", "uparrow" );		// Power
	add_universal_button( "plantbomb", "downarrow" );	// Power
	add_universal_button( "plantbomb", "del" );			// Delete

	level thread universal_input_loop( "plantbomb", "bomb_detonated", true );
}

reset_group()
{
	if( !IsDefined( level.dyn_ent_selected_group ) )
	{
		return "ERROR: Group not selected!";
	}

	ents = GetEntArray( level.dyn_ent_selected_group, "targetname" );
	for( i = 0; i < ents.size; i++ )
	{
		ents[i].origin = ents[i].og_origin;
	}	
}

//-------------//
// Select Mode //
//-------------//

select_mode()
{
	level thread select_mode_thread();
}

select_mode_thread()
{
	level.unselected_color 	= ( 1, 1, 1 );
	level.selected_color	= ( 1, 1, 0 );

	draw_selectables( level.all_objects );
	level thread select_main_thread();

	level waittill( "disable select_mode" );

	level notify( "stop_select_model" );
}

draw_selectables( objects )
{
	for( i = 0; i < objects.size; i++ )
	{
		objects[i] thread select_icon_think();
	}
}

select_icon_think()
{
	self endon( "death" );
	self notify( "only_one_icon_think_thread" );
	self endon( "only_one_icon_think_thread" );
	level endon( "stop_select_model" );

	if( !IsDefined( self.select_scale ) )
	{
		self.select_scale = 1;
	}

	self.select_color = level.unselected_color;

	while( 1 )
	{
		print3d( self.origin, ".", self.select_color, 1, self.select_scale );
		wait( 0.05 );
	}
}

select_main_thread()
{
	level endon( "stop_select_model" );

	level.highlighted_object = undefined;
	level.selected_object = undefined;

	level.selected_object_dist = 48;
//	level thread selected_object_dist();

	while( 1 )
	{
		if( !IsDefined( level.selected_object ) )
		{
			level thread object_highlight( level.all_objects );
		}
		wait( 0.05 );
	}
}

object_highlight( objects )
{
	dot = 0.85;
	highlighted_object = undefined;

	forward = AnglesToForward( level.debug_player GetPlayerAngles() );
	for( i = 0; i < objects.size; i++ )
	{
		// For newly added ents
		if( !IsDefined( objects[i].select_scale ) )
		{
			objects[i] select_icon_think();
		}

		ent = objects[i];
		
		difference = VectorNormalize( ent.origin - ( level.debug_player.origin + ( 0, 0, 55 ) ) );
		newdot = VectorDot( forward, difference );
		if( newdot < dot )
		{
			continue;
		}

		dot = newdot;
		highlighted_object = ent;
	}

	if( IsDefineD( highlighted_object ) )
	{
//		level thread draw_line( highlighted_object, level.debug_player );
		highlighted_object.select_scale = 3;
		highlighted_object.select_color = level.selected_color;
		level.highlighted_object = highlighted_object;

		for( i = 0; i < objects.size; i++ )
		{
			if( objects[i] == highlighted_object )
			{
				continue;
			}

			objects[i].select_scale = 1;
			objects[i].select_color = level.unselected_color;
		}
	}
}

select_grab()
{
	level.selected_object = level.highlighted_object;
	level.selected_object.select_og_origin = level.selected_object.origin;
	level.selected_object thread move_selected_object();
}

select_copy()
{
	origin = level.highlighted_object.origin;
	model = level.highlighted_object.model;

	level.selected_object = Spawn( "script_model", origin );
	level.selected_object SetModel( model );
	level.selected_object.select_og_origin = level.selected_object.origin;
	level.selected_object thread move_selected_object();	
}

select_hop()
{
	object = level.highlighted_object;
	
	start_pos = object.origin;
	target_pos = object.origin + ( -5 + RandomInt( 10 ), -5 + RandomInt( 10 ), 0 );

	///////// Math
	gravity = GetDvarInt( "g_gravity" );
	gravity = gravity * -1;

	dist = Distance( start_pos, target_pos );
	time = dist / 15;

	delta = target_pos - start_pos;
	drop = 0.5 * gravity * ( time * time );
	velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
	/////////

	object MoveGravity( velocity, time );	
}

selected_drop()
{
	drop_model();
	level thread force_menu_back();
	level.selected_object = undefined;
}

selected_shoot()
{
	shoot_model();
	level thread force_menu_back();
	level.selected_object = undefined;
}

selected_reset()
{
	level.selected_object notify( "unlink_selected_object" );
	level.selected_object.origin = level.selected_object.select_og_origin;
	level thread force_menu_back();
	level.selected_object = undefined;
}

selected_delete( no_force_back )
{
	if( !IsDefined( level.selected_object ) )
	{
		return;
	}

	level.selected_object remove_from_all_objects();
	level.selected_object remove_shooter_model();
	level.selected_object remove_misc_model();

	level.selected_object notify( "unlink_selected_object" );
	level.selected_object Delete();
	level.selected_object = undefined;

	if( !IsDefined( no_force_back ) || !no_force_back )
	{
		level thread force_menu_back();
	}
}

selected_back()
{
	if( IsDefined( level.selected_object ) )
	{
		if( !IsDefined( level.selected_object.select_og_origin ) )
		{
			selected_delete();
		}
		else
		{
			selected_reset();
		}
	}
	else
	{
		level thread force_menu_back();
	}
}

selected_save_highlight( key )
{
	object = level.highlighted_object;

	if( !IsDefined( object.save_selected ) || !object.save_selected )
	{
		object add_to_save_highlighted();
		object.save_selected = true;
		object thread save_highlight_loop();
	}
	else
	{
		object remove_save_highlighted();
		object.save_selected = false;
		object notify( "stop_save_highlight" );
	}
	wait( 0.1 );
}

save_highlight_loop()
{
	self endon( "stop_save_highlight" );
	while( 1 )
	{
		print3d( self.origin, "S", ( 0, 1, 0 ), 1 );
		wait( 0.05 );
	}
}

add_to_save_highlighted()
{
	if( !IsDefined( level.save_highlighted ) )
	{
		level.save_highlighted = [];
	}

	if( !check_for_dupes( level.save_highlighted, self ) )
	{
		return;
	}

	level.save_highlighted[level.save_highlighted.size] = self;
}

remove_save_highlighted()
{
	if( !IsDefined( level.save_highlighted ) )
	{
		level.save_highlighted = [];
	}

	level.save_highlighted = maps\_utility::array_remove( level.save_highlighted, self );
}

selected_save()
{
	level thread selected_save_thread();
}

selected_save_thread()
{
	level waittill( "disable select_save_menu" );
	for( i = 0; i < level.all_objects.size; i++ )
	{
		level.all_objects[i] remove_save_stat();
	}
}

selected_misc_model_save()
{
	level thread selected_misc_model_save_thread();
}

selected_misc_model_save_thread()
{
	level waittill( "disable misc_model_select_save_menu" );
	for( i = 0; i < level.misc_models.size; i++ )
	{
		level.misc_models[i] remove_save_stat();
	}
}

remove_save_stat()
{
	self notify( "stop_save_highlight" );
	self.save_selected = false;
}

save_misc_model_highlighted()
{
	if( !IsDefined( level.save_highlighted ) || level.save_highlighted.size < 1 )
	{
		return "ERROR: NO OBJECTS ARE SELECTED!";
	}

	return save_master( "Save Selected Misc_Models?", "misc_model_selected", level.save_highlighted, "misc_model" );
}

save_dyn_ent_highlighted()
{
	if( !IsDefined( level.save_highlighted ) || level.save_highlighted.size < 1 )
	{
		return "ERROR: NO OBJECTS ARE SELECTED!";
	}

	return save_master( "Save Selected Dyn_Ents?", "dyn_ents_selected", level.save_highlighted );
}

draw_line( ent, ent2 )
{
	level notify( "stop_draw_line" );
	level endon( "stop_draw_line" );

	while( 1 )
	{
		line( ent.origin, ent2.origin, ( 1, 1, 1 ) );
		wait( 0.05 );
	}
}

//---------------//
// Input Section //
//---------------//
setup_menu_buttons()
{
	clear_universal_buttons( "menu" );

	level thread menu_cursor();

	if( level.xenon )
	{
		add_universal_button( "menu", "dpad_up" );
		add_universal_button( "menu", "dpad_down" );
		add_universal_button( "menu", "dpad_left" );
		add_universal_button( "menu", "dpad_right" );
		add_universal_button( "menu", "button_a" );
		add_universal_button( "menu", "button_b" );
	}

	add_universal_button( "menu", "1" );
	add_universal_button( "menu", "2" );
	add_universal_button( "menu", "3" );
	add_universal_button( "menu", "4" );
	add_universal_button( "menu", "5" );
	add_universal_button( "menu", "6" );
	add_universal_button( "menu", "7" );
	add_universal_button( "menu", "8" );
	add_universal_button( "menu", "9" );
	add_universal_button( "menu", "0" );

	add_universal_button( "menu", "downarrow" );
	add_universal_button( "menu", "uparrow" );
	add_universal_button( "menu", "leftarrow" );
	add_universal_button( "menu", "rightarrow" );

	add_universal_button( "menu", "=" );
	add_universal_button( "menu", "-" );

	add_universal_button( "menu", "enter" );
	add_universal_button( "menu", "end" );
	add_universal_button( "menu", "backspace" );

	add_universal_button( "menu", "kp_leftarrow" );
	add_universal_button( "menu", "kp_rightarrow" );
	add_universal_button( "menu", "kp_uparrow" );
	add_universal_button( "menu", "kp_downarrow" );
	add_universal_button( "menu", "kp_home" );
	add_universal_button( "menu", "kp_pgup" );

	level thread universal_input_loop( "menu", "never", undefined, undefined, "button_ltrig" );
}

menu_cursor()
{
	level.menu_cursor = set_hudelem( undefined, 0, 130, 1.3 );
	level.menu_cursor SetShader( "white", 125, 20 );
	level.menu_cursor.color = ( 1, 0.5, 0 );	
	level.menu_cursor.alpha = 0.5;
	level.menu_cursor.sort = 1; // Put behind everything
	level.menu_cursor.current_pos = 0;
}

any_button_hit( button_hit, type  )
{
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
}

attackbutton_hold_think()
{
	level endon( "stop_attackbutton_hold_think" );

	level.attack_button_held = false;

	count = 0;
	while( true )
	{
		if( level.debug_player AttackButtonPressed() )
		{
			count++;
			if( count == 3 )
			{
				level.attack_button_held = true;
				level notify( "attack_button_held" );
			}
		}
		else
		{
			if( level.attack_button_held && !level.debug_player AttackButtonPressed() )
			{
				level notify( "attack_button_released" );
				level.attack_button_held = false;
				return;
			}
			count = 0;
		}

		wait( 0.05 );
	}
}

//-----------//
// Prop Menu //
//-----------//
prop_mode()
{
	level thread prop_mode_thread();
}

prop_mode_thread()
{
	level.misc_model_z_offset = 0;
	level.prop_mode = [];
	level.prop_mode["random_yaw"] = false;

	prop_mode_hud();
	prop_buttons();
	level thread prop_mode_input();

	level waittill( "disable prop_mode_menu" );
	level notify( "stop_prop_mode" );

	remove_hud( "prop_hud" );

	// Clean up
	if( IsDefined( level.selected_object ) )
	{
		level.selected_object Delete();
	}
}

prop_mode_hud()
{
	if( level.xenon )
	{
		extra_x = 30;
	}
	else
	{
		extra_x = 0;
	}

	level.prop_hud = [];

	x = 0;
	y = 400;
	hud = new_hud( "prop_hud", undefined, x, y, 1 );
	hud SetShader( "white", 170, 35 );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	// Prop Stats
	hud = new_hud( "prop_hud", "Random Yaw:", 319, 385, 1.2 );
	hud.alignX = "right";
	level.prop_hud["random_yaw"] = new_hud( "prop_hud", "Disabled", 321 + extra_x, 385, 1.2 );
	level.prop_hud["random_yaw"].alignX = "left";

	// Prop Stats
	hud = new_hud( "prop_hud", "Z Offset:", 319, 400, 1.2 );
	hud.alignX = "right";
	level.prop_hud["z_offset"] = new_hud( "prop_hud", "0", 321 + extra_x, 400, 1.2 );
	level.prop_hud["z_offset"].alignX = "left";

	if( level.xenon )
	{
		new_hud( "prop_hud", "X", x + 5, y + 10, 1 );
		new_hud( "prop_hud", "BUMPERS", x + 5, y + 20, 1 );
	}
	else
	{
		new_hud( "prop_hud", "R", x + 5, y + 10, 1 );
		new_hud( "prop_hud", "PGUP/PGDN", x + 5, y + 20, 1 );
	}


	new_hud( "prop_hud", "- Toggles Random Yaw", x + 60, y + 10, 1 );
	new_hud( "prop_hud", "- Inc/Dec Z Offset", x + 60, y + 20, 1 );
}

prop_buttons()
{
	clear_universal_buttons( "prop" );

	if( level.xenon )
	{
		add_universal_button( "prop", "button_x" );
		add_universal_button( "prop", "button_lshldr" );
		add_universal_button( "prop", "button_rshldr" );		
	}

	add_universal_button( "prop", "r" );
	add_universal_button( "prop", "pgup" );
	add_universal_button( "prop", "pgdn" );

	level thread universal_input_loop( "prop", "stop_prop_mode", true );
}

prop_mode_input()
{
	while( 1 )
	{
		level waittill( "prop_button_pressed", key );

		if( key == "r" || key == "button_x" ) // Plant the bomb at this location
		{
			if( level.prop_mode["random_yaw"] )
			{
				level.prop_mode["random_yaw"] = false;
				level.prop_hud["random_yaw"] SetText( "Disabled" );
			}
			else
			{
				level.prop_mode["random_yaw"] = true;
				level.prop_hud["random_yaw"] SetText( "Enabled" );
			}

			level.prop_hud["random_yaw"] thread hud_font_scaler();
			wait( 0.1 ); // - 0.1 cause the button delay is that long.
		}
		else if( key == "pgup" || key == "button_rshldr" )
		{
			level.misc_model_z_offset += 8;
			level.prop_hud["z_offset"] SetText( level.misc_model_z_offset );
			wait( 0.1 );
		}
		else if( key == "pgdn" || key == "button_lshldr" )
		{
			level.misc_model_z_offset -= 8;
			level.prop_hud["z_offset"] SetText( level.misc_model_z_offset );
			wait( 0.1 );
		}
	}
}

spawn_prop()
{
	y = level.menu_sys["current_menu"].options[0].y;

	if( !IsDefined( level.script_modelnames ) )
	{
		return;
	}

	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	list_menu( level.script_modelnames, 180, y, 1.3, ::spawn_selected_prop );

	arrow_hud Destroy();
}

place_prop()
{
	if( !IsDefined( level.selected_object ) )
	{
		return "ERROR: Prop not Selected!";
	}

	level.selected_object notify( "unlink_selected_object" );
	level notify( "stop_prop_move" );
	level.selected_object add_misc_model();
	level.selected_object = undefined;
}

place_prop_copy()
{
	if( !IsDefined( level.selected_object ) )
	{
		return "ERROR: Prop not Selected!";
	}

	level.selected_object notify( "unlink_selected_object" );
	model_name = level.selected_object.model;

	level.selected_object add_misc_model();
	level.selected_object = undefined;	

	spawn_selected_prop( model_name );
}

spawn_selected_prop( model_name )
{
	spawn_selected_object( model_name, true );

	if( level.prop_mode["random_yaw"] )
	{
		level.selected_object.angles = ( 0, RandomInt( 360 ), 0 );
	}
}

prop_move()
{
	level.selected_object = level.highlighted_object;
	level.selected_object.select_og_origin = level.selected_object.origin;
	level.selected_object thread move_selected_object( true );

	level thread prop_move_thread();
}

prop_move_thread()
{
	level waittill( "stop_prop_move" );
	level thread force_menu_back();
}

prop_copy()
{
	origin = level.highlighted_object.origin;
	model = level.highlighted_object.model;

	level.selected_object = Spawn( "script_model", origin );
	level.selected_object SetModel( model );
	level.selected_object.select_og_origin = level.selected_object.origin;
	level.selected_object thread move_selected_object( true );	

	level thread prop_copy_thread();
}

prop_copy_thread()
{
	level waittill( "stop_prop_move" );
	level thread force_menu_back();
}

//------------------//
// Select Prop Mode //
//------------------//
select_prop_mode()
{
	if( !IsDefined( level.misc_models ) || level.misc_models.size < 1 )
	{
		return "ERROR: No script models in level!";
	}

	level thread select_prop_mode_thread();
}

select_prop_mode_thread()
{
	selected_delete( true );

	level.unselected_color 	= ( 1, 1, 1 );
	level.selected_color	= ( 1, 1, 0 );

	draw_selectables( level.misc_models );
	level thread select_prop_main_thread();

	level waittill( "disable select_prop_mode" );

	level notify( "stop_select_model" );
}

select_prop_main_thread()
{
	level endon( "stop_select_model" );

	level.highlighted_object = undefined;
	level.selected_object = undefined;

//	level.selected_object_dist = 48;
//	level thread selected_object_dist();

	while( 1 )
	{
		if( !IsDefined( level.selected_object ) )
		{
			level thread object_highlight( level.misc_models );
		}
		wait( 0.05 );
	}
}

//------------------//
// Rotate Prop Mode //
//------------------//
rotate_prop_mode()
{
	if( !IsDefined( level.misc_models ) || level.misc_models.size < 1 )
	{
		return "ERROR: No script models in level!";
	}

	level thread rotate_prop_mode_thread();
}

rotate_prop_mode_thread()
{
	level.rotate_highlighted = [];

	enable_rotate_hud();
	selected_delete( true );
	rotate_buttons();

	level.unselected_color 	= ( 1, 1, 1 );
	level.selected_color	= ( 1, 1, 0 );

	draw_selectables( level.misc_models );
	set_rotate_og_angles();

	level thread select_prop_main_thread();
	level thread rotate_prop_main_thread();

	level waittill( "disable rotate_prop_mode" );
	disable_rotate_hud();
	level notify( "stop_rotate_mode" );
	level notify( "stop_select_model" );
}

set_rotate_og_angles()
{
	for( i = 0; i < level.misc_models.size; i++ )
	{
		level.misc_models[i].og_angles = level.misc_models[i].angles;
	}
}

selected_rotate_highlight()
{
	object = level.highlighted_object;

	if( !IsDefined( object.rotate_highlighted ) || !object.rotate_highlighted )
	{
		object add_to_rotate_highlighted();
		object thread rotate_highlight_loop();
	}
	else
	{
		object remove_rotate_highlighted();
		object notify( "stop_rotate_highlight" );
	}
	wait( 0.1 );
}

rotate_highlight_loop()
{
	level endon( "stop_rotate_mode" );
	self endon( "stop_rotate_highlight" );
	while( 1 )
	{
		print3d( self.origin, "*", ( 0, 1, 0 ), 1 );
		wait( 0.05 );
	}
}

add_to_rotate_highlighted()
{
	if( !IsDefined( level.rotate_highlighted ) )
	{
		level.rotate_highlighted = [];
	}

	if( !check_for_dupes( level.rotate_highlighted, self ) )
	{
		return;
	}

	self.rotate_highlighted = true;

	level.rotate_highlighted[level.rotate_highlighted.size] = self;
}

remove_rotate_highlighted()
{
	if( !IsDefined( level.rotate_highlighted ) )
	{
		level.rotate_highlighted = [];
	}

	self.rotate_highlighted = false;

	level.rotate_highlighted = maps\_utility::array_remove( level.rotate_highlighted, self );
}

rotate_buttons()
{
	clear_universal_buttons( "rotate" );

	mod_button = undefined;
	if( level.xenon )
	{
		add_universal_button( "rotate", "button_a" );
		add_universal_button( "rotate", "button_b" );
		add_universal_button( "rotate", "button_x" );
		add_universal_button( "rotate", "button_y" );
		add_universal_button( "rotate", "button_lshldr" );
		add_universal_button( "rotate", "button_rshldr" );
		add_universal_button( "rotate", "button_lstick" );
		add_universal_button( "rotate", "button_rstick" );
		mod_button = "button_ltrig";
	}

	add_universal_button( "rotate", "kp_rightarrow" ); 
	add_universal_button( "rotate", "kp_leftarrow" );
	add_universal_button( "rotate", "kp_uparrow" );
	add_universal_button( "rotate", "kp_downarrow" );
	add_universal_button( "rotate", "kp_home" );
	add_universal_button( "rotate", "kp_pgup" );
	add_universal_button( "rotate", "kp_5" );
	add_universal_button( "rotate", "kp_ins" );

	level thread universal_input_loop( "rotate", "stop_rotate_mode", undefined, mod_button );
}

rotate_prop_main_thread()
{
	self endon( "stop_move_selected_object" );
	self endon( "unlink_selected_object" );
	self endon( "death" );

	rate = 2;

	while( 1 )
	{
		level waittill( "rotate_button_pressed", key );

		for( i = 0; i < level.rotate_highlighted.size; i++ )
		{
			object = level.rotate_highlighted[i];
			if( key == "kp_rightarrow" || key == "button_b" )
			{
				object DevAddYaw( rate );
			}
			else if( key == "kp_leftarrow" || key == "button_x" )
			{
				object DevAddYaw( rate * -1 );
			}
			else if( key == "kp_uparrow" || key == "button_y" )
			{
				object DevAddPitch( rate * -1 );
			}
			else if( key == "kp_downarrow" || key == "button_a" )
			{
				object DevAddPitch( rate );
			}
			else if( key == "kp_home" || key == "button_lshldr" )
			{
				object DevAddRoll( rate * -1 );
			}
			else if( key == "kp_pgup" || key == "button_rshldr" )
			{
				object DevAddRoll( rate );
			}
			else if( key == "kp_ins" || key == "button_lstick" )
			{
				object.angles = ( 0, 0, 0 );
			}
			else if( key == "kp_5" || key == "button_rstick" )
			{
				object.angles = object.og_angles;
			}
		}
		wait( 0.01 );
	}
}

//--------------//
// Save Section //
//--------------//
set_default_path()
{
	if( !IsDefined( level.path ) )
	{
		level.path = "prop_man/" + level.script + "/";
	}
}

store_shooter_model()
{
	if( !IsDefined( level.shooter_models ) )
	{
		level.shooter_models = [];
	}

	self add_to_all_objects();

	level.shooter_models = maps\_utility::array_add( level.shooter_models, self );
}

remove_shooter_model()
{
	if( !IsDefined( level.shooter_models ) )
	{
		level.shooter_models = [];
	}

	level.shooter_models = maps\_utility::array_remove( level.shooter_models, self );
}

save_all_dyn_ents()
{
	if( !IsDefined( level.shooter_models ) || level.shooter_models.size < 1 )
	{
		return "ERROR: No Dyn_Ents to Save!";
	}

	return save_master( "Save All Dyn_Ents?", "dyn_ents_all", level.shooter_models );
}

save_all_misc_models()
{
	selected_delete( true );

	if( !IsDefined( level.misc_models ) || level.misc_models.size < 1 )
	{
		return "ERROR: No Misc_Models to Save!";
	}

	return save_master( "Save All Misc_Models?", "misc_models_all", level.misc_models );
}

save_master( save_msg, filename, save_array, classname )
{
	disable_buttons( "menu" );
	disable_buttons( "rotate" );
	disable_buttons( "prop" );

	level.debug_player FreezeControls( true );

	save_buttons();
	filename = filename + ".map";
	save_dialog( save_msg, filename );

	yes_key = "y"; 	// Yes
	no_key = "n";	// No
	xenon_yes_key = "button_x";
	xenon_no_key = "button_n";

	while( true )
	{
		level waittill( "save_button_pressed", key );

		if( key == yes_key || key == xenon_yes_key )
		{
			level thread save_selector( level.save_yes_hud.x, level.save_yes_hud.y, 40 );
	
			check = save( save_array, filename, classname );

			if( IsDefined( check ) && check != "failed" )
			{
				level thread save_complete( check );
			}
			else
			{
				level thread save_failed();
			}

			break;
		}
		else if( key == no_key || key == xenon_no_key )
		{
			save_selector( level.save_no_hud.x, level.save_no_hud.y, 40 );
			break;
		}
	}

	level notify( "stop_savebutton_loop" );

	remove_hud( "save" );

	level.debug_player FreezeControls( false );

	level thread enable_buttons( "menu" );
	level thread enable_buttons( "rotate" );
	level thread enable_buttons( "prop" );
}

save_dialog( msg, filename )
{
	if( !IsDefined( level.save_hud_x ) )
	{
		level.save_hud_x = 0;
	}

	if( !IsDefined( level.save_hud_y ) )
	{
		level.save_hud_y = 380;
	}

	x = level.save_hud_x;
	y = level.save_hud_y;

	bg1_shader_width = 640;
	bg1_shader_height = 100;

	hud = new_hud( "save", undefined, ( x + ( bg1_shader_width * 0.5 ) ), y, 1 );
	hud SetShader( "white", bg1_shader_width, bg1_shader_height );
	hud.alignX = "center";
	hud.alignY = "top";
	hud.color = ( 0.55, 0.29, 0 );
	hud.alpha = 0.85;
	hud.sort = 30;

	bg2_shader_width = 280;
	bg2_shader_height = 20;

	hud = new_hud( "save", msg, ( x + 10 ), ( y + 10 ), 1.3 );
	hud.sort = 35;
	if( level.xenon )
	{
		prefix = "Path: xenonOutput/scriptdata/";
	}
	else
	{
		prefix = "Path: pc/main/scriptdata/";
	}

	hud = new_hud( "save",  prefix + level.path + filename, ( x + 10 ), ( y + 30 ), 1.1 );
	hud.sort = 35;

	if( level.xenon )
	{
		yes_hud = "Yes [X]";
		no_hud = "No [B]";
	}
	else
	{
		yes_hud = "Yes [y]";
		no_hud = "No [n]";
	}

	level.save_yes_hud = new_hud( "save", yes_hud, ( x + ( bg1_shader_width * 0.5 ) ) - 50, ( y + 90 ), 1.3 );
	level.save_yes_hud.alignX = "center";
	level.save_yes_hud.sort = 35;

	level.save_no_hud = new_hud( "save", no_hud, ( x + ( bg1_shader_width * 0.5 ) ) + 50, ( y + 90 ), 1.3 );
	level.save_no_hud.alignX = "center";
	level.save_no_hud.sort = 35;
}

destroy_hud( hud )
{
	if( IsDefined( hud ) )
	{
		hud Destroy();
	}
}

save_complete( msg )
{
	hud = set_hudelem( "Save Successful", 320, 100, 1.5 );
	hud.alignX = "center";
	hud.color = ( 0, 1, 0 );

	hud_msg = set_hudelem( msg, 320, 120, 1.3 );
	hud_msg.alignX = "center";
	hud_msg.color = ( 1, 1, 1 );

	wait( 2 );

	hud FadeOverTime( 3 );
	hud.alpha = 0;

	hud_msg FadeOverTime( 3 );
	hud_msg.alpha = 0;

	wait( 3 );
	hud Destroy();
	hud_msg Destroy();
}

save_failed()
{
	hud = set_hudelem( "Save Failed!", 320, 100, 1.5 );
	hud.AlignX = "center";
	hud.color = ( 1, 0, 0 );
	wait( 1 );

	hud FadeOverTime( 3 );
	hud.alpha = 0;
	wait( 3 );
	hud Destroy();
}

save_selector( x, y, width )
{
	hud = set_hudelem( undefined, x, y, 1 );
	hud.alignX = "center";
	hud SetShader( "white", width, 20 );
	hud.color = ( 1, 1, 0.5 );
	hud.alpha = 0.5;
	hud.sort = 10;

	hud FadeOverTime( 0.25 );
	hud.alpha = 0;
	wait( 0.35 );
	hud Destroy();
}

save( model_array, filename, classname )
{
/#
	level.fullpath_file = level.path + filename;

	// Default classname to dyn_ents
	if( !IsDefined( classname ) )
	{
		classname = "script_model";
	}


	file = OpenFile( level.fullpath_file, "write" );
	assertex( file != -1, "File not writeable (maybe you should check it out): " + level.fullpath_file );
	fprintln( file, "//OH SHIT! IT WORKS!" );

	for( i = 0; i < model_array.size; i++ )
	{
		fprintln( file, "{" );
		fprintln( file, "\"angles\" \"" + model_array[i].angles[0] + " " + model_array[i].angles[1] + " " + model_array[i].angles[2] + "\"" );
		fprintln( file, "\"origin\" \"" + model_array[i].origin[0] + " " + model_array[i].origin[1] + " " + model_array[i].origin[2] + "\"" );
		fprintln( file, "\"model\" \"" + model_array[i].model + "\"" );
		fprintln( file, "\"classname\" \"" + classname + "\"" );
		fprintln( file, "}" );
		fprintln( file, "" );
	}

	saved = CloseFile( file );
	assertex( saved == 1, "File not saved (see above message?): " + level.fullpath_file );

	if( saved )
	{
		return level.fullpath_file;
	}
	else
	{
		return "failed";
	}	
#/
}

save_buttons()
{
	clear_universal_buttons( "save" );

	if( level.xenon )
	{
		add_universal_button( "save", "button_x" );
		add_universal_button( "save", "button_b" );
	}

	add_universal_button( "save", "n" );
	add_universal_button( "save", "y" );

	level thread universal_input_loop( "save", "stop_savebutton_loop" );
}

save_selected_group()
{
	if( !IsDefined( level.dyn_ent_selected_group ) )
	{
		return "ERROR: Group not Selected!";
	}

	ents = GetEntArray( level.dyn_ent_selected_group, "targetname" );
	return save_master( "Save Selected Dyn_Ent Group?", "dyn_ent_group", ents );
}