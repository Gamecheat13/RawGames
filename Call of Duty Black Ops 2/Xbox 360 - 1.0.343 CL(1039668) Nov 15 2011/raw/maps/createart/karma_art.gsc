//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
}


// *karma intro fog* (this happens before you put the sunglasses on
// call karma_intro.vision with this fog
// set exposure to 2.0 for this part then blend back to the level default when the glasses go on
karma_fog_intro()
{
	
	CONST start_dist = 716.942;
	CONST half_dist = 7031.62;
	CONST half_height = 3604.27;
	CONST base_height = 0;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 32;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 122.584;
	CONST time = 0;
	CONST max_fog_opacity = 1;
	
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "karma_intro", time );
}



//fog and vision for security
karma_fog_security()
{
	CONST start_dist = 716.942;
	CONST half_dist = 7031.62;
	CONST half_height = 3604.27;
	CONST base_height = 0;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 32;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 122.584;
	CONST time = 0;
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "karma_security", time );
}


//lobby section after security
karma_fog_lobby()
{
	CONST start_dist = 716.942;
	CONST half_dist = 7031.62;
	CONST half_height = 3604.27;
	CONST base_height = 0;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 32;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 122.584;
	CONST time = 0;
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "karma_lobby", time );
}



//karma_fog_tower starts when you enter the outside area after reception
karma_fog_tower()
{
	CONST start_dist = 1421.38;
	CONST half_dist = 40000;
	CONST half_height = 2427.91;
	CONST base_height = 0;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 9.31297;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.498455;
	CONST sun_dir_y = 0.758091;
	CONST sun_dir_z = 0.420525;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 122.584;
	CONST time = 0;
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "karma_elevator_01", time );
}


// daylight fog settings  (this is the settings we should use when the glasses go on)
karma_fog_default( time )
{
	CONST start_dist = 716.942;
	CONST half_dist = 7031.62;
	CONST half_height = 3604.27;
	CONST base_height = 0;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 12;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 122.584;

	if ( !IsDefined( time ) )
	{
		time = 0;
	}
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "karma_daylight", time );
}


// fog for elevator ride down
karma_fog_elevator()
{
	CONST start_dist = 716.942;
	CONST half_dist = 30000;
	CONST half_height = 3604.27;
	CONST base_height = 0;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 12;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 122.584;
	CONST time = 0.0;
	CONST max_fog_opacity = 1;
	
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "karma_daylight", time );
}


// atrium fog
// call karma_atrium.vision 
karma_fog_atrium()
{
	CONST start_dist = 716.942;
	CONST half_dist = 15089.5;
	CONST half_height = 3604.27;
	CONST base_height = -4122.64;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 12;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 119.867;
	CONST time = 0.0;
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "karma_atrium", time );
}


// spiderbot fog
// call karma_spiderbot.vision for this section
karma_fog_spiderbot()
{
	CONST start_dist = 716.942;
	CONST half_dist = 15089.5;
	CONST half_height = 3604.27;
	CONST base_height = -4122.64;
	CONST fog_r = 0.505882;
	CONST fog_g = 0.6;
	CONST fog_b = 0.658824;
	CONST fog_scale = 12;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 119.867;
	CONST time = 0;
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "karma_spiderbot", time );
}


karma_fog_club_entrance()
{
//club entrance fog
//call karma_club_entrance.vision
//switch to this sun color:  0.976984 0.748325 0.497023
	CONST start_dist = 716.942;
	CONST half_dist = 7031.62;
	CONST half_height = 3604.27;
	CONST base_height = 0;
	CONST fog_r = 0.976984;
	CONST fog_g = 0.748325;
	CONST fog_b = 0.497023;
	CONST fog_scale = 12;
	CONST sun_col_r = 1;
	CONST sun_col_g = 1;
	CONST sun_col_b = 1;
	CONST sun_dir_x = 0.848225;
	CONST sun_dir_y = 0.380566;
	CONST sun_dir_z = 0.368354;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 122.584;
	CONST time = 0;
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "karma_club_entrance", time );
}


// club fog
// call karma_club.vision
karma_fog_club()
{
	CONST start_dist = 0;
	CONST half_dist = 326.183;
	CONST half_height = 43.4494;
	CONST base_height = -2756.25;
	CONST fog_r = 0.211765;
	CONST fog_g = 0.384314;
	CONST fog_b = 0.74902;
	CONST fog_scale = 1;
	CONST sun_col_r = 0;
	CONST sun_col_g = 0;
	CONST sun_col_b = 0;
	CONST sun_dir_x = 0;
	CONST sun_dir_y = 0;
	CONST sun_dir_z = 0;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 0;
	CONST time = 0;
	CONST max_fog_opacity = 0.762843;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	VisionSetNaked( "karma_club", time );
}


//sunset fog  (turn this one on when you get to the mall or outdoors.
//call karma_sunset.vision
karma_fog_sunset()
{
	CONST start_dist = 484.422;
	CONST half_dist = 15083.7;
	CONST half_height = 2627.96;
	CONST base_height = -4122.64;
	CONST fog_r = 0.607843;
	CONST fog_g = 0.619608;
	CONST fog_b = 0.611765;
	CONST fog_scale = 10;
	CONST sun_col_r = 0.917647;
	CONST sun_col_g = 0.901961;
	CONST sun_col_b = 0.878431;
	CONST sun_dir_x = 0.265816;
	CONST sun_dir_y = 0.704942;
	CONST sun_dir_z = 0.657571;
	CONST sun_start_ang = 0;
	CONST sun_stop_ang = 44.3601;
	CONST time = 5.0;
	CONST max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "karma_sunset", time );
}