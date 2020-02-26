#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
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
skipto_escape_intro()
{
	skipto_teleport( "skipto_escape_intro" );
}

main()
{	
	escape_setup();
	
	OnSaveRestored_Callback( ::checkpoint_save_restored );
	
	level.player hide_player_hud();
	
	level.vh_player_drone play_fx( "firescout_spotlight", level.vh_player_drone GetTagOrigin( "tag_flash" ), level.vh_player_drone GetTagAngles( "tag_flash" ), "remove_fx", true, "tag_flash" );
	level.vh_player_soct play_fx( "soct_spotlight_cheap", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx_cheap", true, "tag_headlights" );
	
	level.vh_player_drone thread maps\_vehicle_death::vehicle_damage_filter( "firestorm_turret" );
	level.vh_player_drone thread firescout_fire_missiles();
	
	wait 0.38; // give time for the drone hud to show up
	
	level.vh_player_drone UseBy( level.player );
	level.player.vehicle_state = PLAYER_VH_STATE_DRONE;
	
	level.vh_player_soct SetClientFlag( CLIENT_FLAG_VEHICLE_OUTLINE );
	level.vh_salazar_soct SetClientFlag( CLIENT_FLAG_VEHICLE_OUTLINE );
	
	escape_intro_spawn_funcs();
	level thread escape_intro_objectives();
	level thread escape_intro_checkpoints();
	level thread escape_intro_hints();
	level thread escape_intro_vo();
	
	m_blockade = GetEnt( "drone_blockade", "targetname" );
	m_blockade thread drone_intro_blockade();
	/#
		m_blockade thread debug_di_destroy_blockade();
	#/
	
	//TUEY - Set music during skipto
	setmusicstate ("PAKISTAN_CHASE");
	
	level.vh_player_drone drone_intro();
	
	level.vh_player_drone thread drone_escape_start();
	
	level.vh_salazar_soct thread soct_intro_change_speed();
}

escape_intro_objectives()
{
	set_objective( level.OBJ_ESCAPE );
	
	trigger_wait( "sm_di_scaffolding" );
	
	s_blockade_obj = getstruct( "blockade_obj", "targetname" );
	set_objective( level.OBJ_BLOCKADE, s_blockade_obj, "destroy" );
	
	level waittill( "di_blockade_destroyed" );
	
	set_objective( level.OBJ_BLOCKADE, s_blockade_obj, "done" );
	set_objective( level.OBJ_BLOCKADE, s_blockade_obj, "delete" );
}

escape_intro_checkpoints()
{
	flag_wait( "vehicle_switched" );
	
	autosave_by_name( "drone_intro_done" );
	level.n_save = 0;
}

escape_intro_vo()
{
	level.harper say_dialog( "harp_gotta_clear_a_path_f_0" );
	level.harper say_dialog( "harp_soc_t_s_blocking_the_0" );
	
	trigger_wait( "sm_di_scaffolding" );
	
	level.harper say_dialog( "harp_take_out_that_barric_0" );
	
	level waittill( "player_changed_seat" );
	
	level.harper say_dialog( "harp_go_go_go_0" );
	
	trigger_wait( "reverse_brake_hint" );
	
	level.harper say_dialog( "harp_we_gotta_make_that_e_0" );
	level.player say_dialog( "seal_we_re_clearing_a_pat_0" );
}

escape_intro_spawn_funcs()
{
	sp_st_fork = GetEnt( "st_fork_bad", "targetname" );
	sp_st_fork add_spawn_function( ::run_over );
	
	a_st_scaffolding_left_0 = GetEntArray( "st_scaffolding_left_0", "targetname" );
	array_thread( a_st_scaffolding_left_0, ::add_spawn_function, ::run_over );
	
	sp_st_scaffolding_middle_0 = GetEnt( "st_scaffolding_middle_0", "targetname" );
	sp_st_scaffolding_middle_0 add_spawn_function( ::shoot_at_target_untill_dead, level.player );
	
	sp_st_scaffolding_right_0 = GetEnt( "st_scaffolding_right_0", "targetname" );
	sp_st_scaffolding_right_0 add_spawn_function( ::shoot_at_target_untill_dead, level.player );
	
	sp_st_scaffolding_right_1 = GetEnt( "st_scaffolding_right_1", "targetname" );
	sp_st_scaffolding_right_1 add_spawn_function( ::shoot_at_target_untill_dead, level.player );
	
	a_ai_targets = GetEntArray( "ai_target", "script_noteworthy" );
	array_thread( a_ai_targets, ::add_spawn_function, ::set_lock_on_target, ( 0, 0, 45 ) );
	
	add_spawn_function_veh( "di_soct_0", ::enemy_soct_shoot_logic );
	add_spawn_function_veh( "di_soct_0", ::set_lock_on_target, ( 0, 0, 32 ) );
	add_spawn_function_veh( "di_soct_0", ::drone_kill_count );
	add_spawn_function_veh( "di_soct_0", ::drone_intro_soct_0_logic );
	add_spawn_function_veh( "chicken_soct", ::soct_intro_chicken );
}

// self == the player's drone
drone_intro()
{
//	level endon( "debug_di_blockade" );
	
	level thread drone_intro_enemies();
	self thread drone_intro_entries();
	
	nd_drone_intro_start = GetVehicleNode( "drone_intro_spline", "targetname" );
	self SetVehGoalPos( nd_drone_intro_start.origin );
	self waittill( "goal" );
	
	spawn_vehicle_from_targetname_and_drive( "di_soct_0" );
	
	//self thread drone_intro_lookat_targets();
	self go_path( nd_drone_intro_start );
	
//	self SetPhysAngles( e_blockade_target.angles );
	self SetHoverParams( 128 );
	
	level waittill( "player_changed_seat" );
	
	level notify( "soct_intro_ready" );
}

// HACK: this is a test function
drone_intro_lookat_targets()
{
	self endon( "death" );
	
	self waittill( "di_billboard" );
	
	self SetLookatEnt( GetEnt( "lookat_di_billboard", "targetname" ) );
	IPrintLnBold( "look at billboard" );
	
	self waittill( "di_left_side" );
	
	self SetLookAtEnt( GetEnt( "lookat_di_left", "targetname" ) );
	IPrintLnBold( "look left" );
	
	self waittill( "di_blockade" );
	
	self SetLookAtEnt( GetEnt( "drone_blockade_01", "targetname" ) );
	IPrintLnBold( "look at blockade" );
}

// self == the player's drone
drone_escape_start()
{
	nd_soct_intro_start = GetVehicleNode( "drone_path", "targetname" );
	self SetVehGoalPos( nd_soct_intro_start.origin );
	self waittill( "goal" );
	
	self thread go_path( nd_soct_intro_start );
	self thread vehicle_speed_control();
}

// self == the player's drone
drone_intro_entries()
{
	nd_start = GetNode( "di_right_0_nd", "script_noteworthy" );
	nd_end = GetVehicleNode( "di_left_side", "script_noteworthy" );
	
	waittill_ai_group_cleared( "di_right" );
	
	v_tag_player_org = self GetTagOrigin( "tag_player" );
	v_end_pos = ( nd_end.origin[0], nd_end.origin[1], v_tag_player_org[2] );
	MagicBullet( "usrpg_sp", nd_start.origin + ( 0, 0, 64 ), v_end_pos );
	
	waittill_ai_group_cleared( "di_left" );
	
	trigger_use( "sm_di_scaffolding" );
}

drone_intro_enemies()
{
	level thread drone_intro_billboard();
	level thread drone_intro_glass_building();
	level thread drone_intro_scaffolding();
}

drone_intro_billboard()
{
	trigger_wait( "sm_di_right_0" );
	
	level thread run_scene( "di_billboard_below" );
	
	trigger_wait( "sm_di_right_1" );
	
	level thread run_scene( "di_billboard_left" );
	level thread run_scene( "di_billboard_right" );
	level thread run_scene( "di_billboard_side" );
	
	if ( RandomInt( 2 ) )
	{
		scene_wait( "di_billboard_right" );
	}
	else
	{		
		scene_wait( "di_billboard_left" );
	}
	
	m_billboard = GetEnt( "billboard_fall", "targetname" );
	t_billboard = GetEnt( "t_di_billboard", "targetname" );
	
	e_triggerer = undefined;
	while ( !IsPlayer( e_triggerer ) )
	{
		t_billboard waittill( "trigger", e_triggerer );
		
		wait 0.05;
	}
	
	PlayFX( level._effect[ "blockade_explosion" ], t_billboard.origin );
	
	billboard_ragdoll( 1 );
	billboard_ragdoll( 2 );
	billboard_ragdoll( 4 );
	
	m_billboard Delete();
	t_billboard Delete();
	level notify( "fxanim_billboard_pillar_top03_start" );
}

billboard_ragdoll( n_index )
{
	s_target = GetStruct( "billboard_target_" + n_index, "targetname" );
	ai_billboard = GetEnt( "di_billboard_" + n_index + "_ai", "targetname" );
	
	if ( IsAlive( ai_billboard ) )
	{
		v_launch = s_target.origin - ai_billboard.origin;
		ai_billboard _launch_ai( v_launch );
	}
}

drone_intro_glass_building()
{
	trigger_wait( "ts_di_left_0" );
	
	run_scene_first_frame( "di_glass_building" );
	
	trigger_wait( "di_glass_building" );
	
	run_scene( "di_glass_building" );
}

drone_intro_scaffolding()
{
	trigger_wait( "sm_di_scaffolding" );
	
	trigger_use( "di_glass_building" );
	
	run_scene_first_frame( "di_scaffolding_middle" );
	
	level thread run_scene( "di_scaffolding_left" );
	
	level thread drone_intro_path_end();
	
	trigger_wait( "di_scaffolding_middle" );
	
	run_scene( "di_scaffolding_middle" );
}

drone_intro_path_end()
{
	level.vh_player_drone waittill( "di_path_end" );
	
	trigger_use( "di_scaffolding_middle" );
}

escape_intro_hints()
{
	level thread drone_hints();
	
	level waittill( "di_blockade_destroyed" );
	
	screen_message_delete();
	
	// only do this if you are blowing up the blockade the normal way
	if ( !flag( "debug_di_blockade" ) )
	{
		screen_message_create( &"PAKISTAN_SHARED_DRONE_HINT_SWITCH" );
		
		nd_start = GetVehicleNode( "player_soct_path", "targetname" );
		level thread vehicle_switch( nd_start );
	
		level.player.viewlockedentity waittill( "change_seat" );
	
		screen_message_delete();
		
		level notify( "debug_di_blockade" );
		trigger_use( "di_scaffolding_middle" );
		
		flag_wait( "vehicle_switched" );
		
		level notify( "end_vehicle_switch" );
	}
	
	screen_message_create( &"PAKISTAN_SHARED_SOCT_HINT_GAS", &"PAKISTAN_SHARED_SOCT_HINT_STEER" );
	
	trigger_wait( "sm_st_fork" );
	
	screen_message_delete();
	
	trigger_wait( "reverse_brake_hint" );
	
	screen_message_create( &"PAKISTAN_SHARED_SOCT_HINT_REVERSE", &"PAKISTAN_SHARED_SOCT_HINT_BRAKE" );
	
	trigger_wait( "vs_st_surprise" );
	
	screen_message_delete();
}

drone_hints()
{
	level endon( "di_blockade_destroyed" );
	
	screen_message_create( &"PAKISTAN_SHARED_DRONE_HINT_TURRET" );
	
	trigger_wait( "ts_di_left_0" );
	
	wait_to_remove_turret_hint();
	
	screen_message_delete();
	
	wait 3;
	
	screen_message_create( &"PAKISTAN_SHARED_DRONE_HINT_MISSILE" );
	
	wait 3;
	
	level.player waittill_ads_button_pressed();
	
	screen_message_delete();
}

wait_to_remove_turret_hint()
{
	level endon( "turret_hint_done" );
	
	level.player thread wait_for_turret_fire();
	
	trigger_wait( "sm_di_scaffolding" );
	
	level notify( "turret_hint_done" );
}

wait_for_turret_fire()
{
	level endon( "turret_hint_done" );
	
	self waittill_attack_button_pressed();
	
	level notify( "turret_hint_done" );
}

// self == blockade
drone_intro_blockade()
{	
	self.n_damage_total = 0;
	
	const n_damage_max = 8000;
	
	trigger_wait( "sm_di_scaffolding" );
	
	b_blockade_destroyed = false;
	
	while ( !b_blockade_destroyed )
	{
		self waittill( "damage", n_damage, e_attacker );
		
		if ( e_attacker == level.player )
		{
			self.n_damage_total += n_damage;
		}
		
		// blow up the blockade if it is over the max damage and it is shot by the player
		if ( self.n_damage_total > n_damage_max )
		{
			level notify( "di_blockade_destroyed" );
			s_blockade_obj = getstruct( "blockade_obj", "targetname" );
			PlayFX( level._effect[ "blockade_explosion" ], s_blockade_obj.origin );
			a_blockades = GetEntArray( "drone_blockade_01", "targetname" );
			array_delete( a_blockades );
			b_blockade_destroyed = true;
		}
	}
	
	self thread remove_targets_at_drone_intro();
	
	// only do this if you are blowing up the blockade the normal way
	if ( !flag( "debug_di_blockade" ) )
	{
		level.player.viewlockedentity waittill( "change_seat" );
	}
	
	level notify( "player_changed_seat" );
		
	nd_salazar_start = GetVehicleNode( "salazar_path", "targetname" );
	level.vh_salazar_soct thread go_path( nd_salazar_start );
	level thread salazar_run_into_scaffolding();
		
	wait 1; // give salazar a head start
		
	level.vh_salazar_soct thread salazar_soct_speed_control();
	
	self Delete();
}

remove_targets_at_drone_intro()
{
	a_enemies = GetAIArray( "axis" );
	foreach ( ai_enemy in a_enemies )
	{
		if ( ai_enemy IsTouching( self ) )
		{
			ai_enemy notify( "end_lock_on" );
		}
	}
}

drone_intro_soct_0_logic()
{
	self endon( "death" );
	
	self waittill( "stop_vehicle" );
	
	self SetSpeed( 0 );
	self SetSpeedImmediate( 0 );
}

// self == blockade
debug_di_destroy_blockade()
{
	level endon( "di_blockade_destroyed" );
	
	trigger_wait( "blow_up_blockade" );
	
	self DoDamage( self.health - 1, self.origin, level.player );
	
	flag_set( "debug_di_blockade" );
}

// self == the enemy chicken soc-t
soct_intro_chicken()
{
	self endon( "death" );
	
	self thread soct_intro_chicken_left();
	self thread soct_intro_chicken_right();
	
	//self thread soct_intro_chicken_fail();
	
	self enemy_soct_must_shoot_logic( level.vh_player_soct );
}

// self == the enemy chicken soc-t
soct_intro_chicken_left()
{
	self endon( "death" );
	self endon( "swerved_right" );
	
	nd_swerve = GetVehicleNode( "chicken_swerve", "targetname" );
	nd_dest = GetVehicleNode( "chicken_dest_left", "targetname" );
	
	trigger_wait( "chicken_swerve_left" );
	
	self notify( "swerved_left" );
	
//	IPrintLnBold( "Watch Out!" );
	
	self SetSwitchNode( nd_swerve, nd_dest );
	
	self waittill( "chicken_swerve" );
	
	self SetBrake( true );
	self SetSpeed( 0, 60, 60 );
}

// self == the enemy chicken soc-t
soct_intro_chicken_right()
{
	self endon( "death" );
	self endon( "swerved_left" );
	
	nd_swerve = GetVehicleNode( "chicken_swerve", "targetname" );
	nd_dest = GetVehicleNode( "chicken_dest_right", "targetname" );
	
	trigger_wait( "chicken_swerve_right" );
	
	self notify( "swerved_right" );
	
//	IPrintLnBold( "Swerve Left!" );
	
	self SetSwitchNode( nd_swerve, nd_dest );
	
	self waittill( "chicken_swerve" );
	
	self SetBrake( true );
	self SetSpeed( 0, 60, 60 );
}

soct_intro_chicken_fail()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "veh_collision", location, normal, intensity, type, ent );
		
		if ( IsDefined( ent ) && ent.targetname == "player_soc_t" )
		{
			IPrintLnBold( "chicken fail" );
		}
		
		wait 0.05;
	}
}

salazar_run_into_scaffolding()
{
	trigger_wait( "collapse_scaffolding" );
	
	level notify( "fxanim_scaffold_collapse_start" );
}

soct_intro_change_speed()
{
	trigger_wait( "st_middle" );
	
	self.n_speed_max = 89;
	
	self waittill( "escape_battle_drone_start" );
	
	self.n_speed_max = 71;
}