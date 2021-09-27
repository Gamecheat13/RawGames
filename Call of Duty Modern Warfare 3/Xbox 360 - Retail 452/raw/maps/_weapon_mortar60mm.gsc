/*
	Script file to implement player-controlled mortar.
*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;

/*
	hint_string: hint string to display in order to use
	right_view_arc: right angle limit
	left_view_arc: left angle limit
	top_view_arc: top angle limit
	bottom_view_arc: bottom angle limit
	min_target_distance/max_target_distance: min/max distance for the target from the camera
	shell_arc_height: height of the projectile arc, from the fire point
	shell_air_time: time until the shell gets to the arc_height
	damage_range: radius of damage
	damage_max/damage_min: damage scales linearly from point of impact to max radius
	ammo: number of shots before mortar is disabled, undefined is infinite
*/
main( 	hint_string, 
		right_view_arc, left_view_arc, top_view_arc, bottom_view_arc, 
		max_target_height, min_target_distance, max_target_distance, shell_arc_height, shell_air_time, 
		damage_range, damage_max, damage_min,
		ammo,
		show_debug_draw )
{
	load_fx();
	load_player_anims();
	load_script_model_anims();
	
	PreCacheModel( "projectile_rpg7" );
	PreCacheModel( "viewmodel_mortar60mm" );
	PreCacheModel( "weapon_mortar60mm" );
	PreCacheString( hint_string );
	//PreCacheTurret( "mortar60mm" );

	/#	
	SetDvarIfUninitialized( "mortar_reticule_type", 0 );
	SetDvarIfUninitialized( "mortar_view_right", right_view_arc );
	SetDvarIfUninitialized( "mortar_view_left", left_view_arc );
	SetDvarIfUninitialized( "mortar_view_top", top_view_arc );
	SetDvarIfUninitialized( "mortar_view_bottom", bottom_view_arc );
	SetDvarIfUninitialized( "mortar_arc_height", shell_arc_height );
	SetDvarIfUninitialized( "mortar_arc_time", shell_air_time );
	#/
	
	flag_init( "mortar_in_use" );
	
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		player_mortar.hint_string = hint_string;
		player_mortar.camera_view_angle_right = right_view_arc;
		player_mortar.camera_view_angle_left = left_view_arc;
		player_mortar.camera_view_angle_top = top_view_arc;
		player_mortar.camera_view_angle_bottom = bottom_view_arc;
		player_mortar.world_yaw = AngleClamp180( player_mortar.angles[1] );
		
		player_mortar.max_target_height = max_target_height;
		player_mortar.min_target_distance = min_target_distance;
		player_mortar.max_target_distance = max_target_distance;
		player_mortar.shell_arc_height = shell_arc_height;
		player_mortar.shell_air_time = ( shell_air_time / 0.05 );
		player_mortar.shell_gravity = shell_arc_height / (player_mortar.shell_air_time * ( ( ( player_mortar.shell_air_time - 1 ) / 2 ) - player_mortar.shell_air_time ) );
		player_mortar.initial_shell_up_velocity = player_mortar.shell_gravity * player_mortar.shell_air_time * -1;
		
		player_mortar.damage_range = damage_range;
		player_mortar.damage_max = damage_max;
		player_mortar.damage_min = damage_min;

		if ( IsDefined( ammo ) )
		{
			player_mortar.max_ammo = ammo;
			player_mortar.ammo = ammo;
		}
		
		if ( IsDefined( show_debug_draw ) )
		{
			player_mortar.debug_draw = show_debug_draw;
		}
		
		player_mortar enable_mortar();
		
		/#
		player_mortar thread update_tuning();
		#/
	}
}

update_tuning()
{
	while ( true )
	{
		self.camera_view_angle_right = GetDvarFloat( "mortar_view_right" );
		self.camera_view_angle_left = GetDvarFloat( "mortar_view_left" );
		self.camera_view_angle_top = GetDvarFloat( "mortar_view_top" );
		self.camera_view_angle_bottom = GetDvarFloat( "mortar_view_bottom" );
			
		self.shell_arc_height = GetDvarFloat( "mortar_arc_height" );
		self.shell_air_time = ( GetDvarFloat( "mortar_arc_time" ) / 0.05 );
		
		shell_total_time = (self.shell_air_time * ( ( ( self.shell_air_time - 1 ) / 2 ) - self.shell_air_time ) );
		if ( shell_total_time == 0 )
		{
			self.shell_gravity = -9.8 * 12;
		}
		else
		{
			self.shell_gravity = self.shell_arc_height / shell_total_time;
		}

		self.initial_shell_up_velocity = self.shell_gravity * self.shell_air_time * -1;
		wait 0.05;
	}
}

load_fx()
{
	level._effect[ "mortar_target" ] 			= loadfx( "misc/ui_mortar" );
	level._effect[ "mortar_shell_hit_exp" ] 	= loadfx( "maps/warlord/mortarExp_default" );
	level._effect[ "mortar_shell_hit_exp_debris" ] 	= loadfx( "maps/warlord/mortarExp_debris" );
	level._effect[ "mortar_shell_impact_mud" ] 	= loadfx( "maps/warlord/mortar_impact_mud" );
	level._effect[ "mortar_shell_trail" ]		= loadfx( "smoke/smoke_geotrail_rpg" );
	level._effect[ "mortar_shell_flash" ]		= loadfx( "maps/warlord/mortar_flash" );
}

#using_animtree( "player" );
load_player_anims()
{
	level.scr_anim[ "player_rig" ][ "player_mortar_enter_r" ] 	= %player_mortor60mm_enter_r;
	level.scr_anim[ "player_rig" ][ "player_mortar_enter_l" ] 	= %player_mortor60mm_enter_l;
	level.scr_anim[ "player_rig" ][ "player_mortar_exit_r" ] 	= %player_mortor60mm_exit_r;
	level.scr_anim[ "player_rig" ][ "player_mortar_exit_l" ] 	= %player_mortor60mm_exit_l;
	level.scr_anim[ "player_rig" ][ "player_mortar_fire_r" ] 	= %player_mortor60mm_fire_r;
	level.scr_anim[ "player_rig" ][ "player_mortar_fire_l" ] 	= %player_mortor60mm_fire_l;
	level.scr_anim[ "player_rig" ][ "player_mortar_idle_r" ] 	= %player_mortor60mm_idle_r;
	level.scr_anim[ "player_rig" ][ "player_mortar_idle_r_add" ] 	= %player_mortor60mm_finger_idle_r;
	level.scr_anim[ "player_rig" ][ "player_mortar_idle_l" ] 	= %player_mortor60mm_idle_l;
	level.scr_anim[ "player_rig" ][ "player_mortar_turn_down_r" ] 	= %player_mortor60mm_turn_down_r;
	level.scr_anim[ "player_rig" ][ "player_mortar_turn_left_l" ] 	= %player_mortor60mm_turn_left_l;
	level.scr_anim[ "player_rig" ][ "player_mortar_turn_right_l" ] 	= %player_mortor60mm_turn_right_l;
	level.scr_anim[ "player_rig" ][ "player_mortar_turn_up_r" ] 	= %player_mortor60mm_turn_up_r;
	
	level.scr_animtree[ "player_rig" ] 					 		= #animtree;
	level.scr_model[ "player_rig" ] 							= "viewhands_player_yuri";
}

#using_animtree( "script_model" );
load_script_model_anims()
{
	level.scr_anim[ "mortar_tube" ][ "mortar_idle" ]			= %viewmodel_mortor60mm_idle;
	level.scr_anim[ "mortar_tube" ][ "mortar_fire" ]			= %viewmodel_mortor60mm_fire;
	level.scr_anim[ "mortar_tube" ][ "mortar_crank_up" ]		= %viewmodel_mortor60mm_crank_turn_up;
	level.scr_anim[ "mortar_tube" ][ "mortar_crank_down" ]		= %viewmodel_mortor60mm_crank_turn_down;

	level.scr_animtree[ "mortar_tube" ] 					 	= #animtree;
	level.scr_model[ "mortar_tube" ] 							= "viewmodel_mortar60mm";
}

init_anim_controller( id )
{
	anim_controller = SpawnStruct();
	anim_controller.id = id;
	anim_controller.animation = undefined;
	anim_controller.paused = false;
	return anim_controller;
}

wait_use_button_up()
{
	while ( level.player useButtonPressed() )
	{
		wait 0.05;
	}
}

wait_use_button_down()
{
	while ( !level.player useButtonPressed() ||
			( IsDefined( level.mortar_tube ) && level.player.animation_blocking ) )
	{
		wait 0.05;
	}
}

wait_until_animation_finished()
{
	while ( IsDefined( level.mortar_tube ) && level.player.animation_blocking )
	{
		wait 0.05;
	}
}

wait_until_done()
{
	self endon( "mortar_dismount_requested" );
	
	wait_use_button_up();
	wait_use_button_down();
}

watch_mortar_use()
{
	self endon( "mortar_disabled" );
	level.player endon( "death" );
	
	while ( true )
	{
		self waittill( "trigger" );
		
		// don't equip while meleeing
		if ( level.player IsMeleeing() )
		{
			continue;
		}
		
		self makeUnusable();

		flag_set( "mortar_in_use" );
		level notify( "mortar_equipped" );
		
		level.player.animation_blocking = false;
		level.player.wait_for_fire = false;
		
		equip_mortar();
		
		thread aim_mortar();
		thread watch_mortar_fire();
		thread mortar_cleanup();
		
		while ( flag( "mortar_in_use" ) )
		{
			// wait to be done using
			if ( !IsDefined( self.dismount_requested ) || !self.dismount_requested )
			{
				self wait_until_done();
			}
			
			self wait_until_animation_finished();
			
			if ( ( !IsDefined( self.disable_dismount ) || !self.disable_dismount ) ||
				 ( IsDefined( self.dismount_requested ) && self.dismount_requested ) )
			{
				self.dismount_requested = false;
				flag_clear( "mortar_in_use" );
				
				// done using
				self notify( "mortar_done" );
				thread unequip_mortar();
				self waittill( "mortar_unequipped" );
		
				self makeUsable();
			}

			wait_use_button_up();
		}
	}
}

equip_mortar()
{
	level.player EnableSlowAim();
	level.player allowCrouch( false );
	level.player allowProne( false );
	level.player DisableWeapons();
	
	//audio play mortar pickup sound
	aud_send_msg("player_mortar_attach");
	
	while ( level.player GetStance() != "stand" )
	{
		// if not standing, wait to get to stand stance
		wait 0.05;
	}
	
	// swap level mortar with animated version
	self Hide();
	
	// figure out yaw arcs given world yaw and current yaw
	to_world_yaw = AngleClamp180( self.world_yaw - self.angles[1] );
	self.relative_view_angle_right = self.camera_view_angle_right - to_world_yaw;
	self.relative_view_angle_left = self.camera_view_angle_left + to_world_yaw;
	
	if ( self.relative_view_angle_right < 0 )
		self.relative_view_angle_right = 0;
		
	if ( self.relative_view_angle_left < 0 )
		self.relative_view_angle_left = 0;
	
	//equip_mortar_turret();
	
	level.mortar_tube = spawn_model_with_anim_controller( "mortar_tube", self.origin, self.angles, (["mortar_tube"]) );
	level.player_rig = spawn_model_with_anim_controller( "player_rig", level.player.origin, self.angles, (["arm_l", "arm_r"]) );

	level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1, 0, 0, 0, 0 );
	level.player FreezeControls( true );
	
	level.mortar_tube thread play_animation_loop( "mortar_idle", "mortar_tube" );
	level.mortar_tube play_anim_on_arms( level.player_rig, "player_mortar_enter", 1 );
	
	// dummy player rig to control the camera
	level.player_camera = spawn_model_with_anim_controller( "player_rig", level.player_rig.origin, level.player_rig.angles, (["arm_l", "arm_r"]) );
	level.player_camera Hide();
	
	// dummy player rig to lerp player between rigs
	level.player_lerper = spawn_model_with_anim_controller( "player_rig", level.player_rig.origin, level.player_rig.angles, (["arm_l", "arm_r"]) );
	level.player_lerper Hide();
	
	level.player PlayerLinkToDelta( level.player_camera, "tag_player", 1, self.relative_view_angle_right, self.relative_view_angle_left, self.camera_view_angle_top, self.camera_view_angle_bottom );
	
	level.player_camera thread play_animation_loop( "player_mortar_idle_r", "arm_r" );
	level.player_camera thread play_animation_loop( "player_mortar_idle_l", "arm_l" );

	thread play_crank_idle( level.player_rig, "arm_r", level.mortar_tube, "mortar_tube" );
	level.player_rig thread play_animation_loop( "player_mortar_idle_l", "arm_l" );
	
	level.player_lerper thread play_animation_loop( "player_mortar_idle_r", "arm_r" );
	level.player_lerper thread play_animation_loop( "player_mortar_idle_l", "arm_l" );
	
	self.last_direction = undefined;
}

equip_mortar_turret()
{
	level.turret_mortar = SpawnTurret( "misc_turret", self.origin, "mortar60mm" );
	level.turret_mortar.angles = self.angles;
	level.turret_mortar SetModel( "viewmodel_mortar60mm" );
	level.turret_mortar Hide();
	level.turret_mortar SetMode( "manual" );
	level.turret_mortar TurretFireDisable();
	level.turret_mortar UseBy( level.player );
	level.turret_mortar MakeUnusable();
	level.player DisableTurretDismount();
}

spawn_model_with_anim_controller( model_name, position, orientation, anim_controller_ids )
{
	anim_model = spawn_anim_model( model_name, position );
	anim_model.angles = orientation;
	anim_model.anim_controllers = [];
	
	foreach ( anim_controller_id in anim_controller_ids )
	{
		anim_model.anim_controllers[ anim_controller_id ] = init_anim_controller( anim_controller_id );
	}
	return anim_model;
}

unequip_mortar()
{
	level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1, 0, 0, 0, 0 );

	//audio detach sound
	aud_send_msg("player_mortar_detach");
	
	level.player_rig delaythread( 0.2, ::center_pitch, 0.3 );
	level.mortar_tube play_anim_on_arms( level.player_rig, "player_mortar_exit", 1 );
	
	//level.player CameraUnlink( level.player_rig );
	self.angles = ( self.angles[0], level.mortar_tube.angles[1], self.angles[2] );
	self DontInterpolate();
	self Show();
	level.mortar_tube Delete();
	level.player_rig Delete();
	level.player_camera Delete();
	level.player_lerper Delete();
	level.player EnableWeapons();
	level.player allowCrouch( true );
	level.player allowProne( true );
	
	level.player DisableSlowAim();
	
	self notify( "mortar_unequipped" );
	
	//unequip_mortar_turret();
}

center_pitch( lerp_time )
{
	// center the pitch over a short time, prevents player from
	//   getting stuck in geo after exit animation
	initial_angles = self.angles;
	time_per_cycle = lerp_time / 0.05;
	lerp_per_cycle = -1 * ( AngleClamp180( initial_angles[0] ) / time_per_cycle );
	
	while ( lerp_time > 0 )
	{
		self.angles = ( AngleClamp180( self.angles[0] + lerp_per_cycle ), self.angles[1], self.angles[2] );
		lerp_time = lerp_time - 0.05;
		wait 0.05;
	}
}

unequip_mortar_turret()
{
	level.turret_mortar Delete();
}

play_anim_on_arms( entity, animation_name, playback_rate )
{	
	level.player.animation_blocking = true;
	right_animation = animation_name + "_r";
	left_animation = animation_name + "_l";
	
	neworg = GetStartOrigin( self.origin, self.angles, entity getAnim( right_animation ) );
	newangles = GetStartAngles( self.origin, self.angles, entity getAnim( right_animation ) );

	entity.origin = neworg;
	entity.angles = newangles;
	
	entity clear_additive_idle( "arm_r" );
	
	entity add_wait( ::play_animation_blocking, right_animation, "arm_r", playback_rate );
	entity add_wait( ::play_animation_blocking, left_animation, "arm_l", playback_rate );
	entity do_wait();
	level.player.animation_blocking = false;
}

play_animation_blocking( animation_name, anim_controller_id, playback_rate )
{
	anim_controller = self.anim_controllers[ anim_controller_id ];
	
	if ( IsDefined( anim_controller.animation ) )
	{
		self clearAnim( anim_controller.animation, 0.2 );
	}
	
	play_flagged_animation( anim_controller, animation_name, 0, playback_rate );
	self waittillmatch( animation_name, "end" );
	self clearAnim( anim_controller.animation, 0 );
	anim_controller.animation = undefined;
	anim_controller.animation_name = undefined;
}

play_additive_idle( anim_controller_id )
{
	anim_controller = self.anim_controllers[ anim_controller_id ];
	add_anim = self getAnim( "player_mortar_idle_r_add" );
	anim_controller.additive_anim = add_anim;
	self setAnim( add_anim, 1, 0.2, 1 );
}

clear_additive_idle( anim_controller_id )
{
	anim_controller = self.anim_controllers[ anim_controller_id ];
	if ( IsDefined( anim_controller.additive_anim ) )
	{
		self clearAnim( anim_controller.additive_anim, 0.2 );
		anim_controller.additive_anim = undefined;
	}
}

play_crank_idle( player_rig, player_anim_controller_id,
				 mortar_rig, mortar_anim_controller_id )
{
	player_anim_controller = player_rig.anim_controllers[ player_anim_controller_id ];
	mortar_anim_controller = mortar_rig.anim_controllers[ mortar_anim_controller_id ];
	
	if ( IsDefined( player_anim_controller.animation ) )
	{
		player_rig clearAnim( player_anim_controller.animation, 0 );
	}
	if ( IsDefined( mortar_anim_controller.animation ) )
	{
		mortar_rig clearAnim( mortar_anim_controller.animation, 0 );
	}
	
	player_rig play_additive_idle( player_anim_controller_id );
	
	player_rig play_flagged_animation( player_anim_controller, "player_mortar_turn_down_r", 0, 0 );
	mortar_rig play_flagged_animation( mortar_anim_controller, "mortar_crank_down", 0, 0 );
}

play_crank_animation( player_rig, player_animation_name, player_anim_controller_id,
					  mortar_rig, mortar_animation_name, mortar_anim_controller_id,
					  pause_anim, playback_rate )
{
	player_anim_controller = player_rig.anim_controllers[ player_anim_controller_id ];
	mortar_anim_controller = mortar_rig.anim_controllers[ mortar_anim_controller_id ];
	playback_rate = abs( playback_rate );
	
	if ( IsDefined( player_anim_controller.animation ) )
	{
		if ( pause_anim )
		{
			if ( player_anim_controller.paused )
			{
				return;
			}

			player_rig setAnim( player_anim_controller.animation, 1, 0, 0 );
			mortar_rig setAnim( mortar_anim_controller.animation, 1, 0, 0 );
			player_anim_controller.paused = true;
			mortar_anim_controller.paused = true;
			player_rig play_additive_idle( player_anim_controller_id );
		}
		else if ( player_animation_name == player_anim_controller.animation_name )
		{
			// if already was playing same anim, just continue it
			player_rig clear_additive_idle( player_anim_controller_id );
			player_rig setAnim( player_anim_controller.animation, 1, 0, playback_rate );
			mortar_rig setAnim( mortar_anim_controller.animation, 1, 0, playback_rate );
			player_anim_controller.paused = false;
			mortar_anim_controller.paused = false;
		}
		else
		{
			anim_time = player_rig GetAnimTime( player_anim_controller.animation );
			anim_time = 1 - anim_time;
			if ( anim_time >= 1 || anim_time < 0 )
			{
				anim_time = 0;
			}
			
			player_rig clear_additive_idle( player_anim_controller_id );
			player_rig clearAnim( player_anim_controller.animation, 0 );
			mortar_rig clearAnim( mortar_anim_controller.animation, 0 );
			player_rig play_flagged_animation( player_anim_controller, player_animation_name, 0, playback_rate );
			mortar_rig play_flagged_animation( mortar_anim_controller, mortar_animation_name, 0, playback_rate );
			player_rig setAnimTime( player_anim_controller.animation, anim_time );
			mortar_rig setAnimTime( mortar_anim_controller.animation, anim_time );
		}
	}
	else
	{
		player_rig clear_additive_idle( player_anim_controller_id );
		player_rig play_flagged_animation( player_anim_controller, player_animation_name, 0, playback_rate );
		mortar_rig play_flagged_animation( mortar_anim_controller, mortar_animation_name, 0, playback_rate );
	}
}

play_animation_loop( animation_name, anim_controller_id )
{
	anim_controller = self.anim_controllers[ anim_controller_id ];
	
	if ( IsDefined( anim_controller.animation ) )
	{
		self clearAnim( anim_controller.animation, 0.2 );
		play_flagged_animation( anim_controller, animation_name, 0.2, 1 );
	}
	else
	{
		play_flagged_animation( anim_controller, animation_name, 0.2, 1 );
	}
}

play_flagged_animation( anim_controller, animation_name, transition_time, playback_rate )
{
	new_anim = self getAnim( animation_name );
	anim_controller.animation = new_anim;
	anim_controller.animation_name = animation_name;
	anim_controller.paused = ( playback_rate == 0 );
	
	self setFlaggedAnim( anim_controller.animation_name, anim_controller.animation, 1, transition_time, playback_rate );
}

aim_mortar()
{
	self endon( "mortar_done" );
	level.player endon( "death" );
	
	self.mortar_no_target = GetEntArray( "mortar_no_target", "targetname" );
	
	self.aim_arrow = Spawn( "script_model", (0,0,0) );
	self.aim_arrow SetModel( "tag_origin" );
	self.aim_arrow.angles = ( -90, 0, 0 );
	playfxontag( getfx( "mortar_target" ), self.aim_arrow, "tag_origin" );

	while ( true )
	{
		if ( level.player.animation_blocking || level.player.wait_for_fire )
		{
			wait 0.05;
			continue;
		}
		
		// update model and fx with current target
		self paint_target();
		
		// play correct animation
		if ( IsDefined( self.last_direction ) )
		{
			direction_delta = self.direction - self.last_direction;
			normalized_delta = direction_delta[0] / 0.60;
			if ( normalized_delta > 0.01 )
			{
				thread play_crank_animation( level.player_rig, "player_mortar_turn_down_r", "arm_r", 
											 level.mortar_tube, "mortar_crank_down", "mortar_tube", false, normalized_delta );
			}
			else if ( normalized_delta < -0.01 )
			{
				thread play_crank_animation( level.player_rig, "player_mortar_turn_up_r", "arm_r", 
											 level.mortar_tube, "mortar_crank_up", "mortar_tube", false, normalized_delta );
			}
			else
			{
				thread play_crank_animation( level.player_rig, "player_mortar_idle_r", "arm_r", 
											 level.mortar_tube, "mortar_idle", "mortar_tube", true, normalized_delta );
			}
			
			if ( direction_delta[1] > 0.1 )
			{
				level.player_rig thread play_animation_loop( "player_mortar_turn_left_l", "arm_l" );
			}
			else if ( direction_delta[1] < -0.1 )
			{
				level.player_rig thread play_animation_loop( "player_mortar_turn_right_l", "arm_l" );
			}
			else
			{
				level.player_rig thread play_animation_loop( "player_mortar_idle_l", "arm_l" );
			}
		}
		
		self.last_direction = self.direction;
				
		wait 0.05;
	}
}

paint_target()
{
	// mortar goes up/down with player's up/down
	//rig_offset_angles = (-18.374, 0, 0);
	//self.direction = level.player getPlayerAngles();
	//level.mortar_tube.angles = self.direction + rig_offset_angles;
	//level.player_rig.angles = self.direction + rig_offset_angles;
	
	// mortar goes down/up with player's up/down
	rig_offset_angles = (18.374, 0, 0);
	self.direction = level.player getPlayerAngles();
	mortar_tube_angles = ( self.direction[0] * -1, self.direction[1], self.direction[2] );
	level.player_rig.angles = mortar_tube_angles + rig_offset_angles;
	level.mortar_tube.angles = mortar_tube_angles + rig_offset_angles;
	
	self.mortar_aim_start_pos = level.mortar_tube GetTagOrigin( "tag_flash" );
	
	calculate_target_pos();
	
	calculate_shell_velocity();
	
	trace_through_arc();
	
	self.aim_arrow.origin = self.mortar_aim_target_pos;
	self.aim_arrow RotateTo( VectorToAngles( self.mortar_aim_target_normal ), 0.2 );
	
	/#
	if ( self.debug_draw == 1 )
	{
		debug_draw_arc();
	}
	#/
}

calculate_target_pos()
{
	reticule_type = GetDvar( "mortar_reticule_type" );
	
	direction = level.player getPlayerAngles();
	direction_vec = anglesToForward( direction );
	trace_start_pos = level.player getEye();
	trace_start_pos = trace_start_pos + ( direction_vec * self.min_target_distance );
	trace_end_pos = trace_start_pos + ( direction_vec * self.max_target_distance );
	
	trace_done = false;
	ideal_target = Spawn( "script_origin", trace_end_pos );
	
	while ( !trace_done )
	{
		trace = BulletTrace( trace_start_pos, trace_end_pos, 0, undefined );
		if ( trace[ "fraction" ] < 1 )
		{
			self.mortar_aim_target_pos = trace["position"];
			
			// make sure the target is not in a "no target" zone
			not_valid_target = false;
			if ( IsDefined( self.mortar_no_target ) )
			{
				ideal_target.origin = self.mortar_aim_target_pos;
				foreach ( no_target_area in self.mortar_no_target )
				{
					if ( ideal_target IsTouching( no_target_area ) )
					{
						not_valid_target = true;
						break;
					}
				}
			}
			
			if ( not_valid_target )
			{
				trace_start_pos = self.mortar_aim_target_pos + ( direction_vec * 64 );
				continue;
			}
			
			if ( reticule_type == "1" )
			{
				self.mortar_aim_target_normal = trace[ "normal" ];
			}
			else
			{
				self.mortar_aim_target_normal = (0,0,1);
			}
			
			trace_done = true;
		}
		else
		{
			self.mortar_aim_target_pos = trace_end_pos;
			self.mortar_aim_target_normal = (0,0,1);
			trace_done = true;
		}
	}
	
	ideal_target Delete();
}

calculate_shell_velocity()
{
	// figure out total time it would be in the air 
	downward_arc_distance = self.mortar_aim_target_pos[2] - ( self.mortar_aim_start_pos[2] + self.shell_arc_height );
	
	downward_time = quadratic_equation( 1, -1, ( (-2 * downward_arc_distance) / (self.shell_gravity) ), true );
	
	self.total_air_time = self.shell_air_time + downward_time;
	
	start_pos_2d = ( self.mortar_aim_start_pos[0], self.mortar_aim_start_pos[1], 0 );
	end_pos_2d = ( self.mortar_aim_target_pos[0], self.mortar_aim_target_pos[1], 0 );
	
	xy_distance = Distance( start_pos_2d, end_pos_2d );
	
	velocity_magnitude = xy_distance / self.total_air_time;
	
	yaw_angles = ( 0, self.direction[1], 0 );
	forward_velocity = AnglesToForward( yaw_angles );
	forward_velocity = forward_velocity * velocity_magnitude;
	
	velocity_vector = ( forward_velocity[0], forward_velocity[1], self.initial_shell_up_velocity );
	self.mortar_aim_fire_velocity = velocity_vector;
}

// since the raycast might miss objects that the arc could hit, 
//   figure out the max possible height point on the arc and make sure nothing is in the way
trace_through_arc()
{
	reticule_type = GetDvar( "mortar_reticule_type" );
	
	downward_arc_distance = self.max_target_height - ( self.mortar_aim_start_pos[2] + self.shell_arc_height );
	downward_time = quadratic_equation( 1, -1, ( (-2 * downward_arc_distance) / (self.shell_gravity) ), true );
	time_at_max_target_height = floor( self.shell_air_time + downward_time );
	acceleration = ( 0, 0, self.shell_gravity );
	
	acceleration_over_time = ( ( time_at_max_target_height * (time_at_max_target_height - 1) ) / 2 ) * acceleration;
	position_at_time = self.mortar_aim_start_pos + (time_at_max_target_height * self.mortar_aim_fire_velocity) + acceleration_over_time;

	if ( self.debug_draw == 1 )
	{	
		line( position_at_time, self.mortar_aim_target_pos, (1, 0, 0) );
	}
	
	// see if you hit anything from the max possible target height to your current target height	
	trace = BulletTrace( position_at_time, self.mortar_aim_target_pos, 0, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		self.mortar_aim_target_pos = trace["position"];
		
		if ( reticule_type == "1" )
		{
			self.mortar_aim_target_normal = trace[ "normal" ];
		}
	}
	
	if ( reticule_type == "2" )
	{
		// try making normal the last part of the arc
		self.mortar_aim_target_normal = position_at_time - self.mortar_aim_target_pos;
		self.mortar_aim_target_normal = VectorNormalize( self.mortar_aim_target_normal );
	}
}

debug_draw_arc()
{
	current_step = 1;
	debug_step = 5;
	debug_draw_pos = self.mortar_aim_start_pos;
	
	pos = self.mortar_aim_start_pos;
	velocity = self.mortar_aim_fire_velocity;
	acceleration = ( 0, 0, self.shell_gravity );
	
	while ( true )
	{
		pos = pos + velocity;
		velocity = velocity + acceleration;

		if ( current_step == 0 )
		{
			line( debug_draw_pos, pos );
			debug_draw_pos = pos;
		}
		current_step = current_step + 1;
		if ( current_step == debug_step )
		{
			current_step = 0;
		}
		
		if ( pos[2] < self.mortar_aim_target_pos[2] )
		{
			break;
		}
	}
}

mortar_cleanup()
{
	self waittill( "mortar_done" );
	self.aim_arrow Delete();
}

quadratic_equation( a, b, c, isPlus )
{
	squared_value = ( b * b ) - ( 4 * a * c );
	
	square_root = sqrt( squared_value );
	
	if ( isPlus )
	{
		t = ( 0 - b + square_root ) / ( 2 * a );
	}
	else
	{
		t = ( 0 - b - square_root ) / ( 2 * a );
	}
	
	return t;
}

watch_mortar_fire()
{
	self endon( "mortar_done" );
	level.player endon( "death" );
	if ( !IsAlive( level.player ) )
		return;
	
	NotifyOnCommand( "mortar_fired", "+attack" );
	NotifyOnCommand( "mortar_fired", "+attack_akimbo_accessible" );	// support accessibility control scheme
	while ( true )
	{
		level.player waittill( "mortar_fired" );
		level.player.wait_for_fire = true;
		level.player FreezeControls( true );
		waittillframeend;
		self paint_target();
		fire_mortar();
		level.player FreezeControls( false );
		level.player.wait_for_fire = false;
		
		decrement_mortar_ammo();
	}
}

fire_blur()
{
	setblur(1,.125);
	wait(.35);
	setblur(0,.25);
}

fire_mortar()
{
	last_angle = level.player GetPlayerAngles();
	end_angle = level.player_rig GetTagAngles( "tag_player" );
	level.player switch_player_link_with_lerp( level.player_camera, level.player_rig, "tag_player", last_angle, end_angle, 0.2, 0, 0, 0, 0 );
	
	level.mortar_tube thread play_animation_blocking( "mortar_fire", "mortar_tube", 1 );
	level.mortar_tube thread play_anim_on_arms( level.player_rig, "player_mortar_fire", 1 );
	
	level.player_rig thread start_notetrack_wait( level.player_rig, "player_mortar_fire_r", "any" );
	level.player_rig waittillmatch( "player_mortar_fire_r", "mortor_fire" );
	
	PlayFXOnTag( GetFX( "mortar_shell_flash" ), level.mortar_tube, "tag_flash" );

	// aud - play sfx for weapon fire
	aud_send_msg("player_fire_mortar");
	
	if ( !IsDefined( level.player.mortar_shots ) )
	{
		level.player.mortar_shots = 0;
	}
	level.player.mortar_shots++;
	
	time_to_target = self.total_air_time;

	//Set a quick blur on the player
	thread fire_blur();
	
	// rumble
	level.player PlayRumbleOnEntity( "artillery_rumble" );

	level.mortar_tube fire_mortar_shell( self.mortar_aim_start_pos, self.mortar_aim_target_pos, self.mortar_aim_fire_velocity, self.shell_gravity, self.damage_range, self.damage_max, self.damage_min, 0.2, self.debug_draw, time_to_target );
	level.player_rig waittillmatch( "player_mortar_fire_r", "end" );
	
	waittillframeend;

	thread play_crank_idle( level.player_rig, "arm_r", level.mortar_tube, "mortar_tube" );
	level.player_rig thread play_animation_loop( "player_mortar_idle_l", "arm_l" );
	self.last_direction = undefined;

	level.player switch_player_link_with_lerp( level.player_rig, level.player_camera, "tag_player", end_angle, last_angle, 0.2, self.relative_view_angle_right, self.relative_view_angle_left, self.camera_view_angle_top, self.camera_view_angle_bottom );
}

fire_mortar_shell( start_pos, target_pos, initial_velocity, gravity, damage_range, damage_max, damage_min, delay_trail_time, debug_draw, time_to_target )
{
	mortar_shell = Spawn( "script_model", start_pos );
	aud_info = [mortar_shell, target_pos, start_pos, time_to_target];
	maps\_audio::aud_send_msg("aud_fire_mortar_shell", aud_info);
	mortar_shell.angles = self GetTagAngles( "tag_flash" );
	mortar_shell.velocity = initial_velocity;
	mortar_shell.target_pos = target_pos;
	mortar_shell thread update_mortar( gravity, damage_range, damage_max, damage_min, delay_trail_time, debug_draw );
}

lerp_angle( start_angle, end_angle, total_lerp_time, lerp_time )
{
	new_angle = ( start_angle + ( AngleClamp180( end_angle - start_angle ) * ( (total_lerp_time - lerp_time) / total_lerp_time ) ) );
	return new_angle;
}

switch_player_link_with_lerp( lerp_from_rig, lerp_to_rig, rig_tag, start_player_angles, end_player_angles, lerp_time, right_arc, left_arc, top_arc, bottom_arc )
{
	start_angles = lerp_from_rig.angles;
	end_angles = lerp_to_rig.angles;
	
	level.player_lerper.origin = lerp_from_rig.origin;
	
	total_lerp_time = lerp_time;
	
	right_arc_limit = 0;
	left_arc_limit = 0;
	top_arc_limit = 0;
	bottom_arc_limit = 0;
	while ( lerp_time >= 0 )
	{
		angle_x = lerp_angle( start_angles[0], end_angles[0], total_lerp_time, lerp_time );
		angle_y = lerp_angle( start_angles[1], end_angles[1], total_lerp_time, lerp_time );
		angle_z = lerp_angle( start_angles[2], end_angles[2], total_lerp_time, lerp_time );
		
		level.player_lerper.angles = ( angle_x, angle_y, angle_z );
		player_lerper_tag_angles = level.player_lerper GetTagAngles( rig_tag );
		
		player_angle_x = lerp_angle( start_player_angles[0], end_player_angles[0], total_lerp_time, lerp_time );
		lerp_player_angles = ( player_angle_x, end_player_angles[1], end_player_angles[2] );
				
		pitch_arc = AngleClamp180( player_lerper_tag_angles[0] - lerp_player_angles[0] );
		yaw_arc = AngleClamp180( angle_y - lerp_player_angles[1] );
		if ( pitch_arc >= 0 )
		{
			top_arc_limit = pitch_arc;
			bottom_arc_limit = 0;
		}
		else
		{
			top_arc_limit = 0; 
			bottom_arc_limit = -1 * pitch_arc;
		}
		if ( yaw_arc >= 0 )
		{
			right_arc_limit = yaw_arc;
			left_arc_limit = 0;
		}
		else
		{
			left_arc_limit = -1 * yaw_arc;
			right_arc_limit = 0;
		}
		
		self PlayerLinkToDelta( level.player_lerper, rig_tag, 1 );
		self FreezeControls( true );
		self SetPlayerAngles( lerp_player_angles );
		self LerpViewAngleClamp( 0, 0, 0, right_arc_limit, left_arc_limit, top_arc_limit, bottom_arc_limit );
		
		lerp_time = lerp_time - 0.05;
		wait 0.05;
	}
	
	self PlayerLinkToDelta( lerp_to_rig, rig_tag, 1, right_arc, left_arc, top_arc, bottom_arc );
	self FreezeControls( true );
	self SetPlayerAngles( end_player_angles );
}

delayed_mortar_trail( delay_time )
{
	if ( IsDefined( delay_time ) && delay_time > 0 )
	{
		wait delay_time;
	}
	
	PlayFXOnTag( GetFX( "mortar_shell_trail" ), self, "TAG_FX" );
}

update_mortar( shell_gravity, damage_range, damage_max, damage_min, delay_trail_time, debug_draw )
{	
	// set up mortar
	self SetModel( "projectile_rpg7" );
	self thread delayed_mortar_trail( delay_trail_time );
	
	// aud - TBD SFX on Mortar Trail
	//"mortar_shell_trail"
	
	// doesn't support time scaling...
	gravity_vector = ( 0, 0, shell_gravity );
	hit_pos = undefined;
	hit_info = undefined;//has the complete trace dictionary
	physics_delay = 3;
	
	// aud - set default mortar projectile state
	aud_mortar_falling = false;	

	wait 0.05;
	while ( true )
	{
		old_pos = self.origin;
		self.origin = self.origin + self.velocity;
		
		// don't check collision the first couple of frames so it
		//   it doesn't collide with mortar tube
		if ( physics_delay < 0 )
		{
			// adjust shell orientation toward velocity, only after shell has left tube
			velocity_direction = VectorNormalize( self.velocity );
			self.angles = VectorToAngles( velocity_direction );
			
			// do physics check
			trace = BulletTrace( old_pos, self.origin, false, self );
			if ( trace[ "fraction" ] < 1 )
			{
				// hit something
				hit_pos = trace["position"];
				hit_info = trace;
				
				break;
			}
		}
		else
		{
			physics_delay = physics_delay - 1;
		}
		
		self.velocity = self.velocity + gravity_vector;

		// aud - mortar falling loop sound

		// aud - play looping sound for mortar incoming
		// TBD - self PlayLoopSound("weap_mortar60mm_incoming");
		
		// aud - Checks to see if the projectile has begun falling
		aud_going_down = (self.origin[2] < old_pos[2]);
		if (aud_going_down && !aud_mortar_falling)
		{
			// aud - TBD - Play Falling projectile sound.
			aud_send_msg("player_mortar_falling", self);
			aud_mortar_falling = true;
		}
		
		if ( IsDefined( debug_draw ) && debug_draw )
		{
			debug_draw_damage_radius( self.target_pos, damage_range, damage_max, damage_min );
		}
		
		wait 0.05;
	}
	
	if ( IsDefined( hit_pos ) )
	{
		mortar_hit( hit_pos, damage_range, damage_max, damage_min, hit_info );
	}
	
	self Delete();
}

mortar_hit( hit_pos, damage_range, damage_max, damage_min, hit_info )
{
	// damage
	radiusDamage( hit_pos, damage_range, damage_max, damage_min );
	PhysicsExplosionSphere( hit_pos, 200, 10, .2 );


	// play fx
	print (hit_info["surfacetype"]);
	switch(hit_info["surfacetype"])
	{
		
		case "mud":
		{
			PlayFx( getfx( "mortar_shell_impact_mud" ), hit_pos );
		}
		break;
		
		case "water":
		{
			PlayFx( getfx( "mortar_shell_impact_mud" ), hit_pos );
		}
		break;
			
		case "dirt":
		{
			PlayFx( getfx( "mortar_shell_hit_exp" ), hit_pos );
		}
		break;
			
		default:
		{
			PlayFx( getfx( "mortar_shell_hit_exp_debris" ), hit_pos );
		}
	}
	
	// rumble
	PlayRumbleOnPosition( "artillery_rumble", hit_pos );

	// aud - Play mortar hit Play SFX
	aud_send_msg("mortar_explosion", hit_pos);

	// exploders
	triggered_exploders = [];
						
	damage_range_sq = ( damage_range * 0.5 ) * ( damage_range * 0.5 );
						
	foreach ( exploder_group in level.createFXexploders )
	{
		foreach ( fx_ent in exploder_group )
		{
			if ( !IsDefined( fx_ent.v[ "exploder" ] ) )
			continue;
			
			exploder_distance = DistanceSquared( hit_pos, fx_ent.v[ "origin" ] );
			if ( exploder_distance < damage_range_sq )
		{
			if ( !IsDefined( triggered_exploders[ fx_ent.v[ "exploder" ] ] ) )
			{
				triggered_exploders[ fx_ent.v[ "exploder" ] ] = 1;
				
				if ( IsDefined( fx_ent.v[ "trigger" ] ) )
				{
					foreach ( exploder_trigger in fx_ent.v[ "trigger" ] )
					{
						exploder_trigger notify( "trigger" );
					}
				}
				else
				{
					exploder( fx_ent.v[ "exploder" ] );
				}
			}
		}
	}
}
}

fire_mortar_at( target_pos, time_to_target, initial_up_velocity, damage_range, damage_max, damage_min )
{
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		if ( !IsDefined( damage_range ) ) { damage_range = player_mortar.damage_range; }
		if ( !IsDefined( damage_max ) ) { damage_max = player_mortar.damage_max; }
		if ( !IsDefined( damage_min ) ) { damage_min = player_mortar.damage_min; }
		
		mortar_aim_start_pos = player_mortar GetTagOrigin( "tag_flash" );
		mortar_aim_target_pos = target_pos;
		iterations = time_to_target / 0.05;
		
		// figure out total time it would be in the air 
		height_difference = mortar_aim_target_pos[2] - mortar_aim_start_pos[2];
		shell_gravity = ( 2 * ( height_difference - ( initial_up_velocity * iterations ) ) ) / ( iterations * iterations );
		
		start_pos_2d = ( mortar_aim_start_pos[0], mortar_aim_start_pos[1], 0 );
		end_pos_2d = ( mortar_aim_target_pos[0], mortar_aim_target_pos[1], 0 );
		start_to_end_2d = end_pos_2d - start_pos_2d;
		velocity = start_to_end_2d / iterations;
		velocity = ( velocity[0], velocity[1], initial_up_velocity );

		// TODO: mortar_shell_flash has a trail with it?  trail already comes from projectile...
		//PlayFXOnTag( GetFX( "mortar_shell_flash" ), player_mortar, "tag_flash" );
		player_mortar fire_mortar_shell( mortar_aim_start_pos, mortar_aim_target_pos, velocity, shell_gravity, damage_range, damage_max, damage_min, 0, player_mortar.debug_draw, time_to_target );
	}
}

draw_circle( circle_center, circle_radius, color )
{
	forward_vector = ( 0, 1, 0 );
	forward_side_vector = ( 0.7, 0.7, 0 );
	side_vector = ( 1, 0, 0 );
	down_side_vector = ( 0.7, -0.7, 0 );
	
	forward_side_vector = VectorNormalize( forward_side_vector );
	down_side_vector = VectorNormalize( down_side_vector );
	
	circle_pos = [];
	circle_pos[0] = circle_center + ( forward_vector * circle_radius );
	circle_pos[1] = circle_center + ( forward_side_vector * circle_radius );
	circle_pos[2] = circle_center + ( side_vector * circle_radius );
	circle_pos[3] = circle_center + ( down_side_vector * circle_radius );
	circle_pos[4] = circle_center + ( forward_vector * circle_radius * -1 );
	circle_pos[5] = circle_center + ( forward_side_vector * circle_radius * -1 );
	circle_pos[6] = circle_center + ( side_vector * circle_radius * -1 );
	circle_pos[7] = circle_center + ( down_side_vector * circle_radius * -1 );	
	
	for ( i = 0; i < circle_pos.size - 1; i++ )
	{
		line( circle_pos[i], circle_pos[i+1], color );
	}
	
	line( circle_pos[ circle_pos.size - 1 ], circle_pos[0], color );
	
}

debug_draw_damage_radius( target_pos, damage_range, damage_max, damage_min )
{
	if ( damage_min < 100 )
	{
		draw_circle( target_pos, damage_range, ( 1, 1, 1 ) );
		
		if ( damage_max > 100 )
		{
			damage_length = damage_max - damage_min;
			kill_radius = ( ( ( damage_length ) - ( 100 - damage_min ) ) / ( damage_length ) ) * damage_range;
			draw_circle( target_pos, kill_radius, ( 1, 0, 0 ) );
		}
	}
	else if ( damage_min > 100 )
	{
		draw_circle( target_pos, damage_range, ( 1, 0, 0 ) );
	}
}

enable_dismount()
{
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		player_mortar.disable_dismount = undefined;
	}
}

disable_dismount()
{
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		player_mortar.disable_dismount = true;
	}
}

force_dismount()
{
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		if ( flag( "mortar_in_use" ) )
		{
			player_mortar.dismount_requested = true;
			player_mortar notify( "mortar_dismount_requested" );
		}
	}
}

enable_mortar()
{
	self setCursorHint( "HINT_NOICON" );
	// Press and hold ^3&&1^7 to use mortar.
	self setHintString( self.hint_string );
	self makeUsable();
	
	self thread watch_mortar_use();
}

disable_mortar()
{
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		if ( flag( "mortar_in_use" ) )
		{
			player_mortar.dismount_requested = true;
			player_mortar notify( "mortar_dismount_requested" );
			player_mortar waittill( "mortar_unequipped" );
		}
		
		AssertEx( !flag( "mortar_in_use" ), "Cannot disable when in use" );
		player_mortar notify( "mortar_disabled" );
		player_mortar makeUnusable();
	}
}

mortar_has_ammo()
{
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		if ( IsDefined( player_mortar.max_ammo ) )
		{
			return ( player_mortar.ammo > 0 );
		}
		
		return true;
	}
	
	return false;
}

decrement_mortar_ammo()
{
	player_mortar = GetEnt( "player_mortar", "targetname" );
	if ( IsDefined( player_mortar ) )
	{
		if ( IsDefined( player_mortar.max_ammo ) )
		{
			player_mortar.ammo = player_mortar.ammo - 1;
			if ( player_mortar.ammo <= 0 )
			{
				player_mortar.ammo = 0;
				thread disable_mortar();
			}
		}
	}
}
