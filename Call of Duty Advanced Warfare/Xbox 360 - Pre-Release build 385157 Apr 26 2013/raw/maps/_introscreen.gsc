
/*  INTRO SCREEN EXAMPLE SCRIPT FROM LONDON;

	//""Mind the Gap""
	//"October 6th - 04:11:[{FAKE_INTRO_SECONDS:32}]"
	//"Sgt. Marcus Burns"
	//"22nd SAS Regiment"
	//"Canary Wharf, London"
	intro_screen_create( &"LONDON_INTROSCREEN_LINE_1", &"LONDON_INTROSCREEN_LINE_2", &"LONDON_INTROSCREEN_LINE_3", &"LONDON_INTROSCREEN_LINE_4", &"LONDON_INTROSCREEN_LINE_5" );
	intro_screen_custom_timing( 5, 5 );
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

main()
{
	PreCacheShader( "black" );
	
	SetDevDvarIfUninitialized( "introscreen", "1" );
	DevSkip = false;
	/# DevSkip = GetDebugDvar( "introscreen" ) == "0";#/

	flag_wait( "start_is_set" );
	
	if ( !IsDefined( level.introScreen ) || !is_default_start()|| DevSkip  )
	{
		delayThread( 0.05, ::flag_set, "introscreen_complete" );
		return;
	}
	
	if ( IsDefined( level.introScreen.CustomFunc ) )
		[[ level.introScreen.CustomFunc ]]();
	else
		introscreen();
}

introscreen_feed_lines()
{
	AssertEx(IsDefined(level.introScreen) && IsDefined(level.introScreen.lines), "No introscreen lines, you need to define them by calling _utility::intro_screen_create()");
	
	if ( !IsDefined( level.introScreen ) )
		return false;
	lines = level.introScreen.lines;
	
	keys = GetArrayKeys( lines );

	for ( i = 0; i < keys.size; i++ )
	{
		key		 = keys[ i ];
		interval = 1;
		time	 = ( i * interval ) + 1;
		delayThread( time, ::introscreen_corner_line, lines[ key ], ( lines.size - i - 1 ), interval, key );
	}
	return true;
}

introscreen_generic_black_fade_in( time, fade_time, fade_in_time )
{
	introscreen_generic_fade_in( "black", time, fade_time, fade_in_time );
}

introscreen_generic_fade_in( shader, pause_time, fade_out_time, fade_in_time )
{
	if ( !IsDefined( fade_out_time ) )
		fade_out_time	= 1.5;
		
	if ( !IsDefined( fade_in_time ) )
		start_overlay();	
	else
		fade_out( fade_in_time );
		
	wait pause_time;
	fade_in( fade_out_time );
	wait fade_out_time;
	SetSavedDvar( "com_cinematicEndInWhite", 0 );
}

introscreen_corner_line( string, size, interval, index_key )
{
	level notify( "new_introscreen_element" );

	if ( !IsDefined( level.intro_offset ) )
		level.intro_offset	= 0;
    else
        level.intro_offset++;

	y	= _CornerLineThread_height();

	hudelem			   = NewHudElem();
	hudelem.x		   = 20;
	hudelem.y		   = y;
	hudelem.alignX	   = "left";
	hudelem.alignY	   = "bottom";
	hudelem.horzAlign  = "left";
	hudelem.vertAlign  = "bottom";
	hudelem.sort	   = 1;// force to draw after the background
	hudelem.foreground = true;
    hudelem SetText( string );
	hudelem.alpha		= 0;
    hudelem FadeOverTime( 0.2 );
	hudelem.alpha		= 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale	   = 2.0;// was 1.6 and 2.4, larger font change
	hudelem.color		   = ( 0.8, 1.0, 0.8 );
	hudelem.font		   = "objective";
	hudelem.glowColor	   = ( 0.3, 0.6, 0.3 );
	hudelem.glowAlpha	   = 1;
	duration			   = Int( ( size * interval * 1000 ) + 4000 );
    hudelem SetPulseFX( 30, duration, 700 ); // something, decay start, decay duration
    thread hudelem_destroy( hudelem );
}

_CornerLineThread_height()
{
	return( ( ( level.intro_offset ) * 20 ) - 82 );
}

hudelem_destroy( hudelem )
{
	wait( 16 );
	hudelem notify( "destroying" );
	level.intro_offse = undefined;
	time			  = 0.5;
    hudelem FadeOverTime( time );
	hudelem.alpha		= 0;
    wait time;
    hudelem notify( "destroy" );
    hudelem Destroy();
}

old_introscreen_default()
{
	level.player FreezeControls( true );
	thread introscreen_generic_black_fade_in( level.introScreen.completed_delay, level.introScreen.fade_out_time, level.introScreen.fade_in_time );
	if ( ! introscreen_feed_lines() )
		wait 0.05;
	wait( level.introScreen.completed_delay );
	flag_set( "introscreen_complete" );
	level.player FreezeControls( false );
}

// IW6 introscreen Section --------------------------------
introscreen( no_bg, bg_time )
{
	if ( !IsDefined( no_bg ) )
	{
		no_bg = false;
		no_artifacts = true;
	}

	// For a short timed black background
	if ( IsDefined( bg_time ) )
	{
		no_bg = true;
		start_overlay();
		level.player FreezeControls( true );
		level.player delaycall( bg_time, ::FreezeControls, false );
		delaythread( bg_time, ::fade_in, 2 );
	}

	level.chyron = SpawnStruct();
	level.chyron.huds = [];
	level.chyron.strips = [];
	level.chyron.last_strips = [];
	level.chyron.artifacts = [];
	level.chyron.text_x = 20;
	level.chyron.text_y = -82;
	level.chyron.text_incoming = false;
	level.chyron.strips_disabled = false;
	level.chyron.sound_org = Spawn( "script_origin", level.player.origin );
	level.chyron.sound_org LinkTo( level.player );

	if ( !no_bg )
	{
		level.player FreezeControls( true );
		start_overlay();
		thread artifacts();
	}

//	chyron_sound( "ui_chyron_on" );
	thread strips();

	time = 0.4;
	thread quick_cursor( time );
	wait( time );

	title_line( level.introscreen.lines[ 0 ] );
//	chyron_sound( "ui_chyron_firstline" );
	sub_line( level.introscreen.lines[ 1 ], 0 );
	wait( 2 );
	sub_line( level.introscreen.lines[ 2 ], 1 );
	wait( 1 );

	level.chyron.strips_disabled = true;
	wait( 2 );

	level.chyron.strips_disabled = false;	
	wait( 1 );
	
//	chyron_sound( "ui_chyron_off" );
	faze_out( no_bg );

	if ( !no_bg )
	{
		thread fade_in( 2 );
		level.player FreezeControls( false );
	}

	flag_set( "introscreen_complete" );
	level notify( "stop_chyron" );
	level.chyron.sound_org Delete();
	level.chyron = undefined;
}

chyron_sound( alias )
{
	if ( !SoundExists( alias ) )
	{
/#
		PrintLn( "Warning: chryon_sound() missing alias " + alias );
#/
		return;
	}

	level.chyron.sound_org PlaySound( alias );
}

hud_destroy( time )
{
	self endon( "death" );

	self FadeOverTime( time );
	self.alpha = 0;
	wait( time );
	self Destroy();
}

quick_cursor( time )
{
	wait( 0.5 );
	hud = NewHudElem();
	hud.x = level.chyron.text_x - 5;
	hud.y = level.chyron.text_y;
	hud.fontscale = 3;
	hud.horzAlign = "left";
	hud.vertAlign = "bottom";
	hud.sort = 1;
	hud.foreground = true;
	hud.hidewheninmenu = true;
	hud.alpha = 0.8;
	hud SetShader( "white", 1, 35 );
	hud.color = ( 0.85, 0.93, 0.92 ); // ( 0.18, 0.18, 0.22 );

	hud MoveOverTime( time );
	hud FadeoverTime( time * 0.5 );
	hud.alpha = 0;
	hud.x += 300;

	wait( 0.4 );
	hud Destroy();
}

artifacts()
{
	level endon( "chyron_faze_out_text" );
	chars = [ ".", "-", "_", "|", "+" ];
	fontscale = 0.7;
	for ( i = 0; i < chars.size; i++ )
	{
		hud = create_chyron_text( "" );
		hud.fontscale = fontscale;
		hud.alpha = 0;
		hud.sort = 2;
		hud.color = ( 0.75, 0.83, 0.89 );
		hud.pulse = false;
		level.chyron.artifacts[ level.chyron.artifacts.size ] = hud;
	}

	level.chyron.artifacts_fade = false;
	thread artifact_pulse();

	x = 0;
	y = level.chyron.text_y - 10;
	while ( 1 )
	{
		index = 0;
		chars = array_randomize( chars );
		foreach ( hud in level.chyron.artifacts )
		{
//			chyron_sound( "ui_chyron_plusminus" );

			hud.fontscale = fontscale;
			if ( chars[ index ] == "+" )
			{
				hud.fontscale = 0.55;
			}

			hud SetText( chars[ index ] );
			hud.x = x + RandomInt( 200 );
			hud.y = y + RandomInt( 60 );
			hud.pulse = true;
			index++;
			wait( RandomFloatRange( 0.05, 0.1 ) );
		}

		wait( RandomFloatRange( 4, 7 ) );

		level.chyron.artifacts_fade = true;
		level waittill( "chyron_artifact_faded" );
	}
}

artifact_pulse()
{
	level endon( "chyron_faze_out_text" );
	max_alpha = 0.6;
	dir = 1;
	while ( 1 )
	{
		if ( level.chyron.artifacts_fade )
		{
			max_alpha -= 0.07;
		}
		else
		{
			if ( max_alpha < 0.15 || max_alpha > 0.6 )
			{
				dir *= -1;
			}

			max_alpha += ( 0.02 + RandomFloat( 0.04 ) ) * dir;
		}

		max_alpha = max ( max_alpha, 0 );

		foreach ( hud in level.chyron.artifacts )
		{
			if ( hud.pulse )
			{
				if ( max_alpha == 0 )
				{
					hud.alpha = 0;
				}
				else
				{
					hud.alpha = RandomFloatRange( max_alpha * 0.6, max_alpha );
				}
			}
		}

		if ( max_alpha == 0 )
		{
			level notify( "chyron_artifact_faded" );
			max_alpha = 0.8;
			level.chyron.artifacts_fade = false;

			foreach ( hud in level.chyron.artifacts )
			{
				hud.pulse = false;
			}
		}

		wait( 0.05 );
	}
}

strips()
{
	level endon( "chyron_faze_out_text" );
	count_limit = 5;
	counter = 0;

	timer = 1;
	while ( 1 )
	{
		if ( level.chyron.strips_disabled )
		{
			wait( 0.05 );
			continue;
		}

		counter++;
		count = int( Min( counter, count_limit ) );

		for( i = 0; i < count; i++ )
		{
			thread create_strip();
			wait( RandomFloatRange( 0, 0.1 ) );
		}

		if ( level.chyron.text_incoming )
		{
			wait( 0.05 );
			continue;
		}

		wait( RandomFloatRange( timer * 0.5, timer ) );
		timer -= 0.05;
		timer = Max( timer, 0.2 );
	}
}

title_line( text, num )
{
	hud = create_chyron_text( text );

	level.chyron.text_incoming_x = hud.x;
	level.chyron.text_incoming_y = hud.y;
	level.chyron.text_incoming = true;
	wait( 0.5 );
	level.chyron.text_incoming = false;

	dupes = dupe_hud( hud, 1 );
	dupe_time = 4;
	dupes[ 0 ] thread location_dupes_thread( dupe_time );

	hud.y -= 10;

	hud.glowalpha = 0.05;
	hud.glowcolor = hud.color;
	
	fade_time = 0.3;
	hud MoveOverTime( fade_time );
	hud FadeOverTime( fade_time * 3 );
	hud.y += 10;

	time = 0.5;
	time -= fade_time;
	wait( fade_time );
	hud thread quick_pulse();

	wait( time );
	hud thread offset_thread( -30, 30, 20, -8, 8, 4 );
}

offset_thread( x_min, x_max, x_limit, y_min, y_max, y_limit )
{
	count = RandomIntRange( 1, 2 );
	for ( i = 0; i < count; i++ )
	{
		x_offset = randomintrange_limit( x_min, x_max, x_limit );
		y_offset = randomintrange_limit( y_min, y_max, y_limit );
		offsets[ 0 ] = [ x_offset, y_offset ];
		offsets[ 1 ] = [ x_offset - 10, y_offset ];
		self thread hud_offset( offsets );

		wait( RandomFloatRange( 0.5, 1 ) );
	}
}

faze_out( no_bg )
{
	hud = undefined;
	if ( !no_bg )
	{
		hud = NewHudElem();
		hud.x = level.chyron.text_x + 60;
		hud.y = level.chyron.text_y + 30;
		hud.alignx = "center";
		hud.aligny = "middle";
		hud.horzAlign = "left";
		hud.vertAlign = "bottom";
		hud.sort = 1;
		hud.foreground = true;
		hud.hidewheninmenu = true;
		hud.alpha = 0;
		hud SetShader( "white", 1, 60 );
		hud.color = ( 0.85, 0.93, 0.92 );
	
		hud FadeOverTime( 0.25 );
		hud.alpha = 0.1;
	
		hud ScaleOverTime( 0.1, 2000, 60 );
		wait( 0.1 );
	}

	time = 0.15;
	fade_out_text( time * 0.4 );

	if ( !no_bg )
	{
		hud FadeOverTime( 0.25 );
		hud.alpha = 0.2;
		hud.color = ( 1, 1, 1 );
	
		hud ScaleOverTime( time, 2000, 2 );
		wait( time );
	
		time = 0.15;
		hud ScaleOverTime( time, 2, 2 );
		hud thread faze_out_finish( time );
	}
}

faze_out_finish( time )
{
	self FadeOverTime( time );
	self.alpha = 0;
	wait( time );
	self Destroy();
}

fade_out_text( fade )
{
	level notify( "chyron_faze_out_text" );
	foreach ( hud in level.chyron.huds )
	{
		if ( !IsDefined( hud ) )
		{
			continue;
		}

		hud thread hud_destroy( fade );
	}

	foreach ( hud in level.chyron.strips )
	{
		hud thread hud_destroy( fade );
	}
}

sub_line( text, num )
{
	hud = create_chyron_text( text );
	hud.y += 20 + ( num * 15 );
	hud.fontscale = 0.8;

	level.chyron.text_incoming_x = hud.x;
	level.chyron.text_incoming_y = hud.y;
	level.chyron.text_incoming = true;
	wait( 0.5 );

	hud.glowalpha = 0.05;
	hud.glowcolor = hud.color;

	hud thread quick_pulse();
	hud.alpha = 1;
	hud SetPulseFX( 30, 50000, 700 ); // something, decay start, decay duration

	hud delaythread( 2, ::offset_thread, -7, 7, 3, -5, 5, 3 );
	level.chyron.text_incoming = false;
}

hud_offset( offset_array )
{
	og_x = self.x;
	og_y = self.y;
	foreach ( offset in offset_array )
	{
		self.x = og_x + offset[ 0 ];
		self.y = og_y + offset[ 1 ];
		wait( RandomFloatRange( 0.05, 0.2 ) );
	}

	self.x = og_x;
	self.y = og_y;
}

quick_pulse( max_alpha )
{
	self endon( "death" );
	level endon( "chyron_faze_out_text" );
	if ( !IsDefined( max_alpha ) )
	{
		max_alpha = 1;
	}

	while ( 1 )
	{
		wait( 0.05 );
		self.alpha = RandomFloatRange( max_alpha * 0.7, max_alpha );
	}
}

location_dupes_thread( return_time )
{
	dest_x = self.x;
	dest_y = self.y;
	self.x += RandomIntRange( -30, -10 );
	self.y += RandomIntRange( 10, 20 );

	time = 0.15;
	self MoveOverTime( time );
	self.x = dest_x;
	self.y = dest_y;
	self FadeOverTime( time );
	self.alpha = 0.1;

	wait( time );

	self MoveOverTime( return_time );
	self.x += RandomIntRange( 15, 20 );
	self.y += RandomIntRange( -4, 4 );

	wait( return_time );

	time = 0.05;
	self MoveOverTime( time );
	self.x = dest_x;
	self.y = dest_y;
	wait( time );

	self FadeOverTime( time );
	self.alpha = 0;
}

randomintrange_limit( min, max, limit )
{
	num = RandomIntRange( min, max );

	mult = 1;
	if ( num < 0 )
	{
		mult = -1;
	}

	num = max( abs( num ), limit );
	return ( num * mult );
}

create_chyron_text( text )
{
	hud			   		= NewHudElem();
	hud.x		   		= level.chyron.text_x;
	hud.y		   		= level.chyron.text_y;
	hud.horzAlign  		= "left";
	hud.vertAlign  		= "bottom";
	hud.sort	   		= 3; // force to draw after the background
	hud.foreground 		= true;
    hud SetText( text );
	hud.text 			= text;
	hud.alpha 			= 0;
	hud.hidewheninmenu 	= true;
	hud.fontScale	   	= 1.25; // was 1.6 and 2.4, larger font change

	if ( level.console )
	{
		hud.fontscale = 1;
	}

	hud.color		   	= ( 0.85, 0.93, 0.92 ); // ( 0.76, 0.89, 0.87 );
	hud.font		   	= "hudsmall";
	level.chyron.huds[ level.chyron.huds.size ] = hud;
	return hud;
}

get_strip_settings()
{
	struct = SpawnStruct();

	max_width = 200;
	max_height = 60;
	struct.width = RandomIntRange( 20, max_width );

	thickness = [ 5, 10, 15 ];
	struct.height = thickness[ RandomInt( thickness.size ) ];
	struct.x = RandomIntRange( 0, max_width - struct.width );
	struct.y = -85 + RandomInt( max_height - struct.height ); // 90 is the max Y or height of the background
	struct.alpha = RandomFloatRange( 0.3, 0.7 );
	struct.color = get_strip_color();
	struct.time = RandomFloatRange( 0.05, 0.1 );

	if ( level.chyron.text_incoming )
	{
		struct.x = int( level.chyron.text_incoming_x + RandomIntRange( -1, 1 ) );
		struct.y = int( level.chyron.text_incoming_y + RandomIntRange( 0, 7 ) );
		struct.width = RandomIntRange( 100, max_width );
		struct.height = RandomIntRange( 10, 15 );
		struct.color = ( 0.85, 0.93, 0.92 ) * RandomFloatRange( 0.2, 0.4 );
	}

	return struct;	
}

get_strip_color()
{
	colors = [];
	colors[ colors.size ] = ( 0.15, 0.14, 0.22 );
	colors[ colors.size ] = ( 0.09, 0.11, 0.13 );
	colors[ colors.size ] = ( 0.34, 0.22, 0.22 );
	colors[ colors.size ] = ( 0.29, 0.34, 0.22 );

	return colors[ RandomInt( colors.size ) ];
}

create_strip()
{
	level endon( "chyron_faze_out_text" );

	if ( level.chyron.strips.size < 8 )
	{
		new_hud = NewHudElem();
		new_hud.visible = false;

		level.chyron.strips[ level.chyron.strips.size ] = new_hud;
	}

	hud = undefined;
	foreach ( strip in level.chyron.strips )
	{
		if ( strip.visible )
		{
			continue;
		}

		hud = strip;
	}

	if ( !IsDefined( hud ) )
	{
		return;
	}

	struct = get_strip_settings();

	if ( !level.chyron.text_incoming )
	{
		if ( level.chyron.last_strips.size > 0 && level.chyron.last_strips.size < 3 && RandomInt( 100 ) > 10 )
		{
			prev_hud = level.chyron.last_strips[ level.chyron.last_strips.size - 1 ];
			struct.x = prev_hud.x;
			struct.y = prev_hud.y + prev_hud.height;
	
			if ( cointoss() )
			{
				struct.y = prev_hud.y - struct.height;
			}
		}
		else
		{
			level.chyron.last_strips = [];
		}

		level.chyron.last_strips[ level.chyron.last_strips.size ] = hud;
	}

	hud.x = struct.x;
	hud.y = struct.y;
	hud.width = struct.width;
	hud.height = struct.height;
	hud SetShader( "white", struct.width, struct.height );

	hud.alpha = struct.alpha;
	hud.color = struct.color;

	if ( hud.alpha > 0.6 )
	{
//		chyron_sound( "ui_chyron_line_static" );
	}

	hud.horzAlign = "left";
	hud.vertAlign = "bottom";
	hud.sort = 1;
	hud.foreground = true;
	hud.hidewheninmenu = true;

	hud.visible = true;
	wait( struct.time );
	hud.alpha = 0;
	hud.visible = false;
}

dupe_hud( hud, mult )
{
	dupes = [];
	for( i = 0; i < mult; i++ )
	{
		dupes[ dupes.size ] = create_chyron_text( hud.text );
	}

	return dupes;
}