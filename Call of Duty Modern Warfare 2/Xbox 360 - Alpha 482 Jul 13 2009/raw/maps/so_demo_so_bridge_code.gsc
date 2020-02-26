#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;

// ---------------------------------------------------------------------------------

register_bridge_enemy()
{
	if ( !isdefined( level.bridge_enemies ) )
	{
		level.bridge_enemies = 0;
		level.enemy_list = [];
	}
	
	level.bridge_enemies++;
	level.enemy_list = array_add( level.enemy_list, self );
	
	if ( !flag( "so_demoman_start" ) )
		flag_set( "so_demoman_start" );
	
	self waittill( "death" );
	
	level.bridge_enemies--;
	level.enemy_list = array_remove( level.enemy_list, self );
	foreach ( player in level.players )
		player.target_reminder_time = gettime();
}

// ---------------------------------------------------------------------------------

player_refill_ammo()
{
	level endon( "special_op_terminated" );
	
	while ( true )
	{
		wait 0.05;
		if ( !player_can_refill() )
		{
			if ( isdefined( self.maintain_stock ) )
				self.maintain_stock = [];
			continue;
		}

		if ( !isdefined( self.maintain_stock ) )
			self.maintain_stock = [];

		weapons = self getweaponslistall();
		foreach ( weapon in weapons )
		{
			if ( !isdefined( self.maintain_stock[ weapon ] ) )
				self.maintain_stock[ weapon ] = self getweaponammostock( weapon );
			
			self setweaponammostock( weapon, self.maintain_stock[ weapon ] );
		}
	}
}

player_can_refill()
{
	if ( !isdefined( level.infinite_ammo ) || !level.infinite_ammo )
		return false;
	
	return true;
}

player_wait_for_fire()
{
	notifyoncommand( "player_fired", "+attack" );
	notifyoncommand( "player_fired", "+melee" );
	notifyoncommand( "player_fired", "+frag" );
	notifyoncommand( "player_fired", "+smoke" );
	
	while( true )
	{
		self waittill( "player_fired" );

		// Placing sentry is ok.
		if ( isdefined( self.placingSentry ) )
			continue;
		
		// Certain weapons are allowed...
		weapon = self getcurrentweapon();
		if ( weapon == "claymore" )
			continue;
		
		if ( weapon == "c4" )
		{
			if ( !isdefined( self.c4array ) || ( self.c4array.size <= 0 ) )
				continue;
		}
							
		// Start the challenge!
		break;
	}
	
	if ( !flag( "so_demoman_start" ) )
		flag_set( "so_demoman_start" );
	
	foreach ( player in level.players )
	{
		player.target_reminder_time = gettime();
		player thread player_refill_ammo();
	}
}

// ---------------------------------------------------------------------------------

vehicle_alive_think()
{
	level endon( "special_op_terminated" );

	if ( !isdefined( level.vehicles_alive ) )
		level.vehicles_alive = 0;
		
	level.vehicles_alive++;
	
	self waittill( "exploded", attacker );

	// In case pesky players find a way to explode a car before doing anything else the normal script catches.
	if ( !flag( "so_demoman_start" ) )
		flag_set( "so_demoman_start" );
		
	level.vehicles_alive--;
	level.vehicle_list = array_remove( level.vehicle_list, self );

	if ( isdefined( attacker ) && IsPlayer( attacker ) )
	{
		attacker.target_reminder_time = gettime();
	}
	else
	{
		foreach ( player in level.players )
			player.target_reminder_time = gettime();
	}
		
//	thread hud_create_kill_splash();

	level notify( "vehicle_destroyed" );
	if ( level.vehicles_alive <= 0 )
		flag_set( "so_demoman_complete" );
}

vehicle_get_slide_car( car_id )
{
	slide_cars = getentarray( car_id, "script_noteworthy" );
	foreach ( ent in slide_cars )
	{
		if ( ent.classname == "script_model" )
			return ent;
	}
}

// ---------------------------------------------------------------------------------

// Run on an individual player to help them out.
hud_display_cars_hint()
{
	level endon( "special_op_terminated" );

	assertex( isplayer( self ), "hud_display_cars_help() can only be called on players." );
	gameskill = self get_player_gameskill();
	self.target_reminder_time = gettime();
	switch( gameskill )
	{
		case 0:
		case 1:	self.target_help_time = 20000; break;
		case 2: self.target_help_time = 30000; break;
		case 3: return;	// Veteran doesn't get any help.
	}

	thread hud_display_car_locations();
		
	while ( !flag( "so_demoman_complete" ) )
	{
		wait 1;
		if ( hud_disable_cars_hint() )
			continue;

		self notify( "show_vehicle_locs" );	
		while( !hud_disable_cars_hint() )
		{
			wait 1;
			continue;
		}

		self notify( "hide_vehicle_locs" );	
	}
}

hud_disable_cars_hint()
{
	if ( !flag( "so_demoman_start" ) )
		return true;
		
	if ( isdefined( level.bridge_enemies ) && ( level.bridge_enemies > 0 ) )
	{
		close_enemies = get_array_of_closest( self.origin, level.enemy_list, undefined, undefined, 4096, 0 );
		if ( close_enemies.size > 0 )
			return true;
	}
		
	player_time_test = gettime() - self.target_help_time;
	return ( self.target_reminder_time > player_time_test );
}

hud_display_car_locations()
{
	level endon( "special_op_terminated" );

	while ( !flag( "so_demoman_complete" ) )
	{
		self waittill( "show_vehicle_locs" );

		thread hud_refresh_car_locations();

		self waittill( "hide_vehicle_locs" );
	}
}

hud_refresh_car_locations()
{
	level endon( "special_op_terminated" );
	self endon( "hide_vehicle_locs" );
	
	while( 1 )
	{
		self notify( "refresh_vehicle_locs" );
		close_vehicles = get_array_of_closest( self.origin, level.vehicle_list, undefined, 3 );
		foreach ( vehicle in close_vehicles )
			thread hud_show_target_icon( vehicle );
		wait 1;
	}
}

hud_show_target_icon( vehicle )
{
	assertex( isdefined( vehicle ), "hud_show_target_icon() requires a valid vehicle entity to place an icon over." );
			
	icon = NewClientHudElem( self );
	icon SetShader( "waypoint_targetneutral", 1, 1 );
	icon.alpha = 0;
	icon.color = ( 1, 1, 1 );
	icon.x = vehicle.origin[ 0 ];
	icon.y = vehicle.origin[ 1 ];
	icon.z = vehicle.origin[ 2 ] + 48;
	icon SetWayPoint( true, true );

	icon thread fade_over_time( 1, 0.25 );

	self waittill_any( "hide_vehicle_locs", "refresh_vehicle_locs" );
	icon fade_over_time( 0, 0.25 );
	
	icon Destroy();
}

hud_display_cars_remaining()
{
	self.car_title = so_create_hud_item( 3, so_hud_ypos(), &"SO_DEMO_SO_BRIDGE_VEHICLES", self );
	self.car_count = so_create_hud_item( 3, so_hud_ypos(), level.vehicles_alive, self );
	self.car_count.alignx = "left";
	
/*	thread info_hud_handle_fade( self.car_title );
	thread info_hud_handle_fade( self.car_count );*/
	
	while( true )
	{
		level waittill( "vehicle_destroyed" );
		if ( level.vehicles_alive <= 0 )
			break;

		self.car_count.label = level.vehicles_alive;
	}

	self.car_count.label = "--";

	self.car_title thread so_remove_hud_item();
	self.car_count thread so_remove_hud_item();
}

hud_display_time_bonus()
{
	self.bonus_title = so_create_hud_item( 4, so_hud_ypos(), "Wrecked Bonus in: ", self );
	self.bonus_count = so_create_hud_item( 4, so_hud_ypos(), level.bonus_count_goal, self );
	self.bonus_count.alignx = "left";
	self.bonus_count.pulse_sound = "arcademode_checkpoint";
	self.bonus_count_current = level.bonus_count_goal;

	while( true )
	{
		level waittill( "vehicle_destroyed" );
		if ( level.vehicles_alive <= 0 )
			break;

		self.bonus_count_current--;
		if ( self.bonus_count_current <= 0 )
		{
			self.bonus_count_current = level.bonus_count_goal;
			thread hud_rebuild_time_bonus( level.bonus_time_amount );
		}

		self.bonus_title thread so_hud_pulse_create();
		self.bonus_count thread so_hud_pulse_create( self.bonus_count_current );
	}

	self.bonus_title thread so_remove_hud_item();
	self.bonus_count thread so_remove_hud_item();

	self.time_title thread so_remove_hud_item();
	self.time_bonus thread so_remove_hud_item();
}

hud_rebuild_time_bonus( timer )
{
	level endon( "special_op_terminated" );

	self notify( "rebuild_time_bonus" );
	self endon( "rebuild_time_bonus" );

	if ( level.vehicles_alive <= 0 )
		return;

	// Otherwise build, and wait for the timer to expire then rebuild.
	if ( self == level.player )
	{
		if ( !isdefined( level.infinite_ammo ) || !level.infinite_ammo )
		{
			level.infinite_ammo = true;
			foreach( player in level.players )
				player.infinite_ammo_time = 0;
		}
	}

	if ( !isdefined( self.time_bonus ) )
	{
		self.time_title = so_create_hud_item( 5, so_hud_ypos(), "Infinite Ammo: ", self );
		self.time_bonus = so_create_hud_item( 5, so_hud_ypos(), &"SPECIAL_OPS_TIME_NULL", self );
		self.time_bonus.alignx = "left";
		self.time_bonus.pulse_sound = "arcademode_2x";
		self.time_title.pulse_scale = 1.33;
		self.time_bonus.pulse_scale = 1.75;
		self.time_title.pulse_time = 0.25;
		self.time_bonus.pulse_time = 0.25;
	}

	if ( self.time_title.alpha == 0 )
	{
		self.time_title set_hud_white();
		self.time_bonus set_hud_white();
	}
	
	self.time_title.alpha = 1;
	self.time_bonus.alpha = 1;

	thread hud_time_splash( timer );

	turn_red_time = 5;
	if ( timer > turn_red_time )
	{
		wait 3;	// This wait is for the hud splash to "absorb" into the hud timer.
		self.time_title set_hud_blue();
		self.time_bonus set_hud_blue();
		hud_time_bonus_wait( turn_red_time );
	}

	self.time_title set_hud_red();
	self.time_bonus set_hud_red();
	hud_time_bonus_wait( 0 );

	self.time_title.alpha = 0;
	self.time_bonus.alpha = 0;
	
	if ( self == level.player )
	{
		level.infinite_ammo_time = undefined;
		level.infinite_ammo = undefined;
		level.infinite_ammo_update = undefined;
	}
}

hud_time_splash( timer )
{
	level endon( "special_op_terminated" );

	if ( !isdefined( self.splash_count ) )
		self.splash_count = 0;

	// Only allow one splash active at a time.	
	self.splash_count++;
	if ( self.splash_count > 1 )
		return;

	if ( !isdefined( self.time_splash ) )
	{
		self.time_msg = hud_create_splash( 0, "Wrecked Bonus!" );
		self.time_msg_x = self.time_msg.x;
		self.time_msg_y = self.time_msg.y;

		self.time_splash = hud_create_splash( 1, "+" + level.bonus_time_amount + "s Infinite Ammo!" );
		self.time_splash_x = self.time_splash.x;
		self.time_splash_y = self.time_splash.y;
	}

	while( self.splash_count > 0  )
	{
		if ( self == level.player )
			level.player PlaySound( "arcademode_kill_streak_won" );

		self.time_msg hud_boom_in_splash( self.time_msg_x, self.time_msg_y );
		self.time_splash hud_boom_in_splash( self.time_splash_x, self.time_splash_y );

		wait 2.5;

		self.time_msg hud_absorb_splash( self.time_title.y );
		self.time_splash hud_absorb_splash( self.time_title.y );

		wait 0.5;

		if ( self.infinite_ammo_time < 1 )
			self.infinite_ammo_time = 0;
		self.infinite_ammo_time += timer;
		self.time_bonus settenthstimer( self.infinite_ammo_time );

		self.time_title thread so_hud_pulse_create();
		self.time_bonus thread so_hud_pulse_create( "" );

		wait 0.25;

		self.splash_count--;
	}

	self.time_msg Destroy();
	self.time_splash Destroy();
}

hud_create_splash( yline, message )
{
	hud_elem = so_create_hud_item( yline, 0, message, self );
	hud_elem.alignX = "center";
	hud_elem.horzAlign = "center";
	return hud_elem;
}

hud_boom_in_splash( xpos, ypos )
{
	self.x = xpos;
	self.y = ypos;

	self.fontscale = 0.25;
	self.alpha = 0;
	self fadeovertime( 0.1 );
	self changefontscaleovertime( 0.1 );
	self.fontscale = 1;
	self.alpha = 1;
}

hud_absorb_splash( ypos )
{
	self changefontscaleovertime( 0.5 );
	self.fontscale = 0.5;

	self fadeovertime( 0.5 );
	self.alpha = 0;
	self moveovertime( 0.5 );
	self.x = 200;
	self.y = ypos;
}

hud_time_bonus_wait( stop_time )
{
	while ( ( self.splash_count > 0 ) || ( self.infinite_ammo_time > stop_time ) )
	{
		wait 0.05;
		self.infinite_ammo_time -= 0.05;
	}
}

// ---------------------------------------------------------------------------------
