#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace scene;

/#
	
function autoexec __init__sytem__() {     system::register("scene_debug",&__init__,undefined,undefined);    }

function __init__()
{
	if ( GetDvarString( "scene_menu_mode", "" ) == "" )
	{
		SetDvar( "scene_menu_mode", "default" );
	}
	
	SetDvar( "run_client_scene", "" );
	SetDvar( "init_client_scene", "" );
	SetDvar( "stop_client_scene", "" );
		
	level thread run_scene_tests();
	level thread toggle_scene_menu();
	level thread toggle_postfx_igc_loop();
}

function run_scene_tests()
{
	level endon( "run_scene_tests" );
	
	level.scene_test_struct = SpawnStruct();
	level.scene_test_struct.origin = (0, 0, 0);
	level.scene_test_struct.angles = (0, 0, 0);
				
	while ( true )
	{
		str_scene = GetDvarString( "run_scene");
		str_client_scene = GetDvarString( "run_client_scene");
		
		str_mode = ToLower( GetDvarString( "scene_menu_mode", "default" ) );
		
		b_capture = ( ( str_mode == "capture_single" ) || ( str_mode == "capture_series" ) );
		
		if ( b_capture )
		{
			if ( IsPC() )
			{
				if ( str_scene != "" )
				{					
					SetDvar( "init_scene", str_scene );
					SetDvar( "run_scene", "" );
				}
			}
			else
			{
				SetDvar( "scene_menu_mode", "default" );
			}
		}
		else
		{
			if ( str_client_scene != "" )
			{
				level util::clientnotify( str_client_scene + "playtest" );
				util::wait_network_frame();
			}
			
			if ( str_scene != "" )
			{
				SetDvar( "run_scene", "" );
				
				clear_old_ents( str_scene );
				
				b_found = false;
				
				if ( isdefined( level.active_scenes[ str_scene ] ) )
				{
					foreach ( s_instance in level.active_scenes[ str_scene ] )
					{
						b_found = true;
						s_instance thread scene::test_play( str_scene, str_mode );
					}
				}
				
				a_scenes = struct::get_array( str_scene, "scriptbundlename" );
				foreach ( s_instance in a_scenes )
				{
					if ( isdefined( s_instance ) )
					{
						b_found = true;
						s_instance thread scene::test_play( undefined, str_mode );
					}
				}
				
				if ( !b_found )
				{
					level.scene_test_struct thread scene::test_play( str_scene, str_mode );
				}
			}
		}
		
		str_scene = GetDvarString( "init_scene");
		str_client_scene = GetDvarString( "init_client_scene");
		
		if ( str_client_scene != "" )
		{
			level util::clientnotify( str_client_scene + "inittest" );
			util::wait_network_frame();
		}
		
		if ( str_scene != "" )
		{
			SetDvar( "init_scene", "" );
			
			clear_old_ents( str_scene );
			
			b_found = false;
			
			a_scenes = struct::get_array( str_scene, "scriptbundlename" );
			foreach ( s_instance in a_scenes )
			{
				if ( isdefined( s_instance ) )
				{
					b_found = true;
					s_instance thread scene::test_init();
				}
			}
			
			if ( !b_found )
			{
				level.scene_test_struct thread scene::test_init( str_scene );
			}
			
			if ( b_capture )
			{
				capture_scene( str_scene, str_mode );
			}
		}
		
		str_scene = GetDvarString( "stop_scene");
		str_client_scene = GetDvarString( "stop_client_scene");
		
		if ( str_client_scene != "" )
		{
			level util::clientnotify( str_client_scene + "stoptest" );
			util::wait_network_frame();
		}
		
		if ( str_scene != "" )
		{
			SetDvar( "stop_scene", "" );
			level scene::stop( str_scene, true );
		}
		
		{wait(.05);};
	}
}

function capture_scene( str_scene, str_mode )
{
	SetDvar( "scene_menu", 0 );
	level scene::play( str_scene, undefined, undefined, true, undefined, str_mode );
}

function clear_old_ents( str_scene )
{
	foreach ( ent in GetEntArray( str_scene, "finished_scene" ) )
	{
		if ( ent.scene_spawned === str_scene )
		{
			ent Delete();
		}
	}
}

function toggle_scene_menu()
{
	SetDvar( "scene_menu", 0 );
	
	n_scene_menu_last = -1;
	
	while ( true )
	{
		n_scene_menu = GetDvarString( "scene_menu" );
		
		if ( n_scene_menu != "" )
		{
			n_scene_menu = int( n_scene_menu );
			
			if ( n_scene_menu != n_scene_menu_last )
			{
				switch ( n_scene_menu )
				{
					case 1:
						
						level thread display_scene_menu( "scene" );
						break;
						
					case 2:
						
						level thread display_scene_menu( "fxanim" );
						break;
						
					default:
						
						level flagsys::clear( "menu_open" );
						level notify( "scene_menu_cleanup" );
						SetDvar( "bgcache_disablewarninghints", 0 );
						SetDvar( "cl_tacticalHud", 1 );
				}
				
				n_scene_menu_last = n_scene_menu;
			}
		}
		
		wait .05;
	}
}

function create_scene_hud( scene_name, index )
{
	player = level.players[0];
	
	alpha = 1;
	color = ( 0.9, 0.9, 0.9 );
	if ( index != -1 )
	{
		const middle = 5;
		if ( index != middle )
		{
			alpha = 1 - ( abs( middle - index ) / middle );
		}
	}

	if ( alpha == 0 )
	{
		alpha = 0.05;
	}

	hudelem = player OpenLUIMenu( "HudElementText" );
	player SetLuiMenuData( hudelem, "text", scene_name );
	player SetLuiMenuData( hudelem, "x", 100 );
	player SetLuiMenuData( hudelem, "y", 80 + index * 18 );
	player SetLuiMenuData( hudelem, "width", 1000 );
	
	return hudelem;
}




function display_scene_menu( str_type = "scene" )
{
	level notify( "scene_menu_cleanup" );
	level endon( "scene_menu_cleanup" );
	
	waittillframeend;
	
	level flagsys::set( "menu_open" );
	SetDvar( "bgcache_disablewarninghints", 1 );
	SetDvar( "cl_tacticalHud", 0 );
	
	level thread display_mode();
	
	hudelem = level.players[0] OpenLUIMenu( "HudElementText" );
	level.players[0] SetLuiMenuData( hudelem, "text", "Press LEFT/RIGHT to jump to scene" );
	level.players[0] SetLuiMenuData( hudelem, "x", 100 );
	level.players[0] SetLuiMenuData( hudelem, "y", 520 );
	level.players[0] SetLuiMenuData( hudelem, "width", 500 );
	
	a_scenedefs = scene::get_scenedefs( str_type );
	if ( str_type == "scene" )
	{
		// add awareness scenes
		a_scenedefs = ArrayCombine(
							a_scenedefs,
	                        scene::get_scenedefs( "awareness" ),
	                        false, true
	                       );
	}
	
	names = [];
	
	foreach ( s_scenedef in a_scenedefs )
	{
		array::add_sorted( names, s_scenedef.name, false );
	}
	
	names[ names.size ] = "exit";

	elems = scene_list_menu();
	
	// Available skiptos:
	title = create_scene_hud( str_type + "s:", -1 );
	
	selected = 0;
	up_pressed = false;
	down_pressed = false;
	held = false;
	
	scene_list_settext( elems, names, selected );
	old_selected = selected;
	
	level thread scene_menu_cleanup( elems, title, hudelem );
	
	while ( true )
	{
		scene_list_settext( elems, names, selected );
		
		if ( held )
		{
			wait .5;
		}
		
		if ( !up_pressed )
		{
			if ( level.players[0] util::up_button_pressed() )
			{
				up_pressed = true;
				selected--;
			}
		}
		else
		{
			if ( level.players[0] util::up_button_held() )
			{
				held = true;
				selected -= 10; // page down
			}
			else if ( !level.players[0] util::up_button_pressed() )
			{
				held = false;
				up_pressed = false;
			}
		}

		if ( !down_pressed )
		{
			if ( level.players[0] util::down_button_pressed() )
			{
				down_pressed = true;
				selected++;
			}
		}
		else
		{
			if ( level.players[0] util::down_button_held() )
			{
				held = true;
				selected += 10; // page down
			}
			else if ( !level.players[0] util::down_button_pressed() )
			{
				held = false;
				down_pressed = false;
			}
		}
		
		if ( held )
		{
			if ( selected < 0 )
			{
				selected = 0;
			}	
			else if ( selected >= names.size )
			{
				selected = names.size - 1;
			}
		}
		else
		{		
			if ( selected < 0 )
			{
				selected = names.size - 1;
			}	
			else if ( selected >= names.size )
			{
				selected = 0;
			}
		}

		if ( level.players[0] ButtonPressed( "BUTTON_B" ) )
		{
			SetDvar( "scene_menu", 0 );
		}
		
		if ( names[ selected ] != "exit" )
		{
			if ( level.players[0] ButtonPressed( "RIGHTARROW" ) || level.players[0] ButtonPressed( "DPAD_RIGHT" ) )
			{
				level.players[0] move_to_scene( names[ selected ] );
					
				while ( level.players[0] ButtonPressed( "RIGHTARROW" ) || level.players[0] ButtonPressed( "DPAD_RIGHT" ) )
				{
					{wait(.05);};
				}
			}
			else if ( level.players[0] ButtonPressed( "LEFTARROW" ) || level.players[0] ButtonPressed( "DPAD_LEFT" ) )
			{
				level.players[0] move_to_scene( names[ selected ], true );
					
				while ( level.players[0] ButtonPressed( "LEFTARROW" ) || level.players[0] ButtonPressed( "DPAD_LEFT" ) )
				{
					{wait(.05);};
				}
			}
		}

		if ( level.players[0] ButtonPressed( "kp_enter" ) || level.players[0] ButtonPressed( "BUTTON_A" ) || level.players[0] ButtonPressed( "enter" ) )
		{
			if ( names[ selected ] == "exit" )
			{
				SetDvar( "scene_menu", 0 );
			}
			else if ( is_scene_playing( names[ selected ] ) )
			{
				SetDvar( "stop_scene", names[ selected ] );
			}
			else if ( is_scene_initialized( names[ selected ] ) )
			{
				SetDvar( "run_scene", names[ selected ] );
			}
			else
			{
				if ( scene::has_init_state( names[ selected ] ) )
				{
					SetDvar( "init_scene", names[ selected ] );
				}
				else
				{
					SetDvar( "run_scene", names[ selected ] );
				}
			}
			
			while ( level.players[0] ButtonPressed( "kp_enter" ) || level.players[0] ButtonPressed( "BUTTON_A" ) || level.players[0] ButtonPressed( "enter" ) )
			{
				{wait(.05);};
			}
		}
		
		{wait(.05);};
	}
}

function display_mode()
{
	hudelem = level.players[0] OpenLUIMenu( "HudElementText" );
	level.players[0] SetLuiMenuData( hudelem, "x", 100 );
	level.players[0] SetLuiMenuData( hudelem, "y", 490 );
	level.players[0] SetLuiMenuData( hudelem, "width", 500 );
	
	while ( level flagsys::get( "menu_open" ) )
	{	
		str_mode = ToLower( GetDvarString( "scene_menu_mode", "default" ) );
	
		switch ( str_mode )
		{
			case "default":
				level.players[0] SetLuiMenuData( hudelem, "text", "Mode: Default" );
				break;
			case "loop":
				level.players[0] SetLuiMenuData( hudelem, "text", "Mode: Loop" );
				break;
			case "capture_single":
				level.players[0] SetLuiMenuData( hudelem, "text", "Mode: Capture Single" );
				break;
			case "capture_series":
				level.players[0] SetLuiMenuData( hudelem, "text", "Mode: Capture Series" );
				break;
		}
		
		wait .05;
	}
	
	level.players[0] CloseLUIMenu( hudelem );
}

function scene_list_menu()
{
	hud_array = [];
	for ( i = 0; i < 22; i++ )
	{
		hud = create_scene_hud( "", i );
		hud_array[ hud_array.size ] = hud;
	}

	return hud_array;
}

function scene_list_settext( hud_array, strings, num )
{
	for ( i = 0; i < hud_array.size; i++ )
	{
		index = i + ( num - 5 );
		if ( isdefined( strings[ index ] ) )
		{
			text = strings[ index ];
		}
		else
		{
			text = "";
		}
		
		if ( is_scene_playing( text ) )
		{
//			hud_array[ i ].color = ( .5, .9, .5 );
			level.players[0] SetLuiMenuData( hud_array[ i ], "alpha", 1 );
			text += " (playing)";
		}
		else if ( is_scene_initialized( text ) )
		{
//			hud_array[ i ].color = ( .5, .9, .5 );
			level.players[0] SetLuiMenuData( hud_array[ i ], "alpha", 1 );
			text += " (initialized)";
		}
		else
		{
//			hud_array[ i ].color = ( 0.9, 0.9, 0.9 );
			level.players[0] SetLuiMenuData( hud_array[ i ], "alpha", .5 );
		}
		
		if ( i == 5 ) // Selected
		{
			level.players[0] SetLuiMenuData( hud_array[ i ], "alpha", 1 );
			text = ">" + text + "<";
		}

		level.players[0] SetLuiMenuData( hud_array[ i ], "text", text );
	}
}

function is_scene_playing( str_scene )
{
	if ( str_scene != "" && str_scene != "exit" )
	{
		if ( level flagsys::get( str_scene + "_playing" ) )
		{
			return true;
		}
	}
	
	return false;
}

function is_scene_initialized( str_scene )
{
	if ( str_scene != "" && str_scene != "exit" )
	{
		if ( level flagsys::get( str_scene + "_initialized" ) )
		{
			return true;
		}
	}
	
	return false;
}

function scene_menu_cleanup( elems, title, hudelem )
{
	level waittill( "scene_menu_cleanup" );
	
	level.players[0] CloseLuiMenu( title );
	for ( i = 0; i < elems.size; i++ )
	{
		level.players[0] CloseLuiMenu( elems[ i ] );
	}
	
	level.players[0] CloseLuiMenu( hudelem );
}

function test_init( arg1 )
{
	scene::init( arg1, undefined, undefined, true );
}

function test_play( arg1, str_mode )
{
	scene::play( arg1, undefined, undefined, true, undefined, str_mode );
}

//function test_spawn( arg1, arg2, arg3, arg4 )
//{
//	return scene::spawn( arg1, arg2, arg3, arg4, true );
//}



// self = scene root
function debug_display()
{
	self endon( "death" );
	
	if ( !( isdefined( self.debug_display ) && self.debug_display ) && ( self != level ) )
	{
		self.debug_display = true;
		
		while ( true )
		{
			level flagsys::wait_till( "anim_debug" );
			
			DEBUG_FRAMES = RandomIntRange( 5, 15 );
			DEBUG_TIME = DEBUG_FRAMES / 20;
			
			Sphere( self.origin, 1, ( 1, 1, 0 ), 1, true, 8, DEBUG_FRAMES );
				
			if ( isdefined( self.scenes ) )
			{
				foreach ( i, o_scene in self.scenes )
				{
					n_offset = (15*(i+1));
					Print3d( self.origin - ( 0, 0, n_offset ), [[o_scene]]->get_name(), ( .8, .2, .8 ), 1, .3, DEBUG_FRAMES );
					Print3d( self.origin - ( 0, 0, n_offset + 5 ), "(" + (isdefined([[o_scene]]->get_state())?""+[[o_scene]]->get_state():"") + ")", ( .8, .2, .8 ), 1, .15, DEBUG_FRAMES );
				}
			}
			else if ( isdefined( self.scriptbundlename ) )
			{
				Print3d( self.origin - ( 0, 0, 15 ), self.scriptbundlename, ( .8, .2, .8 ), 1, .3, DEBUG_FRAMES );
			}
			else
			{
				self.debug_display = false;
				break;
			}
			
			wait DEBUG_TIME;
		}
	}
}

function move_to_scene( str_scene, b_reverse_dir = false )
{
	if ( !( level.debug_current_scene_name === str_scene ) )
	{
		level.debug_current_scene_instances = struct::get_array( str_scene, "scriptbundlename" );
		level.debug_current_scene_index = 0;
		level.debug_current_scene_name = str_scene;
	}
	else
	{
		if ( b_reverse_dir )
		{
			level.debug_current_scene_index--;
			if ( level.debug_current_scene_index == -1 )
			{
				level.debug_current_scene_index = level.debug_current_scene_instances.size - 1;
			}
		}
		else
		{
			level.debug_current_scene_index++;
			if ( level.debug_current_scene_index == level.debug_current_scene_instances.size )
			{
				level.debug_current_scene_index = 0;
			}
		}
	}
	
	if ( level.debug_current_scene_instances.size == 0 )
	{
		s_bundle = struct::get_script_bundle( "scene", str_scene );
		if ( isdefined( s_bundle.aligntarget ) )
		{
			e_align = scene::get_existing_ent( s_bundle.aligntarget, false, true );
			if ( isdefined( e_align ) )
			{
				level.players[0] set_origin( e_align.origin );
			}
			else
			{
				scriptbundle::error_on_screen( "Align target doesn't exist, can't move to scene" );
			}
		}
		else
		{
			scriptbundle::error_on_screen( "No align target specified, can't move to scene" );
		}
	}
	else
	{
		s_scene = level.debug_current_scene_instances[ level.debug_current_scene_index ];
		
		level.players[0] set_origin( s_scene.origin );
	}
}

function set_origin( v_origin )
{
	if ( !self IsInMoveMode( "ufo", "noclip" ) )
	{
		AddDebugCommand( "noclip" );
	}
	
	self SetOrigin( v_origin );
}

function toggle_postfx_igc_loop()
{
	while ( true )
	{
		if ( GetDvarInt( "scr_postfx_igc_loop", 0 ) )
		{
			array::run_all( level.activeplayers, &clientfield::increment_to_player, "postfx_igc", 1 );
			wait 4; // the effect is currently about 4 seconds long
		}
		
		wait 1;
	}
}

#/
