#include clientscripts\_utility;

// Scripted effects
precache_scripted_fx()
{
	level._effect["fx_ango_intro_truck_fade"]	= loadFX("maps/angola/fx_ango_intro_truck_fade");
}


// Ambient effects
precache_createfx_fx()
{

	level._effect["fx_ango_intro_truck_fire"]	= loadFX("maps/angola/fx_ango_intro_truck_fire");
	level._effect["fx_ango_dust_distant_lrg"]	= loadFX("maps/angola/fx_ango_dust_distant_lrg");
	level._effect["fx_ango_smoke_distant_lrg"]	= loadFX("maps/angola/fx_ango_smoke_distant_lrg");
	level._effect["fx_ango_vehicle_fire"]	= loadFX("maps/angola/fx_ango_vehicle_fire");
	level._effect["fx_ango_vehicle_fire_2"]	= loadFX("maps/angola/fx_ango_vehicle_fire_2");
	level._effect["fx_ango_fire_sm"]	= loadFX("maps/angola/fx_ango_fire_sm");
	//level._effect["fx_ango_heli_fire"]	= loadFX("maps/angola/fx_ango_heli_fire");
	//level._effect["fx_ango_fire_hut"]	= loadFX("maps/angola/fx_ango_fire_hut");
	//level._effect["fx_elec_ember_shower_os_int_runner"]	= loadFX("electrical/fx_elec_ember_shower_os_int_runner");
	level._effect["fx_ango_fire_sm"]	= loadFX("maps/angola/fx_ango_fire_sm");
	level._effect["fx_ango_hill_outro_fire_sm"]	= loadFX("maps/angola/fx_ango_hill_outro_fire_sm");
	level._effect["fx_ango_hill_outro_fire_med"]	= loadFX("maps/angola/fx_ango_hill_outro_fire_med");
	//level._effect["fx_ango_falling_fire"]	= loadFX("maps/angola/fx_ango_falling_fire");
	//level._effect["fx_ango_godray_smoke_large"]	= loadFX("maps/angola/fx_ango_godray_smoke_large");
	//level._effect["fx_ango_godray_md"]	= loadFX("maps/angola/fx_ango_godray_md");
	level._effect["fx_ango_falling_ash"]	= loadFX("maps/angola/fx_ango_falling_ash");
	level._effect["fx_ango_steam_body"]	= loadFX("maps/angola/fx_ango_steam_body");
	level._effect["fx_ango_rising_smoke"]	= loadFX("maps/angola/fx_ango_rising_smoke");
	level._effect["fx_ango_dust_sml"]	= loadFX("maps/angola/fx_ango_dust_sml");
	level._effect["fx_ango_dust_sml_dark"]	= loadFX("maps/angola/fx_ango_dust_sml_dark");
	level._effect["fx_ango_lingering_dust_sml"]	= loadFX("maps/angola/fx_ango_lingering_dust_sml");
	level._effect["fx_ango_lingering_dust_heavy"]	= loadFX("maps/angola/fx_ango_lingering_dust_heavy");
	level._effect["fx_ango_oil_drips"]	= loadFX("maps/angola/fx_ango_oil_drips");
	//level._effect["fx_ango_blowing_dust"]	= loadFX("maps/angola/fx_ango_blowing_dust");
  //level._effect["fx_ango_waterfall_bottom"]	= loadFX("maps/angola/fx_ango_waterfall_bottom");
	//level._effect["fx_ango_water_ripples"]	= loadFX("maps/angola/fx_ango_water_ripples");
	level._effect["fx_birds_circling"]	= loadFX("bio/animals/fx_birds_circling");
	level._effect["fx_ango_birds_runner"]	= loadFX("maps/angola/fx_ango_birds_runner");
	level._effect["fx_ango_explosion_runner"]	= loadFX("maps/angola/fx_ango_explosion_runner");
	level._effect["fx_insects_fly_swarm"]	= loadFX("bio/insects/fx_insects_fly_swarm");
	level._effect["fx_leaves_falling_lite_sm"]	= loadFX("maps/angola/fx_ango_leaves_falling");
	level._effect["fx_ango_shrimp_horde"]	= loadFX("maps/angola/fx_ango_shrimp_horde");
	level._effect["fx_ango_shrimp_horde_side"]	= loadFX("maps/angola/fx_ango_shrimp_horde_side");
	level._effect["fx_ango_grass_blowing"]	= loadFX("maps/angola/fx_ango_grass_blowing");
	level._effect["fx_insects_dragonflies_ambient"]	= loadFX("bio/insects/fx_insects_dragonflies_ambient");
	level._effect["fx_insects_butterfly_flutter"]	= loadFX("bio/insects/fx_insects_butterfly_flutter");
	level._effect["fx_insects_moths_flutter"]	= loadFX("bio/insects/fx_insects_moths_flutter");
	level._effect["fx_ango_heat_distortion"]	= loadFX("maps/angola/fx_ango_heat_distortion");
	level._effect["fx_ango_heat_distortion_no_fade"]	= loadFX("maps/angola/fx_ango_heat_distortion_no_fade");
	level._effect["fx_ango_heat_distortion_distant"]	= loadFX("maps/angola/fx_ango_heat_distortion_distant");
	level._effect["fx_ango_intro_glass_impact"]	= loadFX("maps/angola/fx_ango_intro_glass_impact");
	level._effect["fx_lf_angola1_sun1"]	= loadFX("lens_flares/fx_lf_angola1_sun1");
	level._effect["fx_lf_angola1_sun2"]	= loadFX("lens_flares/fx_lf_angola1_sun2");
	level._effect["fx_ango_intro_fire_spotlight"]	= loadFX("maps/angola/fx_ango_intro_fire_spotlight");
	level._effect["fx_ango_intro_reflection_light"]	= loadFX("maps/angola/fx_ango_intro_reflection_light");
}

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
}*/

main()
{
	clientscripts\createfx\angOla_Fx::Main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	// footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

