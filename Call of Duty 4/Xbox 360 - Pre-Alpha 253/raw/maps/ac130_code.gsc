#include maps\_utility;
#include maps\_ac130;
#include maps\ac130;
precacheLevelStuff()
{
	precacheString( &"AC130_DO_NOT_ENGAGE" );
	precacheString( &"AC130_CHURCH_DAMAGED" );
	precacheString( &"AC130_ESCAPEVEHICLE_DESTROYED" );
	precacheString( &"AC130_HINT_CYCLE_WEAPONS" );
	precacheString( &"AC130_HINT_TOGGLE_THERMAL" );
	precacheString( &"AC130_HINT_ZOOM_AND_FIRE" );
	precacheString( &"AC130_DEBUG_FRIENDLY_COUNT" );
	precacheString( &"AC130_FRIENDLIES_DEAD" );
	precacheString( &"AC130_OBJECTIVE_SUPPORT_FRIENDLIES" );
	precacheShader( "popmenu_bg" );
}

scriptCalls()
{
	//overrides the destrcution FX and tag to be played on
	maps\_vehicle::build_deathfx_override( "luxurysedan", ( "explosions/large_vehicle_explosion_IR" ), "tag_deathfx", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "truck", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "pickup", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "humvee", ( "explosions/large_vehicle_explosion_IR" ), "tag_deathfx", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "bmp", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	
	maps\_truck::main( "vehicle_pickup_roobars" );
	maps\_luxurysedan::main("vehicle_luxurysedan");
	maps\_humvee::main("vehicle_humvee_thermal");
	maps\_bmp::main( "vehicle_bmp_thermal" );
	maps\_camera::main( "vehicle_camera" );
	
	maps\_load::main();
	maps\ac130_snd::main();
	maps\_ac130::init();
	
	civilian_car_riders = getentarray( "civilian_car_rider", "script_noteworthy" );
	array_thread( civilian_car_riders, ::add_spawn_function, ::civilian_car_rider );
	array_thread( getentarray( "damage_church", "targetname" ), ::damage_church );
}

missionEnd( endLevel )
{
	iprintlnbold( "End of currently scripted level" );
	if ( isdefined( endLevel ) && ( endLevel ) )
	{
		wait 6;
		missionSuccess( "armada", false );
	}
}

spawn_enemies( sTrigger_Noteworthy )
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	// notifies a trigger so that it's targeted spawners spawn
	assert( isdefined( sTrigger_Noteworthy ) );
	spawn_trigger = getent( sTrigger_Noteworthy, "script_noteworthy" );
	assert( isdefined( spawn_trigger ) );
	spawn_trigger notify( "trigger" );
}

stop_enemies( sTrigger_Noteworthy )
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	// grabs the killspawner value and kills that spawn group
	assert( isdefined( sTrigger_Noteworthy ) );
	spawn_trigger = getent( sTrigger_Noteworthy, "script_noteworthy" );
	assert( isdefined( spawn_trigger ) );
	assert( isdefined( spawn_trigger.script_killspawner_group ) );
	thread maps\_spawner::kill_spawnerNum( spawn_trigger.script_killspawner_group );
}

spawn_friendlies( sTargetname )
{
	spawnerArray = getentarray( sTargetname, "targetname" );
	assert( spawnerArray.size == 8 );
	level.friendlies = [];
	for( i = 0 ; i < spawnerArray.size ; i++ )
	{
		guy = spawnerArray[i] stalingradSpawn();
		if (!spawn_failed(guy))
			level.friendlies[level.friendlies.size] = guy;
	}
	array_thread( level.friendlies, ::friendly_health_init );
	array_thread( level.friendlies, ::mission_fail_casualties );
	array_thread( level.friendlies, ::debug_friendly_count );
	array_thread( level.friendlies, ::add_beacon_effect );
}

spawn_vehicle( sTrigger_Targetname )
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	// notifies a trigger so that it's targeted spawners spawn
	assert( isdefined( sTrigger_Targetname ) );
	spawn_trigger = getent( sTrigger_Targetname, "targetname" );
	assert( isdefined( spawn_trigger ) );
	spawn_trigger notify( "trigger" );
}

move_friendlies( sTrigger_Targetname )
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	assert( isdefined( sTrigger_Targetname ) );
	color_node_trigger = getent( sTrigger_Targetname, "targetname" );
	assert( isdefined( color_node_trigger ) );
	color_node_trigger notify( "trigger" );
}

ambiant_civilian_vehicles( vehGroupNum )
{
	for(;;)
	{
		vehicleArray = undefined;
		vehicleArray = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( vehGroupNum );
		assert( isdefined( vehicleArray ) );
		assert( vehicleArray.size == 1 );
		vehicleArray[ 0 ] thread ambiant_civilian_vehicles_death();
		wait ( 3 + randomfloat( 5 ) );
	}
}

ambiant_civilian_vehicles_death()
{
	self endon( "deleteme" );
	while( ( isdefined( self ) ) && ( isAlive( self ) ) )
	{
		self waittill( "damage", amount, attacker );
		if ( attacker != level.player )
			continue;
		iprintlnbold( "YOU ATTACKED A CIVILIAN VEHICLE!" );
		break;
	}
}

damage_church()
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	for (;;)
	{
		self waittill ( "damage", damage, attacker );
		if ( ( attacker == level.player ) & ( damage > 200 ) )
			break;
	}
	
	if ( !flag( "mission_failed" ) )
		thread missionFail_church();
}

missionFail_church()
{
	flag_set( "mission_failed" );
	setdvar( "ui_deadquote", "@AC130_CHURCH_DAMAGED" );
	maps\_utility::missionFailedWrapper();
}

hintPrint( string )
{
	hint = hint_create( string, true );
	wait level.hintPrintDuration;
	hint hint_delete();
}

getEnemiesInZone( sZoneTargetname )
{
	zone = getent( sZoneTargetname, "targetname" );
	axis = getaiarray( "axis" );
	zoneGuys = [];
	for( i = 0 ; i < axis.size ; i++ )
	{
		if ( !axis[ i ] isTouching( zone ) )
			continue;
		zoneGuys[ zoneGuys.size ] = axis[ i ];
	}
	return zoneGuys;
}

civilian_car_rider()
{
	self endon( "death" );
	self gun_remove();
	self.ignoreme = true;
	self.ignoreall = true;
	self.maxsightdistsqrd = 0;
	self.ignoresuppression = true;
	self thread ignoreAllEnemies( true );
	self waittill( "goal" );
	self delete();
}


/*
waittill_aiAndSpawners_dead( guys, timeoutLength )
{
	ent = spawnStruct();
	ent endon( "timeout" );
	
	if ( isdefined( timeoutLength ) )
		thread waittill_aiAndSpawners_dead_timeout( ent, timeoutLength );
	
	ent.count = guys.size;
	array_thread(guys, ::waittill_aiAndSpawners_dead_thread, ent);
	
	while ( ent.count > 0 )
		ent waittill ( "waittill_dead guy died" );
}

waittill_aiAndSpawners_dead_timeout( struct, timeoutLength )
{
	assert( timeoutLength > 0 );
	wait timeoutLength;
	struct notify( "timeout" );
}

waittill_aiAndSpawners_dead_thread( ent )
{
	if ( !isalive( self ) )	//a spawner so wait for it to spawn
	{
		self endon ( "spawn_failed" );
		while( self.count > 0 )
		{
			self thread waittill_aiAndSpawners_dead_spawnfailed_thread( ent );
			self waittill ( "spawned", guy );
			if ( !spawn_failed( guy ) )
				guy waittill ( "death" );
		}
	}
	else
	{
		guy = self;
		if ( !spawn_failed( guy ) )
			guy waittill ( "death" );
	}
	
	ent.count--;
	ent notify ( "waittill_dead guy died" );
}

waittill_aiAndSpawners_dead_spawnfailed_thread( ent )
{
	self endon ( "spawned" );
	
	self waittill ( "spawn_failed" );
	
	ent.count--;
	ent notify ( "waittill_dead guy died" );
}
*/
/*
ac130_flightinfo()
{
	level.ac130.origin = getent( "ac130_startingposition", "targetname" ).origin;
	level.ac130.angles = ( level.ac130.angles[0], 120, level.ac130.angles[2] );
	
	thread rotatePlane( "off" );
	thread movePlaneToPoint( getent( "ac130_encounter1", "targetname" ).origin );
	level waittill( "ac130_almost_at_destination" );
	thread rotatePlane( "on" );
	thread ac130_move_in();
	flag_wait( "ac130_moveto_second_enounter" );
	wait 10;
	movePlaneToPoint( getent( "ac130_encounter2", "targetname" ).origin );
}
*/
/*
friends_mount_humvees()
{
	friends = getaiarray( "allies" );
	
	guys_veh1 = [];
	guys_veh2 = [];
	alternate = 0;
	for( i = 0 ; i < friends.size ; i++ )
	{
		if ( alternate == 0 )
		{
			guys_veh1[guys_veh1.size] = friends[i];
			alternate = 1;
		}
		else
		{
			guys_veh2[guys_veh2.size] = friends[i];
			alternate = 0;
		}
	}
	
	thread friends_mount_humvees_vehicle1( guys_veh1, true );
	thread friends_mount_humvees_vehicle2( guys_veh2, true );
	
	flag_wait( "getaway_vehicle_1 loaded" );
	flag_wait( "getaway_vehicle_2 loaded" );
	flag_set( "humvees_loaded" );
	
	thread autosave_by_name( "humvees_loaded" );
	
	//start the humvees down the road with the friendlies in them now
	
	getaway_vehicle_1 = undefined;
	getaway_vehicle_1 = getent( "getaway_vehicle_1", "targetname" );
	assert( isdefined( getaway_vehicle_1 ) );
	
	getaway_vehicle_2 = undefined;
	getaway_vehicle_2 = getent( "getaway_vehicle_2", "targetname" );
	assert( isdefined( getaway_vehicle_2 ) );
	
	path1 = getvehiclenode( "getaway_vehicle_1_node2", "targetname" );
	assert( isdefined( path1 ) );
	
	path2 = getvehiclenode( "getaway_vehicle_2_node2", "targetname" );
	assert( isdefined( path2 ) );
	
	getaway_vehicle_1 attachPath( path1 );
	getaway_vehicle_1 startPath();
	
	getaway_vehicle_2 attachPath( path2 );
	getaway_vehicle_2 startPath();
	
	
	
	
	//BEFORE TUNNEL
	thread before_tunnel_spawners_dead();
	getent( "roadblock_before_tunnel_spawner_trigger", "script_noteworthy" ) notify ( "trigger" );
	thread movePlaneBeforeTunnel();
	thread ac130_move_out();
	if ( !flag( "tunnel_entrance_cleared" ) )
	{	
		thread before_tunnel_tank_think();
		getent( "before_tunnel_tank_trigger", "targetname" ) notify ( "trigger" );
		
		getent( "stop_humvees_before_roadblock_town", "targetname" ) waittill ( "trigger" );
		getaway_vehicle_1 setSpeed( 0, 10 );
		getaway_vehicle_2 setSpeed( 0, 10 );
		wait 2;
		getaway_vehicle_1 notify ( "unload" );
		getaway_vehicle_2 notify ( "unload" );
		flag_clear( "getaway_vehicle_1 loaded" );
		flag_clear( "getaway_vehicle_2 loaded" );
		
		flag_wait( "tunnel_entrance_cleared" );
		
		thread friends_mount_humvees_vehicle1( guys_veh1 );
		thread friends_mount_humvees_vehicle2( guys_veh2 );
		flag_wait( "getaway_vehicle_1 loaded" );
		flag_wait( "getaway_vehicle_2 loaded" );
		getaway_vehicle_1 resumeSpeed( 100 );
		getaway_vehicle_2 resumeSpeed( 100 );
		
		thread autosave_by_name( "tunnel_entrance_clear" );
	}
	
	
	
	
	
	
	//AFTER TUNNEL
	thread tunnel_spawners_dead();
	getent( "tunnel_spawners_trigger", "script_noteworthy" ) notify ( "trigger" );
	thread movePlaneToPoint( getent( "ac130_tunnel_exit", "targetname" ).origin );
	
	if ( !flag( "tunnel_cleared" ) )
	{
		getent( "vehicle_tunnel_trigger", "targetname" ) waittill ( "trigger" );
		getaway_vehicle_1 setSpeed( 0, 100 );
		getaway_vehicle_2 setSpeed( 0, 100 );
		
		flag_wait( "tunnel_cleared" );
		
		getaway_vehicle_1 resumeSpeed( 100 );
		getaway_vehicle_2 resumeSpeed( 100 );
		
		thread autosave_by_name( "tunnel_exit_clear" );
	}
	
	
	
	
	
	
	//END OF VEHICLE RIDE
	getaway_vehicle_1 thread getaway_vehicle_1_endpath();
	getaway_vehicle_2 thread getaway_vehicle_2_endpath();
	
	
	//START THE JUNKYARD SECTION
	thread start_junkyard_section();
	
	flag_wait( "getaway_vehicle_1_endpath" );
	flag_wait( "getaway_vehicle_2_endpath" );
	getaway_vehicle_1 notify ( "unload" );
	getaway_vehicle_2 notify ( "unload" );
	
	moveFriendlies( "friendlychain_junkyard_a" );
}
*/
/*
friends_mount_humvees_vehicle1( guys, waitForEndNode )
{
	if ( !isdefined( waitForEndNode ) )
		waitForEndNode = false;
	
	getaway_vehicle_1 = undefined;
	getaway_vehicle_1 = getent( "getaway_vehicle_1", "targetname" );
	if (!isdefined(getaway_vehicle_1))
		getaway_vehicle_1 = maps\_vehicle::waittill_vehiclespawn( "getaway_vehicle_1" );
	
	if ( waitForEndNode )
		getaway_vehicle_1 waittill ( "reached_end_node" );
	
	trio = [];
	for( i = 0 ; i < guys.size ; i++ )
	{
		if ( !isdefined( guys[i] ) )
			continue;
		if ( !isalive( guys[i] ) )
			continue;
		trio[trio.size] = guys[i];
	}
	
	array_thread( trio, ::ignoreAllEnemies, true );
	
	getaway_vehicle_1 notify ( "load", trio );
	getaway_vehicle_1 waittill ( "loaded" );
	flag_set( "getaway_vehicle_1 loaded" );
	
	array_thread( trio, ::ignoreAllEnemies, false );
}

friends_mount_humvees_vehicle2( guys, waitForEndNode  )
{
	if ( !isdefined( waitForEndNode ) )
		waitForEndNode = false;
	
	getaway_vehicle_2 = undefined;
	getaway_vehicle_2 = getent( "getaway_vehicle_2", "targetname" );
	if (!isdefined(getaway_vehicle_2))
		getaway_vehicle_2 = maps\_vehicle::waittill_vehiclespawn( "getaway_vehicle_2" );
	
	if ( waitForEndNode )
		getaway_vehicle_2 waittill ( "reached_end_node" );
	
	trio = [];
	for( i = 0 ; i < guys.size ; i++ )
	{
		if ( !isdefined( guys[i] ) )
			continue;
		if ( !isalive( guys[i] ) )
			continue;
		trio[trio.size] = guys[i];
	}
	
	array_thread( trio, ::ignoreAllEnemies, true );
	
	getaway_vehicle_2 notify ( "load", trio );
	getaway_vehicle_2 waittill ( "loaded" );
	flag_set( "getaway_vehicle_2 loaded" );
	
	array_thread( trio, ::ignoreAllEnemies, false );
}
*/