#using scripts\codescripts\struct;
#using scripts\shared\math_shared;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\array_shared;
#using scripts\shared\ai_shared;

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

#using scripts\cp\cybercom\_cybercom_gadget_system_overload;



#namespace cybercom_gadget_surge;

#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "zombie/fx_tesla_bolt_secondary_zmb");
#precache( "fx", "electric/fx_elec_sparks_burst_blue");


#precache( "fx", "fire/fx_fire_ai_robot_arm_left_os");
#precache( "fx", "fire/fx_fire_ai_robot_arm_right_os");
#precache( "fx", "fire/fx_fire_ai_robot_head_os");
#precache( "fx", "fire/fx_fire_ai_robot_leg_left_os");
#precache( "fx", "fire/fx_fire_ai_robot_leg_right_os");
#precache( "fx", "fire/fx_fire_ai_robot_torso_os");













function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(0, 	(1<<3));

	level._effect["surge_arc"]					= "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["surge_secondary_contact"]	= "electric/fx_elec_sparks_burst_blue";
	level._effect["surge_contact"]				= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["surge_disable"]				= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["surge_revert"]				= "electric/fx_elec_sparks_burst_blue";
	
	level._effect[ "burn_os_robot_left_arm" ] 		= "fire/fx_fire_ai_robot_arm_left_os";
	level._effect[ "burn_os_robot_right_arm" ] 		= "fire/fx_fire_ai_robot_arm_right_os";
	level._effect[ "burn_os_robot_head" ] 			= "fire/fx_fire_ai_robot_head_os";
	level._effect[ "burn_os_robot_left_leg" ] 		= "fire/fx_fire_ai_robot_leg_left_os";
	level._effect[ "burn_os_robot_right_leg" ] 		= "fire/fx_fire_ai_robot_leg_right_os";
	level._effect[ "burn_os_robot_torso" ] 			= "fire/fx_fire_ai_robot_torso_os";

	level.cybercom.surge= spawnstruct();
	level.cybercom.surge._is_flickering  	= &_is_flickering;
	level.cybercom.surge._on_flicker 		= &_on_flicker;
	level.cybercom.surge._on_give 			= &_on_give;
	level.cybercom.surge._on_take 			= &_on_take;
	level.cybercom.surge._on_connect 		= &_on_connect;
	level.cybercom.surge._on 				= &_on;
	level.cybercom.surge._off 				= &_off;
	level.cybercom.surge._is_primed 		= &_is_primed;
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
	self.cybercom.weapon 					= weapon;
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
	self thread _activate_surge(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, GetDvarInt( "scr_surge_target_count", 1 ));
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_surge")) 
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
function private _get_valid_targets()
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
function private _activate_surge(slot,weapon)
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
				item.target thread _surge_vehicle(self,(self hasCyberComAbility("cybercom_surge")  == 2));
			}
			else
			{
				item.target thread _surge(self,(self hasCyberComAbility("cybercom_surge")  == 2));
			}
		}
	}
}
#using_animtree( "generic" );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _tryFindPathToBest(enemies,maxAttempts=3)
{

	while(maxAttempts>0)
	{
		maxAttempts--;
		closest = array::get_closest(self.origin, enemies);
		if(!isDefined(closest))
			return;
		
		pathSuccess = false;
		queryResult = PositionQuery_Source_Navigation(closest.origin,	0,	128,	128,	20,	self );
		if( queryResult.data.size > 0 )
		{
			pathSuccess = self FindPath(self.origin, queryResult.data[0].origin, true, false );
		}
		if(!pathSuccess)
		{
			ArrayRemoveValue(enemies,closest,false);
			closest = undefined;
			continue;
		}
		else
		{
			return closest;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _surge_vehicle(attacker, upgraded=false ) //self is vehicle
{
	self endon("death");
	attacker  _electroDischargeArcFX( self );
	self.ignoreall = true;
	PlayFx( level._effect["electro_static_contact"], self.origin ); 
	if(!upgraded)
	{
		/*
		distSQ = distancesquared(self.origin,GROUNDPOS(self,self.origin));
		timeMaxWait = GetTime()+5000;
		while(GetTime()<timeMaxWait && distSQ > SQR(32) )
		{
			wait .5;
			distSQ = distancesquared(self.origin,GROUNDPOS(self,self.origin));
		}
		*/
		if(!isDefined(attacker.cybercom))
			attacker.cybercom = spawnstruct();
		attacker.cybercom.arcCount = 0;
		attacker.cybercom.arcContacts = 0;	
		self thread _electroDischargeArcDamage( attacker, attacker, 1 );
		wait .1;
		self kill();
	}
	else
	{
		if(self.archetype == "turret")
		{
			RadiusDamage(self.origin,128,100,300,self,"MOD_EXPLOSIVE");
			if(isAlive(self))
				self kill();
			return;
		}
		//put vehicle in surge state
		self notify( "surge", attacker );
	}	
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _surge(attacker, upgraded=false ) //self is robot
{
	self endon("death");

	attacker _electroDischargeArcFX( self );
	self.ignoreall = true;
	
	self _surgeInitialFx();
	PlayFxOnTag( level._effect["electro_static_contact"], self, "j_head" ); 
	
	if(upgraded)
	{
		self.goalradius = 36;
	 	comrades = _get_valid_targets();
	 	arrayremovevalue(comrades,self);
	 	target = self _tryFindPathToBest(comrades);
	 	if(isDefined(target))
	 	{
			self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
			self ai::set_behavior_attribute( "sprint", true );
			self ai::set_behavior_attribute( "rogue_control_speed", "run" );
	 		self ClearForcedGoal();
			self SetGoalEntity(target);
			msg = self util::waittill_any_timeout( GetDvarInt( "scr_surge_seek_time", 7 ), "goal","near_goal" );
		}
	}
	
	if(!isDefined(attacker.cybercom))
		attacker.cybercom = spawnstruct();
	attacker.cybercom.arcCount = 0;
	attacker.cybercom.arcContacts = 0;	
	self thread _electroDischargeArcDamage( attacker, attacker, 1 );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _surgeInitialFx() //self is robot
{
	PlayFxOnTag( level._effect["burn_os_robot_torso"], self, "j_spinelower" ); 
	num = RandomInt(4);
	while(num)
	{
		switch(RandomInt(6))
		{
			case 0:
				effect = level._effect[ "burn_os_robot_left_arm" ] ;
				j_tag  = "j_elbow_le_rot";
			break;
			case 1:
				effect = level._effect[ "burn_os_robot_right_arm" ] ;
				j_tag  = "j_elbow_ri_rot";
			break;
			case 2:
				effect = level._effect[ "burn_os_robot_head" ] ;
				j_tag  = "j_head";
			break;
			case 3:
				effect = level._effect[ "burn_os_robot_left_leg" ] ;
				j_tag  = "j_knee_le";
			break;
			case 4:
				effect = level._effect[ "burn_os_robot_right_leg" ] ;
				j_tag  = "j_knee_ri";
			break;
			case 5:
				effect = level._effect[ "burn_os_robot_torso" ] ;
				j_tag  = "j_spinelower";
			break;
			
		}
		num--;
		PlayFxOnTag( effect, self, j_tag ); 
	}	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// this enemy is in the range of the source_enemy's tesla effect
function private _electroDischargeArcDamage( source_enemy, attacker, arc_num )
{
	if(isPlayer(attacker))
	{
		attacker endon( "disconnect" );
	}
	attacker endon( "death" );
	origin = self.origin;
	self thread _electroDischargeDoDamage( source_enemy, arc_num, attacker );
	radius_decay = 20 * arc_num;
	if (GetDvarInt( "scr_surge_radius", 200 ) - radius_decay < 64 )
		radius_decay = GetDvarInt( "scr_surge_radius", 200 ) - ( GetDvarInt( "scr_surge_radius", 200 )-64);
	
	if( isvehicle( self) )
	{
		enemies = _electroDischargeGetEnemiesInArea( origin, GetDvarInt( "scr_surge_radius", 200 ) - radius_decay );
		
	}
	else
	{
		enemies = _electroDischargeGetEnemiesInArea( origin, GetDvarInt( "scr_surge_radius", 200 ) - radius_decay );
	}
	
	foreach(enemy in enemies)
	{
		if( enemy == self )
			continue;
	
		if ( _electroDischargeEndArcDamage(attacker, arc_num ) )
			break;

		enemy thread _electroDischargeArcDamage( self, attacker, arc_num + 1 );
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeEndArcDamage( attacker, arc_num )
{
	if ( arc_num >= GetDvarInt( "scr_surge_max_arcs", 5 ) )
		return true;

	if (attacker.cybercom.arcContacts >= GetDvarInt( "scr_surge_target_count", 1 ) )
		return false;
		
	radius_decay = 20 * arc_num;
	if ( GetDvarInt( "scr_surge_radius", 200 ) - radius_decay <= 0 )
		return true;

	return false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeGetEnemiesInArea( origin, distance )
{
	
	distance_squared = ( (distance) * (distance) );
	enemies = [];

	potential_enemies = util::get_array_of_closest( origin, _get_valid_targets( ) );
	foreach(enemy in potential_enemies)
	{
		if(!isDefined(enemy))
			continue;
			
		if ( DistanceSquared( origin, enemy.origin ) > distance_squared )
			continue;

		if ( !cybercom::targetIsValid(enemy,false) )
			continue;
		
		if ( !_lock_requirement(enemy))
			continue;
		
		if ( ( isdefined( enemy.hit_by_electro_discharge ) && enemy.hit_by_electro_discharge ) )
			continue;
		
		if ( !BulletTracePassed( origin,enemy.origin+(0,0,50), false, undefined ) )
			continue;
		
		//valid target		
		enemies[enemies.size] = enemy;
	}

	return enemies;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeDoDamage( source_enemy, arc_num, attacker )
{
	if(isPlayer(attacker))
	{
		attacker endon( "disconnect" );
	}

	if ( arc_num > 1 )
		wait( RandomFloatRange( 0.1, 0.3 ) * arc_num );

	if( !IsDefined( self ) || !IsAlive( self ) )
		return;
		
	if( arc_num> 1 && IsDefined( source_enemy ) && source_enemy != self )
	{
		if ( attacker.cybercom.arcCount > 3 )
		{
			util::wait_network_frame();
			attacker.cybercom.arcCount = 0;
		}
		attacker.cybercom.arcCount++;
		source_enemy _electroDischargeArcFX( self );
	}

	self _electroDischargeDeathFX( arc_num );
	
	if( !IsDefined( self ) || !IsAlive( self ) )
		return;

	// use the origin of the arc orginator so it pics the correct death direction anim
	origin = attacker.origin;
	if ( IsDefined( source_enemy ) && source_enemy != self  )
		origin = source_enemy.origin;
		
	attacker.cybercom.arcContacts++;

	if(isVehicle(self))
	{
		self DoDamage( 5, self.origin, undefined, undefined, "none", "MOD_RIFLE_BULLET", 0, GetWeapon("emp_grenade"),-1,true);
	}
	else	
	{
		if(arc_num == 1 )	
		{
			self kill(self.origin, undefined, undefined, GetWeapon("gadget_surge"));
		}
		else
		{
			self thread _system_surge_disable(attacker);
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeDeathFX( arc_num )
{
	fx = "electro_static_contact";

	if ( arc_num > 1 )
	{
		fx = "surge_secondary_contact";
	}

	if( isVehicle(self) )
	{
		PlayFx( level._effect[fx], self.origin ); 
	}
	else
	{
		tag = "J_SpineUpper";
		PlayFxOnTag( level._effect[fx], self, tag ); 
	}
	
	self playsound( "zmb_pwup_coco_impact" );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeArcFX( target )
{
	if ( !IsDefined( self ) || !IsDefined( target ) )
		return;

	origin = self.origin+(0,0,40);
	if(isDefined(self.archetype) && self.archetype == "robot" )
	{
		origin = self GetTagOrigin( "J_SpineUpper" );
	}
	
	target_origin = target.origin;
	if( isDefined(target.archetype) && target.archetype == "robot" )
	{
		target_origin 	 = target GetTagOrigin( "J_SpineUpper" );
	}
	
	if(!isDefined(origin) || !isDefined(target_origin))//shouldnt be the case
		return;

	distance_squared = ( (GetDvarInt( "scr_surge_radius", 200 )) * (GetDvarInt( "scr_surge_radius", 200 )) );
	if ( DistanceSquared( origin, target_origin ) < distance_squared )
		return;
	
	fxOrg = Spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["surge_arc"], fxOrg, "tag_origin" );
	playsoundatposition( "zmb_pwup_coco_bounce", fxOrg.origin );
//	fxOrg moveto(target_origin,.1);
	fxOrg thread _lockTrackToEntity( target );
	fxOrg waittill( "tracktoentitydone" );
//	wait .3;
	fxOrg delete();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lockTrackToEntity(target)  //todo, make this a legit missile weapon; faking it through script is lame(ish)
{
	self endon("death");
	
	dist 		= Distance(self.origin,target.origin);
	time		= (dist / 256) * GetDvarFloat( "scr_surge_arc_travel_time", 0.1 );
	intervals  	= time / 0.05;
	while (isDefined(target) && time > 0.05 )
	{
		step 		= (dist/time)/intervals;
		v_to_target = VectorNormalize( target.origin - self.origin ) * step;
		/#
		//util::debug_line( self.origin, self.origin + v_to_target, (1,0,0), 0.8, false, 100 );
		#/
		self.origin +=v_to_target;
		dist 	= Distance(self.origin,target.origin);
		if ( dist < 32 )
			break;
		time -=  0.05;
		wait  0.05;
	}
	self notify("tracktoentitydone");
	if(isDefined(target))
		target notify("tracktoentitydone");
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _system_surge_disable(attacker) //self is robot
{
	if(!isAlive(self))
		return;
	self cybercom_gadget_system_overload::system_overload_robot(attacker,GetDvarInt( "scr_surge_overload_time", 6 )*1000); //self is robot
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateSurge(target,upgraded=false)
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
		guy thread _surge(self,upgraded);
		{wait(.05);};
	}
}