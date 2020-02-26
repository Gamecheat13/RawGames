/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#include animscripts\utility;
#include common_scripts\utility;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\_utility;
#include maps\blackout_anim;

#include maps\blackout_util;
#include maps\blackout_shield;

#define CLIENT_FLAG_HACK_BINK			13

// skipto init functions
init_flags()
{
	flag_init( "meat_shield_start" );
	flag_init( "meat_shield_done" );
	flag_init( "meat_shield_complete" );
}

skipto_menendez_start()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_menendez_start");
	spawn_defalco_or_standin();
	maps\blackout_security::spawn_briggs();
	level.player menendez_weapons();
}

spawn_salazar_serverroom()
{
	level.salazar = init_hero_startstruct( "salazar", "skipto_menendez_combat_salazar" );
	level.salazar gun_switchto( level.salazar.sidearm, "right" );
	level.salazar.name = "Salazar";
}

skipto_menendez_meat_shield()
{
	menendez_animations();
	skipto_setup();
	skipto_teleport_players("player_skipto_meat_shield");
	
	level.player menendez_weapons();
	maps\blackout_security::spawn_briggs();
	spawn_defalco_or_standin( "defalco_shield_start_node" );
	spawn_salazar_serverroom();
}

skipto_menendez_betrayal()
{
	menendez_animations();
	skipto_setup();
	skipto_teleport_players("player_skipto_menendez_betrayal");
	
	maps\blackout_security::spawn_briggs();
	spawn_defalco_or_standin( "defalco_combat_start_node" );
	
	spawn_salazar_serverroom();
	
	level.player menendez_weapons();
}

// skipto run functions
//
run_menendez_start()
{
	menendez_animations();
	
	run_scene_first_frame( "console_chair_karma_sit_loop" );
	flag_set( "distant_explosions_on" );
	setup_lock_lights();
	
	Objective_ClearAll();
	trigger_off( "computer_server_use", "targetname" );
	
	set_player_menendez();
	
	spawn_salazar_serverroom();
	
	// scene system handles the teleport for us.
	if ( level.is_defalco_alive )
	{
		level thread run_scene( "cctv_first_person_defalco" );
	} else {
		level thread run_scene( "cctv_first_person_standin" );
	}
	
	delay_thread( 3.8, ::lock_light_switch );
	
	screen_fade_in( 1.0 );
	
	level thread dialog_menendez_start();
	if ( level.is_defalco_alive )
	{
		scene_wait( "cctv_first_person_defalco" );
	} else {
		scene_wait( "cctv_first_person_standin" );
	}
	
	// TODO: have defalco open the door.
	level.mz_start_door.collision ConnectPaths();
	
	autosave_by_name( "menendez_start" );
	
	flag_clear( "distant_explosions_on" );
}

run_menendez_meat_shield()
{
	spawn_meat_shield_targets();
	level thread scene_observers_variable();
	
	set_objective( level.OBJ_GRAB_BRIGGS, level.briggs, "breadcrumb" );
	level thread run_scene( "shield_victim_wait" );
	
	if( level.is_defalco_alive )
	{
		level thread scene_defalco_wait();
	}
	
	trigger_wait( "meat_shield_start_trigger" );
	level.player thread say_dialog( "mene_no_one_move_0", 6.0 );
	flag_set( "meat_shield_start" );
	
	set_objective( level.OBJ_GRAB_BRIGGS, undefined, "done" );
	e_chair_trig = GetEnt( "briggs_chair_trigger", "targetname");
	set_objective( level.OBJ_MEAT_SHIELD, e_chair_trig, "breadcrumb" );

	if( level.is_defalco_alive )
	{
		level thread scene_shield_worker();
	}
	
	level thread shield_run( level.briggs, "meat_shield_valid_space", "shield_start" );
	
	scene_wait( "shield_start" );
	
	meat_shield_push_back();
	
	// wait for the player to be fully in position.
	flag_wait( "meat_shield_done" );
	set_objective( level.OBJ_MEAT_SHIELD, undefined, "done" );
	shield_end();
}

dialog_menendez_start()
{
	if ( level.is_defalco_alive )
	{
		level.defalco say_dialog( "defa_menendez_everythin_0" );
		level.player say_dialog( "mene_what_of_our_man_on_t_0" );
		level.defalco say_dialog( "defa_he_is_in_position_0" );
		level.player say_dialog( "mene_perfect_0" );
	} else {
		level.defalco say_dialog( "pmc_everything_is_ready_0" );
		level.player say_dialog( "mene_what_of_our_man_on_t_0" );
		level.defalco say_dialog( "pmc_he_s_in_position_wit_0" );
		level.player say_dialog( "mene_perfect_0" );
	}
}

scene_defalco_wait()
{
	level endon( "cancel_defalco_wait" );
	if( level.is_defalco_alive )
	{
		run_scene( "shield_defalco_wait_start" );
	}
	else
	{
		run_scene( "shield_stand_in_wait_start" );
	}
	
	if( level.is_defalco_alive )
	{
		level thread run_scene( "shield_defalco_wait" );
	}
	else
	{
		level thread run_scene( "shield_stand_in_wait_wait" );
	}
}

scene_shield_worker()
{
	level notify( "cancel_defalco_wait" );
	if( level.is_defalco_alive )
	{
		level thread run_scene( "shield_start_worker" );
	}
	else
	{
		level thread run_scene( "shield_start_worker_stand_in" );
	}
	
	worker = get_ais_from_scene( "shield_start_worker" )[0];
	
	if( level.is_defalco_alive )
	{
		scene_wait( "shield_start_worker" );
	}
	else
	{
		scene_wait( "shield_start_worker_stand_in" );
	}

	worker die();
}

run_menendez_betrayal()
{
	// lerp the player & briggs slowly.
	lerp_time = 3.0;
	level thread run_scene( "server_fight_shield_loop", lerp_time );
	
	dialog_pre_super_kill();
	level thread dialog_during_super_kill();
	
	scene_salazar_kill();
	level thread run_kneepcap_scene_main_animations();
	defalco_was_alive = level.is_defalco_alive;
	
	// sets the correct story stats for Karma and Farid.
	set_post_branching_scene_stats();
	
	level thread dialog_post_super_kill();
	
	scene_kneecap();
	
	level thread run_scene( "salazar_chair_wait" );
	
	// player uses the computer
	computer_trig = GetEnt( "computer_server_use", "targetname" );
	computer_trig trigger_on();
	set_objective( level.OBJ_VIRUS, computer_trig, "use" );
	computer_trig waittill( "trigger" );
	
	// disable it once more.
	computer_trig trigger_off();
	
	// If defalco died during the super-kill scene, spawn a new guy
	// to enter the room with you.
	//
	if ( defalco_was_alive && !level.is_defalco_alive )
	{
		spawn_defalco_or_standin( "defalco_combat_start_node" );
	}

	// play the "hacking" scene	
	level thread run_scene( "menendez_hack" );
	if ( level.is_defalco_alive )
	{
		level thread run_scene( "menendez_hack_defalco" );
	} else {
		level thread run_scene( "menendez_hack_standin" );
	}
	
	level waittill( "bink_video_start" );
	level.salazar SetClientFlag( CLIENT_FLAG_HACK_BINK );
	
	level waittill( "blink_on" );
	screen_fade_out( 0.2 );
	
	// it happened whilst he was blinking :)
	server_room_exit_door_open();
	SetSavedDvar( "player_standingViewHeight", 64 );
	give_npc_gas_masks();
	
	level waittill( "blink_off" );
	
	screen_fade_in( 0.2 );
	
	scene_wait( "menendez_hack" );
	
	level.salazar ClearClientFlag( CLIENT_FLAG_HACK_BINK );
	
	set_objective( level.OBJ_VIRUS, computer_trig, "done" );
}

give_npc_gas_masks()
{
	// DeFalco
	if ( IsDefined( level.defalco ) )
	{
		level.defalco _give_gas_mask( "c_mul_defalco_gasmask" );
	}
	
	// Salazar
	if ( IsDefined( level.salazar ) )
	{
		level.salazar _give_gas_mask( "c_usa_salazar_gasmask" );
	}
}

_give_gas_mask( str_model )
{
	self Attach( str_model, "J_Head" );
	self.gas_mask_model = str_model;
}

dialog_pre_super_kill()
{
	level.briggs say_dialog( "brig_salazar_0" );
	level.briggs say_dialog( "brig_kill_this_son_of_a_b_0" );
}

dialog_during_super_kill()
{
	level.briggs say_dialog( "brig_what_0" );
	wait 2.0;
	level.briggs say_dialog( "brig_no_0" );
	level.salazar say_dialog( "brig_you_rotten_son_of_a_0" );
}

dialog_post_super_kill()
{
	level.salazar say_dialog( "sala_this_was_the_only_wa_0" );
	level.briggs say_dialog( "brig_sorry_you_re_a_da_0" );
	level.salazar say_dialog( "sala_it_is_for_the_greate_0" );
}

spawn_meat_shield_targets()
{
	level thread run_scene( level.shield_target_scenes[0][0].loop );
	level thread run_scene( level.shield_target_scenes[1][0].loop );
	level thread run_scene( level.shield_target_scenes[2][0].loop );
	
	wait_network_frame();
	
	level.shield_targets = [];
	level.shield_targets[0] = get_ais_from_scene( level.shield_target_scenes[0][0].loop )[0];
	level.shield_targets[1] = get_ais_from_scene( level.shield_target_scenes[1][0].loop )[0];
	
	// make them stay put.
	for ( i = 0; i < level.shield_targets.size; i++ )
	{
		ai = level.shield_targets[i];
		ai.ignoreme = true;
		ai.ignoreall = true;
		ai magic_bullet_shield();
	}
}

salazar_hit_briggs( briggs )
{
	briggs endon( "damage" );
	briggs endon( "death" );
	
	// how long we get before salazar knocks out briggs for you.
	wait 12.0;

	briggs.knocked_out = true;
	briggs notify( "knockout" );
}

briggs_wound_watch()
{
	self endon( "death" );
	level endon( "menendez_enter_plane" );
	
	while ( true )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		// if the player shoots him again with the judge, he should die.
		if ( IsString( type ) && type == "MOD_PISTOL_BULLET" ) {
			break;
		}
	}
	
	set_briggs_killed();
	kill_all_pending_dialog( level.briggs );
	
	if ( !level.briggs.knocked_out )
	{
		run_scene( "briggs_shot_again" );
		level thread run_scene( "briggs_shot_again_loop" );
	} else {
		// wasn't moving, so just die.
		level.briggs stop_magic_bullet_shield();
		level.briggs ragdoll_death();
	}
}

briggs_delete_watch()
{
	level waittill( "menendez_enter_plane" );
	self Delete();
}

briggs_wound_talk()
{
	self endon( "damage" );
	self endon( "death" );
	self endon( "knockout" );
	
	/*
	wait 1.5;
	level.briggs say_dialog( "brig_aren_t_you_going_to_0" );
	wait 1.0;
	level.salazar say_dialog( "sala_shoot_him_if_you_hav_0" );
	level.briggs say_dialog( "brig_i_don_t_need_sympath_0" );
	*/
}

briggs_wound()
{
	// queue up salazar to hit Briggs if the player doesn't.
	level.salazar thread salazar_hit_briggs( self );
	level.briggs.knocked_out = false;
	
	// move on once someone (sal or the player) shoots briggs.
	self waittill_any( "damage", "death", "knockout" );
	
	// kill him if he was hit in a fatal spot.
	if ( damageLocationIsAny( "torso_upper", "neck", "head", "helmet" ) )
	{
		set_briggs_killed();
		kill_all_pending_dialog( level.briggs );
	}

	// if he wasn't shot in the head, make him arrrg.	
	if ( !level.briggs.knocked_out && !damageLocationIsAny( "head", "helmet" ) )
	{
//		level.briggs thread say_dialog( "brig_aaaarrrrrggggh_0" );
	}
	
	// don't let the player shoot again until briggs is down.
	level.player SetLowReady( true );
	
	if ( level.briggs.knocked_out )
	{
//		level.briggs thread say_dialog( "brig_aaaarrrrrggggh_0", 2.0 );
		run_scene( "briggs_knockout" );
		level thread run_scene( "briggs_knockout_loop" );
	}
	else if ( !level.is_briggs_alive )
	{
		run_scene( "briggs_shot_fatal" );
		level thread run_scene( "briggs_shot_fatal_loop" );
	}
	else
	{
		run_scene( "briggs_shot_nonfatal" );
		level thread run_scene( "briggs_shot_nonfatal_loop" );
	}
	
	// if we hit him again kill him.  if we get in the plane, delete him.
	self thread briggs_delete_watch();
	
	if ( level.is_briggs_alive )
	{
		self thread briggs_wound_watch();
	}
	
	level.player SetLowReady( false );
}

scene_observers_variable()
{
	scene_label = get_branching_scene_label();
	branching_scene_debug();
	if ( IsDefined( scene_label ) )
	{
		level thread run_scene( "super_kill_" + scene_label + "_idle" );
		flag_wait( "meat_shield_start" );
		run_scene( "super_kill_" + scene_label + "_react" );
		level thread run_scene( "super_kill_" + scene_label + "_wait" );
	}
}

scene_salazar_kill_victims()
{
	run_scene( "salazar_kill_victims" );
	run_scene( "salazar_kill_victims_dead" );
}

scene_salazar_kill()
{
	scene_label = get_branching_scene_label();
	branching_scene_debug();
	
	// only run intros if farid or karma is alive.
	if ( IsDefined( scene_label ) )
	{
		level thread run_scene( "super_kill_" + scene_label );
	}
	
	// all scenarios, guards die by sal.
	level thread scene_salazar_kill_victims();
	run_scene( "salazar_kill" );
	
	// only a cluster-kill if farid or karma is alive.
	if ( IsDefined( scene_label ) )
	{		
		level thread run_scene( "super_kill_" + scene_label + "_salazar" );	// super-kill should still be running.
		scene_wait( "super_kill_" + scene_label );						// super kill is now done.
	} else {
		run_scene( "super_kill_salazar_only" );
	}
}

scene_kneecap()
{
	level.briggs thread briggs_wound_talk();
	
	// set up for the kneecapping scene.
	if ( level.is_defalco_alive )
	{
		level thread run_scene( "kneecap_start_defalco" );
	}
	
	scene_wait( "kneecap_start_main" );
	// loop whilst the player decides whether to kneecap or kill.
	if ( level.is_defalco_alive )
	{
		level thread run_scene( "kneecap_loop_defalco" );
	}
	
	level.player SetLowReady( false );
	level.briggs briggs_wound();
}

run_kneepcap_scene_main_animations() // have to do this to prevent poping 
{
	run_scene( "kneecap_start_main" );
	level thread run_scene( "kneecap_loop_main" );
}

meat_shield_push_back_target()
{
	const min_dot = 0.6;
	const push_dist_sq = 196.0 * 196.0;
	
	valid_space_vols = GetEntArray( "meat_shield_valid_space", "targetname" );
	within_reach = false;
	foreach( vol in valid_space_vols )
	{
		if ( is_point_inside_volume( self.origin, vol ) )
		{
			within_reach = true;
		}
	}
	
	// god mode or out of reach...always win.
	if ( !within_reach || IsGodMode( level.player ) )
	{
		wait 1.0;
		return true;
	}
	
	while ( true )
	{
		player_to_target = VectorNormalize( self.origin - level.m_shield.player_rig.origin );
		player_fwd = AnglesToForward( level.m_shield.player_rig.angles );
		dot = VectorDot( player_to_target, player_fwd );
		
		if ( dot < min_dot )
		{
			return false;
		}
		
		dist_sq = Distance2DSquared( level.m_shield.player_rig.origin, self.origin );
		if ( dist_sq < push_dist_sq )
		{
			return true;
		}
		
		wait_network_frame();
		
		wait 1.0; // temp.
	}
}

meat_shield_fail()
{
	level notify( "meat_shield_fail" );

	self.perfectaim = true;
	self.dontmelee = true;
	self thread shoot_at_target( level.player, "J_head", 0, 2.0 );
	
	wait 1.0;
	
	// fake the shots.
	level.player EnableDeathShield( true );
	dmg_per_shot = Int( level.player.health / 4 );
	for ( i = 0; i < 5; i++ )
	{
		level.player dodamage( dmg_per_shot, self.origin);
		wait RandomFloatRange( 0.1, 0.2 );
	}
	level.player EnableDeathShield( false );
	
	MissionFailedWrapper( &"BLACKOUT_EXPOSED_SIDE" );
}

meat_shield_run( scene_list, can_use_lethal_force )
{
	// use lethal force by default.
	if ( !IsDefined( can_use_lethal_force ) )
	{
		can_use_lethal_force = true;
	}
	
	level endon( "meat_shield_fail" );
	
	// Add myself to the shield enemy list so the player will
	// adjust his speed according to my position.
	shield_add_enemy( self );
	
	self.shield_complete = false;
	run_scene( scene_list[0].move );
	
	// start at index 1.  we already ran 0.
	for ( index = 1; index < scene_list.size; index++ )
	{
		level thread run_scene( scene_list[index].loop );
		
		if ( IsDefined( scene_list[index].move ) )
		{
			success = true;
			if ( can_use_lethal_force )
			{
				success = self meat_shield_push_back_target();
			} else {
				wait 1.0;
			}
			
			if ( success )
			{
				shield_aim( 2.0 );
				run_scene( scene_list[index].move );
			}
			else
			{
				if ( can_use_lethal_force && !IsGodMode( level.player ) )
				{
					// stop looping.  kill the snot out of the player.
					end_scene( scene_list[index].loop );
					self thread meat_shield_fail();
				} else {
					// non-lethal: move back anyway.
					run_scene( scene_list[index].move );
				}
			}
		}
	}
	
	if ( can_use_lethal_force )
	{
		self stop_magic_bullet_shield();
	}

	self.shield_complete = true;
}

meat_shield_push_back()
{
	level.shield_targets[0] thread meat_shield_run( level.shield_target_scenes[0] );
	level.shield_targets[1] thread meat_shield_run( level.shield_target_scenes[1] );
	level.salazar thread meat_shield_run( level.shield_target_scenes[2], false );
	
	while ( !level.shield_targets[0].shield_complete || !level.shield_targets[1].shield_complete || !level.salazar.shield_complete )
	{
		wait 0.2;
	}
	
	flag_set( "meat_shield_complete" );
}

// notetrack functions
notetrack_eyeball_smash( playa )
{
//	glass = GetEnt( "eyeball_smash_glass", "targetname" );
//	glass Show();
	eyeball = get_model_or_models_from_scene( "menendez_hack", "eyeball" );
	eyeball hide();
	PlayFX( level._effect["eyeball_glass"], eyeball.origin, anglestoforward( eyeball.angles ), anglestoup( eyeball.angles ) );
}

notetrack_menenedez_mask_on( playa )
{
	clientnotify( "_gasmask_on_pristine" );
	toggle_messiah_mode( true );
}

notetrack_menendez_mask_off( bro )
{
	clientnotify( "_gasmask_off" );
	toggle_messiah_mode( false );
}

notetrack_blink_start( dude )
{
	level notify( "blink_on" );
}

notetrack_blink_stop( mayne )
{
	level notify( "blink_off" );
}

notetrack_video_start( homeboy )
{
	level notify( "bink_video_start" );
}

server_room_exit_door_open()
{
	server_room_exit = getent ("server_room_exit", "targetname");
	if ( !isdefined( server_room_exit.is_open ) )
    {
		server_room_exit.is_open = true;
	} else if ( server_room_exit.is_open )
	{
		return;
	}
	    
	// open the door.
	server_room_exit.origin = server_room_exit.origin - ( 0, 0, 1000 );
	server_room_exit.is_open = true;
}

server_room_exit_door_close()
{
	server_room_exit = getent ("server_room_exit", "targetname");
	if ( !is_true( server_room_exit.is_open ) )
	{
		return;
	}
	    
	// open the door.
	server_room_exit.origin = server_room_exit.origin + ( 0, 0, 1000 );
	server_room_exit.is_open = false;
}

// set up the doors for this section.
init_doors()
{
	level.mz_start_door = GetEnt( "menendez_start_door", "targetname" );
	level.mz_start_door.collision = GetEnt( level.mz_start_door.target, "targetname" );
	level.mz_start_door.collision LinkTo( level.mz_start_door );
	
	level.server_exit_door = GetEnt( "server_room_exit", "targetname" );
	
	// set up the glass on the keyboard.
	glass = GetEnt( "eyeball_smash_glass", "targetname" );
	glass Hide();
	glass SetScale( 0.09 );
}

lock_light_run()
{
	level waittill( "door_light_switch" );
	
	play_fx( "door_light_unlocked", self.origin, self.angles );
}

lock_light_switch()
{
	level notify( "door_light_switch" );
}

setup_lock_lights()
{
	lock_light = GetStruct( "lock_light_position", "targetname" );
	
	play_fx( "door_light_locked", lock_light.origin, lock_light.angles, "door_light_switch" );
	lock_light thread lock_light_run();
}
