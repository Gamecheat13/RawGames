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

                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;


                                                                                                            	   	








#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "explosions/fx_exp_grenade_flshbng");

#namespace cybercom_gadget_system_overload;

function init()
{

}

function main()
{
	cybercom_gadget::registerAbility(0, 	(1<<0));

	level._effect["overload_disable"]			= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["overload_disable_revert"]	= "explosions/fx_exp_grenade_flshbng";

	level.cybercom.system_overload = spawnstruct();
	level.cybercom.system_overload._is_flickering  	= &_is_flickering;
	level.cybercom.system_overload._on_flicker 		= &_on_flicker;
	level.cybercom.system_overload._on_give 		= &_on_give;
	level.cybercom.system_overload._on_take 		= &_on_take;
	level.cybercom.system_overload._on_connect 		= &_on_connect;
	level.cybercom.system_overload._on 				= &_on;
	level.cybercom.system_overload._off 			= &_off;
	level.cybercom.system_overload._is_primed 		= &_is_primed;
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
	// executed when gadget is added to the players inventory
	self.cybercom.weapon 							= weapon;
	self.cybercom.system_overload_target_count 		= GetDvarInt( "scr_system_overload_count", 3 );
	self.cybercom.system_overload_lifetime			= GetDvarInt( "scr_system_overload_lifetime", 4 )*1000;
	if(self hasCyberComAbility("cybercom_systemoverload")  == 2)
	{
		self.cybercom.system_overload_target_count 		= GetDvarInt( "scr_system_overload_upgraded_count", 5 );
		self.cybercom.system_overload_lifetime 			= GetDvarInt( "scr_system_overload_upgraded_lifetime", 8 )*1000;
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
}

function _on_take( slot, weapon )
{
	self _off( slot, weapon );
	self.cybercom.is_primed = undefined;
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self thread _activate_system_overload(slot,weapon);
	self _off( slot, weapon );
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self thread cybercom::weaponEndLockWatcher();
	self.cybercom.is_primed = undefined;
}

function _is_primed( slot, weapon )
{
	//self thread gadget_flashback_start( slot, weapon );
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.system_overload_target_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_systemoverload")) 
		return false;

	if( isActor(target) && target.a.pose !="stand" && target.a.pose !="crouch" )
		return false;
	
	if(isActor(target) && target.archetype != "robot")
		return false;	

	if(!isActor(target) && !isVehicle(target))
		return false;
	
	if(( isdefined( target.is_disabled ) && target.is_disabled ))
		return false;

	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	prospects = ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);//GetVehicleTeamArray( "axis" );
	valid	  = [];
	
	foreach (enemy in prospects)
	{
		if(isVehicle(enemy) || (isActor(enemy) && isDefined(enemy.archetype) && enemy.archetype == "robot") )
			valid[valid.size] = enemy;
	}
	return valid;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_system_overload(slot,weapon)
{
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	
	if ( !isDefined(self.cybercom.lock_targets) || self.cybercom.lock_targets.size == 0 )
	{	//player has the buttons down, and just released, no targets, what to do? 
		//Feedback UI
		//Feedback Audio
		//do we incur the cost of firing the weapon? Seems like we shouldnt
	}
	
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ))
		{
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			if( isVehicle(item.target) )
			{
				item.target thread _system_overload_vehicle(self, weapon);
			}
			else
			{
				item.target thread system_overload_robot(self);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _system_overload_vehicle(attacker, weapon ) //self is vehicle
{
	playfx( level._effect["overload_disable"], self.origin );
//	self kill();
	self DoDamage( 5, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, GetWeapon("emp_grenade"),-1,true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateSystemOverload(target,disableTimeMSEC)
{
	if (!isDefined(target))
		return;
	
	if(self.archetype != "human" ) 
		return;

	validTargets = [];

	if(isArray(target))
	{
		foreach(guy in target)
		{
			if (!_lock_requirement(guy))
				continue;
			validTargets[validTargets.size] = guy;
		}
	}
	else
	{
		if (!_lock_requirement(target))
			return;
		validTargets[validTargets.size] = target;
	}

	if(self.a.pose =="stand")
		type = "stn";
	else
		type = "crc";

	self OrientMode( "face default" );
	self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );		
	self waittillmatch( "ai_cybercom_anim", "fire" );
	foreach(guy in validTargets)
	{
		if ( !cybercom::targetIsValid(guy) )
			continue;
		if(isVehicle(guy))
		{
			guy thread _system_overload_vehicle(self);
		}
		else
		{
			guy thread system_overload_robot(self,disableTimeMSEC);
		}
		{wait(.05);};
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function system_overload_robot(attacker,disableTimeMSEC,weapon,checkValid=true) //self is robot
{
	self endon("death");
	
	if( ( isdefined( self.missingLegs ) && self.missingLegs ) || ( isdefined( self.isCrawler ) && self.isCrawler ) )
	{
		self Kill();
		return;
	}
			
	if(isDefined(disableTimeMSEC))
	{
		disableTime = disableTimeMSEC;
	}
	else
	if(isDefined(attacker.cybercom) && isDefined(attacker.cybercom.system_overload_lifetime))
	{
		disableTime = attacker.cybercom.system_overload_lifetime ;
	}
	else
	{
		disableTime = GetDvarInt( "scr_system_overload_lifetime", 4 )*1000;
	}
	wait (RandomFloatRange(0,0.75));
	if (checkValid && !(attacker cybercom::targetIsValid(self) ))
		return;
	disableFor = GetTime()+disableTime+ (RandomInt(4000)); //upto 4 seconds of random delay
	self.is_disabled = true;
	
	playfxontag(level._effect["overload_disable"], self,"j_neck" );
	if(self.a.pose =="stand")
	{
		type = "stn";
	}
	else
	{
		type = "crc";
	}
	if(!isDefined(weapon))
		weapon = GetWeapon("gadget_system_overload");
	
	self OrientMode( "face default" );
	self AnimScripted( "shutdown_anim", self.origin, self.angles, "ai_robot_base_"+type+"_shutdown" );		
	self thread cybercom::stopAnimScriptedOnNotify("damage","shutdown_anim");
	self waittillmatch( "shutdown_anim", "end" );
	self.ignoreall = true;
	while(GetTime()<disableFor )
	{
		if (!self cybercom::isTurretDude())
		{
			self DoDamage( 2, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
			self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
		}
		else
		{
			self AnimScripted( "shutdown_idle", self.origin, self.angles, "ai_robot_base_"+type+"_shutdown_idle" );		
			self thread cybercom::stopAnimScriptedOnNotify("damage","shutdown_idle");
			self waittillmatch( "shutdown_idle", "end" );
		}
	}
	self.ignoreall = false;
	playfxontag(level._effect["overload_disable_revert"], self,"j_neck" );
	self AnimScripted( "restart_anim", self.origin, self.angles, "ai_robot_base_"+type+"_shutdown_2_alert" );		
	self thread cybercom::stopAnimScriptedOnNotify("damage","restart_anim");
	self waittillmatch( "restart_anim", "end" );
	self.is_disabled = undefined;
}
