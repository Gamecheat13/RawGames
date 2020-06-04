#include common_scripts\utility;
#include maps\_utility; 

// cleaned up by DPG (4/4/07)


/*
==============
///GSCDocBegin
"Name: main()"
"Summary: sets up script for an intro screen to work"
"CallOn: Should only be called as a function, not a thread"
"ScriptFile: "
"MandatoryArg: "
"OptionalArg: "
"Example: "
"NoteLine: maps\_introscreen::main() is called in _load. Each level's introscreen should be set up in the switch statement contained in this file's main() function"
"LEVELVAR: level.script - used for determining which introscreen to display"
"LEVELVAR: pullup_weapon - not used for anything as of yet...
"LEVELVAR: introscreen_complete - used to signify when all the introscreen behavior is finished
"SPCOOP: both"
///GSCDocEnd
==============
*/
main()
{
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	/#
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _introscreen.gsc. Function: main()\n");
	#/
	
	flag_init( "pullup_weapon" ); 
	flag_init( "starting final intro screen fadeout" );
	flag_init( "introscreen_complete" ); // used to notify when introscreen is complete
	
	PrecacheShader( "black" ); 

	if( GetDvar( "introscreen" ) == "" )
	{
		SetDvar( "introscreen", "1" ); 
	}

	level.splitscreen = GetDvarInt( "splitscreen" );
	level.hidef = GetDvarInt( "hidef" );

	level thread introscreen_report_disconnected_clients();
	
	switch( level.script )
	{
		case "example":
			/*
			PrecacheString( &"INTROSCREEN_EXAMPLE_TITLE" ); 
			PrecacheString( &"INTROSCREEN_EXAMPLE_PLACE" ); 
			PrecacheString( &"INTROSCREEN_EXAMPLE_DATE" ); 
			PrecacheString( &"INTROSCREEN_EXAMPLE_INFO" ); 
			introscreen_delay( &"INTROSCREEN_EXAMPLE_TITLE", &"INTROSCREEN_EXAMPLE_PLACE", &"INTROSCREEN_EXAMPLE_DATE", &"INTROSCREEN_EXAMPLE_INFO" ); 
			*/
			break; 
//-------------------//
// Production Levels //
//-------------------//
		case "prologue":
			PrecacheString( &"PROLOGUE_INTROSCREEN_TITLE" );
			PrecacheString( &"PROLOGUE_INTROSCREEN_PLACE" );
			PrecacheString( &"PROLOGUE_INTROSCREEN_DATE" );
			PrecacheString( &"PROLOGUE_INTROSCREEN_INFO" );
			introscreen_delay( &"PROLOGUE_INTROSCREEN_TITLE", &"PROLOGUE_INTROSCREEN_DATE", &"PROLOGUE_INTROSCREEN_PLACE", &"PROLOGUE_INTROSCREEN_INFO" );
			break;
			
		case "mak":
			PrecacheString( &"MAK_INTROSCREEN_TITLE" );
			PrecacheString( &"MAK_INTROSCREEN_PLACE" );
			PrecacheString( &"MAK_INTROSCREEN_DATE" );
			PrecacheString( &"MAK_INTROSCREEN_NAME" );
			PrecacheString( &"MAK_INTROSCREEN_INFO" );
			introscreen_delay( &"MAK_INTROSCREEN_TITLE", &"MAK_INTROSCREEN_PLACE", &"MAK_INTROSCREEN_DATE", &"MAK_INTROSCREEN_NAME", &"MAK_INTROSCREEN_INFO" );
			break;

		case "pel1":
			PrecacheString( &"PEL1_INTROSCREEN_TITLE" );
			PrecacheString( &"pEL1_INTROSCREEN_PLACE" );
			PrecacheString( &"PEL1_INTROSCREEN_DATE" );
			PrecacheString( &"PEL1_INTROSCREEN_NAME" );
			PrecacheString( &"PEL1_INTROSCREEN_INFO" );
			introscreen_delay( &"PEL1_INTROSCREEN_TITLE", &"PEL1_INTROSCREEN_DATE", &"PEL1_INTROSCREEN_PLACE", &"PEL1_INTROSCREEN_NAME", &"PEL1_INTROSCREEN_INFO" );
			break;

		case "pel1a":
			PrecacheString( &"PEL1A_INTROSCREEN_TITLE" );
			PrecacheString( &"pEL1A_INTROSCREEN_PLACE" );
			PrecacheString( &"PEL1A_INTROSCREEN_DATE" );
			PrecacheString( &"PEL1A_INTROSCREEN_INFO" );
			introscreen_delay( &"PEL1A_INTROSCREEN_TITLE", &"PEL1A_INTROSCREEN_DATE", &"PEL1A_INTROSCREEN_PLACE", &"PEL1A_INTROSCREEN_NAME", &"PEL1A_INTROSCREEN_INFO" );
			break;

		case "pel1b":
			PrecacheString( &"PEL1B_INTROSCREEN_TITLE" );
			PrecacheString( &"PEL1B_INTROSCREEN_PLACE" );
			PrecacheString( &"PEL1B_INTROSCREEN_DATE" );
			PrecacheString( &"PEL1B_INTROSCREEN_NAME" );
			PrecacheString( &"PEL1B_INTROSCREEN_INFO" );
			introscreen_delay( &"PEL1B_INTROSCREEN_TITLE", &"PEL1B_INTROSCREEN_DATE", &"PEL1B_INTROSCREEN_PLACE", &"PEL1B_INTROSCREEN_NAME", &"PEL1B_INTROSCREEN_INFO" );
			break;
		
		case "pel2":
			PrecacheString( &"PEL2_INTROSCREEN_TITLE" );
			PrecacheString( &"pEL2_INTROSCREEN_PLACE" );
			PrecacheString( &"PEL2_INTROSCREEN_DATE" );
			PrecacheString( &"PEL2_INTROSCREEN_NAME" );
			PrecacheString( &"PEL2_INTROSCREEN_INFO" );
			introscreen_delay( &"PEL2_INTROSCREEN_TITLE", &"PEL2_INTROSCREEN_DATE", &"PEL2_INTROSCREEN_PLACE", &"PEL2_INTROSCREEN_NAME", &"PEL2_INTROSCREEN_INFO" );
			break;

		case "pby_fly":
			PrecacheString( &"PBY_FLY_INTROSCREEN_TITLE" );
			PrecacheString( &"PBY_FLY_INTROSCREEN_PLACE" );
			PrecacheString( &"PBY_FLY_INTROSCREEN_DATE" );
			PrecacheString( &"PBY_FLY_INTROSCREEN_NAME" );
			PrecacheString( &"PBY_FLY_INTROSCREEN_INFO" );
			introscreen_delay( &"PBY_FLY_INTROSCREEN_TITLE", &"PBY_FLY_INTROSCREEN_DATE", &"PBY_FLY_INTROSCREEN_PLACE", &"PBY_FLY_INTROSCREEN_NAME", &"PBY_FLY_INTROSCREEN_INFO" );
			break;

		case "see1":
			PrecacheString( &"SEE1_INTROSCREEN_TITLE" );
			PrecacheString( &"sEE1_INTROSCREEN_PLACE" );
			PrecacheString( &"SEE1_INTROSCREEN_DATE" );
			PrecacheString( &"SEE1_INTROSCREEN_NAME" );
			PrecacheString( &"SEE1_INTROSCREEN_INFO" );
			introscreen_delay( &"SEE1_INTROSCREEN_TITLE", &"SEE1_INTROSCREEN_DATE", &"SEE1_INTROSCREEN_PLACE", &"SEE1_INTROSCREEN_NAME", &"SEE1_INTROSCREEN_INFO" );
			break;

		case "see2":
			PrecacheString( &"SEE2_INTROSCREEN_TITLE" );
			PrecacheString( &"SEE2_INTROSCREEN_PLACE" );
			PrecacheString( &"SEE2_INTROSCREEN_DATE" );
			PrecacheString( &"SEE2_INTROSCREEN_NAME" );
			PrecacheString( &"SEE2_INTROSCREEN_INFO" );
			introscreen_delay( &"SEE2_INTROSCREEN_TITLE", &"SEE2_INTROSCREEN_DATE", &"SEE2_INTROSCREEN_PLACE", &"SEE2_INTROSCREEN_NAME", &"SEE2_INTROSCREEN_INFO" );
			break;

		case "see3":
			PrecacheString( &"SEE3_INTROSCREEN_TITLE" );
			PrecacheString( &"sEE3_INTROSCREEN_PLACE" );
			PrecacheString( &"SEE3_INTROSCREEN_DATE" );
			PrecacheString( &"SEE3_INTROSCREEN_INFO" );
			introscreen_delay( &"SEE3_INTROSCREEN_TITLE", &"SEE3_INTROSCREEN_DATE", &"SEE3_INTROSCREEN_PLACE", &"SEE3_INTROSCREEN_INFO" );
			break;

		case "oki1":
			PrecacheString( &"OKI1_INTROSCREEN_TITLE" );
			PrecacheString( &"oKI1_INTROSCREEN_PLACE" );
			PrecacheString( &"OKI1_INTROSCREEN_DATE" );
			PrecacheString( &"OKI1_INTROSCREEN_INFO" );
			introscreen_delay( &"OKI1_INTROSCREEN_TITLE", &"OKI1_INTROSCREEN_DATE", &"OKI1_INTROSCREEN_PLACE", &"OKI1_INTROSCREEN_INFO" );
			break;

		case "oki2":
			PrecacheString( &"OKI2_INTROSCREEN_TITLE" );
			PrecacheString( &"oKI2_INTROSCREEN_DATE" );
			PrecacheString( &"OKI2_INTROSCREEN_PLACE" );
			PrecacheString( &"OKI2_INTROSCREEN_WHO" );
			PrecacheString( &"OKI2_INTROSCREEN_WHAT" );
			introscreen_delay( &"OKI2_INTROSCREEN_TITLE", &"OKI2_INTROSCREEN_DATE", &"OKI2_INTROSCREEN_PLACE", &"OKI2_INTROSCREEN_WHO", &"OKI2_INTROSCREEN_WHAT" );
			break;

		case "oki3":
			PrecacheString( &"OKI3_INTROSCREEN_TITLE" );
			PrecacheString( &"oKI3_INTROSCREEN_PLACE" );
			PrecacheString( &"OKI3_INTROSCREEN_DATE" );
			PrecacheString( &"OKI3_INTROSCREEN_INFO" );
			PrecacheString( &"OKI3_INTROSCREEN_NAME" );
			introscreen_delay( &"OKI3_INTROSCREEN_TITLE", &"OKI3_INTROSCREEN_DATE", &"OKI3_INTROSCREEN_PLACE", &"OKI3_INTROSCREEN_NAME" ,&"OKI3_INTROSCREEN_INFO" );
			break;

		case "ber1":
			PrecacheString( &"BER1_INTROSCREEN_TITLE" );
			PrecacheString( &"bER1_INTROSCREEN_PLACE" );
			PrecacheString( &"BER1_INTROSCREEN_DATE" );
			PrecacheString( &"BER1_INTROSCREEN_INFO" );
			PrecacheString( &"BER1_INTROSCREEN_NAME" );
			introscreen_delay( &"BER1_INTROSCREEN_TITLE", &"BER1_INTROSCREEN_DATE", &"BER1_INTROSCREEN_PLACE", &"BER1_INTROSCREEN_NAME", &"BER1_INTROSCREEN_INFO" );
			break;

		case "ber2":
			PrecacheString( &"BER2_INTROSCREEN_TITLE" );
			PrecacheString( &"BER2_INTROSCREEN_PLACE" );
			PrecacheString( &"BER2_INTROSCREEN_NAME" );
			PrecacheString( &"BER2_INTROSCREEN_DATE" );
			PrecacheString( &"BER2_INTROSCREEN_INFO" );
			introscreen_delay( &"BER2_INTROSCREEN_TITLE", &"BER2_INTROSCREEN_DATE", &"BER2_INTROSCREEN_PLACE", &"BER2_INTROSCREEN_NAME", &"BER2_INTROSCREEN_INFO" );
			break;
			
		case "ber2b":
			PrecacheString( &"BER2B_INTROSCREEN_TITLE" );
			PrecacheString( &"BER2B_INTROSCREEN_PLACE" );
			PrecacheString( &"BER2B_INTROSCREEN_DATE" );
			PrecacheString( &"BER2B_INTROSCREEN_INFO" );
			introscreen_delay( &"BER2B_INTROSCREEN_TITLE", &"BER2B_INTROSCREEN_DATE", &"BER2B_INTROSCREEN_PLACE", &"BER2B_INTROSCREEN_INFO" );
			break;

		case "sniper":		// 6/27 FLAMER
			PrecacheString( &"SNIPER_INTROSCREEN_TITLE" );
			PrecacheString( &"SNIPER_INTROSCREEN_PLACE" );
			PrecacheString( &"SNIPER_INTROSCREEN_DATE" );
			PrecacheString( &"SNIPER_INTROSCREEN_INFO" );
			PrecacheString( &"SNIPER_INTROSCREEN_INFO2" );
			introscreen_delay();
	
			//introscreen_delay( &"SNIPER_INTROSCREEN_TITLE", &"SNIPER_INTROSCREEN_DATE", &"SNIPER_INTROSCREEN_PLACE", &"SNIPER_INTROSCREEN_INFO", &"SNIPER_INTROSCREEN_INFO2" );
			break;
		


		case "ber3":
			PrecacheString( &"BER3_INTROSCREEN_TITLE" );
			PrecacheString( &"BER3_INTROSCREEN_PLACE" );
			PrecacheString( &"BER3_INTROSCREEN_NAME" );
			PrecacheString( &"BER3_INTROSCREEN_DATE" );
			PrecacheString( &"BER3_INTROSCREEN_INFO" );
			// introscreen_delay( &"BER3_INTROSCREEN_TITLE", &"BER3_INTROSCREEN_DATE", &"BER3_INTROSCREEN_PLACE", &"BER3_INTROSCREEN_NAME", &"BER3_INTROSCREEN_INFO" );
			break;
		case "ber3b":
			PrecacheString( &"BER3B_INTROSCREEN_TITLE" );
			PrecacheString( &"BER3B_INTROSCREEN_PLACE" );
			PrecacheString( &"BER3B_INTROSCREEN_NAME" );
			PrecacheString( &"BER3B_INTROSCREEN_DATE" );
			PrecacheString( &"BER3B_INTROSCREEN_INFO" );
			pausetime1 = 3;
			pausetime2 = 4;
			timebeforefade = 3;
			introscreen_delay( &"BER3B_INTROSCREEN_TITLE", &"BER3B_INTROSCREEN_DATE", &"BER3B_INTROSCREEN_PLACE", &"BER3B_INTROSCREEN_NAME", &"BER3B_INTROSCREEN_INFO", pausetime1, pausetime2, timebeforefade );
			break;
		case "nazi_zombie_prototype":
			introscreen_delay();
			break;
//-------------//
// Test Levels //
//-------------//
		default:
			// Shouldn't do a notify without a wait( statement before it, or bad things can happen when loading a save game.
			wait( 0.05 ); 
			level notify( "finished final intro screen fadein" ); 
			wait( 0.05 ); 
			flag_set( "starting final intro screen fadeout" ); 
			wait( 0.05 ); 
			level notify( "controls_active" ); // Notify when player controls have been restored
			wait( 0.05 ); 
			flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
			break; 
	}
	
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	/#
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _introscreen.gsc. Function: main() - COMPLETE\n");
	#/
}

// creates a hud-element for the specified string and sets its initial values
introscreen_create_line( string, type, scale, font )
{
	index = level.introstring.size; 
	yPos = ( index * 30 ); 
	
	if (level.console)
	{
		yPos -= 90; 
		xPos = 0;
	}
	else
	{
		yPos -= 120;
		xPos = 10;
	}

	align_x = "center";
	align_y = "middle";
	horz_align = "center";
	vert_align = "middle";

	// MikeD (4/28/2008): Default to lower left
	if( !IsDefined( type ) )
	{
		type = "lower_left";
	}

	if( IsDefined( type ) )
	{
		switch( type )
		{
			case "lower_left":
				yPos -= 30;
				align_x = "left";
				align_y = "bottom";
				horz_align = "left";
				vert_align = "bottom";
				break;
		}
	}

	if ( !isDefined( scale ) )
	{
		if ( level.splitscreen && !level.hidef )
			fontScale = 2.75;
		else
			fontScale = 1.75;
	}
	else
		fontScale = scale;
	
	level.introstring[index] = NewHudElem(); 
	level.introstring[index].x = xPos; 
	level.introstring[index].y = yPos; 
	level.introstring[index].alignX = align_x; 
	level.introstring[index].alignY = align_y; 
	level.introstring[index].horzAlign = horz_align; 
	level.introstring[index].vertAlign = vert_align; 
	level.introstring[index].sort = 1; // force to draw after the background
	level.introstring[index].foreground = true; 
	level.introstring[index].fontScale = fontScale; 
	level.introstring[index] SetText( string ); 
	level.introstring[index].alpha = 0; 
	level.introstring[index] FadeOverTime( 1.2 ); 
	level.introstring[index].alpha = 1; 

	if( IsDefined( font ) )
	{
		level.introstring[index].font = font;
	}
}

// fades out each line of text, then destroys each hud-element associated with each line
introscreen_fadeOutText()
{
	for( i = 0; i < level.introstring.size; i++ )
	{
		level.introstring[i] FadeOverTime( 1.5 ); 
		level.introstring[i].alpha = 0; 
	}

	wait( 1.5 ); 

	for( i = 0; i < level.introstring.size; i++ )
	{
		level.introstring[i] Destroy(); 
	}
}


// handles the displaying and fading of introscreen strings
//
//String1 = Title of the level
//String2 = Place, Country or just Country
//String3 = Month Day, Year
//String4 = Optional additional detailed information
//Pausetime1 = length of pause in seconds after title of level
//Pausetime2 = length of pause in seconds after Month Day, Year
//Pausetime3 = length of pause in seconds before the level fades in 

introscreen_delay( string1, string2, string3, string4, string5, pausetime1, pausetime2, timebeforefade )
{
	/#
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	if( getdebugdvar( "replay_debug" ) == "1" )
	{
		println("File: _introscreen.gsc. Function: introscreen_delay()\n");
	
		println("File: _introscreen.gsc. Function: introscreen_delay() - START WAIT waittillframeend x2\n");
	}
	
	// MikeD: use waittillframend so starts get setup properly before the introscreen refers to any
	// level.start
	waittillframeend; 
	waittillframeend; 

	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _introscreen.gsc. Function: introscreen_delay() - STOP WAIT waittillframeend x2\n");
	
	// SCRIPTER_MOD
	// MikeD( 3/16/200 ):  level.start_point is for their start, ( aka skipto ) stuff... But it did not check to see if it's already defined.
	skipIntro = false; 
	if( IsDefined( level.start ) )
	{
		skipIntro = level.start_point != "default"; 
	}

	if( GetDvar( "introscreen" ) == "0" )
	{
		skipIntro = true; 
	}
		
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _introscreen.gsc. Function: introscreen_delay() - BEFORE VARIOUS WAITS\n");
	
	if( skipIntro )
	{
		// wait until the first player spawns into the game before sending
		// out the introscreen notifies
		//level waittill("first_player_ready",player);
		flag_wait( "all_players_connected" );
		
		if( IsDefined( level.custom_introscreen ) )
		{
			[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
			return;
		}
	
		waittillframeend; 
		level notify( "finished final intro screen fadein" ); 
		waittillframeend; 
		flag_set( "starting final intro screen fadeout" ); 
		waittillframeend; 
		level notify( "controls_active" ); // Notify when player controls have been restored
		waittillframeend; 
		flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" ); 
		return; 
	}
	#/

	if( IsDefined( level.custom_introscreen ) )
	{
		[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
		return;
	}

	// CODER_MOD: Austin (8/15/08): wait until all players have connected before showing black screen
	// the briefing menu will be displayed for network co-op in synchronize_players()
	flag_wait( "all_players_connected" );

	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true;
	level.introblack SetShader( "black", 640, 480 );

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	freezecontrols_all( true ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	wait( 0.5 ); // Used to be 0.05, but we have to wait longer since the save takes precisely a half-second to finish.
 
	level.introstring = []; 
	
	//Title of level
	
	if( IsDefined( string1 ) )
	{
		introscreen_create_line( string1 ); 
	}
	
	if( IsDefined( pausetime1 ) )
	{
		wait( pausetime1 ); 
	}
	else
	{
		wait( 2 ); 	
	}
	
	//City, Country, Date
	
	if( IsDefined( string2 ) )
	{
		introscreen_create_line( string2 ); 
	}

	if( IsDefined( string3 ) )
	{
		introscreen_create_line( string3 ); 
	}
	
	//Optional Detailed Statement
	
	if( IsDefined( string4 ) )
	{
		if( IsDefined( pausetime2 ) )
		{
			wait( pausetime2 ); 
		}
		else
		{
			wait( 2 ); 
		}

		introscreen_create_line( string4 ); 
	}

	if( IsDefined( string5 ) )
	{
		if( IsDefined( pausetime2 ) )
		{
			wait( pausetime2 ); 
		}
		else
		{
			wait( 2 ); 
		}

		introscreen_create_line( string5 ); 
	}

	level notify( "finished final intro screen fadein" );
	
	// SRS 7/14/2008: scripter can make introscreen wait on text before fading up
	if( IsDefined( level.introscreen_waitontext_flag ) )
	{
		level notify( "introscreen_blackscreen_waiting_on_flag" );
		flag_wait( level.introscreen_waitontext_flag );
	}
	
	if( IsDefined( timebeforefade ) )
	{
		wait( timebeforefade ); 
	}
	else
	{
		wait( 3 ); 
	}

	// Fade out black
	level.introblack FadeOverTime( 1.5 ); 
	level.introblack.alpha = 0; 

	flag_set( "starting final intro screen fadeout" );
	
	// Restore player controls part way through the fade in
	level thread freezecontrols_all( false, 0.75 ); // 0.75 delay, since the autosave does a 0.5 delay

	level._introscreen = false;

	level notify( "controls_active" ); // Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
	
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	/#
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _introscreen.gsc. Function: introscreen_delay() - COMPLETE\n");
	#/
}

introscreen_player_connect()
{
	// MikeD (11/14/2007): If player connects during the introscreen, then freeze their controls.
	if( IsDefined(level._introscreen) && level._introscreen )
	{
		self FreezeControls( true );
	}
}

introscreen_report_disconnected_clients()
{
	flag_wait("introscreen_complete");
	
	if(isdefined(level._disconnected_clients))
	{
		for(i = 0; i < level._disconnected_clients.size; i ++)
		{
			ReportClientDisconnected(level._disconnected_clients[i]);
		}
	}
}