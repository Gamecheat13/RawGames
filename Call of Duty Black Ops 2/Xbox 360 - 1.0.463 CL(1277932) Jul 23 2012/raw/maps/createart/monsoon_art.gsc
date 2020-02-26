//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;


main()
{
	start_dist = 1891.13;
	half_dist = 22740.3;
	half_height = 7787.74;
	base_height = -2147.44;
	fog_r = 0.537255;
	fog_g = 0.756863;
	fog_b = 0.756863;
	fog_scale = 1.02711;
	sun_col_r = 0.913726;
	sun_col_g = 1;
	sun_col_b = 1;
	sun_dir_x = -0.285085;
	sun_dir_y = 0.892164;
	sun_dir_z = 0.350385;
	sun_start_ang = 0;
	sun_stop_ang = 52.8329;
	time = 0;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
	    sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
	    sun_stop_ang, time, max_fog_opacity);
	    
	    //////rimlighting////////
    SetSavedDvar( "r_rimIntensity_debug", 1 );
    SetSavedDvar( "r_rimIntensity", 15 );	
    
    	///////////Hero Lighting///////////////
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1 );
	SetSavedDvar( "r_lightGridContrast", 0 );

	// setup vision set triggers
	vs_trigs = GetEntArray( "visionset", "targetname" );
	array_thread( vs_trigs, ::vision_set );
}

vision_set()
{
	//AssertEx( IsDefined(self.script_noteworthy), "vision_set:: trigger needs to have a script_noteworthy for the vision set" );

	time = 2.0;
	if ( IsDefined( self.script_float ) )
		time = self.script_float;

	while(1) 
	{
		self waittill("trigger");

	 	player = get_players()[0];
		if (player GetVisionSetNaked() != self.script_noteworthy)
			VisionSetNaked(self.script_noteworthy, time);
	}
}

