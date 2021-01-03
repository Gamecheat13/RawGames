#using scripts\codescripts\struct;
#using scripts\shared\math_shared;

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
#using scripts\shared\ai\systems\gib;
                                                                                                                                                                                                       	     	                                                                                   
#using scripts\shared\ai\systems\destructible_character;

#using scripts\shared\lui_shared;
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\shared\ai_shared;

#using scripts\shared\vehicles\_amws;


#using scripts\shared\ai\systems\blackboard;
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           


#namespace cybercom_gadget_servo_shortout;










#precache( "fx", "electric/fx_ability_servo_shortout_robot");
#precache( "fx", "destruct/fx_dest_robot_limb_sparks_right");
#precache( "fx", "destruct/fx_dest_robot_limb_sparks_left");


function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(0,	(1<<1));

	level._effect["servo_shortout"]					= "electric/fx_ability_servo_shortout_robot";
	level._effect["servo_shortout_amws"]			= "electric/fx_ability_elec_surge_short_amws";
	level._effect["servo_shortout_raps"]			= "electric/fx_ability_elec_surge_short_raps";
	level._effect["servo_shortout_robot"]			= "electric/fx_ability_elec_surge_short_robot";
	level._effect["servo_shortout_wasp"]			= "electric/fx_ability_elec_surge_short_wasp";
	
	level._effect["servo_shortout_robot_r"]			= "destruct/fx_dest_robot_limb_sparks_right";
	level._effect["servo_shortout_robot_l"]			= "destruct/fx_dest_robot_limb_sparks_left";
	
	
	level.cybercom.servo_shortout = spawnstruct();
	level.cybercom.servo_shortout._is_flickering  	= &_is_flickering;
	level.cybercom.servo_shortout._on_flicker 		= &_on_flicker;
	level.cybercom.servo_shortout._on_give 			= &_on_give;
	level.cybercom.servo_shortout._on_take 			= &_on_take;
	level.cybercom.servo_shortout._on_connect 		= &_on_connect;
	level.cybercom.servo_shortout._on 				= &_on;
	level.cybercom.servo_shortout._off 				= &_off;
	level.cybercom.servo_shortout._is_primed 		= &_is_primed;
	level.cybercom.servo_shortout.gibCounter		= 0;
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
	self.cybercom.target_count		= GetDvarInt( "scr_servo_shortout_count", 2 );
	if(self hasCyberComAbility("cybercom_servoshortout")  == 2)
	{
		self.cybercom.target_count	= GetDvarInt( "scr_servo_shortout_upgraded_count", 3 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}

function _on_take( slot, weapon )
{
	self _off( slot, weapon );
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self thread _activate_servo_shortout(slot,weapon);
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
	if( target cybercom::cybercom_AICheckOptOut("cybercom_servoshortout")) 
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
	
	if (!isDefined(target.archetype) )
	{
		self cybercom::cybercomSetFailHint(1);
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
function private _activate_servo_shortout(slot,weapon)
{
	// Track if one robot already got instant killed this activation.
	instant_killed_bot = false;
	upgraded = self hasCyberComAbility("cybercom_servoshortout")  == 2;

	
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
				
				// Ensure only one bot can get instant killed per activation.
				if (!instant_killed_bot && RandomInt(100)<(upgraded?GetDvarInt( "scr_servo_killchance_upgraded", 30 ):GetDvarInt( "scr_servo_killchance", 15 )))
				{
					item.target thread servo_shortout(self, undefined, upgraded, true);
					instant_killed_bot = true;
				}
				// If one bot already was instant killed, don't instant kill any others.
				else
				{
					item.target thread servo_shortout(self, undefined, upgraded, false);
				}
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
function private _update_gib_position() //self is robot
{
	level.cybercom.servo_shortout.gibCounter++;
	return(level.cybercom.servo_shortout.gibCounter%3);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function servo_shortoutVehicle(attacker, upgraded,weapon ) //self is vehicle
{
	if(isSubStr(self.vehicletype,"wasp"))
	{
		PlayFxOnTag( level._effect["servo_shortout_wasp"], self, "tag_body" ); 
		wait .5;
		if(isAlive(self))
		{
			self playsound( "gdt_servo_robot_die" );
			self kill(self.origin,(isDefined(attacker)?attacker:undefined),undefined,weapon);
		}
	}
	else
	if(isSubStr(self.vehicletype,"raps"))
	{
		self.serverShortout = true;
		self thread sndStopAllPotentialSounds();
		PlayFxOnTag( level._effect["servo_shortout_raps"], self, "tag_wheel_front_right_animate" );
		wait .5;
		if(isAlive(self))
		{
			self kill(self.origin,(isDefined(attacker)?attacker:undefined),undefined,weapon);
		}
	}
	else
	if(isSubStr(self.vehicletype,"amws"))	//also covers pamws
	{
		PlayFxOnTag( level._effect["servo_shortout_amws"], self, "tag_turret_animate" ); 
		self playsound( "gdt_servo_robot_die" );
		wait .5;
		if(isAlive(self))
		{
			self amws::gib( attacker );
		}
		/*
		{
			hR = self.health / self.healthdefault;
			if(hR<.5)
			{
				self kill(self.origin,(isDefined(attacker)?attacker:undefined),undefined,weapon);
			}
			else
			{
				dmg = self.health - (int(self.healthdefault*.25));
				self dodamage(dmg,self.origin,(isDefined(attacker)?attacker:undefined),undefined,"none","MOD_GRENADE_SPLASH",0,GetWeapon("emp_grenade"),-1,true);
			}
		}
		*/
	}
	else
	{
		dmg = int(self.healthdefault*.1);
		self dodamage(dmg,self.origin,(isDefined(attacker)?attacker:undefined),undefined,"none","MOD_GRENADE_SPLASH",0,GetWeapon("emp_grenade"),-1,true);
	}
}
function sndStopAllPotentialSounds()
{
	self stopsounds();
	wait(.05);
	self playsound( "gdt_servo_robot_die" );
}

#using_animtree( "generic" );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function servo_shortout(attacker, weapon, upgraded, instant_kill, damage=2 ) //self is robot
{
	self endon("death");
	
	if(!isDefined(weapon))
		weapon = GetWeapon("gadget_servo_shortout");

	self notify("cybercom_action",weapon,attacker);
	
	if(isVehicle(self))
	{
		self thread servo_shortoutVehicle(attacker, upgraded,weapon );
		return;
	}
	assert(self.archetype=="robot" );
	       
	PlayFxOnTag( level._effect["servo_shortout_robot"], self, "j_spine4" ); 
	//self playloopsound( "gdt_servo_spark_lp" );

	if( !cybercom::hasBothLegs(self) )
	{
		self playsound( "gdt_servo_robot_die" );
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}	

	if (self cybercom::isInstantKill())
	{
		self playsound( "gdt_servo_robot_die" );
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}

	// Stagger the threads so we can ensure different random values in each.
	wait RandomFloatRange(0,.35);
	
	self.is_disabled = true;
	self DoDamage( damage, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);//needs to be something for pain reaction

	time = RandomFloatRange(0.8,2.1);
	//time = (getAnimLength(%ai_robot_base_stn_exposed_pain_juiced_ammo)) * RandomFloatRange(0.4,1.0);
	
	// Break off some robot pieces!
	for ( i = 0; i < 2; i++ )
	{
		self playsound( "gdt_servo_piece_exp" );
		DestructServerUtils::DestructNumberRandomPieces(self, RandomIntRange(1,3));
		wait (time / 3);
	}
	
	if(isAlive(self))
	{
		if(( isdefined( instant_kill ) && instant_kill ))
		{
			self playsound( "gdt_servo_robot_die" );
			self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		}
		else
		{
			playfxontag(level._effect["servo_shortout_robot_r"],self, "j_knee_ri");
			playfxontag(level._effect["servo_shortout_robot_l"],self, "j_knee_le");
			self ai::set_behavior_attribute( "force_crawler", "gib_legs" );
			self.is_disabled = false;
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateServoShortout(target, doCast=true)
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
		guy thread servo_shortout(self);
		{wait(.05);};
	}
}