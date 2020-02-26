#include maps\_utility;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_glasses.gsh;

//
//	To use the glasses interface, just add this to your level csv:
//		include,glasses
//
//	The main commands you will need to use are:
//		get_extracam() - Move the ent this returns or level.e_extra_cam to manipulate what you see via extra cam.
//		turn_on_extra_cam()
//		turn_off_extra_cam()
//		play_bink_on_hud( "bink moviename" )
//		stop_bink_on_hud()
//
//	Some supplementary commands:
//		play_bootup()
//
//	
autoexec init()
{
	get_extracam();
	
	glasses_precache();

	flag_init( "glasses_bink_playing" );
}

/@
"Name: get_extracam()"
"Summary: Get the current extracam ent (used for the camera origin and facing).  If it doesn't exist, create an new one."
"CallOn: N/A"
"Example: e_camera = get_extracam();"
"SPMP: singleplayer"
@/
get_extracam()
{
	if ( !Isdefined( level.e_extra_cam ) )
	{
		level.e_extra_cam = Spawn( "script_model", (0, 0, 0) );
		level.e_extra_cam SetModel( "tag_origin" );
		level.e_extra_cam.angles = ( 0, 0, 0 );
	}	
	
	return level.e_extra_cam;
}


//
//	All of the LUI command strings need to be precached
glasses_precache()
{
	// Commands
	PreCacheString( &"hud_shades_bootup" );
	//PreCacheString( &"register_pip_material" );
	PreCacheString( &"extracam_show" );
	PreCacheString( &"extracam_hide" );
	PreCacheString( &"cinematic_start" );
	PreCacheString( &"cinematic_stop" );
	PreCacheString( &"hud_hide_shadesHud" );
	PreCacheString( &"hud_show_shadesHud" );
	PrecacheString( &"fullscreen_pip" );
	PrecacheString( &"minimize_fullscreen_pip" );
	PrecacheString( &"hud_perform_wipe" );
	
	// Materials
	PreCacheString( &"extracam_glasses" );
	PreCacheString( &"generic_filter_karma_club_extracam" );
//	PreCacheString( &"mtl_karma_retina_bink" );
	PreCacheString( &"cinematic" );
	PrecacheString( &"extracam_glasses_no_distortion" ); //[fxville-ceng 4-25-2012] For mov_anim_test tool.
	
	// Shaders
//	PrecacheShader( "mtl_karma_retina_bink" );
	PrecacheShader( "cinematic" );
	
	// Menus (for lui menu response)
	PreCacheMenu( "lui" );
	PrecacheMenu( "cinematic" );
}


/@
"Name: play_bootup()"
"Summary: Play the glasses bootup sequence"
"CallOn: N/A"
"Example: play_bootup();"
"SPMP: singleplayer"
@/
play_bootup()
{
	LUINotifyEvent( &"hud_shades_bootup" );
}

/@
"Name: perform_visor_wipe( [duration] )"
"Summary: Perform the bootup visor wipe any where ingame. Should not be called for the predetermine bootup sequences/events. Visor images need to be included in the level fastfile."
"OptionalArg: [duration] Pass in the amount of time it should take for shades to perform the wipe in seconds. Default is 2."
"CallOn: N/A"
"Example: perform_visor_wipe( 2 );"
"SPMP: singleplayer"
@/
perform_visor_wipe( duration = 2)
{
	LUINotifyEvent( &"hud_perform_wipe", 1, Int( duration*1000 ) );
}

/@
"Name: make_pip_fullscreen( [duration] )"
"Summary: Makes the pip fullscreen."
"OptionalArg: [duration] Pass in the amount of time it should take for the pip to become fullscreen in seconds. Default is 1."
"CallOn: N/A"
"Example: make_pip_fullscreen( 1 );"
"SPMP: singleplayer"
@/
make_pip_fullscreen( duration = 1 )
{
	LUINotifyEvent( &"fullscreen_pip", 1, Int( duration*1000 ) );
}

/@
"Name: shrink_pip_fullscreen( [duration] )"
"Summary: Makes the pip shrink from the fullscreen to its regular size."
"OptionalArg: [duration] Pass in the amount of time it should take for the fullscreen pip to change back to its regular in seconds. Default is 1."
"CallOn: N/A"
"Example: shrink_pip_fullscreen( 1 );"
"SPMP: singleplayer"
@/
shrink_pip_fullscreen( duration = 1 )
{
	LUINotifyEvent( &"minimize_fullscreen_pip", 1, Int( duration*1000 ) );
}

/@
"Name: turn_on_extra_cam( [str_shader_override], [str_custom_notify], [should_start_fullscreen] )"
"Summary: Turn on the extra cam."
"CallOn: N/A"
"OptionalArg: [str_shader_override] Pass in a precached string name of a different shader to use."
"OptionalArg: [str_custom_notify] Precached string that will override the extracam_show LUI notify for special extracam situations"
"OptionalArg: [should_start_fullscreen] Check if we should start the extra cam in fullscreen."
"Example: turn_on_extra_cam( "my_bink_movie" );"
"SPMP: singleplayer"
@/
turn_on_extra_cam( str_shader_override, str_custom_notify, should_start_fullscreen = false )
{
	// set up LUI command to show extracam window
	str_extracam_show = &"extracam_show";
	
	if ( IsDefined( str_custom_notify ) )
	{
		str_extracam_show = str_custom_notify;
	}
	
	// set up shader to use on extracam window
	str_shader = &"extracam_glasses";
	
	if ( IsDefined( str_shader_override ) )
	{
		str_shader = str_shader_override;
	}
	
	// should start in fullscreen check
	inFullscreen = 0; //false
	if( should_start_fullscreen )
	{
		inFullscreen = 1; //true
	}
	
	//SOUND - Shawn J
	level.pip_sound_ent = spawn( "script_origin", level.player.origin);
	level.player playsound ("evt_pip_on");
	//Playing the loop on the ent does not work in this function, but it does if it is played on the player.
	level.pip_sound_ent playloopsound( "evt_pip_loop", 1 );
	//level.player playloopsound( "evt_pip_loop", 1 );
	//iprintlnbold ("PiP_ON");
	
	level.e_extra_cam SetClientFlag( CLIENT_FLAG_GLASSES_CAM );
	LUINotifyEvent( str_extracam_show, 2, str_shader, inFullscreen );
}


/@
"Name: turn_on_extra_cam( [str_shader_override], [str_custom_notify] )"
"Summary: Turn off the extra cam."
"CallOn: N/A"
"OptionalArg: [str_shader_override] Pass in a precached string name of a different shader to use."
"OptionalArg: [str_custom_notify] Precached string that will override the extracam_hide LUI notify for special extracam situations."
"Example: turn_on_extra_cam( "event_specific_shader" );"
"SPMP: singleplayer"
@/
turn_off_extra_cam( str_shader_override, str_custom_notify )
{
	Assert( isdefined( level.e_extra_cam ), "level.e_extra_cam isn't defined, call _glasses::main" );

	// set up LUI command to show extracam window
	str_extracam_hide = &"extracam_hide";
	
	if ( IsDefined( str_custom_notify ) )
	{
		str_extracam_hide = str_custom_notify;
	}
	
	// set up shader to use on extracam window
	str_shader = &"extracam_glasses";
	
	if ( IsDefined( str_shader_override ) )
	{
		str_shader = str_shader_override;
	}
		
	//SOUND - Shawn J
	level.player playsound ("evt_pip_off");
	level.pip_sound_ent stoploopsound ();
	//level.player stoploopsound ();
	level.pip_sound_ent delete();
	//iprintlnbold ("PiP_Off");
	
	level.e_extra_cam ClearClientFlag( CLIENT_FLAG_GLASSES_CAM );
	LUINotifyEvent( str_extracam_hide, 1, str_shader );
}

/@
"Name: play_bink_on_hud( <str_bink_name>, [b_looping], [b_in_memory], [b_paused], [b_sync_audio], [is_in_memory], [n_duration], [n_x], [n_y], [n_width], [n_height] )"
"Summary: Play a Bink movie on the hud glasses.  The name of the movie must be precached first (e.g. PrecacheString( &"cool_bink" ); "
"CallOn: N/A"
"MandatoryArg: <str_bink_name> The string name of the Bink movie (e.g. "cool_bink")."
"OptionalArg: [b_looping] Tell the movie to loop."
"OptionalArg: [b_in_memory] The movie is loaded in memory."
"OptionalArg: [b_paused] Start paused."
"OptionalArg: [b_sync_audio] Sync the audio to the movie."
"Example: play_bink_on_hud( "my_bink_movie" );"
"SPMP: singleplayer"
@/
play_bink_on_hud( str_bink_name, b_looping = false, b_in_memory = false, b_paused = false, b_sync_audio = false, should_start_fullscreen = false )
{
	Assert( IsDefined( str_bink_name ), "Undefined Bink name" );

	// should start in fullscreen check
	inFullscreen = 0; //false
	if( should_start_fullscreen )
	{
		inFullscreen = 1; //true
	}
	
	//LUINotifyEvent( &"register_pip_material", 1, &"mtl_karma_retina_bink" );
	LUINotifyEvent( &"cinematic_start", 7, &"cinematic", IString( str_bink_name ), b_looping, b_in_memory, b_paused, b_sync_audio, inFullscreen );
	
	// Wait for it to start
	str_menu = "";
	while( str_menu != "cinematic" )
	{
		level.player waittill( "menuresponse", str_menu, str_cin_id ); //wait for the bink to START playing
	}
	flag_set( "glasses_bink_playing" );
	
	//SOUND - Shawn J
	level.pip_sound_bink_ent = spawn( "script_origin", level.player.origin );
	level.player playsound ("evt_pip_on");
	level.pip_sound_bink_ent playloopsound( "evt_pip_loop", 1 );
	//iprintlnbold ("PiP_BINK_ON");

	if ( !b_looping )
	{
		n_cin_id = int( str_cin_id );
		// Must wait for the preload before checking time remaining
		while( IsCinematicPreloading( n_cin_id ) )
		{
			wait .05;
		}
		
		// Wait for it to end
		time_remaining = GetCinematicTimeRemaining( n_cin_id );
		assert( time_remaining >= 0, "GetCinematicTimeRemaining for " + str_bink_name + " returned less than 0 time remaining." );

		// Wait for it to finish playing
		if ( time_remaining > 1 )
		{
			wait( time_remaining );
		}
		else
		{
			wait( time_remaining - 1 );
		}

		stop_bink_on_hud();
	}
}


/@
"Name: stop_bink_on_hud()"
"Summary: Turn off the bink playing on the hud
"CallOn: N/A"
"Example: stop_bink_on_hud();"
"SPMP: singleplayer"
@/
stop_bink_on_hud()
{
	level endon( "bink_timeout" );
	
	//SOUND - Shawn J
	level.player playsound ("evt_pip_off");
	level.pip_sound_bink_ent stoploopsound ();
	level.pip_sound_bink_ent delete();
	//iprintlnbold ("PiP_BINK_Off");
	
	thread _bink_timeout( 1.5 );
	
	LUINotifyEvent( &"cinematic_stop", 1, &"cinematic" );
	str_menu = "";
	while( str_menu != "cinematic" )
	{
		level.player waittill( "menuresponse", str_menu, n_cin_id ); //wait for the bink to STOP playing
	}
	
	flag_clear( "glasses_bink_playing" );
}


_bink_timeout( n_time )
{
	wait n_time;
	
	level notify( "bink_timeout" );
	flag_clear( "glasses_bink_playing" );
}