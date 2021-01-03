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

#using scripts\shared\vehicle_ai_shared;

                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;


                                                                                                            	   	








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
	self.cybercom.weapon 					= weapon;
	self.cybercom.iff_target_count 		= GetDvarInt( "scr_iff_override_count", 1 );
	self.cybercom.iff_override_lifetime = GetDvarInt( "scr_iff_override_lifetime", 60 );
	if(self hasCyberComAbility("cybercom_iffoverride")  == 2)
	{
		self.cybercom.iff_target_count 		= GetDvarInt( "scr_iff_override_upgraded_count", 4 );
		self.cybercom.iff_override_lifetime = GetDvarInt( "scr_iff_override_upgraded_lifetime", 120 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
}

function _on_take( slot, weapon )
{
	self _off( slot, weapon );
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
	self thread _activate_iff_override(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.iff_target_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_iffoverride"))
		return false;

	if( isActor(target) && target.a.pose !="stand" && target.a.pose !="crouch" )
		return false;
	
	if(isActor(target) && target.archetype != "robot")
		return false;	

	if(!isActor(target) && !isVehicle(target))
		return false;
	
	if(( isdefined( target.is_disabled ) && target.is_disabled ))
		return false;	

	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	prospects = ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);//GetVehicleTeamArray( "axis" );
	valid	  = [];
	
	foreach (enemy in prospects)
	{
		if(isVehicle(enemy) || (isActor(enemy) && isDefined(enemy.archetype) && enemy.archetype == "robot") )
			valid[valid.size] = enemy;
	}
	return valid;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_iff_override(slot,weapon)
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
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			
			if(isVehicle(item.target))
			{
				item.target thread _iff_overrideVehicle(self);
			}
			else
			{
				item.target thread _iff_override(self);
			}
		}
	}
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
		self clientfield::set( "cybercom_setiffname", self.iffowner GetEntityNumber()+1 );
	}
	else
	if(!isActive && isDefined(self.iffowner))
	{
		self clientfield::set( "cybercom_setiffname", 0);
		self.iffowner = undefined;
		self.iff_override_cb = undefined;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iff_overrideVehicle(assignedOwner) //self is vehicle
{
	wait (RandomFloatRange(0,0.75));
	///////////////////////////////////////////////////////////////////////////////////////////////
	if( isPlayer(assignedOwner) )
	{
		self.iff_override_cb = &iff_vehicleCB;
		self.iffowner = assignedOwner;
	}
	self thread vehicle_ai::iff_override( assignedOwner );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iff_override(attacker,disableTimeMSEC) //self is robot
{
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
	wait (RandomFloatRange(0,0.75));
	if ( !(attacker cybercom::targetIsValid(self) ))
		return;

	entNum = self getEntityNumber();
	self notify("CloneAndRemoveEntity",entNum); //give self a heads up if level scripter isn't expecting a 'death' notify
	level notify("CloneAndRemoveEntity",entNum); 
	
	clone = CloneAndRemoveEntity(self);  //self just got deleted!
	if(!isDefined(clone))
		return;
	level notify("ClonedEntity",clone,entNum);
	
	clone.no_friendly_fire_penalty = true;
	clone SetTeam(attacker.team);
	
	if ( IsDefined( clone.favoriteenemy ) &&	IsDefined( clone.favoriteenemy._currentRogueRobot ) )
	{
		clone.favoriteenemy._currentRogueRobot = undefined;
	}
	clone.favoriteenemy = undefined;
		
	playfx(level._effect["iff_takeover"], clone.origin );
	clone thread _iff_leash_to_owner(attacker);
	clone.oldgoalradius = clone.goalradius;
	clone.goalradius = 512;
	clone.propername = _get_iff_robbotName();
	clone thread _iff_override_die_after(disableTime);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iff_override_revert_after(timeSec)
{
	self endon("death");
	wait timeSec;
	self SetTeam(self.oldteam);
	if(isDefined(self.oldgoalradius))
	{
		self.goalradius = self.oldgoalradius;
		self.oldgoalradius = undefined;
	}
	playfx(level._effect["iff_takeover_revert"], self.origin );
	self notify("iff_override_reverted");
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iff_override_die_after(timeSec)
{
	self endon("death");
	wait timeSec;
	playfx(level._effect["iff_takeover_death"], self.origin );
	self kill();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_iff_robbotName()
{
	name  = "";
	alpha = array("A","B","C","D","E","F");
	digit = array("0","1","2","3","4","5","6","7","8","9");
	for(i=0;i<6;i++)
	{
		byte  = "";
		if(RandomInt(100)<50)
			byte += alpha[RandomInt(alpha.size)];
		else
			byte += digit[RandomInt(digit.size)];
		if(RandomInt(100)<50)
			byte += alpha[RandomInt(alpha.size)];
		else
			byte += digit[RandomInt(digit.size)];
		
		name+=byte;
		if(i<5)
			name+="-";
	}
	return name;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateIFFOverride(target,disableTimeMSEC)
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
		guy thread _iff_override(self,disableTimeMSEC);
		{wait(.05);};
	}
}