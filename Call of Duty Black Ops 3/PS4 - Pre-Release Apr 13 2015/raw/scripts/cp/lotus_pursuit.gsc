#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\lotus_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "lui_menu", "TmpBSPLoadIGC" );//TODO - remove once we get the anims
#precache( "lui_menu", "drone_pip" );
#precache( "string", "cairotroops" );

/////////////////////////////////////////////////////////////////////////////////////////////////
// SKIPTO: stand_down
/////////////////////////////////////////////////////////////////////////////////////////////////
function stand_down_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		a_delete = GetEntArray( "aigroup_detention_center", "script_aigroup" );
		array::delete_all( a_delete );
		
		level thread lotus_util::juiced_shotgun_trigger_setup();
		
		trigger::wait_till( "trig_stand_down_start", "targetname", level.ai_hendricks );
	}
	
	// TODO: will add back later
//	level.players[0] dialog::say( "kane_done_the_door_is_unl_0" );

	level thread scene::play( "pursuit_initial_bodies" );
	
	GetEnt( "stand_down_door", "targetname" ) MoveZ( 90, 0.25, .1, .1 );
	
	scene::add_scene_func( "cin_lot_08_01_standdown_1st_detention", &stand_down_setup );
	scene::play( "cin_lot_08_01_standdown_1st_detention" );
	
	remove_prometheus_window_clip();
	
	foreach ( player in level.players )
	{
		player SetLowReady( false );
	}
	
	
	wait_for_standdown_robos_deaths();
	
	skipto::objective_completed( "stand_down" );
}

function wait_for_standdown_robos_deaths()
{
	//[RY 04.01.15] We want to check when 4 robots all die here, so we can trigger to move Hendricks to the next area.
	spawner::waittill_ai_group_cleared( "standdown_robos" );
	t_continue_hendricks = GetEnt("continue_hendricks", "targetname");
	if (isdefined(t_continue_hendricks)) {
		trigger::use("continue_hendricks", "targetname");
	}
}

function stand_down_setup( a_ents )
{
	foreach ( player in level.players )
	{
		player SetLowReady( true );
	}
	
	wait 16; // TODO: replace this with notetrack
	
	stand_down_robot_setup( a_ents );
}

function stand_down_robot_setup( a_ents )
{
	foreach ( ai_in_scene in a_ents )
	{
		if ( ai_in_scene.archetype === "robot" )
		{
			if ( ai_in_scene.animname === "standdown_robot04" )
			{
				ai_in_scene ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
			}
			else
			{
				ai_in_scene ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
			}
		}
	}
}

function remove_prometheus_window_clip()
{
	e_prometheus_window = GetEnt( "prometheus_window", "targetname" );
	if( isdefined( e_prometheus_window ) )
	{
		e_prometheus_window Delete();
	}
}

function stand_down_done( str_objective, b_starting, b_direct, player )
{
	IPrintLnBold ("DEBUG: Stand Down Done!");
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// SKIPTO: pursuit
/////////////////////////////////////////////////////////////////////////////////////////////////
function main( str_objective, b_starting )
{
	if ( b_starting )
	{		
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		level thread lotus_util::juiced_shotgun_trigger_setup();
		level thread scene::play( "pursuit_initial_bodies" );
		
		GetEnt( "stand_down_door", "targetname" ) MoveZ( 90, 0.25, .1, .1 );
		
		level flag::wait_till( "first_player_spawned" );
		
		scene::add_scene_func( "cin_lot_08_01_standdown_1st_detention", &stand_down_robot_setup );
		scene::skipto_end( "cin_lot_08_01_standdown_1st_detention", undefined, undefined, 0.85 );
		
		remove_prometheus_window_clip();
		
		wait_for_standdown_robos_deaths();
	}
	
	lotus_util::spawn_funcs_generic_rogue_control();
	
	// specific for pursuit
	spawner::add_spawn_function_group( "prometheus", "script_noteworthy", &pursuit_prometheus_setup );
	spawner::add_spawn_function_group( "pursuit_robot_level_2_a", "script_noteworthy", &prometheus_turning_robots, "trig_turn_set_a" );
	spawner::add_spawn_function_group( "pursuit_robot_level_2_b", "script_noteworthy", &prometheus_turning_robots, "trig_turn_set_b", true );
	spawner::add_spawn_function_group( "pursuit_robot_level_2_b", "script_noteworthy", &pursuit_set_b_logic );
	spawner::add_spawn_function_group( "pursuit_robot_before", "script_noteworthy", &robots_before_turning );
	spawner::add_spawn_function_group( "pursuit_robot_ambient", "script_noteworthy", &pursuit_ambient_robot );
	spawner::add_spawn_function_group( "pursuit_human_b", "script_noteworthy", &pursuit_set_b_logic );
	
	level flag::init( "prometheus_spawned" );
	
	level thread thrown_by_robot();
	
	trigger::wait_till( "pursuit_pip" );
	
	level thread lui::play_movie( "cairotroops", "pip" );

	trigger::wait_till( "pursuit_done" );
	
	skipto::objective_completed( "pursuit" );
}

// self == prometheus
function pursuit_prometheus_setup()
{
	level.ai_prometheus = self;
	
	level flag::set( "prometheus_spawned" );
	
	self util::magic_bullet_shield();
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self.goalradius = 64;
	
	trigger::wait_till( "trig_turn_set_b" );
	
	self.team = "team3";
	
	level thread pursuit_ai_wall_clip_logic();
	
	self waittill( "goal" );
	
	self Delete();
}

function pursuit_ai_wall_clip_logic()
{
	mdl_clip = GetEnt( "pursuit_wall_clip", "targetname" );
	mdl_clip MoveTo( mdl_clip.origin + ( 0, 0, -192 ), 2 );
	
	trigger::wait_till( "trig_delete_pursuit_wall_clip" );
	
	mdl_clip Delete();
}

// self == robot
function prometheus_turning_robots( str_trigger, b_sprint = false )
{
	self endon( "death" );
	
	level flag::wait_till( "prometheus_spawned" );
	
	self.goalradius = 512;
	self thread ai::shoot_at_target( "normal", level.ai_prometheus );
	
	if ( b_sprint )
	{
		self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
	}
	
	trigger::wait_till( str_trigger );
	
	self ai::set_behavior_attribute( "rogue_control", "level_2" );
}

// self == robot
function robots_before_turning()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
	self.goalradius = 64;
	
	self waittill( "goal" );
	
	self Delete();
}

// self == robot
function pursuit_ambient_robot()
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	
	spawner::waittill_ai_group_cleared( "pursuit_human_ambient" );
	
	nd_destination = GetNode( self.target, "targetname" );
	self ai::set_behavior_attribute( "rogue_control_force_goal", nd_destination.origin );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );

	self waittill( "goal" );
	
	self Delete();
}

// self == enemy
function pursuit_set_b_logic()
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "can_initiateaivsaimelee", false );
	self.overrideActorDamage = &pursuit_set_b_damage_override;
	
	level flag::wait_till( "end_set_b_fight" );
	
	if ( !IsDefined( self.b_in_animation ) )
	{
		self.b_end_fight = true;
		self ClearGoalVolume();
	}
}

// self == enemy
function pursuit_set_b_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if ( self.b_end_fight === true && self.archetype == "human")
	{
		n_damage = self.health;
	}
	else if ( !IsPlayer( e_inflictor ) )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

function thrown_by_robot()
{
	trigger::wait_till( "trig_turn_set_b" );
	
	level flag::wait_till( "set_b_human_spawned" );
	
	nd_death = GetNode( "death_by_robot_throw", "script_noteworthy" );
	
	a_enemies = GetAIArray( "pursuit_human_b", "script_noteworthy" );
	ai_human = array::get_closest( nd_death.origin, a_enemies );
	if ( IsAlive( ai_human ) )
	{
		ai_human ai::set_ignoreme( true );
		ai_human SetGoal( nd_death, true );
		ai_human.b_in_animation = true;
		ai_human.goalradius = 64;
		ai_human waittill( "goal" );
		
		level flag::wait_till( "can_play_throw_scene" );
		
		a_enemies = GetAIArray( "pursuit_robot_level_2_b", "script_noteworthy" );
		ai_robot = array::get_closest( nd_death.origin, a_enemies );
		if ( IsAlive( ai_robot ) && IsAlive( ai_human ) )
		{
			ai_robot ai::set_ignoreall( true );
			ai_robot ai::set_ignoreme( true );
			ai_robot ai::set_behavior_attribute( "rogue_control_speed", "run" );
			ai_robot.b_in_animation = true;
			
			a_enemies = array( ai_human, ai_robot );
			scene::play( "cin_gen_melee_robot_choke_throw_do_reach", a_enemies );
			
			if ( IsAlive( ai_robot ) )
			{
				ai_robot.b_end_fight = true;
				ai_robot ai::set_ignoreall( false );
				ai_robot ai::set_ignoreme( false );
				ai_robot ClearGoalVolume();
			}
		}
	}
}

function pursuit_done( str_objective, b_starting, b_direct, player )
{
}
