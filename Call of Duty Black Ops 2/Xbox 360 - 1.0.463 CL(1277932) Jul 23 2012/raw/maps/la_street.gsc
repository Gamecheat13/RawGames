#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_music;
#include maps\_objectives;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\la_utility;
#include animscripts\anims;
#include animscripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_street()
{
	if ( !flag( "harper_dead" ) )
	{
		init_hero( "harper" );
	}
	skipto_teleport( "skipto_street" );
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	level.player.overridePlayerDamage = ::drone_player_damage_override;
}

main()
{	
	load_gump( "la_1b_gump_1" );
	
	//simple_spawn_single( "bdog_eval" );
	
	if ( !flag( "harper_dead" ) )
	{
		init_hero( "harper" );
		level.harper.disable_blindfire = true;
		level.harper thread street_harper_logic();
	}
	
	level.player.overridePlayerDamage = ::drone_player_damage_override;
	
	set_objective( level.OBJ_DRIVE, undefined, "done" );

//	level thread spawn_ambient_drones( "trig_street_flyby_1", "trig_street_flyby_4", "avenger_street_flyby_1", "f38_street_flyby_1", "start_street_flyby_1", 4, 1, 10, 11, 500, 3 );
	level thread spawn_ambient_drones( "trig_street_flyby_1", undefined, "avenger_street_flyby_2", "f38_street_flyby_2", "start_street_flyby_2", 4, 1, 5, 6, 500, 2 );	
	level thread spawn_ambient_drones( "trig_street_flyby_1", "trig_street_flyby_4", "avenger_street_flyby_3", "f38_street_flyby_3", "start_street_flyby_3", 4, 1, 8, 9, 500 );		
	level thread spawn_ambient_drones( "trig_street_flyby_4", undefined, "avenger_street_flyby_4", "f38_street_flyby_4", "start_street_flyby_4", 4, 1, 8, 10, 500 );			
	
	level thread brute_force();
	level thread street_objectives();
	level thread street_ais();
	level thread street_vo();
	level thread street_elec_on_ground();
	level thread fxanim_debris();
	
	run_scene_first_frame( "street_bodies" );
	level thread street_deathposes();
	
	level.supportsPistolAnimations = true;
	
	add_spawn_function_veh( "street_truck", ::street_veh_unload );
	
	level thread setup_street_middle();
	level thread street_fire_hydrant();

	level thread cougar_exit();
	
	level thread street_run_ahead_check();
	level thread player_out_of_bound();
	
	clear_the_street();
	
//	level thread press_demo_quadrotors();
}


street_deathposes()
{
	run_scene_first_frame( "streetbody_01" );
	run_scene_first_frame( "streetbody_02" );
	run_scene_first_frame( "streetbody_06" );
	run_scene_first_frame( "streetbody_08" );
	run_scene_first_frame( "streetbody_14" );
}


brute_force()
{	
	level thread brute_force_use();
	
	level.player waittill_player_has_brute_force_perk();
		
	//level thread brute_force_obj();
	level thread brute_force_fail();
}

street_objectives()
{
	scene_wait( "cougar_exit_player" );
	
	wait 2.0;
	
	// follow harper until the bdog spawns.
	if ( !flag( "harper_dead" ) )
	{
		set_objective( level.OBJ_FOLLOW, level.harper, "follow" );
	}
	else
	{
		// TODO: find a new objective if harper is dead	
	}
	flag_wait( "bdog_front_spawned" );
	
	// switch to the bdog target.
	set_objective( level.OBJ_FOLLOW, undefined, "remove" );
	assert( IsDefined( level.street_bdog_front ) );
	set_objective( level.OBJ_BIG_DOGS, undefined, undefined, level.n_bdogs_killed );
	
	// add the first dog.
	set_objective( level.OBJ_BIG_DOGS, level.street_bdog_front, "destroy", -1 );
	
	flag_wait( "bdog_back_spawned" );
	
	// wait a little so the objective doesn't pop on before the truck has opened its back gate.
	wait 5.0;
	
	// add the second dog.
	set_objective( level.OBJ_BIG_DOGS, level.street_bdog_back, "destroy", -1 );
	
	level waittill( "street_bdogs_killed" );
	
	
	level thread maps\la_1b_amb::la_drone_control_tones( true );
	
//	quadrotor_trigger = GetEnt( "press_demo_quadrotors", "targetname" );
//	if( isdefined( quadrotor_trigger ) )//Make sure this hasn't been triggered yet
//	{
//		quadrotor_trigger UseBy( level.player );
//	}
		
	set_objective( level.OBJ_BIG_DOGS, undefined, "done" );
	set_objective( level.OBJ_BIG_DOGS, undefined, "delete" );
	
	set_objective( level.OBJ_STREET_REGROUP );
	set_objective( level.OBJ_STREET );
	
	//set_objective( level.OBJ_STREET, undefined, "done" );
	set_objective( level.OBJ_STREET, undefined, "delete" );
	
	//trigger_use( "obj_plaza_start" );
}

/* ------------------------------------------------------------------------------------------
AI RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == harper
street_harper_logic()
{	
	trigger_wait( "color_street_start_out" );
	
	level notify( "street_battle_started" );
	
	self.fixedNode = false;
	self.goalradius = 128;
	
	level.n_bdogs_killed = 0;
	
	waittill_ai_group_amount_killed( "street_bdog", 1 );
	
	level thread autosave_by_name( "street_1_bdog_killed" );
	level notify( "street_1_bdog_killed" );
	level notify( "stop_street_anim_entries" );
		
	flag_clear( "police_in_hotel" );
	
	waittill_ai_group_amount_killed( "street_bdog", 2 );
	level thread autosave_by_name( "street_2_bdogs_killed" );
	
	level notify( "street_bdogs_killed" );
	trigger_use( "kill_bdog_2_move" );
	
	level thread street_kill_extra_enemies();
	
	self.perfectaim = 1;
	
	self street_harper_finish();
	
	self.goalradius = 64;
	self.fixedNode = true;
	self enable_ai_color();
	
	self.perfectaim = 0;
	
	wait_network_frame();
	
	trigger_use( "plaza_color_start" );
}

// self == harper
street_harper_finish()
{
	level thread street_move_remaining_ais();
	
	a_street_ais = GetAIArray( "axis" );
	
	if ( a_street_ais.size > 6 )
	{
		queue_dialog_enemy( "pmc0_they_re_in_the_killz_0" );
	}
	
	// wait until there is no more enemy to kill
	while ( a_street_ais.size > 0 )
	{
		a_street_ais = GetAIArray( "axis" );
		
		// if the player's way ahead and both bdogs are dead, go ahead and catch up immediately.
		if ( flag( "fl_player_entered_plaza" ) && ai_group_get_num_killed( "street_bdog" ) >= 2 )
		{
			break;
		}
		
		wait 0.05;
	}
	
	level notify( "street_cleared" );
}

// self == enemy that harper was targeting
waittill_health_zero_or_below()
{
	while ( IsAlive( self ) )
	{
		wait 0.05;
	}
	
	level.harper stop_shoot_at_target();
}

street_move_remaining_ais()
{
	e_street_volume = GetEnt( "street_volume", "targetname" );
	a_street_ais = GetAIArray( "axis" );
	
	foreach ( ai_street in a_street_ais )
	{
		if ( ai_street.weapon != "dsr50_sp" && !ai_street is_rusher() )
		{
			ai_street SetGoalVolumeAuto( e_street_volume );
		}
	}
}

// help kill off remaining enemies after the two CLAWs are dead at the street
street_kill_extra_enemies()
{
	ai_stair_sniper = GetEnt( "street_sniper_stair_ai", "targetname" );
	if ( IsAlive( ai_stair_sniper ) )
	{
		ai_stair_sniper bloody_death();
	}
	
	a_generic_ai = GetEntArray( "street_generic_ai", "targetname" );
	foreach ( ai_generic in a_generic_ai )
	{
		if ( IsAlive( ai_generic ) )
		{
			ai_generic bloody_death();
		}
	}
	
	a_enemy_ais = GetAIArray( "axis" );
	while ( a_enemy_ais.size > 6 )
	{
		wait 0.05;
	}
	
	level notify( "end_enemy_street_vo" );
}

street_ais()
{	
	level thread enemy_on_top_of_metro();
	level thread street_ai_begin();
	level thread street_ai_spawn_funcs();
	level thread street_rushers();
	level thread street_train_surprise();
	level thread street_snipers();
	level thread street_anim_entries();
	level thread street_bdogs();
}

street_ai_begin()
{
	trigger_wait( "color_street_start_out" );
	
	trigger_use( "sm_street_cross_1" );
	
	ai_sniper_stair = simple_spawn_single( "street_sniper_stair" );
	ai_sniper_stair force_goal( undefined, 16, false );
	
	ai_cross_0 = simple_spawn_single( "street_cross_0" );
	ai_cross_0 force_goal( undefined, 16 );
	
	ai_dive = simple_spawn_single( "street_dive" );
	ai_dive force_goal( undefined, 16, false );
}

street_bdogs()
{	
	sp_street_bdog_front = GetEnt( "bdog_front", "targetname" );
	sp_street_bdog_front add_spawn_function( ::street_claw, ::street_claw_front );
	
	sp_street_bdog_back = GetEnt( "bdog_back", "targetname" );
	sp_street_bdog_back add_spawn_function( ::street_claw, ::street_claw_back );	
}

// self == bdog
street_claw( func_logic )
{
	wait_network_frame(); // needs to wait a frame before the below info can be set properly
	
	self change_movemode( "sprint" );
	
	self thread street_claw_vo_grenade();
	
	nd_street_middle = GetNode( "street_middle", "targetname" );
	self SetGoalPos( nd_street_middle.origin );
	
	self SetEngagementMinDist( 250, 50 );
	//self thread street_claw_vo_immobilized();
	
	self thread [[ func_logic ]]();
		
	self waittill( "death" );
	
	level.n_bdogs_killed++;
	set_objective( level.OBJ_BIG_DOGS, self, "remove" );
	set_objective( level.OBJ_BIG_DOGS, undefined, undefined, level.n_bdogs_killed );
}

// self == bdog
street_claw_front()
{
	self endon( "death" );
	
	self thread set_flag_on_notify( "wounded", "bdog_front_wounded" );
	self thread set_flag_on_notify( "immobilized", "bdog_front_immobilized" );
	self thread set_flag_on_notify( "death", "bdog_front_dead" );
		
	level thread street_claw_front_vo();
	self thread claw_death_music_watcher();
	
	level.street_bdog_front = self;
	flag_set( "bdog_front_spawned" );
		
	e_bdog_back_volume = GetEnt( "bdog_front_cover_back_vol", "targetname" );
	e_bdog_front_volume = GetEnt( "bdog_cover_front_volume", "targetname" );
	t_cover_front = GetEnt( "bdog_cover_front", "targetname" );
	b_protect_back = true;
	
	while ( true )
	{
		if ( !b_protect_back ) // Protect the back if the player is at a certain area
		{
			if ( !( level.player IsTouching( t_cover_front ) ) )
			{
				self SetGoalVolumeAuto( e_bdog_back_volume );
				b_protect_back = true;
				
				self move_to_goal_or_till_timeout( 3 );
			}
		}
		else // Protect the front if the player is at a certain area
		{
			if ( level.player IsTouching( t_cover_front ) ) 
			{
				self SetGoalVolumeAuto( e_bdog_front_volume );
				b_protect_back = false;
				
				self move_to_goal_or_till_timeout( 2 );
			}
		}
		
		wait 0.05;
	}
}

claw_death_music_watcher()
{
	self waittill ("death");
	//Play the CLAW music --MUST CHANGE LATER 
	setmusicstate ("LA_1B_STREET_CLAW_DEAD");	
}

street_claw_front_vo()
{
	if ( !flag( "harper_dead" ) )
	{
		level.harper priority_dialog( "harp_finish_it_0", 0, "bdog_front_immobilized", "bdog_front_dead" );
		level.harper priority_dialog( "harp_another_explosive_ro_0", 0, "bdog_front_immobilized", "bdog_front_dead" );
		
		level.player priority_dialog( "fuck_you_042", 1, "bdog_front_dead" );
	}
}

// self == bdog
street_claw_back( takes_in_route )
{
	self endon( "death" );
	
	self thread set_flag_on_notify( "wounded", "bdog_back_wounded" );
	self thread set_flag_on_notify( "immobilized", "bdog_back_immobilized" );
	self thread set_flag_on_notify( "death", "bdog_back_dead" );
	
	level thread street_claw_back_vo();
	
	level.street_bdog_back = self;
	flag_set( "bdog_back_spawned" );
	
	e_bdog_back_volume = GetEnt( "bdog_back_cover_back_vol", "targetname" );
	e_bdog_in_volume = GetEnt( "bdog_cover_in_volume", "targetname" );
	t_cover_in = GetEnt( "bdog_cover_in", "targetname" );
	b_protect_back = true;
	
	while ( true )
	{
		if ( !b_protect_back ) // Protect the back if the player is at a certain area
		{
			if ( !( level.player IsTouching( t_cover_in ) ) )
			{
				self SetGoalVolumeAuto( e_bdog_back_volume );
				b_protect_back = true;
				
				self move_to_goal_or_till_timeout( 3 );
			}
		}
		else // Protect inside the hotel if the player is at a certain area
		{
			if ( level.player IsTouching( t_cover_in ) ) 
			{
				self SetGoalVolumeAuto( e_bdog_in_volume );
				b_protect_back = false;
				
				self move_to_goal_or_till_timeout( 2 );
			}
		}
		
		wait 0.05;
	}
}

street_claw_back_vo()
{
	if ( !flag( "harper_dead" ) )
	{
		level.harper priority_dialog( "harp_stay_on_him_section_0", 1, "bdog_back_wounded", array( "bdog_back_immobilized", "bdog_back_dead" ) );
		level.player priority_dialog( "these_bastards_are_018", 1, "bdog_back_wounded", array( "bdog_back_immobilized", "bdog_back_dead" ) );
		
		level.harper priority_dialog( "its_damaged_h_fin_020", 1, "bdog_back_immobilized", "bdog_back_dead" );
		level.player priority_dialog( "go_down_dammit_021", 0, "bdog_back_immobilized", "bdog_back_dead" );
		
		level.player priority_dialog( "fuck_yeah_022", 1, "bdog_back_dead" );
		level.player priority_dialog( "nice_work_023", 0, "bdog_back_dead" );
	}
}

// self == bdog
move_to_goal_or_till_timeout( n_seconds_till_timeout )
{
	self endon( "death" );
	
	self change_movemode( "sprint" );
	self.goalradius = 16;
				
	self waittill_notify_or_timeout( "goal", 3 );
				
	self.goalradius = 2048;
	self reset_movemode();
}

// self == bdog that covers the front
street_second_wave_move()
{
	level endon( "street_bdogs_killed" );
	
	self waittill( "death" );
	
	if ( !flag( "harper_dead" ) && get_ai_group_count( "street_bdog" ) > 0 )
	{
		level.harper.goalradius = 64;
		level.harper.fixedNode = true;
	}
	
	trigger_use( "sm_street_train_inside" );
	trigger_use( "sm_street_back" );
	trigger_use( "s_bdog_1_clear_move" );
	
	trigger_off( "bdog_cover_front", "targetname" );
	
	while ( GetAIArray( "axis" ).size > 3 )
	{
		wait 0.05;
	}
	
	if ( !flag ( "harper_dead" ) )
	{
		level.harper.goalradius = 128;
		level.harper.fixedNode = false;
	}
	
	level.cop_2.fixedNode = false;
	level.cop_2.goalradius = 128;
	
	wait_network_frame();
	
	trigger_use( "kill_bdog_2_move" );
}

street_snipers()
{	
	trigger_wait( "sm_street_back" );
	
	ai_sniper = simple_spawn_single( "street_snipers" );
	ai_sniper endon( "death" );
	
	//waittill_vo_done();
	level.cop_1 notify( "kill_pending_dialog" );
	
	level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	
	wait 36;
	
	//waittill_vo_done();
	level.cop_1 notify( "kill_pending_dialog" );
	
	level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
}

street_train_surprise()
{
	t_sm_street_back = GetEnt( "sm_street_back", "targetname" );
	t_sm_street_back endon( "trigger" );
	
	trigger_wait( "trig_street_train_surprise" );
	
	run_scene( "train_surprise_attack" );
}

street_anim_entries()
{
	add_spawn_function_group( "guy_pipe_1", "targetname", ::set_force_ragdoll );
	add_spawn_function_group( "guy_ladder_2", "targetname", ::set_force_ragdoll );
	
	level endon( "stop_street_anim_entries" );
	
	trigger_wait( "color_street_start_out" );
	
	level thread street_hotdog_cart();
	
	level thread run_scene( "pipe_entry_1" );
	level thread run_scene( "ladder_entry_2" );
	wait 0.05;
	//ai_ladder_entry = get_ais_from_scene( "ladder_entry_2" );
	//ai_ladder_entry[0].a.nodeath = true;//We want the ladder guy to go directly into ragdoll on death
	
	scene_wait( "ladder_entry_2" );
	
	sp_generic = GetEnt( "street_generic", "targetname" );
	a_str_scenes = array( "ladder_entry_1", "pipe_entry_2" );
	
	// spawn an enemy for the pipe or ladder slide
	while ( sp_generic.count > 0 )
	{
		n_rand_wait = RandomIntRange( 1, 3 );
		wait n_rand_wait;
		
		str_scene = random( a_str_scenes );
		ai_generic = simple_spawn_single( "street_generic", ::set_force_ragdoll );
		
		ai_generic endon( "death" );
		
		add_generic_ai_to_scene( ai_generic, str_scene );
		
		//waittill_vo_done();
		
		flag_set( "someone_near_hotel" );
		
		if ( RandomInt( 2 ) == 0 )
		{
			ai_generic thread queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
		
		run_scene( str_scene );
		
		flag_clear( "someone_near_hotel" );
		
		if ( IsAlive( ai_generic ) )
		{
			ai_generic force_goal( undefined, 16 );
		}
	}
}

set_force_ragdoll()
{
	self.a.deathForceRagdoll = true;
}

street_hotdog_cart()
{
	m_cart = GetEnt( "hot_dog_cart_push", "script_noteworthy" );
	m_cart_dyn_path = GetEnt( "cart_dynamic_path", "targetname" );
	m_cart_dyn_path LinkTo( m_cart );
	m_cart thread street_cart_listener();
	
	level thread run_scene( "cart_push" );
	flag_wait( "cart_push_started" );
	
	m_cart_dyn_path ConnectPaths();
	
	ai_cart_1 = GetEnt( "guy_push_cart_1_ai", "targetname" );
	ai_cart_1 thread street_cart_vo();
	ai_cart_1 waittill( "death" );
	
	level notify( "street_cart_guy_died" );
	end_scene( "cart_push" );
	m_cart_dyn_path DisconnectPaths();
	
	ai_cart_2 = GetEnt( "guy_push_cart_2_ai", "targetname" );
	if ( IsAlive( ai_cart_2 ) )
	{
		ai_cart_2 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

// self == cart
street_cart_listener()
{
	level endon( "street_cart_guy_died" );
	
	scene_wait( "cart_push" );
	
	m_cart_dyn_path = GetEnt( "cart_dynamic_path", "targetname" );
	m_cart_dyn_path DisconnectPaths();
}

street_cart_vo()
{
	self endon( "death" );
	
	level waittill( "street_battle_start_vo_done" );
	
	level.cop_2 queue_dialog( "pmc0_they_re_in_the_killz_0" );
}

street_ai_spawn_funcs()
{
	a_street_ambush_outside = GetEntArray( "street_ambush_outside", "targetname" );	
	array_thread( a_street_ambush_outside, ::add_spawn_function, ::steet_ambush_outside_spawn_func );
	
	a_street_truck_guys = GetEntArray( "street_truck_guy", "targetname" );	
	array_thread( a_street_truck_guys, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_street_cross_1 = GetEntArray( "sm_street_cross_1", "targetname" );	
	array_thread( a_street_cross_1, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_street_inside = GetEntArray( "street_inside", "targetname" );	
	array_thread( a_street_inside, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_street_back = GetEntArray( "street_back", "targetname" );	
	array_thread( a_street_back, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_street_train_inside = GetEntArray( "street_train_inside", "targetname" );
	array_thread( a_street_train_inside, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_street_cross_inside = GetEntArray( "street_cross_inside", "targetname" );
	array_thread( a_street_cross_inside, ::add_spawn_function, ::force_goal, undefined, 16, false );
	
	trigger_use( "sm_street_ambush_outside" );
}

// self == one of the two enemies that is closet to you at the start of the battle
steet_ambush_outside_spawn_func()
{
	self endon( "death" );
	
	self force_goal( undefined, 16, true );
	n_old_goalradius = self.goalradius;
	e_cougar_window = GetEnt( "target_window", "targetname" );
	
	wait 0.05;
	
	self.perfectaim = 1;
	self.goalradius = 16;
	self thread shoot_at_target( e_cougar_window, undefined, undefined, -1 );
	
	level waittill( "street_battle_started" );
	
	self.goalradius = n_old_goalradius;
	self.perfectaim = 0;
	self stop_shoot_at_target();
}

street_rushers()
{
	level endon( "street_cleared" );
	
	level waittill( "street_battle_started" );
	
	v_player_origin_prev = level.player.origin;
	
	// decide if a rusher should attack the player
	while ( true )
	{
		wait 6;
		
		v_player_origin_cur = level.player.origin;
		v_player_prev_min_x = v_player_origin_prev + (-64, 0, 0);
		v_player_prev_max_x = v_player_origin_prev + (64, 0, 0);
		v_player_prev_min_y = v_player_origin_prev + (0, -64, 0);
		v_player_prev_max_y = v_player_origin_prev + (0, 64, 0);
		v_player_prev_min_z = v_player_origin_prev + (0, 0, -64);
		v_player_prev_max_z = v_player_origin_prev + (0, 0, 64);
		
		// rush the player if the player has stayed in a certain spot for a number of seconds
		if ( (v_player_origin_cur[0] > v_player_prev_min_x[0]) && (v_player_origin_cur[0] < v_player_prev_max_x[0])
		 &&  (v_player_origin_cur[1] > v_player_prev_min_y[1]) && (v_player_origin_cur[1] < v_player_prev_max_y[1])
		 &&  (v_player_origin_cur[2] > v_player_prev_min_z[2]) && (v_player_origin_cur[2] < v_player_prev_max_z[2]) )
		{
			ai_rusher = find_street_rusher();
					
			if ( IsDefined( ai_rusher ) )
			{
				ai_rusher hunt_down_player();
			}
		}
		
		v_player_origin_prev = v_player_origin_cur;
	}
}

find_street_rusher()
{
	ai_rusher = undefined;
	a_rushers = [];
	a_enemy_ais = GetAIArray( "axis" );
	
	// grab all the possible rushers ( any enemies holding a SMG or duel pistoling )
	foreach ( ai_enemy in a_enemy_ais )
	{
		if ( WeaponClass( ai_enemy.weapon ) == "smg" || WeaponClass( ai_enemy.weapon ) == "pistol" )
		{
			a_rushers[ a_rushers.size ] = ai_enemy;
		}
	}
	
	if ( a_rushers.size > 0 )
	{
		n_dist_sq_shortest = DistanceSquared( level.player.origin, a_rushers[0].origin );
		ai_rusher = a_rushers[0];
		const n_estimate_metro_height = 100;
		
		foreach ( ai_potential_rusher in a_rushers )
		{	
			// make sure this enemy is on the ground and not on the metro or fire escape
			if ( ai_potential_rusher.origin[2] < n_estimate_metro_height )
			{
				n_dist_sq_between = DistanceSquared( level.player.origin, ai_potential_rusher.origin );
				
				// find the closest enemy to the player
				if ( n_dist_sq_between < n_dist_sq_shortest )
				{
					n_dist_sq_shortest = n_dist_sq_between;
					ai_rusher = ai_potential_rusher;
				}
			}
		}
	}
	
	return ai_rusher;
}

// self == rusher
hunt_down_player()
{	
	self maps\_rusher::rush();
	
	self thread rush_vo();
	
	self waittill( "death" );
}

enemy_on_top_of_metro()
{
	level endon( "street_bdogs_killed" );
	
	trigger_wait( "color_street_start_out" );
	
	ai_climber = simple_spawn_single( "street_traverse_first" );
	ai_climber first_metro_climber();
	
	// find a new enemy to get on the metro once one of them dies
	while ( true )
	{
		ai_climber = find_metro_climber();
		
		if ( IsDefined( ai_climber ) )
		{
			ai_climber move_on_top_of_metro();
		}
		
		wait 0.05;
	}
}

// self == the first enemy that gets on the metro
first_metro_climber()
{
	self endon( "death" );
	
	wait 0.05;
	
	n_old_goalradius = self.goalradius;
	self.goalradius = 128;
	
	self waittill( "goal" );
	
	wait 6;
	
	nd_metro_finish = GetNode( "metro_finish", "targetname" );
	self SetGoalNode( nd_metro_finish );
	
	self waittill( "goal" );
	
	self.goalradius = n_old_goalradius;
}

find_metro_climber()
{
	ai_climber = undefined;
	a_enemy_ais = GetAIArray( "axis" );
	
	// set any enemy that should not climb the metro to undefined
	foreach ( n_key, ai_enemy in a_enemy_ais )
	{
		if ( IsDefined( ai_enemy.aigroup ) && ai_enemy.aigroup == "street_bdog" )
		{
			a_enemy_ais[ n_key ] = undefined;
		}
		else if ( ai_enemy is_rusher() )
		{
			a_enemy_ais[ n_key ] = undefined;
		}
		else if ( ai_enemy.weapon == "dsr50_sp" )
		{
			a_enemy_ais[ n_key ] = undefined;
		}
	}
	
	ArrayRemoveValue( a_enemy_ais, undefined );
	
	if ( a_enemy_ais.size > 0 )
	{
		n_dist_sq_longest = DistanceSquared( level.player.origin, a_enemy_ais[0].origin );
		ai_climber = a_enemy_ais[0];
		const n_estimate_metro_height = 100;
		
		foreach ( ai_potential_climber in a_enemy_ais )
		{
			// make sure this enemy is on the ground and not on the metro or fire escape
			if ( ai_potential_climber.origin[2] < n_estimate_metro_height )
			{
				n_dist_sq_between = DistanceSquared( level.player.origin, ai_potential_climber.origin );
				
				// find the furthest enemy to the player
				if ( n_dist_sq_between > n_dist_sq_longest )
				{
					n_dist_sq_longest = n_dist_sq_between;
					ai_climber = ai_potential_climber;
				}
			}
		}
	}
	
	return ai_climber;
}

// self == enemy on top of the metro
move_on_top_of_metro()
{
	self endon( "death" );
	
	n_old_goalradius = self.goalradius;
	self.goalradius = 128;
	
	const n_highest_nd_index = 3;
	n_random = RandomInt( 2 );
	
	// if the random node number is lower than highest node index on the metro, then run this loop
	while ( n_random < n_highest_nd_index )
	{
		nd_metro_top = GetNode( "metro_top_" + n_random, "targetname" );
		self SetGoalNode( nd_metro_top );
		
		self waittill( "goal" );
		
		self thread metro_vo();
		
		wait 6;
		
		// randomly pick the next node in the path that is on top of the metro
		n_random = RandomIntRange( n_random + 1, 4 );
	}
	
	nd_metro_finish = GetNode( "metro_finish", "targetname" );
	self SetGoalNode( nd_metro_finish );
	
	self waittill( "goal" );
	
	self.goalradius = n_old_goalradius;
}

/* ------------------------------------------------------------------------------------------
COUGAR EXIT ANIM RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/
cougar_exit()
{	
	screen_fade_out( 0 );
	
	//TUEY - moved this from the other function to fix an issue where sounds pop in on load.
	level thread street_shellshock_and_visionset();
	
	setmusicstate ("LA_1B_INTRO");
	
	//Setting this music state so we can blend a non loop with a looping piece of music.
	level thread maps\_audio::switch_music_wait("LA_1B_INTRO_B", 22);
	
	//Eckert Setting intro snap in amb csc main func
	//ClientNotify ("int_st");
	
	//force reverb.
	level notify ("force_verb");
	
	waittill_textures_loaded();
	
	// disable 'get to cover' message
	level.enable_cover_warning = false;
	
//	level.player waittill( "weapon_change" );
//	str_weapon_model = GetWeaponModel( level.player GetCurrentWeapon() );
	
	run_scene_first_frame( "cougar_exit_player" );
	
	level thread do_pip1();
	
	wait 6;
	
	level thread cougar_exit_player();
	level thread cougar_exit_cop_car();
	cougar_exit_everything_else();
	
	level thread autosave_by_name( "street_start" );
	
	// enable 'get to cover' message
	level.enable_cover_warning = true;
}

do_pip1()
{
	flag_set( "pip_playing" );
	
	thread maps\_glasses::play_bink_on_hud( "la_pip_seq_1", !BINK_IS_LOOPING, !BINK_IN_MEMORY );//Streamed bink
	flag_wait( "glasses_bink_playing" );
	
	level.player priority_dialog( "samu_g_units_blue_route_0" );	// Sam
	level.player priority_dialog( "samu_all_convoys_need_to_0" );	// Sam
	//level.player priority_dialog( "pres_what_about_you_agen_0" );	// President
	level.player priority_dialog( "sect_we_ll_find_a_way_thr_0" );	// Section
	
	flag_clear( "pip_playing" );
}

cougar_exit_player()
{	
	level notify ("radio_start_wakeup");
	level.player PlaySound("evt_cougar_exit");
	
	level thread run_scene( "cougar_exit_player" );
	flag_wait( "cougar_exit_player_started" );
	
	m_18_wheeler_clip = GetEnt( "street_truck_collision", "targetname" );
	m_18_wheeler_clip ConnectPaths();
	m_18_wheeler_clip NotSolid();
	
	level thread maps\la_1b_amb::force_snapshot_wait();

	wait 16;
	
	//TUEY - moved sound to Anim.		
//	playsoundatposition ("evt_la_1_convoy_escort_driveby", (0,0,0));
	wait(18.4);

	//TUEY - adjusting this so that the music doesn't trigger until the semi shows up.
	//setmusicstate ("LA_1B_STREET_NO_MUSIC");
}

cougar_exit_cop_car()
{
	level thread street_spawn_scripted_cop_car();
	
	m_ce_cop_car = GetEnt( "ce_cop_car", "script_noteworthy" );
	m_ce_cop_car thread police_car();
	
	level thread run_scene( "cougar_exit_cop_car" );
	
	level waittill ( "cop_car_skid_done" );
	wait 3;
	
	m_ce_cop_car play_fx( "ce_dest_cop_car_fx", m_ce_cop_car.origin, m_ce_cop_car.angles, 4.5, true, "body_animate_jnt" );
	
	run_scene( "ce_fxanim_cop_car" );
	
	level thread run_scene( "ce_fxanim_cop_car_explode" );
	m_ce_cop_car SetModel( "veh_t6_police_car_destroyed" );
	PlayFXOnTag( getfx( "car_explosion" ), m_ce_cop_car, "tag_origin" );

//	wait .5;
//	m_ce_cop_car DoDamage( m_ce_cop_car.health, m_ce_cop_car.origin, undefined, undefined, "riflebullet" );
}

cop_car_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	m_ce_cop_car = GetEnt( "ce_cop_car", "script_noteworthy" );
	if( IsDefined(e_inflictor) && IsDefined(m_ce_cop_car) && m_ce_cop_car == e_inflictor )
	{
		return 50;  // deal 50 damage to the player for the cop car explosion as opposed to killing the player
	}
	
	return n_damage;
}

street_spawn_scripted_cop_car()
{
	//Eckert - Moved to NT: ch_la_05_01_cougar_exit_cop1
	//level thread play_police_pullup();
	wait 28; // magic time get the scripted cop car into the scene
	
	trigger_use( "street_cop_car_entry" );
	
	wait 1;
	
	//vh_cop_car = GetEnt( "street_police_car", "targetname" );
	//vh_cop_car thread police_car();
	
	level.cop_1 = init_hero( "street_cop_1" );
	level.cop_1.name = "Officer Janssen";
	
	level.cop_2 = init_hero( "street_cop_2" );
	level.cop_2.name = "Officer Barnes";
}

play_police_pullup()
{
	//iprintlnbold("wait");
	wait(7);
	//iprintlnbold("pullup");
	playsoundatposition ("evt_la_1_police_drive_up", (0,0,0));	
	
}

cougar_exit_everything_else()
{
	m_cougar_shadow_prop = GetEnt( "cougar_shadow_prop", "targetname" );
	m_cougar_shadow_prop Delete();
	
	m_cougar_interior = GetEnt( "interior_cougar_exit", "targetname" );
	m_cougar_interior Attach( "veh_t6_mil_cougar" );
	m_cougar_interior HidePart( "tag_windshield" );
	m_cougar_interior ShowPart( "tag_windshield_d2" );
	m_cougar_interior play_fx( "cougar_monitor", undefined, undefined, -1, true, "tag_fx_monitor" );
	
	level thread run_scene( "cougar_exit" );
	if ( !flag( "harper_dead" ) )
	{
		level.harper Attach( "t6_wpn_special_storm_world", "tag_weapon_left" );
		level.harper maps\_anim::anim_set_blend_out_time( .3 );		
		
		level thread run_scene( "cougar_exit_interior" );
		level thread run_scene( "cougar_exit_claw" );
		level thread run_scene( "cougar_exit_harper" );
	}
	else
	{
		level thread run_scene( "cougar_exit_interior_noharper" );
		level thread cougar_exit_claw_noharper();
		level.player EnableInvulnerability();
	}
	
	flag_wait( "cougar_exit_started" );
	
	vh_wheeler = get_model_or_models_from_scene( "cougar_exit", "wheeler_cougar_exit" );
	vh_wheeler IgnoreCheapEntityFlag( true );
	
	vh_f35_cougar_exit = get_model_or_models_from_scene( "cougar_exit", "f35_cougar_exit" );
	vh_f35_cougar_exit veh_magic_bullet_shield( true );
	vh_f35_cougar_exit thread f35_vtol_spawn_func();
    
	m_cop_car_1 = get_model_or_models_from_scene( "cougar_exit", "ce_car_1" );
	m_cop_car_1 thread police_car();
    
	m_cop_car_2 = get_model_or_models_from_scene( "cougar_exit", "ce_car_2" );
	m_cop_car_2 thread police_car();
    
	m_ce_bike_1 = get_model_or_models_from_scene( "cougar_exit", "ce_bike_1" );
	m_ce_bike_1 thread police_motorcycle();
    
	m_ce_bike_2 = get_model_or_models_from_scene( "cougar_exit", "ce_bike_2" );
	m_ce_bike_2 thread police_motorcycle();
    
	m_ce_bike_3 = get_model_or_models_from_scene( "cougar_exit", "ce_bike_3" );
	m_ce_bike_3 thread police_motorcycle();
    
	ai_ce_cop_2 = GetEnt( "ce_cop_2_ai", "targetname" );
	ai_ce_cop_2.name = "";
	
	//Tuey - Street Music on.
	level thread maps\_audio::switch_music_wait ("LA_1B_STREET", 30);
    
	if ( !flag( "harper_dead" ) )
	{
		scene_wait( "cougar_exit_harper" );
		end_scene( "cougar_exit_harper" );
		
		level.harper Detach( "t6_wpn_special_storm_world", "tag_weapon_left" );
		level.harper Attach( "t6_wpn_special_storm_world", "tag_stowed_back" );
		
		//SOUND =- Shawn J
		// TODO ai_bdog playsound ("mycoolsound");
		ai_bdog = get_model_or_models_from_scene( "cougar_exit_claw", "bdog_cougar_exit" );
		ai_bdog notify( "claw_cntxt" );		
	}
	else
	{
		scene_wait( "cougar_exit_player" );
    		level.player DisableInvulnerability();
	}
    
	spawn_model( "veh_t6_mil_cougar", m_cougar_interior.origin, m_cougar_interior.angles );
	m_cougar_interior Delete();
}

cougar_exit_claw_noharper()
{
	s_moveto_1 = GetStruct( "claw_harper_dead_pos_1", "targetname" );
	s_moveto_2 = GetStruct( "claw_harper_dead_pos_2", "targetname" );

	wait 19;
	
	ai_claw = simple_spawn_single( "claw_harper_dead" );
	ai_claw.goalradius = 32;
	
	ai_claw SetGoalPos( s_moveto_1.origin );
	ai_claw waittill( "goal" );
	ai_claw set_ignoreall( true );
	ai_claw SetGoalPos( s_moveto_2.origin );
	ai_claw SetTargetOrigin( s_moveto_2.origin );
}

harper_fire_sniperstorm( ai_harper )
{
	PlayFXOnTag( GetFX( "ce_harper_muzflash" ), ai_harper, "tag_weapon_left" );
}

/* ------------------------------------------------------------------------------------------
CLEAR THE STREET ANIM RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/
clear_the_street()
{
	m_clip = GetEnt( "street_truck_collision", "targetname" );
	m_car_clip = getent( "street_police_collision", "targetname" );	
	
	m_clip ConnectPaths();
	m_clip NotSolid();

	m_car_clip Solid();
	m_car_clip DisconnectPaths();		
	
	run_scene_first_frame( "clear_the_street", true );
	
	flag_wait( "fl_clear_the_street" );

	//Client notify that will turn flyby audio back on.
	clientNotify ("fbsoff");
	
	level thread clear_the_street_vo();
	
	m_car_clip ConnectPaths();
	m_car_clip NotSolid();	
	level thread run_scene( "clear_the_street_ter" );
	level thread run_scene( "clear_street_ter_semi" );
	level thread setup_clear_the_street_ai();
	level run_scene( "clear_the_street" );

	m_clip Solid();
	m_clip DisconnectPaths();
	
	simple_spawn_single( "bdog_back" );
}

setup_clear_the_street_ai()
{
	wait 0.1;
	e_clear_street1 = get_ais_from_scene( "clear_the_street_ter", "ter_clear_the_street" );
	if ( IsAlive( e_clear_street1 ) )
	{
		e_clear_street1 disable_long_death();
	}
	
	a_clear_street = get_ais_from_scene( "clear_street_ter_semi" );
	foreach( clear_guy in a_clear_street )
	{
		if ( IsAlive( clear_guy ) )
		{
			clear_guy disable_long_death();
		}
	}
}

clear_the_street_vo()
{
	//waittill_vo_done();
	
	a_enemies = GetAIArray( "axis" );
	if ( a_enemies.size > 0 )
	{
		a_enemies[ RandomInt( a_enemies.size ) ] queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

/* ------------------------------------------------------------------------------------------
BRUTE FORCE RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/
brute_force_obj()
{
	t_brute_force_radius = GetEnt( "t_brute_force_radius", "targetname" );
	
	s_brute_force_pos = getstruct( "brute_force_use_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_brute_force_pos.origin, "interact" );
}

brute_force_use()
{
	level endon( "brute_force_fail" );
	
	run_scene_first_frame( "brute_force_cougar" );
	
	m_bruteforce_cougar = GetEnt( "bruteforce_cougar", "targetname" );
	m_bruteforce_cougar Delete();
	
	m_cougar_interior = GetEnt( "bruteforce_cougar_interior", "targetname" );
	m_cougar_interior Attach( "veh_t6_mil_cougar" );
	m_cougar_interior HidePart( "tag_windshield" );
	m_cougar_interior ShowPart( "tag_windshield_d2" );
	
	a_ssa_brute_force = GetEntArray( "ssa_brute_force", "targetname" );	
	array_thread( a_ssa_brute_force, ::add_spawn_function, ::magic_bullet_shield );
	
	level.player waittill_player_has_brute_force_perk();
	
	s_brute_force_pos = getstruct( "brute_force_use_pos", "targetname" );
	
	set_objective( level.OBJ_BRUTE_PERK, s_brute_force_pos, "interact" );
	
	trigger_wait( "t_brute_force_use" );
	
	set_objective( level.OBJ_BRUTE_PERK, undefined, "remove" );
	
	level notify( "brute_force_done" );
		
	level thread run_scene_and_delete( "brute_force_player" );
	level thread run_scene_and_delete( "brute_force_cougar" );
}

brute_force_fail()
{
	level endon( "brute_force_done" );
	
	//trigger_wait( "brute_force_fail" );
	
	flag_wait( "plaza_enter" );
	flag_set( "brute_force_fail" );
	
	set_objective( level.OBJ_BRUTE_PERK, undefined, "remove" );
	
	m_brute_force_cougar = GetEnt( "bruteforce_cougar_interior", "targetname" );
	m_brute_force_cougar PlaySound( "exp_armor_vehicle" );
	PlayFXOnTag( level._effect[ "brute_force_explosion" ], m_brute_force_cougar, "tag_origin" );
}

/* ------------------------------------------------------------------------------------------
RANDOM STREET SCRIPTS
-------------------------------------------------------------------------------------------*/

// delay, then spawn the middle bdog.
//
street_spawn_bdog_middle(delay_s)
{
	wait delay_s;
	simple_spawn_single( "bdog_front" );
}

// self == a vehicle that needs to be unload in the street
street_veh_unload()
{
	self endon( "death" );
	self waittill_notify_or_timeout( "brake", 6 );	
	
	self playsound( "evt_van_incoming" );
	
	while ( self GetSpeedMPH() > 0 )
	{
		wait 0.05;
	}
	
	//self notify( "unload" );
			
	m_fire_hydrant = GetEnt( "truck_hydrant", "script_noteworthy" );
	m_fire_hydrant DoDamage( m_fire_hydrant.health, m_fire_hydrant.origin, undefined, undefined, "riflebullet" );
	m_fire_hydrant DoDamage( m_fire_hydrant.health, m_fire_hydrant.origin, undefined, undefined, "riflebullet" );
}

setup_street_middle()
{
	street_trigger = GetEnt( "street_truck_entry", "targetname" );
	street_trigger waittill( "trigger" );
	
	wait 6;
	
	level thread street_spawn_bdog_middle(4.0);
	
	m_18_wheeler_clip = GetEnt( "street_truck_collision", "targetname" );
	m_18_wheeler_clip Solid();
	m_18_wheeler_clip DisconnectPaths();	
}


// self == a vehicle
delete_vehicle_on_notify( str_notify )
{
	self endon( "death" );
	
	self waittill( str_notify );
	
	self Delete();
}

street_elec_on_ground()
{
//	a_elec_sparks = getstructarray( "elec_sparks", "targetname" );
//
//	foreach ( s_elec_spark in a_elec_sparks )
//	{
//		PlayFX( level._effect[ "elec_spark" ], s_elec_spark.origin );
//	}
	
	t_street_push_back = GetEnt( "street_push_back", "targetname" );
	
	// push the player back and shock the player
	while ( true )
	{
		if ( level.player IsTouching( t_street_push_back ) )
		{
			v_velocity = level.player GetVelocity();
			
			level.player SetVelocity( v_velocity + ( -600, 0, 0 ) );
			level.player DoDamage( 40, t_street_push_back.origin );
		}
		
		wait 0.05;
	}
}

street_fire_hydrant()
{
	m_fire_hydrant = GetEnt( "street_hydrant", "script_noteworthy" );
	
	n_player_fov = GetDvarFloat( "cg_fov" );
	n_cos_player_fov = cos( n_player_fov );
	
	const n_fh_range = 65536; // 256 * 256
	
	level waittill( "street_battle_started" );
	
	n_fh_dist_from_player = Distance2DSquared( m_fire_hydrant.origin, level.player.origin );
	
	// wait until the player is looking at it and within a certain distance
	while ( !( level.player is_player_looking_at( m_fire_hydrant.origin, 1 ) ) && n_fh_dist_from_player > n_fh_range )
	{
		wait 0.05;
		
		n_fh_dist_from_player = Distance2DSquared( m_fire_hydrant.origin, level.player.origin );
	}
	
	m_fire_hydrant DoDamage( m_fire_hydrant.health, m_fire_hydrant.origin, undefined, undefined, "riflebullet" );
	
	// wait until the player is looking at it and within a certain distance
	while ( !( level.player is_player_looking_at( m_fire_hydrant.origin, 0.01 ) ) && n_fh_dist_from_player > n_fh_range )
	{
		wait 0.05;
	}
	
	m_fire_hydrant DoDamage( m_fire_hydrant.health, m_fire_hydrant.origin, undefined, undefined, "riflebullet" );
}

fxanim_debris()
{
	trigger_wait( "fxanim_debris_1" );
	
	level notify( "fxanim_debris_layer_2_start" );
	
	trigger_wait( "fxanim_debris_2" );
		
	level notify( "fxanim_debris_layer_1_start" );
	level notify( "fxanim_debris_layer_3_start" );
	
	trigger_wait( "t_street_done" );
	
	level notify( "fxanim_drone_chunks_start" );
}

// prevent the player from running ahead until
// both claws are dead.
street_run_ahead_check()
{
	level endon( "street_bdogs_killed" );
	
	trigger_wait( "t_street_done" );
	
	// theoretically, this could be perceived as the bdogs killing you.
	drone_shoot_at_player();
}

player_out_of_bound()
{	
	trigger_wait( "out_of_bound" );
	
	drone_shoot_at_player();
}

drone_shoot_at_player()
{
	level.player DisableInvulnerability();
	level.player EnableHealthShield( false );
	//level.player.overridePlayerDamage = ::drone_player_damage_override;
	
	nd_start = GetVehicleNode( "drone_kill_player_path", "targetname" );
	vh_drone = spawn_vehicle_from_targetname( "avenger_fast" );
	vh_drone.origin = nd_start.origin;
	vh_drone.angles = nd_start.angles;
	vh_drone SetForceNoCull();
	vh_drone thread delete_vehicle_on_notify( "delete_vehicle" );
	vh_drone thread go_path( nd_start );
	vh_drone thread shoot_turret_at_target( level.player, -1, undefined, 0 );
	
	vh_drone waittill( "shoot_player" );
	
	vh_drone thread shoot_turret_at_target( level.player, -1, undefined, 1 );
	vh_drone thread shoot_turret_at_target( level.player, -1, undefined, 2 );
}

drone_player_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	if( IS_VEHICLE( e_inflictor ) )
   	{
		if( IS_QUADROTOR( e_inflictor ) )
		{
			if( isdefined( e_inflictor.team ) && e_inflictor.team == "allies" )
			{
				n_damage = 0;	
			}
			else
			{
				n_damage = n_damage * 2;
			}		
		}   	
   	}	
	
	return n_damage;
}

/* ------------------------------------------------------------------------------------------
VO RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/
street_vo()
{
	scene_wait( "cougar_exit" );
	
	level thread street_vo_lapd_callouts();
	level thread street_vo_pmc_callouts();
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "it_was_a_fucking_a_013" );
		level.harper queue_dialog( "harp_we_got_mercs_moving_0" );
	}
	
	flag_wait( "bdog_front_spawned" );
	
	while ( level.street_bdog_front SightConeTrace( level.player get_eye(), level.street_bdog_front ) < .5 )
	{
		wait .5;
	}
	
	level.player queue_dialog( "dammit_theyve_go_014", 0 );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_it_s_armor_s_tough_0", 0, undefined, "bdog_front_dead" );
		level.harper queue_dialog( "harp_if_you_ve_got_an_exp_0", 0, undefined, "bdog_front_dead" );
		level.harper queue_dialog( "harp_watch_the_grenades_0", 1, undefined, "bdog_front_dead" );
	}
	
//	level thread street_enemy_vo();
//	street_friendly_vo();
}

street_vo_lapd_callouts()
{	
	a_vo_callouts = [];
	a_vo_callouts[ "bus_stop" ]		= array( "lpd1_behind_the_bus_stop_0" );
	a_vo_callouts[ "food_cart" ]	= array( "lpd3_behind_the_cart_0" );
	a_vo_callouts[ "van" ]			= array( "by_the_van_018" );
	a_vo_callouts[ "in_hotel" ]		= array( "lpd1_ground_floor_they_r_0", "lpd3_left_side_left_sid_0", "lpd1_watch_the_hotel_0" );
	a_vo_callouts[ "above_hotel" ] 	= array( "lpd3_look_out_on_the_roo_0", "lpd3_they_re_coming_down_0" );
	a_vo_callouts[ "window" ]		= array( "in_the_window_040" );
	a_vo_callouts[ "train_top" ] 	= array( "lpd2_guy_on_the_train_if_0", "theyre_on_top_of_041", "lpd2_watch_out_sharpshoo_0" );
	a_vo_callouts[ "generic" ] 		= array( "lpd1_dammit_we_re_compl_0", "lpd1_dammit_i_m_nearly_0", "lpd3_don_t_let_them_get_b_0", "get_in_cover_h_ret_005", 
		                               "lpd1_get_in_cover_retur_0", "lpd2_get_in_cover_retur_0", "lpd3_get_in_cover_retur_0", "lpd3_get_me_out_of_here_0", 
		                               "lpd2_get_out_of_here_0", "lpd2_give_them_cover_0", "lpd3_guy_at_the_corner_0", "hold_them_back_006", "lpd1_how_the_hell_do_we_c_0", 
		                               "lpd3_i_m_burning_ammo_he_0", "lpd3_i_m_hit_i_m_hit_0", "lpd2_call_it_in_0", "lpd2_move_get_out_of_th_0", "lpd1_officers_down_0", 
		                               "put_em_down_034", "lpd1_reloading_0", "lpd1_the_city_s_a_fucking_0", "lpd1_they_re_comin_at_us_0", "lpd1_they_re_slaughtering_0", 
		                               "lpd1_they_re_trying_to_fl_0", "lpd3_watch_your_fire_age_0", "lpd3_watch_your_zone_wa_0" );
	
	level thread vo_callouts( "street_lapd", "allies", a_vo_callouts, "la_arena_start" );
}

street_vo_pmc_callouts()
{
	a_vo_callouts = [];
	a_vo_callouts[ "in_hotel" ]		= array( "pmc1_they_re_in_the_hotel_0", "pmc3_get_in_the_hotel_w_0" );
	a_vo_callouts[ "in_train" ]		= array( "pmc3_inside_the_train_0" );
	a_vo_callouts[ "near_cars" ]	= array( "pmc3_get_that_motherfucke_0", "pmc2_fuckers_are_hiding_b_0" );
	a_vo_callouts[ "generic" ]		= array( "pmc0_get_the_hell_away_0", "pmc0_hit_and_move_hit_a_0", "pmc0_keep_shooting_you_f_0", "pmc1_keep_them_on_the_str_0", 
	                                    "pmc1_we_re_taking_you_dow_0", "pmc1_i_got_that_fucker_0", "pmc1_i_bagged_another_0", "pmc1_i_m_three_for_three_0", "pmc1_eat_lead_and_die_mo_0", 
	                                    "pmc1_i_m_hit_0", "pmc1_bastards_0", "pmc1_we_re_losing_men_0", "pmc1_run_get_the_fuck_o_0", "pmc1_dammit_weapon_s_ja_0", "pmc2_die_american_0", 
	                                    "pmc2_fuck_you_0", "pmc2_this_is_payback_0", "pmc2_keep_them_back_0", "pmc2_get_me_a_clip_0", "pmc2_i_need_ammo_0", "pmc2_we_need_more_men_dow_0", 
	                                    "pmc2_hold_the_blockade_0", "pmc3_hit_em_now_0", "pmc3_stay_on_them_0", "pmc3_i_got_him_0", "pmc3_fuck_man_they_shot_0", "pmc3_come_on_keep_push_0", 
	                                    "pmc3_i_m_out_0", "pmc3_keep_it_together_0", "pmc3_keep_your_heads_down_0", "pmc3_get_down_there_0", "pmc3_that_was_close_0" );
	
	level thread vo_callouts( undefined, "axis", a_vo_callouts, "la_arena_start" );
}

harper_waittill_not_talking()
{	
	do_talk = true;
	
	if ( IS_TRUE( level.harper.is_talking ) )
	{
		do_talk = false;
	}
	
	return do_talk;
}

street_enemy_vo()
{
	level endon( "end_enemy_street_vo" );
	
	a_enemies = GetAIArray( "axis" );
	if( a_enemies.size )//Check to make sure any are around
	{
		a_enemies[ RandomInt( a_enemies.size ) ] say_dialog( "pmc0_they_re_in_the_killz_0" );		
	}
	
	while ( true )
	{
		//waittill_vo_done();
		
		if ( flag( "police_in_hotel" ) && RandomInt( 3 ) == 0 )
		{
			flag_set( "vo_general" );
			
			enemy_hotel_vo();
			
			wait 1;
			
			flag_clear( "vo_general" );
			
			wait 36;
		}
		else
		{
			flag_set( "vo_general" );
			
			a_enemies = GetAIArray( "axis" );
			if ( a_enemies.size > 1 )
			{
				ai_enemy = a_enemies[ RandomInt( a_enemies.size ) ];
				
				if ( RandomInt( 3 ) == 0 )
				{
					ai_enemy street_general_enemy_vo();
				}
				else
				{
					ai_enemy street_spanish_enemy_vo();
				}
			}
			
			wait 1;
			
			flag_clear( "vo_general" );
			
			wait 36;
		}
	}
}

street_friendly_vo()
{
	level endon( "street_cleared" );
	
	while ( true )
	{
		//waittill_vo_done();
		
		if ( flag( "someone_near_hotel" ) )
		{
			flag_set( "vo_general" );
			
			friendly_hotel_vo();
			
			wait 1;
			
			flag_clear( "vo_general" );
			
			wait 68;
		}
		else
		{
			flag_set( "vo_general" );
			
			street_general_friendly_vo();
			
			wait 1;
			
			flag_clear( "vo_general" );
			
			wait 68;
		}
	
		wait 0.05;
	}
}

friendly_hotel_vo()
{
	n_random = RandomInt( 4 );	
	
	if ( n_random == 0 )
	{ 
		if ( !flag( "harper_dead" ) )
		{
			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
		else 
		{
			level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
	}
	else if ( n_random == 1 )
	{
		level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 2 )
	{
		level.cop_2 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 3 )
	{
		level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

street_general_friendly_vo()
{
	n_random = RandomInt( 7 );
	
	if ( n_random == 0 )
	{ 
		if ( !flag( "harper_dead" ) )
		{
			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
		else 
		{
			level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
	}
	else if ( n_random == 1 )
	{
		level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 2 )
	{
		level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 3 )
	{
		level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 4 )
	{
		level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 5 )
	{
		level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 6 )
	{
		level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

enemy_hotel_vo()
{
	n_random = RandomInt( 2 );
	
	if ( n_random == 0 )
	{ 
		a_enemies = GetAIArray( "axis" );
		if ( a_enemies.size > 0 )
		{
			a_enemies[ RandomInt( a_enemies.size ) ] queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
	}
	else if ( n_random == 1 )
	{
		a_enemies = GetAIArray( "axis" );
		if ( a_enemies.size > 0 )
		{
			a_enemies[ RandomInt( a_enemies.size ) ] queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
	}
}

street_general_enemy_vo()
{
	self endon( "death" );
	
	n_random = RandomInt( 9 );
	
	if ( n_random == 0 )
	{ 
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 1 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 2 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 3 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 4 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 5 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 6 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 7 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 8 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

street_spanish_enemy_vo()
{
	self endon( "death" );
	
	n_random = RandomInt( 8 );
	
	if ( n_random == 0 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 1 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 2 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 3 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 4 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 5 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 6 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 7 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

//street_claw_vo_immobilized( is_front_bdog )
//{
//	self endon( "death" );
//	
//	self waittill( "immobilized" );
//	self waittill( "damage", n_damage, e_attacker );
//	
//	if ( IS_TRUE( is_front_bdog ) )
//	{
//		//waittill_vo_done();
//		level.player notify( "kill_pending_dialog" );
//		
//		//flag_set( "claw_vo_going" );
//		
//		if ( RandomInt( 2 ) == 0 )
//		{
//			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			
//			if ( IsDefined( e_attacker ) && e_attacker == level.player )
//			{
//				level.player queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			}
//		}
//		else
//		{
//			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			
//			if ( IsDefined( e_attacker ) && e_attacker == level.player )
//			{
//				level.player queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			}
//		}
//		
//		level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//		
////		wait 0.5;
////		
////		flag_clear( "claw_vo_going" );
//	}
//	else
//	{
//		//waittill_vo_done();
//		level.player notify( "kill_pending_dialog" );
//		
//		//flag_set( "claw_vo_going" );
//		
//		if ( RandomInt( 2 ) == 0 )
//		{
//			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			level.player queue_dialog( "pmc0_they_re_in_the_killz_0" );
//		}
//		else
//		{
//			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//			level.player queue_dialog( "pmc0_they_re_in_the_killz_0" );
//		}
//		
//		level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
//		
////		wait 0.5;
////		
////		flag_clear( "claw_vo_going" );
//	}
//}

street_claw_vo_player()
{
	self waittill( "claw_starting_vo_done" );
	
	if ( !flag( "got_hit_by_claw" ) )
	{
		level.cop_1 notify( "kill_pending_dialog" );
		
		flag_set( "got_hit_by_claw" );

		if ( !flag( "harper_dead" ) )
		{
			level.harper queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
		else 
		{
			level.cop_1 queue_dialog( "pmc0_they_re_in_the_killz_0" );
		}
				
		flag_clear( "got_hit_by_claw" );
	}
}

claw_vo_player_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	if ( IsDefined( e_attacker.weaponinfo ) && IsString( e_attacker.weaponinfo ) && e_attacker.weaponinfo == "bigdog_dual_turret" )
	{
		level thread street_claw_vo_player();
	}
	
	return n_damage;
}

street_claw_vo_grenade()
{
	self endon( "death" );
	
	const n_grenade_range = 16384;
		
	while ( true )
	{
		self waittill( "grenade_fire_bigdog", v_grenade_target );
		
		n_dist_sq_range = DistanceSquared( level.player.origin, v_grenade_target );
		if ( n_dist_sq_range < n_grenade_range )
		{
			n_random = RandomInt( 3 );
			
			if ( n_random == 0 )
			{
				if ( !flag( "harper_dead" ) )
				{
					level.harper priority_dialog( "grenade_026" );
				}
			}
			else if ( n_random == 1 )
			{
				if ( !flag( "harper_dead" ) )
				{
					level.harper priority_dialog( "harp_move_section_0" );
				}
			}
			else if ( n_random == 2 )
			{
				if ( !flag( "harper_dead" ) )
				{
					level.harper priority_dialog( "get_outta_there_028" );
				}
			}
			else if ( n_random == 3 )
			{
				if ( !flag( "harper_dead" ) )
				{
					level.harper priority_dialog( "throw_it_back_029" );
				}
			}
		}
	}
}

rush_vo()
{
	self endon( "death" );
	
	//waittill_vo_done();
	
	n_random = RandomInt( 3 );
	
	if ( n_random == 0 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 1 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( n_random == 2 )
	{
		self queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

metro_vo()
{
	self endon( "death" );
	
	//waittill_vo_done();
		
	if ( RandomInt( 4 ) == 0 )
	{
		level.cop_1 thread queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( RandomInt( 2 ) == 0 )
	{
		self thread queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
	else if ( RandomInt( 2 ) == 0 )
	{
		self thread queue_dialog( "pmc0_they_re_in_the_killz_0" );
	}
}

/* ------------------------------------------------------------------------------------------
LIGHTING RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/

street_shellshock_and_visionset()
{
	current_vision_set = level.player GetVisionSetNaked();
	if ( current_vision_set == "" )
	{
		current_vision_set = "default";
	}
		
	VisionSetNaked( "sp_la_1b_crash_exit" );		
	wait 1;	
	screen_fade_in( 9 );
		
	VisionSetNaked( current_vision_set, 10 );
}

/* -------------------------------------------------------------------------------------------
 * QUAD ROTORS
 * -------------------------------------------------------------------------------------------*/
intruder_gatecrash( m_player ) // notetrack = "gatecrash"
{
}

intruder_zap( m_player ) // notetrack = "zap"
{
}

intruder_zap_start( m_cutter ) // notetrack = "zap_start"
{
	m_cutter play_fx( "laser_cutter_sparking", undefined, undefined, "stop_fx", true, "tag_fx" );
	//fx_laser_cutter_on
}

intruder_zap_end( m_cutter ) // notetrack = "zap_end"
{
	m_cutter notify( "stop_fx" );
}

intruder_cutter_on( m_cutter ) // notetrack = "start"
{
	m_cutter play_fx( "laser_cutter_on", undefined, undefined, undefined, true, "tag_fx" );
}

intruder_hide_bolts( m_cage )
{
	m_cage HidePart( "tag_bolts" );
}

autoexec init_attackdrones()
{
	a_drones = get_vehicle_array( "attackdrone" );
	nd_exit_path = GetVehicleNode( "quad_rotors_exit_path", "targetname" );
	
	while( !isdefined(level.player) )
	{
		wait .5;
	}	
	
	level.player waittill_player_has_intruder_perk();
	
	str_objective = getstruct( "intruder_perk_use_pos", "targetname" );
	
	set_objective( level.OBJ_INTRUDER_PERK, str_objective, "interact" );
	
	trigger_wait( "trig_attackdrone", "targetname" );
	
	level.player StartCameraTween( 0.5 );
	run_scene_and_delete( "intruder" );	
	level thread set_objective( level.OBJ_INTRUDER_PERK, str_objective, "remove" );	
	
	level.player maps\_fire_direction::init_fire_direction();
	
	foreach ( vh_drone in a_drones )
	{
		vh_drone maps\_quadrotor::quadrotor_on();
		wait 0.05;
		
		vh_drone DisableAimAssist();
		vh_drone maps\_quadrotor::quadrotor_start_scripted();
		
		vh_drone DrivePath( nd_exit_path );
		
		vh_drone thread init_attackdrones_start_ai();
		wait .5;
	}
}

init_attackdrones_start_ai()
{
	self waittill( "reached_end_node" );
	
	self maps\_quadrotor::quadrotor_start_ai();
	maps\_fire_direction::add_fire_direction_shooter( self );
	
	self thread follow_player();	
}

follow_player( follow_close = false )
{
	self endon( "death" );
	self endon( "stop_follow" );
	
	while ( true )
	{
		//v_goal = level.player.origin + VectorNormalize( AnglesToForward( level.player.angles ) ) * 300;
		v_goal = level.player.origin;
		self defend( v_goal, 400 );
		if( follow_close )
			wait 0.5;
		else
			wait 3;
	}
}

press_demo_quadrotors()
{
	a_press_drones = spawn_vehicles_from_targetname( "press_demo_drone" );
	//foreach( drone in a_press_drones )
	//{
	//	drone thread maps\_quadrotor::quadrotor_off();
	//}
	
	quadrotor_trigger = GetEnt( "press_demo_quadrotors", "targetname" );
	quadrotor_trigger waittill( "trigger" );	
	
	//TUEY - FOR PRESS Music Trigger
	setmusicstate( "LA_1B_PLAZA");
	
	a_press_drones = GetEntArray( "press_demo_drone", "targetname" );
	for( x = 0; x < a_press_drones.size; x++ )
	{
		//drone thread maps\_quadrotor::quadrotor_on();
		//drone thread follow_player(true);
		a_press_drones[x] thread press_demo_quadrotor_intro(x);
		a_press_drones[x] thread quadrotor_target_offset();
	}
	
	PlaySoundAtPosition ("evt_drone_flyby_swt", (14848, -5084, 209));
			
	wait 10;
	
	level.player maps\_fire_direction::init_fire_direction();
	a_press_drones = GetEntArray( "press_demo_drone", "targetname" );
	foreach( drone in a_press_drones )
	{
		level thread maps\_fire_direction::add_fire_direction_shooter( drone );
		drone thread follow_player();
	}
	
	level thread track_demo_drones();
}

press_demo_quadrotor_intro( goal_index )
{
	goal_pos = getent( "press_drone_pos" + (goal_index + 1), "targetname").origin;
	self quadrotor_start_scripted();
	self.goalpos = goal_pos;
	self SetVehGoalPos( goal_pos );
	self waittill( "near_goal" );
	
	switch( goal_index )
	{
		case 4:
		case 5:
			wait .4;	
			self quadrotor_start_ai();	
			goal_pos = getent( "press_drone_plaza" + (goal_index + 1), "targetname").origin;
			self.goalpos = goal_pos;
			self SetVehGoalPos( goal_pos );
			self waittill( "near_goal" );			
			break;
			
		default:
			wait .15;	
			goal_pos = getent( "press_drone_plaza" + (goal_index + 1), "targetname").origin;
			self.goalpos = goal_pos;
			self SetVehGoalPos( goal_pos );
			self waittill( "near_goal" );
			self quadrotor_start_ai();			
			break;
	}	
}

#define QR_OFFSET 2
quadrotor_target_offset()
{
	self endon( "death" );
	
	while( 1 )
	{
		self.custom_target_offset = ( RandomFloatRange( -QR_OFFSET, QR_OFFSET ), RandomFloatRange( -QR_OFFSET, QR_OFFSET ), RandomFloatRange( -QR_OFFSET, QR_OFFSET ) );
		wait 0.2;//QR script looks for a new target a min of 0.4 seconds apart
	}
}

track_demo_drones()
{
	while( maps\_fire_direction::check_for_valid_shooters() )
	{
		wait .05;	
	}
	level.player maps\_fire_direction::_fire_direction_kill();
}
