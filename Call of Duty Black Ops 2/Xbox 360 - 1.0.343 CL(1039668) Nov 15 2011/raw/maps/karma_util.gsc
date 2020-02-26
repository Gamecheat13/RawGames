
#include common_scripts\utility;
#include maps\_utility;
#include animscripts\anims;
#include maps\_objectives;
#include maps\_scene;
#include maps\_dynamic_nodes;
#include maps\_strength_test;
#include maps\_glasses;


#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
Objectives
-------------------------------------------------------------------------------------------*/

//
//	List all level objectives
setup_objectives()
{	
	level.a_objectives = [];
	level.n_obj_index = 0;

	// SECTION 1
	level.OBJ_SECURITY 			= register_objective( "Get through Security Checkpoint" );
	level.OBJ_FIND_CRC			= register_objective( "Head to the CRC area" );
	level.OBJ_ENTER_CRC 		= register_objective( "Infiltrate the CRC room" );
	level.OBJ_CRC_GUY			= register_objective( "Stun the engineer" );
	level.OBJ_SCAN_EYE			= register_objective( "Scan eye" );

//
	level.OBJ_DISABLE_ZAPPER	= register_objective( "Disable static discharger" );
	level.OBJ_IT_GUYS 			= register_objective( "Stun both men" );

	// SECTION 2
	level.OBJ_EVENT_5_1a		= register_objective( "Exit hotel room." );
	level.OBJ_EVENT_5_1b		= register_objective( "Get to the elevators." );	
	level.OBJ_EVENT_5_2a		= register_objective( "Get inside the elevator shaft." );
	level.OBJ_EVENT_5_2b		= register_objective( "Rappel down to the CRC floor." );	
	level.OBJ_EVENT_5_3			= register_objective( "Locate the CRC." );
	level.OBJ_EVENT_5_4			= register_objective( "Get inside the CRC." );
	level.OBJ_INTERACT			= register_objective( &"" );	
	level.OBJ_EVENT_5_5			= register_objective( "Hack the computer and find Karma." );		
	level.OBJ_EVENT_5_6			= register_objective( "Get to the elevators." );
	level.OBJ_EVENT_6_1a		= register_objective( "Follow Salazar" );
	level.OBJ_EVENT_6_1b		= register_objective( "Make your way inside the club." );
	level.OBJ_MEET_KARMA		= register_objective( "Meet up with Karma and Harper." );
	level.OBJ_TAG_TWO_GUARDS	= register_objective( "Mark two targets for Salazar." );
	level.OBJ_KILL_CLUB_GUARDS	= register_objective( "Neutralize all terrorists." );
	
	// SECTION 3
	level.OBJECTIVE_EVENT_7_1 = register_objective( "Locate Defalco in the shopping mall" );
	level.OBJECTIVE_EVENT_8_1 = register_objective( "Defeat the Defalco's Security guards in the Mall" );
	level.OBJECTIVE_EVENT_8_2 = register_objective( "Head towards the swimming pool area" );
	//level.OBJECTIVE_EVENT_9_0 = register_objective( "Regroup with Harper in the Swimming Pool Area" );
	level.OBJ_ADVANCE_PAST_ROCKS = register_objective( "Advance past the rocks and locate Defalco" );
	level.OBJ_STOP_DEFALCO_ESCAPING_WITH_KARMA = register_objective( "Advance, stop Defalco escaping with Karma" );
	level.OBJ_DESTROY_THE_METAL_STORM = register_objective( "Destroy the Metal Storm Attack Vehicle" );
	level.OBJECTIVE_EVENT_9_2 = register_objective( "Quickly advance to the escape vehicle, Defalco is escaping with Karma" );
	level.OBJECTIVE_EVENT_9_3 = register_objective( "Stop Defalco escaping from the Ship" );
	level.OBJECTIVE_EVENT_10_1 = register_objective( "Stop Karma's abduction, she can't leave the ship" );
	
	// Handles the updating of objectives
	level thread maps\_objectives::objectives();
}


/* ------------------------------------------------------------------------------------------
	HERO SKIPTO: Starts a Hero in a skipto at the specified scriptstruct

	Hero Characters are:-
		"han", "harper", "salazar", "redshirt1", "redshirt2"

-------------------------------------------------------------------------------------------*/

init_hero_startstruct( str_hero_name, str_struct_targetname )
{
	ai_hero = init_hero( str_hero_name );
	
	s_start_pos = getstruct( str_struct_targetname, "targetname" );
	assert( IsDefined(s_start_pos), "Bad Hero setup struct: " + str_struct_targetname );
	
	if( IsDefined(s_start_pos.angles) )
	{
		v_angles = s_start_pos.angles;
	}
	else
	{
		v_angles = ( 0, 0, 0 );
	}
	
	ai_hero forceteleport( s_start_pos.origin, v_angles );
	
	return( ai_hero );
}


//*****************************************************************************
// CLEANUP Funcs
// 	Call add_cleanup_ent( str_section, e_add )
// self = level
//*****************************************************************************
add_cleanup_ent( str_category, e_add )
{
	if ( !IsDefined( level.a_e_cleanup ) )
	{
		level.a_e_cleanup = [];
	}
	if ( !IsDefined( level.a_e_cleanup[ str_category ] ) )
	{
		level.a_e_cleanup[ str_category ] = [];
	}
	
	ARRAY_ADD( level.a_e_cleanup[ str_category ], e_add );
}


// Call to cleanup ents added through add_cleanup_ent
cleanup_ents( str_category )
{
	if ( IsDefined( level.a_e_cleanup ) && IsDefined( level.a_e_cleanup[ str_category ] ) )
    {
		foreach( ent in level.a_e_cleanup[ str_category ] )
		{
			if ( IsDefined( ent ) )
			{
				ent Delete();
			}
		}
		
		level.a_e_cleanup[ str_category ] = undefined;
    }
}

// Use add_spawn_function_group() on a spawner to set the category (needed when using the spawn manager)
// self = ent
spawner_set_cleanup_category( str_category )
{
	//IPrintLnBold( "SPAWN MANAGER!!!!" );
	add_cleanup_ent( str_category, self );
}

/* ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------*/

stick_player( b_look, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom )
{
	if ( !IsDefined( b_look ) )
	{
		b_look = false;
	}
	
	self.m_link = Spawn( "script_model", self.origin );
	self.m_link.angles = self.angles;
	self.m_link SetModel( "tag_origin" );
	
	if ( b_look )
	{
		self PlayerLinkToDelta( self.m_link, "tag_origin", 1, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom, true );
	}
	else
	{
		self PlayerLinkToAbsolute( self.m_link, "tag_origin" );
	}
}


/* ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------*/

unstick_player()
{
	if ( IsDefined( self.m_link ) )
	{
		self.m_link Delete();
	}
}


//
//	Rotates the sticky ent to face an entity (2D)
//	self is the player
player_stick_face_ent( e_target, n_time, n_accel, n_decel )
{
	if ( !IsDefined( n_time ) )
	{
		n_time = 1.0;
	}
	if ( !IsDefined( n_accel ) )
	{
		n_accel = 0.0;
	}
	if ( !IsDefined( n_decel ) )
	{
		n_decel = 0.0;
	}
	
	v_to_target = VectorNormalize( e_target.origin - self.origin );
	v_angles = VectorToAngles( v_to_target );
	self.m_link RotateTo( v_angles, n_time, n_accel, n_decel );
	wait( n_time );
}

	
/* ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------*/

hud_create_bar( x, y, width, height, shader )
{
	bar = newHudElem();

	bar.alignX = "left";
	bar.alignY = "top";
//	bar.horzAlign = "right";
//	bar.vertAlign = "bottom";
	bar.x = x;
	bar.y = y;
	bar.width = width;
	bar.height = height;
//bar.foreground = true;
	//bar.frac = 0;
	bar.color = ( 1.0, 1.0, 1.0 );
	bar.shader = shader; 
	bar setShader( shader, width, height );
	bar.alpha = 0.2;
	
	return( bar );
}


//-------------------------------------------------------------
//	Extra Cam functions
//-------------------------------------------------------------

// Start the extra cam
start_glasses_cam()
{
	if ( !IsDefined( level.e_extra_cam ) )
	{
		level.e_extra_cam = GetEnt( "endgame_extra_cam", "targetname" );
	}
	if( IsDefined(level.e_extra_cam) )
	{
		level.e_extra_cam SetClientFlag( level.CLIENT_FLAG_GLASSES_CAM );
	}
	
	//level.e_extra_cam playsound( "evt_pnp_on" );
	//level.e_extra_cam playloopsound( "evt_pnp_loop", 1 );
}


//*****************************************************************************
//*****************************************************************************

stop_glasses_cam()
{
	if( IsDefined(level.e_extra_cam) )
	{
		level.e_extra_cam ClearClientFlag( level.CLIENT_FLAG_GLASSES_CAM );
		//level.e_extra_cam stoploopsound( .5 );
		//level.e_extra_cam playsound ("evt_pnp_off");
		//level.hud_extra_cam Destroy();
//		level.hud_extra_cam = undefined;
	}
}


/* ------------------------------------------------------------------------------------------
  optional: [e_attacker] if defined, only fail if this entity causes the damage 
  optional: [str_endon] if defined, a way to terminate the thread with an endon string
  optional: [str_mission_failure] if defined, string to prnt when mission fails
-------------------------------------------------------------------------------------------*/

mission_failure_if_entity_shot( e_attacker, str_endon, str_mission_failure, impact_fx, fail_wait )
{
	self endon( "death" );
	
	// Optional endon condition
	if( IsDefined(str_endon) )
	{
		self endon( str_endon );
	}

	// Keep checking the character for damage
	mission_fail = false;
	while( mission_fail == false )
	{
		self waittill( "damage", amount, attacker, direction, point, method );
		
		if( IsDefined(impact_fx) )
		{
			PlayFX( impact_fx, point, direction );
		}
		
		if( IsDefined(e_attacker) )
		{
			if( attacker == e_attacker )
			{
				mission_fail = true;
			}
		}
		else
		{
			mission_fail = true;
		}
	
		if( mission_fail == true)
		{
			if( IsDefined(fail_wait) ) 
			{
				wait( fail_wait );
			}

			if( IsDefined(str_mission_failure) )
			{
				maps\_utility::missionFailedWrapper( str_mission_failure );
			}
			else
			{
				maps\_utility::missionFailedWrapper();
			}
		}
	}
}



//
//	self is an elevator model
//		the elevator targets the doors.
//		The doors will tell us how to move them.
//			script_float - rotateYaw
//			script_vector - relative moveTo amount
elevator_move_doors( b_open, n_time, n_accel, n_decel, b_connect_paths )
{
	if ( !IsDefined( n_time ) )
	{
		n_time = 2.0;
	}

	if ( !IsDefined( n_accel ) )
	{
		n_accel = 0.0;
	}
	if ( !IsDefined( n_decel ) )
	{
		n_decel = 0.0;
	}
	
	a_doors = GetEntArray( self.target, "targetname" );
	
	// Open the doors
	foreach( m_door in a_doors )
	{
		if ( b_open )
		{
			m_door Unlink();
		}
	
		// Rotate door
		if ( IsDefined( m_door.script_float ) )
		{
			n_rotate = m_door.script_float;
			if ( !b_open )
			{
				n_rotate = n_rotate * -1;
			}
			m_door RotateYaw( n_rotate, n_time, n_accel, n_decel );
		}
		// Move door
		else if ( IsDefined( m_door.script_vector) )
		{
			v_move = m_door.script_vector;
			if ( !b_open )
			{
				v_move = v_move * -1;
			}
			m_door MoveTo( m_door.origin + v_move, n_time, n_accel, n_decel );
		}
	}
	
	wait ( n_time );

	// If the doors close, then link to the elevator so we can move.
	if ( !b_open )
	{
		foreach( m_door in a_doors )
		{
			m_door LinkTo( self );
		}
	}
	if ( IsDefined( b_connect_paths ) )
	{
		foreach( m_door in a_doors )
		{
			if ( b_open )
			{
				m_door ConnectPaths();
			}
			else
			{
				m_door DisconnectPaths();
			}
		}
	}
}


//*****************************************************************************
// self = entity
//*****************************************************************************

entity_hold_last_anim_frame( ragdoll_hold )
{
	if( IsDefined(ragdoll_hold) && (ragdoll_hold) )
	{
		self ragdoll_death();
	}
	else
	{
		self.a.nodeath = true; 
	    self set_allowdeath( true );
		self die();
	}
}


//*****************************************************************************
// Kill an entity if in specified pose after time 
//  - used primerily for controlled balocny deaths
//
// [delay] - optional delay before checking for death pos
// <pose> - If the entity is in this pose, kill him
//
// self = entity
//*****************************************************************************

entity_death_in_pose_after_time( delay, str_pose )
{
	self endon( "death" );

	if( IsDefined(delay) )
	{
		wait( delay );
	}	

	// Wait for a stand pose
	while( 1 )
	{
		if( self.a.pose == str_pose )
		{
			wait( 0.05 );
			
			self.health = 1;
			self DoDamage( self.health, self.origin );
			return;
		}
		wait( 0.01 );
	}
}


//*****************************************************************************
// Basic spawn function for ai
// - Waits for spawned ai to reach goal, then ncreases radius
// self = guy
//*****************************************************************************

spawn_fn_ai_run_to_target( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades )
{
	self.goalradius = 48;
	self waittill( "goal" );
	self.goalradius = 2048;
	self entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades );
}


//*****************************************************************************
// self = entity
//*****************************************************************************

entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades )
{	
	if( IsDefined(player_favourate_enemy) && (player_favourate_enemy!= 0) )
	{
		self.favoriteenemy = level.player;
	}
	
	if( IsDefined(str_cleanup_category) )
	{
		spawner_set_cleanup_category( str_cleanup_category );
	}
	
	if( IsDefined(ignore_surpression) && (ignore_surpression != 0) )
	{
		self.script_ignore_suppression = 1;
	}

	if( IsDefined(disable_grenades) && (disable_grenades != 0) )
	{
		self.grenadeAmmo = 0;
		self.script_accuracy = 1.0;
	}
}


//*****************************************************************************
// AI stays on target node and acts very aggressive
//*****************************************************************************

spawn_fn_ai_run_to_holding_node( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades )
{
	self.goalradius = 48;
	self waittill( "goal" );
	self.fixednode = true;
	self entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades );
}


//*****************************************************************************
// AI goes prone and stays on target
//*****************************************************************************

spawn_fn_ai_run_to_prone_node( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades )
{
	// While there running to the prone node, make them harder to kill
	self.overrideActorDamage = ::run_to_prone_damage_override;
	self.npc_damage_scale = 0.1;

	self.goalradius = 48;
	self waittill( "goal" );
	self.fixednode = true;
	self AllowedStances( "prone" );
	
	// At node, make easier to kill but still quite difficult
	self.npc_damage_scale = 0.7;
	
	self entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades );
}

run_to_prone_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if( IsDefined(self.npc_damage_scale) )
	{
		//if( IsDefined(e_inflictor) && (e_inflictor != level.player) )
		{
			//IPrintLnBold( "Reduced Damage" );
			n_damage = int(n_damage * self.npc_damage_scale);
		}
	}
	return( n_damage );
}


//*****************************************************************************
//*****************************************************************************

spawn_fn_ai_run_to_jumper_node( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades )
{
	self endon( "death" );

	// While there running to the prone node, make them harder to kill
	self.overrideActorDamage = ::run_to_jumper_damage_override;
	self.npc_damage_scale = 0.1;

	self.goalradius = 48;
	self waittill( "goal" );
	self.fixednode = true;
	
	// Hide
	self AllowedStances( "crouch" );
	
	// Dont fire
	self.pacifist = true;
	
	// At node, make easier to kill but still quite difficult
	self.npc_damage_scale = 0.1;
	
	self entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades );
	
	attack_player_dist = (42.0*16.0);

	self.break_out = false;	
	while( self.break_out == false )
	{
		dist = distance( level.player.origin, self.origin );
		if( dist < attack_player_dist )
		{
			self.break_out = true;
		}
		wait( 0.01 );
	}

	//IPrintLnBold( "AI JUMP AT PLAYER" );
	
	self.pacifist = false;
	self.fixednode = false;
	self.goalradius= 2048;
	self.script_ignore_suppression = 1;
	self.favoriteenemy = level.player;
	self AllowedStances( "stand" );
	
	self thread player_rusher( undefined, undefined, level.player_rusher_jumper_dist, 0.02, 0.1, 1 );
}

run_to_jumper_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if( IsDefined(self.npc_damage_scale) )
	{
		//if( IsDefined(e_inflictor) && (e_inflictor != level.player) )
		{
			//IPrintLnBold( "Reduced Damage" );
			n_damage = int(n_damage * self.npc_damage_scale);
		}
	}
	return( n_damage );
}


//*****************************************************************************
// Kills an animation scene after time
// If defined, deletes all entities in ents array
// self = level
//*****************************************************************************

kill_scene_and_ents_after_time( str_scene_name, delay, a_ents )
{
	if( IsDefined(delay) ) 
	{
		wait( delay );
	}
	
	end_scene( str_scene_name );
	
	if( IsDefined(a_ents) )
	{
		for( i=0; i<a_ents.size; i++ )
		{
			e_ent = a_ents[i];
			e_ent delete();
		}
	}
}


//
//	Print3D above the character
print3d_ent( str_msg, v_offset, n_time, msg_endon )
{
/#
	self endon( "death" );
	
	if ( IsDefined( msg_endon ) )
	{
		level endon( msg_endon );
	}
	
	if( !IsDefined( n_time ) )
	{
		n_time = 99999;
	}

	n_time = GetTime() + ( n_time * 1000 );

	if( !IsDefined( v_offset ) )
	{
		v_offset = ( 0, 0, 32 );
	}
	v_offset = v_offset + ( 0, 0, 1.5 );

	if ( str_msg == "animname" )
	{
		if ( IsDefined( self.script_animname ) )
		{
			str_msg = self.script_animname;
		}
		else
		{
			str_msg = "NA";
		}
	}
	
	while( GetTime() < n_time )
	{
		print3d( self.origin + v_offset, str_msg );
		wait( 0.05 );
	}
#/
}


//
//	Deletes the guy and removes him from the hero array
delete_hero( ai_hero )
{
	if ( IsAlive( ai_hero ) )
	{
		ai_hero Delete();
	}
	level.heroes = array_removeDead( level.heroes );
}


//*****************************************************************************
//*****************************************************************************
// MOVING COVER: 
//*****************************************************************************
//*****************************************************************************

// self = guy
guy_moving_cover_think( e_moving_cover )
{
	self endon( "death" );
	e_moving_cover endon( "death" );

	wait( 0.1 );
	
	ai_stationary = 0;

	while( 1 )
	{
		n_node = get_best_dynamic_node_for_ai_to_attack( e_moving_cover, self, level.player );
	
		switch( e_moving_cover.mode )
		{
			case "stationary":
				if( !ai_stationary )
				{
					self.ignoreall = true;
					self SetGoalNode( n_node );
					self.goalradius = 32;
					self waittill( "goal" );
				
					ai_stationary = 1;
					self.ignoreall = false;
					self.accuracy = 1;
					self.favoriteenemy = level.player;
				}
			break;
		
			case "preparing_to_move":
				self.ignoreall = true;
				ai_stationary = 0;
			break;
		
			case "moving":
				self.ignoreall = true;
				ai_stationary = 0;
				
				v_pos = ( n_node.origin[0], n_node.origin[1], self.origin[2] );
				self SetGoalPos( v_pos );
				self.goalradius = 32;
				self waittill( "goal" );
				wait( 1 );
			break;

			default:
				IPrintLnBold( "MOVING COVER: BAD MODE" );
			break;
		}
		
		wait( 0.01 );
	}
}

// self = moving cover
moving_cover_think( e_guy, max_moves, move_time, move_dist, stationary_time )
{
	self endon( "death" );
	e_guy endon( "death" );

	// Grab the linked cover nodes
	self entity_grab_attached_dynamic_nodes( 1 );

	start_time = gettime();
	self.mode =  "stationary";
		
	stationary_time = 8;
	preparing_to_move_time = 1;
	
	num_moves = 0;
	
	paths_connected = 0;
		
	while( 1 )
	{
		//n_node = GetNode( "moving_cover_node", "targetname" );
		n_node = get_best_dynamic_node_for_ai_to_attack( self, e_guy, level.player );
	
		time = gettime();
	
		switch( self.mode )
		{
			// 
			case "stationary":
				if( num_moves < max_moves )
				{
					dt = ( time - start_time ) / 1000;
					if( dt >= stationary_time )
					{
						//IPrintLnBold( "Preparing To Move" );
						self.mode = "preparing_to_move";
						start_time = time;
						num_moves++;
					}
				}
			break;

			// 
			case "preparing_to_move":
				dt = ( time - start_time ) / 1000;
				if( dt > preparing_to_move_time )
				{
					//IPrintLnBold( "Moving" );
					self.mode = "moving";
					start_time = time;
					if( !paths_connected )
					{
						//self ConnectPaths();
						paths_connected = 1;
					}
				}
			break;

			// 
			case "moving":
				dir = AnglesToForward( self.angles );
				dest_pos = self.origin + (dir * (move_dist));
				self moveto( dest_pos, move_time );

				//IPrintLnBold( "Stationary" );
				self.mode = "stationary";
				start_time = time;
				
				if( paths_connected )
				{
					//self DisconnectPaths();
					paths_connected = 0;
				}
			
				//dt = ( time - start_time ) / 1000;
				//if( dt > move_time )
				//{
				//	IPrintLnBold( "Stationary" );
				//	self.mode = "stationary";
				//	start_time = time;
				//}
			break;

			// 
			default:
				IPrintLnBold( "MOVING COVER: BAD MODE" );
			break;
		}

		wait( 0.01 );
	}
}

get_best_dynamic_node_for_ai_to_attack( e_cover_ent, ai_ent, ai_target_ent )
{
	assert( IsDefined(e_cover_ent.a_dynamic_nodes), "No Dynamic Nodes attached to Dynamic Cover Object" );

	n_node = undefined;
	futhest_dist = 0.0;
	for( i=0; i<e_cover_ent.a_dynamic_nodes.size; i++ )
	{
		test_node = e_cover_ent.a_dynamic_nodes[i];
		dist = distance( ai_target_ent.origin, test_node.origin );
		if( dist > futhest_dist )
		{
			futhest_dist = dist;
			n_node = test_node;
		}
	}

	return( n_node );
}


//-------------------------------------------------------------------------------------------
// Set AI to be visible with Trespasser Perk enabled.
//-------------------------------------------------------------------------------------------
ai_visible()
{
	self endon( "death" );
	
	if( flag( "trespasser_reward_enabled" ) && level.player HasPerk( "specialty_trespasser" ) )
	{		
		Target_Set( self );		
	}
}


//*****************************************************************************
// 
//*****************************************************************************

simple_spawn_script_delay( a_ents, spawn_fn, param1, param2, param3, param4 )
{
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i];
		
		if( IsDefined(e_ent.script_delay) )
		{
			level thread spawn_with_delay( e_ent.script_delay, e_ent, spawn_fn, param1, param2, param3, param4 );
		}
		else
		{
			simple_spawn_single( e_ent, spawn_fn, param1, param2, param3, param4, undefined, true );
		}
	}
}

spawn_with_delay( delay, e_ent, spawn_fn, param1, param2, param3, param4 )
{
	wait( delay );
	simple_spawn_single( e_ent, spawn_fn, param1, param2, param3, param4 );
}


//*****************************************************************************
// RUSHER - Spawn Function: Taken from POW
//*****************************************************************************

player_rusher( str_category, delay, breakoff_distance, npc_damage_scale, npc_damage_scale_breakoff, disable_pain )
{
	if( IsDefined(delay) )
	{
		wait(delay);
	}
	
	self endon("death");

	if( IsDefined(str_category) )
	{
		spawner_set_cleanup_category( str_category );
	}
	
	// Ignore suppression so that this AI can charge the player
	self.ignoresuppression = 1;
	self.ignoreall = true;
	
	if( IsDefined(disable_pain) && (disable_pain != 0) )
	{
		self disable_pain();
	}
	
	player = get_players()[0];
	
	self change_movemode( "sprint" );
	
	self.overrideActorDamage = ::player_rusher_damage_override;
	self.npc_damage_scale = npc_damage_scale;
	self.npc_damage_scale_breakoff = npc_damage_scale_breakoff;
	
	while( 1 )
	{
		// set the goal entity
		self SetGoalPos( player.origin );
		self set_goalradius( 24 );
			
		wait( 0.2 );
		
		dist = distance( player.origin, self.origin );
		if( dist < breakoff_distance )
		{
			self.npc_damage_scale = self.npc_damage_scale_breakoff;
			self change_movemode( "run" );
			self.ignoresuppression = false;
			self.ignoreall = false;
			self enable_pain();
			self set_goalradius( 2048 );
			return;
		}	
	}
}

// Only allow the player to do damage
player_rusher_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if( IsDefined(self.npc_damage_scale) )
	{
		if( IsDefined(e_inflictor) && (e_inflictor != level.player) )
		{
			//IPrintLnBold( "Clearing Damage" );
			n_damage = int(n_damage * self.npc_damage_scale);
		}
	}

	return( n_damage );
}


//*****************************************************************************
// 
//*****************************************************************************

strength_test_jumpdown_guy( str_node, str_attacker_targetname )
{
	level.player.ignoreme = true;
	level.player maps\_strength_test::set_strengthtest_difficulty( 15, 6 );
	level.player maps\_strength_test::strength_test_start( str_node, str_attacker_targetname, &"KARMA_2_STRENGTH_TEST" );
	level.player.ignoreme = false;
}

nva_boom( guy )
{
	level notify( "nva_boom" );

	guy.noExplosiveDeathAnim = true;
	guy playsound( "wpn_grenade_explode" );

	if( is_mature() && !is_gib_restricted_build() )
	{
		guy.force_gib = true; 
		guy.custom_gib_refs = [];
		guy.custom_gib_refs[0] = "no_legs";
	}

	guy StopAnimScripted();
	wait( 0.05 );
	
	dir = vectornormalize( guy.origin - level.player.origin );
	pos = guy.origin + (dir * (42*3));
	guy MagicGrenadeManual( pos, (0, 0, 25), 0.0 );

	if( is_mature() )
	{
		guy bloody_death();
	}
	
	guy StartRagdoll( 1 );
	guy LaunchRagdoll( (-50, 50, 25), "J_Spine4" );
	
	wait( 2 );
	level notify( "strength_test_finished" );
}


//*****************************************************************************
// Does a dp check against each ent to check if any are within 'req_dot' angle
// RVAL:-
//		0  = can't see
//		>0 = distance to closest ent
//*****************************************************************************

can_see_ents( a_ents, req_dot )
{
	closest_dist = 0.0;
	
	v_forward = AnglesToForward( level.player.angles );
	
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[ i ];
		v_dir = e_ent.origin - level.player.origin;
		v_dir = vectornormalize( v_dir );
		
		dp = vectordot( v_forward, v_dir );
		if( dp > req_dot )
		{
			dist = distance( e_ent.origin, level.player.origin );
			if( (closest_dist==0.0) || ((closest_dist>0.0) && (dist < closest_dist)) )
			{
				closest_dist = dist;
			}
		}
	}

	return( closest_dist );
}

can_see_position( v_pos, req_dot )
{
	v_forward = AnglesToForward( level.player.angles );
	
	v_dir = v_pos - level.player.origin;
	v_dir = vectornormalize( v_dir );
		
	dp = vectordot( v_forward, v_dir );
	if( dp > req_dot )
	{
		dist = distance( v_pos, level.player.origin );
		return( dist );
	}

	return( 0 );
}


//*****************************************************************************
// self = helicopter
//*****************************************************************************

helicopter_fly_down_attack_path( teleport_to_start_node, use_start_node_angles, initial_delay, accel, str_start_struct, reached_node_dist, delete_at_path_end )
{
	self endon( "death" );

	if( IsDefined(initial_delay) )
	{
		wait( initial_delay );
	}

	// Just a satety, speed should be on the node
	speed = 30;

	// Start struct of the attack run
	s_node = getstruct( str_start_struct, "targetname" );
			
	// Set initial helicopter position and oriantation
	if( teleport_to_start_node )
	{
		self.origin = s_node.origin;
	}
	if( use_start_node_angles )
	{
		self.angles = s_node.angles;
	}

	wait( 0.01 );
		
	// Spawn a lookat ent
	e_look_at_ent = spawn( "script_origin", (0, 0, 0) );
		
	// Fly along the linked structs, break when last node doesn't target anything
	while( 1 )
	{
		s_prev_node = s_node;
		s_node = getstruct( s_prev_node.target, "targetname" );
			
		if( IsDefined(s_node.speed) )
		{
			speed = s_node.speed;
		}
						
		self SetSpeed( speed, accel, accel );
		
		self SetVehGoalPos( s_node.origin );

						
		// Set the position of the entity for the heli to look at
		dir = anglestoforward( s_prev_node.angles );
		e_look_at_ent.origin = s_node.origin + (dir * (42*20));
		self SetLookAtEnt( e_look_at_ent );
			
		// Wait until we reach the next node in the path
		dist = distance( self.origin, s_node.origin );
		while( dist > reached_node_dist )
		{
			dist = distance( self.origin, s_node.origin );	
			wait( 0.01 );
		}

		// Is it the end of the path?
		if( !IsDefined(s_node.target) )
		{
			break;
		}			
	}
	
	e_look_at_ent delete();
	
	self notify( "heli_path_complete" );
	
	wait( 0.1 );

	if( Isdefined(delete_at_path_end) && (delete_at_path_end==1) )
	{
		self delete();
	}
	else
	{
		self SetSpeed( 0, accel, accel );
	}
}


//*****************************************************************************
//*****************************************************************************

ai_util_set_goal_radius_delay( str_targetname, delay, goal_radius, wait_goal )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	e_ent = getent( str_targetname, "targetname" );
	if( IsDefined(e_ent) )
	{
		e_ent endon( "death" );
	
		if( IsDefined(wait_goal) )
		{
			e_ent waittill( "goal" );
			wait( 0.2 );
		}

		e_ent.goalradius = goal_radius;
	}
}


//*****************************************************************************
//*****************************************************************************

multiple_trigger_waits( str_trigger_name, str_trigger_notify )
{
	a_triggers = getentarray( str_trigger_name, "targetname");
	for( i=0; i<a_triggers.size; i++ )
	{
		a_triggers[i] thread multiple_trigger_wait( str_trigger_notify );
	}
}

// self = trigger ent
multiple_trigger_wait( str_trigger_notify )
{
	level endon( str_trigger_notify );
	self waittill( "trigger" );
	level notify( str_trigger_notify );
}


//*****************************************************************************
//*****************************************************************************

pip_karma_event( delay, str_struct_name, cam_time )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	level.e_extra_cam = get_extracam();
	
	s_cam = getstruct( str_struct_name, "targetname" );
	
	level.e_extra_cam.origin = s_cam.origin;
	level.e_extra_cam.angles = s_cam.angles;
	
	turn_on_extra_cam();

	wait( cam_time );
	
	turn_off_extra_cam();
}


//*****************************************************************************
//*****************************************************************************

earthquake_delay( delay, scale, duration, origin, radius )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	Earthquake( scale, duration, origin, radius );
}


//*****************************************************************************
//*****************************************************************************

civ_run_from_node_to_node( delay, str_civ_targetname, str_node_start, str_node_end )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	n_node1_start = getnode( str_node_start, "targetname" );
	n_node1_end = getnode( str_node_end, "targetname" );
	ai_civ1 = simple_spawn_single( str_civ_targetname );
	if( IsDefined(ai_civ1) )
	{
		wait( 0.1 );
		ai_civ1 forceteleport( n_node1_start.origin, ai_civ1.angles );
		ai_civ1 SetGoalNode( n_node1_end );
		ai_civ1.goalradius = 48;
		ai_civ1 waittill( "goal" );
		ai_civ1 delete();
	}
	else
	{
		IPrintLnBold( "Out of AI Slots for CIV" );
	}
}


//*****************************************************************************
//*****************************************************************************

civ_run_along_node_array( delay, str_civ_targetname, a_str_nodes, health_override )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	ai_civ = simple_spawn_single( str_civ_targetname );
	if( IsDefined(health_override) )
	{
		ai_civ.health = health_override;
	}
	
	wait( 0.1 );
	
	if( !IsDefined(ai_civ) )
	{
		IPrintLnBold( "Not enough AI slots for Civ" );
		return;
	}

	n_node = getnode( a_str_nodes[0], "targetname" );
	ai_civ forceteleport( n_node.origin, ai_civ.angles );
	wait( 0.1 );
	
	for( i=1; i<a_str_nodes.size; i++ )
	{
		n_node = getnode( a_str_nodes[i], "targetname" );
		ai_civ SetGoalNode( n_node );
		ai_civ.goalradius = 64;
		ai_civ waittill( "goal" );
	}
	
	ai_civ delete();
}


//*****************************************************************************
//*****************************************************************************

update_vision()
{
	a_triggers = getentarray("vision_trigger", "script_noteworthy");
	
	foreach(trigger in a_triggers)
	{
		self thread wait_for_vision( trigger );
	}
	
}

wait_for_vision( trigger )
{
	trigger endon("death");
	
	while(1)
	{
		trigger waittill("trigger");
		self update_vision_base_on_trigger( trigger );
		wait(1);
	}
}

update_vision_base_on_trigger( trigger )
{
	self notify("kill_vision_update");
	self endon("kill_vision_update");
	
	if(trigger.targetname == "checkin_elevator_vision")
	{
		if( self.karma_vision == trigger.targetname )
		{
			return;
		}
		
		level thread maps\createart\karma_art::karma_fog_elevator();
		self.karma_vision = trigger.targetname;		
	}
	else if( trigger.targetname == "checkin_lobby_vision" )
	{
		if( self.karma_vision == trigger.targetname )
		{
			return;
		}
		
		level thread maps\createart\karma_art::karma_fog_lobby();
		self.karma_vision = trigger.targetname;	
	}
	else if( trigger.targetname == "checkin_security_vision" )
	{
		if( self.karma_vision == trigger.targetname )
		{
			return;
		}
		
		level thread maps\createart\karma_art::karma_fog_security();
		self.karma_vision = trigger.targetname;	
	}
	else if( trigger.targetname == "checkin_landingpad_vision" )
	{
		if( self.karma_vision == trigger.targetname )
		{
			return;
		}
		
		level thread maps\createart\karma_art::karma_fog_intro();
		self.karma_vision = trigger.targetname;			
	}
}

