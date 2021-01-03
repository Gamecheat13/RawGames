#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	           	              	           	                                                                                                                                                                                                                                                                                             

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses2_fx;
#using scripts\cp\cp_mi_cairo_ramses2_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;

//shareds
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_vehicle;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\cp\_objectives;
#using scripts\cp\_dialog;

#using scripts\shared\exploder_shared;

#using scripts\shared\ai_shared;
#using scripts\shared\ai\robot_phalanx;

#using scripts\cp\_ammo_cache;

#using scripts\shared\vehicles\_quadtank;

                      

#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_PLAZA_IGC_TRIG" );
#precache( "string", "CP_MI_CAIRO_RAMSES_PLAZA_IGC" );

#precache( "fx", "explosions/fx_exp_generic_lg" );

#precache( "objective", "cp_level_ramses_clear_the_plaza" );
#precache( "objective", "cp_level_ramses_plaza_regroup" );
#precache( "objective", "cp_level_ramses_subway_crumb_1" );
#precache( "objective", "cp_level_ramses_subway_crumb_2" );
#precache( "objective", "cp_level_ramses_plaza_follow_khalil" );
#precache( "objective", "cp_level_ramses_demo_hack_quadtank" );

#precache( "objective", "cp_level_ramses_demo_qt1" );
#precache( "objective", "cp_level_ramses_demo_qt2" );
#precache( "objective", "cp_level_ramses_demo_qt3" );
#precache( "objective", "cp_level_ramses_destroy_qt" );

#namespace quad_tank_plaza;

function quad_tank_plaza_main()
{
	precache();	
	plaza_main();
	
}

function precache()
{
	// DO ALL PRECACHING HERE
}

/***********************************
 * PRE SKIPTO
 * ********************************/
 
function pre_skipto()
{
	level.W_QUADTANK_WEAPON = GetWeapon( "quadtank_main_turret" );
	level.W_QUADTANK_PLAYER_WEAPON = GetWeapon( "quadtank_main_turret_player" );
	level.W_QUADTANK_MLRS_WEAPON = GetWeapon( "quadtank_main_turret_rocketpods_straight" );
	level.W_QUADTANK_MLRS_WEAPON2 = GetWeapon( "quadtank_main_turret_rocketpods_javelin" );
	
	//FLAGS
	level flag::init( "quad_tank_1_destroyed" );
	level flag::init( "quad_tank_2_spawned" );
	level flag::init( "quad_tank_2_destroyed" );
	level flag::init( "spawn_quad_tank_3" );
	level flag::init( "quad_tank_3_spawned" );
	level flag::init( "demo_player_controlled_quadtank" );
	
	level flag::init( "qt1_left_side" );
	level flag::init( "qt1_right_side" );
	level flag::init( "qt1_died_in_a_bad_place" );
		
	level flag::init( "siege_bot_solo" );
	level flag::init( "all_siege_bots_killed" );
	
	level flag::init( "qt_targets_statue" );
	level flag::init( "qt_plaza_statue_destroyed" );
	
	level flag::init( "qt_plaza_theater_destroyed" );
	level flag::init( "qt_plaza_theater_enemies_cleared" );
	
	level flag::init( "qt_plaza_mobile_wall_destroyed" );
	
	//objectives
	level flag::init( "obj_plaza_cleared" );
	level flag::init( "obj_player_at_plaza_igc" );
	level flag::init( "obj_follow_khalil" );
	
	level flag::init( "spawn_second_quadtank" );
	level flag::init( "third_quadtank_killed" );
	
	level flag::init( "qt_plaza_outro_igc_started" );
	
	level thread start_qt_plaza_ambient_combat();
	level thread qt1_friendly_vignettes();
	
	a_nd_nodes = GetNodeArray( "mobile_wall_exposed_nodes", "targetname" );
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, false );
	}
}

function start_qt_plaza_ambient_combat()
{
	init_plaza_spawn_functions();
	
	init_statue_fxanim_clips();
	init_theater_fxanim_clips();
	init_palace_corner_fxanim_clips();
	init_outro_igc_shadow_cards();

	//hide outro igc trigger
	e_trig_plaza_igc = GetEnt( "trig_plaza_igc", "targetname" );
	e_trig_plaza_igc SetCursorHint( "HINT_NOICON" );
	e_trig_plaza_igc UseTriggerRequireLookAt();
	e_trig_plaza_igc SetHintString( &"CP_MI_CAIRO_RAMSES_PLAZA_IGC_TRIG" );	
	e_trig_plaza_igc SetInvisibleToAll();

//-- TODO: DECIDE IF WE ARE GOING BACK TO SIEGEBOTS IN THIS FIGHT OR STICKING WITH MULTIPLE QUADTANKS
//	if( !ramses_util::is_demo() )
//	{
//		// Spawn Siege Bots
//		level.a_siege_bots = [];
//		
//		//siege bots
//		a_intro_siege_bots_plaza = GetEntArray( "intro_siege_bots_plaza", "targetname" );
//		foreach( sp_siege_bot in a_intro_siege_bots_plaza )
//		{	
//			ai_siege_bot = sp_siege_bot spawner::spawn();
//			
//			array::add( level.a_siege_bots, ai_siege_bot );
//			
//			ai_siege_bot thread siege_bot_deathfunc();
//		}
//		
//		level thread monitor_siege_bot_death();
//	}
//	else
//	{
		// Spawn MLRS QuadTank
		level thread demo_mlrs_quadtank();
		
		// Spawn AMWS
		a_e_goalvolume = GetEntArray( "qt_plaza_start_amws_goalvolume", "targetname" );
		a_sp_amws = GetEntArray( "qt_plaza_start_amws", "targetname" );
		level.a_qt_plaza_amws = [];
		foreach (sp_awms in a_sp_amws )
		{
			 ai_amws = spawner::simple_spawn_single( sp_awms );
			 ai_amws SetGoal( a_e_goalvolume[0], true );
			 a_e_goalvolume = array::remove_index( a_e_goalvolume, 0 );
			 level.a_qt_plaza_amws[ level.a_qt_plaza_amws.size ] = ai_amws;
		}
//	}
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	// Spawn Egyptian Turrets Turrets
	vehicle::simple_spawn( "qt_plaza_turret" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	//Egyptian Spawn Managers
	spawn_manager::enable( "sm_egypt_plaza_wall" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	spawn_manager::enable( "sm_egypt_palace_window" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	spawn_manager::enable( "sm_egypt_quadtank" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	spawn_manager::enable( "sm_egypt_siegebot" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	//NRC spawn managers
	e_spawnmanager = getent( "sm_nrc_siegebot", "targetname" );
	level thread spawn_manager::run_func_when_enabled( "sm_nrc_siegebot", &wave_spawner, e_spawnmanager, 20, 25, 2 );
	spawn_manager::enable( "sm_nrc_siegebot" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	e_spawnmanager = getent( "sm_nrc_quadtank", "targetname" );
	level thread spawn_manager::run_func_when_enabled( "sm_nrc_quadtank", &wave_spawner, e_spawnmanager, 20, 25, 4 );
	spawn_manager::enable( "sm_nrc_quadtank" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
//	util::wait_network_frame();
//	
//	e_spawnmanager = getent( "sm_nrc_depth", "targetname" );
//	level thread spawn_manager::run_func_when_enabled( "sm_nrc_depth", &wave_spawner, e_spawnmanager, 20, 25, 2 );
//	spawn_manager::enable( "sm_nrc_depth" );
//	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	//util::wait_network_frame();
	
	//spawn_manager::enable( "sm_nrc_berm_rpg" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	spawn_manager::enable( "qt1_nrc_wasp_sm" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	spawn_manager::enable( "sm_nrc_govt_building_rpg" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	//color chain for heroes and enemies 
	trigger::use( "trig_color_vtol_igc_allies", "targetname" );		
	trigger::use( "trig_color_post_vtol_igc_axis", "targetname" );	

	// Set Threat Bias
	// make friendly RPG guys fire at the Quadtank
	SetThreatBias( "NRC_Quadtank", "Egyptian_RPG_guys", 100000 );
	
	// HACK - make sure the logic can't proceed unless the Quadtank has spawned
	while( !IsDefined( level.first_quadtank ) )
	{
		wait 0.05;
	}
	
	level thread magic_bullet_rpg();
	
	level thread ai_movement_on_vtol_igc_end();
}

function ai_movement_on_vtol_igc_end()
{
	level flag::wait_till( "vtol_igc_done" );	
	
	ai_retreat_left = GetEnt( "egyptian_retreat_guy_left_ai", "targetname" );
	ai_retreat_left thread friendly_retreat_left();
	
//	ai_retreat_right = GetEnt( "egyptian_retreat_guy_right_ai", "targetname" );
//	ai_retreat_right thread friendly_retreat_right();
}

function friendly_retreat_left() // self = AI
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "disablearrivals", true );
	
	nd_pos = GetNode( "retreat_guy_left_path", "targetname" );
	while( IsDefined( nd_pos ) )
	{
		self ai::force_goal( nd_pos, 128, false, "near_goal", true, true );
		
		self util::waittill_any( "near_goal", "goal" );
		
		if( IsDefined( nd_pos.target ) )
		{
			nd_pos = GetNode( nd_pos.target, "targetname" );	
		}
		else
		{
			nd_pos = undefined;	 
		}
	}
	
	// PLAY SCENE
	s_scene = struct::get( "s_qt_plaza_egypt_debriscover", "targetname" );
	s_scene scene::play( self );
	
	nd_pos = GetNode( "retreat_guy_left_path_02", "targetname" );
	
	while( IsDefined( nd_pos ) )
	{
		self ai::force_goal( nd_pos, 128, false, "near_goal", true, true );
		
		self util::waittill_any( "near_goal", "goal" );
		
		if( IsDefined( nd_pos.target ) )
		{
			nd_pos = GetNode( nd_pos.target, "targetname" );	
		}
		else
		{
			nd_pos = undefined;	 
		}
	}
	
	self ai::set_ignoreall( false );
	self util::stop_magic_bullet_shield();
}

function friendly_retreat_right() // self = AI
{
	self endon( "death" );
	
	nd_pos = GetNode( "retreat_guy_right_path", "targetname" );
	
	self ai::set_ignoreall( true );
	
	while( IsDefined( nd_pos ) )
	{
		self ai::force_goal( nd_pos, 128, false, "near_goal", true, true );
		
		self util::waittill_any( "near_goal", "goal" );
		
		if( IsDefined( nd_pos.target ) )
		{
			nd_pos = GetNode( nd_pos.target, "targetname" );	
		}
		else
		{
			nd_pos = undefined;	
		}
	}
	
	self ai::set_ignoreall( false );
	self util::stop_magic_bullet_shield();
}

/***********************************
 * SPAWN FUNCTIONS
 * ********************************/

function init_plaza_spawn_functions()
{
	// Setup Threat Bias Groups
	CreateThreatBiasGroup( "Egyptian_RPG_guys" );
	CreateThreatBiasGroup( "NRC_Quadtank" );
	CreateThreatBiasGroup( "NRC_center_guys" );
	CreateThreatBiasGroup( "NRC_QT1_Shotgunners" );
	CreateThreatBiasGroup( "Players" );
	CreateThreatBiasGroup( "PlayerVehicles" );
	CreateThreatBiasGroup( "Egyptian_AI_near_players" );
	CreateThreatBiasGroup( "NRC_RPG_guys" );
	CreateThreatBiasGroup( "NRC_QT2_Robot_Rushers" );
	CreateThreatBiasGroup( "Egyptian_Theater_guys" );
	CreateThreatBiasGroup( "QT2_NRC_Raps" );
	CreateThreatBiasGroup( "QT2_Egyptian_Guys_on_Blocks" );

	SetThreatBias( "Players", "QT2_NRC_Raps", 100000 );
	SetThreatBias( "PlayerVehicles", "QT2_NRC_Raps", 100000 );
	SetThreatBias( "Players", "NRC_Quadtank", 1000 );
	
	// SPAWN FUNCTIONS
	vehicle::add_spawn_function( "demo_intro_mlrs_quadtank", &init_intro_quadtank );
	vehicle::add_hijack_function( "demo_intro_mlrs_quadtank", &quadtank_hijacked );
	
	vehicle::add_spawn_function( "artillery_quadtank", &init_artillery_quadtank );
	vehicle::add_hijack_function( "artillery_quadtank", &quadtank_hijacked );
	
	vehicle::add_spawn_function( "third_quadtank", &init_third_quadtank );
	vehicle::add_hijack_function( "third_quadtank", &quadtank_hijacked );
	
	vehicle::add_spawn_function( "qt_plaza_controllable_qt_raps", &qt_plaza_controllable_qt_raps_spawnfunc );
	
	vehicle::add_spawn_function( "qt_plaza_start_amws", &qt_plaza_start_amws_spawnfunc );
	
	vehicle::add_spawn_function( "qt1_nrc_amws", &qt1_nrc_amws_spawnfunc );
	
	vehicle::add_spawn_function( "qt1_raps", &qt1_nrc_raps_spawnfunc );
	
	vehicle::add_spawn_function( "qt_plaza_turret", &qt_plaza_turret_spawnfunc );
	
	vehicle::add_spawn_function( "qt2_nrc_wasps", &qt2_nrc_wasps_spawnfunc );
	
	vehicle::add_spawn_function( "qt2_nrc_wasps_berm", &qt2_nrc_wasps_berm_spawnfunc );
	
	vehicle::add_spawn_function( "qt2_nrc_wasps_palace", &qt2_nrc_wasps_palace_spawnfunc );
	
	vehicle::add_spawn_function( "qt2_raps", &qt2_nrc_raps_spawnfunc );
	
	spawner::add_spawn_function_group( "egypt_palace_window_guys", "targetname", &egypt_palace_window_guys_spawn_func );
	
	spawner::add_spawn_function_group( "egyptian_retreat_guy_left", "targetname", &egypt_retreat_guys_spawn_func );
	
	spawner::add_spawn_function_group( "egyptian_retreat_guy_right", "targetname", &egypt_retreat_guys_spawn_func );
	
	spawner::add_spawn_function_group( "statue_fall_guys", "targetname", &egypt_statue_fall_guys_spawn_func );
	
	spawner::add_spawn_function_group( "nrc_govt_building_rpg_guys", "targetname", &nrc_govt_building_rpg_guys_spawn_func );
	
	spawner::add_spawn_function_group( "nrc_rpg_berm_guys", "targetname", &nrc_berm_guys_spawn_func );
	
	spawner::add_spawn_function_group( "nrc_quadtank_guys", "targetname", &nrc_quadtank_guys_spawn_func );
	
	spawner::add_spawn_function_group( "qt2_robot_rushers", "targetname", &nrc_quadtank2_robot_rushers_spawn_func );
	
	spawner::add_spawn_function_group( "qt2_ally_theater", "targetname", &egypt_qt2_theater_spawn_func );
	
	spawner::add_spawn_function_group( "nrc_mobile_wall", "targetname", &nrc_mobile_wall_spawn_func );
	
	//WASPS
	a_plaza_wasps = GetEntArray( "plaza_wasps", "script_noteworthy" );
	foreach( sp_wasp in a_plaza_wasps )
	{
		sp_wasp spawner::add_spawn_function( &plaza_wasps_think );
	}
	
	//siege bots
//	if( !ramses_util::is_demo() )
//	{
//		a_intro_siege_bots_plaza = GetEntArray( "intro_siege_bots_plaza", "targetname" );
//		foreach( sp_siege_bot in a_intro_siege_bots_plaza )
//		{
//			sp_siege_bot spawner::add_spawn_function( &init_siege_bot );
//		}	
//	}

	// Friendly RPG guys
	a_egypt_palace_window_guys = GetEntArray( "egypt_palace_window_guys", "targetname" );
	a_egypt_plaza_wall_guys = GetEntArray( "egypt_plaza_wall_guy", "targetname" );
	a_egyptian_rpg_guys = ArrayCombine( a_egypt_palace_window_guys, a_egypt_plaza_wall_guys, true, false );
	foreach( sp_rpg in a_egyptian_rpg_guys )
	{
		sp_rpg spawner::add_spawn_function( &egyptian_rpg_spawn_func );	
	}
	
	// Enemy RPG guys
	a_nrc_govt_building_rpg_guys = GetEntArray( "nrc_govt_building_rpg_guys", "targetname" );
	a_nrc_rpg_berm_guys = GetEntArray( "nrc_rpg_berm_guys", "targetname" );
	a_nrc_rpg_guys = ArrayCombine( a_nrc_govt_building_rpg_guys, a_nrc_rpg_berm_guys, true, false );
	foreach( sp_rpg in a_nrc_rpg_guys )
	{
		sp_rpg spawner::add_spawn_function( &nrc_rpg_spawn_func );	
	}
	
	// Retreat Guys
	spawner::simple_spawn( "egyptian_retreat_guy_left" );
	// This is commented out for now, not sure we need this guy because we have vignettes now
	//spawner::simple_spawn( "egyptian_retreat_guy_right" );
}

function egyptian_rpg_spawn_func()
{
	self SetThreatBiasGroup( "Egyptian_RPG_guys" );
	
	e_goalvolume = GetEnt( self.target, "targetname" );
	self SetGoal( e_goalvolume, true );
}

function nrc_rpg_spawn_func()
{
	self SetThreatBiasGroup( "NRC_RPG_guys" );
}

/***********************************
 * INTRO QUAD TANK STUFF
 * ********************************/

//self = quad tank
function init_intro_quadtank()
{
	self endon( "death" );
	
	self thread vtol_igc_quadtank_movement();
	
	self util::magic_bullet_shield();
	self quadtank::quadtank_weakpoint_display( false );
	
	level flag::wait_till( "vtol_igc_done" );
	
	self util::stop_magic_bullet_shield();
	self quadtank::quadtank_weakpoint_display( true );
	
	self thread intro_quadtank_movement();
	self thread intro_quadtank_deathfunc();
	
	// VO functions
	self thread quadtank_trophy_system_reminder_vo();
	self thread quadtank1_flavor_vo();
}

function vtol_igc_quadtank_movement() // self = Quad Tank
{
	self endon( "death" );
	level endon( "vtol_igc_done" );
	
	a_s_spots = struct::get_array( "demo_qt1_vtol_igc_movement", "targetname" );
	
	while( 1 )
	{
		s_spot = array::random( a_s_spots );
		self SetGoal( s_spot.origin, true );
		self waittill( "at_anchor" );
	}
}

// This function gets QT1 to move to a cluster of spaces on either the left or right hand side of the QT Plaza
// He goes to one side, moves point to point in a cluster on that side, then switches sides
// Other logic here makes sure he only moves to the left hand side cluster if he's over 50% health
// This is b/c QT1 dying on the left side of the QT Plaza creates a problem for QT2's pathing
function intro_quadtank_movement() // self = Quad Tank
{
	self endon( "death" );
	
	self flag::init( "intro_qt_damage_threshold_reached" );
	self thread intro_quadtank_health_watcher();
	
	if( math::cointoss() )
	{
		a_s_spots = struct::get_array( "demo_qt1_movement_left_side", "targetname" );
		str_side = "left";
	}
	else
	{
		a_s_spots = struct::get_array( "demo_qt1_movement_right_side", "targetname" );
		str_side = "right";
	}
	
	while( 1 )
	{	
		self intro_quadtank_shuffle_movement( a_s_spots, str_side );
		
		// Switch Sides
		s_spot = struct::get( "demo_qt1_movement_travel", "targetname" );
		self SetGoal( s_spot.origin, true );
		self waittill( "at_anchor" );
		
		if( str_side == "left" || self flag::get( "intro_qt_damage_threshold_reached" ) )
		{
			str_side = "right";	
		}
		else if( (str_side == "right") && !self flag::get( "intro_qt_damage_threshold_reached" ) )
		{
			str_side = "left";	
		}
		
		level flag::set( "qt1_" + str_side + "_side" );
		level thread update_qt1_amws_goalvolume( str_side );
		
		a_s_spots = struct::get_array( "demo_qt1_movement_" + str_side + "_side", "targetname" );
	}
}

function intro_quadtank_health_watcher()  // self = Quad Tank
{
	self endon( "death" );
	
	n_health_threshold = self.health/2;
	
	while( 1 )
	{
		self waittill( "damage" );
		
		if( self.health <= n_health_threshold )
		{
			self notify( "intro_quadtank_damage_threshold_reached" );
			self flag::set( "intro_qt_damage_threshold_reached" );
			break;
		}
	}
}


function intro_quadtank_shuffle_movement( a_s_spots, str_side ) // self = Quad Tank
{
	self endon( "trophy_system_enabled" );
	if ( isdefined( 60 ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( 60, "timeout" );    };
	
	// If the Quadtank is on the left side of the plaza
	// Allow this function to end early if the quadtank drops below the health threshold
	// This will force the quadtank to move back to the right hand sid of the plaza
	if( str_side == "left" )
	{
		self endon( "intro_quadtank_damage_threshold_reached" );	
	}
	
	s_last_spot = undefined;
	
	// This while loop gets killed either by the trophy system being re-enabled or by the timeout at the top of this thread
	while( 1 )
	{
		// Prevent us from trying to move to the same spot twice in a row
		while( 1 )
		{
			s_spot = array::random( a_s_spots );
			if( IsDefined( s_last_spot ) && (s_last_spot == s_spot ) )
			{
				continue;	
			}
			else
			{
				break;
			}
		}
		
		self SetGoal( s_spot.origin, true );
		self waittill( "at_anchor" );
		s_last_spot = s_spot;
	}		
}

// If the Quadtank is in a particular area when it dies, disconnect paths on the QT's corpse
function intro_quadtank_deathfunc() //self = QT
{
	self waittill( "death" );
	
	e_trigger = GetEnt( "qt1_death_trigger", "targetname" );
	
	if( !IsDefined( self ) )
	{
		return;	
	}
	
	if( self IsTouching( e_trigger ) )
	{
		wait 5.0;
		
		self DisconnectPaths();
		level flag::set( "qt1_died_in_a_bad_place" );
	}	
}

/***********************************
 * ********************************/

function qt_plaza_start_amws_spawnfunc() // self = amws
{
	self endon( "death" );
	
	self util::magic_bullet_shield();
	
	level flag::wait_till( "vtol_igc_done" );
	
	self util::stop_magic_bullet_shield();
}

function qt1_nrc_amws_spawnfunc() // self = amws
{
	self endon( "death" );
	
	if( level flag::get( "qt1_left_side" ) )
	{
		e_goalvolume = GetEnt( "qt1_amws_right_goalvolume", "targetname" );
		self SetGoal( e_goalvolume, true );
	}
	else if( level flag::get( "qt1_right_side" ))
	{
		e_goalvolume = GetEnt( "qt1_amws_left_goalvolume", "targetname" );
		self SetGoal( e_goalvolume, true );
	}
	
	self thread amws_vo_watcher();
}

function amws_vo_watcher() // self = amws
{
	self endon( "death" );
	
	trigger::wait_till( "qt_plaza_alley_spawn_trigger", "targetname", self );
	
	level notify( "amws_callout_vo" );
}

function update_qt1_amws_goalvolume( str_side )
{
	level notify( "update_qt1_amws_goalvolume" );
	level endon( "update_qt1_amws_goalvolume" );
	
	level flag::wait_till( "vtol_igc_done" );
	
	if( str_side == "left" )
	{
		e_goalvolume = GetEnt( "qt1_amws_right_goalvolume", "targetname" );
	}
	else if( str_side == "right" )
	{
		e_goalvolume = GetEnt( "qt1_amws_left_goalvolume", "targetname" );	
	}
	
	//qt_plaza_start_amws
	a_start_amws = GetEntArray( "qt_plaza_start_amws_ai", "targetname" );
	a_qt1_amws = GetEntArray( "qt1_nrc_amws_ai", "targetname" );
	a_amws = ArrayCombine( a_start_amws, a_qt1_amws, true, false );
	foreach( amws in a_amws )
	{
		if( IsAlive( amws ) )
		{
			amws SetGoal( e_goalvolume, true );	
		}
	}
}

function init_third_quadtank() // self = quadtank
{
	self endon( "death" );
	
	//set goal pos, waittill he gets to goal position
	//- have him target position where corner palace wall is
	//- have him fire a large round into it.
	s_pos_1 = struct::get( "qt3_goalpos", "targetname" );
	
	self SetGoal( s_pos_1.origin, true);
	self waittill( "at_anchor" );
	level notify ("start_quad_music"); //will get moved once the music system is implemented
	
	// QT SHOOTS AT PALACE WALL
	s_target = struct::get( "qt3_cannon_shot_pos", "targetname" );
	e_target = spawn( "script_origin", s_target.origin );
	e_target.health = 100;
	
	e_fx_anim = getent( "quadtank_plaza_building_rocket", "targetname" );
	e_fx_anim SetCanDamage( true );
	e_fx_anim.health = 100;
	
	self thread ai::shoot_at_target( "shoot_until_target_dead", e_target );
	
	// wait until palace wall hit
	while( 1 )
	{
		e_fx_anim waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
		
		if( attacker == self && weapon == level.W_QUADTANK_WEAPON )
		{
			e_target notify( "death" );
			break;
		}	
	}
	
	// FX ANIM
	level thread scene::play( "p7_fxanim_cp_ramses_quadtank_plaza_building_rocket_bundle" );
	e_fx_anim SetCanDamage( false );
	e_target Delete();
	
	// Kill the Egyptians inside the building
	level thread kill_egyptians_inside_palace();
	
	//rumble and screenshake on players
	// TODO - tune radius/strength
	rumble_and_camshake( "qt2_intro_org" );
	
	//connect and delete carver clip
	e_palace_corner_breach_carver = GetEnt( "palace_corner_breach_carver", "targetname" );
	e_palace_corner_breach_carver Delete();
	
	//delete palace geo on quad tank impact 
	a_bm_palace_breach_corner = GetEntArray( "palace_corner_breach", "targetname" );
	foreach( bm_piece in a_bm_palace_breach_corner )
	{
		if ( isdefined( bm_piece ) ) 
		{
			bm_piece Delete();
		}
	}

	a_e_debris = GetEntArray( "palace_corner_blocker", "targetname" );
	foreach( e_debris in a_e_debris )
	{
		e_debris Solid();
		e_debris DisconnectPaths();		
		e_debris Show();
	}
	
	e_palace_collision = GetEnt( "palace_corner_breach_collision", "targetname" );
	e_palace_collision Solid();
	//e_palace_collision DisonnectPaths();	
	
	e_goalvolume = GetEnt( "third_quadtank_goalvolume", "targetname" );
	self SetGoal( e_goalvolume, true );
}

function kill_egyptians_inside_palace()
{
	level endon( "qt_plaza_outro_igc_started" );
	
	spawn_manager::disable( "sm_egypt_palace_window" );
	
	a_ai = spawn_manager::get_ai( "sm_egypt_palace_window" );
	foreach( ai in a_ai )
	{
		if( IsAlive( ai ) )
		{
			ai kill();
		}
	}
	
	s_pos = struct::get( "qt3_cannon_shot_pos", "targetname" );
	PhysicsExplosionSphere( s_pos.origin, 768, 768, 1 );
	
	wait 20.0;
	
	spawn_manager::enable( "sm_egypt_palace_window" );
}

//self = siege bot
function init_siege_bot()
{
	self endon( "death" );
	
	e_siege_bot_vol = GetEnt( self.target, "targetname" );
	self SetGoal( e_siege_bot_vol, true );
	
	//god mode during the vtol igc
	self util::magic_bullet_shield();
	
	level flag::wait_till( "vtol_igc_done" );
	
	self util::stop_magic_bullet_shield();
	
	//wait until one of them dies, then open up the volume that encompasses the whole area
	level flag::wait_till( "siege_bot_solo" );
		
	e_siege_bot_vol = GetEnt( "e_seige_bot_vol", "targetname" );
	self SetGoal( e_siege_bot_vol, true );
}

// HACK -  Prevent QT from firing at player immediately when skipto begins
// TODO - how does this handle hotjoin?
function ignore_players()
{
	foreach( player in level.players )
	{
		player.ignoreme = true;
		player EnableInvulnerability();
	}
	
	foreach( hero in level.heroes )
	{
		hero.ignoreme = true;		
	}
	
	level flag::wait_till( "vtol_igc_done" );
	
	// Give the player a window where they won't be shot coming out of the VTOL IGC
	// Allows the player to orient themselves and find cover before they take fire
	wait 5.0;
	
	foreach( player in level.players )
	{
		player.ignoreme = false;
		player DisableInvulnerability();		
	}
	
	foreach( hero in level.heroes )
	{
		hero.ignoreme = false;		
	}
}

function egypt_palace_window_guys_spawn_func() // self = AI
{
	self endon( "death" );
	
	self.ignoreSuppression = true;
	
	e_goalvolume = GetEnt( self.target, "targetname" );
	self SetGoal( e_goalvolume, true );
}

function egypt_retreat_guys_spawn_func() // self = AI
{
	self endon( "death" );	
	
	self util::magic_bullet_shield();
	
	nd_goal = GetNode( self.target, "targetname" );
	self SetGoal( nd_goal, true );
}

function qt_plaza_turret_spawnfunc() // self = turret
{
	if( !IsDefined( level.qt_plaza_egyptian_turrets ) )
	{
		level.qt_plaza_egyptian_turrets = [];
	}
	
	level.qt_plaza_egyptian_turrets[ level.qt_plaza_egyptian_turrets.size ] = self;
	
	self util::magic_bullet_shield();
}	

function qt2_nrc_wasps_spawnfunc() // self = wasp
{
	self endon( "death" );
	
	e_goalvolume = GetEnt( "pre_qt2_nrc_wasp_goalvolume", "targetname" );
	self SetGoal( e_goalvolume, true );
	
	self thread wasp_vo_trigger_watcher();
}

function qt2_nrc_wasps_berm_spawnfunc() // self = wasp
{
	self endon( "death" );
	
	e_goalvolume = GetEnt( "qt2_nrc_wasp_berm_goalvolume", "targetname" );
	self SetGoal( e_goalvolume, true );
	
	// HACK - Turn down friendly AI's accuracy against WASPS
	// Friendly AI is very effective against wasps right now - MB 1/16/2015
	self.attackerAccuracy = 0.25;
	
	self thread wasp_vo_trigger_watcher();
}

function qt2_nrc_wasps_palace_spawnfunc() // self = wasp
{
	self endon( "death" );
	
	e_goalvolume = GetEnt( "qt2_nrc_wasp_palace_goalvolume", "targetname" );
	self SetGoal( e_goalvolume, true );
	
	// HACK - Turn down friendly AI's accuracy against WASPS
	// Friendly AI is very effective against wasps right now - MB 1/16/2015
	self.attackerAccuracy = 0.25;
	
	self thread wasp_vo_trigger_watcher();
}

function qt2_nrc_raps_spawnfunc() // self = RAPS
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "QT2_NRC_Raps" );
	
	trigger::wait_till( "qt_plaza_alley_spawn_trigger", "targetname", self );
	
	level notify( "raps_callout_vo" );
}

function magic_bullet_rpg()
{
	level endon( "qt_plaza_outro_igc_started" );

	a_s_start_points = struct::get_array( "qt_plaza_magic_bullet_rpg", "targetname" );
	weapon = GetWeapon( "launcher_standard" );
	
	while( 1 )
	{
		n_rpg_count = RandomIntRange( 2, 6 );
		
		for( i = 0; i < n_rpg_count; i++ )
		{
			s_start_point = array::random( a_s_start_points );
			
			a_s_end_points = struct::get_array( s_start_point.target, "targetname" );
			s_end_point = array::random( a_s_end_points );
			
			MagicBullet( weapon, s_start_point.origin, s_end_point.origin );
			
			wait( RandomFloatRange( 0.5, 1.0 ) );
		}
		
		wait ( RandomFloatRange( 10.0, 20.0 ) );
	}
}

/***********************************
 * PLAZA MAIN
 * ********************************/

function plaza_main()
{
	level flag::wait_till( "vtol_igc_done" );
	
	trigger::use( "trig_color_post_vtol_igc_allies", "targetname" );
	level thread establish_egyptian_ignore_groups();
	level thread establish_NRC_ignore_groups();
	
	foreach( player in level.players )
	{
		player thread player_hijack_watcher();
	}
	callback::on_spawned( &player_hijack_watcher );
	
	level thread post_vtol_igc_vo();
	level thread rpg_palace_callout_vo();
	level thread rpg_berm_callout_vo();
	
	// TODO - bring this back when dialog has been updated
	//level thread plaza_dialog();
	
//	if( ramses_util::is_demo() )
//	{
		level thread quad_tank_plaza_hijacked_quadtank_watcher();
		
		level thread plaza_objectives_demo();
		
		level thread qt1_raps_DEMO_ONLY();
		
		level flag::wait_till( "quad_tank_1_destroyed" );

		level thread artillery_quadtank();
		
		level flag::wait_till( "spawn_quad_tank_3" );

		level thread third_quadtank();			
//	}
//	else
//	{		
//		// MAIN LEVEL PATH
//		// TODO - bring back spawning in Khalil
//		// TODO - enemy and friendly scripting pass
//		
//		level thread plaza_objectives_main();
//		level thread main_mlrs_quadtank();
//		
//		a_flags = [];
//		a_flags[ 0 ] = "all_siege_bots_killed";
//		a_flags[ 1 ] = "quad_tank_1_destroyed";
//		
//		level flag::wait_till_any( a_flags );
//		
//		// Spawn Artillery Quadtank
//		level thread third_quadtank();	
//	}
}

// TODO - this function needs to be adjusted to account for hotjoining
// This function makes the Egyptian RPG guys ignore the NRC in the middle of the arena
function establish_egyptian_ignore_groups()
{	
	while( 1 )
	{
		if( level.players.size == 1 )
		{
			SetIgnoreMeGroup( "NRC_center_guys" , "Egyptian_RPG_guys" );
		}
		else
		{
			// do different things	
		}
		
		if( flag::get( "quad_tank_1_destroyed" ) )
		{
			// reset things
			break;			
		}
		
		level waittill( "player_spawned" );
	}
}

// Make sure NRC RPG guys ignore the players
// Make sure NRC RPG guys ignore Egyptian AI near the players
// ***NRC RPG guys should only fire at Egyptian AI, and those not near the player
// In this way, they add acitvity/depth to the combat but don't threaten the player
// The primary threat to the player in this fight MUST be the QUADTANK
function establish_NRC_ignore_groups()
{
	SetIgnoreMeGroup( "Players" , "NRC_RPG_guys" );
	SetIgnoreMeGroup( "Egyptian_AI_near_players" , "NRC_RPG_guys" );

	level thread setup_players_qt_plaza_threat_bias_group();
	level thread setup_threat_bias_for_ai_near_players();
}

// This function makes sure all players are thrown into a threat bias group
function setup_players_qt_plaza_threat_bias_group()
{
	level endon( "third_quadtank_killed" );
	
	foreach( player in level.players )
	{
		player SetThreatBiasGroup( "Players" );
	}
	
	while( 1 )
	{
		level waittill( "player_spawned" );
		
		foreach( player in level.players )
		{
			player SetThreatBiasGroup( "Players" );
		}
	}
}   

// This function makes sure all friendly AI near all players (within a radius) are thrown into a threat bias group
function setup_threat_bias_for_ai_near_players()
{
	level endon( "third_quadtank_killed" );
	
	while( 1 )
	{
		foreach( player in level.players )
		{
			a_ai = GetAITeamArray( "allies" );
			
			foreach( ai in a_ai )
			{
				if( IsDefined( ai.script_noteworthy ) && (ai.script_noteworthy == "qt_plaza_egyptian_rpg" ) )
				{
					continue;	
				}
				
				// If this guy is already in another threat bias group, don't add him or remove him here
				str_threat_bias = ai GetThreatBiasGroup();
				if( IsDefined( str_threat_bias ) && (str_threat_bias != "Egyptian_AI_near_players" ) )
				{
					continue;	
				}
				
				n_distance = Distance2DSquared( ai.origin, player.origin );
				if( n_distance <= 256*256 )
				{
					ai SetThreatBiasGroup( "Egyptian_AI_near_players" );
					ai.Egyptian_AI_near_players = true;
				}
				else
				{
					if( ( isdefined( ai.Egyptian_AI_near_players ) && ai.Egyptian_AI_near_players ) )
					{
						// Remove this AI from the threat bias group
						ai SetThreatBiasGroup();
						ai.Egyptian_AI_near_players = false;
					}
				}
			}
			
			wait 0.1;
		}
		
		wait 1.0;
	}
}

function qt1_friendly_vignettes()
{
	level thread qt1_last_stand_scenes();
	
	level waittill( "vtol_igc_start_qt_plaza_vignettes2" );
	
	level thread qt1_egyptian_wounded_scene();
	level thread qt1_rescueinjured_r_scene();
	
	//HACK - this exists only so we have better performance for the VTOL IGC for the demo
	// REMOVE THIS POST DEMO
	level thread qt1_nrc_berm_and_depth_spawnmanagers();
}

function qt1_egyptian_wounded_scene()
{
	a_ai = spawner::simple_spawn( "qt_plaza_egyptian_wounded" );
	
	e_carver = GetEnt( "egyptian_wounded_carver", "targetname" );
	e_carver DisconnectPaths();
	
	a_amws = GetEntArray( "qt_plaza_start_amws_ai", "targetname" );
	ai_amws = array::random( a_amws );
	ai_amws util::magic_bullet_shield();
	s_target = struct::get( "egyptian_wounded_target", "targetname" );
	e_target = spawn( "script_origin", s_target.origin );
	e_target.health = 100;
	
	ai_amws thread ai::shoot_at_target( "shoot_until_target_dead", e_target );
	
	s_scene = struct::get( "scene_qt_plaza_egyptian_wounded", "targetname" );
	s_scene scene::skipto_end( a_ai, undefined, undefined, 0.375 );
	
	ai_amws util::stop_magic_bullet_shield();
	
	e_carver Delete();
	
	e_target notify( "death" );
	e_target Delete();
}

function qt1_rescueinjured_r_scene()
{
	a_ai = spawner::simple_spawn( "qt_plaza_egyptian_rescueinjured_guy" );
	
	foreach( ai in a_ai )
	{
		ai ai::set_ignoreme( true );
		ai util::magic_bullet_shield();
	}
	
	e_clip1 = GetEnt( "qt_plaza_left_vignette_carver1", "targetname" );
	e_clip1 DisconnectPaths();
	
	e_clip2 = GetEnt( "qt_plaza_left_vignette_carver2", "targetname" );
	e_clip2 DisconnectPaths();
	
	s_scene = struct::get( "scene_qt_plaza_rescueinjured_r", "targetname" );
	s_scene thread scene::skipto_end( a_ai, undefined, undefined, 0.25 );	
	
	// notetrack on ch_ram_05_01_defend_vign_rescueinjured_r_group_injured_loop
	level waittill( "rescueinjured_loop_started" );
	
	e_clip1 Delete();
	
	foreach( ai in a_ai )
	{
		if( IsAlive( ai ) )
		{
			ai ai::set_ignoreme( false );
			ai util::stop_magic_bullet_shield();
			ai colors::set_force_color( "p" );
			
			if( ai.animname === "arena_defend_intro_r_injured" )
			{
				ai_injured = ai;
				ai_injured util::delay( 60, "death", &Kill );
			}
		}
	}
	
	if( IsDefined( ai_injured ) )
	{
		ai_injured waittill( "death" );	
	}
	
	e_clip2 Delete();
}

function qt1_last_stand_scenes()
{
	level waittill( "vtol_igc_start_qt_plaza_vignettes" );
	
	a_s_scenes = struct::get_array( "qt_plaza_last_stand_guys", "targetname" );
	foreach( s_scene in a_s_scenes )
	{
		n_time = RandomFloatRange( 0.05, 0.15 );
		s_scene thread scene::skipto_end( undefined, undefined, undefined, n_time );
	}
}

// TODO - retime dialog
// TODO - move subway and freeway dialog into relevant script files
function plaza_dialog()
{
	//PLAZA
	level.ai_hendricks dialog::say( "hend_we_need_to_clear_the_0" ); //We need to clear the plaza!
	
	wait 1.5;
	level.ai_hendricks dialog::say( "hend_quad_tank_on_the_de_0" ); //Quad Tank! On the debris!!	
	
	wait 1;
	level.ai_hendricks dialog::say( "hend_grab_that_launcher_a_0" ); //Grab that launcher and take out the quad!
	
	level flag::wait_till( "quad_tank_1_destroyed" );
	level.ai_hendricks dialog::say( "hend_yeah_tank_down_kee_0" ); //Yeah! Tank down! Keep firing!!!
	
	level flag::wait_till( "obj_plaza_cleared" );	
	level.ai_khalil dialog::say( "khal_regroup_on_me_0" ); //Regroup on me!

	//SUBWAY
	level flag::wait_till( "subway_crumb_2" ); //flag set is on trigger
	level.ai_hendricks dialog::say( "hend_kane_how_did_promet_0" ); //Kane, how did prometheus access the secured comms!?
	
	//FREEWAY
	level flag::wait_till( "start_vtol_robot_drop_1" );
	level.ai_khalil dialog::say( "khal_robots_jumping_from_0" ); //Robots jumping from VTOLs! Top side!
	
	level flag::wait_till( "start_vtol_robot_drop_2" );
	level.ai_hendricks dialog::say( "hend_watch_it_robots_dep_0" ); //Watch it! Robots deploying from VTOLs, up head!
	
	level flag::wait_till( "freeway_battle_cleared" );
	level.ai_hendricks dialog::say( "hend_area_clear_keep_mov_0" ); //Area clear, keep moving!
}

// TODO - remove?
function plaza_objectives_main()
{
	//clear plaza objective
	objectives::set( "cp_level_ramses_clear_the_plaza" );
	level flag::wait_till( "obj_plaza_cleared" );
	objectives::complete( "cp_level_ramses_clear_the_plaza" );
	
	//regroup objective
	objectives::breadcrumb( "cp_level_ramses_plaza_regroup", "trig_plaza_igc" );
	level flag::wait_till( "obj_player_at_plaza_igc" );
	objectives::complete( "cp_level_ramses_plaza_regroup" );	
	
	//breadcrumb 1
	objectives::breadcrumb( "cp_level_ramses_subway_crumb_1", "subway_crumb_1" );
	level flag::wait_till( "subway_crumb_1" ); //flag set is on trigger
	objectives::complete( "cp_level_ramses_subway_crumb_1" );
	
	//breadcrumb 2
	objectives::breadcrumb( "cp_level_ramses_subway_crumb_2", "subway_crumb_2" );
	level flag::wait_till( "subway_crumb_2" ); //flag set is on trigger
	objectives::complete( "cp_level_ramses_subway_crumb_2" );	

	//follow khalil
	objectives::set( "cp_level_ramses_plaza_follow_khalil", level.ai_khalil );
	level flag::wait_till( "obj_follow_khalil" );
	objectives::complete( "cp_level_ramses_plaza_follow_khalil" );		
}

/***********************************
 * DEMO PATH
 * ********************************/
function plaza_objectives_demo()
{
	// Destroy the first Quadtank
	objectives::set( "cp_level_ramses_demo_qt1" );
	while( !IsDefined( level.first_quadtank ) )
	{
		wait 0.1;	
	}
	objectives::set( "cp_level_ramses_destroy_qt", level.first_quadtank );
	level flag::wait_till( "quad_tank_1_destroyed" );
	objectives::complete( "cp_level_ramses_demo_qt1" );
	objectives::complete( "cp_level_ramses_destroy_qt", level.first_quadtank );
	
	// Destroy the second Quadtank
	level flag::wait_till( "quad_tank_2_spawned" );
	objectives::hide( "cp_level_ramses_demo_qt1" );
	objectives::set( "cp_level_ramses_demo_qt2" );
	while( !IsDefined( level.second_quadtank ) )
	{
		wait 0.1;
	}
	objectives::set( "cp_level_ramses_destroy_qt", level.second_quadtank );
	level flag::wait_till_any( array("demo_player_controlled_quadtank", "quad_tank_2_destroyed" ) );
	objectives::complete( "cp_level_ramses_demo_qt2" );
	objectives::complete( "cp_level_ramses_destroy_qt", level.second_quadtank );
	
	// Destroy the third Quadtank
	level flag::wait_till( "quad_tank_3_spawned" );
	objectives::hide( "cp_level_ramses_demo_qt2" );
	objectives::set( "cp_level_ramses_demo_qt3" );
	while( !IsDefined( level.third_quadtank ) )
	{
		wait 0.1;
	}
	objectives::set( "cp_level_ramses_destroy_qt", level.third_quadtank );
	level flag::wait_till( "third_quadtank_killed" );
	objectives::complete( "cp_level_ramses_demo_qt3" );
	objectives::complete( "cp_level_ramses_destroy_qt", level.third_quadtank );	
}

function demo_mlrs_quadtank()
{
	vh_intro_mlrs_quadtank = spawner::simple_spawn_single( "demo_intro_mlrs_quadtank" );
	level.first_quadtank = vh_intro_mlrs_quadtank;
	vh_intro_mlrs_quadtank SetThreatBiasGroup( "NRC_Quadtank" );
	
	vh_intro_mlrs_quadtank util::magic_bullet_shield();
	
	level flag::wait_till( "vtol_igc_done" );
	
	vh_intro_mlrs_quadtank util::stop_magic_bullet_shield();
	level thread spawn_qt1_nrc_technical();
	level thread qt1_amws_spawn_manager();
	spawn_manager::disable( "qt1_nrc_wasp_sm" );
	
	vh_intro_mlrs_quadtank util::waittill_any( "enter_vehicle", "death", "CloneAndRemoveEntity" );
	
	level flag::set( "quad_tank_1_destroyed" );
}

function spawn_qt1_nrc_technical()
{	
	array::wait_till( level.a_qt_plaza_amws, "death" );
	
	a_nd_nodes = GetNodeArray( "qt1_nrc_truck_nodes", "script_noteworthy" );
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, false );
	}
	
	wait 5.0;
	
	vh_nrc_plaza_truck = spawner::simple_spawn_single( "nrc_qt1_truck" );
	vh_nrc_plaza_truck thread nrc_technical_damagefunc();
	
	vh_nrc_plaza_truck playsound ("evt_tech_driveup_qt");
	
	ai_gunner = spawner::simple_spawn_single( "nrc_technical_gunner" );
	ai_gunner vehicle::get_in( vh_nrc_plaza_truck, "gunner1", true );
	
	nd_truck_start = GetVehicleNode( vh_nrc_plaza_truck.target, "targetname" );
	vh_nrc_plaza_truck thread vehicle::get_on_and_go_path( nd_truck_start );		
	
	vh_nrc_plaza_truck turret::enable( 1, true );

	vh_nrc_plaza_truck util::waittill_any( "death", "reached_end_node" );
	
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, true );
	}
}

function qt1_amws_spawn_manager()
{
	level endon( "quad_tank_1_destroyed" );
	
	array::wait_till( level.a_qt_plaza_amws, "death" );

	level thread amws_callout_VO();
	e_spawnmanager = getent( "qt1_nrc_amws_sm", "targetname" );
	level thread spawn_manager::run_func_when_enabled( "qt1_nrc_amws_sm", &wave_spawner, e_spawnmanager, 10, 15, 2 );
	spawn_manager::enable( "qt1_nrc_amws_sm" );
}

//HACK - this exists only so we can have a RAPS get hijacked for the demo
// REMOVE THIS POST DEMO
function qt1_raps_DEMO_ONLY()
{
	spawn_manager::enable( "qt1_nrc_raps_sm" );
	
	// wait until one of the RAPS gets hijacked 
	level util::waittill_any( "stop_qt1_raps", "quad_tank_1_destroyed" );
	
	spawn_manager::disable( "qt1_nrc_raps_sm" );	
}

//HACK - this exists only so we have better performance for the VTOL IGC for the demo
// REMOVE THIS POST DEMO
function qt1_nrc_berm_and_depth_spawnmanagers()
{
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	e_spawnmanager = getent( "sm_nrc_depth", "targetname" );
	level thread spawn_manager::run_func_when_enabled( "sm_nrc_depth", &wave_spawner, e_spawnmanager, 20, 25, 2 );
	spawn_manager::enable( "sm_nrc_depth" );
	
	// THIS WAIT IS HERE TO SPREAD OUT INITIAL SPAWN OF QT PLAZA
	util::wait_network_frame();
	
	spawn_manager::enable( "sm_nrc_berm_rpg" );		
}

function artillery_quadtank()
{
	a_ai_retreat = GetEntArray( "egyptian_retreat_guy_left_ai", "targetname" );
	foreach( ai_guy in a_ai_retreat )
	{
		if( IsAlive( ai_guy ) )
		{
			ai_guy DoDamage( ai_guy.health, ai_guy.origin );
		}
	}
		
	trigger::use( "trig_color_quadtank2_allies" );
	trigger::use( "trig_color_quadtank2_axis" );
	
	// VO
	level thread mlrs_defeated_move_up_vo();
	
	// NRC spawn managers
	level notify( "qt1_nrc_amws_sm_wave_spawner_stop" );
	spawn_manager::disable( "qt1_nrc_amws_sm" );
	e_goalvolume = GetEnt( "post_qt1_amws_goalvolume", "targetname" );
	a_amws = spawn_manager::get_ai( "qt1_nrc_amws_sm" );
	foreach( amws in a_amws )
	{
		amws SetGoal( e_goalvolume, true );
	}
	
	//e_spawnmanager = getent( "qt2_nrc_wasp_sm", "targetname" );
	//level thread spawn_manager::run_func_when_enabled( "qt2_nrc_wasp_sm", &wave_spawner, e_spawnmanager, 20, 25, 3 );
	level thread wasp_callout_VO();
	spawn_manager::enable( "qt2_nrc_wasp_sm" );
	
	// EGYPTIAN spawn managers
	spawn_manager::enable( "sm_egypt_statue_fall" );
	if( !level flag::get( "qt_plaza_theater_destroyed" ) )
	{
		spawn_manager::enable( "sm_egypt_theater" );	
	}	
		
	//bring in khalil
	// TODO - call this out with VO
	level.ai_khalil = util::get_hero( "khalil" );
	level.ai_khalil colors::set_force_color( "o" );	
	
	s_khalil_start = struct::get( "khalil_start", "targetname" );
	level.ai_khalil skipto::teleport_single_ai( s_khalil_start );
	
	// Wait for enemy/friendly positions to update before spawning in the 2nd QT
	wait 5.0;
	
	level notify( "qt2_nrc_wasp_sm_wave_spawner_stop" );
	spawn_manager::disable( "qt2_nrc_wasp_sm" );
	
	//***QUADTANK SPAWNS THROUGH SCENE SYSTEM
	level thread artillery_quadtank_intro_vo();
	level thread palace_wall_fxanim_notetracks();
	
	level scene::play( "p7_fxanim_cp_ramses_qt_plaza_palace_wall_collapse_bundle" );
//	scene::play( "cin_ram_06_05_safiya_vign_qtcrash_quadtank" );

	// HACK - this wait is necessary to make sure the QT takes the SetGoal call below coming out of the scene::play call
	util::wait_network_frame();
	
	level.second_quadtank quadtank::quadtank_on();
	
	level flag::set( "quad_tank_2_spawned" );
	
	// NRC spawn managers
	e_spawnmanager = getent( "qt2_nrc_wasp2_berm_sm", "targetname" );
	level thread spawn_manager::run_func_when_enabled( "qt2_nrc_wasp2_berm_sm", &wave_spawner, e_spawnmanager, 15, 20, 3 );
	spawn_manager::enable( "qt2_nrc_wasp2_berm_sm" );
	
	e_spawnmanager = getent( "qt2_nrc_wasp2_palace_sm", "targetname" );
	level thread spawn_manager::run_func_when_enabled( "qt2_nrc_wasp2_palace_sm", &wave_spawner, e_spawnmanager, 15, 20, 3 );
	spawn_manager::enable( "qt2_nrc_wasp2_palace_sm" );
	
	e_spawnmanager = getent( "qt2_nrc_robot_rushers_sm", "targetname" );
	level thread spawn_manager::run_func_when_enabled( "qt2_nrc_robot_rushers_sm", &wave_spawner, e_spawnmanager, 10, 15, 3 );
	spawn_manager::enable( "qt2_nrc_robot_rushers_sm" );
	SetIgnoreMeGroup( "Egyptian_RPG_guys" , "NRC_QT2_Robot_Rushers" );
	level thread robot_callout_vo();
	
	level thread handle_qt2_depth_spawn_managers();
	
	level thread egyptian_ai_ignore_qt2_nrc_raps();
	spawn_manager::enable( "qt2_nrc_raps_sm" );
	level thread raps_callout_VO();
	
	// All the robot rushers were going straight into the theater
	// So this gets the robots to come out further into the QT Plaza and engage players more
	SetIgnoreMeGroup( "Egyptian_Theater_guys" , "NRC_QT2_Robot_Rushers" );
	SetIgnoreMeGroup( "NRC_QT2_Robot_Rushers", "Egyptian_Theater_guys" );

	// Get QT to shoot at statue
	level.second_quadtank thread artillery_qt_destroys_statue();

	level flag::wait_till( "qt_plaza_statue_destroyed" );
	
	// QUADTANK MOVEMENT LOGIC
	if( IsDefined( level.second_quadtank ) )
	{
		level.second_quadtank thread artillery_quadtank_movement_routine();
	}
	
	level.second_quadtank thread quadtank_flavor_vo();
}

function handle_qt2_depth_spawn_managers()
{
	level notify( "sm_nrc_depth_wave_spawner_stop" );
	spawn_manager::disable( "sm_nrc_depth" );
	
	while( 1 )
	{
		a_active_ai = spawn_manager::get_ai( "sm_nrc_depth" );
	
		if( a_active_ai.size <= 2 )
		{
			break;
		}
		
		wait 1.0;
	}
	
	// No wave spawning for this, because it only maintains a small number of guys
	spawn_manager::enable( "sm_nrc_qt2_depth" );
}

function egyptian_ai_ignore_qt2_nrc_raps()
{
	level endon( "qt_plaza_outro_igc_started" );
	
	SetIgnoreMeGroup( "QT2_NRC_Raps", "QT2_Egyptian_Guys_on_Blocks" );
	
	e_trigger = GetEnt( "qt2_egyptian_guys_on_blocks", "targetname" );
	
	while( 1 )
	{
		e_trigger waittill( "trigger", ent );
		
		str_threat = ent GetThreatBiasGroup();
		
		if( str_threat == "QT2_Egyptian_Guys_on_Blocks" )
		{
			wait 0.1;
			continue;			
		}
		else
		{
			ent SetThreatBiasGroup( "QT2_Egyptian_Guys_on_Blocks" );	
		}
	}
}

function palace_wall_fxanim_notetracks()
{
	e_wall = GetEnt( "qt_plaza_palace_wall_collapse", "targetname" );
	e_wall thread qt_first_hit();
	e_wall thread qt_ground_hit();
}

function qt_first_hit() // self = fxanim wall
{
	self waittill( "qt_first_hit" );
	
	// NRC spawn managers
	level notify( "sm_nrc_siegebot_wave_spawner_stop" );
	spawn_manager::disable( "sm_nrc_siegebot" );
	
	//rumble and screenshake on players
	// TODO - tune radius/strength
	rumble_and_camshake( "qt2_intro_org" );
}

function qt_ground_hit() // self = fxanim wall
{
	self waittill( "qt_ground_hit" );
	
   //destroyed wall that happens when artillery quad tank lands
	a_bm_qt_fall_event = GetEntArray( "qt_fall_event", "targetname" );
	foreach( bm_piece in a_bm_qt_fall_event )
	{
		if ( isdefined( bm_piece ) ) 
		{
			bm_piece Delete();
		}
	}
	
	// Kill players/AI where the QT Lands
	t_kill = GetEnt( "qt2_intro_kill_trigger", "targetname" );
	a_ai = GetAIArray();
	a_all_actors = ArrayCombine( a_ai, level.players, true, false );
	foreach( e_actor in a_all_actors )
	{
		if( e_actor util::is_hero() )
		{
			continue;	
		}
		
		if( e_actor.targetname === "artillery_quadtank_ai" )
		{
			continue;	
		}
		
		if ( e_actor IsTouching( t_kill ) )
		{
			if( IsPlayer( e_actor ) )
			{
				e_actor DoDamage( e_actor.health, e_actor.origin );
				break;
			}
			else
			{
				e_actor Kill();
				break;
			}
		}	
	}
	
	//rumble and screenshake on players
	// TODO - tune radius/strength	
	rumble_and_camshake( "qt2_intro_org" );
}

function init_artillery_quadtank() // self = Quaadtank
{
	level.second_quadtank = self;
	self quadtank::quadtank_off();
	self SetThreatBiasGroup( "NRC_Quadtank" );
	self thread qt2_resolve_death();
	self thread qt2_resolve_hijack();
	
	// VO
	self thread quadtank_trophy_system_down_vo();
}

function spawn_artillery_quadtank( b_dev_skipto = false )
{
	ai_artillery_quadtank = spawner::simple_spawn_single( "artillery_quadtank" );
	ai_artillery_quadtank ai::set_ignoreme( true );
	ai_artillery_quadtank ai::set_ignoreall( true );
	ai_artillery_quadtank quadtank::quadtank_weakpoint_display( false );
	
	if(! b_dev_skipto )
	{
		ai_artillery_quadtank SetThreatBiasGroup( "NRC_Quadtank" );	
	}
	
	level.second_quadtank = ai_artillery_quadtank;

	return ai_artillery_quadtank;
}

function artillery_quadtank_movement_routine() // self = QT
{
	self endon( "death" );
	
	if( !level flag::get( "qt1_died_in_a_bad_place" ) )
	{
		s_pos = struct::get( "qt2_movement_path_A", "targetname" );	
	}
	else
	{
		s_pos = struct::get( "qt2_movement_path_B", "targetname" );	
	}
	
	while( IsDefined( s_pos ) )
	{
		self SetGoal( s_pos.origin, true );
		
		self waittill( "at_anchor" );
		
		if( IsDefined( s_pos.target ) )
		{
			s_pos = struct::get( s_pos.target, "targetname" );	
		}
		else
		{
			s_pos = undefined;	
		}
	}
}

function qt2_resolve_death() // self = QT
{
	level endon( "demo_player_controlled_quadtank" );
	
	self waittill( "death" );
	
	// HACK - this wait is a buffer so we can make sure the quadtank didn't really get hacked before proceeding.
	// We should remove this if we can guarantee the "CloneAndRemoveEntity" notify will fire before the "death" notify
	wait 2.0;
	
	level flag::set( "quad_tank_2_destroyed" );
	
	trigger::use( "trig_color_quadtank3_allies" );
	trigger::use( "trig_color_quadtank3_axis" );
	
	// SET FLAG TO SPAWN THIRD QUADTANK
	wait 10.0;
	
	level flag::set( "spawn_quad_tank_3" );

	level thread stop_qt2_nrc_wasps();
}

function qt2_resolve_hijack() // self = QT
{
	level endon( "quad_tank_2_destroyed" );
	
	self waittill( "CloneAndRemoveEntity" );
	
	level flag::set( "demo_player_controlled_quadtank" );
	level thread handle_player_controllable_quadtank( self );
	level thread stop_qt2_nrc_wasps();
}

function stop_qt2_nrc_wasps()
{
	// Disable Wasp Spawn Managers
	level notify( "qt2_nrc_wasp2_palace_sm_wave_spawner_stop" );
	spawn_manager::disable( "qt2_nrc_wasp2_palace_sm" );
		
	level notify( "qt2_nrc_wasp2_berm_sm_wave_spawner_stop" );
	spawn_manager::disable( "qt2_nrc_wasp2_berm_sm" );	
	
	// Re-position any leftover wasps
	e_goalvolume = GetEnt( "post_qt2_wasp_goalvolume", "targetname" );
	a_wasp_palace = spawn_manager::get_ai( "qt2_nrc_wasp2_palace_sm" );
	a_wasp_berm = spawn_manager::get_ai( "qt2_nrc_wasp2_berm_sm" );
	a_wasps = ArrayCombine( a_wasp_palace, a_wasp_berm, true, false );
	foreach( ai_wasp in a_wasps )
	{
		ai_wasp SetGoal( e_goalvolume, true );
	}
	
}	

// Spawns a bunch of extra stuff if the player hijacks Quadtank 2
function handle_player_controllable_quadtank( ai_artillery_quadtank )
{	
	// Disable Robots Spawn Manager
	level notify( "qt2_nrc_robot_rushers_sm_wave_spawner_stop" );
	spawn_manager::disable( "qt2_nrc_robot_rushers_sm" );
	
	//color chain for heroes and enemies 
	trigger::use( "trig_color_player_controlled_QT_allies", "targetname" );		
	trigger::use( "trig_color_player_controlled_QT_axis", "targetname" );

	// Spawn Enemies to kill with the QT
	level thread nrc_breach_theater();
	
	// Wait until we're sure the player is piloting the quadtank
	while( !IsDefined(level.player_controlled_quadtank) )
	{
		wait 0.1;	
	}
	
	//spawner::add_spawn_function_group( "nrc_playable_quadtank_fodder", "targetname", &nrc_playable_quadtank_fodder_spawnfunc );
	level thread enable_spawn_managers_for_player_controllable_quadtank();
	
	level thread qt2_nrc_technical_trucks();
	
	level thread theater_spawn_manager_watcher();
	
	// TODO - *** BETTER SCRIPTING FOR PROGRESSION WHEN PLAYER HAS CONTROL OF QT
	
	level flag::wait_till_any( array("qt_plaza_theater_destroyed", "qt_plaza_theater_enemies_cleared") );
	
	// small wait so RAPS don't spawn immediately
	wait 3.0;
	
	// TODO - custom scripting for this if the Quadtank is dead?
	spawn_manager::enable( "qt_plaza_controllable_qt_raps_sm" );
	
	// SET FLAG TO SPAWN THIRD QUADTANK
	level flag::set( "spawn_quad_tank_3" );			
}

function enable_spawn_managers_for_player_controllable_quadtank()
{
	// This wait is to allow the person controlling the QT to see these new enemies spawn in
	wait 3.0;
	
	a_nd_nodes = GetNodeArray( "mobile_wall_exposed_nodes", "targetname" );
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, true );
	}
	
	spawn_manager::enable( "nrc_mobile_wall_sm" );
	spawn_manager::enable( "demo_qt2_wasp_sm" );
}	

function quad_tank_plaza_hijacked_quadtank_watcher()
{
	level endon( "qt_plaza_outro_igc_started" );
	
	while( 1 )
	{
		level waittill( "ClonedEntity", clone);

		if( IsDefined( clone.scriptvehicletype ) && ( clone.scriptvehicletype == "quadtank" ) )
		{
			level.player_controlled_quadtank = clone;
			
			// HACK - SPAWN THE EXTRA STUFF HERE FOR THE DEMO	
			if( clone.targetname == "artillery_quadtank_ai" )
			{
			}
		}
		
		e_temp = clone GetVehicleowner();
	}
}

function theater_spawn_manager_watcher()
{
	level endon( "third_quadtank_killed" );
	
	spawn_manager::wait_till_spawned_count( "nrc_theater_sm", 6 );

	level flag::set( "qt_plaza_theater_enemies_cleared" );	
}

function nrc_breach_theater()
{
	// Stop friendly spawning in theater
	spawn_manager::disable( "sm_egypt_theater" );
	a_ai_egyptians = spawn_manager::get_ai( "sm_egypt_theater" );
	foreach( ai_egyptian in a_ai_egyptians )
	{
		ai_egyptian.health = 1;	
	}
	
	wait 5.0;
	
	spawn_manager::enable( "nrc_theater_sm" );
	
	a_e_breach_doors = GetEntArray( "breach_doors", "targetname" );
	foreach( e_breach_door in a_e_breach_doors )
	{		
		e_breach_door Delete();
	}
	
	level thread theater_breach_vo();
}

function qt2_nrc_technical_trucks()
{
	// These nodes stay disabled because they'll be completely inaccessible
	a_nd_nodes = GetNodeArray( "qt3_nrc_truck_nodes", "script_noteworthy" );
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, false );
	}
	
	a_nd_nodes = GetNodeArray( "qt1_nrc_truck_nodes", "script_noteworthy" );
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, false );
	}
	
	a_sp_trucks = GetEntArray( "nrc_qt3_truck", "targetname" );
	truck_sound_counter = 1;
	
	foreach (sp_truck in a_sp_trucks )
	{
		vh_nrc_plaza_truck = spawner::simple_spawn_single( sp_truck );
		vh_nrc_plaza_truck thread nrc_technical_damagefunc();
		
		ai_gunner = spawner::simple_spawn_single( "nrc_technical_gunner" );
		ai_gunner vehicle::get_in( vh_nrc_plaza_truck, "gunner1", true );
	
		nd_truck_start = GetVehicleNode( vh_nrc_plaza_truck.target, "targetname" );
		vh_nrc_plaza_truck thread vehicle::get_on_and_go_path( nd_truck_start );	
		
		vh_nrc_plaza_truck thread nrc_driveup_sound(truck_sound_counter);
		truck_sound_counter += 1;		
		
		vh_nrc_plaza_truck turret::enable( 1, true );

		wait( RandomFloatRange( 2.0, 5.0 ) );
	}
	
	level thread technical_truck_callout_vo();
	
	// Give the trucks some time to get into place
	wait 5.0;
	
	a_nd_nodes = GetNodeArray( "qt1_nrc_truck_nodes", "script_noteworthy" );
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, true );
	}
}

function nrc_driveup_sound(counter)
{
	wait (1);
	self playsound ("evt_tech_driveup_qt_pair_" + counter);
}



function nrc_technical_damagefunc() // self = truck
{
	level endon( "qt_plaza_outro_igc_started" );
	
	while( 1 )
	{
		self waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
		
		if( weapon == level.W_QUADTANK_PLAYER_WEAPON || weapon == level.W_QUADTANK_MLRS_WEAPON || weapon == level.W_QUADTANK_MLRS_WEAPON2 )
		{
			self DoDamage( self.health, self.origin );
			break;
		}
	}
	
	v_launch = (AnglesToForward( self.angles ) * -350) + (0, 0, 200);
	v_org = self.origin + AnglesToForward( self.angles )*10;
	self LaunchVehicle( v_launch, v_org, false );
	self thread nrc_technical_landed_watcher();
	
	a_ai_riders = self.riders;
	foreach( ai in a_ai_riders )
	{
		ai DoDamage( ai.health, ai.origin );
	}
}

function nrc_technical_landed_watcher() // self = truck
{
	self endon( "death" );
	if ( isdefined( 60 ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( 60, "timeout" );    };
	
	self waittill( "veh_landed" );	
	
	if( IsDefined( self ) )
	{
		self playsound ("evt_truck_impact");
	}
}

function qt_plaza_controllable_qt_raps_spawnfunc() // self = RAPS
{
	self endon( "death" );

	self SetThreatBiasGroup( "QT2_NRC_Raps" );
}

function qt1_nrc_raps_spawnfunc() // self = RAPS
{
	self endon( "death" );	
	
	self SetThreatBiasGroup( "QT2_NRC_Raps" );
	self ai::set_ignoreme( true );
	self thread qt1_raps_hijack_watcher();
	self thread qt1_raps_death_watcher();
}

function qt1_raps_hijack_watcher() // self = RAPS
{
	level endon( "stop_qt1_raps" );
	level endon( "quad_tank_1_destroyed" );
	self endon( "qt1_raps_death" );
	
	self waittill( "CloneAndRemoveEntity" );
	
	self notify( "qt1_raps_hijack" );
	level notify( "stop_qt1_raps" );
}

function qt1_raps_death_watcher() // self = RAPS
{
	level endon( "stop_qt1_raps" );
	level endon( "quad_tank_1_destroyed" );
	self endon( "qt1_raps_hijack" );
	
	self waittill( "death" );
	
	// HACK - this wait is a buffer so we can make sure the quadtank didn't really get hacked before proceeding.
	// We should remove this if we can guarantee the "CloneAndRemoveEntity" notify will fire before the "death" notify
	wait 2.0;
	
	if( IsDefined( self ) )
	{
		self notify( "qt1_raps_death" );	
	}
}
 
function artillery_qt_destroys_statue() // self = QT
{
	self endon( "death" );
	
	self util::magic_bullet_shield();
	
	s_target = struct::get( "qt_target_statue", "targetname" );
	e_target = spawn( "script_origin", s_target.origin );
	e_target.health = 100;
	
	e_trigger = GetEnt( "statue_fall_damage_trigger", "targetname" );
	
	self thread ai::shoot_at_target( "shoot_until_target_dead", e_target );
	self thread egyptians_by_statue_vignettes();
	
	level flag::set( "qt_targets_statue" );
	
	// wait until statue hit
	while( 1 )
	{
		e_trigger waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
		
		if( attacker == self && IsDefined( weapon ) && weapon == level.W_QUADTANK_WEAPON )
		{
			e_target notify( "death" );
			level flag::set( "qt_plaza_statue_destroyed" );
			break;
		}	
	}
	
	// trigger statue collapse
	self util::stop_magic_bullet_shield();
	level thread plaza_statue_fall();
	e_target Delete();
	level thread statue_fall_vo();
}

function egypt_statue_fall_guys_spawn_func() // self = AI
{
	self endon( "death" );
	
	self util::magic_bullet_shield();
	self ai::set_ignoreme( true );
	
	self waittill( "qt_plaza_statue_retreat" );
	
	self util::stop_magic_bullet_shield();
}

function egyptians_by_statue_vignettes() // self = QT
{
	self endon( "death" );
	
	a_ai = GetEntArray( "statue_fall_guys_ai", "targetname" );
	spawn_manager::disable( "sm_egypt_statue_fall" );
	a_s_scenes = struct::get_array( "qt_plaza_statue_retreat", "targetname" );
	a_s_scenes_copy = ArrayCopy( a_s_scenes );
	
	foreach( ai in a_ai )
	{
		s_scene = array::get_closest( ai.origin, a_s_scenes_copy );
		ArrayRemoveValue( a_s_scenes_copy, s_scene, false );
		s_scene thread scene::init( ai );
		ai notify( "qt_plaza_statue_retreat" );
		wait RandomFloatRange( 0.1, 0.25 );
	}
	
	while( !( isdefined( self.getreadytofire ) && self.getreadytofire ) )
	{
		wait 0.05;
	}
	
	// This wait is to help us time out the scenes of the Egyptians by the statue.
	// They fall over and die at the end of their anims, so we don't want them to die before the statue gets hit
	// A little bit after is fine, but not before
	wait 1.35;
	
	level thread egyptian_statue_fall_vo( a_ai );
	
	a_s_scenes_copy = ArrayCopy( a_s_scenes );
	foreach( s_scene in a_s_scenes_copy )
	{
		s_scene thread scene::play();
		wait RandomFloatRange( 0.1, 0.25 );
	}
}

function nrc_govt_building_rpg_guys_spawn_func() // self = AI
{
	self endon( "death" );
	
	e_goalvolume = GetEnt( self.target, "targetname" );
	self SetGoal( e_goalvolume, true );
	
	self.ignoreSuppression = true;
	
	trigger::wait_till( self.target, "targetname", self );
	
	level notify( "rpg_palace_callout_vo" );
}

function nrc_berm_guys_spawn_func() // self = AI
{
	self endon( "death" );
	
	e_goalvolume = GetEnt( self.target, "targetname" );
	self SetGoal( e_goalvolume, true );

	trigger::wait_till( self.target, "targetname", self );
	
	level notify( "rpg_berm_callout_vo" );	
}

function nrc_quadtank_guys_spawn_func() // self = AI
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "NRC_center_guys" );
	
	// Make the turrets ignore these guys in a solo game
	if( level.players.size == 1 )
	{
		a_ai = spawn_manager::get_ai( "sm_nrc_quadtank" );
		
		if( a_ai.size > 0 && IsDefined( level.qt_plaza_egyptian_turrets ) && (level.qt_plaza_egyptian_turrets.size > 0)  )
		{
			foreach( e_turret in level.qt_plaza_egyptian_turrets )
			{
				e_turret turret::set_ignore_ent_array( a_ai, 0 );		
			}
		}
	}
	
	if( !level flag::get( "quad_tank_1_destroyed" ) )
	{
		// HACK - these guys are getting killed too easily by friendly AI
		self.attackerAccuracy = 0.05;
		
		if( IsSubStr( self.classname, "shotgun" ) )
		{
			n_count = spawner::get_ai_group_ai( "qt1_nrc_shotgunner" ).size;
			if( n_count < 3 )
			{
				self thread qt1_nrc_cqb_shotgun_rusher();	
			}
		}
		else
		{
			self thread qt1_nrc_center_magic_bullet_shield();
		}
	}
}

function qt1_nrc_cqb_shotgun_rusher() // self = AI
{
	self endon( "death" );
	
	self flag::init( "nrc_qt1_shotgunner_rush" );
	
	// Shotgunners should ignore the Egyptian RPG soldiers up high (and vice versa)
	self SetThreatBiasGroup( "NRC_QT1_Shotgunners" );
	SetIgnoreMeGroup( "NRC_QT1_Shotgunners", "Egyptian_RPG_guys" );
	SetIgnoreMeGroup( "Egyptian_RPG_guys", "NRC_QT1_Shotgunners" );
	
	self thread qt1_nrc_shotgun_handle_magic_bullet_shield();
	
	self waittill( "goal" );
	
	// MAKE THIS GUY A RUSHER
	
	wait( RandomFloatRange( 5.0, 20.0 ) );
	
	a_nd_nodes = GetNodeArray( "nrc_shotgun_rusher_node", "targetname" );
	nd_goal = array::random( a_nd_nodes );
	self thread ai::force_goal( nd_goal, undefined, true, "goal", false );	
	self thread qt1_nrc_shotgun_goalvolume();
}

function qt1_nrc_shotgun_handle_magic_bullet_shield() // self = AI
{
	self endon( "death" );
		
	self util::magic_bullet_shield();

	self qt1_nrc_shotgun_damage_watcher();
	
	self util::stop_magic_bullet_shield();
}

function qt1_nrc_shotgun_damage_watcher()
{
	self endon( "death" );
	self endon( "nrc_qt1_shotgunner_rush" );
	level endon( "quad_tank_1_destroyed" );
	
	while( 1 )
	{
		self waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
		
		if( IsPlayer( attacker ) )
		{
			break;	
		}
	}	
}

// Wait for the shotgunner to touch the goalvolume
//
function qt1_nrc_shotgun_goalvolume() // self = AI
{
	self endon( "death" );
	
	e_goalvolume = GetEnt( "qt1_nrc_rusher_goalvolume", "targetname" );
	while( 1 )
	{
		e_goalvolume waittill( "trigger", ent );
		if( ent == self )
		{
			break;	
		}
	}
	
	self flag::set( "nrc_qt1_shotgunner_rush" );
	self SetGoal( e_goalvolume );
}

function qt1_nrc_center_magic_bullet_shield() // self = AI
{
	self endon( "death" );
		
	self util::magic_bullet_shield();

	self qt1_nrc_center_damage_watcher();
	
	self util::stop_magic_bullet_shield();	
}

function qt1_nrc_center_damage_watcher() // self = AI
{
	self endon( "death" );
	level endon( "quad_tank_1_destroyed" );

	while( 1 )
	{
		self waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
		
		if( IsPlayer( attacker ) )
		{
			break;	
		}
	}	
}

function nrc_quadtank2_robot_rushers_spawn_func() // self = AI
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "NRC_QT2_Robot_Rushers" );
	SetIgnoreMeGroup( "Egyptian_RPG_guys" , "NRC_QT2_Robot_Rushers" );
	
	self ai::set_behavior_attribute( "move_mode", "rusher" );
	self ai::set_behavior_attribute( "sprint", true );
	
	trigger::wait_till( "robot_callout_vo_trigger", "targetname", self );
	
	level notify( "robot_callout_vo" );
}

function egypt_qt2_theater_spawn_func() // self = AI
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "Egyptian_Theater_guys" );
}

function nrc_mobile_wall_spawn_func() // self = AI
{
	self endon( "death" );
	
	a_s_scenes = struct::get_array( "qt_plaza_traverse_mobile_wall", "targetname" );
	while( 1 )
	{
		foreach( s_scene in a_s_scenes )
		{
			if( !s_scene scene::is_playing() )
			{
				s_scene scene::play( self );
				return;
			}
		}
		
		wait 0.1;
	}
}

function init_statue_fxanim_clips()
{
	// hide statue fall carver clip
	a_e_carver = GetEntArray( "wing_carver_slanty", "targetname" );
	foreach( e_carver in a_e_carver )
	{
		e_carver NotSolid();
		e_carver ConnectPaths();		
	}
	
	a_e_carver = GetEntArray( "wing_carver_upright", "targetname" );
	foreach( e_carver in a_e_carver )
	{
		e_carver NotSolid();
		e_carver ConnectPaths();		
	}

	// collision
	a_e_collision = GetEntArray( "wing_slanty_collision", "targetname" );
	foreach( e_clip in a_e_collision )
	{
		e_clip NotSolid();
		e_clip ConnectPaths();
	}
	
	a_e_collision = GetEntArray( "wing_collision_upright", "targetname" );
	foreach( e_clip in a_e_collision )
	{
		e_clip NotSolid();
		e_clip ConnectPaths();
	}
}

function init_theater_fxanim_clips()
{
	a_e_post_collapse = GetEntArray( "post_collapse_collision", "targetname" );
	foreach( e_clip in a_e_post_collapse )
	{
		e_clip NotSolid();
		e_clip ConnectPaths();		
	}

	hide_destroyed_theater_fx_anim();
}

function init_palace_corner_fxanim_clips()
{
	a_e_debris = GetEntArray( "palace_corner_blocker", "targetname" );
	foreach( e_debris in a_e_debris )
	{
		e_debris NotSolid();
		e_debris ConnectPaths();		
		e_debris Hide();
	}
	
	a_nd_nodes = GetNodeArray( "qt_plaza_palace_corner_cover", "script_noteworthy" );
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, false );
	}
	
	wait 0.1;
	
	foreach( node in a_nd_nodes )
	{
		SetEnableNode( node, true );
	}
}

function init_outro_igc_shadow_cards()
{
	e_card = GetEnt( "outro_shot_010_shadow", "targetname" );
	e_card Hide();
	
	e_card = GetEnt( "outro_shot_020_shadow", "targetname" );
	e_card Hide();
	
	e_card = GetEnt( "outro_shot_040_shadow", "targetname" );
	e_card Hide();
}

function plaza_statue_fall()
{
	level thread scene::play( "p7_fxanim_cp_ramses_quadtank_statue_bundle" );
	e_qt_statue = getent( "quadtank_statue", "targetname" );
	e_qt_statue thread bird_wing_impact();
	e_qt_statue thread bird_body_impact();
	
	//rumble and screenshake on players 
	rumble_and_camshake( "s_statue_pos" );
}

function bird_wing_impact() // self = QT statue
{
	self waittill( "bird_wing_impact" );
	
	rumble_and_camshake( "bird_wing_impact" );
	
	// show statue fall carver clip
	a_e_carver = GetEntArray( "wing_carver_upright", "targetname" );
	foreach( e_carver in a_e_carver )
	{
		e_carver Solid();
		e_carver DisconnectPaths();		
	}
	
	// collision
	a_e_collision = GetEntArray( "wing_collision_upright", "targetname" );
	foreach( e_clip in a_e_collision )
	{
		e_clip Solid();
		e_clip DisconnectPaths();
	}
	
	// Kill anyone in the area where the bird wing comes down
	a_t_kill_statue_fall = GetEntArray( "trig_kill_bird_wing", "targetname" );
	a_ai = GetAIArray();
	a_all_actors = ArrayCombine( a_ai, level.players, true, false );
	foreach( e_actor in a_all_actors )
	{
		if( e_actor util::is_hero() )
		{
			continue;	
		}
		
		if( e_actor === level.player_controlled_quadtank )
		{
			e_actor DoDamage( e_actor.health, e_actor.origin );
		}	
		
		foreach( t_kill in a_t_kill_statue_fall )
		{
			if ( e_actor IsTouching( t_kill ) )
			{
				if( IsPlayer( e_actor ) )
				{
					e_actor DoDamage( e_actor.health, e_actor.origin );
					break;
				}
				else
				{
					e_actor Kill();
					break;
				}
			}
		}	
	}
}

function bird_body_impact() // self = QT statue
{
	self waittill( "bird_body_impact" );

	rumble_and_camshake( "bird_body_impact" );
		
	// show statue fall carver clip
	a_e_carver = GetEntArray( "wing_carver_slanty", "targetname" );
	foreach( e_carver in a_e_carver )
	{
		e_carver Solid();
		e_carver DisconnectPaths();		
	}
	
	// collision
	a_e_collision = GetEntArray( "wing_slanty_collision", "targetname" );
	foreach( e_clip in a_e_collision )
	{
		e_clip Solid();
		e_clip DisconnectPaths();	
	}
	
	// Disable Cover Nodes
	a_nd_statue = GetNodeArray( "statue_fall_cover_nodes", "targetname" );
	foreach( nd_statue in a_nd_statue )
	{
		SetEnableNode( nd_statue, false );
	}
	
	// Kill anyone in the area where the bird body comes down
	a_t_kill_statue_fall = GetEntArray( "trig_kill_bird_body", "targetname" );
	a_ai = GetAIArray();
	a_all_actors = ArrayCombine( a_ai, level.players, true, false );
	foreach( e_actor in a_all_actors )
	{
		if( e_actor util::is_hero() )
		{
			continue;	
		}
		
		if( e_actor === level.player_controlled_quadtank )
		{
			e_actor DoDamage( e_actor.health, e_actor.origin );
		}	
		
		foreach( t_kill in a_t_kill_statue_fall )
		{
			if ( e_actor IsTouching( t_kill ) )
			{
				if( IsPlayer( e_actor ) )
				{
					e_actor DoDamage( e_actor.health, e_actor.origin );
					break;
				}
				else
				{
					e_actor Kill();
					break;
				}
			}
		}	
	}
}

function nrc_playable_quadtank_fodder_spawnfunc() // self = AI
{	
	foreach( e_player in level.players )
	{
		if( ( isdefined( e_player.hacked_quadtank ) && e_player.hacked_quadtank ) )
		{
			self thread nrc_fodder_handle_objective();		
		}
	}
}

function nrc_fodder_handle_objective() // self = AI
{
	objectives::set( "cp_level_ramses_demo_quadtank_nrc_targets", self );

	self waittill( "death" );
	
	objectives::complete( "cp_level_ramses_demo_quadtank_nrc_targets", self );	
}

function third_quadtank()
{
	wait 2.0;
	
	ai_third_quadtank = spawner::simple_spawn_single( "third_quadtank" );
	level.third_quadtank = ai_third_quadtank;
	ai_third_quadtank SetThreatBiasGroup( "NRC_Quadtank" );
	ai_third_quadtank thread third_quadtank_deathfunc();
	
	level flag::set( "quad_tank_3_spawned" );
	level notify ("t3_spawn"); //music
	
	level thread qt3_phalanx();
	
	a_bm_second_quadtank_wall = GetEntArray( "oh_yeah_explosion", "targetname" );
	foreach( e_piece in a_bm_second_quadtank_wall )
	{
		e_piece Delete();
	}
	
	// FX Anims
	scene::add_scene_func( "p7_fxanim_cp_ramses_quadtank_plaza_glass_building_bundle", &third_quadtank_spawn_vo, "done" );
	level thread scene::play( "p7_fxanim_cp_ramses_quadtank_plaza_glass_building_bundle" );
	
	rumble_and_camshake( "glass_building_pos" );
	
	ai_third_quadtank thread quadtank_flavor_vo();
	
	level flag::wait_till( "third_quadtank_killed" );
	
	// Make sure the player isn't controlling a quadtank before we trigger the outro IGC
	while( IsDefined( level.player_controlled_quadtank ) )
	{
		wait 0.1;	
	}
	
	// DISABLE ALL REMAINING SPAWN MANAGERS
	level notify( "qt2_nrc_robot_rushers_sm_wave_spawner_stop" );
	spawn_manager::disable( "qt2_nrc_robot_rushers_sm" );
	
	level notify( "sm_nrc_quadtank_wave_spawner_stop" );
	spawn_manager::disable( "sm_nrc_quadtank" );
	
	qt_plaza_outro();	
}

function qt_plaza_outro( b_dev_skipto = false )
{
	level thread util::set_streamer_hint( 4 );
	
	// Allow some time between the quadtank dying and the outro for the demo
	wait 1.0;
	
//	if( ramses_util::is_demo() )
//	{
		level thread ramses_util::post_fx_transitions("dni_futz");
		
		// This wait is to allow the futz to play over the transition into the IGC
		wait 1.5;
		
		level thread quad_tank_plaza_spawn_manager_cleanup();
		e_qt_corpse = GetEnt( "demo_intro_mlrs_quadtank_ai", "targetname" );
		if( IsDefined( e_qt_corpse ) )
		{
			e_qt_corpse Delete();
		}

      	level thread stop_dead_system_fx_anim();
		level flag::set( "qt_plaza_outro_igc_started" );
		level notify ("start_outro"); //starts outtro music
		
		level thread scene::init( "p7_fxanim_cp_ramses_flyover_plaza_cinematic_bundle" );
		
		vehicle::add_spawn_function( "qt_plaza_outro_vtol_flyovers", &vtol_qt_flyover_spawnfunc );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh010", &sh010_shadow_card_show, "play" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh010", &sh010_shadow_card_hide, "done" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh020", &start_sh020_vtol_flyovers, "play" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh020", &sh020_shadow_card_show, "play" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh020", &sh020_shadow_card_hide, "done" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh030", &start_sh030_vtol_flyovers, "play" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh030", &adjust_sunshadowsplitdistance, "play" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh030", &reset_sunshadowsplitdistance, "done" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh040", &sh040_shadow_card_show, "play" );
		scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_sh040", &fade_out_and_end, "done" );
		
		level clientfield::set( "qt_plaza_outro_exposure", 1 );	
		level scene::play( "cin_ram_08_gettofreeway_3rd_sh010" );

		// Notetrack on ch_ram_08_gettofreeway_3rd_sh040_hendricks
//		level.ai_hendricks waittill( "cut_to_black" );
//	
//		util::screen_fade_out( 2.0 );
//		
//		util::clear_streamer_hint();
//
//		skipto::objective_completed( "quad_tank_plaza" );	
//			
////	}
//	else
//	{
//		// Old QT Plaza Outro
//		level thread quad_tank_plaza_outro();
//	}	
}

function fade_out_and_end( a_ents )
{
	util::screen_fade_out( 2.0 );
		
	util::clear_streamer_hint();

	skipto::objective_completed( "quad_tank_plaza" );	
}

function start_sh020_vtol_flyovers( a_ents )
{
	trigger::use( "vtol_flyover_spawn_sh020" );
	
	level thread scene::play( "p7_fxanim_cp_ramses_flyover_plaza_cinematic_bundle" );
	
	// notetrack on ch_ram_08_gettofreeway_3rd_sh020_player
	level waittill( "sh020_send_VTOL_2" );
	
	trigger::use( "vtol_flyover_spawn_sh020_part_2" );
	
	// notetrack on ch_ram_08_gettofreeway_3rd_sh020_player
	level waittill( "sh020_send_VTOL_3" );
	
	trigger::use( "vtol_flyover_spawn_sh020_part_3" );
}

function start_sh030_vtol_flyovers( a_ents )
{
	trigger::use( "vtol_flyover_spawn_sh030" );	
	
	// notetrack on ch_ram_08_gettofreeway_3rd_sh030_player
	level waittill( "sh030_send_VTOL_2" );
	
	trigger::use( "vtol_flyover_spawn_sh030_part_2" );	
}

function vtol_qt_flyover_spawnfunc() // self = VTOL
{
	self endon( "death" );
	
	a_e_models = [];
	
	a_s_structs = struct::get_array( self.target, "targetname" );
	foreach( struct in a_s_structs )
	{
		e_model = spawn( "script_model", struct.origin );
		e_model.angles = struct.angles;
		e_model SetModel( struct.model );
		e_model LinkTo( self );
		a_e_models[ a_e_models.size ] = e_model;
	}
	
	self waittill( "reached_end_node" );
	
	array::run_all( a_e_models, &Delete );
	self Delete();
}


function adjust_sunshadowsplitdistance( a_ents )
{
	level.old_sunshadowsplitdistance = level.sun_shadow_split_distance;

	// SET THE SUNSHADOWSPLITDISTANCE	
	level util::set_sun_shadow_split_distance( 5000 );
}

function reset_sunshadowsplitdistance( a_ents )
{
	if( IsDefined( level.old_sunshadowsplitdistance ) )
	{
		level util::set_sun_shadow_split_distance( level.old_sunshadowsplitdistance );
	}
}

function sh010_shadow_card_show( a_ents )
{
	e_card = GetEnt( "outro_shot_010_shadow", "targetname" );
	e_card Show();
}

function sh010_shadow_card_hide( a_ents )
{
	e_card = GetEnt( "outro_shot_010_shadow", "targetname" );
	e_card Hide();
}

function sh020_shadow_card_show( a_ents )
{
	e_card = GetEnt( "outro_shot_020_shadow", "targetname" );
	e_card Show();
}

function sh020_shadow_card_hide( a_ents )
{
	e_card = GetEnt( "outro_shot_020_shadow", "targetname" );
	e_card Hide();
}

function sh040_shadow_card_show( a_ents )
{
	e_card = GetEnt( "outro_shot_040_shadow", "targetname" );
	e_card Show();
}

function third_quadtank_deathfunc() // self = QT
{
	objectives::set( "cp_level_ramses_demo_quadtank_nrc_targets", self );

	self waittill( "death" );
	
	objectives::complete( "cp_level_ramses_demo_quadtank_nrc_targets", self );
	level flag::set( "third_quadtank_killed" );
}

function qt3_phalanx()
{
	startPosition = struct::get( "qt_plaza_new_bldg_phalanx_start", "targetname" );
	endPosition = struct::get( "qt_plaza_new_bldg_phalanx_end", "targetname" );
	
	phalanx = new RobotPhalanx();
	[[ phalanx ]]->Initialize( "phalanx_column", startPosition.origin, endPosition.origin, 2, level.maxTierSize );
	level.phalanx = phalanx;
	
	level thread qt3_scatter_phalanx();
	
	robots = ArrayCombine(
		ArrayCombine( phalanx.tier1Robots_, phalanx.tier2Robots_, false, false ),
		phalanx.tier3Robots_,
		false,
		false );
	
	ai::waittill_dead( robots, 5 );
	
	spawn_manager::enable( "sm_nrc_quadtank3_robots" );
	
	level.phalanx = undefined;	
}

function qt3_scatter_phalanx()
{
	wait 15;
	
	if( IsDefined( level.phalanx ) )
	{
		level.phalanx robotphalanx::ScatterPhalanx();	
	}
}

/***********************************
 * MAIN LEVEL LOGIC
 * ********************************/

function main_mlrs_quadtank()
{
    //destroyed wall that happens when first quad tank lands
	a_bm_qt_fall_event = GetEntArray( "qt_fall_event", "targetname" );
	foreach( bm_piece in a_bm_qt_fall_event )
	{
		if ( isdefined( bm_piece ) ) 
		{
			bm_piece Delete();
		}
	}		
	
	ai_mlrs_quadtank = spawner::simple_spawn_single( "main_mlrs_quadtank" );
	
	ai_mlrs_quadtank SetThreatBiasGroup( "NRC_Quadtank" );	
	
	//level.second_quadtank = ai_artillery_quadtank;

	e_goalvolume = GetEnt( "vol_qt_battle", "targetname" );
	ai_mlrs_quadtank setgoal( e_goalvolume );	
	
	ai_mlrs_quadtank util::waittill_any( "enter_vehicle", "death", "CloneAndRemoveEntity" );
	
	level flag::set( "quad_tank_1_destroyed" );
}

function quad_tank_plaza_outro()
{
	nd_hendricks_plaza_igc_pos = GetNode( "hendricks_plaza_igc_pos", "targetname" );
	nd_khalil_plaza_igc_pos = GetNode( "khalil_plaza_igc_pos", "targetname" );

	level.ai_khalil colors::disable();
	level.ai_hendricks colors::disable();
	
	level.ai_khalil thread ai::force_goal( nd_khalil_plaza_igc_pos, 32 );
	level.ai_hendricks thread ai::force_goal( nd_hendricks_plaza_igc_pos, 32 );
	
	array::wait_till( level.heroes, "goal" );
	
	level flag::set( "obj_plaza_cleared" );
	
	level.ai_khalil.goalradius = 32;
	level.ai_hendricks.goalradius = 32;
	
	level.ai_khalil.ignoreall = true;
	level.ai_hendricks.ignoreall = true;
	
	//show igc trigger at regroup
	e_trig_plaza_igc = GetEnt( "trig_plaza_igc", "targetname" );
	e_trig_plaza_igc SetVisibleToAll();	
	e_trig_plaza_igc waittill( "trigger", e_player );
	e_trig_plaza_igc SetInVisibleToAll();

	level thread stop_dead_system_fx_anim();
	level flag::set( "qt_plaza_outro_igc_started" );	
	
	scene::add_scene_func( "cin_ram_08_gettofreeway_3rd_pre100", &get_to_freeway_scene_complete,"done" );
	scene::add_scene_func( "cin_ram_08_gettofreeway_vign_start", &get_to_freeway_vign_scene_complete,"done" );
	
	level thread scene::play( "cin_ram_08_gettofreeway_3rd_pre100" );
	
	level waittill( "get_to_freeway_scene_complete" );	
	
	level thread scene::play( "cin_ram_08_gettofreeway_vign_start" );
	
	level waittill( "get_to_freeway_vign_scene_complete" );
	
	// Teleport players and heroes up to the hole
	skipto::teleport( "get_to_freeway_complete_teleport", level.heroes );
	
	level flag::set( "obj_player_at_plaza_igc" );
	
	level.ai_khalil.ignoreall = false;
	level.ai_hendricks.ignoreall = false;	
	
	level.ai_khalil colors::enable();
	level.ai_hendricks colors::enable();	
	
	level flag::set( "obj_follow_khalil" );
	
	//color chain for moving heroes into building with hole blown out from second quad tank
	trigger::use( "trig_color_post_plaza", "targetname", undefined, false );	
	
	skipto::objective_completed( "quad_tank_plaza" );
	
	//TEMP: debug text to indicate IGC
	foreach( e_player in level.players )
	{
		e_player.hud_elem = e_player create_client_hud_elem( "center", "middle", "center", "top", 0, 135, 1.5, ( 1.0, 1.0, 1.0 ), &"CP_MI_CAIRO_RAMSES_PLAZA_IGC" );
	}
	
	wait 4;

	foreach( e_player in level.players )
	{
		e_player.hud_elem Destroy();
	}		
}

function get_to_freeway_scene_complete( a_ents )
{	
	level notify( "get_to_freeway_scene_complete" );
}

function get_to_freeway_vign_scene_complete( a_ents )
{	
	level notify( "get_to_freeway_vign_scene_complete" );
}

function create_client_hud_elem( alignX, alignY, horzAlign, vertAlign, xOffset, yOffset, fontScale, color, str_text )  // self = the player
{
	hud_elem = NewClientHudElem( self );
	hud_elem.elemType = "font";
	hud_elem.font = "objective";
	hud_elem.alignX = alignX;
	hud_elem.alignY = alignY;
	hud_elem.horzAlign = horzAlign;
	hud_elem.vertAlign = vertAlign;
	hud_elem.x += xOffset;
	hud_elem.y += yOffset;
	hud_elem.foreground = true;
	hud_elem.fontScale = fontScale;
	hud_elem.alpha = 1;
	hud_elem.color = color;
	hud_elem.hidewheninmenu = true;
	
	hud_elem SetText( str_text );
	
	return hud_elem;
}

function siege_bot_deathfunc()
{
	self waittill( "death" );
	ArrayRemoveValue( level.a_siege_bots, self );
	
	//set this flag because of the bots has died
	level flag::set( "siege_bot_solo" );
	level notify( "qt_plaza_siege_bot_killed" );
}

function monitor_siege_bot_death()
{
	while( level.a_siege_bots.size > 0 )
	{
		level waittill( "qt_plaza_siege_bot_killed" );	
	}
	
	level flag::set( "all_siege_bots_killed" );
}

function plaza_wasps_think() //self = wasp
{
	self endon( "death" );
	
	e_wasps_vol = GetEnt( self.target, "targetname" );
	self SetGoal( e_wasps_vol, true );
	
	self thread wasp_vo_trigger_watcher();
}

function wasp_vo_trigger_watcher() // self = wasp
{
	self endon( "death" );
	
	trigger::wait_till( "qt_plaza_wasp_vo_trigger", "targetname", self );
	
	level notify( "wasp_callout_vo" );
}

/***********************************
 * SPAWN MANAGER - WAVE SPAWNER
 * ********************************/
 // This function allows us to provide gaps in spawn manager spawning
 // Currently only set up to do this in solo games to make the QT Plaza fight a bit easier
 // Waits for the spawn manager to spawn to full, then disables the spawn manager
 // Then waits for the active count to drop below the respawn threshold
 // Then waits for a specified time
 // Then re-enables the spawn manager
function wave_spawner( n_min_wait, n_max_wait, n_respawn_threshold ) // self = spawn manager
{
	level endon( self.targetname + "_wave_spawner_stop" );
	
	Assert( n_min_wait <= n_max_wait, "Wave Spawner: min wait must be less than max wait" );
	Assert( n_respawn_threshold <= self.sm_active_count_max, "Wave Spawner: respawn threshold must be less than the spawn manager's sm_active_count_max" );
	
	// Ensure that players have spawned in
	level flag::wait_till( "all_players_spawned" );
	
	while( level.players.size == 1 )
	{
		// Wait for the spawn manager to spawn to full then disable the spawn manager
		while( 1 )
		{
			a_active_ai = spawn_manager::get_ai( self.targetname );
		
			if( a_active_ai.size < self.sm_active_count_max )
			{
				wait 0.1;
				
				continue;
			}
			else
			{
				spawn_manager::disable( self.targetname );
				
				break;
			}
		}
		
		// Wait for the Ai count to drop below the respawn threshhold
		// Then re-enable the spawn manager
		while( 1 )
		{
			a_active_ai = spawn_manager::get_ai( self.targetname );
			
			if( a_active_ai.size <= n_respawn_threshold )
			{
				wait( RandomFloatRange( n_min_wait, n_max_wait ) );
				
				spawn_manager::enable( self.targetname );
				
				break;
			}
			else
			{
				wait 0.1;	
			}
		}
	}
}

/***********************************
 * QUADTANK HIJACKED FUNCTION
 * ********************************/

function quadtank_hijacked() // self = hijacked quadtank
{
	// TODO - THIS GETVEHICLEOWNER() CALL DOESN'T WORK ANYMORE
	//e_player = self GetVehicleOwner();
	//level.quadtank_owner = e_player;
	
	level.player_controlled_quadtank = self;
	
	self thread player_controlled_quadtank_deathfunc();
	
	// Make NRC focus their attack on the hijacked quadtank
	self.threatbias = 3000;
	
	// LEVEL LOGIC
	level thread theater_fxanim();
	level thread mobile_wall_fxanim();
	
	// TODO - testing using physics impulses on script_models
	//level thread test_quadtank_damage_trigger();	
}

function player_controlled_quadtank_deathfunc()
{
	self waittill( "death" );
	
	level.player_controlled_quadtank = undefined;
	level.quadtank_owner = undefined;
}

function player_hijack_watcher() // self = player
{
	self endon( "disconnect" );
	
	while( 1 )
	{
		self waittill( "ClonedEntity", e_clone );

		e_clone SetThreatBiasGroup( "PlayerVehicles" );
		
		if( IsDefined( e_clone.archetype ) && ( e_clone.archetype == "quadtank" ) )
		{
			level.quadtank_owner = self;	
		}
	}
}

function theater_fxanim()
{
	level endon( "qt_plaza_outro_igc_started" );
	level.player_controlled_quadtank endon( "death" );

	if( flag::get( "qt_plaza_theater_destroyed" ) )
	{
		return;	
	}
	
	level thread theater_damage_trigger();
	level thread theater_fx_anim_damage_watcher();
	level thread quadtank_fired_watcher();
	
	level flag::wait_till( "qt_plaza_theater_destroyed" );
	
	e_fx_anim = GetEnt( "cinema_collapse", "targetname" );
	e_fx_anim thread left_debris_hit_notetrack();
	e_fx_anim thread right_debris_hit_notetrack();
	e_fx_anim thread center_debris_hit_notetrack();
	
	level thread scene::play( "p7_fxanim_cp_ramses_cinema_collapse_bundle" );
	
	show_destroyed_theater_fx_anim();

	// Lights and FX for the Theater
	exploder::exploder_stop( "LGT_theater" );
	
	// Disable Spawn Managers Inside Theater
	spawn_manager::disable( "nrc_theater_sm" );
	spawn_manager::disable( "sm_egypt_theater" );
	
	// KILL OFF EVERYONE INSIDE
	e_trigger = GetEnt( "theater_damage_trigger", "targetname" );
	level thread kill_stuff_theater_fxanim( e_trigger );
	
	a_nd_cover = GetNodeArray( "qt_plaza_theater_cover_node", "script_noteworthy" );
	foreach( node in a_nd_cover )
	{
		SetEnableNode( node, false );
	}
	
	// HANDLE COLLISION AND NAVMESH
	a_e_post_collapse = GetEntArray( "post_collapse_collision", "targetname" );
	foreach( e_clip in a_e_post_collapse )
	{
		e_clip Solid();
		e_clip DisconnectPaths();		
	}
	
	a_e_pre_collapse = GetEntArray( "pre_collapse_collision", "targetname" );
	foreach( e_clip in a_e_pre_collapse )
	{
		e_clip NotSolid();
	}
	
	//rumble and screenshake on players
	// TODO - tune radius/strength
	rumble_and_camshake( "theater_fxanim_org" );
	
	// Delete ammo boxes
	array::run_all( GetEntArray( "qt_plaza_theater_ammo", "targetname" ), &Delete);
}

function kill_stuff_theater_fxanim( e_trigger, b_kill_quadtank = false )
{
	a_ai = GetAIArray();
	foreach( ai in a_ai )
	{
		if( IsDefined( level.player_controlled_quadtank ) && ai == level.player_controlled_quadtank )
		{
			if( b_kill_quadtank && ai IsTouching( e_trigger ) )
			{
				ai DoDamage( ai.health, ai.origin );
				continue;
			}
			else
			{
				continue;	
			}
		}
		
		if( IsDefined( ai.archetype ) && (ai.archetype == "quadtank" ) )
		{
			if( b_kill_quadtank && ai IsTouching( e_trigger ) )
			{
				ai DoDamage( ai.health, ai.origin );
				continue;
			}
			else
			{
				continue;	
			}	
		}
		
		if( ai IsTouching( e_trigger ) && !ai util::is_hero() )
		{
			ai Kill();
		}
	}
	
	foreach( player in level.players )
	{
		if( player IsTouching( e_trigger ) )
		{
			player DoDamage( player.health, player.origin );
		}	
	}	
}

function theater_damage_trigger()
{
	level endon( "qt_plaza_theater_destroyed" );
	level.player_controlled_quadtank endon( "death" );
	
	e_trigger = GetEnt( "theater_damage_trigger", "targetname" );
	
	while( 1 )
	{
		e_trigger waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
		
		if( attacker === level.quadtank_owner )
		{
			if( type === "MOD_PROJECTILE" || type === "MOD_PROJECTILE_SPLASH" )
			{
				//	PLAYER HIT THE THEATER
				level flag::set( "qt_plaza_theater_destroyed" );
				break;	
			}
		}
	}	
}

function theater_fx_anim_damage_watcher()
{
	level endon( "qt_plaza_theater_destroyed" );
	level.player_controlled_quadtank endon( "death" );
	
	e_fx_anim = GetEnt( "cinema_collapse", "targetname" );
	e_fx_anim SetCanDamage( true );
	e_fx_anim.health = 100;
	
	while( 1 )
	{
		e_fx_anim waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );

		if( attacker === level.quadtank_owner )
		{
			if( weapon === level.W_QUADTANK_PLAYER_WEAPON || weapon === level.W_QUADTANK_MLRS_WEAPON || weapon === level.W_QUADTANK_MLRS_WEAPON2 )
			{
				//	PLAYER HIT THE THEATER
				e_fx_anim SetCanDamage( false );
				level flag::set( "qt_plaza_theater_destroyed" );
				break;
			}
		}
	}
}

function quadtank_fired_watcher()
{
	level endon( "qt_plaza_theater_destroyed" );
	level.player_controlled_quadtank endon( "death" );

	while( 1 )
	{
		level.player_controlled_quadtank waittill( "weapon_fired", projectile );

		projectile thread player_controlled_quadtank_fired_projectile();
	}
}

function player_controlled_quadtank_fired_projectile() // self = projectile
{
	self endon( "death" );
	
	e_trigger = GetEnt( "theater_damage_trigger", "targetname" );
	
	while( 1 )
	{
		if( self IsTouching( e_trigger ) )
		{
			// Make the projectile detonate early
			self notify( "death" );
		}
		
		wait 0.05;
	}
}

function left_debris_hit_notetrack() // self = fx anim script model
{
	self waittill( "left_debris_hits_ground" );
	
	// KILL TRIGGER LEFT
	e_trigger = GetEnt( "theater_fxanim_kill_trigger_left", "targetname" );
	level thread kill_stuff_theater_fxanim( e_trigger, true );
	
	rumble_and_camshake( "theater_fxanim_left_debris" );
}

function right_debris_hit_notetrack() // self = fx anim script model
{
	self waittill( "right_debris_hits_ground" );

	// KILL TRIGGER RIGHT
	e_trigger = GetEnt( "theater_fxanim_kill_trigger_right", "targetname" );
	level thread kill_stuff_theater_fxanim( e_trigger, true );
	
	rumble_and_camshake( "theater_fxanim_right_debris" );
}

function center_debris_hit_notetrack() // self = fx anim script model
{
	self waittill( "center_debris_hits_ground" );
	
	// KILL TRIGGER CENTER
	e_trigger = GetEnt( "theater_fxanim_kill_trigger_center", "targetname" );
	level thread kill_stuff_theater_fxanim( e_trigger, true );
	
	rumble_and_camshake( "theater_fxanim_center_debris" );
}

// TODO - testing using physics impulses on script_models
function test_quadtank_damage_trigger()
{		
	level endon( "qt_plaza_outro_igc_started" );
	
	while( 1 )
	{
		e_trigger = GetEnt( "test_quadtank_damage", "targetname" );
		e_trigger waittill( "trigger", ent );
		
		if( IsDefined(level.quadtank_owner) && ent == level.quadtank_owner )
		{
			a_e_objs = GetEntArray( "physics_test_objects", "targetname" );
			foreach( e_obj in a_e_objs )
			{
				e_obj physicslaunch( e_obj.origin, ( 0,0,20 ) );
			}
		}
	}
}

function mobile_wall_fxanim()
{
	level endon( "qt_plaza_outro_igc_started" );
	level.player_controlled_quadtank endon( "death" );	
	
	if( level flag::get( "qt_plaza_mobile_wall_destroyed" ) )
	{
		return;	
	}
	
	level thread mobile_wall_fxanim_damage_watcher();
	
	level flag::wait_till( "qt_plaza_mobile_wall_destroyed" );
	
	level thread scene::play( "p7_fxanim_cp_ramses_mobile_wall_explode_bundle" );

	rumble_and_camshake( "mobile_wall_fxanim" );
	
	a_e_props = GetEntArray( "mobile_wall_explosion_hidden", "targetname" );
	foreach( e_prop in a_e_props )
	{
		e_prop Hide();
	}
}

function mobile_wall_fxanim_damage_watcher()
{
	level endon( "qt_plaza_mobile_wall_destroyed" );
	level.player_controlled_quadtank endon( "death" );
	
	e_fx_anim = GetEnt( "mobile_wall_explode", "targetname" );
	e_fx_anim SetCanDamage( true );
	e_fx_anim.health = 100;
	
	while( 1 )
	{
		e_fx_anim waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );

		if( attacker === level.quadtank_owner )
		{
			if( weapon === level.W_QUADTANK_PLAYER_WEAPON || weapon === level.W_QUADTANK_MLRS_WEAPON || weapon === level.W_QUADTANK_MLRS_WEAPON2 )
			{
				//	PLAYER HIT THE THEATER
				e_fx_anim SetCanDamage( false );
				level flag::set( "qt_plaza_mobile_wall_destroyed" );
				break;
			}
		}
	}
}
 
/***********************************
 * Ambient Dead System Activity
 * ********************************/
 
function vtol_igc_hunter_fx_anim()
{
	level clientfield::set( "vtol_igc_fxanim_hunter", 1 );		
}

function dead_system_fx_anim()
{
	level clientfield::set( "qt_plaza_fxanim_hunters", 1 );	
}

function stop_dead_system_fx_anim()
{
	level clientfield::set( "qt_plaza_fxanim_hunters", 0 );	
}

function hide_destroyed_theater_fx_anim()
{
	level clientfield::set( "theater_fxanim_swap", 1 );
	
	array::run_all( GetEntArray( "destroyed_interior", "targetname" ), &Hide );
}

function show_destroyed_theater_fx_anim()
{
	level clientfield::set( "theater_fxanim_swap", 0 );

	a_e_models = GetEntArray( "pristine_interior", "targetname" );
	foreach( e_model in a_e_models )
	{
		e_model Hide();
	}
	
	array::run_all( GetEntArray( "destroyed_interior", "targetname" ), &Show );
}

/***********************************
 * RUMBLE AND CAMSHAKE
 * ********************************/
 
function rumble_and_camshake( str_targetname )
{
	s_pos = struct::get( str_targetname, "targetname" );
	foreach( e_player in level.players )
	{
		n_distance_squared = Distance2DSquared( s_pos.origin, e_player.origin );
		
		//earthquake and rumble
		if ( n_distance_squared < 1000 * 1000 )
		{
			e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
			Earthquake( 0.65, 0.7, e_player.origin, 128.0 );

			// Shellshock
			if ( n_distance_squared < 250 * 250 )
			{
				e_player Shellshock( "default", 1.5 );	
			}			
		}
	}	
}

/***********************************
 * VO
 * ********************************/

function post_vtol_igc_vo()
{
	a_str_lines = [];
	a_str_lines[ 0 ] = "hend_grab_some_cover_go_0";
	a_str_lines[ 1 ] = "hend_get_outta_there_fin_0";
	
	str_line = array::random( a_str_lines );
	
	level.ai_hendricks thread dialog::say( str_line );
}

// Reminder VO that plays if players go too long without dropping the first QT's trophy system
function quadtank_trophy_system_reminder_vo() // self = QT
{
	self endon( "trophy_system_disabled" );
	level endon( "quad_tank_1_destroyed" );
	
	a_str_hendricks_lines = [];
	a_str_hendricks_lines[ 0 ] = "hend_focus_on_the_trophy_0";
	a_str_hendricks_lines[ 1 ] = "hend_focus_fire_on_its_tr_0";
	a_str_hendricks_lines[ 2 ] = "hend_that_quad_s_untoucha_0";
	
	a_str_kane_lines = [];
	a_str_kane_lines[ 0 ] = "kane_focus_fire_on_the_tr_0";
	a_str_kane_lines[ 1 ] = "kane_target_the_trophy_sy_0";
	a_str_kane_lines[ 2 ] = "kane_yo_need_to_blow_the_0";
	
	str_last_hendricks_line = undefined;
	str_last_kane_line = undefined;
	
	while( 1 )
	{
		wait 30;
		
		if( math::cointoss() )
		{
			str_line = pick_new_line( a_str_hendricks_lines, str_last_hendricks_line );
			level.ai_hendricks dialog::say( str_line );
			str_last_hendricks_line = str_line;
		}
		else
		{
			str_line = pick_new_line( a_str_kane_lines, str_last_kane_line );
			level dialog::remote( str_line );
			str_last_kane_line = str_line;
		}
	}
}

// Reminder VO that plays while fighting QT1
function quadtank1_flavor_vo() // self = QT
{
	level endon( "quad_tank_1_destroyed" );
	
	self waittill( "trophy_system_disabled" );
	
	a_str_hendricks_lines = [];
	a_str_hendricks_lines[ 0 ] = "hend_bring_down_that_son_0";
	a_str_hendricks_lines[ 1 ] = "hend_that_quad_s_armed_wi_0";
	a_str_hendricks_lines[ 2 ] = "hend_quad_s_rockets_are_g_0";
	
	a_str_kane_lines = [];
	a_str_kane_lines[ 0 ] = "kane_take_out_that_quad_b_0";
	a_str_kane_lines[ 1 ] = "kane_that_quad_s_rockets_0";
	
	str_last_hendricks_line = undefined;
	str_last_kane_line = undefined;
	
	while( 1 )
	{
		wait RandomFloatRange( 45, 60 );
		
		if( math::cointoss() )
		{
			str_line = pick_new_line( a_str_hendricks_lines, str_last_hendricks_line );
			level.ai_hendricks dialog::say( str_line );
			str_last_hendricks_line = str_line;
		}
		else
		{
			str_line = pick_new_line( a_str_kane_lines, str_last_kane_line );
			level dialog::remote( str_line );
			str_last_kane_line = str_line;
		}
	}
}

function amws_callout_VO()
{
	level endon( "quad_tank_1_destroyed" );
	
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl3_amws_incoming_0";
	a_str_lines[ 1 ] = "esl4_amws_inbound_grab_s_0";
	a_str_lines[ 2 ] = "esl1_evasives_amws_inbou_0";
	a_str_lines[ 3 ] = "egy2_spotted_enemy_amw_mo_0";
	a_str_lines[ 4 ] = "esl3_eyes_on_hostile_amw_0";
	
	str_last_line = undefined;

	while( 1 )
	{
		level waittill( "amws_callout_vo" );
		
		ai = undefined;
	
		a_ai_1 = spawn_manager::get_ai( "sm_egypt_siegebot" );
		a_ai_2 = spawn_manager::get_ai( "sm_egypt_quadtank" );
		a_ai = ArrayCombine( a_ai_1, a_ai_2, true, false );
		a_ai = array::randomize( a_ai );
		
		for( i = 0; i < a_ai.size; i++ )
		{
			ai = a_ai[i];
			
			if( IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
			{
				break;
			}
		}
		
		str_line = pick_new_line( a_str_lines, str_last_line );
		ai dialog::say( str_line, 2.0 );
		
		str_last_line = str_line;
		wait( RandomFloatRange( 30, 45 ) );
	}
}

function raps_callout_VO()
{
	level endon( "third_quadtank_killed" );

	a_str_lines = [];
	a_str_lines[ 0 ] = "esl1_hostile_raps_moving_0";
	a_str_lines[ 1 ] = "egy2_look_out_raps_inco_0";
	a_str_lines[ 2 ] = "esl3_take_cover_raps_inb_0";
	a_str_lines[ 3 ] = "esl4_hostile_raps_inbound_0";
	a_str_lines[ 4 ] = "esl1_enemy_raps_coming_in_0";
	a_str_lines[ 5 ] = "egy2_hostile_raps_inbound_0";
	a_str_lines[ 6 ] = "esl3_enemy_raps_moving_on_0";
	a_str_lines[ 7 ] = "esl4_hostile_raps_inbound_1";
	a_str_lines[ 8 ] = "esl1_raps_coming_in_find_0";
	a_str_lines[ 9 ] = "egy2_hostile_raps_look_o_0";
	
	a_str_khalil_lines = [];
	a_str_khalil_lines[ 0 ] = "khal_raps_incoming_0";
	a_str_khalil_lines[ 1 ] = "khal_raps_move_0";
	a_str_khalil_lines[ 2 ] = "khal_find_cover_raps_in_0";
	a_str_khalil_lines[ 3 ] = "khal_look_out_raps_0";
	a_str_khalil_lines[ 4 ] = "khal_enemy_raps_inbound_0";
	a_str_khalil_lines[ 5 ] = "khal_heads_up_enemy_rap_0";
	a_str_khalil_lines[ 6 ] = "khal_hostile_raps_inbound_0";
	a_str_khalil_lines[ 7 ] = "khal_enemy_raps_0";
	a_str_khalil_lines[ 8 ] = "khal_raps_moving_in_0";
	a_str_khalil_lines[ 9 ] = "khal_incoming_raps_0";
	
	str_last_line = undefined;
	str_last_khalil_line = undefined;

	while( 1 )
	{
		level waittill( "raps_callout_vo" );
	
		if( math::cointoss() )
		{
			str_line = pick_new_line( a_str_khalil_lines, str_last_khalil_line );
			level.ai_khalil dialog::say( str_line );
			str_last_khalil_line = str_line;
		}
		else
		{
			a_ai_1 = spawn_manager::get_ai( "sm_egypt_siegebot" );
			a_ai_2 = spawn_manager::get_ai( "sm_egypt_quadtank" );
			a_ai = ArrayCombine( a_ai_1, a_ai_2, true, false );
			a_ai = array::randomize( a_ai );
			
			while( 1 )
			{
				ai = array::random( a_ai );
				
				if( !ai util::is_hero() && IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
				{
					break;
				}	
			}
			
			str_line = pick_new_line( a_str_lines, str_last_line );
			ai dialog::say( str_line );
			str_last_line = str_line;
		}
		
		wait( RandomFloatRange( 60, 120 ) );
	}	
}

// Callout that the second quadtank's trophy system is down
// TODO - this is only called on 2nd QT for DPS
function quadtank_trophy_system_down_vo() // self = QT
{
	level endon( "quad_tank_2_destroyed" );
	level endon( "demo_player_controlled_quadtank" );
	//self endon( "trophy_system_enabled" );

	self waittill( "trophy_system_disabled" );
	
	a_str_lines = [];
	a_str_lines[ 0 ] = "hend_system_s_down_hijac_0";
	a_str_lines[ 1 ] = "hend_system_s_down_she_s_0";
	
	wait 1.0;
	
	str_line = array::random( a_str_lines );
	level.ai_hendricks thread dialog::say( str_line );
}

// Triggers during QT2 & QT3 fights 
function quadtank_flavor_vo() // self = QT
{
	level endon( "quad_tank_2_destroyed" );
	level endon( "demo_player_controlled_quadtank" );
	level endon( "third_quadtank_killed" );
	
	a_str_hendricks_lines = [];
	a_str_hendricks_lines[ 0 ] = "hend_focus_fire_on_that_a_0";
	a_str_hendricks_lines[ 1 ] = "hend_finally_a_fair_fight_0";
	a_str_hendricks_lines[ 2 ] = "hend_we_gotta_bring_down_0";
	a_str_hendricks_lines[ 3 ] = "hend_bring_down_that_son_0";
	a_str_hendricks_lines[ 4 ] = "hend_that_quad_s_armed_wi_0";
	a_str_hendricks_lines[ 5 ] = "hend_quad_s_rockets_are_g_0";
	
	a_str_kane_lines = [];
	a_str_kane_lines[ 0 ] = "kane_focus_fire_on_that_a_0";
	a_str_kane_lines[ 1 ] = "kane_take_down_that_artil_0";
	a_str_kane_lines[ 2 ] = "kane_you_gotta_bring_down_0";
	a_str_kane_lines[ 3 ] = "kane_focus_weapon_fire_on_0";
	a_str_kane_lines[ 4 ] = "kane_take_out_that_quad_b_0";
	a_str_kane_lines[ 5 ] = "kane_that_quad_s_rockets_0";
	
	str_last_hendricks_line = undefined;
	str_last_kane_line = undefined;
	
	while( 1 )
	{
		wait 30;
		
		if( math::cointoss() )
		{
			str_line = pick_new_line( a_str_hendricks_lines, str_last_hendricks_line );
			level.ai_hendricks dialog::say( str_line );
			str_last_hendricks_line = str_line;
		}
		else
		{
			str_line = pick_new_line( a_str_kane_lines, str_last_kane_line );
			level dialog::remote( str_line );
			str_last_kane_line = str_line;
		}
	}
}

// Plays on Egyptian AI that move up after the first QT is defeated
function mlrs_defeated_move_up_vo()
{
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl1_go_push_them_back_0";
	a_str_lines[ 1 ] = "egy2_move_up_move_up_0";
	a_str_lines[ 2 ] = "esl3_move_up_take_new_po_0";
	a_str_lines[ 3 ] = "esl4_come_on_push_forwar_0";
	a_str_lines[ 4 ] = "esl1_let_s_move_let_s_mo_0";

	ai = undefined;
	
	wait 2.0;
	
	for( i = 0; i < 2; i++ )
	{
		while( !IsDefined( ai ) )
		{
			a_ai = spawn_manager::get_ai( "sm_egypt_siegebot" );
			ai = array::random( a_ai );
			if( !IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
			{
				ai = undefined;
			}
		}
		str_line = array::random( a_str_lines );
		ArrayRemoveValue( a_str_lines, str_line );
		ai thread dialog::say( str_line );
		wait( RandomFloatRange( 1.0, 2.5 ) );
	}
}

function wasp_callout_VO()
{
	level endon( "third_quadtank_killed" );
	
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl4_enemy_wasps_incoming_0";
	a_str_lines[ 1 ] = "esl3_hostile_wasps_inboun_0";
	a_str_lines[ 2 ] = "egy2_grab_some_cover_was_0";
	a_str_lines[ 3 ] = "esl1_eyes_up_wasps_spot_0";
	a_str_lines[ 4 ] = "esl4_i_got_wasps_moving_i_0";
	
	str_last_line = undefined;

	while( 1 )
	{
		level waittill( "wasp_callout_vo" );
		
		ai = undefined;
	
		a_ai_1 = spawn_manager::get_ai( "sm_egypt_siegebot" );
		a_ai_2 = spawn_manager::get_ai( "sm_egypt_quadtank" );
		a_ai = ArrayCombine( a_ai_1, a_ai_2, true, false );
		a_ai = array::randomize( a_ai );
		
		for( i = 0; i < a_ai.size; i++ )
		{
			ai = a_ai[i];
			
			if( IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
			{
				break;
			}
		}
		
		str_line = pick_new_line( a_str_lines, str_last_line );
		ai dialog::say( str_line );
		
		str_last_line = str_line;
		wait( RandomFloatRange( 60, 120 ) );
	}
}

function rpg_palace_callout_vo()
{
	level endon( "third_quadtank_killed" );
	
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl3_rpg_top_of_the_pala_0";
	a_str_lines[ 1 ] = "esl4_rpg_spotted_top_flo_0";
	
	str_last_line = undefined;
	
	while( 1 )
	{
		level waittill( "rpg_palace_callout_vo" );
		
		a_ai_1 = spawn_manager::get_ai( "sm_egypt_siegebot" );
		a_ai_2 = spawn_manager::get_ai( "sm_egypt_quadtank" );
		a_ai = ArrayCombine( a_ai_1, a_ai_2, true, false );
		ai = undefined;
		
		while( !IsDefined( ai ) )
		{
			ai = array::random( a_ai );
			
			if( !IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
			{
				ai = undefined;
			}	
		}
		
		str_line = pick_new_line( a_str_lines, str_last_line );
		ai dialog::say( str_line, 3.0 );
		str_last_line = str_line;
		
		wait( RandomFloatRange( 60, 120 ) );
	}
}

function rpg_berm_callout_vo()
{
	level endon( "third_quadtank_killed" );
	
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl1_rpg_top_of_the_berm_0";
	a_str_lines[ 1 ] = "egy2_look_out_rpg_on_the_0";
	
	str_last_line = undefined;
	
	while( 1 )
	{
		level waittill( "rpg_berm_callout_vo" );
		
		a_ai_1 = spawn_manager::get_ai( "sm_egypt_siegebot" );
		a_ai_2 = spawn_manager::get_ai( "sm_egypt_quadtank" );
		a_ai = ArrayCombine( a_ai_1, a_ai_2, true, false );
		ai = undefined;
		
		while( !IsDefined( ai ) )
		{
			ai = array::random( a_ai );
			
			if( !IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
			{
				ai = undefined;
			}	
		}
		
		str_line = pick_new_line( a_str_lines, str_last_line );
		ai dialog::say( str_line, 3.0 );
		str_last_line = str_line;
		
		wait( RandomFloatRange( 60, 120 ) );
	}
}

function artillery_quadtank_intro_vo()
{
	// notetrack on v_ram_06_05_safiya_vign_qtcrash_quadtank
	level waittill( "artillery_qt_intro_hendricks_vo_0" );
	
	level.ai_hendricks thread dialog::say( "hend_look_out_we_got_inc_0" );
	
	// notetrack on v_ram_06_05_safiya_vign_qtcrash_quadtank
	level waittill( "artillery_qt_intro_hendricks_vo_1" );
	
	level.ai_hendricks thread dialog::say( "hend_vtol_down_don_t_ha_0" );
	
	// notetrack on v_ram_06_05_safiya_vign_qtcrash_quadtank
	level waittill( "artillery_qt_intro_hendricks_vo_2" );
	
	level.ai_hendricks thread dialog::say( "hend_shit_quad_is_functi_0" );
}

function egyptian_statue_fall_vo( a_ai )
{
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl1_get_outta_there_0";
	a_str_lines[ 1 ] = "egy2_move_move_move_1";
	a_str_lines[ 2 ] = "esl3_scatter_get_outta_t_0";
	a_str_lines[ 3 ] = "esl4_incoming_move_0";
	a_str_lines[ 4 ] = "esl3_scatter_scatter_in_0";
	
	for( i = 0; i < 2; i++ )
	{
		ai = a_ai[i];
		str_line = array::random( a_str_lines );
		ArrayRemoveValue( a_str_lines, str_line );
		if( IsAlive( ai ) )
		{
			ai thread dialog::say( str_line );
			wait( RandomFloatRange( 0.5, 1.5 ) );
		}
	}
}

function statue_fall_vo()
{
	level.ai_hendricks thread dialog::say( "hend_statue_s_coming_down_0", 1.0 );
}

function robot_callout_vo()
{
	level endon( "third_quadtank_killed" );
	
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl4_eyes_on_hostile_gis_0";
	a_str_lines[ 1 ] = "esl3_enemy_grunts_spotted_0";
	a_str_lines[ 2 ] = "egy2_hostile_grunts_movin_0";
	a_str_lines[ 3 ] = "esl1_grunts_spotted_0";
	a_str_lines[ 4 ] = "esl4_i_got_sights_on_host_0";
	
	str_last_line = undefined;
	
	while( 1 )
	{
		level waittill( "robot_callout_vo" );
		
		a_ai_1 = spawn_manager::get_ai( "sm_egypt_siegebot" );
		a_ai_2 = spawn_manager::get_ai( "sm_egypt_quadtank" );
		a_ai = ArrayCombine( a_ai_1, a_ai_2, true, false );
		ai = undefined;
		
		while( !IsDefined( ai ) )
		{
			ai = array::random( a_ai );
			
			if( !IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
			{
				ai = undefined;
			}	
		}
		
		str_line = pick_new_line( a_str_lines, str_last_line );
		ai dialog::say( str_line );
		str_last_line = str_line;
		
		wait( RandomFloatRange( 60, 120 ) );
	}
}

function technical_truck_callout_vo()
{
	level.ai_hendricks thread dialog::say( "esl1_technical_spotted_t_0", 1.0 );	
}

function theater_breach_vo()
{
	wait 2.0;
	
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl3_spotted_hostiles_in_0";
	a_str_lines[ 1 ] = "esl4_hostile_forces_insid_0";
	a_str_lines[ 2 ] = "esl1_they_re_coming_throu_0";

	ai = undefined;
	
	while( !IsDefined( ai ) )
	{
		a_ai = spawn_manager::get_ai( "sm_egypt_siegebot" );
		ai = array::random( a_ai );
		if( !IsAlive(ai) || ( isdefined( ai.is_talking ) && ai.is_talking ) )
		{
			ai = undefined;
		}
	}
	
	str_line = array::random( a_str_lines );
	ai thread dialog::say( str_line );
}

function third_quadtank_spawn_vo( a_ents )
{
	a_ai = GetAITeamArray( "allies" );
	a_ai = ArraySortClosest( a_ai, level.third_quadtank.origin );
	
	ai = undefined;
	
	for( i = 0; i < a_ai.size; i++ )
	{
		ai = a_ai[i];
			
		if( !ai util::is_hero() && IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
		{
			break;
		}
	}
	
	if( IsDefined( ai ) )
	{
		ai thread dialog::say( "egy2_grab_some_cover_the_0", 1.0 );

		wait 1.0;		
	}
	
	level.ai_hendricks dialog::say( "hend_we_ain_t_out_of_this_0" );
	
	wait 2.0;
	
	// ROBOT Phalanx VO
	a_str_lines = [];
	a_str_lines[ 0 ] = "esl1_grunt_company_comin_0";
	a_str_lines[ 1 ] = "egy2_eyes_on_hostile_grun_0";
	a_str_lines[ 2 ] = "esl3_spotted_hostile_grun_0";
	a_str_lines[ 3 ] = "esl4_grab_some_cover_hos_0";
	a_str_lines[ 4 ] = "esl3_gi_company_spotted_a_0";
	
	a_ai = GetAITeamArray( "allies" );
	a_ai = ArraySortClosest( a_ai, level.third_quadtank.origin );
	
	ai = undefined;
	
	for( i = 0; i < a_ai.size; i++ )
	{
		ai = a_ai[i];
			
		if( !ai util::is_hero() && IsAlive(ai) && !( isdefined( ai.is_talking ) && ai.is_talking ) )
		{
			break;
		}
	}
	
	if( IsDefined( ai ) )
	{
		str_line = array::random( a_str_lines );
		ai thread dialog::say( str_line );
	}
}

function pick_new_line( a_str_lines, str_last_line )
{
	a_str_lines = array::randomize( a_str_lines );
	
    for ( i = 0; i < a_str_lines.size; i++ )
    {
    	str_new_line = a_str_lines[ i ];
        
        if ( str_new_line !== str_last_line )
        {
            return str_new_line;    
        }
    }

    return str_last_line;
}

/***********************************
 * CLEANUP
 * ********************************/

function quad_tank_plaza_spawn_manager_cleanup()
{
	spawn_manager::kill( "sm_egypt_plaza_wall" );
	spawn_manager::kill( "sm_egypt_palace_window" );
	spawn_manager::kill( "sm_egypt_quadtank" );
	spawn_manager::kill( "sm_egypt_siegebot" );
	spawn_manager::kill( "sm_nrc_siegebot" );
	spawn_manager::kill( "sm_nrc_quadtank" );
	spawn_manager::kill( "sm_nrc_depth" );
	spawn_manager::kill( "sm_nrc_berm_rpg" );
	spawn_manager::kill( "qt1_nrc_wasp_sm" );
	spawn_manager::kill( "sm_nrc_govt_building_rpg" );
	spawn_manager::kill( "qt1_nrc_amws_sm" );
	spawn_manager::kill( "qt1_nrc_raps_sm" );
	spawn_manager::kill( "qt2_nrc_wasp_sm" );
	spawn_manager::kill( "sm_egypt_statue_fall" );
	spawn_manager::kill( "sm_egypt_theater" );
	spawn_manager::kill( "qt2_nrc_wasp2_berm_sm" );
	spawn_manager::kill( "qt2_nrc_wasp2_palace_sm" );
	spawn_manager::kill( "qt2_nrc_robot_rushers_sm" );
	spawn_manager::kill( "qt2_nrc_raps_sm" );
	spawn_manager::kill( "sm_nrc_qt2_depth" );
	spawn_manager::kill( "nrc_mobile_wall_sm" );
	spawn_manager::kill( "demo_qt2_wasp_sm" );
	spawn_manager::kill( "qt_plaza_controllable_qt_raps_sm" );
	spawn_manager::kill( "nrc_theater_sm" );
	spawn_manager::kill( "sm_nrc_quadtank3_robots" );
	
	a_ai = GetAIArray();
	foreach( ai in a_ai )
	{
		if( !ai util::is_hero() )
		{
			if( IsDefined( level.player_controlled_quadtank ) && ai == level.player_controlled_quadtank )
			{
				continue;	
			}
			
			ai Delete();
		}
	}
}

function quad_tank_plaza_scene_cleanup()
{
	// TODO - ***ADD ALL FX ANIMS***
	a_str_scenes = [];
	a_str_scenes [0] = "cin_ram_05_02_block_nrc_vign_cheering_a";
	a_str_scenes [1] = "cin_ram_05_02_block_nrc_vign_cheering_b";
	a_str_scenes [2] = "cin_ram_05_02_block_nrc_vign_cheering_c";
	a_str_scenes [3] = "cin_ram_05_02_block_nrc_vign_cheering_d";
	a_str_scenes [4] = "cin_ram_05_02_block_nrc_vign_cheering_e";
	a_str_scenes [5] = "cin_ram_05_02_block_nrc_vign_cheering_f";
	a_str_scenes [6] = "cin_ram_07_04_plaza_vign_quaddefeated";
	a_str_scenes [7] = "cin_ram_08_gettofreeway_3rd_pre100";
	a_str_scenes [8] = "cin_ram_08_gettofreeway_vign_start";
	//cin_ram_06_05_safiya_vign_qtcrash_quadtank

	// VTOL IGC scenes
	a_str_scenes [9] = "cin_ram_06_05_safiya_1st_friendlydown";
	a_str_scenes [10] = "cin_ram_06_05_safiya_1st_friendlydown_init";
	a_str_scenes [11] = "cin_ram_06_05_safiya_aie_breakin_pilotshoots";
	a_str_scenes [12] = "cin_ram_06_05_safiya_aie_breakin_02";
	
	// FX ANIMS
	a_str_scenes [13] = "p7_fxanim_cp_ramses_quadtank_statue_bundle";
	a_str_scenes [14] = "p7_fxanim_cp_ramses_quadtank_plaza_building_rocket_bundle";
	
	foreach( str_scene in a_str_scenes )
	{
		if( level scene::is_active( str_scene )  )
		{
			level thread scene::stop( str_scene, true );

			wait 0.1;			
		}	
	}	
}

/***********************************
 * DEV SKIPTO's
 * ********************************/

function statue_fall_test()
{
	wait 5;
	
	IPrintLnBold( "Statue about to fall" );
	
	vh_intro_mlrs_quadtank = spawner::simple_spawn_single( "intro_mlrs_quadtank" );	
	vh_intro_mlrs_quadtank util::magic_bullet_shield();	
	vh_intro_mlrs_quadtank vehicle_ai::start_scripted( true );		

	wait 1;
	
	level thread scene::play( "cin_ram_07_04_plaza_vign_quaddefeated" );
	level thread scene::play( "p7_fxanim_cp_ramses_quadtank_statue_bundle" );
}

function dev_hacked_quadtank_skipto()
{
	ai_artillery_quadtank = spawn_artillery_quadtank( true );
	
	handle_player_controllable_quadtank( ai_artillery_quadtank );
}

/***********************************
 * DEBUG
 * ********************************/
 
