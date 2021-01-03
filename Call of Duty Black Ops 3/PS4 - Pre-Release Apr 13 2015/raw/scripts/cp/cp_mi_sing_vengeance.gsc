#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\cp\_oed;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_ammo_cache;
#using scripts\cp\_util;
#using scripts\cp\_skipto;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\cp\_objectives;
#using scripts\shared\vehicles\_hunter;
#using scripts\shared\vehicles\_quadtank;
#using scripts\shared\stealth;
#using scripts\shared\stealth_interact;

#using scripts\cp\cp_mi_sing_vengeance_fx;
#using scripts\cp\cp_mi_sing_vengeance_sound;
#using scripts\cp\cp_mi_sing_vengeance_util;
#using scripts\cp\cp_mi_sing_vengeance_intro;
#using scripts\cp\cp_mi_sing_vengeance_killing_streets;
#using scripts\cp\cp_mi_sing_vengeance_dogleg_1;
#using scripts\cp\cp_mi_sing_vengeance_quadtank_alley;
#using scripts\cp\cp_mi_sing_vengeance_temple;
#using scripts\cp\cp_mi_sing_vengeance_dogleg_2;
#using scripts\cp\cp_mi_sing_vengeance_garage;
#using scripts\cp\cp_mi_sing_vengeance_market;
#using scripts\cp\cp_mi_sing_vengeance_safehouse;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#precache( "objective", "cp_level_vengeance_temp" );

#precache( "objective", "cp_standard_follow_breadcrumb" );
#precache( "objective", "cp_standard_breadcrumb" );
#precache( "objective", "obj_follow" );

//civilian_rescue objective
//#precache( "objective", "obj_civilian_rescue" );

//takedown objective
//#precache( "objective", "obj_takedown" );

//hide_tutorial objective
#precache( "objective", "obj_hide_tutorial" );

//arena street objective
#precache( "objective", "obj_arena_street" );

//dogleg 1 objective
#precache( "objective", "obj_dogleg_1" );

//kill and hack jammer objective
#precache( "objective", "module_hackjammer_xy" );
#precache( "objective", "module_hackjammer_ent" );
#precache( "model", "p7_proto_backpack_red" );
#precache( "objective", "regroup_radio_contact" );

//rescue police objective
#precache( "objective", "cp_level_vengeance_police_rescue" );
#precache( "objective", "cp_level_vengeance_police_rescue_waypoint" );

//models
#precache( "model", "p7_ball_rubber_gym_01" );

//strings
#precache( "string", "CP_MI_SING_VENGEANCE_TAKEDOWN_OBJ_TRIGGER" );
#precache( "string", "CP_MI_SING_VENGEANCE_HIDE" );
#precache( "string", "CP_MI_SING_VENGEANCE_HIDE_ACTIONS" );
#precache( "string", "CP_MI_SING_VENGEANCE_RESCUE_POLICE_TRIGGER" );
#precache( "string", "CP_MI_SING_VENGEANCE_RESCUE_POLICE_OBJECTIVE" );
#precache( "string", "CP_MI_SING_VENGEANCE_RESCUE_POLICE_WAYPOINT" );
#precache( "string", "CP_MI_SING_VENGEANCE_WHISTLE" );
#precache( "string", "CP_MI_SING_VENGEANCE_HACK_JAMMER" );

function main()
{
	precache();
	init_flags();
	setup_skiptos();
	
	cp_mi_sing_vengeance_fx::main();
	cp_mi_sing_vengeance_sound::main();
	
	load::main();
	
	vengeance_util::fire_fx();

	//stealth_interact::hide_spot_setup( "hide_spot_use_trigger", "targetname" );
	
	//stealth_interact::whistle_setup( "whistle_trigger", "targetname" );
	
//	vengeance_market::quad_battle_glass_hide();
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function init_flags()
{
	//intro flags
	level flag::init( "intro_wall_done" );
	
	//civilian_rescue flags
	level flag::init( "civilian_rescue_begin" );
	level flag::init( "civilian_rescue_enemies_dead" );
	level flag::init( "civilian_rescue_enemies_alerted" );
	level flag::init( "civilian_rescue_on_three" );
	level flag::init( "hendricks_civilian_rescue_scene_complete" );
	level flag::init( "civilian_rescue_complete" );
	
	//clotheslines flags
	level flag::init( "clotheslines_begin" );
	level flag::init( "apartment_building2_exit_doors_open" );
	level flag::init( "hendricks_at_clotheslines_moment" );
	
	//takedown flags
	level flag::init( "takedown_begin" );
	level flag::init( "takedown_moment_get_in_place" );
	level flag::init( "all_players_ready_for_takedown" );
	level flag::init( "takedown_complete" );
	
	//hide tutorial flags
	level flag::init( "hide_tutorial_begin" );
	level flag::init( "hide_spot_enter_allowed" );
	level flag::init( "all_players_hiding" );
	level flag::init( "hendricks_hide_tutorial_target_in_position" );
	level flag::init( "hendricks_has_hide_tutorial_target" );
	level flag::init( "hide_tutorial_enemies_dead" );
	level flag::init( "hide_spot_exit_allowed" );
	level flag::init( "hide_tutorial_complete" );
	
	//killing streets flags
	level flag::init( "killing_streets_intro_patroller_spawners_cleared" );
	level flag::init( "killing_streets_lineup_civilian_spawners_cleared" );
	level flag::init( "killing_streets_lineup_patroller_spawners_cleared" );
	level flag::init( "cin_ven_03_20_storelineup_vign_fire_done" );
	level flag::init( "killing_streets_lineup_patrollers_alerted" );
	
	//cafe vignettes
	level flag::init( "cafe_execution_thug_dead" );
	level flag::init( "cafe_molotov_thugs_alerted" );
	level flag::init( "cafe_burning_match_thrown" );
	
	//streets
	level flag::init( "enable_arena_street_end_trigger" );
	level flag::init( "streets_begin" );
	level flag::init( "hendricks_out" );
	
    level flag::init( "enemy_dead" );
    level flag::init( "jammers_hacked" );
    
    //DOGLEG 2 FLAGS
    level flag::init( "dogleg_2_enemies_cleared" );
    
    //GARAGE ARENA FLAGS
    level flag::init( "garage_igc_done" );
    level flag::init( "hendricks_at_market" );
    level flag::init( "players_at_market" );
    level flag::init( "entering_market" );
    level flag::init( "players_in_market" );

	//QUAD TANK BATTLE FLAGS    
	level flag::init( "quad_battle_starts" );   
	level flag::init( "quad_battle_ends" );	
	level flag::init( "hendricks_exiting_market" );
	level flag::init( "players_exiting_market" );
	level flag::init( "exiting_market" );
	level flag::init( "hendricks_at_plaza" );
	level flag::init( "players_at_plaza" );
	
	//PLAZA COMBAT FLAGS
	level flag::init( "plaza_cleared" );
}

function setup_skiptos()
{
	skipto::add( "intro",					&vengeance_intro::skipto_intro_init, 						"Intro",					&vengeance_intro::skipto_intro_done );
	skipto::add( "civilian_rescue",			&vengeance_intro::skipto_civilian_rescue_init, 				"Civilian Rescue",			&vengeance_intro::skipto_civilian_rescue_done );
	skipto::add( "clotheslines",			&vengeance_intro::skipto_clotheslines_init, 				"Clotheslines",				&vengeance_intro::skipto_clotheslines_done );
	skipto::add( "takedown",				&vengeance_intro::skipto_takedown_init, 					"Takedown",					&vengeance_intro::skipto_takedown_done );
	skipto::add( "killing_streets",			&vengeance_killing_streets::skipto_killing_streets_init,	"Killing Streets",			&vengeance_killing_streets::skipto_killing_streets_done );
	skipto::add( "dogleg_1",				&vengeance_dogleg_1::skipto_dogleg_1_init, 					"Dogleg 1",					&vengeance_dogleg_1::skipto_dogleg_1_done );
	skipto::add( "quadtank_alley",			&vengeance_quadtank_alley::skipto_quadtank_alley_init, 		"Quadtank Alley",			&vengeance_quadtank_alley::skipto_quadtank_alley_done );
	skipto::add( "temple",					&vengeance_temple::skipto_temple_init, 						"Temple Arena",				&vengeance_temple::skipto_temple_done );
	skipto::add( "dogleg_2",				&vengeance_dogleg_2::skipto_dogleg_2_init, 					"Dogleg 2",					&vengeance_dogleg_2::skipto_dogleg_2_done );
	skipto::add( "garage",					&vengeance_garage::skipto_garage_init, 						"Parking Garage Arena",		&vengeance_garage::skipto_garage_done );
	skipto::add( "quad_battle",				&vengeance_market::skipto_quad_init, 						"Quad Tank Battle",			&vengeance_market::skipto_quad_done );
	skipto::add( "safehouse_plaza",			&vengeance_market::skipto_plaza_init, 						"Plaza Combat",				&vengeance_market::skipto_plaza_done );
	skipto::add( "safehouse_interior",		&vengeance_safehouse::skipto_safe_int_init,					"Safehouse Interior",		&vengeance_safehouse::skipto_safe_int_done );
	skipto::add( "panic_room",				&vengeance_safehouse::skipto_panic_init, 					"Panic Room Scene",			&vengeance_safehouse::skipto_panic_done );
	
	level.skipto_triggers = [];
	a_trigs = GetEntArray( "objective", "targetname" );
	foreach( trig in a_trigs )
	{
		if ( isdefined( trig.script_objective ) )
		{
			level.skipto_triggers[ trig.script_objective ] = trig;
		}
	}
}

