#include maps\mp\_utility;

main()
{
	precache_fxanim_props();
	precache_scripted_fx();
	precache_createfx_fx();
	
	//Commenting out due to breaking game PTASKER 9/23/11
	//wind_init();  
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\mp\createfx\mp_meltdown_fx::main();
	
	//maps\mp\createart\mp_meltdown_fx::main();
		maps\mp\createart\mp_meltdown_art::main();
}

// Scripted effects
precache_scripted_fx()
{
	
}

// Ambient effects
precache_createfx_fx()
{
	//level._effect["effect_alias"]	= loadFX("path/to/effect");
	
	level._effect["fx_fog_low_rising"]												= loadFX("fog/fx_fog_low_rising");
	level._effect["fx_mp_fog_thick_md"]												= loadFX("maps/mp_maps/fx_mp_fog_thick_md");		

	level._effect["fx_mp_water_rain_cooling_tower"]						= loadFX("maps/mp_maps/fx_mp_water_rain_cooling_tower");		
	level._effect["fx_mp_water_drip_light_long"]							= loadFX("maps/mp_maps/fx_mp_water_drip_light_long");		
	level._effect["fx_mp_water_drip_light_shrt"]							= loadFX("maps/mp_maps/fx_mp_water_drip_light_shrt");		
	level._effect["fx_rain_splash_area_100_hvy_lp"]						= loadFX("weather/fx_rain_splash_area_100_hvy_lp");	

}

/*  Commenting out due to breaking game PTASKER 9/23/11
wind_init()
{
	SetSavedDvar( "wind_global_vector", "1 0 0" );						// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage
}
*/

// FXanim Props
precache_fxanim_props()
{
	
}