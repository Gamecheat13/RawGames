// Test clientside script for blackout

#include clientscripts\_filter;
#include clientscripts\_glasses;
#include clientscripts\_utility;

#define CLIENT_FLAG_INTRO_EXTRA_CAM		11
#define CLIENT_FLAG_BLOOD_SHOULDER		12
#define CLIENT_FLAG_HACK_BINK			13
#define CLIENT_FLAG_MIRROR_EXTRA_CAM 	14
#define CLIENT_FLAG_MESSIAH_MODE		15

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\blackout_fx::main();
	clientscripts\_gasmask::init();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\blackout_amb::main();
	
	// fog watcher
	thread sensitive_geo_fog();
	
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_INTRO_EXTRA_CAM, ::toggle_intro_extra_cam );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_MIRROR_EXTRA_CAM, ::toggle_mirror_extra_cam );
	register_clientflag_callback( "actor", CLIENT_FLAG_BLOOD_SHOULDER, ::blood_shoulder );
	register_clientflag_callback( "actor", CLIENT_FLAG_HACK_BINK, ::hack_bink );
	register_clientflag_callback( "player", CLIENT_FLAG_MESSIAH_MODE, ::set_flag_messiah_mode );

	thread run_intro_cam();
	
	// Load the messiah filter.
	init_filter_massiah( level.localPlayers[0] );
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : blackout running...");
}

sensitive_geo_fog()
{
	level waittill( "fog_level_increase" );
	SetWorldFogActiveBank( 0, 2 );
	
	level waittill( "fog_level_increase" );
	SetWorldFogActiveBank( 0, 4 );
	
	level waittill( "fog_level_increase" );
	SetWorldFogActiveBank( 0, 8 );
}

lerp_cam_fov(time_s, old_fov, new_fov)
{
	// sixty frames per second.
	frame_time_s = 1 / 60.0;
	n_lerp_frames = time_s / frame_time_s;
	
	for (n_frame = 1; n_frame <= n_lerp_frames; n_frame++)
	{
		pct = n_frame / n_lerp_frames;
		cur_fov = old_fov + (pct * (new_fov - old_fov));
		SetExtraCamFov( 0, cur_fov );
		
		wait frame_time_s;
	}
	
	SetExtraCamFov( 0, new_fov );
}

min_max( val, min, max )
{
	if ( val < min )
	{
		return min;
	} else if ( val > max ) {
		return max;
	} else {
		return val;
	}
}

extra_cam_mirror_fov()
{
	level endon( "mirror_off" );
	
	frame_time_s = 1 / 60.0;
	dist_min = 0;
	dist_max = 512;
	fov_min = 70;
	fov_max = 40;
	
	player = GetLocalPlayers()[0];
	
	while ( true )
	{
		cam_pos = player GetCamPos();
		dist = Distance2D( self.origin, cam_pos );
		dist = min_max( dist, dist_min, dist_max );
		dist_pct = ( dist - dist_min ) / ( dist_max - dist_min );
		fov = fov_min + (( fov_max - fov_min ) * dist_pct);
		SetExtraCamFov( 0, fov );
		wait frame_time_s;
	}
}

// runs the extra cam for the intro.
toggle_intro_extra_cam( localClientNum, set, newEnt )
{
    if ( !IsDefined( level.extraCamActive ) )
    {
        level.extraCamActive = false;
    }
    
    if ( !level.extraCamActive && set )
    {
        PrintLn( "**** extra cam on - client ****" );
                    
        level.extraCamActive = true;
        self IsExtraCam( localClientNum );
        SetExtraCamFov( 0, 60 );
    }
    else if ( level.extraCamActive && !set )
    {
        PrintLn( "**** extra cam off - client ****" );
        StopExtraCam( localClientNum );
        level.extraCamActive = false;
    }
}

toggle_mirror_extra_cam( localClientNum, set, newEnt )
{
	if ( !IsDefined( level.extraCamActive ) )
    {
        level.extraCamActive = false;
        level notify( "mirror_off" );
    }
    
    if ( !level.extraCamActive && set )
    {
        PrintLn( "**** extra cam on - client ****" );
                    
        level.extraCamActive = true;
        self IsExtraCam( localClientNum );
        self extra_cam_mirror_fov();
    }
    else if ( level.extraCamActive && !set )
    {
        PrintLn( "**** extra cam off - client ****" );
        
        level notify( "mirror_off" );
        SetExtraCamFov( 0, 60 );
        StopExtraCam( localClientNum );
        level.extraCamActive = false;
    }
}

//runs FOV change on camera
run_intro_cam()
{	
	level endon( "intro_cctv_complete" );
	
	level waittill( "intro_cctv_assigned" );
	
	const cloth_fov = 1.0;
	const ear_fov = 10;
	const scene_fov = 60;

	// start the extra cam at 20deg fov (cloth)
	SetExtraCamFov( 0, cloth_fov );	

	level waittill ( "intro_cctv_started" );
	
	wait 3.0;
	
	// then move out to 30deg fov (ear)
	lerp_cam_fov( 3, cloth_fov, ear_fov );
	
	wait 5.0;
	
	// then move out to view the scene
	lerp_cam_fov( 3, ear_fov, scene_fov );
}

hack_bink( localClientNum, set, newEnt )
{
	if ( set )
	{
		level.screen_bink = PlayBink( "blackout_virus", 2 );
	} else {
		StopBink( level.screen_bink );
	}
}

blood_shoulder( localClientNum, set, newEnt )
{
	self MapShaderConstant( localClientNum, 0, "ScriptVector0" );
	
	PrintLn( "**** starting blood shoulder - client ****" );
	
	UNUSED = 0;
	N_TRANSITION_TIME = 5;
	
	s_timer = new_timer();
	
	do
	{
		wait .01;
		
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = LerpFloat( 0, 0.8, n_current_time / N_TRANSITION_TIME );
		
		self SetShaderConstant( localClientNum, 0, UNUSED, n_delta_val, UNUSED, UNUSED );
	}
	while ( n_current_time < N_TRANSITION_TIME );
}

new_timer()
{
	s_timer = SpawnStruct();
	s_timer.n_time_created = GetRealTime();
	return s_timer;
}

get_time()
{
	t_now = GetRealTime();
	return t_now - self.n_time_created;
}

get_time_in_seconds()
{
	return get_time() / 1000;
}

set_flag_messiah_mode( localClientNum, set, newEnt )
{
	if ( !isdefined( level.messiah_mode_on ) )
	{
		level.messiah_mode_on = !set;
	}
	
	if( set && !level.messiah_mode_on )
	{
		enable_filter_massiah( level.localPlayers[0], 1 );
		set_filter_massiah_amount( level.localPlayers[0], 1, 1.0 );
	}
	else if ( !set && level.messiah_mode_on )
	{
		disable_filter_massiah( level.localPlayers[0], 1 );
	}
	
	level.messiah_mode_on = set;
}

