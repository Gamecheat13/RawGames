#include common_scripts\utility;
#include maps\_utility;

initCredits( type )
{
	flag_init( "atvi_credits_go" );
	level.linesize = 1.35;
	level.headingsize = 1.75;
	level.linelist = [];
	level.credits_speed = 22.5;
	level.credits_spacing = -120;
	
	set_console_status();
	if( !isdefined( type ) )
		type = "all";
	switch( type )
	{
		case "all":
			maps\creditsMW3::initMW3Credits();
			break;
	}
}

addEntryMW3( loc1, format1, loc2, format2, textscale )
{
	if (isdefined(loc1))
		precacheString( loc1 );
	if (isdefined(loc2))
		precacheString( loc2 );
		
	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "entry";
	temp.loc1 = loc1;
	temp.format1 = format1;
	temp.loc2 = loc2;
	temp.format2 = format2;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addBlankMW3()
{
	addGap();
}

addTitleMW3( title, textscale )
{
	precacheString( title );

	if ( !isdefined( textscale ) )
		textscale = 1.5*level.linesize;

	temp = spawnstruct();
	temp.type = "titlec";
	temp.title = title;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSubTitleMW3( subtitle, textscale )
{
	precacheString( subtitle );

	if ( !isdefined( textscale ) )
		textscale = 1.25*level.linesize;

	temp = spawnstruct();
	temp.type = "subtitlec";
	temp.subtitle = subtitle;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addHeaderMW3( headerl, headerr, textscale )
{
	precacheString( headerl );
	precacheString( headerr );

	if ( !isdefined( textscale ) )
		textscale = 1.2*level.linesize;

	temp = spawnstruct();
	temp.type = "headerlr";
	temp.left = headerl;
	temp.right = headerr;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSubHeaderMW3( headerl, headerr, textscale )
{
	precacheString( headerl );
	precacheString( headerr );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "subheaderlr";
	temp.left = headerl;
	temp.right = headerr;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSubHeaderLMW3( headerl, textscale )
{
	precacheString( headerl );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "subheaderl";
	temp.left = headerl;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSubHeaderRMW3( headerr, textscale )
{
	precacheString( headerr );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "subheaderr";
	temp.right = headerr;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenteredMW3( centered, textscale )
{
	precacheString( centered );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centered";
	temp.centered = centered;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCreditMW3_4( credit0, credit1, credit2, credit3, textscale )
{
	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "credit4";
	temp.textscale = textscale;
	temp.credits = [];
	if (isdefined(credit0))
	{
		precacheString( credit0 );
		temp.credits[0] = credit0;
	}
	if (isdefined(credit1))
	{
		precacheString( credit1 );
		temp.credits[1] = credit1;
	}
	if (isdefined(credit2))
	{
		precacheString( credit2 );
		temp.credits[2] = credit2;
	}
	if (isdefined(credit3))
	{
		precacheString( credit3 );
		temp.credits[3] = credit3;
	}

	level.linelist[ level.linelist.size ] = temp;
}

addCreditMW3_3f( credit0, format0, credit1, format1, credit2, format2, textscale )
{
	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "credit3f";
	temp.textscale = textscale;
	temp.credits = [];
	temp.formats = [];
	if (isdefined(credit0))
	{
		precacheString( credit0 );
		temp.credits[0] = credit0;
		temp.formats[0] = format0;
	}
	if (isdefined(credit1))
	{
		precacheString( credit1 );
		temp.credits[1] = credit1;
		temp.formats[1] = format1;
	}
	if (isdefined(credit2))
	{
		precacheString( credit2 );
		temp.credits[2] = credit2;
		temp.formats[2] = format2;
	}

	level.linelist[ level.linelist.size ] = temp;
}

addCreditMW3_3( credit0, credit1, credit2, textscale )
{
	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "credit3";
	temp.textscale = textscale;
	temp.credits = [];
	if (isdefined(credit0))
	{
		precacheString( credit0 );
		temp.credits[0] = credit0;
	}
	if (isdefined(credit1))
	{
		precacheString( credit1 );
		temp.credits[1] = credit1;
	}
	if (isdefined(credit2))
	{
		precacheString( credit2 );
		temp.credits[2] = credit2;
	}

	level.linelist[ level.linelist.size ] = temp;
}

addCreditMW3( creditl, creditr, textscale )
{
	precacheString( creditl );
	precacheString( creditr );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "creditlr";
	temp.left = creditl;
	temp.right = creditr;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCreditLMW3( creditl, textscale )
{
	precacheString( creditl );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "creditl";
	temp.left = creditl;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCreditRMW3( creditr, textscale )
{
	precacheString( creditr );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "creditr";
	temp.right = creditr;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCreditLSubHeaderRMW3( creditl, headerr, textscale )
{
	precacheString( creditl );
	precacheString( headerr );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "creditlshr";
	temp.left = creditl;
	temp.right = headerr;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addLeftTitle( title, textscale )
{
	precacheString( title );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "lefttitle";
	temp.title = title;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addLeftName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "leftname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSubLeftTitle( title, textscale )
{
	addLeftName( title, textscale );
}

addSubLeftName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "subleftname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addRightTitle( title, textscale )
{
	precacheString( title );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "righttitle";
	temp.title = title;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addRightName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "rightname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterHeading( heading, textscale )
{
	precacheString( heading );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centerheading";
	temp.heading = heading;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCastName( name, title, textscale )
{
	precacheString( title );
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "castname";
	temp.title = title;
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterName( name, textscale )
{
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centername";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterNameDouble( name1, name2, textscale )
{
	precacheString( name1 );
	precacheString( name2 );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centernamedouble";
	temp.name1 = name1;
	temp.name2 = name2;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterDual( title, name, textscale )
{
	precacheString( title );
	precacheString( name );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centerdual";
	temp.title = title;
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterTriple( name1, name2, name3, textscale )
{
	precacheString( name1 );
	precacheString( name2 );
	precacheString( name3 );

	if ( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centertriple";
	temp.name1 = name1;
	temp.name2 = name2;
	temp.name3 = name3;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSpace()
{
	temp = spawnstruct();
	temp.type = "space";

	level.linelist[ level.linelist.size ] = temp;
}

addSpaceSmall()
{
	temp = spawnstruct();
	temp.type = "spacesmall";

	level.linelist[ level.linelist.size ] = temp;
}

addCenterImage( image, width, height, delay )
{
	precacheShader( image );

	temp = spawnstruct();
	temp.type = "centerimage";
	temp.image = image;
	temp.width = width;
	temp.height = height;
	temp.sort = 2;

	if ( isdefined( delay ) )
		temp.delay = delay;

	level.linelist[ level.linelist.size ] = temp;
}

addLeftImage( image, width, height, delay )
{
	precacheShader( image );

	temp = spawnstruct();
	temp.type = "leftimage";
	temp.image = image;
	temp.width = width;
	temp.height = height;
	temp.sort = 2;

	if ( isdefined( delay ) )
		temp.delay = delay;

	level.linelist[ level.linelist.size ] = temp;
}

playCredits()
{
	VisionSetNaked( "", 0 );
	
	mode =  getdvar( "ui_char_museum_mode" );
	
	for ( i = 0; i < level.linelist.size; i++ )
	{
		delay = 0.5;// 0.4
		type = level.linelist[ i ].type;

		if ( type == "centerimage" )
		{
			if( isdefined( mode ) && mode != "credits_black" )
				flag_wait( "atvi_credits_go" );
				
			image = level.linelist[ i ].image;
			width = level.linelist[ i ].width;
			height = level.linelist[ i ].height;

			temp = newHudElem();
			temp SetShader( image, width, height );
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = 0;
			temp.y = 480;
			temp.sort = 2;
			temp.foreground = true;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;

			if ( isdefined( level.linelist[ i ].delay ) )
				delay = level.linelist[ i ].delay;
			else
				delay = ( ( 0.037 * height ) );
				//delay = ( ( 0.0296 * height ) );
		}
		else if ( type == "leftimage" )
		{
			image = level.linelist[ i ].image;
			width = level.linelist[ i ].width;
			height = level.linelist[ i ].height;

			temp = newHudElem();
			temp SetShader( image, width, height );
			temp.alignX = "center";
			temp.horzAlign = "left";
			temp.x = 128;
			temp.y = 480;
			temp.sort = 2;
			temp.foreground = true;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;

			delay = ( ( 0.037 * height ) );
			//delay = ( ( 0.0296 * height ) );
		}
		else if ( type == "lefttitle" )
		{
			title = level.linelist[ i ].title;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( title );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 28;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;		
			
			temp thread pulse_fx();
		}
		else if ( type == "leftname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 60;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;
			
			temp thread pulse_fx();
		}
		else if ( type == "castname" )
		{
			title = level.linelist[ i ].title;
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;
			
			temp1 = newHudElem();
			temp1 setText( title );
			temp1.alignX = "left";
			temp1.horzAlign = "left";
			temp1.x = 60;
			temp1.y = 480;

			if ( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;
			

			temp2 = newHudElem();
			temp2 setText( name );
			temp2.alignX = "right";
			temp2.horzAlign = "left";
			temp2.x = 275;
			temp2.y = 480;

			if ( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;
			
			

			temp1 thread delayDestroy( level.credits_speed );
			temp1 moveOverTime( level.credits_speed );
			temp1.y = level.credits_spacing;

			temp2 thread delayDestroy( level.credits_speed );
			temp2 moveOverTime( level.credits_speed );
			temp2.y = level.credits_spacing;
			
			temp1 thread pulse_fx();
			temp2 thread pulse_fx();
		}
		else if ( type == "subleftname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 92;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;
			
			temp thread pulse_fx();
		}
		else if ( type == "righttitle" )
		{
			title = level.linelist[ i ].title;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( title );
			temp.alignX = "left";
			temp.horzAlign = "right";
			temp.x = -132;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;
			
			//temp thread pulse_fx();
		}
		else if ( type == "rightname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "right";
			temp.x = -100;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;
			
			//temp thread pulse_fx();
		}
		else if ( type == "centerheading" )
		{
			heading = level.linelist[ i ].heading;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( heading );
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = 0;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;
			
			//temp thread pulse_fx();
		}
		else if ( type == "centerdual" )
		{
			title = level.linelist[ i ].title;
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( title );
			temp1.alignX = "right";
			temp1.horzAlign = "center";
			temp1.x = -8;
			temp1.y = 480;

			if ( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name );
			temp2.alignX = "left";
			temp2.horzAlign = "center";
			temp2.x = 8;
			temp2.y = 480;

			if ( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;

			temp1 thread delayDestroy( level.credits_speed );
			temp1 moveOverTime( level.credits_speed );
			temp1.y = level.credits_spacing;

			temp2 thread delayDestroy( level.credits_speed );
			temp2 moveOverTime( level.credits_speed );
			temp2.y = level.credits_spacing;
			
			//temp1 thread pulse_fx();
			//temp2 thread pulse_fx();
		}
		else if ( type == "centertriple" )
		{
			name1 = level.linelist[ i ].name1;
			name2 = level.linelist[ i ].name2;
			name3 = level.linelist[ i ].name3;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( name1 );
			temp1.alignX = "center";
			temp1.horzAlign = "center";
			temp1.x = -160;
			temp1.y = 480;

			if ( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name2 );
			temp2.alignX = "center";
			temp2.horzAlign = "center";
			temp2.x = 0;
			temp2.y = 480;

			if ( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;

			temp3 = newHudElem();
			temp3 setText( name3 );
			temp3.alignX = "center";
			temp3.horzAlign = "center";
			temp3.x = 160;
			temp3.y = 480;

			if ( !level.console )
				temp3.font = "default";
			else
				temp3.font = "small";

			temp3.fontScale = textscale;
			temp3.sort = 2;
			temp3.glowColor = ( 0.3, 0.6, 0.3 );
			temp3.glowAlpha = 1;

			temp1 thread delayDestroy( level.credits_speed );
			temp1 moveOverTime( level.credits_speed );
			temp1.y = level.credits_spacing;

			temp2 thread delayDestroy( level.credits_speed );
			temp2 moveOverTime( level.credits_speed );
			temp2.y = level.credits_spacing;

			temp3 thread delayDestroy( level.credits_speed );
			temp3 moveOverTime( level.credits_speed );
			temp3.y = level.credits_spacing;
			
			//temp1 thread pulse_fx();
			//temp2 thread pulse_fx();
			//temp3 thread pulse_fx();			
		}
		else if ( type == "centername" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "center";
			temp.x = 8;
			temp.y = 480;

			if ( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( level.credits_speed );
			temp moveOverTime( level.credits_speed );
			temp.y = level.credits_spacing;
			
			//temp thread pulse_fx();
		}
		else if ( type == "centernamedouble" )
		{
			name1 = level.linelist[ i ].name1;
			name2 = level.linelist[ i ].name2;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( name1 );
			temp1.alignX = "center";
			temp1.horzAlign = "center";
			temp1.x = -80;
			temp1.y = 480;

			if ( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name2 );
			temp2.alignX = "center";
			temp2.horzAlign = "center";
			temp2.x = 80;
			temp2.y = 480;

			if ( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;

			temp1 thread delayDestroy( level.credits_speed );
			temp1 moveOverTime( level.credits_speed );
			temp1.y = level.credits_spacing;

			temp2 thread delayDestroy( level.credits_speed );
			temp2 moveOverTime( level.credits_speed );
			temp2.y = level.credits_spacing;
			
			//temp1 thread pulse_fx();
			//temp2 thread pulse_fx();
		}
		else if ( MW3Formatting( type, i ) )
		{
		}
		else if ( type == "spacesmall" )
			delay = 0.1875;// 0.15
		else
			assert( type == "space" );

		//wait 0.65;
		wait delay * ( level.credits_speed/ 22.5 );
	}

}

MW3CreditHUDElem( textscale, brightness )
{
	if (!isdefined(brightness))
		brightness = 1;
	temp1 = newHudElem();
	if ( !level.console )
		temp1.font = "default";
	else
		temp1.font = "small";

	temp1.fontScale = textscale;
	temp1.sort = 2;
	temp1.glowColor = ( 0.3, 0.6, 0.3 );
	temp1.glowAlpha = 1;
	temp1.color = ( brightness, brightness, brightness );
	return temp1;
}

MW3CreditHUDThreads()
{
	self thread delayDestroy( level.credits_speed );
	self moveOverTime( level.credits_speed );
	self.y = level.credits_spacing;
//	self thread pulse_fx();
}

ApplyFormatType( format )
{
	if (!isdefined(format))
		return;
	else if (format == "subtitle")
	{
		self.color = (1.0, 1.0, 1.0);
		self.glowColor = ( 0.2, 0.4, 0.2 );
		self.glowAlpha = 1;
	}
}

MW3Formatting( type, i )
{
	
	leftx =  60;
	rightx = -60;
	centerx = 0;
	basey = 480;
	if ( type == "credit3f" )
	{
		credit3x = [60, 0, -60];
		credit3alignX = ["left", "center", "right"];
		credit3horizAlign = ["left", "center", "right"];
		s = level.linelist[ i ];
		textscale = s.textscale;
	
		for (i=0; i<3; i++)
		{
			if (isdefined(s.credits[i]))
			{
				temp1 = MW3CreditHUDElem( textscale, 0.8 );
				temp1 setText( s.credits[i] );
				temp1.alignX = credit3alignX[i];
				temp1.horzAlign = credit3horizAlign[i];
				temp1.x = credit3x[i];
				temp1.y = basey;
				temp1.glowColor = ( 0.0, 0.0, 0.0 );
				temp1.glowAlpha = 0;
				temp1 ApplyFormatType( s.formats[i] );
				temp1 thread MW3CreditHUDThreads();
			}
		}
		return true;
	}
	else if ( type == "credit3" )
	{
		credit3x = [60, 0, -60];
		credit3alignX = ["left", "center", "right"];
		credit3horizAlign = ["left", "center", "right"];
		s = level.linelist[ i ];
		textscale = s.textscale;
	
		for (i=0; i<3; i++)
		{
			if (isdefined(s.credits[i]))
			{
				temp1 = MW3CreditHUDElem( textscale, 0.9 );
				temp1 setText( s.credits[i] );
				temp1.alignX = credit3alignX[i];
				temp1.horzAlign = credit3horizAlign[i];
				temp1.x = credit3x[i];
				temp1.y = basey;
				temp1.glowColor = ( 0.0, 0.0, 0.0 );
				temp1.glowAlpha = 0;
				temp1 thread MW3CreditHUDThreads();
			}
		}
		return true;
	}
	else if ( type == "credit4" )
	{
		credit4x = [20, 220, -220, -20];
		credit4alignX = ["left", "left", "right", "right"];
		credit4horizAlign = ["left", "left", "right", "right"];
		s = level.linelist[ i ];
		textscale = s.textscale;
	
		for (i=0; i<4; i++)
		{
			if (isdefined(s.credits[i]))
			{
				temp1 = MW3CreditHUDElem( textscale, 0.9 );
				temp1 setText( s.credits[i] );
				temp1.alignX = credit4alignX[i];
				temp1.horzAlign = credit4horizAlign[i];
				temp1.x = credit4x[i];
				temp1.y = basey;
				temp1.glowColor = ( 0.0, 0.0, 0.0 );
				temp1.glowAlpha = 0;
				temp1 thread MW3CreditHUDThreads();
			}
		}
		return true;
	}
	else if ( type == "creditlr" )
	{
		creditl = level.linelist[ i ].left;
		creditr = level.linelist[ i ].right;
		textscale = level.linelist[ i ].textscale;
		
		temp1 = MW3CreditHUDElem( textscale, 0.9 );
		temp1 setText( creditl );
		temp1.alignX = "left";
		temp1.horzAlign = "left";
		temp1.x = leftx;
		temp1.y = basey;

		temp2 = MW3CreditHUDElem( textscale, 0.9 );
		temp2 setText( creditr );
		temp2.alignX = "right";
		temp2.horzAlign = "right";
		temp2.x = rightx;
		temp2.y = basey;

		temp1 thread MW3CreditHUDThreads();
		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "creditl" )
	{
		creditl = level.linelist[ i ].left;
		textscale = level.linelist[ i ].textscale;
		
		temp1 = MW3CreditHUDElem( textscale, 0.9 );
		temp1 setText( creditl );
		temp1.alignX = "left";
		temp1.horzAlign = "left";
		temp1.x = leftx;
		temp1.y = basey;

		temp1 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "creditr" )
	{
		creditr = level.linelist[ i ].right;
		textscale = level.linelist[ i ].textscale;
		
		temp2 = MW3CreditHUDElem( textscale, 0.9 );
		temp2 setText( creditr );
		temp2.alignX = "right";
		temp2.horzAlign = "right";
		temp2.x = rightx;
		temp2.y = basey;

		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "subheaderlr" )
	{
		creditl = level.linelist[ i ].left;
		creditr = level.linelist[ i ].right;
		textscale = level.linelist[ i ].textscale;
		
		temp1 = MW3CreditHUDElem( textscale );
		temp1 setText( creditl );
		temp1.alignX = "left";
		temp1.horzAlign = "left";
		temp1.x = leftx;
		temp1.y = basey;
		temp1.glowColor = ( 0.45, 0.9, 0.45 );

		temp2 = MW3CreditHUDElem( textscale );
		temp2 setText( creditr );
		temp2.alignX = "right";
		temp2.horzAlign = "right";
		temp2.x = rightx;
		temp2.y = basey;
		temp2.glowColor = ( 0.45, 0.9, 0.45 );

		temp1 thread MW3CreditHUDThreads();
		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "subheaderl" )
	{
		creditl = level.linelist[ i ].left;
		textscale = level.linelist[ i ].textscale;
		
		temp1 = MW3CreditHUDElem( textscale );
		temp1 setText( creditl );
		temp1.alignX = "left";
		temp1.horzAlign = "left";
		temp1.x = leftx;
		temp1.y = basey;
		temp1.glowColor = ( 0.45, 0.9, 0.45 );

		temp1 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "subheaderr" )
	{
		creditr = level.linelist[ i ].right;
		textscale = level.linelist[ i ].textscale;
		
		temp2 = MW3CreditHUDElem( textscale );
		temp2 setText( creditr );
		temp2.alignX = "right";
		temp2.horzAlign = "right";
		temp2.x = rightx;
		temp2.y = basey;
		temp2.glowColor = ( 0.45, 0.9, 0.45 );

		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "headerlr" )
	{
		creditl = level.linelist[ i ].left;
		creditr = level.linelist[ i ].right;
		textscale = level.linelist[ i ].textscale;
		
		temp1 = MW3CreditHUDElem( textscale );
		temp1 setText( creditl );
		temp1.alignX = "left";
		temp1.horzAlign = "left";
		temp1.x = leftx;
		temp1.y = basey;
		temp1.glowColor = ( 0.6, 0.9, 0.6 );

		temp2 = MW3CreditHUDElem( textscale );
		temp2 setText( creditr );
		temp2.alignX = "right";
		temp2.horzAlign = "right";
		temp2.x = rightx;
		temp2.y = basey;
		temp2.glowColor = ( 0.6, 0.9, 0.6 );

		temp1 thread MW3CreditHUDThreads();
		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "centered" )
	{
		text = level.linelist[ i ].centered;
		textscale = level.linelist[ i ].textscale;
		
		temp2 = MW3CreditHUDElem( textscale );
		temp2 setText( text );
		temp2.alignX = "center";
		temp2.horzAlign = "center";
		temp2.x = centerx;
		temp2.y = basey;
		temp2.glowColor = ( 0.0, 0.0, 0.0 );
		temp2.glowAlpha = 0;

		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "subtitlec" )
	{
		creditr = level.linelist[ i ].subtitle;
		textscale = level.linelist[ i ].textscale;
		
		temp2 = MW3CreditHUDElem( textscale );
		temp2 setText( creditr );
		temp2.alignX = "center";
		temp2.horzAlign = "center";
		temp2.x = centerx;
		temp2.y = basey;
		temp2.glowColor = ( 0.45, 0.9, 0.45 );

		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "titlec" )
	{
		creditr = level.linelist[ i ].title;
		textscale = level.linelist[ i ].textscale;
		
		temp2 = MW3CreditHUDElem( textscale );
		temp2 setText( creditr );
		temp2.alignX = "center";
		temp2.horzAlign = "center";
		temp2.x = centerx;
		temp2.y = basey;
		temp2.glowColor = ( 0.6, 0.9, 0.6 );

		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "creditlshr" )
	{
		creditl = level.linelist[ i ].left;
		subheaderr = level.linelist[ i ].right;
		textscale = level.linelist[ i ].textscale;
		
		temp1 = MW3CreditHUDElem( textscale );
		temp1 setText( creditl );
		temp1.alignX = "left";
		temp1.horzAlign = "left";
		temp1.x = leftx;
		temp1.y = basey;

		temp2 = MW3CreditHUDElem( textscale );
		temp2 setText( subheaderr );
		temp2.alignX = "right";
		temp2.horzAlign = "right";
		temp2.x = rightx;
		temp2.y = basey;
		temp2.glowColor = ( 0.45, 0.9, 0.45 );

		temp1 thread MW3CreditHUDThreads();
		temp2 thread MW3CreditHUDThreads();
		return true;
	}
	else if ( type == "entry" )
	{
		loc1 = level.linelist[ i ].loc1;
		format1 = level.linelist[ i ].format1;
		loc2 = level.linelist[ i ].loc2;
		format2 = level.linelist[ i ].format2;
		textscale = level.linelist[ i ].textscale;
		
		if (isdefined(loc1))
		{
			temp1 = MW3CreditHUDElem( textscale );
			temp1 setText( loc1 );
			ApplyFormat( temp1, format1, "left", leftx, basey );
			temp1 thread MW3CreditHUDThreads();
		}
		if (isdefined(loc2))
		{
			temp2 = MW3CreditHUDElem( textscale );
			temp2 setText( loc2 );
			ApplyFormat( temp2, format2, "right", rightx, basey );
			temp2 thread MW3CreditHUDThreads();
		}
		return true;
	}

	return false;
}

ApplyFormat( temp, format, textscale, side, x, basey )
{
	centerx = 0;
	credit_brightness = 0.9;
	
	temp.alignX = side;
	temp.horzAlign = side;
	temp.x = x;
	temp.y = basey;
	switch( format )
	{
		case "title":
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = centerx;
			temp.y = basey;
			temp.glowColor = ( 0.6, 0.9, 0.6 );
			temp.fontscale = 1.5*textscale;
			break;
		case "subtitle":
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = centerx;
			temp.y = basey;
			temp.glowColor = ( 0.45, 0.9, 0.45 );
			temp.fontscale = 1.25*textscale;
			break;
		case "header":
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = centerx;
			temp.y = basey;
			temp.glowColor = ( 0.45, 0.9, 0.45 );
			temp.fontscale = 1.2*textscale;
			break;
		case "subheader":
			temp.glowColor = ( 0.45, 0.9, 0.45 );
			break;
		case "credit":
			temp.color = ( credit_brightness, credit_brightness, credit_brightness );
			break;
		default:
			assert(0);	// unhandled format
			break;
	}
}

delayDestroy( duration )
{
	wait duration-2;
	self destroy();
}

pulse_fx()
{
	self.alpha = 0;
	wait level.credits_speed * .08;
	
	self FadeOverTime( 0.2 );
	self.alpha = 1;
	self SetPulseFX( 50, int( level.credits_speed * .6 * 1000 ), 500 );	
}

addSubLeftTitleNameSpace( title, name )
{
	addSubLeftTitle( title );
	addSpaceSmall();
	addSubLeftName( name );
	addSpace();
}

addLeftTitleNameSpace( title, name )
{
	addLeftTitle( title );
	addSpaceSmall();
	addLeftName( name );
	addSpace();
}

addLeftTitleName( title, name )
{
	addLeftTitle( title );
	addSpaceSmall();
	addLeftName( name );
}
	
addSubLeftTitleName( title, name )
{
	addSubLeftTitle( title );
	addSpaceSmall();
	addSubLeftName( name );
}	

addLeftNameName( name1, name2 )
{
	addLeftName( name1 );
	addLeftName( name2 );
}

addSubLeftNameName( name1, name2 )
{
	addSubLeftName( name1 );
	addSubLeftName( name2 );
}

addSubLeftNameNameName( name1, name2, name3 )
{
	addSubLeftName( name1 );
	addSubLeftName( name2 );
	addSubLeftName( name3 );
}

addImageIW( image, width, height, delay )
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
		addLeftImage( image, width, height, delay );
	else
		addCenterImage( image, width, height, delay );
}

addTitleIW( title )
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
		addLeftTitle( title );
	else
		addCenterHeading( title );
}

addSubTitleIW( title )
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
		addSubLeftTitle( title );
	else
		addCenterHeading( title );
}

addTitleNameIW( title, name )
{	
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
	{
		addLeftTitle( title );
		addSpaceSmall();
		addLeftName( name );
	}
	else
		addCenterDual( title, name );
}

addSubTitleNameIW( title, name )
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
	{
		addSubLeftTitle( title );
		addSpaceSmall();
		addSubLeftName( name );
	}
	else
		addCenterDual( title, name );
}

addcastIW( name, title, combo )
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
		addCastName( name, title );
	else
		addCenterHeading( name );
}

addNameIW( name )
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
		addLeftName( name );
	else
		addCenterName( name );
}

addSubNameIW( name )
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
		addSubLeftName( name );
	else
		addCenterName( name );
}

addSpaceTitle()
{
	if ( getdvar( "ui_char_museum_mode" ) != "credits_black" )
		addSpace();
	else	
		addSpaceSmall();
}

addGap()
{
	addSpace();
	addSpace();
}


initActivisionCredits()
{
	initATVICredits_atvi();
	initATVICredits_pr();
	initATVICredits_europe();
	initATVICredits_central_tech();
	initATVICredits_blade();
	initATVICredits_demonware();
	initATVICredits_global();
	initATVICredits_business();
	initATVICredits_qa1();
	initATVICredits_qa2();
	initATVICredits_qa3();
	initATVICredits_qa4();
	initATVICredits_end();
}

initATVICredits_atvi()
{
	addCenterImage( "logo_activision", 256, 128, 3.875 );// 3.1
	addSpace();
	addSpace();
			
	// Production
	addCenterHeading( &"CREDIT_PRODUCTION" );
	addSpaceSmall();
	// Producer
	// CHRIS WILLIAMS
	addCenterDual( &"CREDIT_PRODUCER", &"CREDIT_CHRIS_WILLIAMS" );
	addSpaceSmall();
	// Associate Producers
	// VINCENT FENNEL
	addCenterDual( &"CREDIT_ASSOCIATE_PRODUCERS", &"CREDIT_VINCENT_FENNEL" );
	// TAYLOR LIVINGSTON
	addCenterName( &"CREDIT_TAYLOR_LIVINGSTON" );
	// DEREK RACCA
	addCenterName( &"CREDIT_DEREK_RACCA" );
	addSpaceSmall();
	// Production Coordinator
	// ADRIENNE ARRASMITH
	addCenterDual( &"CREDIT_PRODUCTION_COORDINAT", &"CREDIT_ADRIENNE_ARRASMITH" );
	addSpaceSmall();
	
	// Additional Production
	//RHETT CHASSEREAU
	addCenterDual( &"CREDIT_ADDITIONAL_PRODUCTIO", &"CREDIT_RHETT_CHASSEREAU");
	addSpaceSmall();
	// Senior Executive Producer
	// MARCUS IREMONGER
	addCenterDual( &"CREDIT_SENIOR_EXECUTIVE_PRO", &"CREDIT_MARCUS_IREMONGER" );
	addSpaceSmall();
	// Vice President, Production
	// STEVE ACKRICH
	addCenterDual( &"CREDIT_HEAD_OF_PRODUCTION", &"CREDIT_STEVE_ACKRICH" );
	addGap();
}
	
initATVICredits_pr()
{		
	// Public Relations
	addCenterHeading( &"CREDIT_PUBLIC_RELATIONS" );
	addSpaceSmall();
	// Director, Owned Properties
	// MIKE MANTARRO
	addCenterDual( &"CREDIT_DIRECTOR_OWNED_PROPE", &"CREDIT_MIKE_MANTARRO" );
	addSpaceSmall();
	// PR Manager	
	// JOHN RAFACZ
	addCenterDual( &"CREDIT_PR_MANAGER", &"CREDIT_JOHN_RAFACZ" );
	addSpaceSmall();
	// Junior Publicist
	// MONICA PONTRELLI
	addCenterDual( &"CREDIT_JUNIOR_PUBLICIST", &"CREDIT_MONICA_PONTRELLI" );
	// JOSHUA SELINGER
	addCenterName( &"CREDIT_JOSHUA_SELINGER");
	addSpaceSmall();
	//European PR Director
	// NICK GRANGE
	addCenterDual( &"CREDIT_EUROPEAN_PR_DIRECTOR", &"CREDIT_NICK_GRANGE");

	addGap();
}

initATVICredits_europe()
{		
	// Production Services - Europe
	addCenterHeading( &"CREDIT_PRODUCTION_SERVICES_");
	addSpaceSmall();
	// Senior Director of Production Services - Europe
	// BARRY KEHOE
	addCenterDual( &"CREDIT_SENIOR_DIRECTOR_OF_P", &"CREDIT_BARRY_KEHOE" );
	addSpaceSmall();
	// Localization Manager
	// FIONA EBBS
	addCenterDual( &"CREDIT_LOCALISATION_MANAGER", &"CREDIT_FIONA_EBBS" );		
	addSpaceSmall();
	// Senior Localization Project Manager
	// ANNETTE LEE
	addCenterDual( &"CREDIT_SENIOR_LOCALIZATION_", &"CREDIT_ANNETTE_LEE" );				
	addSpaceSmall();
	// Localization Project Manager
	// JACK O'HARA
	addCenterDual( &"CREDIT_LOCALISATION_PROJECT", &"CREDIT_JACK_OHARA" );		
	addSpaceSmall();			
	// Localization QA Manager
	// DAVID HICKEY
	addCenterDual( &"CREDIT_LOCALISATION_QA_MANA", &"CREDIT_DAVID_HICKEY" );			
	addSpaceSmall();
	
	// Localization Assistant QA Manager
	// YVONNE COSTELLO		
	addCenterDual( &"CREDIT_LOCALISATION_ASSISTA", &"CREDIT_YVONNE_COSTELLO" );		
	addGap();
	
	
	//Localization QA Testers
	addCenterHeading( &"CREDIT_LOCALIZATION_QA_TEST");	
	addSpaceSmall();			
	// LUIS HERNANDEZ DALMAU 
	// VINCENZO FERRARA
	addCenterNameDouble( &"CREDIT_LUIS_HERNANDEZ_DALMA", &"CREDIT_VINCENZO_FERRARA_" );	
	// LARA SOLA GALLEGO
	// JEREMY LEVI		
	addCenterNameDouble( &"CREDIT_LARA_SOLA_GALLEGO", &"CREDIT_JEREMY_LEVI_" );		
	// SEBASTIEN MAZZERBO 
	// DARIO MILONE		
	addCenterNameDouble( &"CREDIT_SEBASTIEN_MAZZERBO_", &"CREDIT_DARIO_MILONE_" );	
	// KERILL MEIER O’BRIEN
	// MARCELL WITEK			
	addCenterNameDouble( &"CREDIT_KERILL_MEIER_OBRIEN", &"CREDIT_MARCELL_WITEK_" );				
	addSpace();
	
	//IT Network Technician
	// FERGUS LINDSAY 
	addCenterDual( &"CREDIT_IT_NETWORK_TECHNICIA", &"CREDIT_FERGUS_LINDSAY_" );	
	addGap();
	
	
	// LOCALIZATION TOOLS & SUPPORT PROVIDED BY STEPHANIE DEMING & XLOC INC.
	addCenterHeading( &"CREDIT_LOCALIZATION_TOOLS_");				
	addGap();
}

initATVICredits_central_tech()
{
	// Central Technology					
	addCenterHeading( &"CREDIT_CENTRAL_TECHNOLOGY");
	addSpaceSmall();

	// VP Art Production
	// ALESSANDRO TENTO
	addCenterDual( &"CREDIT_VP_ART_PRODUCTION", &"CREDIT_ALESSANDRO_TENTO_");
	addSpace();	
	
	addCenterHeading( &"CREDIT_ENGINEERING" );
	addSpaceSmall();
	// VP of Online
	// JOHN BOJORQUEZ
	addCenterDual( &"CREDIT_VP_OF_ONLINE_", &"CREDIT_JOHN_BOJORQUEZ");		
	addSpaceSmall();	
	// Managing Director, Demonware
	// PAT GRIFFITH
	addCenterDual( &"CREDIT_MANAGING_DIRECTOR_DE", &"CREDIT_PAT_GRIFFITH_");	
	addSpaceSmall();
	// Technical Director
	// WADE BRAINERD
	addCenterDual( &"CREDIT_TECHNICAL_DIRECTOR", &"CREDIT_WADE_BRAINERD_");
	addSpace();
	
	// Studio Central - Outsourcing	
	addCenterHeading( &"CREDIT_STUDIO_CENTRAL_OUT");				
	addSpaceSmall();	
	// Director Art Production
	// RICCARD LINDE
	addCenterDual( &"CREDIT_DIRECTOR_ART_PRODUCT", &"CREDIT_RICCARD_LINDE");	
	addSpaceSmall();
			
	// BERNARDO ANTONIAZZI
	addCenterDual( &"CREDIT_TECHNICAL_ART_DIRECT", &"CREDIT_BERNARDO_ANTONIAZZI");	
	addCenterName( &"CREDIT_MITCH_BOWLER");	
	addSpaceSmall();
	
	// Production Manager
	// Michael Restifo
	addCenterDual( &"CREDIT_PRODUCTION_MANAGER", &"CREDIT_MICHAEL_RESTIFO");				
	addSpaceSmall();
	// CHRISTOPHER CODDING	
	addCenterDual( &"CREDIT_PRODUCTION_COORDINAT", &"CREDIT_CHRISTOPHER_CODDING");				
	addGap();
}

initATVICredits_blade()
{
	// Blade Games World, Inc.
	addCenterDual( &"CREDIT_ADDITIONAL_ART", &"CREDIT_BLADE_GAMES_WORLD_IN" );	
	addGap();
}		

initATVICredits_demonware()
{
	// Demonware
	addCenterHeading( &"CREDIT_DEMONWARE");	
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_MICHAEL_COLLINS", &"CREDIT_PAUL_FROESE");	
	addCenterNameDouble( &"CREDIT_JOHN_KIRK", &"CREDIT_EMMANUEL_STONE");
	addCenterNameDouble( &"CREDIT_JASON_WEI", "");
	addGap();
}

initATVICredits_global()
{		
	// GLOBAL BRAND MANAGEMENT
	addCenterHeading( &"CREDIT_GLOBAL_BRAND_MANAGEM");
	addSpaceSmall();
	// DIRECTOR OF MARKETING
	// ROB KOSTICH
	addCenterDual( &"CREDIT_VICE_PRESIDENT_OF_MA", &"CREDIT_ROB_KOSTICH");		
	addSpaceSmall();
	// DIRECTOR OF MARKETING
	// BYRON BEEDE
	addCenterDual( &"CREDIT_DIRECTOR_OF_MARKETIN", &"CREDIT_BYRON_BEEDE");	
	addSpaceSmall();
	// GLOBAL BRAND MANAGER
	// GEOFF_CARROLL	
	addCenterDual( &"CREDIT_GLOBAL_BRAND_MANAGER", &"CREDIT_GEOFF_CARROLL");			
	addSpaceSmall();
	// ASSOCIATE BRAND MANAGERS
	// JOE KORSMO
	addCenterDual( &"CREDIT_ASSOCIATE_BRAND_MANA", &"CREDIT_JOE_KORSMO");	
	// MIKE SCHAEFER
	addCenterName( &"CREDIT_MIKE_SCHAEFER");	
	// DAVID WANG		
	addCenterName( &"CREDIT_DAVID_WANG");		
	addGap();
	
	
	// Art Services
	addCenterHeading( &"CREDIT_ART_SERVICES");	
	addSpaceSmall();
	// Art Services Lead
	// Chris Reinhart
	addCenterDual( &"CREDIT_ART_SERVICES_LEAD", &"CREDIT_CHRIS_REINHART");					
	addGap();	
}

initATVICredits_business()
{
	// Business and Legal Affairs		
	addCenterHeading( &"CREDIT_BUSINESS_AND_LEGAL_A");
	addSpaceSmall();
	// GREG DEUTSCH
	// JANE ELMS			
	addCenterNameDouble( &"CREDIT_GREG_DEUTSCH", &"CREDIT_JANE_ELMS");	
	// KAP KANG
	// KATE OGOSTA					
	addCenterNameDouble( &"CREDIT_KATE_OGOSTA_", &"CREDIT_AMANDA_OKEEFE");	
	// AMANDA O'KEEFE			
	// TRAVIS STANSBURY
	addCenterNameDouble( &"CREDIT_TRAVIS_STANSBURY", &"CREDIT_PHIL_TERZIAN");				
	// PHIL TERZIAN
	//MARY TUCK
	addCenterNameDouble( &"CREDIT_MARY_TUCK", "");		
	addGap();
		
		
	// Talent and Audio Management Group
	addCenterHeading( &"CREDIT_TALENT_AND_AUDIO_MAN");
	addSpaceSmall();
	// Talent Acquisition Manager
	// MARCHELE HARDIN
	addCenterDual( &"CREDIT_TALENT_ACQUISITION_M", &"CREDIT_MARCHELE_HARDIN");	
	addSpaceSmall();
	// Talent Associate
	// NOAH SARID
	addCenterDual( &"CREDIT_TALENT_ASSOCIATE", &"CREDIT_NOAH_SARID");					
	addSpaceSmall();
	// Talent Coordinator
	// STEFANI JONES
	addCenterDual( &"CREDIT_TALENT_COORDINATOR", &"CREDIT_STEFANI_JONES");								
	addGap();	
	
	
	addCenterHeading( &"CREDIT_FINANCE");
	addSpaceSmall();
	// VP of Studio Finance and Royalties
	// RAJ SAIN
	addCenterDual( &"CREDIT_VP_OF_STUDIO_FINANCE", &"CREDIT_RAJ_SAIN");	
	addSpaceSmall();
	// Finance Manager
	// CLINTON ALLEN
	addCenterDual( &"CREDIT_FINANCE_MANAGER", &"CREDIT_CLINTON_ALLEN");	
	addCenterName( &"CREDIT_HARJINDER_SINGH");
	addSpaceSmall();	
	// Sr. Financial Analyst
	// JASON JORDAN
	addCenterDual( &"CREDIT_SR_FINANCIAL_ANALYST", &"CREDIT_JASON_JORDAN");								
	addSpaceSmall();	
	// Finance Analyst
	// ADRIAN GOMEZ	
	addCenterDual( &"CREDIT_FINANCE_ANALYST", &"CREDIT_ADRIAN_GOMEZ");	
//	addCenterName( &"CREDIT_JASON_JORDAN");		
	addCenterName( &"CREDIT_FRANSISCA_TAN");		
	addGap();
	
		
	// Activision Special Thanks
	addCenterHeading( &"CREDIT_ACTIVISION_SPECIAL_T");	
	addSpaceSmall();
	addCenterHeading( &"CREDIT_MIKE_GRIFFITH_BRIAN_");		
	addGap();
}	
	
initATVICredits_qa1()
{		
	addCenterHeading( &"CREDIT_QUALITY_ASSURANCE_ATVI");	
	addSpaceSmall();
	// VP Quality Assurance/Customer Service
	// PAUL STERNGOLD
	addCenterDual( &"CREDIT_VP_QUALITY_ASSURANCE", &"CREDIT_PAUL_STERNGOLD");
	addSpace();
	
	// QA Project Lead
	//	Sean Berrett	
	addCenterDual( &"CREDIT_QUALITY_ASSURANCE_LEAD_ATVI", &"CREDIT_SEAN_BERRETT");	
	addSpaceSmall();
	// QA Floor Lead
	// Jay Menconi
	addCenterDual( &"CREDIT_QA_FLOOR_LEAD", &"CREDIT_JAY_MENCONI");		
	addSpaceSmall();	
	addCenterDual( &"CREDIT_QA_SENIOR_PROJECT_LE", &"CREDIT_HENRY_P_VILLANUEVA");	
	addSpaceSmall();
	addCenterDual( &"CREDIT_QA_MANAGER", &"CREDIT_GLENN_VISTANTE");	
	addSpaceSmall();		
	// Project Lead
	addCenterDual( &"CREDIT_PROJECT_LEAD", &"CREDIT_ERIK_MELEN_");	
	addSpace();
	
	// QA Testers
	addCenterHeading( &"CREDIT_QA_TESTERS");	
	addSpaceSmall();	
	addCenterTriple( &"CREDIT_CHAD_SCHMIDT_", &"CREDIT_ADAM_SMITH_", &"CREDIT_DAVION_FARRIS_");						
	addCenterTriple( &"CREDIT_JOHN_GOLDSWORTHY_", &"CREDIT_NATE_KINNEY_", &"CREDIT_RYAN_TRONDSEN_");
	addCenterTriple( &"CREDIT_TARIKH_BROWN_", &"CREDIT_PETE_ROMULO_PEDROZ", &"CREDIT_CHARLES_DAVIS_");	
	addCenterTriple( &"CREDIT_GABE_NOTO_", &"CREDIT_ULYSSES_HOLGUIN_", &"CREDIT_JOHN_ESTIOKO_");				
	addCenterTriple( &"CREDIT_XIAOHU_ALCOCER_", &"CREDIT_KEVIN_CHESTER_", &"CREDIT_DANIEL_HERSCHER_");
	addCenterTriple( &"CREDIT_LEVETT_WASHINGTON_", &"CREDIT_BRIAN_BAKER", &"CREDIT_MARK_RUZICKA");
	addCenterTriple( &"CREDIT_MATT_WELLMAN_", &"CREDIT_ANTHONY_MORENO_", &"CREDIT_CORY_FURLOW_");
	addCenterTriple( &"CREDIT_BRIAN_POST_", &"CREDIT_ANDREW_GRASS_", &"CREDIT_QUENTIN_TREMAYNE_C");
	addCenterTriple( &"CREDIT_ANDREW_GULOTTA_", &"CREDIT_RICH_BERNOT_", &"CREDIT_TABARI_JEFFRIES_");
	addCenterTriple( &"CREDIT_MICHAEL_MONTOYA_", &"CREDIT_CRAIG_NELSON_", &"CREDIT_BRANDON_ARONSON_");
	addCenterTriple( &"CREDIT_GREG_SANDS_", &"CREDIT_CARLOS_MORAN_", &"CREDIT_SEAN_MOLINE_");
	addCenterTriple( &"CREDIT_LOU_STUDDERT_", &"CREDIT_ROBERT_CHAPLAN_", &"CREDIT_JOSE_VEGA_");
	addCenterTriple( &"CREDIT_MIKE_ARDEN_", &"CREDIT_JOE_CHAVEZ_", &"CREDIT_BRADON_MILLER_");
	addGap();	
}

initATVICredits_qa2()
{				
	// Director, QA
	// CHRISTOPHER WILSON
	addCenterDual( &"CREDIT_DIRECTOR_QA", &"CREDIT_CHRISTOPHER_WILSON");		
	addSpaceSmall();
	// QA CRG Project Lead
	// MATT RYAN
	addCenterDual( &"CREDIT_QA_CRG_PROJECT_LEAD", &"CREDIT_MATT_RYAN");		
	addSpaceSmall();
	// QA CRG Floor Lead
	// JONATHAN MACK
	addCenterDual( &"CREDIT_QA_CRGFLOOR_LEAD", &"CREDIT_JONATHAN_MACK");		
	addSpaceSmall();
	// QA CRG Testers
	// CHRISTIAN VASCO
	addCenterDual( &"CREDIT_QA_CRG_TESTERS", &"CREDIT_CHRISTIAN_VASCO");		
	addSpace();
	
	// QA Network Lab
	addCenterHeading( &"CREDIT_QA_NETWORK_LAB");		
	addSpaceSmall();
	// Manager, QA Operations
	// CHRIS KEIM
	addCenterDual( &"CREDIT_MANAGER_QA_OPERATION", &"CREDIT_CHRIS_KEIM");		
	addSpaceSmall();	
	// QA Network Lab Project Leads
	// JESSIE JONES
	// LEONARD RODRIGUEZ			
	addCenterDual( &"CREDIT_QA_NETWORK_LAB_PROJE", &"CREDIT_JESSIE_JONES");	
	addCenterName( &"CREDIT_LEONARD_RODRIGUEZ");			
	addSpaceSmall();
	// QA Network Lab Tester
	// BRYAN CHICE
	addCenterDual( &"CREDIT_QA_NETWORK_LAB_TESTE", &"CREDIT_BRYAN_CHICE");	
	addSpace();
			
	addCenterHeading( &"CREDIT_QA_COMPATABILITY_LAB");	
	addSpaceSmall();
	addCenterDual( &"CREDIT_QACL_LAB_PROJECT_LE", &"CREDIT_ROBERT_FENOGLIO");	
	addCenterName( &"CREDIT_FARID_KAZIMI");												
	addCenterName( &"CREDIT_AUSTIN_KIENZLE");		
	addSpaceSmall();	
	addCenterDual( &"CREDIT_QACL_LAB_TESTERS", &"CREDIT_ALBERT_LEE");	
	addCenterName( &"CREDIT_WILLIAM_WHALEY");	
	addSpace();
}		

initATVICredits_qa3()
{		
	//QA AUDIO VISUAL LAB
	addCenterHeading( &"CREDIT_QA_AV_LAB");	
	addSpaceSmall();
	
	//QA AV Lab Senior Project Lead
	//Victor Durling
	addCenterDual( &"CREDIT_QA_AV_LAB_SR_PR_LEAD", &"CREDIT_VICTOR_DURLING");	
	addSpaceSmall();
	
	//QA AV Lab Senior Tester
	//Cliff Hooper
	addCenterDual( &"CREDIT_QA_AV_LAB_SR_TESTER", &"CREDIT_CLIFF_HOOPER");	
	addSpaceSmall();
	
	
	//QA AV Lab Testers
	//Delven Rutledge
	//Ryan Visteen
	addCenterDual( &"CREDIT_QA_AV_LAB_TESTERS", &"CREDIT_DELVEN_RUTLEDGE");
	addCenterName( &"CREDIT_RYAN_VISTEEN");			
	addSpace();

	// QA Mastering Lab
	addCenterHeading( &"CREDIT_QA_MASTERING_LAB");	
	addSpaceSmall();
			
	// Mastering Lab Supervisor
	// JOHN DONNELLY
	addCenterDual( &"CREDIT_MASTERING_LAB_SUPERV", &"CREDIT_JOHN_DONNELLY");	
	addSpaceSmall();
	
	// Lead Mastering Lab Technician
	// SEAN KIM
	addCenterDual( &"CREDIT_LEAD_MASTERING_LAB_T", &"CREDIT_SEAN_KIM");	
	addSpaceSmall();
	
	// Senior Mastering Lab Technician
	// DANNY FENG			
	addCenterDual( &"CREDIT_SENIOR_MASTERING_LAB", &"CREDIT_DANNY_FENG_");								
	addSpace();
	
	// Mastering Lab Technicians
	addCenterHeading( &"CREDIT_MASTERING_LAB_TECHNI");	
	addSpaceSmall();		
	addCenterTriple( &"CREDIT_TYREE_DERAMUS", &"CREDIT_JOSE_HERNANDEZ", &"CREDIT_KAI_HSU");	
	addCenterTriple( &"CREDIT_RODRIGO_MAGANA", &"CREDIT_STEVEN_RODRIGUEZ", &"CREDIT_LEEJAY_RONQUILLO");
	addCenterTriple( &"CREDIT_ORBEL_SHAKHMALIAN", &"CREDIT_GARY_WASHINGTON", &"");
	addSpace();
}		

initATVICredits_qa4()
{
	// Customer Support
	addCenterHeading( &"CREDIT_CUSTOMER_SUPPORT");						
	addSpaceSmall();
	// Customer Support Managers
	// Gary Bolduc
	// Michael Hill
	addCenterDual( &"CREDIT_CUSTOMER_SUPPORT_MAN", &"CREDIT_GARY_BOLDUC");							
	addCenterName( &"CREDIT_MICHAEL_HILL");		
	addGap();	
}	

initATVICredits_end()
{
	// Manual designed by Ignited Minds, LLC
	addCenterDual( &"CREDIT_MANUAL_DESIGN", &"CREDIT_IGNITED_MINDS_LLC");	
	addGap();		
	
	
	// Packaging Design by Hamagami/Carroll, Inc.
	addCenterDual( &"CREDIT_PACKAGING_DESIGN_BY", &"CREDIT_RICHARD_KRIEGLER");	
	addCenterName( &"CREDIT_HAMAGAMI");												
	addGap();
	
	
	// Fonts licensed from Monotype 
	// T26
	addCenterDual( &"CREDIT_FONTS_LICENSED_FROM", &"CREDIT_MONOTYPE");					
	addCenterName( &"CREDIT_T26");		
	addGap();
	

	// Uses Bink Video. Copyright © 1997-2007 by RAD Game Tools, Inc.
	addCenterHeading( &"CREDIT_USES_BINK_VIDEO_COPYRIGHT" );
	addSpace();
		
	// Uses Miles Sound System. Copyright © 1991-2007 by RAD Game Tools, Inc.
	addCenterHeading( &"CREDIT_USES_MILES_SOUND_SYSTEM" );// PC and 360 only
	addGap();
	addGap();
	addGap();
	
	
	// The characters and events depicted in this game are fictitious.
	addCenterHeading( &"CREDIT_THE_CHARACTERS_AND_EVENTS1" );
	// Any similarity to actual persons, living or dead, is purely coincidental.
	addCenterHeading( &"CREDIT_THE_CHARACTERS_AND_EVENTS2" );

}

ReadNColumns( fname, row, start, num )
{
	data = [];
	for (i=0; i<num; i++)
		data[i] = TableLookupByRow( fname, row, start+i );
	return data;
}

ReadTriple( fname, row, start )
{
	data[0] = TableLookupByRow( fname, row, start );
	data[1] = TableLookupByRow( fname, row, start+1 );
	data[2] = TableLookupByRow( fname, row, start+2 );
	return data;
}

StringFix( str )
{
	if (issubstr(str,"&"))
	{
		str = GetSubStr(str,1);
		
		// clear out leading doublequotes
		test = GetSubStr(str,0,1);
		while (test == "\"")
		{
			str = GetSubStr(str,1);
			test = GetSubStr(str,0,1);
		}
		// clear out trailing doublequotes
		test = GetSubStr(str,str.size-1,str.size);
		while (test == "\"")
		{
			str = GetSubStr(str,1,str.size-1);
			test = GetSubStr(str,str.size-1,str.size);
		}
//		return IString(str);	// requires code changes
		return str;
	}
	else
		return str;
}

ReadCredits( fname )
{
	eof=false;
	for (row=0; !eof; row++)
	{
		type = TableLookupByRow( fname, row, 0 );
		switch( type )
		{
			case "gap":
				addGap();
				break;
			case "space":
				addSpace();
				break;
			case "spacesmall":
				addSpaceSmall();
				break;
			case "spacetitle":
				addSpaceTitle();
				break;
			case "heading":
				data = TableLookupByRow( fname, row, 1);
				addCenterHeading( StringFix(data) );
				break;
			case "name":
				data = ReadTriple( fname, row, 1 );
				if (data[0] != " ")
					addLeftName( StringFix(data[0]) );
				else if (data[1] != " ")
					addCenterName( StringFix(data[1]) );
				else
					addRightName( StringFix(data[2]) );
				break;
			case "centerdual":
				data[0] = TableLookupByRow( fname, row, 1);
				data[1] = TableLookupByRow( fname, row, 2 );
				addCenterDual( StringFix(data[0]), StringFix(data[1]) );
				break;
			case "centernamedouble":
				data[0] = TableLookupByRow( fname, row, 1);
				data[1] = TableLookupByRow( fname, row, 2 );
				addCenterNameDouble( StringFix(data[0]), StringFix(data[1]) );
				break;
			case "centertriple":
				data = ReadTriple( fname, row, 1);
				addCenterTriple( StringFix(data[0]), StringFix(data[1]), StringFix(data[2]) );
				break;
			case "imageiw":
				data = ReadNColumns( fname, row, 1, 4 );
				addImageIW( data[0], int(data[1]), int(data[2]), float(data[3]) );
				break;
			case "titlenameiw":
				data[0] = TableLookupByRow( fname, row, 1);
				data[1] = TableLookupByRow( fname, row, 2 );
				addTitleNameIW( StringFix(data[0]), StringFix(data[1]) );
				break;
			case "aubtitlenameiw":
				data[0] = TableLookupByRow( fname, row, 1);
				data[1] = TableLookupByRow( fname, row, 2 );
				addSubTitleNameIW( StringFix(data[0]), StringFix(data[1]) );
				break;
			case "nameiw":
				data[0] = TableLookupByRow( fname, row, 1);
				addNameIW( StringFix(data[0]) );
				break;
			case "titleiw":
				data[0] = TableLookupByRow( fname, row, 1);
				addTitleIW( StringFix(data[0]) );
				break;
			case "subtitleiw":
				data[0] = TableLookupByRow( fname, row, 1);
				addSubTitleIW( StringFix(data[0]) );
				break;
			case "subnameiw":
				data[0] = TableLookupByRow( fname, row, 1);
				addSubNameIW( StringFix(data[0]) );
				break;
			case "castiw":
				data = ReadTriple( fname, row, 1);
				addcastIW( StringFix(data[0]), StringFix(data[1]), StringFix(data[2]) );
				break;
			case "include":
				data = TableLookupByRow( fname, row, 1);
				ReadCredits( data );
				break;
			case "end":
				eof = true;
				break;
			default:
				break;
		}
	}
	
}

a_c( type, data0, data1, data2, data3 )
{
	switch( type )
	{
		case "gap":
			addGap();
			break;
		case "space":
			addSpace();
			break;
		case "spacesmall":
			addSpaceSmall();
			break;
		case "spacetitle":
			addSpaceTitle();
			break;
		case "heading":
			addCenterHeading( data0 );
			break;
		case "name":
			if (isdefined(data0))
				addLeftName( data0 );
			else if (isdefined(data1))
				addCenterName( data1 );
			else
				addRightName( data2 );
			break;
		case "centerdual":
			addCenterDual( data0, data1 );
			break;
		case "centernamedouble":
			addCenterNameDouble( data0, data1 );
			break;
		case "centertriple":
			addCenterTriple( data0, data1, data2 );
			break;
		case "imageiw":
			addImageIW( data0, int(data1), int(data2), float(data3) );
			break;
		case "titlenameiw":
			addTitleNameIW( data0, data1 );
			break;
		case "subtitlenameiw":
			addSubTitleNameIW( data0, data1 );
			break;
		case "nameiw":
			addNameIW( data0 );
			break;
		case "titleiw":
			addTitleIW( data0 );
			break;
		case "subtitleiw":
			addSubTitleIW( data0 );
			break;
		case "subnameiw":
			addSubNameIW( data0 );
			break;
		case "castiw":
			addcastIW( data0, data1, data2 );
			break;
		default:
			break;
	}
}
