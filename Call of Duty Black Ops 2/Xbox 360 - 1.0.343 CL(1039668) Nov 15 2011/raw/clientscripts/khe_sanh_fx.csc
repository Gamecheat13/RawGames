//
// file: khe_sanh_fx.gsc
// description: clientside fx script for khe_sanh: setup, special fx functions, etc.
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


// --- BARRY'S SECTION ---//
precache_createfx_fx()
{
	level._effect["fx_ks_sand_blowing_sm"]	            = loadFX("maps/khe_sanh/fx_ks_sand_blowing_sm");
	level._effect["fx_ks_sand_blowing_lg"]	            = loadFX("maps/khe_sanh/fx_ks_sand_blowing_lg");
	level._effect["fx_ks_sand_blow_battle"]	            = loadFX("maps/khe_sanh/fx_ks_sand_blow_battle");		
	level._effect["fx_sand_windy_heavy_md"]						  = loadfx("env/weather/fx_sand_windy_heavy_md");	
	level._effect["fx_ks_ambient_aa_flak"]	            = loadFX("maps/khe_sanh/fx_ks_ambient_aa_flak");
	level._effect["fx_ks_b52_flying_contrails"]	        = loadFX("maps/khe_sanh/fx_ks_b52_flying_contrails");	
	level._effect["fx_ks_b52_fast_contrails"]	          = loadFX("maps/khe_sanh/fx_ks_b52_fast_contrails");				
	level._effect["fx_ks_lz_smoke"]	                    = loadFX("maps/khe_sanh/fx_ks_lz_smoke");
	level._effect["fx_ks_lz_smoke_scattered"]	          = loadFX("maps/khe_sanh/fx_ks_lz_smoke_scattered");						
	level._effect["fx_ks_smk_plume_sm_tall"]				    = LoadFX("maps/khe_sanh/fx_ks_smk_plume_sm_tall");	
	level._effect["fx_ks_smk_plume_md_tall"]				    = LoadFX("maps/khe_sanh/fx_ks_smk_plume_md_tall");
	level._effect["fx_ks_smk_plume_lg_tall"]				    = LoadFX("maps/khe_sanh/fx_ks_smk_plume_lg_tall");		
	level._effect["fx_ks_smk_hillside"]				          = LoadFX("maps/khe_sanh/fx_ks_smk_hillside");
	level._effect["fx_ks_smk_hillside_sm"]				      = LoadFX("maps/khe_sanh/fx_ks_smk_hillside_sm");		
	level._effect["fx_ks_smoldering_tree"]				      = LoadFX("maps/khe_sanh/fx_ks_smoldering_tree");							
	level._effect["fx_fire_md_fuel"]				            = LoadFX("env/fire/fx_fire_md_fuel");
	level._effect["fx_fire_line_xsm_thin"]				      = LoadFX("env/fire/fx_fire_line_xsm_thin");	
	level._effect["fx_ks_fire_line_sm"]				          = LoadFX("env/fire/fx_ks_fire_line_sm");	
	level._effect["fx_fire_detail_sm_nodlight"]				  = LoadFX("env/fire/fx_fire_detail_sm_nodlight");
	level._effect["fx_smolder_mortar_crater"]			      = LoadFX("env/fire/fx_smolder_mortar_crater");		
	level._effect["fx_ks_bunker_smk_ashes"]	            = loadFX("maps/khe_sanh/fx_ks_bunker_smk_ashes");	
	level._effect["fx_pow_insect_swarm"]	              = loadFX("maps/pow/fx_pow_insect_swarm");	
	level._effect["fx_ks_bunker_dust_md"]	              = loadFX("maps/khe_sanh/fx_ks_bunker_dust_md");
	level._effect["fx_dirt_crumble_tunnel_runner"]		  = LoadFX("env/dirt/fx_dirt_crumble_tunnel_runner");
	level._effect["fx_elec_burst_shower_lg_runner"]	    = LoadFX("env/electrical/fx_elec_burst_shower_lg_runner");
	level._effect["fx_ks_interior_motes"]	              = LoadFX("maps/khe_sanh/fx_ks_interior_motes");
	level._effect["fx_ks_jeep_exhaust"]	                = LoadFX("maps/khe_sanh/fx_ks_jeep_exhaust");		
	level._effect["fx_heli_dust_khe_sanh"]				      = LoadFX("vehicle/treadfx/fx_heli_dust_khe_sanh");
	level._effect["fx_grenadeexp_dirt"]				          = LoadFX("explosions/fx_grenadeexp_dirt");		
	
	level._effect["fx_ks_exit_glow_os"]	                = LoadFX("maps/khe_sanh/fx_ks_exit_glow_os");	
	level._effect["fx_ks_god_ray_os"]	                  = LoadFX("maps/khe_sanh/fx_ks_god_ray_os");																
		
	// Exploders
	level._effect["fx_ks_huey_landing"]	                = loadFX("maps/khe_sanh/fx_ks_huey_landing");
	level._effect["fx_ks_bowman_landing"]	              = loadFX("maps/khe_sanh/fx_ks_bowman_landing");		
	level._effect["fx_ks_apc_mortar_hit"]	              = loadFX("maps/khe_sanh/fx_ks_apc_mortar_hit");		
	level._effect["fx_ks_apc_crash"]	                  = loadFX("maps/khe_sanh/fx_ks_apc_crash");		
	level._effect["fx_ks_c130_crash"]	                  = loadFX("maps/khe_sanh/fx_ks_c130_crash");	
	level._effect["fx_ks_jeep_crash"]	                  = loadFX("maps/khe_sanh/fx_ks_jeep_crash");
	level._effect["fx_ks_jeep_windshield_event"]	      = loadFX("maps/khe_sanh/fx_ks_jeep_windshield_event");					
	level._effect["fx_ks_fall_on_grenade"]              = loadFX("maps/khe_sanh/fx_ks_fall_on_grenade");		
	level._effect["fx_ks_napalm_drop_dist"]				      = LoadFX("maps/khe_sanh/fx_ks_napalm_drop_dist");			
  level._effect["fx_ks_smk_napalm_md"]                = LoadFX("maps/khe_sanh/fx_ks_smk_napalm_md");
  level._effect["fx_ks_fire_sm"]                      = LoadFX("maps/khe_sanh/fx_ks_fire_sm"); 
	level._effect["fx_ks_napalm_trench_fire"]				    = LoadFX("maps/khe_sanh/fx_ks_napalm_trench_fire");
  level._effect["fx_ks_fougasse"]                     = LoadFX("maps/khe_sanh/fx_ks_fougasse"); 
  level._effect["fx_ks_mortar_shack_exp"]             = LoadFX("maps/khe_sanh/fx_ks_mortar_shack_exp"); 
  level._effect["fx_ks_bunker_exp"]                   = LoadFX("maps/khe_sanh/fx_ks_bunker_exp");       
  level._effect["fx_ks_trenchjump_dirt_edge"]         = LoadFX("env/dirt/fx_ks_trenchjump_dirt_edge");
	level._effect["fx_ks_dirt_body_impact"]				      = LoadFX("env/dirt/fx_ks_dirt_body_impact"); 
	level._effect["fx_ks_napalm_drop"]				          = LoadFX("maps/khe_sanh/fx_ks_napalm_drop");		  
	level._effect["fx_ks_tent_dust"]				            = LoadFX("maps/khe_sanh/fx_ks_tent_dust");	
	level._effect["fx_ks_airburst_splinters"]				    = LoadFX("maps/khe_sanh/fx_ks_airburst_splinters");
	level._effect["fx_ks_tree_burst"]				            = LoadFX("maps/khe_sanh/fx_ks_tree_burst");			 
	level._effect["fx_ks_bunker_ceiling_dest"]				  = LoadFX("maps/khe_sanh/fx_ks_bunker_ceiling_dest");			
	level._effect["fx_ks_napalm_3_burst"]				        = LoadFX("maps/khe_sanh/fx_ks_napalm_3_burst");			
	level._effect["fx_ks_b52_exp_bomb"]				          = LoadFX("maps/khe_sanh/fx_ks_b52_exp_bomb");		
	level._effect["fx_ks_b52_pressure_wave"]				    = LoadFX("maps/khe_sanh/fx_ks_b52_pressure_wave");	
	level._effect["fx_ks_b52_pressure_wave_dirt"]				= LoadFX("maps/khe_sanh/fx_ks_b52_pressure_wave_dirt");		
	level._effect["fx_ks_b52_pressure_wave_hill"]				= LoadFX("maps/khe_sanh/fx_ks_b52_pressure_wave_hill");	
	level._effect["fx_ks_jeep_crash_debris"]				    = LoadFX("maps/khe_sanh/fx_ks_jeep_crash_debris");							    	
					   																					
}


main()
{
	precache_util_fx();
	precache_createfx_fx();
	
	clientscripts\createfx\khe_sanh_fx::main();
	clientscripts\_fx::reportNumEffects();

	
	disableFX = getdvarint( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

