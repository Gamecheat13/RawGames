#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\colors_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_status;
#using scripts\shared\vehicles\_quadtank;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\animation_shared;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_killing_streets;

function skipto_killing_streets_init( str_objective, b_starting )
{	
	vengeance_util::skipto_baseline( str_objective, b_starting );
	
	if ( b_starting )
	{
		vengeance_util::init_hero( "hendricks", str_objective );
	}
	
	killing_streets_main( str_objective );
}

function killing_streets_main( str_objective )
{
	//setup spawn function on civilians
    killing_streets_civilian_spawners = getentarray( "killing_streets_civilian_spawners", "script_noteworthy" );
    foreach ( spawner in killing_streets_civilian_spawners )
    {
    	spawner spawner::add_spawn_function( &setup_killing_streets_civilian );
    }
    
    level thread setup_killing_streets_intro_patroller_spawners();
    
    level.ai_hendricks thread setup_killing_streets_alley_hendricks();
    level.ai_hendricks thread setup_killing_streets_alley_hendricks_stealth_broken();
    
    vengeance_util::enable_nodes( "killing_streets_window_traversal_nodes", "targetname", false );
    
    //get the scripted node for the lineup kill script bundles
    level.lineup_kill_scripted_node = struct::get( "lineup_kill_scripted_node", "targetname" );
    
    //init cin_ven_03_20_storelineup_vign_start so the first door spawns in
    level.lineup_kill_scripted_node thread scene::init( "cin_ven_03_20_storelineup_vign_start" );
    
    //init cin_ven_03_20_storelineup_vign_fire so the double doors spawns in
    level.lineup_kill_scripted_node thread scene::init( "cin_ven_03_20_storelineup_vign_fire" );
    
    //init cin_ven_03_20_storelineup_vign_exit so the last door spawns in
    level.lineup_kill_scripted_node thread scene::init( "cin_ven_03_20_storelineup_vign_exit" );
    
    {wait(.05);};
    
    level.storelineup_door1 = getent( "storelineup_door1", "targetname" );
	level.storelineup_door1.clip = getent( "storelineup_door1_clip", "targetname" );
	level.storelineup_door1.clip linkto( level.storelineup_door1 );
	
	level.storelineup_door3 = getent( "storelineup_door3", "targetname" );
	level.storelineup_door3.clip = getent( "storelineup_door3_clip", "targetname" );
	level.storelineup_door3.clip linkto( level.storelineup_door3 );
}

function killing_streets_vo_temp()
{
	level flag::wait_till( "killing_streets_vo" );
	self thread dialog::say( "Watch your fire...lots of civilians scattering." );
}

function setup_killing_streets_alley_hendricks()
{
	level endon( "stealth_combat" );
	level endon( "stealth_alert" );
	self endon( "death" );
	
	self.holdfire = true;
	self.ignoreall = false;
	self.ignoreme = true;
	self colors::disable();
	self ai::set_behavior_attribute( "cqb", true );
	self.goalradius = 32;
	objectives::set( "cp_standard_follow_breadcrumb", self );
	
	self thread killing_streets_vo_temp();
//	self thread dialog::say( "Watch your fire...lots of civilians scattering." );
	
	node = getnode( "killing_streets_hendricks_node_05", "targetname" );
	//self thread ai::force_goal( node, 16 );
	self SetGoal( node, true, 16 );
	level flag::wait_till( "move_killing_streets_hendricks_node_10" );
	
	node = getnode( "killing_streets_hendricks_node_10", "targetname" );
	//self thread ai::force_goal( node, 16 );
	self SetGoal( node, true, 16 );
	level flag::wait_till( "move_killing_streets_hendricks_node_15" );
	
	node = getnode( "killing_streets_hendricks_node_15", "targetname" );
	//self ai::force_goal( node, 16 );
	self SetGoal( node, true, 16 );
	//self waittill( "goal" );
	
	if ( !level flag::get( "killing_streets_intro_patroller_spawners_cleared" ) )
	{
		self thread dialog::say( "Targets ahead.  Drop 'em." );
		
		self.ignoreme = false;
		self.holdfire = false;
		
		level flag::wait_till( "killing_streets_intro_patroller_spawners_cleared" );
		
		self.holdfire = true;
		self.ignoreme = true;
	}
}

function setup_killing_streets_alley_hendricks_stealth_broken()
{
	level flag::wait_till_any( Array( "stealth_alert", "stealth_combat" ) );
	
	{wait(.05);};
	
	self.ignoreme = false;
	self.holdfire = false;
	self ai::set_behavior_attribute( "cqb", false );
	self colors::enable();
	
	level flag::wait_till( "killing_streets_intro_patroller_spawners_cleared" );
	
	level flag::wait_till_clear_all( Array( "stealth_alert", "stealth_combat" ) );
	
	self colors::disable();
	self.ignoreme = true;
	self.holdfire = true;
	
	self thread setup_killing_streets_lineup_hendricks();
}
	
function setup_killing_streets_lineup_hendricks()
{
	level endon( "killing_streets_lineup_patrollers_alerted" );
	self endon( "death" );
	
	self thread setup_killing_streets_lineup_hendricks_stealth_broken();
	
	self thread dialog::say( "Keep moving." );
	
	self ai::set_behavior_attribute( "cqb", false );
	
	node = getnode( "killing_streets_hendricks_node_20", "targetname" );
	//self ai::force_goal( node, node.radius );
	self SetGoal( node, true, 16 );
	self waittill( "goal" );
	level flag::set( "enable_hendricks_open_alley_door_01" );
	level flag::wait_till( "start_hendricks_open_alley_door_01" );
	
	self ai::set_behavior_attribute( "cqb", true );
	
	level thread killing_streets_robots();
    level thread killing_streets_stealth_monitor();
    
    spawner::add_spawn_function_group( "killing_streets_lineup_patroller_spawners", "script_noteworthy", &setup_killing_streets_lineup_patroller_spawners );
    spawner::add_spawn_function_group( "killing_streets_lineup_civilian_spawners", "script_noteworthy", &setup_killing_streets_civilian_lineup );
    
	self thread dialog::say( "Get down.  Too many of them.  Do not engage." );
	
	level.storelineup_door1.clip thread storelineup_door1_clip();
	level thread lineup_kill_scene_manager();
	level thread lineup_kill_scene_stopper();
	
	level waittill( "cin_ven_03_20_storelineup_vign_start_done" );
	
	if ( !level flag::get( "move_killing_streets_hendricks_node_30" ) )
	{
		level.lineup_kill_scripted_node thread scene::init( "cin_ven_03_20_storelineup_vign_move1" );
		level flag::wait_till( "move_killing_streets_hendricks_node_30" );
	}
	
	self thread dialog::say( "Stay down and follow me." );
	level.lineup_kill_scripted_node scene::play( "cin_ven_03_20_storelineup_vign_move1" );
	
	if ( !level flag::get( "move_killing_streets_hendricks_node_35" ) )
	{
		level.lineup_kill_scripted_node thread scene::init( "cin_ven_03_20_storelineup_vign_move2" );
		level flag::wait_till( "move_killing_streets_hendricks_node_35" );
	}
	
	level.lineup_kill_scripted_node scene::play( "cin_ven_03_20_storelineup_vign_move2" );
	
	if ( !level flag::get( "move_killing_streets_hendricks_node_40" ) && !level flag::get( "cin_ven_03_20_storelineup_vign_fire_done" ) )
	{
		level.lineup_kill_scripted_node thread scene::init( "cin_ven_03_20_storelineup_vign_move3" );
		level flag::wait_till_all( Array( "move_killing_streets_hendricks_node_40", "cin_ven_03_20_storelineup_vign_fire_done" ) );
	}
	
	level.lineup_kill_scripted_node scene::play( "cin_ven_03_20_storelineup_vign_move3" );
	
	level flag::set( "enable_hendricks_open_alley_door_02" );
	
	if ( !level flag::get( "start_hendricks_open_alley_door_02" ) )
	{
		level.lineup_kill_scripted_node thread scene::init( "cin_ven_03_20_storelineup_vign_exit" );
		level flag::wait_till( "start_hendricks_open_alley_door_02" );
	}
	
	objectives::complete( "cp_standard_follow_breadcrumb", self );
	level thread dogleg_1_intro_trigger();
	
	level.storelineup_door3.clip thread storelineup_door3_clip();
	self thread dialog::say( "Okay...move." );
	level.lineup_kill_scripted_node scene::play( "cin_ven_03_20_storelineup_vign_exit" );
	
	node = getnode( "killing_streets_hendricks_node_55", "targetname" );
	//self thread ai::force_goal( node, 16 );
	self SetGoal( node, true, 16 );
	
	level notify( "stop_setup_killing_streets_lineup_hendricks_stealth_broken" );
	
	//waitflag
	
	node = getnode( "killing_streets_hendricks_node_60", "targetname" );
	//self thread ai::force_goal( node, 16 );
	self SetGoal( node, true, 16 );
}

function setup_killing_streets_lineup_hendricks_stealth_broken()
{
	level endon( "stop_setup_killing_streets_lineup_hendricks_stealth_broken" );
	
	level flag::wait_till( "killing_streets_lineup_patrollers_alerted" );
	
	{wait(.05);};
	
	self stopanimscripted();
	//only play this if we are in prone
	self scene::play( "cin_ven_03_20_storelineup_vign_stand" );
	self.ignoreme = false;
	self.holdfire = false;
	self ai::set_behavior_attribute( "cqb", false );
	self colors::enable();
	
	level flag::wait_till_all( Array( "killing_streets_lineup_patroller_spawners_cleared", "killing_streets_robots_cleared" ) );
	
	self.ignoreme = true;
	self.holdfire = true;
	self ai::set_behavior_attribute( "cqb", true );
	self colors::disable();
	
	objectives::complete( "cp_standard_follow_breadcrumb", self );
	level thread dogleg_1_intro_trigger();
	
	level.storelineup_door3.clip thread storelineup_door3_clip();
	self thread dialog::say( "Okay...move." );
	level.lineup_kill_scripted_node scene::play( "cin_ven_03_20_storelineup_vign_exit_reach" );
	
	node = getnode( "killing_streets_hendricks_node_55", "targetname" );
	//self thread ai::force_goal( node, 16 );
	self SetGoal( node, true, 16 );
	
	//waitflagz
	
	node = getnode( "killing_streets_hendricks_node_60", "targetname" );
	//self thread ai::force_goal( node, 16 );
	self SetGoal( node, true, 16 );
}

function lineup_kill_scene_manager()
{
	level endon( "killing_streets_lineup_patrollers_alerted" );
	
	level.lineup_kill_scripted_node scene::play( "cin_ven_03_20_storelineup_vign_start" );
	
	level notify( "cin_ven_03_20_storelineup_vign_start_done" );
	
	level.lineup_kill_scripted_node thread scene::play( "cin_ven_03_20_storelineup_vign_loop" );
	
	level flag::wait_till( "move_killing_streets_hendricks_node_35" );
	
	level.lineup_kill_scripted_node scene::stop( "cin_ven_03_20_storelineup_vign_loop" );
	
	level.lineup_kill_scripted_node scene::play( "cin_ven_03_20_storelineup_vign_fire" );
	
	level flag::set( "cin_ven_03_20_storelineup_vign_fire_done" );
	
	node = GetNode( "killing_streets_lineup_patroller_spawners_exit_node", "targetname" );
	
	guys = getentarray( "killing_streets_lineup_patroller_spawners", "script_noteworthy", true );
	foreach ( guy in guys )
	{
		if ( isdefined( guy ) && isalive( guy ) )
		{
			guy thread ai::patrol( node );
		}
	}
}

function lineup_kill_scene_stopper()
{
	level flag::wait_till( "killing_streets_lineup_patrollers_alerted" );
	
	if ( scene::is_playing( "cin_ven_03_20_storelineup_vign_start" ) )
	{
		level.lineup_kill_scripted_node scene::stop( "cin_ven_03_20_storelineup_vign_start" );
	}
	
	if ( scene::is_playing( "cin_ven_03_20_storelineup_vign_loop" ) )
	{
		level.lineup_kill_scripted_node scene::stop( "cin_ven_03_20_storelineup_vign_loop" );
	}
	
	if ( scene::is_playing( "cin_ven_03_20_storelineup_vign_fire" ) )
	{
		level.lineup_kill_scripted_node scene::stop( "cin_ven_03_20_storelineup_vign_fire" );
	}
}

function storelineup_door1_clip()
{
	wait 3.0;
	
	self connectpaths();
}

function storelineup_door3_clip()
{
	wait 3.0;
	
	self connectpaths();
}

function setup_killing_streets_intro_patroller_spawners()
{
	level flag::wait_till( "spawn_killing_streets_intro_patroller_spawners" );
	
    killing_streets_intro_patroller_spawners = spawner::simple_spawn( "killing_streets_intro_patroller_spawners", &vengeance_util::setup_patroller );
}

function setup_killing_streets_civilian()
{
	self endon( "death" );
	
	self.team = "allies";
	//self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "panic" , false );
	self.health = 1;
	node = GetNode( self.target, "targetname" );
	self thread ai::force_goal( node, node.radius );
}

function setup_killing_streets_civilian_lineup()
{
	self endon( "death" );
	
	self.team = "allies";
	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "panic" , false );
	//self.health = 1;
	
	level flag::wait_till( "killing_streets_lineup_patrollers_alerted" );
	
	self stopanimscripted();
	self ai::set_ignoreme( false );
	self ai::set_behavior_attribute( "panic" , true );
	
	//node = GetNode( self.target, "targetname" );
	//self ai::force_goal( node, node.radius );
}

function setup_killing_streets_lineup_patroller_spawners()
{
	self util::waittill_any( "damage", "alert" );
	
	level flag::set( "killing_streets_lineup_patrollers_alerted" );
	
	self stopanimscripted();
	self stealth_aware::set_awareness( "combat" );
}

function killing_streets_robots()
{
	killing_streets_robots = spawner::simple_spawn( "killing_streets_robots", &killing_streets_robots_spawn, undefined, undefined, undefined, undefined, undefined, true );
}

function killing_streets_robots_spawn()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	level flag::wait_till( "killing_streets_lineup_patrollers_alerted" );
	
	//slight delay
	wait randomfloatrange( 0.1, 0.5 );
	
	//wake me up
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
}

function killing_streets_stealth_monitor()
{
	level flag::wait_till( "killing_streets_lineup_patrollers_alerted" );
	
	killing_streets_window_clips = getentarray( "killing_streets_window_clips", "targetname" );
	array::thread_all( killing_streets_window_clips, &killing_streets_window_clips_off );
	
	{wait(.05);};
	
	vengeance_util::enable_nodes( "killing_streets_window_traversal_nodes", "targetname", true );
}

function killing_streets_window_clips_off()
{
	self notsolid();
	self connectpaths();
	self Delete();
}

function skipto_killing_streets_done( str_objective, b_starting, b_direct, player )
{
	level thread cleanup_killing_streets();
}

//this should clean up all ents/scripting/etc...when the players cleared the area
function cleanup_killing_streets()
{
	dogleg_1_intro_door_obj_org = struct::get( "dogleg_1_intro_door_obj_org" );
	objectives::complete( "cp_standard_breadcrumb", dogleg_1_intro_door_obj_org );
	array::thread_all( GetAITeamArray( "axis" ), &util::self_delete );
	array::run_all( GetCorpseArray(), &Delete );
}

function dogleg_1_intro_trigger()
{
	dogleg_1_intro_door_obj_org = struct::get( "dogleg_1_intro_door_obj_org" );
	objectives::set( "cp_standard_breadcrumb", dogleg_1_intro_door_obj_org );
	
	dogleg_1_intro_trigger = GetEnt( "dogleg_1_intro_trigger", "script_noteworthy" );
	level thread stealth_combat_toggle_trigger_and_objective( dogleg_1_intro_trigger, "cp_standard_breadcrumb", "start_dogleg_1_intro" );
}

function stealth_combat_toggle_trigger_and_objective( e_trigger, str_objective, str_ender )
{
	e_trigger endon( "death" );
	
	if ( isDefined( str_ender ) )
	{
		level endon( str_ender );
	}
	
	while ( 1 )
	{
		level flag::wait_till( "stealth_combat" );
			
		e_trigger triggerEnable( false );
		e_trigger MakeUnusable();
		
		if ( isDefined( str_objective ) )
		{
			objectives::hide( str_objective );
		}
		
		level flag::wait_till_clear( "stealth_combat" );
		
		e_trigger triggerEnable( true );
		e_trigger MakeUsable();
		
		if ( isDefined( str_objective ) )
		{
			objectives::show( str_objective );
		}
	}
}