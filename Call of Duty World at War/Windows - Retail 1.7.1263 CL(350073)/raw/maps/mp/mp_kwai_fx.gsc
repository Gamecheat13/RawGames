#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_kwai_art::main();
	precacheFX();
	spawnFX();
}

precacheFX()
{	
	level._effect["a_wtrfall_sm"]					          = loadfx("env/water/fx_wtrfall_sm");
	level._effect["a_wtrfall_splash_sm"]			      = loadfx("env/water/fx_wtrfall_splash_sm");
  level._effect["fx_mp_water_splash_med"]	        = loadfx("maps/mp_maps/fx_mp_water_splash_med");
  level._effect["fx_mp_water_spill"]	            = loadfx("maps/mp_maps/fx_mp_water_spill"); 
	level._effect["a_wtrfall_splash_sm_puddle"]	    = loadfx("env/water/fx_wtrfall_splash_sm_puddle");
	level._effect["a_wtrfall_md"]					          = loadfx("env/water/fx_wtrfall_md");
	level._effect["a_wtrfall_lg"]					          = loadfx("env/water/fx_wtrfall_lg");	
	level._effect["a_wtrfall_md_transparent"]			  = loadfx("env/water/fx_wtrfall_md_transparent");	
	level._effect["a_wtr_spill_sm"]					        = loadfx("env/water/fx_wtr_spill_sm");
	level._effect["a_wtr_spill_sm_int"]				      = loadfx("env/water/fx_wtr_spill_sm_int");
	level._effect["a_wtr_spill_sm_splash"]			    = loadfx("env/water/fx_wtr_spill_sm_splash");
	level._effect["a_wtr_spill_sm_splash_puddle"]	  = loadfx("env/water/fx_wtr_spill_sm_splash_puddle");
	level._effect["a_wtr_flow_sm"]					        = loadfx("env/water/fx_wtr_flow_sm");
	level._effect["a_wtr_flow_md"]					        = loadfx("env/water/fx_wtr_flow_md");
	level._effect["a_water_wake_flow_sm"]			      = loadfx("env/water/fx_water_wake_flow_sm");
	level._effect["a_water_wake_flow_md"]			      = loadfx("env/water/fx_water_wake_flow_md");
	level._effect["a_water_ripple"]					        = loadfx("env/water/fx_water_splash_ripple_puddle");
	level._effect["a_water_ripple_md"]				      = loadfx("env/water/fx_water_splash_ripple_puddle_med");
	level._effect["a_water_ripple_aisle"]			      = loadfx("env/water/fx_water_splash_ripple_puddle_aisle");
	level._effect["a_water_ripple_line"]			      = loadfx("env/water/fx_water_splash_ripple_line");
	level._effect["fx_rainbow"]			                = loadfx("env/weather/fx_rainbow");
  level._effect["a_water_rapids_med"]			        = loadfx("maps/mp_maps/fx_mp_water_rapids_med");
  level._effect["a_water_rapids_splash"]	        = loadfx("maps/mp_maps/fx_mp_water_rapids_splash");
  level._effect["a_water_rapids_wake"]			      = loadfx("maps/mp_maps/fx_mp_water_rapids_wake");
  level._effect["a_water_rapids_narrow"]			    = loadfx("maps/mp_maps/fx_mp_water_rapids_narrow");
	level._effect["a_rain_drip_cave_tunnel"]		    = loadfx("maps/oki2/fx_rain_drip_cave_tunnel");
	level._effect["fx_mp_dust_spill_delay"]			    = loadfx("maps/mp_maps/fx_mp_dust_spill_delay");
  level._effect["mp_fire_small_detail"]					  = loadfx("maps/mp_maps/fx_mp_fire_small_detail");	
	level._effect["mp_fire_small"]							    = loadfx("maps/mp_maps/fx_mp_fire_small");
	level._effect["mp_fire_medium"]							    = loadfx("maps/mp_maps/fx_mp_fire_medium");	
	level._effect["mp_fire_large"]							    = loadfx("maps/mp_maps/fx_mp_fire_large");
	level._effect["fx_mp_smoke_plume_sm_slow_def"]	= loadfx("maps/mp_maps/fx_mp_smoke_plume_sm_slow_def");
	level._effect["mp_smoke_column_short"]					= loadfx("maps/mp_maps/fx_mp_smoke_column_short");
	level._effect["mp_smoke_column_tall"]					  = loadfx("maps/mp_maps/fx_mp_smoke_column_tall");		
	level._effect["mp_light_glow_lantern"]		      = loadfx("maps/mp_maps/fx_mp_light_glow_lantern");
	level._effect["fx_mp_ray_sun_xsm_near"]         = loadfx("maps/mp_maps/fx_mp_ray_sun_xsm_near");  
	level._effect["fx_mp_flies_carcass"]            = loadfx("maps/mp_maps/fx_mp_flies_carcass");	
	level._effect["mp_insects_swarm"]							  = loadfx("maps/mp_maps/fx_mp_insect_swarm");
  level._effect["mp_insects_lantern"]							= loadfx("maps/mp_maps/fx_mp_insects_lantern");	
	level._effect["fx_mp_seagulls_circling"]        = loadfx("maps/mp_maps/fx_mp_seagulls_circling");
	level._effect["mp_falling_leaves_elm"]				  = loadfx("maps/mp_maps/fx_mp_falling_leaves_elm");	
	level._effect["fx_mp_water_shimmers"]	          = loadfx("maps/mp_maps/fx_mp_water_shimmers"); 
	level._effect["fx_mp_water_splash_mist"]	      = loadfx("maps/mp_maps/fx_mp_water_splash_mist");
	level._effect["fx_mp_water_fall_mist"]	        = loadfx("maps/mp_maps/fx_mp_water_fall_mist");	 	 
//	level._effect["fx_fog_low_tunnel"]	            = loadfx("maps/mp_maps/fx_fog_low_tunnel"); 
	level._effect["mp_fog_low_tunnel"]	            = loadfx("maps/mp_maps/fx_mp_fog_low_tunnel"); 
	level._effect["fx_water_edge_ripple"]				    = loadfx("maps/mp_maps/fx_water_edge_ripple"); 
	level._effect["fx_mp_water_spill"]	            = loadfx("maps/mp_maps/fx_mp_water_spill");	
	level._effect["fx_mp_water_spill_long"]	        = loadfx("maps/mp_maps/fx_mp_water_spill_long");	
	level._effect["fx_mp_seagulls_circling"]	      = loadfx("maps/mp_maps/fx_mp_seagulls_circling");	
	level._effect["fx_mp_water_fall_rapids"]	      = loadfx("maps/mp_maps/fx_mp_water_fall_rapids");	
	level._effect["fx_mp_wtr_splash"]	              = loadfx("maps/mp_maps/fx_mp_wtr_splash");	
	level._effect["mp_dragonflies"]                     = loadfx("bio/insects/fx_insects_dragonflies_ambient");								
}

spawnFX()
{
	maps\mp\createfx\mp_kwai_fx::main();
}