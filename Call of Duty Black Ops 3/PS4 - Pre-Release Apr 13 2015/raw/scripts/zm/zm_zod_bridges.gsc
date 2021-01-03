/* zm_zod_bridges.gsc
 *
 * Purpose : 	Powered bridges.
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







#using_animtree( "generic" );

#namespace zm_zod_bridges;



function autoexec __init__sytem__() {     system::register("zm_zod_bridges",undefined,&__main__,undefined);    }

function __main__()
{
	level thread init_bridges();
}

function init_bridges()
{
	if(!isdefined(level.beast_mode_targets))level.beast_mode_targets=[];

	if( !isdefined( level.a_o_bridge ) )
	{
		level.a_o_bridge = [];
		init_bridge( "slums", 1 );
		init_bridge( "canal", 2 );
		init_bridge( "theater", 3 );
	}
}

function init_bridge( str_areaname, n_index )
{
	level.a_o_bridge[ n_index ] = new cBridge();
	[[ level.a_o_bridge[ n_index ] ]]->init_bridge( str_areaname );
}

class cBridge
{
	// triggers
	var m_t_rumble; // rumble trigger
	
	// state / stats
	var m_a_e_blockers; // blockers - when extending bridges, will move after the bridges; when retracting bridges, will move before the bridges
	var m_e_clip_blocker; // the clipping brush that keeps everyone off the bridges until they are fully extended
	var m_e_walkway; // array of steps (script_models / script_brushmodels)
	var m_t_pull_trigger;
	var m_e_pull_target;
	var m_str_areaname;
	
	// vo
	var m_b_discovered;
	
	// str_targetname = targetname of an array of script_models / script_brushmodels in the map that are the steps
	function init_bridge( str_areaname )
	{
		m_str_areaname = str_areaname;
		m_n_state = 0;
		m_n_pause_between_steps = 0.1;
		door_name = str_areaname + "_bridge_door";
		m_door_array = GetEntArray(door_name,"script_noteworthy");
		
		m_a_e_blockers		= GetEntArray( "bridge_blocker",		"targetname" );
		a_e_clip_blockers	= GetEntArray( "bridge_clip_blocker",	"targetname" );
		a_e_walkway			= GetEntArray( "bridge_walkway",		"targetname" );
		a_t_pull_trigger	= GetEntArray( "bridge_pull_trigger",	"targetname" );
		a_e_pull_target		= GetEntArray( "bridge_pull_target",	"targetname" );
		
		m_a_e_blockers		= array::filter( m_a_e_blockers,		false, &filter_areaname, str_areaname );
		a_e_clip_blockers	= array::filter( a_e_clip_blockers,		false, &filter_areaname, str_areaname );
		m_e_clip_blocker	= a_e_clip_blockers[0];
		a_e_walkway			= array::filter( a_e_walkway,			false, &filter_areaname, str_areaname );
		m_e_walkway			= a_e_walkway[0];
		//a_t_pull_trigger	= array::filter( a_t_pull_trigger, 		false, &filter_areaname, str_areaname );
		//m_t_pull_trigger	= m_door_array[0];//a_t_pull_trigger[0];
		//m_t_pull_trigger	= m_door_array[1];//a_t_pull_trigger[0];
		a_e_pull_target		= array::filter( a_e_pull_target, 		false, &filter_areaname, str_areaname );
		m_e_pull_target		= a_e_pull_target[0];

		m_b_discovered = false;
		
		m_e_walkway			SetInvisibleToAll();
		
		foreach( e_blocker in m_a_e_blockers )
		{
			e_blocker UseAnimTree( #animtree );
		}
		m_e_walkway UseAnimTree( #animtree );
		
		// set up grapple target
		m_e_pull_target SetGrapplableType( 3 );
		array::add( level.beast_mode_targets, m_e_pull_target, false );
		m_e_pull_target clientfield::set("bminteract",1);
		
		self thread bridge_connect( m_door_array[0], m_door_array[1] );
	}

	function filter_areaname( e_entity, str_areaname )
	{
		if( !isdefined( e_entity.script_string ) || ( e_entity.script_string != str_areaname ) )
		{
			return false;
		}
		return true;
	}

	function bridge_connect( t_trigger_a, t_trigger_b )
	{
		//t_trigger waittill( "trigger" );
		util::waittill_any_ents_two( t_trigger_a, "trigger", t_trigger_b, "trigger" );
	
		// models of blockers (accordion gates)
		foreach( e_blocker in m_a_e_blockers )
		{
			e_blocker SetAnim( %p7_fxanim_zm_zod_gate_scissor_short_open_anim );
		}
		
		// model of walkway (will be animated model of accordion-extending bridge)
		m_e_walkway SetAnim( %p7_fxanim_zm_zod_beast_bridge_open_anim );
		m_e_walkway SetVisibleToAll();
		m_e_pull_target SetInvisibleToAll();
		
		// hide grapple target and no longer show beast mode icon
		m_e_pull_target clientfield::set("bminteract",0);
		m_e_pull_target SetGrapplableType( 0 );
		level.beast_mode_targets = array::exclude( level.beast_mode_targets, m_e_pull_target );

		wait 1;
		
		// the actual clipping
		m_e_clip_blocker move_blocker();
		m_e_clip_blocker ConnectPaths();
		
		unlock_zones();
	}

	function unlock_zones()
	{
		// activate high zone
		str_zonename = m_str_areaname + "_district_zone_high";
		if( !zm_zonemgr::zone_is_enabled( str_zonename ) )
		{
			zm_zonemgr::zone_init( str_zonename );
			zm_zonemgr::enable_zone( str_zonename );
		}
		zm_zonemgr::add_adjacent_zone( m_str_areaname + "_district_zone_B", str_zonename, "enter_" + m_str_areaname + "_district_high_from_B" );
	}

	function move_blocker()
	{
		self MoveTo( self.origin - ( 0, 0, 10000 ), 0.05 );
		wait 0.05;
	}
}
