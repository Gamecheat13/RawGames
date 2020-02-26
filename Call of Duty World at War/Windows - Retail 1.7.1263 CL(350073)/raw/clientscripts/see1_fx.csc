//
// file: see1_fx.gsc
// description: clientside fx script for see1: setup, special fx functions, etc.
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


// --- Quinn'S SECTION ---//
precache_createfx_fx()
{
  level._effect["smoke_impact_smolder"]		      = loadfx ("env/smoke/fx_smoke_crater_w");
  
  level._effect["battlefield_smokebank_lg_white"]		= loadfx ("env/smoke/fx_battlefield_smokebank_ling_lg");
    
  level._effect["detail_fire"]	= loadfx ("env/fire/fx_fire_smoke_tree_brush_detail");
  level._effect["trunk_fire"]	= loadfx ("maps/see1/fx_fire_smoke_tree_trunk_small");
  level._effect["tree_trunk_fire"]	= loadfx ("maps/see1/fx_fire_smoke_tree_trunk_small");


  level._effect["headshot"] = LoadFX( "impacts/flesh_hit_head_fatal_exit" );
  level._effect["embers"] = LoadFX( "env/fire/fx_tree_fire_ash_embers" );
  level._effect["falling_ash_embers"] = LoadFX( "env/fire/fx_ash_embers_light" );
	level._effect["tree_brush_fire_small"]		= loadfx("env/fire/fx_fire_smoke_tree_brush_small_w");
	level._effect["tree_brush_fire"]		= loadfx("maps/see1/fx_fire_foliage_medium");
	level._effect["tree_brush_fire2"]		= loadfx("maps/see1/fx_fire_foliage_medium2");	
	level._effect["fire_foliage_large"]		= loadfx("maps/see1/fx_fire_foliage_large");
	level._effect["fire_foliage_medium"]		= loadfx("maps/see1/fx_fire_foliage_medium");	
	level._effect["fire_foliage_small"]		= loadfx("maps/see1/fx_fire_foliage_small");
	level._effect["fire_foliage_xsmall"]		= Loadfx("maps/see1/fx_fire_foliage_xsmall");	
	level._effect["fire_embers_patch1"]		= Loadfx("maps/see1/fx_fire_embers_patch1");
	level._effect["fire_embers_patch2"]		= loadfx("maps/see1/fx_fire_embers_patch2");
	level._effect["god_rays_large1"]		= loadfx("maps/see1/fx_god_ray_forest_1");
	level._effect["god_rays_large2"]		= loadfx("maps/see1/fx_god_ray_forest_2");
	level._effect["god_rays_small1"]		= loadfx("maps/see1/fx_light_god_rays_small");
	level._effect["god_rays_small2"]		= loadfx("maps/see1/fx_light_god_rays_small2");						
	level._effect["fire_ash_cloud"]		= Loadfx("maps/see1/fx_fire_ash_cloud");
	level._effect["fog_rolling_thick"]		= loadfx("maps/see1/fx_fog_rolling_thick");	
	level._effect["smoke_rolling_thick"]		= loadfx("maps/see1/fx_smoke_rolling_thick");			
	level._effect["fog_rolling_thin"]		= loadfx("maps/see1/fx_fog_rolling_thin");	
	level._effect["smoke_column1"]		= loadfx("maps/see1/fx_smoke_column");				
	level._effect["smoke_column2"]		= loadfx("maps/see1/fx_smoke_column2");
	level._effect["smoke_chimney"]		= loadfx("maps/see1/fx_smoke_chimney");	
	level._effect["dust_falling_medium"]		= loadfx("maps/see1/fx_dust_falling_medium_runner");	
	level._effect["dust_falling_medium2"]		= loadfx("maps/see1/fx_dust_falling_medium_runner2");			
	level._effect["smoke_column_forest"]		= loadfx("maps/see1/fx_smoke_column_forest");		
	level._effect["water_wake_small"]		= loadfx("maps/see1/fx_water_wake_small");					
	level._effect["water_splash_small"]		= loadfx("maps/see1/fx_water_splash_small");		
	level._effect["water_wake_flow"]		= loadfx("maps/see1/fx_water_wake_flow");
	level._effect["water_wake_flow2"]		= loadfx("maps/see1/fx_water_wake_flow2");		
	level._effect["water_wake_flow_subtle"]		= loadfx("maps/see1/fx_water_wake_flow_subtle");		
	level._effect["insects_swarm"]		= loadfx("maps/see1/fx_insects_swarm");			
	level._effect["smoke_ambiance_indoor"]		= loadfx("maps/see1/fx_smoke_ambiance_indoor");	
	level._effect["dust_specs_interior"]		= loadfx("maps/see1/fx_dust_specs_interior");	
	level._effect["d_light_small"]		= loadfx("maps/see1/fx_d_light_small");				
	
	// Exploders
	
// OPENING --------------------------------------------------------------------------

	level._effect["fx_explosion_door_blast"] = LoadFx( "maps/see1/fx_explosion_door_blast" );

	// flamethrower stuffs
	level._effect["character_fire_pain_sm"] = LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] = LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] = LoadFx( "env/fire/fx_fire_player_torso" );

	// farm house blown up
	level._effect["house_blow_up"] = LoadFx( "maps/see1/fx_explosion_tank_shell_med_house" );
	level._effect["house_blow_up_2"] = LoadFx( "maps/see1/fx_explosion_tank_shell_med_house2" );

	// Wheat field blow up
	level._effect["wheat_blow_up"] = LoadFx( "maps/see1/fx_explosion_tank_shell_med_wheat" );			
	
	// battlefield effects (Don't put too much or we'll go over particle limit)
	level._effect["battle_smoke_light"]		= loadfx("env/smoke/fx_battlefield_smokebank_low_thin");
	level._effect["battle_smoke_heavy"]		= loadfx("env/smoke/fx_battlefield_smokebank_low_thick");
	level._effect["tree_trunk_fire"]		= loadfx("maps/see1/fx_fire_smoke_tree_trunk_small");
	level._effect["tree_brush_fire"]		= loadfx("maps/see1/fx_fire_foliage_medium");
	level._effect["tree_brush_fire_large"]		= loadfx("maps/see1/fx_fire_foliage_large");	

	// Standard tank shell on dirt explosion
	level._effect["dirt_blow_up"] = LoadFx( "maps/see1/fx_explosion_tank_shell_med" );

	// Standard tank explosion
	level._effect["tank_blow_up"] = LoadFx( "maps/see1/fx_explosion_tank_shell_default" );
	
	level._effect["tank_smoke_column"] = LoadFX( "maps/see1/fx_smoke_column_tank_1" );
	
	level._effect["admin_sandbag_explode_large"]				= loadfx("maps/pel2/fx_sandbag_explosion_01_lg");
	level._effect["engine_smoke_heavy"]				= loadfx("env/smoke/fx_smoke_plume_md_fast_blk");
	level._effect["engine_smoke_light"]				= loadfx("env/smoke/fx_smoke_plume_sm_fast_blk");	
	
}


main()
{
	clientscripts\createfx\see1_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

