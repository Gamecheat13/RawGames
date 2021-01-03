// ----------------------------------------------------------------------------
// codescripts
// ----------------------------------------------------------------------------
#using scripts\codescripts\struct;

// ----------------------------------------------------------------------------
// shared
// ----------------------------------------------------------------------------
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\player_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           
                                                                                                      	                       	     	                                                                     

// ----------------------------------------------------------------------------
// systems
// ----------------------------------------------------------------------------
#using scripts\cp\_dialog;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_util;

// ----------------------------------------------------------------------------
// Infection
// ----------------------------------------------------------------------------
#using scripts\cp\cp_mi_cairo_infection_util;


// ----------------------------------------------------------------------------
// #precache
// ----------------------------------------------------------------------------

#namespace sgen_server_room;

// ----------------------------------------------------------------------------
// #define
// ----------------------------------------------------------------------------







//p7_sgen_server_top
//p7_sgen_server_middle
#precache( "model", "p7_sgen_server_base" );

// ----------------------------------------------------------------------------
// main
// ----------------------------------------------------------------------------
function main()
{
	/# IPrintLnBold( "sgen_server_room::main" ); #/

	clientfield::register("world", "infection_sgen_server_debris", 1, 2, "int");
	clientfield::register( "world", "infection_sgen_xcam_models", 1, 1, "int" );
	clientfield::register( "scriptmover", "left_arm_shader", 1, 1, "int" );
}

// ----------------------------------------------------------------------------
// sgen_server_room_init
// ----------------------------------------------------------------------------
function sgen_server_room_init( str_objective, b_starting )
{
	/# IPrintLnBold( "sgen_server_room_init" ); #/

		
	level util::set_streamer_hint( 6 );	
	level scene::add_scene_func("cin_inf_05_taylorinfected_server_3rd_sh050", &scene_arm_fx_shader , "play" );
	level scene::add_scene_func( "cin_inf_05_taylorinfected_server_3rd_sh010", &infection_util::igc_begin, "play" );
	level scene::add_scene_func( "cin_inf_05_taylorinfected_server_3rd_sh090", &infection_util::igc_end, "done" );
	level thread scene::init( "cin_inf_05_taylorinfected_server_3rd_sh010" );

	skipto::teleport_players( str_objective );
		
	level flag::wait_till( "all_players_spawned" );
	
	level util::set_lighting_state( 2 );

	//init breakaway floor and debris
	level thread clientfield::set("infection_sgen_server_debris", 1);
	level thread scene::init( "p7_fxanim_cp_infection_sgen_floor_drop_bundle" );
		
	util::screen_fade_out( 0 );	
	array::thread_all(level.players, &infection_util::player_enter_cinematic );	

	level thread util::screen_fade_in( 2 );
	level thread scene::play( "cin_inf_05_taylorinfected_server_3rd_sh010" );
	
	level waittill( "taylorinfected_end_start_fade" );		//NT set in ch_inf_05_taylorinfected_server_3rd_sh090_sarah
	util::screen_fade_out( 0.5, "white" );
	
	util::clear_streamer_hint();
	//playsoundatposition ("evt_floor_fall", (0,0,0));

	exploder::exploder( "sgen_server_room_fall" );
	util::screen_fade_out( 1, "white" );
	level thread util::screen_fade_in( 2, "white" );
	
	skipto::teleport_players( str_objective );
		
	level drop_player();
}

function scene_arm_fx_shader( a_ent )
{
	level waittill( "start_arm_fx" );
	
	cin_taylor = a_ent["taylor"];
	if(IsDefined(cin_taylor))
	{				
		//cin_taylor clientfield::set("left_arm_shader", 1);
		cin_taylor cybercom::cyberCom_armPulse(1);
	}
}

// ----------------------------------------------------------------------------
// sgen_server_room_done
// ----------------------------------------------------------------------------
function sgen_server_room_done( str_objective, b_starting, b_direct, player )
{
	/# IPrintLnBold( "sgen_server_room_done" ); #/
			
	level thread clientfield::set( "infection_sgen_server_debris", 3 );
}

// ----------------------------------------------------------------------------
// drop_pieces
// ----------------------------------------------------------------------------
function drop_pieces()
{
	level thread clientfield::set("infection_sgen_server_debris", 2);
	level thread scene::play( "p7_fxanim_cp_infection_sgen_floor_drop_bundle" );
}

function drop_player()
{
	// Server room fall shared IGC, create temp anchor at player 0.
	temp_anchor = util::spawn_model("tag_origin", level.players[0].origin, level.players[0].angles);
	temp_anchor.targetname = "server_fall_align";

	util::wait_network_frame();	

	level thread drop_pieces();
	
	level scene::play( "cin_inf_05_02_infection_1st_crumblefall" );
	
	level thread clientfield::set("infection_sgen_xcam_models", 1);

	//level thread scene::stop( "cin_inf_05_02_infection_1st_crumblefall" );
	//temp_anchor Delete();

	skipto::objective_completed( "sgen_server_room" );		
}	
