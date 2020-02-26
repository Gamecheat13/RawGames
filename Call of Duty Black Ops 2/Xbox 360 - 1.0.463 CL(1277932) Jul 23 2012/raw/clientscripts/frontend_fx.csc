//
// file: frontend_fx.gsc
// description: clientside fx script for frontend: setup, special fx functions, etc.
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


// Ambient effects
precache_createfx_fx()
{
	level._effect["fx_missing_effect"]	= loadfx ("misc/fx_missing_fx");
	level._effect["fx_smoke_plume_lg_slow_blk"]	= loadfx ("env/smoke/fx_smoke_plume_lg_slow_blk");			
	level._effect["fx_com_flourescent_glow_cool"]	= loadfx ("maps/command_center/fx_com_flourescent_glow_cool");	
	level._effect["fx_com_tv_glow_blue"]	= loadfx ("maps/command_center/fx_com_tv_glow_blue");
	level._effect["fx_com_tv_glow_green"]	= loadfx ("maps/command_center/fx_com_tv_glow_green");
	level._effect["fx_com_tv_glow_yellow"]	= loadfx ("maps/command_center/fx_com_tv_glow_yellow");
	level._effect["fx_com_tv_glow_yellow_sml"]	= loadfx ("maps/command_center/fx_com_tv_glow_yellow_sml");
	level._effect["fx_com_light_glow_white"]	= loadfx ("maps/command_center/fx_com_light_glow_white");
	level._effect["fx_lf_commandcenter_light1"]	= loadfx ("lens_flares/fx_lf_commandcenter_light1");
	level._effect["fx_com_glow_sml_blue"]	= loadfx ("maps/command_center/fx_com_glow_sml_blue");
	level._effect["fx_com_hologram_glow"]	= loadfx ("maps/command_center/fx_com_hologram_glow");
	level._effect["fx_com_button_glows_1"]	= loadfx ("maps/command_center/fx_com_button_glows_1");
	level._effect["fx_com_button_glows_2"]	= loadfx ("maps/command_center/fx_com_button_glows_2");
	level._effect["fx_com_button_glows_3"]	= loadfx ("maps/command_center/fx_com_button_glows_3");
	level._effect["fx_com_button_glows_4"]	= loadfx ("maps/command_center/fx_com_button_glows_4");
	level._effect["fx_com_button_glows_5"]	= loadfx ("maps/command_center/fx_com_button_glows_5");
	level._effect["fx_com_button_glows_6"]	= loadfx ("maps/command_center/fx_com_button_glows_6");
	level._effect["fx_com_button_glows_7"]	= loadfx ("maps/command_center/fx_com_button_glows_7");
	level._effect["fx_com_button_glows_8"]	= loadfx ("maps/command_center/fx_com_button_glows_8");
	level._effect["fx_com_hologram_static"]	= loadfx ("maps/command_center/fx_com_hologram_static");
}

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "brick", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "carpet", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "cloth", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "dirt", LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "foliage", LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "gravel", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "grass", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "metal", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "mud", LoadFx( "bio/player/fx_footstep_mud" ) );
	clientscripts\_utility::setFootstepEffect( "paper", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "plaster", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "rock", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "water", LoadFx( "bio/player/fx_footstep_water" ) );
	clientscripts\_utility::setFootstepEffect( "wood", LoadFx( "bio/player/fx_footstep_dust" ) );
}*/

main()
{
	precache_util_fx();
	precache_createfx_fx();
	
	clientscripts\createfx\frontend_fx::main();
	clientscripts\_fx::reportNumEffects();
	
//	footsteps();
	
	disableFX = GetDvarint( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

