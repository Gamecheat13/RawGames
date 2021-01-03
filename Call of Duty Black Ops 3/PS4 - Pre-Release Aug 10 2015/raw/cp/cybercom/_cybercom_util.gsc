           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
                                                                                                             	     	                                                                                                                                                                
                                                                                                                                                                                     	   	                                                                      	  	  	

#using scripts\shared\ai\systems\blackboard;
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
#using scripts\shared\math_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\cp\_bb;
                                                                                                                                                                                                       	     	                                                                                   

	//#define MAX_SIMULTANEOUS_LOCKONS	5 this number corresponds to a code define

	// Projection for player forward to target roughly representative of "in front"



	



	//each second, this amount will decay from the acumulated total.  The QuadTank, who has been hacked 50% (has accumlator of 5) will be comepletely depleted/decayed in 20 seconds
	
	//3seconds

	

	//8meters

	
#namespace cybercom;
#precache( "lui_menu_data", "HackingProgress" );
#precache( "lui_menu_data", "HackingVisibleFPP" );
#precache( "lui_menu_data", "HackingVisibleTPP" );
#precache( "lui_menu_data", "AbilityWheel.Selected1" );
#precache( "lui_menu_data", "AbilityWheel.Selected2" );
#precache( "lui_menu_data", "AbilityWheel.Selected3" );

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
		vehicle.lockon_timeduration = [];
		switch( vehicle.archetype )
		{
			case "hunter":
				vehicle cybercom_AIOptOut( "cybercom_surge" );
				vehicle cybercom_AIOptOut( "cybercom_servoshortout" );
				vehicle cybercom_AIOptOut( "cybercom_systemoverload" );
				vehicle cybercom_AIOptOut("cybercom_smokescreen");
				vehicle.lockon_timeduration["cybercom_hijack"] 		= GetDvarInt( "scr_hacktime_quadtank",11 );
				vehicle.lockon_timeduration["cybercom_iffoverride"] = GetDvarInt( "scr_hacktime_quadtank",11 );
				vehicle.lockon_accumulator =0;
				break;
			case "quadtank":
				vehicle cybercom_AIOptOut( "cybercom_surge" );
				vehicle cybercom_AIOptOut( "cybercom_servoshortout" );
				vehicle cybercom_AIOptOut( "cybercom_systemoverload" );
				vehicle cybercom_AIOptOut("cybercom_smokescreen");
				
				vehicle.lockon_timeduration["cybercom_hijack"] 		= GetDvarInt( "scr_hacktime_quadtank",11 );
				vehicle.lockon_timeduration["cybercom_iffoverride"] = GetDvarInt( "scr_hacktime_quadtank",11 );
				vehicle.lockon_accumulator =0;
				break;
			case "siegebot":
				vehicle cybercom_AIOptOut( "cybercom_servoshortout" );
				vehicle cybercom_AIOptOut( "cybercom_systemoverload" );
				vehicle cybercom_AIOptOut("cybercom_smokescreen");
				vehicle.lockon_timeduration["cybercom_hijack"] 		= GetDvarInt( "scr_hacktime_siegebot",9 );
				vehicle.lockon_timeduration["cybercom_iffoverride"] = GetDvarInt( "scr_hacktime_siegebot",9 );
				vehicle.lockon_accumulator =0;
				break;
			case "parasite":
			case "glaive":
				vehicle.noCybercom = true;				
			default:
				break;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function vehicle_update_cybercom_defense( vehicle, isSystemUp )
{
	if( isSystemUp )
	{	
	//	vehicle.no_hijack 	= true;
		vehicle.no_iff 		= true;
	}
	else
	{
		vehicle.no_hijack 	= undefined;
		vehicle.no_iff 		= undefined;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getCybercomFlags()
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
function isCyberComUpgraded( cybercomRef )
{
	// itemRef for upgrades are appended with '_pro'
	itemIndex = GetItemIndexFromRef( cybercomRef + "_pro" );
	if ( itemIndex != -1 )
	{
		return self IsItemPurchased( itemIndex );
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function giveCyberCoreAbilitiesFromStats( cybercore_type )
{
	cybercom::debugMsg( "CYBERCORE: " + cybercore_type );

	abilities = cybercom_gadget::getAbilitiesForType( cybercore_type );
	foreach ( ability in abilities )
	{
		itemIndex = GetItemIndexFromRef( ability.name );

		if ( self IsItemPurchased( itemIndex ) )
		{
			upgraded = self isCyberComUpgraded( ability.name );
			self SetCyberComAbility( ability.name, upgraded );
			cybercom::debugMsg( ability.name + " UPGRADED: " + upgraded );
		}
		else
		{
			cybercom::debugMsg( ability.name + " NOT INSTALLED" );
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function equipMeleeCybercomAbility( cybercom_type )
{
	switch( cybercom_type )
	{
		case 0:
			self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_ravagecore"));
			break;
		case 1:
			self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_rapidstrike"));
			break;
		case 2:
			self cybercom_gadget::meleeAbilityGiven(cybercom_gadget::getAbilityByName("cybercom_es_strike"));
			break;
	}
}

function equipFirstAvailableCyberCom( cybercom_type, restoreCybercom )
{
	if(( SessionModeIsCampaignZombiesGame() ))
		return;
	
	lastEquippedCybercomStat = Int( self GetDStat( "PlayerStatsList", "LAST_CYBERCOM_EQUIPPED", "statValue" ) );
	
	lastEquippedCybercomIndex = lastEquippedCybercomStat & ( ( 1 << 10 ) - 1 );
	lastEquippedCybercomButton = lastEquippedCybercomStat >> 10;
	
	self equipMeleeCybercomAbility( cybercom_type );
	
	if( ( isdefined( restoreCybercom ) && restoreCybercom ) && lastEquippedCybercomIndex > 99 && lastEquippedCybercomIndex < 142 )
	{
		lastEquippedCybercomName = TableLookup( "gamedata/stats/cp/cp_statstable.csv", 0, lastEquippedCybercomIndex, 4 );
		cybercomAbility = cybercom_gadget::getAbilityByName( lastEquippedCybercomName );
		
		if( self HasCyberComAbility( cybercomAbility.name ) )
		{
			rig1 = self GetLoadoutItemRef( self.class_num, "cybercom_tacrig1" );
			rig2 = self GetLoadoutItemRef( self.class_num, "cybercom_tacrig2" );
			
			if( cybercom_type == cybercomAbility.type || rig1 == "cybercom_multicore" || rig2 == "cybercom_multicore" )
			{
				self.lastEquippedCybercomButton = lastEquippedCybercomButton;
				self cybercom_gadget::equipability( cybercomAbility.name, false );
				
				//Update the UI to automatically be set to the ability
				self SetControllerUIModelValue( "AbilityWheel.Selected" + ( cybercomAbility.type + 1 ), self.lastEquippedCybercomButton );
				return;
			}
		}
	}
	
	//reset the ui
	self clientfield::set_to_player( "resetAbilityWheel", 1 );
	
	abilities = cybercom_gadget::getabilitiesfortype( cybercom_type );
	abilityIndex = 1;
	foreach( ability in abilities )
	{
		if( self HasCyberComAbility( ability.name ) )
		{
			self.lastequippedcybercombutton = abilityIndex;
			self cybercom_gadget::equipability( ability.name, false );
			return;
		}
		abilityIndex++;
	}
}


function giveCyberComLoadout( class_num, class_num_for_global_weapons, restoreCybercom )
{
	self ClearCyberComAbility();

	rig1 = self GetLoadoutItemRef( class_num, "cybercom_tacrig1" );
	rig2 = self GetLoadoutItemRef( class_num, "cybercom_tacrig2" );

	rig1_upgraded = self isCyberComUpgraded( rig1 );
	rig2_upgraded = self isCyberComUpgraded( rig2 );
	
	self SetCyberComRig( rig1, rig1_upgraded );
	self SetCyberComRig( rig2, rig2_upgraded );

	cybercom::debugMsg( "RIG1: " + rig1 + " UPGRADED:" + rig1_upgraded );
	cybercom::debugMsg( "RIG2: " + rig2 + " UPGRADED:" + rig2_upgraded );

	for ( cybercore_type = 0; cybercore_type <= 2; cybercore_type++ )
	{
		self giveCyberCoreAbilitiesFromStats( cybercore_type ); 
	}
	
	cybercoreRefMap["cybercore_control"] = 0;
	cybercoreRefMap["cybercore_martial"] = 1;
	cybercoreRefMap["cybercore_chaos"] = 2;

	cybercoreRef = self GetLoadoutItemRef( class_num_for_global_weapons, "cybercore" );

	if( cybercoreRef != "weapon_null" && cybercoreRef != "weapon_null_cp" && isDefined(cybercoreRefMap[ cybercoreRef]) ) //required for bots
	{
		self SetCyberComActiveType( cybercoreRefMap[ cybercoreRef] );
		
		self equipFirstAvailableCyberCom( cybercoreRefMap[ cybercoreRef ], restoreCybercom );
	
		self cybercom::updateCybercomFlags();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weaponLockWatcher(slot, weapon, maxLocks)
{
	self endon( "disconnect" );
	self endon ( "death" );

	if ( !isDefined(self.cybercom.lock_targets) )
	{
		self.cybercom.lock_targets = [];
	}

	locks = (isDefined(maxLocks)?maxLocks:GetDvarInt( "scr_max_simLocks" ));
	assert(locks<=5,"exceeded code MAX_SIMULTANEOUS_LOCKONS");
	
	self thread weaponLockWatchTargets(slot, weapon,locks);
	self thread weaponLockAutoFire(slot, weapon);
	self thread weaponLockAbortWatcher(slot, weapon);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weaponLockAbortWatcher(slot,weapon)
{
	self endon( "disconnect" );
	self endon ( "death" );
	self endon("weaponEndLockWatcher");
	self endon("ccom_stop_lock_on");
	self notify("weaponLockAbortWatcher");
	self endon("weaponLockAbortWatcher");
	
	if(!isDefined(self.cybercom.abortConditions))
		return;

	if(self.cybercom.abortConditions & 1 )
	{
		self thread weaponLockIssueAbortOnNote("weapon_change");
	}
	if(self.cybercom.abortConditions & 2 )
	{
		self thread weaponLockIssueAbortOnNote("reload");
	}
	if(self.cybercom.abortConditions & 4 )
	{
		self thread weaponLockIssueAbortOnNote("weapon_fired");
	}
	if(self.cybercom.abortConditions & 8 )
	{
		self thread weaponLockIssueAbortOnNote("weapon_melee");		//there a bunch of melee notifies, they all seem to call melee_end though..
		self thread weaponLockIssueAbortOnNote("melee_end");
	}
	if(self.cybercom.abortConditions & 16 )
	{
		self thread weaponLockIssueAbortOnNote("weapon_ads");
	}
	if(self.cybercom.abortConditions & 32 )
	{
		self thread weaponLockIssueAbortOnNote("damage");
	}
	
	self waittill("weaponLockAbort", reason);
	self cybercomSetFailHint(8);
	self GadgetDeactivate( slot, weapon,1);
}

function weaponLockIssueAbortOnNote(note)
{
	self endon("ccom_stop_lock_on");
	self endon("weaponLockAbort");
	self waittill(note);
	self notify("weaponLockAbort",note);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weaponLockAutoFire(slot,weapon)
{
	self notify("weaponLockAutoFire");
	self endon("weaponLockAutoFire");
	self endon( "disconnect" );
	self endon ( "death" );
	self endon("weaponEndLockWatcher");
	self endon("ccom_stop_lock_on");
	while(1)
	{
		for(i=0;i<self.cybercom.lock_targets.size;i++)	///already in there
		{
			if( !isDefined(self.cybercom.lock_targets[i].target))
				continue;
			
			if ( !isDefined(self.cybercom.lock_targets[i].target.lockon_owner) || self.cybercom.lock_targets[i].target.lockon_owner !=self )
				continue;
			
			if ( isDefined(self.cybercom.lock_targets[i].target.lockon_progress ) && self.cybercom.lock_targets[i].target.lockon_progress != 1 )
				continue;
	
			//we are hacking something
			//progress is at 100%
			//design wishes to auto fire
			if(isDefined(self.cybercom.autoActivate))
			{
				UI_HackEnd(self);
				[[self.cybercom.autoActivate]](slot,weapon);
				return;
			}
		}
		
		{wait(.05);};
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weaponEndLockWatcher( weapon )
{
	self cybercomHintResults( weapon );
	waittillframeend;
	weapon_lock_ClearSlots(true);
	self weapon_notifyLastLocks(); //come after the clear
	self notify("ccom_stop_lock_on");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _weaponAbortWatcher(weapon)
{
	self notify("weaponEndLockWatcher");
	self endon("weaponEndLockWatcher");
	self endon("ccom_stop_lock_on");
	self waittill("gadget_forced_off",slot,offweapon);
	if(weapon == offweapon)
	{
		self weaponEndLockWatcher(weapon);
	}
	else
		self thread  _weaponAbortWatcher(weapon);
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
			if(isDefined(item.target.lockon_owner) && item.target.lockon_owner == self )
			{
				item.target.lockon_owner = undefined;
			}
		}
	}
	self weaponEndLockWatcher( weapon );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_SightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isdefined( target ) ) //targets can disapear during targeting.
		return 0;
	
	if ( !IsAlive( target ) )
		return 0;
	
	if ( target IsRagdoll())
		return 0;
	
	
	if(!isDefined(target.cybercom))
	{
		target.cybercom = spawnstruct();
	}
	if(!isDefined(target.cybercom.sightTraceTests))
	{
		target.cybercom.sightTraceTests = [];
	}
	
	pos = target GetShootAtPos();
	if (IsDefined(pos))
	{
		passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
		if ( passed )
		{
			target.cybercom.sightTraceTests[self GetEntityNumber()] = GetTime();
			return 1;
		}
	}

	pos = target GetCentroid();
	if (IsDefined(pos))
	{
		passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
		if ( passed )
		{
			target.cybercom.sightTraceTests[self GetEntityNumber()] = GetTime();
			return 1;
		}
	}

	pos=target.origin+(0,0,12);
	passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
	if ( passed )
	{
		target.cybercom.sightTraceTests[self GetEntityNumber()] = GetTime();
		return 1;
	}
	

	lastSeen = target.cybercom.sightTraceTests[self GetEntityNumber()];
	if(isDefined(lastSeen) && lastSeen+GetDvarInt( "scr_los_latency",3000 )>GetTime())
	{
	 	trace 	= BulletTrace( eyePos, pos, false, target);
	 	distSQ 	= distancesquared(pos,trace[ "position" ]);
	 	if(distSQ<= GetDvarInt( "scr_cached_dist_threshhold", ( (315) * (315) ) ))
			return 2;
	 	else
			return 0;
	}
	else
	{
		return 0;
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function targetIsValid(target,lockReq=true)
{
	result = true;

	////// CORE SANITY CHECKS \\\\\\	
	if ( !isdefined( target ) ) 
		return false;

	if ( !IsAlive( target ) )	
		return false;
	
	if ( target IsRagdoll())
		return false;

	if ( ( isdefined( target.is_disabled ) && target.is_disabled ) )//this flag gets set if dude is already cybercom'd with something else.  stacking an effect could be troublesome
		return false;

	if(!( isdefined( target.takedamage ) && target.takedamage ))
		return false;
	
	if (isDefined(target._ai_melee_opponent))
		return false;	
	////// CORE SANITY CHECK END \\\\\\	

	if (isDefined(target.cyberComTargetStatusOverride)) //scripter can set this on entity to either force requirement result
	{
		if ( target.cyberComTargetStatusOverride == false )
			return false;
	}
	else
	{
		if ( ( isdefined( target.magic_bullet_shield ) && target.magic_bullet_shield ))
			return false;
	
	    if( IsActor( target ) && target IsInScriptedState() )
	    {
			if(isDefined(self.rider_info))
			{
				if(isDefined(self.rider_info.position) && issubstr(self.rider_info.position,"gunner"))
					return true;
			}
	 	} 
	
	    if(isDefined(target.allowdeath) && !target.allowdeath)
	    	return false;
	}
    
	if(lockReq && isDefined(self.cybercom) && isDefined(self.cybercom.targetLockRequirementCB))
	{
		result = self [[self.cybercom.targetLockRequirementCB]](target);
	}

	//allow level script to have final say
	if(result && isDefined(level.cybercomTargetLockRequirementCB) )
	{
		result &= [[level.cybercomTargetLockRequirementCB]](self, target);
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
	{
		if (self.cybercom.fail_type == 0 )
			self cybercomSetFailHint(4);
		return false;
	}
	
	losResult = self _lock_SightTest(target);
	if ( losResult == 0)
	{
		if (self.cybercom.fail_type == 0 )
			self cybercomSetFailHint(5);
		return false;	
	}
	if( losResult == 2 )
	{
		radius *=2;//give the radius a boost; this guy just went behind something; increasing the radius helps keep the lock on.
	}
	
	if(isDefined(radius))
	{
		result = target_isincircle( target, self, 65, radius );
	}
	if(result == false )
	{
		if (self.cybercom.fail_type == 0 )
			self cybercomSetFailHint(4);
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
function weapon_lock_ClearSlot(slot,note,clearProgress)
{
	if ( isDefined(self.cybercom.lock_targets[slot]))
	{
		item = self.cybercom.lock_targets[slot];
		if(isDefined(item.target) )
		{
			if(isDefined(note))
			{
				item.target notify(note);
			}
			self WeaponLockRemoveSlot(item.lockSlot);
			if(( isdefined( clearProgress ) && clearProgress ))
			{
				item.target.lockon_owner 		= undefined;
				item.target.lockon_lockstart 	= undefined;
				item.target.lockon_progress 	= undefined; 
			
			}
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
	if(isDefined(target.lockon_lockBlock) && GetTime()<target.lockon_lockBlock )
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
		if(isDefined(newitem.target.lockon_timeduration) && isDefined(newitem.target.lockon_timeduration[self.cybercom.lastEquipped.name]))
		{
			if(!isDefined(newitem.target.lockon_owner))
			{
				newitem.target.lockon_lockstart = GetTime() - newitem.target.lockon_accumulator;
				newitem.target.lockon_owner = self;
				newitem.target notify("ccom_lock_started");
				curStart = newitem.target.lockon_accumulator / (newitem.target.lockon_timeduration[self.cybercom.lastEquipped.name]*1000);
				UI_HackStart(self,newitem.target.lockon_timeduration[self.cybercom.lastEquipped.name],curStart);
				level thread UI_HackWatchAbort(self);
			}
			if ( isDefined(newitem.target.lockon_owner) && newitem.target.lockon_owner == self )
			{
				newitem.target.lockon_progress = math::clamp(((GetTime()-newitem.target.lockon_lockstart)/(newitem.target.lockon_timeduration[self.cybercom.lastEquipped.name]*1000)),0,1);
			}
		}
		self WeaponLockStart( newitem.target, newitem.lockSlot );		
		newItem.inRange = 1;
		if( !(self weapon_lock_meetsRangeRequirement( newitem.target, maxRange )))
		{
			newItem.inRange = 0;
			self weaponlocknoclearance( true, slot );	
		}
		if( isDefined(newitem.target.lockon_progress) )
		{
			if(newitem.target.lockon_owner == self )
			{
				if(newitem.target.lockon_progress!= 1)
				{
					newItem.inRange = 2;
					self weaponlocknoclearance( true, slot );	
				}
			}
			else
			{
				newItem.inRange = 0;
				self weaponlocknoclearance( true, slot );	
			}
		}
		if(newItem.inRange == 1 )
		{
		 	UI_HackEnd(self);
		 	self weaponlocknoclearance( false, slot );
			self WeaponLockFinalize( newitem.target, newitem.lockSlot );		
			newitem.target notify ("ccom_locked_on",self);
			level notify ("ccom_locked_on",newitem.target,self);
		}
		else
		{
			newitem.target notify ("ccom_lock_being_targeted",self);
			level notify ("ccom_lock_being_targeted",newitem.target,self);
		}
		newitem.target thread _weapon_lock_targetWatchForDeath(self);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function UI_HackStart(hacker,duration,startRatio)
{
	val = duration & 0x1f;					//total time that hack takes
	if(startRatio > 0 )
	{
		cur		 = math::clamp(startRatio,0,1);
		offset 	 = (int(cur*128))<<5;					//accounts for accumaled start.
		val		 += offset;
	}
	hacker clientfield::set_to_player( "hacking_progress", val );
	hacker clientfield::set_to_player( "sndCCHacking", 1 );
}
function UI_HackEnd(hacker)
{
	if(isDefined(hacker))
	{
		hacker clientfield::set_to_player( "hacking_progress", 0 );
		hacker clientfield::set_to_player( "sndCCHacking", 0 );
	}
	
}
function UI_HackWatchAbort(hacker)
{
	hacker util::waittill_any("death","ccom_lockOnProgress_Cleared","ccom_lost_lock","ccom_locked_on");
	UI_HackEnd(hacker);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
			dotTolerance	= (isDefined(self.cybercom.dotTolerance)?self.cybercom.dotTolerance:0.83);
			// Ensure this target isn't behind or too much to the sides of the player.
			if (newitem.dot > dotTolerance)
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
function weapon_lock_ClearSlots(clearProgress=false)
{
	for(i=0;i<self.cybercom.lock_targets.size;i++)	///already in there
	{
	 	self weapon_lock_ClearSlot(i,undefined,clearProgress);	//reset slot
	}
	self WeaponLockRemoveSlot(-1);
	self.cybercom.lock_targets = [];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function weapon_AdvertiseAbility(weapon)
{
	self endon( "disconnect" );
	self notify("weapon_AdvertiseAbility");
	self endon("weapon_AdvertiseAbility");
	
	if(weapon.requirelockontofire)
	{
		maxRange = 1500;
		if( isDefined( weapon.lockonmaxrange ) )
		{
			maxRange = weapon.lockonmaxrange;
		}
		maxRangeSQR = ( (maxRange) * (maxRange) );
	}
	else
	{
		maxRangeSQR = 0;
	}
		
	while(self HasWeapon(weapon))
	{
		if(maxRangeSQR > 0 )//weapons that are not range based such as active cammo should advertise always
		{
			if(isDefined(self.cybercom.targetLockCB))
			{
				enemies = self [[self.cybercom.targetLockCB]](weapon);
			}
			else
			{
				enemies = ArrayCombine(GetAITeamArray( "axis" ),GetAITeamArray( "team3" ),false,false);
			}
			
			foreach( enemy in enemies )
			{
				distSQ = distancesquared(self.origin,enemy.origin);
				if(distSQ > maxRangeSQR )
					continue;
				
				// Ensure target validity.
				if ( !targetIsValid(enemy) )
					continue;
				
				advertiseAbility = true;
				break;
			}
		}
		else
		{
			advertiseAbility = true;
		}
		
		// 
		// 
		self clientfield::set_player_uimodel( "playerAbilities.inRange", advertiseAbility );
		{wait(.05);};
	}
	advertiseAbility = false; //weapon taken
	self clientfield::set_player_uimodel( "playerAbilities.inRange", advertiseAbility );
}

function weapon_lock_decayAccumulator()
{
	self endon("death");
	self notify("weapon_lock_decayAccumulator");
	self endon("weapon_lock_decayAccumulator");
	self endon("ccom_lock_started");
	
	perTick = int((GetDvarFloat( "scr_hacktime_decay_rate",.25 )/20)*1000);
	while(self.lockon_accumulator>0)
	{
		{wait(.05);};
		self.lockon_accumulator -= perTick;
		if(self.lockon_accumulator<0)
			self.lockon_accumulator = 0;
	}
}

	
function weapon_notifyLastLocks()
{
	if(!isDefined(self.cybercom.lastlockedTargets) || self.cybercom.lastlockedTargets.size == 0 )
		return;
	
	lastLockedtargets = [];
	
	foreach (target in self.cybercom.lastlockedTargets)
	{
		if(!isDefined(target))
			continue;

		found = false;		
		if(self.cybercom.lock_targets.size)
		{
			foreach (lockItem in self.cybercom.lock_targets)
			{
				if(!isDefined(lockItem.target))
					continue;
				if(lockItem.target == target)
				{
					found = true;
					break;
				}
			}
		}
		if(!found)
		{
			target notify("ccom_lost_lock",self);
			level notify("ccom_lost_lock",target,self);
			if(isDefined(target.lockon_owner) && target.lockon_owner == self)
			{
				UI_HackEnd(self);

				target.lockon_owner	 = undefined;
				target.lockon_accumulator = GetTime()-target.lockon_lockstart;
				target thread weapon_lock_decayAccumulator();
				target.lockon_lockstart = undefined;
				target.lockon_lockBlock = GetTime()+150;
				target.lockon_progress = undefined; 
			}
		}
		else
		{
			lastLockedtargets[lastLockedtargets.size] = target;
		}
	}
	self.cybercom.lastlockedTargets = lastLockedtargets;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function  weaponLockWatchTargets(slot, weapon, maxTargets)
{
	self notify ("ccom_stop_lock_on");
	self endon( "ccom_stop_lock_on");
	self endon( "weapon_change" );
	self endon( "disconnect" );
	self endon( "death");

	// Does this ability want to override the default lock radius?
	radius = (isDefined(self.cybercom.lockRadius)?self.cybercom.lockRadius:130);
	
	if(!isdefined(maxTargets))maxTargets=3;

	self thread _lock_fired_watcher(weapon);
	self thread _weaponAbortWatcher(weapon);
	
	
	if( maxTargets<1 )
		maxTargets = 1;
	if( maxtargets > 5 )
		maxTargets = 5;

	maxRange = 1500;
	if( isDefined( weapon.lockonmaxrange ) )
	{
		maxRange = weapon.lockonmaxrange;
	}
	maxRangeSQR = ( (maxRange) * (maxRange) );
	
	validtargets = [];
	dots=[];
	
	while(self HasWeapon(weapon))
	{
		self weapon_notifyLastLocks();
		self weapon_lock_ClearSlots();//reset everthing
		self.cybercom.fail_type = 0;
	
		if(isDefined(self.cybercom.targetLockCB))
		{
			enemies = self [[self.cybercom.targetLockCB]](weapon);
		}
		else
		{
			enemies = ArrayCombine(GetAITeamArray( "axis" ),GetAITeamArray( "team3" ),false,false);
		}
		
		if(enemies.size == 0 )
		{
			self cybercomSetFailHint(4);
		}
		inFOVenemies = [];
		playerForward = AnglesToForward(self GetPlayerAngles());
		tagAim	= self GetTagOrigin("tag_aim");

		//playerForward = (playerForward[0],playerForward[1],0);
		foreach( enemy in enemies )
		{
			center = enemy GetCentroid();
			dirToTarget = VectorNormalize( center - tagAim);
			enemy.dotToPlayer = VectorDot( dirToTarget, playerForward );
			
			// Does this ability want to override the default targeting FOV?
			dotTolerance = (isDefined(self.cybercom.dotTolerance)?self.cybercom.dotTolerance:0.83);
			
			// Ensure target is at least in front of the player, if not mostly on screen.
			// Rule out enemies behind the player as valid targets.
			if (enemy.dotToPlayer > dotTolerance)
			{
				inFOVenemies[inFOVenemies.size] = enemy;
			}
		}
		if(inFOVenemies.size == 0 )
		{
			self cybercomSetFailHint(4);
		}
		
		validtargets 	  = [];
		potentialtargets  = [];
		foreach( enemy in inFOVenemies )
		{
			if(isDefined(enemy.cybercomLockReq))
			{
				result = enemy [[enemy.cybercomLockReq]](self,weapon);
				if(isDefined(result))
				{
					if(result)
					{
						validtargets[validtargets.size] = enemy;
					}
					continue;
				}
			}
			
			if ( !self weapon_lock_meetsRequirement(enemy,radius) )
			{
				continue;
			}
			distSQ = distancesquared(self.origin,enemy.origin);
			if(distSQ > maxRangeSQR )
			{
				self cybercomSetFailHint(2);
				continue;
			}
		
			validtargets[validtargets.size] = enemy;
		}
		
		lastDotSize = dots.size;
		dots=[];
		foreach(target in validtargets)
		{
			newitem			= spawnstruct();
			newitem.dot 	= target.dotToPlayer;
			newitem.target 	= target;
			array::insertion_sort(dots,&TargetInsertionSortCompare,newitem);
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
					
					if(!IsInArray(self.cybercom.lastlockedTargets,item.target))
					{
						self.cybercom.lastlockedTargets[self.cybercom.lastlockedTargets.size] = item.target;
					}
					self weapon_lock_SetTargetToSlot(slot,item.target,maxRange);
				}
			}
			//if(lastDotSize == 0 )//if we didnt have any highlighted targets, but now we do, shake the controller
			{
				self PlayRumbleOnEntity( "damage_light" );
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
function getClosestTo(origin,entArray,max)
{
	if (!isDefined(entArray) )
		return;

	if (entArray.size == 0 )
		return;
	
	ArraySortClosest	(entArray,origin,1,0,(isDefined(max)?max:2048));
	return entArray[0];
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
	self endon(note);
	self endon("death");
	self waittillmatch( animName, "end" );
	self notify(note);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function stopAnimScriptedOnNotify(note,animName,kill=false,attacker,weapon)
{
	self notify("stopOnNotify"+note+animName);
	self endon("stopOnNotify"+note+animName);
	if(isDefined(animName))
		self thread notifyMeOnMatchEnd("stopOnNotify"+note+animName,animName);
	
	self util::waittill_any_return(note,"death");
	if(isDefined(self) && self IsInScriptedState())
	{
		self StopAnimScripted(0.3);
	}
	if(isAlive(self) && ( isdefined( kill ) && kill ))
	{
		self kill(self.origin,(isDefined(attacker)?attacker:undefined),undefined,weapon);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function isInstantKill()
{
	if (( isdefined( self.instant_cybercom_death ) && self.instant_cybercom_death ))
		return true;
	    
	if(isDefined(self.rider_info))
	{
		if(isDefined(self.rider_info.position) && issubstr(self.rider_info.position,"gunner"))
			return true;
		if(isDefined(self.rider_info.aligntag) && issubstr(self.rider_info.aligntag,"gunner"))
			return true;
	}
	if(isDefined(self.archetype) && self.archetype =="robot" && !cybercom::hasBothLegs(self))
		return true;
	
	if(isActor(self) && !self IsOnGround() )	//situation here is guys hit with ability when airborne will cause an animscripted event on them and they will slowly float down.
		return true;

	
	return false;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function isLinked()//when new exes post, remove this in favor of the API
{
	return (isDefined(self GetLinkedEnt()));
}

function seedAnimationVariant(context,max=2)
{
	if(!isDefined(self.cybercom.variants))
		self.cybercom.variants = [];

	if(isDefined(self.cybercom.variants[context]))
		self.cybercom.variants[context] = undefined;
	
	self.cybercom.variants[context] = spawnstruct();
	self.cybercom.variants[context].curVariant = 0;
	self.cybercom.variants[context].maxVariant = max;
}

function getAnimationVariant(context)
{
	if(!isDefined(self.cybercom) || !isDefined(self.cybercom.variants) || !isDefined(self.cybercom.variants[context]))
		return "";
	
	cur = self.cybercom.variants[context].curVariant;
	self.cybercom.variants[context].curVariant++;
	
	if (self.cybercom.variants[context].curVariant>self.cybercom.variants[context].maxVariant)
		self.cybercom.variants[context].curVariant = 0;
	
	if (cur == 0 )
		return "";
	else 
		return ("_"+cur);//"_1" or "_2" etc.. are valid
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getEntityPose()
{
	assert(IsActor(self),"can only be used on actors");
	return Blackboard::GetBlackBoardAttribute( self, "_stance");//"_stance" );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function getAnimPrefixForPose()
{
	assert(IsActor(self),"can only be used on actors");
	stance =  self getEntityPose();
	if(stance == "stand" )
		return "stn";
	if(stance == "crouch" )
		return "crc";
	return "";
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function debugMsg(txt)
{
	/#
		println("[CYBERCOM] " + txt);
	#/
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function hasBothLegs(entity)
{
	if(( isdefined( entity.missingLegs ) && entity.missingLegs ) )
		return false;
	if(( isdefined( entity.isCrawler ) && entity.isCrawler ) )
		return false;
	return ((GibServerUtils::IsGibbed( entity, (128+256))==0)?true:false);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function gadgetOffOnNotify(slot,weapon,watchNote,endNote)
{
	self endon("death");//gadget will turn off automatically on death
	self endon(endNote);
	self waittill(watchNote);
	self GadgetDeactivate( slot,weapon);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cybercomAbilityTurnedONNotify(weapon,fired)
{
	// excecutes when the gadget is turned on
	if(fired)
	{
		self notify(weapon.name+"_fired");
		level notify(weapon.name+"_fired");
		self notify("cybercom_activation_succeeded", weapon);
		bb::logCybercomEvent(self, "fired", weapon);
		self GadgetTargetResult( true );
	}
	else
	{
		self GadgetTargetResult( false );
		self notify("cybercom_activation_failed", weapon);
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function cybercomHintResults( weapon )
{
	if ( isDefined(self.cybercom.fail_type) && self.cybercom.fail_type != 0 && (self.cybercom.lock_targets.size == 0  || self.cybercom.fail_type == 8) )
	{
		switch (self.cybercom.fail_type)
		{
			case 1:
				self SetTargetWrongTypeHint( weapon );
				break;
			case 2:
				self SetTargetOORHint( weapon );
				break;
			case 3:
				self SetTargetAlreadyInUseHint( weapon );
				break;
			case 4:
				self SetNoTargetsHint( weapon );
			break;
			case 5:
				self SetNoLOSOnTargetsHint( weapon );
			break;
			case 6:
				self SetDisabledTargetHint( weapon );
			break;
			case 7:
		//		self SetTargetAlreadyInUseHint();	//change
				self settargetalreadytargetedhint( weapon );	
				break;
			case 8:
		//		self SetTargetAlreadyInUseHint();	//change
				self settargetingabortedhint( weapon );	
			break;
		}
		
		level notify("cybercom_failed",self,self.cybercom.fail_type);
		self notify("cybercom_failed",self.cybercom.fail_type);
		
		
		self.cybercom.fail_type = 0;
		{wait(.05);};
		if(isDefined(self.cybercom.ftpower0))
			self GadgetPowerSet( 0, self.cybercom.ftpower0); 
		if(isDefined(self.cybercom.ftpower1))
			self GadgetPowerSet( 1, self.cybercom.ftpower1); 
		if(isDefined(self.cybercom.ftpower2))
			self GadgetPowerSet( 2, self.cybercom.ftpower2); 
		
		self.cybercom.ftpower0 	= undefined;			
		self.cybercom.ftpower1 	= undefined;			
		self.cybercom.ftpower2 	= undefined;
	}
}

function cybercomSetFailHint(fail_type,requirePrime=true)
{
	if(!isPlayer(self) || !isDefined(self.cybercom))
		return;
	
	if(requirePrime && !( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
		return;
	
	if( !( isdefined( self.cybercom.allowedstate ) && self.cybercom.allowedstate ))
		return;
	
	self.cybercom.fail_type = fail_type;
	self.cybercom.ftpower0 = self gadgetpowerget(0);
	self.cybercom.ftpower1 = self gadgetpowerget(1);
	self.cybercom.ftpower2 = self gadgetpowerget(2);
	
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}
function GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}


