#include maps\_utility;
#include maps\_vehicle;

main()
{
	default_start( ::ride_start );
	add_start( "start", ::ride_start );
	add_start( "wip_start", ::wip_start );

	maps\jeepride_fx::main();
	
	maps\_truck::main( "vehicle_opfor_truck" );
	maps\_uaz::main( "vehicle_uaz_open_for_ride" );
	maps\_blackhawk::main( "vehicle_blackhawk" );
	maps\_luxurysedan::main( "vehicle_luxurysedan_test" );
	maps\_truck::main( "vehicle_pickup_4door" );
	maps\_uaz::main( "vehicle_uaz_open" );	
	maps\createart\jeepride_art::main();
	maps\createfx\jeepride_fx::main();
		
	maps\_load::main();

	array_thread( getvehiclenodearray( "hillbump", "script_noteworthy" ), ::hillbump );
	
	thread getplayersride();
	
	setsaveddvar( "sm_sunSampleSizeNear", 2.0 );

	thread music();
	thread jeepride_start_dumphandle();
	thread end_ride();
	




}

end_ride()
{
	flag_wait( "playersride_init" );
	level.playersride waittill( "reached_end_node" );	
	wait 1;
	level.player unlink();
	thread player_fudge_moveto(( -36031, -15614, 524 ) );
	setsaveddvar( "sm_sunSampleSizeNear", 0.25 );
	
}

getplayersride()
{
	flag_init( "playersride_init" );
	level.playersride = waittill_vehiclespawn( "playersride" );
	flag_set( "playersride_init" );
}


ride_start()
{
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 43 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 44 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 46 );

	//players ride
	thread maps\_vehicle::scripted_spawn( 45 );
	
	flag_wait( "playersride_init" );
	level.playersride.target = "playerspath";
	level.playersride getonpath();
	thread gopath( level.playersride );
	level.player playerlinktodelta( level.playersride, "tag_guy3", .5 );
}

wip_start()
{
	level.syncedvehicles = [];
	maps\scriptgen\jeepride_dumpstart::dumpstart();

	array_thread( getvehiclenodearray( "dumpstart_node", "targetname" ), ::sync_vehicle );
	flag_wait( "playersride_init" );
	level.player playerlinktodelta( level.playersride, "tag_guy3", .5 );
	
}

deleteme()
{
	self delete();
}

hillbump()
{
	//gag script for simulating bumps going down the hill
	self waittill( "trigger", other );
	other notify( "newjolt" );
	other endon( "newjolt" );
	for( i=0;i<12;i++ )
	{
		other joltbody(( other.origin +( 23, 33, 64 ) ), 2 );
		wait .2+randomfloat( .2 );
	}

}

music()
{
//	musicplay( "jeepride_startridemusic" );
}

jeepride_start_dumphandle()
{
	while( 1 )
	{
		while( !level.player buttonpressed( "h" ) )
			wait .05;
		jeepride_start_dump();
		while( level.player buttonpressed( "h" ) )
			wait .05;
	}
}

jeepride_start_dump()
{
	vehicles = getentarray( "script_vehicle", "classname" );
	spawned_vehicles = [];
	for( i=0;i<vehicles.size;i++ )
		if( isdefined( vehicles[ i ].spawner_id ) && isdefined( vehicles[ i ].currentnode ) )
			spawned_vehicles[ spawned_vehicles.size ] = vehicles[ i ];

	/#
	filename = "scriptgen/"+level.script+"_dumpstart.gsc";
	file = openfile( filename, "write" );
/*
#include maps\_utility;
#include maps\_vehicle;
#include maps\jeepride;
*/
	fprintln( file, "#include maps\\jeepride;" );
	fprintln( file, "dumpstart()" );
	fprintln( file, "{" );
		
	count = 0;
	for( i=0;i<spawned_vehicles.size;i++ )
	{
		speed = spawned_vehicles[ i ] getspeedmph();
		angles = spawned_vehicles[ i ].angles;
		origin = spawned_vehicles[ i ].origin;
		currentnode = spawned_vehicles[ i ].currentnode.targetname;
		spawner_id = spawned_vehicles[ i ].spawner_id;
		fprintln( file, "\tbuild_syncedvehicle( "+speed+", "+angles+", "+origin+", \""+currentnode+"\", \""+spawner_id+"\" );" );
	}
	fprintln( file, "}" );
	level.spamed_models = [];
	saved = closefile( file );
	assertex( saved == 1, "File not saved( see above message? ): " + filename );


	filename = "map_source/"+level.script+"_dumpstart.map";
	file = openfile( filename, "write" );
/*
#include maps\_utility;
#include maps\_vehicle;
#include maps\jeepride;
*/
		
	count = 0;
	//blah. compiler doesn't like maps without this info
	fprintln( file, "iwmap 4" );
	fprintln( file, "\"000_Global\" flags  active" );
	fprintln( file, "\"The Map\" flags" ); 
	fprintln( file, "// entity "+count );
	count++;
	fprintln( file, "{" );
	fprintln( file, "\"classname\" \"worldspawn\"" );
	fprintln( file, "}" );

	for( i=0;i<spawned_vehicles.size;i++ )
	{
		
		// entity 5
		/*
		{
		"script_vehicledetour" "31"
		"targetname" "auto11"
		"origin" "16193.1 3131.7 -589.5"
		"classname" "info_vehicle_node"
		"lookahead" "1"
		"script_vehicledetour" "31"
		"speed" "55"
		"spawnflags" "1"
		}
		
		*/
		
		assert( isdefined( spawned_vehicles[ i ].currentnode.target ) );
		target = "dumpstart_node_target_"+i;
		

		fprintln( file, "// entity "+count );
		count++;

		origin = spawned_vehicles[ i ].origin;
		fprintln( file, "{" );
		fprintln( file, "\"origin\" \"" + origintostring( origin )+ "\"" );
		fprintln( file, "\"targetname\" \"dumpstart_node\"" );
		fprintln( file, "\"_color\" \"1.000000 0.000000 0.000000\"" );
		fprintln( file, "\"target\" \"" + target + "\"" );
		fprintln( file, "\"spawner_id\" \"" + spawned_vehicles[ i ].spawner_id + "\"" );
		fprintln( file, "\"classname\" \"info_vehicle_node\"" );
		fprintln( file, "\"lookahead\" \"1\"" ); // todo: see if I can't get the current lookahead value and use that
		fprintln( file, "\"speed\" \"" + spawned_vehicles[ i ] getspeedmph() + "\"" );
		fprintln( file, "}" );

		currentnode = spawned_vehicles[ i ].currentnode.targetname;
		nextnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		
		origin = spawned_vehicles[ i ].origin;
		vect = vectornormalize( nextnode.origin-origin );
		nextorigin = origin+vector_multiply( vect, distance( origin, nextnode.origin )/5 ); 

		fprintln( file, "// entity "+count );
		count++;
		
		
		
		fprintln( file, "{" );
		fprintln( file, "\"origin\" \""+origintostring( nextorigin )+"\"" );
		fprintln( file, "\"targetname\" \""+ target + "\"" );
		fprintln( file, "\"_color\" \"1.000000 0.000000 0.000000\"" );
		fprintln( file, "\"spawner_id\" \"" + spawned_vehicles[ i ].spawner_id + "\"" );
		fprintln( file, "\"classname\" \"info_vehicle_node\"" );
		fprintln( file, "\"script_noteworthy\" \""+nextnode.targetname+"\"" );
		fprintln( file, "\"lookahead\" \"1\"" ); // todo: see if I can't get the current lookahead value and use that
		fprintln( file, "}" );


	}
	level.spamed_models = [];
	saved = closefile( file );
	assertex( saved == 1, "File not saved( see above message? ): " + filename );


	#/

}

origintostring( origin )
{
	string = ""+origin[ 0 ]+" "+origin[ 1 ]+" "+origin[ 2 ]+"";
	return string;
}

sync_vehicle()
{
	
	spawner = level.vehicle_spawners[ self.spawner_id ];
	
	node = self;
	targetnode = getvehiclenode( self.target, "targetname" );
	
	vehicle = vehicle_spawn( spawner );
	vehicle notify( "newpath" );
	vehicle.origin = self.origin;
	vehicle.angles = self.angles;
	vehicle attachpath( node );
	vehicle startpath();
	detournode = getvehiclenode( targetnode.script_noteworthy, "targetname" );
	vehicle setswitchnode( targetnode, detournode );
	vehicle.attachedpath = detournode;
	vehicle thread vehicle_paths();

	
	
}

build_syncedvehicle( speed, angles, origin, currentnode , spawner_id )
{
	struct = spawnstruct();
	struct.speed = speed;
	struct.angles = angles;
	struct.origin = origin;
	struct.currentnode = currentnode;
	struct.spawner_id = spawner_id;
	
	level.syncedvehicles[ spawner_id ] = struct;
}
