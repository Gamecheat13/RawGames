#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_makin_day_art::main();
	precacheFX();
	spawnFX();
}

precacheFX()
{
//	level._effect["mp_fire_small_detail"]								= loadfx("maps/mp_maps/fx_mp_fire_small_detail");
	level._effect["mp_insects_swarm"]										= loadfx("maps/mp_maps/fx_mp_insect_swarm");
	level._effect["mp_water_splash_small"]							= loadfx("maps/mp_maps/fx_mp_water_splash_small");
	level._effect["mp_water_wake_flow"]									= loadfx("maps/mp_maps/fx_mp_water_wake_flow");
	level._effect["mp_light_glow_indoor_short_loop"]		= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short_loop");
	level._effect["mp_light_glow_lantern"]							= loadfx("maps/mp_maps/fx_mp_light_glow_lantern_day");
	level._effect["mp_ray_sun_xsm"]											= loadfx("maps/mp_maps/fx_mp_ray_sun_xsm");
	level._effect["mp_ray_sun_sm"]											= loadfx("maps/mp_maps/fx_mp_ray_sun_sm");
	level._effect["mp_ray_sun_md"]											= loadfx("maps/mp_maps/fx_mp_ray_sun_md");
//	level._effect["mp_ray_sun_lg"]											= loadfx("maps/mp_maps/fx_mp_ray_sun_lg");
	level._effect["mp_ray_sun_md_1sd"]									= loadfx("maps/mp_maps/fx_mp_ray_sun_md_1sd");
	level._effect["mp_smoke_crater"]										= loadfx("maps/mp_maps/fx_mp_smoke_crater");
//	level._effect["mp_smoke_brush_smolder_sm"]					= loadfx("maps/mp_maps/fx_mp_smoke_brush_smolder_sm");
//	level._effect["mp_smoke_brush_smolder_md"]					= loadfx("maps/mp_maps/fx_mp_smoke_brush_smolder_md");


	//////////////////////////////////////////////////////////////////////////////////////
	// Alex Section:

	//level._effect["distant_muzzleflash"]		=	loadfx("weapon/muzzleflashes/heavy");

	//level._effect["flak_flash"] 	= loadfx("weapon/flak/fx_flak_cloudflash_night");
	

}

spawnFX()
{
	maps\mp\createfx\mp_makin_day_fx::main();
}

