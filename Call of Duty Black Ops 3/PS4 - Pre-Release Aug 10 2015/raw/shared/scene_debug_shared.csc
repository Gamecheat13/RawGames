#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
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
	
	level thread run_scene_tests();
	level thread toggle_scene_menu();
}

function run_scene_tests()
{
	level endon( "run_scene_tests" );
	
	level.scene_test_struct = SpawnStruct();
	level.scene_test_struct.origin = (0, 0, 0);
	level.scene_test_struct.angles = (0, 0, 0);
				
	while ( true )
	{
		str_scene = GetDvarString( "run_client_scene");
		str_mode = ToLower( GetDvarString( "scene_menu_mode", "default" ) );
		
		if ( str_scene != "" )
		{
			SetDvar( "run_client_scene", "" );
			
			clear_old_ents( str_scene );
			
			b_found = false;
			
			a_scenes = struct::get_array( str_scene, "scriptbundlename" );
			foreach ( s_instance in a_scenes )
			{
				if ( isdefined( s_instance ) )
				{
					b_found = true;
					s_instance thread scene::test_play( undefined, str_mode );
				}
			}
			
			if ( isdefined( level.active_scenes[ str_scene ] ) )
			{
				foreach ( s_instance in level.active_scenes[ str_scene ] )
				{
					b_found = true;
					s_instance thread scene::test_play( str_scene, str_mode );
				}
			}
			
			if ( !b_found )
			{
				level.scene_test_struct thread scene::test_play( str_scene, str_mode );
			}
		}
		
		str_scene = GetDvarString( "init_client_scene");
		if ( str_scene != "" )
		{
			SetDvar( "init_client_scene", "" );
			
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
		}
		
		str_scene = GetDvarString( "stop_client_scene");
		if ( str_scene != "" )
		{
			SetDvar( "stop_client_scene", "" );
			level scene::stop( str_scene, true );
		}
		
		{wait(.016);};
	}
}

function clear_old_ents( str_scene )
{
	foreach ( ent in GetEntArray( 0 ) )
	{
		if ( ( ent.scene_spawned === str_scene ) && ( ent.finished_scene === str_scene ) )
		{
			ent Delete();
		}
	}
}

function toggle_scene_menu()
{
	SetDvar( "client_scene_menu", 0 );
	
	n_scene_menu_last = -1;
	
	while ( true )
	{
		n_scene_menu = GetDvarString( "client_scene_menu" );
		
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
	
	hudelem = CreateLUIMenu( 0, "HudElementText" );
	SetLuiMenuData( 0, hudelem, "text", scene_name );
	SetLuiMenuData( 0, hudelem, "x", 100 );
	SetLuiMenuData( 0, hudelem, "y", 80 + index * 18 );
	SetLuiMenuData( 0, hudelem, "width", 1000 );
	OpenLUIMenu( 0, hudelem );	
	
	return hudelem;
}




function display_scene_menu( str_type = "scene" )
{
	level notify( "scene_menu_cleanup" );
	level endon( "scene_menu_cleanup" );
	
	waittillframeend;
	
	level flagsys::set( "menu_open" );
	SetDvar( "cl_tacticalHud", 0 );
	
	level thread display_mode();
	
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
	
	level thread scene_menu_cleanup( elems, title );
	
	while ( true )
	{
		scene_list_settext( elems, names, selected );
		
		if ( held )
		{
			wait .5;
		}
		
		if ( !up_pressed )
		{
			if ( level.localplayers[0] util::up_button_pressed() )
			{
				up_pressed = true;
				selected--;
			}
		}
		else
		{
			if ( level.localplayers[0] util::up_button_held() )
			{
				held = true;
				selected -= 10; // page down
			}
			else if ( !level.localplayers[0] util::up_button_pressed() )
			{
				held = false;
				up_pressed = false;
			}
		}

		if ( !down_pressed )
		{
			if ( level.localplayers[0] util::down_button_pressed() )
			{
				down_pressed = true;
				selected++;
			}
		}
		else
		{
			if ( level.localplayers[0] util::down_button_held() )
			{
				held = true;
				selected += 10; // page down
			}
			else if ( !level.localplayers[0] util::down_button_pressed() )
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

		if ( level.localplayers[0] ButtonPressed( "BUTTON_B" ) )
		{
			SetDvar( "client_scene_menu", 0 );
		}
		
		if ( level.localplayers[0] ButtonPressed( "kp_enter" ) || level.localplayers[0] ButtonPressed( "BUTTON_A" ) || level.localplayers[0] ButtonPressed( "enter" ) )
		{
			if ( names[ selected ] == "exit" )
			{
				SetDvar( "client_scene_menu", 0 );
			}
			else if ( is_scene_playing( names[ selected ] ) )
			{
				SetDvar( "stop_client_scene", names[ selected ] );
			}
			else if ( is_scene_initialized( names[ selected ] ) )
			{
				SetDvar( "run_client_scene", names[ selected ] );
			}
			else
			{
				if ( scene::has_init_state( names[ selected ] ) )
				{
					SetDvar( "init_client_scene", names[ selected ] );
				}
				else
				{
					SetDvar( "run_client_scene", names[ selected ] );
				}
			}
			
			while ( level.localplayers[0] ButtonPressed( "kp_enter" ) || level.localplayers[0] ButtonPressed( "BUTTON_A" ) || level.localplayers[0] ButtonPressed( "enter" ) )
			{
				{wait(.016);};
			}
		}
		
		{wait(.016);};
	}
}

function display_mode()
{
	hudelem = CreateLUIMenu( 0, "HudElementText" );
	SetLuiMenuData( 0, hudelem, "x", 100 );
	SetLuiMenuData( 0, hudelem, "y", 490 );
	SetLuiMenuData( 0, hudelem, "width", 500 );
	OpenLUIMenu( 0, hudelem );
	
	while ( level flagsys::get( "menu_open" ) )
	{	
		str_mode = ToLower( GetDvarString( "scene_menu_mode", "default" ) );
	
		switch ( str_mode )
		{
			case "default":
				SetLuiMenuData( 0, hudelem, "text", "Mode: Default" );
				break;
			case "loop":
				SetLuiMenuData( 0, hudelem, "text", "Mode: Loop" );
				break;
			case "capture_single":
				SetLuiMenuData( 0, hudelem, "text", "Mode: Capture Single" );
				break;
			case "capture_series":
				SetLuiMenuData( 0, hudelem, "text", "Mode: Capture Series" );
				break;
		}
		
		wait .05;
	}
	
	CloseLUIMenu( 0, hudelem );
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
			SetLuiMenuData( 0, hud_array[ i ], "alpha", 1 );
			text += " (playing)";
		}
		else if ( is_scene_initialized( text ) )
		{
//			hud_array[ i ].color = ( .5, .9, .5 );
			SetLuiMenuData( 0, hud_array[ i ], "alpha", 1 );
			text += " (initialized)";
		}
		else
		{
//			hud_array[ i ].color = ( 0.9, 0.9, 0.9 );
			SetLuiMenuData( 0, hud_array[ i ], "alpha", .5 );
		}
		
		if ( i == 5 ) // Selected
		{
			SetLuiMenuData( 0, hud_array[ i ], "alpha", 1 );
			text = ">" + text + "<";
		}

		SetLuiMenuData( 0, hud_array[ i ], "text", text );
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

function scene_menu_cleanup( elems, title )
{
	level waittill( "scene_menu_cleanup" );
	
	CloseLuiMenu( 0, title );
	for ( i = 0; i < elems.size; i++ )
	{
		CloseLuiMenu( 0, elems[ i ] );
	}
}

function test_init( arg1 )
{
	scene::init( arg1, undefined, undefined, true );
}

function test_play( arg1, str_mode )
{
	scene::play( arg1, undefined, undefined, true, str_mode );
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
			DEBUG_TIME = DEBUG_FRAMES / 60;
			
			Sphere( self.origin, 1, ( 0, 1, 1 ), 1, true, 8, DEBUG_FRAMES );
				
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

#/
