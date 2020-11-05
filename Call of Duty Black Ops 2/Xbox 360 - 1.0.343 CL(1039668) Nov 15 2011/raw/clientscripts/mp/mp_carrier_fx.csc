
#include clientscripts\mp\_utility; 


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
}

main()
{
	clientscripts\mp\createfx\mp_carrier_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}