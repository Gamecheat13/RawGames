/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 3/13/2012
 * Time: 1:56 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#include common_scripts\utility;
#include maps\_dialog;
#include maps\_objectives;
#include maps\_scene;
#include maps\_utility;

// internal references
#include maps\blackout_util;
#include maps\blackout_sensitive_geo;

defend_turret_callback( turret_active )
{
	ais = GetAIArray( "axis" );
	
	foreach ( ai in ais )
	{
		ai defend_objective_spawn_func();
	}
}

defend_objective_spawn_func()
{
	goal_volume = undefined;
	
	// most of these guys are haphazard.
	if ( rand_chance( 0.8 ) )
	{
		self set_ignoreSuppression( true );
	}
	
	if ( !flag( "player_using_turret" ) )
	{
		if ( rand_chance( 0.3 ) )
		{
			// send a minority portion INTO the defend room.
			goal_volume = GetEnt( "defend_objective_room_volume", "targetname" );
		} else {
			goal_volume = GetEnt( "security_defend_volume", "targetname" );
		}
	} else {
		goal_volume = GetEnt( "turret_goal_volume", "targetname" );
	}
	
	self SetGoalVolumeAuto( goal_volume );
}

// tracks how many bad guys are in the defend room.
// once it gets to a certain number, the hacker becomes vulnerable.
//
defend_volume_watcher()
{
	self endon( "defend_success" );
	self endon( "death" );
	
	num_attackers = 0;
	const num_attackers_fail = 3;
	volume = GetEnt( "defend_objective_room_volume", "targetname" );
	
	// just to be sure.
	self magic_bullet_shield();
	vulnerable = false;
	
	// he's invulnerable for a little while.
	wait 8.0;
	
	// take a snapshot once every second to see how many people are in range of our bro-man.
	while ( true )
	{
		if ( (!vulnerable) && num_attackers >= num_attackers_fail )
		{
			vulnerable = true;
			self stop_magic_bullet_shield();
		} else if ( vulnerable && num_attackers < num_attackers_fail ) {
			vulnerable = false;
			self magic_bullet_shield();
		}
		wait 1.0;
		
		attackers = get_ai_touching_volume( "axis", undefined, volume );
		num_attackers = attackers.size;
	}
}

defend_watcher()
{
	self endon( "defend_success" );
	
	self thread defend_volume_watcher();
	
	self waittill( "death" );
	MissionFailedWrapper( &"BLACKOUT_DEFEND_FAIL" );
}

defend_volume_nag()
{
	self endon( "death" );
	level endon( "defend_objective_complete" );
	
	while ( true )
	{
		flag_wait( "hacker_abandon_active" );
		lines = [];
		lines[0] = "sail_sir_where_are_you_g_0";
		lines[1] = "sail_sir_get_back_over_h_0";
//		self say_dialog( random(lines) );
		
		wait RandomFloatRange( 4.0, 6.0 );
	}
}

// see if the player's still in the defend volume.  if not, count
// to fail_time, then allow the defend target to be killed.
//
watch_defend_volume( hacker, volume_name, fail_time )
{
	hacker endon( "defend_success" );
	hacker endon( "death" );
	
	flag_init( "hacker_abandon_active", false );
	
	level.defenders[0] thread defend_volume_nag();
	
	volume = GetEnt( volume_name, "targetname" );
	
	counter = 0;
	while ( true )
	{
		// as long as the player is near the hacker, don't punish him.
		if ( is_point_inside_volume( level.player.origin, volume ) )
		{
			flag_clear( "hacker_abandon_active" );
			counter = 0;
		}
		else
		{
			flag_set( "hacker_abandon_active" );
			counter = counter + 1;
			
			// when the counter has passed the "fail time", start shooting at the hacker more.
			if ( counter > fail_time )
			{
				// until they get back in the volume, shoot the hacker, a lot.
				kill_attempts = 0;
				max_kill_attempts = 20;
				while ( !is_point_inside_volume( level.player.origin, volume ) && kill_attempts < max_kill_attempts )
				{
					enemies = GetAIArray( "axis" );
					for ( i = 0; i < enemies.size; i++ )
					{
						enemy = enemies[i];
						if ( enemy CanSee( hacker ) )
						{
							enemy.perfectAim = true;
							enemy thread shoot_and_kill( hacker );
							break;
						}
					}
					
					wait 1.0;
					kill_attempts = kill_attempts + 1;
				}
				
				if ( kill_attempts >= max_kill_attempts )
				{
					hacker stop_magic_bullet_shield();
					hacker bloody_death();
				}
			}
		}
		
		wait 1.0;
	}
}

watch_fail_volume( hacker )
{
	hacker endon( "defend_success" );
	hacker endon( "death" );
	
	trigger_wait( "defend_fail_trigger" );
	
	hacker stop_magic_bullet_shield();
	hacker bloody_death();
}

enable_breach_nodes( str_node_name, do_enable )
{
	nodes = GetNodeArray( str_node_name, "script_noteworthy" );
	
	for ( i = 0; i < nodes.size; i++ )
	{
		SetEnableNode( nodes[i], do_enable );
	}
}

// Bad dudes break into your defend area.  Bummer.
//
door_open( door_name, delete_door )
{
	door = GetEnt( door_name, "targetname" );
	
	collision = GetEnt( door.target, "targetname" );
	
	collision ConnectPaths();
	
	if ( IsDefined(delete_door) )
	{
		if ( delete_door )
		{
			collision Delete();
			door Delete();
		}
	}
}

door_breach_right()
{
	level waittill( "door_bash_right" );
	
	s_breach_pos = GetStruct( "door_breach_pos_right", "targetname" );
	level.player waittill_player_not_looking_at( s_breach_pos.origin, 0.4, true );
	
	run_scene_and_delete( "door_bash_right" );
	
	enable_breach_nodes( "right_breach_node", true );
	door_open( "defend_door_right" );
	
	level.defend_hacker say_dialog( "sail_they_have_breached_t_1" );
}

// Handle the case of the player killing the PMC before the scene ends.
//
door_breach_left_death_watcher( bad_dude )
{
	level endon( "left_breach_succeeded" );
	
	bad_dude waittill_either( "death", "pain_death" );
	
	if ( scene_is_playing( "door_bash_left_start" ) )
	{
		end_scene( "door_bash_left_start" );
	}
	
	if ( scene_is_playing( "door_bash_left_wait" ) )
	{
		end_scene( "door_bash_left_wait" );
	}
	
	flag_set( "left_breach_saved" );
	
	// he's no longer a defender, even if he did survive.
	level.defenders[1] stop_magic_bullet_shield();
	ArrayRemoveIndex( level.defenders, 1 );
}

door_breach_left()
{	
	// wait for the door bash to be triggered.
	level waittill( "door_bash_left" );
	
	// make sure the player can't see where this bro spawns in.
	s_breach_pos = GetStruct( "door_breach_pos_left", "targetname" );
	level.player waittill_player_not_looking_at( s_breach_pos.origin, 0.4, true );
	
	// if it's already complete, forget about it.
	if ( flag( "defend_objective_complete" ) )
	{
		return;
	}
	
	bad_dude = simple_spawn_single( "door_bash_pmc02" );
	
	// start the door bash.
	level thread run_scene_and_delete( "door_bash_left_start" );
	
	// respond correctly to the bad dude dying.
	level thread door_breach_left_death_watcher( bad_dude );
	
	// wait for the "start bashing" scene finishes.
	scene_wait( "door_bash_left_start" );
	
	// Bail if the PMC died.
	if ( flag( "left_breach_saved" ) )
	{
		return;
	}
	
	// start the wait loop.
	level thread run_scene_and_delete( "door_bash_left_wait" );
	waittill_trigger_timeout_or_notify( "left_breach_trigger", 8.0, "left_breach_saved" );
	
	// bail if the PMC died.
	if ( flag( "left_breach_saved" ) || !IsAlive( bad_dude ) )
	{
		if ( scene_is_playing( "door_bash_left_wait" ) )
		{
			end_scene( "door_bash_left_wait" );
		}
		return;
	}
	
	level notify( "left_breach_succeeded" );
	
	// he's no longer a defender, since he died.
	level.defenders[1] stop_magic_bullet_shield();
	ArrayRemoveIndex( level.defenders, 1 );
	
	// for this last little giblet of the scene, the PMC is invulnerable.
	bad_dude magic_bullet_shield();
	run_scene_and_delete( "door_bash_left" );
	enable_breach_nodes( "left_breach_node", true );
	door_open( "defend_door_left" );
	bad_dude stop_magic_bullet_shield();

	level.defend_hacker say_dialog( "sail_they_have_breached_t_0" );
}

defend_objective()
{
	level thread door_breach_left();
	level thread door_breach_right();
	
	enable_breach_nodes( "left_breach_node", false );
	enable_breach_nodes( "right_breach_node", false );
	
	// wait till we get close, then spawn the guys.
	trigger_wait( "security_defense_spawn_trigger" );
	
	trigger_off( "mason_security_feed_trigger", "targetname" );
	trigger_off( "cctv_room_trigger", "targetname" );
	
	level.defenders = [];
	level.defenders[0] = simple_spawn_single( "security_defender1", ::magic_bullet_shield );
	level.defenders[1] = simple_spawn_single( "security_defender2", ::magic_bullet_shield );
	
	// start the continuous spawning.
	spawn_manager_enable( "defend_start_enemy_sm" );
	
	sensitive_geo_set_warning_guy( level.defenders[0] );
	
	level thread run_scene_and_delete( "hacker_wait" );
	
	wait 0.2;
	
	hacker_list = get_ais_from_scene( "hacker_wait" );
	Assert( hacker_list.size == 1 );
	
	hacker = hacker_list[0];
	hacker magic_bullet_shield();
	level.defend_hacker = hacker;
	
	// fires when we actually enter the room.
	flag_wait( "at_defend_objective" );
	
	level.defend_hacker say_dialog( "sail_section_keep_these_0", 1.5 );
	
	hacker thread defend_watcher();
	
	// stop the continuous spawning.
	spawn_manager_disable( "defend_start_enemy_sm" );
	
	level thread watch_defend_volume( hacker, "security_defend_volume", 4.0 );
	level thread watch_fail_volume( hacker );
	
	run_scene_and_delete( "hacker_start" );
	level thread run_scene_and_delete( "hacker_hack" );
	
	set_objective( level.OBJ_DEFEND_HACKER, hacker, "protect" );
	
	add_spawn_function_ai_group( "security_defense_waves", ::defend_objective_spawn_func );
	
	spawn_manager_enable( "defend_sm_smg_w1" );
	
	wait 6;			// make sure some get spawned before checking.
	waittill_ai_group_ai_count( "security_defense_waves", 6 );
	
	spawn_manager_enable( "defend_sm_shotgun_w1" );
	
	wait 6;			// make sure some get spawned before checking.
	waittill_ai_group_ai_count( "security_defense_waves", 8 );
	
	level notify( "door_bash_right" );

	/*
	wait 6;			// make sure some get spawned before checking.
	waittill_ai_group_ai_count( "security_defense_waves", 6 );
	
	spawn_manager_enable( "defend_sm_shotgun_w2" );
	spawn_manager_enable( "defend_sm_assault_w1" );
	*/
	
	spawn_manager_enable( "defend_sm_smg_w3" );
	wait 6;
	waittill_ai_group_ai_count( "security_defense_waves", 6 );
	
	level notify( "door_bash_left" );
	
	wait 6;			// make sure some get spawned before checking.
	waittill_ai_group_ai_count( "security_defense_waves", 8 );
	
	// say: ten more seconds!
	level.defend_hacker say_dialog( "sail_almost_there_i_need_0" );
	
	// well, it was more like 8.
	wait 8.0;
	
	// hacker is done--finish up.
	level thread run_scene_and_delete( "hacker_done" );
	
	set_objective( level.OBJ_DEFEND_HACKER, undefined, "done" );
	
	hacker notify( "defend_success" );

	flag_set( "defend_objective_complete" );
	
	dialog_defend_complete();
}

dialog_defend_complete()
{
	level.defend_hacker say_dialog( "sail_clear_0" );
	level.player say_dialog( "sect_i_need_to_get_to_the_0" );
	level.defend_hacker say_dialog( "sail_we_can_get_to_the_se_0" );
}

init_doors()
{
	// put the doors in the correct position.
	run_scene_first_frame( "door_bash_right", true );
	run_scene_first_frame( "door_bash_left_wait", true );
	
	wait_network_frame();
	
	names = [];
	names[0] = "defend_door_right";
	names[1] = "defend_door_left";
	
	// attach the collision
	for ( i = 0; i < names.size; i++ )
	{
		door = GetEnt( names[i], "targetname" );
		collision = GetEnt( door.target, "targetname" );
		collision LinkTo( door, "tag_animate" );
		
		door.collision = collision;
	}
}