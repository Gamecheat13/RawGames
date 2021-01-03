#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses2_fx;
#using scripts\cp\cp_mi_cairo_ramses2_sound; // TODO: used in ramses 2 

//shareds
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_vehicle;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\cp\_dialog;

#using scripts\shared\ai_shared;


//plaza scripts
#using scripts\cp\cp_mi_cairo_ramses_quad_tank_plaza;
#using scripts\cp\cp_mi_cairo_ramses_utility;

#namespace subway;

function subway_main()
{
	precache();
	
	level thread ramses_util::light_shift_think( "ramses_light_shift_2", "freeway_battle_started", &ramses_util::set_lighting_state_time_shift_2 );
	
	level thread vtol_armada_flyover();

	raps_ambush();
	
	skipto::objective_completed( "subway" );	
	
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function vtol_armada_flyover()
{
	trigger::wait_till( "trig_spawn_qt_flyover_1" );	
	
	a_s_subway_vtol_quads = struct::get_array( "subway_vtol_quads_1", "targetname" );
	foreach( s_spot in a_s_subway_vtol_quads )
	{
		s_spot thread setup_vtol_quad();
	}	
	
	trigger::wait_till( "trig_spawn_qt_flyover_2" );	
	
	a_s_subway_vtol_quads_2 = struct::get_array( "subway_vtol_quads_2", "targetname" );
	foreach( s_spot in a_s_subway_vtol_quads_2 )
	{
		s_spot thread setup_vtol_quad();
	}
}

// Self is script struct
function setup_vtol_quad()
{
	sp_vtol = GetEnt( self.target, "targetname" );
	vh_vtol = spawner::simple_spawn_single( sp_vtol );
	vh_vtol.m_quadtank = util::spawn_model( self.model, self.origin, self.angles );
	
	vh_vtol.m_quadtank LinkTo( vh_vtol );	

	//start node
	vnd_start = GetVehicleNode( vh_vtol.target, "targetname" );
	vh_vtol.takedamage = false;
	
	vh_vtol vehicle::get_on_and_go_path( vnd_start );	
	
	vh_vtol.m_quadtank Delete();
	vh_vtol.delete_on_death = true;           vh_vtol notify( "death" );           if( !IsAlive( vh_vtol ) )           vh_vtol Delete();;
}

function raps_ambush()
{
	level scene::init( "p7_fxanim_cp_ramses_raps_rubble_pile_01_bundle" ); // Spawn rubble pile
	
	trigger::wait_till( "trig_setup_raps_ambush" );
	
	//kill and remove Egypt Spawn managers for plaza battle
//	quad_tank_plaza::quad_tank_plaza_spawn_manager_cleanup(); //TODO: DELETE AFTER 3/6 IF THIS ISN'T NECESSARY
	
	a_ai = GetAiArray();
	foreach( e_ai in a_ai )
	{
		if ( isdefined( e_ai.script_friendname ) )
		{
			if ( e_ai.script_friendname == "none" )
			{
				e_ai Delete();	
			}
		}
	}
	
	a_subway_raps = GetEntArray( "subway_raps", "targetname" );
	foreach( sp_raps in a_subway_raps )
	{
		ai_raps = sp_raps spawner::spawn();	
		ai_raps thread setup_raps_ambush();
	}	
	
	level thread rubble_fxanim();
	
	level thread monitor_ambush_gunfire();
	
	level thread monitor_raps_enemies();
	
	wait 3;
}

function rubble_fxanim()
{
	level flag::wait_till( "start_raps_ambush" );
	
	level thread scene::play( "p7_fxanim_cp_ramses_raps_rubble_pile_01_bundle" );
}

function monitor_raps_enemies()
{
	spawner::waittill_ai_group_cleared( "ambush_raps" );
	trigger::use( "trig_color_post_ambush", "targetname", undefined, false );	
	
	level.ai_hendricks dialog::say( "hend_tunnel_s_clear_0" ); //Tunnel's clear!
}

function delete_on_end_node()
{
	self waittill( "reached_end_node" );
	self delete();
}

//damage trigger that starts the ambush
function monitor_ambush_gunfire()
{
	trigger::wait_till( "trig_dmg_raps_ambush" );

	level flag::set( "start_raps_ambush" );
}
	
//self = raps
function setup_raps_ambush()
{
	self endon( "death" );
	
	self vehicle_ai::start_scripted();	
	self.ignoreall = true;
	self.ignoreme = true;

	level flag::wait_till( "start_raps_ambush" );
	
	self vehicle_ai::stop_scripted();	
	self.ignoreall = false;
	self.ignoreme = false;
}
