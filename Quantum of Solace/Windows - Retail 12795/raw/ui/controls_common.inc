// control settings

#ifndef PC //SDOMPIERRE
#define LOCALIZATION_FILE	"@MENU"

#ifdef SINGLE_PLAYER
#undef	LOCALIZATION_FILE
#define LOCALIZATION_FILE	"@MENU"
#endif

#undef CONTROL_MENU_NAME
#define CONTROL_MENU_NAME "controls"

#undef CONTROL_THUMBSTICK_NAME
#define CONTROL_THUMBSTICK_NAME "thumbstick"

#undef CONTROL_BUTTONS_NAME
#define CONTROL_BUTTONS_NAME "buttons"

#undef CONTROL_SENSITIVITY_NAME
#define CONTROL_SENSITIVITY_NAME "sensitivity"

#undef COVER_CONTROL_SENSITIVITY_NAME
#define COVER_CONTROL_SENSITIVITY_NAME "cover_sensitivity"

#undef CONTROL_SENSITIVITY_CUSTOM_NAME
#define CONTROL_SENSITIVITY_CUSTOM_NAME "sensitivity_custom"

#undef CONTROL_BRIGHTNESS_NAME
#define CONTROL_BRIGHTNESS_NAME "brightness"

#undef OPTIONS_NAME
#define OPTIONS_NAME "ingame"

#define BG_SHADE_COLOR	0 0 0 0.75

#ifdef	CONTROL_IN_GAME
	#undef CONTROL_MENU_NAME
	#define CONTROL_MENU_NAME "ingame_controls"
	
	#undef CONTROL_THUMBSTICK_NAME
	#define CONTROL_THUMBSTICK_NAME "ingamecontrols_thumbstick"
	
	#undef CONTROL_BUTTONS_NAME
	#define CONTROL_BUTTONS_NAME "ingamecontrols_buttons"
	
	#undef CONTROL_SENSITIVITY_NAME
	#define CONTROL_SENSITIVITY_NAME "ingamecontrols_sensitivity"
	
	#undef COVER_CONTROL_SENSITIVITY_NAME
	#define COVER_CONTROL_SENSITIVITY_NAME "ingamecontrolls_cover_sensitivity"

	#undef CONTROL_SENSITIVITY_CUSTOM_NAME
	#define CONTROL_SENSITIVITY_CUSTOM_NAME "ingamecontrols_sensitivity_custom"

	#undef CONTROL_BRIGHTNESS_NAME
	#define CONTROL_BRIGHTNESS_NAME "ingamecontrols_brightness"
	
	#undef BG_SHADE_COLOR
	#define BG_SHADE_COLOR	0 0 0 0.75
#endif

#ifdef	CONTROL_IN_GAME_SPLITSCREEN
	#undef CONTROL_MENU_NAME
	#define CONTROL_MENU_NAME "ingame_controls_splitscreen"
	
	#undef CONTROL_THUMBSTICK_NAME
	#define CONTROL_THUMBSTICK_NAME "ingamecontrols_thumbstick_splitscreen"
	
	#undef CONTROL_BUTTONS_NAME
	#define CONTROL_BUTTONS_NAME "ingamecontrols_buttons_splitscreen"
	
	#undef CONTROL_SENSITIVITY_NAME
	#define CONTROL_SENSITIVITY_NAME "ingamecontrols_sensitivity_splitscreen"

	#undef CONTROL_SENSITIVITY_CUSTOM_NAME
	#define CONTROL_SENSITIVITY_CUSTOM_NAME "ingamecontrols_sensitivity_splitscreen_custom"
	
	#undef CONTROL_BRIGHTNESS_NAME
	#define CONTROL_BRIGHTNESS_NAME "ingamecontrols_brightness_splitscreen"

	#undef BG_SHADE_COLOR
	#define BG_SHADE_COLOR	0 0 0 0.85
#endif

#ifdef PS3
	// ps3 voice volume control ==================
	#define LOCAL_VOICE_METER_RAW( dvar1, dvar2 )\
			execOnDvarFloatValue ps3_voiceSpeakerGain dvar1 "set ps3_voiceSpeakerGain "dvar2;
			
	#define LOCAL_VOICE_METER_1 \
			LOCAL_VOICE_METER_RAW( 1.2, "1.5" )\
			LOCAL_VOICE_METER_RAW( 1.5, "2.0" )\
			LOCAL_VOICE_METER_RAW( 2.0, "2.5" )\
			LOCAL_VOICE_METER_RAW( 2.5, "3.0" )\
			LOCAL_VOICE_METER_RAW( 3.0, "3.5" )\
			LOCAL_VOICE_METER_RAW( 3.5, "4.0" )\
			LOCAL_VOICE_METER_RAW( 4.0, "4.5" )\
			LOCAL_VOICE_METER_RAW( 4.5, "5.0" )\
			LOCAL_VOICE_METER_RAW( 5.0, "6.0" )\
			LOCAL_VOICE_METER_RAW( 6.0, "7.0" )\
			LOCAL_VOICE_METER_RAW( 7.0, "8.0" )\
			LOCAL_VOICE_METER_RAW( 8.0, "9.0" )\
			LOCAL_VOICE_METER_RAW( 9.0, "10.0")
			
	#define LOCAL_VOICE_METER_2 \
			LOCAL_VOICE_METER_RAW( 10.0, "9.0")\
			LOCAL_VOICE_METER_RAW( 9.0, "8.0" )\
			LOCAL_VOICE_METER_RAW( 8.0, "7.0" )\
			LOCAL_VOICE_METER_RAW( 7.0, "6.0" )\
			LOCAL_VOICE_METER_RAW( 6.0, "5.0" )\
			LOCAL_VOICE_METER_RAW( 5.0, "4.5" )\
			LOCAL_VOICE_METER_RAW( 4.5, "4.0" )\
			LOCAL_VOICE_METER_RAW( 4.0, "3.5" )\
			LOCAL_VOICE_METER_RAW( 3.5, "3.0" )\
			LOCAL_VOICE_METER_RAW( 3.0, "2.5" )\
			LOCAL_VOICE_METER_RAW( 2.5, "2.0" )\
			LOCAL_VOICE_METER_RAW( 2.0, "1.5" )\
			LOCAL_VOICE_METER_RAW( 1.5, "1.2" )
			
	#define LOCAL_VOICE_EXTRA \
		execKeyInt DPAD_RIGHT { LOCAL_VOICE_METER_1 }\
		execKeyInt APAD_RIGHT { LOCAL_VOICE_METER_1 }\
		execKeyInt DPAD_LEFT { LOCAL_VOICE_METER_2 }\
		execKeyInt APAD_LEFT { LOCAL_VOICE_METER_2 }
#endif


menuDef
{
	name			CONTROL_MENU_NAME

#ifndef CONTROL_IN_GAME
	fullScreen		1
	rect			0 0 640 480
	focusColor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	onOpen	{ ; /*exec "select_save_device";*/ }
	onClose { ; }
	onESC	{/*exec "splitscreencontrols";*/	close CONTROL_MENU_NAME; exec "updategamerprofile" open OPTIONS_NAME;}
#endif

#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		7.0
	legacySplitScreenScale
	onOpen 	{setdvar cg_drawhud "0";setDvar ui_allow_controlschange "0";}
	onclose	{setdvar cg_drawhud "1";setDvar ui_allow_controlschange "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onEsc 	{setdvar cg_drawhud "1"; close CONTROL_MENU_NAME; exec "updategamerprofile"; open OPTIONS_NAME;
#endif
	
#ifdef SINGLE_PLAYER
	#ifdef CONTROL_IN_GAME
		close self; open "pausedmenu";
	#endif
#endif

	}
	
#ifdef	CONTROL_IN_GAME	
	#include "ui/bg.inc"
#else
	#include "ui/bg.inc"
#endif

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_CONTROLS" )
	#else
		CHOICE_MENU_TITLE( "@MENU_CONTROLS" )
	#endif
	// ------------------ buttons ---------------------

// MENU CHOICES
	CHOICE_BUTTON( 1, LOCALIZATION_FILE"_BUTTON_LAYOUT", close CONTROL_MENU_NAME; open CONTROL_BUTTONS_NAME; )	
	CHOICE_BUTTON( 2, LOCALIZATION_FILE"_THUMBSTICK_LAYOUT", close CONTROL_MENU_NAME; open CONTROL_THUMBSTICK_NAME; )
	CHOICE_BUTTON( 3, LOCALIZATION_FILE"_LOOK_SENSITIVITY", close CONTROL_MENU_NAME; open CONTROL_SENSITIVITY_NAME; )
	CHOICE_BUTTON( 4, LOCALIZATION_FILE"_COVER_SENSITIVITY", close CONTROL_MENU_NAME; open COVER_CONTROL_SENSITIVITY_NAME; )
	CHOICE_BUTTON( 5, LOCALIZATION_FILE"_LOOK_INVERSION", exec "toggle input_invertpitch"; )
	
	CHOICE_LEFTITEM_VIS( 1, "@MENU_DEFAULT", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_default_mp" || dvarString( "gpad_buttonsConfig" ) == "buttons_default" ) )
	CHOICE_LEFTITEM_VIS( 1, "@MENU_ALTERNATIVE", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_alternative_mp" || dvarString( "gpad_buttonsConfig" ) == "buttons_alternative" ) )
	CHOICE_LEFTITEM_VIS( 1, "@MENU_ALTERNATIVE2", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_alternative2_mp" || dvarString( "gpad_buttonsConfig" ) == "buttons_alternative2" ) )

	CHOICE_LEFTITEM_VIS( 2, "@MENU_DEFAULT", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_default" ) )
	CHOICE_LEFTITEM_VIS( 2, "@MENU_LEGACY", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_legacy" ) )
	CHOICE_LEFTITEM_VIS( 2, "@MENU_LEGACY_SOUTHPAW", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_legacysouthpaw" ) )
	CHOICE_LEFTITEM_VIS( 2, "@MENU_SOUTHPAW", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_southpaw" ) )

	#define SENSITIVITY_1	0.4
	#define SENSITIVITY_2	0.6
	#define SENSITIVITY_3	0.8
	#define SENSITIVITY_4	1
	#define SENSITIVITY_5	1.2
	#define SENSITIVITY_1_S	"0.4"
	#define SENSITIVITY_2_S	"0.6"
	#define SENSITIVITY_3_S	"0.8"
	#define SENSITIVITY_4_S	"1"
	#define SENSITIVITY_5_S	"1.2"

	CHOICE_LEFTITEM_VIS( 3, "@MENU_SLOW", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) <= SENSITIVITY_1 ) )
	CHOICE_LEFTITEM_VIS( 3, "@MENU_MEDIUM_SLOW", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) > SENSITIVITY_1 && dvarFloat( "input_viewSensitivity" ) <= SENSITIVITY_2 ) )
	CHOICE_LEFTITEM_VIS( 3, "@MENU_MEDIUM", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) > SENSITIVITY_2 && dvarFloat( "input_viewSensitivity" ) <= SENSITIVITY_3 ) )
	CHOICE_LEFTITEM_VIS( 3, "@MENU_MEDIUM_FAST", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) > SENSITIVITY_3 && dvarFloat( "input_viewSensitivity" ) <= SENSITIVITY_4 ) )
	CHOICE_LEFTITEM_VIS( 3, "@MENU_FAST", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) > SENSITIVITY_4 ) )
	
	CHOICE_LEFTITEM_VIS( 4, "@MENU_SLOW", CHOICE_TEXTCOLOR, when( dvarFloat( "input_coverViewSensitivity" ) <= SENSITIVITY_1 ) )
	CHOICE_LEFTITEM_VIS( 4, "@MENU_MEDIUM_SLOW", CHOICE_TEXTCOLOR, when( dvarFloat( "input_coverViewSensitivity" ) > SENSITIVITY_1 && dvarFloat( "input_coverViewSensitivity" ) <= SENSITIVITY_2 ) )
	CHOICE_LEFTITEM_VIS( 4, "@MENU_MEDIUM", CHOICE_TEXTCOLOR, when( dvarFloat( "input_coverViewSensitivity" ) > SENSITIVITY_2 && dvarFloat( "input_coverViewSensitivity" ) <= SENSITIVITY_3 ) )
	CHOICE_LEFTITEM_VIS( 4, "@MENU_MEDIUM_FAST", CHOICE_TEXTCOLOR, when( dvarFloat( "input_coverViewSensitivity" ) > SENSITIVITY_3 && dvarFloat( "input_coverViewSensitivity" ) <= SENSITIVITY_4 ) )
	CHOICE_LEFTITEM_VIS( 4, "@MENU_FAST", CHOICE_TEXTCOLOR, when( dvarFloat( "input_coverViewSensitivity" ) > SENSITIVITY_4 ) )

	CHOICE_LEFTITEM_VIS( 5, "@MENU_DISABLED", CHOICE_TEXTCOLOR, when( dvarString( "input_invertpitch" ) == "0" ) )
	CHOICE_LEFTITEM_VIS( 5, "@MENU_ENABLED", CHOICE_TEXTCOLOR, when( dvarString( "input_invertpitch" ) == "1" ) )

	CHOICE_BUTTON( 6, LOCALIZATION_FILE"_CONTROLLER_VIBRATION", exec "toggle gpad_rumble"; )			
	CHOICE_LEFTITEM_VIS( 6, "@MENU_DISABLED", CHOICE_TEXTCOLOR, when( dvarString( "gpad_rumble" ) == "0" ) )
	CHOICE_LEFTITEM_VIS( 6, "@MENU_ENABLED", CHOICE_TEXTCOLOR, when( dvarString( "gpad_rumble" ) == "1" ) )
	
/*#ifndef SINGLE_PLAYER
		#undef A_BUTTON_OFFSET_X
		#define A_BUTTON_OFFSET_X 100000
		CHOICE_DVARSLIDER_VIS_EX( 7, "@MENU_VOICE_VOLUME", ps3_voiceSpeakerGain, 2.5, 1.0, 10.0, ;, LOCAL_VOICE_EXTRA, 1 )
#endif*/

#undef A_BUTTON_OFFSET_X
#define A_BUTTON_OFFSET_X 100000

#undef A_BUTTON_OFFSET_X
#define A_BUTTON_OFFSET_X (0-4)

#if 0
#ifndef CONTROL_IN_GAME_SPLITSCREEN
	#ifndef SINGLE_PLAYER
		#ifdef PS3
			#ifdef CONTROL_IN_GAME
				CHOICE_BUTTON( 8, "@MENU_BRIGHTNESS", close CONTROL_MENU_NAME; open CONTROL_BRIGHTNESS_NAME; )
			#endif
		#else
			#ifdef CONTROL_IN_GAME
				CHOICE_BUTTON( 8, "@MENU_BRIGHTNESS", close CONTROL_MENU_NAME; open CONTROL_BRIGHTNESS_NAME; )
			#else
				CHOICE_BUTTON_VIS( 8, "@MENU_BRIGHTNESS", close CONTROL_MENU_NAME; open CONTROL_BRIGHTNESS_NAME;, when( dvarBool( hiDef) ) )
			#endif
		#endif
	#endif
#endif
#endif
	
	#include "ui/safearea.menu"
}

// LOOK SENSITIVITY MENU
menuDef 
{
	name			CONTROL_SENSITIVITY_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onclose	{setdvar cg_drawhud "1";setDvar ui_allow_controlschange "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{setfocusbydvar "input_viewSensitivity";setdvar cg_drawhud "0";setDvar ui_allow_controlschange "0";}
	onEsc {	close CONTROL_SENSITIVITY_NAME;	open CONTROL_MENU_NAME;}
	#include "ui/bg.inc"
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onOpen 	{setfocusbydvar "input_viewSensitivity";}
	onClose	{;}
	onEsc {	close CONTROL_SENSITIVITY_NAME;	open CONTROL_MENU_NAME;}
	#include "ui/bg.inc"
#endif
	
	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_LOOK_SENSITIVITY" )
	#else
		CHOICE_MENU_TITLE( "@MENU_LOOK_SENSITIVITY" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC

	#define SETUP_ACTION3( pconfig ) \
		exec pconfig \
		close CONTROL_SENSITIVITY_NAME; \
		open CONTROL_MENU_NAME;

	#define SETUP_EXTRA( pnum ) \
		dvartest "input_viewSensitivity" focusdvar { pnum }

	CHOICE_BUTTON_FOCUS_VIS_EX( 1, "@MENU_SLOW", SETUP_ACTION3( "set input_viewSensitivity "SENSITIVITY_1_S ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_1_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 2, "@MENU_MEDIUM_SLOW", SETUP_ACTION3( "set input_viewSensitivity "SENSITIVITY_2_S ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_2_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 3, "@MENU_MEDIUM", SETUP_ACTION3( "set input_viewSensitivity "SENSITIVITY_3_S ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_3_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 4, "@MENU_MEDIUM_FAST", SETUP_ACTION3( "set input_viewSensitivity "SENSITIVITY_4_S ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_4_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 5, "@MENU_FAST", SETUP_ACTION3( "set input_viewSensitivity "SENSITIVITY_5_S ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_5_S ) )

	#include "ui/safearea.menu"
}

// COVER LOOK SENSITIVITY MENU
menuDef 
{
	name			COVER_CONTROL_SENSITIVITY_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onclose	{setdvar cg_drawhud "1";setDvar ui_allow_controlschange "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{setfocusbydvar "input_coverViewSensitivity";setdvar cg_drawhud "0";setDvar ui_allow_controlschange "0";}
	onEsc {	close COVER_CONTROL_SENSITIVITY_NAME;	open CONTROL_MENU_NAME;}
	#include "ui/bg.inc"
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onOpen 	{setfocusbydvar "input_coverViewSensitivity";}
	onClose	{;}
	onEsc {	close COVER_CONTROL_SENSITIVITY_NAME;	open CONTROL_MENU_NAME;}
	#include "ui/bg.inc"
#endif
	
	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_COVER_SENSITIVITY" )
	#else
		CHOICE_MENU_TITLE( "@MENU_COVER_SENSITIVITY" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC

	#define SETUP_COVER_ACTION( pconfig ) \
		exec pconfig \
		close COVER_CONTROL_SENSITIVITY_NAME; \
		open CONTROL_MENU_NAME;

	#define SETUP_COVER_EXTRA( pnum ) \
		dvartest "input_coverViewSensitivity" focusdvar { pnum }

	CHOICE_BUTTON_FOCUS_VIS_EX( 1, "@MENU_SLOW", SETUP_COVER_ACTION( "set input_coverViewSensitivity "SENSITIVITY_1_S ), ;, ;, when( 1 ), SETUP_COVER_EXTRA( SENSITIVITY_1_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 2, "@MENU_MEDIUM_SLOW", SETUP_COVER_ACTION( "set input_coverViewSensitivity "SENSITIVITY_2_S ), ;, ;, when( 1 ), SETUP_COVER_EXTRA( SENSITIVITY_2_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 3, "@MENU_MEDIUM", SETUP_COVER_ACTION( "set input_coverViewSensitivity "SENSITIVITY_3_S ), ;, ;, when( 1 ), SETUP_COVER_EXTRA( SENSITIVITY_3_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 4, "@MENU_MEDIUM_FAST", SETUP_COVER_ACTION( "set input_coverViewSensitivity "SENSITIVITY_4_S ), ;, ;, when( 1 ), SETUP_COVER_EXTRA( SENSITIVITY_4_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 5, "@MENU_FAST", SETUP_COVER_ACTION( "set input_coverViewSensitivity "SENSITIVITY_5_S ), ;, ;, when( 1 ), SETUP_COVER_EXTRA( SENSITIVITY_5_S ) )

	#include "ui/safearea.menu"
}

#ifdef CONTROL_IN_GAME

#undef CHOICE_Y_START
#define CHOICE_Y_START			78

#endif

// THUMBSTICK LAYOUT MENU
menuDef 
{
	name			CONTROL_THUMBSTICK_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onOpen 	{setdvar cg_drawhud "0";setDvar ui_allow_controlschange "0";}
	onclose	{setdvar cg_drawhud "1";setDvar ui_allow_controlschange "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onEsc 			{ close CONTROL_THUMBSTICK_NAME; open CONTROL_MENU_NAME; }
	#define BG_NO_TEAM_BAR
	#include "ui/bg.inc"
	#undef BG_NO_TEAM_BAR
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onClose			{ ; }
	onEsc 			{ close CONTROL_THUMBSTICK_NAME; open CONTROL_MENU_NAME; }
	#include 		"ui/bg.inc"
#endif

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_THUMBSTICK_LAYOUT" )
	#else
		CHOICE_MENU_TITLE( "@MENU_THUMBSTICK_LAYOUT" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC
	
	#define SETUP_ACTION( pconfig ) \
		setDvar gpad_sticksConfig pconfig \
		close CONTROL_THUMBSTICK_NAME; \
		open CONTROL_MENU_NAME;

#ifndef	CONTROL_IN_GAME_SPLITSCREEN

	#include "ui_mp/controls_thumbstick_set.menu"
	
	#define SETUP_FOCUS( pnum ) \
		show "controls_thumbstick_set"pnum;
	
	#define SETUP_UNFOCUS( pnum ) \
		hide "controls_thumbstick_set"pnum;
#else
	#define SETUP_FOCUS( pnum ) ;
	#define SETUP_UNFOCUS( pnum ) ;
#endif
	
	CHOICE_BUTTON_FOCUS( 1, "@MENU_DEFAULT", SETUP_ACTION( "thumbstick_default" ), SETUP_FOCUS( "1" ), SETUP_UNFOCUS( "1" ) )
	CHOICE_BUTTON_FOCUS( 2, "@MENU_LEGACY", SETUP_ACTION( "thumbstick_legacy" ), SETUP_FOCUS( "2" ), SETUP_UNFOCUS( "2" ) )
	CHOICE_BUTTON_FOCUS( 3, "@MENU_LEGACY_SOUTHPAW", SETUP_ACTION( "thumbstick_legacysouthpaw" ), SETUP_FOCUS( "3" ), SETUP_UNFOCUS( "3" ) )
	CHOICE_BUTTON_FOCUS( 4, "@MENU_SOUTHPAW", SETUP_ACTION( "thumbstick_southpaw" ), SETUP_FOCUS( "4" ), SETUP_UNFOCUS( "4" ) )

	#include "ui/safearea.menu"
}

// BUTTON LAYOUT MENU
menuDef 
{
	name			CONTROL_BUTTONS_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onOpen 	{setdvar cg_drawhud "0";setDvar ui_allow_controlschange "0";}
	onclose	{setdvar cg_drawhud "1";setDvar ui_allow_controlschange "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onEsc 	{close CONTROL_BUTTONS_NAME;open CONTROL_MENU_NAME;}
	#define BG_NO_TEAM_BAR
	#include "ui/bg.inc"
	#undef BG_NO_TEAM_BAR
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onClose	{;}
	onEsc 	{close CONTROL_BUTTONS_NAME;open CONTROL_MENU_NAME;}
	#include "ui/bg.inc"
#endif

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_BUTTON_LAYOUT" )
	#else
		CHOICE_MENU_TITLE( "@MENU_BUTTON_LAYOUT" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC
	
	#define SETUP_ACTION2( pconfig ) \
		setDvar gpad_buttonsConfig pconfig \
		close CONTROL_BUTTONS_NAME; \
		open CONTROL_MENU_NAME;
		
#ifndef	CONTROL_IN_GAME_SPLITSCREEN

	#include "ui_mp/controls_buttons_set.menu"

	#define SETUP_FOCUS2( pnum ) \
		show "controls_buttons_set"pnum;
	
	#define SETUP_UNFOCUS2( pnum ) \
		hide "controls_buttons_set"pnum;
#else
	#define SETUP_FOCUS2( pnum ) ;
	#define SETUP_UNFOCUS2( pnum ) ;
#endif

	CHOICE_BUTTON_FOCUS( 1, "@MENU_DEFAULT", SETUP_ACTION2( "buttons_default" ), SETUP_FOCUS2( "1" ), SETUP_UNFOCUS2( "1" ) )
	CHOICE_BUTTON_FOCUS( 2, "@MENU_ALTERNATIVE", SETUP_ACTION2( "buttons_alternative" ), SETUP_FOCUS2( "2" ), SETUP_UNFOCUS2( "2" ) )
	CHOICE_BUTTON_FOCUS( 3, "@MENU_ALTERNATIVE2", SETUP_ACTION2( "buttons_alternative2" ), SETUP_FOCUS2( "3" ), SETUP_UNFOCUS2( "3" ) )

	#include "ui/safearea.menu"
}
#else //#ifndef PC

//set these buttons smaller
#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X 				155

#undef CHOICE_TEXTSIZE
#define CHOICE_TEXTSIZE				0.3

#undef OPTIONS_NAME
#define OPTIONS_NAME "ingame"

#undef CONTROL_MENU_NAME
#define CONTROL_MENU_NAME "ingame_controls"
	
#undef CONTROL_LOOK_NAME
#define CONTROL_LOOK_NAME "ingamecontrols_look"
	
#undef CONTROL_MOVE_NAME
#define CONTROL_MOVE_NAME "ingamecontrols_move"
	
#undef CONTROL_COMBAT_NAME
#define CONTROL_SENSITIVITY_NAME "ingamecontrols_combat"

#undef CONTROL_WEAPON_NAME
#define CONTROL_WEAPON_NAME "ingamecontrols_weapon"

#undef CONTROL_INTERACT_NAME
#define CONTROL_INTERACT_NAME "ingamecontrols_interact"

#undef CONTROL_MULTIPLAYER_NAME
#define CONTROL_MULTIPLAYER_NAME "ingamecontrols_multiplayer"
	
#undef CONTROL_DEFAULT_NAME
#define CONTROL_DEFAULT_NAME "ingamecontrols_default"
	
#undef BG_SHADE_COLOR
#define BG_SHADE_COLOR	0 0 0 0.75


//Controls menu definition
menuDef
{
	name			CONTROL_MENU_NAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		7.0
	onOpen 	{setdvar cg_drawhud "0";setDvar ui_allow_controlschange "0";}
	onclose	{setdvar cg_drawhud "1";setDvar ui_allow_controlschange "1"; close CONTROL_MOVE_NAME; close CONTROL_COMBAT_NAME; close CONTROL_WEAPON_NAME; close CONTROL_INTERACT_NAME; close CONTROL_DEFAULT_NAME; close CONTROL_LOOK_NAME; close CONTROL_MULTIPLAYER_NAME; open OPTIONS_NAME; exec "updategamerprofile";}
	//execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onEsc 	{setdvar cg_drawhud "1"close CONTROL_MENU_NAME; }
	
	#include "ui/bg.inc"
	
	CHOICE_MENU_TITLE( "@MENU_CONTROLS" )
	
	CHOICE_BUTTON( 1, "@MENU_LOOK", open CONTROL_LOOK_NAME; )	
	CHOICE_BUTTON( 2,"@MENU_MOVE", open CONTROL_MOVE_NAME; )
	CHOICE_BUTTON( 3, "@MENU_COMBAT", open CONTROL_COMBAT_NAME; )
	CHOICE_BUTTON( 4, "@MENU_WEAPON", open CONTROL_WEAPON_NAME; )
	CHOICE_BUTTON( 5, "@MENU_INTERACT", open CONTROL_INTERACT_NAME; )
	CHOICE_BUTTON( 6, "@MENU_MULTIPLAYER", open CONTROL_MULTIPLAYER_NAME; )
	CHOICE_BUTTON( 7, "@MENU_RESET_TO_DEFAULTS", close CONTROL_LOOK_NAME; close CONTROL_MOVE_NAME; close CONTROL_COMBAT_NAME; close CONTROL_WEAPON_NAME; close CONTROL_INTERACT_NAME; close CONTROL_MULTIPLAYER_NAME; open CONTROL_DEFAULT_NAME; )
}

//set the size to their original value
#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X 			220

#undef CHOICE_X_START
#define CHOICE_X_START			0

// LOOK Menu
menuDef
{
	name			CONTROL_LOOK_NAME
	rect			207 0 433 410
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{close CONTROL_MOVE_NAME; close CONTROL_COMBAT_NAME; close CONTROL_WEAPON_NAME; close CONTROL_INTERACT_NAME; close CONTROL_DEFAULT_NAME; close CONTROL_MULTIPLAYER_NAME;}
	onEsc 	{close self;}
	
	CHOICE_BIND( 1, "@MENU_LOOK_UP", "+lookup", ; )
	CHOICE_BIND( 2, "@MENU_LOOK_DOWN", "+lookdown", ; )
	CHOICE_BIND( 3, "@MENU_TURN_LEFT", "+left", ; )
	CHOICE_BIND( 4, "@MENU_TURN_RIGHT", "+right", ; )

	//CHOICE_KEYBINDHELP
}

// MOVE Menu
menuDef
{
	name			CONTROL_MOVE_NAME
	rect			207 0 433 410
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{close CONTROL_LOOK_NAME; close CONTROL_COMBAT_NAME; close CONTROL_WEAPON_NAME; close CONTROL_INTERACT_NAME; close CONTROL_DEFAULT_NAME; close CONTROL_MULTIPLAYER_NAME;}
	onEsc 	{close self;}
	
	CHOICE_BIND( 1, "@MENU_FORWARD", "+forward", ; )
	CHOICE_BIND( 2, "@MENU_BACKPEDAL", "+back", ; )
	CHOICE_BIND( 3, "@MENU_MOVE_LEFT", "+moveleft", ; )
	CHOICE_BIND( 4, "@MENU_MOVE_RIGHT", "+moveright", ; )
	CHOICE_BIND( 5, "@MENU_STANDJUMP", "+gostand2", ; )
	CHOICE_BIND( 6, "@MENU_JUMPCOVER", "+gostand", ; )
	CHOICE_BIND( 7, "@MENU_CHANGESTANCE", "+stance", ; )
	CHOICE_BIND( 8, "@MENU_TOGGLE_WALK", "togglewalk", ; )
	CHOICE_BIND( 9, "@MENU_WALK", "+walk", ; )
	CHOICE_BIND( 10, "@MENU_BIND_BREATH_SPRINT", "+dash", ; )

	//CHOICE_KEYBINDHELP
}

// COMBAT Menu
menuDef
{
	name			CONTROL_COMBAT_NAME
	rect			207 0 433 410
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{close CONTROL_LOOK_NAME; close CONTROL_MOVE_NAME; close CONTROL_WEAPON_NAME; close CONTROL_INTERACT_NAME; close CONTROL_DEFAULT_NAME; close CONTROL_MULTIPLAYER_NAME;}
	onEsc 	{close self;}
	
	CHOICE_BIND( 1, "@MENU_FIRE_WEAPON", "+attack", ; )
	CHOICE_BIND( 2, "@MENU_TOGGLE_AIM_DOWN_THE_SIGHT", "toggleads", ; )
	CHOICE_BIND( 3, "@MENU_AIM_DOWN_THE_SIGHT", "+speed", ; )
	CHOICE_BIND( 4, "@MENU_MELEE_ATTACK", "+melee_qk", ; )
	CHOICE_BIND( 5, "@MENU_RELOAD_WEAPON", "+reload", ; )
	CHOICE_BIND( 6, "@MENU_THROW_GRENADE", "+frag", ; )

	//CHOICE_KEYBINDHELP
}

//WEAPON Menu
menuDef
{
	name			CONTROL_WEAPON_NAME
	rect			207 0 433 410
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{close CONTROL_LOOK_NAME; close CONTROL_MOVE_NAME; close CONTROL_COMBAT_NAME; close CONTROL_INTERACT_NAME; close CONTROL_DEFAULT_NAME; close CONTROL_MULTIPLAYER_NAME;}
	onEsc 	{close self;}

	CHOICE_BIND( 1, "@MENU_SELECT_FIRST_WEAPON", "weapprimary", ; )
	CHOICE_BIND( 2, "@MENU_SELECT_SECOND_WEAPON", "weapsidearm", ; )
	CHOICE_BIND( 3, "@MENU_SWITCH_WEAPON", "weapnext", ; )
	CHOICE_BIND( 4, "@MENU_CHANGE_FIRE_TYPE", "nextfiretype", ; )
	CHOICE_BIND( 5, "@MENU_CHANGE_GRENADE_TYPE", "grenadenext", ; )
	CHOICE_BIND( 6, "@MENU_TOGGLESILENCER", "togglesilencer", ; )

	//CHOICE_KEYBINDHELP
}

//INTERACT Menu
menuDef
{
	name			CONTROL_INTERACT_NAME
	rect			207 0 433 410
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{close CONTROL_LOOK_NAME; close CONTROL_MOVE_NAME; close CONTROL_COMBAT_NAME; close CONTROL_WEAPON_NAME; close CONTROL_DEFAULT_NAME; close CONTROL_MULTIPLAYER_NAME;}
	onEsc 	{close self;}
	
	CHOICE_BIND( 1, "@MENU_COVER", "+cover2", ; )
	CHOICE_BIND( 2, "@MENU_USE", "+use", ; )
	CHOICE_BIND( 3, "@MENU_TOGGLESCORES", "+scores", ; )
	CHOICE_BIND( 4, "@MENU_SCREENSHOT", "TakeScreenshot", ; )

	//CHOICE_KEYBINDHELP
}

//MULTIPLAYER Menu
menuDef
{
	name			CONTROL_MULTIPLAYER_NAME
	rect			207 0 433 410
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{close CONTROL_LOOK_NAME; close CONTROL_MOVE_NAME; close CONTROL_COMBAT_NAME; close CONTROL_WEAPON_NAME; close CONTROL_INTERACT_NAME; close CONTROL_DEFAULT_NAME;}
	onEsc 	{close self;}
	
	CHOICE_BIND( 1, "@MENU_CHAT", "chatmodepublic", ; )
	CHOICE_BIND( 2, "@MENU_TEAMCHAT", "chatmodeteam", ; )

	//CHOICE_KEYBINDHELP
}

//RESET TO DEFAULT Menu
#include "ui_mp/popupstyle.inc"
#include "ui/choices_setup_popmenu.menu"

#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X			220
	
#undef CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN	HORIZONTAL_ALIGN_CENTER
#undef CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN	VERTICAL_ALIGN_CENTER

#undef CHOICE_POPUP_TITLE_HEIGHT
#define CHOICE_POPUP_TITLE_HEIGHT	24

#undef CHOICE_POPUP_SUBTITLE_HEIGHT
#define CHOICE_POPUP_SUBTITLE_HEIGHT 70

menuDef 
{
	CENTER_POPUP_SETUP_ONOPEN( CONTROL_DEFAULT_NAME, 2, ;, setfocus cancel_button, 1 )

	#define RESET_BINDINGS \
		play "mouse_click"; \
		close CONTROL_DEFAULT_NAME; \
		exec "exec buttons_default_mp.cfg"

	CHOICE_POPMENU_TITLE( "@MENU_RESET_TO_DEFAULTS")
	CHOICE_POPMENU_SUBTITLE( "@MENU_RESTORE_DEFAULT_SETTINGS")

	CHOICE_BUTTON( 1, "@MENU_YES", RESET_BINDINGS )
	CHOICE_BUTTON_EX( 2, "@MENU_NO", close self, name cancel_button )
}
#endif