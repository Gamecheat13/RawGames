
//
// prologue_intro.gsc
//
// Event 1 - Air Trafic Controller
// Event 2 - NRC Knocking
// Event 3 - Blend In
//

#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\spawner_shared;
#using scripts\cp\_spawn_manager;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cp_prologue_enter_base;



//*****************************************************************************
// EVENT 1: Air Traffic Controller
//*****************************************************************************

#namespace air_traffic_controller;


function air_traffic_controller_start()
{
	air_traffic_controller_precache();
	level thread air_traffic_controller_main();
}

// DO ALL PRECACHING HERE
function air_traffic_controller_precache()
{
	
}

//*****************************************************************************
//*****************************************************************************
// Event Main Function
function air_traffic_controller_main()
{
	level.a_atc_debris = GetEntArray( "control_tower_debris" , "targetname" );
	
	foreach( ent in level.a_atc_debris )
	{
		ent Hide();
	}
	
	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
	}
	
	level flag::wait_till( "all_players_spawned" );
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_nrc_knocking" );
		
	wait 0.1;
	
	// Close coop black screen
	level thread close_cacwaitmenu();
	
	level thread spawn_tunnel_vehicles();
		
	level thread scene::play( "cin_pro_02_01_knocking_vign_approach_startmove" , level.ai_hendricks );
	
	// first intro animation
	level scene::play( "cin_pro_01_01_airtraffic_1st_interact_intro" );
		
	foreach ( e_player in level.players )
	{
		e_player SetClientUIVisibilityFlag( "hud_visible", 1 ); 
		e_player EnableWeapons();
	}
	
	foreach( ent in level.a_atc_debris )
	{
		ent Show();
	}
		
	skipto::objective_completed( "skipto_air_traffic_controller" );
}


//*****************************************************************************
// close_cacwaitmenu
//*****************************************************************************

function close_cacwaitmenu()
{
	wait 1; //wait until IGC has started playing before closing menu
	
	foreach( player in level.players )
	{
		if ( isdefined( player.wait_menu ) )
		{
			player CloseLUIMenu( player.wait_menu );
		} 
	}
} 


//*****************************************************************************
//*****************************************************************************

function spawn_tunnel_vehicles()	
{
	wait 8;//blockout tuning timing
	//vehicles in level are appended with _near or _far
	a_vehicles = [];
	a_vehicles[a_vehicles.size] = "tarmac_cargo_short";
	a_vehicles[a_vehicles.size] = "tarmac_cargo_long";
	a_vehicles[a_vehicles.size] = "tarmac_humvee";
	a_vehicles[a_vehicles.size] = "tarmac_jeep";
	
	for (i = 0; i < 15; i++)
	{
		//spawn in the near tunnel
		index = RandomIntRange(0, a_vehicles.size);
		veh_to_spawn = a_vehicles[index] + "_near";
		sp_tunneltruck1 = vehicle::simple_spawn_single(veh_to_spawn);
		sp_tunneltruck1 thread take_out_guards::tunneltruck("tunnel_truck1_node");
		
		//spawn in the far tunnel
		index = RandomIntRange(0, a_vehicles.size);
		veh_to_spawn = a_vehicles[index] + "_far";
		sp_tunneltruck2 = vehicle::simple_spawn_single(veh_to_spawn);
		sp_tunneltruck2 thread take_out_guards::tunneltruck("tunnel_truck2_node");
		//spawn more of them as player approaches tunnel
		//TODO: Start up a new spawn sequence in case it empties out on the way down the tower
		if (level flag::get("trigger_obj_cross_tarmac_start"))
		{
			delay_between_spawns = 2.5;
		}
		else
		{
			delay_between_spawns = 6;
		}
		wait delay_between_spawns;
		if (level flag::get("stop_tunnel_spawns"))
        {
       		break;
        }
	}
}

