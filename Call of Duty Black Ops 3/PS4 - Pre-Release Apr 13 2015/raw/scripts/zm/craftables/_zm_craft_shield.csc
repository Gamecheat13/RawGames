#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\craftables\_zm_craftables;

                                                                                                                                                                              	                           	                                        	                                                     	                                 
                                                                                                                               






#namespace zm_craft_shield;

function autoexec __init__sytem__() {     system::register("zm_craft_shield",&__init__,undefined,undefined);    }

// RIOT SHIELD	
function __init__()
{
	zm_craftables::include_zombie_craftable( "craft_shield_zm" );
	zm_craftables::add_zombie_craftable( "craft_shield_zm" );
	
	RegisterClientField( "world", "piece_riotshield_dolly",	1, 1, "int", undefined, false );
	RegisterClientField( "world", "piece_riotshield_door", 1, 1, "int", undefined, false );
	RegisterClientField( "world", "piece_riotshield_clamp",	1, 1, "int", undefined, false );
	
	SetupClientFieldCodeCallbacks( "world", 1, "piece_riotshield_dolly" );
	SetupClientFieldCodeCallbacks( "world", 1, "piece_riotshield_door" );
	SetupClientFieldCodeCallbacks( "world", 1, "piece_riotshield_clamp" );	
}
