#include clientscripts\mp\_utility;

// Scripted effects
precache_scripted_fx()
{
	
}


// Ambient effects
precache_createfx_fx()
{
	
	level._effect["fx_fog_low_rising"]												= loadFX("fog/fx_fog_low_rising");
	level._effect["fx_mp_fog_thick_md"]												= loadFX("maps/mp_maps/fx_mp_fog_thick_md");			

	level._effect["fx_mp_water_rain_cooling_tower"]						= loadFX("maps/mp_maps/fx_mp_water_rain_cooling_tower");		
	level._effect["fx_mp_water_drip_light_long"]							= loadFX("maps/mp_maps/fx_mp_water_drip_light_long");		
	level._effect["fx_mp_water_drip_light_shrt"]							= loadFX("maps/mp_maps/fx_mp_water_drip_light_shrt");		
	level._effect["fx_rain_splash_area_100_hvy_lp"]						= loadFX("weather/fx_rain_splash_area_100_hvy_lp");
	
}


main()
{
	clientscripts\mp\createfx\mp_meltdown_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

