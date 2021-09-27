#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\hijack_code;
#include maps\_blizzard_hijack;

start_tarmac()
{
	//level.commander = spawn_ally("commander");
	level.commander = spawn_ally("commander_tarmac");
	waittillframeend;
	
	exitGoal = GetNode("commander_pre_ramp_node", "targetname");
	level.commander teleport_ai(exitGoal);

	player_start_struct = GetStruct( "player_start_tarmac", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );
	maps\hijack_crash::remove_all_weapons_post_crash();

	maps\_compass::setupMiniMap("compass_map_hijack_tarmac", "tarmac_minimap_corner");
	setsaveddvar( "compassmaxrange", 3500 ); //default is 3500
	
	thread tarmac_carnage();
	aud_send_msg("start_tarmac");
	
	flag_set("stop_managing_crash_player");
	flag_set("player_on_feet_post_crash");
	flag_set("commander_finished_wake_up_anim");
	
    thread main_script_thread();
    scene_origin = getstruct("agent_helps_player_origin", "targetname");
    thread maps\hijack_crash::animated_telephone();
    //thread test_commander_lookat();
}

commander_lookat(startAtDistance, duration)
{
	self endon("death");
	
	while(1)
	{
		dist = Distance(self.origin, level.commander.origin);
		if( dist < startAtDistance )
		{
			break;
		}	
			
		wait .1;			
	}
		
	level.commander SetLookAtEntity(self);
	
	level notify("commander_looks_at_something");
	
	level endon("commander_looks_at_something");
	
	
	wait duration;	
	level.commander SetLookAtEntity();
}

start_tarmac_2()
{
	//level.commander = spawn_ally("commander");
	level.commander = spawn_ally("commander_tarmac");
	waittillframeend;
	

	player_start_struct = GetStruct( "player_start_tarmac_2", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );

	maps\_compass::setupMiniMap("compass_map_hijack_tarmac", "tarmac_minimap_corner");
	setsaveddvar( "compassmaxrange", 3500 ); //default is 3500
	
	thread tarmac_carnage();
	aud_send_msg("start_tarmac_2");
	
	flag_set("stop_managing_crash_player");
	flag_set("player_on_feet_post_crash");
	flag_set("commander_finished_wake_up_anim");
	flag_set("player_on_feet_post_crash");
	flag_set("player_exit_plane_1");
	flag_set("player_exit_plane_3");
	flag_set("player_exit_plane_4");
	flag_set("start_checkdeadguy_anim");
	flag_set("move_commander_to_flare_node");
	flag_set("start_flare_event");
	flag_set("fx_crash_trench_fire");
	
    thread main_script_thread();
    flag_set("commander_finished_wake_up_anim");
	level.tarmac_player_move_speed = 0.60;
	
	waittillframeend;
	level notify("start_commander_wake_up_anim");
}

tarmac_init_flags()
{
	flag_init("player_on_feet_post_crash");
	flag_init("commander_started_ramp_anim");
	flag_init("commander_reached_flare_node");
	flag_init("commander_started_flare_anim");
	flag_init("commander_finished_flare_anim");
	flag_init("commander_finished_engine_react_anim");
	flag_init("spawn_makarov_heli");
	flag_init("commander_ready_for_heli");
	flag_init("start_spotlight_random_targeting");
	flag_init("tail_explosion");
	flag_init("end_guys_waiting_for_commander");
	flag_init("guys_ready_for_door");
	flag_init("start_heli_descent");
	flag_init("heli_landed");
}

tarmac_init_assets()
{
	PrecacheModel("vehicle_mi17_woodland_landing_door");
	PrecacheModel("vehicle_mi17_woodland_landing_door_obj");
	PrecacheModel("com_blackhawk_spotlight_on_mg_setup");
	PrecacheTurret("heli_spotlight");
	PrecacheModel("hjk_plane_debris_02");
	PrecacheModel("hjk_seat_cover_sml");
	//setup_vehicle_light_types();
}

tarmac_objectives()
{
	flag_wait("player_on_feet_post_crash");
	Objective_Add( obj("follow_commander"), "current", &"HIJACK_OBJ_COMMANDER", level.commander.origin );
	Objective_OnEntity( obj("follow_commander"), level.commander, (0, 0, 70));	
	
	flag_wait("player_entered_end_area");
	Objective_Complete( obj("follow_commander") );
	
	obj_pos = getstruct( "find_pres_obj", "targetname" );
	
	Objective_Add( obj("find_president"), "current", &"HIJACK_OBJ_PRESIDENT_END", obj_pos.origin );
	//Objective_Position( obj("find_president"), level.president.origin + (0,0,70) );
	
	flag_wait_or_timeout( "player_near_pres", 15 );
	Objective_Position( obj("find_president"), (0,0,0) );
	
	/*while(!flag("guys_ready_for_door") || !flag("heli_landed"))
	{
		obj_pos = level.president GetTagOrigin("J_SpineLower");
		obj_pos = (obj_pos[0],obj_pos[1],80);
		Objective_Position( obj("find_president"), obj_pos );
		wait(0.05);
	}*/

	flag_wait_all( "guys_ready_for_door", "heli_landed" );
	
	Objective_Position( obj("find_president"), (level.makarov_heli GetTagOrigin("tag_handle_objective")) + (0,0,-1) );
	
	level waittill("door_used");
	objective_state( obj("find_president"), "failed");
}

exit_plane_scene()
{
	scene_origin = getstruct("post_crash_scene_origin", "targetname" );

	//players: commander, crash_agent_1, postcrash_agent2, daughter
	agent1 = spawn_targetname("postcrash_agent1", true);
	agent1.animname = "plane_exit_agent1";
	agent1 gun_remove();
	
	agent2 = spawn_targetname("postcrash_agent2", true);
	agent2.animname = "plane_exit_agent2";
	
	level.daughter = spawn_targetname("daughter_tarmac");
	level.daughter maps\hijack::setup_daughter();
	
	blanket = spawn_anim_model("daughter_blanket");
	blanket StartUsingHeroOnlyLighting();		
	
	scene_origin thread anim_first_frame_solo(agent1,"secure_daughter");
	scene_origin thread anim_first_frame_solo(agent2,"secure_daughter");
	scene_origin thread anim_first_frame_solo(level.daughter,"secure_daughter");
	scene_origin thread anim_first_frame_solo(blanket,"secure_daughter");

	if ( level.start_point != "tarmac" )
	{
		level waittill("start_commander_wake_up_anim");
	}
	// spinning turbine
	engine = GetEnt("crashed_plane_engine","targetname");
	engine.animname = "engine";
	engine SetAnimTree();
	engine thread anim_single_solo( engine, "engine_spin_slow" );	
	
	flag_wait("commander_finished_wake_up_anim");
	
	if ( level.start_point != "tarmac_2" )
	{
		scene_origin thread anim_loop_solo(level.commander,"exit_top_idle","stop_top_loop");
	}
	
	flag_wait_any("player_exit_plane_1","start_commander_ramp_anim");
	flag_set("commander_started_ramp_anim");
	scene_origin notify("stop_top_loop");
	
	if ( level.start_point != "tarmac_2" )
	{
		level.commander.lastGroundtype = "metal"; // hack to get footsteps to show up
		scene_origin anim_single_solo(level.commander,"exit_down_ramp");
		scene_origin thread anim_loop_solo(level.commander,"exit_bottom_idle","stop_bottom_loop");
	}
	
	flag_wait("player_exit_plane_3");
	scene_origin notify("stop_bottom_loop");
	
	outside_engine = GetEnt("engine_outside","targetname");
	outside_engine.animname = "engine";
	outside_engine SetAnimTree();
	outside_engine thread anim_single_solo( outside_engine, "engine_spin_slow" );

	agent1.lastGroundtype = "snow"; // hack to get footsteps to show up
	agent2.lastGroundtype = "snow"; // hack to get footsteps to show up
	level.daughter.lastGroundtype = "snow"; // hack to get footsteps to show up
	
	agent1 thread play_anim_and_loop(scene_origin,"secure_daughter","secure_daughter_loop");
	agent2 thread play_anim_and_loop(scene_origin,"secure_daughter","secure_daughter_loop");
	level.daughter thread play_anim_and_loop(scene_origin,"secure_daughter","secure_daughter_loop");
	blanket thread play_anim_and_loop(scene_origin,"secure_daughter","secure_daughter_loop");
	
	if ( level.start_point != "tarmac_2" )
	{	
		thread agent_secure_daughter_vo(agent1,agent2);
		level.commander.lastGroundtype = "snow"; // hack to get footsteps to show up
		scene_origin anim_single_solo(level.commander, "secure_daughter");	
		thread tarmac_commander_vo();
	}
	
	level.commander disable_cqbwalk();
	level.commander.ignoreall = false;
	level.commander.notarget  = false;

	level.commander thread commander_tarmac_moves();
	
	flag_wait("entered_post_tarmac_area");
	agent1 delete();
	agent2 delete();
	level.daughter stop_magic_bullet_shield();
	level.daughter delete();
	flag_set("commander_ready_for_heli");
}

agent_secure_daughter_vo(agent1,agent2)
{
	wait(0.5);
	agent1 dialogue_queue( "hijack_fso1_howdidthey" );
	wait(0.5);
	agent2 dialogue_queue( "hijack_fso2_theyknew2" );
}

commander_keep_up_with_player()
{
	level endon("entered_post_tarmac_area");
	level endon("stop_monitoring_commander_speed");
	
	wait(0.2);
	while( true )
	{
		distance_difference = distance_commander_to_player();
		if ( distance_difference > 120)
		{
			if ( level.commander needs_to_catch_up() )
			{
				// player ahead of commander
				if ( distance_difference > 240 )
				{
					level.commander.moveplaybackrate = level.commander_base_move_speed+0.27;
					//set_player_move_and_jump_speed( level.tarmac_player_move_speed-0.13 );
				}
				else
				{
					level.commander.moveplaybackrate = level.commander_base_move_speed+0.16;
					//set_player_move_and_jump_speed( level.tarmac_player_move_speed-0.07 );
				}
			}
			/*
			else
			{
				// commander ahead of player
				if ( distance_difference > 240 )
				{
					level.commander.moveplaybackrate = level.commander_base_move_speed-0.25;
					set_player_move_and_jump_speed( level.tarmac_player_move_speed+0.11 );
				}
			}
			*/
		}
		else
		{
			level.commander.moveplaybackrate = level.commander_base_move_speed;
			set_player_move_and_jump_speed( level.tarmac_player_move_speed );
		}
		wait(1.0);
	}
}

distance_commander_to_player()
{
	to_player = ( level.player.origin - level.commander.origin );
	return Length( to_player );
}

needs_to_catch_up()
{
	to_player = ( level.player.origin - self.origin );
	to_player = VectorNormalize( to_player );
	to_goal = VectorNormalize( self.goalpos - self.origin );
	// we goal is on opposite side of player, assume we are leading the player
	dot = VectorDot( to_goal , to_player );
	if ( dot < -0.2 )
	{
		return false;	
	}
	return true;
}

commander_nag_if_stopped()
{
	while(1)
	{
		if( commander_velocity() == 0 )
		{
			vel_still_zero = true;
			num_of_loops = 5 + RandomInt(2);
			for ( i=0; i<num_of_loops && vel_still_zero; i++ )
			{
				wait(2);
				vel_still_zero = commander_velocity() == 0;
			}
			if ( vel_still_zero )
			{
				vo_line = RandomInt(3);
				if ( vo_line == 0 )
				{
					level.commander dialogue_queue("hijack_cmd_keepmoving2");
				}
				else if ( vo_line == 1 )
				{
					level.commander dialogue_queue("hijack_cmd_comeon");
				}
				else if ( vo_line == 2 )
				{
					level.commander dialogue_queue("hijack_cmd_letsgo");
				}
			}
		}
		wait(0.1);
	}
}

commander_velocity()
{
	old_origin = level.commander.origin;
	wait(0.05);
	new_origin = level.commander.origin;
	velocity_size = distance(old_origin,new_origin);
	return velocity_size;
}

commander_tarmac_moves()
{
	level endon("entered_post_tarmac_area");
	
	level.commander_base_move_speed = 1.1;
	level.commander.moveplaybackrate = level.commander_base_move_speed;
	level.commander set_run_anim( "injured_run" );
	//level.commander maps\hijack_anim::commander_post_crash_animset();
	//level.commander.custom_animscript_table[ "combat" ] = ::commander_dummy_combat;
	
	thread commander_keep_up_with_player();
	childthread commander_nag_if_stopped();

	node_1 = GetNode("commander_tarmac_node_1","targetname");
	self thread set_goal_and_idle(node_1);
	
	flag_wait("move_commander_to_flare_node");
	self notify("stop_relaxed_idle");
	self anim_stopanimscripted();
	tarmac_flare_event();
	
	node_3 = GetNode("commander_tarmac_node_3","targetname");
	self thread set_goal_and_idle(node_3);

	flag_wait_all("commander_finished_engine_react_anim");
	anim_origin = GetStruct("post_crash_scene_origin","targetname");

	self notify("stop_relaxed_idle");	
	self anim_stopanimscripted();
	
	anim_origin anim_reach_solo(level.commander,"heli_wave");
	level.commander thread anim_loop_solo(level.commander,"heli_wait");
	flag_set("commander_ready_for_heli");
	
	level.makarov_heli ent_flag_wait("start_commander_anim");
	level.commander notify("stop_loop");
	anim_origin anim_single_solo(level.commander,"heli_wave");

	node_4 = GetNode("commander_tarmac_node_4","targetname");
	self thread set_goal_and_idle(node_4);

	self notify("stop_relaxed_idle");		
	node_5 = GetNode("commander_tarmac_node_5","targetname");
	self SetGoalNode(node_5);
	
	level waittill("commander_react_to_combat");
	level notify("stop_monitoring_commander_speed");
	self animscripts\animset::clear_custom_animset();
	
	self clear_run_anim();
	self clear_generic_idle_anim();
	//level.commander.custom_animscript_table[ "combat" ] = undefined;
	self.moveplaybackrate = 1.0;
}

set_goal_and_idle(node)
{
	self notify("stop_relaxed_idle");
	self anim_stopanimscripted();
	
	self SetGoalNode(node);
	self.disablearrivals = true;
	self.goalradius = 16;
	
	
	//make sure there's only one going at a time.
	self endon("stop_relaxed_idle");
	
	self clear_generic_idle_anim();
	self waittill("goal");
	waittillframeend;
	
	//self set_idle_anim( "relaxed_idle" );
	self anim_loop_solo(self,"relaxed_idle", "stop_relaxed_idle");
}

tarmac_flare_event()
{
	thread commander_wait_for_trigger();
	
	anim_origin = GetStruct("post_crash_scene_origin","targetname");
	anim_origin anim_reach_solo(level.commander,"flare_reaction");
	level.commander thread anim_loop_solo(level.commander,"relaxed_idle");
	
	flag_wait("start_flare_event");
	if ( !flag("commander_finished_engine_react_anim") )
	{
		aud_send_msg("flare_gun");
		level.commander notify("stop_loop");
		level.commander.lastGroundtype = "snow"; // hack to get footsteps to show up
		flag_set("commander_started_flare_anim");
		anim_origin thread anim_single_solo(level.commander,"flare_reaction");
		
		thread maps\_flare::flare_from_targetname( "tarmac_flare" );
		level.commander waittillmatch("single anim","end");
		flag_set("commander_finished_flare_anim");
	}
}

commander_wait_for_trigger()
{
	trigger = GetEnt("commander_flare_vo_trigger","targetname");
	
	trigger waittill("trigger");
	if ( !flag("start_engine_explosion") )
	{
		level.player radio_dialogue ( "hijack_fso4_sendingflare" );
	}
}

tarmac_commander_vo()
{
	wait(1.8);
	level.commander dialogue_queue( "hijack_cmd_evacontheway" );
	wait(1);
	level.commander dialogue_queue( "hijack_cmd_team4report" );
	wait(.2);
	level.player radio_dialogue ( "hijack_fso4_wounded" );
	wait(.2);
	if ( !flag("start_flare_event") )
	{
		level.commander dialogue_queue( "hijack_cmd_securearea" );
	}
}

tarmac_background_chatter()
{
	level endon( "stop_drunk_walk" );
	
	flag_wait("start_engine_explosion");
	wait(6);

	level.tarmac_radio_org = spawn( "script_origin", level.player.origin );
	level.tarmac_radio_org linkto( level.player );
	level.tarmac_radio_org.linked = true;
	
	rand = RandomFloatRange( 0, 5 );
	
	background_chatter( "hijack_fso1_confirmation", level.tarmac_radio_org );
	background_chatter( "hijack_rt1_onsceneinten", level.tarmac_radio_org );
	wait rand;
	background_chatter( "hijack_fso2_cordonoff", level.tarmac_radio_org );
	wait rand;
	background_chatter( "hijack_fso3_leakingfuel", level.tarmac_radio_org );
	wait rand;
	background_chatter( "hijack_rt1_blackbox", level.tarmac_radio_org );
	wait(.4);
	background_chatter( "hijack_fso3_blackbox", level.tarmac_radio_org );
	wait rand;
	background_chatter( "hijack_fso2_medical", level.tarmac_radio_org );
	wait rand;
	background_chatter( "hijack_fso1_satcom", level.tarmac_radio_org );
	wait rand;
	background_chatter( "hijack_fso3_cockpit", level.tarmac_radio_org );
	wait rand;
	background_chatter( "hijack_fso2_tailsection", level.tarmac_radio_org );
}

try_start_heart_beat()
{
	if ( level.start_point == "tarmac" )
	{
		flag_wait("player_exit_plane_2");
	}
	if ( level.start_point == "tarmac_2" )
	{
		flag_wait("start_engine_explosion");
	}
	thread maps\hijack_drunk_player::start_player_heartbeat();	
}

watch_player_jump()
{
	level endon("player_exit_plane_4");
	
	NotifyOnCommand( "playerjump", "+gostand" );
	NotifyOnCommand( "playerjump", "+moveup" );
	
	while( 1 )
	{
		level.player waittill( "playerjump" );
		wait( 0.1 );  // jumps don't happen immediately
		
		level.player AllowJump(false);
		wait(1.5);
		level.player AllowJump(true);
	}
}

set_player_move_and_jump_speed(speed)
{
	level.player setMoveSpeedScale(speed);
	setsaveddvar("jump_height",level.player_original_jump_height * speed);
}

tarmac_events()
{
	flag_wait("stop_managing_crash_player");
	
	level.player_original_jump_height = GetDvarFloat("jump_height");
	
	if ( level.start_point != "tarmac_2" )
	{
		thread post_crash_plane_shake();
	}
	thread post_crash_explosions();
	
	thread tarmac_background_chatter();
	
	if ( level.start_point != "tarmac" && level.start_point != "tarmac_2" )
	{
		wait(3.5);	// wait 3.5 seconds after the crash blackout before enabling this stuff
	}
	thread maps\hijack_drunk_player::main();
	thread try_start_heart_beat();
	thread player_breathing_sound();
	set_player_move_and_jump_speed( 0.2 );
	if ( !flag("player_exit_plane_4") )
	{
		thread watch_player_jump();
	}
	
	thread maps\hijack_drunk_player::aftermath_style_walking();
	flag_set( "start_doing_aftermath_walk" );
	
	flag_wait("player_on_feet_post_crash");
	setSavedDvar( "player_sprintSpeedScale", 1.1 );
	level.player allowcrouch( true );
	level.player allowprone( true );
	
	wait(0.1);	
	flag_wait("player_exit_plane_1");
	if ( level.start_point != "tarmac_2" )
	{
		wait(3);
	}
	set_player_move_and_jump_speed( 0.24 );
	
	flag_wait("player_exit_plane_3");
	set_player_move_and_jump_speed( 0.35 );
	level.unsteady_scale = 2.5;
	thread enable_weapons_after_time();

	if ( isdefined(level.tarmac_radio_org) )
	{
		level.tarmac_radio_org.deleteme = true;
	}
	
	flag_wait("player_exit_plane_4");
	thread blend_player_move_speed();
	level.unsteady_scale = 1.0;
	setSavedDvar( "player_sprintSpeedScale", 1.3 );
	level.player AllowJump(true);
	
	if ( level.start_point != "tarmac_2" )
	{
		level.doPickyAutosaveChecks = 0;
		thread autosave_by_name("exit_airplane");
		wait(2);
		level.doPickyAutosaveChecks = 1;
	}

	flag_wait("entered_post_tarmac_area");
	setSavedDvar( "player_sprintSpeedScale", 1.5 );
	
	//stop all the blurriness and everything
	flag_set("stop_aftermath_player");
	flag_set("stop_fade_in_out");
	level notify( "stop_drunk_walk" );	
	level notify( "kill_limp" );
	level notify("not_random_blur");
	level notify("stop_heart");
}

enable_weapons_after_time()
{
	wait(11);
	level.player EnableWeapons();
}

blend_player_move_speed()
{
	if ( level.start_point == "tarmac_2" )
	{
		level.tarmac_player_move_speed = 0.8;
		set_player_move_and_jump_speed( level.tarmac_player_move_speed );
	}
	else
	{
		level.tarmac_player_move_speed = 0.35;
		while( level.tarmac_player_move_speed < 0.8 )
		{
			level.tarmac_player_move_speed += 0.05;
			set_player_move_and_jump_speed( level.tarmac_player_move_speed );
			wait(0.5);
		}
	}
}

stop_random_blur()
{
	level notify( "not_random_blur" );	
}

restart_random_blur()
{
	thread maps\hijack_drunk_player::player_random_blur();
}

post_crash_plane_shake()
{
	thread post_crash_plane_props();
	
	flag_wait("commander_started_ramp_anim");
	
	stop_random_blur();

	aud_send_msg("tarmac_shift");
	
	earthquake( .30, 5.5, level.player.origin, 80000 );
	level.player PlayRumbleOnEntity( "hijack_plane_medium" );
	
	wait(3.5);
	restart_random_blur();
}

post_crash_plane_props()
{
	anim_origin = GetStruct("post_crash_scene_origin","targetname");
	
	// cabinet2 (first cabinet on the left as you enter the room)
	cab2_med_door1 = GetEnt("cab2_med_door1","targetname");		//hijack_post_crash_locker1
	cab2_med_door2 = GetEnt("cab2_med_door2","targetname");		//hijack_post_crash_locker2
	cab2_lg_door1 = GetEnt("cab2_lg_door1","targetname");		//hijack_post_crash_locker3
	cab2_lg_door2 = GetEnt("cab2_lg_door2","targetname");		//hijack_post_crash_locker4
	
	// cabinet1 (second cabinet on the left as you enter the room)
	cab1_sm_door1 = GetEnt("cab1_sm_door1","targetname");		//hijack_post_crash_locker6
	cab1_sm_door2 = GetEnt("cab1_sm_door2","targetname");		//hijack_post_crash_locker7
	cab1_sm_door3 = GetEnt("cab1_sm_door3","targetname");		//hijack_post_crash_locker8
	cab1_sm_door4 = GetEnt("cab1_sm_door4","targetname");		//hijack_post_crash_locker9
	cab1_med_door1 = GetEnt("cab1_med_door1","targetname");		//hijack_post_crash_locker5
	cab1_med_door2 = GetEnt("cab1_med_door2","targetname");		//hijack_post_crash_locker11
	cab1_med_door3 = GetEnt("cab1_med_door3","targetname");		//hijack_post_crash_locker14
	cab1_med_door4 = GetEnt("cab1_med_door4","targetname");		//hijack_post_crash_locker16
	cab1_med_door5 = GetEnt("cab1_med_door5","targetname");		//hijack_post_crash_locker12
	cab1_med_door6 = GetEnt("cab1_med_door6","targetname");		//hijack_post_crash_locker15
	cab1_med_door7 = GetEnt("cab1_med_door7","targetname");		//hijack_post_crash_locker17
	cab1_med_door8 = GetEnt("cab1_med_door8","targetname");		//hijack_post_crash_locker10
	cab1_lg_door1 = GetEnt("cab1_lg_door1","targetname");		//hijack_post_crash_locker13
	cab1_drawer1 = GetEnt("cab1_drawer1","targetname");			//hijack_post_crash_drawer1
	cab1_drawer2 = GetEnt("cab1_drawer2","targetname");			//hijack_post_crash_drawer2
	
	// cabinet3 (cabinet on the right as you enter the room)
	cab3_med_door1 = GetEnt("cab3_med_door1","targetname");		//hijack_post_crash_locker18
	cab3_med_door2 = GetEnt("cab3_med_door2","targetname");		//hijack_post_crash_locker20
	cab3_med_door3 = GetEnt("cab3_med_door3","targetname");		//hijack_post_crash_locker19
	cab3_med_door4 = GetEnt("cab3_med_door4","targetname");		//hijack_post_crash_locker21
	
	ladder = GetEnt("post_crash_airplane_ladder","targetname");	//hijack_post_crash_ladder
	floor_chunk = GetEnt("post_crash_airplane_floor_chunk","targetname");
	tire = GetEnt("post_crash_airplane_tire","targetname");		//hijack_post_crash_tire
	crate = GetEnt("post_crash_airplane_crate","targetname");	//hijack_post_crash_crate
	crate2 = GetEnt("post_crash_airplane_crate_2","targetname");
	pipe_small = GetEnt("post_crash_pipe_small","targetname");	//hijack_post_crash_pipe_small
	pipe_large = GetEnt("post_crash_pipe_large","targetname");	//hijack_post_crash_pipe_large
	
	cab2_med_door1 thread post_crash_prop_anim(anim_origin,"post_crash_locker1");
	cab2_med_door2 thread post_crash_prop_anim(anim_origin,"post_crash_locker2");
	cab2_lg_door1 thread post_crash_prop_anim(anim_origin,"post_crash_locker3");
	cab2_lg_door2 thread post_crash_prop_anim(anim_origin,"post_crash_locker4");
	cab1_sm_door1 thread post_crash_prop_anim(anim_origin,"post_crash_locker6");
	cab1_sm_door2 thread post_crash_prop_anim(anim_origin,"post_crash_locker7");
	cab1_sm_door3 thread post_crash_prop_anim(anim_origin,"post_crash_locker8");
	cab1_sm_door4 thread post_crash_prop_anim(anim_origin,"post_crash_locker9");
	cab1_med_door1 thread post_crash_prop_anim(anim_origin,"post_crash_locker5");
	cab1_med_door2 thread post_crash_prop_anim(anim_origin,"post_crash_locker11");
	cab1_med_door3 thread post_crash_prop_anim(anim_origin,"post_crash_locker14");
	cab1_med_door4 thread post_crash_prop_anim(anim_origin,"post_crash_locker16");
	cab1_med_door5 thread post_crash_prop_anim(anim_origin,"post_crash_locker12");
	cab1_med_door6 thread post_crash_prop_anim(anim_origin,"post_crash_locker15");
	cab1_med_door7 thread post_crash_prop_anim(anim_origin,"post_crash_locker17");
	cab1_med_door8 thread post_crash_prop_anim(anim_origin,"post_crash_locker10");
	cab1_lg_door1 thread post_crash_prop_anim(anim_origin,"post_crash_locker13");
	
	cab3_med_door1 thread post_crash_prop_anim(anim_origin,"post_crash_locker18");
	cab3_med_door2 thread post_crash_prop_anim(anim_origin,"post_crash_locker20");
	cab3_med_door3 thread post_crash_prop_anim(anim_origin,"post_crash_locker19");
	cab3_med_door4 thread post_crash_prop_anim(anim_origin,"post_crash_locker21");
	
	cab1_drawer1 thread post_crash_prop_anim(anim_origin,"post_crash_drawer1");
	cab1_drawer2 thread post_crash_prop_anim(anim_origin,"post_crash_drawer2");
	
	ladder thread post_crash_prop_anim(anim_origin,"post_crash_ladder");
	floor_chunk thread post_crash_prop_anim(anim_origin,"post_crash_ladder","J_prop_2");
	tire thread post_crash_prop_anim(anim_origin,"post_crash_tire");
	crate thread post_crash_prop_anim(anim_origin,"post_crash_crate");
	crate2 thread post_crash_prop_anim(anim_origin,"post_crash_crate","J_prop_2");
	pipe_small thread post_crash_prop_anim(anim_origin,"post_crash_pipe_small");
	pipe_large thread post_crash_prop_anim(anim_origin,"post_crash_pipe_large");
}

post_crash_prop_anim(anim_origin, anim_name, joint)
{
	if (!isdefined(joint))
	{
		joint = "J_prop_1";	
	}
	
	rig = spawn_anim_model("post_crash_prop");
	waittillframeend;	
	anim_origin thread anim_first_frame_solo( rig, anim_name );
	self linkto( rig , joint );
	
	flag_wait("commander_started_ramp_anim");
	anim_origin anim_single_solo( rig, anim_name );
	waittillframeend;
	rig delete();
}

post_crash_explosions()
{
	thread distant_explosion();
	thread engine_explosion();
	thread tail_random_explosions();
	//thread tail_final_explosion();
}

distant_explosion()
{
	// Distant Explosion as player leaves daughter scene (trigger when about even with tree on path, can occur somewhere near tail area,
	// player doesn’t have to see visual, shouldn’t overlap with jet engine explosion)
	flag_wait("distant_explosion");
	aud_send_msg("wreck_exit_expl");
	exploder("distant_exp");
}

engine_explosion()
{
	// As you approach the rear of the plane, the jet engine explodes (model swap, FX with chunks) 
	// Extreme damage engine to swap to
	// Agents reacting to engine Exploding, dragging guys away
	engine = GetEnt("crashed_plane_engine","targetname");
	destroyed_engine = GetEnt("crashed_plane_engine_destroyed","targetname");
	destroyed_engine hide();
	
	flag_wait("start_engine_explosion");
	wait(1);
	
	aud_send_msg("engine_explosion");
	stop_random_blur();
	
	exploder("engine_exp");
	exploder("engine_exp_fire");
	wait(0.1);
	thread player_engine_explosion_react(engine);
	
	engine hide();
	destroyed_engine show();
	
	thread commander_engine_explosion_react();

	wait(2.0);
	restart_random_blur();
	flag_set("spawn_makarov_heli");
}

commander_engine_explosion_react()
{
	if ( !flag("commander_started_flare_anim") || flag("commander_finished_flare_anim") )
	{
	level.commander notify("stop_loop");
	level.commander anim_single_solo(level.commander,"engine_stumble");
	}
	else
	{
		flag_wait("commander_finished_flare_anim");
	}
	flag_set("commander_finished_engine_react_anim");	
}

player_engine_explosion_react(engine)
{
	level.player dirtEffect( engine.origin );
	level.player shellshock( "hijack_engine_explosion", 1 );
	level.player DoDamage(level.player.health - 1,engine.origin);
	earthquake( .50, 1.5, engine.origin, 10000 );
	level.player PlayRumbleOnEntity( "hijack_plane_large" );
	
	//force player to crouch.
	//tilt your view back from the engine	
	tag = spawn_tag_origin();
	tagToEngine = spawn_tag_origin();
	
	playerToEngine = (engine.origin - level.player.origin);
	desiredAngles = VectorToAngles(playerToEngine);
	//desiredAngles = (-15, desiredAngles[1], desiredAngles[2]);
	tagToEngine.angles = desiredAngles;
	tag.angles = level.ground_ref_ent.angles;
	
	tag LinkTo(tagToEngine);
	
	level.custom_linkto_slide = true;    
    forward = -1.0* AnglesToForward( tagToEngine.angles );
    level.player SetVelocity( forward * 400 );
    
    level.custom_linkto_slide_allow_prone = true;    
    level.player hjk_BeginSliding();
	
    

	//tag.angles = level.ground_ref_ent.angles;
	level.player PlayerSetGroundReferenceEnt(tag);
	//wait .3;
	tagToEngine RotatePitch(-25, .2, 0, .15);
	wait .1;
    
	level.player hjk_EndSliding();
    level.custom_linkto_slide_allow_prone = undefined;
	
	wait .6;	
	
	tagToEngine RotatePitch(25, .8, .4, .1);
	wait .8;
	
	//rotate back to whatever drunk player walk was doing.
	tag RotateTo(level.ground_ref_ent.angles, .5, .4, .1);
	wait .5;
	level.ground_ref_ent.angles = tag.angles;

	//restore the old
	level.player PlayerSetGroundReferenceEnt(level.ground_ref_ent);
}

tail_random_explosions()
{
	// Add random looping explosions on Tail Chunk
	level endon("entered_post_tarmac_area");
	flag_wait("player_exit_plane_4");
	
	while(1)
	{
		exploder("random_tail_exp");
		aud_send_msg("random_tail_expl");
		earthquake( .05, 2.0, ( 8820.26, 7283.35, 239.12 ), 80000 );
		wait(RandomFloatRange(8,15));
	}
}

tail_final_explosion()
{
	// Tail has bigger explosion, swap corner of building with damage version, lots of fire
	flag_wait("tail_explosion");
	aud_send_msg("tail_explosion");
	level notify("big_tail_exp");
	stop_random_blur();
	
	exploder("final_tail_exp");
	earthquake( .50, 2.0, ( 8815.42, 7106.38, 273.014 ), 80000 );
	level.player shellshock( "hijack_tail_explosion", 1 );
	level.player PlayRumbleOnEntity( "hijack_plane_medium" );
	
	exploder("tail_exp_fire_1");
	exploder("tail_exp_fire_2");
	exploder("tail_exp_fire_3");
	exploder("tail_exp_fire_4");
	
	/*anim_origin = GetStruct("tail_fall_anim_struct","targetname");
	big_tail_piece = GetEnt("tail_piece_big","targetname");
	small_tail_piece = GetEnt("tail_piece_small","targetname");
	
	rig = spawn_anim_model("tail_prop");
	waittillframeend;	
	anim_origin thread anim_first_frame_solo( rig, "plane_tail_collapse" );
	rig attach("hjk_plane_dmg_tail_back","J_prop_1");
	rig attach("hjk_plane_dmg_tail_front","J_prop_2");
	//big_tail_piece linkto( rig , "J_prop_1" );
	//small_tail_piece linkto( rig , "J_prop_2" );
	big_tail_piece delete();
	small_tail_piece delete();
	
	anim_origin anim_single_solo( rig, "plane_tail_collapse" );*/
	restart_random_blur();
}

player_breathing_sound()
{
	while(!flag("entered_post_tarmac_area"))
	{
		level.player play_sound_on_entity( "breathing_hurt_start" );
		wait(RandomFloatRange(2,5));
	}
	
	level.player play_sound_on_entity( "breathing_better" );
}

tarmac_dead_allies()
{
	wait(1);
	level.secret_service_dead = array_spawn_targetname( "dead_secret_service" );
	level.secret_service_dead_no_weapons = array_spawn_targetname("dead_secret_service_no_weapon");
	foreach (dude in level.secret_service_dead_no_weapons)
	{
		dude gun_remove();
	}
	level.secret_service_dead = array_combine(level.secret_service_dead,level.secret_service_dead_no_weapons);
	foreach (dude in level.secret_service_dead)
	{
		dude.no_pain_sound = true;
		dude.diequietly = true;
		dude.delete_on_death = false;
		dude kill();
	}
}

main_script_thread()
{
	flag_set( "pause_inflight_fx" );
	flag_clear( "pause_tarmac_fx" );	
	
	thread maps\_blizzard_hijack::blizzard_level_transition_light( 3 );
	thread maps\_blizzard_hijack::blizzard_overlay_clear(); 
	
	battlechatter_off( "axis" );
	//thread set_vision_set( "hijack", 1 );

	flag_init( "stop_aftermath_player" );

	thread tarmac_fail_conditions();
	thread exit_plane_scene();
	thread tarmac_objectives();
	thread tarmac_events();
	thread makarov_heli();
	thread maps\hijack_script_2b::main();
}

tarmac_fail_conditions()
{	
	flag_wait("tarmac_level_fail");
	
	setDvar( "ui_deadquote", &"HIJACK_FAIL_TARMAC" );
	level notify( "mission failed" );
	missionFailedWrapper();
}

tarmac_carnage()
{
	tarmac_dead_allies();
	wait(1);
	
	scene_origin = getstruct("post_crash_scene_origin", "targetname" );
	
	thread FSO_idlers(scene_origin);
	thread FSO_check_deadguy(scene_origin);
	thread FSO_scout_and_terrorist(scene_origin);
	wait(1); // needed to avoid spawning too many guys at the same time
	thread FSO_engine_react();
	thread FSO_tail_explosion_react(scene_origin);
	thread FSO_trapped_agent(scene_origin);
	
	wait(1);
	ai = GetAIArray();
	foreach(guy in ai)
	{
		if ( !IsEnemyTeam(guy.team,level.player.team) )
		{
			guy thread cold_breath_hijack();
		}
	}
}

FSO_idlers(scene_origin)
{
	FSO_agents[0] = spawn_targetname( "FSO_idlers_0" );	// staff_a
	FSO_agents[1] = spawn_targetname( "FSO_idlers_1" );	// has dialogue, needs to be FSO agent
	FSO_agents[2] = spawn_targetname( "FSO_idlers_2" );	// secretary
	
	FSO_agents[2] deletable_magic_bullet_shield();
	FSO_agents[0] thread cold_breath_hijack();
	FSO_agents[1] thread cold_breath_hijack();
	FSO_agents[2] thread cold_breath_hijack();
	
	foreach(guy in FSO_agents)
	{
		guy.animname = "generic";
		if ( guy.weapon != "none" )
		{
			guy gun_remove();
		}
	}
	
	scene_origin thread anim_loop_solo(FSO_agents[0],"injured_hands_on_knees");
	scene_origin thread anim_loop_solo(FSO_agents[1],"injured_on_back");
	scene_origin thread anim_loop_solo(FSO_agents[2],"injured_leg_loop");
	
	flag_wait("fso_arm_vo");
	wait(0.5);
	FSO_agents[1] dialogue_queue("hijack_fso1_myarm");
	
	flag_wait("entered_post_tarmac_area");
	if ( IsDefined(FSO_agents[0]) )
	{
		FSO_agents[0] delete();
	}
	if ( IsDefined(FSO_agents[2]) )
	{
		FSO_agents[2] delete();
	}
}

FSO_check_deadguy(scene_origin)
{
	guys = [];
	guys[0] = spawn_targetname( "FSO_check_deadguy_agent" );
	guys[1] = spawn_targetname( "FSO_check_deadguy_hijacker" );
	guys[1].ignoreall = true;
	guys[1].ignoreme = true;
	guys[1] gun_remove();
	
	guys[0] thread cold_breath_hijack();
	
	guys[0] thread commander_lookat(400, 3.0);
	
	guys[0].animname = "checkguy";
	guys[1].animname = "deadguy";
	
	scene_origin thread anim_first_frame(guys,"checkdeadguy_start");
	
	flag_wait("start_checkdeadguy_anim");
	
	scene_origin anim_single(guys,"checkdeadguy_start");
	scene_origin thread anim_loop(guys,"checkdeadguy_loop");
	
	flag_wait("entered_post_tarmac_area");
	guys[0] delete();
	guys[1] delete();
}

FSO_scout_and_terrorist(scene_origin)
{
	FSO_scout = spawn_targetname( "FSO_scout" );
	buried_hijacker = spawn_targetname( "buried_hijacker" );
	FSO_scout.ignoreall = true;
	FSO_scout.ignoreme = true;
	buried_hijacker.ignoreall = true;
	buried_hijacker.ignoreme = true;
	buried_hijacker gun_remove();

	buried_hijacker thread cold_breath_hijack();
	FSO_scout thread cold_breath_hijack();
	
	FSO_scout.animname = "generic";
	buried_hijacker.animname = "generic";
	
	buried_hijacker thread commander_lookat(400, 3.0);
		
	scene_origin thread anim_first_frame_solo(FSO_scout,"scout_finds_buried_hijacker");
	scene_origin thread anim_first_frame_solo(buried_hijacker,"buried_hijacker");
	
	rig = spawn_anim_model("plane_seats");
	waittillframeend;
	scene_origin thread anim_first_frame_solo( rig, "buried_prop" );
	rig attach("hjk_seat_cover_sml","J_prop_1");

	flag_wait("move_commander_to_flare_node");
	wait(2);
	
	FSO_scout.lastGroundtype = "snow";
	scene_origin thread anim_single_solo(FSO_scout,"scout_finds_buried_hijacker");
	scene_origin thread anim_single_solo(buried_hijacker,"buried_hijacker");
	scene_origin thread anim_single_solo(rig,"buried_prop");
	
	buried_hijacker waittillmatch( "single anim", "die" );
	thread anim_set_rate_single(buried_hijacker,"buried_hijacker",0.00);
	thread anim_set_rate_single(rig,"buried_prop",0.00);
	buried_hijacker notify( "stop personal effect" );
	buried_hijacker.team = "neutral";
	FSO_scout SetGoalPos(FSO_scout.origin);
	
	flag_wait("entered_post_tarmac_area");
	buried_hijacker delete();
	FSO_scout delete();
}

FSO_engine_react()
{
	FSO_agents[0] = spawn_targetname( "FSO_engine_react_0" );	// guy dragging
	FSO_agents[1] = spawn_targetname( "FSO_engine_react_1" );	// guy being dragged (staff_b)
	FSO_agents[2] = spawn_targetname( "FSO_engine_react_2" );	// not currently used
	
	FSO_agents[0] thread cold_breath_hijack();
	FSO_agents[1] thread cold_breath_hijack();
	FSO_agents[2] thread cold_breath_hijack();
	
	scene_origin = getstruct("temp_exp_anim_origin", "targetname" );
	
	foreach(guy in FSO_agents)
	{
		guy.animname = "generic";
		if ( guy.weapon != "none" )
		{
			guy gun_remove();
		}
	}
	
	FSO_agents[2] delete();
	scene_origin thread anim_first_frame_solo(FSO_agents[0],"drag_from_engine_agent1");
	scene_origin thread anim_first_frame_solo(FSO_agents[1],"drag_from_engine_agent2");
	//scene_origin thread anim_first_frame_solo(FSO_agents[2],"drag_from_engine_agent3");
	
	flag_wait("start_exp_anims");
	
	scene_origin thread anim_single_solo(FSO_agents[0],"drag_from_engine_agent1");
	scene_origin thread anim_single_solo(FSO_agents[1],"drag_from_engine_agent2");
	//scene_origin thread anim_single_solo(FSO_agents[2],"drag_from_engine_agent3");
	
	FSO_agents[0] waittillmatch( "single anim", "end" );
	
	scene_origin thread anim_loop_solo(FSO_agents[0],"drag_from_engine_agent1_loop");
	scene_origin thread anim_loop_solo(FSO_agents[1],"drag_from_engine_agent2_loop");
	//scene_origin thread anim_loop_solo(FSO_agents[2],"drag_from_engine_agent3_loop");
}

FSO_tail_explosion_react(scene_origin)
{
	FSO_agents[0] = spawn_targetname( "FSO_tail_react_0" );		// helper (secretary model)
	FSO_agents[1] = spawn_targetname( "FSO_tail_react_1" );		// injured dude 
	
	FSO_agents[0] deletable_magic_bullet_shield();
	FSO_agents[0] thread cold_breath_hijack();
	FSO_agents[1] thread cold_breath_hijack();
	
	foreach(guy in FSO_agents)
	{
		guy.animname = "generic";
		if ( guy.weapon != "none" )
		{
			guy gun_remove();
		}
	}
	
	scene_origin thread anim_loop_solo(FSO_agents[0],"reach_to_explosion_agent1_loop_start","stop_tail_exp_loop");
	scene_origin thread anim_loop_solo(FSO_agents[1],"reach_to_explosion_agent2_loop_start","stop_tail_exp_loop");

	flag_wait("start_tail_exp_anims");
	
	scene_origin notify("stop_tail_exp_loop");
	scene_origin thread anim_single_solo(FSO_agents[0],"reach_to_explosion_agent1");
	scene_origin thread anim_single_solo(FSO_agents[1],"reach_to_explosion_agent2");
	
	FSO_agents[0] waittillmatch( "single anim", "explosion_reaction_2" );
	
	flag_set("tail_explosion");
	
	wait(2);
	FSO_agents[0] dialogue_queue("hijack_fso1_injuredman");
	
	FSO_agents[0] waittillmatch( "single anim", "end" );

	scene_origin thread anim_loop_solo(FSO_agents[0],"reach_to_explosion_agent1_loop_end");
	scene_origin thread anim_loop_solo(FSO_agents[1],"reach_to_explosion_agent2_loop_end");
}

FSO_trapped_agent(scene_origin)
{
	FSO_agents[0] = spawn_targetname( "FSO_trapped_agent_0" );
	FSO_agents[1] = spawn_targetname( "FSO_trapped_agent_1" );	// staff_a
	FSO_agents[2] = spawn_targetname( "FSO_trapped_agent_2" );
		
	FSO_agents[0] thread cold_breath_hijack();
	FSO_agents[1] thread cold_breath_hijack();
	FSO_agents[2] thread cold_breath_hijack();
	
	foreach(guy in FSO_agents)
	{
		guy.animname = "generic";
		if ( guy.weapon != "none" )
		{
			guy gun_remove();
		}
	}
	
	scene_origin thread anim_first_frame_solo(FSO_agents[0],"samaritan_start");
	scene_origin thread anim_first_frame_solo(FSO_agents[1],"limping_agent_start");
	scene_origin thread anim_first_frame_solo(FSO_agents[2],"trapped_agent_start");
	
	rig = spawn_anim_model("metal_beam");
	waittillframeend;
	scene_origin thread anim_first_frame_solo( rig, "trapped_prop" );
	rig attach("hjk_plane_debris_02","J_prop_1");
	
	flag_wait("start_trapped_anims");
	
	FSO_agents[0].lastGroundtype = "snow";
	FSO_agents[0] thread play_anim_and_loop(scene_origin,"samaritan_start","samaritan_loop");
	FSO_agents[1] thread play_anim_and_loop(scene_origin,"limping_agent_start","limping_agent_loop");
	FSO_agents[2] thread play_anim_and_loop(scene_origin,"trapped_agent_start","trapped_agent_loop");
	scene_origin thread anim_single_solo(rig,"trapped_prop");
	
	wait(8);
	FSO_agents[2] dialogue_queue("hijack_fso3_helpme");
	
	wait(2);
	FSO_agents[0] dialogue_queue("hijack_fso1_agentdown");
	
	wait(8);
	FSO_agents[0] dialogue_queue("hijack_fso2_medical");
}

play_anim_and_loop(scene_origin,single_anim,loop_anim)
{
	scene_origin anim_single_solo(self,single_anim);
	if ( isdefined(self) )
	{
		scene_origin anim_loop_solo(self,loop_anim);
	}
}

makarov_heli()
{
	level endon( "kill_heli_1" );
	flag_wait("spawn_makarov_heli");
	level.makarov_heli = spawn_vehicle_from_targetname_and_drive("makarov_heli");
	
	level.makarov_heli_door = Spawn("script_model",level.makarov_heli.origin);
	level.makarov_heli_door SetModel("vehicle_mi17_woodland_landing_door");
	level.makarov_heli_door.angles = level.makarov_heli.angles;
	level.makarov_heli_door LinkTo(level.makarov_heli);
	
	spotlight_wait_time = 1.6;
	if ( level.start_point == "post_tarmac" || level.start_point == "end_scene" )
	{
		spotlight_wait_time = 0.0;	
	}
	level.makarov_heli thread setup_spotlight(spotlight_wait_time);
	level.makarov_heli thread manage_spotlight_targets();
	
	level.makarov_heli ent_flag_init("makarov_heli_reached_end");
	level.makarov_heli ent_flag_init("start_commander_anim");
	level.makarov_heli ent_flag_init("makarov_heli_disable_spotlight");
	level.makarov_heli ent_flag_init("heli_start_flyaway");
	level.makarov_heli ent_flag_init("heli_end_flyaway");
	level.makarov_heli ent_flag_init("heli_start_approach");
	level.makarov_heli ent_flag_init("heli_end_approach");

	// AUDIO: threaded loop manages chopper sound override init and doppler
	thread maps\hijack_aud::loop_chopper_makarov_flyover(); // AUDIO: override chopper sounds
	
	if ( level.start_point != "post_tarmac" && level.start_point != "end_scene" )
	{
		flag_wait("commander_finished_engine_react_anim");
		wait(0.25);
		level.commander dialogue_queue( "hijack_cmd_evacchoppers" );
	}
	
	if ( level.start_point == "end_scene" )
	{
		return;
	}
	
	// trigger in script_2b at beginning of combat
	// if you start end checkpoint, thread should end before this.
	flag_wait("move_heli_to_hover_point");
	
	// NEW - Fly out of sight
	level.makarov_heli vehicle_detachfrompath();
	flyaway_node = GetStruct("heli_fly_away", "targetname");
	level.makarov_heli SetGoalYaw(flyaway_node.angles[1]);
	level.makarov_heli SetTargetYaw(flyaway_node.angles[1]);
	level.makarov_heli SetVehGoalPos(flyaway_node.origin, 1);
	//level.makarov_heli setHoverParams( 175, 40, 20 );
	level.makarov_heli waittill_any( "near_goal", "goal" );
	//level.makarov_heli ent_flag_wait( "heli_start_flyaway" );
	
	level.makarov_heli thread vehicle_paths(flyaway_node);
	level.makarov_heli ent_flag_wait( "heli_end_flyaway" );
	
	// turn and be ready to return
	level notify("stop_spotlight_fx");
	level.makarov_heli vehicle_detachfrompath();
	approach_node = GetStruct("heli_approach", "targetname");
	level.makarov_heli SetGoalYaw(approach_node.angles[1]);
	level.makarov_heli SetTargetYaw(approach_node.angles[1]);
	level.makarov_heli SetVehGoalPos(approach_node.origin, 1);
	//level.makarov_heli setHoverParams( 175, 40, 20 );
	level.makarov_heli waittill_any( "near_goal", "goal" );
	//level.makarov_heli ent_flag_wait( "heli_start_approach" );
	thread makarov_heli_2();
}

makarov_heli_2()
{
	// NEW - Fly to hover position
	flag_wait( "heli_start_approach" );
	
	aud_send_msg("end_heli_approach");
	
	level notify( "kill_heli_1" );
	
	//spotlight_wait_time = 0.0;
	//level.makarov_heli thread setup_spotlight(spotlight_wait_time);
	level.makarov_heli.spotlight thread spot_light( "heli_spotlight", "tag_flash", level.makarov_heli );
	
	approach_node = GetStruct("heli_approach", "targetname");
	level.makarov_heli thread vehicle_paths(approach_node);
	level.makarov_heli ent_flag_wait( "heli_end_approach" );
	
	// Now attach to original hover point
	level.makarov_heli vehicle_detachfrompath();
	hover_node = GetStruct("heli_start_descent", "targetname");
	
	level.makarov_heli SetGoalYaw(hover_node.angles[1]);
	level.makarov_heli SetTargetYaw(hover_node.angles[1]);
	level.makarov_heli SetVehGoalPos(hover_node.origin, 1);
	level.makarov_heli setHoverParams( 175, 40, 20 );
	
	level.makarov_heli thread maps\hijack_script_2c::spotlight_monitor_end();
	
	// there has to be enough time between "move_heli_to_hover_point" and "start_heli_descent"
	// (aka "player_entered_end_area" + time it takes commander to reach his anim start)
	// to get the heli to the hover point no matter where it is
	flag_wait("start_heli_descent");

	level.makarov_heli thread maps\hijack_script_2c::heli_lands();
	
	descend_node = GetStruct("heli_start_descent","targetname");
	level.makarov_heli thread vehicle_paths(descend_node);
}

manage_spotlight_targets()
{
	level.makarov_heli thread spotlight_monitor_flyover();
	flag_wait("start_spotlight_random_targeting");
	level.makarov_heli thread spotlight_monitor_random_targets();
}

setup_spotlight(wait_time)
{
	self.spotlight = SpawnTurret( "misc_turret", self GetTagOrigin( "tag_turret" ), "heli_spotlight" );
	self.spotlight SetMode( "manual" );
	self.spotlight SetModel( "com_blackhawk_spotlight_on_mg_setup" );
	self.spotlight LinkTo( self, "tag_turret" );
	self.spotlight MakeUnusable();

	if (isdefined(wait_time))
	{
		wait(wait_time);
	}
	self.spotlight thread spot_light( "heli_spotlight", "tag_flash", self );
}

spot_light( fxname, tag_name, death_ent )
{
    struct = SpawnStruct();
    struct.effect_id = getfx( fxname );
    struct.entity = self;
    self.spot_light = struct;
    struct.tag_name = tag_name;
	
    playFXOnTag( struct.effect_id , struct.entity, struct.tag_name );
	
	thread spot_light_death( death_ent );
	
	level waittill("stop_spotlight_fx");
	if ( isdefined(struct.entity) )
	{
		StopFXOnTag( struct.effect_id , struct.entity, struct.tag_name );
		wait(0.05);
		struct.effect_id_off = getfx( fxname + "_off" );
		PlayFXOnTag( struct.effect_id_off , struct.entity, struct.tag_name );
	}
}

spot_light_death( death_ent )
{
    self endon ( "death" );
    if (isdefined(death_ent))
    {
    	death_ent waittill ( "death" );
    }
    self Delete();
}


update_spotlight_targets()
{
	while(1)
	{
		right = AnglesToForward( self.angles * (0,1,0) + ( 40, -25, 0 ) );
		self.spotlight_target_right.origin = self GetTagOrigin( "tag_turret" ) + ( right * 100 );
		
		left = AnglesToForward( (self.angles * (0,1,0)) + ( 40, 25, 0 ) );
		self.spotlight_target_left.origin = self GetTagOrigin( "tag_turret" ) + ( left * 100 );
		
		wait(0.05);
	}
}

spotlight_monitor_flyover()
{
	self endon( "death" );
	self endon( "start_random_spotlight_targets" );
	self endon( "shine_spotlight_on_president" );
	
	tail_target_1 = GetEnt("tail_spotlight_target_1","targetname");
	self.spotlight SetTargetEntity( tail_target_1 );
	
	wait(4);

	tail_target_2 = GetEnt("tail_spotlight_target_2","targetname");
	dummy_spotlight_target =  Spawn( "script_origin", tail_target_2.origin );
	self.spotlight SetTargetEntity( dummy_spotlight_target );
	dummy_spotlight_target thread maps\hijack_script_2c::move_around_target(tail_target_2);
	
	wait(4);
	ring_target = GetEnt("ring_spotlight_target","targetname");
	self.spotlight SetTargetEntity(ring_target);
	
	flag_wait("commander_ready_for_heli");
	self.spotlight SetTargetEntity(level.commander);
	
	wait(4);
	
	flag_set("start_spotlight_random_targeting");
}

spotlight_monitor_random_targets()
{
	self endon( "death" );
	self endon( "shine_spotlight_on_president" );
	self notify("start_random_spotlight_targets");
	
	self.spotlight_target_right = Spawn( "script_origin", self.origin );
	self.spotlight_target_left = Spawn( "script_origin", self.origin );
	
	self childthread update_spotlight_targets();
	
	while ( 1 )
	{
		self.spotlight SetTargetEntity( self.spotlight_target_right );
		
		wait(2);
		
		self.spotlight SetTargetEntity( self.spotlight_target_left );
		
		wait(2);
	}
}

setup_vehicle_light_types()
{
	//lightmodel = get_light_model( "vehicle_suburban" , "script_vehicle_suburban" );
	//build_light( lightmodel , "headlight_right", "TAG_LIGHT_RIGHT_FRONT", "misc/car_headlight_suburban_R", 	"headlights" , 0.2 );
	//build_light( lightmodel , "headlight_left", "TAG_LIGHT_LEFT_FRONT", "misc/car_headlight_suburban_L", 	"headlights" , 0.2 );
	//build_light( lightmodel , "taillight_right", "TAG_LIGHT_RIGHT_TAIL", "misc/car_taillight_suburban_R", 	"headlights" , 0.2 );
	//build_light( lightmodel , "taillight_left", "TAG_LIGHT_LEFT_TAIL", "misc/car_taillight_suburban_L", 	"headlights" , 0.2 );
}

turn_on_headlights()
{
	self vehicle_lights_on();
	
	self waittill( "death" );
	
	self vehicle_lights_off( "all" );
}
