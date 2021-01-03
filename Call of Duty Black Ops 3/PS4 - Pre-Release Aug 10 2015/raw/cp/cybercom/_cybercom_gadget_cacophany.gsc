#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
            	      	   	    	           	        	        	                                    	                                                                                                                               	              	                                                                                                                            	          	         	                        
#using scripts\shared\system_shared;

#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\math_shared;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;


#namespace cybercom_gadget_cacophany;





	

	
function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(2, 	(1<<4));

	level.cybercom.cacophany = spawnstruct();
	level.cybercom.cacophany._is_flickering  = &_is_flickering;
	level.cybercom.cacophany._on_flicker 	= &_on_flicker;
	level.cybercom.cacophany._on_give 		= &_on_give;
	level.cybercom.cacophany._on_take 		= &_on_take;
	level.cybercom.cacophany._on_connect 	= &_on_connect;
	level.cybercom.cacophany._on 			= &_on;
	level.cybercom.cacophany._off 			= &_off;
	level.cybercom.cacophany._is_primed 	= &_is_primed;
}

function _is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function _on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function _on_give( slot, weapon )
{
	self.cybercom.target_count = GetDvarInt( "scr_cacophany_count", 4 );
	self.cybercom.dotTolerance = GetDvarFloat( "scr_cacophany_fov", .95 );
	self.cybercom.lockRadius = GetDvarFloat( "scr_cacophany_lock_radius", 330 );
	// executed when gadget is added to the players inventory
	if(self hasCyberComAbility("cybercom_cacophany")  == 2)
	{
		self.cybercom.target_count = GetDvarInt( "scr_cacophany_upgraded_count", 5 );
		self.cybercom.dotTolerance = GetDvarFloat( "scr_cacophany_upgraded_fov", .5 );
		self.cybercom.lockRadius = GetDvarFloat( "scr_cacophany_lock_radius", 330 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}

function _on_take( slot, weapon )
{
	self _off(slot,weapon);
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
	self.cybercom.dotTolerance = undefined;//45degree
	self.cybercom.lockRadius = undefined;
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self thread _activate_cacophany(slot,weapon);
	self _off( slot, weapon );
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self thread cybercom::weaponEndLockWatcher( weapon );
	self.cybercom.is_primed = undefined;
}

function _is_primed( slot, weapon )
{
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		assert (self.cybercom.activeCybercomWeapon == weapon);
		self thread cybercom::weaponLockWatcher(slot, weapon, self.cybercom.target_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_cacophany")) 
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if (isDefined(target.destroyingweapon))
		return false;
	
	if (( isdefined( target.cacophanized ) && target.cacophanized ))
		return false;
	
	if(( isdefined( target.is_disabled ) && target.is_disabled ))
	{
		self cybercom::cybercomSetFailHint(6);
		return false;
	}	

	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	return 	GetEntArray( "destructible", "targetname" );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_cacophany(slot,weapon)
{
	aborted  = 0;
	fired = 0;
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if (item.inRange == 1)
			{
				if ( !cybercom::targetIsValid(item.target) )
					continue;
				
				item.target thread cacophanize(self,fired);
				fired++;
			}
			else
			if (item.inRange == 2)
			{//aborted
				aborted++;
			}
		}
	}
	if(aborted && !fired )
	{
		self.cybercom.lock_targets = [];
		self cybercom::cybercomSetFailHint(4,false);
	}
	cybercom::cybercomAbilityTurnedONNotify(weapon,fired);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cacophanize(attacker,offset) 
{
	if(offset == 0 )
	{
		wait 0.1;
	}
	else
	{
		time_until_detonate = 0.15 + (RandomFloatRange(0.1,0.25)*offset);
		wait time_until_detonate;
	}
	self doDamage(self.health+100,self.origin,attacker,attacker);
	self.cacophanized = true;
}
