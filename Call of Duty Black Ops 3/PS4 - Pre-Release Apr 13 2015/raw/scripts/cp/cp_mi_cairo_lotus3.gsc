#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;

#using scripts\cp\gametypes\_save;

#using scripts\cp\_ammo_cache;
#using scripts\cp\_elevator;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\cp_mi_cairo_lotus3_fx;
#using scripts\cp\cp_mi_cairo_lotus3_sound;
#using scripts\cp\lotus_boss_battle;
#using scripts\cp\lotus_t2_ascent;

#using scripts\cp\voice\voice_lotus3;

 	               	                    

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "fx", "explosions/fx_exp_lt_moving_shop_fall" );

#precache( "fx", "fire/fx_fire_ai_human_arm_left_loop" );
#precache( "fx", "fire/fx_fire_ai_human_arm_left_os" );
#precache( "fx", "fire/fx_fire_ai_human_arm_right_loop" );
#precache( "fx", "fire/fx_fire_ai_human_arm_right_os" );
#precache( "fx", "fire/fx_fire_ai_human_head_loop" );
#precache( "fx", "fire/fx_fire_ai_human_head_os" );
#precache( "fx", "fire/fx_fire_ai_human_leg_left_loop" );
#precache( "fx", "fire/fx_fire_ai_human_leg_left_os" );
#precache( "fx", "fire/fx_fire_ai_human_leg_right_loop" );
#precache( "fx", "fire/fx_fire_ai_human_leg_right_os" );
#precache( "fx", "fire/fx_fire_ai_human_torso_loop" );
#precache( "fx", "fire/fx_fire_ai_human_torso_os" );

#precache( "fx", "fire/fx_fire_ai_robot_arm_left_loop" );
#precache( "fx", "fire/fx_fire_ai_robot_arm_left_os" );
#precache( "fx", "fire/fx_fire_ai_robot_arm_right_loop" );
#precache( "fx", "fire/fx_fire_ai_robot_arm_right_os" );
#precache( "fx", "fire/fx_fire_ai_robot_head_loop" );
#precache( "fx", "fire/fx_fire_ai_robot_head_os" );
#precache( "fx", "fire/fx_fire_ai_robot_leg_left_loop" );
#precache( "fx", "fire/fx_fire_ai_robot_leg_left_os" );
#precache( "fx", "fire/fx_fire_ai_robot_leg_right_loop" );
#precache( "fx", "fire/fx_fire_ai_robot_leg_right_os" );
#precache( "fx", "fire/fx_fire_ai_robot_torso_loop" );
#precache( "fx", "fire/fx_fire_ai_robot_torso_os" );

#precache( "fx", "zombie/fx_meatball_trail_zmb" );

function main()
{
	savegame::set_mission_name("lotus");
	init_clientfields();
	init_variables();
	setup_skiptos();
	
	voice_lotus3::init_voice();
	
	callback::on_spawned( &on_player_spawned );
	
	cp_mi_cairo_lotus3_fx::main();
	cp_mi_cairo_lotus3_sound::main();
	
	load::main();
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
	self thread player_sand_fx();
}

// self == player
function player_sand_fx()
{
	level flag::wait_till( "boss_battle" );
	self clientfield::set_to_player( "sand_fx", 1 );
	
	level flag::wait_till( "old_friend" );
	self clientfield::set_to_player( "sand_fx", 0 );
}

//*****************************************************************************
// SKIPTOS
//*****************************************************************************
function setup_skiptos()
{	
	skipto::add( "tower_2_ascent", 		&lotus_t2_ascent::tower_2_ascent_main,		"Tower 2 Ascent",		&lotus_t2_ascent::tower_2_ascent_done );
	skipto::add( "prometheus_intro",	&lotus_boss_battle::prometheus_intro_main,	"Prometheus Intro",		&lotus_boss_battle::prometheus_intro_done );
	skipto::add( "boss_battle", 		&lotus_boss_battle::boss_battle_main,		"Prometheus Battle",	&lotus_boss_battle::boss_battle_done );
	skipto::add( "old_friend", 			&lotus_boss_battle::old_friend_main,		"Old Friend",			&lotus_boss_battle::old_friend_done );
	
	/#
	skipto::add_billboard( "tower_2_ascent", "11. Tower 2 Ascent", "Combat", "Long", "Alpha" );
	skipto::add_billboard( "prometheus_intro", "15. Prometheus Intro", "IGC", "Short", "Alpha" );
	skipto::add_billboard( "boss_battle", "16. Prometheus Battle", "Combat", "Short", "Alpha" );
	skipto::add_billboard( "old_friend", "17. Old Friend", "IGC", "Short", "Alpha" );
	#/
}
