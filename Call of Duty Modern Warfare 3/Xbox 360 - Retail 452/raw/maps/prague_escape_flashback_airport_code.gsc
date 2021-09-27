#include maps\_hud_util;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include maps\_utility_chetan;

// *************************************
// GENERAL
// *************************************

monitor_attack_button_pressed()
{
	NotifyOnCommand( "LISTEN_attack_button_pressed", "+attack" );
	NotifyOnCommand( "LISTEN_attack_button_pressed", "+attack_akimbo_accessible" );

	for ( ; ; wait 0.1 )
	{
		flag_clear( "FLAG_attack_button_pressed" );
		level.player waittill( "LISTEN_attack_button_pressed" );
		flag_set( "FLAG_attack_button_pressed" );
	}
}

monitor_ads_button_pressed()
{
	NotifyOnCommand( "LISTEN_ads_button_pressed", "+toggleads_throw" );
	NotifyOnCommand( "LISTEN_ads_button_pressed", "+speed_throw" );
	NotifyOnCommand( "LISTEN_ads_button_pressed", "+speed" );
	NotifyOnCommand( "LISTEN_ads_button_pressed", "+ads_akimbo_accessible" );
	
	for ( ; ; wait 0.1 )
	{
		flag_clear( "FLAG_ads_button_pressed" );
		level.player waittill( "LISTEN_ads_button_pressed" );
		flag_set( "FLAG_ads_button_pressed" );
	}
}

monitor_ads()
{
	for ( ; ; wait 0.01 )
	{
		if ( level.player PlayerAds() > 0 )
			flag_set( "FLAG_adsing" );
		else
			flag_clear( "FLAG_adsing" );
	}
}

hint_crawl_right()
{
	//return level.player buttonpressed( "mouse2" );
	return flag( "FLAG_attack_button_pressed" );
}

hint_crawl_left()
{
	//return level.player buttonpressed( "mouse1" );
	return flag( "FLAG_ads_button_pressed" );
}

// *************************************
// CRAWLING
// *************************************

track_buttons( button_track, button_funcs, button_hints )
{
	buttons = [];
	foreach ( i, button_func in button_funcs )
		buttons[ i ] = GetTime();
	button_track.button_last_release 	= buttons;
	button_track.button_hints 			= button_hints;

	for ( ; ; wait 0.05 )
		foreach ( i, button_func in button_funcs )
			if ( ! level.player [[ button_func ]]() )
				button_track.button_last_release[ i ] = GetTime();
}

crawl_earthquake()
{
	Earthquake( 0.12, 0.450, level.player.origin, 5000 );
}

button_wait( button_funcs, button_track, button_index )
{
	time 						= GetTime();
	button_hint_time 			= time + 300;
	button_player_hurt_pulse 	= time + 4150;
	button_failure_time 		= time + 20000;

	button_hinted 	= false;
	hurt_pulsed 	= false;

	skip_to_end		= false;
	
	if ( button_index == 0 )
	{
		button_hint_time 			= time + 1400;
		button_player_hurt_pulse 	= time + 6150;
		button_failure_time 		= time + 20000;
	}

	if ( button_index > 2 )
	{
		button_hint_time 			= time + 1400;
		button_player_hurt_pulse 	= time + 4150;
		button_failure_time 		= time + 20000;
	}

	for ( ; ; wait 0.05 )
	{
		button_pressed 		= level.player [[ button_funcs[ button_index ] ]]();
		needs_to_release 	= button_needs_to_release( button_track, button_index );

		if ( button_hint_time < GetTime() && !button_hinted )
		{
			button_hinted = true;
			display_hint( button_track.button_hints[ button_index ] );
		}

		if ( button_player_hurt_pulse < GetTime() && !hurt_pulsed )
		{
			hurt_pulsed = true;
			thread crawl_hurt_pulse();
		}

		if ( button_failure_time < GetTime() )
		{
			skip_to_end = true;
			level notify( "crawl_breath_recover" );
			break;
		}
		if ( button_pressed && !needs_to_release )
		{
			level.player vision_set_fog_changes( "prague_escape_airport_crawl_recover", .5 );
			level.player delayThread( 1.0, ::vision_set_fog_changes, "prague_escape_airport_crawl_to_elevator", 1.5 );
			level notify( "clear_hurt_pulses" );
			return skip_to_end;
		}
	}
	return skip_to_end;
}

button_needs_to_release( button_track, index )
{
	timediff = GetTime() - button_track.button_last_release[ index ];
	return timediff > 750;
}

crawl_hurt_pulse()
{
	fade_out( 2 );
	SetBlur( 4, 4 );
	level.player vision_set_fog_changes( "prague_escape_airport_crawl_hurt", 4 );
	thread crawl_breath_start();
	level waittill( "clear_hurt_pulses" );
	//level.player vision_set_fog_changes( "prague_escape_airport_crawl_recover", .5 );
	thread crawl_breath_recover();
	SetBlur( 0, .5 );
	fade_in( .23 );
}

crawl_breath_start()
{
	level endon( "crawl_breath_recover" );
	level.player play_sound_on_entity( "breathing_hurt_start" );
	while ( 1 )
	{
		wait RandomFloatRange( .76, 1.7 );
		level.player play_sound_on_entity( "breathing_hurt" );
	}
}

crawl_breath_recover()
{
	level notify( "crawl_breath_recover" );
	level.player thread play_sound_on_entity( "breathing_better" );
}

fade_out( fade_out_time, optional_alpha_override )
{
	black_overlay = get_black_overlay();
	if ( fade_out_time )
		black_overlay FadeOverTime( fade_out_time );

	black_overlay.alpha = ter_op( IsDefined( optional_alpha_override ), optional_alpha_override, 1 );
	//thread eq_changes( 0.5, fade_out_time );
}

fade_in( fade_time )
{
	if ( level.MissionFailed )
		return;
	level notify( "now_fade_in" );
		
	black_overlay = get_black_overlay();
	if ( fade_time )
		black_overlay FadeOverTime( fade_time );

	black_overlay.alpha = 0;

	//thread eq_changes( 0.0, fade_time );
}

get_black_overlay()
{
	if ( !IsDefined( level.black_overlay ) )
		level.black_overlay = create_client_overlay( "black", 0, level.player );
	level.black_overlay.sort = -1;
	level.black_overlay.foreground = true;
	return level.black_overlay;
}

eq_changes( val, fade_time )
{
	if ( IsDefined( level.override_eq ) )
		return;
	if ( !isdefined( level.eq_ent ) )
	{
		waittillframeend;// so e~q_ent will be defined
		waittillframeend; // if came from a start_ function
	}
		
	if ( fade_time )
		level.eq_ent MoveTo( ( val, 0, 0 ), fade_time );
	else
		level.eq_ent.origin = ( val, 0, 0 );
}

// *************************************
// LIMPING
// *************************************

player_heartbeat()
{
	self notify ( "stop_heart" );
	self endon ( "stop_heart" );

	for ( ; ; )
	{
		if ( ent_flag( "FLAG_player_heartbeat_sound" ) )
		{
			self thread play_sound_on_entity( "breathing_heartbeat" );
			wait 0.05;
			self PlayRumbleOnEntity( "damage_light" );
		}
		wait self.player_heartrate;
		
		wait( 0 + randomfloat( 0.1 ) );

		if ( randomint( 50 ) > self.movespeedscale * 190 )
			wait randomfloat( 1 );
	}
}

ENDING_MOVE_SPEED = 0.45;

player_limp_init()
{
	ent_flag_init( "FLAG_player_heartbeat_sound" );
	
	self.player_heartrate 	= 0.8;
	self.movespeedscale 	= 1;
}

player_limp()
{
	self.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) );
	self playerSetGroundReferenceEnt( self.ground_ref_ent );

	//set_vision_set( "aftermath_walking", 0 );

	self play_sound_on_entity( "sprint_gasp" );
	self thread swivel();
	self play_sound_on_entity( "breathing_hurt_start" );
	self thread play_sound_on_entity( "breathing_better" );
	self thread player_random_blur();
	self thread player_limp_on_end();
	self thread player_limp_shellshock();
}

player_limp_on_end()
{
	self waittill( "LISTEN_end_player_limp" );
	time = 0.8;
	self.ground_ref_ent Rotateto( ( 0, 0, 0 ), time, time * 0.5, time * 0.5 );
	wait time;
	self.ground_ref_ent Delete();
	self playerSetGroundReferenceEnt( undefined );
	SetSlowMotion( 0.95, 1, 0.5 );
	self StopShellShock();
}

player_random_blur()
{
	level notify( "LISTEN_end_random_blur" );
	
	level endon( "dying" );
	level endon( "LISTEN_end_random_blur" );

	while ( true )
	{
		wait 0.05;
		if ( randomint( 100 ) > 10 )
			continue;

		blur 			= randomint( 3 ) + 2;
		blur_time 		= randomfloatrange( 0.3, 0.7 );
		recovery_time 	= randomfloatrange( 0.3, 1 );
		setblur( blur * 1.2, blur_time );
		wait blur_time;
		setblur( 0, recovery_time );
		wait 5;
	}
}

adjust_angles_to_player( stumble_angles )
{
	pa = stumble_angles[ 0 ];
	ra = stumble_angles[ 2 ];

	rv = anglestoright( level.player.angles );
	fv = anglestoforward( level.player.angles );

	rva = ( rv[ 0 ], 0, rv[ 1 ] * - 1 );
	fva = ( fv[ 0 ], 0, fv[ 1 ] * - 1 );
	
	angles = ( rva* pa );
	angles = angles + ( fva* ra );
	return angles + ( 0, stumble_angles[ 1 ], 0 );
}

swivel()
{
	self endon( "LISTEN_end_player_limp" );
	
	self.unsteady_scale 	= 4.1;
	//self.yaw_unsteady_scale = 0.0;
	
	thread SetSlowMotion_overtime();
	
	ent 		= level spawn_tag_origin();
	roll_ent 	= level spawn_tag_origin();
	
	thread adjust_swivel_over_time( ent );
	thread adjust_roll_ent( roll_ent );
	//thread swivel_adjust_on_ads_and_fire();

	pitch_sin 				= 0;
	time 					= 0.1;
	last_yaw 				= self GetPlayerAngles()[ 1 ];
	last_ground_ref_yaw 	= ent.origin[ 0 ]; 
	
	for ( ; ; wait 0.05 )
	{
		new_yaw 		= self GetPlayerAngles()[ 1 ];
		delta_yaw 		= new_yaw - last_yaw;
		ground_ref_yaw 	= ent.origin[ 0 ] + delta_yaw;
		last_yaw 			= new_yaw;
		player_speed 		= gt_op( Distance( ( 0,0,0 ), self GetVelocity() ), 15 );
		
		pitch_sin  += player_speed * 0.06;
		pitch 	    = sin( pitch_sin ) * 4 * self.unsteady_scale; // 12;
		
		self.ground_ref_ent RotateTo( ( pitch * 0.15, ground_ref_yaw * -1, pitch * 0.85 ), time, time * 0.5, time * 0.5 );
	}
}

player_limp_shellshock()
{
	self endon( "LISTEN_end_player_limp" );
	
	for ( ; ; )
	{
		self ShellShock( "prague_escape_airport", 60 );
		wait 60;
	}
}
	
SetSlowMotion_overtime()
{
	self endon( "LISTEN_end_player_limp" );
	
	timescale 	= 1;
	range 		= 0.15;
	time 		= 4;
	
	wait 3;
	
	for ( ; ; )
	{
		SetSlowMotion( timescale, 0.89, time );
		wait time;
		SetSlowMotion( timescale, 1.06, time );
		wait time;
	}
}

adjust_swivel_over_time( ent )
{
	self endon( "LISTEN_end_player_limp" );
	
	next_switch 	= 1;	
	original_range 	= 7; // 25;
	
	for ( ;; )
	{
		range 	= original_range * self.unsteady_scale;
		yaw 	= RandomFloatRange( range * 0.5, range );
		
		next_switch--;
		if ( next_switch <= 0 )
		{
			next_switch = randomint( 3 );
			yaw *= -1;
		}
			
		dif = yaw - ent.origin[0];
		dif = abs( dif );

		time = dif * 0.05;
		if ( time < 0.05 )
			time = 0.05;

		start_time = GetTime();
		ent MoveTo( ( yaw, 0, 0 ), time, time * 0.5, time * 0.5 );
		wait time;
		
		wait_for_buffer_time_to_pass( start_time, 0.6 );
		for ( ; ; )
		{
			player_speed = gt_op( Distance( ( 0, 0, 0 ), self GetVelocity() ), 0 );
			if ( player_speed >= ( 80 * self.g_speed_percent ) )
				break;
			wait 0.05;
		}
	}	
}

adjust_roll_ent( roll_ent )
{
	self endon( "LISTEN_end_player_limp" );
	
	walking_count 	= 0;
	cap 			= 140;
	
	struct 	= getstruct( "limp_yaw_ent", "targetname" );
	target 	= getstruct( struct.target, "targetname" );
	angles	= VectorToAngles( target.origin - struct.origin );
	forward = AnglesToForward( angles );
	
	limped = false;
	
	for ( ;; )
	{
		player_speed = gt_op( Distance( ( 0,0,0 ), self GetVelocity() ), 15 );

		//limp_yaw_ent			
		fast_enough = player_speed > ( 80 * self.g_speed_percent );
		
		player_angles 	= self GetPlayerAngles();
		player_forward 	= AnglesToForward( player_angles );
		
		correct_limp_direction = VectorDot( player_forward, forward ) >= 0.8;
		
		if ( fast_enough && correct_limp_direction )
			walking_count += 2;
		else
			walking_count -= 1;	
				
		walking_count = Clamp( walking_count, 0, cap );
		if ( walking_count < cap )
		{
			wait 0.05;
			continue;
		}
		
		walking_count = 0;
		if ( !limped )
		{
			limped = true;
			thread limp_internal();
			
			time 		= 2;
			ent 		= level spawn_tag_origin();
			ent.origin 	= ( self.unsteady_scale, 0, 0 );
			ent MoveTo( ( 1, 0, 0 ), time, time * 0.5, time * 0.5 );
			
			for ( ;; )
			{
				self.unsteady_scale = ent.origin[ 0 ];
				if ( self.unsteady_scale == 1 )
					break;
				wait 0.05;
			}
			ent Delete();
			return;
		}
		
		cap = RandomIntRange( 70, 125 );

		time = 0.45;
		roll = RandomFloatRange( -16, -11 );
		roll_ent moveto( ( roll, 0, 0 ), time, 0, time );
		wait time;
		
		time 	*= 0.8;
		offset 	 = RandomFloatRange( -2, 2 );
		roll_ent moveto( ( offset, 0, 0 ), time, time * 0.5, time * 0.5 );
		wait time;
	}
}

swivel_adjust_on_ads_and_fire()
{
	self endon( "LISTEN_end_player_limp" );
	
	// pitch / roll scales
	min_unsteady_scale			= 4.1;
	max_unsteady_scale			= 15;
	min_ads_unsteady_scale 		= 8.0;
	fire_unsteady_scale_rate	= 0.35;	// change per 0.05 sec
	unsteady_scale_rate			= 0.3; 	// change per 0.05 sec
	
	// yaw scale
	min_yaw_unsteady_scale			= 0.0;
	max_yaw_unsteady_scale			= 5.0;
	min_yaw_ads_unsteady_scale 		= 3.0;
	fire_yaw_unsteady_scale_rate	= 0.5;	// change per 0.05 sec
	yaw_unsteady_scale_rate			= 0.5; // change per 0.05 sec
	
	fire_unsteady_time			= 1.0;
	last_fire_unsteady_time		= GetTime();
	do_cooldown					= false;
	do_fire_unsteady			= false;
	
	for ( ; ; wait 0.05 )
	{
		if ( self HasWeapon( "p99" ) )
		{
			if ( flag( "FLAG_adsing" ) )
			{
				do_cooldown 		= false;
				self.unsteady_scale = gt_op( self.unsteady_scale, min_ads_unsteady_scale );
				self.yaw_unsteady_scale = gt_op( self.yaw_unsteady_scale, min_yaw_ads_unsteady_scale );
			}
			
			if ( flag( "FLAG_attack_button_pressed" ) )
			{
				do_cooldown 			= false;
				do_fire_unsteady		= true;
				last_fire_unsteady_time = GetTime();
			}
			
			if ( !flag( "FLAG_adsing" ) && !flag( "FLAG_attack_button_pressed" ) && self.unsteady_scale > min_unsteady_scale )
				do_cooldown = true;
				
			if ( do_cooldown && !flag( "FLAG_adsing" ) && !flag( "FLAG_attack_button_pressed" ) )
			{
				self.unsteady_scale 	-= unsteady_scale_rate;
				self.unsteady_scale  	 = gt_op( self.unsteady_scale, min_unsteady_scale );
				self.yaw_unsteady_scale -= yaw_unsteady_scale_rate;
				self.yaw_unsteady_scale  = gt_op( self.yaw_unsteady_scale, min_yaw_unsteady_scale );
			}
			
			if ( GetTime() - last_fire_unsteady_time >= fire_unsteady_time * 1000 )
				do_fire_unsteady = false;
			
			if ( do_fire_unsteady )
			{
				self.unsteady_scale 	+= fire_unsteady_scale_rate;
				self.unsteady_scale  	 = lt_op( self.unsteady_scale, max_unsteady_scale );
				self.yaw_unsteady_scale += fire_yaw_unsteady_scale_rate;
				self.yaw_unsteady_scale  = lt_op( self.yaw_unsteady_scale, max_yaw_unsteady_scale );
			}
		}
	}
}

limp_internal()
{
	self notify( "LISTEN_end_player_limp_internal" );
	self endon( "LISTEN_end_player_limp_internal" );
	self endon( "LISTEN_end_player_limp" );
	
	while ( true )
	{
		player_speed = gt_op( Distance( ( 0, 0, 0 ), self GetVelocity() ), 15 );

		if ( player_speed < 80  )
		{
			wait 0.05;
			continue;
		}
		stun_time = 2.3;
		self thread play_sound_on_entity( "breathing_hurt" );
		level notify ( "not_random_blur" );
		noself_delayCall( .5, ::setblur, 4, .25 );
		noself_delayCall( 1.2, ::setblur, 0, 1 );
		delaythread( stun_time, ::player_random_blur );
		delaythread( 1, ::fade_out, stun_time * 4 ); 
		delaythread( stun_time, ::fade_in, stun_time ); 
		//set_vision_set( "aftermath_hurt", stun_time * 2 );
		//delaythread( 1, ::set_vision_set, "aftermath_walking", stun_time );
		//delaythread( stun_time * 2, ::set_vision_set, "aftermath_walking", stun_time );
		self PlayRumbleOnEntity( "damage_light" );
		self blend_movespeedscale( 0.25, 0.3 );
		self delaythread( stun_time * 0.5, ::blend_movespeedscale, ENDING_MOVE_SPEED, stun_time );
//		level.player thread play_sound_on_entity( "breathing_hurt" );
		wait stun_time; 
		break;
	}	
}

