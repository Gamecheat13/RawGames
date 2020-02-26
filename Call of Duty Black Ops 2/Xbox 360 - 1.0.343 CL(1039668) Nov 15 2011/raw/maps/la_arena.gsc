#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_juggernaut;
#include maps\_objectives;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\la_utility;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//skipto_intersection()
//{
//	start_teleport( "skipto_intersection" );
//	
//	exploder( 56 );
//	exploder( 57 );
//	exploder( 58 );
//	exploder( 59 );
//	
//	vh_sam_cougar = spawn_vehicle_from_targetname( "intersect_sam_cougar" );
//	vh_sam_cougar veh_magic_bullet_shield( true );
//	
//	maps\la_plaza::sam_cougar_animation();
//	
//	level thread maps\la_plaza::plaza_and_intersect_transition();
//	
//	maps\la_plaza::interception_animations();
//	
//	flag_wait( "event_6_done" );
//}

skipto_arena()
{
	init_hero( "harper" );
	start_teleport( "skipto_arena" );
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	trigger_use( "arena_start" );
	
	set_objective( level.OBJ_STREET_REGROUP );
}

skipto_arena_exit()
{
	init_hero( "harper" );
	start_teleport( "skipto_arena_exit" );
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	flag_set( "g20_group1_dead" );
	flag_set( "intersect_vip_cougar_died" );
	
	level.b_arena_exit_start = true;
	
	set_objective( level.OBJ_STREET_REGROUP );
}

main()
{
	flag_set( "la_arena_start" );
		
	init_hero( "harper" );

	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	if ( !IsDefined( level.b_arena_exit_start ) )
	{
		level thread spawn_aerial_vehicles( 45, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
		level thread fxanim_aerial_vehicles( 23 );
	}
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper.script_ignore_suppression = 1;
	
	vh_f35_anderson = spawn_vehicle_from_targetname( "f35_anderson" );
	vh_f35_anderson thread anderson_f35_logic();
	
//	vh_down_drone = spawn_vehicle_from_targetname( "sam_crashed_drone" );
//	vh_down_drone thread sam_down_drone_logic();
//	
//	vh_intruder_sam = spawn_vehicle_from_targetname( "intruder_sam" );
	
	level thread arena_objectives();
	level thread arena_vo();
	level thread arena_ais();
	//level thread spawn_outside_enemies();
	//level thread arena_bdog_teleport_logic();
	
	//level thread drop_walkway();
	//level thread arena_lights();
	
	//level thread arena_specialties();
	level thread lock_breaker();	
	
	la_1_ending();
	//level thread collapse_building();
}

arena_objectives()
{
	set_objective( level.OBJ_ARENA );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	set_objective( level.OBJ_FOLLOW, ai_harper, "follow" );
	
//	trigger_wait( "arena_move_up_2", "targetname" );
	trigger_wait( "la_1_ending", "script_noteworthy" );
	
	set_objective( level.OBJ_FOLLOW, undefined, "delete" );
	
	e_anderson_pos = getstruct( "obj_anderson", "targetname" );
	set_objective( level.OBJ_ANDERSON, e_anderson_pos.origin, &"LA_SHARED_OBJ_ANDERSON" );
	
	flag_wait( "ending_dog_fight_started" );
	
	set_objective( level.OBJ_ANDERSON, undefined, "delete" );
}

arena_vo()
{
	if ( !IsDefined( level.b_arena_exit_start ) )
	{
		level.player say_dialog( "septic__009" );
		level.player say_dialog( "anderson_you_oka_010" );
		level.player say_dialog( "im_on_ground_h_no_011" );
		level.player say_dialog( "were_on_our_way_012" );
	
		trigger_wait( "arena_move_up_1" );
	
		level.player say_dialog( "septic_i_took_h_013" );
		level.player say_dialog( "how_bad_014" );
		level.player say_dialog( "im_bleeding_out_015" );
		level.player say_dialog( "hold_on_anderson_016" );
	
		trigger_wait( "arena_move_up_2" );
	}
	
	level.player say_dialog( "anderson_you_o_017" );
	level.player say_dialog( "theyre_all_over_m_018" );
	level.player say_dialog( "stay_with_me_ande_019" );
}

arena_specialties()
{
	trigger_wait( "arena_perk_start" );
	
	level thread lock_breaker();	
	level thread intruder();
}

arena_ai_logic()
{
	if ( IS_TRUE( level.is_sonar_on ) )
	{
		self.grenadeWeapon = "frag_grenade_sonar_sp";
	}
	
	self force_goal( undefined, 16, true );
}

arena_ais()
{
	a_arena_inside_0 = GetEntArray( "arena_inside_0", "targetname" );
	array_thread( a_arena_inside_0, ::add_spawn_function, ::arena_ai_logic );
	
	a_arena_inside_1 = GetEntArray( "arena_inside_1", "targetname" );
	array_thread( a_arena_inside_1, ::add_spawn_function, ::arena_ai_logic );
	
	a_arena_inside_2 = GetEntArray( "arena_inside_2", "targetname" );
	array_thread( a_arena_inside_2, ::add_spawn_function, ::arena_ai_logic );
	
	a_arena_middle_1 = GetEntArray( "arena_middle_1", "targetname" );
	array_thread( a_arena_middle_1, ::add_spawn_function, ::arena_ai_logic );
	
	a_arena_outside_pre_0 = GetEntArray( "arena_outside_pre_0", "targetname" );
	array_thread( a_arena_outside_pre_0, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_arena_outside_0 = GetEntArray( "arena_outside_0", "targetname" );
	array_thread( a_arena_outside_0, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_arena_outside_1 = GetEntArray( "arena_outside_1", "targetname" );
	array_thread( a_arena_outside_1, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_arena_outside_2 = GetEntArray( "arena_outside_2", "targetname" );
	//array_thread( a_arena_outside_2, ::add_spawn_function, ::force_goal, undefined, 16, true );
	array_thread( a_arena_outside_2, ::add_spawn_function, ::shoot_at_statue );
	
	a_possible_targets = GetEntArray( "possible_target", "script_noteworthy" );
	array_thread( a_possible_targets, ::add_spawn_function, ::ending_magic );
	
	a_arena_end_0 = GetEntArray( "arena_end_0", "targetname" );
	//array_thread( a_arena_end_0, ::add_spawn_function, ::shoot_at_target, GetEnt( "anderson_ai", "targetname" ), undefined, undefined, -1 );
	
	a_arena_inside_guards_0 = GetEntArray( "arena_inside_guards_0", "targetname" );
	array_thread( a_arena_inside_guards_0, ::add_spawn_function, ::arena_juggernauts, "arena_inside_bdog_0_ai" );
	
	a_arena_inside_guards_1 = GetEntArray( "arena_inside_guards_1", "targetname" );
	array_thread( a_arena_inside_guards_1, ::add_spawn_function, ::arena_juggernauts, "arena_inside_bdog_1_ai" );
	
	a_arena_middle_guards = GetEntArray( "arena_guards", "targetname" );
	array_thread( a_arena_middle_guards, ::add_spawn_function, ::arena_juggernauts, "arena_bdog_ai" );
	
	a_arena_outside_guards = GetEntArray( "arena_outside_guards_0", "targetname" );
	array_thread( a_arena_outside_guards, ::add_spawn_function, ::arena_juggernauts, "arena_outside_bdog_0_ai" );
	
	a_arena_end_guards_0 = GetEntArray( "arena_end_guards_0", "targetname" );
	array_thread( a_arena_end_guards_0, ::add_spawn_function, ::arena_juggernauts, "arena_end_bdog_0_ai" );
	
	sp_inside_bdog_0 = GetEnt( "arena_inside_bdog_0", "targetname" );
	sp_inside_bdog_0 add_spawn_function( ::arena_bdog );
	
	sp_inside_bdog_1 = GetEnt( "arena_inside_bdog_1", "targetname" );
	sp_inside_bdog_1 add_spawn_function( ::arena_bdog );
	
	sp_middle_bdog = GetEnt( "arena_bdog", "targetname" );
	sp_middle_bdog add_spawn_function( ::arena_bdog );
	
	sp_outside_bdog = GetEnt( "arena_outside_bdog_0", "targetname" );
	sp_outside_bdog add_spawn_function( ::arena_bdog );
	
	sp_end_bdog_0 = GetEnt( "arena_end_bdog_0", "targetname" );
	sp_end_bdog_0 add_spawn_function( ::ending_bdog );
	
	level thread run_away_inside();
	level thread run_away_outside();
}

arena_bdog_teleport_logic()
{
	//level thread teleport_bdog_0();
	level thread teleport_bdog_middle();

	determine_which_path();
	
	level thread teleport_bdog_in();
	level thread teleport_bdog_out();
}

determine_which_path()
{
	trigger_wait( "sm_arena_inside_guards_1" );
	
	waittill_bdog_and_guards_spawned();
	
	level thread player_going_inside();
	level thread player_going_outside();
	
	level waittill( "path_determined" );
}

waittill_bdog_and_guards_spawned()
{
	while ( !is_spawn_manager_complete( "sm_arena_inside_bdog_1" ) )
	{
		wait 0.05;
	}
	
	while ( !is_spawn_manager_complete( "sm_arena_inside_guards_1" ) )
	{
		wait 0.05;
	}
}

player_going_inside()
{
	level endon( "path_determined" );
	
	trigger_wait( "player_going_in" );
	
	level.is_player_inside_arena = true;
	
	level notify( "path_determined" );
}

player_going_outside()
{
	level endon( "path_determined" );
	
	s_teleport_bdog = getstruct( "teleport_bdog_1_out", "targetname" );
	a_teleport_guards = getstructarray( "teleport_guards_1_out", "targetname" );
	
	trigger_wait( "player_going_out" );
	
	ai_bdog = GetEnt( "arena_inside_bdog_1_ai", "targetname" );
	if ( IsAlive( ai_bdog ) )
	{
		ai_bdog Teleport( s_teleport_bdog.origin, s_teleport_bdog.angles );
	}
		
	a_guards = GetEntArray( "arena_inside_guards_1_ai", "targetname" );
	for ( i = 0; i < a_guards.size; i++ )
	{
		a_guards[i] Teleport( a_teleport_guards[i].origin, a_teleport_guards[i].angles );
	}
	
	level.is_player_inside_arena = false;
	
	level notify( "path_determined" );
}

teleport_bdog_0()
{
	s_teleport_bdog_0 = getstruct( "teleport_bdog_0", "targetname" );
	a_teleport_guards_0 = getstructarray( "teleport_guards_0", "targetname" );
	
	n_player_fov = GetDvarFloat( "cg_fov" );
	n_cos_player_fov = cos( n_player_fov );
	a_teleport_pos = a_teleport_guards_0;
	ARRAY_ADD( a_teleport_pos, s_teleport_bdog_0 );
	
	level thread teleport_bdog_0_alt();
	
	trigger_wait( "sm_arena_outside_2" );
	
	level notify( "bdog_0_teleported" );
	
	ai_bdog_0 = GetEnt( "arena_inside_bdog_0_ai", "targetname" );
	if ( IsAlive( ai_bdog_0 ) )
	{	
		wait_to_teleport( a_teleport_pos, n_cos_player_fov );
		
		ai_bdog_0 forceteleport( s_teleport_bdog_0.origin, s_teleport_bdog_0.angles );
	}
	
	a_guards_0 = GetEntArray( "arena_inside_guards_0_ai", "targetname" );
	for ( i = 0; i < a_guards_0.size; i++ )
	{
		wait_to_teleport( a_teleport_pos, n_cos_player_fov );
		
		a_guards_0[i] forceteleport( a_teleport_guards_0[i].origin, a_teleport_guards_0[i].angles );
	}
}

wait_to_teleport( a_teleport_pos, n_cos_player_fov )
{
	a_results = [];
	ARRAY_ADD( a_results, within_fov( level.player.origin, level.player.angles, a_teleport_pos[0].origin, n_cos_player_fov ) );
	ARRAY_ADD( a_results, within_fov( level.player.origin, level.player.angles, a_teleport_pos[1].origin, n_cos_player_fov ) );
	ARRAY_ADD( a_results, within_fov( level.player.origin, level.player.angles, a_teleport_pos[2].origin, n_cos_player_fov ) );
	
	while ( a_results[0] || a_results[1] || a_results[2] )
	{
		wait 0.05;
		
		a_results[0] = within_fov( level.player.origin, level.player.angles, a_teleport_pos[0].origin, n_cos_player_fov );
		a_results[1] = within_fov( level.player.origin, level.player.angles, a_teleport_pos[1].origin, n_cos_player_fov );
		a_results[2] = within_fov( level.player.origin, level.player.angles, a_teleport_pos[2].origin, n_cos_player_fov );
	}
}

teleport_bdog_0_alt()
{
	level endon( "bdog_0_teleported" );
	
	trigger_wait( "player_going_out" );
	
	wait 3;
	
	trigger_use( "sm_arena_outside_2" );
}

teleport_bdog_in()
{	
	s_teleport_bdog = getstruct( "teleport_bdog_1_in", "targetname" );
	a_teleport_guards = getstructarray( "teleport_guards_1_in", "targetname" );
	
	while ( true )
	{
		if ( !level.is_player_inside_arena )
		{
			trigger_wait( "player_going_in" );
	
			ai_bdog = GetEnt( "arena_inside_bdog_1_ai", "targetname" );
			if ( IsAlive( ai_bdog ) )
			{
				ai_bdog Teleport( s_teleport_bdog.origin, s_teleport_bdog.angles );
			}
		
			a_guards = GetEntArray( "arena_inside_guards_1_ai", "targetname" );
			for ( i = 0; i < a_guards.size; i++ )
			{
				a_guards[i] Teleport( a_teleport_guards[i].origin, a_teleport_guards[i].angles );
			}
			
			level.is_player_inside_arena = true;
		}
		
		wait 0.05;
	}
}

teleport_bdog_out()
{	
	s_teleport_bdog = getstruct( "teleport_bdog_1_out", "targetname" );
	a_teleport_guards = getstructarray( "teleport_guards_1_out", "targetname" );
	
	while ( true )
	{
		if ( level.is_player_inside_arena )
		{
			trigger_wait( "player_going_out" );
	
			ai_bdog = GetEnt( "arena_inside_bdog_1_ai", "targetname" );
			if ( IsAlive( ai_bdog ) )
			{
				ai_bdog Teleport( s_teleport_bdog.origin, s_teleport_bdog.angles );
			}
		
			a_guards = GetEntArray( "arena_inside_guards_1_ai", "targetname" );
			for ( i = 0; i < a_guards.size; i++ )
			{
				a_guards[i] Teleport( a_teleport_guards[i].origin, a_teleport_guards[i].angles );
			}
			
			level.is_player_inside_arena = false;
		}
		
		wait 0.05;
	}
}

teleport_bdog_middle()
{
	s_teleport_bdog = getstruct( "teleport_bdog_2", "targetname" );
	a_teleport_guards = getstructarray( "teleport_guards_2", "targetname" );
	level.can_middle_bdog_reset = true;
	level thread waittill_middle_bdog_can_be_reset();
	
	while ( true )
	{
		if ( level.can_middle_bdog_reset )
		{
			trigger_wait( "reset_middle_bdog" );
	
			ai_bdog = GetEnt( "arena_bdog_ai", "targetname" );
			if ( IsAlive( ai_bdog ) )
			{
				ai_bdog Teleport( s_teleport_bdog.origin, s_teleport_bdog.angles );
				ai_bdog thread middle_bdog_find_player();
			}
		
			a_guards = GetEntArray( "arena_guards_ai", "targetname" );
			for ( i = 0; i < a_guards.size; i++ )
			{
				a_guards[i] Teleport( a_teleport_guards[i].origin, a_teleport_guards[i].angles );
			}
			
			level.can_middle_bdog_reset = false;
		}
		
		wait 0.05;
	}
}

middle_bdog_find_player()
{
	self endon( "death" );
	
	self.goalradius = 16;
	self set_goal_ent( level.player );
	self GetPerfectInfo( level.player );
		
	wait 3;
		
	self.goalradius = 2048;
}

waittill_middle_bdog_can_be_reset()
{
	while ( true )
	{
		if ( !level.can_middle_bdog_reset )
		{
			trigger_wait( "middle_bdog_can_reset" );
			
			level.can_middle_bdog_reset = true;
		}
		
		wait 0.05;
	}
}

arena_lights()
{
	a_light_fx_origins = [];
	a_arena_light_fx = getstructarray( "arena_light_fx", "targetname" );
	
	//level.player SetClientDvars( "r_exposureTweak", 1, "r_exposureValue", 0.5 );
	
	foreach ( s_light_fx in a_arena_light_fx )
	{
		e_light_fx_origin = spawn_model( "tag_origin", s_light_fx.origin, s_light_fx.angles );
		ARRAY_ADD( a_light_fx_origins, e_light_fx_origin );
		PlayFXOnTag( level._effect[ "arena_light" ], e_light_fx_origin, "tag_origin" );
	}
	
	while ( !level.player ButtonPressed( "DPAD_UP" ) )
	{
		wait 0.05;
	}
	
	//IPrintLnBold( "lights turned off" );
	
	foreach ( e_light_fx in a_light_fx_origins )
	{
		e_light_fx Delete();
	}
	
	a_arena_lights_dynamic = GetEntArray( "staple_off", "targetname" );
	foreach ( e_light_dynamic in a_arena_lights_dynamic )
	{
		e_light_dynamic SetLightIntensity( 0 );
	}
}

lock_breaker()
{	
//	trigger_wait( "arena_perk_start" );
//	
//	if( !level.player HasPerk( "specialty_trespasser" ) )
//	{
//		return;
//	}
	
	level.player waittill_player_has_lock_breaker_perk();
	
	//level.n_lock_breakers = 3;
	//set_objective( level.OBJ_INTERACT, undefined, undefined, level.n_lock_breakers );
	
	level thread lock_breaker_animation( 1 );
	//level thread lock_breaker_animation( 2 );
	//level thread lock_breaker_animation( 3 );
}

lock_breaker_animation( n_concession )
{
//	s_lock_breaker_pos = getstruct( "concession_obj_" + n_concession, "targetname" );
//	set_objective( level.OBJ_INTERACT, s_lock_breaker_pos, "interact", -1 );
	s_lock_breaker_pos = getstruct( "concession_obj_1", "targetname" );
	set_objective( level.OBJ_INTERACT, s_lock_breaker_pos.origin, "interact" );
	
	level thread can_use_sonar( n_concession );
	
	trigger_wait( "concession_use_" + n_concession );
	
	//level.n_lock_breakers--;
	
	set_objective( level.OBJ_INTERACT, s_lock_breaker_pos, "remove" );
//	set_objective( level.OBJ_INTERACT, undefined, undefined, level.n_lock_breakers );
	
	t_lock_breaker_use = GetEnt( "concession_use_" + n_concession, "targetname" );
	t_lock_breaker_use Delete();
	
	add_scene_properties( "lock_breaker", "anim_align_concession_" + n_concession );
	run_scene( "lock_breaker" );
	
	a_concession_doors = GetEntArray( "concession_door_1", "targetname" );
	foreach ( m_door in a_concession_doors )
	{
		m_door Delete();
	}
}

can_use_sonar( n_concession )
{
	level endon( "sonar_is_on" );
	
	//level waittill( "can_use_sonar_" + n_concession );
	trigger_wait( "light_" + n_concession );
	
	level.is_sonar_on = true;
	
	e_concession_light = GetEnt( "lights_off", "targetname" );
	e_concession_light SetLightIntensity( 0 );
	
	n_grenade_count = level.player GetWeaponAmmoClip( "frag_grenade_sp" );
	level.player TakeWeapon( "frag_grenade_sp" );
	level.player GiveWeapon( "frag_grenade_sonar_sp" );
	level.player SetWeaponAmmoClip( "frag_grenade_sonar_sp", n_grenade_count );
	
	t_light_1 = GetEnt( "light_1", "targetname" );
	t_light_2 = GetEnt( "light_2", "targetname" );
	t_light_3 = GetEnt( "light_3", "targetname" );
	
	t_light_1 Delete();
	t_light_2 Delete();
	t_light_3 Delete();
	
	//wait 1;
	
	add_asset_properties( "player_body", "sonar_on", level.player.origin, level.player.angles );
	level thread run_scene( "sonar_on" );
	
	level thread toggle_sonar();
	level thread get_out_concession_helper();
	
	m_sonar_door_2 = GetEnt( "concession_door_2", "targetname" );
	m_sonar_door_2 Delete();
	
	level notify( "sonar_is_on" );
}

get_out_concession_helper()
{
	s_get_out_pos = getstruct( "get_out_pos", "targetname" );
	set_objective( level.OBJ_SONAR_OUT, s_get_out_pos.origin, "breadcrumb" );
	
	trigger_wait( "get_out_door_sonar" );
	
	set_objective( level.OBJ_SONAR_OUT, s_get_out_pos, "remove" );
}

toggle_sonar()
{
	forcenocull_on = false;
	// str_sonar_vision = "infrared"; // this should be replaced with the correct vision set for sonar
	
//	while ( true )
//	{
//		dudes = GetAIArray( "axis" );
		
//		if ( level.player ButtonPressed( "DPAD_LEFT" ) )
//		{
//			if( forcenocull_on )
//			{
//				level clientnotify( "sonar_off" );
//				forcenocull_on = false;
//				
//				level notify( "sonar_off" );
//				
//				foreach ( ai_dude in dudes )
//				{
//					ai_dude removeforcenocull();
//				}
//			}
//			else
//			{
				level clientnotify( "sonar_on" );
				forcenocull_on = true;
				
				r_lightGridEnableTweaks = GetDvar( "r_lightGridEnableTweaks" );
				r_lightGridIntensity = GetDvar( "r_lightGridIntensity" );
				r_lightGridContrast = GetDvar( "r_lightGridContrast" );
				
				///////////Sonar Hero Lighting///////////////
    			SetSavedDvar( "r_lightGridEnableTweaks", 1 );
    			SetSavedDvar( "r_lightGridIntensity", 2 );
    			SetSavedDvar( "r_lightGridContrast", 1 );

				
				update_see_through();
//				level thread update_see_through();
//			}
//		}
//		
//		// hold the loop so it does not toggle the sonar vision multiple times for pressing the DPAD_LEFT once
//		while ( level.player ButtonPressed( "DPAD_LEFT" ) )
//		{
//			wait 0.05;
//		}
		
//		wait 0.05;
//	}	
	
	level clientnotify( "sonar_off" );
	forcenocull_on = false;
				
	level notify( "sonar_off" );
	
	add_asset_properties( "player_body", "sonar_off", level.player.origin, level.player.angles );
	level thread run_scene( "sonar_off" );

	a_ais = GetAIArray();	
	foreach ( ai_sonar in a_ais )
	{
		ai_sonar removeforcenocull();
		ai_sonar.maxVisibleDist = 8192;
	}
	
	n_grenade_count = level.player GetWeaponAmmoClip( "frag_grenade_sonar_sp" );
	level.player TakeWeapon( "frag_grenade_sonar_sp" );
	level.player GiveWeapon( "frag_grenade_sp" );
	level.player SetWeaponAmmoClip( "frag_grenade_sp", n_grenade_count );
	
	///////////Normal Hero Lighting///////////////
	SetSavedDvar( "r_lightGridEnableTweaks", r_lightGridEnableTweaks );
    SetSavedDvar( "r_lightGridIntensity", r_lightGridIntensity );
    SetSavedDvar( "r_lightGridContrast", r_lightGridContrast );
}

update_see_through()
{
	//level endon( "sonar_off" );
	
	level.b_sonar_done = false;
	
	//while ( true )
	while ( !level.b_sonar_done )
	{
		a_ais = GetAIArray();
		a_ais = array_removeDead( a_ais );
		
		foreach ( ai_sonar in a_ais )
		{
			ai_sonar setforcenocull();
			ai_sonar.maxVisibleDist = 128;
		}
		
		wait 0.05;
	}
}

intruder()
{
	if( !level.player HasPerk( "specialty_intruder" ) )
	{
		return;
	}
	
	s_intruder_pos = getstruct( "intruder_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_intruder_pos.origin, "interact" );
	
	level thread intruder_sam();
	
	trigger_wait( "intruder_use" );
	
	set_objective( level.OBJ_INTERACT, s_intruder_pos, "remove" );
	
	t_intruder_use = GetEnt( "intruder_use", "targetname" );
	t_intruder_use Delete();
	
	run_scene( "intruder" );
	
	m_intruder_gate = GetEnt( "intruder_gate", "targetname" );
	m_intruder_gate Delete();
}

intruder_sam()
{
	trigger_wait( "near_intruder_sam" );
	
	level thread fxanim_drones();
	level thread ambient_drones();
	level thread attacking_drones();
	level thread intruder_sam_timer();
	
	run_scene( "sam_in" );
	flag_set( "rooftop_sam_in" );
	
	vh_sam = GetEnt( "intruder_sam", "targetname" );
	vh_sam UseVehicle( level.player, 1 );
	//vh_sam thread intruder_sam_death();
	//vh_sam thread print_health();
	vh_sam.overrideVehicleDamage = ::sam_damage_override;
	
	SetDvar( "aim_assist_script_disable", 0 );
	level.player.old_aim_assist_min_target_distance = GetDvarInt( "aim_assist_min_target_distance" );
    level.player SetClientDvar( "aim_assist_min_target_distance", 100000 );   // default is  10000
	
	//level.player waittill_use_button_pressed();
	level waittill( "intruder_sam_end" );
	
	flag_clear( "rooftop_sam_in" );
	vh_sam UseBy( level.player );
	
	if ( level.b_sam_success )
	{
		run_scene( "sam_out" );
	}
	else
	{
		vh_sam DoDamage( 10000, vh_sam.origin, undefined, undefined, "explosive" );
		run_scene( "sam_thrown_out" );
	}
	
	level.player SetClientDvar( "aim_assist_min_target_distance", level.player.old_aim_assist_min_target_distance );
}

print_health()
{
	self endon( "death" );
	
	while ( true )
	{
		//IPrintLnBold( self.health );
		
		wait 1;
	}
}

intruder_sam_death()
{
	self waittill( "death" );
	
	level notify( "intruder_sam_end" );
}

intruder_sam_timer()
{
	level endon( "intruder_sam_end" );
	
	n_time = 3 * 60; // 3 minutes
	
	wait n_time;
	
	level.b_sam_success = true;
	level notify( "intruder_sam_end" );
}

sam_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	n_damage = n_damage * 2;
	
	n_health_result = self.health - n_damage;
	if ( n_health_result < 40 )
	{
		level.b_sam_success = false;
		level notify( "intruder_sam_end" );
	}
	
	return n_damage;
}

attacking_drones()
{
	level endon( "intruder_sam_end" );
	
	a_av_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	VEHICLE_COUNT_MAX = 64;
	n_drones_max = 3;
	level.n_attacking_chance = 1;
	level.n_attacking_drones = 0;
	
	level.n_sam_kills = 0;
	
	while ( true )
	{
		if ( level.n_attacking_drones < n_drones_max && GetVehicleArray().size < VEHICLE_COUNT_MAX )
		{
			a_sam_drone_path = choose_path();
		
			vh_attacking = spawn_vehicle_from_targetname( random( a_av_spawner_targetnames ) );
			vh_attacking thread attacking_drone_logic( a_sam_drone_path );
			vh_attacking thread attacking_drone_cleanup();
			//vh_attacking thread rooftop_drone_death_listener();
			
			level.n_attacking_drones++;
		}
		
		//level waittill( "sam_drone_done" );
		
		wait 0.05;
	}
}

choose_path()
{
	a_ordered_numbers = [];
	n_count = 0;
	n_max = 6;
	n_start = RandomIntRange( 0, n_max );
	
	while ( n_start < n_max )
	{
		a_ordered_numbers[ a_ordered_numbers.size ] = n_start;
		n_start++;
	}
	
	if ( a_ordered_numbers.size < n_max )
	{
		n_remaining = n_max - a_ordered_numbers.size;
		for ( i = 0; i < n_remaining; i++ )
		{
			a_ordered_numbers[ a_ordered_numbers.size ] = i;
		}
	}
	
	if ( cointoss() )
	{
		a_ordered_numbers = array_reverse( a_ordered_numbers );
	}
	
	a_sam_drone_path = [];
	for ( i = 0; i < a_ordered_numbers.size; i++ )
	{
		a_sam_drone_path[i] = getstruct( "sam_drone_path_" + a_ordered_numbers[i], "targetname" );
	}
	
	return a_sam_drone_path;
}

attacking_drone_logic( a_sam_drone_path )
{
	self endon( "death" );
	
	self SetForceNoCull();
	self SetNearGoalNotifyDist( 256 );
	//self EnableAimAssist();
	self SetSpeed( 250 );
	Target_set( self );
	
	self.origin = a_sam_drone_path[0].origin;
	
	foreach ( s_drone_path in a_sam_drone_path )
	{
		self SetVehGoalPos( s_drone_path.origin );
		self waittill_notify_or_timeout( "near_goal", 6 );
		
		b_correct_position = s_drone_path.targetname != "sam_drone_path_0" && s_drone_path.targetname != "sam_drone_path_5";
		
		if ( b_correct_position && ( RandomIntRange(0, 6) % level.n_attacking_chance ) == 0 )
		{
			v_attack_pos = ( level.player.origin[0], level.player.origin[1], 2500 );
			self SetVehGoalPos( v_attack_pos );
			self thread attack_player();
			self waittill_notify_or_timeout( "near_goal", 6 );
			
			self notify( "stop_attacking_player" );
		}
	}
	
	self Delete();
}

attack_player()
{
	self endon( "death" );
	self endon( "stop_attacking_player" );
	
	while ( true )
	{
		self shoot_turret_at_target( level.player, 1, undefined, 0 );
		
		wait 0.05;
	}
}

attacking_drone_cleanup()
{
	self waittill( "death" );
	
	//level notify( "sam_drone_done" );
	level.n_attacking_drones--;

	self waittill_notify_or_timeout( "crash_done", 10 );
	
	self notify( "crash_move_done" );
	
	if ( IsDefined( self.deathmodel_pieces ) )
	{
		array_delete( self.deathmodel_pieces );
	}
	
	if ( IsDefined( self ) )
	{
		self Delete();
	}
}

ambient_drones()
{
/*	
	n_aerial_vehicles = 33;
	
	a_av_spawner_targetnames = array( "avenger_fast", "pegasus_fast", "f35_fast" );
	level thread spawn_aerial_vehicles( n_aerial_vehicles, a_av_spawner_targetnames, "av_path_random" );
	
	a_ambient_av = GetEntArray( "f35_fast", "targetname" );
	a_ambient_av = array_merge( a_ambient_av, GetEntArray( "avenger_fast", "targetname" ) );
	a_ambient_av = array_merge( a_ambient_av, GetEntArray( "pegasus_fast", "targetname" ) );
	
	n_av_to_delete = a_ambient_av.size - n_aerial_vehicles;
	
	for ( i = 0; i < n_av_to_delete; i++ )
	{
		a_ambient_av[i] Delete();
	}
	
	level waittill( "intruder_sam_end" );
	
	level thread spawn_aerial_vehicles( 45, a_av_spawner_targetnames, "av_path_random" );
*/
	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	level thread spawn_aerial_vehicles( 45, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );

}

fxanim_drones()
{
	a_fxanim_drones = GetEntArray( "fxanim_ambient_drone", "targetname" );
	
	level.is_player_in_sam = true;
	
	foreach ( m_drone in a_fxanim_drones )
	{
		m_drone Delete();
		level.n_av_models--;
	}
	
	level waittill( "intruder_sam_end" );
	
	level.is_player_in_sam = false;
}

sam_down_drone_logic()
{
	self endon( "death" );
	
	self SetRotorSpeed(0);
	self veh_toggle_tread_fx( false );
	self veh_toggle_exhaust_fx( false );
	
	self.script_targetset = 1;
	self EnableAimAssist();
	
	level.player.overridePlayerDamage = ::sam_player_damage_override;
	
	v_tag_origin = self GetTagOrigin( "tag_turret" );
	
	while ( true )
	{
		self shoot_turret_at_target( level.player, 1, undefined, 0 );
		//self fire_turret_for_time( 1, 0 );
		
		wait 1;
	}
}

sam_player_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	t_sam_player_killable = GetEnt( "sam_player_killable", "targetname" );
	vh_down_drone = GetEnt( "sam_crashed_drone", "targetname" );
	
	if ( IsDefined( e_attacker.targetname ) && e_attacker.targetname == vh_down_drone.targetname && level.player IsTouching( t_sam_player_killable ) )
	{
		self die();
	}
	
	return n_damage;
}

spawn_outside_enemies()
{
	trigger_wait( "st_arena_middle_0" );
	
	trigger_use( "sm_arena_outside_0" );
	trigger_use( "sm_arena_outside_1" );
}

drop_walkway()
{
	m_walkway = GetEnt( "stadium_walkway", "targetname" );
	
	trigger_wait( "sm_arena_bdog" );
	
	m_walkway RotateRoll( -26, 0.4 );
}

anderson_f35_logic()
{
	self endon( "death" );
	
	self veh_magic_bullet_shield( true );
	
	v_turret_1 = self GetTagOrigin( "tag_gunner_turret1" );
	v_turret_2 = self GetTagOrigin( "tag_gunner_turret2" );
	
	CreateThreatBiasGroup( "possible_targets" );
	CreateThreatBiasGroup( "player_and_friendlies" );
	
	a_friendlies = GetAIArray( "allies" );
	ARRAY_ADD( a_friendlies, level.player );
	foreach ( e_friendly in a_friendlies )
	{
		e_friendly SetThreatBiasGroup( "player_and_friendlies" );
	}
	
	trigger_wait( "la_1_ending", "script_noteworthy" );
	
	while ( true )
	{
		a_possible_targets = [];
		a_enemy_ais = GetAIArray( "axis" );
		foreach ( ai_enemy in a_enemy_ais )
		{
			if ( IsDefined( ai_enemy.script_noteworthy ) && ai_enemy.script_noteworthy == "possible_target" )
			{
				ARRAY_ADD( a_possible_targets, ai_enemy );
				ai_enemy SetThreatBiasGroup( "possible_targets" );
			}
		}
		
		SetThreatBias( "possible_targets", "player_and_friendlies", 0 );
		
		if ( !flag( "ending_player_arrived" ) )
		{
			foreach ( ai_enemy in a_possible_targets )
			{
				if ( self.targetname == "arena_end_guards_0_ai" || self.targetname == "arena_end_bdog_0_ai" )
				{
					a_possible_targets = array_remove( a_possible_targets, ai_enemy );
				}
			}
		}
		
		if ( a_possible_targets.size > 0 )
		{
			ai_target = random( a_possible_targets );
		
			a_trace_info_1 = BulletTrace( v_turret_1, ai_target.origin, false, undefined );
			a_trace_info_2 = BulletTrace( v_turret_2, ai_target.origin, false, undefined );
		
			str_turret_1_hit = undefined;
			if ( IsDefined( a_trace_info_1[ "entity" ] ) )
			{
				str_turret_1_hit = a_trace_info_1[ "entity" ].targetname;
			}
		
			str_turret_2_hit = undefined;
			if ( IsDefined( a_trace_info_2[ "entity" ] ) )
			{
				str_turret_2_hit = a_trace_info_2[ "entity" ].targetname;
			}

			if ( !IsDefined( str_turret_1_hit ) || str_turret_1_hit != "f35_anderson" )
			{
				if ( IsAlive( ai_target ) )
				{
					self thread shoot_turret_at_target( ai_target, 1, undefined, 1 );
				}
			}
		
			if ( !IsDefined( str_turret_2_hit ) || str_turret_2_hit != "f35_anderson" )
			{
				if ( IsAlive( ai_target ) )
				{
					self thread shoot_turret_at_target( ai_target, 1, undefined, 2 );
				}
			}
		}
		
		wait 3;
	}
}

shoot_at_statue()
{
	self endon( "death" );
	
	self force_goal( undefined, 16 );
	
	m_statue = GetEnt( "arena_statue", "targetname" );
	s_statue_target_pos = getstruct( "statue_target_pos", "targetname" );
	
	//MagicBullet( "rpg_sp", self.origin + ( 0, 0, 71 ), m_statue.origin + ( 0, 0, 69 ) );
	MagicBullet( "rpg_sp", self.origin + ( 0, 0, 71 ), s_statue_target_pos.origin );
}

arena_juggernauts( str_bdog_name )
{
	self endon( "death" );
	
	self make_juggernaut( false );
	
	ai_bdog = GetEnt( str_bdog_name, "targetname" );

	self thread juggernaut_protect_behavior( ai_bdog );
}

arena_bdog()
{
	self endon( "death" );
	
	self GetPerfectInfo( level.player );
	
	if ( self.targetname == "arena_inside_bdog_0_ai" )
	{
		//self force_goal( undefined, 16, true );
		self thread arena_inside_bdog_0_logic();
	}
	
	if ( self.targetname == "arena_bdog_ai" )
	{
		self thread arena_bdog_2_dead();
		self.goalradius = 16;
		self set_goal_ent( level.player );
		
		wait 3;
		
		self.goalradius = 2048;
	}
	
	if ( self.targetname == "arena_inside_bdog_1_ai" )
	{
		self thread arena_bdog_2_dead();
	}
	
	n_distance_to_shoot_player_sq = 1048576;
	
	while ( true )
	{
		n_distance_squared = DistanceSquared( self.origin, level.player.origin );
		
		if ( self CanSee( level.player ) && n_distance_squared > n_distance_to_shoot_player_sq && ( !IsDefined( level.b_sonar_done ) || IS_TRUE( level.b_sonar_done ) ) )
		{
			animscripts\bigdog\bigdog_utility::fire_grenade_at_target( level.player );
			
			wait 6;
		}
		
		wait 0.05;
	}
}

ending_bdog()
{
	self endon( "death" );
	
	wait 0.5;
	
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.goalradius = 16;
	
	nd_target = GetNode( self.target, "targetname" );
	self set_goal_node( nd_target );
	
	self waittill( "goal" );
	
	flag_wait( "ending_ai_can_die" );
	
	nd_bdog_second = GetNode( "end_bdog_second", "targetname" );
	self set_goal_node( nd_bdog_second );
	
	self thread ending_bdog_killable();
	
	self waittill( "goal" );
	
	//e_bdog_target = GetEnt( "bdog_target", "targetname" );
	vh_anderson_f35 = GetEnt( "f35_anderson", "targetname" );
	vh_anderson_f35 thread shoot_turret_at_target( self, 1, undefined, 1 );
	vh_anderson_f35 thread shoot_turret_at_target( self, 1, undefined, 2 );
	
	animscripts\bigdog\bigdog_utility::fire_grenade_at_target( vh_anderson_f35 );
	
//	nd_bdog_final = GetNode( "end_bdog_final", "targetname" );
//	self set_goal_node( nd_bdog_final );
}

ending_bdog_killable()
{
	self endon( "death" );
	
	t_ending_bdog_killable = GetEnt( "ending_bdog_killable", "targetname" );
	
	while ( !( self IsTouching( t_ending_bdog_killable ) ) )
	{
		wait 0.05;
	}
	
	wait 0.5;
	
	nd_ending_move_from_0 = GetNode( "ending_move_from_0", "script_noteworthy" );
	nd_ending_move_to_0 = GetNode( "ending_move_to_0", "script_noteworthy" );
	ai_node_owner_0 = GetNodeOwner( nd_ending_move_from_0 );
	
	if ( IsDefined( ai_node_owner_0 ) )
	{
		ai_node_owner_0 set_goal_node( nd_ending_move_to_0 );
	}
}

arena_inside_bdog_0_logic()
{
	self waittill( "death" );
	
	level.n_arena_bdog_dead = 0;
	
	trigger_use( "kill_sm_702" );
	trigger_use( "sm_arena_inside_bdog_1" );
	trigger_use( "sm_arena_inside_guards_1" );
	trigger_use( "arena_move_up_1" );
	autosave_by_name( "arena_bdog_killed_1" );
}

arena_bdog_2_dead()
{
	self waittill( "death" );
	
	level.n_arena_bdog_dead++;
	
	if ( level.n_arena_bdog_dead == 2 )
	{
		trigger_use( "arena_move_up_2" );
		autosave_by_name( "arena_bdogs_killed" );
	}
}

ending_magic()
{
	self endon( "death" );
	
	self.overrideActorDamage = ::ending_enemies_override;
	
	//e_bdog_target = GetEnt( "bdog_target", "targetname" );
	vh_anderson_f35 = GetEnt( "f35_anderson", "targetname" );
	self thread shoot_at_target( vh_anderson_f35, undefined, undefined, -1 );
	
	trigger_wait( "la_1_ending" );
	
	flag_set( "ending_ai_can_die" );
	
	nd_ending_move_from_1 = GetNode( "ending_move_from_1", "script_noteworthy" );
	nd_ending_move_to_1 = GetNode( "ending_move_to_1", "script_noteworthy" );
	ai_node_owner_1 = GetNodeOwner( nd_ending_move_from_1 );
	
	if ( IsDefined( ai_node_owner_1 ) )
	{
		ai_node_owner_1 set_goal_node( nd_ending_move_to_1 );
	}
}

debug_death()
{
	self waittill( "death", attacker );
	
	//IPrintLnBold( attacker.targetname );
}

ending_enemies_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{	
	if ( !flag( "ending_ai_can_die" ) )
	{
		if ( IsDefined( e_inflictor.targetname ) && e_inflictor.targetname == "f35_anderson" )
		{
			n_damage = 0;
		}
		else if ( IsDefined( self.targetname ) && self.targetname == "arena_end_bdog_0_ai" )
		{
			n_damage = animscripts\bigdog\bigdog_init::bigdog_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name );
		}
	}
	else if ( IsDefined( self.targetname ) && self.targetname == "arena_end_bdog_0_ai" )
	{
		n_damage = animscripts\bigdog\bigdog_init::bigdog_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name );
	}
	
	return n_damage;
}

run_away_inside()
{
	trigger_wait( "arena_inside_run_away" );
	
	a_vehicles = GetVehicleArray();
	
	nd_run_away = GetNode( "nd_run_away", "script_noteworthy" );
	nd_run_away_to = GetNode( "run_away_to", "targetname" );
	ai_run_away = GetNodeOwner( nd_run_away );
	
	if ( IsAlive( ai_run_away ) )
	{
		ai_run_away force_goal( nd_run_away_to, 16 );
	
		ai_run_away waittill( "death" );
	
		trigger_use( "sm_arena_inside_bdog_0" );
		trigger_use( "sm_arena_inside_guards_0" );
		trigger_use( "sm_arena_inside_1" );
		trigger_use( "sm_arena_inside_2" );
	}
	else
	{
		//IPrintLnBold( "no runaway" );
	}
}

run_away_outside()
{
	flag_wait( "arena_outside_run_away" );
	
	nd_run_away = GetNode( "outside_run_away", "targetname" );
	nd_run_away_to = GetNode( "outside_run_away_to", "targetname" );
	ai_run_away = GetNodeOwner( nd_run_away );
	
	if ( IsAlive( ai_run_away ) )
	{
		ai_run_away force_goal( nd_run_away_to, 16 );
	}
}

la_1_ending()
{
	trigger_wait( "la_1_ending", "script_noteworthy" );
	
	level thread run_scene( "ending_wheeler" );
	
	level thread collapse_building();
	
	level.b_sonar_done = true;
	
//	add_asset_properties( "player_body", "sonar_off", level.player.origin, level.player.angles );
//	run_scene( "sonar_off" );
}

collapse_building()
{
	trigger_wait( "bring_van_in" );
	
	level thread run_scene( "collapse_building_van" );
	flag_wait( "collapse_building_van_started" );
	
	vh_van = GetEnt( "ending_van", "targetname" );
	vh_van thread ending_van_logic();
	
	trigger_wait( "collapse_building" );
	
	s_f35_fire_spot = getstruct( "f35_fire_spot", "targetname" );
	//s_attack_position = getstruct( "obj_anderson", "targetname" );
	s_attack_position = getstruct( "f35_target", "targetname" );
	s_attack_position_2 = getstruct( "look_at_collapse_building", "targetname" );
	MagicBullet( "f35_missile_turret", s_f35_fire_spot.origin, s_attack_position.origin ); // + ( 128, 0, 1279 ) );
	//MagicBullet( "f35_missile_turret", s_f35_fire_spot.origin, s_attack_position_2.origin + ( -256, 0, 0 ) );
	
	level thread run_scene( "ending_dog_fight" );
	flag_wait( "ending_dog_fight_started" );
	
	level thread ending_dog_fight();
	
	scene_wait( "ending_dog_fight" );
	
	level.player StartCameraTween( 0.4 );
	
	m_collapse_building = GetEnt( "collapsing_building_geo", "targetname" );
	m_collapse_building thread collapse_building_animation();
	
	Earthquake( 1, 1, level.player.origin, 64 );
	wait 1;
	
	level.player thread say_dialog( "everybody_down_001" );
	level thread run_scene( "collapse_building_harper" );
	add_asset_properties( "player_body", "collapse_building_player", level.player.origin, level.player.angles );
	run_scene( "collapse_building_player" );

	//level.player AllowCrouch( false );
	level.player AllowStand( false );
	level.player AllowJump( false );
	level.player AllowSprint( false );
	
	v_start = level.player.origin + (0, 0, 100);
	v_end = v_start + (0, 0, -200);
	a_trace_info = BulletTrace( v_start, v_end, false, level.player );
	level.player SetOrigin( a_trace_info["position"] );
	
	level.player SetLowReady( false );
	
	//exploder( 790 );
	
	//IPrintLnBold( "press 'X' to be able to get up" );
	level.player waittill_use_button_pressed();
	
	//level.player AllowCrouch( true );
	level.player AllowJump( true );
	level.player AllowSprint( true );
	level.player AllowStand( true );
}

ending_dog_fight()
{
	s_f35_fire_spot = getstruct( "f35_fire_spot", "targetname" );
	s_attack_position_2 = getstruct( "look_at_collapse_building", "targetname" );
	m_f35 = get_model_or_models_from_scene( "ending_dog_fight", "f35_ending_dog_fight" );
	m_avenger = get_model_or_models_from_scene( "ending_dog_fight", "drone_ending_dog_fight" );
	PlayFXOnTag( level._effect[ "drone_smoke_trail" ], m_avenger, "tag_gunner_turret2" );
	
	level.player SetLowReady( true );
	
	wait 1;
	
	level.player FreezeControlsAllowLook( true );
	level.player thread look_at_crashing_drone( m_avenger );
	level.player playsound( "evt_buildcollapse_drone_fnt" );
	
	m_f35 SetAnimLimited( level.scr_anim[ "f35_ending_dog_fight" ][ "ending_dog_fight" ], 1, 0, 0.65 );
	m_avenger SetAnimLimited( level.scr_anim[ "drone_ending_dog_fight" ][ "ending_dog_fight" ], 1, 0, 0.65 );
	MagicBullet( "f35_missile_turret", s_f35_fire_spot.origin, s_attack_position_2.origin + ( -256, 0, -256 ) );
	
	wait 0.15;
	
	PlayFXOnTag( level._effect[ "tanker_explosion" ], m_avenger, "tag_gunner_turret2" );
	timescale_tween( 0.15, 0.35, 0.05 );
	
	wait 0.15;
	
	timescale_tween( 0.35, 1, 0.05 );
	
	wait 1.3;
	
	level.player playsound( "evt_buildcollapse_build_fnt" );
	PlayFX( level._effect[ "ending_crash_explosion" ] , m_avenger.origin );
	exploder( 790 );
	
	wait 0.05;
	
	end_scene( "ending_dog_fight" );
}

look_at_crashing_drone( m_avenger )
{
	level.scene_sys endon( "ending_dog_fight" );
	
	s_look_at_collapse_building = getstruct( "look_at_collapse_building", "targetname" );
	//level.player look_at( s_look_at_collapse_building.origin, 0.5 );
	
	//wait 1;
	
	while ( true )
	{
		//level.player look_at( m_avenger.origin, 0.05 );
		level.player StartCameraTween( 0.15 );
		if ( IsDefined( m_avenger ) )
		{
			v_angles = VectorToAngles( m_avenger.origin - level.player.origin );
			level.player SetPlayerAngles( v_angles );
		}
		
		wait 0.15;
	}
}

ending_van_logic()
{
	self endon( "death" );
	
	self veh_magic_bullet_shield( true );
	
	scene_wait( "collapse_building_van" );
	
	//self veh_magic_bullet_shield( false );
}

collapse_building_animation()
{
	v_cb_finish_pos = ( 2160, 15936, 0 );
	//SOUND - Shawn J
	level.player playsound( "evt_bldg_fall_f" );
	self MoveTo( v_cb_finish_pos, 9 );
}

la_2_transition()
{
	// player position
	str_local_player_coordinates = level.player get_transition_vector_string();
	SetDvar( "la_2_player_start_pos", str_local_player_coordinates );
	SetDvar( "la_1_ending_position", 1 );	
	
	// did anderson live?
	b_saved_anderson = 0;
	if ( flag( "anderson_saved" ) )
	{
		b_saved_anderson = 1;
	}
	SetDvar( "la_F35_pilot_saved", b_saved_anderson );
	
	// did the first G20 vehicle live?
	b_g20_saved_1st = 0;
	if ( flag( "g20_group1_dead" ) )
	{
		b_g20_saved_1st = 1;
	}
	SetDvar( "la_G20_1_saved", b_g20_saved_1st );
	
	// did the second G20 vehicle live?
	b_g20_saved_2nd = 0;
	if ( flag( "intersect_vip_cougar_died" ) )
	{
		b_g20_saved_2nd = 1;
	}
	SetDvar( "la_G20_2_saved", b_g20_saved_2nd );
}

end_la_1( m_player_body )
{
	exploder( 790 );
	
	wait 4.5;
	
	la_2_transition();
	
	nextmission();
}

/////////////////////////////////////////////////////////////////////////////////////////////
// ARENA CHALLENGES
/////////////////////////////////////////////////////////////////////////////////////////////

challenge_roofdrones( str_notify )
{
	level endon( "intruder_sam_end" );
	
	flag_wait( "rooftop_sam_in" );
	
	a_pegasi = getentarray( "pegasus_fast", "targetname" );
	a_avengers = getentarray( "avenger_fast", "targetname" );
	a_drones = array_merge( a_pegasi, a_avengers );
	//array_thread( a_drones, ::rooftop_drone_death_listener );
	
	while( true ) // TODO: end the loop if we no longer want to track this challenge
	{
		level waittill( "rooftop_drone_killed" );
		self notify( str_notify );
	}
}

challenge_saveanderson( str_notify )
{
	flag_wait( "la_arena_start" );
	
	n_time_limit = GetTime() + ( 9 * 60 * 1000 );	// 9 minutes
	
	trigger_wait( "la_1_ending", "script_noteworthy" ); 
	
	n_complete_time = GetTime();
	if( n_complete_time < n_time_limit )
	{
		flag_set( "anderson_saved" );
		
		self notify( str_notify );
	}
}
