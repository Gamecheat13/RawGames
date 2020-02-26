#include maps\mp\_utility; 

precache_util_fx()
{
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{
	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");

	level._effect["fx_mp_smk_plume_lg_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk");	
	level._effect["fx_mp_smk_plume_lg_blk_carrier"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk_carrier");	
	level._effect["fx_mp_carrier_vista_wake01"]						    = loadfx("maps/mp_maps/fx_mp_carrier_vista_wake01");
  level._effect["fx_mp_carrier_vista_wake_med"]						    = loadfx("maps/mp_maps/fx_mp_carrier_vista_wake_med");	
}

main()
{

	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	
	maps\mp\createfx\mp_carrier_fx::main();
	maps\mp\createart\mp_carrier_art::main();


}

