#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\see1_code;
#include maps\_music;

#using_animtree( "generic_human" );

event2_main()
{

	// TODO: Hook up event 3 to this so we don't have to teleport

	level.ev2_tank1 = undefined;
	level.ev2_tank2 = undefined;
	level.ev2_tank3 = undefined;
	level.ev2_tank4 = undefined;
	level.ev2_tank5 = undefined;

	initialize_spawn_function( "ev2_tank_1_escort", "script_noteworthy", ::ev2_ignore_players_initially );
	initialize_spawn_function( "ev2_tank_2_escort", "script_noteworthy", ::ev2_ignore_players_initially );
	level thread ev2_detect_player();

	initialize_spawn_function( "ev2_tank_3_escort", "script_noteworthy", ::force_to_goal );
	initialize_spawn_function( "ev2_tank_4_escort", "script_noteworthy", ::force_to_goal );

	initialize_spawn_function( "ev2_house_guys", "script_noteworthy", ::force_to_goal );

//	initialize_spawn_function( "ev2_door_guys_1", "script_noteworthy", ::ev2_go_open_barn_door_1 );
//	initialize_spawn_function( "ev2_door_guys_2", "script_noteworthy", ::ev2_go_open_barn_door_2 );

	initialize_spawn_function( "ev2_barn_guys", "script_noteworthy", ::force_to_goal );

	initialize_spawn_function( "ev2_road_spawn_1", "script_noteworthy", ::ev2_road_ai_pathing );
	initialize_spawn_function( "ev2_road_spawn_2", "script_noteworthy", ::ev2_road_ai_pathing );
	initialize_spawn_function( "ev2_road_spawn_3", "script_noteworthy", ::ev2_road_ai_pathing );
	initialize_spawn_function( "ev2_road_spawn_4", "script_noteworthy", ::ev2_road_ai_pathing );

	initialize_spawn_function( "ev2_pacing_spawn_side_guys", "script_noteworthy", ::ev2_road_ai_side );

	level.hero1 thread scripted_molotov_throw_triggered( "molotov_farm_area_1", "script_noteworthy", "molotov_toss_point_5", "all_tanks_destroyed" );
	level.hero1 thread scripted_molotov_throw_triggered( "ev2_start_mg_burst", "targetname", "molotov_toss_point_6", "all_tanks_destroyed"  );

	// objectives
	level thread ev2_objectives();

	level thread ev2_panzershreck_respawns();

	level thread ev2_throw_guy_out_window();

	level thread collectible_corpse();

	level thread dialog_lead_charge();
	level thread dialog_tank_3_success();

	// main events. Starts in this sequence
	level thread ev2_ambient_tank_hits();
	level thread ev2_battle_tank_1_and_2();
	level thread ev2_battle_tank_3_and_4();
	level thread ev2_ambient_t34_actions();
	level thread ev2_regroup_at_the_barn();
	level thread ev2_battle_tank_5();
	level thread ev2_pacing();
	
	level thread ev2_loop_ambient_mg_burst();
	level thread ev2_shreck_loop();
	level thread ev2_shreck_barrage();
	level thread triggered_explosions( "ev2_explosion_trigger" );

	wait( 1 );
	maps\see1_anim::barn_door_kick_spawn();
	maps\see1_anim::barn_door_tank_spawn();

	end_trigger = getent( "ev2_ends", "targetname" );
	end_trigger waittill( "trigger" );
	level notify( "event_2b_ends" );
	/*
	if( isdefined( level.tank_spot_1_guy ) && isplayer( level.tank_spot_1_guy ) )
	{
		level thread print_text_on_screen( &"SEE1_OFF_TANK" );
	}
	if( isdefined( level.tank_spot_2_guy ) && isplayer( level.tank_spot_2_guy ) )
	{
		level thread print_text_on_screen( &"SEE1_OFF_TANK" );
	}
	*/
	level thread ev2_cleanup(); 
}


ev2_detect_player()
{
	trigger_1 = getent( "ev2_shot_at_enemies", "targetname" );
	trigger_2 = getent( "ev2_got_close_to_enemies", "targetname" );

	level thread ev2_wait_for_player_to_damage( trigger_1, "fire_trigger" );
	level thread wait_for_trigger_and_notify( trigger_2, "move_trigger" );
	level thread ev2_delayed_trigger_wait( 4, "move_trigger" );

	level waittill_either( "fire_trigger", "move_trigger" );

	level notify( "ev2_player_discovered" );

	//all_friends_resume_fire();
}

ev2_wait_for_player_to_damage( trigger, msg )
{
	while( 1 )
	{
		trigger waittill( "damage", amount, attacker, direction_vec, point, type );
		if( isplayer( attacker ) )
		{
			level notify( msg );
			flag_set( "ev2_player_fired" );
			return;
		}
	}
}

ev2_delayed_trigger_wait( time, msg )
{
	trigger = getent( "ev2_spawn_battle_1", "targetname" );
	trigger waittill( "trigger" );
	wait( time );
	level notify( msg );
}

ev2_ignore_players_initially()
{
	level endon( "ev2_player_discovered" );
	self endon( "death" );

	self thread ev2_react_to_players();

	self hold_fire();
	self.goalradius = 16;
	self waittill( "goal" );

	self resume_fire();
	fake_target = getent( "ev2_enemy_fake_fire_1", "targetname" );
	self SetEntityTarget( fake_target, 1 );
}

ev2_react_to_players()
{
	self endon( "death" );

	level waittill( "ev2_player_discovered" );

	self ClearEntityTarget();
	self resume_fire();
}

ev2_objectives()
{
	regroup_trigger = getent( "ev2_regroup_barn", "targetname" );
	regroup_trigger trigger_off();

	flag_wait( "ev2_tank2_spawned" );

	objective_state( 2, "done" );

	//objective_delete( 2 );
	objective_add( 3, "current", level.obj3a_string ); // 4 remaining
	
	// modifed to just add tanks, as we can do that now.  DSL
	
	objective_additionalposition( 3, 0, level.ev2_tank1);
	objective_additionalposition( 3, 1, level.ev2_tank2);

	level.ev2_tanks_remaining = 4;
	level thread ev1_tank_obj( 3, 0, level.ev2_tank1, "ev2_tank1_destroyed" );	

	level thread ev1_tank_obj( 3, 1, level.ev2_tank2, "ev2_tank2_destroyed" );

	// these are temp
	level thread ev1_tank_temp_obj( 3, 2, ( 2669, 8543, -86.8 ) );
	level thread ev1_tank_temp_obj( 3, 3, ( 3365, 8372, -79.9 ) );


	//iprintlnbold( "Sgt: Find some panzershreck rockets. Look around." );
	wait( 2 );
	//iprintlnbold( "Sgt: You can also mantle these tanks. Do whatever it takes to destroy them!" );

	flag_wait( "ev2_tank3_spawned" );
	level thread ev1_tank_obj( 3, 2, level.ev2_tank3, "ev2_tank3_destroyed" );

	//iprintlnbold( "Sgt: There are more panzershreck rockets in the trench ahead. Grab them." );

	flag_wait( "ev2_tank4_spawned" );
	level thread ev1_tank_obj( 3, 3, level.ev2_tank4, "ev2_tank4_destroyed" );

	flag_wait_all( "ev2_tank1_destroyed", "ev2_tank2_destroyed", "ev2_tank3_destroyed", "ev2_tank4_destroyed" );

	objective_string( 3, level.obj3e_string );
	objective_state( 3, "done" );
	level notify( "all_tanks_destroyed" );
	
	//TUEY Sets music State to 
	setmusicstate ("TANKS_DESTROYED");
	// regroup
	wait_network_frame();
	
	regroup_trigger trigger_on();
	objective_add( 4, "current", level.obj4_string, ( 4500, 8772, 79.5758 ) );
	level thread dialog_run_to_barn();
	level waittill( "ev2_regroup_time" );
	regroup_trigger waittill( "trigger" );

	level notify( "ev2_regroup_success" );
	level waittill( "ev2_regroup_open_barn_door" );
	wait( 0.6 );
	level notify( "move_tank_5" );
	objective_state( 4, "done" );
	objective_delete( 4 );
	
	flag_wait( "ev2_tank5_spawned" );
	objective_add( 4, "current", level.obj5_string );
	level thread ev1_tank_5_obj( 4, level.ev2_tank5, "ev2_tank5_destroyed" );
	level waittill( "ev2_tank5_destroyed" );
	objective_state( 4, "done" );
	objective_delete( 4 );

	objective_add( 4, "current", level.obj6_string, ( 4882, 9512, 91 ) );
	level waittill( "pacing_ready" );
	objective_state( 4, "done" );
	objective_delete( 4 );

	objective_add( 4, "current", level.obj7_string, ( -932.5, 10459.5, 11 ) );
}

ev1_tank_obj( obj_num, sub_num, tank, flag_to_set )
{
	while( isalive( tank ) )
	{
//		objective_additionalposition( obj_num, sub_num, tank.origin );	// Now we're sending the tank, we don't need to animate this.
		wait( 0.5 );
	}
	objective_additionalposition( obj_num, sub_num, (0,0,0) );
	flag_set( flag_to_set );
	level.ev2_tanks_remaining--;
	ev1_update_tank_obj();
}

ev1_update_tank_obj()
{
	if( level.ev2_tanks_remaining == 3 )
	{
		objective_string( 3, level.obj3b_string );
	}
	else if( level.ev2_tanks_remaining == 2 )
	{
		objective_string( 3, level.obj3c_string );
	}
	else if( level.ev2_tanks_remaining == 1 )
	{
		objective_string( 3, level.obj3d_string );
	}
}

ev1_tank_temp_obj( obj_num, sub_num, pos )
{
	objective_additionalposition( obj_num, sub_num, pos );
}

ev1_tank_5_obj( obj_num, tank, msg )
{
	while( isalive( tank ) )
	{
		objective_position( obj_num, tank.origin );
		wait( 0.5 );
	}
	level notify( msg );
}

ev2_ambient_t34_actions()
{
	trigger = getent( "ev2_spawn_t34s", "targetname" );
	trigger waittill( "trigger" );
	
	wait( 1 );

	tank1 = getent( "ev2_t34_1", "targetname" );
	tank2 = getent( "ev2_t34_2", "targetname" );
	tank3 = getent( "ev2_t34_3", "targetname" );
	tank4 = getent( "ev2_t34_4", "targetname" );
	tank5 = getent( "ev2_t34_5", "targetname" );

	tank1.health = 99999;
	tank2.health = 99999;
	tank3.health = 99999;
	tank4.health = 99999;
	tank5.health = 99999;

	tank1 thread random_death_at_end_node();
	tank2 thread random_death_at_end_node();
	tank3 thread random_death_at_end_node();
	tank4 thread random_death_at_end_node();
	tank5 thread ev2_tank_5_barrage();

	level waittill( "event_2b_ends" );
	tank1 delete();
	tank2 delete();
	tank3 delete();
	tank4 delete();
	tank5 delete();
}

random_death_at_end_node()
{
	self endon( "death" );
	self waittill( "reached_end_node" );
	wait( randomint( 2 ) );
	playfx( level._effect["tank_blow_up"], self.origin );
	playfx( level._effect["tank_smoke_column"], self.origin );
	self dodamage( self.health + 25, ( 0,180,48 ) );
	self notify( "death" );
}

ev2_tank_5_barrage()
{
	node = getvehiclenode( "ev2_shreck_barrage_node", "script_noteworthy" );
	self setwaitnode( node );
	self waittill( "reached_wait_node" );	
	flag_set( "ev2_tank_friend_in_position" );

	level waittill( "tank_killed_by_shreck" );
	playfx( level._effect["tank_blow_up"], self.origin );
	playfx( level._effect["tank_smoke_column"], self.origin );
	self dodamage( self.health + 25, ( 0,180,48 ) );
	self notify( "death" );
}

ev2_ambient_tank_hits()
{
	level thread ev2_ambient_tank_hits_friend();
	level thread ev2_ambient_tank_hits_enemy();
	
	flag_wait_all( "ev2_tank1_destroyed", "ev2_tank2_destroyed", "ev2_tank3_destroyed", "ev2_tank4_destroyed" );
	level notify( "stop_ambient_explosions" );
}

ev2_ambient_tank_hits_friend()
{
	level endon( "stop_ambient_explosions" );
	friendly_targets = getstructarray( "ev2_tank_battle_ambient_friend", "targetname" );
	while( 1 )
	{
		index = randomint( friendly_targets.size );
		playfx( level._effect["dirt_blow_up"], friendly_targets[index].origin );

		wait( randomfloat( 3 ) );
	}
}

ev2_ambient_tank_hits_enemy()
{
	level endon( "stop_ambient_explosions" );
	enemy_targets = getstructarray( "ev2_tank_battle_ambient_enemy", "targetname" );

	while( 1 )
	{
		index = randomint( enemy_targets.size );
		playfx( level._effect["dirt_blow_up"], enemy_targets[index].origin );

		wait( randomfloat( 2 ) );
	}
}

ev2_throw_guy_out_window()
{	
	trigger = getent( "house_throw_damage_trigger", "targetname" );
	trigger waittill( "trigger" );

	level notify( "shreck_guy_killed" );
	
	//iprintlnbold( "THROW TRIGGER" );

	//wait( 4 );

	//wait( 0.1 );
	spawner = getent( "house_throw_guy", "targetname" );
	spawnedGuy = spawner StalingradSpawn();
	spawn_failed( spawnedGuy );

	spawnedGuy.animname = "generic";
	spawnedGuy set_random_gib();
	spawnedGuy thread anim_single_solo( spawnedGuy, "death_explosion_forward" );

	wait( 0.7 );
	spawnedGuy.deathanim = %death_explosion_forward13;
	spawnedGuy dodamage( spawnedGuy.health + 100, ( 0, 0, 0 ) );
	spawnedGuy startragdoll();
}

ev2_battle_tank_1_and_2()
{
	//all_friends_hold_fire();

	trigger = getent( "ev2_spawn_battle_1", "targetname" );
	trigger waittill( "trigger" );

	level thread dialog_panzershreck();
	level thread dialog_tank_1_success();

	drone_trigger_1 = getent( "ev2_tank_1_fire_drones", "script_noteworthy" );
	drone_trigger_2 = getent( "ev2_tank_2_fire_drones", "script_noteworthy" );

	//level thread periodic_trigger( drone_trigger_1, "all_tanks_destroyed" );
	//level thread periodic_trigger( drone_trigger_2, "all_tanks_destroyed" );

	wait( 0.5 );
	level.ev2_tank1 = getent( "ev2_tank1", "targetname" );
	level.ev2_tank2 = getent( "ev2_tank2", "targetname" );

	flag_set( "ev2_tank1_spawned" );
	flag_set( "ev2_tank2_spawned" );

	level notify( "tank_battle_starts" );

	level.ev2_tank2 thread ev2_tank_think( "ev2_tank_2_start_1", "ev2_tank_2_targets", 4, "ev2_tank_2_start_2", "ev2_tank_2_start_3", level.ev2_tank1, 700 );
	level.ev2_tank2 ev2_tank_start_on_path();

	trigger2 = getent( "ev2_move_tank_1", "targetname" );
	trigger2 waittill( "trigger" );

	level thread dialog_tanks_appear();

	level.ev2_tank1 thread ev2_tank_think( "ev2_tank_1_start_1", "ev2_tank_1_targets", 4, "ev2_tank_1_start_2", "ev2_tank_1_start_3", level.ev2_tank2, 300 );
	level.ev2_tank1 ev2_tank_start_on_path();

	level thread ev2_tank_battle_3_force_start();
}

ev2_battle_tank_3_and_4()
{
	trigger = getent( "ev2_tank_battle_2", "targetname" );
	trigger waittill( "trigger" );

	level thread dialog_tank_2_success();

	drone_trigger_3 = getent( "ev2_tank_3_fire_drones", "script_noteworthy" );
	drone_trigger_4 = getent( "ev2_tank_4_fire_drones", "script_noteworthy" );

	//level thread periodic_trigger( drone_trigger_3, "all_tanks_destroyed" );
	//level thread periodic_trigger( drone_trigger_4, "all_tanks_destroyed" );

	wait( 0.5 );
	level.ev2_tank3 = getent( "ev2_tank3", "targetname" );
	level.ev2_tank4 = getent( "ev2_tank4", "targetname" );


	flag_set( "ev2_tank3_spawned" );
	flag_set( "ev2_tank4_spawned" );

	level.ev2_tank3 thread ev2_tank_think( "ev2_tank_3_advance", "ev2_tank_3_targets", 8, "ev2_tank_3_retreat_1", "ev2_tank_3_retreat_2", level.ev2_tank2 );
	tank_3_start_node = getvehiclenode( "ev2_start_tank3", "targetname" );
	level.ev2_tank3 ev2_tank_start_on_different_path( tank_3_start_node );

	level thread ev2_tank_battle_4_force_start();

	trigger = getent( "ev2_tank_battle_3", "targetname" );
	trigger waittill( "trigger" );

	level.ev2_tank4 thread ev2_tank_think( "ev2_tank_4_advance", "ev2_tank_4_targets", 6, "ev2_tank_4_retreat_1", "ev2_tank_4_retreat_2", level.ev2_tank2 );
	tank_4_start_node = getvehiclenode( "ev2_start_tank4", "targetname" );
	level.ev2_tank4 ev2_tank_start_on_different_path( tank_4_start_node );
}

ev2_tank_battle_3_force_start()
{
	flag_wait_all( "ev2_tank1_destroyed", "ev2_tank2_destroyed" );
	trigger = getent( "ev2_tank_battle_2", "targetname" );
	trigger notify( "trigger" );
}

ev2_tank_battle_4_force_start()
{
	flag_wait( "ev2_tank3_destroyed" );
	trigger = getent( "ev2_tank_battle_3", "targetname" );
	trigger waittill( "trigger" );
}

ev2_regroup_at_the_barn()
{
	level waittill( "all_tanks_destroyed" );

	autosave_by_name( "End Tanks" );

	flood_stop = getent( "ev2_stop_last_flood", "targetname" );
	flood_stop notify( "trigger" );

	//iprintlnbold( "Sgt: Get to the barn ahead. There's still some Germans hiding inside." );

	all_friends = getaiarray( "allies" );
	nodes = getnodearray( "ev2_regroup_nodes", "targetname" );

	for( i = 0; i < all_friends.size; i++ )
	{
		all_friends[i] disable_ai_color();
		if( i < nodes.size )
		{
			//all_friends[i] hold_fire();
			all_friends[i].goalradius = 32;
			all_friends[i] setgoalnode( nodes[i] );

			next_node_noteworthy = nodes[i].script_noteworthy + "2";
			all_friends[i].next_retreat_node2 = next_node_noteworthy;
		}
	}

	level.hero1 waittill( "goal" );

	all_friends = getaiarray( "allies" );
	for( i = 0; i < all_friends.size; i++ )
	{
		all_friends[i] hold_fire();
	}

	level notify( "ev2_regroup_time" );
	level waittill( "ev2_regroup_success" );

	// now kill old enemies
	enemies = getaiarray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		enemies[i] thread ai_auto_death( 5 );
	}

	wait( 3 );

	level thread dialog_regroup_at_barn();

	wait( 0.5 );
	level.ev2_tank5 = getent( "ev2_tank5", "targetname" );
	level.ev2_tank5	maps\_vehicle::mgoff();

	level waittill( "move_tank_5" );
	level thread ev2_guys_at_door();

	flag_wait( "ev2_tank5_spawned" );

	for( i = 0; i < all_friends.size; i++ )
	{
		if( isalive( all_friends[i] ) && isdefined( all_friends[i].next_retreat_node2 ) )
		{
			new_node = getnode( all_friends[i].next_retreat_node2, "script_noteworthy" );
			if( isdefined( new_node ) )
			{
				all_friends[i] setgoalnode( new_node );
				all_friends[i] resume_fire();
			}
		}
	}

	//TUEY SETMUSICSTATE TO "SURPRISE"
	setmusicstate("SURPRISE");

	level thread dialog_tank_surprise();

	level waittill( "ev2_tank5_destroyed" );
	


	//iprintlnbold( "Sgt: That was the last tank. Good work. Now let's keep moving." );

	// now tell the friends to go inside barn
	// now kill old enemies
	enemies = getaiarray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		enemies[i] thread ai_auto_death( 5 );
	}

	wait( 3 );

	all_friends = getaiarray( "allies" );
	node_zeitzev = getnode( "ev2_barn_zeitzev1", "targetname" );
	node_chernov = getnode( "ev2_barn_chernov1", "targetname" );
	nodes = getnodearray( "ev2_barn_friends", "targetname" );
	node_index = 0;

	for( i = 0; i < all_friends.size; i++ )
	{
		if( all_friends[i] == level.hero1 )
		{
			all_friends[i] setgoalnode( node_zeitzev );
		}
		else if( all_friends[i] == level.hero2 )
		{
			all_friends[i] setgoalnode( node_chernov );
		}
		else
		{
			if( node_index < nodes.size )
			{
				all_friends[i] setgoalnode( nodes[node_index] );
				node_index++;
			}
		}
	}

	//TuEY set music state to surprise_tank_dead for pacing section
	setmusicstate("SURPRISE_TANK_DEAD");
	
	// wait till both heros are at goal node
	level.hero1 waittill( "goal" );
	while( distance( level.hero2.origin, node_chernov.origin ) > 50 )
	{
		wait( 0.1 );
	}

	//level.hero1 set_run_anim( "walk_barn" );
	//level.hero1 set_run_anim( "walk_barn" );

	node_zeitzev2 = getnode( "ev2_barn_zeitzev", "targetname" );
	node_chernov2 = getnode( "ev2_barn_chernov", "targetname" );
	level notify( "ev2_walk_barn" );
	level thread dialog_tank_5_success();
	// this is a good time to make them walk

	level thread anim_open_barn_door( level.hero1, level.hero2, node_zeitzev2, node_chernov2 );

	// now kill old enemies
	enemies = getaiarray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		enemies[i] thread ai_auto_death( 3 );
	}

	level waittill( "barn_door_opened" );

	colors_barn = getent( "ev2_barn_fc", "targetname" );
	//colors_barn trigger_on();

	all_friends = getaiarray( "allies" );

	for( i = 0; i < all_friends.size; i++ )
	{
		all_friends[i] enable_ai_color();
	}

	colors_barn notify( "trigger" );
}

anim_open_barn_door( guy1, guy2, node1, node2 )
{
/*
	guy1.goalradius = 16;
	guy2.goalradius = 16;
	guy1 setgoalnode( node1 );
	guy2 setgoalnode( node2 );

	guy1 waittill( "goal" );
	guy2 setgoalnode( node2 );

	// wait for guy2 to get into position
	while( distance( guy2.origin, node2.origin ) > 20 )
	{
		wait( 0.1 );
	}

	wait( 2 );
*/
	guys = [];
	guys[0] = guy1;
	guys[1] = guy2;

	wait( 5 );

	anim_struct = getstruct( "ev2_barn_door_kick_origin", "targetname" );
	anim_struct anim_reach( guys, "open_barn_door" );
	flag_wait( "barn_door_anim_ready" );
	anim_struct anim_single( guys, "open_barn_door" );
	level notify( "barn_kick_exit_done" );
}

ev2_battle_tank_5()
{
	level waittill( "move_tank_5" );
	wait( 0.5 );
	level.ev2_tank5 = getent( "ev2_tank5", "targetname" );

	level.ev2_tank5	maps\_vehicle::mgoff();
	level waittill( "move_tank_5_for_real" );

	//move_trigger = getent( "ev2_move_tank_5", "targetname" );
	//move_trigger notify( "trigger" );

	node = getvehiclenode( "ev2_tank_5_start_barn", "script_noteworthy" );
	level.ev2_tank5.see1_tank_no_stop_time = 3;
	level.ev2_tank5 thread ev2_tank_think( "ev2_tank_5_move_3", "ev2_tank_2_targets", 4, "ev2_tank_5_move_1", "ev2_tank_5_move_2" );
	level.ev2_tank5 ev2_tank_start_on_different_path( node );

	wait( 0.5 );

	flag_set( "ev2_tank5_spawned" );
	level.ev2_tank5	maps\_vehicle::mgon();

	exploder( 201 );
	maps\see1_anim::tank_open_door();

	colors_barn = getent( "ev2_barn_fc", "targetname" );
	colors_barn trigger_off();

	players = get_players();
	level.ev2_tank5.see1_tank_current_target = players[0];
	//level.ev2_tank5 thread check_for_panzershreck_hit( 3 );
	//level.ev2_tank5 thread ev2_tank_loop_at_player();

	// spawn guys inside house
	spawn_trigger = getent( "ev2_barn_inside", "script_noteworthy" );
	spawn_trigger notify( "trigger" );
	wait( 0.05 );

	spawn_trigger2 = getent( "ev2_barn_inside_2", "script_noteworthy" );
	spawn_trigger2 notify( "trigger" );

	// open door
	door = getent( "ev2_barn_door_in", "targetname" );
	door connectpaths();
	//door notsolid();
	//door delete();
	door rotateyaw( 90, 0.4, 0.3, .1 );
	level notify( "start_pacing" );
}

ev2_pacing()
{
	level waittill( "ev2_tank5_destroyed" );

	// tanks
	script_trigger2( "ev2_move_tank_20", "targetname" );
	wait( 0.4 );
	script_trigger2( "ev2_move_tank_21", "targetname" );
	wait( 0.4 );
	script_trigger2( "ev2_move_tank_22", "targetname" );

	level thread pacing_tank4_wait();
	level thread pacing_tank1_3_wait();
	level thread pacing_planes( "ev2_pacing_plane_1" );
	level thread pacing_planes( "ev2_pacing_plane_2" );

	level waittill( "tank3_at_first_stop" );
	// AIs
	script_trigger2( "ev2_road_flood_1", "script_noteworthy" );
	wait( 3 );
	script_trigger2( "ev2_road_flood_2", "script_noteworthy" );
	wait( 2 );
	wait( 2 );
	script_trigger2( "ev2_road_flood_3", "script_noteworthy" );
	wait( 3 );
	script_trigger2( "ev2_road_flood_4", "script_noteworthy" );
	//script_trigger2( "ev2_road_flood_5", "script_noteworthy" );
}

pacing_tank4_wait()
{
	wait( 1 );
	tank4 = getent( "ev2_t34_24", "targetname" );
	tank4.health = 999999;
	tank4 waittill( "reached_end_node" );
	//playfx( level._effect["tank_blow_up"], ( 4867.5, 10767.5, 76.2) );
	//playfx( level._effect["tank_smoke_column"], tank4.origin );
	level notify( "pacing_ready" );
}

pacing_tank1_3_wait()
{
	level endon( "tanks_at_destination" );

	wait( 1 );
	tank1 = getent( "ev2_t34_21", "targetname" );
	tank2 = getent( "ev2_t34_22", "targetname" );
	tank3 = getent( "ev2_t34_23", "targetname" );

	tank1.health = 999999;
	tank2.health = 999999;
	tank3.health = 999999;

	level.ev2_tank_1_can_mount = true;
	level.ev2_tank_2_can_mount = true;
	level.ev2_tank_3_can_mount = true;
	level.ev2_tank_3b_can_mount = true;

	//level thread pacing_get_on_tank_1( tank1 );
	level thread pacing_get_on_tank_2( tank2 );
	//level thread pacing_get_on_tank_3( tank3 );
	level thread pacing_get_on_tank_3b( tank3 );

	tank1 thread fire_at_target_at_end_tank1( "ev3_tower_target_3", 1 );
	tank2 thread fire_at_target_at_end( "ev3_tower_target_2", 3 );
	tank3 thread fire_at_target_at_end( "ev3_tower_target_1", 0 );

	start_wait_node = getvehiclenode( "ev2_tank_1_start_waiting", "script_noteworthy" );
	tank3 setwaitnode( start_wait_node );
	tank3 waittill( "reached_wait_node" );
	level notify( "tank3_at_first_stop" );

	//iprintlnbold( "Sgt: Press X at the back of the tank to get on or off." );

	// now we wait for player
	players = get_players();
	destination_point = ( -5359, 15908, 91.8 );
	//close_enough = 1300;
	move_tank = false;

	while( 1 )
	{
		// if player is already on tank, move
		if( isdefined( level.tank_spot_1_guy ) && isplayer( level.tank_spot_1_guy ) )
		{
			//iprintlnbold( "MOUNTED" );
			move_tank = true;
		}
		// if player is already on tank, move
		else if( isdefined( level.tank_spot_2_guy ) && isplayer( level.tank_spot_2_guy ) )
		{
			//iprintlnbold( "MOUNTED" );
			move_tank = true;
		}
		// if any player is within 500 units for any tank, the tanks move
		else if( any_player_within_distance( tank3.origin, 500 ) )
		{
			//iprintlnbold( "PLAYER CLOSE" );
			move_tank = true;
		}
		// else if player is in front of the tanks, tanks move 
		else
		{
			dist_player = dist_to_closest_player( destination_point );
			dist_tank = distance( tank3.origin, destination_point );
			if( dist_player < dist_tank )
			{
				//iprintlnbold( "PLAYER PASSED" );
				move_tank = true;
			}
			else
			{
				//iprintlnbold( "STOP" );
				move_tank = false;
			}
		}


		if( move_tank )
		{
			if( isalive( tank2 ) )
			{
				tank2 resumespeed( 5 );
			}
			wait( 1 );
			if( isalive( tank3 ) )
			{
				tank3 resumespeed( 5 );
			}
			wait( 3 );
		}
		else
		{
			if( isalive( tank2 ) )
			{
				tank2 setspeed( 0, 5, 5 );
			}
			wait( 0.4 );
			if( isalive( tank3 ) )
			{
				tank3 setspeed( 0, 5, 5 );
			}
			wait( 2 );
		}
	}
}

fire_at_target_at_end_tank1( target_name, delay )
{
	level endon( "event_2b_ends" );

	target_point = getstruct( target_name, "targetname" );
	self waittill( "reached_end_node" );


	trigger = getent( "start_tank1_fire", "targetname" );
	trigger waittill( "trigger" );

	self.turretrotscale = 0.7;

	for( i = 0; i < 3; i++ )
	{
		target_vec = target_point.origin  + ( randomint( 200 ), randomint( 100 ), 0 );
		self SetTurretTargetVec( target_vec );
		self waittill( "turret_on_target" );
		self FireWeapon();
		playfx( level._effect["tank_fire_dust"], target_vec );
		playfx( level._effect["house_blow_up"], target_vec );

		wait( 4 + randomint( 2 ) );
	}
}

fire_at_target_at_end( target_name, delay )
{
	target_point = getstruct( target_name, "targetname" );
	self waittill( "reached_end_node" );

	wait( delay );

	self.turretrotscale = 0.7;
	self SetTurretTargetVec( target_point.origin );
	self waittill( "turret_on_target" );

	self FireWeapon();
	playfx( level._effect["tank_fire_dust"], self.origin );
	playfx( level._effect["house_blow_up"], target_point.origin );

	if( target_name == "ev3_tower_target_1" )
	{
		//exploder( 3001 );
		level notify( "tower01_force_blow_up" );
		flag_set( "tank3_in_position_after_ride" );
	}
	else if( target_name == "ev3_tower_target_2" )
	{
		//exploder( 3002 );
		level notify( "tower02_force_blow_up" );
	}
}		

pacing_planes( plane_id )
{
	plane_trigger = getent( plane_id, "targetname" );
	plane_trigger waittill( "trigger" );

	start_node = getvehiclenode( plane_id, "script_noteworthy" );

	plane = spawnvehicle( "vehicle_rus_airplane_il2", 
						 "plane", 
						 "stuka", 
						 start_node.origin, 
						 start_node.angles );		

	plane attachPath( start_node );
	plane startpath();
	
	plane playsound( "fly_by2" );

	plane waittill( "reached_end_node" );
	plane delete();
}

ev2_guys_at_door()
{
	//trigger = getent( "ev2_door_guys_spawn", "targetname" );
	//trigger notify( "trigger" );

	allies_ai = GetAiArray( "allies" );
	/*
	while( allies_ai.size < 4 )
	{
		wait( 1 );
		allies_ai = GetAiArray( "allies" );
	}
	*/

	for( i = 0; i < allies_ai.size; i++ )
	{
		if( allies_ai[i] != level.hero1 && allies_ai[i] != level.hero2 )
		{
			if( !isdefined( level.door_guys_1 ) )
			{
				level.door_guys_1 = allies_ai[i];
				allies_ai[i] thread ev2_go_open_barn_door_1();
			}
			else if( !isdefined( level.door_guys_2 ) )
			{
				level.door_guys_2 = allies_ai[i];
				allies_ai[i] thread ev2_go_open_barn_door_2();
			}
		}
	}

	//iprintlnbold( "Sgt: You two, go break open the barn door!" );

	wait( 1 );

	ev2_door_trigger = getent( "ev2_door_trigger", "targetname" );

	// 3 versions. Either both guys exist, only 1 exist, or none

	if( isdefined( level.door_guys_1 ) && isdefined( level.door_guys_2 ) )
	{
		while( 1 )
		{	
			if( level.door_guys_1 istouching( ev2_door_trigger ) || level.door_guys_2 istouching( ev2_door_trigger ) )
			{
				for( i = 0; i < 30; i++ )
				{
					if( level.door_guys_1 istouching( ev2_door_trigger ) && level.door_guys_2 istouching( ev2_door_trigger ) )
					{
						wait( 1 );
						level notify( "move_tank_5_for_real" );
						return;
					}
					wait( 0.1 );
				}
				level notify( "move_tank_5_for_real" );
				return;
			}
			wait( 0.05 );
		}
	}

	else if( isdefined( level.door_guys_1 ) )
	{
		while( 1 )
		{	
			if( level.door_guys_1 istouching( ev2_door_trigger ) )
			{
				wait( 1 );
				level notify( "move_tank_5_for_real" );
				return;
			}
			wait( 0.05 );
		}
	}

	else
	{
		wait( 3 );
		level notify( "move_tank_5_for_real" );
		return;
	}

	level notify( "move_tank_5_for_real" );
}

ev2_go_open_barn_door_1()
{
	level.door_guys_1 = self;
	self thread magic_bullet_shield();
	self.goalradius = 16;
	self.ignoreall = true;
	self.pacifist = true;

	node = getnode( "ev2_barn_guy_death_1", "script_noteworthy" );
	self setgoalnode( node );

	level waittill( "move_tank_5_for_real" );
	wait( 0.5 );
	self stop_magic_bullet_shield();
	self.animname = "generic";
	self anim_single_solo( self, "death_explosion_back" );
	wait( 0.5 );
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

ev2_go_open_barn_door_2()
{
	level.door_guys_2 = self;
	self thread magic_bullet_shield();
	self.goalradius = 16;
	self.ignoreall = true;
	self.pacifist = true;

	node = getnode( "ev2_barn_guy_death_2", "script_noteworthy" );
	self setgoalnode( node );

	level waittill( "move_tank_5_for_real" );
	wait( 0.5 );
	self stop_magic_bullet_shield();

	if( distance( ( 4592.5, 8765.5, 63 ), self.origin ) < 200 )
	{
		self.animname = "generic";
		self anim_single_solo( self, "death_explosion_back" );
		wait( 0.5 );
		self dodamage( self.health + 100, ( 0, 0, 0 ) );
	}
}

ev2_road_ai_pathing()
{
	self endon( "death" );

	self hold_fire();

	self.goalradius = 64;
	start_node = getnode( self.script_noteworthy, "script_noteworthy" );

	self thread run_chain_nodes( start_node );
	self thread death_if_not_moving();
	self waittill( "chain_ends" );
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

death_if_not_moving()
{
	self endon( "death" );
	
	old_pos = self.origin;
	new_pos = old_pos;

	while( 1 )
	{
		wait( 2 );
		new_pos = self.origin;

		if( distance( new_pos, old_pos ) < 16 )
		{
			self notify( "chain_ends" );
			return;
		}
		else
		{
			old_pos = new_pos;
		}
	}
}

//--------------------------------------------------------------------------------------------------



ev2_loop_ambient_mg_burst()
{
	trigger = getent( "ev2_start_mg_burst", "targetname" );
	trigger waittill( "trigger" );

	start = getstruct( "ev2_mg_roof_pos", "targetname" );
	end = getstruct( "ev2_mg_roof_target", "targetname" );
	play_burst_fake_fire( 20, start.origin, end.origin );

	wait( 3 );

	play_burst_fake_fire( 20, start.origin, end.origin );
}

ev2_tank_loop_at_player()
{
	self endon( "death" );

	self waittill( "reached_end_node" );

	while( 1 )
	{
		// get closest player
		players = get_players();
		closest_index = 0;
		closest_index_radius = 99999;
		for( i = 0; i < players.size; i++ )
		{
			if( distance( players[i].origin, self.origin ) <= closest_index_radius )
			{	
				closest_index = i;
				closest_index_radius = distance( players[i].origin, self.origin );
			}
		}
		
		self.turretrotscale = 0.7;
		self SetTurretTargetVec( players[closest_index].origin + ( 0, 0, 40 ) );
		self waittill( "turret_on_target" );

		self FireWeapon();
		playfx( level._effect["tank_fire_dust"],self.origin );
		wait( 3 + randomfloat( 2 ) );
	}
}


//-------------------------------------------------------------------------------------


ev2_shreck_loop()
{
	level endon( "stop_shreck_loop" );
	level endon( "shreck_guy_killed" );
	
	shreck_points = getstructarray( "ev2_shreck_spawn", "targetname" );
	shreck_targets = getstructarray( "ev2_shreck_target", "targetname" );
	
	fire_point = 0;
	while( 1 )
	{
		level thread fire_shreck( shreck_points[fire_point], shreck_targets[randomint( shreck_targets.size )], 1 );
		fire_point++;
		fire_point = fire_point % shreck_points.size;
		wait( randomfloat( 2 ) );

		level thread fire_shreck( shreck_points[fire_point], shreck_targets[randomint( shreck_targets.size )], 1 );
		fire_point++;
		fire_point = fire_point % shreck_points.size;
		wait( randomfloat( 3 ) );

		level thread fire_shreck( shreck_points[fire_point], shreck_targets[randomint( shreck_targets.size )], 1 );
		fire_point++;
		fire_point = fire_point % shreck_points.size;
		wait( randomfloat( 4 ) );

		wait( 3 );
	}
}


ev2_shreck_barrage()
{
	level endon( "shreck_guy_killed" );

	shreck_points = getstructarray( "ev2_shreck_spawn", "targetname" );
	shreck_targets = getstructarray( "ev2_shreck_barrage_target", "targetname" );

	flag_wait( "ev2_tank_friend_in_position" );
	level thread dialog_panzershreck_window();

	level notify( "stop_shreck_loop" );
	wait( 1 );

	level thread fire_shreck( shreck_points[0], shreck_targets[0], 1 );
	wait( 1 );
	level thread fire_shreck( shreck_points[1], shreck_targets[1], 1 );
	wait( 0.5 );
	level thread fire_shreck( shreck_points[2], shreck_targets[2], 1 );
	level notify( "tank_killed_by_shreck" );

	wait( 3 );

	//exploder( 202 );
	level notify( "main_building_blown_up" );
}


pacing_get_on_tank_1( tank )
{
	player = undefined;

	while( 1 )
	{
		player = get_player_pressing_use_button();
		if( distance( player.origin, tank GetTagOrigin( "tag_passenger9" ) ) < 150 )
		{	
			attached_guys = tank.attachedguys;
			if( attached_guys.size > 0 )
			{
				attached_guys[0].animname = "generic";
				attached_guys[0] say_dialogue( "generic", "no_room1" );
			}
			wait( 2 );
		}
		wait( 0.1 );
	}
}

pacing_get_on_tank_2( tank )
{
	player = undefined;

	while( 1 )
	{
		player = get_player_pressing_use_button();
		if( distance( player.origin, tank GetTagOrigin( "tag_passenger9" ) ) < 150 )
		{	
			attached_guys = tank.attachedguys;
			if( attached_guys.size > 0 )
			{
				attached_guys[0].animname = "generic";
				attached_guys[0] say_dialogue( "generic", "no_room2" );
			}
			wait( 2 );
		}
		wait( 0.1 );
	}
}

pacing_get_on_tank_3( tank )
{
	player = undefined;
	button_held = false;

	while( 1 )
	{
		tank makevehicleusable();
		while( level.ev2_tank_3_can_mount == false )
		{
			wait( 0.05 );
		}

		while( 1 )
		{
			player = get_player_pressing_use_button();
			distance_tag_9 = distance( player.origin, tank GetTagOrigin( "tag_passenger9" ) );
			if( distance_tag_9 < 150 )
			{	
				break;
			}
			wait( 0.1 );
		}

		tank makevehicleunusable();
		level.ev2_tank_3_can_mount = false;

		level.ev2_player_mounted = true;

		origin_linker = spawn( "script_origin", tank gettagorigin( "tag_passenger9" ) );
		origin_linker.angles = tank gettagangles( "tag_passenger9" );
		origin_linker linkto( tank, "tag_passenger9", ( 0, 0, -10 ) );
		player playerlinktodelta( origin_linker, undefined, 1.0 );
		//player PlayerLinkTo( tank, "tag_passenger9", 1.75, 180, 180, 180, 180  );
		player AllowStand( false );
		player Allowcrouch( true );
		player allowprone( false );
		player SetStance( "crouch" );

		wait( 2 );

		while( 1 )
		{
			if( player UseButtonPressed() )
			{
				button_held = true;
				for( i = 0; i < 15; i++ )
				{	
					if( player UseButtonPressed() == false )
					{
						button_held = false;
						break;
					}
					wait( 0.05 );
				}

				if( button_held )
				{
					break;
				}
			}
			wait( 0.1 );
		}

		player unlink();
		player AllowStand( true );
		player Allowcrouch( true );
		player allowprone( true );
		player SetStance( "stand" );
		
		origin_linker delete();

		level.ev2_player_mounted = false;

		wait( 1 );
	
		level.ev2_tank_3_can_mount = true;
	}
}

pacing_get_on_tank_3b( tank )
{
	level thread force_players_off_tank( tank );

	level.tank_spot_1_available = true;
	level.tank_spot_2_available = true;
	level.tank_spot_1_guy = undefined;
	level.tank_spot_2_guy = undefined;

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		level thread ev2_player_get_on_tank( players[i], tank );
	}

	level thread check_for_leaving_players();

	flag_wait( "tank3_in_position_after_ride" );
	//while( level.ev2_tank_3_can_mount )
	//{
	//	wait( 0.1 );
	//}
	flag_set( "tank_ride_over" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( isdefined( players[i].Warning_hud ) )
		{
			players[i].Warning_hud SetText("");
			players[i].Warning_hud delete();
		}
	}
}

force_players_off_tank( tank )
{
	level waittill( "tank3_at_first_stop" );
	wait( 1 );
	start_wait_node = getvehiclenode( "ev2_tank_get_off_node", "script_noteworthy" );
	tank setwaitnode( start_wait_node );
	tank waittill( "reached_wait_node" );

	flag_set( "tank_ride_over" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( isdefined( players[i].Warning_hud ) )
		{
			players[i].Warning_hud SetText("");
			players[i].Warning_hud delete();
		}
	}
}

ev2_player_get_on_tank( player, tank )
{
	take_spot = 0;
	origin_linker = undefined;
	button_held = false;

	player.Warning_hud = newClientHudElem(player);
	player.Warning_hud.alignX = "center";
	player.Warning_hud.x = 450;
	player.Warning_hud.y = 300;
	player.Warning_hud.alignX = "right";
	player.Warning_hud.alignY = "bottom";
	player.Warning_hud.fontScale = 1.5;
	player.Warning_hud.alpha = 1.0;
	player.Warning_hud.sort = 20;
	player.Warning_hud.font = "default";
	player.Warning_hud FadeOverTime( 1 ); 

	while( 1 )
	{
		if( flag( "tank_ride_over" ) )
		{
			return;
		}

		// if no spots available, wait till one becomes available
		while( level.tank_spot_1_available == false && level.tank_spot_2_available == false )
		{
			wait( 0.1 );
		}

		// now wait untill the player makes an appropriate input
		while( 1 )
		{

			// if player is close enough, show icon text
			distance_tag_8 = distance( player.origin, tank GetTagOrigin( "tag_passenger8" ) );
			distance_tag_9 = distance( player.origin, tank GetTagOrigin( "tag_passenger9" ) );

			if( distance_tag_8 < 150 || distance_tag_9 < 150 )
			{
				if( isdefined( player.Warning_hud ) )
				{
					player.Warning_hud SetText(&"SEE1_RIDE_TANK");
				}
			}
			else
			{	
				if( isdefined( player.Warning_hud ) )
				{
					player.Warning_hud SetText("");
				}
			}

			if( player UseButtonPressed() )
			{
				if( distance_tag_8 < 150 || distance_tag_9 < 150 )
				{	
					// player is ready to mount. double check the spot is available
					if( level.tank_spot_1_available )
					{
						level.tank_spot_1_available = false;
						level.tank_spot_1_guy = player;
						take_spot = 1;
						if( isdefined( player.Warning_hud ) )
						{
							player.Warning_hud SetText("");
						}
						break;
					}
					else if( level.tank_spot_2_available )
					{
						level.tank_spot_2_available = false;
						level.tank_spot_2_guy = player;
						take_spot = 2;
						if( isdefined( player.Warning_hud ) )
						{
							player.Warning_hud SetText("");
						}
						break;
					}
				}
			}
			wait( 0.05 );
		}

		// now get on the spot
		if( take_spot == 1 )
		{
			origin_linker = spawn( "script_origin", tank gettagorigin( "tag_passenger8" ) );
			origin_linker.angles = tank gettagangles( "tag_passenger8" );
			origin_linker linkto( tank, "tag_passenger8", ( 0, 0, -10 ) );
			//origin_linker linkto( tank, "tag_passenger8", ( 0, 0, 0 ) );
			player playerlinktodelta( origin_linker, undefined, 1.0 );
			player AllowStand( false );
			player Allowcrouch( true );
			player allowprone( false );
			player SetStance( "crouch" );
		}
		else if( take_spot == 2 )
		{
			origin_linker = spawn( "script_origin", tank gettagorigin( "tag_passenger9" ) );
			origin_linker.angles = tank gettagangles( "tag_passenger9" );
			origin_linker linkto( tank, "tag_passenger9", ( 0, 0, -10 ) );
			//origin_linker linkto( tank, "tag_passenger9", ( 0, 0, 0 ) );
			player playerlinktodelta( origin_linker, undefined, 1.0 );
			player AllowStand( false );
			player Allowcrouch( true );
			player allowprone( false );
			player SetStance( "crouch" );
		}

		wait( 2 );

		if( isdefined( player.Warning_hud ) )
		{
			if( level.console )
				player.Warning_hud SetText(&"SEE1_OFF_TANK");
			else
				player.Warning_hud SetText(&"SCRIPT_PLATFORM_OFF_TANK");
		}

		while( 1 )
		{
			if( flag( "tank_ride_over" ) )
			{
				break;
			}
			else if( player UseButtonPressed() )
			{
				button_held = true;
				for( i = 0; i < 10; i++ )
				{	
					if( player UseButtonPressed() == false )
					{
						button_held = false;
						break;
					}
					if( flag( "tank_ride_over" ) )
					{
						button_held = true;
						break;
					}
					wait( 0.05 );
				}

				if( button_held )
				{
					break;
				}
			}
			wait( 0.1 );
		}

		// now get the player off

		player unlink();
		player AllowStand( true );
		player Allowcrouch( true );
		player allowprone( true );
		//player SetStance( "stand" );
		
		origin_linker delete();
				
		if( isdefined( player.Warning_hud ) )
		{
			player.Warning_hud SetText("");
		}

		wait( 1 );
		if( take_spot == 1 )
		{
			level.tank_spot_1_available = true;
			level.tank_spot_1_guy = undefined;
		}
		else if( take_spot == 2 )
		{
			level.tank_spot_2_available = true;
			level.tank_spot_2_guy = undefined;
		}

		wait( 0.5 );
	}
}

check_for_leaving_players()
{
	while( !flag( "tank_ride_over" ) )
	{
		if( level.tank_spot_1_available == false )
		{
			players = get_players();
			match = false;
			for( i = 0; i < players.size; i++ )
			{
				if( level.tank_spot_1_guy == players[i] )
				{
					match = true;
				}
			}

			if( match == false )
			{
				level.tank_spot_1_guy = undefined;
				level.tank_spot_1_available = true;
			}	
		}

		if( level.tank_spot_2_available == false )
		{
			players = get_players();
			match = false;
			for( i = 0; i < players.size; i++ )
			{
				if( level.tank_spot_2_guy == players[i] )
				{
					match = true;
				}
			}

			if( match == false )
			{
				level.tank_spot_2_guy = undefined;
				level.tank_spot_2_available = true;
			}	
		}

		wait( 0.5 );
	}
}


ev2_mount_player_on_tank_1()
{

}

get_player_pressing_use_button()
{
	players = get_players();
	while( 1 )
	{
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] UseButtonPressed() )
			{
				return( players[i] );
			}
		}
		wait( 0.1 );
	}
}

ev2_panzershreck_barrage( start, end )
{
	level endon( start );

	start_struct = getstruct( start, "targetname" );
	
	ends = getstructarray( end, "targetname" );
	
	index = 0;

	while( 1 )
	{
		wait( randomfloat( 2 ) );
		level thread fire_shreck( start, ends[index], 1 );
		index++;
		index = index % ends.size;
		wait( 3 );
		wait( randomfloat( 2 ) );
	}
}



//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
/* AI Script: Tanks

	Use: thread ev2_tank_think on a tank, then ev2_tank_start_on_path to move it

	- The tank loops between 3 connected rails, with starting nodes "start_node",
	  "retreat_node_1", "retreat_node_2", To make the tank start on a separate rail
	  instead of start_node, use ev2_tank_start_on_different_path(). After finishing 
 	  that rail the tank will be back on the loop

	- Tank can only be destroyed by mantling or 2 explosion damages from player

	- "init_target" - Target the tank will loop firing on initially. It will also resume
      firing there if player gets out of line of sight

	- "init_delay" - Tank does not fire in the first few seconds

	- "buddy_tank" - If tank has a buddy tank, and that gets destroyed, tank will react.

	- "init_react_dist" - Distance the player needs to approach tank for it to react.

	- Reaction - Tank reacts if it feels threatened. When stationary, it reacts by moving
	  along the rail a bit. When moving, it reacts by stoping. The tank will only target
	  the player if the player causes the tank damage. Tank loses track of player if he's
	  out of line of sight, or proning in the wheat field.
*/
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


	ev2_tank_start_on_path()
	{
		self attachPath( self.see1_tank_start_nodes[self.current_path ] );
		self startpath();
		self notify( "start_moving" );
	}
	
	ev2_tank_start_on_different_path( node )
	{
		self attachPath( node );
		self startpath();
		self notify( "start_moving" );
	}
	
	ev2_tank_think( start_node, init_target, init_delay, retreat_node_1, retreat_node_2, buddy_tank, init_react_dist )
	{
		self endon( "death" );

		self.cook_off_chance = 80;
	
		// initial target to loop fire on
		self.see1_tank_current_target = getent( init_target, "targetname" );
	
		// start nodes. The tank will move from one to the next, and loop around.
		self.see1_tank_start_nodes[0] = getvehiclenode( start_node, "targetname" );
		if( isdefined( getvehiclenode( retreat_node_1, "targetname" ) ) )
		{
			self.see1_tank_start_nodes[1] = getvehiclenode( retreat_node_1, "targetname" );
		}
		if( isdefined( getvehiclenode( retreat_node_2, "targetname" ) ) )
		{
			self.see1_tank_start_nodes[2] = getvehiclenode( retreat_node_2, "targetname" );
		}
		self.current_path = 0;
	
		self.see1_tank_aggressive = false;
		self.see1_tank_moving = false;
		self.see1_tank_reached_end_node = false;
		self.see1_tank_moved_once = false;
		self.see1_tank_can_see_player = true;
		self.team = "axis";
	
		self thread check_for_panzershreck_hit( 2 );
	
		self thread ev2_tank_threat_manager();
	
		if( isdefined( init_react_dist ) )
		{
			self thread ev2_wait_for_player_to_get_close( 450, init_react_dist );
		}
		else
		{
			self thread ev2_wait_for_player_to_get_close( 450, 450 );
		}
	
		init_target_ent = getent( init_target, "targetname" );
		self thread ev2_tank_loop_fire( init_delay, "stop_looping_fire", init_target_ent );
		self thread ev2_tank_movement();
		self thread ev2_tank_end_node_detection();
		self thread ev2_wait_for_buddy_tank_death( buddy_tank );
		self thread ev2_check_los();
	}
	
	ev2_tank_loop_fire( init_delay, end_msg, init_target )
	{
		self endon( end_msg );	
		self endon( "death" );
	
		wait( init_delay );
	
		while( 1 )
		{
			// modify the tank turret turning
			if( isplayer( self.see1_tank_current_target ) )
			{
				if( self.see1_tank_can_see_player )
				{
					if( self.see1_tank_aggressive )
					{
						self.turretrotscale = 1; // 3
						//self SetTurretTargetEnt( self.see1_tank_current_target );
						self SetTurretTargetVec( self.see1_tank_current_target.origin + ( 0, 0, 40 ) );
					}
					else
					{
						// turret turns slowly when aiming at player
						self.turretrotscale = 1;
						// targets player's position, instead of locking on. Allowing player a chance to escape
						self SetTurretTargetVec( self.see1_tank_current_target.origin + ( 0, 0, 60 ) );
					}
				}
				else
				{
					self.turretrotscale = 1;
					self SetTurretTargetVec( init_target.origin + ( 0, 0, 60 ) );
				}
			}
			else
			{
				self.turretrotscale = 2;
				self SetTurretTargetEnt( self.see1_tank_current_target );
			}
	
			self waittill( "turret_on_target" );
	
			// modify firing time (give player a chance to move away)
			if( isplayer( self.see1_tank_current_target ) )
			{
				wait( 1 );
		
				// if the player is prone in the wheetfield, search for him
				player_hiding = false;
				continue_search = true;
				wheat_field_triggers = getentarray( "ev2_wheat_field", "targetname" );
	
				while( continue_search )
				{
					if( self.see1_tank_current_target getstance() != "prone" )
					{
						continue_search = false;
						continue;
					}
	
					if( ( self.see1_tank_current_target istouching( wheat_field_triggers[0] ) ) == false  && 
						( self.see1_tank_current_target istouching( wheat_field_triggers[1] ) ) == false )	
					{
						continue_search = false;
						continue;
					}
	
					wait( 2 );
					self SetTurretTargetVec( self.see1_tank_current_target.origin + ( randomint( 600 ) - 300, randomint( 600 ) - 300, 40 ) );
					self waittill( "turret_on_target" );
				}
			}
	
			self FireWeapon();
			playfx( level._effect["tank_fire_dust"],self.origin );
			wait( 2 + randomfloat( 2 ) );
		}
	}
	
	ev2_tank_threat_manager()
	{
		self endon( "death" );
	
		while( 1 )
		{
			self waittill( "damage", amount, attacker, direction_vec, point, type );
			if( isplayer( attacker ) )
			{
				if( type == "MOD_PROJECTILE_SPLASH" || type == "MOD_PROJECTILE" )
				{
					self.see1_tank_current_target = attacker;
					//iprintlnbold( "Target: Player" );
					//break;
				}
			}
		}
	}
	
	ev2_wait_for_player_to_get_close( final_dist, dist_init )
	{
		self endon( "death" );
		
		players = get_players();
		dist = dist_init;
	
		while( 1 )
		{
			for( i = 0; i < players.size; i++ )
			{	
				if( isdefined( players[i] ) && distance( players[i].origin, self.origin ) < dist )
				{
					dist = final_dist;
					self notify( "player_getting_close" );
					//iprintlnbold( "Too Close" );
					self.see1_tank_current_target = players[i];
					//iprintlnbold( "Target: Player" );
	
					// if the tank moves due to player getting too close. It should 
					// not check again until it stops moving, then wait 2 secs
					wait( 1.5 );
	
					while( self.see1_tank_moving )
					{
						wait( 0.05 );
					}
	
					wait( 2 );
				}
			}
			wait( 0.5 );
		}
	}
	
	ev2_tank_end_node_detection()
	{
		self endon( "death" );
		
		while( 1 )
		{
			self waittill( "start_moving" );
			self.see1_tank_moving = true;
			self.see1_tank_reached_end_node = false;
			self waittill( "reached_end_node" );
			self.see1_tank_moving = false;
			self.see1_tank_reached_end_node = true;
		}
	}
	
	ev2_tank_movement()
	{
		self endon( "death" );
		self endon( "tank_mantle_begin" );

		// stop movement when tank is being mantled
		//self thread ev2_tank_movement_stop_mantle();
	
		if( isdefined( self.see1_tank_no_stop_time ) )
		{
			wait( self.see1_tank_no_stop_time );
		}

		while( 1 )
		{
			self waittill_either( "hit_damage", "player_getting_close" );
		
			if( self.see1_tank_reached_end_node )
			{
				self.current_path++;
				self.current_path = self.current_path % self.see1_tank_start_nodes.size;
		
				wait( 1 );
				self thread ev2_tank_start_on_path();
				//iprintlnbold( "New Path Starts" );
			}
			else
			{
				self setspeed( 0, 5, 5 );
				//iprintlnbold( "Stop" );
				self.see1_tank_moving = false;
				wait( 4 );
				self resumespeed( 5 );
				self.see1_tank_moving = true;
				wait( 2 );
			}
		}
	}
	
	ev2_tank_movement_stop_mantle()
	{
		self endon( "death" );
		self waittill( "tank_mantle_begin" );

		self setspeed( 0, 5, 5 );
	}

	ev2_wait_for_buddy_tank_death( buddy_tank )
	{
		self endon( "death" );
	
		if( !isdefined( buddy_tank ) )
		{
			return;
		}
		
		buddy_tank waittill( "death" );

		self notify( "hit_damage" );
	}
	
	ev2_check_los()
	{
		self endon( "death" );
		
		while( 1 )
		{
			if( isplayer( self.see1_tank_current_target ) )
			{
				// can we see him
				if( bullettracepassed( self.origin + ( 0, 0, 50 ), self.see1_tank_current_target getEye(), false, self ) )
				{
					wait( 1 );
					self.see1_tank_can_see_player = true;
				}
				else
				{
					wait( 2 );
					self.see1_tank_can_see_player = false;
				}
			}
			wait( 0.5 );
		}
	}


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

ev2_road_ai_side()
{
	self endon( "death" );
	self.goalradius = 16;
	
	fake_target = getent( "ev2_pacing_firing_target", "targetname" );
	self SetEntityTarget( fake_target, 1 );

	trigger = getent( "ev2_pacing_plane_2", "targetname" );
	trigger waittill( "trigger" );
	wait( 2 );

	node = getnode( "ev2_pacing_death_node", "script_noteworthy" );
	self setgoalnode( node );
	self waittill( "goal" );
	self dodamage( self.health + 100, (0,0,0) );
}

ev2_force_delete_enemies_barn()
{
	enemies = getaiarray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		if( distance( enemies[i].origin, (4473, 8738, -105.4) ) > 1200 )
		{
			enemies[i] delete();
		}
	}
}

ev2_cleanup()
{
	level.barn_door_kick delete();
	level.barn_door_tank delete();

	delete_ent_array( "ev2_spawn_t34s", "targetname" );
	delete_ent_array( "end_forest", "targetname" );
	delete_ent_array( "ev2_explosion_trigger", "targetname" );
	delete_ent_array( "ev2_spawn_battle_1", "targetname" );
	delete_ent_array( "ev2_got_close_to_enemies", "targetname" );
	delete_ent_array( "ev2_move_tank_1", "targetname" );
	delete_ent_array( "ev2_shot_at_enemies", "targetname" );
	delete_ent_array( "ev2_wheat_field", "targetname" );
	delete_ent_array( "ev2_tank_battle_2", "targetname" );
	delete_ent_array( "ev2_start_mg_burst", "targetname" );
	delete_ent_array( "ev2_tank_battle_3", "targetname" );
	delete_ent_array( "ev2_stop_last_flood", "targetname" );
	delete_ent_array( "ev2_regroup_barn", "targetname" );
	delete_ent_array( "ev2_door_trigger", "targetname" );
	delete_ent_array( "ev2_door_guys_spawn", "targetname" );
	delete_ent_array( "ev2_move_tank_5", "targetname" );
	delete_ent_array( "ev2_pacing_plane_1", "targetname" );
	delete_ent_array( "ev2_pacing_plane_2", "targetname" );


	delete_ent_array( "ev2_spawners_cleanup", "script_noteworthy" );
	delete_ent_array( "ev2_barn_inside", "script_noteworthy" );
	delete_ent_array( "ev2_barn_inside_2", "script_noteworthy" );
	delete_ent_array( "ev2_road_flood_1", "script_noteworthy" );
	delete_ent_array( "ev2_road_flood_2", "script_noteworthy" );
	delete_ent_array( "ev2_road_flood_3", "script_noteworthy" );
	delete_ent_array( "ev2_road_flood_4", "script_noteworthy" );
	delete_ent_array( "ev2_road_flood_5", "script_noteworthy" );

	//level.ev2_tank1 delete();
	//level.ev2_tank2 delete();
	//level.ev2_tank3 delete();
	//level.ev2_tank4 delete();
	//level.ev2_tank5 delete();
}

dialog_lead_charge()
{
	trigger = getent( "ev2_spawn_t34s", "targetname" );
	trigger waittill( "trigger" );
	level.hero1 say_dialogue( "reznov", "lead_charge" );
}

dialog_panzershreck()
{
	trigger = getent( "ev2_initial_ai_spawn_extra", "targetname" );
	trigger waittill( "trigger" );

	level.hero1 say_dialogue( "reznov", "over_balcony" );
	level.hero1 say_dialogue( "reznov", "panzershrecks" );
	wait( 0.5 );
	level.hero1 say_dialogue( "reznov", "stall_advance" );
	level.hero1 say_dialogue( "reznov", "protect_armor" );
}

dialog_more_panzershreck()
{
	//level.hero1 say_dialogue_wait( "reznov", "more_panzershreck" );

}

dialog_tanks_appear()
{
	wait( 2 );
	level.hero2 say_dialogue( "chernov", "tanks_approach" );
	//level.hero1 say_dialogue( "reznov", "turn_weapons" );

	wait( 3 );
	//level.hero1 say_dialogue( "reznov", "boil_steel" );
	level.hero1 say_dialogue( "reznov", "use_rockets" );
}

dialog_infantry_wheat_field()
{
	//level.hero1 say_dialogue( "reznov", "infantry_wheat" );
	//level.hero1 say_dialogue( "reznov", "torch_them" );
}

dialog_tank_1_success()
{
	flag_wait( "ev2_tank1_destroyed" );
	//level.hero1 say_dialogue( "reznov", "weaken_aim" );
	level.hero1 say_dialogue( "reznov", "hero_of_staling" );
}

dialog_tank_3_success()
{
	flag_wait( "ev2_tank3_destroyed" );

	if( !flag( "ev2_tank1_destroyed" ) || !flag( "ev2_tank2_destroyed" ) || !flag( "ev2_tank4_destroyed" ) )
	{
		level.hero1 say_dialogue( "reznov", "turn_weapons" );
		level.hero1 say_dialogue_wait( "reznov", "boil_steel" );
	}
}

dialog_tank_2_success()
{
	level.hero1 say_dialogue( "reznov", "armor_no_match" );

	wait( 1 );

	level.hero1 say_dialogue( "reznov", "more_tanks" );
	level.hero1 say_dialogue( "reznov", "fire" );
	level.hero1 say_dialogue( "reznov", "last_one_burns" );
}

dialog_panzershreck_window()
{
	level.hero2 say_dialogue( "chernov", "panzer_window" );
	level.hero1 say_dialogue( "reznov", "let_armor_deal" );
	//level waittill( "main_building_blown_up" );
	//level.hero1 say_dialogue( "reznov", "ha" );
}

dialog_run_to_barn()
{
	level.hero1 say_dialogue( "reznov", "regroup_barn" );
	//level.hero1 say_dialogue( "reznov", "prepare_push" );
}

dialog_regroup_at_barn()
{
	ev2_force_delete_enemies_barn();

	players = get_players();

	level.hero1 say_dialogue( "reznov", "time_weaken_aim" );
	level.hero1 say_dialogue( "reznov", "learn_much" );
	//level.hero1 say_dialogue( "reznov", "enough_talk" );
	ev2_force_delete_enemies_barn();
	level notify( "ev2_regroup_open_barn_door" );
	level.hero1 say_dialogue( "reznov", "break_door" );
	level.hero1 say_dialogue( "reznov", "cowards_shadows" );
	ev2_force_delete_enemies_barn();
}


dialog_tank_surprise()
{
	level.hero1 say_dialogue_wait( "reznov", "another_tank" );
	ev2_force_delete_enemies_barn();
	level.hero1 say_dialogue( "reznov", "take_it_down" );
}

dialog_tank_5_success()
{
	level thread dialog_pacing_shoot_enemies();

	//level.hero1 say_dialogue( "reznov", "hide_cowards" );
	//wait( 1 );
	//level.hero1 say_dialogue( "reznov", "learn_much" );
	level.hero1 say_dialogue( "reznov", "relish" );
	level.hero1 say_dialogue( "reznov", "die_vermin" );
	
	flag_set( "barn_door_anim_ready" );
	//level.hero1 say_dialogue( "reznov", "enough_talk" );

	level waittill( "barn_kick_exit_done" );

	level thread wait_play_text_on_screen();
	level.hero1 say_dialogue( "reznov", "ride_tanks" );
	level.hero1 say_dialogue( "reznov", "you_walk" );

	//level thread print_text_on_screen( &"SEE1_RIDE_TANK" );
}

wait_play_text_on_screen()
{
	wait( 2 );
	//level thread print_text_on_screen( &"SEE1_RIDE_TANK" );
}

dialog_pacing_shoot_enemies()
{	
	trigger = getent( "ev2_pacing_plane_1", "targetname" );
	trigger waittill( "trigger" );

	//level.hero2 say_dialogue( "chernov", "germans_field" );
	//level.hero1 say_dialogue( "reznov", "cockroaches" );
	//level.hero1 say_dialogue( "reznov", "pick_them_off" );
}


ev2_panzershreck_respawns()
{
	level thread ev2_panzershreck_single_respawn( "ev2_respawn_shreck1" );
	level thread ev2_panzershreck_single_respawn( "ev2_respawn_shreck2" );
	level thread ev2_panzershreck_single_respawn( "ev2_respawn_shreck3" );
	level thread ev2_panzershreck_single_respawn( "ev2_respawn_shreck4" );
	level thread ev2_panzershreck_single_respawn( "ev2_respawn_shreck5" );
}

ev2_panzershreck_single_respawn( rocket_name )
{
	respawn_schrek = getent( rocket_name, "targetname" );	
	respawn_origin = respawn_schrek.origin;
	respawn_angles = respawn_schrek.angles;

	glowy_model = spawn( "script_model", respawn_origin );
	glowy_model.angles = respawn_angles;
	glowy_model SetModel( "weapon_ger_panzerschreck_at_obj" );

	// glowy model
	//glowy_model = spawn( "script_model", respawn_origin );
	//glowy_model.angles = respawn_angles;
	//glowy_model SetModel( "weapon_usa_bazooka_at_obj" );

	while( 1 )
	{
	
		if( !isdefined( respawn_schrek ) )
		{
			if( isdefined( glowy_model ) )
			{
				glowy_model delete();	
			}

			respawn_schrek = spawn( "weapon_panzerschrek", respawn_origin, 1 );
			respawn_schrek.angles = respawn_angles;		
		}	
	
		wait( 1 );
		
	}

}


#using_animtree( "generic_human" );
collectible_corpse()
{

	orig = getstruct( "see1_collect_anim", "targetname" );

	corpse = spawn( "script_model", orig.origin );
	corpse.angles = orig.angles;
	corpse character\char_ger_wrmcht_k98::main(); 
	if( level.wii == false )
	{
		corpse detach( corpse.gearModel );
	}
	corpse UseAnimTree( #animtree );
	corpse.animname = "collectible";
	corpse.targetname = "collectible_corpse";

	level anim_loop_solo( corpse, "collectible_loop", undefined, "stop_collectible_loop", orig );
	
}
