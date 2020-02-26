
#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_skipto;
#include maps\_scene;
#include maps\_anim;
#include maps\angola_jungle_stealth_carry;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

level_init_flags()
{
	//non event specific flags
	flag_init( "show_introscreen_title" );
	
//	maps\angola_river::init_flags();
//	maps\angola_savannah::init_flags();
	maps\angola_river::init_flags();
	maps\angola_jungle_stealth::init_flags();
	maps\angola_village::init_flags();
	maps\angola_jungle_escape::init_flags();
}

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_setup()
{
	skipto = level.skipto_point;
		
	if ( skipto == "riverbed" )
		return;	

	if ( skipto == "savannah" )
		return;	
	
	if ( skipto == "river" )
		return;	
	
	if ( skipto == "jungle_stealth" )
		return;	
	
	if ( skipto == "village" )
		return;	
		
	if ( skipto == "jungle_escape" )
		return;	

	if ( skipto == "jungle_ending" )
		return;	


}

setup_objectives()
{
	//**********
	// SECTION 1
	//**********

	//**********
	// SECTION 2
	//**********

	level.OBJ_LOCATE_CONVOY	= register_objective( &"ANGOLA_2_LOCATE_CONVOY" );
	level.OBJ_TAKE_OUT_ESCORT = register_objective( &"ANGOLA_2_RIVER_DESTROY_ESCORT");
	level.OBJ_CLEAN_BOAT_DECK = register_objective( &"ANGOLA_2_CLEAR_BOAT_DECK");
	level.OBJ_DESTROY_PURSUING_BOAT = register_objective( &"ANGOLA_2_DESTROY_PURSUING_BOAT");
	level.OBJ_HEAD_TO_WHEEL_HOUSE = register_objective( &"ANGOLA_2_MOVE_TO_HUDSON");
	level.OBJ_GET_ON_BARGE = register_objective( &"ANGOLA_2_GET_ON_BOARD");
	level.OBJ_SECURE_THE_BARGE = register_objective( &"ANGOLA_2_SECURE_THE_BARGE");
	level.OBJ_FIND_WOODS = register_objective( &"ANGOLA_2_SEARCH_WOODS_TRUCK");
	level.OBJ_FIND_STINGER = register_objective( &"ANGOLA_2_FIND_STINGER");
	level.OBJ_DESTROY_HIND = register_objective( &"ANGOLA_2_TAKE_OUT_HIND");
	level.OBJ_RESCUE_WOODS = register_objective( &"ANGOLA_2_RESCUE_WOODS_FROM_WATER");
	level.OBJ_BRUTE_FORCE = register_objective( "");

	
	//**********
	// SECTION 3
	//**********

	// *** Jungle Stealth ***
	level.OBJ_HUDSON_LOOKOUT_FOR_CHILD_SOLDIERS = register_objective( "Regroup with Hudson at the top of the hill" );
	level.OBJ_MASON_HIDE_BEHIND_LOG_OBJECTIVE = register_objective( "Mason take cover behind the Log" );
	level.OBJ_HUDSON_STEALTH_ORDERS1_OBJECTIVE = register_objective( "Stay in cover until Hudson gives the all clear" );
	level.OBJ_MASON_RUN_TO_COVER2_OBJECTIVE = register_objective( "Mason run to cover in the abandoned building" );
	level.OBJ_MASON_IN_COVER2_POSITION = register_objective( "Mason take cover in building, wait for my signal to move" );
	level.OBJ_MASON_RUN_TO_COVER3_OBJECTIVE = register_objective( "Mason run to cover in the Overgrown Grass" );
	level.OBJ_MASON_IN_COVER3_POSITION = register_objective( "Mason nearly there, hide here in the long grass" );
	level.OBJ_MASON_RUN_TO_SAFETY_ROCKS_OBJECTIVE = register_objective( "Mason run to the safety of the rocks" );
	level.OBJ_MASON_ENTER_THE_VILLAGE = register_objective( "Enter the Village and find the Radio Station" );
	level.OBJ_MASON_FOLLOW_HUDSON = register_objective( "Follow Hudson through the jungle to find the village" );
	
	// *** Jungle Village ***
	level.OBJ_MASON_GOTO_HUT_WINDOW = register_objective( "Approach the Radio Tower Hut Window" );
	level.OBJ_MASON_GRAB_MENENDEZ = register_objective( "Approach and overpower Menendez" );
	level.OBJ_INTERACT = register_objective( &"" );
	
	// *** Jungle Escape ***
	level.OBJ_MASON_EXIT_VILLAGE_ENTER_FOREST = register_objective( "Exit the Village into the Forest" );
	level.OBJ_BATTLE_FOREST_1 = register_objective( "Clear the enemy presance in the area so Hudson can move forward with Woods" );
	level.OBJ_PROTECT_HUDSON_AND_WOODS_ON_WAY_TO_BEACH = register_objective( "Protect Hudson and Woods as they advance through the Forest" );
	level.OBJ_BATTLE_FOREST_2 = register_objective( "Protect Woods and hold off the enemy assault" );
	level.OBJ_BATTLE_FOREST_3 = register_objective( "Protect Woods and wait for the Evacuation vehicle to Arrive" );
	level.OBJ_HUDSON_MOVES_TO_BEACH_EVAC = register_objective( "Regroup with Hudson at the Beach Evacuation Point" );
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


//***********************************************************************************
// SCRIPT_HEALTH - Overrides health
// sb42
// SCRIPT_INT - Used to clear (self.fixednode) after X seconds, used by holding nodes
// SCRIPT_FLOAT - If defined is used as accuracy
//***********************************************************************************

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
			if( IsDefined(e_ent.script_int) )
			{
				e_ai thread ai_turn_of_hold_node_after_time( e_ent.script_int );
			}
			if( IsDefined(e_ent.script_float) )
			{
				e_ai.accuracy = e_ent.script_float;
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
	if( IsDefined(e_ent.script_int) )
	{
		e_ai thread ai_turn_of_hold_node_after_time( e_ent.script_int );
	}	
	if( IsDefined(e_ent.script_float) )
	{
		e_ai.accuracy = e_ent.script_float;
	}	
}

// self = ai
ai_turn_of_hold_node_after_time( delay )
{
	self endon( "death" );

	wait( delay );
	self.fixednode = false;
}


//*****************************************************************************
// Basic spawn function for ai
// - Waits for spawned ai to reach goal, then ncreases radius
// self = guy
//*****************************************************************************

spawn_fn_ai_run_to_target( player_favourate_enemy, str_cleanup_category, aggressive_mode, disable_grenades, ignore_me )
{
	if( IsDefined(ignore_me) && (ignore_me == true) )
	{
		self.ignoreme = true;
	}

	if( IsDefined(str_cleanup_category) )
	{
		spawner_set_cleanup_category( str_cleanup_category );
		str_cleanup_category = undefined;
	}

	if( IsDefined(level.jungle_escape_accuracy) )
	{
		self.script_accuracy = level.jungle_escape_accuracy;
	}
		
	self.goalradius = 48;
	self waittill( "goal" );

	self.aggressiveMode= aggressive_mode;
	
	//if( IsDefined(ignore_me) && (ignore_me == true) )
	//{
	//	self.ignoreme = false;
	//}
	
	self.goalradius = 2048;
	self entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, false, disable_grenades );
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
		if( IsDefined(level.jungle_escape_accuracy) )
		{
			self.script_accuracy = level.jungle_escape_accuracy;
		}
		else
		{
			self.script_accuracy = 1.0;
		}
	}

	self.overrideActorDamage = ::enemy_damage_override;
}


//*****************************************************************************
// AI stays on target node and acts very aggressive
//
// SCRIPT_STRING - If set then a node to advance to after the hold
//*****************************************************************************

spawn_fn_ai_run_to_holding_node( player_favourate_enemy, str_cleanup_category, break_hold_time, disable_grenades, ignore_me )
{
	if( IsDefined(level.jungle_escape_accuracy) )
	{
		self.script_accuracy = level.jungle_escape_accuracy;
	}

	self.goalradius = 48;
	self waittill( "goal" );
	self.fixednode = true;
	self entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, false, disable_grenades );

	if( IsDefined(ignore_me) && (ignore_me == true) )
	{
		self.ignoreme = true;
	}

	if( IsDefined(break_hold_time) )
	{
		self thread ai_break_holding_node_timer( break_hold_time );
	}
}

// self = ai
// self.script_string = a node to advance/fall back to
ai_break_holding_node_timer( break_hold_time )
{
	self endon( "death" );
	wait( break_hold_time );
	self.fixednode = false;

	if( IsDefined(self.script_string) )
	{
		nd_node = getnode( self.script_string, "targetname" );
		self.goalradius = 48;
		self setgoalnode( nd_node );
		self waittill( "goal" );
	}

	self.goalradius = 2048;
}


//*****************************************************************************
// AI runs to target node them kills themselves
//
// NOTEL: SCRIPT_INT is set tells the AI to use WALK not RUN
//*****************************************************************************

spawn_fn_ai_run_to_node_and_die( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades )
{
	if( IsDefined(self.script_int) && (self.script_int > 0) )
	{
		self.animname = "misc_patrol";
		self set_run_anim( "walk" );
	}

	self.ignoreall = true;
	self.goalradius = 48;
	self waittill( "goal" );

	self entity_common_spawn_setup( player_favourate_enemy, str_cleanup_category, ignore_surpression, disable_grenades );

	if( IsDefined(self.target) )
	{
		nd_node = getnode( self.target, "targetname" );
		while( IsDefined(nd_node.target) )
		{
			nd_node = getnode( nd_node.target, "targetname" );	
			dist = distance( self.origin, nd_node.origin );
			while( dist > 48 )
			{
				self setgoalpos( nd_node.origin );
				self.goalradius = 48;
				wait( 0.01 );
				dist = distance( self.origin, nd_node.origin );
			}
		}
	}

	self delete();
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
	
	self entity_common_spawn_setup( false, str_category, true, true );

	if( IsDefined(disable_pain) && (disable_pain != 0) )
	{
		self disable_pain();
	}
	
	player = get_players()[0];
	
	self change_movemode( "sprint" );
	
	self.overrideActorDamage = ::enemy_damage_override;
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
			// Should clear his target and get him to re-evaluate his hes tacticval position
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
//*****************************************************************************

enemy_ai_keep_your_distance( keep_away )
{
	ai = GetAIArray( "axis" );
	if( IsDefined(ai) )
	{
		for( i=0; i<ai.size; i++ )
		{
			e_ent = ai[ i ];
			if( keep_away )
			{
				e_ent.a.disableReacquire = true;
			}
			else
			{
				e_ent.a.disableReacquire = false;
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

enemy_ai_disable_grenades( disable_grenades )
{
	ai = GetAIArray( "axis" );
	if( IsDefined(ai) )
	{
		for( i=0; i<ai.size; i++ )
		{
			e_ent = ai[ i ];
			if( disable_grenades )
			{
				e_ent.temp_grenade_num = e_ent.grenadeAmmo;
				e_ent.grenadeAmmo = 0;
			}
			else
			{
				if( IsDefined(e_ent.temp_grenade_num) )
				{
					e_ent.grenadeAmmo = e_ent.temp_grenade_num;
				}
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

ai_set_enemy_fight_distance( e_enemy, path_distance, skip_launchers )
{
	ai = GetAIArray( "axis" );
	if( IsDefined(ai) )
	{
		for( i=0; i<ai.size; i++ )
		{
			e_ent = ai[ i ];

			if( IsDefined(skip_launchers) && (skip_launchers==true) && ent_is_launcher(e_ent) )
			{
				//IPrintLnBold( "Ignoring launcher" );
				continue;
			}

			if( IsDefined(e_enemy) )
			{
				e_ent setgoalentity( e_enemy );
			}
			else
			{
				e_ent setgoalentity( e_ent );
			}

			e_ent.pathEnemyFightDist = path_distance;
		}
	}
}


//*****************************************************************************
//*****************************************************************************

ent_is_launcher( e_spawner )
{
	if( IsDefined(e_spawner.classname) )
	{
		if( IsSubStr( e_spawner.classname, "_Launcher_" ) )
		{
			return( 1 );
		}
	}
	return( 0 );
}


//*****************************************************************************
// min_time for notify: In seconds
// max_time for notify: In seconds
// min_enemies alive: (OPTIONAL) Before notify will fire off
//*****************************************************************************

wait_time_and_enemies( min_time, max_time, min_enemies, str_notify )
{
	start_time = gettime();

	wait( min_time );

	while( 1 )
	{
		// Start after MAX wait time
		time = gettime();
		dt = ( time - start_time ) / 1000;
		if( dt >= max_time )
		{
			break;
		}

		// Start after min AXIS left
		if( IsDefined(min_enemies) )
		{
			num_axis = GetAIArray("axis").size;
			if( num_axis <= min_enemies )
			{
				break;
			}
		}

		wait( 0.01 );
	}
	
	level notify( str_notify );
}


//*****************************************************************************
//*****************************************************************************

simple_spawn_rusher_single( str_rusher_spawner_targetname, str_category, rusher_distance )
{
	sp_rusher = getent( str_rusher_spawner_targetname, "targetname" );
	if( IsDefined(sp_rusher) )
	{
		process_rusher_spawner( sp_rusher, str_category, rusher_distance );
	}
}

simple_spawn_rusher( str_rusher_spawner_targetname, str_category, rusher_distance )
{
	a_sp_rusher = getentarray( str_rusher_spawner_targetname, "targetname" );
	if( IsDefined(a_sp_rusher) )
	{
		for( i=0; i<a_sp_rusher.size; i++ )
		{
			level thread process_rusher_spawner( a_sp_rusher[i], str_category, rusher_distance );
		}
	}
}

process_rusher_spawner( sp_rusher, str_category, rusher_distance )
{
	if( IsDefined(sp_rusher.script_delay) )
	{
		wait( sp_rusher.script_delay );
	}

	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		//IPrintLnBold( "Spawning Rusher" );
		e_ai thread player_rusher( str_category, undefined, rusher_distance, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

ai_run_along_node_array( str_ai_targetname, a_str_nodes, ignore_all, teleport_to_start_node, str_walk_mode )
{
	// Get a delay from the spawner
	s_spawner = getent( str_ai_targetname, "targetname" );
	if(IsDefined(s_spawner.script_delay) )
	{
		delay = s_spawner.script_delay;
	}
	else
	{
		delay = 0;
	}

	// Is there a delay wait?
	if( delay > 0 )
	{
		wait( delay );
	}

	e_ai = simple_spawn_single( str_ai_targetname );
	
	if( IsDefined(ignore_all) && (ignore_all == true) )
	{
		e_ai.ignoreall = true;
	}

	wait( 0.1 );
	
	if( !IsDefined(e_ai) )
	{
		IPrintLnBold( "Not enough AI slots" );
		return;
	}

	if( IsDefined(teleport_to_start_node) && (teleport_to_start_node == true) )
	{
		n_node = getnode( a_str_nodes[0], "targetname" );
		e_ai forceteleport( n_node.origin, e_ai.angles );
		start_index = 1;
	}
	else
	{
		start_index = 0;
	}

	wait( 0.01 );
	
	for( i=start_index; i<a_str_nodes.size; i++ )
	{
		n_node = getnode( a_str_nodes[i], "targetname" );
		e_ai SetGoalNode( n_node );
		e_ai.goalradius = 64;
		e_ai waittill( "goal" );
	}
	
	e_ai delete();
}


//*****************************************************************************
// Fail the mission if the player is NOT inside any of the info volumes
//*****************************************************************************

mission_fail_if_not_inside_info_volumes( str_info_targetname, str_end_notify, fail_mission_delay, fail_mission_flag, str_fail_enemy_spawners )
{
	level endon( str_end_notify );

	a_volumes = GetEntArray( str_info_targetname, "targetname" );
	if( !IsDefined(a_volumes) )
	{
		return;
	}

	while( 1 )
	{
		player_is_safe = false;
		for( i=0; i<a_volumes.size; i++ )
		{
			e_vol = a_volumes[ i ];
			if( level.player IsTouching(e_vol) )
			{
				player_is_safe = true;
			}
		}

		if( (player_is_safe == false) || flag("js_player_fails_stealth") )
		{
			level notify( "kill_in_cover_checks" );

			if( IsDefined(fail_mission_flag) )
			{
				flag_set( fail_mission_flag );
			}

			if( IsDefined(str_fail_enemy_spawners) )
			{
				level thread spawn_in_stealth_failure_guards( str_fail_enemy_spawners );
			}
			
			if( IsDefined(fail_mission_delay) )
			{
				wait( fail_mission_delay );
			}

			missionfailedwrapper( &"ANGOLA_2_PLAYER_COVER_BROKEN_SPOTTED" );
			return;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

kill_player_if_standing_inside_volume( str_volume, str_endon, fail_mission_delay, str_fail_enemy_spawners )
{
	level endon( str_endon );

	e_volume = getent( str_volume, "targetname" );

	while( 1 )
	{
		if( level.player IsTouching(e_volume) )
		{
			if( !is_mason_stealth_crouched() )
			{
				level notify( "kill_in_cover_checks" );

				if( IsDefined(str_fail_enemy_spawners) )
				{
					level thread spawn_in_stealth_failure_guards( str_fail_enemy_spawners );
				}
			
				if( IsDefined(fail_mission_delay) )
				{
					wait( fail_mission_delay );
				}
				
				missionfailedwrapper( &"ANGOLA_2_PLAYER_COVER_BROKEN_SPOTTED" );
				return;
			}
		}
		wait( 0.01 );
	}
}


//*********************************************************************************************
// Fail the mission if the player is not in cover crough
//
// str_endon_notify		- Ends if notify sent
// delay_fail_time		- Time player has to go crouched
// allow_stance_time	- If player breaks crouch, amount of time they are allowed to do it for
// nag_crouch_time		- If defiend, nag player to crouch for this amount of time
//
//*********************************************************************************************

fail_mission_if_not_in_crouch_cover( str_endon_notify, delay_fail_time, allow_stance_time, nag_crouch_time )
{
	level endon( str_endon_notify );
	level endon( "kill_in_cover_checks" );

	start_time = gettime();

	last_crouched_time = start_time;

	nag_additional_time = 0;

	while( 1 )
	{
		time = gettime();

		if( is_mason_stealth_crouched() )
		{
			last_crouched_time = time;
			nag_crouch_time = undefined;
		}
		else
		{
			time_standing = ( time - last_crouched_time ) / 1000;

			// Has the player been standing longer than the minimum time?
			if( time_standing > allow_stance_time )
			{
				dt = ( time - start_time ) / 1000;
				dt -= nag_additional_time;

				if( dt > delay_fail_time )			
				{
					if( IsDefined(nag_crouch_time) )
					{
						if( level.console )
							helper_message( "Mason, press [{+stance}] to crouch now", 5 );
						else
							helper_message( "Mason, press [{+activate}] to crouch now", 5 );
						nag_additional_time = nag_crouch_time;
						nag_crouch_time = undefined;
						continue;
					}
			
					// Stealth has failed, give any soldiers in the area a chance to shoot you
					flag_set( "js_player_fails_stealth" );
					wait( 0.5 );
					
					missionfailedwrapper( &"ANGOLA_2_PLAYER_COVER_BROKEN_CROUCHED" );
					return;
				}
			}
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

spawn_in_stealth_failure_guards( str_fail_enemy_spawners )
{
	a_spawners = getentarray( str_fail_enemy_spawners, "targetname" );
	if( IsDefined( a_spawners) )
	{
		for( i=0; i<a_spawners.size; i++ )
		{
			e_enemy = simple_spawn_single( a_spawners[i] );

			if( IsDefined(a_spawners[i].target) )
			{
				nd_node = getnode( a_spawners[i].target, "targetname" );
			}
			else
			{
				nd_node = undefined;
			}

			e_enemy thread ai_force_fire_at_target( undefined, level.player, undefined, undefined, nd_node );
		}
	}
}


//*****************************************************************************
// self = ent
// str_scene - If defined, end the anim scene
// e_target - defaults to player
// fire_burst - defaults to 0.2
// fire_time - defaults to 10
//*****************************************************************************

ai_force_fire_at_target( str_scene, e_target, fire_burst, fire_time, nd_node )
{
	self endon( "death" );

	if( IsDefined(str_scene) )
	{
		end_scene( str_scene );
	}

	if( !IsDefined(e_target) )
	{
		e_target = level.player;
	}

	if( !IsDefined(fire_burst) )
	{
		fire_burts = 0.2;
	}

	if( !IsDefined(fire_time) )
	{
		fire_time = 10.0;
	}

	self.ignoreall = true;
	self.favoriteenemy = e_target;
	self.script_ignore_suppression = 1;

	self thread aim_at_target( e_target );
	self thread shoot_at_target( e_target, undefined, fire_burst, fire_time );

	if( IsDefined(nd_node) )
	{
		self.goalradius = 64;
		self setgoalnode( nd_node );
	}
}


//*****************************************************************************
//spawn gunner on medium boat for angola 2
//*****************************************************************************
fire_weapon_on_target( target )
{
	self endon("death");
	
	guards_1 = simple_spawn_single("river_barge_convoy_2_guards_assault");
	guards_1 enter_vehicle(self, "tag_gunner1");
//	guards_1 thread magic_bullet_shield();
	guards_1.animname = "chase_boat_gunner_front";
	self maps\_turret::set_turret_target(target, (0, 0, 40), 1);
	
	self.gunner_alive = guards_1;

	while( isalive( self ) )
	{
		if( !isalive(guards_1) )
		{
			self maps\_turret::stop_turret(1);
			wait(10);
			guards_1 = simple_spawn_single("river_barge_convoy_2_guards_assault");
			guards_1 enter_vehicle(self, "tag_gunner1");
			guards_1.animname = "chase_boat_gunner_front";
			self.gunner_alive = guards_1;
			
		}
		
		self thread maps\_turret::fire_turret_for_time( 2, 1);
		wait( 2 );
	}
	
}

play_damage_fx_on_chase_boat()
{
	self endon("death");
	
	self waittill("damage");
	PlayFXOnTag( level._effect[ "small_boat_damage_1" ], self, "tag_origin");
	
	while(1)
	{
		if(self.health < 300)
			break;
		
		wait(0.1);
	}
	
	PlayFXOnTag( level._effect[ "small_boat_damage_2" ], self, "tag_origin");
}

hmg_boat_challenge_tracking()
{
	self waittill("death", attacker);
	
	if( !isdefined( attacker ) )
	{
		return;
	}	
	
	if( attacker == level.player )
	{
		if( level.escort_boat GetSeatOccupant(2) == level.player  )
		{
			if(!isdefined( level.challenge_hmg_boat_destroy) )
			{
				level.challenge_hmg_boat_destroy = 0;	
			}
			level.challenge_hmg_boat_destroy++;			
		}		
	}
}

escort_boat_challenge_tracking()
{
	self waittill("death", attacker);
	
	
	if( !isdefined( attacker ) )
	{
		return;
	}
	
		if(attacker == level.player)
	{
		if(!isdefined( level.challenge_escort_boat_destroy) )
		{
			level.challenge_escort_boat_destroy = 0;	
		}
		level.challenge_escort_boat_destroy++;
	}
	
	
}


//*****************************************************************************
//*****************************************************************************

helper_message( message, delay, str_abort_flag )
{
	if( IsDefined(level.helper_message) )
	{
		screen_message_delete();
	}

	level notify( "kill_helper_message" );
	level endon( "kill_helper_message" );

	level.helper_message = message;

	screen_message_create( message );

	if( !IsDefined(delay) )
	{
		delay = 5;
	}

	start_time = gettime();
	while( 1 )
	{
		time = gettime();
		dt = ( time - start_time ) / 1000;
		if( dt >= delay )
		{
			break;
		}

		if( IsDefined(str_abort_flag) && (flag(str_abort_flag) == true) )
		{
			break;
		}

		wait( 0.01 );
	}
	

	if( IsDefined(level.helper_message) )
	{
		screen_message_delete();
	}

	level.helper_message = undefined;
}


//*****************************************************************************
//*****************************************************************************

switch_to_pistol()
{
	a_weapon_list = level.player GetWeaponsList();
		
	for( i=0; i<a_weapon_list.size; i++ )
	{
		str_class = WeaponClass( a_weapon_list[ i ] );
		if( str_class == "pistol" )
		{
			//IPrintLnBold( "Switching to: " + a_weapon_list[ i ] );
			level.player SwitchToWeapon( a_weapon_list[ i ] );
			return;
		}
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

setup_mason_protect_nag_distances( nag_ent, nag_distance, nag1_time, nag2_time, nag3_time, nag1_message, nag2_message, nag3_message )
{
	level.mason_protect_ent = nag_ent;
	level.mason_protect_dist = nag_distance;
	level.mason_protect_nag1_time = nag1_time;
	level.mason_protect_nag2_time = nag2_time;
	level.mason_protect_nag3_time = nag3_time;
	level.mason_protect_nag1_message = nag1_message;
	level.mason_protect_nag2_message = nag2_message;
	level.mason_protect_nag3_message = nag3_message;
}

mason_protect_nag_think( nag_ent, nag_distance, nag1_time, nag2_time, nag3_time, nag1_message, nag2_message, nag3_message )
{
	level notify( "mason_protect_nag_end" );
	level endon( "mason_protect_nag_end" );

	setup_mason_protect_nag_distances( nag_ent, nag_distance, nag1_time, nag2_time, nag3_time, nag1_message, nag2_message, nag3_message );
		
	safe_time = gettime();

	nag1 = 0;
	nag2 = 0;
	nag3 = 0;
	
	while( 1 )
	{
		time = gettime();

		dist = distance( level.player.origin, level.mason_protect_ent.origin );

		if( dist > level.mason_protect_dist )
		{
			dt = ( time - safe_time ) / 1000;
			if( (nag1 == 0) && (dt > level.mason_protect_nag1_time) )
			{
				nag1 = 1;
				IPrintLnBold( level.mason_protect_nag1_message );
			}
			if( (nag2 == 0) && (dt > level.mason_protect_nag2_time) )
			{
				nag2 = 1;
				IPrintLnBold( level.mason_protect_nag2_message );
			}
			if( (nag3 == 0) && (dt > level.mason_protect_nag3_time) )
			{
				nag3 = 1;
				missionFailedWrapper( level.mason_protect_nag3_message );
				return;
			}
		}
		else
		{
			safe_time = time;
			nag1 = 0;
			nag2 = 0;
			nag3 = 0;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************
// v_start: 
// v_dest:
// speed_scale: <optional>				Changes the speed of the missiles
// height_scale: <optional>				Changes the default height of the missiles
// randomize_target_radius: <optional>	The bigger the value, the less accurate the missile
//*****************************************************************************
//*****************************************************************************

fire_angola_mortar( v_start, v_dest, speed_scale, height_scale, randomize_target_radius )
{
	// Create the missile and make visible with a trail
	e_missile = spawn( "script_model", v_start );
	
	// sb43 - TODO
	//e_missile setModel( "projectile_cbu97_clusterbomb" ); 
	e_missile setmodel( "t6_wpn_mortar_shell_prop_view" );
	
	e_missile playsound( "prj_mortar_launch" );

	PlayFXOnTag( level._effect["smoketrail"], e_missile, "tag_origin" );

	if( isdefined( randomize_target_radius ) )
	{
		dx = RandomFloatRange( -1*randomize_target_radius, randomize_target_radius );
		dy = RandomFloatRange( -1*randomize_target_radius, randomize_target_radius );
		v_dest = v_dest + ( dx, dy, 0 );
	}

	// Set the speed and height of the arc based on the distance to the target
	speed = (42 * 40);
	if( IsDefined(speed_scale) )
	{
		speed = speed * speed_scale;
	}
	
	min_height = 42*3;
	max_height = 42*26;			// 42*26
	height = max_height;

	dz = ( e_missile.origin[2] - v_dest[2] ) / 100;
	height -= ( dz * 16 );
	if( height < min_height )
	{
		height = min_height;
	}

	if( IsDefined(height_scale) )
	{
		height = height * height_scale;
	}
	
	// Fire that misssile
	e_missile thread angola_mortor_move( v_dest, speed, height );
	//e_missile playsound ( "wpn_river_artillery_fire" );
	//e_missile playloopsound( "wpn_river_rocket_loop" );

	// Wait for the Impact		
	e_missile waittill( "mortor_strike" );
		
	// Play Effect
	PlayFX( level._effect["def_explosion"], e_missile.origin );
	
	// (42*18), 35, 5
	RadiusDamage( e_missile.origin, 42*16, 15, 3 );
	
	// 0.6, 1.2, pos, 3000
	Earthquake( 0.6, 1.2, e_missile.origin, 3000 );
		
	e_missile playsound( "exp_mortar" );

	e_missile Delete();

	level notify( "angola_mortar_impact" );
}


//*****************************************************************************
// Fires mortars with arc's throught rhe air at targets
// self = missile/mortar
//*****************************************************************************

angola_mortor_move( target_position, speed, height )
{
	self endon ("death");

	start_position = self.origin;

	start_time = gettime() / 1000;

	// Calculate the distance to travel (in 2d)
	dist_travelled = 0;
	total_dist = (	(self.origin[0]-target_position[0]) * (self.origin[0]-target_position[0]) + 
					(self.origin[1]-target_position[1]) * (self.origin[1]-target_position[1]) + 
					(self.origin[2]-target_position[2]) * (self.origin[2]-target_position[2]));
	total_dist = sqrt( total_dist );

	// Get the 2d direction delta
	dir = vectornormalize( target_position - self.origin );

	// Now we have the direction vector, play the muzzle flash
	// sb43 - TODO
	//PlayFX( level._effect["artillery_muzzle"], self.origin, dir );
 
	// Mortor travels to target
	last_time = start_time;
	last_pos = self.origin;
	
	frac = 0.0;
	last_frac = 0.0;
	audio_incomming_played = 0;
	while( dist_travelled < total_dist )
	{
		wait( 0.01 );
		
		// Get the time delta
		time = gettime() / 1000;
		dt = time - last_time;
		last_time = time;
	
		// Slow down the speed of the missile as we are near the arc of the curve
		slow_start = 0.38;					// 0.38
		slow_mid = 0.55;					// 0.55
		slow_end = 0.75;					// 0.75
		slow_amount = speed * 0.45;			// 0.45
		end_speedup = speed * 3.0;			// 3.0
				
		if( last_frac < slow_start )
		{
			current_speed = speed;
		}
		// Slow down on the way up
		else if( (last_frac >= slow_start) && (last_frac <= slow_mid) )
		{
			mag = slow_mid - slow_start;
			diff_frac = 1.0 - ((slow_mid - last_frac) / mag);
			current_speed = speed - (slow_amount*diff_frac);
		}
		// Start to gain speed back down
		else if( (last_frac > slow_mid) && (last_frac <= slow_end) )
		{
			mag = slow_end - slow_mid;
			diff_frac = (slow_end - last_frac) / mag;
			current_speed = speed - (slow_amount*diff_frac);
		}
		// Last bit really fast
		else
		{
			mag = 1.0 - slow_end;
			diff_frac = 1.0 - ((1.0 - last_frac) / mag);
			current_speed = speed + (end_speedup*diff_frac);
		}
		
		// Get the distance travelled
		inc = dt * current_speed;
	
		// Add the base movement
		add_vec = ( dir[0]*inc, dir[1]*inc, dir[2]*inc );
		
		missile_height = self.origin[2] + dir[2]*inc;
		missile_pos = self.origin + add_vec;
		
		dist_travelled += inc;
	
		last_frac = frac;
		frac = dist_travelled / total_dist;
		if( frac > 1.0 )
		{
			frac = 1.0;
		}
		
		// Sin curves go from 0 to 180 degrees for an arc
		angle = 180 * frac;
		sinx = sin( angle );
		
		height_offset = height * sinx;
			
		base_height = start_position[2] + ((target_position[2]-start_position[2])*frac);
		self.origin = ( missile_pos[0], missile_pos[1], base_height+height_offset );
		
		self.angles = VectorToAngles( self.origin - last_pos ); 
		last_pos = self.origin;
		
		// Check for final audio "woosh"
		if( (!audio_incomming_played) && (frac > 0.8) )
		{
			self playsound( "prj_mortar_incoming" );
			audio_incomming_played = 1;
		}
	}
	
	self notify( "mortor_strike" );	
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

background_soldier_anims_alert_timeout( str_patrol_anim, str_alerted_anim, str_begin_flag, str_end_flag, fail_timeout, alerted_timeout )
{
	flag_wait( str_begin_flag );

	level thread run_scene( str_patrol_anim );
	wait( fail_timeout );
	end_scene( str_patrol_anim );

	if( flag(str_end_flag) == false )
	{
		level thread run_scene( str_alerted_anim );
		wait( alerted_timeout );
		missionfailedwrapper( &"ANGOLA_2_PLAYER_COVER_BROKEN_SPOTTED" );
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

blackscreen(fadein, stay, fadeout)
{
	blackscreen = NewHudElem();
	
	blackscreen.alpha = 0;
	blackscreen.horzAlign = "fullscreen";
	blackscreen.vertAlign = "fullscreen";
	
	blackscreen SetShader( "black", 640, 480 );
	if( fadein > 0 )
	{
		blackscreen fadeOverTime( fadein ); 
	}
	blackscreen.alpha = 1;
	
	wait (stay);
	
	if( fadeout > 0 )
	{
		blackscreen fadeOverTime( fadeout ); 
	}
	blackscreen.alpha = 0;	
	
	blackscreen destroy();
}


//*****************************************************************************
//*****************************************************************************

make_all_enemy_aggressive( follow_player )
{
	a_ai = GetAIArray( "axis" );
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			e_ent = a_ai[ i ];
			e_ent.aggressiveMode = true;

			if( IsDefined(follow_player) && (follow_player == true) )
			{
				e_ent.pathEnemyFightDist = 1000;
				e_ent setgoalentity( level.player );
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

enemy_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if( IsDefined(self.npc_damage_scale) )
	{
		if( IsDefined(e_inflictor) && (e_inflictor != level.player) )
		{
			//IPrintLnBold( "Clearing Damage" );
			n_damage = int(n_damage * self.npc_damage_scale);
		}
	}

	if( IsDefined(e_inflictor) && (e_inflictor == level.player) )
	{
		if( is_player_climbing_tree() )
		{
			if( (self.health - n_damage) <= 0 )
			{
				if( self.health > 0 )
				{
					//iPrintLnBold( "Player Sniper Tree Kill" );
					level notify( "sniper_tree_kill" );
				}
			}
		}
	}

	return( n_damage );
}


// trigger_on that works with linkto
linkto_trigger_on()
{
	self.origin += (0, 0, 10000);
}


linkto_trigger_off()
{
	self.origin += (0, 0, -10000);
}


lookat_trigger_while_not_in_trigger( triggername )
{
	lookat_trigger = getent(triggername, "targetname");
	
	while(1)
	{
		lookat_trigger waittill("trigger");
	
		if( !(level.player IsTouching(lookat_trigger) ) )
		{
			return;	
		}
	
		wait(0.05);
	}
}


//*****************************************************************************
//*****************************************************************************

// self = player
swap_to_primary_weapon( str_use_primary_if_none_exists )
{
	primary_weapons = self GetWeaponsListPrimaries();
	if( IsDefined( primary_weapons ) && primary_weapons.size > 0 )
	{
		self SwitchToWeapon( primary_weapons[0] );
	}
	// If no primaries, give one to the player
	else
	{
		if( IsDefined(str_use_primary_if_none_exists) )
		{
			self GiveWeapon( str_use_primary_if_none_exists );
			self SwitchToWeapon( str_use_primary_if_none_exists );
		}
	}
}

