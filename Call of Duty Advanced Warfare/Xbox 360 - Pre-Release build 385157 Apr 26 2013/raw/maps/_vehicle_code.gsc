#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle_aianim;
#include common_scripts\utility;
#using_animtree( "vehicles" );

CONST_BP_HEIGHT		  = 300;

CONST_MPHCONVERSION = 17.6;
HELI_DEFAULT_DECEL	= 10;

// setup_script_gatetrigger( trigger, linkMap )
setup_script_gatetrigger( trigger )
{
	gates = [];
	if ( IsDefined( trigger.script_gatetrigger ) )
		return level.vehicle_gatetrigger[ trigger.script_gatetrigger ];
	return gates;
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
		if ( !IsDefined( level.vehicle_killspawn_groups[ group ] ) )
			level.vehicle_killspawn_groups[ group ] = [];

		level.vehicle_killspawn_groups[ group ][ level.vehicle_killspawn_groups[ group ].size ] = self;
	}

	if ( IsDefined( self.script_deathflag ) )
		thread maps\_spawner::vehicle_spawner_deathflag();

	self thread vehicle_linked_entities_think();

	self.count			 = 1;
	self.spawn_functions = [];
	for ( ;; )
	{
		vehicle = undefined;
		self waittill( "spawned", vehicle );
		self.count--;
		if ( !IsDefined( vehicle ) )
		{
			PrintLn( "Vehicle spawned from spawner at " + self.origin + " but didnt exist!" );
			continue;
		}
		vehicle.spawn_funcs = self.spawn_functions;
		vehicle.spawner		= self;

		vehicle thread maps\_spawner::run_spawn_functions();
	}
}

vehicle_linked_entities_think()
{
	//hides linked entities until spwned, then shows and links them to the spawned vehicle, then deletes them when vehicle dies
	if ( !IsDefined( self.script_vehiclecargo ) )
		return;
	
	if ( !IsDefined( self.script_linkTo ) )
		return;

	//this is just to get at least one of the ents it is linked to...code doesn't really support script_Linking to a prefab
	aLinkedEnts = GetEntArray( self.script_linkTo, "script_linkname" );
	if ( aLinkedEnts.size == 0 )
		return;

	//need cargo to have a unique targetname....we can't get script_linkTo arrays within a prefab,
	//and we can't target a vehicle to the cargo since we need to target it to its nodes
	targetname	= aLinkedEnts[ 0 ].targetname;
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

	array_call( aLinkedEnts, ::Delete );
}

is_trigger_once()
{
	// these triggers only trigger once where vehicle paths trigger everytime a vehicle crosses them
	if ( !IsDefined( self.classname ) )
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
	script_vehicledetour = IsDefined( trigger.script_vehicledetour ) && ( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );

	// ground paths get this value
	detoured  = IsDefined( trigger.detoured ) && !( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );
	gotrigger = true;

	vehicles = undefined;

	while ( gotrigger )
	{
		trigger waittill( "trigger", other );

		if ( IsDefined( trigger.script_vehicletriggergroup ) )
		{
				if ( !IsDefined( other.script_vehicletriggergroup ) )
					continue;
				if ( other.script_vehicletriggergroup != trigger.script_vehicletriggergroup )
					continue;
		}

		if ( IsDefined( trigger.enabled ) && !trigger.enabled )
			trigger waittill( "enable" );

		if ( IsDefined( trigger.script_flag_set ) )
			flag_set( trigger.script_flag_set );

		if ( IsDefined( trigger.script_flag_clear ) )
			flag_clear( trigger.script_flag_clear );


		if ( script_vehicledetour )
			other thread path_detour_script_origin( trigger );
		else if ( detoured && IsDefined( other ) )
			other thread path_detour( trigger );

		trigger script_delay();

		if ( bTriggeronce )
			gotrigger = false;

		if ( IsDefined( trigger.script_vehicleGroupDelete ) )
		{
			if ( !IsDefined( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] ) )
			{
				PrintLn( "failed to find deleteable vehicle with script_vehicleGroupDelete group number: ", trigger.script_vehicleGroupDelete );
				level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] = [];
			}
			array_levelthread( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ], ::deleteEnt );
		}

		if ( script_vehiclespawngroup )
			_scripted_spawn( trigger.script_VehicleSpawngroup );

		if ( gates.size > 0 && bTriggeronce )
			array_levelthread( gates, ::path_gate_open );
		
		if ( IsDefined( trigger.script_VehicleStartMove ) )
		{
			if ( !IsDefined( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ] ) )
			{
				PrintLn( "^3Vehicle start trigger is: ", trigger.script_VehicleStartMove );
				return;
			}
			array_levelthread( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ], ::_gopath );
		}
	}
}

path_detour_get_detourpath( detournode )
{
	detourpath = undefined;
	foreach ( vehicle_detourpath in level.vehicle_detourpaths[ detournode.script_vehicledetour ] )
		if ( vehicle_detourpath != detournode )
			if ( !islastnode( vehicle_detourpath ) )
				detourpath = vehicle_detourpath;
	return detourpath;
}

path_detour_script_origin( detournode )
{
	detourpath = path_detour_get_detourpath( detournode );
	if ( IsDefined( detourpath ) )
		self thread _vehicle_paths( detourpath );
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
		 !IsDefined( detourpath.derailed )
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

	if ( node.detoured && !IsDefined( detourpath.script_vehicledetourgroup ) )
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
			if ( !IsDefined( self.script_vehicledetourgroup ) )
				return;
			if ( detourpath.script_vehicledetourgroup != self.script_vehicledetourgroup )
				return;
		}

		self notify( "newpath" );
		self _SetSwitchNode( detournode, detourpath );
		thread detour_flag( detourpath );
		if ( !islastnode( detournode ) && !( IsDefined( node.scriptdetour_persist ) && node.scriptdetour_persist ) )
			node.detoured = 1;
		self.attachedpath = detourpath;
		thread _vehicle_paths();

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
		self wheeldirectionchange( 1 ); //1 forward
	else
		self wheeldirectionchange( 0 ); // 0 backward
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
	
	stalinggradspawneverybody = ent_flag_exist( "no_riders_until_unload" );

	foreach ( spawner in spawners )
	{
		spawner.count = 1;
		dronespawn	  = false;
		if ( IsDefined( spawner.script_drone ) )
		{
			dronespawn = true;
			spawned	   = dronespawn_bodyonly( spawner );
			spawned maps\_drone_base::drone_give_soul();
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

		if ( !dronespawn && !IsAlive( spawned ) )
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

	if ( !IsDefined( ai ) )
		return false;

	if ( !IsDefined( ai.classname ) )
		return false;

	return ai.classname == "script_model";
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

// this partially supports unload groups for vehicles set to "no_riders_until_unload".
//   it is partial because it will just spawn all the AI in the unload group, even if they've
//   already spawned before.  i.e, it does not keep track of what AI are currently in the vehicle,
//   and which AI have entered.
spawn_unload_group( who )
{
	if ( !IsDefined( who ) )
		return spawn_group();
	
	AssertEx( ( ent_flag_exist( "no_riders_until_unload" ) && ent_flag( "no_riders_until_unload" ) ), "spawn_unload_group only used when no_riders_until_unload specified" );
	
	// get the vehicle spawners
	spawners = get_vehicle_ai_spawners();
	if ( !spawners.size )
		return [];
	
	// filter vehicle spawners by ones for the actual unload group
	group_spawners = [];
	
	classname = self.classname;
    
    if ( IsDefined( level.vehicle_unloadgroups[ classname ] ) && IsDefined( level.vehicle_unloadgroups[ classname ][ who ] ) )
    {
    	// add spawners who's index correspond to the correct ride position.
		group	= level.vehicle_unloadgroups[ classname ][ who ];
		
		foreach( ride_pos in group )
			group_spawners[ group_spawners.size ] = spawners[ ride_pos ];
    	
    	// spawn guys and set their position to be the unload position
		ai = spawn_array( group_spawners );
		
		for ( i = 0; i < group.size; i++ )
    		ai[ i ].script_startingposition = group[ i ];
    	
		ai = array_combine( ai, get_vehicle_ai_riders() );
		ai = sort_by_startingpos( ai );
    	
    	foreach ( guy in ai )
			self thread maps\_vehicle_aianim::guy_enter( guy );
			
		return ai;
    }
    else
    {
    	return spawn_group();
    }
}

sort_by_startingpos( guysarray )
{
	firstarray	= [];
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

setup_groundnode_detour( node )
{
		realdetournode = GetVehicleNode( node.targetname, "target" );
		if ( !IsDefined( realdetournode ) )
			return;
		realdetournode.detoured = 0;
		AssertEx( !IsDefined( realdetournode.script_vehicledetour ), "Detour nodes require one non-detour node before another detournode!" );
		add_proccess_trigger( realdetournode );
}

turn_unloading_drones_to_ai()
{
	unload_group = self get_unload_group();
	foreach ( index, rider in self.riders )
	{
		if ( !IsAlive( rider ) )
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
	if ( !IsDefined( node.target ) )
		return true;
	if ( !IsDefined( GetVehicleNode( node.target, "targetname" ) ) && !IsDefined( get_vehiclenode_any_dynamic( node.target ) ) )
		return true;
	return false;
}

get_path_getfunc( pathpoint )
{
	get_func = ::get_from_vehicle_node;

	// get_func is differnt for struct types and script_origin types of paths
	if ( _isHelicopter() && IsDefined( pathpoint.target ) )
	{
		if ( IsDefined( get_from_entity( pathpoint.target ) ) )
			get_func = ::get_from_entity;
		if ( IsDefined( get_from_spawnstruct( pathpoint.target ) ) )
			get_func = ::get_from_spawnstruct;
	}
	return get_func;
}

node_wait( nextpoint, lastpoint, get_func )
{
	if ( self.attachedpath == nextpoint )
	{
		waittillframeend;
		return;
	}
	
	if( IsDefined( self.unique_id ) )
		node_notify = "node_wait_triggered" + self.unique_id;
	else
		node_notify = "node_wait_triggered"; // "empty" vehicle has no unique id
	
	wait_obj = SpawnStruct();
	wait_til_node_wait_triggered( wait_obj, node_notify, nextpoint, get_func );
	
	wait_obj waittill( node_notify );
}

wait_til_node_wait_triggered( wait_obj, node_notify, nextpoint, get_func )
{
	count = 0;
	while ( IsDefined( nextpoint ) && count < 3 )
	{
		count++;
		thread node_wait_triggered( wait_obj, node_notify, nextpoint );
		
		if ( !IsDefined( nextpoint.target ) )
			return;
		nextpoint = [[ get_func ]]( nextpoint.target );
	}
}

node_wait_triggered( wait_obj, node_notify, node )
{
	self endon( "newpath" );
	
	wait_obj endon( node_notify );
	node waittill( "trigger" );
	wait_obj notify( node_notify );
}

vehicle_paths_non_heli( node )
{

	AssertEx( IsDefined( node ) || IsDefined( self.attachedpath ), "vehicle_path() called without a path" );
	self notify( "newpath" );

	// dynamicpaths unique.  node isn't defined by info vehicle node calls to this function
	if ( IsDefined( node ) )
		self.attachedpath = node;

	pathstart		 = self.attachedpath;
	self.currentNode = self.attachedpath;

	if ( !IsDefined( pathstart ) )
		return;

	self endon( "newpath" );

	pathpoint = pathstart;


	lastpoint = undefined;
	nextpoint = pathstart;
	get_func  = get_path_getfunc( pathstart );

	while ( IsDefined( nextpoint ) )
	{
		node_wait( nextpoint, lastpoint, get_func );

		if ( !IsDefined( self ) )
			return;

		self.currentNode = nextpoint;

		if ( IsDefined( nextpoint.gateopen ) && !nextpoint.gateopen )
			self thread path_gate_wait_till_open( nextpoint ); // threaded because vehicle may Vehicle_SetSpeed( 0, 15 ) and run into the next node

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			self notify( nextpoint.script_noteworthy );
			self notify( "noteworthy", nextpoint.script_noteworthy );
		}

		waittillframeend;// this lets other scripts interupt

		if ( !IsDefined( self ) )
			return;

		if ( IsDefined( nextpoint.script_prefab_exploder ) )
		{
			nextpoint.script_exploder		 = nextpoint.script_prefab_exploder;
			nextpoint.script_prefab_exploder = undefined;
		}

		if ( IsDefined( nextpoint.script_exploder ) )
		{
			delay = nextpoint.script_exploder_delay;
			if ( IsDefined( delay ) )
				level delayThread( delay, ::exploder, nextpoint.script_exploder );
			else
				level exploder( nextpoint.script_exploder );
		}

		if ( IsDefined( nextpoint.script_flag_set ) )
			flag_set( nextpoint.script_flag_set );

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
			flag_clear( nextpoint.script_flag_clear );
		}

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			if ( nextpoint.script_noteworthy == "kill" )
				self _force_kill();
			if ( nextpoint.script_noteworthy == "godon" )
				self.godmode = true;
			if ( nextpoint.script_noteworthy == "godoff" )
				self.godmode = false;
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
		{
			if ( nextpoint.script_turretmg )
				self _mgon();
			else
				self _mgoff();
		}
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


		if ( vehicle_should_unload( ::node_wait, nextpoint ) )
			self thread unload_node( nextpoint );

		// physics vehicles have transmission "forward" or "reverse"

		if ( IsDefined( nextpoint.script_transmission ) )
		{
			self.veh_transmission = nextpoint.script_transmission;
			if ( self.veh_transmission == "forward" )
				self wheeldirectionchange( 1 ); //1 forward
			else
				self wheeldirectionchange( 0 ); // 0 backward
		}

		if ( IsDefined( nextpoint.script_brake ) )
		{
			self.veh_brake = nextpoint.script_brake;
		}

		if ( IsDefined( nextpoint.script_pathtype ) )
			self.veh_pathtype = nextpoint.script_pathtype;

		if ( IsDefined( nextpoint.script_ent_flag_wait ) )
		{
			decel = 35;
			if ( IsDefined( nextpoint.script_decel ) )
			{
				decel = nextpoint.script_decel;
			}

			self Vehicle_SetSpeed( 0, decel );
			self ent_flag_wait( nextpoint.script_ent_flag_wait );
			
			if ( !IsDefined( self ) )
				return;
				
			accel = 60;
			if ( IsDefined( nextpoint.script_accel ) )
			{
				accel = nextpoint.script_accel;
			}

			self ResumeSpeed( accel );
		}
		
		if ( IsDefined( nextpoint.script_delay ) )
		{
			decel = 35;
			if ( IsDefined( nextpoint.script_decel ) )
				decel = nextpoint.script_decel;
			self Vehicle_SetSpeed( 0, decel );
			if ( IsDefined( nextpoint.target ) )
				self thread overshoot_next_node( [[ get_func ] ] ( nextpoint.target ) );
			nextpoint script_delay();
			self notify( "delay_passed" );

			accel = 60;
			if ( IsDefined( nextpoint.script_accel ) )
			{
				accel = nextpoint.script_accel;
			}

			self ResumeSpeed( accel );
		}

		if ( IsDefined( nextpoint.script_flag_wait ) )
		{
			was_stopped = false;
			if ( !flag( nextpoint.script_flag_wait ) || IsDefined( nextpoint.script_delay_post ) )
			{
				was_stopped = true;
				accel		= 5;
				decel		= 35;

				if ( IsDefined( nextpoint.script_accel ) )
					accel = nextpoint.script_accel;

				if ( IsDefined( nextpoint.script_decel ) )
					decel = nextpoint.script_decel;
				self _vehicle_stop_named( "script_flag_wait_" + nextpoint.script_flag_wait, accel, decel );
				self thread overshoot_next_node( [[ get_func ] ] ( nextpoint.target ) );
			}

			// wait at the end point if it has flag wait
			flag_wait( nextpoint.script_flag_wait );
			
			if ( !IsDefined( self ) )
			{
				return;
			}

			////////////////
			// Change to code
			////////////////
			// added script_delay_post to vehicle paths
			if ( IsDefined( nextpoint.script_delay_post ) )
			{
				wait nextpoint.script_delay_post;

				if ( !IsDefined( self ) )
				{
					return;
				}
			}
			////////////////
			
			accel = 10;

			if ( IsDefined( nextpoint.script_accel ) )
			{
				accel = nextpoint.script_accel;
			}

			if ( was_stopped )
			{
				self _vehicle_resume_named( "script_flag_wait_" + nextpoint.script_flag_wait );
			}

			self notify( "delay_passed" );
		}

		////////////////
		// Change to code SECONDARY
		////////////////
		if ( IsDefined( self.set_lookat_point ) )
		{
			self.set_lookat_point = undefined;
			self ClearLookAtEnt();
		}
		////////////////

		if ( IsDefined( nextpoint.script_vehicle_lights_off ) )
			self thread lights_off( nextpoint.script_vehicle_lights_off );
		if ( IsDefined( nextpoint.script_vehicle_lights_on ) )
			self thread lights_on( nextpoint.script_vehicle_lights_on );
		if ( IsDefined( nextpoint.script_forcecolor ) )
			self thread vehicle_script_forcecolor_riders( nextpoint.script_forcecolor );

		lastpoint = nextpoint;
		if ( !IsDefined( nextpoint.target ) )
			break;
		nextpoint = [[ get_func ] ] ( nextpoint.target );
		

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = lastpoint;
			AssertMsg( "can't find nextpoint for node at origin (node targets nothing or different type?): " + lastpoint.origin );
			break;
		}
		else
		{
			if ( islastnode( nextpoint ) || IsDefined( nextpoint.script_unload ) )
			{
				speed = Max( 0.01, Length( self Vehicle_GetVelocity() ) );
				dist = Distance(self.origin, nextpoint.origin);
				stopTime = Max( 0.01, dist / speed );
				self notify( "about_to_stop", stopTime );
			}
		}
	}

	if ( IsDefined( nextpoint.script_land ) )
		self thread _vehicle_landvehicle();

	self notify( "reached_dynamic_path_end" );

	if ( IsDefined( self.script_vehicle_selfremove ) )
	{
		// notify vehicle_badplace to end
		self notify( "delete" );
		self Delete();
	}
}

vehicle_paths_helicopter( node, bhelicopterwaitforstart )
{
	AssertEx( IsDefined( node ) || IsDefined( self.attachedpath ), "vehicle_path() called without a path" );
	self notify( "newpath" );
	self endon( "newpath" );
	self endon( "death" );


	if ( !IsDefined( bhelicopterwaitforstart ) )
		bhelicopterwaitforstart = false;// helicopters emulate StartPath() function waiting for a special scripted notify before going


	// dynamicpaths unique.  node isn't defined by info vehicle node calls to this function
	if ( IsDefined( node ) )
		self.attachedpath = node;

	pathstart		 = self.attachedpath;
	self.currentNode = self.attachedpath;

	if ( !IsDefined( pathstart ) )
		return;

	pathpoint = pathstart;

	// dynamic paths / struct path unique
	if ( bhelicopterwaitforstart )
		self waittill( "start_dynamicpath" );


	lastpoint = undefined;
	nextpoint = pathstart;
	get_func  = get_path_getfunc( pathstart );

	while ( IsDefined( nextpoint ) )
	{

		////////////////
		// Change to code SECONDARY
		////////////////
		if ( IsDefined( nextpoint.script_linkTo ) )
			set_lookat_from_dest( nextpoint );
		////////////////


		heli_wait_node( nextpoint, lastpoint );

		if ( !IsDefined( self ) )
			return;

		self.currentNode = nextpoint;

		if ( IsDefined( nextpoint.gateopen ) && !nextpoint.gateopen )
			self thread path_gate_wait_till_open( nextpoint ); // threaded because vehicle may Vehicle_SetSpeed( 0, 15 ) and run into the next node

		// pretend like helicopter nodes are triggers. 
		nextpoint notify( "trigger", self );

		if ( IsDefined( nextpoint.script_helimove ) )
		{
			self SetYawSpeedByName( nextpoint.script_helimove );
			if ( nextpoint.script_helimove == "faster" )
				self SetMaxPitchRoll( 25, 50 );
		}

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			self notify( nextpoint.script_noteworthy );
			self notify( "noteworthy", nextpoint.script_noteworthy );
		}

		waittillframeend;// this lets other scripts interupt

		if ( !IsDefined( self ) )
			return;

		if ( IsDefined( nextpoint.script_prefab_exploder ) )
		{
			nextpoint.script_exploder		 = nextpoint.script_prefab_exploder;
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
			flag_set( nextpoint.script_flag_set );

		if ( IsDefined( nextpoint.script_ent_flag_set ) )
		{
			self ent_flag_set( nextpoint.script_ent_flag_set );
		}

		if ( IsDefined( nextpoint.script_ent_flag_clear ) )
		{
			self ent_flag_clear( nextpoint.script_ent_flag_clear );
		}

		if ( IsDefined( nextpoint.script_flag_clear ) )
			flag_clear( nextpoint.script_flag_clear );

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			if ( nextpoint.script_noteworthy == "kill" )
				self _force_kill();
			if ( nextpoint.script_noteworthy == "godon" )
				self.godmode = true;
			if ( nextpoint.script_noteworthy == "godoff" )
				self.godmode = false;
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
		{
			if ( nextpoint.script_turretmg )
				self _mgon();
			else
				self _mgoff();
		}
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


		if ( vehicle_should_unload( ::heli_wait_node, nextpoint ) )
			self thread unload_node( nextpoint );

		// physics vehicles have transmission "forward" or "reverse"

		if ( self Vehicle_IsPhysVeh() )
		{
			if ( IsDefined( nextpoint.script_transmission ) )
			{
				self.veh_transmission = nextpoint.script_transmission;
				if ( self.veh_transmission == "forward" )
					self wheeldirectionchange( 1 ); //1 forward
				else
					self wheeldirectionchange( 0 ); // 0 backward
			}

			if ( IsDefined( nextpoint.script_pathtype ) )
				self.veh_pathtype = nextpoint.script_pathtype;
		}

		if ( IsDefined( nextpoint.script_flag_wait ) )
		{
			// helicopters stop on their own because they know to stop at destination for script_flag_wait
			// may have to provide a smoother way to stop and go tho, this is rather arbitrary, for tanks
			// in this case

			// wait at the end point if it has flag wait
			flag_wait( nextpoint.script_flag_wait );


			////////////////
			// Duplicated by Radiant
			////////////////
			// added script_delay_post to vehicle paths
			if ( IsDefined( nextpoint.script_delay_post ) )
				wait nextpoint.script_delay_post;
			////////////////
			
			self notify( "delay_passed" );
		}

		////////////////
		// Change to code SECONDARY
		////////////////
		if ( IsDefined( self.set_lookat_point ) )
		{
			self.set_lookat_point = undefined;
			self ClearLookAtEnt();
		}
		////////////////

		if ( IsDefined( nextpoint.script_vehicle_lights_off ) )
			self thread lights_off( nextpoint.script_vehicle_lights_off );
		if ( IsDefined( nextpoint.script_vehicle_lights_on ) )
			self thread lights_on( nextpoint.script_vehicle_lights_on );
		if ( IsDefined( nextpoint.script_forcecolor ) )
			self thread vehicle_script_forcecolor_riders( nextpoint.script_forcecolor );

		lastpoint = nextpoint;
		if ( !IsDefined( nextpoint.target ) )
			break;
		nextpoint = [[ get_func ] ] ( nextpoint.target );
		

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = lastpoint;
			AssertMsg( "can't find nextpoint for node at origin (node targets nothing or different type?): " + lastpoint.origin );
			break;
		}
	}

	if ( IsDefined( nextpoint.script_land ) )
		self thread _vehicle_landvehicle();

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

/*
=============
///ScriptFieldDocBegin
"Name: .dontunloadonend"
"Summary: dontunloadonend"
"Module: Vehicle"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	
	
	if ( IsDefined( self.dontunloadonend ) )
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
	if ( !IsDefined( vnode ) )
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
	if ( !IsDefined( self.script_vehicle_selfremove ) )
		return false;
	return self.script_vehicle_selfremove;
}

heli_wait_node( nextpoint, lastpoint )
{
	self endon( "newpath" );
	// this handles a single node on helicopter path.  they are script_structs in radiant, or script_origins

	////////////////
	// Change to code SECONDARY
	////////////////
	if ( IsDefined( nextpoint.script_unload ) && IsDefined( self.fastropeoffset ) )
	{
		self notify( "about_to_unload" );
		nextpoint.radius = 2;
		
		// Struct node.ground_pos could be hardcoded to skip undesired traces to
		// other choppers or moving entities that will result in AI dropped in mid air.
		if ( IsDefined( nextpoint.ground_pos ) )
		{
			nextpoint.origin = nextpoint.ground_pos + ( 0, 0, self.fastropeoffset );
		}
		else
		{
			neworg = groundpos( nextpoint.origin ) + ( 0, 0, self.fastropeoffset );
			if ( neworg[ 2 ]              > nextpoint.origin[ 2 ] - 2000 )
			{
				// dont descend if it's going to be a huge drop, the designer may intend for it to drop guys behind a wall
				// where there is no geo for it to align with
				nextpoint.origin = groundpos( nextpoint.origin ) + ( 0, 0, self.fastropeoffset );
			}
		}
		self SetHoverParams( 0, 0, 0 );
	}
	
	//IW6 parachute unload
	if ( IsDefined( nextpoint.script_unload ) && IsDefined( self.parachute_unload ) )
	{
		nextpoint.radius = 100;		
		if ( IsDefined( nextpoint.ground_pos ) )
		{
			nextpoint.origin = nextpoint.ground_pos + ( 0, 0, self.dropoff_height );
		}
		else
		{
			nextpoint.origin = groundpos( nextpoint.origin ) + ( 0, 0, self.dropoff_height );
		}
	
	}
	
	if ( IsDefined( lastpoint ) )
	{
		airResistance = lastpoint.script_airresistance;
		speed		  = lastpoint.speed;
		accel		  = lastpoint.script_accel;
		decel		  = lastpoint.script_decel;
	}
	else
	{
		airResistance = undefined;
		speed		  = undefined;
		accel		  = undefined;
		decel		  = undefined;
	}
	stopnode  = IsDefined( nextpoint.script_stopnode ) && nextpoint.script_stopnode;
	unload	  = IsDefined( nextpoint.script_unload );
	flag_wait = ( IsDefined( nextpoint.script_flag_wait ) && !flag( nextpoint.script_flag_wait ) ); // // if the flag gets set during flight, we should update the setvehgoalpos to not stop
	endOfPath = !IsDefined( nextpoint.target );
	hasDelay  = IsDefined( nextpoint.script_delay );
	if ( IsDefined( nextpoint.angles ) )
		yaw = nextpoint.angles[ 1 ];
	else
		yaw = 0;
	
	if ( self.health <= 0 )
		return;
	origin = nextpoint.origin;
	
	if ( IsDefined( self.heliheightoverride ) )
		origin = ( origin[ 0 ], origin[ 1 ], self.heliheightoverride );	// this is used to force the z of the helipath

	self Vehicle_HeliSetAI( origin, speed, accel, decel, nextpoint.script_goalyaw, nextpoint.script_anglevehicle, yaw, airResistance, hasDelay, stopnode, unload, flag_wait, endOfPath );

	////////////////
	// Duplicated in Radiant
	////////////////
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
	////////////////

	/#
	if ( IsDefined( nextpoint.script_flag_set ) )
		self notify( "reached_current_node", nextpoint, nextpoint.script_flag_set );
	else
		self notify( "reached_current_node", nextpoint );
	#/

	if ( IsDefined( nextpoint.script_firelink ) )
	{
		if ( !IsDefined( level.helicopter_fireLinkFunk ) )
			AssertMsg( "no Fire Link funk.. need maps\_helicopter_globals::init_helicopters();" );
		thread [[ level.helicopter_fireLinkFunk ]]( nextpoint );
	}


	////////////////
	// Duplicated in Radiant
	////////////////
	nextpoint script_delay();
	////////////////
	
	if ( IsDefined( self.path_gobbler ) )
		deletestruct_ref( nextpoint );
}

path_gate_open( node )
{
	node.gateopen = true;
	node notify( "gate opened" );
}

path_gate_wait_till_open( pathspot )
{
	//TODO:  use ent_flag_wait
	self endon( "death" );
	self.waitingforgate = true;
	self _vehicle_stop_named( "path_gate_wait_till_open", 5, 15 );
	pathspot waittill( "gate opened" );
	self.waitingforgate = false;
	if ( self.health > 0 )
	{
		self endon( "death" );
		if ( IsDefined( self.waitingforgate ) && self.waitingforgate )
			return;// ignore resumespeeds on waiting for gate.
		self _vehicle_resume_named( "path_gate_wait_till_open" );
	}
}

remove_vehicle_spawned_thisframe()
{
	wait 0.05;
	self.vehicle_spawned_thisframe = undefined;
}

vehicle_init( vehicle )
{
	Assert( vehicle.classname != "script_model" );
	
	classname = vehicle.classname;
	
	if ( IsDefined( level.vehicle_hide_list[ classname ] ) )
	{
	    foreach ( part in level.vehicle_hide_list[ classname ] )
	        vehicle HidePart( part );
	}

	if ( vehicle.vehicletype == "empty" )
	{
		vehicle thread getonpath();
		return;
	}

	vehicle set_ai_number(); // unique id for each vehicle or ai

	if ( !IsDefined( vehicle.modeldummyon ) )
		vehicle.modeldummyon = false;

	type = vehicle.vehicletype;
	
	// give the vehicle health
	vehicle vehicle_life();

	// set the script_team value used everywhere to determine which team the vehicle belongs to
	vehicle vehicle_setteam();

	// init pointer is specified in the precache script( IE maps\_tiger::main() )
	// only special case gag works should exist in this thread, 
	if ( !IsDefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.classname ] ) )
	{
		PrintLn( "vehicle.classname is: " + vehicle.classname );
		PrintLn( "vehicle.vehicletype is: " + vehicle.vehicletype );
		PrintLn( "vehicle.model is: " + vehicle.model );
	}
	vehicle thread [[ level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.classname ] ] ] ();

	vehicle thread maingun_FX();
	vehicle thread playTankExhaust();

	if ( !IsDefined( vehicle.script_avoidplayer ) )
		vehicle.script_avoidplayer = false;

	if ( IsDefined( level.vehicle_draw_thermal ) )
	{
		if ( level.vehicle_draw_thermal )
		{
			vehicle ThermalDrawEnable();
		}
	}

	vehicle ent_flag_init( "unloaded" );
	vehicle ent_flag_init( "loaded" );
	vehicle.riders		 = [];
	vehicle.unloadque	 = [];// for ai. wait till a vehicle is unloaded all the way
	vehicle.unload_group = "default";

	vehicle.fastroperig = [];
	if ( IsDefined( level.vehicle_attachedmodels ) && IsDefined( level.vehicle_attachedmodels[ classname ] ) )
	{
		rigs	= level.vehicle_attachedmodels[ classname ];
		strings = GetArrayKeys( rigs );
		foreach ( string in strings )
		{
			vehicle.fastroperig			[ string ] = undefined;
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
		vehicle.godmode = true;
	}
	
	vehicle.damage_functions = [];

	// regenerate friendly fire damage
	if ( !vehicle isCheap() || vehicle isCheapShieldEnabled() )
		vehicle thread friendlyfire_shield();

	// handles guys riding and doing stuff on vehicles
	vehicle thread maps\_vehicle_aianim::handle_attached_guys();

	if ( IsDefined( vehicle.script_friendname ) )
		vehicle SetVehicleLookAtText( vehicle.script_friendname, &"" );
	
	// special stuff for unloading
	if ( !vehicle isCheap() )
		vehicle thread vehicle_handleunloadevent();
	
	if ( IsDefined( vehicle.script_dontunloadonend ) )
		vehicle.dontunloadonend = true;
	
	// Shellshock player on main turret fire.
	if ( !vehicle isCheap() )
		vehicle thread vehicle_shoot_shock(); // moved to indiviual tank scripts.

	// make the vehicle rumble
	vehicle thread vehicle_rumble();

	// make vehicle shake physics objects.
	if ( IsDefined( vehicle.script_physicsjolt ) && vehicle.script_physicsjolt )
		vehicle thread physicsjolt_proximity();

	// handle tread effects
	vehicle thread vehicle_treads();

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
		level thread [[ level.vehicleSpawnCallbackThread ] ] ( vehicle );

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
		vehicle thread aircraft_wash_thread();

	// physics vehicles have pathtypes constrained or follow
	if ( vehicle Vehicle_IsPhysVeh() )
	{
		if ( IsDefined( vehicle.script_pathtype ) )
			vehicle.veh_pathtype = vehicle.script_pathtype;
	}

	// spawn the vehicle and it's associated ai
	vehicle spawn_group();
	vehicle thread vehicle_kill();

	vehicle apply_truckjunk();
}

isCheapShieldEnabled()
{
	return IsDefined( level.cheap_vehicles_have_shields ) && level.cheap_vehicles_have_shields;
}

kill_damage( classname )
{
	if ( !IsDefined( level.vehicle_death_radiusdamage ) || !IsDefined( level.vehicle_death_radiusdamage[ classname ] ) )
		return;

	if ( IsDefined( self.deathdamage_max ) )
		maxdamage = self.deathdamage_max;
	else
		maxdamage = level.vehicle_death_radiusdamage[ classname ].maxdamage;
	if ( IsDefined( self.deathdamage_min ) )
		mindamage = self.deathdamage_min;
	else
		mindamage = level.vehicle_death_radiusdamage[ classname ].mindamage;

	if ( IsDefined( level.vehicle_death_radiusdamage[ classname ].delay ) )
		wait level.vehicle_death_radiusdamage[ classname ].delay;

	if ( !IsDefined( self ) )
		return;// deleted in this time.

	if ( level.vehicle_death_radiusdamage[ classname ].bKillplayer )
		level.player EnableHealthShield( false );

	self RadiusDamage( self.origin + level.vehicle_death_radiusdamage[ classname ].offset, level.vehicle_death_radiusdamage[ classname ].range, maxdamage, mindamage, self );

	if ( level.vehicle_death_radiusdamage[ classname ].bKillplayer )
		level.player EnableHealthShield( true );
}

vehicle_kill()
{
	self endon( "nodeath_thread" );
	type			= self.vehicletype;
	classname		= self.classname;
	model			= self.model;
	targetname		= self.targetname;
	attacker		= undefined;
	cause			= undefined;
	weapon			= undefined;
	registered_kill = false;

	while ( 1 )
	{
		// waittill death twice. in some cases the vehicle dies and does a bunch of stuff. then it gets deleted. which it then needs to do more stuff
		if ( IsDefined( self ) )
			self waittill( "death", attacker, cause, weapon );

		if ( !registered_kill )
		{
			registered_kill = true;
			if ( IsDefined( attacker ) && IsDefined( cause ) )
			{
				attacker maps\_player_stats::register_kill( self, cause, weapon );
				if ( IsDefined( self.damage_type ) )
				{
					self.damage_type = undefined;
				}
			}
		
			// specops mission xp
			if ( is_specialop() && !is_survival() && IsDefined( attacker ) && IsPlayer( attacker ) )
			{
				if ( attacker.team != self.script_team )
					attacker thread giveXp( "kill", 500 );
				
				// give xp for killing riders
				if ( IsDefined( self.riders ) )
					foreach ( rider in self.riders )
						if ( IsAlive( rider ) && IsAI( rider ) )
							attacker thread giveXp( "kill" );
			}
			
			self thread helicopter_death_achievement( attacker, cause, weapon );
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

		// if vehicle is gone then delete the ai here.
		if ( !IsDefined( self ) || is_corpse() )
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

			self notify( "delete_destructible" ); // kills some destructible fxs
			return;
		}

		rumblestruct = undefined;
		if ( IsDefined( self.vehicle_rumble_unique ) )
			rumblestruct = self.vehicle_rumble_unique;
		else if ( IsDefined( level.vehicle_rumble_override ) && IsDefined( level.vehicle_rumble_override[ classname ] ) )
			rumblestruct = level.vehicle_rumble_override;
		else if ( IsDefined( level.vehicle_rumble[ classname ] ) )
			rumblestruct = level.vehicle_rumble[ classname ];

		if ( IsDefined( rumblestruct ) )
			self StopRumble( rumblestruct.rumble );
			
		if ( IsDefined( level.vehicle_death_thread[ type ] ) )
			thread [[ level.vehicle_death_thread[ type ] ] ] ();


		// kill riders riders blow up
		self array_levelthread( self.riders, maps\_vehicle_aianim::guy_vehicle_death, attacker, type );

		// does radius damage
		thread kill_damage( classname );
		thread kill_badplace( classname );

		thread kill_lights( classname ); // Nate requested this change as a work around for Bugzilla 87770.
		
		delete_corpses_around_vehicle();

		if ( IsDefined( level.vehicle_deathmodel[ classname ] ) )
			self thread set_death_model( level.vehicle_deathmodel[ classname ], level.vehicle_deathmodel_delay[ classname ] );
		else if ( IsDefined( level.vehicle_deathmodel[ model ] ) )
			self thread set_death_model( level.vehicle_deathmodel[ model ], level.vehicle_deathmodel_delay[ model ] );

		rocketdeath = vehicle_should_do_rocket_death( model, attacker, cause );
		vehOrigin	= self.origin;
		
		thread _kill_fx( model, rocketdeath );

		// all the vehicles get the same jolt..
		if ( self.code_classname == "script_vehicle" )
			self thread kill_jolt( classname );
		
		if ( IsDefined( self.delete_on_death ) )
		{
			wait 0.05;
			if ( !IsDefined( self.dontDisconnectPaths ) && !self Vehicle_IsPhysVeh() )
				self DisconnectPaths();

			self _freevehicle();
			wait 0.05;
			self vehicle_finish_death( model );
			self Delete();
			continue;
		}

		if ( IsDefined( self.free_on_death ) )
		{
			self notify( "newpath" );
			if ( !IsDefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
							
			Vehicle_kill_badplace_forever();
			self _freevehicle();
			return;
		}

		vehicle_do_crash( model, attacker, cause, rocketdeath );
		
        if ( !IsDefined( self ) )
            return; // vehicle deleted during crash wait
		
		if ( !rocketdeath )
			vehOrigin = self.origin;
		if ( IsDefined( level.vehicle_death_earthquake[ classname ] ) )
			earthquake
			(
				level.vehicle_death_earthquake[ classname ].scale	,
				level.vehicle_death_earthquake[ classname ].duration,
				vehOrigin,
				level.vehicle_death_earthquake[ classname ].radius
			 );
		
		wait 0.5;

		if ( is_corpse() )
			continue;
			
		if ( IsDefined( self ) )
		{
			while ( IsDefined( self.dontfreeme ) && IsDefined( self ) )
				wait 0.05;
			if ( !IsDefined( self ) )
				continue;

			if ( self Vehicle_IsPhysVeh() )
			{
				// if it's a physics vehicle then don't free it, since that stops it from doing physics when dead.
				// wait for 0 speed then disconnect paths and kill badplaces.
				
				//4.2011 Sholmes this is erroring out when self is not defined
				while ( IsDefined( self ) && self.veh_speed != 0 )
					wait 1;
				if ( !IsDefined( self ) )
					return;
				self DisconnectPaths();
				self notify( "kill_badplace_forever" );
				self Kill(); // make sure it's dead.
				// terminates the vehicle_paths() thread to stop it from starting the vehicle moving again.
				self notify( "newpath" );
				self Vehicle_TurnEngineOff();
				return;
			}
			else
				self _freevehicle();

			if ( self.modeldummyon )
				self Hide();
		}

		if ( _vehicle_is_crashing() )
		{
			self Delete();
			continue;
		}

	}
}

helicopter_death_achievement( attacker, cause, weapon )
{
	// Kill 2 enemy helicopters without getting hit.
	if ( is_survival() && IsDefined( self ) && self _isHelicopter() && IsPlayer( attacker ) )
	{
		if ( !IsDefined( attacker.achieve_birdie ) )
			attacker.achieve_birdie = 1;
		else
			attacker.achieve_birdie++;
		
		if ( attacker.achieve_birdie == 2 )
			attacker player_giveachievement_wrapper( "BIRDIE" );
		
		attacker waittill( "damage" );
		attacker.achieve_birdie = undefined;
	}
}

_freevehicle()
{
	self FreeVehicle();
	delaythread( 0.05, ::extra_vehicle_cleanup );
}

extra_vehicle_cleanup()
{
	self notify ( "newpath" );
	self.accuracy						  = undefined;
	self.attachedguys					  = undefined;
	self.attackback						  = undefined;
	self.badshot						  = undefined;
	self.badshotcount					  = undefined;
	self.currenthealth					  = undefined;
	self.currentnode					  = undefined;
	self.damage_functions				  = undefined;
	self.delayer						  = undefined;
	self.fastroperig					  = undefined;
	self.getinorgs						  = undefined;
	self.hasstarted						  = undefined;
	self.healthbuffer					  = undefined;
	self.offsetone						  = undefined;
	self.offsetrange					  = undefined;
	self.rocket_destroyed_for_achievement = undefined;
	self.rumble_basetime				  = undefined;
	self.rumble_duration				  = undefined;
	self.rumble_radius					  = undefined;
	self.script_attackai				  = undefined;
	self.script_avoidplayer				  = undefined;
	self.script_attackai				  = undefined;
	self.script_avoidplayer				  = undefined;
	self.script_bulletshield			  = undefined;
	self.script_disconnectpaths			  = undefined;
	self.script_linkname				  = undefined;
	self.script_mp_style_helicopter		  = undefined;
	self.script_team					  = undefined;
	self.script_turret					  = undefined;
	self.script_turretmg				  = undefined;
	self.script_vehicleride				  = undefined;
	self.script_vehiclespawngroup		  = undefined;
	self.script_vehiclestartmove		  = undefined;
	self.shotcount						  = undefined;
	self.shotsatzerospeed				  = undefined;
	self.spawn_funcs					  = undefined;
	self.spawn_functions				  = undefined;
	self.tank_queue						  = undefined;
	self.target							  = undefined;
	self.target_min_range				  = undefined;
	self.troop_cache					  = undefined;
	self.troop_cache					  = undefined;
	self.troop_cache_update_next		  = undefined;
	self.turret_damage_max				  = undefined;
	self.turret_damage_min				  = undefined;
	self.turret_damage_range			  = undefined;
	self.badplacemodifier				  = undefined;
	self.attachedpath					  = undefined;
	self.badplacemodifier				  = undefined;
	self.rumble_randomaditionaltime		  = undefined;
	self.rumble_scale					  = undefined;
	self.rumbleon						  = undefined;
	self.rumbletrigger					  = undefined;
	self.runningtovehicle				  = undefined;
	self.script_nomg					  = undefined;
	self.script_startinghealth			  = undefined;
	self.teleported_to_path_section		  = undefined;
	self.turret_damage_range			  = undefined;
	self.turretaccmaxs					  = undefined;
	self.turretaccmins					  = undefined;
	self.turretfiretimer				  = undefined;
	self.turretonvistarg				  = undefined;
	self.turretonvistarg_failed			  = undefined;
	self.unique_id						  = undefined;
	self.unload_group					  = undefined;
	self.unloadque						  = undefined;
	self.usedpositions					  = undefined;
	self.vehicle_spawner				  = undefined;
	self.waitingforgate					  = undefined;
	self.water_splash_function			  = undefined;
	self.water_splash_reset_function	  = undefined;
	self.offsetzero						  = undefined;
	self.script_accuracy				  = undefined;
	self.water_splash_reset_function	  = undefined;
	self.wheeldir						  = undefined;
	self.dontunloadonend				  = undefined;
	self.dontDisconnectPaths			  = undefined;
	self.script_godmode					  = undefined;
	self.ent_flag						  = undefined;
	self.ent_flag_lock					  = undefined;
	self.export							  = undefined;
	self.godmode						  = undefined;
	self.vehicletype					  = undefined;
	self.vehicle_stop_named				  = undefined;
	self.enable_rocket_death			  = undefined;
	self.touching_trigger_ent			  = undefined;
	self.default_target_vec				  = undefined;
	self.script_badplace				  = undefined;
	self.water_splash_info				  = undefined;
}

_vehicle_is_crashing()
{
	return( IsDefined( self.crashing ) ) && ( self.crashing == true );
}

vehicle_finish_death( model )
{
	self notify ( "death_finished" );
	if ( !IsDefined( self ) )
		return;
		
	self UseAnimTree(#animtree );
	if ( IsDefined( level.vehicle_DriveIdle[ model ] ) )
		self ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
	if ( IsDefined( level.vehicle_DriveIdle_r[ model ] ) )
		self ClearAnim( level.vehicle_DriveIdle_r[ model ], 0 );
}

vehicle_should_do_rocket_death( model, attacker, cause )
{
	//ability to disable by setting this variable to false.
	if ( !IsDefined( self.alwaysRocketDeath ) || self.alwaysRocketDeath == false )
	{
		if ( IsDefined( self.enableRocketDeath ) && self.enableRocketDeath == false )
			return false;
		if ( !IsDefined( cause ) )
			return false;
		if ( !( ( cause == "MOD_PROJECTILE" ) || ( cause == "MOD_PROJECTILE_SPLASH" ) ) )
			return false;
	}

	return vehicle_has_rocket_death( model );
}

vehicle_has_rocket_death( model )
{
	return IsDefined( level.vehicle_death_fx[ "rocket_death" + self.classname ] ) && IsDefined( self.enableRocketDeath ) && self.enableRocketDeath == true;
}

vehicle_do_crash( model, attacker, cause, rocketdeath )
{
	// crazy crashpath stuff.
	crashtype = "tank";
	if ( self Vehicle_IsPhysVeh() )
		crashtype = "physics";
	else if ( IsDefined( self.script_crashtypeoverride ) )
		crashtype = self.script_crashtypeoverride;
	else if ( self _isHelicopter() )
		crashtype = "helicopter";
	else if ( IsDefined( self.currentnode ) && crash_path_check( self.currentnode ) )
		crashtype = "none";

	switch( crashtype )
	{
		case "helicopter":
			self thread helicopter_crash( attacker, cause, rocketdeath );
			break;
	
		case "tank":
			if ( !IsDefined( self.rollingdeath ) )
				self Vehicle_SetSpeed( 0, 25 );
			else
			{
				self Vehicle_SetSpeed( 8, 25 );
				self waittill( "deathrolloff" );
				self Vehicle_SetSpeed( 0, 25 );
			}
	
			self notify( "deadstop" );
			if ( !IsDefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
			if ( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
				self waittill( "animsdone" ); // tankgetout will never get notified if there are no guys getting out

			break;

		case "physics":
			self VehPhys_Crash();		

			self notify( "deadstop" );
			if ( !IsDefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
			if ( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
				self waittill( "animsdone" ); // tankgetout will never get notified if there are no guys getting out
			break;
	}

	if ( IsDefined( level.vehicle_hasMainTurret[ model ] ) && level.vehicle_hasMainTurret[ model ] )
		self ClearTurretTarget();

	if ( self _isHelicopter() )
	{
		if ( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
			self waittill( "crash_done" );
	}
	else
	{
		while ( !is_corpse() && IsDefined( self ) && self Vehicle_GetSpeed() > 0 )
			wait 0.1;
	}

	self notify( "stop_looping_death_fx" );
	
	vehicle_finish_death( model );
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
	if ( !IsDefined( self ) )
		return;
	eModel = _get_dummy();
	if ( IsDefined( self.clear_anims_on_death ) )
		eModel ClearAnim( %root, 0 );
	if ( IsDefined( self ) )
		eModel SetModel( sModel );
}

helicopter_crash( attacker, cause, rocketdeath )
{
	if ( IsDefined( attacker ) && IsPlayer( attacker ) )
		self.achievement_attacker = attacker;
		
	self.crashing = true;

	if ( !IsDefined( self ) )
		return;

	self detach_getoutrigs();
	
	if ( !rocketdeath )
		self thread helicopter_crash_move( attacker, cause );
}

kill_riders( riders )
{
	foreach ( rider in riders )
	{
		if ( !IsAlive( rider ) )
			continue;
/*
=============
///ScriptFieldDocBegin
"Name: .ridingVehicle"
"Summary: ridingVehicle is the vehicle a guy is riding in"
"Module: Vehicle"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/				
		if ( !IsDefined( rider.ridingvehicle ) && !IsDefined( rider.drivingVehicle ) )
			continue;

		if ( IsDefined( rider.magic_bullet_shield ) )
			rider stop_magic_bullet_shield();
		rider Kill();
	}
}

vehicle_rider_death_detection( vehicle, riders )
{
	if ( IsDefined( self.vehicle_position ) && self.vehicle_position != 0 )
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
	self endon( "enable_free_path");

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

_vehicle_landvehicle( neargoal, node )
{
	self notify( "newpath" );
	if ( ! IsDefined( neargoal ) )
		neargoal = 2;
	self SetNearGoalNotifyDist( neargoal );
	self SetHoverParams( 0, 0, 0 );
	self ClearGoalYaw();
	self SetTargetYaw( flat_angle( self.angles )[ 1 ] );
	self _setvehgoalpos_wrap( groundpos( self.origin ), 1 );
	self waittill( "goal" );
}

lights_on( group, classname )
{
	groups = StrTok( group, " " );
	array_levelthread( groups, ::lights_on_internal, classname );
}

group_light( model, name, group )
{
	if ( !IsDefined( level.vehicle_lights_group ) )
		level.vehicle_lights_group = [];
	if ( !IsDefined( level.vehicle_lights_group[ model ] ) )
		level.vehicle_lights_group[ model ] = [];
	if ( !IsDefined( level.vehicle_lights_group[ model ][ group ] ) )
		level.vehicle_lights_group[ model ][ group ] = [];
	foreach ( lightgroup_name in level.vehicle_lights_group[ model ][ group ] )
		if ( name == lightgroup_name )
			return; // this group has already been defined. supporting overrides post precache script. this part doesn't need to be overwritten.
	level.vehicle_lights_group[ model ][ group ][ level.vehicle_lights_group[ model ][ group ].size ] = name;
}

lights_delayfxforframe()
{
	level notify( "new_lights_delayfxforframe" );
	level endon( "new_lights_delayfxforframe" );

	if ( !IsDefined( level.fxdelay ) )
		level.fxdelay = 0;

	level.fxdelay += RandomFloatRange( 0.2, 0.4 );

	if ( level.fxdelay > 2 )
		level.fxdelay = 0;

	wait 0.05;

	level.fxdelay = undefined;
}

kill_lights( model )
{
	lights_off_internal( "all", model );
}

vehicle_aim_turret_at_angle( iAngle )
{
	self endon( "death" );
	vec = AnglesToForward( self.angles + ( 0, iAngle, 0 ) );
	vec *= 10000;
	vec = vec + ( 0, 0, 70 );
	self SetTurretTargetVec( vec );
}

vehicle_landvehicle( neargoal, node )
{
	return _vehicle_landvehicle( neargoal, node );
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
_mount_snowmobile( vehicle, sit_position )
{
	self endon( "death" );
	self endon( "long_death" );
	
	if ( doinglongdeath() )
		return;	
	
	rider_types		 = [];
	rider_types[ 0 ] = "snowmobile_driver";
	rider_types[ 1 ] = "snowmobile_passenger";

	tags						   = [];
	tags[ "snowmobile_driver"	 ] = "tag_driver";
	tags[ "snowmobile_passenger" ] = "tag_passenger";

	rider_type = rider_types[ sit_position ];
	AssertEx( IsDefined( rider_type ), "Tried to make a guy mount a snowmobile but it already had 2 riders!" );
	tag = tags[ rider_type ];

	tag_origin = vehicle GetTagOrigin( tag );
	tag_angles = vehicle GetTagAngles( tag );

	closest_scene_name = undefined;
	closest_org		   = undefined;
	closest_dist	   = 9999999;
	foreach ( scene_name, _ in level.snowmobile_mount_anims[ rider_type ] )
	{
		animation = getanim_generic( scene_name );
		org		  = GetStartOrigin( tag_origin, tag_angles, animation );
		new_dist  = Distance( self.origin, org );
		if ( new_dist < closest_dist )
		{
			closest_dist	   = new_dist;
			closest_org		   = org;
			closest_scene_name = scene_name;
		}
	}

	AssertEx( IsDefined( closest_scene_name ), "Somehow an AI could not find an animation to mount a snowmobile" );

	closest_org			 = drop_to_ground( closest_org );
	self.goalradius		 = 8;
	self.disablearrivals = true;
	self SetGoalPos( closest_org );
	self waittill( "goal" );

	vehicle anim_generic( self, closest_scene_name, tag );
	vehicle thread maps\_vehicle_aianim::guy_enter( self );
	self.disablearrivals = false;
}

waittill_stable( node )
{
	// wait for it to level out before unloading
	offset	   = 12;
	stabletime = 400;
	timer	   = GetTime() + stabletime;

	if ( IsDefined( self.dropoff_height ) )
	{
		origin = groundpos( node.origin ) + ( 0, 0, self.dropoff_height );
		self SetTargetyaw( node.angles[ 1 ] );
		self SetVehGoalPos( origin, true );
		self waittill( "goal" );
	}

	while ( IsDefined( self ) )
	{
		if ( abs( self.angles[ 0 ] ) > offset 
		    || abs( self.angles[ 2 ] ) > offset )
			timer = GetTime() + stabletime;
		if ( GetTime() > timer )
			break;
		wait 0.05;
	}
}

_vehicle_badplace()
{
	if ( !IsDefined( self.script_badplace ) )
		return;
	self endon( "kill_badplace_forever" );
	if ( !self Vehicle_IsPhysVeh() )
		self endon( "death" );
	self endon( "delete" );
	if ( IsDefined( level.custombadplacethread ) )
	{
		self thread [[ level.custombadplacethread ] ] ();
		return;
	}
	hasturret	   = IsDefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ];
	bp_duration	   = 0.5;
	bp_angle_left  = 17;
	bp_angle_right = 17;
	for ( ;; )
	{
		if ( !IsDefined( self ) )
			return;
		if ( !IsDefined( self.script_badplace ) || !self.script_badplace )
		{
			while ( IsDefined( self ) && ( !IsDefined( self.script_badplace ) || !self.script_badplace ) )
				wait 0.5;
			if ( !IsDefined( self ) )
				return;
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

		if ( hasturret )
			bp_direction = AnglesToForward( self GetTagAngles( "tag_turret" ) );
		else
			bp_direction = AnglesToForward( self.angles );

		// have to use unique names for each bad place. if not they will be shared for all vehicles and thats not good. - R
		BadPlace_Arc( self.unique_id + "arc", bp_duration, self.origin, bp_radius * 1.9, CONST_BP_HEIGHT, bp_direction, bp_angle_left, bp_angle_right, "axis", "team3", "allies" );
		BadPlace_Cylinder( self.unique_id + "cyl", bp_duration, self.origin, 200, CONST_BP_HEIGHT, "axis", "team3", "allies" );

		wait bp_duration + 0.05;
	}
}

_vehicle_unload( who )
{
	self notify( "unloading" );	// added this notify since it no longer does the old "unload" notify
	ai = [];
	if ( ent_flag_exist( "no_riders_until_unload" ) )
	{
		ent_flag_set( "no_riders_until_unload" );
		ai = spawn_unload_group( who );
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
	ai = self maps\_vehicle_aianim::animate_guys( "unload" );
// 		if ( IsDefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ] && riders_check() )
// 			self ClearTurretTarget();

	/* 
	I added this bit since there's a bug with this function where if you unload with an unload_group, this function will return
	all of the AI in the vehicle, **including the ones that didn't unload**
	
	- Carlos
	*/
	unloadgroups = level.vehicle_unloadgroups[ self.classname ];
    
    if ( IsDefined( unloadgroups ) )
    {
		ai			 = [];
		unload_group = self get_unload_group();
		foreach ( index, rider in self.riders )
		{
			if ( IsDefined( rider ) && IsDefined( rider.vehicle_position ) && IsDefined( unload_group[ rider.vehicle_position ] ) )
				ai[ ai.size ] = rider;
		}
	}
	
	return ai;
}

lights_off_internal( group, model, classname )
{
    if ( IsDefined( classname ) )
        model = classname;
	else if ( !IsDefined( model ) )
		model = self.classname;
	
	if ( !IsDefined( group ) )
		group = "all";
	if ( !IsDefined( self.lights ) )
		return;
	if ( !IsDefined( level.vehicle_lights_group[ model ][ group ] ) )
	{
		PrintLn( "vehicletype: " + self.vehicletype );
		PrintLn( "classname: " + self.classname );
		PrintLn( "light group: " + group );
		AssertMsg( "lights not defined for this vehicle( see console" );
		return;
	}
	lights = level.vehicle_lights_group[ model ][ group ];

	count				  = 0;
	maxlightstopsperframe = 2;
	if ( IsDefined( self.maxlightstopsperframe ) )
		maxlightstopsperframe = self.maxlightstopsperframe;
	foreach( light in lights )
	{
		template = level.vehicle_lights[ model ][ light ];
		StopFXOnTag( template.effect, self, template.tag );
		count++;
		if ( count >= maxlightstopsperframe )
		{
			count = 0;
			wait 0.05;// hackin around lights limitations.. seee BUGZILLA 87770
		}

		//handle delete while shutting of lights. 
		if ( !IsDefined( self ) )
			return;

		self.lights[ light ] = undefined;
	}
}

lights_on_internal( group, model )
{
	level.lastlighttime = GetTime();
	
	if ( !IsDefined( group ) )
		group = "all";
		
    if ( ! IsDefined( model ) )
    	model = self.classname;	
		
	if ( !IsDefined( level.vehicle_lights_group ) )
		return;		
		
	if ( !IsDefined( level.vehicle_lights_group[ model ] )
			|| !IsDefined( level.vehicle_lights_group[ model ][ group ] )
		 )
		return;
		
	thread lights_delayfxforframe();
	
	if ( !IsDefined( self.lights ) )
		self.lights = [];
		
	lights = level.vehicle_lights_group[ model ][ group ];

	count = 0;

	delayoffsetter = [];
	
	foreach( light in lights )
	{
		if ( IsDefined( self.lights[ light ] ) )
			continue;// light is already on

		template = level.vehicle_lights[ model ][ light ];

		if ( IsDefined( template.delay ) )
			delay = template.delay;
		else
			delay = 0;

		delay += level.fxdelay;
			
		while ( IsDefined( delayoffsetter[ "" + delay ] ) )
			delay += 0.05;// don't start these on the same frame.

		delayoffsetter[ "" + delay ] = true;

		//pass the endon death to noself_delaycall
		self endon( "death" );
		childthread noself_delayCall_proc( ::PlayFXOnTag, delay, template.effect, self, template.tag );

		self.lights[ light ] = true;
		if ( !IsDefined( self ) )
			break;
	}
	level.fxdelay = false;

}

_setvehgoalpos_wrap( origin, bStop )
{
	if ( self.health <= 0 )
		return;
	if ( IsDefined( self.originheightoffset ) )
		origin += ( 0, 0, self.originheightoffset ); // TODO - FIXME: this is temporarily set in the vehicles init_local function working on getting it this requirement removed
	self SetVehGoalPos( origin, bStop );
	//Line( self.origin, origin, (0,1,1), 1, 1, 5000 );
}

helicopter_crash_move( attacker, cause )
{
	self endon( "in_air_explosion" );
	
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

	// make the chopper spin around
	self notify( "newpath" );
	self notify( "deathspin" ); //need to know when deathspin begins (not just newpath)
	indirect_zoff = 0;
	direct		  = false;
	if ( IsDefined( crashLoc.script_parameters ) && crashLoc.script_parameters == "direct" )
		direct = true;
	if ( IsDefined( self.heli_crash_indirect_zoff ) )
	{
		direct		  = false;
		indirect_zoff = self.heli_crash_indirect_zoff;
	}

	if ( direct )
	{
		Assert( IsDefined( crashLoc.radius ) );
		crash_speed = 60;
		self Vehicle_SetSpeed( crash_speed, 15, 10 );
		self SetNearGoalNotifyDist( crashLoc.radius );
		self SetVehGoalPos( crashLoc.origin, 0 );
		self thread helicopter_crash_flavor( crashloc.origin, crash_speed );
		self waittill_any( "goal", "near_goal" );
	}
	else
	{
		indirect_target = ( crashLoc.origin[ 0 ], crashLoc.origin[ 1 ], self.origin[ 2 ] + indirect_zoff );
		if ( IsDefined( self.heli_crash_lead ) )
		{	// continue with current velocity for lead time
			indirect_target = self.origin + ( self.heli_crash_lead * ( self Vehicle_GetVelocity() ) );
			indirect_target = ( indirect_target[ 0 ], indirect_target[ 1 ], indirect_target[ 2 ] + indirect_zoff );
		}
		// move chopper closer to crash point
		self Vehicle_SetSpeed( 40, 10, 10 );
		self SetNearGoalNotifyDist( 300 );
		self SetVehGoalPos( indirect_target, 1 );
		self thread helicopter_crash_flavor( indirect_target, 40 );

		msg = "blank";

		while ( msg != "death" )
		{
			msg = self waittill_any( "goal", "near_goal", "death" );
			// waittill_any ends on "death"
			if ( !IsDefined( msg ) && !IsDefined( self ) )
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

helicopter_crash_flavor( target_origin, crash_speed )
{
	self endon( "crash_done" );
	self ClearLookAtEnt();
	
	style = 0;
	if ( IsDefined( self.preferred_crash_style ) )
	{
		style = self.preferred_crash_style;
	
		if ( self.preferred_crash_style < 0 ) // set preferred_crash_style to -1 to get random crash, otherwise crashes should default to old school crashing
		{
			//style_chance = [1,2,2,1];		// inair isn't ready yet
			//total		   = 6;
			style_chance   = [ 1, 2, 2 ];
			total		   = 5;
			rnd			   = RandomInt( total );
			chance		   = 0;
			foreach ( i, val in style_chance )
			{
				chance += val;
				if ( rnd < chance )
				{
					style = i;
					break;
				}
			}
		}
	}
	
	switch( style )
	{
		case 1:
			self thread helicopter_crash_zigzag();
			break;
		case 2:
			self thread helicopter_crash_directed( target_origin, crash_speed );
			break;
		case 3:
			self thread helicopter_in_air_explosion();
			break;
		case 0:
		default: // this should be the default 
			self thread helicopter_crash_rotate();
			break;
	}
}

helicopter_in_air_explosion()
{
	self notify( "crash_done" );//cause the heli to explode
	self notify( "in_air_explosion" );//stop the parent thread
}

helicopter_crash_directed( target_origin, crash_speed )
{
	self endon( "crash_done" );
	self ClearLookAtEnt();
	
	// find the closest set of 90 from the yaw to target
	self SetMaxPitchRoll( RandomIntRange( 20, 90 ), RandomIntRange( 5, 90 ) );
	self SetYawSpeed( 400, 100, 100 );
	angleoff = 90 * RandomIntRange( -2, 3 );
	for ( ;; )
	{
		totarget = target_origin - self.origin;
		yaw		 = VectorToYaw( totarget );
		yaw += angleoff;
		self SetTargetYaw( yaw );
		wait 0.1;
	}	
}

helicopter_crash_zigzag()
{
	self endon( "crash_done" );
	self ClearLookAtEnt();

	//self SetMaxPitchRoll( 150, 600 );
	self SetYawSpeed( 400, 100, 100 );
	dir = RandomInt( 2 );
	for ( ;; )
	{
		if ( !IsDefined( self ) )
			return;
		iRand = RandomIntRange( 20, 120 );
		if ( dir )
			self SetTargetYaw( self.angles[ 1 ] + iRand );
		else
			self SetTargetYaw( self.angles[ 1 ] - iRand );
		dir	  = 1 - dir;
		rtime = RandomFloatRange( 0.5, 1.0 );
		wait rtime;
	}
}

helicopter_crash_rotate()
{
	self endon( "crash_done" );
	self ClearLookAtEnt();

	//self SetMaxPitchRoll( 150, 600 );
	self SetYawSpeed( 400, 100, 100 );
	for ( ;; )
	{
		if ( !IsDefined( self ) )
			return;
		iRand = RandomIntRange( 90, 120 );
		self SetTargetYaw( self.angles[ 1 ] + iRand );
		wait 0.5;
	}
}

get_unused_crash_locations()
{
	unusedLocations	= [];
	
	level.helicopter_crash_locations = array_removeundefined( level.helicopter_crash_locations );
	foreach ( location in level.helicopter_crash_locations )
	{
		if ( IsDefined( location.claimed ) )
			continue;
		unusedLocations[ unusedLocations.size ] = location;
	}
	return unusedLocations;
}


detach_getoutrigs()
{
	if ( !IsDefined( self.fastroperig ) )
		return;
	if ( ! self.fastroperig.size )
		return;
	keys = GetArrayKeys( self.fastroperig );
	for ( i = 0; i < keys.size; i++ )
	{
		self.fastroperig[ keys[ i ] ] Unlink();
	}
}

_get_dummy()
{
	if ( self.modeldummyon )
		eModel = self.modeldummy;
	else
		eModel = self;
	return eModel;
}

crash_path_check( node )
{
	// find a crashnode on the current path
	// this only works on ground info_vehicle_node vheicles. not dynamic helicopter script_origin paths. they have their own dynamic crashing.
	targ = node;
	
	previous_nodes = [];
	
	while ( IsDefined( targ ) )
	{
		if ( ( IsDefined( targ.detoured ) ) && ( targ.detoured == 0 ) )
		{
			detourpath = path_detour_get_detourpath( GetVehicleNode( targ.target, "targetname" ) );
			if ( IsDefined( detourpath ) && IsDefined( detourpath.script_crashtype ) )
				return true;
		}
		
		previous_nodes[previous_nodes.size] = targ;
		
		if ( IsDefined( targ.target ) )
			targ = GetVehicleNode( targ.target, "targetname" );
		else
			targ = undefined;
		
		if ( IsDefined(targ) && array_contains( previous_nodes, targ ))
			break;
	}
	return false;

}

vehicle_kill_badplace_forever()
{
	self notify( "kill_badplace_forever" );
}

kill_jolt( classname )
{
	if ( IsDefined( level.vehicle_death_jolt[ classname ] ) )
	{
		self.dontfreeme = true;
		wait level.vehicle_death_jolt[ classname ].delay;// this is all that exists currently, not to elaborate untill needed.
	}
	if ( !IsDefined( self ) )
		return;
	self JoltBody( ( self.origin + ( 23, 33, 64 ) ), 3 );
	wait 2;
	if ( !IsDefined( self ) )
		return;
	self.dontfreeme = undefined;
}

_kill_fx( model, rocketdeath )
{
	if ( self isDestructible() )
		return;
		
	level notify( "vehicle_explosion", self.origin );
	self notify( "explode", self.origin );
	
	if ( IsDefined( self.ignore_death_fx ) && self.ignore_death_fx )
		return;
		
	type = self.vehicletype;
	classname = self.classname;

	if ( rocketdeath )
		classname = "rocket_death" + classname;
	
	foreach( struct in 	level.vehicle_death_fx[ classname ] )
		thread kill_fx_thread( model, struct, type );
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

	if ( !IsDefined( self ) )
	{
		// self may have been removed during the wait
		return;
	}

	if ( IsDefined( struct.notifyString ) )
		self notify( struct.notifyString );

	eModel = _get_dummy();
	if ( IsDefined( struct.selfDeleteDelay ) )
		self delayCall( struct.selfDeleteDelay, ::Delete );
	if ( IsDefined( struct.effect ) )
	{
		if ( ( struct.bEffectLooping ) && ( !IsDefined( self.delete_on_death ) ) )
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
		{
			PlayFXOnTag( struct.effect, deathfx_ent(), struct.tag );
			if ( IsDefined( struct.remove_deathfx_entity_delay ) )
				deathfx_ent() delayCall( struct.remove_deathfx_entity_delay, ::Delete );
			
		}
		else
		{
			forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin;
			PlayFX( struct.effect, eModel.origin, forward );
		}
	}

	if ( ( IsDefined( struct.sound ) ) && ( !IsDefined( self.delete_on_death ) ) )
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

death_firesound( sound )
{
	self thread play_loop_sound_on_tag( sound, undefined, false, true );
	self waittill_any( "fire_extinguish", "stop_crash_loop_sound" );
	if ( !IsDefined( self ) )
	{
		IPrintLn( "^1DEBUG: Infinite looping sound for a vehicle could be happening right now..." );
		return;
	}
	self notify( "stop sound" + sound );
}

deathfx_ent()
{
	if ( !IsDefined( self.deathfx_ent ) )
	{
		ent	   = Spawn( "script_model", ( 0, 0, 0 ) );
		emodel = _get_dummy();
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

playLoopedFxontag( effect, durration, tag )
{
	eModel		 = _get_dummy();
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
	effectorigin.angles		= self GetTagAngles( tag );
	effectorigin.origin		= self GetTagOrigin( tag );
	effectorigin.forwardvec = AnglesToForward( effectorigin.angles );
	effectorigin.upvec		= AnglesToUp( effectorigin.angles );
	while ( IsDefined( self ) && self.code_classname == "script_vehicle" && self Vehicle_GetSpeed() > 0 )
	{
		eModel					= _get_dummy();
		effectorigin.angles		= eModel GetTagAngles( tag );
		effectorigin.origin		= eModel GetTagOrigin( tag );
		effectorigin.forwardvec = AnglesToForward( effectorigin.angles );
		effectorigin.upvec		= AnglesToUp( effectorigin.angles );
		wait 0.05;
	}
}

kill_badplace( classname )
{
	if ( !IsDefined( level.vehicle_death_badplace[ classname ] ) )
		return;
	struct = level.vehicle_death_badplace[ classname ];
	if ( IsDefined( struct.delay ) )
		wait struct.delay;
	if ( !IsDefined( self ) )
		return;
	BadPlace_Cylinder( "vehicle_kill_badplace", struct.duration, self.origin, struct.radius, struct.height, struct.team1, struct.team2 );
}

turret_deleteme( turret )
{
	if ( IsDefined( self ) )
		if ( IsDefined( turret.deletedelay ) )
			wait turret.deletedelay;
	if ( IsDefined( turret ) )
		turret Delete();
}

apply_truckjunk()
{
	if ( !IsDefined( self.truckjunk ) )
		return;

	junkarray = self.truckjunk;
	
	self.truckjunk = [];
	foreach ( truckjunk in junkarray )
	{
		if ( IsDefined( truckjunk.spawner ) )
		{
			model		  = spawn_tag_origin();
			model.spawner = truckjunk.spawner;
		}
		else
		{
			model = Spawn( "script_model", self.origin );
			model SetModel( truckjunk.model );
		}
		tag = "tag_body";
		
		if ( IsDefined( truckjunk.script_ghettotag ) )
		{
			model.script_ghettotag = truckjunk.script_ghettotag;
			model.base_origin	   = truckjunk.origin;
			model.base_angles	   = truckjunk.angles;
			tag					   = truckjunk.script_ghettotag;
		}
		
		if ( IsDefined( truckjunk.destroyEfx ) )
		    truckjunk thread truckjunk_dyn( model );
			
		if ( IsDefined( truckjunk.script_noteworthy ) )
			model.script_noteworthy = truckjunk.script_noteworthy;

		if ( IsDefined( truckjunk.script_parameters ) )
			model.script_parameters = truckjunk.script_parameters;
		
		model LinkTo( self, tag, truckjunk.origin, truckjunk.angles );
		
		if ( IsDefined( truckjunk.destructible_type ) )
		{
		    model.destructible_type = truckjunk.destructible_type;
    		model common_scripts\_destructible::setup_destructibles( true );
    	}

		self.truckjunk[ self.truckjunk.size ] = model;
	}
}

truckjunk_dyn( model )
{
    model endon ( "death" );
    model SetCanDamage( true );
    model.health = 8000;
    model waittill ( "damage" );
    model Hide();
    ent = spawn_tag_origin();
	ent.origin = model.origin;
	ent.angles = model.angles;
    ent LinkTo( model );
    PlayFXOnTag( self.destroyEfx, ent, "tag_origin" );
}

truckjunk()
{
	Assert( IsDefined( self.target ) );
	spawner = GetEnt( self.target, "targetname" );
	Assert( IsDefined( spawner ) );
	Assert( IsSpawner( spawner ) );

	ghettotag = ghetto_tag_create( spawner );

	if ( IsSpawner( self ) )
		ghettotag.spawner = self;
	if ( IsDefined( self.targetname ) )
	{
		targeting_spawner = GetEnt( self.targetname, "target" );
		if ( IsSpawner( targeting_spawner ) )
			ghettotag.spawner = targeting_spawner;
	}	
		
	if ( IsDefined( self.script_noteworthy ) )
		ghettotag.script_noteworthy = self.script_noteworthy;
	if ( IsDefined( self.script_parameters ) )
		ghettotag.script_parameters = self.script_parameters;
		
	if ( IsDefined( self.script_fxid ) )
		ghettotag.destroyEfx = getfx( self.script_fxid );

	if ( !IsDefined( spawner.truckjunk ) )
		spawner.truckjunk = [];
	if ( IsDefined( self.script_startingposition ) )
		ghettotag.script_startingposition = self.script_startingposition;
		
    if ( IsDefined( self.destructible_type ) )
    {
        precache_destructible( self.destructible_type );
        ghettotag.destructible_type = self.destructible_type;
    }
	spawner.truckjunk[ spawner.truckjunk.size ] = ghettotag;

    // it's a struct.
    if ( !IsDefined( self.classname ) )
        return;
	if ( IsSpawner( self ) )
		return;
        
	self Delete();
}

ghetto_tag_create( target )
{
		struct = SpawnStruct();
		
		tag = "tag_body";
		
		if ( IsDefined( self.script_ghettotag ) )
		{
			tag						= self.script_ghettotag;
			struct.script_ghettotag = self.script_ghettotag;
		}
	
		struct.origin = self.origin - target GetTagOrigin( tag );
		
		if ( !IsDefined( self.angles ) )
			angles = ( 0, 0, 0 );
		else
			angles = self.angles;
	
		struct.angles = angles - target GetTagAngles( tag );
		struct.model  = self.model;
		
		if ( IsDefined( self.script_modelname ) )
		{
		    PreCacheModel( self.script_modelname );
		    struct.model = self.script_modelname;
		}
		
		Assert( IsDefined( struct.model ) );
		
		if ( IsDefined( struct.targetname ) )
			level.struct_class_names[ "targetname" ][ struct.targetname ] = undefined;// done with this forever. don't stick around
		if ( IsDefined( struct.target ) )
			level.struct_class_names[ "target" ][ struct.target ] = undefined;// done with this forever. don't stick around
		return struct;
}

_getvehiclespawnerarray( targetname )
{
	vehicles = GetEntArray( "script_vehicle", "code_classname" );
	if ( IsDefined( targetname ) )
	{
		newArray = [];
		foreach ( vehicle in vehicles )
		{
			if ( !IsDefined( vehicle.targetname ) )
				continue;
			if ( vehicle.targetname == targetname )
				newArray = array_add( newArray, vehicle );
		}
		vehicles = newArray;
	}

	array = [];
	foreach ( vehicle in vehicles )
	{
		if ( IsSpawner( vehicle ) )
			array[ array.size ] = vehicle;
	}
	return array;
}

_getvehiclespawnerarray_by_spawngroup( spawngroup )
{
	spawners = _getvehiclespawnerarray();
	array	 = [];
	foreach ( spawner in spawners )
		 if ( IsDefined( spawner.script_VehicleSpawngroup ) && spawner.script_VehicleSpawngroup == spawngroup )
			array[ array.size ] = spawner;

	return array;
}

manual_tag_linkto( entity, tag )
{
	for ( ;; )
	{
		if ( !IsDefined( self ) )
			break;
		if ( !IsDefined( entity ) )
			break;

		org = entity GetTagOrigin( tag );
		ang = entity GetTagAngles( tag );
		
		self.origin = org;
		self.angles = ang;
		wait( 0.05 );
	}
}

humvee_antenna_animates( anims )
{
	self UseAnimTree(#animtree );
	humvee_antenna_animates_until_death( anims );
	if ( !IsDefined( self ) )
		return;
		
	self ClearAnim( anims[ "idle" ] , 0 );
	self ClearAnim( anims[ "rot_l" ], 0 );
	self ClearAnim( anims[ "rot_r" ], 0 );
}

humvee_antenna_animates_until_death( anims )
{
	self endon( "death" );
	for ( ;; )
	{
		weight = self.veh_speed / 18;
		if ( weight <= 0.0001 )
			weight = 0.0001;
			
		rate = RandomFloatRange( 0.3, 0.7 );
		self SetAnim( anims[ "idle" ], weight, 0, rate );
		
		rate = RandomFloatRange( 0.1, 0.8 );
		self SetAnim( anims[ "rot_l" ], 1, 0, rate );

		rate = RandomFloatRange( 0.1, 0.8 );
		self SetAnim( anims[ "rot_r" ], 1, 0, rate );

		wait( 0.5 );
	}
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

update_steering( vehicle )
{
	if ( vehicle.update_time == GetTime() )
		return vehicle.steering;
	
	vehicle.update_time = GetTime();
	
	if ( vehicle.steering_enable )
	{
		steering_goal = clamp( 0 - vehicle.angles[ 2 ], 0 - vehicle.steering_maxroll, vehicle.steering_maxroll ) / vehicle.steering_maxroll;
		if ( IsDefined( vehicle.leanAsItTurns ) && vehicle.leanAsItTurns )
		{
			vehicle_steering = vehicle Vehicle_GetSteering();
			vehicle_steering = vehicle_steering * -1.0;
			steering_goal += vehicle_steering;
			if ( steering_goal != 0 )
			{
				goal_factor = 1.0 / abs( steering_goal );
				if ( goal_factor < 1 )
					steering_goal *= goal_factor;
			}
		}
		delta = steering_goal - vehicle.steering;
		if ( delta != 0 )
		{
			factor = vehicle.steering_maxdelta / abs( delta );
			if ( factor < 1 )
				delta *= factor;
			vehicle.steering += delta;
		}
	}
	else
	{
		vehicle.steering = 0;
	}
	return vehicle.steering;
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

	if ( !IsDefined( viewTarget ) )
		return;

	self SetLookAtEnt( viewTarget );
	self.set_lookat_point = true;
}

damage_hint_bullet_only()
{

	level.armorDamageHints	   = false;
	self.displayingDamageHints = false;
	self thread damage_hints_cleanup();

	while ( IsDefined( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if ( !IsPlayer( attacker ) )
			continue;
		if ( IsDefined( self.has_semtex_on_it ) )
			continue;

		type = ToLower( type );

		switch( type )
		{
			case "mod_pistol_bullet":
			case "mod_rifle_bullet":
			case "bullet":
				if ( !level.armorDamageHints )
				{
					if ( IsDefined( level.thrown_semtex_grenades ) && level.thrown_semtex_grenades > 0 )
						break;
						
					level.armorDamageHints	   = true;
					self.displayingDamageHints = true;
					attacker display_hint( "invulerable_bullets" );
					wait( 4 );
					level.armorDamageHints = false;
					if ( IsDefined( self ) )	// it could have been deleted during the 4 second wait
						self.displayingDamageHints = false;
					break;
				}
		}
	}
}

damage_hints()
{

	level.armorDamageHints	   = false;
	self.displayingDamageHints = false;
	self thread damage_hints_cleanup();

	while ( IsDefined( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if ( !IsPlayer( attacker ) )
			continue;
		if ( IsDefined( self.has_semtex_on_it ) )
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
					if ( IsDefined( level.thrown_semtex_grenades ) && level.thrown_semtex_grenades > 0 )
						break;
						
					level.armorDamageHints	   = true;
					self.displayingDamageHints = true;
					if ( ( type == "mod_grenade" ) || ( type == "mod_grenade_splash" ) )
						attacker display_hint( "invulerable_frags" );
					else
						attacker display_hint( "invulerable_bullets" );
					wait( 4 );
					level.armorDamageHints = false;
					if ( IsDefined( self ) )	// it could have been deleted during the 4 second wait
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

copy_attachments( modeldummy )
{
	// does all attachments
	attachedModelCount = self GetAttachSize();
	attachedModels	   = [];
	for ( i = 0; i < attachedModelCount; i++ )
		attachedModels[ i ] = ToLower( self GetAttachModelName( i ) );

	for ( i = 0; i < attachedModels.size; i++ )
		modeldummy Attach( attachedModels[ i ], ToLower( self GetAttachTagName( i ) ) );
}

lights_off( group, model, classname )
{
	groups = StrTok( group, " ", model );
	array_levelthread( groups, ::lights_off_internal, model, classname );
}

aircraft_wash_thread( model ) 
{
	self endon( "death" );
	self endon( "death_finished" );
	self notify( "stop_kicking_up_dust" );
	self endon( "stop_kicking_up_dust" );

//	Assert( IsDefined( self.vehicletype ) );

	min_height = 350;	
	max_height = 2000;
	
	if ( IsDefined( level.treadfx_maxheight ) )
		max_height = level.treadfx_maxheight;

	min_fraction = 100 / max_height;

	max_rate = 0.15;
	min_rate = 0.05;

	// Delay the initial rate slightly when we first spawn
	rate = 0.5;
	
	max_trace_frames = 3;
	trace_count = max_trace_frames;
	
	is_plane = _isAirplane();
	if ( is_plane )
		rate = 0.15;

	trace = undefined;
	d	  = undefined;

	trace_ent = self;
	if ( IsDefined( model ) )
		trace_ent = model;
		
	forward = ( 0, 0, 1 );
	bank = "";
	for ( ;; )
	{
		wait( rate );

		down_vector = AnglesToUp( trace_ent.angles ) * -1;
		
		trace_count++;
		if ( trace_count > max_trace_frames )
		{
			trace_count = max_trace_frames;
			trace = BulletTrace( trace_ent.origin, trace_ent.origin + down_vector * max_height, false, trace_ent );
		}

		// We didn't hit anything or it was too close
		if ( trace[ "fraction" ] == 1 || trace[ "fraction" ] < min_fraction )
			continue;

		dist = Distance( trace_ent.origin, trace[ "position" ] );
		treadfx = get_wash_fx( self, trace, down_vector, dist );

		if ( !IsDefined( treadfx ) )
			continue;

		// lerp the rate between min_height and max_height
		rate = ( ( dist - min_height ) / ( max_height - min_height ) ) * ( max_rate - min_rate ) + min_rate;
		rate = max( rate, min_rate );

		if ( !IsDefined( trace ) )
			continue;

		if ( !IsDefined( trace[ "position" ] ) )
			continue;

		fx_origin = trace[ "position" ];
		fx_normal = trace[ "normal" ];
				
		dist = VectorDot( ( fx_origin - trace_ent.origin ), fx_normal );
		pos = trace_ent.origin + ( dist * fx_normal );
		forward = fx_origin - pos;

		// Don't do the fx on a straight vertical wall
		if ( VectorDot( trace[ "normal" ], ( 0, 0, 1 ) ) < -0.99 )
			continue;
				
		if ( Length( forward ) < 1 )
		{
			forward = AnglesToForward( trace_ent.angles + ( 90, 0, 0 ) );
			treadfx = get_wash_fx( self, trace, ( 0, 0, 1 ), dist );

			if ( !IsDefined( treadfx ) )
				continue;
		}

		// avoid SRE if our forward vector is too parallel/antiparallel to the up vector
		if ( Abs( VectorDot( VectorNormalize( forward ), ( 0, 0, 1 ) ) ) > .999 )
			continue;
		
//		thread debug_draw_arrow( fx_origin, forward );
		PlayFX( treadfx, fx_origin, ( 0, 0, 1 ), forward );
	}
}

/#
debug_draw_arrow( origin, forward )
{
	timer = GetTime() + 5000;
	while ( GetTime() < timer )
	{
		wait( 0.05 );
		maps\_debug::drawarrow( origin, VectorToAngles( forward ) );
	}
}
#/

CONST_LOW_BANK		  = 0.97;
CONST_MED_BANK		  = 0.92;
CONST_LOW_DIST		  = 500;
CONST_MED_DIST		  = 1000;
get_wash_fx( vehicle, trace, down_vector, dist )
{
	surface = trace[ "surfacetype" ];
	bank = undefined;
	dot = VectorDot( ( 0, 0, -1 ), down_vector );
	
	if ( dot >= CONST_LOW_BANK )
		bank = undefined;
	else if ( dot >= CONST_MED_BANK )
		bank = "_bank";
	else
		bank = "_bank_lg";
	
//		if ( dist <= CONST_LOW_DIST )
//			fx_height = "low";
//		else if ( dist <= CONST_MED_DIST )
//			fx_height = "med";
//		else
//			fx_height = "high";
	return get_wash_effect( vehicle.classname, surface, bank );
}

get_wash_effect( classname, surface, bank )
{
	if ( IsDefined( bank ) )
	{
		bank_surface = surface + bank;
		if ( !IsDefined( level._vehicle_effect[ classname ][ bank_surface ] ) && surface != "default")
		{
			return get_wash_effect( classname, "default", bank );
		}
		else
		{
			return level._vehicle_effect[ classname ][ bank_surface ];
		}
	}

	return get_vehicle_effect( classname, surface );
}

get_vehicle_effect( classname, surface )
{
	if ( !IsDefined( level._vehicle_effect[ classname ][ surface ] ) && surface != "default" )
	{
		return get_vehicle_effect( classname, "default" );
	}
	else
	{
		return level._vehicle_effect[ classname ][ surface ];
	}

	return undefined;
}

no_treads()
{
	return ( _isHelicopter() || _isAirplane() );
}

vehicle_treads()
{
    tread_class = self.classname;
    
	if ( !IsDefined( level._vehicle_effect[ tread_class ] ) )
		return;

	if ( no_treads() )
		return;

	if ( IsDefined( level.tread_override_thread ) )
	{
		self thread [[ level.tread_override_thread ] ] (	"tag_origin", "back_left", ( 160, 0, 0 ) );
		return;
	}

	// vehicles such as snowmobiles and motorcycles should only do one treadfx in the center of two tags

	if ( IsDefined( level.vehicle_single_tread_list ) && IsDefined( level.vehicle_single_tread_list[self.vehicletype] ) )
		self thread do_single_tread();
	else
		self thread do_multiple_treads();
}

do_multiple_treads()
{
	self endon ( "death" );
	self endon( "kill_treads_forever" );

	while ( true )
	{
		scale = tread_wait();
		if ( scale == -1 )
		{
			wait 0.1;
			continue;
		}
		
		prof_begin( "treads" );
		dummy = self _get_dummy();
		self tread( dummy, scale, "tag_wheel_back_left", "back_left", false );
		wait 0.05;
		self tread( dummy, scale, "tag_wheel_back_right", "back_right", false );
		wait 0.05;
		prof_end( "treads" );
	}
}

tread_wait()
{
	speed = self Vehicle_GetSpeed();
	if ( ! speed )
		return -1;
	
	speed *= CONST_MPHCONVERSION;
	waitTime = ( 1 / speed );
	waitTime = clamp( ( waitTime * 35 ), 0.1, 0.3 );
	
	if ( IsDefined( self.treadfx_freq_scale ) )
	{
	 	//give vehicles a chance to scale the frequency of treadFX for special circumstances
		waitTime *= self.treadfx_freq_scale;
	}	
	
	wait waitTime;	
	return waitTime;
}

tread( dummy, scale, tagname, side, do_second_tag, secondTag )
{
	treadfx = get_treadfx( self, side );
	if ( !IsDefined( treadfx ) )
		return;
		
	ang			 = dummy GetTagAngles( tagname );
	forwardVec	 = AnglesToForward( ang );
	effectOrigin = self GetTagOrigin( tagname );

	// if two tags then use the center between the two
	if ( do_second_tag )
	{
		secondTagOrigin = self GetTagOrigin( secondTag );
		effectOrigin	= ( effectOrigin + secondTagOrigin ) / 2;
	}
	
	PlayFX( treadfx, effectOrigin, AnglesToUp( ang ), ( forwardVec * scale ) );
}

get_treadfx( vehicle, side )
{
	surface = self GetWheelSurface( side );
	if ( !IsDefined( vehicle.vehicletype ) )
	{
		treadfx = -1;
		return treadfx;
	}

	classname = vehicle.classname;
	return get_vehicle_effect( classname, surface );
	}
	
do_single_tread()
{
	self endon ( "death" );
	self endon( "kill_treads_forever" );

	while ( true )
	{
		scale = tread_wait();
		if ( scale == -1 )
		{
			wait 0.1;
			continue;
		}

//		prof_begin( "treads_single" );
		dummy = self _get_dummy();
		dummy tread( dummy, scale, "tag_wheel_back_left", "back_left", true, "tag_wheel_back_right" );
//		prof_end( "treads_single" );
	}
}

_isHelicopter()
{
	return IsDefined( level.helicopter_list[ self.vehicletype ] );
}

_isAirplane()
{
	return IsDefined( level.airplane_list[ self.vehicletype ] );
}

isCheap()
{
	if ( !IsDefined( self.script_cheap ) )
		return false;

	if ( !self.script_cheap )
		return false;

	return true;
}

hasHelicopterDustKickup()
{
	if ( !_isHelicopter() && !_isAirplane() )
		return false;

	if ( isCheap() )
		return false;

	return true;
}

hasHelicopterTurret()
{
	//this is not detecting the apache but adding it now would do more harm than good I fear
	if ( !IsDefined( self.vehicletype ) )
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
/*
=============
///ScriptFieldDocBegin
"Name: .dontdisconnectpaths"
"Summary: dontdisconnectpaths"
"Module: Vehicle"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	
			if ( !IsDefined( self.dontDisconnectPaths ) )
				self DisconnectPaths();
			else
			{
				AssertEx( self.dontDisconnectPaths == 1, ".dontDisconnectPaths should either be 1 or undefined." );
			}
			
			self notify( "speed_zero_path_disconnect" );
			while ( self Vehicle_GetSpeed() < 1 )
				wait 0.05;
		}
		self ConnectPaths();
		wait 1;
	}
}

mginit()
{
	classname = self.classname;

	if ( ( ( IsDefined( self.script_nomg ) ) && ( self.script_nomg > 0 ) ) )
		return;

	if ( !IsDefined( level.vehicle_mgturret[ classname ] ) )
		return;

	mgangle = 0;
	if ( IsDefined( self.script_mg_angle ) )
		mgangle = self.script_mg_angle;


	turret_templates = level.vehicle_mgturret[ classname ];
	if ( !IsDefined( turret_templates ) )
		return;

	one_turret = IsDefined( self.script_noteworthy ) && self.script_noteworthy == "onemg";

	foreach ( index, turret_template in turret_templates )
	{
		turret = SpawnTurret( "misc_turret", ( 0, 0, 0 ), turret_template.info );

		if ( IsDefined( turret_template.offset_tag ) )
			turret LinkTo( self, turret_template.tag, turret_template.offset_tag, ( 0, -1 * mgangle, 0 ) );
		else
			turret LinkTo( self, turret_template.tag, ( 0, 0, 0 ), ( 0, -1 * mgangle, 0 ) );
			
		turret SetModel( turret_template.model );
		turret.angles			 = self.angles;
		turret.isvehicleattached = true;// lets mgturret know not to mess with this turret
		turret.ownerVehicle		 = self;
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
		defaultOnMode = level.vehicle_mgturret[ classname ][ i ].defaultONmode;
		if ( IsDefined( defaultOnMode ) )
		{
			turret turret_set_default_on_mode( defaultOnMode );
		}
	}

	if ( !IsDefined( self.script_turretmg ) )
		self.script_turretmg = true;;

	if ( self.script_turretmg == 0 )
		self thread _mgoff();
	else
	{
		self.script_turretmg = 1;
		self thread _mgon();
	}
}

turret_set_default_on_mode( defaultOnMode )
{
	self.defaultONmode = defaultOnMode;
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

animate_drive_idle()
{
	self endon( "suspend_drive_anims" );

	if ( !IsDefined( self.wheeldir ) )
		self.wheeldir = 1;
	model			  = self.model;

	curanimrate = -1;
	newanimtime = undefined;
	self UseAnimTree(#animtree );
	if ( !IsDefined( level.vehicle_DriveIdle[ model ] ) )
		return;
	if ( !IsDefined( level.vehicle_DriveIdle_r[ model ] ) )
		level.vehicle_DriveIdle_r[ model ] = level.vehicle_DriveIdle[ model ]; // use forward animation if no backwards anim exists
	self endon( "death" );
	normalspeed = level.vehicle_DriveIdle_normal_speed[ model ];

	animrate = 1.0;
	if ( ( IsDefined( level.vehicle_DriveIdle_animrate ) ) && ( IsDefined( level.vehicle_DriveIdle_animrate[ model ] ) ) )
		animrate = level.vehicle_DriveIdle_animrate[ model ];

	lastdir = self.wheeldir;

	animatemodel = self;
	animation	 = level.vehicle_DriveIdle[ model ];

	while ( 1 )
	{
		if ( IsDefined( level.animate_drive_idle_on_dummies ) )
 			animatemodel = _get_dummy();

		if ( !normalspeed )
		{
			if ( IsDefined( self.suspend_driveanims ) )
			{
				wait 0.05;
				continue;
			}

			// vehicles like helicopters always play the same rate. will come up with better design if need arises.
			animatemodel SetAnim( level.vehicle_DriveIdle[ model ], 1, 0.2, animrate );
			return;
		}

		speed = self Vehicle_GetSpeed();
		
		if ( self.modeldummyon && IsDefined( self.dummyspeed ) )
			speed = self.dummyspeed;

		if ( lastdir != self.wheeldir )
		{
			dif = 0;
			if ( self.wheeldir )
			{
				animation = level.vehicle_DriveIdle[ model ];
				dif		  = 1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle_r[ model ] );
				animatemodel ClearAnim( level.vehicle_DriveIdle_r[ model ], 0 );
			}
			else
			{
				animation = level.vehicle_DriveIdle_r[ model ]; // reverse direction
				dif		  = 1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle[ model ] );
				animatemodel ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
			}

			newanimtime = 0.01;
			if ( newanimtime >= 1 || newanimtime == 0 )
				newanimtime = 0.01;// think setting animtime to 0 or 1 messes things up
			lastdir = self.wheeldir;
		}

		newanimrate = speed / normalspeed;
		if ( newanimrate != curanimrate )
		{
			animatemodel SetAnim( animation, 1, 0.05, newanimrate );
			curanimrate = newanimrate;
		}

		if ( IsDefined( newanimtime ) )
		{
			animatemodel SetAnimTime( animation, newanimtime );
			newanimtime = undefined;
		}

		wait 0.05;
	}
}

setup_dynamic_detour( pathnode, get_func )
{
	prevnode = [[ get_func ] ] ( pathnode.targetname );
	AssertEx( IsDefined( prevnode ), "detour can't be on start node" );
	prevnode.detoured = 0;
}

setup_ai()
{
	foreach ( ai in GetAIArray() )
		if ( IsDefined( ai.script_vehicleride ) )
			level.vehicle_RideAI = array_2dadd( level.vehicle_RideAI, ai.script_vehicleride, ai );
	foreach ( ai in GetSpawnerArray() )
		if ( IsDefined( ai.script_vehicleride ) )
			level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, ai.script_vehicleride, ai );
}

array_2dadd( array, firstelem, newelem )
{
	if ( !IsDefined( array[ firstelem ] ) )
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
		level.vehicle_startnodes	[ level.vehicle_startnodes.size ] = self;
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
			setup_groundnode_detour( self ); // other trickery.  the node is set to process in there.
		}

		level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, self.script_vehicledetour, self );
		if ( level.vehicle_detourpaths[ self.script_vehicledetour ].size > 2 )
			PrintLn( "more than two script_vehicledetour grouped in group number: ", self.script_vehicledetour );
	}

	// if a gate isn't open then the vehicle will stop there and wait for it to become open.
	if ( IsDefined( self.script_gatetrigger ) )
	{
		level.vehicle_gatetrigger = array_2dadd( level.vehicle_gatetrigger, self.script_gatetrigger, self );
		self.gateopen			  = false;
	}

	// init the flags! 
	if ( IsDefined( self.script_flag_set ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_set ] ) )
			flag_init( self.script_flag_set );
	}

	// init the flags! 
	if ( IsDefined( self.script_flag_clear ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_clear ] ) )
			flag_init( self.script_flag_clear );
	}

	if ( IsDefined( self.script_flag_wait ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_wait ] ) )
			flag_init( self.script_flag_wait );
	}

	// various nodes that will be sent through trigger_process
	if (
			IsDefined( self.script_VehicleSpawngroup )
				||	IsDefined( self.script_VehicleStartMove	  )
				||	IsDefined( self.script_gatetrigger		  )
				||	IsDefined( self.script_vehicleGroupDelete )
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
	triggers = array_combine( triggers			  , level.struct );
	triggers = array_combine( triggers			  , GetEntArray( "trigger_radius", "code_classname" ) );
	triggers = array_combine( triggers			  , GetEntArray( "trigger_disk", "code_classname" ) );
	triggers = array_combine( triggers			  , GetEntArray( "trigger_multiple", "code_classname" ) );
	triggers = array_combine( triggers			  , GetEntArray( "trigger_lookat", "code_classname" ) );

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
	nonspawned				   = [];
	level.failed_spawnvehicles = [];

	foreach ( vehicle in vehicles )
	{
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
	if ( IsDefined( self.script_VehicleSpawngroup ) && !IsSpawner( self ) )
	{
		level.failed_spawnvehicles[ level.failed_spawnvehicles.size ] = self;
		return true;
	}
	return IsSpawner( self );
}

vehicle_life()
{
	classname = self.classname;
	
	if ( !IsDefined( level.vehicle_life ) || !IsDefined( level.vehicle_life[ classname ] ) )
		wait 2;
	AssertEx( IsDefined( level.vehicle_life[ classname ] ), "need to specify build_life() in vehicle script for vehicletype: " + classname );


	if ( IsDefined( self.script_startinghealth ) )
		self.health = self.script_startinghealth;
	else
	{
		if ( level.vehicle_life[ classname ] == -1 )
			return;
		else if ( IsDefined( level.vehicle_life_range_low[ classname ] ) && IsDefined( level.vehicle_life_range_high[ classname ] ) )
			self.health = ( RandomInt( level.vehicle_life_range_high[ classname ] - level.vehicle_life_range_low[ classname ] ) + level.vehicle_life_range_low[ classname ] );
		else
			self.health = level.vehicle_life[ classname ];
	}

	if ( IsDefined( level.destructible_model[ self.model ] ) )
	{
		self.health			   = 2000;
		self.destructible_type = level.destructible_model[ self.model ];
		self common_scripts\_destructible::setup_destructibles( true );
	}
}

setturretfireondrones( b )
{
	if ( IsDefined( self.mgturret ) && self.mgturret.size )
		foreach( turret in self.mgturret )
			turret.script_fireondrones = b;
}

getnormalanimtime( animation )
{
	animtime   = self GetAnimTime( animation );
	animlength = GetAnimLength( animation );
	if ( animtime == 0 )
		return 0;
	return self GetAnimTime( animation ) / GetAnimLength( animation );
}

rotor_anim()
{
	Length = GetAnimLength( self getanim( "rotors" ) );
	for ( ;; )
	{
		self SetAnim( self getanim( "rotors" ), 1, 0, 1 );
		wait( Length );
	}
}

suspend_drive_anims()
{
	self notify( "suspend_drive_anims" );

	model = self.model;

	self ClearAnim( level.vehicle_DriveIdle[ model ]  , 0 );
	self ClearAnim( level.vehicle_DriveIdle_r[ model ], 0 );
}

idle_animations()
{
	self UseAnimTree(#animtree );
	
	if ( !IsDefined( level.vehicle_IdleAnim[ self.model ] ) )
		return;
		
	foreach ( animation in level.vehicle_IdleAnim[ self.model ] )
		self SetAnim( animation );
}

vehicle_rumble()
{
	self endon( "kill_rumble_forever" );
	classname	 = self.classname;
	rumblestruct = undefined;
	if ( IsDefined( self.vehicle_rumble_unique ) )
		rumblestruct = self.vehicle_rumble_unique;
	else if ( IsDefined( level.vehicle_rumble_override ) && IsDefined( level.vehicle_rumble_override[ classname ] ) )
		rumblestruct = level.vehicle_rumble_override;
	else if ( IsDefined( level.vehicle_rumble[ classname ] ) )
		rumblestruct = level.vehicle_rumble[ classname ];

	if ( !IsDefined( rumblestruct ) )
		return;

	height		= rumblestruct.radius * 2;
	zoffset		= -1 * rumblestruct.radius;
	areatrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, zoffset ), 0, rumblestruct.radius, height );
	areatrigger EnableLinkTo();
	areatrigger LinkTo( self );
	self.rumbletrigger = areatrigger;
	self endon( "death" );
// 	( rumble, scale, duration, radius, basetime, randomaditionaltime )

	//.rumbleon is not used anywhere else 
	//and the current behavior is to turn it on by default but respect it if someone turns it off
	if ( !IsDefined( self.rumbleon ) )
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
		self.rumble_radius = rumblestruct.radius;
	else
		self.rumble_radius = 600;

	if ( IsDefined( rumblestruct.basetime ) )
		self.rumble_basetime = rumblestruct.basetime;
	else
		self.rumble_basetime = 1;

	if ( IsDefined( rumblestruct.randomaditionaltime ) )
		self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
	else
		self.rumble_randomaditionaltime = 1;

	areatrigger.radius = self.rumble_radius;
	while ( 1 )
	{
		areatrigger waittill( "trigger" );
		if ( self Vehicle_GetSpeed() == 0 || !self.rumbleon )
		{
			wait 0.1;
			continue;
		}

		self PlayRumbleLoopOnEntity( rumblestruct.rumble );

		while ( level.player IsTouching( areatrigger ) && self.rumbleon && self Vehicle_GetSpeed() > 0 )
		{
			Earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius ); // scale duration source radius
			wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
		}
		self StopRumble( rumblestruct.rumble );
	}
}

vehicle_kill_treads_forever()
{
	self notify( "kill_treads_forever" );
}

isStationary()
{
	type = self.vehicletype;
	if ( IsDefined( level.vehicle_isStationary[ type ] ) && level.vehicle_isStationary[ type ] )
		return true;
	else
		return false;
}

vehicle_shoot_shock()
{		
	// if no shellshock is specified just get out of here.
	if ( !IsDefined( level.vehicle_shoot_shock[ self.classname ] ) )
		return;

	if ( GetDvar( "disable_tank_shock_minspec" ) == "1" )
		return;

	self endon( "death" );

	if ( !IsDefined( level.vehicle_shoot_shock_overlay ) )
	{
		level.vehicle_shoot_shock_overlay	= NewHudElem();
		level.vehicle_shoot_shock_overlay.x = 0;
		level.vehicle_shoot_shock_overlay.y = 0;
		level.vehicle_shoot_shock_overlay SetShader( "black", 640, 480 );
		level.vehicle_shoot_shock_overlay.alignX	= "left";
		level.vehicle_shoot_shock_overlay.alignY	= "top";
		level.vehicle_shoot_shock_overlay.horzAlign = "fullscreen";
		level.vehicle_shoot_shock_overlay.vertAlign = "fullscreen";
		level.vehicle_shoot_shock_overlay.alpha		= 0;
	}
	
	self endon ( "stop_vehicle_shoot_shock" );

	while ( true )
	{
		self waittill( "weapon_fired" ); // waits for Code notify when FireWeapon() is called.
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

		level.vehicle_shoot_shock_overlay.alpha = 0.5;
		level.vehicle_shoot_shock_overlay FadeOverTime( 0.2 );
		level.vehicle_shoot_shock_overlay.alpha = 0;

		if ( player_distance > shock_distance )
			continue;

		if ( IsDefined( level.player.flashendtime ) && ( ( level.player.flashendtime - GetTime() ) > 200 ) )
			continue;

		if ( IsDefined( self.shellshock_audio_disabled ) && self.shellshock_audio_disabled )
			continue;

		if ( IsDefined( self.shellshock_time ) )
		{
			time = self.shellshock_time;
		}
		else
		{
		fraction = player_distance / shock_distance;
		time	 = 4 - ( 3 * fraction );
		}
		level.player ShellShock( level.vehicle_shoot_shock[ self.classname ], time );
	}
}

vehicle_setteam()
{
	classname = self.classname;
	
	if ( !IsDefined( self.script_team ) && IsDefined( level.vehicle_team[ classname ] ) )
		self.script_team = level.vehicle_team[ classname ];

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

		if ( !IsDefined( path_start ) )
		{
			path_start = GetEnt( target, "targetname" );
		}
		else if ( _ishelicopter() )
		{
			PrintLn( "helicopter node targetname: " + path_start.targetname );
			PrintLn( "vehicletype: " + self.vehicletype );
			AssertMsg( "helicopter on vehicle path( see console for info )" );
		}
		if ( !IsDefined( path_start ) )
		{
			target_array = getstructarray( target, "targetname" );
			
			// adding structs that are targeted by the path for custom unloads (fast zip);
			//  only look at structs that are not used for unload
			path_array = [];
			if ( IsDefined( target_array ) )
			{
				// filter out unloadtype structs
				foreach ( target_struct in target_array )
				{
					if ( IsDefined( target_struct.script_unloadtype ) )
						continue;
					
					path_array[ path_array.size ] = target_struct;
				}
			}
			
			if ( path_array.size == 1 )
			{
				path_start = path_array[0];
			}
			else
			{
				AssertMsg( "Path must only have one target (" + target + ")" );
				path_start = undefined;
			}
		}
		return path_start;
}

vehicle_resumepathvehicle()
{
	if ( !self _ishelicopter() )
	{
		self ResumeSpeed( 35 );
		return;
	}

	node = undefined;

	if ( IsDefined( self.currentnode.target ) )
		node = get_vehiclenode_any_dynamic( self.currentnode.target );
	if ( !IsDefined( node ) )
		return;
	_vehicle_paths( node );
}

has_frontarmor()
{
	return( IsDefined( level.vehicle_frontarmor[ self.vehicletype ] ) );
}

grenadeshielded( type )
{
	if ( !IsDefined( self.script_grenadeshield ) )
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
	if ( !IsDefined( self.script_bulletshield ) )
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

explosive_bulletshielded( type )
{
	if ( !IsDefined( self.script_explosive_bullet_shield ) )
		return false;

	type = ToLower( type );
													
	if ( ! IsDefined( type ) || !IsSubStr( type, "explosive" ) )
		return false;

	if ( self.script_explosive_bullet_shield )
		return true;
	else
		return false;
}

vehicle_should_regenerate( attacker, type )
{
	return ( ! IsDefined( attacker ) && self.script_team != "neutral" )
				||	attacker_isonmyteam( attacker )
				||	attacker_troop_isonmyteam( attacker )
				||	isDestructible()
				||	is_invulnerable_from_ai( attacker )
				||	bulletshielded( type )
				||	explosive_bulletshielded( type )
				||	grenadeshielded( type )
				||	type == "MOD_MELEE";
}

friendlyfire_shield()
{
	self endon( "death" );
	
	if ( !IsDefined( level.unstoppable_friendly_fire_shield ) )
		self endon( "stop_friendlyfire_shield" );
	
	classname = self.classname;

	if ( IsDefined( level.vehicle_bulletshield[ classname ] ) && !IsDefined( self.script_bulletshield ) )
		self.script_bulletshield = level.vehicle_bulletshield[ classname ];

	if ( IsDefined( level.vehicle_grenadeshield[ classname ] ) && !IsDefined( self.script_grenadeshield ) )
		self.script_grenadeshield = level.vehicle_bulletshield[ classname ];

	if ( IsDefined( self.script_mp_style_helicopter ) )
	{
		self.script_mp_style_helicopter = true;
		self.bullet_armor				= 5000;
		self.health						= 350;
	}
	else
		self.script_mp_style_helicopter = false;
		
	self.healthbuffer = 20000;
	self.health += self.healthbuffer;
	self.currenthealth = self.health;
	attacker		   = undefined;
	type			   = undefined;
	weaponName		   = undefined;

	while ( self.health > 0 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
		
		foreach ( func in self.damage_functions )
		{
			thread [[ func ]]( amount, attacker, direction_vec, point, type, modelName, tagName );
		}

		if ( IsDefined( attacker ) )
			attacker maps\_player_stats::register_shot_hit();

		if ( vehicle_should_regenerate( attacker, type ) ||	_is_godmode() )
			self.health = self.currenthealth;
		else if ( self has_frontarmor() ) // regen health for tanks with armor in the front
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

		if ( self.health < self.healthbuffer && !IsDefined( self.vehicle_stays_alive ) )
			break;
		amount		  = undefined;
		attacker	  = undefined;
		direction_vec = undefined;
		point		  = undefined;
		type		  = undefined;
		modelName	  = undefined;
		tagName		  = undefined;
		partName	  = undefined;
		dFlags		  = undefined;
		weaponName	  = undefined;
	}
	self notify( "death", attacker, type, weaponName );
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
	othervec   = VectorNormalize( attacker.origin - self.origin );
	if ( VectorDot( forwardvec, othervec ) > 0.86 )
		self.health += Int( amount * level.vehicle_frontarmor[ self.vehicletype ] );
}

_is_godmode()
{
	if ( IsDefined( self.godmode ) && self.godmode )
		return true;
	else
		return false;
}

is_invulnerable_from_ai( attacker )
{
	//vehicles with script_AI_invulnerable = 1 cannot be damaged by attacking AI
	if ( !IsDefined( self.script_AI_invulnerable ) )
		return false;
	if ( ( IsDefined( attacker ) ) && ( IsAI( attacker ) ) && ( self.script_AI_invulnerable == 1 ) )
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

attacker_isonmyteam( attacker )
{
	if ( ( IsDefined( attacker ) ) && IsDefined( attacker.script_team ) && ( IsDefined( self.script_team ) ) && ( attacker.script_team == self.script_team ) )
		return true;
	return false;
}

vehicle_badplace()
{
	return _vehicle_badplace();
}

wheeldirectionchange( direction )
{
	self.wheeldir = ter_op( direction <= 0, 0, 1 );
}

maingun_FX()
{
	if ( IsDefined( level.maingun_FX_override ) )
	{
		thread [[ level.maingun_FX_override ]]();
		return;
	}

	model = self.model;
	if ( !IsDefined( level.vehicle_deckdust[ model ] ) )
		return;
	
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "weapon_fired" ); // waits for Code notify when FireWeapon() is called.
		PlayFXOnTag( level.vehicle_deckdust[ model ], self, "tag_engine_exhaust" );
		barrel_origin = self GetTagOrigin( "tag_flash" );
		ground		  = PhysicsTrace( barrel_origin, barrel_origin + ( 0, 0, -128 ) );
		PhysicsExplosionSphere( ground, 192, 100, 1 );
	}
}

playTankExhaust()
{
	self endon( "death" );

	model = self.model;

	if ( !IsDefined( level.vehicle_exhaust[ model ] ) )
		return;
		
	exhaustDelay = 0.1;
	
	while ( true )
	{
		if ( !IsDefined( self ) )
			return;
		if ( !IsAlive( self ) )
			return;
		PlayFXOnTag( level.vehicle_exhaust[ model ], _get_dummy(), "tag_engine_exhaust" );
		wait exhaustDelay;
	}
}

getonpath( skip_attach )
{
	path_start = undefined;
	type	   = self.vehicletype;
	if ( IsDefined( self.vehicle_spawner ) )
	{
    	if ( IsDefined( self.vehicle_spawner.dontgetonpath ) && self.dontgetonpath )
    		return;
	}
	
	if ( IsDefined( self.target ) )
	{
		path_start = GetVehicleNode( self.target, "targetname" );

		/#
		if ( _ishelicopter() && IsDefined( path_start ) )
		{
			PrintLn( "helicopter node targetname: " + path_start.targetname );
			PrintLn( "vehicletype: " + self.vehicletype );
			AssertMsg( "helicopter on vehicle path( see console for info )" );
		}
		#/

		if ( !IsDefined( path_start ) )
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

		if ( !IsDefined( path_start ) )
			path_start = getstruct( self.target, "targetname" );
	}

	if ( !IsDefined( path_start ) )
	{
		if ( _ishelicopter() )
			self Vehicle_SetSpeed( 60, 20, HELI_DEFAULT_DECEL );

		return;
	}

	self.attachedpath = path_start;

	if ( !_isHelicopter() )
	{
		self.origin = path_start.origin;
		
		if ( !IsDefined( skip_attach ) )
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
			decel = HELI_DEFAULT_DECEL;
			if ( IsDefined( path_start.script_accel ) )
				accel = path_start.script_accel;
			if ( IsDefined( path_start.script_decel ) )
				accel = path_start.script_decel;

			self Vehicle_SetSpeedImmediate( path_start.speed, accel, decel );
		}
		else
		{
			// default heli speed
			self Vehicle_SetSpeed( 60, 20, HELI_DEFAULT_DECEL );
		}
	}

	self thread _vehicle_paths( undefined, _isHelicopter() );
}

_vehicle_resume_named( stop_name )
{
	resume_speed						 = self.vehicle_stop_named[ stop_name ];
	self.vehicle_stop_named[ stop_name ] = undefined;
	if ( self.vehicle_stop_named.size )
		return;
	self ResumeSpeed( resume_speed );
		
}

_vehicle_stop_named( stop_name, acceleration, deceleration )
{
	if ( !IsDefined( self.vehicle_stop_named ) )
		self.vehicle_stop_named = [];
		
	AssertEx( !IsDefined( self.vehicle_stop_named[ stop_name ] ), "can't stop twice with same name" );

	self Vehicle_SetSpeed( 0, acceleration, deceleration );
	self.vehicle_stop_named[ stop_name ] = acceleration;	
}

unload_node( node )
{
	self endon ( "death" );
	if ( IsDefined( self.ent_flag[ "prep_unload" ] ) && self ent_flag( "prep_unload" ) )
		return; // this vehicle is already in the process of unloading

	if ( IsSubStr( self.classname, "snowmobile" ) )
		while ( self.veh_speed > 15 )
			wait( 0.05 );

	if ( !IsDefined( node.script_flag_wait ) && !IsDefined( node.script_delay ) )
	{
		// going to stop anyway so no need to kill the path
		self notify( "newpath" );
	}

	Assert( IsDefined( self ) );

	pathnode = GetNode( node.targetname, "target" );
	if ( IsDefined( pathnode ) && self.riders.size )
	{
		foreach ( rider in self.riders )
		{
			if ( IsAI( rider ) )
				rider thread maps\_spawner::go_to_node( pathnode );
		}
	}

	if ( self _ishelicopter() )
	{
		if ( IsDefined( self.parachute_unload ) )
		{
			//parachute specific stuff WIP
			self SetMaxPitchRoll( 0, 0 );
			waittill_dropoff_height();	
			self delayCall( 5, ::SetMaxPitchRoll,  15, 15 );			
		}			
		else
		{
			// use default hover params for speed/accel. having them at 0 will not cause the vehicle to hover properly.
			self SetHoverParams( 0 );
			waittill_stable( node );
		}			
	}
	else
		self Vehicle_SetSpeed( 0, 35 );

// 	self vehicle_to_dummy	();

	if ( IsDefined( node.script_noteworthy ) )
		if ( node.script_noteworthy == "wait_for_flag" )
			flag_wait( node.script_flag );

	self _vehicle_unload( node.script_unload );


	if ( maps\_vehicle_aianim::riders_unloadable( node.script_unload ) )
	{
		if ( IsDefined( self.parachute_unload ) )
		{
			//iw6 parachute unload. Default is chopper keeps moving but if geo is uneven, can be stationary with script_noteworthy "para_unload_stop"
			if ( IsDefined( node.script_noteworthy ) )
			{
				if ( node.script_noteworthy == "para_unload_stop" )
				{
					self waittill( "unloaded" );
				}
			}
		}
		else
		{
			self waittill( "unloaded" );
		}
	}

	if ( IsDefined( node.script_flag_wait ) || IsDefined( node.script_delay ) )
		return;

	if ( IsDefined( self ) )
		thread vehicle_resumepathvehicle();
}

move_turrets_here( model )
{
	classname = self.classname;
	
	if ( !IsDefined( self.mgturret ) )
		return;
	if ( self.mgturret.size == 0 )
		return;
	AssertEx( IsDefined( level.vehicle_mgturret[ classname ] ), "no turrets specified for model" );

	foreach ( i, turret in self.mgturret )
	{
		turret Unlink();
		turret LinkTo( model, level.vehicle_mgturret[ classname ][ i ].tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
}

vehicle_pathdetach()
{
	self.attachedpath = undefined;
	self notify( "newpath" );

	self SetGoalYaw( flat_angle( self.angles )[ 1 ] );
	self SetVehGoalPos( self.origin + ( 0, 0, 4 ), 1 );

}

waittill_dropoff_height()
{
	AssertEx( IsDefined( self.dropoff_height ), "Vehicle needs self.dropoff_height to use this func" );
	AssertEx( IsDefined( self.currentNode )	  , "Vehicle needs self.currentnode to use this func" );
	offset	   = 2 * 2;
	stabletime = 400;
	timer	   = GetTime() + stabletime;
	while ( IsDefined( self ) )
	{		
		z_difference = self.origin[ 2 ] - self.currentNode.origin[ 2 ];
		if ( abs( z_difference ) <= offset )
			return;
		else
			timer = GetTime() + stabletime;
		
		if ( GetTime() > timer )
		{
			IPrintLn( "Chopper parachute unload: waittill_dropoff_height timed out!" );
			break;
		}
		wait 0.05;
	}
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

_mgoff()
{
	self.script_turretmg = 0;

	
	if ( ( self _isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		if ( IsDefined( level.ChopperTurretFunc ) )
		{
			AssertEx( IsDefined( level.ChopperTurretoffFunc ), "hasHelicopterTurret with no level.ChopperTurretOnFunc, need maps\_helicopter_globals::init_helicopters();" );
			self thread [[ level.ChopperTurretoffFunc ]]();
			return;
		}
	}

	if ( !IsDefined( self.mgturret ) )
		return;

	foreach ( i, turret in self.mgturret )
	{
		if ( IsDefined( turret.script_fireondrones ) )
			turret.script_fireondrones = false;

		turret SetMode( "manual" );
	}
}

_mgon()
{
	self.script_turretmg = 1;

	if ( ( self _isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		AssertEx( IsDefined( level.ChopperTurretOnFunc ), "hasHelicopterTurret with no level.ChopperTurretOnFunc, need maps\_helicopter_globals::init_helicopters();" );
		self thread [[ level.ChopperTurretOnFunc ]]();
		return;
	}

	if ( !IsDefined( self.mgturret ) )
		return;

	foreach ( turret in self.mgturret )
	{
		turret Show(); // for hidden turrets on vehicles that shouldn't have turrets

		if ( IsDefined( turret.script_fireondrones ) )
			turret.script_fireondrones = true;

		if ( IsDefined( turret.defaultONmode ) )
		{
			if ( turret.defaultONmode != "sentry" ) // sentry types ( miniguns ) will set manage their own mode.
				turret SetMode( turret.defaultONmode );
		}
		else
		{
			turret SetMode( "auto_nonai" );
		}

		set_turret_team( turret );
	}
}

_force_kill()
{
	if ( isDestructible() )
		self common_scripts\_destructible::force_explosion();
	else
		self Kill();
}

get_vehicle_ai_riders()
{
	if ( !IsDefined( self.script_vehicleride ) )
		return [];
	if ( !IsDefined( level.vehicle_RideAI[ self.script_vehicleride ] ) )
		return [];

	return level.vehicle_RideAI[ self.script_vehicleride ];
}

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

	if ( !IsDefined( self.script_vehicleride ) )
		return spawners;

	if ( IsDefined( level.vehicle_RideSpawners[ self.script_vehicleride ] ) )
		spawners = array_combine( spawners, level.vehicle_RideSpawners[ self.script_vehicleride ] );

	return spawners;
}

_vehicle_paths( node, bhelicopterwaitforstart )
{
	if ( _ishelicopter() )
		vehicle_paths_helicopter( node, bhelicopterwaitforstart );
	else
		vehicle_paths_non_heli( node );
}

_gopath( vehicle )
{
	// helis notify reached_dynamic_path_end on end
	if ( !IsDefined( vehicle ) )
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

	if ( vehicle _isHelicopter() )
		vehicle notify( "start_dynamicpath" );
	else
		vehicle StartPath();

}

_scripted_spawn( group )
{
	spawners = _getvehiclespawnerarray_by_spawngroup( group );
	vehicles = [];
	foreach ( spawner in spawners )
		vehicles[ vehicles.size ] = _vehicle_spawn( spawner );
	return vehicles;
}

_vehicle_spawn( vspawner )
{
	Assert( IsSpawner( vspawner ) );
	AssertEx( !IsDefined( vspawner.vehicle_spawned_thisframe ), "spawning two vehicles on one spawner on the same frame is not allowed" );
	vehicle = vspawner Vehicle_DoSpawn();
	Assert( IsDefined( vehicle ) );
	
	if ( !IsDefined( vspawner.spawned_count ) )
		vspawner.spawned_count = 0;
		
	vspawner.spawned_count++;
	
	vspawner.vehicle_spawned_thisframe = vehicle;
	vspawner.last_spawned_vehicle	   = vehicle;
	vspawner thread remove_vehicle_spawned_thisframe();
	vehicle.vehicle_spawner = vspawner;
	
	if ( IsDefined( vspawner.truckjunk ) )
		vehicle.truckjunk = vspawner.truckjunk;
	thread vehicle_init( vehicle );
	// want to get this put in code and rearrange all this stuff so that people can use Vehicle_DoSpawn() directly and not have to initialize the vehicle scripts.
	vspawner notify( "spawned", vehicle );
	return vehicle;
}

kill_vehicle_spawner( trigger )
{
	trigger waittill( "trigger" );
	array_delete( level.vehicle_killspawn_groups[ trigger.script_kill_vehicle_spawner ] );
	level.vehicle_killspawn_groups[ trigger.script_kill_vehicle_spawner ] = [];
}

precache_scripts()
{
	// find all the vehicles in the level and initialize precaching( calling of vehicles main() mostly )
	allvehiclesprespawn = [];

	vehicles = GetEntArray( "script_vehicle", "code_classname" );

	level.needsprecaching  = [];
	playerdrivablevehicles = [];
	allvehiclesprespawn	   = [];
	if ( !IsDefined( level.vehicleInitThread ) )
		level.vehicleInitThread = [];

	foreach( vehicle in vehicles )
	{
		vehicle.vehicletype = ToLower( vehicle.vehicletype );
		if ( vehicle.vehicletype == "empty" )
			continue;

		if ( IsDefined( vehicle.spawnflags ) && vehicle.spawnflags & 1 )
			playerdrivablevehicles[ playerdrivablevehicles.size ] = vehicle;

		allvehiclesprespawn[ allvehiclesprespawn.size ] = vehicle;

		if ( !IsDefined( level.vehicleInitThread[ vehicle.vehicletype ] ) )
			level.vehicleInitThread[ vehicle.vehicletype ] = [];

		loadstring = "classname: " + vehicle.classname;

		precachesetup( loadstring, vehicle );
	}

	if ( level.needsprecaching.size > 0 )
	{
		PrintLn( "----------------------------------------------------------------------------------" );
		PrintLn( "---missing vehicle script: run repackage zone and precache scripts from launcher--" );
		PrintLn( "----------------------------------------------------------------------------------" );
		foreach ( needsprecaching in level.needsprecaching )
			PrintLn( needsprecaching );
		PrintLn( "----------------------------------------------------------------------------------" );
		AssertEx( false, "missing vehicle scripts, see above console prints" );
		level waittill( "never" );
	}

	return allvehiclesprespawn;
}

precachesetup( string, vehicle )
{
	if ( IsDefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.classname ] ) )
		return;
		
	if ( vehicle.classname == "script_vehicle" )
		return;
	
	matched = false;
	foreach ( needsprecaching in level.needsprecaching )
		if ( needsprecaching == string )
			matched = true;
	if ( !matched )
		level.needsprecaching[ level.needsprecaching.size ] = string;
}

setup_levelvars()
{
	//once.
	if ( IsDefined( level.vehicle_setup_levelvars ) )
		return;
	level.vehicle_setup_levelvars = true;
	
	level.vehicle_DeleteGroup	   = [];
	level.vehicle_StartMoveGroup   = [];
	level.vehicle_RideAI		   = [];
	level.vehicle_DeathSwitch	   = [];
	level.vehicle_RideSpawners	   = [];
	level.vehicle_gatetrigger	   = [];
	level.vehicle_crashpaths	   = [];
	level.vehicle_link			   = [];
	level.vehicle_detourpaths	   = [];
	level.vehicle_startnodes	   = [];
	level.vehicle_killspawn_groups = [];

	level.helicopter_crash_locations = GetEntArray	( "helicopter_crash_location"	  , "targetname" );
	level.helicopter_crash_locations = array_combine( level.helicopter_crash_locations, getstructarray_delete( "helicopter_crash_location", "targetname" ) );

	// TODO in a thousand next games.. I don't like managing this variable. not so much that I don't like it, just that I haven't been 
	level.vehicles				= []; // will contain all the vehicles that are spawned and alive
	level.vehicles[ "allies"  ] = [];
	level.vehicles[ "axis"	  ] = [];
	level.vehicles[ "neutral" ] = [];
	level.vehicles[ "team3"	  ] = [];

	if ( !IsDefined( level.vehicle_team ) )
		level.vehicle_team = [];
	if ( !IsDefined( level.vehicle_deathmodel ) )
		level.vehicle_deathmodel = [];
	if ( !IsDefined( level.vehicle_death_thread ) )
		level.vehicle_death_thread = [];
	if ( !IsDefined( level.vehicle_DriveIdle ) )
		level.vehicle_DriveIdle = [];
	if ( !IsDefined( level.vehicle_DriveIdle_r ) )
		level.vehicle_DriveIdle_r = [];
	if ( !IsDefined( level.attack_origin_condition_threadd ) )
		level.attack_origin_condition_threadd = [];
	if ( !IsDefined( level.vehiclefireanim ) )
		level.vehiclefireanim = [];
	if ( !IsDefined( level.vehiclefireanim_settle ) )
		level.vehiclefireanim_settle = [];
	if ( !IsDefined( level.vehicle_hasname ) )
		level.vehicle_hasname = [];
	if ( !IsDefined( level.vehicle_turret_requiresrider ) )
		level.vehicle_turret_requiresrider = [];
	if ( !IsDefined( level.vehicle_rumble ) )
		level.vehicle_rumble = [];
	if ( !IsDefined( level.vehicle_rumble_override ) )
		level.vehicle_rumble_override = [];		
	if ( !IsDefined( level.vehicle_mgturret ) )
		level.vehicle_mgturret = [];
	if ( !IsDefined( level.vehicle_isStationary ) )
		level.vehicle_isStationary = [];
	if ( !IsDefined( level.vehicle_death_earthquake ) )
		level.vehicle_death_earthquake = [];
	if ( !IsDefined( level._vehicle_effect ) )
		level._vehicle_effect = [];
	if ( !IsDefined( level.vehicle_unloadgroups ) )
		level.vehicle_unloadgroups = [];
	if ( !IsDefined( level.vehicle_aianims ) )
		level.vehicle_aianims = [];
	if ( !IsDefined( level.vehicle_unloadwhenattacked ) )
		level.vehicle_unloadwhenattacked = [];
	if ( !IsDefined( level.vehicle_exhaust ) )
		level.vehicle_exhaust = [];
	if ( !IsDefined( level.vehicle_deckdust ) )
		level.vehicle_deckdust = [];
	if ( !IsDefined( level.vehicle_shoot_shock ) )
		level.vehicle_shoot_shock = [];
	if ( !IsDefined( level.vehicle_hide_list ) )
		level.vehicle_hide_list = [];
	if ( !IsDefined( level.vehicle_frontarmor ) )
		level.vehicle_frontarmor = [];
	if ( !IsDefined( level.destructible_model ) )
		level.destructible_model = [];
	if ( !IsDefined( level.vehicle_types ) )
		level.vehicle_types = [];
	if ( !IsDefined( level.vehicle_grenadeshield ) )
		level.vehicle_grenadeshield = [];
	if ( !IsDefined( level.vehicle_bulletshield ) )
		level.vehicle_bulletshield = [];
	if ( !IsDefined( level.vehicle_death_jolt ) )
		level.vehicle_death_jolt = [];
	if ( !IsDefined( level.vehicle_death_badplace ) )
		level.vehicle_death_badplace = [];
	if ( !IsDefined( level.vehicle_IdleAnim ) )
		level.vehicle_IdleAnim = [];
	if ( !IsDefined( level.helicopter_list ) )
		level.helicopter_list = [];
	if ( !IsDefined( level.airplane_list ) )
		level.airplane_list	= [];
	if ( !IsDefined( level.vehicle_single_tread_list ) )
    	level.vehicle_single_tread_list = [];

	maps\_vehicle_aianim::setup_aianimthreads();
}

setvehgoalpos_wrap( origin, bStop )
{
	return _setvehgoalpos_wrap( origin, bStop );
}

vehicle_liftoffvehicle( height )
{
	if ( !IsDefined( height ) )
		height = 512;
	dest = self.origin + ( 0, 0, height );
	self SetNearGoalNotifyDist( 10 );
	self setvehgoalpos_wrap( dest, 1 );
	self waittill( "goal" );
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
	modeldummy endon( "stop_model_dummy_death" );
	while ( IsDefined( self ) )
	{
		self waittill( "death" );
		waittillframeend;
	}
	modeldummy Delete();
}

move_lights_here( model, classname )
{
    model lights_on_internal( "all", self.classname );
    wait 0.3;
	self thread lights_off( "all", self.classname );
}

spawn_vehicles_from_targetname_newstyle( name )
{
	vehicles	= [];
	test		= GetEntArray( name, "targetname" );
	test_return = [];

	//strip out non vehicles.. 
	foreach ( v in test )
	{
		if ( !IsDefined( v.code_classname ) || v.code_classname != "script_vehicle" )
			continue;
		if ( IsSpawner( v ) )
			vehicles[ vehicles.size ] = _vehicle_spawn( v );
	}
	return vehicles;
}
