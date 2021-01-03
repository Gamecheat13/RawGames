#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\animation_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;
#using scripts\cp\_debug;
#using scripts\shared\stealth;
#using scripts\shared\stealth_status;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_dogleg_2;

function skipto_dogleg_2_init( str_objective, b_starting )
{	
	if ( b_starting )
	{
		vengeance_util::skipto_baseline( str_objective, b_starting );
		
		level flag::wait_till( "all_players_spawned" );
	}
	
	//Spawning a new Hendricks since the original is deleted earlier in the level.
	vengeance_util::init_hero( "hendricks", str_objective );
	level.ai_hendricks.goalradius = 32;
	
	dogleg_2_main( str_objective );
}

function skipto_dogleg_2_done( str_objective, b_starting, b_direct, player )
{

}

function dogleg_2_main( str_objective )
{
	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	
	level thread dogleg_2_temp_info_screen();
	level thread dogleg_2_vo();
	level thread dogleg_2_bg_scream();
	level thread dogleg_2_civ_shot();
	level thread dogleg_2_enemies();
	
	e_end_trigger = getent( "dogleg_2_door_trigger", "targetname" );
	e_end_trigger MakeUnusable();
	s_obj_target = struct::get( e_end_trigger.target, "targetname" );
	
	level flag::wait_till( "dogleg_2_enemies_cleared" );
	level.ai_hendricks stealth::init();
	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	
	wait 1.25;
	objectives::set( "cp_level_vengeance_finish_dogleg_2", s_obj_target );
	e_end_trigger MakeUsable();
	
	trigger::wait_till( "dogleg_2_door_trigger" );
	
	objectives::complete( "cp_level_vengeance_finish_dogleg_2" );
	
	skipto::objective_completed( "dogleg_2" );
}

function dogleg_2_temp_info_screen()
{
	text_array = [];
	text_array[ 0 ] = "Players move through a short series";
	text_array[ 1 ] = "of building hallways and rooms.";
	text_array[ 2 ] = "This cooldown section will have 1-2 horrific";
	text_array[ 3 ] = "54i moments.";
	
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, false );
}

function dogleg_2_vo()
{
	wait 1;
	
	//Kayne (radio)– Hendricks, do you copy?  We’re falling back to the panic room, 54i have breached the building.
 	level dialog::remote( "kane_hendricks_do_you_co_0" );
	
	//Hendricks: Copy, we’re almost there.
	level.ai_hendricks dialog::say( "hend_copy_we_re_almost_t_0" );
	
	level flag::wait_till( "dogleg_2_enemies_cleared" );
	wait 1.25;
	//Hendricks: Check that balcony.
	level.ai_hendricks dialog::say( "hend_check_that_balcony_0" );	
}

function dogleg_2_bg_scream()
{
	trigger::wait_till( "dogleg_2_civ_scream" );
	
	level.ai_dl2_civ = spawner::simple_spawn_single( "dogleg_2_civilian_01" );
	level.ai_dl2_civ ai::set_ignoreme( true );
	level.ai_dl2_civ ai::set_ignoreall( true );
	level.ai_dl2_civ util::magic_bullet_shield();	
	
	//54i: I said on your knees!
	level.ai_dl2_civ dialog::say( "ffim1_i_said_on_your_knees_0" );
	
	//Civilian: Please, no!
	level.ai_dl2_civ dialog::say( "civi_please_no_0" );
}

function dogleg_2_civ_shot()
{
	s_anim_spot = struct::get( "dogleg_2_civ_anim_start", "targetname" );
	
	trigger::wait_till( "dogleg_2_civ_death" );
	
	a_guys = [];
	a_guys[ 0 ] = level.ai_dl2_civ;
	
	s_anim_spot thread scene::play( "cin_ven_dogleg_2_civ_killed", level.ai_dl2_civ );
	
	level.ai_dl2_civ waittill( "footstep_left_small" ); //notetrack in animation.
	wait .25;
	
	MagicBullet( level.ai_dl2_killer.weapon, s_anim_spot.origin + ( 0, 0, 40 ), level.ai_dl2_civ.origin + ( 0, 0, 60 ));
		
	level.ai_dl2_civ util::stop_magic_bullet_shield();	
	level.ai_dl2_civ kill();
}

function dogleg_2_enemies()
{
	trigger::wait_till( "dogleg_2_civ_death" );
	
	level.ai_dl2_killer = spawner::simple_spawn_single( "dogleg_2_civ_killer" );
	level.ai_dl2_killer ai::set_ignoreme( true );
	level.ai_dl2_killer ai::set_ignoreall( true );
	level.ai_dl2_killer stealth::stop();
	
	wait .75;
	
	level.ai_dl2_killer ai::set_ignoreme( false );
	level.ai_dl2_killer ai::set_ignoreall( false );
	
	e_node = GetNode( "civ_killer_node_01", "targetname" );
	level.ai_dl2_killer setgoalnode( e_node, true );
	
	e_manager = getent( "dogleg_2_spawn_manager", "targetname" );
	spawner::add_spawn_function_group( e_manager.target, "targetname", &no_stealth );
	
	spawn_manager::enable( "dogleg_2_spawn_manager" );
	
	trigger::use( "dogleg_2_move_to_apt", "targetname" ); //moves Hendricks
	level.ai_hendricks thread no_stealth();
	level.ai_hendricks ai::set_behavior_attribute( "cqb", false );
	
	spawn_manager::wait_till_cleared( "dogleg_2_spawn_manager" );
	trigger::use( "dogleg_2_move_into_apt", "targetname" ); //moves Hendricks
	
	level flag::set( "dogleg_2_enemies_cleared" );
}

function no_stealth()
{
	//TODO remove once stealth is optional per guy
	
//	wait .5;
	
	self stealth::stop();
}

