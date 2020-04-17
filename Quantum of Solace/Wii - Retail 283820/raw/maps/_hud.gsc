

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
	
	if ( level.xenon )
		level.fontHeight = 12;
	else
		level.fontHeight = 12;

	level.primaryProgressBarTextY = -98;
	level.primaryProgressBarFontSize = 1.65;
	level.secondaryProgressBarTextY = -58;
	level.secondaryProgressBarFontSize = 2;
}
