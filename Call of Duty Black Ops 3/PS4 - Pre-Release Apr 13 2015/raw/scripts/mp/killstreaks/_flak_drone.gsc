#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using  scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\_helicopter_sounds;
#using scripts\mp\_util;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    

#using scripts\shared\duplicaterender_mgr;
                                                                           

#precache( "client_fx", "killstreaks/fx_heli_smk_trail_engine_33" );
#precache( "client_fx", "killstreaks/fx_heli_smk_trail_engine_66" );
#precache( "client_fx", "killstreaks/fx_drgnfire_rotor_wash_runner" );
#precache( "client_fx", "killstreaks/fx_ed_lights_green" );
#precache( "client_fx", "killstreaks/fx_ed_lights_red" );
#precache( "client_fx", "killstreaks/fx_sc_lights_grn" );
#precache( "client_fx", "killstreaks/fx_sc_lights_red" );
#precache( "client_fx", "killstreaks/fx_vtol_lights_grn" );
#precache( "client_fx", "killstreaks/fx_vtol_lights_red" );
#precache( "client_fx", "killstreaks/fx_vtol_thruster" );

#using_animtree( "mp_vehicles" );

#namespace helicopter;







function autoexec __init__sytem__() {     system::register("helicopter",&__init__,undefined,undefined);    }
	
function __init__()
{		
	level.chopper_fx["damage"]["light_smoke"] = "killstreaks/fx_heli_smk_trail_engine_33";
	level.chopper_fx["damage"]["heavy_smoke"] = "killstreaks/fx_heli_smk_trail_engine_66";

	level._effect["qrdrone_prop"] = "killstreaks/fx_drgnfire_rotor_wash_runner";
	level._effect["heli_guard_light"]["friendly"] = "killstreaks/fx_sc_lights_grn";
	level._effect["heli_guard_light"]["enemy"] = "killstreaks/fx_sc_lights_red";
	level._effect["heli_comlink_light"]["friendly"] = "killstreaks/fx_sc_lights_grn";
	level._effect["heli_comlink_light"]["enemy"] = "killstreaks/fx_sc_lights_red";
	level._effect["heli_gunner_light"]["friendly"] = "killstreaks/fx_vtol_lights_grn";
	level._effect["heli_gunner_light"]["enemy"] = "killstreaks/fx_vtol_lights_red";

	level._effect["heli_gunner"]["vtol_fx"] = "killstreaks/fx_vtol_thruster";
	level._effect["heli_gunner"]["vtol_fx_ft"] = "killstreaks/fx_vtol_thruster";

	clientfield::register( "helicopter", "heli_warn_targeted", 1, 1, "int", &warnMissileLocking, !true, !true);
	clientfield::register( "helicopter", "heli_warn_locked", 1, 1, "int", &warnMissileLocked, !true, !true);
	clientfield::register( "helicopter", "heli_warn_fired", 1, 1, "int", &warnMissileFired, !true, !true);
	
	clientfield::register( "helicopter", "supplydrop_care_package_state", 1, 1, "int",&supplydrop_care_package_state, !true, !true);
	clientfield::register( "helicopter", "supplydrop_ai_tank_state", 1, 1, "int",&supplydrop_ai_tank_state, !true, !true);
	
	clientfield::register( "helicopter", "heli_comlink_bootup_anim", 1, 1, "int",&heli_comlink_bootup_anim, !true, !true);

	
	clientfield::register( "vehicle", "heli_warn_targeted", 1, 1, "int", &warnMissileLocking, !true, !true);
	clientfield::register( "vehicle", "heli_warn_locked", 1, 1, "int", &warnMissileLocked, !true, !true);
	clientfield::register( "vehicle", "heli_warn_fired", 1, 1, "int", &warnMissileFired, !true, !true);
	
	clientfield::register( "vehicle", "supplydrop_care_package_state", 1, 1, "int",&supplydrop_care_package_state, !true, !true);
	clientfield::register( "vehicle", "supplydrop_ai_tank_state", 1, 1, "int",&supplydrop_ai_tank_state, !true, !true);
	
	clientfield::register( "vehicle", "heli_comlink_bootup_anim", 1, 1, "int",&heli_comlink_bootup_anim, !true, !true);

	duplicate_render::set_dr_filter_framebuffer( "active_camo_scorestreak", 90, "active_camo_on", "", 0, "mc/hud_outline_predator_camo_active_enemy_scorestreak" );
	duplicate_render::set_dr_filter_framebuffer( "active_camo_flicker_scorestreak", 80, "active_camo_flicker", "", 0, "mc/hud_outline_predator_camo_disruption_enemy_scorestreak" );
	duplicate_render::set_dr_filter_framebuffer( "active_camo_reveal_scorestreak", 80, "active_camo_reveal", "", 0, "mc/hud_outline_predator" );
	
	clientfield::register( "helicopter", "active_camo", 1, 3, "int", &active_camo_changed, !true, !true );
	clientfield::register( "vehicle", "active_camo", 1, 3, "int", &active_camo_changed, !true, !true );
}

function SetupAnimTree()
{
	if ( self HasAnimTree() == false )
		self UseAnimTree( #animtree );
}

function active_camo_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == ( 0 ) )
	{
		self.lightFXID = PlayFXOnTag( localClientNum, level._effect["heli_comlink_light"]["friendly"], self, "tag_origin" );
	}
	else
	{
		if( isdefined( self.lightFXID ) )
		{
			StopFX( localClientNum, self.lightFXID );
		}
	}
	
	self duplicate_render::set_dr_flag( "active_camo_flicker", newVal == ( 2 ) );
	self duplicate_render::set_dr_flag( "active_camo_on", false );
	self duplicate_render::set_dr_flag( "active_camo_reveal", true );
	
	self duplicate_render::change_dr_flags();
	
	self notify( "endtest" );
	
	self thread doReveal( localClientNum, newVal != ( 0 ) );
}


function doReveal( localClientNum, direction )
{
	self notify( "endtest" );
	self endon( "endtest" );
	
	self endon( "entityshutdown" );
	
	if( direction )
	{
		startVal = 1;
	}
	else
	{
		startVal = 0;
	}
	
	while( ( startVal >= 0 ) && ( startVal <= 1 ) )
	{
		self MapShaderConstant( localClientNum, 0, "scriptVector0", startVal, 0, 0, 0 );
		if( direction )
		{
			startVal -= .016 / 0.5;
		}
		else
		{
			startVal += .016 / 0.5;
		}
		wait( .016 );
	}
	
	self duplicate_render::set_dr_flag( "active_camo_reveal", false );
	self duplicate_render::set_dr_flag( "active_camo_on", direction );
	self duplicate_render::change_dr_flags();
}

function heli_comlink_bootup_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	self SetupAnimTree();
	self SetAnim( %veh_anim_future_heli_gearup_bay_open, 1.0, 0.0, 1.0 );
}

function supplydrop_care_package_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon( "entityshutdown" );
	self endon( "death" );
	self SetupAnimTree();
	if ( newVal == 1 )
	{
		self SetAnim( %o_drone_supply_care_idle, 1.0, 0.0, 1.0 );
	}
	else
	{
		self SetAnim( %o_drone_supply_care_drop, 1.0, 0.0, 0.3 );
	}
}

function supplydrop_ai_tank_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon( "entityshutdown" );
	self endon( "death" );
	self SetupAnimTree();
	
	if ( newVal == 1 )
	{
		self SetAnim( %o_drone_supply_agr_idle, 1.0, 0.0, 1.0 );
	}
	else
	{
		self SetAnim( %o_drone_supply_agr_drop, 1.0, 0.0, 0.3 );		
	}
}

function warnMissileLocking( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal && !(self IsLocalClientDriver(localClientNum)) )
		return;
		
	helicopter_sounds::play_targeted_sound( newVal );
}

function warnMissileLocked( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal && !(self IsLocalClientDriver(localClientNum)) )
		return;

	helicopter_sounds::play_locked_sound( newVal );
}

function warnMissileFired( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal && !(self IsLocalClientDriver(localClientNum)) )
		return;

	helicopter_sounds::play_fired_sound( newVal );
}

function heli_deletefx(localClientNum)
{
	if (isdefined(self.exhaustLeftFxHandle))
	{
		deletefx( localClientNum, self.exhaustLeftFxHandle );
		self.exhaustLeftFxHandle = undefined;
	}
	
	if (isdefined(self.exhaustRightFxHandlee))
	{
		deletefx( localClientNum, self.exhaustRightFxHandle );
		self.exhaustRightFxHandle = undefined;
	}
	
	if (isdefined(self.lightFXID))
	{
		deletefx( localClientNum, self.lightFXID );
		self.lightFXID = undefined;
	}

	if (isdefined(self.propFXID))
	{
		deletefx( localClientNum, self.propFXID );
		self.propFXID = undefined;
	}
	
	if (isdefined(self.vtolLeftFXID))
	{
		deletefx( localClientNum, self.vtolLeftFXID );
		self.vtolLeftFXID = undefined;
	}
	
	if (isdefined(self.vtolRightFXID))
	{
		deletefx( localClientNum, self.vtolRightFXID );
		self.vtolRightFXID = undefined;
	}

}

function startfx(localClientNum)
{
	self endon( "entityshutdown" );

	if (  isdefined( self.vehicletype ) )
	{
//		if ( self.vehicletype == "heli_guard_mp" )
//		{
//			return;
//		}
	
		if ( self.vehicletype == "remote_mortar_vehicle_mp" )
		{
			return;
		}
		
//		if ( self.vehicletype == "heli_player_gunner_mp" )
//		{
//			return;
//		}
		
		if ( self.vehicletype == "vehicle_straferun_mp" )
		{
			return;
		}
	}
	
	if( isdefined( self.exhaustfxname ) && self.exhaustfxname != "" )
	{
		self.exhaustFx = self.exhaustfxname; 
	}

	if( isdefined(self.exhaustFx) )
	{
		self.exhaustLeftFxHandle = PlayFXOnTag( localClientNum, self.exhaustFx, self, "tag_engine_left" );		
		if( !( isdefined( self.oneexhaust ) && self.oneexhaust ) /*!self.oneexhaust*/ )//TODO T7 - not sure why this isn't getting set anymore
		{
			self.exhaustRightFxHandle = PlayFXOnTag( localClientNum, self.exhaustFx, self, "tag_engine_right" );
		}
	}
	else
	{
	/#	PrintLn("Client: _helicopter.csc - startfx() - exhaust rotor fx is not loaded");	#/
	}
	
	if( isdefined( self.vehicletype ) )
	{
		light_fx = undefined;
		prop_fx = undefined;
		
		switch( self.vehicletype )
		{
			case "heli_ai_mp":
				light_fx = "heli_comlink_light";
				break;
//			case "heli_supplydrop_mp":
//				light_fx = "chinook_light";
//				break;
			case "heli_player_gunner_mp":	
				//TODO store FX not on self to prevent edge cases where it doesnt get cleaned up				
				self.vtolLeftFXID = PlayFXOnTag( localClientNum, level._effect["heli_gunner"]["vtol_fx"], self, "tag_engine_left" );
				self.vtolRightFXID = PlayFXOnTag( localClientNum, level._effect["heli_gunner"]["vtol_fx_ft"], self, "tag_engine_right" );
				light_fx = "heli_gunner_light";
				break;
//			case "heli_player_controlled_firstperson_mp":
//			case "heli_player_controlled_mp":
//				light_fx = "hind_light";
//				break;
			case "heli_guard_mp":
				light_fx = "heli_guard_light";
				break;
			case "qrdrone_mp":
				prop_fx = "qrdrone_prop";
				break;
		};
	
		if ( isdefined( light_fx ) )
		{
			if ( self util::friend_not_foe( localClientNum ) )
			{
//				PrintLn( "HELI playing friendly " + light_fx + " " +   level._effect[light_fx]["friendly"] );
				self.lightFXID = PlayFXOnTag( localClientNum, level._effect[light_fx]["friendly"], self, "tag_origin" );
			}
			else
			{
//				PrintLn( "HELI playing enemy " + light_fx + " " +   level._effect[light_fx]["enemy"] );
				self.lightFXID = PlayFXOnTag( localClientNum, level._effect[light_fx]["enemy"], self, "tag_origin" );
			}
		}
		
		if ( isdefined( prop_fx ) && !self IsLocalClientDriver( localClientNum ))
		{
			self.propFXID = PlayFXOnTag( localClientNum, level._effect[prop_fx], self, "tag_origin" );
		}
	}
	
	self damage_fx_stages(localClientNum);
}

function startfx_loop(localClientNum)
{
	self endon( "entityshutdown" );

	self thread helicopter_sounds::aircraft_dustkick(localClientNum);
	//self thread helicopter_sounds::start_helicopter_sounds();

	startfx( localClientNum );
	
	serverTime = getServerTime( 0 );
	lastServerTime = serverTime;
	
	while( isdefined( self ) )
	{
		//println( "HELI startfx_loop (" + serverTime + ")" );
		// if time goes backwards, then restart them
		if (serverTime < lastServerTime)
		{
			//println( "HELI !!! startfx called (" + serverTime + ")" );
			heli_deletefx( localClientNum );
			//wait( 0.5 );
			startfx( localClientNum );
		}
		wait( 0.05 );	// small for added granularity. any bigger and rapid time switching can cause problems.
		lastServerTime = serverTime;
		serverTime = getServerTime( 0 );
	}
}

function damage_fx_stages(localClientNum)
{
	self endon( "entityshutdown" );

	last_damage_state = self GetHeliDamageState();
	fx = undefined;
	
	for ( ;; )
	{
		if ( last_damage_state != self GetHeliDamageState() )
		{
			if ( self GetHeliDamageState() == 2 )
			{
				if ( isdefined(fx) )
					stopfx( localClientNum, fx );
					
				fx = trail_fx( localClientNum, level.chopper_fx["damage"]["light_smoke"], "tag_engine_left" );
			}
			else if ( self GetHeliDamageState() == 1 )
			{
				if ( isdefined(fx) )
					stopfx( localClientNum, fx );

				fx = trail_fx( localClientNum, level.chopper_fx["damage"]["heavy_smoke"], "tag_engine_left" );
			}
			else
			{
				if ( isdefined(fx) )
					stopfx( localClientNum, fx );

				self notify( "stop trail" );
			}		
			last_damage_state = self GetHeliDamageState();
		}
		wait(0.25);
	}
}

function trail_fx( localClientNum, trail_fx, trail_tag )
{
	// only one instance allowed
//	self notify( "stop trail" );
//	self endon( "stop trail" );
//	self endon( "entityshutdown" );
		
//	for ( ;; )
	{
		id = playfxontag( localClientNum, trail_fx, self, trail_tag );
		//wait( 0.05 );
	}
	return id;
}
