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
                                                                                                                                                                                                                                                                                                                                                                   

#using scripts\shared\lui_shared;
                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\shared\ai_shared;
#using scripts\shared\vehicle_ai_shared;


#using scripts\shared\ai\systems\blackboard;
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               




	
//undefine if you want to test tag location. this fx is pretty noticable ;)	
//#define HUMAN_GRENADE_WARNING_LIGHT "explosions/fx_ability_exp_immolation"

#precache( "fx", "explosions/fx_ability_exp_immolation" );
#precache( "fx", "light/fx_light_red_spike_charge_os");
          

	
#namespace cybercom_gadget_immolation;






	//96inch radius for grenade detonations
	//96inch radius for grenade detonations
	//15%

	//random between 0 and time.
	//min/max define the delay in between spawning of extra grenade detonations
	//
	//number of MAX EXTRA grenade detonations; 0 to number;  A FRAG type will always spawn first and doesn't count against this number
	//100% the chance that extra grende will go off.  extraGrenades is Random between 0 and GRENADE_COUNT_MAX;  For each grenade, this chance of detonation applies.(100 for each one, or lower for random skips)
	
	
	

	
function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(2,	(1<<2));

	level.cybercom.immolation = spawnstruct();
	level.cybercom.immolation._is_flickering  	= &_is_flickering;
	level.cybercom.immolation._on_flicker 		= &_on_flicker;
	level.cybercom.immolation._on_give 			= &_on_give;
	level.cybercom.immolation._on_take 			= &_on_take;
	level.cybercom.immolation._on_connect 		= &_on_connect;
	level.cybercom.immolation._on 				= &_on;
	level.cybercom.immolation._off 				= &_off;
	level.cybercom.immolation._is_primed 		= &_is_primed;
	level.cybercom.immolation.grenadeLocs 		= array("j_shoulder_le_rot","j_elbow_le_rot","j_shoulder_ri_rot","j_elbow_ri_rot","j_hip_le","j_knee_le","j_hip_ri","j_knee_ri","j_head","j_mainroot");
	level.cybercom.immolation.grenadeTypes 		= array("frag_grenade","emp_grenade","flash_grenade");
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
	self.cybercom.immolation_count	= GetDvarInt( "scr_immolation_count", 1 );
	if(self hasCyberComAbility("cybercom_immolation")  == 2)
	{
		self.cybercom.immolation_count	= GetDvarInt( "scr_immolation_upgraded_count", 1 );
	}
	self.cybercom.targetLockCB 				= &_get_valid_targets;
	self.cybercom.targetLockRequirementCB 	= &_lock_requirement;
}

function _on_take( slot, weapon )
{
	self _off(slot,weapon);
	self.cybercom.weapon	= undefined;
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
	self thread _activate_immolation(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.immolation_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_immolation")) 
		return false;

	if(!isDefined(target.archetype))
		return false;
	
	if(isVehicle(target) && ! target _validImmolateVehicle())
		return false;
	
	if(!isActor(target) && !isVehicle(target))
		return false;
	
	if(isActor(target) && ( target.archetype != "robot"  && target.archetype!= "human") )
		return false;

	if( target.archetype == "human" )//human can only be targeted if ability is upgraded
	{
		if(!(self hasCyberComAbility("cybercom_immolation")  == 2))
		   return false;
	}
	
	if(( isdefined( target.isCrawler ) && target.isCrawler ))
		return false;

	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	return ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);//GetVehicleTeamArray( "axis" );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_immolation(slot,weapon)
{
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	
	if ( !isDefined(self.cybercom.lock_targets) || self.cybercom.lock_targets.size == 0 )
	{	//player has the buttons down, and just released, no targets, what to do? 
		//Feedback UI
		//Feedback Audio
		//do we incur the cost of firing the weapon? Seems like we shouldnt
	}
	
	upgraded = (self hasCyberComAbility("cybercom_immolation")  == 2);
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			
			item.target.immolate_origin = item.target.origin;
			if(isVehicle(item.target))
			{
				item.target thread _immolateVehicle(self,upgraded);
			}
			else
			{
				item.target thread _immolate(self,upgraded);
			}
			{wait(.05);};
		}
	}
}
#using_animtree( "generic" );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _validImmolateVehicle()
{
	if(!isDefined(self.vehicletype))
		return false;
	if( isSubStr(self.vehicletype,"amws"))
		return true;
	if( isSubStr(self.vehicletype,"wasp"))
		return true;
	if( isSubStr(self.vehicletype,"raps"))
		return true;
	
	return false;
}
function private _immolateVehicle(attacker,upgraded,immediate=false) //self is vehicle
{
	assert(self _validImmolateVehicle());
	if(!immediate)
		wait (RandomFloatRange(0,0.75));
	self thread vehicle_ai::immolate( attacker );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _immolate(attacker,upgraded,immediate=false) //self is robot
{
	if(self.archetype == "robot")
	{
		self thread _immolateRobot(attacker,upgraded,immediate);
	}
	else
	if(self.archetype == "human")
	{
		self thread _immolateHuman(attacker,upgraded,immediate);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _immolateGrenadeDetonationWatch(tag,count)
{
	msg = self util::waittill_any_return("death","explode","damage");
	origin =  self gettagorigin(tag);
	self thread _detonate_grenades(100,origin,count);
	if(isDefined(self.grenade_prop))
		self.grenade_prop delete();
	
	wait .35;
	
 	RadiusDamage(origin,GetDvarInt( "scr_immolation_gradius", 96 ),100,200,undefined,"MOD_EXPLOSIVE",GetWeapon("frag_grenade"));
 	if(isAlive(self))
 		self kill();
}
 function _immolateHuman(attacker,upgraded,immediate=false) //self is human
 {
 	self endon("death");
 	if(immediate)			//this is a secondary spread;  Human was caught in robot immolate explosion, so burn this guy
 	{
		self.ignoreall = true;	//this dude is giong to die
 		self clientfield::set("arch_actor_fire_fx", 1);
		self thread _corpseWatcher();
		util::wait_network_frame();
		self kill(self.origin,undefined,undefined,GetWeapon("gadget_firefly_swarm_upgraded")); //generic 'flame death'
		return;
	}
	wait RandomFloatRange(.1,.75);
	if ( !(attacker cybercom::targetIsValid(self,false) ))
		return;

 	weapon = GetWeapon("gadget_immolation");
	self.ignoreall = true;	//this dude is giong to die
	//turn on UI TacMode Grenade icon here
	//:
	//:
	tag = undefined;
	numGrenades = undefined;
	
	self playsound( "gdt_immolation_human_countdown" );
	
	if(self.a.pose == "stand" && RandomInt(100)<GetDvarInt( "scr_immolation_specialanimchance", 15 ))
	{
		self thread _immolateGrenadeDetonationWatch("tag_inhand",1);
		self AnimScripted( "immo_anim", self.origin, self.angles, "ai_base_rifle_stn_exposed_immolate_explode_midthrow" );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","immo_anim");
		self waittillmatch( "immo_anim", "grenade_right" );
		self.grenade_prop = Spawn( "script_model", self.origin );
		self.grenade_prop SetModel( "wpn_t7_grenade_frag_world" );
		self.grenade_prop enablelinkto();
		self.grenade_prop linkto(self,"tag_inhand");
	 	playfxontag("light/fx_light_red_spike_charge_os",self.grenade_prop,"tag_origin");
		self waittillmatch( "immo_anim", "explode" );
		self notify("explode");
	}
	else
	{
		//pain loop
	 	self DoDamage( 5, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
	 	playfxontag("light/fx_light_red_spike_charge_os",self,"tag_weapon_chest");

		self thread _immolateGrenadeDetonationWatch("tag_weapon_chest");
	}
 }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 function _immolateRobot(attacker,upgraded,immediate=false) //self is robot
 {
 	self endon("death");
	if(!immediate)
	{
 		wait RandomFloatRange(.1,.75);
	}

	if ( !(attacker cybercom::targetIsValid(self,false) ))
		return;
	
 	weapon = GetWeapon("gadget_immolation");
    
 	self clientfield::set("arch_actor_fire_fx", 1);
	if( ( isdefined( self.missingLegs ) && self.missingLegs ) || ( isdefined( self.isCrawler ) && self.isCrawler ) )
	{
		self Kill();
		return;
	}
	
	self thread _corpseWatcher();
	self.ignoreall = true;	//this dude is giong to die
	if(self.a.pose =="stand")
		type = "stn";
	else
		type = "crc";

	self.ignoreall = true;
	variant = "_"+RandomInt(3);
	if(variant =="_0")
		variant ="";
	
	
	self AnimScripted( "intro_anim", self.origin, self.angles, "ai_robot_base_"+type+"_exposed_immolate_react_intro"+variant );		
	self waittillmatch( "intro_anim", "end" );
 	
	self playsound( "gdt_immolation_robot_countdown" );
	
//	delayTime = GetTime() + 1;// IMMOLATION_DEATH_DELAY*1000 + RandomInt(750);
//	while(GetTime()<delayTime)
	{
	 	self DoDamage( 5, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
		self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
	}

	self playsound( "wpn_incendiary_explode" );
	playfxontag("explosions/fx_ability_exp_immolation",self,"j_spinelower");
	physicsExplosionSphere( self.origin, 200, 32, 2 );
 	self thread immolate_nearby(attacker,upgraded);
	if(upgraded)
	{
 //		self thread _detonate_grenades_inrange(attacker, IMMOLATION_GRENADE_DISTSQ);
 	}
	util::wait_network_frame();
 	RadiusDamage(self.origin,128,500,500,undefined,"MOD_EXPLOSIVE",weapon);
	wait .1;
	if(isDefined(self) && isAlive(self))	
		self kill();
 }
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _corpseWatcher()
{
	archetype = self.archetype;
 	self waittill("actor_corpse", corpse);
 	corpse clientfield::set("arch_actor_fire_fx", 2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _detonate_grenades(chance=GetDvarInt( "scr_immolation_gchance", 100 ),loc,numExtradetonations)
{
	grenade = self MagicGrenadeType( GetWeapon("frag_grenade"),loc, (0,0,0), RandomFloat(GetDvarFloat( "scr_immolation_grenade_cook_timeMAX", .25 )) );
	if(!isDefined(numExtradetonations))
	{
		numExtradetonations = RandomInt(GetDvarInt( "scr_immolation_gcount", 3 ))+1;
	}
	wait RandomFloatRange(GetDvarFloat( "scr_immolation_grenade_wait_timeMIN", .1 ),GetDvarFloat( "scr_immolation_grenade_wait_timeMAX", .3 ));
	accumulator = RandomFloat(GetDvarFloat( "scr_immolation_grenade_cook_timeMAX", .25 ));
	while(numExtradetonations)
	{
		numExtradetonations--;
		if ( RandomInt(100) > chance)
			continue;

		gtype 	= level.cybercom.immolation.grenadeTypes[RandomInt(level.cybercom.immolation.grenadeTypes.size)];
		/#
			iprintlnbold("GrenadeType: " + gtype);
		#/
		grenade = self MagicGrenadeType( GetWeapon(gtype),self.origin, (0,0,0), accumulator );
		accumulator += RandomFloatRange(GetDvarFloat( "scr_immolation_grenade_wait_timeMIN", .1 ),GetDvarFloat( "scr_immolation_grenade_wait_timeMAX", .3 )) + RandomFloat(GetDvarFloat( "scr_immolation_grenade_cook_timeMAX", .25 ));
		grenade thread waitforExplode();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function waitforExplode()
{
	self util::waittill_any_timeout(3, "death", "detonated" );
	if(isDefined(self))
		self delete();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _detonate_grenades_inrange(player, rangeSQ)
{
	//get enemies
	enemies = ArrayCombine(GetAISpeciesArray( "axis", "robot" ),GetAISpeciesArray( "team3", "robot" ),false,false);	//check to see if there are any nearby targets
	closeTargets = cybercom::getArrayItemsWithin(self.origin,enemies,rangeSQ);
	foreach ( guy in closeTargets )
	{
		//filter for good target
		if (player cybercom::targetIsValid(guy) )
		{
			if ( ( isdefined( guy.grenades_detonated ) && guy.grenades_detonated ) )
				continue;

			loc		= guy _get_grenade_spawn_loc();
			if(!isDefined(loc))
				loc = guy.origin +(0,0,50);
			
			guy.grenades_detonated = 1;			
			guy thread _detonate_grenades(undefined,loc); 
		}
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function immolate_nearby(player,upgraded)
{
	closeTargets= cybercom::getArrayItemsWithin(self.origin,_get_valid_targets(undefined),GetDvarInt( "scr_immolation_radiusSQ", ( (200) * (200) ) ));
	foreach ( guy in closeTargets )
	{
		if(guy == self )
			continue;
			
		//filter for good target
		if (player cybercom::targetIsValid(guy) )
		{
			if(isVehicle(guy))
			{
				//guy thread _immolateVehicle(player,upgraded,true);		//waiting to see if design wants immolation to spread to vehicles
			}
			else
			{
				guy thread _immolate(player, upgraded,true ); //self is robot
			}
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_grenade_spawn_loc()
{
	tag = level.cybercom.immolation.grenadeLocs[RandomInt(level.cybercom.immolation.grenadeLocs.size)];
	return self gettagorigin(tag);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateImmolate(target,upgraded=false)
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
		if (!(self cybercom::targetIsValid(guy) ))
			continue;
		guy thread _immolate(self,upgraded);
		{wait(.05);};
	}
}
