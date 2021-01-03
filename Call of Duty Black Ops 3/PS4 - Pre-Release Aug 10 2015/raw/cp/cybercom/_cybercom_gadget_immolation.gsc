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
#precache( "fx", "light/fx_ability_light_chest_immolation");
          

	
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
	level.cybercom.immolation.grenadeTypes 		= array("frag_grenade_notrail","emp_grenade");//,"flash_grenade");
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
	self.cybercom.target_count	= GetDvarInt( "scr_immolation_count", 1 );
	if(self hasCyberComAbility("cybercom_immolation")  == 2)
	{
		self.cybercom.target_count	= GetDvarInt( "scr_immolation_upgraded_count", 1 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}

function _on_take( slot, weapon )
{
	self _off(slot,weapon);
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
	self thread cybercom::weaponEndLockWatcher( weapon );
	self.cybercom.is_primed = undefined;
	self notify( "cybercom_immolation_off" );
}

function _is_primed( slot, weapon )
{
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		assert (self.cybercom.activeCybercomWeapon == weapon);
		self notify( "cybercom_immolation_primed" );
		self thread cybercom::weaponLockWatcher(slot, weapon, self.cybercom.target_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_immolation")) 
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

	if(!isDefined(target.archetype))
		return false;
	
	if(isVehicle(target) && ! target _validImmolateVehicle())
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
	
	if(!isActor(target) && !isVehicle(target))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
	
	if(isActor(target) && ( target.archetype != "robot"  && target.archetype!= "human" && target.archetype !="human_riotshield" ) )
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if( (target.archetype == "human" || target.archetype == "human_riotshield") && isPlayer(self) )//human can only be targeted if ability is upgraded
	{
		if(!(self hasCyberComAbility("cybercom_immolation")  == 2))
		{
			self cybercom::cybercomSetFailHint(1);
			return false;
		}
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
function private _activate_immolation(slot,weapon)
{
	upgraded = (self hasCyberComAbility("cybercom_immolation")  == 2);
	aborted  = 0;
	fired 	 = 0;
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if (item.inRange == 1)
			{
				if ( !cybercom::targetIsValid(item.target) )
					continue;
				
				item.target.immolate_origin = item.target.origin;
				item.target thread _immolate(self,upgraded,false,weapon);
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
	self.is_disabled = true;
	if(!immediate)
		wait (RandomFloatRange(0,0.75));
	self thread vehicle_ai::immolate( attacker );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _immolate(attacker,upgraded,immediate=false,weapon) 
{	
	self notify("cybercom_action",weapon,attacker);
	
	
	if (self cybercom::isInstantKill())
	{
		if (isVehicle(self))
		{
			self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
			return;
		}
		else
		{
			immediate = true;
		}
	}
	if(isVehicle(self))
	{
		self thread _immolateVehicle(attacker,upgraded);
	}
	else
	if(self.archetype == "robot")
	{
		self thread _immolateRobot(attacker,upgraded,immediate);
	}
	else
	if(self.archetype == "human" || self.archetype == "human_riotshield" )
	{
		self thread _immolateHuman(attacker,upgraded,immediate);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _immolateGrenadeDetonationWatch(tag,count,attacker,weapon)
{
	msg = self util::waittill_any_timeout(3,"death","explode","damage");

	if(isDefined(self.grenade_prop))
		self.grenade_prop delete();
	
	self stopsound("gdt_immolation_human_countdown");
	
	attacker thread _detonate_grenades(self,100,count);
 	if(isAlive(self))
 	{
 		self kill(self.origin,(isDefined(attacker)?attacker:undefined),undefined,weapon);
 	}
}


 function _immolateHuman(attacker,upgraded,immediate=false) //self is human
 {
 	self endon("death");
	weapon = GetWeapon("gadget_immolation");
  	if(immediate)			//this is a secondary spread;  Human was caught in robot immolate explosion, so burn this guy
 	{
		self.ignoreall = true;	//this dude is giong to die
 		self clientfield::set("arch_actor_fire_fx", 1);
		self thread _corpseWatcher();
		util::wait_network_frame();
		self thread _immolateGrenadeDetonationWatch("tag_weapon_chest",undefined,attacker,weapon);
		self kill(self.origin,(isDefined(attacker)?attacker:undefined),undefined,weapon); //generic 'flame death'
		return;
	}
	wait RandomFloatRange(.1,.75);
	if ( !(attacker cybercom::targetIsValid(self,false) ))
		return;

	self.is_disabled = true;
 	self.ignoreall = true;	//this dude is giong to die
	//turn on UI TacMode Grenade icon here
	//:
	//:
	tag = undefined;
	numGrenades = undefined;
	
	self PlaySoundWithNotify( "gdt_immolation_human_countdown","explode" );
	
	if(self.archetype != "human_riotshield" && self cybercom::getEntityPose() == "stand" && RandomInt(100)<GetDvarInt( "scr_immolation_specialanimchance", 15 ))
	{
		self notify( "bhtn_action_notify", "reactImmolationLong" );
		self thread _immolateGrenadeDetonationWatch("tag_inhand",1,attacker,weapon);
		self AnimScripted( "immo_anim", self.origin, self.angles, "ai_base_rifle_stn_exposed_immolate_explode_midthrow" );		
		self thread cybercom::stopAnimScriptedOnNotify("damage_pain","immo_anim",true,attacker,weapon);
		self waittillmatch( "immo_anim", "grenade_right" );
		self.grenade_prop = Spawn( "script_model", self GetTagOrigin("tag_inhand") );
		self.grenade_prop SetModel( "wpn_t7_grenade_frag_world" );
		self.grenade_prop enablelinkto();
		self.grenade_prop linkto(self,"tag_inhand");
	 	playfxontag("light/fx_ability_light_chest_immolation",self.grenade_prop,"tag_origin");
		self waittillmatch( "immo_anim", "explode" );
		self stopsound("gdt_immolation_human_countdown");
		self notify("explode");
	}
	else
	{
		//pain loop
		self notify( "bhtn_action_notify", "reactImmolation" );
	 	self DoDamage( 5, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
	 	playfxontag("light/fx_ability_light_chest_immolation",self,"tag_weapon_chest");
		self thread  explodeOnMatch();
		self thread _immolateGrenadeDetonationWatch("tag_weapon_chest",undefined,attacker,weapon);
	}
 }
 
 function explodeOnMatch()
 {
 	self endon("death");
 	self waittillmatch("bhtn_action_terminate", "specialpain" ); 
 	self stopsound("gdt_immolation_human_countdown");
 	self notify("explode");
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
	
 	self.is_disabled = true;
	weapon = GetWeapon("gadget_immolation");
     
 	if(( isdefined( self.isCrawler ) && self.isCrawler ) || !cybercom::hasBothLegs(self) )
	{
		self playsound( "wpn_incendiary_explode" );
		playfxontag("explosions/fx_ability_exp_immolation",self,"j_spinelower");
		physicsExplosionSphere( self.origin, 200, 32, 2 );
	 	self immolate_nearby(attacker,upgraded);
	 	origin = self.origin;
	 	self DoDamage(self.health,self.origin,(isDefined(attacker)?attacker:undefined),(isDefined(attacker)?attacker:undefined),"none","MOD_BURNED",0,weapon,-1,true);
		wait .1;
	 	RadiusDamage(origin,GetDvarInt( "scr_immolation_outer_radius", 235 ),500,30,(isDefined(attacker)?attacker:undefined),"MOD_EXPLOSIVE",weapon);
		return;
	}
	self clientfield::set("arch_actor_fire_fx", 1);
	earthquake( 0.5, 0.5, self.origin, 500 );
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	
	self thread _corpseWatcher();
	self.ignoreall = true;	//this dude is giong to die
	type =self cybercom::getAnimPrefixForPose();

	self.ignoreall = true;
	variant = "_"+RandomInt(3);
	if(variant =="_0")
		variant ="";
	
	
	intro_max_time = GetDvarFloat( "scr_immolation_death_delay", 0.87 ) + RandomFloatRange(0.0, 0.2);
	time_until_detonation = GetTime() + (intro_max_time * 1000);
	
	self playsound( "gdt_immolation_robot_countdown" );	
		
	// If there's still time, play the react pain animation until detonation.
	self DoDamage( 5, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
	
	// Wait until detonation is meant to occur.
	while( GetTime() < time_until_detonation )
	{
		wait (0.1);
	}
	self stopsound( "gdt_immolation_robot_countdown" );
	self playsound( "wpn_incendiary_explode" );
	playfxontag("explosions/fx_ability_exp_immolation",self,"j_spinelower");
	physicsExplosionSphere( self.origin, 200, 32, 2 );
 	self immolate_nearby(attacker,upgraded);
	if(upgraded)
	{
 //		self thread _detonate_grenades_inrange(attacker, IMMOLATION_GRENADE_DISTSQ);
 	}
	level notify( "cybercom_immolation_robot_exploded" );
	util::wait_network_frame();
	origin = self.origin;
 	self DoDamage(self.health,self.origin,(isDefined(attacker)?attacker:undefined),(isDefined(attacker)?attacker:undefined),"none","MOD_BURNED",0,weapon,-1,true);
 	RadiusDamage(origin,GetDvarInt( "scr_immolation_outer_radius", 235 ),500,30,(isDefined(attacker)?attacker:undefined),"MOD_EXPLOSIVE",weapon);
}

 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _corpseWatcher()
{
	archetype = self.archetype;
 	self waittill("actor_corpse", corpse);
 	corpse clientfield::set("arch_actor_fire_fx", 2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _detonate_grenades(guy,chance=GetDvarInt( "scr_immolation_gchance", 100 ),numExtradetonations)//self == attacker
{
	self endon("disconnect");
	
	loc		= guy _get_grenade_spawn_loc();
	if(!isDefined(loc))
		loc = guy.origin +(0,0,50);
	
	grenade = self MagicGrenadeType( GetWeapon("frag_grenade_notrail"),loc, (0,0,0), 0 );
	if(!isDefined(numExtradetonations))
	{
		numExtradetonations = RandomInt(GetDvarInt( "scr_immolation_gcount", 3 ))+1;
	}
	while(numExtradetonations && isDefined(self) && isDefined(guy) )
	{
		wait RandomFloatRange(GetDvarFloat( "scr_immolation_grenade_wait_timeMIN", .3 ),GetDvarFloat( "scr_immolation_grenade_wait_timeMAX", .9 ));
		numExtradetonations--;
		if ( RandomInt(100) > chance)
			continue;

		gtype 	= level.cybercom.immolation.grenadeTypes[RandomInt(level.cybercom.immolation.grenadeTypes.size)];
		/#
		//	iprintlnbold("GrenadeType: " + gtype);
		#/
		if(isDefined(guy))
		{
			loc		= guy _get_grenade_spawn_loc();
			if(!isDefined(loc))
				loc = guy.origin +(0,0,50);
		}
		if(isDefined(loc))
		{
			grenade = self MagicGrenadeType( GetWeapon(gtype),loc, (0,0,0), 0.05 );
			grenade thread waitforExplode();
		}
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
function private _detonate_grenades_inrange(player, rangeMax)
{
	//get enemies
	enemies = ArrayCombine(GetAISpeciesArray( "axis", "robot" ),GetAISpeciesArray( "team3", "robot" ),false,false);	//check to see if there are any nearby targets
	closeTargets = ArraySortClosest(enemies,self.origin,enemies.size,0,rangeMax);
	foreach ( guy in closeTargets )
	{
		//filter for good target
		if (player cybercom::targetIsValid(guy) )
		{
			if ( ( isdefined( guy.grenades_detonated ) && guy.grenades_detonated ) )
				continue;

			guy.grenades_detonated = 1;			
			player thread _detonate_grenades(guy); 
		}
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function immolate_nearby(attacker,upgraded)
{
	targets = _get_valid_targets();
	closeTargets=ArraySortClosest(targets,self.origin,666,0,GetDvarInt( "scr_immolation_radius", 180 ));
	foreach ( guy in closeTargets )
	{
		if(guy == self )
			continue;
			
		//filter for good target
		if (attacker cybercom::targetIsValid(guy) )
		{
			if(isVehicle(guy))
			{
				//guy thread _immolateVehicle(player,upgraded,true);		//waiting to see if design wants immolation to spread to vehicles
			}
			else
			{
				guy thread _immolate(attacker, upgraded,true, GetWeapon("gadget_immolation") ); 
			}
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_grenade_spawn_loc()
{
	if(isdefined(self.archetype) && self.archetype == "human" )
		return self gettagorigin("tag_weapon_chest");
	
	tag = level.cybercom.immolation.grenadeLocs[RandomInt(level.cybercom.immolation.grenadeLocs.size)];
	return self gettagorigin(tag);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateImmolate(target,doCast=true, upgraded)
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
		if (!(self cybercom::targetIsValid(guy) ))
			continue;
		guy thread _immolate(self,upgraded,false,GetWeapon("gadget_immolation"));
		{wait(.05);};
	}
}
