
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\angola_2_util;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
//*****************************************************************************
// Mason Carrying Woods
//*****************************************************************************
//*****************************************************************************

mason_carry_woods( str_startup_scene )
{
	// Pickup
	if( IsDefined(str_startup_scene) )
	{
		run_scene( str_startup_scene );
	}

	// Use the script struct already in the level
	level.m_player_spot = Spawn( "script_model", level.player.origin );
	level.m_player_spot SetModel( "tag_origin" );
	level.m_player_spot.angles = level.player.angles;
					
	//Eckert - Setting up sounds for Mason carrying Woods
	level.m_player_spot thread carry_movement_sounds();

	level.default_mason_carry_crouch_speed = 155;
	level.mason_carry_crouch_speed = level.default_mason_carry_crouch_speed;
		
	// Mason is now carrying Woods
	flag_set( "js_mason_is_carrying_woods" );

	setup_mason_carry_woods();
}


//*****************************************************************************
//*****************************************************************************

carry_movement_sounds()
{
	wait .2;
	self thread carry_sound_watcher();
/*	
	if( !isdefined( level.woods_carry_is_moving ) )
	{
		wait 3;
	}
*/	
	while (1)
	{
		self waittill ( "sound_run" );
		self playsound ( "evt_anim_woods_carry_lp", .7 );
		self playsound ( "fly_gear_run_plr" );
		wait(randomfloatrange(.45, .65));
		
	}
}


//*****************************************************************************
//*****************************************************************************

set_carry_crouch_speed( speed )
{
	level.mason_carry_crouch_speed = speed;
}


//*****************************************************************************
//*****************************************************************************

carry_sound_watcher()
{
	while (1)
	{
		self waittill ( "sound_stop" );
		self stoploopsound ( 1 );
		wait( 0.5 );
	}
}


//*****************************************************************************
//*****************************************************************************

is_mason_stealth_crouched()
{
	return( level.woods_carry_is_crouched );
}


//*****************************************************************************
//*****************************************************************************

setup_mason_carry_woods()
{
	m_player_rig = spawn_anim_model( "player_body", level.player.origin );
	m_player_rig.angles = level.player.angles;
	level.player.m_player_rig = m_player_rig;

	//........

	link_player_and_woods_together();

	m_player_rig linkto( level.m_player_spot, "tag_origin" );

	m_player_rig.animname = "player_body";
	level.m_player_spot thread anim_loop( m_player_rig, "mason_carry_idle" );
	
	level.ai_woods.animname = "woods";
	m_player_rig thread anim_loop( level.ai_woods, "mason_carry_idle" );
	
	wait( 0.1 );

	// TEMP - Movement test
/*
	v_forward = AnglesToForward( level.m_player_spot.angles );
	while( 1 )
	{
		level.m_player_spot.origin = level.m_player_spot.origin + ( v_forward * 1.0 );
		wait( 0.01 );
	}
*/

	level thread mason_movement( m_player_rig );
}


//*****************************************************************************
//*****************************************************************************

link_player_and_woods_together()
{
	level.player PlayerLinkToDelta( level.player.m_player_rig, "tag_player", .5, 0, 10, 25, 0 );	// .5, 0, 0, 20, 0
	level.ai_woods linkto( level.player.m_player_rig, "tag_origin" );
}


//*****************************************************************************
//*****************************************************************************

mason_movement( m_player_rig )
{
	level.woods_carry_complete = false;
	level.woods_carry_height_offset = (0, 0, 16);
	level.woods_carry_delay_walk_frames = 0;
	level.woods_carry_is_moving = false;
	level.woods_carry_is_crouched = false;
	level.woods_carry_disable_movement = false;
	
	level thread mason_movement_rotation( m_player_rig );
	level thread mason_movement_translation( m_player_rig );

	level.player thread mason_carry_crouch_button();
	
	while ( !level.woods_carry_complete )
	{
		if( flag( "pause_woods_carry" ) )
		{
			wait (0.05 );
			continue;	
		}

		
		//****************************************
		//****************************************

		if( flag("woods_carry_cough") )
		{
			level.woods_carry_disable_movement = true;
			level.m_player_spot notify ( "sound_stop" );

	  		level.m_player_spot notify ( "stop_loop" );
			m_player_rig notify ( "stop_loop" );

			level.woods_carry_is_moving = true;

			level.m_player_spot thread anim_single( m_player_rig, "mason_carry_coughing" );
			m_player_rig anim_single( level.ai_woods, "mason_carry_coughing" );
		
			flag_clear( "woods_carry_cough" );

			level.woods_carry_delay_walk_frames = 2;
			level.woods_carry_disable_movement = false;
		}


		//**********************
		// Crouch button pressed
		//**********************

		else if( level.mason_carry_button_pressed )
		{
			level.woods_carry_is_crouched = true;

			level.woods_carry_disable_movement = true;

	  		level.m_player_spot notify ( "stop_loop" );
			m_player_rig notify ( "stop_loop" );
			wait( 0.01 );

			level.m_player_spot thread anim_single( m_player_rig, "mason_carry_crouch_in" );
			m_player_rig thread anim_single( level.ai_woods, "mason_carry_crouch_in" );

			level.m_player_spot thread anim_loop( m_player_rig, "mason_carry_crouch_idle" );
			m_player_rig thread anim_loop( level.ai_woods, "mason_carry_crouch_idle" );

			wait( 0.2 );
			level.woods_carry_disable_movement = false;

			level.woods_carry_is_moving = false;
			level.woods_carry_delay_walk_frames = 2;

			while( 1 )
			{
				wait( 0.01 );

				if( (level.mason_carry_button_pressed) || flag("woods_carry_cough") || (level.player ButtonPressed("BUTTON_A")) )
				{
					break;
				}
			}

			level.woods_carry_is_crouched = false;

			level.woods_carry_disable_movement = true;

			level.m_player_spot notify ( "stop_loop" );
			m_player_rig notify ( "stop_loop" );
			wait( 0.01 );

			level.m_player_spot thread anim_single( m_player_rig, "mason_carry_crouch_out" );
			m_player_rig thread anim_single( level.ai_woods, "mason_carry_crouch_out" );

			level.m_player_spot thread anim_loop( m_player_rig, "mason_carry_idle" );
			m_player_rig thread anim_loop( level.ai_woods, "mason_carry_idle" );

			wait( 0.2 );
			level.woods_carry_disable_movement = false;

			level.woods_carry_is_moving = false;
			level.woods_carry_delay_walk_frames = 2;
		}
         
        wait ( .05 );
	}
}


//*****************************************************************************
//*****************************************************************************

mason_movement_translation( m_player_rig )
{
	n_movement_crouch_speed = 35;	// 50
	v_up = (0, 0, 1);

	a_rig_and_woods = array( m_player_rig, level.ai_woods );

	while( !level.woods_carry_complete )
	{
		if( flag( "pause_woods_carry" ) )
		{
			wait (0.05 );
			continue;	
		}

		if( level.woods_carry_disable_movement == false )
		{
			if( level.woods_carry_is_crouched == false )
			{
				n_speed = level.mason_carry_crouch_speed;
			}
			else
			{
				n_speed = n_movement_crouch_speed;
			}

			a_normalized_movement = level.player GetNormalizedMovement();
	
			n_movement_strength = Length( a_normalized_movement ); 
        
			rig_angles = m_player_rig.angles;
			forward = AnglesToForward( rig_angles );
			right = AnglesToRight( rig_angles );
        
			speed_forward = n_speed * a_normalized_movement[0];
			speed_right = n_speed * a_normalized_movement[1];
			movement_vector = forward * speed_forward + right * speed_right;
		
			if( level.woods_carry_delay_walk_frames > 0 )
			{
				level.woods_carry_delay_walk_frames--;
				n_movement_strength = 0;
			}
		
			// Translation
			if( n_movement_strength > 0 )
			{
				v_start_pos = level.m_player_spot.origin;

				// Set movement anim
				if( level.woods_carry_is_crouched == false )
				{
					str_move_anim_name = "mason_carry_run";
					//plays carrying sounds.
					level.m_player_spot notify ( "sound_run" );
				}
				else
				{
					str_move_anim_name = "mason_carry_crouch_walk";
					//level.m_player_spot notify ( "sound_stop" );
				}
				
	     		if( !level.woods_carry_is_moving )
	      		{
	     			level.m_player_spot notify ( "sound_stop" );
		       		level.m_player_spot notify ( "stop_loop" );
			   		m_player_rig notify ( "stop_loop" );
					level.m_player_spot thread anim_loop( m_player_rig, str_move_anim_name );
					m_player_rig thread anim_loop( level.ai_woods, str_move_anim_name );
				}

			   	array_thread( a_rig_and_woods, ::woods_carry_set_rate, str_move_anim_name, n_movement_strength );
			
		        level.woods_carry_is_moving = true;
				level.m_player_spot notify ( "sound_run" );
        	
			    v_velocity = movement_vector;
				v_collision_velocity = movement_vector * 0.2;
			    v_projected_spot = level.m_player_spot.origin + v_collision_velocity;
				v_woods_projected_spot = level.ai_woods.origin + v_collision_velocity;
        	
				trace_start = level.m_player_spot.origin + level.woods_carry_height_offset;
				trace_end = v_projected_spot + level.woods_carry_height_offset;
        	
			    // thread draw_line_for_time( trace_start, trace_end, 1, 1, 1, 0.05 );
        	
			    // collision detection
				v_forward_trace = PlayerPhysicsTrace( trace_start, trace_end );
        	
		        // Player collided with an object, calculate slide
			    v_final_spot = undefined;
				if ( v_forward_trace != trace_end )
				{
					a_forward_trace = PhysicsTrace( trace_start, trace_end );
					
					if( a_forward_trace == trace_end )
					{
						v_movement = v_forward_trace - trace_start;

						// find the vector perpendicular to the movement vector
						v_movement_perp = VectorCross( VectorNormalize( v_movement ), v_up );
						v_movement_perp_inverse = v_movement_perp *-1;
						
						a_movement_perp_trace = PhysicsTrace( v_forward_trace, v_forward_trace + (v_movement_perp * speed_forward) );
						a_movement_perp_inverse_trace = PhysicsTrace( v_forward_trace, v_forward_trace + (v_movement_perp_inverse * speed_forward) );

						// We need the normal which is only calculated by bullettrace
						bt_movement_perp_trace = bulletTrace( v_forward_trace, v_forward_trace + (v_movement_perp * speed_forward), false, m_player_rig );
						bt_movement_perp_inverse_trace = bulletTrace( v_forward_trace, v_forward_trace + (v_movement_perp_inverse * speed_forward), false, m_player_rig );
							
						frac0 = calc_frac( v_forward_trace, v_forward_trace + (v_movement_perp * speed_forward), a_movement_perp_trace );
						frac1 = calc_frac( v_forward_trace, v_forward_trace + (v_movement_perp_inverse * speed_forward), a_movement_perp_inverse_trace );

						a_forward_trace = a_movement_perp_trace;
						use_frac = frac0;
						use_normal = bt_movement_perp_trace["normal"];
						if( (frac0 > frac1) && (frac0 != 0) && (frac1 != 0) )
						{
							use_frac = frac1;
							use_normal = bt_movement_perp_inverse_trace["normal"];
							a_forward_trace = a_movement_perp_inverse_trace;	
						}
					}
				
		        	// negates the movement into the wall
			    	v_collision_normal = use_normal;
					n_projection = 1 - use_frac;	// abs( VectorDot( VectorNormalize(v_velocity), v_collision_normal ) );
        			v_velocity += ( v_collision_normal * ( n_speed ));
        		
		        	// Find the vector parallel to the collision surface
			    	v_collision_parallel = VectorCross( VectorNormalize( v_collision_normal ), v_up );
					v_collision_to_player = VectorNormalize( v_forward_trace - level.player.origin );
        			n_parallel_dot = VectorDot( v_collision_parallel, v_collision_to_player );
        		
		        	if( n_parallel_dot < 0 )
			    	{
						v_collision_parallel *= -1;	
        			}
        		
	        		v_velocity += (v_collision_parallel * ( n_projection * abs(n_parallel_dot) ) );
		        }
        	
			    v_woods_spot = level.m_player_spot.origin + ( (VectorNormalize(right) * -1) * 8 );
    			v_final_spot = PlayerPhysicsTrace( level.m_player_spot.origin + level.woods_carry_height_offset, ( level.m_player_spot.origin + ( v_velocity * 0.05 ) ) + level.woods_carry_height_offset );
		    	v_final_woods_spot = v_woods_spot + ( VectorNormalize(v_velocity) * 16 ) + level.woods_carry_height_offset;
				v_final_woods_trace = PlayerPhysicsTrace( v_woods_spot + level.woods_carry_height_offset, v_final_woods_spot );

    		
		    	// if woods hit something but the player didn't, shorten the player's movement to the same length
				if( v_final_woods_spot != v_final_woods_trace )
    			{
	    			v_final_spot = level.m_player_spot.origin;
		    	}
    			
				//ground_trace = GetGroundPosition( v_final_spot + level.woods_carry_height_offset, 2 );

				v_start = v_final_spot + level.woods_carry_height_offset + (0,0,32);	// 64
				v_end = v_final_spot - (0,0,100);
				ground_trace = PhysicsTrace( v_start, v_end );

		        v_final_spot = ( v_final_spot[0], v_final_spot[1], ground_trace[2] );
    	
				level.m_player_spot.origin = v_final_spot;


				// Final check, if the player is now falling, stop it
				v_start = level.m_player_spot.origin + (0,0,32);
				v_end = level.m_player_spot.origin - (0,0,32);
				ground_trace = PhysicsTrace( v_start, v_end );
				if( ground_trace == v_end )
				{
					//IPrintLnBold( "Collision Problem" );
					level.m_player_spot.origin = v_start_pos;
				}
			}
			else
			{
				if ( level.woods_carry_is_moving )
				{
					// Set idle anim
					if( level.woods_carry_is_crouched == false )
					{
						str_anim_name = "mason_carry_idle";
					}
					else
					{
						str_anim_name = "mason_carry_crouch_idle";
					}
					level.m_player_spot notify ( "sound_stop" );
					level.m_player_spot notify( "stop_loop" );
					m_player_rig notify( "stop_loop" );
					level.m_player_spot thread anim_loop( m_player_rig, str_anim_name );
					m_player_rig thread anim_loop( level.ai_woods, str_anim_name );        	        		
				}
        	
				level.woods_carry_is_moving = false;
			}
		}

		wait ( .05 );
	}
}

calc_frac( v_start, v_end, v_midpoint )
{
	dist = distance( v_start, v_end );
	mag = distance( v_start, v_midpoint );

	if( (dist == 0) || (mag == 0) )
	{
		return( 0 );
	}

	frac = mag / dist;
	return( frac );
}


//*****************************************************************************
//*****************************************************************************

mason_movement_rotation( m_player_rig )
{
	v_rotate_speed = (0, 5, 0 );
	v_up = (0, 0, 1);

	while( !level.woods_carry_complete )
	{
		if( flag("pause_woods_carry") )
		{
			wait (0.05 );
			continue;	
		}

		if( flag("woods_carry_cough") )
		{
			wait (0.05 );
			continue;	
		}

        rig_angles = m_player_rig.angles;
        forward = AnglesToForward( rig_angles );
        right = AnglesToRight( rig_angles );

		a_normalized_rotation = level.player GetNormalizedCameraMovement();

		// Rotation
		if ( a_normalized_rotation[1] >= 0.2 )
		{
			// woods rotation checks
	        
			v_rotate_vel = v_rotate_speed * a_normalized_rotation[1];
			v_woods_spot = level.m_player_spot.origin + ( (VectorNormalize(right) * -1) * 16 );
			v_rotate_radius = v_woods_spot - level.m_player_spot.origin;
			v_rotation_movement = v_rotate_vel + ( VectorCross( v_rotate_radius, v_up ) );
			v_rotation_point = v_woods_spot + v_rotation_movement;
			v_final_woods_rotation = PlayerPhysicsTrace( v_woods_spot + level.woods_carry_height_offset, v_rotation_point + level.woods_carry_height_offset );
	        
		    v_difference = (v_rotation_point + level.woods_carry_height_offset) - v_final_woods_rotation;
		    if ( Length( v_difference ) < 0.01 )
			{
		      	v_final_angles = level.m_player_spot.angles - ( v_rotate_speed * abs(a_normalized_rotation[1] ) );
		       	level.m_player_spot RotateTo( v_final_angles, 0.05 );
		    }
		}
		else if ( a_normalized_rotation[1] <= -0.2 )
		{
			// woods rotation checks
	        
			v_rotate_vel = v_rotate_speed * a_normalized_rotation[1];
		    v_woods_spot = level.m_player_spot.origin + ( (VectorNormalize(right) * -1) * 16 );
		    v_rotate_radius = v_woods_spot - level.m_player_spot.origin;
			v_rotation_movement = v_rotate_vel + ( VectorCross( v_rotate_radius, v_up ) );
		    v_rotation_point = v_woods_spot + v_rotation_movement;
		    v_final_woods_rotation = PlayerPhysicsTrace( v_woods_spot + level.woods_carry_height_offset, v_rotation_point + level.woods_carry_height_offset );

			v_difference = (v_rotation_point + level.woods_carry_height_offset) - v_final_woods_rotation;
			if ( Length( v_difference ) < 0.01 )
		    {	        	
				v_final_angles = level.m_player_spot.angles + ( v_rotate_speed * abs(a_normalized_rotation[1] ) );
			    level.m_player_spot RotateTo( v_final_angles, 0.05 );
			}
	    }

		wait ( .05 );
	}
}


//*****************************************************************************
//*****************************************************************************
carry_crouch_buttonPressed()
{
	if( !level.console && self usebuttonpressed() )
	{
		return true;
	}

	if ( level.wiiu )
	{
		binding = getKeyBinding( "+stance" );
		return self buttonPressed( binding["key1"] );
	}
	else
	{
		return self buttonPressed("BUTTON_B");
	}
}

mason_carry_crouch_button()
{
	level.mason_carry_button_pressed = false;
	while( !level.woods_carry_complete )
	{
		if ( self carry_crouch_buttonPressed() )
		{
			level.mason_carry_button_pressed = true;
			wait( 0.1 );
		}

		if( level.mason_carry_button_pressed == true )
		{
			level.mason_carry_button_pressed = false;
			while( 1 )
			{
				if( !self carry_crouch_buttonPressed() )
				{
					break;
				}
				wait( 0.01 );
			}
		}
						
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

woods_carry_set_rate( anime, n_rate )
{	
	self SetFlaggedAnim( "looping anim", level.scr_anim[ self.animname ][anime][0], 1, 0, n_rate );
}


//*****************************************************************************
//*****************************************************************************

hide_player_carry()
{
	level.player unlink();
	level.ai_woods unlink();
	level.player.m_player_rig hide();
	flag_set( "pause_woods_carry" );
	level.m_player_spot notify ( "sound_stop" );
}


//*****************************************************************************
//*****************************************************************************

unhide_player_carry()
{
	link_player_and_woods_together();
	level.player.m_player_rig show();

	level.m_player_spot.origin = level.player.origin;
	level.m_player_spot.angles = level.player.angles;
	
	level.m_player_spot thread anim_loop( level.player.m_player_rig, "mason_carry_idle" );
	level.player.m_player_rig thread anim_loop( level.ai_woods, "mason_carry_idle" );

	wait( 0.2 );

	level.woods_carry_is_moving = false;
	level.woods_carry_delay_walk_frames = 2;
	level.woods_carry_disable_movement = false;

	flag_clear( "pause_woods_carry" );
}


//*****************************************************************************
//*****************************************************************************

kill_player_carry()
{
	level.player unlink();
	level.ai_woods unlink();
	level.player.m_player_rig delete();
	level.woods_carry_complete = true;
	level.m_player_spot notify ( "sound_stop" );
}
