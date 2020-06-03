#include maps\_utility;
main()
{
	precache_ambient_fx();
	precache_global_fx();
	precache_event1_fx();


	// Spawn the ambient effects
	maps\createfx\pel1a_fx::main();
	maps\createart\pel1a_art::main();
	//VisionSetNaked("pel1",1);
	//	setVolFog(100, 5500, 0, 3000, 0.4, 0.45, 0.47, 0);
	
	thread wind_settings();
}

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "-178 140 0" ); 
	SetSavedDvar( "wind_global_low_altitude", -500 );
	SetSavedDvar( "wind_global_hi_altitude", 1600 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.2 );


	// Add a while loop to vary the strength of the wind over time.
}

precache_ambient_fx()
{
//////////////////////////////////////////////////////////////////////////////////////
///////////////////////BARRYS SECTION	////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

	// For level._effect["X"]s, X can be whatever makes sense to the scripter. 
	// The loadfx() call needs to point to a valid effect, however.
	level._effect["smoke_plume_xlg_slow_blk_w"]			= loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk_w");
	//level._effect["smoke_plume_lg_low_gry_w"]		    = loadfx ("env/smoke/fx_smoke_plume_md_low_gry_w");
	level._effect["smoke_impact_smolder_w"]		      	= loadfx ("env/smoke/fx_smoke_crater_w");
	level._effect["battlefield_smokebank_lg_white_w"]	= loadfx ("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["battlefield_smokebank_sm_tan_w"]		= loadfx ("env/smoke/fx_battlefield_smokebank_ling_sm_w");
	level._effect["smoke_plume_sm_fast_blk_w"]			= loadfx ("env/smoke/fx_smoke_plume_sm_fast_blk_w");
	level._effect["smoke_xsm_detail_slow_gry_w"]		= loadfx ("env/smoke/fx_smoke_plume_xsm_detail_slow_gry_w");
	level._effect["fire_blown_md_blk_smk_w"]			= loadfx ("env/fire/fx_fire_blown_md_blk_smk_w");
	level._effect["small_fire_w"]						= loadfx ("env/fire/fx_fire_smoke_tree_brush_small_w");
	level._effect["tree_fire_w"]						= loadfx ("env/fire/fx_fire_smoke_tree_trunk_med_w");
	level._effect["detail_fire"]						= loadfx ("env/fire/fx_fire_smoke_tree_brush_detail");
	level._effect["bunker_dust_ceiling_ambient"]		= loadfx ("maps/pel1/fx_bunker_dust_ceiling_impact_ambient");
	level._effect["godray_lg"]							= loadfx ("env/light/fx_ray_sun_lrg");
	level._effect["godray_med"]							= loadfx ("env/light/fx_ray_sun_med");
	
  level._effect["smoke_impact_smolder"]		      = loadfx ("maps/pel1a/fx_smoke_crater_w");	
  level._effect["smoke_rolling_thick"]			= loadfx ("maps/pel1a/fx_smoke_rolling_thick");
  level._effect["smoke_rolling_thick2"]			= loadfx ("maps/pel1a/fx_smoke_rolling_thick2");	
  level._effect["detail_fire"]	= loadfx ("maps/pel1a/fx_fire_detail");	 
	level._effect["godray_small_short"]	= loadfx ("maps/pel1a/fx_godray_small_short");	
	level._effect["godray_large_short"]	= loadfx ("maps/pel1a/fx_godray_large_short");	
	level._effect["godray_small_short2"]	= loadfx ("maps/pel1a/fx_godray_small_short2"); 
	level._effect["heat_haze_medium"] = loadfx ("maps/pel1a/fx_heathaze_md");	
	level._effect["dust_kick_up_emitter"] = loadfx ("maps/pel1a/fx_dust_kick_up_emitter");	
	level._effect["dust_ambiance_tunnel"] = loadfx ("maps/pel1a/fx_dust_ambiance_tunnel");		    	
	
	level._effect["bomb_explosion"] = loadfx ("weapon/napalm/fx_napalmExp_lg_blk_smk_01");
	
	level._effect["fall_out_fx"]		= loadfx("maps/mak/fx_dust_and_leaves_kickup_small");	
	level._effect["sniper_leaf_loop"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf01");	
	level._effect["sniper_leaf_canned"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf02");
	
}

// Load some basic FX to play around with.
precache_global_fx()
{
	// For bloddy death
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );

	// FLAME AI FX
	level._effect["character_fire_pain_sm"] 		= LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] 		= LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] 	= LoadFx( "env/fire/fx_fire_player_torso" );
	
	// Mortar section
	maps\_mortar::set_mortar_delays( "dirt_mortar", 2, 5  );
	maps\_mortar::set_mortar_range( "dirt_mortar", 500, 5000 );

	level._effectType["dirt_mortar"]	 			= "mortar";
	level._effect["dirt_mortar"]					= LoadFx( "weapon/mortar/fx_mortar_exp_dirt_medium" );

	// Ceiling Dust for the dynamic mortars
	maps\_mortar::set_mortar_dust( "dirt_mortar", "ceiling_dust" );
	level._effect["ceiling_dust"]					= LoadFx("env/dirt/fx_dust_ceiling_impact_md_rocks");
	
	// Muzzleflash for the big artillery piece
	level._effect["model3_muzzle"]					= LoadFx("weapon/artillery/fx_artillery_jap_200mm");

	// Mortar muzzleflash when they launch a mortar
	level._effect["mortar_flash"]					= LoadFx( "weapon/mortar/fx_mortar_launch" );
	level.scr_sound["mortar_flash"]					="wpn_mortar_fire";

	// Tincan explosion
	level._effect["mg_tincan_explosion"]			= LoadFx( "maps/pel1/fx_metal_bunker_upward_explosion" );
	level._effect["mg_tunnel_explosion"]			= LoadFx( "env/fire/fx_fire_outward_burst" );
}

precache_event1_fx()
{
	// Plane explosion
	level._effect["plane_explosion"] 		= LoadFx( "vehicle/vexplosion/fx_Vexplode_plane_lg_mid_air" );
	level._effect["plane_trail"] 			= LoadFx( "trail/fx_trail_plane_smoke_fire_damage_long" );
	level._effect["plane_ground_explosion"] = LoadFx( "vehicle/vexplosion/fx_Vexplode_stuka_crash_ground" );
}   
