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


                                                                                                            	   	








#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "explosions/fx_exp_grenade_flshbng");

#namespace cybercom_gadget_sensory_overload;

function init()
{

}

function main()
{
	cybercom_gadget::registerAbility(2, 	(1<<0));

	level._effect["sensory_disable"]			= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["sensory_disable_revert"]	= "explosions/fx_exp_grenade_flshbng";

	level.cybercom.sensory_overload = spawnstruct();
	level.cybercom.sensory_overload._is_flickering  = &_is_flickering;
	level.cybercom.sensory_overload._on_flicker 	= &_on_flicker;
	level.cybercom.sensory_overload._on_give 		= &_on_give;
	level.cybercom.sensory_overload._on_take 		= &_on_take;
	level.cybercom.sensory_overload._on_connect 	= &_on_connect;
	level.cybercom.sensory_overload._on 			= &_on;
	level.cybercom.sensory_overload._off 			= &_off;
	level.cybercom.sensory_overload._is_primed 		= &_is_primed;
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
	self.cybercom.weapon 					= weapon;
	self.cybercom.sensory_overload_target_count 	= GetDvarInt( "scr_sensory_overload_count", 3 );
	self.cybercom.sensory_overload_lifetime			= GetDvarInt( "scr_sensory_overload_lifetime", 8 )*1000;
	if(self hasCyberComAbility("cybercom_sensoryoverload")  == 2)
	{
		self.cybercom.sensory_overload_target_count = GetDvarInt( "scr_sensory_overload_upgraded_count", 5 );
		self.cybercom.sensory_overload_lifetime 	= GetDvarInt( "scr_sensory_overload_upgraded_lifetime", 15 )*1000;
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
}

function _on_take( slot, weapon )
{
	self _off(slot,weapon);
	self.cybercom.weapon	= undefined;
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
	self thread _activate_sensory_overload(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.sensory_overload_target_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_sensoryoverload")) 
		return false;

	if(target.archetype != "human" ) //ability only works on humans
		return false;

	if(target.a.pose !="stand" && target.a.pose !="crouch" )
		return false;
	
	if(( isdefined( target.is_disabled ) && target.is_disabled ))
		return false;

	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	return  ArrayCombine(GetAISpeciesArray( "axis", "human" ),GetAISpeciesArray( "team3", "human" ),false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_sensory_overload(slot,weapon)
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
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			item.target thread sensory_overload(self);
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateSensoryOverload(target,disableTimeMSEC)
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
		guy thread sensory_overload(self,disableTimeMSEC);
		{wait(.05);};
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function sensory_overload(attacker,disableTimeMSEC) //self is human target
{
	self endon("death");
	
	if(isDefined(disableTimeMSEC))
	{
		disableTime = disableTimeMSEC;
	}
	else
	if(isdefined(attacker.cybercom) && isDefined(attacker.cybercom.sensory_overload_lifetime))
	{
		disableTime = attacker.cybercom.sensory_overload_lifetime ;
	}
	else
	{
		disableTime = GetDvarInt( "scr_sensory_overload_lifetime", 8 )*1000;
	}
	wait (RandomFloatRange(0,0.75));
	if ( !(attacker cybercom::targetIsValid(self) ))
		return;
	disableFor = GetTime()+disableTime + RandomInt(4000);
	self.is_disabled = true;
	self.ignoreall = true;
	playfxontag(level._effect["sensory_disable"], self,"j_neck" );
	
	weapon = GetWeapon("gadget_sensory_overload");
	
	self OrientMode( "face default" );
	
	if (!self cybercom::isTurretDude())
	{
		base = "base";
		if((isdefined(self.voicePrefix) && ( GetSubStr(self.voicePrefix,7) == "f" )))
			base ="fem";
		
		if(self.a.pose =="stand")
			type = "stn";
		else
			type = "crc";
		self AnimScripted( "intro_anim", self.origin, self.angles, "ai_"+base+"_rifle_"+type+"_exposed_sens_overload_react_intro"+cybercom::getAnimationVariant() );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","intro_anim");
		self waittillmatch( "intro_anim", "end" );
		while(GetTime()<disableFor )
		{
			self DoDamage( 2, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
			self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
		}
		playfxontag(level._effect["sensory_disable_revert"], self,"j_neck" );
		self AnimScripted( "restart_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_sens_overload_react_outro"+cybercom::getAnimationVariant() );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","restart_anim");
		self waittillmatch( "restart_anim", "end" );
	}
	else
	{
		self AnimScripted( "intro_anim", self.origin, self.angles, "ai_crew_pickup_54i_turret_sens_overload_react_intro" );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","intro_anim");
		self waittillmatch( "intro_anim", "end" );
		while(GetTime()<disableFor )
		{
			self AnimScripted( "sensory_loop_anim", self.origin, self.angles,"ai_crew_pickup_54i_turret_sens_overload_react_loop" );		
			self thread cybercom::stopAnimScriptedOnNotify("damage","sensory_loop_anim");
			self waittillmatch( "sensory_loop_anim", "end" );
		}
		playfxontag(level._effect["sensory_disable_revert"], self,"j_neck" );
		self AnimScripted( "outro_anim", self.origin, self.angles, "ai_crew_pickup_54i_turret_sens_overload_react_outro");		
		self thread cybercom::stopAnimScriptedOnNotify("damage","outro_anim");
		self waittillmatch( "outro_anim", "end" );
	}
	self.is_disabled = undefined;
	self.ignoreall = false;
}
