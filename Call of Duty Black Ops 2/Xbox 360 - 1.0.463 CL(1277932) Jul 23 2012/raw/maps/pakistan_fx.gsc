#include maps\_utility;
#include common_scripts\utility;
#using_animtree("fxanim_props");

#insert raw\maps\pakistan.gsh;

main()
{
	initModelAnims();
	precache_scripted_fx();
	precache_createfx_fx();
	wind_init();
	footsteps();

	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\pakistan_fx::main();
}


// Scripted effects
precache_scripted_fx()
{
	level._effect[ "water_stop" ]						= LoadFx( "bio/player/fx_player_water_swim_ripple" );
	level._effect[ "water_movement" ]					= LoadFx( "bio/player/fx_player_water_swim_wake" );
	level._effect[ "water_loop" ] 						= LoadFX( "water/fx_water_pak_player_wake" );
	level._effect[ "frogger_wake_com_pallet_2" ]		= LoadFX( "water/fx_water_wake_com_pallet_2" );
	level._effect[ "helicopter_drone_spotlight" ] 		= LoadFX( "light/fx_vlight_firescout_spotlight" );
	level._effect[ "helicopter_drone_spotlight_cheap" ]	= LoadFX( "light/fx_vlight_firescout_spotlight_cheap" );
	level._effect[ "civ_car_headlight" ]				= LoadFX( "light/fx_vlight_headlight_foggy_default" );
	level._effect[ "frogger_car_interior_light" ]		= LoadFX( "light/fx_vlight_dome_civ_car_hatch" );
	level._effect[ "underwater_spotlight" ]				= LoadFX( "light/fx_pak_spotlight_caustics_os" );
	level._effect[ "cutter_on" ] 						= LoadFx("props/fx_laser_cutter_on");
	level._effect[ "cutter_spark" ] 					= LoadFx("props/fx_laser_cutter_sparking");
}

play_water_fx()  // self = AI
{
	n_client_flag = CLIENT_FLAG_WATER_FX;

	if ( IsPlayer( self ) )
	{
		n_client_flag = CLIENT_FLAG_WATER_FX_PLAYER;
	}

	self SetClientFlag( n_client_flag );

	self waittill( "death" );

	if ( IsDefined( self ) )
	{
		self ClearClientFlag( n_client_flag );
	}
}

// Ambient effects
precache_createfx_fx()
{
	// Exploders
	level._effect["fx_pak_water_gush_over_bus"]					= loadFX("water/fx_pak_water_gush_over_bus");	// 210
	level._effect["fx_pak_water_splash_lg"]							= loadFX("water/fx_pak_water_splash_lg");	// 210
	level._effect["fx_water_gush_heavy_md_pak"]					= loadFX("water/fx_water_gush_heavy_md_pak");
		level._effect["fx_bus_smash_impact"]							= loadFX("maps/pakistan/fx_bus_smash_impact");//10150
	level._effect["fx_bus_wall_collapse"]								= loadFX("maps/pakistan/fx_bus_wall_collapse");//10151
	level._effect["fx_car_smash_impact"]								= loadFX("maps/pakistan/fx_car_smash_impact");//10152
	level._effect["fx_car_smash_corner_impact"]					= loadFX("maps/pakistan/fx_car_smash_corner_impact");//10200
	level._effect["fx_arch_tunnel_collapse"]						= loadFX("maps/pakistan/fx_arch_tunnel_collapse");//10210
	level._effect["fx_arch_wall_collapse"]							= loadFX("maps/pakistan/fx_arch_wall_collapse");//10210
	level._effect["fx_arch_tunnel_water_impact"]				= loadFX("maps/pakistan/fx_arch_tunnel_water_impact");//10211
	level._effect["fx_arch_wall_water_impact"]					= loadFX("maps/pakistan/fx_arch_wall_water_impact");//10212
	level._effect["fx_balcony_collapse_wood"]					= loadFX("maps/pakistan/fx_balcony_collapse_wood");//10230
	level._effect["fx_sign_kashmir_sparks_01"]					= loadFX("maps/pakistan/fx_sign_kashmir_sparks_01");//10240
	level._effect["fx_sign_kashmir_sparks_02"]					= loadFX("maps/pakistan/fx_sign_kashmir_sparks_02");//10241
	level._effect["fx_sign_dangle_break"]								= loadFX("maps/pakistan/fx_sign_dangle_break");//10215
	level._effect["fx_market_ceiling_collapse"]					= loadFX("maps/pakistan/fx_market_ceiling_collapse");//10110
	level._effect["fx_market_ceiling_water_impact"]			= loadFX("maps/pakistan/fx_market_ceiling_water_impact");//10111
	
	//destructible
	level._effect["fx_pak_dest_shelving_unit"]					= loadFX("destructibles/fx_pak_dest_shelving_unit");


	level._effect["fx_rain_light_loop"]									= loadFX("weather/fx_rain_light_loop");
	level._effect["fx_insects_fly_swarm"]								= loadFX("bio/insects/fx_insects_fly_swarm");
	level._effect["fx_pak_debri_papers"]								= loadFX("maps/pakistan/fx_pak_debri_papers");

	// Event 2
	level._effect["fx_elec_transformer_sparks_runner"]	= loadFX("electrical/fx_elec_transformer_sparks_runner");

	// Event 3
	level._effect["fx_pak_water_particles_lit"]					= loadFX("water/fx_pak_water_particles_lit");	// 310

	// Water
	level._effect["fx_wtr_spill_sm_thin"]								= loadFX("env/water/fx_wtr_spill_sm_thin");
	level._effect["fx_water_pipe_spill_sm_thin_tall"]		= loadFX("water/fx_water_pipe_spill_sm_thin_tall");
	level._effect["fx_water_spill_sm"]									= loadFX("water/fx_water_spill_sm");
	level._effect["fx_water_spill_sm_splash"]						= loadFX("water/fx_water_spill_sm_splash");
	level._effect["fx_water_roof_spill_md"]							= loadFX("water/fx_water_roof_spill_md");
	level._effect["fx_water_roof_spill_md_hvy"]					= loadFX("water/fx_water_roof_spill_md_hvy");
	level._effect["fx_water_roof_spill_lg"]							= loadFX("water/fx_water_roof_spill_lg");
	level._effect["fx_water_roof_spill_lg_hvy"]					= loadFX("water/fx_water_roof_spill_lg_hvy");
	level._effect["fx_water_sheeting_lg_hvy"]						= loadFX("water/fx_water_sheeting_lg_hvy");
	level._effect["fx_rain_spatter_06x30"]							= loadFX("water/fx_rain_spatter_06x30");
	level._effect["fx_rain_spatter_25x25"]							= loadFX("water/fx_rain_spatter_25x25");
	level._effect["fx_rain_spatter_25x50"]							= loadFX("water/fx_rain_spatter_25x50");
	level._effect["fx_rain_spatter_25x120"] 						=	loadFX("water/fx_rain_spatter_25x120");
	level._effect["fx_water_splash_detail_lg"]					= loadFX("water/fx_water_splash_detail_lg");
	level._effect["fx_pak_water_elec_pole_wake"]				= loadFX("water/fx_pak_water_elec_pole_wake");
	level._effect["fx_pak_water_pipe_spill_wake"]				= loadFX("water/fx_pak_water_pipe_spill_wake");
	level._effect["fx_water_spill_splash_wide"]					= loadFX("water/fx_water_spill_splash_wide");
	level._effect["fx_water_drips_hvy_30"]							= loadFX("water/fx_water_drips_hvy_30");
	level._effect["fx_water_drips_hvy_120"]							= loadFX("water/fx_water_drips_hvy_120");
	level._effect["fx_water_drips_hvy_200"]							= loadFX("water/fx_water_drips_hvy_200");
	level._effect["fx_pak_water_froth_sm_front"]				= loadFX("water/fx_pak_water_froth_sm_front");
	level._effect["fx_pak_water_froth_md_front"]				= loadFX("water/fx_pak_water_froth_md_front");
	level._effect["fx_pak_water_froth_sm_side"] 				= loadFX("water/fx_pak_water_froth_sm_side");
	
	// Lights
	level._effect["fx_pak_light_overhead_rain"]					= loadFX("light/fx_pak_light_overhead_rain");
	
}


wind_init()
{
	SetSavedDvar( "wind_global_vector", "-145 110 0" );				// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage
}

footsteps()
{
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["market_car_crash"] = %fxanim_pak_market_car_crash_anim;
	level.scr_anim["fxanim_props"]["market_bus_crash"] = %fxanim_pak_market_bus_crash_anim;
	level.scr_anim["fxanim_props"]["bus_dam_1st_hit"] = %fxanim_pak_bus_dam_1st_hit_anim;
	level.scr_anim["fxanim_props"]["bus_dam_wedge_wall"] = %fxanim_pak_bus_dam_wedge_wall_anim;
	level.scr_anim["fxanim_props"]["bus_dam_wedge_wall2"] = %fxanim_pak_bus_dam_wedge_wall2_anim;
	level.scr_anim["fxanim_props"]["bus_dam_wedge_wall3"] = %fxanim_pak_bus_dam_wedge_wall3_anim;
	level.scr_anim["fxanim_props"]["bus_dam_break_wall"] = %fxanim_pak_bus_dam_break_wall_anim;
	level.scr_anim["fxanim_props"]["arch_collapse"] = %fxanim_pak_arch_collapse_anim;
	level.scr_anim["fxanim_props"]["sign_dangle_start_loop"] = %fxanim_pak_sign_dangle_start_loop_anim;
	level.scr_anim["fxanim_props"]["sign_dangle_end_loop"] = %fxanim_pak_sign_dangle_end_loop_anim;
	level.scr_anim["fxanim_props"]["sign_dangle_break"] = %fxanim_pak_sign_dangle_break_anim;
	level.scr_anim["fxanim_props"]["kashmir_sign_break"] = %fxanim_pak_sign_kashmir_break_anim;
	level.scr_anim["fxanim_props"]["kashmir_sign_loop"] = %fxanim_pak_sign_kashmir_loop_anim;
	level.scr_anim["fxanim_props"]["awning_fast"] = %fxanim_gp_awning_store_mideast_fast_anim;
	level.scr_anim["fxanim_props"]["awning_med_fast"] = %fxanim_gp_awning_store_mideast_med_fast_anim;
	level.scr_anim["fxanim_props"]["market_ceiling_01"] = %fxanim_pak_market_ceiling_01_anim;
	level.scr_anim["fxanim_props"]["market_ceiling_02"] = %fxanim_pak_market_ceiling_02_anim;
  level.scr_anim["fxanim_props"]["car_corner_crash"] = %fxanim_pak_car_corner_bldg_anim;
 	level.scr_anim["fxanim_props"]["shelving_dest01"] = %fxanim_gp_shelving_unit_dest01_anim;
  level.scr_anim["fxanim_props"]["shelving_dest02"] = %fxanim_gp_shelving_unit_dest02_anim;
  level.scr_anim["fxanim_props"]["power_pole_break"] = %fxanim_pak_power_pole_anim;
  level.scr_anim["fxanim_props"]["market_bus_crash_bus"] = %animated_props::fxanim_pak_market_bus_crash_bus_anim;
  level.scr_anim["fxanim_props"]["market_car_crash_car"] = %animated_props::fxanim_pak_market_car_crash_car_anim;
  level.scr_anim["fxanim_props"]["market_car_crash_idle"] = %animated_props::fxanim_pak_market_car_crash_idle_anim;
  level.scr_anim["fxanim_props"]["market_bus_crash_car"] = %animated_props::fxanim_pak_market_bus_crash_car_anim;
  level.scr_anim["fxanim_props"]["bus_dam_start"] = %fxanim_pak_bus_dam_enter_bus_anim;
  level.scr_anim["fxanim_props"]["bus_dam_idle"] = %fxanim_pak_bus_dam_idle_bus_anim;
  level.scr_anim["fxanim_props"]["bus_dam_exit"] = %fxanim_pak_bus_dam_exit_bus_anim;
  level.scr_anim["fxanim_props"]["balcony_collapse"] = %fxanim_pak_balcony_collapse_anim;
  level.scr_anim["fxanim_props"]["market_bus_shelf_01"] = %fxanim_pak_market_bus_shelf_01_anim;
  level.scr_anim["fxanim_props"]["market_bus_shelf_02"] = %fxanim_pak_market_bus_shelf_02_anim;
  level.scr_anim["fxanim_props"]["market_bus_shelf_03"] = %fxanim_pak_market_bus_shelf_03_anim;
  level.scr_anim["fxanim_props"]["market_bus_shelf_04"] = %fxanim_pak_market_bus_shelf_04_anim;
}
