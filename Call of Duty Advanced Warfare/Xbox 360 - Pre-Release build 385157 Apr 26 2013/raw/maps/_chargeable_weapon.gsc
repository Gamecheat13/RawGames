
#include maps\_utility;
#include common_scripts\utility;
#include maps\_shg_utility;
#include maps\_hud_util;
#include soundscripts\_snd;


// in these tunables, lo and hi correspond to the settings at min charge and max charge, respectively

// this is the rumble we play, and we will change its height to change its intensity
CONST_rumble = "steady_rumble";
// this should match the fade intensity with distance range in the above rumble entity
CONST_rumble_fade_distance = 1000;

// the lo_foo and hi_foo mean, foo will be lerped between lo and hi, based on the charge time

// the number of frames to spread the shot over
CONST_lo_frames = 1;
CONST_hi_frames = 5;

// the spread of the shots, in degrees (radius of the cone)
CONST_lo_spread = 1;
CONST_hi_spread = 5;

// how much to vibrate
CONST_lo_rumble_intensity = 0;
CONST_hi_rumble_intensity = .1;

// earthquake scale (earthquake is played near the player)
CONST_earthquake_lo_scale = .1;
CONST_earthquake_hi_scale = .6;
// in multiples of the firing duration
CONST_earthquake_duration = 4; 
// how far through the duration of the shot the earthquake comes
CONST_earthquake_time_fraction = .5;

CONST_camera_shake_lo_intensity = .01;
CONST_camera_shake_hi_intensity = .1;
CONST_camera_shake_falloff_duration = .2;

// bullets come from here relative to the player's eye
CONST_player_eye_offset = (4, 0, -1);

// hud stuff
CONST_num_indicator_dots = 4;
CONST_hud_x = 320;
CONST_hud_y = 170;
CONST_hud_reticle_material = "charged_shot_reticle";
CONST_hud_reticle_corner_material = "charged_shot_reticle_corner";
CONST_hud_reticle_pip_material = "charged_shot_reticle_pip";

CONST_hud_reticle_corner_xoffset = 2;
CONST_hud_reticle_corner_yoffset = 2;

CONST_hudelem_indicator_color_pulse_speed_max = 45;
CONST_hudelem_indicator_color_pulse_speed = 25;
CONST_hudelem_indicator_pulse_rate = 0.5;

CONST_hudelem_circle_start_size = 16;

CONST_hudelem_corner_start_size_x = 16;
CONST_hudelem_corner_max_size_x = 32;
CONST_hudelem_corner_start_size_y = 16;
CONST_hudelem_corner_max_size_y = 24;

CONST_hudelem_corner_multiplier_x = 320;
CONST_hudelem_corner_multiplier_y = 320;

CONST_hudelem_circle_multiplier_x = 620;
CONST_hudelem_circle_multiplier_y = 620;	

// parameters for the radius damage that is fired off where the bullets hit
//CONST_damage_range = 128;
//CONST_damage_max = 300;
//CONST_damage_min = 50;
// don't fire the radius damage if the explosion's within this range of the player
CONST_explosion_arming_distance = 39 * 4;
// how far through the duration of the shot the explosion comes
CONST_explosion_time_fraction = 0;

// parameters for the physics explosion sphere
CONST_physics_outer_radius = 200;
CONST_physics_inner_radius = 50;
CONST_physics_magnitude = 2;


// this is the main entrypoint - it will enable the charged shot listener for all players
setup_charged_shot()
{
	// init stuff	
	level._effect[ "charged_shot_tracer_low" ]						= loadfx( "vfx/trail/charged_shot_1_trail" );
	level._effect[ "charged_shot_tracer_med" ]                      = loadfx( "vfx/trail/charged_shot_2_trail" );
	level._effect[ "charged_shot_tracer_high" ]                     = loadfx( "vfx/trail/charged_shot_3_trail" );
	
	level._effect[ "charged_shot_impact_low" ]                      = loadfx( "vfx/weaponimpact/charged_shot_impact_1" );
	level._effect[ "charged_shot_impact_med" ]                      = loadfx( "vfx/weaponimpact/charged_shot_impact_2" );
	level._effect[ "charged_shot_impact_high" ]                     = loadfx( "vfx/weaponimpact/charged_shot_impact_3" );
	
	level._effect[ "charged_shot_character_smoke" ]                 = loadfx( "vfx/smoke/charged_shot_character_smoke" );
	
	snd_message("wpn_deam160_init");

	PrecacheRumble(CONST_rumble);
	
	foreach(player in level.players)
	{
		player thread monitor_charge_time();
		player thread player_handle_charged_shot();
	}	
}

cleanup()
{
	self player_cleanup_rumble();
	self player_cleanup_reticle();
	self player_cleanup_charge_indicator();
	self player_cleanup_sound();	
}

get_max_charge_time()
{
	min_charge_time = GetMinChargeTime( self GetCurrentWeapon() );
	charge_time_per_shot = GetChargeTimePerShot( self GetCurrentWeapon() );
	max_charge_shots = GetMaxChargeShots( self GetCurrentWeapon() );
	max_charge_time = min_charge_time + ( charge_time_per_shot * max_charge_shots );
	return max_charge_time;
}

monitor_player_death()
{
	self waittill("death");
	self cleanup();
}

monitor_charge_time()
{
	self endon( "death" );
	
	self player_init_rumble();
	self player_init_reticle();
	self player_init_charge_indicator();
	self player_init_sound();
	
	self thread monitor_player_death();
	
	last_charge_time = 0;
	cleaned_up = true;

	while ( true )
	{
		weapon_is_chargeable = WeaponIsChargeable( self GetCurrentWeapon() );
		weapon_is_selected = (
			weapon_is_chargeable &&
			!self IsThrowingGrenade() &&
			!self IsReloading() &&
			!self IsMeleeing() &&
			!self IsMantling()
		);
		
		charge_time = level.player GetChargeTime();
		if ( weapon_is_selected )
		{
			began_charging = ( last_charge_time == 0 && charge_time > 0 );
			stopped_charging = ( last_charge_time > 0 && charge_time == 0 );
			min_charge_time = GetMinChargeTime( self GetCurrentWeapon() );
			max_charge_time = get_max_charge_time();
			
			cleaned_up = false;
			self player_do_rumble( charge_time, min_charge_time, max_charge_time );
			self player_do_reticle( charge_time, min_charge_time, max_charge_time );
			self player_do_charge_indicator( charge_time, min_charge_time, max_charge_time, last_charge_time );
			self player_do_sound( charge_time, began_charging, stopped_charging );
			self player_do_camera_shake( charge_time, min_charge_time, max_charge_time );
		}
		else
		{
			if(!cleaned_up)
			{
				self cleanup();
				cleaned_up = true;
			}
		}
		
		last_charge_time = charge_time;
		
		wait 0.05;
	}
}

player_handle_charged_shot()
{
	Assert(IsPlayer(self));
	
	self endon("death");
	
	while(true)
	{
		// reduce response time by waiting till the notifies are sent (not sure if helpful)
		level.player waittill( "energy_fire", charge_time );
		min_charge_time = GetMinChargeTime( level.player GetCurrentWeapon() );
		max_charge_time = level.player get_max_charge_time();
		self thread player_charged_shot( charge_time, min_charge_time, max_charge_time );
	}
}


set_default_hud_parameters()
{
	self.alignx = "left";
	self.aligny = "top";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	self.hidewhendead = false;
	self.hidewheninmenu = false;
	self.sort = 205;
	self.foreground = true;
	self.alpha = 0.65;
}

player_init_sound()
{
	Assert(!IsDefined(self.charged_shot_soundent));
	if(IsDefined(self.charged_shot_soundent))
	{
		self.charged_shot_soundent Delete();	
	}
	self.charged_shot_soundent = self spawn_tag_origin();
}

player_do_sound( charge_time, began_charging, stopped_charging )
{
	// sadly can't just linkto() the player
	self.charged_shot_soundent.origin = self.origin;
	self.charged_shot_soundent.angles = self.angles;		
		
	if(began_charging)
	{
		snd_message("wpn_deam160_charge");
	}
	
	if(stopped_charging)
	{
		level notify("aud_deam160_charge_break");
	}
}

player_cleanup_sound()
{
	self.charged_shot_soundent StopLoopSound();	
}

player_init_reticle()
{
	PrecacheShader(CONST_hud_reticle_material);
	PrecacheShader(CONST_hud_reticle_corner_material + "_tl");
	PrecacheShader(CONST_hud_reticle_corner_material + "_bl");
	PrecacheShader(CONST_hud_reticle_corner_material + "_tr");
	PrecacheShader(CONST_hud_reticle_corner_material + "_br");
	
	self.charged_shot_reticle_corners = [];
		
	self.charged_shot_reticle = createIcon(CONST_hud_reticle_material, CONST_hudelem_circle_start_size, CONST_hudelem_circle_start_size);
	self.charged_shot_reticle set_default_hud_parameters();
	self.charged_shot_reticle.alignX = "center";
	self.charged_shot_reticle.alignY = "middle";
	
	self.charged_shot_reticle_corners["tl"] = createIcon(CONST_hud_reticle_corner_material + "_tl", CONST_hudelem_corner_start_size_x, CONST_hudelem_corner_start_size_y);
	self.charged_shot_reticle_corners["tl"] set_default_hud_parameters();
	self.charged_shot_reticle_corners["tl"].alignX = "right";
	self.charged_shot_reticle_corners["tl"].alignY = "bottom";		
	
	self.charged_shot_reticle_corners["tr"] = createIcon(CONST_hud_reticle_corner_material + "_tr", CONST_hudelem_corner_start_size_x, CONST_hudelem_corner_start_size_y);
	self.charged_shot_reticle_corners["tr"] set_default_hud_parameters();
	self.charged_shot_reticle_corners["tr"].alignX = "left";
	self.charged_shot_reticle_corners["tr"].alignY = "bottom";			
	
	self.charged_shot_reticle_corners["bl"] = createIcon(CONST_hud_reticle_corner_material + "_bl", CONST_hudelem_corner_start_size_x, CONST_hudelem_corner_start_size_y);
	self.charged_shot_reticle_corners["bl"] set_default_hud_parameters();
	self.charged_shot_reticle_corners["bl"].alignX = "right";
	self.charged_shot_reticle_corners["bl"].alignY = "top";
	
	self.charged_shot_reticle_corners["br"] = createIcon(CONST_hud_reticle_corner_material + "_br", CONST_hudelem_corner_start_size_x, CONST_hudelem_corner_start_size_y);
	self.charged_shot_reticle_corners["br"] set_default_hud_parameters();
	self.charged_shot_reticle_corners["br"].alignX = "left";
	self.charged_shot_reticle_corners["br"].alignY = "top";
		
	player_cleanup_reticle();
}

player_do_reticle( charge_time, min_charge_time, max_charge_time )
{
	if(charge_time > min_charge_time)
	{
		spread = compute_spread( charge_time, min_charge_time, max_charge_time );
		shot_radius = tan( spread );
		
		xsize = shot_radius * CONST_hudelem_circle_multiplier_x;
		ysize = shot_radius * CONST_hudelem_circle_multiplier_y;
		
		self.charged_shot_reticle.alpha = 1;

		self.charged_shot_reticle SetShader(CONST_hud_reticle_material,int(ysize),int(ysize));

		xoffset = shot_radius * CONST_hudelem_corner_multiplier_x;
		yoffset = shot_radius * CONST_hudelem_corner_multiplier_y;
		
		xsize = clamp(shot_radius,CONST_hudelem_corner_start_size_x,CONST_hudelem_corner_max_size_x);
		ysize = clamp(shot_radius,CONST_hudelem_corner_start_size_y,CONST_hudelem_corner_max_size_y);
		
		self.charged_shot_reticle_corners["tl"].x = 0-CONST_hud_reticle_corner_xoffset-xoffset;
		self.charged_shot_reticle_corners["tl"].y = 0-CONST_hud_reticle_corner_yoffset-yoffset;
		self.charged_shot_reticle_corners["tl"].alpha = 1;
		self.charged_shot_reticle_corners["tl"] SetShader(CONST_hud_reticle_corner_material + "_tl",int(xsize),int(ysize));		

		self.charged_shot_reticle_corners["tr"].x = CONST_hud_reticle_corner_xoffset+xoffset;
		self.charged_shot_reticle_corners["tr"].y = 0-CONST_hud_reticle_corner_yoffset-yoffset;
		self.charged_shot_reticle_corners["tr"].alpha = 1;
		self.charged_shot_reticle_corners["tr"] SetShader(CONST_hud_reticle_corner_material + "_tr",int(xsize),int(ysize));		

		self.charged_shot_reticle_corners["bl"].x = 0-CONST_hud_reticle_corner_xoffset-xoffset;
		self.charged_shot_reticle_corners["bl"].y = CONST_hud_reticle_corner_yoffset+yoffset;		
		self.charged_shot_reticle_corners["bl"].alpha = 1;
		self.charged_shot_reticle_corners["bl"] SetShader(CONST_hud_reticle_corner_material + "_bl",int(xsize),int(ysize));
		
		self.charged_shot_reticle_corners["br"].x = CONST_hud_reticle_corner_xoffset+xoffset;
		self.charged_shot_reticle_corners["br"].y = CONST_hud_reticle_corner_yoffset+yoffset;
		self.charged_shot_reticle_corners["br"].alpha = 1;
		self.charged_shot_reticle_corners["br"] SetShader(CONST_hud_reticle_corner_material + "_br",int(xsize),int(ysize));	
		
		self player_set_all_reticle_colors((1,1,1));
	}
	else
	{
		self player_restore_reticle();
	}
}

player_restore_reticle()
{
	self.charged_shot_reticle.alpha = 1;
	
	self.charged_shot_reticle_corners["tl"].alpha = 1;
	self.charged_shot_reticle_corners["tr"].alpha = 1;
	self.charged_shot_reticle_corners["bl"].alpha = 1;
	self.charged_shot_reticle_corners["br"].alpha = 1;

	self.charged_shot_reticle_corners["tl"].x = 0-CONST_hud_reticle_corner_xoffset;
	self.charged_shot_reticle_corners["tl"].y = 0-CONST_hud_reticle_corner_yoffset;

	self.charged_shot_reticle_corners["tr"].x = CONST_hud_reticle_corner_xoffset;
	self.charged_shot_reticle_corners["tr"].y = 0-CONST_hud_reticle_corner_yoffset;

	self.charged_shot_reticle_corners["bl"].x = 0-CONST_hud_reticle_corner_xoffset;
	self.charged_shot_reticle_corners["bl"].y = CONST_hud_reticle_corner_yoffset;

	self.charged_shot_reticle_corners["br"].x = CONST_hud_reticle_corner_xoffset;
	self.charged_shot_reticle_corners["br"].y = CONST_hud_reticle_corner_yoffset;
	
	self.charged_shot_reticle SetShader(CONST_hud_reticle_material,CONST_hudelem_circle_start_size,CONST_hudelem_circle_start_size);
	
	self.charged_shot_reticle_corners["tl"] SetShader(CONST_hud_reticle_corner_material + "_tl",CONST_hudelem_corner_start_size_x,CONST_hudelem_corner_start_size_y);
	self.charged_shot_reticle_corners["bl"] SetShader(CONST_hud_reticle_corner_material + "_bl",CONST_hudelem_corner_start_size_x,CONST_hudelem_corner_start_size_y);
	self.charged_shot_reticle_corners["tr"] SetShader(CONST_hud_reticle_corner_material + "_tr",CONST_hudelem_corner_start_size_x,CONST_hudelem_corner_start_size_y);
	self.charged_shot_reticle_corners["br"] SetShader(CONST_hud_reticle_corner_material + "_br",CONST_hudelem_corner_start_size_x,CONST_hudelem_corner_start_size_y);	
	
	self player_set_all_reticle_colors((1,1,1));
}

player_cleanup_reticle()
{
	self.charged_shot_reticle.alpha = 0;
	
	self.charged_shot_reticle_corners["tl"].alpha = 0;
	self.charged_shot_reticle_corners["tr"].alpha = 0;
	self.charged_shot_reticle_corners["bl"].alpha = 0;
	self.charged_shot_reticle_corners["br"].alpha = 0;
}


player_init_rumble()
{
	self.charged_shot_rumble_ent = self spawn_tag_origin();
}

player_do_rumble( charge_time, min_charge_time, max_charge_time )
{
	rumble_intensity = linear_map_clamp(charge_time, min_charge_time, max_charge_time, CONST_lo_rumble_intensity, CONST_hi_rumble_intensity);
	if(rumble_intensity > 0)
	{
		if(!IsDefined(self.charged_shot_rumble_ent.rumbling))
		{
			self.charged_shot_rumble_ent.rumbling = true;	
			self.charged_shot_rumble_ent PlayRumbleLoopOnEntity(CONST_rumble);	
		}			
		self.charged_shot_rumble_ent.origin = self.origin + (0, 0, (1 - clamp(rumble_intensity, 0, 1)) * CONST_rumble_fade_distance);
	}
	else
	{
		player_cleanup_rumble();
	}
}

player_cleanup_rumble()
{
	if(IsDefined(self.charged_shot_rumble_ent.rumbling))
	{
		self.charged_shot_rumble_ent StopRumble(CONST_rumble);
		self.charged_shot_rumble_ent.rumbling = undefined;
	}
}


player_init_charge_indicator()
{
	for( i=1;i<=CONST_num_indicator_dots;i++)
	{
		PrecacheShader(CONST_hud_reticle_pip_material + i);
	}
	
	self.charge_indicator_hud = createIcon(CONST_hud_reticle_pip_material + "1",32,32);
	self.charge_indicator_hud set_default_hud_parameters();
	self.charge_indicator_hud.sort = 1;
	self.charge_indicator_hud.horzAlign = "fullscreen";
	self.charge_indicator_hud.alignX = "center";
	self.charge_indicator_hud.vertAlign = "fullscreen";
	self.charge_indicator_hud.x = CONST_hud_x;
	self.charge_indicator_hud.y = CONST_hud_y;
	self.charge_indicator_hud.color = (1, 1, 1);
	self.charge_indicator_hud.alpha = 0;
}

player_set_all_reticle_colors( color )
{
	self.charge_indicator_hud.color = color;
	self.charged_shot_reticle.color = color;
	self.charged_shot_reticle_corners["tl"].color = color;
	self.charged_shot_reticle_corners["tr"].color = color;
	self.charged_shot_reticle_corners["bl"].color = color;
	self.charged_shot_reticle_corners["br"].color = color;	
}

player_color_pulse(start_time)
{	
	charge_time = start_time;
	
	pulse_speed = CONST_hudelem_indicator_color_pulse_speed;
	
	snd_message("wpn_deam160_full_charge");
	
	while( level.player GetChargeTime() >= self get_max_charge_time() )
	{
		charge_time += pulse_speed;
		charge_lerp = ( sin( ( charge_time-start_time ) ) + 1.0 ) * 0.5;
						
		self.charge_indicator_hud.color = (charge_lerp,charge_lerp,charge_lerp);
	
		pulse_speed = min(CONST_hudelem_indicator_color_pulse_speed_max, pulse_speed+CONST_hudelem_indicator_pulse_rate);
		
		waitframe();
	}	
	
	self.charge_indicator_hud.color = (1,1,1);	
	
	level notify("aud_deam160_charge_break");
	
	
}

player_do_charge_indicator( charge_time, min_charge_time, max_charge_time, last_charge_time )
{
	num_dots = 0;	
			
	if(max_charge_time > 0)
	{
		prev_num_dots = int(linear_map_clamp(last_charge_time, 0, max_charge_time, 0, CONST_num_indicator_dots));		
		num_dots = int(linear_map_clamp(charge_time, 0, max_charge_time, 0, CONST_num_indicator_dots));
		
		if(prev_num_dots < num_dots)
		{
			snd_message("wpn_deam160_charge_dots_increase");
		}
	}
	
	if(num_dots > 0)
	{
		self.charge_indicator_hud.alpha = 1;	
		self.charge_indicator_hud SetShader(CONST_hud_reticle_pip_material + num_dots,32,32);
	}
	else
	{
		self.charge_indicator_hud.alpha = 0;	
	}
	
	if(charge_time >= max_charge_time && last_charge_time != charge_time )	
	{
		self thread player_color_pulse(charge_time);
	}
}

player_cleanup_charge_indicator()
{
	self.charge_indicator_hud.alpha = 0;
}

player_do_camera_shake( charge_time, min_charge_time, max_charge_time )
{
	if(charge_time > min_charge_time)
	{
		intensity = linear_map_clamp(charge_time, min_charge_time, max_charge_time, CONST_camera_shake_lo_intensity, CONST_camera_shake_hi_intensity);
		Earthquake(intensity, CONST_camera_shake_falloff_duration, self.origin, 512);	
	}
}

compute_spread( charge_time, min_charge_time, max_charge_time )
{
	return linear_map_clamp(charge_time, min_charge_time, max_charge_time, CONST_lo_spread, CONST_hi_spread);
}

play_charged_shot_fx( charge_time, min_charge_time, max_charge_time )
{
	charge_time_length = max_charge_time - min_charge_time;
	low_fx_charge = min_charge_time + ( charge_time_length * 0.2 );
	high_fx_charge = max_charge_time;
	
	gun_angles = self GetGunAngles();
	shot_forward = AnglesToForward(gun_angles);
	shot_origin = TransformMove(self GetEye(), gun_angles, (0, 0, 0), (0, 0, 0), CONST_player_eye_offset, (0, 0, 0))["origin"];
	shot_dest = shot_origin + 1000 * shot_forward;
	shot_up = AnglesToUp(gun_angles);
	shot_right = AnglesToRight(gun_angles);
	
	hit_fx = undefined;
	tracer_fx = undefined;
	if ( charge_time >= high_fx_charge )
	{
		// play high fx
		hit_fx = getfx( "charged_shot_impact_high" );
		tracer_fx = getfx( "charged_shot_tracer_high" );
		snd_message("wpn_deam160_shot", "large");
	}
	else if ( charge_time >= low_fx_charge )
	{
		// play med fx
		hit_fx = getfx( "charged_shot_impact_med" );
		tracer_fx = getfx( "charged_shot_tracer_med" );
		snd_message("wpn_deam160_shot", "medium");
	}
	else
	{
		// play low fx
		hit_fx = getfx( "charged_shot_impact_low" );
		tracer_fx = getfx( "charged_shot_tracer_low" );
		snd_message("wpn_deam160_shot", "small");
	}
	
	if ( IsDefined( tracer_fx ) )
	{
		PlayFX( tracer_fx, shot_origin, shot_forward, shot_up );
	}
	
	if ( IsDefined( hit_fx ) )
	{
		// just trace for solid hits
		result = BulletTrace( shot_origin, shot_dest, false, self, false );
		if ( result["fraction"] < 1 )
		{
			hit_origin = result[ "position" ];
			
			PlayFx( hit_fx, hit_origin, result["normal"]);
		}
	}
}

player_charged_shot( charge_time, min_charge_time, max_charge_time )
{
	Assert(IsPlayer(self));
		
	num_frames = int(linear_map_clamp(charge_time, min_charge_time, max_charge_time, CONST_lo_frames, CONST_hi_frames));
	earthquake_scale = linear_map_clamp(charge_time, min_charge_time, max_charge_time, CONST_earthquake_lo_scale, CONST_earthquake_hi_scale);
	
	Assert(CONST_lo_frames >= 1);
	earthquake_frame = int((num_frames - 1) * CONST_earthquake_time_fraction);	
	
	self thread play_charged_shot_fx( charge_time, min_charge_time, max_charge_time );
	
	for(f = 0; f < num_frames; f++)
	{
		if(f == earthquake_frame)
		{
			Earthquake(earthquake_scale, (num_frames * .05) * CONST_earthquake_duration, level.player.origin, 100);	
		}
		
		waitframe();
	}
}

AI_detect_charged_damage()
{
	notifier = SpawnStruct();
	notifier endon( "end_charged_shot_damage_thread" );
	
	self thread AI_charged_shot_wait_for_death( notifier );
	
	while ( true )
	{
		self waittill( "damage", amount, attacker, direction, position, damage_type );
		
		if ( IsDefined( self ) )
		{
			self.last_damage_pos = position;
			
			if ( IsDefined( damage_type ) && damage_type == "MOD_ENERGY" )
			{
				PlayFx( getfx( "charged_shot_character_smoke" ), self.origin );
			}
				
			if ( self.health <= 0 )
			{
				break;
			}
		}
	}
}

AI_charged_shot_wait_for_death( notifier )
{
	level.player endon( "death" );
	
	self waittill( "death" );
	wait( 0.05 );
	notifier notify( "end_charged_shot_damage_thread" );
}