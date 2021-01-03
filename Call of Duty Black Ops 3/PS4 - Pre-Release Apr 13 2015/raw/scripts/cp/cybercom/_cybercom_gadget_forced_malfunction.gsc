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


                                                                                                            	   	










	//enemy will attempt to path to player if within this distance(to make melee a reality)



	

	
#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "explosions/fx_exp_grenade_flshbng");

#namespace cybercom_gadget_forced_malfunction;

function init()
{

}

function main()
{
	cybercom_gadget::registerAbility(1, (1<<1));

	level._effect["forced_malfunction_robot"]		= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["forced_malfunction_human"]		= "explosions/fx_exp_grenade_flshbng";
	level._effect["forced_malfunction_warlord"]		= "explosions/fx_exp_grenade_flshbng";
	level._effect["forced_malfunction_default"]		= "explosions/fx_exp_grenade_flshbng";

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
	self.cybercom.weapon 								= weapon;
	self.cybercom.forced_malfunction_target_count 		= GetDvarInt( "scr_forced_malfunction_count", 2 );
	if(self hasCyberComAbility("cybercom_forcedmalfunction")  == 2)
	{
		self.cybercom.forced_malfunction_target_count 		= GetDvarInt( "scr_forced_malfunction_upgraded_count", 4 );
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
	self thread _activate_forced_malfunction(slot,weapon);
	self _off(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.forced_malfunction_target_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_forcedmalfunction"))
		return false;
		
	if(target.a.pose != "stand" && target.a.pose !="crouch" )
		return false;

	if(isVehicle(target))
		return false;

	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	humans =  ArrayCombine(GetAISpeciesArray( "axis", "human" ),GetAISpeciesArray( "team3", "human" ),false,false);
	robots =  ArrayCombine(GetAISpeciesArray( "axis", "robot" ),GetAISpeciesArray( "team3", "robot" ),false,false);
	return ArrayCombine(humans,robots,false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_forced_malfunction(slot,weapon)
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
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			
			item.target thread _force_malfunction(self);
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _force_malfunction(attacker,disableTimeMSEC) //self is robot
{
	self endon("death");
	

	if(isDefined(disableTimeMSEC))
	{
		disableTime = disableTimeMSEC;
	}
	else
	{
		disableTime = GetDvarInt( "scr_malfunction_duration", 35 )*1000;
	}
	wait (RandomFloatRange(0,0.75));
	if ( !(attacker cybercom::targetIsValid(self) ))
		return;
	
	disableFor = GetTime() + disableTime + (RandomInt(4000)); //upto 4 seconds of random delay
	if(isDefined(level._effect["forced_malfunction_"+self.archetype]))
	{
		playfx(level._effect["forced_malfunction_"+self.archetype], self.origin );
	}
	else
	{
		playfx(level._effect["forced_malfunction_default"], self.origin );
	}

	type = "stn";
	if(self.a.pose == "crouch")
		type = "crc";

	weapon = GetWeapon("gadget_forced_malfunction");

	if(self.archetype == "robot" )
	{
		if( ( isdefined( self.missingLegs ) && self.missingLegs ) || ( isdefined( self.isCrawler ) && self.isCrawler ) )
		{
			self Kill();
			return;
		}

	
		//play animations ...TODO get some legit animations
		self.is_disabled = true;
		self.ignoreall = true;
		self OrientMode( "face default" );
		self AnimScripted( "malfunction_intro_anim", self.origin, self.angles, "ai_robot_base_"+type+"_shutdown" );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","malfunction_intro_anim");
		self waittillmatch( "malfunction_intro_anim", "end" );
		while(isAlive(self) && GetTime()<disableFor )
		{
			if (!self cybercom::isTurretDude())
			{
				self DoDamage( 2, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
				self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
			}
			else
			{
				self AnimScripted( "malfunction_loop", self.origin, self.angles,"ai_robot_base_"+type+"_shutdown_idle" );		
				self thread cybercom::stopAnimScriptedOnNotify("damage","malfunction_loop");
				self waittillmatch( "malfunction_loop", "end" );
			}
		}
		self AnimScripted( "malfunction_outro_anim", self.origin, self.angles, "ai_robot_base_"+type+"_shutdown_2_alert" );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","malfunction_outro_anim");
		self waittillmatch( "malfunction_outro_anim", "end" );
		self.ignoreall = false;
		self.is_disabled = false;
		self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );//design want robots to go into kamikaze mode
	}
	else
	if(self.archetype == "human" )
	{
		goalpos 			= self.goalpos;
		goalradius 			= self.goalradius;
		self.goalradius 	= 32;
		self.melee_charge_rangeSQ = ( (GetDvarInt( "scr_malfunction_melee_distance", 220 )) * (GetDvarInt( "scr_malfunction_melee_distance", 220 )) );
		while(isAlive(self) && GetTime()<disableFor)
		{
			if(isDefined(self.enemy))
			{
				distanceSQ = distancesquared(self.origin,self.enemy.origin);
				if(distanceSQ < ( (GetDvarInt( "scr_malfunction_close_distance", 512 )) * (GetDvarInt( "scr_malfunction_close_distance", 512 )) )	)
				{
					queryResult = PositionQuery_Source_Navigation(self.enemy.origin,	0,	72,	72,	20,	self );	//can find node around where it wants to go?
					if( queryResult.data.size > 0 )
					{
						pathSuccess = self FindPath(	self.origin, queryResult.data[0].origin, true, false );		//can  path to that location?
						if ( pathSuccess )
						{
							if(GetDvarInt( "scr_malfunction_debug", 0))
							{
								level thread cybercom::debug_Circle( queryResult.data[0].origin+(0,0,32), self.goalradius, 1, (1,0,0) );
							}	
							self clearforcedgoal();
							self SetGoal( queryResult.data[0].origin, true, self.goalradius );
						}
					}
				}
			}
			if ( GetDvarInt( "scr_malfunction_rate_of_failure", 75 ) > RandomInt(100))//roll the dice for jam
			{
				self.malFunctionReaction = true;	//guy is jammed
				wait RandomFloatRange(GetDvarFloat( "scr_malfunction_duration_min_wait", 2 ),GetDvarFloat( "scr_malfunction_duration_min_wait", 6 ));
			}
			self.malFunctionReaction = undefined;	//guy can shoot again
			wait RandomFloatRange(GetDvarFloat( "scr_normalfunction_duration_min_wait", .1 ),GetDvarFloat( "scr_normalfunction_duration_min_wait", 1 ));
		
		}

		self.malFunctionReaction = undefined;
		self.melee_charge_rangeSQ = undefined;
		self.goalradius = goalradius;
		self SetGoal( goalpos, true );
	}
	playfx(level._effect["forced_malfunction_"+self.archetype], self.origin );
	
}

#using_animtree( "generic" );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ai_activateForcedMalfuncton(target,disableTimeMSEC)
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
		guy thread _force_malfunction(self,disableTimeMSEC);
		{wait(.05);};
	}
}