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
#include maps\_anim;
#include maps\_vehicle_aianim;
#include common_scripts\utility;
#using_animtree( "vehicles" );

CONST_MPHCONVERSION = 17.6;
CONST_bp_height = 300;

init_vehicles()
{

	// For Engineering when they need test specific functionality of vehicles
	if ( IsDefined( level.disableVehicleScripts ) && level.disableVehicleScripts )
		return;

	level.heli_default_decel = 10;// will likely go back to 10 in the near future

//	thread dump_handle();// press the hotkey and xenon will export a map with all the current vehicle positions

	init_helicopter_list();
	init_airplane_list();

	// vehicle related dvar initializing goes here
	setup_dvars();

	// initialize all the level wide vehicle system variables
	setup_levelvars();

	setup_vehicle_spawners();

	array_thread( GetEntArray( "truckjunk", "targetname" ), ::truckjunk );

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

	array_thread( getstructarray( "gag_stage_littlebird_unload", "script_noteworthy" ), ::setup_gag_stage_littlebird_unload );
	array_thread( getstructarray( "gag_stage_littlebird_load", "script_noteworthy" ), ::setup_gag_stage_littlebird_load );

	level.vehicle_processtriggers = undefined;

	init_level_has_vehicles();

	add_hint_string( "invulerable_frags", &"SCRIPT_INVULERABLE_FRAGS", undefined );
	add_hint_string( "invulerable_bullets", &"SCRIPT_INVULERABLE_BULLETS", undefined );

}

init_helicopter_list()
{
	level.helicopter_list = [];
	level.helicopter_list[ "blackhawk" ] = true;
	level.helicopter_list[ "blackhawk_minigun" ] = true;
	level.helicopter_list[ "blackhawk_minigun_so" ] = true;
	level.helicopter_list[ "apache" ] = true;
	level.helicopter_list[ "seaknight" ] = true;
	level.helicopter_list[ "seaknight_airlift" ] = true;
	level.helicopter_list[ "hind" ] = true;
	level.helicopter_list[ "mi17" ] = true;
	level.helicopter_list[ "mi17_noai" ] = true;
	level.helicopter_list[ "mi17_bulletdamage" ] = true;
	level.helicopter_list[ "cobra" ] = true;
	level.helicopter_list[ "cobra_player" ] = true;
	level.helicopter_list[ "viper" ] = true;
	level.helicopter_list[ "littlebird_player" ] = true;
	level.helicopter_list[ "littlebird" ] = true;
	level.helicopter_list[ "mi28" ] = true;
	level.helicopter_list[ "pavelow" ] = true;
	level.helicopter_list[ "pavelow_noai" ] = true;
	level.helicopter_list[ "harrier" ] = true;
}

init_airplane_list()
{
	level.airplane_list = [];
	level.airplane_list[ "mig29" ] = true;
	level.airplane_list[ "b2" ] = true;
}

init_level_has_vehicles()
{
	level.levelHasVehicles = false;
	// if there are any vehicles prespawned of any team in the level then there are vehicles

	vehicles = GetEntArray( "script_vehicle", "code_classname" );
	if ( vehicles.size > 0 )
		level.levelHasVehicles = true;
}


trigger_getlinkmap( trigger )
{
	linkMap = [];
	if ( IsDefined( trigger.script_linkTo ) )
	{
		links = StrTok( trigger.script_linkTo, " " );
		foreach ( link in links )
			linkMap[ link ] = true;
		links = undefined;
	}
	return linkMap;
}

// setup_script_gatetrigger( trigger, linkMap )
setup_script_gatetrigger( trigger )
{
	gates = [];
	if ( IsDefined( trigger.script_gatetrigger ) )
		return level.vehicle_gatetrigger[ trigger.script_gatetrigger ];
	return gates;
}

// setup_script_vehiclespawngroup( trigger, vehicles, linkMap )
setup_script_vehiclespawngroup( trigger, vehicles )
{
	script_vehiclespawngroup = false;
	if ( IsDefined( trigger.script_VehicleSpawngroup ) )
		script_vehiclespawngroup = true;
	return script_vehiclespawngroup;
}

setup_vehicle_spawners()
{
	spawners = _getvehiclespawnerarray();
	foreach ( spawner in spawners )
	{
		spawner thread vehicle_spawn_think();
	}
}

vehicle_spawn_think()
{
	if ( IsDefined( self.script_kill_vehicle_spawner ) )
	{
		group = self.script_kill_vehicle_spawner;
		if ( !isdefined( level.vehicle_killspawn_groups[ group ] ) )
		{
			level.vehicle_killspawn_groups[ group ] = [];
		}
		level.vehicle_killspawn_groups[ group ][ level.vehicle_killspawn_groups[ group ].size ] = self;
	}

	if ( IsDefined( self.script_deathflag ) )
		thread maps\_spawner::vehicle_spawner_deathflag();

	self thread vehicle_linked_entities_think();

	self.count = 1;
	self.spawn_functions = [];
	for ( ;; )
	{
		vehicle = undefined;
		self waittill( "spawned", vehicle );
		self.count--;
		if ( !isdefined( vehicle ) )
		{
			PrintLn( "Vehicle spawned from spawner at " + self.origin + " but didnt exist!" );
			continue;
		}
		vehicle.spawn_funcs = self.spawn_functions;
		vehicle.spawner = self;

		vehicle thread maps\_spawner::run_spawn_functions();
	}
}

vehicle_linked_entities_think()
{
	//hides linked entities until spwned, then shows and links them to the spawned vehicle, then deletes them when vehicle dies

	if ( !isdefined( self.script_vehiclecargo ) )
		return;
	if ( !isdefined( self.script_linkTo ) )
		return;

	//this is just to get at least one of the ents it is linked to...code doesn't really support script_Linking to a prefab
	aLinkedEnts = GetEntArray( self.script_linkTo, "script_linkname" );
	if ( aLinkedEnts.size == 0 )
		return;

	//need cargo to have a unique targetname....we can't get script_linkTo arrays within a prefab,
	//and we can't target a vehicle to the cargo since we need to target it to its nodes
	targetname = aLinkedEnts[ 0 ].targetname;
	aLinkedEnts = GetEntArray( targetname, "targetname" );

	eOrg = undefined;
	foreach ( ent in aLinkedEnts )
	{
		if ( ent.classname == "script_origin" )
			eOrg = ent;
		ent Hide();
	}

	AssertEx( IsDefined( eOrg ), "Vehicles that have script_linkTo pointing to entities must have one of those entities be a script_origin to be used as a link point of reference" );

	foreach ( ent in aLinkedEnts )
	{
		if ( ent != eOrg )
			ent LinkTo( eOrg );
	}

	self waittill( "spawned", vehicle );

	foreach ( ent in aLinkedEnts )
	{
		ent Show();
		if ( ent != eOrg )
			ent LinkTo( vehicle );
	}
	vehicle waittill( "death" );

	foreach ( ent in aLinkedEnts )
		ent Delete();
}


is_trigger_once()
{
	// these triggers only trigger once where vehicle paths trigger everytime a vehicle crosses them
	if ( !isdefined( self.classname ) )
		return false;

	if ( self.classname == "trigger_multiple" )
		return true;

	if ( self.classname == "trigger_radius" )
		return true;

	if ( self.classname == "trigger_lookat" )
		return true;

	return self.classname == "trigger_disk";
}


trigger_process( trigger, vehicles )
{

	bTriggerOnce = trigger is_trigger_once();

	trigger.processed_trigger = undefined;// clear out this flag that was used to get the trigger to this point.

	// override to make a trigger loop
	if ( IsDefined( trigger.script_noteworthy ) && trigger.script_noteworthy == "trigger_multiple" )
		bTriggeronce = false;

	gates = setup_script_gatetrigger( trigger );

	script_vehiclespawngroup = IsDefined( trigger.script_VehicleSpawngroup );
	// origin paths and script struct paths get this value
	script_vehicledetour = 					IsDefined( trigger.script_vehicledetour ) && ( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) ) ;

	// ground paths get this value
	detoured = IsDefined( trigger.detoured ) && !( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );
	gotrigger = true;

	vehicles = undefined;

	while ( gotrigger )
	{
		trigger waittill( "trigger", other );

		if ( IsDefined( trigger.script_vehicletriggergroup ) )
		{
				if ( !isdefined( other.script_vehicletriggergroup ) )
					continue;
				if ( other.script_vehicletriggergroup != trigger.script_vehicletriggergroup )
					continue;
		}


		if ( IsDefined( trigger.enabled ) && !trigger.enabled )
			trigger waittill( "enable" );

		if ( IsDefined( trigger.script_flag_set ) )
		{
			if ( IsDefined( other.vehicle_flags ) )
				other.vehicle_flags[ trigger.script_flag_set ] = true;
			other notify( "vehicle_flag_arrived", trigger.script_flag_set );
			flag_set( trigger.script_flag_set );
		}

		if ( IsDefined( trigger.script_flag_clear ) )
		{
			if ( IsDefined( other.vehicle_flags ) )
				other.vehicle_flags[ trigger.script_flag_clear ] = false;
			flag_clear( trigger.script_flag_clear );
		}


		if ( script_vehicledetour )
			other thread path_detour_script_origin( trigger );
		else if ( detoured && IsDefined( other ) )
			other thread path_detour( trigger );

		trigger script_delay();

		if ( bTriggeronce )
			gotrigger = false;

		if ( IsDefined( trigger.script_vehicleGroupDelete ) )
		{
			if ( !isdefined( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] ) )
			{
				PrintLn( "failed to find deleteable vehicle with script_vehicleGroupDelete group number: ", trigger.script_vehicleGroupDelete );
				level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] = [];
			}
			array_levelthread( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ], ::deleteEnt );
		}

		if ( script_vehiclespawngroup )
		{
			scripted_spawn( trigger.script_VehicleSpawngroup );
		}

		if ( gates.size > 0 && bTriggeronce )
			array_levelthread( gates, ::path_gate_open );
		if ( IsDefined( trigger.script_VehicleStartMove ) )
		{
			if ( !isdefined( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ] ) )
			{
				PrintLn( "^3Vehicle start trigger is: ", trigger.script_VehicleStartMove );
				return;
			}
			array_levelthread( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ], ::gopath );
		}
	}
}

path_detour_get_detourpath( detournode )
{
	detourpath = undefined;
	foreach ( vehicle_detourpath in level.vehicle_detourpaths[ detournode.script_vehicledetour ] )
	{
		if ( vehicle_detourpath != detournode )
			if ( !islastnode( vehicle_detourpath ) )
				detourpath = vehicle_detourpath;
	}
	return detourpath;
}

path_detour_script_origin( detournode )
{
	detourpath = path_detour_get_detourpath( detournode );
	if ( IsDefined( detourpath ) )
		self thread vehicle_paths( detourpath );
}

crash_detour_check( detourpath )
{
	Assert( IsDefined( detourpath.script_crashtype ) );

	// long somewhat complex set of conditions on which a vehicle will detour through a crashpath.
	return
	(
		(
			IsDefined( self.deaddriver )
			 || ( self.health < self.healthbuffer )
			 || detourpath.script_crashtype == "forced"
		 )
		 &&
		(
		 !isdefined( detourpath.derailed )
		  || detourpath.script_crashtype == "plane"
		 )
	 );
}

crash_derailed_check( detourpath )
{
	return IsDefined( detourpath.derailed ) && detourpath.derailed;
}

path_detour( node )
{
	detournode = GetVehicleNode( node.target, "targetname" );
	detourpath = path_detour_get_detourpath( detournode );

	// be more aggressive with this maybe? 
	if ( ! IsDefined( detourpath ) )
		return;

	if ( node.detoured && !isdefined( detourpath.script_vehicledetourgroup ) )
		return;

	// if a detourpath have a crashtype it's a crashpath and should only be used by crashing vehicles.
	if ( IsDefined( detourpath.script_crashtype ) )
	{
		if ( !crash_detour_check( detourpath ) )
			return;

		self notify( "crashpath", detourpath );
		detourpath.derailed = 1;
		self notify( "newpath" );
		self _SetSwitchNode( node, detourpath );
		return;
	}
	else
	{
		if ( crash_derailed_check( detourpath ) )
			return;// .derailed crashpaths fail crash check. this keeps other vehicles from following.

		// detour paths specific to grouped vehicles. So they can share a lane and detour when they need to be exciting.			
		if ( IsDefined( detourpath.script_vehicledetourgroup ) )
		{
			if ( !isdefined( self.script_vehicledetourgroup ) )
				return;
			if ( detourpath.script_vehicledetourgroup != self.script_vehicledetourgroup )
				return ;
		}

		self notify( "newpath" );
		self _SetSwitchNode( detournode, detourpath );
		thread detour_flag( detourpath );
		if ( !islastnode( detournode ) && !( IsDefined( node.scriptdetour_persist ) && node.scriptdetour_persist ) )
			node.detoured = 1;
		self.attachedpath = detourpath;
		thread vehicle_paths();

		// handle transmission for physics vehicles.
		if ( self Vehicle_IsPhysVeh() && IsDefined( detournode.script_transmission ) )
			self thread reverse_node( detournode );
		return;
	}
}

reverse_node( detournode )
{
	self endon( "death" );

	detournode waittillmatch( "trigger", self );
	self.veh_transmission = detournode.script_transmission;
	if ( self.veh_transmission == "forward" )
		self vehicle_wheels_forward();
	else
		self vehicle_wheels_backward();
}

_SetSwitchNode( detournode, detourpath )
{
		AssertEx( !( detourpath.lookahead == 1 && detourpath.speed == 1 ), "Detourpath has lookahead and speed of 1, this is indicative that neither has been set." );
		self SetSwitchNode( detournode, detourpath );
}

detour_flag( detourpath )
{
		self endon( "death" );
		self.detouringpath = detourpath;
		detourpath waittillmatch( "trigger", self );
		self.detouringpath = undefined;
}

vehicle_Levelstuff( vehicle, trigger )
{
	// associate with links. false
	if ( IsDefined( vehicle.script_linkName ) )
		level.vehicle_link = array_2dadd( level.vehicle_link, vehicle.script_linkname, vehicle );

	if ( IsDefined( vehicle.script_VehicleStartMove ) )
		level.vehicle_StartMoveGroup = array_2dadd( level.vehicle_StartMoveGroup, vehicle.script_VehicleStartMove, vehicle );

	if ( IsDefined( vehicle.script_vehicleGroupDelete ) )
		level.vehicle_DeleteGroup = array_2dadd( level.vehicle_DeleteGroup, vehicle.script_vehicleGroupDelete, vehicle );


}

spawn_array( spawners )
{
	ai = [];
	stalinggradspawneverybody = ent_flag_exist( "no_riders_until_unload" ) ;

	foreach ( spawner in spawners )
	{
		spawner.count = 1;
		dronespawn = false;
		if ( IsDefined( spawner.script_drone ) )
		{
			dronespawn = true;
			spawned = dronespawn_bodyonly( spawner );
			spawned maps\_drone::drone_give_soul();
			Assert( IsDefined( spawned ) );
		}
		else
		{
			dontShareEnemyInfo = ( IsDefined( spawner.script_stealth ) && flag( "_stealth_enabled" ) && !flag( "_stealth_spotted" ) );

			if ( IsDefined( spawner.script_forcespawn ) || stalinggradspawneverybody )
				spawned = spawner StalingradSpawn( dontShareEnemyInfo );
			else
				spawned = spawner DoSpawn( dontShareEnemyInfo );
		}		

		if ( !dronespawn && !isalive( spawned ) )
			continue;
		Assert( IsDefined( spawned ) );
		ai[ ai.size ] = spawned;
	}

	ai = remove_non_riders_from_array( ai );
	return ai;
}

remove_non_riders_from_array( aiarray )
{
	living_ai = [];
	foreach ( ai in aiarray )
	{
		if ( !ai_should_be_added( ai ) )
			continue;

		living_ai[ living_ai.size ] = ai;
	}
	return living_ai;
}

ai_should_be_added( ai )
{
	if ( IsAlive( ai ) )
		return true;

	if ( !isdefined( ai ) )
		return false;

	if ( !isdefined( ai.classname ) )
		return false;

	return ai.classname == "script_model";
}

/*
=============
///ScriptDocBegin
"Name: get_vehicle_ai_spawners( <get_vehicle_ai_spawners> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_vehicle_ai_spawners()
{
	spawners = [];
	if ( IsDefined( self.target ) )
	{
		targets = GetEntArray( self.target, "targetname" );
		foreach ( target in targets )
		{
			if ( !IsSubStr( target.code_classname, "actor" ) )
				continue;
			if ( !( target.spawnflags & 1 ) )
				continue;
			if ( IsDefined( target.dont_auto_ride ) )
				continue;
			spawners[ spawners.size ] = target;
		}
	}

	if ( !isdefined( self.script_vehicleride ) )
		return spawners;

	if ( IsDefined( level.vehicle_RideSpawners[ self.script_vehicleride ] ) )
		spawners = array_combine( spawners, level.vehicle_RideSpawners[ self.script_vehicleride ] );

	return spawners;
}

/*
=============
///ScriptDocBegin
"Name: get_vehicle_ai_riders()"
"Summary: returns ai's asigned to a vehicle through the radiant menu.  Note that this doesn not return actual riders, for that just read vehicle.riders"
"Module: Entity"
"CallOn: An entity"
"Example: riders = self get_vehicle_ai_riders()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_vehicle_ai_riders()
{
	if ( !isdefined( self.script_vehicleride ) )
		return [];
	if ( !isdefined( level.vehicle_RideAI[ self.script_vehicleride ] ) )
		return [];

	return level.vehicle_RideAI[ self.script_vehicleride ];
}


spawn_group()
{
	if ( ent_flag_exist( "no_riders_until_unload" ) && !ent_flag( "no_riders_until_unload" ) )
	{
		return [];
	}

	spawners = get_vehicle_ai_spawners();
	if ( !spawners.size )
		return [];

	startinvehicles = [];

	ai = spawn_array( spawners );

	ai = array_combine( ai, get_vehicle_ai_riders() );

	ai = sort_by_startingpos( ai );

	foreach ( guy in ai )
		self thread maps\_vehicle_aianim::guy_enter( guy );
// disabling the array_levelthread because it threads them in reverse. I don't really want to be the one to mess with that right now.
// 	array_levelthread( ai, maps\_vehicle_aianim::guy_enter, self );
	return ai;
}

sort_by_startingpos( guysarray )
{
	firstarray = [];
	secondarray = [];
	foreach ( guy in guysarray )
	{
		if ( IsDefined( guy.script_startingposition ) )
			firstarray[ firstarray.size ] = guy;
		else
			secondarray[ secondarray.size ] = guy;
	}
	return array_combine( firstarray, secondarray );
}

vehicle_rider_walk_setup( vehicle )
{
	if ( !isdefined( self.script_vehiclewalk ) )
		return;

	if ( IsDefined( self.script_followmode ) )
		self.FollowMode = self.script_followmode;
	else
		self.FollowMode = "cover nodes";

	// check if the AI should go to a node after walking with the vehicle
	if ( !isdefined( self.target ) )
		return;

	node = GetNode( self.target, "targetname" );
	if ( IsDefined( node ) )
		self.NodeAftervehicleWalk = node;
}

runtovehicle( guy )
{
	guyarray = [];

	//Todo: anim_reach this stuff

	climbinnode = self.climbnode;
	climbinanim = self.climbanim;
	closenode = climbinnode[ 0 ];
	currentdist = 5000;
	thenode = undefined;
	for ( i = 0; i < climbinnode.size; i++ )
	{
		climborg = self GetTagOrigin( climbinnode[ i ] );
		climbang = self GetTagAngles( climbinnode[ i ] );
		org = GetStartOrigin( climborg, climbang, climbinanim[ i ] );
		distance = Distance( guy.origin, climborg );
		if ( distance < currentdist )
		{
			currentdist = distance;
			closenode = climbinnode[ i ];
			thenode = i;
		}
	}
	climbang = undefined;
	climborg = undefined;
	thread runtovehicle_setgoal( guy );
	while ( !guy.vehicle_goal )
	{
		climborg = self GetTagOrigin( climbinnode[ thenode ] );
		climbang = self GetTagAngles( climbinnode[ thenode ] );
		org = GetStartOrigin( climborg, climbang, climbinanim[ thenode ] );
		guy set_forcegoal();
		guy SetGoalPos( org );
		guy.goalradius = 64;
		wait .25;
	}
	guy unset_forcegoal();

	if ( self Vehicle_GetSpeed() < 1 )
	{
		guy LinkTo( self );
		guy AnimScripted( "hopinend", climborg, climbang, climbinanim[ thenode ] );
		guy waittillmatch( "hopinend", "end" );
		self guy_enter_vehicle( guy );
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
		realdetournode = GetVehicleNode( node.targetname, "target" );
		if ( !isdefined( realdetournode ) )
			return;
		realdetournode.detoured = 0;
		AssertEx( !isdefined( realdetournode.script_vehicledetour ), "Detour nodes require one non-detour node before another detournode!" );
		add_proccess_trigger( realdetournode );
}

turn_unloading_drones_to_ai()
{
	unload_group = self get_unload_group();
	foreach ( index, rider in self.riders )
	{
		if( !isalive( rider ) )
			continue;
		
		// does this guy unload?
		if ( IsDefined( unload_group[ rider.vehicle_position ] ) )
			self.riders[ index ] = self guy_becomes_real_ai( rider, rider.vehicle_position );
	}
}


add_proccess_trigger( trigger )
{
	// TODO: next game. stop trying to make everything a trigger.  remove trigger process. I'd do it this game but there is too much complexity in Detour nodes.
	// .processedtrigger is a flag that I set to keep a trigger from getting added twice.
	if ( IsDefined( trigger.processed_trigger ) )
		return;
	level.vehicle_processtriggers[ level.vehicle_processtriggers.size ] = trigger;
	trigger.processed_trigger = true;
}

islastnode( node )
{
	if ( !isdefined( node.target ) )
		return true;
	if ( !isdefined( GetVehicleNode( node.target, "targetname" ) ) && !isdefined( get_vehiclenode_any_dynamic( node.target ) ) )
		return true;
	return false;
}

get_path_getfunc( pathpoint )
{
	get_func = ::get_from_vehicle_node;

	// get_func is differnt for struct types and script_origin types of paths
	if ( isHelicopter() && IsDefined( pathpoint.target ) )
	{
		if ( IsDefined( get_from_entity( pathpoint.target ) ) )
			get_func = ::get_from_entity;
		if ( IsDefined( get_from_spawnstruct( pathpoint.target ) ) )
			get_func = ::get_from_spawnstruct;
	}
	return get_func;
}

path_array_setup( pathpoint )
{
	get_func = ::get_from_vehicle_node;

	// get_func is differnt for struct types and script_origin types of paths
	if ( isHelicopter() && IsDefined( pathpoint.target ) )
	{
		if ( IsDefined( get_from_entity( pathpoint.target ) ) )
			get_func = ::get_from_entity;
		if ( IsDefined( get_from_spawnstruct( pathpoint.target ) ) )
			get_func = ::get_from_spawnstruct;
	}

	arraycount = 0;
	pathpoints = [];
	while ( IsDefined( pathpoint ) )
	{
		pathpoints[ arraycount ] = pathpoint;
		arraycount++;

		if ( IsDefined( pathpoint.target ) )
			pathpoint = [[ get_func ]]( pathpoint.target );
		else
			break;
	}
	return pathpoints;
}

node_wait( nextpoint, lastpoint )
{
	if ( self.attachedpath == nextpoint )
	{
		waittillframeend;
		return;
	}
	nextpoint waittillmatch( "trigger", self );
//	self SetWaitNode( nextpoint );
//	self waittill( "reached_wait_node" );
}

/*
=============
///ScriptDocBegin
"Name: vehicle_paths( <node> , <bhelicopterwaitforstart> )"
"Summary: Call this on a vehicle to send it on it's way down a chain of nodes,structs, or origins. "
"Module: Vehicle"
"CallOn: A vehicle"
"OptionalArg: <node>: start node of chain of nodes,structs, or origins. if unspecified script will search for targeted node."
"OptionalArg: <bhelicopterwaitforstart>: defaults to false. turning it on will make it wait for the gopath() command "
"Example: vehicle maps\_vehicle::vehicle_paths( struct );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

vehicle_paths( node, bhelicopterwaitforstart )
{
	AssertEx( IsDefined( node ) || IsDefined( self.attachedpath ), "vehicle_path() called without a path" );
	self notify( "newpath" );


	if ( !isdefined( bhelicopterwaitforstart ) )
		bhelicopterwaitforstart = false;// helicopters emulate StartPath() function waiting for a special scripted notify before going


	if ( ishelicopter() )
		self endon( "death" );

	// dynamicpaths unique.  node isn't defined by info vehicle node calls to this function
	if ( IsDefined( node ) )
		self.attachedpath = node;

	pathstart = self.attachedpath;
	self.currentNode = self.attachedpath;

	if ( !isdefined( pathstart ) )
		return;

	self endon( "newpath" );

	// this converts chains of whatever types of vehicle nodes and turns them into this array, 
	// from this point most of the script won't care what kind of path it is.
// 	pathpoints = path_array_setup( pathpoint );

	pathpoint = pathstart;

	// dynamic paths / struct path unique
	if ( bhelicopterwaitforstart )
		self waittill( "start_dynamicpath" );

	// default type is for vehicle nodes	
	wait_func = ::node_wait;
	// wait_func is different for helicopters than vehicles on the ground
	if ( isHelicopter() )
	{
		wait_func = ::heli_wait_node;
	}

	lastpoint = undefined;
	nextpoint = pathstart;
	get_func = get_path_getfunc( pathstart );

	while ( IsDefined( nextpoint ) )
	{

		if ( isHelicopter() && IsDefined( nextpoint.script_linkTo ) )
			set_lookat_from_dest( nextpoint );

		[[ wait_func ]]( nextpoint, lastpoint );

		if ( !isdefined( self ) )
			return;

		self.currentNode = nextpoint;

		if ( IsDefined( nextpoint.gateopen ) && !nextpoint.gateopen )
			self thread path_gate_wait_till_open( nextpoint );// threaded because vehicle may Vehicle_SetSpeed( 0, 15 ) and run into the next node

		// pretend like helicopter nodes are triggers. 
		if ( isHelicopter() )
		{
			nextpoint notify( "trigger", self );

			if ( IsDefined( nextpoint.script_helimove ) )
			{
				set_heli_move( nextpoint.script_helimove );
			}
		}

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			self notify( nextpoint.script_noteworthy );
			self notify( "noteworthy", nextpoint.script_noteworthy );
		}

		waittillframeend;// this lets other scripts interupt

		if ( !isdefined( self ) )
			return;

		if ( IsDefined( nextpoint.script_prefab_exploder ) )
		{
			nextpoint.script_exploder = nextpoint.script_prefab_exploder;
			nextpoint.script_prefab_exploder = undefined;
		}

		if ( IsDefined( nextpoint.script_exploder ) )
		{
			delay = nextpoint.script_exploder_delay;
			if ( IsDefined( delay ) )
			{
				level delayThread( delay, ::exploder, nextpoint.script_exploder );
			}
			else
			{
				level exploder( nextpoint.script_exploder );
			}
		}

		if ( IsDefined( nextpoint.script_flag_set ) )
		{
			if ( IsDefined( self.vehicle_flags ) )
				self.vehicle_flags[ nextpoint.script_flag_set ] = true;
			self notify( "vehicle_flag_arrived", nextpoint.script_flag_set );
			flag_set( nextpoint.script_flag_set );
		}

		if ( IsDefined( nextpoint.script_ent_flag_set ) )
		{
			self ent_flag_set( nextpoint.script_ent_flag_set );
		}

		if ( IsDefined( nextpoint.script_ent_flag_clear ) )
		{
			self ent_flag_clear( nextpoint.script_ent_flag_clear );
		}

		if ( IsDefined( nextpoint.script_flag_clear ) )
		{
			if ( IsDefined( self.vehicle_flags ) )
				self.vehicle_flags[ nextpoint.script_flag_clear ] = false;
			flag_clear( nextpoint.script_flag_clear );
		}

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			if ( nextpoint.script_noteworthy == "kill" )
				self force_kill();
			if ( nextpoint.script_noteworthy == "godon" )
				self godon();
			if ( nextpoint.script_noteworthy == "godoff" )
				self godoff();
			if ( nextpoint.script_noteworthy == "deleteme" )
			{
				level thread deleteent( self );
				return;// this could be disasterous
			}
		}

		if ( IsDefined( nextpoint.script_crashtypeoverride ) )
			self.script_crashtypeoverride = nextpoint.script_crashtypeoverride;
		if ( IsDefined( nextpoint.script_badplace ) )
			self.script_badplace = nextpoint.script_badplace;
		if ( IsDefined( nextpoint.script_turretmg ) )
			self.script_turretmg = nextpoint.script_turretmg;
		if ( IsDefined( nextpoint.script_team ) )
			self.script_team = nextpoint.script_team;
		if ( IsDefined( nextpoint.script_turningdir ) )
			self notify( "turning", nextpoint.script_turningdir );

		if ( IsDefined( nextpoint.script_deathroll ) )
			if ( nextpoint.script_deathroll == 0 )
				self thread deathrolloff();
			else
				self thread deathrollon();

		if ( IsDefined( nextpoint.script_vehicleaianim ) )
		{
			if ( IsDefined( nextpoint.script_parameters ) && nextpoint.script_parameters == "queue" )
				self.queueanim = true;
//			if ( IsDefined( nextpoint.script_startingposition ) )
//				self.groupedanim_pos = nextpoint.script_startingposition;
//			self vehicle_ai_event( nextpoint.script_vehicleaianim );
		}

		if ( IsDefined( nextpoint.script_wheeldirection ) )
			self wheeldirectionchange( nextpoint.script_wheeldirection );


		if ( vehicle_should_unload( wait_func, nextpoint ) )
			self thread unload_node( nextpoint );

		// physics vehicles have transmission "forward" or "reverse"

		if ( self Vehicle_IsPhysVeh() )
		{
			if ( IsDefined( nextpoint.script_transmission ) )
			{
				self.veh_transmission = nextpoint.script_transmission;
				if ( self.veh_transmission == "forward" )
					self vehicle_wheels_forward();
				else
					self vehicle_wheels_backward();
			}

			if ( IsDefined( nextpoint.script_pathtype ) )
				self.veh_pathtype = nextpoint.script_pathtype;
		}

		if ( IsDefined( nextpoint.script_delay ) )
		{
			if ( isHelicopter() )
			{
				// helicopters do the script_delay in heli_wait_node()
			}
			else
			{
				decel = 35;
				if ( IsDefined( nextpoint.script_decel ) )
					decel = nextpoint.script_decel;
				self Vehicle_SetSpeed( 0, decel );
				if ( IsDefined( nextpoint.target ) )
					self thread overshoot_next_node( [[ get_func ]]( nextpoint.target ) );
				nextpoint script_delay();
				self notify( "delay_passed" );
				self ResumeSpeed( 60 );
			}
		}

		if ( IsDefined( nextpoint.script_flag_wait ) )
		{
			if ( !isdefined( self.vehicle_flags ) )
			{
				self.vehicle_flags = [];
			}

			self.vehicle_flags[ nextpoint.script_flag_wait ] = true;
			self notify( "vehicle_flag_arrived", nextpoint.script_flag_wait );

			// helicopters stop on their own because they know to stop at destination for script_flag_wait
			// may have to provide a smoother way to stop and go tho, this is rather arbitrary, for tanks
			// in this case

			if ( !flag( nextpoint.script_flag_wait ) || IsDefined( nextpoint.script_delay_post ) )
			{
				if ( !isHelicopter() )
				{
					decel = 35;
					if ( IsDefined( nextpoint.script_decel ) )
						decel = nextpoint.script_decel;
					self Vehicle_SetSpeed( 0, decel );
					self thread overshoot_next_node( [[ get_func ]]( nextpoint.target ) );
				}
			}

			// wait at the end point if it has flag wait
			flag_wait( nextpoint.script_flag_wait );

			// added script_delay_post to vehicle paths
			if ( IsDefined( nextpoint.script_delay_post ) )
				wait nextpoint.script_delay_post;

			if ( !isHelicopter() )
			{
				accel = 10;

				if ( IsDefined( nextpoint.script_accel ) )
						accel = nextpoint.script_accel;

				self ResumeSpeed( accel );
			}

			self notify( "delay_passed" );
		}

		if ( IsDefined( self.set_lookat_point ) )
		{
			self.set_lookat_point = undefined;
			self ClearLookAtEnt();
		}

		if ( IsDefined( nextpoint.script_vehicle_lights_off ) )
			self thread lights_off( nextpoint.script_vehicle_lights_off );
		if ( IsDefined( nextpoint.script_vehicle_lights_on ) )
			self thread lights_on( nextpoint.script_vehicle_lights_on );
		if ( IsDefined( nextpoint.script_forcecolor ) )
			self thread vehicle_script_forcecolor_riders( nextpoint.script_forcecolor );

		lastpoint = nextpoint;
		if ( !isdefined( nextpoint.target ) )
			break;
		nextpoint = [[ get_func ]]( nextpoint.target );
		

		if( !isdefined( nextpoint ) )
		{
			nextpoint = lastpoint;
			assertmsg( "can't find nextpoint for node at origin (node targets nothing or different type?): " + lastpoint.origin );
			break; 
		}
		
	}

	if ( IsDefined( self.script_turretmg ) )
	{
		if ( self.script_turretmg == 1 )
		{
			self mgOn();
		}
		else
		{
			self mgOff();
		}
	}

	if ( IsDefined( nextpoint.script_land ) )
		self thread vehicle_landvehicle();

	self notify( "reached_dynamic_path_end" );

	if ( IsDefined( self.script_vehicle_selfremove ) )
		self Delete();
}

vehicle_should_unload( wait_func, nextpoint )
{
//	if ( IsDefined( nextpoint.script_unload ) || ( wait_func == ::node_wait && islastnode( nextpoint ) && !isdefined( self.dontunloadonend ) && !is_script_vehicle_selfremove() ) )

	if ( IsDefined( nextpoint.script_unload ) )
		return true;
		
	if ( wait_func != ::node_wait )
		return false;
		
	if ( !islastnode( nextpoint ) )
		return false;
	
	if ( isdefined( self.dontunloadonend ) )
		return false;
		
	if ( self.vehicletype == "empty" )
		return false;
		
	return !is_script_vehicle_selfremove();
}


overshoot_next_node( vnode )
{
// asserts if the next node in a chain is reached while trying to come to a complete stop.
// This can happen if the deceleration is too low and/or the next node is too close the the delay node.
// If this happens the vehicle script will have missed the notify on the upcomming node and be stuck waiting for it.
/#
	if ( !isdefined( vnode ) )
		return;

	self endon( "delay_passed" );
	vnode waittillmatch( "trigger", self );
	PrintLn( "^1**************************************************************************************" );
	PrintLn( "^1****** WARNING!!! ********************************************************************" );
	PrintLn( "^1**************************************************************************************" );
	PrintLn( "^1A vehicle most likely overshoot a node at " + vnode.origin + " while trying to come to a stop." );
	PrintLn( "^1This will stop any future nodes for that vehicle to be handled by the vehicle script." );
	PrintLn( "^1**************************************************************************************" );
#/
}

is_script_vehicle_selfremove()
{
	if ( !isdefined( self.script_vehicle_selfremove ) )
		return false;
	return self.script_vehicle_selfremove;

}

/*
=============
///ScriptDocBegin
"Name: set_heli_move( <heliMove> )"
"Summary: Makes a heli turn with specific presets"
"Module: Vehicle"
"CallOn: A helicopter"
"MandatoryArg: <heliMove>: The type of turning"
"Example: heli set_heli_move( "fast" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_heli_move( heliMove )
{
	switch( heliMove )
	{
		case "instant":
			self SetYawSpeed( 290, 245, 222.5, 0 );
			break;
		case "faster":
			self SetMaxPitchRoll( 25, 50 );
			self SetYawSpeed( 180, 90, 22.5, 0 );
			break;
		case "fast":
			self SetYawSpeed( 90, 45, 22.5, 0 );
			break;
		case "slow":
			self SetYawSpeed( 15, 5, 15, 0 );
			break;
		default:
			self SetYawSpeed( 90, 45, 22.5, 0 );
			break;
	}
}

must_stop_at_next_point( nextpoint )
{
	// gotta be able to slow down for unload nodes
	if ( IsDefined( nextpoint.script_unload ) )
		return true;

	if ( IsDefined( nextpoint.script_delay ) )
		return true;
	// gotta stop if it depends on a flag
	return IsDefined( nextpoint.script_flag_wait ) && !flag( nextpoint.script_flag_wait );
}

heli_wait_node( nextpoint, lastpoint )
{
	self endon( "newpath" );
	// this handles a single node on helicopter path.  they are script_structs in radiant, or script_origins
	if ( IsDefined( nextpoint.script_unload ) && IsDefined( self.fastropeoffset ) )
	{
		nextpoint.radius = 2;
		neworg = groundpos( nextpoint.origin ) + ( 0, 0, self.fastropeoffset );

		if ( neworg[ 2 ] > nextpoint.origin[ 2 ] - 2000 )
		{
			// dont descend if it's going to be a huge drop, the designer may intend for it to drop guys behind a wall
			// where there is no geo for it to align with
			nextpoint.origin = groundpos( nextpoint.origin ) + ( 0, 0, self.fastropeoffset );
		}
		self SetHoverParams( 0, 0, 0 );
	}

	if ( IsDefined( lastpoint ) )
	{
		if ( IsDefined( lastpoint.script_airresistance ) )
		{
			self SetAirResistance( lastpoint.script_airresistance );
		}

		if ( IsDefined( lastpoint.speed ) )
		{
			speed = lastpoint.speed;

			accel = 25;
			decel = undefined;
			if ( IsDefined( lastpoint.script_decel ) )
			{
				decel = lastpoint.script_decel;
			}
			else
			{
				if ( must_stop_at_next_point( nextpoint ) )
				{
// 					decel = speed;
				}
			}

			if ( IsDefined( lastpoint.script_accel ) )
			{
				accel = lastpoint.script_accel;
			}
			else
			{
				max_accel = speed / 4;
				if ( accel > max_accel )
				{
					accel = max_accel;
				}

				if ( accel < 15 )
					accel = 15;
			}

			if ( IsDefined( decel ) )
			{
				self Vehicle_SetSpeed( speed, accel, decel );
			}
			else
			{
				self Vehicle_SetSpeed( speed, accel );
			}
		}
		else
		{
			if ( must_stop_at_next_point( nextpoint ) )
			{
// 				self Vehicle_SetSpeed( 60, 15, 60 );
			}
		}
	}


	self set_heli_goal( nextpoint );

	if ( IsDefined( nextpoint.radius ) )
	{
		self SetNearGoalNotifyDist( nextpoint.radius );
		AssertEx( nextpoint.radius > 0, "radius: " + nextpoint.radius );
		self waittill_any( "near_goal", "goal" );
	}
	else
	{
		self waittill( "goal" );
	}

	/#
	if ( IsDefined( nextpoint.script_flag_set ) )
		self notify( "reached_current_node", nextpoint, nextpoint.script_flag_set );
	else
		self notify( "reached_current_node", nextpoint );
	#/

	if ( IsDefined( nextpoint.script_firelink ) )
	{
		thread heli_firelink( nextpoint );
//		self SetVehWeapon( "hind_turret" );
	}

	if ( IsDefined( nextpoint.script_stopnode ) )
	{
		if ( nextpoint.script_stopnode )
			self notify( "reached_stop_node" );
		nextpoint script_delay();
	}

	nextpoint script_delay();
}

heli_firelink( nextpoint )
{
	target = GetEnt( nextpoint.script_linkto, "script_linkname" );
	if ( !isdefined( target ) )
	{
		target = getstruct( nextpoint.script_linkto, "script_linkname" );

		AssertEx( IsDefined( target ), "No target for script_firelink" );
	}
	fire_burst = nextpoint.script_fireLink;

	switch( fire_burst )
	{
		case "zippy_burst":
			wait( 1 );
			maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
			wait( 0.1 );
			maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
			wait( 0.2 );
			maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
			wait( 0.3 );
			maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
			wait( 0.3 );
			maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
			break;

		default:
			// if its unknown, do the default for this class of vehicle
			if ( self.classname == "script_vehicle_littlebird_armed" )
			{
				maps\_attack_heli::heli_fire_missiles( target, 2, 0.25 );
			}
			else
			{
				maps\_helicopter_globals::fire_missile( "hind_zippy", 5, target, 0.3 );
			}
			break;
	}
}

helipath( msg, maxspeed, accel )
{
	// depreciated
	// gets a path from the targetname that is passed
	// sets the lookat for the vehicle to ents that are script_linkname'd to the path
	self SetAirResistance( 30 );
	self Vehicle_SetSpeed( maxspeed, accel, level.heli_default_decel );
	vehicle_paths( getstruct( msg, "targetname" ) );
}

set_heli_goal( node )
{
	self endon( "death" );

	stop = false;
	if ( !isdefined( stop ) )
		stop = true;
	if ( IsDefined( node.script_stopnode ) )// z: stop at nodes if there is a script_stopnode = 1 value
		stop = node.script_stopnode;
	if ( IsDefined( node.script_unload ) )
		stop = true;

	script_anglevehicle = IsDefined( node.script_anglevehicle ) && node.script_anglevehicle;
	script_goalyaw =  IsDefined( node.script_goalyaw ) && node.script_goalyaw;

	if ( IsDefined( node.script_anglevehicle ) || IsDefined( node.script_goalyaw ) )
		self forcetarget( node, script_goalyaw, script_anglevehicle );
	else
		self unforcetarget();

	if ( IsDefined( node.script_flag_wait ) )
	{
		if ( !flag( node.script_flag_wait ) )
		{
			// if the flag gets set during flight, we should update the setvehgoalpos to not stop
			stop = true;
		}
	}
	if ( !isdefined( node.target ) )
	{
		// stop if this is the end of the path
		stop = true;
	}
	else
	if ( IsDefined( node.script_delay ) )
	{
		stop = true;
	}

/#
	index = -1;
	foreach ( index, struct in level.struct )
	{
		if ( node == struct )
			break;
	}
#/

	self setvehgoalpos_wrap( node.origin, stop );// Z: second param = false dont stop at each node.
}

forcetarget( node, script_goalyaw, script_anglevehicle )
{
	AssertEx( IsDefined( node.angles ), "Node with targetname ", node.target, " has no .angles" );
	// [ 14:45 ] [ jiesang - ?? ]: lookat entity > goalyaw > targetyaw
	if ( script_goalyaw )
	{
		self ClearTargetYaw();
		self SetGoalYaw( node.angles[ 1 ] );
	}
	else
	{
		self ClearGoalYaw();// clear this thing
		self SetTargetYaw( node.angles[ 1 ] );
	}
}

unforcetarget()
{
	self ClearGoalYaw();// clear this thing
	self ClearTargetYaw();// clear the stuff
}

deathrollon()
{
	if ( self.health > 0 )
		self.rollingdeath = 1;
}

deathrolloff()
{
	self.rollingdeath = undefined;
	self notify( "deathrolloff" );
}

/*
=============
///ScriptDocBegin
"Name: getonpath( <getonpath> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
getonpath( skip_attach )
{
	path_start = undefined;
	type = self.vehicletype;
	if ( isdefined( self.dontgetonpath ) )
		return;
	
	if ( IsDefined( self.target ) )
	{
		path_start = GetVehicleNode( self.target, "targetname" );

		/#
		if ( ishelicopter() && IsDefined( path_start ) )
		{
			PrintLn( "helicopter node targetname: " + path_start.targetname );
			PrintLn( "vehicletype: " + self.vehicletype );
			AssertMsg( "helicopter on vehicle path( see console for info )" );
		}
		#/

		if ( !isdefined( path_start ) )
		{
			// get path start from the array of targets that may include guys that ride in the vehicle
			path_start_array = GetEntArray( self.target, "targetname" );
			foreach ( path in path_start_array )
			{
				if ( path.code_classname == "script_origin" )
				{
					path_start = path;
					break;
				}
			}
		}

		if ( !isdefined( path_start ) )
		{
			path_start = getstruct( self.target, "targetname" );
		}
	}

	if ( !isdefined( path_start ) )
	{
		if ( ishelicopter() )
			self Vehicle_SetSpeed( 60, 20, level.heli_default_decel );

		return;
	}

	self.attachedpath = path_start;

	if ( !isHelicopter() )
	{
		self.origin = path_start.origin;
		
		if ( !isdefined( skip_attach ) )
			self AttachPath( path_start );
	}
	else
	{
		if ( IsDefined( self.speed ) )
		{
			self Vehicle_SetSpeedImmediate( self.speed, 20 );
		}
		else
		if ( IsDefined( path_start.speed ) )
		{
			accel = 20;
			decel = level.heli_default_decel;
			if ( IsDefined( path_start.script_accel ) )
				accel = path_start.script_accel;
			if ( IsDefined( path_start.script_decel ) )
				accel = path_start.script_decel;

			self Vehicle_SetSpeedImmediate( path_start.speed, accel, decel );
		}
		else
		{
			// default heli speed
			self Vehicle_SetSpeed( 60, 20, level.heli_default_decel );
		}
	}

	if ( !isdefined( self.dontDisconnectPaths ) )
		self DisconnectPaths();
	self thread vehicle_paths( undefined, isHelicopter() );
}

/* 
============= 
///ScriptDocBegin
"Name: create_vehicle_from_spawngroup_and_gopath( <spawnGroup> )"
"Summary: spawns and returns and array of the vehicles in the specified spawngroup starting them on their paths"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <spawnGroup> : the script_vehiclespawngroup asigned to the vehicles in radiant"
"Example: maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( spawnGroup )"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

create_vehicle_from_spawngroup_and_gopath( spawnGroup )
{
	vehicleArray = maps\_vehicle::scripted_spawn( spawnGroup );
	foreach ( vehicle in vehicleArray )
		level thread maps\_vehicle::gopath( vehicle );
	return vehicleArray;
}

/*
=============
///ScriptDocBegin
"Name: gopath( <vehicle> )"
"Summary: Helis notify reached_dynamic_path_end on end"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
gopath( vehicle )
{
	// helis notify reached_dynamic_path_end on end
	if ( !isdefined( vehicle ) )
	{
		vehicle = self;
		AssertEx( self.code_classname == "script_vehicle", "Tried to do goPath on a non-vehicle" );
	}

	if ( IsDefined( vehicle.script_VehicleStartMove ) )
		level.vehicle_StartMoveGroup[ vehicle.script_VehicleStartMove ] = array_remove( level.vehicle_StartMoveGroup[ vehicle.script_VehicleStartMove ], vehicle );

	vehicle endon( "death" );

	if ( IsDefined( vehicle.hasstarted ) )
	{
		PrintLn( "vehicle already moving when triggered with a startmove" );
		return;
	}
	else
		vehicle.hasstarted = true;

	// I wonder if anybody uses this still. I rember using it for cars sitting on the side of the road in CoD1. heh.
	vehicle script_delay();

	vehicle notify( "start_vehiclepath" );

	if ( vehicle isHelicopter() )
		vehicle notify( "start_dynamicpath" );
	else
		vehicle StartPath();

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
	self notify( "wait for gate" );
	self vehicle_setspeed_wrapper( 0, 15, "path gate closed" );
	pathspot waittill( "gate opened" );
	self.waitingforgate = false;
	if ( self.health > 0 )
		script_resumespeed( "gate opened", level.vehicle_ResumeSpeed );
}

/* 
============= 
///ScriptDocBegin
"Name: scripted_spawn( <group> )"
"Summary: spawns and returns a vehiclegroup, you will need to tell it to maps\_vehicle::gopath() when you want it to go"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <group> : "
"Example: bmps = maps\_vehicle::scripted_spawn( 32 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

scripted_spawn( group )
{
	spawners = _getvehiclespawnerarray_by_spawngroup( group );

	vehicles = [];
	foreach ( spawner in spawners )
		vehicles[ vehicles.size ] = vehicle_spawn( spawner );
	return vehicles;
}

/*
=============
///ScriptDocBegin
"Name: vehicle_spawn( <spawner> )"
"Summary: spawnes a vehicle from the given vehicle spawner."
"Module: Vehicle"
LevelOn: A Level"
"MandatoryArg: <spawner>: "
"Example: level.reinforcement_heli = vehicle_spawn( spawner );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_spawn( vspawner )
{
	Assert( isSpawner( vspawner ) );
	AssertEx( !isdefined( vspawner.vehicle_spawned_thisframe ), "spawning two vehicles on one spawner on the same frame is not allowed" );
	vehicle = vspawner Vehicle_DoSpawn();
	Assert( IsDefined( vehicle ) );
	vspawner.vehicle_spawned_thisframe = vehicle;
	vspawner.last_spawned_vehicle = vehicle;
	vspawner thread remove_vehicle_spawned_thisframe();
	thread vehicle_init( vehicle );
	// want to get this put in code and rearrange all this stuff so that people can use Vehicle_DoSpawn() directly and not have to initialize the vehicle scripts.
	vspawner notify( "spawned", vehicle );
	return vehicle;
}

// this is getting a little strange.. kind of a special case for a mo script that I really don't want to spend time unravelling scoutsniper
get_vehicle_spawned_from_spawner_with_targetname( targetname )
{
	spawner = GetEnt( targetname, "targetname" );
	Assert( IsDefined( spawner ) );
	if ( IsDefined( spawner.last_spawned_vehicle ) )
		return spawner.last_spawned_vehicle;
	return undefined;
}

remove_vehicle_spawned_thisframe()
{
	wait .05;
	self.vehicle_spawned_thisframe = undefined;
}

waittill_vehiclespawn( targetname )
{
	spawner = GetEnt( targetname, "targetname" );
	Assert( isSpawner( spawner ) );

	// for those vehicles spawned on the first frame. trying to avoid waittillframeend juggling though I don't think this is much better =/.
	if ( IsDefined( spawner.vehicle_spawned_thisframe ) )
		return spawner.vehicle_spawned_thisframe;

	spawner waittill( "spawned", vehicle );
	return vehicle;
}

waittill_vehiclespawn_noteworthy( noteworthy )
{
	potential_spawners = GetEntArray( noteworthy, "script_noteworthy" );
	spawner = undefined;
	foreach ( test in potential_spawners )
	{
		if ( isSpawner( test ) )
		{
			spawner = test;
			break;
		}
	}

	Assert( IsDefined( spawner ) );

	// for those vehicles spawned on the first frame. trying to avoid waittillframeend juggling though I don't think this is much better =/.
	if ( IsDefined( spawner.vehicle_spawned_thisframe ) )
		return spawner.vehicle_spawned_thisframe;

	spawner = GetEnt( noteworthy, "script_noteworthy" );
	spawner waittill( "spawned", vehicle );
	return vehicle;
}

waittill_vehiclespawn_noteworthy_array( noteworthy )
{
	struct = SpawnStruct();
	struct.array_count = 0;
	struct.vehicles = [];

	array = [];
	potentials_array = GetEntArray( noteworthy, "script_noteworthy" );
	foreach ( test in potentials_array )
	{
		if ( isSpawner( test ) )
			array[ array.size ] = test;
	}

	Assert( array.size );
	array_levelthread( array, ::waittill_vehiclespawn_noteworthy_array_countdown, struct );
	struct waittill( "all_vehicles_spawned" );
	return struct.vehicles;
}

waittill_vehiclespawn_noteworthy_array_countdown( spawner, struct )
{
	struct.array_count++;

	// for those vehicles spawned on the first frame. trying to avoid waittillframeend juggling though I don't think this is much better =/.
	if ( !isdefined( spawner.vehicle_spawned_thisframe ) )
		spawner waittill( "spawned", vehicle );
	else
		vehicle = spawner.vehicle_spawned_thisframe;

	Assert( IsDefined( vehicle ) );
	struct.array_count--;
	struct.vehicles[ struct.vehicles.size ] = vehicle;
	if ( !struct.array_count )
		struct notify( "all_vehicles_spawned" );
}


vehicle_init( vehicle )
{
	Assert( vehicle.classname != "script_model" );

	if ( vehicle.vehicletype == "empty" )
	{
		vehicle thread getonpath();
		return;
	}

	if ( vehicle.vehicletype == "bog_mortar" )
		return;
	if ( ( IsDefined( vehicle.script_noteworthy ) ) && ( vehicle.script_noteworthy == "playervehicle" ) )
		return;// TODO:  I really don't think we should branch off the players vehicle so early. - nate

	vehicle set_ai_number();// unique id for each vehicle or ai

	// TODO: These shouldn't be asigned to everyvehicle
	vehicle.zerospeed = true;

	if ( !isdefined( vehicle.modeldummyon ) )
		vehicle.modeldummyon = false;

	type = vehicle.vehicletype;

	// give the vehicle health
	vehicle vehicle_life();

	// set the script_team value used everywhere to determine which team the vehicle belongs to
	vehicle vehicle_setteam();

	// init pointer is specified in the precache script( IE maps\_tiger::main() )
	// only special case gag works should exist in this thread, 

	if ( !isdefined( 	level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ) )
	{
		PrintLn( "vehicle.vehicletype is: " + vehicle.vehicletype );
		PrintLn( "vehicle.model is: " + vehicle.model );
	}


	vehicle thread [[ level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ]]();
	vehicle thread maingun_FX();
	vehicle thread playTankExhaust();



	if ( !isdefined( vehicle.script_avoidplayer ) )
		vehicle.script_avoidplayer = false;

	vehicle ent_flag_init( "unloaded" );
	vehicle ent_flag_init( "loaded" );
	vehicle.riders = [];
	vehicle.unloadque = [];// for ai. wait till a vehicle is unloaded all the way
	vehicle.unload_group = "default";

	vehicle.fastroperig = [];
	if ( IsDefined( level.vehicle_attachedmodels ) && IsDefined( level.vehicle_attachedmodels[ type ] ) )
	{
		rigs = level.vehicle_attachedmodels[ type ];
		strings = GetArrayKeys( rigs );
		foreach ( string in strings )
		{
			vehicle.fastroperig[ string ] = undefined;
			vehicle.fastroperiganimating[ string ] = false;
		}
	}

	// make ai run way from vehicle
	vehicle thread vehicle_badplace();

	// toggle vehicle lights on / off
	if ( IsDefined( vehicle.script_vehicle_lights_on ) )
		vehicle thread lights_on( vehicle.script_vehicle_lights_on );

	if ( IsDefined( vehicle.script_godmode ) )
	{
		vehicle godon();
	}


	// regenerate friendly fire damage
	if ( !vehicle isCheap() )
		vehicle thread friendlyfire_shield();

	// handles guys riding and doing stuff on vehicles
	vehicle thread maps\_vehicle_aianim::handle_attached_guys();

	if ( isdefined( vehicle.script_friendname ) )
		vehicle setVehicleLookAtText( vehicle.script_friendname, &"" );
	
	// special stuff for unloading
	if ( !vehicle isCheap() )
		vehicle thread vehicle_handleunloadevent();
	
	if ( isdefined( vehicle.script_dontunloadonend ) )
		vehicle.dontunloadonend = true;
	
	// Make the main turret think
	vehicle thread turret_attack_think();

	// Shellshock player on main turret fire.
	if ( !vehicle isCheap() )
		vehicle thread vehicle_shoot_shock();// moved to indiviual tank scripts.

	// make the vehicle rumble
	vehicle thread vehicle_rumble();

	// make vehicle shake physics objects.
	if ( IsDefined( vehicle.script_physicsjolt ) && vehicle.script_physicsjolt )
		vehicle thread physicsjolt_proximity();

	// handle tread effects
	vehicle thread vehicle_treads();

	// handle the compassicon for friendly vehicles
	vehicle thread vehicle_compasshandle();

	vehicle thread idle_animations();

	// make the wheels rotate
	vehicle thread animate_drive_idle();

	if ( IsDefined( vehicle.script_deathflag ) )
	{
		vehicle thread maps\_spawner::vehicle_deathflag();
	}


	// handle machine guns
	if ( !vehicle isCheap() )
		vehicle thread mginit();

	if ( IsDefined( level.vehicleSpawnCallbackThread ) )
		level thread [[ level.vehicleSpawnCallbackThread ]]( vehicle );

	// this got kind of ugly and hackery but it's how I deal with player driveable vehicles in decoytown, elalamein, 88ridge and libya
//	if ( IsDefined( vehicle.spawnflags ) && vehicle.spawnflags & 1 )
//	{
//		startinvehicle = ( IsDefined( vehicle.script_noteworthy ) && vehicle.script_noteworthy == "startinside" );// can't see making a whole new keys.txt entry for something that's only going to be used once in any given level.
//		vehicle maps\_vehicledrive::setup_vehicle_other();
//		vehicle thread maps\_vehicledrive::vehicle_wait( startinvehicle );
//		vehicle_Levelstuff( vehicle );
//		vehicle thread Kill();
//		return;
//	}

	// associate vehicle with living level variables.
	vehicle_Levelstuff( vehicle );

	if ( IsDefined( vehicle.script_team ) )
		vehicle SetVehicleTeam( vehicle.script_team );

	// every vehicle that stops will disconnect its paths
	if ( !vehicle isCheap() )
		vehicle thread disconnect_paths_whenstopped();

	// get on path and start the path handler thread
	vehicle thread getonpath();

	// helicopters do dust kickup fx
	if ( vehicle hasHelicopterDustKickup() )
		vehicle thread aircraft_dust_kickup();

	// physics vehicles have pathtypes constrained or follow
	if ( vehicle Vehicle_IsPhysVeh() )
	{
		if ( !isdefined( vehicle.script_pathtype ) )
		{
			//vehicle.veh_pathtype = "follow";
		}
		else
		{
			vehicle.veh_pathtype = vehicle.script_pathtype;
		}
	}

	// spawn the vehicle and it's associated ai
	vehicle spawn_group();
	vehicle thread vehicle_kill();

	vehicle apply_truckjunk();
}

kill_damage( type )
{
	if ( !isdefined( level.vehicle_death_radiusdamage ) || !isdefined( level.vehicle_death_radiusdamage[ type ] ) )
		return;

	if ( IsDefined( self.deathdamage_max ) )
		maxdamage = self.deathdamage_max;
	else
		maxdamage = level.vehicle_death_radiusdamage[ type ].maxdamage;
	if ( IsDefined( self.deathdamage_min ) )
		mindamage = self.deathdamage_min;
	else
		mindamage = level.vehicle_death_radiusdamage[ type ].mindamage;

	if ( IsDefined( level.vehicle_death_radiusdamage[ type ].delay ) )
		wait level.vehicle_death_radiusdamage[ type ].delay;

	if ( !isdefined( self ) )
		return;// deleted in this time.

	if ( level.vehicle_death_radiusdamage[ type ].bKillplayer )
		level.player EnableHealthShield( false );

	self RadiusDamage( self.origin + level.vehicle_death_radiusdamage[ type ].offset, level.vehicle_death_radiusdamage[ type ].range, maxdamage, mindamage, self );

	if ( level.vehicle_death_radiusdamage[ type ].bKillplayer )
		level.player EnableHealthShield( true );
}

vehicle_kill()
{
	self endon( "nodeath_thread" );
	type = self.vehicletype;
	model = self.model;
	targetname = self.targetname;
	attacker = undefined;
	cause = undefined;
	registered_kill = false;

	while ( 1 )
	{
		// waittill death twice. in some cases the vehicle dies and does a bunch of stuff. then it gets deleted. which it then needs to do more stuff
		if ( IsDefined( self ) )
			self waittill( "death", attacker, cause );

		if ( !registered_kill )
		{
			registered_kill = true;
			if ( IsDefined( attacker ) && IsDefined( cause ) )
			{
				attacker maps\_player_stats::register_kill( self, cause );
				if ( IsDefined( self.damage_type ) )
				{
					self.damage_type = undefined;
				}
			}
		}

		self notify( "clear_c4" );

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// some tank and turret cleanup
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

		if ( IsDefined( self.rumbletrigger ) )
			self.rumbletrigger Delete();

		if ( IsDefined( self.mgturret ) )
		{
			array_levelthread( self.mgturret, ::turret_deleteme );
			self.mgturret = undefined;
		}

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		if ( IsDefined( self.script_team ) )
			level.vehicles[ self.script_team ] = array_remove( level.vehicles[ self.script_team ], self );

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// previously unstuff
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

		if ( IsDefined( self.script_linkName ) )
			level.vehicle_link[ self.script_linkName ] = array_remove( level.vehicle_link[ self.script_linkName ], self );

		// dis - associate with targets

		if ( IsDefined( self.script_VehicleStartMove ) )
			level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ] = array_remove( level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ], self );

		if ( IsDefined( self.script_vehicleGroupDelete ) )
			level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ] = array_remove( level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ], self );

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

		// if vehicle is gone then delete the ai here.
		if ( !isdefined( self ) || is_corpse() )
		{
			if ( IsDefined( self.riders ) )
				foreach ( rider in self.riders )
					if ( IsDefined( rider ) )
						rider Delete();

			if ( is_corpse() )
			{
				self.riders = [];
				continue;
			}

			self notify( "delete_destructible" );// kills some destructible fxs
			return;
		}


		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 


		if ( IsDefined( level.vehicle_rumble[ type ] ) )
			self StopRumble( level.vehicle_rumble[ type ].rumble );

		if ( IsDefined( level.vehicle_death_thread[ type ] ) )
			thread [[ level.vehicle_death_thread[ type ] ]]();


		// kill riders riders blow up
		self array_levelthread( self.riders, maps\_vehicle_aianim::guy_vehicle_death, attacker, type );

		// does radius damage

		thread kill_damage( type );
		thread kill_badplace( type );

		kill_lights( model );// delay hacked.. IsDefined() checks for deleted each time.
		
		delete_corpses_around_vehicle();

		if ( IsDefined( level.vehicle_deathmodel[ model ] ) )
			self thread set_death_model( level.vehicle_deathmodel[ model ], level.vehicle_deathmodel_delay[ model ] );

		rocketdeath = vehicle_should_do_rocket_death( model, attacker, cause );
		vehOrigin = self.origin;
		
		thread kill_fx( model, rocketdeath );

		// all the vehicles get the same jolt..
		if ( self.code_classname == "script_vehicle" )
			self thread kill_jolt( type );
		
		if ( IsDefined( self.delete_on_death ) )
		{
			wait 0.05;
			if ( !isdefined( self.dontDisconnectPaths ) && !self Vehicle_IsPhysVeh() )
				self DisconnectPaths();

			self FreeVehicle();
			wait 0.05;
			self notify( "death_finished" );
			self Delete();
			continue;
		}

		if ( IsDefined( self.free_on_death ) )
		{
			self notify( "newpath" );
			if ( !isdefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
							
			Vehicle_kill_badplace_forever();
			self FreeVehicle();
			return;
		}

		vehicle_do_crash( model, attacker, cause );
		
		if ( !rocketdeath )
			vehOrigin = self.origin;
		if ( IsDefined( level.vehicle_death_earthquake[ type ] ) )
			earthquake
			(
				level.vehicle_death_earthquake[ type ].scale,
				level.vehicle_death_earthquake[ type ].duration,
				vehOrigin,
				level.vehicle_death_earthquake[ type ].radius
			 );
		
		wait .5;

		if ( is_corpse() )
			continue;

		if ( IsDefined( self ) )
		{
			while ( IsDefined( self.dontfreeme ) && IsDefined( self ) )
				wait .05;
			if ( !isdefined( self ) )
				continue;

			if ( self Vehicle_IsPhysVeh() )
			{
				// if it's a physics vehicle then don't free it, since that stops it from doing physics when dead.
				// wait for 0 speed then disconnect paths and kill badplaces.
				while ( self.veh_speed != 0 )
					wait 1;
				self DisconnectPaths();
				self notify( "kill_badplace_forever" );
				self kill(); // make sure it's dead.
				// terminates the vehicle_paths() thread to stop it from starting the vehicle moving again.
				self notify( "newpath" );
				self Vehicle_TurnEngineOff();
				return;
			}
			else
				self FreeVehicle();

			if ( self.modeldummyon )
				self Hide();
		}

		if ( vehicle_is_crashing() )
		{
			self Delete();
			continue;
		}

	}
}

vehicle_should_do_rocket_death( model, attacker, cause )
{
	//ability to disable by setting this variable to false.
	if ( IsDefined( self.enableRocketDeath ) && self.enableRocketDeath == false )
		return false;
	if ( !IsDefined( cause ) )
		return false;
	if ( !( ( cause == "MOD_PROJECTILE" ) || ( cause == "MOD_PROJECTILE_SPLASH" ) ) )
		return false;

	return vehicle_has_rocket_death( model );
}

vehicle_has_rocket_death( model )
{
	return IsDefined( level.vehicle_death_fx[ "rocket_death" + self.vehicletype + model ] ) && IsDefined( self.enableRocketDeath ) && self.enableRocketDeath == true;
}

vehicle_is_crashing()
{
	return( IsDefined( self.crashing ) ) && ( self.crashing == true );
}



vehicle_do_crash( model, attacker, cause )
{
	// crazy crashpath stuff.
	crashtype = "tank";
	if ( self Vehicle_IsPhysVeh() )
		crashtype = "physics";
	else
	if ( IsDefined( self.script_crashtypeoverride ) )
		crashtype = self.script_crashtypeoverride;
	else 
	if ( self isHelicopter() )
		crashtype = "helicopter";
	else 
	if ( IsDefined( self.currentnode ) && crash_path_check( self.currentnode ) )
		crashtype = "none";


	switch( crashtype )
	{
		case "helicopter":
			self thread helicopter_crash( attacker, cause );
			break;
	
		case "tank":
			if ( !isdefined( self.rollingdeath ) )
				self vehicle_setspeed_wrapper( 0, 25, "Dead" );
			else
			{
				self vehicle_setspeed_wrapper( 8, 25, "Dead rolling out of path intersection" );
				self waittill( "deathrolloff" );
				self vehicle_setspeed_wrapper( 0, 25, "Dead, finished path intersection" );
			}
	
			self notify( "deadstop" );
			if ( !isdefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
			if ( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
				self waittill( "animsdone" );// tankgetout will never get notified if there are no guys getting out

			break;

		case "physics":
			self VehPhys_Crash();		

			self notify( "deadstop" );
			if ( !isdefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
			if ( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
				self waittill( "animsdone" );// tankgetout will never get notified if there are no guys getting out
			break;
	}

	if ( IsDefined( level.vehicle_hasMainTurret[ model ] ) && level.vehicle_hasMainTurret[ model ] )
		self ClearTurretTarget();

	if ( self isHelicopter() )
	{
		if ( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
			self waittill( "crash_done" );
	}
	else
	{
		while ( !is_corpse() && IsDefined( self ) && self Vehicle_GetSpeed() > 0 )
			wait .1;
	}

	self notify( "stop_looping_death_fx" );
	self notify( "death_finished" );

}

is_corpse()
{
	is_corpse = false;
	if ( IsDefined( self ) && self.classname == "script_vehicle_corpse" )
		is_corpse = true;
	return is_corpse;
}

set_death_model( sModel, fDelay )
{
	Assert( IsDefined( sModel ) );
	if ( IsDefined( fDelay ) && ( fDelay > 0 ) )
		wait fDelay;
	if ( !isdefined( self ) )
		return;
	eModel = get_dummy();
	if ( IsDefined( self.clear_anims_on_death ) )
		eModel ClearAnim( %root, 0 );
	if ( IsDefined( self ) )
		eModel SetModel( sModel );
}

helicopter_crash( attacker, cause )
{
	if ( IsDefined( attacker ) && IsPlayer( attacker ) )
		self.achievement_attacker = attacker;
		
	self.crashing = true;

	if ( !isdefined( self ) )
		return;

	if ( IsDefined( attacker ) && ( IsPlayer( attacker ) ) )
	{
		thread arcadeMode_kill( self.origin, "explosive", 750 );
		attacker thread giveXp( "kill", 1000 );

		if ( GetDvar( "money_sharing" ) == "1" )
		{
			foreach ( player in level.players )
				player thread giveMoney( "kill", 750, attacker );
		}
		else
			attacker thread giveMoney( "kill", 750 );
	}
	
	self thread helicopter_crash_move( attacker, cause );
}

_hasweapon( weapon )
{
	weapons = self GetWeaponsListAll();
	for ( i = 0; i < weapons.size; i++ )
	{
		if ( IsSubStr( weapons[ i ], weapon ) )
			return true;
	}
	return false;
}

get_unused_crash_locations()
{
	unusedLocations = [];
	for ( i = 0; i < level.helicopter_crash_locations.size; i++ )
	{
		if ( IsDefined( level.helicopter_crash_locations[ i ].claimed ) )
			continue;
		unusedLocations[ unusedLocations.size ] = level.helicopter_crash_locations[ i ];
	}
	return unusedLocations;
}

detach_getoutrigs()
{
	if ( !isdefined( self.fastroperig ) )
		return;
	if ( ! self.fastroperig.size )
		return;
	keys = GetArrayKeys( self.fastroperig );
	for ( i = 0; i < keys.size; i++ )
	{
		self.fastroperig[ keys[ i ] ] Unlink();
	}
}

helicopter_crash_move( attacker, cause )
{

	if ( IsDefined( self.perferred_crash_location ) )
		crashLoc = self.perferred_crash_location;
	else
	{
		// get the nearest unused crash location
		AssertEx( level.helicopter_crash_locations.size > 0, "A helicopter tried to crash but you didn't have any script_origins with targetname helicopter_crash_location in the level" );
		unusedLocations = get_unused_crash_locations();
		AssertEx( unusedLocations.size > 0, "You dont have enough script_origins with targetname helicopter_crash_location in the level" );
		crashLoc = getClosest( self.origin, unusedLocations );
	}
	Assert( IsDefined( crashLoc ) );

	crashLoc.claimed = true;

	self detach_getoutrigs();


	// make the chopper spin around
	self thread helicopter_crash_rotate();
	self notify( "newpath" );

	if ( IsDefined( crashLoc.script_parameters ) && crashLoc.script_parameters == "direct" )
	{
		Assert( IsDefined( crashLoc.radius ) );
		crash_speed = 60;
		self Vehicle_SetSpeed( crash_speed, 15, 10 );
		self SetNearGoalNotifyDist( crashLoc.radius );
		self SetVehGoalPos( crashLoc.origin, 0 );
		self waittill_any( "goal", "near_goal" );
	}
	else
	{
		// move chopper closer to crash point
		self Vehicle_SetSpeed( 40, 10, 10 );
		self SetNearGoalNotifyDist( 300 );
		self SetVehGoalPos( ( crashLoc.origin[ 0 ], crashLoc.origin[ 1 ], self.origin[ 2 ] ), 1 );

		msg = "blank";

		while ( msg != "death" )
		{
			msg = self waittill_any( "goal", "near_goal", "death" );
			// waittill_any ends on "death"
			if ( !isdefined( msg ) && !isdefined( self ) )
			{
				crashLoc.claimed = undefined;
				self notify( "crash_done" );
				return;
			}
			else
				msg = "death";// Mackey sends a non dead helicopter through this function. it dies. but not deleted.
		}

		self SetVehGoalPos( crashLoc.origin, 0 );
		self waittill( "goal" );
	}

	crashLoc.claimed = undefined;
	self notify( "stop_crash_loop_sound" );
	self notify( "crash_done" );
}

helicopter_crash_rotate()
{
	self endon( "crash_done" );
	self ClearLookAtEnt();

	//self SetMaxPitchRoll( 150, 600 );
	self SetYawSpeed( 400, 100, 100 );
	for ( ;; )
	{
		if ( !isdefined( self ) )
			return;
		iRand = RandomIntRange( 90, 120 );
		self SetTargetYaw( self.angles[ 1 ] + iRand );
		wait 0.5;
	}
}

crash_path_check( node )
{
	// find a crashnode on the current path
	// this only works on ground info_vehicle_node vheicles. not dynamic helicopter script_origin paths. they have their own dynamic crashing.
	targ = node;
	while ( IsDefined( targ ) )
	{
		if ( ( IsDefined( targ.detoured ) ) && ( targ.detoured == 0 ) )
		{
			detourpath = path_detour_get_detourpath( GetVehicleNode( targ.target, "targetname" ) );
			if ( IsDefined( detourpath ) && IsDefined( detourpath.script_crashtype ) )
	 			return true;
		}
		if ( IsDefined( targ.target ) )
			targ = GetVehicleNode( targ.target, "targetname" );
		else
			targ = undefined;
	}
	return false;

}

death_firesound( sound )
{
	self thread play_loop_sound_on_tag( sound, undefined, false );
	self waittill_any( "fire_extinguish", "stop_crash_loop_sound" );
	if ( !isdefined( self ) )
		return;
	self notify( "stop sound" + sound );
}

kill_fx( model, rocketdeath )
{
	if ( self isDestructible() )
		return;

	level notify( "vehicle_explosion", self.origin );
	self notify( "explode" );
	type = self.vehicletype;
	typemodel = type + model;
	if ( rocketdeath )
		typemodel = "rocket_death" + typemodel;

	for ( i = 0; i < level.vehicle_death_fx[ typemodel ].size; i++ )
	{
		struct = level.vehicle_death_fx[ typemodel ][ i ];
		thread kill_fx_thread( model, struct, type );
	}
}


/* 
============= 
///ScriptDocBegin
"Name: vehicle_flag_arrived( <msg> )"
"Summary: Script waits until the vehicle hits the node that has script_flag_wait with this msg"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <msg> :  The flag"
"Example: heli vehicle_flag_arrived( "surrender_to_me" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

vehicle_flag_arrived( msg )
{
	if ( !isdefined( self.vehicle_flags ) )
	{
		self.vehicle_flags = [];
	}

	while ( !isdefined( self.vehicle_flags[ msg ] ) )
	{
		self waittill( "vehicle_flag_arrived", notifymsg );
		if ( msg == notifymsg )
			return;
	}
}


kill_fx_thread( model, struct, type )
{
	Assert( IsDefined( struct ) );
	if ( IsDefined( struct.waitDelay ) )
	{
		if ( struct.waitDelay >= 0 )
		wait struct.waitDelay;
		else
			self waittill( "death_finished" );
	}

	if ( !isdefined( self ) )
	{
		// self may have been removed during the wait
		return;
	}

	if ( IsDefined( struct.notifyString ) )
		self notify( struct.notifyString );

	eModel = get_dummy();
	if ( IsDefined( struct.selfDeleteDelay ) )
		self delayCall( struct.selfDeleteDelay, ::Delete );
	if ( IsDefined( struct.effect ) )
	{
		if ( ( struct.bEffectLooping ) && ( !isdefined( self.delete_on_death ) ) )
		{
			if ( IsDefined( struct.tag ) )
			{
				if ( ( IsDefined( struct.stayontag ) ) && ( struct.stayontag == true ) )
					thread loop_fx_on_vehicle_tag( struct.effect, struct.delay, struct.tag );
				else
					thread playLoopedFxontag( struct.effect, struct.delay, struct.tag );
			}
			else
			{
				forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin;
				PlayFX( struct.effect, eModel.origin, forward );
			}
		}
		else if ( IsDefined( struct.tag ) )
			PlayFXOnTag( struct.effect, deathfx_ent(), struct.tag );
		else
		{
			forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin;
			PlayFX( struct.effect, eModel.origin, forward );
		}
	}

	if ( ( IsDefined( struct.sound ) ) && ( !isdefined( self.delete_on_death ) ) )
	{
		if ( struct.bSoundlooping )
			thread death_firesound( struct.sound );
		else
			self play_sound_in_space( struct.sound );
	}
}

loop_fx_on_vehicle_tag( effect, loopTime, tag )
{
	Assert( IsDefined( effect ) );
	Assert( IsDefined( tag ) );
	Assert( IsDefined( loopTime ) );

	self endon( "stop_looping_death_fx" );

	while ( IsDefined( self ) )
	{
		PlayFXOnTag( effect, deathfx_ent(), tag );
		wait loopTime;
	}
}

/* 
============= 
///ScriptDocBegin
"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer> , <delay> )"
"Summary: called in individual vehicle file - define amount of radius damage to be set on each vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <health> :  health"
"MandatoryArg: <offset> : worldspace offset vector, usually goes up"
"MandatoryArg: <range> : randomly chooses between the minhealth, maxhealth"
"MandatoryArg: <maxdamage> : randomly chooses between the minhealth, maxhealth"
"MandatoryArg: <mindamage> : randomly chooses between the minhealth, maxhealth"
"MandatoryArg: <bKillplayer> : true / false: kills player"
"OptionalArg: <delay> : delay after "death" to do the damage."
"Example: build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, false );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_radiusdamage( offset, range, maxdamage, mindamage, bKillplayer, delay )
{
	if ( !isdefined( level.vehicle_death_radiusdamage ) )
		level.vehicle_death_radiusdamage = [];
	if ( !isdefined( bKillplayer ) )
		bKillplayer = false;
	if ( !isdefined( offset ) )
		offset = ( 0, 0, 0 );
	struct = SpawnStruct();
	struct.offset = offset;
	struct.range = range;
	struct.maxdamage = maxdamage;
	struct.mindamage = mindamage;
	struct.bKillplayer = bKillplayer;
	struct.delay = delay;
	level.vehicle_death_radiusdamage[ level.vttype ] = struct;
}


/* 
============= 
///ScriptDocBegin
"Name: build_rumble( <rumble> , <scale> , <duration> , <radius> , <basetime> , <randomaditionaltime> )"
"Summary: called in individual vehicle file - define amount of radius damage to be set on each vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <rumble> :  rumble asset"
"MandatoryArg: <scale> : scale"
"MandatoryArg: <duration> : duration"
"MandatoryArg: <radius> : radius"
"MandatoryArg: <basetime> : time to wait between rumbles"
"MandatoryArg: <randomaditionaltime> : random amount of time to add to basetime"
"Example: build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_rumble( rumble, scale, duration, radius, basetime, randomaditionaltime )
{
	if ( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = [];
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	Assert( IsDefined( rumble ) );
	PreCacheRumble( rumble );
	struct.rumble = rumble;
	level.vehicle_rumble[ level.vttype ] = struct;
}

/* 
============= 
///ScriptDocBegin
"Name: build_deathquake( <scale> , <duration> , <radius> )"
"Summary: called in individual vehicle file - define amount of radius damage to be set on each vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <scale> : scale"
"MandatoryArg: <duration> : duration"
"MandatoryArg: <radius> : radius"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_deathquake( scale, duration, radius )
{
	if ( !isdefined( level.vehicle_death_earthquake ) )
		level.vehicle_death_earthquake = [];
	level.vehicle_death_earthquake[ level.vttype ] = build_quake( scale, duration, radius );
}

build_quake( scale, duration, radius, basetime, randomaditionaltime )
{
	struct = SpawnStruct();
	struct.scale = scale;
	struct.duration = duration;
	struct.radius = radius;
	if ( IsDefined( basetime ) )
		struct.basetime = basetime;
	if ( IsDefined( randomaditionaltime ) )
		struct.randomaditionaltime = randomaditionaltime;
	return struct;
}

build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, selfDeleteDelay )
{
	if ( !isdefined( bSoundlooping ) )
		bSoundlooping = false;
	if ( !isdefined( bEffectLooping ) )
		bEffectLooping = false;
	if ( !isdefined( delay ) )
		delay = 1;
	struct = SpawnStruct();
	struct.effect = _loadfx( effect );
	struct.tag = tag;
	struct.sound = sound;
	struct.bSoundlooping = bSoundlooping;
	struct.delay = delay;
	struct.waitDelay = waitDelay;
	struct.stayontag = stayontag;
	struct.notifyString = notifyString;
	struct.bEffectLooping = bEffectLooping;
	struct.selfDeleteDelay = selfDeleteDelay;
	return struct;
}


/* 
============= 
///ScriptDocBegin
"Name: build_deathfx_override( <type> , <model>, <effect> , <tag> , <sound> , <bEffectLooping> , <delay> , <bSoundlooping> , <waitDelay> , <stayontag> , <notifyString> , <delete_vehicle_delay>  )"
"Summary: called in individual vehicle file - death effects on vehicles, usually multiple lines for multistaged / multitagged sequences"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <type> : vehicle type to override the effect of"
"MandatoryArg: <type> : vehicle model to override the effect of"
"MandatoryArg: <effect> :  effect to play on death"
"OptionalArg: <tag> : tag to play the effect on"
"OptionalArg: <sound> : "  sound to play with effect
"OptionalArg: <bEffectLooping> : play it old fashioned loop style"
"OptionalArg: <delay> : old fashioned loop time"
"OptionalArg: <bSoundlooping> : true / false:  sound loops "
"OptionalArg: <waitDelay> : wait this long after death to start this effect sequence"
"OptionalArg: <stayontag> : playfxontag"
"OptionalArg: <notifyString> : notifies vehicle this when effect starts"
"OptionalArg: <delete_vehicle_delay> : delete the vehicle after this amount of time"
"Example: build_deathfx_override( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_deathfx_override( type, model, effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay  )
{
	level.vttype = type;
	level.vtmodel = model;
	level.vtoverride = true;
	typemodel = type + model;

	//for pre precache script calls.
	if ( !isdefined( level.vehicle_death_fx ) )
		level.vehicle_death_fx = [];

	// overwrite the deathfx post precache. 
	if( ! is_overrode( typemodel )  )
		level.vehicle_death_fx[ typemodel ] = [];
	
	level.vehicle_death_fx_override[ typemodel ] = true;
	
	if ( !isdefined( level.vehicle_death_fx[ typemodel ] ) )
		level.vehicle_death_fx[ typemodel ] = [];
		
	level.vehicle_death_fx[ typemodel ][ level.vehicle_death_fx [ typemodel ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay );

	level.vtoverride = undefined;
}



/* 
============= 
///ScriptDocBegin
"Name: build_deathfx( <effect> , <tag> , <sound> , <bEffectLooping> , <delay> , <bSoundlooping> , <waitDelay> , <stayontag> , <notifyString> , <delete_vehicle_delay> )"
"Summary: called in individual vehicle file - death effects on vehicles, usually multiple lines for multistaged / multitagged sequences"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <effect> :  effect to play on death"
"OptionalArg: <tag> : tag to play the effect on"
"OptionalArg: <sound> : sound to play with effect"
"OptionalArg: <bEffectLooping> : play it old fashioned loop style. Set this to true or undefined"
"OptionalArg: <delay> : old fashioned loop time in seconds"
"OptionalArg: <bSoundlooping> : true / false:  sound loops"
"OptionalArg: <waitDelay> : wait this long after death to start this effect sequence"
"OptionalArg: <stayontag> : playfxontag"
"OptionalArg: <notifyString> : notifies vehicle this when effect starts"
"OptionalArg: <delete_vehicle_delay> : delete the vehicle after this amount of time"
"Example: build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay )
{
	AssertEx( IsDefined( effect ), "Failed to build death effect because there is no effect specified for the model used for that vehicle." );
	typemodel = level.vttype + level.vtmodel;
	
	// don't build the deathfx if it's already in place. for call before _load.gsc. 
	if ( is_overrode ( typemodel ) )
		return;

	if ( !isdefined( level.vehicle_death_fx[ typemodel ] ) )
		level.vehicle_death_fx[ typemodel ] = [];
		
	level.vehicle_death_fx[ typemodel ][ level.vehicle_death_fx [ typemodel ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay );
}

is_overrode( typemodel )
{
	if( !IsDefined( level.vehicle_death_fx_override ) )
		return false;
		
	if( !IsDefined( level.vehicle_death_fx_override[ typemodel ] ) ) 
		return false;
		
	if( IsDefined( level.vtoverride ) )
		return true;  // not overrode if overriding.
		
	return level.vehicle_death_fx_override[ typemodel ];
}

/* 
============= 
///ScriptDocBegin
"Name: build_rocket_deathfx( <effect> , <tag> , <sound> , <bEffectLooping> , <delay> , <bSoundlooping> , <waitDelay> , <stayontag> , <notifyString> , <delete_vehicle_delay> )"
"Summary: Specify the alternate set of effects for a death on a vehicle caused by rockets"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <effect> :  effect to play on death"
"OptionalArg: <tag> : tag to play the effect on"
"OptionalArg: <sound> : sound to play with effect"
"OptionalArg: <bEffectLooping> : play it old fashioned loop style. Set this to true or undefined"
"OptionalArg: <delay> : old fashioned loop time in seconds"
"OptionalArg: <bSoundlooping> : true / false:  sound loops"
"OptionalArg: <waitDelay> : wait this long after death to start this effect sequence"
"OptionalArg: <stayontag> : playfxontag"
"OptionalArg: <notifyString> : notifies vehicle this when effect starts"
"OptionalArg: <delete_vehicle_delay> : delete the vehicle after this amount of time"
"Example: build_rocket_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 


build_rocket_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay )
{
	vttype = level.vttype;
	level.vttype = "rocket_death" + vttype;
	build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay );
	level.vttype = vttype;
}


precache_scripts()
{
	// find all the vehicles in the level and initialize precaching( calling of vehicles main() mostly )
	allvehiclesprespawn = [];

	vehicles = GetEntArray( "script_vehicle", "code_classname" );

	level.needsprecaching = [];
	playerdrivablevehicles = [];
	allvehiclesprespawn = [];
	if ( !isdefined( level.vehicleInitThread ) )
		level.vehicleInitThread = [];

	for ( i = 0; i < vehicles.size; i++ )
	{
		vehicles[ i ].vehicletype = ToLower( vehicles[ i ].vehicletype );
		if ( vehicles[ i ].vehicletype == "bog_mortar" || vehicles[ i ].vehicletype == "empty" )
			continue;

		if ( IsDefined( vehicles[ i ].spawnflags ) && vehicles[ i ].spawnflags & 1 )
			playerdrivablevehicles[ playerdrivablevehicles.size ] = vehicles[ i ];

		allvehiclesprespawn[ allvehiclesprespawn.size ] = vehicles[ i ];

		if ( !isdefined( level.vehicleInitThread[ vehicles[ i ].vehicletype ] ) )
			level.vehicleInitThread[ vehicles[ i ].vehicletype ] = [];

		loadstring = "maps\\\_" + vehicles[ i ].vehicletype + "::main( \"" + vehicles[ i ].model + "\" );";

		precachesetup( loadstring, vehicles[ i ] );
	}

	if ( level.needsprecaching.size > 0 )
	{
		PrintLn( "----------------------------------------------------------------------------------" );
		PrintLn( "---missing vehicle script: run repackage zone and precache scripts from launcher--" );
		PrintLn( "----------------------------------------------------------------------------------" );
		for ( i = 0; i < level.needsprecaching.size; i++ )
			PrintLn( level.needsprecaching[ i ] );
		PrintLn( "----------------------------------------------------------------------------------" );
		AssertEx( false, "missing vehicle scripts, see above console prints" );
		level waittill( "never" );
	}

//	if ( playerdrivablevehicles.size > 0 )
//		thread maps\_vehicledrive::main();// precache driveable vehicle huds and such.
	return allvehiclesprespawn;
}

precachesetup( string, vehicle )
{
	if ( IsDefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ) )
		return;
	matched = false;
	for ( i = 0; i < level.needsprecaching.size; i++ )
		if ( level.needsprecaching[ i ] == string )
			matched = true;
	if ( !matched )
		level.needsprecaching[ level.needsprecaching.size ] = string;
}

vehicle_kill_disconnect_paths_forever()
{
	self notify( "kill_disconnect_paths_forever" );
}

disconnect_paths_whenstopped()
{
	self endon( "death" );
	dont_disconnect_paths = false;
	if ( IsDefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
		dont_disconnect_paths = true;

	//if ( IsSubStr( self.vehicletype, "snowmobile" ) )
	//	dont_disconnect_paths = true;


	if ( dont_disconnect_paths )
	{
		self.dontDisconnectPaths = true;// lets other parts of the script know not to disconnect script
		return;
	}
	wait( RandomFloat( 1 ) );
	while ( IsDefined( self ) )
	{
		if ( self Vehicle_GetSpeed() < 1 )
		{
			if ( !isdefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
			self notify( "speed_zero_path_disconnect" );
			while ( self Vehicle_GetSpeed() < 1 )
				wait .05;
		}
		self ConnectPaths();
		wait 1;
	}
}

vehicle_setspeed_wrapper( speed, rate, msg )
{
	if ( self Vehicle_GetSpeed() ==  0 && speed == 0 )
		return;// potential for disaster? keeps messages from overriding previous messages

	/#
	self thread debug_vehiclesetspeed( speed, rate, msg );
	#/
	self Vehicle_SetSpeed( speed, rate );
}

debug_vehiclesetspeed( speed, rate, msg )
{
	/#
	self notify( "new debug_vehiclesetspeed" );
	self endon( "new debug_vehiclesetspeed" );
	self endon( "resuming speed" );
	self endon( "death" );
	while ( 1 )
	{
		while ( GetDvar( "debug_vehiclesetspeed" ) != "off" )
		{
			Print3d( self.origin + ( 0, 0, 192 ), "vehicle setspeed: " + msg, ( 1, 1, 1 ), 1, 3 );
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
	if ( !isdefined( self.resumemsgs ) )
		self.resumemsgs = [];
	if ( IsDefined( self.waitingforgate ) && self.waitingforgate )
		return;// ignore resumespeeds on waiting for gate.

	if ( IsDefined( self.attacking ) )
	{
		if ( self.attacking )
		{
			fSetspeed = self.attackspeed;
			type = "setspeed";
		}
	}

	self.zerospeed = false;
	if ( fSetspeed == 0 )
		self.zerospeed = true;
	if ( type == "resumespeed" )
		self ResumeSpeed( rate );
	else if ( type == "setspeed" )
		self vehicle_setspeed_wrapper( fSetspeed, 15, "resume setspeed from attack" );
	self notify( "resuming speed" );
	/# self thread debug_vehicleresume( msg + " :" + type ); #/

}

/#
debug_vehicleresume( msg )
{
	if ( GetDvar( "debug_vehicleresume" ) == "off" )
		return;
	self endon( "death" );
	number = self.resumemsgs.size;
	self.resumemsgs[ number ] = msg;
	timer = 3;
	self thread print_resumespeed( GetTime() + ( timer * 1000 ) );

	wait timer;
	newarray = [];
	for ( i = 0; i < self.resumemsgs.size; i++ )
	{
		if ( i != number )
			newarray[ newarray.size ] = self.resumemsgs[ i ];
	}
	self.resumemsgs =  newarray;
}
#/

print_resumespeed( timer )
{
	self notify( "newresumespeedmsag" );
	self endon( "newresumespeedmsag" );
	self endon( "death" );
	while ( GetTime() < timer && IsDefined( self.resumemsgs ) )
	{
		if ( self.resumemsgs.size > 6 )
			start = self.resumemsgs.size - 5;
		else
			start = 0;
		for ( i = start; i < self.resumemsgs.size; i++ )// only display last 5 messages
		{
			position = i * 32;
			Print3d( self.origin + ( 0, 0, position ), "resuming speed: " + self.resumemsgs[ i ], ( 0, 1, 0 ), 1, 3 );
		}
		wait .05;
	}
}

force_kill()
{
	if ( isDestructible() )
	{
		self common_scripts\_destructible::force_explosion();
	}
	else
	{
		self Kill();
	}
}

/*
=============
///ScriptDocBegin
"Name: godon( <godon> )"
"Summary: Vehicle gets god mode"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
godon()
{
	self.godmode = true;
}

/*
=============
///ScriptDocBegin
"Name: godoff( <godoff> )"
"Summary: Vehicle loses god mode"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
godoff()
{
	self.godmode = false;
}

setturretfireondrones( b )
{
	if ( IsDefined( self.mgturret ) && self.mgturret.size )
		for ( i = 0; i < self.mgturret.size; i++ )
			self.mgturret[ i ].script_fireondrones = b;
}

getnormalanimtime( animation )
{
	animtime = self GetAnimTime( animation );
	animlength = GetAnimLength( animation );
	if ( animtime == 0 )
		return 0;
	return self GetAnimTime( animation ) / GetAnimLength( animation );
}

rotor_anim()
{
	length = GetAnimLength( self getanim( "rotors" ) );
	for ( ;; )
	{
		self SetAnim( self getanim( "rotors" ), 1, 0, 1 );
		wait( length );
	}
}

suspend_drive_anims()
{
	self notify( "suspend_drive_anims" );

	model = self.model;

	self ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
	self ClearAnim( level.vehicle_DriveIdle_r[ model ], 0 );
}

idle_animations()
{
	self UseAnimTree( #animtree );
	
	if( !isdefined( level.vehicle_IdleAnim[ self.model ] ) )
		return;
		
	foreach( animation in level.vehicle_IdleAnim[ self.model ] )
		self setanim( animation );
	
}

animate_drive_idle()
{
	self endon( "suspend_drive_anims" );

	if ( !isdefined( self.wheeldir ) )
		self.wheeldir = 1;
	model = self.model;

	newanimtime = undefined;
	self UseAnimTree( #animtree );
	if ( !isdefined( level.vehicle_DriveIdle[ model ] ) )
		return;
	if ( !isdefined( level.vehicle_DriveIdle_r[ model ] ) )
		level.vehicle_DriveIdle_r[ model ] = level.vehicle_DriveIdle[ model ];// use forward animation if no backwards anim exists
	self endon( "death" );
	normalspeed = level.vehicle_DriveIdle_normal_speed[ model ];

	thread animate_drive_idle_death();

	animrate = 1.0;
	if ( ( IsDefined( level.vehicle_DriveIdle_animrate ) ) && ( IsDefined( level.vehicle_DriveIdle_animrate[ model ] ) ) )
		animrate = level.vehicle_DriveIdle_animrate[ model ];

	lastdir = self.wheeldir;

	animatemodel = self;
	animation = level.vehicle_DriveIdle[ model ];

	while ( 1 )
	{
// 		animatemodel = get_dummy();
		if ( !normalspeed )
		{
			if ( IsDefined( self.suspend_driveanims ) )
			{
				wait .05;
				continue;
			}

			// vehicles like helicopters always play the same rate. will come up with better design if need arises.
			animatemodel SetAnim( level.vehicle_DriveIdle[ model ], 1, .2, animrate );
			thread animtimer( .5 );
			self waittill( "animtimer" );
			continue;
		}

		speed = self Vehicle_GetSpeed();

		if ( lastdir != self.wheeldir )
		{
			dif = 0;
			if ( self.wheeldir )
			{
				animation = level.vehicle_DriveIdle [ model ];
				dif = 1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle_r [ model ] );
				animatemodel ClearAnim( level.vehicle_DriveIdle_r [ model ], 0 );
			}
			else
			{
				animation = level.vehicle_DriveIdle_r[ model ];// reverse direction
				dif  =  1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle [ model ] );
				animatemodel ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
			}

			newanimtime = 0.01;
			if ( newanimtime >= 1 || newanimtime == 0 )
				newanimtime = 0.01;// think setting animtime to 0 or 1 messes things up
			lastdir = self.wheeldir;
		}

		if ( speed == 0 )
			animatemodel SetAnim( animation, 1, .05, 0 );
		else
			animatemodel SetAnim( animation, 1, .05, speed / normalspeed );

		if ( IsDefined( newanimtime ) )
		{
			animatemodel SetAnimTime( animation, newanimtime );
			newanimtime = undefined;
		}

		thread animtimer( .05 );
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
	self endon( "suspend_drive_anims" );

	model = self.model;
	self UseAnimTree( #animtree );
	self waittill( "death_finished" );
	if ( IsDefined( self ) )
		self ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
}

setup_dynamic_detour( pathnode, get_func )
{
	prevnode = [[ get_func ]]( pathnode.targetname );
	AssertEx( IsDefined( prevnode ), "detour can't be on start node" );
	prevnode.detoured = 0;
}

/* 
setup_origins()
{
	triggers = []; 
	origins = GetEntArray( "script_origin", "classname" );
	for ( i = 0; i < origins.size; i++ )
	{
		if ( IsDefined( origins[ i ].script_vehicledetour ) )
		{

			level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, origins[ i ].script_vehicledetour, origins[ i ] );
			if ( level.vehicle_detourpaths[ origins[ i ].script_vehicledetour ].size > 2 )
				PrintLn( "more than two script_vehicledetour grouped in group number: ", origins[ i ].script_vehicledetour );

			prevnode = GetEnt( origins[ i ].targetname, "target" );
			AssertEx( IsDefined( prevnode ), "detour can't be on start node" );
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
	ai = GetAIArray();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( IsDefined( ai[ i ].script_vehicleride ) )
			level.vehicle_RideAI = array_2dadd( level.vehicle_RideAI, ai[ i ].script_vehicleride, ai[ i ] );
		else
		if ( IsDefined( ai[ i ].script_vehiclewalk ) )
			level.vehicle_WalkAI = array_2dadd( level.vehicle_WalkAI, ai[ i ].script_vehiclewalk, ai[ i ] );
	}
	ai = GetSpawnerArray();

	for ( i = 0; i < ai.size; i++ )
	{
		if ( IsDefined( ai[ i ].script_vehicleride ) )
			level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, ai[ i ].script_vehicleride, ai[ i ] );
		if ( IsDefined( ai[ i ].script_vehiclewalk ) )
			level.vehicle_walkspawners = array_2dadd( level.vehicle_walkspawners, ai[ i ].script_vehiclewalk, ai[ i ] );
	}
}

array_2dadd( array, firstelem, newelem )
{
	if ( !isdefined( array[ firstelem ] ) )
		array[ firstelem ] = [];
	array[ firstelem ][ array[ firstelem ].size ] = newelem;
	return array;
}

is_node_script_origin( pathnode )
{
	return IsDefined( pathnode.classname ) && pathnode.classname == "script_origin";
}

// this determines if the node will be sent through trigger_process.  The uber trigger function that may get phased out.
node_trigger_process()
{
	processtrigger = false;

	// special treatment for start nodes
	if ( IsDefined( self.spawnflags ) && ( self.spawnflags & 1 ) )
	{
		if ( IsDefined( self.script_crashtype ) )
			level.vehicle_crashpaths[ level.vehicle_crashpaths.size ] = self;
		level.vehicle_startnodes[ level.vehicle_startnodes.size ] = self;
	}

	if ( IsDefined( self.script_vehicledetour ) && IsDefined( self.targetname ) )
	{
		get_func = undefined;
		// get_func is differnt for struct types and script_origin types of paths
		if ( IsDefined( get_from_entity( self.targetname ) ) )
			get_func = ::get_from_entity_target;
		if ( IsDefined( get_from_spawnstruct( self.targetname ) ) )
			get_func = ::get_from_spawnstruct_target;

		if ( IsDefined( get_func ) )
		{
			setup_dynamic_detour( self, get_func );
			processtrigger = true;// the node with the script_vehicledetour waits for the trigger here unlike ground nodes which need to know 1 node in advanced that there's a detour, tricky tricky.
		}
		else
		{
			setup_groundnode_detour( self );// other trickery.  the node is set to process in there.
		}

		level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, self.script_vehicledetour, self );
		if ( level.vehicle_detourpaths[ self.script_vehicledetour ].size > 2 )
			PrintLn( "more than two script_vehicledetour grouped in group number: ", self.script_vehicledetour );
	}

	// if a gate isn't open then the vehicle will stop there and wait for it to become open.
	if ( IsDefined( self.script_gatetrigger ) )
	{
		level.vehicle_gatetrigger = array_2dadd( level.vehicle_gatetrigger, self.script_gatetrigger, self );
		self.gateopen = false;
	}

	// init the flags! 
	if ( IsDefined( self.script_flag_set ) )
	{
		if ( !isDefined( level.flag[ self.script_flag_set ] ) )
			flag_init( self.script_flag_set );
	}

	// init the flags! 
	if ( IsDefined( self.script_flag_clear ) )
	{
		if ( !isDefined( level.flag[ self.script_flag_clear ] ) )
			flag_init( self.script_flag_clear );
	}

	if ( IsDefined( self.script_flag_wait ) )
	{
		if ( !isDefined( level.flag[ self.script_flag_wait ] ) )
			flag_init( self.script_flag_wait );
	}

	// various nodes that will be sent through trigger_process
	if (
		  	IsDefined( self.script_VehicleSpawngroup )
		 		 || 	IsDefined( self.script_VehicleStartMove )
		 		 || 	IsDefined( self.script_gatetrigger )
		 		 || 	IsDefined( self.script_vehicleGroupDelete )
	 	 )
	processtrigger = true;

	if ( processtrigger )
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

	triggers = [];
	triggers = array_combine( GetAllVehicleNodes(), GetEntArray( "script_origin", "code_classname" ) );
	triggers = array_combine( triggers, level.struct );
	triggers = array_combine( triggers, GetEntArray( "trigger_radius", "code_classname" ) );
	triggers = array_combine( triggers, GetEntArray( "trigger_disk", "code_classname" ) );
	triggers = array_combine( triggers, GetEntArray( "trigger_multiple", "code_classname" ) );
	triggers = array_combine( triggers, GetEntArray( "trigger_lookat", "code_classname" ) );

	array_thread( triggers, ::node_trigger_process );

}

is_node_script_struct( node )
{
	if ( ! IsDefined( node.targetname ) )
		return false;
	return IsDefined( getstruct( node.targetname, "targetname" ) );
}

setup_vehicles( vehicles )
{
	nonspawned = [];
	level.failed_spawnvehicles = [];

	foreach ( vehicle in vehicles )
	{

		//here's a hook for gags on vehicles. 
		vehicle setup_gags();

		if ( vehicle check_spawn_group_isspawner() )
			continue;
		else
			nonspawned[ nonspawned.size ] = vehicle;
	}

	//print list of spawngroups that fail due to lack of spawner spawnflag
	check_failed_spawn_groups();

	// init vehicles that aren't spawned
	foreach ( live_vehicle in nonspawned )
		thread vehicle_init( live_vehicle );

}

check_failed_spawn_groups()
{
	if ( !level.failed_spawnvehicles.size )
	{
		level.failed_spawnvehicles = undefined;
		return;
	}

	PrintLn( "Error: FAILED SPAWNGROUPS" );
	foreach ( failed_spawner in level.failed_spawnvehicles )
	{
		PrintLn( "Error: spawner at: " + failed_spawner.origin );
	}
	AssertMsg( "Spawngrouped vehicle( s ) without spawnflag checked, see console" );


}

check_spawn_group_isspawner()
{
	if ( IsDefined( self.script_VehicleSpawngroup ) && !isSpawner( self ) )
	{
		level.failed_spawnvehicles[ level.failed_spawnvehicles.size ] = self;
		return true;
	}
	return isSpawner( self );
}




vehicle_life()
{

	type = self.vehicletype;

	if ( !isdefined( level.vehicle_life ) || !isdefined( level.vehicle_life[ self.vehicletype ] ) )
	{
		wait 2;
	}
	AssertEx( IsDefined( level.vehicle_life[ type ] ), "need to specify build_life() in vehicle script for vehicletype: " + type );


	if ( IsDefined( self.script_startinghealth ) )
		self.health = self.script_startinghealth;
	else
	{
		if ( level.vehicle_life[ type ] == -1 )
			return;
		else if ( IsDefined( level.vehicle_life_range_low[ type ] ) && IsDefined( level.vehicle_life_range_high[ type ] ) )
			self.health  = ( RandomInt( level.vehicle_life_range_high[ type ] - level.vehicle_life_range_low[ type ] ) + level.vehicle_life_range_low[ type ] );
		else
			self.health = level.vehicle_life[ type ];
	}

	if ( IsDefined( level.destructible_model[ self.model ] ) )
	{
		self.health = 2000;
		self.destructible_type = level.destructible_model[ self.model ];
		self common_scripts\_destructible::setup_destructibles( true );
	}

}

mginit()
{

	typemodel = self.vehicletype + self.model;

	if ( ( ( IsDefined( self.script_nomg ) ) && ( self.script_nomg > 0 ) ) )
		return;

	if ( !isdefined( level.vehicle_mgturret[ typemodel ] ) )
		return;

	mgangle = 0;
	if ( IsDefined( self.script_mg_angle ) )
		mgangle = self.script_mg_angle;


	turret_templates = level.vehicle_mgturret[ typemodel ];
	if ( !isdefined( turret_templates ) )
		return;

	one_turret = IsDefined( self.script_noteworthy ) && self.script_noteworthy == "onemg";

	foreach ( index, turret_template in turret_templates )
	{
		turret = SpawnTurret( "misc_turret", ( 0, 0, 0 ), turret_template.info );
		turret LinkTo( self, turret_template.tag, ( 0, 0, 0 ), ( 0, -1 * mgangle, 0 ) );
		turret SetModel( turret_template.model );
		turret.angles = self.angles;
		turret.isvehicleattached = true;// lets mgturret know not to mess with this turret
		turret.ownerVehicle = self;
		Assert( IsDefined( self.script_team ) );
		turret.script_team = self.script_team;// lets mgturret know not to mess with this turret
		turret thread maps\_mgturret::burst_fire_unmanned();
		turret MakeUnusable();
		set_turret_team( turret );
		level thread maps\_mgturret::mg42_setdifficulty( turret, getDifficulty() );

		if ( IsDefined( self.script_fireondrones ) )
			turret.script_fireondrones = self.script_fireondrones;
		if ( IsDefined( turret_template.deletedelay ) )
			turret.deletedelay = turret_template.deletedelay;

		if ( IsDefined( turret_template.maxrange ) )
			turret.maxrange = turret_template.maxrange;

		//default drop pitch defaultdroppitch, defaultdropyaw
		if ( IsDefined( turret_template.defaultdroppitch ) )
			turret SetDefaultDropPitch( turret_template.defaultdroppitch );

		self.mgturret[ index ] = turret;

		if ( one_turret )
			break;
	}

	foreach ( i, turret in self.mgturret )
	{
		defaultOnMode = level.vehicle_mgturret[ typemodel ][ i ].defaultONmode;
		if ( IsDefined( defaultOnMode ) )
		{
			turret turret_set_default_on_mode( defaultOnMode );
		}
	}

	if ( !isdefined( self.script_turretmg ) )
		self.script_turretmg = true;;

	if ( IsDefined( self.script_turretmg ) && self.script_turretmg == 0 )
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
	if ( self.script_turretmg )
		lasttoggle = 1;
	else
		lasttoggle = 0;
	while ( 1 )
	{
		if ( lasttoggle != self.script_turretmg )
		{
			lasttoggle = self.script_turretmg;
			if ( self.script_turretmg )
				self thread mgon();
			else
				self thread mgoff();
		}
		wait .5;
	}
}

/*
=============
///ScriptDocBegin
"Name: mgoff( <mgoff> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
mgoff()
{
	self.script_turretmg = 0;

	if ( ( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		self thread chopper_Turret_Off();
		return;
	}

	if ( !isdefined( self.mgturret ) )
		return;

	foreach ( i, turret in self.mgturret )
	{
		if ( IsDefined( turret.script_fireondrones ) )
			turret.script_fireondrones = false;

		turret SetMode( "manual" );
	}
}

/*
=============
///ScriptDocBegin
"Name: mgon( <mgon> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
mgon()
{
	self.script_turretmg = 1;// fix me.. defense for scripts using mgon();

	if ( ( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		self thread chopper_Turret_On();
		return;
	}

	if ( !isdefined( self.mgturret ) )
		return;

	foreach ( turret in self.mgturret )
	{
		turret Show();// for hidden turrets on vehicles that shouldn't have turrets

		if ( IsDefined( turret.script_fireondrones ) )
			turret.script_fireondrones = true;

		if ( IsDefined( turret.defaultONmode ) )
		{
			turret SetMode( turret.defaultONmode );
		}
		else
		{
			turret SetMode( "auto_nonai" );
		}

		set_turret_team( turret );
	}
}

set_turret_team( turret )
{
	switch( self.script_team )
	{
		case "allies":
		case "friendly":
			turret SetTurretTeam( "allies" );
			break;

		case "axis":
		case "enemy":
			turret SetTurretTeam( "axis" );
			break;
		case "team3":
			turret SetTurretTeam( "team3" );
			break;

		default:
			AssertMsg( "Unknown script_team: " + self.script_team );
			break;
	}
}

turret_set_default_on_mode( defaultOnMode )
{
	self.defaultONmode = defaultOnMode;
}


isHelicopter()
{
	return IsDefined( level.helicopter_list[ self.vehicletype ] );
}

isAirplane()
{
	return IsDefined( level.airplane_list[ self.vehicletype ] );
}

isCheap()
{
	if ( !isdefined( self.script_cheap ) )
		return false;

	if ( !self.script_cheap )
		return false;

	return true;
}


hasHelicopterDustKickup()
{
	if ( !isHelicopter() && !isAirplane() )
		return false;

	if ( isCheap() )
		return false;

	return true;
}

hasHelicopterTurret()
{
	if ( !isdefined( self.vehicletype ) )
		return false;
	if ( isCheap() )
		return false;
	if ( self.vehicletype == "cobra" )
		return true;
	if ( self.vehicletype == "cobra_player" )
		return true;
	if ( self.vehicletype == "viper" )
		return true;
	return false;
}

Chopper_Turret_On()
{
	self endon( "death" );
	self endon( "mg_off" );

	cosine55 = Cos( 55 );

	while ( self.health > 0 )
	{
		// target range, target fov, getAITargets, doTrace
		eTarget = self maps\_helicopter_globals::getEnemyTarget( 16000, cosine55, true, true );
		if ( IsDefined( eTarget ) )
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
 	eModel = get_dummy();
	effectorigin = Spawn( "script_origin", eModel.origin );

	self endon( "fire_extinguish" );
	thread playLoopedFxontag_originupdate( tag, effectorigin );
	while ( 1 )
	{
		PlayFX( effect, effectorigin.origin, effectorigin.upvec );
		wait durration;
	}
}

playLoopedFxontag_originupdate( tag, effectorigin )
{
	effectorigin.angles = self GetTagAngles( tag );
	effectorigin.origin  = self GetTagOrigin( tag );
	effectorigin.forwardvec = AnglesToForward( effectorigin.angles );
	effectorigin.upvec = AnglesToUp( effectorigin.angles );
	while ( IsDefined( self ) && self.code_classname == "script_vehicle"  && self Vehicle_GetSpeed() > 0 )
	{
		eModel = get_dummy();
		effectorigin.angles = eModel GetTagAngles( tag );
		effectorigin.origin  = eModel GetTagOrigin( tag );
		effectorigin.forwardvec = AnglesToForward( effectorigin.angles );
		effectorigin.upvec = AnglesToUp( effectorigin.angles );
		wait .05;
	}
}

/*
=============
///ScriptDocBegin
"Name: build_turret( <info> , <tag> , <model> , <maxrange> , <defaultONmode> , <deletedelay>, <defaultdroppitch>, <defaultdropyaw> )"
"Summary: Creates an mg turret on a vehicle"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: An entity"
"MandatoryArg: <info>: weapon info"
"MandatoryArg: <tag>: of vehicle tag to attach the turret to"
"MandatoryArg: <model>: model of turret"
"MandatoryArg: <maxrange>: maxrange "
"MandatoryArg: <defaultONmode>: ai on mode for turret(auto-nonai and stuff)"
"MandatoryArg: <deletedelay>: used for hacking death sequences"
"MandatoryArg: <defaultdroppitch>: set the defaultdroppitch"
"MandatoryArg: <defaultdropyaw>: set the defaultdropyaw"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

build_turret( info, tag, model, maxrange, defaultONmode, deletedelay, defaultdroppitch, defaultdropyaw )
{
	if ( !isdefined( level.vehicle_mgturret ) )
		level.vehicle_mgturret = [];

	typemodel = level.vttype + level.vtmodel;
	if ( !isdefined( level.vehicle_mgturret[ typemodel ] ) )
		level.vehicle_mgturret[ typemodel ] = [];

	PreCacheModel( model );
	PreCacheTurret( info );
	struct = SpawnStruct();
	struct.info = info;
	struct.tag = tag;
	struct.model = model;
	struct.maxrange = maxrange;
	struct.defaultONmode = defaultONmode;
	struct.deletedelay = deletedelay;
	struct.defaultdroppitch = defaultdroppitch;
	struct.defaultdropyaw = defaultdropyaw;
	level.vehicle_mgturret[ typemodel ][ level.vehicle_mgturret[ typemodel ].size ] = struct;
}


setup_dvars()
{
	/#
	SetDvarIfUninitialized( "debug_tankcrush", "0" );
	SetDvarIfUninitialized( "debug_vehicleresume", "off" );
	SetDvarIfUninitialized( "debug_vehiclesetspeed", "off" );
	#/
}

empty_var( var )
{

}

setup_levelvars()
{
	level.vehicle_ResumeSpeed = 5;
	level.vehicle_DeleteGroup = [];
	level.vehicle_StartMoveGroup = [];
	level.vehicle_RideAI =  [];
	level.vehicle_WalkAI =  [];
	level.vehicle_DeathSwitch = [];
	level.vehicle_RideSpawners = [];
	level.vehicle_walkspawners = [];
	level.vehicle_gatetrigger = [];
	level.vehicle_crashpaths = [];
	level.vehicle_link = [];
	level.vehicle_detourpaths = [];
// 	level.vehicle_linkedpaths = []; 
	level.vehicle_startnodes = [];
	level.vehicle_killspawn_groups = [];

	if ( !isdefined( level.drive_spline_path_fun ) )
		level.drive_spline_path_fun = ::empty_var;

	level.helicopter_crash_locations = GetEntArray( "helicopter_crash_location", "targetname" );

	level.playervehicle = Spawn( "script_origin", ( 0, 0, 0 ) );// no isdefined for level.playervehicle
	level.playervehiclenone = level.playervehicle;// no isdefined for level.playervehicle

	// TODO in a thousand next games.. I don't like managing this variable. not so much that I don't like it, just that I haven't been = / 
	level.vehicles = []; 	// will contain all the vehicles that are spawned and alive
	level.vehicles[ "allies" ] = [];
	level.vehicles[ "axis" ] = [];
	level.vehicles[ "neutral" ] = [];
	level.vehicles[ "team3" ] = [];

	if ( !isdefined( level.vehicle_team ) )
		level.vehicle_team = [];
	if ( !isdefined( level.vehicle_deathmodel ) )
		level.vehicle_deathmodel = [];
	if ( !isdefined( level.vehicle_death_thread ) )
		level.vehicle_death_thread = [];
	if ( !isdefined( level.vehicle_DriveIdle ) )
		level.vehicle_DriveIdle = [];
	if ( !isdefined( level.vehicle_DriveIdle_r ) )
		level.vehicle_DriveIdle_r = [];
	if ( !isdefined( level.attack_origin_condition_threadd ) )
		level.attack_origin_condition_threadd = [];
	if ( !isdefined( level.vehiclefireanim ) )
		level.vehiclefireanim = [];
	if ( !isdefined( level.vehiclefireanim_settle ) )
		level.vehiclefireanim_settle = [];
	if ( !isdefined( level.vehicle_hasname ) )
		level.vehicle_hasname = [];
	if ( !isdefined( level.vehicle_turret_requiresrider ) )
		level.vehicle_turret_requiresrider = [];
	if ( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = [];
	if ( !isdefined( level.vehicle_mgturret ) )
		level.vehicle_mgturret = [];
	if ( !isdefined( level.vehicle_isStationary ) )
		level.vehicle_isStationary = [];
	if ( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = [];
	if ( !isdefined( level.vehicle_death_earthquake ) )
		level.vehicle_death_earthquake = [];
	if ( !isdefined( level.vehicle_treads ) )
		level.vehicle_treads = [];
	if ( !isdefined( level.vehicle_compassicon ) )
		level.vehicle_compassicon = [];
	if ( !isdefined( level.vehicle_unloadgroups ) )
		level.vehicle_unloadgroups = [];
	if ( !isdefined( level.vehicle_aianims ) )
		level.vehicle_aianims = [];
	if ( !isdefined( level.vehicle_unloadwhenattacked ) )
		level.vehicle_unloadwhenattacked = [];
	if ( !isdefined( level.vehicle_exhaust ) )
		level.vehicle_exhaust = [];
	if ( !isdefined( level.vehicle_deckdust ) )
		level.vehicle_deckdust = [];
	if ( !isdefined( level.vehicle_shoot_shock ) )
		level.vehicle_shoot_shock = [];
	if ( !isdefined( level.vehicle_frontarmor ) )
		level.vehicle_frontarmor = [];
	if ( !isdefined( level.destructible_model ) )
		level.destructible_model = [];
	if ( !isdefined( level.vehicle_types ) )
		level.vehicle_types = [];
	if ( !isdefined( level.vehicle_compass_types ) )
		level.vehicle_compass_types = [];
	if ( !isdefined( level.vehicle_grenadeshield ) )
		level.vehicle_grenadeshield = [];
	if ( !isdefined( level.vehicle_bulletshield ) )
		level.vehicle_bulletshield = [];
	if ( !isdefined( level.vehicle_death_jolt ) )
		level.vehicle_death_jolt = [];
	if ( !isdefined( level.vehicle_death_badplace ) )
		level.vehicle_death_badplace = [];
	if ( !isdefined( level.vehicle_IdleAnim ) )
		level.vehicle_IdleAnim = [];

	maps\_vehicle_aianim::setup_aianimthreads();

}


attacker_isonmyteam( attacker )
{
	if ( ( IsDefined( attacker ) ) && IsDefined( attacker.script_team ) && ( IsDefined( self.script_team ) ) && ( attacker.script_team == self.script_team ) )
		return true;
	else
		return false;
}

is_invulnerable_from_ai( attacker )
{
	//vehicles with script_AI_invulnerable = 1 cannot be damaged by attacking AI
	if ( !isdefined( self.script_AI_invulnerable ) )
		return false;
	if ( ( IsDefined( attacker ) ) && ( IsAI( attacker ) ) && ( self.script_AI_invulnerable == 1 ) )
		return true;
	else
		return false;
}

is_godmode()
{
	if ( IsDefined( self.godmode ) && self.godmode )
		return true;
	else
		return false;
}

attacker_troop_isonmyteam( attacker )
{
	if ( IsDefined( self.script_team ) && self.script_team == "allies" && IsDefined( attacker ) && IsPlayer( attacker ) )
		return true;// player is always on the allied team.. hahah! future CoD games that let the player be the enemy be damned!
	else if ( IsAI( attacker ) && attacker.team == self.script_team )
		return true;
	else
		return false;
}

has_frontarmor()
{
	return( IsDefined( level.vehicle_frontarmor [ self.vehicletype ] ) );
}

grenadeshielded( type )
{
	if ( !isdefined( self.script_grenadeshield ) )
		return false;

	type = ToLower( type );

	if ( ! IsDefined( type ) || ! IsSubStr( type, "grenade" ) )
		return false;

	if ( self.script_grenadeshield )
		return true;
	else
		return false;
}

bulletshielded( type )
{
	if ( !isdefined( self.script_bulletshield ) )
		return false;


	type = ToLower( type );
													// hack to make explosive bullets bypass the bulletshield. -R
	if ( ! IsDefined( type ) || ! IsSubStr( type, "bullet" ) || IsSubStr( type, "explosive" ) )
		return false;

	if ( self.script_bulletshield )
		return true;
	else
		return false;
}

friendlyfire_shield()
{
	self endon( "death" );
	self endon( "stop_friendlyfire_shield" );

	if ( IsDefined( level.vehicle_bulletshield[ self.vehicletype ] ) && !isdefined( self.script_bulletshield ) )
		self.script_bulletshield = level.vehicle_bulletshield[ self.vehicletype ];

	if ( IsDefined( level.vehicle_grenadeshield[ self.vehicletype ] ) && !isdefined( self.script_grenadeshield ) )
		self.script_grenadeshield = level.vehicle_bulletshield[ self.vehicletype ];

	if ( IsDefined( self.script_mp_style_helicopter ) )
	{
		self.script_mp_style_helicopter = true;
		self.bullet_armor = 5000;
		self.health = 350;
	}
	else
		self.script_mp_style_helicopter = false;

	self.healthbuffer = 20000;
	self.health += self.healthbuffer;
	self.currenthealth = self.health;
	attacker = undefined;
	type = undefined;

	while ( self.health > 0 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );

		if ( IsDefined( attacker ) )
			attacker maps\_player_stats::register_shot_hit();

		if (
						( ! IsDefined( attacker ) && self.script_team != "neutral" )
				 || 	is_godmode()
				 || 	attacker_isonmyteam( attacker )
				 || 	attacker_troop_isonmyteam( attacker )
				 || 	isDestructible()
				 || 	is_invulnerable_from_ai( attacker )
				 || 	bulletshielded( type )
				 ||		grenadeshielded( type )
				 || 	type == "MOD_MELEE"
			 )
			self.health = self.currenthealth;// give back health for these things
		else if ( self has_frontarmor() )// regen health for tanks with armor in the front
		{
			self regen_front_armor( attacker, amount );
			self.currenthealth = self.health;
		}
		else if ( self hit_bullet_armor( type ) )
		{
			self.health = self.currenthealth;
			self.bullet_armor -= amount;
		}
		else
			self.currenthealth = self.health;

		if ( common_scripts\_destructible::getDamageType( type ) == "splash" )
			self.rocket_destroyed_for_achievement = true;// little bit of hackery, not perfect but contributes to achievement script for determining that this heli was destroyed by the players RPG.
		else
			self.rocket_destroyed_for_achievement = undefined;

		if ( self.health < self.healthbuffer && !isdefined( self.vehicle_stays_alive ) )
			break;
		amount = undefined;
		attacker = undefined;
		direction_vec = undefined;
		point = undefined;
		modelName = undefined;
		tagName = undefined;
		type = undefined;
	}

	self notify( "death", attacker, type );
}

hit_bullet_armor( type )
{
	if ( ! self.script_mp_style_helicopter )
		return false;
	if ( self.bullet_armor <= 0 )
		return false;
	if ( !( IsDefined( type ) ) )
		return false;
	if ( ! IsSubStr( type, "BULLET" ) )
		return false;
	else
		return true;
}


regen_front_armor( attacker, amount )
{
	forwardvec = AnglesToForward( self.angles );
	othervec = VectorNormalize( attacker.origin - self.origin );
	if ( VectorDot( forwardvec, othervec ) > .86 )
		self.health += Int( amount * level.vehicle_frontarmor [ self.vehicletype ] );
}

vehicle_kill_rumble_forever()
{
	self notify( "kill_rumble_forever" );
}

vehicle_rumble()
{
// makes vehicle rumble

	self endon( "kill_rumble_forever" );
	type = self.vehicletype;
	if ( !isdefined( level.vehicle_rumble[ type ] ) )
		return;

	rumblestruct = level.vehicle_rumble[ type ];
	height = rumblestruct.radius * 2;
	zoffset = -1 * rumblestruct.radius;
	areatrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, zoffset ), 0, rumblestruct.radius, height );
	areatrigger EnableLinkTo();
	areatrigger LinkTo( self );
	self.rumbletrigger = areatrigger;
	self endon( "death" );
// 	( rumble, scale, duration, radius, basetime, randomaditionaltime )
	if ( !isdefined( self.rumbleon ) )
		self.rumbleon = true;
	if ( IsDefined( rumblestruct.scale ) )
		self.rumble_scale = rumblestruct.scale;
	else
		self.rumble_scale = 0.15;

	if ( IsDefined( rumblestruct.duration ) )
		self.rumble_duration = rumblestruct.duration;
	else
		self.rumble_duration = 4.5;

	if ( IsDefined( rumblestruct.radius ) )
	{
		self.rumble_radius = rumblestruct.radius;
	}
	else
	{
		self.rumble_radius = 600;
	}

	if ( IsDefined( rumblestruct.basetime ) )
	{
		self.rumble_basetime = rumblestruct.basetime;
	}
	else
	{
		self.rumble_basetime = 1;
	}

	if ( IsDefined( rumblestruct.randomaditionaltime ) )
	{
		self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
	}
	else
	{
		self.rumble_randomaditionaltime = 1;
	}

	areatrigger.radius = self.rumble_radius;
	while ( 1 )
	{
		areatrigger waittill( "trigger" );
		if ( self Vehicle_GetSpeed() == 0 || !self.rumbleon )
		{
			wait .1;
			continue;
		}

		self PlayRumbleLoopOnEntity( level.vehicle_rumble[ type ].rumble );
		while ( level.player IsTouching( areatrigger ) && self.rumbleon && self Vehicle_GetSpeed() > 0 )
		{
			Earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius );// scale duration source radius
			wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
		}
		self StopRumble( level.vehicle_rumble[ type ].rumble );
	}
}

vehicle_kill_badplace_forever()
{
	self notify( "kill_badplace_forever" );
}

vehicle_badplace()
{
	if ( !isdefined( self.script_badplace ) )
		return;
	self endon( "kill_badplace_forever" );
	if ( !self Vehicle_IsPhysVeh() )
		self endon( "death" );
	self endon( "delete" );
	if ( IsDefined( level.custombadplacethread ) )
	{
		self thread [[ level.custombadplacethread ]]();
		return;
	}
	hasturret = IsDefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ];
	bp_duration = .5;
	bp_angle_left = 17;
	bp_angle_right = 17;
	for ( ;; )
	{
		if ( !self.script_badplace )
		{
// 			BadPlace_Delete( "tankbadplace" );
			while ( !self.script_badplace )
				wait .5;
		}
		speed = self Vehicle_GetSpeed();
		if ( speed <= 0 )
		{
			wait bp_duration;
			continue;
		}
		if ( speed < 5 )
			bp_radius = 200;
		else if ( ( speed > 5 ) && ( speed < 8 ) )
			bp_radius = 350;
		else
			bp_radius = 500;

		if ( IsDefined( self.BadPlaceModifier ) )
			bp_radius = ( bp_radius * self.BadPlaceModifier );

// 			bp_direction = AnglesToForward( self.angles );
		if ( hasturret )
			bp_direction = AnglesToForward( self GetTagAngles( "tag_turret" ) );
		else
			bp_direction = AnglesToForward( self.angles );

		// have to use unique names for each bad place. if not they will be shared for all vehicles and thats not good. - R
		BadPlace_Arc( self.unique_id + "arc", bp_duration, self.origin, bp_radius * 1.9, CONST_bp_height, bp_direction, bp_angle_left, bp_angle_right, "axis", "team3", "allies" );
		BadPlace_Cylinder( self.unique_id + "cyl", bp_duration, self.origin, 200, CONST_bp_height, "axis", "team3", "allies" );

		wait bp_duration + .05;
	}
}

no_treads()
{
   	if ( self isHelicopter() )
   		return true;

   	if ( self isAirplane() )
   		return true;

   	return false;
}

vehicle_treads()
{
   	if ( !isdefined( level.vehicle_treads [ self.vehicletype ] ) )
   		return;

	if ( no_treads() )
		return;

	if ( IsDefined( level.tread_override_thread ) )
	{
		self thread [[ level.tread_override_thread ]]( 	"tag_origin", "back_left", ( 160, 0, 0 ) );
		return;
	}

	// vehicles such as snowmobiles and motorcycles should only do one treadfx in the center of two tags
	singleTreadVehicles[ 0 ] = "snowmobile";
	singleTreadVehicles[ 1 ] = "snowmobile_friendly";
	singleTreadVehicles[ 2 ] = "snowmobile_player";
	singleTreadVehicles[ 3 ] = "motorcycle";
	if ( is_in_array( singleTreadVehicles, self.vehicletype ) )
	{
		self thread tread( "tag_wheel_back_left", "back_left", undefined, "tag_wheel_back_right" );
	}
	else
	{
		self thread tread( "tag_wheel_back_left", "back_left" );
		self thread tread( "tag_wheel_back_right", "back_right" );
	}
}

vehicle_kill_treads_forever()
{
	self notify( "kill_treads_forever" );
}

tread( tagname, side, relativeOffset, secondTag, fakespeed )
{
	self endon( "death" );
	treadfx = treadget( self, side );
	self endon( "kill_treads_forever" );
	for ( ;; )
	{
		speed = self Vehicle_GetSpeed();
		if ( speed == 0 )
		{
			if( isdefined( fakespeed ) )
			{
				speed = fakespeed;
			}
			else
			{
				wait 0.1;
				continue;
			}
		}
		speed *= CONST_MPHCONVERSION;
		waitTime = ( 1 / speed );
		waitTime = ( waitTime * 35 );
		if ( waitTime < 0.1 )
			waitTime = 0.1;
		else if ( waitTime > 0.3 )
			waitTime = 0.3;
		wait waitTime;
		lastfx = treadfx;
		treadfx = treadget( self, side );
		if ( treadfx != -1 )
		{
			ang = self GetTagAngles( tagname );
			forwardVec = AnglesToForward( ang );

			effectOrigin = self GetTagOrigin( tagname );

			// if two tags then use the center between the two
			if ( IsDefined( secondTag ) )
			{
				secondTagOrigin = self GetTagOrigin( secondTag );
				effectOrigin = ( effectOrigin + secondTagOrigin ) / 2;
			}

			forwardVec = vector_multiply( forwardVec, waitTime );
			upVec = AnglesToUp( ang );
			PlayFX( treadfx, effectOrigin, upVec, forwardVec );
		}
	}
}

treadget( vehicle, side )
{
	surface = self GetWheelSurface( side );
	if ( !isdefined( vehicle.vehicletype ) )
	{
		treadfx = -1;
		return treadfx;
	}

	if ( !isdefined( level._vehicle_effect[ vehicle.vehicletype ] ) )
	{
		PrintLn( "no treads setup for vehicle type: ", vehicle.vehicletype );
		wait 1;
		return - 1;
	}
	treadfx = level._vehicle_effect[ vehicle.vehicletype ][ surface ];

	if ( surface == "ice" )
		self notify( "iminwater" );

	if ( !isdefined( treadfx ) )
		treadfx = -1;

	return treadfx;
}

turret_attack_think()
{
	// chad - disable this for now, will eventually handle shooting of missiles at targets
	if ( self isHelicopter() )
		return;

	// Nathan - Turrets don't think anymore. Sorry, and your welcome.
	thread turret_shoot();
}

isStationary()
{
	type = self.vehicletype;
	if ( IsDefined( level.vehicle_isStationary[ type ] ) && level.vehicle_isStationary[ type ] )
		return true;
	else
		return false;

}

turret_shoot()
{
	type = self.vehicletype;
	self endon( "death" );
	self endon( "stop_turret_shoot" );
	index = 0;
	turrets = [];
	if ( level.vehicle_mainTurrets[ self.model ].size )
	{
		turrets = GetArrayKeys( level.vehicle_mainTurrets[ self.model ] );
	}
	while ( self.health > 0 )
	{
		self waittill( "turret_fire" );// next game remove this. just a simple fireturret command should do
		self notify( "groupedanimevent", "turret_fire" );
		if ( ! turrets.size )
			self FireWeapon();
		else
		{
			self FireWeapon( turrets[ index ] );
			index++;
			if ( index >= turrets.size )
				index = 0;
		}
	}
}

vehicle_shoot_shock()
{
	// if no shellshock is specified just get out of here.
	if ( !isdefined( level.vehicle_shoot_shock[ self.model ] ) )
		return;

	if ( GetDvar( "disable_tank_shock_minspec" ) == "1" )
		return;

	self endon( "death" );

	if ( !isdefined( level.vehicle_shoot_shock_overlay ) )
	{
		level.vehicle_shoot_shock_overlay = NewHudElem();
		level.vehicle_shoot_shock_overlay.x = 0;
		level.vehicle_shoot_shock_overlay.y = 0;
		level.vehicle_shoot_shock_overlay SetShader( "black", 640, 480 );
		level.vehicle_shoot_shock_overlay.alignX = "left";
		level.vehicle_shoot_shock_overlay.alignY = "top";
		level.vehicle_shoot_shock_overlay.horzAlign = "fullscreen";
		level.vehicle_shoot_shock_overlay.vertAlign = "fullscreen";
		level.vehicle_shoot_shock_overlay.alpha = 0;
	}

	while ( true )
	{
		self waittill( "weapon_fired" );// waits for Code notify when FireWeapon() is called.
		if ( IsDefined( self.shock_distance ) )
			shock_distance = self.shock_distance;
		else
			shock_distance = 400;

		if ( IsDefined( self.black_distance ) )
			black_distance = self.black_distance;
		else
			black_distance = 800;

		player_distance = Distance( self.origin, level.player.origin );
		if ( player_distance > black_distance )
			continue;

// 		might add this at some point, but it's so subtle now that I don't think it matters.
// 		if ( SightTracePassed( level.player GetEye(), self.origin + ( 0, 0, 64 ), false, self ) )

		level.vehicle_shoot_shock_overlay.alpha = .5;
		level.vehicle_shoot_shock_overlay FadeOverTime( 0.2 );
		level.vehicle_shoot_shock_overlay.alpha = 0;

		if ( player_distance > shock_distance )
			continue;

		if ( IsDefined( level.player.flashendtime ) && ( ( level.player.flashendtime - GetTime() ) > 200 ) )
			continue;

		fraction = player_distance / shock_distance;
		time = 4 - ( 3 * fraction );
		level.player ShellShock( level.vehicle_shoot_shock[ self.model ], time );
	}
}

vehicle_compasshandle()
{
	type = self.vehicletype;
	if ( !isdefined( level.vehicle_compassicon[ type ] ) )
		return;
	if ( !level.vehicle_compassicon[ type ] )
		return;
	self enable_vehicle_compass();
}


vehicle_setteam()
{
	type = self.vehicletype;
	if ( !isdefined( self.script_team ) && IsDefined( level.vehicle_team[ type ] ) )
		self.script_team = level.vehicle_team[ type ];
	if ( IsDefined( level.vehicle_hasname[ type ] ) )
		self thread maps\_vehiclenames::get_name();

	level.vehicles[ self.script_team ] = array_add( level.vehicles[ self.script_team ], self );
}

vehicle_handleunloadevent()
{
	self endon( "death" );
	type = self.vehicletype;
	if ( !ent_flag_exist( "unloaded" ) )
	{
		ent_flag_init( "unloaded" );
	}
}



get_vehiclenode_any_dynamic( target )
{
		// the should return undefined
		path_start = GetVehicleNode( target, "targetname" );

		if ( !isdefined( path_start ) )
		{
			path_start = GetEnt( target, "targetname" );
		}
		else if ( ishelicopter() )
		{
			PrintLn( "helicopter node targetname: " + path_start.targetname );
			PrintLn( "vehicletype: " + self.vehicletype );
			AssertMsg( "helicopter on vehicle path( see console for info )" );
		}
		if ( !isdefined( path_start ) )
		{
			path_start = getstruct( target, "targetname" );
		}
		return path_start;
}


vehicle_resumepathvehicle()
{
	if ( !self ishelicopter() )
	{
		self ResumeSpeed( 35 );
		return;
	}

	node = undefined;

	if ( IsDefined( self.currentnode.target ) )
		node = get_vehiclenode_any_dynamic( self.currentnode.target );
	if ( !isdefined( node ) )
		return;
	vehicle_paths( node );
}




setvehgoalpos_wrap( origin, bStop )
{
	if ( self.health <= 0 )
		return;
	if ( IsDefined( self.originheightoffset ) )
		origin += ( 0, 0, self.originheightoffset );// TODO - FIXME: this is temporarily set in the vehicles init_local function working on getting it this requirement removed
	self SetVehGoalPos( origin, bStop );
	//Line( self.origin, origin, (0,1,1), 1, 1, 5000 );
}

vehicle_liftoffvehicle( height )
{
	if ( !isdefined( height ) )
		height = 512;
	dest = self.origin + ( 0, 0, height );
	self SetNearGoalNotifyDist( 10 );
	self setvehgoalpos_wrap( dest, 1 );
	self waittill( "goal" );
}

waittill_stable()
{
	// wait for it to level out before unloading
	offset = 12;
	stabletime = 400;
	timer = GetTime() + stabletime;
	while ( IsDefined( self ) )
	{
		if ( abs( self.angles[ 0 ] ) > offset )
			timer = GetTime() + stabletime;
		if ( abs( self.angles[ 2 ] ) > offset )
			timer = GetTime() + stabletime;
		if ( GetTime() > timer )
			break;
		wait .05;
	}
}

littlebird_landing()
{
	self endon ( "death" );
	
	self ent_flag_init( "prep_unload" );
	self ent_flag_wait( "prep_unload" );

	self turn_unloading_drones_to_ai();

	landing_node = self get_landing_node();
	landing_node littlebird_lands_and_unloads( self );
	self vehicle_paths( landing_node );
}

get_landing_node()
{
	node = self.currentnode;
	for ( ;; )
	{
		nextnode = getent_or_struct( node.target, "targetname" );
		AssertEx( IsDefined( nextnode ), "Was looking for landing node with script_unload but ran out of nodes to look through." );
		if ( IsDefined( nextnode.script_unload ) )
			return nextnode;
		node = nextnode;
	}
}

unload_node( node )
{
	if ( IsDefined( self.ent_flag[ "prep_unload" ] ) && self ent_flag( "prep_unload" ) )
	{
		// this vehicle is already in the process of unloading
		return;
	}

	if ( IsSubStr( self.classname, "snowmobile" ) )
	{
		while ( self.veh_speed > 15 )
		{
			wait( 0.05 );
		}
	}

	if ( !isdefined( node.script_flag_wait ) && !isdefined( node.script_delay ) )
	{
		// going to stop anyway so no need to kill the path
		self notify( "newpath" );
	}

	Assert( IsDefined( self ) );
// 	self vehicle_detachfrompath();

	pathnode = GetNode( node.targetname, "target" );
	if ( IsDefined( pathnode ) && self.riders.size )
	{
		foreach ( rider in self.riders )
		{
			if ( IsAI( rider ) )
				rider thread maps\_spawner::go_to_node( pathnode );
		}
	}

	if ( self ishelicopter() )
	{
		self SetHoverParams( 0, 0, 0 );
		waittill_stable();
	}
	else
	{
		self Vehicle_SetSpeed( 0, 35 );
	}

// 	self vehicle_to_dummy	();

	if ( IsDefined( node.script_noteworthy ) )
		if ( node.script_noteworthy == "wait_for_flag" )
			flag_wait( node.script_flag );

	self vehicle_unload( node.script_unload );

	if ( maps\_vehicle_aianim::riders_unloadable( node.script_unload ) )
		self waittill( "unloaded" );

// 	self dummy_to_vehicle();

	// if we want the helis to hang around for bog_b we can do some script_magic here.
// 	wait 1; 

	if ( IsDefined( node.script_flag_wait ) || IsDefined( node.script_delay ) )
	{
		return;
	}

	if ( IsDefined( self ) )
		thread vehicle_resumepathvehicle();
}


move_turrets_here( model )
{
	typemodel = self.vehicletype + self.model;
	if ( !isdefined( self.mgturret ) )
		return;
	if ( self.mgturret.size == 0 )
		return;
	AssertEx( IsDefined( level.vehicle_mgturret[ typemodel ] ), "no turrets specified for model" );

	foreach ( i, turret in self.mgturret )
	{
		turret Unlink();
		turret LinkTo( model, level.vehicle_mgturret[ typemodel ][ i ].tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
}

vehicle_pathdetach()
{
	self.attachedpath = undefined;
	self notify( "newpath" );

	self SetGoalYaw( flat_angle( self.angles )[ 1 ] );
	self SetVehGoalPos( self.origin + ( 0, 0, 4 ), 1 );

}

vehicle_to_dummy()
{
	// create a dummy model that takes the place of a vehicle, the vehicle gets hidden
	AssertEx( !isdefined( self.modeldummy ), "Vehicle_to_dummy was called on a vehicle that already had a dummy." );
	self.modeldummy = Spawn( "script_model", self.origin );
	self.modeldummy SetModel( self.model );
	self.modeldummy.origin = self.origin;
	self.modeldummy.angles = self.angles;
	self.modeldummy UseAnimTree( #animtree );
	self Hide();
	self notify( "animtimer" );
	// move rider characters to dummy model
	self thread model_dummy_death();
	move_riders_here( self.modelDummy );
	move_turrets_here( self.modeldummy );
	move_ghettotags_here( self.modeldummy );
//	move_lights_here( self.modeldummy );
	move_effects_ent_here( self.modeldummy );
	copy_destructable_attachments( self.modeldummy );// destructables are all Attach()'d. Little bit different but not too tricky

	// flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = true;

	// helicopters do dust kickup fx
	if ( self hasHelicopterDustKickup() )
	{
		self notify( "stop_kicking_up_dust" );
		self thread aircraft_dust_kickup( self.modeldummy );
	}

	return self.modeldummy;
}

move_effects_ent_here( model )
{
	ent = deathfx_ent();
	ent Unlink();
	ent LinkTo( model );
}

model_dummy_death()
{
// delete model dummy when the vehicle is deleted.
	modeldummy = self.modeldummy;
	modeldummy endon( "death" );
	while ( IsDefined( self ) )
	{
		self waittill( "death" );
		waittillframeend;
	}
	modeldummy Delete();
}

// will get back to this if people are using vehicle to dummy..
//move_lights_here( model )
//{
//	if ( !isdefined( self.lights ) )
//		return;
//
//	lights = level.vehicle_lights_group[ self.model ][ group ];
//	
//
//	foreach ( light in lights )
//	{
//		
//		light Unlink();
//		light LinkTo( model, light.lighttag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
//	}
//}

move_ghettotags_here( model )
{

	if ( !isdefined( self.ghettotags ) )
		return;
	foreach ( ghettotag in self.ghettotags )
	{
		ghettotag Unlink();
		ghettotag LinkTo( model );

	}
}

dummy_to_vehicle()
{
	AssertEx( IsDefined( self.modeldummy ), "Tried to turn a vehicle from a dummy into a vehicle. Can only be called on vehicles that have been turned into dummies with vehicle_to_dummy." );

	if ( self isHelicopter() )
		self.modeldummy.origin = self GetTagOrigin( "tag_ground" );
	else
	{
		self.modeldummy.origin = self.origin;
		self.modeldummy.angles = self.angles;
	}

	self Show();

	// move rider characters back to the vehicle
	move_riders_here( self );
	move_turrets_here( self );
//	move_lights_here( self );
	move_effects_ent_here( self );


	// flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = false;
	self.modeldummy Delete();
	self.modeldummy = undefined;

	// helicopters do dust kickup fx
	if ( self hasHelicopterDustKickup() )
	{
		self notify( "stop_kicking_up_dust" );
		self thread aircraft_dust_kickup();
	}

	return self.modeldummy;
}

move_riders_here( base )
{
	if ( !isdefined( self.riders ) )
		return;
	riders = self.riders;
	// move rider characters to their new location
	foreach ( guy in riders )
	{
		if ( !isdefined( guy ) )
			continue;
		guy Unlink();
		animpos = maps\_vehicle_aianim::anim_pos( self, guy.vehicle_position );
		guy LinkTo( base, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
		if ( IsAI( guy ) )
			guy Teleport( base GetTagOrigin( animpos.sittag ) );
		else
			guy.origin = base GetTagOrigin( animpos.sittag );
	}
}


spawn_vehicles_from_targetname_newstyle( name )
{
	vehicles = [];
	test = GetEntArray( name, "targetname" );
	test_return = [];

	//strip out non vehicles.. 
	foreach ( v in test )
	{
		if ( !isdefined( v.code_classname ) || v.code_classname != "script_vehicle" )
			continue;
		if ( isSpawner( v ) )
			vehicles[ vehicles.size ] =  vehicle_spawn( v );
	}
	return vehicles;

}

/*
=============
///ScriptDocBegin
"Name: spawn_vehicles_from_targetname( <name> )"
"Summary: returns an array of vehicles from a spawner with that targetname value"
"Module: Vehicle"
"CallOn: Level"
"MandatoryArg: <name>: targetname of the spawners "
"Example: level.helicopters = maps\_vehicle::spawn_vehicles_from_targetname( "blackhawk" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

spawn_vehicles_from_targetname( name )
{
	vehicles = [];
	vehicles = spawn_vehicles_from_targetname_newstyle( name );
	AssertEx( vehicles.size, "No vehicle spawners had targetname " + name );
	return vehicles;
}

/*
=============
///ScriptDocBegin
"Name: spawn_vehicle_from_targetname( <name> )"
"Summary: returns a vehicle from a spawner with that targetname value."
"Module: Vehicle"
"CallOn: Level"
"MandatoryArg: <name>: targetname of the spawner "
"Example: level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

spawn_vehicle_from_targetname( name )
{
	// spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	AssertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );
	return vehicleArray[ 0 ];
}

/*
=============
///ScriptDocBegin
"Name: spawn_vehicle_from_targetname_and_drive( <name> )"
"Summary: returns a vehicle from a spawner with that targetname value and starts it on its targeted path"
"Module: Vehicle"
"CallOn: Level"
"MandatoryArg: <name>: targetname of the spawner "
"Example: level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "blackhawk" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

spawn_vehicle_from_targetname_and_drive( name )
{
	// spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	AssertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );
	thread gopath( vehicleArray[ 0 ] );
	return vehicleArray[ 0 ];
}

/*
=============
///ScriptDocBegin
"Name: spawn_vehicles_from_targetname_and_drive( <name> )"
"Summary: returns an array of vehicles from a spawner with that targetname value and starts them on their targeted path"
"Module: Vehicle"
"CallOn: Level"
"MandatoryArg: <name>: targetname of the spawners"
"Example: level.helicopters = maps\_vehicle::spawn_vehicles_from_targetname_and_drive( "blackhawk" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/


spawn_vehicles_from_targetname_and_drive( name )
{
	// spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	for ( i = 0; i < vehicleArray.size; i++ )
	foreach ( vehicle in vehicleArray )
		thread gopath( vehicle );
	return vehicleArray;
}

aircraft_dust_kickup( model )
{
	self endon( "death_finished" );
	self endon( "stop_kicking_up_dust" );

	assert( IsDefined( self.vehicletype ) );
	
	maxHeight = 1200;
	if ( isdefined( level.treadfx_maxheight ) )
		maxHeight = level.treadfx_maxheight;
		
	minHeight = 350;
	
	slowestRepeatWait = 0.15;
	fastestRepeatWait = 0.05;
	
	numFramesPerTrace = 3;
	doTraceThisFrame = numFramesPerTrace;

	defaultRepeatRate = 1.0;
	if ( self isAirplane() )
		defaultRepeatRate = 0.15;

	repeatRate = defaultRepeatRate;

	trace = undefined;
	d = undefined;

	trace_ent = self;
	if ( IsDefined( model ) )
		trace_ent = model;

	while ( IsDefined( self ) )
	{
		if ( isdefined( level.skip_treadfx ) )
			return true;
			
		if ( repeatRate <= 0 )
		repeatRate = defaultRepeatRate;
		wait repeatRate;

		if ( !isdefined( self ) )
			return;

		doTraceThisFrame--;

		// prof_begin( "aircraft_dust_kickup" );

		if ( doTraceThisFrame <= 0 )
		{
			doTraceThisFrame = numFramesPerTrace;

			trace = BulletTrace( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ), false, trace_ent );

			/#
			//if ( IsDefined( trace ) && IsDefined( trace[ "position" ] ) )
			//	thread draw_line_for_time( trace_ent.origin, trace[ "position" ], 1, 0, 0, 2.0 );
			#/

			/* 
			trace[ "entity" ]
			trace[ "fraction" ]
			trace[ "normal" ]
			trace[ "position" ]
			trace[ "surfacetype" ]
			*/ 

			d = Distance( trace_ent.origin, trace[ "position" ] );

			repeatRate = ( ( d - minHeight ) / ( maxHeight - minHeight ) ) * ( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait;
		}

		if ( !isdefined( trace ) )
			continue;

		Assert( IsDefined( d ) );

		if ( d > maxHeight )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}

		if ( IsDefined( trace[ "entity" ] ) )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}

		if ( !isdefined( trace[ "position" ] ) )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}

		if ( !isdefined( trace[ "surfacetype" ] ) )
			trace[ "surfacetype" ] = "dirt";

		//iprintln( "surface: " + trace[ "surfacetype" ] );

		AssertEx( IsDefined( level._vehicle_effect[ self.vehicletype ] ), self.vehicletype + " vehicle script hasn't run _tradfx properly" );
		AssertEx( IsDefined( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] ), "UNKNOWN SURFACE TYPE: " + trace[ "surfacetype" ] );

		// prof_end( "aircraft_dust_kickup" );

		if ( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] != -1 )
		{
			PlayFX( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ], trace[ "position" ] );
			//Print3d( trace[ "position" ], trace[ "surfacetype" ], (0,1,0), 1, 1.1, 150 );
		}
		else
		{
			//Print3d( trace[ "position" ], trace[ "surfacetype" ], (1,0,0), 1, 1.1, 150 );
		}
	}
}

tank_crush( crushedVehicle, endNode, tankAnim, truckAnim, animTree, soundAlias )
{
	// Chad G's tank crushing vehicle script. Self corrects for node positioning errors.

	Assert( IsDefined( crushedVehicle ) );
	Assert( IsDefined( endNode ) );
	Assert( IsDefined( tankAnim ) );
	Assert( IsDefined( truckAnim ) );
	Assert( IsDefined( animTree ) );



	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Create an animatable tank and move the real tank to the next path and store required info
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	animatedTank = vehicle_to_dummy();
	self Vehicle_SetSpeed( 7, 5, 5 );


	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Total time for animation, and correction and uncorrection times
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	animLength = GetAnimLength( tankAnim );
	move_to_time = ( animLength / 3 );
	move_from_time = ( animLength / 3 );



	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Node information used for calculating both starting and ending points for the animation
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	// get node vecs
	node_origin = crushedVehicle.origin;
	node_angles = crushedVehicle.angles;
	node_forward = AnglesToForward( node_angles );
	node_up = AnglesToUp( node_angles );
	node_right = AnglesToRight( node_angles );



	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Calculate Starting Point for the animation from crushedVehicle and create the dummy
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	// get anim starting point origin and angle
	anim_start_org = GetStartOrigin( node_origin, node_angles, tankAnim );
	anim_start_ang = GetStartAngles( node_origin, node_angles, tankAnim );

	// get anim starting point vecs
	animStartingVec_Forward = AnglesToForward( anim_start_ang );
	animStartingVec_Up = AnglesToUp( anim_start_ang );
	animStartingVec_Right = AnglesToRight( anim_start_ang );

	// get tank vecs
	tank_Forward = AnglesToForward( animatedTank.angles );
	tank_Up = AnglesToUp( animatedTank.angles );
	tank_Right = AnglesToRight( animatedTank.angles );

	// spawn dummy with appropriate offset
	offset_Vec = ( node_origin - anim_start_org );
	offset_Forward = VectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = VectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = VectorDot( offset_Vec, animStartingVec_Right );
	dummy = Spawn( "script_origin", animatedTank.origin );
	dummy.origin += vector_multiply( tank_Forward, offset_Forward );
	dummy.origin += vector_multiply( tank_Up, offset_Up );
	dummy.origin += vector_multiply( tank_Right, offset_Right );

	// set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = AnglesToForward( node_angles );
	offset_Forward = VectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = VectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = VectorDot( offset_Vec, animStartingVec_Right );
	dummyVec = vector_multiply( tank_Forward, offset_Forward );
	dummyVec += vector_multiply( tank_Up, offset_Up );
	dummyVec += vector_multiply( tank_Right, offset_Right );
	dummy.angles = VectorToAngles( dummyVec );



	// -- -- -- -- -- -- -- -- -- -- - 
	// Debug Lines
	// -- -- -- -- -- -- -- -- -- -- - 
	/#
	if ( GetDvar( "debug_tankcrush" ) == "1" )
	{
		// line to where tank1 is
		thread draw_line_from_ent_for_time( level.player, animatedTank.origin, 1, 0, 0, animLength / 2 );

		// line to where tank1 SHOULD be
		thread draw_line_from_ent_for_time( level.player, anim_start_org, 0, 1, 0, animLength / 2 );

		// line to the dummy
		thread draw_line_from_ent_to_ent_for_time( level.player, dummy, 0, 0, 1, animLength / 2 );
	}
	#/


	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Animate the animatable tank and self correct into the crushed vehicle
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	if ( IsDefined( soundAlias ) )
		level thread play_sound_in_space( soundAlias, node_origin );

	animatedTank LinkTo( dummy );
	crushedVehicle UseAnimTree( animTree );
	animatedTank UseAnimTree( animTree );

	Assert( IsDefined( level._vehicle_effect[ "tankcrush" ][ "window_med" ] ) );
	Assert( IsDefined( level._vehicle_effect[ "tankcrush" ][ "window_large" ] ) );

	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_left_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.2 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_right_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.4 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_back_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 0.7 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_front_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 1.5 );

	crushedVehicle AnimScripted( "tank_crush_anim", node_origin, node_angles, truckAnim );
	animatedTank AnimScripted( "tank_crush_anim", dummy.origin, dummy.angles, tankAnim );

	dummy MoveTo( node_origin, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
	dummy RotateTo( node_angles, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
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
	// anim_end_org = anim_start_org + GetMoveDelta( tankAnim, 0, 1 );
	temp = Spawn( "script_model", ( anim_start_org ) );
	temp.angles = anim_start_ang;
	anim_end_org = temp LocalToWorldCoords( GetMoveDelta( tankAnim, 0, 1 ) );
	anim_end_ang = anim_start_ang + ( 0, GetAngleDelta( tankAnim, 0, 1 ), 0 );
	temp Delete();

	// get anim ending point vecs
	animEndingVec_Forward = AnglesToForward( anim_end_ang );
	animEndingVec_Up = AnglesToUp( anim_end_ang );
	animEndingVec_Right = AnglesToRight( anim_end_ang );

	// get ending tank pos vecs
	attachPos = self GetAttachPos( endNode );
	tank_Forward = AnglesToForward( attachPos[ 1 ] );
	tank_Up = AnglesToUp( attachPos[ 1 ] );
	tank_Right = AnglesToRight( attachPos[ 1 ] );

	// see what the dummy's final origin will be
	offset_Vec = ( node_origin - anim_end_org );
	offset_Forward = VectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = VectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = VectorDot( offset_Vec, animEndingVec_Right );
	dummy.final_origin = attachPos[ 0 ];
	dummy.final_origin += vector_multiply( tank_Forward, offset_Forward );
	dummy.final_origin += vector_multiply( tank_Up, offset_Up );
	dummy.final_origin += vector_multiply( tank_Right, offset_Right );

	// set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = AnglesToForward( node_angles );
	offset_Forward = VectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = VectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = VectorDot( offset_Vec, animEndingVec_Right );
	dummyVec = vector_multiply( tank_Forward, offset_Forward );
	dummyVec += vector_multiply( tank_Up, offset_Up );
	dummyVec += vector_multiply( tank_Right, offset_Right );
	dummy.final_angles = VectorToAngles( dummyVec );

	// -- -- -- -- -- -- -- -- -- -- - 
	// Debug Lines
	// -- -- -- -- -- -- -- -- -- -- - 
	if ( GetDvar( "debug_tankcrush" ) == "1" )
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

	dummy MoveTo( dummy.final_origin, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	dummy RotateTo( dummy.final_angles, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	wait move_from_time;



	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Tank is done animating now, remove the animatable tank and show the real one( they should be perfectly aligned now )
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	self DontInterpolate();
	self AttachPath( endNode );
	dummy_to_vehicle();
}

tank_crush_fx_on_tag( tagName, fxName, soundAlias, startDelay )
{
	if ( IsDefined( startDelay ) )
		wait startDelay;
	PlayFXOnTag( fxName, self, tagName );
	if ( IsDefined( soundAlias ) )
		self thread play_sound_on_tag( soundAlias, tagName );
}

loadplayer( position, animfudgetime )
{
	/#
	SetDvarIfUninitialized( "fastrope_arms", "0" );
	#/

	if ( !isdefined( animfudgetime ) )
		animfudgetime = 0;
	Assert( IsDefined( self.riders ) );
	Assert( self.riders.size );
	guy = undefined;
	foreach ( rider in self.riders )
	{
		if ( rider.vehicle_position == position )
		{
			guy = rider;
			guy.drone_delete_on_unload = true;
			guy.playerpiggyback = true;
			break;
		}
	}

	AssertEx( !isai( guy ), "guy in position of player needs to have script_drone set, use script_startingposition ans script drone in your map" );
	Assert( IsDefined( guy ) );
	thread show_rigs( position );
	animpos = maps\_vehicle_aianim::anim_pos( self, position );

// 	guy StopAnimScripted();
// 	guy StopUseAnimTree();
	guy notify( "newanim" );
	guy DetachAll();
// 	guy SetModel( "" );
	guy SetModel( "fastrope_arms" );
	guy UseAnimTree( animpos.player_animtree );
	thread maps\_vehicle_aianim::guy_idle( guy, position );
	// PlayerLinkToDelta( <linkto entity> , <tag> , <viewpercentag fraction> , <right arc> , <left arc> , <top arc> , <bottom arc> )
	level.player PlayerLinkToDelta( guy, "tag_player", 1.0, 40, 18, 30, 30 );

	// level.player SetPlayerAngles( guy GetTagAngles( "tag_player" ) );

	// level.player AllowCrouch( false );
	// level.player AllowProne( false );
	// level.player AllowStand( true );

	guy Hide();

	animtime = GetAnimLength( animpos.getout );
	animtime -= animfudgetime;
	self waittill( "unloading" );

	/#

	if ( GetDvar( "fastrope_arms" ) != "0" )
		guy Show();
	#/

	level.player DisableWeapons();
// 	guy waittill( "jumpedout" );

	guy NotSolid();

	wait animtime;

	level.player Unlink();
	level.player EnableWeapons();
	// level.player AllowCrouch( true );
	// level.player AllowProne( true );
}

show_rigs( position )
{
	wait .01;
	self thread maps\_vehicle_aianim::getout_rigspawn( self, position );// spawn the getoutrig for this position
	if ( !self.riders.size )
		return;
	foreach ( rider in self.riders )
		self thread maps\_vehicle_aianim::getout_rigspawn( self, rider.vehicle_position );
}

turret_deleteme( turret )
{
	if ( IsDefined( self ) )
		if ( IsDefined( turret.deletedelay ) )
			wait turret.deletedelay;
	if ( IsDefined( turret ) )
		turret Delete();
}


/*
=============
///ScriptDocBegin
"Name: vehicle_wheels_forward()"
"Summary: change the direction of the wheel animation on a vehicle to forward."
"Module: Vehicle"
"CallOn: A Vehicle"
"Example: vehicle vehicle_wheels_forward()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_wheels_forward()
{
	wheeldirectionchange( 1 );
}

/*
=============
///ScriptDocBegin
"Name: vehicle_wheels_backward()"
"Summary: change the direction of the wheel animation on a vehicle to backward."
"Module: Vehicle"
"CallOn: A Vehicle"
"Example: vehicle vehicle_wheels_backward()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_wheels_backward()
{
	wheeldirectionchange( 0 );
}

wheeldirectionchange( direction )
{
	if ( direction <= 0 )
		self.wheeldir = 0;
	else
		self.wheeldir = 1;
}

maingun_FX()
{
	if ( !isdefined( level.vehicle_deckdust[ self.model ] ) )
		return;
	self endon( "death" );
	while ( true )
	{
		self waittill( "weapon_fired" );// waits for Code notify when FireWeapon() is called.
		PlayFXOnTag( level.vehicle_deckdust[ self.model ], self, "tag_engine_exhaust" );
		barrel_origin = self GetTagOrigin( "tag_flash" );
		ground = PhysicsTrace( barrel_origin, barrel_origin + ( 0, 0, -128 ) );
		PhysicsExplosionSphere( ground, 192, 100, 1 );
	}
}

playTankExhaust()
{
	self endon( "death" );
	if ( !isdefined( level.vehicle_exhaust[ self.model ] ) )
		return;

	exhaustDelay = 0.1;
	while ( IsDefined( self ) )
	{
		if ( !isdefined( self ) )
			return;
		if ( !isalive( self ) )
			return;
		PlayFXOnTag( level.vehicle_exhaust[ self.model ], self, "tag_engine_exhaust" );
		wait exhaustDelay;
	}
}

/* 
============= 
///ScriptDocBegin
"Name: build_light( <model> , <name> , <tag> , <effect> , <group> , <delay> )"
"Summary: contstruct a light fx to play on a vehicle tag, see lights_on lights_off"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: An entity"
"MandatoryArg: <model> : Name of model that you are building the light for"
"MandatoryArg: <name> : Unique name used for grouping"
"MandatoryArg: <tag> : Tag to play the light effect on"
"MandatoryArg: <effect> : the effect"
"MandatoryArg: <group> : Group is used for lights_on lights_off"
"MandatoryArg: <delay> : Used to offset the timing of this light so they don't all start at the same time"
"Example: build_light( model, "taillight_R", 	"TAG_REAR_LIGHT_RIGHT", 	"misc/car_taillight_btr80", 		"running", 	0.1 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_light( model, name, tag, effect, group, delay )
{
	if ( !isdefined( level.vehicle_lights ) )
		level.vehicle_lights = [];
	if ( !isdefined( level.vehicle_lights_group_override ) )
		level.vehicle_lights_group_override = [];
	if ( IsDefined( level.vehicle_lights_group_override[ group ] ) && !level.vtoverride )
		return;// this light group has been overwritten and shouldn't be set.

	struct = SpawnStruct();
	struct.name = name;
	struct.tag = tag;
	struct.delay = delay;
	struct.effect = _loadfx( effect );

	level.vehicle_lights[ model ][ name ] = struct;

	group_light( model, name, "all" );
	if ( IsDefined( group ) )
		group_light( model, name, group );
		
}

/* 
============= 
///ScriptDocBegin
"Name: build_light_override( <type>, <model> , <name> , <tag> , <effect> , <group> , <delay> )"
"Summary: contstruct a light fx override to play on a vehicle tag, see lights_on lights_off."
"Module: vehicle_build( vehicle.gsc )"
"CallOn: An entity"
"MandatoryArg: <type> : vehicletype of model that you are building the light for"
"MandatoryArg: <model> : Name of model that you are building the light for"
"MandatoryArg: <name> : Unique name used for grouping"
"MandatoryArg: <tag> : Tag to play the light effect on"
"MandatoryArg: <effect> : the effect"
"MandatoryArg: <group> : Group is used for lights_on lights_off"
"MandatoryArg: <delay> : Used to offset the timing of this light so they don't all start at the same time"
"Example: build_light_override( "btr80", "vehicle_btr80", "spotlight", 		"TAG_FRONT_LIGHT_RIGHT", "misc/spotlight_btr80_daytime", 	"spotlight", 			0.2 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 


build_light_override( type, model, name, tag, effect, group, delay )
{
	level.vttype = type;
	level.vtmodel = type;
	level.vtoverride = true;
	build_light( model, name, tag, effect, group, delay );
	level.vtoverride = false;
	level.vehicle_lights_group_override[ group ] = true;
}

group_light( model, name, group )
{
	if ( !isdefined( level.vehicle_lights_group ) )
		level.vehicle_lights_group = [];
	if ( !isdefined( level.vehicle_lights_group[ model ] ) )
		level.vehicle_lights_group[ model ] = [];
	if ( !isdefined( level.vehicle_lights_group[ model ][ group ] ) )
		level.vehicle_lights_group[ model ][ group ] = [];
	foreach( lightgroup_name in level.vehicle_lights_group[ model ][ group ] )
		if( name == lightgroup_name )
			return; // this group has already been defined. supporting overrides post precache script. this part doesn't need to be overwritten.
	level.vehicle_lights_group[ model ][ group ][ level.vehicle_lights_group[ model ][ group ].size ] = name;
}

lights_on( group )
{
	groups = StrTok( group, " " );
	array_levelthread( groups, ::lights_on_internal );
}

lights_delayfxforframe()
{
	level notify( "new_lights_delayfxforframe" );
	level endon( "new_lights_delayfxforframe" );

	if ( !isdefined( level.fxdelay ) )
		level.fxdelay = 0;

	level.fxdelay += RandomFloatRange( 0.2, 0.4 );

	if ( level.fxdelay > 2 )
		level.fxdelay = 0;

	wait 0.05;

	level.fxdelay = undefined;


}

lights_on_internal( group )
{
	level.lastlighttime = GetTime();
	if ( !isdefined( group ) )
		group = "all";

	if ( !isDefined( level.vehicle_lights_group[ self.model ] )
			 || !isdefined( level.vehicle_lights_group[ self.model ][ group ] )
		 )
		return;
	thread lights_delayfxforframe();
	if ( !isdefined( self.lights ) )
		self.lights = [];
	lights = level.vehicle_lights_group[ self.model ][ group ];

	count = 0;

	delayoffsetter = [];
	for ( i = 0; i < lights.size; i++ )
	{
		if ( IsDefined( self.lights[ lights[ i ] ] ) )
			continue;// light is already on

		template = level.vehicle_lights[ self.model ][ lights[ i ] ];

		if ( IsDefined( template.delay ) )
			delay = template.delay;
		else
			delay = 0;

		while ( IsDefined( delayoffsetter[ "" + delay ] ) )
			delay += .05;// don't start these on the same frame.

		delay += level.fxdelay;

		delayoffsetter[ "" + delay ] = true;

		//pass the endon death to noself_delaycall
	 	self endon( "death" );
		childthread noself_delayCall( delay, ::playfxontag, template.effect, self, template.tag );

		self.lights[ lights[ i ] ] = true;
		if ( !isdefined( self ) )
			break;

	}
	level.fxdelay = false;

}


deathfx_ent()
{
	if ( !isdefined( self.deathfx_ent ) )
	{
		ent = Spawn( "script_model", ( 0, 0, 0 ) );
		emodel = get_dummy();
		ent SetModel( self.model );
		ent.origin = emodel.origin;
		ent.angles = emodel.angles;
		ent NotSolid();
		ent Hide();
		ent LinkTo( emodel );
		self.deathfx_ent = ent;
	}
	else
		self.deathfx_ent SetModel( self.model );
	return self.deathfx_ent;
}

lights_off( group, model )
{
	groups = StrTok( group, " ", model );
	array_levelthread( groups, ::lights_off_internal, model );
}


lights_off_internal( group, model )
{
	if ( !isdefined( model ) )
		model = self.model;
	if ( !isdefined( group ) )
		group = "all";
	if ( !isdefined( self.lights ) )
		return;
	if ( !isdefined( level.vehicle_lights_group[ model ][ group ] ) )
	{
		PrintLn( "vehicletype: " + self.vehicletype );
		PrintLn( "light group: " + group );
		AssertMsg( "lights not defined for this vehicle( see console" );
	}
	lights = level.vehicle_lights_group[ model ][ group ];

	count = 0;
	for ( i = 0;i < lights.size;i++ )
	{
		template = level.vehicle_lights[ model ][ lights[ i ] ];
		StopFXOnTag( template.effect, self, template.tag );


		count++;
		if ( count > 2 )
		{
			count = 0;
			wait .05;// hackin around lights limitations.. seee BUGZILLA 87770
		}

		//handle delete while shutting of lights. 
		if ( !isdefined( self ) )
			return;

		self.lights[ lights[ i ] ] = undefined;
	}

}

/* 
============= 
///ScriptDocBegin
"Name: build_deathmodel( <model> , <deathmodel> )"
"Summary: called in individual vehicle file - assigns death model to vehicles with this model. "
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <model> : name of model to associate death model"
"OptionalArg: <deathmodel> : name of death model to be associated with model"
"OptionalArg: <swapDelay> : number of seconds to wait before setting the death model after the vehicle dies. Defaults to 0"
"Example: build_deathmodel( "bmp", "bmp_destroyed" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_deathmodel( model, deathmodel, swapDelay )
{
	if ( model != level.vtmodel )
		return;
	if ( !isdefined( deathmodel ) )
		deathmodel = model;
	PreCacheModel( model );
	PreCacheModel( deathmodel );
	level.vehicle_deathmodel[ model ] = deathmodel;
	if ( !isdefined( swapDelay ) )
		swapDelay = 0;
	level.vehicle_deathmodel_delay[ model ] = swapDelay;
}


/* 
============= 
///ScriptDocBegin
"Name: build_shoot_shock( <shock> )"
"Summary: called in individual vehicle file - assigns shock file to be played when main cannon on a tank fires "
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <shock> : the shock asset"
"Example: build_shoot_shock( "tankblast" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_shoot_shock( shock )
{
	// shock script uses "black" hudelem or something. I don't know . Just had to move it out of _m1a1.gsc
	PreCacheShader( "black" );
	PreCacheShellShock( shock );
	level.vehicle_shoot_shock[ level.vtmodel ] = shock;
}

/* 
============= 
///ScriptDocBegin
"Name: build_idle( animation )"
"Summary: called in individual vehicle file - assigns animations to be used on vehicles"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <animation> : animation"
"Example: build_idle( %abrams_idle );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_idle( animation )
{
	
	if( !isdefined( level.vehicle_IdleAnim ) )
		level.vehicle_IdleAnim = [];
	if( !isdefined( level.vehicle_IdleAnim[ level.vtmodel ] ) )
		level.vehicle_IdleAnim[ level.vtmodel ] = [];
	level.vehicle_IdleAnim[ level.vtmodel ][level.vehicle_IdleAnim[ level.vtmodel ].size] = animation;
}

/* 
============= 
///ScriptDocBegin
"Name: build_drive( <forward> , <reverse> , <normalspeed> , <rate> )"
"Summary: called in individual vehicle file - assigns animations to be used on vehicles"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <forward> : forward animation"
"OptionalArg: <reverse> : reverse animation"
"OptionalArg: <normalspeed> : speed at which animation will be played at 1x defaults to 10mph"
"OptionalArg: <rate> : scales speed of animation( please only use this for testing )"
"Example: build_drive( %abrams_movement, %abrams_movement_backwards, 10 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_drive( forward, reverse, normalspeed, rate )
{
	if ( !isdefined( normalspeed ) )
		normalspeed = 10;
	level.vehicle_DriveIdle[ level.vtmodel ] = forward;

	if ( IsDefined( reverse ) )
		level.vehicle_DriveIdle_r[ level.vtmodel ] = reverse;
	level.vehicle_DriveIdle_normal_speed[ level.vtmodel ] = normalspeed;
	if ( IsDefined( rate ) )
		level.vehicle_DriveIdle_animrate[ level.vtmodel ] = rate;
}

/* 
============= 
///ScriptDocBegin
"Name: build_template( <type> , <model> , <typeoverride> )"
"Summary: called in individual vehicle file - mandatory to call this in all vehicle files at the top!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <type> : vehicle type to set"
"MandatoryArg: <model> : model to set( this is usually generated by the level script )"
"OptionalArg: <typeoverride> : this overrides the type, used for copying a vehicle script"
"Example: build_template( "bmp", model, type );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_template( type, model, typeoverride )
{
	if ( IsDefined( typeoverride ) )
		type = typeoverride;
	typemodel = type + model;
	PrecacheVehicle( type );

	if ( !isdefined( level.vehicle_death_fx ) )
		level.vehicle_death_fx = [];
	if ( 	!isdefined( level.vehicle_death_fx[ typemodel ] ) )
		level.vehicle_death_fx[ typemodel ] = [];// can have overrides


	level.vehicle_compassicon[ type ] = false;
	level.vehicle_team[ type ] = "axis";
	level.vehicle_life[ type ] = 999;
	level.vehicle_hasMainTurret[ model ] = false;
	level.vehicle_mainTurrets[ model ] = [];
	level.vtmodel = model;
	level.vttype = type;
}

/* 
============= 
///ScriptDocBegin
"Name: build_exhaust( <exhaust_effect_str> )"
"Summary: called in individual vehicle file - assign an exhaust effect to this vehicle!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <exhaust_effect_str> : exhaust effect in string format"
"Example: build_exhaust( "distortion/abrams_exhaust" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_exhaust( effect )
{
	level.vehicle_exhaust[ level.vtmodel ] = _loadfx( effect );
}

/* 
============= 
///ScriptDocBegin
"Name: build_treadfx()"
"Summary: called in individual vehicle file - enables treadfx"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"Example: build_treadfx();"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_treadfx( type )
{
	if ( ! IsDefined( type ) )
		type = level.vttype;
	maps\_treadfx::main( type );
}

/* 
============= 
///ScriptDocBegin
"Name: build_team( <team> )"
"Summary: called in individual vehicle file - sets team"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <team> : team"
"Example: build_team( "allies" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_team( team )
{
	level.vehicle_team[ level.vttype ] = team;
}

/* 
============= 
///ScriptDocBegin
"Name: build_mainturret( <firetime> , <tag1> , <tag2> , <tag3> , <tag4> )"
"Summary: called in individual vehicle file - enables main( cannon ) turret"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"OptionalArg: <tag1> : additional tags to fire from"
"OptionalArg: <tag2> : additional tags to fire from"
"OptionalArg: <tag3> : additional tags to fire from"
"OptionalArg: <tag4> : additional tags to fire from"
"Example: build_mainturret();"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_mainturret( tag1, tag2, tag3, tag4 )
{
	level.vehicle_hasMainTurret[ level.vtmodel ] = true;
	if ( IsDefined( tag1 ) )
		level.vehicle_mainTurrets[ level.vtmodel ][ tag1 ] = true;
	if ( IsDefined( tag2 ) )
		level.vehicle_mainTurrets[ level.vtmodel ][ tag2 ] = true;
	if ( IsDefined( tag3 ) )
		level.vehicle_mainTurrets[ level.vtmodel ][ tag3 ] = true;
	if ( IsDefined( tag4 ) )
		level.vehicle_mainTurrets[ level.vtmodel ][ tag4 ] = true;

}

/*
=============
///ScriptDocBegin
"Name: build_bulletshield( <bShield> )"
"Summary: Set script toggleable bullet shield on a vehicle. must enable bullet damage on the vehicletype asset first."
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <bShield>: set default enable or disable shield on vehicle "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_bulletshield( bShield )
{
	Assert( IsDefined( bShield ) );
	level.vehicle_bulletshield[ level.vttype ] = bShield;
}

/*
=============
///ScriptDocBegin
"Name: build_grenadeshield( <bShield> )"
"Summary: Set script toggleable grenade shield on a vehicle. must enable grenade damage on the vehicletype asset first."
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <bShield>: set default enable or disable shield on vehicle "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_grenadeshield( bShield )
{
	Assert( IsDefined( bShield ) );
	level.vehicle_grenadeshield[ level.vttype ] = bShield;
}




/* 
============= 
///ScriptDocBegin
"Name: build_aianims( <aithread> , <vehiclethread> )"
"Summary: called in individual vehicle file - set threads for ai animation and vehicle animation assignments"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <aithread> : ai thread"
"OptionalArg: <vehiclethread> : vehicle thread"
"Example: build_aianims( ::setanims, ::set_vehicle_anims );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_aianims( aithread, vehiclethread )
{
	level.vehicle_aianims[ level.vttype ] = [[ aithread ]]();
	if ( IsDefined( vehiclethread ) )
		level.vehicle_aianims[ level.vttype ] = [[ vehiclethread ]]( level.vehicle_aianims[ level.vttype ] );
}



/* 
============= 
///ScriptDocBegin
"Name: build_frontarmor( <armor> )"
"Summary: called in individual vehicle file - sets percentage of health to regen on attacks from the front"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <armor> : ercentage of health to regen on attacks from the front"
"Example: build_frontarmor( .33 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_frontarmor( armor )
{
	level.vehicle_frontarmor [ level.vttype ] = armor;
}

build_hidden_riders_until_unload()
{
	level.hidden_riders_until_unload [ level.vttype ] = true;
}

/* 
============= 
///ScriptDocBegin
"Name: build_attach_models( <modelsthread> )"
"Summary: called in individual vehicle file - thread for building attached models( ropes ) with animation"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <modelsthread> : thread"
"Example: build_attach_models( ::set_attached_models );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_attach_models( modelsthread )
{
	level.vehicle_attachedmodels[ level.vttype ] = [[ modelsthread ]]();;
}

/* 
============= 
///ScriptDocBegin
"Name: build_unload_groups( <unloadgroupsthread> )"
"Summary: called in individual vehicle file - thread for building unload groups"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <modelsthread> : thread"
"Example: build_unload_groups( ::Unload_Groups );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_unload_groups( unloadgroupsthread )
{
	level.vehicle_unloadgroups[ level.vttype ] = [[ unloadgroupsthread ]]();
}

/* 
============= 
///ScriptDocBegin
"Name: build_life( <health> , <minhealth> , <maxhealth> , )"
"Summary: called in individual vehicle file - sets health for vehicles"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <health> :  health"
"OptionalArg: <minhealth> : randomly chooses between the minhealth, maxhealth"
"OptionalArg: <maxhealth> : randomly chooses between the minhealth, maxhealth"
"Example: build_life( 999, 500, 1500 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_life( health, minhealth, maxhealth )
{
	level.vehicle_life[ level.vttype ] = health;
	level.vehicle_life_range_low[ level.vttype ] = minhealth;
	level.vehicle_life_range_high[ level.vttype ] = maxhealth;
}

/* 
============= 
///ScriptDocBegin
"Name: build_compassicon( <type>, <enable> )"
"Summary: called in individual vehicle file - enables vehicle on the compass with the icontype set to the type. defaults to enabled"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <compasstype> :  valid types - automobile,tank,plane,helicopter "
"OptionalArg: <enable> : defaults to true, set to false to disable vehicle on compass"
"Example: build_compassicon( "automobile", false );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_compassicon( compasstype, enabled )
{
	Assert( IsDefined( compasstype ) );

	if ( !isdefined( enabled ) )
		enabled = false;

	level.vehicle_compassicon[ level.vttype ] = enabled;
	level.vehicle_compass_types[ level.vttype ] = compassType;
}

/* 
============= 
///ScriptDocBegin
"Name: build_deckdust( <effect> )"
"Summary: called in individual vehicle file - sets a deckdust effect on a vehicle?"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <effect> :  effect to be assigned as deckdust"
"Example: build_deckdust( "dust/abrams_desk_dust" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_deckdust( effect )
{
	level.vehicle_deckdust[ level.vtmodel ] = _loadfx( effect );
}

/* 
============= 
///ScriptDocBegin
"Name: build_destructible( <model> , <destructible> )"
"Summary: called in individual vehicle file: asigns destructible type to model."
"Module: vehicle_build( vehicle.gsc )"
"CallOn: level "
"MandatoryArg: <model> : vehicles placed in radiant with this model will be asigned the destructible( see _destructible_types.gsc )"
"OptionalArg: <destructible> : the destructible type to asign"
"Example: build_destructible( "vehicle_bm21_mobile_bed_destructible", "vehicle_bm21_mobile_bed" );
"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_destructible( model, destructible )
{
	if ( IsDefined( level.vehicle_csv_export ) )
		return;

	Assert( IsDefined( model ) );
	Assert( IsDefined( destructible ) );
	if ( model != level.vtmodel )
		return;
	struct = SpawnStruct();
	passer = SpawnStruct();
	passer.model = model;//

	struct.destuctableInfo = passer common_scripts\_destructible_types::makeType( destructible );;
	struct thread common_scripts\_destructible::precache_destructibles();
	struct thread common_scripts\_destructible::add_destructible_fx();

	level.destructible_model[ level.vtmodel ] = destructible;
}

/* 
============= 
///ScriptDocBegin
"Name: build_localinit( <init_thread> )"
"Summary: called in individual vehicle file - mandatory for all vehicle files, this sets the individual init thread for those special sequences, it is also used to determine that a vehicle is being precached or not"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <init_thread> :  local thread to the vehicle to be called when it spawns"
"Example: build_localinit( ::init_local );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

build_localinit( init_thread )
{
	level.vehicleInitThread[ level.vttype ][ level.vtmodel ] = init_thread;
}

get_from_spawnstruct( target )
{
	return getstruct( target, "targetname" );
}

get_from_entity( target )
{
	ent = GetEntArray( target, "targetname" );
	if ( IsDefined( ent ) && ent.size > 0 )
		return ent[ RandomInt( ent.size ) ];
	return undefined;
}

get_from_spawnstruct_target( target )
{
	return getstruct( target, "target" );
}

get_from_entity_target( target )
{
	return GetEnt( target, "target" );
}

get_from_vehicle_node( target )
{
	return GetVehicleNode( target, "targetname" );
}

set_lookat_from_dest( dest )
{
	viewTarget = GetEnt( dest.script_linkto, "script_linkname" );

	// temp fix for an issue with Hunted
	// I use script_linktos as well but for some other purpose.
	// I don't have the time to fix this propper now.
	if ( !isdefined( viewTarget ) || level.script == "hunted" )
		return;

	self SetLookAtEnt( viewTarget );
	self.set_lookat_point = true;
}

get_deletegroups( script_vehiclegroupdelete )
{
	deletegroups = [];
	vehicles = GetEntArray( "script_vehicle", "code_classname" );
	foreach ( vehicle in vehicles )
	{
		if ( !isdefined( vehicle.script_vehicleGroupDelete )
			 || vehicle.script_vehicleGroupDelete != script_vehiclegroupdelete
			 )
			continue;
		deletegroups[ deletegroups.size ] = vehicle;
	}
	return deletegroups;
}


damage_hint_bullet_only()
{

	level.armorDamageHints = false;
	self.displayingDamageHints = false;
	self thread damage_hints_cleanup();

	while ( IsDefined( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if ( !isplayer( attacker ) )
			continue;
		if( isdefined( self.has_semtex_on_it ) )
			continue;

		type = ToLower( type );

		switch( type )
		{
			case "mod_pistol_bullet":
			case "mod_rifle_bullet":
			case "bullet":
				if ( !level.armorDamageHints )
				{
					if( isdefined( level.thrown_semtex_grenades ) && level.thrown_semtex_grenades > 0 ) 
						break;
						
					level.armorDamageHints = true;
					self.displayingDamageHints = true;
					attacker display_hint( "invulerable_bullets" );
					wait( 4 );
					level.armorDamageHints = false;
					self.displayingDamageHints = false;
					break;
				}
		}
	}
}

damage_hints()
{

	level.armorDamageHints = false;
	self.displayingDamageHints = false;
	self thread damage_hints_cleanup();

	while ( IsDefined( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if ( !isplayer( attacker ) )
			continue;
		if( isdefined( self.has_semtex_on_it ) )
			continue;

		type = ToLower( type );

		switch( type )
		{
			case "mod_grenade":
			case "mod_grenade_splash":
			case "mod_pistol_bullet":
			case "mod_rifle_bullet":
			case "bullet":
				if ( !level.armorDamageHints )
				{
					if( isdefined( level.thrown_semtex_grenades ) && level.thrown_semtex_grenades > 0 ) 
						break;
						
					level.armorDamageHints = true;
					self.displayingDamageHints = true;
					if( ( type == "mod_grenade" ) || ( type == "mod_grenade_splash" ) )
						attacker display_hint( "invulerable_frags" );
					else
						attacker display_hint( "invulerable_bullets" );
					wait( 4 );
					level.armorDamageHints = false;
					self.displayingDamageHints = false;
					break;
				}
		}
	}
}

damage_hints_cleanup()
{
	self waittill( "death" );
	if ( self.displayingDamageHints )
		level.armorDamageHints = false;
}

copy_destructable_attachments( modeldummy )
{
	// does all attachments
	attachedModelCount = self GetAttachSize();
	attachedModels = [];
	for ( i = 0 ; i < attachedModelCount ; i++ )
		attachedModels[ i ] = ToLower( self GetAttachModelName( i ) );

	for ( i = 0 ; i < attachedModels.size ; i++ )
		modeldummy Attach( attachedModels[ i ], ToLower( self GetAttachTagName( i ) ) );

	// original model still has it's own attachments because that's too much script to rewrite 
	// to move them completely to the dummy, I just want to translate the effects of an 
	// explosion to the dummy so that's all I'm doing.  So don't expect a dummy destructable 
	// vehicle to react to damage and all of that jazz it's the original model that will do this
}

get_dummy()
{
	if ( self.modeldummyon )
		eModel = self.modeldummy;
	else
		eModel = self;
	return eModel;
}

apply_truckjunk( eVehicle, truckjunk )
{
	if ( !isdefined( self.truckjunk ) )
		return;

	junkarray = self.truckjunk;
	self.truckjunk = [];
	foreach ( truckjunk in junkarray )
	{
		model = Spawn( "script_model", self.origin );
		model SetModel( truckjunk.model );
		model LinkTo( self, "tag_body", truckjunk.origin, truckjunk.angles );
		self.truckjunk[ self.truckjunk.size ] = truckjunk;
	}
}

truckjunk()
{
	Assert( IsDefined( self.target ) );
	spawner = GetEnt( self.target, "targetname" );
	Assert( IsDefined( spawner ) );
	Assert( isSpawner( spawner ) );

	ghettotag = ghetto_tag_create( spawner );

	if ( IsDefined( self.script_noteworthy ) )
		ghettotag.script_noteworthy = self.script_noteworthy;
	if ( !isdefined( spawner.truckjunk ) )
		spawner.truckjunk = [];
	if ( IsDefined( self.script_startingposition ) )
		ghettotag.script_startingposition = self.script_startingposition;
	spawner.truckjunk[ spawner.truckjunk.size ] = ghettotag;

	self Delete();
}

ghetto_tag_create( target )
{
		struct = SpawnStruct();
		struct.origin = self.origin - target GetTagOrigin( "tag_body" );
		struct.angles = self.angles - target GetTagAngles( "tag_body" );
		struct.model = self.model;
		if ( IsDefined( struct.targetname ) )
			level.struct_class_names[ "targetname" ][ struct.targetname ] = undefined;// done with this forever. don't stick around
		if ( IsDefined( struct.target ) )
			level.struct_class_names[ "target" ][ struct.target ] = undefined;// done with this forever. don't stick around
		return struct;
}

//vehicle_dump()
//{
//
//	if ( 1 ) return;
///#
//
//	// starts a map with the necessary blank layer info and a blank worldspawn.  
//	// Throught he magic of junction this file ends up in "map_source\xenon_export\jeepride_veh_ref.map"  
//	// I keep the directory structure somewhat flat because permissions in winnt is painful when dealing with the xenonremote share stuff. 
//	// junction.bat keeps it in check
//
//	// this simple script exports all of the vehicles as script models that have a delete_on_load targetname
//
//	predumpvehicles = GetEntArray( "script_vehicle", "code_classname" );
//	vehicles = [];
//
//	// dumping can jump a frame in which the information could be altered, this stores the necessary info real quick
//	for ( i = 0 ; i < predumpvehicles.size ; i++ )
//	{
//		struct = SpawnStruct();
//		struct.classname = predumpvehicles[ i ].classname;
//		struct.origin = predumpvehicles[ i ].origin;
//		struct.angles = predumpvehicles[ i ].angles;
////		struct.spawner_id = predumpvehicles[ i ].spawner_id;
//		struct.speedbeforepause = predumpvehicles[ i ] Vehicle_GetSpeed();
//		struct.script_VehicleSpawngroup = predumpvehicles[ i ].script_vehiclespawngroup;
//		struct.script_VehicleStartMove = predumpvehicles[ i ].script_vehiclestartmove;
//		struct.model = predumpvehicles[ i ].model;
//		struct.angles = predumpvehicles[ i ].angles;
//		if ( IsDefined( level.playersride ) && predumpvehicles[ i ] == level.playersride )
//			struct.playersride = true;
//		vehicles[ i ] = struct;
//	}
//
//	fileprint_map_start( level.script + "_veh_ref" );
//
//	foreach ( i, vehicle in vehicles )
//	{
//		origin = fileprint_radiant_vec( vehicle.origin );// convert these vectors to mapfile keypair format
//		angles = fileprint_radiant_vec( vehicle.angles );
//
//		fileprint_map_entity_start();
//			fileprint_map_keypairprint( "classname", "script_struct" );
//			fileprint_map_keypairprint( "spawnflags", "4" );
//			fileprint_map_keypairprint( "model", vehicle.model );
//			fileprint_map_keypairprint( "origin", origin );
//			fileprint_map_keypairprint( "angles", angles );
//			if ( IsDefined( vehicle.playersride ) )
//				fileprint_map_keypairprint( "target", "delete_on_load" );// _load deletes these.
//			else
//			{
//				fileprint_map_keypairprint( "target", "structtarg" + i );// _load deletes these.
//				fileprint_map_keypairprint( "targetname", "delete_on_load" );// _load deletes these.
//			}
//
//			if ( IsDefined( vehicle.speedbeforepause ) )
//				fileprint_map_keypairprint( "current_speed", vehicle.speedbeforepause );
//			if ( IsDefined( vehicle.script_VehicleSpawngroup ) )
//				fileprint_map_keypairprint( "script_vehiclespawngroup", vehicle.script_VehicleSpawngroup );
//			if ( IsDefined( vehicle.script_VehicleStartMove ) )
//				fileprint_map_keypairprint( "script_vehiclestartmove", vehicle.script_VehicleStartMove );
//		fileprint_map_entity_end();
//#/
//}


//dump_handle()
//{
//	/#
//	button1 = "r";
//	button2 = "CTRL";
//	while ( 1 )
//	{
//		while ( !twobuttonspressed( button1, button2 ) )
//			wait .05;
//		vehicle_dump();
//		while ( twobuttonspressed( button1, button2 ) )
//			wait .05;
//	}
//	#/
//}

twobuttonspressed( button1, button2 )
{
		return level.player ButtonPressed( button1 ) && level.player ButtonPressed( button2 );
}


/*
=============
///ScriptDocBegin
"Name: vehicle_load_ai( <ai_array> , <bGoddriver> , <group> )"
"Summary: loads a vehicle with the specified array of guys. Sets entity flag "unloaded""
"Module: Vehicle"
"CallOn: A vehicle"
"OptionalArg: <ai_array>: Defaults to searching for an Ai with same team and .script_vehicleride value"
"OptionalArg: <bGoddriver>: gives driver a magic bullet shield if he doesn't already have one"
"OptionalArg: <group>: some vehicles support special groups that can be unloaded or loaded"
"Example: uaz vehicle_load_ai( friendlies, true );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

vehicle_load_ai( ai, goddriver, group )
{
	maps\_vehicle_aianim::load_ai( ai, undefined, group );
}

/*
=============
///ScriptDocBegin
"Name: vehicle_load_ai_single( <ai_array> , <bGoddriver> , <group> )"
"Summary: loads a vehicle with the specified guys. Sets entity flag "unloaded""
"Module: Vehicle"
"CallOn: A vehicle"
"OptionalArg: <ai_array>: Defaults to searching for an Ai with same team and .script_vehicleride value"
"OptionalArg: <bGoddriver>: gives driver a magic bullet shield if he doesn't already have one"
"OptionalArg: <group>: some vehicles support special groups that can be unloaded or loaded"
"Example: uaz vehicle_load_ai( guy, true );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

vehicle_load_ai_single( guy, goddriver, group )
{
	ai = [];
	ai[ 0 ] = guy;
	maps\_vehicle_aianim::load_ai( ai, goddriver, group );
}


kill_badplace( type )
{
	if ( !isdefined( level.vehicle_death_badplace[ type ] ) )
		return;
	struct = level.vehicle_death_badplace[ type ];
	if ( IsDefined( struct.delay ) )
		wait struct.delay;
	if ( !isdefined( self ) )
		return;
	BadPlace_Cylinder( "vehicle_kill_badplace", struct.duration, self.origin, struct.radius, struct.height, struct.team1, struct.team2 );
}

/*
=============
///ScriptDocBegin
"Name: build_death_badplace( <delay> , <duration> , <height> , <radius> , <team1> , <team2> )"
"Summary: builds a badplace on death of a vehicle."
"Module: vehicle_build( vehicle.gsc )"
"CallOn: An entity"
"MandatoryArg: <delay>: delay "
"MandatoryArg: <duration>: duration"
"MandatoryArg: <height>: height"
"MandatoryArg: <radius>: radius"
"MandatoryArg: <team1>: team1"
"MandatoryArg: <team2>: team2"
"Example: build_death_badplace( .5, 3, 512, 700, "axis", "allies" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_death_badplace( delay, duration, height, radius, team1, team2 )
{
	if ( !isdefined( level.vehicle_death_badplace ) )
		level.vehicle_death_badplace = [];

	struct = SpawnStruct();
	struct.delay = delay;
	struct.duration = duration;
	struct.height = height;
	struct.radius = radius;
	struct.team1 = team1;
	struct.team2 = team2;

	level.vehicle_death_badplace[ level.vttype ] = struct;

}

build_death_jolt( delay )
{
	if ( !isdefined( level.vehicle_death_jolt ) )
		level.vehicle_death_jolt = [];
	struct = SpawnStruct();
	struct.delay = delay;
	level.vehicle_death_jolt[ level.vttype ] = struct;
}

kill_jolt( type )
{
	if ( IsDefined( level.vehicle_death_jolt[ type ] ) )
	{
		self.dontfreeme = true;
		wait level.vehicle_death_jolt[ type ].delay;// this is all that exists currently, not to elaborate untill needed.
	}
	if ( !isdefined( self ) )
		return;
	self JoltBody( ( self.origin + ( 23, 33, 64 ) ), 3 );
	wait 2;
	if ( !isdefined( self ) )
		return;
	self.dontfreeme = undefined;
}

heli_squashes_stuff( ender )
{
	self endon( "death" );
	level endon( ender );
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( IsAlive( other ) )
		{
			if ( other.team == "allies" && !isplayer( other ) )
				continue;
			other Kill( ( 0, 0, 0 ) );
		}
	}
}

_getvehiclespawnerarray_by_spawngroup( spawngroup )
{
	spawners = _getvehiclespawnerarray();
	array = [];
	foreach ( spawner in spawners )
		 if ( IsDefined( spawner.script_VehicleSpawngroup ) && spawner.script_VehicleSpawngroup == spawngroup )
		 	array[ array.size ] = spawner;

	return array;
}

_getvehiclespawnerarray( targetname )
{
	vehicles = GetEntArray( "script_vehicle", "code_classname" );
	if ( IsDefined( targetname ) )
	{
		newArray = [];
		foreach ( vehicle in vehicles )
		{
			if ( !isdefined( vehicle.targetname ) )
				continue;
			if ( vehicle.targetname == targetname )
				newArray = array_add( newArray, vehicle );
		}
		vehicles = newArray;
	}

	array = [];
	foreach ( vehicle in vehicles )
	{
		if ( isSpawner( vehicle ) )
			array[ array.size ] = vehicle;
	}
	return array;
}

get_compassTypeForVehicleType( type )
{
	if ( !isdefined( level.vehicle_compass_types[ type ] ) )
	{
		PrintLn( "Compass - type doesn't exist for type '" + type + "'." );
		PrintLn( "Set it in vehicle script:_" + type + ".gsc with build_compassicon." );
		AssertMsg( "Compass - type for model doesn't exits, see console for info" );
	}
	return level.vehicle_compass_types[ type ];
}

setup_gags()
{
	if ( !isdefined( self.script_parameters ) )
		return;
	if ( self.script_parameters == "gag_ride_in" )
		setup_gag_ride();
}

setup_gag_ride()
{
	Assert( IsDefined( self.targetname ) );
	linked = GetEntArray( self.targetname, "target" );
	self.script_vehicleride = auto_assign_ride_group();
	foreach ( ent in linked )
	{
		ent.qSetGoalPos = false;
		level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, self.script_vehicleride, ent );
	}

	level.gag_heliride_spawner = self;
}

auto_assign_ride_group()
{
	if ( !isdefined( level.vehicle_group_autoasign ) )
		level.vehicle_group_autoasign = 1000;
	else
		level.vehicle_group_autoasign++;
	return level.vehicle_group_autoasign;
}


vehicle_script_forcecolor_riders( script_forcecolor )
{
	foreach ( rider in self.riders )
	{
		if ( IsAI( rider ) )
			rider set_force_color( script_forcecolor );
		else if ( IsDefined( rider.spawner ) )
			rider.spawner.script_forcecolor = script_forcecolor;
		else
			AssertMsg( "rider who's not an ai without a spawner.." );

	}
}

vehicle_spawn_group_limit_riders( group, ridermax )
{
	spawners = sort_by_startingpos( level.vehicle_RideSpawners[ group ] );
	array = [];
	for ( i = 0; i < ridermax; i++ )
		array[ array.size ] = spawners[ i ];
	level.vehicle_RideSpawners[ group ] = array;
}

/*
=============
///ScriptDocBegin
"Name: enable_vehicle_compass( )"
"Summary: turns on the compass icon for that vehicle type. different from AddVehicleToCompass in that it finds the type for you. use RemoveVehicleFromCompass() script command to turn it off."
"Module: Vehicle"
"CallOn: A vehicle"
"Example: m1a1 enable_vehicle_compass();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

enable_vehicle_compass()
{
}


update_steering( snowmobile )
{
    if ( snowmobile.update_time != GetTime() )
    {
        snowmobile.update_time = GetTime();
        if ( snowmobile.steering_enable )
        {
            steering_goal = clamp( 0 - snowmobile.angles[ 2 ], 0 - snowmobile.steering_maxroll, snowmobile.steering_maxroll ) / snowmobile.steering_maxroll;
            delta = steering_goal - snowmobile.steering;
            if ( delta != 0 )
            {
                factor = snowmobile.steering_maxdelta / abs( delta );
                if ( factor < 1 )
                    delta *= factor;
                snowmobile.steering += delta;
            }
        }
        else
        {
            snowmobile.steering = 0;
        }
    }
    return snowmobile.steering;
}



/*
=============
///ScriptDocBegin
"Name: mount_snowmobile( <vehicle> )"
"Summary: The guy runs to the vehicle and uses the best anim to enter"
"Module: Vehicle"
"CallOn: An AI that is getting in a vehicle"
"MandatoryArg: <vehicle>: The vehicle to ride "
"MandatoryArg: <sit_position>: 0 for driver, 1 for first passenger, etc."
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
mount_snowmobile( vehicle, sit_position )
{
	self endon( "death" );
	self endon( "long_death" );
	
	if ( doinglongdeath() )
		return;	
	
	rider_types = [];
	rider_types[ 0 ] = "snowmobile_driver";
	rider_types[ 1 ] = "snowmobile_passenger";

	tags = [];
	tags[ "snowmobile_driver" ] = "tag_driver";
	tags[ "snowmobile_passenger" ] = "tag_passenger";

	rider_type = rider_types[ sit_position ];
	AssertEx( IsDefined( rider_type ), "Tried to make a guy mount a snowmobile but it already had 2 riders!" );
	tag = tags[ rider_type ];

	tag_origin = vehicle GetTagOrigin( tag );
	tag_angles = vehicle GetTagAngles( tag );

	closest_scene_name = undefined;
	closest_org = undefined;
	closest_dist = 9999999;
	foreach ( scene_name, _ in level.snowmobile_mount_anims[ rider_type ] )
	{
		animation = getanim_generic( scene_name );
		org = GetStartOrigin( tag_origin, tag_angles, animation );

		new_dist = Distance( self.origin, org );
		if ( new_dist < closest_dist )
		{
			closest_dist = new_dist;
			closest_org = org;
			closest_scene_name = scene_name;
		}
	}

	AssertEx( IsDefined( closest_scene_name ), "Somehow an AI could not find an animation to mount a snowmobile" );

	closest_org = drop_to_ground( closest_org );
	self.goalradius = 8;
	self.disablearrivals = true;
	self SetGoalPos( closest_org );
	self waittill( "goal" );

	vehicle anim_generic( self, closest_scene_name, tag );
	vehicle thread maps\_vehicle_aianim::guy_enter( self );
	self.disablearrivals = false;
}

/*
=============
///ScriptDocBegin
"Name: get_my_spline_node( <org> )"
"Summary: Returns the node of the veihcle spline path that this vehicle is on"
"Module: Vehicle"
"Example: node = get_my_spline_node( self.origin );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_my_spline_node( org )
{
	// finds the 3 closest nodes and puts you on the one that is earliest on the path.
	org = ( org[ 0 ], org[ 1 ], 0 );
	all_nodes = get_array_of_closest( org, level.snowmobile_path );
	close_nodes = [];
	for ( i = 0; i < 3; i++ )
	{
		close_nodes[ i ] = all_nodes[ i ];
	}

	for ( i = 0; i < level.snowmobile_path.size; i++ )
	{
		foreach ( node in close_nodes )
		{
			if ( node == level.snowmobile_path[ i ] )
			{
				return node;
			}
		}
	}
	AssertEx( 0, "Found no node to be on!" );
}

spawn_vehicle_and_attach_to_spline_path( default_speed )
{
	if ( level.enemy_snowmobiles.size >= 8 )
		return;

	vehicle = self spawn_vehicle();
	if ( IsDefined( default_speed ) )
		vehicle VehPhys_SetSpeed( default_speed );

	vehicle thread vehicle_becomes_crashable();

	vehicle endon( "death" );
	vehicle.dontUnloadOnEnd = true;
	vehicle gopath( vehicle );
	vehicle leave_path_for_spline_path();
}

leave_path_for_spline_path()
{
	self endon( "script_crash_vehicle" );
	self waittill_either( "enable_spline_path", "reached_end_node" );

	node = self get_my_spline_node( self.origin );
	//Line( vehicle.origin, node.midpoint, (1, 0, 0 ), 1, 0, 5000 );
	node thread [[ level.drive_spline_path_fun ]]( self );
}

kill_vehicle_spawner( trigger )
{
	trigger waittill( "trigger" );
	foreach ( spawner in level.vehicle_killspawn_groups[ trigger.script_kill_vehicle_spawner ] )
	{
		spawner Delete();
	}

	level.vehicle_killspawn_groups[ trigger.script_kill_vehicle_spawner ] = [];
}

/*
=============
///ScriptDocBegin
"Name: spawn_vehicle_and_gopath()"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
spawn_vehicle_and_gopath()
{
	vehicle = self spawn_vehicle();
	if ( IsDefined( self.script_speed ) )
	{
		if ( !isHelicopter() )
			vehicle VehPhys_SetSpeed( self.script_speed );// used to default to 70
	}
	vehicle thread maps\_vehicle::gopath( vehicle );
	return vehicle;
}


/*
=============
///ScriptDocBegin
"Name: attach_vehicle_triggers()"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
attach_vehicle_triggers()
{
	triggers = GetEntArray( "vehicle_touch_trigger", "targetname" );
	other_triggers = GetEntArray( "vehicle_use_trigger", "targetname" );
	triggers = array_combine( triggers, other_triggers );

	origin = undefined;
	// find a trigger with the correct script_noteworthy and then get all the triggers at that origin.
	foreach ( trigger in triggers )
	{
		if ( trigger.script_noteworthy == self.model )
		{
			origin = trigger.origin;
			break;
		}
	}

	vehicle_triggers = [];

	foreach ( trigger in triggers )
	{
		if ( trigger.script_noteworthy != self.model )
			continue;

		if ( trigger.origin != origin )
			continue;

		vehicle_triggers[ vehicle_triggers.size ] = trigger;
	}

	self.vehicle_triggers = [];

	foreach ( trigger in vehicle_triggers )
	{
		// remove the trigger's targetname so other vehicles dont get these triggers.
		trigger.targetname = undefined;
		trigger thread manual_tag_linkto( self, "tag_origin" );
		if ( !isdefined( self.vehicle_triggers[ trigger.code_classname ] ) )
			self.vehicle_triggers[ trigger.code_classname ] = [];

		self.vehicle_triggers[ trigger.code_classname ][ self.vehicle_triggers[ trigger.code_classname ].size ] = trigger;
	}
}

humvee_antenna_animates( anims )
{
	self UseAnimTree( #animtree );
	humvee_antenna_animates_until_death( anims );
	if ( !isdefined( self ) )
		return;
		
	self clearanim( anims[ "idle" ], 0 );
	self clearanim( anims[ "rot_l" ], 0 );
	self clearanim( anims[ "rot_r" ], 0 );
}

humvee_antenna_animates_until_death( anims )
{
	self endon( "death" );
//	self setanim( anims[ "idle" ], 1, 0, 1 );

	for ( ;; )
	{
		weight = self.veh_speed / 18;
		if ( weight <= 0.0001 )
			weight = 0.0001;
			
		rate = randomfloatrange( 0.3, 0.7 );
		self setanim( anims[ "idle" ], weight, 0, rate );
		
		rate = randomfloatrange( 0.1, 0.8 );
		self setanim( anims[ "rot_l" ], 1, 0, rate );

		rate = randomfloatrange( 0.1, 0.8 );
		self setanim( anims[ "rot_r" ], 1, 0, rate );

		wait( 0.5 );
	}
}


manual_tag_linkto( entity, tag )
{
	for ( ;; )
	{
		if ( !isdefined( self ) )
			break;
		if ( !isdefined( entity ) )
			break;

		org = entity GetTagOrigin( tag );
		ang = entity GetTagAngles( tag );
		self.origin = org;
		self.angles = ang;
		wait( 0.05 );
	}
}

littlebird_lands_and_unloads( vehicle )
{
	vehicle SetDeceleration( 6 );
	vehicle SetAcceleration( 4 );
	AssertEx( IsDefined( self.angles ), "Landing nodes must have angles set." );
	vehicle SetTargetYaw( self.angles[ 1 ] );

	vehicle Vehicle_SetSpeed( 20, 7, 7 );

	while ( Distance( flat_origin( vehicle.origin ), flat_origin( self.origin ) ) > 512 )
		wait .05;

	vehicle endon( "death" );

	badplace_name = "landing" + RandomInt( 99999 );
	BadPlace_Cylinder( badplace_name, 30, self.origin, 200, CONST_bp_height, "axis", "allies", "neutral", "team3" );
	

	vehicle thread vehicle_land_beneath_node( 424, self );

	vehicle waittill( "near_goal" );

	
	BadPlace_Delete( badplace_name );
	BadPlace_Cylinder( badplace_name, 30, self.origin, 200, CONST_bp_height, "axis", "allies", "neutral", "team3" );

	vehicle notify( "groupedanimevent", "pre_unload" );
	vehicle thread vehicle_ai_event( "pre_unload" );

	vehicle Vehicle_SetSpeed( 20, 22, 7 );
	vehicle notify( "nearing_landing" );

	if ( isdefined( vehicle.custom_landing ) )
	{
		switch( vehicle.custom_landing )
		{
			case "hover_then_land":
				vehicle Vehicle_SetSpeed( 10, 22, 7 );
				vehicle thread vehicle_land_beneath_node( 32, self, 64 );
				vehicle waittill( "near_goal" );
				vehicle notify( "hovering" );
				wait( 1 );
				break;
				
			default:
				assertmsg( "Unsupported vehicle.custom_landing" );
				break;
		}
	}


	vehicle thread vehicle_land_beneath_node( 16, self );
	vehicle waittill( "near_goal" );
	BadPlace_Delete( badplace_name );
	//BadPlace_Cylinder( badplace_name, 6, self.origin, 200, CONST_bp_height, "axis", "allies", "neutral", "team3" );

	self script_delay();

	vehicle vehicle_unload();
	vehicle waittill_stable();
	vehicle Vehicle_SetSpeed( 20, 8, 7 );
	wait .2;
	vehicle notify( "stable_for_unlink" );
	wait .2;

	if ( IsDefined( self.script_flag_set ) )
	{
		flag_set( self.script_flag_set );
	}

	if ( IsDefined( self.script_flag_wait ) )
	{
		flag_wait( self.script_flag_wait );
	}

	vehicle notify( "littlebird_liftoff" );
}


// feel free to tear this apart once you have a real context
setup_gag_stage_littlebird_unload()
{
	Assert( IsDefined( self.targetname ) );
	Assert( IsDefined( self.angles ) );

	while ( 1 )
	{
		self waittill( "trigger", vehicle );
		littlebird_lands_and_unloads( vehicle );
	}

//	vehicle ent_flag_wait("unloaded");
//	ai = GetAIArray("allies");
//	foreach( guy in ai )
//	{
//		relativeorigin = guy.origin-vehicle.origin;
//		relativeangles = guy.angles-vehicle.angles;
//		PrintLn("Error: relativeorigin " + relativeorigin ); 
//		PrintLn("Error: relativeangles " + relativeangles ); 
//	}
}


setup_gag_stage_littlebird_load()
{
	Assert( IsDefined( self.targetname ) );
	Assert( IsDefined( self.angles ) );

//	nodes = getstructarray(self.targetname,"target");
//	Assert(nodes.size);

	while ( 1 )
	{
		self waittill( "trigger", vehicle );

		vehicle SetDeceleration( 6 );
		vehicle SetAcceleration( 4 );
		vehicle SetTargetYaw( self.angles[ 1 ] );
		vehicle Vehicle_SetSpeed( 20, 7, 7 );

		while ( Distance( flat_origin( vehicle.origin ), flat_origin( self.origin ) ) > 256 )
			wait .05;

		vehicle endon( "death" );
		vehicle thread vehicle_land_beneath_node( 220, self );

		vehicle waittill( "near_goal" );

		vehicle Vehicle_SetSpeed( 20, 22, 7 );
		vehicle thread vehicle_land_beneath_node( 16, self );
		vehicle waittill( "near_goal" );

		vehicle waittill_stable();
		vehicle notify( "touch_down", self );
		vehicle Vehicle_SetSpeed( 20, 8, 7 );
	}

//	vehicle ent_flag_wait("unloaded");
//	ai = GetAIArray("allies");
//	foreach( guy in ai )
//	{
//		relativeorigin = guy.origin-vehicle.origin;
//		relativeangles = guy.angles-vehicle.angles;
//		PrintLn("Error: relativeorigin " + relativeorigin ); 
//		PrintLn("Error: relativeangles " + relativeangles ); 
//	}
}

vehicle_land_beneath_node( neargoal, node, height )
{
	if ( !isdefined( height ) )
		height = 0;
	
	self notify( "newpath" );
	if ( ! IsDefined( neargoal ) )
		neargoal = 2;
	self SetNearGoalNotifyDist( neargoal );
	self SetHoverParams( 0, 0, 0 );
	self ClearGoalYaw();
	self SetTargetYaw( flat_angle( node.angles )[ 1 ] );
	
	self setvehgoalpos_wrap( groundpos( node.origin ) + ( 0, 0, height ), 1 );
	self waittill( "goal" );
}


vehicle_landvehicle( neargoal, node )
{
	self notify( "newpath" );
	if ( ! IsDefined( neargoal ) )
		neargoal = 2;
	self SetNearGoalNotifyDist( neargoal );
	self SetHoverParams( 0, 0, 0 );
	self ClearGoalYaw();
	self SetTargetYaw( flat_angle( self.angles )[ 1 ] );
	self setvehgoalpos_wrap( groundpos( self.origin ), 1 );
	self waittill( "goal" );
}



/*
=============
///ScriptDocBegin
"Name: vehicle_get_riders_by_group( <groupname> )"
"Summary: Some vehicles like the littlebird have predefined unload groups you can use this to get the guys on those groups"
"Module: Vehicle"
"CallOn: A Vehicle"
"MandatoryArg: <groupname>: "
"Example: ai = vehicle vehicle_get_riders_by_group( "right" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

vehicle_get_riders_by_group( groupname )
{
	group = [];
	Assert( IsDefined( self.vehicletype ) );
	if ( ! IsDefined( level.vehicle_unloadgroups[ self.vehicletype ] ) )
	{
		return group;
	}
	vehicles_groups = level.vehicle_unloadgroups[ self.vehicletype ];
	if ( ! IsDefined( groupname ) )
	{
		return group;
	}

	foreach ( guy in self.riders )
	{
		Assert( IsDefined( guy.vehicle_position ) );
		foreach ( groupid in	vehicles_groups[ groupname ] )
		{
			if ( guy.vehicle_position == groupid )
			{
				group[ group.size ] = guy;
			}
		}
	}
	return group;
}

/*
=============
///ScriptDocBegin
"Name: vehicle_ai_event( <event> )"
"Summary: tell a vehicle to do one of the following actions, provided that it has those anims setup for it:  ( idle, duck, duck_once, duck_once, weave,"
"Summary: weave, stand, turn_right, turn_right, turn_left, turn_left, turn_hardright, turn_hardleft, turret_fire, turret_turnleft, turret_turnright,"
"Summary: unload, pre_unload, pre_unload, idle_alert, idle_alert_to_casual, reaction )"
"Summary: returns the ai that did the event"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <param1>: "
"Example: vehicle vehicle_ai_event( "idle_alert" ) "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_ai_event( event )
{
	return self maps\_vehicle_aianim::animate_guys( event );
}

/*
=============
///ScriptDocBegin
"Name: vehicle_unload( <group> )"
"Summary: Tells ai to unload from a vehicle, returns the ai"
"Module: Vehicle"
"CallOn: A Vehicle"
"OptionalArg: <group>: some vehicles have groups of ai that you can unload, I'll try to list them from here out on the entity info in radiant"
"Example: ai = bmp vehicle_unload();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_unload( who )
{
	self notify( "unloading" );	// added this notify since it no longer does the old "unload" notify
	ai = [];
	if ( ent_flag_exist( "no_riders_until_unload" ) )
	{
		ent_flag_set( "no_riders_until_unload" );
		ai = spawn_group();
		foreach ( a in ai )
			spawn_failed( a );
	}
	if ( IsDefined( who ) )
		self.unload_group = who;
	// makes ai unload
	foreach ( guy in self.riders )
	{
		if ( IsAlive( guy ) )
			guy notify( "unload" );
	}
	ai = self vehicle_ai_event( "unload" );
// 		if ( IsDefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ] && riders_check() )
// 			self ClearTurretTarget();
	return ai;
}


/*
=============
///ScriptDocBegin
"Name: get_stage_nodes( <pickup_node_before_stage>, <side> )"
"Summary: Used for getting cover nodes in Littlebird staging prefab"
"Module: Vehicle"
"MandatoryArg: <pickup_node_before_stage>: A script_origin or struct on a helicopter path that is right before the linked stage prefab"
"MandatoryArg: <side>: " Left" or "right" side bench of littlebird"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_stage_nodes( pickup_node_before_stage, side )
{
	Assert( IsDefined( pickup_node_before_stage.target ) );
	targeted_nodes = GetNodeArray( pickup_node_before_stage.target, "targetname" );
	stage_side_nodes = [];
	foreach ( node in targeted_nodes )
	{
		Assert( IsDefined( node.script_noteworthy ) );
		if ( node.script_noteworthy == "stage_" + side )
			stage_side_nodes[ stage_side_nodes.size ] = node;
	}
	return stage_side_nodes;
}

/*
=============
///ScriptDocBegin
"Name: set_stage( <pickup_node_before_stage>, <guys>, <side> )"
"Summary: Used for getting setting up AI around the landing area of a littlebird with benches"
"Module: Vehicle"
"MandatoryArg: <pickup_node_before_stage>: A script_origin or struct on a helicopter path that is right before the linked stage prefab"
"MandatoryArg: <guys>: group of 3 AI that will load on either the right or left side"
"MandatoryArg: <side>: " Left" or "right" side bench of littlebird"
"Example: littlebird_wingman set_stage( pickup_node_before_stage, aRoof_riders_left, "left" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_stage( pickup_node_before_stage, guys, side )
{
	if ( !ent_flag_exist( "staged_guy_" + side ) )
		ent_flag_init( "staged_guy_" + side );
	else
		ent_flag_clear( "staged_guy_" + side );

	if ( !ent_flag_exist( "guy2_in_" + side ) )
		ent_flag_init( "guy2_in_" + side );
	else
		ent_flag_clear( "guy2_in_" + side );

	//if ( ! ent_flag_exist( "all_aboard" ) )
		//ent_flag_init( "all_aboard" );
	//else
		//ent_flag_clear( "all_aboard" );

	nodes = get_stage_nodes( pickup_node_before_stage, side );
	Assert( nodes.size );
	heli_node = getstruct( pickup_node_before_stage.target, "targetname" );
	stage_heli = Spawn( "script_model", ( 0, 0, 0 ) );
	stage_heli SetModel( self.model );
	stage_heli.origin = drop_to_ground( heli_node.origin ) + ( 0, 0, self.originheightoffset );
	stage_heli.angles = heli_node.angles;
	stage_heli Hide();

	hop_on_guy1 = undefined;
	patting_back_second_guy = undefined;
	stage_guy = undefined;


	foreach ( node in nodes )
	{
		guy = undefined;
		
		//check to see if there is already a guy destined for this node with .script_startingposition
		foreach( rider in guys )
		{
			if ( ( isdefined( rider.script_startingposition ) ) && ( rider.script_startingposition == node.script_startingposition ) )
			{
				guy = rider;
				break;
			}
		}
		
		if ( !isdefined( guy ) )
		{
			guy = getClosest( node.origin, guys );
		}
		
		Assert( IsDefined( guy ) );

		//used to associate this node with a position
		Assert( IsDefined( node.script_startingposition ) );
		guy.script_startingposition = node.script_startingposition;

		if ( guy.script_startingposition  == 2 || guy.script_startingposition == 5 )
		{
				hop_on_guy1 = guy;
				guy maps\_spawner::go_to_node_set_goal_node( node );
		}
		else if ( guy.script_startingposition  == 3 || guy.script_startingposition == 6 )
		{
			 stage_guy = guy;
		}
		else if ( guy.script_startingposition  == 4 || guy.script_startingposition == 7 )
		{
			patting_back_second_guy = guy;
				guy maps\_spawner::go_to_node_set_goal_node( node );
		}

		guys = array_remove( guys, guy );
	}

	Assert( IsDefined( hop_on_guy1 ) );
	Assert( IsDefined( patting_back_second_guy ) );
	Assert( IsDefined( stage_guy ) );

	self thread stage_guy( stage_guy, side, patting_back_second_guy, stage_heli );
	self thread delete_on_death( stage_heli );

}


/*
=============
///ScriptDocBegin
"Name: load_side( <side>, <riders> )"
"Summary: Used for loading AI onto a littlebird with benches"
"Module: Vehicle"
"MandatoryArg: <riders>: group of 3 AI that will load on either the right or left side"
"MandatoryArg: <side>: " Left" or "right" side bench of littlebird"
"Example: littlebird_wingman_02 thread load_side( "left", aRoof_riders_left );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
load_side( side, riders )
{

	hop_on_guy1 = undefined;
	patting_back_second_guy = undefined;
	stage_guy = undefined;
	foreach ( rider in riders )
	{
		Assert( IsDefined( rider.script_startingposition ) );
		if ( rider.script_startingposition  == 2 || rider.script_startingposition == 5 )
			hop_on_guy1 = rider;
		else if ( rider.script_startingposition  == 3 || rider.script_startingposition == 6 )
			 stage_guy = rider;
		else if ( rider.script_startingposition  == 4 || rider.script_startingposition == 7 )
			patting_back_second_guy = rider;
	}
	Assert( IsDefined( hop_on_guy1 ) );
	Assert( IsDefined( patting_back_second_guy ) );
	Assert( IsDefined( stage_guy ) );

//	stage_guy = getClosest( self.origin, riders );
//	riders = array_remove( riders, stage_guy );

//	hop_on_guy1 = getClosest( self.origin, riders );
//	riders = array_remove( riders, hop_on_guy1 );

	//this guy kneels down needs to be setup before other guy can be there.
//	thread stage_guy( stage_guy, side, patting_back_second_guy );

	ent_flag_wait( "staged_guy_" + side );

	thread vehicle_load_ai_single( hop_on_guy1, undefined, side );
	//waittill he's just starting to play out his animation before sending the other guys to get in the way.
	hop_on_guy1 waittill( "boarding_vehicle" );
	// send the third guy off to jump in
	thread vehicle_load_ai_single( patting_back_second_guy, undefined, side );
	patting_back_second_guy waittill( "boarding_vehicle" );
	ent_flag_set( "guy2_in_" + side );
}

//Nate's magical Littlebird script
stage_guy( guy, side, otherguy, stag_objected )
{
	scene = "stage_littlebird_" + side ;
	array = [];
	array[ 0 ] = guy;

	stag_objected anim_generic_reach( array[ 0 ], scene, "tag_detach_" + side );
	stag_objected anim_generic( 	array[ 0 ], scene, "tag_detach_" + side );
	ent_flag_set( "staged_guy_" + side );

	guy SetGoalPos( drop_to_ground( guy.origin ) );
	guy.goalradius = 16;

	ent_flag_wait( "guy2_in_" + side );

	thread vehicle_load_ai_single( guy, undefined, side );

	//ent_flag_wait( "loaded" );

	//ent_flag_set( "all_aboard" );
}

kill_riders( riders )
{
	foreach ( rider in riders )
	{
		if ( !IsAlive( rider ) )
			continue;
		if ( !isdefined( rider.ridingvehicle ) && !isdefined( rider.drivingVehicle ) )
			continue;

		if ( isdefined( rider.magic_bullet_shield ) )
			rider stop_magic_bullet_shield();
		rider Kill();
	}
}

vehicle_rider_death_detection( vehicle, riders )
{
	// this is just plain wrong.. I'm just going to hack around it for af_chase since we're supposed to be finished with the game.. -Nate
	if( level.script == "af_chase" )
		if( isdefined( self.vehicle_position ) && self.vehicle_position != 0 )
			return;

	self.health = 1;
	vehicle endon( "death" );
	self.baseaccuracy = 0.15;

			
	self waittill( "death" );
	vehicle notify( "driver_died" );
	kill_riders( riders );
}

vehicle_becomes_crashable()
{
	self endon( "death" );
	self endon( "enable_spline_path" ); // vehicle spline behavior handles this on its own

	waittillframeend; // let .riders get set
	self.riders = remove_dead_from_array( self.riders );
	
	if ( self.riders.size )
	{
		array_thread( self.riders, ::vehicle_rider_death_detection, self, self.riders );
		self waittill_either( "veh_collision", "driver_died" );
		kill_riders( self.riders );
		wait( 0.25 );
	}

	self notify( "script_crash_vehicle" );
	self VehPhys_Crash();
}

/*
=============
///ScriptDocBegin
"Name: vehicle_turret_scan_on()"
"Summary: Call on a tank to make its main turret scan randomly back and forth"
"Module: Vehicle"
"CallOn: A spawned vehicle entity with a main turret cannon (tanks)"
"Example: level.t72 thread vehicle_turret_scan_on(); "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_turret_scan_on()
{
	self endon( "death" );
	self endon( "stop_scanning_turret" );

	positive_range = RandomInt( 2 );

	while ( IsDefined( self ) )
	{

		if ( cointoss() )
		{
			self vehicle_aim_turret_at_angle( 0 );
			wait( RandomFloatRange( 2, 10 ) );
		}

		if ( positive_range == 0 )
		{
			angle = RandomIntRange( 10, 30 );
			positive_range = 1;
		}
		else
		{
			angle = RandomIntRange( -30, -10 );
			positive_range = 0;
		}

		self vehicle_aim_turret_at_angle( angle );
		wait( RandomFloatRange( 2, 10 ) );
	}
}

/*
=============
///ScriptDocBegin
"Name: vehicle_turret_scan_off()"
"Summary: Call on a tank to make its main turret stop scanning randomly back and forth"
"Module: Vehicle"
"CallOn: A spawned vehicle entity with a main turret cannon (tanks)"
"Example: level.t72 thread vehicle_turret_scan_off(); "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_turret_scan_off()
{
	self notify( "stop_scanning_turret" );
}

vehicle_aim_turret_at_angle( iAngle )
{
	self endon( "death" );
	vec = AnglesToForward( self.angles + ( 0, iAngle, 0 ) );
	vec *= 10000;
	vec = vec + ( 0, 0, 70 );
	self SetTurretTargetVec( vec );
}


/*
=============
///ScriptDocBegin
"Name: vehicle_get_path_array()"
"Summary: Call on a vehicle to get an array of nodes/structs/script_origins it is linked to"
"Module: Vehicle"
"CallOn: A spawned vehicle entity"
"Example: path_array = level.t72 vehicle_get_path_array(); "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_get_path_array()
{
	self endon( "death" );
	aPathNodes = [];
	eStartNode = self.attachedpath;
	if ( !isdefined( self.attachedpath ) )
		return aPathNodes;
	nextNode = eStartNode;
	nextNode.counted = false;
	while ( IsDefined( nextNode ) )
	{
		//end loop if next node links back to some other node already in the array
		if ( ( IsDefined( nextNode.counted ) ) && ( nextNode.counted == true ) )
			break;
		//add the next node to the array
		aPathNodes = array_add( aPathNodes, nextNode );
		nextNode.counted = true;
		//end loop if not targeting a new node
		if ( !isdefined( nextNode.target ) )
			break;

		if ( !isHelicopter() )
			nextNode = GetVehicleNode( nextNode.target, "targetname" );
		else
			nextNode = getent_or_struct( nextNode.target, "targetname" );
	}

	return aPathNodes;
}

kill_lights( model )
{
	lights_off_internal( "all", model );
}
/*
=============
///ScriptDocBegin
"Name: vehicle_lights_on( <group> )"
"Summary: turn on this group of lights on a vehicle."
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <group>: "
"Example: vehicle_lights_on( "spotlight" )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_lights_on( group )
{
	lights_on( group );
}

/*
=============
///ScriptDocBegin
"Name: vehicle_lights_off( <group> )"
"Summary: turn off this group of lights on a vehicle."
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <group>: "
"Example: vehicle_lights_off( "spotlight" )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_lights_off( group )
{
	lights_off( group );
}


