
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\angola_2_util;


#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
//*****************************************************************************
//
// NOTES: 
//
// There are multiple ways an AI can break out of stealth:-
//	- An AI sees the player and breaks stealth
//	- The player fires and alerts the AI
//	- The bear trap is used to snare in an AI
//
// Use level notify( "reset_patrol" ) to turn off the patrol system
// 
// Call player_start_stealth_battle() to turn on the patrol mechanic
//	- In conjunction with the spawn function spawn_fn_ai_jungle_patrol() to put guys in patrol
//
//


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

player_start_stealth_battle()
{
	level endon( "player_position_located" );
	level endon( "reset_patrol" );

	level thread monitor_player_stealth_state();

	level thread patrol_check_for_player_firing();

	level.player.stealth_num_times_player_seen = 0;
	level.player.stealth_visible_dot = 0.7;					// 0.75
	level.player.ground_visible_distance = 1000;			// 1400
	level.player.stealth_visible_distance = level.player.ground_visible_distance;

	level.stealth_spotted_time_scale = 1.0;

	while( 1 )
	{
		if( IsDefined(level.player.climbing_tree) )
		{
			level.player.stealth_visible_distance = 60;	
		}
		else
		{
			level.player.stealth_visible_distance = level.player.ground_visible_distance;
		}
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

patrol_set_ground_visibility_distance( new_distance )
{
	level.player.ground_visible_distance = new_distance;
}


//*****************************************************************************
//*****************************************************************************

monitor_player_stealth_state()
{
	level endon( "reset_patrol" );

	level.player.stealth_cover_broken = false;
	level waittill( "player_position_located" );
	level.player.stealth_cover_broken = true;
}


//*****************************************************************************
//*****************************************************************************

is_player_in_stealth_mode()
{
	if( IsDefined(level.player.stealth_cover_broken) && (level.player.stealth_cover_broken==false) )
	{
		return( 1 );
	}

	return( 0 );
}


//*****************************************************************************
// ENTITY PRPERTIES:-
//	script_string = path_start_targetname
//	script_int = percentage chance a patrolling guard will stop at a node
//	script_noteworthy = a way to override the locomotion animation ("walk", "run")
//
// NODE PROPERTIES:-
//	target = next node in the path
//	script_noteworthy = targetname of a potential path branch
// 
//*****************************************************************************

spawn_fn_ai_jungle_patrol( player_favourate_enemy, str_category, ignore_surpression, attack_player_if_located, kill_if_path_ends )
{
	if( !is_player_in_stealth_mode() )
	{
		self entity_common_spawn_setup( player_favourate_enemy, str_category, ignore_surpression, false );
		self.goalradius = 2048;
		return;
	}
	
	self endon( "death" );
	level endon( "player_position_located" );
	
	self entity_common_spawn_setup( player_favourate_enemy, str_category, ignore_surpression, false );

	self.attack_player_if_located = attack_player_if_located;

	self thread patrol_search_for_player();
	self thread ai_patrol_return_to_combat();
	
	self.animname = "misc_patrol";

	// Check for locomotion animation override
	if( IsDefined(self.script_noteworthy) && (self.script_noteworthy == "walk") )
	{
		self change_movemode( "cqb_walk" );
	}
	else
	{
		self set_run_anim( "walk" );
	}
		
	nd_node = getnode( self.script_string, "targetname" );
	self.goalradius = 48;
	self waittill( "goal" );
	
	self.target = undefined;
	self.disable_node_arrivals = false;

	change_route_frac = 40;
	
	if( IsDefined(self.script_int) )
	{
		change_arrivals_anim_frac = self.script_int;
	}
	else
	{
		change_arrivals_anim_frac = 60;
	}
	
	min_node_wait_time = 1.0;
	max_node_wait_time = 3.5;

	while( IsDefined(nd_node.target) )
	{
		// Get the next node in the path
		// If the node has defiend "script_noteworthy" its a potential path alternative route
		str_next_node_name = nd_node.target;
		if( IsDefined(nd_node.script_noteworthy) )
		{
			if( randomfloatrange( 0, 100 ) <= change_route_frac )
			{
				str_next_node_name = nd_node.script_noteworthy;
			}
		}
		
		nd_node = getnode( str_next_node_name, "targetname" );
		self.goalradius = 48;
		self setgoalpos( nd_node.origin );

		self update_node_arrivals( change_arrivals_anim_frac );

		self waittill( "goal" );

		// If the node has the script_string "" then break out of patrol and go into combat
		if( IsDefined(nd_node.script_string) && (nd_node.script_string == "break_patrol") )
		{
			level notify( "player_position_located" );		
		}

		if( self.disable_node_arrivals == false )
		{
			delay = randomfloatrange( min_node_wait_time, max_node_wait_time );
			wait( delay );
		}
	}

	// OK, the path has ended
	// We either kill the guy or break stealth

	if( IsDefined(kill_if_path_ends) && (kill_if_path_ends == true) )
	{
		self delete();
		return;
	}

	level notify( "player_position_located" );
	
	self.goalradius = 2048;
}

update_node_arrivals( disable_frac )
{
	// If arrivals are disabled, always turn them back on
	if( self.disable_node_arrivals == false )
	{
		self.disable_node_arrivals = true;
	}
	else
	{
		frac = randomfloatrange( 0, 100 );
		if( frac <= disable_frac )
		{
			self.disable_node_arrivals = false;
		}
	}

	self ai_set_node_approach_anims( self.disable_node_arrivals );
}


ai_set_node_approach_anims( active )
{
	self.disablearrivals = active;
	self.disableExits = active;
	self.disableTurns = active;
}


//*****************************************************************************
// self = ai
//*****************************************************************************

patrol_search_for_player()
{
	self endon( "death" );
	self endon( "kill_patrol" );
	level endon( "player_position_located" );
	level endon( "reset_patrol" );
	
	self.ignoreall = true;

	self.can_see_player_start_time = undefined;

	while( 1 )
	{
		str_message = undefined;

		//IPrintLnBold( "Patrolling" );

		// Are we in player range?
		dist_to_player = distance( level.player.origin, self.origin );

		if( dist_to_player < level.player.stealth_visible_distance )
		{
			str_message = "Player Behind Me: " + dist_to_player;

			// Is the AI looking in the direction of the player?
			v_ai_forward = anglestoforward( self.angles );
			v_dir_to_player = VectorNormalize( level.player.origin - self.origin );
			dot = vectordot( v_ai_forward, v_dir_to_player );
			if( dot > level.player.stealth_visible_dot )
			{
				// Do a ray cast to see if we can see the player
				up = anglestoup( (0, 90, 0) );
				v_start = self.origin + (up * 60);
				v_end = level.player GetEye();
				trace = BulletTrace( v_start, v_end, false, self );
				if( trace["fraction"] == 1 )
				{
					str_message = "Looking at Player: " + dist_to_player;
					if( !IsDefined(self.can_see_player_start_time) )
					{
						self.can_see_player_start_time = gettime();
						level.player.stealth_num_times_player_seen++;
					}
				}
				else
				{
					str_message = "Player Hidden: " + dist_to_player;
					self.can_see_player_start_time = undefined;
				}
			}
		}
		else
		{
			str_message = "OUT OF RANGE";
			self.can_see_player_start_time = undefined;
		}
		
		if( IsDefined(str_message) )
		{
			//IPrintLnBold( str_message );
		}

		// Is the AI looking at the player?
		if( IsDefined(self.can_see_player_start_time) )
		{
			time = gettime();
			alerted_time = ( time - self.can_see_player_start_time ) / 1000;

			// Set the amount of time the player should stay in LOS before being detected
			if( level.player.stealth_num_times_player_seen == 1 )
			{
				can_see_player_time = 2.0;	// 3.0
			}
			else if ( level.player.stealth_num_times_player_seen == 2 )
			{
				can_see_player_time = 1.5;
			}
			else
			{
				can_see_player_time = 1.25;
			}

			can_see_player_time = can_see_player_time * level.stealth_spotted_time_scale;

			if( alerted_time > can_see_player_time )
			{
				// If I detect the player, should I attack him directly?
				if( IsDefined(self.attack_player_if_located) && (self.attack_player_if_located == true) )
				{
					self thread aim_at_target( level.player );
					self thread shoot_at_target( level.player );
				}

				level notify( "player_position_located" );

				return;
			}
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

patrol_check_for_player_firing()
{
	level endon( "player_position_located" );
	level endon( "patrol_dont_check_player_fire" );
	level endon( "reset_patrol" );

	level.player thread fire_grenade_watch();

	// Check for the player firing a weapn that could alert the player
	while( 1 )
	{
		// Wait for the player to fire a weapon
		level.player waittill( "weapon_fired" );

		// If the weapon fired was the brar trap, don't alery the enemy
		str_current_weapon = level.player GetCurrentWeapon(); 
		if( str_current_weapon != "beartrap_sp" )
		{
			break;
		}
	}
	
	patrol_alerted_find_player_quickly( 10, 0.5 );
}


//*****************************************************************************
// Break patrol if a grenade is fired
//*****************************************************************************

// self = player
fire_grenade_watch()
{
	level endon( "reset_patrol" );

	while( 1 )
	{
		self waittill ( "grenade_fire", grenade, weapon_name );
		if( IsDefined(weapon_name) )
		{
			//iprintlnbold( "weaponName: " + weapon_name);
			if( weapon_name != "beartrap_sp" )
			{
				patrol_alerted_find_player_quickly( 5, 0.5 );
				return;
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

patrol_alerted_find_player_quickly( tree_search_time, ground_search_time )
{
	level endon( "player_position_located" );

	// If Patrol alerted, no need to do this
	if( !is_player_in_stealth_mode() )
	{
		return;
	}

	// If the player has climbed a tree
	// The solider takes a bit to locate the player
	if( IsDefined(level.player.climbing_tree) )
	{
		a_enemies = GetAiArray( "axis" );
		for( i=0; i<a_enemies.size; i++ )
		{
			a_enemies[i].animname = "alerted_patrol";
			a_enemies[i] set_run_anim( "walk" );
		}
		wait( tree_search_time );
	}

	// If the player is at ground level
	// The ai is located almost immediately
	else
	{
		wait( ground_search_time );
	}

	level notify( "player_position_located" );
}


//*****************************************************************************
// self = ai
//*****************************************************************************

ai_patrol_return_to_combat()
{
	self endon( "death" );
	self endon( "kill_patrol" );
	
	level waittill( "player_position_located" );

	// Wait for the stealth threads to get killed off
	wait( 0.1 );

	self.ignoreall = false;
	self.goalradius = 2048;
	self clear_run_anim();
}


//*****************************************************************************
//*****************************************************************************

player_climbs_tree_confuses_ai()
{
	if( !is_player_in_stealth_mode() )
	{
		a_enemies = GetAiArray( "axis" );
		for( i=0; i<a_enemies.size; i++ )
		{
			a_enemies[i] thread temp_confuse_ai_by_tree_climb( randomfloatrange(8.0, 9.0) );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

// self = ai
temp_confuse_ai_by_tree_climb( delay_time )
{
	self endon( "death" );

	self.ignoreall = true;

	self.animname = "alerted_patrol";
	self set_run_anim( "walk" );

	wait( delay_time );

	self.ignoreall = false;
	self.goalradius = 2048;
	self clear_run_anim();
	
}


//*****************************************************************************
//*****************************************************************************
// This function can be use to setup a mini stealth encounter
//*****************************************************************************
//*****************************************************************************

setup_stealth_event( str_save_name, str_patrol_spawner_targetname, str_category, kill_guy_if_path_ends, fail_mission_if_stealth_broken )
{
	level notify( "reset_patrol" );

	level thread player_start_stealth_event( str_save_name );
	wait( 0.01 );

	a_spawners = getentarray( str_patrol_spawner_targetname, "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, maps\angola_stealth::spawn_fn_ai_jungle_patrol, false, str_category, false, true, kill_guy_if_path_ends );
	}

	if( IsDefined(fail_mission_if_stealth_broken) && (fail_mission_if_stealth_broken == true))
	{
		player_fails_mission_if_stealth_broken( 1 );
	}
}

//*****************************************************************************
//*****************************************************************************

player_start_stealth_event( str_stealth_name )
{
	if( IsDefined( str_stealth_name) )
	{
		autosave_by_name( str_stealth_name );
	}
	maps\angola_stealth::player_start_stealth_battle();
}


//*****************************************************************************
// 1.0 = default spotted timeing values
//*****************************************************************************

player_stealth_override_spotted_params( time_scale, vis_dot )
{
	level.stealth_spotted_time_scale = time_scale;

	if( IsDefined(vis_dot) )
	{
		level.player.stealth_visible_dot = vis_dot;
	}
}


//*****************************************************************************
//*****************************************************************************

player_fails_mission_if_stealth_broken( delay )
{
	level endon( "reset_patrol" );

	level waittill( "player_position_located" );

	wait( delay );

	missionfailedwrapper( &"ANGOLA_2_PLAYER_COVER_BROKEN_SPOTTED" );
}

