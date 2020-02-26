//
// file: pel1_fx.gsc
// description: clientside fx script for pel1: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
	// csc side smoke
	level._effect["side_smoke"] = loadfx("maps/pel1/fx_smokebank_beach_xxlg");	
	
	// aaa muzzle flash
	level._effect["aaa_tracer"]				= loadfx ("Weapon/Tracer/fx_tracer_jap_tripple25_projectile");
	
	// japanese shooting from a distance
	level._effect["distant_muzzleflash"]		=	loadfx("weapon/tracer/fx_muz_distnt_lg_wrld");
	
	// flak in the air abive tracers
	level._effect["air_flak"] = loadfx("weapon/flak/fx_flak_field_8k_dist");
}


// --- BARRY'S SECTION ---//
precache_createfx_fx()
{
	level._effect["a_smoke_plume_xlg_slow_blk"] = loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk");
	level._effect["a_smoke_plume_xlg_slow_blk_tall"] = loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk_tall_w");
  level._effect["a_smk_column_lg_blk"]		    = loadfx ("env/smoke/fx_smk_column_lg_blk");
  level._effect["smoke_rolling_thick"]			= loadfx ("maps/pel1/fx_smoke_rolling_thick");
  level._effect["smoke_rolling_thick2"]			= loadfx ("maps/pel1/fx_smoke_rolling_thick2");
  level._effect["lingering_cliff_smoke_w"]	= loadfx ("env/smoke/fx_smoke_artillery_barrage_w");
  
  level._effect["smoke_impact_smolder"]		      = loadfx ("maps/pel1/fx_smoke_crater_w");
  
  level._effect["player_water_blood_cloud"]		    = loadfx ("env/water/fx_water_blood_cloud_player");	
  level._effect["med_water_blood_cloud"]					= loadfx ("env/water/fx_water_blood_cloud_256x256");
  level._effect["large_water_blood_cloud"]		    = loadfx ("env/water/fx_water_blood_cloud_512x512");
  level._effect["xlarge_water_blood_cloud"]		    = loadfx ("env/water/fx_water_blood_cloud_1024x1024");
  
  level._effect["detail_fire"]	= loadfx ("env/fire/fx_fire_rubble_detail");
  level._effect["small_fire"]	= loadfx ("env/fire/fx_fire_smoke_tree_brush_small_w");
  level._effect["med_fire"]	= loadfx ("env/fire/fx_fire_smoke_tree_brush_med_w");
  level._effect["trunk_fire"]	= loadfx ("env/fire/fx_fire_smoke_tree_trunk_med_w");
  
  level._effect["bunker_dust"]	= loadfx ("maps/pel1/fx_bunker_dust_ceiling_impact");
	level._effect["bunker_dust_ambient"]	= loadfx ("maps/pel1/fx_bunker_dust_ceiling_impact_ambient");
	
	level._effect["godray_small"]	= loadfx ("env/light/fx_ray_sun_small");
	level._effect["godray_small_short"]	= loadfx ("maps/pel1/fx_godray_small_short");
	level._effect["godray_small_short2"]	= loadfx ("maps/pel1/fx_godray_small_short2");
	
	level._effect["tide_splash_small"] = loadfx ("env/water/fx_water_splash_tide_small");
	level._effect["tide_splash_med"] = loadfx ("env/water/fx_water_splash_tide_med");
	level._effect["tide_splash_large"] = loadfx ("env/water/fx_water_splash_tide_lrg");
	
	level._effect["ash_and_embers"] = loadfx ("env/fire/fx_tree_fire_ash_embers");
	level._effect["large_fire_distant"] = loadfx ("env/fire/fx_fire_large_distant");
	level._effect["xlarge_fire_distant"] = loadfx ("env/fire/fx_fire_xlarge_distant");
	
	level._effect["heat_haze_medium"] = loadfx ("maps/pel1/fx_heathaze_md");	
	level._effect["ash_cloud_1"] = loadfx ("maps/pel1/fx_ash_cloud");	
	level._effect["dust_kick_up_emitter"] = loadfx ("maps/pel1/fx_dust_kick_up_emitter");
	level._effect["dust_ambiance_tunnel"] = loadfx ("maps/pel1/fx_dust_ambiance_tunnel");
}


main()
{
	clientscripts\createfx\pel1_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

