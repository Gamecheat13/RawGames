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


#using scripts\shared\ai\systems\blackboard;
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               


#namespace cybercom_gadget_servo_shortout;



#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");


function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(0,	(1<<1));

	level._effect["servo_shortout"]					= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["servo_shortout_leftarm"]			= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["servo_shortout_rightarm"]		= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["servo_shortout_legs"]			= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["servo_shortout_head"]			= "electric/fx_elec_sparks_burst_lg_os";

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
	self.cybercom.weapon 					= weapon;
	self.cybercom.servo_shortout_count		= GetDvarInt( "scr_servo_shortout_count", 2 );
	if(self hasCyberComAbility("cybercom_servoshortout")  == 2)
	{
		self.cybercom.servo_shortout_count	= GetDvarInt( "scr_servo_shortout_upgraded_count", 4 );
	}
	self.cybercom.targetLockCB 				= &_get_valid_targets;
	self.cybercom.targetLockRequirementCB 	= &_lock_requirement;
}

function _on_take( slot, weapon )
{
	self _off( slot, weapon );
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
	self thread _activate_servo_shortout(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.servo_shortout_count);
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_servoshortout")) 
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
function private _activate_servo_shortout(slot,weapon)
{
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	
	if ( !isDefined(self.cybercom.lock_targets) || self.cybercom.lock_targets.size == 0 )
	{	//player has the buttons down, and just released, no targets, what to do? 
		//Feedback UI
		//Feedback Audio
		//do we incur the cost of firing the weapon? Seems like we shouldnt
	}
	
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			
			if(isVehicle(item.target))
			{
				item.target thread servo_shortoutVehicle(self, self hasCyberComAbility("cybercom_servoshortout")  == 2 );
			}
			else
			{
				item.target thread servo_shortout(self, GetWeapon("gadget_servo_shortout"), self hasCyberComAbility("cybercom_servoshortout")  == 2 );
			}
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _update_gib_position() //self is robot
{
	level.cybercom.servo_shortout.gibCounter++;
	return(level.cybercom.servo_shortout.gibCounter%3);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function servo_shortoutVehicle(attacker, upgraded ) //self is vehicle
{
	if(isSubStr(self.vehicletype,"wasp"))
	{
		PlayFx( level._effect["electro_static_secondary_contact"], self.origin ); 
		self kill();
	}
	else
	if(isSubStr(self.vehicletype,"raps"))
	{
		PlayFx( level._effect["electro_static_secondary_contact"], self.origin ); 
		self kill();
	}
	else
	if(isSubStr(self.vehicletype,"amws"))	//also covers pamws
	{
		PlayFx( level._effect["electro_static_secondary_contact"], self.origin ); 
		hR = self.health / self.healthdefault;
		if(hR<.5)
			self kill();
		else
		{
			dmg = self.health - (int(self.healthdefault*.25));
			self dodamage(dmg,self.origin,undefined,undefined,"none","MOD_UNKNOWN",0,GetWeapon("emp_grenade"),-1,true);
		}
	}
}

#using_animtree( "generic" );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function servo_shortout(attacker, weapon, upgraded, gibPosition, damage=0 ) //self is robot
{
	self endon("death");

	if(!isDefined(weapon))
		weapon = GetWeapon("gadget_servo_shortout");

	if(self.archetype=="robot" )
		PlayFxOnTag( level._effect["electro_static_contact"], self, "J_SpineUpper" ); 
	else
		PlayFxOnTag( level._effect["electro_static_contact"], self, "tag_origin" ); 
	
	if( ( isdefined( self.missingLegs ) && self.missingLegs ) || ( isdefined( self.isCrawler ) && self.isCrawler ) )
	{
		self kill();
		return;
	}

	
	self.is_disabled = true;
	if(damage == 0 )
	{
		oldhealth = self.health;
		self DoDamage( 5, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);//needs to be something for pain reaction
		self.health = oldhealth;
	}
	else
	{
		self DoDamage( damage, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, weapon,-1,true);
	}

	if(!isDefined(gibPosition) || gibPosition<0||gibPosition>2 )
	{
		gibPosition = self _update_gib_position();
	}
	time = getAnimLength(%ai_robot_base_stn_exposed_pain_juiced_ammo);
	switch( gibPosition )
	{
		case 0:
			wait (time*0.75);
			playfxontag(level._effect["servo_shortout_leftarm"],self, "j_shoulder_le_rot");
			GibServerUtils::GibLeftArm( self );
		break;
		case 1:
			wait (time);
			playfxontag(level._effect["servo_shortout_legs"],self, "J_SpineLower");
			self ai::set_behavior_attribute( "force_crawler", "gib_legs" );
			//GibServerUtils::GibLegs( self );
			//Blackboard::SetBlackBoardAttribute( self, GIB_LOCATION, "legs" );
			//self.becomeCrawler = true;
		break;
		case 2:
			playfxontag(level._effect["servo_shortout_head"],self, "j_head");
			wait (time*0.5);
			GibServerUtils::GibHead( self );
		break;
	}
	self.is_disabled = false;

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateServoShortout(target)
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
		guy thread servo_shortout(self);
		{wait(.05);};
	}
}