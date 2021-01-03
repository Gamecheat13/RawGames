#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_powerups;

                                                                
                                                                                                                               

#namespace zm_powerup_full_ammo;

function autoexec __init__sytem__() {     system::register("zm_powerup_full_ammo",&__init__,undefined,undefined);    }
	
function __init__()
{
	zm_powerups::include_zombie_powerup( "full_ammo" );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "full_ammo" );
	}
}
