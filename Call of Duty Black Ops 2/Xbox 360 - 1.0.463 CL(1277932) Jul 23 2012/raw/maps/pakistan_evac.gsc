#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_objectives;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\pakistan_util;
#include maps\pakistan_s3_util;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\pakistan.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_hangar()
{
	skipto_teleport( "skipto_hangar" );
	
	level.vh_player_soct = spawn_vehicle_from_targetname( "player_soc_t" );
	level.vh_player_soct get_player_on_soc_t();
	level.vh_player_soct veh_magic_bullet_shield( true );
	
	wait 0.05; // needs a wait before notifying the client to get the hands back
	
	// Spawn drive hands
	ClientNotify( "enter_soct" );
	
	level.vh_player_soct play_fx( "soct_spotlight", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx", true, "tag_headlights" );
	
	level.vh_apache = spawn_vehicle_from_targetname( "boss_apache" );
	
	level.player.vehicle_state = PLAYER_VH_STATE_SOCT;
	
	OnSaveRestored_Callback( ::checkpoint_save_restored );
	
	//exploder( 850 );
	purple_smoke();
	
	set_objective( level.OBJ_ESCAPE );
}

skipto_standoff()
{
	skipto_teleport( "skipto_standoff" );
	
	level.vh_player_soct = spawn_vehicle_from_targetname( "player_soc_t" );
	level.vh_player_soct get_player_on_soc_t();
	level.vh_player_soct veh_magic_bullet_shield( true );
	
	wait 0.05; // needs a wait before notifying the client to get the hands back
	
	// Spawn drive hands
	ClientNotify( "enter_soct" );
	
	level.vh_player_soct play_fx( "soct_spotlight", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx", true, "tag_headlights" );
	
	level.vh_salazar_soct = spawn_vehicle_from_targetname( "salazar_soc_t" );
	
	s_skipto = getstruct( "skipto_" + level.skipto_point + "_salazar", "targetname" );
	level.vh_salazar_soct.origin = s_skipto.origin;
	level.vh_salazar_soct.angles = s_skipto.angles;
	
	spawn_vehicles_from_targetname( "standoff_heli" );
	
	OnSaveRestored_Callback( ::checkpoint_save_restored );
	
	set_objective( level.OBJ_EVAC_POINT, getstruct( "evac_point", "targetname" ), "breadcrumb" );
	//exploder( 850 );
	purple_smoke();
	
	set_objective( level.OBJ_ESCAPE );
	
	level.player set_story_stat( "HARPER_SCARRED", true );
}

skipto_dev_s3_script()
{
	skipto_teleport( "skipto_dev_s3_script" );
	
	level.vh_player_soct = spawn_vehicle_from_targetname( "player_soc_t" );
	level.vh_player_soct get_player_on_soc_t();
	level.vh_player_soct veh_magic_bullet_shield( true );
	level.vh_player_soct thread watch_for_boost();
	level.vh_player_soct.driver = level.player;
	level.vh_player_soct.n_intensity_min = 9;

	if ( level.player get_temp_stat( SOCT_HAS_BOOST ) )
	{
		level.vh_player_soct SetModel( "veh_t6_mil_super_soc_t" );
		level.vh_player_soct.n_intensity_min = 6;
	}
	
	wait 0.05; // needs a wait before notifying the client to get the hands back
	
	// Spawn drive hands
	ClientNotify( "enter_soct" );
	
	level.vh_player_soct play_fx( "soct_spotlight", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx", true, "tag_headlights" );
	
	level.player.vehicle_state = PLAYER_VH_STATE_SOCT;
	
	script_test_main();
}

skipto_dev_s3_build()
{
	skipto_teleport( "skipto_dev_s3_build" );
	
	level.player hide_player_hud();
}

hangar_main()
{
	/#
		IPrintLn( "Hangar" );
	#/
	
	if ( level.skipto_point == "hangar" )
	{
		trigger_wait( "hangar_animation" );
		n_lerp_time = 0;
	}
	else
	{
		n_lerp_time = 3.1;
		
	}
	
	fake_soc = spawn("script_model", (0, 0, 0));
	fake_soc setmodel("veh_t6_mil_soc_t_no_col");
	fake_soc.targetname = "fake_soc_t";

	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		flag_clear( "cannot_switch" );
		
		level.player.viewlockedentity notify( "change_seat" );
		level.vh_player_soct thread speed_up_player_soct();
		
		wait (0.05); // let the switching begin before waiting for it to end
		level notify( "end_vehicle_switch" );
		screen_fade_out( SWITCH_TIME );
		level thread screen_fade_in( SWITCH_TIME );
		//flag_wait( "vehicle_switched" );
		
	}
	
	if ( IsDefined( level.harper ) )
	{
		level.harper Delete();
	}
	
	if ( IsDefined( level.salazar ) )
	{
		level.salazar Delete();
	}
	
	if ( IsDefined( level.han ) )
	{
		level.han Delete();
	}
	
	if ( does_apache_exist() )
	{
		level thread run_scene( "hangar_apache" );
	}
	
	if ( does_super_soct_exist() )
	{
		level thread run_scene( "hangar_super_soct" );
	}
	
	level.vh_player_soct UseBy( level.player );

	level.player SetPlayerAngles(level.vh_player_soct.angles);
//	level.vh_player_soct hide();
	level thread run_scene( "hangar" );
	
	if ( does_apache_exist() || does_super_soct_exist() )
	{
		level.player set_story_stat( "HARPER_SCARRED", true );
		level thread run_scene( "harper_burned" );
	}
	else
	{
		level.player set_story_stat( "HARPER_SCARRED", false );
		level thread run_scene( "harper_not_burned" );
	}
	
	flag_wait( "hangar_started" );
	
		
	scene_wait( "hangar" );
	setmusicstate ("PAKISTAN_BURNED");
	
	level.vh_player_soct show();
	level.vh_player_soct UseBy( level.player );
	level.vh_player_soct SetVehGoalPos( level.vh_player_soct.origin, true );
	level.vh_player_soct disable_turret( 1 );
	
	level.vh_salazar_soct = GetEnt( "salazar_soc_t", "targetname" );
	level.vh_salazar_soct SetVehGoalPos( level.vh_salazar_soct.origin, true );
	level.vh_salazar_soct disable_turret( 1 );
	
	level.harper = init_hero( "harper" );
	level.harper enter_vehicle( level.vh_player_soct );
	
	level.salazar = init_hero( "salazar" );
	level.salazar enter_vehicle( level.vh_salazar_soct, "tag_driver" );
	
	level.han = init_hero( "han" );
	level.han enter_vehicle( level.vh_salazar_soct );
	
	level.player thread say_dialog( "sect_there_s_our_evac_sit_0" );
	
	wait 0.05; // needs a wait before notifying the client to get the hands back
	
	// Spawn drive hands
	ClientNotify( "enter_soct" );
	
//	level.player FreezeControls( false );
	
	spawn_vehicles_from_targetname( "standoff_heli" );
}

does_apache_exist()
{
	b_apache_exists = false;
	
	if ( IsDefined( level.vh_apache ) && IS_VEHICLE( level.vh_apache ) && !IsDefined( level.vh_apache.crashing ) )
	{
		b_apache_exists = true;
	}
	
	return b_apache_exists;
}

does_super_soct_exist()
{
	b_super_soct_exists = false;
	
	if ( IsDefined( level.vh_super_soct ) && IS_VEHICLE( level.vh_super_soct ) )
	{
		b_super_soct_exists = true;
	}
	
	return b_super_soct_exists;
}

// self == player's soc-t
speed_up_player_soct()
{	
	level endon( "hangar_started" );
	
	n_speed = self GetSpeedMPH();
	self SetSpeed( 0, 1000, 1000 );
	
	flag_wait( "vehicle_switch_fade_in_started" );

	level.vh_player_soct SetSpeed( n_speed, 1000, 1000 );
	level.vh_player_soct SetSpeedImmediate( n_speed, 1000, 1000 );
	
	while ( level.vh_player_soct GetSpeedMPH() < 111 )
	{
		wait 0.05;
		
		level.vh_player_soct SetSpeedImmediate( n_speed, 1000, 1000 );
	}
}

standoff_main()
{
	/#
		IPrintLn( "Standoff" );
	#/
		
	a_enemies = GetAIArray( "axis" );
	array_delete( a_enemies );
		
	level thread standoff_ai_setup();
	level thread standoff_objectives();

//	level.player FreezeControls( true );
		
	s_align = getstruct( "chinese_standoff", "targetname" );
	
	v_player_soct_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_9_4_standoff_approach_soct1 );
	level.vh_player_soct SetVehGoalPos( v_player_soct_start_pos, false, 0 );
	level.vh_player_soct SetNearGoalNotifyDist( 512 );
	level.vh_player_soct thread lerp_vehicle_speed( level.vh_player_soct GetSpeedMPH(), 119, 6 );
	
	v_salazar_soct_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_9_4_standoff_approach_soct2 );
	level.vh_salazar_soct SetVehGoalPos( v_salazar_soct_start_pos, false, 0 );
	level.vh_salazar_soct SetNearGoalNotifyDist( 512 );
	level.vh_salazar_soct thread lerp_vehicle_speed( level.vh_salazar_soct GetSpeedMPH(), 63, 6 );
	
	level.vh_player_soct waittill( "near_goal" );
	level.vh_salazar_soct ClearVehGoalPos();
	
	if ( IsDefined( level.harper ) )
	{
		level.harper Delete();
	}
	
	if ( IsDefined( level.salazar ) )
	{
		level.salazar Delete();
	}
	
	if ( IsDefined( level.han ) )
	{
		level.han Delete();
	}
	
	level thread standoff();
	standoff_approach();
	
	scene_wait( "standoff" );
}

standoff_objectives()
{
	set_objective( level.OBJ_ESCAPE, undefined, "done" );
	set_objective( level.OBJ_EVAC );
	
	flag_wait( "standoff_approach_started" );
	
	setmusicstate ("PAKISTAN_STANDOFF");
	
	set_objective( level.OBJ_EVAC_POINT, undefined, "remove" );
	
	trigger_wait( "disable_player_weapon" );
	
	set_objective( level.OBJ_EVAC, undefined, "done" );
}

standoff_ai_setup()
{	
	// seals setup
	for ( i = 0; i < 12; i++ )
	{
		ai_seal = simple_spawn_single( "seal_team" );
		s_spot = getstruct( "seal_" + i, "targetname" );
//		ai_seal forceteleport( s_spot.origin, s_spot.angles );
//		ai_seal.script_noteworthy = ai_seal.targetname + "_" + i;
//		ai_seal thread standoff_aim_seal();
		
		if ( i == 0 )
		{
//			ai_seal AllowedStances( "crouch" );
			add_scene_properties( "soldier_idle_seal_1", s_spot.targetname );
			add_generic_ai_to_scene( ai_seal, "soldier_idle_seal_1" );
			level thread run_scene( "soldier_idle_seal_1" );
			ai_seal thread soldier_stance( "seal_1", s_spot.targetname );
		}
		else
		{
			n_random = RandomIntRange( 2, 4 );
			add_scene_properties( "soldier_idle_seal_" + n_random, s_spot.targetname );
			add_generic_ai_to_scene( ai_seal, "soldier_idle_seal_" + n_random );
			level thread run_scene( "soldier_idle_seal_" + n_random );
			ai_seal thread soldier_stance( "seal_" + n_random, s_spot.targetname );
		}
	}
	
	// chinese setup
	for ( i = 0; i < 12; i++ )
	{
		ai_chinese = simple_spawn_single( "chinese_force" );
		s_spot = getstruct( "chinese_" + i, "targetname" );
//		ai_chinese forceteleport( s_spot.origin, s_spot.angles );
//		ai_chinese.script_noteworthy = ai_chinese.targetname + "_" + i;
//		ai_chinese thread standoff_aim_chinese();
		
		if ( i == 0 || i == 1 || i == 2 )
		{
//			ai_chinese AllowedStances( "crouch" );
			add_scene_properties( "soldier_idle_chinese_3", s_spot.targetname );
			add_generic_ai_to_scene( ai_chinese, "soldier_idle_chinese_3" );
			level thread run_scene( "soldier_idle_chinese_3" );
			ai_chinese thread soldier_stance( "chinese_3", s_spot.targetname );
		}
		else
		{
			n_random = RandomIntRange( 1, 3 );
			add_scene_properties( "soldier_idle_chinese_" + n_random, s_spot.targetname );
			add_generic_ai_to_scene( ai_chinese, "soldier_idle_chinese_" + n_random );
			level thread run_scene( "soldier_idle_chinese_" + n_random );
			ai_chinese thread soldier_stance( "chinese_" + n_random, s_spot.targetname );
		}
	}
	
	level notify( "standoff_ai_setup_done" );
}

// self == a soldier in the standoff
soldier_stance( str_suffix, str_align_targetname )
{
	trigger_wait( "standoff_start" );
	
	add_scene_properties( "soldier_react_" + str_suffix, str_align_targetname );
	add_generic_ai_to_scene( self, "soldier_react_" + str_suffix );
	run_scene( "soldier_react_" + str_suffix );
	
	add_scene_properties( "soldier_idle_" + str_suffix, str_align_targetname );
	add_generic_ai_to_scene( self, "soldier_idle_" + str_suffix );
	level thread run_scene( "soldier_idle_" + str_suffix );
	
	level waittill( "standoff_settle" );
	
	add_scene_properties( "soldier_settle_" + str_suffix, str_align_targetname );
	add_generic_ai_to_scene( self, "soldier_settle_" + str_suffix );
	run_scene( "soldier_settle_" + str_suffix );
}

// self == chinese AI
standoff_aim_chinese()
{
	self endon( "death" );
	
	level waittill( "standoff_ai_setup_done" );
	
	while ( true )
	{
		n_random = RandomInt( 12 );
		ai_target = GetEnt( "seal_team_ai_" + n_random, "script_noteworthy" );
		self aim_at_target( ai_target );
		
		wait RandomIntRange( 3, 6 );
	}
}

// self == seal AI
standoff_aim_seal()
{
	self endon( "death" );
	
	level waittill( "standoff_ai_setup_done" );
	
	while ( true )
	{
		n_random = RandomInt( 12 );
		ai_target = GetEnt( "chinese_force_ai_" + n_random, "script_noteworthy" );
		self aim_at_target( ai_target );
		
		wait RandomIntRange( 3, 6 );
	}
}

standoff_approach()
{
	const n_lerp_time = 0.65;
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		level thread standoff_approach_harper_burned_logic( n_lerp_time );
	}
	else
	{
		level thread standoff_approach_harper_not_burned_logic( n_lerp_time );
	}
	
	level thread run_scene( "standoff_approach_soct", n_lerp_time );
	level thread run_scene( "standoff_approach", n_lerp_time );
	
	flag_wait( "standoff_approach_started" );
	
	level.vh_player_soct UseBy( level.player );
//	level.player FreezeControls( false );
	
	level.harper = init_hero( "harper" );
	level.harper set_ignoreall( true );
	
	level.salazar = init_hero( "salazar" );
	level.salazar set_ignoreall( true );
	level.salazar change_movemode( "cqb_sprint" );
	
	level.han = init_hero( "han" );
	level.han set_ignoreall( true );
	level.han change_movemode( "cqb_sprint" );
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		scene_wait( "standoff_approach_burned_player" );
	}
	else
	{
		scene_wait( "standoff_approach_not_burned_player" );
	}
	
	level.vh_player_soct SetVehGoalPos( level.vh_player_soct.origin, true );
	level.vh_salazar_soct SetVehGoalPos( level.vh_salazar_soct.origin, true );
	level.player thread player_arms_transition();
	
	scene_wait( "standoff_approach" );
	
	level.salazar thread salazar_approach_logic();
	level.han thread han_approach_logic();
}

salazar_approach_logic()
{
//	level endon( "standoff_started" );
	
	s_align = getstruct( "chinese_standoff", "targetname" );
	v_idle_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %generic_human::ch_pakistan_9_4_standoff_idle_salazar );
	self force_goal( v_idle_pos, 16, false );
	
	level thread run_scene( "standoff_idle_salazar" );
}

han_approach_logic()
{
//	level endon( "standoff_started" );
	
	s_align = getstruct( "chinese_standoff", "targetname" );
	v_idle_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %generic_human::ch_pakistan_9_4_standoff_idle_redshirt );
	self force_goal( v_idle_pos, 16, false );
	
	level thread run_scene( "standoff_idle_han" );
}

standoff_approach_harper_burned_logic( n_lerp_time )
{
//	level endon( "standoff_started" );
	
	level thread run_scene( "standoff_approach_burned_harper", n_lerp_time );
	level thread run_scene( "standoff_approach_burned_player", n_lerp_time );
	
	level.harper = init_hero( "harper" );
	level.harper SetModel( "c_usa_cia_combat_harper_burned_fb" );
	level.harper set_run_anim( "harper_burned_walk" );
	
	s_align = getstruct( "chinese_standoff", "targetname" );
	v_harper_idle_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %generic_human::ch_pakistan_9_4_standoff_burned_idle_harper );
	
	scene_wait( "standoff_approach_burned_harper" );
	
	level.harper force_goal( v_harper_idle_pos, 16, false );
	
	level thread run_scene( "standoff_idle_burned" );
}

standoff_approach_harper_not_burned_logic( n_lerp_time )
{
//	level endon( "standoff_started" );
	
	level thread run_scene( "standoff_approach_not_burned_harper", n_lerp_time );
	level thread run_scene( "standoff_approach_not_burned_player", n_lerp_time );
	
	s_align = getstruct( "chinese_standoff", "targetname" );
	v_harper_idle_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %generic_human::ch_pakistan_9_4_standoff_idle_harper );
	
	scene_wait( "standoff_approach_not_burned_harper" );
	
	level.harper force_goal( v_harper_idle_pos, 16, false );
	
	level thread run_scene( "standoff_idle_not_burned" );
}

// self == player
player_arms_transition()
{
	level notify( "player_got_off_soct" );
	
	self notify( "give_back_weapons" );
	
	self SetLowReady( true );
	
	trigger_wait( "disable_player_weapon" );
	
	self DisableWeapons();
	self SetLowReady( false );
}

standoff()
{
	level thread run_scene_first_frame( "standoff_chinese_important" );
	
	trigger_wait( "standoff_start" );
	
//	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
//	{
//		level thread run_scene( "standoff_burned" );
//	}
//	else
//	{
//		level thread run_scene( "standoff_not_burned" );
//	}
	
	level thread run_scene( "standoff_chinese_important" );
	level thread run_scene( "standoff" );
	flag_wait( "standoff_started" );
	
//	str_weapon_model = GetWeaponModel( "scar_sp" );
//	m_player = get_model_or_models_from_scene( "standoff", "player_body" );
//	m_player Attach( str_weapon_model, "tag_weapon" );
	
	scene_wait( "standoff" );
}

script_test_main()
{
	/#
		IPrintLn( "Script Test" );
	#/
	
	add_spawn_function_veh( "test_bump", ::vehicle_collision_watcher );
	
	trigger_wait( "test_takedown" );
	
	wait 1;
	
	level.vh_player_soct thread rubberband_potential_soct();
}