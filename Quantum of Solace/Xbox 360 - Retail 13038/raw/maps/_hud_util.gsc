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
			setPointBar( point, relativePoint, xOffset, yOffset );
			if( isDefined (self.barFrame ) )
			{
				self.barFrame setParent( self getParent() );
				self.barFrame setPoint( point, relativePoint, xOffset, yOffset );
			}
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
		self.bar.x = self.x + self.padding;
	else if ( self.alignX == "right" )
		self.bar.x = self.x - (self.width - self.padding);
	else
		self.bar.x = self.x - int((self.width - self.padding) / 2);
	
	self updateBar( self.bar.frac );
}


/*updateBar( barFrac )
{
	barWidth = int((self.width - (self.padding * 2)) * barFrac);
	
	if ( !barWidth )
		barWidth = 1;
	
	self.bar.frac = barFrac;
	self.bar setShader( self.bar.shader, barWidth, self.height - (self.padding * 2) );
}*/

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
	
	if ( isDefined( rateOfChange ) && barWidth != self.width ) 
	{
		if ( rateOfChange > 0 )
		{
			printLn( "scaling from: " + barWidth + " to " + self.width + " at " + ((1 - barFrac) / rateOfChange) );
			assertex( ((1 - barFrac) / rateOfChange) > 0, "barFrac: " + barFrac + "rateOfChange: " + rateOfChange );
			self.bar scaleOverTime( (1 - barFrac) / rateOfChange, self.width, self.height );
		}
		else if ( rateOfChange < 0 )
		{
			printLn( "scaling from: " + barWidth + " to " + 0 + " at " + (barFrac / (-1 * rateOfChange)) );
			assertex(  (barFrac / (-1 * rateOfChange)) > 0, "barFrac: " + barFrac + "rateOfChange: " + rateOfChange );
			self.bar scaleOverTime( barFrac / (-1 * rateOfChange), 1, self.height );
		}
	}
	self.bar.rateOfChange = rateOfChange;
	self.bar.lastUpdateTime = getTime();
}

createFontString( font, fontScale )
{
	fontElem = newHudElem( self );
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


createServerFontString( font, fontScale )
{
	fontElem = newHudElem( self );
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

createIcon( shader, width, height )
{
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
	
	if ( isDefined( shader ) )
		iconElem setShader( shader, width, height );
	
	return iconElem;
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

createPrimaryProgressBarText()
{
	text = createFontString( "default", level.primaryProgressBarFontSize );
	text setPoint("CENTER", undefined, 0, level.primaryProgressBarTextY);
	return text;
}

createSecondaryProgressBarText()
{
	text = createFontString( "default", level.secondaryProgressBarFontSize);
	text setPoint("BOTTOM", undefined, 0, level.secondaryProgressBarTextY);
	return text;
}

setFlashFrac( flashFrac )
{
	self.bar.flashFrac = flashFrac;
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

	for ( index = 0; index < self.children.size; index++ )
		tempChildren[index] = self.children[index];

	for ( index = 0; index < tempChildren.size; index++ )
		tempChildren[index] setParent( self getParent() );
		
	if ( self.elemType == "bar" )
	{
		self.bar destroy();
		if( isDefined( self.barFrame ) )
		{
			self.barFrame destroy();
		}
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
