// Test clientside script for karma

#include clientscripts\_utility;
#include clientscripts\_filter;
#include clientscripts\_glasses;
#include clientscripts\_argus;

#insert raw\maps\karma.gsh;


//*****************************************************************************
//*****************************************************************************

main()
{
	// This MUST be first for CreateFX!	
	clientscripts\karma_fx::main();
	
	// _load!
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\karma_amb::main();
	
	clientscripts\_driving_fx::init();
	clientscripts\_spiderbot_ride::init();

	register_clientflag_callback( "scriptmover", 	CLIENT_FLAG_FACE_SWAP_INIT, 	::face_swap_init );
	register_clientflag_callback( "scriptmover", 	CLIENT_FLAG_FACE_SWAP, 			::face_swap_other );
	register_clientflag_callback( "scriptmover", 	CLIENT_FLAG_FACE_SWAP_PLAYER,	::face_swap_player );
	register_clientflag_callback( "actor", 			CLIENT_FLAG_ENEMY_HIGHLIGHT, ::tresspasser_on );
	
	level.onArgusNotify = ::onArgusNotify;

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	// Set ui3d window
	//ui3dsetwindow( 0, 0, 0, 1, 1 );		

	println("*** Client : karma running...");

	level thread increase_lighting();

             


	//****************
	// EXTRA CAM SETUP
	//****************
        level thread do_lowlight();        
	
	//init_sw_cam();
	//level.extraCamActive = false;
	level thread fov_listener( "fov_zoom_e7_defalco_chase", 16 );	// 18
	level thread fov_listener( "fov_zoom", 10 );
	level thread fov_listener( "fov_zoom_hi", 3 );
	level thread fov_listener( "fov_normal", 70 );
}

do_lowlight()
{
    init_filter_karma_lowlight( level.localPlayers[0] );
        
    while( true )
    {
        level waittill( "lowlight_on" );
        
        enable_filter_karma_lowlight(level.localPlayers[0], 0 );
        level waittill( "lowlight_off" );
        
    	disable_filter_karma_lowlight(level.localPlayers[0], 0 );
	}
}

//
//	layer 0 - Ad Banner
//	layer 1 - Hero face
//	layer 2 - Player face
//	layer 3 - ?
//	layer 4 - Default face  (can't manipulate)
face_swap_init( localClientNum, set, newEnt  )
{
	a_n_layer_transparency[ 0 ] = 0;
	a_n_layer_transparency[ 1 ] = 1;
	a_n_layer_transparency[ 2 ] = 1;
	a_n_layer_transparency[ 3 ] = 0;
	a_n_layer_transparency[ 4 ] = 1;

	self thread face_swap( localClientNum, a_n_layer_transparency );
}

//
//	layer 0 - Ad Banner
//	layer 1 - Hero face
//	layer 2 - Player face
//	layer 3 - ?
//	layer 4 - Default face  (can't manipulate)
face_swap_other( localClientNum, set, newEnt  )
{
	if ( set )
	{
		a_n_layer_transparency[ 0 ] = 0;
		a_n_layer_transparency[ 1 ] = 0;
		a_n_layer_transparency[ 2 ] = 1;
		a_n_layer_transparency[ 3 ] = 1;
		a_n_layer_transparency[ 4 ] = 1;
	}
	else
	{
		a_n_layer_transparency[ 0 ] = 0;
		a_n_layer_transparency[ 1 ] = 1;
		a_n_layer_transparency[ 2 ] = 1;
		a_n_layer_transparency[ 3 ] = 0;
		a_n_layer_transparency[ 4 ] = 1;
	}

	self thread face_swap( localClientNum, a_n_layer_transparency );
}

//
//	layer 0 - Ad Banner
//	layer 1 - Hero face
//	layer 2 - Player face
//	layer 3 - ?
//	layer 4 - Default face  (can't manipulate)
face_swap_player( localClientNum, set, newEnt )
{
	if ( set )
	{
		a_n_layer_transparency[ 0 ] = 0;
		a_n_layer_transparency[ 1 ] = 1;	// Squad face transparent
		a_n_layer_transparency[ 2 ] = 0;	// Player face on
		a_n_layer_transparency[ 3 ] = 1;
		a_n_layer_transparency[ 4 ] = 1;
	}
	else
	{
		a_n_layer_transparency[ 0 ] = 0;	// Ad banner
		a_n_layer_transparency[ 1 ] = 1;	// Squad face on
		a_n_layer_transparency[ 2 ] = 1;	// Player face transparent
		a_n_layer_transparency[ 3 ] = 0;
		a_n_layer_transparency[ 4 ] = 1;
	}

	self thread face_swap( localClientNum, a_n_layer_transparency );
}


//
//	Do face swaps on a texture
//		a_n_target_val = target transparency value
face_swap( localClientNum, a_n_target_val )
{
	self notify( "face_swap_end" );

	self endon( "face_swap_end" );

	self mapshaderconstant( localClientNum, 0, "ScriptVector0" ); 		
	self mapshaderconstant( localClientNum, 1, "ScriptVector1" ); 		

	// init var if necessary
	if ( !IsDefined( self.n_layer_transparency ) )
	{
		for( i=0; i<a_n_target_val.size; i++ )
		{
			self.n_layer_transparency[ i ] = a_n_target_val[ i ];
		}
	}

	// figure out what the step direction is
	a_n_step = [];
	for( i=0; i<a_n_target_val.size; i++ )
	{
		if ( self.n_layer_transparency[ i ] < a_n_target_val[ i ] )
		{
			a_n_step[ i ] = 0.02;
		}
		else if ( self.n_layer_transparency[ i ] > a_n_target_val[ i ] )
		{
			a_n_step[ i ] = -0.02;
		}
		else
		{
			a_n_step[ i ] = 0;
		}
	}

	n_step_time = 0.02;
	b_transitioning = true;

	// now smooth transition the values.	
	while( b_transitioning )
	{
		b_transitioning = false;
		for( i=0; i<self.n_layer_transparency.size; i++ )
		{
			self.n_layer_transparency[ i ] += a_n_step[ i ];
			if ( self.n_layer_transparency[ i ] != a_n_target_val[ i ] )
			{
				b_transitioning = true;
				// bounds check
				if ( ( a_n_step[ i ] > 0 && self.n_layer_transparency[ i ] > a_n_target_val[ i ] ) ||
				     ( a_n_step[ i ] < 0 && self.n_layer_transparency[ i ] < a_n_target_val[ i ] ) )
				{
					self.n_layer_transparency[ i ] = a_n_target_val[ i ];
				}
			}
		}

		self setshaderconstant( localClientNum, 0, self.n_layer_transparency[ 0 ], self.n_layer_transparency[ 1 ], self.n_layer_transparency[ 2 ], self.n_layer_transparency[ 3 ] );
		wait( n_step_time );
	}

	self setshaderconstant( localClientNum, 0, a_n_target_val[ 0 ], a_n_target_val[ 1 ], a_n_target_val[ 2 ], a_n_target_val[ 3 ] );
//	self setshaderconstant( localClientNum, 1, self.n_layer_transparency[ 4 ], 0, 0, 0 );
}

tresspasser_on( localClientNum, set, newEnt )
{
	self mapshaderconstant( localClientNum, 2, "ScriptVector3" ); 
	
	if ( set )
	{
		self setshaderconstant( localClientNum, 2, 1, 0, 0, 0 );
	}
	else
	{
		decrement = 0;
		
		while(1)
		{
			self setshaderconstant( localClientNum, 2, 1 - decrement, 0, 0, 0 );
			decrement += RandomFloatRange(0.01, 0.05);
			
			if(decrement >= 1)
			{
				self setshaderconstant( localClientNum, 2, 0, 0, 0, 0 );
				break;
			}
			wait(0.05);
		}
	}
}

argusBuildUI( localClientNum, userTag)
{
	switch(userTag)
	{
	case "heli_vtol":
		return argusImageAndText2UI(localClientNum,"white",&"KARMA_ARGUS_HELI_VTOL",&"KARMA_ARGUS_HELI_VTOL_INFO");
	case "metal_storm":
		return argusImageAndText2UI(localClientNum,"white",&"KARMA_ARGUS_METAL_STORM",&"KARMA_ARGUS_METAL_STORM_INFO");
	case "al_jinan":
		return argusImageAndText2UI(localClientNum,"white",&"KARMA_ARGUS_AL_JINAN",&"KARMA_ARGUS_AL_JINAN_INFO");
	case "scanner":
		return argusImageAndText2UI(localClientNum,"white",&"KARMA_ARGUS_SCANNER",&"KARMA_ARGUS_SCANNER_INFO");
	case "heli_hip":
		return argusImageAndText2UI(localClientNum,"white",&"KARMA_ARGUS_HELI_HIP",&"KARMA_ARGUS_HELI_HIP_INFO");
	}
}

onArgusNotify( localClientNum, argusID, userTag, message )
{
	switch( message )
	{
	case "buildui":
		//construct the ui elem and return it - the system will manage it from that point
		return argusBuildUI(localClientNum,userTag);
	case "create":
		ArgusSetBracket(argusID,"square_bound");
		switch ( userTag )
		{
			case "heli_hip":
//				ArgusSetOffset( argusID, (69, 13, 94 ) );
				ArgusSetDistance( argusID, 20000 );
				break;
			case "heli_vtol":
//				ArgusSetOffset( argusID, (0, 100, 130 ) );
				ArgusSetDistance( argusID, 20000 );
				break;
			case "marked_target":
				ArgusSetDistance( argusID, 2048 );
				ArgusForceDrawBracket(argusID, 1);
				break;
			case "metal_storm":
				break;
		}		
		break;
	case "in":
		break;
	case "active":
		break;
	case "out":
		break;
	}

	return true;
}


//
//
increase_lighting()
{
	// initialize variables - doesn't reset with level
	setgenericscenevalue( 0, 0, 0 );

	level waittill( "clon" );	// club lighting on

	n_light_current = 0.0;
	n_light_goal = 1.0;
	n_time = 1.0;
	n_step_time = 0.01;
	
	n_steps = n_time / n_step_time;
	n_step_value = ( n_light_goal - n_light_current ) / n_steps;
	for ( i=0; i<n_steps; i++ )
	{
		n_light_current += n_step_value;
		setgenericscenevalue( 0, 0, n_light_current );
		
		wait( n_step_time );
	}
	setgenericscenevalue( 0, 0, n_light_goal );
}
