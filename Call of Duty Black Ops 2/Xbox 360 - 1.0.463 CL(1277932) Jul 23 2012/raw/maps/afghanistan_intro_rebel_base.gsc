#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_vehicle;
#include maps\_objectives;
#include maps\_dialog;
#include maps\_horse;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


init_flags()
{
	flag_init( "first_rebel_base_visit" );
	flag_init("lockbreaker_opened");
	flag_init( "map_tutorial_active" );
	flag_init( "tutorial_vo_tank_sniper" );
	flag_init( "tutorial_vo_tank_rpg" );
	flag_init( "tutorial_vo_tank_stinger" );
	flag_init( "tutorial_vo_west_sniper" );
	flag_init( "tutorial_vo_west_rpg" );
	flag_init( "tutorial_vo_west_stinger" );
	flag_init( "tutorial_vo_north_sniper" );
	flag_init( "tutorial_vo_north_rpg" );
	flag_init( "tutorial_vo_north_stinger" );
	flag_init( "tutorial_vo_east_sniper" );
	flag_init( "tutorial_vo_east_rpg" );
	flag_init( "tutorial_vo_east_stinger" );
}



init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );
}


skipto_intro()
{
	skipto_setup();
	level.woods = init_hero("woods");
	remove_woods_facemask_util();
	
	level.zhao = init_hero("zhao");
	skipto_teleport( "skipto_rebel_base_intro", level.heroes );
	
	flag_wait( "afghanistan_gump_intro" );
}


main()
{
	/#
		IPrintLn( "Intro Rebel Base" );
	#/
	
	level thread cleanup();
		
	set_up_map_room();

	maps\afghanistan_anim::init_afghan_anims_part1b();
		
	run_map_room_anims();
	
	flag_set( "first_rebel_base_visit" );
}


set_up_map_room()
{
	autosave_by_name("e3_base_start");
	
	level thread spawn_map_room_personnel();
	
	level.rebel_leader = init_hero("rebel_leader");
	level.rebel_leader.animname = "rebel_leader";
	level.hudson = init_hero("hudson");
	level.hudson.animname = "hudson";
	
//	level.zhao set_run_anim( "patrol_walk" );
//	level.woods set_run_anim( "patrol_walk" );
//	level.zhao clear_run_anim();
//	level.woods clear_run_anim();

	level.zhao thread say_dialog( "zhao_this_way_0" );
	
	//level thread run_scene("e2_walk_in");
	//level thread run_scene("e2_leader_hudson_waiting");
	
	run_scene( "walkto_cave_entrance" );
	
	level thread run_scene( "cave_entrance_wait" );
	
	flag_wait( "enter_cave" );
	
	end_scene( "cave_entrance_wait" );
	
	delete_scene( "walkto_cave_entrance" );
	delete_scene( "cave_entrance_wait" );
	
//	level thread delete_intro_scenes();
}


run_map_room_anims()
{
	t_map_table = GetEnt( "trigger_map_room_table", "targetname" );
	
	//level thread run_scene( "map_room_wait_leader" );
	
	run_scene( "cave_enter" );
	
	set_objective( level.OBJ_AFGHAN_BC3, t_map_table, "breadcrumb" );
	
	level thread run_scene( "map_room_wait_hudson" );
	level thread run_scene( "map_room_wait" );
	
	while( !level.player IsTouching( t_map_table ) )
	{
		wait 0.05;	
	}
	
	set_objective( level.OBJ_AFGHAN_BC3, undefined, "done");
	set_objective( level.OBJ_AFGHAN_BC3, undefined, "delete");
	
//	end_scene( "map_room_wait" );
	
	level thread run_scene( "map_room" );
	
	flag_wait( "map_room_started" );
	
	wait 0.35;
	
	delete_intro_scenes();
	rebel_base_clean_up();
	
	load_gump( "afghanistan_gump_arena" );
	
	scene_wait( "map_room" );
	
	//TUEY setting music to AFGHAN_BATTLE_START
	setmusicstate( "AFGHAN_BATTLE_START" );
	
	clientNotify ( "abs_1" );
	
	delete_scene( "cave_enter" );
	delete_scene( "map_room_wait" );
	delete_scene( "map_room" );
}


delete_intro_scenes()
{
	level thread cleanup_intro();
	
	end_scene("e2_cooking_muj");
	end_scene("e2_drum_burner");
	//end_scene("e2_gas_guys");
	end_scene("e2_gunsmith");
	//level end_scene("e2_ridge_lookout");
	end_scene("e2_smokers");
	end_scene("e2_generator");
	end_scene("e2_tower_lookout_endidl");
	end_scene("e2_stinger_endidl");
	//level end_scene("e2_herder_endidl");
	end_scene("e2_stacker_endidl");
	end_scene("e2_stacker_3");
	
	delete_section_2_scenes();	
}


spawn_map_room_personnel()
{
	a_ai_muj = [];
	a_s_positions = [];
	
	for ( i = 0; i < 4; i++ )
	{
		a_s_positions[ i ] = getstruct( "map_room_muj_pos" + i, "targetname" );
	}
		
	for ( i = 0; i < a_s_positions.size; i++ )
	{
		a_ai_muj[ i ] = get_muj_ai();
		a_ai_muj[ i ] forceteleport( a_s_positions[ i ].origin, a_s_positions[ i ].angles );
		a_ai_muj[ i ].goalradius = 64;
		a_ai_muj[ i ] SetGoalPos( a_ai_muj[ i ].origin );
		a_ai_muj[ i ].arena_guy = true;
	}
	
	flag_wait( "e3_exit_map_room_started" );
	
	wait 3.5;
	
	v_wait_pos = GetEnt( "trigger_tower_collapse", "targetname" ).origin;
	
	for ( i = 0; i < a_s_positions.size; i++ )
	{
		if ( IsAlive( a_ai_muj[ i ] ) )
		{
			a_ai_muj[ i ] SetGoalPos( v_wait_pos + ( RandomIntRange( -32, 32 ), RandomIntRange( -64, 64 ), 0 ) );
			
			wait RandomFloatRange( 0.5, 1.0 );
		}
	}
	
	trigger_wait( "trigger_maproom_exit" );
	
	v_goal_pos = getstruct( "base_weapons_cache", "targetname" ).origin;
	
	for ( i = 0; i < a_s_positions.size; i++ )
	{
		if ( IsAlive( a_ai_muj[ i ] ) )
		{
			a_ai_muj[ i ] SetGoalPos( v_goal_pos + ( RandomIntRange( -32, 32 ), RandomIntRange( -64, 64 ), 0 ) );
			
			wait 0.1;
		}
	}
	
	wait 3.5;
	
	for ( i = 0; i < a_s_positions.size; i++ )
	{
		if ( IsAlive( a_ai_muj[ i ] ) )
		{
			MagicBullet( "btr60_heavy_machinegun", a_ai_muj[ i ].origin + ( -200, 0, 200 ), a_ai_muj[ i ].origin + ( 0, 0, 40 ) );
				
			wait 0.05;
		}
	}
	
	for ( i = 0; i < 4; i++ )
	{
		a_s_positions[ i ] structdelete();
		a_s_positions[ i ] = undefined;
	}
	
	goal_pos = getstruct( "base_weapons_cache", "targetname" );
	goal_pos structdelete();
	goal_pos = undefined;
}


start_loop_for_maps_room()
{
	//scene_wait( "e2_leader_hudson_waiting" );
	
	level thread run_scene( "e2_s1_map_loop" );
}


cleanup()
{
	if ( isdefined( level.muj_horses ) )
	{
		for( i = 0; i < level.muj_horses.size; i++ )
		{
			VEHICLE_DELETE( level.muj_horses[i] );
		}
	}
}


rebel_base_clean_up()
{
	ent_useless = getentarray( "e2_muj_clean_up", "script_noteworthy" );
	
	for( i = 0; i < ent_useless.size; i++ )
	{
		ent_useless[i] delete();
	}
	
	if ( isDefined( level.zhao.vh_my_horse ) )
	{
		VEHICLE_DELETE( level.zhao.vh_my_horse );
	}
	
	if ( isDefined( level.woods.vh_my_horse ) )
	{
		VEHICLE_DELETE( level.woods.vh_my_horse );
	}
	
	if ( isDefined( level.mason_horse ) && ( !level.press_demo ) )
	{
		VEHICLE_DELETE( level.mason_horse );
	}
	
	if ( isDefined( level.muj_tank ) )
	{
		VEHICLE_DELETE( level.muj_tank );
	}
	
	//reset horse overrides used in intro
	allow_horse_sprint( true );
	override_player_horse_speed( undefined );	
	
	level maps\createart\afghanistan_art::turn_down_fog();
}


/*map_tutorial()
{
	level.player.map_input_off = true;
	level.player.map_button_off = true;
	flag_set( "map_tutorial_active" );
	level map_tutorial_background_text();
	
	level.player.map_input_off = false;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_1");
	
	level.map_text_movement_button = NewHudElem();
	level.map_text_movement_button SetText(&"AFGHANISTAN_MAP_MOVEMENT");
	level.map_text_movement_button.x = 0;
	level.map_text_movement_button.y = 0;
	level.map_text_movement_button.alignX = "left";
	level.map_text_movement_button.alignY = "bottom";
	level.map_text_movement_button.horzAlign = "left";
	level.map_text_movement_button.vertAlign = "bottom";
	level.map_text_movement_button.fontScale = 1.3;
	
	level.player waittill("Blocking_Point_1");
	screen_message_delete();
	
	//add_temp_dialog_line("Woods", "Okay, we want to assign a Crew to Blocking Point 1.");
	
	level.player.map_button_off = false;
	level.player.tank_button_off = true;
	level.player.map_movement_off = true;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_4");
	
	level.map_text_x_button = NewHudElem();
	level.map_text_x_button SetText(&"AFGHANISTAN_MAP_X");
	level.map_text_x_button.x = -150;
	level.map_text_x_button.y = 0;
	level.map_text_x_button.alignX = "center";
	level.map_text_x_button.alignY = "bottom";
	level.map_text_x_button.horzAlign = "center";
	level.map_text_x_button.vertAlign = "bottom";
	level.map_text_x_button.fontScale = 1.3;
	
	level.map_text_sniper_remaining = NewHudElem();
	level.map_text_sniper_remaining SetText( "Sniper: x" + level.crew_remaining[ 0 ] );
	level.map_text_sniper_remaining.x = level.map_text_x_button.x + 35;
	level.map_text_sniper_remaining.y = 0;
	level.map_text_sniper_remaining.alignX = "center";
	level.map_text_sniper_remaining.alignY = "bottom";
	level.map_text_sniper_remaining.horzAlign = "center";
	level.map_text_sniper_remaining.vertAlign = "bottom";
	level.map_text_sniper_remaining.fontScale = 1.3;
	
	level.map_text_y_button = NewHudElem();
	level.map_text_y_button SetText(&"AFGHANISTAN_MAP_Y");
	level.map_text_y_button.x = 0;
	level.map_text_y_button.y = 0;
	level.map_text_y_button.alignX = "center";
	level.map_text_y_button.alignY = "bottom";
	level.map_text_y_button.horzAlign = "center";
	level.map_text_y_button.vertAlign = "bottom";
	level.map_text_y_button.fontScale = 1.3;
	
	level.map_text_stinger_remaining = NewHudElem();
	level.map_text_stinger_remaining SetText( "Stinger: x" + level.crew_remaining[ 2 ] );
	level.map_text_stinger_remaining.x = level.map_text_y_button.x + 35;
	level.map_text_stinger_remaining.y = 0;
	level.map_text_stinger_remaining.alignX = "center";
	level.map_text_stinger_remaining.alignY = "bottom";
	level.map_text_stinger_remaining.horzAlign = "center";
	level.map_text_stinger_remaining.vertAlign = "bottom";
	level.map_text_stinger_remaining.fontScale = 1.3;
	
	level.map_text_b_button = NewHudElem();
	level.map_text_b_button SetText(&"AFGHANISTAN_MAP_B");
	level.map_text_b_button.x = 150;
	level.map_text_b_button.y = 0;
	level.map_text_b_button.alignX = "center";
	level.map_text_b_button.alignY = "bottom";
	level.map_text_b_button.horzAlign = "center";
	level.map_text_b_button.vertAlign = "bottom";
	level.map_text_b_button.fontScale = 1.3;
	
	level.map_text_rpgs_remaining = NewHudElem();
	level.map_text_rpgs_remaining SetText( "RPG: x" + level.crew_remaining[ 1 ] );
	level.map_text_rpgs_remaining.x = level.map_text_b_button.x + 35;
	level.map_text_rpgs_remaining.y = 0;
	level.map_text_rpgs_remaining.alignX = "center";
	level.map_text_rpgs_remaining.alignY = "bottom";
	level.map_text_rpgs_remaining.horzAlign = "center";
	level.map_text_rpgs_remaining.vertAlign = "bottom";
	level.map_text_rpgs_remaining.fontScale = 1.3;
	
	level.player waittill("Unit_Placed");
	screen_message_delete();
	
	level.player.map_button_off = true;
	level.player.tank_button_off = true;
	level.player.map_movement_off = false;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_2");
	
	level.player waittill("Blocking_Point_2");
	screen_message_delete();
	
	level.player.map_button_off = false;
	level.player.tank_button_off = true;
	level.player.map_movement_off = true;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_4");
	level.player waittill("Unit_Placed");
	screen_message_delete();
	
	level.player.map_button_off = true;
	level.player.tank_button_off = true;
	level.player.map_movement_off = false;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_3");
	
	level.player waittill("Blocking_Point_3");
	screen_message_delete();
	
	level.player.map_button_off = false;
	level.player.tank_button_off = true;
	level.player.map_movement_off = true;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_4");
	level.player waittill("Unit_Placed");
	screen_message_delete();
	
	level.player.map_button_off = true;
	level.player.tank_button_off = true;
	level.player.map_movement_off = false;
	
	//add_temp_dialog_line("Woods", "Now we want to place the tank.");
	place_tank_vo();
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_8");
	
	level.player waittill("Arena");
	screen_message_delete();
	
	level.player.map_button_off = false;
	level.player.tank_button_off = false;
	level.player.map_movement_off = true;
	
	level.map_text_a_button = NewHudElem();
	level.map_text_a_button SetText(&"AFGHANISTAN_MAP_A");
	level.map_text_a_button.x = 0;
	level.map_text_a_button.y = 0;
	level.map_text_a_button.alignX = "right";
	level.map_text_a_button.alignY = "bottom";
	level.map_text_a_button.horzAlign = "right";
	level.map_text_a_button.vertAlign = "bottom";
	level.map_text_a_button.fontScale = 1.3;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_5");
	
	level.player waittill("Tank_Placed");
	screen_message_delete();
	
	level.player.map_button_off = false;
	level.player.map_movement_off = false;
	
	tank_placed_vo();
	//add_temp_dialog_line("Woods", "Finish your strategic placements and head out to battle with Zhao, Mason.");
	//wait 2;
	//add_temp_dialog_line("Woods", "When you're out in the field you'll be able to radio back to me to move the crews or tank.");
	//wait 2;

	screen_message_create(&"AFGHANISTAN_MAP_TUT_6");
	
	while( !level.player ActionSlotFourButtonPressed() )
	{
		wait 0.05;
	}
	
	screen_message_delete();
	
	screen_fade_out();
	map_room_teleport();
	level.player notify("map_tutorial_finished");
	flag_clear( "map_tutorial_active" );
	screen_message_create(&"AFGHANISTAN_MAP_TUT_7");
	
	wait 6;
	
	screen_message_delete();
}*/

place_tank_vo()
{
	wait 1;
	level.player say_dialog( "wood_that_it_0" );
	wait .5;
	level.player say_dialog( "omar_we_have_a_captured_r_0" );
}

tank_placed_vo()
{
	level.player say_dialog( "maso_if_the_russians_brea_0" );
}

map_tutorial_background_text()
{
	level.player say_dialog( "russian_tactics_ha_006" );
	//add_temp_dialog_line("Mason", "Russian tactics haven't changed much since World War Two.");
	wait .5;
	level.player say_dialog( "they_rely_on_stren_007" );
	//add_temp_dialog_line("Woods", "They rely on strength of numbers and brute force more than anything else.");
	wait .5;
	level.player say_dialog( "while_theyre_stro_008" );
	//add_temp_dialog_line("Woods", "While they're strong, they're not very quick to adapt.");
	wait .5;
	level.player say_dialog( "our_best_chance_is_009" );
	//add_temp_dialog_line("Mason", "Our best chance is to catch them off guard, so placement of your defenses is key.");
	wait .5;
	level.player say_dialog( "maso_the_base_is_located_0" );
	//add_temp_dialog_line("Mason", "The base is located to the south of this valley.");
	wait .5;
	level.player say_dialog( "maso_the_west_the_nor_0" );
	//add_temp_dialog_line("Mason", "The West, the North, and the East.");
	wait .5;
	level.player say_dialog( "omar_we_have_ammo_caches_0" );
	//add_temp_dialog_line("Omar", "We have ammo caches at each position.");
	wait .5;
	level.player say_dialog( "maso_that_s_where_the_rus_0" );
	//add_temp_dialog_line("Mason", "That's where the Russians will focus their attack. You'll need to ensure they're well defended.");
	wait .5;
	level.player say_dialog( "omar_stinger_rpgs_and_sn_0" );
	//add_temp_dialog_line("Omar", "Stinger, RPGs and Sniper teams await our orders.");
	wait .5;
	level.player say_dialog( "maso_okay_0" );
	//add_temp_dialog_line("Mason", "Okay.");
	/*wait 3.5;
	add_temp_dialog_line("Rebel Leader", "These men are all experienced with the weapon mentioned in the crew and are available for you to assign to");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "any of the blocking points that you feel need the support.");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "We have only had time to train two (2) of each crew type.");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "Finally, we recently captured a Russian T-62 tank. This will be at your disposal to help defend the base");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "and be assigned to any of the three blocking points.");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "If it is destroyed, it is gone. We only have the one tank.");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "What you're pointing to right now is the arena. This is where only tank can be placed but the crews do not have");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "access to without being put at risk. Through out the area there are ammo caches where you will find equipment.");
	wait 3.5;
	add_temp_dialog_line("Rebel Leader", "Now look towards the West side of the map at blocking point 1");
	wait 3.5;*/
}

cleanup_intro()
{
	delete_ride_vignette_array = GetEntArray( "e1_ride_vig_cleanup", "script_noteworthy" );
	foreach( cleanup_ent in delete_ride_vignette_array )
	{
		cleanup_ent delete();
	}
	
	//t_unload_trigger = getent( "truck_unload_vignette_trigger", "targetname" );
	//t_unload_trigger delete();
	
	intro_fail_triggers = GetEntArray( "e1_intro_ride_fail_trigger", "script_noteworthy" );
	foreach( fail_trigger in intro_fail_triggers )
	{
		fail_trigger Delete();
	}
}
/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here
