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

#using scripts\shared\ai\systems\destructible_character;

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
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

#namespace cybercom_gadget_ravage_core;




function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(0,	(1<<4));

	level.cybercom.ravage_core = spawnstruct();
	level.cybercom.ravage_core._is_flickering  	= &_is_flickering;
	level.cybercom.ravage_core._on_flicker 		= &_on_flicker;
	level.cybercom.ravage_core._on_give 			= &_on_give;
	level.cybercom.ravage_core._on_take 			= &_on_take;
	level.cybercom.ravage_core._on_connect 		= &_on_connect;
	level.cybercom.ravage_core._on 				= &_on;
	level.cybercom.ravage_core._off 				= &_off;
	
	level.cybercom.ravage_core.weapon		= GetWeapon("gadget_ravage_core");
	callback::on_spawned( &on_player_spawned );
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
		level waittill("ravage_core", target,attacker,damage,weapon,hitOrigin);
		self notify("ravage_core",target,damage,weapon);
		DestructServerUtils::DestructHitLocPieces( target, "torso_upper" ); // Break off the robot's torso door.
		self notify(weapon.name+"_fired");
		level notify(weapon.name+"_fired");
		target HidePart( "j_chest_door" );
		target thread  _corpseWatcher();
		target ai::set_behavior_attribute( "robot_lights", 1 );
		self waittill("grenade_fire");
		self notify("ravage_end");
	}	
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _corpseWatcher()
{
 	self waittill("actor_corpse", corpse);
 	if(isDefined(corpse))
 	{
		corpse HidePart( "j_chest_door" );
	}
}