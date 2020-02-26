#include clientscripts\_utility;

// Scripted effects
precache_scripted_fx()
{
	
}


// Ambient effects
precache_createfx_fx()
{
	level._effect["fx_com_gas_aftermath_linger"]							= loadFX("maps/command_center/fx_com_gas_aftermath_linger");
	level._effect["fx_com_sparks_slow"]							= loadFX("maps/command_center/fx_com_sparks_slow");
	level._effect["fx_com_sparks"]							= loadFX("maps/command_center/fx_com_sparks");
	level._effect["fx_com_water_drips"]							= loadFX("maps/command_center/fx_com_water_drips");
	level._effect["fx_com_pipe_water"]							= loadFX("maps/command_center/fx_com_pipe_water");
	level._effect["fx_com_pipe_steam"]							= loadFX("maps/command_center/fx_com_pipe_steam");
	level._effect["fx_com_pipe_steam_slow"]							= loadFX("maps/command_center/fx_com_pipe_steam_slow");
	level._effect["fx_com_distant_exp_1"]							= loadFX("maps/command_center/fx_com_distant_exp_1");
	level._effect["fx_com_distant_exp_2"]							= loadFX("maps/command_center/fx_com_distant_exp_2");
	level._effect["fx_com_distant_exp_water"]							= loadFX("maps/command_center/fx_com_distant_exp_water");
	level._effect["fx_com_distant_exp_flak"]							= loadFX("maps/command_center/fx_com_distant_exp_flak");
	level._effect["fx_com_distant_smoke"]							= loadFX("maps/command_center/fx_com_distant_smoke");
	level._effect["fx_com_deck_fire_lrg"]							= loadFX("maps/command_center/fx_com_deck_fire_lrg");
	level._effect["fx_com_deck_fire_sml"]							= loadFX("maps/command_center/fx_com_deck_fire_sml");
	level._effect["fx_com_deck_takeoff_steam"]							= loadFX("maps/command_center/fx_com_deck_takeoff_steam");
	level._effect["fx_com_hub_rpg_exp"]							= loadFX("maps/command_center/fx_com_hub_rpg_exp");
	level._effect["fx_com_carrier_runner"]							= loadFX("maps/command_center/fx_com_carrier_runner");
	level._effect["fx_com_menendez_spotlight"]							= loadFX("maps/command_center/fx_com_menendez_spotlight");
	level._effect["fx_com_floating_paper"]							= loadFX("maps/command_center/fx_com_floating_paper");
	level._effect["fx_com_oil_drips"]							= loadFX("maps/command_center/fx_com_oil_drips");
	level._effect["fx_com_steam_debri"]							= loadFX("maps/command_center/fx_com_steam_debri");
	level._effect["fx_com_deck_oil_fire"]							= loadFX("maps/command_center/fx_com_deck_oil_fire");
	level._effect["fx_com_deck_exp_vtol"]							= loadFX("maps/command_center/fx_com_deck_exp_vtol");
	level._effect["fx_com_deck_exp_f38"]							= loadFX("maps/command_center/fx_com_deck_exp_f38");
	level._effect["fx_com_deck_dust"]							= loadFX("maps/command_center/fx_com_deck_dust");
	level._effect["fx_com_water_leak"]							= loadFX("maps/command_center/fx_com_water_leak");
	level._effect["fx_com_exp_sparks"]							= loadFX("maps/command_center/fx_com_exp_sparks");
	level._effect["fx_com_glass_shatter"]							= loadFX("maps/command_center/fx_com_glass_shatter");
	level._effect["fx_com_glass_shatter_f38"]							= loadFX("maps/command_center/fx_com_glass_shatter_f38");
		level._effect["fx_com_pipe_steam_exp_1"]							= LoadFX( "maps/command_center/fx_com_pipe_steam_exp_1" );
	level._effect["fx_com_pipe_steam_exp_2"]							= LoadFX( "maps/command_center/fx_com_pipe_steam_exp_2" );
	level._effect["fx_com_ceiling_collapse"]							= LoadFX( "maps/command_center/fx_com_ceiling_collapse" );
	level._effect["fx_com_water_ship_sink"]							= LoadFX( "maps/command_center/fx_com_water_ship_sink" );
	level._effect["fx_com_distant_ship_exp"]							= LoadFX( "maps/command_center/fx_com_distant_ship_exp" );
	level._effect["fx_com_window_break_paper"]							= LoadFX( "maps/command_center/fx_com_window_break_paper" );
	level._effect["fx_com_elev_fa38_impact"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_impact" );
	level._effect["fx_com_elev_fa38_exp"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_exp" );
	level._effect["fx_com_elev_fa38_debri_trail"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_debri_trail" );
	level._effect["fx_com_elev_fa38_water_impact"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_water_impact" );
	level._effect["fx_com_messiah_papers_exp"]							= LoadFX( "maps/command_center/fx_com_messiah_papers_exp" );
	level._effect["fx_com_f38_slide"]							= LoadFX( "maps/command_center/fx_com_f38_slide" );
	level._effect["fx_com_drone_slide"]							= LoadFX( "maps/command_center/fx_com_drone_slide" );
	level._effect["fx_com_light_beam"]							= LoadFX( "maps/command_center/fx_com_light_beam" );
	level._effect["fx_com_emergency_lights"]							= LoadFX( "maps/command_center/fx_com_emergency_lights" );
		level._effect["fx_com_hanger_godray"]							= LoadFX( "maps/command_center/fx_com_hanger_godray" );
	level._effect["fx_com_flourescent_glow_white"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_white" );
	level._effect["fx_com_flourescent_glow_warm"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_warm" );
	level._effect["fx_com_flourescent_glow_green"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_green" );
	
		//frontend fx
	level._effect["fx_com_flourescent_glow_cool"]	= loadfx ("maps/command_center/fx_com_flourescent_glow_cool");
	level._effect["fx_com_flourescent_glow_cool_sm"]	= loadfx ("maps/command_center/fx_com_flourescent_glow_cool_sm");
	level._effect["fx_com_tv_glow_blue"]	= loadfx ("maps/command_center/fx_com_tv_glow_blue");
	level._effect["fx_com_tv_glow_green"]	= loadfx ("maps/command_center/fx_com_tv_glow_green");
	level._effect["fx_com_tv_glow_yellow"]	= loadfx ("maps/command_center/fx_com_tv_glow_yellow");
	level._effect["fx_com_tv_glow_yellow_sml"]	= loadfx ("maps/command_center/fx_com_tv_glow_yellow_sml");
	level._effect["fx_com_light_glow_white"]	= loadfx ("maps/command_center/fx_com_light_glow_white");
	level._effect["fx_lf_commandcenter_light1"]	= loadfx ("lens_flares/fx_lf_commandcenter_light1");
	level._effect["fx_lf_commandcenter_light2"]	= loadfx ("lens_flares/fx_lf_commandcenter_light2");
	level._effect["fx_lf_commandcenter_light3"]	= loadfx ("lens_flares/fx_lf_commandcenter_light3");
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


main()
{
	clientscripts\createfx\blackout_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

