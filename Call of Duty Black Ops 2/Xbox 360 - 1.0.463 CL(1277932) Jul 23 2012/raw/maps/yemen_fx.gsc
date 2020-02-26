#include maps\_utility; 
#include common_scripts\utility;
#include maps\_anim;
#using_animtree("fxanim_props");

// fx used by util scripts
precache_util_fx()
{
}

// Scripted effects
precache_scripted_fx()
{
	//General
	level._effect["friendly_marker"]			  = LoadFX( "misc/fx_friendly_indentify01" );
	level._effect["quadrotor_marker"]			  = LoadFX( "misc/fx_friendly_indentify02" );
	level._effect["metalstorm_marker"]			= LoadFX( "misc/fx_friendly_indentify03" );
	level._effect["vtol_marker"]				    = LoadFX( "misc/fx_friendly_indentify04" );
	
	// This should already be loaded with the an94 weapon.
	level._effect["drone_weapon_flash"]			= LoadFX( "weapon/muzzleflashes/fx_muz_ar_flash_3p" );
	
	//Crashing VTOL
	level._effect["crashing_vtol"]				  = LoadFX( "maps/yemen/fx_vtol_exp1" );
	level._effect["explosion_midair_heli"] 	= LoadFX( "maps/yemen/fx_vtol_exp2" );
	level._effect["explosion_midair_heli_engine1"] 	= LoadFX( "maps/yemen/fx_vtol_engine_burn1" );
	
	//Terrorist Hunt
	level._effect["fx_yem_gascan_explo"]	= LoadFX( "maps/yemen/fx_yem_gascan_explo" );
	level._effect["th_gaspipe_exp"]				= LoadFX( "maps/yemen/fx_gaspipe_explosion01" );
	level._effect["th_generator_exp"]			= LoadFX( "maps/yemen/fx_yem_elec_burst_fire_sm" );
	level._effect["th_pipe_steam"]				= LoadFX( "maps/yemen/fx_pipes_spraying01" );
	level._effect["th_rpgammo_exp"]				= LoadFX( "maps/yemen/fx_rpg_explosion01" );
	level._effect["th_wires_sparking"]			= LoadFX( "maps/yemen/fx_yem_elec_burst_xsm" );
	
	//Metal Storm
	level._effect["balcony_explosion"]			= LoadFX( "maps/yemen/fx_balcony_explosion01" );
	level._effect["balcony_debris_atplayer"]	= LoadFX( "maps/yemen/fx_debris_atplayer" );
	
	//Morals
	level._effect["vtol_attack_explosion"]		= LoadFX( "explosions/fx_grenadeexp_concrete" );
	level._effect["morals_rocket_trail" ]		= LoadFX( "maps/yemen/fx_yem_rocket_trail" );
	level._effect["morals_rocket_exp" ]			= LoadFX( "explosions/fx_exp_anti_tank_mine" );
	
	//Hijacked
	level._effect["quadrotor_crash"]            = LoadFX("destructibles/fx_quadrotor_crash01");
	
	//Capture
	level._effect["flesh_hit"]		            = LoadFX("impacts/fx_flesh_hit");
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["vtol1_crash"] = %fxanim_yemen_vtol1_crash_anim;
	level.scr_anim["fxanim_props"]["canopy_collapse"] = %fxanim_yemen_market_canopy_collapse_anim;
	level.scr_anim["fxanim_props"]["ceiling_collapse"] = %fxanim_yemen_ceiling_collapse_anim;
	level.scr_anim["fxanim_props"]["bridge_explode"] = %fxanim_yemen_bridge_explode_anim;
	level.scr_anim["fxanim_props"]["bridge_explode_02"] = %fxanim_yemen_bridge_explode_02_anim;
	level.scr_anim["fxanim_props"]["bridge_drop"] = %fxanim_yemen_bridge_drop_anim;
	level.scr_anim["fxanim_props"]["vtol2_crash"] = %fxanim_yemen_vtol2_crash_anim;
	level.scr_anim["fxanim_props"]["balcony_courtyard"] = %fxanim_yemen_balcony_courtyard_anim;
	level.scr_anim["fxanim_props"]["balcony_courtyard2"] = %fxanim_yemen_balcony_courtyard02_anim;
	level.scr_anim["fxanim_props"]["rock_slide"] = %fxanim_yemen_rock_slide_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_01"] = %fxanim_gp_seagull_circle_01_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_02"] = %fxanim_gp_seagull_circle_02_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_03"] = %fxanim_gp_seagull_circle_03_anim;
	level.scr_anim["fxanim_props"]["falling_rocks"] = %fxanim_yemen_falling_rocks_anim;
	level.scr_anim["fxanim_props"]["market_canopy"] = %fxanim_yemen_market_canopy_anim;
	level.scr_anim["fxanim_props"]["canopy_01"] = %fxanim_yemen_cloth_canopy01_anim;
	level.scr_anim["fxanim_props"]["canopy_02"] = %fxanim_yemen_cloth_canopy02_anim;
	level.scr_anim["fxanim_props"]["canopy_03"] = %fxanim_yemen_cloth_canopy03_anim;
	level.scr_anim["fxanim_props"]["canopy_04"] = %fxanim_yemen_cloth_canopy04_anim;
	level.scr_anim["fxanim_props"]["canopy_05"] = %fxanim_yemen_cloth_canopy05_anim;
	level.scr_anim["fxanim_props"]["canopy_06"] = %fxanim_yemen_cloth_canopy06_anim;
	level.scr_anim["fxanim_props"]["canopy_07"] = %fxanim_yemen_cloth_canopy07_anim;
	level.scr_anim["fxanim_props"]["canopy_08"] = %fxanim_yemen_cloth_canopy08_anim;
	level.scr_anim["fxanim_props"]["canopy_09"] = %fxanim_yemen_cloth_canopy09_anim;
	level.scr_anim["fxanim_props"]["canopy_10"] = %fxanim_yemen_cloth_canopy10_anim;
	level.scr_anim["fxanim_props"]["canopy_11"] = %fxanim_yemen_cloth_canopy11_anim;
	level.scr_anim["fxanim_props"]["canopy_12"] = %fxanim_yemen_cloth_canopy12_anim;
	level.scr_anim["fxanim_props"]["canopy_13"] = %fxanim_yemen_cloth_canopy13_anim;
	level.scr_anim["fxanim_props"]["d_blood_fall01"] = %fxanim_yemen_tree_d_blood_fall01_anim;
	level.scr_anim["fxanim_props"]["d_blood_fall02"] = %fxanim_yemen_tree_d_blood_fall02_anim;
	level.scr_anim["fxanim_props"]["wire_coil"] = %fxanim_gp_wire_coil_01_anim;
	level.scr_anim["fxanim_props"]["awning_fast"] = %fxanim_gp_awning_store_mideast_fast_anim;
	level.scr_anim["fxanim_props"]["awning_xl"] = %fxanim_gp_awning_store_mideast_xl_anim;
	level.scr_anim["fxanim_props"]["tarp_white_stripe"] = %fxanim_gp_tarp_white_stripe_anim;
	level.scr_anim["fxanim_props"]["banner_menendez"] = %fxanim_yemen_banner_menendez_anim;		
}

// --- FX DEPARTMENT SECTION ---//
precache_createfx_fx()
{
 // EXPLODERS //
 
 level._effect["fx_balcony_explosion"]			     = LoadFX( "maps/yemen/fx_balcony_explosion01"); // exploder 410
  
 level._effect["fx_bridge_explosion01"]          = LoadFX("maps/yemen/fx_bridge_explosion01"); // exploder 750
 level._effect["fx_wall_explosion01"]            = LoadFX("maps/yemen/fx_wall_explosion01"); // exploder 760
 level._effect["fx_wall_explosion02"]            = LoadFX("maps/yemen/fx_wall_explosion02"); // exploder 760
 
 level._effect["fx_ceiling_collapse01"]          = LoadFX("maps/yemen/fx_ceiling_collapse01"); // exploder 10330
 level._effect["fx_ceiling_collapse02"]          = LoadFX("maps/yemen/fx_ceiling_collapse02"); // exploder 10331
 
 level._effect["fx_shockwave01"]                 = LoadFX("maps/yemen/fx_shockwave01"); // exploder 330
 
  level._effect["fx_yemen_rockpuff02_custom"]    = LoadFX("maps/yemen/fx_yemen_rockpuff02_custom"); // exploder 10610
 level._effect["fx_yemen_rockpuff02"]            = LoadFX("maps/yemen/fx_yemen_rockpuff02"); // exploder 10611 & 10612
 
 level._effect["fx_gascontainer_explosion01"]    = LoadFX("maps/yemen/fx_gascontainer_explosion01");

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
 level._effect["fx_yemen_dust01"]           = LoadFX("maps/yemen/fx_yemen_dust01");
 level._effect["fx_light_spot_yemen1"]           = LoadFX("maps/yemen/fx_light_spot_yemen1");
 level._effect["fx_light_spot_yemen2"]           = LoadFX("maps/yemen/fx_light_spot_yemen2");

 level._effect["fx_vtol_crash_impact1"]       = LoadFX("maps/yemen/fx_vtol_crash_impact1");
 level._effect["fx_vtol_crash_impact2"]       = LoadFX("maps/yemen/fx_vtol_crash_impact2");
 level._effect["fx_vtol_crash_dust1"]       = LoadFX("maps/yemen/fx_vtol_crash_dust1");
 level._effect["fx_yem_rotor_wash_morals"]       = LoadFX("maps/yemen/fx_yem_rotor_wash_morals");  
 level._effect["fx_yem_vtol_ground_impact_sm"]       = LoadFX("maps/yemen/fx_yem_vtol_ground_impact_sm");   
 level._effect["fx_yem_explo_window"]               = LoadFX("maps/yemen/fx_yem_explo_window");       

 level._effect["fx_yemen_dustwind01"]       = LoadFX("maps/yemen/fx_yemen_dustwind01");
 level._effect["fx_yemen_smokewind01"]       = LoadFX("maps/yemen/fx_yemen_smokewind01");
 level._effect["fx_yemen_burningdrone02"]       = LoadFX("maps/yemen/fx_yemen_burningdrone02");
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
 level._effect["fx_firetorch01"]       = LoadFX("maps/yemen/fx_firetorch01");
 level._effect["fx_yem_smoke_pile"]       = LoadFX("maps/yemen/fx_yem_smoke_pile");  
 
 level._effect["fx_insects_swarm_md_light"]											= loadfx("bio/insects/fx_insects_swarm_md_light");

 level._effect["fx_seagulls_circle_overhead"]							= loadfx("bio/animals/fx_seagulls_circle_overhead");
 level._effect["fx_insects_swarm_md_light"]								= loadfx("bio/insects/fx_insects_swarm_md_light");
 level._effect["fx_debris_papers"]													= loadfx("env/debris/fx_debris_papers");
 
 level._effect["fx_vtol_engine_burn1"]       = LoadFX("maps/yemen/fx_vtol_engine_burn1");
 level._effect["fx_vtol_engine_burn2"]       = LoadFX("maps/yemen/fx_vtol_engine_burn2");


 level._effect["fx_lf_yemen_sun1"]													= loadfx("lens_flares/fx_lf_yemen_sun1");

 level._effect["fx_fire_line_xsm_thin"]             		= LoadFX("env/fire/fx_fire_line_xsm_thin");
 level._effect["fx_snow_windy_heavy_md_slow"]            = LoadFX("env/weather/fx_snow_windy_heavy_md_slow");
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "-172 28 0" );			// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 2775);					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5);	// change 0.5 to your desired wind strength percentage
}

main()
{
	initModelAnims();
	precache_util_fx();
	precache_scripted_fx();
	precache_createfx_fx();

	footsteps();

	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\yemen_fx::main();

	wind_initial_setting();
}

footsteps()
{
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
}

//*************************************************
//	CREATEFX
//*************************************************
createfx_setup()
{
// TODO: Need to define all scene anims so the ents used in them don't get deleted.

	// Since we're not doing the full init, just set the skipto name
	level.skipto_point = ToLower( GetDvar( "skipto" ) );
	if ( level.skipto_point == "" )
	{
		level.skipto_point = "speech";
	}
	
	maps\yemen_utility::load_gumps();
}
