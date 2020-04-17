// background_overlay
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			48 36 546 410
	backcolor		0 0 0 0.5
	visible			1
	decoration
}

#ifndef BG_NO_TEAM_BAR
	
// blue_menu_bar
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			48 64 546 54 
	background		"mp_blue_bar_01"
	visible			1
	visible when ( dvarstring( cl_menu_skin ) == "mi6" || dvarstring( cl_menu_skin ) == "bond" );
	decoration
}

// orange_menu_bar
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			48 64 546 54 
	background		"mp_orange_bar_01"
	visible			1
	visible when ( dvarstring( cl_menu_skin ) == "org" );
	decoration
}

// gray_menu_bar
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			48 64 546 54 
	background		"mp_gray_bar_01"
	visible			1
	visible when ( dvarstring( cl_menu_skin ) == "default" );
	decoration
}

#endif // BG_NO_TEAM_BAR

// top_menu_bar
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 36 640 38 HORIZONTAL_ALIGN_FULLSCREEN  VERTICAL_ALIGN_FULLSCREEN
	background		"mp_top_bar_01"
	visible			1
	decoration
}

// bottom_white_line_thick
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			-82 416 854 2 HORIZONTAL_ALIGN_FULLSCREEN  VERTICAL_ALIGN_FULLSCREEN
	backcolor		0.6 0.6 0.6 1.0
	visible			1
	decoration
}

// bottom_white_line_skinny
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			-82 445 854 1 HORIZONTAL_ALIGN_FULLSCREEN  VERTICAL_ALIGN_FULLSCREEN
	backcolor		0.6 0.6 0.6 1.0
	visible			1
	decoration
}

#ifndef BG_NO_TEAM_BAR

// team_icon_MI6
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			54 74 44 44
	background		"hudicon_mi6"
	visible			1
	visible when ( dvarstring( cl_menu_skin ) == "mi6" || dvarstring( cl_menu_skin ) == "bond" );
	decoration
}

// team_icon_ORG
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			54 74 44 44
	background		"hudicon_enemy_a"
	visible			1
	visible when ( dvarstring( cl_menu_skin ) == "org" );
	decoration
}

// Text for the game mode (as, be, vs, etc.)
itemDef
{
	type			ITEM_TYPE_TEXT
	visible			1
	rect			214 118 350 42
	forecolor		1 1 1 0.5
	dvar			"ui_gametype_text"
	textfont		UI_FONT_BOLD
	textscale		TEXTSIZE_TITLE
	textalign		ITEM_ALIGN_BOTTOM
	textalign		ITEM_ALIGN_RIGHT
	decoration
}

itemDef
{
	type			ITEM_TYPE_TEXT
	visible			1
	rect			-50 25 128 24
	origin			158	 92
	forecolor		0.9 0.7 0.3 1.0
	text			"@MPUI_MI6"
	textfont		UI_FONT_NORMAL
	textscale		TEXTSIZE_TITLE
	visible when ( dvarstring( cl_menu_skin ) == "mi6" );
	decoration
}

itemDef
{
	type			ITEM_TYPE_TEXT
	visible			1
	rect			-50 25 128 24
	origin			158	 92
	forecolor		0.9 0.7 0.3 1.0
	text			"@MPUI_ORGANIZATION"
	textfont		UI_FONT_NORMAL
	textscale		TEXTSIZE_TITLE
	visible when ( dvarstring( cl_menu_skin ) == "org" );
	decoration
}

#endif // BG_NO_TEAM_BAR

#include "ui/bars.menu"
#include "ui/navcontrols.menu"