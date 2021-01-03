#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicle_death_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

 // match MAX_LIGHTFX_GROUPS in vehiclecustomsettings.awi
 // match MAX_AMBIENT_ANIM_GROUPS in vehiclecustomsettings.awi
	


#precache( "material", "black" );
#precache( "eventstring", "hud_vehicle_turret_fire" );

#namespace vehicle;

function autoexec __init__sytem__() {     system::register("vehicle_shared",&__init__,&__main__,undefined);    }

 /*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

VEHICLE script

This handles playing the various effects and animations on a vehicle.
function It handles initializing a vehicle( giving it life, turrets, machine guns, treads and things )

It also handles spawning of vehicles in a very ugly way for now, we're getting code to make it pretty

Most things you see in the vehicle menu in Radiant are handled here.  There's all sorts of properties
that you can set on a trigger to access some of this functionality.  A trigger can spawn a vehicle,
toggle different behaviors,


HIGH LEVEL FUNCTIONS

 // init( vehicle )
	this give the vehicle life, treads, turrets, machine guns, all that good stuff

 // animmode::main()
	this is setup, sets up spawners, trigger associations etc is ran on first frame by _load

 // trigger_process( trigger, vehicles )
	since triggers are multifunction I made them all happen in the same thread so that
	the sequencing would be easy to handle

 // paths()
	This makes the nodes get notified trigger when they are hit by a vehicle, we hope
	to move this functionality to CODE side because we have to use a lot of wrappers for
	attaching a vehicle to a path

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */


#using_animtree( "generic" );

function __init__()
{
	clientfield::register( "vehicle", "toggle_lockon",							1, 1, "int" );
	clientfield::register( "vehicle", "toggle_sounds", 							1, 1, "int" );
	clientfield::register( "vehicle", "use_engine_damage_sounds",			 	1, 2, "int" );
	clientfield::register( "vehicle", "toggle_treadfx", 						1, 1, "int" );
	clientfield::register( "vehicle", "toggle_exhaustfx", 						1, 1, "int" );
	clientfield::register( "vehicle", "toggle_lights", 							1, 2, "int" );
	clientfield::register( "vehicle", "toggle_lights_group1", 					1, 1, "int" );
	clientfield::register( "vehicle", "toggle_lights_group2", 					1, 1, "int" );
	clientfield::register( "vehicle", "toggle_lights_group3", 					1, 1, "int" );
	clientfield::register( "vehicle", "toggle_ambient_anim_group1", 			1, 1, "int" );
	clientfield::register( "vehicle", "toggle_ambient_anim_group2", 			1, 1, "int" );
	clientfield::register( "vehicle", "toggle_ambient_anim_group3", 			1, 1, "int" );
	clientfield::register( "vehicle", "deathfx",								1, 1, "int" );
	clientfield::register( "vehicle", "alert_level", 							1, 2, "int" );
	clientfield::register( "vehicle", "set_lighting_ent", 						1, 1, "int" );
	clientfield::register( "vehicle", "use_lighting_ent", 						1, 1, "int" );
	clientfield::register( "vehicle", "damage_level",							1, 3, "int" );
	
	clientfield::register( "helicopter", "toggle_lockon",							1, 1, "int" );
	clientfield::register( "helicopter", "toggle_sounds", 							1, 1, "int" );
	clientfield::register( "helicopter", "use_engine_damage_sounds",			 	1, 2, "int" );
	clientfield::register( "helicopter", "toggle_treadfx", 						1, 1, "int" );
	clientfield::register( "helicopter", "toggle_exhaustfx", 						1, 1, "int" );
	clientfield::register( "helicopter", "toggle_lights", 							1, 2, "int" );
	clientfield::register( "helicopter", "toggle_lights_group1", 					1, 1, "int" );
	clientfield::register( "helicopter", "toggle_lights_group2", 					1, 1, "int" );
	clientfield::register( "helicopter", "toggle_lights_group3", 					1, 1, "int" );
	clientfield::register( "helicopter", "toggle_ambient_anim_group1", 			1, 1, "int" );
	clientfield::register( "helicopter", "toggle_ambient_anim_group2", 			1, 1, "int" );
	clientfield::register( "helicopter", "toggle_ambient_anim_group3", 			1, 1, "int" );
	clientfield::register( "helicopter", "deathfx",								1, 1, "int" );
	clientfield::register( "helicopter", "alert_level", 							1, 2, "int" );
	clientfield::register( "helicopter", "set_lighting_ent", 						1, 1, "int" );
	clientfield::register( "helicopter", "use_lighting_ent", 						1, 1, "int" );
	clientfield::register( "helicopter", "damage_level",							1, 3, "int" );
	
	clientfield::register( "plane", "toggle_treadfx", 							1, 1, "int" );
	
	clientfield::register( "toplayer", "toggle_dnidamagefx", 					1, 1, "int" );
	
	if(isdefined(level.bypassVehicleScripts))
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
	setup_level_vars();

	// pre - associate vehicle triggers and vehicle nodes with stuff.
	setup_triggers();
	
	setup_nodes();

	// send the setup triggers to be processed
	level array::thread_all_ents( level.vehicle_processtriggers, &trigger_process );

	// CHECKME
	level.vehicle_processtriggers = undefined;
	
	// SCRIPTER_MOD: dguzzo: 3-9-09 : this looks to be used only for arcade mode. going to leave in the one cod:waw reference as an example.
	// CODER_MOD: Tommy K
	level.vehicle_enemy_tanks = [];
	level.vehicle_enemy_tanks[ "vehicle_ger_tracked_king_tiger" ] 		= true;
	
	level thread _watch_for_hijacked_vehicles();

}

function __main__()
{
	a_all_spawners = GetVehicleSpawnerArray();
	setup_spawners( a_all_spawners );
	
	/#
		level thread vehicle_spawner_tool();
		level thread spline_debug();
	#/
}

/* DEAD CODE REMOVAL
function trigger_getlinkmap( trigger )
{
	linkMap = [];
	if( isdefined( trigger.script_linkTo ) )
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
function setup_script_gatetrigger( trigger )
{
	gates = [];
	if( isdefined( trigger.script_gatetrigger ) )
	{
		return level.vehicle_gatetrigger[ trigger.script_gatetrigger ];
	}
	return gates;
}

/* DEAD CODE REMOVAL
// setup_script_vehiclespawngroup( trigger, vehicles, linkMap )
function setup_script_vehiclespawngroup( trigger, vehicles )
{
	script_vehiclespawngroup = false;
	if( isdefined( trigger.script_vehiclespawngroup ) )
	{
		script_vehiclespawngroup = true;
	}
	return script_vehiclespawngroup;
}
*/

function trigger_process( trigger )
{
	// these triggers only trigger once where vehicle paths trigger everytime a vehicle crosses them
	if( isdefined( trigger.classname ) && ( trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat" || trigger.classname == "trigger_box" ))
	{
		bTriggeronce = true;
	}
	else
	{
		bTriggeronce = false;
	}
	
	// override to make a trigger loop
	if( isdefined( trigger.script_noteworthy ) && trigger.script_noteworthy == "trigger_multiple" )
	{
		bTriggeronce = false;
	}
	
	trigger.processed_trigger = undefined;  // clear out this flag that was used to get the trigger to this point.

	gates = setup_script_gatetrigger( trigger );

	// origin paths and script struct paths get this value
	script_vehicledetour = isdefined( trigger.script_vehicledetour ) && ( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) ) ;

	 // ground paths get this value
	detoured = isdefined( trigger.detoured ) && !( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );
	gotrigger = true;

	while( gotrigger )
	{
		trigger trigger::wait_till();
		other = trigger.who;

// bbarnes - starting to trim out things we probably don't need.
//		if ( isdefined( trigger.script_vehicletriggergroup ) )
//		{
//			if( !isdefined( other.script_vehicletriggergroup ) )
//			{
//				continue;
//			}
//
//			if( isdefined(other) && other.script_vehicletriggergroup != trigger.script_vehicletriggergroup )
//			{
//				continue;
//			}
//		}

		if( isdefined( trigger.enabled ) && !trigger.enabled )
		{
			trigger waittill( "enable" );
		}
			
		if ( isdefined( trigger.script_flag_set ) )
		{
			if ( isdefined(other) && isdefined( other.vehicle_flags ) )
			{
				other.vehicle_flags[ trigger.script_flag_set ] = true;
			}

			if ( isdefined(other) )
			{
				other notify( "vehicle_flag_arrived", trigger.script_flag_set );
			}
			
			level flag::set( trigger.script_flag_set );
		}

		if ( isdefined( trigger.script_flag_clear ) )
		{
			if ( isdefined(other) && isdefined( other.vehicle_flags ) )
			{
				other.vehicle_flags[ trigger.script_flag_clear ] = false;
			}
			
			level flag::clear( trigger.script_flag_clear );
		}

		if( isdefined(other) && script_vehicledetour )
		{
			other thread path_detour_script_origin( trigger );
		}
		else if ( detoured && isdefined( other ) )
		{
			other thread path_detour( trigger );
		}
		
		trigger util::script_delay();

		if( bTriggeronce )
		{
			gotrigger = false;
		}

		if ( isdefined( trigger.script_vehicleGroupDelete ) )
		{
			if( !isdefined( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] ) )
			{
				/#println( "failed to find deleteable vehicle with script_vehicleGroupDelete group number: ", trigger.script_vehicleGroupDelete );#/
				level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] = [];
			}
			array::delete_all( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] );
		}

		if( isdefined( trigger.script_vehiclespawngroup ) )
		{
			level notify( "spawnvehiclegroup" + trigger.script_vehiclespawngroup );
			level waittill( "vehiclegroup spawned" + trigger.script_vehiclespawngroup );
		}

		if ( gates.size > 0 && bTriggeronce )
		{
			level array::thread_all_ents( gates,&path_gate_open );
		}

		if ( isdefined( trigger.script_VehicleStartMove ) )
		{
			if ( !isdefined( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ] ) )
			{
				/#println( "^3Vehicle start trigger is: ", trigger.script_VehicleStartMove );#/
				return;
			}

			array::thread_all( ArrayCopy( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ] ),&go_path  );
		}
	}
}

function path_detour_get_detourpath( detournode )
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

function path_detour_script_origin( detournode )
{
	detourpath = path_detour_get_detourpath( detournode );
	if( isdefined( detourpath ) )
	{
		self thread paths( detourpath );
	}
}

function crash_detour_check( detourpath )
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
		)
		&&
		(
			!isdefined( detourpath.derailed )
			|| ( isdefined( detourpath.script_crashtype ) && detourpath.script_crashtype == "plane" )
		)
	);
}

function crash_derailed_check( detourpath )
{
	return isdefined( detourpath.derailed ) && detourpath.derailed;
}

function path_detour( node )
{
	detournode = getvehiclenode( node.target, "targetname" );
	detourpath = path_detour_get_detourpath( detournode );

	// be more aggressive with this maybe?
	if( !isdefined( detourpath ) )
	{
		return;
	}

	if( node.detoured && !isdefined( detourpath.script_vehicledetourgroup ) )
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
		if( isdefined( detourpath.script_vehicledetourgroup ) )
		{
			if( !isdefined( self.script_vehicledetourgroup ) )
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
function levelstuff( vehicle/*, trigger*/ )
{
	// associate with links
	if( isdefined( vehicle.script_linkname ) )
	{
		level.vehicle_link = array_2d_add( level.vehicle_link, vehicle.script_linkname, vehicle );
	}

	if( isdefined( vehicle.script_VehicleSpawngroup ) )
	{
		level.vehicle_SpawnGroup = array_2d_add( level.vehicle_SpawnGroup, vehicle.script_VehicleSpawngroup, vehicle );
	}

	if( isdefined( vehicle.script_VehicleStartMove ) )
	{
		level.vehicle_StartMoveGroup = array_2d_add( level.vehicle_StartMoveGroup, vehicle.script_VehicleStartMove, vehicle );
	}

	if( isdefined( vehicle.script_vehicleGroupDelete ) )
	{
		level.vehicle_DeleteGroup = array_2d_add( level.vehicle_DeleteGroup, vehicle.script_vehicleGroupDelete, vehicle );
	}
}

function _spawn_array( spawners )
{
	ai = _remove_non_riders_from_array( spawner::simple_spawn( spawners ) );
	return ai;
}

function _remove_non_riders_from_array( ai )
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

function ai_should_be_added( ai )
{
	if( isalive( ai ) )
	{
		return true;
	}
	
	if ( !isdefined( ai ) )
	{
		return false;
	}
	
	if ( !isdefined( ai.classname ) )
	{
		return false;
	}
		
	return ai.classname == "script_model";
}
		
function sort_by_startingpos( guysarray )
{
	firstarray = [];
	secondarray = [];

	for ( i = 0 ; i < guysarray.size ; i++ )
	{
		if ( isdefined( guysarray[ i ].script_startingposition ) )
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

function rider_walk_setup( vehicle )
{
	if ( !isdefined( self.script_vehiclewalk ) )
	{
		return;
	}

	if ( isdefined( self.script_followmode ) )
	{
		self.FollowMode = self.script_followmode;
	}
	else
	{
		self.FollowMode = "cover nodes";
	}

	// check if the AI should go to a node after walking with the vehicle
	if ( !isdefined( self.target ) )
	{
		return;
	}

	node = getnode( self.target, "targetname" );
	if( isdefined( node ) )
	{
		self.NodeAftervehicleWalk = node;
	}
}

function setup_groundnode_detour( node )
{
	realdetournode = getvehiclenode( node.targetname, "target" );
	if( !isdefined( realdetournode ) )
	{
		return;
	}

	realdetournode.detoured = 0;
	add_proccess_trigger( realdetournode );
}

function add_proccess_trigger( trigger )
{
	// TODO: next game. stop trying to make everything a trigger.  remove trigger process. I'd do it this game but there is too much complexity in Detour nodes.
	 // .processedtrigger is a flag that I set to keep a trigger from getting added twice.
	if( isdefined( trigger.processed_trigger ) )
	{
		return;
	}
	
	if ( !isdefined( level.vehicle_processtriggers ) ) level.vehicle_processtriggers = []; else if ( !IsArray( level.vehicle_processtriggers ) ) level.vehicle_processtriggers = array( level.vehicle_processtriggers ); level.vehicle_processtriggers[level.vehicle_processtriggers.size]=trigger;;
	trigger.processed_trigger = true;
}

function islastnode( node )
{
	if( !isdefined( node.target ) )
	{
		return true;
	}

	if( !isdefined( getvehiclenode( node.target, "targetname" ) ) && !isdefined( get_vehiclenode_any_dynamic( node.target ) )  )
	{
		return true;
	}

	return false;
}

function paths( node )
{
	self endon( "death" );
	
	assert( isdefined( node ) || isdefined( self.attachedpath ), "vehicle_path() called without a path" );
	self notify( "newpath" );

	 // dynamicpaths unique.  node isn't defined by info vehicle node calls to this function
	if( isdefined( node ) )
	{
		self.attachedpath = node;
	}
	
	pathstart = self.attachedpath;
	self.currentNode = self.attachedpath;

	if ( !isdefined( pathstart ) )
	{
		return;
	}
	
/#
	self thread debug_vehicle_paths();
#/

	self endon( "newpath" );

	currentPoint = pathstart;

	while ( isdefined( currentPoint ) )
	{
		self waittill( "reached_node", currentPoint );
		
		currentPoint enable_turrets( self );

		if ( !isdefined( self ) )
		{
			return;
		}
			
		self.currentNode = currentPoint;
		self.nextNode = ( isdefined( currentPoint.target ) ? GetVehicleNode( currentPoint.target, "targetname" ) : undefined );

		if ( isdefined( currentPoint.gateopen ) && !currentPoint.gateopen )
		{
			 // threaded because vehicle may setspeed( 0, 15 ) and run into the next node
			self thread path_gate_wait_till_open( currentPoint );
		}
		
		currentPoint notify( "trigger", self );
		
		// SRS 05/03/07: added for _planeweapons to drop bombs
		// amount, delay, delay trace
		if( isdefined( currentPoint.script_dropbombs ) && currentPoint.script_dropbombs > 0 )
		{
			amount = currentPoint.script_dropbombs;
			delay = 0;
			delaytrace = 0;
			
			if( isdefined( currentPoint.script_dropbombs_delay ) && currentPoint.script_dropbombs_delay > 0 )
			{
				delay = currentPoint.script_dropbombs_delay;
			}
			
			if( isdefined( currentPoint.script_dropbombs_delaytrace ) && currentPoint.script_dropbombs_delaytrace > 0 )
			{
				delaytrace = currentPoint.script_dropbombs_delaytrace;
			}
			
			self notify( "drop_bombs", amount, delay, delaytrace );
		}

		if ( isdefined( currentPoint.script_noteworthy ) )
		{
			self notify( currentPoint.script_noteworthy );
			self notify( "noteworthy", currentPoint.script_noteworthy );
		}

		if ( isdefined( currentPoint.script_notify) )
		{
			self notify( currentPoint.script_notify );
			level notify( currentPoint.script_notify );
		}
		
		waittillframeend; // this lets other scripts interupt
		
		if ( !isdefined( self ) )
		{
			return;
		}
		
		if ( ( isdefined( currentPoint.script_delete ) && currentPoint.script_delete ) )
		{
			if ( isdefined( self.riders ) && self.riders.size > 0 )
			{
				array::delete_all( self.riders );
			}
			
			self.delete_on_death = true;           self notify( "death" );           if( !IsAlive( self ) )           self Delete();;
			return;
		}

		if ( isdefined( currentPoint.script_noteworthy ) )
		{
			if ( currentPoint.script_noteworthy == "godon" )
			{
				self god_on();
			}
			else if ( currentPoint.script_noteworthy == "godoff" )
			{
				self god_off();
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
			else if ( currentPoint.script_noteworthy == "resumespeed" )
			{
				accel = 30;
				if ( isdefined( currentPoint.script_float ) )
				{
					accel = currentPoint.script_float;	
				}
				self ResumeSpeed( accel );
			}
		}
		
		if ( isdefined( currentPoint.script_crashtypeoverride ) )
		{
			self.script_crashtypeoverride = currentPoint.script_crashtypeoverride;
		}

		if ( isdefined( currentPoint.script_badplace ) )
		{
			self.script_badplace = currentPoint.script_badplace;
		}

		if ( isdefined( currentPoint.script_team ) )
		{
			self.team = currentPoint.script_team;
		}

		if ( isdefined( currentPoint.script_turningdir ) )
		{
			self notify( "turning", currentPoint.script_turningdir );
		}
			
		if ( isdefined( currentPoint.script_deathroll ) )
		{
			if ( currentPoint.script_deathroll == 0 )
			{
				self thread vehicle_death::deathrolloff();
			}
			else
			{
				self thread vehicle_death::deathrollon();
			}
		}
		
		if ( isdefined( currentPoint.script_exploder ) )
		{
			exploder::exploder( currentPoint.script_exploder );
		}

		if ( isdefined( currentPoint.script_flag_set ) )
		{
			if ( isdefined( self.vehicle_flags ) )
			{
				self.vehicle_flags[ currentPoint.script_flag_set ] = true;
			}
			
			self notify( "vehicle_flag_arrived", currentPoint.script_flag_set );
			level flag::set( currentPoint.script_flag_set );
		}

		if ( isdefined( currentPoint.script_flag_clear ) )
		{
			if ( isdefined( self.vehicle_flags ) )
			{
				self.vehicle_flags[ currentPoint.script_flag_clear ] = false;
			}
			
			level flag::clear( currentPoint.script_flag_clear );
		}
				
		if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) && isdefined( self.drivepath ) && self.drivepath == 1 )
		{
			if ( isdefined( self.nextNode ) && self.nextNode is_unload_node() )
			{
				unload_node_helicopter( undefined );
				self.attachedpath = self.nextNode;
				self DrivePath( self.attachedpath );
			}
		}
		else 
		{
			if ( currentPoint is_unload_node() )
			{
				unload_node( currentPoint );
			}
		}
		
		if ( isdefined( currentPoint.script_wait ) )
		{
			pause_path();
			currentPoint util::script_wait();
		}
		
		if ( isdefined( currentPoint.script_waittill ) )
		{
			pause_path();
			util::waittill_any_ents( self, currentPoint.script_waittill, level, currentPoint.script_waittill );
		}

		if( isdefined( currentPoint.script_flag_wait ) )
		{
			if ( !isdefined( self.vehicle_flags ) )
			{
				self.vehicle_flags = [];
			}

			self.vehicle_flags[ currentPoint.script_flag_wait ] = true;
			self notify( "vehicle_flag_arrived", currentPoint.script_flag_wait );
			self flag::set( "waiting_for_flag" );

			// helicopters stop on their own because they know to stop at destination for script_flag_wait
			// may have to provide a smoother way to stop and go tho, this is rather arbitrary, for tanks
			// in this case
			
			if ( !level flag::get( currentPoint.script_flag_wait ) )
			{
				pause_path();
				level flag::wait_till( currentPoint.script_flag_wait );
			}

			self flag::clear( "waiting_for_flag" );
		}
			
		if ( isdefined( self.set_lookat_point ) )
		{
			self.set_lookat_point = undefined;
			self clearLookAtEnt();
		}
	
		if ( isdefined( currentPoint.script_lights_on ) )
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

		if ( isdefined( currentPoint.script_stopnode ) )
		{
			self set_goal_pos( currentPoint.origin, true );
		}
		
		if ( isdefined( self.switchNode ) )
		{
			if ( currentPoint == self.switchNode ) 
			{
				self.switchNode = undefined;	
			}
		}
		else
		{
			if ( !isdefined( currentPoint.target ) )
			{
				break;
			}
		}
		
		resume_path();
	}

	self notify( "reached_dynamic_path_end" );
	
	if ( isdefined( self.script_delete ) )
	{
		self Delete();
	}
}

function pause_path()
{
	if ( !( isdefined( self.vehicle_paused ) && self.vehicle_paused ) )
	{
		if ( self.isphysicsvehicle )
		{
			self SetBrake( true );
		}
		
		if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )
		{
			if ( ( isdefined( self.drivepath ) && self.drivepath ) )
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

function resume_path()
{
	if ( ( isdefined( self.vehicle_paused ) && self.vehicle_paused ) )
	{
		if ( self.isphysicsvehicle )
		{
			self SetBrake( false );
		}
		
		if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )
		{
			if ( ( isdefined( self.drivepath ) && self.drivepath ) )
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

/@
"Name: get_on_path( <path_start>, [str_key] )"
"Module: Vehicle"
"CallOn: Vehicle"
"Summary: Will attach the vehicle to a path"
"MandatoryArg: <path_start> : the actual start node or string name of the node"
"OptionalArg: [str_key] if passing in a string, the key of the node to look for."	
"Example: v_jeep vehicle::get_on_path( "escape_jeep_start" );"
@/
function get_on_path( path_start, str_key = "targetname"  ) // self == vehicle
{
	if( IsString( path_start ) )
	{
		path_start = GetVehicleNode( path_start, str_key );		
	}
	
	if( !isdefined( path_start ) )
	{
		if( isdefined( self.targetname ) )
		{
			AssertMsg( "Start Node not defined for vehicle: " + self.targetname  );
		}
		else
		{
			AssertMsg( "Start Node not defined for vehicle: " + self.targetname  );
		}
	}	
	
	//[ceng 4/26/2010] If a vehicle previously used _utility::go_path() then .hasstarted
	//would be set but never cleared, preventing the vehicle from using _utility::go_path()
	//again. This allows the vehicle to follow more paths beyond their first.
	if( isdefined( self.hasstarted ) )
	{
		self.hasstarted = undefined;
	}
	
	self.attachedpath = path_start;
	
	if ( !( isdefined( self.drivepath ) && self.drivepath ) )
	{
		//self.origin = path_start.origin;
		self AttachPath( path_start );
	}
	
	if( self.disconnectPathOnStop === true && !IsSentient(self) )
	{
		self DisconnectPaths();
	}

	if (( isdefined( self.isphysicsvehicle ) && self.isphysicsvehicle ))
	{
		self SetBrake(true);
	}

	self thread paths();
}

function get_off_path()
{
	self CancelAIMove();	
	self ClearVehGoalPos();	
}


/@
"Name: create_from_spawngroup_and_go_path( <spawnGroup> )"
"Summary: spawns and returns and array of the vehicles in the specified spawngroup starting them on their paths"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <spawnGroup> : the script_vehiclespawngroup asigned to the vehicles in radiant"
"Example: vehicle::create_from_spawngroup_and_go_path( spawnGroup )"
"SPMP: singleplayer"
@/

function create_from_spawngroup_and_go_path( spawnGroup )
{
	vehicleArray = _scripted_spawn( spawnGroup );
	for( i = 0; i < vehicleArray.size; i++ )
	{
		if (isdefined(vehicleArray[ i ]))
		{
			vehicleArray[ i ] thread vehicle::go_path();
		}
	}
	return vehicleArray;
}

/@
"Name: get_on_and_go_path( <path_start> )"
"Module: Vehicle"
"CallOn: a vehicle"
"MandatoryArg: <path_start> : the node, script_origin, or struct to start from"
"Summary: Attach and start the vehicle on its path."
"Example: vehicle thread vehicle::get_on_and_go_path(path_start)"
"SPMP: singleplayer"
@/
function get_on_and_go_path(path_start) // self == vehicle
{	
	// get_on_path will attach us to the path and allow us to get script_noteworthy notifies from nodes
	self vehicle::get_on_path(path_start);

	// go_path starts us on the path
	self vehicle::go_path();
}

// AE 5-15-09: cleaned up by taking out the vehicle parameter and just having the vehicle as self
function go_path() // self == vehicle
{
	self endon( "death" );
	self endon( "stop path" );
	
	if( self.isphysicsvehicle )
	{
		self SetBrake(false);
	}

	if( isdefined( self.script_vehiclestartmove ) )
	{
		ArrayRemoveValue( level.vehicle_StartMoveGroup[ self.script_vehiclestartmove ], self );
	}
	
	if( isdefined( self.hasstarted ) )
	{
		/#println( "vehicle already moving when triggered with a startmove" );#/
		return;
	}
	else
	{
		self.hasstarted = true;
	}

	self util::script_delay();

	self notify( "start_vehiclepath" );

	if ( ( isdefined( self.drivepath ) && self.drivepath ) )
	{
		self DrivePath( self.attachedpath );
	}
	else
	{
		self StartPath();
	}
			
	// start waiting for the end of the path
	wait .05;
	self ConnectPaths();
	
	self waittill( "reached_end_node" );

	if ( self.disconnectPathOnStop === true && !IsSentient( self ) )
	{
		self DisconnectPaths();
	}

	if( isdefined( self.currentnode ) && isdefined( self.currentnode.script_noteworthy ) && self.currentnode.script_noteworthy == "deleteme" )
	{
		return;
	}
}

function path_gate_open( node )
{
	node.gateopen = true;
	node notify( "gate opened" );
}

function path_gate_wait_till_open( pathspot )
{
	self endon( "death" );
	self.waitingforgate = true;
	self set_speed( 0, 15, "path gate closed" );
	pathspot waittill( "gate opened" );
	self.waitingforgate = false;

	if( self.health > 0 )
	{
		script_resume_speed( "gate opened", level.vehicle_ResumeSpeed );
	}
}

function _spawn_group( spawngroup )
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
			spawned_vehicles[ spawned_vehicles.size ] = _vehicle_spawn( level.vehicle_spawners[ spawngroup ][ i ] );
		}

		// notify we spawned and pass back spawned vehicles
		level notify( "vehiclegroup spawned" + spawngroup, spawned_vehicles );
	}
}

/@
"Name: _scripted_spawn( <group> )"
"Summary: spawns and returns a vehiclegroup, you will need to tell it to vehicle::go_path() when you want it to go"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <group> : "
"Example: bmps = _scripted_spawn( 32 );"
"SPMP: singleplayer"
@/

function _scripted_spawn( group )
{
	thread _scripted_spawn_go( group );
	level waittill( "vehiclegroup spawned" + group, vehicles );
	return vehicles;
}

function _scripted_spawn_go( group )
{
	waittillframeend;
	level notify( "spawnvehiclegroup" + group );
}

function set_variables( vehicle )
{
	if ( isdefined( vehicle.script_deathflag ) )
	{
		if ( !level flag::exists( vehicle.script_deathflag ) )
		{
			level flag::init( vehicle.script_deathflag );
		}
	}
}

//TODO T7 - set up a think function and send out a notify once we get a callback so vehicle spawning is similar to AI spawning
function _vehicle_spawn( vspawner, from )
{
	if( !vspawner.count )
	{
		return;
	}

	str_targetname = undefined;
	if( isdefined( vspawner.targetname ) )
	{
		str_targetname = vspawner.targetname + "_vh";
	}

	vehicle = vspawner SpawnFromSpawner( str_targetname, true );
	
	//failed to spawn a vehicle.
	if(!IsDefined(vehicle))
	{
		return;
	}

	//TODO T7 - bring over _destructible to CP
	/*if( isdefined( vehicle.destructibledef ) )
	{
		vehicle thread destructible::destructible_think();
	}*/
	
	if ( isdefined( vspawner.script_team ) )
	{
		vehicle SetTeam( vspawner.script_team );
	}
	
	if ( isdefined( vehicle.lockheliheight ) )
	{
		vehicle SetHeliHeightLock( vehicle.lockheliheight );
	}
	
	if( isdefined( vehicle.targetname ) )
	{
		level notify( "new_vehicle_spawned" + vehicle.targetname, vehicle );
	}

	if( isdefined( vehicle.script_noteworthy ) )
	{
        level notify( "new_vehicle_spawned" + vehicle.script_noteworthy, vehicle );
	}
	
	if( isdefined(vehicle.script_animname))
	{
		vehicle.animname = vehicle.script_animname;
	}
	
	if ( isdefined( vehicle.script_animscripted ) )
	{
		vehicle.supportsAnimScripted = vehicle.script_animscripted;
	}
	
	return vehicle;
}

function init( vehicle )
{
	callback::callback( #"on_vehicle_spawned" );
	
	vehicle UseAnimTree( #animtree );
	
	if ( isdefined( vehicle.e_dyn_path ) )
	{
		vehicle.e_dyn_path LinkTo( vehicle );
	}

	vehicle flag::init("waiting_for_flag");
	vehicle.takedamage = !( isdefined( vehicle.script_godmode ) && vehicle.script_godmode );

	vehicle.zerospeed = true;
	
	if( !isdefined( vehicle.modeldummyon ) )
	{
		vehicle.modeldummyon = false;
	}
	
	if ( ( isdefined( vehicle.isphysicsvehicle ) && vehicle.isphysicsvehicle ) )
	{
		if ( ( isdefined( vehicle.script_brake ) && vehicle.script_brake ) )
		{
			vehicle SetBrake( true );
		}
	}

	type = vehicle.vehicletype;

	 // give the vehicle health
	vehicle _vehicle_life();

	vehicle thread maingun_fx();

	// getoutrig means fastrope.
	vehicle.getoutrig = [];
	if( isdefined( level.vehicle_attachedmodels ) && isdefined( level.vehicle_attachedmodels[ type ] ) )
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
	if( isdefined( self.script_badplace ) )
	{
		vehicle thread _vehicle_bad_place();
	}

	if ( isdefined( vehicle.scriptbundlesettings ) )
	{
		settings = struct::get_script_bundle( "vehiclecustomsettings", vehicle.scriptbundlesettings );

		if ( isdefined( settings ) && isdefined( settings.lightgroups_numGroups ) )
		{
			if ( settings.lightgroups_numGroups >= 1 && settings.lightgroups_1_always_on === true )
			{
				vehicle toggle_lights_group( 1, true );
			}
			if ( settings.lightgroups_numGroups >= 2 && settings.lightgroups_2_always_on === true )
			{
				vehicle toggle_lights_group( 2, true );
			}
			if ( settings.lightgroups_numGroups >= 3 && settings.lightgroups_3_always_on === true )
			{
				vehicle toggle_lights_group( 3, true );
			}
		}
	}

	 // regenerate friendly fire damage
	if( !vehicle is_cheap() )
	{
		vehicle friendly_fire_shield();
	}

	 // handles guys riding and doing stuff on vehicles
//	vehicle thread vehicle_aianim::handle_attached_guys();

	 // make vehicle shake physics objects.
	if( isdefined( vehicle.script_physicsjolt ) && vehicle.script_physicsjolt )
	{
		//T7 - Request from code to get this ability back if needed
	}

	 // associate vehicle with living level variables.
	levelstuff( vehicle );

	if ( vehicle.type === "artilery" )
	{
		vehicle.disconnectPathOnStop = undefined;

		self.bad_place_name = self.vehicletype + self GetEntityNumber();
		BadPlace_Box( self.bad_place_name, 0, self.origin, self.radius, "neutral" );
	}
	else
	{
		vehicle.disconnectPathOnStop = self.script_disconnectpaths;
	}

	// every vehicle that stops will disconnect its paths
	if( !vehicle is_cheap() && !( isdefined(vehicle.vehicleclass) && (vehicle.vehicleclass == "plane") ) && vehicle.type !== "artilery" )
	{
		vehicle thread _disconnect_paths_when_stopped();
	}

	if ( !isdefined( vehicle.script_nonmovingvehicle ) )
	{
		if ( isdefined( vehicle.target ) )
		{
			path_start = GetVehicleNode( vehicle.target, "targetname" );
			if ( !isdefined( path_start ) )
			{
				path_start = GetEnt(vehicle.target, "targetname" );
				if ( !isdefined( path_start ) )
				{
					path_start = struct::get( vehicle.target, "targetname" );
				}
			}
		}

		if ( isdefined( path_start ) && vehicle.vehicletype != "inc_base_jump_spotlight" )
		{
			vehicle thread get_on_path( path_start );
		}
	}
	
	if ( isdefined( vehicle.script_vehicleattackgroup ) )
	{
		vehicle thread attack_group_think();
	}

/#
	if( ( isdefined( vehicle.script_recordent ) && vehicle.script_recordent ) )
	{
		RecordEnt( vehicle );
	}
#/
	
	 // helicopters do dust kickup fx
	if( vehicle has_helicopter_dust_kickup() )
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
	//vehicle spawn_ai_group();
	vehicle thread vehicle_death::main();
	
	// Set myself as a target if specificed
	if ( isdefined( vehicle.script_targetset ) && vehicle.script_targetset == 1 )
	{
		offset = ( 0, 0, 0 );
		if ( isdefined( vehicle.script_targetoffset ) )
		{
			offset = vehicle.script_targetoffset;
		}
		
		Target_Set( vehicle, offset );
	}
	
	if ( ( isdefined( vehicle.script_vehicleavoidance ) && vehicle.script_vehicleavoidance ) )
	{
		vehicle SetVehicleAvoidance( true );
	}
	
	vehicle enable_turrets();
	
	if( isdefined( level.vehicleSpawnCallbackThread ) )
	{
		level thread [[ level.vehicleSpawnCallbackThread ]]( vehicle );
	}
}

function detach_getoutrigs()
{
	if ( !isdefined( self.getoutrig ) )
		return;
	if ( ! self.getoutrig.size )
		return;
	keys = GetArrayKeys( self.getoutrig );
	for ( i = 0; i < keys.size; i++ )
	{
		self.getoutrig[ keys[ i ] ] Unlink();
	}
}

function enable_turrets( veh )
{
	if ( !isdefined( veh ) )
	{
		veh = self;
	}
	
	if ( ( isdefined( self.script_enable_turret0 ) && self.script_enable_turret0 ) )
	{
		veh turret::enable( 0 );
	}

	if ( ( isdefined( self.script_enable_turret1 ) && self.script_enable_turret1 ) )
	{
		veh turret::enable( 1 );
	}
	
	if ( ( isdefined( self.script_enable_turret2 ) && self.script_enable_turret2 ) )
	{
		veh turret::enable( 2 );
	}
	
	if ( ( isdefined( self.script_enable_turret3 ) && self.script_enable_turret3 ) )
	{
		veh turret::enable( 3 );
	}
	
	if ( ( isdefined( self.script_enable_turret4 ) && self.script_enable_turret4 ) )
	{
		veh turret::enable( 4 );
	}
	
	if ( isdefined( self.script_enable_turret0 ) && !self.script_enable_turret0 )
	{
		veh turret::disable( 0 );
	}

	if ( isdefined( self.script_enable_turret1 ) && !self.script_enable_turret1 )
	{
		veh turret::disable( 1 );
	}
	
	if ( isdefined( self.script_enable_turret2 ) && !self.script_enable_turret2 )
	{
		veh turret::disable( 2 );
	}
	
	if ( isdefined( self.script_enable_turret3 ) && !self.script_enable_turret3 )		
	{
		veh turret::disable( 3 );
	}
	
	if ( isdefined( self.script_enable_turret4 ) && !self.script_enable_turret4 )				
	{
		veh turret::disable( 4 );
	}
}

// self == vehicle
function enable_auto_disconnect_path()
{
	self notify( "kill_disconnect_paths_forever" );
	self.disconnectPathOnStop = false;
	self thread _disconnect_paths_when_stopped();
}

function _disconnect_paths_when_stopped()
{
	if( IsPathfinder( self) ) 
	{
		self.disconnectPathOnStop = false;// lets other parts of the script know not to disconnect script
		return;
	}
	
	if ( isdefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
	{
		self.disconnectPathOnStop = false;// lets other parts of the script know not to disconnect script
		return;
	}

	self endon( "death" );
	self endon( "kill_disconnect_paths_forever" );
	
	wait 1;
	threshold = 5;
	
	while ( isdefined( self ) )
	{
		if ( LengthSquared( self.velocity ) < ( (threshold) * (threshold) ) )
		{
			if ( self.disconnectPathOnStop === true )
			{
				self DisconnectPaths();
				self notify( "speed_zero_path_disconnect" );
			}
			
			while( LengthSquared( self.velocity ) < ( (threshold) * (threshold) ) )
			{
				wait 1;
			}
		}
		
		self ConnectPaths();
		
		while( LengthSquared( self.velocity ) >= ( (threshold) * (threshold) ) )
		{
			wait 1;
		}		
	}
}

//function disconnect_paths_while_moving( interval )
//{
//	if( IsSentient( self) ) 
//	{
//		return;
//	}
//	
//	if ( isdefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
//	{
//		self.disconnectPathOnStop = true;// lets other parts of the script know not to disconnect script
//		return;
//	}
//
//	self endon( "death" );
//	self endon( "kill_disconnect_paths_forever" );
//	
//	while ( isdefined( self ) )
//	{
//		if ( Length( self.velocity ) > 1 )
//		{
//			if ( !isdefined( self.disconnectPathOnStop ) )
//			{
//				//self ConnectPaths();
//				self DisconnectPaths();
//			}
//			
//			self notify( "moving_path_disconnect" );
//		}
//		
//		wait interval;
//	}	
//}

function set_speed( speed, rate, msg )
{
	if( self getspeedmph() ==  0 && speed == 0 )
	{
		return;  // potential for disaster? keeps messages from overriding previous messages
	}

	 /#
	self thread debug_set_speed( speed, rate, msg );
	#/
	self setspeed( speed, rate );
}

function debug_set_speed( speed, rate, msg )
{
	 /#
	self notify( "new debug_vehiclesetspeed" );
	self endon( "new debug_vehiclesetspeed" );
	self endon( "resuming speed" );
	self endon( "death" );
	while( 1 )
	{
		while( GetDvarString( "debug_vehiclesetspeed" ) != "off" )
		{
			print3d( self.origin + ( 0, 0, 192 ), "vehicle setspeed: " + msg, ( 1, 1, 1 ), 1, 3 );
			wait .05;
		}
		wait .5;
	}
	#/
}

function script_resume_speed( msg, rate )
{
	self endon( "death" );
	fSetspeed = 0;
	type = "resumespeed";
	if( !isdefined( self.resumemsgs ) )
	{
		self.resumemsgs = [];
	}
	if( isdefined( self.waitingforgate ) && self.waitingforgate )
	{
		return; // ignore resumespeeds on waiting for gate.
	}

	if( isdefined( self.attacking ) && self.attacking )
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
		self set_speed( fSetspeed, 15, "resume setspeed from attack" );
	}
	self notify( "resuming speed" );
	/# self thread debug_resume( msg + " :" + type ); #/

}

/#
function debug_resume( msg )
{
	if( GetDvarString( "debug_vehicleresume" ) == "off" )
	{
		return;
	}
	self endon( "death" );
	number = self.resumemsgs.size;
	self.resumemsgs[ number ] = msg;
	const timer = 3;
	self thread print_resume_speed( gettime() + ( timer * 1000 ) );

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

function print_resume_speed( timer )
{
	self notify( "newresumespeedmsag" );
	self endon( "newresumespeedmsag" );
	self endon( "death" );
	while( gettime() < timer && isdefined( self.resumemsgs ) )
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

function god_on()
{
	self.takedamage = false;
}

function god_off()
{
	self.takedamage = true;
}

function get_normal_anim_time( animation )
{
	animtime = self getanimtime( animation );
	animlength = getanimlength( animation );
	if( animtime == 0 )
	{
		return 0;
	}
	return self getanimtime( animation ) / getanimlength( animation );
}

function setup_dynamic_detour( pathnode , get_func )
{
	prevnode = [[ get_func ]]( pathnode.targetname );
	assert( isdefined( prevnode ), "detour can't be on start node" );
	prevnode.detoured = 0;
}

 /*
function setup_origins()
{
	triggers = [];
	origins = getentarray( "script_origin", "classname" );
	for( i = 0; i < origins.size; i++ )
	{
		if( isdefined( origins[ i ].script_vehicledetour ) )
		{

			level.vehicle_detourpaths = array_2d_add( level.vehicle_detourpaths, origins[ i ].script_vehicledetour, origins[ i ] );
			if( level.vehicle_detourpaths[ origins[ i ].script_vehicledetour ].size > 2 )
				println( "more than two script_vehicledetour grouped in group number: ", origins[ i ].script_vehicledetour );

			prevnode = getent( origins[ i ].targetname, "target" );
			assert( isdefined( prevnode ), "detour can't be on start node" );
			triggers[ triggers.size ] = prevnode;
			prevnode.detoured = 0;
			prevnode = undefined;
		}
	}
	return triggers;
}
 */

function array_2d_add( array, firstelem, newelem )
{
	if( !isdefined( array[ firstelem ] ) )
	{
		array[ firstelem ] = [];
	}
	array[ firstelem ][ array[ firstelem ].size ] = newelem;
	return array;
}

function is_node_script_origin( pathnode )
{
	return isdefined( pathnode.classname ) && pathnode.classname == "script_origin";
}

// this determines if the node will be sent through trigger_process.  The uber trigger function that may get phased out.
function node_trigger_process()
{
	processtrigger = false;

	// special treatment for start nodes
	if ( (isdefined(self.spawnflags)&&((self.spawnflags & 1) == 1)) )
	{
		if( isdefined( self.script_crashtype ) )
		{
			level.vehicle_crashpaths[ level.vehicle_crashpaths.size ] = self;
		}
		
		level.vehicle_startnodes[ level.vehicle_startnodes.size ] = self;
	}

	if( isdefined( self.script_vehicledetour ) && isdefined( self.targetname ) )
	{
		get_func = undefined;
		// get_func is differnt for struct types and script_origin types of paths
		if( isdefined( get_from_entity( self.targetname ) ) )
		{
			get_func =&get_from_entity_target;
		}
		if( isdefined( get_from_spawnstruct( self.targetname ) ) )
		{
			get_func =&get_from_spawnstruct_target;
		}

		if( isdefined( get_func ) )
		{
			setup_dynamic_detour( self, get_func );
			processtrigger = true;  // the node with the script_vehicledetour waits for the trigger here unlike ground nodes which need to know 1 node in advanced that there's a detour, tricky tricky.
		}
		else
		{
			setup_groundnode_detour( self ); // other trickery.  the node is set to process in there.
		}

		level.vehicle_detourpaths = array_2d_add( level.vehicle_detourpaths, self.script_vehicledetour, self );
		/#
		if( level.vehicle_detourpaths[ self.script_vehicledetour ].size > 2 )
		{
			println( "more than two script_vehicledetour grouped in group number: ", self.script_vehicledetour );
		}
		#/
	}

	// if a gate isn't open then the vehicle will stop there and wait for it to become open.
	if( isdefined( self.script_gatetrigger ) )
	{
		level.vehicle_gatetrigger = array_2d_add( level.vehicle_gatetrigger, self.script_gatetrigger, self );
		self.gateopen = false;
	}

	// init the flags!
	if ( isdefined( self.script_flag_set ) )
	{
		if ( !isdefined(level.flag) || !isdefined( level.flag[ self.script_flag_set ] ) )
		{
			level flag::init( self.script_flag_set );
		}
	}

	// init the flags!
	if ( isdefined( self.script_flag_clear ) )
	{
		if ( !level flag::exists( self.script_flag_clear ) )
		{
			level flag::init( self.script_flag_clear );
		}
	}

	if( isdefined( self.script_flag_wait ) )
	{
		if ( !level flag::exists( self.script_flag_wait ) )
		{
			level flag::init( self.script_flag_wait );
		}
	}

	// various nodes that will be sent through trigger_process
	if (isdefined( self.script_VehicleSpawngroup )
		|| isdefined( self.script_VehicleStartMove )
		|| isdefined( self.script_gatetrigger )
		|| isdefined( self.script_Vehiclegroupdelete ))
	{
		processtrigger = true;
	}

	if( processtrigger )
	{
		add_proccess_trigger( self );
	}
}

function setup_triggers()
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
	triggers = ArrayCombine( triggers, trigger::get_all(), true, false );
	array::thread_all( triggers, &node_trigger_process );
	
}

function setup_nodes()
{
	a_nodes = GetAllVehicleNodes();
	foreach ( node in a_nodes )
	{
		if ( isdefined( node.script_flag_set ) )
		{
			if ( !level flag::exists( node.script_flag_set ) )
			{
				level flag::init( node.script_flag_set );
			}
		}
	}
}

function is_node_script_struct( node )
{
	if ( !isdefined( node.targetname ) )
	{
		return false;
	}
	
	return isdefined( struct::get( node.targetname, "targetname" ) );
}

function setup_spawners( a_veh_spawners )
{
	spawnvehicles = [];
	groups = [];

	foreach ( spawner in a_veh_spawners )
	{
		if ( isdefined( spawner.script_vehiclespawngroup ) )
		{
			if ( !isdefined( spawnvehicles[ spawner.script_vehiclespawngroup ] ) ) spawnvehicles[ spawner.script_vehiclespawngroup ] = []; else if ( !IsArray( spawnvehicles[ spawner.script_vehiclespawngroup ] ) ) spawnvehicles[ spawner.script_vehiclespawngroup ] = array( spawnvehicles[ spawner.script_vehiclespawngroup ] ); spawnvehicles[ spawner.script_vehiclespawngroup ][spawnvehicles[ spawner.script_vehiclespawngroup ].size]=spawner;;
			
			addgroup[ 0 ] = spawner.script_vehiclespawngroup;
			groups = ArrayCombine( groups, addgroup, false, false );
		}
	}

	waittillframeend;	//T7 - wait here and let all the vehicle inits run
	
	foreach ( spawngroup in groups )
	{
		a_veh_spawners = spawnvehicles[ spawngroup ];
				
		level.vehicle_spawners[ spawngroup ] = [];
	
		foreach ( sp in a_veh_spawners )
		{
			if( sp.count < 1 )
			{
				sp.count = 1;
			}
			
//			sp vehicle_dynamic_cover();
			set_variables( sp );
	
			if ( !isdefined( level.vehicle_spawners[ spawngroup ] ) ) level.vehicle_spawners[ spawngroup ] = []; else if ( !IsArray( level.vehicle_spawners[ spawngroup ] ) ) level.vehicle_spawners[ spawngroup ] = array( level.vehicle_spawners[ spawngroup ] ); level.vehicle_spawners[ spawngroup ][level.vehicle_spawners[ spawngroup ].size]=sp;;
		}
	
		level thread _spawn_group( spawngroup );
	}
}

function _vehicle_life()
{
	if (isdefined(self.destructibledef))
	{
		self.health = 99999;
	}
	else
	{
		type = self.vehicletype;

		if( isdefined( self.script_startinghealth ) )
		{
			self.health = self.script_startinghealth;
		}
		else
		{
			if( self.healthdefault == -1 )
			{
				return;
			}
			else
			{
				self.health = self.healthdefault;
				//println("set health: " + self.health);
			}
		}
		
		//	if( isdefined( level.destructible_model[ self.model ] ) )
		//	{
		//		self.health = 2000;
		//		self.destructible_type = level.destructible_model[ self.model ];
		//		self destructible::setup_destructibles( true );
		//	}
	}
}

function _vehicle_load_assets()
{

}


function is_cheap()
{
	if( !isdefined( self.script_cheap ) )
	{
		return false;
	}

	if( !self.script_cheap )
	{
		return false;
	}

	return true;
}


function has_helicopter_dust_kickup()
{
	if( !( isdefined(self.vehicleclass) && (self.vehicleclass == "plane") ) )
	{
		return false;
	}

	if( is_cheap() )
	{
		return false;
	}

	return true;
}

function play_looped_fx_on_tag( effect, durration, tag )
{
 	eModel = get_dummy();
	effectorigin = Spawn( "script_origin", eModel.origin );

	self endon( "fire_extinguish" );
	thread _play_looped_fx_on_tag_origin_update( tag, effectorigin );
	while( 1 )
	{
		playfx( effect, effectorigin.origin, effectorigin.upvec );
		wait durration;
	}
}

function _play_looped_fx_on_tag_origin_update( tag, effectorigin )
{
	effectorigin.angles = self gettagangles( tag );
	effectorigin.origin  = self gettagorigin( tag );
	effectorigin.forwardvec = anglestoforward( effectorigin.angles );
	effectorigin.upvec = anglestoup( effectorigin.angles );
	while( isdefined( self ) && self.classname == "script_vehicle" && self getspeedmph() > 0 )
	{
		eModel = get_dummy();
		effectorigin.angles = eModel gettagangles( tag );
		effectorigin.origin  = eModel gettagorigin( tag );
		effectorigin.forwardvec = anglestoforward( effectorigin.angles );
		effectorigin.upvec = anglestoup( effectorigin.angles );
		wait .05;
	}
}

function setup_dvars()
{
	/#
	if( GetDvarString( "debug_vehicleresume" ) == "" )
	{
		SetDvar( "debug_vehicleresume", "off" );
	}
	if( GetDvarString( "debug_vehiclesetspeed" ) == "" )
	{
		SetDvar( "debug_vehiclesetspeed", "off" );
	}
	#/
}

function setup_level_vars()
{
	level.vehicle_ResumeSpeed = 5;
	level.vehicle_DeleteGroup = [];
	level.vehicle_SpawnGroup = [];
	level.vehicle_StartMoveGroup = [];
	level.vehicle_DeathSwitch = [];
	level.vehicle_gatetrigger = [];
	level.vehicle_crashpaths = [];
	level.vehicle_link = [];
	level.vehicle_detourpaths = [];
// 	level.vehicle_linkedpaths = [];
	level.vehicle_startnodes = [];
	level.vehicle_spawners =  [];
	level.a_vehicle_types = [];
	level.a_vehicle_targetnames = [];

	// AE 3-5-09: added this vehicle_walkercount so we can have ai walk with vehicles
	level.vehicle_walkercount = [];

	level.helicopter_crash_locations = getentarray( "helicopter_crash_location", "targetname" );

	level.playervehicle = sys::Spawn( "script_origin", ( 0, 0, 0 ) ); // no isdefined for level.playervehicle
	level.playervehiclenone = level.playervehicle; // no isdefined for level.playervehicle

	if( !isdefined( level.vehicle_death_thread ) )
	{
		level.vehicle_death_thread = [];
	}
	if( !isdefined( level.vehicle_DriveIdle ) )
	{
		level.vehicle_DriveIdle = [];
	}
	if( !isdefined( level.vehicle_DriveIdle_r ) )
	{
		level.vehicle_DriveIdle_r = [];
	}
	if( !isdefined( level.attack_origin_condition_threadd ) )
	{
		level.attack_origin_condition_threadd = [];
	}
	if( !isdefined( level.vehiclefireanim ) )
	{
		level.vehiclefireanim = [];
	}
	if( !isdefined( level.vehiclefireanim_settle ) )
	{
		level.vehiclefireanim_settle = [];
	}
	if( !isdefined( level.vehicle_hasname ) )
	{
		level.vehicle_hasname = [];
	}
	if( !isdefined( level.vehicle_turret_requiresrider ) )
	{
		level.vehicle_turret_requiresrider = [];
	}
	if( !isdefined( level.vehicle_isStationary ) )
	{
		level.vehicle_isStationary = [];
	}
	if( !isdefined( level.vehicle_compassicon ) )
	{
		level.vehicle_compassicon = [];
	}
	if( !isdefined( level.vehicle_unloadgroups ) )
	{
		level.vehicle_unloadgroups = [];
	}
//	if( !isdefined( level.vehicle_aianims ) )
//	{
//		level.vehicle_aianims = [];
//	}
	if( !isdefined( level.vehicle_unloadwhenattacked ) )
	{
		level.vehicle_unloadwhenattacked = [];
	}
	if( !isdefined( level.vehicle_deckdust ) )
	{
		level.vehicle_deckdust = [];
	}
	if( !isdefined( level.vehicle_types ) )
	{
		level.vehicle_types = [];
	}
	if( !isdefined( level.vehicle_compass_types ) )
	{
		level.vehicle_compass_types = [];
	}
	if( !isdefined( level.vehicle_bulletshield ) )
	{
		level.vehicle_bulletshield = [];
	}
	if( !isdefined( level.vehicle_death_badplace ) )
	{
		level.vehicle_death_badplace = [];
	}
		
//	vehicle_aianim::setup_aianimthreads();
		
}


function attacker_is_on_my_team( attacker )
{
	if( ( isdefined( attacker ) ) && isdefined( attacker.team ) && ( isdefined( self.team ) ) && ( attacker.team == self.team ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function attacker_troop_is_on_my_team( attacker )
{
	if ( isdefined( self.team ) && self.team == "allies" && isdefined( attacker ) && isdefined(level.player) && attacker == level.player )
	{
		return true;  // player is always on the allied team.. hahah! future CoD games that let the player be the enemy be damned!
	}
	else if( isai( attacker ) && attacker.team == self.team )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function bullet_shielded( type )
{
	if ( !isdefined( self.script_bulletshield ) )
	{
		return false;
	}
	
	type = tolower( type );
		
	if ( ! isdefined( type ) || ! issubstr( type, "bullet" ) )
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

function friendly_fire_shield()
{
	self.friendlyfire_shield = true;

	if ( isdefined( level.vehicle_bulletshield[ self.vehicletype ] ) && !isdefined( self.script_bulletshield ) )
	{
		self.script_bulletshield = level.vehicle_bulletshield[ self.vehicletype ];
	}
}

function friendly_fire_shield_callback( attacker, amount, type )
{
	if( !isdefined(self.friendlyfire_shield) || !self.friendlyfire_shield )
	{
		return false;
	}

	if(
		( ! isdefined( attacker ) && self.team != "neutral" ) ||
		attacker_is_on_my_team( attacker ) ||
		attacker_troop_is_on_my_team( attacker ) ||
		is_destructible() || 				// destructible pieces take the damage
		bullet_shielded( type )
	)
	{
		return true;
	}
	
	return false;
}

//function vehicle_dynamic_cover()
//{
//	if ( isdefined( self.targetname ) )
//	{
//		ent = GetEnt( self.targetname, "target" );
//		if ( isdefined( ent ) )
//		{
//			if ( isdefined( ent.script_noteworthy ) && ( ent.script_noteworthy == "dynamic_cover" ) )
//			{
//				e_dyn_path = ent;
//			}
//		}
//	}
//	
//	if ( isdefined( e_dyn_path ) )
//	{
//		self.e_dyn_path = e_dyn_path;
//	}
//	else
//	{
//		e_dyn_path = self;
//	}
//}

function _vehicle_bad_place()
{
	self endon( "kill_badplace_forever" );
	self endon( "death" );
	self endon( "delete" );
	
	if( isdefined( level.custombadplacethread ) )
	{
		self thread [[ level.custombadplacethread ]]();
		return;
	}
	
	hasturret = isdefined( self.turretweapon ) && self.turretweapon != level.weaponNone;
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

		if ( isdefined( self.BadPlaceModifier ) )
		{
			bp_radius = ( bp_radius * self.BadPlaceModifier );
		}

  		v_turret_angles = self GetTagAngles( "tag_turret" );
 		
 		if ( hasturret && isdefined( v_turret_angles ) )
		{
			bp_direction = AnglesToForward( v_turret_angles );
		}
		else
		{
			bp_direction = AnglesToForward( self.angles );
		}

		//badplace_arc( "", bp_duration, self.origin, bp_radius * 1.9, bp_height, bp_direction, bp_angle_left, bp_angle_right, "allies", "axis" );
		//badplace_cylinder( "", bp_duration, self.origin, 200, "allies", "axis" );
		//badplace_cylinder( "", bp_duration, self.colidecircle[ 1 ].origin, 200, bp_height, "allies", "axis" );
		wait bp_duration + .05;
	}
}

//function handle_unload_event()
//{
//	self notify( "vehicle_handleunloadevent" );
//	self endon( "vehicle_handleunloadevent" );
//	self endon( "death" );
//
//	type = self.vehicletype;
//	while( 1 )
//	{
//		self waittill( "unload", who );
//
//		 // setting an unload group unloaded guys resets to "default"
//		// SCRIPTER_MOD: JesseS (5/14/2007) -  took this out "who" for now, seems to be breaking unloadgroups.
//		//if( isdefined( who ) )
//		//	self.unload_group = who;
//		 // makes ai unload
//		self notify( "groupedanimevent", "unload" );
//	}
//}

function get_vehiclenode_any_dynamic( target )
{
	 // the should return undefined
	path_start = GetVehicleNode( target, "targetname" );
	
	if ( !isdefined( path_start ) )
	{
		path_start = GetEnt( target, "targetname" );
	}
	else if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "plane") ) )
	{
		/#
		PrintLn( "helicopter node targetname: " + path_start.targetname );
		PrintLn( "vehicletype: " + self.vehicletype );
		#/
		AssertMsg( "helicopter on vehicle path( see console for info )" );
	}
	
	if ( !isdefined( path_start ) )
	{
		path_start = struct::get( target, "targetname" );
	}
	
	return path_start;
}

//TODO T7 - ask code how this function differs from vehicle::resume_path()
function resume_path_vehicle()
{
	if ( isdefined( self.currentnode.target ) )
	{
		node = get_vehiclenode_any_dynamic( self.currentnode.target );
	}
	
	if ( isdefined( node ) )
	{
		self ResumeSpeed( 35 );
		paths( node );
	}
}

function land()
{
	self setNearGoalNotifyDist( 2 );
	self sethoverparams( 0, 0, 10 );
	self cleargoalyaw();
	self settargetyaw( ( 0, self.angles[1], 0 )[ 1 ] );
	self set_goal_pos( (bullettrace(self.origin,(self.origin + ( 0, 0, -100000 ) ), 0, self )[ "position" ]), 1 );
	self waittill( "goal" );
}

function set_goal_pos( origin, bStop )
{
	if( self.health <= 0 )
	{
		return;
	}
	if( isdefined( self.originheightoffset ) )
	{
		origin += ( 0, 0, self.originheightoffset ); // TODO - FIXME: this is temporarily set in the vehicles init_local function working on getting it this requirement removed
	}
	self setvehgoalpos( origin, bStop );
}

function liftoff( height )
{
	if( !isdefined( height ) )
	{
		height = 512;
	}
	dest = self.origin + ( 0, 0, height );
	self setNearGoalNotifyDist( 10 );
	self set_goal_pos( dest, 1 );
	self waittill( "goal" );
}

function wait_till_stable()
{
	 // wait for it to level out before unloading
	const offset = 12;
	const stabletime = 400;
	timer = gettime() + stabletime;
	while( isdefined( self ) )
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

function unload_node( node )
{
	// needed by RTS mode to halt choppers quicker. 
	// Result is ugly though and should be done properly by someone that knows vehicles at some point.
	if( isdefined( self.custom_unload_function ) )
	{
		[[ self.custom_unload_function ]]();
		return;
	}
	
	pause_path();
	
//	if ( self.riders.size > 0 )
//	{
//		pathnode = GetNode( node.targetname, "target" );
//		if ( isdefined( pathnode ) )
//		{
//			foreach ( ai_rider in self.riders )
//			{
//				if ( IsAI( ai_rider ) )
//				{
//					ai_rider thread spawner::go_to_node( pathnode );
//				}
//			}
//		}
//	}

	if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "plane") ) )
	{
		wait_till_stable();
	}
	else if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )
	{
		self SetHoverParams( 0, 0, 10 );
		wait_till_stable();
	}
	
	if ( node is_unload_node() )
	{
		unload( node.script_unload );
	}

//	if ( vehicle_aianim::riders_unloadable( node.script_unload ) || IS_TRUE( self.custom_unload ) )
//	{
//		self waittill( "unloaded" );
//	}
}

function is_unload_node()
{
	return ( isdefined( self.script_unload ) && ( self.script_unload != "none" ) );
}

function unload_node_helicopter( node )
{
	// needed by RTS mode to halt choppers quicker. 
	// Result is ugly though and should be done properly by someone that knows vehicles at some point.
	if( isdefined( self.custom_unload_function ) )
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
	if( isdefined( self.drop_offset_tag ) )
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

function detach_path()
{
	self.attachedpath = undefined;
	self notify( "newpath" );

	self setGoalyaw( ( 0, self.angles[1], 0 )[ 1 ] );
	self setvehgoalpos( self.origin + ( 0, 0, 4 ), 1 );
}

function setup_targetname_spawners()
{
	level.vehicle_targetname_array = [];

	vehicles = getentarray( "script_vehicle", "classname" );

	n_highest_group = 0;
	// get the highest script_vehicleSpawnGroup in use
	foreach ( vh in vehicles )
	{
		if ( isdefined( vh.script_vehicleSpawnGroup ) )
		{
			n_spawn_group = Int( vh.script_vehicleSpawnGroup );
			
			if ( n_spawn_group > n_highest_group )
			{
				n_highest_group = n_spawn_group;
			}
		}
	}

	for( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];

		if ( isdefined( vehicle.targetname ) && IsVehicleSpawner( vehicle ) )
		{
			if( !isdefined( vehicle.script_vehicleSpawnGroup ) )
			{
				// vehicle spawners that have no script_vehiclespawngroup get assigned one, if they have a targetname
				n_highest_group++;
				vehicle.script_vehicleSpawnGroup = n_highest_group;
			}

			if( !isdefined( level.vehicle_targetname_array[ vehicle.targetname ] ) )
			{
				level.vehicle_targetname_array[ vehicle.targetname ] = [];
			}

			level.vehicle_targetname_array[ vehicle.targetname ][ vehicle.script_vehicleSpawnGroup ] = true;
		}
	}
}

function simple_spawn( name, b_supress_assert=false )
{
	// spawns an array of vehicles that all have the specified targetname in the editor,
	// but are deleted at runtime
	
	Assert( b_supress_assert || isdefined( level.vehicle_targetname_array[ name ] ), "No vehicle spawners had targetname " + name );
	
	vehicles = [];
	if ( isdefined( level.vehicle_targetname_array[ name ] ) )
	{
		array = level.vehicle_targetname_array[ name ];
		
		if ( array.size > 0 )
		{
			keys = GetArrayKeys( array );
			
			foreach ( key in keys )
			{
				vehicle_array = _scripted_spawn( key );
				vehicles = ArrayCombine( vehicles, vehicle_array, true, false );
			}
		}
	}
	
	return vehicles;
}

function simple_spawn_single( name, b_supress_assert=false )
{
	vehicle_array = simple_spawn( name, b_supress_assert );
	Assert( b_supress_assert ||  vehicle_array.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicle_array.size + " vehicles, instead of 1" );

	if ( vehicle_array.size > 0 )
	{
		return vehicle_array[ 0 ];
	}
}

function simple_spawn_single_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = simple_spawn( name );
	assert( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );

	vehicleArray[ 0 ] thread go_path();
	return vehicleArray[ 0 ];
}

function simple_spawn_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = simple_spawn( name );
	for( i = 0; i < vehicleArray.size; i++ )
	{
		vehicleArray[ i ] thread go_path();
	}

	return vehicleArray;
}

//Wrapper for SpawnVehicle, use this to throttle vehicle spawning
function spawn( modelname, targetname, vehicletype, origin, angles, destructibledef )
{
	assert(isdefined(targetname));
	assert(isdefined(vehicletype));
	assert(isdefined(origin));
	assert(isdefined(angles));

	return SpawnVehicle( vehicletype, origin, angles, targetname, destructibledef );
}

function aircraft_dust_kickup( model )
{
	self endon( "death" );
	self endon( "death_finished" );
	self endon( "stop_kicking_up_dust" );

	assert( isdefined( self.vehicletype ) );

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
	if ( isdefined( model ) )
	{
		trace_ent = model;
	}

	while( isdefined( self ) )
	{
		if( repeatRate <= 0 )
		{
			repeatRate = defaultRepeatRate;
		}
		wait repeatRate;
		
		if( !isdefined( self ) )
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

		if( !isdefined( trace ) )
		{
			continue;
		}

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
		{
			trace[ "surfacetype" ] = "dirt";
		}
		assert( isdefined( level._vehicle_effect[ self.vehicletype ] ), self.vehicletype + " vehicle script hasn't run _tradfx properly" );
		assert( isdefined( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] ), "UNKNOWN SURFACE TYPE: " + trace[ "surfacetype" ] );

		 
		if( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] != -1 )
		{
			playfx( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ], trace[ "position" ] );
		}
	}
}

function impact_fx( fxname, surfaceTypes )
{
	if ( isdefined( fxname ) )
	{
		body = self GetTagOrigin( "tag_body" );
		if ( !isdefined( body ) )
		{
			body = self.origin + (0,0,10);
		}

		trace = BulletTrace( body, body - (0,0,2 * self.radius), false, self );
		if( trace["fraction"] < 1.0 && !isdefined( trace[ "entity" ] ) && ( !isdefined(surfaceTypes) || array::contains( surfaceTypes, trace["surfacetype"] ) ) )
		{
			pos = 0.5 * ( self.origin + trace["position"] );
			up = 0.5 * ( trace["normal"] + AnglesToUp( self.angles ) );
			forward = AnglesToForward( self.angles );
			PlayFx( fxname, pos, up, forward ); // reverse up and forward because impact FX are X-axis up
		}
	}
}

function maingun_fx()
{
	if( !isdefined( level.vehicle_deckdust[ self.model ] ) )
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

function lights_on( team )
{
	//lights:
	//0 - turn on normal
	//1 - turn off
	//2 - override to allied color
	//3 - override to axis color
	
	if( IsDefined( team ) )
	{
		if( team == "allies" )
		{
			self clientfield::set( "toggle_lights", 2 );
		}
		else if( team == "axis" )
		{
			self clientfield::set( "toggle_lights", 3 );
		}
	}
	else
	{
		self clientfield::set( "toggle_lights", 0 );
	}
}

function lights_off()
{
	self clientfield::set( "toggle_lights", 1 );
}

function toggle_lights_group( groupID, on )
{
	bit = 1;
	if ( !on ) 
	{
		bit = 0;
	}

	self clientfield::set( "toggle_lights_group" + groupID, bit );
}

function toggle_ambient_anim_group( groupID, on )
{
	bit = 1;
	if ( !on ) 
	{
		bit = 0;
	}

	self clientfield::set( "toggle_ambient_anim_group" + groupID, bit );
}

function do_death_fx()
{
	self clientfield::set( "deathfx", 1 );
}

function set_alert_fx_level( alert_level )	// 0 is off, 1 unaware, 2 alert, 3 combat
{
	self clientfield::set( "alert_level", alert_level );
}

function should_update_damage_fx_level( currentHealth, damage, maxHealth )
{
	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	if ( !isdefined( settings ) )
	{
		return 0;
	}

	currentRatio = math::clamp( float( currentHealth ) / float( maxHealth ), 0.0, 1.0 );
	afterDamageRatio = math::clamp( float( currentHealth - damage ) / float( maxHealth ), 0.0, 1.0 );
	currentLevel = undefined;
	afterDamageLevel = undefined;
	switch( settings.damagestate_numStates )
	{
	case 6:
		if ( settings.damagestate_lv6_ratio >= afterDamageRatio )
		{
			afterDamageLevel = 6;
			currentLevel = 6;
			if ( settings.damagestate_lv6_ratio < currentRatio )
			{
				currentLevel = 5;
			}
			break;
		} // fall through
	case 5:
		if ( settings.damagestate_lv5_ratio >= afterDamageRatio )
		{
			afterDamageLevel = 5;
			currentLevel = 5;
			if ( settings.damagestate_lv5_ratio < currentRatio )
			{
				currentLevel = 4;
			}
			break;
		} // fall through
	case 4:
		if ( settings.damagestate_lv4_ratio >= afterDamageRatio )
		{
			afterDamageLevel = 4;
			currentLevel = 4;
			if ( settings.damagestate_lv4_ratio < currentRatio )
			{
				currentLevel = 3;
			}
			break;
		} // fall through
	case 3:
		if ( settings.damagestate_lv3_ratio >= afterDamageRatio )
		{
			afterDamageLevel = 3;
			currentLevel = 3;
			if ( settings.damagestate_lv3_ratio < currentRatio )
			{
				currentLevel = 2;
			}
			break;
		} // fall through
	case 2:
		if ( settings.damagestate_lv2_ratio >= afterDamageRatio )
		{
			afterDamageLevel = 2;
			currentLevel = 2;
			if ( settings.damagestate_lv2_ratio < currentRatio )
			{
				currentLevel = 1;
			}
			break;
		} // fall through
	case 1:
		if ( settings.damagestate_lv1_ratio >= afterDamageRatio )
		{
			afterDamageLevel = 1;
			currentLevel = 1;
			if ( settings.damagestate_lv1_ratio < currentRatio )
			{
				currentLevel = 0;
			}
			break;
		} // fall through
	}

	if ( !isdefined( currentLevel ) || !isdefined( afterDamageLevel ) )
	{
		return 0;
	}

	if ( currentLevel != afterDamageLevel )
	{
		return afterDamageLevel;
	}

	return 0;
}

// self == vehicle
// returns if damage level changed after damage
function update_damage_fx_level( currentHealth, damage, maxHealth )
{
	newDamageLevel = should_update_damage_fx_level( currentHealth, damage, maxHealth );
	if ( newDamageLevel > 0 )
	{
		self set_damage_fx_level( newDamageLevel );
		return true;
	}
	return false;
}

// self == vehicle
// 0 is off, higher level means higher damage
function set_damage_fx_level( damage_level )
{
	self clientfield::set( "damage_level", damage_level );
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

function build_drive( forward, reverse, normalspeed, rate )
{
	if( !isdefined( normalspeed ) )
	{
		normalspeed = 10;
	}
	level.vehicle_DriveIdle[ self.model ] = forward;
	
	if( isdefined( reverse ) )
	{
		level.vehicle_DriveIdle_r[ self.model ] = reverse;
	}
	level.vehicle_DriveIdle_normal_speed[ self.model ] = normalspeed;
	if( isdefined( rate ) )
	{
		level.vehicle_DriveIdle_animrate[ self.model ] = rate;
	}
}

///@
//"Name: build_ai_anims( <aithread> , <vehiclethread> )"
//"Summary: called in individual vehicle file - set threads for ai animation and vehicle animation assignments"
//"Module: Vehicle"
//"CallOn: A vehicle"
//"MandatoryArg: <aithread> : ai thread"
//"OptionalArg: <vehiclethread> : vehicle thread"
//"Example: vehicle build_ai_anims(&setanims,&set_vehicle_anims );"
//"SPMP: singleplayer"
//@/
//
//function build_ai_anims( aithread, vehiclethread )
//{
//	level.vehicle_aianims[ self.vehicletype ] = [[ aithread ]]();
//	if( isdefined( vehiclethread ) )
//	{
//		level.vehicle_aianims[ self.vehicletype ] = [[ vehiclethread ]]( level.vehicle_aianims[ self.vehicletype ] );
//	}
//}


///@
//"Name: build_attach_models( <modelsthread> )"
//"Summary: called in individual vehicle file - thread for building attached models( ropes ) with animation"
//"Module: Vehicle"
//"CallOn: "
//"MandatoryArg: <modelsthread> : thread"
//"Example: build_attach_models(&set_attached_models );"
//"SPMP: singleplayer"
//@/
//
//function build_attach_models( modelsthread )
//{
//	level.vehicle_attachedmodels[ self.vehicletype ] = [[ modelsthread ]]();;
//}

///@
//"Name: build_unload_groups( <unloadgroupsthread> )"
//"Summary: called in individual vehicle file - thread for building unload groups"
//"Module: Vehicle"
//"CallOn: A vehicle"
//"MandatoryArg: <modelsthread> : thread"
//"Example: vehicle build_unload_groups(&Unload_Groups );"
//"SPMP: singleplayer"
//@/
//
//function build_unload_groups( unloadgroupsthread )
//{
//	level.vehicle_unloadgroups[ self.vehicletype ] = [[ unloadgroupsthread ]]();
//}

function get_from_spawnstruct( target )
{
	return struct::get( target, "targetname" );
}

function get_from_entity( target )
{
	return getent( target, "targetname" );
}

function get_from_spawnstruct_target( target )
{
	return struct::get( target, "target" );
}

function get_from_entity_target( target )
{
	return getent( target, "target" );
}

function is_destructible()
{
	return isdefined( self.destructible_type );
}

// SCRIPTER_MOD: JesseS (5/12/200) -  readded script_vehicleattackgroup scripting
// This allows vehicles to attack other vehicles automatically. Just set the script_vehicleattackgroup of the attacker
// to the script_vehiclespawngroup you want to attack.
function attack_group_think()
{
	self endon ("death");
	self endon ("switch group");
	self endon ("killed all targets");
	
	if (isdefined (self.script_vehicleattackgroupwait))
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
			if( !isdefined( group[i].script_vehiclespawngroup ) )
			{
				continue;
			}
			// get all vehicles with the same spawngroup as the agroup we want to attack
			if (group[i].script_vehiclespawngroup == self.script_vehicleattackgroup)
			{
				// Make sure we only attack different teams vehicles
				if (group[i].team != self.team)
				{
					if ( !isdefined( valid_targets ) ) valid_targets = []; else if ( !IsArray( valid_targets ) ) valid_targets = array( valid_targets ); valid_targets[valid_targets.size]=group[i];;
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
				if( isdefined( self.fire_delay_min ) && isdefined( self.fire_delay_max ) )
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
function get_nearest_target(valid_targets)
{
	nearest_distsq = 99999999;
	nearest = undefined;
	
	for (i = 0; i < valid_targets.size; i++)
	{
		if( !isdefined( valid_targets[i] ) )
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
function debug_vehicle()
{
	self endon( "death" );

	if( GetDvarString( "debug_vehicle_health" ) == "" )
	{
		SetDvar( "debug_vehicle_health", "0" );
	}

	while( 1 )
	{
		if( GetDvarInt( "debug_vehicle_health" ) > 0 )
		{
			print3d( self.origin, "Health: " + self.health, ( 1, 1, 1 ), 1, 3 );
		}

		{wait(.05);};
	}
}

function debug_vehicle_paths()
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

		{wait(.05);};
		
		// update
		if( isdefined(self.nextNode) && self.nextNode != nextNode )
		{
			nextNode = self.nextNode;
		}
	}
}
#/

function get_dummy()
{
	if ( ( isdefined( self.modeldummyon ) && self.modeldummyon ) )
	{
		eModel = self.modeldummy;
	}
	else
	{
		eModel = self;
	}
	return eModel;
}

function add_main_callback( vehicleType, main )
{
	if ( !isdefined( level.vehicle_main_callback ) )
	{
		level.vehicle_main_callback = [];
	}
		
	/#
	if ( isdefined( level.vehicle_main_callback[ vehicleType ] ) )
	{
		PrintLn( "WARNING! Main callback function for vehicle " + vehicleType + " already exists. Proceeding with override" );
	}
	#/
		
	level.vehicle_main_callback[ vehicleType ] = main;
}

function vehicle_get_occupant_team()
{
	occupants = self GetVehOccupants();
	
	if ( occupants.size != 0 )
	{
		// first occupant defines the vehicle team
		occupant = occupants[0];
		
		if ( isplayer(occupant) )
		{
			return occupant.team;
		}
	}

	return self.team;
}

/@
"Name: toggle_exhaust_fx( <on> )"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Will toggle the vehicles exhaust fx on (1) and off (0)"
"MandatoryArg: <on> : 1 - exhaustfx on, 0 - exhaustfx off"
"Example: level.tank vehicle::toggle_exhaust_fx(0);"
"SPMP: singleplayer"
@/
function toggle_exhaust_fx( on )
{
	if(!on)
	{
		self clientfield::set( "toggle_exhaustfx", 1 );
	}
	else
	{
		self clientfield::set( "toggle_exhaustfx", 0 );
	}
}

/@
"Name: toggle_tread_fx( <on> )"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Will toggle the vehicles tread fx on (1) and off (0)"
"MandatoryArg: <on> : 1 - treadfx on, 0 - treadfx off"
"Example: level.tank toggle_tread_fx(1);"
"SPMP: singleplayer"
@/
function toggle_tread_fx( on )
{
	if(on)
	{
		self clientfield::set( "toggle_treadfx", 1 );
	}
	else
	{
		self clientfield::set( "toggle_treadfx", 0 );
	}
}

/@
"Name: toggle_sounds( <on> )"
"Module: Vehicle"
"CallOn: Vehicle"
"Summary: Will toggle the vehicle's sounds between on (1) and off (0)"
"MandatoryArg: <on> : 1 - sounds on, 0 - sounds off"
"Example: car toggle_sounds(0);"
"SPMP: singleplayer"
@/
function toggle_sounds( on )
{
	// this flag number should *NOT* be changed. if it needs to be changed, code must be updated as well.  See EF2_DISABLE_VEHICLE_SOUNDS in bg_public.h
	if(!on)
	{
		self clientfield::set( "toggle_sounds", 1 );
	}
	else
	{
		self clientfield::set( "toggle_sounds", 0 );
	}
}

/@
"Name: is_corpse( <veh> )"
"Summary: Checks to see if a vehicle is a corpse."
"CallOn: AI"
"MandatoryArg: <veh> The vehicle you're checking to see is a corpse."
"Example: if ( !is_corpse( veh_truck ) )"
"SPMP: singleplayer"
@/
function is_corpse( veh )
{
	if ( isdefined( veh ) )
	{
		if ( ( isdefined( veh.isacorpse ) && veh.isacorpse ) )
		{
			return true;
		}
		else if ( isdefined( veh.classname ) && ( veh.classname == "script_vehicle_corpse" ) )
		{
			return true;
		}
	}

	return false;
}

///@
//"Name: enter( <vehicle> )"
//"Summary: This puts the guy into the vehicle and tells him to idle."
//"Module: AI"
//"CallOn: an actor"
//"MandatoryArg: <vehicle>: the vehicle to get in"
//"Example: my_ai thread vehicle::enter(my_vehicle);"
//"SPMP: singleplayer"
//@/
//function enter( vehicle, tag ) // self == ai
//{
//	self vehicle_aianim::vehicle_enter( vehicle, tag );
//}

/@
"Name: is_on( <vehicle> )"
"Summary: Returns true if a player is on the vehicle."
"Module: Vehicle"
"CallOn: a player"
"MandatoryArg: <vehicle>: the vehicle to check against"
"Example: if( player is_on( vehicle ) )"
"SPMP: singleplayer"
@/
function is_on(vehicle) // self == player
{

	if(!isdefined(self.viewlockedentity))
	{
		return false;
	}
	else if(self.viewlockedentity == vehicle)
	{
		return true;
	}

	if(!isdefined(self.groundentity))
	{
		return false;
	}
	else if(self.groundentity == vehicle)
	{
		return true;
	}

	return false;
}

/@
"Name: add_spawn_function( <targetname>, <func> , <param1> , <param2> , <param3>, <param4> )"
"Summary: Anything that spawns from this spawner will run this function. Anything."
"MandatoryArg: <targetname> : The targetname of the vehicle."
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"Example: vehicle::add_spawn_function( "amazing_vehicle",&do_the_amazing_thing, some_amazing_parameter );"
"Note: This function must be called before load::main"
@/
function add_spawn_function( veh_targetname, spawn_func, param1, param2, param3, param4 )
{
	func = [];
	func[ "function" ] =spawn_func;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	
	if(!isdefined(level.a_vehicle_targetnames))level.a_vehicle_targetnames=[];
			
	if ( !isdefined( level.a_vehicle_targetnames[ veh_targetname ] ) ) level.a_vehicle_targetnames[ veh_targetname ] = []; else if ( !IsArray( level.a_vehicle_targetnames[ veh_targetname ] ) ) level.a_vehicle_targetnames[ veh_targetname ] = array( level.a_vehicle_targetnames[ veh_targetname ] ); level.a_vehicle_targetnames[ veh_targetname ][level.a_vehicle_targetnames[ veh_targetname ].size]=func;;
}

/@
"Name: add_spawn_function_by_type( <vehicle_type>, <func> , <param1> , <param2> , <param3>, <param4> )"
"Summary: Anything that spawns from this spawner will run this function. Anything."
"MandatoryArg: <vehicle_type> : The .vehicletype of the vehicle."
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"Example: vehicle::add_spawn_function_by_type( "tank_t72",&do_the_amazing_thing, some_amazing_parameter );"
"Note: This function must be called before load::main"	
@/
function add_spawn_function_by_type( veh_type, spawn_func, param1, param2, param3, param4 )
{	
	func = [];
	func[ "function" ] =spawn_func;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	
	if(!isdefined(level.a_vehicle_types))level.a_vehicle_types=[];
			
	if ( !isdefined( level.a_vehicle_types[ veh_type ] ) ) level.a_vehicle_types[ veh_type ] = []; else if ( !IsArray( level.a_vehicle_types[ veh_type ] ) ) level.a_vehicle_types[ veh_type ] = array( level.a_vehicle_types[ veh_type ] ); level.a_vehicle_types[ veh_type ][level.a_vehicle_types[ veh_type ].size]=func;;
}

/@
"Name: add_hijack_function( <targetname>, <func> , <param1> , <param2> , <param3>, <param4> )"
"Summary: Runs when a vehicle gets hijacked/hacked with 'security breach'."
"MandatoryArg: <targetname> : The targetname of the vehicle."
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"Example: vehicle::add_hijack_function( "amazing_vehicle", &do_the_amazing_thing, some_amazing_parameter );"
"Note: This function must be called before load::main"
@/
function add_hijack_function( veh_targetname, spawn_func, param1, param2, param3, param4 )
{
	func = [];
	func[ "function" ] =spawn_func;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	
	if(!isdefined(level.a_vehicle_hijack_targetnames))level.a_vehicle_hijack_targetnames=[];
	
	if ( !isdefined( level.a_vehicle_hijack_targetnames[ veh_targetname ] ) ) level.a_vehicle_hijack_targetnames[ veh_targetname ] = []; else if ( !IsArray( level.a_vehicle_hijack_targetnames[ veh_targetname ] ) ) level.a_vehicle_hijack_targetnames[ veh_targetname ] = array( level.a_vehicle_hijack_targetnames[ veh_targetname ] ); level.a_vehicle_hijack_targetnames[ veh_targetname ][level.a_vehicle_hijack_targetnames[ veh_targetname ].size]=func;;
}

function private _watch_for_hijacked_vehicles()
{
	while ( true )
	{
		level waittill( "ClonedEntity", clone );
		
		str_targetname = clone.targetname;
		if (isdefined( str_targetname ) && StrEndsWith( str_targetname, "_ai" ) )
		{
			str_targetname = GetSubStr( str_targetname, 0, str_targetname.size - 3 );
		}
		
		waittillframeend;

		if ( isdefined( str_targetname ) && isdefined( level.a_vehicle_hijack_targetnames ) && isdefined( level.a_vehicle_hijack_targetnames[ str_targetname ] ) )
		{
			foreach ( func in level.a_vehicle_hijack_targetnames[ str_targetname ] )
			{
				util::single_thread( clone, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ] );
			}				
		}
	}
}

/#
function vehicle_spawner_tool()
{
	allvehicles = GetEntArray( "script_vehicle", "classname" );
	
	vehicletypes = [];
	
	foreach( veh in allvehicles )
	{
		vehicletypes[ veh.vehicletype ] = veh.model;
	}
	
	if( IsAssetLoaded( "vehicle", "civ_pickup_mini" ) )
	{
		veh = SpawnVehicle( "civ_pickup_mini", (0,0,10000), (0,0,0), "debug_spawn_vehicle" );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	if( IsAssetLoaded( "vehicle", "atv" ) )
	{
		veh = SpawnVehicle( "atv", (0,0,10000), (0,0,0), "debug_spawn_vehicle" );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	if( IsAssetLoaded( "vehicle", "prowler_quad" ) )
	{
		veh = SpawnVehicle( "prowler_quad", (0,0,10000), (0,0,0), "debug_spawn_vehicle" );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	if( IsAssetLoaded( "vehicle", "rc_car_racer" ) )
	{
		veh = SpawnVehicle( "rc_car_racer", (0,0,10000), (0,0,0), "debug_spawn_vehicle" );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	if( IsAssetLoaded( "vehicle", "jeep_fav_player" ) )
	{
		veh = SpawnVehicle( "jeep_fav_player", (0,0,10000), (0,0,0), "debug_spawn_vehicle" );
		vehicletypes[ veh.vehicletype ] = veh.model;
		veh Delete();
	}
	
	types = getArrayKeys( vehicletypes );
	
	if( types.size == 0 )
		return;
	
	type_index = 0;
	
	while( 1 )
	{
		if( GetDvarInt( "debug_vehicle_spawn" ) > 0 )
		{
			player = GetPlayers()[0];
			
			dynamic_spawn_hud = NewClientHudElem( player );
			dynamic_spawn_hud.alignX = "left";
			dynamic_spawn_hud.x = 20;
			dynamic_spawn_hud.y = 395;
			dynamic_spawn_hud.fontscale = 2;
			
			dynamic_spawn_dummy_model = sys::Spawn( "script_model", (0,0,0) );
			
			const waittime = 0.3;
			
			while( GetDvarInt( "debug_vehicle_spawn" ) > 0 )
			{
				origin = player.origin + AnglesToForward( player getPlayerAngles() ) * 270.0;
				origin += (0,0,40);
				
				if( player UseButtonPressed() )
				{	
					dynamic_spawn_dummy_model Hide();
					vehicle = SpawnVehicle( types[type_index], origin, player.angles, "debug_spawn_vehicle" );
					vehicle MakeVehicleUsable();
					
					if( GetDvarInt( "debug_vehicle_spawn" ) == 1 )
					{
						SetDvar( "debug_vehicle_spawn", "0" );
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
				{wait(.05);};
			}
			
			dynamic_spawn_hud destroy();
			dynamic_spawn_dummy_model delete();
		}
		
		wait 2;
	}
}

function spline_debug()
{
	level flag::init( "debug_vehicle_splines" );
	
	level thread _spline_debug();
	
	while ( true )
	{
		level flag::set_val( "debug_vehicle_splines", GetDvarInt( "g_vehicleDrawSplines" ) );
		wait .05;
	}
}

function _spline_debug()
{
	while ( true )
	{
		level flag::wait_till( "debug_vehicle_splines" );
		
		foreach ( nd in GetAllVehicleNodes() )
		{
			nd show_node_debug_info();
		}
		
		wait .05;
	}
}

function show_node_debug_info()
{
	self.n_debug_display_count = 0;
	
	if ( is_unload_node() )
	{
		print_debug_info( "unload: \"" + self.script_unload + "\"" );
	}
	
	if ( isdefined( self.script_notify ) )
	{
		print_debug_info( "notify: \"" + self.script_notify + "\"" );
	}
	
	if ( ( isdefined( self.script_delete ) && self.script_delete ) )
	{
		print_debug_info( "delete" );
	}
}

function print_debug_info( str_info )
{
	self.n_debug_display_count++;
	Print3D( self.origin - ( 0, 0, self.n_debug_display_count * 20 ), str_info, ( 0, 0, 1 ), 1, 1 );
}

#/
