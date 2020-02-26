// MikeD (3/20/2007): This script enables you to define camera movement within the game.

//HIGH PRIORITY:
//    * creation of special camera entity – Code
//    * Insert/Delete camera nodes – Script
//    * Spline paths – Code
//    * Lerping of all camera attributes through node points – Script
//    * Target objects, points, splines – Code
//    * Being able to stop/interrupt a playback - Script
//
//LOWER PRIORITY:
//    * camera roll – Script
//    * Clean cuts – Code/Script
//    * Locking camera axis (independently) – Script
//    * Shaky cam – Code
//    * Camera Lens mappings – Script
//    * Copy shots – Script
//    * Full screen FX (blurs, fades, color shifts, shaders, depth of field, etc.) – Code
//    * Editing of shots as independent elements.  Creation of scene list from shots. - Script
//
// WISH LIST:
//    * cross fades


#include maps\_utility;
#include maps\_createmenu;
#include maps\_camsys;
main()
{
/#
	PrecacheModel( "temp_camera" );
	if( GetDvar( "createcam" ) != "1" )
	{
		return;
	}

	if( !IsDefined( level.xenon ) )
	{
		level.xenon = ( GetDvar( "xenonGame" ) == "true" );
	}

	if( !IsDefined( level.script ) )
	{
		level.script = Tolower( GetDvar( "Mapname" ) );	
	}

	if( !IsDefined( level.player ) )
	{
		players = get_players();
		level.player = players[0];
	}
	level thread remove_player_weapons();

	level.cam_scenes = [];

	PrecacheShader( "white" );
	level.cam_model_func = ::spawn_cam_model;

	// Setup the default save path/files
	level set_default_path();

	// Display the cursor, copied from _createfx
	level set_crosshair();

	// Setup and enable the menu system.
	level setup_menus();

	// Setup the buttons that will be used in the menu system.
	level setup_menu_buttons();

	// Capture button input.
	level thread maps\_createmenu::menu_input();
#/
}

remove_player_weapons()
{
/#
	wait( 0.05 );
	// Player does not need any weapons.
	level.player TakeallWeapons();
#/
}

set_crosshair()
{
/#
	// setup "crosshair"
	crossHair = NewHudElem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "middle";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 1;
	crossHair.x = 320;
	crossHair.y = 233;
	crossHair SetText(".");
#/
}

//--------------//
// Menu Section //
//--------------//

// Sets up the menus
setup_menus()
{
/#
	createmenu_init();

	// Root Menu
	add_menu( "select_mode", "Select Mode:" );
		add_menuoptions( "select_mode", "Record Mode" );
		add_menuoptions( "select_mode", "Edit Mode" );
		add_menuoptions( "select_mode", "Save Mode" );

		// Record Mode
		add_menu_child( "select_mode", "record_mode", "Record Mode:", undefined );
			add_menuoptions( "record_mode", "Start Recording" );
			add_menuoptions( "record_mode", "Playback Scene", ::playback_new_scene );
			add_menuoptions( "record_mode", "Name Scene", ::record_name_scene );
				// Start Recording
				add_menu_child( "record_mode", "start_recording", "Recording:", undefined, ::start_recording );
					add_menuoptions( "start_recording", "Place Camera Node", ::place_new_cam_node );

				// Playback Recording
//				add_menu_child( "record_mode", "playback_new_scene", "Playback Scene:", undefined, ::playback_new_scene );

		// Edit Mode
		add_menu_child( "select_mode", "edit_mode", "Edit Mode:", undefined, ::edit_mode );
			add_menuoptions( "edit_mode", "Select Scene", ::edit_select_scene );
			add_menuoptions( "edit_mode", "Playback Scene", ::edit_playback_scene );
			add_menuoptions( "edit_mode", "Delete Scene", ::edit_delete_scene );

		add_menu_child( "select_mode", "save_mode", "Save:", undefined, ::save_mode );
			add_menuoptions( "save_mode", "Save All", ::save_all );

	enable_menu( "select_mode" );

	level thread menu_cursor();
#/
}

// Sets up the buttons used to navigate the menus.
setup_menu_buttons()
{
/#
	clear_universal_buttons( "menu" );

	if( level.xenon )
	{
		add_universal_button( "menu", "dpad_up" );
		add_universal_button( "menu", "dpad_doown" );
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
#/
}

//----------------//
// Record Section //
//----------------//
start_recording()
{
/#
	level.recording_start = GetTime();
	remove_scene( "new" );
	level thread record_thread();
#/
}

record_thread()
{
/#
	level thread draw_scene_lines( "new" );
	level waittill( "disable start_recording" );
#/
}

place_new_cam_node()
{
/#
	if( !IsDefined( level.cam_scenes["new"] ) )
	{
		level.cam_scenes["new"] = [];
	}

	size = level.cam_scenes["new"].size;

	if( size == 0 )
	{
		time = 0;
		
	}
	else
	{
		time = GetTime() - level.cam_scenes["new"][size - 1]["time_stamp"];
	}

	create_cam_node( "new", level.player GetEye(), level.player GetPlayerAngles(), time, 0, 0 );
#/
}

playback_new_scene()
{
/#
//	level thread force_menu_back( "plackback_finished" );
	return playback_scene( "new" );
#/
}

record_name_scene()
{
/#
	if( !Isdefined( level.cam_scenes["new"] ) )
	{
		return "You need to create a scene first";
	}

	new_scene_name = name_scene( "new" );

	if( new_scene_name != "-1" )
	{
		copy_scene( "new", new_scene_name );
		remove_scene( "new" );
	}
#/	
}

name_scene( scene_name )
{
	players = get_players();
	players[0] FreezeControls( true );
	new_scene_name = dialog_text_box( "Enter a name for your scene", "(Keep it short and no spaces)", 8 );
	players[0] FreezeControls( false );

	return new_scene_name;
}

//--------------//
// Edit Section //
//--------------//
edit_mode()
{
/#
	level.cam_edit_scene = undefined;
	level.cam_edit_node_index = 0;

	level edit_mode_hud();
	level edit_mode_buttons();
	level thread edit_mode_node_highlight();
	level thread edit_mode_input();
	level thread edit_mode_thread();
#/
}

edit_mode_thread()
{
/#
	level waittill( "disable edit_mode" );

	level.cam_edit_scene = undefined;
	level.cam_edit_node_index = 0;

	remove_hud( "edit_mode_hud" );
#/
}

edit_mode_input()
{
/#
	level endon( "disable edit_mode" );

	while( 1 )
	{
		level waittill( "edit_mode_button_pressed", key );

		if( !IsDefined( level.cam_edit_scene ) )
		{
			continue;
		}

		scene_name = level.cam_edit_scene;
		if( key == "[" )
		{
			if( level.cam_edit_node_index == 0 )
			{
				level.cam_edit_node_index = level.cam_scenes[scene_name].size - 1;
			}
			else
			{
				level.cam_edit_node_index--;
			}
		}
		else if( key == "]" )
		{
			if( level.cam_edit_node_index == level.cam_scenes[scene_name].size - 1 )
			{
				level.cam_edit_node_index = 0;
			}
			else
			{
				level.cam_edit_node_index++;
			}
		}
		else if( key == "home" )
		{
			edit_adjust_accel_deccel( scene_name, "accel", 0.05 );
		}
		else if( key == "end" )
		{
			edit_adjust_accel_deccel( scene_name, "accel", -0.05 );
		}
		else if( key == "pgup" )
		{
			edit_adjust_accel_deccel( scene_name, "deccel", 0.05 );
		}
		else if( key == "pgdn" )
		{
			edit_adjust_accel_deccel( scene_name, "deccel", -0.05 );
		}
		else if( key == "ins" )
		{
			index = level.cam_edit_node_index;
			level.cam_scenes[scene_name][index]["time"] += 50;
		}
		else if( key == "del" )
		{
			index = level.cam_edit_node_index;
			level.cam_scenes[scene_name][index]["time"] -= 50;

			if( level.cam_scenes[scene_name][index]["time"] < 100 )
			{
				level.cam_scenes[scene_name][index]["time"] = 100;
			}
		}
		else if( key == "m" )
		{
			level edit_node_pos();
		}
		else if( key == "c" )
		{
			level edit_node_angles();
		}

		wait( 0.01 );
	}
#/
}

edit_node_pos()
{
/#
	level thread edit_help( "Press 'M' to set the current POS/ANGLE" );

	while( 1 )
	{
		level waittill( "edit_mode_button_pressed", key );
		if( key == "m" )
		{
			break;
		}

		wait( 0.01 );
	}

	index = level.cam_edit_node_index;
	scene_name = level.cam_edit_scene;

	players = get_players();

	level.cam_scenes[scene_name][index]["pos"] = players[0] GetEye();
	level.cam_scenes[scene_name][index]["angles"] = players[0] GetPlayerAngles();

	level.cam_models[scene_name][index].origin = level.cam_scenes[scene_name][index]["pos"];
	level.cam_models[scene_name][index].angles = level.cam_scenes[scene_name][index]["angles"];

	level.edit_help = false;
#/
}

edit_node_angles()
{
/#
	level thread edit_help( "Press 'C' to set the current ANGLE" );

	index = level.cam_edit_node_index;
	scene_name = level.cam_edit_scene;

	// Put player on Node
	// TEMP
	players = get_players();
	org = Spawn( "script_origin", players[0] GetEye() );
	diff = players[0] GetEye() - players[0].origin;
	org2 = Spawn( "script_origin", org.origin - diff );
	org2 LinkTo( org );

	org.angles = players[0] GetPlayerAngles();

	players[0] PlayerLinkToAbsolute( org2, "" );
	org.origin = level.cam_scenes[scene_name][index]["pos"];
	org.angles = level.cam_scenes[scene_name][index]["angles"];
	wait( 0.05 );

	players[0] UnLink();
	wait( 0.05 );
	players[0] PlayerLinkToDelta( org2 );
	//

	while( 1 )
	{
		level waittill( "edit_mode_button_pressed", key );
		if( key == "c" )
		{
			break;
		}

		wait( 0.01 );
	}
	players = get_players();

	level.cam_scenes[scene_name][index]["angles"] = players[0] GetPlayerAngles();
	level.cam_models[scene_name][index].angles = level.cam_scenes[scene_name][index]["angles"];

	level.edit_help = false;

	players[0] UnLink();
#/
}

edit_adjust_accel_deccel( scene_name, type, adjustment )
{
/#
	index = level.cam_edit_node_index;

	if( index == 0 ) // Can't adjust accel/deccel on the beginning cam node.
	{
		println( "^1Can't adjust accel/deccel on the beginning cam node." );
		return;
	}

	if( adjustment < 0 )
	{
		level.cam_scenes[scene_name][index][type] += adjustment;

		if( level.cam_scenes[scene_name][index][type] <= 0.1 )
		{
			level.cam_scenes[scene_name][index][type] = 0;
		}
	}
	else
	{
		accel = level.cam_scenes[scene_name][index]["accel"];
		deccel = level.cam_scenes[scene_name][index]["deccel"];
		time = level.cam_scenes[scene_name][index]["time"] * 0.001;

		level.cam_scenes[scene_name][index][type] += adjustment;

		if( accel + deccel > time - 0.1 )
		{
			level.cam_scenes[scene_name][index][type] -= adjustment;
			println( "^1Accel and Deccel cannot be longer than the time." );
			return;
		}
	}
#/
}

edit_mode_node_highlight()
{
/#
	level endon( "disable edit_mode" );

	points[0] = ( 5, 	5, 	-5 );
	points[1] = ( -5,	5, 	-5 );
	points[2] = ( -5, 	-5, 	-5 );
	points[3] = ( 5, 	-5, 	-5 );
	pointsb[0] = ( 5,	5, 	5 );
	pointsb[1] = ( -5, 5, 	5 );
	pointsb[2] = ( -5, -5, 	5 );
	pointsb[3] = ( 5, 	-5, 	5 );

	color = ( 1, 1, 1 );
	color1 = ( 1, 1, 1 );
	color2 = ( 0, 0, 0.5 );

	c1_red = color1[0];
	c1_green = color1[1];
	c1_blue = color1[2];
	c2_red = color2[0];
	c2_green = color2[1];
	c2_blue = color2[2];

	red = color[0];
	green = color[1];
	blue = color[2];

	max_color_count = 10;

	c1_red_diff = ( c2_red - c1_red ) / max_color_count;
	c1_green_diff = ( c2_green - c1_green ) / max_color_count;
	c1_blue_diff = ( c2_blue - c1_blue ) / max_color_count;
	c2_red_diff = ( c1_red - c2_red ) / max_color_count;
	c2_green_diff = ( c1_green - c2_green ) / max_color_count;
	c2_blue_diff = ( c1_blue - c2_blue ) / max_color_count;

	while( !IsDefined( level.cam_edit_scene ) )
	{
		wait( 0.05 );
	}

	color_count = 0;
	while( 1 )
	{
		if( !IsDefined( level.cam_scenes[level.cam_edit_scene] ) )
		{
			return;
		}

		pos = level.cam_scenes[level.cam_edit_scene][level.cam_edit_node_index]["pos"];
		for( i = 0; i < points.size; i++ )
		{
			if( i == 3 )
			{
				line( pos + points[i], pos + points[0], color );
				line( pos + pointsb[i], pos + pointsb[0], color );
			}
			else
			{
				line( pos + points[i], pos + points[i + 1], color );
				line( pos + pointsb[i], pos + pointsb[i + 1], color );
			}

			line( pos + points[i], pos + pointsb[i], color );
		}

		color_count++;
		if( color_count < max_color_count ) // Switch to color2
		{
			red = c1_red_diff;
			green = c1_green_diff;
			blue = c1_blue_diff;
		}
		else if( color_count < max_color_count * 2 )
		{
			red = c2_red_diff;
			green = c2_green_diff;
			blue = c2_blue_diff;
		}
		else
		{
			color_count = -10;
		}

		if( color_count < 0 )
		{
			color = color1;
		}
		else
		{
			color = ( color[0] + red, color[1] + green, color[2] + blue );
		}

		wait( 0.06 );
	}
#/
}

edit_mode_hud()
{
/#
	if( IsDefined( level.hud_array ) && IsDefined( level.hud_array["edit_mode_hud"] ) )
	{
		return;
	}

	shader_width = 150;
	shader_height = 80;
	x = 0;
	y = 300;
	hud = new_hud( "edit_mode_hud", undefined, x, y, 1 );
	hud SetShader( "white", shader_width, shader_height );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	new_hud( "edit_mode_hud", "Edit Node Help:", x + 10, y + 10, 1 );

	y += 3;

	new_hud( "edit_mode_hud", "Brackets", x + 10, y + 20, 1 );
	new_hud( "edit_mode_hud", "Ins/Del", x + 10, y + 30, 1 );
	new_hud( "edit_mode_hud", "HOME/END", x + 10, y + 40, 1 );
	new_hud( "edit_mode_hud", "PGUP/PGDN", x + 10, y + 50, 1 );
	new_hud( "edit_mode_hud", "M", x + 10, y + 60, 1 );
	new_hud( "edit_mode_hud", "C", x + 10, y + 70, 1 );

	new_hud( "edit_mode_hud", "- Next/Prev Node", x + 60, y + 20, 1 );
	new_hud( "edit_mode_hud", "- Inc/Dec Time", x + 60, y + 30, 1 );
	new_hud( "edit_mode_hud", "- Inc/Dec Accel", x + 60, y + 40, 1 );
	new_hud( "edit_mode_hud", "- Inc/Dec Deccel", x + 60, y + 50, 1 );
	new_hud( "edit_mode_hud", "- Re-Position", x + 60, y + 60, 1 );
	new_hud( "edit_mode_hud", "- Adjust Angle", x + 60, y + 70, 1 );
#/
}

edit_mode_buttons()
{
/#
	clear_universal_buttons( "edit_mode" );

	mod_button = undefined;
	if( level.xenon )
	{
//		add_universal_button( "rotate", "button_a" );
//		add_universal_button( "rotate", "button_b" );
//		add_universal_button( "rotate", "button_x" );
//		add_universal_button( "rotate", "button_y" );
//		add_universal_button( "rotate", "button_lshldr" );
//		add_universal_button( "rotate", "button_rshldr" );
//		add_universal_button( "rotate", "button_lstick" );
//		add_universal_button( "rotate", "button_rstick" );
//		mod_button = "button_ltrig";
	}

	add_universal_button( "edit_mode", "[" );
	add_universal_button( "edit_mode", "]" );
	add_universal_button( "edit_mode", "home" );
	add_universal_button( "edit_mode", "end" );
	add_universal_button( "edit_mode", "pgup" );
	add_universal_button( "edit_mode", "pgdn" );
	add_universal_button( "edit_mode", "ins" );
	add_universal_button( "edit_mode", "del" );
	add_universal_button( "edit_mode", "m" );
	add_universal_button( "edit_mode", "c" );
//	add_universal_button( "rotate", "kp_rightarrow" ); 
//	add_universal_button( "rotate", "kp_leftarrow" );
//	add_universal_button( "rotate", "kp_uparrow" );
//	add_universal_button( "rotate", "kp_downarrow" );
//	add_universal_button( "rotate", "kp_home" );
//	add_universal_button( "rotate", "kp_pgup" );
//	add_universal_button( "rotate", "kp_5" );
//	add_universal_button( "rotate", "kp_ins" );

	level thread universal_input_loop( "edit_mode", "disable edit_mode", undefined, mod_button );
#/
}

edit_select_scene()
{
/#
	y = level.menu_sys["current_menu"].options[0].y;

	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	value = undefined;
	value = list_menu( level.cam_scenes_names, 180, y, 1.3, ::edit_select_scene_list );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No scenes in list!", 10, y );
		}
	}

	arrow_hud Destroy();
#/
}

edit_select_scene_list( scene_name )
{
/#
	level.cam_edit_scene = scene_name;
	level thread draw_scene_lines( scene_name );
	level thread draw_scene_node_info( scene_name, "disable edit_mode" );
#/
}

edit_playback_scene()
{
/#
	if( !IsDefined( level.cam_edit_scene ) )
	{
		return "Scene is not selected";
	}
	playback_scene( level.cam_edit_scene );
#/
}

edit_delete_scene()
{
/#
	if( !IsDefined( level.cam_edit_scene ) )
	{
		return "Scene is not selected";
	}
	remove_scene( level.cam_edit_scene );
#/
}

edit_help( msg )
{
/#
	hud = set_hudelem( msg, 320, 100, 1.5 );
	hud.alignX = "center";
	hud.color = ( 1, 1, 0 );
	
	level.edit_help = true;
	while( level.edit_help )
	{
		wait( 0.05 );
	}

	hud Destroy();
#/
}

//--------------//
// File Section //
//--------------//
set_default_path()
{
/#
	if( !IsDefined( level.path ) )
	{
		level.path = "createcam/";
	}
#/
}

save_mode()
{
/#
	level thread save_mode_thread();
#/
}

save_mode_thread()
{
/#
	level waittill( "disable save_mode" );
#/
}

save_all()
{
/#
	if( !IsDefined( level.cam_scenes_names ) )
	{
		return "No camera scenes exist!";
	}

	fullpath_file = level.path + level.script + "_cam.gsc";

	file = OpenFile( fullpath_file, "write" );
	assertex( file != -1, "File not writeable (maybe you should check it out): " + fullpath_file );
	fprintln( file, "//Created by _createcam.gsc, if you need help talk to MikeD" );

//	attrib = level.cam_scene_attributes;

	tab = "     ";

	fprintln( file, "main()" );
	fprintln( file, "{" );

	create_cam_node = tab + "maps\\_camsys::" + "create_cam_node( ";
	for( i = 0; i < level.cam_scenes_names.size; i++ )
	{
		tab = "     ";
		
		scene_name 	= level.cam_scenes_names[i];

		fprintln( file, tab + "// " + scene_name );

		for( q = 0; q < level.cam_scenes[scene_name].size; q++ )
		{
			pos 			= level.cam_scenes[scene_name][q]["pos"];
			angles 			= level.cam_scenes[scene_name][q]["angles"];
			time 			= level.cam_scenes[scene_name][q]["time"];
			accel 			= level.cam_scenes[scene_name][q]["accel"];
			deccel 			= level.cam_scenes[scene_name][q]["deccel"];
			fprintln( file, create_cam_node + "\"" + scene_name + "\"" + ", " + pos + ", " + angles + ", " + time + ", " + accel + ", " + deccel + " );" );
		}

		fprintln( file, "" );
	}

	fprintln( file, "}" );

	saved = CloseFile( file );
	assertex( saved == 1, "File not saved (see above message?): " + fullpath_file );

	if( !saved )
	{
		return "Save FAILED!";
	}

	level thread save_complete( "scriptdata/" + fullpath_file );
#/
}

save_complete( msg )
{
/#
	println( "Save Successful, " + msg );

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
#/
}

//-------//
// Debug //
//-------//
spawn_cam_model( scene_name, pos, angles )
{
/#
	model = Spawn( "script_model", pos );
	model.angles = angles;
	model SetModel( "temp_camera" );

	return model;
#/
}

draw_scene_lines( scene_name )
{
/#
	level notify( "stop_all_lines" );

	level endon( "stop_" + scene_name + "_lines" );
	level endon( "stop_all_lines" );

	while( 1 )
	{
		if( IsDefined( level.cam_scenes[scene_name] ) && level.cam_scenes[scene_name].size > 1 )
		{
			for( i = 1; i < level.cam_scenes[scene_name].size; i++ )
			{
				line( level.cam_scenes[scene_name][i]["pos"], level.cam_scenes[scene_name][i-1]["pos"], ( 1, 1, 1 ) );
			}
		}

		wait( 0.06 );
	}
#/
}

draw_scene_node_info( scene_name, end_on )
{
/#
	level notify( "stop_all_node_info" );
	level endon( "stop_all_node_info" );

	level endon( end_on );

	color = ( 1, 1, 1 );

	pos_array = [];
	time_array = [];
	time2_array = [];

	players = get_players();
	scale = 0.25;
	alpha = 0.5;

	max_dist = 500 * 500;
	dot = 0.95;
	while( 1 )
	{
		if( !IsDefined( level.cam_scenes[scene_name] ) )
		{
			return;
		}

		for( i = 0; i < level.cam_scenes[scene_name].size; i++ )
		{
			if( i == 0 )
			{
				time_array[i] = 0;
				time2_array[i] = 0;
			}
			else
			{
				time_array[i] = level.cam_scenes[scene_name][i]["time"] + time_array[i-1];
				time2_array[i] = level.cam_scenes[scene_name][i]["time"];
			}
		}

		forward = AnglesToForward( players[0] GetPlayerAngles() );

		for( i = 0; i < level.cam_scenes[scene_name].size; i++ )
		{
			pos = level.cam_scenes[scene_name][i]["pos"];
			time = time_array[i] * 0.001;
			time2 = time2_array[i] * 0.001;
			accel = level.cam_scenes[scene_name][i]["accel"];
			deccel = level.cam_scenes[scene_name][i]["deccel"];

			player_distsqrd = DistanceSquared( players[0].origin, pos );
			alpha = ( max_dist - player_distsqrd ) / max_dist; 

			if( alpha < 0.3 )
			{
				alpha = 0.3;
			}

			difference = VectorNormalize( pos - players[0] GetEye() );
			newdot = VectorDot( forward, difference );
			if( newdot < dot )
			{
				scale = 0.25;
			}
			else
			{
				scale = 0.5;
				alpha = 0.9;
			}

			print3d( pos + ( 0, 0, -10 ) , "Time: " + time + " (" + time2 + ")", color, alpha, scale );
			print3d( pos + ( 0, 0, -15 ) , "Accel: " + accel, color, alpha, scale );
			print3d( pos + ( 0, 0, -20 ) , "Deccel: " + deccel, color, alpha, scale );
		}

		wait( 0.06 );
	}
#/
}