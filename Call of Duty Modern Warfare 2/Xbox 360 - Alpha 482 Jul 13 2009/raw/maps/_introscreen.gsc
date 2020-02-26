#include common_scripts\utility;
#include maps\_utility;

main()
{
	flag_init( "pullup_weapon" );
	flag_init( "introscreen_complete" );
	flag_init( "safe_for_objectives" );	
	flag_init( "introscreen_complete" );
	delaythread( 10, ::flag_set, "safe_for_objectives" );
	level.linefeed_delay = 16;

	precacheshader("black");
	precacheshader("white");

	if (getDvar("introscreen") == "")
		setDvar("introscreen", "1");
	
	//String1 = Title of the level
	//String2 = Place, Country or just Country
	//String3 = Month Day, Year
	//String4 = Optional additional detailed information
	//Pausetime1 = length of pause in seconds after title of level
	//Pausetime2 = length of pause in seconds after Month Day, Year
	//Pausetime3 = length of pause in seconds before the level fades in 
	
	if ( isdefined( level.credits_active ) )
		return;

	switch ( level.script )
	{
	case "roadkill":
		precacheString(&"ROADKILL_LINE_1");
		precacheString(&"ROADKILL_LINE_2");
		precacheString(&"ROADKILL_LINE_3");
		precacheString(&"ROADKILL_LINE_4");
		introscreen_delay();
		break;
	case "airport":
		precacheString(&"AIRPORT_LINE1");
		precacheString(&"AIRPORT_LINE2");
		precacheString(&"AIRPORT_LINE3");
		precacheString(&"AIRPORT_LINE4");
		precacheString(&"AIRPORT_LINE5");
		introscreen_delay();
		break;
	case "invasion":
		precacheString(&"INVASION_LINE1");
		precacheString(&"INVASION_LINE2");
		precacheString(&"INVASION_LINE3");
		precacheString(&"INVASION_LINE4");
		//precacheString(&"INVASION_LINE5");
		//introscreen_delay(&"INVASION_LINE1", &"INVASION_LINE2", &"INVASION_LINE3", &"INVASION_LINE4", 2, 2, .5);
		break;
	case "oilrig":
		precacheString(&"OILRIG_INTROSCREEN_LINE_1");
		precacheString(&"OILRIG_INTROSCREEN_LINE_2");
		precacheString(&"OILRIG_INTROSCREEN_LINE_3");
		precacheString(&"OILRIG_INTROSCREEN_LINE_4");
		precacheString(&"OILRIG_INTROSCREEN_LINE_5");
		introscreen_delay();
		break;
	case "gulag":
		precacheString(&"GULAG_INTROSCREEN_1");
		precacheString(&"GULAG_INTROSCREEN_2");
		precacheString(&"GULAG_INTROSCREEN_3");
		precacheString(&"GULAG_INTROSCREEN_4");
		precacheString(&"GULAG_INTROSCREEN_5");
		introscreen_delay();
		break;
	case "dcburning":
		precacheString(&"DCBURNING_INTROSCREEN_1");
		precacheString(&"DCBURNING_INTROSCREEN_2");
		precacheString(&"DCBURNING_INTROSCREEN_3");
		precacheString(&"DCBURNING_INTROSCREEN_4");
		precacheString(&"DCBURNING_INTROSCREEN_5");
		introscreen_delay();
		break;
	case "trainer":
		precacheString(&"TRAINER_INTROSCREEN_LINE_1");
		precacheString(&"TRAINER_INTROSCREEN_LINE_2");
		precacheString(&"TRAINER_INTROSCREEN_LINE_3");
		precacheString(&"TRAINER_INTROSCREEN_LINE_4");
		introscreen_delay();
		break;
	case "dcemp":
		introscreen_delay();
		break;
	case "dc_whitehouse":
		precacheString(&"DC_WHITEHOUSE_INTROSCREEN_1");
		precacheString(&"DC_WHITEHOUSE_INTROSCREEN_2");
		precacheString(&"DC_WHITEHOUSE_INTROSCREEN_3");
		precacheString(&"DC_WHITEHOUSE_INTROSCREEN_4");
		precacheString(&"DC_WHITEHOUSE_INTROSCREEN_5");
		introscreen_delay();
		break;
	case "killhouse":
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_1" );
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_2" );//not used
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_3" );
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_4" );
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_5" );
		introscreen_delay(&"KILLHOUSE_INTROSCREEN_LINE_1", &"KILLHOUSE_INTROSCREEN_LINE_3", &"KILLHOUSE_INTROSCREEN_LINE_4", &"KILLHOUSE_INTROSCREEN_LINE_5");
		break;
	case "favela":
		precachestring( &"FAVELA_INTROSCREEN_LINE_1" );
		precachestring( &"FAVELA_INTROSCREEN_LINE_2" );
		precachestring( &"FAVELA_INTROSCREEN_LINE_3" );
		precachestring( &"FAVELA_INTROSCREEN_LINE_4" );
		precachestring( &"FAVELA_INTROSCREEN_LINE_5" );
		introscreen_delay();
		break;
	case "arcadia":
		precachestring( &"ARCADIA_INTROSCREEN_LINE_1" );
		precachestring( &"ARCADIA_INTROSCREEN_LINE_2" );
		precachestring( &"ARCADIA_INTROSCREEN_LINE_3" );
		precachestring( &"ARCADIA_INTROSCREEN_LINE_4" );
		precachestring( &"ARCADIA_INTROSCREEN_LINE_5" );
		introscreen_delay();
		break;
	case "favela_escape":
		precachestring( &"FAVELA_ESCAPE_INTROSCREEN_LINE_1" );
		precachestring( &"FAVELA_ESCAPE_INTROSCREEN_LINE_2" );
		precachestring( &"FAVELA_ESCAPE_INTROSCREEN_LINE_3" );
		precachestring( &"FAVELA_ESCAPE_INTROSCREEN_LINE_4" );
		precachestring( &"FAVELA_ESCAPE_INTROSCREEN_LINE_5" );
		introscreen_delay();
		break;
	case "estate":
		precacheString(&"ESTATE_INTROSCREEN_LINE_1");
		precacheString(&"ESTATE_INTROSCREEN_LINE_2");
		precacheString(&"ESTATE_INTROSCREEN_LINE_3");
		precacheString(&"ESTATE_INTROSCREEN_LINE_4");
		precacheString(&"ESTATE_INTROSCREEN_LINE_5");
		introscreen_delay();
		break;
	case "boneyard":
		precachestring( &"BONEYARD_INTROSCREEN_LINE_1" );
		precachestring( &"BONEYARD_INTROSCREEN_LINE_2" );
		precachestring( &"BONEYARD_INTROSCREEN_LINE_3" );
		precachestring( &"BONEYARD_INTROSCREEN_LINE_4" );
		introscreen_delay();
		break;
	case "example":
		/*
		precacheString(&"INTROSCREEN_EXAMPLE_TITLE");
		precacheString(&"INTROSCREEN_EXAMPLE_PLACE");
		precacheString(&"INTROSCREEN_EXAMPLE_DATE");
		precacheString(&"INTROSCREEN_EXAMPLE_INFO");
		introscreen_delay(&"INTROSCREEN_EXAMPLE_TITLE", &"INTROSCREEN_EXAMPLE_PLACE", &"INTROSCREEN_EXAMPLE_DATE", &"INTROSCREEN_EXAMPLE_INFO");
		*/
		break;


	case "bridge":
		thread flying_intro();
		break;
	default:
		// Shouldn't do a notify without a wait statement before it, or bad things can happen when loading a save game.
		wait 0.05;
		level notify( "finished final intro screen fadein" );
		wait 0.05;
		level notify( "starting final intro screen fadeout" );
		wait 0.05;
		level notify( "controls_active" );// Notify when player controls have been restored
		wait 0.05;
		flag_set( "introscreen_complete" );// Do final notify when player controls have been restored
		break;
	}
}

introscreen_feed_lines( lines )
{
	keys = getarraykeys( lines );

	for ( i = 0; i < keys.size; i++ )
	{
		key = keys[ i ];
		interval = 1;
		time = ( i * interval ) + 1;
		delayThread( time, ::introscreen_corner_line, lines[ key ], ( lines.size - i - 1 ), interval, key );
	}
}

introscreen_generic_black_fade_in( time, fade_time, fade_in_time )
{
	introscreen_generic_fade_in( "black", time, fade_time, fade_in_time );
}

introscreen_generic_white_fade_in( time, fade_time, fade_in_time )
{
	introscreen_generic_fade_in( "white", time, fade_time, fade_in_time );
}

introscreen_generic_fade_in( shader, pause_time, fade_out_time, fade_in_time )
{
	if ( !isdefined( fade_out_time ) )
		fade_out_time = 1.5;

	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack setShader( shader, 640, 480 );

	if ( isdefined( fade_in_time ) && fade_in_time > 0 )
	{
		introblack.alpha = 0;
		introblack fadeOverTime( fade_in_time );
		introblack.alpha = 1;
		wait( fade_in_time );
	}

	wait pause_time;

	// Fade out black
	if ( fade_out_time > 0 )
		introblack fadeOverTime( fade_out_time );
		
	introblack.alpha = 0;
}

introscreen_create_line( string )
{
	index = level.introstring.size;
	yPos = ( index * 30 );

	if ( level.console )
		yPos -= 60;

	level.introstring[ index ] = newHudElem();
	level.introstring[ index ].x = 0;
	level.introstring[ index ].y = yPos;
	level.introstring[ index ].alignX = "center";
	level.introstring[ index ].alignY = "middle";
	level.introstring[ index ].horzAlign = "center";
	level.introstring[ index ].vertAlign = "middle";
	level.introstring[ index ].sort = 1;// force to draw after the background
	level.introstring[ index ].foreground = true;
	level.introstring[ index ].fontScale = 1.75;
	level.introstring[ index ] setText( string );
	level.introstring[ index ].alpha = 0;
	level.introstring[ index ] fadeOverTime( 1.2 );
	level.introstring[ index ].alpha = 1;
}

introscreen_fadeOutText()
{
	for ( i = 0; i < level.introstring.size; i++ )
	{
		level.introstring[ i ] fadeOverTime( 1.5 );
		level.introstring[ i ].alpha = 0;
	}

	wait 1.5;

	for ( i = 0; i < level.introstring.size; i++ )
		level.introstring[ i ] destroy();

}

introscreen_delay( string1, string2, string3, string4, pausetime1, pausetime2, timebeforefade )
{
	//Chaotically wait until the frame ends twice because handle_starts waits for one frame end so that script gets to init vars
	//and this needs to wait for handle_starts to finish so that the level.start_point gets set.
	waittillframeend;
	waittillframeend;

	 /#
	skipIntro = !is_default_start();
	if ( getdvar( "introscreen" ) == "0" )
		skipIntro = true;

	if ( skipIntro )
	{
		waittillframeend;
		level notify( "finished final intro screen fadein" );
		waittillframeend;
		level notify( "starting final intro screen fadeout" );
		waittillframeend;
		level notify( "controls_active" );// Notify when player controls have been restored
		waittillframeend;
		flag_set( "introscreen_complete" );// Do final notify when player controls have been restored
		flag_set( "pullup_weapon" );
		return;
	}
	#/

	if ( flying_intro() )
	{
		return;
	}
	if ( level.script == "airport" )
	{
		airport_intro();
		return;
	}
	if ( level.script == "favela" )
	{
		favela_intro();
		return;
	}
	if ( level.script == "favela_escape" )
	{
		favela_escape_intro();
		return;
	}
	if ( level.script == "arcadia" )
	{
		arcadia_intro();
		return;
	}
	if ( level.script == "oilrig" )
	{
		oilrig_intro();
		return;
	}
	if ( level.script == "dcburning" )
	{
		dcburning_intro();
		return;
	}
	if ( level.script == "trainer" )
	{
		trainer_intro();
		return;
	}
	if( level.script == "dcemp" )
	{
		dcemp_intro();
		return;	
	}
	if ( level.script == "dc_whitehouse" )
	{
		dc_whitehouse_intro();
		return;
	}
	if ( level.script == "gulag" )
	{
		flag_set( "introscreen_complete" );// Notify when complete
		return;
	}
	
	level.introblack = newHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;
	level.introblack setShader( "black", 640, 480 );

	level.player freezeControls( true );
	wait .05;

	level.introstring = [];

	//Title of level

	if ( isdefined( string1 ) )
		introscreen_create_line( string1 );

	if ( isdefined( pausetime1 ) )
	{
		wait pausetime1;
	}
	else
	{
		wait 2;
	}

	//City, Country, Date

	if ( isdefined( string2 ) )
		introscreen_create_line( string2 );
	if ( isdefined( string3 ) )
		introscreen_create_line( string3 );

	//Optional Detailed Statement

	if ( isdefined( string4 ) )
	{
		if ( isdefined( pausetime2 ) )
		{
			wait pausetime2;
		}
		else
		{
			wait 2;
		}
	}

	if ( isdefined( string4 ) )
		introscreen_create_line( string4 );

	//if(isdefined(string5))
		//introscreen_create_line(string5);

	level notify( "finished final intro screen fadein" );

	if ( isdefined( timebeforefade ) )
	{
		wait timebeforefade;
	}
	else
	{
		wait 3;
	}

	// Fade out black
	level.introblack fadeOverTime( 1.5 );
	level.introblack.alpha = 0;

	level notify( "starting final intro screen fadeout" );

	// Restore player controls part way through the fade in
	level.player freezeControls( false );
	level notify( "controls_active" );// Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText();

	flag_set( "introscreen_complete" );// Notify when complete
}

_CornerLineThread( string, size, interval, index_key )
{
	level notify( "new_introscreen_element" );

	if ( !isdefined( level.intro_offset ) )
		level.intro_offset = 0;
	else
		level.intro_offset++ ;

	y = _CornerLineThread_height();

	hudelem = newHudElem();
	hudelem.x = 20;
	hudelem.y = y;
	hudelem.alignX = "left";
	hudelem.alignY = "bottom";
	hudelem.horzAlign = "left";
	hudelem.vertAlign = "bottom";
	hudelem.sort = 1;// force to draw after the background
	hudelem.foreground = true;
	hudelem setText( string );
	hudelem.alpha = 0;
	hudelem fadeOverTime( 0.2 );
	hudelem.alpha = 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale = 2.0;// was 1.6 and 2.4, larger font change
	hudelem.color = ( 0.8, 1.0, 0.8 );
	hudelem.font = "objective";
	hudelem.glowColor = ( 0.3, 0.6, 0.3 );
	hudelem.glowAlpha = 1;
	duration = int( ( size * interval * 1000 ) + 4000 );
	hudelem SetPulseFX( 30, duration, 700 );// something, decay start, decay duration

	thread hudelem_destroy( hudelem );

	if ( !isdefined( index_key ) )
		return;
	if ( !isstring( index_key ) )
		return;
	if ( index_key != "date" )
		return;
}


_CornerLineThread_height()
{
	//return ( ( ( pos ) * 19 ) - 10 );
	return( ( ( level.intro_offset ) * 20 ) - 82 );// was 19 and 22 larger font change
}

introscreen_corner_line( string, size, interval, index_key )
{
	thread _CornerLineThread( string, size, interval, index_key );
}


hudelem_destroy( hudelem )
{
	wait( level.linefeed_delay );
	hudelem notify( "destroying" );
	level.intro_offset = undefined;

	time = .5;
	hudelem fadeOverTime( time );
	hudelem.alpha = 0;
	wait time;
	hudelem notify( "destroy" );
	hudelem destroy();
}


cargoship_intro_dvars()
{
	wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showStance", 0 );
	setSavedDvar( "hud_drawhud", "0" );
}

favela_intro()
{
	level.player freezeControls( true );
	
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	
	thread introscreen_generic_black_fade_in( 5.0 );
	
	lines = [];
	lines[ lines.size ] = &"FAVELA_INTROSCREEN_LINE_1";		// 'Takedown'
	lines[ "date" ]     = &"FAVELA_INTROSCREEN_LINE_2";		// Day 4 - 14:30:[{FAKE_INTRO_SECONDS:16}]
	lines[ lines.size ] = &"FAVELA_INTROSCREEN_LINE_3";		// Sgt. Gary 'Roach' Sanderson
	lines[ lines.size ] = &"FAVELA_INTROSCREEN_LINE_4";		// Task Force 141
	lines[ lines.size ] = &"FAVELA_INTROSCREEN_LINE_5";		// Rio de Janeiro, Brazil	
	
	introscreen_feed_lines( lines );
	
	wait( 5.0 );
	level notify( "introscreen_complete" );
	
	level.player freezeControls( false );
}

favela_escape_intro()
{
	level.player freezeControls( true );
	
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	
	blacktime = 6;
	thread introscreen_generic_black_fade_in( blacktime );
	thread flag_set_delayed( "introscreen_start_dialogue", 1.0 );
	
	lines = [];
	lines[ lines.size ] = &"FAVELA_ESCAPE_INTROSCREEN_LINE_1";  // 'The Hornet's Nest'
	lines[ "date" ]		= &"FAVELA_ESCAPE_INTROSCREEN_LINE_2";  // Day 4 - 04:19:[{FAKE_INTRO_SECONDS:40}]
	lines[ lines.size ] = &"FAVELA_ESCAPE_INTROSCREEN_LINE_3";  // Sgt. Gary 'Roach' Sanderson
	lines[ lines.size ] = &"FAVELA_ESCAPE_INTROSCREEN_LINE_4";  // Task Force 141
	lines[ lines.size ] = &"FAVELA_ESCAPE_INTROSCREEN_LINE_5";  // Rio de Janeiro, 7000 F.S.L.
	
	introscreen_feed_lines( lines );

	wait( blacktime );
	level notify( "introscreen_complete" );
	
	level.player freezeControls( false );
}

arcadia_intro()
{
	level.player freezeControls( true );
	
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	
	thread introscreen_generic_black_fade_in( 5.0 );
	
	lines = [];
	lines[ lines.size ] = &"ARCADIA_INTROSCREEN_LINE_1";	// 'Contraflow'
	lines[ "date" ]     = &"ARCADIA_INTROSCREEN_LINE_2";	// DC Invasion D+1 - 15:22:[{FAKE_INTRO_SECONDS:02}]
	lines[ lines.size ] = &"ARCADIA_INTROSCREEN_LINE_3";	// PFC James Patterson
	lines[ lines.size ] = &"ARCADIA_INTROSCREEN_LINE_4";	// U.S. Army 3rd Infantry Regiment
	lines[ lines.size ] = &"ARCADIA_INTROSCREEN_LINE_5";	// Washington DC Suburbs	
	
	introscreen_feed_lines( lines );

	wait( 5.0 );
	level notify( "introscreen_complete" );
	
	level.player freezeControls( false );
}

boneyard_intro()
{
	lines = [];
	lines[ lines.size ] = &"BONEYARD_INTROSCREEN_LINE_1";		// 'Just Like Old Times'
	lines[ "date" ] 	 = 	&"BONEYARD_INTROSCREEN_LINE_2";		// Day 6 - 17:30:[{FAKE_INTRO_SECONDS:41}]
	lines[ lines.size ] = &"BONEYARD_INTROSCREEN_LINE_3";		// Sgt. John 'Soap' MacTavish
	lines[ lines.size ] = &"BONEYARD_INTROSCREEN_LINE_4";		// 160 miles SW of Kandahar, Afghanistan
	lines[ lines.size ] = &"BONEYARD_INTROSCREEN_LINE_5";		// U.S. Ordnance and Vehicle Disposal Yard 437
	
	introscreen_feed_lines( lines );
	
	level notify( "introscreen_complete" );
}

estate_intro()
{
	lines = [];
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_1";		// 'Loose Ends'
	lines[ "date" ] 	 = 	&"ESTATE_INTROSCREEN_LINE_2";	// Day 6 - 14:30:[{FAKE_INTRO_SECONDS:07}]
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_3";		// Sgt. Gary 'Roach' Sanderson
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_4";		// Task Force 141
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_5";		// Georgian-Russian Border
	
	introscreen_feed_lines( lines );
	
	level notify( "introscreen_complete" );
}

airport_intro()
{
	level.player freezeControls( true );
	
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	
	time = 21 + 5.5;
	thread introscreen_generic_black_fade_in( time );

	lines = [];
	
	// "No Russian"
	lines[ lines.size ] = &"AIRPORT_LINE1";	
	// Day 3, 08:40:[{FAKE_INTRO_SECONDS:32}]
	lines[ "date" ] 	 = &"AIRPORT_LINE2";
	// PFC Ed Brodsky a.k.a. Alexei Borodin
	lines[ lines.size ] = &"AIRPORT_LINE3";
	// Terminal 3, Domodedovo Int'l Airport
	lines[ lines.size ] = &"AIRPORT_LINE4";
	// Moscow, Russia
	lines[ lines.size ] = &"AIRPORT_LINE5";
	
	delaythread( 10.25 + 5.5, ::introscreen_feed_lines, lines );

	wait( time );
		
	wait 1;
	
	if( !flag( "do_not_save" ) )
		thread autosave_now_silent();
		
	level notify( "introscreen_complete" );
	
	level.player freezeControls( false );
}

oilrig_intro_dvars()
{
	//wait( 0.05 );
	setsaveddvar( "ui_hidemap", 1 );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );
	//SetDvar( "old_compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	setsaveddvar( "g_friendlyNameDist", 0 );
	//SetSavedDvar( "hud_showTextNoAmmo", "0" ); 
}

oilrig_intro()
{
	if ( !level.underwater )
		return;
	thread oilrig_intro_dvars();
	level.player freezeControls( true );
	flag_wait( "open_dds_door" );
	wait( 2 );
	level.player freezeControls( false );
}

oilrig_intro2()
{
	lines = [];
	
	lines[ lines.size ] = &"OILRIG_INTROSCREEN_LINE_1";	
	lines[ lines.size ] = &"OILRIG_INTROSCREEN_LINE_2";
	lines[ lines.size ] = &"OILRIG_INTROSCREEN_LINE_3";
	lines[ lines.size ] = &"OILRIG_INTROSCREEN_LINE_4";
	lines[ lines.size ] = &"OILRIG_INTROSCREEN_LINE_5";
	
	introscreen_feed_lines( lines );
}

estate_intro2()
{
	lines = [];
	
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_1";	// "'Loose Ends'"
	lines[ "date" ] 	 = &"ESTATE_INTROSCREEN_LINE_2";	// "Day 06 – 14:05:[{FAKE_INTRO_SECONDS:07}]"
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_3";	// "Sgt. Gary 'Roach' Sanderson"
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_4";	// "Task Force 141"
	lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_5";	// "Georgian-Russian Border"
	
	introscreen_feed_lines( lines );
}


dcburning_intro()
{
	level.player disableWeapons();
	thread dcburningIntroDvars();
	thread dcburningIntroPlayer();

	//cinematicingamesync( "scoutsniper_fade" );

	// Start
	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack setShader( "black", 640, 480 );
	wait 4.25;

//	introtime = newHudElem();
//	introtime.x = 0;
//	introtime.y = 0;
//	introtime.alignX = "center";
//	introtime.alignY = "middle";
//	introtime.horzAlign = "center";
//	introtime.vertAlign = "middle";
//	introtime.sort = 1;
//	introtime.foreground = true;
//	// Of Their Own Accord
//	introtime setText( &"DCBURNING_MAIN_TITLE" );
//	introtime.fontScale = 1.6;
//	introtime.color = ( 0.8, 1.0, 0.8 );
//	introtime.font = "objective";
//	introtime.glowColor = ( 0.3, 0.6, 0.3 );
//	introtime.glowAlpha = 1;
//	introtime SetPulseFX( 30, 2000, 700 );// something, decay start, decay duration

	wait 3;

	// Fade out black
	
	level notify( "black_fading" );
	introblack fadeOverTime( 1.5 );
	introblack.alpha = 0;
	
	wait( 1.5 );
	flag_set( "introscreen_complete" );
	 // Do final notify when player controls have been restored	
	level notify( "introscreen_complete" );
	level.player freezeControls( false );
	level.player enableWeapons();
	wait( .5 );

	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	
	flag_wait( "player_exiting_start_trench" );

  
	lines = [];
	lines[ lines.size ] = &"DCBURNING_INTROSCREEN_1";
	lines[ lines.size ] = &"DCBURNING_INTROSCREEN_2";
	lines[ lines.size ] = &"DCBURNING_INTROSCREEN_3";
	lines[ lines.size ] = &"DCBURNING_INTROSCREEN_4";
	lines[ lines.size ] = &"DCBURNING_INTROSCREEN_5";
	
	introscreen_feed_lines( lines );
}

dcemp_intro()
{
	flag_set( "introscreen_complete" );
}

dc_whitehouse_intro()
{
	level.player disableweapons();
	level.player freezeControls( true );
	
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	
	thread introscreen_generic_black_fade_in( 5.0 );
	
	lines = [];
	lines[ lines.size ] = &"DC_WHITEHOUSE_INTROSCREEN_1";
	lines[ "date" ]     = &"DC_WHITEHOUSE_INTROSCREEN_2";
	lines[ lines.size ] = &"DC_WHITEHOUSE_INTROSCREEN_3";
	lines[ lines.size ] = &"DC_WHITEHOUSE_INTROSCREEN_4";
	lines[ lines.size ] = &"DC_WHITEHOUSE_INTROSCREEN_5";
	
	introscreen_feed_lines( lines );

	wait( 5.0 );
	level notify( "introscreen_complete" );
	
	level.player freezeControls( false );
	level.player enableweapons();
}

dcburningIntroPlayer()
{
	level.player freezeControls( true );
	ang = level.player getplayerangles();
	org = spawn( "script_origin", level.player.origin );
	org.origin = level.player.origin;
	org.angles = level.player.angles;
	org rotateTo( org.angles + ( 0, 180, 0 ), .1 );
	wait( .1 );
	level.player setPlayerAngles( org.angles );
	level waittill( "black_fading" );
	level.player setplayerangles( ang );
	org delete();
}

dcburningIntroDvars()
{
	wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showStance", 0 );
}



trainerIntroDvars()
{
	//wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showStance", 0 );
}

trainer_intro()
{
	thread trainerIntroDvars();
	level.player freezeControls( true );
	// Start
	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack setShader( "black", 640, 480 );
	lines = [];
	lines[ lines.size ] = &"TRAINER_INTROSCREEN_LINE_1";
	lines[ lines.size ] = &"TRAINER_INTROSCREEN_LINE_2";
	lines[ lines.size ] = &"TRAINER_INTROSCREEN_LINE_3";
	lines[ lines.size ] = &"TRAINER_INTROSCREEN_LINE_4";
	
	introscreen_feed_lines( lines );
	
	wait( 6 );
	// Fade out black
	level notify( "black_fading" );
	introblack fadeOverTime( 1.5 );
	introblack.alpha = 0;
	
	wait( 1.5 );
	flag_set( "introscreen_complete" );
	 // Do final notify when player controls have been restored	
	level notify( "introscreen_complete" );
	level.player freezeControls( false );
	wait( .5 );

	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );

}



bog_intro_sound()
{
	wait( 0.05 );
	//level.player playsound( "ui_camera_whoosh_in" );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showstance", "0" );
	SetSavedDvar( "actionSlotsHide", "1" );
}

feedline_delay()
{
	wait( 2 );
}

flying_intro()
{
	flying_levels = [];
	flying_levels[ "killhouse" ] = true;
	flying_levels[ "cliffhanger" ] = true;
	//flying_levels[ "favela_escape" ] = true;
	flying_levels[ "estate" ] = true;
	flying_levels[ "roadkill" ] = true;
	flying_levels[ "boneyard" ] = true;

	override_angles = isdefined( level.customIntroAngles );
	
	if ( !isdefined( flying_levels[ level.script ] ) )
		return false;
		
	if ( !isdefined( level.dontReviveHud ) )
		thread revive_ammo_counter();


	thread bog_intro_sound();
	thread weapon_pullout();

	level.player freezeControls( true );
	feedline_delay_func = ::feedline_delay;

	zoomHeight = 16000;
	slamzoom = true;
	 /#
	if ( getdvar( "slamzoom" ) != "" )
		slamzoom = false;
	#/

	extra_delay = 0;
	special_save = false;

	if ( slamzoom )
	{
		lines = [];
		switch ( level.script )
		{
			case "killhouse":
				special_save = true;
				//thread introscreen_generic_black_fade_in( 0.7, 0.20 );
				cinematicingamesync( "killhouse_fade" );
				lines = [];
				// 'F.N.G.'
				lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_1";
					// Day 1 - 06:30:[{FAKE_INTRO_SECONDS:09}]
			//	lines[ "date" ] 	= &"KILLHOUSE_INTROSCREEN_LINE_2";
				// Credenhill, UK
				lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_3";
				// Sgt. 'Soap' MacTavish
				lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_4";
				// 22nd SAS Regiment
				lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_5";
				break;
				
			case "estate":
				thread introscreen_generic_black_fade_in( 0.05 );
				//cinematicingamesync( "village_assault_fade" );
				lines = [];
				// "Loose Ends"
				//lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_1";
				// Day 6 - 14:20:[{FAKE_INTRO_SECONDS:07}]
				//lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_2";
				// Sgt. Gary 'Roach' Sanderson
				//lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_3";
				// Task Force 141
				//lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_4";
				// Georgian-Russian Border
				//lines[ lines.size ] = &"ESTATE_INTROSCREEN_LINE_5";
				zoomHeight = 3500; //2632
				setsaveddvar( "sm_sunSampleSizeNear", 0.6 );// air
				delaythread( 0.5, ::ramp_out_sunsample_over_time, 0.9 );
				break;

			case "boneyard":
				thread introscreen_generic_black_fade_in( 0.05 );
				lines = [];
				setsaveddvar( "sm_sunSampleSizeNear", 0.6 );// air
				delaythread( 0.5, ::ramp_out_sunsample_over_time, 0.9 );
				zoomHeight = 4000;
				break;				
				
			case "roadkill":
				thread introscreen_generic_black_fade_in( 0.05 );
				lines = [];
				// 'F.N.G.'
				lines[ lines.size ] = &"ROADKILL_LINE_1";
				lines[ lines.size ] = &"ROADKILL_LINE_2";
				lines[ lines.size ] = &"ROADKILL_LINE_3";
				lines[ lines.size ] = &"ROADKILL_LINE_4";
				feedline_delay = 21;
			
				feedline_delay_func = level.roadkill_feedline_delay;
				setsaveddvar( "sm_sunSampleSizeNear", 2.0 );// air
				delaythread( 0.6, ::ramp_out_sunsample_over_time, 1.4 );
				break;
		}
		
		add_func( feedline_delay_func );
		add_func( ::introscreen_feed_lines, lines );
		thread do_funcs();
	}

	origin = level.player.origin;

	level.player PlayerSetStreamOrigin( origin );

	level.player.origin = origin + ( 0, 0, zoomHeight );
	ent = spawn( "script_model", ( 69, 69, 69 ) );
	ent.origin = level.player.origin;

	ent setmodel( "tag_origin" );
	
	if ( override_angles )
	{
		ent.angles = ( 0, level.customIntroAngles[ 1 ], 0 );
	}
	else
	{
		ent.angles = level.player.angles;
	}
	
	level.player playerlinkto( ent, undefined, 1, 0, 0, 0, 0 );
	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 );

	wait( extra_delay );
	ent moveto( origin + ( 0, 0, 0 ), 2, 0, 2 );
	
	wait( 1.00 );
	wait( 0.5 );
	
	if ( override_angles )
	{
		ent rotateto( level.customIntroAngles, 0.5, 0.3, 0.2 );
	}
	else
	{
		ent rotateto( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), 0.5, 0.3, 0.2 );
	}
	
	if ( !special_save )
		// Start
		saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	wait( 0.5 );
	flag_set( "pullup_weapon" );

	wait( 0.2 );
	level.player unlink();
	level.player freezeControls( false );

	level.player PlayerClearStreamOrigin();

	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );

	wait( 0.2 );

	thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );

	wait( 0.2 );

	// Do final notify when player controls have been restored
	flag_set( "introscreen_complete" );

	wait( 2 );

	ent delete();

	return true;
}

weapon_pullout()
{
	weap = level.player GetWeaponsListAll()[ 0 ];
    level.player DisableWeapons();
	flag_wait( "pullup_weapon" );
    level.player EnableWeapons();
//	level.player switchToWeapon( weap );
}

revive_ammo_counter()
{
	flag_wait( "safe_for_objectives" );
	if ( !isdefined( level.nocompass ) )
		setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "actionSlotsHide", "0" );
	SetSavedDvar( "hud_showstance", "1" );
}

ramp_out_sunsample_over_time( time, base_sample_size )
{
	sample_size = getdvarfloat( "sm_sunSampleSizeNear" );
	if ( !isdefined( base_sample_size ) )
		base_sample_size = 0.25;
	
	range = sample_size - base_sample_size; // min sample size is 0.25
		
	frames = time * 20;
	for ( i = 0; i <= frames; i++ )
	{
		dif = i / frames;
		dif = 1 - dif;
		current_range = dif * range;
		current_sample_size = base_sample_size + current_range;
		setsaveddvar( "sm_sunSampleSizeNear", current_sample_size );
		wait( 0.05 );
	}	
}
