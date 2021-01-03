#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\math_shared;
#using scripts\shared\turret_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;
#using scripts\shared\stealth;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicles\_quadtank;

#using scripts\cp\_debug;
#using scripts\cp\sidemissions\_sm_ui;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;



#namespace vengeance_market;

/*****************************************
 * -- Stealth from Garage to Safehouse --
 * ***************************************/

function skipto_quad_init( str_objective, b_starting )
{
	if( b_starting )
	{
		vengeance_util::skipto_baseline();
		
		vengeance_util::init_hero( "hendricks", str_objective );
		level.ai_hendricks colors::disable();
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );
		level.ai_hendricks.goalradius = 32;
		
//		e_node = GetNode( "hendricks_market_entry_node", "targetname" );
//		level.ai_hendricks setgoalnode( e_node, true );
//				
//		level flag::wait_till( "all_players_spawned" );
	}
	
	level thread quad_battle_vo();
//	level thread quad_battle_intro_destruction();
	level.ai_hendricks thread quad_battle_hendricks();
	quad_battle_main();
}

function skipto_quad_done( str_objective, b_starting, b_direct, player )
{

}

//function quad_battle_glass_hide()
//{
//	a_facade_glass = getentarray( "quad_market_glass_shards", "targetname" );
//	
//	foreach( e_glass in a_facade_glass )
//	{
//		e_glass hide();
//	}
//}
//
//function quad_battle_glass_show()
//{
//	a_facade_glass = getentarray( "quad_market_glass_shards", "targetname" );
//	
//	foreach( e_glass in a_facade_glass )
//	{
//		e_glass show();
//	}
//}

function quad_battle_main()
{
//    text_array = [];
//	text_array[ 0 ] = "This is not the final layout/position";
//	text_array[ 1 ] = "for the Quad Tank.  Some geo was removed";
//	text_array[ 2 ] = "and we're re-evaluating.";
//	text_array[ 3 ] = "It's expected most everything in this area will";
//	text_array[ 4 ] = "be destructable.";
//	
//	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, false );
	
	//wait 3;
	e_quadtank_spawner = getent( "plaza_quadtank", "targetname" );
   	e_quadtank_spawner spawner::add_spawn_function( &quad_battle_quadtank_setup );
	
	level.quadtank = spawner::simple_spawn_single( "plaza_quadtank" );
	
	level.quadtank waittill( "death" );
	level flag::set( "quad_battle_ends" );
	
	objectives::complete( "cp_level_vengeance_destroy_quad" );
	
	//Hendricks - Nice job.  Through here.
	//level.ai_hendricks dialog::say( "Nice job.  Through here." );
	level.ai_hendricks dialog::say( "hend_nice_job_pause_0" );
	
	
	level flag::wait_till_all( array( "hendricks_exiting_market", "players_exiting_market" ) );

	e_mall_door = GetEnt( "shopping_mall_door", "targetname" );
	e_mall_door movez( 128.0, 3.0 ); 
	e_mall_door connectpaths();
	
	level flag::set( "exiting_market" );
	
	level flag::wait_till_all( array( "hendricks_at_plaza", "players_at_plaza" ) );
	
	skipto::objective_completed( "quad_battle" );
}

function quad_battle_quadtank_setup()
{
	self endon( "death" );
	
//	foreach ( player in level.players )
//	{
//		self setignoreent( player, true );
//	}
//	
//	self setignoreent( level.ai_hendricks, true );

//	self vehicle_ai::set_state( "scripted" );
//	
//	e_target = getent( "quad_market_cannon_target", "targetname" );
//	
//	self SetTurretTargetEnt( e_target );
//	self SetLookAtEnt( e_target );
//	
//	wait 1;
//	
//	self ASMRequestSubstate( "fire@stationary" );
//	self thread quadtank::set_detonation_time();
//	
//	self waittill( "weapon_fired", proj );
//	e_pillar = getent( "garage_pillar_01", "targetname" );
//	e_pillar connectpaths();
//	e_pillar delete();
//	
//	self vehicle_ai::waittill_asm_complete( "fire@stationary", 4 );
	
	objectives::set( "cp_level_vengeance_destroy_quad" );
	level flag::set( "quad_battle_starts" );
	
//	self vehicle_ai::set_state( "combat" );
//	
//	foreach ( player in level.players )
//	{
//		self setignoreent( player, false );
//	}
//
//	self setignoreent( level.ai_hendricks, false );
	
	self.goalradius = 64;
	self setneargoalnotifydist( 64 );
	
//	s_goal = struct::get( "quad_market_qt_node_01", "targetname" );
	e_goalvolume = GetEnt( "quad_tank_goal_volume", "targetname" );
	self setGoal( e_goalvolume, true );
//	self util::waittill_either( "near_goal", "goal" );	
	
//	util::wait_network_frame();

}

//function quad_battle_intro_destruction()
//{
//	a_breakables_01 = getentarray( "quad_market_breakables_01", "targetname" );
//	a_breakables_02 = getentarray( "quad_market_breakables_02", "targetname" );
//	a_breakables_03 = getentarray( "quad_market_breakables_03", "targetname" );
//	a_breakables_04 = getentarray( "quad_market_breakables_04", "targetname" );
//	a_breakables_05 = getentarray( "quad_market_breakables_05", "targetname" );
//	
//	trigger::wait_till( "destroy_01" );
//	array::delete_all( a_breakables_01 );
//	
//	trigger::wait_till( "destroy_02" );
//	array::delete_all( a_breakables_02 );
//	
//	trigger::wait_till( "destroy_03" );
//	array::delete_all( a_breakables_03 );
//	
//	trigger::wait_till( "destroy_04" );
//	array::delete_all( a_breakables_04 );
//	
//	trigger::wait_till( "destroy_05" );
//	array::delete_all( a_breakables_05 );
//}

//function quad_battle_facade( proj )
//{
//	while( isdefined( proj ))
//	{
//		wait .05;
//	}
//	
//	e_facade = getent( "quad_market_facade", "targetname" );
//	e_facade connectpaths();
//	
//	e_facade delete();
//		
//	level thread quad_battle_glass_show();
//}

function quad_battle_hendricks()
{
	level flag::wait_till( "quad_battle_starts" );
	
//	e_exit_door = GetEnt( "market_shop_exit_door", "targetname" );
//	e_exit_door thread vengeance_util::handle_door( 2 );
//	
//	wait 1.5; //waiting for door to open.
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
	self ai::set_behavior_attribute( "cqb", false );
	
	e_node = getnode( "quad_battle_hendricks", "targetname" );
	self setgoalnode( e_node, true );
	
	level flag::wait_till( "quad_battle_ends" );
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
		
	e_node = GetNode( "hendricks_exit_market_node", "targetname" );
	self setgoalnode( e_node, true );
	
	self waittill( "goal" );
	self ai::set_behavior_attribute( "cqb", true );
	
	level flag::wait_till( "exiting_market" );
	wait 2.5; //waiting for door to open.
	
	e_node = GetNode( "hendricks_plaza_node", "targetname" );
	self setgoalnode( e_node, true );
	
	self waittill( "goal" );
	
	level flag::set( "hendricks_at_plaza" );
}

function quad_battle_vo()
{
	//Hendricks:  Stop.  Do you hear that?
	//level.ai_hendricks dialog::say( "Stop.  Do you hear that?", 0 );
	level.ai_hendricks dialog::say( "hend_stop_do_you_hear_t_0", 0 );
	
	//Hendricks:  Quad Tank!  Take cover!
	//level.ai_hendricks dialog::say( "hend_quad_tank_take_0", 0 );
	level.ai_hendricks dialog::say( "hend_quad_tank_take_cove_0", 0 );
}

/*****************************************
 * -- Plaza Ambush/Combat --
 * ***************************************/

function skipto_plaza_init( str_objective, b_starting )
{
	if( b_starting )
	{
		vengeance_util::skipto_baseline();
		
		vengeance_util::init_hero( "hendricks", str_objective );
		
		waittillframeend;
		
		level flag::wait_till( "all_players_spawned" );
		
		level.ai_hendricks colors::disable();
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
		
		e_node = GetNode( "hendricks_plaza_node", "targetname" );
		level.ai_hendricks setgoalnode( e_node, true );
	}
	
	level.ai_hendricks thread plaza_hendricks();
	level thread plaza_enemies();
	level thread plaza_combat_failsafe();
	plaza_main();
}

function skipto_plaza_done( str_objective, b_starting, b_direct, player )
{
//	if( isdefined( level.ai_hendricks ))
//	{
//		level.ai_hendricks Delete();
//	}
}

function plaza_main()
{
//	level flag::wait_till_all( array( "hendricks_exiting_market", "players_exiting_market" ) );
//
//	e_mall_door = GetEnt( "shopping_mall_door", "targetname" );
//	e_mall_door movez( 128.0, 3.0 ); 
//	e_mall_door connectpaths();
//	
//	level flag::set( "exiting_market" );
//	
//	level flag::wait_till_all( array( "hendricks_at_plaza", "players_at_plaza" ) );
//	
	text_array = [];
	text_array[ 0 ] = "We're planning a new device to start an";
	text_array[ 1 ] = "ambush of the 54, an explosive small drone.";
	text_array[ 2 ] = "The players would plant them on anything,";
	text_array[ 3 ] = "detonate them, and start the battle.";
	
	level debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, false );
	
	//Hendricks - We have the element of surprise.
	level.ai_hendricks dialog::say( "hend_we_have_the_element_0" );
	
	//Hendricks - See if you can get to that technical.
	level.ai_hendricks dialog::say( "hend_see_if_you_can_get_t_0" );
	
	objectives::set( "cp_level_vengeance_clear_plaza" );
	
	//spawner::waittill_ai_group_cleared( "plaza_enemies" );//commented this out because 1 or more of the guys couldn't be found to kill
	spawner::waittill_ai_group_ai_count( "plaza_enemies", 2 ); //put this in to just wait until a couple guys are left
	guys = spawner::get_ai_group_ai( "plaza_enemies" ); //get those few remaining guys and manually kill them so they're not shooting at us in the cinematic
	foreach ( guy in guys )
	{
		if ( isDefined( guy ) && isAlive( guy ) )
		{
			guy Kill();
		}
	}
	level flag::set( "plaza_cleared" );
	
	objectives::complete( "cp_level_vengeance_clear_plaza" );
	
	//Hendricks - We’re clear, let’s go!
	level.ai_hendricks dialog::say( "hend_we_re_clear_let_s_g_0" );
	
	skipto::objective_completed( "safehouse_plaza" );
}

function plaza_combat_failsafe()
{
	trigger::wait_till( "plaza_combat_failsafe", "targetname" );
	level notify( "plaza_combat_live" );
}

function plaza_hendricks()
{
//	self ai::set_ignoreall( true );
//	self ai::set_ignoreme( true );
//		
//	e_node = GetNode( "hendricks_exit_market_node", "targetname" );
//	self setgoalnode( e_node, true );
//	
//	self waittill( "goal" );
//	self ai::set_behavior_attribute( "cqb", true );
//	
//	level flag::wait_till( "exiting_market" );
//	wait 2.5; //waiting for door to open.
//
//	e_node = GetNode( "hendricks_plaza_node", "targetname" );
//	self setgoalnode( e_node, true );
//	
//	self waittill( "goal" );
	
//	level flag::set( "hendricks_at_plaza" );
	
	level waittill( "plaza_combat_live" );

	s_struct = struct::get( "hendricks_plaza_teleport", "targetname" );
	self skipto::teleport_single_ai( s_struct );
//	self ForceTeleport( s_struct.origin, s_struct.angles );
	
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
	self ai::set_behavior_attribute( "cqb", false );
	self stealth::stop();
	
	level flag::wait_till( "plaza_cleared" );
	
	e_node = GetNode( "hendricks_approach_sh_node", "targetname" );
	self setgoalnode( e_node, true );
	
	trigger::wait_till( "players_near_safehouse", "targetname" );
	
//	self delete(); //Shouldn't need Hendricks anymore after IGC.
}

function plaza_enemies()
{
	//Vehicle Spawn Functions
	vehicle::add_spawn_function( "plaza_enemies_technical_01", &spawn_func_plaza_technical, "plaza_enemies_technical_01_gunner" );
	vehicle::add_spawn_function( "plaza_enemies_technical_02", &spawn_func_plaza_technical, "plaza_enemies_technical_02_gunner" );

	//Enemy Spawn Functions
	spawner::add_global_spawn_function( "axis", &stealth::stop );
	spawner::add_global_spawn_function( "axis", &vengeance_util::magic_bullet_shield_till_notify, "plaza_combat_live", true );
	
	//Safehouse Ally Spawn Functions
	e_manager = getent( "plaza_allies_spawn_manager", "targetname" );
	spawner::add_spawn_function_group( e_manager.target, "targetname", &stealth::stop );
	spawner::add_spawn_function_group( e_manager.target, "targetname", &vengeance_util::magic_bullet_shield_till_notify, "plaza_combat_live", true );
	
	trigger::wait_till( "exit_to_plaza" );
		
	spawn_manager::enable( "plaza_allies_spawn_manager" );
	waittillframeend;	
	spawner::simple_spawn( "plaza_enemies_wave_01" );
	e_plaza_technical_01 = vehicle::simple_spawn_single( "plaza_enemies_technical_01" );
	e_plaza_technical_02 = vehicle::simple_spawn_single( "plaza_enemies_technical_02" );
	waittillframeend;
	spawner::simple_spawn( "plaza_enemies_wave_02" );
	waittillframeend;
	spawner::simple_spawn( "plaza_enemies_wave_03" );
}

//TECHNICAL VEHICLE STUFF
function spawn_func_plaza_technical( str_gunner_targetname )
{
	// self = vehicle
	self endon( "death" );
	
	self flag::init( "gunner_position_occupied" );
	
	if( isdefined( str_gunner_targetname ))
	{
		ai_gunner = self spawn_turret_gunner( str_gunner_targetname );
		ai_gunner thread kill_ai_on_vehicle_death( self );
		ai_gunner thread turret_disable_on_vehicle_death( self );
		
		self thread gunner_position_think();
	}
}

// HACK: fake gunner doesn't aim properly
function spawn_turret_gunner( str_gunner_targetname )
{
	// self = vehicle
	ai_gunner = spawner::simple_spawn_single( str_gunner_targetname );

	ai_gunner vehicle::get_in( self, "gunner1", true );  // teleport AI to gunner position
	ai_gunner ai::set_ignoreme( true );  //want players to kill him
	ai_gunner thread vengeance_util::magic_bullet_shield_till_notify( "turret_guys_vulnerable", true );
	
	return ai_gunner;
}

function kill_ai_on_vehicle_death( vh_vehicle )
{
	// self = AI
	self endon( "death" );
	
	vh_vehicle util::waittill_either( "death", "kill_passengers" );
	
	self util::stop_magic_bullet_shield();
	
	self Unlink();
	self Kill();
}

function turret_disable_on_vehicle_death( vh_vehicle )
{
	// self = AI
	self waittill( "death" );
	
	if( IsDefined( self ) ) // Catch case where he is deleted - when using debug
	{
		self Unlink();
	}
	
	if ( !vehicle::is_corpse( vh_vehicle ) )
	{
		vh_vehicle turret::disable( 1 );
	}
}

function gunner_position_think() 
{
	// self = vehicle
	self endon( "death" );
	
	const GUNNER_CHECK_TIME_MIN = 5;
	const GUNNER_CHECK_TIME_MAX = 8;
	
	// set burst fire parameters
	const FIRE_TIME_MIN = 1.0;
	const FIRE_TIME_MAX = 2.0;
	const FIRE_WAIT_MIN = 0.25;
	const FIRE_WAIT_MAX = 0.75;
	
	self turret::set_burst_parameters( FIRE_TIME_MIN, FIRE_TIME_MAX, FIRE_WAIT_MIN, FIRE_WAIT_MAX, 1 );
	
	//simplified from ramses 2.  If we decide to add the ability for another AI to use the gun, see that function.
	ai_gunner = self vehicle::get_rider( "gunner1" );
		
	if ( IsDefined( ai_gunner ) )
	{			
		self turret::enable( 1, true );
		
		self flag::set( "gunner_position_occupied" );
		
		ai_gunner waittill( "death" );  // TODO: add check on turret exit, if we ever want that
	}
	
	self turret::disable( 1 );
	self flag::clear( "gunner_position_occupied" );
}


//Vehicle stuff for later
//function plaza_stuff()
//{
//	ai_rider = self vehicle::get_rider( "driver" );
//	
//	self SetDrivePathPhysicsScale( 3.0 );  // this makes the technical follow the spline more closely while staying in DrivePath - predictable end locations are important!
//
//	if ( IsDefined( self.target ) )
//	{
//		self waittill( "reached_end_node" );
//		v_end_pos = self.origin;
//		v_end_angles = self.angles;
//		
//		level notify( self.targetname + "_reached_end_node" );
//	}
//	
//	self vehicle::get_off_path(); //kills path driving (seems like failsafe)
//	
//	ramses_util::enable_nodes( self.targetname + "_covernode", "targetname" ); //can have cover nodes around vehicle once it parks.
//
//	// make sure a guy is on here and turret is enabled (this occurs in gunner_position_think() )
//	while ( !vh_technical turret::is_turret_enabled( TECHNICAL_TURRET_INDEX ) )
//	{
//		wait 0.25;
//	}
//	
//	// pause firing so we can manually control this for intro
//	vh_technical turret::disable( TECHNICAL_TURRET_INDEX );  
//	
//
//}