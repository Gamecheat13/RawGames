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
#using scripts\shared\callbacks_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

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

#precache( "material", "waypoint_return" );
#precache( "material", "objective_arrow" );

#precache( "eventstring", "comms_event_message" );
#precache( "string", "CP_SH_CAIRO_PLAYER_READY" );



	



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
				for ( i = m_a_targets.size - 1; i >= 0; i-- )
				{
					if ( m_a_targets[ i ] == target )
					{
						Objective_State( m_a_game_obj[ i ], "done" );
						
						ArrayRemoveIndex( m_a_game_obj, i );
						ArrayRemoveIndex( m_a_targets, i );
						
						break;
					}
				}
			}
		}
		else
		{
			foreach ( n_gobj_id in m_a_game_obj )
			{
				Objective_State( n_gobj_id, "done" );
			}
			
			for ( i = m_a_targets.size - 1; i >= 0; i-- )
			{
				ArrayRemoveIndex( m_a_game_obj, i );
				ArrayRemoveIndex( m_a_targets, i );
			}
		}
		
		if ( m_a_game_obj.size == 0 )
		{
			ArrayRemoveValue( level.a_objectives, self, true );
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
	
	function get_id_for_target( e_target )
	{
		foreach( i, obj_id in m_a_game_obj )
		{
			ent = m_a_targets[i];
			if ( isdefined( ent ) && ent == e_target )
			{
				return obj_id;
			}
		}
		return -1;
	}

	function is_breadcrumb()
	{
		return false;
	}
}



class cBreadcrumbObjective : cObjective
{
	var m_a_player_game_obj;			// array of objective ids, one per player
	var m_str_first_trig_targetname;	// the targetname of the first trigger in the breadcrumb sequence
	var m_done;							// at least one of the players has reached the end of their breadcrumb trail

	constructor()
	{
	}

	function init( str_type, a_target_list, b_done = false )
	{
		// call the parent version
		cObjective::init( str_type, a_target_list, b_done );

		// init some fields
		m_str_first_trig_targetname = "";
		m_done = false;

		// create objectives for max players
		m_a_player_game_obj = [];
		for ( i = 0; i < 4; i++ )
		{
			obj_id = gameobjects::get_next_obj_id();
			m_a_player_game_obj[i] = obj_id;
			Objective_Add( obj_id, "empty", ( 0, 0, 0 ), iString( m_str_type ) );
		}

		// hide the actual objective, since each player now has their own
		obj_id = m_a_game_obj[0];
		Objective_SetInvisibleToAll( obj_id );
	}

	function complete( a_target_or_list )
	{
		// kill the threads
		level notify( "breadcrumb_" + m_str_type + "_complete" );

		// destroy the objectives
		for ( i = 0; i < 4; i++ )
		{
			obj_id = m_a_player_game_obj[i];
			Objective_State( obj_id, "done" );
		}

		// call the parent version
		cObjective::complete( a_target_or_list );
	}

	function hide( e_player )
	{
		if ( isdefined( e_player ) )
		{
			Assert( IsPlayer( e_player ), "Passed a non-player entity into cBreadcrumbObjective::hide()" );
			entnum = e_player GetEntityNumber();
			obj_id = m_a_player_game_obj[entnum];
			Objective_SetInvisibleToPlayer( obj_id, e_player );
		}
		else
		{
			for ( i = 0; i < 4; i++ )
			{
				obj_id = m_a_player_game_obj[i];
				Objective_SetInvisibleToPlayerByIndex( obj_id, i );
			}
		}
	}
	
	function show( e_player )
	{
		if ( isdefined( e_player ) )
		{
			Assert( IsPlayer( e_player ), "Passed a non-player entity into cBreadcrumbObjective::hide()" );
			entnum = e_player GetEntityNumber();
			obj_id = m_a_player_game_obj[entnum];
			Objective_SetVisibleToPlayer( obj_id, e_player );
		}
		else
		{
			for ( i = 0; i < 4; i++ )
			{
				obj_id = m_a_player_game_obj[i];
				Objective_SetVisibleToPlayerByIndex( obj_id, i );
			}
		}
	}

	function start( str_trig_targetname )
	{
		// remember the name of the first trigger
		m_str_first_trig_targetname = str_trig_targetname;
		m_done = false;

		// create individual objectives for each player
		foreach( player in level.players )
		{
			add_player( player );
		}
	}

	function add_player( player )
	{
		// activate the objective
		entnum = player GetEntityNumber();
		obj_id = m_a_player_game_obj[entnum];
		Objective_SetInvisibleToAll( obj_id );
		Objective_SetVisibleToPlayer( obj_id, player );
		Objective_State( obj_id, "active" );

		// spawn a thread to track the player's movement along the breadcrumb trail
		thread do_player_breadcrumb( player );
	}

	function private set_player_objective( player, target )
	{
		entnum = player GetEntityNumber();
		obj_id = m_a_player_game_obj[entnum];
		
		n_breadcrumb_height = 72;
		
		v_pos = target;
		if ( !IsVec( target ) )
		{
			v_pos = target.origin;
			
			if ( isdefined( target.script_height ) )
			{
				n_breadcrumb_height = target.script_height;
			}
		}
		
		v_pos = util::ground_position( v_pos, 300, n_breadcrumb_height );
		
		Objective_Position( obj_id, v_pos );
		Objective_State( obj_id, "active" );
	}

	function do_player_breadcrumb( player )
	{
		level endon( "breadcrumb_" + m_str_type );
		level endon( "breadcrumb_" + m_str_type + "_complete" );
		player endon( "death" );

		str_trig_targetname = m_str_first_trig_targetname;
		entnum = player GetEntityNumber();
		obj_id = m_a_player_game_obj[entnum];
		Objective_SetVisibleToPlayer( obj_id, player );
		do
		{
			t_current = GetEnt( str_trig_targetname, "targetname" );
		
			if ( isdefined( t_current ) )
			{			
				if ( isdefined( t_current.target ) )
				{
					if ( isdefined( t_current.script_flag_true ) )
					{
						Objective_SetInvisibleToPlayer( obj_id, player );
						level flag::wait_till( t_current.script_flag_true );
						Objective_SetVisibleToPlayer( obj_id, player );
					}
				
					s_current = struct::get( t_current.target, "targetname" );
				
					if ( isdefined( s_current ) )
					{
						set_player_objective( player, s_current );
					}
					else
					{
						set_player_objective( player, t_current );
					}
				}
				else
				{
					set_player_objective( player, t_current );
				}
			
				str_trig_targetname = t_current.target;
				t_current trigger::wait_till( undefined, undefined, player );
			}
			else
			{
				str_trig_targetname = undefined;
			}
		}
		while ( isdefined( str_trig_targetname ) );
		Objective_SetInvisibleToPlayer( obj_id, player );

		// done
		m_done = true;
	}

	function is_breadcrumb()
	{
		return true;
	}

	function is_done()
	{
		// we're done if at least one of the players has made it to the final breadcrumb
		return m_done;
	}
}

function autoexec __init__sytem__() {     system::register("objectives",&__init__,undefined,undefined);    }

function __init__()
{
	level.a_objectives = [];	// Declares an array of objectives to hold the objective strings.
	level.n_obj_index = 0;	// This is the objective number associated with the objective strings.

	callback::on_spawned( &on_player_spawned );
}

/@
"Name: set( <str_obj_type>, <a_target_or_list>, <b_breadcrumb> )"
"Summary: Used for all objective-related tasks."
"CallOn: NA"
"Example: objectives::set( "cp_level_lotus_hakim", level.ai_hakim );"
"SPMP: singleplayer"
@/
function set( str_obj_type, a_target_or_list, b_breadcrumb )
{
	if(!isdefined(level.a_objectives))level.a_objectives=[];
	if(!isdefined(b_breadcrumb))b_breadcrumb=false;
	
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
		if ( b_breadcrumb )
		{
			o_objective = new cBreadcrumbObjective();
		}
		else
		{
			o_objective = new cObjective();
		}
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

/@
"Name: breadcrumb( <str_trig_targetname>, [str_obj_id] )"
"Summary: Automatically advances a chain of triggered objective structs."
"Module: Objectives"
"CallOn: Level"
"MandatoryArg: <str_trig_targetname> The first trigger in the string of breadcrumbs."
"OptionalArg: [str_obj_id] The objective string ID we'd like to hide the marker and menu entry of. Default behavior hides for ALL players."
"Example: objectives::breadcrumb( "trig_breadcrumb" );"
"SPMP: singleplayer"
@/
function breadcrumb( str_trig_targetname, str_obj_id = "cp_waypoint_breadcrumb", b_complete_on_first_player_finish = true )
{
	level notify( "breadcrumb_" + str_obj_id );
	level endon( "breadcrumb_" + str_obj_id );
	
	if ( isdefined( level.a_objectives[ str_obj_id ] ) )
	{
		complete( str_obj_id );
	}
	
	o_objective = set( str_obj_id, undefined, true );
	[[o_objective]]->start( str_trig_targetname );

	while ( ![[o_objective]]->is_done() )
	{
		wait 0.05;
	}

	if ( b_complete_on_first_player_finish )
	{	
		complete( str_obj_id );
	}
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
"Name: get_id_for_target( <str_obj_type>, <e_target> )"
"Summary: Get objective ID for a specific target."
"CallOn: NA"
"MandatoryArg: <str_obj_type> The objective string ID."
"MandatoryArg: <e_target> The target for which you want the ID."
"Example: id = objectives::get_id_for_target( "tank_marker", vh_tank_3 );"
"SPMP: singleplayer"
@/
function get_id_for_target( str_obj_type, e_target )
{
	id = -1;
	if ( isdefined( level.a_objectives[str_obj_type] ) )
	{
		o_objective = level.a_objectives[str_obj_type];
		id = [[o_objective]]->get_id_for_target( e_target );
	}
	
	if ( id < 0 )
	{
		Assert( false, "get_id_for_target called for an objective that does not exist." );
	}
	return id;
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
		util::show_event_message( player, istring( istr_message ) );
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

function private on_player_spawned() // self = player
{
	// find any active breadcrumbs, and initialize them on this player
	if ( isdefined( level.a_objectives ) )
	{
		foreach( o_objective in level.a_objectives )
		{
			if ( [[o_objective]]->is_breadcrumb() )
			{
				[[o_objective]]->add_player( self );
			}
		}
	}
}
