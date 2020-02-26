//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
 
	// *Fog section* 
	
	const start_dist = 455.027;
    const half_dist = 6175.38;
	const half_height = 3812.64;
    const base_height = -635.478;
    const fog_r = 0.72549;
    const fog_g = 0.92549;
    const fog_b = 1;
    const fog_scale = 10.3386;
    const sun_col_r = 0;
    const sun_col_g = 0;
    const sun_col_b = 0;
    const sun_dir_x = 0;
    const sun_dir_y = 0;
    const sun_dir_z = 0;
    const sun_start_ang = 0;
    const sun_stop_ang = 0;
    const time = 0;
    const max_fog_opacity = 0.805942;

    setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
                    sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
                    sun_stop_ang, time, max_fog_opacity);

}