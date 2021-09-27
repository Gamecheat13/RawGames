#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;


uav_init()
{
	level.uav_sort = -5;
	level.uav_fontscale = 1.25;
	level.uav_fake_elevation = 16500 * 12;
	PrecacheShader( "uav_crosshair" );
	PrecacheShader( "uav_vertical_meter" );
	PrecacheShader( "uav_horizontal_meter" );
	PreCacheShader( "overlay_grain" );
	PrecacheShader( "uav_arrow_up" );
	PrecacheShader( "uav_arrow_left" );
	PrecacheShader( "ac130_thermal_overlay_bar" );

	SetSavedDvar( "thermalBlurFactorNoScope", 50 );

	flag_init( "uav_hud_enabled" );
}

uav_spawn_and_use( msg, player, targetent_start_origin )
{
	uav = spawn_vehicle_from_targetname_and_drive( msg );
	uav uav_useby( player, targetent_start_origin );
	return uav;
}

uav_useby( player, targetent_start_origin )
{
	self.player = player;

	self.view_controller = get_player_view_controller( self, "tag_origin", ( 0, 0, -8 ), "player_view_controller" );

	self.view_controller_parent = Spawn( "script_origin", self.view_controller.origin );
	self.view_controller LinkTo( self.view_controller_parent );

	self thread uav_draw_targets();

	origin = self.origin + ( 0, 0, -1000 );
	if ( IsDefined( targetent_start_origin ) )
	{
		origin = targetent_start_origin;
	}

	self.target_ent = Spawn( "script_origin", origin );
	self.view_controller SnapToTargetEntity( self.target_ent );

	self.view_controller_parent thread update_controller_pos( self );

	player uav_enable_view();

	player UnLink();
	if ( IsDefined( self.fake_controller ) )
	{
		self.view_rig = uav_rig_controller( self.fake_controller );
	}
	else
	{
		self.view_rig = uav_rig_controller( self.view_controller );
	}

	player PlayerLinkToDelta( self.view_controller, "tag_player", 1, 0, 0, 0, 0, true );
	self.view_rig UseBy( player );
	level.player DisableTurretDismount();

	self thread uav_delete_ondeath();
	self thread uav_hud_thread();
	self Hide();
}

update_controller_pos( vehicle )
{
	self endon( "death" );
	self endon( "stop_update_controller_pos" );
	vehicle endon( "death" );
	rate = 0.1;
	offset = ( 0, 0, -8 );
	while ( 1 )
	{
		self MoveTo( vehicle.origin + offset, rate );
		angles = VectorToAngles( vehicle.target_ent.origin - self.origin );
		self RotateTo( angles, rate );
		wait( rate );
	}
}

uav_rig_controller( ent, turret )
{
	tag = "tag_aim";
	origin = ent GetTagOrigin( tag );
	angles = ent GetTagAngles( tag );

	if ( !IsDefined( turret ) )
	{
		turret = "player_view_controller_uav";
	}
	
	rig = SpawnTurret( "misc_turret", origin, turret );
	rig.angles = angles;
	rig SetModel( "tag_turret" );
	rig LinkTo( ent, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	rig MakeUnusable();
	rig Hide();
	rig SetMode( "manual" );
	rig TurretFireDisable();

	return rig;
}

uav_hud_thread()
{
	self endon( "death" );

	self.player thread uav_hud_scanline();

	rate = 0.1;

	self.base_latitude 		= get_float_from_degrees( 51, 30, 11.58 );
	self.base_longitude 	= get_float_from_degrees( 0, 0, 56.06 );
	self.base_x = self.origin[ 0 ];
	self.base_y = self.origin[ 1 ];

	while ( 1 )
	{
		if ( flag( "uav_hud_enabled" ) )
		{
			// Target data
			range = Distance( self.view_controller.origin + ( 0, 0, level.uav_fake_elevation ), self.target_ent.origin );
			range = to_meters( range );
			self.player uav_set_target_hud_data( "brg", AngleClamp( int( ( self.angles[ 1 ] - 90 ) ) * -1 ) ); // 90 is north
			self.player uav_set_target_hud_data( "rng_m", int( range ) );
			self.player uav_set_target_hud_data( "rng_nm", round_to( meters_to_nm( range ), 1000 ) );
			self.player uav_set_target_hud_data( "elv", int( to_feet( self.target_ent.origin[ 2 ] ) ) );

			// Camera Arrows
			self uav_update_hud_arrows( rate );

			// Longitude/Latitude
			degrees = update_current_degrees();
			degrees = update_target_degrees();
		}

		wait( rate );
	}
}

uav_hud_scanline()
{
	hud = self.uav_huds[ "scanline" ];
	hud endon( "death" );

	min_height = 80;
	max_height = 280;
	min_time = 7;
	max_time = 15;
	start_y = -100;
	end_y = 480 + 100;
	while ( 1 )
	{
		hud.y = start_y;
		height = RandomIntRange( min_height, max_height );
		hud SetShader( "ac130_thermal_overlay_bar", 640, height );

		time = RandomFloatRange( min_time, max_time );
		
		hud MoveOverTime( time );
		hud.y = end_y;

		wait( time );
	}
}

uav_update_hud_arrows( rate )
{
	player_angles = self.player GetPlayerAngles();
	pitch = self.angles[ 0 ] - player_angles[ 0 ] * -1;
	yaw = AngleClamp180( self.angles[ 1 ] - player_angles[ 1 ] );

	self.player uav_set_hud_data( "arrow_left", int( pitch ) );
	self.player uav_set_hud_data( "arrow_up", int( yaw ) );

	// Left Arrow
	hud_vert_meter = self.player.uav_huds[ "vert_meter" ];
	hud_left_arrow = self.player.uav_huds[ "arrow_left" ];

	pitch = Clamp( pitch, hud_vert_meter.min_value, hud_vert_meter.max_value );
	percent = abs( pitch / hud_vert_meter.range );
	meter_pos = hud_vert_meter.meter_size * percent;
	offset = meter_pos - ( hud_vert_meter.meter_size * 0.5 );
	y = hud_vert_meter.y + offset;

	hud_left_arrow MoveOverTime( 0.2 );
	hud_left_arrow.y = y;
	hud_left_arrow.data_value MoveOverTime( rate );
	hud_left_arrow.data_value.y = y;

	// Up Arrow
	hud_horz_meter = self.player.uav_huds[ "horz_meter" ];
	hud_up_arrow = self.player.uav_huds[ "arrow_up" ];

	percent = yaw / hud_horz_meter.range;
	meter_pos = hud_horz_meter.meter_size * percent;
	x = hud_horz_meter.x + meter_pos;

	hud_up_arrow MoveOverTime( 0.2 );
	hud_up_arrow.x = x;
	hud_up_arrow.data_value MoveOverTime( rate );
	hud_up_arrow.data_value.x = x;
}

update_current_degrees()
{
	x_delta = self.origin[ 0 ] - self.base_x;
	y_delta = self.origin[ 1 ] - self.base_y;

	deltas = get_inches_per_degree( get_degree_delta( y_delta ) );

	long_delta = x_delta / deltas[ 0 ];
	lat_delta = y_delta / deltas[ 1 ];

	long = get_degree_from_float( self.base_longitude - long_delta );
	lat = get_degree_from_float( self.base_latitude - lat_delta );

	self.player uav_set_hud_degrees( "upper_right", "lat", lat );
	self.player uav_set_hud_degrees( "upper_right", "long", long );
}

update_target_degrees()
{
	pos = level.player.origin + ( AnglesToForward( level.player GetPlayerAngles() ) * 10000 );
	trace = BulletTrace( level.player GetEye(), pos, true, level.player );
	origin = trace[ "position" ];

	x_delta = origin[ 0 ] - self.base_x;
	y_delta = origin[ 1 ] - self.base_y;

	deltas = get_inches_per_degree( get_degree_delta( y_delta ) );

	long_delta = x_delta / deltas[ 0 ];
	lat_delta = y_delta / deltas[ 1 ];

	long = get_degree_from_float( self.base_longitude - long_delta );
	lat = get_degree_from_float( self.base_latitude - lat_delta );

	self.player uav_set_hud_degrees( "lower_right", "lat", lat );
	self.player uav_set_hud_degrees( "lower_right", "long", long );
}

get_degree_delta( y_movement_in_inches )
{
	return y_movement_in_inches / 4370078.74;
}

get_degree_from_float( latitude )
{
	degrees = 0;
	minutes = 0;
	seconds = 0;
	
	degrees = floor( latitude );
	latitude -= degrees;
	latitude *= 60.0;
	minutes = floor( latitude );
	latitude -= minutes;
	latitude *= 60.0;
	seconds = round_to( latitude, 1000 );

	// Make sure it is always 3 digits
	num = seconds * 100;
	if ( num - int( num ) == 0 )
	{
		seconds += 0.001;
	}

	return [ degrees, minutes, seconds ];
}

get_float_from_degrees( degrees, minutes, seconds )
{
	f_latitude = 0;

	f_latitude = seconds / 60;
	f_latitude += minutes;
	f_latitude /= 60;
	f_latitude += degrees;

	return f_latitude;
}

get_inches_per_degree( latitude )
{
	lat_table = [ 4353307.09, 4356259.84, 4364251.97, 4375275.59, 4386299.21, 4394409.45, 4397401.57 ];
	lat_diff_table = [ 2952.75, 7992.13, 11023.62,  11023.62, 8110.24, 2992.12, 0 ];
	long_table = [ 4382677.17, 4234291.34, 3798661.42, 3104212.6, 2196850.39, 1137874.02, 0.0 ];
	long_diff_table = [ -148385.83, -435629.92, -694448.82, -907362.21, -1058976.37,  -1137874.02, 0.0 ];

 	num_table_entries = 7;

    scaled_index = abs( latitude ) * num_table_entries / 90.0; //num_table_entries is 7 for the table above
    base_index = int( floor( scaled_index ) );
    lerp_ratio = ( scaled_index - base_index ) * num_table_entries;

    lat_delta = lat_table[ base_index ]  + ( lerp_ratio * lat_diff_table[ base_index ] );
    long_delta = long_table[ base_index ]  + ( lerp_ratio * long_diff_table[ base_index ] );

    return [ long_delta, lat_delta ];
}

to_feet( val )
{
	return val * 12;
}

to_meters( val )
{
	return val * 0.0254;
}

meters_to_nm( val )
{
	return val * 0.000539956803;
}

round_to( val, mult )
{
	val = int( val * mult ) / mult;
	return val;
}

uav_delete_ondeath()
{
	self waittill( "death" );

	if ( IsDefined( self.view_rig ) )
	{
		self.view_rig Delete();
	}

	if ( IsDefined( self.view_controller ) )
	{
		self.view_controller Delete();
	}

	if ( IsDefined( self.view_controller_parent ) )
	{
		self.view_controller_parent Delete();
	}	
}

uav_enable_playerhud()
{
	SetSavedDvar( "compass", "1" );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "actionSlotsHide", "0" );
}

uav_disable_playerhud()
{
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "actionSlotsHide", "1" );
}

uav_enable_view( time, skip_thermal )
{
//	level.uav_hud_color = ( 0.338, 0.637, 0.344 );
	level.uav_hud_color = ( 1, 1, 1 );
	uav_disable_playerhud();
	self.uav_huds = [];
	self.uav_huds[ "static_hud" ] 	= create_hud_static_overlay( time );
	self.uav_huds[ "scanline" ]		= create_hud_scanline_overlay( time );
	self.uav_huds[ "horz_meter" ] 	= create_hud_horizontal_meter( time );
	self.uav_huds[ "vert_meter" ] 	= create_hud_vertical_meter( time );
	self.uav_huds[ "crosshair" ] 	= create_hud_crosshair( time );

	self.uav_huds[ "upper_left" ]	= create_hud_upper_left( time );
	self.uav_huds[ "upper_right" ]	= create_hud_upper_right( time );
	self.uav_huds[ "lower_right" ]	= create_hud_lower_right( time );
	self.uav_huds[ "arrow_left" ]   = create_hud_arrow( "left", time );
	self.uav_huds[ "arrow_up" ]   = create_hud_arrow( "up", time );

	// Store some settings
	self.uav_huds[ "vert_meter" ].meter_size = 96;
	self.uav_huds[ "vert_meter" ].min_value = 10;
	self.uav_huds[ "vert_meter" ].max_value = 90;
	self.uav_huds[ "vert_meter" ].range = self.uav_huds[ "vert_meter" ].max_value - self.uav_huds[ "vert_meter" ].min_value;

	self.uav_huds[ "horz_meter" ].meter_size = 96;
	self.uav_huds[ "horz_meter" ].min_value = -180;
	self.uav_huds[ "horz_meter" ].max_value = 180;
	self.uav_huds[ "horz_meter" ].range = self.uav_huds[ "horz_meter" ].max_value - self.uav_huds[ "horz_meter" ].min_value;;

	self DisableWeapons();
	self DisableOffhandWeapons();
	self FreezeControls( true );

	SetSavedDvar( "sm_sunsamplesizenear", "1" );
	SetSavedDvar( "sm_cameraoffset", "3400" );

	flag_set( "uav_hud_enabled" );

	if ( !IsDefined( skip_thermal ) )
	{
		self uav_thermal_on( time );
	}
}

hud_fade_in_time( time, val )
{
	if ( !IsDefined( time ) )
	{
		return false;
	}

	if ( !IsDefined( val ) )
	{
		val = 1;
	}

	self.alpha = 0;
	self FadeOverTime( time );
	self.alpha = val;

	return true;
}

create_hud_static_overlay( time )
{
	hud = NewHudElem();
	hud.x = 0;
	hud.y = 0;
	hud.sort = level.uav_sort;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud SetShader( "overlay_grain", 640, 480 );

	if ( !hud hud_fade_in_time( time, 0.3 ) )
	{
		hud.alpha = 0.3;
	}

	return hud;
}

create_hud_scanline_overlay( time )
{
	hud = NewHudElem();
	hud.x = 0;
	hud.y = 0;
	hud.sort = level.uav_sort + 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud SetShader( "ac130_thermal_overlay_bar", 640, 100 );

	if ( !hud hud_fade_in_time( time, 1 ) )
	{
		hud.alpha = 1;
	}

	return hud;
}

create_hud_horizontal_meter( time )
{
	hud = NewHudElem();
	hud.x = 320;
	hud.y = 40;
	hud.sort = level.uav_sort;
	hud.alignX = "center";
	hud.alignY = "bottom";
	hud.color = level.uav_hud_color;
	hud SetShader( "uav_horizontal_meter", 96, 16 );

	hud hud_fade_in_time( time );

	return hud;
}

create_hud_vertical_meter( time )
{
	hud = NewHudElem();
	hud.x = 40;
	hud.y = 240;
	hud.sort = level.uav_sort;
	hud.alignX = "right";
	hud.alignY = "middle";
	hud.color = level.uav_hud_color;

	if ( GetDvarInt( "widescreen" ) != 1 )
	{
		hud.horzalign = "left";
		hud.vertalign = "top";
	}

	hud SetShader( "uav_vertical_meter", 16, 96 );

	hud hud_fade_in_time( time );

	return hud;
}

create_hud_crosshair( time )
{
	hud = NewHudElem();
	hud.x = 320;
	hud.y = 240;
	hud.sort = level.uav_sort;
	hud.alignX = "center";
	hud.alignY = "middle";

	hud SetShader( "uav_crosshair", 320, 240 );

	hud hud_fade_in_time( time );

	return hud;
}

uav_set_target_hud_data( index, value )
{
	self.uav_huds[ "lower_right" ][ index ].data_value SetValue( value );
}

uav_set_hud_degrees( index, ref, degrees )
{
	huds = self.uav_huds[ index ][ ref ].degrees;
	huds[ "deg" ] SetValue( degrees[ 0 ] );
	huds[ "min" ] SetValue( degrees[ 1 ] );
	huds[ "sec" ] SetValue( degrees[ 2 ] );
}

uav_set_hud_data( index, value )
{
	self.uav_huds[ index ].data_value SetValue( value );
}

create_hud_upper_left( time )
{
	data = [];
	data[ "nar" ]  		= [ &"UAV_NAR", "none" ];	//
	data[ "white" ]  	= [ &"UAV_WHT", "none" ];	//
	data[ "rate" ] 		= [ &"UAV_RATE", "none" ];	//
	data[ "angle" ] 	= [ &"UAV_RATIO", "none" ];	//
	data[ "numbers" ] 	= [ &"UAV_ABOVE_TEMP_NUMBERS", "none" ];	//
	data[ "temp" ] 		= [ &"UAV_TEMP", "none" ];	//

//	if ( GetDvar( "widescreen" ) )
//	{
//		x = 10;
//	}
//	else
//	{
//		x = 
//	}

	huds = create_hud_section( data, 10, 80, "left", time );

	if ( GetDvarInt( "widescreen" ) != 1 )
	{
		foreach ( hud in huds )
		{
			hud.horzalign = "left";
			hud.vertalign = "top";
		}
	}
	
	return huds;
}

create_hud_upper_right( time )
{
	data = [];
	data[ "acft" ]  	= [ &"UAV_ACFT", "none" ];	//
	data[ "lat" ] 		= [ &"UAV_N", "none" ];	//
	data[ "long" ]  	= [ &"UAV_W", "none" ];	//
	data[ "angle" ] 	= [ &"UAV_HAT", "none" ];	//

	huds = create_hud_section( data, 510, 80, "left", time );

	deg_huds = [ huds[ "lat" ], huds[ "long" ] ];
	create_degree_values( deg_huds );

	return huds;
}

create_hud_lower_right( time )
{
	y_offset = 30;

	data = [];
	data[ "lat" ] 		= [ &"UAV_N", "none" ];	//
	data[ "long" ]  	= [ &"UAV_W", "none" ];	//

	huds = create_hud_section( data, 500, 335 - y_offset, "left", time );
	create_degree_values( huds );

	data = [];
	data[ "brg" ] 		= [ &"UAV_BRG", "" ];			// Bearing
	data[ "rng_m" ]  	= [ &"UAV_RNG", &"UAV_M" ];		// Range Meters
	data[ "rng_nm" ] 	= [ &"UAV_RNG", &"UAV_NM" ];	// Range Nautical Miles
	data[ "elv" ] 	 	= [ &"UAV_ELV", &"UAV_F" ];		// Elevation Feet

	huds2 = create_hud_section( data, 510, 360 - y_offset, "right", time );

	foreach ( idx, hud in huds2 )
	{
		huds[ idx ] = hud;
	}

	return huds;
}

create_hud_section( data, x, y, align_x, time )
{
	huds = [];

	spacing = 10 * level.uav_fontscale;
	foreach ( i, item in data )
	{
		hud = NewHudElem();
		hud.x = x;
		hud.y = y;
		hud.sort = level.uav_sort;
		hud.alignX = align_x;
		hud.alignY = "middle";
		hud.fontscale = level.uav_fontscale;
		hud.color = level.uav_hud_color;
		hud SetText( item[ 0 ] );

		if ( IsDefined( item[ 1 ] ) )
		{
			if ( !string_is_valid( item[ 1 ], "none" ) )
			{
				hud create_hud_data_value( item[ 1 ], time );
			}
		}
		else
		{
			hud create_hud_data_value( undefined, time );
		}

		hud hud_fade_in_time( time );

		huds[ i ] = hud;

		y += spacing;
	}

	return huds;
}

create_degree_value( val, is_string, x_offset )
{
	hud = NewHudElem();
	hud.x = self.x + 30 + x_offset;
	hud.y = self.y;
	hud.sort = level.uav_sort;
	hud.alignX = "right";
	hud.alignY = "middle";
	hud.fontscale = level.uav_fontscale;
	hud.color = level.uav_hud_color;

	if ( is_string )
	{
		hud SetText( val );
	}
	else
	{
		hud SetValue( val );
	}

	return hud;
}

create_degree_values( huds )
{
	foreach ( hud in huds )
	{
		hud.degrees = [];

		hud.degrees[ "deg" ] 		= hud create_degree_value( 0, false, 0 );
		hud.degrees[ "deg_str" ] 	= hud create_degree_value( &"UAV_DEGREE", true, 2 );
		hud.degrees[ "min" ] 		= hud create_degree_value( 0, false, 20 );
		hud.degrees[ "min_str" ] 	= hud create_degree_value( &"UAV_DEGREE", true, 20 + 2 );
		hud.degrees[ "sec" ] 		= hud create_degree_value( 0, false, 60 );
		hud.degrees[ "sec_str" ] 	= hud create_degree_value( &"UAV_QUOTE", true, 60 + 3 );
	}
}

string_is_valid( str, test )
{
	if ( IsString( str ) )
	{
		if ( str == test )
		{
			return true;
		}
	}

	return false;
}

create_hud_data_value( suffix, time )
{
	x_add = 75;

	if ( IsDefined( suffix ) && !string_is_valid( suffix, "" ) )
	{
		data_value_suffix = NewHudElem();
		data_value_suffix.x = self.x + x_add;
		data_value_suffix.y = self.y;
		data_value_suffix.alignX = "right";
		data_value_suffix.alignY = "middle";
		data_value_suffix.fontscale = level.uav_fontscale;
		data_value_suffix.color = level.uav_hud_color;
		data_value_suffix.sort = level.uav_sort;
		data_value_suffix SetText( suffix );

		self.data_value_suffix = data_value_suffix;

		size = 1;
		if ( suffix == &"UAV_NM" )
		{
			size = 2;
		}

		data_value_suffix hud_fade_in_time( time );

		x_add -= 10 * size;	
	}

	data_value = NewHudElem();
	data_value.x = self.x + x_add;
	data_value.y = self.y;
	data_value.alignX = "right";
	data_value.alignY = "middle";
	data_value.fontscale = level.uav_fontscale;
	data_value.color = level.uav_hud_color;
	data_value.sort = level.uav_sort;
	data_value SetValue( 0 );

	data_value hud_fade_in_time( time );

	self.data_value = data_value;
}

create_hud_arrow( dir, time )
{
	if ( dir == "up" )
	{
		shader = "uav_arrow_up";
		parent_hud = self.uav_huds[ "horz_meter" ];
		x = 320;
		y = parent_hud.y + 10;
		x_align = "center";
		y_align = "top";
	}
	else
	{
		shader = "uav_arrow_left";
		parent_hud = self.uav_huds[ "vert_meter" ];
		x = parent_hud.x + 10;
		y = 240;
		x_align = "left";
		y_align = "middle";
	}

	hud = NewHudElem();
	hud.x = x;
	hud.y = y;
	hud.alignX = x_align;
	hud.alignY = y_align;
	hud.sort = level.uav_sort;
	hud SetShader( shader, 16, 16 );

	if ( GetDvarInt( "widescreen" ) != 1 )
	{
		if ( dir == "left" )
		{
			hud.horzalign = "left";
			hud.vertalign = "top";
		}
	}

	hud hud_fade_in_time( time );

	hud create_hud_arrow_value( dir, time );

	return hud;	
}

create_hud_arrow_value( dir, time )
{
	if ( dir == "up" )
	{
		x = self.x;
		y = self.y + 16;
		x_align = "center";
		y_align = "top";
	}
	else
	{
		x = self.x + 16;
		y = self.y;
		x_align = "left";
		y_align = "middle";
	}

	data_value = NewHudElem();
	data_value.x = x;
	data_value.y = y;
	data_value.alignX = x_align;
	data_value.alignY = y_align;
	data_value.sort = level.uav_sort;
	data_value SetValue( 0 );


	if ( GetDvarInt( "widescreen" ) != 1 )
	{
		if ( dir == "left" )
		{
			data_value.horzalign = "left";
			data_value.vertalign = "top";
		}
	}

	data_value hud_fade_in_time( time );

	self.data_value = data_value;
}

uav_view_cone_open( duration, left, right, up, down )
{
	level.player LerpViewAngleClamp( duration, duration * 0.5, duration * 0.5, left, right, up, down );
}

uav_disable_view( duration )
{
	flag_clear( "uav_hud_enabled" );
	uav_enable_playerhud();

	foreach ( hud in self.uav_huds )
	{
		if ( IsArray( hud ) )
		{
			foreach ( elem in hud )
			{
				uav_destroy_hud( elem, duration );
			}

			hud = undefined;
		}
		else
		{
			uav_destroy_hud( hud, duration );
		}
	}

	self uav_thermal_off();

	if ( !IsDefined( duration ) )
	{
		duration = 0.05;
	}

	SetSavedDvar( "sm_sunenable", 1.0 );
}

uav_destroy_hud( hud, duration )
{
	if ( IsDefined( hud.degrees ) )
	{
		foreach ( deg_hud in hud.degrees )
		{
			deg_hud thread uav_destroy_hud_wrapper( duration );
		}
	}

	if ( IsDefined( hud.data_value ) )
	{
		hud.data_value thread uav_destroy_hud_wrapper( duration );
	}

	if ( IsDefined( hud.data_value_suffix ) )
	{
		hud.data_value_suffix thread uav_destroy_hud_wrapper( duration );
	}

	if ( IsDefined( hud.data_value ) )
	{
	}

	hud thread uav_destroy_hud_wrapper( duration );
}

uav_destroy_hud_wrapper( duration )
{
	if ( IsDefined( duration ) )
	{
		self FadeOverTime( duration );
		self.alpha = 0;
		wait( duration );
	}

	self Destroy();
}

uav_enable_weapons()
{
	self EnableWeapons();
	self EnableOffhandWeapons();
	self FreezeControls( false );
}

uav_thermal_on( time )
{
	if ( IsDefined( time ) )
	{
//		self VisionSetThermalForPlayer( "ac130", time );
		self VisionSetThermalForPlayer( "uav_flir_Thermal", time );
	}
	else
	{
		self VisionSetThermalForPlayer( "uav_flir_Thermal", 0.25 );
	}

	self maps\_load::thermal_EffectsOn();
	self ThermalVisionOn();
}

uav_thermal_off()
{
	self maps\_load::thermal_EffectsOff();
	self ThermalVisionOff();
}

uav_target_tracking( ent, diff_override, forward_offset )
{
	self endon( "death" );
	self notify( "stop_uav_target_tracking" );
	self endon( "stop_uav_target_tracking" );

	diff = 0.94;
	time = 0.2;

	if ( IsDefined( diff_override ) )
	{
		diff = diff_override;
	}

//	self.target_ent thread draw_tracking( ent );

	while ( 1 )
	{
		dest = ent.origin + ( 0, 0, 60 );

		if ( IsDefined( forward_offset ) )
		{
			forward = AnglesToForward( ent.angles );
			dest = ent.origin + ( forward * forward_offset );
		}

		origin = ( self.target_ent.origin * diff ) + ( dest * ( 1.0 - diff ) );

		self.target_ent MoveTo( origin, time );
		wait( time );
	}
}

draw_tracking( ent )
{
/#
	self endon( "death" );
	self endon( "stop_uav_target_tracking" );

	while ( 1 )
	{
		Line( ent.origin, self.origin );
		wait( 0.05 );
	}
#/
}

uav_add_target()
{
	if ( !IsDefined( level.uav_targets ) )
	{
		level.uav_targets = [];
	}

//	self.lag_target = Spawn( "script_origin", self.origin );
//	self.lag_target thread uav_lag_target_thread();	

	level.uav_targets[ self.unique_id ] = self;
}

uav_lag_target_thread( parent )
{
	while ( IsDefined( parent ) && IsAlive( parent ) )
	{
		wait( 0.5 );
		self.origin = parent.origin;
	}

	self Delete();
}

uav_clear_targets()
{
	level notify( "stop_draw_uav_targets" );

	foreach ( target in level.uav_targets )
	{
		if ( !IsDefined( target ) )
		{
			continue;
		}

		target uav_remove_target();
	}

	level.uav_targets = undefined;
}

uav_remove_target_ondeath()
{
	id = self.unique_id;
	self waittill( "death" );

	if ( IsDefined( level.uav_targets ) )
	{
		level.uav_targets[ id ] = undefined;
	}

	if ( IsDefined( self ) && IsDefined( self.has_target_shader ) )
	{
		if ( IsDefined( self.lag_target ) )
		{
			Target_Remove( self.lag_target );
		}
		else
		{
			Target_Remove( self );
		}
	}
}

uav_remove_target()
{
	if ( IsDefined( self.has_target_shader ) )
	{
		self.has_target_shader = undefined;
		Target_Remove( self );
	}

	level.uav_targets[ self.unique_id ] = undefined;
}

uav_draw_targets()
{
	level endon( "stop_draw_uav_targets" );

	if ( !IsDefined( level.uav_targets ) )
	{
		level.uav_targets = [];
	}

	targets_per_frame = 2;
	targets_drawn = 0;
	delay = 1;

	while ( 1 )
	{
		foreach ( target in level.uav_targets )
		{
			if ( !IsDefined( target ) )
			{
				continue;
			}

			if ( !target draw_target( self.player ) )
			{
				continue;
			}

			quick_count = 0;
			targets_drawn++;
			if ( targets_drawn >= targets_per_frame )
			{
				targets_drawn = 0;
				wait( delay );
			}
		}

		wait( 0.05 );
	}
}

draw_target( player )
{
	if ( IsDefined( self.has_target_shader ) && self.has_target_shader )
	{
		return false;
	}

	self.has_target_shader = true;

	Target_Set( self );

	if ( IsAI( self ) )
	{
		if ( self.team == "axis" )
		{
			Target_SetShader( self, "uav_enemy_target" );
			Target_SetScaledRenderMode( self, true );
			Target_DrawCornersOnly( self, true );
		}
		else
		{
			Target_SetShader( self, "veh_hud_friendly" );
		}
	}
	else if ( IsPlayer( self ) ) // Make sure you add the player to the level.remote_missile_targets before use
	{
		Target_SetShader( self, "hud_fofbox_self_sp" );
	}
	else if ( self.code_classname == "script_vehicle" )
	{
		Target_SetShader( self, "uav_vehicle_target" );
	}
	else
	{
		Target_SetShader( self, "uav_enemy_target" );
	}

	Target_ShowToPlayer( self, player );

	return true;
}