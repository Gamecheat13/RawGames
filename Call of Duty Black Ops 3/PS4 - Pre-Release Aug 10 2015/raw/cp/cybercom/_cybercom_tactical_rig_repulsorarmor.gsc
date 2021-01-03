    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

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


#precache( "fx", "zombie/fx_tesla_bolt_secondary_zmb");
#precache( "fx", "vehicle/fx_quadtank_airburst");
#precache( "fx", "electric/fx_elec_sparks_burst_lg_os");











#namespace cybercom_tacrig_respulsorarmor;




function init()
{
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	

	level._effect["repulsorarmor_fx"]					= "vehicle/fx_quadtank_airburst";
	level._effect["repulsorarmorUpgraded_fx"]			= "vehicle/fx_quadtank_airburst";
	level._effect["repulsorarmor_arc"]					= "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["repulsorarmor_contact"]				= "electric/fx_elec_sparks_burst_lg_os";
	
	
	cybercom_tacrig::register_cybercom_rig_ability( "cybercom_repulsorarmor", 1 );
	cybercom_tacrig::register_cybercom_rig_possession_callbacks( "cybercom_repulsorarmor",  &RepulsorArmorShieldGive, &RepulsorArmorShieldTake );
	cybercom_tacrig::register_cybercom_rig_activation_callbacks( "cybercom_repulsorarmor",  &RepulsorArmorShieldActivate, &RepulsorArmorShieldDeactivate);	
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
// Tactical RIG - Repulsor Armor
// Standard: Destroys grenades at 300 units out
// Upgraded: Destroys grenades and rockets at 512 units out
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RepulsorArmorShieldGive(type)
{
	//setup ui?
	//vision sets or audio?	

	//trophy system
	if( !isdefined( self.missile_repulsor ) ) 
	{	
		isUpgraded = (self HasCyberComRig(type)==2);
		self.missile_repulsor = missile_createrepulsorent( self, 4000, GetDvarInt( "scr_repulsorarmor_dist",200 ), isUpgraded );
	}
	
	if(!isDefined(self.cybercom.activeRepulsorThreats))
	{
		self.cybercom.activeRepulsorThreats 	 = [];
		self.cybercom.activeRepulsorThreats[0] = spawnstruct();
		self.cybercom.activeRepulsorThreats[1] = spawnstruct();
		self.cybercom.activeRepulsorThreats[2] = spawnstruct();
		self.cybercom.activeRepulsorThreats[3] = spawnstruct();
		self.cybercom.activeRepulsorThreats[0].time = 0;
		self.cybercom.activeRepulsorThreats[1].time = 0;
		self.cybercom.activeRepulsorThreats[2].time = 0;
		self.cybercom.activeRepulsorThreats[3].time = 0;
	}
	
	self thread ui_pumpActiveRepulsorThreats();
	
	//turn on by default.  This rig is always on if given
	cybercom_tacrig::turn_rig_ability_on(type);
	
//	self.cybercom.repulsor_shield_targets = [];	
//	self thread _repulsorArmorShieldMonitorThreats(type);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RepulsorArmorShieldTake(type)
{
	//teardown ui?
	//vision sets or audio?	
	if( isdefined( self.missile_repulsor ) ) 
	{
		missile_deleteattractor( self.missile_repulsor );
		self.missile_repulsor = undefined;
	}
	self notify("RepulsorArmorShieldTake");
	self.cybercom.activeRepulsorThreats = undefined;
//	self notify("stop_repulsorArmorShieldMonitorThreats");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _threatMonitor(isUpgraded)
{
	self notify("RepulseArmorThreatMonitor");
	self endon("RepulseArmorThreatMonitor");
	self endon ("RepulsorArmorShieldTake");
	self endon ("RepulsorArmorShieldDeactivate");

	cooldown = 0.5;
	lastUsed = GetTime();
	
	fx = (isUpgraded?level._effect["repulsorarmorUpgraded_fx"]:level._effect["repulsorarmor_fx"]);
	while( 1 )
	{
		self waittill( "projectile_applyattractor",missile );
		if ( GetTime() > lastUsed + cooldown * 1000 )
		{
			PlayFxOnTag( fx, self, "tag_origin" );
			self PlaySound( "gdt_cybercore_rig_repulse_jawawawa" );
			self thread  _repulseThreat(missile,self.origin+(0,0,72));
			lastUsed = GetTime();
		}
	}	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RepulsorArmorShieldActivate(type)
{
	self thread  _threatMonitor(self HasCyberComRig(type));
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RepulsorArmorShieldDeactivate(type)
{
	self notify("RepulsorArmorShieldDeactivate");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ui_pumpActiveRepulsorThreats()
{
	self endon ("RepulsorArmorShieldTake");
	while(1)
	{
		curtime 	= GetTime();
		hottestZone = undefined;
		newestTime 	= 0;
		
		for(zone=0;zone<4;zone++)
		{
			if( self.cybercom.activeRepulsorThreats[zone].time > curtime )
			{
				threat = self.cybercom.activeRepulsorThreats[zone].threat;
				if(isDefined(threat))
				{
					self.cybercom.activeRepulsorThreats[zone].yaw = self cybercom::GetYawToSpot(threat.origin);			//update the yaw incase we ever want to move to a ui sytem that isn't just based on carinal directions n/s/e/w
				   // self clientfield::set_player_uimodel( "playerAbilities.repulsorIndicatorDirection", zone, self.cybercom.activeRepulsorThreats[zone].yaw);				
				}
				
				if ( self.cybercom.activeRepulsorThreats[zone].time > newestTime )	///it appears that you can only have one indicator active, so use the newest one?  
				{
					newestTime 	= self.cybercom.activeRepulsorThreats[zone].time;
					hottestZone = zone;
				}
			}
			else
			if ( self.cybercom.activeRepulsorThreats[zone].time != 0 )
			{
				self.cybercom.activeRepulsorThreats[zone].time   = 0;
				self.cybercom.activeRepulsorThreats[zone].threat = undefined;
				self.cybercom.activeRepulsorThreats[zone].yaw	 = undefined;
			}
		}
		
		if(isDefined(hottestZone)) //illuminate the newest hot zone quadrant
		{
			self clientfield::set_player_uimodel( "playerAbilities.repulsorIndicatorIntensity", 1 );
		    self clientfield::set_player_uimodel( "playerAbilities.repulsorIndicatorDirection", hottestZone );				
		}
		else
		{
			self clientfield::set_player_uimodel( "playerAbilities.repulsorIndicatorIntensity", 0 );
		}
			
		
		{wait(.05);};
	}
}

function repulsorArmorActivateUIFeedback(threat)
{
	threat = (isDefined(threat.owner)?threat.owner:threat);	//if threat has an owner, probably better to point indicator towards owner?
	//this 'zone' system uses only 4 fixed indicator directions N/S/E/W.  If the player rotates, the threat indicator stays fixed and is somewhat confusing because of this.		
	yaw = self cybercom::GetYawToSpot(threat.origin);
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
	
	self.cybercom.activeRepulsorThreats[zone].time 		= GetTime()+GetDvarInt( "scr_repulsorarmor_indicator_durationMSEC",1500 );  //hot for 1.5 seconds
	self.cybercom.activeRepulsorThreats[zone].threat	= threat;	//if threat has an owner, probably better to point indicator towards owner?
	self.cybercom.activeRepulsorThreats[zone].yaw		= yaw;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _repulseThreat(grenade,trophyOrigin)   //todo, make this a legit missile weapon; faking it through script is lame(ish)
{
	self endon("disconnect");
	
/*	
	if(!isDefined(grenade))
		return;
		
	grenade.repulse_tagged = true;
	fxOrg = Spawn( "script_model", trophyOrigin);
	fxOrg SetModel( "tag_origin" );
	fx = PlayFxOnTag( level._effect["repulsorarmor_arc"], fxOrg, "tag_origin" );
	
	fxOrg thread _lockTrackToEntity( grenade, REPULSORARMOR_WEAPON_SPEED );
	fxOrg waittill( "tracktoentitydone" );
	fxOrg delete();
*/	
	if(isDefined(grenade))
	{
		self thread repulsorArmorActivateUIFeedback(grenade);
		grenade PlaySound( "gdt_cybercore_rig_repulse_jawawawa_missile" );
		PlayFx( level._effect["repulsorarmor_contact"], grenade.origin ); 
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lockTrackToEntity(target,time)  //todo, make this a legit missile weapon; faking it through script is lame(ish)
{
	self endon("disconnect");
	self endon("death");
	
	if ( time <= 0 )
		time = 1;
	
	intervals  	= time / GetDvarFloat( "scr_repulsorarmor_weapon_tick", 0.05 );
	while (isDefined(target) && time > GetDvarFloat( "scr_repulsorarmor_weapon_tick", 0.05 ) )
	{
		dist 		= Distance(self.origin,target.origin);
		step 		= (dist/time)/intervals;
		v_to_target = VectorNormalize( target.origin - self.origin ) * step;
		/#
		//util::debug_line( self.origin, self.origin + v_to_target, (1,0,0), 0.8, false, 100 );
		#/
		self.origin +=v_to_target;
		dist 	= Distance(self.origin,target.origin);
		if ( dist < 32 )
			break;
		time -= GetDvarFloat( "scr_repulsorarmor_weapon_tick", 0.05 );
		wait GetDvarFloat( "scr_repulsorarmor_weapon_tick", 0.05 );
	}
	self notify("tracktoentitydone");
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// OLD script
/*
function _repulsorArmorShieldMonitorThreats(type)
{
	self notify("stop_repulsorArmorShieldMonitorThreats");
	self endon("stop_repulsorArmorShieldMonitorThreats");
	self endon("disconnect");
	self endon("take_ability_"+type);
	
	ability = self HasCyberComRig(type);

	distThreshSQ = ( ability != CCOM_STATUS_UPGRADED ? SQR(REPULSORARMOR_INCOMING_DIST_THRESHOLD) : SQR(REPULSORARMOR_INCOMING_DIST_THRESHOLD_UPGRADED));
	while(1)
	{
		wait (level.missileEntities.size?0.05:0.25);
		
		if( IS_TRUE(self.cybercom.tacrigs_disabled))
			continue;		
			
		foreach(grenade in level.missileEntities)
		{
			if ( !IsDefined(grenade) )
				continue;
			
			if ( grenade.team == self.team )
				continue;

			if ( IS_TRUE(grenade.repulse_tagged) )
				continue;

			if( !IS_TRUE(grenade.weapon.destroyableByTrophySystem) )
				continue;
			
			if( grenade.classname != "grenade" && ability != CCOM_STATUS_UPGRADED )
				continue;
			
			if( isDefined(grenade.owner) )
			{
				if( grenade.owner cybercom::cybercom_AICheckOptOut("cybercom_repulsorarmor"))
					continue;
			}
			
			//Is projectile in range?
			distSQ = DistanceSquared( self.origin, grenade.origin );
			if (distSQ > distThreshSQ)
				continue;

			trophyOrigin = self.origin + (0,0,72);	
			if ( isdefined( grenade ) && BulletTracePassed( grenade.origin, trophyOrigin, true, self, grenade ) )
			{
				ARRAY_ADD( self.cybercom.repulsor_shield_targets, grenade );
				self thread cybercom_tacrig::turn_rig_ability_on(type);
				self thread _repulseThreat(type,grenade,trophyOrigin);
				//self.repulsorArmorShieldPower =  math::clamp(self.repulsorArmorShieldPower-REPULSORARMOR_WEAPON_COST,0,100);
			}
		}
	}
}
*/
