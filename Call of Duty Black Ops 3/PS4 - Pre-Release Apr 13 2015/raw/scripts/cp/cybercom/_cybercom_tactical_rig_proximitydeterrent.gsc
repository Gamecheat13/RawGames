    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

#using scripts\shared\math_shared;
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_gadget_servo_shortout;


#precache( "fx", "zombie/fx_tesla_bolt_secondary_zmb");
#precache( "fx", "electric/fx_elec_sparks_burst_blue");
#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");





#namespace cybercom_tacrig_proximitydeterrent;

function init()
{
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	level._effect["electro_static_arc"]					= "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["electro_static_secondary_contact"]	= "electric/fx_elec_sparks_burst_blue";
	level._effect["electro_static_contact"]				= "electric/fx_elec_sparks_burst_lg_os";
	level._effect["proxy_deterrent_freeze"]				= "electric/fx_elec_sparks_burst_lg_os";

	cybercom_tacrig::register_cybercom_rig_ability( "cybercom_proximitydeterrent", 2 );
	cybercom_tacrig::register_cybercom_rig_possession_callbacks( "cybercom_proximitydeterrent", &ProximityDeterrentGive, &ProximityDeterrentTake );
	cybercom_tacrig::register_cybercom_rig_activation_callbacks( "cybercom_proximitydeterrent",  &ProximityDeterrentActivate, &ProximityDeterrentDeactivate);	
}


//---------------------------------------------------------
function on_player_connect()
{	
}
function on_player_spawned()
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Tactical RIG - Proximity Deterent
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProximityDeterrentGive(type)
{
	//ui
	//audio
	//etc
	
	self thread ProximityDeterrentThink(type); 
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProximityDeterrentTake(type)
{
	//ui
	//audio
	//etc
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProximityDeterrentThink(type)
{
	self notify("ProximityDeterrentThink");
	self endon("ProximityDeterrentThink");
	self endon("disconnect");
	self endon("take_ability_"+type);

	while(1)
	{
		self waittill( "damage", n_damage, e_attacker, v_vector, v_point, str_means_of_death, str_string_1, str_string_2, str_string_3, w_weapon );
		
		if( isSubStr(str_means_of_death,"MOD_MELEE") && isDefined(e_attacker)  )
		{	
			self.cybercom.proximity_deterrent_target = e_attacker;
			self cybercom_tacrig::turn_rig_ability_on(type);
			//ui
			//vision set?
			//audio?
			//delay cooldown?
		}
	}	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProximityDeterrentActivate(type)
{
	//ui
	//audio
	if(isDefined(self.cybercom.proximity_deterrent_target))
	{
		self.cybercom.proximity_deterrent_target thread ProximityDeterrentOnAttacker(type,self);
	}
	self cybercom_tacrig::turn_rig_ability_off(type);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProximityDeterrentDeactivate(type)
{
	//ui
	//audio
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProximityDeterrentOnAttacker(type,player)
{
	if(!isDefined(self))
		return;

	if( ( isdefined( player.cybercom.tacrigs_disabled ) && player.cybercom.tacrigs_disabled ))
		return;		

	if( ( isdefined( self.noCyberCom ) && self.noCyberCom ) )
		return;

	if(player HasCyberComRig(type)  == 	2)
	{
		self thread _electroDischargeDoDamage( player );
	}
	else
	{
		level thread _stunAssailant(player,self);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _electroDischargeDoDamage( player )
{
	if( !IsDefined( self ) || !IsAlive( self ) )
		return;

	if ( self.archetype == "human" || self.archetype == "robot" )
	{
		PlayFxOnTag( level._effect["electro_static_contact"], self, "J_SpineUpper" ); 
	}
	else
	{
		PlayFxOnTag( level._effect["electro_static_contact"], self, "tag_origin" ); 
	}
	self playsound( "zmb_pwup_coco_impact" );
	self kill( self.origin, player );

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _stunAssailant (player,attacker)
{
	attacker endon("death");

	if (attacker.archetype == "robot" )
	{
		attacker thread cybercom_gadget_servo_shortout::servo_shortout(player, GetWeapon("gadget_servo_shortout"), false, undefined, GetDvarInt( "scr_proximity_stun_damage_to_robotORhuman", 50 ));
	}
	else
	if( attacker.archetype == "human" )
	{
		PlayFxOnTag( level._effect["electro_static_contact"], attacker, "J_SpineUpper" ); 
		attacker DoDamage(GetDvarInt( "scr_proximity_stun_damage_to_robotORhuman", 50 ), player.origin, player, player, "none", "MOD_RIFLE_BULLET", 0, GetWeapon("gadget_concussive_wave"),-1,true);
	}
	else
	if(isVehicle(attacker))
	{
		PlayFxOnTag( level._effect["electro_static_contact"], attacker, "tag_origin" ); 
		attacker DoDamage(GetDvarInt( "scr_proximity_stun_damage_to_robotORhuman", 50 ), player.origin, player, player, "none", "MOD_RIFLE_BULLET", 0, GetWeapon("emp_grenade"));
	}
	else
	{
		PlayFxOnTag( level._effect["electro_static_contact"], attacker, "tag_origin" ); 
		attacker kill(player.origin,undefined,undefined,GetWeapon("emp_grenade"));
	}
}
