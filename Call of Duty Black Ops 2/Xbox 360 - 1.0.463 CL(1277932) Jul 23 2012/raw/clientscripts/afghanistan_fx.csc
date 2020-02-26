//
// file: afghanistan_fx.gsc
// description: clientside fx script for afghanistan: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
}


// --- FX DEPT SECTION ---//
precache_createfx_fx()
{	
	// Ambient
	level._effect["fx_afgh_sandstorm_intro"]			    = LoadFX("maps/afghanistan/fx_afgh_sandstorm_intro");	
	level._effect["fx_afgh_mirage_distant"]		        = LoadFX("maps/afghanistan/fx_afgh_mirage_distant");
	level._effect["fx_afgh_sand_ledge_sml"]		        = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_sml");
	level._effect["fx_afgh_sand_ledge_sml_intro"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_sml_intro");						
//	level._effect["fx_afgh_sand_ledge"]		            = LoadFX("maps/afghanistan/fx_afgh_sand_ledge");	
	level._effect["fx_afgh_sand_ledge_wide_distant"]  = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_wide_distant");
  level._effect["fx_afgh_sand_windy_fast_md"]		    = LoadFX("maps/afghanistan/fx_afgh_sand_windy_fast_md");
	level._effect["fx_afgh_sand_windy_detail_sm"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_windy_detail_sm");				
	level._effect["fx_afgh_sand_windy_heavy_sm"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_windy_heavy_sm");			
	level._effect["fx_afgh_sand_windy_heavy_md"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_windy_heavy_md");
	level._effect["fx_afgh_sandstorm_close_intro"]			    = LoadFX("maps/afghanistan/fx_afgh_sandstorm_close_intro");		
	level._effect["fx_afgh_sandstorm_close_tall"]			= LoadFX("maps/afghanistan/fx_afgh_sandstorm_close_tall");		
	level._effect["fx_afgh_sandstorm_distant"]			  = LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant");
	level._effect["fx_afgh_sandstorm_distant_detail"]	= LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant_detail");	
	level._effect["fx_afgh_sandstorm_distant_lrg"]	  = LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant_lrg");	
	level._effect["fx_birds_circling"]				        = LoadFX("bio/animals/fx_birds_circling");	
	
	level._effect["fx_afgh_light_lamp"]	              = LoadFX("maps/afghanistan/fx_afgh_light_lamp");
	level._effect["fx_afgh_light_tinhat"]	            = LoadFX("maps/afghanistan/fx_afgh_light_tinhat");
	level._effect["fx_afgh_ceiling_dust_cavern"]	    = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_cavern");			
	level._effect["fx_afgh_ceiling_dust_tunnel"]	    = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_tunnel");
	level._effect["fx_afgh_steam_cook_pot"]	          = LoadFX("maps/afghanistan/fx_afgh_steam_cook_pot");					
	level._effect["fx_afgh_fire_cooking"]	            = LoadFX("maps/afghanistan/fx_afgh_fire_cooking");			

	level._effect["fx_afgh_spot_cave"] 					= LoadFX("light/fx_afgh_spot_cave");
	 
	// Fires and Smoke
	level._effect["fx_fire_sm_smolder"]				      = LoadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]				      = LoadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_smoke_building_xlg"]			    = LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");	

	// Exploders
	level._effect["fx_afgh_wall_edge_crumble"]			 = LoadFX("maps/afghanistan/fx_afgh_wall_edge_crumble");    
	level._effect["fx_afgh_ceiling_dust_tunnel_os"]	 = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_tunnel_os");			
	level._effect["fx_mortarexp_sand"]			         = LoadFX("explosions/fx_mortarexp_sand");		
	level._effect["fx_grenadeexp_sand"]			         = LoadFX("explosions/fx_grenadeexp_sand");	
	level._effect["fx_afgh_tower_explo"]	           = LoadFX("maps/afghanistan/fx_afgh_tower_explo");	 
	level._effect["fx_afgh_tower_explo_collide"]	   = LoadFX("maps/afghanistan/fx_afgh_tower_explo_collide");	
	level._effect["fx_afgh_interrog_numbers_amb"]	   = LoadFX("maps/afghanistan/fx_afgh_interrog_numbers_amb");	
	level._effect["fx_afgh_dest_bridge"]			       = LoadFX("maps/afghanistan/fx_afgh_dest_bridge");	
	level._effect["fx_afgh_cliff_explo"]	           = LoadFX("maps/afghanistan/fx_afgh_cliff_explo");		
	level._effect["fx_afgh_cliff_explo_grnd_impact"] = LoadFX("maps/afghanistan/fx_afgh_cliff_explo_grnd_impact");			
	level._effect["fx_afgh_water_tower_explo"]	     = LoadFX("maps/afghanistan/fx_afgh_water_tower_explo");		
	level._effect["fx_afgh_water_tower_impact"]	     = LoadFX("maps/afghanistan/fx_afgh_water_tower_impact");
	level._effect["fx_afgh_heli_cliff_impact"]	     = LoadFX("maps/afghanistan/fx_afgh_heli_cliff_impact");		
	level._effect["fx_afgh_heli_cliff_crash"]	       = LoadFX("maps/afghanistan/fx_afgh_heli_cliff_crash");				
	level._effect["fx_exp_afgh_heli_ground"]			   = LoadFX("explosions/fx_exp_afgh_heli_ground");	
	level._effect["fx_afgh_statue_explo"]	           = LoadFX("maps/afghanistan/fx_afgh_statue_explo");		
	level._effect["fx_afgh_statue_grnd_impact"]	     = LoadFX("maps/afghanistan/fx_afgh_statue_grnd_impact");		
	level._effect["fx_afgh_statue_grnd_impact_sm"]	 = LoadFX("maps/afghanistan/fx_afgh_statue_grnd_impact_sm");								
	level._effect["fx_afgh_explo_bp1_dome"]	         = LoadFX("maps/afghanistan/fx_afgh_explo_bp1_dome");
	level._effect["fx_afgh_mortar_launch_fake"]	     = LoadFX("maps/afghanistan/fx_afgh_mortar_launch_fake");				
	level._effect["fx_afgh_explo_wave_bp1_dome"]	   = LoadFX("maps/afghanistan/fx_afgh_explo_wave_bp1_dome");		
	level._effect["fx_afgh_time_lapse_clouds"]	     = LoadFX("maps/afghanistan/fx_afgh_time_lapse_clouds");	
	level._effect["fx_afgh_clouds"]                  = LoadFX("maps/afghanistan/fx_afgh_clouds");				
	level._effect["fx_afgh_time_lapse_sand"]	       = LoadFX("maps/afghanistan/fx_afgh_time_lapse_sand");	
	level._effect["fx_afgh_pulwar_spark"]	           = LoadFX("maps/afghanistan/fx_afgh_pulwar_spark");
	level._effect["fx_afgh_mortar_cook_off"]	       = LoadFX("maps/afghanistan/fx_afgh_mortar_cook_off");				
	level._effect["fx_afgh_pillar_fall"]	           = LoadFX("maps/afghanistan/fx_afgh_pillar_fall");
	level._effect["fx_afgh_cliff_crumble"]	         = LoadFX("maps/afghanistan/fx_afgh_cliff_crumble");						
	
	level._effect["fx_afgh_gas_cloud_lg"]	           = LoadFX("maps/afghanistan/fx_afgh_gas_cloud_lg");
	level._effect["fx_afgh_gas_cloud_lg_push"]	     = LoadFX("maps/afghanistan/fx_afgh_gas_cloud_lg_push");							
}


main()
{
	clientscripts\createfx\afghanistan_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

