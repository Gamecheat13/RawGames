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






#namespace cybercom_gadget_exosuitbreakdown;


#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "explosions/fx_exp_grenade_flshbng");


function init()
{

}

function main()
{
	cybercom_gadget::registerAbility(0, 	(1<<2));

	level._effect["exo_disable"]			= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["exo_disable_revert"]		= "explosions/fx_exp_grenade_flshbng";

	level.cybercom.exo_breakdown = spawnstruct();
	level.cybercom.exo_breakdown._is_flickering = &_is_flickering;
	level.cybercom.exo_breakdown._on_flicker 	= &_on_flicker;
	level.cybercom.exo_breakdown._on_give 		= &_on_give;
	level.cybercom.exo_breakdown._on_take 		= &_on_take;
	level.cybercom.exo_breakdown._on_connect 	= &_on_connect;
	level.cybercom.exo_breakdown._on 			= &_on;
	level.cybercom.exo_breakdown._off		 	= &_off;
	level.cybercom.exo_breakdown._is_primed 	= &_is_primed;
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
	self.cybercom.weapon 							= weapon;
	self.cybercom.exo_breakdown_target_count 		= GetDvarInt( "scr_exo_breakdown_count", 1 );
	self.cybercom.exo_breakdown_lifetime 			= GetDvarInt( "scr_exo_breakdown_lifetime", 8 )*1000;
	if(self hasCyberComAbility("cybercom_exosuitbreakdown")  == 2)
	{
		self.cybercom.exo_breakdown_target_count 	= GetDvarInt( "scr_exo_breakdown_upgraded_count", 2 );
		self.cybercom.exo_breakdown_lifetime 		= GetDvarInt( "scr_exo_breakdown_upgraded_lifetime", 12 )*1000;
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
	self thread _activate_exo_breakdown(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.exo_breakdown_target_count);
		self.cybercom.is_primed = true;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_exosuitbreakdown"))
		return false;

	if(target.a.pose != "stand" && target.a.pose !="crouch" )
		return false;
	
	if(target.archetype != "human" )
		return false;
	
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	return  ArrayCombine(GetAISpeciesArray( "axis", "human" ),GetAISpeciesArray( "team3", "human" ),false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _activate_exo_breakdown(slot, weapon)
{
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	
	if ( !isDefined(self.cybercom.lock_targets) || self.cybercom.lock_targets.size == 0 )
	{	//player has the buttons down, and just released, no targets, what to do? 
		//Feedback UI
		//Feedback Audio
		//do we incur the cost of firing the weapon? Seems like we shouldnt
	}
	foreach(item in self.cybercom.lock_targets )
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ))
		{
			// Ensure target validity.
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			
			item.target thread _exo_breakdown(self);
		}
	}	
}	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateExoSuitBreakdown(target,disableTimeMSEC)
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
		guy thread _exo_breakdown(self,disableTimeMSEC);
		{wait(.05);};
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _exo_breakdown(attacker,disableTimeMSEC) //self is guy
{
	self endon("death");
	
	if(isDefined(disableTimeMSEC))
	{
		disableTime = disableTimeMSEC;
	}
	else
	if(isDefined(attacker.cybercom) && isDefined(attacker.cybercom.exo_breakdown_lifetime))
	{
		disableTime = attacker.cybercom.exo_breakdown_lifetime ;
	}
	else
	{
		disableTime = GetDvarInt( "scr_exo_breakdown_lifetime", 8 )*1000;
	}
	wait (RandomFloatRange(0,0.75));
	if ( !(attacker cybercom::targetIsValid(self) ))
		return;
	disableFor = GetTime()+disableTime + RandomInt(4000);
	self.is_disabled = true;
	self.ignoreall = true;
	playfx(level._effect["exo_disable"], self.origin );

	if (!self cybercom::isTurretDude())
	{
		weapon = GetWeapon("gadget_exo_breakdown");
		
		base = "base";
		if((isdefined(self.voicePrefix) && ( GetSubStr(self.voicePrefix,7) == "f" )))
			base ="fem";
			
		if(self.a.pose =="stand")
			type = "stn";
		else
		if(self.a.pose =="crouch")
			type = "crc";

		self OrientMode( "face default" );
		self AnimScripted( "exo_intro_anim", self.origin, self.angles, "ai_"+base+"_rifle_"+type+"_exposed_suit_overload_react_intro"+cybercom::getAnimationVariant());		
		self thread cybercom::stopAnimScriptedOnNotify("damage","exo_intro_anim");
		self waittillmatch( "exo_intro_anim", "end" );
	
		while(GetTime()<disableFor )
		{
			self DoDamage( 2, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
			self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
		}
		playfx(level._effect["exo_disable_revert"], self.origin );
		self AnimScripted( "exo_outro_anim", self.origin, self.angles, "ai_"+base+"_rifle_"+type+"_exposed_suit_overload_react_outro"+cybercom::getAnimationVariant());	
		self thread cybercom::stopAnimScriptedOnNotify("damage","exo_outro_anim");
		self waittillmatch( "exo_outro_anim", "end" );
	}	
	else
	{
		self AnimScripted( "exo_intro_anim", self.origin, self.angles, "ai_crew_pickup_54i_turret_suit_overload_intro" );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","exo_intro_anim");
		self waittillmatch( "exo_intro_anim", "end" );
		self Unlink();
		self startragdoll();
		self kill();
		return;
		/*
		while(GetTime()<disableFor && isAlive(attacker) )
		{
			self AnimScripted( "exo_loop_anim", self.origin, self.angles, "ai_crew_pickup_54i_turret_suit_overload_loop" );		
			self thread cybercom::stopAnimScriptedOnNotify("damage");
			self waittillmatch( "exo_loop_anim", "end" );
		}
		self AnimScripted( "exo_outro_anim", self.origin, self.angles, "ai_crew_pickup_54i_turret_suit_overload_outro" );		
		self waittillmatch( "exo_outro_anim", "end" );
		*/
	}
	self.ignoreall = false;
	self.is_disabled = undefined;
}
