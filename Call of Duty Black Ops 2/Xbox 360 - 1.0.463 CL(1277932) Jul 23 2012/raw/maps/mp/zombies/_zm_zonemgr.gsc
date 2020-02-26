#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

#insert raw\common_scripts\utility.gsh;


//
//	This manages which spawners are valid for the game.  The round_spawn function
//	will use the arrays generated to figure out where to spawn a zombie from.
//	
//	Your level will need to set the level.zone_manager_init_func.  This function
//	should specify all of the connections you need to generate for each zone.
//		Ex.:	level.zone_manager_init_func = ::cosmodrome_zone_init;
//	
//	You will also need to call the zone_manager startup function, manage_zones.
//	Pass in an array of starting zone names.
//		Ex.:	init_zones[0] = "start_zone";
//				init_zones[1] = "start_building1_zone";
//				init_zones[2] = "start_building1b_zone";
//				level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );
//
//	The zone_manager_init_func should contain lines such as the following:
//
//		add_adjacent_zone( "start_zone", "start_zone_roof", "start_exit_power" );
//		add_adjacent_zone( "start_zone", "start_zone_roof", "start_exit_power2" );
//		add_adjacent_zone( "start_zone_roof", "north_catwalk_zone", "start_exit_power" );


//
//	Zone Manager initializations
//
init()
{
/#	PrintLn( "ZM >> Zombiemode Server Scripts Init (_zm_zonemgr.gsc)" );	#/
	
	flag_init( "zones_initialized" );

	level.zones = [];
	level.zone_flags = [];

	if ( !IsDefined( level.create_spawner_list_func ) )
	{
		level.create_spawner_list_func = ::create_spawner_list;
	}
}


//
//	Check to see if a zone is enabled
//
zone_is_enabled( zone_name )
{
	if ( !IsDefined(level.zones) ||
		!IsDefined(level.zones[ zone_name ]) ||
		!level.zones[ zone_name ].is_enabled )
	{
		return false;
	}

	return true;
}

//--------------------------------------------------------------
//  Checks to see how many players are in a zone_name volume
//--------------------------------------------------------------
get_players_in_zone( zone_name )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name ) )
	{
		return false;
	}
	zone = level.zones[ zone_name ];

	// Okay check to see if a player is in one of the zone volumes
	num_in_zone = 0;
	players = GET_PLAYERS();
	for (i = 0; i < zone.volumes.size; i++)
	{
		for (j = 0; j < players.size; j++)
		{
			if ( players[j] IsTouching(zone.volumes[i]) )
				num_in_zone++;
		}
	}
	return num_in_zone;
}


//--------------------------------------------------------------
//  Checks to see if a player is in a zone_name volume
//--------------------------------------------------------------
player_in_zone( zone_name )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name ) )
	{
		return false;
	}
	zone = level.zones[ zone_name ];

	// Okay check to see if a player is in one of the zone volumes
	players = GET_PLAYERS();
	for (i = 0; i < zone.volumes.size; i++)
	{
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
//--------------------------------------------------------------
entity_in_zone( zone_name, ignore_enabled_check )
{
	// If the zone hasn't been enabled, don't even bother checking
	if ( !zone_is_enabled( zone_name ) && !is_true(ignore_enabled_check))
	{
		return false;
	}
	zone = level.zones[ zone_name ];

	// Okay check to see if an entity is in one of the zone volumes
	for (i = 0; i < zone.volumes.size; i++)
	{
		if ( self IsTouching( zone.volumes[i] ) )
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
deactivate_initial_barrier_goals()
{
	special_goals = GetStructArray("exterior_goal", "targetname");
	for (i = 0; i < special_goals.size; i++)
	{
		if (IsDefined(special_goals[i].script_noteworthy))
		{
			special_goals[i].is_active = false;
			special_goals[i] trigger_off();
		}
	}
}


//--------------------------------------------------------------
//	Call this when you want to allow zombies to spawn from a zone
//	-	Must have at least one info_volume with targetname = (name of the zone)
//	-	Have the info_volumes target the zone's spawners
//--------------------------------------------------------------
zone_init( zone_name )
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

	if ( IsDefined( zone.volumes[0].target ) )
	{
		spots = getstructarray(zone.volumes[0].target, "targetname");
		zone.spawn_locations = [];
		zone.dog_locations = [];
		zone.screecher_locations = [];
		zone.inert_locations = [];
		zone.quad_locations = [];
		
		for (i = 0; i < spots.size; i++)
		{
			spots[i].zone_name = zone_name;
			spots[i].is_enabled = true;

			// DCS: pull out screecher and dog locations.
			tokens = StrTok( spots[i].script_noteworthy, " " );
			foreach ( token in tokens )
			{
				if ( token == "dog_location" )
				{
					ARRAY_ADD(zone.dog_locations, spots[i]);
				}
				else if( token == "screecher_location" )
				{
					ARRAY_ADD(zone.screecher_locations, spots[i]);
				}
				else if( token == "inert_location" )
				{
					ARRAY_ADD(zone.inert_locations, spots[i]);
				}
				else if( token == "quad_location" )
				{
					ARRAY_ADD(zone.quad_locations, spots[i]);
				}
				else
				{
					ARRAY_ADD(zone.spawn_locations, spots[i]);
				}	
			}
			
			if(IsDefined(spots[i].script_string))
			{
				barricade_id = spots[i].script_string;
				//level.exterior_goals probably not yet defined.
				barricades = getstructarray("exterior_goal","targetname");
				for (k = 0; k < barricades.size; k++)
				{
					if(IsDefined(barricades[k].script_string) && barricades[k].script_string == barricade_id)
					{
						nodes = GetNodeArray(barricades[k].target, "targetname");
						for (j = 0; j < nodes.size; j++)
						{
							if(	IsDefined(nodes[j].type) &&  nodes[j].type == "Begin")
								spots[i].target = nodes[j].targetname;
						}
					}	
				}	
			}			
			
		}
	}	
}

//
// Update the spawners
reinit_zone_spawners()
{
	zkeys = GetArrayKeys( level.zones );
	for ( i = 0; i < level.zones.size; i++ )
	{
		zone = level.zones[ zkeys[i] ];

		if ( IsDefined( zone.volumes[0].target ) )
		{
			spots = getstructarray(zone.volumes[0].target, "targetname");
			zone.spawn_locations = [];
			zone.dog_locations = [];
			zone.screecher_locations = [];
			zone.quad_locations = [];
	
			for (i = 0; i < spots.size; i++)
			{
				spots[i].zone_name = zkeys[i];
				spots[i].is_enabled = true;
			
				// DCS: pull out screecher and dog locations.
				tokens = StrTok( spots[i].script_noteworthy, " " );
				foreach ( token in tokens )
				{
					if ( token == "dog_location" )
					{
						ARRAY_ADD(zone.dog_locations, spots[i]);
					}
					else if( token == "screecher_location" )
					{
						ARRAY_ADD(zone.screecher_locations, spots[i]);
					}
					else if( token == "quad_location" )
					{
						ARRAY_ADD(zone.quad_locations, spots[i]);
					}
					else
					{
						ARRAY_ADD(zone.spawn_locations, spots[i]);
					}	
				}
			}
		}
	}
}


//
//	Turn on the zone
enable_zone( zone_name )
{
	assert( IsDefined(level.zones) && IsDefined(level.zones[zone_name]), "enable_zone: zone has not been initialized" );

	if ( level.zones[ zone_name ].is_enabled )
	{
		return;
	}
	
	level.zones[ zone_name ].is_enabled = true;
	level notify( zone_name );

	// activate any player spawn points
	//spawn_points = GetStructArray("player_respawn_point", "targetname");
	
	spawn_points = maps\mp\gametypes\_zm_gametype::get_player_spawns_for_gametype();
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
	entry_points = GetStructArray(zone_name+"_barriers", "script_noteworthy");
	for(i=0;i<entry_points.size;i++)
	{
		entry_points[i].is_active = true;
		entry_points[i] trigger_on();
	}		
}


//
//	Add zone B to zone A's adjacency list
//
//	main_zone_name - zone to be connected to
//	adj_zone_name - zone to connect
//	flag_name - flag that will cause the connection to happen
make_zone_adjacent( main_zone_name, adj_zone_name, flag_name )
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
add_zone_flags( wait_flag, add_flags )
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
add_adjacent_zone( zone_name_a, zone_name_b, flag_name, one_way )
{
	if ( !IsDefined( one_way ) )
	{
		one_way = false;
	}

	// rsh030110 - added to make sure all our flags are inited before setup_zone_flag_waits()
	if ( !IsDefined( level.flag[ flag_name ] ) )
	{
		flag_init( flag_name );
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
setup_zone_flag_waits()
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
				flags = add_to_array(flags, azone.flags[f], false );
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
zone_flag_wait( flag_name )
{
	if ( !IsDefined( level.flag[ flag_name ] ) )
	{
		flag_init( flag_name );
	}
	flag_wait( flag_name );

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
						if ( flag( azone.flags[f] ) )
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
						if ( !flag( azone.flags[f] ) )
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
					if(flag("door_can_close"))
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
				flag_set( check_flag[k] );
			}
			break;
		}
	}
}

// start thread to watch for door to close.
door_close_disconnect(flag_name)
{
	while(flag(flag_name))
	{
		wait(1.0);
	}
	self.is_connected = false;
	level thread zone_flag_wait( flag_name );
}	
//--------------------------------------------------------------
//	This needs to be called when new zones open up via doors
//--------------------------------------------------------------
connect_zones( zone_name_a, zone_name_b, one_way )
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
manage_zones( initial_zone )
{
	assert( IsDefined( initial_zone ), "You must specify an initial zone to manage" );	

	deactivate_initial_barrier_goals();	// Must be called before zone_init

	// Lock player respawn points
	//spawn_points = GetStructArray("player_respawn_point", "targetname");
	spawn_points = maps\mp\gametypes\_zm_gametype::get_player_spawns_for_gametype();
	
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
	
	flag_set( "zones_initialized" );

	flag_wait( "begin_spawning" );

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
				zone.is_occupied = player_in_zone( zkeys[z] );
			}
			
			if ( zone.is_occupied )
			{
				zone.is_active = true;
				a_zone_is_active = true;
				azkeys = GetArrayKeys( zone.adjacent_zones );
				for ( az=0; az<zone.adjacent_zones.size; az++ )
				{
					if ( zone.adjacent_zones[ azkeys[az] ].is_connected &&
					     level.zones[ azkeys[az] ].is_enabled )
					{
						level.zones[ azkeys[ az ] ].is_active = true;
					}
				}
			}
		}

		// MM - Special logic for empty spawner list, this is just a failsafe
		if ( !a_zone_is_active )
		{
			if ( IsArray( initial_zone ) )
			{
				level.zones[ initial_zone[0] ].is_active = true;
				level.zones[ initial_zone[0] ].is_occupied = true;
			}
			else
			{
				level.zones[ initial_zone ].is_active = true;
				level.zones[ initial_zone ].is_occupied = true;
			}
		}
		
		// Okay now we can re-create the spawner list
		[[ level.create_spawner_list_func ]]( zkeys );

		//wait a second before another check
		wait(1);			
	}
}


//
//	Create the list of enemies to be used for spawning
create_spawner_list( zkeys )
{
	level.zombie_spawn_locations = [];
	level.inert_locations = [];
	level.enemy_dog_locations = [];
	level.zombie_screecher_locations = [];
	level.quad_locations = [];

	for( z=0; z<zkeys.size; z++ )
	{
		
		zone = level.zones[ zkeys[z] ];

		if ( zone.is_enabled && zone.is_active )
		{
			for(i=0;i < zone.spawn_locations.size;i++)
			{
				if ( zone.spawn_locations[i].is_enabled )
				{
					level.zombie_spawn_locations[ level.zombie_spawn_locations.size ] = zone.spawn_locations[i];
				}
			}

			// add inert locations
			for(x=0; x<zone.inert_locations.size; x++)
			{
				if ( zone.inert_locations[x].is_enabled )
				{
					level.inert_locations[ level.inert_locations.size ] = zone.inert_locations[x];
				}
			}

			// add dog_spawn locations
			for(x=0; x<zone.dog_locations.size; x++)
			{
				if ( zone.dog_locations[x].is_enabled )
				{
					level.enemy_dog_locations[ level.enemy_dog_locations.size ] = zone.dog_locations[x];
				}
			}

			// add zombie_screecher locations
			for(x=0; x<zone.screecher_locations.size; x++)
			{
				if ( zone.screecher_locations[x].is_enabled )
				{
					level.zombie_screecher_locations[ level.zombie_screecher_locations.size ] = zone.screecher_locations[x];
				}
			}			

			// add quad locations
			for(x=0; x<zone.quad_locations.size; x++)
			{
				if ( zone.quad_locations[x].is_enabled )
				{
					level.quad_locations[ level.quad_locations.size ] = zone.quad_locations[x];
				}
			}			
		}
	}
}

get_active_zone_names()
{
	ret_list = [];
	
	if(!isdefined(level.zone_keys))
	{
		return ret_list;
	}
	
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
_init_debug_zones()
{
	current_y = 50;
	current_x = 10;

	zkeys = GetArrayKeys( level.zones );
	for ( i = 0; i < zkeys.size; i++ )
	{
		zoneName = zkeys[i];
		zone = level.zones[zoneName];
		zone.debug_hud = NewDebugHudElem();
		zone.debug_hud.alignX = "left";
		zone.debug_hud.x = current_x;
		zone.debug_hud.y = current_y;
		current_y += 10;
		zone.debug_hud SetText(zoneName);
	}
}

_destroy_debug_zones()
{
	zkeys = GetArrayKeys( level.zones );
	for ( i = 0; i < zkeys.size; i++ )
	{
		zoneName = zkeys[i];
		zone = level.zones[zoneName];

		zone.debug_hud Destroy();
		zone.debug_hud = undefined;
	}
}

_debug_zones()
{
	enabled = false;
	if ( GetDvar("zombiemode_debug_zones") == "" ) 
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

		if ( enabled )
		{
			zkeys = GetArrayKeys( level.zones );
			for ( i = 0; i < zkeys.size; i++ )
			{
				zoneName = zkeys[i];
				zone = level.zones[zoneName];

				text = zoneName;
				if ( zone.is_enabled )
				{
					text += " Enabled";
				}
				if ( zone.is_active ) 
				{
					text += " Active";
				}
				if ( zone.is_occupied )
				{
					text += " Occupied";
				}

				zone.debug_hud SetText(text);
			/#	PrintLn( "ZM >> DEBUG=" + text );	#/
			}
		}

		wait_network_frame();
	}
}
// RAVEN END
