/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
*/

// External References
#include common_scripts\utility;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\_utility;

// Internal References
#include maps\blackout_defend;
#include maps\blackout_sensitive_geo;
#include maps\blackout_util;

// skipto init functions
#define CLIENT_FLAG_INTRO_EXTRA_CAM			11

skipto_mason_lower_level()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_lower_level");
	
	level thread breadcrumb_and_flag( "security_breadcrumb", level.OBJ_RESTORE_CONTROL, "at_defend_objective" );
	level thread lower_level_entry_battle();
	level thread maps\blackout_bridge::scene_ziptied_pmcs();
}

skipto_mason_security()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_security");
	
	// ready the defend objective.
	level thread defend_objective();
	
	simple_spawn( "skipto_security_allies" );
	
	delay_thread( 5.0, ::flag_set, "at_defend_objective" );
}

skipto_mason_cctv()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_cctv");
	
	door_open( "defend_door_left", true );
	door_open( "defend_door_right", true );
	
	// spawn the defenders so they can cut into the wall.
	level.defenders = [];
	level.defenders[0] = simple_spawn_single( "security_defender1", ::magic_bullet_shield );
	level.defenders[1] = simple_spawn_single( "security_defender2", ::magic_bullet_shield );
	
	sensitive_geo_set_warning_guy( level.defenders[0] );
	
	trigger_off( "mason_security_feed_trigger", "targetname" );
	trigger_off( "cctv_room_trigger", "targetname" );
	
	level thread queue_pipes_drop();
}


// skipto run functions

// to the defend objective.
//
run_mason_lower_level()
{
	flag_set( "distant_explosions_on" );
	// ready the defend objective.
	level thread defend_objective();
	level thread scene_window_throw();
	
	trigger_wait( "double_stairs_mid" );
	
	end_sea_cowbell();
	end_bridge_launchers();
	
	// a guy gets shot by one of your allies.
	level thread dramatic_death_moment();
	
	// spawn a battle you join into in the lower level.
	level thread lower_level_trapped_allies();
	
	trigger_wait( "double_stairs_bottom" );
	
	// TODO: use a trigger, not a delay.
	delay_thread( 6.0, ::harper_takeover_turret );

	// spawn a special enemy to fall down the stairs
	level thread moment_stair_shoot();
	
	flag_wait( "at_defend_objective" );
	set_objective( level.OBJ_RESTORE_CONTROL, undefined, "done" );
	
	// stop spawning new friendlies.
	spawn_manager_disable( "sm_friendly_lower_level_start" );
}

// When we hit a trigger by this name, delete all triggers by that same name.
//
multipath_trigger_cleanup( str_trigger_name, str_key )
{
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	trigger_wait( str_trigger_name, str_key );
	wait 0.5;
	triggers = GetEntArray( str_trigger_name, str_key );
	foreach ( trigger in triggers )
	{
		trigger trigger_off();
	}
}

// the defend objective.
//
run_mason_security()
{
	hackable_turret_enable( "defend_turret" );
	
	// once you get past the turret, it should no longer attack the player.
	turret = GetEnt( "security_turret", "targetname" );
	if ( isdefined( turret ) )
	{
		turret turret_set_team( "allies" );
	}
	
	level thread queue_pipes_drop();
	flag_set( "distant_explosions_on" );
	spawn_manager_enable( "sm_friendly_defend" );
	
	post_defend_triggers = GetEntArray( "post_defend_spawn_trigger", "script_noteworthy" );
	post_defend_triggers = ArrayCombine( post_defend_triggers, GetEntArray( "post_defend_color_trigger", "script_noteworthy" ),true, false );
	array_func( post_defend_triggers, ::trigger_off );
	
	autosave_by_name( "defend_engineer" );
	
	flag_wait( "defend_objective_complete" );
	array_func( post_defend_triggers, ::trigger_on );
}

// defend objective to the CCTV switcharoo.
//
run_mason_cctv()
{
	run_scene_first_frame( "torch_wall_panel_first_frame" );
	
	hackable_turret_enable( "defend_turret" );
	
	// drop the pipes.
	level notify( "sensitive_pipes_drop" );
	
	// explosions in the sky.
	flag_set( "distant_explosions_on" );
	
	level thread multipath_trigger_cleanup( "color_trigger_29" );
	level thread multipath_trigger_cleanup( "color_trigger_30" );
	level thread multipath_trigger_cleanup( "color_trigger_31" );
	
	spawn_manager_enable( "sm_friendly_defend" );
	
	cctv_trigger = GetEnt( "mason_security_feed_trigger", "targetname" );
	cctv_trigger trigger_off();
	
	cutter = GetEnt( "security_defender1_ai", "targetname" );
	set_objective( level.OBJ_RENDEZVOUS, cutter, "follow" );

	// you'll need these stats to set up the coming scenes.
	retrieve_story_stats();
	
	// Set up the PMC typing in the CCTV room.
	level thread scene_cctv_hacker();
	
	cctv_room_trigger = GetEnt( "cctv_room_trigger", "targetname" );
	cctv_room_trigger trigger_on();	
	
	// send our torchcutter guy downstairs to get the party started.
	trigger_use( "defend_exit_color_trigger" );
	
	autosave_by_name( "goto_cctv_room" );

	cctv_room_trigger waittill( "trigger" );
	
	spawn_manager_disable( "sm_friendly_defend" );
	
	level thread scene_torchcutters();
	
	wait_network_frame();	
	cutter waittill( "goal" );
	
	set_objective( level.OBJ_RENDEZVOUS, undefined, "remove" );
	
	cctv_trigger trigger_on();
	level.player thread say_dialog( "sect_security_feeds_are_b_0" );
	set_objective( level.OBJ_CCTV, cctv_trigger, "use" );
	cctv_trigger waittill( "trigger" );
	
	cctv_trigger triggeroff();
	
	set_objective( level.OBJ_CCTV, cctv_trigger, "done" );
	
	//SOUND - Shawn J
	level.player playsound ( "sce_typing" );
	
	level.player delay_thread( 3.0, ::menendez_weapons, "give_menendez_guns" );
	
	{
		level thread run_scene( "cctv_first_person_mason" );
		level waittill( "cctv_turn_on" );
		level.extra_cam_surfaces[ "cctv" ] Show();
		scene_security_reboot();
		wait_network_frame();			// wait a frame to make sure the old extra cam gets switched off.
		scene_cctv_taunt_mason();
	}
	
	// wait for mason's angry time to end.
	scene_wait( "cctv_first_person_mason" );
	
	screen_fade_out( 1.0 );
	
	level.extra_cam_surfaces[ "cctv" ] Hide();
	sensitive_geo_clear_warning_guy();
	
	delete_everyone_not_in_server_room();
	hackable_turret_disable( "defend_turret" );
	level.player notify( "give_menendez_guns" );
}

dialog_harper_turret()
{
	if ( !level.is_harper_alive )
	{
		return;
	}

	level.player say_dialog( "sect_harper_i_m_pinned_0" );
	level.player say_dialog( "sect_can_you_take_manual_0" );
	level.player say_dialog( "harp_you_got_it_0" );
}

harper_takeover_turret()
{
	if ( !level.is_harper_alive )
		return;
	
	dialog_harper_turret();
	turret = GetEnt( "security_turret", "targetname" );
	if ( isdefined( turret ) && IsAlive( turret ) )
	{
		turret turret_set_team( "allies" );
	}
}

cctv_turn_on( notetrack_homie )
{
	level notify( "cctv_turn_on" );
}

delete_everyone_not_in_server_room()
{
	everyone = GetAIArray( "axis", "allies" );
	for ( i = 0; i < everyone.size; i++ )
	{
		if ( everyone[i].targetname == "briggs_ai" )
		{
			continue;
		}
		
		if ( everyone[i].targetname == "farid_ai" )
		{
			continue;
		}
		
		if ( everyone[i].targetname == "server_worker_ai" )
		{
			continue;
		}
		
		if ( everyone[i].targetname == "defalco_ai" )
		{
			continue;
		}
		
		everyone[i] Delete();
	}
}

// breaks the glass around the unfortunate schlub who gets
// thrown out the window.
//
window_throw_glass_break( unfortunate_schlub )
{
	window_break_pos = unfortunate_schlub GetTagOrigin( "J_SpineLower" );
	RadiusDamage( window_break_pos, 64.0, 1000, 800 );
	level notify( "guy_thrown_out_window" );
}

scene_window_throw()
{
	run_scene_first_frame( "window_throw" );
	wait_network_frame();
	ais = get_ais_from_scene( "window_throw" );
	foreach ( ai in ais )
	{
		ai magic_bullet_shield();
	}
	trigger_wait( "lower_level_entry_stairs_trigger" );
//	look_trig = GetEnt( "window_throw_trigger", "targetname" );
//	look_trig trigger_wait_timeout( 3 );
	level thread run_scene( "window_throw" );
	
	level waittill( "guy_thrown_out_window" );
	
	// Re-enable the nodes where the window throw takes place.
	nodes = GetNodeArray( "window_throw_node", "targetname" );
	foreach ( node in nodes )
	{
		SetEnableNode( node, true );
	}
	
	wait 1.0;
	
	foreach ( ai in ais )
	{
		if ( IsAlive( ai ) )
		{
			ai stop_magic_bullet_shield();
		}
	}
}

scene_torchcutters()
{
	level thread run_scene( "torchcutters_start" );
	
	wait_network_frame();
	
	torch_guy = get_ais_from_scene( "torchcutters_start" )[0];
	torch_guy endon( "death" );
	
	// wait till he finishes his reach.
	torch_guy waittill( "goal" );
	
	// let the "start" animation start.
	wait_network_frame();
	
	// attach the torch.
	torch_guy Attach( "t6_wpn_laser_cutter_prop", "TAG_WEAPON_LEFT" );
	torch_guy thread welding_fx( "cctv_mason_after_exit" );
	
	scene_wait( "torchcutters_start" );
	
	// run the looping animation.
	level thread run_scene( "torchcutters" );
	
	scene_wait( "cctv_first_person_mason" );
	torch_guy Delete();
}

scene_cctv_taunt_mason()
{	
	// make sure we get the right "defalco"
	spawn_defalco_or_standin();

	origin = getstruct( "menendez_start_extracam", "targetname" );
	sm_cam_ent = spawn_model( "tag_origin", origin.origin, origin.angles );
	sm_cam_ent.targetname = origin.targetname + "_cam_ent";
	sm_cam_ent SetClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );

	run_scene( "cctv_third_person" );
	
	sm_cam_ent ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
}

lower_level_entry_battle()
{
	// spawn these guys when the ziptied pmcs get spawned.
	flag_wait( "ziptied_pmc_01_started" );
	
	// descent to security...
	spawn_manager_enable( "sm_friendly_lower_level_start" );
	spawn_manager_enable( "sm_enemies_lower_level_start" );
	
	// Disable these nodes by default.
	nodes = GetNodeArray( "window_throw_node", "targetname" );
	foreach ( node in nodes )
	{
		SetEnableNode( node, false );
	}
	
	// stop spawning guys once they get into the room.
	trigger_wait( "lower_level_entry_stairs_trigger" );
	
	level thread maps\blackout_bridge::open_catwalk_door( false );
	
	spawn_manager_disable( "sm_enemies_lower_level_start" );
}

lower_level_trapped_allies()
{
	spawn_manager_enable( "sm_friendly_trapped" );
	spawn_manager_enable( "sm_enemy_trapped" );
	
	trigger_wait( "double_stairs_bottom" );
	
	spawn_manager_disable( "sm_friendly_trapped" );
	spawn_manager_disable( "sm_enemy_trapped" );
}

dramatic_death_moment()
{	
	level thread run_scene( "backpedal" );
	ally = simple_spawn_single( "backpedal_ally" );
	
	node = GetNode( ally.target, "targetname" );
	ally.fixednode = true;
	ally SetGoalNode( node );
	ally magic_bullet_shield();
	
	wait 1.0;
	
	victims = get_ais_from_scene( "backpedal" );

	source = GetStruct( "dramatic_death_bullet_source", "targetname" );
	
	foreach ( victim in victims )
	{
		if ( IsAlive( victim ) )
		{
			ally thread shoot_at_target( victim, undefined, undefined, 0.5 );
			wait 0.5;
			if ( IsAlive( victim ) )
			{
				victim bloody_death();
			}
		}
	}
	
	ally stop_magic_bullet_shield();
	ally.fixednode = false;
	
	// leave him with a smidge of health so he dies quickly.
	ally DoDamage( ally.health - 2, ally.origin );
}

moment_stair_shoot()
{
	pmc = simple_spawn_single( "stair_shoot_pmc" );
	node = GetNode( pmc.target, "targetname" );
	pmc.fixednode = true;
	pmc.ignoreme = true;
	pmc.attackerAccuracy = 0.0;
	pmc SetGoalNode( node );
	pmc magic_bullet_shield();
	
	// wait for the player to attack him.
	do
	{
		pmc waittill( "damage", amount, attacker );
	} while( !IsDefined( attacker ) || !IsPlayer( attacker ) );
	
	pmc stop_magic_bullet_shield();
	
	run_scene( "stair_shoot" );
}

cctv_hacker_wait( trigger )
{
	self endon( "damage" );
	self endon( "whizby" );
	trigger endon( "trigger" );
	level.player waittill_player_looking_at( self.origin + (0, 0, 96), 0.7 );
	wait RandomFloatRange( 0.0, 2.0 );
}

scene_cctv_hacker()
{
	level thread run_scene( "cctv_hacker_loop" );
	wait_network_frame();
	hacker = get_ais_from_scene( "cctv_hacker_loop" )[0];
	hacker magic_bullet_shield();
	
	trigger_wait( "cctv_tower_top_trigger" );
	
	hacker cctv_hacker_wait( GetEnt( "cctv_room_trigger", "targetname" ) );
	hacker stop_magic_bullet_shield();
	run_scene( "cctv_hacker_react" );
}

system_offline_messages()
{
	messages = [];
	wait 7.0;
	IPrintLnBold( "SECURITY SYSTEMS REBOOTING..." );
	wait 2.0;
	IPrintLnBold( "TURRET SYSTEMS OFFLINE" );
	wait 0.7;
	IPrintLnBold( "DRONE CONTROL OFFLINE" );
	wait 1.5;
	IPrintLnBold( "DOOR MECHANISMS OFFLINE" );
}

queue_pipes_drop( skip_waittill )
{
	level waittill( "sensitive_pipes_drop" );
	
	disable_seam_set( "drop_pipes" );
	
	fall_volume = GetEnt( "pipe_fall_volume", "targetname" );
	while ( level.player IsTouching( fall_volume ) )
	{
		wait_network_frame();
	}
	
	important_guy_blocking = false;
	ai_list = [];
	
	// wait until nobody important is blocking.
	do
	{
		axis_list = get_ai_touching_volume( "axis", fall_volume.targetname, fall_volume );
		ally_list = get_ai_touching_volume( "allies", fall_volume.targetname, fall_volume );
		ai_list = ArrayCombine( axis_list, ally_list,true,false );
		
		foreach ( ai in ai_list )
		{
			if ( is_true( ai.magic_bullet_shield ) )
			{
				important_guy_blocking = true;
			}
		}
		wait 0.2;
	}
	while ( important_guy_blocking );
	
	// kill the ais nearby.
	array_thread( ai_list, ::bloody_death );
	
	// drop the pipes.
	level notify( "fxanim_pipes_block_start" );
	
	// block the path.
	blocking_pipes_geo = GetEnt( "pipe_fall_collision", "targetname" );
	blocking_pipes_geo Solid();
	blocking_pipes_geo DisconnectPaths();
}

setup_briggs()
{
	// he's a "bad guy" but doesn't attack or get attacked.
	self.team = "axis";
	self.ignoreme = true;
	self.ignoreall = true;
}

spawn_briggs()
{
	briggs_spawner = GetEnt( "briggs", "targetname" );
	briggs_spawner add_spawn_function( ::setup_briggs );
	level.briggs = init_hero_startstruct( "briggs", "briggs_meat_shield_start" );
	level.briggs gun_switchto( level.briggs.sidearm, "right" );
	level.briggs.team = "axis";
}

scene_security_reboot()
{
	spawn_briggs();

	level thread run_scene( "briggs_pip" );
	
	origin = getstruct( "pip_glasses_pos", "targetname" );
	sm_cam_ent = spawn_model( "tag_origin", origin.origin, origin.angles );
	sm_cam_ent.targetname = origin.targetname + "_cam_ent";
	sm_cam_ent SetClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	level thread system_offline_messages();
	
	scene_wait( "briggs_pip" );
	
	sm_cam_ent ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
}

///////////////////////////
//                       //
//                       //
//                       //
///////////////////////////

init_doors()
{
	blocking_pipes_geo = GetEnt( "pipe_fall_collision", "targetname" );
	blocking_pipes_geo NotSolid();
	blocking_pipes_geo ConnectPaths();
}

init_flags()
{
	flag_init( "at_defend_objective" );
	flag_init( "defend_objective_complete" );
	flag_init( "at_cctv_room" );
	flag_init( "left_breach_saved" );
}