#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\systems\shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\sidemissions\_sm_devgui;

#namespace zone_mgr;

function autoexec __init__sytem__() {     system::register("sm_zone_mgr",&__init__,undefined,undefined);    }

//
//	This provides location information for the map.  It tracks the location of players
//	and manages what spawn locations can become activated for use.
//	
//	Your level will need to set the level.zone_manager_init_func.  This function
//	should specify all of the connections you need to generate for each zone.
//		Ex.:	level.zone_manager_init_func = &cosmodrome_zone_init;
//	
//	You will also need to call the zone_manager startup function, manage_zones.
//	Pass in an array of starting zone names.
//		Ex.:	init_zones[0] = "start_zone";
//				init_zones[1] = "start_building1_zone";
//				init_zones[2] = "start_building1b_zone";
//				level thread _zm_zonemgr::manage_zones( init_zones );
//
//	The zone_manager_init_func should contain lines such as the following:
//
//		add_adjacent_zone( "start_zone", "start_zone_roof", "start_exit_power" );
//		add_adjacent_zone( "start_zone", "start_zone_roof", "start_exit_power2" );
//		add_adjacent_zone( "start_zone_roof", "north_catwalk_zone", "start_exit_power" );

//
//	Zone Manager initializations
//
function __init__()
{
	level flag::init( "zones_initialized" );
	level flag::init( "zone_scanning_active" );
	level flag::init( "always_on", true );
	
	level.zones = [];
	level.zone_flags = [];
	
	// Init Zone Mgr.  
	level.zone_mgr = spawnstruct();
	level.zone_mgr flag::init( "activate_player_zones" );		// Zones including and adjacent to players will be activated
	level.zone_mgr flag::init( "activate_objective_zones" );	// Zones including and adjacent to objectives will be activated
	level.zone_mgr flag::init( "exclude_player_occupied_zones" );	// Zones occupied by players will become deactivated (overrides activation)
	
	// Zone Manager Operating mode.  
	//	"player_occupied" - activates zones occupied by players plus all zones adjacent to them.
	//	"player_unoccupied" - activates zones adjacent to players, minus any occupied by players.
	//	"objective_unoccupied" - activates zones marked as objective zones which are not occupied by players
	set_mode( "player_unoccupied" );

	if ( !isdefined( level.create_spawner_list_func )  )
	{
		level.create_spawner_list_func = &create_spawner_list;
	}
	
	/# level thread sm_devgui::sidemission_devgui_init(); #/
}


//
//	Sets the operating mode for the zone manager.  The mode generally dictates how zones
//	become "active".
function set_mode( str_mode )
{
	switch ( str_mode )
	{
	case "player_occupied":
		level.zone_mgr flag::set( "activate_player_zones" );
		level.zone_mgr flag::clear( "activate_objective_zones" );
		level.zone_mgr flag::clear( "exclude_player_occupied_zones" );
		break;
	case "player_unoccupied":
		level.zone_mgr flag::set( "activate_player_zones" );
		level.zone_mgr flag::clear( "activate_objective_zones" );
		level.zone_mgr flag::set( "exclude_player_occupied_zones" );
		break;
	case "objective_unoccupied":
		level.zone_mgr flag::clear( "activate_player_zones" );
		level.zone_mgr flag::set( "activate_objective_zones" );
		level.zone_mgr flag::set( "exclude_player_occupied_zones" );
		break;
	default:
		AssertMsg( "_zone_mgr: attempting to set invalid mode" );
		return;
	}

	level.zone_mgr.str_mode = str_mode;
}


//*****************************************************************************
//	Check to see if a zone is enabled
//*****************************************************************************

function zone_is_enabled( zone_name )
{
	if ( !isdefined( level.zones[ zone_name ] ) ||
	     !level.zones[ zone_name ] flag::get( "enabled" ) )
	{
		return false;
	}

	return true;
}

function zone_is_occupied( zone_name )
{
	if ( !isdefined( level.zones[ zone_name ] ) ||
	     !level.zones[ zone_name ] flag::get( "occupied" ) )
	{
		return false;
	}

	return true;
}


//
//	Sets the "objective" flag on the indicated zone
function set_objective_zone( str_zone )
{
	assert( isdefined( level.zones[ str_zone ] ), "set_objective_zone: Zone (" + str_zone + ") doesn't exist" );

	// Force switch to objective mode for now.  May need to move to individual objectives if we have different modes.
	set_mode( "objective_unoccupied" );

	if( IsDefined(str_zone) && IsDefined(level.zones[str_zone]) )
	{
		level.zones[ str_zone ] flag::set( "objective" );
	}
}

//
//	Clears the "objective" flag on the indicated zone
function clear_objective_zone( str_zone )
{
	assert( isdefined( level.zones[ str_zone ] ), "clear_objective_zone: Zone (" + str_zone + ") doesn't exist" );

	level.zones[ str_zone ] flag::clear( "objective" );
}


//*****************************************************************************
// Pass back the zone the player is occupying
//*****************************************************************************

// self = player
function get_player_zone()
{
	player_zone = undefined;

	keys = GetArrayKeys( level.zones );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( self entity_in_zone( keys[i] )  )
		{
			player_zone = keys[i];
			break;
		}
	}

	return ( player_zone );
}


//*****************************************************************************
// Pass back the zone from the position
//*****************************************************************************

function get_zone_from_position( v_pos, ignore_enabled_check )
{
	zone = undefined;

	scr_org = spawn( "script_origin", v_pos );

	keys = GetArrayKeys( level.zones );
	for ( i=0; i<keys.size; i++ )
	{
		if ( scr_org entity_in_zone( keys[i], ignore_enabled_check )  )
		{
			zone = keys[i];
			break;
		}
	}

	scr_org delete();

	return ( zone );
}

//*****************************************************************************
//  Checks to see how many players are in a zone_name volume
//*****************************************************************************

function get_players_in_zone( zone_name, return_players )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name )  )
	{
		return false;
	}

	zone = level.zones[ zone_name ];

	// Okay check to see if a player is in one of the zone volumes
	num_in_zone = 0;
	players_in_zone = [];
	for ( i = 0; i < zone.volumes.size; i++ )
	{
		for ( j = 0; j < level.players.size; j++ )
		{
			if ( level.players[j] IsTouching( zone.volumes[i] ) )
			{
				num_in_zone++;
				players_in_zone[players_in_zone.size] = level.players[j];
			}
		}
	}
	if ( isdefined( return_players ))
	{
		return players_in_zone;
	}
	return num_in_zone;
}


//--------------------------------------------------------------
//  Checks to see if a player is in a zone_name volume
//--------------------------------------------------------------
function player_in_zone( zone_name )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name )  )
	{
		return false;
	}
	zone = level.zones[ zone_name ];

	// Okay check to see if a player is in one of the zone volumes
	for ( i = 0; i < zone.volumes.size; i++ )
	{
		for ( j = 0; j < level.players.size; j++ )
		{
			if ( level.players[j] IsTouching( zone.volumes[i] ) && !( level.players[j].sessionstate == "spectator" ) )
			{
				return true;
			}
		}
	}
	return false;
}

//--------------------------------------------------------------
//  Checks to see if a entity is in a zone_name volume
//--------------------------------------------------------------
function entity_in_zone( zone_name, ignore_enabled_check )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name ) && !( isdefined( ignore_enabled_check ) && ignore_enabled_check ))
	{
		return false;
	}
	zone = level.zones[ zone_name ];

	// Okay check to see if an entity is in one of the zone volumes
	for ( i = 0; i < zone.volumes.size; i++ )
	{
		if ( self IsTouching( zone.volumes[i] )  )
		{
			return true;
		}
	}
	return false;
}


//--------------------------------------------------------------
//	Call this when you want to allow enemies to spawn from a zone
//	-	Must have at least one info_volume with targetname = ( name of the zone )
//	-	Have the info_volumes target the zone's spawners
//--------------------------------------------------------------
function zone_init( zone_name )
{
	if ( isdefined( level.zones[ zone_name ] )  )
	{
		// It's already been activated
		return;
	}

	/#	PrintLn( "zone_mgr->zone_init ( 1 ) = " + zone_name );		#/

	// Add this to the list of active zones
	level.zones[ zone_name ] = SpawnStruct();
	zone = level.zones[ zone_name ];
	
	zone.zone_name = zone_name;

	zone flag::init( "enabled" );	// The zone is not enabled.  You can stop looking at it
									//		until it is.
	zone flag::init( "occupied" );	// The zone is occupied by a player.  
	zone flag::init( "objective" );	// The zone contains an objective.  
	zone flag::init( "active" );	// The spawners will not be added to the spawning list
									//		until this true.  Zones adjacent to objectives 
									//		or players may become active, depending on the 
									//		operating mode
	zone flag::init( "spawning_allowed" );

	zone.adjacent_zones = [];		// NOTE: These must be defined in a separate level-specific initialization via add_adjacent_zone


	//
	zone.volumes = [];
	volumes = GetEntArray( zone_name, "targetname" );

	/#	PrintLn( "zone_mgr->zone_init ( 2 ) = " + volumes.size );	#/


	for ( i=0; i<volumes.size; i++ )
	{
		if ( volumes[i].classname == "info_volume" )
		{
			zone.volumes[ zone.volumes.size ] = volumes[i];
		}
	}

	assert( isdefined( zone.volumes[0] ), "zone_init: No volumes found for zone: "+zone_name );

	zone.a_s_spawn_locs = [];

	if ( isdefined( zone.volumes[0].target )  )
	{
		spots = struct::get_array( zone.volumes[0].target, "targetname" );

		for ( i = 0; i < spots.size; i++ )
		{
			spots[i].zone_name = zone_name;
			is_enabled = false;
			if ( !( isdefined( spots[i].is_blocked ) && spots[i].is_blocked ) )
			{
				is_enabled = true;
			}
			spots[i] flag::init( "enabled", is_enabled );

			//TODO Use the spawner_id to indicate spawning possibilities,
			//	e.g. single, double, warlord, soldier, etc.
			if ( isdefined( spots[i].spawner_id ) )
			{
				tokens = StrTok( spots[i].spawner_id, " " );
				foreach ( token in tokens )
				{
					if ( !isdefined( zone.a_s_spawn_locs ) ) zone.a_s_spawn_locs = []; else if ( !IsArray( zone.a_s_spawn_locs ) ) zone.a_s_spawn_locs = array( zone.a_s_spawn_locs ); zone.a_s_spawn_locs[zone.a_s_spawn_locs.size]=spots[i];;
				}
			}
			else
			{
				if ( !isdefined( zone.a_s_spawn_locs ) ) zone.a_s_spawn_locs = []; else if ( !IsArray( zone.a_s_spawn_locs ) ) zone.a_s_spawn_locs = array( zone.a_s_spawn_locs ); zone.a_s_spawn_locs[zone.a_s_spawn_locs.size]=spots[i];;
			}
		}
	}
}

//
// Update the spawners
function reinit_zone_spawners()
{
	a_keys = GetArrayKeys( level.zones );
	for ( i = 0; i < level.zones.size; i++ )
	{
		zone = level.zones[ a_keys[i] ];

		if ( isdefined( zone.volumes[0].target )  )
		{
			spots = struct::get_array( zone.volumes[0].target, "targetname" );
			zone.a_s_spawn_locs = [];

			for ( j = 0; j < spots.size; j++ )
			{
				spots[j].zone_name = a_keys[j];
				if ( !( isdefined( spots[j].is_blocked ) && spots[j].is_blocked ) )
				{
					spots[j] flag::set( "enabled" );
				}
				else
				{
					spots[j] flag::clear( "enabled" );
				}

				//TODO May need to add spawn type classifications here
//				tokens = StrTok( spots[j].script_noteworthy, " " );
//				foreach ( token in tokens )
//				{
//				}

				if ( !isdefined( zone.a_s_spawn_locs ) ) zone.a_s_spawn_locs = []; else if ( !IsArray( zone.a_s_spawn_locs ) ) zone.a_s_spawn_locs = array( zone.a_s_spawn_locs ); zone.a_s_spawn_locs[zone.a_s_spawn_locs.size]=spots[j];;
			}
		}
	}
}


//
//	Turn on the zone
function enable_zone( zone_name )
{
	assert( isdefined( level.zones[zone_name] ), "enable_zone: zone has not been initialized" );

	if ( level.zones[ zone_name ] flag::get( "enabled" ) )
	{
		return;
	}

    level.zones[ zone_name ] flag::set( "enabled" );
    level.zones[ zone_name ] flag::set( "spawning_allowed" );
	level notify( zone_name );
}

function disable_zone( str_zone_name )
{
	assert( isdefined( level.zones[ str_zone_name ] ), "disable_zone: zone '" + str_zone_name + "' has not been initialized" );

	if ( !level.zones[ str_zone_name ] flag::get( "enabled" ) )
	{
		return;
	}

    level.zones[ str_zone_name ] flag::clear( "enabled" );
    level.zones[ str_zone_name ] flag::clear( "spawning_allowed" );	
}


function enable_spawning( zone_name )
{
	assert( isdefined( level.zones[zone_name] ), "allow_spawning: zone has not been initialized" );

    level.zones[ zone_name ] flag::set( "spawning_allowed" );
}

function disable_spawning( str_zone_name )
{
	assert( isdefined( level.zones[ str_zone_name ] ), "disallow_spawning: zone '" + str_zone_name + "' has not been initialized" );

    level.zones[ str_zone_name ] flag::clear( "spawning_allowed" );	
}


//
//	Add adjacent zone to zone main zone's adjacency list
//
//	main_zone_name - zone to be connected to
//	adj_zone_name - zone to connect
//	flag_name - flag that will cause the connection to happen
function make_zone_adjacent( main_zone_name, adj_zone_name, flag_name )
{
	main_zone = level.zones[ main_zone_name ];

	// Create the adjacent zone entry if it doesn't exist
	if ( !isdefined( main_zone.adjacent_zones[ adj_zone_name ] )  )
	{
		main_zone.adjacent_zones[ adj_zone_name ] = SpawnStruct();
		adj_zone = main_zone.adjacent_zones[ adj_zone_name ];
		adj_zone flag::init( "connected" );
		adj_zone.flags_do_or_check = false;
		// Create the link condition, the flag that needs to be set to be considered connected
		if ( IsArray( flag_name )  )
		{
			adj_zone.flags = flag_name;
		}
		else
		{
			adj_zone.flags[0] = flag_name;
		}
	}
	else
	{
		// we've already defined a link condition, but we need to add another one and treat
		//	it as an "OR" condition
		assert( !IsArray( flag_name ), "make_zone_adjacent: can't mix single and arrays of flags" );
		adj_zone = main_zone.adjacent_zones[ adj_zone_name ];
		size = adj_zone.flags.size;
		adj_zone.flags_do_or_check = true;
		adj_zone.flags[ size ] = flag_name;
	}
}


//	When the wait_flag gets set ( like when a door opens ), the add_flags will also get set.
//	This provides a slightly less clunky way to connect multiple contiguous zones within an area
//
//	wait_flag = flag to wait for
//	adj_flags = array of flag strings to set when flag is set
function add_zone_flags( wait_flag, add_flags )
{
	if ( !IsArray( add_flags ) )
	{
		temp = add_flags;
		add_flags = [];
		add_flags[0] = temp;
	}

	keys = GetArrayKeys( level.zone_flags );
	for ( i=0; i<keys.size; i++ )
	{
		if ( keys[i] == wait_flag )
		{
			level.zone_flags[ keys[i] ] = ArrayCombine( level.zone_flags[ keys[i] ], add_flags, true, false );
			return;
		}
	}
	level.zone_flags[ wait_flag ] = add_flags;
}


//
//	Shortcut function - creates a one-way adjacency which is always connected.
function add_oneway_connection( zone_name_a, zone_name_b, str_flag = "always_on" )
{
	add_adjacent_zone( zone_name_a, zone_name_b, str_flag, true );
}


//
// Makes zone_b adjacent to zone_a.  If one_way is false, zone_a is also made "adjacent" to zone_b
//	Note that you may not always want enemies coming from zone B while you are in Zone A, but you
//	might want them to come from B while in A.  It's a rare case though, such as a one-way traversal.
function add_adjacent_zone( zone_name_a, zone_name_b, flag_name = "one_way", one_way = false )
{
	// rsh030110 - added to make sure all our flags are inited before setup_zone_flag_waits()
	if ( !isdefined( level.flag[ flag_name ] )  )
	{
		level flag::init( flag_name );
	}

	// If it's not already activated, this zone_init will activate the zone
	//	If it's already activated, it won't do anything.
	zone_init( zone_name_a );
	zone_init( zone_name_b );

	// B becomes an adjacent zone of A
	make_zone_adjacent( zone_name_a, zone_name_b, flag_name );

	if ( !one_way )
	{
		// A becomes an adjacent zone of B
		make_zone_adjacent( zone_name_b, zone_name_a, flag_name );
	}
}


//--------------------------------------------------------------
//	Gathers all flags that need to be evaluated and sets up waits for them
//--------------------------------------------------------------
function setup_zone_flag_waits()
{
	flags = [];
	a_keys = GetArrayKeys( level.zones );
	for ( z=0; z<level.zones.size; z++ )
	{
		zone = level.zones[ a_keys[z] ];
		aa_keys = GetArrayKeys( zone.adjacent_zones );
		for ( az = 0; az<zone.adjacent_zones.size; az++ )
		{
			azone = zone.adjacent_zones[ aa_keys[az] ];
			for ( f = 0; f< azone.flags.size; f++ )
			{
				array::add( flags, azone.flags[f], false );
			}
		}
	}

	for ( i=0; i<flags.size; i++ )
	{
		level thread zone_flag_wait( flags[i] );
	}
}


//
//	Wait for a zone flag to be set and then update zones
//
function zone_flag_wait( flag_name )
{
	if ( !isdefined( level.flag[ flag_name ] )  )
	{
		level flag::init( flag_name );
	}
	level flag::wait_till( flag_name );

	flags_set = false;	//	scope declaration
	// Enable adjacent zones if all flags are set for a connection
	for ( z=0; z<level.zones.size; z++ )
	{
		a_keys = GetArrayKeys( level.zones );
		zone = level.zones[ a_keys[z] ];
		for ( az = 0; az<zone.adjacent_zones.size; az++ )
		{
			aa_keys = GetArrayKeys( zone.adjacent_zones );
			azone = zone.adjacent_zones[ aa_keys[az] ];
			if ( !azone flag::get( "connected" ) )
			{
				if ( azone.flags_do_or_check )
				{
					// If ANY flag is set, then connect zones
					flags_set = false;
					for ( f = 0; f< azone.flags.size; f++ )
					{
						if ( level flag::get( azone.flags[f] )  )
						{
							flags_set = true;
							break;
						}
					}
				}
				else
				{
					// See if ALL the flags have been set, otherwise, move on
					flags_set = true;
					for ( f = 0; f< azone.flags.size; f++ )
					{
						if ( !level flag::get( azone.flags[f] )  )
						{
							flags_set = false;
						}
					}
				}

				if ( flags_set )
				{
					enable_zone( a_keys[z] );
					azone flag::set( "connected" );
					if ( !level.zones[ aa_keys[az] ] flag::get( "enabled" ) )
					{
						enable_zone( aa_keys[az] );
					}
				}
			}
		}
	}

	// Also set any zone flags
	keys = GetArrayKeys( level.zone_flags );
	for ( i=0; i<keys.size; i++ )
	{
		if ( keys[i] == flag_name )
		{
			check_flag = level.zone_flags[ keys[i] ];
			for ( k=0; k<check_flag.size; k++ )
			{
				level flag::set( check_flag[k] );
			}
			break;
		}
	}
}

//--------------------------------------------------------------
//	This needs to be called when new zones open up via doors
//--------------------------------------------------------------
function connect_zones( zone_name_a, zone_name_b, one_way )
{
	if ( !isdefined( one_way )  )
	{
		one_way = false;
	}

	// If it's not already activated, it will activate the zone
	//	If it's already activated, it won't do anything.
	zone_init( zone_name_a );
	zone_init( zone_name_b );

	enable_zone( zone_name_a );
	enable_zone( zone_name_b );

	// B becomes an adjacent zone of A
	if ( !isdefined( level.zones[ zone_name_a ].adjacent_zones[ zone_name_b ] )  )
	{
		level.zones[ zone_name_a ].adjacent_zones[ zone_name_b ] = SpawnStruct();
		level.zones[ zone_name_a ].adjacent_zones[ zone_name_b ] flag::set( "connected" );
	}

	if ( !one_way )
	{
		// A becomes an adjacent zone of B
		if ( !isdefined( level.zones[ zone_name_b ].adjacent_zones[ zone_name_a ] )  )
		{
			level.zones[ zone_name_b ].adjacent_zones[ zone_name_a ] = SpawnStruct();
			level.zones[ zone_name_b ].adjacent_zones[ zone_name_a ] flag::set( "connected" );
		}
	}
}


//--------------------------------------------------------------
//	This one function will handle managing all zones in your map
//	to turn them on/off - probably the best way to handle this
//--------------------------------------------------------------
function manage_zones( initial_zone )
{
	if ( IsDefined( initial_zone ) && !IsDefined( level.zone_mgr.a_sections ) )
	{
		zone_mgr::register_start_section( initial_zone );
	}
	
	if ( !IsDefined( initial_zone ) && IsDefined( level.zone_mgr.a_sections[ "start" ] ) )
	{
		initial_zone = level.zone_mgr.a_sections[ "start" ].str_seed;
	}
	
	assert( isdefined( initial_zone ), "You must specify an initial zone to manage" );

	zone_choke = 0;

	// Setup zone connections
	if ( isdefined( level.zone_manager_init_func )  )
	{
		[[ level.zone_manager_init_func ]]();
	}

	/#	PrintLn( "zone_mgr->manage_zones ( initial zone size ) = " + initial_zone.size );	#/

	if ( IsArray( initial_zone )  )
	{
		for ( i = 0; i < initial_zone.size; i++ )
		{
			/#	PrintLn( "zone_mgr->manage_zones ( initial zone[" + i + "] ) = " + initial_zone[i] );	#/
				
			zone_init( initial_zone[i] );
			enable_zone( initial_zone[i] );
		}
	}
	else
	{
		/#	PrintLn( "zone_mgr->manage_zones ( initial zone ) = " + initial_zone );	#/
		zone_init( initial_zone );
		enable_zone( initial_zone );
	}

	setup_zone_flag_waits();

	a_keys = GetArrayKeys( level.zones );
	level.zone_keys = a_keys;
	level.newzones = [];
	for ( z=0; z<a_keys.size; z++ )
	{
		level.newzones[ a_keys[z] ] = spawnstruct();
		level.newzones[ a_keys[z] ] flag::init( "active" );
		level.newzones[ a_keys[z] ] flag::init( "occupied" );
		level.newzones[ a_keys[z] ] flag::init( "objective" );
	}
	oldzone = undefined;

	setup_map_sections( initial_zone );
	init_blockers();
	
	level flag::set( "zones_initialized" );
	
	// Add thread to display zone info for debugging
	/#
		level thread _debug_zones();
		level thread _debug_spawn_points();
	#/

	// Now iterate through the active zones and see if we need to activate spawners
	while( GetDvarInt( "noclip" ) == 0 ||GetDvarInt( "notarget" ) != 0	 )
	{
		level flag::set( "zone_scanning_active" );

		// reset working zone flags
		for ( z=0; z<a_keys.size; z++ )
		{
			zone = level.zones[ a_keys[z] ];
			newzone = level.newzones[ a_keys[z] ];

			if ( !zone flag::get( "enabled" ) )
			{
				continue;
			}

			if ( isdefined( level.zone_occupied_func )  )
			{
				newzone flag::set_val( "occupied", [[ level.zone_occupied_func ]]( a_keys[z] ) );
			}
			else
			{
				newzone flag::set_val( "occupied", player_in_zone( a_keys[z] ) );
			}

			newzone flag::clear( "active" );
			newzone flag::set_val( "objective", zone flag::get( "objective" ) );
			
			// Need to 
			zone_choke++;
			if ( zone_choke >= 10 )
			{
				zone_choke=0;
				{wait(.05);};
			}
		}

		// Figure out which zones are active
		//	If a player occupies a zone, then that zone and any of its enabled adjacent zones will activate
		a_zone_is_active = false;	// let's us know if an active zone is found
		a_zone_is_spawning_allowed = false;	// let's us know if an active zone that allows spawning is found
		for ( z=0; z<a_keys.size; z++ )
		{
			zone = level.zones[ a_keys[z] ];
			newzone = level.newzones[ a_keys[z] ];
			if ( !zone flag::get( "enabled" ) )
			{
				continue;
			}

			// If it's a player activated zone in a player-based mode OR
			//	an objective zone in an objective-based mode then process
			if ( ( newzone flag::get( "occupied" )  && level.zone_mgr flag::get( "activate_player_zones" ) ) ||
			     ( newzone flag::get( "objective" ) && level.zone_mgr flag::get( "activate_objective_zones" ) ) )
			{
				// Activate this zone unless there is an exclusion on it.
				if ( !level.zone_mgr flag::get( "exclude_player_occupied_zones" ) || 
				     !newzone flag::get( "occupied" ) )
				{
					newzone flag::set( "active" );
					a_zone_is_active = true;
					if ( zone flag::get( "spawning_allowed" ) )
					{
						a_zone_is_spawning_allowed = true;
					}
	
					if ( !isdefined( oldzone ) || ( oldzone != newzone ) )
					{
						level notify( "newzoneActive", a_keys[z] );
						oldzone = newzone;
					}
				}

				// Activate adjacent zones
				aa_keys = GetArrayKeys( zone.adjacent_zones );
				for ( az=0; az<zone.adjacent_zones.size; az++ )
				{
					// Make sure it's connected (door/pathway open) and enabled.
					if ( zone.adjacent_zones[ aa_keys[az] ] flag::get( "connected" ) &&
					    level.zones[ aa_keys[az] ] flag::get( "enabled" ) )
					{
						// add unless we're excluding player occupied zones and it's occupied
						if ( !level.zone_mgr flag::get( "exclude_player_occupied_zones" ) ||
						     !level.newzones[ aa_keys[ az ] ] flag::get( "occupied" ) )
						{
							//level.zones[ aa_keys[ az ] ] flag::set( "active" );
							level.newzones[ aa_keys[ az ] ] flag::set( "active" );
							a_zone_is_active = true;
							if ( level.zones[ aa_keys[ az ] ] flag::get( "spawning_allowed" ) )
							{
								a_zone_is_spawning_allowed = true;
							}
						}
					}
				}
			}
		}
		level flag::clear( "zone_scanning_active" );

		// Now populate the real zone data
		foreach( str_zone,s_zone in level.zones )
		{
			s_temp_zone = level.newzones[ str_zone ];
			
			s_zone flag::set_val( "active",		s_temp_zone flag::get( "active" ) );
			s_zone flag::set_val( "occupied",	s_temp_zone flag::get( "occupied" ) );
		}

//		// MM - Special logic for empty spawner list, this is just a failsafe
//		if ( !a_zone_is_active || !a_zone_is_spawning_allowed )
//		{
//			if ( IsArray( initial_zone )  )
//			{
//				level.zones[ initial_zone[0] ] flag::set( "active" );
//				level.zones[ initial_zone[0] ] flag::set( "occupied" );
//				level.zones[ initial_zone[0] ] flag::set( "spawning_allowed" );
//			}
//			else
//			{
//				level.zones[ initial_zone ] flag::set( "active" );
//				level.zones[ initial_zone ] flag::set( "occupied" );
//				level.zones[ initial_zone ] flag::set( "spawning_allowed" );
//			}
//		}

		// Okay now we can re-create the spawner list
		[[ level.create_spawner_list_func ]]( a_keys );

		/#
		debug_show_spawn_locations();
		#/

//		level.active_zone_names = get_active_zone_names();

		//wait a second before another check
		wait( 1 );
	}
}

function setup_map_sections( a_initial_zones )
{
	// generate section list, then disable all zones at start
	foreach ( str_zone in get_section_list() )
	{
		set_section_zone_list( str_zone );
		disable_section( str_zone );
	}
	
	// always turn on start section by default
	enable_section( "start" );
	
	/#
	// sanity check
	n_zone_count = 0;
	foreach ( str_section in get_section_list() )
	{
		n_zone_count += level.zone_mgr.a_sections[ str_section ].a_zone_list.size;
	}
	
	if ( n_zone_count > level.zones.size )
	{
		iprintlnbold( "WARNING: zone sections overlap! get_area_list() found " + n_zone_count + " zones out of a possible " + level.zones.size + " zones in the map" );
	}
	else if ( n_zone_count < level.zones.size )
	{
		iprintlnbold( "WARNING: zone sections missing! get_area_list() found " + n_zone_count + " zones out of a possible " + level.zones.size + " zones in the map" );
	}
	#/
}

function enable_section( str_identifier )
{
	Assert( IsDefined( level.zone_mgr.a_sections[ str_identifier ] ), "enable_section() couldn't find section with identifier " + str_identifier );
	
	foreach ( str_zone in get_section_zone_list( str_identifier ) )
	{
		enable_zone( str_zone );
	}
	
	level.zone_mgr.a_sections[ str_identifier ].is_locked = false;
	
	// remove blocker doors
	foreach ( m_door in level.zone_mgr.a_sections[ str_identifier ].a_doors )
	{
		m_door notify( "unlock" );
	}
	
	// run optional unlock func
	if ( IsDefined( level.zone_mgr.a_sections[ str_identifier ].func_unlock ) )
	{
		level thread [[ level.zone_mgr.a_sections[ str_identifier ].func_unlock ]]();
	}	
}

function disable_section( str_identifier )
{
	Assert( IsDefined( level.zone_mgr.a_sections[ str_identifier ] ), "disable_section() couldn't find section with identifier " + str_identifier );
	
	foreach ( str_zone in get_section_zone_list( str_identifier ) )
	{
		disable_zone( str_zone );
	}	
	
	level.zone_mgr.a_sections[ str_identifier ].is_locked = true;
}

function is_section_locked( str_identifier )
{
	Assert( IsDefined( level.zone_mgr.a_sections[ str_identifier ] ), "is_section_locked() couldn't find section with identifier " + str_identifier );
	
	return level.zone_mgr.a_sections[ str_identifier ].is_locked;
}

function is_zone_in_section( str_zone, str_section )
{
	return IsInArray( get_section_zone_list( str_section ), str_zone );
}

function is_valid_section( str_section )
{
	return IsDefined( level.zone_mgr.a_sections[ str_section ] );
}

function is_zone_in_unlocked_section( str_zone )
{
	b_is_in_unlocked_section = false;
	
	foreach ( str_section in get_unlocked_sections_list() )
	{
		if ( is_zone_in_section( str_zone, str_section ) )
		{
			b_is_in_unlocked_section = true;
			break;
		}
	}
	
	return b_is_in_unlocked_section;
}

function print_disabled_zones()
{
	// zone test
	level flag::wait_till( "zones_initialized" );
	
	n_zones_total = level.zones.size;
	a_zones_disabled = [];
	
	foreach ( s_zone in level.zones )
	{
		if ( !s_zone flag::get( "enabled" ) )
		{
			if ( !isdefined( a_zones_disabled ) ) a_zones_disabled = []; else if ( !IsArray( a_zones_disabled ) ) a_zones_disabled = array( a_zones_disabled ); a_zones_disabled[a_zones_disabled.size]=s_zone.zone_name;;
		}
	}
	
	/#
	println( "_zone_mgr >> zones disabled = " + a_zones_disabled.size );
	
	foreach ( str_zone in a_zones_disabled )
	{
		println( "_zone_mgr >> disabled: " + str_zone );
	}
	#/
}

function get_blocker_doors_from_script_flag( str_script_flag )
{
	Assert( IsDefined( str_script_flag ), "get_blocker_doors_from_script_flag() requires input argument str_script_flag to identify a blocking door!" );
	
	a_doors = get_blocker_doors();
	
	a_doors_found = [];
	
	foreach ( m_door in a_doors )
	{
		if ( ( str_script_flag === m_door.script_flag ) )
		{
			array::add( a_doors_found, m_door, false );
		}
	}
	
	Assert( a_doors_found.size, "get_blocker_doors_from_script_flag() couldn't find door with script_flag = " + str_script_flag );
	
	return a_doors_found;
}

function get_blocker_doors()
{
	return GetEntArray( "script_door_blocker", "targetname" );
}

function register_start_section( str_zone_seed )
{
	// make sure we only use one start zone seed - done this way to make sure old levels continue to work
	if ( IsArray( str_zone_seed ) )
	{
		str_zone_seed = str_zone_seed[ 0 ];
	}
	
	register_locked_section( "start", str_zone_seed, "always_on" );
}

function register_locked_section( str_identifier, str_zone_seed, str_door, func_unlock )
{
	Assert( IsDefined( str_identifier ), "register_locked_section() missing str_identifier input argument. This is required to set up a locked section in _zone_mgr.gsc" );
	Assert( IsDefined( str_zone_seed ), "register_locked_section() missing str_zone_seed input argument. Use any zone name inside the registered section to fix this." );
	Assert( IsDefined( str_door ), "register_locked_section() missing str_door input argument. This flag will be set when section '" + str_identifier + "' unlocks, and associates doors with each section. This should match the script_flag KVP on blocking doors." );
	
	if ( !IsDefined( level.zone_mgr.a_sections ) )
	{
		level.zone_mgr.a_sections = [];
	}
	
	Assert( !IsDefined( level.zone_mgr.a_sections[ str_identifier ] ), "register_locked_section attempted to re-register existing section with name '" + str_identifier + "'!" );
	
	s_temp = SpawnStruct();
	
	s_temp.str_zone_seed = str_zone_seed;
	s_temp.is_locked = true;
	s_temp.func_unlock = func_unlock;
	s_temp.str_door = str_door;
	
	// associate doors with section
	s_temp.a_doors = [];
	
	if ( str_door != "always_on" )
	{
		s_temp.a_doors = get_blocker_doors_from_script_flag( str_door );
		foreach ( m_door in s_temp.a_doors )
		{
			m_door.str_section_to_unlock = str_identifier;
		}
	}
	
	s_temp.a_zone_list = [];  // to be populated once zones are initialized
	
	level.zone_mgr.a_sections[ str_identifier ] = s_temp;
}

function get_section_list()
{
	a_keys = GetArrayKeys( level.zone_mgr.a_sections );
	
	return a_keys;
}

function get_locked_sections_list()
{
	a_locked_sections = [];
	
	a_keys = GetArrayKeys( level.zone_mgr.a_sections );
	
	for ( i = 0; i < a_keys.size; i++ )
	{
		if ( level.zone_mgr.a_sections[ a_keys[ i ] ].is_locked )
		{
			array::add( a_locked_sections, a_keys[ i ], false );
		}
	}
	
	return a_locked_sections;
}

function get_unlocked_sections_list()
{
	a_unlocked_sections = [];
	
	a_keys = GetArrayKeys( level.zone_mgr.a_sections );
	
	for ( i = 0; i < a_keys.size; i++ )
	{
		if ( !level.zone_mgr.a_sections[ a_keys[ i ] ].is_locked )
		{
			array::add( a_unlocked_sections, a_keys[ i ], false );
		}
	}
	
	return a_unlocked_sections;	
}

function get_doors_for_section( str_section )
{
	Assert( IsDefined( level.zone_mgr.a_sections[ str_section ] ), "get_doors_for_section() couldn't find section named " + str_section );
	
	return level.zone_mgr.a_sections[ str_section ].a_doors;
}

function set_section_zone_list( str_identifier )
{
	Assert( IsDefined( level.zone_mgr.a_sections[ str_identifier ] ), "set_section_zone_list() couldn't find a zone with identifier " + str_identifier );
	
	level.zone_mgr.a_sections[ str_identifier ].a_zone_list = get_connected_zone_list( level.zone_mgr.a_sections[ str_identifier ].str_zone_seed );
}

function get_section_zone_list( str_identifier )
{
	Assert( IsDefined( level.zone_mgr.a_sections[ str_identifier] ), "get_section_zone_list() couldn't find a zone with identifier " + str_identifier );
	
	return level.zone_mgr.a_sections[ str_identifier ].a_zone_list;
}

function get_connected_zone_list( a_initial_zones )
{
	Assert( ( IsDefined( a_initial_zones ) && ( a_initial_zones.size > 0 ) ), "get_connected_zone_list() needs start zone string to start traversal!" );

	if ( !IsArray( a_initial_zones ) )
	{
		a_initial_zones = Array( a_initial_zones );
	}
	
	a_connected_zones = [];
	a_searched = [];
	a_to_search = a_initial_zones;
	
	// enable only connected zones
	while ( a_to_search.size > 0 )
	{
		str_current = a_to_search[ 0 ];
		s_current = level.zones[ str_current ];
		a_adjacents = GetArrayKeys( s_current.adjacent_zones );
		
		if ( !isdefined( a_searched ) ) a_searched = []; else if ( !IsArray( a_searched ) ) a_searched = array( a_searched ); a_searched[a_searched.size]=str_current;;
		ArrayRemoveValue( a_to_search, str_current, false );
		
		for ( i = 0; i < a_adjacents.size; i++ )
		{
			str_adjacent = a_adjacents[ i ];
			
			if ( s_current.adjacent_zones[ str_adjacent ] flag::get( "connected" ) )
			{
				if ( !IsInArray( a_to_search, str_adjacent ) && !IsInArray( a_searched, str_adjacent ) )
				{
					if ( !isdefined( a_to_search ) ) a_to_search = []; else if ( !IsArray( a_to_search ) ) a_to_search = array( a_to_search ); a_to_search[a_to_search.size]=str_adjacent;;
				}
				
				array::add( a_connected_zones, str_adjacent, false );
			}
		}
	}
	
	return a_connected_zones;	
}

function init_blockers()
{
	a_doors = get_blocker_doors();
	
	foreach ( m_door in a_doors )
	{
		m_door thread init_door_blocker();
	}
}

function init_door_blocker()  // self = script brush model
{
	Assert( IsDefined( self.script_flag ), "script_flag KVP missing on script_blocker_door at " + self.origin + "! This is used to set a zone connection flag." );

	self DisconnectPaths();
	
	self wait_for_door_unlock();
	
	level flag::set( self.script_flag );
	
	if ( IsDefined( self.str_section_to_unlock ) )
	{
		enable_section( self.str_section_to_unlock );
	}
	
	self ConnectPaths();
	level notify( "zone_manager_door_unlocked" );
	
	self movez( 200, 0.4 );
	self waittill( "movedone" );
	self delete();

}

function wait_for_door_unlock()
{
	level endon( "dev_unlock_all_doors" );
	
	self waittill( "unlock" );
}

//--------------------------------------------------------------
/#
function debug_show_spawn_locations()
{
	if ( ( isdefined( level.toggle_show_spawn_locations ) && level.toggle_show_spawn_locations )  )
	{
		host_player = util::GetHostPlayer();
		foreach( location in level.soldier_spawn_locations )
		{
			distance = Distance( location.origin, host_player.origin );
			color = ( 0,0,1 );
			if ( distance > ( GetDvarInt( "scr_spawner_location_distance" ) * 12 )  )
			{
				color = ( 1,0,0 );
			}
			debugstar( location.origin, GetDvarInt( "scr_spawner_location_time" ), color );
			//Print3d( location.origin, ( distance/12 ), color, 1, 20 );
		}
	}

}

//
//	Create the list of enemies to be used for spawning
function create_spawner_list( a_keys )
{
	level.soldier_spawn_locations = [];

	for ( z = 0; z < a_keys.size; z++ )
	{
		zone = level.zones[ a_keys[z] ];

		if ( zone flag::get( "enabled" ) && zone flag::get( "active" ) && zone flag::get( "spawning_allowed" ) )
		{
			for ( i = 0; i < zone.a_s_spawn_locs.size; i++ )
			{
				if ( zone.a_s_spawn_locs[i] flag::get( "enabled" ) )
				{
					level.soldier_spawn_locations[ level.soldier_spawn_locations.size ] = zone.a_s_spawn_locs[i];
				}
			}
		}
	}
}


//
//	Retrieve a list of active zones
function get_active_zone_names( )
{
	a_str_zones = [];

	if ( !isdefined( level.zone_keys ))
	{
		return a_str_zones;
	}

	level flag::wait_till_clear( "zone_scanning_active" );

	foreach( str_zone in level.zone_keys )
	{
		if ( level.zones[ str_zone ] flag::get( "active" ) )
		{
			if ( !isdefined( a_str_zones ) ) a_str_zones = []; else if ( !IsArray( a_str_zones ) ) a_str_zones = array( a_str_zones ); a_str_zones[a_str_zones.size]=str_zone;;
		}
	}

	return a_str_zones;
}


/#
// Debug zone info
function _init_debug_zones()
{
	current_y = 30;
	current_x = 20;

	xloc = [];
	xloc[0] = 250;
	xloc[1] = 260;
	xloc[2] = 300;
	xloc[3] = 330;
	xloc[4] = 370;
	xloc[5] = 410;

	a_keys = GetArrayKeys( level.zones );
	for ( i = 0; i < a_keys.size; i++ )
	{
		zoneName = a_keys[i];
		zone = level.zones[zoneName];

		zone.debug_hud = [];
		for ( j = 0; j < xloc.size; j++ )
		{
			zone.debug_hud[j] = NewDebugHudElem();
			if ( !j )
			{
				zone.debug_hud[j].alignX = "right";
			}
			else
			{
				zone.debug_hud[j].alignX = "left";
			}
			zone.debug_hud[j].x = xloc[j];
			zone.debug_hud[j].y = current_y;
		}

		current_y += 10;
		zone.debug_hud[0] SetText( zoneName );
	}
}

function _destroy_debug_zones()
{
	a_keys = GetArrayKeys( level.zones );
	for ( i = 0; i < a_keys.size; i++ )
	{
		zoneName = a_keys[i];
		zone = level.zones[zoneName];

		n_huds = zone.debug_hud.size;
		for ( j = 0; j < n_huds; j++ )
		{
			zone.debug_hud[j] Destroy();
			zone.debug_hud[j] = undefined;
		}
	}
}

function _debug_zones()
{
	enabled = false;
	if ( GetDvarString( "sidemission_debug_zones" ) == "" )
	{
		SetDvar( "sidemission_debug_zones", "0" );
	}

	while ( true )
	{
		wasEnabled = enabled;
		enabled = GetDvarInt( "sidemission_debug_zones" );
		if ( enabled && !wasEnabled )
		{
			_init_debug_zones();
		}
		else if ( !enabled && wasEnabled )
		{
			_destroy_debug_zones();
		}

		if ( enabled )
		{
			a_keys = GetArrayKeys( level.zones );
			for ( i = 0; i < a_keys.size; i++ )
			{
				zoneName = a_keys[i];
				zone = level.zones[zoneName];

				text = zoneName;
				zone.debug_hud[0] SetText( text );

				if ( zone flag::get( "enabled" ) )
				{
					text += " Enabled";
					zone.debug_hud[1] SetText( "Enabled" );
				}
				else
				{
					zone.debug_hud[1] SetText( "" );
				}
				if ( zone flag::get( "active" ) )
				{
					text += " Active";
					zone.debug_hud[2] SetText( "Active" );
				}
				else
				{
					zone.debug_hud[2] SetText( "" );
				}
				if ( zone flag::get( "occupied" ) )
				{
					text += " Occupied";
					zone.debug_hud[3] SetText( "Occupied" );
				}
				else
				{
					zone.debug_hud[3] SetText( "" );
				}
				if ( zone flag::get( "objective" ) )
				{
					text += " Objective";
					zone.debug_hud[4] SetText( "Objective" );
				}
				else
				{
					zone.debug_hud[4] SetText( "" );
				}
				if ( zone flag::get( "spawning_allowed" ) )
				{
					text += " SpawningAllowed";
					zone.debug_hud[5] SetText( "SpawningAllowed" );
				}
				else
				{
					zone.debug_hud[5] SetText( "" );
				}
			}
		}

		//util::wait_network_frame();
		wait( 0.1 );
	}
}

function _debug_spawn_points()
{
	while ( true )
	{
		if ( GetDvarInt( "sidemission_debug_spawn_points" ) > 0 )
		{	
			foreach ( s_zone in level.zones )
			{
				if ( ( s_zone flag::get( "active" ) || s_zone flag::get( "occupied" ) ) && s_zone flag::get( "spawning_allowed" ) )
				{
					if ( isdefined( s_zone.a_s_spawn_locs ) )
					{
						foreach ( s_spawn_point in s_zone.a_s_spawn_locs )
						{
							s_spawn_point debug_show_spawner_location();
						}
					}
				}
			}	
		}
		
		wait 1;
	}
}

function debug_show_spawner_location()
{
	const DURATION = 20; // frames
	const DEPTH_TEST = 0;  // boolean
	const COLOR_ALPHA = 0.5;
	
	v_box_min = ( -16, -16, 0 );
	v_box_max = ( 16, 16, 64 );
	
	if ( IsDefined( self.angles ) )
	{
		box_yaw = self.angles[ 1 ];
	}
	else 
	{
		box_yaw = 0;
	}
	
	Box( self.origin, v_box_min, v_box_max, box_yaw, ( 1, 0, 0 ), COLOR_ALPHA, DEPTH_TEST, DURATION );
}

// ZONE DEBUG END
#/

//--------------------------------------------------------------
//  Checks to see if the player is in a zone_name volume
// self == a player
//--------------------------------------------------------------
function is_player_in_zone( zone_name )
{
	zone = level.zones[ zone_name ];
	for ( i = 0; i < zone.volumes.size; i++ )
	{
		if ( self IsTouching( level.zones[ zone_name ].volumes[i] ) && !( self.sessionstate == "spectator" ) )
		{
			return true;
		}
	}
	return false;
}
