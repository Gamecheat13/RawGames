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
	level._effect["fx_afgh_mirage_distant"]		        = LoadFX("maps/afghanistan/fx_afgh_mirage_distant");
	level._effect["fx_afgh_sand_ledge_sml"]		        = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_sml");				
	level._effect["fx_afgh_sand_ledge"]		            = LoadFX("maps/afghanistan/fx_afgh_sand_ledge");	
	level._effect["fx_afgh_sand_ledge_wide_distant"]  = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_wide_distant");		
	level._effect["fx_afgh_sand_windy_heavy_md"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_windy_heavy_md");	
	level._effect["fx_afgh_sandstorm_close_tall"]			= LoadFX("maps/afghanistan/fx_afgh_sandstorm_close_tall");		
	level._effect["fx_afgh_sandstorm_distant"]			  = LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant");
	level._effect["fx_afgh_sandstorm_distant_detail"]	= LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant_detail");	
	level._effect["fx_afgh_sandstorm_distant_lrg"]	  = LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant_lrg");	
	
	level._effect["fx_birds_circling"]				        = LoadFX("bio/animals/fx_birds_circling");	
	
	level._effect["fx_afgh_light_lamp"]	              = LoadFX("maps/afghanistan/fx_afgh_light_lamp");
	level._effect["fx_afgh_light_tinhat"]	            = LoadFX("maps/afghanistan/fx_afgh_light_tinhat");
	level._effect["fx_afgh_ceiling_dust_cavern"]	    = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_cavern");			
	level._effect["fx_afgh_ceiling_dust_tunnel"]	    = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_tunnel");							
	 
	// Fires and Smoke
	level._effect["fx_fire_sm_smolder"]				      = LoadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]				      = LoadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_smoke_building_xlg"]			    = LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");	

	// Exploders
	level._effect["fx_afgh_wall_edge_crumble"]			= LoadFX("maps/afghanistan/fx_afgh_wall_edge_crumble");
	level._effect["fx_afgh_ceiling_dust_tunnel_os"]	= LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_tunnel_os");			
	level._effect["fx_mortarexp_sand"]			        = LoadFX("explosions/fx_mortarexp_sand");		
	level._effect["fx_grenadeexp_sand"]			        = LoadFX("explosions/fx_grenadeexp_sand");	
	level._effect["fx_afgh_tower_explo"]	          = LoadFX("maps/afghanistan/fx_afgh_tower_explo");	
	level._effect["fx_afgh_interrog_numbers_amb"]	  = LoadFX("maps/afghanistan/fx_afgh_interrog_numbers_amb");		
	level._effect["fx_afgh_dest_bridge"]			      = LoadFX("maps/afghanistan/fx_afgh_dest_bridge");	
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

