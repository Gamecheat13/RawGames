// Test clientside script for frontend

#include clientscripts\_utility;

main()
{
	// Keep this here for CreateFx
	clientscripts\frontend_fx::main();
	
	level.CLIENT_EXTRACAM_TV_INIT = 100;
	level.CLIENT_EXTRACAM_TV_SINGLE = 101;
	level.CLIENT_EXTRACAM_TV_UL = 102;
	level.CLIENT_EXTRACAM_TV_UR = 103;
	level.CLIENT_EXTRACAM_TV_BL = 104;
	level.CLIENT_EXTRACAM_TV_BR = 105;
	
	// _load!
	clientscripts\_load::main();

	level._client_flagasval_callbacks["scriptmover"] = ::bink_monitor_handler;
	level._client_flagasval_callbacks["player"] = ::whitenoise_handler;

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\frontend_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

//	thread create_spy_camera();
	
	thread settings();
	thread setup_ui3d();

	thread handle_sit_dec20();
	thread handle_stand_dec20();
	
	thread cpu_fov_in();
	thread cpu_fov_out();

	clients = getmaxlocalclients();
	for (i=0;i<clients;i++)
	{
		if (localclientactive(i))
		{
			ForceGameModeMappings( i, "default" );
		}
	}

	PrintLn("*** Client : frontend running...");
}

create_spy_camera()
{
	level thread first_interstitial_camera();
	level endon ("start_first_interstitial");
	
	camera=GetEnt(0,"security_camera","targetname");
	camera isExtraCam(0);
	SetExtraCamFov( 0, 60 );
	last_cam=0;
	while (1)
	{
		wait(10);
		StopExtraCam(0);
		last_cam++;
		if (last_cam>=3)
			last_cam=0;
		switch(last_cam)
		{
		case 0:
			camera=GetEnt(0,"security_camera","targetname");
			camera isExtraCam(0);
			SetExtraCamFov( 0, 60 );
			break;
		case 1:
			camera=GetEnt(0,"security_camera1","targetname");
			camera isExtraCam(0);
			SetExtraCamFov( 0, 60 );
			break;
		case 2:
			camera=GetEnt(0,"security_camera2","targetname");
			camera isExtraCam(0);
			SetExtraCamFov( 0, 60 );
			break;
		}
	}
}

handle_sit_dec20()
{
	self endon( "disconnect" );
	waitforclient(0);

	while( 1 )
	{
		level waittill( "sit_at_dec20" );

		setup_ui3d_full_dec20();
	}
}

handle_stand_dec20()
{
	self endon( "disconnect" );
	waitforclient(0);
	
	while( 1 )
	{
		level waittill( "stand_from_dec20" );

		setup_ui3d_normal();
	}
}

// self == ent that has the flag set or clear on it.
bink_monitor_handler(localClientNum, val) 
{
	if ( val < 64 )
		{
			gridx = 8;
			gridy = 8;
			self mapshaderconstant( localClientNum, 0, "scriptVector0" ); 
			self mapshaderconstant( localClientNum, 1, "scriptVector1" ); 
			self mapshaderconstant( localClientNum, 2, "scriptVector2" );
			self mapshaderconstant( localClientNum, 3, "scriptVector3" );
			self setshaderconstant( localClientNum, 0, val, 0, 0, 0 );
			self setshaderconstant( localClientNum, 1, gridx, gridy, 0, 0 );
	  }
		else if ( val == level.CLIENT_EXTRACAM_TV_INIT )
		{
			self mapshaderconstant( localClientNum, 0, "scriptVector0" ); 
			self mapshaderconstant( localClientNum, 1, "scriptVector1" ); 
			self mapshaderconstant( localClientNum, 2, "scriptVector2" );
			self mapshaderconstant( localClientNum, 3, "scriptVector3" );
		}
		else if ( val == level.CLIENT_EXTRACAM_TV_SINGLE )
		{
			//self setshaderconstant( localClientNum, 2, 0, 0, 1, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 2, 0, 0, 1, 1 );  // UVs
			self setshaderconstant( localClientNum, 3, 1, 0, 0, 0 );     // 1 means turn on extracam, 0 means use the bink video
		}
		else if ( val == level.CLIENT_EXTRACAM_TV_SINGLE )
		{
			//self setshaderconstant( localClientNum, 2, 0, 0, 1, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 2, 0, 0, 1, 1 );  // UVs
			self setshaderconstant( localClientNum, 3, 1, 0, 0, 0 );     // 1 means turn on extracam, 0 means use the bink video
		}
		else if ( val == level.CLIENT_EXTRACAM_TV_UL )
		{
			//self setshaderconstant( localClientNum, 2, 0, 0, 1, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 2, 0, 0, 0.5, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 3, 1, 0, 0, 0 );     // 1 means turn on extracam, 0 means use the bink video
		}
		else if ( val == level.CLIENT_EXTRACAM_TV_UR )
		{
			//self setshaderconstant( localClientNum, 2, 0, 0, 1, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 2, 0.5, 0, 1, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 3, 1, 0, 0, 0 );     // 1 means turn on extracam, 0 means use the bink video
		}
		else if ( val == level.CLIENT_EXTRACAM_TV_BL )
		{
			//self setshaderconstant( localClientNum, 2, 0, 0, 1, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 2, 0, 0.5, 0.5, 1 );  // UVs
			self setshaderconstant( localClientNum, 3, 1, 0, 0, 0 );     // 1 means turn on extracam, 0 means use the bink video
		}
		else if ( val == level.CLIENT_EXTRACAM_TV_BR )
		{
			//self setshaderconstant( localClientNum, 2, 0, 0, 1, 0.5 );  // UVs
			self setshaderconstant( localClientNum, 2, 0.5, 0.5, 1, 1 );  // UVs
			self setshaderconstant( localClientNum, 3, 1, 0, 0, 0 );     // 1 means turn on extracam, 0 means use the bink video
		}
			
}

whitenoise_handler(localClientNum, val) 
{
	ShowUI(localClientNum,"whitenoise_frontend_tv",val);
}

setup_ui3d_normal()
{
	if( isps3() ) 
	{
		// split our w=1024 h=512 texture left/right
		// 2 x (w=512, h=512)  instead of 2 x (w=1024, h=256) nonsense
		ui3dsetwindow( 0, 0, 0, 0.5, 1 );
		ui3dsetwindow( 1, 0.5, 0, 0.5, 1 );
	}
	else
	{
		// split our w=1024 h=1024 top/bottom
		// 2 x (w=1024, h=512) -- this looks slightly better than 512x1024.
		ui3dsetwindow( 0, 0, 0, 1, 0.5 );
		ui3dsetwindow( 1, 0, 0.5, 1, 0.5 );
	}
}

setup_ui3d_full_dec20()
{
	ui3dsetwindow( 0, 0, 0, 0, 0 );
	if( isps3() ) 
	{
		// 640 x 480 of a 1024x512 buffer
		ui3dsetwindow( 1, 0, 0, 0.625, 0.9375 );
	}
	else
	{
		// 640 x 480 of a 1024x1024 buffer
		ui3dsetwindow( 1, 0, 0, 1, 1 );
	}
}

setup_ui3d()
{
	//waitforclient(0);
	
	setup_ui3d_normal();
	ui3dsetwindow( 2, 0, 0, 0, 0 );
	ui3dsetwindow( 3, 0, 0, 0, 0 );
	ui3dsetwindow( 4, 0, 0, 0, 0 );
	ui3dsetwindow( 5, 0, 0, 0, 0 );
}

settings()
{
	SetClientDvar( "hud_showstance", 0 );
	SetClientDvar( "compass", 0);
}

create_fakeplayer_camera()
{
	while(1)
	{
		camera=GetEnt(0,"fakeplayer_camera","targetname");
		camera isExtraCam(0);
		SetExtraCamFov( 0, 30 );
		
		level waittill ("tv_extracam_off");
		StopExtraCam(0);
		
		camera=GetEnt(0,"fakeplayer_camera_off","targetname");
		camera isExtraCam(0);
		SetExtraCamFov( 0, 30 );
		
		level waittill ("tv_extracam_on");
		StopExtraCam(0);
	}
}

first_interstitial_camera()
{
	level waittill ("start_first_interstitial");
	StopExtraCam(0);
	camera=GetEnt(0,"fakeplayer_camera","targetname");
	camera isExtraCam(0);
	SetExtraCamFov( 0, 25 );
		
	//level waittill ("tv_fov_in");
	//SetExtraCamFov( 0, 25 );
}

cpu_fov_in()
{
	while(1)
	{
		level waittill ("cpu_fov_in");
		thread lerp_fov_overtime( 0.4, 47 );
	}
}

cpu_fov_out()
{
	while(1)
	{
		level waittill ("cpu_fov_out");
		thread lerp_fov_overtime( 0.4, 65 );
	}
}


/@
"Name: lerp_fov_overtime( <time> , <destfov> )"
"Summary: lerps from the current cg_fov value to the destfov value linearly over time"
"Module: Player"
"CallOn: a player"
"MandatoryArg: <time>: time to lerp"
"OptionalArg: <destfov>: field of view to go to"
"Example: players[0] thread lerp_fov_overtime(2.0, 45);"
"SPMP: singleplayer"
@/
lerp_fov_overtime( time, destfov )
{
	level notify ("new_fov_lerp");
	level endon ("new_fov_lerp");
	
	basefov = GetDvarfloat( "cg_fov" );
	incs = int( time/.017 );
	incfov = (  destfov  -  basefov  ) / incs ;
	currentfov = basefov;
	
	// AE 9-17-09: if incfov is 0 we should move on without looping
	if(incfov == 0)
	{
		return;
	}

	for ( i = 0; i < incs; i++ )
	{
		currentfov += incfov;
		SetClientDvar( "cg_fov", currentfov );
		wait .017;
	}
	//fix up the little bit of rounding error. not that it matters much .002, heh
	SetClientDvar( "cg_fov", destfov );
}
