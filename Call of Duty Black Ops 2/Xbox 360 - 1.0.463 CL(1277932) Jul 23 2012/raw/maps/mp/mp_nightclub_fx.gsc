#include maps\mp\_utility; 
#using_animtree("fxanim_props");

precache_util_fx()
{
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{

	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
  level._effect["fx_mp_light_laser_blue_fxanim"]						= loadfx("maps/mp_maps/fx_mp_light_laser_bluee_fxanim");

	level._effect["fx_mp_nightclub_spotlight"]								= loadfx("maps/mp_maps/fx_mp_nightclub_spotlight");
	level._effect["fx_mp_nightclub_laser_roller"]							= loadfx("maps/mp_maps/fx_mp_nightclub_laser_roller");	
	level._effect["fx_mp_nightclub_laser_fan"]								= loadfx("maps/mp_maps/fx_mp_nightclub_laser_fan");
	level._effect["fx_mp_nightclub_laser_disco"]							= loadfx("maps/mp_maps/fx_mp_nightclub_laser_disco");
	level._effect["fx_mp_nightclub_dancefloor_grays"]					= loadfx("maps/mp_maps/fx_mp_nightclub_dancefloor_grays");
	level._effect["fx_mp_light_laser_blue_static"]						= loadfx("maps/mp_maps/fx_mp_light_laser_blue_static");  
	level._effect["fx_mp_light_laser_blue_fxanim"]           	= loadfx("maps/mp_maps/fx_mp_light_laser_blue_fxanim");
	level._effect["fx_mp_nightclub_laser_floor"]           		= loadfx("maps/mp_maps/fx_mp_nightclub_laser_floor");	

	level._effect["fx_mp_nightclub_floormist"]								= loadfx("maps/mp_maps/fx_mp_nightclub_floormist");
	level._effect["fx_mp_nightclub_mist"]											= loadfx("maps/mp_maps/fx_mp_nightclub_mist"); 
	level._effect["fx_mp_nightclub_mist_sm"]									= loadfx("maps/mp_maps/fx_mp_nightclub_mist_sm");
}

main()
{
	precache_fxanim_props();
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	
	maps\mp\createfx\mp_nightclub_fx::main();
	maps\mp\createart\mp_nightclub_art::main();

}

// FXanim Props
precache_fxanim_props()
{
	level.scr_anim["fxanim_props"]["laser"] = %fxanim_mp_nightclub_laser_anim;
	level.scr_anim["fxanim_props"]["shopping_lights_short"] = %fxanim_gp_shopping_lights_short_anim;
	level.scr_anim["fxanim_props"]["shopping_lights_med"] = %fxanim_gp_shopping_lights_med_anim;
	level.scr_anim["fxanim_props"]["shopping_lights_long"] = %fxanim_gp_shopping_lights_long_anim;
	level.scr_anim["fxanim_props"]["skylight"] = %fxanim_gp_skylight_anim;
}
