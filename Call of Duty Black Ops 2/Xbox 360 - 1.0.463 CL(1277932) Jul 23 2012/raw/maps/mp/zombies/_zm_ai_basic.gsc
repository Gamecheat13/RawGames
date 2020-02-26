#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\zombies\_zm_utility.gsh;

#define INERT_WAKEUP_DIST			( 64 * 64 )
#define INERT_WAKEUP_SPRINT_DIST	( 600 * 600 )
#define INERT_WEAPON_FIRED_DIST		( 2400 * 2400 )

//-------------------------------------------------------------------
// the seeker logic for zombies
//-------------------------------------------------------------------
find_flesh()
{
	self endon( "death" ); 
	level endon( "intermission" );
	self endon( "stop_find_flesh" );

	if( level.intermission )
	{
		return;
	}

	self.ai_state = "find_flesh";
	
	self.helitarget = true;
	self.ignoreme = false; // don't let attack dogs give chase until the zombie is in the playable area
	self.noDodgeMove = true; // WW (0107/2011) - script_forcegoal KVP overwites this variable which allows zombies to push the player in laststand

	//PI_CHANGE - 7/2/2009 JV Changing this to an array for the meantime until we get a more substantial fix 
	//for ignoring multiple players - Reenabling change 274916 (from DLC3)
	self.ignore_player = [];

	self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> start" );

	self.goalradius = 32;
	while( 1 )
	{
		zombie_poi = undefined;
		// try to split the zombies up when the bunch up
		// see if a bunch zombies are already near my current target; if there's a bunch
		// and I'm still far enough away, ignore my current target and go after another one
		near_zombies = getaiarray("axis");
		same_enemy_count = 0;
		for (i = 0; i < near_zombies.size; i++)
		{
			if ( isdefined( near_zombies[i] ) && isalive( near_zombies[i] ) )
			{
				if ( isdefined( near_zombies[i].favoriteenemy ) && isdefined( self.favoriteenemy ) 
				&&	near_zombies[i].favoriteenemy == self.favoriteenemy )
				{
					if ( distancesquared( near_zombies[i].origin, self.favoriteenemy.origin ) < 225 * 225 
					&&	 distancesquared( near_zombies[i].origin, self.origin ) > 525 * 525)
					{
						same_enemy_count++;
					}
				}
			}
		}
		
		if (same_enemy_count > 12  ) 
		{
			if(!isDefined(level._should_skip_ignore_player_logic) || ![[level._should_skip_ignore_player_logic]]() )
			{
				self.ignore_player[self.ignore_player.size] = self.favoriteenemy;
			}
		}

		//PI_CHANGE_BEGIN - 6/18/09 JV It was requested that we use the poi functionality to set the "wait" point while all players  
		//are in the process of teleportation. It should not intefere with the monkey.  The way it should work is, if all players are in teleportation,
		//zombies should go and wait at the stage, but if there is a valid player not in teleportation, they should go to him
		if (isDefined(level.zombieTheaterTeleporterSeekLogicFunc) )
		{
       		self [[ level.zombieTheaterTeleporterSeekLogicFunc ]]();
       	}
       	//PI_CHANGE_END

		if( IsDefined( level._poi_override ) )
		{
    		zombie_poi = self [[ level._poi_override ]]();
		}
    
		if( !IsDefined( zombie_poi ) )
		{
    		zombie_poi = self get_zombie_point_of_interest( self.origin );	
		}
		
		players = GET_PLAYERS();
					
		// If playing single player, never ignore the player
		if( !isdefined(self.ignore_player) || (players.size == 1) )
		{
			self.ignore_player = [];
		}
		else if(!isDefined(level._should_skip_ignore_player_logic) || ![[level._should_skip_ignore_player_logic]]() )
		{
			i=0;
			while (i < self.ignore_player.size)
			{
				if( IsDefined( self.ignore_player[i] ) && IsDefined( self.ignore_player[i].ignore_counter ) && self.ignore_player[i].ignore_counter > 3 )
				{
					self.ignore_player[i].ignore_counter = 0;
					self.ignore_player = ArrayRemoveValue( self.ignore_player, self.ignore_player[i] );
					if (!IsDefined(self.ignore_player))
						self.ignore_player = [];
					i=0;
					continue;
				}
				i++;
			}
		}

		player = get_closest_valid_player( self.origin, self.ignore_player );

		if( !isDefined( player ) && !isDefined( zombie_poi ) )
		{
			self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> can't find player, continue" );
			if( IsDefined( self.ignore_player )  )
			{
				if(isDefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]() )
				{
					wait(1);
					continue;
				}			
				self.ignore_player = [];
			}

			wait( 1 ); 
			continue; 
		}
		
		//PI_CHANGE - 7/2/2009 JV Reenabling change 274916 (from DLC3)
		//self.ignore_player = undefined;
		if ( !isDefined( level.check_for_alternate_poi ) || ![[level.check_for_alternate_poi]]() )
		{
			self.enemyoverride = zombie_poi;
			
			self.favoriteenemy = player;
		}
		
		self thread zombie_pathing();
		
		//PI_CHANGE_BEGIN - 7/2/2009 JV Reenabling change 274916 (from DLC3)
		if( players.size > 1 )
		{
			for(i = 0; i < self.ignore_player.size; i++)
			{
				if( IsDefined( self.ignore_player[i] ) )
				{
					if( !IsDefined( self.ignore_player[i].ignore_counter ) )
						self.ignore_player[i].ignore_counter = 0;
					else
						self.ignore_player[i].ignore_counter += 1;
				}
			}
		}
		//PI_CHANGE_END

		self thread attractors_generated_listener();
		if(isDefined(level._zombie_path_timer_override))
		{
			self.zombie_path_timer = [[level._zombie_path_timer_override]]();
		}
		else
		{
			self.zombie_path_timer = GetTime() + ( RandomFloatRange( 1, 3 ) * 1000 );// + path_timer_extension;
		}
		
		while( GetTime() < self.zombie_path_timer ) 
		{
			wait( 0.1 );
		}
		self notify( "path_timer_done" );

		self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> bottom of loop" );

		debug_print( "Zombie is re-acquiring enemy, ending breadcrumb search" );
		self notify( "zombie_acquire_enemy" );
	}
}

//-------------------------------------------------------------------
// setup inert zombies
//-------------------------------------------------------------------
init_inert_zombies()
{
	level init_inert_substates();
}

//-------------------------------------------------------------------
// setup substate lists
//-------------------------------------------------------------------
init_inert_substates()
{
	level.inert_substates = [];
	level.inert_substates[ level.inert_substates.size ] = "inert1";
	level.inert_substates[ level.inert_substates.size ] = "inert2";
	level.inert_substates[ level.inert_substates.size ] = "inert3";
	level.inert_substates[ level.inert_substates.size ] = "inert4";
	level.inert_substates[ level.inert_substates.size ] = "inert5";
	level.inert_substates[ level.inert_substates.size ] = "inert6";
	level.inert_substates[ level.inert_substates.size ] = "inert7";

	level.inert_substates = array_randomize( level.inert_substates );

	level.inert_substate_index = 0;

	level.inert_trans_walk = [];
	level.inert_trans_walk[ level.inert_trans_walk.size ] = "inert_2_walk_1";
	level.inert_trans_walk[ level.inert_trans_walk.size ] = "inert_2_walk_2";
	level.inert_trans_walk[ level.inert_trans_walk.size ] = "inert_2_walk_3";
	level.inert_trans_walk[ level.inert_trans_walk.size ] = "inert_2_walk_4";

	level.inert_trans_run = [];
	level.inert_trans_run[ level.inert_trans_run.size ] = "inert_2_run_1";
	level.inert_trans_run[ level.inert_trans_run.size ] = "inert_2_run_2";

	level.inert_trans_sprint = [];
	level.inert_trans_sprint[ level.inert_trans_sprint.size ] = "inert_2_sprint_1";
	level.inert_trans_sprint[ level.inert_trans_sprint.size ] = "inert_2_sprint_2";

	level.inert_crawl_substates = [];
	level.inert_crawl_substates[ level.inert_crawl_substates.size ] = "inert1";
	level.inert_crawl_substates[ level.inert_crawl_substates.size ] = "inert2";
	level.inert_crawl_substates[ level.inert_crawl_substates.size ] = "inert3";
	level.inert_crawl_substates[ level.inert_crawl_substates.size ] = "inert4";
	level.inert_crawl_substates[ level.inert_crawl_substates.size ] = "inert5";
	level.inert_crawl_substates[ level.inert_crawl_substates.size ] = "inert6";
	level.inert_crawl_substates[ level.inert_crawl_substates.size ] = "inert7";

	level.inert_crawl_trans_walk = [];
	level.inert_crawl_trans_walk[ level.inert_crawl_trans_walk.size ] = "inert_2_walk_1";

	level.inert_crawl_trans_run = [];
	level.inert_crawl_trans_run[ level.inert_crawl_trans_run.size ] = "inert_2_run_1";
	level.inert_crawl_trans_run[ level.inert_crawl_trans_run.size ] = "inert_2_run_2";

	level.inert_crawl_trans_sprint = [];
	level.inert_crawl_trans_sprint[ level.inert_crawl_trans_sprint.size ] = "inert_2_sprint_1";
	level.inert_crawl_trans_sprint[ level.inert_crawl_trans_sprint.size ] = "inert_2_sprint_2";

	level.inert_crawl_substates = array_randomize( level.inert_crawl_substates );

	level.inert_crawl_substate_index = 0;
}

//-------------------------------------------------------------------
// returns the next substate in the list
//-------------------------------------------------------------------
get_inert_substate()
{
	substate = level.inert_substates[ level.inert_substate_index ];
	
	level.inert_substate_index++;
	if ( level.inert_substate_index >= level.inert_substates.size )
	{
		level.inert_substates = array_randomize( level.inert_substates );
		level.inert_substate_index = 0;
	}

	return substate;
}

//-------------------------------------------------------------------
// returns the next crawl substate in the list
//-------------------------------------------------------------------
get_inert_crawl_substate()
{
	substate = level.inert_crawl_substates[ level.inert_crawl_substate_index ];
	
	level.inert_crawl_substate_index++;
	if ( level.inert_crawl_substate_index >= level.inert_crawl_substates.size )
	{
		level.inert_crawl_substates = array_randomize( level.inert_crawl_substates );
		level.inert_crawl_substate_index = 0;
	}

	return substate;
}

//-------------------------------------------------------------------
// put zombie into inert state
//-------------------------------------------------------------------
start_inert( in_place )
{
	self endon( "death" );

	if ( is_true( self.is_inert ) )
	{
		self maps\mp\zombies\_zm_spawner::zombie_history( "is_inert already set " + GetTime() );
		return;
	}

	self.is_inert = true;
	self maps\mp\zombies\_zm_spawner::zombie_eye_glow_stop();

	self maps\mp\zombies\_zm_spawner::zombie_history( "is_inert set " + GetTime() );
	self playsound( "zmb_zombie_go_inert" );

	// going to tear down boards
	if ( isdefined( self.ai_state ) && self.ai_state == "zombie_goto_entrance" )
	{
		self notify( "stop_zombie_goto_entrance" );
		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
	}

	// already in find flesh
	if ( is_true( self.completed_emerging_into_playable_area ) )
	{
		self notify( "stop_find_flesh" );
		self notify( "zombie_acquire_enemy" );
	}

	// wait for risers to finish
	if ( is_true( self.in_the_ground ) )
	{
		self waittill( "risen", find_flesh_struct_string );

		if ( self maps\mp\zombies\_zm_spawner::should_skip_teardown( find_flesh_struct_string ) )
		{
			self waittill( "completed_emerging_into_playable_area" );

			self notify( "stop_find_flesh" );
			self notify( "zombie_acquire_enemy" );
		}
	}

	// doing a traversal
	if ( is_true( self.is_traversing ) )
	{
		while ( self IsInScriptedState() )
		{
			wait_network_frame();
		}

		if ( !is_true( self.completed_emerging_into_playable_area ) )
		{
			self waittill( "completed_emerging_into_playable_area" );

			while ( 1 )
			{
				if ( self.ai_state == "find_flesh" )
				{
					break;
				}
				wait_network_frame();
			}
			
			self notify( "stop_find_flesh" );
			self notify( "zombie_acquire_enemy" );
		}
	}

	self inert_think( in_place );
}

//-------------------------------------------------------------------
// zombies just idle and wait for players to make noise or get close
//-------------------------------------------------------------------
inert_think( in_place )
{
	self endon( "death" );

	self.ignoreall = true;

	if ( self.has_legs )
	{
		if ( is_true( in_place ) )
		{
			if ( RandomInt( 100 ) > 50 )
			{
				self SetAnimStateFromASD( "zm_inert", "inert1" );
			}
			else
			{
				self SetAnimStateFromASD( "zm_inert", "inert2" );
			}
		}
		else
		{
			self SetAnimStateFromASD( "zm_inert", get_inert_substate() );
			self maps\mp\zombies\_zm_spawner::zombie_history( "zm_inert ASD " + GetTime() );
		}
	}
	else
	{
		self SetAnimStateFromASD( "zm_inert_crawl", get_inert_crawl_substate() );
		self maps\mp\zombies\_zm_spawner::zombie_history( "zm_inert_crawl ASD " + GetTime() );
	}

	self thread inert_wakeup();

	self waittill( "stop_zombie_inert" );
	self maps\mp\zombies\_zm_spawner::zombie_history( "stop_zombie_inert " + GetTime() );

	self inert_transition();
	
	self playsound( "zmb_zombie_end_inert" );

	self maps\mp\zombies\_zm_spawner::zombie_history( "inert transition done" );

	if ( isdefined( self.ai_state ) && self.ai_state == "zombie_goto_entrance" )
	{
		self thread maps\mp\zombies\_zm_spawner::zombie_goto_entrance( self.first_node );
	}

	if ( is_true( self.completed_emerging_into_playable_area ) )
	{
		self.ignoreall = false;
		self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
	}

	self.is_inert = undefined;
	self.needs_run_update = true;
	self maps\mp\zombies\_zm_spawner::zombie_history( "is_inert cleared " + GetTime() );
}

//-------------------------------------------------------------------
// wakeup conditions
//-------------------------------------------------------------------
inert_wakeup()
{
	self endon( "death" );
	self endon( "stop_zombie_inert" );

	wait_network_frame();

	self thread inert_damage();
	
	while ( 1 )
	{
		current_time = GetTime();

		players = GET_PLAYERS();
		foreach( player in players )
		{
			dist_sq = DistanceSquared( self.origin, player.origin );
			if ( dist_sq < INERT_WAKEUP_DIST )
			{
				self stop_inert();
				return;
			}

			if ( dist_sq < INERT_WAKEUP_SPRINT_DIST )
			{
				if ( player IsSprinting() )
				{
					self stop_inert();
					return;
				}
			}

			if ( dist_sq < INERT_WEAPON_FIRED_DIST )
			{
				if ( ( current_time - player.lastFireTime ) < 100 )
				{
					self stop_inert();
					return;
				}
			}
		}

		wait_network_frame();
	}
}

//-------------------------------------------------------------------
// zombie took damage
//-------------------------------------------------------------------
inert_damage()
{
	self endon( "death" );
	self endon( "stop_zombie_inert" );

	while ( 1 )
	{
		self waittill( "damage", amount, inflictor, direction, point, type, tagName, modelName, partname, weaponName, iDFlags );

		if ( weaponName == "emp_grenade_zm" )
		{
			continue;
		}
		
		if ( isdefined( inflictor ) )
		{
			if ( isdefined( inflictor._trap_type ) && inflictor._trap_type == "fire" )
			{
				continue;
			}
		}
	}

	self stop_inert();
}

//-------------------------------------------------------------------
// resume pursuing the player
//-------------------------------------------------------------------
stop_inert()
{
	self notify( "stop_zombie_inert" );
}

//-------------------------------------------------------------------
// play a transition anim based on speed
//-------------------------------------------------------------------
inert_transition()
{
	self endon( "death" );

	trans_num = 4;
	trans_set = level.inert_trans_walk;
	animstate = "zm_inert_trans";

	if ( !self.has_legs )
	{
		trans_num = 1;
		trans_set = level.inert_crawl_trans_walk;
		animstate = "zm_inert_crawl_trans";
	}

	if ( self.zombie_move_speed == "run" )
	{
		if ( self.has_legs )
		{
			trans_set = level.inert_trans_run;
		}
		else
		{
			trans_set = level.inert_crawl_trans_run;
		}
		trans_num = 2;
	}
	else if ( self.zombie_move_speed == "sprint" )
	{
		if ( self.has_legs )
		{
			trans_set = level.inert_trans_sprint;
		}
		else
		{
			trans_set = level.inert_crawl_trans_sprint;
		}
		trans_num = 2;
	}

	self SetAnimStateFromASD( animstate, trans_set[ RandomInt( trans_num ) ] );
	self maps\mp\zombies\_zm_spawner::zombie_history( "inert_trans_anim " + GetTime() );
	maps\mp\animscripts\zm_shared::DoNoteTracks( "inert_trans_anim" );

	self maps\mp\zombies\_zm_spawner::zombie_eye_glow();
}
