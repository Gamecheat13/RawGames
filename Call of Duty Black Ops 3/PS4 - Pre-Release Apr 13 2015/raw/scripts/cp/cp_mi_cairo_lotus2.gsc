#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;

#using scripts\cp\gametypes\_save;

#using scripts\cp\_ammo_cache;
#using scripts\cp\_elevator;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\cp_mi_cairo_lotus2_fx;
#using scripts\cp\cp_mi_cairo_lotus2_sound;
#using scripts\cp\lotus_detention_center;
#using scripts\cp\lotus_pursuit;
#using scripts\cp\lotus_security_station;
#using scripts\cp\lotus_sky_bridge;

#using scripts\cp\voice\voice_lotus2;

 	               	                    

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "fx", "explosions/fx_exp_lt_moving_shop_fall" );

function main()
{
	savegame::set_mission_name("lotus");
	init_clientfields();
	init_variables();
	setup_skiptos();
	
	voice_lotus2::init_voice();
	
	callback::on_spawned( &on_player_spawned );
	
	cp_mi_cairo_lotus2_fx::main();
	cp_mi_cairo_lotus2_sound::main();
	
	lotus_detention_center::init();
	
	load::main();
	
	skipto::set_skip_safehouse();
}

function init_clientfields()
{
	clientfield::register( "toplayer", "sand_fx", 1, 1, "int" );
}

function init_variables()
{	
	// only global level variables should be place here
	level.overrideAmmoDropTeam3 = true;
}

// self == player
function on_player_spawned()
{
}

//*****************************************************************************
// SKIPTOS
//*****************************************************************************
function setup_skiptos()
{	
	// Events 6 - 10
	skipto::add( "prometheus_otr",			&lotus_security_station::prometheus_otr_main,			"Prometheus OTR",				&lotus_security_station::prometheus_otr_done );
	skipto::add( "vtol_hallway",			&lotus_detention_center::vtol_hallway_main,				"VTOL Hallway",					&lotus_detention_center::vtol_hallway_done );
	skipto::add( "mobile_shop_ride2",		&lotus_detention_center::mobile_shop_ride2_main,		"Mobile Shop Ride 2",			&lotus_detention_center::mobile_shop_ride2_done );
	skipto::add( "bridge_battle",			&lotus_detention_center::bridge_battle_main,			"Get to the Detention Center",	&lotus_detention_center::bridge_battle_done );
	skipto::add( "up_to_detention_center",	&lotus_detention_center::up_to_detention_center_main,	"Get to the Detention Center",	&lotus_detention_center::up_to_detention_center_done );
	skipto::add( "detention_center",		&lotus_detention_center::detention_center_main,			"Detention Center",				&lotus_detention_center::detention_center_done );
	skipto::add( "stand_down", 				&lotus_pursuit::stand_down_main,						"Stand Down",					&lotus_pursuit::stand_down_done );
	skipto::add( "pursuit", 				&lotus_pursuit::main,									"Pursuit",						&lotus_pursuit::pursuit_done );
	skipto::add( "industrial_zone",			&lotus_sky_bridge::industrial_zone_main,				"Industrial Zone",				&lotus_sky_bridge::industrial_zone_done );
	skipto::add( "sky_bridge1", 			&lotus_sky_bridge::sky_bridge1_main,					"Sky Bridge1",					&lotus_sky_bridge::sky_bridge1_done );
	skipto::add( "sky_bridge2", 			&lotus_sky_bridge::sky_bridge2_main,					"Sky Bridge2",					&lotus_sky_bridge::sky_bridge2_done );	
	
	// Events 11 - 17
	skipto::add( "tower_2_ascent", 			&skipto_lotus_3 );
	skipto::add( "prometheus_intro",		&skipto_lotus_3 );
	skipto::add( "boss_battle", 			&skipto_lotus_3 );
	skipto::add( "old_friend", 				&skipto_lotus_3 );
	
	/#
	skipto::add_billboard( "prometheus_otr", "6. Prometheus OTR", "Pacing/OTR", "Short", "Alpha" );
	skipto::add_billboard( "vtol_hallway", "7. VTOL Hallway", "Combat", "Long", "Alpha" );
	skipto::add_billboard( "mobile_shop_ride2", "7. Mobile Shop Ride 2", "Combat", "Long", "Alpha" );
	skipto::add_billboard( "bridge_battle", "7. Bridge Battle", "Combat", "Long", "Alpha" );
	skipto::add_billboard( "up_to_detention_center", "7. Up to Detention Center", "Combat", "Long", "Alpha" );
	skipto::add_billboard( "detention_center", "7. Detention Center", "Combat", "Short", "Alpha" );
	skipto::add_billboard( "stand_down", "8. Stand Down", "IGC", "Short", "Alpha" );
	skipto::add_billboard( "pursuit", "9. Pursuit", "Combat", "Medium", "Alpha" );
	skipto::add_billboard( "industrial_zone", "10. Industrial Zone", "Combat", "Short", "Alpha" );
	skipto::add_billboard( "sky_bridge1", "10. Sky Bridge", "Combat", "Long", "Alpha" );
	skipto::add_billboard( "sky_bridge2", "10. Sky Bridge", "Combat", "Long", "Alpha" );
	#/
}

function skipto_lotus_3( str_objective, b_starting )
{	
	SwitchMap_Load( "cp_mi_cairo_lotus3" );
	
	wait 0.05;
	
	SwitchMap_Switch();
}
