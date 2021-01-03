    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     
                                                                                                            	   	

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_tactical_rig_emergencyreserve;
#using scripts\shared\array_shared;

	//#define MAX_SIMULTANEOUS_LOCKONS	5 this number corresponds to a code define

	// Projection for player forward to target roughly representative of "in front"



#namespace cybercom;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function wait_to_load()
{
	level flagsys::wait_till( "load_main_complete" );
	/#
	level thread cybercom_dev::cybercom_SetupDevgui();
	#/
	SetDvar( "scr_max_simLocks",5 );	//#define MAX_SIMULTANEOUS_LOCKONS	5 this number corresponds to a code define
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function vehicle_init_cybercom( vehicle )
{
	if( IsDefined( vehicle.archetype ) )
	{
		switch( vehicle.archetype )
		{
			case "hunter":
				//vehicle cybercom_AIOptOut( "cybercom_hijack" );
				//vehicle cybercom_AIOptOut( "cybercom_iffoverride" );
				vehicle cybercom_AIOptOut( "cybercom_servoshortout" );
				vehicle cybercom_AIOptOut( "cybercom_surge" );
				break;
			case "quadtank":
				vehicle cybercom_AIOptOut( "cybercom_surge" );
				vehicle cybercom_AIOptOut( "cybercom_servoshortout" );
				vehicle cybercom_AIOptOut( "cybercom_systemoverload" );
			default:
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function vehicle_update_cybercom_defence( vehicle, isSystemUp )
{
	if( isSystemUp )
	{	
		vehicle cybercom_AIOptOut( "cybercom_hijack" );
		vehicle cybercom_AIOptOut( "cybercom_iffoverride" );		
	}
	else
	{
		vehicle cybercom_AIClearOptOut( "cybercom_hijack" );
		vehicle cybercom_AIClearOptOut( "cybercom_iffoverride" );
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getCybercomFlags()
{
	assert(!( isdefined( self.cybercom.noFlagSet ) && self.cybercom.noFlagSet ));
	if(!( isdefined( self.cybercom.noFlagSet ) && self.cybercom.noFlagSet ))
	{
		self.cybercom.flags.tacrigs = self getcybercomrigs();
		self.cybercom.flags.type = self getcybercomactivetype();
		self.cybercom.flags.abilities = [];
		self.cybercom.flags.upgrades = [];
		for( i = 0; i <= 2; i++ )
		{
			self.cybercom.flags.abilities[i] = self getcybercomabilities( i );
			self.cybercom.flags.upgrades[i] = self getcybercomupgrades( i );
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function updateCybercomFlags()
{
	self getCybercomFlags();					//struct containing byte flags that indicates all the stuff player has
	self.cybercom.ccom_abilities 	= self cybercom_gadget::getAvailableAbilities();			//this is the list of what i have unlocked
	self.cybercom.menu	= "AbilityWheel";
	self.pers["cybercom_flags"] 	= self.cybercom.flags;	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function setCybercomFlags()
{
	self setcybercomrigsflags( self.cybercom.flags.tacrigs );
	self setcybercomactivetype( self.cybercom.flags.type );
	for( i = 0; i <= 2; i++ )
	{
		self setcybercomabilityflags( self.cybercom.flags.abilities[i], i );
		self setcybercomupgradeflags( self.cybercom.flags.upgrades[i], i );
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function setAbilitiesByFlags(flags)
{
	if( isDefined( flags ) )
	{
		self.cybercom.flags = flags;
	}
	self setCybercomFlags();	
	self cybercom::updateCybercomFlags();
	
	foreach(ability in self.cybercom.ccom_abilities )
	{
		status = self HasCyberComAbility(ability.name);
		if(status == 0 )
			continue;
		self cybercom_gadget::meleeAbilityGiven(ability,(status==2));
	}

	foreach (ability in level._cybercom_rig_ability)
	{
		status = self HasCyberComRig(ability.name);
		if(status == 0 )
			continue;
			
		self cybercom_tacrig::rigAbilityGiven(ability.name,(status==2));
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weaponLockWatcher(weapon, maxLocks)
{
	self endon( "disconnect" );
	self endon ( "death" );

	if ( !isDefined(self.cybercom.lock_targets) )
	{
		self.cybercom.lock_targets = [];
	}
	locks = (isDefined(maxLocks)?maxLocks:GetDvarInt( "scr_max_simLocks" ));
	assert(locks<=5,"exceeded code MAX_SIMULTANEOUS_LOCKONS");
	
	self thread weapon_lock_WatchTargets(weapon,locks);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weaponEndLockWatcher()
{
	self notify("ccom_stop_lock_on");
	waittillframeend;
	weapon_lock_ClearSlots();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_fired_watcher(weapon)
{
	self endon( "disconnect" );
	self endon( "death");
	self endon("ccom_stop_lock_on");
	event = self util::waittill_any_return(weapon.name+"_fired");
	level notify("ccom_lock_fired",self,weapon);
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target))
		{
			item.target notify("ccom_lock_fired",self,weapon);
		}
	}
	self notify("ccom_stop_lock_on");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_SightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isdefined( target ) ) //targets can disapear during targeting.
		return false;
	
	if ( !IsAlive( target ) )
		return false;
	
	if ( target IsRagdoll())
		return false;
	
	pos = target GetShootAtPos();
	if (IsDefined(pos))
	{
		passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
		if ( passed )
			return true;
	}

	pos = target GetCentroid();
	if (IsDefined(pos))
	{
		passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
		if ( passed )
			return true;
	}

	pos=target.origin+(0,0,12);
	passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
	if ( passed )
		return true;

	return false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function targetIsValid(target,lockReq=true)
{
	result = true;
	
	if ( !isdefined( target ) ) 
		return false;

	if (isDefined(target.cyberComTargetStatusOverride)) //scripter can set this on entity to either force requirement result
		return target.cyberComTargetStatusOverride;
	
	if ( !IsAlive( target ) )
		return false;
	
	if ( target IsRagdoll())
		return false;

	if ( ( isdefined( target.is_disabled ) && target.is_disabled ) )
		return false;

	if(!( isdefined( target.takedamage ) && target.takedamage ))
		return false;

    if( IsActor( target ) && target IsInScriptedState() )
    {
    	if(!target cybercom::isTurretDude())
  			return false;
	} 

	if(!( isdefined( target.allowdeath ) && target.allowdeath ))
		return false;
	
	if(lockReq && isDefined(self.cybercom) && isDefined(self.cybercom.targetLockRequirementCB))
	{
		result = self [[self.cybercom.targetLockRequirementCB]](target);
	}
	
	return result;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_meetsRangeRequirement( target, maxRange )
{
	if( isDefined( maxRange ) )
	{
		maxRangeSqr = maxRange * maxRange;
		distanceSqr = DistanceSquared( target.origin, self.origin );
		if( distanceSqr > maxRangeSqr )
			return false;
	}
	return true;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_meetsRequirement(target, radius )
{
	result = true;
	
	if (!self targetIsValid(target) )
		return false;
	
	if ( ! self _lock_SightTest(target) )
		return false;	
	
	if(isDefined(radius))
	{
		result = target_isincircle( target, self, 65, radius );
	}
	return result;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function TargetInsertionSortCompare(a, b)
{
	if (a.dot<b.dot)
		return -1;
	if (a.dot>b.dot)
		return 1;
	return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_ClearSlot(slot,note)
{
	if ( isDefined(self.cybercom.lock_targets[slot]))
	{
		item = self.cybercom.lock_targets[slot];
		removedEnt  = item.target;
		if(isDefined(removedEnt) )
		{
			if(isDefined(note))
			{
				removedEnt notify(note);
			}
			self WeaponLockRemoveSlot(item.lockSlot);
			item.target = undefined;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _weapon_lock_targetWatchForDeath(player)
{
	self endon("ccom_lost_lock");
	self notify("_weapon_lock_targetWatchForDeath");
	self endon("_weapon_lock_targetWatchForDeath");
	slot = player weapon_lock_AlreadyLocked(self);
	self util::waittill_any("death","ccom_lock_fired");
	player WeaponLockRemoveSlot(slot);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_SetTargetToSlot(slot,target, maxRange)
{
	if (slot == -1 || slot >= GetDvarInt( "scr_max_simLocks" ))
		return;
		
	if ( isDefined(self.cybercom.lock_targets[slot]))
	{
		self weapon_lock_ClearSlot(slot,"ccom_lost_lock");
		newitem 			= self.cybercom.lock_targets[slot];
		newitem.target 		= target;
	}
	else
	{
		newitem				= spawnstruct();
		newitem.target 		= target;
		newitem.lockSlot 	= slot;
		self.cybercom.lock_targets[slot] = newitem;
	}
	if(isDefined(newitem.target))
	{
		newItem.inRange = true;
		self WeaponLockFinalize( newitem.target, newitem.lockSlot );		
		if( !(self weapon_lock_meetsRangeRequirement( newitem.target, maxRange )))
		{
			newItem.inRange = false;
			self weaponlocknoclearance( true, slot );	
		}
		newitem.target notify ("ccom_locked_on");
		newitem.target thread _weapon_lock_targetWatchForDeath(self);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_AlreadyLocked(target)
{
	for(i=0;i<self.cybercom.lock_targets.size;i++)	///already in there
	{
		if( !isDefined(self.cybercom.lock_targets[i].target))
			continue;
			
		if (self.cybercom.lock_targets[i].target == target )
			return i;
	}				
	return -1;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_GetLockedOnTargets()
{
	targets= [];
	for(i=0;i<self.cybercom.lock_targets.size;i++)	///already in there
	{
		if( !isDefined(self.cybercom.lock_targets[i].target))
			continue;
			
		targets[targets.size] = self.cybercom.lock_targets[i].target;	
	}
	return targets;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_GetSlot(target, force=false)
{
	if ( self.cybercom.lock_targets.size < GetDvarInt( "scr_max_simLocks" ) )
		return self.cybercom.lock_targets.size;
		
	alreadyInSlot =  self weapon_lock_AlreadyLocked(target);
	if (alreadyInSlot != -1 )
	{
		return alreadyInSlot;
	}
	else
	{
		slot = -1;
		playerForward = AnglesToForward(self GetPlayerAngles());
		dots=[];
		for(i=0;i<self.cybercom.lock_targets.size;i++)
		{
			lockTarget 		= self.cybercom.lock_targets[i].target;
			if(!isDefined(lockTarget))
			{
				return i;
			}
			
				
			newitem			= spawnstruct();
			newitem.dot 	= VectorDot(playerForward,VectorNormalize(lockTarget.origin-self.origin));
			
			// Ensure this target isn't behind or too much to the sides of the player.
			if (newitem.dot > 0.83)
			{
				newitem.target 	= lockTarget;
				array::insertion_sort(dots,&TargetInsertionSortCompare,newitem);
			}
		}
		
		newitem			= spawnstruct();
		newitem.dot 	= VectorDot(playerForward,VectorNormalize(target.origin-self.origin));		
		newitem.target 	= target;
		array::insertion_sort(dots,&TargetInsertionSortCompare,newitem);
		worstTarget = dots[dots.size-1].target;
		if(!force && worstTarget == target)
		{
			return -1;
		}
		
		return self weapon_lock_AlreadyLocked(worstTarget);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_lock_ClearSlots()
{
	for(i=0;i<self.cybercom.lock_targets.size;i++)	///already in there
	{
	 	self weapon_lock_ClearSlot(i);	//reset slot
	}
	self WeaponLockRemoveSlot(-1);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function  weapon_lock_WatchTargets(weapon, maxTargets)
{
	self notify ("ccom_stop_lock_on");
	self endon( "ccom_stop_lock_on");
	self endon( "weapon_change" );
	self endon( "disconnect" );
	self endon( "death");

	radius = 130;
	if(!isdefined(maxTargets))maxTargets=3;

	self thread _lock_fired_watcher(weapon);
	
	if( maxTargets<1 )
		maxTargets = 1;
	if( maxtargets > 5 )
		maxTargets = 5;

	maxRange = 10000;
	if( isDefined( weapon.lockonmaxrange ) )
	{
		maxRange = weapon.lockonmaxrange;
	}
	
	validtargets = [];
	while(self HasWeapon(weapon))
	{
		self  weapon_lock_ClearSlots();//reset everthing
	
		if(isDefined(self.cybercom.targetLockCB))
		{
			enemies 		= self [[self.cybercom.targetLockCB]](weapon);
		}
		else
		{
			enemies 		= ArrayCombine(GetAITeamArray( "axis" ),GetAITeamArray( "team3" ),false,false);
		}
		validtargets 	= [];
		foreach( enemy in enemies )
		{
			if ( self weapon_lock_meetsRequirement(enemy,radius) )
			{
				validtargets[validtargets.size] = enemy;
			}
		}
		playerForward = AnglesToForward(self GetPlayerAngles());
		dots=[];
		foreach(target in validtargets)
		{
			newitem			= spawnstruct();
			newitem.dot 	= VectorDot(playerForward,VectorNormalize(target.origin-self.origin));
			
			// Ensure target is at least in front of the player, if not mostly on screen.
			// Rule out enemies behind the player as valid targets.
			if (newitem.dot > 0.83)
			{
				newitem.target 	= target;
				array::insertion_sort(dots,&TargetInsertionSortCompare,newitem);
			}
		}
		
		if(dots.size)
		{
			i = 0;
			foreach(item in dots)
			{
				i++;
				if (i>maxTargets)
				{
					break;
				}
				if(isDefined(item.target))
				{
					if ( self weapon_lock_AlreadyLocked(item.target) != -1 )
						continue;

					slot = self weapon_lock_GetSlot(item.target);
					if (slot == -1 )
						continue;

					self weapon_lock_SetTargetToSlot(slot,item.target,maxRange);
				}
			}
		}

		{wait(.05);};
	}
	self notify ("ccom_stop_lock_on");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function drawOriginForever()
{
/#
	self endon("death");
	for( ;; )
	{
		debug_Arrow( self.origin, self.angles );
		{wait(.05);};
	}
#/	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function debug_Arrow( org, ang, opcolor )
{
/#
	const scale = 50;
	forward = anglestoforward( ang );
	forwardFar = VectorScale( forward, scale );
	forwardClose = VectorScale( forward, ( scale * 0.8 ) );
	right = anglestoright( ang );
	leftdraw = VectorScale( right, ( scale * -0.2 ) );
	rightdraw = VectorScale( right, ( scale * 0.2 ) );
	
	up = anglestoup( ang );
	right = VectorScale( right, scale );
	up = VectorScale( up, scale );
	
	red = ( 0.9, 0.2, 0.2 );
	green = ( 0.2, 0.9, 0.2 );
	blue = ( 0.2, 0.2, 0.9 );
	if ( isdefined( opcolor ) )
	{
		red = opcolor;
		green = opcolor;
		blue = opcolor;
	}
	
	line( org, org + forwardFar, red, 0.9 );
	line( org + forwardFar, org + forwardClose + rightdraw, red, 0.9 );
	line( org + forwardFar, org + forwardClose + leftdraw, red, 0.9 );

	line( org, org + right, blue, 0.9 );
	line( org, org + up, green, 0.9 );
#/	
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function debug_Circle( origin, radius, seconds, color )
{
/#
	if ( !isdefined( seconds ) )
	{
		seconds = 1;
	}

	if ( !isdefined( color ) )
	{
		color = ( 1, 0, 0 );
	}

	frames = Int( 20 * seconds );
	Circle( origin, radius, color, false, true, frames );
#/	
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getClosestTo(origin,&entArray,minSQ)
{
	if (!isDefined(entArray) )
		return;

	if (entArray.size == 0 )
		return;

	bestEnt = undefined;
	bestSQ  = 2048*2048;
	
	if(!isDefined(minSQ) )
		minSQ = bestSQ;
		
	if (isDefineD(entArray) )
	{
		foreach (item in entArray)
		{
			if (!isDefined(item) || !isDefined(item.origin) )
			{
				continue;
			}
			distsq = distanceSquared( item.origin, origin );
			if ( distsq < bestSQ && distsq < minSQ )
			{
				bestEnt = item;
				bestSQ 	= distsq;
			}
		}
	}
	return bestEnt;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getArrayItemsWithin(origin,&entArray,minSQ)
{
	items	= [];
	
	if (isDefineD(entArray) && entArray.size )
	{
		foreach (item in entArray)
		{
			if (!isDefined(item) || !isDefined(item.origin) )
			{
				continue;
			}
			distsq = distanceSquared( item.origin, origin );
			if ( distsq < minSQ )
			{
				items[items.size] = item;
			}
		}
	}
	return items;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cybercom_AIOptOutGetFlag(name)
{
	ability = cybercom_gadget::getAbilityByName(name);
	if(isDefined(ability))
	{
		shift = 8*ability.type;
		return(ability.flag << shift);
	}
	else
	if( isDefined( level._cybercom_rig_ability[ name ] ))
	{
		return (1<<(24+level._cybercom_rig_ability[ name ].type));
	}
	else
	{
		return;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cybercom_AIOptOut(name) 
{
	if(!isDefined(self))
		return;

	flag = cybercom_AIOptOutGetFlag(name);
	if(!isDefined(flag))
		return;

	self cybercom_InitEntityFields();
	self.cybercom.optOutFlags |= flag;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cybercom_AIClearOptOut(name) 
{
	if(!isDefined(self))
		return;

	self cybercom_InitEntityFields();
	flag = cybercom_AIOptOutGetFlag(name);
	if(!isDefined(flag))
		return;
	
	self.cybercom.optOutFlags &= ~flag;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cybercom_AICheckOptOut(name) 
{
	if(!isDefined(self))
		return false;

	if(( isdefined( self.noCyberCom ) && self.noCyberCom ))
		return true;	

	self cybercom_InitEntityFields();
	
	flag = cybercom_AIOptOutGetFlag(name);
	if(!isDefined(flag))
		return false;
	
	if ( self.cybercom.optOutFlags & flag )
		return true;
		
	return false;
}

function cybercom_InitEntityFields()
{
	if(!isDefined(self.cybercom))
	{
		self.cybercom = spawnstruct();
	}
	
	if(!isDefined(self.cybercom.optOutFlags))
	{
		self.cybercom.optOutFlags = 0;
	}
}
function notifyMeOnMatchEnd(note,animName)
{
	self endon("death");
	self waittillmatch( animName, "end" );
	self notify(note);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function stopAnimScriptedOnNotify(note,animName)
{
	self notify("stopAnimScriptedOnNotify");
	self endon("stopAnimScriptedOnNotify");
	self endon("death");
	if(isDefined(animName))
		self thread notifyMeOnMatchEnd("stopAnimScriptedOnNotify",animName);
	
	self waittill(note);
	if(self IsInScriptedState())
	{
		self StopAnimScripted();
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function isTurretDude()
{
	if(isDefined(self.rider_info))
	{
		if(isDefined(self.rider_info.position) && issubstr(self.rider_info.position,"gunner"))
			return true;
	}
	return false;
}

function getAnimationVariant(min=0,max=2)
{
	roll = RandomInt(max+1);
	if(roll == 0 )
		return "";
	else
		return ("_"+roll);//"_1" or "_2" are valid
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function debug_box( origin, mins, maxs, yaw=0, frames=20, color=(1,0,0) )
{
/#
	Box( origin, mins, maxs, yaw, color, 1, false, frames );
#/	
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function debug_sphere( origin, radius, color=(1,0,0), alpha=.1, timeFrames=1 )
{
/#
	sides = Int(10 * ( 1 + Int(radius) % 100 ));
	sphere( origin, radius, color, alpha, true, sides, timeFrames );
#/	
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function notifyMeInNSec(note,seconds)
{
	self endon(note);
	self endon("death");
	wait seconds;
	self notify(note);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function notifyMeOnNote(note,waitnote)
{
	self endon(note);
	self endon("death");
	self waittill(waitnote);
	self notify(note);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function deleteEntOnNote(note,ent)
{
	ent endon("death");
	self waittill(note);
	if(isDefined(ent))
		ent delete();
}


/@
"Name: cyberCom_armPulse()"
"Summary: Turns on the cyber arm pulse of a player, actor, or script model."
"CallOn: The entity with an arm that cyber pulses"
"For e_pulse_type, use:"
"ARM_PULSE_CYBERCOM_ABILITY"
"ARM_PULSE_HACKING"
"ARM_PULSE_REVIVE"
@/
function cyberCom_armPulse(e_pulse_type)
{
	if ( IsPlayer( self ) )
	{
		clientfield::increment_to_player( "cyber_arm_pulse", e_pulse_type);
	}
	else
	{
		clientfield::increment( "cyber_arm_pulse", e_pulse_type);
	}
}
