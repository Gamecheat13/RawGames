#include maps\_hud_util;

/*
=============
///ScriptDocBegin
"Name: draw_point( origin, size, colr, time )"
"Summary: Draws a point at the specified origin of the specified size and color, and optionally for a time"
"CallOn: Nothing"
"MandatoryArg: <origin>: The position of the point"
"MandatoryArg: <size>: The size of the point"
"MandatoryArg: <colr>: The color of the point"
"OptionalArg: [time]: The time to draw the point"
"Example: draw_point( (0,5,3), 24, (1,1,1), 1.0 )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_point( origin, size, colr, time )
{
	/#
	force_run = false;
	if ( !IsDefined( time ) )
	{
		force_run = true;
		time = 0;
	}
	
	while ( force_run || time > 0 )
	{
		x = (size, 0, 0);
		line( origin - x, origin + x, colr );
		y = (0, size, 0);
		line( origin - y, origin + y, colr );
		z = (0, 0, size);
		line( origin - z, origin + z, colr );
	
		if ( !force_run )
		{
			wait 0.05;
		}
		
		time = time - 0.05;
		force_run = false;
	}
	#/
}

/*
=============
///ScriptDocBegin
"Name: draw_axis( origin, angles, time )"
"Summary: Draws an axis at the specified origin and orientation, and optionally for a time"
"CallOn: Nothing"
"MandatoryArg: <origin>: The position of the axis"
"MandatoryArg: <angles>: The orientation of the axis"
"OptionalArg: [time]: The time to draw the axis"
"Example: draw_axis( (0,5,3), (0,0,0), 1.0 )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_axis( origin, angles, time )
{
	/#
	force_run = false;
	if ( !IsDefined( time ) )
	{
		force_run = true;
		time = 0;
	}
	
	while ( force_run || time > 0 )
	{
		red = (1, 0, 0);
		grn = (0, 1, 0);
		blu = (0, 0, 1);
		axis =[];
		axis[0] = anglestoforward( angles );
		axis[1] = anglestoright( angles );
		axis[2] = anglestoup( angles );
		size = 16;
		line( origin, origin + (size * axis[0]), red );
		line( origin, origin + (size * axis[1]), grn );
		line( origin, origin + (size * axis[2]), blu );
	
		if ( !force_run )
		{
			wait 0.05;
		}
		
		time = time - 0.05;
		force_run = false;
	}
	#/
}

/*
=============
///ScriptDocBegin
"Name: draw_debug_sphere( ent, center, radius, colr )"
"Summary: Draws a sphere at the specified center of a given radius and color, and at an optional entity's angles"
"CallOn: Nothing"
"OptionalArg: [ent]: The orientation of the sphere"
"MandatoryArg: <center>: The center position of the sphere"
"MandatoryArg: <radius>: The radius of the sphere"
"MandatoryArg: <colr>: The color of the sphere"
"Example: draw_axis( (0,5,3), (0,0,0), 1.0 )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

draw_debug_sphere( ent, center, radius, colr )
{
	/#
	axis =[];
	if (isdefined(ent))
	{
		axis[0] = anglestoforward( ent.angles );
		axis[1] = anglestoright( ent.angles );
		axis[2] = anglestoup( ent.angles );
	}
	else
	{
		axis[0] = anglestoforward( (0,0,0) );
		axis[1] = anglestoright( (0,0,0) );
		axis[2] = anglestoup( (0,0,0) );
	}
	points =[];
	points[0] = center + (radius * axis[0]);
	points[1] = center - (radius * axis[0]);
	points[2] = center + (radius * axis[1]);
	points[3] = center - (radius * axis[1]);
	points[4] = center + (radius * axis[2]);
	points[5] = center - (radius * axis[2]);

	line( points[0], points[2], colr );
	line( points[0], points[3], colr );
	line( points[0], points[4], colr );
	line( points[0], points[5], colr );

	line( points[1], points[2], colr );
	line( points[1], points[3], colr );
	line( points[1], points[4], colr );
	line( points[1], points[5], colr );

	line( points[2], points[4], colr );
	line( points[4], points[3], colr );
	line( points[3], points[5], colr );
	line( points[5], points[2], colr );
	#/
}

/*
=============
///ScriptDocBegin
"Name: create_debug_text_hud( <name>, <x>, <y>, [color], [text], [fontsize] )"
"Summary: Creates a debug HUD element that can be used to display debug text"
"CallOn: Nothing"
"MandatoryArg: <name>: The name used for this element."
"MandatoryArg: <x>: The x location in screen space (0-639)."
"MandatoryArg: <y>: The y location in screen space (0-479)."
"OptionalArg: [color]: The color of the text (defaults to (1,1,1))"
"OptionalArg: [text]: The text used for this element (defaults to empty string)"
"OptionalArg: [fontsize]: The size of the text used for this element (defaults to 2.0)"
"Example: create_debug_text_hud( name, x, y, color, text )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
create_debug_text_hud( name, x, y, color, text, fontsize )
{
	assert( !isdefined( level.debug_text_hud ) || !isdefined( level.debug_text_hud[ name ] ) );
	
	size = 2.0;
	if (isdefined(fontsize))
		size = fontsize;
			
	hud = level.player createClientFontString( "default",  size );
	
	hud.x = x;
	hud.y = y;
	hud.sort = 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = 1.0;
	if (!isdefined(color))
		color = (1,1,1);
	hud.color = color;
	if (isdefined(text))
		hud.label = text;
	level.debug_text_hud[ name ] = hud;
}

/*
=============
///ScriptDocBegin
"Name: print_debug_text_hud( <name>, <value> )"
"Summary: Sets the value for the debugTextHud name (CreateDebugTextHud needs to have been previously called)"
"CallOn: Nothing"
"MandatoryArg: <name>: The name used for this element."
"MandatoryArg: <value>: The value used for this element. (must be a number)"
"Example: print_debug_text_hud( "my name", 0.5 )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
print_debug_text_hud( name, val )
{
	assert( isdefined( level.debug_text_hud[ name ] ) );
	level.debug_text_hud[ name ] SetValue( val );
}

/*
=============
///ScriptDocBegin
"Name: print_debug_text_string_hud( <name>, <text> )"
"Summary: Sets the text for the debugTextHud name (CreateDebugTextHud needs to have been previously called)"
"CallOn: Nothing"
"MandatoryArg: <name>: The name used for this element."
"MandatoryArg: <text>: The text used for this element. (must be a string)"
"Example: print_debug_text_string_hud( name, "value="+value )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
print_debug_text_string_hud( name, text )
{
	assert( isdefined( level.debug_text_hud[ name ] ) );
	level.debug_text_hud[ name ] SetText( text );
}

/*
=============
///ScriptDocBegin
"Name: change_debug_text_hud_color( <name>, <color> )"
"Summary: Sets the color for the debugTextHud name (CreateDebugTextHud needs to have been previously called)"
"CallOn: Nothing"
"MandatoryArg: <name>: The name used for this element."
"MandatoryArg: <color>: The color used for this element. (must be a vector)"
"Example: change_debug_text_hud_color( name, (1,0,0) )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
change_debug_text_hud_color( name, color )
{
	assert( isdefined( level.debug_text_hud[ name ] ) );
	level.debug_text_hud[ name ].color = color;
}

/*
=============
///ScriptDocBegin
"Name: delete_debug_text_hud( <name> )"
"Summary: Deletes the debugTextHud with name"
"CallOn: Nothing"
"MandatoryArg: <name>: The name used for this element."
"Example: delete_debug_text_hud( name )"
"Module: Debug"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
delete_debug_text_hud( name )
{
	assert( isdefined( level.debug_text_hud[ name ] ) );
	level.debug_text_hud[ name ] Destroy();
	level.debug_text_hud[ name ] = undefined;
}
