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
	flag_init( "pullup_weapon" ); 
	flag_init( "starting final intro screen fadeout" );
	flag_init( "introscreen_complete" ); // used to notify when introscreen is complete
	
	PrecacheShader( "black" ); 
	
	if( GetDvar( "introscreen" ) == "" )
	{
		SetDvar( "introscreen", "1" ); 
	}

	level.splitscreen = GetDvarint( "splitscreen" );
	level.hidef = GetDvarint( "hidef" );

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
	
		
		case "angola":
			introscreen_delay( &"ANGOLA_INTROSCREEN_TITLE", &"ANGOLA_INTROSCREEN_PLACE", &"ANGOLA_INTROSCREEN_TARGET", &"ANGOLA_INTROSCREEN_TEAM", &"ANGOLA_INTROSCREEN_DATE");
			break;
			
		case "haiti":
			level.introscreen_shader_fadeout_time = 1.0;
			level.introscreen_shader = "black";
			introscreen_typewriter_delay( &"HAITI_INTROSCREEN_PLACE", &"HAITI_INTROSCREEN_CHARACTER", &"HAITI_INTROSCREEN_TITLE", &"HAITI_INTROSCREEN_DATE", undefined, 0.05, 0.25, 1.5, 10, 0, (1,1,1) );
			break;
			
		case "nicaragua":
			level.introscreen_shader = "none";
			level.introscreen_dontfreezcontrols = true;
			introscreen_delay(  &"NICARAGUA_INTROSCREEN_TITLE", &"NICARAGUA_INTROSCREEN_PLACE", &"NICARAGUA_INTROSCREEN_TARGET", &"NICARAGUA_INTROSCREEN_TEAM", &"NICARAGUA_INTROSCREEN_DATE" );
			break;
			
		case "monsoon":
			introscreen_delay( &"MONSOON_INTROSCREEN_TITLE", &"MONSOON_INTROSCREEN_PLACE", &"MONSOON_INTROSCREEN_TARGET", &"MONSOON_INTROSCREEN_TEAM", &"MONSOON_INTROSCREEN_DATE");
			break;
					
		case "so_cmp_afghanistan":
			introscreen_delay( &"AFGHANISTAN_INTROSCREEN_TITLE", &"AFGHANISTAN_INTROSCREEN_PLACE", &"AFGHANISTAN_INTROSCREEN_CHARACTER", &"AFGHANISTAN_INTROSCREEN_DATE" );
			break;

		case "pakistan":
			level.introscreen_shader = "none";
			level.introscreen_dontfreezcontrols = true;
			introscreen_delay(  &"PAKISTAN_SHARED_INTROSCREEN_TITLE", &"PAKISTAN_SHARED_INTROSCREEN_PLACE", &"PAKISTAN_SHARED_INTROSCREEN_TARGET", &"PAKISTAN_SHARED_INTROSCREEN_TEAM", &"PAKISTAN_SHARED_INTROSCREEN_DATE" );
			break;
			
		case "karma":
			//introscreen_redact_delay( &"KARMA_INTROSCREEN_TITLE", &"KARMA_INTROSCREEN_PLACE", &"KARMA_INTROSCREEN_TARGET", &"KARMA_INTROSCREEN_TEAM", &"KARMA_INTROSCREEN_DATE", 2, 10, 1.5, 1.8, 2 );
			introscreen_typewriter_delay( &"KARMA_INTROSCREEN_TITLE", &"KARMA_INTROSCREEN_PLACE", &"KARMA_INTROSCREEN_TARGET", &"KARMA_INTROSCREEN_TEAM", &"KARMA_INTROSCREEN_DATE", 0.05, 1, 1.2, 10, 0 );
			break;
		
		case "blackout":
			level.introscreen_shader_fadeout_time = .05;
			level.introscreen_shader = "black";
			//introscreen_redact_delay( &"BLACKOUT_INTROSCREEN_TITLE", &"BLACKOUT_INTROSCREEN_PLACE", &"BLACKOUT_INTROSCREEN_PERSON", &"BLACKOUT_INTROSCREEN_TEAM", &"BLACKOUT_INTROSCREEN_DATE", 2, 10, 1.5, 1.8, 2 );
			introscreen_typewriter_delay( &"BLACKOUT_INTROSCREEN_TITLE", &"BLACKOUT_INTROSCREEN_PLACE", &"BLACKOUT_INTROSCREEN_PERSON", &"BLACKOUT_INTROSCREEN_TEAM", &"BLACKOUT_INTROSCREEN_DATE", 0.05, 0.25, 1.5, 10, 0, (1,1,1) );
			break;

		case "la_1":
			level.introscreen_waitontext_flag = "end_intro_screen";
			level.introscreen_shader_fadeout_time = .05;
			level.introscreen_shader = "black";
			//introscreen_redact_delay( &"LA_SHARED_INTROSCREEN_TITLE", &"LA_SHARED_INTROSCREEN_PLACE", &"LA_SHARED_INTROSCREEN_TARGET", &"LA_SHARED_INTROSCREEN_TEAM", &"LA_SHARED_INTROSCREEN_DATE", 1.5, 10, 1.5, 0, 2, (1,1,1) );
			introscreen_typewriter_delay( &"LA_SHARED_INTROSCREEN_TITLE", &"LA_SHARED_INTROSCREEN_PLACE", &"LA_SHARED_INTROSCREEN_TARGET", &"LA_SHARED_INTROSCREEN_TEAM", &"LA_SHARED_INTROSCREEN_DATE", 0.05, 0.25, 1.5, 10, 0, (1,1,1) );
			break;
			
		case "la_1b":
			introscreen_delay();
			break;	

		case "panama":
			introscreen_delay( &"PANAMA_INTROSCREEN_TITLE", &"PANAMA_INTROSCREEN_PLACE", &"PANAMA_INTROSCREEN_TARGET", &"PANAMA_INTROSCREEN_DATE");
			break;
			
		case "la_2":
			introscreen_delay();
			break;					
		
		case "yemen":
			level.introscreen_shader_fadeout_time = .05;
			level.introscreen_shader = "black";
			introscreen_typewriter_delay( &"YEMEN_INTROSCREEN_TITLE", &"YEMEN_INTROSCREEN_PLACE", &"YEMEN_INTROSCREEN_TARGET", &"YEMEN_INTROSCREEN_TEAM", undefined, undefined, undefined, undefined, undefined, undefined, (1, 1, 1));
			break;
			
		case "so_rts_mp_dockside":
			introscreen_typewriter_delay( &"SO_RTS_MP_DOCKSIDE_INTROSCREEN_TITLE", &"SO_RTS_MP_DOCKSIDE_INTROSCREEN_PLACE", &"SO_RTS_MP_DOCKSIDE_INTROSCREEN_TEAM", &"SO_RTS_MP_DOCKSIDE_INTROSCREEN_DATE" );
			break;
		case "so_rts_mp_socotra":
			introscreen_typewriter_delay( &"SO_RTS_MP_SOCOTRA_INTROSCREEN_TITLE", &"SO_RTS_MP_SOCOTRA_INTROSCREEN_PLACE", &"SO_RTS_MP_SOCOTRA_INTROSCREEN_TEAM", &"SO_RTS_MP_SOCOTRA_INTROSCREEN_DATE" );
			break;
		case "so_rts_afghanistan":
			introscreen_typewriter_delay( &"SO_RTS_AFGHANISTAN_INTROSCREEN_TITLE", &"SO_RTS_AFGHANISTAN_INTROSCREEN_PLACE", &"SO_RTS_AFGHANISTAN_INTROSCREEN_TEAM", &"SO_RTS_AFGHANISTAN_INTROSCREEN_DATE" );
			break;
		case "so_rts_mp_overflow":
			introscreen_typewriter_delay( &"SO_RTS_MP_OVERFLOW_INTROSCREEN_TITLE", &"SO_RTS_MP_OVERFLOW_INTROSCREEN_PLACE", &"SO_RTS_MP_OVERFLOW_INTROSCREEN_TEAM", &"SO_RTS_MP_OVERFLOW_INTROSCREEN_DATE" );
			break;
		case "so_rts_mp_drone":
			introscreen_typewriter_delay( &"SO_RTS_MP_DRONE_INTROSCREEN_TITLE", &"SO_RTS_MP_DRONE_INTROSCREEN_PLACE", &"SO_RTS_MP_DRONE_INTROSCREEN_TEAM", &"SO_RTS_MP_DRONE_INTROSCREEN_DATE" );
			break;
		case "so_rts_mp_carrier":
			introscreen_typewriter_delay( &"SO_RTS_MP_CARRIER_INTROSCREEN_TITLE", &"SO_RTS_MP_CARRIER_INTROSCREEN_PLACE", &"SO_RTS_MP_CARRIER_INTROSCREEN_TEAM", &"SO_RTS_MP_CARRIER_INTROSCREEN_DATE" );
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
}

/@
"Name: introscreen_create_redacted_line()"
"Summary: creates a hud-element for the specified string ,sets its initial values, and does the redaction."
"CallOn: level"
"MandatoryArg: <string> : String for this line to display."
"OptionalArg: <redacted_line_time> : Time before string line starts to fade out"
"OptionalArg: <start_rubout_time> : Time before string line starts to get the rubout / redacted effect."
"OptionalArg: <rubout_time> : Time it takes to finish rub/redacting one line of text from when it starts."
"OptionalArg: <color> : color of text"
"OptionalArg: <type> : Determines placement of text."
"OptionalArg: <scale> : Determines size of text."
"OptionalArg: <font> : Sets the font of the text."

"introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time ); "
"SPMP: singleplayer"
@/ 
introscreen_create_redacted_line( string, redacted_line_time, start_rubout_time, rubout_time, color, type, scale, font )
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
			fontScale = 2.5;
		else
			fontScale = 1.5;
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
	level.introstring[index].color = (0,0,0);
	level.introstring[index] SetText( string );
	level.introstring[index] SetRedactFX( redacted_line_time, 700, start_rubout_time, rubout_time ); // param1 - time before text fades away, param2 - time it takes text to fade away, param 3 - time before start redacting text , param 4 - time it takes to cross out text
	level.introstring[index].alpha = 0; 
	level.introstring[index] FadeOverTime( 1.2 ); 
	level.introstring[index].alpha = 1; 

	if( IsDefined( font ) )
	{
		level.introstring[index].font = font;
	}
	
	if( IsDefined( color ) )
	{
		level.introstring[index].color = color;
	}

	if( IsDefined( level.introstring_text_color ) )
	{
		level.introstring[index].color =  level.introstring_text_color;
	}
}

/@
"Name: introscreen_create_typewriter_line()"
"Summary: creates a hud-element for the specified string ,sets its initial values, and displays with the typewriter effect."
"CallOn: level"
"MandatoryArg: <string> : String for this line to display."
"OptionalArg: <letter_time> : Time it takes for each character to type in."
"OptionalArg: <decay_start_time> : Time before string starts fading out."
"OptionalArg: <decay_duration> : Time it takes for string to fade out."
"OptionalArg: <color> : color of text"
"OptionalArg: <type> : Determines placement of text."
"OptionalArg: <scale> : Determines size of text."
"OptionalArg: <font> : Sets the font of the text."

"introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time ); "
"SPMP: singleplayer"
@/ 
introscreen_create_typewriter_line( string, letter_time, decay_start_time, decay_duration, color, type, font )
{
	index = level.introstring.size;
	
	// TODO: figure out the font sizes for !level.hidef
	// the first two lines are bigger than the others
	// the last line is the smallest
	if ( index <= 1 )
	{
		scale = 2;
		yPos = ( index * 20 );
	}
	else if ( index == 4 )
	{
		scale = 1.2;
		yPos = ( index * 15 );
	}
	else
	{
		scale = 1.5;
		yPos = ( index * 15 ) + 5;
	}
	
	if (level.console)
	{
		yPos -= 60; 
		xPos = 0;
	}
	else
	{
		yPos -= 90;
		xPos = 20;
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
			fontScale = 2.5;
		else
			fontScale = 1.5;
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
	level.introstring[index].color = (0,0,0);
	level.introstring[index] SetText( string );
	level.introstring[index] SetTypewriterFX( letter_time, decay_start_time, decay_duration );
	level.introstring[index].alpha = 0; 
	level.introstring[index] FadeOverTime( 1.2 ); 
	level.introstring[index].alpha = 1; 

	if( IsDefined( font ) )
	{
		level.introstring[index].font = font;
	}
	
	if( IsDefined( color ) )
	{
		level.introstring[index].color = color;
	}

	if( IsDefined( level.introstring_text_color ) )
	{
		level.introstring[index].color =  level.introstring_text_color;
	}
}

// creates a hud-element for the specified string and sets its initial values
introscreen_create_line( string, type, scale, font, color )
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
	
	if( IsDefined( color ) )
	{
		level.introstring[index].color = color;
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
	
	wait(0.25);
	
}




/@
"Name: introscreen_redact_delay()"
"Summary: Does the introscreen, displays strings, with redacted effect."
"CallOn: level"
"MandatoryArg: <string1> : 1st string in the introscreen."
"OptionalArg: <string2> : 2nd string in the introscreen."
"OptionalArg: <string3> : 3rd string in the introscreen."
"OptionalArg: <string4> : 4th string in the introscreen."
"OptionalArg: <string5> : 5th string in the introscreen."
"OptionalArg: <pausetime> : Amount of time to pause before starting to display each consecutive string line."
"OptionalArg: <totaltime> : Total time all introscreen text will be displayed."
"OptionalArg: <time_to_redact> : Time at which the first string starts to be redacted ."
"OptionalArg: <delay_after_text> : Time to wait after text all fades away before background hudelem fades."
"OptionalArg: <rubout_time> : Time it takes to redact one line of text.  Temp until we have a code solution to handle based on string length"

"introscreen_redact_delay( &"HUE_CITY_INTROSCREEN_LINE1", &"HUE_CITY_INTROSCREEN_LINE2", &"HUE_CITY_INTROSCREEN_LINE3", &"HUE_CITY_INTROSCREEN_LINE4", &"HUE_CITY_INTROSCREEN_LINE5"  );"
"SPMP: singleplayer"
@/ 
introscreen_redact_delay( string1, string2, string3, string4, string5, pausetime, totaltime, time_to_redact, delay_after_text, rubout_time, color )
{
// MikeA:	TODO Put this comment block back in before we SHIP
//			Currently commented out so we don't get the redacted text in ShipCheats using checkpoints
//	/#
	// MikeD: use waittillframend so starts get setup properly before the introscreen refers to any
	// level.start
	waittillframeend; 
	waittillframeend; 

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ):  level.start_point is for their start, ( aka skipto ) stuff... But it did not check to see if it's already defined.
	//[ceng 5/18/2010] Fixed typo from IsDefined( level.start ) to IsDefined( level.start_point ).
	skipIntro = false; 
	if( IsDefined( level.start_point ) )
	{
		skipIntro = level.start_point != "default"; 
	}
	
	// TFLAME - 3/31/11 - start's days are numbered, now is the era of the skipto!
	if( IsDefined( level.skipto_point ) )
	{
		skipIntro = !maps\_skipto::is_default_skipto(); 
	}

	if( GetDvar( "introscreen" ) == "0" || level.createFX_enabled )
	{
		skipIntro = true; 
	}
		
	if( skipIntro )
	{
		//-- if the level did an early black
		if(IsDefined(level.introblack))
		{
			level.introblack Destroy();
		}
		
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
//	#/

	if( IsDefined( level.custom_introscreen ) )
	{
		[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
		return;
	}

	//-- The level may set this screen up early, if the game is drawing before the screen comes up
	if(!IsDefined(level.introblack))
	{
		level.introblack = NewHudElem(); 
		level.introblack.x = 0; 
		level.introblack.y = 0; 
		level.introblack.horzAlign = "fullscreen"; 
		level.introblack.vertAlign = "fullscreen"; 
		level.introblack.foreground = true;
	
		// Alex Liu 6-26-10: Added a way for a level to specify a introscreen shader, such as "white"
		// level is responsible to precache its own shader.  set to "none" if you want none
		if( !isdefined( level.introscreen_shader ) )
		{
			level.introblack SetShader( "white", 640, 480 );
		}
		else if (level.introscreen_shader != "none")
		{
			level.introblack SetShader( level.introscreen_shader, 640, 480 );
		}
	}


	// CODER_MOD: Austin (8/15/08): wait until all players have connected before showing black screen
	// the briefing menu will be displayed for network co-op in synchronize_players()
	flag_wait( "all_players_connected" );

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	if( !IsDefined( level.introscreen_dontfreezcontrols ) )
		freezecontrols_all( true ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	wait( 0.5 ); // Used to be 0.05, but we have to wait longer since the save takes precisely a half-second to finish.
 
	level.introstring = []; 
	
	
	if( !IsDefined( pausetime ) ) 
	{
		pausetime = 0.75;
	}
	if (!IsDefined(totaltime))
	{
		totaltime = 14.25;
	}
	if (!IsDefined(time_to_redact))
	{
		time_to_redact = ( 0.525 * totaltime);
	}
	if (!IsDefined(rubout_time))
	{
		rubout_time = 1;
	}

	const delay_between_redacts_min = 350; // this is a slight pause added when redacting each line, so it isn't robotically smooth
	const delay_between_redacts_max = 500;
	
	start_rubout_time = Int( time_to_redact*1000 );// convert to miliseconds and fraction of total time to start rubbing out the text
	totalpausetime = 0; // track how much time we've waited so we can wait total desired waittime
	rubout_time = Int(rubout_time*1000); // convert to miliseconds 

			// following 2 lines are used in and logically could exist in isdefined(string1), but need to be initialized so exist here
	redacted_line_time = Int( 1000* (totaltime - totalpausetime) ); // each consecutive line waits the total time minus the total pause time so far, so they all go away at once.



	if( IsDefined( string1 ) )
	{
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
		
		level thread introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time, color, undefined, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;	
	}

	if( IsDefined( string2 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min,delay_between_redacts_max);
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
				
		level thread introscreen_create_redacted_line( string2, redacted_line_time, start_rubout_time, rubout_time, color, undefined, undefined, "objective" ); 

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min,delay_between_redacts_max);	
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
	
		
		level thread introscreen_create_redacted_line( string3, redacted_line_time,  start_rubout_time, rubout_time, color, undefined, undefined, "objective" ); 

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}
	
	if( IsDefined( string4 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) )	+ RandomIntRange(delay_between_redacts_min,delay_between_redacts_max);		
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
	
		
		level thread introscreen_create_redacted_line( string4, redacted_line_time, start_rubout_time, rubout_time, color, undefined, undefined, "objective" ); 

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}		
	
	if( IsDefined( string5 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min,delay_between_redacts_max);			
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
	
		level thread introscreen_create_redacted_line( string5, redacted_line_time, start_rubout_time, rubout_time, color, undefined, undefined, "objective" ); 
	
		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	level notify( "finished final intro screen fadein" );
	
	// SRS 7/14/2008: scripter can make introscreen wait on text before fading up
	if( IsDefined( level.introscreen_waitontext_flag ) )
	{
		level notify( "introscreen_blackscreen_waiting_on_flag" );
		flag_wait( level.introscreen_waitontext_flag );
	}
	else
	{
		wait (totaltime - totalpausetime);
		
		if (IsDefined(delay_after_text))
		{
			wait delay_after_text;
		}
		else
		{
			wait 2.5;
		}
	}
	
	waittill_textures_loaded();

	// fadeout introscreen shader
	if( IsDefined( level.introscreen_shader_fadeout_time ) )
		level.introblack FadeOverTime( level.introscreen_shader_fadeout_time ); 
	else
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
}


/@
"Name: introscreen_typewriter_delay()"
"Summary: Does the introscreen, displays strings, with typewriter effects."
"CallOn: level"
"MandatoryArg: <string1> : 1st string in the introscreen."
"OptionalArg: <string2> : 2nd string in the introscreen."
"OptionalArg: <string3> : 3rd string in the introscreen."
"OptionalArg: <string4> : 4th string in the introscreen."
"OptionalArg: <string5> : 5th string in the introscreen."
"OptionalArg: <letter_time> : Time it takes for each character to type in."
"OptionalArg: <decay_duration> : Time it takes for the line to fade out."
"OptionalArg: <pausetime> : Time to delay before displaying the next line."
"OptionalArg: <totaltime> : Total time all introscreen text will be displayed."
"OptionalArg: <delay_after_text> : Time to wait after text all fades away before background hudelem fades."

"introscreen_typewriter_delay( &"KARMA_INTROSCREEN_TITLE", &"KARMA_INTROSCREEN_PLACE", &"KARMA_INTROSCREEN_TARGET", &"KARMA_INTROSCREEN_TEAM", &"KARMA_INTROSCREEN_DATE", 0.1, 0.5, 2, 10, 1.8 );"
"SPMP: singleplayer"
@/ 
introscreen_typewriter_delay( string1, string2, string3, string4, string5, letter_time, decay_duration, pausetime, totaltime, delay_after_text, color )
{
// MikeA:	TODO Put this comment block back in before we SHIP
//			Currently commented out so we don't get the redacted text in ShipCheats using checkpoints
//	/#
	// MikeD: use waittillframend so starts get setup properly before the introscreen refers to any
	// level.start
	waittillframeend; 
	waittillframeend; 

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ):  level.start_point is for their start, ( aka skipto ) stuff... But it did not check to see if it's already defined.
	//[ceng 5/18/2010] Fixed typo from IsDefined( level.start ) to IsDefined( level.start_point ).
	skipIntro = false; 
	if( IsDefined( level.start_point ) )
	{
		skipIntro = level.start_point != "default"; 
	}
	
	// TFLAME - 3/31/11 - start's days are numbered, now is the era of the skipto!
	if( IsDefined( level.skipto_point ) )
	{
		skipIntro = !maps\_skipto::is_default_skipto(); 
	}

	if( GetDvar( "introscreen" ) == "0" || level.createFX_enabled )
	{
		skipIntro = true; 
	}
		
	if( skipIntro )
	{
		//-- if the level did an early black
		if(IsDefined(level.introblack))
		{
			level.introblack Destroy();
		}
		
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
//	#/

	if( IsDefined( level.custom_introscreen ) )
	{
		[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
		return;
	}

	//-- The level may set this screen up early, if the game is drawing before the screen comes up
	if(!IsDefined(level.introblack))
	{
		level.introblack = NewHudElem(); 
		level.introblack.x = 0; 
		level.introblack.y = 0; 
		level.introblack.horzAlign = "fullscreen"; 
		level.introblack.vertAlign = "fullscreen"; 
		level.introblack.foreground = true;
	
		// Alex Liu 6-26-10: Added a way for a level to specify a introscreen shader, such as "white"
		// level is responsible to precache its own shader.  set to "none" if you want none
		if( !isdefined( level.introscreen_shader ) )
		{
			level.introblack SetShader( "white", 640, 480 );
		}
		else if (level.introscreen_shader != "none")
		{
			level.introblack SetShader( level.introscreen_shader, 640, 480 );
		}
	}


	// CODER_MOD: Austin (8/15/08): wait until all players have connected before showing black screen
	// the briefing menu will be displayed for network co-op in synchronize_players()
	flag_wait( "all_players_connected" );

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	if( !IsDefined( level.introscreen_dontfreezcontrols ) )
		freezecontrols_all( true ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	wait( 0.5 ); // Used to be 0.05, but we have to wait longer since the save takes precisely a half-second to finish.
 
	level.introstring = []; 
	
	if (!IsDefined(letter_time))
	{
		letter_time = 0.1;
	}
	if (!IsDefined(decay_duration))
	{
		decay_duration = 0.5;
	}
	if (!IsDefined(pausetime))
	{
		pausetime = 1.5;
	}
	if (!IsDefined(totaltime))
	{
		totaltime = 14.25;
	}
	
	letter_time 		= Int( 1000 * letter_time );  		// convert to milliseconds
	decay_duration 		= Int( 1000 * decay_duration );		// convert to milliseconds
	decay_start 		= Int( 1000 * totaltime ); 			// convert to milliseconds
	totalpausetime		= 0; 								// track how much time we've waited so we can wait total desired waittime

	if( IsDefined( string1 ) )
	{
		level thread introscreen_create_typewriter_line( string1, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 
		
		wait( pausetime );
		totalpausetime += pausetime;
	}

	if( IsDefined( string2 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread introscreen_create_typewriter_line( string2, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread introscreen_create_typewriter_line( string3, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}
	
	if( IsDefined( string4 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread introscreen_create_typewriter_line( string4, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}		
	
	if( IsDefined( string5 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread introscreen_create_typewriter_line( string5, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}

	level notify( "finished final intro screen fadein" );
	
	// SRS 7/14/2008: scripter can make introscreen wait on text before fading up
	if( IsDefined( level.introscreen_waitontext_flag ) )
	{
		level notify( "introscreen_blackscreen_waiting_on_flag" );
		flag_wait( level.introscreen_waitontext_flag );
	}
	else
	{
		wait (totaltime - totalpausetime);
		
		if (IsDefined(delay_after_text))
		{
			wait delay_after_text;
		}
		else
		{
			wait 2.5;
		}
	}
	
	waittill_textures_loaded();

	// fadeout introscreen shader
	if( IsDefined( level.introscreen_shader_fadeout_time ) )
		level.introblack FadeOverTime( level.introscreen_shader_fadeout_time ); 
	else
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

introscreen_delay( string1, string2, string3, string4, string5, pausetime1, pausetime2, timebeforefade, skipwait )
{
	/#
	// MikeD: use waittillframend so starts get setup properly before the introscreen refers to any
	// level.start
	waittillframeend; 
	waittillframeend; 

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ):  level.start_point is for their start, ( aka skipto ) stuff... But it did not check to see if it's already defined.
	//[ceng 5/18/2010] Fixed typo from IsDefined( level.start ) to IsDefined( level.start_point ).
	skipIntro = false; 
	if( IsDefined( level.start_point ) )
	{
		skipIntro = level.start_point != "default"; 
	}

	if( IsDefined( level.skipto_point ) )
	{
		skipIntro = !maps\_skipto::is_default_skipto(); 
	}
	
	if( GetDvar( "introscreen" ) == "0"  || level.createFX_enabled )
	{
		skipIntro = true; 
	}
		
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

	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true;
	
	// Alex Liu 6-26-10: Added a way for a level to specify a introscreen shader, such as "white"
	// level is responsible to precache its own shader
	if( !isdefined( level.introscreen_shader ) )
	{
		level.introblack SetShader( "black", 640, 480 );
	}
	else if ( level.introscreen_shader != "none")
	{
		level.introblack SetShader( level.introscreen_shader, 640, 480 );
	}
	
	if(!IsDefined(skipwait))
	{
		flag_wait( "all_players_connected" );
	}

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	if( !IsDefined( level.introscreen_dontfreezcontrols ) )
		freezecontrols_all( true ); 
	
	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	if(IsDefined(skipwait))
	{
		flag_wait( "all_players_connected" );
	}
	
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
	
	waittill_textures_loaded();

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

//If for some reason (Rebirth), this will be called more than once in a level
introscreen_clear_redacted_flags()
{
	flag_clear("introscreen_complete");
	flag_clear( "starting final intro screen fadeout" );
}
