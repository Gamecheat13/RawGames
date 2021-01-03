#using scripts\codescripts\struct;

//Data table (map / checkpoints for tosser system)


function fill_in_values_from_data_table( mapname, checkpoint_name )
{
	if( isdefined(level.tosser_data[ mapname ]) && isdefined(level.tosser_data[ mapname ][ checkpoint_name ]) )
	{
		level.bonuszm_extra_spawns = level.tosser_data[ mapname ][ checkpoint_name ][0];
		level.bonuszm_extra_spawn_gap = level.tosser_data[ mapname ][ checkpoint_name ][1];
		level.bonuszm_max_threshold = level.tosser_data[ mapname ][ checkpoint_name ][2];
		level.bonuszm_max_number_extra_zombies = level.tosser_data[ mapname ][ checkpoint_name ][3];
	
		level.bonuszm_walk_percent = level.tosser_data[ mapname ][ checkpoint_name ][4];
		level.bonuszm_run_percent = level.tosser_data[ mapname ][ checkpoint_name ][5];
		level.bonuszm_sprint_percent = level.tosser_data[ mapname ][ checkpoint_name ][6];
	
		level.bonuszm_lv1_percent = level.tosser_data[ mapname ][ checkpoint_name ][7];
		level.bonuszm_lv2_percent = level.tosser_data[ mapname ][ checkpoint_name ][8];
		level.bonuszm_lv3_percent = level.tosser_data[ mapname ][ checkpoint_name ][9];
		level.bonuszm_lv4_percent = level.tosser_data[ mapname ][ checkpoint_name ][10];
		
		level.bonuszm_zombify_enabled = level.tosser_data[ mapname ][ checkpoint_name ][11];
		level.bonuszm_start_unaware = level.tosser_data[ mapname ][ checkpoint_name ][12];

		level.bonuszm_waittill_name = level.tosser_data[ mapname ][ checkpoint_name ][13];
	}
}

function SetTosserValues( mapname, checkpoint_name, 
                         extra_spawns, extra_spawn_gap, max_threshold, max_number_extra_zombies, 
                         walk_percent, run_percent, sprint_percent, 
                         lv1_percent, lv2_percent, lv3_percent, lv4_percent,
                         zombify_enabled, start_unaware,
						 waittill_name )
{
	level.tosser_data[ mapname ][ checkpoint_name ] = [];
	
	level.tosser_data[ mapname ][ checkpoint_name ][0] = extra_spawns;
	level.tosser_data[ mapname ][ checkpoint_name ][1] = extra_spawn_gap;
	level.tosser_data[ mapname ][ checkpoint_name ][2] = max_threshold;
	level.tosser_data[ mapname ][ checkpoint_name ][3] = max_number_extra_zombies;
	
	level.tosser_data[ mapname ][ checkpoint_name ][4] = walk_percent;
	level.tosser_data[ mapname ][ checkpoint_name ][5] = run_percent;
	level.tosser_data[ mapname ][ checkpoint_name ][6] = sprint_percent;
	
	level.tosser_data[ mapname ][ checkpoint_name ][7] = lv1_percent;
	level.tosser_data[ mapname ][ checkpoint_name ][8] = lv2_percent;
	level.tosser_data[ mapname ][ checkpoint_name ][9] = lv3_percent;
	level.tosser_data[ mapname ][ checkpoint_name ][10] = lv4_percent;
	
	level.tosser_data[ mapname ][ checkpoint_name ][11] = zombify_enabled;
	level.tosser_data[ mapname ][ checkpoint_name ][12] = start_unaware;

	level.tosser_data[ mapname ][ checkpoint_name ][13] = waittill_name;
}

function init()
{
	//PROLOGUE
	level.tosser_data[ "cp_mi_eth_prologue" ] = [];
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_air_traffic_controller",		0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_nrc_knocking",					0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_blend_in",						10, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 0,	"tower_doors_open" );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_take_out_guards",				5, 1, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );

	SetTosserValues( "cp_mi_eth_prologue",		"skipto_security_camera",				0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_hostage_1",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_security_desk",					0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_lift_escape",					0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_intro_cyber_soldiers",			1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );

	SetTosserValues( "cp_mi_eth_prologue",		"skipto_hangar",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_vtol_collapse",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_jeep_alley",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_bridge_battle",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_dark_battle",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_vtol_tackle",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_robot_horde",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );

	SetTosserValues( "cp_mi_eth_prologue",		"skipto_get_door_open",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_apc",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_robot_defend",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_sky_hook",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_get_to_truck",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_eth_prologue",		"skipto_prologue_ending",				1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	
	//SGEN
	level.tosser_data[ "cp_mi_sing_sgen" ] = [];
	SetTosserValues( "cp_mi_sing_sgen",			"intro",								2, 2, 30, 1000, 	80, 10, 10, 	40, 20, 10, 30, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"enter_sgen",							2, 2, 30, 1000, 	80, 10, 10, 	40, 20, 10, 30, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"qtank_fight",							2, 2, 30, 1000, 	80, 10, 10, 	40, 20, 10, 30, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"enter_lobby",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	
	SetTosserValues( "cp_mi_sing_sgen",			"discover_data",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"follow_leader1",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"gen_lab",								0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"follow_leader2",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"chem_lab",								0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"follow_leader3",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"silo_floor",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"under_silo",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	
	SetTosserValues( "cp_mi_sing_sgen",			"fallen_soldiers",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"testing_lab_igc",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"dark_battle",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"charging_station",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	
	SetTosserValues( "cp_mi_sing_sgen",			"descent",								0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"pallas_start",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"pallas_end",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"twin_revenge",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	
	SetTosserValues( "cp_mi_sing_sgen",			"flood_combat",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"underwater_battle",					0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"underwater_rail",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_sing_sgen",			"silo_swim",							0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	
	//LOTUS
	level.tosser_data[ "cp_mi_cairo_lotus" ] = [];
	// Events 1 - 9
	SetTosserValues( "cp_mi_cairo_lotus",		"plan_b",								3, 2, 30, 1000, 	80, 10, 10, 	70, 20, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"start_the_riots",						2, 1, 30, 1000, 	80, 10, 10, 	70, 20, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"general_hakim",						1, 2, 30, 1000, 	80, 10, 10, 	70, 20, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"apartments",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"atrium_battle",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"to_security_station",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"hack_the_system",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"prometheus_otr",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"vtol_hallway",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"mobile_shop_ride2",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"to_detention_center3",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"to_detention_center4",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"detention_center",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"stand_down",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"pursuit",								1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	// Events 10 - 16
	SetTosserValues( "cp_mi_cairo_lotus",		"sky_bridge",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"tower_2_ascent",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"minigun_platform",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"platform_fall",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10,		1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"hunter",								1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10,		1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"prometheus_intro",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"boss_battle",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus",		"old_friend",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );	


	//LOTUS2
	level.tosser_data[ "cp_mi_cairo_lotus2" ] = [];
	// Events 6 - 10
	SetTosserValues( "cp_mi_cairo_lotus2",		"prometheus_otr",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"vtol_hallway",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"mobile_shop_ride2",					1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"bridge_battle",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"up_to_detention_center",				1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"detention_center",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"stand_down",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"pursuit",								0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"industrial_zone",						0, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"sky_bridge1", 							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"sky_bridge2",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );	
	// Events 11 - 17
	SetTosserValues( "cp_mi_cairo_lotus2",		"tower_2_ascent", 						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"prometheus_intro",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"boss_battle", 							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus2",		"old_friend", 							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );

	//LOTUS3
	level.tosser_data[ "cp_mi_cairo_lotus3" ] = [];
	// Events 6 - 10
	SetTosserValues( "cp_mi_cairo_lotus3",		"tower_2_ascent",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus3",		"prometheus_intro",						1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus3",		"boss_battle",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );
	SetTosserValues( "cp_mi_cairo_lotus3",		"old_friend",							1, 2, 30, 1000, 	80, 10, 10, 	60, 20, 10, 10, 	1, 1 );

	//RAMSES
	level.tosser_data[ "cp_mi_cairo_ramses" ] = [];
	// Events 1 - 5
	SetTosserValues( "cp_mi_cairo_ramses",		"level_start",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses",		"rs_walk_through",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses",		"interview_dr_nasser",					1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses",		"defend_ramses_station",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses",		"vtol_ride",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );

	//RAMSES2
	level.tosser_data[ "cp_mi_cairo_ramses2" ] = [];
	// Events 6 - 10
	SetTosserValues( "cp_mi_cairo_ramses2",		"area_defend_intro",					1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses2",		"area_defend",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses2",		"alley",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses2",		"vtol_igc",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses2",		"quad_tank_plaza",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	
	//RAMSES3
	level.tosser_data[ "cp_mi_cairo_ramses3" ] = [];
	// Events 11 - 14
	SetTosserValues( "cp_mi_cairo_ramses3",		"subway",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses3",		"freeway_battle",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses3",		"freeway_collapse",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_ramses3",		"dead_event",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );

	//INFECTION
	level.tosser_data[ "cp_mi_cairo_infection" ] = [];
	// Events 1 - 3
	SetTosserValues( "cp_mi_cairo_infection",	"vtol_arrival",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection",	"sarah_battle",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection",	"sarah_battle_end",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );

	//INFECTION2
	level.tosser_data[ "cp_mi_cairo_infection2" ] = [];
	// Events 4 - 15
	SetTosserValues( "cp_mi_cairo_infection2",	"sgen_server_room",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,  	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"forest_intro",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"forest",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"forest_surreal",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"forest_wolves",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"black_station",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"village",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"village_house",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"village_inception",					1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"church",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"cathedral",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_infection2",	"underwater",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
		
	//INFECTION3
	level.tosser_data[ "cp_mi_cairo_infection3" ] = [];
	// Events 16 - 22
	SetTosserValues( "cp_mi_cairo_infection3",	"hideout",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection3",	"interrogation",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_infection3",	"city_barren",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_infection3",	"city",									1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_infection3",	"city_tree",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_cairo_infection3",	"city_nuked",							1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_infection3",	"outro",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );


	//BIO_DOMES
	level.tosser_data[ "cp_mi_sing_biodomes" ] = [];
	// Events 1 - 9
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_igc",						0, 3, 10, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	0, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_markets_start",				1, 3, 10, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	0, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_markets_rpg",				1, 2, 15, 1000, 	40, 50, 10, 	60, 30, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_markets2_start",				0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_wherehouse",					1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_cloudmountain",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_turret_hallway",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_xulan_vignette",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_server_room_defend",			1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes",		"objective_fighttothedome",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	
	//BIO_DOMES2
	level.tosser_data[ "cp_mi_sing_biodomes2" ] = [];
	// Events 9 - 13
	SetTosserValues( "cp_mi_sing_biodomes2",	"objective_decend",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes2",	"objective_supertrees",					1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes2",	"objective_dive",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_biodomes2",	"objective_swamp",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	
	//BLACKSTATION
	level.tosser_data[ "cp_mi_sing_blackstation" ] = [];
	// Events 1 - 13
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_igc",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_qzone",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_warlord_igc",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_warlord",					1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_anchor_intro",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_port_assault",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_barge_assault",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_storm_surge",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_subway",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_comm_relay_traverse",		1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_comm_relay",					1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_cross_debris",				1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_blackstation_exterior",		1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_blackstation",	"objective_blackstation_interior",		1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );

	//NEW WORLD
	level.tosser_data[ "cp_mi_zurich_newworld" ] = [];
	// Events 1 - 25
	SetTosserValues( "cp_mi_zurich_newworld",	"white_infinite_igc",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"pallas_igc",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"factory_exterior",						1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"alley",								1, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"warehouse",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"foundry",								3, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"vat_room",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"chase",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"bridge_collapse_igc",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"rooftops",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"construction_site",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"glass_ceiling_igc",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"pinned_down_igc",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"subway",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"crossroads",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"construction",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"maintenance",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"water_plant",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"staging_room_igc",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"inbound_igc",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"train",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"train_rooftop",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"detach_bomb_igc",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_zurich_newworld",	"waking_up_igc",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	
	//VENGANCE
	level.tosser_data[ "cp_mi_sing_vengeance" ] = [];
	// Events 1 - 25
	SetTosserValues( "cp_mi_sing_vengeance",	"intro",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"civilian_rescue",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"clotheslines",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"takedown",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"killing_streets",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"dogleg_1",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"quadtank_alley",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"dogleg_2",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"garage",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"quad_battle",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"safehouse_plaza",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"safehouse_interior",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_sing_vengeance",	"panic_room",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );


	//AQUIFER
	level.tosser_data[ "cp_mi_cairo_aquifer" ] = [];
	// Events 1 - 25
	SetTosserValues( "cp_mi_cairo_aquifer",		"level_long_fly_in",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"post_intro",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"destroy_defenses",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"hack_terminals",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"destroy_defenses2",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"hack_terminals2",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"destroy_defenses3",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"hack_terminals3",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"breach_hangar",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"post_breach",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"sniper_boss",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"hideout",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_cairo_aquifer",		"exfil",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );

	//ZURICH
	level.tosser_data[ "cp_mi_zurich_coalescence" ] = [];
	// Events 1 - 25
	SetTosserValues( "cp_mi_zurich_coalescence",	"zurich",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_zurich_coalescence",	"clearing",							0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,	 	1, 1 );
	SetTosserValues( "cp_mi_zurich_coalescence",	"root_zurich",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_coalescence",	"root_cairo",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_coalescence",	"root_singapore",					0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
	SetTosserValues( "cp_mi_zurich_coalescence",	"nest",								0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0,		1, 1 );
	SetTosserValues( "cp_mi_zurich_coalescence",	"zurich_outro",						0, 2, 30, 1000, 	80, 10, 10, 	80, 10, 10, 0, 		1, 1 );
		
}
