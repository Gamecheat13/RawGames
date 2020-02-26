#include maps\_utility;
#include maps\_utility_code;
#include maps\_vehicle;


main()
{
	
	level.sparkclaimed = false;
	array_thread( getentarray( "ghetto_tag", "targetname" ), ::ghetto_tag );
	array_thread( getentarray( "ghetto_tag", "targetname" ), ::ghetto_tag_ref_clear );
	array_thread( getvehiclenodearray( "sparks_on", "script_noteworthy" ), ::trigger_sparks_on );
	array_thread( getvehiclenodearray( "sparks_off", "script_noteworthy" ), ::trigger_sparks_off );
	array_thread( getentarray( "fliptruck_ghettoanimate", "targetname" ), ::fliptruck_ghettoanimate );
	
	
	array_levelthread( getentarray( "delete_on_load", "targetname" ), ::deleteEnt );
	array_levelthread( getentarray( "delete_on_load", "target" ), ::deleteEnt );

	default_start( ::ride_start );
	add_start( "start", ::ride_start );
	add_start( "wip_start", ::wip_start );

	
	maps\jeepride_fx::main();
	
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
	//fancy override for some _bm21 stuff
	build_aianims( ::bm21_overrides,maps\_bm21_troops::set_vehicle_anims );
	
	
	maps\_truck::main( "vehicle_opfor_truck" );
	maps\_uaz::main( "vehicle_uaz_open_for_ride" );
	maps\_blackhawk::main( "vehicle_blackhawk" );
	maps\_luxurysedan::main( "vehicle_luxurysedan_test" );
	maps\_truck::main( "vehicle_pickup_4door" );
	maps\_uaz::main( "vehicle_uaz_open" );	
	maps\createart\jeepride_art::main();
	maps\createfx\jeepride_fx::main();
		
	maps\_load::main();
	
	level.player allowstand( false );
	level.player allowprone( false );

 // 	array_thread( getvehiclenodearray( "view_magnet", "script_noteworthy" ), ::view_magnet );
	array_thread( getvehiclenodearray( "hillbump", "script_noteworthy" ), ::hillbump );
	array_thread( getvehiclenodearray( "sideswipe", "script_noteworthy" ), ::sideswipe );
	
	thread getplayersride();
	
	setsaveddvar( "sm_sunSampleSizeNear", 2.0 );

	thread pausevehicles();
	thread music();
	thread jeepride_start_dumphandle();
	thread end_ride();
	thread time_triggers();

}

#using_animtree( "generic_human" );   

bm21_overrides( )
{
	positions =	maps\_bm21_troops::setanims();
	
	positions[ 0 ].idle = %bm21_driver_idle;
	positions[ 1 ].idle = %bm21_passenger_idle;
	positions[ 2 ].idle = undefined;
	positions[ 3 ].idle = undefined;
	positions[ 4 ].idle = undefined;
	positions[ 5 ].idle = undefined;
	positions[ 6 ].idle = undefined;
	positions[ 7 ].idle = undefined;
	positions[ 8 ].idle = undefined;
	positions[ 9 ].idle = undefined;

	return positions;
}

end_ride()
{	
	flag_wait( "playersride_init" );
	level.playersride waittill( "reached_end_node" );	
	wait 1;
	level.player unlink();
	thread player_fudge_moveto( ( - 36031, -15614, 524 ) );
	level.player allowstand( true );
	level.player allowprone( true );

	setsaveddvar( "sm_sunSampleSizeNear", 0.25 );
	
}

getplayersride()
{
	flag_init( "playersride_init" );
	level.playersride = waittill_vehiclespawn( "playersride" );
	level.playersride godon();
	flag_set( "playersride_init" );
}


ride_start()
{
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 43 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 44 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 46 );

	 // players ride
	thread maps\_vehicle::scripted_spawn( 45 );
	
	flag_wait( "playersride_init" );
	level.playersride.target = "playerspath";
	level.playersride getonpath();
	thread gopath( level.playersride );
	player_link();
}

wip_start()
{
	array_thread( getvehiclenodearray( "dumpstart_node", "targetname" ), ::sync_vehicle );
	flag_wait( "playersride_init" );
	player_link();
	
}

player_link()
{
	level.player playerlinkto( level.playersride, "tag_guy3", .5 );
}

deleteme()
{
	self delete();
}

sideswipe()
{
	 // sideswipes from other cars to players car bumping 
	self waittill( "trigger", other );

	other notify( "newjolt" );
	level.playersride notify( "newjolt" );

	other endon( "newjolt" );
	level.playersride endon( "newjolt" );
	
	other joltbody( ( level.playersride.origin + ( 0, 0, 64 ) ), 4 );
	level.playersride joltbody( ( other.origin + ( 0, 0, 64 ) ), 4 );
}
hillbump()
{
	 // gag script for simulating bumps going down the hill
	self waittill( "trigger", other );
	other notify( "newjolt" );
	other endon( "newjolt" );
	for( i = 0;i < 12;i ++ )
	{
		other joltbody( ( other.origin + ( 23, 33, 64 ) ), 2 );
		wait .2 + randomfloat( .2 );
	}

}

music()
{
	musicplay( "jeepride_chase_music" );
}

jeepride_start_dumphandle()
{
	button1 = "h";
	button2 = "CTRL";
	while( 1 )
	{
		while( ! twobuttonspressed( button1, button2 )  )
			wait .05;
			while( !jeepride_start_dump() )
				wait.05;
		while( twobuttonspressed( button1, button2 ) )
			wait .05;
	}
}

get_vehicles_with_spawners()
{
	vehicles = getentarray( "script_vehicle", "classname" );
	spawned_vehicles = [];
	for( i = 0;i < vehicles.size;i ++ )
		if( isdefined( vehicles[ i ].spawner_id ) && isdefined( vehicles[ i ].currentnode ) )
			spawned_vehicles[ spawned_vehicles.size ] = vehicles[ i ];
	return spawned_vehicles;		
}

jeepride_start_dump()
{

 /#
	spawned_vehicles = get_vehicles_with_spawners();


	for( i = 0;i < spawned_vehicles.size;i ++ )
	{
		if( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue; // this vehicle is at the end of its path and doesn't really need to be in the quickload.
		targetnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		if( !isdefined( targetnode ) )
			continue;
		if( isdefined( targetnode.detoured ) )
			return false;
	}	
	 // starts a map with a header and a blank worldspawn
	fileprint_map_start( level.script + "_dumpstart" );
	 
	for( i = 0;i < spawned_vehicles.size;i ++ )
	{
		if( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue; // this vehicle is at the end of its path and doesn't really need to be in the quickload.

		target = "dumpstart_node_target_" + i;
		 // vectors print as( 0, 0, 0 ) where they need to be converted to "0 0 0" for radiant to know what's up
		origin = fileprint_radiant_vec( spawned_vehicles[ i ].origin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();

			if( i == 0 )
				fileprint_map_keypairprint( "script_delay", gettime() / 1000.0  );
			fileprint_map_keypairprint( "spawnflags", "1" );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", "dumpstart_node" );
			fileprint_map_keypairprint( "_color", "1.000000 0.000000 0.000000" );
			fileprint_map_keypairprint( "target", target );
			fileprint_map_keypairprint( "spawner_id", spawned_vehicles[ i ].spawner_id );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			if( isdefined( spawned_vehicles[ i ].ghettotags ) )
				fileprint_map_keypairprint( "script_ghettotag", "1" );
			fileprint_map_keypairprint( "lookahead", ".2" ); // static lookahead for the short duration of the path shouldn't put it too out of sync
			fileprint_map_keypairprint( "speed", spawned_vehicles[ i ] getspeedmph() );

		fileprint_map_entity_end();


		 // project a node towards the next node in the chain for an onramp
		if( isdefined( spawned_vehicles[ i ].detouringpath ) )
			nextnode = spawned_vehicles[ i ].detouringpath;
		else
			nextnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		origin = spawned_vehicles[ i ].origin;
		vect = vectornormalize( nextnode.origin - origin );
		nextorigin = origin + vector_multiply( vect, distance( origin, nextnode.origin ) / 5 ); 
 // 		nextorigin = nextnode.origin; 

		origin = fileprint_radiant_vec( nextorigin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();
		
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", target );
			fileprint_map_keypairprint( "_color", "1.000000 0.000000 0.000000" );
			 // fileprint_map_keypairprint( "spawner_id", spawned_vehicles[ i ].spawner_id );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			fileprint_map_keypairprint( "script_noteworthy", nextnode.targetname );

		fileprint_map_entity_end();
		
	}
	fileprint_end();
#/ 
	jeepride_vehicle_dump();
	iprintlnbold( "wip_start dumped!" );
	return true;


}

origintostring( origin )
{
	string = "" + origin[ 0 ] + " " + origin[ 1 ] + " " + origin[ 2 ] + "";
	return string;
}

sync_vehicle()
{
	
	
	spawner = level.vehicle_spawners[ self.spawner_id ];
	
	node = self;
	targetnode = getvehiclenode( self.target, "targetname" );
	
	vehicle = vehicle_spawn( spawner );

	vehicle notify( "newpath" );
	vehicle.origin = self.origin + ( 0, 0, 555 );
	vehicle.angles = self.angles;
	vehicle attachpath( node );
	vehicle startpath();
	if( isdefined( node.script_ghettotag ))
		vehicle apply_ghettotag();
	if( isdefined( node.script_delay ) )
		level.startdelay = node.script_delay;
	detournode = getvehiclenode( targetnode.script_noteworthy, "targetname" );
	vehicle setswitchnode( targetnode, detournode );
	vehicle.attachedpath = detournode;
	vehicle thread vehicle_paths();
	
	
}


build_syncedvehicle( speed, angles, origin, currentnode, spawner_id )
{
	struct = spawnstruct();
	struct.speed = speed;
	struct.angles = angles;
	struct.origin = origin;
	struct.currentnode = currentnode;
	struct.spawner_id = spawner_id;
	
	level.syncedvehicles[ spawner_id ] = struct;
}

twobuttonspressed( button1, button2 )
{
		return level.player buttonpressed( button1 ) && level.player buttonpressed( button2 );
}

pausevehicles()
{
	button1 = "r";
	button2 = "CTRL";
	while( 1 )
	{
		while( !twobuttonspressed( button1, button2 ) )
			wait .05;
		array_thread( getentarray( "script_vehicle", "classname" ), ::pausevehicle );
		jeepride_vehicle_dump();
		while( twobuttonspressed( button1, button2 ) )
			wait .05;
		while( !twobuttonspressed( button1, button2 ) )
			wait .05;
		array_thread( getentarray( "script_vehicle", "classname" ), ::unpausevehicle );
		while( twobuttonspressed( button1, button2 ) )
			wait .05;
	}	
}

pausevehicle()
{
	self.speedbeforepause = self getspeedmph();
	self setspeed( 0, 600 );
}

unpausevehicle()
{
	self.speedbeforepause = undefined;
	self resumespeed( 5000 );
}


jeepride_vehicle_dump()
{
 /#
	
	 // starts a map with the necessary blank layer info and a blank worldspawn.  
	 // Throught he magic of junction this file ends up in "map_source\xenon_export\jeepride_veh_ref.map"  
	 // I keep the directory structure somewhat flat because permissions in winnt is painful when dealing with the xenonremote share stuff. 
	 // junction.bat keeps it in check
	 
	 // this simple script exports all of the vehicles as script models that have a delete_on_load targetname
	 
	vehicles = getentarray( "script_vehicle", "classname" );
	fileprint_map_start( level.script + "_veh_ref" );
	for( i = 0;i < vehicles.size;i ++ )
	{
		origin = fileprint_radiant_vec( vehicles[ i ].origin );  // convert these vectors to mapfile keypair format
		angles = fileprint_radiant_vec( vehicles[ i ].angles );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "classname", "script_model" );
			fileprint_map_keypairprint( "model", vehicles[ i ].model );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "angles", angles );
			if( vehicles[ i ] == level.playersride )
				fileprint_map_keypairprint( "target", "delete_on_load" ); // _load deletes these.
			else
				fileprint_map_keypairprint( "targetname", "delete_on_load" ); // _load deletes these.
				
			if( isdefined( vehicles[ i ].speedbeforepause ) )
			fileprint_map_keypairprint( "current_speed", vehicles[ i ].speedbeforepause );
			if( isdefined( vehicles[ i ].lastnodespeed ) )
				fileprint_map_keypairprint( "last_node_speed", vehicles[ i ].lastnodespeed );
			if( isdefined( vehicles[ i ].script_vehiclespawngroup ) )
				fileprint_map_keypairprint( "script_vehiclespawngroup", vehicles[ i ].script_vehiclespawngroup );
			if( isdefined( vehicles[ i ].script_vehiclestartmove ) )
				fileprint_map_keypairprint( "script_vehiclestartmove", vehicles[ i ].script_vehiclestartmove );
		fileprint_map_entity_end();

	}

	fileprint_end();
#/ 

}


magnet_endon()
{
	level waittill( "new_magnet" );
	self delete();
}

view_magnet()
{
		org_ent = spawn( "script_origin", level.player.origin );
		self waittill( "trigger", other );
		level notify( "new_magnet" );
		level endon( "new_magnet" );
		org_ent thread magnet_endon();
		
		org_ent.origin = level.player geteye();
		org_ent.angles = level.player getplayerangles();
		
		dest_angle = vectortoangles( vectornormalize( ( other.origin + ( 0, 0, 48 ) ) - org_ent.origin ) );
		
		waittime = .5;
		org_ent rotateto( dest_angle, waittime, .2, .2 );


		incs = int( waittime / .05 );	
		for( i = 0 ; i < incs ; i ++ )
		{
				level.player setplayerangles( org_ent.angles );
				wait .05;
 // 				if( level.player attackbuttonpressed() )
 // 					break;
		}
	
}

time_triggers()
{
	waittillframeend;
	waittillframeend;
	 // since paths are linear and done the same I'm going to try to do a lot of things based on the time in the level
	 // ( seen by getttime() / 1000 in the debugger )
	 
	if( !isdefined( level.startdelay ) )
		level.startdelay = 0;
	thread delaythread_loc( 65, ::endprint );
	
	
	
}

delaythread_loc( delay, sthread )
{
		if( level.startdelay > delay )
			return;  // this event has passed in the wip_start start point.
		delaythread( delay - level.startdelay, sthread );
}

endprint()
{
	iprintlnbold( "End of currently scripted level" );
}







ghetto_tag()
{
		if( !isdefined( level.ghettotag ) )
			level.ghettotag = [];
		target = getent( self.target, "targetname" );
		assert( isdefined( target ) );
		assert( isdefined( target.model ) );
		if( !isdefined( level.ghettotag[ target.model ] ) )
			level.ghettotag[ target.model ] = [];
		level.ghettotag[ target.model ][ level.ghettotag[ target.model ].size ] = ghetto_tag_create( target );
		
}

ghetto_tag_ref_clear()
{
	target = getent( self.target, "targetname" );
	if( isdefined( target ) )
		target delete();
	self delete();	
}

ghetto_tag_create( target )
{
		struct = spawnstruct();
		struct.origin = self.origin - target gettagorigin( "tag_body" );
		struct.angles = self.angles - target gettagangles( "tag_body" );
		struct.model = self.model;
		return struct;
}

trigger_sparks_on()
{
	while( 1 )
	{
		self waittill( "trigger", other );
		other thread apply_ghettotag();
			
	}
}

trigger_sparks_off()
{
	while( 1 )
	{
		self waittill( "trigger", other );
		other thread remove_ghettotag();
			
	}
}

remove_ghettotag()
{
	if( !isdefined( self.ghettotags ) )
		return;
	array_thread( self.ghettotags, ::deleteme );
	self.ghettotags = [];
}

apply_ghettotag()
{
	if( !isdefined( level.ghettotag ) || !isdefined( level.ghettotag[ self.model ] ) )
		return;
	self.ghettotags = [];
	ghettotags = level.ghettotag[ self.model ];
	for( i = 0 ; i < ghettotags.size ; i ++ )
	{
		model = spawn( "script_model", self.origin );
		model setmodel( ghettotags[ i ].model );
		model hide();
 // 		origin = self localtoworldcoords( ghettotags[ i ].origin );
 // 		angles = self.angles + ghettotags[ i ].angles;
		model linkto( self, "tag_body", ghettotags[ i ].origin, ghettotags[ i ].angles );
		model.linkedobj = self;
		self.ghettotags[ self.ghettotags.size ] = model; // todo create special string value of these.
		model thread tempfx();
	}
}

tempfx()
{
	self endon( "death" );
	self.linkedobj endon( "death" );
	delaytime = .05;
	while( 1 )
	{
		org1 = self.origin;
		org2 = self.origin + vector_multiply( anglestoup( self.angles ), 8 );
 // 		line( org1, org2, ( 0, 1, 1 ), 0, int( .05 / delaytime ) );
		trace = bullettrace( org1, org2, false, self.linkedobj );
		if( trace[ "fraction" ] < 1 )
		{
			spark = getspark();
			playfxontag( spark, self, "polySurface1" );
		}
		wait delaytime;
	}	
}

getspark()
{
	if( level.sparkclaimed )
		return level._effect[ "tunnelspark" ];
	else
	{
		thread claimspark();
		return level._effect[ "tunnelspark_dl" ];
	}
}

claimspark()
{
	level.sparkclaimed = true;
	wait .2;
	level.sparkclaimed = false;
}


fliptruck_ghettoanimate()
{
	
	throwchain = setup_throwchain( self );
	
	assert( isdefined( throwchain[ 0 ].vehiclenode ) );
	vehiclenode = throwchain[ 0 ].vehiclenode;
	previous_vehiclenode = getvehiclenode( vehiclenode.targetname, "target" );
	assert( isdefined( previous_vehiclenode ) );
	previous_vehiclenode waittill( "trigger", truck );
	time = gettime();
	prevorg = truck.origin;
	vehiclenode waittill( "trigger", truck );
	timediff = ( gettime() - time ) / 1000;
	dist = distance( prevorg, truck.origin );
	rate = dist / timediff;

	dummy = truck maps\_vehicle::vehicle_to_dummy();
	
	array_thread(truck.riders, ::killthrow );
	for( i = 0 ; i < throwchain.size - 1 ; i ++ )
	{
		org = throwchain[ i ];
		dest = throwchain[ i + 1 ];
		if( isdefined( org.speed ) )
			rate = org.speed;
 // 	dummy movewithrate( dest.origin, dest.angles, org.speed );
		dummy movewithrate( dest.origin, dest.angles, rate );
	}
	truck remove_ghettotag();
	
}

killthrow()
{
	self dodamage( 8000, self.origin ); 
}

setup_throwchain( pathpoint )
{
	arraycount = 0;
	pathpoints = [];
	chain = [];
	speed = 200;
	while( isdefined( pathpoint ) )
	{
		struct = spawnstruct();
		struct.origin = pathpoint.origin;
		struct.angles = pathpoint.angles;
		if( isdefined( pathpoint.speed ) )
			struct.speed = pathpoint.speed;
		chain[ arraycount ] = pathpoint; 
		pathpoints[ arraycount ] = struct; 
		arraycount ++ ; 

		if( isdefined( pathpoint.target ) )
			pathpoint = getent( pathpoint.target, "targetname" );
		else
			break; 
	}
	pathpoints[ 0 ].vehiclenode = getvehiclenode( chain[ chain.size - 1 ].target, "targetname" );
	for( i = 0 ; i < chain.size ; i ++ )
		chain[ i ] delete();
	return pathpoints;
}

movewithrate( dest, destang, moverate, accel, decel )
{
	if( !isdefined( accel ) )
		accel = 0;
	if( !isdefined( decel ) )
		decel = 0;
	 // moverate = units / persecond
	if( !isdefined( moverate ) )
		moverate = 200;
	
	dist = distance( self.origin, dest );
	movetime = dist / moverate;
	self moveto( dest, movetime, accel, decel );
	self rotateto( destang, movetime, accel, decel );
	wait movetime;
}

