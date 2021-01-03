#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;
#using scripts\shared\stealth;

#using scripts\cp\_debug;
#using scripts\cp\sidemissions\_sm_ui;
#using scripts\shared\vehicles\_quadtank;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_exfil;

/*****************************************
 * -- Quad Tank Battle --
 * ***************************************/

function skipto_quad_init( str_objective, b_starting )
{
	if( b_starting )
	{
		vengeance_util::init_hero( "rachel", str_objective );
		level.ai_rachel.goalradius = 32;		
		
		if ( isdefined( level.stealth ))
	    {
	        level stealth::stop();
	    }
		
		level flag::wait_till( "all_players_spawned" );
	}

	//Spawn Hendricks a 3rd time.
	vengeance_util::init_hero( "hendricks", str_objective );
	
	quad_combat_main();
}

function skipto_quad_done( str_objective, b_starting, b_direct, player )
{

}

function quad_combat_main()
{
	e_door_clip = GetEnt( "safehouse_ext_door_clip", "targetname" );
	a_doors = GetEntArray( "safehouse_ext_door", "targetname" );
	
	e_door_clip Delete();
	array::delete_all( a_doors );	
	
	text_array = [];
	text_array[ 0 ] = "Still figuring out details here";
	text_array[ 1 ] = "but the player blows the bridges killing";
	text_array[ 2 ] = "most of the 54i.  One full Quad Tank";
	text_array[ 3 ] = "remains in the plaza.";
				
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, undefined );
	
	//Sends Kayne outside.
	trigger::use( "kayne_color_path_4", "targetname", level.ai_rachel );
	
    level.quadtank = spawner::simple_spawn_single( "plaza_quadtank" );

	objectives::set( "obj_destroy_quad",  level.quadtank );

	//Hendricks:  Quad Tank!  Take cover!
	dialog::remote( "hend_quad_tank_take_0", 0 );
	
	level.quadtank  waittill( "death" );
	
	objectives::complete( "obj_destroy_quad" );
	skipto::objective_completed( "quad_battle" );
}

/*****************************************
 * -- Combat from Safehouse to Garage --
 * ***************************************/

function skipto_market_combat_init( str_objective, b_starting )
{
	if( b_starting )
	{
		vengeance_util::init_hero( "hendricks", str_objective );
		vengeance_util::init_hero( "rachel", str_objective );
		
		if ( isdefined( level.stealth ))
	    {
	        level stealth::stop();
	    }
		
		level flag::wait_till( "all_players_spawned" );
	}

	trigger::use( "market_color_path_1", "targetname", level.ai_rachel );
	
	level.ai_hendricks thread market_combat_vo();
	market_combat_main();
}

function skipto_market_combat_done( str_objective, b_starting, b_direct, player )
{
	
}

function market_combat_main()
{
	text_array = [];
	text_array[ 0 ] = "The players are forced to battle back the";
	text_array[ 1 ] = "way they came.  This is traditional combat.";
				
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, false );
		
	objectives::breadcrumb( "obj_exfil", "obj_market_combat_breadcrumb" );
	
//	trig = getent( "obj_exfil", "targetname" );
//	trig.objective_target = SpawnStruct();
//	trig.objective_target.origin = trig.origin;
//	objectives::set( "obj_exfil", trig.objective_target );
		
	trigger::wait_till( "obj_market_combat", "targetname" );
		
//	util::screen_message_create( "Market Combat Checkpoint Reached.", undefined, undefined, undefined, 2.0 );
	
	skipto::objective_completed( "market_combat" );
}

function market_combat_vo()
{
	self dialog::say( "hend_keep_pushing_through_0", 0 );
	
	trigger::wait_till( "mc_breadcrumb_1", "targetname" );
	
	text_array = [];
	text_array[ 0 ] = "The Singapore police join in from the";
	text_array[ 1 ] = "right.  The number of police is based";
	text_array[ 2 ] = "on how many you rescued earlier in the level.";
					
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, true );
		
	dialog::remote( "pcap_to_the_american_forc_0", 0 );
	self dialog::say( "hend_nice_timing_li_we_0", 0 );
	
	trigger::wait_till( "vo_at_garage", "targetname" );
	
	self dialog::say( "hend_command_what_is_the_0", 0 );
	dialog::remote( "comm_2_mikes_until_we_ent_0", 0 );
	self dialog::say( "hend_it_s_going_to_be_a_h_0", 0 );
	
	text_array = [];
	text_array[ 0 ] = "The garage is full of enemies.";
	text_array[ 1 ] = "There are multiple paths upwards.";
						
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, false );
}

/*****************************************
 * -- Exfil --
 * ***************************************/

function skipto_exfil_init( str_objective, b_starting )
{
	if( b_starting )
	{	
		vengeance_util::init_hero( "hendricks", str_objective );
		vengeance_util::init_hero( "rachel", str_objective );
		
		level thread exfil_skipto_objective();
				
		if ( isdefined( level.stealth ))
	    {
	        level stealth::stop();
	    }
		
		level flag::wait_till( "all_players_spawned" );
		
		trigger::use( "garage_color_path_1", "targetname" );
	}
	
	exfil_main();
}

function skipto_exfil_done( str_objective, b_starting, b_direct, player )
{

}

function exfil_skipto_objective()
{
	objectives::breadcrumb( "obj_exfil","obj_exfil" );	
}

function exfil_main()
{
	trigger::wait_till( "at_exfil_spot", "targetname" );
	
	objectives::complete( "obj_exfil" );
	
	level.ai_hendricks dialog::say( "hend_command_we_re_in_po_0", 0 );

	//starts VTOL fly-in.
	level thread exfil_vtol();
	
	dialog::remote( "vtlp_delta_4_this_is_eag_0", 0 );
		
	level waittill( "vtol_done" );
	
	text_array = [];
	text_array[ 0 ] = "A friendly aircraft swoops in to pickup";
	text_array[ 1 ] = "the crew.";
	text_array[ 2 ] = "Level Ends.";
						
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, true );
	
	
	skipto::objective_completed( "exfil" );
	
}

function exfil_vtol()
{
	sp_vtol = GetEnt( "exfil_vtol", "targetname" );
	nd_first = GetVehicleNode( sp_vtol.target, "targetname" );
	
	// spawn vtol, fly in and land
	e_vtol = vehicle::simple_spawn_single( "exfil_vtol" );
	e_vtol AttachPath( nd_first );
	e_vtol StartPath();
	
	e_vtol waittill( "reached_end_node" );
	
	level notify( "vtol_done" );
}

