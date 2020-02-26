#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

/*
=============
///ScriptDocBegin
"Name: so_create_hud_item( <yLine>, <xOffset> , <message>, <player>, <always_draw> )"
"Summary: Useful for creating the hud items that line up on the right side of the screen for typical Special Ops information."
"Module: Hud"
"OptionalArg: <yLine>: Line # to draw the element on. Start with 0 meaning top of the screen in split screen within the safe area."
"OptionalArg: <xOffset>: Offset for the X position."
"OptionalArg: <message>: Optional message to apply to the hudelem.label."
"OptionalArg: <player>: If a player is passed in, it will create a ClientHudElem for that player specifically."
"OptionalArg: <always_draw>: If true, then will not add itself to the list of hud elements to be toggled on and off with the dpad."
"Example: so_create_hud_item( 1, 0, &"SPECIAL_OPS_TIME_NULL", level.player2 );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_create_hud_item( yLine, xOffset, message, player, always_draw, color )
{
	if ( isdefined( player ) )
		assert( isplayer( player ), "so_create_hud_item() received a value for player that did not pass the isplayer() check." );

	if ( !isdefined( yLine ) )
		yLine = 0;
	if ( !isdefined( xOffset ) )
		xOffset = 0;

	// This is to globally shift all the SOs down by two lines to help with overlap with the objective and help text.
	yLine += 2;

	hudelem = undefined;		
	if ( isdefined( player ) )
		hudelem = newClientHudElem( player );
	else
		hudelem = newHudElem();

	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "left";
	hudelem.vertAlign = "middle";
	hudelem.x = xOffset;
	hudelem.y = -100 + ( 15 * yLine );
	hudelem.font = "big";
	hudelem.fontScale = 1.5;
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = true;
	hudelem.hidewhendead = true;
	hudelem.sort = 2;
	hudelem set_hud_white();

	if ( isdefined( message ) )
		hudelem.label = message;

	if ( !isdefined( always_draw ) || !always_draw )
	{
		if ( isdefined( player ) )
		{
			if ( !player so_hud_can_show() )
				player thread so_create_hud_item_delay_draw( hudelem );
		}
	}

	if( IsDefined(color) )
		hudelem.color = color;

	return hudelem;
}

/*
=============
///ScriptDocBegin
"Name: so_hud_ypos( <so_hud_ypos> )"
"Summary: Returns the default value for SO HUD element Y positions. This is generally the split between the Text and the Value. When used allows simple adjustment of the hud to move it around in all SOs rather than hand updating each hud element."
"Module: Hud"
"CallOn: A hud element"
"Example: so_create_hud_item( 1, so_hud_ypos(), &"SPECIAL_OPS_TIME_NULL", level.player2 );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_ypos()
{
	return -72;
}

/*
=============
///ScriptDocBegin
"Name: so_hud_ypos( <so_hud_ypos> )"
"Summary: Returns the default value for SO HUD element Y positions. This is generally the split between the Text and the Value. When used allows simple adjustment of the hud to move it around in all SOs rather than hand updating each hud element."
"Module: Hud"
"CallOn: A hud element"
"Example: so_create_hud_item( 1, so_hud_ypos(), &"SPECIAL_OPS_TIME_NULL", level.player2 );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_xpos()
{
	return 5;
}

/*
=============
///ScriptDocBegin
"Name: so_remove_hud_item( <destroy_immediately> )"
"Summary: Default behavior for removing an SO HUD item. Pulses out by default, but can be told to be removed immediately."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <destroy_immediately>: When set to true, will just remove the item immediately."
"OptionalArg: <decay_immediately>: When set to true, will do the decay visuals immediately rather than holding for a moment."
"Example: hudelem so_remove_hud_item();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_remove_hud_item( destroy_immediately, decay_immediately )
{
	if ( isdefined( destroy_immediately ) && destroy_immediately )
	{
		self notify( "destroying" );
		self Destroy();
		return;
	}

	self thread so_hud_pulse_stop();

	if ( isdefined( decay_immediately ) && decay_immediately )
	{
		self SetPulseFX( 0, 0, 500 );
		wait( 0.5 );
	}
	else
	{
		self SetPulseFX( 0, 1500, 500 );
		wait( 2 );
	}

	self notify( "destroying" );
	self Destroy();
}

so_create_hud_item_delay_draw( hudelem )
{
	hudelem.alpha = 0;
	while( !so_hud_can_show() )
		wait 0.5;

	if ( !isdefined( hudelem ) )
		return;

	if ( so_hud_can_toggle( hudelem ) )
	{
		switch( self.so_infohud_toggle_state )
		{
		case "on":	
		case "none":	hudelem fade_over_time( 1, 0.5 ); break;
		case "off":		hudelem fade_over_time( 0, 0.5 ); break;
		default:		assertmsg( "so_create_hud_item_delay_draw() encountered a setting for player.so_infohud_toggle_state (" + self.so_infohud_toggle_state + ") it didn't recognize." );
		}
	}
	else
	{
		hudelem fade_over_time( 1, 0.5 );
	}

	if ( !self ent_flag( "so_hud_can_toggle" ) )
		self ent_flag_set( "so_hud_can_toggle" );
}

so_hud_can_show()
{
	if ( is_true( level.so_waiting_for_players ) )
		return false;

	if ( is_true( level.challenge_time_force_on ) )
		return true;

	if ( !isdefined( self.so_hud_show_time ) )
		return true;

	return ( gettime() > self.so_hud_show_time );
}

so_hud_can_toggle( hudelem )
{
	if ( !isdefined( hudelem.so_can_toggle ) || !hudelem.so_can_toggle )
		return false;

	if ( !isdefined( self.so_infohud_toggle_state ) )
		return false;

	return true;
}

/*
=============
///ScriptDocBegin
"Name: set_hud_white( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard white color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_white();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
set_hud_white( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 1, 1, 1 );
	self.glowcolor = ( 0.6, 0.6, 0.6 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_blue( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard blue color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_blue();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
set_hud_blue( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 0.8, 0.8, 1 );
	self.glowcolor = ( 0.301961, 0.301961, 0.6 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_green( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard green color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_green();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
set_hud_green( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 0.8, 1, 0.8 );
	self.glowcolor = ( 0.301961, 0.6, 0.301961 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_yellow( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard yellow color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_yellow();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
set_hud_yellow( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 1, 1, 0.5 );
	self.glowcolor = ( 0.7, 0.7, 0.2 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_red( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard red color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_red();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
set_hud_red( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 1, 0.4, 0.4 );
	self.glowcolor = ( 0.7, 0.2, 0.2 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_grey( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard grey color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_grey();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
set_hud_grey( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 0.4, 0.4, 0.4 );
	self.glowcolor = ( 0.2, 0.2, 0.2 );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_create( <new_value> )"
"Summary: Pulses the hud item and updates the label to the new value. Should always try to use the so_hud_pulse_<type> functions instead."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When set to a value, will be set on the .label parameter of the hud element."
"Example: hudelem thread so_hud_pulse_create( 0 );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_create( new_value )
{
	if ( !so_hud_pulse_init() )
		return;

	self notify( "update_hud_pulse" );
	self endon( "update_hud_pulse" );
	self endon( "destroying" );

	// Need to update this script to support SetValue AND SetText AND updating the label.
	if ( isdefined( new_value ) )
		self.label = new_value;

	if ( isdefined( self.pulse_sound ) )
		level.player PlaySound( self.pulse_sound );

	if ( isdefined( self.pulse_loop ) && self.pulse_loop )
		so_hud_pulse_loop();
	else
		so_hud_pulse_single( self.pulse_scale_big, self.pulse_scale_normal, self.pulse_time );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_stop( <new_value> )"
"Summary: Call to take whatever current status a hud element pulse is in, and return it to normal."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When start_immediately, will pass this through to be applied to the hud element's label."
"Example: hudelem thread so_hud_pulse_stop();"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_stop( new_value )
{
	if ( !so_hud_pulse_init() )
		return;

	self notify( "update_hud_pulse" );
	self endon( "update_hud_pulse" );
	self endon( "destroying" );

	if ( isdefined( new_value ) )
		self.label = new_value;

	self.pulse_loop = false;
	so_hud_pulse_single( self.fontscale, self.pulse_scale_normal, self.pulse_time );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_default( <new_value> )"
"Summary: Pulses the hud element, and sets the default color for that type of pulse."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_default( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_default( new_value )
{
	set_hud_white();

	self.pulse_loop = false;
	so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_close( <new_value> )"
"Summary: Pulse loops the hud element, and sets the default color for that type of pulse."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_close( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_close( new_value )
{
	set_hud_green();

	self.pulse_loop = true;
	so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_success( <new_value> )"
"Summary: Pulses the hud element, and sets the default color for that type of pulse."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_success( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_success( new_value )
{
	set_hud_green();

	self.pulse_loop = false;
	so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_warning( <new_value> )"
"Summary: Pulses the hud element, and sets the default color for that type of pulse."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_warning( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_warning( new_value )
{
	set_hud_yellow();

	self.pulse_loop = false;
	so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_alarm( <new_value> )"
"Summary: Pulse loops the hud element, and sets the default color for that type of pulse."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_alarm( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_alarm( new_value )
{
	set_hud_red();

	self.pulse_loop = true;
	so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_failure( <new_value> )"
"Summary: Pulses the hud element, and sets the default color for that type of pulse."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_failure( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_failure( new_value )
{
	set_hud_red();

	self.pulse_loop = false;
	so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_disabled( <new_value> )"
"Summary: Pulses the hud element, and sets the default color for that type of pulse."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_disabled( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_disabled( new_value )
{
	set_hud_grey();

	self.pulse_loop = false;
	so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_smart( <test_value>, <new_value> )"
"Summary: Pulses the hud element with the automatic style as specified with data on the hud element."
"Module: Hud"
"CallOn: A hud element"
"MandatoryArg: <test_value>: Value to check the pulse_bounds against. First thing it is less than in the bounds is the effect that will be acted upon."
"OptionalArg: <new_value>: When defined, will be set as the label of the new hud element."
"Example: hudelem so_hud_pulse_smart( enemy_count );"
"SPMP: coop"
///ScriptDocEnd
=============
*/
so_hud_pulse_smart( test_value, new_value )
{
	if ( !isdefined( self.pulse_bounds ) )
	{
		self so_hud_pulse_default( new_value );
		return;
	}

	foreach ( i, bound in self.pulse_bounds )
	{
		if ( test_value <= bound )
		{
			switch ( i )
			{
			case "pulse_disabled" :	self so_hud_pulse_disabled( new_value );return;
			case "pulse_failure" :	self so_hud_pulse_failure( new_value );	return;
			case "pulse_alarm" :	self so_hud_pulse_alarm( new_value );	return;
			case "pulse_warning" :	self so_hud_pulse_warning( new_value );	return;
			case "pulse_default" :	self so_hud_pulse_default( new_value );	return;
			case "pulse_close" :	self so_hud_pulse_close( new_value );	return;
			case "pulse_success" :	self so_hud_pulse_success( new_value );	return;
			}
		}
	}

	self so_hud_pulse_default( new_value );
}

so_hud_pulse_single( scale_start, scale_end, time )
{
	self endon( "update_hud_pulse" );
	self endon( "destroying" );
	self endon( "death" );

	self.fontscale = scale_start;
	self changefontscaleovertime( time );
	self.fontscale = scale_end;

	wait time;
}

so_hud_pulse_loop()
{
	self endon( "update_hud_pulse" );
	self endon( "destroying" );
	self endon( "death" );

	if ( self.pulse_start_big )
		so_hud_pulse_single( self.pulse_scale_big, self.pulse_scale_loop_normal, self.pulse_time );

	while( isdefined( self.pulse_loop ) && self.pulse_loop )
	{
		so_hud_pulse_single( self.pulse_scale_loop_normal, self.pulse_scale_loop_big, self.pulse_time_loop );
		so_hud_pulse_single( self.pulse_scale_loop_big, self.pulse_scale_loop_normal, self.pulse_time_loop );
	}
}

so_hud_pulse_init()
{
	if ( !isdefined( self ) )
		return false;

	// Bang defaults
	if ( !isdefined( self.pulse_time ) )
		self.pulse_time = 0.5;

	if ( !isdefined( self.pulse_scale_normal ) )
		self.pulse_scale_normal = 1.0;

	if ( !isdefined( self.pulse_scale_big ) )
		self.pulse_scale_big = 1.6;

	// Looping defaults
	if ( !isdefined( self.pulse_loop ) )
		self.pulse_loop = false;

	if ( !isdefined( self.pulse_time_loop ) )
		self.pulse_time_loop = 1.0;

	if ( !isdefined( self.pulse_scale_loop_normal ) )
		self.pulse_scale_loop_normal = 1.0;

	if ( !isdefined( self.pulse_scale_loop_big ) )
		self.pulse_scale_loop_big = 1.15;

	if ( !isdefined( self.pulse_start_big ) )
		self.pulse_start_big = true;

	// Successful initialization!		
	return true;
}


elem_ready_up_setup()
{
	self.alignX = "left";
	//self.fontScale = 0.75;
	self.alpha = 0.0;
	self thread maps\_hud_util::fade_over_time( 1.0, 0.5 );
}