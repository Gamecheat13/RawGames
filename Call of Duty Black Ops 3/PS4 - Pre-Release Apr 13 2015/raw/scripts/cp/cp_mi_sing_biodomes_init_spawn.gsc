/*=============================================================================
SCRIPT SETUP:
- in your main level file, add this line: 
#using scripts\cp\sidemissions\_sm_initial_spawns;
=============================================================================*/

#using scripts\codescripts\struct;

#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace sm_initial_spawns;	

function autoexec __init__sytem__() {     system::register("sm_initial_spawns",&__init__,&__main__,undefined);    }
	
function __init__()
{
	//level flag::init( "sm_combat_started" );
	
	//level.using_awareness = 1;  
}

function __main__()
{
//	level thread spawn_sidemission_guys();
	level thread sm_infil_zone_setup();
}

// call this to spawn in guys at level start
//function spawn_sidemission_guys( a_types )
//{
//	a_spawners = get_sm_spawners();
//	a_spawn_locations = struct::get_array( "sm_initial_spawn", "targetname" );
//	a_spawner_types = GetArrayKeys( a_spawners );
//
//	foreach ( spawn_struct in a_spawn_locations )
//	{
//		// do we need a specific spawner?
//		str_type = spawn_struct.script_noteworthy;
//
//		if ( IsDefined( str_type ) )
//		{
//			a_valid_spawners = a_spawners[ str_type ];
//		}
//		else 
//		{
//			str_random_type = array::random( a_spawner_types );
//			a_valid_spawners = a_spawners[ str_random_type ];
//		}
//		
//		spawner_temp = array::random( a_valid_spawners );
//		
//		ai_temp = spawner::simple_spawn( spawner_temp, &sm_axis_initial_spawn_func, spawn_struct );
//	}
//}

function sm_axis_initial_spawn_func( spawn_struct )  // self = AI
{
	self endon( "death" );
	
	//manual wait until awareness system setup
	wait(1);
	if ( !level flag::get( "sm_combat_started" ) )
	{
		//while( !self ai::is_awareness_combat() )
		{
			wait RandomFloatRange( 0.5, 1.0 );
		}
		
		level flag::set( "sm_combat_started" );
	}
}

//function move_to_spawn_location( spawn_struct )
//{	
//	if ( !IsDefined( spawn_struct.angles ) )
//	{
//		spawn_struct.angles = ( 0, 0, 0 );
//	}
//	
//	self ForceTeleport( spawn_struct.origin, spawn_struct.angles );
//	
//	self ai::update_start_position( spawn_struct.origin, spawn_struct.angles );
//}

// run this function to start wave spawning when infil guys go into combat
function start_wave_spawning_on_combat()
{
	level waittill( "sm_combat_started" );  // this notify can come from flag or scripted event
	
}

//function get_sm_spawners()
//{	
//	a_spawners = [];
//	
//	foreach ( spawner in GetEntArray( "enemy_spawner", "targetname" ) )
//	{
//		str_type = spawner.script_noteworthy;
//		
//		Assert( IsDefined( str_type ), "get_sm_spawners found spawner without script_noteworthy at " + spawner.origin + "! This is required to define enemy type." );
//		
//		if ( !IsDefined( a_spawners[ str_type ] ) )
//		{
//			a_spawners[ str_type ] = [];
//		}
//		
//		ARRAY_ADD( a_spawners[ str_type ], spawner );
//	}
//	
//	return a_spawners;
//}

function sm_infil_zone_setup()
{
	//TODO behavior tree error.. need AI fix.
	wait(1);
	
	a_infil_zones = struct::get_array( "infil_manager", "targetname" );
	
	foreach( zone in a_infil_zones )
	{
		zone infil_zone_selection();
	}
	
}

function infil_zone_selection()
{
	a_volume_list = getentarray( self.target, "targetname" );
	
 	Assert( a_volume_list.size != 0, "There are infil spawn manager not pointing to anything." );
 	
 //	s_sm_volume = get_infil_activity( a_volume_list );

	
 	
 	//if( isdefined( a_volume_list ) )
 	//{
 	a_volume_list[0] thread spawn_infil_zones();
 	//}
}

function get_infil_activity( a_volume_list )
{
	for(i = 0; i < a_volume_list.size; i++ )
 	{
		
		//if activity manager's script_string matchup with gametype
		if( isdefined( a_volume_list[i].script_noteworthy ) && isdefined( level.gameType ))
		{
			if( a_volume_list[i].script_noteworthy == level.gameType )
			{
				s_spawn_manager = a_volume_list[i];
			}
			else
			{
				a_volume_list[i] infil_clean_up();
				array::remove_index(a_volume_list, i, true);
			}
		}
	}
	
	if( a_volume_list.size == 0)
	{
		return;
	}
	
	
	if( !isdefined( s_spawn_manager ) )
	{
		s_spawn_manager = array::random( a_volume_list );
	}
	
	foreach( volume in a_volume_list )
 	{
		if( volume != s_spawn_manager )
		{
			volume infil_clean_up();
		}
	}
	
	return s_spawn_manager;
		
}

function spawn_infil_zones()
{
	while(1)
	{
		self waittill( "trigger", ent );
		
		if(isdefined(ent.sessionstate) && ent.sessionstate != "spectator" )
		{
			break;	
		}
		
		{wait(.05);};
	}
	target = self.target;
	
	a_entities = getentarray( target, "targetname" );
	
	Assert( a_entities.size != 0, "There are infil zone manager not pointing to anything." );
	
	s_handler = self;
	
	//TODO: change this wait to a more permanent solution
	wait 1;	// With no wait, the awareness system might not be fully initialized
	
	foreach( entity in a_entities )
	{
		if( IsSpawner( entity ) && !isdefined( level._infil_actor_off ) && isdefined( s_handler ) )
		{
			entity handle_role_assignment( s_handler );
		}
	}
	
	self notify( "infil_spawn_complete" );
}
function handle_role_assignment( handler_struct )
{
	
	defend_volume = getent( "street_battle_volume", "targetname");
	//Assert( isDefined( self.script_noteworthy ), "Infil actor spawner need a script noteworthy indicate it's awareness." );
	
	if( isdefined( level.free_targeting ) || isdefined( level.target_volume ) )
	{
		if( isdefined( self.script_noteworthy ) && self.script_noteworthy != "wasp_swarm" && self.script_noteworthy != "hunter_swarm"  )
		{
			self.target = undefined;
		}
	}

	
	if( !isdefined( self.script_noteworthy ) )
	{
		camp_guard = spawner::simple_spawn_single( self );
	
		if( isdefined( level.target_volume ) && isActor( camp_guard ) )
		{
			camp_guard SetGoal( defend_volume );
		}

		return;
	}

	if( self.script_noteworthy == "wasp_swarm" )
	{
		
		self thread wasp_swarm_logic();
		return;
	}
	
	if( self.script_noteworthy == "hunter_swarm" )
	{
		
		self thread hunter_swarm_logic();
		return;
	}
	
	camp_guard = spawner::simple_spawn_single( self );
	
	
	
	
	if( self.script_noteworthy == "patrol" )
	{
		camp_guard thread infil_patrol_logic( self.target );
	}
	else if( self.script_noteworthy == "defend" )
	{
		if(isdefined( camp_guard.target ) )
		{
			
		}
		else
		{
			
		}
	}
	else if( self.script_noteworthy == "guard" )
	{
		if(isdefined( camp_guard.target ) )
		{
			
		}
		else
		{
			
		}
	}
	else if( self.script_noteworthy == "scene" )
	{
		camp_guard thread script_scene_setup( self, handler_struct );
	}
	
}

function wasp_swarm_logic()
{
	
	path_start = GetVehicleNode( self.target, "targetname" );
	
	offset = (0, 60, 0);
	
	for( i=0; i < self.script_int; i++ )
	{
		wasp = spawner::simple_spawn_single( self );
		wasp thread handle_spline( path_start, i );
	}
	
	
}

function hunter_swarm_logic()
{
	path_start = GetVehicleNode( self.target, "targetname" );
	
	hunter = spawner::simple_spawn_single( self );

	hunter vehicle_ai::start_scripted();
	hunter vehicle::get_on_path( path_start );
	hunter.drivepath = true;
	hunter vehicle::go_path();
	//hunter vehicle_ai::SetGoal( level.players[0], false, 1000 );
	hunter Setgoal( level.players[0], false, 1000 );
	hunter vehicle_ai::stop_scripted();
	hunter.lockOnTarget = level.players[0];
	

	
}

function handle_spline( path_start, index )
{
	offset = (0, 30, 0);
		
	self vehicle_ai::start_scripted();
	self vehicle::get_on_path( path_start );
	self.drivepath = true;
	offset_scale = get_offset_scale( index );
	self PathFixedOffset( offset * offset_scale );
	self vehicle::go_path();
	//self vehicle_ai::SetGoal( level.players[0], false, 600, 150, (0, 0, 75) );
	self SetGoal( level.players[0], false, 600, 150 );
	self vehicle_ai::stop_scripted();
	self.lockOnTarget = level.players[0];
	
}

function get_offset_scale( i )
{
	if( i % 2 == 0 )
	{
		return -(i / 2);
	}
	else
	{
		return i - (i/2) + 0.5;
	}
}

function infil_patrol_logic( str_start_node )
{
	self endon("death");
	
	
	
	while(1)
	{
		self waittill( "patrol_wp_reached", node );
		
		if( isdefined( node.script_wait ) || ( isdefined( node.script_wait_min ) && isdefined( node.script_wait_max ) ) )
		{
			//self ai::stop_patrol();
			node util::script_wait();
			//self ai::start_patrol();
		}
		
	}
	
}

function script_scene_setup( align_node, handler_struct )
{
	
	if( isdefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );
		
		if(	isdefined( node ) )
		{
			
		}
		else
		{
			defend_volume = GetEnt( self.target, "targetname" );
			
			if( isdefined( defend_volume ) )
			{
				
			}
		}
	}
	else
	{
		
		
		if( isdefined( handler_struct.height ) )
		{
			self.goalheight = handler_struct.height;
		}
		if( isdefined( handler_struct.radius ) )
		{
			self.goalradius = handler_struct.radius;
		}
	}
	
	
	//waiting for behavior tree to be fully working before playing scene.
	{wait(.05);};
	
	Assert( isDefined( self.script_string ), "Infil Actor who are playing a scene needs to have scene handle as part of it's script string." );
	align_node thread scene::init( self.script_string, self );
	

}

function infil_clean_up()
{
	a_entities = getentarray( self.target, "targetname" );	
	
	foreach( entity in a_entities )
	{
		//check to see if it's a spawner or model.
		if( IsSpawner( entity ) )
		{
			entity delete();
		}
		else 
		{
			//check to see if the model points to any nodes, if so. disable the nodes and then delete the model.
			
			if( isdefined( entity.target ) )
			{
				nd_cover_nodes = GetNodeArray( entity.target, "targetname" );
				foreach( node in nd_cover_nodes )
				{
					SetEnableNode( node, false );
				}
			}
			entity ConnectPaths();
			entity delete();
		}
	}
	
	self delete();
}
	
function kill_infil_actor_spawn()
{
	if( !isdefined( level._infil_actor_off ) )
	{
		level._infil_actor_off = true;
	}
	
}
