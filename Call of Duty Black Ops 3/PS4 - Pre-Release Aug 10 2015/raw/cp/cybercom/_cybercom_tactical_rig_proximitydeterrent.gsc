    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

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
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;


	//
	//


	//12feet
	//max number of enemy to hit

	
#namespace cybercom_tacrig_proximitydeterrent;

function init()
{
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
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
	self.cybercom.proxyDetWeapon = GetWeapon("gadget_proximity_det");
	self.cybercom.proxyDetWeaponRobot = GetWeapon("gadget_es_strike");

	
	if(!isDefined(self.cybercom.activeProxyThreats))
	{
		self.cybercom.activeProxyThreats 	 = [];
		self.cybercom.activeProxyThreats[0] = spawnstruct();
		self.cybercom.activeProxyThreats[1] = spawnstruct();
		self.cybercom.activeProxyThreats[2] = spawnstruct();
		self.cybercom.activeProxyThreats[3] = spawnstruct();
		self.cybercom.activeProxyThreats[0].time = 0;
		self.cybercom.activeProxyThreats[1].time = 0;
		self.cybercom.activeProxyThreats[2].time = 0;
		self.cybercom.activeProxyThreats[3].time = 0;
	}
	
	self thread ui_pumpActiveProxyThreats();	
	self thread ProximityDeterrentThink(type); 
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProximityDeterrentTake(type)
{
	//ui
	//audio
	//etc
	self.cybercom.proxyDetWeapon = undefined;
	self notify("ProximityDeterrentTake");
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
			
			self thread proximityDeterrentActivateUIFeedback(e_attacker);
			//ui
			//vision set?
			//audio?
			//delay cooldown?
		}
	}	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ui_pumpactiveProxyThreats()
{
	self endon ("ProximityDeterrentTake");
	while(1)
	{
		curtime 	= GetTime();
		hottestZone = undefined;
		newestTime 	= 0;
		
		for(zone=0;zone<4;zone++)
		{
			if( self.cybercom.activeProxyThreats[zone].time > curtime )
			{
				attacker = self.cybercom.activeProxyThreats[zone].attacker;
				if(isDefined(attacker))
				{
					self.cybercom.activeProxyThreats[zone].yaw = self cybercom::GetYawToSpot(attacker.origin);			//update the yaw incase we ever want to move to a ui sytem that isn't just based on carinal directions n/s/e/w
				   // self clientfield::set_player_uimodel( "playerAbilities.proximityIndicatorDirection", zone, self.cybercom.activeProxyThreats[zone].yaw);				
				}
				
				if ( self.cybercom.activeProxyThreats[zone].time > newestTime )	///it appears that you can only have one indicator active, so use the newest one?  
				{
					newestTime 	= self.cybercom.activeProxyThreats[zone].time;
					hottestZone = zone;
				}
			}
			else
			if ( self.cybercom.activeProxyThreats[zone].time != 0 )
			{
				self.cybercom.activeProxyThreats[zone].time   	= 0;
				self.cybercom.activeProxyThreats[zone].attacker = undefined;
				self.cybercom.activeProxyThreats[zone].yaw	 	= undefined;
			}
		}
		
		if(isDefined(hottestZone)) //illuminate the newest hot zone quadrant
		{
			self clientfield::set_player_uimodel( "playerAbilities.proximityIndicatorIntensity", 1 );
		    self clientfield::set_player_uimodel( "playerAbilities.proximityIndicatorDirection", hottestZone );				
		}
		else
		{
			self clientfield::set_player_uimodel( "playerAbilities.proximityIndicatorIntensity", 0 );
		}
			
		
		{wait(.05);};
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function proximityDeterrentActivateUIFeedback(attacker)
{
	yaw = self cybercom::GetYawToSpot(attacker.origin);
	
	if(yaw > -45  && yaw <=45 )
		zone = 0;					//north/top
	else
	if(yaw > 45 && yaw <=135 )
		zone = 3;					//east/right
	else
	if( (yaw > 135 && yaw<=180) || (yaw >=-180 && yaw <-135) )
		zone = 2;					//south/bottom
	else
		zone = 1;					//west/left
	
	self.cybercom.activeProxyThreats[zone].time 	= GetTime()+GetDvarInt( "scr_proximity_indicator_durationMSEC",1500 );  //hot for 1.5 seconds
	self.cybercom.activeProxyThreats[zone].attacker	= attacker;	
	self.cybercom.activeProxyThreats[zone].yaw		= yaw;
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

	player playsound( "gdt_cybercore_rig_prox_activate" );
	level thread _stunAssailant(player,self, (player HasCyberComRig(type)==2) );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _stunAssailant (player,attacker,upgraded)
{
	attacker endon("death");

	if(!isDefined(attacker.archetype))
		return;
	
	switch (attacker.archetype)
	{
		case "human":
		case "human_riotshield":
		case "zombie":
			contactTag = "J_Wrist_LE";
			fx = level._effect["es_effect_human"];
			tag = "j_spine4";
			damage = attacker.health;
			weapon = player.cybercom.proxyDetWeapon;
			if( isdefined( attacker.voicePrefix ) && isdefined( attacker.bcVoiceNumber ) )
			{
				attacker playsound( attacker.voicePrefix + attacker.bcVoiceNumber + "_exert_electrocution" );
			}	
			break;
		case "robot":
			contactTag = "J_Wrist_LE";
			fx = level._effect["es_effect_robot"];
			attacker playsound ("fly_bot_disable");
			tag = "j_spine4";
			damage = attacker.health;
			weapon = player.cybercom.proxyDetWeaponRobot;
			break;
		case "warlord":
			contactTag = "J_Wrist_LE";
			fx = level._effect["es_effect_warlord"];
			tag = "j_spine4";
			damage = GetDvarInt( "scr_proximity_stun_damage_to_warlord", 60 );
			weapon = player.cybercom.proxyDetWeapon;
			break;
		case "direwolf":
			contactTag = "J_Wrist_LE";
			fx = level._effect["es_effect_generic"];
			tag = "tag_origin";
			damage = attacker.health;
			weapon = player.cybercom.proxyDetWeapon;
			break;
		default:
			contactTag = "J_Wrist_LE";
			tag = "tag_origin";
			fx = level._effect["es_effect_generic"];
			damage = attacker.health;
			weapon = player.cybercom.proxyDetWeapon;
			break;
	}
	if(( isdefined( upgraded ) && upgraded ))
	{
		level thread radialProxyDischarge(player,attacker);
	}
	
	playfxontag(level._effect["es_contact"],player,contactTag);
	playfxontag(fx,attacker,tag);

	attacker playsound( "gdt_cybercore_rig_prox_imp" );
	
	attacker DoDamage(damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function radialProxyDischarge(player,attacker,radius)
{
	enemies = ArrayCombine(GetAITeamArray( "axis" ),GetAITeamArray( "team3" ),false,false);
	if(!isDefined(radius))
	{
		maxSQ   = ( (GetDvarInt( "scr_proximity_stun_discharge_radius", 12*12 )) * (GetDvarInt( "scr_proximity_stun_discharge_radius", 12*12 )) );
	}
	else
	{
		maxSQ   = ( (radius) * (radius) );
	}
	inRangeEnemy = [];
	foreach(guy in enemies)
	{
		if(isDefined(attacker) && guy == attacker)
			continue;
		
		if(isVehicle(guy))
			continue;
		
		if(!isDefined(guy.archetype))
			continue;
		
		if( ( isdefined( guy.noCyberCom ) && guy.noCyberCom ) )
			continue;

		if( guy.takedamage == false )
			continue;
	
		distSQ = distancesquared(player.origin,guy.origin);
		if(distSQ > maxSQ )
			continue;
		
		inRangeEnemy[inRangeEnemy.size] = guy;
		if(inRangeEnemy.size >= GetDvarInt( "scr_proximity_stun_max_secondary_hits", 6 ) )
			break;
	}
	
	foreach(guy in inRangeEnemy)
	{
		level thread _proximityDischarge(player, guy);
	}
}

function private _deleteEntOnNote(ent,note)
{
	ent endon("death");
	self waittill(note);
	ent delete();
}
function private _proximityDischarge(player, target)
{
	target endon("death");
	player endon("disconnect");
	
	orb = spawn("script_model",player.origin + (0,0,45));
	orb setModel("tag_origin");
	playfxontag(level._effect["es_arc"],orb,"tag_origin");

	orb endon("death");
	target thread _deleteEntOnNote(orb,"death");
	player thread _deleteEntOnNote(orb,"disconnect");
	
	orb moveto(target.origin + (0,0,45),.3);
	orb waittill("movedone");
	
	target playsound( "gdt_cybercore_rig_prox_imp" );

	damage = GetDvarInt( "scr_proximity_stun_damage", 20 );
	switch (target.archetype)
	{
		case "human":
		case "human_riotshield":
		case "zombie":
			fx = level._effect["es_effect_human"];
			tag = "j_spine4";
			target DoDamage(damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, player.cybercom.proxyDetWeapon,-1,true);	
			target notify("bhtn_action_notify", "electrocute");			
			break;
		case "robot":
			fx = level._effect["es_effect_robot"];
			tag = "j_spine4";
			target thread cybercom_gadget_system_overload::system_overload(player);
			break;
		case "warlord":
			fx = level._effect["es_effect_warlord"];
			tag = "j_spine4";
			target DoDamage(damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, player.cybercom.proxyDetWeapon,-1,true);			
			break;
		case "direwolf":
			fx = level._effect["es_effect_generic"];
			tag = "tag_origin";
			target DoDamage(damage, player.origin, player, player, "none", "MOD_UNKNOWN", 0, player.cybercom.proxyDetWeapon,-1,true);			
			break;
		default:
			fx = level._effect["es_effect_generic"];
			tag = "tag_body";
			target DoDamage( damage, player.origin, player, player, "none", "MOD_GRENADE_SPLASH", 0, GetWeapon("emp_grenade"),-1,true);
			break;
	}
	playfx(level._effect["es_contact"],orb.origin);
	playfxontag(fx,target,tag);
	orb delete();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetAdjustedDamage(iDamage,damageMod)
{
	if ( !isSubStr(damageMod,"_MELEE"))
		return iDamage;
	
	status 			= self HasCyberComRig("cybercom_proximitydeterrent");
	reducer 		= ((status == 2)?GetDvarFloat( "scr_proximity_damage_reducer_upg", .10 ):GetDvarFloat( "scr_proximity_damage_reducer", .20 ));
	reducedDamage 	= int(iDamage * reducer);
	return reducedDamage;
}
