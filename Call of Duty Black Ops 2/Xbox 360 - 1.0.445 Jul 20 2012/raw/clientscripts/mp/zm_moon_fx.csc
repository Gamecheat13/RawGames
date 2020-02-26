//
// file: mak_fx.gsc
// description: clientside fx script for mak: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_fx;
#include clientscripts\mp\_music;


//*****************************************************************************
//*****************************************************************************

main()
{
	precache_createfx_fx();
	clientscripts\mp\createfx\zm_moon_fx::main();
	clientscripts\mp\_fx::reportNumEffects();

//	footsteps();

	precache_scripted_fx();
	
	// TRAPS - Use an individual thread for each trap instance
	//level thread trap_fx_monitor( "digsite_east_trap", "digsite_east", "electric" );
	//level thread trap_fx_monitor( "digsite_west_trap", "digsite_west", "fire" );
	//level thread trap_fx_monitor( "bridge_trap", "bridge", "fire" );
		
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
	level thread clientscripts\mp\zombies\_zm::init_perk_machines_fx();
	level thread fog_triggers_setup();
	level thread airlock_fx_init();
	
	level thread breach_receiving_fx();
	level thread breach_labs_lower_fx();
	level thread breach_labs_upper_fx();
	level thread power_on_spinning_lights();
	
}

fog_triggers_setup()
{
	waitforclient(0);
	wait(3);
	players = getlocalplayers();
	for(i = 0;i<players.size;i++)
	{
		level thread moon_fog_triggers_init(i);	
  }
		
}


//*****************************************************************************
//*****************************************************************************

/*footsteps()
{

}*/

//*****************************************************************************
airlock_fx_init()
{
	waitforallclients();

	players = getlocalplayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] thread airlock_fx(i);
	}	
}	
airlock_fx(localClientNum)
{
	level waittill("power_on");
	
	airlock_fx = GetEntArray(localClientNum, "airlock_jambs_fx", "targetname");
	
	for(i = 0;i<airlock_fx.size;i++)
	{
		forwardVec = VectorNormalize( AnglesToForward(airlock_fx[i].angles) );
		PlayFX(localClientNum, level._effect["airlock_fx"], airlock_fx[i].origin, forwardVec);
	}
}	

//*****************************************************************************
//*****************************************************************************

precache_scripted_fx()
{
	level._effect["switch_sparks"]                        = loadfx ("env/electrical/fx_elec_wire_spark_burst");
	
	level._effect["zapper_fx"]                            = loadfx("maps/zombie/fx_zombie_zapper_powerbox_on");
	level._effect["zapper_wall"]                          = loadfx("maps/zombie/fx_zombie_zapper_wall_control_on");
	level._effect["elec_trail_one_shot"]                  = loadfx("maps/zombie/fx_zombie_elec_trail_oneshot");
	
	level._effect["zapper_light_ready"]                   = loadfx("maps/zombie/fx_zombie_zapper_light_green");
	level._effect["zapper_light_notready"]                = loadfx("maps/zombie/fx_zombie_zapper_light_red");
	level._effect["wire_sparks_oneshot"]                  = loadfx("electrical/fx_elec_wire_spark_dl_oneshot");
	
	//fx for airlocks
	level._effect["airlock_fx"]                  = loadfx("maps/zombie_moon/fx_moon_airlock_door_forcefield");

	level._effect["eye_glow"]	                            = LoadFx( "misc/fx_zombie_eye_single" );
		   
	level._effect["headshot"] 														= LoadFX( "impacts/fx_flesh_hit" );
	level._effect["headshot_nochunks"] 										= LoadFX( "misc/fx_zombie_bloodsplat" );
	level._effect["bloodspurt"] 													= LoadFX( "misc/fx_zombie_bloodspurt" );
	level._effect["animscript_gib_fx"] 		 								= LoadFx( "weapon/bullet/fx_flesh_gib_fatal_01" );		   
	level._effect["animscript_gibtrail_fx"] 	 						= LoadFx( "trail/fx_trail_blood_streak" );
	
	level._effect["jump_pad_active"] 					= loadfx("maps/zombie_moon/fx_moon_jump_pad_on");

	// FX for blowing out windows
	level._effect["glass_impact"]                    = loadfx("maps/zombie_moon/fx_moon_break_window" );

	level._effect["fx_weak_sauce_trail"]			       			= loadfx("maps/zombie_temple/fx_ztem_weak_sauce_trail");	   
	level._effect["soul_swap_trail"]					       			= loadfx("maps/zombie_moon/fx_moon_soul_swap");	   
	level._effect["vrill_glow"]														= LoadFX("maps/zombie_moon/fx_moon_vril_glow");

  // LOW G Rise FX
	level._effect["rise_billow_lg"]	            = loadFx("maps/zombie_moon/fx_moon_body_dirt_billowing");
	level._effect["rise_dust_lg"] 						= loadfx("maps/zombie_moon/fx_moon_body_dust_falling");
	level._effect["rise_burst_lg"]		           = loadFx("maps/zombie_moon/fx_moon_hand_dirt_burst");
  
  //excavator stuff
  level._effect["exca_beam"]	= loadfx("maps/zombie_moon/fx_digger_light_beam");
  level._effect["exca_blink"] = loadfx("maps/zombie_moon/fx_beacon_light_red");
  level._effect["digger_treadfx_fwd"] 									= loadfx("maps/zombie_moon/fx_digger_treadfx_fwd");
	level._effect["digger_treadfx_bkwd"] 									= loadfx("maps/zombie_moon/fx_digger_treadfx_rev");
	level._effect["panel_on"] = loadfx("maps/zombie_moon/fx_moon_digger_panel_on");
	level._effect["panel_off"] = loadfx("maps/zombie_moon/fx_moon_digger_panel_off");
	
	level._effect["lght_marker_flare"]        = Loadfx("maps/zombie/fx_zombie_coast_marker_fl");
	//spinning lights.
	level._effect["test_spin_fx"] = LoadFX( "env/light/fx_light_warning");	
	
	level._effect["blue_eyes"] = LoadFX( "maps/zombie/fx_zombie_eye_single_blue" );
	level._effect["osc_button_glow"] = LoadFX("maps/zombie_moon/fx_moon_button_console_glow");
}


//*****************************************************************************
//*****************************************************************************

precache_createfx_fx()
{
	level._effect["fx_mp_fog_xsm_int"] 			            = Loadfx("maps/zombie_old/fx_mp_fog_xsm_int");
	level._effect["fx_moon_fog_spawn_closet"]           = Loadfx("maps/zombie_moon/fx_moon_fog_spawn_closet");	
	level._effect["fx_zmb_fog_thick_300x300"] 			    = Loadfx("maps/zombie/fx_zmb_fog_thick_300x300");
	level._effect["fx_zmb_fog_thick_600x600"] 			    = Loadfx("maps/zombie/fx_zmb_fog_thick_600x600");	
	level._effect["fx_moon_fog_canyon"] 			          = Loadfx("maps/zombie_moon/fx_moon_fog_canyon");
	level._effect["fx_moon_vent_wall_mist"] 			      = Loadfx("maps/zombie_moon/fx_moon_vent_wall_mist");		
	level._effect["fx_dust_motes_blowing"] 			        = Loadfx("env/debris/fx_dust_motes_blowing");			
	level._effect["fx_zmb_coast_sparks_int_runner"] 	  = Loadfx("maps/zombie/fx_zmb_coast_sparks_int_runner");					
	level._effect["fx_moon_floodlight_narrow"] 			    = Loadfx("maps/zombie_moon/fx_moon_floodlight_narrow");		
	level._effect["fx_moon_floodlight_wide"] 	   		    = Loadfx("maps/zombie_moon/fx_moon_floodlight_wide");				
	level._effect["fx_moon_tube_light"] 	   		        = Loadfx("maps/zombie_moon/fx_moon_tube_light");	
	level._effect["fx_moon_lamp_glow"] 			            = Loadfx("maps/zombie_moon/fx_moon_lamp_glow");	
	level._effect["fx_moon_trap_switch_light_glow"] 		= Loadfx("maps/zombie_moon/fx_moon_trap_switch_light_glow");								
	
	level._effect["fx_moon_teleporter_beam"] 			      = Loadfx("maps/zombie_moon/fx_moon_teleporter_beam");		
	level._effect["fx_moon_teleporter_start"] 			    = Loadfx("maps/zombie_moon/fx_moon_teleporter_start");	
	level._effect["fx_moon_teleporter_pad_start"] 			= Loadfx("maps/zombie_moon/fx_moon_teleporter_pad_start");
	level._effect["fx_moon_teleporter2_beam"] 			    = Loadfx("maps/zombie_moon/fx_moon_teleporter2_beam");	
	level._effect["fx_moon_teleporter2_pad_start"] 			= Loadfx("maps/zombie_moon/fx_moon_teleporter2_pad_start");
		
	level._effect["fx_moon_pyramid_egg"] 	  	  	      = Loadfx("maps/zombie_moon/fx_moon_pyramid_egg");				
	level._effect["fx_moon_pyramid_drop"] 		  	      = Loadfx("maps/zombie_moon/fx_moon_pyramid_drop");
	level._effect["fx_moon_pyramid_opening"] 		  	    = Loadfx("maps/zombie_moon/fx_moon_pyramid_opening");			
	
	level._effect["fx_moon_ceiling_cave_dust"] 			    = Loadfx("maps/zombie_moon/fx_moon_ceiling_cave_dust");	
	level._effect["fx_moon_ceiling_cave_collapse"] 			= Loadfx("maps/zombie_moon/fx_moon_ceiling_cave_collapse");
	level._effect["fx_moon_digger_dig_dust"] 			      = Loadfx("maps/zombie_moon/fx_moon_digger_dig_dust");	
	level._effect["fx_moon_airlock_hatch_forcefield"] 	= Loadfx("maps/zombie_moon/fx_moon_airlock_hatch_forcefield");								
	level._effect["fx_moon_biodome_ceiling_breach"] 	  = Loadfx("maps/zombie_moon/fx_moon_biodome_ceiling_breach");	
	level._effect["fx_moon_biodome_breach_dirt"] 	      = Loadfx("maps/zombie_moon/fx_moon_biodome_breach_dirt");	
	
	level._effect["fx_moon_breach_debris_room_os"] 	    = Loadfx("maps/zombie_moon/fx_moon_breach_debris_room_os");	
	level._effect["fx_moon_breach_debris_out_os"] 	    = Loadfx("maps/zombie_moon/fx_moon_breach_debris_out_os");		
	
//	level._effect["fx_earth"] 	                        = Loadfx("maps/zombie_moon/fx_earth");	
	level._effect["fx_earth_destroyed"] 	              = Loadfx("maps/zombie_moon/fx_earth_destroyed");			

	// TRAP: Fire
	//level._effect["fire_trap_med"]                      = Loadfx("maps/zombie/fx_zombie_fire_trap_med");
	
	//Quad Vent Exploders	- bottom floor -1001,1002,1003,1004
	level._effect["fx_quad_vent_break"]          				= LoadFX("maps/zombie/fx_zombie_crawler_vent_break");		

}



//*****************************************************************************
// spinning lights
//*****************************************************************************



power_on_spinning_lights()
{
	level waittill("power_on");
	
	//tunnel 6 - Front Light - spinning light
	//level notify("sl2");
	
	//tunnel 6 - Back Light - spinning light
	//level notify("sl3");
	
	//tunnel 11 - spinning light
	//level notify("sl1");

	//Tunnel 11 - Back Area - spinning light
	//level notify("sl7");
	
}	



//*****************************************************************************
// TRAPS:
//*****************************************************************************

trap_fx_monitor( name, side, trap_type )
{
	while(1)
	{
		// Wait for the notify
		level waittill( name );

		// Spawn an FX for each struct
		points = getstructarray( name, "targetname" );
		for( i=0; i<points.size; i++ )
		{
			points[i] thread electric_trap_fx( name, side, trap_type );
		}
	}
}

breach_receiving_fx()
{
		level waittill( "Az1" );
//t6todo		clientscripts\mp\_fx::activate_exploder(300);

	if(level.power_on == false)
	{
		level waittill("ZPO");
	}
			
	//receiving - spinning light
	level notify("sl0");		
}
breach_labs_lower_fx()
{
		level waittill( "Az4a" );
//t6todo		clientscripts\mp\_fx::activate_exploder(320);

	if(level.power_on == false)
	{
		level waittill("ZPO");
	}
		
	//Labs - Mid Floor - spinning light
	level notify("sl5");
	
	//Labs - Bottom Floor - spinning light
	level notify("sl6");		
}
breach_labs_upper_fx()
{
		level waittill( "Az4b" );
//t6todo		clientscripts\mp\_fx::activate_exploder(340);

	if(level.power_on == false)
	{
		level waittill("ZPO");
	}

	//Labs - Top Floor - spinning light
	level notify("sl4");		
}


//*****************************************************************************
// ELECTRIC TRAP FX
//*****************************************************************************

electric_trap_fx( name, side, trap_type )
{
	// Get the structs oriantation
	ang = self.angles;
	forward = anglestoforward( ang );
	up = anglestoup( ang );
	
	// If the effects already exist, delete them
	if ( isdefined( self.loopFX ) )
	{
		for( i=0; i<self.loopFX.size; i++ )
		{
			self.loopFX[i] delete();
		}
		
		self.loopFX = [];
	}
	if(!isdefined(self.loopFX))
	{
		self.loopFX = [];
	}	

	// Create the Effect for each player
	players = getlocalplayers();
	for( i=0; i<players.size; i++ )
	{
		switch( trap_type )
		{
			case "electric":
				self.loopFX[i] = SpawnFx( i, level._effect["zapper"], self.origin, 0, forward, up );
			break;
			
			default:
			case "fire":
				self.loopFX[i] = SpawnFx( i, level._effect["fire_trap_med"], self.origin, 0, forward, up );
			break;
		}
//t6todo		triggerfx( self.loopFX[i] );
	}
	
	// Wait for the server notify to stop the effect
	level waittill( side + "off" );
	
	// Delete the effects
	for(i=0; i<self.loopFX.size; i++ )
	{
		self.loopFX[i] delete();
	}
	self.loopFX = [];

/*	
	if(isDefined(self.script_sound))
	{
		self.tag_origin playsound("elec_start");
		self.tag_origin playloopsound("elec_loop");
		self thread play_electrical_sound();
	}
	wait(30);
	wait(randomfloat(2));
	if(isDefined(self.script_sound))
	{
		self.tag_origin stoploopsound();
	}
	self.tag_origin delete();
	wait(2);
	notify_ent notify("elec_done");
	level notify ("arc_done"); 
*/
		
}


//------------------------------------------------------------------------------
// special triggers for entering and exiting fog changes
//------------------------------------------------------------------------------
moon_fog_triggers_init(localClientNum)
{
	
	exterior_array = GetEntArray(localClientNum, "zombie_moonExterior", "targetname");
	array_thread( exterior_array, ::fog_trigger, ::moon_exterior_fog_change);

	moon_interior_array = GetEntArray(localClientNum, "zombie_moonInterior", "targetname");
	array_thread( moon_interior_array, ::fog_trigger, ::moon_interior_fog_change);

	moon_biodome_array = GetEntArray(localClientNum, "zombie_moonBiodome", "targetname");
	array_thread( moon_biodome_array, ::fog_trigger, ::moon_biodome_fog_change);
	
	moon_biodome_array = GetEntArray(localClientNum, "zombie_moonTunnels", "targetname");
	array_thread( moon_biodome_array, ::fog_trigger, ::moon_tunnels_fog_change);
	
	nml_array = GetEntArray( localClientNum, "zombie_nmlVision", "targetname" );
	if( IsDefined( nml_array ) && nml_array.size > 0 ) // don't break the level if they don't have a new BSP
	{
		array_thread( nml_array, ::fog_trigger, ::moon_nml_fog_change );
	}
	

}

//------------------------------------------------------------------------------
// .inside value to denote where:
// 0 = outside
// 1 = moonbase
// 2 = Biodome
// 3 = Tunnels
//------------------------------------------------------------------------------

fog_trigger(change_func)
{
	while(1)
	{
		self waittill("trigger", who);

		if(who IsLocalPlayer())
		{
			self thread trigger_thread( who, change_func);
		}
	}
}

Moon_Exterior_Fog_Change(Ent_Player)
{
	if(!isDefined(ent_player))
	{
		return;
	}
	local_clientnum = ent_player GetLocalClientNumber();
	
	ent_player endon("entityshutdown");

	// moon exterior (fog) settings
	
		start_dist = 2098.71;
		half_dist = 1740.12;
		half_height = 1332.23;
		base_height = 576.887;
		fog_r = 0.0196078;
		fog_g = 0.0235294;
		fog_b = 0.0352941;
		fog_scale = 4.1367;
		sun_col_r = 0.247;
		sun_col_g = 0.235;
		sun_col_b = 0.160;
		sun_dir_x = 0.796421;
		sun_dir_y = 0.425854;
		sun_dir_z = 0.429374;
		sun_start_ang = 0;
		sun_stop_ang = 55;
		time = 0;
		max_fog_opacity = 0.95;
	
		// correct vision set but won't remove the old visionsets.			
		// thread clientscripts\mp\zombies\_zm::zombie_vision_set_apply( level._moon_exterior_vision_set, level._moon_exterior_vision_set_priority, 1,local_clientnum );

		setClientVolumetricFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang,
		sun_stop_ang, time, max_fog_opacity);
		
		sunlight = 8;
		sundirection = (-16.28, 56.06, 0);
		suncolor = (0.655, 0.768, 0.817);
		
		SetSavedDvar( "r_lightTweakSunLight", sunlight );
		//t6todo SetSavedDvar( "r_lightTweakSunDirection", sundirection );
    //t6todo SetSavedDvar("sm_sunSampleSizeNear", "1.8");
    SetSavedDvar( "r_skyColorTemp", (6400));
    
		if( !IsDefined( ent_player._previous_vision ) )
		{
			ent_player._previous_vision = "zme";
		}
		
		new_vision = "zme"; // zombie_moon
		
		ent_player clientscripts\mp\zm_moon_fx::moon_vision_set( ent_player._previous_vision, new_vision, local_clientnum, self.script_int );
		
		ent_player._previous_vision = "zme";
      
    // VisionSetNaked(local_clientnum,"zombie_moon", 1);

}	

// moon interior fog change

moon_interior_fog_change(ent_player)
{
	if(!isDefined(ent_player))
	{
		return;
	}
	
	local_clientnum = ent_player GetLocalClientNumber();
	
	ent_player endon("entityshutdown");

			start_dist = 2098.71;
			half_dist = 1740.12;
			half_height = 1332.23;
			base_height = 576.887;
			fog_r = 0.0196078;
			fog_g = 0.0235294;
			fog_b = 0.0352941;
			fog_scale = 4.1367;
			sun_col_r = 0.247;
			sun_col_g = 0.235;
			sun_col_b = 0.160;
			sun_dir_x = 0.796421;
			sun_dir_y = 0.425854;
			sun_dir_z = 0.429374;
			sun_start_ang = 0;
			sun_stop_ang = 55;
			time = 0;
			max_fog_opacity = 0.95;
	
		setClientVolumetricFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang,
		sun_stop_ang, time, max_fog_opacity);

		// Correct visionset but won't get rid of the old one
		// thread clientscripts\mp\zombies\_zm::zombie_vision_set_apply( level._moon_interior_vision_set, level._moon_interior_vision_set_priority, 1,local_clientnum );

		sunlight = 8;
		sundirection = (-16.28, 56.06, 0);
		suncolor = (0.655, 0.768, 0.817);
		
		SetSavedDvar( "r_lightTweakSunLight", sunlight );
		//t6todo SetSavedDvar( "r_lightTweakSunDirection", sundirection );
		//t6todo SetSavedDvar("sm_sunSampleSizeNear", ".8");
		SetSavedDvar( "r_skyColorTemp", (6400));
		
		if( !IsDefined( ent_player._previous_vision ) )
		{
			ent_player._previous_vision = "zmi";
		}
		
		new_vision = "zmi"; // zombie_moonInterior
		
		ent_player clientscripts\mp\zm_moon_fx::moon_vision_set( ent_player._previous_vision, new_vision, local_clientnum, self.script_int );
		
		ent_player._previous_vision = "zmi";
		
    // VisionSetNaked(local_clientnum, "zombie_moonInterior", 1);

}

// moon Biodome fog/lighting change


moon_biodome_fog_change(ent_player)

{
	if(!isDefined(ent_player))
	{
		return;
	}
	
	local_clientnum = ent_player GetLocalClientNumber();
	
	ent_player endon("entityshutdown");

	
			start_dist = 65.3744;
			half_dist = 860.241;
			half_height = 35.1158;
			base_height = 116.637;
			fog_r = 0.117647;
			fog_g = 0.137255;
			fog_b = 0.101961;
			fog_scale = 2.96282;
			sun_col_r = 0.341176;
			sun_col_g = 0.231373;
			sun_col_b = 0.141176;
			sun_dir_x = 0.315232;
			sun_dir_y = 0.132689;
			sun_dir_z = -0.939693;
			sun_start_ang = 0;
			sun_stop_ang = 44.4323;
			time = 0;
			max_fog_opacity = 0.836437;
			
			
/*			

			Previous settings

			start_dist = 957.861;
			half_dist = 2964.15;
			half_height = 278.646;
			base_height = 1035.58;
			fog_r = 0.180392;
			fog_g = 0.243137;
			fog_b = 0.164706;
			fog_scale = 5.03993;
			sun_col_r = 0.180392;
			sun_col_g = 0.376471;
			sun_col_b = 0.341176;
			sun_dir_x = 0.796421;
			sun_dir_y = 0.425854;
			sun_dir_z = 0.429374;
			sun_start_ang = 0;
			sun_stop_ang = 50;
			time = 3;
			max_fog_opacity = 0.404906;
			
*/		
			
		setClientVolumetricFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang,
		sun_stop_ang, time, max_fog_opacity);

		// Wrong visionset being set here
		// thread clientscripts\mp\zombies\_zm::zombie_vision_set_apply( level._moon_interior_vision_set, level._moon_interior_vision_set_priority, 1,local_clientnum );

	  // Previous sun: sunlight = 7;
	   
	  sunlight = 1.13;
		sundirection = (-33.34, -38.56, 0);
		
	
		SetSavedDvar( "r_lightTweakSunLight", sunlight );
		//t6todo SetSavedDvar( "r_lightTweakSunDirection", sundirection );
		//t6todo SetSavedDvar("sm_sunSampleSizeNear", "2");
		
	//t6todo	SetSavedDvar( "r_sky_intensity_factor0", 2 );
	//t6todo	SetSavedDvar( "r_sky_intensity_useDebugValues", true );
	

		SetSavedDvar( "r_skyColorTemp", (3600)); 
		
		SetSavedDvar( "r_lightGridEnableTweaks", 1 );
		SetSavedDvar( "r_lightGridIntensity", 1.25 );
		SetSavedDvar( "r_lightGridContrast", .45 );
		
		if( !IsDefined( ent_player._previous_vision ) )
		{
			ent_player._previous_vision = "zmb";
		}
		
		new_vision = "zmb"; // zombie_moonBioDome
		
		ent_player clientscripts\mp\zm_moon_fx::moon_vision_set( ent_player._previous_vision, new_vision, local_clientnum, self.script_int );
		
		ent_player._previous_vision = "zmb";
    
   	// VisionSetNaked(local_clientnum, "zombie_moonBioDome", 1);
    
}


moon_tunnels_fog_change(ent_player)

{
	if(!isDefined(ent_player))
	{
		return;
	}
	
	local_clientnum = ent_player GetLocalClientNumber();
	
	ent_player endon("entityshutdown");

			
			start_dist = 1413.46;
			half_dist = 4300.81;
			half_height = 32.2476;
			base_height = -238.873;
			fog_r = 0.192157;
			fog_g = 0.137255;
			fog_b = 0.180392;
			fog_scale = 3.2984;
			sun_col_r = 0.34902;
			sun_col_g = 0.129412;
			sun_col_b = 0.219608;
			sun_dir_x = 0.954905;
			sun_dir_y = 0.280395;
			sun_dir_z = 0.0976461;
			sun_start_ang = 0;
			sun_stop_ang = 0;
			time = 0;
			max_fog_opacity = 0.22;

			
		setClientVolumetricFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang,
		sun_stop_ang, time, max_fog_opacity);
		
		if( !IsDefined( ent_player._previous_vision ) )
		{
			ent_player._previous_vision = "zmt";
		}
		
		new_vision = "zmt"; // zombie_moonTunnels
		
		ent_player clientscripts\mp\zm_moon_fx::moon_vision_set( ent_player._previous_vision, new_vision, local_clientnum, self.script_int );
		
		ent_player._previous_vision = "zmt";

		// Don't know why this is here but it would be setting the wrong visionset
		// thread clientscripts\mp\zombies\_zm::zombie_vision_set_apply( level._moon_interior_vision_set, level._moon_interior_vision_set_priority, 1,local_clientnum );
		
    // VisionSetNaked(local_clientnum, "zombie_moonTunnels", 3);
    
    
    SetSavedDvar( "r_skyColorTemp", (6400)); 
    
}


moon_nml_fog_change( ent_player )
{
	if( !IsDefined( ent_player ) || (IsDefined( level._dte_done ) && level._dte_done) )
	{
		return;
	}
	
	local_clientnum = ent_player GetLocalClientNumber();
	
	ent_player endon( "entityshutdown" );
	
	// No Man's Land Fog/Sun settings
		
	start_dist = 1662.13;
	half_dist = 18604.1;
	half_height = 2618.86;
	base_height = -5373.56;
	fog_r = 0.764706;
	fog_g = 0.505882;
	fog_b = 0.231373;
	fog_scale = 5;
	sun_col_r = 0.8;
	sun_col_g = 0.435294;
	sun_col_b = 0.101961;
	sun_dir_x = 0.796421;
	sun_dir_y = 0.425854;
	sun_dir_z = 0.429374;
	sun_start_ang = 0;
	sun_stop_ang = 45.87;
	time = 0;
	max_fog_opacity = 0.72;

   
	sunlight = 5;
	sundirection = (-16, 56.06, 0);
	suncolor = (.924, .775, .651);
		
	//t6todo SetSavedDvar("sm_sunSampleSizeNear", "1.18");
	
	if( !IsDefined( ent_player._previous_vision ) )
	{
		ent_player._previous_vision = "zmh";
	}
	
	new_vision = "zmh"; // zombie_moonHanger18
	
	ent_player clientscripts\mp\zm_moon_fx::moon_vision_set( ent_player._previous_vision, new_vision, local_clientnum, self.script_int );
	
	ent_player._previous_vision = "zmh";
	
	// VisionSetNaked(local_clientnum,"zombie_moonHanger18", 0);
	
	setClientVolumetricFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
	sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
	sun_stop_ang, time, max_fog_opacity);
			
//t6todo	setClientDvar( "r_lightTweakSunLight", sunlight);
//t6todo	setClientDvar(	"r_lightTweakSunColor", suncolor);
//t6todo	setClientDvar(	"r_lightTweakSunDirection", sundirection);
	SetSavedDvar( "r_skyColorTemp", (6400)); 
	
}

// sets the vision based on the trigger
// runs on player
moon_vision_set( str_vision_old, str_vision_new, int_clientnum, int_trans )
{

	if( str_vision_old == str_vision_new )
	{
		return; // no need to change the visionset since they are the same
	}

	
	if( IsDefined( str_vision_old ) ) // remove
	{
	//t6todo	remove_vision = clientscripts\mp\zm_moon::moon_vision_set_choice( str_vision_old );
		//T6todo clientscripts\mp\zombies\_zm::zombie_vision_set_remove( remove_vision[0], 0, int_clientnum );
	}
	
	if( IsDefined( int_trans ) )
	{
		trans_time = int_trans;
	}
	else
	{
		trans_time = 0;
	}
	
	// wait( 0.1 );
	
//t6todo	start_vision = clientscripts\mp\zm_moon::moon_vision_set_choice( str_vision_new );
	//T6todo clientscripts\mp\zombies\_zm::zombie_vision_set_apply( start_vision[0], start_vision[1], trans_time, int_clientnum );
	
	/#
	// PrintLn( "$$$$ " + start_vision[0] + " $$$$" );
	#/
}
