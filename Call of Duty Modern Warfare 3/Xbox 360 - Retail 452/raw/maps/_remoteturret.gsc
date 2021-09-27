#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;


// Pass an array where the keys to the array are the .script_startname
// param on the turret and the corresponding values are the localized
// text reference. I wish there was a way to create a localized text
// reference out of a string variable... bleh
precache_cam_names( localize_table )
{
	AssertEx( IsDefined( localize_table ) && IsArray( localize_table ) && localize_table.size, "Invalid localize_table array." );
	if ( !IsDefined( localize_table ) || !IsArray( localize_table ) )
		return;
	
	level._remoteturret_loc_table = localize_table;
	
	terminals = get_terminals();
	foreach ( terminal in terminals )
	{
		turrets = terminal get_linked_ents();
		foreach ( turret in turrets )
		{
			AssertEx( IsDefined( localize_table[ turret.script_startname ] ), "script_startname param set on turret that was not passed to precache_cam_names()" );
			if ( IsDefined( localize_table[ turret.script_startname ] ) )
			{
				PreCacheString( localize_table[ turret.script_startname ] );
			}
		}
	}
}

init()
{
	PrecacheShader( "uav_crosshair" );
	PrecacheShader( "uav_vertical_meter" );
	PrecacheShader( "uav_horizontal_meter" );
	PreCacheShader( "overlay_grain" );
	PrecacheShader( "uav_arrow_up" );
	PrecacheShader( "uav_arrow_left" );
	PrecacheShader( "ac130_thermal_overlay_bar" );
	
	terminals = get_terminals();
	array_thread( terminals, ::remote_turret_terminal_think );
	
	foreach ( player in level.players )
	{	
		player ent_flag_init( "on_remote_turret" );
	}
	
	flag_init( "_remoteturret_manual_getoff" );
	flag_init( "_remoteturret_nofade" );
	
	flag_set( "_remoteturret_manual_getoff" );
}

get_terminals()
{
	return getentarray( "remote_turret_terminal", "targetname" );
}

remote_turret_terminal_think()
{
	trigger = Spawn( "script_model", self.origin );	
	
	self.trigger = trigger;
	self.lastTurretIndex = 0;	

	self._remote_turrets = self get_linked_ents();
	array_thread( self._remote_turrets, ::setup_turret, self );
	
	trigger.angles = self.angles;
	trigger setModel( "com_laptop_2_open_obj" );
	trigger makeUsable();
	trigger SetHintString( &"PLATFORM_HOLD_TO_USE" );
	
	while( 1 )
	{
		trigger waittill( "trigger", guy );
		trigger trigger_off();
		guy thread play_sound_on_entity( "intelligence_pickup" );
		guy thread remote_turret_loop( self );
		guy waittill( "get_off_turret" );
		trigger trigger_on();
	}
}

remote_turret_loop( terminal )
{	
	self endon( "transfer_terminal" );
	
	if ( flag( "_remoteturret_manual_getoff" ) )
		self NotifyOnPlayerCommand( "get_off_turret", "+stance" );
	
	if ( terminal._remote_turrets.size > 1 )
		self thread turret_switch_input_loop( terminal );
		
	self thread remote_turret_enable( terminal._remote_turrets[ terminal.lastTurretIndex ], terminal );
	
	self thread	cancel_on_player_damage();
	self waittill( "get_off_turret" );
	self thread remote_turret_disable( terminal._remote_turrets[ terminal.lastTurretIndex ], terminal );
		
	self ent_flag_waitopen( "on_remote_turret" );
}

turret_switch_input_loop( terminal )
{
	self endon( "no_switching_allowed" );
	self endon( "get_off_turret" );
	self NotifyOnPlayerCommand( "next_turret", "weapnext" );
	
	waittillframeend; //give tirret time to initialize
	
	while( 1 )
	{
		self waittill( "next_turret" );
		if ( self ent_flag( "on_remote_turret" ) )
		{
			self remote_turret_next( terminal );
		}
	}
}

setup_turret( terminal )
{
	turret = self;
	turret MakeUnusable();
	turret.isSentryGun	= true;		// Required by _spawner::deathFunctions() when checking to see if a sentry killed the ai
	
	if ( isdefined( turret.target ) )
	{
		targ = turret get_target_ent();
		turret.last_look_origin = targ.origin;
	}

	if ( !isDefined( turret.leftArc ) )
		turret.leftArc = 70;

	if ( !isDefined( turret.rightArc ) )
		turret.rightArc = 70;

	if ( !isDefined( turret.topArc ) )
		turret.topArc = 60;

	if ( !isDefined( turret.bottomArc ) )
		turret.bottomArc = 60;

	turret setRightArc( turret.rightArc );
	turret setLeftArc( turret.rightArc );
	turret setTopArc( turret.topArc );
	turret setBottomArc( turret.bottomArc );

	turret.terminal = terminal;

	turret.turret = SpawnTurret( "misc_turret", turret.origin, turret.weaponInfo );
	turret.turret.angles = turret.angles;
	turret.turret SetModel( turret.model );
	turret.turret Hide();
	turret.turret MakeUnusable();
	turret.turret SetDefaultDropPitch( 0 );
}

player_turret_shoot( turret )
{
	turret endon( "stop_use_turret" );
	
	while( 1 )
	{
		while ( !self AttackButtonPressed() )
			wait( 0.05 );
		turret ShootTurret();
		turret notify( "create_badplace" );
		wait( 0.05 );
	}
}

player_look_aim( turret, org )
{
	turret endon( "stop_use_turret" );
	
	ai = getaiarray( "axis" );
	new_origin = turret getTagOrigin( "tag_player" );
	turret SetMode( "manual" );
	turret setTargetEntity( org );
	while( 1 )
	{
		angles = self getPlayerAngles();
		end = AnglesToForward( angles );
		spot = new_origin + (end * 999999);
		org.origin = spot;
		turret.last_look_origin = spot;
		wait( 0.1 );
	}
}

FADE_OUT_TIME = 0.2;
FADE_IN_TIME = 0.3;

remote_turret_enable( turret, terminal )
{
	self endon( "get_off_turret" );
	
	turret.attacker	= self;		// Required by _spawner::deathFunctions() when checking to see if a sentry manned by player killed the ai
	turret.owner	= self;		// Required by _player_stats::RegisterKill() when the sentry kills a vehicle
	turret SetSentryOwner( self );
	
	self FreezeControls( true );
	self.oldangles = self getPlayerAngles();
	self DisableWeapons();
	HoldStanceChange( false );
	
	fade_out();
	self ThermalVisionOn();
	self RemoteCameraSoundscapeOn();
	self text_TitleCreate();
	self ent_flag_set( "on_remote_turret" );
	HudItemsHide();	
	self thread turret_activate( turret, terminal );
	
	fade_in();
	self FreezeControls( false );
}

remote_turret_disable( turret, terminal )
{
	turret.attacker	= undefined;	// Required by _spawner::deathFunctions() when checking to see if a sentry manned by player killed the ai
	turret.owner	= undefined;	// Required by _player_stats::RegisterKill() when the sentry kills a vehicle
	self SetSentryOwner( undefined );
	
	self ent_flag_clear( "on_remote_turret" );
	if ( !flag( "_remoteturret_nofade" ) )
		fade_out();
	self turret_deactivate( turret, terminal );
	self EnableWeapons();

	self ThermalVisionOff();
	self RemoteCameraSoundscapeOff();
	self setPlayerAngles( self.oldangles );
	HoldStanceChange( true );
	HudItemsShow();
	text_TitleDestroy();
	if ( !flag( "_remoteturret_nofade" ) )
		fade_in();
}

remote_turret_next( terminal )
{
	self ent_flag_clear( "on_remote_turret" );
	self endon( "get_off_turret" );
	if ( !flag( "_remoteturret_nofade" ) )
		fade_out();
	turret_deactivate( terminal._remote_turrets[ terminal.lastTurretIndex ], terminal );
	terminal.lastTurretIndex += 1;
	terminal.lastTurretIndex = ( terminal.lastTurretIndex ) % ( terminal._remote_turrets.size );
	self thread turret_activate( terminal._remote_turrets[ terminal.lastTurretIndex ], terminal );
	if ( !flag( "_remoteturret_nofade" ) )
		fade_in();
	self ent_flag_set( "on_remote_turret" );
}

turret_activate( turret, terminal )
{
	if	(
			IsDefined( level._remoteturret_loc_table )
		&&	IsDefined( turret.script_startname )
		&&	IsDefined( level._remoteturret_loc_table[ turret.script_startname ] )
		)
	{
		text_TitleSetText( level._remoteturret_loc_table[ turret.script_startname ] );
	}
	else
	{
		text_TitleSetText( "CAMERA: " + ( terminal.lastTurretIndex + 1 ) );
	}
	turret HideOnClient( self );
	self uav_enable_view();	
	
	org = spawn_tag_origin();
	ang = turret GetTagAngles( "tag_origin" );
	
	if ( isdefined( turret.last_look_origin ) )
	{
		ang = VectorToAngles( turret.last_look_origin - turret.origin );
	}
	
	self setPlayerAngles( (ang[0], ang[1], self.angles[2]) );
	self PlayerLinkTo( turret, "tag_player", 0, turret.rightArc * 0.9, turret.leftArc * 0.9, turret.topArc * 0.9, turret.bottomArc * 0.9 );
	
	// Added this block because PlayerLinkWeaponViewToDelta caused clipping issues
	// actually putting the player on the turret instead of "remote controlling" it
	// would have liked to keep the remote control stuff, but since this isn't used anywhere else this will have to do
	// -Carlos
	turret TurretFireEnable();
	turret MakeUsable();
	turret UseBy( self );
	turret MakeUnusable();
	self disableturretdismount();
	
//	Removed these lines because we removed the "remote control" functionality 
//	and are actually putting the player on the turret - Carlos
//	self thread remote_turret_badplace( turret, terminal );
//	self thread player_turret_shoot( turret );
//	self player_look_aim( turret, org );
	org delete();
}

turret_deactivate( turret, terminal )
{
	self uav_disable_view();
	
	// Moving the player from one turret to the next
	// on the same frame caused a bug where the turret
	// left behind kept playing the fire sound even though
	// the player wasn't on it. Fix this but disabling fire
	// for a frame and then unlinking and moving the player.
	turret TurretFireDisable();
	turret StopFiring();
	wait 0.1;		// Tried waiting 0.05, that wasn't long enough, 0.1 works consistently /puke -JC
	
	// added this block because PlayerLinkWeaponViewToDelta caused clipping issues
	// actually putting the player on the turret instead of "remote controlling" it
	// would have liked to keep the remote control stuff, but since this isn't used anywhere else this will have to do 
	// -Carlos
	self unlink();
	self enableturretdismount();
	turret MakeUsable();
	turret UseBy( self );
	turret MakeUnusable();
	
	turret notify( "stop_use_turret" );
	turret ShowOnClient( self );
}

remote_turret_badplace( turret, terminal )
{
	turret endon( "stop_use_turret" );
	
	while( 1 )
	{
		turret waittill( "create_badplace" );
		start = turret getTagOrigin( "tag_flash" );
		tagangles = turret getTagAngles( "tag_flash" );
		end = start + ( AnglesToForward( tagangles ) * 9999 );
		trace = BulletTrace( start, end, false );
		BadPlace_Cylinder( "bullet_impact", 1, trace[ "position" ], 256, 96, "axis" );
		wait( 1 );
	}
}

fade_in()
{
	if ( level.MissionFailed )
		return;
	level notify( "now_fade_in" );
	wait( 0.05 );
	
	white_overlay = self get_white_overlay();
	white_overlay FadeOverTime( FADE_OUT_TIME );
	white_overlay.alpha = 0;

	wait( FADE_IN_TIME );
}


fade_out()
{
	white_overlay = self get_white_overlay();
	white_overlay FadeOverTime( FADE_OUT_TIME );
	white_overlay.alpha = 1;
	
	wait( FADE_OUT_TIME );
}

get_white_overlay()
{
	if ( !IsDefined( self.white_overlay ) )
		self.white_overlay = create_client_overlay( "white", 0, self );
	self.white_overlay.sort = -1;
	self.white_overlay.foreground = false;
	return self.white_overlay;
}

HudItemsHide()
{
	if ( level.players.size > 0 )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( level.players[i] ent_flag( "on_remote_turret" ) )
				SetDvar( "ui_remotemissile_playernum", ( i + 1 ) );// 0 = no uav, 1 = player1, 2 = player2
		}
	}
	else
	{
		SetSavedDvar( "compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
		SetSavedDvar( "actionSlotsHide", "1" );
	}
}


HudItemsShow()
{
	if ( level.players.size > 0 )
	{
		SetDvar( "ui_remotemissile_playernum", 0 );// 0 = no uav, 1 = player1, 2 = player2
	}
	else
	{
		SetSavedDvar( "compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
		SetSavedDvar( "actionSlotsHide", "0" );
	}
}

HoldStanceChange( allowed )
{
	if (!allowed)
	{
		stance = self getstance();
		if (stance != "prone")
			self AllowProne(allowed);
		if (stance != "crouch")
			self AllowCrouch(allowed);
		if (stance != "stand")
			self AllowStand(allowed);
	}
	else
	{
		self AllowProne(allowed);
		self AllowCrouch(allowed);
		self AllowStand(allowed);
	}
}

uav_enable_view( time, skip_thermal )
{
	level.uav_sort = -5;
//	level.uav_hud_color = ( 0.338, 0.637, 0.344 );
	level.uav_hud_color = ( 1, 1, 1 );
	
	self.uav_huds = [];
	self.uav_huds[ "static_hud" ] 	= self create_hud_static_overlay( time );
	self.uav_huds[ "scanline" ]		= self create_hud_scanline_overlay( time );
//	self.uav_huds[ "horz_meter" ] 	= self create_hud_horizontal_meter( time );
//	self.uav_huds[ "vert_meter" ] 	= self create_hud_vertical_meter( time );
	self.uav_huds[ "crosshair" ] 	= self create_hud_crosshair( time );
	/*
	self.uav_huds[ "upper_left" ]	= self create_hud_upper_left( time );
	self.uav_huds[ "upper_right" ]	= self create_hud_upper_right( time );
	self.uav_huds[ "lower_right" ]	= self create_hud_lower_right( time ); 

	self.uav_huds[ "arrow_left" ]   = self create_hud_arrow( "left", time );
	self.uav_huds[ "arrow_up" ]  	= self create_hud_arrow( "up", time );
	*/
	
	/* Store some settings
	self.uav_huds[ "vert_meter" ].meter_size = 96;
	self.uav_huds[ "vert_meter" ].min_value = 10;
	self.uav_huds[ "vert_meter" ].max_value = 90;
	self.uav_huds[ "vert_meter" ].range = self.uav_huds[ "vert_meter" ].max_value - self.uav_huds[ "vert_meter" ].min_value;

	self.uav_huds[ "horz_meter" ].meter_size = 96;
	self.uav_huds[ "horz_meter" ].min_value = -180;
	self.uav_huds[ "horz_meter" ].max_value = 180;
	self.uav_huds[ "horz_meter" ].range = self.uav_huds[ "horz_meter" ].max_value - self.uav_huds[ "horz_meter" ].min_value;;
	*/
	SetSavedDvar( "sm_sunsamplesizenear", "1" );
	SetSavedDvar( "sm_cameraoffset", "3400" );
	
	self thread uav_hud_scanline();
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
	hud = create_client_overlay( "overlay_grain", 0.3, self );
	hud.sort = level.uav_sort;

	if ( !hud hud_fade_in_time( time, 0.3 ) )
	{
		hud.alpha = 0.3;
	}

	return hud;
}

create_hud_scanline_overlay( time )
{
	hud = create_client_overlay( "ac130_thermal_overlay_bar", 1, self );
	hud.x = 0;
	hud.y = 0;
	hud.sort = level.uav_sort + 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";

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
	hud SetShader( "uav_vertical_meter", 16, 96 );

	hud hud_fade_in_time( time );

	return hud;
}

create_hud_crosshair( time )
{
	hud = createClientIcon( "uav_crosshair", 320, 240 );
	hud.sort = level.uav_sort;
	hud.elemType = "icon";
	hud setParent( level.uiParent );
	hud setPoint( "CENTER", undefined, 0, 0 );

	hud hud_fade_in_time( time );

	return hud;
}

uav_set_target_hud_data( index, value )
{
	self.uav_huds[ "lower_right" ][ index ].data_value SetValue( value );
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

	return create_hud_section( data, 10, 80, "left", time );
}

create_hud_upper_right( time )
{
	data = [];
	data[ "acft" ]  	= [ &"UAV_ACFT", "none" ];	//
	data[ "long" ]  	= [ &"UAV_N", "none" ];	//
	data[ "lat" ] 		= [ &"UAV_W", "none" ];	//
	data[ "angle" ] 	= [ &"UAV_HAT", "none" ];	//

	return create_hud_section( data, 510, 80, "left", time );
}

create_hud_lower_right( time )
{
	data = [];
	data[ "long" ]  	= [ &"UAV_N", "none" ];	//
	data[ "lat" ] 		= [ &"UAV_W", "none" ];	//

	huds = create_hud_section( data, 500, 335, "left", time );

	data = [];
	data[ "brg" ] 		= [ &"UAV_BRG", "" ];			// Bearing
	data[ "rng_m" ]  	= [ &"UAV_RNG", &"UAV_M" ];		// Range Meters
	data[ "rng_nm" ] 	= [ &"UAV_RNG", &"UAV_NM" ];	// Range Nautical Miles
	data[ "elv" ] 	 	= [ &"UAV_ELV", &"UAV_F" ];		// Elevation Feet

	huds2 = create_hud_section( data, 510, 360, "right", time );

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

	data_value hud_fade_in_time( time );

	self.data_value = data_value;
}

uav_disable_view( duration )
{
	if ( isdefined( self.uav_huds ) )
	{
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
	}
	if ( !IsDefined( duration ) )
	{
		duration = 0.05;
	}

	SetSavedDvar( "sm_sunenable", 1.0 );
}

uav_destroy_hud( hud, duration )
{
	if ( IsDefined( hud.data_value ) )
	{
		hud.data_value thread uav_destroy_hud_wrapper( duration );
	}

	if ( IsDefined( hud.data_value_suffix ) )
	{
		hud.data_value_suffix thread uav_destroy_hud_wrapper( duration );
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
	if ( isdefined( self ) )
		self Destroy();
}


text_TitleCreate()
{
	level.text1 = self createClientFontString( "objective", 2.0 );
	level.text1 setPoint( "TOP", undefined, 0, 10 );
}

text_TitleSetText( text )
{
	level.text1 SetText( text );
}

text_TitleFadeout()
{
	level.text1 FadeOverTime( 0.25 );
	level.text1.alpha = 0;
}

text_TitleDestroy()
{
	if ( !IsDefined( level.text1 ) )
		return;
	level.text1 Destroy();
	level.text1 = undefined;
}

cancel_on_player_damage()
{
	self endon( "get_off_turret" );
	self.took_damage = false;
	//self waittill( "damage" );
	self waittill_any( "damage", "dtest", "force_out_of_uav" );
	self.took_damage = true;
	self notify( "get_off_turret" );
}

uav_hud_scanline()
{
	hud = self.uav_huds[ "scanline" ];
	
	if ( !isdefined( hud ) )
		return;
	
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

transfer_to_new_terminal( old_terminal, new_terminal )
{
	flag_set( "_remoteturret_nofade" );
	self ent_flag_clear( "on_remote_turret" );
	self notify( "no_switching_allowed" );
	fade_out();
	self turret_deactivate( old_terminal get_active_turret()  );
	self notify( "transfer_terminal" );
	self notify( "get_off_turret" );
	text_TitleDestroy();
	self thread remote_turret_loop( new_terminal );
	fade_in();
	self ent_flag_set( "on_remote_turret" );	
	flag_clear( "_remoteturret_nofade" );
}

// self : terminal
get_active_turret()
{
	return self._remote_turrets[ self.lastTurretIndex ];
}