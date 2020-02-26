//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
 
	// *Fog section* 
	//dust storm fog
	//call afghanistan_dust_storm.vision here also
	
  	const start_dist = 131.046;
	const half_dist = 1000.5;
	const half_height = 1007.89;
	const base_height = -144.597;
	const fog_r = 0.427451;
	const fog_g = 0.364706;
	const fog_b = 0.27451;
	const fog_scale = 19.0959;
	const sun_col_r = 1;
	const sun_col_g = 0.941177;
	const sun_col_b = 0.843137;
	const sun_dir_x = 0.305329;
	const sun_dir_y = 0.730931;
	const sun_dir_z = 0.610339;
	const sun_start_ang = 0;
	const sun_stop_ang = 71.3698;
	const time = 0;
	const max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

//fog for start of canyon after intro
// use afghanistan_canyon_start.vision


//  start_dist = 296.237;
//	half_dist = 21215;
//	half_height = 11399.1;
//	base_height = -144.597;
//	fog_r = 0.580392;
//	fog_g = 0.627451;
//	fog_b = 0.647059;
//	fog_scale = 21.5074;
//	sun_col_r = 1;
//	sun_col_g = 0.941177;
//	sun_col_b = 0.843137;
//	sun_dir_x = 0.305329;
//	sun_dir_y = 0.730931;
//	sun_dir_z = 0.610339;
//	sun_start_ang = 0;
//	sun_stop_ang = 102.152;
//	time = 0;
//	max_fog_opacity = 1;


//	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
//		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
//		sun_stop_ang, time, max_fog_opacity);



// fog for after the canyon and before the rebel base
// use afghanistan_open_area.vision


//start_dist = 296.237;
//	half_dist = 7497.43;
//	half_height = 4759.88;
//	base_height = -144.597;
//	fog_r = 0.74902;
//	fog_g = 0.796079;
//	fog_b = 0.823529;
//	fog_scale = 21.5074;
//	sun_col_r = 1;
//	sun_col_g = 0.941177;
//	sun_col_b = 0.843137;
//	sun_dir_x = 0.305329;
//	sun_dir_y = 0.730931;
//	sun_dir_z = 0.610339;
//	sun_start_ang = 0;
//	sun_stop_ang = 102.152;
//	time = 0;
//	max_fog_opacity = 0.900923;

//	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
//		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
//		sun_stop_ang, time, max_fog_opacity);


//fog for rebel base entrance
//use afghanistan_rebel_entrance.vision

//	start_dist = 281.96;
//	half_dist = 16268.3;
//	half_height = 4759.88;
//	base_height = -144.597;
//	fog_r = 0.74902;
//	fog_g = 0.796079;
//	fog_b = 0.823529;
//	fog_scale = 16.9023;
//	sun_col_r = 1;
//	sun_col_g = 0.941177;
//	sun_col_b = 0.843137;
//	sun_dir_x = 0.305329;
//	sun_dir_y = 0.730931;
//	sun_dir_z = 0.610339;
//	sun_start_ang = 0;
//	sun_stop_ang = 102.152;
//	time = 0;
//	max_fog_opacity = 0.900923;

//	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
//		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
//		sun_stop_ang, time, max_fog_opacity);

//fog for inside rebel camp
//use afghanistan_rebel_camp.vision


//	start_dist = 162;
//	half_dist = 16268.3;
//	half_height = 4759.88;
//	base_height = -144.597;
//	fog_r = 0.74902;
//	fog_g = 0.796079;
//	fog_b = 0.823529;
//	fog_scale = 12;
//	sun_col_r = 1;
//	sun_col_g = 0.941177;
//	sun_col_b = 0.843137;
//	sun_dir_x = 0.305329;
//	sun_dir_y = 0.730931;
//	sun_dir_z = 0.610339;
//	sun_start_ang = 0;
//	sun_stop_ang = 102.152;
//	time = 0;
//	max_fog_opacity = 0.900923;

//	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
//		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
//		sun_stop_ang, time, max_fog_opacity);