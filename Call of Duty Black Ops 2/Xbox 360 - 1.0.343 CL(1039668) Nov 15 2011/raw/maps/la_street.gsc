#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_juggernaut;
#include maps\_objectives;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\la_utility;
#include animscripts\anims;
#include animscripts\utility;
#include maps\_music;

#include maps\_glasses;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_street()
{
	init_hero( "harper" );
	start_teleport( "skipto_street" );
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
}

main()
{	
	init_hero( "harper" );
	
	set_objective( level.OBJ_DRIVE, undefined, "done" );

	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	level thread spawn_aerial_vehicles( 45, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	level thread fxanim_aerial_vehicles( 23 );
	
	level thread street_objectives();
	level thread street_ais();
	level thread street_vo();
	level thread street_elec_on_ground();
	level thread fxanim_debris();
	level thread enemy_on_top_of_metro();
	
	level thread hotel_visionset();
	
	level.supportsPistolAnimations = true;
	
//	add_spawn_function_veh( "street_police_car", ::veh_brake_unload );

	cougar_exit();
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper thread street_harper_logic();
	
	level thread player_out_of_bound();
	
	clear_the_street();
	
	level thread brute_force();
	
	flag_wait( "la_street_done" );
}

glight_to_la_2() // TODO: remove this after greenlight
{
	play_bink_on_hud_glasses( "eye_v2" );
	
	if ( is_greenlight_build() )
	{
		fade_to_black( 3 );
		
		nextmission();
	}
}

street_objectives()
{
	ai_harper = GetEnt( "harper_ai", "targetname" );
	
	scene_wait( "cougar_exit_player" );
	
	set_objective( level.OBJ_STREET_REGROUP );
	set_objective( level.OBJ_STREET );
	
	level waittill( "plaza_obj_ready" );
	
	set_objective( level.OBJ_STREET, undefined, "done" );
	set_objective( level.OBJ_STREET, undefined, "delete" );
	
	trigger_use( "obj_plaza_start" );
	
	level thread glight_to_la_2();
}

street_vo()
{
	ai_harper = GetEnt( "harper_ai", "targetname" );
	
	level waittill( "street_battle_started" );
	
	ai_harper say_dialog( "the_area_is_too_ho_001" );
	level.player say_dialog( "keep_the_president_002" );
	level.player say_dialog( "well_regroup_at_p_003" );
	
	add_vo_to_nag_group( "street_nag", ai_harper, "theyre_almost_on_004" );
	add_vo_to_nag_group( "street_nag", ai_harper, "dammit__keep_firi_005" );
	add_vo_to_nag_group( "street_nag", ai_harper, "keep_them_back_006" );
	
	t_street_nag_done = GetEnt( "plaza_color_start", "targetname" );
	level thread start_vo_nag_group_trigger( "street_nag", t_street_nag_done, 61, undefined, true );
	
	level waittill( "street_cleared" );
	
	level.player say_dialog( "the_road_is_clear_007" );
}

// self == harper
street_harper_logic()
{	
	self thread street_harper_start();
	
//	t_color_street_clear_out = GetEnt( "color_street_clear_out", "targetname" );
//	t_color_street_clear_out Delete();
//	
//	t_color_street_clear_in = GetEnt( "color_street_clear_in", "targetname" );
//	t_color_street_clear_in Delete();
	
	waittill_ai_group_amount_killed( "street_bdog", 1 );
	
	autosave_by_name( "street_1_bdog_killed" );
	
	level thread street_second_wave_move();
	
	waittill_ai_group_amount_killed( "street_bdog", 2 );
	
	level notify( "street_bdogs_killed" );
	
//	t_color_street_clear_out = GetEnt( "color_street_clear_out", "targetname" );
//	t_color_street_clear_out Delete();
//	
//	t_color_street_clear_in = GetEnt( "color_street_clear_in", "targetname" );
//	t_color_street_clear_in Delete();
	
//	self change_movemode("cqb");
	self.perfectaim = 1;
	
	self disable_ai_color();
	self.goalradius = 2048;
	self.fixedNode = false;
	
	self street_harper_finish();
	
	self.goalradius = 64;
	self.fixedNode = true;
	self enable_ai_color();
	
	trigger_use( "plaza_color_start" );
	
//	self reset_movemode();
	self.perfectaim = 0;
	
	flag_set( "la_street_done" );
}

// self == harper
street_harper_start()
{
	trigger_wait( "color_street_start_out" );
	
	level notify( "street_battle_started" );
	
	self force_goal( undefined, 16, true );
}

street_second_wave_move()
{
	level endon( "street_bdogs_killed" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper disable_ai_color();
	ai_harper.goalradius = 2048;
	ai_harper.fixedNode = false;
	
	trigger_use( "sm_street_train_inside" );
	trigger_use( "sm_street_back" );
	trigger_use( "s_bdog_1_clear_move" );
	
	t_clear_the_street = GetEnt( "t_clear_the_street", "targetname" );
	if ( IsDefined( t_clear_the_street ) )
	{
		trigger_use( "t_clear_the_street" );
	}
	
	trigger_off( "bdog_cover_front", "targetname" );
	
	while ( GetAIArray( "axis" ).size > 2 )
	{
		wait 0.05;
	}
	
	ai_cop_1 = GetEnt( "street_cop_1_ai", "targetname" );
	ai_cop_2 = GetEnt( "street_cop_2_ai", "targetname" );
	
	ai_cop_1.fixedNode = false;
	ai_cop_2.fixedNode = false;
	
	ai_harper enable_ai_color();
	ai_harper.goalradius = 256;
	
	wait 0.05;
	
	
	
	trigger_use( "kill_bdog_2_move" );
}

street_harper_finish()
{
	level thread street_move_remaining_ais();
	
	a_street_ais = GetAIArray( "axis" );
	
	// wait until there is no more enemy to kill
	while ( a_street_ais.size > 0 )
	{
		n_distance_y = 10000;
		
		// goes through each enemy and find the closest one to Harper
		foreach ( ai_street in a_street_ais )
		{
			n_distance_from_harper_y = ai_street.origin[1] - self.origin[1];
			
			if ( n_distance_from_harper_y < n_distance_y )
			{
				n_distance_y = n_distance_from_harper_y;
				ai_to_kill = ai_street;
			}
		}
		
		ai_to_kill thread waittill_health_zero_or_below(); // HACK: stop harper from shooting this AI if his health is zero or below (for a progression break)
		self GetPerfectInfo( ai_to_kill );
		self shoot_at_target_untill_dead( ai_to_kill );
		
		a_street_ais = array_removeDead( a_street_ais );
		
		wait 0.05;
	}
	
	level notify( "street_cleared" );
}

waittill_health_zero_or_below()
{
	self endon( "death" );
	
	while ( self.health > 0 )
	{
		wait 0.05;
	}
	
	/#
	IPrintLnBold( "this broke" );
	#/
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper stop_shoot_at_target();
}

street_move_remaining_ais()
{
	a_street_ais = GetAIArray( "axis" );
	foreach ( ai_street in a_street_ais )
	{
		if ( ai_street.weapon != "dsr50_sp" )
		{
			ai_street thread street_move_remaining_ai();
		}
	}
}

// self == enemy ai
street_move_remaining_ai()
{
	self endon( "death" );
	
	if ( !self is_rusher() )
	{
		e_street_volume = GetEnt( "street_volume", "targetname" );
		self SetGoalVolumeAuto( e_street_volume );
	}
}

street_ais()
{
	level thread street_ambush();
	level thread street_juggernauts_and_bdogs();
	level thread street_snipers();
	level thread street_train_surprise();
	level thread street_others();
	
	level thread street_rushers();
}

street_ambush()
{	
	a_street_ambush_outside = GetEntArray( "street_ambush_outside", "targetname" );	
	array_thread( a_street_ambush_outside, ::add_spawn_function, ::steet_ambush_outside_spawn_func );
	
	a_street_ambush_back = GetEntArray( "street_ambush_back", "targetname" );	
	array_thread( a_street_ambush_back, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_street_ambush_inside = GetEntArray( "street_ambush_inside", "targetname" );
	array_thread( a_street_ambush_inside, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	// TODO: comment out to have no enemy on street
	level thread spawn_manager_enable( "sm_street_ambush_outside" );
	level thread spawn_manager_enable( "sm_street_ambush_back" );
	
	level waittill( "street_battle_started" );
	
	spawn_manager_enable( "sm_street_ambush_inside" );
}

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

shoot_at_goal( str_target )
{
	self endon( "death" );
	
	self waittill( "goal" );
	
	if ( str_target == "player" )
	{
		self shoot_at_target( level.player, undefined, undefined, -1 );
	}
	else
	{
		e_target = GetEnt( str_target, "targetname" );
		self shoot_at_target( e_target, undefined, undefined, -1 );
	}
}

street_juggernauts_and_bdogs()
{	
	street_bdog_in = GetEnt( "bdog_back", "targetname" );
	street_bdog_in add_spawn_function( ::street_bdog_back, true );
	
	street_bdog_middle = GetEnt( "bdog_front", "targetname" );
	street_bdog_middle add_spawn_function( ::street_bdog_front, true );
	
//	trigger_off( "t_clear_the_street", "targetname" );
//	
//	scene_wait( "cougar_exit_player" );
//	
//	trigger_on( "t_clear_the_street", "targetname" );
}

// self == bdog
street_bdog_front( takes_in_route )
{
	self endon( "death" );
	
	self change_movemode( "sprint" );
	
	wait 0.5; // needs to wait a frame before the below info can be set properly
	
	nd_street_middle = GetNode( "street_middle", "targetname" );
	self SetGoalPos( nd_street_middle.origin );
	
	self SetEngagementMinDist( 350, 300 );
	self SetEngagementMaxDist( 750, 1100 );

//	if ( self.targetname != "bdog_middle_ai" )
//	{
//		self.pathenemyfightdist = 0;
//		self.pathenemylookahead = 0;
//		self.goalradius = 16;
//	}
	
	e_bdog_back_volume = GetEnt( "bdog_cover_back_volume", "targetname" );
	e_bdog_front_volume = GetEnt( "bdog_cover_front_volume", "targetname" );
	t_cover_front = GetEnt( "bdog_cover_front", "targetname" );
	b_protect_back = true;
	
	while ( true )
	{
		if ( !b_protect_back )
		{
			if ( !( level.player IsTouching( t_cover_front ) ) )
			{
				self SetGoalVolumeAuto( e_bdog_back_volume );
				b_protect_back = true;
				
				self.goalradius = 16;
				self waittill_notify_or_timeout( "goal", 3 );
				
				self.goalradius = 2048;
			}
		}
		else
		{
			if ( level.player IsTouching( t_cover_front ) ) 
			{
				self SetGoalVolumeAuto( e_bdog_front_volume );
				b_protect_back = false;
				
				self.goalradius = 16;
				self waittill_notify_or_timeout( "goal", 2 );
				
				self.goalradius = 2048;
			}
		}
		
		wait 0.05;
	}
}

// self == bdog
street_bdog_back( takes_in_route )
{
	self endon( "death" );
	
	self change_movemode( "sprint" );
	
	wait 0.5; // needs to wait a frame before the below info can be set properly
	
	nd_street_middle = GetNode( "street_middle", "targetname" );
	self SetGoalPos( nd_street_middle.origin );
	
	self SetEngagementMinDist( 250, 50 );
	self SetEngagementMaxDist( 750, 1100 );
	
	e_bdog_back_volume = GetEnt( "bdog_cover_back_volume", "targetname" );
	e_bdog_in_volume = GetEnt( "bdog_cover_in_volume", "targetname" );
	t_cover_in = GetEnt( "bdog_cover_in", "targetname" );
	b_protect_back = true;
	
	while ( true )
	{
		if ( !b_protect_back )
		{
			if ( !( level.player IsTouching( t_cover_in ) ) )
			{
				self SetGoalVolumeAuto( e_bdog_back_volume );
				b_protect_back = true;
				
				self.goalradius = 16;
				self waittill_notify_or_timeout( "goal", 3 );
				
				self.goalradius = 2048;
			}
		}
		else
		{
			if ( level.player IsTouching( t_cover_in ) ) 
			{
				self SetGoalVolumeAuto( e_bdog_in_volume );
				b_protect_back = false;
				
				self.goalradius = 16;
				self waittill_notify_or_timeout( "goal", 2 );
				
				self.goalradius = 2048;
			}
		}
		
		wait 0.05;
	}
}

street_snipers()
{	
	trigger_wait( "sm_street_back" );
	
//	run_scene( "climb_on_top_train" );
	simple_spawn_single( "street_snipers" );
}

street_train_surprise()
{
	t_sm_street_back = GetEnt( "sm_street_back", "targetname" );
	t_sm_street_back endon( "trigger" );
	
	trigger_wait( "trig_street_train_surprise" );
	
	run_scene( "train_surprise_attack" );
}

street_others()
{
	a_street_inside = GetEntArray( "street_inside", "targetname" );	
	array_thread( a_street_inside, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_street_back = GetEntArray( "street_back", "targetname" );	
	array_thread( a_street_back, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_street_train_inside = GetEntArray( "street_train_inside", "targetname" );
	array_thread( a_street_train_inside, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	// TODO: uncomment out to have no enemy on street
//	trigger_off( "sm_street_inside", "targetname" );
//	trigger_off( "sm_street_back", "targetname" );
//	trigger_off( "sm_street_train_inside", "targetname" );
	
	trigger_off( "street_test", "targetname" ); // TODO: leave this uncomment unless you want 29 enemies spawning
}

street_rushers()
{
	level endon( "street_cleared" );
	
	level waittill( "street_battle_started" );
	
	v_player_origin_prev = level.player.origin;
	
	while ( true )
	{
		wait 3;
		
		v_player_origin_cur = level.player.origin;
		v_player_prev_min_x = v_player_origin_prev + (-64, 0, 0);
		v_player_prev_max_x = v_player_origin_prev + (64, 0, 0);
		v_player_prev_min_y = v_player_origin_prev + (0, -64, 0);
		v_player_prev_max_y = v_player_origin_prev + (0, 64, 0);
		v_player_prev_min_z = v_player_origin_prev + (0, 0, -64);
		v_player_prev_max_z = v_player_origin_prev + (0, 0, 64);
		
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
		
		foreach ( ai_potential_rusher in a_rushers )
		{
			if ( ai_potential_rusher.origin[2] < 100 )
			{
				n_dist_sq_between = DistanceSquared( level.player.origin, ai_potential_rusher.origin );
				
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

hunt_down_player()
{	
	self maps\_rusher::rush();
	
	self waittill( "death" );
}

enemy_on_top_of_metro()
{
	level endon( "street_bdogs_killed" );
	
	trigger_wait( "color_street_start_out" );
	
	ai_climber = simple_spawn_single( "street_traverse_first" );
	ai_climber first_metro_climber();
	
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
	
	a_enemy_ais = array_removeundefined( a_enemy_ais );
	
	if ( a_enemy_ais.size > 0 )
	{
		n_dist_sq_longest = DistanceSquared( level.player.origin, a_enemy_ais[0].origin );
		ai_climber = a_enemy_ais[0];
		
		foreach ( ai_potential_climber in a_enemy_ais )
		{
			if ( ai_potential_climber.origin[2] < 100 )
			{
				n_dist_sq_between = DistanceSquared( level.player.origin, ai_potential_climber.origin );
				
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

move_on_top_of_metro()
{
	self endon( "death" );
	
	n_old_goalradius = self.goalradius;
	self.goalradius = 128;
	
	n_random = RandomInt( 2 );
	
	while ( n_random < 3 )
	{
		nd_metro_top = GetNode( "metro_top_" + n_random, "targetname" );
		self SetGoalNode( nd_metro_top );
		
		self waittill( "goal" );
		
		wait 6;
		
		n_random = RandomIntRange( n_random + 1, 4 );
	}
	
	nd_metro_finish = GetNode( "metro_finish", "targetname" );
	self SetGoalNode( nd_metro_finish );
	
	self waittill( "goal" );
	
	self.goalradius = n_old_goalradius;
}

street_elec_on_ground()
{
	level endon( "event_6_done" );
	
	a_elec_sparks = getstructarray( "elec_sparks", "targetname" );

	foreach ( s_elec_spark in a_elec_sparks )
	{
		PlayFX( level._effect[ "elec_spark" ], s_elec_spark.origin );
	}
	
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

cougar_exit()
{	
	fade_to_black( 0 );
	level thread fade_with_shellshock_and_visionset();
	
	setmusicstate ("LA_1B_STREET");
	
	// disable 'get to cover' message
	level.enable_cover_warning = false;
	
//	level.player waittill( "weapon_change" );
//	str_weapon_model = GetWeaponModel( level.player GetCurrentWeapon() );
	
	level thread cougar_exit_player();
	level thread cougar_exit_friendlies();
	cougar_exit_everything_else();
	
	// enable 'get to cover' message
	level.enable_cover_warning = true;
	
	trigger_use( "spawn_bdog_middle" );
}

cougar_exit_player()
{	
	level.player PlaySound("evt_cougar_exit");
	
	level thread run_scene( "cougar_exit_player" );
	flag_wait( "cougar_exit_player_started" );
	
	wait 7;
	playsoundatposition ("evt_la_1_convoy_escort_driveby", (0,0,0));
	
	level thread play_bink_on_hud_glasses( "eye_v2" );
	
	wait 18;
	playsoundatposition ("evt_la_1_police_drive_up", (0,0,0));
	
	autosave_by_name( "street_start" );
	trigger_use( "street_cop_car_entry" );
	
	wait 1;
	
	init_hero( "street_cop_1" );
	init_hero( "street_cop_2" );
	
	ai_cop_1 = GetEnt( "ce_cop_1_ai", "targetname" );
	ai_cop_2 = GetEnt( "ce_cop_2_ai", "targetname" );
	ai_bdog = GetEnt( "bdog_cougar_exit_ai", "targetname" );
	
	if ( IsAlive( ai_cop_1 ) )
	{
		ai_bdog shoot_at_target_untill_dead( ai_cop_1 );
	}
	
	if ( IsAlive( ai_cop_2 ) )
	{
		ai_bdog shoot_at_target_untill_dead( ai_cop_2 );
	}

	if ( IsAlive( ai_bdog ) )
	{
		ai_bdog set_ignoreall( true );
	}
//	m_player = get_model_or_models_from_scene( "cougar_exit_player", "player_body" );
//	m_player Attach( str_weapon_model, "tag_weapon" );
}

cougar_exit_friendlies()
{
//	level thread run_scene( "cougar_exit_driver" );
//	flag_wait( "cougar_exit_driver_started" );
//	
//	ai_driver = GetEnt( "driver_cougar_exit_ai", "targetname" );
//	ai_driver.a.pose = "back";
//	ai_driver endon( "death" );
	
	//scene_wait( "cougar_exit_driver" );
	
//	level thread run_scene( "cougar_exit_driver_loop" );
//	flag_wait( "cougar_exit_driver_loop_started" );

	level thread run_scene( "cougar_exit_cop_vh" );
	run_scene( "cougar_exit_friendlies" );
//	level thread run_scene( "cougar_exit_cop_car" );
}

cougar_exit_everything_else()
{
	level endon( "la_street_done" );
	
	level thread run_scene( "cougar_exit" );
	flag_wait( "cougar_exit_started" );
	
	m_cougar_interior = get_model_or_models_from_scene( "cougar_exit", "interior_cougar_exit" );
	m_cougar_interior Attach( "veh_t6_mil_cougar" );
	
	vh_f35_cougar_exit = get_model_or_models_from_scene( "cougar_exit", "f35_cougar_exit" );
	vh_f35_cougar_exit veh_magic_bullet_shield( true );
    
    ai_roofter = GetEnt( "ambush_cougar_exit_bottom_ai", "targetname" );
    ai_roofter.overrideActorDamage = ::roofter_damage_override; // damage override because animation has ragdoll
    
    ai_bdog = GetEnt( "bdog_cougar_exit_ai", "targetname" );
    if ( IsAlive( ai_bdog ) )
	{
    	ai_bdog set_ignoreall( true );
    }
	
	scene_wait( "cougar_exit" );
	
	ai_bdog.a.noDeathAnim = true;
	ai_bdog.allowdeath = true;
	ai_bdog DoDamage( ai_bdog.health + 1, ai_bdog.origin, level.player, -1, "melee" );
	
	//SOUND =- Shawn J
	// TODO ai_bdog playsound ("mycoolsound");
	ai_bdog notify( "claw_cntxt" );
//	ai_driver = GetEnt( "driver_cougar_exit_ai", "targetname" );
//	if ( IsAlive( ai_driver ) )
//	{
//		ai_harper = GetEnt( "harper_ai", "targetname" );
//		ai_harper shoot_at_target_untill_dead( ai_driver );
//	}
	
	if ( IsAlive( ai_roofter ) )
	{
		ai_roofter Delete();
	}
}

roofter_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	n_damage = 0;
	
	return n_damage;
}

clear_the_street()
{
	trigger_wait( "t_clear_the_street" );
	
//	level thread run_scene( "clear_the_street_bdog_1" );
//	level thread run_scene( "clear_the_street_ter" );
	run_scene( "clear_the_street" );
}

brute_force()
{	
	level endon( "event_6_done" );
	
	level.player waittill_player_has_brute_force_perk();
	
	level thread brute_force_intro_vo();
	level thread brute_force_obj();
	level thread brute_force_use();
	level thread brute_force_fail();
}

brute_force_obj()
{
	t_brute_force_radius = GetEnt( "t_brute_force_radius", "targetname" );
	
	s_brute_force_pos = getstruct( "brute_force_use_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_brute_force_pos.origin, "interact" );
}

brute_force_intro_vo()
{
	level endon( "brute_force_fail" );
	level endon( "brute_force_done" );
	
	flag_wait( "brute_force_vo_can_play" );
	
	level.player say_dialog( "septic_were_hit_001" );
	level.player say_dialog( "the_convoy_was_hit_002" );
	level.player say_dialog( "our_iav_is_on_fire_003" );
}

brute_force_helping_vo()
{
	level.player say_dialog( "on_our_way_004" );
	level.player say_dialog( "septic_thank_go_005" );
	level.player say_dialog( "grab_a_rifle_h_we_006" );
}

brute_force_use()
{
	level endon( "brute_force_fail" );
	
	a_ssa_brute_force = GetEntArray( "ssa_brute_force", "script_noteworthy" );	
	array_thread( a_ssa_brute_force, ::add_spawn_function, ::magic_bullet_shield );
	
	trigger_wait( "t_brute_force_use" );
	
	brute_force_remove();
	
	level notify( "brute_force_done" );
	
	level thread brute_force_helping_vo();
	brute_force_animation();
}

brute_force_remove()
{
	s_brute_force_pos = getstruct( "brute_force_use_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_brute_force_pos, "remove" );
	
	t_brute_force_use = GetEnt( "t_brute_force_use", "targetname" );
	t_brute_force_use Delete();
}

brute_force_animation()
{
	m_brute_force_rubble = GetEnt( "bruteforce_rubble_model", "targetname" );
	m_brute_force_cougar = GetEnt( "bruteforce_cougar", "targetname" );
	
	run_scene( "brute_force" );
}

brute_force_fail()
{
	level endon( "brute_force_done" );
	
	trigger_wait( "brute_force_fail" );
	
	brute_force_remove();
	
	m_brute_force_cougar = GetEnt( "bruteforce_cougar", "targetname" );
	m_brute_force_cougar SetModel( "veh_t6_mil_cougar_dead" );
	m_brute_force_cougar PlaySound( "exp_armor_vehicle" );
	PlayFXOnTag( level._effect[ "brute_force_explosion" ], m_brute_force_cougar, "tag_origin" );
	
	level notify( "brute_force_fail" );
}

delete_vehicle_on_notify( str_notify )
{
	self endon( "death" );
	
	self waittill( str_notify );
	
	self Delete();
}

fxanim_debris()
{
	trigger_wait( "fxanim_debris_1" );
	
	level notify( "fxanim_debris_layer_1_start" );
	
	trigger_wait( "fxanim_debris_2" );
	
	level notify( "fxanim_debris_layer_2_start" );
	
	wait 1;
	
	level notify( "fxanim_debris_layer_3_start" );
	
	trigger_wait( "t_street_done" );
	
	level notify( "fxanim_drone_chunks_start" );
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
	level.player.overridePlayerDamage = ::drone_player_damage_override;
	
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
	n_damage = n_damage * 2;
	
	return n_damage;
}

hotel_visionset()
{
	//fog settings to blend into when skybox changes (driving section)
	const start_dist = 407.599;
	const half_height = 2000.28;
	const base_height = 118.875;
	const fog_r = 0.42;
	const fog_g = 0.5;
	const fog_b = 0.5;
	const fog_scale = 13.3861;
	const sun_col_r = 0.917647;
	const sun_col_g = 0.733333;
	const sun_col_b = 0.423529;
	const sun_dir_x = 0.476913;
	const sun_dir_y = 0.645584;
	const sun_dir_z = 0.596469;
	const sun_start_ang = 0;
	const sun_stop_ang = 68.812;
	const max_fog_opacity = 1;
	const time = 0.5;
	half_dist = 6863.42;

	e_hotel_visionset_vol = GetEnt( "hotel_visionset_vol", "targetname" );
	b_already_set = false;
	
	while ( true )
	{
		if ( level.player IsTouching( e_hotel_visionset_vol ) )
		{
			if ( !b_already_set )
			{
				prev_visionset = level.player GetVisionSetNaked();
				level.player VisionSetNaked( "la1b_lobby", 0.5 );
				
				half_dist = 12000;
				SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
					sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
					sun_stop_ang, time, max_fog_opacity);
				
				b_already_set = true;
			}
		}
		else
		{
			if ( b_already_set )
			{
				level.player VisionSetNaked( prev_visionset, 0.5 );
				
				half_dist = 6863.42;
				SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
					sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
					sun_stop_ang, time, max_fog_opacity);
				
				b_already_set = false;
			}
		}
		
		wait 0.05;
	}
}