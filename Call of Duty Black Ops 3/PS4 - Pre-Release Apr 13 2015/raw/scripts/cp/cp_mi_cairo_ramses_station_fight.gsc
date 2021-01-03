#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\clientfield_shared;
#using scripts\cp\_dialog;
#using scripts\shared\math_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                    

#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_oed;

#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_sound;
#using scripts\cp\cp_mi_cairo_ramses_level_start;
#using scripts\cp\cp_mi_cairo_ramses_vtol_ride;
#using scripts\cp\cp_mi_cairo_ramses_utility;
#using scripts\cp\cp_mi_cairo_ramses_station_walk;
#using scripts\cp\cp_mi_cairo_ramses_nasser_interview;

#using scripts\shared\ai\robot_phalanx;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	           	              	           	                                                                                                                                                                                                                                                                                             

#precache( "objective", "cp_level_ramses_defend_station" );
#precache( "objective", "cp_level_ramses_exit_station" );
#precache( "objective", "cp_level_ramses_kill" ); // UNDONE: will need to set this up for AI taking turret over when geo is locked down
#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_PULL_BODY" );

#precache( "model", "p7_debris_junkyard_scrap_pile_02" );
#precache( "model", "p7_debris_junkyard_scrap_pile_01" );
#precache( "model", "p7_debris_drywall_chunks_pile_07" );

#namespace station_fight;

function init( str_objective, b_starting )
{
	// Init flags
	// "script_flag_set"/"station_fight_body_pull_scene_completed"
	// "script_flag_set"/"station_fight_gather_reached"
	// "script_flag_set"/"station_fight_interview_room_opened"
	// "script_flag_true"/"station_fight_completed"
	// "script_flag_true"/"station_fight_reached"

	callback::remove_on_spawned( &level_start::setup_players_for_station_walk );
	
	spawner::add_spawn_function_group( "station_fight_scene_robot", "script_noteworthy", &entry_anim_spawnfunc );
	spawner::add_spawn_function_group( "station_fight_balcony_turret_steal_robot", "targetname", &robot_turret_spawnfunc );
//	spawner::add_spawn_function_group( "station_fight_raps_kill_turret_guy", "targetname", &raps_kill_turret_guy_spawnfunc );
//	vehicle::add_spawn_function( "station_fight_raps_vtol", &vtol_spawnfunc ); //TODO: DELETE
	
	spawner::add_spawn_function_group( "initial_station_fight_ai", "script_noteworthy", &ramses_util::magic_bullet_shield_till_notify, "reached_ceiling_collapse", true );
	//TODO: write function for giving individual fights magic bullet shield until... a lookat trigger... or something
	//spawner::add_spawn_function_group( "initial_station_fight_ai", "script_noteworthy", &ramses_util::magic_bullet_shield_till_notify, "reached_ceiling_collapse", true );
	
	//RAPS Spawn Fucnctions
	spawner::add_spawn_function_group( "rap_drive_to_point_explode", "script_noteworthy", &drive_to_point_then_explode );
	spawner::add_spawn_function_group( "station_fight_raps_jump_raps", "targetname", &raps_jump_spawnfunc );
	
	//ROBOT POD Spawn Functions
	spawner::add_spawn_function_group( "droppod_robot", "script_noteworthy", &pod_robot_spawn_function );
	
	//MELEE and MBS
	spawner::add_spawn_function_group("actor_spawner_enemy_dps_robot_assault_ar", "classname", &resolve_melee_with_mbs );
	spawner::add_spawn_function_group("actor_spawner_enemy_dps_robot_cqb_shotgun", "classname", &resolve_melee_with_mbs );
	spawner::add_spawn_function_group("actor_spawner_enemy_dps_robot_suppressor_ar", "classname", &resolve_melee_with_mbs );
	spawner::add_spawn_function_group("actor_spawner_enemy_dps_robot_suppressor_mg", "classname", &resolve_melee_with_mbs );
	
	
	if( b_starting )
	{
		ramses_util::init_dead_turrets();
		level thread intermediate_prop_state_show();
		level thread ramses_util::ambient_walk_fx_exploder();
		level flag::wait_till( "first_player_spawned" );
	}

	init_heroes( str_objective, b_starting );
	init_turrets();

	foreach( e_player in level.players )
	{
		e_player thread level_start::setup_players_for_station_fight();
	}
	
	level thread vtol_ride::dead_system_fx_anim();
	
	main( b_starting );
	
	skipto::objective_completed( "defend_ramses_station" );
}

function done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_ramses_exit_station" );
	objectives::set( "cp_level_ramses_defend_checkpoint" );
	if( b_starting )
	{
		objectives::complete( "cp_level_ramses_defend_station" );
//		show_breach( "station_breach_1" );
//		show_breach( "station_breach_2" );
	}
	
	ramses_util::set_lighting_state_alarm();  // set here for use with skiptos
}

function main( b_starting )
{
	level flag::set( "station_fight_reached" );
	
	util::wait_network_frame();
	ramses_util::set_lighting_state_alarm();
	util::wait_network_frame();
	
	level thread snd_notifies();
	
	level thread allies_think();
	level thread objectives();
	level thread progression_scenes( 3 , b_starting ); //first param is how long to wait before playing the RAP Intro
	
	clientfield::set( "hide_station_miscmodels", 0 );
	clientfield::set( "delete_fxanim_fans", 1 );
	
	if( ramses_util::is_demo() )
	{
		skipto::teleport_players( "demo_teleport_to_fight_start" );
	}
	
	station_fight();
}

function snd_notifies()
{
	
	//sound - turning on alarm
	level util::clientnotify ("alert_on");
	wait (.05);
	//sound - turning off PA and hosp amb
	level util::clientnotify ("hosp_amb");
	level util::clientNotify ("inv");  //activating audio snapshot
}

// Spawn Functions
//------------------------------------------------------

function entry_anim_spawnfunc()
{
	Assert( isdefined( self.script_string ), "AI at " + self.origin + " needs a script_string of <scene name> to play custom entry animation." );
	self scene::play( self.script_string, self );
}

// Self is AI
//function raps_kill_turret_guy_spawnfunc()
//{
//	self waittill( "death" );
//	ramses_util::enable_nodes( self.target, undefined, false );
//}

// Self is AI Vehicle
function _fake_launch()
{
	self endon( "death" );
	
	s_start = struct::get( self.target, "targetname" );
	m_raps = Spawn( "script_model", s_start.origin );
	m_raps SetModel( "veh_t7_drone_raps" );
	
	self _drop( s_start, m_raps );
}
// Self is AI Vehicle
function _drop( s_start, m_raps )
{
	self endon( "death" );
	
	const N_MOVETIME = 1.1;
	a_s_ends = struct::get_array( s_start.target, "targetname" );
	s_end =	a_s_ends[ RandomInt( a_s_ends.size ) ];
			
	m_raps.origin = s_start.origin;
	m_raps.angles = s_start.angles;
	m_raps MoveTo( s_end.origin, N_MOVETIME );
	
	m_raps waittill( "movedone" );
	//self raps_collide_kill_scene( s_end, m_raps );
	
	self.origin = m_raps.origin;
	self.angles = m_raps.angles;
	m_raps Delete();
}

// Self is a RAP
function drive_to_point_then_explode()
{
	self endon( "death" );
	
	Assert( isdefined( self.target ), "Requires a targetted struct in radiant" );
	
	vec_goal = struct::get( self.target, "targetname").origin;
	
	self vehicle_ai::start_scripted( false );
	self SetVehGoalPos( vec_goal, false );
	self waittill( "goal" );
	/*
	self util::set_ignoreall( true );
	self SetGoal( vec_goal, true );
	self waittill( "at_anchor" );
	*/
	
	self raps::detonate();
}

// Self is AI Vehicle
function raps_jump_spawnfunc()
{
	self endon( "death" );
	
	const N_FORCE_SCALE = 80;
	self ai::set_ignoreme( true );

	if( isdefined( self.target ) )
	{
		vnd_start = GetVehicleNode( self.target, "targetname" );
		
		self vehicle::get_on_and_go_path( vnd_start );
	}
	else if( isdefined( self.script_int ) )
	{
		self _launch( N_FORCE_SCALE );
	}
	
	self vehicle_ai::stop_scripted( "combat" );
	self ai::set_ignoreme( false );
}
// Self is AI Vehicle
// TODO: this is will be animated
function _launch( n_scale )
{
	self endon( "death" );
	
	v_direction = AnglesToForward( self.angles );
	v_force = v_direction * n_scale;
	
	self LaunchVehicle( v_force, self.origin + (0, 0, -4) );
	Assert( isdefined( self.script_int ), "Raps Spawner at " + self.origin + " needs script_int in order to go into combat." );
	wait self.script_int;
}


// Self if AI
// UNDONE: finish this once we get any geo changes are in
function robot_turret_spawnfunc()
{
//	self.deathFunction = &robot_turret_gunner_death; // TODO: use callback
	self.goalradius = 96;
	vh_turret = GetVehicleArray( "station_capture_turret", "script_noteworthy" );
	vh_turret = vh_turret[ 0 ];
	
	self endon( "death" );
	
	level objectives::set( "cp_level_ramses_kill", self );
	self SetGoal( vh_turret.origin, true );
	
	self waittill( "goal" );
	vh_turret thread captured_turret_think( self );
	self robot_turret_gunner_think( vh_turret );
}
// Self is Vehicle
function captured_turret_think( ai_gunner )
{
	self endon( "death" );
	
	self.team = "axis";
	
	ai_gunner waittill( "death" );
	ai_gunner Unlink();
	
	self.team = "allies"; 
}
// Self is AI
function robot_turret_gunner_think( vh_turret )
{
	self endon( "death" );
	
	t_enemy_balcony_goal = GetEnt( "station_fight_enemy_balcony_goaltrig", "targetname" );
	
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self forceteleport( vh_turret.origin, vh_turret.angles, true );
	self LinkTo( vh_turret );
	
	vh_turret waittill( "death" );
	self ClearForcedGoal();
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );
	self Unlink();
	
	self.goalradius = 1024;
	self SetGoal( t_enemy_balcony_goal );
}

function robot_turret_gunner_death()
{
	level objectives::complete( "cp_level_ramses_kill", self );
}

// Init
//------------------------------------------------------

function init_heroes( str_objective, b_starting )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_khalil = util::get_hero( "khalil" );
	level.ai_rachel = util::get_hero( "rachel" );
	
	// TODO - HACK!  Remove this later!
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_khalil ai::set_ignoreall( false );
	level.ai_rachel ai::set_ignoreall( false );
	
	level.ai_hendricks.goalradius = 8;
	level.ai_khalil.goalradius = 8;
	level.ai_rachel.goalradius = 8;
	
	if( b_starting )
	{
		setup_heros_start_positions();
	}
	
	if( isdefined( level.ai_nasser ) )
	{
		level.ai_nasser Delete();
	}
}

// Approx interview scene ending pos
function setup_heros_start_positions()
{
	s_hendricks = struct::get( "defend_ramses_station_hendricks_start_spot", "targetname" );
	s_khalil = struct::get( "defend_ramses_station_khalil_start_spot", "targetname" );
	s_rachel = struct::get( "defend_ramses_station_rachel_start_spot", "targetname" );
	
	level.ai_hendricks ForceTeleport( s_hendricks.origin, s_hendricks.angles, true );
	level.ai_khalil ForceTeleport( s_khalil.origin, s_khalil.angles, true );
	level.ai_rachel ForceTeleport( s_rachel.origin, s_rachel.angles, true );
}

function init_turrets()
{
	a_vh_turrets = GetEntArray( "station_fight_turret", "targetname" );
	array::thread_all( a_vh_turrets, &_turret_enable_think );
}
// Self is Vehicle
function _turret_enable_think()
{
	s_obj = struct::get( self.script_string, "targetname" );
	t_obj = Spawn( "trigger_radius", self.origin, 0, s_obj.radius, 128 );
	t_obj.script_objective = "vtol_ride";
	e_turret = self;
	
//	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "station_fight_start_disabled" )
//	{
//		e_turret = self _enable_scene_turret( s_obj, t_obj );
//	}
//	else
//	{
		self thread ramses_util::turret_pickup_think( s_obj );
//	}
//	e_turret oed::enable_keyline( true );
	
	level waittill( "vtol_crash_complete" );
	e_turret turret_objective( s_obj, t_obj );
}

// TODO: Find a better solution - turrets don't seem to be useable all the time if they are spawned and moved
function _enable_scene_turret( s_obj, t_obj )
{
	vh_turret = GetEnt( "station_fight_turret_respawn", "targetname" );
	vh_turret.team = "allies";
	m_turret = util::spawn_model( self.model, self.origin, self.angles ); // Swap for model for scene
	
//	m_turret oed::enable_keyline( true );
	self.delete_on_death = true;           self notify( "death" );           if( !IsAlive( self ) )           self Delete();;
	vh_turret thread _respawn_scene_turret( m_turret, s_obj, t_obj );
	return m_turret;
}

function _respawn_scene_turret( m_turret, s_obj, t_obj )
{
	level endon( "mobile_wall_fxanim_start" );
	
	level flag::wait_till( "station_fight_body_pull_scene_completed" );
	
	self.origin = m_turret.origin;
	self.angles = m_turret.angles;
	
	m_turret Delete();
	self thread ramses_util::turret_pickup_think( s_obj );
	
	if( !level flag::get( "station_fight_completed" ) )
	{
		self thread turret_objective( s_obj, t_obj );
	}
}

// Event Functions
//------------------------------------------------------

function station_fight()
{
	e_sm_center_raps = GetEnt( "station_fight_raps_jump", "targetname" );
	
	e_sm_center_raps ramses_util::scale_spawn_manager_by_player_count( 2, 1 );
	
	//-- First wave of robots that engage the Egyptians
	spawn_manager::enable( "station_fight_wave1_robots_left" );
	spawn_manager::enable( "sm_initial_arch_spawn_left" );
	level thread ramses_util::staged_battle_outcomes( "station_fight_wave1_robots_left", "sm_initial_arch_spawn_left" );
	
	spawn_manager::enable( "station_fight_wave1_robots_right" );
	spawn_manager::enable( "sm_initial_arch_spawn_right" );
	level thread ramses_util::staged_battle_outcomes( "station_fight_wave1_robots_right", "sm_initial_arch_spawn_right" );
	
	
	//-- Balcony wave
	spawn_manager::enable( "sm_initial_balcony_spawn" );
	spawn_manager::enable( "sm_balcony_robots" );
	level thread ramses_util::staged_battle_outcomes( "sm_balcony_robots", "sm_initial_balcony_spawn" );
			
	level thread ai_at_arch_magic_bullet_shield_removal( "sm_initial_arch_spawn_right", "sm_initial_arch_spawn_left" );
	
	spawn_manager::enable( "sm_initial_recovery_left_spawn" ); //-- guys in the recovery room
	
	level flag::set( "station_fight_reached" ); //-- this flag controls various triggers
	
	//-- This is time so that there is a small beat between the RAP Intro IGC and the station ceiling falling
	trigger::wait_till( "trigger_ceiling_collapse" );
	level notify( "reached_ceiling_collapse" );
	
	level thread spawn_in_drop_pod_robots(); //-- These are the ones in the drop pod of the fxanim dropship
		
	wait 2; // some spawn/thinking space
	
	spawn_manager::enable( "sm_escalator_rap" ); //-- Custom RAP that comes down escalator
	
	
	wait 3; // some spawn/thinking space
	
	
	//-- Robots that fight from ceiling piece to server area	
	spawn_manager::enable( "sm_ceiling_fight_server_robots" );
	spawn_manager::enable( "sm_server_fights_ceiling_ally" );
	level thread ramses_util::staged_battle_outcomes( "sm_ceiling_fight_server_robots", "sm_server_fights_ceiling_ally" );
	
	spawn_manager::enable( "station_fight_raps_jump" );
	
	
	spawn_manager::enable( "sm_center_ceiling_robots" );
	
	wait 5; // just space some things out a bit...
	
	level thread spawn_station_phalanx();
	level thread spawn_station_right_phalanx();
	spawn_manager::enable( "sm_right_across_gap_human" );
	
	level thread track_gap_soldiers_dead( "sm_right_across_gap_human" );
	level thread track_right_robot_phalanx_dead( "sm_right_across_gap_human" );
	
	wait 10; // another break before bringing in RAPS
	spawn_manager::enable( "sm_rap_trickle" );
	
//	wait 3;
////	ai_turret_robot = spawner::simple_spawn_single( "station_fight_balcony_turret_steal_robot" ); // TODO: try when geo is locked down more
//	a_ai_intro_bots = spawner::simple_spawn( "station_fight_hatch_open_robot" ); // TODO: proving out opening hatch before onslaught
//	
//	wait 3;
//	spawn_manager::enable( "station_fight_wave2_robots" );
//	
//	spawn_manager::wait_till_ai_remaining( "station_fight_wave2_robots", 7 );
//	spawn_manager::enable( "station_fight_wave2_raps" );
//	
//	spawn_manager::wait_till_ai_remaining( "station_fight_wave2_robots", 3 );
//	spawn_manager::kill( "station_fight_wave2_raps", true );
//	
//	spawner::waittill_ai_group_cleared( "station_fight_raps_wave2" );
//	level thread enemies_track_players();
//	
//	spawn_manager::wait_till_cleared( "station_fight_wave2_robots" );
//	level notify( "stop_waves" );
//	
//	WAIT_SERVER_FRAME;
	
	spawn_manager::wait_till_cleared( "station_fight_wave1_robots_left" );
	spawn_manager::wait_till_cleared( "station_fight_wave1_robots_right" );
	spawn_manager::wait_till_cleared( "sm_ceiling_fight_server_robots" );
	spawn_manager::wait_till_cleared( "station_fight_raps_jump" );
	spawn_manager::wait_till_cleared( "sm_center_ceiling_robots" );
	spawn_manager::wait_till_cleared( "sm_balcony_robots" );
	level flag::wait_till( "station_phalanx_dead" );
	level flag::wait_till( "station_right_phalanx_dead" );
	
	//-- Force Drop Pod Open if it hasn't opened based on proximity yet
	if( !flag::get( "drop_pod_opened_and_spawned" ) )
	{
		trigger::use( "trig_open_pod", "targetname" );
		wait( 1.0 ); //Let everything get setup
	}
	
	level spawner::waittill_ai_group_cleared( "droppod_ai" );
	
	spawn_manager::wait_till_cleared( "sm_rap_trickle" );
	
	level flag::set( "station_fight_completed" );
	level.allowbattlechatter["bc"] = false;
	//	level thread open_security_doors();
	
	end_fight_dialog();
	level thread end_fight_ambient_dialog();
	
	level flag::wait_till( "station_fight_gather_reached" );
}

function resolve_melee_with_mbs()
{
	self endon( "death" );
	
	level flag::wait_till( "ceiling_collapse_complete" );
	
	while( true )
	{
		self waittill( "failed_melee_mbs", e_target );
		
		if( e_target == level.ai_khalil || e_target == level.ai_hendricks )
		{
			self notify( "ram_kill_mb" );
		}
		else if( (e_target != level.ai_khalil) && (e_target != level.ai_hendricks) && !IsPlayer(e_target) )
		{
			e_target notify( "ram_kill_mb");
		}
	}
}

function robotintro_handler( a_ents )
{
	level scene::play( "cin_ram_03_02_defend_vign_robotintro" );
	
	e_robot = GetEnt( "robot_intro_robot_ai", "targetname" );
	
	if( isdefined(e_robot) )
	{
		e_robot ai::set_behavior_attribute( "move_mode", "rusher" );
	}
	
	e_robot endon("death");
	wait 10;
	e_robot Kill();
	
}

function spawn_in_drop_pod_robots()
{
	
	flag::init( "drop_pod_opened_and_spawned" ); //-- Need to force this if it doesn't happen naturally
		
	trigger::wait_till( "trig_open_pod", "targetname" );
	
	level thread scene::play("p7_fxanim_cp_ramses_station_ceiling_vtol_bundle");
	
	flag::set( "drop_pod_opened_and_spawned" );
	
	level thread spawn_robots_in_pod();
	
//	e_door = GetEnt( "transport_door", "targetname" );
//	e_door ConnectPaths();
	
	e_vtol = GetEnt( "station_ceiling_troopcarrier", "targetname" ); //-- spawned by the fxanim
	e_vtol ConnectPaths();
	
	wait 0.2;
	
	e_vtol_cutter = GetEnt( "vtol_navmesh_cutter", "targetname" );
	e_vtol_cutter DisconnectPaths();
		
	wait 0.5;
	
//	e_door Delete();
}

//-- most of this is a cut and paste from cp_ai_phalanx.gsc
function spawn_station_phalanx()
{
	level flag::init( "station_phalanx_dead" );
	startPosition = struct::get( "station_phalanx_start", "targetname" ).origin;
	endPosition = struct::get( "station_phalanx_end", "targetname" ).origin;
	
	phalanx = new RobotPhalanx();
	[[ phalanx ]]->Initialize( "phalanx_column_right", startPosition, endPosition, 1, 4 );
	level.station_phalanx = phalanx;
	
	robots = ArrayCombine(
		ArrayCombine( phalanx.tier1Robots_, phalanx.tier2Robots_, false, false ),
		phalanx.tier3Robots_,
		false,
		false );
	
	array::wait_till( robots, "death" );
	
	level.station_phalanx = undefined;
	level flag::set( "station_phalanx_dead" );
}


//-- This robot phalanx needs to be magic bullet shield for a little bit
function spawn_station_right_phalanx()
{
	level flag::init( "station_right_phalanx_dead" );
	startPosition = struct::get( "station_right_phalanx_start", "targetname" ).origin;
	endPosition = struct::get( "station_right_phalanx_end", "targetname" ).origin;
	
	phalanx = new RobotPhalanx();
	[[ phalanx ]]->Initialize( "phanalx_wedge", startPosition, endPosition, 2, 3 );
	level.station_phalanx = phalanx;
	
	robots = ArrayCombine(
		ArrayCombine( phalanx.tier1Robots_, phalanx.tier2Robots_, false, false ),
		phalanx.tier3Robots_,
		false,
		false );
	
	foreach( e_robot in robots )
	{
		e_robot thread ramses_util::magic_bullet_shield_till_notify( "gap_soldiers_dead", true, "station_right_phalanx_scatter");
	}
	
	phalanx thread scatter_on_notify("station_right_phalanx_scatter");
	
	array::wait_till( robots, "death", "station_right_phalanx_scatter" );
	
	level.station_phalanx = undefined;
	level flag::set( "station_right_phalanx_dead" );
}

//self == phalanx object
function scatter_on_notify( str_phalanx_scatter_notify )
{
	level waittill( str_phalanx_scatter_notify );
	self robotphalanx::ScatterPhalanx();	
}


//-- this is specific for the soldiers that are fighting across the stairs against the phalanx
function track_gap_soldiers_dead( str_gap_spawn_manager )
{
	level endon( "station_right_phalanx_dead" );
	
	do
	{
		wait 0.5; //don't need to check this every frame
		a_human_ais = spawn_manager::get_ai( str_gap_spawn_manager );
	}
	while( a_human_ais.size > 0 || spawn_manager::is_enabled( str_gap_spawn_manager ) );
	
	level notify( "gap_soldiers_dead" ); //-- turns magic bullet shield off on the right phalanx
}

function track_right_robot_phalanx_dead( str_gap_spawn_manager )
{
	level endon( "gap_soldiers_dead" );
	
	level util::waittill_any( "station_right_phalanx_dead", "station_right_phalanx_scatter"  );
	
	a_human_ais = spawn_manager::get_ai( str_gap_spawn_manager );
	
	foreach( e_human in a_human_ais )
	{
		e_human.goalradius = 1024;	//-- These guys were restricted by their nodes before
	}
}

function kill_on_ceiling_drop( str_spawn_manager )
{
	a_alive_ai = spawn_manager::get_ai( "station_fight_wave1_robots_left" );
	
	a_alive_ai = ArrayCombine( a_alive_ai, spawn_manager::get_ai( "station_fight_wave1_robots_right" ), false, false );
	
	array::thread_all( a_alive_ai, &random_wait_then_kill );

}

//self is an AI
function random_wait_then_kill()
{
	self endon( "death" );
	
	wait( RandomFloatRange(0.15, 0.5) );
	util::stop_magic_bullet_shield( self );
	self Kill();
}

function spawn_robots_in_pod()
{
	if( !isdefined( level.a_droppod_robots ) )
	{
		level.a_droppod_robots = [];
	}
	
	trigger::use( "trig_activate_robot_pod_spawns", "targetname" );
	
	wait(0.5); //-- just some time to get rid of the door and then activate the robots in sequence
	
	foreach( e_robot in level.a_droppod_robots )
	{
		e_robot.ignoreall = false;
		e_robot.ignoreme = false;
		
		e_robot ai::set_behavior_attribute( "move_mode", "rusher" );
		util::stop_magic_bullet_shield( self );	
		
		wait 1;
	}
	
}

function pod_robot_spawn_function()
{
	//-- TODO: get some sort of looping animation here
	self.ignoreall = true;
	self.ignoreme = true;
	
	util::magic_bullet_shield( self );
	
	Assert( isdefined( self.script_int ), "This AI needs a script int to tell him what num robot he is in the pod" );
	
	level.a_droppod_robots[ self.script_int ] = self;
}

//-- Moves all of the friendlies throughout the space
function allies_think()
{
	level waittill( "raps_intro_done" ); //-- These need to hold until the RAP intro is done
	
	level thread rachel_move_out(); //TODO: TEMP - WE NEED AN ANIMATION FOR RACHEL AT THE CONSOLE
	level thread khalil_station_fight();
    
    level.ai_hendricks SetGoal( struct::get( "cin_gen_melee_hendricks_stomp_gibbedrobot" , "scriptbundlename" ).origin , false , 128 ); //go to the general location of the scriptbundle he's about to perform
    
//    e_sm_allies = GetEnt( "station_fight_friendlies", "targetname" );
//    t_right_allies_goal = GetEnt( "station_fight_allies_right_goaltrig", "targetname" );
//    spawn_manager::enable( "station_fight_friendlies_balcony" );
    
    scene::init( "cin_gen_melee_hendricks_stomp_gibbedrobot" );
    util::wait_network_frame();
    e_robot = scene::get_existing_ent( "stomped_robot_ai" );
    e_robot ai::set_ignoreme( true );
    
    level waittill( "reached_ceiling_collapse" );
    
    //ROBOT GIBBED STOMP SCENE
    level scene::play( "cin_gen_melee_hendricks_stomp_gibbedrobot" );

    level.ai_hendricks SetGoal( GetEnt( "station_fight_allies_left_goaltrig", "targetname" ) );
}

function ai_at_arch_magic_bullet_shield_removal( str_sm1, str_sm2 )
{
	level endon( "reached_ceiling_collapse" );
	
	trigger::wait_till( "trig_start_rap_intro", "targetname" ); //-- start this once the RAP intro scene begins
	
	wait 15; //Let the scene progress far enough that the guys are still alive when you come back
	
	a_soldiers = spawn_manager::get_ai( str_sm1 );
	a_soldiers = ArrayCombine( a_soldiers, spawn_manager::get_ai( str_sm2 ), false, false );
	
	a_soldiers = array::randomize( a_soldiers );
	
	foreach( e_guy in a_soldiers )
	{
		if( isdefined( e_guy ) )
		{
			e_guy notify( "ram_kill_mb" );
		}
		
		wait(2); //slowly remove every ally bullet shield
	}
}

//-- manage Khalil for this fight
function khalil_station_fight()
{
	level scene::init( "cin_ram_03_03_defend_vign_balconybash" );
	//-- send khalil to a goal node
	
	level waittill( "reached_ceiling_collapse");
	
	//-- X seconds after the Ceiling Crash - send Khalil up to do the Balcony Bash animation
	wait 5; //-- temp until this gets all figured out
	level scene::play("cin_ram_03_03_defend_vign_balconybash");
	
	e_goalvolume = GetEnt( "initial_balcony_friendly_volume", "targetname" );
	level.ai_khalil SetGoal( e_goalvolume );
	
	spawn_manager::wait_till_cleared( "sm_balcony_robots" );
	
	e_goalvolume = GetEnt( "second_balcony_friendly_volume", "targetname" );
	level.ai_khalil SetGoal( e_goalvolume );
	
	//level.ai_khalil SetGoalNode( GetNode( "khalil_balcony_node", "targetname" ) );
	//TODO: after this animation, Khalil needs to be sent to the turret next to where he ends, once he re-enters AI
}

//-- This runs Rachael away and then deletes her since she needs to be cleaned up
function rachel_move_out()
{	
	nd_rachel_exit_goal = GetNode( "station_fight_rachel_exit_goal", "targetname" );
	
	if( isdefined( level.ai_rachel ) )
	{
		//HACK: make sure that she isn't left in a scripted animation.  This will automatically be fixed
		// when the level gets the full IGC for the interview scene
		if( isdefined( level.ai_rachel.current_scene ) )
		{
			level.ai_rachel StopAnimScripted();
		}
		
		level.ai_rachel.goalradius = 8;
		
		level.ai_rachel SetGoal( nd_rachel_exit_goal, true );
		
		level.ai_rachel waittill( "goal" );
		
		level.ai_rachel ramses_util::wait_till_no_players_looking_at();
		
		util::unmake_hero( "rachel" );
		level.ai_rachel Delete();
	}
}

// Scenes
//------------------------------------------------------

function progression_scenes( n_delay , b_starting )
{	
	level thread scene::init( "cin_ram_03_01_defend_1st_rapsintro" );
	
	level util::waittill_notify_or_timeout( "movie_done", n_delay );
	level thread util::set_streamer_hint( 2 );
	
	level.players[0] thread dialog::say( "khal_move_get_out_of_th_0" ); //-- HACK: this is temp for Raps Intro Black Screen
	
	if ( !b_starting )
	{
		wait 3; //-- time with black over
		
		util::screen_fade_in( 0.1 ); //This is just making the screen flash black for a moment
	}
	
	level thread raps_intro();
	
	//trigger::wait_till( "trig_start_rap_intro", "targetname" );
	
	//level thread open_interview_room_door();
//	trigger::wait_till( "defend_ramses_station_friendlies" ); //TODO: DELETE THIS
	
		//-- All of the ambient scenes that are not required/shared by the players
	level thread ambient_scenes(); 

//-- the dead body that is pinned to the turret TODO: re-enable after demo
//	t_pull_body = GetEnt( "station_fight_turret_body_scene_trig", "targetname" );
//	t_pull_body thread pull_body_think();

	play_ceiling_collapse();
	
	level notify ("start_defend_music");  //this will be moved when the music system is implmented
	
	
	level flag::wait_till( "station_fight_completed" );
	
	level notify ("end_fight");  //kill the music 
	
//	level thread ending_scenes();
	
	level flag::wait_till( "station_fight_gather_reached" );
}

function raps_intro()
{
	level thread sndWaitTillAnimNotify();
	level thread raps_intro_fxanim();
	level thread wait_for_blood_notifies();
	scene::add_scene_func( "cin_ram_03_01_defend_1st_rapsintro", &swap_soldier_body, "play" );
	level thread swap_soldier_body();
	
	ramses_util::co_op_teleport_on_igc_end( "cin_ram_03_01_defend_1st_rapsintro", "raps_intro_skipto" );
	level scene::play( "cin_ram_03_01_defend_1st_rapsintro" );
	level notify( "raps_intro_done" );
	wait 1.5; //Beat to space dialog out from the Scene
	
	
	//-- play dialog off of AI closest to the server
	a_ai = GetAITeamArray( "allies" );
	a_ai = ArraySortClosest( a_ai, level.players[0].origin );
	if( isdefined( a_ai[0] ) )
	{
//		a_ai[0] thread dialog::say( "esl4_everyone_get_back_i_0" );
	}
}

function swap_soldier_body( a_ents )
{
	StreamerModelHint( "c_ega_soldier_3_pincushion_armoff_fb", 5 );
	
	level waittill( "swap_rap_guy_model" );
	
	e_soldier = scene::get_existing_ent("rap_intro_guy");
	e_soldier SetModel("c_ega_soldier_3_pincushion_armoff_fb");
	
	util::clear_streamer_hint();
}

function wait_for_blood_notifies()
{
	level waittill( "rap_blood_postfx" );
	level thread play_blood_postfx(); //-- slice
	
	level waittill( "rap_blood_postfx" );
	level thread play_blood_postfx(); //-- explosion
}

function play_blood_postfx()
{
	foreach( e_player in level.players )
	{
		if( e_player.current_scene === "cin_ram_03_01_defend_1st_rapsintro" )
		{
			e_player clientfield::increment_to_player( "rap_blood_on_player" );
		}
	}	
}

function sndWaitTillAnimNotify()
{
	level waittill( "sndRapsIntroDone" );
	level util::ClientNotify ("dro"); // get rid of the audio snapshot that's occluding the weapons
}

function raps_intro_fxanim()
{
	level waittill( "play_raps_explosion_bundle" );
	level scene::play( "p7_fxanim_cp_ramses_raps_explosion_bundle" );
}


//TODO: look into getting this hooked up as a door script bundle
function open_interview_room_door()
{
//	m_door = GetEnt( "station_fight_interview_door", "targetname" );
//	
//	trigger::wait_till( "station_fight_interview_room_door_trig" );
//	m_door Delete();
}

function close_interview_room_door()
{
//	m_door = GetEnt( "station_fight_interview_door", "targetname" );
//	
//	m_door ramses_util::make_solid( false );
//	m_door Show();
}

// Self is trigger_use
///TODO: put back in after demo
function pull_body_think()
{
	level endon( "station_fight_gather_reached" );
	
	self SetHintString( &"CP_MI_CAIRO_RAMSES_PULL_BODY" );
	self SetCursorHint( "HINT_NOICON");
	
	self waittill( "trigger", e_user );
	level scene::play( "cin_ram_03_02_defend_1st_pullbody", e_user );
}

// Fxanim info
/* ********************************************
 * VTOL positions -----------------------------
 * RAPS deploy position
 * 		origin: (6621.11, -2802.58, 869.178)
 * 		angles: (-0.325891, 163.573, 15.7179)
 * VTOL crash position
 *		origin: (6450.53, -2723.49, 150.711)
 * 		angles: (2.40408, 290.964, -15.9241)
 * *******************************************/
function play_ceiling_collapse()
{
	scene::add_scene_func( "p7_fxanim_cp_ramses_station_ceiling_vtol_bundle", &ceiling_collapse_setup_props, "done" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_station_ceiling_vtol_bundle", &ceiling_lighting_swap, "init" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_station_ceiling_bundle", &ceiling_collapse_break_glass, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_station_ceiling_bundle", &ceiling_anim_swap_station_interior, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_station_ceiling_bundle", &kill_on_ceiling_drop, "done" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_station_ceiling_bundle", &phys_pulse_on_structs, "done" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_station_ceiling_bundle", &robotintro_handler, "done" );
	
	level scene::init( "p7_fxanim_cp_ramses_station_ceiling_bundle" );
	
	level waittill( "reached_ceiling_collapse" );
	
	level thread kill_ambient_exploder_on_notetrack();
	level thread ceiling_anim_pod_impact();
	level play_ceiling_anims_blocking();
	level flag::set( "ceiling_collapse_complete" );
	
	level scene::init( "p_ramses_lift_wing_blockage" );
		
	level notify( "vtol_crash_complete" );
	level notify( "killed_by_ceiling" );
}

function phys_pulse_on_structs()
{
	a_structs = struct::get_array( "station_phys_pulse", "targetname" );
	
	foreach( struct in a_structs )
	{
		PhysicsExplosionSphere( struct.origin, 255, 254, 0.3, 400, 25 );
		wait RandomFloatRange( 0.5, 1.5 );
	}
	
}

function play_ceiling_anims_blocking()
{
	level thread scene::play( "p7_fxanim_cp_ramses_station_ceiling_bundle" );
	level scene::init( "p7_fxanim_cp_ramses_station_ceiling_vtol_bundle" );	
}

//called when the pod hits the floor
function ceiling_anim_pod_impact()
{
	//level notify setup in the animation
	level waittill( "pod_hits_floor" );
	
	if( spawn_manager::get_ai("station_fight_wave1_robots_left").size > 0 )
	{
		e_impact = GetEnt( "station_fight_wave1_robots_left", "targetname" );      
		RadiusDamage( e_impact.origin , 300, 1000, 500, undefined, "MOD_EXPLOSIVE" );
	}
	
	level.ai_hendricks thread dialog::say( "hend_it_s_comin_down_l_0" );
}

function ceiling_lighting_swap()
{
	level waittill( "switch_fog_banks" );
	
	level clientfield::set( "defend_fog_banks", 1 );
	
	//-- Will eventually be handled by FXAnim - this gets lighting unblocked
	a_ceiling_geo = GetEntArray( "station_roof_hole", "targetname" );
	foreach( piece in a_ceiling_geo )
	{
		piece Delete();
	}
}

function ceiling_anim_swap_station_interior()
{
	wait 1.0; //-- even though this is off of the play, it seems like the pieces aren't rendering yet.
	
	a_ceiling_piece_geo = GetEntArray( "station_ceiling_pristine", "targetname" );
	foreach( piece in a_ceiling_piece_geo )
	{
		piece Delete();
	}
	
	
	//level notify setup in the anmation of the ceiling
	level waittill( "swap_station_interior" );
	
	//change station floor states
	delete_props();
	show_props( "_combat" );
}

function kill_ambient_exploder_on_notetrack()
{
	level waittill( "dropship_through_ceiling" );
	level ramses_util::ambient_walk_fx_exploder(false);	
}

function ceiling_collapse_setup_props( a_ents )
{

//	a_ents[ "station_ceiling_vtol" ].script_objective = "vtol_ride"; TODO: get past sre for now - this isn't really needed now anyway
}

function ceiling_collapse_break_glass( a_ents )
{
	a_s_pulse = struct::get_array( "station_fight_glass_pulse", "targetname" );
	
	wait 1.4;
	 
	foreach( s in a_s_pulse )
	{
		GlassRadiusDamage( s.origin, s.radius, 500, 400 );
		wait RandomFloatRange( .5, .75 );
	}
}


function ambient_scenes()
{
	level scene::init( "cin_ram_03_03_defend_vign_debriscover_aligned" );
	
//	trigger::wait_till( "trig_robot_intro_scene", "targetname" ); //TODO: convert this to the radiant method
	
	level waittill( "killed_by_ceiling" ); //-- trigger these anims after 
	level thread scene::play( "cin_ram_03_03_defend_vign_debriscover_aligned" );
	
//	level scene::init( "cin_ram_03_02_defend_1st_pullbody" );
//	level thread scene::play( "station_fight_deadbody_pinned_01", "targetname" ); // This scene contains 3 guys
}

function ending_scenes()
{
	level thread scene::play( "station_fight_scene_mediccpr", "targetname" );
	level thread scene::play( "cin_ram_03_03_defend_vign_gurney" );
	level thread scene::play( "station_fight_scene_missinglegs", "targetname" );
//	level scene::play( "cin_ram_03_03_defend_vign_fortify" );
}


// Objectives
//------------------------------------------------------

function objectives()
{
	objectives::set( "cp_level_ramses_defend_station" );
	
	level flag::wait_till( "station_fight_completed" );	
	objectives::complete( "cp_level_ramses_defend_station" );
	objectives::set( "cp_level_ramses_go_to_checkpoint" );
	
 	s_exit = struct::get( "station_fight_exit_spot", "targetname" );
	objectives::set( "cp_level_ramses_exit_station", s_exit );
}

// Self is ent - script model or vehicle
function turret_objective( s_obj, t_obj )
{
	self turret_objective_show_think( s_obj, t_obj );
	
	if( isdefined( self ) )
	{
		self oed::disable_keyline();
	}
}

// Self is ent - script model or vehicle
function turret_objective_show_think( s_obj, t_obj )
{
	level endon( "station_fight_completed" );
	self endon( "death" );
	
	while( isdefined( self ) )
	{
//		self oed::enable_keyline( true );
		
		t_obj waittill( "trigger", e_player );
//		self oed::disable_keyline();
		
		while( isdefined( t_obj ) && IsAlive( e_player ) && e_player IsTouching( t_obj ) )
		{
			wait .1;
		}
	}
}

// Cleanup
//------------------------------------------------------

function cleanup_scenes()
{
	a_str_scenes = [];
//	a_str_scenes [0] = "cin_ram_03_03_defend_vign_missinglegs";
//	a_str_scenes [1] = "cin_ram_03_03_defend_vign_medicscpr";
//	a_str_scenes [2] = "cin_ram_03_03_defend_vign_gurney";
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_03_02_defend_vign_deadbody";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_03_02_defend_1st_pullbody";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_05_interview_vign_nassersitting";;
	
	//-- combat animations
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_03_03_defend_vign_balconybash";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_03_03_defend_vign_debriscover_aligned";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_03_02_defend_vign_last_stand_death_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_03_02_defend_vign_last_stand_death_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_03_02_defend_vign_last_stand_death_guy03";;
	
	foreach( str_scene in a_str_scenes )
	{
		if( level scene::is_active( str_scene )  )
		{
			level thread scene::stop( str_scene, true );

			wait 0.1;			
		}	
	}
}

// TODO: unhack for First Playable
function cleanup_scene_turret()
{
	vh_turret = GetEnt( "station_fight_turret_respawn", "targetname" );
	if( isdefined( vh_turret ) )
	{
		vh_turret.delete_on_death = true;           vh_turret notify( "death" );           if( !IsAlive( vh_turret ) )           vh_turret Delete();;
	}
}

// Util
//------------------------------------------------------

function enemies_track_players()
{
	a_ai_robots = GetAITeamArray( "axis" );
	
	foreach( ai in a_ai_robots )
	{	
		if( !IsVehicle( ai ) )
		{
			ai ai::set_behavior_attribute( "move_mode", "rusher" );
		}
	}
}

// Station props

function hide_props( str_state = "" )
{
	a_m_props = GetEntArray( "station_clutter" + str_state, "targetname" );
	a_m_props_noteworthy = GetEntArray( "station_clutter" + str_state, "script_noteworthy" );
	a_m_clips = GetEntArray( "station_clutter_collision" + str_state, "targetname" );
//	a_m_props_no_col = GetEntArray( "station_clutter_nocol" + str_state, "targetname" );
	a_m_stairs = GetEntArray( "station_stairs" + str_state, "targetname" );
	
	a_m_props ramses_util::hide_ents( true );
	a_m_props_noteworthy ramses_util::hide_ents( true );
	a_m_clips ramses_util::make_not_solid();
//	a_m_props_no_col ramses_util::hide_ents();
	a_m_stairs ramses_util::hide_ents();// TODO: connect when model colmap is sorted out
}

function show_props( str_state = "" )
{
	a_m_props = GetEntArray( "station_clutter" + str_state, "targetname" );
	a_m_props_noteworthy = GetEntArray( "station_clutter" + str_state, "script_noteworthy" );
	a_m_clips = GetEntArray( "station_clutter_collision" + str_state, "targetname" );
//	a_m_props_no_col = GetEntArray( "station_clutter_nocol" + str_state, "targetname" );
	a_m_stairs = GetEntArray( "station_stairs" + str_state, "targetname" );
	
	a_m_props ramses_util::show_ents( true );
	a_m_props_noteworthy ramses_util::show_ents( true );
	a_m_props ramses_util::show_ents( );
	a_m_clips ramses_util::make_solid();
//	a_m_props_no_col ramses_util::show_ents();
	a_m_stairs ramses_util::show_ents(); // TODO: disconnect when model colmap is sorted out
	
	
	a_struct_props = struct::get_array( "station_clutter" + str_state, "targetname" );
	a_struct_props ramses_util::spawn_from_structs();
}

function delete_props( str_state = "", b_connectpaths = false )
{
	a_m_props = GetEntArray( "station_clutter" + str_state, "targetname" );
	a_m_clips = GetEntArray( "station_clutter_collision" + str_state, "targetname" );
	a_m_props_no_col = GetEntArray( "station_clutter_nocol" + str_state, "targetname" );
	a_m_stairs = GetEntArray( "station_stairs" + str_state, "targetname" );
	
	HideMiscModels( "station_clutter" + str_state );
	
	if( b_connectpaths )
	{
		foreach( e_prop in a_m_props )
		{
			e_prop ConnectPaths();
		}
	}
		
	array::delete_all( a_m_props );
	array::delete_all( a_m_clips );
	array::delete_all( a_m_props_no_col );
	array::delete_all( a_m_stairs );
}

//-- This handles props that are different after the player has gone into the interview room, but before 
// the FX Anim of the ceiling collapse plays
function intermediate_prop_state_hide()
{
	//station_defend_before
	//station_defend_after
	
	a_m_props_to_hide = GetEntArray( "station_defend_after", "script_noteworthy" );
	a_m_props_to_hide ramses_util::hide_ents( );
}

function intermediate_prop_state_show()
{
	a_m_props_to_show = GetEntArray( "station_defend_after", "script_noteworthy" );
	a_m_props_to_show ramses_util::show_ents(true);
	
	util::wait_network_frame();
	
	a_m_props_to_delete = GetEntArray( "station_defend_before", "script_noteworthy" );
	array::delete_all( a_m_props_to_delete );
	
	util::wait_network_frame();
	
	//-- Also delete the first drop pod roof pieces
	a_rooftop_pieces = GetEntArray( "droppod_hole", "targetname" );
	
	foreach( rooftop_piece in a_rooftop_pieces )
	{
		rooftop_piece Delete();
	}
}


// VO
//-----------------------------------------------------

function end_fight_dialog()
{
	//Hendricks	
	level.ai_hendricks dialog::say( "hend_kane_what_are_we_de_0" );
	wait 1.0;
	
	//Kane Rmote
	level dialog::remote( "kane_nrc_forces_are_mobil_0" );
	wait 2.0;
	
	//Hendricks	
	level.ai_hendricks dialog::say( "hend_let_s_take_it_to_em_0" );
}

function end_fight_ambient_dialog()
{
	wait 5.0; //-- time to seperate the conversation from the end hero dialog
	
	//-- play dialog off of AI closest to the server
	//-- TODO: disallow Hendricks and Khalil
	a_ai = GetAITeamArray( "allies" );
	
	ArrayRemoveValue( a_ai, level.ai_hendricks, false );
	ArrayRemoveValue( a_ai, level.ai_khalil, false );
	
	a_ai = ArraySortClosest( a_ai, level.players[0].origin );
		
	
	if( isdefined( a_ai[0] ) )
	{
		if( math::cointoss() )
		{
			a_ai[0] thread dialog::say( "esl3_how_did_they_beat_ou_0" );
		}
		else
		{
			a_ai[0] thread dialog::say( "esl4_impossible_how_did_0" );
		}
	}
	
}


// Dev
//------------------------------------------------------

function defend_station_test( str_objective, b_starting )
{
	station_fight::delete_props();
	station_fight::show_props( "_combat" );
	
	init( "defend_ramses_station", b_starting ); // Same logic, new starting pos
}

function defend_station_done()
{
}
