/* ---------------------------------------------------------------------------------
This script handles player swimming
-----------------------------------------------------------------------------------*/
#include maps\_utility;
#include common_scripts\utility;

init()
{
	vehicle_anims();
	player_anims();

	fx();
}

/* ---------------------------------------------------------------------------------
These anims are used on the client, but need to be referenced on the server to work
-----------------------------------------------------------------------------------*/
vehicle_anims()
{
	level.cougar_steer_anim = %vehicles::v_la_04_01_drive_leftturn_cougar;
}

/* ---------------------------------------------------------------------------------
These anims are used on the client, but need to be referenced on the server to work
-----------------------------------------------------------------------------------*/
player_anims()
{
	level.viewarms = PreCacheModel("c_usa_cia_masonjr_viewbody");
	
	level.viewarms_steer_anim = %player::ch_la_04_01_drive_leftturn_player;
}

/* ---------------------------------------------------------------------------------
Load the fx. They need to be loaded here even though they are used on the client.
self = player
-----------------------------------------------------------------------------------*/
fx()
{
	// client fx - used on client, but need to be pre-loaded on the server too
	//loadedfx = LoadFX( "env/water/fx_water_particles_surface_fxr" );
}

