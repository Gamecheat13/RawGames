#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\scene_shared;

#using scripts\shared\vehicles\_quadtank;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses3_fx;
#using scripts\cp\cp_mi_cairo_ramses3_sound;

#using scripts\cp\cp_mi_cairo_ramses_subway;
#using scripts\cp\cp_mi_cairo_ramses_freeway_battle;
#using scripts\cp\cp_mi_cairo_ramses_freeway_collapse;
#using scripts\cp\cp_mi_cairo_ramses_dead_event;
#using scripts\cp\cp_mi_cairo_ramses_utility;

#precache( "material", "waypoint_circle_arrow" );
#precache( "material", "waypoint_circle_arrow_yellow" );
#precache( "model", "veh_t7_civ_sedan_standard_blk" ); // TODO: have to precache this for destructible 

function main()
{
	precache();
	init_clientfields();
	init_flags();
	setup_skiptos();
	
	callback::on_spawned( &on_player_spawned );
	
	cp_mi_cairo_ramses3_fx::main();
	cp_mi_cairo_ramses3_sound::main();

	compass::setupMiniMap( "compass_map_cp_mi_cairo_ramses" );
	
	load::main();

	SetDvar( "compassmaxrange", "12000" );	// Set up the default range of the compass
	
	if ( ramses_util::is_demo() )
	{
		SetDvar( "livestats_giveCPXP", 0 );
	}
	
	/# 	// set up devgui
		ExecDevgui( "devgui/cp/cp_devgui_ramses" );
	#/
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function init_clientfields()
{
	// Dead Event
	clientfield::register( "toplayer", "dead_event_gridlines", 1, 1, "int" );
}

function init_flags()
{
	level flag::init( "player_has_dead_control" );
	level flag::init( "start_vtol_robot_drop_1" );
	level flag::init( "start_vtol_robot_drop_2" );
	level flag::init( "freeway_battle_cleared" );	
}

// Self is Vehicle
function station_turret_spawnfunc()
{
	self.team = "allies";
}

function setup_skiptos()
{
	skipto::add( "subway", &skipto_subway_init, "Subway", &skipto_subway_done );
		
	skipto::add( "freeway_battle", &skipto_freeway_battle_init, "Freeway Battle", &skipto_freeway_battle_done );
		
	skipto::add( "freeway_collapse", &skipto_freeway_collapse_init, "Freeway Collapse", &skipto_freeway_collapse_done );
		
	skipto::add( "dead_event", &skipto_dead_event_init, "D.E.A.D. System Targeting", &skipto_dead_event_done );
}

/**********************************************
 * CALLBACKS
 * ********************************************/
 
function on_player_spawned()
{
	self ramses_util::give_spike_launcher( false, false );
	
	self ramses_util::set_lighting_state_on_spawn();
}

/**********************************************
 * SKIP-TO's
 * ********************************************/

//////////////////////////////////////
//				SUBWAY
//////////////////////////////////////

function skipto_subway_init( str_objective, b_starting )
{
	if( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
		
		level.ai_hendricks colors::set_force_color( "o" );
		level.ai_khalil colors::set_force_color( "o" );		
		
	    skipto::teleport_ai( str_objective );
	    
	    //destroyed wall that happens when first quad tank lands
		a_bm_qt_fall_event = GetEntArray( "qt_fall_event", "targetname" );
		foreach( bm_piece in a_bm_qt_fall_event )
		{
			if ( isdefined( bm_piece ) ) 
			{
				bm_piece Delete();
			}
		}		    	    
		
		//objectives
		objectives::complete( "cp_level_ramses_vtol_igc" );			
		objectives::complete( "cp_level_ramses_clear_the_plaza" );
		objectives::complete( "cp_level_ramses_subway_crumb_1" );
		objectives::complete( "cp_level_ramses_subway_crumb_2" );		
		objectives::complete( "cp_level_ramses_plaza_regroup" );	
		
		objectives::set( "cp_level_ramses_plaza_follow_khalil", level.ai_khalil );
	}		
	
	ramses_util::init_dead_turrets( true );	
	subway::subway_main();
}

function skipto_subway_done( str_objective, b_starting, b_direct, player )
{
	ramses_util::set_lighting_state_time_shift_2();
}


//////////////////////////////////////
//				FREEWAY BATTLE
//////////////////////////////////////

function skipto_freeway_battle_init( str_objective, b_starting )
{
	if( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
		
		level.ai_hendricks colors::set_force_color( "o" );
		level.ai_khalil colors::set_force_color( "o" );		
		
	    skipto::teleport_ai( str_objective );
	    
		//objectives
		objectives::complete( "cp_level_ramses_vtol_igc" );				
		objectives::complete( "cp_level_ramses_clear_the_plaza" );
		objectives::complete( "cp_level_ramses_subway_crumb_1" );		
		objectives::complete( "cp_level_ramses_subway_crumb_2" );		
		objectives::complete( "cp_level_ramses_plaza_regroup" );	
		
		objectives::set( "cp_level_ramses_plaza_follow_khalil", level.ai_khalil );

	    ramses_util::init_dead_turrets( true );
	}

	level scene::init( "p7_fxanim_cp_ramses_robot_car_crush_bundle" ); // Spawn model
	level thread cp_mi_cairo_ramses_dead_event::pre_skipto();
	freeway_battle::freeway_battle_main();
}

function skipto_freeway_battle_done( str_objective, b_starting, b_direct, player )
{
}

//////////////////////////////////////
//				FREEWAY COLLAPSE
//////////////////////////////////////

function skipto_freeway_collapse_init( str_objective, b_starting )
{
	if( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
		
		level.ai_hendricks colors::set_force_color( "o" );
		level.ai_khalil colors::set_force_color( "o" );		
		
		objectives::complete( "cp_level_ramses_vtol_igc" );		
		objectives::complete( "cp_level_ramses_clear_the_plaza" );		
		objectives::complete( "cp_level_ramses_plaza_regroup" );	
		objectives::complete( "cp_level_ramses_plaza_follow_khalil" );		
		
	    skipto::teleport_ai( str_objective );
	    
	    ramses_util::init_dead_turrets( true );
	    level thread cp_mi_cairo_ramses_dead_event::pre_skipto();
	    
	    level thread cp_mi_cairo_ramses_dead_event::dead_event_start_ambient_combat();
	}
	
	freeway_collapse::freeway_collapse_main();
}

function skipto_freeway_collapse_done( str_objective, b_starting, b_direct, player )
{
}

//////////////////////////////////////
//				DEAD EVENT
//////////////////////////////////////

function skipto_dead_event_init( str_objective, b_starting )
{
	if( b_starting )
	{
		cp_mi_cairo_ramses_dead_event::init_heroes( str_objective );
		ramses_util::init_dead_turrets( true );
		
		level thread scene::skipto_end( "p7_fxanim_cp_ramses_freeway_collapse_bundle" );
		
		level thread cp_mi_cairo_ramses_dead_event::setup_threat_bias();
		level thread cp_mi_cairo_ramses_dead_event::dead_event_start_ambient_combat();
	}
	
	cp_mi_cairo_ramses_dead_event::main();
}

function skipto_dead_event_done( str_objective, b_starting, b_direct, player )
{
}
