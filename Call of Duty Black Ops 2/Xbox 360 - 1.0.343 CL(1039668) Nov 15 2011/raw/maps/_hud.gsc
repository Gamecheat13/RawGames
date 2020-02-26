/*
static const char *g_he_font[] =
{
	"default",		// HE_FONT_DEFAULT
	"bigfixed",		// HE_FONT_BIGFIXED
	"smallfixed",	// HE_FONT_SMALLFIXED
	"objective",	// HE_FONT_OBJECTIVE
};


// These values correspond to the defines in q_shared.h
static const char *g_he_alignx[] =
{
	"left",   // HE_ALIGN_LEFT
	"center", // HE_ALIGN_CENTER
	"right",  // HE_ALIGN_RIGHT
};


static const char *g_he_aligny[] =
{
	"top",    // HE_ALIGN_TOP
	"middle", // HE_ALIGN_MIDDLE
	"bottom", // HE_ALIGN_BOTTOM
};


// These values correspond to the defines in menudefinition.h
static const char *g_he_horzalign[] =
{
	"subleft",			// HORIZONTAL_ALIGN_SUBLEFT
	"left",				// HORIZONTAL_ALIGN_LEFT
	"center",			// HORIZONTAL_ALIGN_CENTER
	"right",			// HORIZONTAL_ALIGN_RIGHT
	"fullscreen",		// HORIZONTAL_ALIGN_FULLSCREEN
	"noscale",			// HORIZONTAL_ALIGN_NOSCALE
	"alignto640",		// HORIZONTAL_ALIGN_TO640
	"center_safearea",	// HORIZONTAL_ALIGN_CENTER_SAFEAREA
};
cassert( ARRAY_COUNT( g_he_horzalign ) == HORIZONTAL_ALIGN_MAX + 1 );


static const char *g_he_vertalign[] =
{
	"subtop",			// VERTICAL_ALIGN_SUBTOP
	"top",				// VERTICAL_ALIGN_TOP
	"middle",			// VERTICAL_ALIGN_CENTER
	"bottom",			// VERTICAL_ALIGN_BOTTOM
	"fullscreen",		// VERTICAL_ALIGN_FULLSCREEN
	"noscale",			// VERTICAL_ALIGN_NOSCALE
	"alignto480",		// VERTICAL_ALIGN_TO480
	"center_safearea",	// VERTICAL_ALIGN_CENTER_SAFEAREA
};
cassert( ARRAY_COUNT( g_he_vertalign ) == VERTICAL_ALIGN_MAX + 1 );
*/

init()
{
	level.uiParent = spawnstruct();
	level.uiParent.horzAlign = "left";
	level.uiParent.vertAlign = "top";
	level.uiParent.alignX = "left";
	level.uiParent.alignY = "top";
	level.uiParent.x = 0;
	level.uiParent.y = 0;
	level.uiParent.width = 0;
	level.uiParent.height = 0;
	level.uiParent.children = [];
	
	// supplydrop
	level.primaryProgressBarY = -61; // from center
	level.primaryProgressBarX = 0;
	level.primaryProgressBarHeight = 9; //28; // this is the height and width of the whole progress bar, including the outline. the part that actually moves is 2 pixels smaller.
	level.primaryProgressBarWidth = 120;
	level.primaryProgressBarTextY = -75;
	level.primaryProgressBarTextX = 0;
	level.primaryProgressBarFontSize = 1.4;
	
	level.secondaryProgressBarY = -85; // from center
	level.secondaryProgressBarX = 0;
	level.secondaryProgressBarHeight = 9; //28; // this is the height and width of the whole progress bar, including the outline. the part that actually moves is 2 pixels smaller.
	level.secondaryProgressBarWidth = 120;
	level.secondaryProgressBarTextY = -100;
	level.secondaryProgressBarTextX = 0;
	level.secondaryProgressBarFontSize = 1.4;
	
	if ( level.console )
		level.fontHeight = 12;
	else
		level.fontHeight = 12;
}
