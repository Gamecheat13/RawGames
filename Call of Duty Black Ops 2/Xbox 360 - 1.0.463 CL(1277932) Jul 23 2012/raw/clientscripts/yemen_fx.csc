//
// file: yemen_fx.gsc
// description: clientside fx script for yemen: setup, special fx functions, etc.
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


// --- FX DEPARTMENT SECTION ---//
precache_createfx_fx()
{
 // EXPLODERS //
 
 level._effect["fx_balcony_explosion"]			  = LoadFX( "maps/yemen/fx_balcony_explosion01"); // exploder 410
  
 level._effect["fx_bridge_explosion01"]       = LoadFX("maps/yemen/fx_bridge_explosion01"); // exploder 750
 level._effect["fx_wall_explosion01"]         = LoadFX("maps/yemen/fx_wall_explosion01"); // exploder 760
 level._effect["fx_wall_explosion02"]         = LoadFX("maps/yemen/fx_wall_explosion02"); // exploder 760
 
 level._effect["fx_ceiling_collapse01"]       = LoadFX("maps/yemen/fx_ceiling_collapse01"); // exploder 10330
 level._effect["fx_ceiling_collapse02"]       = LoadFX("maps/yemen/fx_ceiling_collapse02"); // exploder 10331
 
 level._effect["fx_shockwave01"]              = LoadFX("maps/yemen/fx_shockwave01"); // exploder 330
 
  level._effect["fx_yemen_rockpuff02_custom"] = LoadFX("maps/yemen/fx_yemen_rockpuff02_custom"); // exploder 10610
 level._effect["fx_yemen_rockpuff02"]         = LoadFX("maps/yemen/fx_yemen_rockpuff02"); // exploder 10611 & 10612
 
 level._effect["fx_yem_gascan_explo"]         = LoadFX("maps/yemen/fx_yem_gascan_explo");

 level._effect["fx_yem_elec_burst_fire_sm"]         = LoadFX("maps/yemen/fx_yem_elec_burst_fire_sm");
 level._effect["fx_yem_elec_burst_xsm"]         = LoadFX("maps/yemen/fx_yem_elec_burst_xsm");
 
  level._effect["fx_yem_dest_roof_impact"]    = LoadFX("maps/yemen/fx_yem_dest_roof_impact");
  level._effect["fx_yem_dest_wall_impact"]    = LoadFX("maps/yemen/fx_yem_dest_wall_impact");
  level._effect["fx_yem_dest_wall_vtol_tall"] = LoadFX("maps/yemen/fx_yem_dest_wall_vtol_tall");
  level._effect["fx_yem_vtol_ground_impact"]  = LoadFX("maps/yemen/fx_yem_vtol_ground_impact");
  level._effect["fx_yem_fire_column_lg"]      = LoadFX("maps/yemen/fx_yem_fire_column_lg");        
  level._effect["fx_yem_vfire_car_compact"]   = LoadFX("maps/yemen/fx_yem_vfire_car_compact");  
  level._effect["fx_vfire_t6_civ_car_compact"] = LoadFX("fire/fx_vfire_t6_civ_car_compact");   
  level._effect["fx_yem_dust_windy_sm"]       = LoadFX("maps/yemen/fx_yem_dust_windy_sm");           
 
 // END EXPLODERS //
 
 level._effect["fx_lensflare_exp_hexes_lg_red"]       = LoadFX("light/fx_lensflare_exp_hexes_lg_red");
 
 level._effect["fx_fireplace01"]            = LoadFX("maps/yemen/fx_fireplace01");
 level._effect["fx_yem_fire_detail"]        = LoadFX("maps/yemen/fx_yem_fire_detail"); 
 level._effect["fx_yem_god_ray_med_thin"]   = LoadFX("maps/yemen/fx_yem_god_ray_med_thin");  
 level._effect["fx_yem_god_ray_xlg"]        = LoadFX("maps/yemen/fx_yem_god_ray_xlg");
 level._effect["fx_yem_god_ray_stained"]    = LoadFX("maps/yemen/fx_yem_god_ray_stained");   
 level._effect["fx_yemen_dust01"]       = LoadFX("maps/yemen/fx_yemen_dust01");
 level._effect["fx_light_spot_yemen1"]           = LoadFX("maps/yemen/fx_light_spot_yemen1");
 level._effect["fx_light_spot_yemen2"]           = LoadFX("maps/yemen/fx_light_spot_yemen2");

 level._effect["fx_yemen_dustwind01"]       = LoadFX("maps/yemen/fx_yemen_dustwind01");
 level._effect["fx_yemen_smokewind01"]       = LoadFX("maps/yemen/fx_yemen_smokewind01");
 level._effect["fx_yemen_burningdrone02"]       = LoadFX("maps/yemen/fx_yemen_burningdrone02");
// level._effect["fx_yemen_burningfoliage01"]       = LoadFX("maps/yemen/fx_yemen_burningfoliage01");
 level._effect["fx_yemen_burningfoliage_custom01"]       = LoadFX("maps/yemen/fx_yemen_burningfoliage_custom01");

 level._effect["fx_yemen_rotorwash01"]       = LoadFX("maps/yemen/fx_yemen_rotorwash01");
 level._effect["fx_yemen_ash01"]       = LoadFX("maps/yemen/fx_yemen_ash01");

 level._effect["fx_yemen_dustyledge01"]       = LoadFX("maps/yemen/fx_yemen_dustyledge01");

 level._effect["fx_yemen_dustyledge03"]       = LoadFX("maps/yemen/fx_yemen_dustyledge03");
 level._effect["fx_yemen_dustyledge04"]       = LoadFX("maps/yemen/fx_yemen_dustyledge04");

 level._effect["fx_yemen_dustyledge06"]       = LoadFX("maps/yemen/fx_yemen_dustyledge06");
 level._effect["fx_yemen_leaves_blow01"]       = LoadFX("maps/yemen/fx_yemen_leaves_blow01");
 level._effect["fx_yemen_leaves_blow02"]       = LoadFX("maps/yemen/fx_yemen_leaves_blow02");
 level._effect["fx_yemen_mist01"]       = LoadFX("maps/yemen/fx_yemen_mist01");
 level._effect["fx_yemen_pcloud_dustfast01"]       = LoadFX("maps/yemen/fx_yemen_pcloud_dustfast01");
 level._effect["fx_yemen_pcloud_dustfast02"]       = LoadFX("maps/yemen/fx_yemen_pcloud_dustfast02");
 level._effect["fx_yemen_vistamist01"]       = LoadFX("maps/yemen/fx_yemen_vistamist01");
 level._effect["fx_yemen_vistamist02"]       = LoadFX("maps/yemen/fx_yemen_vistamist02");
 level._effect["fx_yemen_wake01"]       = LoadFX("maps/yemen/fx_yemen_wake01");
 level._effect["fx_yemen_smoldering01"]       = LoadFX("maps/yemen/fx_yemen_smoldering01");
 level._effect["fx_yemen_smoldering02"]       = LoadFX("maps/yemen/fx_yemen_smoldering02");
 level._effect["fx_yemen_crepuscular01"]       = LoadFX("maps/yemen/fx_yemen_crepuscular01");
 level._effect["fx_yemen_smokeflare01"]       = LoadFX("maps/yemen/fx_yemen_smokeflare01");
 level._effect["fx_firetorch01"]              = LoadFX("maps/yemen/fx_firetorch01");
 level._effect["fx_yem_smoke_pile"]           = LoadFX("maps/yemen/fx_yem_smoke_pile"); 
 
 level._effect["fx_insects_swarm_md_light"]											= loadfx("bio/insects/fx_insects_swarm_md_light");

 level._effect["fx_seagulls_circle_overhead"]							= loadfx("bio/animals/fx_seagulls_circle_overhead");
 level._effect["fx_insects_swarm_md_light"]								= loadfx("bio/insects/fx_insects_swarm_md_light");
 level._effect["fx_debris_papers"]													= loadfx("env/debris/fx_debris_papers");
 

 level._effect["fx_vtol_engine_burn2"]       = LoadFX("maps/yemen/fx_vtol_engine_burn2");

 level._effect["fx_lf_yemen_sun1"]													= loadfx("lens_flares/fx_lf_yemen_sun1");
 
 level._effect["fx_vtol_crash_impact1"]             = LoadFX("maps/yemen/fx_vtol_crash_impact1");
 level._effect["fx_vtol_crash_impact2"]             = LoadFX("maps/yemen/fx_vtol_crash_impact2");
 level._effect["fx_vtol_crash_dust1"]               = LoadFX("maps/yemen/fx_vtol_crash_dust1");
 level._effect["fx_yem_rotor_wash_morals"]          = LoadFX("maps/yemen/fx_yem_rotor_wash_morals");  
 level._effect["fx_yem_vtol_ground_impact_sm"]      = LoadFX("maps/yemen/fx_yem_vtol_ground_impact_sm"); 
 level._effect["fx_yem_explo_window"]               = LoadFX("maps/yemen/fx_yem_explo_window");        

 level._effect["fx_fire_line_xsm_thin"]             		= LoadFX("env/fire/fx_fire_line_xsm_thin");
 level._effect["fx_snow_windy_heavy_md_slow"]            = LoadFX("env/weather/fx_snow_windy_heavy_md_slow");
}

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
}*/


main()
{
	clientscripts\createfx\yemen_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

