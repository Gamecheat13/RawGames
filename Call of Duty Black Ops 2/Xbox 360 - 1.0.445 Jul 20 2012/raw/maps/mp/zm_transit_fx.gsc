#include maps\mp\_utility; 

main()
{
	precache_createfx_fx();
	precache_scripted_fx();
	maps\mp\createfx\zm_transit_fx::main();
	maps\mp\createart\zm_transit_art::main();
}

precache_scripted_fx()
{
	level._effect["switch_sparks"]						= loadfx("env/electrical/fx_elec_wire_spark_burst");
	level._effect["zapper_light_ready"] 				= loadfx("maps/zombie/fx_zombie_zapper_light_green");
	level._effect["zapper_light_notready"] 				= loadfx("maps/zombie/fx_zombie_zapper_light_red");
	

	// TRAP: Fire
//	level._effect["fire_trap_med"] 						= Loadfx("maps/zombie/fx_zombie_fire_trap_med");

	//Magic Box
	level._effect["lght_marker"] 						  = Loadfx("maps/zombie/fx_zombie_coast_marker");
	level._effect["lght_marker_flare"] 				= Loadfx("maps/zombie/fx_zombie_coast_marker_fl");
	level._effect["poltergeist"]						  = LoadFx("misc/fx_zombie_couch_effect");
//	level._effect["powercell"] 							= loadfx("maps/zombie/fx_zombie_pack_a_punch_battery_glow");
	level._effect["zomb_gib"]							    = Loadfx( "maps/zombie/fx_zmb_tranzit_lava_torso_explo" );	
	
/*	
	PrecacheRumble( "explosion_generic" );
*/
	level._effect["fx_headlight"]                  = LoadFX("maps/zombie/fx_zmb_tranzit_bus_headlight");
	level._effect["fx_brakelight"]									= LoadFX("maps/zombie/fx_zmb_tranzit_bus_brakelights");
	level._effect["fx_emergencylight"]							= LoadFX("maps/zombie/fx_zmb_tranzit_bus_flashing_lights");
	level._effect["fx_turn_signal_right"]						= LoadFX("maps/zombie/fx_zmb_tranzit_bus_turnsignal_right");
	level._effect["fx_turn_signal_left"]						= LoadFX("maps/zombie/fx_zmb_tranzit_bus_turnsignal_left");
	level._effect["fx_busInsideLight"]					    = LoadFX("light/fx_vlight_zmb_bus_dome");
	level._effect["fx_zbus_headlight_beam"]  		= LoadFx("light/fx_vlight_zmb_bus_headlight");
	level._effect["fx_zbus_light_flood"]  			= LoadFx("light/fx_vlight_zmb_bus_headlight");	
	
	// For The Zapper
	level._effect["elec_md"] 						= loadfx("electrical/fx_elec_player_md");
	level._effect["elec_sm"] 						= loadfx("electrical/fx_elec_player_sm");
	level._effect["elec_torso"] 					= loadfx("electrical/fx_elec_player_torso");	
	
	// For The Teleporter
	level._effect["transporter_start"]				= loadfx("maps/zombie/fx_transporter_start");
			
	level._effect["blue_eyes"]                  = LoadFX( "maps/zombie/fx_zombie_eye_single_blue" );
	level._effect["lava_burning"]                  = LoadFX( "env/fire/fx_fire_lava_player_torso" );

	level._effect[ "screecher_portal" ]				= LoadFX( "maps/zombie/fx_zmb_blackhole_looping" );
}

precache_createfx_fx()
{
	level._effect["fx_insects_swarm_md_light"]				    = loadfx("bio/insects/fx_insects_swarm_md_light");
	level._effect["fx_zmb_tranzit_leaves_falling"]	      = loadfx("maps/zombie/fx_zmb_tranzit_leaves_falling");
	level._effect["fx_zmb_tranzit_flourescent_glow"]	    = loadfx("maps/zombie/fx_zmb_tranzit_flourescent_glow");
	level._effect["fx_zmb_tranzit_flourescent_dbl_glow"]  = loadfx("maps/zombie/fx_zmb_tranzit_flourescent_dbl_glow");
	level._effect["fx_zmb_tranzit_depot_map_flicker"]     = loadfx("maps/zombie/fx_zmb_tranzit_depot_map_flicker");		
	level._effect["fx_zmb_tranzit_light_glow"]            = loadfx("maps/zombie/fx_zmb_tranzit_light_glow");		
	level._effect["fx_zmb_tranzit_light_depot_cans"]      = loadfx("maps/zombie/fx_zmb_tranzit_light_depot_cans");										
	level._effect["fx_zmb_tranzit_spark_int_runner"]      = loadfx("maps/zombie/fx_zmb_tranzit_spark_int_runner");
	level._effect["fx_zmb_tranzit_spark_ext_runner"]      = loadfx("maps/zombie/fx_zmb_tranzit_spark_ext_runner");					
  level._effect["fx_zmb_fog_closet"] 		                = loadfx("fog/fx_zmb_fog_closet");		
  level._effect["fx_zmb_fog_lit_200"] 		              = loadfx("fog/fx_zmb_fog_lit_200");   
  level._effect["fx_zmb_fog_light_600x600"] 		        = loadfx("fog/fx_zmb_fog_light_600x600");	  	
  level._effect["fx_zmb_fog_low_300x300"] 		          = loadfx("fog/fx_zmb_fog_low_300x300");		
  level._effect["fx_zmb_fog_thick_600x600"] 		        = loadfx("fog/fx_zmb_fog_thick_600x600");		  	
  level._effect["fx_zmb_fog_thick_1200x600"] 		        = loadfx("fog/fx_zmb_fog_thick_1200x600");	
  level._effect["fx_zmb_fog_transition_600x600"]        = loadfx("fog/fx_zmb_fog_transition_600x600");	  	  	
  level._effect["fx_zmb_fog_transition_1200x600"]       = loadfx("fog/fx_zmb_fog_transition_1200x600");	
  level._effect["fx_zmb_fog_transition_1200x600_tall"]  = loadfx("fog/fx_zmb_fog_transition_1200x600_tall");
  level._effect["fx_zmb_tranzit_smk_interior_md"]       = loadfx("maps/zombie/fx_zmb_tranzit_smk_interior_md");  
  level._effect["fx_zmb_tranzit_smk_interior_heavy"]    = loadfx("maps/zombie/fx_zmb_tranzit_smk_interior_heavy");   		    
  level._effect["fx_zmb_ash_ember_1000x1000"] 		      = loadfx("maps/zombie/fx_zmb_ash_ember_1000x1000");		
  level._effect["fx_zmb_ash_ember_2000x1000"] 		      = loadfx("maps/zombie/fx_zmb_ash_ember_2000x1000");	
  level._effect["fx_zmb_ash_windy_heavy_sm"] 		        = loadfx("maps/zombie/fx_zmb_ash_windy_heavy_sm");	  
  level._effect["fx_zmb_ash_windy_heavy_md"] 		        = loadfx("maps/zombie/fx_zmb_ash_windy_heavy_md");	 
     
  level._effect["fx_zmb_lava_detail"] 		              = loadfx("maps/zombie/fx_zmb_lava_detail"); 
  level._effect["fx_zmb_lava_edge_50"] 		              = loadfx("maps/zombie/fx_zmb_lava_edge_50");	      
  level._effect["fx_zmb_lava_edge_100"] 		            = loadfx("maps/zombie/fx_zmb_lava_edge_100");	
  level._effect["fx_zmb_lava_50x50_sm"]   		          = loadfx("maps/zombie/fx_zmb_lava_50x50_sm");	   
  level._effect["fx_zmb_lava_100x100"] 		              = loadfx("maps/zombie/fx_zmb_lava_100x100");	 
  level._effect["fx_zmb_lava_crevice_glow_50"]  		    = loadfx("maps/zombie/fx_zmb_lava_crevice_glow_50");	  
  level._effect["fx_zmb_lava_crevice_glow_100"] 		    = loadfx("maps/zombie/fx_zmb_lava_crevice_glow_100");
  level._effect["fx_zmb_tranzit_depot_lava_hole"] 	    = loadfx("maps/zombie/fx_zmb_tranzit_depot_lava_hole"); 
  level._effect["fx_zmb_tranzit_fire_med"]              = loadfx("maps/zombie/fx_zmb_tranzit_fire_med"); 
  level._effect["fx_zmb_tranzit_smk_column_lrg"]        = loadfx("maps/zombie/fx_zmb_tranzit_smk_column_lrg");  
  level._effect["fx_zmb_fire_med"]                      = loadfx("maps/zombie/fx_zmb_fire_med");   	   		     
    
  level._effect["fx_zmb_papers_windy_slow"] 		        = loadfx("maps/zombie/fx_zmb_papers_windy_slow");
  level._effect["fx_zmb_tranzit_god_ray_short_warm"] 		= loadfx("maps/zombie/fx_zmb_tranzit_god_ray_short_warm");    
  
	level._effect["fx_zmb_tranzit_light_safety"]          = loadfx("maps/zombie/fx_zmb_tranzit_light_safety");	
	level._effect["fx_zmb_tranzit_light_safety_off"]      = loadfx("maps/zombie/fx_zmb_tranzit_light_safety_off");		     
	level._effect["fx_zmb_tranzit_bridge_dest"]           = loadfx("maps/zombie/fx_zmb_tranzit_bridge_dest");			   	         
           	
	// Fog 	
//	level._effect["fx_fog_ground_rising_md"] 		= loadfx("env/smoke/fx_fog_ground_rising_md");
//	level._effect["fx_fog_rolling_ground_md"] 		= loadfx("env/smoke/fx_fog_rolling_ground_md");
//	level._effect["fx_fog_large_slow"] 				= loadfx("env/smoke/fx_fog_large_slow");
//	level._effect["fx_fog_lit_overhead"] 			= loadfx("env/smoke/fx_fog_lit_overhead");
//	level._effect["fx_zbus_fog_barrier"] 			= loadfx("maps/zombie_bus/fx_zbus_fog_barrier");
	
	// Fire - 
//	level._effect["fx_ash_embers_heavy"] 			= loadfx("env/fire/fx_ash_embers_heavy");
//	level._effect["fx_ash_embers_light"] 			= loadfx("env/fire/fx_ash_embers_light");
//	level._effect["fx_ash_embers_md"] 				= loadfx("env/fire/fx_ash_embers_md");
//	level._effect["fx_embers_falling_md"] 			= loadfx("env/fire/fx_embers_falling_md");
//	level._effect["fx_fire_md"] 					= loadfx("env/fire/fx_fire_md");
//	level._effect["fx_fire_lg"] 					= loadfx("env/fire/fx_fire_lg");
//	level._effect["fx_fire_lg_fuel"] 				= loadfx("env/fire/fx_fire_lg_fuel");
//	level._effect["fx_fire_xlg_fuel"] 				= loadfx("env/fire/fx_fire_xlg_fuel");
//	level._effect["fx_fire_debris_xsmall"] 			= loadfx("env/fire/fx_fire_debris_xsmall");
//	level._effect["fx_fire_hut_wall_sm"] 			= loadfx("env/fire/fx_fire_hut_wall_sm");
//	level._effect["fx_fire_hut_wall_xsm"] 			= loadfx("env/fire/fx_fire_hut_wall_xsm");
//	level._effect["fx_fire_ceiling_md"] 			= loadfx("env/fire/fx_fire_ceiling_md");
//	level._effect["fx_zbus_fire_lg"] 				= loadfx("maps/zombie_bus/fx_zbus_fire_lg");
//	level._effect["fx_zbus_fire_lg_tunnel"] 		= loadfx("maps/zombie_bus/fx_zbus_fire_lg_tunnel");
//	level._effect["fx_zbus_fire_md"] 				= loadfx("maps/zombie_bus/fx_zbus_fire_md");	
//	level._effect["fx_zbus_fire_sm"] 				= loadfx("maps/zombie_bus/fx_zbus_fire_sm");
	

	// Lights - 
//	level._effect["fx_dlight_fire_glow"] 			= loadfx("env/light/fx_dlight_fire_glow");
//	level._effect["fx_light_overhead"] 				= loadfx("env/light/fx_light_overhead");
//	level._effect["fx_light_red_on_lg"] 			= loadfx("env/light/fx_light_red_on_lg");
//	level._effect["fx_street_light"] 				= loadfx("env/light/fx_street_light");
//	level._effect["fx_search_light_tower"] 			= loadfx("env/light/fx_search_light_tower");	
	
	//Weather
//	level._effect["fx_zbus_rain_lg"]  				= LoadFx("maps/zombie_bus/fx_zbus_rain_lg");
	
}
