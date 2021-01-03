#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\gametypes\_zm_gametype;

#using scripts\zm\_util;

#namespace zm_zonemgr;

function autoexec __init__sytem__() {     system::register("zm_zonemgr",&__init__,undefined,undefined);    }

//
//	This manages which spawners are valid for the game.  The round_spawn function
//	will use the arrays generated to figure out where to spawn a zombie from.
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
//				level thread zm_zonemgr::manage_zones( init_zones );
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
/#	PrintLn( "ZM >> Zombiemode Server Scripts Init (_zm_zonemgr.gsc)" );	#/
	
	level flag::init( "zones_initialized" );

	level.zones = [];
	level.zone_flags = [];
	level.zone_scanning_active = 0;

	//Default callback. Set local override before load::main
	level.create_spawner_list_func = &create_spawner_list;
}


//*****************************************************************************
//	Check to see if a zone is enabled
//*****************************************************************************

function zone_is_enabled( zone_name )
{
	if ( !IsDefined(level.zones) || !IsDefined(level.zones[ zone_name ]) || !level.zones[ zone_name ].is_enabled )
	{
		return false;
	}

	return true;
}


//*****************************************************************************
// Pass back the zone the player is occupying
//*****************************************************************************

// self = player
function get_player_zone()
{
	player_zone = undefined;

	keys = GetArrayKeys( level.zones );
	for( i=0; i<keys.size; i++ )
	{
		if( self entity_in_zone( keys[i] ) )
		{
			player_zone = keys[i];
			break;
		}
	}

	return( player_zone );
}


//*****************************************************************************
// Pass back the zone from the position
//*****************************************************************************

function get_zone_from_position( v_pos, ignore_enabled_check )
{
	zone = undefined;

	scr_org = spawn( "script_origin", v_pos );

	keys = GetArrayKeys( level.zones );
	for( i=0; i<keys.size; i++ )
	{
		if( scr_org entity_in_zone( keys[i], ignore_enabled_check ) )
		{
			zone = keys[i];
			break;
		}
	}

	scr_org delete();

	return( zone );
}

function get_zone_magic_boxes( zone_name )
{
	if( IsDefined( zone_name ) && !zone_is_enabled( zone_name ) )
	{
		return undefined;
	}
	
	zone = level.zones[ zone_name ];
	
	assert( IsDefined( zone_name ) );
	
	return zone.magic_boxes;
}

function get_zone_zbarriers( zone_name )
{
	if( IsDefined( zone_name ) && !zone_is_enabled( zone_name ) )
	{
		return undefined;
	}
	
	zone = level.zones[ zone_name ];
	
	assert( IsDefined( zone_name ) );
	
	return zone.zbarriers;
}

//*****************************************************************************
//  Checks to see how many players are in a zone_name volume
//*****************************************************************************

function get_players_in_zone( zone_name, return_players )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name ) )
	{
		return false;
	}
	zone = level.zones[ zone_name ];

	// Okay check to see if a player is in one of the zone volumes
	num_in_zone = 0;
	players_in_zone = [];
	players = GetPlayers();
	for (i = 0; i < zone.volumes.size; i++)
	{
		for (j = 0; j < players.size; j++)
		{
			if ( players[j] IsTouching(zone.volumes[i]) )
			{
				num_in_zone++;
				players_in_zone[players_in_zone.size] = players[j];
			}
		}
	}
	if(isDefined(return_players))
	{
		return players_in_zone;
	}
	return num_in_zone;
}


//--------------------------------------------------------------
//  Checks to see if a player is in a zone_name volume
//--------------------------------------------------------------
function any_player_in_zone( zone_name )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name ) )
	{
		return false;
	}
	zone = level.zones[ zone_name ];

	// Okay check to see if a player is in one of the zone volumes
	for (i = 0; i < zone.volumes.size; i++)
	{
		players = GetPlayers();
		for (j = 0; j < players.size; j++)
		{
			if ( players[j] IsTouching(zone.volumes[i]) && !(players[j].sessionstate == "spectator"))
			return true;
		}
	}
	return false;
}

//--------------------------------------------------------------
//  Checks to see if a entity is in a zone_name volume
//	self is an entity
function entity_in_zone( zone_name, ignore_enabled_check = false )
{
	if ( IsPlayer( self ) && self.sessionstate == "spectator" )
	{
		return false;
	}

	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name ) && !ignore_enabled_check )
	{
		return false;
	}

	zone = level.zones[ zone_name ];

	// Okay check to see if an entity is in one of the zone volumes
	foreach( e_volume in zone.volumes )
	{
		if ( self IsTouching( e_volume ) )
		{
			return true;
		}
	}
	return false;
}


//	Check to see if an entity is in a currently active zone
//	self is an entity (do not use a player)
function entity_in_active_zone( ignore_enabled_check = false )
{
	if ( IsPlayer( self ) && self.sessionstate == "spectator" )
	{
		return false;
	}
	
	foreach( str_adj_zone in level.active_zone_names )
	{
		b_in_zone = entity_in_zone( str_adj_zone, ignore_enabled_check );
		if ( b_in_zone )
		{
			return true;
		}			
	}
	
	return false;
}


//
//	Disable exterior_goals that have a script_noteworthy.  This can prevent zombies from
//		pathing to a3 goal that the zombie can't path towards the player after entering.
//	They will be activated later, when the zone gets enabled.
function deactivate_initial_barrier_goals()
{
	special_goals = struct::get_array("exterior_goal", "targetname");
	for (i = 0; i < special_goals.size; i++)
	{
		if (IsDefined(special_goals[i].script_noteworthy))
		{
			special_goals[i].is_active = false;
			special_goals[i] TriggerEnable( false );
		}
	}
}


//--------------------------------------------------------------
//	Call this when you want to allow zombies to spawn from a zone
//	-	Must have at least one info_volume with targetname = (name of the zone)
//	-	Have the info_volumes target the zone's spawners
//--------------------------------------------------------------
function zone_init( zone_name, zone_tag )
{
	if ( IsDefined( level.zones[ zone_name ] ) )
	{
		// It's already been activated
		return;
	}

/#	PrintLn( "ZM >> zone_init (1) = " + zone_name);		#/
	// Add this to the list of active zones
	level.zones[ zone_name ] = SpawnStruct();
	zone = level.zones[ zone_name ];

	zone.is_enabled = false;	// The zone is not enabled.  You can stop looking at it
								//		until it is.
	zone.is_occupied = false;	// The zone is not occupied by a player.  This is what we 
								//		use to determine when to activate adjacent zones
	zone.is_active = false;		// The spawners will not be added to the spawning list
								//		until this true.
	zone.adjacent_zones = [];	// NOTE: These must be defined in a separate level-specific initialization via add_adjacent_zone
	
	zone.is_spawning_allowed = false;
	
	if( isDefined( zone_tag ) )
	{
		zone_name_tokens = StrTok( zone_name, "_" );
		
		zone.district = zone_name_tokens[1];
		zone.area = zone_tag;
	}
	
	// 
	zone.volumes = [];
	volumes = GetEntArray( zone_name, "targetname" );
	
/#	PrintLn( "ZM >> zone_init (2) = " + volumes.size );	#/
	
	
	for ( i=0; i<volumes.size; i++ )
	{
		if ( volumes[i].classname == "info_volume" )
		{
			zone.volumes[ zone.volumes.size ] = volumes[i];
		}
	}
	
	assert( IsDefined( zone.volumes[0] ), "zone_init: No volumes found for zone: "+zone_name );	

/#	
	zone.total_spawn_count = 0;
	zone.round_spawn_count = 0;
#/	
	// Fill in locs array with locations needed.
	zone.a_loc_types = [];
	zone.a_loc_types[ "zombie_location" ] = [];

	zone.zbarriers = [];
	zone.magic_boxes = [];
	
	if ( IsDefined( zone.volumes[0].target ) )
	{
		spots = struct::get_array(zone.volumes[0].target, "targetname");
		
		barricades = struct::get_array("exterior_goal","targetname");
		box_locs = struct::get_array( "treasure_chest_use", "targetname" );

		foreach( spot in spots )
		{
			spot.zone_name = zone_name;
			if(!( isdefined( spot.is_blocked ) && spot.is_blocked ))
			{
				spot.is_enabled = true;
			}
			else
			{
				spot.is_enabled = false;
			}

			//	Sort the locations
			tokens = StrTok( spot.script_noteworthy, " " );
			foreach ( token in tokens )
			{
				switch( token )
				{
					// Basic zombie spawn locations
					case "spawn_location":
					case "riser_location":
					case "faller_location":
						if ( !isdefined( zone.a_loc_types[ "zombie_location" ] ) ) zone.a_loc_types[ "zombie_location" ] = []; else if ( !IsArray( zone.a_loc_types[ "zombie_location" ] ) ) zone.a_loc_types[ "zombie_location" ] = array( zone.a_loc_types[ "zombie_location" ] ); zone.a_loc_types[ "zombie_location" ][zone.a_loc_types[ "zombie_location" ].size]=spot;;
						break;
					default:
						if ( !isdefined( zone.a_loc_types[ token ] ) )
						{
							zone.a_loc_types[ token ] = [];
						}
						
						if ( !isdefined( zone.a_loc_types[ token ] ) ) zone.a_loc_types[ token ] = []; else if ( !IsArray( zone.a_loc_types[ token ] ) ) zone.a_loc_types[ token ] = array( zone.a_loc_types[ token ] ); zone.a_loc_types[ token ][zone.a_loc_types[ token ].size]=spot;;
				}
			}
			
			if(IsDefined(spot.script_string))
			{
				barricade_id = spot.script_string;
				//level.exterior_goals probably not yet defined.
				for (k = 0; k < barricades.size; k++)
				{	
					if(IsDefined(barricades[k].script_string) && barricades[k].script_string == barricade_id)
					{
						nodes = GetNodeArray(barricades[k].target, "targetname");
						for (j = 0; j < nodes.size; j++)
						{
							if(	IsDefined(nodes[j].type) &&  nodes[j].type == "Begin")
								spot.target = nodes[j].targetname;
						}
					}					
				}	
			}
		}
		
		for( i = 0; i < barricades.size; i++ )
		{
			targets = GetEntArray( barricades[i].target, "targetname" );
			for( j = 0; j < targets.size; j++ )
			{
				if( targets[j] IsZBarrier() && IsDefined( targets[j].script_string ) && targets[j].script_string == zone_name )
				{
					if ( !isdefined( zone.zbarriers ) ) zone.zbarriers = []; else if ( !IsArray( zone.zbarriers ) ) zone.zbarriers = array( zone.zbarriers ); zone.zbarriers[zone.zbarriers.size]=targets[j];;
				}
			}
		}

		for( i = 0; i < box_locs.size; i++ )
		{
			chest_ent = GetEnt(box_locs[i].script_noteworthy + "_zbarrier", "script_noteworthy");
			if( chest_ent entity_in_zone( zone_name, true ) )
			{
				if ( !isdefined( zone.magic_boxes ) ) zone.magic_boxes = []; else if ( !IsArray( zone.magic_boxes ) ) zone.magic_boxes = array( zone.magic_boxes ); zone.magic_boxes[zone.magic_boxes.size]=box_locs[i];;
			}
		}
	}	
}

//
// Update the spawners
function reinit_zone_spawners()
{
	zkeys = GetArrayKeys( level.zones );
	for ( i = 0; i < level.zones.size; i++ )
	{
		zone = level.zones[ zkeys[i] ];
		
		// Fill in locs array with locations
		zone.a_loc_types = [];
		zone.a_loc_types[ "zombie_location" ] = [];

		if ( IsDefined( zone.volumes[0].target ) )
		{
			spots = struct::get_array(zone.volumes[0].target, "targetname");
			foreach ( n_index, spot in spots )
			{
				spot.zone_name = zkeys[n_index];
 				if(!( isdefined( spot.is_blocked ) && spot.is_blocked ))
				{
					spot.is_enabled = true;
				}
				else
				{
					spot.is_enabled = false;
				}

				//	Sort the locations
				tokens = StrTok( spot.script_noteworthy, " " );
				foreach ( token in tokens )
				{
					switch( token )
					{
						// Basic zombie spawn locations
						case "spawn_location":
						case "spawner_location":
						case "riser_location":
						case "faller_location":
						if ( !isdefined( zone.a_loc_types[ "zombie_location" ] ) ) zone.a_loc_types[ "zombie_location" ] = []; else if ( !IsArray( zone.a_loc_types[ "zombie_location" ] ) ) zone.a_loc_types[ "zombie_location" ] = array( zone.a_loc_types[ "zombie_location" ] ); zone.a_loc_types[ "zombie_location" ][zone.a_loc_types[ "zombie_location" ].size]=spot;;
							break;
						default:
							if ( !isdefined( zone.a_a_locs[ token ] ) )
							{
								zone.a_loc_types[ token ] = [];
							}
							
							if ( !isdefined( zone.a_loc_types[ token ] ) ) zone.a_loc_types[ token ] = []; else if ( !IsArray( zone.a_loc_types[ token ] ) ) zone.a_loc_types[ token ] = array( zone.a_loc_types[ token ] ); zone.a_loc_types[ token ][zone.a_loc_types[ token ].size]=spot;;
					}
				}
			}
		}
	}
}


//
//	Turn on the zone
function enable_zone( zone_name )
{
	assert( IsDefined(level.zones) && IsDefined(level.zones[zone_name]), "enable_zone: zone has not been initialized" );

	if ( level.zones[ zone_name ].is_enabled )
	{
		return;
	}
	
	level.zones[ zone_name ].is_enabled = true;
	level.zones[ zone_name ].is_spawning_allowed = true;
	level notify( zone_name );

	// activate any player spawn points
	//spawn_points = struct::get_array("player_respawn_point", "targetname");
	
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	for( i = 0; i < spawn_points.size; i++ )
	{
		if ( spawn_points[i].script_noteworthy == zone_name )
		{
			spawn_points[i].locked = false;
		}
	}

	//	Allow zombies to path to the barriers in the zone.
	//	All barriers with a script_noteworthy should initially be triggered off by
	//		deactivate_barrier_goals
	entry_points = struct::get_array(zone_name+"_barriers", "script_noteworthy");
	for(i=0;i<entry_points.size;i++)
	{
		entry_points[i].is_active = true;
		entry_points[i] TriggerEnable( true );
	}	

	bb::logRoundEvent("zone_enable_" + zone_name);	
}


//
//	Add zone B to zone A's adjacency list
//
//	main_zone_name - zone to be connected to
//	adj_zone_name - zone to connect
//	flag_name - flag that will cause the connection to happen
function make_zone_adjacent( main_zone_name, adj_zone_name, flag_name )
{
	main_zone = level.zones[ main_zone_name ];

	// Create the adjacent zone entry if it doesn't exist
	if ( !IsDefined( main_zone.adjacent_zones[ adj_zone_name ] ) )
	{
		main_zone.adjacent_zones[ adj_zone_name ] = SpawnStruct();
		adj_zone = main_zone.adjacent_zones[ adj_zone_name ];
		adj_zone.is_connected = false;
		adj_zone.flags_do_or_check = false;
		// Create the link condition, the flag that needs to be set to be considered connected
		if ( IsArray( flag_name ) )
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


//	When the wait_flag gets set (like when a door opens), the add_flags will also get set.
//	This provides a slightly less clunky way to connect multiple contiguous zones within an area
//
//	wait_flag = flag to wait for
//	adj_flags = array of flag strings to set when flag is set
function add_zone_flags( wait_flag, add_flags )
{
	if (!IsArray(add_flags) )
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
// Makes zone_b adjacent to zone_a.  If one_way is false, zone_a is also made "adjacent" to zone_b
//	Note that you may not always want zombies coming from zone B while you are in Zone A, but you 
//	might want them to come from B while in A.  It's a rare case though, such as a one-way traversal.
function add_adjacent_zone( zone_name_a, zone_name_b, flag_name, one_way, zone_tag_a, zone_tag_b )
{
	if ( !IsDefined( one_way ) )
	{
		one_way = false;
	}

	// rsh030110 - added to make sure all our flags are inited before setup_zone_flag_waits()
	if ( !IsDefined( level.flag[ flag_name ] ) )
	{
		level flag::init( flag_name );
	}

	// If it's not already activated, this zone_init will activate the zone
	//	If it's already activated, it won't do anything.
	zone_init( zone_name_a, zone_tag_a );
	zone_init( zone_name_b, zone_tag_b );

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
	zkeys = GetArrayKeys( level.zones );
	for( z=0; z<level.zones.size; z++ )
	{
		zone = level.zones[ zkeys[z] ];
		azkeys = GetArrayKeys( zone.adjacent_zones );
		for ( az = 0; az<zone.adjacent_zones.size; az++ )
		{
			azone = zone.adjacent_zones[ azkeys[az] ];
			for ( f = 0; f< azone.flags.size; f++ )
			{
				array::add(flags, azone.flags[f], false );
			}
		}
	}

	for( i=0; i<flags.size; i++ )
	{
		level thread zone_flag_wait( flags[i] );
	}
}


//
//	Wait for a zone flag to be set and then update zones
//
function zone_flag_wait( flag_name )
{
	if ( !IsDefined( level.flag[ flag_name ] ) )
	{
		level flag::init( flag_name );
	}
	level flag::wait_till( flag_name );

	flags_set = false;	//	scope declaration
	// Enable adjacent zones if all flags are set for a connection
	for( z=0; z<level.zones.size; z++ )
	{
		zkeys = GetArrayKeys( level.zones );
		zone = level.zones[ zkeys[z] ];
		for ( az = 0; az<zone.adjacent_zones.size; az++ )
		{
			azkeys = GetArrayKeys( zone.adjacent_zones );
			azone = zone.adjacent_zones[ azkeys[az] ];
			if ( !azone.is_connected )
			{
				if ( azone.flags_do_or_check )
				{
					// If ANY flag is set, then connect zones
					flags_set = false;
					for ( f = 0; f< azone.flags.size; f++ )
					{
						if ( level flag::get( azone.flags[f] ) )
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
						if ( !level flag::get( azone.flags[f] ) )
						{
							flags_set = false;
						}
					}
				}

				if ( flags_set )
				{
					enable_zone( zkeys[z] );
					azone.is_connected = true;
					if ( !level.zones[ azkeys[az] ].is_enabled )
					{
						enable_zone( azkeys[az] );
					}
					if(level flag::get("door_can_close"))
					{
						azone thread door_close_disconnect(flag_name);
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

// start thread to watch for door to close.
function door_close_disconnect(flag_name)
{
	while(level flag::get(flag_name))
	{
		wait(1.0);
	}
	self.is_connected = false;
	level thread zone_flag_wait( flag_name );
}	
//--------------------------------------------------------------
//	This needs to be called when new zones open up via doors
//--------------------------------------------------------------
function connect_zones( zone_name_a, zone_name_b, one_way )
{
	if ( !IsDefined( one_way ) )
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
	if ( !IsDefined( level.zones[ zone_name_a ].adjacent_zones[ zone_name_b ] ) )
	{
		level.zones[ zone_name_a ].adjacent_zones[ zone_name_b ] = SpawnStruct();
		level.zones[ zone_name_a ].adjacent_zones[ zone_name_b ].is_connected = true;
	}

	if ( !one_way )
	{
		// A becomes an adjacent zone of B
		if ( !IsDefined( level.zones[ zone_name_b ].adjacent_zones[ zone_name_a ] ) )
		{
			level.zones[ zone_name_b ].adjacent_zones[ zone_name_a ] = SpawnStruct();
			level.zones[ zone_name_b ].adjacent_zones[ zone_name_a ].is_connected = true;
		}
	}
}


//--------------------------------------------------------------
//	This one function will handle managing all zones in your map
//	to turn them on/off - probably the best way to handle this
//--------------------------------------------------------------
function manage_zones( initial_zone )
{
	assert( IsDefined( initial_zone ), "You must specify an initial zone to manage" );	

	deactivate_initial_barrier_goals();	// Must be called before zone_init

	zone_choke = 0;
	
	// Lock player respawn points
	//spawn_points = struct::get_array("player_respawn_point", "targetname");
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	
	for( i = 0; i < spawn_points.size; i++ )
	{
		assert( IsDefined( spawn_points[i].script_noteworthy ), "player_respawn_point: You must specify a script noteworthy with the zone name" );
		spawn_points[i].locked = true;
	}

	// Setup zone connections
	if ( IsDefined( level.zone_manager_init_func ) )
	{
		[[ level.zone_manager_init_func ]]();
	}
	
/#	PrintLn( "ZM >> zone_init bbbb  (_zm_zonemgr.gsc) = " + initial_zone.size );	#/

	if ( IsArray( initial_zone ) )
	{
/#	PrintLn( "ZM >> zone_init aaaa  (_zm_zonemgr.gsc) = " + initial_zone[0] );	#/
		for ( i = 0; i < initial_zone.size; i++ )	
		{
			zone_init( initial_zone[i] );
			enable_zone( initial_zone[i] );
		}
	}
	else
	{
/#	PrintLn( "ZM >> zone_init (_zm_zonemgr.gsc) = " + initial_zone );	#/
		zone_init( initial_zone );
		enable_zone( initial_zone );
	}

	setup_zone_flag_waits();

	zkeys = GetArrayKeys( level.zones );
    level.zone_keys = zkeys;
    level.newzones = [];
	for( z=0; z<zkeys.size; z++ )
	{
		level.newzones[ zkeys[z] ] = spawnstruct();
	}
	oldzone = undefined;
	
	level flag::set( "zones_initialized" );

	level flag::wait_till( "begin_spawning" );

	// RAVEN BEGIN bhackbarth: Add thread to display zone info for debugging
	/#
		level thread _debug_zones();
    #/
	// RAVEN END

	// Now iterate through the active zones and see if we need to activate spawners

	while(GetDvarInt( "noclip") == 0 ||GetDvarInt( "notarget") != 0	)
	{
		// clear out active zone flags
		for( z=0; z<zkeys.size; z++ )
		{
			level.newzones[ zkeys[z] ].is_active   = false;
			level.newzones[ zkeys[z] ].is_occupied = false;
		}

		// Figure out which zones are active
		//	If a player occupies a zone, then that zone and any of its enabled adjacent zones will activate
		a_zone_is_active = false;	// let's us know if an active zone is found
		a_zone_is_spawning_allowed = false;	// let's us know if an active zone that allows spawning is found
		level.zone_scanning_active = 1;
		for( z=0; z<zkeys.size; z++ )
		{
			zone = level.zones[ zkeys[z] ];
			newzone = level.newzones[ zkeys[z] ];
			if ( !zone.is_enabled )
			{
				continue;
			}

			if ( isdefined( level.zone_occupied_func ) )
			{
				newzone.is_occupied = [[ level.zone_occupied_func ]]( zkeys[z] );
			}
			else
			{
				newzone.is_occupied = any_player_in_zone( zkeys[z] );
			}
			
			if ( newzone.is_occupied )
			{
				newzone.is_active = true;
				a_zone_is_active = true;
				if ( zone.is_spawning_allowed )
				{
					a_zone_is_spawning_allowed = true;
				}
				
				if( !isdefined( oldzone ) || (oldzone != newzone) )
				{
					level notify( "newzoneActive", zkeys[z] );
					oldzone = newzone;
				}

				azkeys = GetArrayKeys( zone.adjacent_zones );
				for ( az=0; az<zone.adjacent_zones.size; az++ )
				{
					if ( zone.adjacent_zones[ azkeys[az] ].is_connected &&
					     level.zones[ azkeys[az] ].is_enabled )
					{
						//level.zones[ azkeys[ az ] ].is_active = true;
						level.newzones[ azkeys[ az ] ].is_active = true;
						if ( level.zones[ azkeys[ az ] ].is_spawning_allowed )
						{
							a_zone_is_spawning_allowed = true;
						}
					}
				}
			}
			zone_choke++;
			if ( zone_choke >= 3 ) 
			{
				zone_choke=0;
				{wait(.05);}; 
			}
		}
		level.zone_scanning_active = 0;

		for( z=0; z<zkeys.size; z++ )
		{
			level.zones[ zkeys[z] ].is_active   		= level.newzones[ zkeys[z] ].is_active;
			level.zones[ zkeys[z] ].is_occupied 		= level.newzones[ zkeys[z] ].is_occupied;
		}
		
		// MM - Special logic for empty spawner list, this is just a failsafe
		if ( !a_zone_is_active || !a_zone_is_spawning_allowed )
		{
			if ( IsArray( initial_zone ) )
			{
				level.zones[ initial_zone[0] ].is_active = true;
				level.zones[ initial_zone[0] ].is_occupied = true;
				level.zones[ initial_zone[0] ].is_spawning_allowed = true;
			}
			else
			{
				level.zones[ initial_zone ].is_active = true;
				level.zones[ initial_zone ].is_occupied = true;
				level.zones[ initial_zone ].is_spawning_allowed = true;
			}
		}
		
		// Okay now we can re-create the spawner list
		[[ level.create_spawner_list_func ]]( zkeys );

		/#
		debug_show_spawn_locations();
		#/

		level.active_zone_names = zm_zonemgr::get_active_zone_names();

		//wait a second before another check
		wait(1);			
	}
}

//--------------------------------------------------------------
/#
function debug_show_spawn_locations()
{
	if( ( isdefined( level.toggle_show_spawn_locations ) && level.toggle_show_spawn_locations ) )
	{
		host_player = util::GetHostPlayer();
		foreach( location in level.zm_loc_types[ "zombie_location" ] )
		{
			distance = Distance( location.origin, host_player.origin );
			color = (0,0,1);
			if( distance > ( GetDvarInt( "scr_spawner_location_distance" ) * 12 ) )
			{
				color = (1,0,0);
			}
			debugstar( location.origin, GetDvarInt( "scr_spawner_location_time" ), color );
			//Print3d( location.origin, (distance/12), color, 1, 20 );
		}
	}
	
}

#/
//--------------------------------------------------------------
//	This one function will handle managing all zones in your map
//	to turn them on/off - probably the best way to handle this
//--------------------------------------------------------------
function old_manage_zones( initial_zone )
{
	assert( IsDefined( initial_zone ), "You must specify an initial zone to manage" );	

	deactivate_initial_barrier_goals();	// Must be called before zone_init

	// Lock player respawn points
	//spawn_points = struct::get_array("player_respawn_point", "targetname");
	spawn_points = zm_gametype::get_player_spawns_for_gametype();
	
	for( i = 0; i < spawn_points.size; i++ )
	{
		assert( IsDefined( spawn_points[i].script_noteworthy ), "player_respawn_point: You must specify a script noteworthy with the zone name" );
		spawn_points[i].locked = true;
	}

	// Setup zone connections
	if ( IsDefined( level.zone_manager_init_func ) )
	{
		[[ level.zone_manager_init_func ]]();
	}
	
/#	PrintLn( "ZM >> zone_init bbbb  (_zm_zonemgr.gsc) = " + initial_zone.size );	#/

	if ( IsArray( initial_zone ) )
	{
/#	PrintLn( "ZM >> zone_init aaaa  (_zm_zonemgr.gsc) = " + initial_zone[0] );	#/
		for ( i = 0; i < initial_zone.size; i++ )	
		{
			zone_init( initial_zone[i] );
			enable_zone( initial_zone[i] );
		}
	}
	else
	{
/#	PrintLn( "ZM >> zone_init (_zm_zonemgr.gsc) = " + initial_zone );	#/
		zone_init( initial_zone );
		enable_zone( initial_zone );
	}

	setup_zone_flag_waits();

	zkeys = GetArrayKeys( level.zones );
    level.zone_keys = zkeys;
	
	level flag::set( "zones_initialized" );

	level flag::wait_till( "begin_spawning" );

	// RAVEN BEGIN bhackbarth: Add thread to display zone info for debugging
	/#
		level thread _debug_zones();
    #/
	// RAVEN END

	// Now iterate through the active zones and see if we need to activate spawners

	while(GetDvarInt( "noclip") == 0 ||GetDvarInt( "notarget") != 0	)
	{
		// clear out active zone flags
		for( z=0; z<zkeys.size; z++ )
		{
			level.zones[ zkeys[z] ].is_active   = false;
			level.zones[ zkeys[z] ].is_occupied = false;
		}

		// Figure out which zones are active
		//	If a player occupies a zone, then that zone and any of its enabled adjacent zones will activate
		a_zone_is_active = false;	// let's us know if an active zone is found
		a_zone_is_spawning_allowed = false;	// let's us know if an active zone that allows spawning is found
		for( z=0; z<zkeys.size; z++ )
		{
			zone = level.zones[ zkeys[z] ];
			if ( !zone.is_enabled )
			{
				continue;
			}

			if ( isdefined( level.zone_occupied_func ) )
			{
				zone.is_occupied = [[ level.zone_occupied_func ]]( zkeys[z] );
			}
			else
			{
				zone.is_occupied = any_player_in_zone( zkeys[z] );
			}
			
			if ( zone.is_occupied )
			{
				zone.is_active = true;
				a_zone_is_active = true;
				if ( zone.is_spawning_allowed )
				{
					a_zone_is_spawning_allowed = true;
				}

				azkeys = GetArrayKeys( zone.adjacent_zones );
				for ( az=0; az<zone.adjacent_zones.size; az++ )
				{
					if ( zone.adjacent_zones[ azkeys[az] ].is_connected &&
					     level.zones[ azkeys[az] ].is_enabled )
					{
						level.zones[ azkeys[ az ] ].is_active = true;
						if ( level.zones[ azkeys[ az ] ].is_spawning_allowed )
						{
							a_zone_is_spawning_allowed = true;
						}
					}
				}
			}
		}

		// MM - Special logic for empty spawner list, this is just a failsafe
		if ( !a_zone_is_active || !a_zone_is_spawning_allowed )
		{
			if ( IsArray( initial_zone ) )
			{
				level.zones[ initial_zone[0] ].is_active = true;
				level.zones[ initial_zone[0] ].is_occupied = true;
				level.zones[ initial_zone[0] ].is_spawning_allowed = true;
			}
			else
			{
				level.zones[ initial_zone ].is_active = true;
				level.zones[ initial_zone ].is_occupied = true;
				level.zones[ initial_zone ].is_spawning_allowed = true;
			}
		}
		
		// Okay now we can re-create the spawner list
		[[ level.create_spawner_list_func ]]( zkeys );

		level.active_zone_names = zm_zonemgr::get_active_zone_names();

		//wait a second before another check
		wait(1);			
	}
}

//
//	Create the list of enemies to be used for spawning
function create_spawner_list( zkeys )
{
	// Clear the array lists
	foreach( str_index,a_locs in level.zm_loc_types )
	{
		level.zm_loc_types[ str_index ] = [];
	}
	

	for( z=0; z<zkeys.size; z++ )
	{
		zone = level.zones[ zkeys[z] ];

		if ( zone.is_enabled && zone.is_active && zone.is_spawning_allowed )
		{
			foreach( a_locs in zone.a_loc_types )
			{
				foreach( loc in a_locs )
				{
					//	Add the locations
					tokens = StrTok( loc.script_noteworthy, " " );
					foreach ( token in tokens )
					{
						switch( token )
						{
							// Basic zombie spawn locations
							case "spawn_location":
							case "riser_location":
							case "faller_location":
								if ( !isdefined( level.zm_loc_types[ "zombie_location" ] ) ) level.zm_loc_types[ "zombie_location" ] = []; else if ( !IsArray( level.zm_loc_types[ "zombie_location" ] ) ) level.zm_loc_types[ "zombie_location" ] = array( level.zm_loc_types[ "zombie_location" ] ); level.zm_loc_types[ "zombie_location" ][level.zm_loc_types[ "zombie_location" ].size]=loc;;
								break;
							default:
								if ( !isdefined( level.zm_loc_types[ token ] ) )
								{
									level.zm_loc_types[ token ] = [];
								}
								
								if ( !isdefined( level.zm_loc_types[ token ] ) ) level.zm_loc_types[ token ] = []; else if ( !IsArray( level.zm_loc_types[ token ] ) ) level.zm_loc_types[ token ] = array( level.zm_loc_types[ token ] ); level.zm_loc_types[ token ][level.zm_loc_types[ token ].size]=loc;;
						}
					}
				}
			}
		}
	}
}

function get_active_zone_names()
{
	ret_list = [];
	
	if(!isdefined(level.zone_keys))
	{
		return ret_list;
	}
	
	while ( level.zone_scanning_active )
		{wait(.05);};

	for(i = 0; i < level.zone_keys.size; i ++)
	{
		if(level.zones[level.zone_keys[i]].is_active)
		{
			ret_list[ret_list.size] = level.zone_keys[i];
		}
	}
	
	return ret_list;
}

              
// RAVEN BEGIN: bhackbarth  Debug zone info
function _init_debug_zones()
{
	current_y = 30;
	current_x = 20;

	xloc = [];
	xloc[0] = 50;
	xloc[1] = 60;
	xloc[2] = 100;
	xloc[3] = 130;
	xloc[4] = 170;
	xloc[5] = 220;

	zkeys = GetArrayKeys( level.zones );
	for ( i = 0; i < zkeys.size; i++ )
	{
		zoneName = zkeys[i];
		zone = level.zones[zoneName];

		zone.debug_hud = [];
		/#
		for ( j = 0; j < 6; j++ )
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

		if ( i == 40 )
		{
			// Create a second column
			for ( x=0; x < xloc.size; x++ )
			{
				xloc[x] += 350;
			}
			current_y = 30;
		}
		else
		{
			current_y += 10;
		}
		zone.debug_hud[0] SetText(zoneName);
		#/
	}
}

function _destroy_debug_zones()
{
	zkeys = GetArrayKeys( level.zones );
	for ( i = 0; i < zkeys.size; i++ )
	{
		zoneName = zkeys[i];
		zone = level.zones[zoneName];

		for ( j = 0; j < 6; j++ )
		{
			zone.debug_hud[j] Destroy();
			zone.debug_hud[j] = undefined;
		}
	}
}

function _debug_zones()
{
	enabled = false;
	if ( GetDvarString("zombiemode_debug_zones") == "" ) 
	{
		SetDvar("zombiemode_debug_zones", "0");
	}

	while ( true )
	{
		wasEnabled = enabled;
		enabled = GetDvarInt("zombiemode_debug_zones");
		if ( enabled && !wasEnabled )
		{
			_init_debug_zones();
		}
		else if ( !enabled && wasEnabled )
		{
			_destroy_debug_zones();
		}
		
		occupied_zone = undefined;

		if ( enabled )
		{
			zkeys = GetArrayKeys( level.zones );
			for ( i = 0; i < zkeys.size; i++ )
			{
				zoneName = zkeys[i];
				zone = level.zones[zoneName];

				text = zoneName;
				zone.debug_hud[0] SetText(text);

				if ( zone.is_enabled )
				{
					text += " Enabled";
					zone.debug_hud[1] SetText("Enabled");
				}
				else
				{
					zone.debug_hud[1] SetText("");
				}
				if ( zone.is_active ) 
				{
					text += " Active";
					zone.debug_hud[2] SetText("Active");
				}
				else
				{
					zone.debug_hud[2] SetText("");
				}
				if ( zone.is_occupied )
				{
					text += " Occupied";
					zone.debug_hud[3] SetText("Occupied");
					occupied_zone = zone;
				}
				else
				{
					zone.debug_hud[3] SetText("");
				}
				if ( zone.is_spawning_allowed )
				{
					text += " SpawnOK";
					zone.debug_hud[4] SetText("SpawnOK");
				}
				else
				{
					zone.debug_hud[4] SetText("");
				}
				
			/#	
				text += zone.a_loc_types[ "zombie_location" ].size + " spawn";
				zone.debug_hud[5] SetText(zone.a_loc_types[ "zombie_location" ].size + " - " + zone.total_spawn_count + " - " + zone.round_spawn_count );
			#/

			/#	PrintLn( "ZM >> DEBUG=" + text );	#/
			}
		}
		
	/*	if( IsDefined(occupied_zone) )
		{
			//Debug draw spawners being used
			
			//Occupied zone
			
			
			//Adjacent zones
			for( i=0; i<adjacent_zones.size; i++ )
			{
				
			}
		}*/

		//util::wait_network_frame();
		wait( 0.1 );
	}
}
// RAVEN END

