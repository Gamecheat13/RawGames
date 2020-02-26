/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 3/6/2012
 * Time: 9:36 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

// External References
#include common_scripts\utility;
#include maps\_anim;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\_utility;

// Internal References
#include maps\blackout_util;

#define BLACKOUT_SHIELD_STRAFING		(false)
#define BLACKOUT_SHIELD_TURNING			(true)
#define BLACKOUT_SHIELD_FIXED_PATH		(true)
#define BLACKOUT_SHIELD_MAX_TURN		(40)

get_align_ent()
{
	Assert( isdefined( level.m_shield.player_rig ) );
	
	if ( !isdefined( level.m_shield.align ) )
	{
		level.m_shield.align = Spawn( "script_model", level.m_shield.player_rig.origin );
		level.m_shield.align.angles = level.m_shield.player_rig.angles;
	}
	
	return level.m_shield.align;
}

// Refreshes the "raised" or "lowered" state of the meatshield gun animation.
//
shield_raise_or_lower_gun()
{
	state = level.meatshield_state;
	level.meatshield_state = "nil";
	if ( state == "standing" )
	{
		shield_anim_stand();
	} else {
		shield_anim_move();
	}
}

shield_anim_stand()
{
	if ( level.meatshield_state == "standing" )
	{
		return;
	}
	
	// Animate Player & victim
	if ( shield_is_aiming() )
	{
		level.m_shield.player_rig thread anim_loop( level.m_shield.player_rig, "mason_stand_loop_aim" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.victim, "victim_stand_loop_aim" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.weapon, "gun_stand_loop_aim" );
	} else {
		level.m_shield.player_rig thread anim_loop( level.m_shield.player_rig, "mason_stand_loop" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.victim, "victim_stand_loop" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.weapon, "gun_stand_loop" );
	}
	
	level.meatshield_state = "standing";
}

shield_anim_move()
{
	if ( level.meatshield_state == "moving" )
	{
		return;
	}
	
	// Animate Player & victim
	if ( shield_is_aiming() )
	{
		level.m_shield.player_rig thread anim_loop( level.m_shield.player_rig, "mason_move_loop_aim" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.victim, "victim_move_loop_aim" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.weapon, "gun_move_loop_aim" );
	} else {
		level.m_shield.player_rig thread anim_loop( level.m_shield.player_rig, "mason_move_loop" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.victim, "victim_move_loop" );
		level.m_shield.player_rig thread anim_loop( level.m_shield.weapon, "gun_move_loop" );
	}
	
	level.meatshield_state = "moving";
}

shield_aim( time_s )
{
	was_active = shield_is_aiming();
	
	level.m_shield_aim_timer += time_s;
	
	if ( !was_active )
	{
		shield_raise_or_lower_gun();
	}
}

shield_is_aiming()
{
	return level.m_shield_aim_timer > 0.0;
}

shield_run_aim_aim_timer()
{
	level endon( "meat_shield_done" );
	level.m_shield_aim_timer = 0.0;
	while ( true )
	{
		if ( level.m_shield_aim_timer > 0.0 )
		{
			level.m_shield_aim_timer -= 0.05;
			if ( level.m_shield_aim_timer <= 0 )
			{
				shield_raise_or_lower_gun();
			}
		}
		wait 0.05;
	}
}

shield_add_enemy( ai_enemy )
{
	if ( !isdefined( level.m_shield.enemies ) )
	{
		level.m_shield.enemies = [];
	}
	
	ArrayInsert( level.m_shield.enemies, ai_enemy, 0 );
}

shield_run( e_victim, str_volume, str_scene_name )
{
	level thread run_scene( str_scene_name );
	level thread shield_run_aim_aim_timer();
	
	level.m_shield = SpawnStruct();
	
	wait( 0.1 );

	// Grab the player body
	a_rigs = getentarray( "player_body", "targetname" );
	m_player_rig = a_rigs[0];
	end_pos = GetStruct( "meat_shield_end_struct", "targetname" );
	
	max_turn_dot = Cos(BLACKOUT_SHIELD_MAX_TURN);
	turning_center_vec = AnglesToForward( end_pos.angles );

	level.m_shield.player_rig = m_player_rig;
	level.m_shield.victim = e_victim;
	
	level.m_shield.weapon = GetEnt( "shield_gun", "targetname" );
	
	scene_wait( str_scene_name );
	
	flag_set( "meat_shield_start" );

	// Thread the player meatshield controls
	level.m_shield.strafe = 0.0;
	level.m_shield.fwd = 0.0;
	level.m_shield.turn = 0.0;
	level thread meatshield_input( 1.2, 2.0 );
	
	e_victim Teleport( level.m_shield.player_rig.origin, level.m_shield.player_rig.angles );
	level.m_shield.weapon.origin = level.m_shield.player_rig.origin;
	
	// Start in the standing pose.
	level.meatshield_state = "nil";
	shield_anim_stand();
	
	wait_network_frame();
	
	// Link victim to player
	link_offset = ( 0, 0, 0 );
	e_victim linkto( level.m_shield.player_rig, "tag_origin", link_offset );
	level.m_shield.weapon LinkTo( level.m_shield.player_rig, "tag_origin", link_offset );
	
	align_ent = get_align_ent();
	level.m_shield.player_rig LinkTo( align_ent );

	level.player HideViewModel();
	level.player DisableWeapons();
	
	// Link Player to the player rig.
	level.player PlayerLinkToDelta( level.m_shield.player_rig, "tag_player", 1, 0, 0, 30, 0, false );
	
	// get valid spaces
	valid_spaces = GetEntArray( str_volume, "targetname" );

	const shield_debug = false;
	while( !flag( "meat_shield_done" ) )
	{
		// see if where we're going is inside the designated allowable space.
		invalid_space_fwd = false;
		invalid_space_strafe = false;
		
		/#
		if ( shield_debug )
		{
			pos_player = align_ent.origin;
			fvec_player = anglestoforward( align_ent.angles );
			
			pos_victim = e_victim GetTagOrigin( "tag_origin" );
			fvec_victim = anglestoforward( e_victim GetTagAngles( "tag_origin" ) );
			
			draw_arrow_time( pos_player, pos_player + (fvec_player * 64), (0, 1, 0), 0.1 );
			draw_arrow_time( pos_victim, pos_victim + (fvec_victim * 64), (1, 0, 0), 0.1 );
		}
		#/
		
		//*************************************
		// Check input for left/right movement
		//*************************************
		
		// Rotate the player rig according to rotation values.
		if ( BLACKOUT_SHIELD_TURNING && level.m_shield.turn != 0.0 )
		{
			new_vec = AnglesToForward( (0, align_ent.angles[1] + level.m_shield.turn, 0) );
			new_vec_dot = VectorDot( new_vec, turning_center_vec );
			if ( new_vec_dot > max_turn_dot )
			{
				align_ent RotateYaw( level.m_shield.turn, 0.05 );
			}
		}

		if( level.m_shield.strafe != 0.0 || level.m_shield.fwd != 0.0 )
		{
			rvec = AnglesToRight( level.player.angles );
			fvec = undefined;
			
			if ( BLACKOUT_SHIELD_FIXED_PATH )
			{
				fvec = VectorNormalize( end_pos.origin - level.player.origin );
			} else {
				fvec = AnglesToForward( level.player.angles );
			}
			
			if ( BLACKOUT_SHIELD_FIXED_PATH )
			{
				// within a certain distance of the goal, stop moving forward.
				dist_sq_to_end = Distance2DSquared( align_ent.origin, end_pos.origin );
				if ( dist_sq_to_end < 16 * 16 )
				{
					shield_anim_move();
					flag_set( "meat_shield_done" );
					
					// move them to where the fandango ends.
					end_pos = GetStruct( "meat_shield_end_struct", "targetname" );
					align_node = get_align_ent();
					align_node MoveTo( end_pos.origin, 3.0 );
					align_node RotateTo( end_pos.angles, 3.0 );
					wait 3.2;
					
					shield_anim_stand();
					invalid_space_fwd = true;
				}
			}
			// if valid spaces are provided, check those before moving the player.
			else if ( valid_spaces.size > 0 ) {
				
				// check the forward motion, projecting forward a tad, so you don't get stuck up against the far wall.
				invalid_space_fwd = true;
				for ( i = 0; i < valid_spaces.size; i++ )
				{
					if ( is_point_inside_volume( align_ent.origin + ( fvec * (level.m_shield.fwd + 32 ) ), valid_spaces[i] ) )
					{
						invalid_space_fwd = false;
						break;
					}
				}
				
				// check the sideways motion.
				invalid_space_strafe = true;
				for ( i = 0; i < valid_spaces.size; i++ )
				{
					if ( is_point_inside_volume( align_ent.origin + ( rvec * level.m_shield.strafe ), valid_spaces[i] ) )
					{
						invalid_space_strafe = false;
						break;
					}
				}
			}
			
			v_newpos = align_ent.origin;

			// add the forward motion
			if ( !invalid_space_fwd )
			{
				v_newpos = v_newpos + (level.m_shield.fwd * fvec);
			}
			
			// add the lateral motion.
			if ( BLACKOUT_SHIELD_STRAFING && !invalid_space_strafe )
			{
				v_newpos = v_newpos + (level.m_shield.strafe * rvec);
			}
			
			// move the player rig.
			if ( !invalid_space_fwd || !invalid_space_strafe )
			{
				align_ent MoveTo( v_newpos, 0.05 );
			}
		}
		
		if ( level.m_shield.fwd == 0 || invalid_space_fwd )
		{
			shield_anim_stand();
		} else {
			shield_anim_move();
		}

		wait( 0.01 );
	}
}

shield_end()
{	
	// unlink the victim and the weapon.
	level.m_shield.victim Unlink();
	level.m_shield.weapon Unlink();
	level.m_shield.player_rig Unlink();
	
	if ( isdefined( level.m_shield.align ) )
	{
		level.m_shield.align Delete();
	}
	
	// clear all the variables.
	level.m_shield = undefined;
}

meatshield_process_proximity_speed_scalar()
{	
	while ( !flag( "meat_shield_done" ) )
	{
		if ( isdefined( level.m_shield.enemies ) )
		{
			const min_dist = 128;
			dist_closest = min_dist;
			foreach ( ai in level.m_shield.enemies )
			{
				dist = Distance2D( level.m_shield.player_rig.origin, ai.origin );
				if ( dist < dist_closest )
					dist_closest = dist;
			}
			
			level.m_shield.proximity_speed_scalar = dist_closest / min_dist;
		}
		
		wait 0.5;
	}
}

meatshield_input( move_scale, turn_scale )
{
	// Adjusts speed according to distance from your nearest enemy.
	level.m_shield.proximity_speed_scalar = 1.0;
	level thread meatshield_process_proximity_speed_scalar();
	
	while( !flag( "meat_shield_done" ) )
	{
		v_lstick = level.player GetNormalizedMovement();	// left stick
		v_rstick = level.player GetNormalizedCameraMovement();	// right stick.

		left_right = v_lstick[1];
		fwd_back = v_lstick[0];
		
		// floor the dead zone.
		const dead_zone = 0.02;
		if( (left_right < dead_zone) && (left_right > -dead_zone) )
		{
			left_right = 0.0;
		}
		
		if( (fwd_back < dead_zone) )
		{
			fwd_back = 0.0;
		}

		// can move forward, left, and right.
		level.m_shield.strafe = left_right * move_scale;
		level.m_shield.fwd = fwd_back * move_scale * level.m_shield.proximity_speed_scalar;
		
		turn_val = v_rstick[1];
		if ( ( turn_val < dead_zone ) && ( turn_val > -dead_zone ) )
		{
			turn_val = 0.0;
		}
		
		level.m_shield.turn = -turn_val * turn_scale;

		// wait one frame
		wait_network_frame();
	}
}
