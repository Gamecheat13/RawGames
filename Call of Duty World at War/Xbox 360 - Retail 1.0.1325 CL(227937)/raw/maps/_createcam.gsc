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


#include common_scripts\utility;
#include maps\_utility;
#include maps\_createmenu;
#include maps\_camsys;
main()
{
	// Set camsys level variables
	camsys_init();

/#
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

	createcam_precache();
	level thread main2();
#/
}

// Used to be main(), but now that we wait for the player, we must thread it.
main2()
{
/#
	wait_for_first_player();

	if( !IsDefined( level.player ) )
	{
		players = get_players();
		level.player = players[0];
	}
	level thread remove_player_weapons();

	level.cam_scenes = [];
	level.cam_model_func = ::spawn_cam_model;

	// Setup the default save path/files
	level set_default_path();

	// Display the cursor, copied from _createfx
	level set_crosshair();

	// Set level variables
	level level_vars();

	// Set the types of cameras (tracks/targets) we can have.
	level setup_types();

	// Setup and enable the menu system.
	level setup_menus();

	// Setup the buttons that will be used in the menu system.
	level setup_menu_buttons();

	// Capture button input.
	level thread maps\_createmenu::menu_input();
#/
}

createcam_precache()
{
/#
	PrecacheModel( "temp_camera" );
	PrecacheShader( "white" );
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

// Sets up level vars for reference
level_vars()
{
/#
	level.cam_shot_id = 0;
#/
}

setup_types()
{
/#
	add_shot_type( "Timed Curve" );
//	add_shot_type( "Rounded Curve" );
//	add_shot_type( "Smoothed Curve" );
	add_shot_type( "Point" );
#/	
}

add_shot_type( name )
{
	if( !IsDefined( level.shottypes ) )
	{
		level.shottypes = [];
	}

	level.shottypes[level.shottypes.size] = name;
}

//--------------//
// Menu Section //
//--------------//

// Sets up the menus
setup_menus()
{
/#
	createmenu_init();

	// Main Menu
	add_menu( "main_menu", "Main Menu:" );
		add_menuoptions( "main_menu", "Shot Editor" );
		add_menuoptions( "main_menu", "Scene Editor" );
		add_menuoptions( "main_menu", "Save" );

		// Main Menu->Shots
		add_menu_child( "main_menu", "shots", "Shots:", undefined );
			add_menuoptions( "shots", "Tracks/Targets" );
			add_menuoptions( "shots", "Create Shot" );
			add_menuoptions( "shots", "Select Shot", ::select_shot );
			add_menuoptions( "shots", "Play Selected", ::play_selected_shot );
			add_menuoptions( "shots", "Edit Shot" );

			// Main Menu->Shots->Tracks/Targets
			add_menu_child( "shots", "tracks_targets", "Tracks/Targets:", undefined );
				add_menuoptions( "tracks_targets", "Create Track" );
				add_menuoptions( "tracks_targets", "Create Target" );					
				add_menuoptions( "tracks_targets", "Edit Track" );
				add_menuoptions( "tracks_targets", "Edit Target" );

				// Main Menu->Shots->Tracks/Targets->Create Track
				add_menu_child( "tracks_targets", "create_track", "Create Track:", undefined, ::create_track );
					add_menuoptions( "create_track", "Type", ::shot_type );
					add_menuoptions( "create_track", "Place CP", ::place_track_cp );

				// Main Menu->Shots->Tracks/Targets->Create Target
				add_menu_child( "tracks_targets", "create_target", "Create Target:", undefined, ::create_target );
					add_menuoptions( "create_target", "Type", ::shot_type );
					add_menuoptions( "create_target", "Place CP", ::place_target_cp );

				// Main Menu->Shots->Tracks/Targets->Edit Track
				add_menu_child( "tracks_targets", "edit_track", "Edit Track:", undefined, ::create_track );
					add_menuoptions( "edit_track", "Select Track", ::edit_track_select_track );
					add_menuoptions( "edit_track", "Move CP" );

			// Main Menu->Shots->Create_Shot
			add_menu_child( "shots", "create_shot", "Create Shot:", undefined );
				add_menuoptions( "create_shot", "Select Track", ::select_track );
				add_menuoptions( "create_shot", "Select Target", ::select_target );
				add_menuoptions( "create_shot", "Play Track", ::play_selected_track );
				add_menuoptions( "create_shot", "Name Shot", ::name_shot );

			// Main Menu->Shots->Edit_Shot
			add_menu_child( "shots", "edit_shot", "Edit Shot:", 4, ::edit_shot );
				add_menuoptions( "edit_shot", "Edit Track" );
				add_menuoptions( "edit_shot", "Edit Target" );
				add_menuoptions( "edit_shot", "Change Track", ::edit_shot_change_track );
				add_menuoptions( "edit_shot", "Change Target", ::edit_shot_change_target );
				add_menuoptions( "edit_shot", "Play Shot", ::play_selected_shot );

				// Main Menu->Shots->Edit_Shot->Edit_Shot_Track
				add_menu_child( "edit_shot", "edit_shot_track", "Edit Shot Track:", undefined, ::edit_shot_track );
					add_menuoptions( "edit_shot_track", "Play Shot", ::play_selected_shot );
					add_menuoptions( "edit_shot_track", "Add CP", ::edit_add_cpoint );
					add_menuoptions( "edit_shot_track", "Delete CP", ::edit_delete_cpoint );
					add_menuoptions( "edit_shot_track", "Set Time to Target", ::edit_sync_time_to_target );

				// Main Menu->Shots->Edit_Shot->Edit_Shot_Target
				add_menu_child( "edit_shot", "edit_shot_target", "Edit Shot Target:",undefined, ::edit_shot_target );
					add_menuoptions( "edit_shot_target", "Play Shot", ::play_selected_shot );
					add_menuoptions( "edit_shot_target", "Add CP", ::edit_add_target_cpoint );
					add_menuoptions( "edit_shot_target", "Delete CP", ::edit_delete_target_cpoint );
					add_menuoptions( "edit_shot_target", "Set Time to Track", ::edit_sync_time_to_track );
				

		// Main Menu->Create Scene Menu
		add_menu_child( "main_menu", "scenes", "Create Scene:", undefined );
			add_menuoptions( "scenes", "Compose Scene", ::compose_scene );
			add_menuoptions( "scenes", "Name Scene", ::name_scene );

		// Main Menu->Create Save Menu
		add_menu_child( "main_menu", "save", "Save:", undefined );
			add_menuoptions( "save", "Save All", ::save_all );

	enable_menu( "main_menu" );

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
		add_universal_button( "menu", "dpad_down" );
		add_universal_button( "menu", "dpad_left" );
		add_universal_button( "menu", "dpad_right" );
		add_universal_button( "menu", "button_a" );
		add_universal_button( "menu", "button_b" );
		add_universal_button( "menu", "button_y" );
		add_universal_button( "menu", "button_x" );
		add_universal_button( "menu", "button_lshldr" );
		add_universal_button( "menu", "button_rshldr" );
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
	add_universal_button( "menu", "del" );
	add_universal_button( "menu", "ins" );

	add_universal_button( "menu", "kp_leftarrow" );
	add_universal_button( "menu", "kp_rightarrow" );
	add_universal_button( "menu", "kp_uparrow" );
	add_universal_button( "menu", "kp_downarrow" );
	add_universal_button( "menu", "kp_home" );
	add_universal_button( "menu", "kp_pgup" );

	level thread universal_input_loop( "menu", "never", undefined, undefined, "button_ltrig" );
#/
}

//-------//
// Shots //
//-------//

create_track()
{
/#
	level thread create_track_thread();
#/
}

create_track_thread()
{
/#
	level waittill( "disable create_track" );
	level.create_num = undefined;
#/
}

create_target()
{
/#
	level thread create_target_thread();
#/
}

create_target_thread()
{
/#
	level waittill( "disable create_target" );
	level.create_num = undefined;
#/
}

// Choose the shop type
shot_type()
{
/#
	if( IsDefined( level.shottype ) )
	{
		level.shottype = undefined;
	}

	y = level.menu_sys["current_menu"].options[0].y;

	arrow_hud = set_hudelem( "-------->", 125, y, 1.3 );
	value = undefined;
	value = list_menu( level.shottypes, 180, y, 1.3 );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No ShotTypes in list!", 10, y );
		}
		else
		{
			level.shottype = level.shottypes[value];
		}
	}

	arrow_hud Destroy();
#/
}

place_track_cp()
{
/#
	if( !IsDefined( level.shottype ) )
	{
		return "Shot Type must be selected.";
	}

	if( !IsDefined( level.cam_tracks ) )
	{
		level.cam_tracks = [];
	}

	if( !IsDefined( level.create_num ) )
	{
		level.create_num = level.cam_tracks.size;
	}

	cp = create_cp( level.player GetEye() );
	add_cp_to_track( level.create_num, level.shottype, cp );

	draw_track( level.create_num );
#/
}

place_target_cp()
{
/#
	if( !IsDefined( level.shottype ) )
	{
		return "Shot Type must be selected.";
	}

	if( !IsDefined( level.cam_targets ) )
	{
		level.cam_targets = [];
	}

	if( !IsDefined( level.create_num ) )
	{
		level.create_num = level.cam_targets.size;
	}

	cp = create_cp( level.player GetEye() );
	add_cp_to_target( level.create_num, level.shottype, cp );

	draw_target( level.create_num );
#/
}

select_track()
{
/#
	if( !IsDefined( level.cam_tracks ) || level.cam_tracks.size < 1 )
	{
		return "No Camera Tracks Exist";
	}

	// Stop drawing all
	stop_drawing_all();

	// Now, only draw the tracks
	draw_all_targets();	

	y = level.menu_sys["current_menu"].options[0].y;

	arrow_hud = set_hudelem( "-------->", 125, y, 1.3 );
	value = undefined;

	strings = [];
	for( i = 0; i < level.cam_tracks.size; i++ )
	{
		strings[strings.size] = "" + i;
	}

	value = list_menu( strings, 180, y, 1.3, ::select_track_highlight );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No Camera Tracks in list!", 10, y );
		}
		else
		{
			create_shot( "new", int( strings[value] ) );
		}
	}

	arrow_hud Destroy();
#/
}

select_track_highlight( num )
{
/#
	stop_drawing_all();
	draw_track( int( num )  );
#/
}

create_shot( shot_name, track_name, target_name )
{
/#
	if( !IsDefined( level.cam_shots[shot_name] ) )
	{
		level.cam_shots[shot_name] = SpawnStruct();
	}

	if( IsDefined( track_name ) )
	{
		level.cam_shots[shot_name].cam_track = level.cam_tracks[track_name];
	}

	if( IsDefined( target_name ) )
	{
		level.cam_shots[shot_name].cam_target = level.cam_targets[target_name];
	}
#/
}

select_target()
{
/#
	if( !IsDefined( level.cam_targets ) || level.cam_targets.size < 1 )
	{
		return "No Camera Targets Exist";
	}

	y = level.menu_sys["current_menu"].options[1].y;

	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	value = undefined;

	strings = [];
	for( i = 0; i < level.cam_targets.size; i++ )
	{
		strings[strings.size] = "" + i;
	}

	value = list_menu( strings, 180, y, 1.3, ::select_target_highlight );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No Camera Targets in list!", 10, y );
		}
		else
		{
			create_shot( "new", undefined, int( strings[value] ) );
		}
	}

	arrow_hud Destroy();
#/
}

select_target_highlight( num )
{
/#
	stop_drawing_all();
	draw_target( int( num )  );
#/
}

play_selected_track()
{
/#
	if( !IsDefined( level.cam_shots["new"] ) || !IsDefined( level.cam_shots["new"].cam_track ) )
	{
		return "Track is not selected";
	}

	if( !IsDefined( level.cam_shots["new"].cam_target ) )
	{
		return "Target is not selected";
	}

	track 	= level.cam_shots["new"].cam_track;
	target 	= level.cam_shots["new"].cam_target;

	camera = create_camera();
	link_players_to_camera( camera );

	play_shot_internal( camera, track, target );
	
	unlink_players_from_camera( camera );
#/
}

name_shot()
{
/#
	if( !Isdefined( level.cam_shots["new"] ) )
	{
		return "Shot is not selected";
	}

	text = text_box( "Enter a name for your shot", "(Keep it short and no spaces, 8 characters)", 8 );
 
	if( text != "-1" )
	{
		copy_shot( "new", text );
		remove_shot( "new" );
	}
#/
}

select_shot()
{
/#
	y = level.menu_sys["current_menu"].options[2].y;

	arrow_hud = set_hudelem( "-------->", 125, y, 1.3 );
	value = undefined;

	names = GetArrayKeys( level.cam_shots );
	value = list_menu( names, 180, y, 1.3, ::draw_shot );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No Shots Found", 10, y );
		}
		else
		{
			level.shot_selected = names[value];
		}
	}

	arrow_hud Destroy();
#/
}


play_selected_shot()
{
/#
	if( !IsDefined( level.shot_selected ) )
	{
		return "Shot is not Selected";
	}

	camera = create_camera();
	link_players_to_camera( camera );
	
	play_shot( level.shot_selected, camera );

	unlink_players_from_camera( camera );
#/
}

// EDITING TRACKS/TARGETS //
edit_track_select_track()
{
/#
	if( !IsDefined( level.cam_tracks ) || level.cam_tracks.size < 1 )
	{
		return "No Camera Tracks Exist";
	}

	y = level.menu_sys["current_menu"].options[0].y;

	arrow_hud = set_hudelem( "-------->", 125, y, 1.3 );
	value = undefined;

	strings = [];
	for( i = 0; i < level.cam_tracks.size; i++ )
	{
		strings[strings.size] = "" + i;
	}

	value = list_menu( strings, 180, y, 1.3 );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No Camera Tracks in list!", 10, y );
		}
	}
	arrow_hud Destroy();
#/
}

// Edit Shots //
edit_shot()
{
/#
	if( !IsDefined( level.shot_selected ) )
	{
		return "Shot is not selected";
	}
#/
}

edit_shot_track()
{
/#
	level.edit_current_cp = 0;

	edit_shot_track_hud();
	edit_shot_track_cp_hud_info();

	level thread edit_shot_track_input();
	level thread edit_shot_track_buttons();

	level thread edit_shot_track_thread();
#/
}

edit_shot_track_thread()
{
/#
	level waittill( "disable edit_shot_track" );

	remove_hud( "edit_shot_track" );
	remove_hud( "edit_shot_track_cp_info" );
	remove_hud( "edit_shot_track_cp_info2" );
#/
}

edit_shot_target()
{
/#
	level.edit_current_cp = 0;

	edit_shot_track_hud( true );
	edit_shot_track_cp_hud_info( true );

	level thread edit_shot_track_input( true );
	level thread edit_shot_track_buttons();

	level thread edit_shot_target_thread();
#/
}

edit_shot_target_thread()
{
/#
	level waittill( "disable edit_shot_target" );

	remove_hud( "edit_shot_track" );
	remove_hud( "edit_shot_track_cp_info" );
	remove_hud( "edit_shot_track_cp_info2" );
#/
}

edit_shot_track_hud( edit_target )
{
/#
	if( IsDefined( level.hud_array ) && IsDefined( level.hud_array["edit_shot_track"] ) )
	{
		return;
	}

	shader_width = 150;
	shader_height = 80;
	x = 0;
	y = 300;
	hud = new_hud( "edit_shot_track", undefined, x, y, 1 );
	hud SetShader( "white", shader_width, shader_height );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	if( IsDefined( edit_target ) && edit_target )
	{
		new_hud( "edit_shot_track", "Edit Target Help:", x + 10, y + 10, 1 );
	}
	else
	{
		new_hud( "edit_shot_track", "Edit Track Help:", x + 10, y + 10, 1 );
	}

	y += 3;

	if( level.xenon )
	{
		new_hud( "edit_shot_track", "BUMPERS", x + 10, y + 20, 1 );
		new_hud( "edit_shot_track", "X/Y", x + 10, y + 30, 1 );
	}
	else
	{
		new_hud( "edit_shot_track", "Brackets", x + 10, y + 20, 1 );
		new_hud( "edit_shot_track", "Ins/Del", x + 10, y + 30, 1 );
		new_hud( "edit_shot_track", "HOME/END", x + 10, y + 40, 1 );
		new_hud( "edit_shot_track", "PGUP/PGDN", x + 10, y + 50, 1 );
		new_hud( "edit_shot_track", "M", x + 10, y + 60, 1 );
	}

	new_hud( "edit_shot_track", "- Next/Prev CP", x + 60, y + 20, 1 );
	new_hud( "edit_shot_track", "- Inc/Dec Time", x + 60, y + 30, 1 );
	new_hud( "edit_shot_track", "- NOT WORKING YET Inc/Dec Accel", x + 60, y + 40, 1 );
	new_hud( "edit_shot_track", "- NOT WORKING YET Inc/Dec Deccel", x + 60, y + 50, 1 );
	new_hud( "edit_shot_track", "- Re-Position", x + 60, y + 60, 1 );
#/
}

edit_shot_track_cp_hud_info( edit_target )
{
/#
	if( IsDefined( level.hud_array ) && IsDefined( level.hud_array["edit_shot_track_cp_info"] ) )
	{
		return;
	}

	shader_width = 75;
	shader_height = 380;
	x = 640 - shader_width;
	y = 480 - shader_height;
	hud = new_hud( "edit_shot_track_cp_info", undefined, x, y, 1 );
	hud SetShader( "white", shader_width, shader_height );
	hud.alignX = "left";
	hud.alignY = "top";
	hud.sort = 10;
	hud.alpha = 0.6;	
	hud.color = ( 0.0, 0.0, 0.5 );

	new_hud( "edit_shot_track_cp_info", "CP:", x + 10, y + 10, 1 );

	if( IsDefined( edit_target ) && edit_target )
	{
		level.current_cp_hud = new_hud( "edit_shot_track_cp_info", "1 / " + level.cam_shots[level.shot_selected].cam_target.cpoints.size, x + 30, y + 20, 1 );
	}
	else
	{
		level.current_cp_hud = new_hud( "edit_shot_track_cp_info", "1 / " + level.cam_shots[level.shot_selected].cam_track.cpoints.size, x + 30, y + 20, 1 );
	}

	edit_track_cp_update_info( edit_target );
#/
}

edit_track_cp_update_info( edit_target )
{
/#
	if( IsDefined( level.hud_array ) && IsDefined( level.hud_array["edit_shot_track_cp_info2"] ) )
	{
		remove_hud( "edit_shot_track_cp_info2" );
	}

	if( IsDefined( edit_target ) && edit_target )
	{
		cpoint = level.cam_shots[level.shot_selected].cam_target.cpoints[level.edit_current_cp];
		keys = GetArrayKeys( cpoint.attrib );
	}
	else
	{
		cpoint = level.cam_shots[level.shot_selected].cam_track.cpoints[level.edit_current_cp];
		keys = GetArrayKeys( cpoint.attrib );
	}

	x = level.hud_array["edit_shot_track_cp_info"][1].x;
	y = level.hud_array["edit_shot_track_cp_info"][1].y + 10;
	for( i = 0; i < keys.size; i++ )
	{
		y += 15;
		new_hud( "edit_shot_track_cp_info2", keys[i] + ":", x, y, 1 );

		x += 30;
		y += 10;

		new_hud( "edit_shot_track_cp_info2", "" + cpoint.attrib[keys[i]], x, y, 1 );

		x -= 30;
	}
#/
}

edit_update_cpoint_attrib( attrib_name, value, edit_target )
{
/#
	if( IsDefined( edit_target ) && edit_target )
	{
		cpoint = level.cam_shots[level.shot_selected].cam_target.cpoints[level.edit_current_cp];
	}
	else
	{
		cpoint = level.cam_shots[level.shot_selected].cam_track.cpoints[level.edit_current_cp];
	}

	cpoint.attrib[attrib_name] += value;

	if( cpoint.attrib[attrib_name] < 0.05 )
	{
		cpoint.attrib[attrib_name] = 0.05;
	}

	if( attrib_name == "time" )
	{
		draw_shot( level.shot_selected );
	}
#/
}

edit_update_cpoint_origin( edit_target )
{
/#
	if( level.xenon )
	{
		level thread edit_help( "Press 'A' to set Origin (B to Cancel)" );
	}
	else
	{
		level thread edit_help( "Press 'M' to set Origin (END to Cancel)" );
	}

	while( 1 )
	{
		level waittill( "edit_shot_track_button_pressed", key );
		if( key == "m" )
		{
			break;
		}
		else if( key == "button_b" )
		{
			level.edit_help = false;
			return;
		}

		wait( 0.05 );
	}

	if( IsDefined( edit_target ) && edit_target )
	{
		cpoint = level.cam_shots[level.shot_selected].cam_target.cpoints[level.edit_current_cp];
	}
	else
	{
		cpoint = level.cam_shots[level.shot_selected].cam_track.cpoints[level.edit_current_cp];
	}

	level.edit_help = false;

	cpoint.origin = level.player GetEye();

	draw_shot( level.shot_selected );
#/
}

edit_add_target_cpoint()
{
/#
	edit_add_cpoint( true );
#/
}

edit_add_cpoint( edit_target )
{
/#
	if( level.xenon )
	{
		level thread edit_help( "Press 'A' to Add CP (B to Cancel)" );
	}
	else
	{
		level thread edit_help( "Press 'ENTER' to Add CP (END to Cancel)" );
	}

	while( 1 )
	{
		level waittill( "edit_shot_track_button_pressed", key );
		if( key == "button_a" || key == "enter" )
		{
			break;
		}
		else if( key == "button_b" || key == "end" )
		{
			level.edit_help = false;
			return;
		}

		wait( 0.05 );
	}

	level.edit_help = false;

	if( IsDefined( edit_target ) && edit_target )
	{
		cpoints = level.cam_shots[level.shot_selected].cam_target.cpoints;
	}
	else
	{
		cpoints = level.cam_shots[level.shot_selected].cam_track.cpoints;
	}

	new_cpoint = create_cp( level.player GetEye() );

	cpoints = array_insert( cpoints, new_cpoint, level.edit_current_cp + 1 );

	if( IsDefined( edit_target ) && edit_target )
	{
		level.cam_shots[level.shot_selected].cam_target.cpoints = cpoints;
	}
	else
	{
		level.cam_shots[level.shot_selected].cam_track.cpoints = cpoints;
	}

	draw_shot( level.shot_selected );

	wait( 0.5 );
#/
}

edit_delete_target_cpoint()
{
/#
	edit_delete_cpoint( true );
#/
}

edit_delete_cpoint( edit_target )
{
/#
	if( level.xenon )
	{
		level thread edit_help( "Press 'A' to Delete CP (B to Cancel)" );
	}
	else
	{
		level thread edit_help( "Press 'ENTER' to Delete CP (END to Cancel)" );
	}

	while( 1 )
	{
		level waittill( "edit_shot_track_button_pressed", key );
		if( key == "button_a" || key == "enter" )
		{
			break;
		}
		else if( key == "button_b" || key == "end" )
		{
			level.edit_help = false;
			return;
		}

		wait( 0.05 );
	}

	level.edit_help = false;

	if( IsDefined( edit_target ) && edit_target )
	{
		cpoints = level.cam_shots[level.shot_selected].cam_target.cpoints;
	}
	else
	{
		cpoints = level.cam_shots[level.shot_selected].cam_track.cpoints;
	}

	cpoints = array_remove_index( cpoints, level.edit_current_cp );

	if( IsDefined( edit_target ) && edit_target )
	{
		level.cam_shots[level.shot_selected].cam_target.cpoints = cpoints;
	}
	else
	{
		level.cam_shots[level.shot_selected].cam_track.cpoints = cpoints;
	}

	draw_shot( level.shot_selected );

	wait( 0.5 );	
#/
}

edit_sync_time_to_target()
{
/#
	target_cpoints = level.cam_shots[level.shot_selected].cam_target.cpoints;

	time = 0;
	for( i = 1; i < target_cpoints.size; i++ )
	{
		time += target_cpoints[i].attrib["time"];
	}

	cpoints = level.cam_shots[level.shot_selected].cam_track.cpoints;

	div_time = time / ( cpoints.size - 1 );
	for( i = 1; i < cpoints.size; i++ )
	{
		cpoints[i].attrib["time"] = div_time;
	}

	edit_track_cp_update_info( false );

	draw_shot( level.shot_selected );
#/
}

edit_sync_time_to_track()
{
/#
	track_cpoints = level.cam_shots[level.shot_selected].cam_track.cpoints;

	time = 0;
	for( i = 1; i < track_cpoints.size; i++ )
	{
		time += track_cpoints[i].attrib["time"];
	}

	cpoints = level.cam_shots[level.shot_selected].cam_target.cpoints;

	div_time = time / ( cpoints.size - 1 );
	for( i = 1; i < cpoints.size; i++ )
	{
		cpoints[i].attrib["time"] = div_time;
	}

	edit_track_cp_update_info( true );

	draw_shot( level.shot_selected );
#/
}

edit_shot_track_buttons()
{
/#
	clear_universal_buttons( "edit_shot_track" );

	mod_button = undefined;
	if( level.xenon )
	{
		add_universal_button( "edit_shot_track", "button_lshldr" );
		add_universal_button( "edit_shot_track", "button_rshldr" );
		add_universal_button( "edit_shot_track", "button_a" );
		add_universal_button( "edit_shot_track", "button_b" );
		add_universal_button( "edit_shot_track", "button_x" );
		add_universal_button( "edit_shot_track", "button_y" );
		add_universal_button( "edit_shot_track", "button_ltrig" );
	}

	add_universal_button( "edit_shot_track", "[" );
	add_universal_button( "edit_shot_track", "]" );
	add_universal_button( "edit_shot_track", "home" );
	add_universal_button( "edit_shot_track", "end" );
	add_universal_button( "edit_shot_track", "pgup" );
	add_universal_button( "edit_shot_track", "pgdn" );
	add_universal_button( "edit_shot_track", "ins" );
	add_universal_button( "edit_shot_track", "del" );
	add_universal_button( "edit_shot_track", "m" );
	add_universal_button( "edit_shot_track", "enter" );

	level thread universal_input_loop( "edit_shot_track", "disable edit_shot_track", undefined, mod_button );
#/
}

edit_shot_track_input( edit_target )
{
/#
	level endon( "disable edit_shot_track" );
	level endon( "disable edit_shot_target" );

	while( 1 )
	{
		if( IsDefined( edit_target ) && edit_target )
		{
			cpoints = level.cam_shots[level.shot_selected].cam_target.cpoints;
		}
		else
		{
			cpoints = level.cam_shots[level.shot_selected].cam_track.cpoints;
		}

		if( level.edit_current_cp > cpoints.size - 1 )
		{
			level.edit_current_cp = cpoints.size - 1;
		}

		level thread edit_cp_highlight( cpoints[level.edit_current_cp].origin, edit_target );
		level.current_cp_hud SetText( ( level.edit_current_cp + 1 ) + " / " + cpoints.size );
		edit_track_cp_update_info( edit_target );

		level waittill( "edit_shot_track_button_pressed", key );

		if( key == "button_lshldr" || key == "[" )
		{
			if( level.edit_current_cp == 0 )
			{
				level.edit_current_cp = cpoints.size - 1;
			}
			else
			{
				level.edit_current_cp--;
			}
		}
		else if( key == "button_rshldr" || key == "]" )
		{
			if( level.edit_current_cp == cpoints.size - 1 )
			{
				level.edit_current_cp = 0;
			}
			else
			{
				level.edit_current_cp++;
			}
		}
		else if( key == "button_y" || key == "ins" )
		{
			edit_update_cpoint_attrib( "time", 0.05, edit_target );
			continue;
		}
		else if( key == "button_x" || key == "del" )
		{
			edit_update_cpoint_attrib( "time", -0.05, edit_target );
			continue;
		}
		else if( key == "button_ltrig" || key == "m" )
		{
			edit_update_cpoint_origin( edit_target );
			wait( 0.25 );
		}

		wait( 0.1 );
	}
#/
}

edit_cp_highlight( pos, edit_target )
{
/#
	level notify( "disable edit_cp_highlight" );
	level endon( "disable edit_cp_highlight" );
	level endon( "disable edit_shot_track" );
	level endon( "disable edit_shot_target" );

	points[0] = ( 0, 	0, 	10 );
	points[1] = ( 0,	0, 	-10 );
	pointsb[0] = ( 0,	10, 	0 );
	pointsb[1] = ( 0,   -10, 0 );
	pointsc[0] = ( 10,	0, 	0 );
	pointsc[1] = ( -10,   0, 0 );

	color = ( 1, 1, 0 );
	color1 = ( 1, 1, 0 );
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

	max_color_count = 7;

	c1_red_diff = ( c2_red - c1_red ) / max_color_count;
	c1_green_diff = ( c2_green - c1_green ) / max_color_count;
	c1_blue_diff = ( c2_blue - c1_blue ) / max_color_count;
	c2_red_diff = ( c1_red - c2_red ) / max_color_count;
	c2_green_diff = ( c1_green - c2_green ) / max_color_count;
	c2_blue_diff = ( c1_blue - c2_blue ) / max_color_count;

	points_a = [];
	points_b = [];
	points_c = [];

	radius = 10;
	segments = 16;
	add_angles = 360 / segments;
	angles = ( 0, 0, 0 );

	for( i = 0; i < segments; i++ )
	{
		angles = angles + ( add_angles, 0, 0 );
		forward = AnglesToForward( angles );
		points_a[i] = pos + VectorScale( forward, radius );
	}		

	angles = ( 0, 90, 0 ); // Since we're using anglestoforward
	for( i = 0; i < segments; i++ )
	{
		angles = angles + ( add_angles, 0, 0 );
		forward = AnglesToForward( angles );
		points_b[i] = pos + VectorScale( forward, radius );
	}

	angles = ( 0, 0, 0 );
	for( i = 0; i < segments; i++ )
	{
		angles = angles + ( 0, add_angles, 0 );
		forward = AnglesToForward( angles );
		points_c[i] = pos + VectorScale( forward, radius );
	}

	color_count = 0;
	while( 1 )
	{
		for( i = 0; i < points_a.size; i++ )
		{
			if( i == ( points_a.size - 1 ) )
			{
				Line( points_a[i], points_a[0], color, 1 );
			}
			else
			{
				Line( points_a[i], points_a[i + 1], color, 1 );
			}
		}

		for( i = 0; i < points_b.size; i++ )
		{
			if( i == ( points_b.size - 1 ) )
			{
				Line( points_b[i], points_b[0], color, 1 );
			}
			else
			{
				Line( points_b[i], points_b[i + 1], color, 1 );
			}
		}

		for( i = 0; i < points_c.size; i++ )
		{
			if( i == ( points_c.size - 1 ) )
			{
				Line( points_c[i], points_c[0], color, 1 );
			}
			else
			{
				Line( points_c[i], points_c[i + 1], color, 1 );
			}
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

		wait( 0.05 );
	}
#/	
}

edit_shot_change_track()
{
/#
	if( !IsDefined( level.cam_tracks ) || level.cam_tracks.size < 1 )
	{
		return "No Camera Tracks Exist";
	}

	y = level.menu_sys["current_menu"].options[2].y;

	arrow_hud = set_hudelem( "-------->", 125, y, 1.3 );
	value = undefined;

	strings = [];
	for( i = 0; i < level.cam_tracks.size; i++ )
	{
		strings[strings.size] = "" + i;
	}

	value = list_menu( strings, 180, y, 1.3, ::select_track_highlight );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No Camera Tracks in list!", 10, y );
		}
		else
		{
			level.cam_shots[level.shot_selected].cam_track = level.cam_tracks[int( strings[value] )];
		}
	}

	arrow_hud Destroy();
#/
}

edit_shot_change_target()
{
/#
	if( !IsDefined( level.cam_targets ) || level.cam_targets.size < 1 )
	{
		return "No Camera Targets Exist";
	}

	y = level.menu_sys["current_menu"].options[1].y;

	arrow_hud = set_hudelem( "-------->", 120, y, 1.3 );
	value = undefined;

	strings = [];
	for( i = 0; i < level.cam_targets.size; i++ )
	{
		strings[strings.size] = "" + i;
	}

	value = list_menu( strings, 180, y, 1.3, ::select_target_highlight );

	if( IsDefined( value ) )
	{
		if( value < 0 )
		{
			level thread selection_error( "No Camera Targets in list!", 10, y );
		}
		else
		{
			level.cam_shots[level.shot_selected].cam_target = level.cam_targets[int( strings[value] )];
		}
	}

	arrow_hud Destroy();
#/
}

//quick_scene()

//----------------//
// Compose Scenes //
//----------------//
compose_scene()
{
/#
	y = level.menu_sys["current_menu"].options[0].y;

	strings = GetArrayKeys( level.cam_shots );

	if( !IsDefined( strings ) )
	{
		return "No Shots Found!";
	}

	values = scene_editor_menu( strings, maps\_camsys::create_scene_add_shot );

	if( IsDefined( values ) )
	{
		remove_scene( "new" );

		for( i = 0; i < values.size; i++ )
		{
			if( IsDefined( values[i] ) )
			{
				create_scene_add_shot( "new", values[i] );
			}
		}
	}
#/
}

scene_editor_menu( strings, func )
{
/#
	x = 320;
	y = 425;
	scale = 1.3;
	space_between = 75;

	current_x_pos = 0;

	blue_background = draw_fancy_hudline( "horizontal", 0, 410, 640, 0.2, ( 0.0, 0.0, 0.5 ), 0.7, 60 );

	huds = [];
	for( i = 0; i < 2; i++ )
	{
		huds[i] = scene_editor_add_huds( x + ( i * space_between ), y, scale, i );
	}

	set_huds_alphas( huds, current_x_pos, 5, 0 );

	while( true )
	{
		level waittill( "menu_button_pressed", key );

		if( key == "leftarrow" || key == "dpad_left" )
		{
			if( current_x_pos == 0 )
			{
				continue;
			}

			current_x_pos--;
			move_huds( huds, 75, 0, current_x_pos, 5, 0 );
		}
		else if( key == "rightarrow" || key == "dpad_right" )
		{
			if( current_x_pos == huds.size - 1 )
			{
				continue;
			}

			if( huds[current_x_pos].value == "---" )
			{
				println( "^3Cannot move Right until you set the previous shot" );
				wait( 0.1 );
				continue;
			}

			current_x_pos++;

			if( current_x_pos == huds.size - 1 )
			{
				// Add a new empty shot
				huds[huds.size] = scene_editor_add_huds( x + ( ( huds.size - current_x_pos + 1 ) * space_between ), y, scale, huds.size );
			}

			move_huds( huds, -75, 0, current_x_pos, 5, 0 );
		}
		else if( key == "enter" || key == "button_a" )
		{
			popup = popup_box( x, y - 70, 100, 100, 0.1 );

			selected = scene_editor_select_shot( x + 20, y - 70, strings );

			if( IsDefined( selected ) )
			{
				huds[current_x_pos].value = strings[selected];
				huds[current_x_pos].hud SetText( strings[selected] );
			}

			popup destroy_popup();
		}
		else if( key == "ins" || key == "button_lshldr" )
		{
			temp = scene_editor_add_huds( x, y, scale, current_x_pos );
			huds = array_insert( huds, temp, current_x_pos );

			for( i = current_x_pos + 1; i < huds.size; i++ )
			{
				huds[i].hud.x = huds[i].hud.x + space_between;
				huds[i].title SetText( "#" + ( i + 1 ) );
				huds[i].title.x = huds[i].title.x + space_between;
			}

			set_huds_alphas( huds, current_x_pos, 5, 0 );
		}
		else if( key == "del" || key == "button_y" )
		{
			huds[current_x_pos].hud Destroy();
			huds[current_x_pos].title Destroy();

			huds = array_remove_index( huds, current_x_pos );

			for( i = current_x_pos; i < huds.size; i++ )
			{
				huds[i].hud.x = huds[i].hud.x - space_between;
				huds[i].title SetText( "#" + ( i + 1 ) );
				huds[i].title.x = huds[i].title.x - space_between;
			}

			set_huds_alphas( huds, current_x_pos, 5, 0 );
		}
		else if( key == "end" || key == "button_b" )
		{
			break;
		}
		else if( key == "p" || key == "button_x" )
		{
			remove_scene( "new" );

			skip = 0;
			for( i = 0; i < huds.size - 1; i++ )
			{
				if( huds[i].value == "---" )
				{
					println( "^3Shot # " + ( i + 1 ) + " is not set properly, Skipping!" );
					skip++;
					continue;
				}
	
				[[func]]( "new", huds[i - skip].value, i - skip );
			}

			play_scene( "new" );

			wait( 0.2 );
		}

		if( IsDefined( huds[current_x_pos].value ) && huds[current_x_pos].value != "---" )
		{
			draw_shot( huds[current_x_pos].value );
		}
		else
		{
			stop_drawing_all();
		}
	}

	for( i = 0; i < huds.size; i++ )
	{
		if( IsDefined( huds[i] ) )
		{
			huds[i].hud Destroy();
		}
	}

	blue_background Destroy();

	values = [];

	for( i = 0; i < huds.size; i++ )
	{
		if( huds[i].value == "---" )
		{
			values[i] = undefined;
		}
		else
		{
			values[i] = huds[i].value;
		}
	}
	return values;
#/
}

scene_editor_add_huds( x, y, scale, num )
{
/#
	huds = SpawnStruct();
	huds.value = "---";
	huds.hud = set_hudelem( huds.value, x, y, scale, 1 );
	huds.hud.alignX = "center";
	huds.title = set_hudelem( "#" + ( num + 1 ), x, y - 30, scale, 0.75 );
	huds.title.alignX = "center";

	return huds;
#/
}

scene_editor_select_shot( x, y, strings )
{
/#
	arrow_hud = set_hudelem( ">", x - 20, y, 1.3 );
	arrow_hud.sort = 45;
	value = undefined;
	value = list_menu( strings, x, y, 1.3, ::draw_shot, 40 );

	arrow_hud Destroy();

	if( IsDefined( value ) )
	{
		return value;
	}
	else
	{
		return undefined;
	}
#/
}

draw_fancy_hudline( type, start_x, start_y, length, time, color, alpha, thickness )
{
/#
	if( !IsDefined( alpha ) )
	{
		alpha = 1;
	}

	if( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	hud = NewHudElem();
	hud.alignX = "left";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.sort = 20;
	hud.x = start_x;
	hud.y = start_y;
	hud.alpha = alpha;
	hud.color = color;

	if( !IsDefined( thickness ) )
	{
		thickness = 2;
	}

	if( type == "horizontal" )
	{
		hud.alignY = "middle";

		if( length < 0 )
		{
			length = length * -1;
			hud.alignX = "right";
		}

		hud SetShader( "white", 0, thickness );
		hud ScaleOverTime( time, length, thickness );
	}
	else // vertical
	{
		hud.alignX = "center";

		if( length < 0 )
		{
			length = length * -1;
			hud.alignY = "bottom";
		}
		else
		{
			hud.alignY = "top";
		}

		hud SetShader( "white", thickness, 0 );
		hud ScaleOverTime( time, thickness, length );
	}

	wait( time );

	return hud;
#/
}

move_huds( huds, x_shift, y_shift, current_pos, max_num_fading, min_alpha )
{
/#
	if( !IsDefined( min_alpha ) )
	{
		min_alpha = 0.1;
	}

	time = 0.1;
	for( i = 0; i < huds.size; i++ )
	{
		huds[i].hud MoveOverTime( time );
		huds[i].title MoveOverTime( time );

		huds[i].hud.x += x_shift;
		huds[i].hud.y += y_shift;
		huds[i].title.x += x_shift;
		huds[i].title.y += y_shift;

	}

	if( IsDefined( current_pos ) && IsDefined( max_num_fading ) && IsDefined( min_alpha ) )
	{
		set_huds_alphas( huds, current_pos, 5, 0 );
	}

	wait( time );
#/
}

set_huds_alphas( huds, current_pos, max_num_fading, min_alpha )
{
/#
	if( !IsDefined( min_alpha ) )
	{
		min_alpha = 0.1;
	}

	if( !IsDefined( max_num_fading ) )
	{
		max_num_fading = 3;
	}

	for( i = 0; i < huds.size; i++ )
	{
		temp = i - current_pos;

		if( temp < 0 )
		{
			temp = temp * -1;
		}
		
		alpha = 1 / ( temp + 1 );

		if( alpha < ( 1 / max_num_fading ) )
		{
			alpha = min_alpha;
		}

		huds[i].hud.alpha = alpha;		
		huds[i].title.alpha = alpha;
	}
#/
}

//------------//
// Name Scene //
//------------//
name_scene()
{
/#
	if( !Isdefined( level.cam_scenes["new"] ) )
	{
		return "New Scene is not made";
	}

	text = text_box( "Enter a name for your scene", "(Keep it short and no spaces, 8 characters)", 8 );
 
	if( text != "-1" )
	{
		copy_scene( "new", text );
		remove_scene( "new" );
	}
#/
}

copy_scene( name, copy_name )
{
/#
	size = level.cam_scenes[name].shots.size;

	for( i = 0; i < size; i++ )
	{
		create_scene_add_shot( copy_name, level.cam_scenes[name].shots[i] );
	}
#/
}

remove_scene( name_of_scene )
{
/#
	if( IsDefined( level.cam_scenes[name_of_scene] ) )
	{
		level.cam_scenes[name_of_scene] = undefined;
	}
#/
}

//--------------//
// Save Section //
//--------------//
save_all()
{
/#
	if( !IsDefined( level.cam_shots ) || level.cam_shots.size < 1 )
	{
		return "No Shots Exist";
	}

	fullpath_file = level.path + level.script + "_cam.gsc";

	file = OpenFile( fullpath_file, "write" );
	assertex( file != -1, "File not writeable (maybe you should check it out): " + fullpath_file );
	fprintln( file, "// AUTO GENERATED -- DO NOT TOUCH" );
	fprintln( file, "// Created by _createcam.gsc, if you need help talk to MikeD" );

//	attrib = level.cam_scene_attributes;

	tab = "    ";

	fprintln( file, "main()" );
	fprintln( file, "{" );
	fprintln( file, tab + "shots();" );
	fprintln( file, tab + "scenes();" );
	fprintln( file, "}" );

	// Shots
	save_shots( file );

	// Scenes
	save_scenes( file );

	saved = CloseFile( file );
	assertex( saved == 1, "File not saved (see above message?): " + fullpath_file );

	if( !saved )
	{
		return "Save FAILED!";
	}

	level thread save_complete( "scriptdata/" + fullpath_file );
#/
}

save_shots( file )
{
/#
	tab = "    ";
	cp_string 	= "maps\\_camsys::create_cp( ";
	build_shot 	= "maps\\_camsys::build_shot( ";

	fprintln( file, "" );
	fprintln( file, "shots()" );
	fprintln( file, "{" );

	shot_names = GetArrayKeys( level.cam_shots );
	for( i = 0; i < shot_names.size; i++ )
	{
		// Track
		track = level.cam_shots[shot_names[i]].cam_track;

		fprintln( file, tab + "// SHOT NAME: " + shot_names[i] );
		fprintln( file, tab + "//---------------------------------------------------------------------------------" );
		fprintln( file, tab + "// Track:" );
		fprintln( file, tab + "track_array = [];" );
		for( j = 0; j < track.cpoints.size; j++ )
		{
			fprintln( file, tab + "num = track_array.size;" );
			fprintln( file, tab + "track_array[num] = " + cp_string + track.cpoints[j].origin + " );" );

			keys = GetArrayKeys( track.cpoints[j].attrib );
			for( q = 0; q < keys.size; q++ )
			{
				fprintln( file, tab + "track_array[num].attrib[\"" + keys[q] + "\"] = " + track.cpoints[j].attrib[keys[q]] + ";" );
			}

			fprintln( file, "" );
		}

		fprintln( file, "" );

		// Target
		target = level.cam_shots[shot_names[i]].cam_target;

		fprintln( file, tab + "// Target:" );
		fprintln( file, tab + "target_array = [];" );
		for( j = 0; j < target.cpoints.size; j++ )
		{
			fprintln( file, tab + "num = target_array.size;" );
			fprintln( file, tab + "target_array[num] = " + cp_string + target.cpoints[j].origin + " );" );

			keys = GetArrayKeys( target.cpoints[j].attrib );
			for( q = 0; q < keys.size; q++ )
			{
				fprintln( file, tab + "target_array[num].attrib[\"" + keys[q] + "\"] = " + target.cpoints[j].attrib[keys[q]] + ";" );
			}

			fprintln( file, "" );
		}

		fprintln( file, tab + build_shot + "\"" + shot_names[i] + "\", " + "\"" + level.cam_shots[shot_names[i]].cam_track.type + "\", " + "\"" + level.cam_shots[shot_names[i]].cam_target.type + "\", track_array, target_array );" );
		fprintln( file, "" );
	}

	fprintln( file, "}" );
#/
}

save_scenes( file )
{
/#
	tab = "    ";
	create_scene = "maps\\_camsys::create_scene( ";

	fprintln( file, "" );
	fprintln( file, "scenes()" );
	fprintln( file, "{" );

//	size = level.cam_scenes[name].shots.size;

//	for( i = 0; i < size; i++ )
//	{
//		create_scene_add_shot( copy_name, level.cam_scenes[name].shots[i] );
//	}

	scene_names = GetArrayKeys( level.cam_scenes );
	for( i = 0; i < scene_names.size; i++ )
	{
		fprintln( file, tab + "// SCENE NAME: " + scene_names[i] );
		fprintln( file, tab + "//---------------------------------------------------------------------------------" );
		fprintln( file, tab + "shots = [];" );

		shots = level.cam_scenes[scene_names[i]].shots;
		for( j = 0; j < shots.size; j++ )
		{
			fprintln( file, tab + "shots[" + j + "] = " + "\"" + shots[j] + "\";" );
		}

		fprintln( file, "" );
		fprintln( file, tab + create_scene + "\"" + scene_names[i] + "\"" + ", shots );" );

		fprintln( file, "" );
	}

	fprintln( file, "}" );
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

//---------------//
// GENERIC STUFF //
//---------------//
text_box( msg1, msg2, chars )
{
/#
	level.player FreezeControls( true );
	name = dialog_text_box( msg1, msg2, chars );
	level.player FreezeControls( false );

	return name;
#/
}

add_cp_to_track( num, type, cp )
{
/#
	if( !IsDefined( level.cam_tracks ) )
	{
		level.cam_tracks = [];
	}

	// If num does not exist in level.cam_tracks, create it.
	if( !IsDefined( level.cam_tracks[num] ) )
	{
		shot = SpawnStruct();
		shot.type = type;
		shot.cpoints = [];
		level.cam_tracks[num] = shot;
	}

	if( type == "Point" )
	{
		level.cam_tracks[num].cpoints = [];
	}

	size = level.cam_tracks[num].cpoints.size;
	level.cam_tracks[num].cpoints[size] = cp;
#/
}

add_cp_to_target( num, type, cp )
{
/#
	if( !IsDefined( level.cam_targets ) )
	{
		level.cam_targets = [];
	}

	// If num does not exist in level.cam_targets, create it.
	if( !IsDefined( level.cam_targets[num] ) )
	{
		shot = SpawnStruct();
		shot.type = type;
		shot.cpoints = [];
		level.cam_targets[num] = shot;
	}

	if( type == "Point" )
	{
		level.cam_targets[num].cpoints = [];
	}

	size = level.cam_targets[num].cpoints.size;
	level.cam_targets[num].cpoints[size] = cp;
#/
}

copy_shot( name, copy_name )
{
/#
	level.cam_shots[copy_name] = SpawnStruct();
	level.cam_shots[copy_name].cam_track = level.cam_shots[name].cam_track;
	level.cam_shots[copy_name].cam_target = level.cam_shots[name].cam_target;
#/
}

remove_shot( shot_name )
{
/#
	level.cam_shots[shot_name] = undefined;
#/
}

//-------------------------//
// GENERIC DRAWING SECTION //
//-------------------------//

draw_all_shots()
{
/#
	if( !IsDefined( level.cam_shots ) || level.cam_shots.size < 1 )
	{
		return;
	}

	keys = level.cam_shots;
	for( i = 0; i < keys.size; i++ )
	{
		draw_shot_track( level.cam_shots[keys[i]] );
		draw_shot_target( level.cam_shots[keys[i]] );
	}
#/
}

draw_all_tracks_and_targets()
{
/#
	draw_all_tracks();
	draw_all_targets();
#/
}

draw_all_tracks()
{
/#
	for( i = 0; i < level.cam_track.size; i++ )
	{
		draw_track( i );
	}
#/
}

draw_track( num )
{
/#
	draw_track = false;
	if( IsDefined( level.cam_tracks ) && IsDefined( level.cam_tracks[num] ) )
	{
		if( IsCurve( level.cam_tracks[num].type ) )
		{
			if( level.cam_tracks[num].cpoints.size < 2 )
			{
				println( "^3---Track needs 2 CPoints before it can draw..." );
			}
			else
			{
				draw_track = true;
			}
		}
		else if( level.cam_tracks[num].type == "Point" )
		{
			draw_track = true;
		}
	}

	if( !IsDefined( level.drawn_tracks ) )
	{
		level.drawn_tracks = [];
	}

	if( IsDefined( level.drawn_tracks[num] ) )
	{
		if( IsString( level.drawn_tracks[num] ) )
		{
			level notify( level.drawn_tracks[num] );
		}	
		else // Assume curve id
		{
			FreeCurve( level.drawn_tracks[num] );
		}
	}

	// Draw Track
	if( draw_track && IsDefined( level.cam_tracks[num] ) )
	{
		if( IsCurve( level.cam_tracks[num].type )  )
		{
			level.drawn_tracks[num] = build_curve( level.cam_tracks[num].cpoints );
			DrawCurve( level.drawn_tracks[num], ( 0, 1, 0 ) );
		}
		else if( level.cam_tracks[num].type == "Point" )
		{
			level.drawn_tracks[num] = draw_point( level.cam_tracks[num].cpoints[0].origin, "track", num, ( 0, 0, 1 ) );
		}
	}
#/
}

draw_point( origin, point_type, num, color )
{
/#
	level thread draw_point_thread( origin, num, color );

	return "stop_drawing_" + point_type + num;
#/
}

draw_point_thread( origin, num, color )
{
/#
	level endon( "stop_drawing_" + num );
	points = get_square_points( origin, 5 );

	while( 1 )
	{
		// Top
		line( points[0], points[1], color );
		line( points[1], points[2], color );
		line( points[2], points[3], color );
		line( points[3], points[0], color );

		// Bottom
		line( points[4], points[5], color );
		line( points[5], points[6], color );
		line( points[6], points[7], color );
		line( points[7], points[4], color );

		// Sides
		line( points[0], points[4], color );
		line( points[1], points[5], color );
		line( points[2], points[6], color );
		line( points[3], points[7], color );

		wait( 0.05 );
	}
#/
}

get_square_points( origin, square_width )
{
	points = [];

	square_width = square_width * 0.5;
	points[0] = origin + ( square_width, square_width, square_width );
	points[1] = origin + ( square_width, square_width * -1, square_width );
	points[2] = origin + ( square_width * -1, square_width * -1, square_width );
	points[3] = origin + ( square_width * -1, square_width, square_width );
	points[4] = origin + ( square_width, square_width, square_width * -1 );
	points[5] = origin + ( square_width, square_width * -1, square_width * -1 );
	points[6] = origin + ( square_width * -1, square_width * -1, square_width * -1 );
	points[7] = origin + ( square_width * -1, square_width, square_width * -1 );

	return points;
}

draw_all_targets()
{
/#
	for( i = 0; i < level.cam_targets.size; i++ )
	{
		draw_target( i );
	}
#/
}

draw_target( num )
{
/#
	draw_target = false;
	if( IsDefined( level.cam_targets ) && IsDefined( level.cam_targets[num] ) )
	{
		if( level.cam_targets[num].type == "Timed Curve" )
		{
			if( level.cam_targets[num].cpoints.size < 2 )
			{
				println( "^3---Track needs 2 CPoints before it can draw..." );
			}
			else
			{
				draw_target = true;
			}
		}
		else if( level.cam_targets[num].type == "Point" )
		{
			draw_target = true;
		}
	}

	if( !IsDefined( level.drawn_targets ) )
	{
		level.drawn_targets = [];
	}

	if( IsDefined( level.drawn_targets[num] ) )
	{
		if( IsString( level.drawn_targets[num] ) )
		{
			level notify( level.drawn_targets[num] );
		}	
		else // Assume curve id
		{
			FreeCurve( level.drawn_targets[num] );
		}
	}

	// Draw Target
	if( draw_target && IsDefined( level.cam_targets[num] ) )
	{
		if( IsCurve( level.cam_tracks[num].type ) )
		{
			level.drawn_targets[num] = build_curve( level.cam_targets[num].cpoints );
			DrawCurve( level.drawn_targets[num], ( 1, 1, 0 ) );
		}
		else if( level.cam_targets[num].type == "Point" )
		{
			level.drawn_targets[num] = draw_point( level.cam_targets[num].cpoints[0].origin, "target", num, ( 1, 1, 0 ) );
		}
	}
#/
}

//---------------//
// Scene Section //
//---------------//

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