

init()
{
	precacheShader( "progress_bar_bg" );
	precacheShader( "progress_bar_fg" );
	precacheShader( "progress_bar_fill" );
	precacheShader( "score_bar_bg" );
	precacheShader( "score_bar_allies" );
	precacheShader( "score_bar_opfor" );
	precacheShader( "dtimer_bg" );
	precacheShader( "dtimer_bg_border" );
	precacheShader( "dtimer_0" );
	precacheShader( "dtimer_1" );
	precacheShader( "dtimer_2" );
	precacheShader( "dtimer_3" );
	precacheShader( "dtimer_4" );
	precacheShader( "dtimer_5" );
	precacheShader( "dtimer_6" );
	precacheShader( "dtimer_7" );
	precacheShader( "dtimer_8" );
	precacheShader( "dtimer_9" );
	
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
	
	level.fontHeight = 12;
	
	level.hud["allies"] = spawnstruct();
	level.hud["axis"] = spawnstruct();
	
	
	
	
	level.primaryProgressBarY = -96; 
	level.primaryProgressBarHeight = 28; 
	level.primaryProgressBarWidth = 192;
	level.primaryProgressBarTextY = -98;
	level.primaryProgressBarFontSize = 1.65;
	
	
	level.secondaryProgressBarY = -48; 
	level.secondaryProgressBarHeight = 38;
	level.secondaryProgressBarWidth = 192;
	level.secondaryProgressBarTextY = -58;
	level.secondaryProgressBarFontSize = 2;

	level.teamProgressBarY = 32; 
	level.teamProgressBarHeight = 14;
	level.teamProgressBarWidth = 192;
	level.teamProgressBarTextY = 8; 
	level.teamProgressBarFontSize = 1.65;

	if ( getDvar( "ui_score_bar" ) == "" )
		setDvar( "ui_score_bar", 0 );
		
	if ( getDvarInt( "ui_score_bar" ) > 0 )
	{
		makeDVarServerInfo( "ui_gametype_text" );
		level.hud_scoreBar = maps\mp\gametypes\_hud_util::createServerIcon( "score_bar_bg", 720, 62 );
		level.hud_scoreBar maps\mp\gametypes\_hud_util::setPoint( "TOPLEFT", "TOPLEFT", 0, -18 );
		level.hud_scoreBar.alpha = 0;
	}
	
	level.lowerTextY = 30;
	level.lowerTextFontSize = 2;
}


fontPulseInit()
{
	self.baseFontScale = self.fontScale;
	self.maxFontScale = self.fontScale * 2;
	self.inFrames = 3;
	self.outFrames = 5;
}


fontPulse(player)
{
	self notify ( "fontPulse" );
	self endon ( "fontPulse" );
	player endon("disconnect");
	player endon("joined_team");
	player endon("joined_spectators");

	scaleRange = self.maxFontScale - self.baseFontScale;

	while ( self.fontScale < self.maxFontScale )
	{
		self.fontScale = min( self.maxFontScale, self.fontScale + (scaleRange / self.inFrames) );
		wait 0.05;
	}

	while ( self.fontScale > self.baseFontScale )
	{
		self.fontScale = max( self.baseFontScale, self.fontScale - (scaleRange / self.outFrames) );
		wait 0.05;
	}
}
