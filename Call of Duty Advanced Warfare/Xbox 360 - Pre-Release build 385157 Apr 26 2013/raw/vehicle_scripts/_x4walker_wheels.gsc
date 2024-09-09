#include maps\_vehicle;
#include maps\_vehicle_shg;
#include maps\_anim;
#include maps\_utility;
#include maps\_shg_utility;
#include soundscripts\_snd;

#include common_scripts\utility;

#using_animtree( "vehicles" );
main( model, type, classname )
{
	PreCacheModel( "vehicle_vm_x4walker_wheels" );
	PreCacheModel( "projectile_rpg7" );
	PreCacheShader( "hud_exo_poly_cool" );
	PreCacheShader( "hud_exo_circle_hot" );
	PreCacheItem( "mobile_turret_missile" );
		
	set_console_status();
	
	build_template( "x4walker_wheels", model, type, classname );
	build_localinit( ::local_init );
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_mainturret();
	build_shoot_shock( "mobile_turret_shoot" );
	build_aianims( ::set_ai_anims );
	build_drive( %x4walker_wheels_drive_idle, %x4walker_wheels_drive_idle, 3.36 );
	build_treadfx();
	build_walker_death( classname );
	
	register_vehicle_anims( classname );
	register_player_anims();
	register_fx();
}

build_walker_death( classname )
{
	//walker death fx/////
	level._effect[ "walkerexplode" ]				= LoadFX( "vfx/explosion/vehicle_x4walker_explosion" );

	build_deathmodel( "vehicle_x4walker_wheels", "vehicle_x4walker_wheels_dstrypv" );
	
	//	build_deathfx( effect, 									tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "vfx/explosion/vehicle_x4walker_explosion", "TAG_DEATH_FX" );
	
	build_deathquake( 1, 1.6, 625 );

	//"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer>, <delay> )"
	build_radiusdamage( ( 0, 0, 32 ), 300, 200, 0, false );
	
}

register_vehicle_anims( classname )
{
	add_vehicle_anim( classname, "idle", %x4walker_wheels_idle );
	add_vehicle_anim( classname, "cockpit_idle", %x4walker_wheels_cockpit_idle );
}

register_fx()
{
	level._effect[ "exo_rocket_trail" ] = LoadFX( "fx/test/test_smoke_geotrail_exo_rocket" );
	level._effect[ "exo_rocket_explosion" ] = LoadFX( "fx/explosions/rpg_wall_impact" );
	level._effect[ "x4walker_wheels_rpg_fv" ] = LoadFX( "vfx/muzzleflash/x4walker_wheels_rpg_fv" );
}

local_init()
{
	self UseAnimTree( #animtree );
	
	//self thread make_mobile_turret_usable();
	self thread vehicle_scripts\_x4walker_wheels_aud::snd_init_x4_walker_wheels();
	self thread monitor_vehicle_mount();
	self thread animation_think();
	self thread monitor_wheel_movements();
	self thread monitor_walker_death_stop_sounds();
	
	waittillframeend;
	
	// turn off shellshock by default
	self notify( "stop_vehicle_shoot_shock" );
}

#using_animtree( "generic_human" );
set_ai_anims()
{
	positions = [];
	
	positions[0] = SpawnStruct();
	positions[0].sittag = "tag_guy";
	positions[0].idle = %x4walker_wheels_idle_npc;
	//positions[0].vehicle_getoutanim_clear = false;
	//positions[0].getin_idle_func = ::guy_set_animscripts;
	
	return positions;
}

#using_animtree( "player" );
register_player_anims()
{
	level.scr_anim[ "_vehicle_player_rig" ][ "enter_left" ] = %x4walker_wheels_cockpit_in_l_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "enter_right" ] = %x4walker_wheels_cockpit_in_r_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "enter_back" ] = %x4walker_wheels_cockpit_in_b_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "exit_left" ] = %x4walker_wheels_cockpit_out_l_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "exit_right" ] = %x4walker_wheels_cockpit_out_r_vm;
	level.scr_anim[ "_vehicle_player_rig" ][ "exit_back" ] = %x4walker_wheels_cockpit_out_b_vm;
	
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_cockpit_model, "enter_left" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_cockpit_model, "enter_right" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_cockpit_model, "enter_back" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_world_model, "exit_left" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_world_model, "exit_right" );
	addNotetrack_customFunction( "_vehicle_player_rig", "cockpit_swap", ::swap_world_model, "exit_back" );
}

make_mobile_turret_usable()
{
	self endon( "death" );
	
	// enable dof in vehicle while in vehicle
	self thread handle_vehicle_dof();
	
	// spawn usable model and place around vehicle
	// left, right, back
	self.enter_use_tags = [];
	for ( i = 0; i < 3; i++ )
	{
		use_tag = Spawn( "script_model", (0,0,0) );
		use_tag SetModel( "tag_origin" );
		use_tag Hide();
		self.enter_use_tags[i] = use_tag;
	}
	
	tag_body_pos = self GetTagOrigin( "tag_body" );
	tag_wheel_front_left_pos = self GetTagOrigin( "tag_wheel_front_left" );
	tag_wheel_front_right_pos = self GetTagOrigin( "tag_wheel_front_right" );
	tag_wheel_back_left_pos = self GetTagOrigin( "tag_wheel_back_left" );
	tag_wheel_back_right_pos = self GetTagOrigin( "tag_wheel_back_right" );
	
	// left
	self.enter_use_tags[0].origin = ( ( tag_wheel_front_left_pos[0] + tag_wheel_back_left_pos[0] ) * 0.5, ( tag_wheel_front_left_pos[1] + tag_wheel_back_left_pos[1] ) * 0.5, tag_body_pos[2] );
	// right
	self.enter_use_tags[1].origin = ( ( tag_wheel_front_right_pos[0] + tag_wheel_back_right_pos[0] ) * 0.5, ( tag_wheel_front_right_pos[1] + tag_wheel_back_right_pos[1] ) * 0.5, tag_body_pos[2] );
	// back
	self.enter_use_tags[2].origin = ( ( tag_wheel_back_left_pos[0] + tag_wheel_back_right_pos[0] ) * 0.5, ( tag_wheel_back_left_pos[1] + tag_wheel_back_right_pos[1] ) * 0.5, tag_body_pos[2] );
	
	foreach ( use_tag in self.enter_use_tags )
	{
		use_tag LinkTo( self );
		use_tag SetHintString( "Press ^3 &&1 ^7to Enter the Mobile Turret." );
		use_tag MakeUsable();
	}
	
	while ( true )
	{
		self MakeUnusable();
		wait_for_any_trigger_hit( self.enter_use_tags );
		
		foreach ( use_tag in self.enter_use_tags )
		{
			use_tag MakeUnusable();
		}
		
		level.player setup_player_for_scene();
		player_rig = spawn_player_rig();
		player_rig Hide();
		
		left_distance = DistanceSquared( level.player.origin, self.enter_use_tags[0].origin );
		right_distance = DistanceSquared( level.player.origin, self.enter_use_tags[1].origin );
		back_distance = DistanceSquared( level.player.origin, self.enter_use_tags[2].origin );
		
		closest_distance = left_distance;
		enter_anim = "enter_left";
		exit_anim = "exit_left";
		if ( right_distance < closest_distance )
		{
			closest_distance = right_distance;
			enter_anim = "enter_right";
			exit_anim = "exit_right";
		}
		
		if ( back_distance < closest_distance )
		{
			closest_distance = back_distance;
			enter_anim = "enter_back";
			exit_anim = "exit_back";
		}

		self anim_first_frame_solo( player_rig, enter_anim, "tag_body" );
		level.player PlayerLinkToBlend( player_rig, "tag_player", 0.2, 0.1, 0.1 );
		wait 0.2;
		
		player_rig Show();
		player_rig.vehicle_to_swap = self;
		self anim_single_solo( player_rig, enter_anim, "tag_body" );
		
		level.player Unlink();
		player_rig Delete();
		level.player setup_player_for_gameplay();
		level.player player_mount_vehicle( self );
		self wait_for_exit_message();
		
		// can be forced out by another script
		if ( IsDefined( level.player.drivingVehicle ) )
		{
			// dismount vehicle
			level.player setup_player_for_scene();
			player_rig = spawn_player_rig();
			player_rig Hide();
			self anim_first_frame_solo( player_rig, exit_anim, "tag_body" );
			level.player PlayerLinkToBlend( player_rig, "tag_player", 0.2, 0.1, 0.1 );
			wait 0.2;
			player_rig Show();
			player_rig.vehicle_to_swap = self;
			
			level.player player_dismount_vehicle();
			level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
			
			self anim_single_solo( player_rig, exit_anim, "tag_body" );
			level.player Unlink();
			player_rig Delete();
			level.player setup_player_for_gameplay();
			
			foreach ( use_tag in self.enter_use_tags )
			{
				use_tag MakeUsable();
			}
		}
	}
}

handle_vehicle_dof()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "enter_vehicle_dof" );
		
		start = level.dofDefault;
		dof_enter_vehicle = [];
		dof_enter_vehicle[ "nearStart" ] = 10.0;
		dof_enter_vehicle[ "nearEnd" ]	= 70;
		dof_enter_vehicle[ "nearBlur" ] = 4;
		dof_enter_vehicle[ "farStart" ] = 9500;
		dof_enter_vehicle[ "farEnd" ] = 10000;
		dof_enter_vehicle[ "farBlur" ] = 0;
		
		blend_dof( start, dof_enter_vehicle, .25 );
		
		self waittill( "exit_vehicle_dof" );
		
		blend_dof( dof_enter_vehicle, start, .25 );
	}
}

wait_for_exit_message()
{
	self endon( "vehicle_dismount" );
	
	exit_message = "exit_message";
	NotifyOnCommand( exit_message, "+activate" );
	NotifyOnCommand( exit_message, "+usereload" );
	
	level.player waittill( exit_message );
}

wait_for_any_trigger_hit( trigger_array )
{
	if ( trigger_array.size > 1 )
	{
		for ( i = 1; i < trigger_array.size; i++ )
		{
			trigger_array[i] endon( "trigger" );
		}
	}
	
	if ( trigger_array.size > 0 )
	{
		trigger_array[0] waittill( "trigger" );
	}
}

make_mobile_turret_unusable()
{
	self MakeUnusable();
	
	if ( IsDefined( self.enter_use_tags ) )
	{
		foreach ( use_tag in self.enter_use_tags )
		{
			use_tag MakeUnusable();
		}
	}
}

monitor_vehicle_mount()
{
	self endon( "death" );
	
	self SetAnim( get_vehicle_anim( "idle" ) );
	
	self thread calculate_base_target_offset();
	
	while ( true )
	{
		self wait_for_vehicle_mount();
		self thread turret_think();
		
		if ( !IsDefined( self.player_driver ) )
		{
			self thread handle_vehicle_ai();
			self thread rocket_ai();
			self make_mobile_turret_unusable();
			self thread vehicle_scripts\_x4walker_wheels_aud::snd_start_x4_walker_wheels("npc");
		}
		else
		{
			self thread rocket_think();
		}
		
		self wait_for_vehicle_dismount();
		
		self reset_turret();
	}
}

monitor_walker_death_stop_sounds()
{
	self waittill ( "death" );
	
	fade_out_time = 1;
	self snd_message("snd_stop_vehicle", fade_out_time);
}

animation_think()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "play_anim", anim_mode );
		self clear_anims();
		self SetAnim( get_vehicle_anim( anim_mode ), 1.0, 0.2, 1.0 );
	}
}

#using_animtree( "vehicles" );
clear_anims()
{
	self ClearAnim( %walker_wheels, 0.2 );
}

turret_think()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	
	// enable shoot shock only when player is on turret
	if ( IsDefined( self.player_driver ) )
	{
	//	self.shellshock_time = 0.1;
	//	self thread maps\_vehicle_code::vehicle_shoot_shock();
		level.player ShellShock( "mobile_turret_shoot", 0.1 ); 
	}
	
	while( 1 )
	{
		self waittill( "turret_fire" );
		self FireWeapon();
	}
}

reset_turret()
{
	// stop shoot shock
	self notify( "stop_vehicle_shoot_shock" );
	
	// reset the turret so the enter/exit anims line up
	if ( IsDefined( self.base_target_offset_angles ) && IsDefined( self.base_target_offset_length ) )
	{
		forward = AnglesToForward( self.angles );
		target_position = self GetTagOrigin( "tag_body" );
		target_position = target_position + ( forward * 100 );
		
		target_offset = AnglesToForward( self.base_target_offset_angles + self GetTagAngles( "tag_body" ) );
		target_offset = target_offset * self.base_target_offset_length;
		self SetTurretTargetVec( target_position + target_offset );
	}
}

rocket_think()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	
	Assert( IsDefined( self.player_driver ) );
	
	self thread monitor_missile_input();
	
	while ( true )
	{
		self waittill( "target_missile_system" );
		
		self thread rocket_target_think();
		
		self waittill( "fire_missile_system" );
		
		self thread fire_rockets();
		
		// delay until you can fire again
		wait 2;
	}
}

rocket_target_think()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	self endon( "fire_missile_system" );
	
	Assert( IsDefined( self.player_driver ) );
	
	if ( !IsDefined( self.rocket_targets ) )
	{
		self.rocket_targets = [];
	}
	
	max_targets = 4;
	
	while ( true )
	{
		if ( self.rocket_targets.size < max_targets )
		{		
			look_forward = AnglesToForward( self.player_driver GetPlayerAngles() );
			look_forward = VectorNormalize( look_forward );
			eye_pos = self.player_driver GetEye();
			
			trace = BulletTrace( eye_pos, eye_pos + ( look_forward * 2048 ), true, self );
			hit_entity = trace[ "entity" ];
			if ( IsDefined( hit_entity ) && IsAI( hit_entity ) && IsAlive( hit_entity ) && !maps\_vehicle_code::attacker_isonmyteam( hit_entity ) && !maps\_vehicle_code::attacker_troop_isonmyteam( hit_entity ) )
			{
				if ( !IsDefined( hit_entity.target_marked ) || !hit_entity.target_marked )
				{
					hit_entity.target_marked = true;
					Target_Set( hit_entity, ( 0, 0, 20 ) );
					Target_SetShader( hit_entity, "hud_exo_poly_cool" );
					
					self thread remove_target( hit_entity );
					
					self.rocket_targets[ self.rocket_targets.size ] = hit_entity;
				}
			}
		}
		
		wait 0.05;
	}
}

remove_target( target_entity )
{
	self wait_to_remove_target( target_entity );
	
	if ( IsDefined( target_entity ) )
	{
		target_entity.target_marked = undefined;
		Target_Remove( target_entity );
	}
	
	// rebuild target array and remove any undefined entities and the target to remove
	if ( IsDefined( self ) && IsDefined( self.rocket_targets ) )
	{
		temp_targets = [];
		foreach ( rocket_target in self.rocket_targets )
		{
			if ( IsDefined( rocket_target ) )
			{
				if ( IsDefined( target_entity ) && rocket_target == target_entity )
					continue;
				
				temp_targets[ temp_targets.size ] = rocket_target;
			}
		}
		
		self.rocket_targets = temp_targets;
	}
}

wait_to_remove_target( target_entity )
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	target_entity endon( "death" );
	
	target_entity waittill( "remove_target" );
}

monitor_missile_input()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	
	Assert( IsDefined( self.player_driver ) );
	
	missiles_active = false;
	while ( true )
	{
		frag_pressed = self.player_driver FragButtonPressed();
		if ( frag_pressed && !missiles_active )
		{
			missiles_active = true;
			self notify( "target_missile_system" );
		}
		else if ( !frag_pressed && missiles_active )
		{
			missiles_active = false;
			self notify( "fire_missile_system" );
		}
		
		wait 0.05;
	}
}

fire_rockets()
{
	missile_index = 0;
	foreach ( rocket_target in self.rocket_targets )
	{
		if ( !IsDefined( rocket_target ) )
			continue;
		
		self.player_driver PlayRumbleOnEntity( "heavygun_fire" );
		Target_SetShader( rocket_target, "hud_exo_circle_hot" );
		self thread fire_rocket_at( rocket_target, missile_index );
		missile_index++;
		wait 0.35;
	}
}

fire_rocket_at( rocket_target, missile_index )
{	
	if ( !IsDefined( self.launcher_index ) )
	{
		self.launcher_index = 0;
	}
	else
	{
		self.launcher_index++;
		self.launcher_index = self.launcher_index % 4;
	}
	
	end = rocket_target.origin;
	
	launcher_tag = "TAG_LAUNCHER" + ( self.launcher_index + 1 );
	start_pos = self GetTagOrigin( launcher_tag );
	launcher_angles = self GetTagAngles( launcher_tag );
	straight_pos = start_pos + ( AnglesToForward( launcher_angles ) * 512 );
	
	//play muzzleflash fx
	playfxontag(getfx("x4walker_wheels_rpg_fv"), self, launcher_tag);
	
	missile = MagicBullet( "mobile_turret_missile", start_pos, straight_pos );
	missile Missile_SetTargetEnt( rocket_target );
	missile Missile_SetFlightModeDirect();
	missile snd_message( "mobile_turret_missile" );
}

handle_vehicle_ai()
{
	if ( IsDefined( self.ai_func_override ) )
	{
		self thread [[ self.ai_func_override ]]();
	}
	else
	{
		// AI driver
		self thread vehicle_scripts\_vehicle_turret_ai::vehicle_turret_settings_target( 10 );
		self thread vehicle_scripts\_vehicle_turret_ai::vehicle_turret_settings_shoot( 2, 4, 0.1, 0.3, true );
		self thread vehicle_scripts\_vehicle_turret_ai::vehicle_turret_default_ai();
	}
}

rocket_ai()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	
	player_safe_dist = 128;
	
	wait RandomIntRange( 1, 10 );
	
	while ( true )
	{
		wait RandomFloatRange( 12, 20 );
		
		targets_found = false;
		while ( !targets_found )
		{
			rocket_targets = [];
			
			enemies = GetAIArray( "axis" );
			foreach ( ai_enemy in enemies )
			{
				to_enemy = ai_enemy.origin - self.origin;
				enemy_distance = Length( to_enemy );
				if ( enemy_distance < 1024 )
				{
					continue;
				}
	
				to_enemy = VectorNormalize( to_enemy );
				flash_angles = self GetTagAngles( "tag_flash" );
				flash_forward = AnglesToForward( flash_angles );
				
				enemy_dot = VectorDot( to_enemy, flash_forward );
				if ( enemy_dot < 0.5 )
				{
					continue;
				}
				
				flash_origin = self GetTagOrigin( "tag_flash" );
				enemy_sight_pos = ai_enemy.origin + ( 0, 0, 32 );
				can_sight = SightTracePassed( flash_origin, enemy_sight_pos, false, self );
				if ( !can_sight )
				{
					continue;
				}

				//make sure player isn't in the line of fire
				player_line_of_fire_vector = VectorFromLineToPoint( flash_origin, enemy_sight_pos, level.player.origin + (0, 0, 32) );
				if( length( player_line_of_fire_vector ) < player_safe_dist )
				{
					continue;
				}
				
				rocket_targets[ rocket_targets.size ] = ai_enemy;
			}
			
			picked_targets = [];
			if ( rocket_targets.size > 0 )
			{
				random_index = RandomInt( rocket_targets.size );
				
				for ( i = 0; i < rocket_targets.size; i++ )
				{
					actual_index = ( random_index + i ) % rocket_targets.size;
					rocket_target = rocket_targets[ actual_index ];
					picked_targets[ picked_targets.size ] = rocket_target;
					if ( picked_targets.size > 1 )
					{
						picked_ratio = picked_targets.size / 4;
						if ( picked_ratio > RandomFloatRange( 0, 1 ) )
						{
							break;
						}
					}
				}
			}
			
			missile_index = 0;
			foreach ( missile_target in picked_targets )
			{
				if ( !IsDefined( missile_target ) )
					continue;
				
				targets_found = true;
			
				self thread fire_rocket_at( missile_target, missile_index );
				missile_index++;
				wait 0.35;
			}
			
			// no targets found, wait a shorter amount of time
			if ( !targets_found )
			{
				wait 0.5;
			}
		}
	}
	
}

calculate_base_target_offset()
{
	// figure out target offset from base pose so we can reset the turret properly
	forward = AnglesToForward( self.angles );
	body = self GetTagOrigin( "tag_body" );
	target_position = body + ( forward * 100 );
	
	flash_origin = self GetTagOrigin( "tag_flash" );
	flash_forward = AnglesToForward( self GetTagAngles( "tag_flash" ) );
	flash_target = flash_origin + ( flash_forward * 100 );
	
	target_offset = flash_target - target_position;
	body_angles = self GetTagAngles( "tag_body" );
	self.base_target_offset_length = Length( target_offset );
	target_offset_angles = VectorToAngles( target_offset );
	self.base_target_offset_angles = target_offset_angles - body_angles;
}

swap_cockpit_model( ent )
{
	if ( IsDefined( ent ) && IsDefined( ent.vehicle_to_swap ) )
	{
		ent.vehicle_to_swap notify( "enter_vehicle_dof" );
		ent.vehicle_to_swap SetModel( "vehicle_vm_x4walker_wheels" );
		ent.vehicle_to_swap notify( "play_anim", "cockpit_idle" );
	}
}

swap_world_model( ent )
{
	if ( IsDefined( ent ) && IsDefined( ent.vehicle_to_swap ) )
	{
		ent.vehicle_to_swap notify( "exit_vehicle_dof" );
		ent.vehicle_to_swap SetModel( "vehicle_x4walker_wheels" );
		ent.vehicle_to_swap notify( "play_anim", "idle" );
	}
}

// monitor velocities of legs for use in audio
monitor_wheel_movements()
{
	self endon( "death" );
	
	wheel_tags = [ "tag_wheel_back_left", "tag_wheel_back_right", "tag_wheel_front_left", "tag_wheel_front_right" ];
	self.last_wheel_pos = [];
	self.current_wheel_pos = [];
	update_rate = 0.05;
	if (level.currentgen)
		update_rate = 0.5;
	
	while ( true )
	{
		foreach ( wheel_tag in wheel_tags )
		{
			self.current_wheel_pos[ wheel_tag ] = self GetTagOrigin( wheel_tag );
		}
		
		wait update_rate;
		foreach ( wheel_tag in wheel_tags )
		{
			self.last_wheel_pos[ wheel_tag ] = self.current_wheel_pos[ wheel_tag ];
		}
	}
}

get_wheel_velocity( wheel_tag )
{
	AssertEx( IsDefined( wheel_tag ), "wheel_tag parameter must be defined" );
	
	if ( IsDefined( self.current_wheel_pos[ wheel_tag ] ) && IsDefined( self.last_wheel_pos[ wheel_tag ] ) )
	{
		wheel_diff = self.current_wheel_pos[ wheel_tag ] - self.last_wheel_pos[ wheel_tag ];
		return wheel_diff * 20;
	}
	
	return (0,0,0);
}


/*QUAKED script_vehicle_x4walker_wheels (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_x4walker_wheels::main( "vehicle_x4walker_wheels", undefined, "script_vehicle_x4walker_wheels" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_x4walker_wheels


defaultmdl="vehicle_x4walker_wheels"
default:"vehicletype" "x4walker_wheels"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_x4walker_wheels_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_x4walker_wheels::main( "vehicle_x4walker_wheels", "x4walker_wheels_physics", "script_vehicle_x4walker_wheels_physics" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_x4walker_wheels


defaultmdl="vehicle_x4walker_wheels"
default:"vehicletype" "x4walker_wheels_physics"
default:"script_team" "allies"
*/
