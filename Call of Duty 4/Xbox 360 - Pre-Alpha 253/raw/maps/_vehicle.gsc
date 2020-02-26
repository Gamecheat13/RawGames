 /* 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

VEHICLE script

This handles playing the various effects and animations on a vehicle.
It handles initializing a vehicle( giving it life, turrets, machine guns, treads and things )

It also handles spawning of vehicles in a very ugly way for now, we're getting code to make it pretty

Most things you see in the vehicle menu in Radiant are handled here.  There's all sorts of properties
that you can set on a trigger to access some of this functionality.  A trigger can spawn a vehicle, 
toggle different behaviors, 


HIGH LEVEL FUNCTIONS

 // vehicle_init( vehicle )
	this give the vehicle life, treads, turrets, machine guns, all that good stuff

 // main()
	this is setup, sets up spawners, trigger associations etc is ran on first frame by _load

 // trigger_process( trigger, vehicles )
	since triggers are multifunction I made them all happen in the same thread so that
	the sequencing would be easy to handle

 // vehicle_paths()
	This makes the nodes get notified trigger when they are hit by a vehicle, we hope
	to move this functionality to CODE side because we have to use a lot of wrappers for
	attaching a vehicle to a path

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 */ 
#include maps\_utility; 
#include common_scripts\utility; 
#using_animtree( "vehicles" );

init_vehicles()
{
	
	 // this removes the requirement of putting vehicletype on vehicles
	maps\_vehicletypes::setup_types();
	
	 // put all the vehicles with targetnames into an array so we can spawn vehicles from
	 // a string instead of their vehicle group #
	setup_targetname_spawners();

	 // vehicle related dvar initializing goes here
	setup_dvars();

	 // initialize all the level wide vehicle system variables
	setup_levelvars();

	 // drives vehicle through level
	 // helpful on levels where vehicles don't always make it through the whole path
	vclogin_vehicles();

	 // pre - associate ai and spawners with their vehicles
	setup_ai();

	 // pre - associate vehicle triggers and vehicle nodes with stuff.
	setup_triggers();

	 // check precacheing of vehicle scripts.
	allvehiclesprespawn = precache_scripts();

	 // setup spawners and non - spawning vehicles
	setup_vehicles( allvehiclesprespawn );

	 // send the setup triggers to be processed
	array_levelthread( level.vehicle_processtriggers, ::trigger_process, allvehiclesprespawn );

}


delete_group( vehicle, group )
{
	 // TODO: this may be redundant
	if( isdefined( vehicle.walkers ) )
		for( j = 0; j < vehicle.walkers.size; j ++ )
			if( issentient( vehicle.walkers[ j ] ) )
				vehicle.walkers[ j ] delete();
	if( isdefined( vehicle.riders ) )
		for( j = 0; j < vehicle.riders.size; j ++ )
			if( issentient( vehicle.riders[ j ] ) )
				vehicle.riders[ j ] delete();
	if( isdefined( vehicle ) )
		vehicle delete();
}

trigger_getlinkmap( trigger )
{
	linkMap = []; 
	if( isdefined( trigger.script_linkTo ) )
	{
		links = strtok( trigger.script_linkTo, " " );
		for( i = 0; i < links.size; i ++ )
			linkMap[ links[ i ] ] = true; 
		links = undefined; 
	}
	return linkMap; 
}

 /* 
Uber trigger handling.  I do this so I can process more than one
function on a trigger and maintain sequence( don't have 5 threads
running on a trigger ) it also helps that I only have to get the
linkmap and waittill trigger in one place
 */ 


setup_script_gatetrigger( trigger, linkMap )
{
	gates = []; 
	if( isdefined( trigger.script_gatetrigger ) )
	{
		gates = getlinks_array( level.vehicle_linkedpaths, linkMap );
		script_gatetrigger = level.vehicle_gatetrigger[ trigger.script_gatetrigger ]; 
		if( isdefined( script_gatetrigger ) )
			gates = array_merge_links( gates, script_gatetrigger );
	}
	return gates; 
}


setup_script_vehiclespawngroup( trigger, vehicles, linkMap )
{
	script_vehiclespawngroup = false; 
	if( isdefined( trigger.script_vehiclespawngroup ) )
	{
		script_vehiclespawngroup = true; 

 // 		bTriggeronce check here was a CoD1 hack I believe.
 // 		if( bTriggeronce )

		if( isdefined( trigger.target ) )
		{
			target = getent( trigger.target, "targetname" );
			if( isdefined( target ) && target.classname == "script_vehicle" )
			{
				targetedvehicle = target.targetname; 
				thread spawner_setup( target, target.targetname, "trigger target" );
			}
		}

		if( linkMap.size > 0 )
		{
			linkvehicles = getlinks_array( vehicles, linkMap );
			if( linkvehicles.size > 0 )
				thread spawner_setup( linkvehicles, linkvehicles[ 0 ].script_linkname, "trigger link" );
		}
	}
	return script_vehiclespawngroup; 
}

trigger_process( trigger, vehicles )
{
	 // these triggers only trigger once where vehicle paths trigger everytime a vehicle crosses them
	if( isdefined( trigger.classname ) && ( trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat" ) )
			bTriggeronce = true; 
	else
		bTriggeronce = false; 

	trigger.processed_trigger = undefined;  // clear out this flag that was used to get the trigger to this point.
	
	 // override to make a trigger loop
	if( isdefined( trigger.script_noteworthy ) && trigger.script_noteworthy == "trigger_multiple" )
		bTriggeronce = false; 

	 // depreciating linkmaps on vehicle triggers
	linkMap = []; 
	linkvehicles = []; 
	vehiclenames = []; 
	groupvehicles = []; 
	targetedvehicle = undefined; 

	 // get map of links
	linkMap = trigger_getlinkmap( trigger );

	 // associate script_linkto gates
	gates = setup_script_gatetrigger( trigger, linkMap );

	 // preprocesses linked vehicles for spawning
	
	 // CUTTING BOARD: this sets up targeted and linkto'd vehicles, this is what converts them to a spawngroup, it's very legacy and possibly not needed.
	script_vehiclespawngroup = setup_script_vehiclespawngroup( trigger, vehicles, linkMap );

	 // do all the isdefined checks on the first frame changing them to simple boolean values to be checked.
	 // ( maybe a bit memory intensive, I don't know, bools are cheap right? )

	script_vehicleaianim = 					isdefined( trigger.script_vehicleaianim );
	script_turret = 								isdefined( trigger.script_turret );
	script_delay = 									isdefined( trigger.script_delay );
	script_linkto = 								isdefined( trigger.script_linkto );
	script_VehicleStartMove = 			isdefined( trigger.script_VehicleStartMove );
	script_vehicleGroupDelete = 		isdefined( trigger.script_vehicleGroupDelete );
	script_crashtypeoverride = 			isdefined( trigger.script_crashtypeoverride );
	script_badplace = 							isdefined( trigger.script_badplace );
	script_turretmg = 							isdefined( trigger.script_turretmg );
	script_noteworthy = 						isdefined( trigger.script_noteworthy );
	script_deathroll = 							isdefined( trigger.script_deathroll );
	script_vehicledisabletrigger = 	isdefined( trigger.script_vehicledisabletrigger );
	script_turningdir = 						isdefined( trigger.script_turningdir );
	script_exploder = 							isdefined( trigger.script_exploder );
	script_vehicledetour = 					( 	isdefined( trigger.script_vehicledetour ) && isdefined( trigger.classname ) && trigger.classname == "script_origin" );
	script_unload = 					isdefined( trigger.script_unload );
	script_wheeldirection = isdefined( trigger.script_wheeldirection );

	detoured = 							isdefined( trigger.detoured ) && !isdefined( trigger.classname );

	gotrigger = true; 

	if( script_vehicledisabletrigger )
		level endon( "disabletriggers" + trigger.script_vehicledisabletrigger );

	vehicles = undefined; 

	while( gotrigger )
	{
		trigger waittill( "trigger", other );
		if( isdefined( trigger.enabled ) && !trigger.enabled )
			trigger waittill( "enable" );
		if( script_wheeldirection )
			other wheeldirectionchange( trigger.script_wheeldirection );


		if( script_exploder )
			exploder( trigger.script_exploder );

		triggererisdefined = isdefined( other );

		if( script_unload )
			other thread unload_node( trigger );

		if( detoured && triggererisdefined )
			other thread path_detour( trigger );
		
		if( script_vehicledetour )
			other thread path_detour_script_origin( trigger );

		if( script_delay )
			wait trigger.script_delay; 
		if( script_vehicledisabletrigger && script_noteworthy && trigger.script_noteworthy == "trigger" )
			level notify( "disabletriggers" + trigger.script_vehicledisabletrigger );
		targs = []; 
		if( bTriggeronce )
		{
			if( isdefined( trigger.target ) && isdefined( level.vehicle_target[ trigger.target ] ) )
				targs = level.vehicle_target[ trigger.target ]; 
			gotrigger = false; 
		}
		if( script_vehicleGroupDelete )
		{
			if( !isdefined( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] ) )
			{
				println( "failed to find deleteable vehicle with script_vehicleGroupDelete group number: ", trigger.script_vehicleGroupDelete );
				level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] = []; 
			}
			array_levelthread( array_merge( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ], targs ), ::delete_group, trigger.script_vehicleGroupDelete ); // was _links
		}

		if( script_vehiclespawngroup )
		{
			if( isdefined( linkvehicles ) && linkvehicles.size > 0 )
				level notify( "spawnvehiclegroup" + linkvehicles[ 0 ].script_linkname );
			level notify( "spawnvehiclegroup" + trigger.script_vehiclespawngroup );
			if( isdefined( targetedvehicle ) )
				level notify( "spawnvehiclegroup" + targetedvehicle );
			waittillframeend; 
 // 		level waittill( "vehiclegroup spawned" + targetedvehicle );
		}


		linkvehicles = []; 
		if( script_linkto )
			linkvehicles = getlinks_array( getentarray( "script_vehicle", "classname" ), linkMap );

		targs = array_merge_links( targs, linkvehicles );
		if( gates.size > 0 )
			array_levelthread( gates, ::path_gate_open );
		if( script_VehicleStartMove )
		{
			if( !isdefined( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ] ) && !targs.size )
			{
				println( "^3Vehicle start trigger is: ", trigger.script_VehicleStartMove );
				assertmsg( "script_VehicleStartMove trigger hit with nothing to move( see console )" );
				return; 
			}
			array_levelthread( array_merge( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ], targs ), ::gopath ); // was _links

		}
		if( !( triggererisdefined ) )
			continue; 

		if( script_crashtypeoverride )
			other.script_crashtypeoverride = trigger.script_crashtypeoverride; 
		if( script_badplace )
			other.script_badplace = trigger.script_badplace; 
 // 		if( script_attackspeed )
 // 			other.attackspeed = trigger.script_attackspeed; 
		if( script_turretmg )
			other.script_turretmg = trigger.script_turretmg; 
		if( script_noteworthy )
		{
			if( trigger.script_noteworthy == "forcekill" )
				other forcekill();
			if( trigger.script_noteworthy == "godon" )
				other godon();
			if( trigger.script_noteworthy == "godoff" )
				other godoff();
			if( trigger.script_noteworthy == "deleteme" )
				other thread vehicle_deleteme();
				
			other notify( trigger.script_noteworthy );
			other notify( "noteworthy", trigger.script_noteworthy );
		}

		if( script_turningdir )
			other notify( "turning", trigger.script_turningdir );

		if( script_deathroll )
			if( trigger.script_deathroll == 0 )
				other thread deathrolloff();
			else
				other thread deathrollon();

		if( script_vehicleaianim )
			other notify( "groupedanimevent", trigger.script_vehicleaianim );
	}
}

path_detour_get_detourpath( detournode )
{
	detourpath = undefined; 
	for( j = 0; j < level.vehicle_detourpaths[ detournode.script_vehicledetour ].size; j ++ )
	{
		if( level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ] != detournode )
			if( !islastnode( level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ] ) )
				detourpath = level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ]; 
	}
	return detourpath; 
}

path_detour_script_origin( detournode )
{
	detourpath = path_detour_get_detourpath( detournode );
	if( isdefined( detourpath ) )
		self thread vehicle_dynamicpath( detourpath );
}

crash_detour_check( detourpath )
{
	 // long somewhat complex set of conditions on which a vehicle will detour through a crashpath.
	return
	( 
		isdefined( detourpath.script_crashtype )
		 && 
		( 
				isdefined( self.deaddriver ) 
			 || self.health <= 0 
			 || detourpath.script_crashtype == "forced" 
			 || ( level.vclogin_vehicles )
		 )
		 && 
		( 
		 !isdefined( detourpath.derailed )  
		 || ( isdefined( detourpath.script_crashtype ) && detourpath.script_crashtype == "plane" ) 
		 )
	 );
}

crash_derailed_check( detourpath )
{
	return isdefined( detourpath.derailed ) && detourpath.derailed; 
}

path_detour( node )
{
	 // make sure those pesky script_origins aren't getting in.  remove this assert once i've got my sanity back
	assert( !(( isdefined( node.classname ) && node.classname == "script_origin" ) ) );
	assert( isdefined( node.detoured ) );
	
	if( node.detoured )
		return; 

	detournode = getvehiclenode( node.target, "targetname" );
	detourpath = path_detour_get_detourpath( detournode );
	
	 // be more aggressive with this maybe? 
	if( ! isdefined( detourpath ) )
		return; 
		
	if( crash_detour_check( detourpath ) )  
	{
		self notify( "crashpath", detourpath );
		detourpath.derailed = 1; 
		self notify( "newpath" );
		self setSwitchNode( node, detourpath );
		return; 
	}
	else
	{
		if( crash_derailed_check( detourpath ) )
			return;  // .derailed crashpaths fail crash check. this keeps other vehicles from following.
		self notify( "newpath" );
		self setswitchnode( detournode, detourpath );
		if( !islastnode( detournode ) && !( isdefined( node.scriptdetour_persist ) && node.scriptdetour_persist ) )
			node.detoured = 1; 
		self.attachedpath = detourpath; 
		thread vehicle_paths();
		return; 
	}
}

vehicle_Levelstuff( vehicle, trigger )
{
	 // associate with links. false
	if( isdefined( vehicle.script_linkname ) )
		level.vehicle_link = array_2dadd( level.vehicle_link, vehicle.script_linkname, vehicle );

	 // associate with targets
	if( isdefined( vehicle.targetname ) )
		level.vehicle_target = array_2dadd( level.vehicle_target, vehicle.targetname, vehicle );

	if( isdefined( vehicle.script_VehicleSpawngroup ) )
		level.vehicle_SpawnGroup = array_2dadd( level.vehicle_SpawnGroup, vehicle.script_VehicleSpawngroup, vehicle );

	if( isdefined( vehicle.script_VehicleStartMove ) )
		level.vehicle_StartMoveGroup = array_2dadd( level.vehicle_StartMoveGroup, vehicle.script_VehicleStartMove, vehicle );

	if( isdefined( vehicle.script_vehicleGroupDelete ) )
		level.vehicle_DeleteGroup = array_2dadd( level.vehicle_DeleteGroup, vehicle.script_vehicleGroupDelete, vehicle );

	thread vehicle_level_unstuff( vehicle );
}

vehicle_level_unstuff( vehicle )
{
	targetname = vehicle.targetname; 
	vehicle waittill( "death" );
	 // dis - associate with links. false
	if( isdefined( vehicle.script_linkname ) )
		level.vehicle_link[ vehicle.script_linkname ] = array_remove( level.vehicle_link[ vehicle.script_linkname ], vehicle );
	 // dis - associate with targets

	if( isdefined( targetname ) )
		level.vehicle_target[ targetname ] = array_remove( level.vehicle_target[ targetname ], vehicle );; 

	if( isdefined( vehicle.script_VehicleSpawngroup ) )
		level.vehicle_SpawnGroup[ vehicle.script_VehicleSpawngroup ] = array_remove( level.vehicle_SpawnGroup[ vehicle.script_VehicleSpawngroup ], vehicle );

	if( isdefined( vehicle.script_VehicleStartMove ) )
		level.vehicle_StartMoveGroup[ vehicle.script_VehicleStartMove ] = array_remove( level.vehicle_StartMoveGroup[ vehicle.script_VehicleStartMove ], vehicle );

	if( isdefined( vehicle.script_vehicleGroupDelete ) )
		level.vehicle_DeleteGroup[ vehicle.script_vehicleGroupDelete ] = array_remove( level.vehicle_DeleteGroup[ vehicle.script_vehicleGroupDelete ], vehicle );
}

spawn_array( spawners )
{
	ai = []; 
	for( i = 0; i < spawners.size; i ++ )
	{
		spawners[ i ].count = 1; 
		dronespawn = false; 
		if( isdefined( spawners[ i ].script_drone ) )
		{
			dronespawn = true; 
			spawned = dronespawn( spawners[ i ] );
			assert( isdefined( spawned ) );
		}
		else if( isdefined( spawners[ i ].script_forcespawn ) )
			spawned = spawners[ i ] stalingradSpawn();
		else
			spawned = spawners[ i ] doSpawn();
		if( !dronespawn && spawn_failed( spawned ) )
			continue; 
		assert( isdefined( spawned ) );
		ai[ ai.size ] = spawned; 
	}
	return ai; 
}

spawn_group()
{

	HasRiders = ( isdefined( self.script_vehicleride ) );
	HasWalkers = ( isdefined( self.script_vehiclewalk ) );
	if( !( HasRiders || HasWalkers ) )
	{
		return; 
	}
	spawners = []; 

	riderspawners = []; 
	walkerspawners = []; 

	if( HasRiders )
		riderspawners = level.vehicle_RideSpawners[ self.script_vehicleride ]; 
	if( !isdefined( riderspawners ) )
		riderspawners = []; 

	if( HasWalkers )
		walkerspawners = level.vehicle_walkspawners[ self.script_vehiclewalk ]; 
	if( !isdefined( walkerspawners ) )
		walkerspawners = []; 


	spawners = array_combine( riderspawners, walkerspawners );
	startinvehicles = []; 
	runtovehicles = []; 

	ai = spawn_array( spawners );

	if( HasRiders )
		if( isdefined( level.vehicle_RideAI[ self.script_vehicleride ] ) )
			ai = array_combine( ai, level.vehicle_RideAI[ self.script_vehicleride ] );
	if( HasWalkers )
		if( isdefined( level.vehicle_WalkAI[ self.script_vehiclewalk ] ) )
			ai = array_combine( ai, level.vehicle_WalkAI[ self.script_vehiclewalk ] );

	for( i = 0; i < ai.size; i ++ )
	{
		if( isdefined( ai[ i ].script_vehiclewalk ) )
		{
			if( isdefined( ai[ i ].script_followmode ) )
				ai[ i ].FollowMode = ai[ i ].script_followmode; 
			else
				ai[ i ].FollowMode = "cover nodes"; 

			 // check if the AI should go to a node after walking with the vehicle
			if( isdefined( ai[ i ].target ) )
			{
				node = getnode( ai[ i ].target, "targetname" );
				if( isdefined( node ) )
					ai[ i ].NodeAftervehicleWalk = node; 
			}
		}
		 // this is kind of legacy stuff from CoD1 I don't think anybody uses it anymore. - nate

		if(( isdefined( ai[ i ].script_noteworthy ) ) && ( ai[ i ].script_noteworthy == "runtovehicle" ) )
			runtovehicles[ runtovehicles.size ] = ai[ i ]; 
		else
			startinvehicles[ startinvehicles.size ] = ai[ i ]; 

	}

	if( runtovehicles.size > 0 )
		self notify( "load", runtovehicles );
	guy_array_enter_vehicle( startinvehicles, self );
}

runtovehicle( guy )
{
	guyarray = []; 

	climbinnode = self.climbnode; 
	climbinanim = self.climbanim; 
	closenode = climbinnode[ 0 ]; 
	currentdist = 5000; 
	thenode = undefined; 
	for( i = 0; i < climbinnode.size; i ++ )
	{
		climborg = self gettagorigin( climbinnode[ i ] );
		climbang = self gettagangles( climbinnode[ i ] );
		org = getstartorigin( climborg, climbang, climbinanim[ i ] );
		distance = distance( guy.origin, climborg );
		if( distance < currentdist )
		{
			currentdist = distance; 
			closenode = climbinnode[ i ]; 
			thenode = i; 
		}

	}

	climbang = undefined; 
	climborg = undefined; 
	thread runtovehicle_setgoal( guy );
	while( !guy.vehicle_goal )
	{
		climborg = self gettagorigin( climbinnode[ thenode ] );
		climbang = self gettagangles( climbinnode[ thenode ] );
		org = getStartOrigin( climborg, climbang, climbinanim[ thenode ] );
		guy set_forcegoal();
		guy setgoalpos( org );
		guy.goalradius = 64; 
		wait .25; 
	}
	guy unset_forcegoal();

	if( self getspeedmph() < 1 )
	{
		guy linkto( self );
		guy animscripted( "hopinend", climborg, climbang, climbinanim[ thenode ] );
		guy waittillmatch( "hopinend", "end" );
		guy_enter_vehicle( guy, self );
	}
}

runtovehicle_setgoal( guy )
{
	guy.vehicle_goal = false; 
	self endon( "death" );
	guy endon( "death" );
	guy waittill( "goal" );
	guy.vehicle_goal = true; 
}

setup_groundnode_detour( node )
{

		realdetournode = getvehiclenode( node.targetname, "target" );
		if( !isdefined( realdetournode ) )
			return; 
		realdetournode.detoured = 0; 
		if( isdefined( node.script_vehicledisabletrigger ) )
			realdetournode.script_vehicledisabletrigger = node.script_vehicledisabletrigger;  // pass the value on to the real detour trigger node
		add_proccess_trigger( realdetournode );	
}

add_proccess_trigger( trigger )
{
	 // .processedtrigger is a flag that I set to keep a trigger from getting added twice.
	if( isdefined( trigger.processed_trigger ) )
		return; 
	level.vehicle_processtriggers[ level.vehicle_processtriggers.size ] = trigger; 
	trigger.processed_trigger = true; 

}

islastnode( node )
{
	if( !isdefined( node.target ) )
		return true; 
	if( !isdefined( getvehiclenode( node.target, "targetname" ) ) && !isdefined( getent( node.target, "targetname" ) ) )
		return true; 
	return false; 
}

vehicle_paths()
{
	pathstart = self.attachedpath; 
	self.currentNode = self.attachedpath; 

	if( !isdefined( pathstart ) )
		return; 

	pathpoint = pathstart; 
	arraycount = 0; 
	pathpoints = []; 
	self endon( "newpath" );

	while( isdefined( pathpoint ) )
	{
		pathpoints[ arraycount ] = pathpoint; 
		arraycount ++ ; 

		if( isdefined( pathpoint.target ) )
			pathpoint = getvehiclenode( pathpoint.target, "targetname" );
		else
			break; 
	}
	arraycount = undefined; 

	pathpoint = pathstart; 
	for( i = 0; i < pathpoints.size; i ++ )
	{
		node = pathpoints[ i ]; 
		self setWaitNode( node );
		self waittill( "reached_wait_node" );
		if( !isdefined( self ) )
			return; 

		self.currentNode = node; 

		if( isdefined( node.gateopen ) && !node.gateopen )
		{
			 // threaded because vehicle may setspeed( 0, 15 ) and run into the next node
			self thread path_gate_wait_till_open( node );
		}

		 // the sweet stuff! Pathpoints handled in script as triggers!
		node notify( "trigger", self );

	}
}

vehicle_dynamicpathsvehicle( node, bwaitforstart ) // for helicopters
{
	self endon( "death" );
	self notify( "newpath" );
	if( isdefined( node ) )
		self.attachedpath = node; 
	if( !isdefined( bwaitforstart ) )
		bwaitforstart = false; 
	pathstart = self.attachedpath; 
	self.currentNode = self.attachedpath; 
	if( !isdefined( pathstart ) )
		return; 
	pathpoint = pathstart; 
	arraycount = 0; 
	pathpoints = []; 
	detourpath = undefined; 
	self endon( "newpath" );
	while( isdefined( pathpoint ) )
	{
		pathpoints[ arraycount ] = pathpoint; 
		arraycount ++ ; 
		if( isdefined( pathpoint.target ) )
			pathpoint = getent( pathpoint.target, "targetname" );
		else
			break; 
	}
	pathpoint = pathstart; 
	if( bwaitforstart )
		self waittill( "start_dynamicpath" );
	for( i = 0; i < pathpoints.size; i ++ )
	{
		if( isdefined( pathpoints[ i ].script_unload ) && isdefined( self.fastropeoffset ) )
		{
			pathpoints[ i ].radius = 2; 
			pathpoints[ i ].origin = groundpos( pathpoints[ i ].origin ) + ( 0, 0, self.fastropeoffset );
 // 			self sethoverparams( 3, 1, .5 ); // TODO, bug engineering. get them to make 0 level the helicopter off better.
			self sethoverparams( 0 ); // TODO, bug engineering. get them to make 0 level the helicopter off better.
		}

		if(( isdefined( pathpoints[ i - 1 ] ) ) && ( isdefined( pathpoints[ i - 1 ].speed ) ) )
		{
			accel = 25; 
			if( accel > pathpoints[ i - 1 ].speed )
				accel = ( pathpoints[ i - 1 ].speed / 4 );
			self setSpeed( pathpoints[ i - 1 ].speed, accel );
		}

		self setvehgoalnode( pathpoints[ i ] );

		if( isdefined( pathpoints[ i ].radius ) )
		{
			self setNearGoalNotifyDist( pathpoints[ i ].radius );
			assertex( pathpoints[ i ].radius > 0, "radius: " + pathpoints[ i ].radius );
			self waittill_any( "near_goal", "goal" );
		}
		else
		{
			self waittill( "goal" );
			 // self waittill_any( "near_goal", "goal" );
		}

		if( isdefined( pathpoints[ i ].script_stopnode ) )
			if( pathpoints[ i ].script_stopnode )
				self notify( "reached_stop_node" );

		 // todo handle nodes with angles for strafeing and all that cool stuff
		if( !isdefined( self ) )
			return; 

		self.currentNode = pathpoints[ i ]; 

		if( isdefined( pathpoints[ i ].gateopen ) && !pathpoints[ i ].gateopen )
			self thread path_gate_wait_till_open( pathpoints[ i ] ); // threaded because vehicle may setspeed( 0, 15 ) and run into the next node

		pathpoints[ i ] notify( "trigger", self ); // the sweet stuff! Pathpoints handled in script as triggers!

		if( isdefined( pathpoints[ i ].script_unload ) && isdefined( self.fastropeoffset ) )
			return; // script_unload nodes will resume the path.
	}
}

setvehgoalnode( node, stop, radius )
{
	self endon( "death" );

	stop = false; 
	if( !isdefined( stop ) )
		stop = true; 
	if( isdefined( node.script_stopnode ) ) // z: stop at nodes if there is a script_stopnode = 1 value
		stop = node.script_stopnode; 

	if( isdefined( node.script_unload ) )
		stop = true; 

	if( isdefined( node.script_anglevehicle ) )
		self forcetarget( node );
	else
		self unforcetarget();
	self setvehgoalpos_wrap( node.origin, stop ); // Z: second param = false dont stop at each node.
}

forcetarget( node )
{
	 // [ 14:45 ] [ jiesang - ?? ]: lookat entity > goalyaw > targetyaw

	self cleargoalyaw(); // clear this thing
	self clearlookatent(); // clear that other thing
	self settargetyaw( node.angles[ 1 ] );



}

unforcetarget()
{
	self cleargoalyaw(); // clear this thing
	self clearlookatent(); // clear that other thing
	self cleartargetyaw(); // clear the stuff
}


debug_vehicledetour( start, end )
{
	 /#
	self notify( "newdetour" );
	self endon( "newdetour" );
	self endon( "death" );
	while( getdvar( "debug_vehicledetour" ) != "off" )
	{
		print3d( self.origin + ( 0, 0, 128 ), "vehicle_detourpaths group: " + start.script_vehicledetour, ( 1, 1, 1 ), 1, 2 );
		line( start.origin, end.origin, ( 1, 1, 1 ), 1 );
		line( self.origin, start.origin, ( 1, 1, 1 ), 1 );
		wait .05; 
	}
	#/ 
}

deathrollon()
{
	if( self.health > 0 )
		self.rollingdeath = 1; 
}

deathrolloff()
{
	self.rollingdeath = undefined; 
	self notify( "deathrolloff" );
}

getonpath()
{
	theone = undefined; 
	type = self.vehicletype; 
	if( isdefined( self.target ) )
	{
		theone = getvehiclenode( self.target, "targetname" );
		if( !isdefined( theone ) )
		{
			theone = getent( self.target, "targetname" );
			self.bpathisdynamic = true; 
		}
	}
	if( !isdefined( theone ) )
		return; 
	self.attachedpath = theone; 
	self.origin = theone.origin; 
	if( !self.bpathisdynamic )
		self attachpath( theone );
	else if( isdefined( theone.speed ) )
		self setspeed( theone.speed, 20, 10 );
	else
		self setspeed( 60, 20, 10 );
	self disconnectpaths();

	if( !self.bpathisdynamic )
		self thread vehicle_paths();
	else
		self thread vehicle_dynamicpath( undefined, true );

}

create_vehicle_from_spawngroup_and_gopath( spawnGroup )
{
	vehicleArray = maps\_vehicle::scripted_spawn( spawnGroup );
	for( i = 0; i < vehicleArray.size; i ++ )
		level thread maps\_vehicle::gopath( vehicleArray[ i ] );
	return vehicleArray; 
}

gopath( vehicle )
{
	if( !isdefined( vehicle ) )
		println( "go path called on non existant vehicle" );

	if( isdefined( vehicle.script_vehiclestartmove ) )
		level.vehicle_StartMoveGroup[ vehicle.script_vehiclestartmove ] = array_remove( level.vehicle_StartMoveGroup[ vehicle.script_vehiclestartmove ], vehicle );
	vehicle endon( "death" );
	if( isdefined( vehicle.hasstarted ) )
	{
		println( "vehicle already moving when triggered with a startmove" );
		return; 
	}
	else
		vehicle.hasstarted = true; 

	if( isdefined( vehicle.script_delay ) )
		wait vehicle.script_delay; 

	vehicle notify( "start_vehiclepath" );

	if( !vehicle.bpathisdynamic )
		vehicle startpath();
	else
		vehicle notify( "start_dynamicpath" );
		
	 // next game, remove from here down this isn't the place to do such things.
	
	wait .05; 
	vehicle connectpaths();
	vehicle waittill( "reached_end_node" );

	vehicle disconnectpaths();

	if( isdefined( vehicle.currentnode.script_noteworthy ) && vehicle.currentnode.script_noteworthy == "deleteme" )
		return; 

	if( isdefined( vehicle.script_unloaddelay ) )
		vehicle thread dounload( vehicle.script_unloaddelay );
	else
		vehicle notify( "unload" );

}

dounload( delay )
{
	self endon( "unload" );

	if( delay <= 0 )
		return; 

	wait delay; 

	self notify( "unload" );
}

path_gate_open( node )
{
	node.gateopen = true; 
	node notify( "gate opened" );
}

path_gate_wait_till_open( pathspot )
{
	self endon( "death" );
	self.waitingforgate = true; 
	self vehicle_setspeed( 0, 15, "path gate closed" );
	pathspot waittill( "gate opened" );
	self.waitingforgate = false; 
	if( self.health > 0 )
		script_resumespeed( "gate opened", level.vehicle_ResumeSpeed );
}

spawner_setup( vehicles, message, from )
{

	script_vehiclespawngroup = message; 

	if( !isdefined( level.vehicleSpawners ) )
		level.vehicleSpawners = []; 

	level.vehicleSpawners[ script_vehiclespawngroup ] = []; 

	vehicle = [];  // vehicle is an array of vehiclegroup array's
	for( i = 0; i < vehicles.size; i ++ )
	{
		if( !isdefined( vehicle[ script_vehiclespawngroup ] ) )
			vehicle[ script_vehiclespawngroup ] = []; 


		script_origin = spawn( "script_origin", vehicles[ i ].origin );

		 // creates struct that copies certain values from the vehicle to be added when the vehicle is spawned.
		script_origin setspawnervariables( vehicles[ i ], from );
		vehicle[ script_vehiclespawngroup ][ vehicle[ script_vehiclespawngroup ].size ] = script_origin; 
		level.vehicleSpawners[ script_vehiclespawngroup ][ i ] = script_origin; 

	}
	while( 1 )
	{
		spawnedvehicles = []; 
		level waittill( "spawnvehiclegroup" + message );
		for( i = 0; i < vehicle[ script_vehiclespawngroup ].size; i ++ )
			spawnedvehicles[ spawnedvehicles.size ] = vehicle_spawn( vehicle[ script_vehiclespawngroup ][ i ] );
		level notify( "vehiclegroup spawned" + message, spawnedvehicles );
	}
}

scripted_spawn( group )
{
	thread scripted_spawn_go( group );
	level waittill( "vehiclegroup spawned" + group, vehicles );
	return vehicles; 
}

scripted_spawn_go( group )
{
	waittillframeend; 
	level notify( "spawnvehiclegroup" + group );
}

setspawnervariables( vehicle, from )
{
 // 	self.spawnerclassname = vehicle.classname; 
	self.spawnermodel = vehicle.model; 
	self.angles = vehicle.angles; 
	self.origin = vehicle.origin; 
	if( isdefined( vehicle.script_delay ) )
		self.script_delay = vehicle.script_delay; 
	if( isdefined( vehicle.script_noteworthy ) )
		self.script_noteworthy = vehicle.script_noteworthy; 
	if( isdefined( vehicle.script_parameters ) )
		self.script_parameters = vehicle.script_parameters; 
	if( isdefined( vehicle.script_team ) )
		self.script_team = vehicle.script_team; 
	if( isdefined( vehicle.script_vehicleride ) )
		self.script_vehicleride = vehicle.script_vehicleride; 
	if( isdefined( vehicle.target ) )
	{
		self.target = vehicle.target; 
		struct = getstruct( vehicle.target, "targetname" );
		if( isdefined( struct ) )
		{
			add_flags_from_chain( struct );
		}
	}
	if( isdefined( vehicle.targetname ) )
		self.targetname = vehicle.targetname; 
	else
		self.targetname = "notdefined"; 
		self.spawnedtargetname = self.targetname; 

	self.targetname = self.targetname + "_vehiclespawner"; 
	if( isdefined( vehicle.triggeredthink ) )
		self.triggeredthink = vehicle.triggeredthink; 
	if( isdefined( vehicle.script_sound ) )
		self.script_sound = vehicle.script_sound; 
	if( isdefined( vehicle.script_turretmg ) )
		self.script_turretmg = vehicle.script_turretmg; 
	if( isdefined( vehicle.script_startinghealth ) )
		self.script_startinghealth = vehicle.script_startinghealth; 
	if( isdefined( vehicle.spawnerNum ) )
		self.spawnerNum = vehicle.spawnerNum; 
	if( isdefined( vehicle.script_deathnotify ) )
		self.script_deathnotify = vehicle.script_deathnotify; 
	if( isdefined( vehicle.script_turret ) )
		self.script_turret = vehicle.script_turret; 
	if( isdefined( vehicle.script_linkTo ) )
		self.script_linkTo = vehicle.script_linkTo; 
	if( isdefined( vehicle.script_VehicleSpawngroup ) )
		self.script_VehicleSpawngroup = vehicle.script_VehicleSpawngroup; 
	if( isdefined( vehicle.script_VehicleStartMove ) )
		self.script_VehicleStartMove = vehicle.script_VehicleStartMove; 
	if( isdefined( vehicle.script_vehicleGroupDelete ) )
		self.script_vehicleGroupDelete = vehicle.script_vehicleGroupDelete; 
	if( isdefined( vehicle.script_nomg ) )
		self.script_nomg = vehicle.script_nomg; 
	if( isdefined( vehicle.script_badplace ) )
		self.script_badplace = vehicle.script_badplace; 
	if( isdefined( vehicle.script_vehicleride ) )
		self.script_vehicleride = vehicle.script_vehicleride; 
	if( isdefined( vehicle.script_vehiclewalk ) )
		self.script_vehiclewalk = vehicle.script_vehiclewalk; 
	if( isdefined( vehicle.script_linkName ) )
		self.script_linkName = vehicle.script_linkName; 
	if( isdefined( vehicle.script_crashtypeoverride ) )
		self.script_crashtypeoverride = vehicle.script_crashtypeoverride; 
	if( isdefined( vehicle.script_unloaddelay ) )
		self.script_unloaddelay = vehicle.script_unloaddelay; 
	if( isdefined( vehicle.script_unloadmgguy ) )
		self.script_unloadmgguy = vehicle.script_unloadmgguy; 
	if( isdefined( vehicle.script_keepdriver ) )
		self.script_keepdriver = vehicle.script_keepdriver; 
	if( isdefined( vehicle.script_fireondrones ) )
		self.script_fireondrones = vehicle.script_fireondrones; 
	if( isdefined( vehicle.script_tankgroup ) )
		self.script_tankgroup = vehicle.script_tankgroup; 
	if( isdefined( vehicle.script_avoidplayer ) )
		self.script_avoidplayer = vehicle.script_avoidplayer; 
	if( isdefined( vehicle.script_playerconeradius ) )
		self.script_playerconeradius = vehicle.script_playerconeradius; 
	if( isdefined( vehicle.script_cobratarget ) )
		self.script_cobratarget = vehicle.script_cobratarget; 
	if( isdefined( vehicle.script_targettype ) )
		self.script_targettype = vehicle.script_targettype; 
	if( isdefined( vehicle.script_targetoffset_z ) )
		self.script_targetoffset_z = vehicle.script_targetoffset_z; 
	if( isdefined( vehicle.script_wingman ) )
		self.script_wingman = vehicle.script_wingman; 
	if( isdefined( vehicle.script_mg_angle ) )
		self.script_mg_angle = vehicle.script_mg_angle; 
	if( isdefined( vehicle.script_physicsjolt ) )
		self.script_physicsjolt = vehicle.script_physicsjolt; 
	if( isdefined( vehicle.script_vehicle_lights_on ) )
		self.script_vehicle_lights_on = vehicle.script_vehicle_lights_on; 
	if( isdefined( vehicle.script_light_toggle ) )
		self.script_light_toggle = vehicle.script_light_toggle; 

	if( isdefined( vehicle.script_cheap ) )
		self.script_cheap = vehicle.script_cheap; 
	
	if( vehicle.count > 0 )
		self.count = vehicle.count; 
	else
		self.count = 1; 


	if( isdefined( vehicle.vehicletype ) )
		self.vehicletype = vehicle.vehicletype; 
	else
		self.vehicletype = maps\_vehicletypes::get_type( vehicle.model );
	vehicle delete();
	
	id = "spawnid" + int( self.origin[ 0 ] ) + "a" + int( self.origin[ 1 ] ) + "a" + int( self.origin[ 2 ] );
	self.spawner_id = id; 
	level.vehicle_spawners[ id ] = self; 
}

vehicle_spawn( vspawner, from )
{
	if( !vspawner.count )
		return; 


	vehicle = spawnVehicle( vspawner.spawnermodel, vspawner.spawnedtargetname, vspawner.vehicletype, vspawner.origin, vspawner.angles );
	if( isdefined( vspawner.script_delay ) )
		vehicle.script_delay = vspawner.script_delay; 
	if( isdefined( vspawner.script_noteworthy ) )
		vehicle.script_noteworthy = vspawner.script_noteworthy; 
	if( isdefined( vspawner.script_parameters ) )
		vehicle.script_parameters = vspawner.script_parameters; 
	if( isdefined( vspawner.script_team ) )
		vehicle.script_team = vspawner.script_team; 
	if( isdefined( vspawner.script_vehicleride ) )
		vehicle.script_vehicleride = vspawner.script_vehicleride; 
	if( isdefined( vspawner.target ) )
		vehicle.target = vspawner.target; 
	if( isdefined( vspawner.vehicletype ) )
		vehicle.vehicletype = vspawner.vehicletype; 
	if( isdefined( vspawner.triggeredthink ) )
		vehicle.triggeredthink = vspawner.triggeredthink; 
	if( isdefined( vspawner.script_sound ) )
		vehicle.script_sound = vspawner.script_sound; 
	if( isdefined( vspawner.script_turretmg ) )
		vehicle.script_turretmg = vspawner.script_turretmg; 
	if( isdefined( vspawner.script_startinghealth ) )
		vehicle.script_startinghealth = vspawner.script_startinghealth; 
	if( isdefined( vspawner.script_deathnotify ) )
		vehicle.script_deathnotify = vspawner.script_deathnotify; 
	if( isdefined( vspawner.script_turret ) )
		vehicle.script_turret = vspawner.script_turret; 
	if( isdefined( vspawner.script_linkTo ) )
		vehicle.script_linkTo = vspawner.script_linkTo; 
	if( isdefined( vspawner.script_VehicleSpawngroup ) )
		vehicle.script_VehicleSpawngroup = vspawner.script_VehicleSpawngroup; 
	if( isdefined( vspawner.script_VehicleStartMove ) )
		vehicle.script_VehicleStartMove = vspawner.script_VehicleStartMove; 
	if( isdefined( vspawner.script_vehicleGroupDelete ) )
		vehicle.script_vehicleGroupDelete = vspawner.script_vehicleGroupDelete; 
	if( isdefined( vspawner.script_nomg ) )
		vehicle.script_nomg = vspawner.script_nomg; 
	if( isdefined( vspawner.script_badplace ) )
		vehicle.script_badplace = vspawner.script_badplace; 
	if( isdefined( vspawner.script_vehicleride ) )
		vehicle.script_vehicleride = vspawner.script_vehicleride; 
	if( isdefined( vspawner.script_vehiclewalk ) )
		vehicle.script_vehiclewalk = vspawner.script_vehiclewalk; 
	if( isdefined( vspawner.script_linkName ) )
		vehicle.script_linkName = vspawner.script_linkName; 
	if( isdefined( vspawner.script_crashtypeoverride ) )
		vehicle.script_crashtypeoverride = vspawner.script_crashtypeoverride; 
	if( isdefined( vspawner.script_unloaddelay ) )
		vehicle.script_unloaddelay = vspawner.script_unloaddelay; 
	if( isdefined( vspawner.script_unloadmgguy ) )
		vehicle.script_unloadmgguy = vspawner.script_unloadmgguy; 
	if( isdefined( vspawner.script_keepdriver ) )
		vehicle.script_keepdriver = vspawner.script_keepdriver; 
	if( isdefined( vspawner.script_fireondrones ) )
		vehicle.script_fireondrones = vspawner.script_fireondrones; 
	if( isdefined( vspawner.script_tankgroup ) )
		vehicle.script_tankgroup = vspawner.script_tankgroup; 
	if( isdefined( vspawner.script_avoidplayer ) )
		vehicle.script_avoidplayer = vspawner.script_avoidplayer; 
	if( isdefined( vspawner.script_playerconeradius ) )
		vehicle.script_playerconeradius = vspawner.script_playerconeradius; 
	if( isdefined( vspawner.script_cobratarget ) )
		vehicle.script_cobratarget = vspawner.script_cobratarget; 
	if( isdefined( vspawner.script_targettype ) )
		vehicle.script_targettype = vspawner.script_targettype; 
	if( isdefined( vspawner.script_targetoffset_z ) )
		vehicle.script_targetoffset_z = vspawner.script_targetoffset_z; 
	if( isdefined( vspawner.script_wingman ) )
		vehicle.script_wingman = vspawner.script_wingman; 
	if( isdefined( vspawner.script_mg_angle ) )
		vehicle.script_mg_angle = vspawner.script_mg_angle; 
	if( isdefined( vspawner.script_physicsjolt ) )
		vehicle.script_physicsjolt = vspawner.script_physicsjolt; 
	if( isdefined( vspawner.script_cheap ) )
		vehicle.script_cheap = vspawner.script_cheap; 
	if( isdefined( vspawner.script_vehicle_lights_on ) )
		vehicle.script_vehicle_lights_on = vspawner.script_vehicle_lights_on; 
	if( isdefined( vspawner.script_light_toggle ) )
		vehicle.script_light_toggle = vspawner.script_light_toggle; 
	if( isdefined( vspawner.spawner_id ) )
		vehicle.spawner_id = vspawner.spawner_id; 
	


 // 	if( initVehicle )
	vehicle_init( vehicle );

	if( isdefined( vehicle.targetname ) )
		level notify( "new_vehicle_spawned" + vehicle.targetname, vehicle );

	if( isdefined( vehicle.script_noteworthy ) )
        level notify( "new_vehicle_spawned" + vehicle.script_noteworthy, vehicle );

	return vehicle; 
}

waittill_vehiclespawn( targetname )
{
	level waittill( "new_vehicle_spawned" + targetname, vehicle );
	return vehicle; 

}

waittill_vehiclespawn_noteworthy( noteworthy )
{
    level waittill( "new_vehicle_spawned" + noteworthy, vehicle );
    return vehicle; 
}

wait_vehiclespawn( targetname )
{
	println( "wait_vehiclespawn() called; change to waittill_vehiclespawn()" );
	level waittill( "new_vehicle_spawned" + targetname, vehicle );
	return vehicle; 
}

spawn_through( vehicle )
{
	struct = spawnstruct();
	struct  setspawnervariables( vehicle );
	return vehicle_spawn( struct );
}

vehicle_init( vehicle )
{
	if( vehicle.classname == "script_model" )
	{
		vehicle = 	spawn_through( vehicle ); // this sends non - spawned script models through the spawner process to get vehicleinfo.
		return; 
	}

	if( vehicle.vehicletype == "bog_mortar" )
		return; 
	if(( isdefined( vehicle.script_noteworthy ) ) && ( vehicle.script_noteworthy == "playervehicle" ) )
		return; // TODO:  I really don't think we should branch off the players vehicle so early. - nate

	 // TODO: These shouldn't be asigned to everyvehicle
 // 	vehicle.tanksquadfollow = false; 
	vehicle.zerospeed = true; 

	if( !isdefined( vehicle.modeldummyon ) )
		vehicle.modeldummyon = false; 


	type = vehicle.vehicletype; 

	 // give the vehicle health
	vehicle vehicle_life();

	 // set the script_team value used everywhere to determine which team the vehicle belongs to
	vehicle vehicle_setteam();

	 // init pointer is specified in the precache script( IE maps\_tiger::main() )
	 // only special case gag works should exist in this thread, 
	 // I'm currently working to reduce redundancy by moving common init functions here

	if( !isdefined( 	level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ) )
	{
		println( "vehicle.vehicletype is: " + vehicle.vehicletype );
		println( "vehicle.model is: " + vehicle.model );
	}
	
	vehicle thread [ [ level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ] ]();

	vehicle thread maingun_FX();
	vehicle thread playTankExhaust();


 // 	if( !isdefined( vehicle.script_badplace ) )
 // 		vehicle.script_badplace = true; 
	if( !isdefined( vehicle.script_avoidplayer ) )
		vehicle.script_avoidplayer = false; 

	vehicle.riders = []; 
	vehicle.walkers = []; 
	vehicle.unloadque = [];  // for ai. wait till a vehicle is unloaded all the way
	vehicle.unload_group = "default"; 

	vehicle.bpathisdynamic = false; 

	vehicle.getoutrig = []; 
	if( isdefined( level.vehicle_attachedmodels ) && isdefined( level.vehicle_attachedmodels[ type ] ) )
	{
		rigs = level.vehicle_attachedmodels[ type ]; 
		strings = getarraykeys( rigs );
		for( i = 0; i < strings.size; i ++ )
		{
			vehicle.getoutrig[ strings[ i ] ] = false; 
			vehicle.getoutriganimating[ strings[ i ] ] = false; 
		}
	}

	 // avoid running into other vehicles TODO: GET CODE to do this expensive stuff
 // 	if( !vehicle isCheap() )
 // 		vehicle thread vehicle_avoidcolision();

	 // make ai run way from vehicle
	vehicle thread vehicle_badplace();

	 // toggle vehicle lights on / off
	if( isdefined( vehicle.script_vehicle_lights_on ) )
		vehicle thread lights_on( vehicle.script_vehicle_lights_on );

	 // regenerate friendly fire damage
	if( !vehicle isCheap() )
		vehicle thread friendlyfire_shield();

	 // handles guys riding and doing stuff on vehicles
	vehicle thread maps\_vehicle_aianim::handle_attached_guys();

	 // special stuff for unloading
	if( !vehicle isCheap() )
		vehicle thread vehicle_handleunloadevent();

	 // Make the main turret think
	vehicle thread turret_attack_think();

	 // Shellshock player on main turret fire.
	if( !vehicle isCheap() )
		vehicle thread vehicle_shoot_shock(); // moved to indiviual tank scripts.

	 // make the vehicle rumble
	vehicle thread vehicle_rumble();

	 // make vehicle shake physics objects.
	if( isdefined( vehicle.script_physicsjolt ) && vehicle.script_physicsjolt )
		vehicle thread physicsjolt_proximity();

	 // handle tread effects
	vehicle thread vehicle_treads();

	 // handle the compassicon for friendly vehicles
 // 	vehicle thread vehicle_compasshandle();

	 // make the wheels rotate
	vehicle thread animate_drive_idle();

	 // handle machine guns
	if( !vehicle isCheap() )
		vehicle thread mginit();

	if( isdefined( level.vehicleSpawnCallbackThread ) )
		level thread [ [ level.vehicleSpawnCallbackThread ] ]( vehicle );

	 // this got kind of ugly and hackery but it's how I deal with player driveable vehicles in decoytown, elalamein, 88ridge and libya
	if( isdefined( vehicle.spawnflags ) && vehicle.spawnflags & 1 )
	{
		startinvehicle = ( isdefined( vehicle.script_noteworthy ) && vehicle.script_noteworthy == "startinside" ); // can't see making a whole new keys.txt entry for something that's only going to be used once in any given level.
		vehicle maps\_vehicledrive::setup_vehicle_other();
		vehicle thread maps\_vehicledrive::vehicle_wait( startinvehicle );
		vehicle_Levelstuff( vehicle );
		vehicle thread kill();
		return; 
	}

	 // associate vehicle with living level variables.
	vehicle_Levelstuff( vehicle );
	if( isdefined( vehicle.script_team ) )
		vehicle setvehicleteam( vehicle.script_team );

	 // every vehicle that stops will disconnect its paths
	if( !vehicle isCheap() )
		vehicle thread disconnect_paths_whenstopped();

	 // squad behavior
	 // commenting out, nobody uses this
 // 	if( !vehicle isCheap() )
 // 		vehicle thread squad();

	 // get on path and start the path handler thread
	vehicle thread getonpath();

	 // helicopters do dust kickup fx
	if( vehicle hasHelicopterDustKickup() )
		vehicle thread helicopter_dust_kickup();

	 // spawn the vehicle and it's associated ai
	vehicle spawn_group();
	vehicle thread kill();
}

kill_damage( type )
{
	if( !isdefined( level.vehicle_death_radiusdamage ) || !isdefined( level.vehicle_death_radiusdamage[ type ] ) )
		return; 

	if( isdefined( self.deathdamage_max ) )
		maxdamage = self.deathdamage_max; 
	else
		maxdamage = level.vehicle_death_radiusdamage[ type ].maxdamage; 
	if( isdefined( self.deathdamage_min ) )
		mindamage = self.deathdamage_min; 
	else
		mindamage = level.vehicle_death_radiusdamage[ type ].mindamage; 

	if( level.vehicle_death_radiusdamage[ type ].bKillplayer )
		level.player enableHealthShield( false );
	radiusDamage( self.origin + level.vehicle_death_radiusdamage[ type ].offset, level.vehicle_death_radiusdamage[ type ].range, maxdamage, mindamage );
	if( level.vehicle_death_radiusdamage[ type ].bKillplayer )
		level.player enableHealthShield( true );
}

kill()
{
	self endon( "nodeath_thread" );
	type = self.vehicletype; 
	model = self.model; 
	self waittill( "death", attacker );

	 // some tank and turret cleanup

	if( isdefined( self.rumbletrigger ) )
		self.rumbletrigger delete();
	if( isdefined( self.mgturret ) )
		for( i = 0; i < self.mgturret.size; i ++ )
			if( isdefined( self.mgturret[ i ] ) )
				self.mgturret[ i ] delete();

	level.vehicles[ self.script_team ] = array_remove( level.vehicles[ self.script_team ], self );

	 // if vehicle is gone then don't do this stuff
	if( !isdefined( self ) )
		return; 

 // 	if( isdefined( self.script_light_toggle ) && self.script_light_toggle )
 // 		lights_off();

	if( isdefined( self.nospawning ) )
		self.tankgetout = 0; 

	if( isdefined( level.vehicle_rumble[ type ] ) )
		self StopRumble( level.vehicle_rumble[ type ].rumble );


	if( isdefined( level.vehicle_death_thread[ type ] ) )
		thread [ [ level.vehicle_death_thread[ type ] ] ]();

	if( isdefined( level.vehicle_death_earthquake[ type ] ) )
		earthquake
		( 
			level.vehicle_death_earthquake[ type ].scale, 
			level.vehicle_death_earthquake[ type ].duration, 
			self.origin, 
			level.vehicle_death_earthquake[ type ].radius
		 );

	 // does radius damage
	kill_damage( type );

	if( isdefined( level.vehicle_deathmodel[ model ] ) )
		self setmodel( level.vehicle_deathmodel[ model ] );

	 // I used this for identifying when the players tank kills stuff in libya for dialog
	if( isdefined( level.vehicle_deathnotify ) && isdefined( level.vehicle_deathnotify[ self.vehicletype ] ) )
		level notify( level.vehicle_deathnotify[ self.vehicletype ], attacker );

	thread kill_fx( model );
	if( self.health > 0 )
		radiusdamage( self.origin, 30, 10000, 10000 ); // for vehicles notified "death".

	if( isdefined( self.delete_on_death ) )
	{
		wait 0.05; 
		self disconnectpaths();
		self freevehicle();
		wait 0.05; 
		self notify( "death_finished" );
		self delete();
		return; 
	}

	 // all the vehicles get the same jolt...
	self joltbody(( self.origin + ( 23, 33, 64 ) ), 3 );

	 // crazy crashpath stuff.
	if( isdefined( self.script_crashtypeoverride ) )
		crashtype = self.script_crashtypeoverride; 
	else if( self isHelicopter() )
		crashtype = "helicopter"; 
	else if( isdefined( self.currentnode ) && crash_path_check( self.currentnode ) )
		crashtype = "none"; 
	else
		crashtype = "tank";  // tanks used to be the only vehicle that would stop. legacy nonsense from CoD1

	if( crashtype == "helicopter" )
		self thread helicopter_crash();

	if( crashtype == "tank" )
	{
		if( !isdefined( self.rollingdeath ) )
			self vehicle_setspeed( 0, 25, "Dead" );
		else
		{
			self vehicle_setspeed( 8, 25, "Dead rolling out of path intersection" );
			self waittill( "deathrolloff" );
			self vehicle_setspeed( 0, 25, "Dead, finished path intersection" );
		}
		wait .4; 
		self vehicle_setspeed( 0, 10000, "deadstop" );

		self notify( "deadstop" );
		self disconnectpaths();
		if(( isdefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
			self waittill( "animsdone" ); // tankgetout will never get notified if there are no guys getting out
	}
	
	if( isdefined( level.vehicle_hasMainTurret[ model ] ) && level.vehicle_hasMainTurret[ model ] )
		self clearTurretTarget();
	if( self isHelicopter() )
	{
		if(( isdefined( self.crashing ) ) && ( self.crashing == true ) )
			self waittill( "crash_done" );
	}
	else
	{
		while( isdefined( self ) && self getspeedmph() > 0 )
			wait .1; 
	}

	self notify( "stop_looping_death_fx" );
	self notify( "death_finished" );

	wait .5; 

	if(( isdefined( self ) ) )
		self freevehicle();
	if(( isdefined( self.crashing ) ) && ( self.crashing == true ) )
		self delete();
}

helicopter_crash()
{
	self.crashing = true; 

	if( isdefined( self.unloading ) )
	{
		while( isdefined( self.unloading ) )
			wait 0.05; 
	}

	if( !isdefined( self ) )
		return; 

	self thread helicopter_crash_move();
}

helicopter_crash_move()
{
	 // get the nearest unused crash location
	assertEx( level.helicopter_crash_locations.size > 0, "A helicopter tried to crash but you didn't have any script_origins with targetname helicopter_crash_location in the level" );
	crashLoc = undefined; 
	unusedLocations = []; 
	for( i = 0; i < level.helicopter_crash_locations.size; i ++ )
	{
		if( isdefined( level.helicopter_crash_locations[ i ].claimed ) )
			continue; 
		unusedLocations[ unusedLocations.size ] = level.helicopter_crash_locations[ i ]; 
	}
	assertEx( unusedLocations.size > 0, "You dont have enough script_origins with targetname helicopter_crash_location in the level" );
	crashLoc = getclosest( self.origin, unusedLocations );
	assert( isdefined( crashLoc ) );
	crashLoc.claimed = true; 
	
	 // make the chopper spin around
	self thread helicopter_crash_rotate();
	
	 // move chopper closer to crash point
	self setSpeed( 40, 10, 10 );
	self setNearGoalNotifyDist( 300 );
	self setvehgoalpos(( crashLoc.origin[ 0 ], crashLoc.origin[ 1 ], self.origin[ 2 ] ), 1 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( crashLoc.origin, 1 );
	self waittill( "goal" );
	crashLoc.claimed = undefined; 
	
	self notify( "crash_done" );
}

helicopter_crash_rotate()
{
	self endon( "crash_done" );
	
	self setyawspeed( 400, 100, 100 );
	for( ;; )
	{
		self setTargetYaw( self.angles[ 1 ] + 90 );
		wait 0.5; 
	}
}

crash_path_check( node )
{
	 // find a crashnode on the current path
	 // this only works on ground info_vehicle_node vheicles. not dynamic helicopter script_origin paths. they have their own dynamic crashing.
	targ = node; 
	while( isdefined( targ ) )
	{
		if(( isdefined( targ.detoured ) ) && ( targ.detoured == 0 ) )
		{
			detourpath = path_detour_get_detourpath( getvehiclenode( targ.target, "targetname" ) );
			if( isdefined( detourpath ) && isdefined( detourpath.script_crashtype ) )
	 			return true; 
		}
		if( isdefined( targ.target ) )
			targ = getvehiclenode( targ.target, "targetname" );
		else
			targ = undefined; 
	}
	return false; 

}

death_firesound( sound )
{
	self thread play_loop_sound_on_tag( sound );
	self waittill_any( "death", "fire_extinguish", "stop_crash_loop_sound" );
	self notify( "stop sound" + sound );
}

prekill_fx( model )
{
	type = self.vehicletype; 
	for( i = 0; i < level.vehicle_predeath_fx[ type ].size; i ++ )
	{
		struct = level.vehicle_predeath_fx[ type ][ i ]; 
		thread kill_fx_thread( model, struct, type );
	}
}

kill_fx( model )
{
	 // going to use vehicletypes for identifying a vehicles association with effects.
	 // will add new vehicle types if vehicle is different enough that it needs to use
	 // different effect. also handles the sound

	 // all of these effects will end when the vehicle is notified( "fire_extinguish" );

	if( self isdestructible() )
		return;
	level notify( "vehicle_explosion", self.origin );
	type = self.vehicletype; 
	for( i = 0; i < level.vehicle_death_fx[ type ].size; i ++ )
	{
		struct = level.vehicle_death_fx[ type ][ i ]; 
		thread kill_fx_thread( model, struct, type );
	}
}

kill_fx_thread( model, struct, type )
{
	assert( isdefined( struct ) );
	if( isdefined( struct.waitDelay ) )
	{
		if( struct.waitDelay >= 0 )
		wait struct.waitDelay; 
		else
			self waittill( "death_finished" );
	}

	if( isdefined( struct.notifyString ) )
		self notify( struct.notifyString );

	if( isdefined( struct.effect ) )
	{
		if(( struct.bEffectLooping ) && ( !isdefined( self.delete_on_death ) ) )
		{
			if( isdefined( struct.tag ) )
			{
				if(( isdefined( struct.stayontag ) ) && ( struct.stayontag == true ) )
					thread loop_fx_on_vehicle_tag( struct.effect, struct.delay, struct.tag );
				else
					thread playLoopedFxontag( struct.effect, struct.delay, struct.tag );
			}
			else
			{
				forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin; 
				playfx( struct.effect, self.origin, forward );
			}
		}
		else if( isdefined( struct.tag ) )
			playfxontag( struct.effect, self, struct.tag );
		else
		{
			forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin; 
			playfx( struct.effect, self.origin, forward );
		}
	}

	if(( isdefined( struct.sound ) ) && ( !isdefined( self.delete_on_death ) ) )
	{
		if( struct.bSoundlooping )
			thread death_firesound( struct.sound );
		else
			self playsound( struct.sound );
	}
}

loop_fx_on_vehicle_tag( effect, loopTime, tag )
{
	assert( isdefined( effect ) );
	assert( isdefined( tag ) );
	assert( isdefined( loopTime ) );

	self endon( "stop_looping_death_fx" );

	while( isdefined( self ) )
	{
		playfxontag( effect, self, tag );
		wait loopTime; 
	}
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_radiusdamage( < offset > , < range > , < maxdamage > , < mindamage > , < bKillplayer > )"
"Summary: called in individual vehicle file - define amount of radius damage to be set on each vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < health > :  health"
"MandatoryArg: < offset > : worldspace offset vector, usually goes up"
"MandatoryArg: < range > : randomly chooses between the minhealth, maxhealth"
"MandatoryArg: < maxdamage > : randomly chooses between the minhealth, maxhealth"
"MandatoryArg: < mindamage > : randomly chooses between the minhealth, maxhealth"
"MandatoryArg: < bKillplayer > : true / false: kills player"
"Example: 			build_radiusdamage(( 0, 0, 53 ), 512, 300, 20, false );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_radiusdamage( offset, range, maxdamage, mindamage, bKillplayer )
{
	if( !isdefined( level.vehicle_death_radiusdamage ) )
		level.vehicle_death_radiusdamage = []; 
	if( !isdefined( bKillplayer ) )
		bKillplayer = false; 
	if( !isdefined( offset ) )
		offset = ( 0, 0, 0 );
	struct = spawnstruct();
	struct.offset = offset; 
	struct.range = range; 
	struct.maxdamage = maxdamage; 
	struct.mindamage = mindamage; 
	struct.bKillplayer = bKillplayer; 
	level.vehicle_death_radiusdamage[ level.vttype ] = struct; 
}


 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_rumble( < rumble > , < scale > , < duration > , < radius > , < basetime > , < randomaditionaltime > )"
"Summary: called in individual vehicle file - define amount of radius damage to be set on each vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < rumble > :  rumble asset"
"MandatoryArg: < scale > : scale"
"MandatoryArg: < duration > : duration"
"MandatoryArg: < radius > : radius"
"MandatoryArg: < basetime > : time to wait between rumbles"
"MandatoryArg: < randomaditionaltime > : random amount of time to add to basetime"
"Example: 			build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_rumble( rumble, scale, duration, radius, basetime, randomaditionaltime )
{
	if( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = []; 
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	assert( isdefined( rumble ) );
	precacherumble( rumble );
	struct.rumble = rumble; 
	level.vehicle_rumble[ level.vttype ] = struct; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_deathquake( < scale > , < duration > , < radius > )"
"Summary: called in individual vehicle file - define amount of radius damage to be set on each vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < scale > : scale"
"MandatoryArg: < duration > : duration"
"MandatoryArg: < radius > : radius"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_deathquake( scale, duration, radius, basetime, randomaditionaltime )
{
	if( !isdefined( level.vehicle_death_earthquake ) )
		level.vehicle_death_earthquake = []; 
	if( !isdefined( level.vehicle_death_earthquake[ level.vttype ] ) )
		level.vehicle_death_earthquake[ level.vttype ] = []; 
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	level.vehicle_death_earthquake[ level.vttype ][ level.vehicle_death_earthquake[ level.vttype ].size ] = struct; 
}

build_quake( scale, duration, radius, basetime, randomaditionaltime )
{
	struct = spawnstruct();
	struct.scale = scale; 
	struct.duration = duration; 
	struct.radius = radius; 
	if( isdefined( basetime ) )
		struct.basetime = basetime; 
	if( isdefined( randomaditionaltime ) )
		struct.randomaditionaltime = randomaditionaltime; 
	return struct; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_predeathfx( < effect > , < tag > , < sound > , < bEffectLooping > , < delay > , < bSoundlooping > , < waitDelay > , < stayontag > , < notifyString > )"
"Summary: called in individual vehicle file - death effects on vehicles, usually multiple lines for multistaged / multitagged sequences"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < effect > :  effect to play on death"
"OptionalArg: < tag > : tag to play the effect on"
"OptionalArg: < sound > : "  sound to play with effect
"OptionalArg: < bEffectLooping > : play it old fashioned loop style"
"OptionalArg: < delay > : old fashioned loop time"
"OptionalArg: < bSoundlooping > : true / false:  sound loops "
"OptionalArg: < waitDelay > : wait this long after death to start this effect sequence"
"OptionalArg: < stayontag > : playfxontag"
"OptionalArg: < notifyString > : notifies vehicle this when effect starts"
"Example: 			build_predeathfx( "explosions / aerial_explosion", 		"tag_deathfx", 		"hind_helicopter_hit" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_predeathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
{
	if( !isdefined( level.vehicle_predeath_fx ) )
		level.vehicle_predeath_fx = []; 
	if( !isdefined( level.vehicle_predeath_fx[ level.vttype ] ) )
		level.vehicle_predeath_fx[ level.vttype ] = []; 
	level.vehicle_predeath_fx[ level.vttype ][ level.vehicle_predeath_fx[ level.vttype ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString );
}

build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
{
	if( !isdefined( bSoundlooping ) )
		bSoundlooping = false; 
	if( !isdefined( bEffectLooping ) )
		bEffectLooping = false; 
	if( !isdefined( delay ) )
		delay = 1; 
	struct = spawnstruct();
	struct.effect = loadfx( effect );
	struct.tag = tag; 
	struct.sound = sound; 
	struct.bSoundlooping = bSoundlooping; 
	struct.delay = delay; 
	struct.waitDelay = waitDelay; 
	struct.stayontag = stayontag; 
	struct.notifyString = notifyString; 
	struct.bEffectLooping = bEffectLooping; 
	return struct; 
}


 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_deathfx_override( < type > , < effect > , < tag > , < sound > , < bEffectLooping > , < delay > , < bSoundlooping > , < waitDelay > , < stayontag > , < notifyString > )"
"Summary: called in individual vehicle file - death effects on vehicles, usually multiple lines for multistaged / multitagged sequences"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < type > : vehicle type to override the effect of"
"MandatoryArg: < effect > :  effect to play on death"
"OptionalArg: < tag > : tag to play the effect on"
"OptionalArg: < sound > : "  sound to play with effect
"OptionalArg: < bEffectLooping > : play it old fashioned loop style"
"OptionalArg: < delay > : old fashioned loop time"
"OptionalArg: < bSoundlooping > : true / false:  sound loops "
"OptionalArg: < waitDelay > : wait this long after death to start this effect sequence"
"OptionalArg: < stayontag > : playfxontag"
"OptionalArg: < notifyString > : notifies vehicle this when effect starts"
"Example: 			build_deathfx( "explosions / large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_deathfx_override( type, effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
{
	
	level.vttype = type; 
	level.vehicle_death_fx_override[ type ] = true; 
	build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString );
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_deathfx( < effect > , < tag > , < sound > , < bEffectLooping > , < delay > , < bSoundlooping > , < waitDelay > , < stayontag > , < notifyString > )"
"Summary: called in individual vehicle file - death effects on vehicles, usually multiple lines for multistaged / multitagged sequences"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < effect > :  effect to play on death"
"OptionalArg: < tag > : tag to play the effect on"
"OptionalArg: < sound > : sound to play with effect"
"OptionalArg: < bEffectLooping > : play it old fashioned loop style. Set this to true or undefined"
"OptionalArg: < delay > : old fashioned loop time in seconds"
"OptionalArg: < bSoundlooping > : true / false:  sound loops"
"OptionalArg: < waitDelay > : wait this long after death to start this effect sequence"
"OptionalArg: < stayontag > : playfxontag"
"OptionalArg: < notifyString > : notifies vehicle this when effect starts"
"Example: 			build_deathfx( "explosions / large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
{
	assertEx( isdefined( effect ), "Failed to build death effect because there is no effect specified for the model used for that vehicle." );
	type = level.vttype; 
	if( 
			isdefined( level.vehicle_death_fx_override ) 
			 && isdefined( level.vehicle_death_fx_override[ type ] )
			 && level.vehicle_death_fx_override[ type ] 
			 )
		return;  // build_deathfx already defined by override. keeps death effects from loading twice.

	if( !isdefined( level.vehicle_death_fx[ type ] ) )
		level.vehicle_death_fx[ type ] = []; 
	level.vehicle_death_fx[ type ][ level.vehicle_death_fx [ type ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString );
}

get_script_modelvehicles()
{
	array = []; 
	models = getentarray( "script_model", "classname" );
	for( i = 0; i < models.size; i ++ )
	{
		if( isdefined( models[ i ].targetname ) && models[ i ].targetname == "destructible" )
			continue; 
		if( maps\_vehicletypes::is_type( models[ i ].model ) ) 
		{
			array[ array.size ] = models[ i ]; 
			models[ i ].vehicletype = maps\_vehicletypes::get_type( models[ i ].model );			
		}
			
	}
	return array; 
}

precache_scripts()
{
	 // find all the vehicles in the level and initialize precaching( calling of vehicles main() mostly )
	allvehiclesprespawn = []; 
	vehicles = getentarray( "script_vehicle", "classname" );
 // 	vehicles = array_combine( vehicles, getentarray( "vehiclespawnmodel", "targetname" ) );
	vehicles = array_combine( vehicles, get_script_modelvehicles() );

	level.needsprecaching = []; 
	playerdrivablevehicles = []; 
	allvehiclesprespawn = []; 
	if( !isdefined( level.vehicleInitThread ) )
		level.vehicleInitThread = []; 

	for( i = 0; i < vehicles.size; i ++ )
	{
		vehicles[ i ].vehicletype = tolower( vehicles[ i ].vehicletype );
		if( vehicles[ i ].vehicletype == "bog_mortar" )
			continue; 

		if( isdefined( vehicles[ i ].spawnflags ) && vehicles[ i ].spawnflags & 1 )
			playerdrivablevehicles[ playerdrivablevehicles.size ] = vehicles[ i ]; 

		allvehiclesprespawn[ allvehiclesprespawn.size ] = vehicles[ i ]; 

		if( !isdefined( level.vehicleInitThread[ vehicles[ i ].vehicletype ] ) )
			level.vehicleInitThread[ vehicles[ i ].vehicletype ] = []; 


		loadstring = "maps\\\_" + vehicles[ i ].vehicletype + "::main( \"" + vehicles[ i ].model + "\" );"; 

		if( level.bScriptgened )
			script_gen_dump_addline( loadstring, vehicles[ i ].model ); // adds to scriptgendump using model as signature for lookup

		precachesetup( loadstring, vehicles[ i ] );

	}

	if( !level.bScriptgened && level.needsprecaching.size > 0 )
	{
		println( " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		println( " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		println( " -- -- - add these lines to your level script above maps\\\_load::main(); -- -- -- -- -- -- - " );
		for( i = 0; i < level.needsprecaching.size; i ++ )
			println( level.needsprecaching[ i ] );
		println( " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		println( " -- -- -- -- -- -- -- -- -- -- -- -- - hint copy paste them from console.log -- -- -- -- -- -- -- -- -- -- " );
		println( " -- -- if it already exists then check for unmatching vehicletypes in your map -- -- -- " );
		println( " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		assertEX( false, "missing vehicle scripts, see above console prints" );
		level waittill( "never" );
	}

	if( playerdrivablevehicles.size > 0 )
		thread maps\_vehicledrive::main(); // precache driveable vehicle huds and such.
	return allvehiclesprespawn; 
}

precachesetup( string, vehicle )
{
	if( isdefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ) )
		return; 
	matched = false; 
	for( i = 0; i < level.needsprecaching.size; i ++ )
		if( level.needsprecaching[ i ] == string )
			matched = true; 
	if( !matched )
		level.needsprecaching[ level.needsprecaching.size ] = string; 
}


vehicle_modelinarray( arrayofmodels, model )
{
	for( i = 0; i < arrayofmodels.size; i ++ )
		if( arrayofmodels[ i ] == model )
			return true; 
	return false; 
}

disconnect_paths_whenstopped()
{
	self endon( "death" );
	wait( randomfloat( 1 ) );
	while( isdefined( self ) )
	{
		if( self getspeed() < 1 )
		{
			self disconnectpaths();
			while( self getspeed() < 1 )
				wait .05; 
		}
		self connectpaths();
		wait 1; 
	}
}

vehicle_setspeed( speed, rate, msg )
{
	if( self getspeedmph() ==  0 && speed == 0 )
		return;  // potential for disaster? keeps messages from overriding previous messages

	 /#
	self thread debug_vehiclesetspeed( speed, rate, msg );
	#/ 

 /* 
	if( speed == 0 )
		self.zerospeed = true; 
	else
		self.zerospeed = false; 
 */ 

	println( msg );
	self setspeed( speed, rate );
}

debug_vehiclesetspeed( speed, rate, msg )
{
	 /#
	self notify( "new debug_vehiclesetspeed" );
	self endon( "new debug_vehiclesetspeed" );
	self endon( "resuming speed" );
	self endon( "death" );
	while( 1 )
	{
		while( getdvar( "debug_vehiclesetspeed" ) != "off" )
		{
			print3d( self.origin + ( 0, 0, 192 ), "vehicle setspeed: " + msg, ( 1, 1, 1 ), 1, 3 );
			wait .05; 
		}
		wait .5; 
	}
	#/ 
}

script_resumespeed( msg, rate )
{
	self endon( "death" );
	fSetspeed = 0; 
	type = "resumespeed"; 
	if( !isdefined( self.resumemsgs ) )
		self.resumemsgs = []; 
	if( isdefined( self.waitingforgate ) && self.waitingforgate )
		return; // ignore resumespeeds on waiting for gate.

	if( isdefined( self.attacking ) )
	{
		if( self.attacking )
		{
			fSetspeed = self.attackspeed; 
			type = "setspeed"; 
		}
	}

	self.zerospeed = false; 
	if( fSetspeed == 0 )
		self.zerospeed = true; 
	if( type == "resumespeed" )
		self resumespeed( rate );
	else if( type == "setspeed" )
		self vehicle_setspeed( fSetspeed, 15, "resume setspeed from attack" );
	self notify( "resuming speed" );
	self thread debug_vehicleresume( msg + " :" + type );

}

debug_vehicleresume( msg )
{
	if( getdvar( "debug_vehicleresume" ) == "off" )
		return; 
	self endon( "death" );
	number = self.resumemsgs.size; 
	self.resumemsgs[ number ] = msg; 
	timer = 3; 
	self thread print_resumespeed( gettime() + ( timer * 1000 ) );

	wait timer; 
	newarray = []; 
	for( i = 0; i < self.resumemsgs.size; i ++ )
	{
		if( i != number )
			newarray[ newarray.size ] = self.resumemsgs[ i ]; 
	}
	self.resumemsgs =  newarray; 
}

print_resumespeed( timer )
{
	self notify( "newresumespeedmsag" );
	self endon( "newresumespeedmsag" );
	self endon( "death" );
	while( gettime() < timer && isdefined( self.resumemsgs ) )
	{
		if( self.resumemsgs.size > 6 )
			start = self.resumemsgs.size - 5; 
		else
			start = 0; 
		for( i = start; i < self.resumemsgs.size; i ++ )  // only display last 5 messages
		{
			position = i * 32; 
			print3d( self.origin + ( 0, 0, position ), "resuming speed: " + self.resumemsgs[ i ], ( 0, 1, 0 ), 1, 3 );
		}
		wait .05; 
	}
}

vclogin_vehicles()
{
	if( getdvar( "vclogin_vehicles" ) == "off" )
		return; 
	precachemodel( "vehicle_blackhawk" );
	level.vclogin_vehicles = 1; 
 // 	paths = level.vehicle_startnodes; 
	vehicles = getentarray( "script_vehicle", "classname" );
	for( i = 0; i < vehicles.size; i ++ )
		vehicles[ i ] delete();

	paths = getallvehiclenodes();

	for( i = 0; i < paths.size; i ++ )
	{
		if( !( isdefined( paths[ i ].spawnflags ) && ( paths[ i ].spawnflags & 1 ) ) )
			continue; 
		crashtype = paths[ i ].script_crashtype; 
		if( !isdefined( crashtype ) )
			crashtype = "default"; 
		if( crashtype == "plane" )
			vehicle = spawnVehicle( "vehicle_blackhawk", "vclogger", "blackhawk", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		else
			vehicle = spawnVehicle( "vehicle_blackhawk", "vclogger", "blackhawk", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		vehicle attachpath( paths[ i ] );

		if( isdefined( vehicle.model ) && vehicle.model == "vehicle_blackhawk" )
		{
			tagorg = vehicle gettagorigin( "tag_bigbomb" );
			level.player setorigin( tagorg );
			level.player playerLinkTodelta( vehicle, "tag_bigbomb", 1.0 );
		}
		else
		{
			tagorg = vehicle gettagorigin( "tag_player" );
			level.player setorigin( tagorg );
			level.player playerLinkToDelta( vehicle, "tag_player", 0.1 );
		}


		vehicle startpath();
		vehicle.zerospeed = false; 
 // 		vehicle setspeed( 100, 50 );
		vehicle waittill( "reached_end_node" );
		level.player unlink();
		vehicle delete();
		crashtype = undefined; 
	}
	level waittill( "never" ); // map needs to be restarted at this point
}

forcekill()
{
	radiusDamage( self.origin, 2, 10000, 9000 );
}

godon()
{
	self.godmode = true; 
}

godoff()
{
	self.godmode = false; 
}

trigger_disable()
{
	level waittill( "disabletriggers" + self.script_vehicledisabletrigger );
	self notify( "disabletrigger" );
}

setturretfireondrones( b )
{
	if( isdefined( self.mgturret ) && self.mgturret.size )
		for( i = 0; i < self.mgturret.size; i ++ )
			self.mgturret[ i ].script_fireondrones = b; 
}

getnormalanimtime( animation )
{
	animtime = self getanimtime( animation );
	animlength = getanimlength( animation );
	if( animtime == 0 )
		return 0; 
	return self getanimtime( animation ) / getanimlength( animation );
}

animate_drive_idle()
{
	if( !isdefined( self.wheeldir ) )
		self.wheeldir = 1; 
	model = self.model; 

	newanimtime = undefined; 
	self UseAnimTree( #animtree );
	if( !isdefined( level.vehicle_DriveIdle[ model ] ) )
		return; 
	if( !isdefined( level.vehicle_DriveIdle_r[ model ] ) )
		level.vehicle_DriveIdle_r[ model ] = level.vehicle_DriveIdle[ model ];  // use forward animation if no backwards anim exists
	self endon( "death" );
	normalspeed = level.vehicle_DriveIdle_normal_speed[ model ]; 

	thread animate_drive_idle_death();

	animrate = 1.0; 
	if(( isdefined( level.vehicle_DriveIdle_animrate ) ) && ( isdefined( level.vehicle_DriveIdle_animrate[ model ] ) ) )
		animrate = level.vehicle_DriveIdle_animrate[ model ]; 

	lastdir = self.wheeldir; 
		animatemodel = self; 

	animation = level.vehicle_DriveIdle[ model ]; 

	while( 1 )
	{
		if( !normalspeed )
		{
				 // vehicles like helicopters always play the same rate. will come up with better design if need arises.
				animatemodel setanim( level.vehicle_DriveIdle[ model ], 1, .2, animrate );
				thread animtimer( .5 );
				self waittill( "animtimer" );
				continue; 
		}

		speed = self getspeedmph();

		if( lastdir != self.wheeldir )
		{
			dif = 0; 
			if( self.wheeldir )
			{
				animation = level.vehicle_DriveIdle [ model ]; 
				dif = 1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle_r [ model ] );
				animatemodel clearanim( level.vehicle_DriveIdle_r [ model ], 0 );
			}
			else
			{
				animation = level.vehicle_DriveIdle_r[ model ];  // reverse direction
				dif  =  1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle [ model ] );
				animatemodel clearanim( level.vehicle_DriveIdle[ model ], 0 );
			}

			newanimtime = 0.01; 
			if( newanimtime >= 1 || newanimtime == 0 )
				newanimtime = 0.01; // think setting animtime to 0 or 1 messes things up
			lastdir = self.wheeldir; 
		}

		if( speed == 0 )
			animatemodel setanim( animation, 1, .2, 0 );
		else
			animatemodel setanim( animation, 1, .2, speed / normalspeed );

		if( isdefined( newanimtime ) )
		{
			animatemodel setanimtime( animation, newanimtime );
			newanimtime = undefined; 
		}

		thread animtimer( .2 );
		self waittill( "animtimer" );
	}
}

animtimer( time )
{
	self endon( "animtimer" );
	wait time; 
	self notify( "animtimer" );
}

animate_drive_idle_death()
{
	model = self.model; 
	self UseAnimTree( #animtree );
	self waittill( "death_finished" );
	if( isdefined( self ) )
		self clearanim( level.vehicle_DriveIdle[ model ], 0 );
}

setup_origin_detour( pathnode )
{
		prevnode = getent( pathnode.targetname, "target" );
		assertex( isdefined( prevnode ), "detour can't be on start node" );
		prevnode.detoured = 0; 
}

 /* 
setup_origins()
{
	triggers = []; 
	origins = getentarray( "script_origin", "classname" );
	for( i = 0; i < origins.size; i ++ )
	{
		if( isdefined( origins[ i ].script_vehicledetour ) )
		{

			level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, origins[ i ].script_vehicledetour, origins[ i ] );
			if( level.vehicle_detourpaths[ origins[ i ].script_vehicledetour ].size > 2 )
				println( "more than two script_vehicledetour grouped in group number: ", origins[ i ].script_vehicledetour );

			prevnode = getent( origins[ i ].targetname, "target" );
			assertex( isdefined( prevnode ), "detour can't be on start node" );
			triggers[ triggers.size ] = prevnode; 
			prevnode.detoured = 0; 
			prevnode = undefined; 
		}
	}
	return triggers; 
}
 */ 

setup_ai()
{
	ai = getaiarray();
	for( i = 0; i < ai.size; i ++ )
	{
		if( isdefined( ai[ i ].script_vehicleride ) )
			level.vehicle_RideAI = array_2dadd( level.vehicle_RideAI, ai[ i ].script_vehicleride, ai[ i ] );
		else
		if( isdefined( ai[ i ].script_vehiclewalk ) )
			level.vehicle_WalkAI = array_2dadd( level.vehicle_WalkAI, ai[ i ].script_vehiclewalk, ai[ i ] );
	}
	ai = getspawnerarray();

	for( i = 0; i < ai.size; i ++ )
	{
		if( isdefined( ai[ i ].script_vehicleride ) )
			level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, ai[ i ].script_vehicleride, ai[ i ] );
		if( isdefined( ai[ i ].script_vehiclewalk ) )
			level.vehicle_walkspawners = array_2dadd( level.vehicle_walkspawners, ai[ i ].script_vehiclewalk, ai[ i ] );
	}
}

array_2dadd( array, firstelem, newelem )
{
	if( !isdefined( array[ firstelem ] ) )
		array[ firstelem ] = []; 
	array[ firstelem ][ array[ firstelem ].size ] = newelem; 
	return array; 
}

is_node_script_origin( pathnode )
{
	return isdefined( pathnode.classname ) && pathnode.classname == "script_origin"; 
}


 // this determines if the node will be sent through trigger_process.  The uber trigger function that may get phased out.
node_trigger_process()
{
		processtrigger = false; 
		 // for forcing a trigger to be processed.. this is used when a certain
		 // association needs to designate one vehicle node as the trigger node
		if( isdefined( self.script_noteworthy ) )
		{
			if
			( 
				self.script_noteworthy == "trigger" 	 || 
				self.script_noteworthy == "godon" 	 || 
				self.script_noteworthy == "forcekill" || 
				self.script_noteworthy == "deleteme" || 
				self.script_noteworthy == "godoff"
			 )
			processtrigger = true; 
		}


		 // special treatment for start nodes
		if( isdefined( self.spawnflags ) && ( self.spawnflags & 1 ) )
		{
			if( isdefined( self.script_crashtype ) )
				level.vehicle_crashpaths[ level.vehicle_crashpaths.size ] = self; 
			level.vehicle_startnodes[ level.vehicle_startnodes.size ] = self; 
		}

 // 		if( isdefined( self.script_vehicledetour ) && !is_script_origin )
		if( isdefined( self.script_vehicledetour ) )
		{
			if( is_node_script_origin( self ) )
			{
				setup_origin_detour( self );
				processtrigger = true;  // the node with the script_vehicledetour waits for the trigger here unlike ground nodes which need to know 1 node in advanced that there's a detour, tricky tricky.
			}
			else
			{
				setup_groundnode_detour( self ); // other trickery.  the node is set to process in there.
			}
			
			level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, self.script_vehicledetour, self );
			if( level.vehicle_detourpaths[ self.script_vehicledetour ].size > 2 )
				println( "more than two script_vehicledetour grouped in group number: ", self.script_vehicledetour );
		}
		

		if( isdefined( self.script_linkname ) )
			level.vehicle_linkedpaths[ level.vehicle_linkedpaths.size ] = self; 


		 // if a gate isn't open then the vehicle will stop there and wait for it to become open.
		if( isdefined( self.script_gatetrigger ) )
		{
			level.vehicle_gatetrigger = array_2dadd( level.vehicle_gatetrigger, self.script_gatetrigger, self );
			self.gateopen = false; 
		}

		 // a vehicle node will have a closed gate untill its associated vehicle is killed.


		 // various nodes that will be sent through trigger_process
		if
		( 
			  	isdefined( self.script_VehicleSpawngroup )
			 || 	isdefined( self.script_VehicleStartMove )
			 || 	isdefined( self.script_Vehiclegroupdelete )
			 || 	isdefined( self.script_turret )
			 || 	isdefined( self.script_crashtypeoverride )
			 || 	isdefined( self.script_badplace )
			 || 	isdefined( self.script_attackspeed )
			 || 	isdefined( self.script_turretmg )
			 || 	isdefined( self.script_deathroll )
			 || 	isdefined( self.script_vehicleaianim )
			 || 	isdefined( self.script_turningdir )
			 || 	isdefined( self.script_exploder )
			 || 	isdefined( self.script_unload )
			 || 	isdefined( self.detoured )
			 || 	isdefined( self.script_wheeldirection )
			 || 	isdefined( self.script_noteworthy )
		 )
		processtrigger = true; 

		if( isdefined( self.script_vehicle_lights_off ) )
			thread script_vehicle_lights_off();
		if( isdefined( self.script_vehicle_lights_on ) )
			thread script_vehicle_lights_on();

		if( processtrigger )
			add_proccess_trigger( self );
}

setup_triggers()
{
	 // TODO: move this to _load under the triggers section.  larger task than this simple cleanup.

	 // the processtriggers array is all the triggers and vehicle node triggers to be put through
	 // the trigger_process function.   This is so that I only do a waittill trigger once
	 // in script to assure better sequencing on a multi - function trigger.

	 // some of the vehiclenodes don't need to waittill trigger on anything and are here only
	 // for being linked with other trigger

	level.vehicle_processtriggers = []; 

	pathnodes = array_combine( getallvehiclenodes(), getentarray( "script_origin", "classname" ) );

	is_script_origin = undefined; 

	
	array_thread( pathnodes, ::node_trigger_process );

	VehicleSpawngroup = []; 
	VehicleStartMove = []; 
	vehicleGroupDelete = []; 
	nonplayervehicles = []; 
	triggers = array_combine( getentarray( "trigger_multiple", "classname" ), getentarray( "trigger_radius", "classname" ) );
	triggers = array_combine( triggers, getentarray( "trigger_lookat", "classname" ) );
	for( i = 0; i < triggers.size; i ++ )
	{
		if
		( 
		   isdefined( triggers[ i ].script_VehicleSpawngroup )		
		 || isdefined( triggers[ i ].script_VehicleStartMove )		
		 || isdefined( triggers[ i ].script_vehicleGroupDelete )		
		 || isdefined( triggers[ i ].script_gatetrigger )			
		 || isdefined( triggers[ i ].script_vehicledisabletrigger )
		 )
		add_proccess_trigger( triggers[ i ] );
	}
}

setup_vehicles( allvehiclesprespawn )
{
 // 	vehicles = getentarray( "script_vehicle", "classname" );
	
 // old setup required targetname. blahrg
 // 	vehicles = array_combine( vehicles, getentarray( "vehiclespawnmodel", "targetname" ) );


	 // this could be dangerous but lets give it a try and see what happesn.. yeehaw! - Nate
 // 	vehicles = array_combine( vehicles, getentarray( "script_model", "classname" ) );
	
	vehicles = allvehiclesprespawn; 
	
	spawnvehicles = []; 
	groups = []; 
	nonspawned = []; 

	for( i = 0; i < vehicles.size; i ++ )
	{
		if( isdefined( vehicles[ i ].script_vehiclespawngroup ) )
		{
			if( !isdefined( spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ] ) )
				spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ] = []; 

			spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ]
			[ spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ].size ] = vehicles[ i ]; 
			addgroup[ 0 ] = vehicles[ i ].script_vehiclespawngroup; 
			groups = array_merge( groups, addgroup );
			continue; 
		}
 // 		else if( vehicles[ i ].classname == "script_vehicle" )
		else 
			nonspawned[ nonspawned.size ] = vehicles[ i ]; 
	}

	for( i = 0; i < groups.size; i ++ )
		thread spawner_setup( spawnvehicles[ groups[ i ] ], groups[ i ], "main" );

	 // init vehicles that aren't spawned
	for( i = 0; i < nonspawned.size; i ++ )
		thread vehicle_init( nonspawned[ i ] );
}

vehicle_life()
{
	
	type = self.vehicletype; 

	if( !isdefined( level.vehicle_life ) || !isdefined( level.vehicle_life[ self.vehicletype ] ) )
	{
		wait 2; 
	}
	assertEX( isdefined( level.vehicle_life[ type ] ), "need to specify build_life() in vehicle script for vehicletype: " + type );


	if( isdefined( self.script_startinghealth ) )
		self.health = self.script_startinghealth; 
	else
	{
		if( level.vehicle_life[ type ] == - 1 )
			return; 
		else if( isdefined( level.vehicle_life_range_low[ type ] ) && isdefined( level.vehicle_life_range_high[ type ] ) )
			self.health  = ( randomint( level.vehicle_life_range_high[ type ] - level.vehicle_life_range_low[ type ] ) + level.vehicle_life_range_low[ type ] );
		else
			self.health = level.vehicle_life[ type ]; 
	}
	
	if( isdefined( level.destructible_model[ self.model ] ) )
	{
		self.health = 2000;
		self.destructible_type = level.destructible_model[ self.model ]; 
		self maps\_destructible::setup_destructibles( true );
	}
	
}

mginit()
{

	type = self.vehicletype; 

	if((( isdefined( self.script_nomg ) ) && ( self.script_nomg > 0 ) ) )
		return; 

	if( self isHelicopter()  || !isdefined( level.vehicle_mgturret[ type ] ) )
		return; 

	mgangle = 0; 
	if( isdefined( self.script_mg_angle ) )
		mgangle = self.script_mg_angle; 


	turret_template = level.vehicle_mgturret[ type ]; 
	if( !isdefined( turret_template ) )
		return; 

	for( i = 0; i < turret_template.size; i ++ )
	{
		self.mgturret[ i ] = spawnTurret( "misc_turret", ( 0, 0, 0 ), turret_template[ i ].info );
		self.mgturret[ i ] linkto( self, turret_template[ i ].tag, ( 0, 0, 0 ), ( 0, - 1 * mgangle, 0 ) );
		self.mgturret[ i ] setmodel( turret_template[ i ].model );
		self.mgturret[ i ].angles = self.angles; 
		self.mgturret[ i ].isvehicleattached = true; // lets mgturret know not to mess with this turret
		self.mgturret[ i ] thread maps\_mgturret::burst_fire_unmanned();
		self.mgturret[ i ] maketurretunusable();
		level thread maps\_mgturret::mg42_setdifficulty( self.mgturret[ i ], getdifficulty() );
		if( isdefined( self.script_fireondrones ) )
			self.mgturret[ i ].script_fireondrones = self.script_fireondrones; 
		self.mgturret[ i ] setshadowhint( "never" );
		if( isdefined( turret_template[ i ].defaultOFFmode ) )
			self.mgturret[ i ] setmode( turret_template[ i ].defaultOFFmode );
		if( isdefined( turret_template[ i ].maxrange ) )
			self.mgturret[ i ].maxrange = turret_template[ i ].maxrange; 
		if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "onemg" )
				break; 
	}

	if( !isdefined( self.script_turretmg ) )
		self.script_turretmg = true;; 

	if( isdefined( self.script_turretmg ) && self.script_turretmg == 0 )
		self thread mgoff();
	else
	{
		self.script_turretmg = 1; 
		self thread mgon();
	}

	self thread mgtoggle();
}

mgtoggle()
{
	self endon( "death" );
	if( self.script_turretmg )
		lasttoggle = 1; 
	else
		lasttoggle = 0; 
	while( 1 )
	{
		if( lasttoggle != self.script_turretmg )
		{
			lasttoggle = self.script_turretmg; 
			if( self.script_turretmg )
				self thread mgon();
			else
				self thread mgoff();
		}
		wait .5; 
	}
}

mgoff()
{
	type = self.vehicletype; 
	self.script_turretmg = 0; 

	if(( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		self thread chopper_Turret_Off();
		return; 
	}

	if( !isdefined( self.mgturret ) )
		return; 
	for( i = 0; i < self.mgturret.size; i ++ )
	{
		if( isdefined( self.mgturret[ i ].script_fireondrones ) )
			self.mgturret[ i ].script_fireondrones = false; 
		if( isdefined( level.vehicle_mgturret[ type ][ i ].defaultOFFmode ) )
			self.mgturret[ i ] setmode( level.vehicle_mgturret[ type ][ i ].defaultOFFmode );
		else
			self.mgturret[ i ] setmode( "manual" );
	}
}

mgon()
{
	type = self.vehicletype; 
	self.script_turretmg = 1; // fix me.. defense for scripts using mgon();

	if(( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		self thread chopper_Turret_On();
		return; 
	}

	if( !isdefined( self.mgturret ) )
		return; 
	for( i = 0; i < self.mgturret.size; i ++ )
	{
		if( isdefined( self.mgturret[ i ].script_fireondrones ) )
			self.mgturret[ i ].script_fireondrones = true; 
		if( isdefined( level.vehicle_mgturret[ type ][ i ].defaultONmode ) )
			self.mgturret[ i ] setmode( level.vehicle_mgturret[ type ][ i ].defaultONmode );
		else
			self.mgturret[ i ] setmode( "auto_nonai" );
		if(( self.script_team == "allies" ) || ( self.script_team == "friendly" ) )
			self.mgturret[ i ] setTurretTeam( "allies" );
		else if(( self.script_team == "axis" ) || ( self.script_team == "enemy" ) )
			self.mgturret[ i ] setTurretTeam( "axis" );
	}
}

isHelicopter()
{
	if( !isdefined( self.vehicletype ) )
		return false; 
	if( self.vehicletype == "blackhawk" )
		return true; 
	if( self.vehicletype == "apache" )
		return true; 
	if( self.vehicletype == "seaknight" )
		return true; 
	if( self.vehicletype == "hind" )
		return true; 
	if( self.vehicletype == "mi17" )
		return true; 
	if( self.vehicletype == "mi17_noai" )
		return true; 
	if( self.vehicletype == "cobra" )
		return true; 
	if( self.vehicletype == "cobra_player" )
		return true; 
	if( self.vehicletype == "mi28" )
		return true; 
	return false; 
}


isCheap()
{
	if( !isdefined( self.script_cheap ) )
		return false; 

	if( !self.script_cheap )
		return false; 

	return true; 
}


hasHelicopterDustKickup()
{
	if( !isHelicopter() )
		return false; 

	if( isCheap() )
		return false; 

	return true; 
}

hasHelicopterTurret()
{
	if( !isdefined( self.vehicletype ) )
		return false; 
	if( isCheap() )
		return false; 
	if( self.vehicletype == "cobra" )
		return true; 
	if( self.vehicletype == "cobra_player" )
		return true; 
	return false; 
}

Chopper_Turret_On()
{
	self endon( "death" );
	self endon( "mg_off" );

	cosine55 = cos( 55 );

	while( self.health > 0 )
	{
		 // target range, target fov, getAITargets, doTrace
		eTarget = self maps\_helicopter_globals::getEnemyTarget( 16000, cosine55, true, true );
		if( isdefined( eTarget ) )
			self thread maps\_helicopter_globals::shootEnemyTarget_Bullets( eTarget );
		wait 2; 
	}
}

chopper_Turret_Off()
{
	self notify( "mg_off" );
}

playLoopedFxontag( effect, durration, tag )
{
	effectorigin = spawn( "script_origin", self.origin );
	self endon( "fire_extinguish" );
	thread playLoopedFxontag_originupdate( tag, effectorigin );
	while( 1 )
	{
		playfx( effect, effectorigin.origin, effectorigin.upvec );
		wait durration; 
	}
}

playLoopedFxontag_originupdate( tag, effectorigin )
{
	effectorigin.angles = self gettagangles( tag );
	effectorigin.origin  = self gettagorigin( tag );
	effectorigin.forwardvec = anglestoforward( effectorigin.angles );
	effectorigin.upvec = anglestoup( effectorigin.angles );
	while( isdefined( self ) && self.classname == "script_vehicle" && self getspeedmph() > 0 )
	{
		effectorigin.angles = self gettagangles( tag );
		effectorigin.origin  = self gettagorigin( tag );
		effectorigin.forwardvec = anglestoforward( effectorigin.angles );
		effectorigin.upvec = anglestoup( effectorigin.angles );
		wait .05; 
	}
}

build_turret( info, tag, model, bAicontrolled, maxrange, defaultONmode, defaultOFFmode )
{
	if( !isdefined( level.vehicle_mgturret ) )
		level.vehicle_mgturret = []; 
	if( !isdefined( level.vehicle_mgturret[ level.vttype ] ) )
		level.vehicle_mgturret[ level.vttype ] = []; 
	precachemodel( model );
	precacheturret( info );
	struct = spawnstruct();
	struct.info = info; 
	struct.tag = tag; 
	struct.model = model; 
	struct.bAicontrolled = bAicontrolled; 
	struct.maxrange = maxrange; 
	struct.defaultONmode = defaultONmode; 
	struct.defaultOFFmode = defaultOFFmode; 
	level.vehicle_mgturret[ level.vttype ][ level.vehicle_mgturret[ level.vttype ].size ] = struct; 
}


setup_dvars()
{
	if( getdvar( "debug_tankcrush" ) == "" )
		setdvar( "debug_tankcrush", "0" );
	if( getdvar( "vclogin_vehicles" ) == "" )
		setdvar( "vclogin_vehicles", "off" );
	if( getdvar( "debug_vehicleresume" ) == "" )
		setdvar( "debug_vehicleresume", "off" );
	if( getdvar( "debug_vehicledetour" ) == "" )
		setdvar( "debug_vehicledetour", "off" );
	if( getdvar( "debug_vehiclesetspeed" ) == "" )
		setdvar( "debug_vehiclesetspeed", "off" );
	if( getdvar( "debug_vehiclesittags" ) == "" )
		setdvar( "debug_vehiclesittags", "off" );
}

setup_levelvars()
{
	level.vehicle_ResumeSpeed = 5; 
	level.vehicle_DeleteGroup = []; 
	level.vehicle_SpawnGroup = []; 
	level.vehicle_StartMoveGroup = []; 
	level.vehicle_RideAI =  []; 
	level.vehicle_WalkAI =  []; 
	level.vehicle_DeathSwitch = []; 
	level.vehicle_RideSpawners = []; 
	level.vehicle_walkspawners = []; 
	level.vehicle_gatetrigger = []; 
	level.vehicle_crashpaths = []; 
	level.vehicle_target = []; 
	level.vehicle_link = []; 
	level.vehicle_detourpaths = []; 
	level.vehicle_linkedpaths = []; 
	level.vehicle_startnodes = []; 
	level.vehicle_spawners =  []; 

	level.helicopter_crash_locations = getentarray( "helicopter_crash_location", "targetname" );

	level.vclogin_vehicles = 0; 
	level.playervehicle = spawn( "script_origin", ( 0, 0, 0 ) ); // no isdefined for level.playervehicle
	level.playervehiclenone = level.playervehicle; // no isdefined for level.playervehicle
	level.vehicles = []; 	 // will contain all the vehicles that are spawned and alive
	level.vehicles[ "allies" ] = []; 
	level.vehicles[ "axis" ] = []; 

	if( !isdefined( level.vehicle_team ) )
		level.vehicle_team = []; 
	if( !isdefined( level.vehicle_deathmodel ) )
		level.vehicle_deathmodel = []; 
	if( !isdefined( level.vehicle_death_thread ) )
		level.vehicle_death_thread = []; 
	if( !isdefined( level.vehicle_DriveIdle ) )
		level.vehicle_DriveIdle = []; 
	if( !isdefined( level.vehicle_DriveIdle_r ) )
		level.vehicle_DriveIdle_r = []; 
	if( !isdefined( level.attack_origin_condition_threadd ) )
		level.attack_origin_condition_threadd = []; 
	if( !isdefined( level.vehiclefireanim ) )
		level.vehiclefireanim = []; 
	if( !isdefined( level.vehiclefireanim_settle ) )
		level.vehiclefireanim_settle = []; 
	if( !isdefined( level.vehicle_hasname ) )
		level.vehicle_hasname = []; 
	if( !isdefined( level.vehicle_turret_requiresrider ) )
		level.vehicle_turret_requiresrider = []; 
	if( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = []; 
	if( !isdefined( level.vehicle_mgturret ) )
		level.vehicle_mgturret = []; 
	if( !isdefined( level.vehicle_isStationary ) )
		level.vehicle_isStationary = []; 
	if( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = []; 
	if( !isdefined( level.vehicle_death_earthquake ) )
		level.vehicle_death_earthquake = []; 
	if( !isdefined( level.vehicle_treads ) )
		level.vehicle_treads = []; 
	if( !isdefined( level.vehicle_compassicon ) )
		level.vehicle_compassicon = []; 
	if( !isdefined( level.vehicle_unloadgroups ) )
		level.vehicle_unloadgroups = []; 
	if( !isdefined( level.vehicle_aianims ) )
		level.vehicle_aianims = []; 
	if( !isdefined( level.vehicle_unloadwhenattacked ) )
		level.vehicle_unloadwhenattacked = []; 
	if( !isdefined( level.vehicle_exhaust ) )
		level.vehicle_exhaust = []; 
	if( !isdefined( level.vehicle_deckdust ) )
		level.vehicle_deckdust = []; 
	if( !isdefined( level.vehicle_shoot_shock ) )
		level.vehicle_shoot_shock = []; 
	if( !isdefined( level.vehicle_frontarmor ) )
		level.vehicle_frontarmor = []; 
	if( !isdefined( level.destructible_model ) )
		level.destructible_model = []; 
	if( !isdefined( level.vehicle_types ) )
		level.vehicle_types = []; 
		
	maps\_vehicle_aianim::setup_aianimthreads();
		
}


attacker_isonmyteam( attacker )
{
	if(( isdefined( attacker ) ) && isdefined( attacker.script_team ) && ( isdefined( self.script_team ) ) && ( attacker.script_team == self.script_team ) )
		return true; 
	else
		return false; 
}

is_godmode()
{
	if( isdefined( self.godmode ) && self.godmode )
		return true; 
	else
		return false; 
}

attacker_troop_isonmyteam( attacker )
{
		if( isdefined( self.script_team ) && self.script_team == "allies" && isdefined( attacker ) && attacker == level.player )
			return true;  // player is always on the allied team.. hahah! future CoD games that let the player be the enemy be damned!
		else if( isai( attacker ) && attacker.team == self.script_team )
			return true; 
		else
			return false; 
}

has_frontarmor()
{
	return( isdefined( level.vehicle_frontarmor [ self.vehicletype ] ) );
}

friendlyfire_shield()
{
	self endon( "death" );
	self endon( "stop_friendlyfire_shield" );

	self.healthbuffer = 2000; 
	self.health += self.healthbuffer; 
	self.currenthealth = self.health; 
	attacker = undefined; 

	while( self.health > 0 )
	{
		self waittill( "damage", amount, attacker );
		assert( isdefined( attacker ) );
		if( 
						is_godmode()
				 || 	attacker_isonmyteam( attacker )
				 || 	attacker_troop_isonmyteam( attacker )
				 || 		isDestructible()
			 )
			self.health = self.currenthealth;  // give back health for these things
		else if( self has_frontarmor() )  // regen health for tanks with armor in the front
		{
			self regen_front_armor( attacker, amount );
			self.currenthealth = self.health; 
		}
		else
			self.currenthealth = self.health; 
		if( self.health < self.healthbuffer )
			break; 
	}
	self notify( "death", attacker );
}

regen_front_armor( attacker, amount )
{
	forwardvec = anglestoforward( self.angles );
	othervec = vectorNormalize( attacker.origin - self.origin );
	if( vectordot( forwardvec, othervec ) > .86 )
		self.health += int( amount * level.vehicle_frontarmor [ self.vehicletype ] );
}

vehicle_rumble()
{
 // makes vehicle rumble

	type = self.vehicletype; 
	if( !isdefined( level.vehicle_rumble[ type ] ) )
		return; 

	rumblestruct = level.vehicle_rumble[ type ]; 
	height = rumblestruct.radius * 2; 
	zoffset = - 1 * rumblestruct.radius; 
	areatrigger = spawn( "trigger_radius", self.origin + ( 0, 0, zoffset ), 0, rumblestruct.radius, height );
	areatrigger enablelinkto();
	areatrigger linkto( self );
	self.rumbletrigger = areatrigger; 
	self endon( "death" );
 // 	( rumble, scale, duration, radius, basetime, randomaditionaltime )
	if( !isdefined( self.rumbleon ) )
		self.rumbleon = true; 
	if( isdefined( rumblestruct.scale ) )
		self.rumble_scale = rumblestruct.scale; 
	else
		self.rumble_scale = 0.15; 

	if( isdefined( rumblestruct.duration ) )
		self.rumble_duration = rumblestruct.duration; 
	else
		self.rumble_duration = 4.5; 

	if( isdefined( rumblestruct.radius ) )
			self.rumble_radius = rumblestruct.radius; 
	else
			self.rumble_radius = 600; 
	if( isdefined( rumblestruct.basetime ) )
			self.rumble_basetime = rumblestruct.basetime; 
	else
		self.rumble_basetime = 1; 
	if( isdefined( rumblestruct.randomaditionaltime ) )
			self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime; 
	else
		self.rumble_randomaditionaltime = 1; 

	areatrigger.radius = self.rumble_radius; 
	while( 1 )
	{
		areatrigger waittill( "trigger" );
		if( self getspeedmph() == 0 || !self.rumbleon )
		{
			wait .1; 
			continue; 
		}

		self PlayRumbleLoopOnEntity( level.vehicle_rumble[ type ].rumble );
		while( level.player istouching( areatrigger ) && self.rumbleon && self getspeedmph() > 0 )
		{
			earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius ); // scale duration source radius
			wait( self.rumble_basetime + randomfloat( self.rumble_randomaditionaltime ) );
		}
		self StopRumble( level.vehicle_rumble[ type ].rumble );
	}
}

vehicle_badplace()
{
	if( !isdefined( self.script_badplace ) )
		return; 
	self endon( "death" );
	self endon( "delete" );
	if( isdefined( level.custombadplacethread ) )
	{
		self thread [ [ level.custombadplacethread ] ]();
		return; 
	}
	hasturret = isdefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ]; 
	bp_duration = .5; 
	bp_height = 300; 
	bp_angle_left = 17; 
	bp_angle_right = 17; 
	for( ;; )
	{
		if( !self.script_badplace )
		{
 // 			badplace_delete( "tankbadplace" );
			while( !self.script_badplace )
				wait .5; 
		}
		speed = self getspeedmph();
		if( speed <= 0 )
		{
			wait bp_duration; 
			continue; 
		}
		if( speed < 5 )
			bp_radius = 200; 
		else if(( speed > 5 ) && ( speed < 8 ) )
			bp_radius = 350; 
		else
			bp_radius = 500; 

		if( isdefined( self.BadPlaceModifier ) )
			bp_radius = ( bp_radius * self.BadPlaceModifier );

 // 			bp_direction = anglestoforward( self.angles );
		if( hasturret )
			bp_direction = anglestoforward( self gettagangles( "tag_turret" ) );
		else
			bp_direction = anglestoforward( self.angles );

		badplace_arc( "", bp_duration, self.origin, bp_radius * 1.9, bp_height, bp_direction, bp_angle_left, bp_angle_right, "allies", "axis" );
		badplace_cylinder( "", bp_duration, self.origin, 200, bp_height, "allies", "axis" );
 // / 			badplace_cylinder( "", bp_duration, self.colidecircle[ 1 ].origin, 200, bp_height, "allies", "axis" );
		wait bp_duration + .05; 
	}
}

vehicle_treads()
{
   	if( !isdefined( level.vehicle_treads [ self.vehicletype ] ) )
   		return; 

   	if( self isHelicopter() )
   		return; 

	if( isdefined( level.tread_override_thread ) )
		self thread [ [ level.tread_override_thread ] ]( 	"tag_origin", "back_left", ( 160, 0, 0 ) );
	else
	{
		self thread tread( "tag_wheel_back_left", "back_left" );
		self thread tread( "tag_wheel_back_right", "back_right" );
	}
}

tread( tagname, side, relativeOffset )
{
	self endon( "death" );
	treadfx = treadget( self, side );
	for( ;; )
	{
		speed = self getspeed();
		if( speed == 0 )
		{
			wait 0.1; 
			continue; 
		}
		waitTime = ( 1 / speed );
		waitTime = ( waitTime * 35 );
		if( waitTime < 0.1 )
			waitTime = 0.1; 
		else if( waitTime > 0.3 )
			waitTime = 0.3; 
		wait waitTime; 
		lastfx = treadfx; 
		treadfx = treadget( self, side );
		if( treadfx != - 1 )
		{
			ang = self getTagAngles( tagname );
			forwardVec = anglestoforward( ang );
			effectOrigin = self getTagOrigin( tagname );
			forwardVec = maps\_utility::vector_multiply( forwardVec, waitTime );
			playfx( treadfx, effectOrigin, ( 0, 0, 0 ) - forwardVec );
		}
	}
}

treadget( vehicle, side )
{
	surface = self getwheelsurface( side );
	if( !isdefined( vehicle.vehicletype ) )
	{
		treadfx = - 1; 
		return treadfx; 
	}

	if( !isdefined( level._vehicle_effect[ vehicle.vehicletype ] ) )
	{
		println( "no treads setup for vehicle type: ", vehicle.vehicletype );
		wait 1; 
		return - 1; 
	}
	treadfx = level._vehicle_effect[ vehicle.vehicletype ][ surface ]; 

	if( surface == "ice" )
		self notify( "iminwater" );

	if( !isdefined( treadfx ) )
		treadfx = - 1; 

	return treadfx; 
}

turret_attack_think()
{
	 // chad - disable this for now, will eventually handle shooting of missiles at targets
	if( self isHelicopter() )
		return; 

	 // Nathan - Turrets don't think anymore. Sorry, and your welcome.
	thread turret_shoot();
}

isStationary()
{
	type = self.vehicletype; 
	if( isdefined( level.vehicle_isStationary[ type ] ) && level.vehicle_isStationary[ type ] )
		return true; 
	else
		return false; 

}

turret_shoot()
{
	type = self.vehicletype; 
	self endon( "death" );
	self endon( "stop_turret_shoot" );
	while( self.health > 0 )
	{
		self waittill( "turret_fire" );
		self thread turret_shoot_anim();
		self notify( "groupedanimevent", "turret_fire" );
		self fireWeapon();
	}
}

turret_shoot_anim()
{
	self endon( "death" );
	self endon( "turret_fire" );
	self useanimtree( #animtree );
	if( !isdefined( level.vehiclefireanim[ self.model ] ) )
		return; 

	if( !isdefined( level.vehiclefireanim_settle[ self.model ] ) )
	{
		self setanim( level.vehiclefireanim[ self.model ], 1, 0 );
		return; 
	}
	self clearanim( level.vehiclefireanim_settle[ self.model ], 0 );
	self setanim( level.vehiclefireanim[ self.model ], 1, 0 );
	wait .25; 
	self clearanim( level.vehiclefireanim[ self.model ], 0 );
	if( !isdefined( level.vehiclefireanim_settle[ self.model ] ) )
		return; 
	self setflaggedanim( "shooting_animation", level.vehiclefireanim_settle[ self.model ], 1, 0 );
	self waittillmatch( "shooting_animation", "end" );
	self clearanim( level.vehiclefireanim_settle[ self.model ], 0 );
}

vehicle_shoot_shock()
{
	 // if no shellshock is specified just get out of here.
	if( !isdefined( level.vehicle_shoot_shock[ self.model ] ) )
		return; 
	self endon( "death" );

	if( !isdefined( level.vehicle_shoot_shock_overlay ) )
	{
		level.vehicle_shoot_shock_overlay = newHudElem();
		level.vehicle_shoot_shock_overlay.x = 0; 
		level.vehicle_shoot_shock_overlay.y = 0; 
		level.vehicle_shoot_shock_overlay setshader( "black", 640, 480 );
		level.vehicle_shoot_shock_overlay.alignX = "left"; 
		level.vehicle_shoot_shock_overlay.alignY = "top"; 
		level.vehicle_shoot_shock_overlay.horzAlign = "fullscreen"; 
		level.vehicle_shoot_shock_overlay.vertAlign = "fullscreen"; 
		level.vehicle_shoot_shock_overlay.alpha = 0; 
	}

	while( true )
	{
		self waittill( "weapon_fired" ); // waits for Code notify when fireWeapon() is called.
		if( isdefined( self.shock_distance ) )
			shock_distance = self.shock_distance; 
		else
			shock_distance = 400; 

		if( isdefined( self.black_distance ) )
			black_distance = self.black_distance; 
		else
			black_distance = 800; 

		player_distance = distance( self.origin, level.player.origin );
		if( player_distance > black_distance )
			continue; 

 // 		might add this at some point, but it's so subtle now that I don't think it matters.
 // 		if( sighttracepassed( level.player geteye(), self.origin + ( 0, 0, 64 ), false, self ) )

		level.vehicle_shoot_shock_overlay.alpha = .5; 
		level.vehicle_shoot_shock_overlay fadeOverTime( 0.2 );
		level.vehicle_shoot_shock_overlay.alpha = 0; 

		if( player_distance > shock_distance )
			continue; 

		fraction = player_distance / shock_distance; 
		time = 4 - ( 3 * fraction );
		level.player shellshock( level.vehicle_shoot_shock[ self.model ], time );
	}
}

vehicle_compasshandle()
{
	type = self.vehicletype; 
	if( !level.vehicle_compassicon[ type ] )
		return; 
	self endon( "death" );
	level.compassradius = int( getdvar( "compassMaxRange" ) );
	self.onplayerscompass = false; 
	 // TODO: complain to Code about this feature.  I shouldn't have to poll the distance of the tank to remove it from the compass
	while( 1 )
	{
		if( distance( self.origin, level.player.origin ) < level.compassradius )
		{
			if( !( self.onplayerscompass ) )
			{
				self addvehicletocompass();
				self.onplayerscompass = true; 
			}
		}
		else
		{
			if( self.onplayerscompass )
			{
				self removevehiclefromcompass();
				self.onplayerscompass = false; 
			}
		}
		wait .5; 
	}
}


vehicle_setteam()
{
	type = self.vehicletype; 
	if( !isdefined( self.script_team ) && isdefined( level.vehicle_team[ type ] ) )
		self.script_team = level.vehicle_team[ type ]; 
	if( isdefined( level.vehicle_hasname[ type ] ) )
		self thread maps\_vehiclenames::get_name();

	level.vehicles[ self.script_team ] = array_add( level.vehicles[ self.script_team ], self );
}



vehicle_handleunloadevent()
{
	self endon( "death" );

	type = self.vehicletype; 
	while( 1 )
	{
		self waittill( "unload", who );

		 // setting an unload group unloaded guys resets to "default"
		if( isdefined( who ) )
			self.unload_group = who; 
		 // makes ai unload
		self notify( "groupedanimevent", "unload" );

 // 		if( isdefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ] && riders_check() )
 // 			self clearTurretTarget();
	}
}

vehicle_resumepathvehicle()
{
	node = undefined; 
	if( isdefined( self.currentnode.target ) )
		node = getent( self.currentnode.target, "targetname" );
	if( !isdefined( node ) )
		return; 
	vehicle_dynamicpath( node );
}

vehicle_landvehicle()
{
		self setNearGoalNotifyDist( 2 );
		self sethoverparams( 0 );
		self	setvehgoalpos_wrap( groundpos( self.origin ), 1 );
		self waittill( "goal" );
}

setvehgoalpos_wrap( origin, bStop )
{
	if( self.health <= 0 )
		return; 
	if( isdefined( self.originheightoffset ) )
		origin += ( 0, 0, self.originheightoffset ); // TODO - FIXME: this is temporarily set in the vehicles init_local function working on getting it this requirement removed
	self setvehgoalpos( origin, bStop );
}

vehicle_liftoffvehicle( height )
{
	if( !isdefined( height ) )
		height = 512; 
	dest = self.origin + ( 0, 0, height );
	self setNearGoalNotifyDist( 10 );
	self	setvehgoalpos_wrap( dest, 1 );
	self waittill( "goal" );
}

unloading_damage_record_on()
{
	self endon( "stop_unloading_damage_record" );
	self godon();

	if( !isdefined( self.accumulatedDamage ) )
		self.accumulatedDamage = 0; 

	while( isdefined( self ) )
	{
		self waittill( "damage", amount, attacker );
		if( amount <= 0 )
			continue; 
		if( !isdefined( attacker ) )
			continue; 
		if( attacker != level.player )
			continue; 

		self.accumulatedDamage += amount; 

		if(( self.health - self.healthbuffer - self.accumulatedDamage ) <= 0 )
			thread prekill_fx( self.model );
	}
}

unloading_damage_record_off()
{
	self notify( "stop_unloading_damage_record" );
	self godoff();
	self.health -= self.accumulatedDamage; 
	self notify( "damage", self.accumulatedDamage, level.player );
	self.accumulatedDamage = 0; 
}

waittill_stable()
{
		 // wait for it to level out before unloading
		offset = 12; 
		stabletime = 400; 
		timer = gettime() + stabletime; 
		while( isdefined( self ) )
		{
			if( self.angles[ 0 ] > offset || self.angles [ 0 ] < ( - 1 * offset ) )
				timer = gettime() + stabletime; 
			if( self.angles[ 2 ] > offset || self.angles [ 2 ] < ( - 1 * offset ) )
				timer = gettime() + stabletime; 
			if( gettime() > timer )
				break; 
			wait .05; 
		}
}

unload_node( node )
{
	assert( isdefined( self ) );
	self thread unloading_damage_record_on();

	pathnode = getnode( node.targetname, "target" );
	if( isdefined( pathnode ) && self.riders.size )
		for( i = 0; i < self.riders.size; i ++ )
			if( isai( self.riders[ i ] ) )
				self.riders[ i ] thread maps\_spawner::go_to_node( pathnode );

	if( self ishelicopter() )
		waittill_stable();

	if( isdefined( node.script_noteworthy ) )
		if( node.script_noteworthy == "wait_for_flag" )
			flag_wait( node.script_flag );

	self notify( "unload", node.script_unload );

	if( self.riders.size )
		self waittill( "unloaded" );

	self thread unloading_damage_record_off();
	wait 1; 
	if( isdefined( self ) )
		thread vehicle_resumepathvehicle();
}

move_turrets_here( model )
{
	type = self.vehicletype; 
	if( !isdefined( self.mgturret ) )
		return; 
	if( self.mgturret.size == 0 )
		return; 
	for( i = 0; i < self.mgturret.size; i ++ )
	{
		self.mgturret[ i ] unlink();
		self.mgturret[ i ] linkto( model, level.vehicle_mgturret[ type ][ i ].tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
}

vehicle_pathdetach()
{
	self.attachedpath = undefined; 
	self notify( "newpath" );

	self setGoalyaw( flat_angle( self.angles )[ 1 ] );
	self	setvehgoalpos( self.origin + ( 0, 0, 4 ), 1 );

}

vehicle_to_dummy()
{
	 // create a dummy model that takes the place of a vehicle, the vehicle gets hidden
	assertEx( !isdefined( self.modeldummy ), "Vehicle_to_dummy was called on a vehicle that already had a dummy." );
	self.modeldummy = spawn( "script_model", self.origin );
	self.modeldummy setmodel( self.model );

	self.modeldummy.origin = self.origin; 
	self.modeldummy.angles = self.angles; 

	self.modeldummy useanimtree( #animtree );

	self hide();

	self notify( "animtimer" );

	 // move rider characters to dummy model
	move_riders_here( self.modelDummy );
	move_turrets_here( self.modeldummy );

	 // flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = true; 
	return self.modeldummy; 
}

dummy_to_vehicle()
{
	assertEx( isdefined( self.modeldummy ), "Tried to turn a vehicle from a dummy into a vehicle. Can only be called on vehicles that have been turned into dummies with vehicle_to_dummy." );

	if( self isHelicopter() )
		self.modeldummy.origin = self gettagorigin( "tag_ground" );
	else
	{
		self.modeldummy.origin = self.origin; 
		self.modeldummy.angles = self.angles; 
	}
	self show();

	 // move rider characters back to the vehicle
	move_riders_here( self );
	move_turrets_here( self );

	 // flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = false; 
	self.modeldummy delete();
	self.modeldummy = undefined; 
	return self.modeldummy; 
}

move_riders_here( base )
{
	riders = self.riders; 
	 // move rider characters to their new location
	for( i = 0; i < riders.size; i ++ )
	{
		if( !isdefined( riders[ i ] ) )
			continue; 
		guy = riders[ i ]; 
		guy unlink();
		animpos = maps\_vehicle_aianim::anim_pos( self, guy.pos );
		guy linkto( base, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
		if( isai( guy ) )
			guy teleport( base gettagorigin( animpos.sittag ) );
		else
			guy.origin = base gettagorigin( animpos.sittag );
	}
}

setup_targetname_spawners()
{
	level.vehicle_targetname_array = []; 

	vehicles = getentarray( "script_vehicle", "classname" );

	 /* 
	 // disabling this until we can get a spawner checkbox on vehicles
	highestGroup = 0; 
	 // get the highest script_vehicleSpawnGroup in use
	for( i = 0; i < vehicles.size; i ++ )
	{
		if( !isdefined( vehicles[ i ].script_vehicleSpawnGroup ) )
			continue; 

		if( vehicles[ i ].script_vehicleSpawnGroup > highestGroup )
		{
			highestGroup = vehicles[ i ].script_vehicleSpawnGroup; 
		}
	}
	 */ 

	for( i = 0; i < vehicles.size; i ++ )
	{
		if( !isdefined( vehicles[ i ].targetname ) )
			continue; 
		if( !isdefined( vehicles[ i ].script_vehicleSpawnGroup ) )
		{
			 // vehicles that have no script_vehiclespawngroup get assigned one, if they have a targetname
 // 			highestGroup ++ ; 
 // 			vehicles[ i ].script_vehicleSpawnGroup = highestGroup; 
			continue; 
		}

		targetname = vehicles[ i ].targetname; 
		spawngroup = vehicles[ i ].script_vehicleSpawnGroup; 

		if( !isdefined( level.vehicle_targetname_array[ targetname ] ) )
			level.vehicle_targetname_array[ targetname ] = []; 

		level.vehicle_targetname_array[ targetname ][ spawngroup ] = true; 
	}
}

spawn_vehicles_from_targetname( name )
{
	 // spawns an array of vehicles that all have the specified targetname in the editor, 
	 // but are deleted at runtime
	assertEx( isdefined( level.vehicle_targetname_array[ name ] ), "No vehicle spawners had targetname " + name );

	array = level.vehicle_targetname_array[ name ]; 
	keys = getArrayKeys( array );

	vehicles = []; 
	for( i = 0; i < keys.size; i ++ )
	{
		vehicleArray = scripted_spawn( keys[ i ] );
		vehicles = array_combine( vehicles, vehicleArray );
	}

	return vehicles; 
}

spawn_vehicle_from_targetname( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	assertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );

	return vehicleArray[ 0 ]; 
}

spawn_vehicle_from_targetname_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	assertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );

	thread gopath( vehicleArray[ 0 ] );
	return vehicleArray[ 0 ]; 
}

spawn_vehicles_from_targetname_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	for( i = 0; i < vehicleArray.size; i ++ )
		thread goPath( vehicleArray[ i ] );

	return vehicleArray; 
}

helicopter_dust_kickup()
{
	self endon( "death_finished" );

	assert( isdefined( self.vehicletype ) );

	maxHeight = 1200; 
	minHeight = 350; 

	slowestRepeatWait = 0.15; 
	fastestRepeatWait = 0.05; 

	numFramesPerTrace = 3; 
	doTraceThisFrame = numFramesPerTrace; 

	defaultRepeatRate = 1.0; 
	repeatRate = defaultRepeatRate; 

	trace = undefined; 
	d = undefined; 

	while( isdefined( self ) )
	{
		if( repeatRate <= 0 )
		repeatRate = defaultRepeatRate; 
		wait repeatRate; 
		
		if( !isdefined( self ) )
			return; 
		
		doTraceThisFrame -- ; 

		 // prof_begin( "helicopter_dust_kickup" );

		if( doTraceThisFrame <= 0 )
		{
			doTraceThisFrame = numFramesPerTrace; 

			trace = bullettrace( self.origin, self.origin - ( 0, 0, 100000 ), false, self );
			 /* 
			trace[ "entity" ]
			trace[ "fraction" ]
			trace[ "normal" ]
			trace[ "position" ]
			trace[ "surfacetype" ]
			 */ 

			d = distance( self.origin, trace[ "position" ] );

			repeatRate = (( d - minHeight ) / ( maxHeight - minHeight ) ) * ( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait; 
		}

		if( !isdefined( trace ) )
			continue; 

		assert( isdefined( d ) );

		if( d > maxHeight )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( isdefined( trace[ "entity" ] ) )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( !isdefined( trace[ "position" ] ) )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( !isdefined( trace[ "surfacetype" ] ) )
			trace[ "surfacetype" ] = "dirt"; 
		assertEx( isdefined( level._vehicle_effect[ self.vehicletype ] ), self.vehicletype + " vehicle script hasn't run _tradfx properly" );
		assertEx( isdefined( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] ), "UNKNOWN SURFACE TYPE: " + trace[ "surfacetype" ] );

		 // prof_end( "helicopter_dust_kickup" );

		if( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] != - 1 )
			playfx( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ], trace[ "position" ] );
	}
}

tank_crush( crushedVehicle, endNode, tankAnim, truckAnim, animTree, soundAlias )
{
	 // Chad G's tank crushing vehicle script. Self corrects for node positioning errors.

	assert( isdefined( crushedVehicle ) );
	assert( isdefined( endNode ) );
	assert( isdefined( tankAnim ) );
	assert( isdefined( truckAnim ) );
	assert( isdefined( animTree ) );



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Create an animatable tank and move the real tank to the next path and store required info
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	animatedTank = vehicle_to_dummy();
	self setspeed( 7, 5, 5 );


	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Total time for animation, and correction and uncorrection times
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	animLength = getanimlength( tankAnim );
	move_to_time = ( animLength / 3 );
	move_from_time = ( animLength / 3 );



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Node information used for calculating both starting and ending points for the animation
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	 // get node vecs
	node_origin = crushedVehicle.origin; 
	node_angles = crushedVehicle.angles; 
	node_forward = anglesToForward( node_angles );
	node_up = anglesToUp( node_angles );
	node_right = anglesToRight( node_angles );



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Calculate Starting Point for the animation from crushedVehicle and create the dummy
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	 // get anim starting point origin and angle
	anim_start_org = getStartOrigin( node_origin, node_angles, tankAnim );
	anim_start_ang = getStartAngles( node_origin, node_angles, tankAnim );

	 // get anim starting point vecs
	animStartingVec_Forward = anglesToForward( anim_start_ang );
	animStartingVec_Up = anglesToUp( anim_start_ang );
	animStartingVec_Right = anglesToRight( anim_start_ang );

	 // get tank vecs
	tank_Forward = anglesToForward( animatedTank.angles );
	tank_Up = anglesToUp( animatedTank.angles );
	tank_Right = anglesToRight( animatedTank.angles );

	 // spawn dummy with appropriate offset
	offset_Vec = ( node_origin - anim_start_org );
	offset_Forward = vectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = vectorDot( offset_Vec, animStartingVec_Right );
	dummy = spawn( "script_origin", animatedTank.origin );
	dummy.origin += vector_multiply( tank_Forward, offset_Forward );
	dummy.origin += vector_multiply( tank_Up, offset_Up );
	dummy.origin += vector_multiply( tank_Right, offset_Right );

	 // set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = anglesToForward( node_angles );
	offset_Forward = vectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = vectorDot( offset_Vec, animStartingVec_Right );
	dummyVec = vector_multiply( tank_Forward, offset_Forward );
	dummyVec += vector_multiply( tank_Up, offset_Up );
	dummyVec += vector_multiply( tank_Right, offset_Right );
	dummy.angles = vectorToAngles( dummyVec );



	 // -- -- -- -- -- -- -- -- -- -- - 
	 // Debug Lines
	 // -- -- -- -- -- -- -- -- -- -- - 
	if( getdvar( "debug_tankcrush" ) == "1" )
	{
		 // line to where tank1 is
		thread draw_line_from_ent_for_time( level.player, animatedTank.origin, 1, 0, 0, animLength / 2 );

		 // line to where tank1 SHOULD be
		thread draw_line_from_ent_for_time( level.player, anim_start_org, 0, 1, 0, animLength / 2 );

		 // line to the dummy
		thread draw_line_from_ent_to_ent_for_time( level.player, dummy, 0, 0, 1, animLength / 2 );
	}



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Animate the animatable tank and self correct into the crushed vehicle
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	if( isdefined( soundAlias ) )
		level thread play_sound_in_space( soundAlias, node_origin );

	animatedTank linkto( dummy );
	crushedVehicle useAnimTree( animTree );
	animatedTank useAnimTree( animTree );

	assert( isdefined( level._vehicle_effect[ "tankcrush" ][ "window_med" ] ) );
	assert( isdefined( level._vehicle_effect[ "tankcrush" ][ "window_large" ] ) );

	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_left_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.2 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_right_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.4 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_back_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 0.7 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_front_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 1.5 );

	crushedVehicle animscripted( "tank_crush_anim", node_origin, node_angles, truckAnim );
	animatedTank animscripted( "tank_crush_anim", dummy.origin, dummy.angles, tankAnim );

	dummy moveTo( node_origin, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
	dummy rotateTo( node_angles, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
	wait move_to_time; 

	animLength -= move_to_time; 
	animLength -= move_from_time; 

	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	 // Tank plays animation in the exact correct location for a while
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	wait animLength; 

	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	 // Calculate Ending Point for the animation from crushedVehicle
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

	 // get anim ending point origin and angle
	 // anim_end_org = anim_start_org + getMoveDelta( tankAnim, 0, 1 );
	temp = spawn( "script_model", ( anim_start_org ) );
	temp.angles = anim_start_ang; 
	anim_end_org = temp localToWorldCoords( getMoveDelta( tankAnim, 0, 1 ) );
	anim_end_ang = anim_start_ang + ( 0, getAngleDelta( tankAnim, 0, 1 ), 0 );
	temp delete();

	 // get anim ending point vecs
	animEndingVec_Forward = anglesToForward( anim_end_ang );
	animEndingVec_Up = anglesToUp( anim_end_ang );
	animEndingVec_Right = anglesToRight( anim_end_ang );

	 // get ending tank pos vecs
	attachPos = self getAttachPos( endNode );
	tank_Forward = anglesToForward( attachPos[ 1 ] );
	tank_Up = anglesToUp( attachPos[ 1 ] );
	tank_Right = anglesToRight( attachPos[ 1 ] );

	 // see what the dummy's final origin will be
	offset_Vec = ( node_origin - anim_end_org );
	offset_Forward = vectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = vectorDot( offset_Vec, animEndingVec_Right );
	dummy.final_origin = attachPos[ 0 ]; 
	dummy.final_origin += vector_multiply( tank_Forward, offset_Forward );
	dummy.final_origin += vector_multiply( tank_Up, offset_Up );
	dummy.final_origin += vector_multiply( tank_Right, offset_Right );

	 // set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = anglesToForward( node_angles );
	offset_Forward = vectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = vectorDot( offset_Vec, animEndingVec_Right );
	dummyVec = vector_multiply( tank_Forward, offset_Forward );
	dummyVec += vector_multiply( tank_Up, offset_Up );
	dummyVec += vector_multiply( tank_Right, offset_Right );
	dummy.final_angles = vectorToAngles( dummyVec );

	 // -- -- -- -- -- -- -- -- -- -- - 
	 // Debug Lines
	 // -- -- -- -- -- -- -- -- -- -- - 
	if( getdvar( "debug_tankcrush" ) == "1" )
	{
		 // line to where tank2 is
		thread draw_line_from_ent_for_time( level.player, self.origin, 1, 0, 0, animLength / 2 );

		 // line to where tank2 SHOULD be
		thread draw_line_from_ent_for_time( level.player, anim_end_org, 0, 1, 0, animLength / 2 );

		 // line to the dummy
		thread draw_line_from_ent_to_ent_for_time( level.player, dummy, 0, 0, 1, animLength / 2 );
	}



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	 // Tank uncorrects to the real location of the tank on the spline
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

	dummy moveTo( dummy.final_origin, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	dummy rotateTo( dummy.final_angles, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	wait move_from_time; 



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Tank is done animating now, remove the animatable tank and show the real one( they should be perfectly aligned now )
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	self dontInterpolate();
	self attachPath( endNode );
	dummy_to_vehicle();
}

tank_crush_fx_on_tag( tagName, fxName, soundAlias, startDelay )
{
	if( isdefined( startDelay ) )
		wait startDelay; 
	playfxontag( fxName, self, tagName );
	if( isdefined( soundAlias ) )
		self thread play_sound_on_tag( soundAlias, tagName );
}

loadplayer( position, animfudgetime )
{
	if( getdvar( "fastrope_arms" ) == "" )
		setdvar( "fastrope_arms", "0" );
	if( !isdefined( animfudgetime ) )
		animfudgetime = 0; 
	assert( isdefined( self.riders ) );
	assert( self.riders.size );
	guy = undefined; 
	for( i = 0; i < self.riders.size; i ++ )
	{
		if( self.riders[ i ].pos == position )
		{
			guy = self.riders[ i ]; 
			guy.drone_delete_on_unload = true; 
			guy.playerpiggyback = true; 
			break; 
		}
	}

	assertex( !isai( guy ), "guy in position of player needs to have script_drone set, use script_startingposition ans script drone in your map" );
	assert( isdefined( guy ) );
	thread show_rigs( position );
	animpos = maps\_vehicle_aianim::anim_pos( self, position );

 // 	guy stopanimscripted();
 // 	guy stopuseanimtree();
	guy notify( "newanim" );
	guy detachall();
 // 	guy setmodel( "" );
	guy setmodel( "fastrope_arms" );
	guy useanimtree( animpos.player_animtree );
	thread maps\_vehicle_aianim::guy_idle( guy, position );
	 // playerlinktodelta( < linkto entity > , < tag > , < viewpercentag fraction > , < right arc > , < left arc > , < top arc > , < bottom arc > )
	level.player playerlinktodelta( guy, "tag_player", 1.0, 70, 70, 90, 90 );

	 // level.player setplayerangles( guy gettagangles( "tag_player" ) );

	 // level.player allowcrouch( false );
	 // level.player allowprone( false );
	 // level.player allowstand( true );

	guy hide();

	animtime = getanimlength( animpos.getout );
	animtime -= animfudgetime; 
	self waittill( "unload" );

	if( getdvar( "fastrope_arms" ) != "0" )
		guy show();
	level.player disableweapons();
 // 	guy waittill( "jumpedout" );

	guy notsolid();

	wait animtime; 

	level.player unlink();
	level.player enableweapons();
	 // level.player allowcrouch( true );
	 // level.player allowprone( true );
}

show_rigs( position )
{
	wait .01; 
	self thread maps\_vehicle_aianim::getout_rigspawn( self, position ); // spawn the getoutrig for this position
	if( !self.riders.size )
		return; 
	for( i = 0; i < self.riders.size; i ++ )
		self thread maps\_vehicle_aianim::getout_rigspawn( self, self.riders[ i ].pos );
}

vehicle_deleteme()
{
	self notify( "deleteme" );
	waittillframeend; 
	self delete();
}


wheeldirectionchange( direction )
{
	if( direction <= 0 )
		self.wheeldir = 0; 
	else
		self.wheeldir = 1; 
}

maingun_FX()
{
	if( !isdefined( level.vehicle_deckdust[ self.model ] ) )
		return; 
	self endon( "death" );
	while( true )
	{
		self waittill( "weapon_fired" ); // waits for Code notify when fireWeapon() is called.
		playfxontag( level.vehicle_deckdust[ self.model ], self, "tag_engine_exhaust" );
		barrel_origin = self gettagorigin( "tag_flash" );
		ground = physicstrace( barrel_origin, barrel_origin + ( 0, 0, - 128 ) );
		physicsExplosionSphere( ground, 192, 100, 1 );
	}
}

playTankExhaust()
{
	if( !isdefined( level.vehicle_exhaust[ self.model ] ) )
		return; 

	exhaustDelay = 0.1; 
	for( ;; )
	{
		if( !isdefined( self ) )
			return; 
		if( !isalive( self ) )
			return; 
		playfxontag( level.vehicle_exhaust[ self.model ], self, "tag_engine_exhaust" );
		wait exhaustDelay; 
	}
}

build_light( model, name, tag, effect, group, delay )
{
	if( !isdefined( level.vehicle_lights ) )
		level.vehicle_lights = []; 
	struct = spawnstruct();
	struct.name = name; 
	struct.tag = tag; 
	struct.delay = delay; 
	struct.effect = loadfx( effect );

	level.vehicle_lights[ model ][ name ] = struct; 
	group_light( model, name, "all" );
	if( isdefined( group ) )
		group_light( model, name, group );
}

group_light( model, name, group )
{
	if( !isdefined( level.vehicle_lights_group ) )
		level.vehicle_lights_group = []; 
	if( !isdefined( level.vehicle_lights_group[ model ] ) )
		level.vehicle_lights_group[ model ] = []; 
	if( !isdefined( level.vehicle_lights_group[ model ][ group ] ) )
		level.vehicle_lights_group[ model ][ group ] = []; 
	level.vehicle_lights_group[ model ][ group ][ level.vehicle_lights_group[ model ][ group ].size ] = name; 
}

lights_on( group, bnotthreaded )
{
	 // hack for lights make this thing thread.
	if( !isdefined( bnotthreaded ) )
	{
		thread lights_on( group, true );
		return; 
	}
	
	if( !isdefined( group ) )
		group = "all"; 
	
	assert( isdefined( level.vehicle_lights_group[ self.model ] ) );
	assert( isdefined( level.vehicle_lights_group[ self.model ][ group ] ) );
	 // hack for lights limits.
	self endon( "death" );
	if( !isdefined( level.fxdelay ) )
		level.fxdelay = false; 
	while( level.fxdelay )
		wait .05; 
	level.fxdelay = true; 
	if( !isdefined( self.lights ) )
		self.lights = []; 
	lights = level.vehicle_lights_group[ self.model ][ group ]; 
	
	count = 0; 
	for( i = 0; i < lights.size; i ++ )
	{
		if( isdefined( self.lights[ lights[ i ] ] ) )
			continue;  // light is already on

		template = level.vehicle_lights[ self.model ][ lights[ i ] ]; 
		if( isdefined( template.delay ) )
			delay = template.delay; 
		else
			delay = 0; 

		 // Nate - effects can only be stopped on an object when it is deleted. therefor we fake it by spawning a model, 
		 // this is expensive so it's required that people turn it on.
		if( isdefined( self.script_light_toggle ) && self.script_light_toggle )
		{
			light = spawn( "script_model", ( 0, 0, 0 ) );
			light setmodel( "fx" );
			light hide();
			light linkto( self, template.tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
			 thread light_death( light );
			playfxontag_delay( template.effect, light, "Trim_Char_F_1_1", delay );
		}
		else
		{
			light = self; 
			thread playfxontag_delay( template.effect, light, template.tag, delay );
		}
		self.lights[ lights[ i ] ] = light; 
		count ++ ; 
		if( count > 2 )
		{
			wait .05; 
			count = 0; 
		}
	}
	level.fxdelay = false; 

}

playfxontag_delay( effect, entity, tag, delay )
{
	entity endon( "death" );
	wait delay; 
	playfxontag( effect, entity, tag );
}

light_death( light )
{
	self waittill( "death" );
	light delete();
}

lights_off( group )
{
	if( !isdefined( group ) )
		group = "all"; 
	assertEX( isdefined( self.script_light_toggle ) && self.script_light_toggle, "can't turn off lights on a vehicle without script_light_toggle" );
	if( !isdefined( self.lights ) )
		return; 

	if( !isdefined( level.vehicle_lights_group[ self.model ][ group ] ) )
	{
		println( "vehicletype: " + self.vehicletype );
		println( "light group: " + group );
		assertmsg( "lights not defined for this vehicle( see console" );
	}
	lights = level.vehicle_lights_group[ self.model ][ group ]; 
	for( i = 0; i < lights.size; i ++ )
		self.lights[ lights[ i ] ] delete();
}

 // Nate - new things out of uber trigger function.
 // not sure if it's better to have a separate thread or to have one thread with a bunch of bools and isdefined checks

script_vehicle_lights_off()
{
	self waittill( "trigger", other );
	other thread lights_off( self.script_vehicle_lights_off );
}

script_vehicle_lights_on()
{
	self waittill( "trigger", other );
	other thread lights_on( self.script_vehicle_lights_on );
}


 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_deathmodel( < model > , < deathmodel > )"
"Summary: called in individual vehicle file - assigns death model to vehicles with this model. "
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < model > : name of model to associate death model"
"OptionalArg: < deathmodel > : name of death model to be associated with model"
"Example: build_deathmodel( "bmp", "bmp_destroyed" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_deathmodel( model, deathmodel )
{
	if( model != level.vtmodel )
		return; 
	if( !isdefined( deathmodel ) )
		deathmodel = model; 
	precachemodel( model );
	precachemodel( deathmodel );
	level.vehicle_deathmodel[ model ] = deathmodel; 
}


 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_shoot_shock( < shock > )"
"Summary: called in individual vehicle file - assigns shock file to be played when main cannon on a tank fires "
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < shock > : the shock asset"
"Example: build_shoot_shock( "tankblast" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_shoot_shock( shock )
{
	 // shock script uses "black" hudelem or something. I don't know . Just had to move it out of _m1a1.gsc
	precacheShader( "black" );
	precacheshellshock( shock );
	level.vehicle_shoot_shock[ level.vtmodel ] = shock; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_drive( < forward > , < reverse > , < normalspeed > , < rate > )"
"Summary: called in individual vehicle file - assigns animations to be used on vehicles"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < forward > : forward animation"
"OptionalArg: < reverse > : reverse animation"
"OptionalArg: < normalspeed > : speed at which animation will be played at 1x defaults to 10mph"
"OptionalArg: < rate > : scales speed of animation( please only use this for testing )"
"Example: 	build_drive( %abrams_movement, %abrams_movement_backwards, 10 );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_drive( forward, reverse, normalspeed, rate )
{
	if( !isdefined( normalspeed ) )
		normalspeed = 10; 
	level.vehicle_DriveIdle[ level.vtmodel ] = forward; 
	
	if( isdefined( reverse ) )
		level.vehicle_DriveIdle_r[ level.vtmodel ] = reverse; 
	level.vehicle_DriveIdle_normal_speed[ level.vtmodel ] = normalspeed; 
	if( isdefined( rate ) )
		level.vehicle_DriveIdle_animrate[ level.vtmodel ] = rate; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_template( < type > , < model > , < typeoverride > )"
"Summary: called in individual vehicle file - mandatory to call this in all vehicle files at the top!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < type > : vehicle type to set"
"MandatoryArg: < model > : model to set( this is usually generated by the level script )"
"OptionalArg: < typeoverride > : this overrides the type, used for copying a vehicle script"
"Example: 	build_template( "bmp", model, type );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_template( type, model, typeoverride )
{
	if( isdefined( typeoverride ) )
		type = typeoverride; 
	precachevehicle( type );

	if( !isdefined( level.vehicle_death_fx ) )
		level.vehicle_death_fx = []; 
	if( 	!isdefined( level.vehicle_death_fx[ type ] ) )
		level.vehicle_death_fx[ type ] = []; // can have overrides
		
	level.vehicle_compassicon[ type ] = []; 
	level.vehicle_team[ type ] = "axis"; 
	level.vehicle_life[ type ] = 999; 
	level.vehicle_hasMainTurret[ type ] = false; 
	level.vtmodel = model; 
	level.vttype = type; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_exhaust( < exhaust_effect_str > )"
"Summary: called in individual vehicle file - assign an exhaust effect to this vehicle!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < exhaust_effect_str > : exhaust effect in string format"
"Example: 	build_exhaust( "distortion / abrams_exhaust" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_exhaust( effect )
{
	level.vehicle_exhaust[ level.vtmodel ] = loadfx( effect );
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_treadfx()"
"Summary: called in individual vehicle file - enables treadfx"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"Example: 	build_treadfx();"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_treadfx( type )
{
	if( ! isdefined( type ) )
		type = level.vttype; 
	maps\_treadfx::main( type );
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_team( < team > )"
"Summary: called in individual vehicle file - sets team"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < team > : team"
"Example: 	build_team( "allies" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_team( team )
{
	level.vehicle_team[ level.vttype ] = team; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_mainturret( < firetime > )"
"Summary: called in individual vehicle file - enables main( cannon ) turret"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"Example: 	build_mainturret();"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_mainturret()
{
	level.vehicle_hasMainTurret[ level.vtmodel ] = true; 
}


 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_aianims( < aithread > , < vehiclethread > )"
"Summary: called in individual vehicle file - set threads for ai animation and vehicle animation assignments"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < aithread > : ai thread"
"OptionalArg: < vehiclethread > : vehicle thread"
"Example: 	build_aianims( ::setanims, ::set_vehicle_anims );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_aianims( aithread, vehiclethread )
{
	level.vehicle_aianims[ level.vttype ] = [ [ aithread ] ]();
	if( isdefined( vehiclethread ) )
		level.vehicle_aianims[ level.vttype ] = [ [ vehiclethread ] ]( level.vehicle_aianims[ level.vttype ] );
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_frontarmor( < armor > )"
"Summary: called in individual vehicle file - sets percentage of health to regen on attacks from the front"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < armor > : ercentage of health to regen on attacks from the front"
"Example: 	build_frontarmor( .33 );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_frontarmor( armor )
{
	level.vehicle_frontarmor [ level.vttype ] = armor; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_crashanim( < modelsthread > )"
"Summary: called in individual vehicle file - thread for building attached models( ropes ) with animation"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < modelsthread > : thread"
"Example: 			build_attach_models( ::set_attached_models );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_attach_models( modelsthread )
{
	level.vehicle_attachedmodels[ level.vttype ] = [ [ modelsthread ] ]();; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_unload_groups( < unloadgroupsthread > )"
"Summary: called in individual vehicle file - thread for building unload groups"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < modelsthread > : thread"
"Example: 			build_unload_groups( ::Unload_Groups );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_unload_groups( unloadgroupsthread )
{
	level.vehicle_unloadgroups[ level.vttype ] = [ [ unloadgroupsthread ] ]();
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_unload_groups( < health > , < minhealth > , < maxhealth > , )"
"Summary: called in individual vehicle file - sets health for vehicles"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < health > :  health"
"OptionalArg: < minhealth > : randomly chooses between the minhealth, maxhealth"
"OptionalArg: < maxhealth > : randomly chooses between the minhealth, maxhealth"
"Example: 			build_life( 999, 500, 1500 );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_life( health, minhealth, maxhealth )
{
	level.vehicle_life[ level.vttype ] = health; 
	level.vehicle_life_range_low[ level.vttype ] = minhealth; 
	level.vehicle_life_range_high[ level.vttype ] = maxhealth; 
}


 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_compassicon()"
"Summary: called in individual vehicle file - enables vehicle on the compass( they use tank icons )"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"Example: 			build_compassicon();"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_compassicon()
{
	level.vehicle_compassicon[ level.vttype ] = true; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_deckdust( < effect > )"
"Summary: called in individual vehicle file - sets a deckdust effect on a vehicle?"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < effect > :  effect to be assigned as deckdust"
"Example: 			build_deckdust( "dust / abrams_desk_dust" );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_deckdust( effect )
{
	level.vehicle_deckdust[ level.vtmodel ] = loadfx( effect );
}

build_destructible( model, destructible )
{
	assert( isdefined( model ) );
	assert( isdefined( destructible ) );
	if( model != level.vtmodel )
		return; 
	struct = spawnstruct();
	struct.destuctableInfo = maps\_destructible_types::makeType( destructible );; 
	struct thread maps\_destructible::precache_destructibles();
	
	level.destructible_model[ level.vtmodel ] = destructible; 
}		

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: build_localinit( < init_thread > )"
"Summary: called in individual vehicle file - mandatory for all vehicle files, this sets the individual init thread for those special sequences, it is also used to determine that a vehicle is being precached or not"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: < init_thread > :  local thread to the vehicle to be called when it spawns"
"Example: 			build_localinit( ::init_local );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

build_localinit( init_thread )
{
	
	level.vehicleInitThread[ level.vttype ][ level.vtmodel ] = init_thread; 
}

 /* 
 == == == == == == = 
 // / ScriptDocBegin
"Name: helipath( < init_thread > )"
"Summary: Makes a helicopter chase a chain of spawnstructs"
"Module: _vehicle"
"CallOn: Helicopters"
"MandatoryArg: < msg > : First targetname of the spawnstruct chain"
"MandatoryArg: < maxspeed > : Maxspeed of the heli"
"MandatoryArg: < accel > : Accelleration of the heli"
"Example: 			heli helipath( "helipath3, 100, 25 );"
"SPMP: singleplayer"
 // / ScriptDocEnd
 == == == == == == = 
 */ 

helipath( msg, maxspeed, accel )
{
	self endon( "death" );
	self clearLookAtEnt();
	 // gets a path from the targetname that is passed
	 // sets the lookat for the vehicle to ents that are script_linkname'd to the path
	dest = getstruct( msg, "targetname" );

	self setairresistance( 30 );
	self setSpeed( maxspeed, accel, 5 );
 // 	self setturningability( 1 );

	for( ;; )
	{
 // 		self thread draw_dest_line( dest.origin );
 // 		if( isdefined( dest.angles ) )
 // 			self setgoalyaw( dest.angles[ 1 ] );
		nextdest = undefined; 
		if( isdefined( dest.target ) )
		{
			nextdest = getstruct( dest.target, "targetname" );
		}

		if( isdefined( dest.angles ) )
		{
			self setgoalyaw( dest.angles[ 1 ] );
		}
		else
		{
			self cleargoalyaw();
		}

		if( isdefined( dest.script_flag_set ) )
		{
			flag_set( dest.script_flag_set );
		}

		if( isdefined( dest.script_flag_wait ) )
		{
			 // wait at the end point if it has flag wait
			self setVehGoalPos( dest.origin, true );
			flag_wait( dest.script_flag_wait );
			self setVehGoalPos( dest.origin, false );
		}
		else
		{
			self setVehGoalPos( dest.origin, false );
		}

		radius = 400; 
		if( isdefined( dest.radius ) )
			radius = dest.radius; 
			
		while( distance( self.origin, dest.origin ) >= radius )
			wait( 0.05 );
	
		if( isdefined( dest.script_accel ) )
			accel = dest.script_accel; 
		if( isdefined( dest.speed ) )
			maxspeed = dest.speed; 
			
		self setSpeed( maxspeed, accel, 5 );
		
		
		set_lookat_from_dest( dest );

		if( !isdefined( nextdest ) )
			break; 
		dest = nextdest; 
	}

 // 	self thread draw_dest_line( dest.origin );
	self setSpeed( maxspeed, accel, 5 );
	self setVehGoalPos( dest.origin, true );

	set_lookat_from_dest( dest );
}

add_flags_from_chain( dest )
{
	visited = []; 

	for( ;; )
	{
		if( isdefined( dest.script_flag_set ) )
		{
			if( !isdefined( level.flag[ dest.script_flag_set ] ) )
			{
				flag_init( dest.script_flag_set );
			}
		}
		if( isdefined( dest.script_flag_wait ) )
		{
			if( !isdefined( level.flag[ dest.script_flag_wait ] ) )
			{
				flag_init( dest.script_flag_wait );
			}
		}
		if( !isdefined( dest.target ) )
			return; 

		visited[ visited.size ] = dest; 
		dest = getstruct( dest.target, "targetname" );
	
		if( is_in_array( visited, dest ) )
			return; 
	}
}

set_lookat_from_dest( dest )
{
	if( !isdefined( dest.script_linkto ) )
		return; 

	viewTarget = getent( dest.script_linkto, "script_linkname" );
	self setLookAtEnt( viewTarget );
}

getspawner_byid( id )
{
	return level.vehicle_spawners[ id ]; 
}

vehicle_getspawner()
{
	assert( isdefined( self.spawner_id ) );
	return getspawner_byid( self.spawner_id );
}

isDestructible()
{
	return isdefined( self.destructible_type );	
}