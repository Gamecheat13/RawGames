// Update menudefinition.h in the code source if you change this file.

#define ITEM_TYPE_TEXT				0		// simple text
#define ITEM_TYPE_BUTTON			1		// button, basically text with a border
#define ITEM_TYPE_RADIOBUTTON		2		// toggle button, may be grouped
#define ITEM_TYPE_CHECKBOX			3		// check box
#define ITEM_TYPE_EDITFIELD 		4		// editable text, associated with a dvar
#define ITEM_TYPE_COMBO 			5		// drop down list
#define ITEM_TYPE_LISTBOX			6		// scrollable list
#define ITEM_TYPE_MODEL 			7		// model
#define ITEM_TYPE_OWNERDRAW 		8		// owner draw, name specs what it is
#define ITEM_TYPE_NUMERICFIELD		9		// editable text, associated with a dvar
#define ITEM_TYPE_SLIDER			10		// mouse speed, volume, etc.
#define ITEM_TYPE_YESNO 			11		// yes no dvar setting
#define ITEM_TYPE_MULTI 			12		// multiple list setting, enumerated
#define ITEM_TYPE_DVARENUM 			13		// multiple list setting, enumerated from a dvar
#define ITEM_TYPE_BIND				14		// bind
#define ITEM_TYPE_MENUMODEL 		15		// special menu model
#define ITEM_TYPE_VALIDFILEFIELD	16		// text must be valid for use in a dos filename
#define ITEM_TYPE_DECIMALFIELD		17		// editable text, associated with a dvar, which allows decimal input
#define ITEM_TYPE_UPREDITFIELD		18		// editable text, associated with a dvar

#define ITEM_ALIGN_LEFT 			0		// left alignment
#define ITEM_ALIGN_CENTER			1		// center alignment
#define ITEM_ALIGN_RIGHT			2		// right alignment
#define ITEM_ALIGN_CENTER2			3		// center alignment

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

#define WINDOW_STYLE_EMPTY				0	// no background
#define WINDOW_STYLE_FILLED 			1	// filled with background color
#define WINDOW_STYLE_GRADIENT			2	// gradient bar based on background color
#define WINDOW_STYLE_SHADER 			3	// shader based on background color
#define WINDOW_STYLE_TEAMCOLOR			4	// team color
#define WINDOW_STYLE_CINEMATIC			5	// cinematic
#define WINDOW_STYLE_DVAR_SHADER		6	// draws the shader specified by the dvar
#define WINDOW_STYLE_LOADBAR 			7	// shader based on background color

#define MENU_TRUE			1
#define MENU_FALSE			0

#define HUD_VERTICAL			0x00
#define HUD_HORIZONTAL			0x01

#define RANGETYPE_ABSOLUTE		0
#define RANGETYPE_RELATIVE		1

// list box element types
#define LISTBOX_TEXT				0x00
#define LISTBOX_IMAGE				0x01

// list feeders
#define FEEDER_HEADS				0x00	// model heads
#define FEEDER_MAPS 				0x01	// text maps based on game type
#define FEEDER_SERVERS				0x02	// servers
#define FEEDER_CLAN_MEMBERS			0x03	// clan names
#define FEEDER_ALLMAPS				0x04	// all maps available, in graphic format
#define FEEDER_REDTEAM_LIST 		0x05	// red team members
#define FEEDER_BLUETEAM_LIST		0x06	// blue team members
#define FEEDER_PLAYER_LIST			0x07	// players
#define FEEDER_TEAM_LIST			0x08	// team members for team voting
#define FEEDER_MODS 				0x09	// team members for team voting
#define FEEDER_DEMOS				0x0a	// team members for team voting
#define FEEDER_SCOREBOARD			0x0b	// team members for team voting
#define FEEDER_Q3HEADS				0x0c	// model heads
#define FEEDER_SERVERSTATUS 		0x0d	// server status
#define FEEDER_FINDPLAYER			0x0e	// find player
#define FEEDER_CINEMATICS			0x0f	// cinematics
#define FEEDER_SAVEGAMES			0x10	// savegames
#define FEEDER_PICKSPAWN			0x11
#define FEEDER_PARTY_MEMBERS		0x12	// list of players in your party
#define FEEDER_PARTY_MEMBERS_TALK	0x13	// icon for whether they are speaking or not
#define FEEDER_MUTELIST				0x14	// list of musted players
#define FEEDER_PLAYERSTALKING		0x15	// list of players who are currently talking
#define FEEDER_SPLITSCREENPLAYERS	0x16	// list of all players who are playing splitscreen
#define FEEDER_PARTY_MEMBERS_READY	0x17	// icon for whether they are ready or not
#define FEEDER_PLAYER_PROFILES		0x18	// player profiles

// display flags
#define CG_SHOW_BLUE_TEAM_HAS_REDFLAG		0x00000001
#define CG_SHOW_RED_TEAM_HAS_BLUEFLAG		0x00000002
#define CG_SHOW_ANYTEAMGAME					0x00000004
#define CG_SHOW_CTF 						0x00000020
#define CG_SHOW_OBELISK 					0x00000040
#define CG_SHOW_HEALTHCRITICAL				0x00000080
#define CG_SHOW_SINGLEPLAYER				0x00000100
#define CG_SHOW_TOURNAMENT					0x00000200
#define CG_SHOW_DURINGINCOMINGVOICE 		0x00000400
#define CG_SHOW_IF_PLAYER_HAS_FLAG			0x00000800
#define CG_SHOW_LANPLAYONLY 				0x00001000
#define CG_SHOW_MINED						0x00002000
#define CG_SHOW_HEALTHOK					0x00004000
#define CG_SHOW_TEAMINFO					0x00008000
#define CG_SHOW_NOTEAMINFO					0x00010000
#define CG_SHOW_OTHERTEAMHASFLAG			0x00020000
#define CG_SHOW_YOURTEAMHASENEMYFLAG		0x00040000
#define CG_SHOW_ANYNONTEAMGAME				0x00080000
#define CG_SHOW_TEXTASINT					0x00200000
#define CG_SHOW_HIGHLIGHTED					0x00100000

#define CG_SHOW_NOT_V_CLEAR					0x02000000

#define CG_SHOW_2DONLY						0x10000000


#define UI_SHOW_LEADER						0x00000001
#define UI_SHOW_NOTLEADER					0x00000002
#define UI_SHOW_FAVORITESERVERS 			0x00000004
#define UI_SHOW_ANYNONTEAMGAME				0x00000008
#define UI_SHOW_ANYTEAMGAME 				0x00000010
#define UI_SHOW_NEWHIGHSCORE				0x00000020
#define UI_SHOW_DEMOAVAILABLE				0x00000040
#define UI_SHOW_NEWBESTTIME 				0x00000080
#define UI_SHOW_FFA				 			0x00000100
#define UI_SHOW_NOTFFA						0x00000200
#define UI_SHOW_NETANYNONTEAMGAME			0x00000400
#define UI_SHOW_NETANYTEAMGAME				0x00000800
#define UI_SHOW_NOTFAVORITESERVERS			0x00001000

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
#define CG_PLAYER_SCORE 			21

#define CG_BLUE_FLAGSTATUS			22
#define CG_BLUE_FLAGNAME			23
#define CG_RED_FLAGSTATUS			25
#define CG_RED_FLAGNAME 			26

#define CG_BLUE_SCORE				27
#define CG_RED_SCORE				28
#define CG_RED_NAME 				29
#define CG_BLUE_NAME				30
#define CG_PLAYER_LOCATION			33
#define CG_TEAM_COLOR				34
#define CG_CTF_POWERUP				35

#define CG_AREA_POWERUP				36
#define CG_AREA_LAGOMETER			37	// painted with old system
#define CG_PLAYER_HASFLAG			38
#define CG_GAME_TYPE				39	// not done

#define CG_PLAYER_STATUS			42
#define CG_FRAGGED_MSG				43	// painted with old system
#define CG_AREA_FPSINFO 			45	// painted with old system
#define CG_GAME_STATUS				49
#define CG_KILLER					50
#define CG_ACCURACY 				53
#define CG_ASSISTS					54
#define CG_DEFEND					55
#define CG_EXCELLENT				56
#define CG_IMPRESSIVE				57
#define CG_PERFECT					58
#define CG_GAUNTLET					59
#define CG_SPECTATORS				60
#define CG_TEAMINFO 				61
#define CG_VOICE_HEAD				62
#define CG_CAPFRAGLIMIT 			66
#define CG_1STPLACE					67
#define CG_2NDPLACE 				68
#define CG_CAPTURES 				69

#define CG_PLAYER_AMMOCLIP_VALUE	70
#define CG_HOLD_BREATH_HINT			71
#define CG_CURSORHINT				72
#define CG_PLAYER_POWERUP			73
#define CG_PLAYER_HOLDABLE			74
#define CG_PLAYER_INVENTORY			75
#define CG_AREA_WEAPON				76	// draw weapons here
#define CG_AREA_HOLDABLE			77
#define CG_CURSORHINT_STATUS		78	// like 'health' bar when pointing at a func_explosive

#define CG_PLAYER_BAR_HEALTH		79
#define CG_MANTLE_HINT				80

#define CG_PLAYER_WEAPON_NAME		81
#define CG_PLAYER_WEAPON_NAME_BACK	82
#define CG_PLAYER_WEAPON_MODE_ICON	83

#define CG_PLAYER_COMPASS			84
#define CG_PLAYER_COMPASS_BACK		85
#define CG_PLAYER_COMPASS_POINTERS	86
#define CG_PLAYER_COMPASS_ACTORS	87
#define CG_PLAYER_COMPASS_TANKS     88
#define CG_PLAYER_COMPASS_FRIENDS	89

#define CG_TANK_BODY_DIR			90
#define CG_TANK_BARREL_DIR			91

#define CG_DEADQUOTE				92

#define CG_DRAW_SHADER				94
#define CG_PLAYER_BAR_HEALTH_BACK	95

#define CG_MISSION_OBJECTIVE_HEADER		96
#define CG_MISSION_OBJECTIVE_LIST		97
#define CG_MISSION_OBJECTIVE_BACKDROP	98
#define CG_PAUSED_MENU_LINE				99

#define CG_OFFHAND_WEAPON_ICON_FRAG	    100
#define CG_OFFHAND_WEAPON_ICON_SMOKE	101
#define CG_OFFHAND_WEAPON_AMMO_FRAG	    102
#define CG_OFFHAND_WEAPON_AMMO_SMOKE	103
#define CG_OFFHAND_WEAPON_NAME_FRAG	    104
#define CG_OFFHAND_WEAPON_NAME_SMOKE	105
#define CG_OFFHAND_WEAPON_SELECT_FRAG	106
#define CG_OFFHAND_WEAPON_SELECT_SMOKE	107
#define CG_SAVING						108
#define	CG_PLAYER_LOW_HEALTH_OVERLAY	109

#define CG_INVALID_CMD_HINT				110

#define UI_OWNERDRAW_BASE			200
#define UI_HANDICAP 				200
#define UI_EFFECTS					201
#define UI_PLAYERMODEL				202
#define UI_GAMETYPE 				205
#define UI_MAPPREVIEW				206
#define UI_SKILL					207
#define UI_NETSOURCE				220
#define UI_NETMAPPREVIEW			221
#define UI_NETFILTER				222
#define UI_VOTE_KICK				238
#define UI_MAPCINEMATIC 			244
#define UI_NETGAMETYPE				245
#define UI_NETMAPCINEMATIC			246
#define UI_SERVERREFRESHDATE		247
#define UI_SERVERMOTD				248
#define UI_GLINFO					249
#define UI_KEYBINDSTATUS			250
#define UI_JOINGAMETYPE 			253
#define UI_PREVIEWCINEMATIC 		254
#define UI_STARTMAPCINEMATIC		255
#define UI_MENUMODEL				257
#define	UI_SAVEGAME_SHOT			258
#define UI_SAVEGAMENAME				262
#define UI_SAVEGAMEINFO				263
#define UI_LOADPROFILING			264
#define UI_RECORDLEVEL				265
#define UI_AMITALKING				266
#define UI_TALKER1					267
#define UI_TALKER2					268
#define UI_TALKER3					269
#define UI_TALKER4					270
#define UI_PARTYSTATUS				271
#define UI_LOGGEDINUSER				272

// Edge relative placement values for rect->h_align and rect->v_align
#define HORIZONTAL_ALIGN_SUBLEFT		0	// left edge of a 4:3 screen (safe area not included)
#define HORIZONTAL_ALIGN_LEFT			1	// left viewable (safe area) edge
#define HORIZONTAL_ALIGN_CENTER			2	// center of the screen (reticle)
#define HORIZONTAL_ALIGN_RIGHT			3	// right viewable (safe area) edge
#define HORIZONTAL_ALIGN_FULLSCREEN		4	// disregards safe area
#define HORIZONTAL_ALIGN_NOSCALE		5	// uses exact parameters - neither adjusts for safe area nor scales for screen size
#define HORIZONTAL_ALIGN_TO640			6	// scales a real-screen resolution x down into the 0 - 640 range
#define HORIZONTAL_ALIGN_CENTER_SAFEAREA 7	// center of the safearea
#define HORIZONTAL_ALIGN_MAX			HORIZONTAL_ALIGN_CENTER_SAFEAREA
#define HORIZONTAL_ALIGN_DEFAULT		HORIZONTAL_ALIGN_SUBLEFT

#define VERTICAL_ALIGN_SUBTOP			0	// top edge of the 4:3 screen (safe area not included)
#define VERTICAL_ALIGN_TOP				1	// top viewable (safe area) edge
#define VERTICAL_ALIGN_CENTER			2	// center of the screen (reticle)
#define VERTICAL_ALIGN_BOTTOM			3	// bottom viewable (safe area) edge
#define VERTICAL_ALIGN_FULLSCREEN		4	// disregards safe area
#define VERTICAL_ALIGN_NOSCALE			5	// uses exact parameters - neither adjusts for safe area nor scales for screen size
#define VERTICAL_ALIGN_TO480			6	// scales a real-screen resolution y down into the 0 - 480 range
#define VERTICAL_ALIGN_CENTER_SAFEAREA	7	// center of the save area
#define VERTICAL_ALIGN_MAX				VERTICAL_ALIGN_CENTER_SAFEAREA
#define VERTICAL_ALIGN_DEFAULT			VERTICAL_ALIGN_SUBTOP
