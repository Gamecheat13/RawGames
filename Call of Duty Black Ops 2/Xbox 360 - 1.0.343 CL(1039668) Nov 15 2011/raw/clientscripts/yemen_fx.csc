//
// file: yemen_fx.gsc
// description: clientside fx script for yemen: setup, special fx functions, etc.
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


// --- FX DEPARTMENT SECTION ---//
precache_createfx_fx()
{
 // EXPLODERS //
  
 level._effect["fx_bridge_explosion01"]       = LoadFX("maps/yemen/fx_bridge_explosion01"); // exploder 750
 
 // END EXPLODERS //
 
 level._effect["fx_smk_fire_md_gray_int"]         = LoadFX("env/smoke/fx_smk_fire_md_gray_int");
 level._effect["fx_smk_fire_md_black"]            = LoadFX("env/smoke/fx_smk_fire_md_black");
 level._effect["fx_shrimp_group_hangout03"]       = LoadFX("bio/shrimps/fx_shrimp_group_hangout03");
}

footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
}


main()
{
	clientscripts\createfx\yemen_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

