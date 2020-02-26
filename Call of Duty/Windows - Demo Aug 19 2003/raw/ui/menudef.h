
#define ITEM_TYPE_TEXT				0		// simple text
#define ITEM_TYPE_BUTTON			1		// button, basically text with a border 
#define ITEM_TYPE_RADIOBUTTON		2		// toggle button, may be grouped 
#define ITEM_TYPE_CHECKBOX			3		// check box
#define ITEM_TYPE_EDITFIELD 		4		// editable text, associated with a cvar
#define ITEM_TYPE_COMBO 			5		// drop down list
#define ITEM_TYPE_LISTBOX			6		// scrollable list	
#define ITEM_TYPE_MODEL 			7		// model
#define ITEM_TYPE_OWNERDRAW 		8		// owner draw, name specs what it is
#define ITEM_TYPE_NUMERICFIELD		9		// editable text, associated with a cvar
#define ITEM_TYPE_SLIDER			10		// mouse speed, volume, etc.
#define ITEM_TYPE_YESNO 			11		// yes no cvar setting
#define ITEM_TYPE_MULTI 			12		// multiple list setting, enumerated
#define ITEM_TYPE_BIND				13		// multiple list setting, enumerated
#define ITEM_TYPE_MENUMODEL 		14		// special menu model
#define ITEM_TYPE_VALIDFILEFIELD	15		// text must be valid for use in a dos filename
	
#define ITEM_ALIGN_LEFT 			0		// left alignment
#define ITEM_ALIGN_CENTER			1		// center alignment
#define ITEM_ALIGN_RIGHT			2		// right alignment

#define ITEM_TEXTSTYLE_NORMAL			0	// normal text
#define ITEM_TEXTSTYLE_BLINK			1	// fast blinking
#define ITEM_TEXTSTYLE_PULSE			2	// slow pulsing
#define ITEM_TEXTSTYLE_SHADOWED 		3	// drop shadow ( need a color for this )
#define ITEM_TEXTSTYLE_OUTLINED 		4	// drop shadow ( need a color for this )
#define ITEM_TEXTSTYLE_OUTLINESHADOWED	5	// drop shadow ( need a color for this )
#define ITEM_TEXTSTYLE_SHADOWEDMORE 	6	// drop shadow ( need a color for this )
						  
#define WINDOW_BORDER_NONE			0		// no border
#define WINDOW_BORDER_FULL			1		// full border based on border color ( single pixel )
#define WINDOW_BORDER_HORZ			2		// horizontal borders only
#define WINDOW_BORDER_VERT			3		// vertical borders only 
#define WINDOW_BORDER_KCGRADIENT	4		// horizontal border using the gradient bars
  
#define WINDOW_STYLE_EMPTY			0		// no background
#define WINDOW_STYLE_FILLED 		1		// filled with background color
#define WINDOW_STYLE_GRADIENT		2		// gradient bar based on background color 
#define WINDOW_STYLE_SHADER 		3		// shader based on background color 
#define WINDOW_STYLE_TEAMCOLOR		4		// team color
#define WINDOW_STYLE_CINEMATIC		5		// cinematic
#define WINDOW_STYLE_CVAR_SHADER	6		// Get's the shader to draw from the set cvar

#define MENU_TRUE			1		// uh.. true
#define MENU_FALSE			0		// and false

#define HUD_VERTICAL		0x00
#define HUD_HORIZONTAL		0x01

#define RANGETYPE_ABSOLUTE	0
#define RANGETYPE_RELATIVE	1

// list box element types
#define LISTBOX_TEXT		0x00
#define LISTBOX_IMAGE		0x01

// list feeders
#define FEEDER_HEADS				0x00	// model heads
#define FEEDER_CLANS				0x03	// clan names
#define FEEDER_MODS 				0x09	// team members for team voting
#define FEEDER_DEMOS				0x0a	// team members for team voting
#define FEEDER_SCOREBOARD			0x0b	// team members for team voting
#define FEEDER_Q3HEADS				0x0c	// model heads
#define FEEDER_CINEMATICS			0x0f	// cinematics
#define FEEDER_SAVEGAMES			0x10	// savegames
#define FEEDER_PICKSPAWN			0x11	// NERVE - SMF - wolf mp pick spawn point

// display flags
#define CG_SHOW_OBELISK 					0x00000040
#define CG_SHOW_HEALTHCRITICAL				0x00000080
#define CG_SHOW_DURINGINCOMINGVOICE 		0x00000400
#define CG_SHOW_LANPLAYONLY 				0x00001000
#define CG_SHOW_MINED						0x00002000
#define CG_SHOW_HEALTHOK					0x00004000
//(SA)
#define CG_SHOW_TEXTASINT					0x00200000
#define CG_SHOW_HIGHLIGHTED					0x00100000

#define CG_SHOW_NOT_V_CLEAR					0x02000000	//----(SA)	added	// hide on normal, full-view huds

#define CG_SHOW_2DONLY						0x10000000


#define UI_SHOW_LEADER						0x00000001
#define UI_SHOW_NOTLEADER					0x00000002
#define UI_SHOW_FAVORITESERVERS 			0x00000004
#define UI_SHOW_NEWHIGHSCORE				0x00000008
#define UI_SHOW_DEMOAVAILABLE				0x00000010
#define UI_SHOW_NEWBESTTIME 				0x00000020
#define UI_SHOW_NOTFAVORITESERVERS			0x00000040

// font types
#define UI_FONT_DEFAULT			0	// auto-chose betwen big/reg/small
#define UI_FONT_NORMAL			1
#define UI_FONT_BIG				2
#define UI_FONT_SMALL			3
#define UI_FONT_BOLD			4
#define UI_FONT_CONSOLE			5

// owner draw types
// ideally these should be done outside of this file but
// this makes it much easier for the macro expansion to 
// convert them for the designers ( from the .menu files )
#define CG_OWNERDRAW_BASE			1
#define CG_PLAYER_HEAD				3
#define CG_PLAYER_HEALTH			4
#define CG_PLAYER_AMMO_VALUE		5
#define CG_PLAYER_AMMO_BACKDROP		6

#define CG_PLAYER_ITEM				19
#define CG_PLAYER_STANCE			20

#define CG_KILLER					50

// (SA) adding
#define CG_PLAYER_AMMOCLIP_VALUE	70	
#define CG_CURSORHINT				72
#define CG_PLAYER_POWERUP			73
#define CG_PLAYER_HOLDABLE			74
#define CG_PLAYER_INVENTORY			75
#define CG_CURSORHINT_STATUS		78	// like 'health' bar when pointing at a func_explosive

#define CG_PLAYER_WEAPON_NAME		81
#define CG_PLAYER_WEAPON_NAME_BACK	82
#define CG_PLAYER_WEAPON_MODE_ICON	83

#define CG_PLAYER_COMPASS			84
#define CG_PLAYER_COMPASS_BACK		85
#define CG_PLAYER_COMPASS_POINTERS	86
#define CG_PLAYER_COMPASS_HEALTH	87
#define CG_PLAYER_COMPASS_FRIENDS	88
#define CG_PLAYER_COMPASS_TANKS     89

#define CG_TANK_BODY_DIR	90
#define CG_TANK_BARREL_DIR	91

#define UI_OWNERDRAW_BASE			200
#define UI_HANDICAP 				200
#define UI_EFFECTS					201
#define UI_PLAYERMODEL				202
#define UI_MAPPREVIEW				206
#define UI_SKILL					207
#define UI_CROSSHAIR				242
#define UI_MAPCINEMATIC 			244
#define UI_NETMAPCINEMATIC			246
#define UI_GLINFO					249
#define UI_KEYBINDSTATUS			250
#define UI_PREVIEWCINEMATIC 		254
#define UI_STARTMAPCINEMATIC		255

#define UI_MENUMODEL				257
#define	UI_SAVEGAME_SHOT			258

#define UI_LEVELSHOT				260
#define UI_LOADSTATUSBAR			261
#define UI_SAVEGAMENAME				262
#define UI_SAVEGAMEINFO				263

#define WEAPON_NAME_OFS			28 // This defined the amount of space to leave for the weapon mode icon
#define WEAPON_NAME_EDGE_SPACE	8 // space to leave on the left side of the weapon name

// size defines for the hud compass
// These are used for both the dynamic & non-dynamic compass drawing
// If these are changed, the cgame should be recompiled
//#define COMPASS_X     6
//#define COMPASS_Y     367
//#define COMPASS_SIZE  106

//#define COMPASS_HEALTH_OFF   25
//#define COMPASS_HEALTH_SIZE  56

//#define COMPASS_NEEDLE_XOFF     46
//#define COMPASS_NEEDLE_YOFF     29
//#define COMPASS_NEEDLE_WIDTH    14
//#define COMPASS_NEEDLE_HEIGHT   28

//#define COMPASS_POINTER_RADIUS   50
//#define COMPASS_POINTER_WIDTH    8
//#define COMPASS_POINTER_HEIGHT   16

#define COMPASS_X     -25 // -40
#define COMPASS_Y     345 // 552
#define COMPASS_SIZE  160 // 256

#define COMPASS_HEALTH_OFF   54.375 // 87
#define COMPASS_HEALTH_SIZE  51.25 // 82

#define COMPASS_NEEDLE_XOFF     60 // 96
#define COMPASS_NEEDLE_YOFF     50 // 80
#define COMPASS_NEEDLE_WIDTH    40 // 64
#define COMPASS_NEEDLE_HEIGHT   40 // 64

#define COMPASS_POINTER_RADIUS   43.75 // 70
#define COMPASS_POINTER_WIDTH    32 // 20
#define COMPASS_POINTER_HEIGHT   32 // 20

#define COMPASS_FRIENDLY_WIDTH    10 // 16
#define COMPASS_FRIENDLY_HEIGHT   10 // 16

#define COMPASS_TANK_WIDTH    16
#define COMPASS_TANK_HEIGHT   16

#define OPTIONS_CONTROL_SIZE	350 13
//#define OPTIONS_WINDOW	10 75 360 325
#define OPTIONS_WINDOW_POS	5 75
#define	OPTIONS_WINDOW_SIZE	360 325
#define	OPTIONS_WINDOW_BACKCOLOR	0 0 0 .6
#define OPTIONS_CONTROL_XALIGN	165
#define OPTIONS_CONTROL_YALIGN	11
#define OPTIONS_CONTROL_TXTSCALE	.22
#define OPTIONS_CONTROL_BACKCOLOR	0	0	.25	.3
#define OPTIONS_CONTROL_FORECOLOR	.9	.9	.9	1

//menu backgrounds, 1024x768 image split to 1024x512 & 1024x256 images
#define UI_MAIN_BACKGROUND_TOP		main_back_top
#define UI_MAIN_BACKGROUND_BOTTOM	main_back_bottom