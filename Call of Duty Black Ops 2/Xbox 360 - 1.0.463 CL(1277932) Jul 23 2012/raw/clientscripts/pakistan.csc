// pakistan.csc

#include clientscripts\_utility;
#include clientscripts\_glasses;

#insert raw\maps\pakistan.gsh;

main()
{
	// _load!
	clientscripts\_load::main();

	clientscripts\pakistan_fx::main();
	clientscripts\_claw_grenade::main();
	clientscripts\_flamethrower_plight::init();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\pakistan_amb::main();
	thread clientscripts\_fire_direction::init();  // turn on grid shader and extracam for claw fire direction feature
	
	register_clientflag_callback( "actor", CLIENT_FLAG_WATER_FX, ::toggle_water_fx_actor );  // handle water fx for AI
	register_clientflag_callback( "player", CLIENT_FLAG_WATER_FX_PLAYER, ::toggle_water_fx_actor );  // handle water fx for player	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_FROGGER_DEBRIS, ::toggle_water_fx_model );  // handle wakes for frogger debris
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);
	
	println("*** Client : pakistan running...");
	
	level thread frogger_street_wave();
	level thread bus_street_wave();
	level thread bus_street_initial_wave();
	level thread alley_set_underwater_fog();

	//Eckert Footstep setup
	clientscripts\_footsteps::RegisterAITypeFootstepCB("Ally_SEAL_Pakistan_Bigdog", clientscripts\_footsteps::BigDogFootstepCBFunc);
	level thread clientscripts\_audio::enableSwimmingAudio();
}

frogger_street_wave()
{
	level waittill( "frogger_water_surge" );

	s_wave_origin = getstruct( "frogger_water_surge_struct", "targetname" );
	
	const clientnum = 0;
	x_pos = ( s_wave_origin.origin[ 0 ] ) * -1;  // bug: code multiplies these values by -1
	y_pos = ( s_wave_origin.origin[ 1 ] ) * -1;  // bug: code multiplies these values by -1
	const width = 900;
	const speed_scale = 1.6; 
	const amplitude_width_ratio = 0.04;
	const fade_in_start = 0.0;
	const fade_in_end = 900.0;
	const fade_out_start = 1000;
	const fade_out_end = 1750;
	
	SetRippleWave( clientnum, x_pos, y_pos, width, speed_scale, amplitude_width_ratio, fade_in_start, fade_in_end, fade_out_start, fade_out_end );
}

bus_street_wave()
{
	level waittill( "bus_wave_start" );

	s_wave_origin = getstruct( "bus_wave_struct", "targetname" );
	
	const clientnum = 0;
	x_pos = ( s_wave_origin.origin[ 0 ] ) * -1;  // bug: code multiplies these values by -1
	y_pos = ( s_wave_origin.origin[ 1 ] ) * -1;  // bug: code multiplies these values by -1
	const width = 650;
	const speed_scale = 0.90; 
	const amplitude_width_ratio = 0.08;
	const fade_in_start = 0.0;
	const fade_in_end = 10.0;
	const fade_out_start = 1200;
	const fade_out_end = 1500;
	
	SetRippleWave( clientnum, x_pos, y_pos, width, speed_scale, amplitude_width_ratio, fade_in_start, fade_in_end, fade_out_start, fade_out_end );
}

bus_street_initial_wave()
{
	level waittill( "bus_wave_initial_start" );

	s_wave_origin = getstruct( "bus_wave_initial", "targetname" );
	
	const clientnum = 0;
	x_pos = ( s_wave_origin.origin[ 0 ] ) * -1;  // bug: code multiplies these values by -1
	y_pos = ( s_wave_origin.origin[ 1 ] ) * -1;  // bug: code multiplies these values by -1
	const width = 450;
	const speed_scale = 0.8;
	const amplitude_width_ratio = 0.04;
	const fade_in_start = 0.0;
	const fade_in_end = 10.0;
	const fade_out_start = 4100;
	const fade_out_end = 5100;
	
	SetRippleWave( clientnum, x_pos, y_pos, width, speed_scale, amplitude_width_ratio, fade_in_start, fade_in_end, fade_out_start, fade_out_end );
}


alley_set_underwater_fog()
{
	const n_start_dist = 0.000000;
	const n_halfway_dist = 7.249844;
	const n_halfway_height = 2983.752930;
	const n_base_height = -2981.250000;
	const n_red = 0.2211;
	const n_green = 0.1614;
	const n_blue = 0.1018;
	const n_scale = 1;
	const n_sun_red = 0.5469;
	const n_sun_green = 0.5509;
	const n_sun_blue = 0.5679;
	const n_sun_dir_x = 0;
	const n_sun_dir_y = 0;
	const n_sun_dir_z = 0;
	const n_sun_angle_start = 0;
	const n_sun_angle_end = 0;
	const n_max_opacity = 1.000000;
	
	SetWaterFog( n_start_dist, n_halfway_dist, n_halfway_height, n_base_height, n_red, n_green,
	           	n_blue, n_scale, n_sun_red, n_sun_green, n_sun_blue, n_sun_dir_x, n_sun_dir_y, n_sun_dir_z,
	           	n_sun_angle_start, n_sun_angle_end, n_max_opacity );
}