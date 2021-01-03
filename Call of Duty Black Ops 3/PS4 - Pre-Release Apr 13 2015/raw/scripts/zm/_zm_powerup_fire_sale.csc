#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_powerups;

                                                                
                                                                                                                               

#namespace zm_powerup_fire_sale;

function autoexec __init__sytem__() {     system::register("zm_powerup_fire_sale",&__init__,undefined,undefined);    }
	
function __init__()
{
	zm_powerups::include_zombie_powerup( "fire_sale" );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "fire_sale", "powerup_fire_sale" );
	}
	
	//level._BOX_INDICATOR_FLASH_LIGHTS_FIRE_SALE = 98;//TODO T7 - this does not appear to be used, pulled from _zm.csc
}
