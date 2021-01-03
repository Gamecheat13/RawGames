#using scripts\codescripts\struct;

#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
            	     	     

#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_save;

#using scripts\shared\array_shared;

#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\scene_shared;

                                                                                     	                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\_character_customization;

#namespace safehouse;

#precache( "lui_menu", "PersonalDataVaultMenu" );
#precache( "lui_menu", "MissionRecordVaultMenu" );
#precache( "lui_menu", "MissionOverviewScreen" );
#precache( "lui_menu_data", "highestMapReached" );
#precache( "lui_menu_data", "showMissionSelect" );
#precache( "lui_menu_data", "showMissionOverview" );
#precache( "lui_menu", "PersonalDataVault_PlaceCollectibleLocations" );
#precache( "lui_menu", "ChooseClass_InGame" );
#precache( "lui_menu", "chooseClass" );
#precache( "lui_menu_data", "close_current_menu" );
//for SendMenuReponse
#precache( "menu", "MissionRecordVaultMenu" );

#precache( "model", "p7_nc_cai_sgen_01" );
#precache( "model", "p7_nc_cai_sgen_02" );
#precache( "model", "p7_nc_cai_sgen_03" );
#precache( "model", "p7_nc_cai_sgen_04" );
#precache( "model", "p7_nc_cai_sgen_05" );
#precache( "model", "p7_nc_cai_sgen_06" );
#precache( "model", "p7_nc_sin_sgen_01" );
#precache( "model", "p7_nc_sin_sgen_02" );
#precache( "model", "p7_nc_sin_sgen_03" );
#precache( "model", "p7_nc_sin_sgen_04" );
#precache( "model", "p7_nc_sin_sgen_05" );
#precache( "model", "p7_nc_sin_sgen_06" );

#using_animtree("core_frontend");
	
#precache( "objective", "cp_standard_breadcrumb" );

function autoexec __init__sytem__() {     system::register("safehouse",&__init__,&__main__,undefined);    }
	
function private __init__()
{
	clientfield::register( "world", "nextMap", 1, 6, "int" );
	clientfield::register( "world", "selectMenu", 1, GetMinBitCountForNum(15), "int" );
	clientfield::register( "world", "gun_rack_fxanim", 1, 1, "int" );
	clientfield::register( "world", "toggle_bunk_1", 1, 1, "int" );
	clientfield::register( "world", "toggle_bunk_2", 1, 1, "int" );
	clientfield::register( "world", "toggle_bunk_3", 1, 1, "int" );
	clientfield::register( "world", "toggle_bunk_4", 1, 1, "int" );
	clientfield::register( "world", "toggle_console_1", 1, 1, "int" );
	clientfield::register( "world", "toggle_console_2", 1, 1, "int" );
	clientfield::register( "world", "toggle_console_3", 1, 1, "int" );
	clientfield::register( "world", "toggle_console_4", 1, 1, "int" );
	
	level flag::init( "safehouse_can_load_map", false );
	
	callback::on_spawned( &on_player_spawned );
}

function private __main__()
{
	level thread _load_next_level();
	
	init_rooms();
	init_stations();
	
	callback::on_spawned( &player_claim_room );
	callback::on_disconnect( &player_unclaim_room );
	
}

function private on_player_spawned()
{
	level flag::set( "safehouse_can_load_map" );
	
	self SetLowReady( true );
	self AllowProne( false );
	self AllowCrouch( false );
	self AllowJump( false );
	self AllowDoubleJump( false );
}

function init_interactive_prompt( trigger, objectiveId, normalText, usingText )
{
	trigger SetHintString( normalText );
	trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
	
	game_object = gameobjects::create_use_object( "any", trigger, Array( trigger ), ( 0, 0, 0 ), objectiveId );
	game_object gameobjects::allow_use( "any" );
	game_object gameobjects::set_use_time( 0 );
	game_object gameobjects::set_owner_team( "allies" );
	game_object gameobjects::set_visible_team( "any" );
	game_object.single_use = false;
	
	game_object EnableLinkTo();
	game_object LinkTo( trigger );
	
	// Set origin/angles so it can be used as an objective target.
	game_object.origin = game_object.origin;
	game_object.angles = game_object.angles;
}

// Loading from the safehouse to the level.
//
function private _load_next_level()
{
	//used to track how many players are located in the ready room
	level.n_players_ready = 0;
	
	//set once all players in the safehouse have entered the ready room
	level flag::init( "all_players_ready" );
	
	_init_ready_room_positions();
	
	t_start = GetEnt( "trig_start_level", "targetname" );
	init_interactive_prompt( t_start, &"cp_ready_room", &"CP_SH_CAIRO_START_LEVEL", undefined );

	str_next_level = world.next_map;
	if ( !isdefined( str_next_level ) )
	{
		str_next_level = GetDvarString( "cp_queued_level" );
	}

	t_start SetInvisibleToAll();
	
	if ( !isdefined( str_next_level ) || str_next_level == "" )
	{
		return;
	}
	
	// HACK: TODO: Remove these timing checks once we have a real indication of when it's safe to start loading.
	n_start_time = GetTime();
	const n_min_lead_time = 4000;
	
	level flag::wait_till( "safehouse_can_load_map" );
	
	while ( GetTime() - n_start_time < n_min_lead_time )
	{
		wait 0.5;
	}
	
	str_movie = GetMapIntroMovie( str_next_level );
	if ( isdefined( str_movie ) )
	{
		SwitchMap_SetLoadingMovie( str_movie );
	}
	
	//SwitchMap_Preload( str_next_level, "coop" );		// Removing in favor of switchmap_load until level fastfiles are of more predictable size.
	SwitchMap_Load( str_next_level, "coop" );
	
	//level waittill( "switchmap_preload_finished" );		// Removing in favor of switchmap_load until level fastfiles are of more predictable size.
	
	t_start SetVisibleToAll();
	
	//flag set on a trigger in the ready room that waits for all connected players
	t_start thread _player_ready_room_menu_trigger();
	while( !flag::get( "all_players_ready" ) )
	{
		flag::wait_till( "all_players_ready" );
		wait 0.5;
	}
	
	// Let the intro movie register internally.
	util::wait_network_frame();
	
	skipto::set_current_skipto( "" );
	SwitchMap_Switch();
}

function private _player_ready_room_menu_trigger()
{
	level endon( "all_players_ready" );
	
	while( true )
	{
		self waittill( "trigger", e_who );
		e_who thread _player_enter_ready_room();
	}
}

function private _delay_close_menu(delay, menuHandle)
{
	wait delay;
	self CloseLUIMenu(menuHandle);
}

function get_savegame_name( levelname )
{
	//TODO something not awful
	switch( levelname )
	{
	case "cp_mi_cairo_infection":
	case "cp_mi_cairo_infection2":
	case "cp_mi_cairo_infection3":
		return "infection";

	case "cp_mi_cairo_lotus":
	case "cp_mi_cairo_lotus2":
	case "cp_mi_cairo_lotus3":
		return "lotus";

	case "cp_mi_cairo_ramses":
	case "cp_mi_cairo_ramses2":
		return "ramses";

	case "cp_mi_sing_biodomes":
	case "cp_mi_sing_biodomes2":
		return "biodomes";
	}

	return levelname;
}

function private _player_enter_ready_room()
{
	//do not allow players to exit once everyone is in the room
	level endon( "all_players_ready" );
	self endon( "disconnect" );
	
	fadeToBlackMenu = self OpenLUIMenu( "FadeToBlack" );
	wait 0.5;

	self.disableClassCallback = true;
	self openMenu( game[ "menu_changeclass" ] );

	enterReadyRoom = true;
	while( true )
	{
		self waittill( "menuresponse", menu, response );
		if ( menu == "ChooseClass_InGame" )
		{
			if ( response == "cancel" )
			{
				enterReadyRoom = false;
			}
			break;
		}
	}

	if( enterReadyRoom )
	{
		self thread _player_wait_in_ready_room();
	}

	self SetLUIMenuData( fadeToBlackMenu, "close_current_menu", 1 );
	self thread _delay_close_menu( 0.5, fadeToBlackMenu );

	wait .05;
	self.disableClassCallback = false;

	if( !enterReadyRoom )
	{
		return;
	}

	playerclass = self loadout::getClassChoice( response );
	self savegame::set_player_data( get_savegame_name(world.next_map) + "_class", playerclass );

	self SetClientUIVisibilityFlag( "hud_visible", 0 );
	missionOverviewMenu = self OpenLUIMenu( "MissionOverviewScreen" );
	self SetLUIMenuData( missionOverviewMenu, "showMissionOverview", false );
	self SetLUIMenuData( missionOverviewMenu, "showMissionSelect", false );
	
	while ( 1 )
	{
		self waittill( "menuresponse", menu, response );
		if ( menu == "MissionRecordVaultMenu" && response == "closed" )
		{
			break;
		}
	}

	fadeToBlackMenu2 = self OpenLUIMenu( "FadeToBlack" );
	wait 0.5;	
	self SetClientUIVisibilityFlag( "hud_visible", 1 );
	self CloseLUIMenu( missionOverviewMenu );

	self _player_leave_ready_room();
	
	self SetLUIMenuData( fadeToBlackMenu2, "close_current_menu", 1 );
	self thread _delay_close_menu( 0.5, fadeToBlackMenu2 );	
}

function _player_wait_in_ready_room()
{
	self endon( "disconnect" );
	self endon( "left_ready_room" );
	level endon( "all_players_ready" );
	
	level.n_players_ready++;
	
	//if this is the last player to enter the ready room, skip playing animations and get everyone to the level
	if( level.n_players_ready == 1 /*level.players.size*/ ) //HACK until clientside xcam is working, the first player to enter the ready room transitions the whole group
	{
		level flag::set( "all_players_ready" );
		return;
	}
			
	//get the index of the animations to reference
	self _player_get_ready_room_position();
		
	//watch for player disconnect for handling who is in the room
	self thread _player_ready_disconnect_watch();
	
	//looping animation of the player character preparing for the mission at the table
	self thread scene::play( level.a_ready_room[ self.n_ready_room_index ].str_player_scene );
	
	n_cam_index = 0;
	while( 1 )
	{
		//play the current indexed xcam
		self thread scene::play( level.a_ready_room[ self.n_ready_room_index ].a_str_xcam[n_cam_index] );
		
		wait 5;
		
		//cycle through as many camera angles that exist for this player
		n_cam_index++;
		if( n_cam_index == level.a_ready_room[ self.n_ready_room_index ].a_str_xcam.size )
		{
			n_cam_index = 0;
		}
	}
}

//self is a player who has backed out of the ready room
function _player_leave_ready_room()
{
	self notify( "left_ready_room" );
	
	level.n_players_ready--;	
	self _player_free_ready_room_position();
	
	self scene::stop();
	
	s_room_pos = struct::get( "ready_room_return_player_" + self GetEntityNumber(), "targetname" );
	
	self SetOrigin( s_room_pos.origin );
	self SetPlayerAngles( s_room_pos.angles );
}

//self is a player waiting in the ready room
function _player_ready_disconnect_watch()
{
	level endon( "all_players_ready" );
	self endon( "left_ready_room" );
	
	self waittill( "disconnect" );
	
	level.n_players_ready--;	
	self _player_free_ready_room_position();
}

//organizes all the animations for the various positions of the players
function _init_ready_room_positions()
{
	level.a_ready_room[ 0 ] = SpawnStruct();
	level.a_ready_room[ 0 ].b_occupied = false;
	level.a_ready_room[ 0 ].str_player_scene = "cin_saf_ram_readyroom_3rd_pre100_player01";
	level.a_ready_room[ 0 ].a_str_xcam[ 0 ] = "cin_saf_ram_readyroom_3rd_pre100_p1_cam01";
	level.a_ready_room[ 0 ].a_str_xcam[ 1 ] = "cin_saf_ram_readyroom_3rd_pre100_p1_cam02";
	level.a_ready_room[ 0 ].a_str_xcam[ 2 ] = "cin_saf_ram_readyroom_3rd_pre100_p1_cam03";
	
	level.a_ready_room[ 1 ] = SpawnStruct();
	level.a_ready_room[ 1 ].b_occupied = false;
	level.a_ready_room[ 1 ].str_player_scene = "cin_saf_ram_readyroom_3rd_pre100_player02";
	level.a_ready_room[ 1 ].a_str_xcam[ 0 ] = "cin_saf_ram_readyroom_3rd_pre100_p2_cam01";
	level.a_ready_room[ 1 ].a_str_xcam[ 1 ] = "cin_saf_ram_readyroom_3rd_pre100_p2_cam02";
	level.a_ready_room[ 1 ].a_str_xcam[ 2 ] = "cin_saf_ram_readyroom_3rd_pre100_p2_cam03";
	
	level.a_ready_room[ 2 ] = SpawnStruct();
	level.a_ready_room[ 2 ].b_occupied = false;
	level.a_ready_room[ 2 ].str_player_scene = "cin_saf_ram_readyroom_3rd_pre100_player03";
	level.a_ready_room[ 2 ].a_str_xcam[ 0 ] = "cin_saf_ram_readyroom_3rd_pre100_p3_cam01";
	level.a_ready_room[ 2 ].a_str_xcam[ 1 ] = "cin_saf_ram_readyroom_3rd_pre100_p3_cam02";
	level.a_ready_room[ 2 ].a_str_xcam[ 2 ] = "cin_saf_ram_readyroom_3rd_pre100_p3_cam03";
	
}

//self is a player who is assigned an unused position at the table
function _player_get_ready_room_position()
{
	for( n_index = 0; n_index < level.a_ready_room.size; n_index++ )
	{
		if( level.a_ready_room[ n_index ].b_occupied == false )
		{
			level.a_ready_room[ n_index ].b_occupied = true;
			self.n_ready_room_index = n_index;
			return;
		}
	}
}

//self is a player who is leaving the ready room
function _player_free_ready_room_position()
{
	 level.a_ready_room[ self.n_ready_room_index ].b_occupied = false;
	 self.n_ready_room_index = undefined;
}

function init_rooms()
{
	// needed for vault_think.  TODO: remove this when world saves
	if ( !isdefined( world.next_map ) && (GetDvarString( "cp_queued_level" ) != "") )
	{
		world.next_map = GetDvarString( "cp_queued_level" );
	}
	if ( !isdefined( world.highest_map_reached ) && (GetDvarString( "cp_highest_level" ) != "") )
	{
		world.highest_map_reached = GetDvarString( "cp_highest_level" );
	}

	level.rooms = [];
	
	//all ents and structs here are placed within bunk prefabs with a blank targetname that is inherited
	for( n_player_index = 0; n_player_index < 4; n_player_index++ )
	{
		level.rooms[n_player_index] = SpawnStruct();
		level.rooms[n_player_index].b_claimed = false;
		
		a_t_interact = GetEntArray( "player_bunk_" + n_player_index, "targetname" );
		foreach( t_interact in a_t_interact )
		{
			switch( t_interact.script_noteworthy )
			{
				case "data_vault":
					level.rooms[n_player_index].t_vault = t_interact;
					level.rooms[n_player_index].t_vault SetHintString( &"CP_SH_CAIRO_USE_VAULT" );
					level.rooms[n_player_index].t_vault SetCursorHint( "HINT_NOICON" );
					level.rooms[n_player_index].t_vault thread vault_think( "PersonalDataVaultMenu" );
					level.rooms[n_player_index].t_vault SetInvisibleToAll();
					break;
				case "wardrobe":
					level.rooms[n_player_index].t_wardrobe = t_interact;
					level.rooms[n_player_index].t_wardrobe SetHintString( &"CP_SH_CAIRO_USE_WARDROBE" );
					level.rooms[n_player_index].t_wardrobe SetCursorHint( "HINT_NOICON" );
					level.rooms[n_player_index].t_wardrobe thread wardrobe_think();
					level.rooms[n_player_index].t_wardrobe SetInvisibleToAll();
					break;
				case "foot_locker":
					level.rooms[n_player_index].t_locker = t_interact;
					level.rooms[n_player_index].t_locker SetHintString( &"CP_SH_CAIRO_USE_LOCKER" );
					level.rooms[n_player_index].t_locker SetCursorHint( "HINT_NOICON" );
					level.rooms[n_player_index].t_locker thread locker_think();
					level.rooms[n_player_index].t_locker SetInvisibleToAll();
					break;
			}
		}		
		
		//spawning tag origins to represent collectible models
		level.rooms[n_player_index].a_coll = [];
		a_s_coll_pos = array::merge_sort( struct::get_array( "player_bunk_" + n_player_index, "targetname" ), &_sort_by_script_noteworthy_compare_func );
		for( n_coll = 0; n_coll <= 8; n_coll++ )
		{
			level.rooms[n_player_index].a_coll[n_coll] = util::spawn_model( "tag_origin", a_s_coll_pos[n_coll].origin, a_s_coll_pos[n_coll].angles );
		}
	}
	
	level.t_mission_vault = GetEnt( "t_mission_vault", "targetname" );
	init_interactive_prompt( level.t_mission_vault, &"cp_mission_vault", &"CP_SH_CAIRO_MISSION_DATA", undefined );
	level.t_mission_vault thread vault_think( "MissionRecordVaultMenu" );
}

//used to arrange the structs in the correct order based on index
function _sort_by_script_noteworthy_compare_func( e1, e2, b_unused )
{
	return e1.script_noteworthy < e2.script_noteworthy;
}

function init_stations()
{
	level thread printer_think();
	level thread gun_rack_think();
	level thread console_think();
}

//handles playing animations on the 3D printer
function printer_think()
{
	a_str_scenes[0] = "p7_fxanim_gp_3d_printer_object01_01_bundle";
	a_str_scenes[1] = "p7_fxanim_gp_3d_printer_object01_02_bundle";
	a_str_scenes[2] = "p7_fxanim_gp_3d_printer_object01_03_bundle";
		
	m_printer = GetEnt( "printer", "targetname" );
	
	while( 1 )
	{
		a_str_scenes = array::randomize( a_str_scenes );
		for( i = 0; i < a_str_scenes.size; i++ )
		{
			m_printer scene::play( a_str_scenes[i] );
		}
	}
}

//handles animation of the gun rack based on player proximity
function gun_rack_think()
{
	t_gun_rack = GetEnt( "t_gun_rack", "targetname" );
	init_interactive_prompt( t_gun_rack, &"cp_gun_rack", &"CP_SH_CAIRO_EDIT_LOADOUT", undefined );
	t_gun_rack thread gun_rack_proximity_check();
	
	while( true )
	{
		t_gun_rack waittill( "trigger", player );
		player thread gun_rack_open_menu();
	}
}

//self is a player who has activated the gun rack trigger
function gun_rack_open_menu()
{
	self endon( "death" );
	
	self HideViewModel();
	self OpenLuiMenu( "chooseClass" );
	
	do
	{
		self waittill( "menuresponse", menu, response );
	} while( response != "closed" );
		
	self ShowViewModel();
}

//self is the use trigger for the create a class
function gun_rack_proximity_check()
{
	b_gun_deployed = false;
	
	while( 1 )
	{
		//check if any players are in proximity of the gun rack
		b_player_near = false;
		foreach( e_player in level.players )
		{
			if( e_player IsTouching( self ) )
			{
				b_player_near = true;
			}
		}

		//update clients and animate
		if( b_player_near && !b_gun_deployed )
		{
			level clientfield::set( "gun_rack_fxanim", 1 );
			b_gun_deployed = true;
			wait 6; //length of animation
		}
		else if( !b_player_near && b_gun_deployed )
		{
			level clientfield::set( "gun_rack_fxanim", 0 );
			b_gun_deployed = false;
			wait 4; //length of animation
		}
		
		wait 0.05;
	}
}

//handles the logic of the VR chairs, currently temp to just animate random ones for other department iteration
function console_think()
{
	while ( 1 )
	{
		//TODO change logic to handle players getting into the chairs once the system is up
		n_console = RandomIntRange( 1, 4 );
		wait 4;
		level clientfield::set( "toggle_console_" + n_console, 1 );
		wait 4;
		level clientfield::set( "toggle_console_" + n_console, 0 );
	}
}


//self is a use trigger
function locker_think()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "trigger", player );
		self TriggerEnable( false );
		player HideViewModel();
		player OpenLuiMenu( "PersonalDataVault_PlaceCollectibleLocations" );
		
		do
		{
			player waittill( "menuresponse", menu, response );
		} while( response != "closed" );
		
		self TriggerEnable( true );
		player ShowViewModel();
	}
}

//self is a use trigger
function vault_think( menuName )
{
	self endon( "death" );

	wait 0.05;

	nextMap = "cp_mi_eth_prologue";
	highestMapReached = "cp_mi_eth_prologue";

	if( isdefined(world.next_map) )
	{
		nextMap = world.next_map;
		highestMapReached = nextMap;
		if( isdefined(world.highest_map_reached) )
		{
			highestMapReached = world.highest_map_reached;
		}
	}
	/#
	if (GetDvarString( "unlock_all_maps" ) == "1")
	{
		highestMapReached = "fakeMapNameToUnlockAll";
	}
	#/
		
	level clientfield::set( "nextMap", GetMapOrder( nextMap ) );

	while( 1 )
	{
		self waittill( "trigger", player );
		self TriggerEnable( false );
		player HideViewModel();
		menuHandle = player OpenLuiMenu( menuName );
		player SetClientUIVisibilityFlag( "hud_visible", 0 );

		if( menuName == "MissionRecordVaultMenu" )
		{
			player SetLuiMenuData( menuHandle, "highestMapReached", highestMapReached );
			player SetLuiMenuData( menuHandle, "showMissionSelect", player.entnum == 0 );
		}

		do
		{
			do
			{
				player waittill( "menuresponse", menu, response );
			} while( menu != menuName );

			if( response != "closed" && menuName == "MissionRecordVaultMenu" )
			{
				world.next_map = response;
				level clientfield::set( "nextMap", GetMapOrder( world.next_map ) );
			}
		} while( response != "closed" );
		
		player SetClientUIVisibilityFlag( "hud_visible", 1 );
		player CloseLuiMenu( menuHandle );
		
		self TriggerEnable( true );
		player ShowViewModel();
	}
}

//self is a use trigger used to interact with a player's wardrobe
function wardrobe_think()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "trigger", player );
		
		player OpenLuiMenu( "OutfitsMainMenu" );
		lastMenu = "OutfitsMainMenu";

		do
		{
			player waittill( "menuresponse", menu, response );
			if ( StrStartsWith( menu, "personalizeHero" ) )
			{
				if ( StrStartsWith( response, "opened" ) )
				{
					level clientfield::set( "selectMenu", 9 );
					
					if ( response != "opened_noCam" )
					{
						spawnpointname = menu + "_camera";
						spawnpoint = struct::get( spawnpointname );
						
						assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
						
						animTime = 0;
						if ( lastMenu === "personalizeHero" )
						{
							animTime = 300;
						}
						
						CamAnimScripted( player, "ui_cam_character_customization", GetTime(), spawnpoint.origin, spawnpoint.angles, animTime, "cam_preview" );
					}
				}
				else if ( StrStartsWith( response, "inspecting" ) )
				{
					spawnpointname = menu + "_camera";
					spawnpoint = struct::get( spawnpointname );
					
					assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
					
					camName = "cam_select";
					if ( response == "inspecting_helmet" )
					{
						camName = "cam_helmet";
					}
					
					CamAnimScripted( player, "ui_cam_character_customization", GetTime(), spawnpoint.origin, spawnpoint.angles, 300, camName );
				}
				else if ( response == "closed" )
				{
					EndCamAnimScripted( player );
				}
			}
			else if ( menu == "OutfitsMainMenu" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 12 );
				}
			}
			else if ( menu == "ChooseGender" || menu == "ChooseGender_v1" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 11 );
				}
			}
			else if ( menu == "ChooseHead" || menu == "ChooseHead_v1" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 10 );
					
					if ( response != "opened_noCam" )
					{
						spawnpointname = "personalizeHero_camera";
						spawnpoint = struct::get( spawnpointname );
						
						assert( spawnpoint.size, "There are no " + spawnpointname + "script_structs in the map.  There must be at least one."  );
						
						CamAnimScripted( player, "ui_cam_character_customization", GetTime(), spawnpoint.origin, spawnpoint.angles, 0, "cam_helmet" );
					}
				}
				else if ( response == "closed" )
				{
					EndCamAnimScripted( player );
				}
			}
			else if ( menu == "ChooseOutfit" )
			{
				if ( response == "opened" )
				{
					level clientfield::set( "selectMenu", 13 );
				}
			}
			lastMenu = menu;
		} while( menu != "OutfitsMainMenu" || response != "closed" );
		
		level clientfield::set( "selectMenu", 1 );
	}
}

//self is a player
function player_claim_room()
{
	n_player = self GetEntityNumber();
	level.rooms[n_player].b_claimed = true;
	level.rooms[n_player].t_locker SetVisibleToPlayer( self );
	level.rooms[n_player].t_vault SetVisibleToPlayer( self );
	level.rooms[n_player].t_wardrobe SetVisibleToPlayer( self );
	
	//set the models for current collectibles setup in player's room
	for( i = 0; i < level.rooms[n_player].a_coll.size; i++ )
	{
		collectibleId = self GetCollectibleForSlot( i );
		if( collectibleId != 0 )
		{
			str_model = GetCollectibleModel( collectibleId );
			level.rooms[n_player].a_coll[ i ] SetModel( str_model );
		}
	}
	
	self thread watch_menu_notifies();

	level clientfield::set( "toggle_bunk_" + ( n_player + 1), 1 );
}

//self is a player
function player_unclaim_room()
{
	n_player = self GetEntityNumber();
	level.rooms[n_player].b_claimed = false;
	level.rooms[n_player].t_locker SetInvisibleToAll();
	level.rooms[n_player].t_vault SetInvisibleToAll();
	level.rooms[n_player].t_wardrobe SetInvisibleToAll();
		
	//remove all models
	for( i = 0; i < level.rooms[n_player].a_coll.size; i++ )
	{
		level.rooms[n_player].a_coll[ i ] SetModel( "tag_origin" );
	}
	
	level clientfield::set( "toggle_bunk_" + ( n_player + 1), 0 );
}

function watch_menu_notifies()
{
	self endon( "disconnect" );
	
	str_cam_pos = "none";
	
	while( 1 )
	{
		self waittill( "menuresponse", menu, response);
		
		if( menu == "PersonalDataVaultMenu" || menu == "PersonalDataVault_PlaceCollectibleLocations" )
		{
			switch( response )
			{
					
				//shelves into computer cases
				case "mainCam":
					if( str_cam_pos == "none" )
					{
						scene::stop();
						self thread scene::play( "cin_saf_collectible_computer_in" );
					}
					else if( str_cam_pos == "small" )
					{
						scene::stop();
						self thread scene::play( "cin_saf_collectible_collsmall_2computer" );
					}
					else if( str_cam_pos == "medium" )
					{
						scene::stop();
						self thread scene::play( "cin_saf_collectible_collmed_2computer" );
					}
					else if( str_cam_pos == "large" )
					{
						scene::stop();
						self thread scene::play( "cin_saf_collectible_colllarge_2computer" );
					}
					str_cam_pos = "vault";
					break;
				
				//computer to shelves cases
				case "cam_to0":
				case "cam_to0from0":
					if( str_cam_pos == "none" )
					{
						scene::stop();
						self thread scene::play( "cin_saf_collectible_collsmall_in" );
					}
					else if( str_cam_pos == "vault" )
					{
						scene::stop();
						self thread scene::play( "cin_saf_collectible_computer_2collsmall" );
					}
					str_cam_pos = "small";
					break;
				case "cam_to1":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_computer_2collmed" );
					str_cam_pos = "medium";
					break;
				case "cam_to2":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_computer_2colllarge" );
					str_cam_pos = "large";
					break;
				
				//other shelves to small
				case "cam_to0from1":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_collmed_2collsmall" );
					str_cam_pos = "small";
					break;
				case "cam_to0from2":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_colllarge_2collsmall" );
					str_cam_pos = "small";
					break;
				
				//other shelves to medium
				case "cam_to1from0":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_collsmall_2collmed" );
					str_cam_pos = "medium";
					break;
				case "cam_to1from2":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_colllarge_2collmed" );
					str_cam_pos = "medium";
					break;
				
				//other shelves to large					
				case "cam_to2from0":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_collsmall_2colllarge" );
					str_cam_pos = "large";
					break;
				case "cam_to2from1":
					scene::stop();
					self thread scene::play( "cin_saf_collectible_collmed_2colllarge" );
					str_cam_pos = "large";
					break;
					
				case "closed":
					scene::stop();
					str_cam_pos = "none";
					break;
					
				default:
					break;
			}

		}
	}
}



