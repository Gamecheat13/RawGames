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


                                                                                                             	     	                                                                                                                                                                


	// These sound low, but, the anim intro + outro time is 3 seconds





#precache( "fx", "electric/fx_ability_elec_sensory_ol_human");

#namespace cybercom_gadget_sensory_overload;

function init()
{
	clientfield::register( "actor", "sensory_overload", 1, 1, "int");
}

function main()
{
	cybercom_gadget::registerAbility(2, 	(1<<0));

	level._effect["sensory_disable_human"]				= "electric/fx_ability_elec_sensory_ol_human";
	level._effect["sensory_disable_human_riotshield"]	= "electric/fx_ability_elec_sensory_ol_human";
	level._effect["sensory_disable_warlord"]			= "electric/fx_ability_elec_sensory_ol_human";

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
	self.cybercom.target_count 				= GetDvarInt( "scr_sensory_overload_count", 3 );
	self.cybercom.sensory_overload_loops	= GetDvarInt( "scr_sensory_overload_loops", 1 );
	if(self hasCyberComAbility("cybercom_sensoryoverload")  == 2)
	{
		self.cybercom.target_count = GetDvarInt( "scr_sensory_overload_upgraded_count", 5 );
		self.cybercom.sensory_overload_loops 	= GetDvarInt( "scr_sensory_overload_upgraded_loops", 2 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
	
	self  cybercom::seedAnimationVariant("base_rifle_stn",8);
	self  cybercom::seedAnimationVariant("base_rifle_crc",2);
	self  cybercom::seedAnimationVariant("fem_rifle_stn",8);
	self  cybercom::seedAnimationVariant("fem_rifle_crc",2);
	
	
}

function _on_take( slot, weapon )
{
	self _off(slot,weapon);
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
	if( target cybercom::cybercom_AICheckOptOut("cybercom_sensoryoverload")) 
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if(( isdefined( target.is_disabled ) && target.is_disabled ))
	{
		self cybercom::cybercomSetFailHint(6);
		return false;
	}	
	if (isVehicle(target) || !isDefined(target.archetype) )
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
	
	if(target.archetype != "human" && target.archetype != "human_riotshield" && target.archetype !="warlord"  ) //ability only works on humans
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if(isActor(target) && target cybercom::getEntityPose() != "stand" && target cybercom::getEntityPose() !="crouch" )
		return false;
	
	if( isActor(target) && !(target IsOnGround()) && !(target cybercom::isInstantKill()) )
		return false;

	
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	return  ArrayCombine(GetAITeamArray( "axis"),GetAITeamArray( "team3"),false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_sensory_overload(slot,weapon)
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
				
				item.target thread sensory_overload(self);
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
#using_animtree( "generic" );

function ai_activateSensoryOverload(target,doCast=true)
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
		self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate", "normal", %root, 1, 0.3 );
		self waittillmatch( "ai_cybercom_anim", "fire" );
	}
	foreach(guy in validTargets)
	{
		if ( !cybercom::targetIsValid(guy) )
			continue;
		guy thread sensory_overload(self);
		{wait(.05);};
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function sensory_overload(attacker) //self is human target
{
	self endon("death");
	
	weapon = GetWeapon("gadget_sensory_overload");
	self notify("cybercom_action",weapon,attacker);
	
	if(isdefined(attacker.cybercom) && isDefined(attacker.cybercom.sensory_overload_loops))
	{
		loops = attacker.cybercom.sensory_overload_loops ;
	}
	else
	{
		loops = 1;
	}
	wait (RandomFloatRange(0,0.75));
	if ( !(attacker cybercom::targetIsValid(self) ))
		return;
	
	self clientfield::set( "sensory_overload",1 );
	
	if (self cybercom::isInstantKill())
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}	
	
	self OrientMode( "face default" );
	self.is_disabled = true;
	self.ignoreall = true;
	
	self playsound( "gdt_sensory_feedback_start" );
	
	if( isplayer( attacker ) && attacker hasCyberComAbility("cybercom_sensoryoverload") == 2 )
		self playloopsound( "gdt_sensory_feedback_lp_upg", .5 );
	else
		self playloopsound( "gdt_sensory_feedback_lp", .5 );
	
	self notify( "bhtn_action_notify", "reactSensory" );
	
	if(self.archetype == "warlord" )
	{
		self DoDamage( 2, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
		self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
		self clientfield::set( "sensory_overload",0 );
	}
	else
	if( self.archetype == "human_riotshield" )
	{
		   
		while(loops)
		{
			self DoDamage( 2, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
			self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
			loops--;
		}
		self clientfield::set( "sensory_overload",0 );
	}
	else
	{
		assert(self.archetype == "human" );
		
		base = "base_rifle";
		if((isdefined(self.voicePrefix) && ( GetSubStr(self.voicePrefix,7) == "f" )))
			base ="fem_rifle";
		
		type 	= self cybercom::getAnimPrefixForPose();
		variant = attacker cybercom::getAnimationVariant(base+"_"+type);
		
		self AnimScripted( "intro_anim", self.origin, self.angles, "ai_"+base+"_"+type+"_exposed_sens_overload_react_intro"+variant, "normal", %root, 1, 0.3);		
		self thread cybercom::stopAnimScriptedOnNotify("damage_pain","intro_anim",true,attacker,weapon);
		self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","intro_anim",true,attacker,weapon);
		self waittillmatch( "intro_anim", "end" );

		while(loops)
		{
			self PlayPainLoop( attacker, weapon, variant,base,type );
			loops--;
		}
		
		if(isAlive(self) && !(self isRagdoll()) )
		{
			self clientfield::set( "sensory_overload",0 );
			self AnimScripted( "restart_anim", self.origin, self.angles, "ai_"+base+"_"+type+"_exposed_sens_overload_react_outro"+variant, "normal", %root, 1, 0.3);		
			self thread cybercom::stopAnimScriptedOnNotify("damage_pain","restart_anim",true,attacker,weapon);
			self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","restart_anim",true,attacker,weapon);
			self waittillmatch( "restart_anim", "end" );
		}
	}
	self stoploopsound( .75 );
	
	self.is_disabled = undefined;
	self.ignoreall = false;
}

// Loop the pain animation until the designated loopTime is over.
function PlayPainLoop(attacker, weapon, variant, base, type)
{
	self endon("death");
	self AnimScripted( "sens_loop_anim", self.origin, self.angles, "ai_"+base+"_"+type+"_exposed_sens_overload_react_loop"+variant,"normal",%body,1,.2);		
	self thread cybercom::stopAnimScriptedOnNotify("damage_pain","sens_loop_anim",true,attacker,weapon);
	self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","sens_loop_anim",true,attacker,weapon);
	self waittillmatch( "sens_loop_anim", "end" );
}

