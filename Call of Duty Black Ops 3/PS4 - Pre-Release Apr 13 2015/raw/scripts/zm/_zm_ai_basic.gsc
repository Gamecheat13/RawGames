#using scripts\codescripts\struct;

#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_behavior;

                                                                                                                               








	
#namespace zm_ai_basic;

//-------------------------------------------------------------------
// the seeker logic for zombies
//-------------------------------------------------------------------
function find_flesh()
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

	self zm_spawner::zombie_history( "find flesh -> start" );

	self.goalradius = 32;
	if( IsDefined( self.custom_goalradius_override ) )
	{
		self.goalradius = self.custom_goalradius_override;
	}
	
	while( 1 )
	{
		if ( zm_behavior::zombieShouldMoveAwayCondition( self ) )
		{
			{wait(.05);};
			continue;
		}
		zombie_poi = undefined;
		// try to split the zombies up when the bunch up
		// see if a bunch zombies are already near my current target; if there's a bunch
		// and I'm still far enough away, ignore my current target and go after another one
		/*
		near_zombies = GetAiTeamArray( level.zombie_team );
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
		*/

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
    		zombie_poi = self zm_utility::get_zombie_point_of_interest( self.origin );	
		}
		
		players = GetPlayers();
					
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

		player = zm_utility::get_closest_valid_player( self.origin, self.ignore_player );

		if( !isDefined( player ) && !isDefined( zombie_poi ) )
		{
			self zm_spawner::zombie_history( "find flesh -> can't find player, continue" );
			if( IsDefined( self.ignore_player )  )
			{
				if(isDefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]() )
				{
					wait(1);
					continue;
				}			
				self.ignore_player = [];
			}

			self SetGoal( self.origin );

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
		
		self thread zm_spawner::zombie_pathing();
		
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

		self thread zm_spawner::attractors_generated_listener();
		if(isDefined(level._zombie_path_timer_override))
		{
			self.zombie_path_timer = [[level._zombie_path_timer_override]]();
		}
		else
		{
			self.zombie_path_timer = GetTime() + ( RandomFloatRange( 1, 3 ) * 1000 );// + path_timer_extension;
		}
		
		zombie_path_timer = self.zombie_path_timer;
		
		while( GetTime() < zombie_path_timer )
		{
			wait( 0.1 );
		}
		self notify( "path_timer_done" );

		self zm_spawner::zombie_history( "find flesh -> bottom of loop" );

		zm_utility::debug_print( "Zombie is re-acquiring enemy, ending breadcrumb search" );
		self notify( "zombie_acquire_enemy" );
	}
}

//-------------------------------------------------------------------
// setup inert zombies
//-------------------------------------------------------------------
function init_inert_zombies()
{
	level init_inert_substates();
}

//-------------------------------------------------------------------
// setup substate lists
//-------------------------------------------------------------------
function init_inert_substates()
{
	level.inert_substates = [];
	level.inert_substates[ level.inert_substates.size ] = "inert1";
	level.inert_substates[ level.inert_substates.size ] = "inert2";
	level.inert_substates[ level.inert_substates.size ] = "inert3";
	level.inert_substates[ level.inert_substates.size ] = "inert4";
	level.inert_substates[ level.inert_substates.size ] = "inert5";
	level.inert_substates[ level.inert_substates.size ] = "inert6";
	level.inert_substates[ level.inert_substates.size ] = "inert7";

	level.inert_substates = array::randomize( level.inert_substates );

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

	level.inert_crawl_substates = array::randomize( level.inert_crawl_substates );

	level.inert_crawl_substate_index = 0;
}

//-------------------------------------------------------------------
// returns the next substate in the list
//-------------------------------------------------------------------
function get_inert_substate()
{
	substate = level.inert_substates[ level.inert_substate_index ];
	
	level.inert_substate_index++;
	if ( level.inert_substate_index >= level.inert_substates.size )
	{
		level.inert_substates = array::randomize( level.inert_substates );
		level.inert_substate_index = 0;
	}

	return substate;
}

//-------------------------------------------------------------------
// returns the next crawl substate in the list
//-------------------------------------------------------------------
function get_inert_crawl_substate()
{
	substate = level.inert_crawl_substates[ level.inert_crawl_substate_index ];
	
	level.inert_crawl_substate_index++;
	if ( level.inert_crawl_substate_index >= level.inert_crawl_substates.size )
	{
		level.inert_crawl_substates = array::randomize( level.inert_crawl_substates );
		level.inert_crawl_substate_index = 0;
	}

	return substate;
}

//-------------------------------------------------------------------
// put zombie into inert state
//-------------------------------------------------------------------
function start_inert( in_place )
{
	self endon( "death" );

	if ( ( isdefined( self.is_inert ) && self.is_inert ) )
	{
		self zm_spawner::zombie_history( "is_inert already set " + GetTime() );
		return;
	}

	self.is_inert = true;
	self notify( "start_inert" );
	self zombie_utility::zombie_eye_glow_stop();

	self zm_spawner::zombie_history( "is_inert set " + GetTime() );
	self playsound( "zmb_zombie_go_inert" );

	// entering through a barricade
	if ( ( isdefined( self.barricade_enter ) && self.barricade_enter ) )
	{
		while ( ( isdefined( self.barricade_enter ) && self.barricade_enter ) )
		{
			wait( 0.1 );
		}
	}
	else if ( isdefined( self.ai_state ) && self.ai_state == "zombie_goto_entrance" )	// going to tear down boards
	{
		self notify( "stop_zombie_goto_entrance" );
		self zombie_utility::reset_attack_spot();
	}

	// already in find flesh
	if ( ( isdefined( self.completed_emerging_into_playable_area ) && self.completed_emerging_into_playable_area ) )
	{
		self notify( "stop_find_flesh" );
		self notify( "zombie_acquire_enemy" );
	}
	else
	{
		in_place = true;
	}

	// wait for risers to finish
	if ( ( isdefined( self.in_the_ground ) && self.in_the_ground ) )
	{
		self waittill( "risen", find_flesh_struct_string );

		if ( self zm_spawner::should_skip_teardown( find_flesh_struct_string ) )
		{
			if ( !( isdefined( self.completed_emerging_into_playable_area ) && self.completed_emerging_into_playable_area ) )
			{
				self waittill( "completed_emerging_into_playable_area" );
			}

			self notify( "stop_find_flesh" );
			self notify( "zombie_acquire_enemy" );
		}
	}

	// doing a traversal
	if ( ( isdefined( self.is_traversing ) && self.is_traversing ) )
	{
		/*
			iprintln( "EMP during traversal" );
		*/
		while ( self IsInScriptedState() )
		{
			wait( 0.1 );
		}
	}

	if ( ( isdefined( self.doing_equipment_attack ) && self.doing_equipment_attack ) )
	{
		self StopAnimScripted();
	}

	if ( isdefined( self.inert_delay ) )
	{
		self [[ self.inert_delay ]]();
		self zm_spawner::zombie_history( "inert_delay done " + GetTime() );
	}

	self inert_think( in_place );
}

//-------------------------------------------------------------------
// zombies just idle and wait for players to make noise or get close
//-------------------------------------------------------------------
function inert_think( in_place )
{
	self endon( "death" );

	self.ignoreall = true;

	self AnimMode( "normal" );

	if ( !self.missingLegs )
	{
		if ( ( isdefined( in_place ) && in_place ) )
		{
			self SetGoal( self.origin );
			if ( RandomInt( 100 ) > 50 )
			{
				self zm_spawner::zombie_history( "inert 1 " + GetTime() );
				self SetAnimStateFromASD( "zm_inert", "inert1" );
			}
			else
			{
				self zm_spawner::zombie_history( "inert 2 " + GetTime() );
				self SetAnimStateFromASD( "zm_inert", "inert2" );
			}
			self.in_place = true;
		}
		else
		{
			substate = get_inert_substate();
			if ( isdefined( level.inert_substate_override ) )
			{
				substate = self [[ level.inert_substate_override ]]( substate );
			}
			self SetAnimStateFromASD( "zm_inert", substate );
			self zm_spawner::zombie_history( "zm_inert ASD " + GetTime() );
			if ( substate == "inert3" || substate == "inert4" || substate == "inert5" || substate == "inert6" )
			{
				self thread inert_watch_goal();
			}
			else
			{
				self.in_place = true;
			}
		}
	}
	else
	{
		self SetAnimStateFromASD( "zm_inert_crawl", get_inert_crawl_substate() );
		self zm_spawner::zombie_history( "zm_inert_crawl ASD " + GetTime() );
	}

	self thread inert_wakeup();

	self waittill( "stop_zombie_inert" );
	self zm_spawner::zombie_history( "stop_zombie_inert " + GetTime() );
	
	self playsound( "zmb_zombie_end_inert" );
	self inert_transition();

	self zm_spawner::zombie_history( "inert transition done" );

	if ( isdefined( self.ai_state ) && self.ai_state == "zombie_goto_entrance" )
	{
		self thread zm_spawner::zombie_goto_entrance( self.first_node );
	}

	if ( isdefined( self.inert_wakeup_override ) )
	{
		self [[ self.inert_wakeup_override ]]();
	}
	else if ( ( isdefined( self.completed_emerging_into_playable_area ) && self.completed_emerging_into_playable_area ) )
	{
		self.ignoreall = false;

		if ( isdefined( level.ignore_find_flesh ) && !self [[ level.ignore_find_flesh ]]() )
		{
			self thread zm_ai_basic::find_flesh();
		}
	}

	self.becoming_inert = undefined;
	self.is_inert = undefined;
	self.in_place = undefined;
	self zm_spawner::zombie_history( "is_inert cleared " + GetTime() );
}

function inert_watch_goal()
{
	self endon( "death" );
	self endon( "stop_zombie_inert" );

	while ( 1 )
	{
		self waittill( "goal" );

		locs = array::randomize( level.enemy_dog_locations );
		foreach ( loc in locs )
		{
			dist_sq = DistanceSquared( self.origin, loc.origin );
			if ( dist_sq > ( 300 * 300 ) )
			{
				/*
					iprintln( "inert got to goal, pick new one" );
				*/
				self SetGoal( loc.origin );
				continue;
			}
		}

		if ( locs.size > 0 )
		{
			/*
				iprintln( "inert got to goal, none far enough" );
			*/
			self SetGoal( locs[0].origin );
		}
	}
}

//-------------------------------------------------------------------
// wakeup conditions
//-------------------------------------------------------------------
function inert_wakeup()
{
	self endon( "death" );
	self endon( "stop_zombie_inert" );

	wait( 0.1 );

	self thread inert_damage();
	self thread inert_bump();
	
	while ( 1 )
	{
		current_time = GetTime();

		players = GetPlayers();
		foreach( player in players )
		{
			dist_sq = DistanceSquared( self.origin, player.origin );
			if ( dist_sq < ( 64 * 64 ) )
			{
				self stop_inert();
				return;
			}

			if ( dist_sq < ( 600 * 600 ) )
			{
				if ( player IsSprinting() )
				{
					self stop_inert();
					return;
				}
			}

			if ( dist_sq < ( 2400 * 2400 ) )
			{
				if ( ( current_time - player.lastFireTime ) < 100 )
				{
					self stop_inert();
					return;
				}
			}
		}	

		wait( 0.1 );
	}
}

function inert_bump()
{
	self endon( "death" );
	self endon( "stop_zombie_inert" );

	while ( 1 )
	{
		zombies = GetAiTeamArray( level.zombie_team );
		foreach( zombie in zombies )
		{
			if ( zombie == self )
			{
				continue;
			}

			if ( ( isdefined( zombie.is_inert ) && zombie.is_inert ) )
			{
				continue;
			}

			if ( ( isdefined( zombie.becoming_inert ) && zombie.becoming_inert ) )
			{
				continue;
			}

			dist_sq = DistanceSquared( self.origin, zombie.origin );
			if ( dist_sq < ( 36 * 36 ) )
			{
				self stop_inert();
				return;
			}
		}

		wait( 0.2 );
	}
}

//-------------------------------------------------------------------
// zombie took damage
//-------------------------------------------------------------------
function inert_damage()
{
	self endon( "death" );
	self endon( "stop_zombie_inert" );

	while ( 1 )
	{
		self waittill( "damage", amount, inflictor, direction, point, type, tagName, modelName, partname, weapon, iDFlags );

		if ( weapon.isEmp )
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
// grenade exploded near zombie
//-------------------------------------------------------------------
function grenade_watcher( grenade )
{
	grenade waittill( "explode", grenade_origin );

	zombies = array::get_all_closest( grenade_origin, zombie_utility::get_round_enemy_array(), undefined, undefined, ( 2400 ) );
	if ( !isDefined( zombies ) )
	{
		return;
	}	

	foreach( zombie in zombies )
	{
		zombie stop_inert();
	}
}

//-------------------------------------------------------------------
// resume pursuing the player
//-------------------------------------------------------------------
function stop_inert()
{
	self notify( "stop_zombie_inert" );
}

//-------------------------------------------------------------------
// play a transition anim based on speed
//-------------------------------------------------------------------
function inert_transition()
{
	self endon( "death" );
	self endon( "stop_zombie_inert_transition" );

	trans_num = 4;
	trans_set = level.inert_trans_walk;
	animstate = "zm_inert_trans";

	if ( self.missingLegs )
	{
		trans_num = 1;
		trans_set = level.inert_crawl_trans_walk;
		animstate = "zm_inert_crawl_trans";
	}

	if ( self.zombie_move_speed == "run" )
	{
		if ( !self.missingLegs )
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
		if ( !self.missingLegs )
		{
			trans_set = level.inert_trans_sprint;
		}
		else
		{
			trans_set = level.inert_crawl_trans_sprint;
		}
		trans_num = 2;
	}

	self thread inert_eye_glow();

	self SetAnimStateFromASD( animstate, trans_set[ RandomInt( trans_num ) ] );
	self zm_spawner::zombie_history( "inert_trans_anim " + GetTime() );
	zombie_shared::DoNoteTracks( "inert_trans_anim" );
}

function inert_eye_glow()
{
	self endon( "death" );

	while ( 1 )
	{
		self waittill( "inert_trans_anim", note );
		if ( note == "end" )
		{
			return;
		}
		else if ( note == "zmb_awaken" )
		{
			self zombie_utility::zombie_eye_glow();
			return;
		}
	}
}
