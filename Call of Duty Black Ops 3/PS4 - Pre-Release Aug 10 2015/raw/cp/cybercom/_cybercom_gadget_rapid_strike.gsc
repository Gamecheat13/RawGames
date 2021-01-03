/*
 * Created by ScriptDevelop.
 * User: dking
 * Date: 1/26/2015
 * Time: 4:14 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
#using scripts\shared\system_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_battlechatter;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;

	
#namespace cybercom_gadget_rapid_strike;

function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(1, 	(1<<6));
	callback::on_spawned( &on_player_spawned );
	
	level.cybercom.rapid_strike = spawnstruct();
	level.cybercom.rapid_strike._is_flickering  	= &_is_flickering;
	level.cybercom.rapid_strike._on_flicker 		= &_on_flicker;
	level.cybercom.rapid_strike._on_give 			= &_on_give;
	level.cybercom.rapid_strike._on_take 			= &_on_take;
	level.cybercom.rapid_strike._on_connect 		= &_on_connect;
	level.cybercom.rapid_strike._on 				= &_on;
	level.cybercom.rapid_strike._off 				= &_off;	
}

function on_player_spawned()
{
}

function _is_flickering( slot )
{
}
function _on_flicker( slot, weapon )
{
}
function _on_give( slot, weapon )
{
	self thread meleeListener(weapon);
}
function _on_take( slot, weapon )
{
	self notify("endmeleeListener");
}
function _on_connect()
{
}
function _on( slot, weapon )
{
}
function _off( slot, weapon )
{
}

function meleeListener(weapon)
{
	self notify("meleeListener");
	self endon("meleeListener");
	self endon("endmeleeListener");
	self endon("disconnect");
	while(1)
	{
		level waittill("rapid_strike", target,attacker,damage,weapon,hitOrigin);
		self notify(weapon.name+"_fired");
		level notify(weapon.name+"_fired");
		{wait(.05);};
		if(isDefined(target))
		{
		}
	}	
}
