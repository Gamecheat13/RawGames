/* 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

VEHICLE script

This handles playing the various effects and animations on a vehicle.
It handles initializing a vehicle( giving it life, turrets, machine guns, treads and things )

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

*/ 

/*QUAKED info_vehicle_node_small (0.0 0.8 0.0) (-4 -4 -4) (4 4 4) START_NODE
targetname - name of this node
target - name of next node in this path
speed - speed[mph] vehicle should have at this node
lookahead - time[sec] vehicle should look ahead at this node
*/


/*QUAKED info_vehicle_node_rotate_small (0.2 0.4 1.0) (-4 -4 -4) (4 4 4) START_NODE
targetname - name of this node
target - name of next node in this path
speed - speed[mph] vehicle should have at this node
lookahead - time[sec] vehicle should look ahead at this node
*/


/*QUAKED info_vehicle_node_notify_small (0.4 0.2 1.0) (-4 -4 -4) (4 4 4)
targetname - name of this node
target - name of next node in this path
*/

#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle_aianim;
#include common_scripts\utility;
#include maps\_vehicle_code;
#using_animtree( "vehicles" );

init_vehicles()
{
	// For Engineering when they need test specific functionality of vehicles
	if ( IsDefined( level.disableVehicleScripts ) && level.disableVehicleScripts )
		return;

	// initialize all the level wide vehicle system variables
	setup_levelvars();
	
	level.helicopter_crash_locations = array_combine( level.helicopter_crash_locations, getstructarray_delete( "helicopter_crash_location", "targetname" ) );

	setup_vehicle_spawners();

			  //   entities 										   process 	   
	array_thread( GetEntArray( "truckjunk", "targetname" )			, ::truckjunk );
	array_thread( GetEntArray( "truckjunk", "script_noteworthy" )	, ::truckjunk );
	array_thread( getstructarray( "truckjunk", "targetname" )		, ::truckjunk );
	array_thread( getstructarray( "truckjunk", "script_noteworthy" ), ::truckjunk );

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

	level.vehicle_processtriggers = undefined;

	level.levelHasVehicles = ( GetEntArray( "script_vehicle", "code_classname" ).size > 0 );

	//"Frag Grenades cannot damage this vehicle"
	add_hint_string( "invulerable_frags", &"SCRIPT_INVULERABLE_FRAGS", undefined );
	//"Bullets cannot damage this vehicle"
	add_hint_string( "invulerable_bullets", &"SCRIPT_INVULERABLE_BULLETS", undefined );
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
	return _vehicle_paths( node, bhelicopterwaitforstart );
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
	return _gopath( vehicle );
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
	return _vehicle_spawn( vspawner );
}

kill_fx( model, rocketdeath )
{
	return _kill_fx( model, rocketdeath );
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
	if ( !IsDefined( level.vehicle_death_radiusdamage ) )
		level.vehicle_death_radiusdamage = [];
	if ( !IsDefined( bKillplayer ) )
		bKillplayer = false;
	if ( !IsDefined( offset ) )
		offset = ( 0, 0, 0 );
	struct												  = SpawnStruct();
	struct.offset										  = offset;
	struct.range										  = range;
	struct.maxdamage									  = maxdamage;
	struct.mindamage									  = mindamage;
	struct.bKillplayer									  = bKillplayer;
	struct.delay										  = delay;
	level.vehicle_death_radiusdamage[ level.vtclassname ] = struct;
}

/* 
============= 
///ScriptDocBegin
"Name: build_rumble( <rumble> , <scale> , <duration> , <radius> , <basetime> , <randomaditionaltime> )"
"Summary: called in individual vehicle file - define how the rumble behaves for a vehicle type"
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
	if ( !IsDefined( level.vehicle_rumble ) )
		level.vehicle_rumble = [];
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	Assert( IsDefined( rumble ) );
	PreCacheRumble( rumble );
	struct.rumble							  = rumble;
	level.vehicle_rumble[ level.vtclassname ] = struct;
}

/* 
============= 
///ScriptDocBegin
"Name: build_rumble_override( <class>, <rumble> , <scale> , <duration> , <radius> , <basetime> , <randomaditionaltime> )"
"Summary: called in script - override how the rumble behaves for a vehicle type"
"Module: Level"
"CallOn:"
"MandatoryArg: <class> :  the class name that we're creating an override for"
"MandatoryArg: <rumble> :  rumble asset"
"MandatoryArg: <scale> : scale"
"MandatoryArg: <duration> : duration"
"MandatoryArg: <radius> : radius"
"MandatoryArg: <basetime> : time to wait between rumbles"
"MandatoryArg: <randomaditionaltime> : random amount of time to add to basetime"
"Example: build_rumble_override( "motorcycle", "tank_rumble", 0.15, 4.5, 600, 1, 1 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_rumble_override( class, rumble, scale, duration, radius, basetime, randomaditionaltime )
{
	if ( !IsDefined( level.vehicle_rumble_override ) )
		level.vehicle_rumble_override = [];
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	Assert( IsDefined( rumble ) );
	PreCacheRumble( rumble );
	struct.rumble = rumble;
	Assert( !IsDefined( level.vehicle_rumble_override[ class ] ) );
	level.vehicle_rumble_override[ class ] = struct;
}

/* 
============= 
///ScriptDocBegin
"Name: build_rumble_unique( <rumble> , <scale> , <duration> , <radius> , <basetime> , <randomaditionaltime> )"
"Summary: called on a vehicle instance - set a unique vehicle rumble for this isntance"
"Module: Entity"
"CallOn: the vehicle you want to have a custom rumble"
"MandatoryArg: <rumble> :  rumble asset"
"MandatoryArg: <scale> : scale"
"MandatoryArg: <duration> : duration"
"MandatoryArg: <radius> : radius"
"MandatoryArg: <basetime> : time to wait between rumbles"
"MandatoryArg: <randomaditionaltime> : random amount of time to add to basetime"
"Example: build_rumble_unique( "tank_rumble", 0.15, 4.5, 600, 1, 1 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_rumble_unique( rumble, scale, duration, radius, basetime, randomaditionaltime )
{
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	Assert( IsDefined( rumble ) );
	//cant precache the rumble since this can be called at anypoint during the level
//	PreCacheRumble( rumble );
	struct.rumble = rumble;
	Assert( IsDefined( self.vehicletype ) ); //so we're reasonably sure you're a vehicle
	self.vehicle_rumble_unique = struct;
	
	//since rumble is started up when a vehicle spawns there should always be a rumble running on the instance that has called this
	//so we need to restart the rumble with our new settings
	vehicle_kill_rumble_forever();
	thread vehicle_rumble();
}

/* 
============= 
///ScriptDocBegin
"Name: build_deathquake( <scale> , <duration> , <radius> )"
"Summary: called in individual vehicle file - define how the death quake acts for a vehicle type"
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
	classname = level.vtclassname;
	
	if ( !IsDefined( level.vehicle_death_earthquake ) )
		level.vehicle_death_earthquake = [];
	level.vehicle_death_earthquake[ classname ] = build_quake( scale, duration, radius );
}

build_quake( scale, duration, radius, basetime, randomaditionaltime )
{
	struct			= SpawnStruct();
	struct.scale	= scale;
	struct.duration = duration;
	struct.radius	= radius;
	if ( IsDefined( basetime ) )
		struct.basetime = basetime;
	if ( IsDefined( randomaditionaltime ) )
		struct.randomaditionaltime = randomaditionaltime;
	return struct;
}

build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, selfDeleteDelay, remove_deathfx_entity_delay )
{
	if ( !IsDefined( bSoundlooping ) )
		bSoundlooping = false;
	if ( !IsDefined( bEffectLooping ) )
		bEffectLooping = false;
	if ( !IsDefined( delay ) )
		delay = 1;
	struct							   = SpawnStruct();
	struct.effect					   = LoadFX				   ( effect );
	struct.tag						   = tag;
	struct.sound					   = sound;
	struct.bSoundlooping			   = bSoundlooping;
	struct.delay					   = delay;
	struct.waitDelay				   = waitDelay;
	struct.stayontag				   = stayontag;
	struct.notifyString				   = notifyString;
	struct.bEffectLooping			   = bEffectLooping;
	struct.selfDeleteDelay			   = selfDeleteDelay;
	struct.remove_deathfx_entity_delay = remove_deathfx_entity_delay;
	return struct;
}

/* 
============= 
///ScriptDocBegin
"Name: build_deathfx_override( <type> , <model>, <effect> , <tag> , <sound> , <bEffectLooping> , <delay> , <bSoundlooping> , <waitDelay> , <stayontag> , <notifyString> , <delete_vehicle_delay>  )"
"Summary: called in individual vehicle file - death effects on vehicles, usually multiple lines for multistaged / multitagged sequences"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <classname> : vehicle classname to override the effect of"
"MandatoryArg: <type> : vehicle type to override the effect of"
"MandatoryArg: <model> : vehicle model to override the effect of"
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
"Example: build_deathfx_override( "fx/explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_deathfx_override( classname, type, model, effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay )
{
	// set the level script here since its called pre-load, needed for IW4 map check.
	if ( !IsDefined( level.script ) )
		level.script = ToLower( GetDvar( "mapname" ) );
	
	// use level variables so I don't have to pass so much stuff around.
	level.vttype	 = type;
	level.vtmodel	 = model;
	level.vtoverride = true;
	
	Assert( IsDefined( classname ) );
		
	level.vtclassname = classname;
	

	//for pre precache script calls.
	if ( !IsDefined( level.vehicle_death_fx ) )
		level.vehicle_death_fx = [];

	// overwrite the deathfx post precache. 
	if ( ! is_overrode( classname ) )
		level.vehicle_death_fx[ classname ] = [];
	
	level.vehicle_death_fx_override[ classname ] = true;
	
	if ( !IsDefined( level.vehicle_death_fx[ classname ] ) )
		level.vehicle_death_fx[ classname ] = [];
		
	level.vehicle_death_fx[ classname ][ level.vehicle_death_fx[ classname ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay );

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
"Example: build_deathfx( "fx/explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay )
{
	AssertEx( IsDefined( effect ), "Failed to build death effect because there is no effect specified for the model used for that vehicle." );
	
	classname = level.vtclassname;
	
	// don't build the deathfx if it's already in place. for call before _load.gsc. 
	if ( is_overrode ( classname ) )
		return;

	if ( !IsDefined( level.vehicle_death_fx[ classname ] ) )
		level.vehicle_death_fx[ classname ] = [];
		
	level.vehicle_death_fx[ classname ][ level.vehicle_death_fx[ classname ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay );
}

is_overrode( typemodel )
{
	if ( !IsDefined( level.vehicle_death_fx_override ) )
		return false;
		
	if ( !IsDefined( level.vehicle_death_fx_override[ typemodel ] ) )
		return false;
		
	if ( IsDefined( level.vtoverride ) )
		return true; // not overrode if overriding.
		
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
"Example: build_rocket_deathfx( "fx/explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_rocket_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay )
{
	classname		  = level.vtclassname;
	level.vtclassname = "rocket_death" + classname;
	build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay );
	level.vtclassname = classname;
}

force_kill()
{
	return _force_kill();
}

/*
=============
///ScriptDocBegin
"Name: godon()"
"Summary: Vehicle gets god mode"
"Module: Vehicle"
"CallOn: A Vehicle"
"Example: tank godon();"
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
"Name: godoff()"
"Summary: Vehicle loses god mode"
"Module: Vehicle"
"CallOn: A Vehicle"
"Example: tank godoff();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
godoff()
{
	self.godmode = false;
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
	return _mgoff();
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
	return _mgon();
}

isVehicle()
{
	return IsDefined( self.vehicletype );
}

/*
=============
///ScriptDocBegin
"Name: build_turret( <info> , <tag> , <model> , <maxrange> , <defaultONmode> , <deletedelay>, <defaultdroppitch>, <defaultdropyaw>, <offset_tag> )"
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
"OptionalArg: <offset_tag>: vector offset to use when linking the turret to the vehicle."
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_turret( info, tag, model, maxrange, defaultONmode, deletedelay, defaultdroppitch, defaultdropyaw, offset_tag )
{
	if ( !IsDefined( level.vehicle_mgturret ) )
		level.vehicle_mgturret = [];

	classname = level.vtclassname;
		
	if ( !IsDefined( level.vehicle_mgturret[ classname ] ) )
		level.vehicle_mgturret[ classname ] = [];

	PreCacheModel( model );
	PreCacheTurret( info );
	struct					= SpawnStruct();
	struct.info				= info;
	struct.tag				= tag;
	struct.model			= model;
	struct.maxrange			= maxrange;
	struct.defaultONmode	= defaultONmode;
	struct.deletedelay		= deletedelay;
	struct.defaultdroppitch = defaultdroppitch;
	struct.defaultdropyaw	= defaultdropyaw;
	if ( IsDefined( offset_tag ) )
		struct.offset_tag = offset_tag;
	level.vehicle_mgturret[ classname ][ level.vehicle_mgturret[ classname ].size ] = struct;
}

vehicle_is_crashing()
{
	return _vehicle_is_crashing();
}

is_godmode()
{
	return _is_godmode();
}

vehicle_kill_rumble_forever()
{
	self notify( "kill_rumble_forever" );
}

// just does all the lights.
move_truck_junk_here( model )
{

	if ( !IsDefined( self.truckjunk ) )
		return;
		
	foreach ( truckjunk in self.truckjunk )
	{
	    //I'm moving the truckjunk to one of the truckjunks
	    if ( truckjunk == model )
	        continue;
	        
		truckjunk Unlink();
		if ( IsDefined( truckjunk.script_ghettotag ) )
    		truckjunk LinkTo( model, truckjunk.script_ghettotag, truckjunk.base_origin, truckjunk.base_angles );
		else
	    	truckjunk LinkTo( model );
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
	thread move_lights_here( self );
	move_effects_ent_here( self );


	// flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = false;
	self.modeldummy Delete();
	self.modeldummy = undefined;

	// helicopters do dust kickup fx
	if ( self hasHelicopterDustKickup() )
	{
		self notify( "stop_kicking_up_dust" );
		self thread aircraft_wash_thread();
	}

	return self.modeldummy;
}

move_riders_here( base )
{
	if ( !IsDefined( self.riders ) )
		return;
	riders = self.riders;
	// move rider characters to their new location
	foreach ( guy in riders )
	{
		if ( !IsDefined( guy ) )
			continue;
		animpos = maps\_vehicle_aianim::anim_pos( self, guy.vehicle_position );
		if ( IsDefined( animpos.passenger_2_turret_func ) )
			continue;
		guy Unlink();
		guy LinkTo( base, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
		if ( IsAI( guy ) )
			guy ForceTeleport( base GetTagOrigin( animpos.sittag ) );
		else
			guy.origin = base GetTagOrigin( animpos.sittag );
	}
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
	foreach ( vehicle in vehicleArray )
		thread gopath( vehicle );
	return vehicleArray;
}

aircraft_wash( model )
{
	thread aircraft_wash_thread( model );
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

/* 
============= 
///ScriptDocBegin
"Name: build_light( <classname> , <name> , <tag> , <effect> , <group> , <delay> )"
"Summary: contstruct a light fx to play on a vehicle tag, see lights_on lights_off"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: An entity"
"MandatoryArg: <classname> : Name of classname that you are building the light for"
"MandatoryArg: <name> : Unique name used for grouping"
"MandatoryArg: <tag> : Tag to play the light effect on"
"MandatoryArg: <effect> : the effect"
"MandatoryArg: <group> : Group is used for lights_on lights_off"
"MandatoryArg: <delay> : Used to offset the timing of this light so they don't all start at the same time"
"Example: build_light( model, "taillight_R", 	"TAG_REAR_LIGHT_RIGHT", 	"fx/misc/car_taillight_btr80", 		"running", 	0.1 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_light( classname, name, tag, effect, group, delay )
{
	if ( !IsDefined( level.vehicle_lights ) )
		level.vehicle_lights = [];
	if ( !IsDefined( level.vehicle_lights_group_override ) )
		level.vehicle_lights_group_override = [];
	
	if ( IsDefined( level.vehicle_lights_group_override[ group ] ) && !level.vtoverride )
		return;// this light group has been overwritten and shouldn't be set.

	struct		  = SpawnStruct();
	struct.name	  = name;
	struct.tag	  = tag;
	struct.delay  = delay;
	struct.effect = LoadFX( effect );

	level.vehicle_lights[ classname ][ name ] = struct;

	group_light( classname, name, "all" );
	if ( IsDefined( group ) )
		group_light( classname, name, group );
		
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
"Example: build_light_override( "btr80", "vehicle_btr80", "spotlight", 		"TAG_FRONT_LIGHT_RIGHT", "fx/misc/spotlight_btr80_daytime", 	"spotlight", 			0.2 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_light_override( classname, name, tag, effect, group, delay )
{
	// set the level script here since its called pre-load, needed for IW4 map check.
	if ( !IsDefined( level.script ) )
		level.script = ToLower( GetDvar( "mapname" ) );

	level.vtclassname = classname;
	build_light( classname, name, tag, effect, group, delay );
	level.vtoverride							 = false;
	level.vehicle_lights_group_override[ group ] = true;
}

/*
=============
///ScriptDocBegin
"Name: build_hideparts( <classname> , <parts_array> )"
"Summary: Describes the parts for this class of vehicle to be hidden on spawn."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <classname>: classname"
"MandatoryArg: <parts_array>: array of parts that should be hidden.. "
"Example: 	build_hideparts( classname, ["TAG_RAIL"] );"
"SPMP: singleplayer"
"NoteLine: You should have a part hideable. Usually set by checking 'allowHidingAllParts' in asset manager."
///ScriptDocEnd
=============
*/
build_hideparts( classname, parts_array )
{
	Assert( IsDefined( classname ) );
	Assert( IsDefined( parts_array ) );
    if ( !IsDefined( level.vehicle_hide_list ) )
		level.vehicle_hide_list			= [];
	level.vehicle_hide_list[ classname ] = parts_array;
}

/* 
============= 
///ScriptDocBegin
"Name: build_deathmodel( <model> , <deathmodel>, <swapDelay>, <classname> )"
"Summary: called in individual vehicle file - assigns death model to vehicles with this model. "
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <model> : name of model to associate death model"
"OptionalArg: <deathmodel> : name of death model to be associated with model"
"OptionalArg: <swapDelay> : number of seconds to wait before setting the death model after the vehicle dies. Defaults to 0"
"OptionalArg: <classname> : classname for swap, IW5 uses classnames to assign deathmodels."
"Example: build_deathmodel( "bmp", "bmp_destroyed" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_deathmodel( model, deathmodel, swapDelay, classname )
{
	if ( model != level.vtmodel )
		return;
	if ( !IsDefined( deathmodel ) )
		deathmodel = model;
	PreCacheModel( model );
	PreCacheModel( deathmodel );
	
	if ( !IsDefined( swapDelay ) )
		swapDelay = 0;

	if ( !IsDefined( classname ) )
	{
		level.vehicle_deathmodel	  [ model ] = deathmodel;
		level.vehicle_deathmodel_delay[ model ] = swapDelay;
	}
	else
	{
		level.vehicle_deathmodel	  [ classname ] = deathmodel;
		level.vehicle_deathmodel_delay[ classname ] = swapDelay;
	}
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
	level.vehicle_shoot_shock[ level.vtclassname ] = shock;
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
	
	if ( !IsDefined( level.vehicle_IdleAnim ) )
		level.vehicle_IdleAnim = [];
	if ( !IsDefined( level.vehicle_IdleAnim[ level.vtmodel ] ) )
		level.vehicle_IdleAnim[ level.vtmodel ] = [];
	level.vehicle_IdleAnim[ level.vtmodel ][ level.vehicle_IdleAnim[ level.vtmodel ].size ] = animation;
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
	if ( !IsDefined( normalspeed ) )
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
"MandatoryArg: <classname> : classname to set( this is usually generated by the level script )"
"Example: build_template( "bmp", model, type );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_template( type, model, typeoverride, classname )
{
	// set the level script here since its called pre-load
	if ( !IsDefined( level.script ) )
		level.script = ToLower( GetDvar( "mapname" ) );
	
	if ( IsDefined( typeoverride ) )
		type = typeoverride;

	AssertEx( IsDefined( classname ), "templated without classname" );
	PrecacheVehicle( type );

	if ( !IsDefined( level.vehicle_death_fx ) )
		level.vehicle_death_fx = [];
	if (	!IsDefined( level.vehicle_death_fx[ classname ] ) )
		level.vehicle_death_fx[ classname ] = [];// can have overrides

	level.vehicle_team[ classname ] = "axis";
	level.vehicle_life[ classname ] = 999;
	
	level.vehicle_hasMainTurret[ model ] = false;
	
	level.vehicle_mainTurrets[ model ] = [];
	
	level.vtmodel	  = model;	  //Vehicle Template Model
	level.vttype	  = type;	  //Vehicle Template VehicleType
	level.vtclassname = classname;//Vehicle Template Classname
}

/* 
============= 
///ScriptDocBegin
"Name: build_exhaust( <exhaust_effect_str> )"
"Summary: called in individual vehicle file - assign an exhaust effect to this vehicle!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <exhaust_effect_str> : exhaust effect in string format"
"Example: build_exhaust( "fx/distortion/abrams_exhaust" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_exhaust( effect )
{
	level.vehicle_exhaust[ level.vtmodel ] = LoadFX( effect );
}

/* 
============= 
///ScriptDocBegin
"Name: build_treadfx( <classname>, <type>, <fx>, [do_wash] )"
"Summary: called in individual vehicle file - specifies the treadFX to use per surface. NEW: Supports 'default' as a type, if a surface is undefined, it will try to use default"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <classname> : classname of vehicle"
"MandatoryArg: <type> : surface type for the fx to correspond to"
"MandatoryArg: <fx> : the fx to play"
"OptionalArg: <do_wash> : for aircraft to do the extra wash logic (bank power)"
"Example: build_template( "bmp", model, type );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_treadfx( classname, type, fx, do_wash )
{
	if ( IsDefined( classname ) )
	{
		set_vehicle_effect( classname, type, fx );

		if ( IsDefined( do_wash ) && do_wash )
		{
			set_vehicle_effect( classname, type, fx, "_bank" );
			set_vehicle_effect( classname, type, fx, "_bank_lg" );
		}
	}
	else
	{
		classname = level.vtclassname;
		maps\_treadfx::main( classname );
	}
}

/* 
============= 
///ScriptDocBegin
"Name: build_all_treadfx( <classname>, <fx>, [no_wash] )"
"Summary: called in individual vehicle file - uses the same treadFX for all surfaces type. NEW: Supports 'default' as a type, if a surface is undefined, it will try to use default"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <classname> : classname of vehicle"
"MandatoryArg: <fx> : the fx to play"
"OptionalArg: <no_wash> : for aircraft not to do the extra wash logic (bank power)"
"Example: build_template( "bmp", model, type );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_all_treadfx( classname, fx )
{
	types = get_surface_types();
	foreach ( type in types )
		set_vehicle_effect( classname, type );
}

set_vehicle_effect( classname, material, fx, suffix )
{
	if ( !IsDefined( level._vehicle_effect ) )
		level._vehicle_effect = [];

	if ( IsDefined( suffix ) )
	{
		material = material + suffix;
		fx = fx + suffix;
	}

	if ( IsDefined( fx ) )
		level._vehicle_effect[ classname ][ material ] = LoadFX( fx );
	else if ( IsDefined( level._vehicle_effect[ classname ] ) && IsDefined( level._vehicle_effect[ classname ][ material ] ) )
		level._vehicle_effect[ classname ][ material ] = undefined;
}

get_surface_types()
{
	types = [];
	types[ types.size ] = "brick";
	types[ types.size ] = "bark";
	types[ types.size ] = "carpet";
	types[ types.size ] = "cloth";
	types[ types.size ] = "concrete";
	types[ types.size ] = "dirt";
	types[ types.size ] = "flesh";
	types[ types.size ] = "foliage";
	types[ types.size ] = "glass";
	types[ types.size ] = "grass";
	types[ types.size ] = "gravel";
	types[ types.size ] = "ice";
	types[ types.size ] = "metal";
	types[ types.size ] = "mud";
	types[ types.size ] = "paper";
	types[ types.size ] = "plaster";
	types[ types.size ] = "rock";
	types[ types.size ] = "sand";
	types[ types.size ] = "snow";
	types[ types.size ] = "water";
	types[ types.size ] = "wood";
	types[ types.size ] = "asphalt";
	types[ types.size ] = "ceramic";
	types[ types.size ] = "plastic";
	types[ types.size ] = "rubber";
	types[ types.size ] = "cushion";
	types[ types.size ] = "fruit";
	types[ types.size ] = "paintedmetal";
	types[ types.size ] = "riotshield";
	types[ types.size ] = "slush";
	types[ types.size ] = "default";

	return types;
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
	level.vehicle_team[ level.vtclassname ] = team;
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
	level.vehicle_bulletshield[ level.vtclassname ] = bShield;
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
	level.vehicle_grenadeshield[ level.vtclassname ] = bShield;
	
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
	classname						   = level.vtclassname;
	level.vehicle_aianims[ classname ] = [[ aithread ] ] ();
	
	if ( IsDefined( vehiclethread ) )
		level.vehicle_aianims[ classname ] = [[ vehiclethread ] ] ( level.vehicle_aianims[ classname ] );
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
	level.vehicle_frontarmor[ level.vtclassname ] = armor;
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
	level.vehicle_attachedmodels[ level.vtclassname ] = [[ modelsthread ] ] ();
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
	level.vehicle_unloadgroups[ level.vtclassname ] = [[ unloadgroupsthread ] ] ();
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
	classname = level.vtclassname;
		
	level.vehicle_life			 [ classname ] = health;
	level.vehicle_life_range_low [ classname ] = minhealth;
	level.vehicle_life_range_high[ classname ] = maxhealth;
}

/* 
============= 
///ScriptDocBegin
"Name: build_deckdust( <effect> )"
"Summary: called in individual vehicle file - sets a deckdust effect on a vehicle?"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <effect> :  effect to be assigned as deckdust"
"Example: build_deckdust( "fx/dust/abrams_deck_dust" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
build_deckdust( effect )
{
	level.vehicle_deckdust[ level.vtmodel ] = LoadFX( effect );
}

/* 
============= 
///ScriptDocBegin
"Name: build_destructible( <model> , <destructible_type> )"
"Summary: called in individual vehicle file: asigns destructible type to model."
"Module: vehicle_build( vehicle.gsc )"
"CallOn: level "
"MandatoryArg: <model> : vehicles placed in radiant with this model will be asigned the destructible( see _destructible_types.gsc )"
"OptionalArg: <destructible_type> : the destructible type to asign"
"Example: build_destructible( "vehicle_bm21_mobile_bed_destructible", "vehicle_bm21_mobile_bed" );"
"SPMP: singleplayer"
"NoteLine: destructible_type is setup by Repackager, though you still need to Manually link in the zone source for the destructible assets "
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

	passer		 = SpawnStruct();
	passer.model = model;//
	passer precache_destructible( destructible );

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
	level.vehicleInitThread[ level.vttype ][ level.vtclassname ] = init_thread; //this should be collapsed to single dimension array once IW4 is removed
}

is_dummy()
{
	return self.modeldummyon;
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
	ai		= [];
	ai[ 0 ] = guy;
	maps\_vehicle_aianim::load_ai( ai, goddriver, group );
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
	if ( !IsDefined( level.vehicle_death_badplace ) )
		level.vehicle_death_badplace = [];

	struct			= SpawnStruct();
	struct.delay	= delay;
	struct.duration = duration;
	struct.height	= height;
	struct.radius	= radius;
	struct.team1	= team1;
	struct.team2	= team2;

	level.vehicle_death_badplace[ level.vtclassname ] = struct;
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
	return _mount_snowmobile( vehicle, sit_position );
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
			vehicle VehPhys_SetSpeed( self.script_speed ); // used to default to 70
	}
	vehicle thread maps\_vehicle::gopath( vehicle );
	return vehicle;
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
	
	classname = self.classname;
	
	if ( ! IsDefined( level.vehicle_unloadgroups[ classname ] ) )
		return group;
		
		
	vehicles_groups = level.vehicle_unloadgroups[ classname ];
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
	return _vehicle_unload( who );
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
			angle		   = RandomIntRange( 10, 30 );
			positive_range = 1;
		}
		else
		{
			angle		   = RandomIntRange( -30, -10 );
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
	if ( !IsDefined( self.attachedpath ) )
		return aPathNodes;
	nextNode		 = eStartNode;
	nextNode.counted = false;
	while ( IsDefined( nextNode ) )
	{
		//end loop if next node links back to some other node already in the array
		if ( ( IsDefined( nextNode.counted ) ) && ( nextNode.counted == true ) )
			break;
		//add the next node to the array
		aPathNodes		 = array_add( aPathNodes, nextNode );
		nextNode.counted = true;
		//end loop if not targeting a new node
		if ( !IsDefined( nextNode.target ) )
			break;

		if ( !isHelicopter() )
			nextNode = GetVehicleNode( nextNode.target, "targetname" );
		else
			nextNode = getent_or_struct( nextNode.target, "targetname" );
	}

	return aPathNodes;
}

/*
=============
///ScriptDocBegin
"Name: vehicle_lights_on( <group>, <classname> )"
"Summary: turn on this group of lights on a vehicle."
"Module: Vehicle"
"CallOn: A vehicle"
"OptionalArg: <group>: "
"OptionalArg: <classname>: using a classname override you can apply vehicle lights to model versions."
"Example: vehicle_lights_on( "spotlight" )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_lights_on( group, classname )
{
    if ( !IsDefined( group ) )
		group = "all";
	lights_on( group, classname );
}

/*
=============
///ScriptDocBegin
"Name: vehicle_lights_off( <group> )"
"Summary: turn off this group of lights on a vehicle."
"Module: Vehicle"
"CallOn: A vehicle"
"OptionalArg: <group>: "
"OptionalArg: <classname>: using a classname override you can apply vehicle lights to model versions. "
"Example: vehicle_lights_off( "spotlight" )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_lights_off( group, classname )
{
	lights_off( group, classname );
}


vehicle_single_light_on( light_name )
{
	if ( !IsDefined( self ) || !IsDefined( self.classname ) || !IsDefined( light_name ) )
		return;
	
	if ( !IsDefined( level.vehicle_lights[ self.classname ] ) )
		return;
	
	template = level.vehicle_lights[ self.classname ][ light_name ];
		
	if ( !IsDefined( template ) )
		return;

	if ( IsDefined( template.delay ) )
		delay = template.delay;
	else
		delay = 0;

	//pass the endon death to noself_delaycall
	self endon( "death" );
	childthread noself_delayCall_proc( ::PlayFXOnTag, delay, template.effect, self, template.tag );

	self.lights[ light_name ] = true;
}


vehicle_single_light_off( light_name )
{
	if ( !IsDefined( self.lights ) )
		return;
	
	if ( !IsDefined( self.lights[ light_name ] ) )
		return;
	
	template = level.vehicle_lights[ self.classname ][ light_name ];
	if ( !IsDefined( template ) )
		return;
	
	StopFXOnTag( template.effect, self, template.tag );
	self.lights[ light_name ] = undefined;
}


/*
=============
///ScriptDocBegin
"Name: vehicle_switch_paths( <next_node> , <target_node> )"
"Summary: On stop for SetSwitchNode and vehicle_paths."
"Module: Vehicle"
"CallOn: An vehicle"
"MandatoryArg: <next_node>: The node that the vehicle will switch on, in the future ( not the one that was just triggered. ) "
"MandatoryArg: <target_node>: The node on another path that the vehicle will switch to"
"Example:  vehicle vehicle_switch_paths( next_node, target_node );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_switch_paths( next_node, target_node )
{
    self SetSwitchNode( next_node, target_node );
    self.attachedpath = target_node;
	self thread vehicle_paths();
}

/*
=============
///ScriptDocBegin
"Name: vehicle_stop_named( <stop_name> , <acceleration> , <deceleration> )"
"Summary: With a named stop you can setup multiple conditions on which to resume, IE, SHOOTBUILDING, STOPFORAI, , IT Will not resume ( vehicle_resume_named )untill all of the stop conditions are resumed"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <stop_name>: "
"MandatoryArg: <acceleration>: "
"MandatoryArg: <deceleration>: "
"Example:     	tank vehicle_stop_named( "tank_stop_for_enemies", 15, 15 );	"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_stop_named( stop_name, acceleration, deceleration )
{
	return _vehicle_stop_named( stop_name, acceleration, deceleration );
}

/*
=============
///ScriptDocBegin
"Name: vehicle_resume_named( <stop_name> )"
"Summary: With a named stop you can setup multiple conditions on which to resume, IE, SHOOTBUILDING, STOPFORAI, , IT Will not resume ( vehicle_resume_named )untill all of the stop conditions are resumed"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <stop_name>: "
"Example:     	tank vehicle_resume_named( "tank_stop_for_enemies" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_resume_named( stop_name )
{
	return _vehicle_resume_named( stop_name );
}

/*
=============
///ScriptDocBegin
"Name: build_is_helicopter( <vehicle_Type> )"
"Summary: Sets this vehicle script to answer is_helicopter as true"
"Module: Entity"
"CallOn: An entity"
"OptionalArg: <vehicle_Type>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_is_helicopter( vehicle_Type )
{
	if ( !IsDefined( level.helicopter_list ) )
		level.helicopter_list = [];
	if ( !IsDefined( vehicle_Type ) )
		vehicle_Type = level.vttype;
	level.helicopter_list[ vehicle_Type ] = true;
}

/*
=============
///ScriptDocBegin
"Name: build_is_airplane( <vehicle_Type> )"
"Summary:  Sets this vehicle script to answer is_airplane as true"
"Module: Entity"
"CallOn: An entity"
"OptionalArg: <vehicle_Type>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_is_airplane( vehicle_Type )
{
	if ( !IsDefined( level.airplane_list ) )
		level.airplane_list = [];
	if ( !IsDefined( vehicle_Type ) )
		vehicle_Type = level.vttype;
	level.airplane_list[ vehicle_Type ] = true;
}

/*
=============
///ScriptDocBegin
"Name: build_single_tread( <vehicle_type> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <vehicle_type>: "
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_single_tread( vehicle_type )
{
	if ( !IsDefined( level.vehicle_single_tread_list ) )
		level.vehicle_single_tread_list = [];
	if ( !IsDefined( vehicle_Type ) )
		vehicle_Type = level.vttype;
	level.vehicle_single_tread_list[ vehicle_Type ] = true;
}

/*
=============
///ScriptDocBegin
"Name: vehicle_set_health( <health> )"
"Summary: Sets health of a vehicle."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <health>: new health of the vehicle"
"Example: veh vehicle_set_health( 100 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
vehicle_set_health( health )
{
	self.health = health + self.healthbuffer;
	self.currenthealth = self.health;
}

isHelicopter()
{
	return _isHelicopter();
}

isAirplane()
{
	return _isAirplane();
}

get_dummy()
{
	return _get_dummy();
}

vehicle_to_dummy()
{
	// create a dummy model that takes the place of a vehicle, the vehicle gets hidden
	AssertEx( !IsDefined( self.modeldummy ), "Vehicle_to_dummy was called on a vehicle that already had a dummy." );
	self.modeldummy = Spawn( "script_model", self.origin );
	self.modeldummy SetModel( self.model );
	self.modeldummy.origin = self.origin;
	self.modeldummy.angles = self.angles;
	self.modeldummy UseAnimTree(#animtree );
	self Hide();
	
	// if we wanted to support driving idle anims on dummy vehicles, we should uncomment
	// the support for it in animate_drive_idle(), and then restart that thread here.

	// move rider characters to dummy model
	self thread model_dummy_death();
	move_riders_here( self.modelDummy );
	move_turrets_here( self.modeldummy );
	move_truck_junk_here( self.modeldummy );
	thread move_lights_here( self.modeldummy );
	move_effects_ent_here( self.modeldummy );
	copy_attachments( self.modeldummy ); // destructables are all Attach()'d. Little bit different but not too tricky

	// flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = true;

	// helicopters do dust kickup fx
	if ( self hasHelicopterDustKickup() )
	{
		self notify( "stop_kicking_up_dust" );
		self thread aircraft_wash_thread( self.modeldummy );
	}

	return self.modeldummy;
}

build_death_jolt_delay( delay )
{
	if ( !IsDefined( level.vehicle_death_jolt ) )
		level.vehicle_death_jolt = [];
	struct = SpawnStruct();
	struct.delay = delay;
	
	level.vehicle_death_jolt[ level.vtclassname ] = struct;
}
