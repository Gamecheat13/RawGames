//
// file: flashpoint_fx.gsc
// description: clientside fx script for flashpoint: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{
}

// Scripted effects
precache_scripted_fx()
{
	//-- Damage FX for Enemy Hind
	level._effect["prop_smoke"] = LoadFX("vehicle/vfire/fx_vsmoke_hind_trail");
	
	//-- Damage FX for Inside Player Helicopter
	level._effect["panel_dmg_sm"] = LoadFX("maps/pow/fx_dmg_helo_panel_sm");
	level._effect["panel_dmg_md"] = LoadFX("maps/pow/fx_dmg_helo_panel_md");
	
	//-- Weather
//	level._effect["rain"] = LoadFX("maps/pow/fx_rain_pow");
}


// Ambient effects
precache_createfx_fx()
{
  level._effect["fx_pow_smoke_napalm_md"]           = LoadFX("maps/pow/fx_pow_smoke_napalm_md");		
  level._effect["fx_pow_smoke_napalm_xlg"]          = LoadFX("maps/pow/fx_pow_smoke_napalm_xlg");		
  level._effect["fx_pow_cloud_md"]                  = LoadFX("env/weather/fx_pow_cloud_md");
  level._effect["fx_pow_cloud_lg"]                  = LoadFX("env/weather/fx_pow_cloud_lg");
  level._effect["fx_pow_floating_wood"]             = LoadFX("maps/pow/fx_pow_floating_wood");
  level._effect["fx_leaves_falling_mangrove_lg"]    = LoadFX("env/foliage/fx_leaves_falling_mangrove_lg");     
  level._effect["fx_pow_waterfall_giant"]           = LoadFX("maps/pow/fx_pow_waterfall_giant");  
  
  level._effect["fx_water_river_wake_md"]           = LoadFX("env/water/fx_water_river_wake_md");  
  level._effect["fx_water_river_wake_lg"]           = LoadFX("env/water/fx_water_river_wake_lg");
  level._effect["fx_pow_river_wake_short"]          = LoadFX("maps/pow/fx_pow_river_wake_short");  
  level._effect["fx_pow_river_wake_thin"]           = LoadFX("maps/pow/fx_pow_river_wake_thin");   
  level._effect["fx_pow_waterfall_bottom"]          = LoadFX("maps/pow/fx_pow_waterfall_bottom");  
  level._effect["fx_water_conc_bridge_wake"]        = LoadFX("env/water/fx_water_conc_bridge_wake");  
  
  level._effect["fx_quag_birds_gen_right"]          = LoadFX("maps/quagmire/fx_quag_birds_gen_right");
  level._effect["fx_quag_birds_gen_left"]           = LoadFX("maps/quagmire/fx_quag_birds_gen_left"); 
	level._effect["fx_pow_insect_lamps"]	            = loadfx("maps/pow/fx_pow_insect_lamps");  
	level._effect["fx_pow_insect_swarm"]	             = loadfx("maps/pow/fx_pow_insect_swarm");
	level._effect["fx_pow_dragonfly"]	              	= loadfx("maps/pow/fx_pow_dragonfly");
	level._effect["fx_pow_godray_sm"]	              	= loadfx("maps/pow/fx_pow_godray_sm");	
	level._effect["fx_pow_godray_md"]	              	= loadfx("maps/pow/fx_pow_godray_md");
	level._effect["fx_pow_godray_lg"]	              	= loadfx("maps/pow/fx_pow_godray_lg");
	level._effect["fx_pow_ground_mist"]	            	= loadfx("maps/pow/fx_pow_ground_mist"); 
		
	level._effect["fx_pow_cave_bulb_light"]	       = loadfx("maps/pow/fx_pow_cave_bulb_light"); 	
	level._effect["fx_pow_cave_tinhat_light"]	     = loadfx("maps/pow/fx_pow_cave_tinhat_light"); 
	level._effect["fx_pow_cave_water_fall"]	       = loadfx("maps/pow/fx_pow_cave_water_fall"); 	
	level._effect["fx_pow_cave_water_fall_sm"]     = loadfx("maps/pow/fx_pow_cave_water_fall_sm"); 			
	level._effect["fx_pow_cave_water_splash"]	     = loadfx("maps/pow/fx_pow_cave_water_splash");
  level._effect["fx_pow_cave_water_wake"]	       = loadfx("maps/pow/fx_pow_cave_water_wake");
  level._effect["fx_pow_cave_water_wake_fast"]	 = loadfx("maps/pow/fx_pow_cave_water_wake_fast"); 
  level._effect["fx_pow_dust_motes_med"]	       = loadfx("maps/pow/fx_pow_dust_motes_med");      
  level._effect["fx_pow_tunnel_drip"]	           = loadfx("maps/pow/fx_pow_tunnel_drip"); 	    		 		
	level._effect["fx_pow_mist_tunnel"]	           = loadfx("maps/pow/fx_pow_mist_tunnel"); 	
	level._effect["fx_pow_cave_debris_falling"]	   = loadfx("maps/pow/fx_pow_cave_debris_falling");	
	
	level._effect["fx_pow_window_break"]	         = loadfx("maps/pow/fx_pow_window_break");
	level._effect["fx_pow_finale_explo"]	         = loadfx("maps/pow/fx_pow_finale_explo");					 							 		  		   	                    
 
// Exploders
  level._effect["pow_woodbridge_explo"]          = LoadFX("destructibles/fx_pow_woodbridge_explo"); 
  level._effect["pow_woodbridge_splash"]         = LoadFX("destructibles/fx_pow_woodbridge_splash");
  
 level._effect["exp_pressure_wave"]             = LoadFX("explosions/fx_exp_pressure_wave");
 level._effect["pow_fire_column_md"]            = LoadFX("maps/pow/fx_pow_fire_column_md"); 
 level._effect["pow_fire_column_lg"]            = LoadFX("maps/pow/fx_pow_fire_column_lg");
 level._effect["pow_fire_line_lg"]              = LoadFX("maps/pow/fx_pow_fire_line_lg"); 
 level._effect["pow_fire_fuel_sm"]              = LoadFX("maps/pow/fx_pow_fire_fuel_sm");   
 level._effect["pow_fire_fuel_lg"]              = LoadFX("maps/pow/fx_pow_fire_fuel_lg");  
  
 level._effect["pow_sam_cave_exp_sm"]           = LoadFX("maps/pow/fx_pow_sam_cave_exp_sm");
 level._effect["pow_cave_collapse_exp"]         = LoadFX("maps/pow/fx_pow_cave_collapse_exp");
 level._effect["pow_cave_collapse_smoke"]       = LoadFX("maps/pow/fx_pow_cave_collapse_smoke");      
 
 level._effect["fx_heli_dust_cockpit_view_1"]   = LoadFX("vehicle/treadfx/fx_heli_dust_cockpit_view_1");
  
 level._effect["fx_pow_ceiling_trapdoor_dust"]  = LoadFX("maps/pow/fx_pow_ceiling_trapdoor_dust");         
}


main()
{	
	precache_util_fx();
	precache_createfx_fx();
	
	clientscripts\createfx\pow_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	disableFX = getdvarint( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

