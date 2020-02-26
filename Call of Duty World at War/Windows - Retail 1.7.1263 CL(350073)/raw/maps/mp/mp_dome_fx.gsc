#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_dome_art::main();
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
	  level._effect["mp_battlesmoke_small"]							  = loadfx("maps/mp_maps/fx_mp_battlesmoke_thick_small_area");	
		level._effect["mp_fog_rolling_large"]							  = loadfx("maps/mp_maps/fx_mp_fog_rolling_thick_large_area");	
		level._effect["mp_fog_rolling_small"]							  = loadfx("maps/mp_maps/fx_mp_fog_rolling_thick_small_area");	
	  level._effect["mp_godray_white_large"]						  = loadfx("maps/mp_maps/fx_mp_godray_white_large");	
	  level._effect["mp_godray_white_xlarge"]						  = loadfx("maps/mp_maps/fx_mp_hangar_godray_white_large");			  
		level._effect["mp_godray_white_medium"]					    = loadfx("maps/mp_maps/fx_mp_godray_white_medium");	
		level._effect["mp_godray_white_small"]						  = loadfx("maps/mp_maps/fx_mp_godray_white_small");	
	  level._effect["mp_godray_yellow_large"]						  = loadfx("maps/mp_maps/fx_mp_godray_yellow_large");	
		level._effect["mp_godray_yellow_medium"]					  = loadfx("maps/mp_maps/fx_mp_godray_yellow_medium");	
		level._effect["mp_godray_yellow_small"]						  = loadfx("maps/mp_maps/fx_mp_godray_yellow_small");	
	  level._effect["mp_smoke_ambiance_indoor"]					  = loadfx("maps/mp_maps/fx_mp_smoke_ambiance_indoor");	
		level._effect["mp_smoke_column_tall"]					      = loadfx("maps/mp_maps/fx_mp_smoke_column_tall");	
		level._effect["mp_smoke_column_short"]						  = loadfx("maps/mp_maps/fx_mp_smoke_column_short");		
	  level._effect["mp_smoke_ambiance_indoor_misty"]	    = loadfx("maps/mp_maps/fx_mp_smoke_ambiance_indoor_misty");	
	  level._effect["mp_light_glow_indoor_short"]		      = loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short");
	  level._effect["mp_water_splash_small"]		          = loadfx("maps/mp_maps/fx_mp_water_splash_small");
	  level._effect["mp_water_wake_flow"]		              = loadfx("maps/mp_maps/fx_mp_water_wake_flow");	
	  level._effect["mp_falling_leaves"]		              = loadfx("maps/mp_maps/fx_mp_falling_leaves_elm");	
  
	  
	  	 


	//////////////////////////////////////////////////////////////////////////////////////
	// Alex Section:

	//level._effect["distant_muzzleflash"]		=	loadfx("weapon/muzzleflashes/heavy");

	//level._effect["flak_flash"] 	= loadfx("weapon/flak/fx_flak_cloudflash_night");
		
}

spawnFX()
{
	if (( getdvar( "createfx" ) != "" ))
	{
		maps\mp\createfx\mp_dome_fx::main();
	}
}    

