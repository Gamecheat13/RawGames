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
	flag_init( "introscreen_complete" ); // used to notify when introscreen is complete
	
	PrecacheShader( "black" ); 

	if( GetDvar( "introscreen" ) == "" )
	{
		SetDvar( "introscreen", "1" ); 
	}
	
	
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
		case "trn":
			PrecacheString( &"TRN_INTROSCREEN_TITLE" );
			PrecacheString( &"TRN_INTROSCREEN_PLACE" );
			PrecacheString( &"TRN_INTROSCREEN_DATE" );
			PrecacheString( &"TRN_INTROSCREEN_INFO" );
			introscreen_delay( &"TRN_INTROSCREEN_TITLE", &"TRN_INTROSCREEN_PLACE", &"TRN_INTROSCREEN_DATE", &"TRN_INTROSCREEN_INFO" );
			break;

		case "mak":
			PrecacheString( &"MAK_INTROSCREEN_TITLE" );
			PrecacheString( &"MAK_INTROSCREEN_PLACE" );
			PrecacheString( &"MAK_INTROSCREEN_DATE" );
			PrecacheString( &"MAK_INTROSCREEN_INFO" );
			introscreen_delay( &"MAK_INTROSCREEN_TITLE", &"MAK_INTROSCREEN_PLACE", &"MAK_INTROSCREEN_DATE", &"MAK_INTROSCREEN_INFO" );
			break;

		case "pel1":
			PrecacheString( &"PEL1_INTROSCREEN_TITLE" );
			PrecacheString( &"pEL1_INTROSCREEN_PLACE" );
			PrecacheString( &"PEL1_INTROSCREEN_DATE" );
			PrecacheString( &"PEL1_INTROSCREEN_INFO" );
			introscreen_delay( &"PEL1_INTROSCREEN_TITLE", &"PEL1_INTROSCREEN_PLACE", &"PEL1_INTROSCREEN_DATE", &"PEL1_INTROSCREEN_INFO" );
			break;

		case "pel2":
			PrecacheString( &"PEL2_INTROSCREEN_TITLE" );
			PrecacheString( &"pEL2_INTROSCREEN_PLACE" );
			PrecacheString( &"PEL2_INTROSCREEN_DATE" );
			PrecacheString( &"PEL2_INTROSCREEN_INFO" );
			introscreen_delay( &"PEL2_INTROSCREEN_TITLE", &"PEL2_INTROSCREEN_PLACE", &"PEL2_INTROSCREEN_DATE", &"PEL2_INTROSCREEN_INFO" );
			break;

		case "fly":
			PrecacheString( &"FLY_INTROSCREEN_TITLE" );
			PrecacheString( &"FLY_INTROSCREEN_PLACE" );
			PrecacheString( &"FLY_INTROSCREEN_DATE" );
			PrecacheString( &"FLY_INTROSCREEN_INFO" );
			introscreen_delay( &"FLY_INTROSCREEN_TITLE", &"FLY_INTROSCREEN_PLACE", &"FLY_INTROSCREEN_DATE", &"FLY_INTROSCREEN_INFO" );
			break;

		case "hol1":
			PrecacheString( &"HOL1_INTROSCREEN_TITLE" );
			PrecacheString( &"hOL1_INTROSCREEN_PLACE" );
			PrecacheString( &"HOL1_INTROSCREEN_DATE" );
			PrecacheString( &"HOL1_INTROSCREEN_INFO" );
			introscreen_delay( &"HOL1_INTROSCREEN_TITLE", &"HOL1_INTROSCREEN_PLACE", &"HOL1_INTROSCREEN_DATE", &"HOL1_INTROSCREEN_INFO" );
			break;

		case "hol2":
			PrecacheString( &"HOL2_INTROSCREEN_TITLE" );
			PrecacheString( &"hOL2_INTROSCREEN_PLACE" );
			PrecacheString( &"HOL2_INTROSCREEN_DATE" );
			PrecacheString( &"HOL2_INTROSCREEN_INFO" );
			introscreen_delay( &"HOL2_INTROSCREEN_TITLE", &"HOL2_INTROSCREEN_PLACE", &"HOL2_INTROSCREEN_DATE", &"HOL2_INTROSCREEN_INFO" );
			break;

		case "hol3":
			PrecacheString( &"HOL3_INTROSCREEN_TITLE" );
			PrecacheString( &"hOL3_INTROSCREEN_PLACE" );
			PrecacheString( &"HOL3_INTROSCREEN_DATE" );
			PrecacheString( &"HOL3_INTROSCREEN_INFO" );
			introscreen_delay( &"HOL3_INTROSCREEN_TITLE", &"HOL3_INTROSCREEN_PLACE", &"HOL3_INTROSCREEN_DATE", &"HOL3_INTROSCREEN_INFO" );
			break;

		case "see1":
			PrecacheString( &"SEE1_INTROSCREEN_TITLE" );
			PrecacheString( &"sEE1_INTROSCREEN_PLACE" );
			PrecacheString( &"SEE1_INTROSCREEN_DATE" );
			PrecacheString( &"SEE1_INTROSCREEN_INFO" );
			introscreen_delay( &"SEE1_INTROSCREEN_TITLE", &"SEE1_INTROSCREEN_PLACE", &"SEE1_INTROSCREEN_DATE", &"SEE1_INTROSCREEN_INFO" );
			break;

		case "see2":
			PrecacheString( &"SEE2_INTROSCREEN_TITLE" );
			PrecacheString( &"sEE2_INTROSCREEN_PLACE" );
			PrecacheString( &"SEE2_INTROSCREEN_DATE" );
			PrecacheString( &"SEE2_INTROSCREEN_INFO" );
			introscreen_delay( &"SEE2_INTROSCREEN_TITLE", &"SEE2_INTROSCREEN_PLACE", &"SEE2_INTROSCREEN_DATE", &"SEE2_INTROSCREEN_INFO" );
			break;

		case "see3":
			PrecacheString( &"SEE3_INTROSCREEN_TITLE" );
			PrecacheString( &"sEE3_INTROSCREEN_PLACE" );
			PrecacheString( &"SEE3_INTROSCREEN_DATE" );
			PrecacheString( &"SEE3_INTROSCREEN_INFO" );
			introscreen_delay( &"SEE3_INTROSCREEN_TITLE", &"SEE3_INTROSCREEN_PLACE", &"SEE3_INTROSCREEN_DATE", &"SEE3_INTROSCREEN_INFO" );
			break;

		case "rhi1":
			PrecacheString( &"RHI1_INTROSCREEN_TITLE" );
			PrecacheString( &"rHI1_INTROSCREEN_PLACE" );
			PrecacheString( &"RHI1_INTROSCREEN_DATE" );
			PrecacheString( &"RHI1_INTROSCREEN_INFO" );
			introscreen_delay( &"RHI1_INTROSCREEN_TITLE", &"RHI1_INTROSCREEN_PLACE", &"RHI1_INTROSCREEN_DATE", &"RHI1_INTROSCREEN_INFO" );
			break;

		case "rhi2":
			PrecacheString( &"RHI2_INTROSCREEN_TITLE" );
			PrecacheString( &"rHI2_INTROSCREEN_PLACE" );
			PrecacheString( &"RHI2_INTROSCREEN_DATE" );
			PrecacheString( &"RHI2_INTROSCREEN_INFO" );
			introscreen_delay( &"RHI2_INTROSCREEN_TITLE", &"RHI2_INTROSCREEN_PLACE", &"RHI2_INTROSCREEN_DATE", &"RHI2_INTROSCREEN_INFO" );
			break;

		case "rhi3":
			PrecacheString( &"RHI3_INTROSCREEN_TITLE" );
			PrecacheString( &"rHI3_INTROSCREEN_PLACE" );
			PrecacheString( &"RHI3_INTROSCREEN_DATE" );
			PrecacheString( &"RHI3_INTROSCREEN_INFO" );
			introscreen_delay( &"RHI3_INTROSCREEN_TITLE", &"RHI3_INTROSCREEN_PLACE", &"RHI3_INTROSCREEN_DATE", &"RHI3_INTROSCREEN_INFO" );
			break;

		case "oki1":
			PrecacheString( &"OKI1_INTROSCREEN_TITLE" );
			PrecacheString( &"oKI1_INTROSCREEN_PLACE" );
			PrecacheString( &"OKI1_INTROSCREEN_DATE" );
			PrecacheString( &"OKI1_INTROSCREEN_INFO" );
			introscreen_delay( &"OKI1_INTROSCREEN_TITLE", &"OKI1_INTROSCREEN_PLACE", &"OKI1_INTROSCREEN_DATE", &"OKI1_INTROSCREEN_INFO" );
			break;

		case "oki2":
			PrecacheString( &"OKI2_INTROSCREEN_TITLE" );
			PrecacheString( &"oKI2_INTROSCREEN_PLACE" );
			PrecacheString( &"OKI2_INTROSCREEN_DATE" );
			PrecacheString( &"OKI2_INTROSCREEN_INFO" );
			introscreen_delay( &"OKI2_INTROSCREEN_TITLE", &"OKI2_INTROSCREEN_PLACE", &"OKI2_INTROSCREEN_DATE", &"OKI2_INTROSCREEN_INFO" );
			break;

		case "oki3":
			PrecacheString( &"OKI3_INTROSCREEN_TITLE" );
			PrecacheString( &"oKI3_INTROSCREEN_PLACE" );
			PrecacheString( &"OKI3_INTROSCREEN_DATE" );
			PrecacheString( &"OKI3_INTROSCREEN_INFO" );
			introscreen_delay( &"OKI3_INTROSCREEN_TITLE", &"OKI3_INTROSCREEN_PLACE", &"OKI3_INTROSCREEN_DATE", &"OKI3_INTROSCREEN_INFO" );
			break;

		case "ber1":
			PrecacheString( &"BER1_INTROSCREEN_TITLE" );
			PrecacheString( &"bER1_INTROSCREEN_PLACE" );
			PrecacheString( &"BER1_INTROSCREEN_DATE" );
			PrecacheString( &"BER1_INTROSCREEN_INFO" );
			introscreen_delay( &"BER1_INTROSCREEN_TITLE", &"BER1_INTROSCREEN_PLACE", &"BER1_INTROSCREEN_DATE", &"BER1_INTROSCREEN_INFO" );
			break;

		case "ber2":
			PrecacheString( &"BER2_INTROSCREEN_TITLE" );
			PrecacheString( &"bER2_INTROSCREEN_PLACE" );
			PrecacheString( &"BER2_INTROSCREEN_DATE" );
			PrecacheString( &"BER2_INTROSCREEN_INFO" );
			introscreen_delay( &"BER2_INTROSCREEN_TITLE", &"BER2_INTROSCREEN_PLACE", &"BER2_INTROSCREEN_DATE", &"BER2_INTROSCREEN_INFO" );
			break;

		case "ber3":
			PrecacheString( &"BER3_INTROSCREEN_TITLE" );
			PrecacheString( &"bER3_INTROSCREEN_PLACE" );
			PrecacheString( &"BER3_INTROSCREEN_DATE" );
			PrecacheString( &"BER3_INTROSCREEN_INFO" );
			introscreen_delay( &"BER3_INTROSCREEN_TITLE", &"BER3_INTROSCREEN_PLACE", &"BER3_INTROSCREEN_DATE", &"BER3_INTROSCREEN_INFO" );
			break;
//-------------//
// Test Levels //
//-------------//

		// SCRIPTER_MOD
		// MikeD( 3/16/200 ): Testing introscreen
		case "coop_test1":
			PrecacheString( "Co-Op Test 1" ); 
			PrecacheString( "" ); 
			PrecacheString( "" ); 
			PrecacheString( "" ); 
			introscreen_delay( "Co-Op Test 1", "", "", "" ); 
			break; 
		case "guzzo_test_new":
			//introscreen_delay( "testing...", "introscreen...", "extra" ); 
			break;
		default:
			// Shouldn't do a notify without a wait( statement before it, or bad things can happen when loading a save game.
			wait( 0.05 ); 
			level notify( "finished final intro screen fadein" ); 
			wait( 0.05 ); 
			level notify( "starting final intro screen fadeout" ); 
			wait( 0.05 ); 
			level notify( "controls_active" ); // Notify when player controls have been restored
			wait( 0.05 ); 
			flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
			break; 
	}
}

// creates a hud-element for the specified string and sets its initial values
introscreen_create_line( string )
{
	index = level.introstring.size; 
	yPos = ( index * 30 ); 
	
	if( level.xenon )
	{
		yPos -= 60; 
	}
	
	level.introstring[index] = NewHudElem(); 
	level.introstring[index].x = 0; 
	level.introstring[index].y = yPos; 
	level.introstring[index].alignX = "center"; 
	level.introstring[index].alignY = "middle"; 
	level.introstring[index].horzAlign = "center"; 
	level.introstring[index].vertAlign = "middle"; 
	level.introstring[index].sort = 1; // force to draw after the background
	level.introstring[index].foreground = true; 
	level.introstring[index].fontScale = 1.75; 
	level.introstring[index] SetText( string ); 
	level.introstring[index].alpha = 0; 
	level.introstring[index] FadeOverTime( 1.2 ); 
	level.introstring[index].alpha = 1; 
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

introscreen_delay( string1, string2, string3, string4, pausetime1, pausetime2, timebeforefade )
{
	/#
	//Chaotically wait( until the frame ends twice because handle_starts waits for one frame end so that script gets to init vars
	//and this needs to wait for handle_starts to finish so that the level.start_point gets set.
	waittillframeend; 
	waittillframeend; 
	
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
		
	if( skipIntro )
	{
		waittillframeend; 
		level notify( "finished final intro screen fadein" ); 
		waittillframeend; 
		level notify( "starting final intro screen fadeout" ); 
		waittillframeend; 
		level notify( "controls_active" ); // Notify when player controls have been restored
		waittillframeend; 
		flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" ); 
		return; 
	}
	#/

	
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
	
	wait( 0.05 ); 
 
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
	}
	
	if( IsDefined( string4 ) )
	{
		introscreen_create_line( string4 ); 
	}
	
	level notify( "finished final intro screen fadein" ); 
	
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

	level notify( "starting final intro screen fadeout" ); 
	
	// Restore player controls part way through the fade in
	freezecontrols_all( false ); 
	level notify( "controls_active" ); // Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
}

