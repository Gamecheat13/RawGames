//
// file: zm_transit_fx.gsc
// description: clientside fx script for mp_zombie_temp: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{

	level._effect["eye_glow"]				= LoadFx( "misc/fx_zombie_eye_single" ); 
	level._effect["blue_eyes"]                  = LoadFX( "maps/zombie/fx_zombie_eye_single_blue" );

	level._effect["headshot"]				= LoadFX( "impacts/fx_flesh_hit" );
	level._effect["headshot_nochunks"]		= LoadFX( "misc/fx_zombie_bloodsplat" );
	level._effect["bloodspurt"]				= LoadFX( "misc/fx_zombie_bloodspurt" );
	level._effect["animscript_gib_fx"]		= LoadFx( "weapon/bullet/fx_flesh_gib_fatal_01" ); 
	level._effect["animscript_gibtrail_fx"]	= LoadFx( "trail/fx_trail_blood_streak" ); 	



	//Buslights
	level._effect["fx_headlight"]                   = LoadFX("maps/zombie/fx_zmb_tranzit_bus_headlight");
	level._effect["fx_brakelight"]									= LoadFX("maps/zombie/fx_zmb_tranzit_bus_brakelights");
	level._effect["fx_emergencylight"]							= LoadFX("maps/zombie/fx_zmb_tranzit_bus_flashing_lights");
	level._effect["fx_turn_signal_right"]						= LoadFX("maps/zombie/fx_zmb_tranzit_bus_turnsignal_right");
	level._effect["fx_turn_signal_left"]						= LoadFX("maps/zombie/fx_zmb_tranzit_bus_turnsignal_left");
	level._effect["fx_busInsideLight"]					    = LoadFX("light/fx_vlight_zmb_bus_dome");	
	level._effect["fx_zbus_headlight_beam"]  		= LoadFx("light/fx_vlight_zmb_bus_headlight");	
	level._effect["fx_zbus_light_flood"]  			= LoadFx("light/fx_vlight_zmb_bus_headlight");		
	
	mode = getdvar("ui_gametype");
	if( mode == "zrace") 
	{
		level._effect["race_marker"]			= Loadfx("maps/zombie/fx_zmb_race_marker");	
		level._effect["race_soul_trail"] = loadfx("maps/zombie/fx_zmb_meat_trail_fireworks");
		level._effect["race_soul_trail_green"] = loadfx("maps/zombie/fx_zmb_race_fireworks_trail_green");
	}
	else if( mode == "zmeat")
	{
		level._effect["meat_glow3p"] = loadfx("maps/zombie/fx_zmb_meat_glow_3p");
	}
	
	
	// Lightning, Rain, Weather
//	level._effect["fx_rain_sys_heavy_windy_1"]		= loadfx("env/weather/fx_rain_sys_heavy_windy_1");
//	level._effect["fx_rain_sys_heavy_windy_2"]		= loadfx("env/weather/fx_rain_sys_heavy_windy_2");
//	level._effect["fx_rain_sys_heavy_windy_3"]		= loadfx("env/weather/fx_rain_sys_heavy_windy_3");
// 	level._effect["fx_lightning_flash_single_lg"]	= loadfx("env/weather/fx_lightning_flash_single_lg"); // 7001-7004
//	level._effect["fx_zbus_rain_player"]  			= LoadFx("maps/zombie_bus/fx_zbus_rain_player");
	
	// power panel
//	level._effect["power_bulb_green"] 				= loadfx("misc/fx_zombie_zapper_light_green");
//	level._effect["power_bulb_red"] 				= loadfx("misc/fx_zombie_zapper_light_red");
//	level._effect["power_bulb_yellow"] 				= loadfx("misc/fx_zombie_zapper_light_on");


}


precache_createfx_fx()
{
	level._effect["fx_insects_swarm_md_light"]	         = loadfx("bio/insects/fx_insects_swarm_md_light");
	level._effect["fx_zmb_tranzit_leaves_falling"]	     = loadfx("maps/zombie/fx_zmb_tranzit_leaves_falling");
	level._effect["fx_zmb_tranzit_flourescent_glow"]	   = loadfx("maps/zombie/fx_zmb_tranzit_flourescent_glow");
	level._effect["fx_zmb_tranzit_flourescent_dbl_glow"] = loadfx("maps/zombie/fx_zmb_tranzit_flourescent_dbl_glow");
	level._effect["fx_zmb_tranzit_depot_map_flicker"]    = loadfx("maps/zombie/fx_zmb_tranzit_depot_map_flicker");	
	level._effect["fx_zmb_tranzit_light_glow"]           = loadfx("maps/zombie/fx_zmb_tranzit_light_glow");			
	level._effect["fx_zmb_tranzit_light_depot_cans"]     = loadfx("maps/zombie/fx_zmb_tranzit_light_depot_cans");					
	level._effect["fx_zmb_tranzit_spark_int_runner"]     = loadfx("maps/zombie/fx_zmb_tranzit_spark_int_runner");			
	level._effect["fx_zmb_tranzit_spark_ext_runner"]     = loadfx("maps/zombie/fx_zmb_tranzit_spark_ext_runner");		
  level._effect["fx_zmb_fog_closet"] 		               = loadfx("fog/fx_zmb_fog_closet");			
  level._effect["fx_zmb_fog_lit_200"] 		             = loadfx("fog/fx_zmb_fog_lit_200");
  level._effect["fx_zmb_fog_light_600x600"] 		       = loadfx("fog/fx_zmb_fog_light_600x600");    
  level._effect["fx_zmb_fog_low_300x300"] 		         = loadfx("fog/fx_zmb_fog_low_300x300");
  level._effect["fx_zmb_fog_thick_600x600"] 		       = loadfx("fog/fx_zmb_fog_thick_600x600");	  			
  level._effect["fx_zmb_fog_thick_1200x600"] 		       = loadfx("fog/fx_zmb_fog_thick_1200x600");	
  level._effect["fx_zmb_fog_transition_600x600"]       = loadfx("fog/fx_zmb_fog_transition_600x600");	  	
  level._effect["fx_zmb_fog_transition_1200x600"]      = loadfx("fog/fx_zmb_fog_transition_1200x600");		
  level._effect["fx_zmb_fog_transition_1200x600_tall"] = loadfx("fog/fx_zmb_fog_transition_1200x600_tall");
  level._effect["fx_zmb_tranzit_smk_interior_md"]      = loadfx("maps/zombie/fx_zmb_tranzit_smk_interior_md");
  level._effect["fx_zmb_tranzit_smk_interior_heavy"]   = loadfx("maps/zombie/fx_zmb_tranzit_smk_interior_heavy");     	 		     
  level._effect["fx_zmb_ash_ember_1000x1000"] 		     = loadfx("maps/zombie/fx_zmb_ash_ember_1000x1000");	
  level._effect["fx_zmb_ash_ember_2000x1000"] 		     = loadfx("maps/zombie/fx_zmb_ash_ember_2000x1000");	 
  level._effect["fx_zmb_ash_windy_heavy_sm"] 		       = loadfx("maps/zombie/fx_zmb_ash_windy_heavy_sm");	  
  level._effect["fx_zmb_ash_windy_heavy_md"] 		       = loadfx("maps/zombie/fx_zmb_ash_windy_heavy_md");	  
  
  
  level._effect["fx_zmb_lava_detail"] 		             = loadfx("maps/zombie/fx_zmb_lava_detail");  
  level._effect["fx_zmb_lava_edge_50"] 		             = loadfx("maps/zombie/fx_zmb_lava_edge_50");    	  	
  level._effect["fx_zmb_lava_edge_100"] 		           = loadfx("maps/zombie/fx_zmb_lava_edge_100");
  level._effect["fx_zmb_lava_50x50_sm"] 	  	         = loadfx("maps/zombie/fx_zmb_lava_50x50_sm");	  	 
  level._effect["fx_zmb_lava_100x100"] 		             = loadfx("maps/zombie/fx_zmb_lava_100x100");	 
  level._effect["fx_zmb_lava_crevice_glow_50"]  		   = loadfx("maps/zombie/fx_zmb_lava_crevice_glow_50");	   
  level._effect["fx_zmb_lava_crevice_glow_100"] 		   = loadfx("maps/zombie/fx_zmb_lava_crevice_glow_100");	     
  level._effect["fx_zmb_tranzit_depot_lava_hole"] 	   = loadfx("maps/zombie/fx_zmb_tranzit_depot_lava_hole"); 
  level._effect["fx_zmb_tranzit_fire_med"]             = loadfx("maps/zombie/fx_zmb_tranzit_fire_med");  
  level._effect["fx_zmb_tranzit_smk_column_lrg"]       = loadfx("maps/zombie/fx_zmb_tranzit_smk_column_lrg"); 
  level._effect["fx_zmb_fire_med"]                     = loadfx("maps/zombie/fx_zmb_fire_med");    	    
   
  level._effect["fx_zmb_papers_windy_slow"] 		       = loadfx("maps/zombie/fx_zmb_papers_windy_slow"); 
  level._effect["fx_zmb_tranzit_god_ray_short_warm"] 	 = loadfx("maps/zombie/fx_zmb_tranzit_god_ray_short_warm");   
  
	level._effect["fx_zmb_tranzit_light_safety"]         = loadfx("maps/zombie/fx_zmb_tranzit_light_safety");	
	level._effect["fx_zmb_tranzit_light_safety_off"]     = loadfx("maps/zombie/fx_zmb_tranzit_light_safety_off");	 
	level._effect["fx_zmb_tranzit_bridge_dest"]           = loadfx("maps/zombie/fx_zmb_tranzit_bridge_dest");			 	        
	
	// Fog                                       
//	level._effect["fx_fog_ground_rising_md"] 	     = loadfx("env/smoke/fx_fog_ground_rising_md");
//	level._effect["fx_fog_rolling_ground_md"]      = loadfx("env/smoke/fx_fog_rolling_ground_md");
//	level._effect["fx_fog_large_slow"] 				     = loadfx("env/smoke/fx_fog_large_slow");
//	level._effect["fx_fog_lit_overhead"] 			     = loadfx("env/smoke/fx_fog_lit_overhead");
//	level._effect["fx_zbus_fog_barrier"] 			     = loadfx("maps/zombie_bus/fx_zbus_fog_barrier");	
                                                 
	// Fire -                                      
//	level._effect["fx_ash_embers_heavy"] 			     = loadfx("env/fire/fx_ash_embers_heavy");
//	level._effect["fx_ash_embers_light"] 			     = loadfx("env/fire/fx_ash_embers_light");
//	level._effect["fx_ash_embers_md"] 				     = loadfx("env/fire/fx_ash_embers_md");
//	level._effect["fx_embers_falling_md"] 		     = loadfx("env/fire/fx_embers_falling_md");
//	level._effect["fx_fire_md"] 					         = loadfx("env/fire/fx_fire_md");
//	level._effect["fx_fire_lg"] 					         = loadfx("env/fire/fx_fire_lg");
//	level._effect["fx_fire_lg_fuel"] 			  	     = loadfx("env/fire/fx_fire_lg_fuel");
//	level._effect["fx_fire_xlg_fuel"] 				     = loadfx("env/fire/fx_fire_xlg_fuel");
//	level._effect["fx_fire_debris_xsmall"] 		     = loadfx("env/fire/fx_fire_debris_xsmall");
//	level._effect["fx_zbus_fire_lg"] 				       = loadfx("maps/zombie_bus/fx_zbus_fire_lg");
//	level._effect["fx_zbus_fire_lg_tunnel"] 	     = loadfx("maps/zombie_bus/fx_zbus_fire_lg_tunnel");
//	level._effect["fx_zbus_fire_md"] 				       = loadfx("maps/zombie_bus/fx_zbus_fire_md");	
//	level._effect["fx_zbus_fire_sm"] 				       = loadfx("maps/zombie_bus/fx_zbus_fire_sm");	
                                                 
	// Lights -                                    
//	level._effect["fx_dlight_fire_glow"] 			     = loadfx("env/light/fx_dlight_fire_glow");
//	level._effect["fx_light_overhead"] 				     = loadfx("env/light/fx_light_overhead");
//	level._effect["fx_light_red_on_lg"] 			     = loadfx("env/light/fx_light_red_on_lg");
//	level._effect["fx_street_light"] 				       = loadfx("env/light/fx_street_light");
//	level._effect["fx_search_light_tower"] 		     = loadfx("env/light/fx_search_light_tower");
                                              
	//Weather                                      
//	level._effect["fx_zbus_rain_lg"]  				     = LoadFx("maps/zombie_bus/fx_zbus_rain_lg");
		
}


main()
{
	clientscripts\mp\createfx\zm_transit_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

/*
fog_settings()
{
	start_dist 			= 0;
	halfway_dist 		= 1500;
	halfway_height 		= 1739;
	base_height 		= 1020;
	red 				= 0.0;	
	green 				= 0.19;
	blue		 		= 0.26;
	trans_time			= 0;
	cull_dist 			= 6000;
	
	setClientVolumetricFog(start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	SetCullDist( cull_dist ); 
}
*/