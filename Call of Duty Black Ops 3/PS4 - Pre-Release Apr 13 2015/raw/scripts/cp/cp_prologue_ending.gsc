
//
// Event 20
//
// cp_prologue_ending.gsc
//

#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;

#using scripts\shared\scene_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\flag_shared;

#using scripts\cp\_skipto;

//*****************************************************************************
// EVENT 19: prologue_ending
//*****************************************************************************



#namespace prologue_ending;

// DO ALL PRECACHING HERE
function prologue_ending_precache()
{
	
}

// Event Main Function
function prologue_ending_main()
{
	prologue_ending_precache();
		

	
	// Get Vehicle
	/*if ( !IsDefined(level.apc) )
	{
		level.apc = vehicle::simple_spawn_single( "vehicle_apc_hijack" );
			
		// NEEDED OR THE VEHICLE FALLS THROUGH THE WORLD
		wait( 0.2 );				
		
		s_struct = struct::get( "prolgue_ending_vehicle_skipto_position", "targetname" );
		level.apc.origin = s_struct.origin;
		level.apc.angles = s_struct.angles;
	}	*/
	
	level flag::wait_till( "all_players_spawned" );
		
//	str_next_map = "cp_mi_zurich_newworld";
//	level thread load_next_map( str_next_map );	
		
	level thread overrun_message();
	
	wait 1.0;
	
	// Player ripped apart scene
	level scene::play( "cin_pro_20_01_squished_1st_rippedapart" );
	
	level thread util::screen_fade_out( 5 );	

	level scene::play( "cin_pro_20_03_squished_1st_shot" );

	wait 2;
	
	skipto::objective_completed( "skipto_prologue_ending" );	
}

function overrun_message()
{
	// Hendricks tells players to defend
	wait( 1 );
	util::screen_message_create( "The robots overcome the players, but the cybersoldiers rescue them at the last minute." );
	wait( 5 );
	util::screen_message_delete();
}

function load_next_map( str_next_map )
{
    SwitchMap_Preload( "cp_mi_zurich_newworld", "coop" );
    world.next_map = str_next_map;
    //SetDvar( "cp_queued_level", str_next_map );  // TODO: when world.save carries over, remove this.
    level waittill( "switchmap_preload_finished" );
    SwitchMap_Switch();
}
