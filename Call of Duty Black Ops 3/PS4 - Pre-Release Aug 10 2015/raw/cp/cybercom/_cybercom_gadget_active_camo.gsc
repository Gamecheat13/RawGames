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

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;





#namespace cybercom_gadget_active_camo;

function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(1,	(1<<3), true);

	level.cybercom.active_camo = spawnstruct();
	level.cybercom.active_camo._on_flicker 		= &_on_flicker;
	level.cybercom.active_camo._on_give 		= &_on_give;
	level.cybercom.active_camo._on_take 		= &_on_take;
	level.cybercom.active_camo._on_connect 		= &_on_connect;
	level.cybercom.active_camo._on 				= &_on;
	level.cybercom.active_camo._off 			= &_off;
	level.cybercom.active_cammo_upgraded_weap	= GetWeapon("gadget_active_camo_upgraded");
	callback::on_disconnect( &_on_disconnect );
	
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
	self notify("active_camo_off");
	self notify("active_camo_taken");
	self notify("delete_false_target");
}
function _on_connect()
{
}
function _on_disconnect()
{
	self notify("delete_false_target");
	self notify("active_camo_off");
	self notify("active_camo_taken");
}
function _on( slot, weapon )
{
	self endon("active_camo_off");
	self endon("death");
	self endon("disconnect");
	wait GetDvarFloat( "scr_active_camo_shaderDelay_sec", .4 );
	self clientfield::set( "camo_shader", 1 );
	cybercom::cybercomAbilityTurnedONNotify(weapon,true);

	self.cybercom.oldignore 	= self.ignoreme;
	self.ignoreme 	= true;
	self.active_camo = true;

/*	if(self hasCyberComAbility("cybercom_camo") == CCOM_STATUS_UPGRADED )
	{
		self thread _active_cammo_reactivate();
		self thread _camo_killReActivateOnNotify(slot,"weapon_fired");
		self thread _camo_killReActivateOnNotify(slot,"damage");
	}
*/	
	self PlayRumbleOnEntity( "tank_rumble" );
	self thread _forceOffOnNote(slot,weapon,"scene_disable_player_stuff","active_camo_taken");
	self thread _camo_createFalseTarget();
	self thread cybercom::gadgetOffOnNotify(slot,weapon,"changed_class","active_camo_off");
}
function _off( slot, weapon )
{
	self.ignoreme 	= self.cybercom.oldignore;
	self.active_camo = undefined;
		
	/#
	if(( isdefined( self.ignoreme ) && self.ignoreme ) )
	{
		IPrintLnBold( "!WARNING: Active Camo turning off, but player still set to ignore!" );
	}
	#/
	self notify("delete_false_target");
	self notify("active_camo_off");
}
function _forceOffOnNote( slot, weapon,waitnote, endnote )
{
	self notify(endnote + waitnote + weapon.name);
	self endon(endnote + waitnote + weapon.name);
	self endon(endnote);
	self endon("disconnect");
	self waittill(waitnote);
	if(self HasWeapon(weapon) &&
	   isDefined(self.cybercom.activeCybercomWeapon) &&
	   self.cybercom.activeCybercomWeapon == weapon )
	{
		self GadgetDeactivate( slot, weapon );
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _camo_killReActivateOnNotify(slot,note,durationMin=300,durationMax=1000)
{
	self endon("active_camo_taken");
	self endon("disconnect");
	self notify("_camo_killReActivateOnNotify"+slot+note);
	self endon("_camo_killReActivateOnNotify"+slot+note);
	while(1)
	{
		self waittill(note,param);
		self notify("kill_active_cammo_reactivate");
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _camo_createFalseTarget()
{
	self notify("delete_false_target");
	self endon("delete_false_target");
	fakeMe = Spawn( "script_model", self.origin );
	fakeMe SetModel( "tag_origin" );
	fakeMe MakeSentient();
	//fakeMe thread cybercom::drawOriginForever();
	fakeMe.origin +=(0,0,30);
	fakeMe.team = self.team;
	self thread cybercom::deleteEntOnNote("disconnect",fakeMe);
	self thread cybercom::deleteEntOnNote("active_camo_off",fakeMe);
	self thread cybercom::deleteEntOnNote("delete_false_target",fakeMe);
	self thread _camo_updateFalseTarget(fakeMe);
//	self thread cybercom::notifyMeInNSec("delete_false_target",RandomFloatRange(4,10));
	zMin = self.origin[2];
	while(isDefined(fakeMe))
	{
		fakeMe.origin +=(RandomIntRange(-50,50),RandomIntRange(-50,50),RandomIntRange(-5,5));
		if(fakeMe.origin[2] < zMin )
			fakeMe.origin = (fakeMe.origin[0],fakeMe.origin[1],zMin);
		wait .5;
	}
}

function private _camo_updateFalseTarget(fakeEnt)
{
	fakeEnt endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill( "weapon_fired", projectile );
		fakeEnt.origin = self.origin;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _active_cammo_reactivate()
{
	self notify("_active_cammo_reactivate");
	self endon("_active_cammo_reactivate");
	self endon("active_camo_taken");
	self endon("kill_active_cammo_reactivate");
	
	while(1)
	{
		self waittill("gadget_forced_off",slot,weapon);
		if ( isDefined(weapon) && weapon == level.cybercom.active_cammo_upgraded_weap )
		{
			wait GetDvarInt( "scr_active_camo_melee_escape_duration_SEC", 1 );
			if(! (self GadgetIsActive(slot)))
			{
				self GadgetActivate( slot, weapon, false );
			}
		}
	}
}
