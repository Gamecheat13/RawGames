#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_testing_lab_igc;
#using scripts\cp\cp_mi_sing_sgen_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       



function skipto_fallen_soldiers_init( str_objective, b_starting )
{
	// Init flags
	// "script_flag_set"/"fallen_soldiers_dayroom_started"
	// "script_flag_set"/"fallen_soldiers_dayroom_completed"
	// "script_flag_true"/"fallen_soldiers_robots_cleared"
	level flag::init( "kane_robots_convo_done" );
	level flag::init( "fallen_soldiers_hendricks_ready_to_enter_dayroom" );
	
	spawner::add_spawn_function_group( "fallen_soldiers_spawner", "script_noteworthy", &robot_wake_spawnfunc );
	spawner::add_spawn_function_group( "fallen_soldiers_start_awake", "script_noteworthy", &robot_spawnfunc );
		
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );

		nd_post_jump_downs = GetNode( "nd_post_jump_downs", "targetname" );
		level.ai_hendricks thread ai::force_goal( nd_post_jump_downs, 32 );		
		
		// Allow things to float
		level clientfield::set( "w_underwater_state", 1 );
		level clientfield::set( "fallen_soldiers_client_fxanims", 1 );
		
		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::complete( "cp_level_sgen_investigate_sgen" );

		sgen::wait_for_all_players_to_spawn();
	}
	
	// Cleanup Robot Dead Poses From Silo Floor
	for ( x = 0; x < 6; x++ )
	{
		array::run_all( GetEntArray( "robot0" + x, "targetname" ), &Delete );
	}
	
	main();
	
	skipto::objective_completed( "fallen_soldiers" );
}

function skipto_fallen_soldiers_done( str_objective, b_s_starting, b_direct, player )
{
	for ( x = 0; x < 6; x++ )
	{
		array::thread_all( GetEntArray( "robot0" + x, "targetname" ), &util::self_delete );
	}
	
	exploder::delete_exploder_on_clients( "fallen_soldiers_decon_spray" );
}

// ***********************************************
// Event Functions
// ***********************************************
function main()
{
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks colors::disable();

	level thread scene::init( "cin_sgen_14_humanlab_3rd_sh005" ); // Doing it early incase Players sprint through this event
		
	level thread vo();
	level thread handle_breadcrumbs();
		
	level thread fallen_soldiers_objective();
	fallen_soldiers_room();
	
	const N_CLEAR_TIMEOUT = 40;
	
	level flag::wait_till_timeout( N_CLEAR_TIMEOUT,"fallen_soldiers_hendricks_ready_to_enter_dayroom" );
	
	const N_HENDRICKS_READY_TIMEOUT = 5;
		
	trigger::wait_or_timeout( N_HENDRICKS_READY_TIMEOUT, "fallen_soldiers_encounter_clear_trig" );
	
	level notify( "fallen_soldiers_terminate" );
	
	level thread encounter_kill_spawnmanagers();
	
	const N_ENCOUNTER_TIMEOUT = 20;
	
	wait_till_all_dead_or_timeout( N_ENCOUNTER_TIMEOUT, "fallen_soldiers_robots_cleared" );
	
	level.ai_hendricks SetGoal( GetNode( "fallen_soldiers_hendricks_dayroom_enter_node", "targetname" ), true );
	
	level flag::wait_till( "fallen_soldiers_dayroom_started" ); // Set on triggers
	
	spawner::waittill_ai_group_cleared( "fallen_soldiers_extra_robots" ); // Killspawner on trigger
	
	level.ai_hendricks waittill( "goal" );
	
	wait .5; // HACK: Arrive at node, start idle
		
	play_hendricks_dayroom_scene();
	
	trigger::wait_till( "fallen_soldiers_exit_zone_trig" );
}

function hendricks_battle_movement()
{
	level endon( "fallen_soldiers_robots_cleared" );
	
	wait_till_an_initial_zone_spawned();
	
	level.ai_hendricks SetGoal( GetNode( "fallen_soldiers_hendricks_decon_door_exit_node", "targetname" ), true );
	
	level.ai_hendricks waittill( "goal" );
	
	level.ai_hendricks wait_till_zone_safe_then_move( "fallen_soldiers_hendricks_decon_exit_zone_aitrig" );
	
	level.ai_hendricks ai::set_ignoreme( false );
	
	level flag::wait_till( "fallen_soldiers_lockerroom_second_spawn" ); // Set on triggers
	
	level.ai_hendricks wait_till_zone_safe_then_move( "fallen_soldiers_hendricks_dayroom_approach_aitrig" );
	
	level flag::set( "fallen_soldiers_hendricks_ready_to_enter_dayroom" );
}

function wait_till_an_initial_zone_spawned()
{
	t_spawn_left = GetEnt( "fallen_soldiers_left_first_spawn_trig", "targetname" );
	t_spawn_right = GetEnt( "fallen_soldiers_right_first_spawn_trig", "targetname" );

	t_spawn_left endon( "death" );
	
	t_spawn_right waittill( "death" );
}

// Self is AI
function wait_till_zone_safe_then_move( str_key, str_val = "targetname" )
{
	self endon( "death" );
	level endon( "fallen_soldiers_robots_cleared" );
	
	const N_CHECK_TIME = 1.5;
	
	t_safe = GetEnt( str_key, str_val );
	nd_safe = GetNode( t_safe.target, "targetname" );
	
	t_safe endon( "death" );
	
	do
	{
		t_safe waittill( "trigger" );
		
		n_touchers = 0;
		a_ai_robots = GetAISpeciesArray( "team3", "robot" );
			
		foreach( ai_robot in a_ai_robots )
		{
			if( IsAlive( ai_robot ) && ai_robot IsTouching( self ) )
			{
				n_touchers++;
			}
		}
		
		wait N_CHECK_TIME;
	}
	while( n_touchers > 0 );
	
	self SetGoal( nd_safe );
}

function fallen_soldiers_objective()
{
	level thread sgen_util::set_door_state( "fallen_soldiers_decon_hallway_door", "close" );
	
	level scene::add_scene_func( "cin_sgen_12_01_corvus_vign_secret_entrance_hendricks", &drone_breadcrumb, "init" );
	level scene::init( "cin_sgen_12_01_corvus_vign_secret_entrance_hendricks" ); // Put drone and breadcrumb
	
	level flag::wait_till( "hendricks_corvus_examination" ); //flag on trigger
	
	level scene::add_scene_func( "cin_sgen_12_01_corvus_vign_secret_entrance_hendricks", &open_entrance_hall_doors, "play" );
	level scene::play( "cin_sgen_12_01_corvus_vign_secret_entrance_hendricks" );
	
	level notify( "corvus_entrance_opened" );
	
	level.ai_hendricks waittill( "goal" );
	
	wait .5; // HACK: Arrive at node, start idle
	
	trigger::wait_till( "fallen_soldiers_enter_decon_trig" );
	
	level thread sgen_util::set_door_state( "fallen_soldiers_enter_door", "open" );
	
	objectives::set( "cp_level_sgen_enter_corvus" );
	
	trigger::wait_till( "fallen_soldiers_hendricks_grab_start", undefined, undefined, false );
	
	level scene::init( "cin_sgen_13_01_fallensoldiers_vign_grab_start" ); 
	
	level scene::play( "cin_sgen_13_01_fallensoldiers_vign_grab_start" );
	
	level.ai_hendricks SetGoal( level.ai_hendricks.origin );
	
	level scene::init( "cin_sgen_13_01_fallensoldiers_vign_grab_end" );
		
	t_room = GetEnt( "decontamination_room_trigger", "targetname" );
	t_room sgen_util::gather_point_wait( true, Array( level.ai_hendricks ) );
	
	level notify( "decon_gather_done" );
	
	level thread sgen_util::set_door_state( "fallen_soldiers_enter_door", "close" );

	level notify( "decon_room_door_close" );
	
	level scene::stop( "cin_sgen_13_01_fallensoldiers_vign_grab_end" );
	
	level scene::play( "cin_sgen_13_01_fallensoldiers_vign_grab_end" );
	
	level flag::set( "fallen_soldiers_hendricks_ready" );
}

function open_entrance_hall_doors( a_ents )
{
	level waittill( "hendricks_approaching_exit" ); // Sent by notetrack
	
	level flag::set( "fallen_soldiers_hendricks_approaching_exit" ); // Init on trigger
	
	level.ai_hendricks SetGoal( GetNode( "fallen_soldiers_hendricks_decon_ready_node", "targetname" ), true );
	
	level thread sgen_util::set_door_state( "fallen_soldiers_decon_hallway_door", "open" );
}

function fallen_soldiers_room()
{	
	a_t_robot = GetEntArray( "fallen_soldiers_robot_trigger", "script_noteworthy" );
	sp_robot = GetEnt( "fallen_soldiers_spawner", "targetname" );
	a_t_wakeup = GetEntArray( "fallen_soldiers_walkeup_looktrig", "targetname" );
	
	array::thread_all( a_t_wakeup, &wakeup_think );
	
	foreach ( t_robot in a_t_robot )
	{
		t_robot thread fallen_soldiers_robot_trigger_init( sp_robot );
	}
	
	level thread sgen_util::set_door_state( "fallen_soldiers_enter_door", "close" );
	
	level flag::wait_till( "fallen_soldiers_hendricks_ready" );
	
	level flag::set( "fallen_soldiers_robots_wakeup_started" ); // Init on triggers
	
	PlaySoundAtPosition ( "evt_decon_light_breaker", ( 828, -1411, -4552 ) );
	
	exploder::exploder( "fallen_soldiers_decon_spray" );
	exploder::exploder( "LGT_light_dayroom" );
	
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks ai::set_ignoreme( true );
	level.ai_hendricks SetGoal( GetNode( "fallen_soldiers_hendricks_decon_battle_node", "targetname" ), true );
	
	t_decon_room = GetEnt( "fallen_soldiers_decon_room_wake_trig", "targetname" );
	
	t_decon_room waittill( "death" ); // Wait for this wakeup zone to spawn all and delete
	
	const N_DECON_OPEN_TIMEOUT = 7;
	
	wait_till_all_dead_or_timeout( N_DECON_OPEN_TIMEOUT, "fallen_soldiers_robots_decon_room_cleared" ); // Flag enables triggers
	
	spawn_manager::enable( "fallen_soldiers_decon_room_door_rushers_spawnmanager" );
	
	spawn_manager::wait_till_complete( "fallen_soldiers_decon_room_door_rushers_spawnmanager" );
	
	level notify( "decon_room_door_open" );
	
	level thread sgen_util::set_door_state( "fallen_soldiers_exit_door", "open" );
	
	level thread hendricks_battle_movement();
	
	trigger::wait_till( "fallen_soldiers_decon_room_exit_trig" );
}

function play_hendricks_dayroom_scene()
{
	level scene::add_scene_func( "cin_sgen_12_01_corvus_vign_dayroom", &set_hendricks_end_goal, "play" );
	level scene::play( "cin_sgen_12_01_corvus_vign_dayroom" ); // Hendricks reaches
	
	level notify( "hendricks_dayroom_done" );
}

function set_hendricks_end_goal( a_ents )
{
	level.ai_hendricks.goalradius = 16;
	
	level.ai_hendricks SetGoal( GetNode( "fallen_soldiers_hendricks_hack_door_node", "targetname" ), true );
	
	level.ai_hendricks waittill( "goal" );
	
	level.ai_hendricks ClearForcedGoal();
}

// ***********************************************
// VO Functions
// ***********************************************
function vo()
{
	util::waittill_any( "player_saw_drone", "hendricks_approaching_drone" ); // First notify is sent from look trigger, second is sent from notetrack
	
	level dialog::player_say( "plyr_what_the_hell_happen_0", RandomFloatRange( .1, .2 ) );	// What the hell happened to our Recon Drone?
	
	level waittill( "decon_room_door_close" );
	
	level dialog::player_say( "plyr_what_s_going_on_here_0", RandomFloatRange( .1, .2 ) ); 	// What’s going on here, Kane? 
	
	playsoundatposition( "mus_coalescence_theme_decon", (796,-1406,-4604) );
	
	trigger::wait_till( "fallen_soldiers_hendricks_grab_start", undefined, undefined, false );
	
	level.ai_hendricks dialog::say( "hend_what_the_hell_0", RandomFloatRange( .1, .2 ) ); 		// What the hell???
	
	level waittill( "decon_room_door_open" );
	level waittill( "robot_woke_up" );
	
	level.ai_hendricks dialog::say( "hend_what_the_hell_are_th_0", RandomFloatRange( .1, .2 ) ); //What the hell are they doing? You ever see Grunts do that?
	
	level thread say_dayroom_gps_vo();
	
	level flag::wait_till( "fallen_soldiers_robots_cleared" );
	
	level.ai_hendricks dialog::say( "hend_area_clear_stay_ale_0", RandomFloatRange( 1.5, 2 ) ); // Area clear. Stay alert, no knowing what hides in the dark down here.
	
	level dialog::player_say( "plyr_kane_you_ever_see_a_0", RandomFloatRange( .15, .21 ) );	//Kane, you ever see a robot run like that?
	
	level dialog::remote( "kane_i_ve_never_seen_any_0", RandomFloatRange( .15, .2 ) ); 	// I've never seen any robot behavior like that, it's not in their programming. Somehow they've gone rogue from their preset parameters. Consider any encounter hostile.
	
	level flag::set( "kane_robots_convo_done" );
}

function say_dayroom_gps_vo()
{
	level endon( "fallen_soldiers_completed" ); // Flag set by skipto system
	
	trigger::wait_till( "fallen_soldiers_enter_reception_looktrig" ); // Player inside reception and facing the way he should go
	
	level flag::wait_till( "kane_robots_convo_done" );
	
	level dialog::remote( "kane_according_to_the_gps_0" ); // According to the GPS, the source of the signal should be through there.
}

// ***********************************************
// Robots Wakeup Functions
// ***********************************************
function wait_till_all_dead_or_timeout( n_timeout, str_flag )
{
	level thread monitor_encounter( str_flag );
	
	level flag::wait_till_timeout( n_timeout, str_flag );
	level flag::set( str_flag );
}

// Self is trigger look
function wakeup_think()
{
	self endon( "death" );
	level endon( "fallen_soldiers_terminate" );
	
	s_lookpoint = struct::get( self.target, "targetname" );
	t_activate = GetEnt( s_lookpoint.target, "targetname" );
	
	t_activate endon( "death" );
	
	while( true )
	{
		self waittill( "trigger" );
		
		if( isdefined( t_activate ) )
		{
			t_activate trigger::use();
		}
		else
		{
			self Delete();
		}
	}
}

// Self is trigger
function fallen_soldiers_robot_trigger_init( sp_robot )
{
	self endon( "death" );
	level endon( "fallen_soldiers_terminate" );
	
	Assert( IsDefined( self.target ), "Fallen Soldier Robot trigger not targeting a ScriptBundle at: " + self.origin );
	
	a_ai_robots = [];
	a_s_scriptbundles = struct::get_array( self.target );

	foreach( n_count, s_scriptbundle in a_s_scriptbundles )
	{
		a_ai_robots[ n_count ] = spawner::simple_spawn_single( sp_robot );
		s_scriptbundle thread scene::init( a_ai_robots[ n_count ] );
	}
	
	level flag::wait_till( "fallen_soldiers_robots_wakeup_started" );
	
	foreach( n_count, s_scriptbundle in a_s_scriptbundles )
	{
		if( IsAlive( a_ai_robots[ n_count ] ) )
		{
			self fallen_soldiers_robot_wakeup( a_ai_robots[ n_count ], s_scriptbundle );
		}
	}
	
	self Delete();
}

// Self is trigger
function fallen_soldiers_robot_wakeup( ai_robot, s_scriptbundle )
{
	level endon( "fallen_soldiers_terminate" );
	ai_robot endon( "death" );
	self endon( "death" );
	
	self util::waittill_any_ents( ai_robot, "damage", self, "trigger" );
	
	wait RandomFloatRange( .1, .25 ); // Delay before wakeup
		
	ai_robot robot_wake_up();
	s_scriptbundle scene::play( ai_robot );
	
	level notify( "robot_woke_up" );
	
	wait_till_wakeup_cooldown_expired();
}

function wait_till_wakeup_cooldown_expired()
{
	const N_SP_MIN = 2.9;
	const N_SP_MAX = 3.7;
	const N_COOP_SCALE_MIN = -.55;
	const N_COOP_SCALE_MAX = -.71;
	
	// Increase potential wakeup rate with each player added
	n_min_wait = sgen_util::get_num_scaled_by_player_count( N_SP_MIN, N_COOP_SCALE_MIN );
	n_max_wait = sgen_util::get_num_scaled_by_player_count( N_SP_MAX, N_COOP_SCALE_MAX );
	
	if( n_min_wait < 0 )
	{
		n_min_wait = 0;
	}
	if( n_max_wait <= 0 )
	{
		n_max_wait = .2;
	}
	
	wait RandomFloatRange( n_min_wait, n_max_wait );
}

// Self is AI
function robot_wake_spawnfunc()
{
	// TODO: need to solve crosshairs turning red
	// TODO: need to solve showing up in tactical view
	
	self.team = "team3";
	
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	
	self NotSolid(); // Disable collision, tmode, ev mode, aim assist, crosshair highlight
}

// Self is AI
function robot_spawnfunc()
{
	self endon( "death" );
	
	self.team = "team3";
	self.is_awoken = true;
	n_level = 2; // Default level is 2 - rusher
	
	if( isdefined( self.script_int ) ) // self.script_int is robot level
	{
		n_level = self.script_int;
	}
	
	self ai::set_behavior_attribute( "rogue_control", "forced_level_" + n_level );
	
	// Hide tells until they have started moving
	self NotSolid();
	
	wait RandomFloatRange( .5, .7 );
	
	self Solid();
}

// Self is AI
function robot_wake_up()
{
	self.is_awoken = true;
	
	self playsound( "evt_robot_ambush_arise" );
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	
	self Solid();
}

function monitor_encounter( str_flag )
{
	level endon( str_flag );
	
	a_ai_robots = GetAISpeciesArray( "team3", "robot" );
		
	a_ai_robots wait_till_all_death( str_flag );
	
	level flag::set( str_flag );
}

// Self is array of AI
function wait_till_all_death( str_ender )
{
	level endon( str_ender );
	
	foreach( ai_robot in self )
	{
		if( IsAlive( ai_robot ) && ( isdefined( ai_robot.is_awoken ) && ai_robot.is_awoken ) )
		{
			ai_robot waittill( "death" );
		}
	}
}

function encounter_kill_spawnmanagers()
{
	trigger::wait_till( "fallen_soldiers_encounter_clear_trig", undefined, undefined, false );
	
	spawn_manager::kill( "fallen_soldiers_mid_encounter_group" );
	spawn_manager::kill( "fallen_soldiers_end_encounter_group" );
}

// ***********************************************
// Objectives
// ***********************************************
function handle_breadcrumbs()
{
	level waittill( "corvus_entrance_opened" );
	
	objectives::set( "cp_level_sgen_gather" , struct::get( "fallen_soldiers_decon_breadcrumb" ) );
	
	level waittill( "decon_gather_done" );
	
	objectives::complete( "cp_level_sgen_gather" );
	
	level waittill( "decon_room_door_open" );
	
	objectives::set( "cp_level_sgen_breadcrumb" , struct::get( "fallen_soldiers_decon_room_exit_breadcrumb" ) );
	
	trigger::wait_till( "fallen_soldiers_decon_room_exit_breadcrumb_trig" );
	
	objectives::complete( "cp_level_sgen_breadcrumb" );
	
	objectives::set( "cp_level_sgen_breadcrumb" , struct::get( "fallen_soldiers_dayroom_breadcrumb2" ) );
	
	trigger::wait_till( "fallen_soldiers_encounter_clear_trig" );
	
	objectives::complete( "cp_level_sgen_breadcrumb" );
	
	objectives::set( "cp_level_sgen_breadcrumb" , struct::get( "fallen_soldiers_dayroom_breadcrumb" ) );
	
	level waittill( "hendricks_dayroom_done" );
		
	objectives::complete( "cp_level_sgen_breadcrumb" );
	
	objectives::set( "cp_level_sgen_breadcrumb" , struct::get( "fallen_soldiers_end_breadcrumb" ) );
}

function drone_breadcrumb( a_ents )
{
	objectives::set( "cp_level_sgen_breadcrumb", a_ents[ "mapping_drone" ] );
	
	level waittill( "hendricks_approaching_exit" ); // Sent by notetrack
	
	objectives::complete( "cp_level_sgen_breadcrumb", a_ents[ "mapping_drone" ] );
}
