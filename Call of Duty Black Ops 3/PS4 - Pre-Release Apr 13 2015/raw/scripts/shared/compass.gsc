
#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#namespace containers;





class cContainer
{
	var	m_s_container_bundle;
	var m_s_fxanim_bundle;

	var m_s_container_instance;
	
	var m_e_container;						// Container Ent
	
	constructor()
	{
	}

	destructor()
	{
	}

	function init_xmodel( str_xmodel, v_origin, v_angles )
	{
		if( !IsDefined(str_xmodel) )
		{
			str_xmodel = "script_origin";
			//ASSERTMSG( "No model found in Container Script Bundle" );
			//return;
		}

		m_e_container = util::spawn_model( str_xmodel, v_origin, v_angles );
		return( m_e_container );
	}
}


//*****************************************************************************
//*****************************************************************************

function autoexec __init__sytem__() {     system::register("containers",&__init__,undefined,undefined);    }

function __init__()
{	
	a_containers = struct::get_array( "scriptbundle_containers", "classname" );		// "_containers" auto generates from the TYPE field in the bundle
	foreach ( s_instance in a_containers )
	{
		c_container = s_instance init();
		if( IsDefined(c_container) )
		{
			s_instance.c_container = c_container;
		}
	}
}


//*****************************************************************************
//*****************************************************************************
// Setup Container Instances
//*****************************************************************************
//*****************************************************************************

// self = container instance
function init()
{	
	if( !IsDefined(self.angles) )
	{	
		self.angles = ( 0, 0 ,0 );
	}
		
	s_bundle = struct::get_script_bundle( "containers", self.scriptbundlename );

	return setup_container_scriptbundle( s_bundle, self );
}


//*****************************************************************************
//*****************************************************************************

// self = container bundle
function setup_container_scriptbundle( s_bundle, s_container_instance )
{
	c_container = new cContainer();

	c_container.m_s_container_bundle = s_bundle;														// Container bundle
	c_container.m_s_fxanim_bundle = struct::get_script_bundle( "scene", s_bundle.TheEffectBundle );		// Get fxanim bundle
	c_container.m_s_container_instance = s_container_instance;

	// Setup
	//[[ c_container ]]->init_xmodel( c_container.m_s_container_bundle.model, s_container_instance.origin, s_container_instance.angles );

	// The init function makes the container appear...
	self scene::init( s_bundle.theeffectbundle, c_container.m_e_container );
	
	level thread container_update( c_container );

	return( c_container );
}


//*****************************************************************************
//*****************************************************************************

// Problems:-
// - im playing the scene on the bundle not the instance
// - whats the best way to spawn the ent, i'm currently spawning two ents
// - what do i play the notify on for the pickup etc......
// - can I get the ent back from the scene::play?
// DOES IT WORK WITH TWO SCRIPTBUNDLES OF THE SAME TYPE?????

// NOTE - DONT FORGET TO SET "auto-run" KVP to init

// self = level
function container_update( c_container )
{
	e_ent = c_container.m_e_container;

//#if 0
//	//wait( 10 );
//	//level thread scene::play( c_container.m_s_container_bundle.theeffectbundle, e_ent );
//	//c_container.m_s_container_bundle.theeffectbundle thread scene::play( c_container.m_s_container_bundle.theeffectbundle, e_ent );
//	//c_container.m_e_container scene::play( c_container.m_s_fxanim_bundle.name );
//	//level thread scene::play( "test_container_bundle", "targetname" );
//	//wait( 1000 );
//#endif

	
	s_bundle = c_container.m_s_container_bundle;

 	targetname = c_container.m_s_container_instance.targetname;


//#if 0
//	//self scene::init( c_container.m_s_container_bundle );
//	
//	wait( 1000 );
//	//self scene::play( c_container.m_s_container_bundle );
//	//wait( 1000 );
//
//	// Store the container class on the entity
//	//	e_ent.c_container = c_container;
//
//	if( IsDefined(s_bundle.loot_offset_x) )
//	{
//		v_loot_offset = ( s_bundle.loot_offset_x, s_bundle.loot_offset_y, s_bundle.loot_offset_z );
//	}
//	else
//	{
//		v_loot_offset = ( 0, 0, 0 );
//	}
//#endif
	
	// Wait fot the container to be opened
	n_radius = s_bundle.trigger_radius;
	e_trigger = containers::create_locker_trigger( c_container.m_s_container_instance.origin, n_radius, "Press [{+activate}] to open" );
	e_trigger waittill( "trigger", e_who );
	e_trigger delete();
	
	
	scene::play( targetname, "targetname" );
	
	// Play the open animation - from the containers fxanim bundle
	//c_container.m_e_container scene::play( c_container.m_s_fxanim_bundle.name );
	
	// ERROR - using a scene name 'container_pickup_medium' that doesn't exist.
	//level thread scene::play( "test_container_bundle", "targetname" );
	

	// Notify script the container has been opened
	// You can use a targetname on the container if you want to grab this instance and spawn a model inside
	//e_ent notify(s_bundle.open_notify );
}


//*****************************************************************************
//*****************************************************************************

function create_locker_trigger( v_pos, n_radius, str_message )
{
	// Its a look at trigger, so move the base of the trigger off the ground
	v_pos = ( v_pos[0], v_pos[1], v_pos[2]+50 );

	e_trig = spawn( "trigger_radius_use", v_pos, 0, n_radius, 100 );
	e_trig TriggerIgnoreTeam();

	e_trig SetVisibleToAll();
	e_trig SetTeamForTrigger( "none" );
	e_trig UseTriggerRequireLookAt();
	e_trig SetCursorHint( "HINT_NOICON" );
	e_trig SetHintString( str_message );

	return( e_trig );
}


//*****************************************************************************
//*****************************************************************************
// General purpose locker bundles
//*****************************************************************************
//*****************************************************************************

function setup_general_container_bundle( str_targetname, str_intel_vo, str_narrative_collectable_model, force_open )
{
	s_struct = struct::get( str_targetname, "targetname" );
	if( !IsDefined(s_struct) )
	{
		return;
	}

	//level thread doors::door_debug_line( s_struct.origin );

	//level waittill( "prematch_over" );
	//level flag::wait_till( "start_coop_logic" ); 
	//level flag::wait_till( "all_players_connected" );
	level flag::wait_till( "all_players_spawned" );

	e_trigger = containers::create_locker_trigger( s_struct.origin, 64, "Press [{+activate}] to open" );
	if( !IsDefined(force_open) || (force_open == false) )		// Force locker into open state?
	{
		e_trigger waittill( "trigger", e_who );
	}
	else
	{
		// TODO: Why is this wait needed, without the anim doesn't play
		rand_time = RandomFloatRange( 1.0, 1.5 );
		wait( rand_time );
	}
	
	e_trigger delete();

	// Open the container lid
	level thread scene::play( str_targetname , "targetname" );

	// Notify the scene entities
	if( IsDefined(s_struct.a_entity) )
	{
		for( i=0; i<s_struct.a_entity.size; i++ )
		{
			s_struct.a_entity[i] notify( "opened" );
		}
	}

	// If we have a narrative collectable, wait for the player to pick it up
	if( IsDefined(str_narrative_collectable_model) )
	{
		v_pos = s_struct.origin + ( 0, 0, 30 );

		if( !IsDefined(s_struct.angles) )
		{
			v_angles = ( 0, 0, 0 );
		}
		else
		{
			v_angles = s_struct.angles;
		}

		v_angles = ( v_angles[0], v_angles[1]+90, v_angles[2] );
		
		e_collectable = spawn( "script_model", v_pos );
		e_collectable setModel( "p7_int_narrative_collectable" );
		e_collectable.angles = v_angles;
	
		wait( 1 );
		
		e_trigger = containers::create_locker_trigger( s_struct.origin, 64, "Press [{+activate}] to pickup collectable" );
		e_trigger waittill( "trigger", e_who );
		e_trigger delete();

		e_collectable delete();
	}

	if( IsDefined(str_intel_vo) )
	{
		e_who PlaySound( str_intel_vo );
	}
}


//*****************************************************************************
//*****************************************************************************
// General purpose locked scripts
//*****************************************************************************
//*****************************************************************************

function setup_locker_double_doors( str_left_door_name, str_right_door_name, center_point_offset )
{
	// Get all the left door instances
	a_left_doors = getentarray( str_left_door_name, "targetname" );
	if( !IsDefined(a_left_doors) )
	{
		return;
	}

	// Get all the right door instances
	a_right_doors = getentarray( str_right_door_name, "targetname" );
	if( !IsDefined(a_right_doors) )
	{
		return;
	}
	
	// For each left door instance
	// - Find the closest right door instance, - link them, create an activation trigger
	for( i=0; i<a_left_doors.size; i++ )
	{
		e_left_door = a_left_doors[i];

		if( IsDefined(center_point_offset) )
		{
			v_forward = AnglesToForward( e_left_door.angles );
			v_search_pos = e_left_door.origin + ( v_forward * center_point_offset );
		}
		else
		{
			v_search_pos = e_left_door.origin;
		}

		e_right_door = get_closest_ent_from_array( v_search_pos, a_right_doors );
		level thread create_locker_doors( e_left_door, e_right_door, 120, 0.4 );
	}
}


//*****************************************************************************
//*****************************************************************************

function get_closest_ent_from_array( v_pos, a_ents )
{
	e_closest = undefined;
	n_closest_dist = 9999999;

	for( i=0; i<a_ents.size; i++ )
	{
		dist = distance( v_pos, a_ents[i].origin );
		if( dist < n_closest_dist )
		{
			n_closest_dist = dist;
			e_closest = a_ents[i];
		}
	}

	return( e_closest );
}


//*****************************************************************************
//*****************************************************************************

function create_locker_doors( e_left_door, e_right_door, door_open_angle, door_open_time )
{
	// Locker door trigger
	v_locker_pos = ( e_left_door.origin + e_right_door.origin ) / 2;
	n_trigger_radius = 48;
	e_trigger = create_locker_trigger( v_locker_pos, n_trigger_radius, "Press [{+activate}] to open" );
	e_trigger waittill( "trigger" );


	e_left_door playsound( "evt_cabinet_open" );
	
	// Open the locker
	v_angle = ( e_left_door.angles[0], e_left_door.angles[1]-door_open_angle, e_left_door.angles[2] );
	e_left_door RotateTo( v_angle, door_open_time );
	v_angle = ( e_right_door.angles[0], e_right_door.angles[1]+door_open_angle, e_right_door.angles[2] );
	e_right_door RotateTo( v_angle, door_open_time );

	// Cleanup
	e_trigger delete();
}


