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
#include codescripts\struct;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#using_animtree( "vehicles" );

init_vehicles()
{
	precachemodel( "fx" );
	PrecacheString( &"hud_vehicle_turret_fire" );
	
	if(IsDefined(level.bypassVehicleScripts))
	{
		return;
	}
	
	level.heli_default_decel = 10;
	
	 // put all the vehicles with targetnames into an array so we can spawn vehicles from
	 // a string instead of their vehicle group #
	setup_targetname_spawners();

	 // vehicle related dvar initializing goes here
	setup_dvars();

	 // initialize all the level wide vehicle system variables
	setup_levelvars();

	 // pre - associate ai and spawners with their vehicles
	setup_ai();

	// pre - associate vehicle triggers and vehicle nodes with stuff.
	setup_triggers();
	
	setup_nodes();
	
	maps\_vehicle_death::init();

	allvehiclesprespawn = getentarray( "script_vehicle", "classname" );
	
	/#
		level thread vehicle_spawner_tool( allvehiclesprespawn );
	#/

	 // setup spawners and non - spawning vehicles
	setup_vehicles( allvehiclesprespawn );

	 // send the setup triggers to be processed
	level array_ent_thread( level.vehicle_processtriggers, ::trigger_process );

	// CHECKME
	level.vehicle_processtriggers = undefined;
	
	// SCRIPTER_MOD: dguzzo: 3-9-09 : this looks to be used only for arcade mode. going to leave in the one cod:waw reference as an example.
	// CODER_MOD: Tommy K
	level.vehicle_enemy_tanks = [];
	level.vehicle_enemy_tanks[ "vehicle_ger_tracked_king_tiger" ] 		= true;
}

/* DEAD CODE REMOVAL
trigger_getlinkmap( trigger )
{
	linkMap = [];
	if( IsDefined( trigger.script_linkTo ) )
	{
		links = strtok( trigger.script_linkTo, " " );
		for( i = 0; i < links.size; i++ )
		{
			linkMap[ links[ i ] ] = true;
		}
		links = undefined;
	}
	return linkMap;
}
*/

// setup_script_gatetrigger( trigger, linkMap )
setup_script_gatetrigger( trigger )
{
	gates = [];
	if( IsDefined( trigger.script_gatetrigger ) )
	{
		return level.vehicle_gatetrigger[ trigger.script_gatetrigger ];
	}
	return gates;
}

/* DEAD CODE REMOVAL
// setup_script_vehiclespawngroup( trigger, vehicles, linkMap )
setup_script_vehiclespawngroup( trigger, vehicles )
{
	script_vehiclespawngroup = false;
	if( IsDefined( trigger.script_vehiclespawngroup ) )
	{
		script_vehiclespawngroup = true;
	}
	return script_vehiclespawngroup;
}
*/

trigger_process( trigger )
{
	// these triggers only trigger once where vehicle paths trigger everytime a vehicle crosses them
	if( IsDefined( trigger.classname ) && ( trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat" || trigger.classname == "trigger_box" ))
	{
		bTriggeronce = true;
	}
	else
	{
		bTriggeronce = false;
	}
	
	// override to make a trigger loop
	if( IsDefined( trigger.script_noteworthy ) && trigger.script_noteworthy == "trigger_multiple" )
	{
		bTriggeronce = false;
	}
	
	trigger.processed_trigger = undefined;  // clear out this flag that was used to get the trigger to this point.

	gates = setup_script_gatetrigger( trigger );

	// origin paths and script struct paths get this value
	script_vehicledetour = IsDefined( trigger.script_vehicledetour ) && ( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) ) ;

	 // ground paths get this value
	detoured = IsDefined( trigger.detoured ) && !( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );
	gotrigger = true;

	while( gotrigger )
	{
		trigger trigger_wait();
		other = trigger.who;
		
		n_group_delete = trigger.script_vehicleGroupDelete;
		n_group_spawn = trigger.script_vehiclespawngroup;
		n_group_move = trigger.script_VehicleStartMove;
		
		if ( IsDefined( trigger.script_vehicletriggergroup ) )
		{
			if( !IsDefined( other.script_vehicletriggergroup ) )
			{
				continue;
			}

			if( IsDefined(other) && other.script_vehicletriggergroup != trigger.script_vehicletriggergroup )
			{
				continue;
			}
		}

		if( IsDefined( trigger.enabled ) && !trigger.enabled )
		{
			trigger waittill( "enable" );
		}
			
		if ( IsDefined( trigger.script_flag_set ) )
		{
			if ( IsDefined(other) && IsDefined( other.vehicle_flags ) )
			{
				other.vehicle_flags[ trigger.script_flag_set ] = true;
			}

			if ( IsDefined(other) )
			{
				other notify( "vehicle_flag_arrived", trigger.script_flag_set );
			}
			
			flag_set( trigger.script_flag_set );
		}

		if ( IsDefined( trigger.script_flag_clear ) )
		{
			if ( IsDefined(other) && IsDefined( other.vehicle_flags ) )
			{
				other.vehicle_flags[ trigger.script_flag_clear ] = false;
			}
			
			flag_clear( trigger.script_flag_clear );
		}

		if( IsDefined(other) && script_vehicledetour )
		{
			other thread path_detour_script_origin( trigger );
		}
		else if ( detoured && IsDefined( other ) )
		{
			other thread path_detour( trigger );
		}
		
		trigger script_delay();

		if( bTriggeronce )
		{
			gotrigger = false;
		}

		if ( IsDefined( n_group_delete ) )
		{
			if( !IsDefined( level.vehicle_DeleteGroup[ n_group_delete ] ) )
			{
				/#println( "failed to find deleteable vehicle with script_vehicleGroupDelete group number: ", trigger.script_vehicleGroupDelete );#/
				level.vehicle_DeleteGroup[ n_group_delete ] = [];
			}
			array_delete( level.vehicle_DeleteGroup[ n_group_delete ] );
		}

		if( IsDefined( n_group_spawn ) )
		{
			level notify( "spawnvehiclegroup" + n_group_spawn );
			level waittill( "vehiclegroup spawned" + n_group_spawn );
		}

		if ( gates.size > 0 && bTriggeronce )
		{
			level array_ent_thread( gates, ::path_gate_open );
		}

		if ( IsDefined( n_group_move ) )
		{
			if ( !IsDefined( level.vehicle_StartMoveGroup[ n_group_move ] ) )
			{
				/#println( "^3Vehicle start trigger is: ", n_group_move );#/
				return;
			}

			array_thread( array_copy( level.vehicle_StartMoveGroup[ n_group_move ] ), ::gopath  );
		}
	}
}

path_detour_get_detourpath( detournode )
{
	detourpath = undefined;
	for( j = 0; j < level.vehicle_detourpaths[ detournode.script_vehicledetour ].size; j++ )
	{
		if( level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ] != detournode )
		{
			if( !islastnode( level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ] ) )
			{
				detourpath = level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ];
			}
		}
	}

	return detourpath;
}

path_detour_script_origin( detournode )
{
	detourpath = path_detour_get_detourpath( detournode );
	if( IsDefined( detourpath ) )
	{
		self thread vehicle_paths( detourpath );
	}
}

crash_detour_check( detourpath )
{
	 // long somewhat complex set of conditions on which a vehicle will detour through a crashpath.
	return
	(
		IsDefined( detourpath.script_crashtype )
		&&
		(
			IsDefined( self.deaddriver )
			|| self.health <= 0
			|| detourpath.script_crashtype == "forced"
		)
		&&
		(
			!IsDefined( detourpath.derailed )
			|| ( IsDefined( detourpath.script_crashtype ) && detourpath.script_crashtype == "plane" )
		)
	);
}

crash_derailed_check( detourpath )
{
	return IsDefined( detourpath.derailed ) && detourpath.derailed;
}

path_detour( node )
{
	detournode = getvehiclenode( node.target, "targetname" );
	detourpath = path_detour_get_detourpath( detournode );

	// be more aggressive with this maybe?
	if( !IsDefined( detourpath ) )
	{
		return;
	}

	if( node.detoured && !IsDefined( detourpath.script_vehicledetourgroup ) )
	{
		return;
	}
		
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
		{
			return;  // .derailed crashpaths fail crash check. this keeps other vehicles from following.
		}

		 // detour paths specific to grouped vehicles. So they can share a lane and detour when they need to be exciting.
		if( IsDefined( detourpath.script_vehicledetourgroup ) )
		{
			if( !IsDefined( self.script_vehicledetourgroup ) )
			{
				return;
			}

			if( detourpath.script_vehicledetourgroup != self.script_vehicledetourgroup )
			{
				return;
			}
		}
	}
}

//PARAMETER CLEANUP
vehicle_Levelstuff( vehicle/*, trigger*/ )
{
	// associate with links
	if( IsDefined( vehicle.script_linkname ) )
	{
		level.vehicle_link = array_2dadd( level.vehicle_link, vehicle.script_linkname, vehicle );
	}

	if( IsDefined( vehicle.script_VehicleSpawngroup ) )
	{
		level.vehicle_SpawnGroup = array_2dadd( level.vehicle_SpawnGroup, vehicle.script_VehicleSpawngroup, vehicle );
	}

	if( IsDefined( vehicle.script_VehicleStartMove ) )
	{
		level.vehicle_StartMoveGroup = array_2dadd( level.vehicle_StartMoveGroup, vehicle.script_VehicleStartMove, vehicle );
	}

	if( IsDefined( vehicle.script_vehicleGroupDelete ) )
	{
		level.vehicle_DeleteGroup = array_2dadd( level.vehicle_DeleteGroup, vehicle.script_vehicleGroupDelete, vehicle );
	}
}

spawn_array( spawners )
{
	ai = [];
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ].count = 1;
		if( IsDefined( spawners[ i ].script_drone ) )
		{
			spawned = spawners[ i ] spawn_drone();
		}
		else
		{
			spawned = spawners[ i ] spawn_ai();
			if (!IsAlive(spawned))
			{
				continue;
			}
		}
		
		assert( IsDefined( spawned ) );
		ai[ ai.size ] = spawned;
	}

	ai = remove_non_riders_from_array( ai );
	return ai;
}

remove_non_riders_from_array( ai )
{
	living_ai = [];
	for( i = 0; i < ai.size; i++ )
	{
		if ( !ai_should_be_added( ai[ i ] ) )
		{
			continue;
		}

		living_ai[ living_ai.size ] = ai[ i ];
	}
	return living_ai;
}

ai_should_be_added( ai )
{
	if( isalive( ai ) )
	{
		return true;
	}
	
	if ( !IsDefined( ai ) )
	{
		return false;
	}
	
	if ( !IsDefined( ai.classname ) )
	{
		return false;
	}
		
	return ai.classname == "script_model";
}

spawn_ai_group()
{
	HasRiders = ( IsDefined( self.script_vehicleride ) );
	HasWalkers = ( IsDefined( self.script_vehiclewalk ) );
	if( !( HasRiders || HasWalkers ) )
	{
		return;
	}
	spawners = [];

	riderspawners = [];
	walkerspawners = [];

	if( HasRiders )
	{
		riderspawners = level.vehicle_RideSpawners[ self.script_vehicleride ];
	}
	
	if( !IsDefined( riderspawners ) )
	{
		riderspawners = [];
	}

	if( HasWalkers )
	{
		walkerspawners = level.vehicle_walkspawners[ self.script_vehiclewalk ];
	}
	
	if( !IsDefined( walkerspawners ) )
	{
		walkerspawners = [];
	}


	spawners = ArrayCombine( riderspawners, walkerspawners, true, false );
	startinvehicles = [];
	
	for(i = 0; i < spawners.size; i ++)
	{
		spawners[i].script_forcespawn = true;	// All riders and walkers should always spawn...  DSL
	}

	ai = spawn_array( spawners );

	if( HasRiders )
	{
		if( IsDefined( level.vehicle_RideAI[ self.script_vehicleride ] ) )
		{
			ai = ArrayCombine( ai, level.vehicle_RideAI[ self.script_vehicleride ], true, false );
		}
	}
	
	if( HasWalkers )
	{
		if( IsDefined( level.vehicle_WalkAI[ self.script_vehiclewalk ] ) )
		{
			ai = ArrayCombine( ai, level.vehicle_WalkAI[ self.script_vehiclewalk ], true, false );
			ai vehicle_rider_walk_setup (self);
		}
	}

	ai = sort_by_startingpos( ai );
	
	for ( i = 0; i < ai.size; i++ )
	{
		ai[ i ] thread maps\_vehicle_aianim::vehicle_enter( self, self.script_tag );
	}
}
		
sort_by_startingpos( guysarray )
{
	firstarray = [];
	secondarray = [];

	for ( i = 0 ; i < guysarray.size ; i++ )
	{
		if ( IsDefined( guysarray[ i ].script_startingposition ) )
		{
			firstarray[ firstarray.size ] = guysarray[ i ];
		}
		else
		{
			secondarray[ secondarray.size ] = guysarray[ i ];
		}
	}

	return ArrayCombine( firstarray, secondarray, true, false );
}

vehicle_rider_walk_setup( vehicle )
{
	if ( !IsDefined( self.script_vehiclewalk ) )
	{
		return;
	}

	if ( IsDefined( self.script_followmode ) )
	{
		self.FollowMode = self.script_followmode;
	}
	else
	{
		self.FollowMode = "cover nodes";
	}

	// check if the AI should go to a node after walking with the vehicle
	if ( !IsDefined( self.target ) )
	{
		return;
	}

	node = getnode( self.target, "targetname" );
	if( IsDefined( node ) )
	{
		self.NodeAftervehicleWalk = node;
	}
}

/* DEAD CODE REMOVAL
runtovehicle( guy )
{
	guyarray = [];

	climbinnode = self.climbnode;
	climbinanim = self.climbanim;
	closenode = climbinnode[ 0 ];
	currentdist = 5000;
	thenode = undefined;

	for( i = 0; i < climbinnode.size; i++ )
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
		guy enter_vehicle(  self );
	}
}
*/

/* DEAD CODE REMOVAL
runtovehicle_setgoal( guy )
{
	guy.vehicle_goal = false;
	self endon( "death" );
	guy endon( "death" );
	guy waittill( "goal" );
	guy.vehicle_goal = true;
}
*/

setup_groundnode_detour( node )
{
	realdetournode = getvehiclenode( node.targetname, "target" );
	if( !IsDefined( realdetournode ) )
	{
		return;
	}

	realdetournode.detoured = 0;
	add_proccess_trigger( realdetournode );
}

add_proccess_trigger( trigger )
{
	// TODO: next game. stop trying to make everything a trigger.  remove trigger process. I'd do it this game but there is too much complexity in Detour nodes.
	 // .processedtrigger is a flag that I set to keep a trigger from getting added twice.
	if( IsDefined( trigger.processed_trigger ) )
	{
		return;
	}
	
	ARRAY_ADD( level.vehicle_processtriggers, trigger );
	trigger.processed_trigger = true;
}

islastnode( node )
{
	if( !IsDefined( node.target ) )
	{
		return true;
	}

	if( !IsDefined( getvehiclenode( node.target, "targetname" ) ) && !IsDefined( get_vehiclenode_any_dynamic( node.target ) )  )
	{
		return true;
	}

	return false;
}

vehicle_paths( node )
{
	self endon( "death" );
	
	assert( IsDefined( node ) || IsDefined( self.attachedpath ), "vehicle_path() called without a path" );
	self notify( "newpath" );

	 // dynamicpaths unique.  node isn't defined by info vehicle node calls to this function
	if( IsDefined( node ) )
	{
		self.attachedpath = node;
	}
	
	pathstart = self.attachedpath;
	self.currentNode = self.attachedpath;

	if ( !IsDefined( pathstart ) )
	{
		return;
	}
	
/#
	self thread debug_vehicle_paths();
#/

	self endon( "newpath" );

	currentPoint = pathstart;

	while ( IsDefined( currentPoint ) )
	{
		self waittill( "reached_node", currentPoint );
		
		currentPoint enable_turrets( self );

		if ( !IsDefined( self ) )
		{
			return;
		}
			
		self.currentNode = currentPoint;
		self.nextNode = ( IsDefined( currentPoint.target ) ? GetVehicleNode( currentPoint.target, "targetname" ) : undefined );

		if ( IsDefined( currentPoint.gateopen ) && !currentPoint.gateopen )
		{
			 // threaded because vehicle may setspeed( 0, 15 ) and run into the next node
			self thread path_gate_wait_till_open( currentPoint );
		}
		
		currentPoint notify( "trigger", self );
		
		// SRS 05/03/07: added for _planeweapons to drop bombs
		// amount, delay, delay trace
		if( IsDefined( currentPoint.script_dropbombs ) && currentPoint.script_dropbombs > 0 )
		{
			amount = currentPoint.script_dropbombs;
			delay = 0;
			delaytrace = 0;
			
			if( IsDefined( currentPoint.script_dropbombs_delay ) && currentPoint.script_dropbombs_delay > 0 )
			{
				delay = currentPoint.script_dropbombs_delay;
			}
			
			if( IsDefined( currentPoint.script_dropbombs_delaytrace ) && currentPoint.script_dropbombs_delaytrace > 0 )
			{
				delaytrace = currentPoint.script_dropbombs_delaytrace;
			}
			
			self notify( "drop_bombs", amount, delay, delaytrace );
		}

		if ( IsDefined( currentPoint.script_noteworthy ) )
		{
			self notify( currentPoint.script_noteworthy );
			self notify( "noteworthy", currentPoint.script_noteworthy );
		}

		if ( IsDefined( currentPoint.script_notify) )
		{
			self notify( currentPoint.script_notify );
			level notify( currentPoint.script_notify );
		}
		
		waittillframeend; // this lets other scripts interupt
		
		if ( !IsDefined( self ) )
		{
			return;
		}

		if ( IsDefined( currentPoint.script_noteworthy ) )
		{
			if ( currentPoint.script_noteworthy == "godon" )
			{
				self godon();
			}
			else if ( currentPoint.script_noteworthy == "godoff" )
			{
				self godoff();
			}
			else if ( currentPoint.script_noteworthy == "deleteme" )
			{
				if ( IsDefined( self.riders ) && self.riders.size > 0 )
				{
					array_delete( self.riders );
				}
				
				VEHICLE_DELETE( self );
				return;
			}
			else if ( currentPoint.script_noteworthy == "drivepath" )
			{
				self DrivePath();	// this will auto tilt and stuff for helicopters
			}
			else if ( currentPoint.script_noteworthy == "lockpath" )
			{
				self StartPath();	// this will stop the auto tilting and lock the heli back on the spline
			}
			else if ( currentPoint.script_noteworthy == "brake" )
			{
				if ( self.isphysicsvehicle )
				{
					self SetBrake( true );
				}
				
				self SetSpeed( 0, 60, 60 );
			}
		}
		
		if ( IsDefined( currentPoint.script_crashtypeoverride ) )
		{
			self.script_crashtypeoverride = currentPoint.script_crashtypeoverride;
		}

		if ( IsDefined( currentPoint.script_badplace ) )
		{
			self.script_badplace = currentPoint.script_badplace;
		}

		if ( IsDefined( currentPoint.script_team ) )
		{
			self.vteam = currentPoint.script_team;
		}

		if ( IsDefined( currentPoint.script_turningdir ) )
		{
			self notify( "turning", currentPoint.script_turningdir );
		}
			
		if ( IsDefined( currentPoint.script_deathroll ) )
		{
			if ( currentPoint.script_deathroll == 0 )
			{
				self thread deathrolloff();
			}
			else
			{
				self thread deathrollon();
			}
		}
		
		if ( IsDefined( currentPoint.script_vehicleaianim ) )
		{
			if ( IsDefined( currentPoint.script_parameters ) && currentPoint.script_parameters == "queue" )
			{
				self.queueanim = true;
			}
			if ( IsDefined( currentPoint.script_startingposition ) )
			{
				self.groupedanim_pos = currentPoint.script_startingposition;
			}
			
			self notify( "groupedanimevent", currentPoint.script_vehicleaianim );
		}
	
		if ( IsDefined( currentPoint.script_exploder ) )
		{
			exploder( currentPoint.script_exploder );
		}

		if ( IsDefined( currentPoint.script_flag_set ) )
		{
			if ( IsDefined( self.vehicle_flags ) )
			{
				self.vehicle_flags[ currentPoint.script_flag_set ] = true;
			}
			
			self notify( "vehicle_flag_arrived", currentPoint.script_flag_set );
			flag_set( currentPoint.script_flag_set );
		}

		if ( IsDefined( currentPoint.script_flag_clear ) )
		{
			if ( IsDefined( self.vehicle_flags ) )
			{
				self.vehicle_flags[ currentPoint.script_flag_clear ] = false;
			}
			
			flag_clear( currentPoint.script_flag_clear );
		}
				
		if ( IS_HELICOPTER( self ) && IsDefined( self.drivepath ) && self.drivepath == 1 )
		{
			if ( IsDefined( self.nextNode ) && IsDefined( self.nextNode.script_unload ) )
			{
				unload_node_helicopter( undefined );
				self.attachedpath = self.nextNode;
				self DrivePath( self.attachedpath );
			}
		}
		else 
		{
			if ( IsDefined( currentPoint.script_unload ) )
			{
				unload_node( currentPoint );
			}
		}
		
		if ( IsDefined( currentPoint.script_wait ) )
		{
			vehicle_pause_path();
			currentPoint script_wait();
		}
		
		if ( IsDefined( currentPoint.script_waittill ) )
		{
			vehicle_pause_path();
			self waittill( currentPoint.script_waittill );
		}

		if( IsDefined( currentPoint.script_flag_wait ) )
		{
			if ( !IsDefined( self.vehicle_flags ) )
			{
				self.vehicle_flags = [];
			}

			self.vehicle_flags[ currentPoint.script_flag_wait ] = true;
			self notify( "vehicle_flag_arrived", currentPoint.script_flag_wait );
			self ent_flag_set( "waiting_for_flag" );

			// helicopters stop on their own because they know to stop at destination for script_flag_wait
			// may have to provide a smoother way to stop and go tho, this is rather arbitrary, for tanks
			// in this case
			
			if ( !flag( currentPoint.script_flag_wait ) )
			{
				vehicle_pause_path();
				flag_wait( currentPoint.script_flag_wait );
			}

			self ent_flag_clear( "waiting_for_flag" );
		}
			
		if ( IsDefined( self.set_lookat_point ) )
		{
			self.set_lookat_point = undefined;
			self clearLookAtEnt();
		}
	
		if ( IsDefined( currentPoint.script_lights_on ) )
		{
			if ( currentPoint.script_lights_on )
			{
				self lights_on();
			}
			else
			{
				self lights_off();
			}
		}

		if ( IsDefined( currentPoint.script_stopnode ) )
		{
			self setvehgoalpos_wrap( currentPoint.origin, true );
		}
		
		if ( IsDefined( self.switchNode ) )
		{
			if ( currentPoint == self.switchNode ) 
			{
				self.switchNode = undefined;	
			}
		}
		else
		{
			if ( !IsDefined( currentPoint.target ) )
			{
				break;
			}
		}
		
		vehicle_resume_path();
	}

	self notify( "reached_dynamic_path_end" );
	
	if ( IsDefined( self.script_vehicle_selfremove ) )
	{
		self delete();
	}
}

vehicle_pause_path()
{
	if ( !IS_TRUE( self.vehicle_paused ) )
	{
		if ( self.isphysicsvehicle )
		{
			self SetBrake( true );
		}
		
		if ( IS_HELICOPTER( self ) )
		{
			if ( IS_TRUE( self.drivepath ) )
			{
				// hover
				self SetVehGoalPos( self.origin, true );
			}
			else
			{
				self SetSpeed( 0, 100, 100 );
			}
		}
		else
		{
			self SetSpeed( 0, 35, 35 );
		}
		
		self.vehicle_paused = true;
	}
}

vehicle_resume_path()
{
	if ( IS_TRUE( self.vehicle_paused ) )
	{
		if ( self.isphysicsvehicle )
		{
			self SetBrake( false );
		}
		
		if ( IS_HELICOPTER( self ) )
		{
			if ( IS_TRUE( self.drivepath ) )
			{
				// stop hovering and get back on path
				self DrivePath( self.currentNode );
			}
						
			self ResumeSpeed( 100 );
		}
		else
		{
			self ResumeSpeed( 35 );
		}
		
		self.vehicle_paused = undefined;
	}
}

// AE 5-15-09: cleaned this up and added the path_start parameter
getonpath(path_start) // self == vehicle
{
	if( !IsDefined( path_start ) )
	{
		return;
	}
	
	//[ceng 4/26/2010] If a vehicle previously used go_path() then .hasstarted
	//would be set but never cleared, preventing the vehicle from using go_path()
	//again. This allows the vehicle to follow more paths beyond their first.
	if( isDefined( self.hasstarted ) )
	{
		self.hasstarted = undefined;
	}
	
	self.attachedpath = path_start;
	
	if ( !IS_TRUE( self.drivepath ) )
	{
		//self.origin = path_start.origin;
		self AttachPath( path_start );
	}
	
	if( !IsDefined( self.dontDisconnectPaths ) && !IsSentient(self) )
	{
		self vehicle_disconnectpaths_wrapper();
	}

	if (IS_TRUE(self.isphysicsvehicle))
	{
		self SetBrake(true);
	}

	self thread vehicle_paths();
}

getoffpath()
{
	self CancelAIMove();	
	self ClearVehGoalPos();	
}


/@
"Name: create_vehicle_from_spawngroup_and_gopath( <spawnGroup> )"
"Summary: spawns and returns and array of the vehicles in the specified spawngroup starting them on their paths"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <spawnGroup> : the script_vehiclespawngroup asigned to the vehicles in radiant"
"Example: maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( spawnGroup )"
"SPMP: singleplayer"
@/

create_vehicle_from_spawngroup_and_gopath( spawnGroup )
{
	vehicleArray = maps\_vehicle::scripted_spawn( spawnGroup );
	for( i = 0; i < vehicleArray.size; i++ )
	{
		if (IsDefined(vehicleArray[ i ]))
		{
			vehicleArray[ i ] thread maps\_vehicle::gopath();
		}
	}
	return vehicleArray;
}

// AE 5-15-09: cleaned up by taking out the vehicle parameter and just having the vehicle as self
gopath() // self == vehicle
{
	self endon( "death" );
	self endon( "stop path" );
	
	if( self.isphysicsvehicle )
	{
		self SetBrake(false);
	}

	if( IsDefined( self.script_vehiclestartmove ) )
	{
		ArrayRemoveValue( level.vehicle_StartMoveGroup[ self.script_vehiclestartmove ], self );
	}
	
	if( IsDefined( self.hasstarted ) )
	{
		/#println( "vehicle already moving when triggered with a startmove" );#/
		return;
	}
	else
	{
		self.hasstarted = true;
	}

	self script_delay();

	self notify( "start_vehiclepath" );

	if ( IS_TRUE( self.drivepath ) )
	{
		self DrivePath( self.attachedpath );
	}
	else
	{
		self StartPath();
	}
			
	// start waiting for the end of the path
	wait .05;
	self vehicle_connectpaths_wrapper();
	self waittill( "reached_end_node" );

	if ( !IsDefined( self.dontDisconnectPaths ) && !IsSentient( self ) )
	{
		self vehicle_disconnectpaths_wrapper();
	}

	if( IsDefined( self.currentnode ) && IsDefined( self.currentnode.script_noteworthy ) && self.currentnode.script_noteworthy == "deleteme" )
	{
		return;
	}

	if ( !IsDefined( self.dontunloadonend ) )
	{
		do_unload( self.script_unloaddelay );
	}
}

// self == vehicle
do_unload( delay )
{
	self endon( "unload" );

	if (IsDefined(delay) && delay > 0)
	{
		wait delay;
	}

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
	{
		script_resumespeed( "gate opened", level.vehicle_ResumeSpeed );
	}
}

spawner_setup( vehicles, spawngroup )
{
	level.vehicle_spawners[ spawngroup ] = [];
	
	foreach ( veh in vehicles )
	{
		veh thread vehicle_main();
		
		 // creates struct that copies certain values from the vehicle to be added when the vehicle is spawned.
		s_spawner = CreateStruct();
		
		veh vehicle_dynamic_cover( s_spawner );
		s_spawner set_spawner_variables( veh );

		level.vehicle_spawners[ spawngroup ][ level.vehicle_spawners[ spawngroup ].size ] = s_spawner;
	}

	// Spin the tread that spawns vehicles for this group when notified
	thread vehicle_spawn_group( spawngroup );
}

vehicle_spawn_group( spawngroup )
{
	while( 1 )
	{
		// waittill we get a notify for our group
		level waittill( "spawnvehiclegroup" + spawngroup );

		spawned_vehicles = [];
		
		// for all spawners in the group
		for( i = 0; i < level.vehicle_spawners[ spawngroup ].size; i++ )
		{
			// spawn the vehicle
			spawned_vehicles[ spawned_vehicles.size ] = vehicle_spawn( level.vehicle_spawners[ spawngroup ][ i ] );
		}

		// notify we spawned and pass back spawned vehicles
		level notify( "vehiclegroup spawned" + spawngroup, spawned_vehicles );
	}
}

/@
"Name: scripted_spawn( <group> )"
"Summary: spawns and returns a vehiclegroup, you will need to tell it to maps\_vehicle::gopath() when you want it to go"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <group> : "
"Example: bmps = maps\_vehicle::scripted_spawn( 32 );"
"SPMP: singleplayer"
@/

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

set_spawner_variables( vehicle )
{
	self.spawnermodel = vehicle.model;
	self.angles = vehicle.angles;
	self.origin = vehicle.origin;
	if( IsDefined( vehicle.script_delay ) )
	{
		self.script_delay = vehicle.script_delay;
	}

	if( IsDefined( vehicle.script_noteworthy ) )
	{
		self.script_noteworthy = vehicle.script_noteworthy;
	}

	if( IsDefined( vehicle.script_parameters ) )
	{
		self.script_parameters = vehicle.script_parameters;
	}

	if( IsDefined( vehicle.script_team ) )
	{
		self.script_team = vehicle.script_team;
	}

	if( IsDefined( vehicle.script_vehicleride ) )
	{
		self.script_vehicleride = vehicle.script_vehicleride;
	}

	if( IsDefined( vehicle.target ) )
	{
		self.target = vehicle.target;
	}
	
	if( IsDefined( vehicle.targetname ) )
	{
		self.targetname = vehicle.targetname;
	}
	else
	{
		self.targetname = "notdefined";
	}

	self.spawnedtargetname = self.targetname;

	self.targetname = self.targetname + "_vehiclespawner";
	if( IsDefined( vehicle.triggeredthink ) )
	{
		self.triggeredthink = vehicle.triggeredthink;
	}

	if( IsDefined( vehicle.script_sound ) )
	{
		self.script_sound = vehicle.script_sound;
	}

	if( IsDefined( vehicle.script_startinghealth ) )
	{
		self.script_startinghealth = vehicle.script_startinghealth;
	}

	if( IsDefined( vehicle.spawnerNum ) )
	{
		self.spawnerNum = vehicle.spawnerNum;
	}

	if( IsDefined( vehicle.script_deathnotify ) )
	{
		self.script_deathnotify = vehicle.script_deathnotify;
	}

	if( IsDefined( vehicle.script_enable_turret0 ) )
	{
		self.script_enable_turret0 = vehicle.script_enable_turret0;
	}
	
	if( IsDefined( vehicle.script_enable_turret1 ) )
	{
		self.script_enable_turret1 = vehicle.script_enable_turret1;
	}
	
	if( IsDefined( vehicle.script_enable_turret2 ) )
	{
		self.script_enable_turret2 = vehicle.script_enable_turret2;
	}
	
	if( IsDefined( vehicle.script_enable_turret3 ) )
	{
		self.script_enable_turret3 = vehicle.script_enable_turret3;
	}
	
	if( IsDefined( vehicle.script_enable_turret4 ) )
	{
		self.script_enable_turret4 = vehicle.script_enable_turret4;
	}

	if( IsDefined( vehicle.script_linkTo ) )
	{
		self.script_linkTo = vehicle.script_linkTo;
	}

	if( IsDefined( vehicle.script_VehicleSpawngroup ) )
	{
		self.script_VehicleSpawngroup = vehicle.script_VehicleSpawngroup;
	}

	if( IsDefined( vehicle.script_VehicleStartMove ) )
	{
		self.script_VehicleStartMove = vehicle.script_VehicleStartMove;
	}

	if( IsDefined( vehicle.script_vehicleGroupDelete ) )
	{
		self.script_vehicleGroupDelete = vehicle.script_vehicleGroupDelete;
	}

	if( IsDefined( vehicle.script_vehicle_selfremove ) )
	{
		self.script_vehicle_selfremove = vehicle.script_vehicle_selfremove;
	}

	if( IsDefined( vehicle.script_nomg ) )
	{
		self.script_nomg = vehicle.script_nomg;
	}

	if( IsDefined( vehicle.script_badplace ) )
	{
		self.script_badplace = vehicle.script_badplace;
	}

	if( IsDefined( vehicle.script_vehicleride ) )
	{
		self.script_vehicleride = vehicle.script_vehicleride;
	}

	if( IsDefined( vehicle.script_vehiclewalk ) )
	{
		self.script_vehiclewalk = vehicle.script_vehiclewalk;
	}

	if( IsDefined( vehicle.script_linkName ) )
	{
		self.script_linkName = vehicle.script_linkName;
	}

	if( IsDefined( vehicle.script_crashtypeoverride ) )
	{
		self.script_crashtypeoverride = vehicle.script_crashtypeoverride;
	}

	if( IsDefined( vehicle.script_unloaddelay ) )
	{
		self.script_unloaddelay = vehicle.script_unloaddelay;
	}

	if( IsDefined( vehicle.script_unloadmgguy ) )
	{
		self.script_unloadmgguy = vehicle.script_unloadmgguy;
	}

	if( IsDefined( vehicle.script_keepdriver ) )
	{
		self.script_keepdriver = vehicle.script_keepdriver;
	}

	if( IsDefined( vehicle.script_fireondrones ) )
	{
		self.script_fireondrones = vehicle.script_fireondrones;
	}

	if( IsDefined( vehicle.script_tankgroup ) )
	{
		self.script_tankgroup = vehicle.script_tankgroup;
	}

	if( IsDefined( vehicle.script_playerconeradius ) )
	{
		self.script_playerconeradius = vehicle.script_playerconeradius;
	}

	if( IsDefined( vehicle.script_cobratarget ) )
	{
		self.script_cobratarget = vehicle.script_cobratarget;
	}

	if( IsDefined( vehicle.script_targettype ) )
	{
		self.script_targettype = vehicle.script_targettype;
	}

	if( IsDefined( vehicle.script_targetoffset_z ) )
	{
		self.script_targetoffset_z = vehicle.script_targetoffset_z;
	}

	if( IsDefined( vehicle.script_wingman ) )
	{
		self.script_wingman = vehicle.script_wingman;
	}

	if( IsDefined( vehicle.script_mg_angle ) )
	{
		self.script_mg_angle = vehicle.script_mg_angle;
	}

	if( IsDefined( vehicle.script_physicsjolt ) )
	{
		self.script_physicsjolt = vehicle.script_physicsjolt;
	}

	if( IsDefined( vehicle.script_lights_on ) )
	{
		self.script_lights_on = vehicle.script_lights_on;
	}

	if( IsDefined( vehicle.script_vehicledetourgroup ) )
	{
		self.script_vehicledetourgroup = vehicle.script_vehicledetourgroup;
	}

	if( IsDefined( vehicle.speed ) )
	{
		self.speed = vehicle.speed;
	}

	if( IsDefined( vehicle.script_vehicletriggergroup ) )
	{
		self.script_vehicletriggergroup = vehicle.script_vehicletriggergroup;
	}

	if( IsDefined( vehicle.script_cheap ) )
	{
		self.script_cheap = vehicle.script_cheap;
	}

	// SCRIPTER_MOD: JesseS (7/21/2007): added script_nonmovingvehicle to eventually replace script_flak88
	if( IsDefined( vehicle.script_nonmovingvehicle ) )
	{
		self.script_nonmovingvehicle = vehicle.script_nonmovingvehicle;
	}

	if( IsDefined( vehicle.script_flag ) )
	{
		self.script_flag = vehicle.script_flag;
	}

	if ( IsDefined( vehicle.script_disconnectpaths ) )
	{
		self.script_disconnectpaths = vehicle.script_disconnectpaths;
	}

	if ( IsDefined( vehicle.script_bulletshield ) )
	{
		self.script_bulletshield = vehicle.script_bulletshield;
	}

	if ( IsDefined( vehicle.script_godmode ) )
	{
		self.script_godmode = vehicle.script_godmode;
	}

	//// SCRIPTER_MOD: JesseS (5/12/200) - script_vehicleattackgroup added back in
	if (IsDefined (vehicle.script_vehicleattackgroup))
	{
		self.script_vehicleattackgroup = vehicle.script_vehicleattackgroup;
	}

	if (IsDefined (vehicle.script_vehicleattackgroupwait))
	{
		self.script_vehicleattackgroupwait = vehicle.script_vehicleattackgroupwait;
	}
	
	// guzzo - 4/1/08 - made it so script_friendname carries over to the spawned vehicle from the spawner
	if (IsDefined (vehicle.script_friendname))
	{
		self.script_friendname = vehicle.script_friendname;
	}

	// SCRIPTER_MOD: KevinD (4/8/2010): script_unload added to specify the unload group on the vehicle spawner
	if( IsDefined( vehicle.script_unload ) )
	{
		self.script_unload = vehicle.script_unload;
	}
	
	if( IsDefined(vehicle.script_string))
	{
		self.script_string = vehicle.script_string;
	}
	
	if( IsDefined(vehicle.script_int))
	{
		self.script_int = vehicle.script_int;
	}
	
	if( IsDefined(vehicle.script_animation))
	{
		self.script_animation = vehicle.script_animation;
	}

	if( IsDefined(vehicle.script_ignoreme))
	{
		self.script_ignoreme = vehicle.script_ignoreme;
	}

	if( IsDefined( vehicle.lockheliheight ) )
	{
		self.lockheliheight =  vehicle GetHeliHeightLock();
	}
	
	if( IsDefined( vehicle.script_targetset ) )
	{
		self.script_targetset = vehicle.script_targetset;
	}
	
	if( IsDefined( vehicle.script_targetoffset ) )
	{
		self.script_targetoffset = vehicle.script_targetoffset;
	}
	
	if ( IsDefined( vehicle.script_startstate ) )
	{
		self.script_startstate = vehicle.script_startstate;	
	}	
	
	if( IsDefined( vehicle.script_animname ) )
	{
		self.script_animname = vehicle.script_animname;
	}
	
	if ( IsDefined( vehicle.script_animscripted ) )
	{
		self.script_animscripted = vehicle.script_animscripted;
	}

	if ( IsDefined( vehicle.script_recordent ) )
	{
		self.script_recordent = vehicle.script_recordent;
	}
	
	if ( isdefined( vehicle.script_brake ) )
	{
		self.script_brake = vehicle.script_brake;
	}
	
	if ( IsDefined( vehicle.script_vehicleavoidance ) )
	{
		self.script_vehicleavoidance = vehicle.script_vehicleavoidance;	
	}
	
	if ( IsDefined( vehicle.script_doorstate ) )
	{
		self.script_doorstate = vehicle.script_doorstate;	
	}
	
	if ( IsDefined( vehicle.script_combat_getout ) )
	{
		self.script_combat_getout = vehicle.script_combat_getout;	
	}
	
	
	if ( IsDefined( vehicle.radius ) )
	{
		self.radius = vehicle.radius;
	}
	
	if( vehicle.count > 0 )
	{
		self.count = vehicle.count;
	}
	else
	{
		self.count = 1;
	}

	if( !IsDefined(self.vehicletype) )
	{
		if( IsDefined( vehicle.vehicletype ) )
		{
			self.vehicletype = vehicle.vehicletype;
		}
	}
	
	if( IsDefined(vehicle.destructibledef) )
	{
		self.destructibledef = vehicle.destructibledef;
	}
	
	// can't call vehicle functions if it is a spawner
	if ( !vehicle has_spawnflag( SPAWNFLAG_VEHICLE_SPAWNER ) && vehicle IsVehicleUsable() )
	{
		self.usable = 1;
	}
	
	if ( IsDefined( vehicle.drivepath ) )
	{
		self.drivepath = vehicle.drivepath;
	}
			
	// SRS 05/03/07: added to support _planeweapons dropping bombs
	if( IsDefined( vehicle.script_numbombs ) )
	{
		self.script_numbombs = vehicle.script_numbombs;
	}
	
	if( IsDefined(vehicle.deathfx))
	{
		self.deathfx = vehicle.deathfx;
	}
	
	if ( IsDefined( vehicle.fx_crash_effects ) )
	{
		self.fx_crash_effects = vehicle.fx_crash_effects;
	}
	
	if ( IsDefined( vehicle.m_objective_model ) )
	{
		self.m_objective_model = vehicle.m_objective_model;
	}
	
	vehicle delete();
	
	id = vehicle_spawnidgenerate( self.origin );
	self.spawner_id = id;
	//level.vehicle_spawners[ id ] = self;
}

vehicle_spawnidgenerate( origin )
{
	return "spawnid" + int( origin[ 0 ] ) + "a" + int( origin[ 1 ] ) + "a" + int( origin[ 2 ] );
}

// CODER_MOD: Tommy K
vehicleDamageAssist()
{
	self endon( "death" );
	
	self.attackers = [];
	self.attackerData = [];
		
	while( true )
	{
		self waittill( "damage", amount, attacker );
		
		if( !IsDefined ( attacker ) || !isPlayer(attacker) )
		{
			continue;
		}
	
		if ( !IsDefined( self.attackerData[ attacker getEntityNumber() ] ) )
		{
			self.attackers[ self.attackers.size ] = attacker;
			self.attackerData[ attacker getEntityNumber() ] = false;
		}
	}

}

vehicle_spawn( vspawner, from )
{
	if( !vspawner.count )
	{
		return;
	}

	vehicle = spawnVehicle( vspawner.spawnermodel, vspawner.spawnedtargetname, vspawner.vehicletype, vspawner.origin, vspawner.angles, vspawner.destructibledef );

	if( IsDefined( vspawner.destructibledef ) )
	{
		vehicle.destructibledef = vspawner.destructibledef;
		vehicle thread maps\_destructible::destructible_think();
	}
		
	if( IsDefined( vspawner.script_delay ) )
	{
		vehicle.script_delay =	vspawner.script_delay;
	}
	
	if( IsDefined( vspawner.script_noteworthy ) )
	{
		vehicle.script_noteworthy = vspawner.script_noteworthy;
	}
	
	if( IsDefined( vspawner.script_parameters ) )
	{
		vehicle.script_parameters =	vspawner.script_parameters;
	}
	
	if( IsDefined( vspawner.script_team ) )
	{
		vehicle.vteam = vspawner.script_team;
	}
	
	if( IsDefined( vspawner.script_vehicleride ) )
	{
		vehicle.script_vehicleride = vspawner.script_vehicleride;
	}
	
	if( IsDefined( vspawner.target ) )
	{
		vehicle.target = vspawner.target;
	}
	
	if( IsDefined( vspawner.vehicletype ) && !IsDefined( vehicle.vehicletype ) )
	{
		vehicle.vehicletype =	vspawner.vehicletype;
	}
	
	if( IsDefined( vspawner.triggeredthink ) )
	{
		vehicle.triggeredthink = vspawner.triggeredthink;
	}
	
	if( IsDefined( vspawner.script_sound ) )
	{
		vehicle.script_sound = vspawner.script_sound;
	}
	
	if( IsDefined( vspawner.script_startinghealth ) )
	{
		vehicle.script_startinghealth = vspawner.script_startinghealth;
	}
	
	if(IsDefined( vspawner.script_deathnotify ) )
	{
		vehicle.script_deathnotify = vspawner.script_deathnotify;
	}
	
	if( IsDefined( vspawner.script_enable_turret0 ) )
	{
		vehicle.script_enable_turret0 = vspawner.script_enable_turret0;
	}
	
	if( IsDefined( vspawner.script_enable_turret1 ) )
	{
		vehicle.script_enable_turret1 = vspawner.script_enable_turret1;
	}
	
	if( IsDefined( vspawner.script_enable_turret2 ) )
	{
		vehicle.script_enable_turret2 = vspawner.script_enable_turret2;
	}
	
	if( IsDefined( vspawner.script_enable_turret3 ) )
	{
		vehicle.script_enable_turret3 = vspawner.script_enable_turret3;
	}
	
	if( IsDefined( vspawner.script_enable_turret4 ) )
	{
		vehicle.script_enable_turret4 = vspawner.script_enable_turret4;
	}
	
	if( IsDefined(vspawner.script_linkTo ) )
	{
		vehicle.script_linkTo = vspawner.script_linkTo;
	}
	
	if( IsDefined( vspawner.script_VehicleSpawngroup ) )
	{
		vehicle.script_VehicleSpawngroup = vspawner.script_VehicleSpawngroup;
	}
	
	if(	IsDefined( vspawner.script_VehicleStartMove ) )
	{
		vehicle.script_VehicleStartMove = vspawner.script_VehicleStartMove;
	}
	
	if(	IsDefined( vspawner.script_vehicleGroupDelete ) )
	{
		vehicle.script_vehicleGroupDelete = vspawner.script_vehicleGroupDelete;
	}
	
	if( IsDefined( vspawner.script_vehicle_selfremove ) )
	{
		vehicle.script_vehicle_selfremove = vspawner.script_vehicle_selfremove;
	}

	if( IsDefined( vspawner.script_nomg ) )
	{
		vehicle.script_nomg = vspawner.script_nomg;
	}

	if( IsDefined( vspawner.script_badplace ) )
	{
		vehicle.script_badplace = vspawner.script_badplace;
	}

	if( IsDefined( vspawner.script_vehicleride ) )
	{
		vehicle.script_vehicleride = vspawner.script_vehicleride;
	}

	if( IsDefined( vspawner.script_vehiclewalk ) )
	{
		vehicle.script_vehiclewalk = vspawner.script_vehiclewalk;
	}

	if( IsDefined( vspawner.script_linkName ) )
	{
		vehicle.script_linkName = vspawner.script_linkName;
	}

	if( IsDefined( vspawner.script_crashtypeoverride ) )
	{
		vehicle.script_crashtypeoverride = vspawner.script_crashtypeoverride;
	}

	if( IsDefined( vspawner.script_unloaddelay ) )
	{
		vehicle.script_unloaddelay = vspawner.script_unloaddelay;
	}

	if( IsDefined( vspawner.script_unloadmgguy ) )
	{
		vehicle.script_unloadmgguy = vspawner.script_unloadmgguy;
	}

	if( IsDefined( vspawner.script_keepdriver ) )
	{
		vehicle.script_keepdriver = vspawner.script_keepdriver;
	}

	if( IsDefined( vspawner.script_fireondrones ) )
	{
		vehicle.script_fireondrones = vspawner.script_fireondrones;
	}

	if( IsDefined( vspawner.script_tankgroup ) )
	{
		vehicle.script_tankgroup = vspawner.script_tankgroup;
	}

	if( IsDefined( vspawner.script_playerconeradius ) )
	{
		vehicle.script_playerconeradius = vspawner.script_playerconeradius;
	}

	if( IsDefined( vspawner.script_cobratarget ) )
	{
		vehicle.script_cobratarget = vspawner.script_cobratarget;
	}

	if( IsDefined( vspawner.script_targettype ) )
	{
		vehicle.script_targettype = vspawner.script_targettype;
	}

	if( IsDefined( vspawner.script_targetoffset_z ) )
	{
		vehicle.script_targetoffset_z = vspawner.script_targetoffset_z;
	}

	if( IsDefined( vspawner.script_wingman ) )
	{
		vehicle.script_wingman = vspawner.script_wingman;
	}

	if( IsDefined( vspawner.script_mg_angle ) )
	{
		vehicle.script_mg_angle = vspawner.script_mg_angle;
	}

	if( IsDefined( vspawner.script_physicsjolt ) )
	{
		vehicle.script_physicsjolt = vspawner.script_physicsjolt;
	}

	if( IsDefined( vspawner.script_cheap ) )
	{
		vehicle.script_cheap = vspawner.script_cheap;
	}

	if ( IsDefined( vspawner.script_flag ) )
	{
		vehicle.script_flag = vspawner.script_flag;
	}

	if( IsDefined( vspawner.script_lights_on ) )
	{
		vehicle.script_lights_on = vspawner.script_lights_on;
	}

	if( IsDefined( vspawner.script_vehicledetourgroup ) )
	{
		vehicle.script_vehicledetourgroup = vspawner.script_vehicledetourgroup;
	}

	if( IsDefined( vspawner.speed ) )
	{
		vehicle.speed = vspawner.speed;
	}

	if( IsDefined( vspawner.spawner_id ) )
	{
		vehicle.spawner_id = vspawner.spawner_id;
	}

	if( IsDefined( vspawner.script_vehicletriggergroup ) )
	{
		vehicle.script_vehicletriggergroup = vspawner.script_vehicletriggergroup;
	}

	if ( IsDefined( vspawner.script_disconnectpaths ) )
	{
		vehicle.script_disconnectpaths = vspawner.script_disconnectpaths;
	}
	
	if ( IsDefined( vspawner.script_godmode ) )
	{
		vehicle.script_godmode = vspawner.script_godmode;
	}
	
	if ( IsDefined( vspawner.script_bulletshield ) )
	{
		vehicle.script_bulletshield = vspawner.script_bulletshield;
	}
	
	// SRS 05/03/07: added to support _planeweapons dropping bombs
	if( IsDefined( vspawner.script_numbombs ) )
	{
		vehicle.script_numbombs = vspawner.script_numbombs;
	}

	if( IsDefined( vspawner.script_flag ) )
	{
		vehicle.script_flag = vspawner.script_flag;
	}

	// SCRIPTER_MOD: JesseS (7/21/2007): script_nonmovingvehicle added to eventually replace script_flak88
	if( IsDefined( vspawner.script_nonmovingvehicle ) )
	{
		vehicle.script_nonmovingvehicle = vspawner.script_nonmovingvehicle;
	}

	// SCRIPTER_MOD: JesseS (5/12/200) - script_vehicleattackgroup readded
	if( IsDefined( vspawner.script_vehicleattackgroup ) )
	{
		vehicle.script_vehicleattackgroup = vspawner.script_vehicleattackgroup;
	}

	if( IsDefined( vspawner.script_vehicleattackgroupwait ) )
	{
		vehicle.script_vehicleattackgroupwait = vspawner.script_vehicleattackgroupwait;
	}
	
	// guzzo - 4/1/08 - made it so script_friendname carries over to the spawned vehicle from the spawner
	if (IsDefined (vspawner.script_friendname))
	{
		vehicle SetVehicleLookAtText( vspawner.script_friendname, &"" );
	}

	// SCRIPTER_MOD: KevinD (4/8/2010): script_unload_group added to specify the unload group on the vehicle spawner
	if( IsDefined( vspawner.script_unload ) )
	{
		vehicle.unload_group = vspawner.script_unload;
	}
	
	if(IsDefined(vspawner.script_string))
	{
		vehicle.script_string = vspawner.script_string;
	}
	
	if ( IsDefined(vspawner.script_int) )
	{
		vehicle.script_int = vspawner.script_int;
	}
	
	if ( IsDefined(vspawner.script_animation) )
	{
		vehicle.script_animation = vspawner.script_animation;
	}

	if ( IsDefined( vspawner.lockheliheight ) )
	{
		vehicle SetHeliHeightLock( vehicle.lockheliheight );
	}
	
	if ( IsDefined( vspawner.script_targetset ) )
	{
		vehicle.script_targetset = vspawner.script_targetset;
	}
	
	if ( IsDefined( vspawner.script_targetoffset ) )
	{
		vehicle.script_targetoffset = vspawner.script_targetoffset;
	}
	
	if ( IsDefined( vspawner.script_startstate ) )
	{
		vehicle.script_startstate = vspawner.script_startstate;
	}	

	if ( IsDefined( vspawner.script_recordent ) )
	{
		vehicle.script_recordent = vspawner.script_recordent;
	}
	
	if ( isdefined( vspawner.e_dyn_path ) )
	{
		vehicle.e_dyn_path = vspawner.e_dyn_path;
	}
	
	if ( isdefined( vspawner.script_brake ) )
	{
		vehicle.script_brake = vspawner.script_brake;
	}
	
	if ( IsDefined( vspawner.script_vehicleavoidance ) )
	{
		vehicle.script_vehicleavoidance = vspawner.script_vehicleavoidance;	
	}
	
	if ( IsDefined( vspawner.script_doorstate ) )
	{
		vehicle.script_doorstate = vspawner.script_doorstate;	
	}
			
	if ( IsDefined( vspawner.script_combat_getout ) )
	{
		vehicle.script_combat_getout = vspawner.script_combat_getout;	
	}
	
	if ( IsDefined( vspawner.radius ) )
	{
		vehicle.radius = vspawner.radius;	
	}
	
	// Init vehicle!
	vehicle_init( vehicle );

	if( IsDefined( vehicle.targetname ) )
	{
		level notify( "new_vehicle_spawned" + vehicle.targetname, vehicle );
	}

	if( IsDefined( vehicle.script_noteworthy ) )
	{
        level notify( "new_vehicle_spawned" + vehicle.script_noteworthy, vehicle );
	}

	if ( IsDefined( vehicle.spawner_id ) )
	{
		level notify( "new_vehicle_spawned" + vehicle.spawner_id, vehicle );
	}
	
	if( IsDefined( vspawner.usable ) )
	{
		vehicle makeVehicleUsable();
	}
	
	if( IsDefined( vspawner.drivepath ) )
	{
		vehicle.drivepath = vspawner.drivepath;
	}
	
	if( IsDefined(vspawner.deathfx))
	{
		vehicle.deathfx = vspawner.deathfx;
	}
	
	if( IsDefined(vspawner.script_ignoreme))
	{
		vehicle.script_ignoreme = vspawner.script_ignoreme;
	}
	
	if( IsDefined(vspawner.script_animname))
	{
		vehicle.script_animname = vspawner.script_animname;
		vehicle.animname = vspawner.script_animname;
	}
	
	if ( IsDefined( vspawner.script_animscripted ) )
	{
		vehicle.supportsAnimScripted = vspawner.script_animscripted;
	}
	
	if ( IsDefined( vspawner.fx_crash_effects ) )
	{
		vehicle.fx_crash_effects = vspawner.fx_crash_effects;
	}

	if ( IsDefined( vspawner.m_objective_model ) )
	{
		vehicle.m_objective_model = vspawner.m_objective_model;
	}

	// CODER_MOD: Tommy K
	if ( vehicle.vteam == "axis" && IsDefined( level.vehicle_enemy_tanks[ vspawner.spawnermodel ] ) )
	{
		vehicle thread vehicleDamageAssist();
	}
	
	//-- GLocke: Vehicle Spawn Functions
	if( IsDefined(vspawner.spawn_funcs) )
	{
		for( i = 0; i < vspawner.spawn_funcs.size; i++ )
		{
			if (IsDefined(vehicle))
			{
				func = vspawner.spawn_funcs[ i ];
				single_thread(vehicle, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ]);
			}
		}
	}
	
	return vehicle;
}

vehicle_init( vehicle )
{
	vehicle UseAnimTree( #animtree );
	
	if ( isdefined( vehicle.e_dyn_path ) )
	{
		vehicle.e_dyn_path LinkTo( vehicle );
	}

	vehicle ent_flag_init("waiting_for_flag");
	vehicle.takedamage = !IS_TRUE(vehicle.script_godmode);

	vehicle.zerospeed = true;
	
	if( !IsDefined( vehicle.modeldummyon ) )
	{
		vehicle.modeldummyon = false;
	}
	
	if ( IS_TRUE( vehicle.isphysicsvehicle ) )
	{
		if ( IS_TRUE( vehicle.script_brake ) )
		{
			vehicle SetBrake( true );
		}
	}

	type = vehicle.vehicletype;

	 // give the vehicle health
	vehicle vehicle_life();

	// call the vehicle-specific init function
	vehicle thread vehicle_main();

	vehicle thread maingun_FX();

	vehicle.riders = [];
	vehicle.unloadque = [];  // for ai. wait till a vehicle is unloaded all the way

	// SCRIPTER_MOD: KevinD (4/8/2010): script_unload added to specify the unload group on the vehicle spawner
	if( !IsDefined(vehicle.unload_group) )
	{
		vehicle.unload_group = "default";
	}
	
	// getoutrig means fastrope.
	vehicle.getoutrig = [];
	if( IsDefined( level.vehicle_attachedmodels ) && IsDefined( level.vehicle_attachedmodels[ type ] ) )
	{
		rigs = level.vehicle_attachedmodels[ type ];
		strings = getarraykeys( rigs );
		for( i = 0; i < strings.size; i++ )
		{
			vehicle.getoutrig[ strings[ i ] ] = undefined;
			vehicle.getoutriganimating[ strings[ i ] ] = false;
		}
	}

	 // make ai run way from vehicle
	if( IsDefined( self.script_badplace ) )
	{
		vehicle thread vehicle_badplace();
	}

	 // toggle vehicle lights on / off
	if ( IS_TRUE( vehicle.script_lights_on ) )
	{
		vehicle lights_on();
	}

	 // regenerate friendly fire damage
	if( !vehicle isCheap() )
	{
		vehicle friendlyfire_shield();
	}

	 // handles guys riding and doing stuff on vehicles
	vehicle thread maps\_vehicle_aianim::handle_attached_guys();

	 // Make the main turret think
	 if ( IsDefined( vehicle.turretweapon ) && vehicle.turretweapon != "" )  // TravisJ - turretWeapons aren't in turrettagarray (those are gunner weapons), so check for both
		vehicle thread turret_shoot();

	 // make vehicle shake physics objects.
	if( IsDefined( vehicle.script_physicsjolt ) && vehicle.script_physicsjolt )
	{
		vehicle thread physicsjolt_proximity();
	}

	 // associate vehicle with living level variables.
	vehicle_Levelstuff( vehicle );

	// every vehicle that stops will disconnect its paths
	if( !vehicle isCheap() && ! IS_PLANE(vehicle) )
	{
		vehicle thread disconnect_paths_whenstopped();
	}

	if ( !IsDefined( vehicle.script_nonmovingvehicle ) )
	{
		if ( IsDefined( vehicle.target ) )
		{
			path_start = GetVehicleNode( vehicle.target, "targetname" );
			if ( !IsDefined( path_start ) )
			{
				path_start = GetEnt(vehicle.target, "targetname" );
				if ( !IsDefined( path_start ) )
				{
					path_start = getstruct( vehicle.target, "targetname" );
				}
			}
		}

		if ( IsDefined( path_start ) && vehicle.vehicletype != "inc_base_jump_spotlight" )
		{
			vehicle thread getonpath( path_start );
		}
	}
	
	if ( IsDefined( vehicle.script_vehicleattackgroup ) )
	{
		vehicle thread attackgroup_think();
	}

/#
	if( IS_TRUE( vehicle.script_recordent ) )
	{
		RecordEnt( vehicle );
	}
#/
	
	 // helicopters do dust kickup fx
	if( vehicle hasHelicopterDustKickup() )
	{
		if(!level.clientscripts)
		{
			vehicle thread aircraft_dust_kickup();
		}
	}

/#
	// MikeD (8/1/2007): Debug info for vehicles
	vehicle thread debug_vehicle();
#/

	// spawn the vehicle and it's associated ai
	vehicle spawn_ai_group();
	vehicle thread maps\_vehicle_death::main();
	
	// Set myself as a target if specificed
	if ( IsDefined( vehicle.script_targetset ) && vehicle.script_targetset == 1 )
	{
		offset = ( 0, 0, 0 );
		if ( IsDefined( vehicle.script_targetoffset ) )
		{
			offset = vehicle.script_targetoffset;
		}
		
		Target_Set( vehicle, offset );
	}
	
	if ( IsDefined( vehicle.script_vehicleavoidance ) && vehicle.script_vehicleavoidance == 1 )
	{
		vehicle SetVehicleAvoidance( true );
	}
	
	vehicle enable_turrets();
	
	if( IsDefined( level.vehicleSpawnCallbackThread ) )
	{
		level thread [[ level.vehicleSpawnCallbackThread ]]( vehicle );
	}
}

detach_getoutrigs()
{
	if ( !IsDefined( self.getoutrig ) )
		return;
	if ( ! self.getoutrig.size )
		return;
	keys = GetArrayKeys( self.getoutrig );
	for ( i = 0; i < keys.size; i++ )
	{
		self.getoutrig[ keys[ i ] ] Unlink();
	}
}

enable_turrets( veh )
{
	if ( !IsDefined( veh ) )
	{
		veh = self;
	}
	
	if ( IS_TRUE( self.script_enable_turret0 ) )
	{
		veh maps\_turret::enable_turret( 0 );
	}

	if ( IS_TRUE( self.script_enable_turret1 ) )
	{
		veh maps\_turret::enable_turret( 1 );
	}
	
	if ( IS_TRUE( self.script_enable_turret2 ) )
	{
		veh maps\_turret::enable_turret( 2 );
	}
	
	if ( IS_TRUE( self.script_enable_turret3 ) )
	{
		veh maps\_turret::enable_turret( 3 );
	}
	
	if ( IS_TRUE( self.script_enable_turret4 ) )
	{
		veh maps\_turret::enable_turret( 4 );
	}
	
	if ( IS_FALSE( self.script_enable_turret0 ) )
	{
		veh maps\_turret::disable_turret( 0 );
	}

	if ( IS_FALSE( self.script_enable_turret1 ) )
	{
		veh maps\_turret::disable_turret( 1 );
	}
	
	if ( IS_FALSE( self.script_enable_turret2 ) )
	{
		veh maps\_turret::disable_turret( 2 );
	}
	
	if ( IS_FALSE( self.script_enable_turret3 ) )
	{
		veh maps\_turret::disable_turret( 3 );
	}
	
	if ( IS_FALSE( self.script_enable_turret4 ) )
	{
		veh maps\_turret::disable_turret( 4 );
	}
}

disconnect_paths_whenstopped()
{
	if( IsSentient( self) ) 
	{
		return;
	}
	
	if ( isdefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
	{
		self.dontDisconnectPaths = true;// lets other parts of the script know not to disconnect script
		return;
	}

	self endon( "death" );
	self endon( "kill_disconnect_paths_forever" );
	
	wait 1;
	
	while ( isdefined( self ) )
	{
		if ( Length( self.velocity ) < 1 )
		{
			if ( !isdefined( self.dontDisconnectPaths ) )
			{
				self vehicle_disconnectpaths_wrapper();
			}
			
			self notify( "speed_zero_path_disconnect" );
			
			while( Length( self.velocity ) < 1 )
			{
				wait 1;
			}
		}
		
		self vehicle_connectpaths_wrapper();
		
		while( Length( self.velocity ) > 1 )
		{
			wait 1;
		}		
	}
}

disconnect_paths_while_moving( interval )
{
	if( IsSentient( self) ) 
	{
		return;
	}
	
	if ( isdefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
	{
		self.dontDisconnectPaths = true;// lets other parts of the script know not to disconnect script
		return;
	}

	self endon( "death" );
	self endon( "kill_disconnect_paths_forever" );
	
	while ( isdefined( self ) )
	{
		if ( Length( self.velocity ) > 1 )
		{
			if ( !isdefined( self.dontDisconnectPaths ) )
			{
				//self vehicle_connectpaths_wrapper();				
				self vehicle_disconnectpaths_wrapper();
			}
			
			self notify( "moving_path_disconnect" );
		}
		
		wait interval;
	}	
}


vehicle_setspeed( speed, rate, msg )
{
	if( self getspeedmph() ==  0 && speed == 0 )
	{
		return;  // potential for disaster? keeps messages from overriding previous messages
	}

	 /#
	self thread debug_vehiclesetspeed( speed, rate, msg );
	#/
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
		while( GetDvar( "debug_vehiclesetspeed" ) != "off" )
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
	if( !IsDefined( self.resumemsgs ) )
	{
		self.resumemsgs = [];
	}
	if( IsDefined( self.waitingforgate ) && self.waitingforgate )
	{
		return; // ignore resumespeeds on waiting for gate.
	}

	if( IsDefined( self.attacking ) && self.attacking )
	{
		fSetspeed = self.attackspeed;
		type = "setspeed";
	}

	self.zerospeed = false;
	if( fSetspeed == 0 )
	{
		self.zerospeed = true;
	}
	if( type == "resumespeed" )
	{
		self resumespeed( rate );
	}
	else if( type == "setspeed" )
	{
		self vehicle_setspeed( fSetspeed, 15, "resume setspeed from attack" );
	}
	self notify( "resuming speed" );
	/# self thread debug_vehicleresume( msg + " :" + type ); #/

}

/#
debug_vehicleresume( msg )
{
	if( GetDvar( "debug_vehicleresume" ) == "off" )
	{
		return;
	}
	self endon( "death" );
	number = self.resumemsgs.size;
	self.resumemsgs[ number ] = msg;
	const timer = 3;
	self thread print_resumespeed( gettime() + ( timer * 1000 ) );

	wait timer;
	newarray = [];
	for( i = 0; i < self.resumemsgs.size; i++ )
	{
		if( i != number )
		{
			newarray[ newarray.size ] = self.resumemsgs[ i ];
		}
	}
	self.resumemsgs =  newarray;
}
#/

print_resumespeed( timer )
{
	self notify( "newresumespeedmsag" );
	self endon( "newresumespeedmsag" );
	self endon( "death" );
	while( gettime() < timer && IsDefined( self.resumemsgs ) )
	{
		if( self.resumemsgs.size > 6 )
		{
			start = self.resumemsgs.size - 5;
		}
		else
		{
			start = 0;
		}
		for( i = start; i < self.resumemsgs.size; i++ )  // only display last 5 messages
		{
			position = i * 32;
			/#print3d( self.origin + ( 0, 0, position ), "resuming speed: " + self.resumemsgs[ i ], ( 0, 1, 0 ), 1, 3 );#/
		}
		wait .05;
	}
}

godon()
{
	self.takedamage = false;
}

godoff()
{
	self.takedamage = true;
}

getnormalanimtime( animation )
{
	animtime = self getanimtime( animation );
	animlength = getanimlength( animation );
	if( animtime == 0 )
	{
		return 0;
	}
	return self getanimtime( animation ) / getanimlength( animation );
}

setup_dynamic_detour( pathnode , get_func )
{
	prevnode = [[ get_func ]]( pathnode.targetname );
	assert( IsDefined( prevnode ), "detour can't be on start node" );
	prevnode.detoured = 0;
}

 /*
setup_origins()
{
	triggers = [];
	origins = getentarray( "script_origin", "classname" );
	for( i = 0; i < origins.size; i++ )
	{
		if( IsDefined( origins[ i ].script_vehicledetour ) )
		{

			level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, origins[ i ].script_vehicledetour, origins[ i ] );
			if( level.vehicle_detourpaths[ origins[ i ].script_vehicledetour ].size > 2 )
				println( "more than two script_vehicledetour grouped in group number: ", origins[ i ].script_vehicledetour );

			prevnode = getent( origins[ i ].targetname, "target" );
			assert( IsDefined( prevnode ), "detour can't be on start node" );
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
	for( i = 0; i < ai.size; i++ )
	{
		if( IsDefined( ai[ i ].script_vehicleride ) )
		{
			level.vehicle_RideAI = array_2dadd( level.vehicle_RideAI, ai[ i ].script_vehicleride, ai[ i ] );
		}
		else if( IsDefined( ai[ i ].script_vehiclewalk ) )
		{
			level.vehicle_WalkAI = array_2dadd( level.vehicle_WalkAI, ai[ i ].script_vehiclewalk, ai[ i ] );
		}
	}
	ai = getspawnerarray();

	for( i = 0; i < ai.size; i++ )
	{
		if( IsDefined( ai[ i ].script_vehicleride ) )
		{
			level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, ai[ i ].script_vehicleride, ai[ i ] );
		}
		if( IsDefined( ai[ i ].script_vehiclewalk ) )
		{
			level.vehicle_walkspawners = array_2dadd( level.vehicle_walkspawners, ai[ i ].script_vehiclewalk, ai[ i ] );
		}
	}
}

array_2dadd( array, firstelem, newelem )
{
	if( !IsDefined( array[ firstelem ] ) )
	{
		array[ firstelem ] = [];
	}
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
	if ( self has_spawnflag( SPAWNFLAG_VEHICLE_NODE_START_NODE ) )
	{
		if( IsDefined( self.script_crashtype ) )
		{
			level.vehicle_crashpaths[ level.vehicle_crashpaths.size ] = self;
		}
		
		level.vehicle_startnodes[ level.vehicle_startnodes.size ] = self;
	}

	if( IsDefined( self.script_vehicledetour ) && IsDefined( self.targetname ) )
	{
		get_func = undefined;
		// get_func is differnt for struct types and script_origin types of paths
		if( IsDefined( get_from_entity( self.targetname ) ) )
		{
			get_func = ::get_from_entity_target;
		}
		if( IsDefined( get_from_spawnstruct( self.targetname ) ) )
		{
			get_func = ::get_from_spawnstruct_target;
		}

		if( IsDefined( get_func ) )
		{
			setup_dynamic_detour( self, get_func );
			processtrigger = true;  // the node with the script_vehicledetour waits for the trigger here unlike ground nodes which need to know 1 node in advanced that there's a detour, tricky tricky.
		}
		else
		{
			setup_groundnode_detour( self ); // other trickery.  the node is set to process in there.
		}

		level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, self.script_vehicledetour, self );
		/#
		if( level.vehicle_detourpaths[ self.script_vehicledetour ].size > 2 )
		{
			println( "more than two script_vehicledetour grouped in group number: ", self.script_vehicledetour );
		}
		#/
	}

	// if a gate isn't open then the vehicle will stop there and wait for it to become open.
	if( IsDefined( self.script_gatetrigger ) )
	{
		level.vehicle_gatetrigger = array_2dadd( level.vehicle_gatetrigger, self.script_gatetrigger, self );
		self.gateopen = false;
	}

	// init the flags!
	if ( IsDefined( self.script_flag_set ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_set ] ) )
		{
			flag_init( self.script_flag_set );
		}
	}

	// init the flags!
	if ( IsDefined( self.script_flag_clear ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_clear ] ) )
		{
			flag_init( self.script_flag_clear );
		}
	}

	if( IsDefined( self.script_flag_wait ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_wait ] ) )
		{
			flag_init( self.script_flag_wait );
		}
	}

	// various nodes that will be sent through trigger_process
	if (IsDefined( self.script_VehicleSpawngroup )
		|| IsDefined( self.script_VehicleStartMove )
		|| IsDefined( self.script_gatetrigger )
		|| IsDefined( self.script_Vehiclegroupdelete ))
	{
		processtrigger = true;
	}

	if( processtrigger )
	{
		add_proccess_trigger( self );
	}
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
	triggers = ArrayCombine( getallvehiclenodes(), getentarray( "script_origin", "classname" ), true, false );
	triggers = ArrayCombine( triggers, level.struct, true, false );
	triggers = ArrayCombine( triggers, get_triggers( "trigger_radius", "trigger_multiple", "trigger_once", "trigger_lookat", "trigger_box" ), true, false );
	array_thread( triggers, ::node_trigger_process );
	
}

setup_nodes()
{
	a_nodes = GetAllVehicleNodes();
	foreach ( node in a_nodes )
	{
		if ( IsDefined( node.script_flag_set ) )
		{
			if ( !level flag_exists( node.script_flag_set ) )
			{
				flag_init( node.script_flag_set );
			}
		}
	}
}

is_node_script_struct( node )
{
	if( ! IsDefined( node.targetname ) )
	{
		return false;
	}
	return IsDefined( getstruct( node.targetname, "targetname" ) );
}

setup_vehicles( allvehiclesprespawn )
{
	vehicles = allvehiclesprespawn;
	
	spawnvehicles = [];
	groups = [];
	nonspawned = [];

	for( i = 0; i < vehicles.size; i++ )
	{
		vehicles[i] vehicle_load_assets();
		
		if ( vehicles[i] has_spawnflag( SPAWNFLAG_VEHICLE_SPAWNER ) )
		{
			assert(IsDefined(vehicles[i].script_vehiclespawngroup), "Vehicle of type: " + vehicles[i].vehicletype + " has SPAWNER flag set, but is not part of a script_vehiclespawngroup or doesn't have a targetname." );
		}

		if( IsDefined( vehicles[i].script_vehiclespawngroup ) )
		{
			if( !IsDefined( spawnvehicles[ vehicles[i].script_vehiclespawngroup ] ) )
			{
				spawnvehicles[ vehicles[i].script_vehiclespawngroup ] = [];
			}

			spawnvehicles[ vehicles[i].script_vehiclespawngroup ][ spawnvehicles[ vehicles[i].script_vehiclespawngroup ].size ] = vehicles[ i ];
			addgroup[ 0 ] = vehicles[ i ].script_vehiclespawngroup;
			groups = ArrayCombine( groups, addgroup, false, false );
			continue;
		}
 		else
		{
			nonspawned[ nonspawned.size ] = vehicles[ i ];
		}
	}

	for( i = 0; i < groups.size; i++ )
	{
		thread spawner_setup( spawnvehicles[ groups[ i ] ], groups[ i ] );
	}

	 // init vehicles that aren't spawned
	 foreach ( veh in nonspawned )
	 {
		if ( IsDefined( veh.script_team ) )
		{
			veh.vteam = veh.script_team;
		}
		
		veh vehicle_dynamic_cover();
		
		thread vehicle_init( veh );
	}
}

vehicle_life()
{
	if (IsDefined(self.destructibledef))
	{
		self.health = 99999;
	}
	else
	{
		type = self.vehicletype;

		if( IsDefined( self.script_startinghealth ) )
		{
			self.health = self.script_startinghealth;
		}
		else
		{
			if( self.healthdefault == -1 )
			{
				return;
			}
			else if( IsDefined( self.healthmin ) && IsDefined( self.healthmax ) && (self.healthmax - self.healthmin) > 0 )
			{
				self.health  = ( randomint( self.healthmax - self.healthmin ) + self.healthmin );
				//println("set range health: " + self.health);
			}
			else
			{
				self.health = self.healthdefault;
				//println("set health: " + self.health);
			}
		}
		
		//	if( IsDefined( level.destructible_model[ self.model ] ) )
		//	{
		//		self.health = 2000;
		//		self.destructible_type = level.destructible_model[ self.model ];
		//		self maps\_destructible::setup_destructibles( true );
		//	}
	}
}

vehicle_load_assets()
{
	// vehicle
	precachevehicle( self.vehicletype );

	// model
	precachemodel( self.model );
	
	if( IsDefined( self.vehmodel ) )
	{
		precachemodel( self.vehmodel );
	}
	
	if( IsDefined( self.vehmodelenemy ) )
	{
		precachemodel( self.vehmodelenemy );
	}
	
	precache_extra_models(); //GLOCKE: moved TFlame's temp solution to a new function so it could be specified by vehicle type

	// death model
	if( IsDefined(self.deathmodel) && self.deathmodel != "" )
	{
		// 6/7/2010 - TFLAME - Added support for no deathmodel needing to be loaded , if desired
		precache_death_model_wrapper( self.deathmodel );
	}

	// shoot shock
	if( IsDefined(self.shootshock) && self.shootshock != "" )
	{
		precacheShader( "black" );
		precacheShellShock( self.shootshock );
	}

	// shoot rumble
	if( IsDefined(self.shootrumble) && self.shootrumble != "" )
	{
		PrecacheRumble( self.shootrumble );
	}

	// rumble
	if( IsDefined( self.rumbletype ) && self.rumbletype != "" )
	{
		precacherumble( self.rumbletype );
	}

	// secondary turrets
	if( IsDefined(self.secturrettype) && self.secturrettype != "" )
	{
		precacheturret( self.secturrettype );
	}

	if( IsDefined(self.secturretmodel) && self.secturretmodel != "" )
	{
		precachemodel( self.secturretmodel );
	}

	self vehicle_load_fx();

}

precache_extra_models()
{
	switch( self.vehicletype )	// Don't judge me :)
	{
		case "heli_huey":
		case "heli_huey_player":
		case "heli_huey_small":
		case "heli_huey_heavyhog":
		case "heli_huey_heavyhog_creek":
		case "heli_huey_usmc_heavyhog_khesanh":
		case "heli_huey_medivac":
		case "heli_huey_medivac_khesanh":
		case "heli_huey_gunship":
		case "heli_huey_assault":
		case "heli_huey_usmc":
		case "heli_huey_usmc_khesanh":
		case "heli_huey_usmc_khesanh_std":
		case "heli_huey_side_minigun":
		case "heli_huey_side_minigun_uwb":
			self maps\_huey::precache_submodels();
			break;
		
		case "heli_hind_player":
			self maps\_hind_player::precache_models();
			self maps\_hind_player::precache_weapons();
			self maps\_hind_player::precache_hud();
			break; 
		
		
		case "heli_blackhawk_rts":
		case "heli_blackhawk_stealth":
		case "heli_blackhawk_stealth_axis":
		case "heli_blackhawk_stealth_la2":			
			maps\_blackhawk::precache_extra_models();
			break;
			
		case "heli_hind":
		case "heli_hind_pakistan":
		case "heli_hind_so":
			maps\_hind::precache_extra_models();
			break;
		
		case "truck_gaz63_camorack":
			PrecacheModel("t5_veh_truck_gaz63_camo_rack");
			break;
			
		case "truck_gaz63_canvas":
		case "truck_gaz66_canvas":
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			PrecacheModel("t5_veh_gaz66_canvas");
			PrecacheModel("t5_veh_gaz66_canvas_dead");
			break;
			
		case "truck_gaz63_canvas_camorack":
			PrecacheModel("t5_veh_gaz66_troops");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			PrecacheModel("t5_veh_gaz66_canvas");
			PrecacheModel("t5_veh_gaz66_canvas_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_canvas");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_dead");
			break;
		
		case "truck_gaz63_flatbed":
		case "truck_gaz66_flatbed":
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;
			
		case "truck_gaz63_flatbed_camorack":
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_dead");
			break;
		
		case "truck_gaz63_tanker":
		case "truck_gaz66_tanker":
		case "truck_gaz66_tanker_physics":
			PrecacheModel("t5_veh_gaz66_tanker");
			precache_death_model_wrapper("t5_veh_gaz66_tanker_dead"); // check added for no_deathmodel - PeterL 083010(BETA)
			break;
		
		case "truck_gaz63_troops":
		case "truck_gaz66_troops":
		case "truck_gaz66_troops_physics":
		case "truck_gaz63_troops_bulletdamage":
			PrecacheModel("t5_veh_gaz66_troops");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			break;
			
		case "truck_gaz63_troops_camorack":
			PrecacheModel("t5_veh_gaz66_troops");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_dead");
			break;
			
		case "truck_gaz66_troops_attacking_physics":
		
			PrecacheModel("t5_veh_gaz66_troops_no_benches");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			break;
			
		
		case "truck_gaz63_single50":
		case "truck_gaz66_single50":
			PrecacheModel("t5_veh_gaz66_single50");
			PrecacheModel("t5_veh_gaz66_single50_dead");
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;
			
		case "truck_gaz63_player_single50":
		case "truck_gaz63_player_single50_physics":
		case "truck_gaz66_player_single50":
		case "truck_gaz63_player_single50_bulletdamage":
			PrecacheModel("t5_veh_gunner_turret_enemy_50cal");
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;
		
		case "truck_gaz63_player_single50_nodeath":
			PrecacheModel("t5_veh_gunner_turret_enemy_50cal");
			PrecacheModel("t5_veh_gaz66_flatbed");
			break;
						
		case "truck_gaz63_quad50":
		case "truck_gaz66_quad50":
			PrecacheModel("t5_veh_gaz66_quad50");
			PrecacheModel("t5_veh_gaz66_quad50_dead");
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;
		
		case "truck_gaz63_camorack_low":
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_low");
			break;
			
		case "truck_gaz63_canvas_low":
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			PrecacheModel("t5_veh_gaz66_canvas_low");
			PrecacheModel("t5_veh_gaz66_canvas_dead_low");
			break;
		
		case "truck_gaz63_flatbed_low":
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			break;
		
		case "truck_gaz63_tanker_low":
			PrecacheModel("t5_veh_gaz66_tanker_low");
			PrecacheModel("t5_veh_gaz66_tanker_dead_low");
			break;
		
		case "truck_gaz63_troops_low":
			PrecacheModel("t5_veh_gaz66_troops_low");
			PrecacheModel("t5_veh_gaz66_troops_dead_low");
			break;
		
		case "truck_gaz63_single50_low":
			PrecacheModel("t5_veh_gaz66_single50_low");
			PrecacheModel("t5_veh_gaz66_single50_dead_low");
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			break;
		
		case "truck_gaz63_quad50_low":
			PrecacheModel("t5_veh_gaz66_quad50_low");
			PrecacheModel("t5_veh_gaz66_quad50_dead_low");
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			break;
			
		case "truck_gaz63_quad50_low_no_deathmodel":
			PrecacheModel("t5_veh_gaz66_quad50_low");
			break;
			
		case "tank_snowcat_plow":
			precacheModel("t5_veh_snowcat_plow");
			break;

		case "boat_pbr":
			PreCacheModel( "t5_veh_boat_pbr_set01_friendly" );
			PreCacheModel( "t5_veh_boat_pbr_waterbox" );
			break;
			
		case "boat_pbr_medium":
		case "boat_pbr_medium_breakable":			
			PrecacheModel( "veh_t6_sea_gunboat_medium_damaged" );
			PrecacheModel( "veh_t6_sea_gunboat_medium_wheelhouse_dmg0" );
			PrecacheModel( "veh_t6_sea_gunboat_medium_wheelhouse_dmg1" );
			PrecacheModel( "veh_t6_sea_gunboat_medium_wheelhouse_dmg2" );
			PrecacheModel( "veh_t6_sea_gunboat_medium_rear_dmg0"	);
			PrecacheModel( "veh_t6_sea_gunboat_medium_rear_dmg1" );
			PrecacheModel( "veh_t6_sea_gunboat_medium_rear_dmg2" );
			break;
			
		case "boat_pbr_player":
			PrecacheModel( "t5_veh_boat_pbr_set01" );
			PrecacheModel( "t5_veh_boat_pbr_stuff" );
			break;
			
		case "drone_avenger":
		case "drone_avenger_fast":
		case "drone_avenger_fast_la2":
			maps\_avenger::precache_extra_models();
			break;
		case "drone_avenger_fast_la2_2x":
			maps\_avenger::precache_extra_models( true );
			break;
			
		case "drone_pegasus":
		case "drone_pegasus_fast":
		case "drone_pegasus_fast_la2":
		case "drone_pegasus_low":
		case "drone_pegasus_low_la2":				
			maps\_pegasus::precache_extra_models();
			break;
		case "drone_pegasus_fast_la2_2x":		
			maps\_pegasus::precache_extra_models( true);
			break;
			
		case "plane_f35":
		case "plane_f35_fast":
		case "plane_f35_vtol":
		case "plane_f35_fast_la2":
		case "plane_f35_vtol_nocockpit":
		case "plane_fa38_hero":
			maps\_f35::precache_extra_models();
			break;
			
		case "heli_osprey":
		case "heli_osprey_pakistan":
		case "heli_v78":
		case "heli_v78_rts":			
		case "heli_v78_yemen":			
			maps\_osprey::precache_extra_models();
			break;
	}
}

vehicle_load_fx()
{
	// exhaust fx
	if( IsDefined( self.exhaustfxname ) && self.exhaustfxname != "" )
	{
		loadfx( self.exhaustfxname );	// played in client script
	}

	// tread fx
	maps\_treadfx::loadtreadfx(self);

	// death fx
	if( IsDefined(self.deathfxname) && self.deathfxname != "" )
	{
		self.deathfx = loadfx( self.deathfxname );
	}
	
	if ( IsDefined( self._vehicle_load_fx ) )
	{
		self [[ self._vehicle_load_fx ]]();
	}
	
	if ( IsDefined( level._vehicle_load_fx ) )
	{
		if ( IsDefined( level._vehicle_load_fx[ self.vehicleType ] ) )
		{
			self [[ level._vehicle_load_fx[ self.vehicleType ] ]]();
		}
	}
}

vehicle_add_loadfx_callback( vehicleType, load_fx )
{
	if ( !IsDefined( level._vehicle_load_fx ) )
	{
		level._vehicle_load_fx = [];
	}
	
	/#	
	if ( IsDefined( level._vehicle_load_fx[ vehicleType ] ) )
	{
		PrintLn( "WARNING! LoadFX callback function for vehicle " + vehicleType + " already exists. Proceeding with override" );
	}
	#/
	
	level._vehicle_load_fx[ vehicleType ] = load_fx;
}

isCheap()
{
	if( !IsDefined( self.script_cheap ) )
	{
		return false;
	}

	if( !self.script_cheap )
	{
		return false;
	}

	return true;
}


hasHelicopterDustKickup()
{
	if( !IS_PLANE(self) )
	{
		return false;
	}

	if( isCheap() )
	{
		return false;
	}

	return true;
}

playLoopedFxontag( effect, durration, tag )
{
 	eModel = get_dummy();
	effectorigin = spawn( "script_origin", eModel.origin );

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
	while( IsDefined( self ) && self.classname == "script_vehicle" && self getspeedmph() > 0 )
	{
		eModel = get_dummy();
		effectorigin.angles = eModel gettagangles( tag );
		effectorigin.origin  = eModel gettagorigin( tag );
		effectorigin.forwardvec = anglestoforward( effectorigin.angles );
		effectorigin.upvec = anglestoup( effectorigin.angles );
		wait .05;
	}
}

setup_dvars()
{
	/#
	if( GetDvar( "debug_vehicleresume" ) == "" )
	{
		SetDvar( "debug_vehicleresume", "off" );
	}
	if( GetDvar( "debug_vehiclesetspeed" ) == "" )
	{
		SetDvar( "debug_vehiclesetspeed", "off" );
	}
	#/
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
	level.vehicle_link = [];
	level.vehicle_detourpaths = [];
// 	level.vehicle_linkedpaths = [];
	level.vehicle_startnodes = [];
	level.vehicle_spawners =  [];

	// AE 3-5-09: added this vehicle_walkercount so we can have ai walk with vehicles
	level.vehicle_walkercount = [];

	level.helicopter_crash_locations = getentarray( "helicopter_crash_location", "targetname" );

	level.playervehicle = spawn( "script_origin", ( 0, 0, 0 ) ); // no IsDefined for level.playervehicle
	level.playervehiclenone = level.playervehicle; // no IsDefined for level.playervehicle

	if( !IsDefined( level.vehicle_death_thread ) )
	{
		level.vehicle_death_thread = [];
	}
	if( !IsDefined( level.vehicle_DriveIdle ) )
	{
		level.vehicle_DriveIdle = [];
	}
	if( !IsDefined( level.vehicle_DriveIdle_r ) )
	{
		level.vehicle_DriveIdle_r = [];
	}
	if( !IsDefined( level.attack_origin_condition_threadd ) )
	{
		level.attack_origin_condition_threadd = [];
	}
	if( !IsDefined( level.vehiclefireanim ) )
	{
		level.vehiclefireanim = [];
	}
	if( !IsDefined( level.vehiclefireanim_settle ) )
	{
		level.vehiclefireanim_settle = [];
	}
	if( !IsDefined( level.vehicle_hasname ) )
	{
		level.vehicle_hasname = [];
	}
	if( !IsDefined( level.vehicle_turret_requiresrider ) )
	{
		level.vehicle_turret_requiresrider = [];
	}
	if( !IsDefined( level.vehicle_isStationary ) )
	{
		level.vehicle_isStationary = [];
	}
	if( !IsDefined( level.vehicle_compassicon ) )
	{
		level.vehicle_compassicon = [];
	}
	if( !IsDefined( level.vehicle_unloadgroups ) )
	{
		level.vehicle_unloadgroups = [];
	}
	if( !IsDefined( level.vehicle_aianims ) )
	{
		level.vehicle_aianims = [];
	}
	if( !IsDefined( level.vehicle_unloadwhenattacked ) )
	{
		level.vehicle_unloadwhenattacked = [];
	}
	if( !IsDefined( level.vehicle_deckdust ) )
	{
		level.vehicle_deckdust = [];
	}
	if( !IsDefined( level.vehicle_types ) )
	{
		level.vehicle_types = [];
	}
	if( !IsDefined( level.vehicle_compass_types ) )
	{
		level.vehicle_compass_types = [];
	}
	if( !IsDefined( level.vehicle_bulletshield ) )
	{
		level.vehicle_bulletshield = [];
	}
	if( !IsDefined( level.vehicle_death_badplace ) )
	{
		level.vehicle_death_badplace = [];
	}
		
	maps\_vehicle_aianim::setup_aianimthreads();
		
}


attacker_isonmyteam( attacker )
{
	if( ( IsDefined( attacker ) ) && IsDefined( attacker.vteam ) && ( IsDefined( self.vteam ) ) && ( attacker.vteam == self.vteam ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

attacker_troop_isonmyteam( attacker )
{
	if ( IsDefined( self.vteam ) && self.vteam == "allies" && IsDefined( attacker ) && IsDefined(level.player) && attacker == level.player )
	{
		return true;  // player is always on the allied team.. hahah! future CoD games that let the player be the enemy be damned!
	}
	else if( isai( attacker ) && attacker.team == self.vteam )
	{
		return true;
	}
	else
	{
		return false;
	}
}

bulletshielded( type )
{
	if ( !IsDefined( self.script_bulletshield ) )
	{
		return false;
	}
	
	type = tolower( type );
		
	if ( ! IsDefined( type ) || ! issubstr( type, "bullet" ) )
	{
		return false;
	}
		
	if ( self.script_bulletshield )
	{
		return true;
	}
	else
	{
		return false;
	}
}

friendlyfire_shield()
{
	self.friendlyfire_shield = true;

	if ( IsDefined( level.vehicle_bulletshield[ self.vehicletype ] ) && !IsDefined( self.script_bulletshield ) )
	{
		self.script_bulletshield = level.vehicle_bulletshield[ self.vehicletype ];
	}
}

friendlyfire_shield_callback( attacker, amount, type )
{
	if( !IsDefined(self.friendlyfire_shield) || !self.friendlyfire_shield )
	{
		return false;
	}

	if(
		( ! IsDefined( attacker ) && self.vteam != "neutral" ) ||
		attacker_isonmyteam( attacker ) ||
		attacker_troop_isonmyteam( attacker ) ||
		isDestructible() || 				// destructible pieces take the damage
		bulletshielded( type )
	)
	{
		return true;
	}
	
	return false;
}

vehicle_dynamic_cover( s_spawner )
{
	if ( isdefined( self.targetname ) )
	{
		ent = GetEnt( self.targetname, "target" );
		if ( isdefined( ent ) )
		{
			if ( isdefined( ent.script_noteworthy ) && ( ent.script_noteworthy == "dynamic_cover" ) )
			{
				e_dyn_path = ent;
			}
		}
	}
	
	if ( isdefined( e_dyn_path ) )
	{
		// if we have a vehicle spawner, save it to the spawner
		if ( isdefined( s_spawner ) )
		{
			s_spawner.e_dyn_path = e_dyn_path;
		}
		else
		{
			self.e_dyn_path = e_dyn_path;
		}
	}
	else
	{
		e_dyn_path = self;
	}
	
	e_dyn_path delay_thread( .05, maps\_dynamic_nodes::entity_grab_attached_dynamic_nodes, !isdefined( s_spawner ) );
}

vehicle_badplace()
{
	self endon( "kill_badplace_forever" );
	self endon( "death" );
	self endon( "delete" );
	
	if( IsDefined( level.custombadplacethread ) )
	{
		self thread [[ level.custombadplacethread ]]();
		return;
	}
	
	hasturret = IsDefined( self.turretweapon ) && self.turretweapon != "";
	const bp_duration = .5;
	const bp_height = 300;
	const bp_angle_left = 17;
	const bp_angle_right = 17;
	
	while ( true )
	{
		if( !self.script_badplace )
		{
 // 		badplace_delete( "tankbadplace" );
			while ( !self.script_badplace )
			{
				wait .5;
			}
		}
		
		speed = self GetSpeedMPH();
		if ( speed <= 0 )
		{
			wait bp_duration;
			continue;
		}
		
		if ( speed < 5 )
		{
			bp_radius = 200;
		}
		else if ( ( speed > 5 ) && ( speed < 8 ) )
		{
			bp_radius = 350;
		}
		else
		{
			bp_radius = 500;
		}

		if ( IsDefined( self.BadPlaceModifier ) )
		{
			bp_radius = ( bp_radius * self.BadPlaceModifier );
		}

 // 	bp_direction = anglestoforward( self.angles );
		if ( hasturret )
		{
			bp_direction = AnglesToForward( self GetTagAngles( "tag_turret" ) );
		}
		else
		{
			bp_direction = AnglesToForward( self.angles );
		}

		badplace_arc( "", bp_duration, self.origin, bp_radius * 1.9, bp_height, bp_direction, bp_angle_left, bp_angle_right, "allies", "axis" );
		badplace_cylinder( "", bp_duration, self.origin, 200, bp_height, "allies", "axis" );
// 		badplace_cylinder( "", bp_duration, self.colidecircle[ 1 ].origin, 200, bp_height, "allies", "axis" );
		wait bp_duration + .05;
	}
}

turret_shoot()
{
	self endon( "death" );
	self endon( "stop_turret_shoot" );
	
	self.weapon_fire_time = 0;
	str_weapon = self SeatGetWeapon( 0 );
	if( IsDefined( str_weapon ) )
	{
		weapon_fire_time = WeaponFireTime( str_weapon );
	}

	while( self.health > 0 )
	{
		self waittill( "turret_fire" );// next game remove this. just a simple fireturret command should do
		self notify( "groupedanimevent", "turret_fire" );
		self fireWeapon();
		LUINotifyEvent( &"hud_vehicle_turret_fire", 1, Int( weapon_fire_time * 1000 ) );
	}
}

vehicle_handleunloadevent()
{
	self notify( "vehicle_handleunloadevent" );
	self endon( "vehicle_handleunloadevent" );
	self endon( "death" );

	type = self.vehicletype;
	while( 1 )
	{
		self waittill( "unload", who );

		 // setting an unload group unloaded guys resets to "default"
		// SCRIPTER_MOD: JesseS (5/14/2007) -  took this out "who" for now, seems to be breaking unloadgroups.
		//if( IsDefined( who ) )
		//	self.unload_group = who;
		 // makes ai unload
		self notify( "groupedanimevent", "unload" );

 // 		if( IsDefined( self.turretweapon ) && self.turretweapon != "" && riders_check() )
 // 			self clearTurretTarget();
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
	else if ( IS_PLANE( self ) )
	{
		/#
		PrintLn( "helicopter node targetname: " + path_start.targetname );
		PrintLn( "vehicletype: " + self.vehicletype );
		#/
		AssertMsg( "helicopter on vehicle path( see console for info )" );
	}
	
	if ( !IsDefined( path_start ) )
	{
		path_start = getstruct( target, "targetname" );
	}
	
	return path_start;
}

vehicle_resumepathvehicle()
{
	if ( IsDefined( self.currentnode.target ) )
	{
		node = get_vehiclenode_any_dynamic( self.currentnode.target );
	}
	
	if ( IsDefined( node ) )
	{
		self ResumeSpeed( 35 );
		vehicle_paths( node );
	}
}

vehicle_landvehicle()
{
	self setNearGoalNotifyDist( 2 );
	self sethoverparams( 0, 0, 10 );
	self cleargoalyaw();
	self settargetyaw( flat_angle( self.angles )[ 1 ] );
	self setvehgoalpos_wrap( GROUNDPOS( self, self.origin ), 1 );
	self waittill( "goal" );
}

setvehgoalpos_wrap( origin, bStop )
{
	if( self.health <= 0 )
	{
		return;
	}
	if( IsDefined( self.originheightoffset ) )
	{
		origin += ( 0, 0, self.originheightoffset ); // TODO - FIXME: this is temporarily set in the vehicles init_local function working on getting it this requirement removed
	}
	self setvehgoalpos( origin, bStop );
}

vehicle_liftoffvehicle( height )
{
	if( !IsDefined( height ) )
	{
		height = 512;
	}
	dest = self.origin + ( 0, 0, height );
	self setNearGoalNotifyDist( 10 );
	self setvehgoalpos_wrap( dest, 1 );
	self waittill( "goal" );
}

waittill_stable()
{
	 // wait for it to level out before unloading
	const offset = 12;
	const stabletime = 400;
	timer = gettime() + stabletime;
	while( IsDefined( self ) )
	{
		if( self.angles[ 0 ] > offset || self.angles [ 0 ] < ( - 1 * offset ) )
		{
			timer = gettime() + stabletime;
		}
		if( self.angles[ 2 ] > offset || self.angles [ 2 ] < ( - 1 * offset ) )
		{
			timer = gettime() + stabletime;
		}
		if( gettime() > timer )
		{
			break;
		}
		wait .05;
	}
}

unload_node( node )
{
	// needed by RTS mode to halt choppers quicker. 
	// Result is ugly though and should be done properly by someone that knows vehicles at some point.
	if( IsDefined( self.custom_unload_function ) )
	{
		[[ self.custom_unload_function ]]();
		return;
	}
	
	vehicle_pause_path();
	
	if ( self.riders.size > 0 )
	{
		pathnode = GetNode( node.targetname, "target" );
		if ( IsDefined( pathnode ) )
		{
			foreach ( ai_rider in self.riders )
			{
				if ( IsAI( ai_rider ) )
				{
					ai_rider thread maps\_spawner::go_to_node( pathnode );
				}
			}
		}
	}

	if ( IS_PLANE( self ) )
	{
		waittill_stable();
	}
	else if ( IS_HELICOPTER( self ) )
	{
		self SetHoverParams( 0, 0, 10 );
		waittill_stable();
	}

	self notify( "unload", node.script_unload );

	if ( maps\_vehicle_aianim::riders_unloadable( node.script_unload ) || IS_TRUE( self.custom_unload ) )
	{
		self waittill( "unloaded" );
	}
}

unload_node_helicopter( node )
{
	// needed by RTS mode to halt choppers quicker. 
	// Result is ugly though and should be done properly by someone that knows vehicles at some point.
	if( IsDefined( self.custom_unload_function ) )
	{
		self thread [[ self.custom_unload_function ]]();
	}
	
	self SetHoverParams( 0, 0, 10 );	

	goal = self.nextNode.origin;
	
	// find out how far off the ground the drop node is
	start = self.nextNode.origin;
	end = start - ( 0, 0, 10000 );
	
	// trace the ground
	trace = BulletTrace( start, end, false, undefined, true );
	if ( trace["fraction"] <= 1 )
	{
		goal = ( trace["position"][0], trace["position"][1], trace["position"][2] + self.fastropeoffset );
	}
	
	// For now always do the ri tag
	drop_offset_tag = "tag_fastrope_ri";
	
	// unless there's a custom one set on the helicopter
	if( IsDefined( self.drop_offset_tag ) )
		drop_offset_tag = self.drop_offset_tag;
	
	// Get offset from drop tag to origin
	drop_offset = self GetTagOrigin( "tag_origin" ) - self GetTagOrigin( drop_offset_tag );
	
	// offset goal
	goal += ( drop_offset[0], drop_offset[1], 0 );
	
	self SetVehGoalPos( goal, 1 );
	self waittill( "goal" );
	self notify( "unload", self.nextNode.script_unload );
	
	self waittill( "unloaded" );
}

vehicle_pathdetach()
{
	self.attachedpath = undefined;
	self notify( "newpath" );

	self setGoalyaw( flat_angle( self.angles )[ 1 ] );
	self setvehgoalpos( self.origin + ( 0, 0, 4 ), 1 );
}

setup_targetname_spawners()
{
	level.vehicle_targetname_array = [];

	vehicles = getentarray( "script_vehicle", "classname" );

	highestGroup = 0;
	// get the highest script_vehicleSpawnGroup in use
	for( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];
		if( IsDefined( vehicle.script_vehicleSpawnGroup ) )
		{
			if( vehicle.script_vehicleSpawnGroup > highestGroup )
			{
				highestGroup = vehicle.script_vehicleSpawnGroup;
			}
		}
	}

	for( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];

		if ( IsDefined( vehicle.targetname ) && vehicle has_spawnflag( SPAWNFLAG_VEHICLE_SPAWNER ) )
		{
			if( !IsDefined( vehicle.script_vehicleSpawnGroup ) )
			{
				// vehicle spawners that have no script_vehiclespawngroup get assigned one, if they have a targetname
				highestGroup++;
				vehicle.script_vehicleSpawnGroup = highestGroup;
			}

			if( !IsDefined( level.vehicle_targetname_array[ vehicle.targetname ] ) )
			{
				level.vehicle_targetname_array[ vehicle.targetname ] = [];
			}

			level.vehicle_targetname_array[ vehicle.targetname ][ vehicle.script_vehicleSpawnGroup ] = true;
		}
	}
}

spawn_vehicles_from_targetname( name, b_supress_assert )
{
	// spawns an array of vehicles that all have the specified targetname in the editor,
	// but are deleted at runtime
	
	if ( !IsDefined( b_supress_assert ) )
	{
		b_supress_assert = false;
	}
	
	Assert( b_supress_assert || IsDefined( level.vehicle_targetname_array[ name ] ), "No vehicle spawners had targetname " + name );
	
	vehicles = [];
	if ( IsDefined( level.vehicle_targetname_array[ name ] ) )
	{
		array = level.vehicle_targetname_array[ name ];
		
		if ( array.size > 0 )
		{
			keys = GetArrayKeys( array );
			
			foreach ( key in keys )
			{
				vehicle_array = scripted_spawn( key );
				vehicles = ArrayCombine( vehicles, vehicle_array, true, false );
			}
		}
	}
	
	return vehicles;
}

spawn_vehicle_from_targetname( name, b_supress_assert )
{
	if ( !IsDefined( b_supress_assert ) )
	{
		b_supress_assert = false;
	}
	
	vehicle_array = spawn_vehicles_from_targetname( name, b_supress_assert );
	Assert( b_supress_assert ||  vehicle_array.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicle_array.size + " vehicles, instead of 1" );

	if ( vehicle_array.size > 0 )
	{
		return vehicle_array[ 0 ];
	}
}

spawn_vehicle_from_targetname_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	assert( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );

	vehicleArray[ 0 ] thread gopath();
	return vehicleArray[ 0 ];
}

spawn_vehicles_from_targetname_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	for( i = 0; i < vehicleArray.size; i++ )
	{
		vehicleArray[ i ] thread goPath();
	}

	return vehicleArray;
}

aircraft_dust_kickup( model )
{
	self endon( "death" );
	self endon( "death_finished" );
	self endon( "stop_kicking_up_dust" );

	assert( IsDefined( self.vehicletype ) );

	const maxHeight = 1200;
	const minHeight = 350;

	const slowestRepeatWait = 0.15;
	const fastestRepeatWait = 0.05;

	const numFramesPerTrace = 3;
	doTraceThisFrame = numFramesPerTrace;

	const defaultRepeatRate = 1.0;
	repeatRate = defaultRepeatRate;

	trace = undefined;
	d = undefined;

	trace_ent = self;
	if ( IsDefined( model ) )
	{
		trace_ent = model;
	}

	while( IsDefined( self ) )
	{
		if( repeatRate <= 0 )
		{
			repeatRate = defaultRepeatRate;
		}
		wait repeatRate;
		
		if( !IsDefined( self ) )
		{
			return;
		}
		
		doTraceThisFrame -- ;

		 
		if( doTraceThisFrame <= 0 )
		{
			doTraceThisFrame = numFramesPerTrace;

			trace = bullettrace( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ), false, trace_ent );
			 /*
			trace[ "entity" ]
			trace[ "fraction" ]
			trace[ "normal" ]
			trace[ "position" ]
			trace[ "surfacetype" ]
			 */

			d = distance( trace_ent.origin, trace[ "position" ] );

			repeatRate = ( ( d - minHeight ) / ( maxHeight - minHeight ) ) * ( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait;
		}

		if( !IsDefined( trace ) )
		{
			continue;
		}

		assert( IsDefined( d ) );

		if( d > maxHeight )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}

		if( IsDefined( trace[ "entity" ] ) )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}

		if( !IsDefined( trace[ "position" ] ) )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}

		if( !IsDefined( trace[ "surfacetype" ] ) )
		{
			trace[ "surfacetype" ] = "dirt";
		}
		assert( IsDefined( level._vehicle_effect[ self.vehicletype ] ), self.vehicletype + " vehicle script hasn't run _tradfx properly" );
		assert( IsDefined( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] ), "UNKNOWN SURFACE TYPE: " + trace[ "surfacetype" ] );

		 
		if( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] != -1 )
		{
			playfx( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ], trace[ "position" ] );
		}
	}
}

/* DEAD CODE REMOVAL
loadplayer( player, position, animfudgetime )
{
	/#
	if( GetDvar( "fastrope_arms" ) == "" )
	{
		SetDvar( "fastrope_arms", "0" );
	}
	#/
		
	if( !IsDefined( animfudgetime ) )
	{
		animfudgetime = 0;
	}
	assert( IsDefined( self.riders ) );
	assert( self.riders.size );
	guy = undefined;
	for( i = 0; i < self.riders.size; i++ )
	{
		if( self.riders[ i ].pos == position )
		{
			guy = self.riders[ i ];
			guy.drone_delete_on_unload = true;
			guy.playerpiggyback = true;
			break;
		}
	}

	assert( !isai( guy ), "guy in position of player needs to have script_drone set, use script_startingposition ans script drone in your map" );
	assert( IsDefined( guy ) );
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
	 // playerlinktodelta( <linkto entity> , <tag> , <viewpercentag fraction> , <right arc> , <left arc> , <top arc> , <bottom arc> )
	
	// SCRIPTER_MOD: JesseS (8/10/2007):  passing in player now, use player instead of level.player
	player playerlinktodelta( guy, "tag_player", 1.0, 70, 70, 90, 90 );

	 // level.player setplayerangles( guy gettagangles( "tag_player" ) );

	 // level.player allowcrouch( false );
	 // level.player allowprone( false );
	 // level.player allowstand( true );

	guy hide();

	animtime = getanimlength( animpos.getout );
	animtime -= animfudgetime;
	self waittill( "unload" );

	/#
	
	if( GetDvar( "fastrope_arms" ) != "0" )
		guy show();
	#/
	
	player disableweapons();
 // 	guy waittill( "jumpedout" );

	guy notsolid();

	wait animtime;

	player unlink();
	player enableweapons();
	 // level.player allowcrouch( true );
	 // level.player allowprone( true );
}
*/

/* DEAD CODE REMOVAL
show_rigs( position )
{
	wait .01;
	self thread maps\_vehicle_aianim::getout_rigspawn( self, position ); // spawn the getoutrig for this position
	if( !self.riders.size )
	{
		return;
	}
	for( i = 0; i < self.riders.size; i++ )
	{
		self thread maps\_vehicle_aianim::getout_rigspawn( self, self.riders[ i ].pos );
	}
}
*/

/* DEAD CODE REMOVAL
turret_deleteme( turret )
{
	if ( IsDefined( self ) )
	{
		if ( IsDefined( turret.deletedelay ) )
		{
			wait turret.deletedelay;
		}
	}
			
	turret delete();
}
*/

maingun_FX()
{
	if( !IsDefined( level.vehicle_deckdust[ self.model ] ) )
	{
		return;
	}
	self endon( "death" );
	while( true )
	{
		self waittill( "weapon_fired" ); // waits for Code notify when fireWeapon() is called.
		playfxontag( level.vehicle_deckdust[ self.model ], self, "tag_engine_exhaust" );
		barrel_origin = self gettagorigin( "tag_flash" );
		ground = physicstrace( barrel_origin, barrel_origin + ( 0, 0, -128 ) );
		physicsExplosionSphere( ground, 192, 100, 1 );
	}
}

lights_on()
{
	self ClearClientFlag(10);
}

lights_off()
{
	self SetClientFlag(10);
}

/@
"Name: build_drive( <forward> , <reverse> , <normalspeed> , <rate> )"
"Summary: called in individual vehicle file - assigns animations to be used on vehicles"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <forward> : forward animation"
"OptionalArg: <reverse> : reverse animation"
"OptionalArg: <normalspeed> : speed at which animation will be played at 1x defaults to 10mph"
"OptionalArg: <rate> : scales speed of animation( please only use this for testing )"
"Example: vehicle build_drive( %abrams_movement, %abrams_movement_backwards, 10 );"
"SPMP: singleplayer"
@/

build_drive( forward, reverse, normalspeed, rate )
{
	if( !IsDefined( normalspeed ) )
	{
		normalspeed = 10;
	}
	level.vehicle_DriveIdle[ self.model ] = forward;
	
	if( IsDefined( reverse ) )
	{
		level.vehicle_DriveIdle_r[ self.model ] = reverse;
	}
	level.vehicle_DriveIdle_normal_speed[ self.model ] = normalspeed;
	if( IsDefined( rate ) )
	{
		level.vehicle_DriveIdle_animrate[ self.model ] = rate;
	}
}

/@
"Name: build_aianims( <aithread> , <vehiclethread> )"
"Summary: called in individual vehicle file - set threads for ai animation and vehicle animation assignments"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <aithread> : ai thread"
"OptionalArg: <vehiclethread> : vehicle thread"
"Example: vehicle build_aianims( ::setanims, ::set_vehicle_anims );"
"SPMP: singleplayer"
@/

build_aianims( aithread, vehiclethread )
{
	level.vehicle_aianims[ self.vehicletype ] = [[ aithread ]]();
	if( IsDefined( vehiclethread ) )
	{
		level.vehicle_aianims[ self.vehicletype ] = [[ vehiclethread ]]( level.vehicle_aianims[ self.vehicletype ] );
	}
}


/@
"Name: build_crashanim( <modelsthread> )"
"Summary: called in individual vehicle file - thread for building attached models( ropes ) with animation"
"Module: Vehicle"
"CallOn: "
"MandatoryArg: <modelsthread> : thread"
"Example: build_attach_models( ::set_attached_models );"
"SPMP: singleplayer"
@/

build_attach_models( modelsthread )
{
	level.vehicle_attachedmodels[ self.vehicletype ] = [[ modelsthread ]]();;
}

/@
"Name: build_unload_groups( <unloadgroupsthread> )"
"Summary: called in individual vehicle file - thread for building unload groups"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <modelsthread> : thread"
"Example: vehicle build_unload_groups( ::Unload_Groups );"
"SPMP: singleplayer"
@/

build_unload_groups( unloadgroupsthread )
{
	level.vehicle_unloadgroups[ self.vehicletype ] = [[ unloadgroupsthread ]]();
}

/* DEAD CODE REMOVAL
/@
"Name: build_vehiclewalk( <walk num> )"
"Summary: called in individual vehicle file - this sets the max numer of walkers the vehicle has
"Module: Vehicle"
"CallOn: "
"MandatoryArg: <walk num> :  max number of walkers this vehicle supports"
"Example: build_vehiclewalk( 6 );"
"SPMP: singleplayer"
@/

build_vehiclewalk( num_walkers )
{
	level.vehicle_walkercount[ level.vttype ] = num_walkers;
}
*/

get_from_spawnstruct( target )
{
	return getstruct( target, "targetname" );
}

get_from_entity( target )
{
	return getent( target, "targetname" );
}

get_from_spawnstruct_target( target )
{
	return getstruct( target, "target" );
}

get_from_entity_target( target )
{
	return getent( target, "target" );
}

/* DEAD CODE REMOVAL
get_from_vehicle_node( target )
{
	return getvehiclenode( target, "targetname" );
}
*/

/* DEAD CODE REMOVAL
set_lookat_from_dest( dest )
{
	viewTarget = getent( dest.script_linkto, "script_linkname" );

	if ( !IsDefined( viewTarget ) )
	{
		return;
	}

	self setLookAtEnt( viewTarget );
	self.set_lookat_point = true;
}
*/

/* DEAD CODE REMOVAL
getspawner_byid( id )
{
	for ( i = 0; i < level.vehicle_spawners.size; i++ )
	{
		for ( j = 0; j < level.vehicle_spawners[i].size; j++ )
		{
			if ( IsDefined( level.vehicle_spawners[ i ][ j ].spawner_id ) )
			{
				if ( level.vehicle_spawners[ i ][ j ].spawner_id == id )
				{
					return level.vehicle_spawners[ i ][ j ];
				}
			}
		}
	}

	return 0;
}
*/

/* DEAD CODE REMOVAL
vehicle_getspawner()
{
	assert( IsDefined( self.spawner_id ) );
	return getspawner_byid( self.spawner_id );
}
*/

isDestructible()
{
	return IsDefined( self.destructible_type );
}

// SCRIPTER_MOD: JesseS (5/12/200) -  readded script_vehicleattackgroup scripting
// This allows vehicles to attack other vehicles automatically. Just set the script_vehicleattackgroup of the attacker
// to the script_vehiclespawngroup you want to attack.
attackgroup_think()
{
	self endon ("death");
	self endon ("switch group");
	self endon ("killed all targets");
	
	if (IsDefined (self.script_vehicleattackgroupwait))
	{
		wait (self.script_vehicleattackgroupwait);
	}
	
	for(;;)
	{
		//get all the vehicles
		group = getentarray("script_vehicle", "classname");
		
		// get our target array
		valid_targets = [];
		for (i = 0; i< group.size; i++)
		{
			// dpg: not all script vehicles have a script_vehiclespawngroup
			if( !IsDefined( group[i].script_vehiclespawngroup ) )
			{
				continue;
			}
			// get all vehicles with the same spawngroup as the agroup we want to attack
			if (group[i].script_vehiclespawngroup == self.script_vehicleattackgroup)
			{
				// Make sure we only attack different teams vehicles
				if (group[i].vteam != self.vteam)
				{
					ARRAY_ADD(valid_targets, group[i]);
				}
			}
		}
		
		// Try again every .5 seconds if there are no valid targets.
		if (valid_targets.size == 0)
		{
			wait (0.5);
			continue;
		}
		
		// Main loop which makes the vehicle fire on the nearest group it's been set to attack
		for (;;)
		{
			current_target = undefined;
			if (valid_targets.size != 0)
			{
				current_target = self get_nearest_target(valid_targets);
			}
			else
			{
				// We killed them all, end this thread
				self notify ("killed all targets");
			}
			
			// if it's a death vehicle, remove it from the list of valid targets
			if (current_target.health <= 0)
			{
				ArrayRemoveValue(valid_targets, current_target);
				continue;
			}
			else
			{
				// set the target ent for the vehicle. offset a bit so it doesnt shoot into the ground
				self setturrettargetent( current_target, (0,0,50) );
				
				// DPG 10/22/07 - in case we want specific wait values on the vehicle
				if( IsDefined( self.fire_delay_min ) && IsDefined( self.fire_delay_max ) )
				{
					// in case max is less than min
					if( self.fire_delay_max < self.fire_delay_min )
					{
						self.fire_delay_max = self.fire_delay_min;
					}
					
					wait ( randomintrange(self.fire_delay_min, self.fire_delay_max) );
				}
				
				else
				{
					wait (randomintrange(4, 6));
				}
				self fireweapon();
			}
		}
	}


	// if this is called again, just add new group to queue
	// queue should be sorted by distance
	// delete from queue once vehicle is dead, check to see if vehicles health > 0
}

// Gets the nearest ent to self
get_nearest_target(valid_targets)
{
	nearest_distsq = 99999999;
	nearest = undefined;
	
	for (i = 0; i < valid_targets.size; i++)
	{
		if( !IsDefined( valid_targets[i] ) )
		{
			continue;
		}
		current_distsq = distancesquared( self.origin, valid_targets[i].origin );
		if (current_distsq < nearest_distsq)
		{
			nearest_distsq = current_distsq;
			nearest = valid_targets[i];
		}
	}
	return nearest;
}

//---------------//
// Debug section //
//---------------//
/#
debug_vehicle()
{
	self endon( "death" );

	if( GetDvar( "debug_vehicle_health" ) == "" )
	{
		SetDvar( "debug_vehicle_health", "0" );
	}

	while( 1 )
	{
		if( GetDvarInt( "debug_vehicle_health" ) > 0 )
		{
			print3d( self.origin, "Health: " + self.health, ( 1, 1, 1 ), 1, 3 );
		}

		wait( 0.05 );
	}
}

debug_vehicle_paths()
{
	self endon( "death" );
	self endon( "newpath" );
	self endon( "reached_dynamic_path_end" );
	
	nextNode = self.currentNode;
	
	while( 1 )
	{
		if( GetDvarInt( "debug_vehicle_paths" ) > 0 )
		{
			RecordLine( self.origin, self.currentNode.origin, (1,0,0), "Script", self );
			RecordLine( self.origin, nextNode.origin, (0,1,0), "Script", self );
			RecordLine( self.currentNode.origin, nextNode.origin, (1,1,1), "Script", self );
		}

		wait( 0.05 );
		
		// update
		if( IsDefined(self.nextNode) && self.nextNode != nextNode )
		{
			nextNode = self.nextNode;
		}
	}
}
#/

get_dummy()
{
	if ( self.modeldummyon )
	{
		eModel = self.modeldummy;
	}
	else
	{
		eModel = self;
	}
	return eModel;
}

vehicle_add_main_callback( vehicleType, main )
{
	if ( !IsDefined( level.vehicle_main_callback ) )
	{
		level.vehicle_main_callback = [];
	}
		
	/#
	if ( IsDefined( level.vehicle_main_callback[ vehicleType ] ) )
	{
		PrintLn( "WARNING! Main callback function for vehicle " + vehicleType + " already exists. Proceeding with override" );
	}
	#/
		
	level.vehicle_main_callback[ vehicleType ] = main;
}

vehicle_main()
{
	if ( IsDefined( level.vehicle_main_callback ) && 
		IsDefined( level.vehicle_main_callback[ self.vehicleType ] ) )
	{
		if( !self has_spawnflag( SPAWNFLAG_VEHICLE_SPAWNER ) )
		{
			self thread [[level.vehicle_main_callback[ self.vehicleType ]]]();
		}
	}
	
	switch( self.vehicletype )
	{
		// TANKS //
		case "tank_t72":
			self maps\_t72::main();
			break;
		
		case "tank_zsu23":
		case "tank_zsu23_low":
			self maps\_tank_zsu23::main();
			break;
			
		// TRANSPORT //
		case "truck_bm21":
		case "truck_bm21_troops":
		case "truck_maz543":
			self maps\_truck::main();
			break;

		// TRUCK - GAZ66 //
		case "truck_gaz66":
		case "truck_gaz66_canvas":
		case "truck_gaz66_flatbed":
		case "truck_gaz66_troops":
		case "truck_gaz66_fuel":
		case "truck_gaz66_cargo":
			self maps\_truck_gaz66::main();
			break;
			
		// TRUCK - GAZ63 //
		case "truck_gaz63":
		case "truck_gaz63_canvas":
		case "truck_gaz63_canvas_camorack":
		case "truck_gaz63_flatbed":
		case "truck_gaz63_flatbed_camorack":
		case "truck_gaz63_tanker":
		case "truck_gaz63_troops":
		case "truck_gaz63_troops_bulletdamage":
		case "truck_gaz63_troops_camorack":
		case "truck_gaz63_single50":
		case "truck_gaz63_player_single50":
		case "truck_gaz63_player_single50_nodeath":
		case "truck_gaz63_player_single50_physics":
		case "truck_gaz63_player_single50_bulletdamage":
		case "truck_gaz63_quad50":
		case "truck_gaz63_camorack":
		case "truck_gaz63_low":
		case "truck_gaz63_canvas_low":
		case "truck_gaz63_flatbed_low":
		case "truck_gaz63_tanker_low":
		case "truck_gaz63_troops_low":
		case "truck_gaz63_single50_low":
		case "truck_gaz63_quad50_low":
		case "truck_gaz63_quad50_low_no_deathmodel":
		case "truck_gaz63_camorack_low":
			self maps\_truck_gaz63::main();
			break;
			
		case "jeep_uaz":
		case "jeep_uaz_closetop":
			self maps\_uaz::main();
			break;

		case "jeep_intl":
		case "jeep_willys":
		case "jeep_ultimate":
			self maps\_jeep::main();
			break;

		// HELICOPTERS /////
		case "heli_chinook":
			self maps\_chinook::main();
			break;

		case "heli_cobra":
		case "heli_cobra_khesanh":
			self maps\_cobra::main();
			break;

		case "heli_hip":
		case "heli_hip_afghanistan":
		case "heli_hip_afghanistan_land":
		case "heli_hip_sidegun":
		case "heli_hip_sidegun_uwb":
		case "heli_hip_sidegun_spotlight":
			self maps\_hip::main();
			break;
			
		case "heli_pavelow":	
		case "heli_pavelow_la2":
			self maps\_pavelow::main();
			break;
			
		case "heli_osprey":		
		case "heli_osprey_pakistan":
		case "heli_v78":
		case "heli_v78_rts":			
		case "heli_v78_yemen":			
			self maps\_osprey::main();
			break;
			
		case "heli_huey":
		case "heli_huey_vista":
		case "heli_huey_assault":
		case "heli_huey_assault_river":
		case "heli_huey_gunship":
		case "heli_huey_gunship_river":
		case "heli_huey_heavyhog":
		case "heli_huey_heavyhog_creek":
		case "heli_huey_usmc_heavyhog_khesanh":
		case "heli_huey_heavyhog_river":
		case "heli_huey_medivac":
		case "heli_huey_medivac_khesanh":
		case "heli_huey_medivac_river":
		case "heli_huey_minigun":
		case "heli_huey_player":
		case "heli_huey_small":
		case "heli_huey_usmc":
		case "heli_huey_usmc_gunship":
		case "heli_huey_usmc_heavyhog":
		case "heli_huey_usmc_khesanh":
		case "heli_huey_usmc_khesanh_std":
		case "heli_huey_usmc_minigun":
		case "heli_huey_side_minigun":
		case "heli_huey_side_minigun_uwb":
		{
			self maps\_huey::main();
		}
			break;
		
		case "heli_hind_player":
			self maps\_hind_player::main();
			break;
			
		case "heli_blackhawk_rts":
		case "heli_blackhawk_stealth":
		case "heli_blackhawk_stealth_axis":
		case "heli_blackhawk_stealth_la2":
			self maps\_blackhawk::main();
			break;

		case "heli_hind":
		case "heli_hind_pakistan":
		case "heli_hind_so":
			self maps\_hind::main();
			break;

		case "heli_littlebird":
			self maps\_littlebird::main();
			break;			
	
		// PLANES //
		case "plane_mig17":
		case "plane_mig23":
			self maps\_mig17::main();
			break;
			
		case "plane_phantom":
		case "plane_phantom_gearup_lowres":
			self maps\_mig17::main();
			break;
			
		// WEAPONS //
		case "wpn_zpu_antiair":
			self maps\_zpu_antiair::main();
			break;

		// APC //
		case "apc_brt40":
		case "apc_m113":
		case "apc_m113_axis":
		case "apc_m113_ally":
		case "apc_m113_khesanh_outcasts":
		case "apc_m113_khesanh_warchicken":
		case "apc_m113_khesanh_plain":
		case "apc_bmp":
			self maps\_apc::main();
			break;
			
		// APC - BUFFEL //
		case "apc_buffel":
		case "apc_buffel_gun_turret":	
		case "apc_buffel_gun_turret_nophysics":
			self maps\_apc_buffel::main();
			break;

		case "apc_btr40_flashpoint":
		case "apc_btr60":
		case "apc_btr60_pakistan":
		case "apc_btr60_grenade":
			self maps\_btr::main();
			break;
		
		case "apc_gaz_tigr":
		case "apc_gaz_tigr_wturret":
		case "apc_gaz_tigr_pakistan":
			self maps\_truck_gaztigr::main();
			break;
			
		case "civ_pickup":
		case "civ_pickup_4door":
		case "civ_technical_afgh":
		case "civ_pickup_wturret":
		case "civ_pickup_wturret_angola":			
		case "civ_pickup_wturret_panama":
		case "civ_pickup_wturret_afghan":
		case "civ_pickup_wturret_beatup":	
		case "civ_pickup_wturret_beatup_cartel":
			self maps\_civ_pickup::main();
			break;
			
		case "civ_pickup_red":
		case "civ_pickup_red_nophysics":
		case "civ_pickup_red_wturret":
		case "civ_pickup_red_wturret_light":
		case "civ_pickup_red_wturret_nophysics":
		case "civ_pickup_red_wturret_la2":
			self maps\_civ_pickup_big::main();
			break;

		case "civ_tanker":
		case "civ_tanker_civ":
		case "civ_sedan_luxury":
			self maps\_civ_vehicle::main();
			break;

		case "tiara":
			self maps\_tiara::main();
			break;

		case "police":
		case "civ_police":
		case "civ_police_light":			
			self maps\_policecar::main();
			break;
			
		// snowcat //
		case "tank_snowcat":
		case "tank_snowcat_plow":
		case "tank_snowcat_troops":
			self maps\_snowcat::main();
			break;

		case "rcbomb":
			self maps\_rcbomb::main();
			break;
		
		case "boat_sampan_pow":
		case "boat_sampan":
			self maps\_sampan::main();
			break;
		
		case "motorcycle_lapd":
			self maps\_motorcycle_lapd::main();
			break;
			
		case "motorcycle_ai":
			self maps\_motorcycle::main();
			break;

		case "civ_van_sprinter":
		case "civ_van_sprinter_la2":
			self maps\_van::main();
			break;
			
		case "horse":
		case "horse_player":
		case "horse_player_low":
		case "horse_low":
			self maps\_horse::main();
			break;
			
		case "boat_soct_allies":
			self maps\_soct::main();
			break;

		default:
			//ASSERTMSG( "Vehicle type: " + self.vehicletype + " not handled in _vehicle.gsc::vehicle_main" );
			break;
		
	}
}


//*****************************************************************************************
// self = vehicle
//
// Vehicle wants to move so:-
//  - Make sure the navigation mesh is fully connected
//  - Disconnect the cover nodes that are part of the vehicle from the main navigation mesh
//*****************************************************************************************

vehicle_connectpaths_wrapper()
{
	self ConnectPaths();
	if ( isdefined( self.e_dyn_path ) )
	{
		self.e_dyn_path maps\_dynamic_nodes::entity_disconnect_dynamic_nodes_from_navigation_mesh();
	}
	else
	{
		self maps\_dynamic_nodes::entity_disconnect_dynamic_nodes_from_navigation_mesh();
	}
}


//*****************************************************************************
// self = vehicle
//
// Vehicle wants to stop so:-
//   - make a hole in the navigation mesh
//   - connect the vehicles cover nodes to the navigation mesh
//*****************************************************************************

vehicle_disconnectpaths_wrapper()
{
	if ( isdefined( self.e_dyn_path ) )
	{
		self.e_dyn_path thread maps\_dynamic_nodes::entity_connect_dynamic_nodes_to_navigation_mesh();
	}
	else
	{
		self thread maps\_dynamic_nodes::entity_connect_dynamic_nodes_to_navigation_mesh();
	}
	
	self DisconnectPaths();
}


//*****************************************************************************
// 	Vehicle AI Commands
// 
//	- These are used in conjunction with the vehicle ai system
//	- If you the vehicle is not setup to use the ai system they will do nothing
//	- Please see Omar if you have questions
//
//*****************************************************************************

// Will stop current behavior
stop()
{
	if( !IsDefined( self.emped ) )
	{
		self notify( "scripted" );
	}
}


// Will defend an area defined by position and radius
defend( position, radius )
{
	if( !IsDefined( self.emped ) )
	{
		self.goalpos = position;
		if( IsDefined( radius ) )
		{
			self.goalradius = radius;
		}
		self notify( "main" );	
	}
}

/#
vehicle_spawner_tool( allvehicles )
{
	vehicletypes = [];
	
	foreach( veh in allvehicles )
	{
		vehicletypes[ veh.vehicletype ] = veh.model;
	}
	
	if( IsAssetLoaded( "vehicle", "civ_pickup_mini" ) )
	{
		veh = CodeSpawnVehicle( 1, "debug_spawn_vehicle", "civ_pickup_mini", (0,0,10000), (0,0,0) );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	if( IsAssetLoaded( "vehicle", "apc_cougar_player" ) )
	{
		veh = CodeSpawnVehicle( 1, "debug_spawn_vehicle", "apc_cougar_player", (0,0,10000), (0,0,0) );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	if( IsAssetLoaded( "vehicle", "rc_car_racer" ) )
	{
		veh = CodeSpawnVehicle( 1, "debug_spawn_vehicle", "rc_car_racer", (0,0,10000), (0,0,0) );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	
	types = getArrayKeys( vehicletypes );
	
	type_index = 0;
	
	while( 1 )
	{
		if( getdebugdvarint( "debug_vehicle_spawn" ) > 0 )
		{
			player = get_players()[0];
			
			dynamic_spawn_hud = NewClientHudElem( player );
			dynamic_spawn_hud.alignX = "left";
			dynamic_spawn_hud.x = 20;
			dynamic_spawn_hud.y = 395;
			dynamic_spawn_hud.fontscale = 2;
			
			dynamic_spawn_dummy_model = spawn( "script_model", (0,0,0) );
			
			const waittime = 0.3;
			
			while( getdebugdvarint( "debug_vehicle_spawn" ) > 0 )
			{
				origin = player.origin + AnglesToForward( player getPlayerAngles() ) * 270.0;
				origin += (0,0,40);
				
				if( player UseButtonPressed() )
				{	
					dynamic_spawn_dummy_model Hide();
					vehicle = CodeSpawnVehicle( 1, "debug_spawn_vehicle", types[type_index], origin, player.angles );
					vehicle_init( vehicle );
					vehicle MakeVehicleUsable();
					
					if( getdebugdvarint( "debug_vehicle_spawn" ) == 1 )
					{
						setdvar( "debug_vehicle_spawn", 0 );
						continue;
					}
					wait waittime;
				}
				if( player buttonpressed("DPAD_RIGHT") )
				{
					dynamic_spawn_dummy_model Hide();
					type_index++;
					if( type_index >= types.size )
						type_index = 0;
					wait waittime;
				}
				if( player buttonpressed("DPAD_LEFT") )
				{
					dynamic_spawn_dummy_model Hide();
					type_index--;
					if( type_index < 0 )
						type_index = types.size - 1;
					wait waittime;
				}
				type = types[type_index];
				dynamic_spawn_hud settext("Press X to spawn vehicle " + type );
			
				dynamic_spawn_dummy_model SetModel( vehicletypes[type] );
				dynamic_spawn_dummy_model Show();
				dynamic_spawn_dummy_model NotSolid();
				dynamic_spawn_dummy_model.origin = origin;
				dynamic_spawn_dummy_model.angles = player.angles;
				wait 0.05;
			}
			
			dynamic_spawn_hud destroy();
			dynamic_spawn_dummy_model delete();
		}
		
		wait 2;
	}
}
#/