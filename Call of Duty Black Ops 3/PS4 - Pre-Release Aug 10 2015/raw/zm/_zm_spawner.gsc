#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_behavior_utility;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_puppet;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                           	                                     	                	                       	            	                                                                                                                                                                                                                              
                                                                                                                                                                                                       	     	                                                                                   
 	  	
                                                                                       	                                

#namespace zm_spawner;

function init()
{
	level._CONTEXTUAL_GRAB_LERP_TIME = .3; // This is the time it takes to move into position for each bar.

	level.zombie_spawners = GetEntArray( "zombie_spawner", "script_noteworthy" );
	
	// This will be an array of archetypes and the saved health of any entities cleaned up so that replacements can have the same health.
	// We don't want people exploiting cleaned up zombies as a way to generate extra points by continually shooting fresh enemies.
	level.a_zombie_respawn_health = [];	

	if(( isdefined( level.use_multiple_spawns ) && level.use_multiple_spawns ))
	{
		level.zombie_spawn = [];
		for ( i = 0; i < level.zombie_spawners.size; i++ )
		{
			if(IsDefined(level.zombie_spawners[i].script_int))
			{
				int = level.zombie_spawners[i].script_int;
				if ( !IsDefined( level.zombie_spawn[int] ))
				{
					level.zombie_spawn[int] = [];
				}
				level.zombie_spawn[int][level.zombie_spawn[int].size] = level.zombie_spawners[i];
			}
		}
	}
	
	if ( IsDefined( level.ignore_spawner_func ) )
	{
		for ( i = 0; i < level.zombie_spawners.size; i++ )
		{
			ignore = [[ level.ignore_spawner_func ]]( level.zombie_spawners[i] );
			if ( ignore )
			{
				ArrayRemoveValue(level.zombie_spawners, level.zombie_spawners[i]);
			}
		}	
	}
 	
 	if ( !IsDefined( level.attack_player_thru_boards_range ) )
 	{
 		level.attack_player_thru_boards_range = 109.8;
 	}
 	
 	if(isdefined(level._game_module_custom_spawn_init_func))
 	{
 		[[level._game_module_custom_spawn_init_func]]();
 	}

	/#
		level thread debug_show_exterior_goals();
	#/
}

/#
function debug_show_exterior_goals()
{
	while ( 1 )
	{
		if ( ( isdefined( level.toggle_show_exterior_goals ) && level.toggle_show_exterior_goals ) )
		{
			color = ( 1, 1, 1 );
			color_red = ( 1, 0, 0 );
			color_blue = ( 0, 0, 1 );

			foreach( zone in level.zones )
			{
				foreach( location in zone.a_loc_types[ "zombie_location" ] )
				{
					RecordStar( location.origin, color );
				}
			}

			foreach( zone in level.zones )
			{
				foreach( location in zone.a_loc_types[ "zombie_location" ] )
				{
					foreach( goal in level.exterior_goals )
					{
						if ( goal.script_string == location.script_string )
						{
							RecordLine( location.origin, goal.origin, color );
							goal.has_spawner = true;
							break;
						}
					}
				}
			}

			foreach( goal in level.exterior_goals )
			{
				if ( ( isdefined( goal.has_spawner ) && goal.has_spawner ) )
				{
					RecordCircle( goal.origin, 16, color );
				}
				else if ( IsDefined( goal.script_string ) && goal.script_string == "find_flesh" )
				{
					RecordCircle( goal.origin, 16, color_blue );
				}
				else
				{
					RecordCircle( goal.origin, 16, color_red );
				}
			}
		}

		{wait(.05);};
	}
}
#/

function add_cusom_zombie_spawn_logic(func)
{
	if(!IsDefined(level._zombie_custom_spawn_logic))
	{
		level._zombie_custom_spawn_logic = [];
	}
	
	level._zombie_custom_spawn_logic[level._zombie_custom_spawn_logic.size] = func;
}

function player_attacks_enemy( player, amount, type, point, weapon )
{
	team = undefined;
	if(isDefined(self._race_team))
	{
		team = self._race_team;
	}
	
	if ( ( isdefined( player.allow_zombie_to_target_ai ) && player.allow_zombie_to_target_ai ) || !player util::is_ads() )
	{
		// defaults to empty_kill_func, for arcademode
		[[ level.global_damage_func ]]( type, self.damagelocation, point, player, amount, team, weapon );
		return false;
	}
		
	if ( !zm_utility::bullet_attack( type ) )
	{
		// defaults to empty_kill_func, for arcademode
		[[ level.global_damage_func ]]( type, self.damagelocation, point, player, amount, team, weapon );
		return false;
	}

	// defaults to empty_kill_func, for arcademode
	[[ level.global_damage_func_ads ]]( type, self.damagelocation, point, player, amount, team, weapon );
		
	return true;
}


function player_attacker( attacker )
{
	if ( IsPlayer(attacker) )
	{
		return true;
	}
	return false;
}

function enemy_death_detection()
{
	self endon ("death");
	
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, tagName, modelName, partName, weapon );
		if ( !isDefined(amount) )
		{
			continue;
		}

		if ( !isalive( self ) )
		{
			return;
		}
		
		if ( !player_attacker( attacker ) && !( isdefined( attacker.allow_zombie_to_target_ai ) && attacker.allow_zombie_to_target_ai ) )
		{
			continue;
		}
		
		self.has_been_damaged_by_player = true;
		
		self player_attacks_enemy( attacker, amount, type, point, weapon );
	}
}


function is_spawner_targeted_by_blocker( ent )
{
	if( IsDefined( ent.targetname ) )
	{
		targeters = GetEntArray( ent.targetname, "target" );

		for( i = 0; i < targeters.size; i++ )
		{
			if( targeters[i].targetname == "zombie_door" || targeters[i].targetname == "zombie_debris" )
			{
				return true;
			}

			result = is_spawner_targeted_by_blocker( targeters[i] );
			if( result )
			{
				return true;
			}
		}
	}

	return false;
}

function add_custom_zombie_spawn_logic(func)
{
	if(!IsDefined(level._zombie_custom_spawn_logic))
	{
		level._zombie_custom_spawn_logic = [];
	}
	
	level._zombie_custom_spawn_logic[level._zombie_custom_spawn_logic.size] = func;
}


// set up zombie walk cycles
function zombie_spawn_init( animname_set )
{
	if( !isDefined( animname_set ) )
	{
		animname_set = false;
	}
	
	self.targetname = "zombie";
	self.script_noteworthy = undefined;

	//A zombie was spawned - recalculate zombie array
	zm_utility::recalc_zombie_array();

	if( !animname_set )
	{
		self.animname = "zombie"; 		
	}
	
	//pre-spawn gamemodule init
	if(isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}

	self thread play_ambient_zombie_vocals();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	 
	self.ignoreme = true; // don't let attack dogs give chase until the zombie is in the playable area
	self.allowdeath = true; 			// allows death during animscripted calls
	self.force_gib = true; 		// needed to make sure this guy does gibs
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	self allowedStances( "stand" );
	
	//needed to make sure zombies don't distribute themselves amongst players
	self.attackercountthreat = 0;	
	
	self.zombie_damaged_by_bar_knockdown = false; // This tracks when I can knock down a zombie with a bar

	self.gibbed = false; 
	self.head_gibbed = false;
	
	// might need this so co-op zombie players cant block zombie pathing
//	self PushPlayer( true ); 
//	self.meleeRange = 128; 
//	self.meleeRangeSq = anim.meleeRange * anim.meleeRange; 

	self setPhysParams( 15, 0, 72 );
	self.goalradius = 32;
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;

	self.badplaceawareness = 0;
	self.chatInitialized = false;
	self.missingLegs = false;
	if(randomint( 2 ) == 0)
		self.zombie_arms_position = "up";
	else
		self.zombie_arms_position = "down";

	if ( randomint( 100 ) < 25 )
	{
		self.canStumble = true;
	}
	
	self.a.disablepain = true;
	self zm_utility::disable_react(); // SUMEET - zombies dont use react feature.

	if ( isdefined( level.zombie_health ) )
	{
		self.maxhealth = level.zombie_health; 
		
		if( IsDefined(level.a_zombie_respawn_health[ self.archetype ] ) && level.a_zombie_respawn_health[ self.archetype ].size > 0 )
		{
			self.health = level.a_zombie_respawn_health[ self.archetype ][0];
			ArrayRemoveValue(level.a_zombie_respawn_health[ self.archetype ], level.a_zombie_respawn_health[ self.archetype ][0]);		
		}
		else
		{
			self.health = level.zombie_health;
		}	 
	}
	else
	{
		self.maxhealth = level.zombie_vars["zombie_health_start"]; 
		self.health = self.maxhealth; 
	}

	self.freezegun_damage = 0;

	//setting avoidance parameters for zombies
	self setAvoidanceMask( "avoid none" );

	// wait for zombie to teleport into position before pathing
	self PathMode( "dont move" );

	level thread zombie_death_event( self );

	// We need more script/code to get this to work properly
//	self add_to_spectate_list();
//	self random_tan(); 
	self zm_utility::init_zombie_run_cycle(); 
	self thread zombie_think(); 
	self thread zombie_utility::zombie_gib_on_damage(); 
	self thread zombie_damage_failsafe();
	
	self thread enemy_death_detection();

	if(IsDefined(level._zombie_custom_spawn_logic))
	{
		if(IsArray(level._zombie_custom_spawn_logic))
		{
			for(i = 0; i < level._zombie_custom_spawn_logic.size; i ++)
			{
			self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else
		{
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}
	
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		if ( !( isdefined( self.is_inert ) && self.is_inert ) )
		{
			self thread zombie_utility::delayed_zombie_eye_glow();	// delayed eye glow for ground crawlers (the eyes floated above the ground before the anim started)
		}
	}
	self.deathFunction = &zombie_death_animscript;
	self.flame_damage_time = 0;

	self.meleeDamage = 60;	// 45
	self.no_powerups = true;
	
	self zombie_history( "zombie_spawn_init -> Spawned = " + self.origin );

	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	self.tesla_head_gib_func = &zombie_tesla_head_gib;

	self.team = level.zombie_team;
	
	self.sword_kill_power = 2;

	if ( isDefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}
		
	//gamemodule post init
	if(isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}

	if ( isDefined( level.zombie_init_done ) )
	{
		self [[ level.zombie_init_done ]]();
	}
	self.zombie_init_done = true;

	self notify( "zombie_init_done" );
}

function zombie_damage_failsafe()
{
	self endon ("death");

	continue_failsafe_damage = false;	
	while (1)
	{
		//should only be for zombie exploits
		wait 0.5;
		
		if ( !isdefined( self.enemy ) || !IsPlayer( self.enemy ) )
		{
			continue;
		}
		
		if (self istouching(self.enemy))
		{
			old_org = self.origin;
			if (!continue_failsafe_damage)
			{
				wait 5;
			}
			
			//make sure player doesn't die instantly after getting touched by a zombie.
			if (!isdefined(self.enemy) || !IsPlayer( self.enemy ) || self.enemy hasperk( "specialty_armorvest" ) )
			{
				continue;
			}
		
		
		if (self istouching(self.enemy) 
				&& !self.enemy laststand::player_is_in_laststand()
				&& isalive(self.enemy))
			{
				//TODO	THIS SHOULD NOT BE A PERMANENT FIX, ONLY TEMP TEST
				//MM -10/13/09  This distance used to be 35
				if (distancesquared(old_org, self.origin) < (60 * 60) ) 
				{
					self.enemy DoDamage( self.enemy.health + 1000, self.enemy.origin, self, self, "none", "MOD_RIFLE_BULLET" );
				
					continue_failsafe_damage = true;
				}
			}
		}
		else
		{
			continue_failsafe_damage = false;
		}
	}
}


function should_skip_teardown( find_flesh_struct_string )
{
	// Riser who spawns in the playable area
	if( IsDefined(find_flesh_struct_string) && find_flesh_struct_string == "find_flesh" ) 
	{
		return true;
	}
	// Used on dogs...could be used on a zombie who spawns in and immediately chases player
	if( isDefined( self.script_string ) && self.script_string == "find_flesh" ) 
	{
		return true;
	}
	
	return false;
}

function zombie_findnodes()
{
	
	node = undefined;

	desired_nodes = [];
	self.entrance_nodes = [];

	if ( IsDefined( level.max_barrier_search_dist_override ) )
	{
		max_dist = level.max_barrier_search_dist_override;
	}
	else
	{
		max_dist = 500;
	}

	if( !IsDefined(self.find_flesh_struct_string) && IsDefined( self.target ) && self.target != "" )
	{
		desired_origin = zombie_utility::get_desired_origin();

		assert( IsDefined( desired_origin ), "Spawner @ " + self.origin + " has a .target but did not find a target" );
	
		origin = desired_origin;
			
		node = ArrayGetClosest( origin, level.exterior_goals ); 	
		self.entrance_nodes[self.entrance_nodes.size] = node;

		self zombie_history( "zombie_think -> #1 entrance (script_forcegoal) origin = " + self.entrance_nodes[0].origin );
	}
	// JMA - this is used in swamp to spawn outdoor zombies and immediately rush the player
	// JMA - if riser becomes a non-riser, make sure they go to a barrier first instead of chasing a player
	else if ( self should_skip_teardown( self.find_flesh_struct_string ) )
	{
		self zombie_setup_attack_properties();
		//if the zombie has a target, make them go there first
		if (isDefined(self.target))
		{
			end_at_node = GetNode(self.target, "targetname");
			if (isDefined(end_at_node))
			{
				self setgoalnode (end_at_node);
				self waittill("goal");
			}
		}

		if ( ( isdefined( self.start_inert ) && self.start_inert ) )
		{
			self zombie_complete_emerging_into_playable_area();
		}
		else
		{
			self thread zombie_entered_playable();
		}
		return;	
	}
	else if( IsDefined(self.find_flesh_struct_string) )
	{
/#
		assert( IsDefined(self.find_flesh_struct_string) );		//This needs to be setup corrcetly now
#/
		for( i=0; i<level.exterior_goals.size; i++ )
		{
			if( IsDefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == self.find_flesh_struct_string )
			{
				node = level.exterior_goals[i];
				break;
			}
		}
		self.entrance_nodes[self.entrance_nodes.size] = node;
		
		self zombie_history( "zombie_think -> #1 entrance origin = " + node.origin );

		// Incase the guy does not move from spawn, then go to the closest one instead
		self thread zombie_assure_node();
	}

	assert( IsDefined( node ), "Did not find a node!!! [Should not see this!]" );

	level thread zm_utility::draw_line_ent_to_pos( self, node.origin, "goal" );
	
	self.first_node = node; // This is the first locatin the zombies go to
	
}

// JL 12/08/09 this is the main zombie think thread that starts when they spawn in
function zombie_think()
{
	self endon( "death" ); 
	assert( !self.isdog );
	
	self.ai_state = "zombie_think";
	
	//node = level.exterior_goals[randomint( level.exterior_goals.size )]; 
	
	// MM - 5/8/9 Add ability for risers to find_flesh immediately after spawning if the
	//	rise struct has the script_noteworthy "find_flesh"
	find_flesh_struct_string = undefined;

	if ( IsDefined(level.zombie_custom_think_logic) )
	{
		shouldWait = self [[ level.zombie_custom_think_logic ]]();
		if ( shouldWait )
		{
			self waittill("zombie_custom_think_done", find_flesh_struct_string);
		}
	}
	else if ( ( isdefined( self.start_inert ) && self.start_inert ) )
	{
		find_flesh_struct_string = "find_flesh";
	}
	else
	{
		if ( isdefined( self.custom_location ) )
		{
			self thread [[ self.custom_location ]]();
		}
		else
		{
			// DCS 032612: find available structs to spawn at:
			self thread do_zombie_spawn();
		}
		self waittill("risen", find_flesh_struct_string );
	}
	self.find_flesh_struct_string = find_flesh_struct_string;

	/#
	//need to use this node if released from the puppeteer
	self.backupNode = self.first_node;
	self thread zm_puppet::wait_for_puppet_pickup();
	#/
	// what is the zombies goal radius at this point
	//self thread zombie_goto_entrance( self.first_node ); // sends the zombie to the node right in front of the window

	self SetGoal( self.origin );
	self PathMode( "move allowed" );
	self.zombie_think_done = true;
}

function zombie_entered_playable()
{
	self endon( "death" );

	if ( !IsDefined( level.playable_areas ) )
	{
		level.playable_areas = GetEntArray("player_volume", "script_noteworthy" );
	}

	while ( true )
	{
		foreach(area in level.playable_areas)
		{
			if(self IsTouching(area))
			{
				self zombie_complete_emerging_into_playable_area();
				return;
			}
		}
		wait(1);
	}	 
}	

function zombie_goto_entrance( node, endon_bad_path )
{
	assert( !self.isdog );
	
	self endon( "death" );
	self endon( "stop_zombie_goto_entrance" );
	level endon( "intermission" );

	self.ai_state = "zombie_goto_entrance";
	
	if( IsDefined( endon_bad_path ) && endon_bad_path )
	{
		// If we cannot go to the goal, then end...
		// Used from find_flesh
		self endon( "bad_path" );
	}



	self zombie_history( "zombie_goto_entrance -> start goto entrance " + node.origin );

	self.got_to_entrance = false;
	
	
	
	// This is the goal radius while the zombies search for a window to attack
	self.goalradius = 128; 
	self SetGoal( node.origin );
	self waittill( "goal" ); 
	self.got_to_entrance = true;

	self zombie_history( "zombie_goto_entrance -> reached goto entrance " + node.origin );

	// Guy should get to goal and tear into building until all barrier chunks are gone
	// They go into this function and do everything they and then comeback once all the barriers are removed
	self tear_into_building();

	if( isDefined( level.pre_aggro_pathfinding_func ) )
	{
		self [[ level.pre_aggro_pathfinding_func ]]();
	}

	barrier_pos = [];
	barrier_pos[0] = "m";
	barrier_pos[1] = "r";
	barrier_pos[2] = "l";

	self.barricade_enter = true;
	animstate = zombie_utility::append_missing_legs_suffix( "zm_barricade_enter" );
	//substate = "barrier_" + self.zombie_move_speed + "_" + barrier_pos[ self.attacking_spot_index ];
	//self AnimScripted( self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, animstate, substate );
	self AnimScripted( "barricade_enter_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_barricade_enter_m_v1" );
	zombie_shared::DoNoteTracks( "barricade_enter_anim" );
	
	self zombie_setup_attack_properties();
	
	//self.pathEnemyFightDist = 4;	// make sure zombie gets out of the window

	self zombie_complete_emerging_into_playable_area();
	//self.pathEnemyFightDist = 64;	// restore
	self.barricade_enter = false;
}
	

// Here the zombies constantly search 
function zombie_assure_node()
{
	self endon( "death" );
	self endon( "goal" );
	level endon( "intermission" );

	start_pos = self.origin;
	if(IsDefined(self.entrance_nodes))
	{
		for( i = 0; i < self.entrance_nodes.size; i++ )
		{
			if( self zombie_bad_path() )
			{
				self zombie_history( "zombie_assure_node -> assigned assured node = " + self.entrance_nodes[i].origin );
	
			/#	println( "^1Zombie @ " + self.origin + " did not move for 1 second. Going to next closest node @ " + self.entrance_nodes[i].origin );	#/
				level thread zm_utility::draw_line_ent_to_pos( self, self.entrance_nodes[i].origin, "goal" );
				self.first_node = self.entrance_nodes[i];
				self SetGoal( self.entrance_nodes[i].origin );
			}
			else
			{
				return;
			}
		}
	}		
	// CHRISP - must add an additional check, since the 'self.entrance_nodes' array is not dynamically updated to accomodate for entrance points that can be turned on and off
	// only do this if it's the asylum map
	wait(2);
	// Get more nodes and try again
	nodes = array::get_all_closest( self.origin, level.exterior_goals, undefined, 20 );
	//nodes = ArraySort( level.exterior_goals, self.origin, true, 20 );

	if(IsDefined(nodes))
	{
		self.entrance_nodes = nodes;
		for( i = 0; i < self.entrance_nodes.size; i++ )
		{
			if( self zombie_bad_path() )
			{
				self zombie_history( "zombie_assure_node -> assigned assured node = " + self.entrance_nodes[i].origin );
	
			/#	println( "^1Zombie @ " + self.origin + " did not move for 1 second. Going to next closest node @ " + self.entrance_nodes[i].origin );	#/
				level thread zm_utility::draw_line_ent_to_pos( self, self.entrance_nodes[i].origin, "goal" );
				self.first_node = self.entrance_nodes[i];
				self SetGoal( self.entrance_nodes[i].origin );
			}
			else
			{
				return;
			}
		}
	}	

	self zombie_history( "zombie_assure_node -> failed to find a good entrance point" );
	
	//assertmsg( "^1Zombie @ " + self.origin + " did not find a good entrance point... Please fix pathing or Entity setup" );
	wait(20);
	//iprintln( "^1Zombie @ " + self.origin + " did not find a good entrance point... Please fix pathing or Entity setup" );
	
	
	self DoDamage( self.health + 10, self.origin );
	
	//add this zombie back into the spawner queue to be re-spawned, should only happen with a bad window.
	if(( isdefined( level.put_timed_out_zombies_back_in_queue ) && level.put_timed_out_zombies_back_in_queue ) && !( isdefined( self.has_been_damaged_by_player ) && self.has_been_damaged_by_player ))
	{
		level.zombie_total++;
		level.zombie_total_subtract++;					
	}
	
	//add this to the stats even tho he really didn't 'die' 
	level.zombies_timeout_spawn++;
	
}

function zombie_bad_path()
{
	self endon( "death" );
	self endon( "goal" );

	self thread zombie_bad_path_notify();
	self thread zombie_bad_path_timeout();

	self.zombie_bad_path = undefined;
	while( !IsDefined( self.zombie_bad_path ) )
	{
		{wait(.05);};
	}

	self notify( "stop_zombie_bad_path" );

	return self.zombie_bad_path;
}

function zombie_bad_path_notify()
{
	self endon( "death" );
	self endon( "stop_zombie_bad_path" );

	self waittill( "bad_path" );
	
	
	self.zombie_bad_path = true;
}

function zombie_bad_path_timeout()
{
	self endon( "death" );
	self endon( "stop_zombie_bad_path" );

	wait( 2 );
	self.zombie_bad_path = false;
}


// This controls the zombies breaking into the building.
// Self is a specific zombie
// Node is the player's origin
function tear_into_building()
{
	self endon( "death" ); // this is a zombie
	self endon("teleporting");
	self zombie_history( "tear_into_building -> start" ); // update history that they have started to tear in 

	while( 1 )
	{
		//also check
		//if( IsDefined( self.first_node) )
		//{
		
			if( IsDefined( self.first_node.script_noteworthy ) )
			{
				if( self.first_node.script_noteworthy == "no_blocker" )
				{
					return; // if no blocker checks out ok... then allow the zombie to connect paths
				}
			}

			if( !IsDefined( self.first_node.target ) )
			{
				return;
			}

			// barrier_chunks is the exterior_goal that has all the bars and boards connected to it.
			// remember all_chunks_destroyed is in utility script _zombie_utility
			if( zm_utility::all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) ) // If barrier_chunks status says all chunks are destroyed then continue
			{
				// latest
				// Send this notify but only accept the first time it comes through.
				self zombie_history( "tear_into_building -> all chunks destroyed" ); // Enter the building if all chunks are gone. This is threaded for each zombie
			}

			// If an attacking_spot is availiable then they well grab one, if not they taunt.
			// Jluyties (02/04/10)Added the ability for zombies to taunt while they wait to attack a window 
			if( !get_attack_spot( self.first_node ) )
			{	
				self zombie_history( "tear_into_building -> Could not find an attack spot" );
				//Print3d(self.origin+(0,0,70), "Hey I am waiting to attack, play random " );
				//Print3d(self.origin+(0,0,70), "Hey I am waiting to attack", ( 1, 0.8, 0.5), 1, 1, 5);
				//IPrintLnBold( "Hey I am waiting to attack " );
				self thread  do_a_taunt();
				wait( 0.5 );
				continue;
			}
		
			// This is where the zombie moves into position to tear down a board/bar
			self.goalradius = 2;
			//self maps\_zombiemode_utility:: lerp( chunk );
			self.at_entrance_tear_spot = false;
			if ( isdefined( level.tear_into_position ) )
			{
				self [[ level.tear_into_position ]]();
			}
			else
			{
				angles = self.first_node.zbarrier.angles;
		
				self SetGoal( self.attacking_spot );
			}
			self waittill( "goal" );
			self.at_entrance_tear_spot = true;
			//	MM- 05/09
			//	If you wait for "orientdone", you NEED to also have a timeout.
			//	Otherwise, zombies could get stuck waiting to do their facing.
			if ( isdefined( level.tear_into_wait ) )
			{
				self [[ level.tear_into_wait ]]();
			}
			else
			{
				self util::waittill_any_timeout(1, "orientdone" );
			}
	
			self zombie_history( "tear_into_building -> Reach position and orientated" );		
	
			// chrisp - do one final check to make sure that the boards are still torn down
			// this *mostly* prevents the zombies from coming through the windows as you are boarding them up. 
			if( zm_utility::all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) )
			{
				self zombie_history( "tear_into_building -> all chunks destroyed" );
				for( i = 0; i < self.first_node.attack_spots_taken.size; i++ )
				{
					self.first_node.attack_spots_taken[i] = false;
				}
				return;
			}
		//}
	
		// Now tear down boards
		while( 1 )
		{
			if ( isDefined( self.zombie_board_tear_down_callback ) )
			{
				self [[self.zombie_board_tear_down_callback]]();
			}

			// get_closest_non_destroyed_chunk calls into _zombiemode_utility and returns if any chunks are still there
			self.chunk = zm_utility::get_closest_non_destroyed_chunk( self.origin, self.first_node, self.first_node.barrier_chunks );

			if ( !IsDefined( self.chunk ) )
			{
				if( !zm_utility::all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) )
				{
					attack = self should_attack_player_thru_boards();
					if(isDefined(attack) && !attack && !self.missingLegs)
					{
						self do_a_taunt();
					}
					else
					{
						wait( 0.1 );
					}
					continue;
				}


				for( i = 0; i < self.first_node.attack_spots_taken.size; i++ )
				{
					self.first_node.attack_spots_taken[i] = false;
				}
				return; 
			}

			self zombie_history( "tear_into_building -> animating" );
			
			self.first_node.zbarrier SetZBarrierPieceState(self.chunk, "targetted_by_zombie");
			self.first_node thread check_zbarrier_piece_for_zombie_inert(self.chunk, self.first_node.zbarrier, self);
			self.first_node thread check_zbarrier_piece_for_zombie_death(self.chunk, self.first_node.zbarrier, self);
			
			self notify( "bhtn_action_notify", "teardown" );

			/*if( isdefined( level.zbarrier_override_tear_in ) )
			{
				animStateBase = self [[ level.zbarrier_override_tear_in ]]( chunk );			
			}
			else
			{
				animStateBase = self.first_node.zbarrier GetZBarrierPieceAnimState(chunk);			
			}
			
			animSubState = "spot_" + self.attacking_spot_index + "_piece_" + self.first_node.zbarrier GetZBarrierPieceAnimSubState(chunk);
			
			anim_sub_index	= self GetAnimSubStateFromASD( animStateBase + "_in", animSubState );				
			*/
			
            //self AnimScripted( self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, zombie_utility::append_missing_legs_suffix( animStateBase + "_in" ), anim_sub_index );
			self AnimScripted( "tear_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_boardtear_aligned_m_1_grab" );
			
				
            self zombie_tear_notetracks( "tear_anim", self.chunk, self.first_node );
			
			while(0 < self.first_node.zbarrier.chunk_health[self.chunk])
			{
				//self AnimScripted( self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, zombie_utility::append_missing_legs_suffix( animStateBase + "_loop" ), anim_sub_index );
				self AnimScripted( "tear_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_boardtear_aligned_m_1_hold" );
				self zombie_tear_notetracks( "tear_anim", self.chunk, self.first_node );
        		self.first_node.zbarrier.chunk_health[self.chunk]--;
			}
			
            //self AnimScripted( self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, zombie_utility::append_missing_legs_suffix( animStateBase + "_out" ), anim_sub_index );
			self AnimScripted( "tear_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_boardtear_aligned_m_1_pull" );
			self waittill("temp proceed");
			
             //to prevent the zombie from being deleted by the failsafe system
            self.lastchunk_destroy_time = GetTime();
            
            attack = self should_attack_player_thru_boards();
            if ( isDefined( attack ) && !attack && !self.missingLegs )
            {
                self do_a_taunt();
            }                

			//chrisp - fix the extra tear anim bug
			if ( zm_utility::all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) )
			{
				for( i = 0; i < self.first_node.attack_spots_taken.size; i++ )
				{
					self.first_node.attack_spots_taken[i] = false;
				}
				
				level notify( "last_board_torn", self.first_node.zbarrier.origin );
				
				return;
			}	
		}
		
		self zombie_utility::reset_attack_spot();
	}		
}


/*------------------------------------
function checks to see if the zombie should 
function do a taunt when tearing thru the boards
------------------------------------*/
function do_a_taunt()
{
	self endon ("death"); // Jluyties 02/16/10 added death check, cause of crash 
	if( self.missingLegs )
	{
		return false;
	}

	if(!self.first_node.zbarrier ZBarrierSupportsZombieTaunts())
	{
		return;
	}
	
	self.old_origin = self.origin;
	if(GetDvarString( "zombie_taunt_freq") == "")
	{
		SetDvar("zombie_taunt_freq","5");
	}
	freq = GetDvarInt( "zombie_taunt_freq");
	
	if( freq >= randomint(100) )
	{
		self notify( "bhtn_action_notify", "taunt" );
		
		tauntState = "zm_taunt";
		
		if(isdefined(self.first_node.zbarrier) && self.first_node.zbarrier GetZBarrierTauntAnimState() != "")
		{
			tauntState = self.first_node.zbarrier GetZBarrierTauntAnimState();
		}
		
		//self animscripted( "anim_wait_done", self.origin, self.angles, tauntState );
		self animscripted( "taunt_anim", self.origin, self.angles, "ai_zombie_taunts_4" );
		self taunt_notetracks( "taunt_anim" );
	}
}

function taunt_notetracks(msg)
{
	self endon("death");

	while(1)
	{
		self waittill( msg, notetrack );

		if( notetrack == "end" )
		{
			self ForceTeleport(self.old_origin);

			return;
		}
	}
}
/*------------------------------------
function checks to see if the players are near
function the entrance and tries to attack them 
function thru the boards. 50% chance
function Self is a zombie
------------------------------------*/
function should_attack_player_thru_boards()
{

	//no board attacks if they are crawlers
	if( self.missingLegs )
	{
		return false;
	}
	
	if(isdefined(self.first_node.zbarrier))
	{
		if(!self.first_node.zbarrier ZBarrierSupportsZombieReachThroughAttacks())
		{
			return false;
		}
	}
	
	if(GetDvarString( "zombie_reachin_freq") == "")
	{
		SetDvar("zombie_reachin_freq","50");
	}
	freq = GetDvarInt( "zombie_reachin_freq");
	
	players = GetPlayers();
	attack = false;

    self.player_targets = [];
    for(i=0;i<players.size;i++)
    {
    	if ( isAlive( players[i] ) && !isDefined( players[i].revivetrigger ) && distance2d( self.origin, players[i].origin ) <= level.attack_player_thru_boards_range && !( isdefined( players[i].zombie_vars[ "zombie_powerup_zombie_blood_on" ] ) && players[i].zombie_vars[ "zombie_powerup_zombie_blood_on" ] ) )
        {
            self.player_targets[self.player_targets.size] = players[i];
            attack = true;
        }
    }

    if ( !attack || freq < randomint(100) )
	{
		return false;	
	}

	self.old_origin = self.origin;

	attackAnimState = "zm_window_melee";
	
	if(isdefined(self.first_node.zbarrier) && self.first_node.zbarrier GetZBarrierReachThroughAttackAnimState() != "")
	{
		attackAnimState = self.first_node.zbarrier GetZBarrierReachThroughAttackAnimState();
	}
	
	// index 0 is center, index 2 is left and index 1 is the right, so (0 - 1) results in randomizing between both options
	self notify( "bhtn_action_notify", "attack" );
	//self AnimScripted( self.origin, self.angles, attackAnimState, self.attacking_spot_index - 1 );
	self AnimScripted( "window_melee_anim", self.origin, self.angles, "ai_zombie_window_attack_arm_l_out" ); 
	self window_notetracks( "window_melee_anim" );

	return true;
}

function window_notetracks(msg)
{
	self endon("death");

	while(1)
	{
		self waittill( msg, notetrack );

		if( notetrack == "end" )
		{
			//self waittill("end");
			self teleport(self.old_origin);

			return;
		}
		if( notetrack == "fire" )
		{
			if(self.ignoreall)
			{
				self.ignoreall = false;
			}

			// just hit a player
			if ( isDefined( self.first_node ) )
			{
				_MELEE_DIST_SQ = 90*90;
				
				if ( IsDefined( level.attack_player_thru_boards_range ) )
 				{
 					_MELEE_DIST_SQ =  level.attack_player_thru_boards_range	* level.attack_player_thru_boards_range;
				}
				
				_TRIGGER_DIST_SQ = 51*51;

				for ( i = 0; i < self.player_targets.size; i++ )
				{
					playerDistSq = Distance2DSquared( self.player_targets[i].origin, self.origin );
					heightDiff = abs( self.player_targets[i].origin[2] - self.origin[2] ); // be sure we're on the same floor
					if ( playerDistSq < _MELEE_DIST_SQ && (heightDiff * heightDiff) < _MELEE_DIST_SQ )
					{
						triggerDistSq = Distance2DSquared( self.player_targets[i].origin, self.first_node.trigger_location.origin );
						heightDiff = abs( self.player_targets[i].origin[2] - self.first_node.trigger_location.origin[2] ); // be sure we're on the same floor
						if ( triggerDistSq < _TRIGGER_DIST_SQ && (heightDiff * heightDiff) < _TRIGGER_DIST_SQ )
						{
							self.player_targets[i] DoDamage( self.meleeDamage, self.origin, self, self, "none", "MOD_MELEE" );
							break;
						}
					}
				}
			}
			else
			{
				self melee();
			}
		}
	}
}

function get_attack_spot( node )
{
	index = get_attack_spot_index( node );
	if( !IsDefined( index ) )
	{
		return false;
	}

	/#
		val = GetDvarInt( "zombie_attack_spot" );
		if ( val> -1 )
		{
			index = val;
		}
	#/
	
	self.attacking_node = node;
	self.attacking_spot_index = index;
	node.attack_spots_taken[index] = true;
	self.attacking_spot = node.attack_spots[index];

	return true;
}

function get_attack_spot_index( node )
{
	indexes = [];
	for( i = 0; i < node.attack_spots.size; i++ )
	{
		if( !node.attack_spots_taken[i] )
		{
			indexes[indexes.size] = i;
		}
	}

	if( indexes.size == 0 )
	{
		return undefined;
	}

	return indexes[RandomInt( indexes.size )];
}

// Self is zombie
function zombie_tear_notetracks( msg, chunk, node )
{
	self endon("death");
	
	while( 1 )
	{
		self waittill( msg, notetrack );

		if ( notetrack == "end" )
		{
			return;
		}
		
		if ( notetrack == "board" || notetrack == "destroy_piece" || notetrack == "bar")
		{
			if( isdefined( level.zbarrier_zombie_tear_notetrack_override ) )
			{
				self thread [[ level.zbarrier_zombie_tear_notetrack_override ]]( node, chunk );
			}
			node.zbarrier SetZBarrierPieceState(chunk, "opening");
		}
	}
}

// jl I am doing this so I can have an offset of timing for when the chunks come off to give it more life
// 0.8 is too long
// need to offset sound
// need to add this to the boards
function zombie_boardtear_offset_fx_horizontle( chunk, node )
{
	// DCS 090110: fx for breaking out glass or wall.
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "repair_board"  || chunk.script_parameters == "board") )
	{
		if(IsDefined(chunk.unbroken) && chunk.unbroken == true)
		{ 
			if(IsDefined(chunk.material) && chunk.material == "glass")
			{
				PlayFX( level._effect["glass_break"], chunk.origin, node.angles );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "metal")
			{
				PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "rock")
			{
				if(	( isdefined( level.use_clientside_rock_tearin_fx ) && level.use_clientside_rock_tearin_fx ))
				{
					chunk clientfield::set( "tearin_rock_fx", 1 );
				}
				else
				{
					PlayFX( level._effect["wall_break"], chunk.origin );
				}
				chunk.unbroken = false;
			}
		}
	}
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "barricade_vents" ) )
	{
		if(	( isdefined( level.use_clientside_board_fx ) && level.use_clientside_board_fx ))
		{
			chunk clientfield::set( "tearin_board_vertical_fx", 1);
		}
		else
		{
			PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
		}
	}	
	else if(IsDefined(chunk.material) && chunk.material == "rock")
	{
		if(	( isdefined( level.use_clientside_rock_tearin_fx ) && level.use_clientside_rock_tearin_fx ))
		{
			chunk clientfield::set( "tearin_rock_fx", 1 );
		}
	}
			
	else
	{	
		if(isDefined(level.use_clientside_board_fx))
		{
			chunk clientfield::set( "tearin_board_vertical_fx", 1 );
		}
		else
		{
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, 30));
			wait( randomfloatrange( 0.2, 0.4 ));
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, -30));
		}	
	}
}

function zombie_boardtear_offset_fx_verticle( chunk, node )
{
	// DCS 090110: fx for breaking out glass or wall.
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "repair_board"  || chunk.script_parameters == "board") )
	{
		if(IsDefined(chunk.unbroken) && chunk.unbroken == true)
		{ 
			if(IsDefined(chunk.material) && chunk.material == "glass")
			{
				PlayFX( level._effect["glass_break"], chunk.origin, node.angles );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "metal")
			{
				PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "rock")
			{
				if(	( isdefined( level.use_clientside_rock_tearin_fx ) && level.use_clientside_rock_tearin_fx ))
				{
					chunk clientfield::set( "tearin_rock_fx", 1 );
				}
				else
				{
					PlayFX( level._effect["wall_break"], chunk.origin );
				}
				chunk.unbroken = false;
			}
		}
	}
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "barricade_vents" ) )
	{
		if(isDefined(level.use_clientside_board_fx))
		{
			chunk clientfield::set( "tearin_board_horizontal_fx", 1 );
		}
		else
		{
			PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
		}
	}	
	else if(IsDefined(chunk.material) && chunk.material == "rock")
	{
		if(	( isdefined( level.use_clientside_rock_tearin_fx ) && level.use_clientside_rock_tearin_fx ))
		{
			chunk clientfield::set( "tearin_rock_fx", 1 );
		}
	}			
	else	
	{		
		if(isDefined(level.use_clientside_board_fx))
		{
			chunk clientfield::set( "tearin_board_horizontal_fx", 1 );
		}
		else
		{
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (30, 0, 0));
			wait( randomfloatrange( 0.2, 0.4 ));
//			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (-30, 0, 0));
		}
	}
}


function zombie_bartear_offset_fx_verticle( chunk )
{
	if ( IsDefined ( chunk.script_parameters ) && ( chunk.script_parameters == "bar" ) || ( chunk.script_noteworthy == "board" ))
	{
		// array random grab for fx		
		//point = points[i];
		possible_tag_array_1 = [];
		possible_tag_array_1[0] = "Tag_fx_top";
		possible_tag_array_1[1] = "";
		possible_tag_array_1[2] = "Tag_fx_top";
		possible_tag_array_1[3] = "";

		possible_tag_array_2 = [];
		possible_tag_array_2[0] = "";
		possible_tag_array_2[1] = "Tag_fx_bottom";
		possible_tag_array_2[2] = "";
		possible_tag_array_2[3] = "Tag_fx_bottom";
		// now I need a random int between 0 and 3
		possible_tag_array_2 = array::randomize( possible_tag_array_2 );

		random_fx = [];
		random_fx[0] = level._effect["fx_zombie_bar_break"];
		random_fx[1] = level._effect["fx_zombie_bar_break_lite"];
		random_fx[2] = level._effect["fx_zombie_bar_break"];
		random_fx[3] = level._effect["fx_zombie_bar_break_lite"];
		// now I need a random int between 0 and 3
		random_fx = array::randomize( random_fx );   

		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;

			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;

			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;

			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;

			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;

			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
				break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
				break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
		} 
	}
}

//jl I am doing this so I can have an offset of timing for when the chunks come off to give it more life
function zombie_bartear_offset_fx_horizontle( chunk )
{
	if ( IsDefined ( chunk.script_parameters ) && ( chunk.script_parameters == "bar" ) || ( chunk.script_noteworthy == "board" ))
	{
		switch( randomInt( 10 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
				
			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
				
			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
				
			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
				
			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
				
			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
			break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
		} 
	}
}  

function check_zbarrier_piece_for_zombie_inert(chunk_index, zbarrier, zombie)
{
	zombie endon( "completed_emerging_into_playable_area" );

	zombie waittill( "stop_zombie_goto_entrance" );

	if ( zbarrier GetZBarrierPieceState(chunk_index) == "targetted_by_zombie" )
	{
		zbarrier SetZBarrierPieceState(chunk_index, "closed");
	}
}

function check_zbarrier_piece_for_zombie_death(chunk_index, zbarrier, zombie)
{
	while(1)
	{
		if(zbarrier GetZBarrierPieceState(chunk_index) != "targetted_by_zombie")
		{
			return;
		}
		
		if(!isdefined(zombie) || !IsAlive(zombie))
		{
			zbarrier SetZBarrierPieceState(chunk_index, "closed");
			return;
		}
		
		{wait(.05);};
	}
}

function check_for_zombie_death(zombie)
{
	self endon("destroyed");
	
	wait(2.5);
	self zm_blockers::update_states("repaired");
}

//
function player_can_score_from_zombies() 
{
	if ( IsDefined(self) && ( isdefined( self.inhibit_scoring_from_zombies ) && self.inhibit_scoring_from_zombies ) ) 
	{
		return false;
	}
	return true;
}

//
//
function zombie_can_drop_powerups( zombie )
{
	if( zm_utility::is_tactical_grenade( zombie.damageweapon ) || !level flag::get( "zombie_drop_powerups" ) )
	{
		return false;
	}

	if ( isdefined(zombie.no_powerups) && zombie.no_powerups )
	{
		return false;
	}

	if ( ( isdefined( level.use_powerup_volumes ) && level.use_powerup_volumes ) )
	{
		volumes = GetEntArray( "no_powerups", "targetname" );
		foreach( volume in volumes )
		{
			if ( zombie IsTouching( volume ) )
			{
				return false;
			}
		}
	}
	
	return true;
}

function zombie_delay_powerup_drop(origin)
{
	util::wait_network_frame();
	level thread zm_powerups::powerup_drop( origin );
}

//
//	award points on death
function zombie_death_points( origin, mod, hit_location, attacker, zombie,team )
{
	if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
	{
		return; 
	}

	if ( !attacker player_can_score_from_zombies() )
	{
		zombie.marked_for_recycle = 1;
		return;
	}

	if( zombie_can_drop_powerups( zombie ) )
	{
		// DCS 031611: hack to prevent risers from dropping powerups under the ground.
		if(IsDefined(zombie.in_the_ground) && zombie.in_the_ground == true)
		{
			trace = BulletTrace(zombie.origin + (0, 0, 100), zombie.origin + (0, 0, -100), false, undefined);
			origin = trace["position"];
			level thread zombie_delay_powerup_drop( origin );
		}
		else
		{	
			trace = GroundTrace(zombie.origin + (0, 0, 5), zombie.origin + (0, 0, -300), false, undefined);
			origin = trace["position"];
			level thread zombie_delay_powerup_drop( origin );
		}	
	}

	//AUDIO: Ayers - Decides what vox to play after killing a zombie
	level thread zm_audio::player_zombie_kill_vox( hit_location, attacker, mod, zombie );

	event = "death";
	if ( zombie.damageweapon.isBallisticKnife && (mod == "MOD_MELEE" || mod == "MOD_IMPACT") )
	{
		event = "ballistic_knife_death";
	}
	
	if(( isdefined( zombie.deathpoints_already_given ) && zombie.deathpoints_already_given ))
	{
		return;
	}
	
	zombie.deathpoints_already_given = true;
	
	if ( zm_equipment::is_equipment(zombie.damageweapon) )
		return;
	
	if ( IsDefined(attacker) )
	{
		attacker zm_score::player_add_points( event, mod, hit_location, undefined, team, attacker.currentweapon );
	}
	
	if( isdefined(level.sword_power_update))
	{
		[[level.sword_power_update]](attacker, zombie);
	}
}

function get_number_variants(aliasPrefix)
{
		for(i=0; i<100; i++)
		{
			if( !SoundExists( aliasPrefix + "_" + i) )
			{
				//iprintlnbold(aliasPrefix +"_" + i);
				return i;
			}
		}
}	


function dragons_breath_flame_death_fx()
{
	if ( self.isdog )
	{
		return;
	}

	if( !IsDefined( level._effect ) || !IsDefined( level._effect["character_fire_death_sm"] ) )
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_sm\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_zombie_md\"" );
#/
		return;
	}

	PlayFxOnTag( level._effect["character_fire_death_sm"], self, "J_SpineLower" );

	tagArray = []; 
	if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "left_arm" )
	{
		tagArray[tagArray.size] = "J_Elbow_LE";
		tagArray[tagArray.size] = "J_Wrist_LE";
	}
	if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "right_arm" )
	{
		tagArray[tagArray.size] = "J_Elbow_RI";
		tagArray[tagArray.size] = "J_Wrist_RI";
	}
	if( !IsDefined( self.a.gib_ref ) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "left_leg") )
	{
		tagArray[tagArray.size] = "J_Knee_LE";
		tagArray[tagArray.size] = "J_Ankle_LE";
	}
	if( !IsDefined( self.a.gib_ref ) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "right_leg") )
	{
		tagArray[tagArray.size] = "J_Knee_RI";
		tagArray[tagArray.size] = "J_Ankle_RI";
	}

	tagArray = array::randomize( tagArray ); 
	PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] );
}

function zombie_ragdoll_then_explode( launchvector, attacker )
{
	if (!isdefined(self))
		return; 
	
	self zombie_utility::zombie_eye_glow_stop();
	self clientfield::set("zombie_ragdoll_explode", 1);
	self notify( "exploding" );
	self notify( "end_melee" );
	self notify( "death", attacker );
	
	// Physics Launch off Window
	//--------------------------
	self.dont_die_on_me = true;
	self.exploding = true;
	self.a.nodeath = true;
	self.dont_throw_gib = true;
	self StartRagdoll();
    self SetPlayerCollision(0);	
	self zombie_utility::reset_attack_spot();

	if (isdefined(launchvector))
		self LaunchRagdoll( launchvector );
	
	wait 2.1;
	if (isdefined(self))
	{
		self ghost();
		self util::delay( 0.25, undefined, &zm_utility::self_delete );
	}
}



// Called from animscripts\zm_death.gsc
function zombie_death_animscript( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	team = undefined;

	//A zombie died - recalculate zombie array
	zm_utility::recalc_zombie_array();
	
	if(isDefined(self._race_team))
	{
		team = self._race_team;
	}
	
	self zombie_utility::reset_attack_spot();

	if( self check_zombie_death_animscript_callbacks() )
	{
		return false;
	}

	// animscript override
	if( IsDefined( level.zombie_death_animscript_override ) )
	{
		self [ [ level.zombie_death_animscript_override ] ] ();
	}

	self.grenadeAmmo = 0;

	// rsh090710 - nuked zombies don't give points but should still possibly drop powerups
	if ( IsDefined( self.nuked ) )
	{
		if( zombie_can_drop_powerups( self ) )
		{
			// DCS 031611: hack to prevent risers from dropping powerups under the ground.
			if(IsDefined(self.in_the_ground) && self.in_the_ground == true)
			{
				trace = BulletTrace(self.origin + (0, 0, 100), self.origin + (0, 0, -100), false, undefined);
				origin = trace["position"];
				level thread zombie_delay_powerup_drop( origin );
			}
			else
			{	
				trace = GroundTrace(self.origin + (0, 0, 5), self.origin + (0, 0, -300), false, undefined);
				origin = trace["position"];
				level thread zombie_delay_powerup_drop( self.origin );
			}	
		}
	}
	else
	{
		// Give attacker points
		//ChrisP - 12/8/08 - added additional 'self' argument		
		level zombie_death_points( self.origin, self.damagemod, self.damagelocation, self.attacker, self ,team);
	}

	// switch to inflictor when SP DoDamage supports it
	if( isdefined( self.attacker ) && isai( self.attacker ) )
	{
		self.attacker notify( "killed", self );
	}
	

	if( "rottweil72_upgraded" == self.damageweapon.name && "MOD_RIFLE_BULLET" == self.damagemod )
	{
		self thread dragons_breath_flame_death_fx();
	}
	if( "tazer_knuckles" == self.damageweapon.name && "MOD_MELEE" == self.damagemod )
	{
		self.is_on_fire = false;
		self notify("stop_flame_damage");
	}
	if( self.damagemod == "MOD_BURNED" )
	{
		self thread zombie_death::flame_death_fx();
	}
	if( self.damagemod == "MOD_GRENADE" || self.damagemod == "MOD_GRENADE_SPLASH" ) 
	{
		level notify( "zombie_grenade_death", self.origin );
	}

	return false;
}


function check_zombie_death_animscript_callbacks()
{
	if ( !isdefined( level.zombie_death_animscript_callbacks ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_death_animscript_callbacks.size; i++ )
	{
		if ( self [[ level.zombie_death_animscript_callbacks[i] ]]() )
		{
			return true;
		}
	}

	return false;
}


function register_zombie_death_animscript_callback( func )
{
	if ( !isdefined( level.zombie_death_animscript_callbacks ) )
	{
		level.zombie_death_animscript_callbacks = [];
	}

	level.zombie_death_animscript_callbacks[level.zombie_death_animscript_callbacks.size] = func;
}


function damage_on_fire( player )
{
	self endon ("death");
	self endon ("stop_flame_damage");
	wait( 2 );
	
	while( isdefined( self.is_on_fire) && self.is_on_fire )
	{
		if( level.round_number < 6 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.2, 0.3 ); // 20% - 30%
		}
		else if( level.round_number < 9 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.15, 0.25 );
		}
		else if( level.round_number < 11 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.1, 0.2 );
		}
		else
		{
			dmg = level.zombie_health * RandomFloatRange( 0.1, 0.15 );
		}

		if ( Isdefined( player ) && Isalive( player ) )
		{
			self DoDamage( dmg, self.origin, player );
		}
		else
		{
			self DoDamage( dmg, self.origin, level );
		}
		
		wait( randomfloatrange( 1.0, 3.0 ) );
	}
}

function player_using_hi_score_weapon( player )
{
	if( IsPlayer( player) ) //check because robot companion can fire off this function, and internally requires a player
	{
		weapon = player GetCurrentWeapon();
		
		return (weapon == level.weaponNone || weapon.isSemiAuto);
	}
	
	return false;
}

function zombie_damage( mod, hit_location, hit_origin, player, amount, team, weapon )
{
	if( zm_utility::is_magic_bullet_shield_enabled( self ) )
	{
		return;
	}

	//ChrisP - 12/8 - no points for killing gassed zombies!
	player.use_weapon_type = mod;
	if(isDefined(self.marked_for_death))
	{
		return;
	}	

	if( !IsDefined( player ) )
	{
		return; 
	}

	if (isdefined(hit_origin))
		self.damagehit_origin = hit_origin;
	else
		self.damagehit_origin = player GetWeaponMuzzlePoint();

	if ( self check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount, weapon ) )
	{
		return;
	}
	else if ( !player player_can_score_from_zombies() )
	{
		
	}
	else if( self zombie_flame_damage( mod, player ) )
	{
		if( self zombie_give_flame_damage_points() )
		{
			player zm_score::player_add_points( "damage", mod, hit_location, self.isdog,team );
		}
	}
	else
	{
		if( player_using_hi_score_weapon( player ) )
		{
			damage_type = "damage";
		}
		else
		{
			damage_type = "damage_light";
		}

		if ( !( isdefined( self.no_damage_points ) && self.no_damage_points ) )
		{
			player zm_score::player_add_points( damage_type, mod, hit_location, self.isdog, team, weapon );
		}
	}

	if ( IsDefined( self.zombie_damage_fx_func ) )
	{
		self [[ self.zombie_damage_fx_func ]]( mod, hit_location, hit_origin, player );
	}

	if ( "MOD_IMPACT" != mod && zm_utility::is_placeable_mine( weapon ) )
	{
		if ( IsDefined( self.zombie_damage_claymore_func ) )
		{
			self [[ self.zombie_damage_claymore_func ]]( mod, hit_location, hit_origin, player );
		}
		else if ( isdefined( player ) && isalive( player ) )
		{
			self DoDamage( level.round_number * randomintrange( 100, 200 ), self.origin, player, self, hit_location, mod, 0, weapon );
		}
		else
		{
			self DoDamage( level.round_number * randomintrange( 100, 200 ), self.origin, undefined, self, hit_location, mod, 0, weapon );
		}
	}
	else if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
	{
		if ( isdefined( player ) && isalive( player ) )
		{
			player.grenade_multiattack_count++;
			player.grenade_multiattack_ent = self;

			self DoDamage( level.round_number + randomintrange( 100, 200 ), self.origin, player, self, hit_location, mod, 0, weapon );
		}
		else
		{
			self DoDamage( level.round_number + randomintrange( 100, 200 ), self.origin, undefined, self, hit_location, mod, 0, weapon );
		}
	}
	else if( mod == "MOD_PROJECTILE" || mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH" )
	{
		if ( isdefined( player ) && isalive( player ) )
		{
			self DoDamage( level.round_number * randomintrange( 0, 100 ), self.origin, player, self, hit_location, mod, 0, weapon );
		}
		else
		{
			self DoDamage( level.round_number * randomintrange( 0, 100 ), self.origin, undefined, self, hit_location, mod, 0, weapon );
		}
	}
	
	//AUDIO Plays a sound when Crawlers are created
	if( ( isdefined( self.gibbed ) && self.gibbed ))
	{
		if( IsDefined( self.a.gib_ref ) && (self.a.gib_ref == "no_legs") && isalive( self ) )
		{
			if ( isdefined( player ) )
			{
					player zm_audio::create_and_play_dialog( "general", "crawl_spawn" );
			}
		}
		else if( IsDefined( self.a.gib_ref ) && ( (self.a.gib_ref == "right_arm") || (self.a.gib_ref == "left_arm") ) )
		{
			if( !self.missingLegs && isalive( self ) )
			{
				if ( isdefined( player ) )
				{
					rand = randomintrange(0, 100);
					if(rand < 7)
					{
						player zm_audio::create_and_play_dialog( "general", "shoot_arm" );
					}
				}
			}
		}	
	}
	self thread zm_powerups::check_for_instakill( player, mod, hit_location );
}

function zombie_damage_ads( mod, hit_location, hit_origin, player, amount, team, weapon )
{
	
	if( zm_utility::is_magic_bullet_shield_enabled( self ) )
	{
		return;
	}

	player.use_weapon_type = mod;
	if( !IsDefined( player ) )
	{
		return; 
	}

	if (isdefined(hit_origin))
		self.damagehit_origin = hit_origin;
	else
		self.damagehit_origin = player GetWeaponMuzzlePoint();

	
	if ( self check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount, weapon ) )
	{
		return;
	}
	else if ( !player player_can_score_from_zombies() )
	{
	}
	else if( self zombie_flame_damage( mod, player ) )
	{
		if( self zombie_give_flame_damage_points() )
		{			
			player zm_score::player_add_points( "damage_ads", mod, hit_location,undefined,team );
		}
	}
	else
	{
		if( player_using_hi_score_weapon( player ) )
		{
			damage_type = "damage";
		}
		else
		{
			damage_type = "damage_light";
		}

		if ( !( isdefined( self.no_damage_points ) && self.no_damage_points ) )
		{				
			player zm_score::player_add_points( damage_type, mod, hit_location, undefined, team, weapon );
		}
	}

	self thread zm_powerups::check_for_instakill( player, mod, hit_location );
}


function check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount, weapon )
{
	if ( !isdefined( level.zombie_damage_callbacks ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_damage_callbacks.size; i++ )
	{
		if ( self [[ level.zombie_damage_callbacks[i] ]]( mod, hit_location, hit_origin, player, amount, weapon ) )
		{
			return true;
		}
	}

	return false;
}


function register_zombie_damage_callback( func )
{
	if ( !isdefined( level.zombie_damage_callbacks ) )
	{
		level.zombie_damage_callbacks = [];
	}

	level.zombie_damage_callbacks[level.zombie_damage_callbacks.size] = func;
}


function zombie_give_flame_damage_points()
{
	if( GetTime() > self.flame_damage_time )
	{
		self.flame_damage_time = GetTime() + level.zombie_vars["zombie_flame_dmg_point_delay"];
		return true;
	}

	return false;
}

function zombie_flame_damage( mod, player )
{
	if( mod == "MOD_BURNED" )
	{
		if( !IsDefined( self.is_on_fire ) || ( Isdefined( self.is_on_fire ) && !self.is_on_fire ) )
		{
			self thread damage_on_fire( player );
		}

		do_flame_death = true;
		dist = 100 * 100;
		ai = GetAiTeamArray( level.zombie_team );
		for( i = 0; i < ai.size; i++ )
		{
			if( IsDefined( ai[i].is_on_fire ) && ai[i].is_on_fire )
			{
				if( DistanceSquared( ai[i].origin, self.origin ) < dist )
				{
					do_flame_death = false;
					break;
				}
			}
		}

		if( do_flame_death )
		{
			self thread zombie_death::flame_death_fx();
		}

		return true;
	}

	return false;
}

function is_weapon_shotgun( weapon )
{
	return (weapon.weapClass == "spread");
}


//*****************************************************************************
// A zombie has been killed
//*****************************************************************************

function zombie_death_event( zombie )
{
	zombie.marked_for_recycle = 0;

	force_explode = 0;
	force_head_gib = 0;
	
	zombie waittill( "death", attacker);
	time_of_death = gettime();
	
	if(isDefined(zombie))
	{
		zombie StopSounds();
	}

	// The Insta Kill Upgrade - Forces melee deaths on close proximity
	if( IsDefined(zombie) && IsDefined(zombie.marked_for_insta_upgraded_death) )
	{
		force_head_gib = 1;
	}

	if ( !isdefined( zombie.damagehit_origin ) && isdefined( attacker ) && IsAlive( attacker ) && !IsVehicle( attacker ) )
	{
		zombie.damagehit_origin = attacker GetWeaponMuzzlePoint();
	}

	//stat tracking
	if(isDefined(attacker) && isPlayer(attacker) && attacker player_can_score_from_zombies() )
	{
		// Carpenter - Persistent upgrade kills accumulator
		if( ( isdefined( level.pers_upgrade_carpenter ) && level.pers_upgrade_carpenter ) )
		{
			zm_pers_upgrades::pers_zombie_death_location_check( attacker, zombie.origin );
		}

		// Player "sniper" persistent ability tracking
		if( ( isdefined( level.pers_upgrade_sniper ) && level.pers_upgrade_sniper ) )
		{
			attacker zm_pers_upgrades_functions::pers_upgrade_sniper_kill_check( zombie, attacker );
		}

		if(isDefined(zombie) && isDefined(zombie.damagelocation) )
		{
			if( zm_utility::is_headshot( zombie.damageweapon, zombie.damagelocation, zombie.damagemod ))
			{
				attacker.headshots++;
				attacker zm_stats::increment_client_stat( "headshots" );	//headshots
				attacker AddWeaponStat(zombie.damageWeapon, "headshots", 1);
				attacker zm_stats::increment_player_stat( "headshots" );
			
				// Only in classic mode
				if(zm_utility::is_Classic() )
				{
					//track pers upgrade				
					attacker zm_pers_upgrades_functions::pers_check_for_pers_headshot( time_of_death, zombie );
				}
			}
			else
			{
				attacker notify("zombie_death_no_headshot");
			}
			
		}
		if(isDefined(zombie) && isDefined(zombie.damagemod) && zombie.damagemod == "MOD_MELEE")
		{
			attacker zm_stats::increment_client_stat( "melee_kills" );	//melee kills
			attacker zm_stats::increment_player_stat( "melee_kills" );
			attacker notify( "melee_kill" );

			// If the insta_kill - force an explosive death of the zombies
			if( attacker zm_pers_upgrades::is_insta_kill_upgraded_and_active() )
			{
				force_explode = 1;
			}
		}

		attacker demo::add_actor_bookmark_kill_time();
		attacker.kills++;
		attacker zm_stats::increment_client_stat( "kills" );			//total kills
		attacker zm_stats::increment_player_stat( "kills" );

		// Persistent upgrade - pistol points
		if( ( isdefined( level.pers_upgrade_pistol_points ) && level.pers_upgrade_pistol_points ) )
		{
			attacker zm_pers_upgrades_functions::pers_upgrade_pistol_points_kill();
		}
		
		if( isDefined( zombie ) && isDefined( zombie.damageweapon ) )
		{
			attacker AddWeaponStat(zombie.damageWeapon, "kills", 1);
		}
			
		// Check for persistant headshot upgrade and always gib the head no matter if it's a headshot or not
		// Also check for a force head gib
		if(	(attacker zm_pers_upgrades_functions::pers_mulit_kill_headshot_active()) || (force_head_gib) )
		{
			zombie zombie_utility::zombie_head_gib();
		}

		// Player "sniper" persistent ability tracking
		if( ( isdefined( level.pers_upgrade_nube ) && level.pers_upgrade_nube ) )
		{
			attacker notify( "pers_player_zombie_kill" );
		}
	}

	//A zombie died - recalculate zombie array
	zm_utility::recalc_zombie_array();

	// Need to check in case he got deleted earlier
	if ( !IsDefined( zombie ) )
	{
		return;
	}
	
	//Track all zombies killed
	level.global_zombies_killed++;

	//track stats on zombies killed by traps 
	if(isDefined(zombie.marked_for_death) && !isDefined(zombie.nuked))
	{
		level.zombie_trap_killed_count++;
	}
	
	zombie check_zombie_death_event_callbacks();
	
	// Need to check in case he got deleted in the callback
	if ( !IsDefined( zombie ) )
	{
		return;
	}
	
	name = zombie.animname;
	if( isdefined( zombie.sndname ) )
	{
		name = zombie.sndname;
	}
	
	self notify( "bhtn_action_notify", "death" );
	zombie thread zombie_utility::zombie_eye_glow_stop();

	if( IsActor( zombie ) )
	{
		if(	(is_weapon_shotgun( zombie.damageweapon ) && zm_weapons::is_weapon_upgraded( zombie.damageweapon )) ||
		   ( zm_utility::is_placeable_mine( zombie.damageweapon ) )||
		     ( (zombie.damagemod === "MOD_GRENADE") || (zombie.damagemod === "MOD_GRENADE_SPLASH") || (zombie.damagemod === "MOD_EXPLOSIVE") || (force_explode == 1) ) )
		{
			splode_dist = 12 * 15;
			if ( isdefined(zombie.damagehit_origin) && distancesquared(zombie.origin,zombie.damagehit_origin) < splode_dist * splode_dist )
			{
				tag = "J_SpineLower";
				
				
				if ( ( isdefined( zombie.isdog ) && zombie.isdog ) )
				{
					tag = "tag_origin";
				}
				
				if (!( isdefined( zombie.is_on_fire ) && zombie.is_on_fire ) && !( isdefined( zombie.guts_explosion ) && zombie.guts_explosion ))
				{
					zombie thread zombie_utility::zombie_gut_explosion();
				}
				/*
				else if( IsDefined( level._effect[ "zomb_gib" ] ) )
				{
					PlayFX( level._effect[ "zomb_gib" ], zombie GetTagOrigin( tag ) );
				}
				*/
			}
		}

		if ( zombie.damagemod === "MOD_GRENADE" || zombie.damagemod === "MOD_GRENADE_SPLASH" )
		{
			if ( isdefined( attacker ) && isalive( attacker ) )
			{
				attacker.grenade_multiattack_count++;
				attacker.grenade_multiattack_ent = zombie;
			}
		}
	}
	
	// this is controlling killstreak voice over in the asylum.gsc
	if ( !( isdefined( zombie.has_been_damaged_by_player ) && zombie.has_been_damaged_by_player ) && ( isdefined( zombie.marked_for_recycle ) && zombie.marked_for_recycle ))
	{
		level.zombie_total++;
		level.zombie_total_subtract++;
	}
	else if(isdefined (zombie.attacker) && isplayer(zombie.attacker) )
	{
		
		//this tracks the zombies killed by a player for stat tracking
		level.zombie_player_killed_count++;		
		
		if ( IsDefined( zombie.sound_damage_player ) && zombie.sound_damage_player == zombie.attacker )
		{	
			zombie.attacker zm_audio::create_and_play_dialog( "kill", "damage" );	
		}

		zombie.attacker notify( "zom_kill", zombie );
	}
	else
	{
		if(zombie.ignoreall && !( isdefined( zombie.marked_for_death ) && zombie.marked_for_death )  )
		{
			level.zombies_timeout_spawn++;
		}
	}
		
	level notify( "zom_kill" );
	level.total_zombies_killed++;
}

//*****************************************************************************
//*****************************************************************************

function check_zombie_death_event_callbacks()
{
	if ( !isdefined( level.zombie_death_event_callbacks ) )
	{
		return;
	}

	for ( i = 0; i < level.zombie_death_event_callbacks.size; i++ )
	{
		self [[ level.zombie_death_event_callbacks[i] ]]();
	}
}


function register_zombie_death_event_callback( func )
{
	if ( !isdefined( level.zombie_death_event_callbacks ) )
	{
		level.zombie_death_event_callbacks = [];
	}

	level.zombie_death_event_callbacks[level.zombie_death_event_callbacks.size] = func;
}

function deregister_zombie_death_event_callback( func )
{
	if (isdefined( level.zombie_death_event_callbacks ) )
	{
		ArrayRemoveValue(level.zombie_death_event_callbacks,func);
	}	
}


// this is where zombies go into attack mode, and need different attributes set up
function zombie_setup_attack_properties()
{
	self zombie_history( "zombie_setup_attack_properties()" );

	// allows zombie to attack again
	self.ignoreall = false; 

	// push the player out of the way so they use traversals in the house.
	//self PushPlayer( true ); 

//	self.pathEnemyFightDist = 64;	//set in gdt now
	self.meleeAttackDist = 64;
	
	//try to prevent always turning towards the enemy
	self.maxsightdistsqrd = 128 * 128;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 
}


//this lets them wake up and go after things like the monkey bomb immediately
function attractors_generated_listener()
{
	self endon( "death" );
	level endon( "intermission" );
	self endon( "stop_find_flesh" );
	self endon( "path_timer_done" );

	level waittill( "attractor_positions_generated" );
	self.zombie_path_timer = 0;
}


function zombie_pathing()
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	level endon( "intermission" );

	assert( IsDefined( self.favoriteenemy ) || IsDefined( self.enemyoverride ) );
	
	self._skip_pathing_first_delay = true;
	self thread zombie_follow_enemy();
	self waittill( "bad_path" );
	
	level.zombie_pathing_failed ++;
	
	//If we get here then we have a bad path and the zombie can't use the regular pathing system to find the player
	//.....  crap!
	
	if( isDefined( self.enemyoverride ) ) 
	{
		zm_utility::debug_print( "Zombie couldn't path to point of interest at origin: " + self.enemyoverride[0] + " Falling back to breadcrumb system" );
		if( isDefined( self.enemyoverride[1] ) )
		{
			self.enemyoverride = self.enemyoverride[1] zm_utility::invalidate_attractor_pos( self.enemyoverride, self );
			self.zombie_path_timer = 0;
			return;
		}
	}
	else
	{
		if(isDefined(self.favoriteenemy))
		{
			zm_utility::debug_print( "Zombie couldn't path to player at origin: " + self.favoriteenemy.origin + " Falling back to breadcrumb system" );
		}
		else
		{
			zm_utility::debug_print( "Zombie couldn't path to a player ( the other 'prefered' player might be ignored for encounters mode ). Falling back to breadcrumb system" );
		}
	}
	
	if( !isDefined( self.favoriteenemy ) )
	{
		self.zombie_path_timer = 0;
		return;
	}
	else
	{
		self.favoriteenemy endon( "disconnect" );
	}
	
	//this is for selecting the valid player from the player to use for tracking purposes.
	players = GetPlayers();
	valid_player_num = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( zm_utility::is_player_valid( players[i], true ) ) 
		{
			valid_player_num += 1;
		}
	}
	//PI_CHANGE_BEGIN - 7/2/2009 JV Reenabling change 274916 (from DLC3)
	if( players.size > 1 )
	{
		if(isDefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]() )
		{
			self.zombie_path_timer = 0;
			return;	
		}
		if( !IsInArray( self.ignore_player, self.favoriteenemy) )
		{
			self.ignore_player[self.ignore_player.size] = self.favoriteenemy;
		}

		if( self.ignore_player.size < valid_player_num )
		{
			self.zombie_path_timer = 0;
			return;
		}
	}
	//PI_CHANGE_END

	crumb_list = self.favoriteenemy.zombie_breadcrumbs;
	bad_crumbs = [];
	
	while( 1 )
	{
		if( !zm_utility::is_player_valid( self.favoriteenemy, true ) )
		{
			self.zombie_path_timer = 0;
			return;
		}

		goal = zombie_pathing_get_breadcrumb( self.favoriteenemy.origin, crumb_list, bad_crumbs, ( RandomInt( 100 ) < 20 ) );
		
		if ( !IsDefined( goal ) )
		{
			zm_utility::debug_print( "Zombie exhausted breadcrumb search" );
			
			//zombies failed to get breadcrumbs
			level.zombie_breadcrumb_failed ++;
			
			goal = self.favoriteenemy.spectator_respawn.origin;
		}

		zm_utility::debug_print( "Setting current breadcrumb to " + goal );

		self.zombie_path_timer += 100;
		self SetGoal( goal );
		self waittill( "bad_path" );

		zm_utility::debug_print( "Zombie couldn't path to breadcrumb at " + goal + " Finding next breadcrumb" );
		for( i = 0; i < crumb_list.size; i++ )
		{
			if( goal == crumb_list[i] )
			{
				bad_crumbs[bad_crumbs.size] = i;
				break;
			}
		}
	}
}

function zombie_pathing_get_breadcrumb( origin, breadcrumbs, bad_crumbs, pick_random )
{
	assert( IsDefined( origin ) );
	assert( IsDefined( breadcrumbs ) );
	assert( IsArray( breadcrumbs ) );

	/#
		if ( pick_random )
		{
			zm_utility::debug_print( "Finding random breadcrumb" );
		}
	#/
			
	for( i = 0; i < breadcrumbs.size; i++ )
	{
		if ( pick_random )
		{
			crumb_index = RandomInt( breadcrumbs.size );
		}
		else
		{
			crumb_index = i;
		}
				
		if( crumb_is_bad( crumb_index, bad_crumbs ) )
		{
			continue;
		}

		return breadcrumbs[crumb_index];
	}

	return undefined;
}

function crumb_is_bad( crumb, bad_crumbs )
{
	for ( i = 0; i < bad_crumbs.size; i++ )
	{
		if ( bad_crumbs[i] == crumb )
		{
			return true;
		}
	}

	return false;
}

function jitter_enemies_bad_breadcrumbs( start_crumb )
{
	trace_distance = 35;
	jitter_distance = 2;
	
	index = start_crumb;
	
	while (isdefined(self.favoriteenemy.zombie_breadcrumbs[ index + 1 ]))
	{
		current_crumb = self.favoriteenemy.zombie_breadcrumbs[ index ];
		next_crumb = self.favoriteenemy.zombie_breadcrumbs[ index + 1 ];
		
		angles = vectortoangles(current_crumb - next_crumb);
		
		right = anglestoright(angles);
		left = anglestoright(angles + (0,180,0));
		
		dist_pos = current_crumb + VectorScale( right, trace_distance );
		
		trace = bulletTrace( current_crumb, dist_pos, true, undefined );
		vector = trace["position"];
		
		if (distance(vector, current_crumb) < 17 )
		{
			self.favoriteenemy.zombie_breadcrumbs[ index ] = current_crumb + VectorScale( left, jitter_distance );
			continue;
		}
		
		
		// try the other side
		dist_pos = current_crumb + VectorScale( left, trace_distance );
		
		trace = bulletTrace( current_crumb, dist_pos, true, undefined );
		vector = trace["position"];
		
		if (distance(vector, current_crumb) < 17 )
		{
			self.favoriteenemy.zombie_breadcrumbs[ index ] = current_crumb + VectorScale( right, jitter_distance );
			continue;
		}
		
		index++;
	}
	
}

function zombie_repath_notifier()
{
	note = 0;

	notes = [];
	
	for(i = 0; i < 4; i ++)
	{
		notes[notes.size] = "zombie_repath_notify_"+i;
	}
	
	while(1)
	{
		level notify(notes[note]);
		
		note = (note + 1) % 4;
		{wait(.05);};
	}
}

function zombie_follow_enemy()
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	self endon( "bad_path" );
	
	level endon( "intermission" );

	if(!isdefined(level.repathNotifierStarted))
	{
		level.repathNotifierStarted = true;
		
		level thread zombie_repath_notifier();
	}

	if(!isdefined(self.zombie_repath_notify))
	{
		self.zombie_repath_notify = "zombie_repath_notify_" + (self getentitynumber() % 4);
	}
	
	while( 1 )
	{
		if(!isdefined(self._skip_pathing_first_delay))
		{
			level waittill(self.zombie_repath_notify);
		}
		else
		{
			self._skip_pathing_first_delay = undefined;
		}
		
		if( !( isdefined( self.ignore_enemyoverride ) && self.ignore_enemyoverride ) && isDefined( self.enemyoverride ) && isDefined( self.enemyoverride[1] ) )
		{
			if( distanceSquared( self.origin, self.enemyoverride[0] ) > 1*1 )
			{
				self OrientMode( "face motion" );
			}
			else
			{
				self OrientMode( "face point", self.enemyoverride[1].origin );
			}
			self.ignoreall = true;

			goalPos = self.enemyoverride[0];
			if ( IsDefined( level.adjust_enemyoverride_func ) )
			{
				goalPos = self [[ level.adjust_enemyoverride_func ]]();
			}
			self SetGoal( goalPos );
		}
		else if( IsDefined( self.favoriteenemy ) )
		{
			self.ignoreall = false;

			//TEMP Just to get us running for the playtest.  Need to kill this whole function later.
			if ( IsDefined( level.enemy_location_override_func ) )
			{
				goalPos = [[ level.enemy_location_override_func ]]( self, self.favoriteenemy );
	
				if ( IsDefined( goalPos ) )
				{
					self SetGoal( goalPos );
				}
				else
				{
					self zm_behavior::zombieUpdateGoal();
				}
			}
			else if( ( isdefined( self.is_rat_test ) && self.is_rat_test ) )
			{
			}
			else if ( zm_behavior::zombieShouldMoveAwayCondition( self ) )
			{
				{wait(.05);};
				continue;
			}
			else if ( IsDefined( self.favoriteenemy.last_valid_position ) )
			{
				self SetGoal( self.favoriteenemy.last_valid_position );		
			}
			else
			{
				//AssertMsg( "no last_valid_position" );
			}

			if ( !IsDefined( level.ignore_path_delays ) )
			{
				distSq = distanceSquared( self.origin, self.favoriteenemy.origin );
			
				if( distSq > 3200 * 3200 )
				{
					wait(2.0 + randomFloat( 1.0 ));
				}
				else if( distSq > 2200 * 2200 )
				{
					wait(1.0 + randomFloat( 0.5 ));
				}
				else if( distSq > 1200 * 1200 )
				{
					wait(0.5 + randomFloat( 0.5 ));
				}
			}
		}

		// LDS - changed this from a level specific catch function to a general one that can be overloaded based
		//       on the conditions in a level that can render a player inaccessible to zombies.
		if( isDefined( level.inaccesible_player_func ) )
		{
			self [[ level.inaccessible_player_func ]]();
		}
	}
}

//
// DEBUG
//

function zombie_history( msg )
{
/#
	if( !IsDefined( self.zombie_history ) || 32 <= self.zombie_history.size ) // don't blow out the script var max
	{
		self.zombie_history = [];
	}

	self.zombie_history[self.zombie_history.size] = msg;
#/
}

function do_zombie_spawn()
{
	self endon("death");

	spots = [];

	// special case, seems to appear in gamemodules. 
	if(isDefined(self._rise_spot))
	{
		spot = self._rise_spot;
		self thread do_zombie_rise(spot);
		return;
	}
	
	// add spawner locations
	if ( ( isdefined( level.use_multiple_spawns ) && level.use_multiple_spawns ) && isdefined( self.script_int ) )
	{
		foreach( loc in level.zm_loc_types[ "zombie_location" ] )
		{
			if ( !(IsDefined( level.spawner_int ) && (level.spawner_int == self.script_int)) &&
			    !(IsDefined( loc.script_int ) || IsDefined( level.zones[ loc.zone_name ].script_int )) )
			{
				continue;
			}

			if ( IsDefined( loc.script_int ) && ( loc.script_int != self.script_int ) )
			{
				continue;
			}
			else if ( IsDefined( level.zones[ loc.zone_name ].script_int ) && ( level.zones[ loc.zone_name ].script_int != self.script_int ) )
			{
				continue;
			}
			
			spots[spots.size] = loc;
		}	
	}
	else
	{
		spots = level.zm_loc_types[ "zombie_location" ];
	}
	
		if ( GetDvarInt("scr_zombie_spawn_in_view") )
		{
			player = GetPlayers()[0];
			spots = [];
			max_dot = 0;
			look_loc = undefined;
			foreach ( loc in level.zm_loc_types[ "zombie_location" ] )
			{
				player_vec = VectorNormalize( AnglesToForward( player GetPlayerAngles() ) );
				player_vec_2d = ( player_vec[0], player_vec[1], 0 );
				player_spawn = VectorNormalize( loc.origin - player.origin );
				player_spawn_2d = ( player_spawn[0], player_spawn[1], 0 );
				dot = VectorDot( player_vec_2d, player_spawn_2d );
				dist = Distance( loc.origin, player.origin );
				if ( dot > 0.707 && dist <= GetDvarInt( "scr_zombie_spawn_in_view_dist" ) )
				{
					if ( dot > max_dot )
					{
						look_loc = loc;
						max_dot = dot;
					}
					//spots[spots.size] = loc;
					/# debugstar( loc.origin, 1000, ( 1, 1, 1 ) ); #/
				}
			}

			if ( isdefined( look_loc ) )
			{
				spots[ spots.size ] = look_loc;
				/# debugstar( look_loc.origin, 1000, ( 0, 1, 0 ) ); #/
			}

			if ( spots.size <= 0 )
			{
				spots[spots.size] = level.zm_loc_types[ "zombie_location" ][0];
				iprintln( "no spawner in view" );
			}
		}

	assert( spots.size > 0, "No spawn locations found" );
	
	spot = array::random(spots);
	self.spawn_point = spot;
	
	
/#
	//Increment this spawn counter
	if( GetDvarInt("zombiemode_debug_zones") )
	{
		level.zones[spot.zone_name].total_spawn_count++;
		level.zones[spot.zone_name].round_spawn_count++;
		self.zone_spawned_from = spot.zone_name;
		self thread draw_zone_spawned_from();
	}
#/
	
	/#
	
	if( ( isdefined( level.toggle_show_spawn_locations ) && level.toggle_show_spawn_locations ) )
	{
		debugstar( spot.origin, GetDvarInt( "scr_spawner_location_time" ), ( 0, 1, 0 ) );
		host_player = util::GetHostPlayer();
		distance = Distance( spot.origin, host_player.origin );
		IPrintLn( "Distance to player: " + distance/12 + "feet" );
	}
	
	#/
	
	self thread [[level.move_spawn_func]](spot);
}

function draw_zone_spawned_from()
{
/#
	self endon( "death" ); 
	while( 1 )
	{
		print3d( self.origin +( 0, 0, 64 ), self.zone_spawned_from, ( 1, 1, 1 ) ); 
		{wait(.05);}; 
	}
#/
}


function do_zombie_rise(spot)
{	
	self endon("death");

	self.in_the_ground = true;

	if ( IsDefined( self.anchor ) )
	{
		self.anchor Delete();
	}
	
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	if( !isDefined( spot.angles ) )
	{
		spot.angles = (0, 0, 0);
	}

	anim_org = spot.origin;
	anim_ang = spot.angles;

	anim_org = anim_org + (0, 0, 0);	// start the animation 45 units below the ground

	//self Teleport(anim_org, anim_ang);

	self Ghost();
	self.anchor moveto(anim_org, .05);
	self.anchor waittill("movedone");

	// face goal
	target_org = zombie_utility::get_desired_origin();
	if (IsDefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), .05);
		self.anchor waittill("rotatedone");
	}

	self unlink();
	
	if(isDefined(self.anchor))
	{
		self.anchor delete();
	}

	self thread zombie_utility::hide_pop();	// hack to hide the pop when the zombie gets to the start position before the anim starts

	level thread zombie_utility::zombie_rise_death(self, spot);
	spot thread zombie_rise_fx(self);

	substate = 0;
	if ( self.zombie_move_speed == "walk" )
	{
		substate = RandomInt( 2 );
	}
	else if ( self.zombie_move_speed == "run" )
	{
		substate = 2;
	}
	else if ( self.zombie_move_speed == "sprint" )
	{
		substate = 3;
	}

	self OrientMode( "face default" );
	
	if( isdefined( level.custom_riseanim ) )
	{
		self AnimScripted( "rise_anim", self.origin, self.angles, level.custom_riseanim );	
	}
	else
	{
		self AnimScripted( "rise_anim", self.origin, self.angles, "ai_zombie_traverse_ground_climbout_fast" );		
	}
	//self AnimScripted( self.origin, spot.angles, "zm_rise", substate );
	self zombie_shared::DoNoteTracks( "rise_anim", &zombie_utility::handle_rise_notetracks, spot );

	self notify("rise_anim_finished");
	spot notify("stop_zombie_rise_fx");
	self.in_the_ground = false;
	self notify("risen", spot.script_string );
}

/*
function zombie_rise_fx:	 self is the script struct at the rise location
function Play the fx as the zombie crawls out of the ground and thread another function to handle the dust falling
function off when the zombie is out of the ground.
*/
function zombie_rise_fx(zombie)
{
	
	if(!( isdefined( level.riser_fx_on_client ) && level.riser_fx_on_client ))
	{
		self thread zombie_rise_dust_fx(zombie);
		self thread zombie_rise_burst_fx(zombie);
	}
	else
	{
		self thread zombie_rise_burst_fx(zombie);
	}
	zombie endon("death");
	self endon("stop_zombie_rise_fx");
	wait 1;
	if (zombie.zombie_move_speed != "sprint")
	{
		// wait longer before starting billowing fx if it's not a really fast animation
		wait 1;
	}
}

function zombie_rise_burst_fx(zombie)
{
	self endon("stop_zombie_rise_fx");
	self endon("rise_anim_finished");
	
	if(IsDefined(self.script_parameters) && self.script_parameters == "in_water" && (!( isdefined( level._no_water_risers ) && level._no_water_risers )) )
	{
			zombie clientfield::set("zombie_riser_fx_water", 1);
	}
	else if(IsDefined(self.script_parameters) && self.script_parameters == "in_foliage" && (( isdefined( level._foliage_risers ) && level._foliage_risers )) )
	{
			zombie clientfield::set("zombie_riser_fx_foliage", 1);
	}
	else if(IsDefined(self.script_parameters) && self.script_parameters == "in_snow")
	{
	
		// this needs to have "level.riser_type = "snow" set in the level script to work properly in snow levels!
		zombie clientfield::set("zombie_riser_fx", 1);
	}
	else 
	{
		if(isDefined(zombie.zone_name ) && isDefined(level.zones[zombie.zone_name]) )
		{
			low_g_zones = getentarray(zombie.zone_name,"targetname");
			
			if(isDefined(low_g_zones[0].script_string) && low_g_zones[0].script_string == "lowgravity")
			{
				zombie clientfield::set("zombie_riser_fx_lowg", 1);
			}
			else
			{

				zombie clientfield::set("zombie_riser_fx", 1);

			}
		}
		else
		{

			zombie clientfield::set("zombie_riser_fx", 1);

		}
	}	
}

function zombie_rise_dust_fx(zombie)
{
	dust_tag = "J_SpineUpper";
	
	self endon("stop_zombie_rise_dust_fx");
	self thread stop_zombie_rise_dust_fx(zombie);
	wait(2);
	dust_time = 5.5; // play dust fx for a max time
	dust_interval = .3; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	//TODO - add rising dust stuff ere
	if(IsDefined(self.script_string) && self.script_string == "in_water")
	{

		for (t = 0; t < dust_time; t += dust_interval)
		{
			PlayfxOnTag(level._effect["rise_dust_water"], zombie, dust_tag);
			wait dust_interval;
		}

	}
	else if(IsDefined(self.script_string) && self.script_string == "in_snow")
	{

		for (t = 0; t < dust_time; t += dust_interval)
		{
			PlayfxOnTag(level._effect["rise_dust_snow"], zombie, dust_tag);
			wait dust_interval;
		}

	}
	else if(IsDefined(self.script_string) && self.script_string == "in_foliage")
	{

		for (t = 0; t < dust_time; t += dust_interval)
		{
			PlayfxOnTag(level._effect["rise_dust_foliage"], zombie, dust_tag);
			wait dust_interval;
		}

	}
	else
	{
		for (t = 0; t < dust_time; t += dust_interval)
		{
		PlayfxOnTag(level._effect["rise_dust"], zombie, dust_tag);
		wait dust_interval;
		}
	}
}

function stop_zombie_rise_dust_fx(zombie)
{
	zombie waittill("death");
	self notify("stop_zombie_rise_dust_fx");
}

// for now only regular zombies can head gib from the tesla
function zombie_tesla_head_gib()
{
	self endon("death");
	
	if(self.animname == "quad_zombie")
	{
		return;
	}	
	
	if( RandomInt( 100 ) < level.zombie_vars["tesla_head_gib_chance"] )
	{
		wait( randomfloatrange( 0.53, 1.0 ) );
		self zombie_utility::zombie_head_gib();
	}
	else
	{
		zm_net::network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect["tesla_shock_eyes"], self, "J_Eyeball_LE" );
	}
}

function play_ambient_zombie_vocals()
{
    self endon( "death" );
    
    if( self.animname == "monkey_zombie" || ( isdefined( self.is_avogadro ) && self.is_avogadro ) )
	{
        return;
	}
    
    while(1)
    {
        type = "ambient";
        float = 2;
        
        if( !IsDefined( self.zombie_move_speed ) )
        {
            wait(.5);
            continue;
        }
        
        switch(self.zombie_move_speed)
	    {
			case "walk":    type="ambient"; float=4;    break;
			case "run":     type="sprint";  float=4;    break;
			case "sprint":  type="sprint";  float=4;    break;
		}
		
		if( self.animname == "zombie" && self.missingLegs )
		{
		    type = "crawler";
		}
		else if( self.animname == "thief_zombie" || self.animname == "leaper_zombie" )
		{
		    float = 1.2;
		}
		else if( self.voicePrefix == "keeper" )
		{
		    float = 1.2;
		}
		
		name = self.animname;
		if( isdefined( self.sndname ) )
		{
			name = self.sndname;
		}
		
		
		self notify( "bhtn_action_notify", type );
		
		wait(RandomFloatRange(1,float));
    }
}

function zombie_complete_emerging_into_playable_area()
{
	self.should_turn = false;
	self.completed_emerging_into_playable_area = true;
	self notify( "completed_emerging_into_playable_area" );
	self.no_powerups = false;
	if( IsDefined( self.backedUpGoal ) )
	{
		self SetGoal( self.backedUpGoal );
		self.backedUpGoal = undefined;
	}
	self thread zombie_free_cam_allowed();
	self thread zombie_push();
	self thread zm::update_zone_name();
}

function zombie_free_cam_allowed()
{
	self endon( "death" );

	wait( 1.5 );
	if ( !IsDefined( self ) )
	{
		return;
	}
	self SetFreeCameraLockOnAllowed( true );
}

function zombie_push()
{
	self endon( "death" );

	wait( 5 );
	if ( !IsDefined( self ) )
	{
		return;
	}
	self PushActors( true );
}

