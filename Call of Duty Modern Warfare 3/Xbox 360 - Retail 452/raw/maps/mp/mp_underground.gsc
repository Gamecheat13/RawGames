
main()
{
	maps\mp\mp_underground_precache::main();
	maps\createart\mp_underground_art::main();
	maps\mp\mp_underground_fx::main();
	
	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_underground" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_underground" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
	
	thread ac130_thread();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "arena", 0.15, 0.9, 2 );
}

ac130_thread()
{
	// this is the default speed for planes.  Override by setting speed = value on the script_model for the
	// start of the plane's path
	default_speed = 1200;
	// how many plane groups there are in the map
	num_plane_groups = 3;
	
	index = 0;
	while ( 1 )
	{
		index = ( index % num_plane_groups ) + 1;
		start_spots = getEntArray( "ac130_overhead_" + index , "targetname" );
		greatest_time = 0;
		planes = [];
		foreach ( spot in start_spots )
		{
			plane = Spawn( "script_model" , spot.origin );
			plane.angles = spot.angles;
			// The plane will use the value of "model" on the starting spot 
			// (a script_origin with ac130_overhead_# as targetname)
			plane SetModel( spot.model );
			target = getEnt( spot.target , "targetname" );
			dist = Distance( target.origin , spot.origin );
			speed = default_speed;
			if ( IsDefined( spot.speed ))
		    {
				speed = spot.speed;			    	
		    }
			time = dist / speed;
			if ( time > greatest_time )
			{
				greatest_time = time;	
			}
			plane moveto( target.origin , time );
			plane thread play_plane_fx( time );
			planes[planes.size] = plane;
		}
		// wait for planes to finish
		wait greatest_time;
		foreach ( plane in planes )
		{
			plane notify( "delete_plane" );
			wait 0.05;
			plane Delete();
		}
		wait( RandomFloatRange( 5 , 20 ));
	}
}

play_plane_fx( time )
{
	self endon( "delete_plane" );
	
	// play any fx, sounds for the plane.  It will fly for "time" seconds
}