#include maps\mp\_utility;
#using_animtree("fxanim_props");

main()
{
	precache_fxanim_props();
	precache_scripted_fx();
	precache_createfx_fx();
	
	maps\mp\createfx\mp_turbine_fx::main();
	
	maps\mp\createart\mp_turbine_art::main();	
		
	wind_initial_setting();

}

wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-150 -230 -150" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}

// Scripted effects
precache_scripted_fx()
{
	
}

// Ambient effects
precache_createfx_fx()
{

//	level._effect["fx_sand_blowing_xlg"]											= loadFX("dirt/fx_sand_blowing_xlg");
//	level._effect["fx_sand_blowing_xlg_fall"]									= loadFX("dirt/fx_sand_blowing_xlg_fall");
	level._effect["fx_sand_blowing_lg"]												= loadFX("dirt/fx_sand_blowing_lg");
	level._effect["fx_sand_blowing_md"]												= loadFX("dirt/fx_sand_blowing_md");
	level._effect["fx_sand_blowing_sm"]												= loadFX("dirt/fx_sand_blowing_sm");
	level._effect["fx_sand_gust_ground_lg"]										= loadFX("dirt/fx_sand_gust_ground_lg");
	level._effect["fx_sand_gust_ground_sm"]										= loadFX("dirt/fx_sand_gust_ground_sm");
	level._effect["fx_sand_gust_ground_md"]										= loadFX("dirt/fx_sand_gust_ground_md");
	level._effect["fx_sand_gust_door"]												= loadFX("dirt/fx_sand_gust_door");
	level._effect["fx_sand_blowing_lg_vista"]									= loadFX("dirt/fx_sand_blowing_lg_vista");
	level._effect["fx_sand_blowing_lg_vista_shrt"]						= loadFX("dirt/fx_sand_blowing_lg_vista_shrt");	
//	level._effect["fx_sand_cloud_ground_vista"]								= loadFX("dirt/fx_sand_cloud_ground_vista");

	level._effect["fx_sand_gust_cliff_fall"]									= loadFX("dirt/fx_sand_gust_cliff_fall");	
	level._effect["fx_sand_gust_cliff_fall_md"]								= loadFX("dirt/fx_sand_gust_cliff_fall_md");
	level._effect["fx_sand_gust_cliff_fall_md_lng"]						= loadFX("dirt/fx_sand_gust_cliff_fall_md_lng");
	level._effect["fx_sand_gust_cliff_edge_md"]								= loadFX("dirt/fx_sand_gust_cliff_edge_md");	

	level._effect["fx_sand_swirl_lg_pipe"]										= loadFX("dirt/fx_sand_swirl_lg_pipe");		
	level._effect["fx_sand_swirl_sm_pipe"]										= loadFX("dirt/fx_sand_swirl_sm_pipe");	

	level._effect["fx_sand_swirl_debris_pipe"]								= loadFX("dirt/fx_sand_swirl_debris_pipe");

	level._effect["fx_mp_light_wind_turbine"]									= loadFX("maps/mp_maps/fx_mp_light_wind_turbine");
	level._effect["fx_light_floodlight_sqr_cool"]							= loadFX("light/fx_light_floodlight_sqr_cool");
//	level._effect["fx_light_flourescent_glow_cool"]						= loadFX("light/fx_light_flourescent_glow_cool");	
	level._effect["fx_light_flour_glow_cool_dbl_shrt"]				= loadFX("light/fx_light_flour_glow_cool_dbl_shrt");		

//	level._effect["fx_mp_light_dust_motes_md"]								= loadFX("maps/mp_maps/fx_mp_light_dust_motes_md");
	
	level._effect["fx_mp_sun_flare_turbine_streak"]						= loadFX("maps/mp_maps/fx_mp_sun_flare_turbine_streak");
	level._effect["fx_mp_sun_flare_turbine"]									= loadFX("maps/mp_maps/fx_mp_sun_flare_turbine");
//	level._effect["fx_light_gray_xlng_warm_sm"]								= loadFX("light/fx_light_gray_xlng_warm_sm");	

	level._effect["fx_lf_mp_turbine_sun1"]										= loadFX("lens_flares/fx_lf_mp_turbine_sun1");

}




// FXanim Props
precache_fxanim_props()
{
	level.scr_anim["fxanim_props"]["wires_01"] = %fxanim_mp_turbine_wires_01_anim;
	level.scr_anim["fxanim_props"]["wires_02"] = %fxanim_mp_turbine_wires_02_anim;
	level.scr_anim["fxanim_props"]["wires_03"] = %fxanim_mp_turbine_wires_03_anim;
	level.scr_anim["fxanim_props"]["bridge_cables"] = %fxanim_mp_turbine_bridge_cables_anim;
}