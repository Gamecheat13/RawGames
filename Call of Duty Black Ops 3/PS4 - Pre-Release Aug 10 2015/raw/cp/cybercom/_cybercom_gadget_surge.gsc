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

#precache( "fx", "electric/fx_ability_elec_surge_short_amws");
#precache( "fx", "electric/fx_ability_elec_surge_short_pamws");
#precache( "fx", "electric/fx_ability_elec_surge_short_raps");
#precache( "fx", "electric/fx_ability_elec_surge_short_robot");
#precache( "fx", "electric/fx_ability_elec_surge_short_turret");
#precache( "fx", "electric/fx_ability_elec_surge_short_wasp");
#precache( "fx", "electric/fx_ability_elec_surge_trail");

#precache( "fx", "electric/fx_ability_elec_surge_short_upgrade_amws");
#precache( "fx", "electric/fx_ability_elec_surge_short_upgrade_pamws");
#precache( "fx", "electric/fx_ability_elec_surge_short_upgrade_raps");
#precache( "fx", "electric/fx_ability_elec_surge_short_upgrade_robot");
#precache( "fx", "electric/fx_ability_elec_surge_short_upgrade_turret");
#precache( "fx", "electric/fx_ability_elec_surge_short_upgrade_wasp");





	//radius that shock arcs consider
	//radius that upgraded robot who has find target will affect.  (from target, explode out this radius)



	//travel time for arc over 64 units
	// How long to play the reaction animation for


function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(0, 	(1<<3));

	level._effect["surge_arc"]					= "electric/fx_ability_elec_surge_trail";
	level._effect["surge_contact_amws"]			= "electric/fx_ability_elec_surge_short_amws";
	level._effect["surge_contact_pamws"]		= "electric/fx_ability_elec_surge_short_pamws";
	level._effect["surge_contact_raps"]			= "electric/fx_ability_elec_surge_short_raps";
	level._effect["surge_contact_robot"]		= "electric/fx_ability_elec_surge_short_robot";
	level._effect["surge_contact_wasp"]			= "electric/fx_ability_elec_surge_short_wasp";
	level._effect["surge_contact_turret"]		= "electric/fx_ability_elec_surge_short_turret";
	level._effect["surge_contact_amws_upgrade"]			= "electric/fx_ability_elec_surge_short_upgrade_amws";
	level._effect["surge_contact_pamws_upgrade"]		= "electric/fx_ability_elec_surge_short_upgrade_pamws";
	level._effect["surge_contact_raps_upgrade"]			= "electric/fx_ability_elec_surge_short_upgrade_raps";
	level._effect["surge_contact_robot_upgrade"]		= "electric/fx_ability_elec_surge_short_upgrade_robot";
	level._effect["surge_contact_wasp_upgrade"]			= "electric/fx_ability_elec_surge_short_upgrade_wasp";
	level._effect["surge_contact_turret_upgrade"]		= "electric/fx_ability_elec_surge_short_upgrade_turret";
	level._effect["surge_contact"]				= "electric/fx_elec_sparks_burst_lg_os";
	
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

	self.cybercom.target_count = GetDvarInt( "scr_surge_target_count", 1 );
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
	self thread _activate_surge(slot,weapon);
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
		self thread cybercom::weaponLockWatcher(slot, weapon, GetDvarInt( "scr_surge_target_count", 1 ));
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target,secondary=false)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_surge")) 
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
		if(target.archetype == "human" && ( isdefined( secondary ) && secondary ) )
		{
		}
		else
		{
			self cybercom::cybercomSetFailHint(1);
			return false;	
		}
	}

	if(!isActor(target) && !isVehicle(target))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
	
	if(isVehicle(target))
	{
		if(!isDefined(target.archetype))
		{
			self cybercom::cybercomSetFailHint(1);
			return false;
		}
		
		switch(target.archetype)
		{
			case "amws":
			case "pamws":
			case "raps":
			case "wasp":
			case "turret":
				break;
			default:
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
function private _activate_surge(slot,weapon)
{
	upgraded = (self hasCyberComAbility("cybercom_surge")  == 2);
	
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
				
				item.target thread _surge(upgraded,false, self,weapon);
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
function private _surge_vehicle(upgraded=false, secondary=false, attacker ) //self is vehicle
{
	self endon("death");
	self.ignoreall = true;
	
	self playsound( "gdt_surge_impact" );
	
	switch(self.archetype)
	{
		case "turret":
			playfxontag(level._effect["surge_contact_turret"+(upgraded?"_upgrade":"")],self,"tag_barrel");
			break;
		case "amws":
			playfxontag(level._effect["surge_contact_amws"+(upgraded?"_upgrade":"")],self,"tag_turret_animate");
			break;
		case "pamws":
			playfxontag(level._effect["surge_contact_pamws"+(upgraded?"_upgrade":"")],self,"tag_turret_animate");
		break;
		case "raps":
			playfxontag(level._effect["surge_contact_raps"+(upgraded?"_upgrade":"")],self,"tag_wheel_front_right_animate");
		break;
		case "wasp":
			playfxontag(level._effect["surge_contact_wasp"+(upgraded?"_upgrade":"")],self,"tag_body");
		break;
		default:
			assert(0,"illegal vehicle in surge");
		break;
	}

	if(!upgraded)
	{
		self thread _surgeArc( upgraded );
		wait .1;
		RadiusDamage(self.origin,128,300,100,self,"MOD_EXPLOSIVE");
		if(isAlive(self))
			self kill();
	}
	else
	{
		if(self.archetype == "turret")
		{
			RadiusDamage(self.origin,128,300,100,self,"MOD_EXPLOSIVE");
			if(isAlive(self))
				self kill();
			return;
		}
		self notify( "surge", attacker );
	}	
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _surge(upgraded=false, secondary = false, attacker,weapon ) //self is robot
{
	self endon("death");

	self notify("cybercom_action",weapon,attacker);
	weapon = GetWeapon("gadget_surge");
	
	if(isVehicle(self))
	{
		self thread _surge_vehicle(upgraded,secondary,attacker );
		return;
	}
	
	self.ignoreall 		= true;
	self.is_disabled 	= true;
	self.health			= self.maxhealth;
	
	if (self.archetype == "human" || self ai::get_behavior_attribute( "rogue_control" ) != "level_3")
	{
		// Level 3 rogue controlled robots already have the surge effect playing.
		playfxontag(level._effect["surge_contact_robot"],self,"j_spine4");
	}
	self playsound( "gdt_surge_impact" );
	
	
	
	if (self cybercom::isInstantKill() || self.archetype == "human" )
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined),undefined,weapon);
		return;
	}
	
	if(!secondary)
	{
		//self thread _surgeArc(upgraded, attacker);
	}
	
	
	// Do reaction
	self PlayReactAnimForTime(attacker,weapon,GetDvarFloat( "scr_surge_react_time",  0.45));
	
	self ClearForcedGoal();
	self UsePosition(self.origin);
	if(upgraded)
	{
		self clientfield::set( "cybercom_setiffname",2);
		self ai::set_behavior_attribute( "rogue_allow_pregib", false );
		self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
		self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
		
		self.team = "allies";
		self clientfield::set( "robot_mind_control", 0 );
		self clientfield::set( "robot_lights", 3 );
		self.TokubetsuKogekita	= true;
	
		self playsound( "gdt_surge_chase" );
		self.goalradius = 32;
	 	comrades = _get_valid_targets();
	 	arrayremovevalue(comrades,self);
	 	target = self _tryFindPathToBest(comrades);
	 	if(isDefined(target))
	 	{
			self thread _robotSurgeDetonate();
			self thread _robotSurgeDetonateOnFatalDamage();
			
			while(isDefined(target) && !( isdefined( self.surgeDetonate ) && self.surgeDetonate ))
			{
				self UsePosition( GetClosestPointOnNavMesh( target.origin, 200 ) );
				
				{wait(.05);};
			}
		}
	}
	self thread _surgeBlow( attacker);
}

// Play the react animation once, or until the elapsed time is exceeded
function PlayReactAnimForTime(attacker, weapon, maxAnimTime)
{
	self endon("EndReactAnim");
	self endon("death");
	
	self thread EndReactAnimAtTime(maxAnimTime);
	
	self DoDamage( 2, self.origin, (isDefined(attacker)?attacker:undefined),undefined, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
	self waittillmatch("bhtn_action_terminate", "specialpain" );
	
	self notify("ReactAnimTimeOver");
}


// If the react animation is longer than the desired time, notify the react to stop early.
function EndReactAnimAtTime(maxAnimTime)
{
	self endon("ReactAnimTimeOver");
	self endon("death");
	
	wait maxAnimTime;
	
	self notify("EndReactAnim");
}


function _robotSurgeDetonateOnFatalDamage(attacker)
{
	self endon("_surgeBlow");
	self waittill("death");
	self thread _surgeBlow( attacker);
}

function private _robotSurgeDetonate()
{
	self endon("death");
	
	startTime = GetTime();
	
	while ( true )
	{
		if ( IsDefined( self.pathgoalpos ) && DistanceSquared( self.origin, self.pathgoalpos ) <= ( (self.goalradius) * (self.goalradius) ) )
		{
			break;
		}
		
		if ( ( GetTime() - startTime ) / 1000 >= GetDvarInt( "scr_surge_seek_time", 8 ) )
		{
			break;
		}
	
		{wait(.05);};
	}
	
	self.surgeDetonate = true;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// this enemy is in the range of the source_enemy's tesla effect
function private _surgeArcAndSpread(upgraded,enemy,attacker)
{
	self endon("death");
	enemy endon("death");
	
	travelTime	= ( ((distancesquared(enemy.origin,self.origin))/( (128) * (128) )))*GetDvarFloat( "scr_surge_arc_travel_time", 0.05 );
	self thread _electroDischargeArcFX( enemy,travelTime);		//bolt effect from self to enemy
	wait travelTime;

	if(isVehicle(enemy))
	{
		enemy thread _surge_vehicle(upgraded,true, attacker);
	}
	else
	{
		enemy thread _surge(upgraded, true, attacker);
	}
}

function private _surgeArc(upgraded,attacker )
{
	self endon( "death" );
	enemies = _surgeGetNearbyEnemies( self.origin, GetDvarInt( "scr_surge_radius", 220 ), GetDvarInt( "scr_surge_count", 4 ) );
	
	foreach(enemy in enemies)
	{
		if( enemy == self )
			continue;
		
		self thread _surgeArcAndSpread(upgraded,enemy,attacker);
	}
}

function private _surgeBlow(attacker)
{
	self notify("_surgeBlow");
	self endon("_surgeBlow");
	origin = self.origin;
	self clientfield::set("robot_mind_control_explosion", 1 );
//	self ai::set_behavior_attribute( "rogue_force_explosion", true );	//would prefer to use this interface but need to find a way to credit player with death.  For now, trigger fx and explo radius
	enemies = _surgeGetNearbyEnemies( origin, GetDvarInt( "scr_surge_blowradius", 128 ), GetDvarInt( "scr_surge_count", 4 ) );
	foreach(guy in enemies)
	{
		if(guy.archetype=="human")
			guy DoDamage(guy.health,self.origin,(isDefined(attacker)?attacker:undefined),undefined,"none","MOD_EXPLOSIVE",0,GetWeapon("frag_grenade"),-1,true);
		else
			guy DoDamage(5,self.origin,(isDefined(attacker)?attacker:undefined),undefined,"none","MOD_GRENADE_SPLASH",0,GetWeapon("emp_grenade"),-1,true);
	}
	
	if(isDefined(attacker))
		grenade = attacker MagicGrenadeType( GetWeapon("emp_grenade"),origin+(0,0,40), (0,0,0), .05 );
		
//	RadiusDamage(origin,SURGE_BLOW_RADIUS,SURGE_BLOW_DAMAGE_MAX,SURGE_BLOW_DAMAGE_MIN,(isDefined(attacker)?attacker:undefined),"MOD_GRENADE_SPLASH",GetWeapon("emp_grenade") );
	wait .2;
	if(isAlive(self))
	{
		self kill(self.origin,(isDefined(attacker)?attacker:undefined));
		self StartRagdoll();
	}
	if(isDefined(grenade))
		grenade delete();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _surgeGetNearbyEnemies( origin, distance, max )
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
		
		if ( !_lock_requirement(enemy,true))
			continue;
		
		if ( ( isdefined( enemy.hit_by_electro_discharge ) && enemy.hit_by_electro_discharge ) )
			continue;
		
		if ( !BulletTracePassed( origin,enemy.origin+(0,0,50), false, undefined ) )
			continue;
		
		//valid target		
		enemies[enemies.size] = enemy;
		if(isDefined(max))
		{
			if(enemies.size >= max)
				break;
		}
	}

	return enemies;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeArcFX( target,travelTime )
{
	if ( !IsDefined( self ) || !IsDefined( target ) )
		return;

	origin = self.origin+(0,0,40);
	if(isDefined(self.archetype) && self.archetype == "robot" )
	{
		origin = self GetTagOrigin( "J_SpineUpper" );
	}
	
	fxOrg = Spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );
	fx = PlayFxOnTag( level._effect["surge_arc"], fxOrg, "tag_origin" );
	
	tag = (isVehicle(target)?"tag_origin":"J_SpineUpper" );
	fxOrg thread trackTo( target,travelTime,tag);
	fxOrg playsound( "gdt_surge_bounce" );
	wait travelTime;
//	fxOrg moveto(target.origin,.3);
	wait .25;
	fxOrg delete();
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private trackTo(target,time,tag) 
{
	self endon("disconnect");
	self endon("death");
	self notify("trackTo");
	self endon("trackTo");
	            
	if(!isDefined(target))
		return;
	
	if(!isDefined(tag))
		tag ="tag_origin";
	
	if ( time <= 0 )
		time = 1;

	dest 		= target GetTagOrigin(tag);
	if(!isDefined(dest))
		dest = target.origin;
	
	intervals  	= int(time / .05);
	while (isDefined(target) && intervals>0)
	{
		dist 		= Distance(self.origin,dest);
		step 		= dist/intervals;
		v_to_target = VectorNormalize( dest - self.origin ) * step;
		/#
		//util::debug_line( self.origin, self.origin + v_to_target, (1,0,0), 0.8, false, 100 );
		#/
		intervals--;
		self moveto(self.origin + v_to_target,0.05);
		self waittill("movedone");
		dest 	= target GetTagOrigin(tag);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );

function ai_activateSurge(target,doCast=true,upgraded=false)
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
		guy thread _surge(self,upgraded);
		{wait(.05);};
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _tryFindPathToBest(&enemies,maxAttempts=3)
{

	while(maxAttempts>0 && enemies.size>0)
	{
		maxAttempts--;
		closest = ArrayGetClosest(self.origin, enemies);
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
