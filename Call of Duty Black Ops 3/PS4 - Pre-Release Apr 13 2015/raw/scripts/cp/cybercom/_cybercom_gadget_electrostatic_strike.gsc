/*
 * Created by ScriptDevelop.
 * User: dking
 * Date: 1/26/2015
 * Time: 4:14 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#using scripts\codescripts\struct;

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
#using scripts\shared\lui_shared;
#using scripts\cp\_util;

                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;


//this is extra damage added to melee hit







#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "zombie/fx_tesla_bolt_secondary_zmb");


#namespace cybercom_gadget_electrostatic_strike;

function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(2,	(1<<1));

	level._effect["es_contact"]		= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["es_arc"]			= "zombie/fx_tesla_bolt_secondary_zmb";

	level.cybercom.electro_strike = spawnstruct();
	level.cybercom.electro_strike._is_flickering  	= &_is_flickering;
	level.cybercom.electro_strike._on_flicker 		= &_on_flicker;
	level.cybercom.electro_strike._on_give 			= &_on_give;
	level.cybercom.electro_strike._on_take 			= &_on_take;
	level.cybercom.electro_strike._on_connect 		= &_on_connect;
	level.cybercom.electro_strike._on 				= &_on;
	level.cybercom.electro_strike._off 				= &_off;
	level.cybercom.electro_strike._is_primed 		= &_is_primed;
	
	level.cybercom.electro_strike.human_weapon		= GetWeapon("gadget_concussive_wave");
	level.cybercom.electro_strike.robot_weapon		= GetWeapon("emp_grenade");
	level.cybercom.electro_strike.vehicle_weapon	= GetWeapon("emp_grenade");
	level.cybercom.electro_strike.other_weapon		= GetWeapon("gadget_concussive_wave");
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
}

function _is_flickering( slot )
{
}
function _on_flicker( slot, weapon )
{
}
function _on_give( slot, weapon )
{
	self.cybercom.weapon	= weapon;
	if(isDefined(self.informMeOnDamageCausedToOtherCB))
	{
		assert (isArray(self.informMeOnDamageCausedToOtherCB),"This cb should be an array");
		if(!isInArray(self.informMeOnDamageCausedToOtherCB, &electroStaticDamageResponse))
		{
			self.informMeOnDamageCausedToOtherCB[self.informMeOnDamageCausedToOtherCB.size] = &electroStaticDamageResponse;
		}
	}
	else
	{
		self.informMeOnDamageCausedToOtherCB = array(&electroStaticDamageResponse);
	}
}
function _on_take( slot, weapon )
{
	self.cybercom.weapon	= undefined;
	if(isDefined(self.informMeOnDamageCausedToOtherCB))
	{
		ArrayRemoveValue(self.informMeOnDamageCausedToOtherCB,&electroStaticDamageResponse);
		if(self.informMeOnDamageCausedToOtherCB.size == 0)
			self.informMeOnDamageCausedToOtherCB = [];
	}
}
function _on_connect()
{
}
function _on( slot, weapon )
{
}
function _off( slot, weapon )
{
}
function _is_primed( slot, weapon )
{
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function electroStaticDamageResponse(victim,iDamage,iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex )
{
	if(sMeansOfDeath != "MOD_MELEE" )
		return;

	if( victim cybercom::cybercom_AICheckOptOut("cybercom_es_strike")) 
		return;
	
	status = self hasCyberComAbility("cybercom_es_strike", true);
	if (status == 0 )
		return;

	upgraded = (status==2);
	{wait(.05);};
	if(isDefined(victim))
	{
		victim thread electroStaticContact(self,self,upgraded,vPoint);
		victim thread electroStaticArc(self,upgraded);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ai_activateElectroStaticStrike(upgraded=false)
{
	self thread aiElectroStaticKillMonitor((upgraded?2:1));
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function aiElectroStaticKillMonitor(statusOverride)
{
	if(isPlayer(self))
	{
		self endon("disconnect");
	}
	else
	{
		self endon("death");
	}
	self notify("electro_static_monitor_kill");
	self endon("electro_static_monitor_kill");

	while(1)
	{
		self waittill("target_meleed", target,damage,weapon,hitOrigin);
		if(isDefined(target))
		{
			if( target cybercom::cybercom_AICheckOptOut("cybercom_es_strike")) 
				continue;
		
			upgraded = (statusOverride==2);
			target thread electroStaticContact(self,self,upgraded,hitOrigin);
			target thread electroStaticArc(self,upgraded);
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function electroStaticContact(player,source, upgraded=false,contactPoint)//self = melee target
{
	if (!isDefined(self))
		return;
		
	if(!isDefined(source))
		source = player;
	
	if(!isDefined(player))
		return;
	
	if(!isDefined(self.archetype))
		return;
	
	if(!isDefined(contactPoint))
	{
		contactPoint = self GetTagOrigin("j_neck");
		if(!isDefined(contactPoint))
		{
			contactPoint = self GetTagOrigin("tag_origin");
		}
	}
	playFx(level._effect["es_contact"], contactPoint);//self,"j_neck");
	
	electro_strike_damage 		= GetDvarInt( "scr_es_damage", 20 );
	if(upgraded)
	{
		electro_strike_damage 	= GetDvarInt( "scr_es_upgraded_damage", 40 );
	}
	if (self.archetype == "human")
	{
		self DoDamage(electro_strike_damage, contactPoint, player, player, "none", "MOD_RIFLE_BULLET", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.electro_strike.human_weapon,-1,true);
	}
	else
	if (self.archetype == "robot")
	{
		self DoDamage(electro_strike_damage, source.origin, player, player, "none", "MOD_RIFLE_BULLET", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.electro_strike.robot_weapon,-1,true);
		if ( !( isdefined( self.is_disabled ) && self.is_disabled ) && isAlive(self))
		{
			self thread cybercom_gadget_system_overload::system_overload_robot(player,undefined,undefined,false);
		}
	}
	else
	if (isVehicle(self))
	{
		self DoDamage(electro_strike_damage, source.origin, player, player, "none", "MOD_GRENADE", 0, level.cybercom.electro_strike.vehicle_weapon);
	}
	else
	{
		self DoDamage(electro_strike_damage, source.origin, player, player, "none", "MOD_RIFLE_BULLET", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.electro_strike.other_weapon);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function electroStaticArc(player, upgraded)
{
	electro_strike_arc_range 	= GetDvarInt( "scr_es_arc_range", 72 );
	if(upgraded)
	{
		electro_strike_arc_range = GetDvarInt( "scr_es_upgraded_arc_range", 128 );
	}

	distSQ = ( (electro_strike_arc_range) * (electro_strike_arc_range) );
	enemies = [];
	
	badguys = GetAITeamArray("axis");//GetVehicleTeamArray( "axis" );

	potential_enemies = util::get_array_of_closest( self.origin, badguys );
	foreach(enemy in potential_enemies)
	{
		if(!isDefined(enemy))
			continue;
			
		if (enemy == self )
			continue;		
			
		if ( DistanceSquared( self.origin, enemy.origin ) > distSQ )
			continue;

		if( enemy cybercom::cybercom_AICheckOptOut("cybercom_es_strike")) 
			continue;
			
		if ( ( isdefined( enemy.is_disabled ) && enemy.is_disabled ) )
			continue;
			
		if( ( isdefined( enemy.missingLegs ) && enemy.missingLegs ) || ( isdefined( enemy.isCrawler ) && enemy.isCrawler ) )
			continue;

		if ( !BulletTracePassed( self.origin,enemy.origin+(0,0,50), false, undefined ) )
			continue;
		
		//valid target		
		enemies[enemies.size] = enemy;
	}
	
	i=0;
	foreach(guy in enemies)
	{
		self thread _electroDischargeArcDmg(guy,player);
		i++;
		if(i>=GetDvarInt( "scr_es_max_arcs", 4 ))
			break;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeArcDmg( target,player )
{
	if ( !IsDefined( self ) || !IsDefined( target ) )
		return;


	origin = self.origin+(0,0,40);
	target_origin = target.origin+(0,0,40);
	
	fxOrg = Spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["es_arc"], fxOrg, "tag_origin" );
	playsoundatposition( "zmb_pwup_coco_bounce", fxOrg.origin );
	
	fxOrg MoveTo( target_origin,0.25);
	fxOrg util::waittill_any_timeout(1,"movedone" );
	fxOrg delete();
	target thread electroStaticContact(player,self);
}

