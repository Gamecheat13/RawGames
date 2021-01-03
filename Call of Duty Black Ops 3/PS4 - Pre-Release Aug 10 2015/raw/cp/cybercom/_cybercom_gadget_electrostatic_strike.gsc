/*
 * Created by ScriptDevelop.
 * User: dking
 * Date: 1/26/2015
 * Time: 4:14 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
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
#using scripts\cp\gametypes\_battlechatter;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

//this is extra damage added to melee hit







#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");
#precache( "fx", "zombie/fx_tesla_bolt_secondary_zmb");


#precache( "fx", "electric/fx_ability_elec_strike_short_human");
#precache( "fx", "electric/fx_ability_elec_strike_short_robot");
#precache( "fx", "electric/fx_ability_elec_strike_short_warlord");
#precache( "fx", "electric/fx_ability_elec_strike_short_wasp");
#precache( "fx", "electric/fx_ability_elec_strike_impact");
#precache( "fx", "electric/fx_ability_elec_strike_generic");
#precache( "fx", "electric/fx_ability_elec_strike_trail");

	
#namespace cybercom_gadget_electrostatic_strike;

function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(2,	(1<<1));

	level._effect["es_effect_human"]		= "electric/fx_ability_elec_strike_short_human";
	level._effect["es_effect_warlord"]		= "electric/fx_ability_elec_strike_short_warlord";
	level._effect["es_effect_robot"]		= "electric/fx_ability_elec_strike_short_robot";
	level._effect["es_effect_wasp"]			= "electric/fx_ability_elec_strike_short_wasp";
	level._effect["es_effect_generic"]		= "electric/fx_ability_elec_strike_generic";
	level._effect["es_contact"]				= "electric/fx_ability_elec_strike_impact";
	level._effect["es_arc"]					= "electric/fx_ability_elec_strike_trail";

	level.cybercom.electro_strike = spawnstruct();
	level.cybercom.electro_strike._is_flickering  	= &_is_flickering;
	level.cybercom.electro_strike._on_flicker 		= &_on_flicker;
	level.cybercom.electro_strike._on_give 			= &_on_give;
	level.cybercom.electro_strike._on_take 			= &_on_take;
	level.cybercom.electro_strike._on_connect 		= &_on_connect;
	level.cybercom.electro_strike._on 				= &_on;
	level.cybercom.electro_strike._off 				= &_off;
	
	level.cybercom.electro_strike.human_weapon		= GetWeapon("gadget_es_strike");
	level.cybercom.electro_strike.warlord_weapon	= GetWeapon("gadget_es_strike");
	level.cybercom.electro_strike.robot_weapon		= GetWeapon("gadget_es_strike");
	level.cybercom.electro_strike.robot_weapon_secondary	= GetWeapon("emp_grenade");
	level.cybercom.electro_strike.vehicle_weapon	= GetWeapon("emp_grenade");
	level.cybercom.electro_strike.other_weapon		= GetWeapon("emp_grenade");
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
	self thread meleeListener(weapon);
}
function _on_take( slot, weapon )
{
	self notify("endmeleeListener");
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


function meleeListener(weapon)
{
	self notify("meleeListener");
	self endon("meleeListener");
	self endon("endmeleeListener");
	self endon("disconnect");
	while(1)
	{
		level waittill("es_strike", target,attacker,damage,weapon,hitOrigin);
		{wait(.05);};
		if(isDefined(target))
		{
			if( target cybercom::cybercom_AICheckOptOut("cybercom_es_strike")) 
				continue;

			if (!isAlive(target))
				continue;		
			
			self notify(weapon.name+"_fired");
			level notify(weapon.name+"_fired");

			status = self hasCyberComAbility("cybercom_es_strike", true);
			upgraded = (status==2);
			target notify("cybercom_action",weapon,attacker);
			target thread electroStaticContact(attacker,attacker,upgraded,hitOrigin);
			target thread electroStaticArc(attacker,upgraded);
			
			if(isDefined(target.archetype) && target.archetype == "human")
			{
				target clientfield::set("arch_actor_char",1);
				target thread corpseListener();
			//	wait 1;
			// 	target clientfield::set("arch_actor_fire_fx", BURN_SMOLDER);
			}
			
		}
	}	
}


function corpseListener()
{
	self waittill("actor_corpse", corpse);
/*	
	if(isDefined(corpse.archetype))
	{
		switch(corpse.archetype)
		{
			case "human":
			case "human_riotshield":
			case "zombie":
				fx = level._effect["es_effect_human"];
				tag = "j_spine4";
			break;
			case "robot":
				fx = level._effect["es_effect_robot"];
				tag = "j_spine4";
			break;
			case "wasp":
				fx = level._effect["es_effect_wasp"];
				tag = "tag_body";
			break;
			case "warlord":
				fx = level._effect["es_effect_warlord"];
				tag = "j_spine4";
			break;
			default:
				fx = level._effect["es_effect_generic"];
				tag = "tag_body";
			break;
		}
	}
	else
	{
		fx = level._effect["es_effect_generic"];
		tag = "tag_body";
	}
	
	if(!isDefined(corpse gettagorigin(tag)))
	   tag = "tag_origin";
		
	playfxontag(fx,corpse,tag);
	corpse playsound( "gdt_electro_electrocute" );
*/	
//	corpse clientfield::set("arch_actor_char",CHAR_RAMP);
 	corpse clientfield::set("arch_actor_fire_fx", 3);
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
		level waittill("es_strike", target,attacker,damage,weapon,hitOrigin);
		{wait(.05);};
		if(isDefined(target))
		{
			target notify("cybercom_action",weapon,attacker);
			upgraded = (statusOverride==2);
			target thread electroStaticContact(attacker,attacker,upgraded,hitOrigin);
			target thread electroStaticArc(attacker,upgraded);
		}
	}
}

function isValidESTarget(attacker)
{
	if (!isDefined(self))
		return false;

	if( self cybercom::cybercom_AICheckOptOut("cybercom_es_strike")) 
		return false;

	if (!isAlive(self))
		return false;		

	if (isDefined(self._ai_melee_opponent))
		return false;
	
	if(!isDefined(self.archetype))
		return false;

	if ( ( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield ))
		return false;

	if (isDefined(self._ai_melee_opponent))
		return false;
	
	if (self.team == attacker.team)
		return false;
	
	return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function electroStaticContact(attacker,source, upgraded=false,contactPoint,secondary = false)//self = melee target
{
	if (!self isValidESTarget(attacker) )
		return;
	
	if(!isDefined(source))
		source = attacker;
	
	if(!isDefined(attacker))
		return;
	
	if(isDefined(contactPoint))
	{
		playFx(level._effect["es_contact"], contactPoint);
	}
	if(isDefined(self.archetype))
	{
		switch(self.archetype)
		{
			case "human":
				self clientfield::set("arch_actor_char",1);//fallthrough
				self thread corpseListener();
			case "human_riotshield":
			case "zombie":
				fx = level._effect["es_effect_human"];
				tag = "j_spine4";
			break;
			case "robot":
				fx = level._effect["es_effect_robot"];
				tag = "j_spine4";
			break;
			case "wasp":
				fx = level._effect["es_effect_wasp"];
				tag = "tag_body";
			break;
			case "warlord":
				fx = level._effect["es_effect_warlord"];
				tag = "j_spine4";
			break;
			default:
				fx = level._effect["es_effect_generic"];
				tag = "tag_body";
			break;
		}
	}
	else
	{
		fx = level._effect["es_effect_generic"];
		tag = "tag_body";
	}
	
	if(!isDefined(self gettagorigin(tag)))
	   tag = "tag_origin";
		
	playfxontag(fx,self,tag);
	
	self playsound( "gdt_electro_electrocute" );
	
	if (self cybercom::isInstantKill())
	{
		self Kill(self.origin, (isDefined(attacker)?attacker:undefined));
		return;
	}
	
	if (self.archetype == "human" || self.archetype =="zombie" || self.archetype =="human_riotshield" || self.archetype == "direwolf" )
	{
		if( isdefined( self.voicePrefix ) && isdefined( self.bcVoiceNumber ) )
		{
			self playsound( self.voicePrefix + self.bcVoiceNumber + "_exert_electrocution" );
		}
		
		self DoDamage(self.health, source.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_UNKNOWN", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.electro_strike.human_weapon,-1,true);
	}
	else
	if (self.archetype == "warlord" )
	{
		self DoDamage(GetDvarInt( "scr_es_upgraded_damage", 80 ),self.origin,(isDefined(attacker)?attacker:undefined),undefined,undefined,"MOD_UNKNOWN",0,level.cybercom.electro_strike.warlord_weapon,-1,true);
	}
	else
	if (self.archetype == "robot")
	{
		self ai::set_behavior_attribute( "can_gib", false );
	
		self playsound ("fly_bot_disable_delayed");
		
		if(( isdefined( secondary ) && secondary ))
		{
			self DoDamage(GetDvarInt( "scr_es_damage", 5 ), source.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_MELEE", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.electro_strike.robot_weapon_secondary,-1,true);
		}
		else
		{
			self DoDamage(self.health, source.origin, (isDefined(attacker)?attacker:undefined),undefined, "none", "MOD_UNKNOWN", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.electro_strike.robot_weapon,-1,true);
		}
		
		self ai::set_behavior_attribute( "robot_lights", 1 );
		
		if ( !( isdefined( self.is_disabled ) && self.is_disabled ) && isAlive(self))
		{
			self thread cybercom_gadget_system_overload::system_overload(attacker,undefined,undefined,false);
		}
		
		wait 2.5;
		if(isDefined(self))
		{
			self ai::set_behavior_attribute( "robot_lights", 2 );
		}
	}
	else
	if (isVehicle(self))
	{
		self DoDamage(GetDvarInt( "scr_es_damage", 5 ), source.origin, (isDefined(attacker)?attacker:undefined), undefined, "none", "MOD_GRENADE", 0, level.cybercom.electro_strike.vehicle_weapon);
		self playsound ("gdt_cybercore_amws_shutdown");
	}
	else
	{
		self DoDamage(GetDvarInt( "scr_es_damage", 5 ), source.origin, (isDefined(attacker)?attacker:undefined),undefined, "none", "MOD_UNKNOWN", 512 /*DAMAGE_DISABLE_RAGDOLL_SKIP*/, level.cybercom.electro_strike.other_weapon);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function electroStaticArc(player, upgraded)
{
	self endon("death");
	if(!upgraded)
		return;
	
	{wait(.05);};
	
	electro_strike_arc_range 	= GetDvarInt( "scr_es_arc_range", 72 );
	if(upgraded)
	{
		electro_strike_arc_range = GetDvarInt( "scr_es_upgraded_arc_range", 128 );
	}

	distSQ = ( (electro_strike_arc_range) * (electro_strike_arc_range) );
	enemies = [];
	
	prospects = ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);
	potential_enemies = util::get_array_of_closest( self.origin, prospects );
	foreach(enemy in potential_enemies)
	{
		if(!isDefined(enemy))
			continue;
			
		if (enemy == self )
			continue;		
		
		if ( ( isdefined( enemy.is_disabled ) && enemy.is_disabled ) )
			continue;
				
		if( ( isdefined( enemy.missingLegs ) && enemy.missingLegs ) || ( isdefined( enemy.isCrawler ) && enemy.isCrawler ) )
			continue;
	
		if (!enemy isValidESTarget(player) )
			continue;
		
		if ( DistanceSquared( self.origin, enemy.origin ) > distSQ )
			continue;

		if ( !BulletTracePassed( self.origin,enemy.origin+(0,0,50), false, undefined ) )
			continue;
		
		//valid target		
		enemies[enemies.size] = enemy;
	}
	
	i=0;
	foreach(guy in enemies)
	{
		self thread _electroDischargeArcDmg(guy,player,upgraded);
		i++;
		if(i>=GetDvarInt( "scr_es_max_arcs", 4 ))
			break;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeArcDmg( target,player,upgraded )
{
	if ( !IsDefined( self ) || !IsDefined( target ) )
		return;


	origin = self.origin+(0,0,40);
	target_origin = target.origin+(0,0,40);
	
	fxOrg = Spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["es_arc"], fxOrg, "tag_origin" );
	fxOrg playsound( "gdt_electro_bounce" );
	
	fxOrg MoveTo( target_origin,0.25);
	fxOrg util::waittill_any_timeout(1,"movedone" );
	fxOrg delete();
	target thread electroStaticContact(player,self,upgraded,undefined,true);
}

