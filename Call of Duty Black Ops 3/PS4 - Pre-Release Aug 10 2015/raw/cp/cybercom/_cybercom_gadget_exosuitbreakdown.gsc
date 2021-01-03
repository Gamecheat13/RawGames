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
//#precache( "fx", "explosions/fx_exp_grenade_flshbng");


function init()
{

}

function main()
{
	cybercom_gadget::registerAbility(0, 	(1<<2));

//	level._effect["exo_disable"]					= "electric/fx_elec_sparks_burst_lg_os";
//	level._effect["exo_disable_revert"]				= "explosions/fx_exp_grenade_flshbng";
//	level._effect["exo_disable_warlord"]			= "electric/fx_elec_sparks_burst_lg_os";
//	level._effect["exo_disable_revert_warlord"]		= "explosions/fx_exp_grenade_flshbng";

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
	self.cybercom.target_count 					= GetDvarInt( "scr_exo_breakdown_count", 1 );
	self.cybercom.exo_breakdown_loops 			= GetDvarInt( "scr_exo_breakdown_loops", 1 );
	if(self hasCyberComAbility("cybercom_exosuitbreakdown")  == 2)
	{
		self.cybercom.target_count 				= GetDvarInt( "scr_exo_breakdown_upgraded_count", 2 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
	
	self  cybercom::seedAnimationVariant("base_rifle_stn",8);
	self  cybercom::seedAnimationVariant("base_rifle_crc",2);
	self  cybercom::seedAnimationVariant("fem_rifle_stn",8);
	self  cybercom::seedAnimationVariant("fem_rifle_crc",2);
	self  cybercom::seedAnimationVariant("riotshield",2);
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
	self thread _activate_exo_breakdown(slot,weapon);
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
	//self thread gadget_flashback_start( slot, weapon );
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
	if( target cybercom::cybercom_AICheckOptOut("cybercom_exosuitbreakdown"))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
	
	if(( isdefined( target.is_disabled ) && target.is_disabled ))
	{
		self cybercom::cybercomSetFailHint(6);
		return false;
	}
	
	if(isActor(target) && target cybercom::getEntityPose() != "stand" && target cybercom::getEntityPose() !="crouch" )
		return false;

	if(isVehicle(target))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
		
	if(!isDefined(target.archetype ) || (target.archetype != "human" && target.archetype != "human_riotshield" && target.archetype != "warlord") )
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	
	if( isActor(target) && !(target IsOnGround()) && !(target cybercom::isInstantKill()))
		return false;
	
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	return  ArrayCombine(GetAITeamArray( "axis"),GetAITeamArray( "team3"),false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _activate_exo_breakdown(slot, weapon)
{
	aborted = 0;
	fired 	= 0;
	
	foreach(item in self.cybercom.lock_targets )
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ))
		{
			if (item.inRange == 1)
			{
				// Ensure target validity.
				if ( !cybercom::targetIsValid(item.target) )
					continue;
				
				item.target thread _exo_breakdown(self);
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

function ai_activateExoSuitBreakdown(target,doCast=true)
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
		guy thread _exo_breakdown(self);
		{wait(.05);};
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _exo_breakdownWarlord(attacker,loops,weapon) //self is guy
{
	self endon("death");
	self.is_disabled = true;
	self.ignoreall = true;
	while(loops)
	{
		self DoDamage(5,self.origin,(isDefined(attacker)?attacker:undefined),undefined,"none","MOD_UNKNOWN",0,weapon,-1,true);
		self waittillmatch("bhtn_action_terminate", "specialpain" );
		loops--;
	}

	self.ignoreall = false;
	self.is_disabled = undefined;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _exo_breakdown(attacker) //self is guy
{
	self endon("death");
	
	weapon = GetWeapon("gadget_exo_breakdown");
	self notify("cybercom_action",weapon,attacker);
	
	if(attacker hasCyberComAbility("cybercom_exosuitbreakdown")  == 2)
	{
		if( isdefined( self.voicePrefix ) && isdefined( self.bcVoiceNumber ) )
		{
			self playsound( self.voicePrefix + self.bcVoiceNumber + "_exert_breakdown_pain" );
		}
	}
	if(isDefined(attacker.cybercom) && isDefined(attacker.cybercom.exo_breakdown_lifetime))
	{
		loops = self.cybercom.exo_breakdown_loops;
	}
	else
	{
		loops = 1;
	}
	wait (RandomFloatRange(0,0.75));
	if ( !(attacker cybercom::targetIsValid(self) ))
		return;
	
	if (self cybercom::isInstantKill() )
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined));
		return;
	}
	
	self notify( "bhtn_action_notify", "reactExosuit" );
	
	if(self.archetype == "warlord" )
	{
		self thread _exo_breakdownWarlord(attacker,1,weapon);
		return;
	}
	

	self.is_disabled = true;
	self.ignoreall = true;
//	playfx(level._effect["exo_disable"], self.origin );

	
	if(isPlayer(attacker) && attacker hasCyberComAbility("cybercom_exosuitbreakdown")  == 2)
	{
		self DoDamage( self.health+666, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
		return;
	}
	
	base = "base_rifle";
	if((isdefined(self.voicePrefix) && ( GetSubStr(self.voicePrefix,7) == "f" )))
		base ="fem_rifle";
	if(self.archetype == "human_riotshield" )
		base = "riotshield";
	
	type =self cybercom::getAnimPrefixForPose();
	variant = attacker cybercom::getAnimationVariant(base+"_"+type);
	                                             	
	self OrientMode( "face default" );
	self AnimScripted( "exo_intro_anim", self.origin, self.angles, "ai_"+base+"_"+type+"_exposed_suit_overload_react_intro"+variant,"normal",%body,1,.2);		
	self thread cybercom::stopAnimScriptedOnNotify("damage_pain","exo_intro_anim",true, attacker,weapon);
	self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","exo_intro_anim",true,attacker,weapon);
	self waittillmatch( "exo_intro_anim", "end" );

	while(loops)
	{
		self PlayPainLoop( attacker, weapon, variant,base,type );
		loops--;
	}
	
	//playfx(level._effect["exo_disable_revert"], self.origin );
	self AnimScripted( "exo_outro_anim", self.origin, self.angles, "ai_"+base+"_"+type+"_exposed_suit_overload_react_outro"+variant,"normal",%body,1,.2);		
	self thread cybercom::stopAnimScriptedOnNotify("damage_pain","exo_outro_anim",true,attacker,weapon);
	self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","exo_outro_anim",true,attacker,weapon);
	self waittillmatch( "exo_outro_anim", "end" );
	self.ignoreall = false;
	self.is_disabled = undefined;

}

// Loop the pain animation until the designated loopTime is over.
function PlayPainLoop(attacker, weapon, variant, base, type)
{
	self endon("death");

	self AnimScripted( "exo_loop_anim", self.origin, self.angles, "ai_"+base+"_"+type+"_exposed_suit_overload_react_loop"+variant,"normal",%body,1,.2);		
	self thread cybercom::stopAnimScriptedOnNotify("damage_pain","exo_loop_anim",true,attacker,weapon);
	self waittillmatch( "exo_loop_anim", "end" );
}

