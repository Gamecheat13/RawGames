#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;

init_once()
{
	PrecacheShader( "white" );

	dyn_models = GetDynModels();	
	dyn_models = [];	// Disable temporarily. the levels were exceeding the MAX_MODELS limit, because we precache all misc and dyn models here
	for( i = 0; i < dyn_models.size; i++ )
	{
		if( isdefined( dyn_models[i] ) )
		{
			PrecacheModel( dyn_models[i] );
		}
	}
	
	misc_models = GetMiscModels();
	misc_models = [];	// Disable temporarily. the levels were exceeding the MAX_MODELS limit, because we precache all misc and dyn models here
	for( i = 0; i < misc_models.size; i++ )
	{
		if( isdefined( misc_models[i] ) )
		{
			PrecacheModel( misc_models[i] );
		}
	}
	
	level.model_names["dynent"] = [];
	level.model_names["destructible"] = [];
	level.model_names["miscmodel"] = [];
	
	level.models["dynent"] = [];
	level.models["destructible"] = [];
	level.models["miscmodel"] = [];
	
	level.dynent_groups = [];	
	level.all_objects = [];
	
	setup_groups();

	dyn_models = GetDynModels();
	dyn_models = [];	// Disable temporarily. the levels were exceeding the MAX_MODELS limit, because we precache all misc and dyn models here	
	for( i = 0; i < dyn_models.size; i++ )
	{
		if( isdefined( dyn_models[i] ) )
		{
			add_model_to_group( dyn_models[i] );
			add_name( dyn_models[i], "dynent" );
		}
	}

	misc_models = GetMiscModels();
	misc_models = [];	// Disable temporarily. the levels were exceeding the MAX_MODELS limit, because we precache all misc and dyn models here
	for( i = 0; i < misc_models.size; i++ )
	{
		add_name( misc_models[i], "miscmodel" );
	}
	
	destructible_defs = GetDestructibleDefs();	
	for( i = 0; i < destructible_defs.size; i++ )
	{
		add_name( destructible_defs[i], "destructible" );
	}
}

main()
{
	while( GetDvar( "propman" ) != "1" )
	{
		wait 1;
	}
	
	if( !isdefined( level.script ) )
	{
		level.script = ToLower( GetDvar( "mapname" ) );	
	}
	waittillframeend;
	
	wait 1;
	
	wait_for_first_player();
	
	players = get_players();
	level.debug_player = players[0];	

	// Setup the default save path/files
	level set_default_path();

	// Display the cursor, copied from _createfx
	level set_crosshair();
	
	level init();

	level setup_menus();

	level setup_menu_buttons();

	level thread menu_input();
	
	level setup_xform_menu();
}

set_crosshair()
{
	crossHair = NewDebugHudElem();
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

setup_groups()
{
	level.model_group_map = [];
	level.dynent_groups = [];
	level.groups = [];
	
	level.model_group_map["p_glo_gascan"] = "p_glo";
	level.model_group_map["p_glo_cinder_block"] = "p_glo";

	level.model_group_map["p_jun_fruit_apple"] = "fruits";
	level.model_group_map["p_jun_fruit_pineapple"] = "fruits";
}

add_to_group( group, model )
{
	if( isdefined( level.groups[group] ) )
	{
		if( check_for_dupes( level.groups[group], model ) )
		{
			level.groups[group][level.groups[group].size] = model;
		}
	}
	else
	{
		level.dynent_groups[level.dynent_groups.size] = group;
		level.groups[group][0] = model;
	}
}

add_model_to_group( model )
{
	if( isdefined( level.model_group_map[model] ) )
	{
		add_to_group( level.model_group_map[model], model );
	}
	else
	{
		add_to_group( "miscmodel", model );
	}
}

init()
{
	level.highlighted = [];
	level.rotate_highlighted = [];
}

add_to_dynent_group( dynent_name )
{
	if( check_for_dupes( level.dynent_groups, dynent_name ) )
	{
		level.dynent_groups[level.dynent_groups.size] = dynent_name;
	}
}

add_to_all_objects()
{
	if( check_for_dupes( level.all_objects, self ) )
	{
		level.all_objects[level.all_objects.size] = self;
	}
}

remove_from_all_objects()
{
	if( level.all_objects.size > 0 )
	{	
		level.all_objects = array_remove( level.all_objects, self );	
	}
}

add_name( name, type )
{
	if( check_for_dupes( level.model_names[type], name ) )
	{
		level.model_names[type][level.model_names[type].size] = name;
	}
}

add_model( type )
{
	if( check_for_dupes( level.models[type], self ) )
	{
		level.models[type][level.models[type].size] = self;
	}
}

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

//---------//
// Menus   //
//---------//
setup_menus()
{
	level.menu_sys = [];
	level.menu_sys["current_menu"] = SpawnStruct();

	// main Menu
	add_menu( "choose_mode", "Choose Mode:" );
		add_menuoptions( "choose_mode", "Dyn Ents Mode" );
		add_menuoptions( "choose_mode", "Destructibles Mode" );
		add_menuoptions( "choose_mode", "Misc Models Mode" );
		add_menuoptions( "choose_mode", "Toggle Help Hud", ::toggle_xform_hud );
		add_menuoptions( "choose_mode", "Quit", ::quit );

		//////////////////////
		//
		// DYN ENTS MENU
		//
		//////////////////////
		
		add_menu_child( "choose_mode", "dynent_mode", "Dyn Ents Mode" );
			set_no_back_menu( "dynent_mode" );
			add_menuoptions( "dynent_mode", "Select Model", ::select_dynent_from_list );
			add_menuoptions( "dynent_mode", "Select Group", ::select_dynent_group );
			add_menuoptions( "dynent_mode", "Place Model", ::place_dynent );
			add_menuoptions( "dynent_mode", "Place Copy", ::place_dynent_copy );
			add_menuoptions( "dynent_mode", "Spray Selected", ::spray_model );
			add_menuoptions( "dynent_mode", "Select Mode" );
			add_menuoptions( "dynent_mode", "Save", ::save_dynents );
			add_menuoptions( "dynent_mode", "Back", ::selected_back );

			// Select Mode
			add_menu_child( "dynent_mode", "dynent_select_menu", "Dyn Ents->Select Mode:", 5, ::select_dynents );
				add_menuoptions( "dynent_select_menu", "Move" );
				add_menuoptions( "dynent_select_menu", "Copy" );
				add_menuoptions( "dynent_select_menu", "Delete", ::delete_model );
				add_menuoptions( "dynent_select_menu", "Save" );
					// Move Menu
					add_menu_child( "dynent_select_menu", "dynent_move_menu", "Dyn Ents->Move Selected:", 0, ::move_model );
					set_no_back_menu( "dynent_move_menu" );
						add_menuoptions( "dynent_move_menu", "Place Model", ::place_dynent );
						add_menuoptions( "dynent_move_menu", "Copy Model", ::place_dynent_copy );
						add_menuoptions( "dynent_move_menu", "Back", ::selected_back );
		
					// Copy Menu
					add_menu_child( "dynent_select_menu", "dynent_copy_menu", "Dyn Ents->Copy Selected:", 1, ::copy_dynent );
					set_no_back_menu( "dynent_copy_menu" );
						add_menuoptions( "dynent_copy_menu", "Place Model", ::place_dynent );
						add_menuoptions( "dynent_copy_menu", "Place Copy", ::place_dynent_copy );
						add_menuoptions( "dynent_copy_menu", "Back", ::selected_back );

					add_menu_child( "dynent_select_menu", "selected_dynent_save_menu", "Dyn Ents->Save Selected:", 3, ::selected_dynent_save );
						add_menuoptions( "selected_dynent_save_menu", "Highlight", ::selected_save_highlight );
						add_menuoptions( "selected_dynent_save_menu", "Save Selected", ::save_dynent_highlighted );
				
			
		//////////////////////
		//
		// DESTRUCTIBLES MENU
		//
		//////////////////////

		add_menu_child( "choose_mode", "destructible_mode", "Destructibles Mode" );
			add_menuoptions( "destructible_mode", "Select Model", ::select_destructible_from_list );
			add_menuoptions( "destructible_mode", "Place Model", ::place_destructible );
			add_menuoptions( "destructible_mode", "Place Copy", ::place_destructible_copy );
			add_menuoptions( "destructible_mode", "Select Mode" );
			add_menuoptions( "destructible_mode", "Save", ::save_destructibles );

			// Select Mode
			add_menu_child( "destructible_mode", "destructible_select_menu", "Destructibles->Select Mode:", 3, ::select_destructibles );
				add_menuoptions( "destructible_select_menu", "Move" );
				add_menuoptions( "destructible_select_menu", "Copy" );
				add_menuoptions( "destructible_select_menu", "Delete", ::delete_model );
				add_menuoptions( "destructible_select_menu", "Save" );
					// Move Menu
					add_menu_child( "destructible_select_menu", "destructible_move_menu", "Destructibles->Move Selected:", 0, ::move_model );
					set_no_back_menu( "destructible_move_menu" );
						add_menuoptions( "destructible_move_menu", "Place Model", ::place_destructible );
						add_menuoptions( "destructible_move_menu", "Copy Model", ::place_destructible_copy );
						add_menuoptions( "destructible_move_menu", "Back", ::selected_back );
		
					// Copy Menu
					add_menu_child( "destructible_select_menu", "destructible_copy_menu", "Destructibles->Copy Selected:", 1, ::copy_destructible );
					set_no_back_menu( "destructible_copy_menu" );
						add_menuoptions( "destructible_copy_menu", "Place Model", ::place_destructible );
						add_menuoptions( "destructible_copy_menu", "Place Copy", ::place_destructible_copy );
						add_menuoptions( "destructible_copy_menu", "Back", ::selected_back );

					add_menu_child( "destructible_select_menu", "selected_destructible_save_menu", "Destructibles->Save Selected:", 3, ::selected_destructible_save );
						add_menuoptions( "selected_destructible_save_menu", "Highlight", ::selected_save_highlight );
						add_menuoptions( "selected_destructible_save_menu", "Save Selected", ::save_destructible_highlighted );
			
		//////////////////////
		//
		// MISCMODELS MENU
		//
		//////////////////////

		add_menu_child( "choose_mode", "miscmodel_menu", "Misc Models Mode" );
				add_menuoptions( "miscmodel_menu", "Select Model", ::select_miscmodel_from_list );
				add_menuoptions( "miscmodel_menu", "Place Model", ::place_miscmodel );
				add_menuoptions( "miscmodel_menu", "Place Copy", ::place_miscmodel_copy );
				add_menuoptions( "miscmodel_menu", "Select Mode" );
				add_menuoptions( "miscmodel_menu", "Save", ::save_miscmodels );

				// Select Mode
				add_menu_child( "miscmodel_menu", "miscmodel_select_menu", "Misc Model->Select Mode:", 3, ::select_miscmodels );
					add_menuoptions( "miscmodel_select_menu", "Move" );
					add_menuoptions( "miscmodel_select_menu", "Copy" );
					add_menuoptions( "miscmodel_select_menu", "Delete", ::delete_model );
					add_menuoptions( "miscmodel_select_menu", "Save" );
						// Move Menu
						add_menu_child( "miscmodel_select_menu", "miscmodel_move_menu", "Misc Model->Move Selected:", 0, ::move_model );
						set_no_back_menu( "miscmodel_move_menu" );
							add_menuoptions( "miscmodel_move_menu", "Place Model", ::place_miscmodel );
							add_menuoptions( "miscmodel_move_menu", "Copy Model", ::place_miscmodel_copy );
							add_menuoptions( "miscmodel_move_menu", "Back", ::selected_back );
			
						// Copy Menu
						add_menu_child( "miscmodel_select_menu", "miscmodel_copy_menu", "Misc Model->Copy Selected:", 1, ::copy_miscmodel );
						set_no_back_menu( "miscmodel_copy_menu" );
							add_menuoptions( "miscmodel_copy_menu", "Place Model", ::place_miscmodel);
							add_menuoptions( "miscmodel_copy_menu", "Place Copy", ::place_miscmodel_copy );
							add_menuoptions( "miscmodel_copy_menu", "Back", ::selected_back );

						add_menu_child( "miscmodel_select_menu", "selected_miscmodel_save_menu", "Misc Model->Save Selected:", 3, ::selected_miscmodel_save );
							add_menuoptions( "selected_miscmodel_save_menu", "Highlight", ::selected_save_highlight );
							add_menuoptions( "selected_miscmodel_save_menu", "Save Selected", ::save_miscmodel_highlighted );

	enable_menu( "choose_mode" );
}

//----------------------------------------------------------//
// add_menu( <menu_name>, <title> )							//
//		Creates a menu										//
//----------------------------------------------------------//
// self 		- n/a										//
// menu_name 	- The registered name used for reference	//
// title 		- Name of menu when it's displayed			//
//----------------------------------------------------------//
add_menu( menu_name, title )
{
	if( isdefined( level.menu_sys[menu_name] ) )
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
//add_menuoptions( menu_name, option_text, func, key )
add_menuoptions( menu_name, option_text, func )
{
	if( !isdefined( level.menu_sys[menu_name].options ) )
	{
		level.menu_sys[menu_name].options = [];
	}

	num = level.menu_sys[menu_name].options.size;
	level.menu_sys[menu_name].options[num] = option_text;
	level.menu_sys[menu_name].function[num] = func;
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
	if( !isdefined( level.menu_sys[child_menu] ) )
	{
		add_menu( child_menu, child_title );
	}

	level.menu_sys[child_menu].parent_menu = parent_menu;

	if( !isdefined( level.menu_sys[parent_menu].children_menu ) )
	{
		level.menu_sys[parent_menu].children_menu = [];
	}

	if( !isdefined( child_number_override ) )
	{
		size = level.menu_sys[parent_menu].children_menu.size;
	}
	else
	{
		size = child_number_override;
	}

	level.menu_sys[parent_menu].children_menu[size] = child_menu;

	if( isdefined( func ) )
	{
		if( !isdefined( level.menu_sys[parent_menu].children_func ) )
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

	if( isdefined( level.menu_cursor ) )
	{
		level.menu_cursor.y = 130;
		level.menu_cursor.current_pos = 0;
	}

	// Set the title
	level.menu_sys["current_menu"].title = set_menu_hudelem( level.menu_sys[menu_name].title, "title" );

	// Set the Options
	level.menu_sys["current_menu"].menu_name = menu_name;

	back_option_num = 0; // Used for the "back" option
	if( isdefined( level.menu_sys[menu_name].options ) )
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
	if( isdefined( level.menu_sys[menu_name].parent_menu ) && !isdefined( level.menu_sys[menu_name].no_back ) )
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
	if( isdefined( level.menu_sys[menu_name] ) )
	{
		if( isdefined( level.menu_sys[menu_name].title ) )
		{
			level.menu_sys[menu_name].title Destroy();
		}
	
		if( isdefined( level.menu_sys[menu_name].options ) )
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
	const x = 10;
	y = 100;
	if( isdefined( type ) && type == "title" )
	{
		scale = 2;
	}
	else // Default to Options
	{
		scale = 1.3;
		y = y + 30;
	}

	if( !isdefined( y_offset ) )
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
	if( !isdefined( alpha ) )
	{
		alpha = 1;
	}

	if( !isdefined( scale ) )
	{
		scale = 1;
	}

	hud = NewDebugHudElem();
	
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

	if( isdefined( text ) )
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
	level endon( "stop_createdynents" );

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
			else
			{	// wrap around
				level.menu_cursor.y = 130 + 20 * ( level.menu_sys["current_menu"].options.size - 1 );
				level.menu_cursor.current_pos = level.menu_sys["current_menu"].options.size - 1;
			}
			continue;
		}
		else if( keystring == "dpad_down" || keystring == "downarrow" )
		{
			if( level.menu_cursor.current_pos < level.menu_sys["current_menu"].options.size - 1 )
			{
				level.menu_cursor.y = level.menu_cursor.y + 20;
				level.menu_cursor.current_pos++;
			}
			else
			{	// wrap around
				level.menu_cursor.y = 130;
				level.menu_cursor.current_pos = 0;
			}
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
		else if( isdefined( level.menu_sys[menu_name].parent_menu ) && key == level.menu_sys[menu_name].options.size )
		{
			// This is if the "back" key is hit.
			level notify( "disable " + menu_name );
			level enable_menu( level.menu_sys[menu_name].parent_menu );
		}
		else if( isdefined( level.menu_sys[menu_name].function ) && isdefined( level.menu_sys[menu_name].function[key] ) )
		{
			level.menu_sys["current_menu"].options[key] thread hud_selector( level.menu_sys["current_menu"].options[key].x, level.menu_sys["current_menu"].options[key].y );

			if( isdefined( level.menu_sys[menu_name].func_key ) && isdefined( level.menu_sys[menu_name].func_key[key] ) && level.menu_sys[menu_name].func_key[key] == keystring )
			{
				error_msg = level [[level.menu_sys[menu_name].function[key]]]();
			}
			else
			{
				error_msg = level [[level.menu_sys[menu_name].function[key]]]();
			}

			level thread hud_selector_fade_out();

			if( isdefined( error_msg ) )
			{
				level thread selection_error( error_msg, level.menu_sys["current_menu"].options[key].x, level.menu_sys["current_menu"].options[key].y );
			}
		}
		if( !isdefined( level.menu_sys[menu_name].children_menu ) )
		{
			continue;
		}
		else if( !isdefined( level.menu_sys[menu_name].children_menu[key] ) )
		{
			continue;
		}
		else if( !isdefined( level.menu_sys[level.menu_sys[menu_name].children_menu[key]] ) )
		{
			continue;
		}

		if( isdefined( level.menu_sys[menu_name].children_func ) && isdefined( level.menu_sys[menu_name].children_func[key] ) )
		{
			func = level.menu_sys[menu_name].children_func[key];
			error_msg = [[func]]();

			if( isdefined( error_msg ) )
			{
				level thread selection_error( error_msg, level.menu_sys["current_menu"].options[key].x, level.menu_sys["current_menu"].options[key].y );
				continue;
			}
		}

		level enable_menu( level.menu_sys[menu_name].children_menu[key] );
	}
}

force_menu_back()
{
	level endon( "stop_createdynents" );

	wait( 0.1 );
	menu_name = level.menu_sys["current_menu"].menu_name;
	key = level.menu_sys[menu_name].options.size;
	key++;
	
	keys[1] = "1";
	keys[2] = "2";	
	keys[3] = "3";
	keys[4] = "4";	
	keys[5] = "5";
	keys[6] = "6";	
	keys[7] = "7";
	keys[8] = "8";	
	keys[9] = "9";
	
	if( key > 0 && key < 10 )
		key = keys[key];

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
	const space_apart = 15;
	for( i = 0; i < list.size; i++ )
	{
		alpha = 1 / ( i + 1 );

		if( alpha < 0.2 )
		{
			alpha = 0.1;
		}

		hud = set_hudelem( list[i], x, y + ( i * space_apart ), scale, alpha );
		ARRAY_ADD( hud_array, hud );
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
	const time = 0.1;
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

		if( alpha < 0.2 )
		{
			alpha = 0.1;
		}

		hud_array[i] FadeOverTime( time );
		hud_array[i].alpha = alpha;		
	}
}

hud_selector( x, y )
{
	level endon( "stop_createdynents" );

	if( isdefined( level.hud_selector ) )
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
	level endon( "stop_createdynents" );

	if( !isdefined( time ) )
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
	level endon( "stop_createdynents" );

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
	level endon( "stop_createdynents" );
	self notify( "stop_fontscaler" );
	self endon( "death" );
	self endon( "stop_fontscaler" );

	og_scale = self.og_scale;

	if( !isdefined( mult ) )
	{
		mult = 1.5;
	}

	self.fontscale = og_scale * mult;
	dif = og_scale - self.fontscale;
	const time = 1;

	dif /= time * 20;

	for( i = 0; i < time * 20; i++ )
	{
		self.fontscale += dif;
		wait( 0.05 );
	}
}

update_selected_object_position()
{
	object = level.selected_object;
	if( isdefined( object ) )
	{
		forward = AnglesToforward( level.debug_player GetPlayerAngles() );
		vector = level.debug_player GetEye() + VectorScale( forward, 5000 );
		trace = BulletTrace( level.debug_player GetEye(), vector, false, self );

		if( trace["fraction"] != 1 )
		{
			vector = trace["position"] + ( 0, 0, level.selected_object_z_offset );
			if( vector != object.origin )
			{
				object MoveTo( vector, 0.1 );
				object waittill( "movedone" );
			}
		}
		wait( 0.1 );
	}
}

move_selected_object( with_trace )
{
	level endon( "stop_createdynents" );
	self notify( "stop_move_selected_object" );
	self endon( "stop_move_selected_object" );
	self endon( "unlink_selected_object" );
	self endon( "death" );

	if( !isdefined( with_trace ) )
	{
		with_trace = false;
	}

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

			vector = vector + ( 0, 0, level.selected_object_z_offset );
		}
		else
		{
			vector = level.debug_player GetEye() + VectorScale( forward, level.selected_object_dist );
		}

		if( vector != self.origin )
		{
			self MoveTo( vector, 0.1 );
			self waittill( "movedone" );
		}
		else
		{
			wait( 0.1 );
		}
	}
}

get_random_model()
{
	count = level.groups[level.selected_group].size;
	return level.groups[level.selected_group][randomintrange( 0, count )];
}

spray_model()
{
	level.spray = [];
	if( isdefined( level.selected_object ) && !isdefined( level.selected_group ) )
	{
		level.spray = [];
		level.spray["model"] = level.selected_object.model;
		level.selected_object Delete();		
	}
	else
	{
		if( isdefined( level.selected_group ) )
		{
			level.spray = [];
			level.spray["model"] = get_random_model();
			if( isdefined( level.selected_object ) )
			{
				level.selected_object Delete();
				level.selected_object = undefined;
			}
		}
		else
		{
			return "ERROR: Select Model or Group first!";
		}
	}

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
			
			if( isdefined( level.selected_group ) )
			{
				level.spray["model"] = get_random_model();
				level.spray_hud["model"] SetText( level.spray["model"] );
				level.spray_hud["model"] thread hud_font_scaler();
			}
			
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
		else if( key == "button_lshldr" || key == "button_rshldr" )
		{
			if( isdefined( level.selected_group ) )
			{
				level.spray["model"] = get_random_model();
				level.spray_hud["model"] SetText( level.spray["model"] );
				level.spray_hud["model"] thread hud_font_scaler();
				wait( 0.05 );
			}
		}		
		else if( key == "end" || key == "button_b" ) // Quit out of this.
		{
			break;
		}
	}

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

	//object MoveGravity( velocity, 1 );
	object PhysicsLaunch( object.origin, velocity );

	object store_model( "dynent" );
}

spray_trajectory()
{
	level endon( "stop_createdynents" );
	level endon( "stop_spray" );

	const segments = 10;
	const time = 1.0;
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
		gravity = GetDvarint( "bg_gravity" );
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

	const x = 0;
	const y = 400;
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

	new_hud( "spray_hud", "FIRE", x + 5, y + 10, 1 );
	new_hud( "spray_hud", "LEFT/RIGHT", x + 5, y + 20, 1 );
	new_hud( "spray_hud", "UP/DOWN", x + 5, y + 30, 1 );
	if( isdefined( level.selected_group ) )
	{
		new_hud( "spray_hud", "Bumpers", x + 5, y + 40, 1 );
		new_hud( "spray_hud", "B", x + 5, y + 50, 1 );
	}
	else
	{
		new_hud( "spray_hud", "B", x + 5, y + 40, 1 );
	}


	new_hud( "spray_hud", "- Spray Object", x + 60, y + 10, 1 );
	new_hud( "spray_hud", "- Inc/Dec Rate", x + 60, y + 20, 1 );
	new_hud( "spray_hud", "- Inc/Dec Power", x + 60, y + 30, 1 );
	if( isdefined( level.selected_group ) )
	{
		new_hud( "spray_hud", "- Change model", x + 60, y + 40, 1 );	
		new_hud( "spray_hud", "- Quit", x + 60, y + 50, 1 );
	}
	else
	{
		new_hud( "spray_hud", "- Quit", x + 60, y + 40, 1 );
	}
}

spray_buttons()
{
	clear_universal_buttons( "spray" );

	add_universal_button( "spray", "dpad_up" );
	add_universal_button( "spray", "dpad_down" );
	add_universal_button( "spray", "dpad_left" );
	add_universal_button( "spray", "dpad_right" );
	add_universal_button( "spray", "button_b" );
	add_universal_button( "spray", "button_lshldr" );
	add_universal_button( "spray", "button_rshldr" );

	level thread universal_input_loop( "spray", "stop_spray", true );
}

//-----------------//
// Universal Input //
//-----------------//
add_universal_button( button_group, name )
{
	if( !isdefined( level.u_buttons[button_group] ) )
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
	level endon( "stop_createdynents" );
	level endon( end_on );

	if( !isdefined( use_attackbutton ) )
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

		if( isdefined( mod_button ) && !level.debug_player ButtonPressed( mod_button ) )
		{
			wait( 0.05 );
			continue;
		}
		else if( isdefined( no_mod_button ) && level.debug_player ButtonPressed( no_mod_button ) )
		{
			wait( 0.05 );
			continue;
		}

		if( use_attackbutton && level.debug_player AttackButtonPressed() )
		{
			level notify( notify_name, "fire" );
			wait( 0.15 );
			continue;
		}

		for( i = 0; i < buttons.size; i++ )
		{
			if( level.debug_player ButtonPressed( buttons[i] ) )
			{
				level notify( notify_name, buttons[i] );
				wait( 0.15 );
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

select_dynent_group()
{
	level.dyn_ent_selected_group = undefined;

	y = level.menu_sys["current_menu"].options[0].y;

	if( !isdefined( level.dynent_groups ) )
	{
		return;
	}

	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	selected = list_menu( level.dynent_groups, 180, y, 1.3, ::group_selected );

	if( !isdefined( selected ) )
	{
		level notify( "stop_select_group" );
	}
	else
	{
		level.dyn_ent_selected_group = level.dynent_groups[selected];
	}

	arrow_hud Destroy();
}

group_selected( group_name )
{
	level.selected_group = group_name;
}

remove_hud( hud_name )
{
	if( !isdefined( level.hud_array[hud_name] ) )
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
	if( !isdefined( level.hud_array ) )
	{
		level.hud_array = [];
	}

	if( !isdefined( level.hud_array[hud_name] ) )
	{
		level.hud_array[hud_name] = [];
	}

	hud = set_hudelem( msg, x, y, scale );
	level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
	return hud;
}

object_highlight( objects )
{
	level endon( "stop_createdynents" );
	level endon( "stop_select_model" );

	dot = 0.85;
	highlighted_object = undefined;

	forward = AnglesToForward( level.debug_player GetPlayerAngles() );
	for( i = 0; i < objects.size; i++ )
	{
		// For newly added ents
		if( !isdefined( objects[i].select_scale ) )
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

	if( isdefined( highlighted_object ) )
	{
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

selected_delete( no_force_back )
{
	if( isdefined( level.selected_object ) )
	{
		level.selected_object remove_from_all_objects();
		level.selected_object remove_model( "dynent" );
		level.selected_object remove_model( "destructible" );
		level.selected_object remove_model( "miscmodel" );

		level.selected_object notify( "unlink_selected_object" );
		level.selected_object notify( "stop_move" );
		level.selected_object notify( "stop_move_selected_object" );
		level.selected_object Delete();
		level.selected_object = undefined;

		if( !isdefined( no_force_back ) || !no_force_back )
		{
			level thread force_menu_back();
		}
	}
}

selected_back()
{
	if( isdefined( level.selected_object ) )
	{
		if( isdefined( level.selected_object.old_origin ) )
		{
			level.selected_object notify( "unlink_selected_object" );
			level.selected_object.origin = level.selected_object.old_origin;
			level thread force_menu_back();
			level.selected_object = undefined;		
		}
		else
		{
			selected_delete();
		}
	}
	else
	{
		level thread force_menu_back();
	}
}

selected_save_highlight( key )
{
	if( isdefined( level.highlighted_object ) )
	{
		object = level.highlighted_object;

		if( isdefined( object.save_selected ) )
		{
			object remove_highlighted();
			object.save_selected = false;
			object notify( "stop_save_highlight" );
		}
		else
		{
			object add_highlighted();
			object.save_selected = true;
			object thread save_highlight_loop();
		}
		wait( 0.1 );
	}
}

save_highlight_loop()
{
	level endon( "stop_createdynents" );
	self endon( "stop_save_highlight" );
	while( 1 )
	{
		print3d( self.origin, "S", ( 0, 1, 0 ), 1 );
		wait( 0.05 );
	}
}

add_highlighted()
{
	level.highlighted[level.highlighted.size] = self;
}

remove_highlighted()
{
	level.highlighted = array_remove( level.highlighted, self );
}

selected_models_save_thread( type )
{
	level endon( "stop_createdynents" );

	level waittill( "disable selected_" + type + "_save_menu" );
	for( i = 0; i < level.models[type].size; i++ )
	{
		level.models[type][i] remove_save_stat();
	}
}

selected_dynent_save()
{
	level.highlighted = [];
	level thread selected_models_save_thread( "dynent" );
}

selected_destructible_save()
{
	level.highlighted = [];
	level thread selected_models_save_thread( "destructible" );
}

selected_miscmodel_save()
{
	level.highlighted = [];
	level thread selected_models_save_thread( "miscmodel" );
}

remove_save_stat()
{
	self notify( "stop_save_highlight" );
	self.save_selected = false;
}

save_dynent_highlighted()
{
	if( level.highlighted.size > 0 )
	{
		return save_master( "Save Selected DynEnts?", "dynents_selected", level.highlighted, "dynent" );	
	}
}

save_destructible_highlighted()
{
	if( level.highlighted.size > 0 )
	{
		return save_master( "Save Selected Destructibles?", "detructibles_selected", level.highlighted, "destructible" );
	}
}

save_miscmodel_highlighted()
{
	if( level.highlighted.size > 0 )
	{
		return save_master( "Save Selected Misc_Models?", "miscmodels_selected", level.highlighted, "miscmodel" );
	}
}

//---------------//
// Input Section //
//---------------//
setup_menu_buttons()
{
	clear_universal_buttons( "menu" );

	menu_cursor();

	add_universal_button( "menu", "dpad_up" );
	add_universal_button( "menu", "dpad_down" );
	add_universal_button( "menu", "dpad_left" );
	add_universal_button( "menu", "dpad_right" );
	add_universal_button( "menu", "button_a" );
	add_universal_button( "menu", "button_b" );

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

	add_universal_button( "menu", "enter" );
	add_universal_button( "menu", "end" );
	add_universal_button( "menu", "backspace" );

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

setup_xform_menu()
{
	level.selected_object_z_offset = 0;
	level.selected_object_dist = 48;
	
	setup_xform_buttons();
	
	level thread xform_input_handler();
	
	level.xform_hud_active = 0;
	toggle_xform_hud();
}

toggle_xform_hud()
{
	level.xform_hud_active = !level.xform_hud_active;
	if( level.xform_hud_active )
	{
		const shader_width = 120;
		const shader_height = 90;
		x = 640 - shader_width;
		y = 480 - shader_height - 25;
		hud = new_hud( "xform_hud", undefined, x, y, 1 );
		hud SetShader( "white", shader_width, shader_height );
		hud.alignX = "left";
		hud.alignY = "top";
		hud.sort = 10;
		hud.alpha = 0.6;	
		hud.color = ( 0.0, 0.0, 0.5 );
		
		new_hud( "xform_hud", "BUMPERS",	x + 5, y + 10, 1 );
		new_hud( "xform_hud", "Up / Down",	x + 60, y + 10, 1 );
		
		y += 3;

		new_hud( "xform_hud", "(HOLD LTrigger) +", x + 5, y + 20, 1 );

		y += 3;

		new_hud( "xform_hud", "Y/A",		x + 5, y + 30, 1 ); 
		new_hud( "xform_hud", "X/B",		x + 5, y + 40, 1 );
		new_hud( "xform_hud", "BUMPERS",	x + 5, y + 50, 1 );
		new_hud( "xform_hud", "L3",			x + 5, y + 60, 1 );


		new_hud( "xform_hud", "- Pitch",	x + 60, y + 30, 1 );
		new_hud( "xform_hud", "- Yaw",		x + 60, y + 40, 1 );
		new_hud( "xform_hud", "- Roll",		x + 60, y + 50, 1 );
		new_hud( "xform_hud", "- Zero Out",	x + 60, y + 60, 1 );
	
	}
	else
	{
		remove_hud( "xform_hud" );
	}
}

setup_xform_buttons()
{
	clear_universal_buttons( "xform" );

	add_universal_button( "xform", "button_a" );
	add_universal_button( "xform", "button_b" );
	add_universal_button( "xform", "button_x" );
	add_universal_button( "xform", "button_y" );
	add_universal_button( "xform", "button_lshldr" );
	add_universal_button( "xform", "button_rshldr" );
	add_universal_button( "xform", "button_lstick" );
	
	level thread universal_input_loop( "xform", "never", true );
}

xform_input_handler()
{
	level endon( "stop_createdynents" );

	const rate = 2;
	
	while( 1 )
	{
		level waittill( "xform_button_pressed", key );
		
		object = level.selected_object;
		if( !isdefined( object ) )
			object = level.highlighted_object;
		
		if( !level.debug_player ButtonPressed( "button_ltrig" ) )
		{
			if( key == "button_rshldr" )
			{
				level.selected_object_z_offset += 4;
				update_selected_object_position();
			}
			else if( key == "button_lshldr" )
			{
				level.selected_object_z_offset -= 4;
				update_selected_object_position();
			}
		}
		else if( isdefined( object )  )
		{
			if( key == "button_b" )
			{
				object DevAddYaw( rate );
			}
			else if( key == "button_x" )
			{
				object DevAddYaw( rate * -1 );
			}
			else if( key == "button_y" )
			{
				object DevAddPitch( rate * -1 );
			}
			else if( key == "button_a" )
			{
				object DevAddPitch( rate );
			}
			else if( key == "button_lshldr" )
			{
				object DevAddRoll( rate * -1 );
			}
			else if( key == "button_rshldr" )
			{
				object DevAddRoll( rate );
			}
			else if( key == "button_lstick" )
			{
				object.angles = ( 0, 0, 0 );
			}
		}
		
		wait( 0.1 );
	}
}
	
////////////////////////////////////
//
// PLACE AND PLACE COPY FUNCTIONS
//
////////////////////////////////////

place( type )
{
	if( isdefined( level.selected_object ) )
	{
		level.selected_object notify( "unlink_selected_object" );
		level notify( "stop_move" );
		level.selected_object add_model( type );
		level.selected_object = undefined;
	}
}

place_copy( type )
{
	if( isdefined( level.selected_object ) )
	{
		level.selected_object notify( "unlink_selected_object" );
		if( type == "destructible" )
		{
			model_name = level.selected_object getdestructiblename();
		}
		else
		{
			model_name = level.selected_object.model;
		}
			
		level.selected_object add_model( type );
		angles = level.selected_object.angles;
		level.selected_object = undefined;
		spawn_selected_object( model_name, true, type );
		level.selected_object.angles = angles;
	}
}

place_dynent()
{
	place( "dynent" ); 
}

place_destructible()
{
	place( "destructible" ); 
}

place_miscmodel()
{
	place( "miscmodel" ); 
}

place_dynent_copy()
{
	place_copy( "dynent" ); 
}

place_destructible_copy()
{
	place_copy( "destructible" ); 
}

place_miscmodel_copy()
{
	place_copy( "miscmodel" ); 
}

////////////////////////////////////
//
// SELECT FROM LIST FUNCTIONS
//
////////////////////////////////////

select_dynent_from_list()
{
	y = level.menu_sys["current_menu"].options[0].y;
	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	list_menu( level.model_names["dynent"], 180, y, 1.3, ::spawn_dynent );
	level.selected_group = undefined;
	arrow_hud Destroy();
}

select_destructible_from_list()
{
	y = level.menu_sys["current_menu"].options[0].y;
	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	list_menu( level.model_names["destructible"], 180, y, 1.3, ::spawn_destructible );
	level.selected_group = undefined;
	arrow_hud Destroy();
}

select_miscmodel_from_list()
{
	y = level.menu_sys["current_menu"].options[0].y;
	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	list_menu( level.model_names["miscmodel"], 180, y, 1.3, ::spawn_miscmodel );
	arrow_hud Destroy();
}

////////////////////////////////////
//
// SPAWN FUNCTIONS
//
////////////////////////////////////

spawn_selected_object( model_name, with_trace, type )
{
	if( isdefined( level.selected_object ) )
	{
		level.selected_object Delete();
	}

	forward = AnglesToforward( level.debug_player GetPlayerAngles() );
	vector = level.debug_player GetEye() + VectorScale( forward, level.selected_object_dist );
	if( isdefined( type ) && type == "destructible" )
	{
		level.selected_object = CodeSpawn( "script_model", vector, 0, 0, 0, model_name );
	}
	else
	{
		level.selected_object = Spawn( "script_model", vector );
		level.selected_object SetModel( model_name );
	}
	
	level.select_group = undefined;
	
	level.selected_object thread move_selected_object( with_trace );
}

spawn_dynent( model_name )
{
	spawn_selected_object( model_name, true, "dynent" );
}

spawn_miscmodel( model_name )
{
	spawn_selected_object( model_name, true, "miscmodel" );
}

spawn_destructible( model_name )
{
	spawn_selected_object( model_name, true, "destructible" );
}

////////////////////////////////////
//
// MOVE & COPY FUNCTIONS
//
////////////////////////////////////

move_model()
{
	if( isdefined( level.highlighted_object ) )
	{
		level.selected_object = level.highlighted_object;
		level.selected_object.old_origin = level.selected_object.origin;
		level.selected_object thread move_selected_object( true );
		level thread move_model_thread();
	}
}

move_model_thread()
{
	level endon( "stop_createdynents" );
	level waittill( "stop_move" );
	level thread force_menu_back();
}

copy_model( type )
{
	if( isdefined( level.highlighted_object ) )
	{
		model_origin = level.highlighted_object.origin;

		if( type == "destructible" )
		{
			model_name = level.highlighted_object getdestructiblename();
			level.selected_object = CodeSpawn( "script_model", model_origin, 0, 0, 0, model_name );
		}
		else
		{
			model_name = level.highlighted_object.model;
			level.selected_object = Spawn( "script_model", model_origin );
			level.selected_object SetModel( model_name );
		}
		
		level.selected_object.old_origin = level.selected_object.origin;
		level.selected_object thread move_selected_object( true );	

		level thread copy_thread();
	}
}

copy_dynent()
{
	copy_model( "dynent" );
}

copy_destructible()
{
	copy_model( "destructible" );
}

copy_miscmodel()
{
	copy_model( "miscmodel" );
}

copy_thread()
{
	level endon( "stop_createdynents" );
	level waittill( "stop_move" );
	level thread force_menu_back();
}

////////////////////////////////////
//
// SELECT FUNCTIONS
//
////////////////////////////////////

select_dynents()
{
	select( "dynent" );
}

select_destructibles()
{
	select( "destructible" );
}

select_miscmodels()
{
	select( "miscmodel" );
}

select( type )
{
	if( level.models[type].size > 0 )
	{
		level thread select_model_thread( type );
	}
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
	level endon( "stop_createdynents" );
	self endon( "death" );
	self notify( "only_one_icon_think_thread" );
	self endon( "only_one_icon_think_thread" );
	level endon( "stop_select_model" );

	if( !isdefined( self.select_scale ) )
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

delete_model()
{
	if( isdefined( level.highlighted_object ) )
	{
		level.highlighted_object remove_from_all_objects();
		level.highlighted_object remove_model( "dynent" );
		level.highlighted_object remove_model( "destructible" );
		level.highlighted_object remove_model( "miscmodel" );
		level.highlighted_object Delete();
		level.selected_object = undefined;
	}	
}

select_model_thread( type )
{
	level endon( "stop_createdynents" );

	selected_delete( true );

	level.unselected_color 	= ( 1, 1, 1 );
	level.selected_color	= ( 1, 1, 0 );

	draw_selectables( level.models[type] );
	level thread select_main_thread( type );
	
	level waittill( "disable " + type + "_select_menu" );
	level notify( "stop_select_model" );
}

select_main_thread( type )
{
	level endon( "stop_createdynents" );
	level endon( "stop_select_model" );

	level.highlighted_object = undefined;
	level.selected_object = undefined;

	while( 1 )
	{
		if( !isdefined( level.selected_object ) )
		{
			level thread object_highlight( level.models[type] );
		}
		wait( 0.05 );
	}
}

////////////////////////////////////
//
// SAVE FUNCTIONS
//
////////////////////////////////////

set_default_path()
{
	if( !isdefined( level.path ) )
	{
		level.path = "prop_man/" + level.script + "/";
	}
}

store_model( type )
{
	self add_to_all_objects();
	ARRAY_ADD( level.models[type], self );
}

remove_model( type )
{
	level.models[type] = array_remove( level.models[type], self );
}

save_dynents()
{
	if( level.models["dynent"].size > 0 )
	{
		return save_master( "Save All DynEnts?", "dynents_all", level.models["dynent"], "dynent" );
	}
}

save_destructibles()
{
	if( level.models["destructible"].size > 0 )
	{
		return save_master( "Save All Destructibles?", "destructibles_all", level.models["destructible"], "destructible" );
	}
}

save_miscmodels()
{
	selected_delete( true );

	if( level.models["miscmodel"].size > 0 )
	{
		return save_master( "Save All misc models?", "miscmodels_all", level.models["miscmodel"], "miscmodel" );
	}
}

save_master( save_msg, filename, save_array, type )
{
	disable_buttons( "menu" );
	disable_buttons( "rotate" );
	disable_buttons( "prop" );

	level.debug_player FreezeControls( true );

	save_buttons();
	filename = filename + ".map";
	save_dialog( save_msg, filename );

	yes_key = "button_x";
	no_key = "button_b";

	while( true )
	{
		level waittill( "save_button_pressed", key );

		if( key == yes_key )
		{
			level thread save_selector( level.save_yes_hud.x, level.save_yes_hud.y, 40 );
	
			check = save( save_array, filename, type );

			if( isdefined( check ) && check != "failed" )
			{
				level thread save_complete( check );
			}
			else
			{
				level thread save_failed();
			}

			break;
		}
		else if( key == no_key )
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
	if( !isdefined( level.save_hud_x ) )
	{
		level.save_hud_x = 0;
	}

	if( !isdefined( level.save_hud_y ) )
	{
		level.save_hud_y = 300;
	}

	x = level.save_hud_x;
	y = level.save_hud_y;

	const bg1_shader_width = 640;
	const bg1_shader_height = 100;

	hud = new_hud( "save", undefined, ( x + ( bg1_shader_width * 0.5 ) ), y, 1 );
	hud SetShader( "white", bg1_shader_width, bg1_shader_height );
	hud.alignX = "center";
	hud.alignY = "top";
	hud.color = ( 0.55, 0.29, 0 );
	hud.alpha = 0.85;
	hud.sort = 30;

	const bg2_shader_width = 280;
	const bg2_shader_height = 20;

	hud = new_hud( "save", msg, ( x + 10 ), ( y + 10 ), 1.3 );
	hud.sort = 35;
	prefix = "Path: xenonOutput/scriptdata/";

	hud = new_hud( "save",  prefix + level.path + filename, ( x + 10 ), ( y + 30 ), 1.1 );
	hud.sort = 35;

	yes_hud = "Yes [X]";
	no_hud = "No [B]";

	level.save_yes_hud = new_hud( "save", yes_hud, ( x + ( bg1_shader_width * 0.5 ) ) - 50, ( y + 90 ), 1.3 );
	level.save_yes_hud.alignX = "center";
	level.save_yes_hud.sort = 35;

	level.save_no_hud = new_hud( "save", no_hud, ( x + ( bg1_shader_width * 0.5 ) ) + 50, ( y + 90 ), 1.3 );
	level.save_no_hud.alignX = "center";
	level.save_no_hud.sort = 35;
}

destroy_hud( hud )
{
	if( isdefined( hud ) )
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

save( model_array, filename, type )
{
/#
	level.fullpath_file = level.path + filename;

	// Default type to dynents
	if( !isdefined( type ) )
	{
		type = "dynent";
	}
	
	spawnflags = 0;
	if( type == "dynent" )
		spawnflags = 1;

	file = OpenFile( level.fullpath_file, "write" );
	assert( file != -1, "File not writeable (maybe you should check it out): " + level.fullpath_file );
	
	fprintln( file, "// entity 0" );
	fprintln( file, "{" );
	fprintln( file, "\"classname\" \"worldspawn\"" );
	fprintln( file, "}" );
	
	if( type == "dynent" )
		classname = "dyn_model";
	else
		classname = "misc_model";

	for( i = 0; i < model_array.size; i++ )
	{
		fprintln( file, "{" );
		fprintln( file, "\"angles\" \"" + model_array[i].angles[0] + " " + model_array[i].angles[1] + " " + model_array[i].angles[2] + "\"" );
		fprintln( file, "\"origin\" \"" + model_array[i].origin[0] + " " + model_array[i].origin[1] + " " + model_array[i].origin[2] + "\"" );
		if( type == "destructible" )
		{
			fprintln( file, "\"model\" \"" + model_array[i].model + "\"" );
			fprintln( file, "\"classname\" \"script_model\"" );
			ddef = model_array[i] getdestructiblename();
			fprintln( file, "\"destructibledef\" \"" + ddef + "\"" );
		}
		else
		{
			fprintln( file, "\"model\" \"" + model_array[i].model + "\"" );
			if( spawnflags == 1 )
				fprintln( file, "\"spawnflags\" \"2\"" );
			fprintln( file, "\"classname\" \"" + classname + "\"" );
		}
		fprintln( file, "}" );
		fprintln( file, "" );
	}

	saved = CloseFile( file );
	assert( saved == 1, "File not saved (see above message?): " + level.fullpath_file );

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

	add_universal_button( "save", "button_x" );
	add_universal_button( "save", "button_b" );

	level thread universal_input_loop( "save", "stop_savebutton_loop" );
}

quit()
{
	if( level.xform_hud_active )
		toggle_xform_hud();
		
	level.hud_selector Destroy();
		
	disable_menu( "current_menu" );	
	
	level.menu_sys = [];
	
	AddDebugCommand( "set propman 0" );
	
	wait 1;
	
	AddDebugCommand( "noclip" );
	
	wait 1;
	
	thread main();
	
	level notify( "stop_createdynents" );
}
