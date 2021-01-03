#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\gametypes\_weapon_utils;
#using scripts\mp\gametypes\_weaponobjects;

#using scripts\mp\_challenges;
#using scripts\mp\_scoreevents;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreak_weapons;
#using scripts\mp\killstreaks\_supplydrop;

#namespace weapons;

function autoexec __init__sytem__() {     system::register("weapons",&__init__,undefined,undefined);    }
	
function __init__()
{
	weapons::init_shared();
}