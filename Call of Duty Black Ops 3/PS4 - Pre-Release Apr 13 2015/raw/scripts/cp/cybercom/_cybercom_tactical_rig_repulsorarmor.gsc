    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

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
		dist = (isUpgraded?GetDvarInt( "scr_repulsorarmor_dist_upgraded",512 ):GetDvarInt( "scr_repulsorarmor_dist",300 ));
		self.missile_repulsor = missile_createrepulsorent( self, 40000, dist, isUpgraded );
	}
	
	
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
//	self notify("stop_repulsorArmorShieldMonitorThreats");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _threatMonitor(isUpgraded)
{
	self notify("RepulseArmorThreatMonitor");
	self endon("RepulseArmorThreatMonitor");
	self endon ("RepulsorArmorShieldTake");
	self endon ("RepulsorArmorShieldDeactivate");
	
	fx = (isUpgraded?level._effect["repulsorarmorUpgraded_fx"]:level._effect["repulsorarmor_fx"]);
	while( 1 )
	{
		self waittill( "projectile_applyattractor",missile );
		PlayFxOnTag( fx, self, "tag_origin" );
		self PlaySound( "wpn_trophy_alert" );
		self thread  _repulseThreat(missile,self.origin+(0,0,72));
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
function private _repulseThreat(grenade,trophyOrigin)   //todo, make this a legit missile weapon; faking it through script is lame(ish)
{
	self endon("disconnect");
	if(!isDefined(grenade))
		return;
		
	grenade.repulse_tagged = true;
	fxOrg = Spawn( "script_model", trophyOrigin);
	fxOrg SetModel( "tag_origin" );
	fx = PlayFxOnTag( level._effect["repulsorarmor_arc"], fxOrg, "tag_origin" );
	
	fxOrg thread _lockTrackToEntity( grenade, GetDvarFloat( "scr_repulsorarmor_weapon_speed", 0.1 ) );
	fxOrg waittill( "tracktoentitydone" );
	fxOrg delete();
	if(isDefined(grenade))
	{
		self PlaySound( "wpn_trophy_projectile_deflected" );
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
