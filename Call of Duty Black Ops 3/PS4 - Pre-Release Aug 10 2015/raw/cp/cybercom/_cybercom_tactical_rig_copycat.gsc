    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#using scripts\shared\math_shared;
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\shared\weapons_shared;

#namespace cybercom_tacrig_copycat;

function init()
{
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	cybercom_tacrig::register_cybercom_rig_ability( "cybercom_copycat", 6 );
	cybercom_tacrig::register_cybercom_rig_possession_callbacks( "cybercom_copycat", &CopyCatGive, &CopyCatTake );
}

//---------------------------------------------------------
function on_player_connect()
{
}
function on_player_spawned()
{
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tactical RIG - Copy Cat
// Standard: killed AI drop guns
// Upgraded: killed AI drop explosives
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function CopyCatGive(type)
{
	//ui
	//vision set?
	self thread cybercom_tacrig::turn_rig_ability_on(type);//this rig is passive, just turn on by default
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function CopyCatTake(type)
{
	self thread cybercom_tacrig::turn_rig_ability_off(type);
	self notify("copyCatTake");
}
