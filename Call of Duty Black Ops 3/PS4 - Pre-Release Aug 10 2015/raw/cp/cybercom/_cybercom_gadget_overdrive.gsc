/*
 * Created by ScriptDevelop.
 * User: dking
 * Date: 1/26/2015
 * Time: 4:14 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#using scripts\codescripts\struct;

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
#using scripts\shared\visionset_mgr_shared;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;
                              	                               	                    	                                 	                                        	                            	                                                                  	                             





#namespace cybercom_gadget_overdrive;

function init()
{
	
}

function main()
{
	cybercom_gadget::registerAbility(1,		(1<<4));

	level.cybercom.overdrive = spawnstruct();
	level.cybercom.overdrive._on_give 		= &_on_give;
	level.cybercom.overdrive._on_take 		= &_on_take;
	level.cybercom.overdrive._on 				= &_on;
	level.cybercom.overdrive._off 			= &_off;
}

function _on_flicker( slot, weapon )
{
}
function _on_give( slot, weapon )
{
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}
function _on_take( slot, weapon )
{
	_off( slot, weapon );
}
function _on_connect()
{
}
function _on_disconnect()
{
	self notify("overdrive_off");
}
function _on( slot, weapon )
{
	self endon("overdrive_off");
	self endon("death");
	self endon("disconnect");
	wait GetDvarFloat( "scr_overdrive_activationDelay_sec", .4 );
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_overdrive_on" );
		
		
	self.hadDeadShot = self HasPerk("specialty_deadshot");
	if(!( isdefined( self.hadDeadShot ) && self.hadDeadShot ))
		self SetPerk("specialty_deadshot");
	
	// Activation effects - pulse, flash, and FOV
	self clientfield::set_to_player( "overdrive_state", 1);
	visionset_mgr::activate( "visionset", "overdrive", self, 0.4, .1, 1.35 );
	
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	
	if( self.health < self.maxHealth * GetDvarFloat( "scr_overdrive_min_health", 0.35 ) )
	{
		self setnormalhealth( GetDvarFloat( "scr_overdrive_min_health", 0.35 ) );
	}	
	self PlayRumbleOnEntity( "tank_rumble" );
}
function _off( slot, weapon )
{
	self notify("overdrive_off");
	
	if(!( isdefined( self.hadDeadShot ) && self.hadDeadShot ))
		self UnSetPerk("specialty_deadshot");

	self clientfield::set_to_player( "overdrive_state", 0);
}
