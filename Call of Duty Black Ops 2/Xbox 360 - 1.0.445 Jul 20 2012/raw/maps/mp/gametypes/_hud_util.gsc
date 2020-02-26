#include maps\mp\_utility;

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
		self setPoint( "TOP" );
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

	switch( point )
	{
		case "CENTER":
			break;

		case "TOP":
			self.alignY = "top";
			break;

		case "BOTTOM":
			self.alignY = "bottom";
			break;

		case "LEFT":
			self.alignX = "left";
			break;
		
		case "RIGHT":
			self.alignX = "right";
			break;

		case "TOPRIGHT":
		case "TOP_RIGHT":
			self.alignY = "top";
			self.alignX = "right";
			break;

		case "TOPLEFT":
		case "TOP_LEFT":
			self.alignY = "top";
			self.alignX = "left";
			break;

		case "TOPCENTER":
			self.alignY = "top";
			self.alignX = "center";
			break;

		case "BOTTOM RIGHT":
		case "BOTTOM_RIGHT":
			self.alignY = "bottom";
			self.alignX = "right";
			break;

		case "BOTTOM LEFT":
		case "BOTTOM_LEFT":
			self.alignY = "bottom";
			self.alignX = "left";
			break;

		default:
		/#	println( "^3Warning: unknown point passed to setPoint(): " + point ); 	#/
			break;
	}

	if ( !isDefined( relativePoint ) )
		relativePoint = point;

	self.relativePoint = relativePoint;

	relativeX = "center";
	relativeY = "middle";

	switch( relativePoint )
	{
		case "CENTER":
			break;

		case "TOP":
			relativeY = "top";
			break;

		case "BOTTOM":
			relativeY = "bottom";
			break;

		case "LEFT":
			relativeX = "left";
			break;

		case "RIGHT":
			relativeX = "right";
			break;

		case "TOPRIGHT":
		case "TOP_RIGHT":
			relativeY = "top";
			relativeX = "right";
			break;

		case "TOPLEFT":
		case "TOP_LEFT":
			relativeY = "top";
			relativeX = "left";
			break;

		case "TOPCENTER":
			relativeY = "top";
			relativeX = "center";
			break;

		case "BOTTOM RIGHT":
		case "BOTTOM_RIGHT":
			relativeY = "bottom";
			relativeX = "right";
			break;

		case "BOTTOM LEFT":
		case "BOTTOM_LEFT":
			relativeY = "bottom";
			relativeX = "left";
			break;

		default:
		/#	println( "^3Warning: unknown relativePoint passed to setPoint(): " + relativePoint ); 	#/
			break;
	}

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
			setPointBar( point, relativePoint, xOffset, yOffset );
			//self.bar setPoint( point, relativePoint, xOffset, yOffset );
			self.barFrame setParent( self getParent() );
			self.barFrame setPoint( point, relativePoint, xOffset, yOffset );
			break;
	}
	
	self updateChildren();
}


setPointBar( point, relativePoint, xOffset, yOffset )
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


createFontString( font, fontScale )
{
	fontElem = newClientHudElem( self );
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
	fontElem.hidden = false;
	return fontElem;
}


createServerFontString( font, fontScale, team )
{
	if ( isDefined( team ) )
		fontElem = newTeamHudElem( team );
	else
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
	fontElem.hidden = false;
	
	return fontElem;
}

createServerTimer( font, fontScale, team )
{	
	if ( isDefined( team ) )
		timerElem = newTeamHudElem( team );
	else
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
	timerElem.hidden = false;
	
	return timerElem;
}

createClientTimer( font, fontScale )
{
	timerElem = newClientHudElem( self );
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
	timerElem.hidden = false;
	
	return timerElem;
}

createIcon( shader, width, height )
{
	iconElem = newClientHudElem( self );
	iconElem.elemType = "icon";
	iconElem.x = 0;
	iconElem.y = 0;
	iconElem.width = width;
	iconElem.height = height;
	iconElem.xOffset = 0;
	iconElem.yOffset = 0;
	iconElem.children = [];
	iconElem setParent( level.uiParent );
	iconElem.hidden = false;
	
	if ( isDefined( shader ) )
		iconElem setShader( shader, width, height );
	
	return iconElem;
}


createServerIcon( shader, width, height, team )
{
	if ( isDefined( team ) )
		iconElem = newTeamHudElem( team );
	else
		iconElem = newHudElem();
	iconElem.elemType = "icon";
	iconElem.x = 0;
	iconElem.y = 0;
	iconElem.width = width;
	iconElem.height = height;
	iconElem.xOffset = 0;
	iconElem.yOffset = 0;
	iconElem.children = [];
	iconElem setParent( level.uiParent );
	iconElem.hidden = false;
	
	if ( isDefined( shader ) )
		iconElem setShader( shader, width, height );
	
	return iconElem;
}


createServerBar( color, width, height, flashFrac, team, selected )
{
	if ( isDefined( team ) )
		barElem = newTeamHudElem( team );
	else
		barElem = newHudElem();
	barElem.x = 0;
	barElem.y = 0;
	barElem.frac = 0;
	barElem.color = color;
	barElem.sort = -2;
	barElem.shader = "progress_bar_fill";
	barElem setShader( "progress_bar_fill", width, height );
	barElem.hidden = false;
	if ( isDefined( flashFrac ) )
	{
		barElem.flashFrac = flashFrac;
//		barElem thread flashThread();
	}

	if ( isDefined( team ) )
		barElemFrame = newTeamHudElem( team );
	else
		barElemFrame = newHudElem();
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
	if ( isDefined( selected ) )
		barElemFrame setShader( "progress_bar_fg_sel", width, height );
	else
		barElemFrame setShader( "progress_bar_fg", width, height );
	barElemFrame.hidden = false;

	if ( isDefined( team ) )
		barElemBG = newTeamHudElem( team );
	else
		barElemBG = newHudElem();
	barElemBG.elemType = "bar";
	barElemBG.x = 0;
	barElemBG.y = 0;
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
	barElemBG setShader( "progress_bar_bg", width, height );
	barElemBG.hidden = false;
	
	return barElemBG;
}

createBar( color, width, height, flashFrac )
{
	barElem = newClientHudElem(	self );
	barElem.x = 0 ;
	barElem.y = 0;
	barElem.frac = 0;
	barElem.color = color;
	barElem.sort = -2;
	barElem.shader = "progress_bar_fill";
	barElem setShader( "progress_bar_fill", width, height );
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
		barElemBG setShader( "progress_bar_bg", width + 4, height + 4 );
	else
		barElemBG setShader( "progress_bar_bg", width + 0, height + 0 );
	barElemBG.hidden = false;
	
	return barElemBG;
}

getCurrentFraction()
{
	frac = self.bar.frac;
	if (isdefined(self.bar.rateOfChange))
	{
		frac += (getTime() - self.bar.lastUpdateTime) * self.bar.rateOfChange;
		if (frac > 1) frac = 1;
		if (frac < 0) frac = 0;
	}
	return frac;
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
	text = createFontString( "objective", level.primaryProgressBarFontSize );
	if ( level.splitScreen )
		text setPoint("TOP", undefined, level.primaryProgressBarTextX, level.primaryProgressBarTextY);
	else
		text setPoint("CENTER", undefined, level.primaryProgressBarTextX, level.primaryProgressBarTextY);
	
	text.sort = -1;
	return text;
}

createSecondaryProgressBar()
{
	secondaryProgressBarHeight = GetDvarIntDefault( "scr_secondaryProgressBarHeight", level.secondaryProgressBarHeight );
	secondaryProgressBarX = GetDvarIntDefault( "scr_secondaryProgressBarX", level.secondaryProgressBarX );
	secondaryProgressBarY = GetDvarIntDefault( "scr_secondaryProgressBarY", level.secondaryProgressBarY );

	bar = createBar( (1, 1, 1), level.secondaryProgressBarWidth, secondaryProgressBarHeight );
	if ( level.splitScreen )
		bar setPoint("TOP", undefined, secondaryProgressBarX, secondaryProgressBarY);
	else
		bar setPoint("CENTER", undefined, secondaryProgressBarX, secondaryProgressBarY);

	return bar;
}

createSecondaryProgressBarText()
{
	secondaryProgressBarTextX = GetDvarIntDefault( "scr_btx", level.secondaryProgressBarTextX );
	secondaryProgressBarTextY = GetDvarIntDefault( "scr_bty", level.secondaryProgressBarTextY );

	text = createFontString( "objective", level.primaryProgressBarFontSize );
	if ( level.splitScreen )
		text setPoint("TOP", undefined, secondaryProgressBarTextX, secondaryProgressBarTextY);
	else
		text setPoint("CENTER", undefined, secondaryProgressBarTextX, secondaryProgressBarTextY);
	
	text.sort = -1;
	return text;
}

createTeamProgressBar( team )
{
	bar = createServerBar( (1,0,0), level.teamProgressBarWidth, level.teamProgressBarHeight, undefined, team );
	bar setPoint("TOP", undefined, 0, level.teamProgressBarY);
	return bar;
}
createTeamProgressBarText( team )
{
	text = createServerFontString( "default", level.teamProgressBarFontSize, team );
	text setPoint("TOP", undefined, 0, level.teamProgressBarTextY);
	return text;
}


setFlashFrac( flashFrac )
{
	self.bar.flashFrac = flashFrac;
}

hideElem()
{
	if ( self.hidden )
		return;
		
	self.hidden = true;

	if ( self.alpha != 0 )
		self.alpha = 0;
	
	if ( self.elemType == "bar" || self.elemType == "bar_shader" )
	{
		self.bar.hidden = true;
		if ( self.bar.alpha != 0 )
			self.bar.alpha = 0;

		self.barFrame.hidden = true;
		if ( self.barFrame.alpha != 0 )
			self.barFrame.alpha = 0;
	}
}

showElem()
{
	if ( !self.hidden )
		return;
		
	self.hidden = false;

	if ( self.elemType == "bar" || self.elemType == "bar_shader" )
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
		if ( self.alpha != 1 )
			self.alpha = 1;
	}
}


flashThread()
{
	self endon ( "death" );

	if ( !self.hidden )
		self.alpha = 1;
		
	while(1)
	{
		if ( self.frac >= self.flashFrac )
		{
			if ( !self.hidden )
			{
				self fadeOverTime(0.3);
				self.alpha = .2;
				wait(0.35);
				self fadeOverTime(0.3);
				self.alpha = 1;
			}
			wait(0.7);
		}
		else
		{
			if ( !self.hidden && self.alpha != 1 )
				self.alpha = 1;

			wait ( 0.05 );
		}
	}
}


destroyElem()
{
	tempChildren = [];

	for ( index = 0; index < self.children.size; index++ )
	{
		if ( isDefined( self.children[index] ) )
			tempChildren[tempChildren.size] = self.children[index];
	}

	for ( index = 0; index < tempChildren.size; index++ )
		tempChildren[index] setParent( self getParent() );
		
	if ( self.elemType == "bar" || self.elemType == "bar_shader" )
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

setWidth( width )
{
	self.width = width;
}


setHeight( height )
{
	self.height = height;
}

setSize( width, height )
{
	self.width = width;
	self.height = height;
}

updateChildren()
{
	for ( index = 0; index < self.children.size; index++ )
	{
		child = self.children[index];
		child setPoint( child.point, child.relativePoint, child.xOffset, child.yOffset );
	}
}

createLoadoutIcon( verIndex, horIndex, xpos, ypos )
{
	iconsize = 32;

	if ( level.splitScreen )
		ypos = ypos - (80 + iconsize * (3 - verIndex));
	else
		ypos = ypos - (90 + iconsize * (3 - verIndex));
	
	if ( level.splitScreen )
		xpos = xpos - (5 + iconsize * horIndex);
	else
		xpos = xpos - (10 + iconsize * horIndex);

	icon = createIcon( "white", iconsize, iconsize );
	icon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", xpos, ypos );
	icon.horzalign = "user_right";
	icon.vertalign = "user_bottom";
	icon.archived = false;
	icon.foreground = false;
	icon.overrridewhenindemo = true;

	return icon;
}

setLoadoutIconCoords( verIndex, horIndex, xpos, ypos )
{
	iconsize = 32;

	if ( level.splitScreen )
		ypos = ypos - (80 + iconsize * (3 - verIndex));
	else
		ypos = ypos - (90 + iconsize * (3 - verIndex));
	
	if ( level.splitScreen )
		xpos = xpos - (5 + iconsize * horIndex);
	else
		xpos = xpos - (10 + iconsize * horIndex);

	self setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", xpos, ypos );
	self.horzalign = "user_right";
	self.vertalign = "user_bottom";
	self.archived = false;
	self.foreground = false;
	self.alpha = 1;
}

setLoadoutTextCoords( xCoord)
{
	self setPoint( "RIGHT", "LEFT", xCoord, 0 );
}

createLoadoutText( icon, xCoord )
{
	text = createFontString( "small", 1 );
	text setParent( icon );
	text setPoint( "RIGHT", "LEFT", xCoord, 0 );
	text.archived = false;
	text.alignX = "right";
	text.alignY = "middle";
	text.foreground = false;
	text.overrridewhenindemo = true;

	return text;
}

showLoadoutAttribute( iconElem, icon, alpha, textElem, text )
{
	iconsize = 32;

	iconElem.alpha = alpha;
	if ( alpha )
		iconElem setShader( icon, iconsize, iconsize );

	if ( isdefined( textElem ) )
	{
		textElem.alpha = alpha;
		if ( alpha )
			textElem setText( text );
	}
}

hideLoadoutAttribute( iconElem, fadeTime, textElem, hideTextOnly )
{
	if ( isdefined( fadeTime ) )
	{
		if ( !isDefined( hideTextOnly ) || !hideTextOnly )
		{
			iconElem fadeOverTime( fadeTime );
		}
		if ( isDefined( textElem ) )
		{
			textElem fadeOverTime( fadeTime );
		}
	}
	
	if ( !isDefined( hideTextOnly ) || !hideTextOnly )
		iconElem.alpha = 0;

	if ( isDefined( textElem ) )
		textElem.alpha = 0;
}

showPerks(  )
{
	ypos = 40;
	if ( !isdefined( self.perkHudelem ) )
	{
		self.perkHudelem = createLoadoutIcon( 0, 0, 200, ypos ); 	
	}
	else 
	{
		self.perkHudelem setLoadoutIconCoords( 0, 0, 200, ypos ); 
	}

	self.perkHudelem SetPerks( self );
	self.perkHudelem.x = -10;
	self.perkHudelem.alpha = 0;
	self.perkHudelem fadeOverTime( 0.4 );
	self.perkHudelem.alpha = 1;
	self.perkHudelem.hidewheninmenu = true;
}

showPerk( index, perk, ypos )
{
	// don't want the hud elements when the game is over
	assert( game["state"] != "postgame" );
	
	if ( !isdefined( self.perkicon ) )
	{
		self.perkicon = [];
		self.perkname = [];
	}
	
	if ( !isdefined( self.perkicon[ index ] ) )
	{
		assert( !isdefined( self.perkname[ index ] ) );
		
		self.perkicon[ index ] = createLoadoutIcon( index, 0, 200, ypos ); 
		self.perkname[ index ] = createLoadoutText( self.perkicon[ index ], 160 );
	}
	else 
	{
		self.perkicon[ index ] setLoadoutIconCoords( index, 0, 200, ypos ); 
		self.perkname[ index ] setLoadoutTextCoords( 160 ); 

	}

	if ( perk == "perk_null" || perk == "weapon_null" || perk == "specialty_null" )
	{
		alpha = 0;
	}
	else
	{
		assert( isDefined( level.perkNames[ perk ] ), perk );

		alpha = 1;
	}
	
	showLoadoutAttribute( self.perkicon[ index ], perk, alpha, self.perkname[ index ], level.perkNames[ perk ] );

	self.perkicon[ index ] moveOverTime( 0.3 );
	self.perkicon[ index ].x = -5;
	self.perkicon[ index ].hidewheninmenu = true;

	self.perkname[ index ] moveOverTime( 0.3 );
	self.perkname[ index ].x = -40;
	self.perkname[ index ].hidewheninmenu = true;
}

hidePerks( fadeTime )
{
	if ( level.perksEnabled == 1)
	{
		// If there has been no regualr killcams (hardcore) before the final killcam
		// perkicon will not be set up and will fail this assert )
		if ( game["state"] == "postgame" )
		{
				// perk icons should have been deleted in freeGameplayHudElems()
				assert( !isdefined( self.perkHudelem ) );
			return;
		}
	}
	assert( isdefined( self.perkHudelem ) );
	
	if ( IsDefined( self.perkHudelem ) )
	{
		hideLoadoutAttribute( self.perkHudelem, fadeTime );
	}
}

hidePerk( index, fadeTime, hideTextOnly )
{
	if ( !isdefined (fadeTime ) )
		fadeTime = 0.05;

	if ( level.perksEnabled == 1)
	{
		if ( game["state"] == "postgame" )
		{
			// If there has been no regualr killcams (hardcore) before the final killcam
			// perkicon will not be set up and will fail this assert )
			if ( isdefined( self.perkicon ) )
			{
				// perk icons should have been deleted in freeGameplayHudElems()
				assert( !isdefined( self.perkicon[ index ] ) );
				assert( !isdefined( self.perkname[ index ] ) );
			}
			return;
		}
		assert( isdefined( self.perkicon[ index ] ) );
		assert( isdefined( self.perkname[ index ] ) );
	
		if ( IsDefined( self.perkicon ) && IsDefined( self.perkicon[ index ] ) && IsDefined( self.perkname ) && IsDefined( self.perkname[ index ] ) )
		{
			hideLoadoutAttribute( self.perkicon[ index ], fadeTime, self.perkname[ index ], hideTextOnly );
		}
	}
}

hideAllPerks( fadeTime, hideTextOnly )
{
	if ( level.perksEnabled == 1 )
	{
		hidePerks( fadeTime );
//		for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
//		{
//			hidePerk( numSpecialties, fadeTime, hideTextOnly );
//		}
	}
}

showKillstreak( index, killstreak, xpos, ypos )
{
	// don't want the hud elements when the game is over
	assert( game["state"] != "postgame" );
	
	if ( !isdefined( self.killstreakIcon ) )
		self.killstreakIcon = [];
	
	if ( !isdefined( self.killstreakIcon[ index ] ) )
	{	
		// Since the perks are being displayed before the killstreaks, we use 3 as our vertical index. 
		// This might have to be changed/modified if we add some other details as part of the loadout
		// self.killstreak.size - 1 - index would be the horizontal index since we want to display the killstreaks from left to right
		self.killstreakIcon[ index ] = createLoadoutIcon( 3, self.killstreak.size - 1 - index, xpos, ypos ); 
	}

	if ( killstreak == "killstreak_null" || killstreak == "weapon_null" )
	{
		alpha = 0;
	}
	else
	{
		assert( isDefined( level.killstreakIcons[ killstreak ] ), killstreak );

		alpha = 1;
	}
	
	showLoadoutAttribute( self.killstreakIcon[ index ], level.killstreakIcons[ killstreak ], alpha );
}

hideKillstreak( index, fadetime )
{
	if ( isKillstreaksEnabled() )
	{
		if ( game["state"] == "postgame" )
		{
			// killstreak icons should have been deleted in freeGameplayHudElems()
			assert( !isdefined( self.killstreakIcon[ index ] ) );
			return;
		}
		assert( isdefined( self.killstreakIcon[ index ] ) );
	
		hideLoadoutAttribute( self.killstreakIcon[ index ], fadetime );
	}
}

setGamemodeInfoPoint()
{
	//self setPoint( "TOPLEFT", "TOPLEFT", 5, 110 );
	self.x = 5;
	self.y = 110;
	self.horzAlign = "user_left"; 
	self.vertAlign = "user_top"; 
	
	self.alignX = "left";
	self.alignY = "top";
}

