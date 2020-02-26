#include clientscripts\mp\_utility;
#using_animtree("fxanim_props");

// Scripted effects
precache_scripted_fx()
{
	
}


// Ambient effects
precache_createfx_fx()
{
		level._effect["fx_leaves_falling_mangrove_lg"] 						= loadfx("env/foliage/fx_leaves_falling_mangrove_lg");
		level._effect["fx_leaves_falling_lite"] 									= loadfx("env/foliage/fx_leaves_falling_lite");
		level._effect["fx_mp_vent_steam"] 						          	= loadfx("maps/mp_maps/fx_mp_vent_steam");
		level._effect["fx_hvac_steam_md"] 								      	= loadfx("smoke/fx_hvac_steam_md");
		level._effect["fx_mp_water_drip_light_shrt"] 							= loadfx("maps/mp_maps/fx_mp_water_drip_light_shrt");
		 level._effect["fx_mp_elec_spark_burst_xsm_thin_runner"] 		 = loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin_runner");
		 level._effect["fx_fog_street_cool_slw_md"] 							   = loadfx("fog/fx_fog_street_cool_slw_md");
		 level._effect["fx_light_emrgncy_floodlight"] 							    = loadfx("light/fx_light_emrgncy_floodlight");
		 level._effect["fx_insects_swarm_dark_lg"] 							       = loadfx("bio/insects/fx_insects_swarm_dark_lg");
		 level._effect["fx_mp_fog_low"] 							                = loadfx("maps/mp_maps/fx_mp_fog_low");
		  //level._effect["fx_mp_steam_thick"]                           = loadfx("maps/mp_maps/fx_mp_steam_thick");
		   level._effect["fx_insects_swarm_md_light"]                       = loadfx("bio/insects/fx_insects_swarm_md_light");
		   level._effect["fx_lf_mp_turbine_sun1"]                           = loadfx("lens_flares/fx_lf_mp_turbine_sun1");
		   level._effect["fx_light_floodlight_rnd_cool_glw_dim"]            = loadfx("light/fx_light_floodlight_rnd_cool_glw_dim");
		   level._effect["fx_mp_steam_pipe_md"]                             = loadfx("maps/mp_maps/fx_mp_steam_pipe_md");
		   level._effect["fx_mp_light_dust_motes_md"]                       = loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
		   level._effect["fx_mp_light_dust_motes_sm"]                       = loadfx("maps/mp_maps/fx_mp_light_dust_motes_sm");
		   level._effect["fx_mp_fog_cool_ground"]                           = loadfx("maps/mp_maps/fx_mp_fog_cool_ground");
		   level._effect["fx_water_splash_detail"]                          = loadfx("water/fx_water_splash_detail");
		   level._effect["fx_red_button_flash"]                             = loadfx("light/fx_red_button_flash");
		   level._effect["fx_wall_water_bottom"]                            = loadfx("water/fx_wall_water_bottom");
		   level._effect["fx_wall_water_bottom"]                            = loadfx("water/fx_wall_water_bottom");
		   level._effect["fx_mp_distant_cloud"]                             = loadfx("maps/mp_maps/fx_mp_distant_cloud");
		   level._effect["fx_light_god_ray_mp_drone"]                       = loadfx("env/light/fx_light_god_ray_mp_drone");
		   level._effect["fx_mp_vent_steam_dark"]                           = loadfx("maps/mp_maps/fx_mp_vent_steam_dark");
		   level._effect["fx_ceiling_circle_light_glare"]                   = loadfx("light/fx_ceiling_circle_light_glare");
		   level._effect["fx_drone_rectangle_light"]                        = loadfx("light/fx_drone_rectangle_light");
		   level._effect["fx_drone_rectangle_light_02"]                        = loadfx("light/fx_drone_rectangle_light_02");
		   level._effect["fx_mp_water_drip_light_long"]                        = loadfx("maps/mp_maps/fx_mp_water_drip_light_long");
		   level._effect["fx_pc_panel_lights_runner"]                        = loadfx("props/fx_pc_panel_lights_runner");
		   level._effect["fx_drone_red_ring_console"]                        = loadfx("light/fx_drone_red_ring_console");
		   level._effect["fx_blue_light_flash"]                               = loadfx("light/fx_blue_light_flash");
		   level._effect["fx_window_god_ray"]				                          = loadfx("light/fx_window_god_ray");
		   level._effect["fx_mp_drone_interior_steam"]				                = loadfx("maps/mp_maps/fx_mp_drone_interior_steam");
		   level._effect["fx_drone_pipe_water"]				                         = loadfx("water/fx_drone_pipe_water");
		   level._effect["fx_pc_panel_heli"]				                         = loadfx("props/fx_pc_panel_heli");
		   level._effect["fx_red_light_flash"]				                        = loadfx("light/fx_red_light_flash");
		   level._effect["fx_drone_rectangle_light_blue"]				             = loadfx("light/fx_drone_rectangle_light_blue");
		   level._effect["fx_mp_distant_cloud_vista"]				                 = loadfx("maps/mp_maps/fx_mp_distant_cloud_vista");
		   level._effect["fx_drone_rectangle_light_blue_4"]				             = loadfx("light/fx_drone_rectangle_light_blue_4");
		   level._effect["fx_drone_rectangle_light_yellow"]				             = loadfx("light/fx_drone_rectangle_light_yellow");
		   level._effect["fx_ceiling_circle_light_led"]				                 = loadfx("light/fx_ceiling_circle_light_led");
		   level._effect["fx_drone_rectangle_door_open"]				                 = loadfx("light/fx_drone_rectangle_door_open");
		   level._effect["fx_drone_rectangle_door_project"]				                 = loadfx("light/fx_drone_rectangle_door_project");
		   level._effect["fx_drone_red_ring_console_runner"]				           = loadfx("light/fx_drone_red_ring_console_runner");
		   level._effect["fx_light_beacon_red_blink_fst"]				               = loadfx("light/fx_light_beacon_red_blink_fst");
		   
		  
		    
		   
		  

}


main()
{
	clientscripts\mp\createfx\mp_drone_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_createfx_fx();
	precache_fxanim_props();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

// FXanim Props
precache_fxanim_props()
{
	level.scr_anim["fxanim_props"]["vines_aquilaria"] = %fxanim_gp_vines_aquilaria_anim;
	level.scr_anim["fxanim_props"]["vines_strangler_fig"] = %fxanim_gp_vines_strangler_fig_anim;
}