
#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
//*****************************************************************************

start_metal_storm( metal_storm_intro )
{
	
	
	e_metal_storm = maps\_vehicle::spawn_vehicle_from_targetname( "metal_storm_1" );
	//e_metal_storm = GetEnt( "metal_storm_1", "targetname" );

	level notify("start_metalstorm_event");
	
	if( IsDefined(metal_storm_intro) )
	{
		e_metal_storm.intro = 1;
		e_metal_storm thread metal_storm_intro( 0.1 );
	}

	// Who we want the Metal Storm to target
	e_metal_storm.drone_target = level.player;
	
	e_metal_storm thread metal_storm_moving();
	e_metal_storm thread metal_storm_firing();
	e_metal_storm thread metal_storm_damage_effects();
	e_metal_storm thread metal_storm_death_effect();
	
	return( e_metal_storm );
}


//*****************************************************************************
// self = vehicle
//*****************************************************************************

metal_storm_moving()
{
	self endon( "death" );

	self.mode = "patrol_path";
	self.can_see_target = false;
	self.node = GetVehicleNode( "metal_storm_n0", "targetname" );	// Get start node
	
	//self.direction = "anti-clockwise";
	self.direction = "clockwise";
	self.last_reverse_time = GetTime();

	// Make sure out path of nodes has .prev_node links
	if( !IsDefined(self.node.prev_node) )
	{
		metal_storm_calc_path_from_start_node( self.node );
	}	


	//**************************************
	// 
	//**************************************

	while( 1 )
	{
		//*************************
		// Set the next Target Node
		//*************************

		self SetVehGoalPos( self.node.origin, 0, 0 );
		

		//*******************************************
		// Wait until the drone is near the goal node
		//*******************************************
		
		while( 1 )
		{
			//*********************************************
			// Check if the Metal Strorm can see the target
			//*********************************************
			
			height = (42*1);
			start_pos = ( self.origin[0], self.origin[1], self.origin[2]+height );
			end_pos = ( self.drone_target.origin[0], self.drone_target.origin[1], self.drone_target.origin[2]+height );
			trace = bullettrace( start_pos, end_pos, true, self );
			if( IsDefined(trace["entity"]) )
			{
				self.can_see_target = true;
			}
			else
			{
				self.can_see_target = false;
			}
			
			
			//**************************************************
			// Check if the Metal Storm wants to Reveerse course
			//**************************************************
			
			self metal_storm_check_for_direction_change();
			

			//***********************
			// Set the Vehicles Speed
			//***********************
			
			self metal_storm_set_speed();
		
		
			//*******************************************************
			// If we have reach our target node, move to the next one
			//*******************************************************
			
			dist_to_node = distance( self.origin, self.node.origin );
			if( dist_to_node < 100 )
			{
				break;
			}

			//self waittill( "near_goal" );
			
			//IPrintLnBold( "MODE: " + self.mode );
			
			//if( self.can_see_target )
			//{
			//	IPrintLnBold( "CAN SEE TARGET" );
			//}
			
			wait( 0.01 );
		}
		

		//**************************************
		// The Robot has reached its target node
		//**************************************
	
		// The robot either paths clockwise or anti-clockwise
		if( self.direction == "clockwise" )
		{
			self.node = GetVehicleNode( self.node.target, "targetname" );	
		}
		else if( self.direction == "anti-clockwise" )
		{
			self.node = self.node.prev_node;
		}
		else
		{
			AssertMsg( "Unknown Metal Strom Direction" );
		}
	}
}


//***********************************************************************************************************
// self = Metal Storm
//
//
// [override_direction_change_chance] - optional, if set an override for changing direction percentage chance
//***********************************************************************************************************

metal_storm_check_for_direction_change( override_direction_change_chance )
{
	min_time_before_direction_change = 4.0;		// 3.0
	target_behind_me_angle = -0.55;
	turn_around_chance = 6;						// 7 - a randomint( 1000 )

	//*********************************************
	// When was the last time we changed direction?
	//*********************************************
	
	time = gettime();
	last_change = (time - self.last_reverse_time) / 1000;
	if( last_change < min_time_before_direction_change )
	{
		return;
	}


	//*******************************************************************************
	// If the player is approximately behind us, we probably want to change direction
	//*******************************************************************************

	v_dir = vectornormalize( self.drone_target.origin - self.origin );
	v_forward = anglestoforward( self.angles );
	dot = vectordot( v_dir, v_forward );

	if( dot < target_behind_me_angle )
	{
		//IPrintLnBold( "Target Behind Me" );
	
		if( IsDefined(override_direction_change_chance) )
		{
			turn_around_chance = override_direction_change_chance;
		}
		
		rval = randomint( 1000 );
		if( rval > turn_around_chance )
		{
			return;
		}
	}
	else
	{
		return;
	}


	//*****************
	// Change direction
	//*****************

	if( self.direction == "clockwise" )
	{
		self.direction = "anti-clockwise";
	}
	else
	{
		self.direction = "clockwise";
	}

	self.last_reverse_time = time;
}


//*****************************************************************************
// self = Metal Storm
//*****************************************************************************

metal_storm_set_speed()
{
	accel = 20;
	
	target_slow_attack_range = (42*10);

	//****************************************************
	// If the robot needs to turn, slow down the max speed
	//****************************************************

	v_dir = vectornormalize( self.node.origin - self.origin );
	v_forward = anglestoforward( self.angles );
	dot = vectordot( v_dir, v_forward );
	
	if( dot < -0.4 )
	{
		max_speed = 1;
		min_speed = 1;
	}
	else if( dot < 0 )
	{
		max_speed = 2;
		min_speed = 2;
	}
	else if( dot < 0.2 )
	{
		max_speed = 4;
		min_speed = 4;
	}
	else
	{
		max_speed = 13;		// 11
		min_speed = 6;		// 5
	}


	//******************************************************************
	// If we are close to the target and have a clear LOS slow to a stop
	//******************************************************************
			
	dist_to_target = distance( self.origin, self.drone_target.origin );
	if( dist_to_target <= target_slow_attack_range )
	{
		// If we are moving around and are in close proximity to the player and have a
		// clear LOS of the target, slow down
		if( self.mode != "slow_down" )
		{
			if( self.can_see_target == true )
			{
				self.mode = "slow_down";
			}
			else
			{
				self.mode = "patrol_path";
			}
		}
	}
	else
	{
		self.mode = "patrol_path";
	}

	//************************
	// Set speed based on mode
	//************************
		
	if( self.mode == "patrol_path" )
	{
		self SetSpeed( max_speed, accel, accel );		
	}
	else if ( self.mode == "slow_down" )
	{
		self SetSpeed( min_speed, accel, accel );
	}
	else
	{
		AssertMsg( "Unknown Metal Strom Mode" );
	}
}


//*****************************************************************************
// self = vehicle
//*****************************************************************************

metal_storm_firing()
{
	self endon( "death" );
	
	//*******************
	// Basic firing Setup
	//*******************
	
	target_fire_distance = (42*25);		// 42*18, Fire at target distance
	
	turret_enabled = false;
	turret_index = 0;					// 0
	
	// Set burst firing rate
	n_fire_min = 0.4;	// 0.5
	n_fire_max = 0.6;	// 0.6
	n_wait_min = 0.3;	// 0.7
	n_wait_max = 0.4;	// 0.8
	self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, turret_index );
	
		
	//*************************************************
	// If the intro is active, wait for it to cvomplete
	//*************************************************
	
	if( IsDefined(self.intro) )
	{
		self waittill( "intro_complete" );
	}

	
	//**********	
	// Fire loop
	//**********

	while( 1 )
	{
		dist = distance( self.drone_target.origin, self.origin );

		if( (dist < target_fire_distance) && (self.can_see_target) )
		{
			//IPrintLnBold( "Player in Fire Range" );
		
			if( turret_enabled == false )
			{
				self maps\_turret::enable_turret( turret_index ); 
				
				// Force the turret to shoot the player
				a_ents = [];
				a_ents[ a_ents.size ] = level.player;
				self maps\_turret::set_turret_target_ent_array( a_ents, turret_index );

				turret_enabled = true;
			}
		
			
			//self SetTargetEntity( self.drone_target );
			//self ShootTurret();
			//wait( 1 );
		}
		else
		{
			if( turret_enabled == true )
			{
				self maps\_turret::disable_turret( turret_index ); 
				turret_enabled = false;
			}
			
			//self ClearTargetEntity();
		}
	
		wait( 0.01 );
	}
}


//*****************************************************************************
// self = vehicle
//*****************************************************************************

metal_storm_damage_effects()
{
	self endon( "death" );
	
	damage_state1 = 0;
	damage_state2 = 0;
	damage_state3 = 0;
	damage_state4 = 0;
	
	max_health = self.health;

	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction, point, method );
		
		if( IsDefined(attacker) && (attacker == self.drone_target) )
		{
			//********************************
			// Add a damage effect when needed
			//********************************

			health = self.health;
			if( health < 1 )
			{
				health = 1;
			}
			damage_percentage = health / max_health;

			//IPrintLnBold( "DAMAGE %:  " + damage_percentage );

			if( (damage_percentage <= 0.8) && (damage_state1 == 0) )
			{
				playfxontag( level._effect["metal_storm_damage_1"], self, "tag_origin" );
				damage_state1 = 1;
			}

			if( (damage_percentage <= 0.65) && (damage_state2 == 0) )
			{
				playfxontag( level._effect["metal_storm_damage_2"], self, "tag_origin" );
				damage_state2 = 1;
			}

			if( (damage_percentage <= 0.5) && (damage_state3 == 0) )
			{
				playfxontag( level._effect["metal_storm_damage_3"], self, "tag_origin" );
				damage_state3 = 1;
			}

			if( (damage_percentage <= 0.3) && (damage_state4 == 0) )
			{
				playfxontag( level._effect["metal_storm_damage_4"], self, "tag_origin" );
				damage_state4 = 1;
			}

			//********************************
			// Add a damage effect when needed
			//********************************
		
			self PlaySound ("exp_metalstorm_damage");
				
			//playfx( level._effect["def_explosion"], point );
			//IPrintLnBold( "Health: " + self.health, "  Damage: " + amount );
			
			metal_storm_check_for_direction_change( 300 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

metal_storm_death_effect()
{
	self waittill( "death" );
	
	self PlaySound ("exp_metalstorm_damage");
	playfxontag( level._effect["metal_storm_death"], self, "tag_origin" );
	
	level notify( "metal_storm_killed" );
}


//*****************************************************************************
// Link each node in the circular path to the previous node
// Once run each node has:-
//		node->target
//		node->prev_node
//
// This allows the path to be navigated in reverse order
//*****************************************************************************

metal_storm_calc_path_from_start_node( nd_path_node )
{
	nd_start = nd_path_node;
	nd_current = nd_path_node;
	while( 1 )
	{
		// Set prev node
		nd_next = GetVehicleNode( nd_current.target, "targetname" );
		nd_next.prev_node = nd_current;
		nd_current = nd_next;
		
		// Completed the circular path of links
		if( nd_current == nd_start )
		{
			break;
		}
	}
}


//*****************************************************************************
//*****************************************************************************

metal_storm_intro( delay )
{
	level thread metal_storm_tree_fall( 1 );

	// Spawn the guys and send them to their balcony nodes
	a_sp_friendly = getentarray( "metal_storm_friendly_intro_guys", "targetname" );
	a_friendly_ai = simple_spawn( a_sp_friendly );
	
	ai_death_time = 0;
	if( IsDefined(delay) )
	{
		ai_death_time = ai_death_time + delay;
	}

	for( i=0; i<a_friendly_ai.size; i++ )
	{
		a_friendly_ai[i].health = 11111;
		a_friendly_ai[i].grenadeawareness = 0;
		a_friendly_ai[i].goalradius = 42;
		a_friendly_ai[i].ignoreall = true;
		rval = randomfloatrange( 2.5, 3.5 );
		a_friendly_ai[i] thread entity_death_in_pose_after_time( ai_death_time + rval, "stand" );
	}

	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	//target, time, ioffset, index
	a_player = [];
	a_player[a_player.size] = level.player;
	self maps\_turret::set_turret_ignore_ent_array( a_player, 0 );
	
	self maps\_turret::shoot_turret_at_target( a_friendly_ai[0], 0.5, undefined, 0 );
	wait( 0.1 );	
	self maps\_turret::shoot_turret_at_target( a_friendly_ai[1], 0.5, undefined, 0 );
			
	self maps\_turret::clear_turret_ignore_ent_array( 0 );
	
	exploder( 916 );
	wait( 0.2 );
	exploder( 917 );
	wait( 0.2 );
	exploder( 918 );
	wait( 0.2 );
	exploder( 919 );
	
	// Resume normal firing
	self notify( "intro_complete" );
}

metal_storm_tree_fall( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Tree falls
	level notify( "fxanim_tree_palm_start" );
}


