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
#using scripts\shared\ai_shared;


                                                                                                             	     	                                                                                                                                                                












	

	

#namespace cybercom_gadget_forced_malfunction;

function init()
{
	clientfield::register( "actor", "forced_malfunction", 1, 1, "int");

}

function main()
{
	cybercom_gadget::registerAbility(1, (1<<1));

	level.cybercom.forced_malfunction = spawnstruct();
	level.cybercom.forced_malfunction._is_flickering  = &_is_flickering;
	level.cybercom.forced_malfunction._on_flicker 	= &_on_flicker;
	level.cybercom.forced_malfunction._on_give 		= &_on_give;
	level.cybercom.forced_malfunction._on_take 		= &_on_take;
	level.cybercom.forced_malfunction._on_connect 	= &_on_connect;
	level.cybercom.forced_malfunction._on 			= &_on;
	level.cybercom.forced_malfunction._off 			= &_off;
	level.cybercom.forced_malfunction._is_primed 	= &_is_primed;
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
	self.cybercom.target_count 		= GetDvarInt( "scr_forced_malfunction_count", 2 );
	if(self hasCyberComAbility("cybercom_forcedmalfunction")  == 2)
	{
		self.cybercom.target_count 		= GetDvarInt( "scr_forced_malfunction_upgraded_count", 4 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
	
	self  cybercom::seedAnimationVariant("base_rifle",5);
	self  cybercom::seedAnimationVariant("fem_rifle",3);
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
	self thread _activate_forced_malfunction(slot,weapon);
	self _off(slot,weapon);
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
	if( target cybercom::cybercom_AICheckOptOut("cybercom_forcedmalfunction"))
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
	
	if(isVehicle(target))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if (isActor(target) && isDefined(target.archetype) && (target.archetype == "zombie" || (target.archetype == "direwolf")))
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
//	humans  ArrayCombine(GetAISpeciesArray( "axis", "human" ),GetAISpeciesArray( "team3", "human" ),false,false);
//	robots 	=  ArrayCombine(GetAISpeciesArray( "axis", "robot" ),GetAISpeciesArray( "team3", "robot" ),false,false);
//	return  ArrayCombine(humans,robots,false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_forced_malfunction(slot,weapon)
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
				
				item.target thread _force_malfunction(self,undefined);
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
function private _force_malfunctionWarlord(attacker,disableFor,weapon)
{
	self endon ("death");

	self clientfield::set( "forced_malfunction",1 );
	self.is_disabled = true;
	self DoDamage( 5, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
	self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
	self.is_disabled = false;
	self clientfield::set( "forced_malfunction",0 );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _force_malfunctionRobot(attacker,disableFor,weapon)
{
	self endon ("death");

	if( !cybercom::hasBothLegs(self) )
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined));
		return;
	}	
	
	//play animations ...TODO get some legit animations
	self clientfield::set( "forced_malfunction",1 );
	self.is_disabled = true;
	miss = 100;
	while(isAlive(self) && GetTime()<disableFor )
	{
		if ( (GetDvarInt( "scr_malfunction_rate_of_failure", 25 )+miss) > RandomInt(100))//roll the dice for jam
		{
			miss = 0;
			self DoDamage( 5, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
			self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
		}
		else
		{
			miss += 10;
			wait RandomIntRange(1,3);
		}
	}

	self clientfield::set( "forced_malfunction",0 );
	self.is_disabled = false;
//	self ai::set_behavior_attribute( "rogue_allow_pregib", false );
//	self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
//	self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _force_malfunction(attacker,disableTimeMSEC) 
{
	self endon("death");
	
	weapon = GetWeapon("gadget_forced_malfunction");
	
	self notify("cybercom_action",weapon,attacker);

	if(isDefined(disableTimeMSEC))
		disableTime = disableTimeMSEC;
	else
		disableTime = GetDvarInt( "scr_malfunction_duration", 15 )*1000;
	
	if ( !(attacker cybercom::targetIsValid(self) ))
		return;
	
	if (self cybercom::isInstantKill())
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}

	disableFor = GetTime() + disableTime + (RandomInt(4000)); //upto 4 seconds of random delay
	
	if(self.archetype == "robot" )
	{
		self thread _force_malfunctionRobot(attacker,disableFor,weapon);
		return;
	}
	if(self.archetype == "warlord" )
	{
		self thread _force_malfunctionWarlord(attacker,disableFor,weapon);
		return;
	}
	
	assert(self.archetype == "human" || self.archetype == "human_riotshield" );
	////////////////////////////////////
	//HUMAN
	type =self cybercom::getAnimPrefixForPose();

//	playfx(level._effect["forced_malfunction_"+self.archetype], self.origin );

	
	self clientfield::set( "forced_malfunction",1 );
	goalpos 			= self.goalpos;
	goalradius 			= self.goalradius;
	self.goalradius 	= 32;
	// start with malfunctioning on
	
	
	if ( self isactorshooting() )
	{
		base = "base_rifle";
		if((isdefined(self.voicePrefix) && ( GetSubStr(self.voicePrefix,7) == "f" )))
		{
			base ="fem_rifle";
		}
		else
		if(self.archetype == "human_riotshield")
		{
			base = "riotshield";
		}
		
		type =self cybercom::getAnimPrefixForPose();
		variant = attacker cybercom::getAnimationVariant(base);
	
	//	self OrientMode( "face default" );
		self AnimScripted( "malfunction_intro_anim", self.origin, self.angles, "ai_"+base+"_"+type+"_exposed_rifle_malfunction"+variant);		
		self thread cybercom::stopAnimScriptedOnNotify("damage_pain","malfunction_intro_anim",true,attacker,weapon);
		self thread cybercom::stopAnimScriptedOnNotify("notify_melee_damage","malfunction_intro_anim",true,attacker,weapon);
		self waittillmatch( "malfunction_intro_anim", "end" );
	}
	
	check_next_malfunction_time = 0;
	//self thread chance_stop_malfunction();
	
	while(isAlive(self) && GetTime()<disableFor)
	{
		// There's a chance we'll stop malfunctioning here.
		// If so, we'll stop trying to move closer until we're malfunctioning again
		if (GetTime() > check_next_malfunction_time)
		{
			// The next time we need to check if we're going to malfunction again
			check_next_malfunction_time = GetTime() + (RandomFloatRange(GetDvarFloat( "scr_malfunction_duration_min_wait", 2 ),GetDvarFloat( "scr_malfunction_duration_max_wait", 3.25 )) * 1000);
			
			if ( GetDvarInt( "scr_malfunction_rate_of_failure", 90 ) > RandomInt(100))//roll the dice for jam
			{
				self.malFunctionReaction = true;	//guy is jammed
			}
			else
			{
				self.malFunctionReaction = false;	//unjammed, can fire again
			}
		}
		
		wait (0.2);
	}

	self clientfield::set( "forced_malfunction",0 );
	self.malFunctionReaction = undefined;
	self.melee_charge_rangeSQ = undefined;
	self.goalradius = goalradius;
	self SetGoal( goalpos, true );
}

#using_animtree( "generic" );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ai_activateForcedMalfuncton(target,doCast=true)
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
		//self OrientMode( "face default" );
		self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );		
		self waittillmatch( "ai_cybercom_anim", "fire" );
	}

	foreach(guy in validTargets)
	{
		if ( !cybercom::targetIsValid(guy) )
			continue;
		guy thread _force_malfunction(self);
		{wait(.05);};
	}
}