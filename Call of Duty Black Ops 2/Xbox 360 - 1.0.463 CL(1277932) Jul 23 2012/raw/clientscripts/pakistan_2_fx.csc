#include clientscripts\_utility;

// Scripted effects
precache_scripted_fx()
{
	level._effect[ "soct_water_splash" ] = LoadFX( "weapon/tank/fx_tank_water" );
}


// Ambient effects
precache_createfx_fx()
{
	// Exploders
	// Event 8
	level._effect["fx_exp_harper_burn"]									= loadFX("maps/pakistan/fx_exp_harper_burn");	// 810
	level._effect["fx_pak_smk_signal_dist"]							= loadFX("smoke/fx_pak_smk_signal_dist");	// 850
	level._effect["fx_fire_fuel_sm_water"]							= loadFX("fire/fx_fire_fuel_sm_water");
	level._effect["fx_fire_fuel_md_water"]							= loadFX("fire/fx_fire_fuel_md_water");
	level._effect["fx_fire_fuel_sm_ground"]							= loadFX("fire/fx_fire_fuel_sm_ground");
	level._effect["fx_fire_fuel_sm_line"]								= loadFX("fire/fx_fire_fuel_sm_line");
	level._effect["fx_fire_fuel_sm"]										= loadFX("fire/fx_fire_fuel_sm");
	level._effect["fx_exp_catwalk_collapse"]						= loadFX("maps/pakistan/fx_exp_catwalk_collapse");	// 10920
	level._effect["fx_pak_water_splash_catwalk"]				= loadFX("water/fx_pak_water_splash_catwalk");	// 10920 + 1.5 seconds
	level._effect["fx_water_silo_exp"]									= loadFX("weapon/rocket/fx_rocket_exp_water");	// 10925
	level._effect["fx_pak_pipe_fire"]										= loadFX("maps/pakistan/fx_pak_pipe_fire");
	
	level._effect["fx_rain_light_loop"]									= loadFX("weather/fx_rain_med_loop");
	level._effect["fx_lights_stadium_drizzle_pak"]			= loadFX("light/fx_lights_stadium_drizzle_pak");
	level._effect["fx_lights_small_drizzle_pak"]				= loadFX("light/fx_lights_small_drizzle_pak");
	level._effect["fx_lights_small_drizzle_pak_b"]			= loadFX("light/fx_lights_small_drizzle_pak_b");
	level._effect["fx_lights_small_glow_pak"]						= loadFX("light/fx_lights_small_glow_pak");
	level._effect["fx_lights_small_glow_pak_b"]					= loadFX("light/fx_lights_small_glow_pak_b");
	level._effect["fx_light_glow_red_sml"]							= loadFX("maps/pakistan/fx_light_glow_red_sml");
	level._effect["fx_light_glow_blue_sml"]							= loadFX("maps/pakistan/fx_light_glow_blue_sml");
	level._effect["fx_light_glow_yellow_sml"]						= loadFX("maps/pakistan/fx_light_glow_yellow_sml");
	level._effect["fx_pak_flourescent_glow"]						= loadFX("maps/pakistan/fx_pak_flourescent_glow");
	level._effect["fx_pak_rooftop_water"]								= loadFX("maps/pakistan/fx_pak_rooftop_water");
	level._effect["fx_trainstation_steam_vent"]					= loadFX("maps/pakistan/fx_trainstation_steam_vent");
	level._effect["fx_trainstation_steam_train"]				= loadFX("maps/pakistan/fx_trainstation_steam_train");
	level._effect["fx_fire_wall_md"]										= loadFX("env/fire/fx_fire_wall_md");
}


main()
{
	clientscripts\createfx\pakistan_2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

