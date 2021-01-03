#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#precache( "material", "compass_waypoint_target" );
#precache( "material", "compass_waypoint_captureneutral" );
#precache( "material", "compass_waypoint_capture" );
#precache( "material", "compass_waypoint_defend" );
#precache( "material", "compass_waypoint_captureneutral_a" );
#precache( "material", "compass_waypoint_capture_a" );
#precache( "material", "compass_waypoint_defend_a" );
#precache( "material", "compass_waypoint_captureneutral_b" );
#precache( "material", "compass_waypoint_capture_b" );
#precache( "material", "compass_waypoint_defend_b" );
#precache( "material", "compass_waypoint_captureneutral_c" );
#precache( "material", "compass_waypoint_capture_c" );
#precache( "material", "compass_waypoint_defend_c" );
#precache( "material", "compass_waypoint_captureneutral_d" );
#precache( "material", "compass_waypoint_capture_d" );
#precache( "material", "compass_waypoint_defend_d" );
#precache( "material", "compass_waypoint_captureneutral_e" );
#precache( "material", "compass_waypoint_capture_e" );
#precache( "material", "compass_waypoint_defend_e" );

#precache( "material", "waypoint_targetneutral" );
#precache( "material", "waypoint_captureneutral" );
#precache( "material", "waypoint_capture" );
#precache( "material", "waypoint_defend" );
#precache( "material", "waypoint_captureneutral_a" );
#precache( "material", "waypoint_capture_a" );
#precache( "material", "waypoint_defend_a" );
#precache( "material", "waypoint_captureneutral_b" );
#precache( "material", "waypoint_capture_b" );
#precache( "material", "waypoint_defend_b" );
#precache( "material", "waypoint_captureneutral_c" );
#precache( "material", "waypoint_capture_c" );
#precache( "material", "waypoint_defend_c" );
#precache( "material", "waypoint_captureneutral_d" );
#precache( "material", "waypoint_capture_d" );
#precache( "material", "waypoint_defend_d" );
#precache( "material", "waypoint_captureneutral_e" );
#precache( "material", "waypoint_capture_e" );
#precache( "material", "waypoint_defend_e" );
#precache( "material", "waypoint_return" );
#precache( "material", "objective_arrow" );

#precache( "eventstring", "comms_event_message" );




#precache( "lui_menu_data", "obj_x" );
#precache( "lui_menu_data", "obj_y" );

#namespace objectives;
	
class cObjective
{
	var m_str_type;
	var m_a_game_obj;
	var m_a_targets;
	var m_str_lui_menu;
	
	constructor()
	{
	}
	
	function init( str_type, a_target_list, b_done = false )
	{
		m_a_targets = [];
		m_a_game_obj = [];
		m_str_type = str_type;
		
		if ( b_done )
		{
			gobj_id = gameobjects::get_next_obj_id();
			m_a_game_obj = array( gobj_id );
			Objective_Add( gobj_id, "done", (0,0,0), iString(str_type) );
		}
		else
		{
			if ( isdefined( a_target_list ) && a_target_list.size > 0 )
			{
				foreach( target in a_target_list )
				{
					add_target( target );
				}
			}
			else
			{
				gobj_id = gameobjects::get_next_obj_id();
				m_a_game_obj = array( gobj_id );
				Objective_Add( gobj_id, "active", (0,0,0), iString(str_type) );
			}
		}
	}
	
	function update_value( str_menu_data_name, value )
	{
		gobj_id = m_a_game_obj[0];
		Objective_SetUIModelValue( gobj_id, str_menu_data_name, value );
	}
	
	function update_counter( x_val, y_val )
	{
		update_value( "obj_x", x_val );
		
		if ( isdefined( y_val ) )
		{
			update_value( "obj_y", y_val );
		}
	}
	
	function set_target( target )
	{
		gobj_id = m_a_game_obj[0];
		if ( IsVec( target ) )
		{
			Objective_Position( gobj_id, target );
		}
		else
		{
			Objective_Position( gobj_id, target.origin );
		}
		
		m_a_targets[0] = target;
	}
	
	function add_target( target )
	{
		// do not add a target twice.
		if ( IsInArray( m_a_targets, target ) )
		{
			return;
		}
		
		gobj_id = undefined;
		if ( m_a_targets.size < m_a_game_obj.size )
		{
			gobj_id = m_a_game_obj[m_a_game_obj.size-1];
		}
		else
		{
			gobj_id = gameobjects::get_next_obj_id();
			array::add( m_a_game_obj, gobj_id );
		}
		
		//Objective_Add can take in an entity or a vector for its 'target'
		if ( IsVec( target ) || IsEntity( target ) )
		{
			Objective_Add( gobj_id, "active", target, iString(m_str_type) );
		}
		else
		{
			Objective_Add( gobj_id, "active", target.origin, iString(m_str_type) );
		}
		
		array::add( m_a_targets, target );
		
		assert( m_a_targets.size == m_a_game_obj.size );
	}
	
	function complete( a_target_or_list )
	{
		if ( a_target_or_list.size > 0 )
		{
			// find specific targets to remove their objective
			foreach ( target in a_target_or_list )
			{
				for ( i = 0; i < m_a_targets.size; i++ )
				{
					if ( m_a_targets[i] == target )
					{
						objective_state( m_a_game_obj[i], "done" );
						ArrayRemoveIndex( m_a_game_obj, i );
						ArrayRemoveIndex( m_a_targets, i );
						break;
					}
				}
			}
		}
		else
		{
			// TODO Slone: Clear target data at this point?
			foreach( n_gobj_id in m_a_game_obj )
			{
				objective_state( n_gobj_id, "done" );
			}
		}
	}
	
	//hide waypoint
	function hide( e_player )
	{
		if(isdefined( e_player) )
		{
			Assert( IsPlayer( e_player ), "Passed a non-player entity into cObjective::hide()" );
			
			foreach( obj_id in m_a_game_obj )
			{
				Objective_SetInvisibleToPlayer( obj_id, e_player );
			}
		}
		else
		{
			foreach( obj_id in m_a_game_obj )
			{
				Objective_SetInvisibleToAll( obj_id );
			}	
		}
	}
	
	//show waypoint
	function show( e_player )
	{
		if(isdefined( e_player) )
		{
			Assert( IsPlayer( e_player ), "Passed a non-player entity into cObjective::show()" );
			
			foreach( obj_id in m_a_game_obj )
			{
				Objective_SetVisibleToPlayer( obj_id, e_player );
			}
		}
		else
		{
			foreach( obj_id in m_a_game_obj )
			{
				Objective_SetVisibleToAll( obj_id );
			}	
		}
	}
	
	function hide_for_target( e_target )
	{
		foreach( i, obj_id in m_a_game_obj )
		{
			ent = m_a_targets[i];
			if ( isdefined( ent ) && ent == e_target )
			{
				Objective_State( obj_id, "invisible" );
				return;
			}
		}
	}
	
	function show_for_target( e_target )
	{
		foreach( i, obj_id in m_a_game_obj )
		{
			ent = m_a_targets[i];
			if ( isdefined( ent ) && ent == e_target )
			{
				Objective_State( obj_id, "active" );
				return;
			}
		}
	}
}

function autoexec __init__sytem__() {     system::register("objectives",&__init__,undefined,undefined);    }

function __init__()
{
	level.a_objectives = [];	// Declares an array of objectives to hold the objective strings.
	level.n_obj_index = 0;	// This is the objective number associated with the objective strings.
}

/@
"Name: set( <str_obj_type>, <a_target_or_list> )"
"Summary: Used for all objective-related tasks."
"CallOn: NA"
"Example: objectives::set( "cp_level_lotus_hakim", level.ai_hakim );"
"SPMP: singleplayer"
@/
function set( str_obj_type, a_target_or_list )
{
	if(!isdefined(level.a_objectives))level.a_objectives=[];
	
	// Make an array out if it, if it's only one objective.
	if ( !isdefined( a_target_or_list ) ) a_target_or_list = []; else if ( !IsArray( a_target_or_list ) ) a_target_or_list = array( a_target_or_list );;
	
	o_objective = undefined;
	if ( isdefined( level.a_objectives[str_obj_type] ) )
	{
		// TODO Slone: Clear old targets here?
		o_objective = level.a_objectives[str_obj_type];
		if ( isdefined( a_target_or_list ) )
		{
			foreach( target in a_target_or_list )
			{
				[[o_objective]]->add_target( target );
			}
		}
	}
	else
	{
		o_objective = new cObjective();
		[[o_objective]]->init( str_obj_type, a_target_or_list );
		level.a_objectives[ str_obj_type ] = o_objective;
	}
	
	return o_objective;
}

// Mark just one of many targets for this objective as complete.
//
// str_obj_type: the objective string ID we'd like to remove.
// a_target_or_list: the object from which we'd like to remove the marker.
//
/@
"Name: complete( <str_obj_type>, <a_target_or_list> )"
"Summary: Mark specific targets for this objective as complete."
"CallOn: NA"
"MandatoryArg: <str_obj_type> The objective string ID we'd like to remove."
"OptionalArg: <a_target_or_list> The target or targets from which we'd like to remove the marker."
"Example: objectives::complete( "cp_level_lotus_minigun", self );"
"SPMP: singleplayer"
@/
function complete( str_obj_type, a_target_or_list )
{
	// Make an array out if it, if it's only one objective.
	if ( !isdefined( a_target_or_list ) ) a_target_or_list = []; else if ( !IsArray( a_target_or_list ) ) a_target_or_list = array( a_target_or_list );;
	
	if ( isdefined( level.a_objectives[str_obj_type] ) )
	{
		o_objective = level.a_objectives[str_obj_type];
		[[o_objective]]->complete( a_target_or_list );
	}
	else
	{
		o_objective = new cObjective();
		[[o_objective]]->init( str_obj_type, undefined, true );
		level.a_objectives[ str_obj_type ] = o_objective;
	}
}

/@
"Name: set( <str_obj_id>, <a_target_or_list> )"
"Summary: Set the objective and automatically set the counter to [0 of a_targets.size]"
"CallOn: NA"
"Example: objectives::set( "objective_kill_targets", a_targets );"
"SPMP: singleplayer"
@/
function set_with_counter( str_obj_id, a_targets )
{
	if ( !isdefined( a_targets ) ) a_targets = []; else if ( !IsArray( a_targets ) ) a_targets = array( a_targets );;
	o_obj = set( str_obj_id, a_targets );
	[[o_obj]]->update_counter( 0, a_targets.size );
}

/@
"Name: update_counter( <str_obj_id>, <x_val>, <y_val> )"
"Summary: Set the values on an objective with a counter."
"CallOn: NA"
"Example: objectives::update_counter( "objective_kill_targets", 2, a_targets.size );"
"SPMP: singleplayer"
@/
function update_counter( str_obj_id, x_val, y_val )
{
	o_obj = level.a_objectives[ str_obj_id ];
	if ( isdefined( o_obj ) )
	{
		[[o_obj]]->update_counter( x_val, y_val );
	}
}

/@
	"Name: set_value( <str_obj_id>, <str_menu_data_name>, <value> )"
	"Summary: Set the LUI model values on an objective."
	"CallOn: NA"
	"Example: objectives::set_value( "objective_kill_targets", "num_targets", a_targets.size );"
	"SPMP: singleplayer"
@/
function set_value( str_obj_id, str_menu_data_name, value )
{
	o_obj = level.a_objectives[ str_obj_id ];
	if ( isdefined( o_obj ) )
	{
		[[o_obj]]->update_value( str_menu_data_name, value );
	}
}

// Hide the breadcrumb, and if they haven't hit it after n_timeout seconds, show it.
//
function private breadcrumb_timeout( o_obj, t_current, n_timeout )
{
	t_current endon( "trigger" );
	
	[[o_obj]]->hide();
	
	wait n_timeout;
	
	[[o_obj]]->show();
}

/@
"Name: breadcrumb( <str_obj_index>, <str_trig_targetname>, <n_timeout> )"
"Summary: Automatically advances a chain of triggered objective structs."
"Module: Objectives"
"CallOn: Level"
"MandatoryArg: <str_obj_index> The objective string ID we'd like to hide the marker and menu entry of. Default behavior hides for ALL players"
"MandatoryArg: <str_trig_targetname> The first trigger in the string of breadcrumbs.
"OptionalArg: <n_timeout> Time (seconds) after which an ignored breadcrumb will appear on-screen."
"Example: objectives::breadcrumb( "objective_go", "trig_breadcrumb", 10.0 );"
"SPMP: singleplayer"
@/
function breadcrumb( str_obj_id, str_trig_targetname, n_timeout = 0.0 )
{
	o_objective = set( str_obj_id );
	
	do
	{
		t_current = GetEnt( str_trig_targetname, "targetname" );
		
		if ( isdefined( t_current ) )
		{			
			if ( isdefined( t_current.target ) )
			{
				s_current = struct::get( t_current.target, "targetname" );
				
				if ( isdefined( s_current ) )
				{
					[[o_objective]]->set_target( s_current );
				}
				else
				{
					[[o_objective]]->set_target( t_current );
				}
			}
			else
			{
				[[o_objective]]->set_target( t_current );
			}
			
			if ( n_timeout > 0 )
			{
				level thread breadcrumb_timeout( o_objective, t_current, n_timeout );
			}
			
			str_trig_targetname = t_current.target;
			t_current trigger::wait_till();
		}
		else
		{
			str_trig_targetname = undefined;
		}
	}
	while ( isdefined( str_trig_targetname ) );
}

/@
"Name: hide( <str_obj_type>, <e_player> )"
"Summary: Hide the objective marker and menu entry for an objective."
"CallOn: NA"
"MandatoryArg: <str_obj_type> The objective string ID we'd like to hide the marker and menu entry of. Default behavior hides for ALL players"
"OptionalArg: <e_player> The specific player you would like to hide the objective waypoint from."
"Example: objectives::hide( "objective_to_do_things", e_player_2 );"
"SPMP: singleplayer"
@/
function hide( str_obj_type, e_player )
{
	if ( isdefined( level.a_objectives[str_obj_type] ) )
	{
		o_objective = level.a_objectives[str_obj_type];
		[[o_objective]]->hide( e_player );
	}
	else
	{
		Assert( false, "Attempting to hide a marker on an objective that does not exist." );
	}
}

/@
"Name: hide_for_target( <str_obj_type>, <e_target> )"
"Summary: Hide the objective marker for a specific target."
"CallOn: NA"
"MandatoryArg: <str_obj_type> The objective string ID we'd like to hide the marker."
"MandatoryArg: <e_target> The target for which you want to hide the objective marker."
"Example: objectives::hide_for_target( "tank_marker", vh_tank_3 );"
"SPMP: singleplayer"
@/
function hide_for_target( str_obj_type, e_target )
{
	if ( isdefined( level.a_objectives[str_obj_type] ) )
	{
		o_objective = level.a_objectives[str_obj_type];
		[[o_objective]]->hide_for_target( e_target );
	}
	else
	{
		Assert( false, "Attempting to hide a marker on an objective that does not exist." );
	}
}

/@
"Name: show( <str_obj_type>, <e_player> )"
"Summary: Show the objective marker and menu entry for an objective."
"CallOn: NA"
"MandatoryArg: <str_obj_type> The objective string ID we'd like to show the marker and menu entry of. Default behavior shows for ALL players"
"OptionalArg: <e_player> The specific player you would like to show the objective waypoint to."
"Example: objectives::show( "objective_to_do_things", e_player_2 );"
"SPMP: singleplayer"
@/
function show( str_obj_type, e_player )
{
	if ( isdefined( level.a_objectives[str_obj_type] ) )
	{
		o_objective = level.a_objectives[str_obj_type];
		[[o_objective]]->show( e_player );
	}
	else
	{
		Assert( false, "Attempting to show a marker on an objective that does not exist." );
	}
}

/@
"Name: show_for_target( <str_obj_type>, <e_target> )"
"Summary: Show the objective marker for a specific target."
"CallOn: NA"
"MandatoryArg: <str_obj_type> The objective string ID we'd like to show the marker."
"MandatoryArg: <e_target> The target for which you want to show the objective marker."
"Example: objectives::show_for_target( "tank_marker", vh_tank_3 );"
"SPMP: singleplayer"
@/
function show_for_target( str_obj_type, e_target )
{
	if ( isdefined( level.a_objectives[str_obj_type] ) )
	{
		o_objective = level.a_objectives[str_obj_type];
		[[o_objective]]->show_for_target( e_target );
	}
	else
	{
		Assert( false, "Attempting to hide a marker on an objective that does not exist." );
	}
}

/@
"Name: event_message( <istr_message> )"
"Summary: Show an event message on the HUD."
"MandatoryArg: <istr_message> The localized string to show."
"Example: objectives::event_message( "Kill the quadtank" );"
@/
function event_message( istr_message )
{
	foreach ( player in level.players )
	{
		player LUINotifyEvent( &"comms_event_message", 1, istring( istr_message ) );
	}
}

//str_obj_type - the icon type ( target, capture, defend, defend_b, etc )
//str_obj_name - a unique identifier for this icon. Creating a new icon with a name already in use, will destroy/override the previous icon
//v_pos - the position the icon will be placed
function create_temp_icon( str_obj_type, str_obj_name, v_pos, v_offset=(0,0,0) )
{
	switch( str_obj_type )
	{
		case "target":
			str_shader = "waypoint_targetneutral";
			break;
			
		case "capture":
			str_shader = "waypoint_capture";
			break;
			
		case "capture_a":
			str_shader = "waypoint_capture_a";		
			break;

		case "capture_b":
			str_shader = "waypoint_capture_b";		
			break;

		case "capture_c":
			str_shader = "waypoint_capture_c";		
			break;			

		case "defend":
			str_shader = "waypoint_defend";
			break;
			
		case "defend_a":
			str_shader = "waypoint_defend_a";
			break;

		case "defend_b":
			str_shader = "waypoint_defend_b";
			break;

		case "defend_c":
			str_shader = "waypoint_defend_c";
			break;

		case "return":
			str_shader = "waypoint_return";
			break;
			
		default:
			AssertMsg( "Type '" + str_obj_type + "' not supported. Please see create_temp_icon() in _objectives.gsc for supported types." );
			break;
	}
	
	nextObjPoint = objpoints::create( str_obj_name, v_pos + v_offset, "all", str_shader );
	nextObjPoint setWayPoint( true, str_shader );
	
	return nextObjPoint;
}

function destroy_temp_icon()
{
	objpoints::delete( self );
}