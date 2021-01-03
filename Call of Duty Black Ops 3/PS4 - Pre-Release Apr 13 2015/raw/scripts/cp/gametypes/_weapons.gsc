#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_shellshock;
#using scripts\cp\gametypes\_weapon_utils;
#using scripts\cp\gametypes\_weaponobjects;

#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_killstreak_weapons;
#using scripts\cp\killstreaks\_supplydrop;

#namespace weapons;

function autoexec __init__sytem__() {     system::register("weapons",&__init__,undefined,undefined);    }
	
function __init__()
{
	weapons::init_shared();
}