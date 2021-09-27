#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

#using_animtree( "player" );

init_parachute_sim_defaults()
{
	// Setup parachute tweaks
	self.parachute_tweaks = [];
	self.parachute_tweaks["turn_control"] = "right_stick"; 		// left_stick, right_stick or triggers
	self.parachute_tweaks["forward_acceleration"] = 250;		// acceleration along forward axis
	self.parachute_tweaks["lateral_acceleration"] = 500;		// acceleration along right axis	
	self.parachute_tweaks["torque"] = ( 0, -40, 30 );			// rotational accelerations
	self.parachute_tweaks["max_roll"] = 45;						// max bank angle
	self.parachute_tweaks["pendulum_gravity"] = -5000;			// pendulum gravity...higher == slower swing
	self.parachute_tweaks["pendulum_length"] = 101;				// pendulum length...longer is slower swing ( longer period )
	self.parachute_tweaks["pendulum_damping"] = 0.6;			// pendulum damper...higher == comes to rest sooner
	self.parachute_tweaks["max_speed"] = 600;					// max speed ( inches/sec )
	self.parachute_tweaks["min_speed"] = 0;						// min speed ( inches/sec )
	self.parachute_tweaks["lateral_move_damping"] = 0.5;		// damping for lateral movement...higher == stop sooner
	self.parachute_tweaks["max_turn_speed"] = 30;				// max turn speed ( degrees/sec )
	self.parachute_tweaks["max_fall_speed"] = 75;				// max fall speed ( inches/sec )
	self.parachute_tweaks["max_flared_fall_speed"] = 400;		// max flared fall speed ( inches/sec )
	self.parachute_tweaks["max_rise_speed"] = 500;				// max rise speed ( inches/sec )
	self.parachute_tweaks["max_rise_flared_speed"] = 300;		// max rise flared speed ( inches/sec )	
	self.parachute_tweaks["min_stick_turn"] = 0.25;				// stick threshold to start turning
	self.parachute_tweaks["gravity"] = 150;						// world gravity...larger == fall faster towards terminal velocity
	self.parachute_tweaks["lateral_bank_scale"] = 0.6;			// how much of a full bank we get from moving laterally
	self.parachute_tweaks["left_arc"] = 0;						// free look left
	self.parachute_tweaks["right_arc"] = 0;						// free look right
	self.parachute_tweaks["top_arc"] = 0;						// free look up
	self.parachute_tweaks["bottom_arc"] = 70;					// free look down
	self.parachute_tweaks["disable_move"] = false;				// for debugging
	self.parachute_tweaks["disable_fall"] = true;				// disable/enable falling
	self.parachute_tweaks["disable_flare"] = false;				// disable/enable flairing
	self.parachute_tweaks["disable_input"] = false;				// disable control input
	
	// Set free look for left stick control
	if ( self.parachute_tweaks["turn_control"] == "left_stick" )
	{
		self.parachute_tweaks["left_arc"] = 30;					// free look left
		self.parachute_tweaks["right_arc"] = 30;				// free look right			
	}	
}

start_parachute_sim()
{
	init_parachute_sim_defaults();	
	
	// Parachute dynamics
	self.parachute_dynamics["velocity"] = AnglesToForward( self.angles ) * self.parachute_tweaks["max_speed"];
	self.parachute_dynamics["angular_velocity"] = ( 0, 0, 0 );
	self.parachute_dynamics["force"] = ( 0, 0, 0 );
	self.parachute_dynamics["flare_state"] = "none";
	self.parachute_dynamics["thermal_state"] = "none";
	self.parachute_dynamics["ai_controlled"] = false;
	self.parachute_dynamics["goal_velocity"] = 0.0;
	
	// Spawn the canopy
	self.parachute_canopy = spawn_anim_model( "player_parachute", self.origin + ( 0, 0, 50 ) );
	self.parachute_canopy.angles = self.angles;
	self.parachute_canopy DontCastShadows();
	
	// Spawn the harness
	self.m_player_rig = spawn_anim_model( "player_rig", ( 0, 0, 0 ) );
	self.m_player_rig.angles = self.angles;
	self.m_player_rig DontCastShadows();
	
//	self.m_altimeter = spawn_anim_model( "player_altimeter" );
//	self.m_altimeter LinkTo( self.m_player_rig, "J_WristTwist_LE", ( 0, 0, 0 ), ( 0, 0, 0 ) );
//	self.m_altimeter DontCastShadows();

	// Link the arms to the canopy at an offset
	self.m_player_rig LinkTo( self.parachute_canopy, "tag_player", ( 0, 0, 0 ), ( 0, 0, 0 ) );	
	
	// Setup the animation thread
	self.parachute_steering = 0;
	self thread parachute_turning_anims();
	self thread parachute_flare_anims();
	self thread parachute_misc_anims();

	// Link the player to the harness
	self HideViewModel();
	self PlayerLinkToDelta( self.m_player_rig, "tag_origin", 1, 
	                       self.parachute_tweaks["right_arc"], self.parachute_tweaks["left_arc"], 
	                       self.parachute_tweaks["top_arc"], self.parachute_tweaks["bottom_arc"], 
	                       false );	                      
	
	// Disable extra stuff here
	SetSavedDvar( "cg_drawCrosshair", 0 );
	self DisableWeapons();
	
	// Start the sim
	self thread parachute_update_sim();
	//self thread parachute_debug_redrop();
	//self thread parachute_crash_watcher();
	
	//self thread parachute_draw_debug();	
}

start_ai_parachute_sim( path ) // self == ai
{
	init_parachute_sim_defaults();	

	self.parachute_tweaks["turn_control"] = "left_stick";
	self.parachute_tweaks["max_roll"] = 25;
	self.parachute_tweaks["min_stick_turn"]	= 0;
	self.parachute_tweaks["pendulum_damping"] = 0.575;
	self.parachute_tweaks["torque"] = ( 0, -720, 360 );			// rotational accelerations	
	self.parachute_tweaks["max_turn_speed"] = 360;				// max turn speed ( degrees/sec )
	self.parachute_tweaks["max_speed"] = 500;					// max speed ( inches/sec )
	self.parachute_tweaks["pendulum_damping"] = 0.65;

	// Parachute dynamics
	self.parachute_dynamics["velocity"] = ( 0, 0, 0 ); //AnglesToForward( s_parachute_start.angles ) * self.parachute_tweaks["max_speed"];
	self.parachute_dynamics["angular_velocity"] = ( 0, 0, 0 );
	self.parachute_dynamics["force"] = ( 0, 0, 0 );
	self.parachute_dynamics["flare_state"] = "none";
	self.parachute_dynamics["thermal_state"] = "none";
	self.parachute_dynamics["goal_pos"] = undefined;
	self.parachute_dynamics["ai_controlled"] = true;
	
	// For animations
	self.parachute_steering = 0;	
	
	// Spawn the ai parachute
	self.parachute_canopy = spawn_anim_model( "ai_parachute", self.origin );
	self.parachute_canopy.angles = self.angles;
	
	// link ai to chute
	self LinkTo( self.parachute_canopy, "tag_player", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	// Start idle animation
	//self.parachute_canopy SetAnim( self.parachute_canopy getanim( "chute_idle" ), 1, 0.0, 1 );
	//self.parachute_canopy thread anim_loop_solo( self, "chute_idle", "stop", "tag_player" );
	
	// Start the sim
	//self thread parachute_ai_follow_player( 100 );
	
	if ( IsDefined( path ) )
	{
		self thread parachute_ai_follow_path( path );
	}
	
	self thread parachute_update_sim();
}

parachute_ai_follow_player( radius )
{
	while ( 1 )
	{
		player_pos = level.player.parachute_canopy.origin;
		self_pos = self.parachute_canopy.origin;
		
		delta = flat_origin( player_pos ) - flat_origin( self_pos );
		
		dist = Length( delta );
		if ( dist > radius )
		{
			self.parachute_dynamics["goal_pos"] = flat_origin( player_pos );
		}
		
		wait( 0.05 );
	}
}

parachute_ai_follow_path( path_start )
{
	self endon( "death" );
	self endon( "end_parachute" );
	self endon( "end_parachute_sim" );
	
	path_start_node = GetVehicleNode( path_start, "targetname" );
	
	//AssertEx( IsDefined( path_start_node ), "Could not find parachute path: " + path_start_node );

	// Set my position to the start of the path	
	self.parachute_canopy.origin = path_start_node.origin;
	
	// get starting line
	last_node = undefined;
	current_node = path_start_node;
	next_node = GetVehicleNode( current_node.target, "targetname" );
	
	initial_dir = next_node.origin - current_node.origin;
	initial_dir = VectorNormalize( initial_dir );
	
	self.parachute_dynamics["velocity"] = initial_dir * current_node.speed;
	
	initial_angles = VectorToAngles( initial_dir );
	self.parachute_canopy.angles = initial_angles + ( 0, 0, 45 );

	fraction = 0;
	
	while ( IsDefined( next_node.target ) )
	{
		last_node_dir = ( 1, 0, 0 );
		if ( IsDefined( last_node ) )
		{
			last_node_dir = current_node.origin - last_node.origin;
			last_node_dir = VectorNormalize( last_node_dir );
		}
		else 
		{
			last_node_dir = AnglesToForward( self.parachute_canopy.angles );
		}

		curr_node_dir = next_node.origin - current_node.origin;
		curr_node_dir = VectorNormalize( curr_node_dir );
		
		next_node_dir = GetVehicleNode( next_node.target, "targetname" ).origin - next_node.origin;
		next_node_dir = VectorNormalize( next_node_dir );
		
		next_node_plane = curr_node_dir + next_node_dir;
		next_node_plane = VectorNormalize( next_node_plane );
		
		curr_node_plane = last_node_dir + curr_node_dir;
		curr_node_plane = VectorNormalize( curr_node_plane );
		
		origin = self.parachute_canopy.origin;
		
		curr_node_to_origin = origin - current_node.origin;
		origin_to_next_node = next_node.origin - origin;
		
		d1 = VectorDot( curr_node_to_origin, curr_node_plane );
		d2 = VectorDot( origin_to_next_node, next_node_plane );
		
		if ( d2 < 0 )
		{
			self notify( "reached_node" );
			if ( IsDefined( current_node.script_noteworthy ) )
			{
				self notify( current_node.script_noteworthy );
			}
			
			last_node = current_node;
			current_node = next_node;
			next_node = GetVehicleNode( current_node.target, "targetname" );
			
			continue;
		}
		else if ( d1 < 0 )
		{
			d1 = VectorDot( curr_node_dir, curr_node_to_origin );
			if ( d1 < 0 )
			{
				fraction = 0;	
			}
			else 
			{
				curr_node_length = Length( next_node.origin - current_node.origin );
				dist = Length( origin_to_next_node );
				
				fraction = 1 - ( dist / curr_node_length );
				fraction = clamp( fraction, 0, 1 );
				
				if ( fraction > 0.95 )
				{					
					self notify( "reached_node" );
					if ( IsDefined( current_node.script_noteworthy ) )
					{
						self notify( current_node.script_noteworthy );
					}					
					
					last_node = current_node;
					current_node = next_node;
					next_node = GetVehicleNode( current_node.target, "targetname" );
					continue;					
				}
			}
		}
		
		fraction = d1 / ( d1 + d2 );
		
		speed = 0;
		if ( IsDefined( self.parachute_dynamics["script_speed"] ) )
		{
			speed = self.parachute_dynamics["script_speed"];
		}
		else
		{
			speed = current_node.speed + ( next_node.speed - current_node.speed ) * fraction;
		}
		
		look_ahead = current_node.lookahead + ( next_node.lookahead - current_node.lookahead ) * fraction;
		
		look_dist = current_node.lookahead * speed;
		
		node_length = Length( next_node.origin - current_node.origin );
		dist = ( fraction * node_length ) + look_dist;
		
		look_pos = ( 0, 0, 0 );
		if ( dist > node_length )
		{
			delta = dist - node_length;
			look_pos = next_node.origin + next_node_dir * delta;
		}
		else 
		{
			look_pos = current_node.origin + curr_node_dir * dist;
		}
		
		look_dir = VectorNormalize( look_pos - self.parachute_canopy.origin );
		
		self.parachute_dynamics["goal_pos"] = look_pos;		
		self.parachute_dynamics["velocity"] = look_dir * speed;
		self.parachute_canopy.origin = self.parachute_canopy.origin + self.parachute_dynamics["velocity"] * 0.05;
		
		// Debug draw
		//thread draw_line_for_time( self.parachute_canopy.origin, look_pos, 1, 1, 1, 0.05 );
		//thread draw_line_for_time( current_node.origin, next_node.origin, 1, 0, 0, 0.05 );
		
		wait( 0.05 );
	}
}

set_ai_speed( n_speed )
{
	self.parachute_dynamics["script_speed"] = n_speed;
}

end_parachute_sim()
{
	// Kill running threads
	self notify( "end_parachute" );
	self notify( "end_parachute_crash_watcher" );
		
	// Unlink player
	self Unlink();
	
	//self.m_altimeter Delete();
	
	// Clean up arms
	self.m_player_rig Unlink();
	self.m_player_rig Delete();
	
	// Delete canopy
	self.parachute_canopy Delete();
	
	// Stop the vents
	end_thermal_vents();
	
	// Restore view model
	self ShowViewModel();
	self EnableWeapons();
	SetSavedDvar( "cg_drawCrosshair", 1 );
}

end_ai_parachute_sim()
{
	// Kill running threads
	self notify( "end_parachute" );
	
	// unlink
	self Unlink();
	
	// Delete canopy
	self.parachute_canopy notify( "stop" ); // stop the looping animation
	//self.parachute_canopy Delete();
}

parachute_crash_watcher()
{
	self endon( "death" );
	self endon( "end_parachute_crash_watcher" );
	
	trace_dist = 30;
	
	while ( 1 )
	{
		trace = BulletTrace( self.origin, self.origin + ( 0, 0, -1 ) * trace_dist, false, self );
		trace2 = BulletTrace( self.origin, self.origin + AnglesToForward( self.angles ) * trace_dist, false, self );
		//thread draw_line_for_time( self.origin, self.origin + ( 0, 0, -1 ) * trace_dist, 1, 1, 1, 0.05 );
		                    
		if ( trace["fraction"] < 1.0 || trace2["fraction"] < 1.0)
		{
			//IPrintLnBold( "CRASH" );
			self notify( "end_parachute" );
			
			self parachute_crash_animation();
			
			MissionFailed();
			
			self notify( "end_parachute_crash_watcher" );
		}
		
		wait( 0.05 );
	}
}

parachute_crash_animation()
{
	self Unlink();
	self PlayerLinkToDelta( self.m_player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	
	self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "neutral2flare" ), 0 );
	self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "flare2neutral" ), 0 );
	self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "turn_left2right" ), 0 );
	self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "turn_right2left" ), 0 );
	self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "neutral" ), 0 );

	self.m_player_rig ClearAnim( self.m_player_rig getanim( "neutral2flare" ), 0 );
	self.m_player_rig ClearAnim( self.m_player_rig getanim( "flare2neutral" ), 0 );
	self.m_player_rig ClearAnim( self.m_player_rig getanim( "neutral" ), 0 );
	self.m_player_rig ClearAnim( %castle_parachute_turning, 0 );
	
	//self.m_altimeter ClearAnim( self.m_altimeter getanim( "neutral2flare" ), 0 );
	//self.m_altimeter ClearAnim( self.m_altimeter getanim( "flare2neutral" ), 0 );
	//self.m_altimeter ClearAnim( self.m_altimeter getanim( "neutral" ), 0 );
	//self.m_altimeter ClearAnim( %castle_parachute_turning, 0 );

	crash_anim = "crash_death";
	if ( self.parachute_dynamics["thermal_state"] == "in" )
	{
		crash_anim = "fire_death";
		parachute_thermal_fullscreen_fx();
	}
	
	self.m_player_rig SetAnim( self.m_player_rig getanim( crash_anim ), 1, 0.1, 1 );
	self.parachute_canopy SetAnim( self.parachute_canopy getanim( crash_anim ), 1, 0.1, 1 );
	//self.m_altimeter SetAnim( self.m_altimeter getanim( crash_anim ), 1, 0.1, 1 );	
}

parachute_precache()
{
	// Precache 
	PreCacheModel( "ctl_parachute_player" );
	PreCacheModel( "ctl_parachute_ai" );
}

setup_thermal_vents()
{
	thermal_trigs = GetEntArray( "trig_thermal", "targetname" );
	array_thread( thermal_trigs, ::parachute_thermal );	
	//array_thread( thermal_trigs, ::parachute_thermal_fx );
}

end_thermal_vents()
{
	thermal_trigs = GetEntArray( "trig_thermal", "targetname" );
	array_notify( thermal_trigs, "end_parachute" );
}

parachute_draw_debug()
{
	while ( 1 )
	{
		thread draw_circle_until_notify( self.parachute_canopy.origin, 5, 1, 1, 0, self, "stop_parachute_debug" );
		thread draw_circle_until_notify( self.m_player_rig.origin, 5, 1, 0, 1, self, "stop_parachute_debug" );
		thread draw_line_for_time( self.parachute_canopy.origin, self.m_player_rig.origin, 1, 1, 1, 0.05 );
		
		wait ( 0.05 );
		
		self notify( "stop_parachute_debug" );
	}
}

parachute_update_sim()
{
	self endon( "death" );
	self endon( "end_parachute" );
	self endon( "end_parachute_sim" );
	
	
	
	self.last_left_stick = ( 0, 0, 0 );
	self.left_stick = ( 0, 0, 0 );
	self.right_stick = ( 0, 0, 0 );
	
	lateral_movement = ( self.parachute_tweaks["turn_control"] == "right_stick" );

	while ( 1 )
	{
		// Get the current angles
		angles = self.parachute_canopy.angles;
		
		// Input values
		turn_input = 0;
		bank_input = 0;
				
		// Check for stick input
		self.last_left_stick = self.left_stick;
		
		// If user is a player
		if ( !self.parachute_dynamics["ai_controlled"] && !self.parachute_tweaks["disable_input"] )
		{
			// Get current stick
			self.left_stick = self GetNormalizedMovement();
			self.right_stick = self GetNormalizedCameraMovement();
			
			if ( IsDefined( self.parachute_dynamics["goal_pos"] ) )
			{
				// Influence the player controlled movement
				
				dir_to_goal = flat_origin( self.parachute_dynamics["goal_pos"] ) - flat_origin( self.parachute_canopy.origin );	
				dist = Length( dir_to_goal );
				
				dir_to_goal = VectorNormalize( dir_to_goal );

				if ( dist > 10 )
				{				
					yaw_angles = ( 0, AngleClamp180( angles[1] ), 0 );
					dir = AnglesToForward( yaw_angles );
					
					//thread draw_line_for_time( self.parachute_canopy.origin, self.parachute_canopy.origin + dir * dist, 0, 1, 1, 0.05 );								
					
					x = VectorDot( dir, dir_to_goal );
					y = ( 1 - x );
					y = y * 5;
					y = min( y, 1 );
					
					y /= 3;
					
					right = AnglesToRight( yaw_angles );
					right_dot = VectorDot( dir_to_goal, right );
					
					if ( right_dot < 0 )
					{
						y = y * -1;
					}
						
					self.right_stick += ( 0, y, 0 );
				}
			}
		}
		else
		{
			if ( IsDefined( self.parachute_dynamics["goal_pos"] ) )
			{			
				//thread draw_line_for_time( self.parachute_canopy.origin, self.parachute_dynamics["goal_pos"], 1, 0, 1, 0.05 );
				
				dir_to_goal = flat_origin( self.parachute_dynamics["goal_pos"] ) - flat_origin( self.parachute_canopy.origin );	
				dist = Length( dir_to_goal );
				
				if ( dist > 10 )
				{
					dir_to_goal = VectorNormalize( dir_to_goal );
					
					yaw_angles = ( 0, AngleClamp180( angles[1] ), 0 );
					dir = AnglesToForward( yaw_angles );
					
					//thread draw_line_for_time( self.parachute_canopy.origin, self.parachute_canopy.origin + dir * dist, 0, 1, 1, 0.05 );								
					
					x = VectorDot( dir, dir_to_goal );
					y = ( 1 - x );
					y = y * 5;
					y = min( y, 1 );
					
					right = AnglesToRight( yaw_angles );
					right_dot = VectorDot( dir_to_goal, right );
					
					if ( right_dot < 0 )
					{
						y = y * -1;	
					}
						
					if ( IsPlayer( self ) )
					{
						z = 0;
						if ( self.parachute_dynamics["goal_pos"][2] > self.parachute_canopy.origin[2] )
						{
							z = 1;
						}
						else if ( self.parachute_dynamics["goal_pos"][2] < self.parachute_canopy.origin[2] )
						{
							z = -1;
						}
						
						self.left_stick = ( x, y, z );
						self.right_stick = ( x, y, 0 );
					}
					else
					{
						self.left_stick = ( 0, y, 0 );
					}
				}
				else 
				{
					self.left_stick = ( 0, 0, 0 );
				}
			}
			else
			{
				self.left_stick = ( 0, 0, 0 );
			}		
		}
	
		// Get turn/strafe values based on stick input and control type
		if ( self.parachute_tweaks["turn_control"] == "right_stick" )
		{
			if ( Abs( self.right_stick[1] ) > self.parachute_tweaks["min_stick_turn"] )
			{
				turn_input = self.right_stick[1];
				bank_input = self.right_stick[1];
			}
			else
			{
				turn_input = 0;
				
				if ( Abs( self.left_stick[1] ) > self.parachute_tweaks["min_stick_turn"] )				
				{
					bank_input = self.left_stick[1] * self.parachute_tweaks["lateral_bank_scale"];
				}
			}
		}
		else if ( self.parachute_tweaks["turn_control"] == "left_stick" )
		{
			if ( Abs( self.left_stick[1] ) > self.parachute_tweaks["min_stick_turn"] )
			{
				turn_input = self.left_stick[1];
				bank_input = self.left_stick[1];
			}
		}
		else if ( self.parachute_tweaks["turn_control"] == "triggers" )
		{
			self DisableWeapons();
			
			if ( self AttackButtonPressed() )
			{
				turn_input = 1;
				bank_input = 1;
			}
			else if ( self AdsButtonPressed() )
			{
				turn_input = -1;
				bank_input = -1;
			}
		}
		
		if ( !self.parachute_tweaks["disable_fall"] )
		{
			if ( self.parachute_tweaks[ "turn_control" ] != "triggers" 
			    && !self.parachute_tweaks["disable_flare"] )
			{
				if ( self AttackButtonPressed() && self AdsButtonPressed() )
				{
					if ( self.parachute_dynamics[ "flare_state" ] != "flare_in" )
					{
						self.parachute_dynamics[ "flare_state" ] = "flare_in";
					}
				}
				else 
				{
					if ( self.parachute_dynamics[ "flare_state" ] == "flare_in" )
					{
						self.parachute_dynamics[ "flare_state" ] = "flare_out";
					}				
				}	
			}
		}
		
		if ( turn_input != 0 )
		{
			self.parachute_steering = lag( turn_input, self.parachute_steering, 1.0,  0.05 );
		}
		else if ( bank_input != 0 )
		{
			self.parachute_steering = lag( bank_input, self.parachute_steering, 1.0, 0.05 );
		}
		else 
		{
			//self.parachute_steering = lag( angles[2] / self.parachute_tweaks[ "max_roll" ], self.parachute_steering, 0.5, 0.05 );
			self.parachute_steering = lag( 0, self.parachute_steering, 1.0, 0.05 );			
			if ( abs( self.parachute_steering ) < 0.1 )		
				self.parachute_steering = 0;
		}
		//PrintLn( self.parachute_steering );

		// If the player is intending to move get the desired angular velocity	
		if ( turn_input != 0 || bank_input != 0 )
		{
			desired_angles = undefined;
			if ( self.parachute_dynamics["ai_controlled"] )
			{
				desired_angles = VectorToAngles( self.parachute_dynamics["velocity"] );
			}
			
			self.parachute_dynamics["angular_velocity"] = parachute_update_desired_angular_velocity( turn_input, bank_input, self.parachute_dynamics["angular_velocity"], angles, self.parachute_tweaks["max_turn_speed"], self.parachute_tweaks["torque"], desired_angles );		
		}

		// Blend in the pendulum motion		
		self.parachute_dynamics["angular_velocity"] = parachute_update_pendulum( angles, self.parachute_dynamics["angular_velocity"] );	
		
		// Integrate angles		
		angles = angles + self.parachute_dynamics["angular_velocity"] * 0.05;
		
		// Clamp angles
		angles = parachute_clamp_angles( angles, self.parachute_dynamics["angular_velocity"], self.parachute_tweaks["max_roll"] );
		
		// Keep angles in range
		self.parachute_canopy.angles = ( AngleClamp180( angles[0] ), AngleClamp180( angles[1] ), AngleClamp180( angles[2] ) );
			
		// Update Velocity vector
		if ( /*IsPlayer( self ) ||*/ !self.parachute_dynamics["ai_controlled"] )
		{
			self.parachute_dynamics["velocity"] = parachute_update_velocity( self.left_stick, self.parachute_dynamics["velocity"], angles, lateral_movement );
			
			// integrate velocity
			self.parachute_canopy.origin = self.parachute_canopy.origin + self.parachute_dynamics["velocity"] * 0.05;
			
			if ( IsDefined( self.parachute_dynamics["goal_pos"] ) )
			{
				dir_to_goal = self.parachute_dynamics["goal_pos"] - self.parachute_canopy.origin;
				dist = Length( dir_to_goal );
				
				thread draw_line_for_time( self.parachute_canopy.origin, self.parachute_dynamics["goal_pos"], 1, 1, 1, 0.05 );
						
				if ( dist < 50 )
				{
					self notify( "goal" );
				}
			}
		}	
		else
		{
			if ( IsPlayer( self ) ) 
			{
				dir_to_goal = self.parachute_dynamics["goal_pos"] - self.parachute_canopy.origin;
				dist = Length( dir_to_goal );
				
				if ( dist < 30 )
				{
					self notify( "goal" );
					self.parachute_dynamics[ "flare_state" ] = "flare_out";						
				}
				else
				{
					self.parachute_dynamics[ "flare_state" ] = "flare_in";	
				}
				
				dir_to_goal = VectorNormalize( dir_to_goal );
				
				self.parachute_dynamics["goal_velocity"] += 5 * 0.05;
				if ( self.parachute_dynamics["goal_velocity"] > self.parachute_tweaks["max_speed"] )
					self.parachute_dynamics["goal_velocity"] = self.parachute_tweaks["max_speed"];
				desired_v = dist / 0.05;
				if ( desired_v < self.parachute_tweaks["max_speed"] )
					v = desired_v;
				
				self.parachute_dynamics["velocity"] = dir_to_goal * self.parachute_dynamics["goal_velocity"];
				self.parachute_canopy.origin = self.parachute_canopy.origin + self.parachute_dynamics["velocity"] * 0.05;							
			}
			else
			{
				//desired_angles = VectorToAngles( self.parachute_dynamics["velocity"] );
				//desired_yaw = AngleClamp180( desired_angles[1] );
				//self.parachute_canopy.angles = ( self.parachute_canopy.angles[0], desired_yaw, self.parachute_canopy.angles[2] );				
			}
		}
					
		wait ( 0.05 );
	}
	
}

parachute_update_velocity( stick, velocity, angles, lateral_movement )
{
	if ( self.parachute_tweaks["disable_move"] )
		return ( 0, 0, 0 );
	
	// Get our forward vector
	forward = AnglesToForward( angles );
	
	// Get our right vector
	flat_angles = ( angles[0], angles[1], 0 );	
	right = AnglesToRight( flat_angles );
	
	// Get the components of velocity on those axes
	speed_forward = VectorDot( velocity, forward );
	speed_lateral = VectorDot( velocity, right );
	speed_vertical = velocity[2];
	
	// Check forward/backward push
	fwd_acceleration = stick[0] * self.parachute_tweaks["forward_acceleration"];
	
	// Check for left/right push
	lateral_acceleration = 0;
	if ( IsDefined( lateral_movement ) && lateral_movement == true )
	{
		lateral_acceleration = stick[1] * self.parachute_tweaks["lateral_acceleration"];
	}
	
	// Update our speeds
	speed_forward = speed_forward + fwd_acceleration * 0.05;
	speed_lateral = speed_lateral + lateral_acceleration * 0.05;
	
	// Clamp forward speed
	max_speed = self.parachute_tweaks["max_speed"];
	if ( self.parachute_dynamics["thermal_state"] == "in" )
	{
		//max_speed = max_speed * 1.25;	
		if ( speed_forward < self.parachute_tweaks["min_speed"] )
		{
			speed_forward = self.parachute_tweaks["min_speed"];
		}
		else if ( speed_forward > self.parachute_tweaks["max_speed"] * 1.25 )
		{
			speed_forward = self.parachute_tweaks["max_speed"] * 1.25;
		}
	}
	else
	{
		if ( speed_forward < self.parachute_tweaks["min_speed"] )
		{
			speed_forward = self.parachute_tweaks["min_speed"];
		}
		else if ( speed_forward > self.parachute_tweaks["max_speed"] )
		{
			speed_forward = speed_forward * 0.95;
		}		
	}
	
	//speed_forward = clamp( speed_forward, self.parachute_tweaks["min_speed"],  max_speed );
	
	// Add damping to the lateral movment to slow down
	damping = speed_lateral * self.parachute_tweaks["lateral_move_damping"];
	speed_lateral = speed_lateral - damping * 0.05;
	
	// Clamp lateral speed
	speed_lateral = clamp( speed_lateral, self.parachute_tweaks["max_speed"] * -1, max_speed );
	
	// Figure out vertical velocity
	up = ( 0, 0, 1 );

	// Gravity
	acceleration = self.parachute_dynamics["force"] + ( up * self.parachute_tweaks["gravity"] * -1 ) * 0.05;
	if ( self.parachute_tweaks["disable_fall"] == true )
	{	
		acceleration = ( 0, 0, 0 );				
		if ( stick[2] != 0 )
		{
			if ( self.parachute_dynamics["ai_controlled"] && self.parachute_dynamics["goal_pos"] != ( 0, 0, 0 ) )
			{
				speed_vertical += 100 * 0.05;
				
				z = self.parachute_dynamics["goal_pos"][2] - self.parachute_canopy.origin[2];
				desired_v = z / 0.05;

				if ( abs( desired_v ) < abs( speed_vertical ) )
				{
					speed_vertical = desired_v;	
				}	
			}
		}
		else
		{
			speed_vertical = 0;
		}
	}
	
	// Make back into a vector
	velocity = ( forward * speed_forward ) + ( right * speed_lateral );
	
	// Set our fall speed back to what it was
	velocity = velocity + ( 0, 0, speed_vertical );
	
	// Now add in acceleration...kind of awkward a little I guess
	velocity = velocity + acceleration;
	
	// clamp fall speed
	if ( self.parachute_dynamics[ "flare_state" ] == "flare_in" )
	{
		if ( velocity[2] < 0 && abs( velocity[2] ) > self.parachute_tweaks[ "max_flared_fall_speed" ] )
		{	
			fall_speed = velocity[2] * 0.9;
			
			if ( abs( fall_speed ) < self.parachute_tweaks[ "max_flared_fall_speed" ] )
			{
				fall_speed = self.parachute_tweaks[ "max_flared_fall_speed" ] * -1;
			}
			
			velocity = ( velocity[0], velocity[1], fall_speed );			
		}
		else if ( velocity[2] > 0 && velocity[2] > self.parachute_tweaks[ "max_rise_flared_speed" ] )
		{
			// Damp out the z velocity if we're past goign faster than the max flared speed
			rise_speed = velocity[2] * 0.7;			
			
			velocity = ( velocity[0], velocity[1], rise_speed );
		}	
	}
	else
	{
		if ( velocity[2] < 0 && abs( velocity[2] ) > self.parachute_tweaks[ "max_fall_speed" ] )
		{
			fall_speed = velocity[2] * 0.9;
			
			velocity = ( velocity[0], velocity[1], fall_speed );
		}
		else if ( velocity[2] > 0 && velocity[2] > self.parachute_tweaks[ "max_rise_speed" ] )
		{
			velocity = ( velocity[0], velocity[1], self.parachute_tweaks[ "max_rise_speed" ] );		
		}
	}
	
	// Zero out force every frame
	self.parachute_dynamics["force"] = ( 0, 0, 0 );
	
	//IPrintLn( "Velocity: " + velocity[0] + ":" + velocity[1] + ":" + velocity[2] );
	
	// pass back
	return velocity;
}

parachute_update_desired_angular_velocity( turn, bank, angular_velocity, angles, max_turn_speed, torque, desired_angles )
{
	stick = ( 0, turn, bank );
	
	angular_velocity = angular_velocity + ( ( stick * torque ) * 0.05 );	
	
	turn_speed = angular_velocity[1];
	turn_speed = Clamp( turn_speed, max_turn_speed * -1, max_turn_speed );
	
	angular_velocity = ( angular_velocity[0], turn_speed, angular_velocity[2] );
	
	if ( IsDefined( desired_angles ) )
	{
		desired_yaw = desired_angles[1];
		desired_yaw = AngleClamp180( desired_yaw );
		
		yaw = angles[1];
		yaw = AngleClamp180( yaw );
		
		diff = desired_yaw - yaw;
		
		dv = diff / 0.05;
		if ( abs( dv ) > 0 && abs( dv ) < abs( angular_velocity[1] ) )
		{
			//angular_velocity = ( angular_velocity[0], dv, angular_velocity[2] );	
			angular_velocity = ( angular_velocity[0], lag( dv, angular_velocity[1], 1.0, 0.05 ), angular_velocity[2] );
		}
	}

	// If we are at the max entent
	if ( angles[2] == self.parachute_tweaks["max_roll"] ) 
	{
		// If we have velocity in that direction 0 it out
		if ( angular_velocity[2] > 0 )
		{
			angular_velocity = ( angular_velocity[0], angular_velocity[1], angular_velocity[2] * 0.95 );
		}
	}
	else if ( angles[2] == self.parachute_tweaks["max_roll"] * -1 ) 
	{
		// Same for the min extent
		if ( angular_velocity[2] < 0 )
		{
			angular_velocity = ( angular_velocity[0], angular_velocity[1], angular_velocity[2] * 0.95 );
		}
	}
	
	return angular_velocity;	
}

parachute_update_pendulum( angles, angular_velocity )
{
	// Find the acceleration due to the pendulum
	angular_acceleration_roll = (( self.parachute_tweaks["pendulum_gravity"] / self.parachute_tweaks["pendulum_length"] ) * 1 ) * Sin( angles[2] );
	
	// Save the old angular velocity
	prev_angular_velocity = angular_velocity;	
	
	// calculate the new angular velocity
	angular_velocity = angular_velocity + ( 0, 0, angular_acceleration_roll ) * 0.05;
	
	// Damping based on hookes law
	damping = angular_velocity * self.parachute_tweaks["pendulum_damping"];
	
	// Adjust angular velocity
	angular_velocity = angular_velocity - damping * 0.05;
	
	// Pass back angular vel
	return angular_velocity;
}

parachute_clamp_angles( angles, angular_velocity, max_roll )
{
	roll = angles[2];
	roll = clamp( roll, max_roll * -1, max_roll );
	
	angles = ( angles[0], angles[1], roll );
	
	return angles;
}

vector_cross( a, b )
{
	x = a[1] * b[2] - a[2] - b[1];
	y = a[2] * b[0] - a[0] - b[2];
	z = a[0] * b[1] - a[1] - b[0];	
	
	return ( x, y, z );
}

lag(desired, curr, k, dt)
{
    r = 0.0;

    if (((k * dt) >= 1.0) || (k <= 0.0))
    {
        r = desired;
    }
    else
    {
        err = desired - curr;
        r = curr + k * err * dt;
    }

    return r;
}

#using_animtree( "vehicles" );

setup_parachute_model_ai()
{
	level.scr_model[ "ai_parachute" ] = "ctl_parachute_ai";
	level.scr_animtree[ "ai_parachute" ] = #animtree;

	level.scr_anim[ "ai_parachute" ][ "chute_idle" ]			= %o_castle_1_1_parachute_idl;	
	level.scr_anim[ "ai_parachute" ][ "chute_left2right" ]		= %o_castle_1_1_parachute_left2right;	
	level.scr_anim[ "ai_parachute" ][ "chute_right2left" ]		= %o_castle_1_1_parachute_right2left;

	level.scr_anim[ "ai_parachute" ][ "chute_loop" ]			= %o_castle_1_1_parachute_idl_new;
	level.scr_anim[ "ai_parachute" ][ "chute_right" ]			= %o_castle_1_1_parachute_leftturn_new;
	level.scr_anim[ "ai_parachute" ][ "chute_left" ]			= %o_castle_1_1_parachute_rightturn_new;
	level.scr_anim[ "ai_parachute" ][ "chute_up" ]				= %o_castle_1_1_parachute_updraft_new;	
}

#using_animtree( "player" );

setup_player_rig()
{
	level.scr_model[ "player_rig" ] = level.player_viewhand_model;
	level.scr_animtree[ "player_rig" ] = #animtree;	

	level.scr_anim[ "player_rig" ][ "neutral2flare" ] 	= %castle_player_paraglide_arms_neutral_to_flare;
	level.scr_anim[ "player_rig" ][ "flare2neutral" ] 	= %castle_player_paraglide_arms_flare_to_neutral;
	level.scr_anim[ "player_rig" ][ "turn_left2right" ] = %castle_player_paraglide_arms_l_to_r;
	level.scr_anim[ "player_rig" ][ "turn_right2left" ] = %castle_player_paraglide_arms_r_to_l;
	level.scr_anim[ "player_rig" ][ "neutral" ] 		= %castle_player_paraglide_arms_neutral_idle;
	level.scr_anim[ "player_rig" ][ "crash_death" ] 	= %castle_player_paraglide_arms_crashdeath;	
	level.scr_anim[ "player_rig" ][ "fire_death" ] 		= %castle_player_paraglide_arms_firedeath;
	
	level.scr_anim[ "player_rig" ][ "sleeve_flap" ] 	= %castle_player_paraglide_arms_sleeveflap;
	
	//setup_altimeter();
}

setup_altimeter()
{
	level.scr_animtree[ "player_altimeter" ]				= #animtree;
	level.scr_model[ "player_altimeter" ]					= "ctl_altimeter";
	
	level.scr_anim[ "player_altimeter" ][ "neutral2flare" ]		= %castle_player_paraglide_altimeter_neutral_to_flare;
	level.scr_anim[ "player_altimeter" ][ "flare2neutral" ]		= %castle_player_paraglide_altimeter_flare_to_neutral;
	level.scr_anim[ "player_altimeter" ][ "turn_left2right" ]	= %castle_player_paraglide_altimeter_l_to_r;
	level.scr_anim[ "player_altimeter" ][ "turn_right2left" ]	= %castle_player_paraglide_altimeter_r_to_l;
	level.scr_anim[ "player_altimeter" ][ "neutral" ]			= %castle_player_paraglide_altimeter_neutral_idle;
	level.scr_anim[ "player_altimeter" ][ "crash_death" ]		= %castle_player_paraglide_altimeter_crashdeath;	
	level.scr_anim[ "player_altimeter" ][ "fire_death" ]		= %castle_player_paraglide_altimeter_firedeath;
}

setup_parachute_model()
{
	level.scr_model[ "player_parachute" ] = "ctl_parachute_player";
	level.scr_animtree[ "player_parachute" ] = #animtree;
	
	level.scr_anim[ "player_parachute" ][ "neutral2flare" ]		= %castle_player_paraglide_chute_neutral_to_flare;
	level.scr_anim[ "player_parachute" ][ "flare2neutral" ]		= %castle_player_paraglide_chute_flare_to_neutral;
	level.scr_anim[ "player_parachute" ][ "turn_left2right" ]	= %castle_player_paraglide_chute_l_to_r;
	level.scr_anim[ "player_parachute" ][ "turn_right2left" ]	= %castle_player_paraglide_chute_r_to_l;
	level.scr_anim[ "player_parachute" ][ "neutral" ]			= %castle_player_paraglide_chute_neutral_idle;
	level.scr_anim[ "player_parachute" ][ "crash_death" ]		= %castle_player_paraglide_chute_crashdeath;	
	level.scr_anim[ "player_parachute" ][ "fire_death" ]		= %castle_player_paraglide_chute_firedeath;	
		
	setup_parachute_model_ai();
}

parachute_misc_anims()
{
	self.m_player_rig SetAnim( self.m_player_rig getanim( "sleeve_flap" ), 1, 0, 1 );
}

parachute_turning_anims() // self = player
{
	self endon( "end_parachute" );
	
	level.UPDATE_TIME      			= 0.05;
	level.BLEND_TIME	   			= 0.5;
	level.STEER_MIN		   			= -1.0;	
	level.STEER_MAX		   			= 1.0;
	level.TURN_ANIM_FPS 			= 5.0;

	self.parachute_canopy SetAnim( %castle_parachute_turning, 1, 0, 1.0 );
	self.parachute_canopy SetAnimLimited( self.parachute_canopy getanim( "turn_left2right" ), 1.0, 0.5, 0.0 );
	self.parachute_canopy SetAnimTime( self.parachute_canopy getanim( "turn_left2right" ), 0.5 );
	
	self.m_player_rig SetAnim( %castle_parachute_turning, 1, 0, 1.0 );
	self.m_player_rig SetAnimLimited( self.m_player_rig getanim( "turn_left2right" ), 1.0, 0.5, 0.0 );
	self.m_player_rig SetAnimTime( self.m_player_rig getanim( "turn_left2right" ), 0.5 );
	
//	self.m_altimeter SetAnim( %castle_parachute_turning, 1, 0, 1.0 );
//	self.m_altimeter SetAnimLimited( self.m_altimeter getanim( "turn_left2right" ), 1.0, 0.5, 0.0 );
//	self.m_altimeter SetAnimTime( self.m_altimeter getanim( "turn_left2right" ), 0.5 );
	
	newAnim = "";
	currAnim = "turn_left2right";

	weight = 1;	
	lastDirection = 1;
	steerValue = 0;	
	
	while(1)
	{
		lastSteerValue = steerValue;
		
		steerValue = self.parachute_steering;
		steerValue = clamp( steerValue, level.STEER_MIN, level.STEER_MAX );
		
		steerDelta = steerValue - lastSteerValue;
		
		// Going left
		if ( steerDelta < 0 )
		{
			if ( currAnim != "turn_right2left" )
			{
				newAnim = "turn_right2left";
			}
		}
		else if ( steerDelta > 0 )
		{
			// Going right
			if ( currAnim != "turn_left2right" )
			{
				newAnim = "turn_left2right";
			}
		}
		
		if ( self.parachute_dynamics["flare_state"] != "none" )
		{
			self.parachute_canopy ClearAnim( %castle_parachute_turning, 0 );
			self.m_player_rig ClearAnim( %castle_parachute_turning, 0 );
			//self.m_altimeter ClearAnim( %castle_parachute_turning, 0 );
			
			self waittill("flare_done");
			
			self.parachute_canopy SetAnim( %castle_parachute_turning, 1, 0, 1 );
			self.m_player_rig SetAnim( %castle_parachute_turning, 1, 0, 1 );
			//self.m_altimeter SetAnim( %castle_parachute_turning, 1, 0, 1 );
			
			newAnim = "";
			
			steerValue = 0;
	
			self.parachute_canopy SetAnimLimited( self.parachute_canopy getanim( currAnim ), weight, level.BLEND_TIME, 0.0 );
			self.parachute_canopy SetAnimTime( self.parachute_canopy getanim( currAnim ), 0.5 );

			self.m_player_rig SetAnimLimited( self.m_player_rig getanim( currAnim ), weight, level.BLEND_TIME, 0.0 );
			self.m_player_rig SetAnimTime( self.m_player_rig getanim( currAnim ), 0.5 );
			
			//self.m_altimeter SetAnimLimited( self.m_altimeter getanim( currAnim ), weight, level.BLEND_TIME, 0.0 );
			//self.m_altimeter SetAnimTime( self.m_altimeter getanim( currAnim ), 0.5 );
		}
			
		if ( newAnim != "" )
		{
			// clear the current anim
			self.parachute_canopy ClearAnim( self.parachute_canopy getanim( currAnim ), 0 );
			self.m_player_rig ClearAnim( self.m_player_rig getanim( currAnim ), 0 );
			//self.m_altimeter ClearAnim( self.m_altimeter getanim( currAnim ), 0 );
			
			if ( is_parachute_turn_anim( newAnim ) && !is_parachute_turn_anim( currAnim ) )
			{
				self.parachute_canopy SetAnim( %castle_parachute_turning, weight, 0, 1.0 );
				self.m_player_rig SetAnim( %castle_parachute_turning, weight, 0, 1.0 );
				//self.m_altimeter SetAnim( %castle_parachute_turning, weight, 0, 1.0 );
			}
			
			//anim_time = get_parachute_anim_time( steerValue, newAnim );
			anim_time = self.parachute_canopy GetAnimTime( self.parachute_canopy getanim( currAnim ) );
			anim_time = 1.0 - anim_time;
			
			self.parachute_canopy SetAnimLimited( self.parachute_canopy getanim( newAnim ), weight, level.BLEND_TIME, 0.0 );
			self.parachute_canopy SetAnimTime( self.parachute_canopy getanim( newAnim ), anim_time );

			self.m_player_rig SetAnimLimited( self.m_player_rig getanim( newAnim ), weight, level.BLEND_TIME, 0.0 );
			self.m_player_rig SetAnimTime( self.m_player_rig getanim( newAnim ), anim_time );
			
			//self.m_altimeter SetAnimLimited( self.m_altimeter getanim( newAnim ), weight, level.BLEND_TIME, 0.0 );
			//self.m_altimeter SetAnimTime( self.m_altimeter getanim( newAnim ), anim_time );
			
			currAnim = newAnim;
			newAnim = "";
		}
		else if ( currAnim != "" )
		{
			anim_time = get_parachute_anim_time( steerValue, currAnim );
			current_time = self.parachute_canopy GetAnimTime( self.parachute_canopy getanim( currAnim ) );
		
			// Set the default rate
			rate = level.TURN_ANIM_FPS * 0.05;				
			
			// Find the delta between the current anim time and the desired anim time
			delta = anim_time - current_time;
			
			// if its less than 0 we need to switch anims here
			if ( delta < 0 )
			{
				// we are going to play nothing this frame...we'll let the next pass
				// through the loop figure out what the intentions were
				rate = 0;				
			}
			else
			{
				if ( delta < rate )
				{
					rate = delta;
				}				
			}
			
			if ( ( current_time > .35 ) && ( current_time < .65 ) && ( rate < .01 ) )
			{
				self.parachute_canopy ClearAnim( self.parachute_canopy getanim( currAnim ), level.BLEND_TIME );
				self.m_player_rig ClearAnim( self.m_player_rig getanim( currAnim ), level.BLEND_TIME );
				//self.m_altimeter ClearAnim( self.m_altimeter getanim( currAnim ), level.BLEND_TIME );
				
				self.parachute_canopy SetAnimLimited( self.parachute_canopy getanim( "neutral" ), 1, level.BLEND_TIME, 1 );
				self.m_player_rig SetAnimLimited( self.m_player_rig getanim( "neutral" ), 1, level.BLEND_TIME, 1 );
				//self.m_altimeter SetAnimLimited( self.m_altimeter getanim( "neutral" ), 1, level.BLEND_TIME, 1 );
			}
			else
			{
				self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "neutral" ), level.BLEND_TIME );
				self.m_player_rig ClearAnim( self.m_player_rig getanim( "neutral" ), level.BLEND_TIME );
				//self.m_altimeter ClearAnim( self.m_altimeter getanim( "neutral" ), level.BLEND_TIME );
				
				self.parachute_canopy SetAnimLimited( self.parachute_canopy getanim( currAnim ), weight, level.BLEND_TIME, rate );
				self.m_player_rig SetAnimLimited( self.m_player_rig getanim( currAnim ), weight, level.BLEND_TIME, rate );
				//self.m_altimeter SetAnimLimited( self.m_altimeter getanim( currAnim ), weight, level.BLEND_TIME, rate );
			}
		}
		
		wait level.UPDATE_TIME;
	}	
}

parachute_flare_anims()
{
	self endon( "end_parachute" );	
	
	flaring = false;
	flare_to_neutral_playing = false;
	
	while ( 1 )
	{
		if ( self.parachute_dynamics["flare_state"] == "flare_in" )
		{
			// If weren't previously flaring
			if ( !flaring )
			{				
				// Gross thing here to start the anim at 0 the first time we play it
				if ( !flare_to_neutral_playing )
				{
					start_time = 0;
				}
				else 
				{
					// Get the desired start time for the animation...if we were playing the flare to neutral "out"
					// animation this will properly transition back to neutral to from the correct position...			
					start_time = 1.0 - self.parachute_canopy GetAnimTime( self.parachute_canopy getanim( "flare2neutral" ) );
				}
				
				// Clear out the flare to neutral animation
				self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "flare2neutral" ), 0 );
				self.m_player_rig ClearAnim( self.m_player_rig getanim( "flare2neutral" ), 0 );
				//self.m_altimeter ClearAnim( self.m_altimeter getanim( "flare2neutral" ), 0 );
			
				// Set the nuetral to flare anim
				self.parachute_canopy SetAnimLimited( self.parachute_canopy getanim( "neutral2flare" ), 1, 0.5, 1.5 );
				self.parachute_canopy SetAnimTime( self.parachute_canopy getanim( "neutral2flare" ), start_time );
				
				self.m_player_rig SetAnimLimited( self.m_player_rig getanim( "neutral2flare" ), 1, 0.5, 1.5 );
				self.m_player_rig SetAnimTime( self.m_player_rig getanim( "neutral2flare" ), start_time );
				
				//self.m_altimeter SetAnimLimited( self.m_altimeter getanim( "neutral2flare" ), 1, 0.5, 1.5 );
				//self.m_altimeter SetAnimTime( self.m_altimeter getanim( "neutral2flare" ), start_time );

				// Set the flag so we're not doing this every frame
				flaring = true;		
			}			
		}
		else if ( self.parachute_dynamics["flare_state"] == "flare_out" )
		{
			// If we're not flaring and were last frame
			if ( flaring )
			{	
				// Get the desired start time for the animation...this is the inverse of what happens in the 
				// other state
				start_time = 1.0 - self.parachute_canopy GetAnimTime( self.parachute_canopy getanim( "neutral2flare" ) );				
				
				// Clear neutral to flare
				self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "neutral2flare" ), 0 );
				self.m_player_rig ClearAnim( self.m_player_rig getanim( "neutral2flare" ), 0 );
				//self.m_altimeter ClearAnim( self.m_altimeter getanim( "neutral2flare" ), 0 );
				
				// Play the animation
				self.parachute_canopy SetAnimLimited( self.parachute_canopy getanim( "flare2neutral" ), 1, 0.5, 1.5 );
				self.parachute_canopy SetAnimTime( self.parachute_canopy getanim( "flare2neutral" ), start_time );
				
				self.m_player_rig SetAnimLimited( self.m_player_rig getanim( "flare2neutral" ), 1, 0.5, 1.5 );	
				self.m_player_rig SetAnimTime( self.m_player_rig getanim( "flare2neutral" ), start_time );
				
				//self.m_altimeter SetAnimLimited( self.m_altimeter getanim( "flare2neutral" ), 1, 0.5, 1.5 );	
				//self.m_altimeter SetAnimTime( self.m_altimeter getanim( "flare2neutral" ), start_time );
				
				flare_to_neutral_playing = true;
					
				// Set the flag to avoid doing this every frame
				flaring = false;				
			}
			else
			{
				time = self.parachute_canopy GetAnimTime( self.parachute_canopy getanim( "flare2neutral" ) );
				if ( time >= 1 )
				{
					self.parachute_canopy ClearAnim( self.parachute_canopy getanim( "flare2neutral" ), 0 );
					self.m_player_rig ClearAnim( self.m_player_rig getanim( "flare2neutral" ), 0 );
					//self.m_altimeter ClearAnim( self.m_altimeter getanim( "flare2neutral" ), 0 );
					
					flare_to_neutral_playing = false;
					
					self.parachute_dynamics["flare_state"] = "none";
					
					self notify( "flare_done" );
				}
			}				
		}
		
		wait ( 0.05 );
	}
}

get_parachute_anim_time( steer_value, anim_name )
{
	anim_time = 0;
	if ( is_parachute_turn_anim( anim_name ) )
	{		
		anim_time = abs( ( steer_value - level.STEER_MIN ) / ( level.STEER_MIN - level.STEER_MAX ) );
		if ( anim_name == "turn_right2left" )
		{
			anim_time = 1.0 - anim_time;
		}
	}

	return anim_time;
}

is_parachute_turn_anim( anim_name ) 
{
	return ( anim_name == "turn_left2right" || anim_name == "turn_right2left" ) || ( anim_name == "chute_left2right" || anim_name == "chute_right2left" );
}

cap_value( value, minValue, maxValue )
{
	assert( isdefined( value ) );

	// handle a min value larger than a max value
	if ( minValue > maxValue )
		return cap_value( value, maxValue, minValue );

	assert( minValue <= maxValue );

	if ( isdefined( minValue ) && ( value < minValue ) )
		return minValue;

	if ( isdefined( maxValue ) && ( value > maxValue ) )
		return maxValue;

	return value;
}

parachute_thermal_fx()
{
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "fire" ) )
	{
		PlayFX( level._effect["fire_field_patch_md"], self.origin, ( 0, 0, 1 ), ( 1, 0, 0 ) );
	}
}

parachute_thermal_fullscreen_fx()
{
	m_fx_dummy = spawn( "script_model", ( 0, 0, 0 ) );
	m_fx_dummy SetModel( "tag_origin" );
	m_fx_dummy LinkTo( self.m_player_rig, "tag_camera", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	PlayFXOnTag( level._effect["fullscreen_fire_death"], m_fx_dummy, "tag_origin" );
}

parachute_thermal()
{
	self endon( "end_parachute" );
	self endon( "death" );
	
	self waittill( "trigger", player );
	player notify( "enter_thermal" );
	
	//play smoke fx
	PlayFXOnTag( getfx( "smoke_push_player" ), level.player.m_player_rig, "tag_origin" );
	
	in_range = true;
	trig_radius = self.radius;
	trig_height = self.height;
	trig_origin = self.origin;
	
	if ( self.classname != "trigger_radius" )
	{
		s_target = getstruct( self.target, "targetname" );
		AssertEx( IsDefined( s_target, "Thermal trigger must target a struct unless it's a tigger_radius." ) );
		trig_origin = ( player.origin[0], player.origin[1], s_target.origin[2] );
	}
	
	// Tweakable...move to kvps
	thermal_force_magnitude = 250;
	thermal_force_flared_magnitude = 150;
	exit_thermal_restore_gravity = 500;

	a_params = self get_thermal_params();
	if ( IsDefined( a_params ) )
	{
		thermal_force_magnitude = Int(a_params[0]);
		thermal_force_flared_magnitude = Int(a_params[1]);
		exit_thermal_restore_gravity = Int(a_params[2]);
		
		/#
			IPrintLn( "thermal: " + thermal_force_magnitude + ", " + thermal_force_flared_magnitude + ", " + exit_thermal_restore_gravity );
		#/
	}

	force = 0;
	current_height = level.player.origin[2];
	start_height = self.origin[2];
	peak = -9999;
		
	// Add the force as long as we're in the radius of the thermal and we
	// haven't reached the desired peak
	while ( peak < ( start_height + self.height ) && in_range )
	{	
		player.parachute_dynamics["thermal_state"] = "in";
		
		// Save the highest altitude
		if ( current_height > peak )
			peak = current_height;
		
		// set the current height on this frame
		current_height = player.origin[2];
		
		// Get the normalized distance from the center of the thermal vent
		player_pos = player.origin;
		
		// extent 
		extent = ( trig_radius, trig_radius, self.height );		
		
		force_dist = Distance( player_pos, trig_origin );
		dist = Distance2D( trig_origin, player_pos );
		
		normalized_dist = dist / trig_radius; 
		normalized_dist = max( normalized_dist, 0.01 );
		
		normalized_force_dist = force_dist / Length( extent );
			
		// Check to see if we're out of range
		if ( normalized_dist > 1 )
		{
			in_range = false;	
		}
		
		normalized_height = ( level.player.origin[2] - start_height ) / self.height;
		normalized_height = ( 1.0 - normalized_height ) / 1.5;
		//normalized_height = .5;
		
		// Pick the appropriate max force
		if ( player.parachute_dynamics[ "flare_state" ] == "flare_in" )
		{
			force = thermal_force_flared_magnitude;
		}
		else 
		{
			force = thermal_force_magnitude;				
		}
		
		// Add the force
		player.parachute_dynamics["force"] = ( 0, 0, 1 ) * ( force * normalized_height );
		
		// Check to see if we are on the back side of a thermal
		player_pos_2D = player_pos * ( 1, 1, 0 );
		player_dir = AnglesToForward( flat_angle( player.angles ) );
		trig_origin_2D = trig_origin * ( 1, 1, 0 );
		delta = VectorNormalize( player_pos_2D - trig_origin_2D );

		// dot <>0 == trig origin behind us
		dot = VectorDot( player_dir, delta );		
		//if ( dot > 0 )
		//{
		//	self.parachute_dynamics["force"] += VectorNormalize( player_dir ) * thermal_force_magnitude;
		//}
		
		//IPrintLn( "Start Height: " + start_height + " Peak: " + peak + " Travel: " + ( peak - start_height ) );		
		
		Earthquake( 0.1, 0.05, level.player.origin, 100 );
		
		wait ( 0.05 );
	}
	
	// After exiting the radius or reaching the desired peak height...the player could have reached a vertical speed
	// which our "normal" gravity would take a long time to bring back down to 0...so our actual peak height would
	// be much higher than intended...To fix this we increase gravity for a short period of time until the z velocity
	// is no longer positive. 
	curr_vel_z = player.parachute_dynamics["velocity"][2];	
	
	// save the original gravity and set the stronger gravity
	save_gravity = player.parachute_tweaks["gravity"];
	player.parachute_tweaks["gravity"] = exit_thermal_restore_gravity;
	
	player.parachute_dynamics["thermal_state"] = "none";
	player notify( "exit_thermal_vent" );
	
	// Until we're back at 0 or below
	while ( curr_vel_z > 0 )
	{
		curr_vel_z = player.parachute_dynamics["velocity"][2];			
		wait ( 0.05 );
	}
	
	// Restore gravity
	player.parachute_tweaks["gravity"] = save_gravity;
	
	// TEST start the thread again...remove me when this goes in for real
	self thread parachute_thermal();
}

get_thermal_params()
{
	if ( IsDefined( self.script_parameters ) )
	{
		return StrTok( self.script_parameters, ":;, " );
	}
}

parachute_instructional_text()
{
	// TODO: Replace with real instruction text
	IPrintLnBold( "Use LS to move" );
	wait( 2.0 );
	IPrintLnBold( "Use RS to look/turn" );
	wait( 2.0 );	
	IPrintLnBold( "Hold RT to flare" );
	wait( 2.0 );	
	IPrintLnBold( "Use the thermal vents to gain altitude" );	
	
	wait( 2.0 );
	
	self waittill( "enter_thermal" );
	
	IPrintLnBold( "Flare (RT) to control your ascent" );
	wait( 2.0 );
	IPrintLnBold( "Exit the vent when desired altitude is reached" );
}

parachute_debug_redrop()
{
	self endon( "death" );
	self endon( "end_parachute" );	
	
	while ( 1 )
	{
		if ( self ButtonPressed("BUTTON_A") )
		{
			self.parachute_canopy.origin += ( 0, 0, 3000 );
		}
		
		wait( 1 );
	}
}

#using_animtree( "generic_human" );
parachute_ai_anims()
{
	self endon( "end_parachute" );
	self endon( "death" );

	while( true )
	{
		//self SetAnimKnobAll( self getanim( "chute_loop"), %root, 1, 0.5, 1.0 );
		//self.parachute_canopy parachute_idle();
		
		
		
		self SetFlaggedAnimKnobAll( "right", self getanim( "chute_right" ), %root, 1, 0.5, 1 );
		self.parachute_canopy parachute_right();
		self waittillmatch( "right", "anim_end" );
		
		self SetFlaggedAnimKnobAll( "left", self getanim( "chute_left" ), %root, 1, 0.5, 1 );
		self.parachute_canopy parachute_left();
		self waittillmatch( "left", "anim_end" );
			
//		msg = self waittill_any_return( "left", "right", "up" );
//		
//		switch( msg )
//		{
//			case "left": 
//				self SetFlaggedAnimKnobAll( "left", self getanim( "chute_left" ), %root, 1, 0.5, 1 );
//				self.parachute_canopy parachute_left();
//				self waittillmatch( "left", "anim_end" );
//				break;
//			case "right":
//				self SetFlaggedAnimKnobAll( "right", self getanim( "chute_right" ), %root, 1, 0.5, 1 );
//				self.parachute_canopy parachute_right();
//				self waittillmatch( "right", "anim_end" );
//				break;
//			case "up":
//				self SetFlaggedAnimKnobAll( "up", self getanim( "chute_up" ), %root, 1, 0.5, 1 );
//				self.parachute_canopy parachute_up();
//				self waittillmatch( "up", "anim_end" );
//				break;
//			default:
//				break;
//		}
	}
}

#using_animtree( "vehicles" );
parachute_right()
{
	self SetAnimKnobAll( self getanim( "chute_left" ), %root, 1, 0.5, 1.0 );
}

parachute_left()
{
	self SetAnimKnobAll( self getanim( "chute_right" ), %root, 1, 0.5, 1.0 );
}

parachute_up()
{
	self SetAnimKnobAll( self getanim( "chute_up" ), %root, 1, 0.5, 1.0 );
}

parachute_idle()
{
	self SetAnimKnobAll( self getanim( "chute_loop" ), %root, 1, 0.5, 1.0 );
}

/*	
#using_animtree( "generic_human" );
parachute_ai_turning_anims( ) // self = ai
{
	self endon( "end_parachute" );
	self endon( "death" );
	
	self ClearAnim( %root, 0.0 );
	
	level.UPDATE_TIME      			= 0.05;
	level.BLEND_TIME	   			= 0.5;
	level.STEER_MIN		   			= -1.0;
	level.STEER_MAX		   			= 1.0;
	level.TURN_ANIM_FPS 			= 5.0;

	chute = self.parachute_canopy;
	
	chute SetAnimLimited( chute getanim( "chute_left2right" ), 1.0, 0.5, 0.0 );
	chute SetAnimTime( chute getanim( "chute_left2right" ), 0.5 );	

	self SetAnim( %castle_parachute_turning, 1, 0, 1.0 ); 		
	self SetAnimLimited( self getanim( "chute_left2right" ), 1.0, 0.5, 0.0 );
	self SetAnimTime( self getanim( "chute_left2right" ), 0.5 );
	
	newAnim = "";
	currAnim = "chute_left2right";

	weight = 1;
	lastDirection = 1;
	steerValue = 0;
	
	while(1)
	{
		lastSteerValue = steerValue;
		
		steerValue = self.parachute_steering;
		steerValue = clamp( steerValue, level.STEER_MIN, level.STEER_MAX );
		
		steerDelta = steerValue - lastSteerValue;
		
		// Going left
		if ( steerDelta < 0 )
		{
			if ( currAnim != "chute_right2left" )
			{
				newAnim = "chute_right2left";
			}
		}
		else if ( steerDelta > 0 )
		{
			// Going right
			if ( currAnim != "chute_left2right" )
			{
				newAnim = "chute_left2right";
			}
		}
		
		if ( self.parachute_dynamics["flare_state"] != "none" )
		{
			chute ClearAnim( chute getanim( currAnim ), 0 );
			self ClearAnim( %castle_parachute_turning, 0 );
			
			self waittill("flare_done");
			
			self SetAnim( %castle_parachute_turning, 1, 0, 1 );	
			
			newAnim = "";
			
			steerValue = 0;
	
			chute SetAnimLimited( chute getanim( currAnim ), weight, level.BLEND_TIME, 0.0 );
			chute SetAnimTime( chute getanim( currAnim ), 0.5 );

			self SetAnimLimited( self getanim( currAnim ), weight, level.BLEND_TIME, 0.0 );
			self SetAnimTime( self getanim( currAnim ), 0.5 );			
		}
			
		if ( newAnim != "" )
		{
			// clear the current anim
			chute ClearAnim( chute getanim( currAnim ), 0 );
			self ClearAnim( self getanim( currAnim ), 0 );
			
			if ( is_parachute_turn_anim( newAnim ) && !is_parachute_turn_anim( currAnim ) )
			{
				self SetAnim( %castle_parachute_turning, weight, 0, 1.0 ); 	
			}
			
			//anim_time = get_parachute_anim_time( steerValue, newAnim );
			anim_time = chute GetAnimTime( chute getanim( currAnim ) );
			anim_time = 1.0 - anim_time;
			
			chute SetAnimLimited( chute getanim( newAnim ), weight, level.BLEND_TIME, 0.0 );
			chute SetAnimTime( chute getanim( newAnim ), anim_time );

			self SetAnimLimited( self getanim( newAnim ), weight, level.BLEND_TIME, 0.0 );
			self SetAnimTime( self getanim( newAnim ), anim_time );
			
			currAnim = newAnim;
			newAnim = "";
		}
		else if ( currAnim != "" )
		{
			anim_time = get_parachute_anim_time( steerValue, currAnim );
			current_time = chute GetAnimTime( chute getanim( currAnim ) );
		
			// Set the default rate
//			rate = level.TURN_ANIM_FPS * 0.05;				
//			
//			// Find the delta between the current anim time and the desired anim time
//			delta = anim_time - current_time;
//			
//			// if its less than 0 we need to switch anims here
//			if ( delta < 0 )
//			{
//				// we are going to play nothing this frame...we'll let the next pass
//				// through the loop figure out what the intentions were
//				rate = 0;				
//			}
//			else
//			{
//				if ( delta < rate )
//				{
//					rate = delta;
//				}				
//			}
			
			rate = 1;
		
			chute SetAnimLimited( chute getanim( currAnim ), weight, level.BLEND_TIME, rate );
			self SetAnimLimited( self getanim( currAnim ), weight, level.BLEND_TIME, rate );
		}
		
		wait level.UPDATE_TIME * 1;
	}	
}
*/


