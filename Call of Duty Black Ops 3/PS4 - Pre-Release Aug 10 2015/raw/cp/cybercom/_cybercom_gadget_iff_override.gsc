#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
	
#using scripts\shared\system_shared;

#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;

#using scripts\shared\vehicle_ai_shared;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                             	     	                                                                                                                                                                







	//probably has to match the amounts above!
	

#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "explosions/fx_exp_grenade_flshbng");

#namespace cybercom_gadget_iff_override;

function init()
{

}

function main()
{
	cybercom_gadget::registerAbility(0,	(1<<6));

	level._effect["iff_takeover"]			= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["iff_takeover_revert"]	= "explosions/fx_exp_grenade_flshbng";
	level._effect["iff_takeover_death"]		= "explosions/fx_exp_grenade_flshbng";

	level.cybercom.iff_override = spawnstruct();
	level.cybercom.iff_override._is_flickering  = &_is_flickering;
	level.cybercom.iff_override._on_flicker 	= &_on_flicker;
	level.cybercom.iff_override._on_give 		= &_on_give;
	level.cybercom.iff_override._on_take 		= &_on_take;
	level.cybercom.iff_override._on_connect 	= &_on_connect;
	level.cybercom.iff_override._on 			= &_on;
	level.cybercom.iff_override._off 			= &_off;
	level.cybercom.iff_override._is_primed 		= &_is_primed;
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
	self.cybercom.target_count 		= GetDvarInt( "scr_iff_override_count", 1 );
	self.cybercom.iff_override_lifetime = GetDvarInt( "scr_iff_override_lifetime", 60 );
	self.cybercom.iff_control_count		= GetDvarInt( "scr_iff_override_control_count", 1 );
	if(self hasCyberComAbility("cybercom_iffoverride")  == 2)
	{
		self.cybercom.target_count 		= GetDvarInt( "scr_iff_override_upgraded_count", 2);
		self.cybercom.iff_override_lifetime = GetDvarInt( "scr_iff_override_upgraded_lifetime", 120 );
		self.cybercom.iff_control_count		= GetDvarInt( "scr_iff_override_control_upgraded_count", 2 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self.cybercom.iff_controlled_entities = [];
	
	self.cybercom.autoActivate = &_autofire;
	self.cybercom.abortConditions = (1|2|4|8|16|32);


	
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}

function _on_take( slot, weapon )
{
	self _off( slot, weapon );
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
	self.cybercom.abortConditions = undefined;
	self.cybercom.autoActivate = undefined;
	// executed when gadget is removed from the players inventory
}

function _autofire(slot,weapon)
{
	self GadgetActivate(slot,weapon);		
	_on( slot, weapon );
}


//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self thread _activate_iff_override(slot,weapon);
	self _off( slot, weapon );
}

function _off( slot, weapon )
{
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

function private _robotRevertWatcher(team,attacker)
{
	self endon("death");
	self waittill("iff_override_reverted");
	self clientfield::set( "cybercom_setiffname",4);
	self SetTeam(team);
	wait 1;
	self clientfield::set( "cybercom_setiffname",0);
	playfx(level._effect["iff_takeover_death"], self.origin );
	self playsound ("gdt_iff_deactivate");
	if(isDefined(attacker))
	{
		self kill(self.origin,attacker);
	}
	else
		self kill();	
}

function private _pushIffControlledEntity(entity)
{
	if(!isPlayer(self))
		return;
	
	valid = [];
	foreach(guy in self.cybercom.iff_controlled_entities )
	{
		if(isDefined(guy) && isAlive(guy))
			valid[valid.size] = guy;
	}
	self.cybercom.iff_controlled_entities = valid;
	self.cybercom.iff_controlled_entities[self.cybercom.iff_controlled_entities.size] = entity;
	
	if (self.cybercom.iff_controlled_entities.size > self.cybercom.iff_control_count )
	{
		revertEntity = self.cybercom.iff_controlled_entities[0];
		ArrayRemoveIndex(self.cybercom.iff_controlled_entities,0);
		if(isDefined(revertEntity))
		{
			revertEntity notify("iff_override_reverted");
			wait(1.5);
			if(isAlive(revertEntity))
				revertEntity kill();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_iffoverride"))
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
	
	if(isActor(target) && target.archetype != "robot")
	{
		self cybercom::cybercomSetFailHint(1);
		return false;	
	}

	if(!isActor(target) && !isVehicle(target))
		return false;
	
	if(isVehicle(target) && isDefined(target.iffowner))
	{
		self cybercom::cybercomSetFailHint(3);
		return false;	
	}
	
	if (( isdefined( target.no_iff ) && target.no_iff ))
		return false;

	
	if ( isActor(target) && target.archetype == "robot" && target ai::get_behavior_attribute( "rogue_control" ) == "level_3" )//don't target rogue robots
		return false;

	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	prospects = GetAITeamArray("axis");//ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);//GetVehicleTeamArray( "axis" );
	valid	  = [];
	
	foreach (enemy in prospects)
	{
		if(isVehicle(enemy) || (isActor(enemy) && isDefined(enemy.archetype) ) )
			valid[valid.size] = enemy;
	}
	return valid;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_iff_override(slot,weapon)
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
				
				item.target thread iff_override(self,undefined,weapon);
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
function private _iff_leash_to_owner(owner)
{
	self endon("death");
	self endon("iff_override_reverted");
	if(isPlayer(owner))
	{
		owner endon("disconnect");
	}
	else
	{
		owner endon("death");
	}
	while(isDefined(owner))
	{
		wait RandomFloatRange(1,4);
		if( distancesquared(self.origin,owner.origin) > ( (self.goalradius) * (self.goalradius) ) )
		{
			self setgoal(owner.origin);
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function iff_vehicleCB(isActive)
{
	if(isActive && isDefined(self.iffowner) && isPlayer(self.iffowner))
	{
		self clientfield::set( "cybercom_setiffname",2);
		self thread _iff_overrideVehicleRevertWatch();
	}
	else
	if(!isActive && isDefined(self.iffowner))
	{
		self clientfield::set( "cybercom_setiffname", 0);
		self.iffowner = undefined;
		self.iff_override_cb = undefined;
		self.is_disabled = false;
	}
}
function private _iff_overrideVehicleRevertWatch()
{
	self endon("death");
	self waittill( "iff_override_reverted" );
	self clientfield::set( "cybercom_setiffname",4);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iff_overrideVehicle(assignedOwner) //self is vehicle
{
	self endon("death");
	wait (RandomFloatRange(0,0.75));
	///////////////////////////////////////////////////////////////////////////////////////////////
	if( isPlayer(assignedOwner) )
	{
		self.iff_override_cb = &iff_vehicleCB;
		self.iffowner = assignedOwner;
	}
	assignedOwner thread _pushIffControlledEntity(self);
	self playsound ("gdt_iff_activate");
	self thread vehicle_ai::iff_override( assignedOwner );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iff_override_warn_revert()
{
	self endon("death");
	self waittill("iff_override_revert_warn");
	self clientfield::set( "cybercom_setiffname", 3);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function iff_override(attacker,disableTimeMSEC,weapon) 
{
	if(!isDefined(weapon))
	{
		weapon = GetWeapon("gadget_iff_override");
	}
	self notify("cybercom_action",weapon,attacker);
	self clientfield::set( "cybercom_setiffname",1);
	
	if(isActor(self))
	{
		self ai::set_behavior_attribute( "can_gib", false ); // Disable normal damage gibbing.
	}
	
	self.is_disabled = true;
	if(isVehicle(self))
	{
		self thread _iff_override_warn_revert();
		self thread _iff_overrideVehicle(attacker);
		return;
	}
	
	if (self cybercom::isInstantKill())
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}
	
	if(isDefined(disableTimeMSEC))
	{
		disableTime = int(disableTimeMSEC/1000);
	}
	else
	if(isDefined(attacker.cybercom) && isDefined(attacker.cybercom.iff_override_lifetime))
	{
		disableTime = attacker.cybercom.iff_override_lifetime ;
	}
	else
	{
		disableTime = GetDvarInt( "scr_iff_override_lifetime", 60 );
	}
	self.ignoreall = true;
	self ai::set_behavior_attribute( "robot_lights", 2 );
	wait 1;
	if(!isDefined(self))	//robot delte3d or killed
		return;
	
	entNum = self getEntityNumber();
	self notify("CloneAndRemoveEntity",entNum); //give self a heads up if level scripter isn't expecting a 'death' notify
	level notify("CloneAndRemoveEntity",entNum); 
	
	{wait(.05);};
	team = self.team;
	clone = CloneAndRemoveEntity(self);  //self just got deleted!
	if(!isDefined(clone))
		return;
	level notify("ClonedEntity",clone,entNum);

	if(isActor(clone))
	{
		clone ai::set_behavior_attribute( "move_mode", "rusher" );  // Force the robot to move toward enemies instead of staying at cover or in the open.
	}

	attacker thread _pushIffControlledEntity(clone);
	clone thread  _robotRevertWatcher(team,attacker);
	clone thread _iff_override_warn_revert();
	clone thread _iff_override_revert_after(disableTime,attacker);
	clone.no_friendly_fire_penalty = true;
	clone SetTeam(attacker.team);
	clone.remote_owner = attacker;
	clone.oldTeam		= team;
	if ( IsDefined( clone.favoriteenemy ) &&	IsDefined( clone.favoriteenemy._currentRogueRobot ) )
	{
		clone.favoriteenemy._currentRogueRobot = undefined;
	}
	clone.favoriteenemy = undefined;
		
	playfx(level._effect["iff_takeover"], clone.origin );
	clone playsound ("gdt_iff_activate");
	clone thread _iff_leash_to_owner(attacker);
	clone.oldgoalradius = clone.goalradius;
	clone.goalradius = 512;
	clone clientfield::set( "cybercom_setiffname",2);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function iff_notifyMeInNSec(time,note)
{
	self endon("death");
	wait time;
	self notify(note);
}
function private _iff_override_revert_after(timeSec,attacker)
{
	self endon("death");
	wait (timeSec-6);
	self notify("iff_override_revert_warn");//CCOM_IFF_EXPIRE_WARNING defined in _cybercom.gsh;
	wait 6;
	self clientfield::set( "cybercom_setiffname",4);
	wait 2;
	self SetTeam(self.oldTeam);
	self notify("iff_override_reverted");
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateIFFOverride(target,doCast=true)
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
		guy thread iff_override(self,undefined,undefined);
		{wait(.05);};
	}
}