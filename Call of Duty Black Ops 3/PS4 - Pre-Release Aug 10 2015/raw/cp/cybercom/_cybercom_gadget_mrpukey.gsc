    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                       	     	                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
            	      	   	    	           	        	        	                                    	                                                                                                                               	              	                                                                                                                            	          	         	                        
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
		

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;


#using scripts\codescripts\struct;

#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;


#namespace cybercom_gadget_mrpukey;

#precache( "fx", "water/fx_liquid_vomit");






	

function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(2, 	(1<<6));

	level._effect["puke_reaction"]				= "water/fx_liquid_vomit";
	
	level.cybercom.mrpukey= spawnstruct();
	level.cybercom.mrpukey._is_flickering  	= &_is_flickering;
	level.cybercom.mrpukey._on_flicker 		= &_on_flicker;
	level.cybercom.mrpukey._on_give 		= &_on_give;
	level.cybercom.mrpukey._on_take 		= &_on_take;
	level.cybercom.mrpukey._on_connect 		= &_on_connect;
	level.cybercom.mrpukey._on 				= &_on;
	level.cybercom.mrpukey._off 			= &_off;
	level.cybercom.mrpukey._is_primed 		= &_is_primed;
	level.cybercom.mrpukey.illegalHeadModels= array("c_54i_cqb_head1","c_nrc_cqb_head","c_nrc_cqb_f_head","c_54i_supp_head1","c_54i_supp_head1","c_nrc_sniper_head","c_nrc_suppressor_head");
	                                                 
	                                               
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
	self.cybercom.target_count	= GetDvarInt( "scr_mrpukey_target_count", 4 );
	self.cybercom.dotToleerance = GetDvarFloat( "scr_pukey_fov", .968 );
	if(self hasCyberComAbility("cybercom_mrpukey")  == 2)
	{
		self.cybercom.dotTolerance = GetDvarFloat( "scr_pukey_upgraded_fov", .92 );
		self.cybercom.target_count	= GetDvarInt( "scr_mrpukey_target_count_upgraded", 5 );
	}
	
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
	
	self  cybercom::seedAnimationVariant("base_rifle",5);
	self  cybercom::seedAnimationVariant("fem_rifle",5);
	self  cybercom::seedAnimationVariant("riotshield",2);
}

function _on_take( slot, weapon )
{
	self _off( slot, weapon );
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
	self.cybercom.dotTolerance = undefined;
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self thread _activate_mrpukey(slot,weapon);
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
	if( target cybercom::cybercom_AICheckOptOut("cybercom_mrpukey")) 
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
	
	if (isVehicle(target) || !isDefined(target.archetype) )
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if(isActor(target) && target.archetype != "human" && target.archetype !="human_riotshield" )
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
	return  ArrayCombine(GetAITeamArray( "axis"),GetAITeamArray( "team3"),false,false);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_mrpukey(slot,weapon)
{
	upgraded = (self hasCyberComAbility("cybercom_mrpukey")  == 2);
	
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
				
				item.target thread _puke(upgraded,false, self,weapon);
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
function private _puke(upgraded=false, secondary = false, attacker,weapon ) //self is target
{
	self notify("cybercom_action",weapon,attacker);
	
	weapon = GetWeapon("gadget_mrpukey");
	self.ignoreall 		= true;
	self.is_disabled 	= true;
	self DoDamage( self.health+666, self.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
	if(self shouldPlayPukeFX())
	{
		self waittill("puke" );
		playfxontag(level._effect["puke_reaction"],self,"j_neck");
		if( isdefined( self.voicePrefix ) && isdefined( self.bcVoiceNumber ) )
		{
			self playsound( self.voicePrefix + self.bcVoiceNumber + "_exert_vomit" );
		}
	}
	else
	{
		if( isdefined( self.voicePrefix ) && isdefined( self.bcVoiceNumber ) )
		{
			self playsound( self.voicePrefix + self.bcVoiceNumber + "_exert_sonic" );
		}
	}
}

function shouldPlayPukeFX()
{
	attachSize = self getAttachSize();
	for (i = 0; i < attachSize; i++)
	{
		model_name = self getAttachModelName(i);
		if(isInArray(level.cybercom.mrpukey.illegalHeadModels,model_name))
			return false;
	}
	
	return true;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateMrPukey(target, doCast=true,upgraded)
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
		guy thread _puke(upgraded,false, self);
		{wait(.05);};
	}
}