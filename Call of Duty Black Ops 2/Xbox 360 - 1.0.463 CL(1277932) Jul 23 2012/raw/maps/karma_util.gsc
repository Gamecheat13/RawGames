
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
#insert raw\maps\karma.gsh;


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
	level.OBJ_SECURITY 			= register_objective( &"KARMA_OBJ_SECURITY" );
	level.OBJ_FIND_CRC			= register_objective( &"KARMA_OBJ_FIND_CRC" );
	level.OBJ_ENTER_CRC 		= register_objective( &"KARMA_OBJ_INFILTRATE_CRC" );
	level.OBJ_DISABLE_ZAPPER	= register_objective( &"KARMA_OBJ_DISABLE_ZAPPER" );
	level.OBJ_CRC_GUY			= register_objective( &"KARMA_OBJ_CRC_GUY" );

	// SECTION 2
	level.OBJ_INTERACT			= register_objective( &"" );	
	level.OBJ_ID_KARMA			= register_objective( &"KARMA_OBJ_ID_KARMA" );		
	level.OBJ_GET_TO_CLUB		= register_objective( &"KARMA_OBJ_GET_TO_CLUB" );
	level.OBJ_MEET_KARMA		= register_objective(  &"KARMA_OBJ_MEET_KARMA" );
	level.OBJ_KILL_CLUB_GUARDS	= register_objective(  &"KARMA_OBJ_KILL_CLUB_GUARDS" );
	level.OBJ_EXIT_CLUB			= register_objective(  &"KARMA_OBJ_EXIT_CLUB" );
	
	// SECTION 3
	//TODO condense this down to simply chasing down Karma and/or Preventing Karma from leaving the ship.
	level.OBJECTIVE_EVENT_7_1				= register_objective( &"KARMA_2_OBJ_FIND_DEFALCO" );
	level.OBJ_FIGHT_IN_MALL					= register_objective( &"KARMA_2_OBJ_DEFEAT_PMC" );
//	level.OBJ_HELP_SECURITY_DEFEAT_ENEMY	= register_objective( &"KARMA_2_OBJ_DEFECT_AQUARIUM" );
	level.OBJ_SALAZAR_UNLOCK_DOOR			= register_objective( &"KARMA_2_OBJ_OPEN_GATE");
//	level.OBJ_MASON_OPEN_MALL_EXIT_DOOR		= register_objective( "Open the Door to exit the shopping mall" );
	level.OBJ_MOVE_TO_POOL_AREA				= register_objective( "Head towards the swimming pool area" );
	level.OBJ_ADVANCE_PAST_ROCKS			= register_objective( "Advance past the rocks and locate Defalco" );
	level.OBJ_STOP_DEFALCO_ESCAPING_WITH_KARMA	= register_objective( "Advance, stop Defalco escaping with Karma" );
	level.OBJ_DESTROY_THE_METAL_STORM			= register_objective( "Destroy the Metal Storm Attack Vehicle" );
	level.OBJECTIVE_EVENT_9_2					= register_objective( "Quickly advance to the escape vehicle, Defalco is escaping with Karma" );
	level.OBJECTIVE_EVENT_9_3					= register_objective( "Stop Defalco escaping from the Ship" );
	level.OBJECTIVE_DISABLE_KARMA				= register_objective( &"KARMA_2_OBJ_DISABLE_KARMA" );
	
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
// 	Call add_cleanup_ent( str_section )
// self = entity to add to cleanup
//*****************************************************************************
add_cleanup_ent( str_category )
{
	if ( !IsDefined( level.a_e_cleanup ) )
	{
		level.a_e_cleanup = [];
	}
	if ( !IsDefined( level.a_e_cleanup[ str_category ] ) )
	{
		level.a_e_cleanup[ str_category ] = [];
	}
	
	if ( IsArray( self ) )
	{
		level.a_e_cleanup[ str_category ] = ArrayCombine( level.a_e_cleanup[ str_category ], self, true, false);
	}
	else
	{
		ARRAY_ADD( level.a_e_cleanup[ str_category ], self );
	}
}


// Call to cleanup ents added through add_cleanup_ent
cleanup_ents( str_category )
{
	level notify( str_category );
	
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
	
	// Check for loose ents
	a_ents = GetEntArray( str_category, "script_noteworthy" );
	foreach( ent in a_ents )
	{
		ent Delete();
	}
}


/* ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------*/

//
//	Link the player to a tag_origin, then you can keep the player there or move it around
//	b_look - allow the player to look around (default: false)
//	n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom - angle clamp values to use (b_look must be TRUE)
//	self is the player
player_stick( b_look = false, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom )
{
	self.m_link = Spawn( "script_model", self.origin );
	self.m_link.angles = self.angles;
	self.m_link SetModel( "tag_origin" );
	
	self AllowSprint( false );
	
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

//
//	Allow the player to move freely after a player_stick
//	self is the player
player_unstick()
{
	if ( IsDefined( self.m_link ) )
	{
		self.m_link Delete();
		self AllowSprint( true );
	}
}


//
//	Rotates the sticky ent to face an entity (2D)
//	self is the player
player_stick_face_ent( e_target, n_time = 1.0, n_accel = 0.0, n_decel = 0.0 )
{
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


// Attach briefcase model to character
attach_briefcase()
{
	self Attach( "p6_spiderbot_case_anim", "tag_weapon_right" );
}

//
//	This one's a little trickier since we can't detach unless it's actually there.
//
detach_briefcase()
{
	n_attached = self GetAttachSize();
	for ( i=0; i<n_attached; i++ )
	{
		str_attach_model = self GetAttachModelName( i );
		if ( str_attach_model == "p6_spiderbot_case_anim" )
		{
			self Detach( "p6_spiderbot_case_anim", self GetAttachTagName( i ) );
			return;
		}
	}
}

//
// Links the elevator clip to the elevator model
//	returns the brushmodel entity
setup_elevator( str_brushmodelname, str_modelname, str_cleanup )
{
	bm_lift = GetEnt( str_brushmodelname,  "targetname" );

	// Link the door clips
	a_bm_door_clips = GetEntArray( bm_lift.target, "targetname" );
	foreach( bm_door_clip in a_bm_door_clips )
	{
		bm_door_clip LinkTo( bm_lift );
	}
	
	// match the clip to the model
	m_lift = GetEnt( str_modelname, "targetname" );
	bm_lift.origin = m_lift.origin;
	m_lift LinkTo( bm_lift );

	m_origin = spawn( "script_model", m_lift GetTagOrigin( "tag_flashlight" ) );
	m_origin.angles = m_lift GetTagAngles( "tag_flashlight" );
	m_origin SetModel( "tag_origin" );
	m_origin LinkTo( m_lift );
	PlayFXOnTag( level._effect["elevator_light"], m_origin, "tag_origin" );
	
	if ( IsDefined( str_cleanup ) )
	{
		m_origin add_cleanup_ent( str_cleanup );
	}
	
	return bm_lift;
}


//
//	Open or close a set of elevator doors
//		b_open - if true, then open otherwise close the doors
//		n_time - total movement time
//		n_accel - accelleration time
//		n_decel - decelleration time
//		b_connect_paths - if true, then ConnectPaths.  If false, DisconnectPaths
//	self is an elevator model
//		the elevator targets the doors.
//		The doors will tell us how to move them.
//			script_float - rotateYaw
//			script_vector - relative moveTo amount
elevator_move_doors( b_open, n_time = 2.0, n_accel = 0.0, n_decel = 0.0, b_connect_paths )
{
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

spawn_fn_ai_run_to_target( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades, ignore_all )
{
	if( IsDefined(ignore_all) && (ignore_all == true) )
	{
		self.ignoreall = true;
		self.ignoreme = true;
	}
	
	self.goalradius = 48;
	self waittill( "goal" );
	
	if( IsDefined(ignore_all) && (ignore_all == true) )
	{
		self.ignoreall = false;
		self.ignoreme = false;
	}
	
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
		self add_cleanup_ent( str_cleanup_category );
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

spawn_fn_ai_run_to_jumper_node( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades, attack_dist )
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

	if( IsDefined(attack_dist) )
	{
		attack_player_dist = attack_dist;
	}
	else
	{
		attack_player_dist = (42.0*16.0);
	}
	
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
//*****************************************************************************

spawn_ai_battle( str_friendly_sp, str_enemy_sp, friendly_health, enemy_health, friendly_grenades, enemy_grenades, friendly_accuracy, enemy_accuracy )
{
	sp_friendly = getent( str_friendly_sp, "targetname" );
	ai_friendly = simple_spawn_single( sp_friendly, ::spawn_fn_ai_run_to_holding_node );
	if( IsDefined(friendly_health) )
	{
		ai_friendly.health = friendly_health;
	}

	sp_enemy = getent( str_enemy_sp, "targetname" );
	ai_enemy = simple_spawn_single( sp_enemy, ::spawn_fn_ai_run_to_holding_node );
	if( IsDefined(enemy_health) )
	{
		ai_enemy.health = enemy_health;
	}
	
	ai_friendly.favouriteenemy = ai_enemy;
	ai_enemy.favouriteenemy = ai_friendly;
	
	if( !IsDefined(friendly_grenades) )
	{
		ai_friendly.grenadeAmmo = 0;
	}
	if( !IsDefined(enemy_grenades) )
	{
		ai_enemy.grenadeAmmo = 0;
	}

	if( !IsDefined(friendly_accuracy) )
	{
		ai_friendly.script_accuracy = friendly_accuracy;
	}
	if( !IsDefined(enemy_accuracy) )
	{
		ai_enemy.script_accuracy = enemy_accuracy;
	}
}

//*****************************************************************************
//*****************************************************************************
//TODO only used in karma_2 in one instance...see if it's really necessary
add_category_to_ai_in_scene( str_scene_name, str_category )
{
	a_ai = get_ais_from_scene( str_scene_name );
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			a_ai[i] add_cleanup_ent( str_category );		
		}
	}
}


//*****************************************************************************
//*****************************************************************************

run_scene_delay( str_scene_name, delay, dont_let_ai_die_in_scene )
{
	wait( delay );
	level thread run_scene( str_scene_name );
	
	if( IsDefined(dont_let_ai_die_in_scene) )
	{
		// Make sure the ents don't get killed in the fire fight
		wait( 0.1 );
		a_ents = get_ais_from_scene( str_scene_name );
		for( i=0; i<a_ents.size; i++ )
		{
			a_ents[i].health = 10000;
		}
	}
}


//
//	Print3D above the character
print3d_ent( str_msg, v_offset, n_time = 99999, msg_endon )
{
/#
	self endon( "death" );
	
	if ( IsDefined( msg_endon ) )
	{
		level endon( msg_endon );
	}

	n_time = GetTime() + ( n_time * 1000 );

	if( !IsDefined( v_offset ) )
	{
		v_offset = ( 0, 0, 32 );
	}
	v_offset = v_offset + ( 0, 0, 1.5 );

	if ( str_msg == "animname" )
	{
		if ( IsDefined( self.animname ) )
		{
			str_msg = self.animname;
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
				//IPrintLnBold( "MOVING COVER: BAD MODE" );
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
				//IPrintLnBold( "MOVING COVER: BAD MODE" );
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


//*****************************************************************************
// 
//*****************************************************************************

simple_spawn_script_delay( a_ents, spawn_fn, param1, param2, param3, param4, param5 )
{
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i];
		
		if( IsDefined(e_ent.script_delay) )
		{
			level thread spawn_with_delay( e_ent.script_delay, e_ent, spawn_fn, param1, param2, param3, param4, param5 );
		}
		else
		{
			e_ai = simple_spawn_single( e_ent, spawn_fn, param1, param2, param3, param4, param5, true );
			if( IsDefined(e_ent.script_health) )
			{
				e_ai.health = e_ent.script_health;
				//IPrintLnBold( "Overriding Health 2" );
			}
		}
	}
}

spawn_with_delay( delay, e_ent, spawn_fn, param1, param2, param3, param4, param5 )
{
	wait( delay );
	e_ai = simple_spawn_single( e_ent, spawn_fn, param1, param2, param3, param4, param5 );
	if( IsDefined(e_ent.script_health) )
	{
		e_ai.health = e_ent.script_health;
		//IPrintLnBold( "Overriding Health" );
	}
}


//*****************************************************************************
// self = 'civ' ai
//*****************************************************************************

run_to_node_and_die( n_node )
{
	self endon( "death" );

	self SetGoalNode( n_node );
	self.goalradius = 64;
	self waittill( "goal" );
	
	self delete();
}


//
//	A faster and more aggressive enemy
aggressive_runner( str_category, n_delay )
{
	self endon("death");

	if( IsDefined( n_delay ) )
	{
		wait( n_delay);
	}
	
	if( IsDefined(str_category) )
	{
		self add_cleanup_ent( str_category );
	}
	
	// Ignore suppression so that this AI can charge
	self.ignoresuppression = 1;
	self change_movemode( "sprint" );
	// Make them more aggressive and smart
	self.aggressiveMode = true;
	self.canFlank = true;
}

//*****************************************************************************
// RUSHER - Spawn Function: Taken from POW
//*****************************************************************************
player_rusher( str_category, delay, breakoff_distance, npc_damage_scale, npc_damage_scale_breakoff, disable_pain )
{
	self endon("death");

	if( IsDefined(delay) )
	{
		wait(delay);
	}
	
	if( IsDefined(str_category) )
	{
		self add_cleanup_ent( str_category );
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
			self SetGoalPos( self.origin );
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
pip_karma_event( str_structname, str_scene_name )
{
	e_extra_cam = get_extracam();
	
	s_camera = GetStruct( str_structname, "targetname" );
	e_extra_cam.origin = s_camera.origin;
	e_extra_cam.angles = s_camera.angles;
	turn_on_extra_cam();

	run_scene( str_scene_name );

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
	if ( IsDefined( n_node1_start.target ) )
	{
		n_node1_end = getnode( n_node1_start.target, "targetname" );
	}
	else
	{
		n_node1_end = getnode( str_node_end, "targetname" );
	}
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
//		IPrintLnBold( "Out of AI Slots for CIV" );
	}
}


//*****************************************************************************
//*****************************************************************************
civ_run_along_node_array( delay, str_civ_targetname, str_start_node, health_override )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	ai_civ = simple_spawn_single( str_civ_targetname );
	if( !IsDefined(ai_civ) )
	{
/#		
		IPrintLnBold( "Civs out of ent slots" );
#/		
		return;
	}
	
	ai_civ endon( "death" );
	
	if( IsDefined(health_override) )
	{
		ai_civ.health = health_override;
	}
	
	wait( 0.1 );
	
	if( !IsDefined(ai_civ) )
	{
/#
		IPrintLnBold( "Not enough AI slots for Civ" );
#/		
		return;
	}

	if ( IsArray( str_start_node ) )
	{
		n_node = getnode( str_start_node[0], "targetname" );
		ai_civ forceteleport( n_node.origin, ai_civ.angles );
		wait( 0.1 );
		
		for( i=1; i<str_start_node.size; i++ )
		{
			n_node = getnode( str_start_node[i], "targetname" );
			ai_civ SetGoalNode( n_node );
			ai_civ.goalradius = 64;
			ai_civ waittill( "goal" );
		}
	}
	else
	{
		n_node = getnode( str_start_node, "targetname" );
		ai_civ forceteleport( n_node.origin, ai_civ.angles );
		wait( 0.1 );
		
		while( IsDefined( n_node.target ) )
		{
			n_node = getnode( n_node.target, "targetname" );
			ai_civ SetGoalNode( n_node );
			ai_civ.goalradius = 64;
			ai_civ waittill( "goal" );
		}
	}
	
	while ( ai_civ CanSee( level.player ) )
	{
		wait( 2.0 );
	}
	
	ai_civ delete();
}


//*****************************************************************************
//*****************************************************************************

//-------------------------------------------------------------------------------------------
// Camera setup.
//-------------------------------------------------------------------------------------------
camera_think()
{
	v_camera_eyes = self GetEye();
	level.e_extra_cam.origin = v_camera_eyes;
	level.e_extra_cam.angles = self.angles;
	level.e_extra_cam LinkTo( self );	
	self Hide();
}

//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------

Callback_ActorKilled_Check( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime )
{
	if ( IsDefined( eAttacker ) )
	{
		if ( IsPlayer( eAttacker ) )
		{
			if ( self.team == "axis" )
			{
				if ( level.player get_temp_stat( TEMP_STAT_ENEMY_ID ) )
				{
			    	level notify( "killed_with_trespasser" );
				}

				if ( IsDefined( self.b_rappelling ) )
				{
					level notify( "killed_while_rappelling" );
				}
			}
		}
	}
}


kill_helicopters_challenge( str_notify )
{
	while ( true )
	{
		level waittill( "player_killed_helicopter" );
		
		self notify( str_notify );
	}
}

keep_asd_alive_challenge( str_notify )
{
	flag_wait( "friendly_asd_activated" );

	level.vh_friendly_asd endon( "death" );
	
	self waittill( "mission_finished" );

	self notify( str_notify );
}

special_vision_kills_challenge( str_notify )
{
	flag_wait( "trespasser_reward_enabled" );
	
	add_global_spawn_function( "axis", ::special_vision_kill_think, self, str_notify );
	
	// Maybe should do this way...no time to test
//	while ( 1 )
//	{
//		level waittill( "killed_with_trespasser" );
//	}
}

special_vision_kill_think( e_player, str_notify )
{
	self waittill( "death", e_killer );
	
	if( IsPlayer( e_killer ) )
	{
		e_player notify( str_notify );
	}
}

retrieve_bot_challenge( str_notify ) // self == player
{
	m_spiderbot_temp = GetEnt( "destroyed_spider_bot", "targetname" );
	
	trigger_wait( "destroyed_spider_bot_trigger" );

	e_trigger = getent("destroyed_spider_bot_trigger", "targetname");
	e_trigger delete();

	m_spiderbot_temp delete();
	
	self notify( str_notify );
}

no_killing_civ( str_notify )
{
	level endon( "player_killed_civ" );
	
	add_global_spawn_function( "neutral", ::no_killing_civ_think );
	self waittill_any( "mission_finished" );
	
	self notify ( str_notify );	
}

no_killing_civ_think()
{
	self waittill( "death", e_killer );
	
	if( IsPlayer( e_killer ) )
	{
		level notify( "player_killed_civ" );
	}
}

fast_complete_spider_bot( str_notify )
{
	level endon("spiderbot_timed_out");
	
	flag_wait("spiderbot_bootup_done");
	
	level thread timedNotify(300, "spiderbot_timed_out");
	flag_wait( "spiderbot_entered_crc" );
	
	self notify ( str_notify );
}

club_speed_kill_challenge( str_notify )
{
	level endon("club_fight_timed_out");

	flag_wait( "heroes_open_fire" );
	
	level thread timedNotify(30, "club_fight_timed_out");
	
	flag_wait( "counterterrorists_win" );
	
	self notify( str_notify );
}

rappel_kills_challenge( str_notify )
{
	while( 1 )
	{
		level waittill( "killed_while_rappelling" );
	
		self notify( str_notify );
	}
}

karma_no_death_challenge( str_notify ) // self == player
{
	self waittill( "mission_finished" );
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
}
		
locate_int( str_notify )
{
	self waittill( "mission_finished" );
	
	player_collected_all = collected_all();
	
	if( player_collected_all )
	{
		self notify( str_notify );		
	}
}

//stealing this from combat_utility
timedNotify( time, msg )
{
	self endon( msg );
	wait time;
	self notify( msg );
}


//
//	Display a screen hint for a specified amount of time
screen_message( str_msg, n_timeout, str_notify )
{
	screen_message_create( str_msg );

	if ( Isdefined( str_notify ) )
	{
		waittill_any_or_timeout( n_timeout, str_notify );
	}
	else
	{
		wait( n_timeout );
	}
	
	screen_message_delete();
}


//
//  Lerp light intensity over time
//	self is a light
lerp_intensity( n_intensity_final, n_time )
{
	n_frames = Int( n_time * 20 );
	
	n_intensity_current = self GetLightIntensity();
	n_intensity_change_total = n_intensity_final - n_intensity_current;
	n_intensity_change_per_frame = n_intensity_change_total / n_frames;
	
	for ( i = 0; i < n_frames; i++ )
	{
		self SetLightIntensity( n_intensity_current );
		n_intensity_current = n_intensity_current + n_intensity_change_per_frame;
		wait 0.05;
	}

	self SetLightIntensity( n_intensity_final );
}


//
//	Blend an exposure value over time
blend_exposure_over_time( n_exposure_final, n_time )
{
	n_frames = Int( n_time * 20 );
	
	n_exposure_current = GetDvarFloat( "r_exposureValue" );
	n_exposure_change_total = n_exposure_final - n_exposure_current;
	n_exposure_change_per_frame = n_exposure_change_total / n_frames;
	
	SetDvar( "r_exposureTweak", 1 );
	for ( i = 0; i < n_frames; i++ )
	{
		SetDvar( "r_exposureValue", n_exposure_current + ( n_exposure_change_per_frame * i ) );
		wait 0.05;
	}
	
	SetDvar( "r_exposureValue", n_exposure_final );
}


//
//	Run an initial idle scene, wait for a trigger, play a reaction and then end with an idle
//		str_triggername	- name of the trigger to start the react scene
//		str_start_idle	- (optional) starting idle scene
//		str_react 		- react scene
//		str_end_idle 	- (optional) ending idle
//		str_end_flag 	- (optional) flag to wait for to end the scene
react_scene( str_triggername, str_start_idle, str_react, str_end_idle, str_end_flag )
{
	if ( IsDefined( str_end_flag ) )
	{
		level endon( str_end_flag );
		level thread react_scene_end( str_start_idle, str_react, str_end_idle, str_end_flag );
	}

	// Is there a start idle?
	if ( IsDefined( str_start_idle ) )
	{
		thread run_scene( str_start_idle );
	}

	trigger_wait( str_triggername );

	end_scene( str_start_idle );
	// Play reaction
	run_scene( str_react, 1 );
	
	// Is there an end idle?
	if ( IsDefined( str_end_idle ) )
	{
		thread run_scene( str_end_idle );
	}
}

//
//	Wait until str_end_flag and then delete everything
react_scene_end( str_start_idle, str_react, str_end_idle, str_end_flag )
{
	flag_wait( str_end_flag );
	
	if ( IsDefined( str_start_idle ) )
	{
		delete_scene_all( str_start_idle, true, false );
	}
	
	delete_scene_all( str_react, true, false );
		
	if ( IsDefined( str_end_idle ) )
	{
		delete_scene_all( str_end_idle, true, false );
	}	
}


//
//	A special shader that makes the enemies more visible
turn_on_enemy_highlight( guy )
{
	//turn on shader if ability is active
	if( level.player get_temp_stat( TEMP_STAT_ENEMY_ID ) )
	{
		self setClientFlag( CLIENT_FLAG_ENEMY_HIGHLIGHT );
		self.deathfunction = ::turn_off_enemy_highlight;
	}

}

turn_off_enemy_highlight()
{
	self ClearClientFlag( CLIENT_FLAG_ENEMY_HIGHLIGHT );

	return false;
}


setup_helicopter_for_challenge()  // self = helicopter
{
	Target_Set( self );  // enable lockon with missile launchers
	self.overrideVehicleDamage = ::helicopter_damage_callback;  // make sure explosives will kill helicopter
}

helicopter_damage_callback( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsSubStr( ToLower( type ), "bullet" ) )
	{
		iDamage = 0;  // bullets cannot damage this vehicle
	}
	else if ( IsSubStr( ToLower( type ), "explosive" ) || IsSubStr( ToLower( type ), "projectile" ) )  // TEMP - WEAPON NOT YET AVAILABLE; NEEDS SPECIFIC WEAPON
	{
		if ( IsDefined( eAttacker ) && IsPlayer( eAttacker ) )
		{
			level notify( "player_killed_helicopter" );
		}		
		
		// kill off helicopters in the air because the _vehicle_death scripts don't support instant midair deaths
		iDamage = 1;
		
		m_explode = spawn( "script_model", self.origin );
		m_explode SetModel( "tag_origin" );
		m_explode linkto( self, "tag_origin" );
		
		PlayFXOnTag( self.deathfx, m_explode, "tag_origin" );
		
		wait 0.1;
			
		VEHICLE_DELETE( self );
		
		wait 5;
		
		m_explode Delete();
	}
	
	return iDamage;
}