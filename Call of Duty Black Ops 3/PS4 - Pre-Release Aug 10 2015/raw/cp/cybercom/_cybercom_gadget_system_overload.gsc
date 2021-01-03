#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
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

#using scripts\shared\ai\systems\blackboard;

                                                                                                             	     	                                                                                                                                                                

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           

	// These sound low, but, the anim intro + outro time is 3 seconds






#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "electric/fx_ability_elec_startup_robot");
	


#namespace cybercom_gadget_system_overload;

function init()
{

}

function main()
{
	cybercom_gadget::registerAbility(0, 	(1<<0));

	level._effect["overload_disable"]			= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["overload_recover_robot"]		= "electric/fx_ability_elec_startup_robot";

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
	self.cybercom.target_count 		= GetDvarInt( "scr_system_overload_count", 3 );
	self.cybercom.system_overload_lifetime			= GetDvarInt( "scr_system_overload_lifetime", 3 )*1000;
	if(self hasCyberComAbility("cybercom_systemoverload")  == 2)
	{
		self.cybercom.target_count 		= GetDvarInt( "scr_system_overload_upgraded_count", 5 );
		self.cybercom.system_overload_lifetime 			= GetDvarInt( "scr_system_overload_upgraded_lifetime", 6 )*1000;
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
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
	self thread cybercom::weaponEndLockWatcher( weapon );
	self.cybercom.is_primed = undefined;
	self notify( "cybercom_systemoverload_off" );
}

function _is_primed( slot, weapon )
{
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		assert (self.cybercom.activeCybercomWeapon == weapon);
		self notify( "cybercom_systemoverload_primed" );
		self thread cybercom::weaponLockWatcher(slot, weapon, self.cybercom.target_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( !isdefined( target ) )
		return false;
	
	if( target cybercom::cybercom_AICheckOptOut("cybercom_systemoverload"))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
	
	if(( isdefined( target.hijacked ) && target.hijacked ))
	{
		self cybercom::cybercomSetFailHint(3);
		return false;
	}
	
	if(( isdefined( target.is_disabled ) && target.is_disabled ))
	{
		self cybercom::cybercomSetFailHint(6);
		return false;
	}
	
	if(isActor(target) && target cybercom::getEntityPose() != "stand" && target cybercom::getEntityPose() !="crouch" )
		return false;
	
	if(isActor(target) && target.archetype != "robot")
	{
		self cybercom::cybercomSetFailHint(1);
		return false;	
	}

	if(!isActor(target) && !isVehicle(target))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if( isActor(target) && !(target IsOnGround()) && !(target cybercom::isInstantKill()) )
		return false;
	
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	return ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);//GetVehicleTeamArray( "axis" );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_system_overload(slot,weapon)
{
	aborted = 0;
	fired 	= 0;
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if (item.inRange == 1)
			{
				if ( !cybercom::targetIsValid(item.target) )
					continue;
				
				item.target thread system_overload(self,undefined,weapon);
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
function private _system_overload_vehicle(attacker, weapon ) //self is vehicle
{
	if(isDefined(self.disabled_cooldown) && GetTime() < self.disabled_cooldown )
		return;
	
	playfx( level._effect["overload_disable"], self.origin );
//	self kill();
	
	self stopsounds();
	
	damage = 5;
	
	//audio for veh shutdown
	if(isDefined(self.archetype))
	{
		if (self.archetype == "wasp")
		{
			self playsound("gdt_cybercore_wasp_shutdown");
			damage = 25;	// Needs to get close to killing wasps so they die when they hit the ground
		}
		if (self.archetype == "raps")
		{
			self playsound("veh_raps_skid");
		}	
		if (self.archetype == "turret")
		{
			self playsound("gdt_cybercore_turret_shutdown");
		}			
		if (self.archetype == "amws")
		{
			self playsound("gdt_cybercore_amws_shutdown");
		}		
		
	}
	
	self DoDamage( damage, self.origin, attacker, undefined, "none", "MOD_GRENADE_SPLASH", 0, GetWeapon("emp_grenade"),-1,true);
	self.disabled_cooldown = GetTime() + GetDvarInt( "scr_system_overload_vehicle_cooldown_seconds", 5 ) * 1000;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateSystemOverload(target,doCast=true,disableTimeMSEC)
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

	if(( isdefined( doCast ) && doCast ))
	{
		type =self cybercom::getAnimPrefixForPose();
	
		self OrientMode( "face default" );
		self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );		
		self waittillmatch( "ai_cybercom_anim", "fire" );
	}
	foreach(guy in validTargets)
	{
		if ( !cybercom::targetIsValid(guy) )
			continue;
		guy thread system_overload(self,disableTimeMSEC);
		{wait(.05);};
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function system_overload(attacker,disableTimeMSEC,weapon,checkValid=true) //self is robot
{
	self endon("death");

	self notify("cybercom_action",weapon,attacker);
	
	if( isVehicle(self) )
	{
		self thread _system_overload_vehicle(attacker, weapon);
		return;
	}
	
	if( !cybercom::hasBothLegs(self) )
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}	
	
	if (self cybercom::isInstantKill())
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}
	self.is_disabled = true;

	
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
		disableTime = GetDvarInt( "scr_system_overload_lifetime", 3 )*1000;
	}
	wait (RandomFloatRange(0,0.75));


	disableFor = GetTime()+disableTime+ (RandomInt(4000)); //upto 4 seconds of random delay
	
	playfxontag(level._effect["overload_disable"], self,"j_neck" );
	self playsound ("fly_bot_disable");
	
	type =self cybercom::getAnimPrefixForPose();
	isCrouching = type == "crc";
	isMarching = false;
	previousGoalPos = self.pathGoalPos;
	
	if ( self ai::has_behavior_attribute( "move_mode" ) )
	{
		isMarching = self ai::get_behavior_attribute( "move_mode" ) == "marching";
	}
	
	weapon = GetWeapon("gadget_system_overload");//force the weapon; special pain animations 
	
	self OrientMode( "face default" );
	self ai::set_behavior_attribute( "robot_lights", 1 );
	self AnimScripted( "shutdown_anim", self.origin, self.angles, "ai_robot_base_"+type+"_shutdown", "normal", %root, 1, 0.2 );		
	self thread cybercom::stopAnimScriptedOnNotify("damage_pain","shutdown_anim",true,attacker,weapon);
	self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","shutdown_anim",true,attacker,weapon);
	self waittillmatch( "shutdown_anim", "end" );
	waittillframeend;
	self ai::set_behavior_attribute( "robot_lights", 2 );
	self.ignoreall = true;
	while(GetTime()<disableFor )
	{
		if ( isCrouching )
		{
			Blackboard::SetBlackBoardAttribute( self, "_stance", "crouch" );
		}
		self DoDamage( 2, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
		self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
	}
	if(isAlive(self) && !(self isRagdoll()) )
	{
		self ai::set_behavior_attribute( "robot_lights", 0 );
		self.ignoreall = false;
		playfxontag(level._effect["overload_recover_robot"], self,"j_spine4" );
		self playsound ("fly_bot_reboot");
		self AnimScripted( "restart_anim", self.origin, self.angles, "ai_robot_base_"+type+"_shutdown_2_alert" );		
		self thread cybercom::stopAnimScriptedOnNotify("damage_pain","restart_anim",true,attacker,weapon);
		self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","restart_anim",true,attacker,weapon);
		self waittillmatch( "restart_anim", "end" );
		if ( isCrouching )
		{
			Blackboard::SetBlackBoardAttribute( self, "_stance", "crouch" );
		}
		if ( isMarching )
		{
			self ai::set_behavior_attribute( "move_mode", "marching" );
		}
		if ( IsDefined( previousGoalPos ) )
		{
			// AnimScripted clears the previous goal position, reassign it.
			self UsePosition( previousGoalPos );
			self ClearPath();
		}
		self.is_disabled = undefined;
	}
}

