#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_kneedeep_art::main();
	precacheFX();
	spawnFX();
}

precacheFX()
{
		level._effect["mp_fire_small_detail"]						    = loadfx("maps/mp_maps/fx_mp_fire_small_detail");	
		level._effect["mp_fire_small"]							        = loadfx("maps/mp_maps/fx_mp_fire_small");		  
		level._effect["mp_fire_medium"]							        = loadfx("maps/mp_maps/fx_mp_fire_medium");	
		level._effect["mp_fire_large"]							        = loadfx("maps/mp_maps/fx_mp_fire_large");	
	  level._effect["mp_fire_tree_trunk"]							    = loadfx("maps/mp_maps/fx_mp_fire_tree_trunk");	
		level._effect["mp_insects_swarm"]							      = loadfx("maps/mp_maps/fx_mp_insect_swarm");	
		level._effect["mp_battlesmoke_large"]							  = loadfx("maps/mp_maps/fx_mp_battlesmoke_thick_large_area");	
	  level._effect["mp_battlesmoke_small"]							  = loadfx("maps/mp_maps/fx_mp_battlesmoke_brown_thick_small_area");	
		level._effect["mp_fog_rolling_large"]							  = loadfx("maps/mp_maps/fx_mp_fog_rolling_thick_large_area");	
		level._effect["mp_fog_rolling_small"]							  = loadfx("maps/mp_maps/fx_mp_fog_rolling_thick_small_area");				
	  level._effect["mp_smoke_ambiance_indoor"]					  = loadfx("maps/mp_maps/fx_mp_smoke_ambiance_indoor");	
		level._effect["mp_smoke_column_tall"]					      = loadfx("maps/mp_maps/fx_mp_smoke_column_tall");	
		level._effect["mp_smoke_column_short"]						  = loadfx("maps/mp_maps/fx_mp_smoke_column_short");		
	  level._effect["mp_smoke_ambiance_indoor_misty"]	    = loadfx("maps/mp_maps/fx_mp_smoke_ambiance_indoor_misty");	
	  level._effect["mp_light_glow_indoor_short"]		      = loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short");	
	  level._effect["mp_water_splash_small"]		          = loadfx("maps/mp_maps/fx_mp_water_splash_small");
	  level._effect["mp_water_wake_flow"]		              = loadfx("maps/mp_maps/fx_mp_water_wake_flow");	
	  level._effect["mp_light_glow_lantern"]		          = loadfx("maps/mp_maps/fx_mp_light_glow_lantern");
	  level._effect["mp_falling_leaves_elm"]		          = loadfx("maps/mp_maps/fx_mp_falling_leaves_elm");		
	  level._effect["mp_fire_rubble_small_column_smldr"]	= loadfx("maps/mp_maps/fx_mp_fire_rubble_small_column_smldr");
	  level._effect["smoke_chimney_med"]	                = loadfx("maps/mak/fx_smoke_chimney_med");
	  level._effect["fx_mp_electric_sparks"]	            = loadfx("maps/mp_maps/fx_mp_electric_sparks");
    level._effect["fx_mp_water_wake_flow_slow"]         = loadfx("maps/mp_maps/fx_mp_water_wake_flow_slow");
    level._effect["fx_mp_seagulls_circling"]            = loadfx("maps/mp_maps/fx_mp_seagulls_circling");	  	  
    level._effect["fx_mp_flies_carcass"]                = loadfx("maps/mp_maps/fx_mp_flies_carcass");	
    level._effect["fx_mp_fire_window_smk_lf"]           = loadfx("maps/mp_maps/fx_mp_fire_window_smk_lf");
    level._effect["fx_mp_fire_column_xsm"]              = loadfx("maps/mp_maps/fx_mp_fire_column_close");   
    level._effect["fx_mp_fire_column_sm"]               = loadfx("maps/mp_maps/fx_mp_fire_column_sm"); 
    level._effect["fx_mp_fire_column_lg"]               = loadfx("maps/mp_maps/fx_mp_fire_column_lg");
    level._effect["fx_mp_smoke_brush_smolder_sm"]       = loadfx("maps/mp_maps/fx_mp_smoke_brush_smolder_sm");  
    level._effect["fx_mp_smoke_brush_smolder_md"]       = loadfx("maps/mp_maps/fx_mp_smoke_brush_smolder_md"); 
    level._effect["fx_mp_ray_sun_xsm"]                  = loadfx("maps/mp_maps/fx_mp_ray_sun_xsm");
    level._effect["fx_mp_ray_sun_md"]                   = loadfx("maps/mp_maps/fx_mp_ray_sun_md");
    level._effect["fx_mp_ray_sun_xsm_near"]             = loadfx("maps/mp_maps/fx_mp_ray_sun_xsm_near");          
    level._effect["fx_mp_embers_patch"]                 = loadfx("maps/mp_maps/fx_mp_embers_patch");
    level._effect["fx_mp_embers_patch_sm"]              = loadfx("maps/mp_maps/fx_mp_embers_patch_sm"); 
    level._effect["fx_mp_dlight_fire_glow"]             = loadfx("maps/mp_maps/fx_mp_dlight_fire_glow");
    level._effect["fx_mp_debris_hall_ash_embers_sm"]    = loadfx("maps/mp_maps/fx_mp_debris_hall_ash_embers_sm");
    level._effect["fx_mp_smoke_sm_slow"]                = loadfx("maps/mp_maps/fx_mp_smoke_sm_slow");                        	    		  
}

spawnFX()
{
	maps\mp\createfx\mp_kneedeep_fx::main();
}    

