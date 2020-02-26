#include common_scripts\utility;
#include maps\_utility;
#include maps\_utility_code;
#include maps\_vehicle;

main()
{
	level.fxplay_writeindex = 0;
	level.startdelay = 0;
	level.recorded_fx_timer = 0;
	level.recorded_fx = [];
	level.truckjunk = [];
	level.sparksclaimed = 0;
	level.whackamolethread = ::whackamole;
	array_levelthread( getentarray( "delete_on_load", "targetname" ), ::deleteEnt );
	array_levelthread( getentarray( "delete_on_load", "target" ), ::deleteEnt );
	
	precacherumble( "tank_rumble" );
	precacheItem( "hind_FFAR_jeepride" );// this is kind of dumb
	precacheItem( "stinger" );

	array_thread( getentarray( "truckjunk", "targetname" ), ::truckjunk );

	default_start( ::ride_start );
	add_start( "start", ::ride_start );
	add_start( "wip", ::wip_start );
	
	// comment out this to record effects.
 	thread maps\jeepride_fx::jeepride_fxline();

	if ( !isdefined( level.fxplay_model ) )
	{
		array_thread( getentarray( "ghetto_tag", "targetname" ), ::ghetto_tag );
		array_thread( getvehiclenodearray( "sparks_on", "script_noteworthy" ), ::trigger_sparks_on );
		array_thread( getvehiclenodearray( "sparks_off", "script_noteworthy" ), ::trigger_sparks_off );
	}
	
	array_thread( getentarray( "ghetto_tag", "targetname" ), ::ghetto_tag_ref_clear );
	
	array_thread( getentarray( "ambient_setter", "targetname" ), ::ambient_setter );
	array_thread( getentarray( "sound_emitter", "targetname" ), ::sound_emitter );

	maps\jeepride_fx::main();
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
	// fancy override for some _bm21 stuff
	build_aianims( ::bm21_overrides, maps\_bm21_troops::set_vehicle_anims );
	
	maps\_small_hatchback::main( "vehicle_small_hatch_turq_destructible" );
	maps\_small_hatchback::main( "vehicle_small_hatchback_turq" );
	maps\_80s_sedan1::main( "vehicle_80s_sedan1_brn_destructible" );
	maps\_luxurysedan::main( "vehicle_luxurysedan" );	
	maps\_bus::main( "vehicle_bus_destructable" );	
	maps\_80s_hatch1::main( "vehicle_80s_hatch1_silv_destructible" );
	maps\_hind::main( "vehicle_mi24p_hind_woodland" );	
	maps\_truck::main( "vehicle_opfor_truck" );
	maps\_uaz::main( "vehicle_uaz_open_for_ride" );
	maps\_blackhawk::main( "vehicle_blackhawk" );
	maps\_luxurysedan::main( "vehicle_luxurysedan_test" );
	maps\_tanker::main( "vehicle_tanker_truck_civ" );
	maps\_truck::main( "vehicle_pickup_4door" );
	maps\_uaz::main( "vehicle_uaz_open" );	
	maps\_truck::main( "vehicle_pickup_roobars" );
	

	maps\createart\jeepride_art::main();
	maps\createfx\jeepride_fx::main();
		
	maps\_load::main();
	maps\_stinger::init();

	maps\jeepride_amb::main();

// 	thread monitorvehiclecounts();	
 	level.player allowstand( false );
	level.player allowprone( false );

// 	array_thread( getvehiclenodearray( "view_magnet", "script_noteworthy" ), ::view_magnet );


	array_thread( level.vehicle_spawners, ::all_god );
	array_thread( level.vehicle_spawners, ::apply_truckjunk );// stuff and manual ai positioning
	array_thread( getstructarray( "fliptruck_ghettoanimate", "targetname" ), ::fliptruck_ghettoanimate );
	array_thread( getstructarray( "attack_dummy_path", "targetname" ), ::attack_dummy_path );
	array_thread( getvehiclenodearray( "hillbump", "script_noteworthy" ), ::hillbump );
	array_thread( getvehiclenodearray( "sideswipe", "script_noteworthy" ), ::sideswipe );
	array_thread( getvehiclenodearray( "destructible_assistance", "script_noteworthy" ), ::destructible_assistance );
	array_thread( getvehiclenodearray( "no_godmoderiders", "script_noteworthy" ), ::no_godmoderiders );
	
	
	
	array_thread( getentarray( "stinger_me", "script_noteworthy" ), ::stinger_me );
	array_thread( getentarray( "all_allies_targetme", "script_noteworthy" ), ::all_allies_targetme );
	array_thread( getentarray( "heli_focusonplayer", "script_noteworthy" ), ::heli_focusonplayer );
	
	
	thread getplayersride();
	
	setsaveddvar( "sm_sunSampleSizeNear", 2.0 );

	thread pausevehicles();
	thread music();
	thread jeepride_start_dumphandle();
	thread end_ride();
	thread time_triggers();
// 	thread player_god_on();
	array_thread( getvehiclenodearray( "dumpstart_node", "targetname" ), ::clean_up_sync_vehicles );
// 	thread can_cannon();
//	level.player notify( "noHealthOverlay" );
	wait .05;
 	level.player allowstand( true );

}

#using_animtree( "generic_human" );   

bm21_overrides()
{
	positions = 	maps\_bm21_troops::setanims();
	
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
	
	positions[ 2 ].deathscript = ::specialdeaththread;
	positions[ 3 ].deathscript = ::specialdeaththread;
	positions[ 4 ].deathscript = ::specialdeaththread;
	positions[ 5 ].deathscript = ::specialdeaththread;
	positions[ 6 ].deathscript = ::specialdeaththread;
	positions[ 7 ].deathscript = ::specialdeaththread;
	positions[ 8 ].deathscript = ::specialdeaththread;
	positions[ 9 ].deathscript = ::specialdeaththread;
	

	return positions;
}

end_ride()
{	
	flag_wait( "playersride_init" );
	level.playersride waittill( "reached_end_node" );	
	wait 1;
	level.player unlink();
// 	thread player_fudge_moveto( ( - 36031, -15614, 524 ) );
	thread player_fudge_moveto( level.player.origin + ( 0, 0, 30000 ), 22000 );
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
//	level.player playerlinkto( level.playersride, "tag_guy3", .5 );
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
	
	other joltbody( ( level.playersride.origin + ( 0, 0, 64 ) ), 16 );
	level.playersride joltbody( ( other.origin + ( 0, 0, 64 ) ), 16 );
	dist = distance( other.origin, level.playersride.origin );
	sndorg = vector_multiply( vectornormalize( other.origin - level.playersride.origin ), dist / 2 ) + level.playersride.origin + ( 0, 0, 48 );
	thread play_sound_in_space( "jeepride_sideswipe", sndorg, 1 );
// 	iprintlnbold( "sideswipe" );
	earthquake( .45, 1, level.player.origin, 1000 );
	
	// 	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	level.player PlayRumbleOnEntity( "tank_rumble" );
}

hillbump()
{
	// gag script for simulating bumps going down the hill
	self waittill( "trigger", other );
	other notify( "newjolt" );
	other endon( "newjolt" );
	other endon( "death" );
	level.playersride PlayRumbleOnEntity( "tank_rumble" );
	
	thread play_sound_in_space( "jeepride_grassride_thud", level.player.origin, 1 );
	
	for ( i = 0;i < 6 ;i ++ )
	{
		other joltbody( ( other.origin + ( 23, 33, 64 ) ), 2 );
		if ( other == level.playersride )
		{
			earthquake( .15, 1, level.player.origin, 1000 );
		}
		wait .2 + randomfloat( .2 );
		thread play_sound_in_space( "jeepride_grassride_through", level.player.origin, 1 );
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
	while ( 1 )
	{
		while ( ! twobuttonspressed( button1, button2 )  )
			wait .05;
			while ( !jeepride_start_dump() )
				wait.05;
		while ( twobuttonspressed( button1, button2 ) )
			wait .05;
	}
}

get_vehicles_with_spawners()
{
	vehicles = getentarray( "script_vehicle", "classname" );
	spawned_vehicles = [];
	for ( i = 0;i < vehicles.size;i ++ )
		if ( isdefined( vehicles[ i ].spawner_id ) && isdefined( vehicles[ i ].currentnode ) )
			spawned_vehicles[ spawned_vehicles.size ] = vehicles[ i ];
	return spawned_vehicles;		
}

jeepride_start_dump()
{
	spawned_vehicles = [];
 /#
	freezeframed_vehicles = get_vehicles_with_spawners();
	
	// freezeframe the vehicles because fileprint requires some frames.
	for ( i = 0;i < freezeframed_vehicles.size;i ++ )
	{
		struct = spawnstruct();
		struct.vehicletype = freezeframed_vehicles[ i ].vehicletype;
		struct.origin = freezeframed_vehicles[ i ].origin;
		struct.angles = freezeframed_vehicles[ i ].angles;
		struct.currentnode = freezeframed_vehicles[ i ].currentnode;
		struct.detouringpath = freezeframed_vehicles[ i ].detouringpath;
		struct.target = freezeframed_vehicles[ i ].target;
		struct.targetname = freezeframed_vehicles[ i ].targetname;
		struct.script_forceyaw = freezeframed_vehicles[ i ].script_forceyaw;// remove me when models are rigged
		struct.spawner_id = freezeframed_vehicles[ i ].spawner_id;
		struct.speedmph = freezeframed_vehicles[ i ] getspeedmph();
		struct.ghettomodel_obj = freezeframed_vehicles[ i ].ghettomodel_obj;
		struct.script_angles = freezeframed_vehicles[ i ].script_angles;
		spawned_vehicles[ i ] = struct;
	}

	// break if detouring oddlike
	for ( i = 0;i < spawned_vehicles.size;i ++ )
	{
		if ( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.
		targetnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		if ( !isdefined( targetnode ) )
			continue;
		if ( isdefined( targetnode.detoured ) )
			return false;
	}	
	starttime = string( gettime() + level.startdelay );

	// starts a map with a header and a blank worldspawn
	fileprint_map_start( level.script + "_dumpstart" );

	for ( i = 0;i < spawned_vehicles.size;i ++ )
	{
		if ( spawned_vehicles[ i ] ishelicopter() )
			continue;// no helicopters in quickstarts yet.  I'm too scared of them. I should be able to use some sort of setspeed immediate but they won't be as close to accurate I don't think.
		if ( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.

		target = "dumpstart_node_target_" + i;
		// vectors print as( 0, 0, 0 ) where they need to be converted to "0 0 0" for radiant to know what's up
		origin = fileprint_radiant_vec( spawned_vehicles[ i ].origin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();
// 			if ( i == 0 )
			fileprint_map_keypairprint( "script_delay", starttime );
			fileprint_map_keypairprint( "spawnflags", "1" );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", "dumpstart_node" );
			fileprint_map_keypairprint( "_color", "1.000000 0.000000 0.000000" );
			fileprint_map_keypairprint( "target", target );
			fileprint_map_keypairprint( "spawner_id", spawned_vehicles[ i ].spawner_id );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );


	
			if ( isdefined( spawned_vehicles[ i ].ghettotags ) )
				fileprint_map_keypairprint( "script_ghettotag", "1" );
			fileprint_map_keypairprint( "lookahead", ".2" );// static lookahead for the short duration of the path shouldn't put it too out of sync
			fileprint_map_keypairprint( "speed", spawned_vehicles[ i ].speedmph  );
		fileprint_map_entity_end();

		// project a node towards the next node in the chain for an onramp
		if ( isdefined( spawned_vehicles[ i ].detouringpath ) )
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

// won't need this when tankers are rigged
clean_up_sync_vehicles()
{
	node = self;
	targetingghettomodel = getent( node.target, "target" );
	if ( isdefined( targetingghettomodel ) )
		targetingghettomodel delete();
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
	if ( isdefined( node.script_ghettotag ) )
		vehicle apply_ghettotag();
	if ( isdefined( node.script_delay ) )
		level.startdelay = node.script_delay;
	detournode = getvehiclenode( targetnode.script_noteworthy, "targetname" );
	

	vehicle setswitchnode( targetnode, detournode );
	
	vehicle.attachedpath = detournode;
	vehicle thread vehicle_paths();
}

twobuttonspressed( button1, button2 )
{
		return level.player buttonpressed( button1 ) && level.player buttonpressed( button2 );
}

pausevehicles()
{
	button1 = "r";
	button2 = "CTRL";
	while ( 1 )
	{
		while ( !twobuttonspressed( button1, button2 ) )
			wait .05;
// 		array_thread( getentarray( "script_vehicle", "classname" ), ::pausevehicle );
		jeepride_vehicle_dump();
		while ( twobuttonspressed( button1, button2 ) )
			wait .05;
		while ( !twobuttonspressed( button1, button2 ) )
			wait .05;
		array_thread( getentarray( "script_vehicle", "classname" ), ::unpausevehicle );
		while ( twobuttonspressed( button1, button2 ) )
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
	 
	predumpvehicles = getentarray( "script_vehicle", "classname" );
	vehicles = [];
	
	// dumping can jump a frame in which the information could be altered, this stores the necessary info real quick
	for ( i = 0 ; i < predumpvehicles.size ; i ++ )
	{
		struct = spawnstruct();
		struct.classname = predumpvehicles[ i ].classname;
		struct.origin = predumpvehicles[ i ].origin;
		struct.angles = predumpvehicles[ i ].angles;
		struct.spawner_id = predumpvehicles[ i ].spawner_id;
		struct.speedbeforepause = predumpvehicles[ i ].speedbeforepause;
		struct.lastnodespeed = predumpvehicles[ i ].lastnodespeed;
		struct.script_vehiclespawngroup = predumpvehicles[ i ].script_vehiclespawngroup;
		struct.script_vehiclestartmove = predumpvehicles[ i ].script_vehiclestartmove;
		struct.model = predumpvehicles[ i ].model;
		struct.angles = predumpvehicles[ i ].angles;
		if ( predumpvehicles[ i ] == level.playersride )
			struct.playersride = true;
		vehicles[ i ] = struct; 
	}

	fileprint_map_start( level.script + "_veh_ref" );
	
	
	for ( i = 0;i < vehicles.size;i ++ )
	{
		origin = fileprint_radiant_vec( vehicles[ i ].origin );// convert these vectors to mapfile keypair format
		angles = fileprint_radiant_vec( vehicles[ i ].angles );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "classname", "script_model" );
			fileprint_map_keypairprint( "spawnflags", "4" );
			fileprint_map_keypairprint( "model", vehicles[ i ].model );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "angles", angles );
			fileprint_map_keypairprint( "spawnersorigin", fileprint_radiant_vec( level.vehicle_spawners[ vehicles[ i ].spawner_id ].origin ) );
			if ( isdefined( vehicles[ i ].playersride ) )
				fileprint_map_keypairprint( "target", "delete_on_load" );// _load deletes these.
			else
			{
				fileprint_map_keypairprint( "target", "structtarg" + i );// _load deletes these.
				fileprint_map_keypairprint( "targetname", "delete_on_load" );// _load deletes these.
			}
				
			if ( isdefined( vehicles[ i ].speedbeforepause ) )
				fileprint_map_keypairprint( "current_speed", vehicles[ i ].speedbeforepause );
			if ( isdefined( vehicles[ i ].lastnodespeed ) )
				fileprint_map_keypairprint( "last_node_speed", vehicles[ i ].lastnodespeed );
			if ( isdefined( vehicles[ i ].script_vehiclespawngroup ) )
				fileprint_map_keypairprint( "script_vehiclespawngroup", vehicles[ i ].script_vehiclespawngroup );
			if ( isdefined( vehicles[ i ].script_vehiclestartmove ) )
				fileprint_map_keypairprint( "script_vehiclestartmove", vehicles[ i ].script_vehiclestartmove );
		fileprint_map_entity_end();
		
		// struct shows where the spawner is
		fileprint_map_entity_start();
			fileprint_map_keypairprint( "classname", "script_struct" );
			fileprint_map_keypairprint( "origin", fileprint_radiant_vec( level.vehicle_spawners[ vehicles[ i ].spawner_id ].origin ) );
			fileprint_map_keypairprint( "_color", "0.300000 0.300000 0.300000" );
			fileprint_map_keypairprint( "angles", angles );
			fileprint_map_keypairprint( "model", vehicles[ i ].model );
			fileprint_map_keypairprint( "targetname", "structtarg" + i );
			if ( isdefined( vehicles[ i ].speedbeforepause ) )
				fileprint_map_keypairprint( "current_speed", vehicles[ i ].speedbeforepause );
			if ( isdefined( vehicles[ i ].lastnodespeed ) )
				fileprint_map_keypairprint( "last_node_speed", vehicles[ i ].lastnodespeed );
			if ( isdefined( vehicles[ i ].script_vehiclespawngroup ) )
				fileprint_map_keypairprint( "script_vehiclespawngroup", vehicles[ i ].script_vehiclespawngroup );
			if ( isdefined( vehicles[ i ].script_vehiclestartmove ) )
				fileprint_map_keypairprint( "script_vehiclestartmove", vehicles[ i ].script_vehiclestartmove );
		fileprint_map_entity_end();
		
	}
	fileprint_end();
	iprintlnbold( "dumped vehicles" );
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
		for ( i = 0 ; i < incs ; i ++ )
		{
				level.player setplayerangles( org_ent.angles );
				wait .05;
// 				if ( level.player attackbuttonpressed() )
// 					break;
		}
	
}

time_triggers()
{
	waittillframeend;
	thread delaythread_loc( 5.5, ::hintthread, "Behind US!" ); 
	thread delaythread_loc( 15, ::hintthread, "They're gaining to our left!" ); 
	thread delaythread_loc( 49, ::hintthread, "We're boxed in!  BANG BANG!" ); 
	thread delaythread_loc( 52, ::hintthread, "Got him!" ); 
	thread delaythread_loc( 56, ::hintthread, "Behind US!" ); 
	thread delaythread_loc( 57, ::hintthread, "Incoming to our left" ); 
	thread delaythread_loc( 58, ::hintthread, "Got him!" );
	thread delaythread_loc( 62.5, ::hintthread, "Enemy hind to our Left" );
	thread delaythread_loc( 74.5, ::hintthread, "Out of our way you dirty bastard" );
	thread delaythread_loc( 80, ::hintthread, "Turbulance Ahead!" );
	thread delaythread_loc( 107, ::hintthread, "He's on our Left!" );
	thread delaythread_loc( 111, ::hintthread, "Suppress that Hind Ahead!" );
	thread delaythread_loc( 125, ::hintthread, "Incoming from the Right!" );
	thread delaythread_loc( 125, ::hintthread, "Heads Up!" );
	thread delaythread_loc( 152, ::endprint );
}

giveplayer_missilelauncher()
{
	
}

delaythread_loc( delay, sthread, param1 )
{
	delay *= 1000;
	
	if ( level.startdelay != 0 && level.startdelay  > delay )
		return;// this event has passed in the wip start point.
	while ( gettime() + level.startdelay < delay )
		wait .05;
	if ( isdefined( param1 ) )
		thread [[ sthread ]]( param1 );
	else
		thread [[ sthread ]]();
}

hintthread( msg )
{
	level notify( "new_hintj" );
	level endon( "new_hintj" );
	iprintlnbold( "                     " + msg );
	slidetime = 200;
	timer = gettime() + 1000;
	boldprinttimer = gettime() + slidetime;
	while ( timer > gettime() )
	{
		if ( gettime() > boldprinttimer )
		{
			iprintlnbold( " " );
			boldprinttimer = gettime() + slidetime;
		}
		wait .05;
	}
	while ( ! level.player attackbuttonpressed() )
		wait .05;
		
	for ( i = 0;i < 10;i ++ )
		iprintlnbold( " " );
}


endprint()
{
	if ( !isdefined( level.fxplay_model ) )
		playfx_write_all( level.recorded_fx );
		
		
	iprintlnbold( "End of current level" );
	wait 3;
	missionsuccess( "jeepride", false );
}

ghetto_tag()
{
		if ( !isdefined( level.ghettotag ) )
			level.ghettotag = [];
		target = getent( self.target, "targetname" );
		assert( isdefined( target ) );
		assert( isdefined( target.model ) );
		if ( !isdefined( level.ghettotag[ target.model ] ) )
			level.ghettotag[ target.model ] = [];
		level.ghettotag[ target.model ][ level.ghettotag[ target.model ].size ] = ghetto_tag_create( target );
		
}

ghetto_tag_ref_clear()
{
	target = getent( self.target, "targetname" );
	if ( isdefined( target ) )
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
	while ( 1 )
	{
		self waittill( "trigger", other );
		other thread apply_ghettotag();
			
	}
}

trigger_sparks_off()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		other thread remove_ghettotag();
			
	}
}

remove_ghettotag()
{
	if ( !isdefined( self.ghettotags ) )
		return;
	array_thread( self.ghettotags, ::deleteme );
	if ( !isdefined( self ) )
		return;
	self.ghettotags = [];
}

apply_ghettotag()
{
	if ( !isdefined( level.ghettotag ) || !isdefined( level.ghettotag[ self.model ] ) )
		return;
	self.ghettotags = [];
	ghettotags = level.ghettotag[ self.model ];
	for ( i = 0 ; i < ghettotags.size ; i ++ )
	{
		model = spawn( "script_model", self.origin );
		model setmodel( ghettotags[ i ].model );
		model hide();
// 		origin = self localtoworldcoords( ghettotags[ i ].origin );
// 		angles = self.angles + ghettotags[ i ].angles;
		model linkto( self, "tag_body", ghettotags[ i ].origin, ghettotags[ i ].angles );
		model notsolid();
		self.ghettotags[ self.ghettotags.size ] = model;// todo create special string value of these.
		model thread tempfx( self );
	}
}

tempfx( vehicle )
{
	self endon( "death" );
	delaytime = .05;
	while ( isdefined( self ) )
	{
		org1 = self.origin;
		org2 = self.origin + vector_multiply( anglestoup( self.angles ), 8 );
		trace = bullettrace( org1, org2, false, vehicle );
		if ( trace[ "fraction" ] < 1 && ! trace_isjunk( trace ) )
		{
			spark = getspark();
			playfxontag_record( spark, self, "polySurface1" );
		}
		wait delaytime;
	}	
}

trace_isjunk( trace )
{
	if ( isdefined( trace[ "entity" ] ) )
		if ( trace[ "entity" ].classname == "script_model" )
			return true;// I don't have any cases that I'm aware of where I want it to spark on a script model
	return false;
}

playfxontag_record( strFXid, object, tag )
{
	playfxontag( level._effect[ strFXid ], self, "polySurface1" );
	struct = spawnstruct();
	struct.effectid = strFXid;
	struct.origin = object.origin;
	struct.angles = object.angles;
// 	struct.tag = tag;
// 	struct.model = object.model;
// 	struct.delay = ( gettime() * 1.0 - level.recorded_fx_timer * 1.0 ) / 1000.00;
	struct.delay = gettime();
	if ( level.recorded_fx.size > 2000 )
	{
		thread playfx_write_all( level.recorded_fx );// dump a new file to keep variable count from overflowing.. pain in the neck blah
		level.recorded_fx = [];
	}
	else
	{
		level.recorded_fx[ level.recorded_fx.size ] = struct;
		level.recorded_fx_timer = gettime();	
	}
}



playfx_write_all( recorded )
{
// 	modelname = "axis";
	 /#
	index = level.fxplay_writeindex;
	level.fxplay_writeindex ++ ;// have to write multiple files out as the sparkfile grows and variables need to be cleared;
	file = "scriptgen/" + level.script + "_fxline_" + index + ".gsc";
	file = fileprint_start( file );
	
	fileprint_chk( level.fileprint, "#include maps\\jeepride;" );
	fileprint_chk( level.fileprint, "fxline()" );
	fileprint_chk( level.fileprint, "{" );
	
	if ( !index )
		fileprint_chk( level.fileprint, "createfxplayers( 8 );" );
	for ( i = 0 ; i < recorded.size ; i ++ )
	{
		fileprint_chk( level.fileprint, "fx_wait_set( " + recorded[ i ].delay + ", " + recorded[ i ].origin + ", " + recorded[ i ].angles + ", \"" + recorded[ i ].effectid + "\" );" );
// 		fileprint_chk( level.fileprint, "setfxplayer();" );
// 		fileprint_chk( level.fileprint, "level.fxplay_model.origin = " + recorded[ i ].origin + ";" );
// 		level.fxplay_model.origin = recorded[ i ].origin;
// 		fileprint_chk( level.fileprint, "level.fxplay_model.angles = " + recorded[ i ].angles + ";" );
// 		level.fxplay_model.angles = recorded[ i ].angles;
// 		fileprint_chk( level.fileprint, "playfxontag( level._effect[ \"" + recorded[ i ].effectid + "\" ], level.fxplay_model, \"polySurface1\" );" );
// 	 	playfxontag( level._effect[ recorded[ i ].effectid ], level.fxplay_model, [ recorded[ i ].tag ] );
	}
	fileprint_chk( level.fileprint, "}" );
	fileprint_end();
	#/ 
}

fx_wait_set( time, origin, angles, effectID, tag )
{
	tag = "polySurface1";// using axis model . may use other models later on
	// delay was suffering some roundoff issues I believe. storing and comparing gettime is more accurate that setting a delay on each effect
	if ( time < level.startdelay )
		return; 
	while ( gettime() + level.startdelay < time )
		wait .05;
	setfxplayer();
	level.fxplay_model.origin = origin;
	level.fxplay_model.angles = angles;
	playfxontag( level._effect[ effectID ], level.fxplay_model, tag );
}

createfxplayers( amount )
{
	level.Fxplay_model_array = [];
	level.Fxplay_index = 0;
	level.Fxplay_indexmax = amount;
	for ( i = 0 ; i < amount ; i ++ )
	{
		model = spawn( "script_model", ( 0, 0, 0 ) );
		model setmodel( "axis" );
		model hide();
		level.Fxplay_model_array[ i ] = model;
	}
	return setfxplayer();
}

setfxplayer()
{
	level.fxplay_model = level.Fxplay_model_array[ level.Fxplay_index ];
	level.Fxplay_index ++ ;
	if ( level.Fxplay_index >= level.Fxplay_indexmax )
		level.Fxplay_index = 0;
	
}

getspark()
{
	if ( level.sparksclaimed > 3 )
		return "tunnelspark" ;
	else
	{
		thread claimspark();
		return "tunnelspark_dl" ;
	}
}

claimspark()
{
	level.sparksclaimed ++ ;
	wait .05;
	level.sparksclaimed -- ;
}

// helicopter fires at a moving invisible object, object is made to sync with players ride making things dramatic.
attack_dummy_path()
{
	
	path = setup_throwchain( self );
	delay = 0;
	if ( isdefined( self.script_delay ) )
		delay = self.script_delay;
	trigger = getent( self.script_linkto, "script_linkname" );
	trigger waittill( "trigger", helicopter );

	model = spawn( "script_model", path[ 0 ].origin );
	model setmodel( "fx" );
 	model hide();
	model notsolid();
	model.oldmissiletype = false;
	helicopter endon( "gunner_new_target" );
	helicopter endon( "death" );
	helicopter clearlookatent();
	helicopter setlookatent( model );
	
	// I'm ghetto hacking this.  only handles hind in Jeepride. doin what I need to do to do th e stuff.  get out of my sandbox!
	helicopter thread shootEnemyTarget( model, delay );
	ghetto_animate_through_chain( path, model, 500 );
	helicopter clearlookatent();
	model delete();
}

fliptruck_ghettoanimate()
{
	throwchain = setup_throwchain( self );
	vehiclenode =  getvehiclenode( self.script_linkto, "script_linkname" );
	previous_vehiclenode = getvehiclenode( vehiclenode.targetname, "target" );
	assert( isdefined( previous_vehiclenode ) );
	previous_vehiclenode waittill( "trigger", truck );
	time = gettime();
	prevorg = truck.origin;
	vehiclenode waittill( "trigger", truck );
	timediff = ( gettime() - time ) / 1000;
	dist = distance( prevorg, truck.origin );
	rate = dist / timediff;

	// todo copy collmap and apply it to the dummy for better physics.
	dummy = truck maps\_vehicle::vehicle_to_dummy();
	truck junk_to_dummy( dummy );
	truck thread junk_throw();
	dummy notsolid();
	
	array_thread( truck.riders, ::killthrow );
	ghetto_animate_through_chain( throwchain, dummy, rate );

	truck remove_ghettotag();
}

ghetto_animate_through_chain( throwchain, dummy, rate )
{
	dummy endon( "death" );
	if ( !isdefined( rate ) )
		rate = 500;
	for ( i = 0 ; i < throwchain.size - 1 ; i ++ )
	{
		org = throwchain[ i ];
		dest = throwchain[ i + 1 ];
		if ( isdefined( org.speed ) )
		{
			rate = org.speed;
		}
		if ( isdefined( org.script_attackmetype ) )
			dummy.script_attackmetype = org.script_attackmetype;
		else
			dummy.script_attackmetype = undefined;
			
		if ( isdefined( org.script_shotcount ) )
			dummy.script_shotcount = org.script_shotcount;

		if ( isdefined( org.script_sound ) )
			dummy thread play_sound_on_entity( org.script_sound );
			
		println( "speed of ghettoanimated: " + rate );
		dummy movewithrate( dest.origin, dest.angles, rate );
	}
}


fire_missile( weaponName, iShots, eTarget, fDelay )
{
	self endon( "death" );
	self endon( "gunner_new_target" );
	eTarget endon( "death" );
	if ( !isdefined( iShots ) )
		iShots = 1;
	assert( self.health > 0 );
	tags[ 0 ] = "tag_missile_left";
	tags[ 1 ] = "tag_missile_right";
	weaponShootTime = weaponfiretime( weaponName );
	assert( isdefined( weaponShootTime ) );
	self setVehWeapon( weaponName );
	nextMissileTag = -1;
	for ( i = 0 ; i < iShots ; i ++ )
	{
		nextMissileTag ++ ;
		if ( nextMissileTag >= tags.size )
			nextMissileTag = 0;
		
		eMissile = self fireWeapon( tags[ nextMissileTag ] );
		if ( !isdefined( eMissile ) )
			continue;// TODO: I should find out why.  there's no apparent reason. maybe I'm firing too many?

		if ( eTarget.oldmissiletype )
			eMissile missile_settarget( eTarget, ( 80, 20, -200 ) );
		else
			eMissile missile_settarget( eTarget );
				
		if ( i < iShots - 1 )
			wait weaponShootTime;
			
		if ( isdefined( fDelay ) )
			wait( fDelay );
	}
}

killthrow()
{
	if ( self.pos == 0 || self.pos == 1 )
	{
		self delete();
		return;
	}
	self dodamage( 8000, self.origin ); 

}

setup_throwchain( pathpoint )
{
	arraycount = 0;
	pathpoints = [];
	chain = [];
	speed = 200;
	while ( isdefined( pathpoint ) )
	{
// 		struct = spawnstruct();
// 		struct.origin = pathpoint.origin;
// 		struct.angles = pathpoint.angles;
// 		if ( isdefined( pathpoint.script_shotcount ) )
// 			struct.script_shotcount = pathpoint.script_shotcount;
// 		if ( isdefined( pathpoint.script_attackmetype ) )
// 			struct.script_attackmetype = pathpoint.script_attackmetype;
// 		if ( isdefined( pathpoint.speed ) )
// 			struct.speed = pathpoint.speed;
// 		if ( isdefined( pathpoint.script_sound ) )
// 			struct.script_sound = pathpoint.script_sound;
		if ( !isdefined( pathpoint.angles ) )
			pathpoint.angles = ( 0, 0, 0 );
		chain[ arraycount ] = pathpoint; 
// 		pathpoints[ arraycount ] = struct; 
		pathpoints[ arraycount ] = pathpoint; 
		arraycount ++ ; 

		if ( isdefined( pathpoint.target ) )
			pathpoint = getstructarray( pathpoint.target, "targetname" )[ 0 ];
		else
			break; 
	}
// 	for ( i = 0 ; i < chain.size ; i ++ )
// 		chain[ i ] delete();
	return pathpoints;
}


movewithrate( dest, destang, moverate, accel, decel )
{

	if ( !isdefined( accel ) )
		accel = 0;
	if ( !isdefined( decel ) )
		decel = 0;
	// moverate = units / persecond
	if ( !isdefined( moverate ) )
		moverate = 200;
	
	dist = distance( self.origin, dest );
	movetime = dist / moverate;
	self moveto( dest, movetime, accel, decel );
	self rotateto( destang, movetime, accel, decel );
	wait movetime;
}


heli_focusonplayer()
{
	self waittill( "trigger", other );
	other setlookatent( level.playersride );
	other setTurretTargetEnt( level.playersride );
}

shootEnemyTarget( eTarget, delay )
{
	if ( !isdefined( delay ) )
		delay = 0;
	self endon( "death" );
	self endon( "mg_off" );
	eTarget endon( "death" );
	self endon( "gunner_new_target" );
	self setTurretTargetEnt( eTarget );
	wait delay;
	while ( self.health > 0 )
	{
		script_attackmetype = "mg";
		if ( isdefined( eTarget.script_attackmetype ) )
			script_attackmetype = eTarget.script_attackmetype;
		if ( script_attackmetype == "none" )
		{
			wait .05;
		}
		else if ( script_attackmetype == "mg" )
		{
			self setVehWeapon( "hind_turret" );
			randomShots = randomintrange( 15, 25 );
			self fireWeapon( "tag_flash" );
			wait 0.05;
		}
		else if ( script_attackmetype == "missile" || script_attackmetype == "missile_old" )
		{
			if ( script_attackmetype == "missile_old" )
				eTarget.oldmissiletype = true;
			self setVehWeapon( "hind_FFAR_jeepride" );
			script_shotcount = 6;
			if ( isdefined( eTarget.script_shotcount ) )
				script_shotcount = eTarget.script_shotcount;

			self fire_missile( "hind_FFAR_jeepride", script_shotcount, eTarget, .2 );
			eTarget.script_attackmetype = undefined;
		}
		else
		{
			println( "attackmetype: " + script_attackmetype );
			assertmsg( "check attackmetype" );
		}
	}
}


sound_emitter()
{
	links = get_links();
	trigger = undefined;
	sound = self.script_noteworthy;
	assert( isdefined( sound ) );
	for ( i = 0 ; i < links.size ; i ++ )
	{
		trigger = getvehiclenode( links[ i ], "script_linkname" );
		if ( !isdefined( trigger ) )
			continue;
		trigger thread sound_emitter_single( sound );
	}
	self delete();
}

sound_emitter_single( sound )
{
	self waittill( "trigger", vehicle );
	vehicle thread play_sound_on_entity( sound );
}

ambient_setter()
{
	trigger = getvehiclenode( self.target, "targetname" );
	self hide();
	assert( isdefined( trigger ) );
	ambient = self.ambient;
	trigger waittill( "trigger" );
// 	level thread maps\_ambient::activateAmbient( ambient );
	type = ambient;
	level.player setReverb( level.ambient_reverb[ type ][ "priority" ], level.ambient_reverb[ type ][ "roomtype" ], level.ambient_reverb[ type ][ "drylevel" ], level.ambient_reverb[ type ][ "wetlevel" ], level.ambient_reverb[ type ][ "fadetime" ] );

}

whackamole( guy )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	// lots of bridges to pass with this one.  for now it's very simple. 
	// they crouch and stand util they die!
	if ( guy.team == "allies" )
	{
		guy.desired_anim_pose = "crouch";	
		guy allowedstances( "crouch" );
		guy thread animscripts\utility::UpdateAnimPose();
		return;
	}

	thread orientmodehack_axis( guy );
	while ( 1 )
	{
		guy.desired_anim_pose = "crouch";	
		guy allowedstances( "crouch" );
		guy.ignoreall = true;
		guy thread animscripts\utility::UpdateAnimPose();
		wait randomfloatrange( 3, 5 );
		guy.desired_anim_pose = "stand";	
		guy allowedstances( "stand" );
		guy.ignoreall = false;

		guy thread animscripts\utility::UpdateAnimPose();
		wait randomfloatrange( 1, 3 );
	}

}
#using_animtree( "generic_human" );   

orientmodehack_axis( guy )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	guy endon( "death" );
	// set the orient mode to face the player every frame. lets  see what this does
	
	while ( 1 )
	{
// 		guy setpotentialthreat( vectortoangles( level.player.origin - guy.origin )[ 1 ] );                
		guy orientmode( "face angle", vectortoangles( level.player.origin - guy.origin )[ 1 ] );
		wait 4;
	}
}

specialdeaththread()
{
	self unlink();
}

all_god()
{
	while ( 1 )
	{
	   eVehicle = waittill_vehiclespawn_spawner_id( self.spawner_id );
	   if ( eVehicle.script_team == "allies" )
	   	eVehicle thread riders_godon();
	   eVehicle thread godon();// all vehicles get godmode untill I tell them it's ok to die
	}
     
}

riders_godon()
{
	for ( i = 0 ; i < self.riders.size ; i ++ )
		self.riders[ i ] thread magic_bullet_shield();
}

monitorvehiclecounts()
{
	while ( 1 )
	{
		if ( getentarray( "script_vehicle", "classname" ).size > 60 )
		{
			jeepride_vehicle_dump();
			assertmsg( "too many vehicles" );
		}
		wait .05;
	}
}

destructible_assistance()
{
 	self waittill( "trigger", eVehicle );
	eVehicle notify( 	"stop_friendlyfire_shield" );
	eVehicle.health = 1;
  if ( ! eVehicle isDestructible() )
  {
  	eVehicle notify( "death" );
	}
	else
		eVehicle notify( "damage", 5000, level.player, ( 1, 1, 1 ), eVehicle.origin, "mod_explosive", eVehicle.model, undefined );

}

truckjunk()
{
	assert( isdefined( self.target ) );
	linked_vehicle = getent( self.target, "targetname" );
	assert( isdefined( linked_vehicle ) );
	spawner_id = vehicle_spawnidgenerate( linked_vehicle.origin );
	target = getent( self.target, "targetname" );
	ghettotag = ghetto_tag_create( target );
	if ( isdefined( self.script_noteworthy ) )
		ghettotag.script_noteworthy = self.script_noteworthy;
	if ( !isdefined( level.truckjunk[ spawner_id ] ) )
		level.truckjunk[ spawner_id ] = [];
	if ( isdefined( self.script_startingposition ) )
		ghettotag.script_startingposition = self.script_startingposition;
	level.truckjunk[ spawner_id ][ level.truckjunk[ spawner_id ].size ] = ghettotag;
	self delete();
}

apply_truckjunk()
{
	if ( !isdefined( level.truckjunk[ self.spawner_id ] ) )
		return;
	truckjunk = level.truckjunk[ self.spawner_id ];
	
	eVehicle = waittill_vehiclespawn_spawner_id( self.spawner_id );
	
	eVehicle.truckjunk = [];
	for ( i = 0 ; i < truckjunk.size ; i ++ )
	{
		model = spawn( "script_model", self.origin );
		model setmodel( truckjunk[ i ].model );
		model linkto( eVehicle, "tag_body", truckjunk[ i ].origin, truckjunk[ i ].angles );
		if ( isdefined( truckjunk[ i ].script_startingposition ) )
			eVehicle thread fake_position( model, truckjunk[ i ].script_startingposition );
		if ( isdefined( truckjunk[ i ].script_noteworthy ) && truckjunk[ i ].script_noteworthy == "loosejunk" )
			model thread loosejunk();
		eVehicle.truckjunk[ eVehicle.truckjunk.size ] = model; 
	}
}

fake_position( model, pos )
{
	model hide();
	while ( !self.riders.size )
		wait .05;
	if( pos == 999 )
	{
		level.player unlink();
		level.player playerlinkto( model, "polySurface1", .5 );
		return;
	}

	for ( i = 0 ; i < self.riders.size ; i ++ )
	{
		if ( self.riders[ i ].pos == pos )
		{
			self.riders[ i ] unlink();
			self.riders[ i ] linkto( model, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		}
	}
}

loosejunk()
{
	self.health = 10000;
	self setcandamage( true );
	self endon( "junk_throw" );
	while ( 1 )
	{
// 		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
			self waittill( "damage", damage, attacker, direction_vec, point );
			if ( attacker != level.player )
				continue;
			self unlink();
			self physicslaunch( point, vector_multiply( direction_vec, 10 ) + ( 0, 0, 20 ) );
			return;
	}
}

junk_to_dummy( model )
{
	if ( !isdefined( self.truckjunk ) )
		return;
	for ( i = 0 ; i < self.truckjunk.size ; i ++ )
	{
		self.truckjunk[ i ] unlink();
		self.truckjunk[ i ] linkto( model );
	}
}

junk_throw()
{
	if ( !isdefined( self.truckjunk ) )
		return;
	self notify( "junk_throw" );
// 	lastpos = self.origin;
// 	wait .1;
// 	forward = vectornormalize( self.origin - lastpos );
// 	forwardvec = vector_multiply( forward, 80000 );// yay troll math
	for ( i = 0 ; i < self.truckjunk.size ; i ++ )
	{
		if ( isdefined( self.truckjunk[ i ].script_startingposition ) || self.truckjunk[ i ].model == "axis" )
		{
			self.truckjunk[ i ] thread delayThread( 2, ::deleteme );
			continue;
		}
		center_height = 17;
		strength = 80000;
		delay = randomfloat( .7 );
		if ( self.truckjunk[ i ].model == "com_barrel_blue" || self.truckjunk[ i ].model == "com_barrel_black" )
		{
			strength = 660000;
			center_height = 23;
			delay = randomfloat( 1 );
		}
		else if ( self.truckjunk[ i ].model == "me_corrugated_metal2x4" )
		{
			strength = 1000;
			center_height = 0;
		}
		self.truckjunk[ i ] delaythread( delay, ::physicslaunch_loc, center_height, strength );
	}
}

physicslaunch_loc( centroid, strength, vec_sampledelay )
{
	if ( !isdefined( vec_sampledelay ) )
		vec_sampledelay = .1;
	orgbefore = self.origin;
	wait vec_sampledelay;
	throwvec = vectornormalize( self.origin - orgbefore );
	upvect = anglestoup( self.angles );
	self unlink();
	self physicslaunch( self.origin + vector_multiply( upvect, centroid ), vector_multiply( throwvec, strength ) );
}

can_cannon()
{
	level.cannonpower = 100;
	precachemodel( "com_trashcan_metal" );
	while ( 1 )
	{
		if ( level.player usebuttonpressed() )
			fire_can();
		wait .05;
	}
}

fire_can()
{
	can = spawn( "script_model", level.player geteye() );
	can setmodel( "com_trashcan_metal" );
	throw_vect = vector_multiply( vectornormalize( anglestoforward( level.player getplayerangles() ) ), level.cannonpower );
	can physicslaunch( can.origin + ( 0, 0, 17 ), throw_vect + ( 0, 0, 17 ) );
	wait .05;
	
}

no_godmoderiders()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		array_thread( other.riders, ::stop_magic_bullet_shield );
	}
}

all_allies_targetme()
{
	self waittill( "trigger", eVehicle );
	ai = getaiarray( "allies" );
	for ( i = 0 ; i < ai.size ; i ++ )
	{
		ai[ i ] orientmode( "face angle", vectortoangles( eVehicle.origin - ai[ i ].origin )[ 1 ] );
		ai[ i ] setentitytarget( eVehicle );
	}
}

stinger_me()
{
	
	self waittill( "trigger", eVehicle );

	thread hintthread( "Use this Stinger!" );
	weaponstore = level.player getcurrentweapon();

	level.player giveweapon( "stinger" );
	level.player switchtoweapon( "stinger" );

	ent = spawn( "script_model", eVehicle.origin );
	ent linkto( eVehicle, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	target_set( ent, ( 0, 0, -80 ) );
	target_setJavelinOnly( ent, true );

	level.player waittill( "stinger_fired" );

	level.player takeweapon( "stinger" );
	level.player switchToWeapon( weaponstore );

	if(!isdefined(eVehicle))
		return;
		
	level thread jeepride_flares_fire_burst( eVehicle, 8, 6, 5.0 );
	wait 0.5;

	ent unlink();
	vec = maps\_helicopter_globals::flares_get_vehicle_velocity( eVehicle );
	ent movegravity( vec, 8 );

}

jeepride_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
// 		copied from maps\hunted which was copied from maps\_helicopter_globals
// 		had to change it a litle since I couldn't redirect the missile in my case.
// 		I simplified even more because I don't need any of that stuff that those scripts do

	assert( isdefined( level.flare_fx[ vehicle.vehicletype ] ) );
	assert( fxCount >= flareCount );
	
	for ( i = 0 ; i < fxCount ; i ++ )
	{
		playfx( level.flare_fx[ vehicle.vehicletype ], vehicle getTagOrigin( "tag_light_belly" ) );
		wait 0.25;
	}
}