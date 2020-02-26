#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;

setParent( element )
{
	if ( isDefined( self.parent ) && self.parent == element )
		return;
		
	if ( isDefined( self.parent ) )
		self.parent removeChild( self );

	self.parent = element;
	self.parent addChild( self );

	if ( isDefined( self.point ) )
		self setPoint( self.point, self.relativePoint, self.xOffset, self.yOffset );
	else
		self setPoint( "TOPLEFT" );
}

getParent()
{
	return self.parent;
}

addChild( element )
{
	element.index = self.children.size;
	self.children[self.children.size] = element;
}

removeChild( element )
{
	element.parent = undefined;

	if ( self.children[self.children.size-1] != element )
	{
		self.children[element.index] = self.children[self.children.size-1];
		self.children[element.index].index = element.index;
	}
	self.children[self.children.size-1] = undefined;
	
	element.index = undefined;
}


setPoint( point, relativePoint, xOffset, yOffset, moveTime )
{
	if ( !isDefined( moveTime ) )
		moveTime = 0;

	element = self getParent();

	if ( moveTime )
		self moveOverTime( moveTime );
	
	if ( !isDefined( xOffset ) )
		xOffset = 0;
	self.xOffset = xOffset;

	if ( !isDefined( yOffset ) )
		yOffset = 0;
	self.yOffset = yOffset;
		
	self.point = point;

	self.alignX = "center";
	self.alignY = "middle";

	if ( isSubStr( point, "TOP" ) )
		self.alignY = "top";
	if ( isSubStr( point, "BOTTOM" ) )
		self.alignY = "bottom";
	if ( isSubStr( point, "LEFT" ) )
		self.alignX = "left";
	if ( isSubStr( point, "RIGHT" ) )
		self.alignX = "right";

	if ( !isDefined( relativePoint ) )
		relativePoint = point;

	self.relativePoint = relativePoint;

	relativeX = "center";
	relativeY = "middle";

	if ( isSubStr( relativePoint, "TOP" ) )
		relativeY = "top";
	if ( isSubStr( relativePoint, "BOTTOM" ) )
		relativeY = "bottom";
	if ( isSubStr( relativePoint, "LEFT" ) )
		relativeX = "left";
	if ( isSubStr( relativePoint, "RIGHT" ) )
		relativeX = "right";

	if ( element == level.uiParent )
	{
		self.horzAlign = relativeX;
		self.vertAlign = relativeY;
	}
	else
	{
		self.horzAlign = element.horzAlign;
		self.vertAlign = element.vertAlign;
	}


	if ( relativeX == element.alignX )
	{
		offsetX = 0;
		xFactor = 0;
	}
	else if ( relativeX == "center" || element.alignX == "center" )
	{
		offsetX = int(element.width / 2);
		if ( relativeX == "left" || element.alignX == "right" )
			xFactor = -1;
		else
			xFactor = 1;	
	}
	else
	{
		offsetX = element.width;
		if ( relativeX == "left" )
			xFactor = -1;
		else
			xFactor = 1;
	}
	self.x = element.x + (offsetX * xFactor);

	if ( relativeY == element.alignY )
	{
		offsetY = 0;
		yFactor = 0;
	}
	else if ( relativeY == "middle" || element.alignY == "middle" )
	{
		offsetY = int(element.height / 2);
		if ( relativeY == "top" || element.alignY == "bottom" )
			yFactor = -1;
		else
			yFactor = 1;	
	}
	else
	{
		offsetY = element.height;
		if ( relativeY == "top" )
			yFactor = -1;
		else
			yFactor = 1;
	}
	self.y = element.y + (offsetY * yFactor);
	
	self.x += self.xOffset;
	self.y += self.yOffset;
	
	switch ( self.elemType )
	{
		case "bar":
			setPointBar( point, relativePoint );
			break;
	}
	
	self updateChildren();
}

// CODER_MOD: Austin (8/4/08): port progress bar script from MP
//PARAMETER CLEANUP
setPointBar( point, relativePoint )
{
	self.bar.horzAlign = self.horzAlign;
	self.bar.vertAlign = self.vertAlign;
	
	self.bar.alignX = "left";
	self.bar.alignY = self.alignY;
	self.bar.y = self.y;
	
	if ( self.alignX == "left" )
		self.bar.x = self.x;
	else if ( self.alignX == "right" )
		self.bar.x = self.x - self.width;
	else
		self.bar.x = self.x - int(self.width / 2);
	
	if ( self.alignY == "top" )
		self.bar.y = self.y;
	else if ( self.alignY == "bottom" )
		self.bar.y = self.y;

	self updateBar( self.bar.frac );
}


updateBar( barFrac, rateOfChange )
{
	if ( self.elemType == "bar" )
		updateBarScale( barFrac, rateOfChange );
}


updateBarScale( barFrac, rateOfChange ) // rateOfChange is optional and is in "(entire bar lengths) per second"
{
	barWidth = int(self.width * barFrac + 0.5); // (+ 0.5 rounds)

	if ( !barWidth )
		barWidth = 1;

	self.bar.frac = barFrac;
	self.bar setShader( self.bar.shader, barWidth, self.height );

	assert( barWidth <= self.width, "barWidth <= self.width: " + barWidth + " <= " + self.width + " - barFrac was " + barFrac );

	//if barWidth is bigger than self.width then we are drawing more than 100%
	if ( isDefined( rateOfChange ) && barWidth < self.width ) 
	{
		if ( rateOfChange > 0 )
		{
			//printLn( "scaling from: " + barWidth + " to " + self.width + " at " + ((1 - barFrac) / rateOfChange) );
			assert( ((1 - barFrac) / rateOfChange) > 0, "barFrac: " + barFrac + "rateOfChange: " + rateOfChange );
			self.bar scaleOverTime( (1 - barFrac) / rateOfChange, self.width, self.height );
		}
		else if ( rateOfChange < 0 )
		{
			//printLn( "scaling from: " + barWidth + " to " + 0 + " at " + (barFrac / (-1 * rateOfChange)) );
			assert(  (barFrac / (-1 * rateOfChange)) > 0, "barFrac: " + barFrac + "rateOfChange: " + rateOfChange );
			self.bar scaleOverTime( barFrac / (-1 * rateOfChange), 1, self.height );
		}
	}
	self.bar.rateOfChange = rateOfChange;
	self.bar.lastUpdateTime = getTime();
}


/@
"Name: createFontString( <font>, <fontScale> )"
"Summary: Creates a hud element for font purposes"
"Module: Hud"
"MandatoryArg: <font>: Apparently this is always set to default."
"MandatoryArg: <fontScale>: The scale you want."
"OptionalArg: <player>: If specified, causes the hud elem created to be a client hud elem."
"Example: level.hintElem = createFontString( "default", 2.0 );"
"SPMP: singleplayer"
@/

createFontString( font, fontScale, player )
{
	if(isdefined(player))
	{
		fontElem = newClientHudElem(player);
	}
	else
	{
		fontElem = newHudElem();
	}
	fontElem.elemType = "font";
	fontElem.font = font;
	fontElem.fontscale = fontScale;
	fontElem.x = 0;
	fontElem.y = 0;
	fontElem.sort = 100;
	fontElem.width = 0;
	fontElem.height = int(level.fontHeight * fontScale);
	fontElem.xOffset = 0;
	fontElem.yOffset = 0;
	fontElem.children = [];
	fontElem setParent( level.uiParent );
	fontElem.hidden = false;
	return fontElem;
}


createServerFontString( font, fontScale )
{
	fontElem = newHudElem();
	fontElem.elemType = "font";
	fontElem.font = font;
	fontElem.fontscale = fontScale;
	fontElem.x = 0;
	fontElem.y = 0;
	fontElem.width = 0;
	fontElem.height = int(level.fontHeight * fontScale);
	fontElem.xOffset = 0;
	fontElem.yOffset = 0;
	fontElem.children = [];
	fontElem setParent( level.uiParent );
	
	return fontElem;
}

createServerTimer( font, fontScale )
{	
	timerElem = newHudElem();
	timerElem.elemType = "timer";
	timerElem.font = font;
	timerElem.fontscale = fontScale;
	timerElem.x = 0;
	timerElem.y = 0;
	timerElem.width = 0;
	timerElem.height = int(level.fontHeight * fontScale);
	timerElem.xOffset = 0;
	timerElem.yOffset = 0;
	timerElem.children = [];
	timerElem setParent( level.uiParent );
	
	return timerElem;
}

// CODER_MOD - BNANDAKUMAR (7/16/08): Added the player as the 4th argument to toggle between clientHudElem or HudElem for all clients
createIcon( shader, width, height, player )
{
	if(isdefined(player))
	{
		iconElem = newClientHudElem( player );
	}
	else
	{
		iconElem = newHudElem();
	}
	iconElem.elemType = "icon";
	iconElem.x = 0;
	iconElem.y = 0;
	iconElem.width = width;
	iconElem.height = height;
	iconElem.xOffset = 0;
	iconElem.yOffset = 0;
	iconElem.children = [];
	iconElem setParent( level.uiParent );
	
	if ( isDefined( shader ) )
		iconElem setShader( shader, width, height );
	
	return iconElem;
}


createBar( color, width, height, flashFrac )
{
	barElem = newClientHudElem(	self );
	barElem.x = 0 ;
	barElem.y = 0;
	barElem.frac = 0;
	barElem.color = color;
	barElem.sort = -2;
	barElem.shader = "white";
	barElem setShader( "white", width, height );
	barElem.hidden = false;
	if ( isDefined( flashFrac ) )
	{
		barElem.flashFrac = flashFrac;
//		barElem thread flashThread();
	}

	barElemFrame = newClientHudElem( self );
	barElemFrame.elemType = "icon";
	barElemFrame.x = 0;
	barElemFrame.y = 0;
	barElemFrame.width = width;
	barElemFrame.height = height;
	barElemFrame.xOffset = 0;
	barElemFrame.yOffset = 0;
	barElemFrame.bar = barElem;
	barElemFrame.barFrame = barElemFrame;
	barElemFrame.children = [];
	barElemFrame.sort = -1;
	barElemFrame.color = (1,1,1);
	barElemFrame setParent( level.uiParent );
//	barElemFrame setShader( "progress_bar_fg", width, height );
	barElemFrame.hidden = false;

	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	if ( !level.splitScreen )
	{
		barElemBG.x = -2;
		barElemBG.y = -2;
	}
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.bar = barElem;
	barElemBG.barFrame = barElemFrame;
	barElemBG.children = [];
	barElemBG.sort = -3;
	barElemBG.color = (0,0,0);
	barElemBG.alpha = 0.5;
	barElemBG setParent( level.uiParent );
	if ( !level.splitScreen )
		barElemBG setShader( "black", width + 4, height + 4 );
	else
		barElemBG setShader( "black", width + 0, height + 0 );
	barElemBG.hidden = false;

	return barElemBG;
}


createPrimaryProgressBar()
{
	bar = createBar( (1, 1, 1), level.primaryProgressBarWidth, level.primaryProgressBarHeight );
	if ( level.splitScreen )
		bar setPoint("TOP", undefined, level.primaryProgressBarX, level.primaryProgressBarY);
	else
		bar setPoint("CENTER", undefined, level.primaryProgressBarX, level.primaryProgressBarY);

	return bar;
}

createPrimaryProgressBarText()
{
	text = createFontString( "objective", level.primaryProgressBarFontSize, self );
	if ( level.splitScreen )
		text setPoint("TOP", undefined, level.primaryProgressBarTextX, level.primaryProgressBarTextY);
	else
		text setPoint("CENTER", undefined, level.primaryProgressBarTextX, level.primaryProgressBarTextY);
	
	text.sort = -1;
	return text;
}


hideElem()
{
	if ( !isDefineD(self.hidden) )
		self.hidden = false;
		
	if ( self.hidden )
		return;

	self.hidden 	= true;
	self.oldAlpha  	= self.alpha;
	self.alpha 		= 0;

	if ( isDefined(self.elemType) && (self.elemType == "bar" || self.elemType == "bar_shader" ))
	{
		self.bar.hidden = true;
		self.bar.alpha = 0;

		self.barFrame.hidden = true;
		self.barFrame.alpha = 0;
	}
}


showElem()
{
	if ( !isDefineD(self.hidden) )
		self.hidden = false;
		
	if ( !self.hidden )
		return;

	self.hidden = false;
	
	if ( isDefined(self.elemType) &&(self.elemType == "bar" || self.elemType == "bar_shader") )
	{
		if ( self.alpha != .5 )
			self.alpha = .5;

		self.bar.hidden = false;
		if ( self.bar.alpha != 1 )
			self.bar.alpha = 1;

		self.barFrame.hidden = false;
		if ( self.barFrame.alpha != 1 )
			self.barFrame.alpha = 1;
	}
	else
	{
		self.alpha  = self.oldAlpha;
	}
}

flashThread()
{
	self endon ( "death" );

	self.alpha = 1;
	while(1)
	{
		if ( self.frac >= self.flashFrac )
		{
			self fadeOverTime(0.3);
			self.alpha = .2;
			wait(0.35);
			self fadeOverTime(0.3);
			self.alpha = 1;
			wait(0.7);
		}
		else
		{
			self.alpha = 1;
			wait ( 0.05 );
		}
	}
}


destroyElem()
{
	tempChildren = [];

	if (isDefined(self.children) )
	{
		for ( index = 0; index < self.children.size; index++ )
			tempChildren[index] = self.children[index];
	}

	for ( index = 0; index < tempChildren.size; index++ )
		tempChildren[index] setParent( self getParent() );
		
	if ( isDefined(self.elemType) && self.elemType == "bar" )
	{
		self.bar destroy();
		self.barFrame destroy();
	}
		
	self destroy();
}

setIconShader( shader )
{
	self setShader( shader, self.width, self.height );
}

updateChildren()
{
	for ( index = 0; index < self.children.size; index++ )
	{
		child = self.children[index];
		child setPoint( child.point, child.relativePoint, child.xOffset, child.yOffset );
	}
}

/*
	thread stance_carry_icon_enable( bool );
	Diasables all stance icons and replaces with an icon of 
	a person carrying another person on his back. True/false
*/
// disabled, nobody is using this and it needs to be updated to work on remote clients
//stance_carry_icon_enable( bool )
//{
//	if ( isdefined( bool ) && bool == false )
//	{
//		stance_carry_icon_disable();
//		return;
//	}
//		
//	if ( isDefined( level.stance_carry ) )
//		level.stance_carry destroy();
//		
//	SetSavedDvar( "hud_showStance", "0" );
//	
//	level.stance_carry = newHudElem();
//	level.stance_carry.x = 100;
//	level.stance_carry.y = 20;
//	level.stance_carry setshader ( "stance_carry", 64, 64 );
//	level.stance_carry.alignX = "left";
//	level.stance_carry.alignY = "bottom";
//	level.stance_carry.horzAlign = "left";
//	level.stance_carry.vertAlign = "bottom";
//	level.stance_carry.foreground = true;
//	level.stance_carry.alpha = 0;
//	level.stance_carry fadeOverTime( 0.5 );
//	level.stance_carry.alpha = 1;
//}
//
//stance_carry_icon_disable()
//{
//	if ( isDefined( level.stance_carry ) )
//	{
//		level.stance_carry fadeOverTime( 0.5 );
//		level.stance_carry.alpha = 0;
//		level.stance_carry destroy();			
//	}
//	SetSavedDvar( "hud_showStance", "1" );
//}

get_countdown_hud( x )
{
	xPos = undefined;
	if ( !isdefined( x ) )
		xPos = -225;
	else
		xPos = x;
	hudelem = newHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "right";
    hudelem.vertAlign = "top";
    hudelem.x = xPos;
    hudelem.y = 100;
    
  	hudelem.fontScale = 1.6;
	hudelem.color = (0.8, 1.0, 0.8);
	hudelem.font = "objective";
	hudelem.glowColor = (0.3, 0.6, 0.3);
	hudelem.glowAlpha = 1;
 	hudelem.foreground = 1;
 	hudelem.hidewheninmenu = true;
	return hudelem;
	
}


/*
=============
///ScriptDocBegin
"Name: fade_over_time( <target_alpha> , <fade_time> )"
"Summary: Fade the hud_elem to the target_alpha over fade_time."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <target_alpha>: Desired alpha to transition to"
"OptionalArg: <fade_time>: Time for the fade to take place"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
fade_over_time( target_alpha, fade_time )
{
	assert( isdefined( target_alpha ), "fade_over_time must be passed a target_alpha." );

	if ( isdefined( fade_time ) && fade_time > 0 )
	{
		self fadeOverTime( fade_time );
	}

	self.alpha = target_alpha;

	if ( isdefined( fade_time ) && fade_time > 0 )
	{
		wait fade_time;
	}
}

destroyHudElem( hudElem )
{
	if( isDefined( hudElem ) )
		hudElem destroyElem();
}



fadeToBlackForXSec( startwait, blackscreenwait, fadeintime, fadeouttime )
{
	//Init wait
	wait( startwait );
	
	//Displays black screen
	if( !isdefined(self.blackscreen) )
		self.blackscreen = newclienthudelem( self );
	
	self.blackscreen.x = 0;
	self.blackscreen.y = 0; 
	self.blackscreen.horzAlign = "fullscreen";
	self.blackscreen.vertAlign = "fullscreen";
	self.blackscreen.foreground = false;
	self.blackscreen.hidewhendead = false;
	self.blackscreen.hidewheninmenu = true;

	self.blackscreen.sort = 50; 
	self.blackscreen SetShader( "black", 640, 480 ); 
	self.blackscreen.alpha = 0; 
	
	//Fade in
	if( fadeintime>0 )
		self.blackscreen FadeOverTime( fadeintime ); 
	self.blackscreen.alpha = 1; 
	wait( fadeintime );
	if( !isdefined(self.blackscreen) )
		return;		//hudelem was deleted during this wait 
	
	//Wait at black screen for a set time
	wait( blackscreenwait );
	if( !isdefined(self.blackscreen) )
		return;		//hudelem was deleted during this wait 
	
	//Fade out
	if( fadeouttime>0 )
		self.blackscreen FadeOverTime( fadeouttime ); 
	self.blackscreen.alpha = 0; 
	wait( fadeouttime );

	//Cleanup hud element
	if( isdefined(self.blackscreen) )			
	{
		self.blackscreen destroy();
		self.blackscreen = undefined;
	}
}
