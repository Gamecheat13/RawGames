#include maps\_utility;
#include maps\see1_code;

main()
{
	
	maps\createart\see1_art::main();
//	thread vision_settings();	//added by rich 3/25 THIS IS NOW HANDLED BY see1_art.gsc
//	level thread cull_dist_adjustment();
	footsteps();
	precacheFX();
	spawnFX();
		
}

precacheFX()
{
	//////////////////////////////////////////////////////////////////////////////////////
	// Alex Section:

	level._effect["flesh_hit"]	= loadfx("impacts/flesh_hit");
	level._effect["headshot_hit"]	= loadfx("impacts/flesh_hit_head_fatal_exit");

	level._effect["distant_muzzleflash"]		=	loadfx("weapon/muzzleflashes/heavy");

	level._effect["flak_flash"] 	= loadfx("weapon/flak/fx_flak_cloudflash_night");
	level._effect["napalm"] 	= loadfx("weapon/napalm/fx_napalmExp_lg_blk_smk_01");

	level._effect["rifleflash"] = LoadFX( "weapon/muzzleflashes/rifleflash" );
	level._effect["rifle_shelleject"] = LoadFX( "weapon/shellejects/rifle" );
	level._effect["tank_smoke_column"] = LoadFX( "maps/see1/fx_smoke_column_tank_1" );

	//level._effect["plane_tracers"] = LoadFX( "weapon/tracer/fx_tracer_jap_tripple25_projectile" );
	level._effect["plane_tracers"] = LoadFX( "weapon/tracer/fx_tracer_flak_single_noExp" );

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

	level._effect["wheat_fire_medium"]	= loadfx("maps/see1/fx_fire_foliage_medium_3min");
	level._effect["wheat_fire_large"]	= loadfx("maps/see1/fx_fire_foliage_large_3min");
	level._effect["wheat_smoke"]		= loadfx("maps/see1/fx_smoke_column_3min");

	// dust effect from tank fire
	level._effect["tank_fire_dust"]		= loadfx("maps/see1/fx_treadfx_tank_dust_plume");

	level._effect["puddle"]		= loadfx("maps/see1/fx_water_ripple_large");

	level._effect["molotov_trail_fire"] = LoadFx( "weapon/molotov/fx_molotov_wick" );
	level._effect["molotov_explosion"] = LoadFx( "weapon/molotov/fx_molotov_exp" );
	level._effect["molotov_burn_trail_large"] = LoadFx( "weapon/molotov/fx_molotov_burn_trail2" );
	level._effect["molotov_burn_trail_small"] = LoadFx( "weapon/molotov/fx_molotov_burn_trail" );

// EVENT 1 --------------------------------------------------------------------------

	// Standard tank shell on dirt explosion
	level._effect["dirt_blow_up"] = LoadFx( "maps/see1/fx_explosion_tank_shell_med" );

	// Standard tank explosion
	level._effect["tank_blow_up"] = LoadFx( "maps/see1/fx_explosion_tank_shell_default" );

	level._effect["truck_fire_med"] = LoadFx( "maps/see1/fx_fire_truck_medium" );
	level._effect["truck_explosion_phys"] = LoadFx( "explosions/fx_lg_vehicle_exp_physics" );


// EVENT 2 --------------------------------------------------------------------------

	level._effect["rocket_trail"]		= loadfx("weapon/rocket/fx_trail_bazooka_geotrail");
	level._effect["shreck_explode"]		= loadfx("explosions/default_explosion");
// EVENT 3 --------------------------------------------------------------------------
	
	level._effect["admin_sandbag_explode_large"]				= loadfx("maps/pel2/fx_sandbag_explosion_01_lg");
	level._effect["engine_smoke_heavy"]				= loadfx("env/smoke/fx_smoke_plume_md_fast_blk");
	level._effect["engine_smoke_light"]				= loadfx("env/smoke/fx_smoke_plume_sm_fast_blk");



	level._vehicle_effect[ "t34" ][ "dirt" ]   = loadfx ("maps/see1/fx_treadfx_tank_dust_plume");


	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////Quinn Section	////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////

	SetSavedDvar( "wind_global_vector", "-200 0 0" );
	SetSavedDvar( "wind_global_low_altitude", -2000 );
	SetSavedDvar( "wind_global_hi_altitude", 2000 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.05 );


	// For level._effect["X"]s, X can be whatever makes sense to the scritper. 
	// The loadfx() call needs to point to a valid effect, however.

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
	level._effect["fire_foliage_xsmall"]		= loadfx("maps/see1/fx_fire_foliage_xsmall");	
	level._effect["fire_embers_patch1"]		= loadfx("maps/see1/fx_fire_embers_patch1");
	level._effect["fire_embers_patch2"]		= loadfx("maps/see1/fx_fire_embers_patch2");
	level._effect["god_rays_large1"]		= loadfx("maps/see1/fx_god_ray_forest_1");
	level._effect["god_rays_large2"]		= loadfx("maps/see1/fx_god_ray_forest_2");
	level._effect["god_rays_small1"]		= loadfx("maps/see1/fx_light_god_rays_small");	
	level._effect["god_rays_small2"]		= loadfx("maps/see1/fx_light_god_rays_small2");						
	level._effect["fire_ash_cloud"]		= loadfx("maps/see1/fx_fire_ash_cloud");
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
		
}

spawnFX()
{
	maps\createfx\see1_fx::main();
}    

footsteps()
{
	animscripts\utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "brick", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "carpet", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "cloth", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "dirt", LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "foliage", LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "gravel", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "grass", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "metal", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "mud", LoadFx( "bio/player/fx_footstep_mud" ) );
	animscripts\utility::setFootstepEffect( "paper", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "plaster", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "rock", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "water", LoadFx( "bio/player/fx_footstep_water" ) );
	animscripts\utility::setFootstepEffect( "wood", LoadFx( "bio/player/fx_footstep_dust" ) );
}

////////////////////////////////////////////////////////////////////////////////////////
///////////////////////Rich's Section/////////////////////////////////////////////////// THIS IS NOW HANDLED BY see1_art.gsc
////////////////////////////////////////////////////////////////////////////////////////
// vision_settings() 
// {
//	wait( 0.2 );
//	VisionSetNaked( "see1", 1 );// TODO change to per-client
//	setVolFog(1100, 4100, 1360, -448, 0.62, 0.59, 0.52, 0);
//
//	if( IsSplitScreen() )
//	{
//		cull_dist 		= 7000;
//		set_splitscreen_fog( 1100, 4100, 1360, -448, 0.62, 0.59, 0.52, 0, cull_dist );
//	}
//	else
//	{
//		setVolFog(1100, 4100, 1360, -448, 0.62, 0.59, 0.52, 0);
//	}
//}

cull_dist_adjustment()
{
	wait( 1 );
	trigger1 = getent( "cull_set_forest_trench", "targetname" ); // trench
	trigger2 = getent( "cull_set_forest_entrance", "targetname" );	// S curve

	current_cull = 15000;
	while( 1 )
	{
		if( any_player_touching( trigger1 ) )
		{
			if( current_cull != 5000 )
			{
				// set 5000
				SetCullDist( 5000 );
				current_cull = 5000;
				//iprintlnbold( 5000 );
			}
			wait( 0.5 );
		}
		else if( any_player_touching( trigger2 ) )
		{
			if( current_cull != 6000 )
			{
				// set 6000
				SetCullDist( 6000 );
				current_cull = 6000;
				//iprintlnbold( 6000 );
			}
			wait( 0.5 );
		}
		else
		{
			if( current_cull != 15000 )
			{
				// set 15000
				SetCullDist( 15000 );
				current_cull = 15000;
				//iprintlnbold( 15000 );
			}
			wait( 0.5 );
		}
	}
}