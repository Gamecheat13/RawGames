/* zm_zod_stairs.gsc
 *
 * Purpose : 	Powered stairs.
 *		
 * Author : 	G Henry Schmitt
 * 
 * 
 */
 
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_poweronswitch;





#namespace zm_zod_stairs;



function autoexec __init__sytem__() {     system::register("zm_zod_stairs",undefined,&__main__,undefined);    }

function __main__()
{
	level thread init_stairs();
}

function init_stairs()
{
	if( !isdefined( level.a_o_stair ) )
	{
		level.a_o_stair = [];
		init_stair( "slums", 		1 + 10 );
		init_stair( "canal", 		2 + 10 );
		init_stair( "theater",		3 + 10 );
		init_stair( "start",			4 + 10 );
		init_stair( "brothel",		6 + 10 );
		init_stair( "underground",	5 + 10 );
		init_stair( "club",			21 );
	}
}

function init_stair( str_areaname, n_power_index )
{
	if( !isdefined( level.a_o_stair[ n_power_index ] ) )
	{
		level.a_o_stair[ n_power_index ] = new cStair();
		[[ level.a_o_stair[ n_power_index ] ]]->init_stair( str_areaname, n_power_index );
		[[ level.a_o_stair[ n_power_index ] ]]->start_stair();
	}
}

class cStair
{
	// triggers
	var m_t_rumble; // rumble trigger
	
	// state / stats
	var m_n_state; // inactive, extending, active, retracting
	var m_a_e_steps; // array of steps (script_models / script_brushmodels)
	var m_a_e_blockers; // blockers - when extending stairs, will move after the stairs; when retracting stairs, will move before the stairs
	var m_a_e_clip; // the clipping brush that keeps everyone off the stairs until they are fully extended
	var m_s_orientation; // struct used to set the orientation of the stair entities in the map
	
	// settings
	var m_n_pause_between_steps; // pause between starting to move each step
	var m_str_areaname; // the part of the map these stairs are in
	var m_n_power_index;
	
	var m_b_discovered;
	
	// str_targetname = targetname of an array of script_models / script_brushmodels in the map that are the steps
	function init_stair( str_areaname, n_power_index )
	{
		m_n_state = 0;
		m_n_pause_between_steps = 0.1;
		
		m_str_areaname	= str_areaname;
		
		m_a_e_steps		= GetEntArray( "stair_step",	"targetname" );
		m_a_e_blockers	= GetEntArray( "stair_blocker",	"targetname" );
		m_a_e_clip		= GetEntArray( "stair_clip",	"targetname" );
		
		m_a_e_steps		= array::filter( m_a_e_steps,		false, &filter_areaname, str_areaname );
		m_a_e_blockers	= array::filter( m_a_e_blockers,	false, &filter_areaname, str_areaname );
		m_a_e_clip		= array::filter( m_a_e_clip, 		false, &filter_areaname, str_areaname );

		m_n_power_index = n_power_index;
		
		m_b_discovered = false;
	}
	
	function start_stair()
	{
		// stairs start out in closed position, and instantly retract (makes them easier to place in Radiant)
		stair_move( false, true );
		self thread stair_think();
	}
	
	function filter_areaname( e_entity, str_areaname )
	{
		if( !isdefined( e_entity.script_string ) || ( e_entity.script_string != str_areaname ) )
		{
			return false;
		}
		return true;
	}
	
	function get_blocker()
	{
		return m_a_e_blockers[0];
	}
	
	function stair_think()
	{
		// wait for power to be activated
		stair_wait();
		// raise the stairs
		stair_move( true, false );
	}

	function stair_wait()
	{
		level flag::wait_till( "power_on" + m_n_power_index );
	}
	
	function stair_move( b_is_extending, b_is_instant )
	{
		// instant setting
		if( b_is_instant )
		{
			n_step_rise_duration = 0.05; // nonzero value so MoveTo will work
			n_barricade_duration = 0.05;
		}
		else
		{
			n_step_rise_duration = 0.5;
			n_barricade_duration = 0.25;
		}
		
		if( b_is_extending )
		{
			m_n_state = 1;
		}
		else
		{
			m_n_state = 3;
		}
		
		// blockers
		if( !b_is_extending )
		{
			foreach( e_blocker in m_a_e_blockers )
			{
				self thread element_move( e_blocker, !b_is_extending, 64, n_barricade_duration );
			}
		}
		
		// steps
		foreach( e_step in m_a_e_steps )
		{
			self thread element_move( e_step, b_is_extending, e_step.script_int, n_step_rise_duration );
			if( isdefined( m_n_pause_between_steps ) )
			{
				wait m_n_pause_between_steps;
			}
		}
		wait n_step_rise_duration; // let final step move into place before continuing
		
		// blockers
		if( b_is_extending )
		{
			foreach( e_blocker in m_a_e_blockers )
			{
				self thread element_move( e_blocker, !b_is_extending, 64, n_barricade_duration );
			}
		}

		// collision & state
		if( b_is_extending )
		{
			m_n_state = 2;
			m_a_e_clip[0]	move_blocker();
			m_a_e_clip[0]	ConnectPaths();
		}
		else
		{
			m_n_state = 0;
			m_a_e_clip[0]	SetVisibleToAll();
			m_a_e_clip[0]	DisconnectPaths();
		}
		
		if( b_is_extending )
		{

			// Set flag if specified.  This can be used to activate zones like doors
			if ( isdefined( m_a_e_steps[0].script_flag_set ) )
			{
				level flag::set( m_a_e_steps[0].script_flag_set );
			}
		}
	}
	
	// self = step or blocker
	// moves the step into or out of place
	// gets the distance to move off of the entity's script_int (in units)
	// gets the duration to move off of the entity's script_float (in seconds)
	function element_move( e_mover, b_is_extending, n_step_rise_distance, n_duration )
	{
		if( !b_is_extending )
		{
			n_step_rise_distance = -n_step_rise_distance; // retract
		}
		
		v_offset = AnglesToUp( (0, 0, 0 ) ) * n_step_rise_distance;
		e_mover MoveTo( e_mover.origin + v_offset, n_duration );
	}
	
	function move_blocker()
	{
		self MoveTo( self.origin - ( 0, 0, 10000 ), 0.05 );
		wait 0.05;
	}
}
