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
	// Horse tread fx
	level._effect[ "horse_treadfx" ] = LoadFX( "vehicle/treadfx/fx_afgh_treadfx_horse_sand" );
		
	// Section 1
	
	
	//Section 2
	level._effect[ "explode_large_sand" ] = LoadFX( "explosions/fx_explosion_sand_lg" );
	level._effect[ "explode_mortar_sand" ] = LoadFX( "explosions/fx_mortarexp_sand" );
	level._effect[ "explode_grenade_sand" ] = LoadFX( "explosions/fx_grenadeexp_sand" );
	level._effect[ "fire_horse" ] = LoadFX( "maps/afghanistan/fx_afgh_horse_onfire_moving" );
	level._effect[ "aircraft_flares" ] = LoadFX( "vehicle/vexplosion/fx_heli_chaff_flares" );
	level._effect[ "sniper_glint" ] = LoadFX( "misc/fx_misc_sniper_scope_glint" );
	level._effect[ "cache_dmg" ] = LoadFX( "maps/afghanistan/fx_afgh_smk_weapon_cache" );
	level._effect[ "cache_dest" ] = LoadFX( "maps/afghanistan/fx_afgh_exp_weapon_cache" );
	level._effect[ "sniper_trail" ] = LoadFX( "maps/afghanistan/fx_afgh_bullet_trail_sniper" );
	level._effect[ "sniper_impact" ] = LoadFX( "weapon/bullet/fx_flesh_gib_fatal_01" );
	
	//Section 3
	level._effect[ "numbers_base" ] = LoadFX( "maps/afghanistan/fx_afgh_interrog_numbers_base" );
	level._effect[ "numbers_center" ] = LoadFX( "maps/afghanistan/fx_afgh_interrog_numbers_center" );
	level._effect[ "numbers_mid" ] = LoadFX( "maps/afghanistan/fx_afgh_interrog_numbers_mid" );
	
	level._effect[ "kickout_dust_impact" ] = LoadFX( "dirt/fx_dust_impact_plume_lg" );
	level._effect[ "truck_kickup_dust" ] = LoadFX( "maps/afghanistan/fx_afgh_cin_truck_kickup_dust" );
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["horse_wall_break"] = %fxanim_afghan_horses_wall_break_anim;
	level.scr_anim["fxanim_props"]["statue_crumble"] = %fxanim_afghan_statue_crumble_anim;
	level.scr_anim["fxanim_props"]["village_tower"] = %fxanim_afghan_village_tower_anim;
	level.scr_anim["fxanim_props"]["bridge01_break"] = %fxanim_afghan_rope_bridge01_anim;
	level.scr_anim["fxanim_props"]["bridge02_break"] = %fxanim_afghan_rope_bridge02_anim;
	level.scr_anim["fxanim_props"]["bridge01_long_break"] = %fxanim_afghan_rope_bridge_long01_anim;
	level.scr_anim["fxanim_props"]["bridge02_long_break"] = %fxanim_afghan_rope_bridge_long02_anim;
	level.scr_anim["fxanim_props"]["cliff_collapse"] = %fxanim_afghan_cliff_collapse_anim;
	level.scr_anim["fxanim_props"]["water_tower"] = %fxanim_afghan_water_tower_anim;
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

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "-172 28 0" );		// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);			// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 2775);			// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 1.0);	// change 0.5 to your desired wind strength percentage
}


main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	initModelAnims();	

	footsteps();

	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\afghanistan_fx::main();

	wind_initial_setting();
}

footsteps()
{
	LoadFX( "bio/player/fx_footstep_dust" );
	LoadFX( "bio/player/fx_footstep_dust" );
}
