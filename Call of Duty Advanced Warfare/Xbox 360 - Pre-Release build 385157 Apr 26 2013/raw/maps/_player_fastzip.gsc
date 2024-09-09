#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include soundscripts\_audio;
#include soundscripts\_snd;

main()
{
	flag_init( "use_fastzip_hint" );
	
	add_hint_string( "hint_use_fastzip", &"FASTZIP_HARPOON_SWITCH", ::should_end_fastzip_hint );
	
	PreCacheTurret( "zipline_gun_player" );
	
	load_fx();
	load_model_anims();
	load_player_anims();
}

load_fx()
{
	//zipline fx
	level._effect[ "zipline_flash_view" ]			= LoadFX( "vfx/muzzleflash/zipline_flash_view" );
	level._effect[ "harpoon_dust" ]					= LoadFX( "vfx/trail/harpoon_dust" );
	level._effect[ "landing_target_valid" ]			= LoadFX( "fx/misc/ui_fastzip_valid" );
	level._effect[ "landing_target_invalid" ]		= LoadFX( "fx/misc/ui_fastzip_invalid" );
}

#using_animtree( "script_model" );
load_model_anims()
{
	level.scr_anim[ "_turret_fastzip" ][ "fastzip_aim_idle" ] = %fastzip_launcher_ads;
}

#using_animtree( "player" );
load_player_anims()
{
	level.scr_anim[ "_player_arms_fastzip" ][ "fastzip_pullout" ] = %fastzip_launcher_pullout_vm;
	level.scr_anim[ "_player_arms_fastzip" ][ "fastzip_ads" ] = %fastzip_launcher_ads_vm;
	level.scr_anim[ "_player_arms_fastzip" ][ "fastzip_putaway" ] = %fastzip_launcher_putaway_vm;
	level.scr_anim[ "_player_arms_fastzip" ][ "fastzip_land" ] = %fastzip_launcher_land_vm;
}

should_end_fastzip_hint()
{
	return flag( "use_fastzip_hint" );
}

copy_script_model( script_model )
{
	script_model_copy = Spawn( "script_model", script_model.origin );
	script_model_copy assign_animtree( script_model.animname );
	script_model_copy SetModel( script_model.model );
	return script_model_copy;
}

fastzip_turret_think( heli, turret_tag, player_rig, detach_delay )
{
	self endon( "death" );
	
	player_rig_copy = copy_script_model( player_rig );
	player_rig_copy.animname = "_player_arms_fastzip";	
	player_rig_copy Hide();

	valid_landings = getentarray( "valid_landing", "targetname" );
	AssertEx( valid_landings.size > 0, "no valid landing zones placed" );
	
	self wait_for_player_switch_to_turret();
	self notify( "using_zip" );

	zipline_gun_model = heli.zipline_gun_model[ turret_tag ];
	heli_turret = vehicle_scripts\_xh9_warbird::setup_zipline_gun( "zipline_gun_player", heli, turret_tag, zipline_gun_model.model, zipline_gun_model.rope_model, "_turret_fastzip" );
	heli_turret_rope = vehicle_scripts\_xh9_warbird::setup_zipline_gun( "zipline_gun_rope", heli, turret_tag, zipline_gun_model.rope_model, undefined, "_turret_fastzip" );
	
	self fastzip_turret_pullout( heli, turret_tag, player_rig_copy, zipline_gun_model );
	heli_turret Show();
	player_rig_copy Hide();
	
	heli_turret MakeUsable();
	heli_turret SetMode( "manual" );
	heli_turret_rope SetMode( "manual" );
	heli_turret UseBy( self );
	heli_turret TurretFireDisable();
	self DisableTurretDismount();
	heli_turret MakeUnusable();
	
	heli_turret.ground_target = spawn_tag_origin();
	heli_turret_rope SetTargetEntity( heli_turret.ground_target, (0,0,0) );
	
	//heli_turret thread debug_draw_target( heli_turret_rope );
	
	self wait_to_fire_rope( heli, heli_turret, valid_landings );
	rope_distance = heli_turret_rope fire_rope( heli_turret, heli_turret.ground_target.origin, zipline_gun_model );
	
	// get off turret
	heli_turret set_landing_target_fx( undefined );
	heli_turret UseBy( self );
	heli_turret SetTargetEntity( heli_turret.ground_target );
	
	self fastzip_turret_putaway( heli, turret_tag, player_rig_copy, heli_turret, zipline_gun_model );
	self thread player_fastzip( heli_turret_rope, heli_turret.ground_target.origin, player_rig_copy, detach_delay );
	self waittill( "fastzip_arrived" );	

	self waittill( "fastzip_landed" );
	player_rig_copy Delete();

	wait 0.5;
	
	heli_turret_rope retract_rope( rope_distance, "left" );	
	heli_turret_rope Delete();
	heli_turret.ground_target Delete();
	heli_turret Delete();
}

/*
// not working yet
turret_view_pip( heli_turret )
{
	cam = Spawn( "script_model", heli_turret.origin );
	cam SetModel( "tag_origin" );
	cam.angles = heli_turret.angles;
	cam linkto( heli_turret, "tag_player", (0,0,30), (0,0,0) );
	
	turret_pip = self newpip();
	turret_pip.freeCamera = true;
	turret_pip.entity = cam;
	turret_pip.foreground = true;
	
	turret_pip.fov = 50;
	
	turret_pip.ent_source = heli_turret;
	
	turret_pip.width = 220;
	turret_pip.height = 135; 
	turret_pip.x = 490;
	turret_pip.y = 25;
	
	turret_pip.border_thickness = 2;
	turret_pip.tag = "tag_origin";
	
	turret_pip.enable = true;
}
*/

#using_animtree( "script_model" );
fastzip_turret_pullout( heli, turret_tag, player_rig, turret_model )
{
	player_rig LinkTo( heli, turret_tag, (0,0,0), (0,0,0) );
	
	fastzip_pullout_guys = [];
	fastzip_pullout_guys[0] = player_rig;
	fastzip_pullout_guys[1] = turret_model;
	
	turret_model clear_script_model_anim( 0 );
	
	snd_message( "fastzip_turret_switch_to" );
	heli anim_first_frame( fastzip_pullout_guys, "fastzip_pullout", turret_tag );
	self PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	//wait 0.2;
	player_rig Show();
	
	delayThread( 1.2, ::lerp_fov_overtime, 2, 55 );
	heli anim_single( fastzip_pullout_guys, "fastzip_pullout", turret_tag );
	
	player_rig anim_stopanimscripted();
	player_rig SetAnim( level.scr_anim[ "_player_arms_fastzip" ][ "fastzip_ads" ], 1, 0, 1 );
	player_rig Unlink();
	
	turret_model Hide();
	if ( IsDefined( turret_model.attachment ) )
	{
		turret_model.attachment Hide();
	}

	snd_message( "fastzip_turret_switch_complete" );

	self Unlink();
}

/*
debug_draw_target( turret_rope )
{
	/#
	self.ground_target endon( "death" );
	
	while ( true )
	{
		start = self GetTagOrigin( "tag_player" );
		trace = BulletTrace( start, self.ground_target.origin, false );
		if( isDefined( trace[ "position" ] ) )
		{
			thread maps\_shg_debug::draw_point( trace[ "position" ], 5, (0,0,1), 0.2 );
		}

		start = turret_rope GetTagOrigin( "tag_aim" );
		trace = BulletTrace( start, self.ground_target.origin, false );
		if( isDefined( trace[ "position" ] ) )
		{
			thread maps\_shg_debug::draw_point( trace[ "position" ], 5, (1,0,0), 0.2 );
		}
		
		start = turret_rope GetTagOrigin( "tag_flash" );
		forward = AnglesToForward( turret_rope GetTagAngles( "tag_flash" ) );
		trace = BulletTrace( start, start + ( forward * 10000 ), false );
		if( isDefined( trace[ "position" ] ) )
		{
			thread maps\_shg_debug::draw_point( trace[ "position" ], 5, (1,1,0), 0.2 );
		}

		wait 0.05;
	}
	#/
}
*/

/*
 */
set_landing_target_fx( fx )
{
	if ( !IsDefined( self.current_landing_fx ) )
	{
		if ( IsDefined( fx ) )
		{
			self.current_landing_fx = fx;
			PlayFXOnTag( getfx( self.current_landing_fx ), self.ground_target, "tag_origin" );
		}
		
		return;
	}
	
	if ( IsDefined( self.current_landing_fx ) && !IsDefined( fx ) )
	{
		StopFXOnTag( getfx( self.current_landing_fx ), self.ground_target, "tag_origin" );
		self.current_landing_fx = undefined;
		return;
	}
	
	if ( self.current_landing_fx != fx )
	{
		assert( IsDefined( fx ) );
		assert( IsDefined( self.current_landing_fx ) );
		
		StopFXOnTag( getfx( self.current_landing_fx ), self.ground_target, "tag_origin" );
		
		self.current_landing_fx = fx;
		PlayFXOnTag( getfx( self.current_landing_fx ), self.ground_target, "tag_origin" );
	}
}

wait_to_fire_rope( heli, heli_turret, valid_landings )
{
	heli_turret.ground_target.angles = ( -90, 0, 0 );
	heli_turret.current_landing_fx = undefined;
	
	while( true )
	{
		start = heli_turret GetTagOrigin( "tag_player" );
		turret_angles = heli_turret GetTagAngles( "tag_player" );
		turret_forward = VectorNormalize( AnglesToForward( turret_angles ) );
		adjusted_start = start + ( turret_forward * 100 );
		end = start + ( turret_forward * 10000 );
		landing_valid = false;
		
		// keep rope turret aiming close to your current target to minimize convergence time
		//   when you show it
		heli_turret.ground_target.origin = end;
		trace = BulletTrace( adjusted_start, end, false );
		if ( isDefined( trace[ "position" ] ) )
		{
			heli_turret.ground_target.origin = trace[ "position" ];
			
			foreach( volume in valid_landings )
			{
				if( heli_turret.ground_target IsTouching( volume ) )
				{
					landing_valid = true;
					heli_turret set_landing_target_fx( "landing_target_valid" );
					break;
				}
			}
			
			if ( landing_valid )
			{
				if ( self AttackButtonPressed() )
				{
					AssertEx( IsDefined( heli_turret.ground_target ), "Turret must have a ground target ent defined" );
					snd_message( "fastzip_turret_fire" );
					return;
				}
			}
			else
			{
				heli_turret set_landing_target_fx( "landing_target_invalid" );
			}
		}
		else
		{
			heli_turret set_landing_target_fx( undefined );
		}
		
		wait( 0.05 );
	}
}

#using_animtree( "script_model" );
fire_rope( heli_turret, end, zipline_gun_model )
{
	rope_length = 200;
	fire_speed = 210;				// feet/sec
	
	fire_rate = fire_speed / 30;	// playback speed
	
	heli_turret Detach( zipline_gun_model.rope_model );
	zipline_gun_model Detach( zipline_gun_model.rope_model );

	// crashes?
	//self SnapToTargetEntity( heli_turret.ground_target, (0,0,28) );
	self Show();
	
	start = heli_turret GetTagOrigin( "tag_player" );
	dist = Distance( start, end ) / 12; //units to feet... ish
	AssertEx( dist <= rope_length, "distance is longer than the rope" );
	percent_of_anim = dist / rope_length;
	
	//play fx
	playfxontag(getfx("harpoon_dust"), self, "jnt_harpoon");
	playfxontag(getfx("zipline_flash_view"), self, "TAG_FLASH");
	
	rope_anim = %fastzip_launcher_fire_left;
	time_of_anim = GetAnimLength( rope_anim );
	time_to_interrupt = ( time_of_anim / fire_rate ) * percent_of_anim;
	self SetAnimKnob( rope_anim, 1, 0.2, fire_rate );
	
	heli_turret SetAnimKnob( rope_anim, 1, 0.2, 1 );
	
	time_to_interrupt = time_to_interrupt - 0.05;
	if ( time_to_interrupt > 0.05 )
	{
		wait( time_to_interrupt );
	}
		
	self SetAnim( rope_anim, 1, 0, 0 );
	self SetAnimTime( rope_anim, percent_of_anim );
	
	return dist;
}

#using_animtree( "script_model" );
fastzip_turret_putaway( heli, turret_tag, player_rig, heli_turret, turret_model )
{
	thread lerp_fov_overtime( 2, 65 );
	
	heli_turret Hide();
	turret_model Show();
	if ( IsDefined( turret_model.attachment ) )
	{
		turret_model.attachment Show();
	}
	
	fastzip_putaway_guys = [];
	fastzip_putaway_guys[0] = player_rig;
	fastzip_putaway_guys[1] = turret_model;

	heli_turret clear_script_model_anim( 0.2 );
	heli anim_first_frame( fastzip_putaway_guys, "fastzip_putaway", turret_tag );
	self PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	snd_message( "fastzip_turret_putaway" );
	
	// this is needed because getting off the turret will teleport the player to 
	//   the turret's dismount position and forces the player to its current angles,
	//   but will run after script finishes.  So force the player's angles to be the current
	//   view angles so the teleport will set the angles we want.
	self SetPlayerAngles( self GetPlayerAngles() );
	wait 0.2;
	player_rig Show();
	heli anim_single( fastzip_putaway_guys, "fastzip_putaway", turret_tag );
	
	turret_model anim_stopanimscripted();
	turret_model clear_script_model_anim( 0 );
	turret_model SetAnim( %fastzip_launcher_folded_idle_left, 1, 0, 1 );
}

player_fastzip( heli_turret_rope, end, player_rig, detach_delay )
{
	self thread player_camera_shake();
	self notify( "fastzip_start" );
	// animated slide down
	slide_anim = %fastzip_launcher_slidedown_left;
	heli_turret_rope SetAnimLimited( %add_slide, 1, 0, 1 );
	heli_turret_rope SetAnimLimited( slide_anim, 1, 0, 1 );
	
	self PlayerLinkToDelta( heli_turret_rope, "TAG_PLAYER_ATTACH", 1, 20, 20, 20, 20, true );
	snd_message( "fastzip_rappel" );
	
	if( IsDefined( detach_delay ) )
	{
		wait( detach_delay );
	}
	else
	{
		wait 0.05;
	}
	
	previous_position = self.origin;
	trace[ "fraction" ] = 1;
	ground_dir = (0,0,0);
	frame_velocity = (0,0,0);
	while( trace[ "fraction" ] == 1 )
	{
		wait( 0.05 );
		
		current_position = self.origin;
		frame_velocity = current_position - previous_position;
		ground_dir = frame_velocity * 3;
		trace = BulletTrace( current_position, current_position + ground_dir, false, self );
		previous_position = current_position;
	}
	
	self Unlink();
	self notify( "kill_camera_shake" );
	
	self thread player_fastzip_land( frame_velocity, player_rig );
	self notify( "fastzip_arrived" );

	heli_turret_rope SetAnimLimited( slide_anim, 1, 0, 0 );
}

player_fastzip_land( frame_velocity, player_rig )
{	
	player_velocity = frame_velocity * 20;
	self SetVelocity( player_velocity );
	
	air_velocity = undefined;
	while ( !self IsOnGround() )
	{
		air_velocity = self GetVelocity();
		wait 0.05;
	}
	
	snd_message("fastzip_hit_the_ground");
	
	velocity_angles = VectorToAngles( frame_velocity );
	land_org = SpawnStruct();
	land_org.origin = self.origin;
	land_org.angles = ( 0, velocity_angles[1] + 90, 0 );
	
	land_org anim_first_frame_solo( player_rig, "fastzip_land" );
	
	// try to predict where the player will end up and see if it's ok.
	//   adjust move delta by scripted node's transform to get it properly in world space
	local_move_delta = GetMoveDelta( player_rig getanim( "fastzip_land" ), 0, 1 );
	anim_end_pos = player_rig localToWorldCoords( local_move_delta );
	
	// figure out the max height you should start the trace from.  first check if your expected position is good
	//   and if it has any ceiling
	max_up_position = anim_end_pos + ( 0, 0, 24 );
	trace = PlayerPhysicsTraceInfo( anim_end_pos, max_up_position );
	if ( trace[ "fraction" ] > 0 )
	{
		max_up_position = trace[ "position" ] - ( 0, 0, 1 );
	}
	
	trace = PlayerPhysicsTraceInfo( max_up_position, max_up_position - ( 0, 0, 36 ) );
	if ( trace[ "fraction" ] > 0 )
	{
		if ( trace[ "fraction" ] < 1 )
		{
			// found a good ground position, adjust starting position so you end up on it
			good_end_pos = trace[ "position" ];
			to_good_pos_offset = good_end_pos - anim_end_pos;
			land_org.origin = land_org.origin + to_good_pos_offset;
		}
		
		// found valid ground, play landing animation
		self PlayerLinkToDelta( player_rig, "tag_player", 1, 180, 180, 180, 180, 1 );
		land_org anim_single_solo( player_rig, "fastzip_land" );
		self Unlink();
	}
	else
	{
		// couldn't find a good end position, just don't play landing.
	}
	
	/*
	ground_speed = Length( air_velocity );
	ground_velocity = ( air_velocity[0], air_velocity[1], 0 );
	ground_velocity = VectorNormalize( ground_velocity ) * ground_speed;
	self SetVelocity( ground_velocity );
	
	wait 0.05;
	
	self thread player_camera_shake_land();
	
	diff_vel = ground_velocity - self GetVelocity();
	push_vel = ( diff_vel * 0.65 * 0.3333 );
	push_speed = Length( push_vel );
	
	while ( push_speed > 1 )
	{
		self PushPlayerVector( push_vel );
		push_vel = push_vel * 0.9;
		push_speed = Length( push_vel );
		wait 0.05;
	}
	
	self PushPlayerVector( (0,0,0) );
	self notify( "kill_camera_shake" );
	*/
	
	self notify( "fastzip_landed" );
}

player_camera_shake()
{
	self endon( "fastzip_arrived" );
	self endon( "kill_camera_shake" );
	
	quake_scale = 0.1;
	quake_grow_rate = 0.8;
	quake_duration = 0.1;
	quake_max_scale = 0.45;
	
	quake_accel_time = quake_grow_rate;
	while ( true )
	{
		Earthquake( min( quake_scale, quake_max_scale ), quake_duration, self.origin, 100 );
		wait quake_duration;
		
		quake_accel_time -= quake_duration;
		
		if ( quake_accel_time < 0 )
		{
			quake_scale += 0.1;
			quake_accel_time = quake_grow_rate;
		}
	}
}

player_camera_shake_land()
{
	self endon( "kill_camera_shake" );
	
	quake_scale = 0.5;
	quake_duration = 0.2;
	while ( quake_scale > 0 )
	{
		Earthquake( quake_scale, quake_duration, self.origin, 100 );
		wait quake_duration;
		
		quake_scale -= 0.1;
	}
}

retract_rope( rope_distance, side )
{
	rope_length = 200;
	rope_ratio = rope_distance / rope_length;
	rope_ratio = 1 - min( rope_ratio, 1 );
	
	anim_frame_length = 30;
	anim_rate = 1;
	
	rope_anim = %fastzip_launcher_retract_left;
	if ( side == "right" )
	{
		rope_anim = %fastzip_launcher_retract_right;
	}
	
	self SetAnimKnob( rope_anim, 1, 0.2, anim_rate );
	self SetAnimTime( rope_anim, rope_ratio );
	
	play_time = ( anim_frame_length * (1 - rope_ratio) ) / ( 30 * anim_rate );
	wait play_time + 0.05;
}

#using_animtree( "script_model" );
clear_script_model_anim( fade_time )
{
	self ClearAnim( %root, fade_time );
}

#using_animtree( "player" );
clear_player_anim()
{
	self ClearAnim( %root, 0 );
}

wait_for_player_switch_to_turret()
{
	display_hint( "hint_use_fastzip" );
	wait_done = false;
	while ( !wait_done )
	{
		wait_time = 0.3;
		while ( level.player UseButtonPressed() )
		{
			wait_time -= 0.05;
			if ( wait_time < 0 )
			{
				wait_done = true;
				break;
			}
			
			wait 0.05;
		}
		
		wait 0.05;
	}
	
	flag_set( "use_fastzip_hint" );
}
