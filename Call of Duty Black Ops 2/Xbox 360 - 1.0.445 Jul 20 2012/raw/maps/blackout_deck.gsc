/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
 #include maps\blackout_util;
 #include maps\blackout_anim;
 #include common_scripts\utility;
 #include maps\_utility;
 #include maps\_vehicle;
 #include maps\_colors;
 #include maps\_scene;
 #include maps\_objectives;
 #include maps\_dialog;
 
#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

// skipto initialization functions 

init_flags()
{
	flag_init( "anderson_take_off" );
	flag_init( "start_evac" );
	flag_init( "drone_swarm" );
}

init_spawn_funcs()
{
	CreateThreatBiasGroup( "player_and_team" );
	CreateThreatBiasGroup( "ambient_axis_ai" );
	CreateThreatBiasGroup( "ambient_ally_ai" );
	
	spawners = GetEntArray( "sm_3_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 3 );
	}
	
	spawners = GetEntArray( "sm_4_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 4 );
		spawners[ i ] add_spawn_function( ::ignore_player );
		spawners[ i ] add_spawn_function( ::kill_ignored_ai );
	}
	
	spawners = GetEntArray( "sm_5_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 5 );
	}
	
	spawners = GetEntArray( "sm_6_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 6 );
	}
	
	spawners = GetEntArray( "sm_7_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 7 );
		spawners[ i ] add_spawn_function( ::kill_ignored_ai_final_2 );
	}
	
	spawners = GetEntArray( "sm_8_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 8 );
		spawners[ i ] add_spawn_function( ::ignore_player );
		spawners[ i ] add_spawn_function( ::kill_ignored_ai );
	}
	
	spawners = GetEntArray( "sm_9_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 9 );
	}
	
	spawners = GetEntArray( "sm_10_spawner", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::set_goal_volume_sm, 10 );
		spawners[ i ] add_spawn_function( ::ignore_player );
		spawners[ i ] add_spawn_function( ::kill_ignored_ai_final );
	}
	
	spawners = GetEntArray( "deck_navy_set1", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::magic_bullet_shield );
		spawners[ i ] add_spawn_function( ::kill_ignored_ai );
		spawners[ i ] add_spawn_function( ::ignore_main_ai );
	}
	
	spawners = GetEntArray( "deck_navy_set2", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] add_spawn_function( ::magic_bullet_shield );
		spawners[ i ] add_spawn_function( ::kill_ignored_ai_final );
		spawners[ i ] add_spawn_function( ::ignore_main_ai );
	}
	
	spawners = GetEnt( "redshirt1", "targetname" );
	spawners add_spawn_function( ::kill_ignored_ai );
	spawners add_spawn_function( ::ignore_main_ai );
	
	spawners = GetEnt( "redshirt2", "targetname" );
	spawners add_spawn_function( ::kill_ignored_ai );
	spawners add_spawn_function( ::ignore_main_ai );
	
}

skipto_mason_deck()
{
	mason_part_2_animations();
	
	skipto_setup();
	
	setup_threat_bias_group();
	
	level.is_briggs_alive = true;
	
	level thread spawn_menendez_f38_for_skipto();
	
	if ( !( level.player get_story_stat( "HARPER_DEAD_IN_YEMEN" ) ) )
	{
		level.harper = init_hero_startstruct( "harper", "harper_deck_tele" );
		
		if ( level.player get_story_stat( "HARPER_SCARRED" ) )
		{
			level.harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
		}
		
		level.harper set_force_color( "r" );
	}
	
	for( i = 1; i < 4; i++ )
	{
		seal = simple_spawn_single( "support_seal_" + i );
		seal thread magic_bullet_shield();
	}
	
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "redshirt_deck_tele" );
	
	level.ai_redshirt1 set_force_color( "g" );
	
	trigger = GetEnt( "move_allies_off_elevator", "targetname" );
	trigger activate_color_trigger( "allies" );
	
	level notify( "start_vtol_timer" );
	
	skipto_teleport_players("player_skipto_mason_deck");
}

skipto_mason_plane_crash()
{
	mason_part_2_animations();
	
	skipto_setup();
	level notify( "start_vtol_timer" );
	
	skipto_teleport_players("player_skipto_mason_plane_crash");
}

skipto_mason_deck_final()
{
	mason_part_2_animations();
	
	skipto_setup();
	level notify( "start_vtol_timer" );
	
	skipto_teleport_players("player_skipto_mason_deck_final");
}

skipto_mason_anderson()
{
	mason_part_2_animations();
	
	skipto_setup();
	level notify( "start_vtol_timer" );
	
	skipto_teleport_players("player_skipto_mason_anderson");
}

spawn_menendez_f38_for_skipto()
{
	f35 = spawn_vehicle_from_targetname( "F35"  );
	f35 thread go_path( GetVehicleNode( "menedez_deck_start", "targetname" ) );
	f35 Attach( "veh_t6_air_fa38_landing_gear", "tag_landing_gear_down" );
	f35 thread takeoff_sound();
	
	set_objective( level.OBJ_STOP_MENEN, f35 );

	level thread menendez_f38_VO();
	
	f35 thread increase_f35_speed();
	
	level waittill( "take_off" );
	
	f35 waittill( "reached_end_node" );
	f35 Delete();
}

takeoff_sound()
{
	menendez_f38 = GetEnt( "F35" , "targetname" );
	sound_ent = Spawn( "script_origin" , menendez_f38.origin );
	sound_ent LinkTo( menendez_f38 , "tag_canopy" );
	//sound_ent PlaySound( "evt_menendez_takeoff" , "sound_done" );//kevin putting sound on f35
	sound_ent PlayloopSound( "evt_menendez_takeoff");
	wait 27;
	sound_ent Delete();
}

menendez_f38_VO()
{
	level waittill( "take_off" );
	level.player thread say_dialog( "sect_shit_menendez_got_a_0" );
	level thread play_dradis_and_general_pip();
}

increase_f35_speed()
{
	level endon( "resume_speed" );
	
	trigger_wait ( "menedez_take_off" );
	self SetSpeed( 15 );
	
	self thread f35_resume_speed();
}

f35_resume_speed()
{
	level waittill("resume_speed");
	self ResumeSpeed( 10 );
}

// skipto run functions



run_mason_deck()
{
	autosave_by_name( "after_elevator" );
	
	level thread brute_force();
	
	level thread kill_player_before_take_off();
	setup_threat_bias_group();
	
	spawn_manager_enable( "sm_3" );
	simple_spawn( "deck_navy_set1" );

	level thread deck_first_wave_manager();	
}


kill_player_before_take_off()
{
	level endon( "dont_kill_player" );
	level thread end_kill_player_function();
	
	trigger_wait( "trigger_kill_player_menendez_take_off" );
	
	while( 1 )
	{
		vector_forward = ( anglestoforward( level.player.angles ) * -50 ) + ( 0, 0, 30 );
		MagicBullet( "vector_sp", level.player.origin + vector_forward, level.player.origin + ( 0, 0, 30 ) );
		wait 0.75;
	}
}

end_kill_player_function()
{
	trigger = GetEnt( "trigger_kill_player_menendez_take_off", "targetname" );
	trigger endon ( "trigger" );
	
	level waittill( "resume_speed" );
	level notify( "dont_kill_player" );
}

falling_deck_cover()
{
	trigger_wait( "falling_debris_cover_trigger" );
	level notify( "fxanim_drone_cover_start" );
}

deck_first_wave_manager()
{
	level thread watch_wave0();

	level waittill_either( "resume_speed", "wave0_killed" );
	spawn_manager_enable( "sm_9" );
	spawn_manager_enable( "sm_4" );
	
}

watch_wave0()
{
	level endon( "resume_speed" );
	
	waittill_ai_group_amount_killed( "wave0_group", 5 );
	
	level notify( "wave0_killed" );
}

run_mason_plane_crash()
{
	level waittill( "resume_speed" );
		
	if( IsDefined( level.redshirt1 ) )
	{
		level.redshirt1 set_force_color( "g" );
	}
	
	if( IsDefined( level.redshirt2 ) )
	{
		level.redshirt2 set_force_color( "g" );
	}
	
	trigger_use( "allies_red_deck_trigger_1" );
		
	set_objective( level.OBJ_STOP_MENEN, undefined, "done" );
	
	autosave_by_name( "menendez_took_off" );
	
	set_objective( level.OBJ_CLEAR );
				
	waittill_ai_group_amount_killed( "wave1_group", 4 );
	
	level thread play_drone_swarm();
	level thread f38_crash();
	
	if ( level.is_briggs_alive )
	{
		sea_cowbell();
		level.fire_at_drones = true;
		level thread randomly_destroy_drone();
	}
	
	waittill_ai_group_amount_killed( "wave1_group", 5 );
	
	level thread manage_f38_attackers();
	
	trigger_use( "allies_red_deck_trigger_2" );
		
	s_planes = get_struct( "struct_ambient_planes", "targetname" );
	play_fx( "fx_la_drones_above_city", s_planes.origin, s_planes.angles );
	
	waittill_ai_group_amount_killed( "wave2_group", 8 );
	
	level thread falling_deck_cover();
}



f38_crash()
{
	trigger_wait( "crash_trigger" );
	level notify( "fxanim_f38_launch_fail_start" );
}

play_dradis_and_general_pip()
{
	wait 1;
	
	level thread play_pip( "blackout_dradis" );
	
	waittill_ai_group_amount_killed( "wave1_group", 4 );
	
	level thread play_pip( "blackout_general" );
	level thread five_start_general_VO();
}

five_start_general_VO()
{
	level.player say_dialog( "gene_we_re_looking_at_a_d_0" );
	level.player say_dialog( "gene_the_entire_drone_fle_0" );
	level.player say_dialog( "gene_we_have_reports_that_0" );
	level.player say_dialog( "gene_destination_unknown_0" );
	
	level.player say_dialog( "sect_they_re_under_his_co_0" );
	level.player say_dialog( "sect_attention_all_on_thi_0" );
	level.player say_dialog( "sect_prep_for_evac_we_h_0" );
}

crash_explosion()
{
	explo_struct = getstruct( "drone_crash_explosion", "targetname" );
	MagicBullet( "f35_missile_turret", explo_struct.origin, explo_struct.origin - ( 0, 0, 10 ) );
}

manage_f38_attackers()
{
	level.deck_wave = 1;
	level.assault_wave1_count = 15;
	level.assault_wave2_count = 14;
	level.attacker_struct_index = 1;
	
	spawn_manager_enable( "sm_5" );
	spawn_manager_enable( "sm_8" );
	
}

run_mason_anderson()
{	
	level thread anderson_takeoff_vo();
	
	trigger_use( "allies_red_deck_trigger_3" );
	
	obj_struct = getstruct( "elevator_objective_struct", "targetname" );
	set_objective( level.OBJ_BREADCRUMB, obj_struct.origin, "breadcrumb" );
	
	spawn_manager_enable( "sm_6" );
	
	autosave_by_name( "drone_attack" );
	
	waittill_ai_group_amount_killed( "wave3_group", 2 );
	spawn_manager_enable( "sm_7" );
	
	trigger_use( "allies_red_deck_trigger_4" );
	
	waittill_ai_group_amount_killed( "wave4_group", 5 );
}

anderson_takeoff_vo()
{
	level.player say_dialog( "ande_section_this_is_an_1" );
	level.player say_dialog( "sect_go_ahead_anderson_0", 0.5 );
	level.player say_dialog( "ande_i_have_orders_from_h_0", 0.5 );
	level.player say_dialog( "sect_not_yet_we_have_to_0", 0.5 );
	level.player say_dialog( "ande_it_s_hopeless_secti_0", 0.5 );
}

drones_firing_at_the_player()
{
	level endon( "player_in_vtol" );
	
	player_last_pos = level.player.origin;
	
	wait 3;
	
	while( 1 )
	{
		player_last_pos = level.player.origin;
		
		wait 5;
		
		bullet = MagicBullet( "f35_missile_turret", player_last_pos + ( 0, 0, 300 ), player_last_pos );
		bullet thread drone_missile_earthquake();
	}

	
}

harper_follow_icon()
{
	set_objective( level.OBJ_FOLLOW, level.harper, "follow" );
	
	trigger_wait( "kill_past_ai" );
	
	wait 1;
	
	set_objective( level.OBJ_FOLLOW, level.harper, "delete" );
}

drone_missile_earthquake()
{
	wait 0.2;
	
	Earthquake( 0.75, 1, level.player.origin, 100);
}

run_mason_deck_final()
{	
	set_objective( level.OBJ_BREADCRUMB, undefined, "delete" );
	
	level thread player_vtol();
	
	level thread watch_for_mission_fail();
	
	trigger_linkto_vtol = GetEnt( "vtol_trigger_origin", "targetname" );
	trigger_linkto_vtol wait_till_player_close_enough();
	
	
	level notify( "player_in_vtol" );
	level.b_vtol_reached = true;
	
	set_objective( level.OBJ_EVAC, level.obj_vtol_door, "done" );
	
	if ( level.is_harper_alive )
	{
		level thread run_scene( "harper_vtol_escape" );
	}
	
	level thread mason_anderson_dialog();
	
	level thread anderson_animations();
	run_scene( "player_vtol_escape" );
	
	level thread trigger_carrier_explosions();
	
	level thread run_scene( "player_vtol_escape_loop" );
	//level thread run_scene( "anderson_idle" );
	
	if ( level.is_harper_alive )
	{
		level thread run_scene( "harper_vtol_idle" );
	}
	
	level thread trigger_carrier_explosions();
	
	anim_timer = GetAnimLength( %vehicles::v_command_07_07_anderson_vtol_x78_takeoff_01 );
	
	wait anim_timer - 5;
	
	//Eckert - Fading sound out
	level clientnotify( "fade_out" );
	
	level.player notify( "mission_finished" );
	screen_fade_out( 2 );
	
	nextmission();
}

anderson_animations()
{
	run_scene( "anderson_end" );
	run_scene( "anderson_idle" );
}

mason_anderson_dialog()
{
	level.player say_dialog( "sect_go_go_go_0", 1 );
	level.anderson say_dialog( "ande_my_god_section_t_0", 1.5 );
	level.player say_dialog( "sect_things_are_about_to_0", 0.5 );
	level.player say_dialog( "sect_menendez_is_just_get_0", 0.2 );	
}

player_drop_gun()
{

	wait 12;
	
	set_objective( level.OBJ_CLEAR, undefined, "done" );
	set_objective( level.OBJ_EVAC, level.obj_vtol_door, "enter" );
	
	level.anderson thread say_dialog( "ande_section_we_have_to_0" );
	
	SetSavedDvar( "player_sprintUnlimited", 1 );
	level.player.overridePlayerDamage = ::vtol_player_override;

	level thread drones_firing_at_the_player();
}

player_vtol()
{
	level.vtol = spawn_vehicle_from_targetname( "player_vtol" );

	level thread run_scene( "vtol_taxi" );
	
	if ( level.is_harper_alive )
	{
		level thread run_scene( "harper_ground_loop" );
	}
	
	level.anderson = init_hero( "anderson" );
	level thread run_scene( "anderson_idle" );
	
	trigger_linkto_vtol = GetEnt( "vtol_trigger_origin", "targetname" );
	level.vtol_harper_pos = GetEnt( "vtol_harper", "targetname" );
	
	level.obj_vtol_door = Spawn( "script_model", trigger_linkto_vtol.origin );
	level.obj_vtol_door SetModel( "tag_origin" );
	level.obj_vtol_door LinkTo( level.vtol );
	
	level notify( "origin_spawned" );
	
	level.vtol_harper_pos LinkTo( level.vtol );
	trigger_linkto_vtol LinkTo( level.vtol );
	
	wait 5;
	
	level thread player_drop_gun();
	
	
	scene_wait( "vtol_taxi" );
	level thread run_scene( "vtol_takeoff" );
}

vtol_player_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	if( self.health < 50 )
	{
		if( str_weapon != "f35_missile_turret" )
		{
			n_damage = 0;
		}
	}
	
	return n_damage;
}

anderson_kill_wave_2()
{	
	anderson_f38 = spawn_vehicle_from_targetname( "anderson_kill_pmc" );
	anderson_f38 thread go_path( GetVehicleNode( "anderson_kill_pmc_path", "targetname" ) );
	
	anderson_f38 thread delete_at_end_node();
	spawn_manager_disable( "sm_7" );
		
	level waittill( "anderson_start_firing" );
	
	spawn_manager_disable( "sm_10" );
	anderson_f38.stop_firing = false;
	anderson_f38 thread anderson_watch_stop_firing();
	
	anderson_missiles_loc = getstruct( "anderson_missiles", "targetname" );
	
	while( !anderson_f38.stop_firing )
	{	
		turret_origin_1 = anderson_f38 GetTagOrigin( "tag_gunner_turret1" );
		turret_origin_2 = anderson_f38 GetTagOrigin( "tag_gunner_turret2" );
		
		MagicBullet( "f35_side_minigun", turret_origin_1, anderson_missiles_loc.origin );
		MagicBullet( "f35_side_minigun", turret_origin_2, anderson_missiles_loc.origin + ( turret_origin_2 - turret_origin_1 ) );
		
		wait 0.1;
	}
	
	tag_origin = anderson_f38 GetTagOrigin( "tag_gunner_turret1" );
	
	MagicBullet( "f35_missile_turret", tag_origin, anderson_missiles_loc.origin );
}

anderson_watch_stop_firing()
{
	level waittill( "anderson_stop_firing" );
	self.stop_firing = true;
}

trigger_carrier_explosions()
{	
	exploder( 11000 );

	Earthquake( 0.3, 2.0, level.player.origin, 100 );
}


watch_for_mission_fail()
{
	level endon( "player_in_vtol" );
	
	scene_wait( "vtol_taxi" );
	
	missionfailedwrapper( &"BLACKOUT_VTOL_FAIL" );
}

get_harper_to_the_vtol()
{
	level.harper endon( "reached_vtol" );
	
	level.harper_got_in_vtol = false;
	
	level.harper thread track_harper_reaching_vtol();
	
	level.harper set_ignoreall( true );
	level.harper set_ignoreSuppression( true );
	level.harper disable_pain();
	level.harper disable_ai_color();
	level.harper force_goal();
	
	level.harper thread change_movemode( "sprint" );
	
	while( 1 )
	{
		level.harper SetGoalPos( level.obj_vtol_door.origin );
		
		wait 0.05;
	}
}

track_harper_reaching_vtol()
{
	level waittill( "origin_spawned" );
	
	while( Distance2D( level.harper.origin, level.obj_vtol_door.origin ) > 100 ) 
	{
		wait 0.05;
	}
	
	level.harper notify( "reached_vtol" );
	
	run_scene( "harper_vtol_escape" );

	level.harper LinkTo( level.vtol_harper_pos );
	
	run_scene( "harper_vtol_idle" );
}

crashing_drone()
{
	trigger_wait( "trigger_drone_crash" );
	
	drone = spawn_vehicle_from_targetname( "veh_crash_drone" );
	drone thread go_path( GetVehicleNode( "crash_drone_path", "targetname" ) );
	
	level waittill( "drone_hit" );
	
	tag_origin = drone GetTagOrigin( "TAG_MISSILE_LEFT" );
	
	MagicBullet( "f35_missile_turret", drone.origin, drone.origin + anglestoforward( drone.angles ) );	
}

ambient_drone_manager()
{
	previous_drone_index = 0;
	random_drone_index = 0;
	
	while( 1 )
	{
		while( previous_drone_index == random_drone_index )
		{
			random_drone_index = RandomIntRange( 1, 6 );
			wait 0.05;
		}
		
		previous_drone_index = random_drone_index;
	
		level thread spawn_drone_to_fire( random_drone_index );
		
		wait 3;
	}
}

spawn_drone_to_fire( index )
{
	drone = spawn_vehicle_from_targetname( "veh_drone_deck_" + index );
	
	drone thread go_path( GetVehicleNode( "drone_path_" + index, "targetname" ) );
	drone thread delete_at_end_node();
	
	level waittill( "drone_fire_" + index );
	
	if( drone.vehicletype == "drone_pegasus" )
	{
		tag_origin = drone GetTagOrigin( "TAG_MISSILE_LEFT" );
		end_missile = getstruct( "drone_fire_missiles_end_" + index, "targetname" );
	
		MagicBullet( "f35_missile_turret", tag_origin, end_missile.origin );
		
		if( index == 5 )
		{
			tag_origin = drone GetTagOrigin( "TAG_MISSILE_Right" );
			end_missile = getstruct( "drone_fire_missiles_end_" + index + "_2", "targetname" );
			
			
			MagicBullet( "f35_missile_turret", tag_origin, end_missile.origin );
		}
	}
	else
	{
		drone thread drone_fire_squibs( index );
	}
}

drone_fire_squibs( index )
{
	level endon( "drone_stop_fire_" + index );
	
	
	while( 1 )
	{
		tag_origin = self GetTagOrigin( "tag_gear_nose" );
		
		fire_at_target = ( anglestoforward( self.angles + ( RandomIntRange( -45, 45 ), RandomIntRange( -45, 45 ) ,0 ) ) * 300 ) + ( 0, 0, -1000 );
		MagicBullet( "f35_side_minigun", tag_origin, tag_origin + fire_at_target );
		
		wait 0.1;
	}
}

delete_at_end_node()
{
	self endon("delete");
	
	self waittill( "reached_end_node" );
	self Delete();
}

wait_till_player_close_enough()
{
	while(  Distance2D( level.player.origin, self.origin ) > 100 )
	{
		wait 0.05;
	}
}

play_drone_swarm()
{
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_1", "targetname" ) );
	drone thread drone_swarm_fire_missile( 1 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_2", "targetname" ) );
	drone thread drone_swarm_fire_missile( 2 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_0" );
	drone thread go_path( GetVehicleNode( "drone_start_path_3", "targetname" ) );
	drone thread drone_swarm_fire_squibs( 3 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_4", "targetname" ) );
	drone thread drone_swarm_fire_missile( 4 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_5", "targetname" ) );
	drone thread drone_swarm_fire_missile( 5 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_0" );
	drone thread go_path( GetVehicleNode( "drone_start_path_6", "targetname" ) );
	drone thread drone_swarm_fire_squibs( 6 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_7", "targetname" ) );
	drone thread drone_swarm_fire_missile( 2 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_8", "targetname" ) );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_9", "targetname" ) );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_10", "targetname" ) );
	drone thread drone_swarm_fire_missile( 5 );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_11", "targetname" ) );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_1" );
	drone thread go_path( GetVehicleNode( "drone_start_path_12", "targetname" ) );
	drone thread delete_at_end_node();
	
	drone = spawn_vehicle_from_targetname( "drone_swarm_0" );
	drone thread go_path( GetVehicleNode( "drone_start_path_13", "targetname" ) );
	drone thread drone_swarm_fire_squibs( 3 );
	drone thread delete_at_end_node();

	level thread drone_earthquake();
	
	level waittill( "start_ambient" );
		
	level thread sky_cowbell();	
	level thread ambient_drone_manager();
	level thread run_missile_firing_drones_around_player();
}

drone_earthquake()
{
	level waittill( "drone_swarm_start_fire_2" );
	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	
	Earthquake( .2, 2, level.player.origin, 1000, level.player );
	wait 0.9;
	
	level.player PlayRumbleLoopOnEntity( "damage_heavy" );
	
	Earthquake( .3, 3, level.player.origin, 1000, level.player );
	wait 1.9;
		
	Earthquake( .4, 2.5, level.player.origin, 1000, level.player );
	wait 1.4;
	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	
	Earthquake( .3, 2, level.player.origin, 1000, level.player );
	
	wait 1.9;
	
	StopAllRumbles();
}

drone_swarm_fire_missile( index )
{
	level waittill( "drone_swarm_start_fire_" + index );
	
	tag_origin = self GetTagOrigin( "TAG_MISSILE_Right" );
		
	fire_at_target = ( anglestoforward( self.angles ) * 500 );
	MagicBullet( "f35_missile_turret", tag_origin + fire_at_target, tag_origin + ( fire_at_target * 10 ) );
}

drone_swarm_fire_squibs( index )
{
	level endon( "drone_swarm_stop_fire_" + index );
	
	level waittill( "drone_swarm_start_fire_" + index );
	
	while( 1 )
	{
		tag_origin = self GetTagOrigin( "tag_gear_nose" );
		
		fire_at_target = ( anglestoforward( self.angles + ( RandomIntRange( -45, 45 ), RandomIntRange( -45, 45 ) ,0 ) ) * 300 ) + ( 0, 0, -1000 );
		MagicBullet( "f35_side_minigun", tag_origin, tag_origin + fire_at_target );
		
		wait 0.1;
	}
}

sky_cowbell()
{
	level endon( "sky_cowbell_stop" );
	
	s_sky_cowbell = get_struct( "sky_cowbell", "targetname" );  // make sure everything exists in map
	
	if ( IsDefined( s_sky_cowbell ) )
	{
		// init
		level.sky_cowbell = SpawnStruct();
		sky_cowbell_set_max_drones();  // default = 20
		sky_cowbell_set_ratio();  // default = ratio = 2 avenger : 1 pegasus
		level.sky_cowbell.avenger_count = 0;
		level.sky_cowbell.pegasus_count = 0;
		level.sky_cowbell.drones = [];
		sp_avenger = get_vehicle_spawner( "avenger_ambient" );
		sp_pegasus = get_vehicle_spawner( "pegasus_ambient" );
		a_spawn_points = get_struct_array( "sky_cowbell_spawn_point", "targetname", true );
		a_flight_structs = get_struct_array( "sky_cowbell_flight_struct", "targetname", true );
		
		// add anything for the drones to fire at
		a_valid_targets = get_ent_array( "sky_cowbell_targets", "targetname", true );
		a_valid_targets = ArrayCombine( a_valid_targets, GetEntArray( "sky_cowbell_targets", "script_noteworthy" ),true,false );
		
		// add spawn functions for avenger
		add_spawn_function_veh( "avenger_ambient", ::sky_cowbell_drone_spawn_func, a_flight_structs );
		add_spawn_function_veh( "avenger_ambient", ::sky_cowbell_drone_tracker );
		add_spawn_function_veh( "avenger_ambient", ::sky_cowbell_firing_func, a_valid_targets );
		add_spawn_function_veh( "avenger_ambient", ::delete_corpse );
		
		// add spawn functions for pegasus
		add_spawn_function_veh( "pegasus_ambient", ::sky_cowbell_drone_spawn_func, a_flight_structs );
		add_spawn_function_veh( "pegasus_ambient", ::sky_cowbell_drone_tracker );
		add_spawn_function_veh( "pegasus_ambient", ::sky_cowbell_firing_func, a_valid_targets );		
		add_spawn_function_veh( "pegasus_ambient", ::delete_corpse );
			
		while ( true )
		{
			n_delay = 0.25;
			
			n_active = level.sky_cowbell.drones.size;
			n_active_max = level.sky_cowbell.max_count;
			
			// spawn drone if under max count
			if ( n_active < n_active_max )
			{
				// select drone type
				n_drones_total = level.sky_cowbell.max_count;
				n_avengers_ideal = Int( level.sky_cowbell.ratio_pegasus_percent * n_drones_total );
				n_avengers_active = level.sky_cowbell.avenger_count;
	
				b_should_spawn_avenger = ( n_avengers_active < n_avengers_ideal );
				
				if ( b_should_spawn_avenger )
				{
					sp_drone = sp_avenger;
					str_spawner = "avenger_ambient";
				}
				else 
				{
					sp_drone = sp_pegasus;
					str_spawner = "pegasus_ambient";
				}
				
				// move drone to a spawn point so audio doesn't cut out on warp when alive
				s_spawner_position = _get_random_element_player_cant_see( a_spawn_points );
				sp_drone.origin = s_spawner_position.origin;
				spawn_vehicle_from_targetname( str_spawner );
			}
			else 
			{
				n_delay = 3;  // don't recheck often if drone count is maxed out
			}
			
			wait n_delay;
		}
	}
}

_get_random_element_player_cant_see( a_elements )
{
	Assert( IsDefined( a_elements ), "a_elements is a required parameter for _get_random_element_player_cant_see" );
	Assert( ( a_elements.size > 0 ), "a_elements needs to contain at least one element in _get_random_element_player_cant_see" );
	
	b_found_element = false;
	e_player = level.player;
	const n_dot_range = 0.3;
	b_do_trace = false;
	
	while ( !b_found_element )
	{
		s_element = random( a_elements );
		
		if ( !IsDefined( s_element ) )
		{
			wait 0.1;
			continue;
		}
		
		b_can_player_see_point = e_player is_looking_at( s_element.origin, n_dot_range, b_do_trace );
		
		if ( !b_can_player_see_point )
		{
		    b_found_element = true;
		}
		    
		wait 0.1;
	}
	
	return s_element;
}

// function kills off sky cowbell
sky_cowbell_stop()
{
	level notify( "sky_cowbell_stop" );
}

sky_cowbell_drone_spawn_func( a_flight_structs )  // self = sky cowbell drone
{
	self endon( "death" );
	
	n_notify_dist = 1000;
	self SetNearGoalNotifyDist( n_notify_dist );
	
	while ( is_alive( self ) )
	{
		s_flight_goal = random( a_flight_structs );
		self SetVehGoalPos( s_flight_goal.origin, false );
		self waittill( "near_goal" );
	}
}

sky_cowbell_drone_tracker()  // self = drone
{
	if ( !IsDefined( level.sky_cowbell.drones ) )
	{
		level.sky_cowbell.drones = [];
	}
	
	ARRAY_ADD( level.sky_cowbell.drones, self );
	
	b_is_avenger = IsSubStr( self.vehicletype, "avenger" );
	
	// increment counts for easier tracking
	if ( b_is_avenger )
	{
		level.sky_cowbell.avenger_count++;
	}
	else 
	{
		level.sky_cowbell.pegasus_count++;
	}
	
	self waittill( "death" );
	
	ArrayRemoveValue( level.sky_cowbell.drones, undefined );
	
	// decrement counts
	if ( b_is_avenger )
	{
		level.sky_cowbell.avenger_count--;
	}
	else 
	{
		level.sky_cowbell.pegasus_count--;
	}	
}

sky_cowbell_firing_func( a_valid_targets )  // self = drone
{
	self endon( "death" );
	
	// declare indicies. Note these are the same for the Avenger and Pegasus drones
	const BULLET_TURRET_INDEX = 0;
	const MISSILE_TURRET_LEFT_INDEX = 1;
	const MISSILE_TURRET_RIGHT_INDEX = 2;
	
	// bullet turret burst parameters
	const n_fire_time_bullet_min = 1;
	const n_fire_time_bullet_max = 3;
	const n_fire_wait_bullet_min = 2;
	const n_fire_wait_bullet_max = 5;
	
	//  missile turret burst parameters
	const n_fire_time_missile_min = 0.5;
	const n_fire_time_missile_max = 1.5;
	const n_fire_wait_missile_min = 2;
	const n_fire_wait_missile_max = 6;

	// set burst parameters on all turrets	
	self maps\_turret::set_turret_burst_parameters( n_fire_time_bullet_min, n_fire_time_bullet_max, n_fire_wait_bullet_min, n_fire_wait_bullet_max, BULLET_TURRET_INDEX );
	self maps\_turret::set_turret_burst_parameters( n_fire_time_missile_min, n_fire_time_missile_max, n_fire_wait_missile_min, n_fire_wait_missile_max, MISSILE_TURRET_LEFT_INDEX );
	self maps\_turret::set_turret_burst_parameters( n_fire_time_missile_min, n_fire_time_missile_max, n_fire_wait_missile_min, n_fire_wait_missile_max, MISSILE_TURRET_RIGHT_INDEX );
	
	// set valid targets
	self maps\_turret::set_turret_target_ent_array( a_valid_targets, BULLET_TURRET_INDEX );
	self maps\_turret::set_turret_target_ent_array( a_valid_targets, MISSILE_TURRET_LEFT_INDEX );
	self maps\_turret::set_turret_target_ent_array( a_valid_targets, MISSILE_TURRET_RIGHT_INDEX );
	
	while ( is_alive( self ) )
	{
		b_use_guns = cointoss();
		n_fire_time = RandomFloatRange( 3, 5 );
		
		// pick target
		b_has_target = false;
		while ( !b_has_target )
		{
			e_target = random( a_valid_targets );
			b_has_target = self maps\_turret::can_turret_hit_target( e_target, b_use_guns );  // missile turrets should be able to hit the same targets
			wait 0.05;
		}
		
		if ( b_use_guns )
		{
			self maps\_turret::set_turret_target( e_target, ( 0, 0, 0 ), BULLET_TURRET_INDEX );
			self maps\_turret::fire_turret_for_time( n_fire_time, BULLET_TURRET_INDEX );
		}
		else // use missiles
		{
			self maps\_turret::set_turret_target( e_target, ( 0, 0, 0 ), MISSILE_TURRET_LEFT_INDEX );
			self maps\_turret::set_turret_target( e_target, ( 0, 0, 0 ), MISSILE_TURRET_RIGHT_INDEX );
			
			self thread maps\_turret::fire_turret_for_time( n_fire_time, MISSILE_TURRET_LEFT_INDEX );
			self maps\_turret::fire_turret_for_time( n_fire_time, MISSILE_TURRET_LEFT_INDEX );
		}
	}
}

sky_cowbell_set_max_drones( n_count )
{
	DEFAULT( level.sky_cowbell.max_count, 20 );

	if ( IsDefined( n_count ) )
	{
		level.sky_cowbell.max_count = n_count;
	}
}

// set ratio of sky cowbell drones in the air
sky_cowbell_set_ratio( n_ratio_avenger, n_ratio_pegasus )
{
	DEFAULT( level.sky_cowbell.ratio_avenger, 2 );
	DEFAULT( level.sky_cowbell.ratio_pegasus, 1 );
	
	if ( IsDefined( n_ratio_avenger ) )
	{
		level.sky_cowbell.ratio_avenger = n_ratio_avenger;
	}
	
	if ( IsDefined( n_ratio_pegasus ) )
	{
		level.sky_cowbell.ratio_pegasus = n_ratio_pegasus;
	}
	
	// set percentages for easier use later
	n_total = sky_cowbell_get_ratio_total();
	n_pegasus_count = level.sky_cowbell.ratio_pegasus;
	n_avenger_count = level.sky_cowbell.ratio_avenger;
	
	level.sky_cowbell.ratio_pegasus_percent = n_pegasus_count / n_total;
	level.sky_cowbell.ratio_avenger_percent = n_avenger_count / n_total;
}

// returns divisor for ratio determination
sky_cowbell_get_ratio_total()
{
	return ( level.sky_cowbell.ratio_avenger + level.sky_cowbell.ratio_pegasus );
}

brute_force()
{
	run_scene_first_frame( "brute_force_f38" );
	
	level waittill( "resume_speed" );
	
	level.player waittill_player_has_brute_force_perk();
	
	s_brute_force_pos = getstruct( "brute_force_debris_struct", "targetname" );
			
	set_objective( level.OBJ_INTERACT, s_brute_force_pos.origin, "interact" );
	
	level.player.targetname = "player";
	
	trigger = trigger_wait( "brute_force_debris_trigger" );
	trigger triggeroff();
	
	run_scene( "brute_force_move" );
	
	s_brute_force_pos = getstruct( "brute_force_obj_console_struct", "targetname" );
	set_objective( level.OBJ_INTERACT, s_brute_force_pos.origin, "interact" );
	
	trigger = trigger_wait( "brute_force_computer" );
	trigger triggeroff();
	
	axis_array = getaiarray("axis");
	foreach( axis in axis_array )
	{
		axis.overrideactordamage = ::brute_force_ai_damage_override;
	}
	
	run_scene( "brute_force_launch" );
	level thread run_scene( "brute_force_f38" );
	
	set_objective( level.OBJ_INTERACT, undefined, "done" );
}

brute_force_ai_damage_override( eInflictor, e_attacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( sMeansOfDeath == "MOD_EXPLOSIVE" && iDamage >= 1000 )
	{
		level.brute_force_ai_killed++;
	}
	
	return iDamage;
}

brute_force_explosions()
{
	explo_struct = getstruct( "brute_force_explo_1", "targetname" );
	MagicBullet( "f35_missile_turret", explo_struct.origin, explo_struct.origin - ( 0, 0, 10 ) );
	RadiusDamage( explo_struct.origin, 1500, 1000, 1000 );
	
	wait 0.5;
	
	explo_struct = getstruct( "brute_force_explo_2", "targetname" );
	MagicBullet( "f35_missile_turret", explo_struct.origin, explo_struct.origin - ( 0, 0, 10 ) );
	RadiusDamage( explo_struct.origin, 1500, 1000, 1000 );
	
	wait 0.5;
	
	explo_struct = getstruct( "brute_force_explo_3", "targetname" );
	MagicBullet( "f35_missile_turret", explo_struct.origin, explo_struct.origin - ( 0, 0, 10 ) );
	RadiusDamage( explo_struct.origin, 1500, 1000, 1000 );
	
	wait 0.5;
	
	explo_struct = getstruct( "brute_force_explo_4", "targetname" );
	MagicBullet( "f35_missile_turret", explo_struct.origin, explo_struct.origin - ( 0, 0, 10 ) );
	RadiusDamage( explo_struct.origin, 1500, 1000, 1000 );
}

drone_barrage()
{
	self endon( "death" );
	
	fire_at_array = GetEntArray( "drone_strike_at", "targetname" );
	
	index = RandomInt( fire_at_array.size );
	
	level waittill ( "drone_barrage" );
	
	rand_wait = RandomInt( 10 );
	
	wait ( rand_wait / 10 );
	
	missile_right = self GetTagOrigin( "TAG_MISSILE_Right" );
	missile_left = self GetTagOrigin( "TAG_MISSILE_Left" );
	
	MagicBullet( "f35_missile_turret", missile_right, fire_at_array[ index ].origin );
	MagicBullet( "f35_missile_turret", missile_left, fire_at_array[ index ].origin );
}

set_goal_volume_sm( n_spawner )
{
	volume = GetEnt( "sm" + n_spawner + "_goal_volume", "targetname" );
	self SetGoalVolumeAuto( volume );
}

ignore_player()
{
	self SetThreatBiasGroup( "ambient_axis_ai" );
}

ignore_main_ai()
{
	self SetThreatBiasGroup( "ambient_ally_ai" );
}

setup_threat_bias_group()
{
	disable_auto_adjust_threatbias();
		
	level.player SetThreatBiasGroup( "player_and_team" );
	
	if( IsDefined( level.harper ) )
	{
		level.harper SetThreatBiasGroup( "player_and_team" );
	}
	
	SetThreatBias( "player_and_team", "ambient_axis_ai", -1000 );
	SetThreatBias( "ambient_axis_ai", "player_and_team", -1000 );
	SetThreatBias( "ambient_ally_ai", "ambient_axis_ai", 1000 );
	SetThreatBias( "ambient_axis_ai", "ambient_ally_ai", 1000 );
}

kill_ignored_ai()
{
	self endon( "death" );
	self endon( "deleted" );
	
	trigger_wait( "kill_past_ai" );
	
	if( IsDefined( self.magic_bullet_shield ) && is_true( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}
	
	self bloody_death();
}

kill_ignored_ai_final()
{
	self endon( "death" );
	self endon( "deleted" );
	
	level waittill( "anderson_start_firing" );
	
	if( IsDefined( self.magic_bullet_shield ) && is_true( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}
	
	self bloody_death();
}

kill_ignored_ai_final_2()
{
	self endon( "death" );
	self endon( "deleted" );
	
	level waittill( "anderson_stop_firing" );
	
	wait 0.3;
	
	if( IsDefined( self.magic_bullet_shield ) && is_true( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}
	
	self bloody_death();
}

randomly_destroy_drone()
{
	while( 1 )
	{
		if( RandomInt( 4 ) == 0 )
		{
			a_drone_vehicles = GetEntArray( "drone_turret_targets", "script_noteworthy" );
			
			if( a_drone_vehicles.size > 0 )
			{
				index = RandomInt( a_drone_vehicles.size );
			
				RadiusDamage( a_drone_vehicles[ index ].origin, 1028, a_drone_vehicles[ index ].health * 2, a_drone_vehicles[ index ].health * 2 );
			}
		}
		
		wait 5;
	}
}

delete_corpse()
{
	self endon( "delete" );
	
	self waittill( "death" );
	
	while( self.origin[2] < -1028 )
	{
		wait 0.5;
	}
	
	self Delete();
}

run_missile_firing_drones_around_player()
{
	while( 1 )
	{
		level thread fire_missile_from_behind_the_player();
		wait RandomIntRange( 3, 6 );
	}	
}

fire_missile_from_behind_the_player()
{
	n_spawn_yaw = AbsAngleClamp360( level.player.angles[ 1 ] + RandomIntRange( 90, 270 ) );
	v_missile_spawn_org = level.player.origin + ( AnglesToForward( ( 0, n_spawn_yaw, 0 ) ) * 3000 );
	v_missile_spawn_org = ( v_missile_spawn_org[0], v_missile_spawn_org[1], RandomIntRange( 2000, 3000 ) );
	s_fire_missile_target = find_missile_fire_at_target_the_player_is_looking_at();
	
	MagicBullet( "f35_missile_turret", v_missile_spawn_org, s_fire_missile_target.origin );
}

find_missile_fire_at_target_the_player_is_looking_at( )
{
	a_elements = getstructarray( "drone_fire_missles_target", "targetname" );
	
	b_found_element = false;
	e_player = level.player;
	const n_dot_range = 0.3;
	b_do_trace = false;
	
	while ( !b_found_element )
	{
		s_element = random( a_elements );
		
		if ( !IsDefined( s_element ) )
		{
			wait 0.1;
			continue;
		}
		
		b_can_player_see_point = e_player is_looking_at( s_element.origin, n_dot_range, b_do_trace );
		
		if( Distance( e_player.origin, s_element.origin ) < 1500)
		{
			wait 0.1;
			continue;	
		}
		
		if ( b_can_player_see_point )
		{
		    b_found_element = true;
		}
		    
		wait 0.1;
	}
	
	return s_element;
}