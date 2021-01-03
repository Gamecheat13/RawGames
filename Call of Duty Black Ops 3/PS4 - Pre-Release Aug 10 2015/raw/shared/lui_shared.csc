#using scripts\codescripts\struct;

#using scripts\shared\_character_customization;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\core\_multi_extracam;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
	
#namespace lui;

function autoexec __init__sytem__() {     system::register("lui_shared",&__init__,undefined,undefined);    }

function __init__()
{
	level.client_menus = associativeArray();
	callback::on_localclient_connect( &on_player_connect );
}

function on_player_connect( localClientNum )
{
	level thread client_menus( localClientNum );
}

function initMenuData( localClientNum )
{
	assert( !isdefined( level.client_menus[localClientNum] ) );
	level.client_menus[localClientNum] = associativeArray();
}

function createExtraCamXCamData( menu_name, localClientNum, extracam_index, target_name, xcam, sub_xcam )
{
	assert( isdefined( level.client_menus[localClientNum][menu_name] ) );
	menu_data = level.client_menus[localClientNum][menu_name];
	
	extracam_data = SpawnStruct();
	extracam_data.extracam_index = extracam_index;
	extracam_data.target_name = target_name;
	extracam_data.xcam = xcam;
	extracam_data.sub_xcam = sub_xcam;
	
	if ( !isdefined( menu_data.extra_cams ) ) menu_data.extra_cams = []; else if ( !IsArray( menu_data.extra_cams ) ) menu_data.extra_cams = array( menu_data.extra_cams ); menu_data.extra_cams[menu_data.extra_cams.size]=extracam_data;;
}

function createCustomExtraCamXCamData( menu_name, localClientNum, extracam_index, camera_function )
{
	assert( isdefined( level.client_menus[localClientNum][menu_name] ) );
	menu_data = level.client_menus[localClientNum][menu_name];
	
	extracam_data = SpawnStruct();
	extracam_data.extracam_index = extracam_index;
	extracam_data.camera_function = camera_function;
	
	if ( !isdefined( menu_data.extra_cams ) ) menu_data.extra_cams = []; else if ( !IsArray( menu_data.extra_cams ) ) menu_data.extra_cams = array( menu_data.extra_cams ); menu_data.extra_cams[menu_data.extra_cams.size]=extracam_data;;
}

function addMenuExploders( menu_name, localClientNum, exploder )
{
	assert( isdefined( level.client_menus[localClientNum][menu_name] ) );
	menu_data = level.client_menus[localClientNum][menu_name];
	
	if ( IsArray( exploder ) )
	{
		foreach ( expl in exploder )
		{
			if ( !isdefined( menu_data.exploders ) ) menu_data.exploders = []; else if ( !IsArray( menu_data.exploders ) ) menu_data.exploders = array( menu_data.exploders ); menu_data.exploders[menu_data.exploders.size]=expl;;
		}
	}
	else
	{
		if ( !isdefined( menu_data.exploders ) ) menu_data.exploders = []; else if ( !IsArray( menu_data.exploders ) ) menu_data.exploders = array( menu_data.exploders ); menu_data.exploders[menu_data.exploders.size]=exploder;;
	}
}

#using_animtree( "all_player" );
function linkToCustomCharacter( menu_name, localClientNum, target_name )
{
	assert( isdefined( level.client_menus[localClientNum][menu_name] ) );
	menu_data = level.client_menus[localClientNum][menu_name];
	assert( !isdefined( menu_data.custom_character ) );
	
	model = GetEnt( localClientNum, target_name, "targetname" );
	if ( !isdefined( model ) )
	{
		model = util::spawn_model( localClientNum, "tag_origin" );
		model.targetname = target_name;
	}
	model UseAnimTree( #animtree );
	
	menu_data.custom_character = character_customization::create_character_data_struct( model );
	model Hide();
}

function getCharacterDataForMenu( menu_name, localClientNum )
{
	if ( isdefined( level.client_menus[localClientNum][menu_name] ) )
	{
		return level.client_menus[localClientNum][menu_name].custom_character;
	}
	
	return undefined;
}

function createCameraMenu( menu_name, localClientNum, target_name, xcam, sub_xcam, custom_open_fn = undefined, custom_close_fn = undefined, extra_cams = undefined )
{
	assert( !isdefined( level.client_menus[localClientNum][menu_name] ) );
	level.client_menus[localClientNum][menu_name] = SpawnStruct();
	menu_data = level.client_menus[localClientNum][menu_name];
	
	menu_data.target_name = target_name;
	menu_data.xcam = xcam;
	menu_data.sub_xcam = sub_xcam;
	menu_data.custom_open_fn = custom_open_fn;
	menu_data.custom_close_fn = custom_close_fn;
	menu_data.extra_cams = extra_cams;
	
	return menu_data;
}

function createCustomCameraMenu( menu_name, localClientNum, camera_function, has_state, custom_open_fn = undefined, custom_close_fn = undefined, extra_cams = undefined )
{
	assert( !isdefined( level.client_menus[localClientNum][menu_name] ) );
	level.client_menus[localClientNum][menu_name] = SpawnStruct();
	menu_data = level.client_menus[localClientNum][menu_name];
	
	menu_data.camera_function = camera_function;
	menu_data.has_state = has_state;
	menu_data.custom_open_fn = custom_open_fn;
	menu_data.custom_close_fn = custom_close_fn;
	menu_data.extra_cams = extra_cams;
	
	return menu_data;
}

function setup_menu( localClientNum, menu_data, previous_menu )
{
	// handle closing the previous menu
	if ( isdefined( previous_menu ) && isdefined( level.client_menus[localClientNum][previous_menu.menu_name] ) )
	{
		previous_menu_info = level.client_menus[localClientNum][previous_menu.menu_name];
		
		if ( isdefined( previous_menu_info.custom_close_fn ) )
		{
			if ( isarray( previous_menu_info.custom_close_fn ) )
			{
				foreach ( fn in previous_menu_info.custom_close_fn )
				{
					[[fn]]( localClientNum, previous_menu_info );
				}
			}
			else
			{
				[[previous_menu_info.custom_close_fn]]( localClientNum, previous_menu_info );
			}
		}
		
		if ( isdefined( previous_menu_info.extra_cams ) )
		{
			foreach ( extracam_data in previous_menu_info.extra_cams )
			{
				multi_extracam::extracam_reset_index( extracam_data.extracam_index );
			}
		}
		
		level notify( previous_menu.menu_name + "_closed" );
		if ( isdefined( previous_menu_info.camera_function ) )
		{
			StopMainCamXCam( localClientNum );
		}
		else if ( isdefined( previous_menu_info.xcam ) )
		{
			StopMainCamXCam( localClientNum );
		}
		
		if ( isdefined( previous_menu_info.custom_character ) )
		{
			previous_menu_info.custom_character.characterModel Hide();
		}
		
		if ( isdefined( previous_menu_info.exploders ) )
		{
			foreach ( exploder in previous_menu_info.exploders )
			{
				KillRadiantExploder( localClientNum, exploder );
			}
		}
	}
	
	// setup our new menu
	if ( isdefined( menu_data ) && isdefined( level.client_menus[localClientNum][menu_data.menu_name] ) )
	{
		new_menu = level.client_menus[localClientNum][menu_data.menu_name];
		
		if ( isdefined( new_menu.custom_character ) )
		{
			new_menu.custom_character.characterModel Show();
		}
		
		if ( isdefined( new_menu.exploders ) )
		{
			foreach ( exploder in new_menu.exploders )
			{
				PlayRadiantExploder( localClientNum, exploder );
			}
		}

		if ( isdefined( new_menu.camera_function ) )
		{
			if ( new_menu.has_state === true )
			{
				level thread [[new_menu.camera_function]]( localClientNum, menu_data.menu_name, menu_data.state );
			}
			else
			{
				level thread [[new_menu.camera_function]]( localClientNum, menu_data.menu_name );
			}
		}
		else if ( isdefined( new_menu.xcam ) )
		{
			camera_ent = struct::get( new_menu.target_name );
			if ( isdefined( camera_ent ) )
			{
				PlayMainCamXCam( localclientnum, new_menu.xcam, 0, new_menu.sub_xcam, "", camera_ent.origin, camera_ent.angles );
			}
		}
		
		if ( isdefined( new_menu.custom_open_fn ) )
		{
			if ( isarray( new_menu.custom_open_fn ) )
			{
				foreach ( fn in new_menu.custom_open_fn )
				{
					[[fn]]( localClientNum, new_menu );
				}
			}
			else
			{
				[[new_menu.custom_open_fn]]( localClientNum, new_menu );
			}
		}
		
		if ( isdefined( new_menu.extra_cams ) )
		{
			foreach ( extracam_data in new_menu.extra_cams )
			{
				if( isdefined( extracam_data.camera_function ) )
				{
					level thread [[extracam_data.camera_function]]( localClientNum, menu_data.menu_name, extracam_data );
				}
				else
				{
					camera_ent = multi_extracam::extracam_init_index( localClientNum, extracam_data.target_name, extracam_data.extracam_index );
					if ( isdefined( camera_ent ) )
					{
						camera_ent PlayExtraCamXCam( extracam_data.xcam, 0, extracam_data.sub_xcam );
					}
				}
			}
		}
	}
}

function client_menus( localClientNum )
{
	level endon("disconnect");
	
	clientMenuStack = array();
	
	while(1)
	{
		level waittill( "menu_change", menu_name, status, state );
		
		menu_index = undefined;
		for (i = 0; i < clientMenuStack.size; i++ )
		{
			if ( clientMenuStack[i].menu_name == menu_name )
			{
				menu_index = i;
				break;
			}
		}
		
		if ( ( status === "closeToMenu" ) && isdefined( menu_index ) )
		{
			topMenu = undefined;
			for( i = 0; i < menu_index; i++ )
			{
				popped = array::pop_front( clientMenuStack, false );
				if( !isdefined( topMenu ) )
				{
					topMenu = popped;
				}
			}
			
			setup_menu( localClientNum, clientMenuStack[0], topMenu );
			continue;
		}
		
		stateChange = ( isdefined( menu_index ) && status !== "closed" && clientMenuStack[menu_index].state !== state && !( !isdefined( clientMenuStack[menu_index].state ) && !isdefined( state ) ) );
		updateOnly = ( stateChange && menu_index !== 0 );
		
		if ( updateOnly )
		{
			clientMenuStack[i].state = state;
		}
		else
		{
			if ( ( status === "closed" || stateChange ) && isdefined( menu_index ) )
			{
				popped = undefined;
				// don't want asserts at e3 so gracefully handle this hard to repro bug
				if ( GetDvarInt( "ui_execdemo_e3" ) == 1 ) //&& menu_index > 0 )
				{
					while ( menu_index >= 0 )
					{
						if(!isdefined(popped))popped=array::pop_front( clientMenuStack, false );
						menu_index--;
					}
				}
				else
				{
					assert( menu_index == 0 );
					popped = array::pop_front( clientMenuStack, false );
				}
				
				setup_menu( localClientNum, clientMenuStack[0], popped );
			}
			
			if ( status === "opened" && ( !isdefined( menu_index ) || stateChange ) )
			{
				menu_data = SpawnStruct();
				menu_data.menu_name = menu_name;
				menu_data.state = state;
				
				lastMenu = ( clientMenuStack.size > 0 ? clientMenuStack[0] : undefined );
				setup_menu( localClientNum, menu_data, lastMenu );
				array::push_front( clientMenuStack, menu_data );
			}
		}
	}
}


/@
"Name: screen_fade( <n_time>, [n_target_alpha = 1], [str_color = "black"], [b_force_close_menu = false] )"
"Summary: fade the screen in/out"
"CallOn: player or level (for all players)"
"MandatoryArg: n_time: fade time"
"OptionalArg: n_target_alpha: end alpha (defaults to 1)"
"OptionalArg: str_color: "white" or "black" (defaults to black)."
"OptionalArg: b_force_close_menu: close the fade menu when done even if the alpha isn't 0."
"Example: level lui::screen_fade( 3, .5, "black" ); // fade to .5 alpha over 3 sec"
@/
function screen_fade( n_time, n_target_alpha = 1, n_start_alpha = 0, str_color = "black", b_force_close_menu = false )
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player thread _screen_fade( n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu );
		}
	}
	else
	{
		self thread _screen_fade( n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu );
	}
}

/@
"Name: screen_fade_out( <n_time>, [str_color] )"
"Summary: fade the screen out"
"CallOn: player or level (for all players)"
"MandatoryArg: n_time: fade time"
"OptionalArg: str_color: "white" or "black" (defaults to black)."
"Example: level lui::screen_fade_out( 3 ); // fade out over 3 sec"
@/
function screen_fade_out( n_time, str_color )
{
	screen_fade( n_time, 1, 0, str_color, false );
	wait n_time;
}

/@
"Name: screen_fade_in( <n_time>, [str_color] )"
"Summary: fade the screen in"
"CallOn: player or level (for all players)"
"MandatoryArg: n_time: fade time"
"OptionalArg: str_color: "white" or "black" (defaults to black)."
"Example: level lui::screen_fade_in( 3 ); // fade in over 3 sec"
@/
function screen_fade_in( n_time, str_color )
{
	screen_fade( n_time, 0, 1, str_color, true );
	wait n_time;
}

/@
"Name: screen_close_menu()"
"Summary: foce closes the menu regardless of the current alpha value"
"CallOn: player or level (for all players)"
@/	
function screen_close_menu()
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player thread _screen_close_menu();
		}
	}
	else
	{
		self thread _screen_close_menu();
	}
}

function private _screen_close_menu()
{
	self notify( "_screen_fade" );
	self endon( "_screen_fade" );
	self endon( "disconnect" );
	
	if(isdefined(self.screen_fade_menus))
	{
		str_menu = "FullScreenBlack";
		
		if ( isdefined( self.screen_fade_menus[ str_menu ] ) )
		{
			CloseLUIMenu( self.localClientNum, self.screen_fade_menus[ str_menu ].lui_menu );
			self.screen_fade_menus[ str_menu ] = undefined;
		}
		
		str_menu = "FullScreenWhite";
		
		if ( isdefined( self.screen_fade_menus[ str_menu ] ) )
		{
			CloseLUIMenu( self.localClientNum, self.screen_fade_menus[ str_menu ].lui_menu );
			self.screen_fade_menus[ str_menu ] = undefined;
		}
	}
}

function private _screen_fade( n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu )
{
	self notify( "_screen_fade" );
	self endon( "_screen_fade" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	
	if(!isdefined(self.screen_fade_menus))self.screen_fade_menus=[];
	
	n_time_ms = int( n_time * 1000 );
		
	lui_menu = "";
	switch ( str_color )
	{
		case "black":
			
			str_menu = "FullScreenBlack";
			break;
			
		case "white":
			
			str_menu = "FullScreenWhite";
			break;
			
		default: AssertMsg( "Unsupported color for screen fade." );
	}
	
	if ( isdefined( self.screen_fade_menus[ str_menu ] ) )
	{
		/* Close current menu */
		
		s_menu = self.screen_fade_menus[ str_menu ];		
		lui_menu = s_menu.lui_menu;
		
		CloseLUIMenu( self.localClientNum, lui_menu );
		
		/* Calculate the current alpha since we can't get it directly from the menu */
						
		n_start_alpha = LerpFloat( s_menu.n_start_alpha, s_menu.n_target_alpha, GetTime() - s_menu.n_start_time );
	}
	
	lui_menu = CreateLUIMenu( self.localClientNum, str_menu );
	
	self.screen_fade_menus[ str_menu ] = SpawnStruct();
	self.screen_fade_menus[ str_menu ].lui_menu = lui_menu;
	
	self.screen_fade_menus[ str_menu ].n_start_alpha = n_start_alpha;	
	self.screen_fade_menus[ str_menu ].n_target_alpha = n_target_alpha;
	self.screen_fade_menus[ str_menu ].n_target_time = n_time_ms;
	self.screen_fade_menus[ str_menu ].n_start_time = GetTime();
		
	SetLUIMenuData( self.localClientNum, lui_menu, "startAlpha", n_start_alpha );
	SetLUIMenuData( self.localClientNum, lui_menu, "endAlpha", n_target_alpha );
	SetLUIMenuData( self.localClientNum, lui_menu, "fadeOverTime", n_time_ms );
	
	OpenLUIMenu( self.localClientNum, lui_menu );
	
	wait n_time;
		
	if ( b_force_close_menu || ( n_target_alpha == 0 ) )
	{
		CloseLUIMenu( self.localClientNum, self.screen_fade_menus[ str_menu ].lui_menu );
		self.screen_fade_menus[ str_menu ] = undefined;
	}
}
