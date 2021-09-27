#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include animscripts\utility;


main()
{
	level.activate_uav_hud_cb = ::activate_uav_hud_cb;
	level.deactivate_uav_hud_cb = ::deactivate_uav_hud_cb;
	level.firemissile_uav_hud_cb = ::firemissile_uav_hud_cb;
	if(isdefined(level.remote_missile_use_cluster_bomb) && level.remote_missile_use_cluster_bomb)
		level.remote_missile_steering_cb = ::monitor_cluster;
		
	PrecacheShader( "uav_predator2_dir" );
	PrecacheShader( "uav_predator2_dirbar" );
	PrecacheShader( "uav_predator2_xhair" );
	PrecacheShader( "uav_predator2_horz_bar1" );
	PrecacheShader( "uav_predator2_l_topleft" );
	PrecacheShader( "uav_predator2_l_topright" );
	PrecacheShader( "uav_predator2_l_bottomleft" );
	PrecacheShader( "uav_predator2_l_bottomright" );
	PrecacheShader( "uav_predator2_heading_frame" );
	PrecacheString( &"UAV_M" );
	PrecacheString( &"UAV_WTR_DVR_ON" );
	PrecacheString( &"UAV_NAR" );
	PrecacheString( &"UAV_BLK_WHT" );
	PrecacheString( &"UAV_KIAS" );
	PrecacheString( &"UAV_N2" );
	PrecacheString( &"UAV_W2" );
//	setdvar("uav_crosshair", "reaper"); // this tells the hud.menu to not draw the missile crosshairs
}

activate_uav_hud_cb()
{
	assert(!isdefined(self.uav_huds));

	if ( isSplitscreen() )
		self.hud_dimension_multiplier = 1.0 / 1.5;
	else
		self.hud_dimension_multiplier = 1.0;

	self.uav_huds = [];
	self.uav_huds["screen"] = create_hud_predator2_screen( 1, 1 );
//	self.uav_huds["time"] = create_hud_time();
//	self.uav_huds["msl"] = create_hud_msl();
	self.uav_huds["text"] = create_hud_text();
	self.uav_huds["kias"] = create_hud_kias();
	self.uav_huds["alt"] = create_hud_alt();
//	self.uav_huds["rng"] = create_hud_rng();
	self.uav_huds["heading"] = create_hud_heading();
//	self.uav_huds["horz_indicator"] = create_hud_horz_indicator();
	self.uav_huds["crosshair"] = create_hud_crosshair();
}

hide_predator_hud_part( fadeout, hudPart, fadeTime )
{
	if ( IsArray( hudPart ) )
	{
		foreach ( elem in hudPart )
		{
			if ( fadeout )
			{
				elem FadeOverTime( fadeTime );
			}
			elem.alpha = 0;
		}
	}
	else
	{
		if ( fadeout )
		{
			hudPart FadeOverTime( fadeTime );
		}
		hudPart.alpha = 0;
	}
}

hide_predator_hud( fadeout )
{
	self notify( "uav_cleanup_hud" );
	foreach ( hud in self.uav_huds )
	{
		if(IsDefined(hud))
		{
			hide_predator_hud_part ( fadeout, hud, 0.25 );
		}
	}
}

deactivate_uav_hud_cb( phase )
{
	assert(isdefined(self.uav_huds));
	if (phase == 0)
	{	// fadeout
		hide_predator_hud( true );
	}
	else
	{	// cleanup
		uav_cleanup_hud();
	}
}

firemissile_uav_hud_cb( phase )
{
	assert(isdefined(self.uav_huds));
	if (phase == 0)
	{
		hide_predator_hud( false );
	}
	else
	{
		uav_cleanup_hud();
	}
}

uav_cleanup_hud()
{
	self notify( "uav_cleanup_hud" );
	if(IsDefined(self.uav_huds))
	{
		foreach ( hud in self.uav_huds )
		{
			if(IsDefined(hud))
			{
				if ( IsArray( hud ) )
				{
					foreach ( elem in hud )
					{
						uav_destroy_hud( elem );
					}
		
					hud = undefined;
				}
				else
				{
					uav_destroy_hud( hud );
				}
			}
		}
		self.uav_huds = undefined;
	}
}

uav_destroy_hud( hud )
{
	if(!IsDefined(hud))
		return;
		
	if ( IsDefined( hud.data_value ) )
	{
		hud.data_value Destroy();
	}

	if ( IsDefined( hud.data_value_suffix ) )
	{
		hud.data_value_suffix Destroy();
	}

	hud Destroy();
}

adjust_coord_for_split_screen( coord )
{
	if ( isSplitscreen() )
		return coord * self.hud_dimension_multiplier;
	else
		return coord;
}

create_hud_l_bar( x, y, w, h, shader, sortOrder, alphaValue, alignx, aligny )
{
	hud = NewClientHudElem( self );
	hud.x = adjust_coord_for_split_screen( x );
	hud.y = adjust_coord_for_split_screen( y );
	hud.alignx = alignx;
	hud.aligny = aligny;
	hud.sort = sortOrder;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = alphaValue;
	hud SetShader( shader, w, h );

	return hud;
}

create_hud_predator2_screen( sortOrder, alphaValue )
{
	hud[0] = create_hud_l_bar( 100 + 40, 135, 21, 32, "uav_predator2_l_topleft", sortOrder, alphaValue, "left", "top" );
	hud[1] = create_hud_l_bar( 518 - 40 + 21, 135, 21, 32, "uav_predator2_l_topright", sortOrder, alphaValue, "right", "top" );
	hud[2] = create_hud_l_bar( 100 + 40, 332 + 32, 21, 32, "uav_predator2_l_bottomleft", sortOrder, alphaValue, "left", "bottom" );
	hud[3] = create_hud_l_bar( 518 - 40 + 21, 332 + 32, 21, 32, "uav_predator2_l_bottomright", sortOrder, alphaValue, "right", "bottom" );

	return hud;
}

predator_hud_time( hud )
{
	self endon( "uav_cleanup_hud" );
	self endon( "death" );
	basetime = (((10*60)+20)*60)*1000;
	while (isdefined(hud))
	{
		time = GetTime() + basetime;
		seconds = int(time/1000);
		minutes = int(seconds/60);
		seconds = int(seconds - (60*minutes));
		hours = int(minutes/60);
		minutes = int(minutes - (60*hours));
		hours = safemod( hours, 24 );
		if (hours < 10)
			str = "0" + hours;
		else
			str = "" + hours;
		hud[0] SetText(str);
		if (minutes < 10)
			str = "0" + minutes;
		else
			str = "" + minutes;
		hud[1] SetText(str);
		if (seconds < 10)
			str = "0" + seconds;
		else
			str = "" + seconds;
		hud[2] SetText( str );
		wait 0.05;
	}
}

create_hud_time()
{
	hud[0] = self createClientFontString( "default",  2.0 );
	hud[0].x = adjust_coord_for_split_screen( 320-4*2.0*8 + 2*2.0*8 );
	hud[0].y = adjust_coord_for_split_screen( 420 );
	hud[0].sort = 1;
	hud[0].horzAlign = "fullscreen";
	hud[0].vertAlign = "fullscreen";
	hud[0].alpha = 1.0;
	hud[0].color = ( 0.56, 1.0, 0.52 );
	hud[0] SetText( "01" );
	hud[1] = self createClientFontString( "default",  2.0 );
	hud[1].x = adjust_coord_for_split_screen( 320-4*2.0*6 + 2*2.0*8 );
	hud[1].y = adjust_coord_for_split_screen( 420 );
	hud[1].sort = 1;
	hud[1].horzAlign = "fullscreen";
	hud[1].vertAlign = "fullscreen";
	hud[1].alpha = 1.0;
	hud[1].color = ( 0.56, 1.0, 0.52 );
	hud[1].label = ":";
	hud[1] SetText( "23" );
	hud[2] = self createClientFontString( "default",  2.0 );
	hud[2].x = adjust_coord_for_split_screen( 320-4*2.0*3 + 2*2.0*8 );
	hud[2].y = adjust_coord_for_split_screen( 420 );
	hud[2].sort = 1;
	hud[2].horzAlign = "fullscreen";
	hud[2].vertAlign = "fullscreen";
	hud[2].alpha = 1.0;
	hud[2].color = ( 0.56, 1.0, 0.52 );
	hud[2].label = ":";
	hud[2] SetText( "45" );
	thread predator_hud_time( hud );
	
	return hud;
}

predator_hud_msl( hud )
{
	self endon( "uav_cleanup_hud" );
	self endon( "death" );
	while (isdefined(hud))
	{
		uav = maps\_remotemissile::get_uav();
		if (isdefined(uav))
		{
			height = uav.origin[2];
			height = height * 0.0254;	// get it in meters
			height = int(height);
			hud[0] SetValue( height );
			numlen= 1;
			height /= 10;
			while (height > 1)
			{
				numlen++;
				height /= 10;
			}
			hud[1].x = adjust_coord_for_split_screen( 480 + 2*4.0*numlen );
		}
		wait 0.05;
	}
}

create_hud_msl()
{
	hud[0] = self createClientFontString( "default",  2.0 );
	hud[0].x = adjust_coord_for_split_screen( 480 );
	hud[0].y = adjust_coord_for_split_screen( 70 );
	hud[0].sort = 1;
	hud[0].horzAlign = "fullscreen";
	hud[0].vertAlign = "fullscreen";
	hud[0].alpha = 1.0;
	hud[0].color = ( 0.56, 1.0, 0.52 );
	hud[0] SetValue( 16 );
	hud[1] = self createClientFontString( "default",  2.0 );
	hud[1].x = adjust_coord_for_split_screen( 480 + 8 );
	hud[1].y = adjust_coord_for_split_screen( 70 );
	hud[1].sort = 1;
	hud[1].horzAlign = "fullscreen";
	hud[1].vertAlign = "fullscreen";
	hud[1].alpha = 1.0;
	hud[1].color = ( 0.56, 1.0, 0.52 );
	hud[1] SetText( &"UAV_MSL" );

	thread predator_hud_msl( hud );
	
	return hud;
}

create_hud_text_line()
{
	hudElement = self createClientFontString( "default",  1.2 );
	hudElement.sort = 1;
	hudElement.horzAlign = "fullscreen";
	hudElement.vertAlign = "fullscreen";
	hudElement.alpha = 1.0;
	hudElement.color = ( 0.56, 1.0, 0.52 );
	
	return hudElement;
}

create_hud_text()
{
	hud[0] = create_hud_text_line();
	hud[0].x = adjust_coord_for_split_screen( 30 + 20 );
	hud[0].y = adjust_coord_for_split_screen( 55 + 54 );
	hud[0] SetText( &"UAV_WTR_DVR_ON" );

	hud[1] = create_hud_text_line();
	hud[1].x = adjust_coord_for_split_screen( 30 + 20 );
	hud[1].y = adjust_coord_for_split_screen( 67 + 54 );
	hud[1] SetText( &"UAV_NAR" );

	hud[2] = create_hud_text_line();
	hud[2].x = adjust_coord_for_split_screen( 30 + 20 );
	hud[2].y = adjust_coord_for_split_screen( 79 + 54 );
	hud[2] SetText( &"UAV_BLK_WHT" );
	
	hud[3] = create_hud_text_line();
	hud[3].x = adjust_coord_for_split_screen( 30 + 20 );
	hud[3].y = adjust_coord_for_split_screen( 93 + 54 );
	hud[3] SetText( &"UAV_KIAS" );

	hud[4] = create_hud_text_line();
	hud[4].x = adjust_coord_for_split_screen( 550 - 40 );
	hud[4].y = adjust_coord_for_split_screen( 380 );
	if ( isdefined( level.predatorHUD_lat_text ) )
		hud[4] SetText( level.predatorHUD_lat_text );
	else
		hud[4] SetText( &"UAV_N2" );

	hud[5] = create_hud_text_line();
	hud[5].x = adjust_coord_for_split_screen( 548 - 40 );
	hud[5].y = adjust_coord_for_split_screen( 400 );
	if ( isdefined( level.predatorHUD_lon_text ) )
		hud[5] SetText( level.predatorHUD_lon_text );
	else
		hud[5] SetText( &"UAV_W2" );

	hud[6] = create_hud_text_line();
	hud[6].x = adjust_coord_for_split_screen( 531 - 40 );
	hud[6].y = adjust_coord_for_split_screen( 420 );
	hud[6] SetText( &"UAV_ALT_MSL" );

	return hud;
}

predator_hud_rng( hud )
{
	self endon( "uav_cleanup_hud" );
	self endon( "death" );
	while (isdefined(hud))
	{
		rig = maps\_remotemissile_utility::player_uav_rig();
		if (isdefined(rig))
		{
			if (isdefined(self.active_uav_missile))
			{
				origin = self.active_uav_missile.origin;
				forward = AnglesToForward( self.active_uav_missile.angles );
				endpoint = origin + 20000*forward;;
				
				traceData = BulletTrace( origin, endpoint, true, self.active_uav_missile );
				range = Distance(traceData["position"], self.active_uav_missile.origin);
			}
			else
			{
				origin = rig.origin;
				playerAngles = self GetPlayerAngles();
				forward = AnglesToForward( playerAngles );
				origin = origin + 500*forward;
				endpoint = origin + 20000*forward;;
				
				traceData = BulletTrace( origin, endpoint, true, self );
				range = Distance(traceData["position"], rig.origin);
			}
			
			range = range * 0.0254;	// get it in meters
			range = int(range);
			hud[0] SetValue( range );
			numlen= 1;
			range /= 10;
			while (range > 1)
			{
				numlen++;
				range /= 10;
			}
			hud[0].x = adjust_coord_for_split_screen( 320 - 2*4*(numlen+1)/2 );
			hud[1].x = adjust_coord_for_split_screen( 320 - 2*4*(numlen+1)/2 + 2*4*numlen );
			
			maps\_audio::aud_send_msg("predator_dist_update", range);
			
		}
		wait 0.05;
	}
}

create_hud_rng()
{
	hud[0] = self createClientFontString( "default",  2.0 );
	hud[0].x = adjust_coord_for_split_screen( 320 - 2*4*(3+1)/2 );
	hud[0].y = adjust_coord_for_split_screen( 60 );
	hud[0].sort = 1;
	hud[0].horzAlign = "fullscreen";
	hud[0].vertAlign = "fullscreen";
	hud[0].alpha = 1.0;
	hud[0].color = ( 0.56, 1.0, 0.52 );
	hud[0] SetValue( 215 );
	hud[1] = self createClientFontString( "default",  2.0 );
	hud[1].x = adjust_coord_for_split_screen( 320 - 2*4*(3+1)/2 + 2*4*3 );
	hud[1].y = adjust_coord_for_split_screen( 60 );
	hud[1].sort = 1;
	hud[1].horzAlign = "fullscreen";
	hud[1].vertAlign = "fullscreen";
	hud[1].alpha = 1.0;
	hud[1].color = ( 0.56, 1.0, 0.52 );
	hud[1] SetText( &"UAV_M" );
	thread predator_hud_rng( hud );
	
	return hud;
}

predator_hud_kias( hud )
{
	self endon( "uav_cleanup_hud" );
	self endon( "death" );
	uav = maps\_remotemissile::get_uav();
	speed = 0;
	minspeed = 0;
	maxspeed = 200;
	if (isdefined(uav))
	{
		if ( uav.code_classname == "script_vehicle" )
			speed = uav Vehicle_GetSpeed();	// in mph
		minspeed = speed - 30;
		maxspeed = speed + 30;
	}
	
	variation = 0;
	varduration = 3;
	vartimer = varduration;
	curvar = 0;
	tgtvar = 0;

	steps = 25;
	pixel_steps = 55;
	guage_center = 245;

	while (isdefined(hud))
	{
		uav = maps\_remotemissile::get_uav();
		if (isdefined(uav))
		{
			if ( uav.code_classname == "script_vehicle" )
				speed = uav Vehicle_GetSpeed();	// in mph
			ratio = (speed - minspeed)/(maxspeed-minspeed);
			ratio += curvar;
			if (ratio < 0)
				ratio = 0;
			if (ratio > 1)
				ratio = 1;
			speed = 80 + ratio*(110-80);	// fake based on original .tga

		    fade_range = pixel_steps / 2;
		    top_alpha_fade_y_start = guage_center - pixel_steps * 2;
		    top_alpha_fade_y_end = top_alpha_fade_y_start + fade_range;
		    bottom_alpha_fade_y_end = guage_center + pixel_steps * 2;
		    bottom_alpha_fade_y_start = bottom_alpha_fade_y_end - fade_range;
		    
		    part_step = speed - (int(speed / steps)) * steps; // = mod(steps)
		    mid = speed - part_step;
		    offset_y = int((part_step / steps) * pixel_steps);
		    hud[0] SetValue( mid + steps * 2);
		    y = guage_center + offset_y - 2 * pixel_steps;
		    hud[0].y = adjust_coord_for_split_screen( y );
		    hud[0].alpha = clamp (( y - top_alpha_fade_y_start ) / fade_range, 0, 1 );
		    hud[1] SetValue( mid + steps );
		    hud[1].y = adjust_coord_for_split_screen( guage_center + offset_y - pixel_steps );
		    hud[2] SetValue( mid );
		    hud[2].y = adjust_coord_for_split_screen( guage_center + offset_y );
		    hud[3] SetValue( mid - steps );
		    y = guage_center + offset_y + pixel_steps;
		    hud[3].y = adjust_coord_for_split_screen( y );
		    hud[3].alpha = 1 - clamp (( y - bottom_alpha_fade_y_start ) / fade_range, 0, 1 );

			hud[4] SetValue( int(speed) );

			bars_hud_start_index = 5;
			for ( i = 0; i < 25; i++ ) 
			{
				y = i*11 + 135 + offset_y - pixel_steps + 4; // +4 to center on the number
				hud[bars_hud_start_index + i].y = int( adjust_coord_for_split_screen( y ) );
				hud[bars_hud_start_index + i].alpha = 1;
				if ( y <= top_alpha_fade_y_end )
					hud[bars_hud_start_index + i].alpha = clamp (( y - top_alpha_fade_y_start ) / fade_range, 0, 1 );
				if ( y >= bottom_alpha_fade_y_start )
					hud[bars_hud_start_index + i].alpha = 1 - clamp (( y - bottom_alpha_fade_y_start ) / fade_range, 0, 1 );
			}
		}
		vartimer += 0.05;
		curvar += variation;
		if (vartimer >= varduration)
		{
			vartimer = 0;
			prevvar = tgtvar;
			tgtvar = RandomFloatRange(-0.1,0.1);
			variation = (tgtvar - prevvar)*0.05/varduration;
		}
		wait 0.05;
	}
}

create_hud_kias_line( x, y )
{
	hud = self createClientFontString( "default",  1.0 );
	hud.x = adjust_coord_for_split_screen( x );
	hud.y = adjust_coord_for_split_screen( y );
	hud.alignx = "right";
	hud.sort = 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = 1.0;
	hud.color = ( 1.0, 1.0, 1.0 );
	hud SetValue( 0 );
	
	return hud;
}

create_hud_kias()
{
	hud[0] = create_hud_kias_line( 80 + 40, 100);
	hud[1] = create_hud_kias_line( 80 + 40, 120);
	hud[2] = create_hud_kias_line( 80 + 40, 140);
	hud[3] = create_hud_kias_line( 80 + 40, 160);

	hud[4] = create_hud_text_line();
	hud[4].x = adjust_coord_for_split_screen( 30 + 20 + 30 );
	hud[4].y = adjust_coord_for_split_screen( 93 + 54 );
	hud[4] SetValue( 100 );

	bars_hud_start_index = 5;
	large_bar_every = 5;
	large_bar_countdown = 1;
	for ( i = 0; i < 25; i++ ) 
	{
		hud[bars_hud_start_index + i] = NewClientHudElem( self );
		hud[bars_hud_start_index + i].x = adjust_coord_for_split_screen( 95 + 40 );
		hud[bars_hud_start_index + i].y = adjust_coord_for_split_screen( i*11 + 135 );
		hud[bars_hud_start_index + i].alignx = "right";
		hud[bars_hud_start_index + i].sort = 1;
		hud[bars_hud_start_index + i].horzAlign = "fullscreen";
		hud[bars_hud_start_index + i].vertAlign = "fullscreen";
		hud[bars_hud_start_index + i].alpha = 1.0;
		
		large_bar_countdown = large_bar_countdown - 1;
		if ( large_bar_countdown == 0 )
		{
			hud[bars_hud_start_index + i] SetShader( "uav_predator2_horz_bar1", 8, 4 );
			large_bar_countdown = large_bar_every;
		}
		else
			hud[bars_hud_start_index + i] SetShader( "uav_predator2_horz_bar1", 6, 4 );
	}

	thread predator_hud_kias( hud );
	
	return hud;
}

predator_hud_alt( hud )
{
	self endon( "uav_cleanup_hud" );
	self endon( "death" );
	uav = maps\_remotemissile::get_uav();
	alt = 0;
	minalt = 0;
	maxalt = 1000;
	if (isdefined(uav))
	{
		alt = uav.origin[2];
		minalt = alt - 100;
		maxalt = alt + 100;
	}

	vartimer = 0;
	variation = 0;
	curvar = 0;
	tgtvar = 0;
	varduration = 4;
	vartimer = varduration;

	steps = 250;
	pixel_steps = 55;
	guage_center = 245;

	while (isdefined(hud))
	{
		uav = maps\_remotemissile::get_uav();
		if (isdefined(uav))
		{
			alt = uav.origin[2];
			ratio = (alt - minalt)/(maxalt-minalt);
			ratio += curvar;
			if (ratio < 0)
				ratio = 0;
			if (ratio > 1)
				ratio = 1;
			alt = minalt + ratio * (maxalt-minalt);

		    fade_range = pixel_steps / 2;
		    top_alpha_fade_y_start = guage_center - pixel_steps * 2;
		    top_alpha_fade_y_end = top_alpha_fade_y_start + fade_range;
		    bottom_alpha_fade_y_end = guage_center + pixel_steps * 2;
		    bottom_alpha_fade_y_start = bottom_alpha_fade_y_end - fade_range;
		    
		    part_step = alt - (int(alt / steps)) * steps; // = mod(steps)
		    mid = alt - part_step;
		    offset_y = int((part_step / steps) * pixel_steps);
		    hud[0] SetValue( mid + steps * 2);
		    y = guage_center + offset_y - 2 * pixel_steps;
		    hud[0].y = adjust_coord_for_split_screen( y );
		    hud[0].alpha = clamp (( y - top_alpha_fade_y_start ) / ( top_alpha_fade_y_end - top_alpha_fade_y_start ), 0, 1 );
		    hud[1] SetValue( mid + steps );
		    hud[1].y = adjust_coord_for_split_screen( guage_center + offset_y - pixel_steps );
		    hud[2] SetValue( mid );
		    hud[2].y = adjust_coord_for_split_screen( guage_center + offset_y );
		    hud[3] SetValue( mid - steps );
		    y = guage_center + offset_y + pixel_steps;
		    hud[3].y = adjust_coord_for_split_screen( y );
		    hud[3].alpha = 1 - clamp (( y - bottom_alpha_fade_y_start ) / ( bottom_alpha_fade_y_end - bottom_alpha_fade_y_start ), 0, 1 );

			bars_hud_start_index = 4;
			for ( i = 0; i < 25; i++ ) 
			{
				y = i*11 + 135 + offset_y - pixel_steps + 4; // +4 to center on the number
				hud[bars_hud_start_index + i].y = int( adjust_coord_for_split_screen( y ) );
				hud[bars_hud_start_index + i].alpha = 1;
				if ( y <= top_alpha_fade_y_end )
					hud[bars_hud_start_index + i].alpha = clamp (( y - top_alpha_fade_y_start ) / fade_range, 0, 1 );
				if ( y >= bottom_alpha_fade_y_start )
					hud[bars_hud_start_index + i].alpha = 1 - clamp (( y - bottom_alpha_fade_y_start ) / fade_range, 0, 1 );
			}
		}
		vartimer += 0.05;
		curvar += variation;
		if (vartimer >= varduration)
		{
			vartimer = 0;
			prevvar = tgtvar;
			tgtvar = RandomFloatRange(-0.1,0.1);
			variation = (tgtvar - prevvar)*0.05/varduration;
		}
		wait 0.05;
	}
}

create_hud_alt_line( x, y )
{
	hud = self createClientFontString( "default",  1.0 );
	hud.x = adjust_coord_for_split_screen( x );
	hud.y = adjust_coord_for_split_screen( y );
	hud.alignx = "left";
	hud.sort = 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = 1.0;
	hud.color = ( 1.0, 1.0, 1.0 );
	hud SetValue( 0 );
	
	return hud;
}

create_hud_alt()
{
	hud[0] = create_hud_alt_line( 565 - 40, 100);
	hud[1] = create_hud_alt_line( 565 - 40, 120);
	hud[2] = create_hud_alt_line( 565 - 40, 140);
	hud[3] = create_hud_alt_line( 565 - 40, 160);

	bars_hud_start_index = 4;
	large_bar_every = 5;
	large_bar_countdown = 1;
	for ( i = 0; i < 25; i++ ) 
	{
		hud[bars_hud_start_index + i] = NewClientHudElem( self );
		hud[bars_hud_start_index + i].x = adjust_coord_for_split_screen( 545 - 40 );
		hud[bars_hud_start_index + i].y = adjust_coord_for_split_screen( i*11 + 135 );
		hud[bars_hud_start_index + i].alignx = "left";
		hud[bars_hud_start_index + i].sort = 1;
		hud[bars_hud_start_index + i].horzAlign = "fullscreen";
		hud[bars_hud_start_index + i].vertAlign = "fullscreen";
		hud[bars_hud_start_index + i].alpha = 1.0;
		
		large_bar_countdown = large_bar_countdown - 1;
		if ( large_bar_countdown == 0 )
		{
			hud[bars_hud_start_index + i] SetShader( "uav_predator2_horz_bar1", 8, 4 );
			large_bar_countdown = large_bar_every;
		}
		else
			hud[bars_hud_start_index + i] SetShader( "uav_predator2_horz_bar1", 6, 4 );
	}

	thread predator_hud_alt( hud );
	
	return hud;
}

predator_hud_heading( arrow, text )
{
	self endon( "uav_cleanup_hud" );
	self endon( "death" );
	uav = maps\_remotemissile::get_uav();
	minheading = 0;
	maxheading = 360;
	
	while (isdefined(arrow))
	{
		uav = maps\_remotemissile::get_uav();
		if (isdefined(uav))
		{
			heading = uav.angles[1];
			heading = safemod( heading, 360 );
			ratio = (heading - minheading)/(maxheading-minheading);
			if (ratio < 0)
				ratio = 0;
			if (ratio > 1)
				ratio = 1;
			x = arrow.minx + ratio*(arrow.maxx-arrow.minx);
			arrow.x = adjust_coord_for_split_screen( x );

			text SetValue( heading );
		}
		wait 0.05;
	}
}

create_hud_heading()
{
	hud[0] = NewClientHudElem( self );
	hud[0].x = adjust_coord_for_split_screen( 320-16 );
	hud[0].y = adjust_coord_for_split_screen( 8 );
	hud[0].sort = 1;
	hud[0].horzAlign = "fullscreen";
	hud[0].vertAlign = "fullscreen";
	hud[0].alpha = 1.0;
	hud[0] SetShader( "uav_predator2_dir", 24, 16 );
	hud[0].minx = 200 - 12;
	hud[0].maxx = 440 - 12;

	hud[1] = NewClientHudElem( self );
	hud[1].x = adjust_coord_for_split_screen( 320 );
	hud[1].y = adjust_coord_for_split_screen( 36 );
	hud[1].alignx = "center";
	hud[1].aligny = "middle";
	hud[1].sort = 1;
	hud[1].horzAlign = "fullscreen";
	hud[1].vertAlign = "fullscreen";
	hud[1].alpha = 1.0;
	hud[1] SetShader( "uav_predator2_dirbar", 256, 32 );

	hud[2] = NewClientHudElem( self );
	hud[2].x = adjust_coord_for_split_screen( 320 );
	hud[2].y = adjust_coord_for_split_screen( 55 );
	hud[2].alignx = "center";
	hud[2].aligny = "middle";
	hud[2].sort = 1;
	hud[2].horzAlign = "fullscreen";
	hud[2].vertAlign = "fullscreen";
	hud[2].alpha = 1.0;
	hud[2] SetShader( "uav_predator2_heading_frame", 21, 32 );

	hud[3] = self createClientFontString( "default",  1.2 );
	hud[3].x = adjust_coord_for_split_screen( 320 );
	hud[3].y = adjust_coord_for_split_screen( 55 );
	hud[3].sort = 1;
	hud[3].horzAlign = "fullscreen";
	hud[3].vertAlign = "fullscreen";
	hud[3].alignx = "center";
	hud[3].aligny = "middle";
	hud[3].alpha = 1.0;
	hud[3].color = ( 0.56, 1.0, 0.52 );
	hud[3] SetValue( 215 );

	thread predator_hud_heading( hud[0], hud[3] );
	
	return hud;
}

create_hud_horz_indicator()
{
	hud = NewClientHudElem( self );
	hud.x = adjust_coord_for_split_screen( 272 );
	hud.y = adjust_coord_for_split_screen( 292 );
	hud.sort = 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = 1.0;
	hud SetShader( "uav_predator2_horz", 64, 64 );
	
	return hud;
}

create_hud_crosshair()
{
	hud = NewClientHudElem( self );
	hud.x = adjust_coord_for_split_screen( 320 );
	hud.y = adjust_coord_for_split_screen( 240 );
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.sort = 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.alpha = 1.0;
	hud SetShader( "uav_predator2_xhair", 205, 205 );
	
	return hud;
}

monitor_cluster ( missile )
{
	assert(isplayer(self));
	while ( isdefined ( missile ) )
	{
		if ( self adsbuttonPressed() )
		{
			missile thread start_cluster ( self );
		}
		
		wait 0.05;
	}
}

start_cluster ( player )
{
	player dodamage ( 1, player.origin );
	
	org = spawn ( "script_origin", ( 0, 0, 0 ) );
	org.origin = self.origin;
	org.angles = self.angles;
	self delete();
	
	for ( i = 0; i < 6; i++ )
	{
		wait randomfloatrange ( 0.1, 0.3 );
		forward = anglestoforward ( org.angles );
		right = anglestoright ( org.angles );
		up = anglestoup ( org.angles );
		x = randomintrange ( -64, 64 );
		y = randomintrange ( -64, 64 );
		z = randomintrange ( -64, -63 );
		cluster = magicgrenade ( "m203", org.origin, org.origin + ( x * forward + y * right + z * up ) );
		cluster thread cluster_explosion();
	}
	
	org delete();
	
}

cluster_explosion()
{
	org = spawn ( "script_origin", ( 0, 0, 0 ) );
	
	while ( isdefined ( self ) )
	{
		org.origin = self.origin;
		wait 0.05;
	}
	
	playfx ( level._effect[ "slamraam_explosion"], org.origin );
	radiusdamage( org.origin + ( 0, 0, 128 ), 512, 200, 200 );
	earthquake( 0.4, 1, org.origin, 1000 );
	org playsound( "detpack_explo_main", "sound_done" );
	
	org delete();
}