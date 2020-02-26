#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_horse;
#include maps\_turret;
#include maps\_ai_rappel;
#include maps\_vehicle_aianim;
#include maps\_dialog;


init_flags()
{
	//wave2 bp2
	flag_init( "zhao_at_bp2" );
	flag_init( "dropoff1_complete" );
	flag_init( "dropoff2_complete" );
	flag_init( "dropoff3_complete" );
	flag_init( "dropoff4_complete" );
	flag_init( "spawn_vehicles" );
	flag_init( "spawn_boss_bp2" );
	flag_init( "attack_crew_bp2" );
	flag_init( "attack_cache_bp2" );
	flag_init( "cache_destroyed_bp2" );
	flag_init( "muj_charge" );
	flag_init( "horse_at_bp2hitch" );
	flag_init( "bp2_exit" );
	flag_init( "left_bp2" );
	
	//wave2 bp3
	flag_init( "zhao_at_bp3" );
	flag_init( "shoot_rider" );
	flag_init( "rider_shot" );
	flag_init( "spawn_bridge_crossers" );
	flag_init( "crew_inplace_bp3" );
	flag_init( "crew_gone_bp3" );
	flag_init( "attack_crew_bp3" );
	flag_init( "attack_cache_bp3" );
	flag_init( "cache_destroyed_bp3" );
	flag_init( "bp3_exit" );
	
	//wave2 shared
	flag_init( "wave2_started" );
	flag_init( "wave2_done" );
}


skipto_wave2()
{
	skipto_setup();
	
	init_hero( "zhao" );
	
	init_weapon_cache();
	
	level.zhao = getent( "zhao_ai", "targetname" );
	
	level.zhao SetCanDamage( false );
	
	//level thread maps\_unit_command::load();
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		start_teleport( "skipto_wave2bp2", level.heroes );
		
		t_horses = getent( "spawn_wave2bp2_horses", "targetname" );
		t_horses notify( "trigger" );
		
		wait 0.1;
	
		level.horse_zhao = getent( "zhao_horse_wave2bp2", "targetname" );
		level.player_horse = getent( "player_horse_wave2bp2", "targetname" );
	}
	
	else
	{
		start_teleport( "skipto_wave2", level.heroes );
		
		t_horses = getent( "spawn_wave2_horses", "targetname" );
		t_horses notify( "trigger" );
		
		wait 0.1;
	
		level.horse_zhao = getent( "zhao_horse_bp2", "targetname" );
		level.player_horse = getent( "player_horse_bp2", "targetname" );
	}
	
	level.player_horse MakeVehicleUsable();
		
	level.zhao enter_vehicle( level.horse_zhao );
	
	wait 0.1;
	
	level.horse_zhao thread zhao_bp2_skipto();
}


zhao_bp2_skipto()
{
	self SetVehicleAvoidance( true );
	self SetCanDamage( false );
	
	self notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.horse_zhao );
	
	level.player_horse waittill( "enter_vehicle", player );
	
	self thread maps\afghanistan_wave_1::zhao_goto_wave2();
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
main()
{
	level.n_current_wave = 2;
		
	if ( level.wave2_loc == "blocking point 2" )
	{
		level thread wave2_bp2_main();
	}
	
	else
	{
		level thread wave2_bp3_main();
	}
	
	flag_wait( "wave2_done" );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WAVE 2: BLOCKING POINT 2 //////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
wave2_bp2_main()
{
	init_wave2bp2_setup();
	init_spawn_funcs_wave2_bp2();
	wave2_bp2();
}


init_wave2bp2_setup()
{
	level.horse_zhao SetCanDamage( false );
}


init_spawn_funcs_wave2_bp2()
{
	add_spawn_function_veh( "bp2_hip_dropoff", ::hip_dropoff_logic );
	add_spawn_function_veh( "tank_wave2bp2", ::bp2wave2_tank_logic );
	add_spawn_function_veh( "hind_wave2bp2", ::bp2wave2_hind_logic );
	add_spawn_function_veh( "bp2_ramp_horse", ::bp2_ramp_horse_logic );
	add_spawn_function_veh( "bp2_cache_horse", ::bp2_cache_horse_logic );
		
	add_spawn_function_group( "bp2_dropoff1", "targetname", ::bp2_dropoff_logic, "dropoff1_complete", "dropoff_cache_node" );
	add_spawn_function_group( "bp2_dropoff3", "targetname", ::bp2_dropoff_logic, "dropoff3_complete", "dropoff_hump_node" );
	add_spawn_function_group( "bp2_dropoff4", "targetname", ::bp2_dropoff_logic, "dropoff4_complete", "dropoff_stand_node" );
	add_spawn_function_group( "bp2_soviet", "targetname", ::bp2_soviet_logic );
	add_spawn_function_group( "hip1_wave2bp2_rappel1", "targetname", ::bp2_rappeller_logic );
	add_spawn_function_group( "hip1_wave2bp2_rappel2", "targetname", ::bp2_rappeller_logic );
	add_spawn_function_group( "hip1_wave2bp2_rappel3", "targetname", ::bp2_rappeller_logic );
	add_spawn_function_group( "hip1_wave2bp2_rappel4", "targetname", ::bp2_rappeller_logic );
	add_spawn_function_group( "hip2_wave2bp2_rappel1", "targetname", ::bp2_rappeller_logic );
	add_spawn_function_group( "hip2_wave2bp2_rappel2", "targetname", ::bp2_rappeller_logic );
	add_spawn_function_group( "hip2_wave2bp2_rappel3", "targetname", ::bp2_rappeller_logic );
	add_spawn_function_group( "hip2_wave2bp2_rappel4", "targetname", ::bp2_rappeller_logic );
	
	add_spawn_function_group( "bp2_muj_defend", "targetname", ::muj_bp2defend_logic );
	add_spawn_function_group( "muj_reinforce_bp2", "targetname", ::reinforce_bp2_logic );
	add_spawn_function_group( "bp2wave2_muj_stinger", "targetname", ::cliffside_fxanim );
}


wave2_bp2()
{
	level.n_veh_wave2bp2 = RandomInt( 3 );
	
	level.n_bp2_veh_destroyed = 0;
		
	level.horse_zhao thread zhao_wave2_bp2();
	
	trigger_wait( "spawn_wave2_bp2" );
	
	if ( level.n_current_wave == 3 )
	{
		flag_set( "wave3_started" );
	}
	
	flag_set( "wave2_started" );
	
	flag_set( "stop_arena_explosions" );
	
	autosave_by_name( "wave2bp2_start" );
	
	cleanup_ai_bp2wave2();
	
	trigger_use( "trigger_hip_dropoff" );
	
	level thread monitor_wave2bp2_enemies();
	level thread muj_horse_lineup();
	level thread bp2_replenish_arena();
	level thread cliffside_fxanim();
	
	if ( level.n_current_wave == 2 )
	{
		while ( level.n_bp2_veh_destroyed < 3 )
		{
			wait 1;
		}
		
		flag_set( "wave2_done" );
		
		set_objective( level.OBJ_AFGHAN_BP2, undefined, "done" );
		
		set_objective( level.OBJ_FOLLOW, level.zhao, "follow" );
	}
	
	else if ( level.n_current_wave == 3 )
	{
		flag_set( "player_at_bp2wave3" );
		
		while ( level.n_bp2_veh_destroyed < 4 )
		{
			wait 1;
		}
		
		flag_set( "bp2wave3_done" );
	}
}


bp2_vehicle_destroyed()
{
	self waittill( "death" );
	
	level.n_bp2_veh_destroyed++;
	
	if ( level.n_bp2_veh_destroyed && !flag( "spawn_boss_bp2" ) )
	{
		flag_set( "spawn_boss_bp2" );	
	}
	
	autosave_by_name( "bp2_vehicle_destroyed" );
}


cliffside_fxanim()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self waittill( "goal" );
	
	 e_stinger = GetEnt( "bp2wave2_stinger_target", "targetname" );
	 	 
	 level thread trigger_cliffside_fxanim();
	
	if ( IsDefined( e_stinger ) )
	{
		self aim_at_target( e_stinger );
		wait 5;
		MagicBullet( "stinger_sp", self GetTagOrigin( "tag_flash" ), e_stinger.origin );
		wait 1;
		self stop_aim_at_target();
	}
}


trigger_cliffside_fxanim()
{
	b_triggered = false;
	
	m_clip = GetEnt( "bp2wave2_cliffside_clip", "targetname" );
	
	m_clip SetCanDamage( true );
	
	while( !b_triggered )
	{
		m_clip waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( type == "MOD_PROJECTILE" )
		{
			level notify( "fxanim_cliff_collapse_start" );
			b_triggered = true;
		}
	}
}


bp2_backup_horse()
{
	s_spawnpt = getstruct( "bp2_hitch", "targetname" );
	
	horse = spawn_vehicle_from_targetname( "backup_horse" );
	horse.origin = s_spawnpt.origin;
	horse.angles = s_spawnpt.angles;
	
	horse SetNearGoalNotifyDist( 200 );
			
	horse MakeVehicleUsable();
	
	horse Godon();
}


bp2_replenish_arena()
{
	trigger_wait( "bp2_commit" );
	
	trigger_wait( "bp2_replenish_arena" );
	
	if ( !flag( "wave2_done" ) )
	{
		level thread replenish_bp2();
	}
	
	//TODO - move
	flag_set( "bp2_exit" );
	
	flag_set( "left_bp2" );
	
	spawn_manager_disable( "manager_bp2_soviet" );
	spawn_manager_disable( "manager_reinforce_bp2" );
	
	wait 0.1;
	
	cleanup_bp_ai();
	respawn_arena();
}


replenish_bp2()
{
	trigger_wait( "replenish_bp2" );
	
	cleanup_arena();
	
	flag_clear( "left_bp2" );
	
	wait 0.1;
	
	spawn_manager_enable( "manager_bp2_soviet" );
	spawn_manager_enable( "manager_reinforce_bp2" );
	
	level thread bp2_replenish_arena();
}


zhao_wave2_bp2()  //self = level.horse_zhao
{
	flag_wait( "zhao_at_bp2" );
	
	flag_wait( "dropoff1_complete" );
	
	self thread zhao_circle_bp2();
	
	flag_wait( "wave2_done" );
	
	self thread zhao_goto_bp2exit();
}


zhao_circle_bp2()  //self = level.horse_zhao
{
	level endon( "wave2_done" );
		
	s_goal = getstruct( "zhao_bp2_goal1", "targetname" );
	s_end = getstruct( "zhao_cache", "targetname" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( self );
	
	self SetVehicleAvoidance( true );
	
	self SetNearGoalNotifyDist( 200 );
	
	self SetBrake( false );
	
	self SetSpeed( 24, 15, 10 );
	
	while( !flag( "spawn_vehicles" ) )
	{
		self setvehgoalpos( s_goal.origin, 0, true );
		self waittill_any( "goal", "near_goal" );
		
		s_goal = getstruct( s_goal.target, "targetname" );
	}
	
	self ClearVehGoalPos();
	
	wait 1;
	
	self SetVehGoalPos( s_end.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	level.zhao notify( "stop_riding" );
	
	self SetBrake( true );
	
	self notify( "unload" );
	
	level.zhao.fixednode = false;
}


zhao_goto_bp2exit()  //self = level.horse_zhao
{
	s_bp2_exit = getstruct( "zhao_bp2_exit", "targetname" );
	
	wait 1;
	iprintlnbold( "Mason!  We've got enemy troops at blocking points one and three!" );
	wait 2;
	iprintlnbold( "Pick one and let's go!" );
	
	while( !level.horse_zhao.riders.size )
	{
		level.zhao run_to_vehicle( level.horse_zhao );
		
		wait 1;
	}
	
	self notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.horse_zhao );
	
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	
	self SetVehGoalPos( s_bp2_exit.origin, 1, true );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "bp2_exit" );
	
	self SetBrake( false );
	
	self thread maps\afghanistan_wave_3::zhao_goto_wave3();
}


zhao_goto_bp3()
{
	while( Distance2D( level.zhao.origin, level.player.origin ) > 750 )
	{
		wait 1;
	}
	
	level.zhao enter_vehicle( level.horse_zhao );
	
	wait 0.1;
	
	level.horse_zhao notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.horse_zhao );
	
	s_zhao_bp3 = getstruct( "zhao_bp3", "targetname" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	self SetVehGoalPos( s_zhao_bp3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	level.zhao notify( "stop_riding" );
	
	flag_set( "zhao_at_bp3" );
}


muj_horse_lineup()
{
	trigger_wait( "trigger_bp2_horses" );
	
	level thread bp2_backup_horse();
	level thread spawn_horse_lineup();
	
	trigger_wait( "lookat_horse_lineup" );
	
	flag_set( "muj_charge" );
}


spawn_horse_lineup()
{
	wait 0.3;
	
	trigger_use( "trigger_bp2_horses2" );
	
	wait 0.3;
	
	trigger_use( "trigger_bp2_horses3" );
	
	wait 0.3;
	
	trigger_use( "trigger_bp2_horses4" );
}


monitor_wave2bp2_enemies()
{
	flag_wait_all( "dropoff1_complete", "dropoff2_complete", "dropoff3_complete", "dropoff4_complete" );
	
	level thread monitor_bp2_defenders();
	
	waittill_ai_group_ai_count( "group_dropoff", 5 );
	
	if ( !flag( "left_bp2" ) )
	{
		spawn_manager_enable( "manager_bp2_soviet" );
	}
	
	waittill_spawn_manager_spawned_count( "manager_bp2_soviet", 7 );
	
	autosave_by_name( "bp2_vehicle_spawned" );
	
	flag_set( "spawn_vehicles" );
	
	m_damage = GetEnt( "bp2_cache_accumulator", "targetname" );
	
	level thread monitor_weapons_cache( m_damage );
	level thread wave2bp2_vehicle_spawn();
	
	flag_wait( "wave2_done" );
	
	spawn_manager_disable( "manager_bp2_soviet" );
}


monitor_bp2_defenders()
{
	flag_wait_or_timeout( "muj_charge", 15 );
	
	if ( !flag( "muj_charge" ) )
	{
		flag_set( "muj_charge" );
	}
	
	waittill_ai_group_ai_count( "group_horse_defender", 4 );
	
	if ( !flag( "left_bp2" ) )
	{
		spawn_manager_enable( "manager_reinforce_bp2" );
	}
	
	waittill_spawn_manager_spawned_count( "manager_reinforce_bp2", 12 );
	
	flag_set( "attack_cache_bp2" );
	
	flag_wait( "wave2_done" );
	
	spawn_manager_disable( "manager_reinforce_bp2" );
}


wave2bp2_vehicle_spawn()
{
	if ( level.n_veh_wave2bp2 == 0 )
	{
		level thread spawn_hip1_wave2bp2();
		wait 3;
		level thread spawn_hip2_wave2bp2();
	}
	
	else if ( level.n_veh_wave2bp2 == 1 )
	{
		level thread spawn_btr1_wave2bp2();
		wait 3;
		level thread spawn_btr2_wave2bp2();
	}
	
	else
	{
		level thread spawn_hip1_wave2bp2();
		wait 3;
		level thread spawn_btr1_wave2bp2();
	}
	
	level thread bp2wave2_spawn_boss();
}


spawn_hip1_wave2bp2()
{
	s_spawnpt = getstruct( "wave2bp2_hip1_spawnpt", "targetname" );
		
	vh_hip = spawn_vehicle_from_targetname( "wave2bp2_hip" );
	vh_hip.origin = s_spawnpt.origin;
	vh_hip.angles = s_spawnpt.angles;
	vh_hip thread bp2wave2_hip1_logic();
}


spawn_hip2_wave2bp2()
{
	s_spawnpt = getstruct( "wave2bp2_hip2_spawnpt", "targetname" );
		
	vh_hip = spawn_vehicle_from_targetname( "wave2bp2_hip" );
	vh_hip.origin = s_spawnpt.origin;
	vh_hip.angles = s_spawnpt.angles;
	vh_hip thread bp2wave2_hip2_logic();
}


spawn_btr1_wave2bp2()
{
	s_spawnpt = getstruct( "wave2bp2_btr1_spawnpt", "targetname" );
		
	vh_btr = spawn_vehicle_from_targetname( "wave2bp2_btr" );
	vh_btr.origin = s_spawnpt.origin;
	vh_btr.angles = s_spawnpt.angles;
	vh_btr thread bp2wave2_btr1_logic();
}


spawn_btr2_wave2bp2()
{
	s_spawnpt = getstruct( "wave2bp2_btr2_spawnpt", "targetname" );
		
	vh_btr = spawn_vehicle_from_targetname( "wave2bp2_btr" );
	vh_btr.origin = s_spawnpt.origin;
	vh_btr.angles = s_spawnpt.angles;
	vh_btr thread bp2wave2_btr2_logic();
}


bp2wave2_spawn_boss()
{
	flag_wait_or_timeout( "spawn_boss_bp2", 10 );
	
	if ( cointoss() )
	{
		trigger_use( "spawn_hind_bp2" );
	}
	
	else
	{
		trigger_use( "spawn_tank_bp2" );
	}
	
	wait 3;
	
	if ( level.n_current_wave == 3 )
	{
		if ( cointoss() )
		{
			level thread maps\afghanistan_wave_3::spawn_hind_bp2wave3();
		}
	
		else
		{
			level thread maps\afghanistan_wave_3::spawn_tank_bp2wave3();
		}	
	}
}


bp2_ramp_horse_logic()
{
	self endon( "death" );
	self endon( "got_rider" );
	
	self thread make_horse_usable();
	
	if ( self.script_noteworthy == "muj_horse1_ramp" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_ramp1", "targetname" );
	}
	
	else if ( self.script_noteworthy == "muj_horse2_ramp" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_ramp2", "targetname" );
	}
	
	else if ( self.script_noteworthy == "muj_horse3_ramp" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_ramp3", "targetname" );
	}
	
	else if ( self.script_noteworthy == "muj_horse4_ramp" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_ramp4", "targetname" );
	}
	
	nd_hilltop.gateopen = false;
	
	flag_wait_or_timeout( "muj_charge", 8 );
		
	nd_hilltop.gateopen = true;
	
	wait RandomFloatRange( 0.5, 1.5 );
	
	self ResumeSpeed( 15 );
	
	self waittill( "reached_end_node" );
	
	self notify( "unload" );
	
	if ( IsDefined( self.riders[0] ) )
	{
		wait 5;
	}
	
	s_end = getstruct ( "skipto_wave2", "targetname" );
	
	self vehicle_detachfrompath();
	
	self ClearVehGoalPos();
	
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	self SetSpeed( 20, 15, 10 );
	self SetVehGoalPos( s_end.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	//TODO - make sure player doesn't see
	self delete();
}


bp2_cache_horse_logic()
{
	self endon( "death" );
	self endon( "got_rider" );
	
	self thread make_horse_usable();
	
	s_end = getstruct ( "skipto_wave2bp2", "targetname" );
	
	if ( self.script_noteworthy == "muj_horse1_cache" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_cache1", "targetname" );
	}
	
	if ( self.script_noteworthy == "muj_horse2_cache" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_cache2", "targetname" );
	}
	
	else if ( self.script_noteworthy == "muj_horse3_cache" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_cache3", "targetname" );
	}
	
	else if ( self.script_noteworthy == "muj_horse4_cache" )
	{
		nd_hilltop = GetVehicleNode( "hilltop_cache4", "targetname" );
	}
	
	nd_hilltop.gateopen = false;
	
	flag_wait_or_timeout( "muj_charge", 8 );
	
	nd_hilltop.gateopen = true;
	
	wait RandomFloatRange( 0.5, 1.5 );
	
	self ResumeSpeed( 15 );
	
	self waittill( "reached_end_node" );
	
	self notify( "unload" );
	
	if ( IsDefined( self.riders[0] ) )
	{
		wait 5;
	}
	
	self vehicle_detachfrompath();
	
	self ClearVehGoalPos();

	self SetBrake( false );
	self SetNearGoalNotifyDist( 200 );
	self SetSpeed( 20, 15, 10 );
	self SetVehGoalPos( s_end.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	//TODO - make sure player doesn't see
	self delete();
}


muj_bp2defend_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	self.ignoreme = true;
	
	self waittill( "enter_vehicle", vehicle );
	
	vehicle notify( "groupedanimevent", "ride" );
	
	flag_wait( "muj_charge" );
	
	self maps\_horse_rider::ride_and_shoot( vehicle );
	
	self.ignoreme = false;
}


reinforce_bp2_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	if ( cointoss() )
	{
		vh_horse = spawn_vehicle_from_targetname( "bp2_reinforce_horse" );
	
		self enter_vehicle( vh_horse );
	
		wait 0.1;
		
		vh_horse notify( "groupedanimevent", "ride" );
	
		self maps\_horse_rider::ride_and_shoot( vh_horse );
	
		vh_horse thread reinforce_horse_logic( self );
	
		self waittill( "exit_vehicle" );
	}
	
	n_goal = RandomInt( 3 );
	
	if ( n_goal == 0 )
	{
		self set_spawner_targets( "bp2_ramp_defend" );
	}
	
	else if ( n_goal == 1 )
	{
		self set_spawner_targets( "bp2_cache_defend" );
	}
	
	else
	{
		self set_spawner_targets( "dropoff_rappel_node" );
	}
}


reinforce_horse_logic( ai_rider )
{
	self endon( "death" );
	self endon( "got_rider" );
	
	self SetVehicleAvoidance( true );
	
	self thread make_horse_usable();
	
	n_goal = RandomInt( 3 );
	
	if ( n_goal == 0 )
	{
		s_goal = getstruct( "muj_reinforce_ramp", "targetname" );
	}
	
	else if ( n_goal == 1 )
	{
		s_goal = getstruct( "muj_reinforce_cache", "targetname" );
	}
	
	else
	{
		s_goal = getstruct( "muj_reinforce_tower", "targetname" );
	}
	
	self SetNearGoalNotifyDist( 200 );
	
	self SetSpeed( 20, 15, 10 );
	self SetVehGoalPos( s_goal.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	ai_rider notify( "stop_riding" );
	
	self notify( "unload" );
	
	if ( IsDefined( self.riders[0] ) )
	{
		wait 5;
	}
	
	s_end = getstruct( "skipto_wave2bp2", "targetname" );
	
	self SetBrake( false );
	
	self ClearVehGoalPos();
	
	self SetSpeed( 20, 15, 10 );
	self SetVehGoalPos( s_end.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	//TODO - make sure player doesn't see
	self delete();
}


/* ------------------------------------------------------------------------------------------
	Begin Hip Functions
-------------------------------------------------------------------------------------------*/
hip_dropoff_logic()
{
	self endon( "death" );
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	s_goal1 = getstruct( "hip_dropoff_goal1", "targetname" );
	s_goal2 = getstruct( "hip_dropoff_goal2", "targetname" );
	s_goal3 = getstruct( "hip_dropoff_goal3", "targetname" );
	s_goal4 = getstruct( "hip_dropoff_goal4", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetSpeed( 35, 20, 10 );
	self SetVehGoalPos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	if ( self.script_noteworthy == "hip1_dropoff" )
	{
		self thread set_dropoff_flag_ondeath( "dropoff1_complete" );
		
		s_goal1 = getstruct( "hip1_dropoff_goal1", "targetname" );
	}
	
	else if ( self.script_noteworthy == "hip2_dropoff" )
	{
		self thread set_dropoff_flag_ondeath( "dropoff2_complete" );
		
		s_goal0 = getstruct( "hip2_dropoff_goal0", "targetname" );
		s_goal1 = getstruct( "hip2_dropoff_goal1", "targetname" );
		
		self SetSpeed( 20, 15, 10 );
		self SetVehGoalPos( s_goal0.origin, 0 );
		self waittill_any( "goal", "near_goal" );
	}
	
	else if ( self.script_noteworthy == "hip3_dropoff" )
	{
		self thread set_dropoff_flag_ondeath( "dropoff3_complete" );
		
		s_goal1 = getstruct( "hip3_dropoff_goal1", "targetname" );
	}
	
	else
	{
		self thread set_dropoff_flag_ondeath( "dropoff4_complete" );
		
		s_goal0 = getstruct( "hip4_dropoff_goal0", "targetname" );
		s_goal1 = getstruct( "hip4_dropoff_goal1", "targetname" );
		
		self SetSpeed( 20, 15, 10 );
		self SetVehGoalPos( s_goal0.origin, 0 );
		self waittill_any( "goal", "near_goal" );
	}
	
	self SetSpeed( 20, 15, 10 );
	self SetVehGoalPos( s_goal1.origin, 1 );
	self waittill_any( "goal", "near_goal" );
		
	self SetSpeedImmediate( 0, 25, 20 );
	
	if ( self.script_noteworthy == "hip1_dropoff" )
	{
		wait 2;
		spawn_manager_enable( "manager_bp2_dropoff1" );
		waittill_spawn_manager_complete( "manager_bp2_dropoff1" );
		flag_set( "dropoff1_complete" );
	}
	
	else if ( self.script_noteworthy == "hip2_dropoff" )
	{
		wait 2;
		self bp2_dropoff_rappel();
		flag_set( "dropoff2_complete" );
		wait 1;
	}
	
	else if ( self.script_noteworthy == "hip3_dropoff" )
	{
		wait 2;
		spawn_manager_enable( "manager_bp2_dropoff3" );
		waittill_spawn_manager_complete( "manager_bp2_dropoff3" );
		flag_set( "dropoff3_complete" );
	}
	
	else
	{
		wait 2;
		spawn_manager_enable( "manager_bp2_dropoff4" );
		waittill_spawn_manager_complete( "manager_bp2_dropoff4" );
		flag_set( "dropoff4_complete" );
	}
	
	self SetSpeed( 80, 15, 10 );
	self SetVehGoalPos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self delete();
}


bp2wave2_hip1_logic()
{
	self endon( "death" );
	
	self.hip_number = 1;
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self thread bp2_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal1 = getstruct( "hip1_wave2bp2_goal1", "targetname" );
	s_goal2 = getstruct( "hip1_wave2bp2_goal2", "targetname" );
	s_goal3 = getstruct( "hip1_wave2bp2_goal3", "targetname" );
	s_goal4 = getstruct( "hip1_wave2bp2_goal4", "targetname" );
	s_goal5 = getstruct( "hip1_wave2bp2_goal5", "targetname" );
	s_goal6 = getstruct( "hip1_wave2bp2_goal6", "targetname" );
	s_goal7 = getstruct( "hip1_wave2bp2_goal7", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetSpeed( 45, 25, 15 );
	self SetVehGoalPos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal5.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal6.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal7.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 0, 25, 15 );
	
	wait 2;
	
	self bp2_hip_rappel();
	
	wait 2;
	
	s_start = getstruct( "bp2_circle_goal01", "targetname" );
	
	self thread hip_circle( s_start );
	
	flag_wait( "attack_cache_bp2" );
	
	m_damage = GetEnt( "bp2_cache_accumulator", "targetname" );
	self thread hip_attack_cache( m_damage );
	
	flag_wait( "cache_destroyed_bp2" );
	
	self notify( "stop_cache_attack" );
	self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	s_start = getstruct( "bp2_sentry_goal08", "targetname" );
	
	self thread hip_circle( s_start );
}


bp2wave2_hip2_logic()
{
	self endon( "death" );
	
	self.hip_number = 2;
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self thread bp2_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal1 = getstruct( "hip2_wave2bp2_goal1", "targetname" );
	s_goal2 = getstruct( "hip2_wave2bp2_goal2", "targetname" );
	s_goal3 = getstruct( "hip2_wave2bp2_goal3", "targetname" );
	s_goal4 = getstruct( "hip2_wave2bp2_goal4", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetSpeed( 35, 25, 15 );
	self SetVehGoalPos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 20, 15, 10 );
	self SetVehGoalPos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal4.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 0, 25, 15 );
	
	wait 2;
	
	self bp2_hip_rappel();
	
	wait 1;
	
	s_start = getstruct( "bp2_circle_goal01", "targetname" );
	
	self thread hip_circle( s_start );
	
	flag_wait( "attack_cache_bp2" );
	
	m_damage = GetEnt( "bp2_cache_accumulator", "targetname" );
	self thread hip_attack_cache( m_damage );
	
	flag_wait( "cache_destroyed_bp2" );
	
	self notify( "stop_cache_attack" );
	self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	s_start = getstruct( "bp2_sentry_goal08", "targetname" );
	
	self thread hip_circle( s_start );
}


bp2_dropoff_rappel()
{	
	sp_rappell1 = GetEnt( "bp2_dropoff_rappel1", "targetname" );
	sp_rappell2 = GetEnt( "bp2_dropoff_rappel2", "targetname" );
	sp_rappell3 = GetEnt( "bp2_dropoff_rappel3", "targetname" );
	sp_rappell4 = GetEnt( "bp2_dropoff_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	rappeller1 = sp_rappell1 spawn_ai( true );
	wait 0.3;
	rappeller2 = sp_rappell2 spawn_ai( true );
	wait 1.3;
	rappeller3 = sp_rappell3 spawn_ai( true );
	wait 1.4;
	rappeller4 = sp_rappell4 spawn_ai( true );
	
	rappeller1.overrideActorKilled =::runover_by_horse_callback;
	rappeller2.overrideActorKilled =::runover_by_horse_callback;
	rappeller3.overrideActorKilled =::runover_by_horse_callback;
	rappeller1.overrideActorKilled =::runover_by_horse_callback;
}


bp2_dropoff_logic( str_waitflag, str_node )
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	flag_wait( str_waitflag );
	
	self set_spawner_targets( str_node );
}


bp2_rappeller_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}


bp2_soviet_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	if ( self.script_noteworthy == "bp2_soviet_cave1" )
	{
		if ( cointoss() )
		{
			self set_spawner_targets( "bp2_ledge_right" );
		}
		else
		{
			self set_spawner_targets( "dropoff_rappel_node" );
		}
	}
	
	else if ( self.script_noteworthy == "bp2_soviet_cave2" )
	{
		if ( cointoss() )
		{
			self set_spawner_targets( "bp2_ledge_left" );
		}
		else
		{
			self set_spawner_targets( "dropoff_rappel_node" );
		}
	}
	
	else if ( self.script_noteworthy == "bp2_soviet_trail1" )
	{
		self set_spawner_targets( "dropoff_rappel_node" );
	}
	
	else
	{
		self set_spawner_targets( "dropoff_hump_node" );
	}
}


bp2_hip_rappel()
{	
	if ( self.hip_number == 1 )
	{
		sp_rappell1 = GetEnt( "hip1_wave2bp2_rappel1", "targetname" );
		sp_rappell2 = GetEnt( "hip1_wave2bp2_rappel2", "targetname" );
		sp_rappell3 = GetEnt( "hip1_wave2bp2_rappel3", "targetname" );
		sp_rappell4 = GetEnt( "hip1_wave2bp2_rappel4", "targetname" );
	}
	
	else
	{
		sp_rappell1 = GetEnt( "hip2_wave2bp2_rappel1", "targetname" );
		sp_rappell2 = GetEnt( "hip2_wave2bp2_rappel2", "targetname" );
		sp_rappell3 = GetEnt( "hip2_wave2bp2_rappel3", "targetname" );
		sp_rappell4 = GetEnt( "hip2_wave2bp2_rappel4", "targetname" );
	}
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -125 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -125 );
	
	sp_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	sp_rappell1 spawn_ai( true );
	wait 0.3;
	sp_rappell2 spawn_ai( true );
	wait 1.3;
	sp_rappell3 spawn_ai( true );
	wait 1.4;
	sp_rappell4 spawn_ai( true );
}


hip_attack_cache( m_damage )
{
	self endon( "death" );
	self endon( "stop_cache_attack" );
			
	self disable_turret( 2 );
		
	while( 1 )
	{
		self thread shoot_turret_at_target( m_damage, 10, ( 0, 0, 0 ), 2, false );
		
		wait 8;
	}
}
/* ------------------------------------------------------------------------------------------
	End Hip Functions
-------------------------------------------------------------------------------------------*/


/* ------------------------------------------------------------------------------------------
	Begin BTR Functions
-------------------------------------------------------------------------------------------*/
bp2wave2_btr1_logic()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	self thread bp2_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal01 = getstruct( "bp2_btr1_goal01", "targetname" );
	s_goal02 = getstruct( "bp2_btr1_goal02", "targetname" );
	s_goal03 = getstruct( "bp2_btr1_goal03", "targetname" );
	s_goal04 = getstruct( "bp2_btr1_goal04", "targetname" );
	s_goal05 = getstruct( "bp2_btr1_goal05", "targetname" );
	s_goal06 = getstruct( "bp2_btr1_goal06", "targetname" );
	s_goal07 = getstruct( "bp2_btr1_goal07", "targetname" );
	s_goal08 = getstruct( "bp2_btr1_goal08", "targetname" );
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetBrake( true );
	wait .3;
	self SetBrake( false );
	
	self enable_turret( 1 );
	
	self SetSpeed( 45, 20, 15 );
	self SetVehGoalPos( s_goal01.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 15, 10, 5 );
	self SetVehGoalPos( s_goal02.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal03.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "attack_cache_bp2" );
	
	self SetBrake( false );
	
	self SetVehGoalPos( s_goal04.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal05.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "cache_destroyed_bp2" );
	
	self SetBrake( false );
	
	self SetVehGoalPos( s_goal06.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal07.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal08.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
}


bp2wave2_btr2_logic()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	self thread bp2_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal01 = getstruct( "bp2_btr2_goal01", "targetname" );
	s_goal02 = getstruct( "bp2_btr2_goal02", "targetname" );
	s_goal03 = getstruct( "bp2_btr2_goal03", "targetname" );
	s_goal04 = getstruct( "bp2_btr2_goal04", "targetname" );
	s_goal04a = getstruct( "bp2_btr2_goal04a", "targetname" );
	s_goal05 = getstruct( "bp2_btr2_goal05", "targetname" );
	s_goal06 = getstruct( "bp2_btr2_goal06", "targetname" );
	s_goal07 = getstruct( "bp2_btr2_goal07", "targetname" );
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetBrake( true );
	wait .3;
	self SetBrake( false );
	
	self enable_turret( 1 );
	
	self SetSpeed( 45, 20, 15 );
	self SetVehGoalPos( s_goal01.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 15, 10, 5 );
	self SetVehGoalPos( s_goal02.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal03.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal04.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal04a.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "attack_cache_bp2" );
	
	self SetBrake( false );
	
	self SetVehGoalPos( s_goal05.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "cache_destroyed_bp2" );
	
	self SetBrake( false );
	
	self SetVehGoalPos( s_goal06.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal07.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}
/* ------------------------------------------------------------------------------------------
	End BTR Functions
-------------------------------------------------------------------------------------------*/


/* ------------------------------------------------------------------------------------------
	Begin Tank Functions
-------------------------------------------------------------------------------------------*/
bp2wave2_tank_logic()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	self thread bp2_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_pos1 = getstruct( "bp2_tank_pos1", "targetname" );
	s_pos2 = getstruct( "bp2_tank_pos2", "targetname" );
	s_pos3 = getstruct( "bp2_tank_pos3", "targetname" );
	s_goal01 = getstruct( "bp2_tank_goal01", "targetname" );
	s_goal02 = getstruct( "bp2_tank_goal02", "targetname" );
	s_goal03a = getstruct( "bp2_tank_goal03a", "targetname" );
	s_goal03b = getstruct( "bp2_tank_goal03b", "targetname" );
	s_goal03 = getstruct( "bp2_tank_goal03", "targetname" );
	s_goal04 = getstruct( "bp2_tank_goal04", "targetname" );
	s_goal05 = getstruct( "bp2_tank_goal05", "targetname" );
	weapons_cache = GetEnt( "bp2_cache_accumulator", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetBrake( true );
	wait .3;
	self SetBrake( false );
	
	self enable_turret( 1 );
	
	self thread tank_targetting();
	
	self SetSpeed( 35, 20, 15 );
	self SetVehGoalPos( s_pos1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_pos2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 15, 10, 5 );
	self SetVehGoalPos( s_pos3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal01.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "attack_cache_bp2" );
	
	self SetBrake( false );
	
	self SetVehGoalPos( s_goal02.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal03.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal03a.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal03b.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self thread tank_attack_cache( weapons_cache );
	
	flag_wait( "cache_destroyed_bp2" );
	
	self notify( "cache_destroyed" );
	
	self ClearTargetEntity();
	
	self SetBrake( false );
	
	self SetVehGoalPos( s_goal04.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self SetVehGoalPos( s_goal05.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
		
	self SetBrake( true );
	
	wait 5;
	
	self thread tank_baseattack();
}
/* ------------------------------------------------------------------------------------------
	End Tank Functions
-------------------------------------------------------------------------------------------*/


/* ------------------------------------------------------------------------------------------
	Begin Hind Functions
-------------------------------------------------------------------------------------------*/
bp2wave2_hind_logic()
{
	self endon( "death" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self thread bp2_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal01 = getstruct( "bp2_hind_goal01", "targetname" );
	s_goal02 = getstruct( "bp2_hind_goal02", "targetname" );
	s_goal03 = getstruct( "bp2_hind_goal03", "targetname" );
	s_goal04 = getstruct( "bp2_hind_goal04", "targetname" );
	s_goal05 = getstruct( "bp2_hind_goal05", "targetname" );
	s_goal06 = getstruct( "bp2_hind_goal06", "targetname" );
	s_goal07 = getstruct( "bp2_hind_goal07", "targetname" );
	s_goal08 = getstruct( "bp2_hind_goal08", "targetname" );
	s_goal09 = getstruct( "bp2_hind_goal09", "targetname" );
	s_goal10 = getstruct( "bp2_hind_goal10", "targetname" );
	
	weapons_cache = GetEnt( "bp2_cache_accumulator", "targetname" );
	
	self SetNearGoalNotifyDist( 500 );
	
	self SetSpeed( 100, 50, 15 );
	self SetVehGoalPos( s_goal01.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread hind_strafe();
	
	self SetVehGoalPos( s_goal02.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal03.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "stop_strafe" );
	
	self SetVehGoalPos( s_goal05.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal06.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal07.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal08.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal09.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal10.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self thread bp2_hind_attackpoint();
	
	flag_wait( "attack_cache_bp2" );
	
	self notify( "stop_hind_attack" );
	
	self thread bp2_hind_attack_cache();
	
	flag_wait( "cache_destroyed_bp2" );
	
	self notify( "cache_destroyed" );
	
	s_base = getstruct( "hind_bp3_goal12", "targetname" );
	self ClearLookAtEnt();
	self SetSpeed( 50, 50, 15 );
	
	iprintlnbold( "WE HAVE A HELICOPTER APPROACHING THE BASE" );
	
	self SetVehGoalPos( s_base.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self thread hind_baseattack();
}


bp2_hind_attackpoint()
{
	self endon( "death" );
	self endon( "stop_hind_attack" );
	
	a_s_right = [];
	a_s_right[ 0 ] = getstruct( "bp2_hind_right01", "targetname" );
	a_s_right[ 1 ] = getstruct( "bp2_hind_right02", "targetname" );
	a_s_right[ 2 ] = getstruct( "bp2_hind_right03", "targetname" );
	a_s_right[ 3 ] = getstruct( "bp2_hind_right04", "targetname" );
	
	a_s_left = [];
	a_s_left[ 0 ] = getstruct( "bp2_hind_left01", "targetname" );
	a_s_left[ 1 ] = getstruct( "bp2_hind_left02", "targetname" );
	a_s_left[ 2 ] = getstruct( "bp2_hind_left03", "targetname" );
	a_s_left[ 3 ] = getstruct( "bp2_hind_left04", "targetname" );
	
	s_attackpt = a_s_right[ RandomInt( a_s_right.size ) ];
	self.loc = "right";
	
	if ( cointoss() )
	{
		s_attackpt = a_s_left[ RandomInt( a_s_left.size ) ];
		self.loc = "left";
	}
	
	e_goal = spawn( "script_origin", s_attackpt.origin );
	
	self setLookAtEnt( e_goal );
	
	self SetSpeed( 100, 50, 15 );
	self SetVehGoalPos( s_attackpt.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	self ClearLookAtEnt();
	
	e_goal Delete();
	
	while( 1 )
	{
		if ( self.loc == "right" )
		{
			s_attackpt = a_s_left[ RandomInt( a_s_left.size ) ];
			self.loc = "left";
		}
		
		else
		{
			s_attackpt = a_s_right[ RandomInt( a_s_right.size ) ];
			self.loc = "right";
		}
		
		e_goal = spawn( "script_origin", s_attackpt.origin );
	
		self setLookAtEnt( e_goal );
		self SetVehGoalPos( s_attackpt.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self ClearLookAtEnt();
		
		e_goal Delete();
		
		self bp2_hind_attack();
	}
}


bp2_hind_attack()
{
	self endon( "death" );
	
	a_enemies = getaiarray( "allies" );
	a_targets = sortbydistance( a_enemies, self.origin );
		
	e_target = level.player;
		
	if ( cointoss() )
	{
		ai_muj = a_targets[ RandomInt( a_targets.size ) ];
		
		if ( IsDefined( ai_muj ) )
		{
			e_target = ai_muj;
		}
		
		else
		{
			e_target = level.player;
		}
	}
	
	self setLookAtEnt( e_target );
	
	//TODO - wait until vehicle faces target
	
	wait 2;
		
	self hind_fireat_target( e_target );
		
	wait RandomFloatRange( 2.0, 3.0 );
	
	self ClearLookAtEnt();
}


bp2_hind_attack_cache()
{
	self endon( "death" );
	self endon( "cache_destroyed" );
	
	s_cache1 = getstruct( "bp2_hind_cache1", "targetname" );
	s_cache2 = getstruct( "bp2_hind_cache2", "targetname" );
	s_cache3 = getstruct( "bp2_hind_cache3", "targetname" );
	s_cache4 = getstruct( "bp2_hind_cache4", "targetname" );
		
	m_weapons_cache = GetEnt( "bp2_cache_accumulator", "targetname" );
	
	self SetSpeed( 100, 50, 15 );
	self SetVehGoalPos( s_cache1.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self setLookAtEnt( m_weapons_cache );
	
	while( 1 )
	{
		self SetVehGoalPos( s_cache2.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		wait 1;
		hind_fireat_target( m_weapons_cache );
			
		self SetVehGoalPos( s_cache3.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		wait 1;
		hind_fireat_target( m_weapons_cache );
		
		self SetVehGoalPos( s_cache4.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		wait 1;
		hind_fireat_target( m_weapons_cache );
		
		self SetVehGoalPos( s_cache3.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		wait 1;
		hind_fireat_target( m_weapons_cache );
		
		self SetVehGoalPos( s_cache2.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		wait 1;
		hind_fireat_target( m_weapons_cache );
		
		self SetVehGoalPos( s_cache1.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		wait 1;
		hind_fireat_target( m_weapons_cache );
	}
}


/* ------------------------------------------------------------------------------------------
	End Hind Functions
-------------------------------------------------------------------------------------------*/



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WAVE 2: BLOCKING POINT 3 //////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
wave2_bp3_main()
{
	event_setup_wave2_bp3();
	init_spawn_funcs_wave2_bp3();
	vehicles_wave2_bp3();
	wave2_bp3();
}


event_setup_wave2_bp3()
{
	t_uaz = getent( "spawn_uaz", "targetname" );
	t_uaz trigger_on();
	
	a_t_hip = GetEntArray( "trigger_hip1_bp3", "script_noteworthy" );
	foreach( t_hip in a_t_hip )
	{
		t_hip trigger_on();
	}
	
	t_boss = getent( "trigger_boss_bp3", "script_noteworthy" );
	t_boss trigger_on();
	
	t_btr = getent( "spawn_btr1_bp3", "script_noteworthy" );
	t_btr trigger_on();
	
	t_boss_bp3 = getent( "spawn_boss_bp3", "script_noteworthy" );
	t_boss_bp3 trigger_on();
	
	//level thread spawn_bp3_cache( "rpg" );
	//level thread spawn_bp3_cache( "stinger" );
}


init_spawn_funcs_wave2_bp3()
{
	add_spawn_function_veh( "horse_defender", ::bp3_horse_logic );
	add_spawn_function_veh( "uaz1_bp3", ::uaz1_logic );
	add_spawn_function_veh( "uaz2_bp3", ::uaz2_logic );
	add_spawn_function_veh( "hip1_bp3", ::bp3wave2_hip1_logic );
	add_spawn_function_veh( "hip2_bp3", ::bp3wave2_hip2_logic );
	add_spawn_function_veh( "btr1_bp3", ::btr1_logic );
	add_spawn_function_veh( "btr2_bp3", ::btr2_logic );
	add_spawn_function_veh( "hind_bp3", ::bp3wave2_hind_logic );
	add_spawn_function_veh( "tank_bp3", ::tank_logic );
	
	add_spawn_function_group( "bp3_horse_rider", "targetname", ::bp3_horserider_logic );
	add_spawn_function_group( "bp3_rider_victim", "script_noteworthy", ::rider_victim_logic );
	add_spawn_function_group( "sniper_bp3", "targetname", ::sniper_logic );
	add_spawn_function_group( "bridge_crosser", "targetname", ::bridge_crosser_logic );
	add_spawn_function_group( "bp3_foot_soldier", "targetname", ::foot_soldier_logic );
	add_spawn_function_group( "bp3_crew_assault", "targetname", ::bp3_crewassault_logic );
	add_spawn_function_group( "bp3_hip_rappel", "script_noteworthy", ::bp3_hip_rappel_logic );
}


vehicles_wave2_bp3()
{
	level.n_vehicles = RandomInt( 3 );
		
	if ( level.n_vehicles == 0 )
	{
		level thread spawn_hip1();
		level thread spawn_hip2();
	}
	
	else if ( level.n_vehicles == 1 )
	{
		level thread spawn_btr1();
		level thread spawn_btr2();
	}
	
	else
	{
		level thread spawn_hip1();
		level thread spawn_btr1();
	}
	
	level thread spawn_boss();
}


wave2_bp3()
{
	level.n_bp3_veh_destroyed = 0;
		
	level.horse_zhao thread zhao_wave2_bp3();
	level thread prelim_vehicles_destroyed();
	level thread monitor_uaz_group();
	level thread spawn_bridge_crossers();
	level thread defenders_bp3();
	level thread monitor_defenders();
	level thread check_for_crew();
	level thread crew_assault_team();
	level thread bp3_replenish_arena();
	level thread bp3_backup_horse();
	level thread fxanim_statue();
	level thread fxanim_bridges();
		
	m_damage = GetEnt( "bp3_cache_accumulator", "targetname" );
	level thread monitor_weapons_cache( m_damage );
	
	sp_sniper = getent( "sniper_bp3", "targetname" );
	bp3_sniper = sp_sniper spawn_ai( true );
	
	trigger_wait( "spawn_wave2_bp3" );
	
	if ( level.n_current_wave == 3 )
	{
		flag_set( "wave3_started" );
	}
	
	flag_set( "wave2_started" );
	
	//TODO - cleanup ai ///////////////////////////////////
	flag_set( "stop_arena_explosions" );	
	spawn_manager_disable( "manager_troops_exit" );
	spawn_manager_disable( "manager_hip3_troops" );
	spawn_manager_disable( "manager_hip4_troops" );
	
	guys = getaiarray( "axis" );
	a_ai_guys = array_exclude( guys, bp3_sniper );
	foreach( guy in a_ai_guys )
	{
		guy delete();
	}
	
	guys = getaiarray( "allies" );
	a_ai_guys = array_exclude( guys, level.zhao );
	a_muj = GetEntArray( "bp3_horse_rider_ai", "targetname" );
	foreach( rider in a_muj )
	{
		a_ai_guys = array_exclude( a_ai_guys, rider );
	}
	
	foreach( muj in a_ai_guys )
	{
		muj delete();
	}
	///////////////////////////////////////////////////////////
	
	spawn_manager_enable( "manager_wave2_bp3" );
	
	if ( level.n_current_wave == 2 )
	{
		while ( level.n_bp3_veh_destroyed < 3 )
		{
			wait 1;
		}
		
		spawn_manager_disable( "manager_wave2_bp3" );
		
		flag_set( "wave2_done" );
		
		set_objective( level.OBJ_AFGHAN_BP3, undefined, "done" );
		
		set_objective( level.OBJ_FOLLOW, level.zhao, "follow" );
	}
	
	else if ( level.n_current_wave == 3 )
	{
		flag_set( "player_at_bp3wave3" );
		
		while ( level.n_bp3_veh_destroyed < 4 )
		{
			wait 1;
		}
		
		flag_set( "bp3wave3_done" );
	}
}


fxanim_bridges()
{
	m_bridge_clip1 = GetEnt( "BP3_bridge_1", "targetname" );
	m_bridge_clip2 = GetEnt( "BP3_bridge_2", "targetname" );
	m_bridge_clip3 = GetEnt( "BP3_bridge_3", "targetname" );
	m_bridge_clip4 = GetEnt( "BP3_bridge_4", "targetname" );
	
	m_bridge1 = GetEnt( "pristine_bridge01_break", "targetname" );
	m_bridge2 = GetEnt( "pristine_bridge02_break", "targetname" );
	m_bridge3 = GetEnt( "pristine_bridge01_long_break", "targetname" );
	m_bridge4 = GetEnt( "pristine_bridge02_long_break", "targetname" );
	
	str_bridge1 = "fxanim_bridge01_break_start";
	str_bridge2 = "fxanim_bridge02_break_start";
	str_bridge3 = "fxanim_bridge01_long_break_start";
	str_bridge4 = "fxanim_bridge02_long_break_start";
	
	m_bridge_clip1 thread trigger_fxanim_bridge( m_bridge1, str_bridge1 );
	m_bridge_clip2 thread trigger_fxanim_bridge( m_bridge2, str_bridge2 );
	m_bridge_clip3 thread trigger_fxanim_bridge( m_bridge3, str_bridge3 );
	m_bridge_clip4 thread trigger_fxanim_bridge( m_bridge4, str_bridge4 );
}


trigger_fxanim_bridge( m_bridge, str_notify )
{
	self.b_triggered = false;

	self SetCanDamage( true );
	
	while( !self.b_triggered )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( ( type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" || type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" ) )
		{
			level notify( str_notify );
			m_bridge Delete();
			self.b_triggered = true;
		}
	}
}


fxanim_statue()
{
	b_triggered = false;
	
	m_clip = GetEnt( "bp3_statue_clip", "targetname" );
	
	m_clip SetCanDamage( true );
	
	while( !b_triggered )
	{
		m_clip waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( type == "MOD_PROJECTILE" )
		{
			level notify( "fxanim_statue_crumble_start" );
			b_triggered = true;
		}
	}
}


bp3_backup_horse()
{
	s_spawnpt = getstruct( "bp3_hitch", "targetname" );
	
	horse = spawn_vehicle_from_targetname( "backup_horse" );
	horse.origin = s_spawnpt.origin;
	horse.angles = s_spawnpt.angles;
	
	horse SetNearGoalNotifyDist( 200 );
			
	horse MakeVehicleUsable();
	
	horse Godon();
}


bp3_replenish_arena()
{
	trigger_wait( "spawn_uaz" );
	
	trigger_wait( "bp3_replenish_arena" );
	
	if ( !flag( "wave2_done" ) )
	{
		level thread replenish_bp3();
	}
	
	flag_set( "bp3_exit" );
	
	spawn_manager_disable( "manager_wave2_bp3" );
	spawn_manager_disable( "manager_bp3_foot" );
	
	wait 0.1;
	
	cleanup_bp_ai();
	respawn_arena();
}


replenish_bp3()
{
	trigger_wait( "replenish_bp3" );
	
	cleanup_arena();
	
	flag_clear( "bp3_exit" );
	
	spawn_manager_enable( "manager_wave2_bp3" );
	spawn_manager_enable( "manager_bp3_foot" );
	
	wait 0.1;
	
	level thread bp3_replenish_arena();
}


defenders_bp3()
{
	trigger_wait( "bp3_defense" );
	
	autosave_by_name( "wave2bp3_start" );
	
	trigger_use( "bp3_horse_defenders" );
	
	spawn_manager_enable( "manager_bp3_foot" );	
}


spawn_bridge_crossers()
{
	flag_wait_any( "spawn_bridge_crossers", "spawn_btr1_bp3" );
	
	spawn_manager_enable( "manager_bridge_crosser" );	
}


prelim_vehicles_destroyed()
{
	while( level.n_bp3_veh_destroyed < 1 )
	{
		wait 1;	
	}
	
	flag_set( "spawn_boss_bp3" );
}


zhao_wave2_bp3()  //self = level.horse_zhao
{
	flag_wait( "zhao_at_bp3" );
	
	self notify( "unload" );
	
	level.zhao notify( "stop_riding" );
	
	level.zhao.fixednode = false;
	
	flag_wait( "wave2_done" );
	
	level.horse_zhao thread zhao_goto_bp3exit();
}


zhao_goto_bp3exit()  //self = level.horse_zhao
{
	s_bp3_exit = getstruct( "zhao_bp3_exit", "targetname" );
	
	wait 1;
	iprintlnbold( "Mason!  We've got enemy troops at blocking points one and two!" );
	wait 2;
	iprintlnbold( "Pick one and let's go!" );
	
	while( !level.horse_zhao.riders.size )
	{
		level.zhao run_to_vehicle( level.horse_zhao );
		
		wait 1;
	}
	
	level.horse_zhao notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.horse_zhao );
	
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	
	self SetVehGoalPos( s_bp3_exit.origin, 1, true );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "bp3_exit" );
	
	self SetBrake( false );
	
	self thread maps\afghanistan_wave_3::zhao_goto_wave3();
}


spawn_hip1()
{
	flag_wait( "spawn_hip1_bp3" );
	
	trigger_use( "spawn_hip1_bp3" );
}


spawn_hip2()
{
	flag_wait( "spawn_hip1_bp3" );
	
	wait 8;
	
	trigger_use( "spawn_hip2_bp3" );
}


spawn_btr1()
{
	flag_wait( "spawn_btr1_bp3" );
	
	trigger_use( "spawn_btr1_bp3" );
}


spawn_btr2()
{
	flag_wait( "spawn_btr1_bp3" );
	
	wait 5;
	
	trigger_use( "spawn_btr2_bp3" );
}


spawn_boss()
{
	flag_wait( "spawn_boss_bp3" );
	
	if ( cointoss() )
	{
		trigger_use( "spawn_tank_bp3" );
	}
	
	else
	{
		trigger_use( "spawn_hind_bp3" );
	}
	
	if ( level.n_current_wave == 3 )
	{
		if ( cointoss() )
		{
			level thread maps\afghanistan_wave_3::spawn_hind_bp3wave3();
		}
	
		else
		{
			level thread maps\afghanistan_wave_3::spawn_tank_bp3wave3();
		}	
	}
}


monitor_defenders()
{
	waittill_spawn_manager_spawned_count( "manager_bp3_foot", 12 );
	
	flag_set( "attack_crew_bp3" );
	
	waittill_spawn_manager_spawned_count( "manager_bp3_foot", 18 );
	
	flag_set( "attack_cache_bp3" );
	flag_set( "spawn_boss_bp3" );
}


/* ------------------------------------------------------------------------------------------
	Spawn function logic
-------------------------------------------------------------------------------------------*/
bp3_horserider_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	self waittill( "enter_vehicle", vehicle );
	
	self thread setup_rider( vehicle );
	
	vehicle notify( "groupedanimevent", "ride" );
	
	self maps\_horse_rider::ride_and_shoot( vehicle );
}


bp3_horse_logic()
{
	self endon( "death" );
	self endon( "got_rider" );
	
	//self thread make_horse_usable();
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	a_s_goals = getstructarray( "horse_bp3_goal", "targetname" );
	a_s_runs = getstructarray( "horse_bp3_runaway", "targetname" );
	
	v_horse_goal = a_s_goals[ RandomInt( a_s_goals.size ) ].origin + ( RandomInt( 100 ), RandomInt( 200 ), 0 );
	
	self SetNearGoalNotifyDist( 100 );
	
	self setspeed( 35, 20, 10 );
	self setvehgoalpos( v_horse_goal, 0, true );
	self waittill_any( "goal", "near_goal" );
	self SetBrake( true );
	
	self notify( "unload" );
	
	if ( IsAlive( self.riders[0] ) )
	{
		self.riders[0] notify( "stop_riding" );
	}
	
	wait RandomFloatRange( 1.5, 2.5 );
	
	v_horse_runaway = a_s_runs[ RandomInt( a_s_runs.size ) ].origin + ( RandomInt( 100 ), RandomInt( 200 ), 0 );
	
	self SetBrake( false );
	
	self setspeed( 15, 5, 2 );
	self setvehgoalpos( v_horse_runaway, 1 );
}


rider_victim_logic()
{
	self endon( "death" );
	
	level.rider_victim = self;
	
	wait 1;
	
	flag_set( "shoot_rider" );
	
	flag_wait( "rider_shot" );
	
	self dodamage( self.health, self.origin );
}


/* ------------------------------------------------------------------------------------------
	Begin Hip Functions
-------------------------------------------------------------------------------------------*/
bp3wave2_hip1_logic()
{
	self endon( "death" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	
	self thread bp3_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_liftoff = getstruct( "hip1_bp3_liftoff", "targetname" );
	s_dropoff = getstruct( "hip1_bp3_dropoff", "targetname" );
	s_ascent = getstruct( "hip1_bp3_ascent", "targetname" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 20, 10 );
	self setvehgoalpos( s_liftoff.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_dropoff.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 0, 25, 20 );
	
	wait 2;
	
	self thread bp3_hip1_rappel();
	
	wait 5;
	
	self setspeed( 100, 20, 10 );
	self setvehgoalpos( s_ascent.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	s_start = getstruct( "hip_bp3_circle01", "targetname" );
	
	self thread hip_circle( s_start );
	
	flag_wait( "attack_cache_bp3" );
	
	m_damage = GetEnt( "bp3_cache_accumulator", "targetname" );
	self thread hip_attack_cache( m_damage );
	
	flag_wait( "cache_destroyed_bp3" );
	
	self notify( "stop_cache_attack" );
	self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	s_start = getstruct( "bp3_sentry_goal07", "targetname" );
	
	self thread hip_circle( s_start );
}


bp3wave2_hip2_logic()
{
	self endon( "death" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	
	self thread bp3_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_liftoff = getstruct( "hip2_bp3_liftoff", "targetname" );
	s_over = getstruct( "hip2_bp3_over", "targetname" );
	s_approach = getstruct( "hip2_bp3_approach", "targetname" );
	s_dropoff = getstruct( "hip2_bp3_dropoff", "targetname" );
	s_away = getstruct( "hip2_bp3_away", "targetname" );
		
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 20, 10 );
	self setvehgoalpos( s_liftoff.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_over.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_approach.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_dropoff.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 0, 25, 20 );
	
	wait 3;
	
	self thread bp3_hip2_rappel();
	
	wait 5;
	
	self setspeed( 100, 20, 10 );
	self setvehgoalpos( s_away.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	s_start = getstruct( "hip_bp3_circle01", "targetname" );
	
	self thread hip_circle( s_start );
	
	flag_wait( "attack_cache_bp3" );
	
	m_damage = GetEnt( "bp3_cache_accumulator", "targetname" );
	self thread hip_attack_cache( m_damage );
	
	flag_wait( "cache_destroyed_bp3" );
	
	self notify( "stop_cache_attack" );
	self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	s_start = getstruct( "bp3_sentry_goal07", "targetname" );
	
	self thread hip_circle( s_start );
}


bp3_hip1_rappel()
{	
	sp_hip1_rappell1 = GetEnt( "bp3_hip1_rappel1", "targetname" );
	sp_hip1_rappell2 = GetEnt( "bp3_hip1_rappel2", "targetname" );
	sp_hip1_rappell3 = GetEnt( "bp3_hip1_rappel3", "targetname" );
	sp_hip1_rappell4 = GetEnt( "bp3_hip1_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip1_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip1_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip1_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip1_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	sp_hip1_rappell1 spawn_ai( true );
	wait 0.3;
	sp_hip1_rappell2 spawn_ai( true );
	wait 1.3;
	sp_hip1_rappell3 spawn_ai( true );
	wait 1.4;
	sp_hip1_rappell4 spawn_ai( true );
}


bp3_hip2_rappel()
{	
	sp_hip1_rappell1 = GetEnt( "bp3_hip2_rappel1", "targetname" );
	sp_hip1_rappell2 = GetEnt( "bp3_hip2_rappel2", "targetname" );
	sp_hip1_rappell3 = GetEnt( "bp3_hip2_rappel3", "targetname" );
	sp_hip1_rappell4 = GetEnt( "bp3_hip2_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip1_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip1_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip1_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip1_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	sp_hip1_rappell1 spawn_ai( true );
	wait 0.3;
	sp_hip1_rappell2 spawn_ai( true );
	wait 1.3;
	sp_hip1_rappell3 spawn_ai( true );
	wait 1.4;
	sp_hip1_rappell4 spawn_ai( true );
}


bp3_hip_rappel_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	self thread force_goal( undefined, 32 );
}


/* ------------------------------------------------------------------------------------------
	End Hip Functions
-------------------------------------------------------------------------------------------*/



/* ------------------------------------------------------------------------------------------
	Begin Hind Functions
-------------------------------------------------------------------------------------------*/
bp3wave2_hind_logic()
{
	self endon( "death" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	
	self thread bp3_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_bridge_target = getstruct( "hind_bridge_target", "targetname" );
	e_target = spawn( "script_origin", s_bridge_target.origin );
	
	s_goal01 = getstruct( "hind_bp3_goal1", "targetname" );
	s_goal02 = getstruct( "hind_bp3_goal2", "targetname" );
	s_goal03 = getstruct( "hind_bp3_goal3", "targetname" );
	s_goal04 = getstruct( "hind_bp3_goal4", "targetname" );
	s_goal05 = getstruct( "hind_bp3_goal5", "targetname" );
	s_goal06 = getstruct( "hind_bp3_goal6", "targetname" );
	s_goal07 = getstruct( "hind_bp3_goal7", "targetname" );
	s_goal08 = getstruct( "hind_bp3_goal8", "targetname" );
					
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 20, 10 );
	self setvehgoalpos( s_goal01.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal02.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal03.origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	self setvehgoalpos( s_goal05.origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	self setvehgoalpos( s_goal06.origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	self SetLookAtEnt( e_target );
		
	self hind_fireat_target( e_target );
		
	self ClearLookAtEnt();
		
	self setvehgoalpos( s_goal07.origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	self setvehgoalpos( s_goal08.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread bp3wave2_hind_attack_pattern();
}


bp3wave2_hind_attack_pattern()
{
	self endon( "death" );
	self endon( "stop_attack_pattern" );
		
	s_goal09 = getstruct( "hind_bp3_goal9", "targetname" );
	s_goal10 = getstruct( "hind_bp3_goal10", "targetname" );
	s_goal11 = getstruct( "hind_bp3_goal11", "targetname" );
	s_goal12 = getstruct( "hind_bp3_goal12", "targetname" );
	s_goal13 = getstruct( "hind_bp3_goal13", "targetname" );
	s_goal14 = getstruct( "hind_bp3_goal14", "targetname" );
	s_goal15 = getstruct( "hind_bp3_goal15", "targetname" );
	
	while( 1 )
	{
		n_index = 8;
		b_divert = false;
	
		if ( cointoss() )
		{
			n_index = 15;
			b_divert = true;
		}
	
		while( 1 )
		{
			if ( !b_divert )
			{
				if ( n_index < 15 )
				{
					n_index++;
				}
				
				else
				{
					self bp3wave2_hind_circle();
					
					break;
				}
			}
			
			else
			{
				if ( n_index > 8 )
				{
					n_index--;
				}
				
				else
				{
					self bp3wave2_hind_circle();
					
					break;
				}
			}
			
			self setvehgoalpos( getstruct( "hind_bp3_goal"+n_index, "targetname" ).origin, 0 );
			self waittill_any( "goal", "near_goal" );
			
			if ( flag( "cache_destroyed_bp3" ) )
			{
				if ( n_index > 7 )
				{
					self thread bp3wave2_hind_flyto_base();
					wait 0.5;
					self notify( "stop_attack_pattern" );
				}
			}
			
			if ( b_divert && ( n_index == 9 || n_index == 12 || n_index == 15 ) )
			{
				self hind_target_and_fire();
			}
			
			if ( n_index == 13 )
			{
				self hind_target_and_fire();
			}
			
			if ( !b_divert && n_index == 14 )
			{
				self hind_target_and_fire();
			}
		}
	}
}


hind_target_and_fire()
{
	self endon( "death" );
	
	a_targets = getaiarray( "allies" );
		
	e_target = level.player;
		
	if ( cointoss() )
	{
		if ( IsDefined( a_targets[ RandomIntRange( 0, a_targets.size ) ] ) )
		{
			e_target = a_targets[ RandomIntRange( 0, a_targets.size ) ];
		}
		
		else
		{
			e_target = level.player;	
		}
	}
	
	if ( flag( "attack_cache_bp3" ) )
	{
		if ( cointoss() )
		{
			m_weapons_cache = GetEnt( "bp3_cache_accumulator", "targetname" );
			e_target = m_weapons_cache;	
		}
		
		else
		{
			e_target = level.player;	
		}
	}
	
	self SetLookAtEnt( e_target );
	
	//TODO - get waittill look
	wait 3;
		
	self hind_fireat_target( e_target );
		
	self ClearLookAtEnt();
}



bp3wave2_hind_circle()
{
	self endon( "death" );
	self endon( "stop_attack_pattern" );
	
	s_goal03 = getstruct( "hind_bp3_goal3", "targetname" );
	s_goal04 = getstruct( "hind_bp3_goal4", "targetname" );
	s_goal05 = getstruct( "hind_bp3_goal5", "targetname" );
	s_goal06 = getstruct( "hind_bp3_goal6", "targetname" );
	s_goal07 = getstruct( "hind_bp3_goal7", "targetname" );
	s_goal08 = getstruct( "hind_bp3_goal8", "targetname" );
	
	self setvehgoalpos( s_goal08.origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	self setvehgoalpos( s_goal07.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self setvehgoalpos( s_goal06.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self setvehgoalpos( s_goal05.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self setvehgoalpos( s_goal03.origin, 1 );
	self waittill_any( "goal", "near_goal" );
					
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self setvehgoalpos( s_goal05.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self setvehgoalpos( s_goal06.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self hind_target_and_fire();
					
	self setvehgoalpos( s_goal07.origin, 0 );
	self waittill_any( "goal", "near_goal" );
					
	self hind_target_and_fire();
	
	self setvehgoalpos( s_goal08.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	if ( flag( "cache_destroyed_bp3" ) )
	{
		self thread bp3wave2_hind_flyto_base();
		wait 0.5;
		self notify( "stop_attack_pattern" );
	}
}


bp3wave2_hind_flyto_base()
{
	self endon( "death" );
	
	s_goal01 = getstruct( "hind_bp3_base01", "targetname" );
	s_goal02 = getstruct( "hind_bp3_base02", "targetname" );
	s_goal03 = getstruct( "hind_bp3_base03", "targetname" );
	s_goal04 = getstruct( "hind_bp3_base04", "targetname" );
	s_goal05 = getstruct( "hind_bp3_base05", "targetname" );
	
	self setvehgoalpos( s_goal01.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal02.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal03.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A HELICOPTER APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal05.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self hind_baseattack();
}


/* ------------------------------------------------------------------------------------------
	End Hind Functions
-------------------------------------------------------------------------------------------*/


tank_logic()
{
	self endon( "death" );
	
	self thread bp3_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal01 = getstruct( "tank_bp3_goal01", "targetname" );
	s_goal02 = getstruct( "tank_bp3_goal02", "targetname" );
	s_goal03 = getstruct( "tank_bp3_goal03", "targetname" );
	s_goal04 = getstruct( "tank_bp3_goal04", "targetname" );
	s_goal05 = getstruct( "tank_bp3_goal05", "targetname" );
	s_goal06 = getstruct( "tank_bp3_goal06", "targetname" );
	s_goal07 = getstruct( "tank_bp3_goal07", "targetname" );
	s_goal08 = getstruct( "tank_bp3_goal08", "targetname" );
	s_goal09 = getstruct( "tank_bp3_goal09", "targetname" );
	s_goal10 = getstruct( "tank_bp3_goal10", "targetname" );
	s_hill = getstruct( "tank_bp3_hill", "targetname" );
	s_goal11 = getstruct( "tank_bp3_goal11", "targetname" );
	s_goal12 = getstruct( "tank_bp3_goal12", "targetname" );
	s_goal13 = getstruct( "tank_bp3_goal13", "targetname" );
	s_goal14 = getstruct( "tank_bp3_goal14", "targetname" );
	
	weapons_cache = GetEnt( "bp3_cache_accumulator", "targetname" );
		
	self SetNearGoalNotifyDist( 200 );
	
	self enable_turret( 1 );
	
	self thread tank_targetting();
	
	self setspeed( 15, 5, 2 );
	self setvehgoalpos( s_goal01.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal02.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal03.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal05.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal06.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal07.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal08.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	if ( !flag( "attack_cache_bp3" ) )
	{
		self SetBrake( true );
	}
	
	flag_wait( "attack_cache_bp3" );
	
	self SetBrake( false );
	
	self setspeed( 14, 5, 2 );
	self setvehgoalpos( s_goal09.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal10.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	if ( !flag( "cache_destroyed_bp3" ) )
	{
		self SetBrake( true );
		self thread tank_attack_cache( weapons_cache );
		flag_wait( "cache_destroyed_bp3" );
		self notify( "cache_destroyed" );
		self ClearTargetEntity();
		self SetBrake( false );
	}
	
	self setspeed( 35, 15, 5 );
	self setvehgoalpos( s_hill.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal11.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 20, 10, 5 );
	self setvehgoalpos( s_goal12.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal13.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal14.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self thread tank_baseattack();
}


tank_attack_cache( weapons_cache )
{
	self endon( "death" );
	self endon( "cache_destroyed" );
	self notify( "attack_cache" );
	
	while ( 1 )
	{
		self SetTargetEntity( weapons_cache );
		
		self FireWeapon();
		
		wait RandomFloatRange( 2.5, 4.0 );
	}
}


uaz1_logic()
{
	self endon( "death" );
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_stop = getstruct( "bp3_uaz1_stop", "targetname" );
		
	self SetNearGoalNotifyDist( 100 );
	
	self setspeed( 15, 5, 2 );
	self setvehgoalpos( s_stop.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


uaz2_logic()
{
	self endon( "death" );
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_stop = getstruct( "bp3_uaz2_stop", "targetname" );
		
	self SetNearGoalNotifyDist( 100 );
	
	self setspeed( 15, 5, 2);
	self setvehgoalpos( s_stop.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


monitor_uaz_group()
{
	waittill_ai_group_count( "group_uaz", 3 );
	
	flag_set( "spawn_bridge_crossers" );
	
	waittill_ai_group_count( "group_uaz", 2 );
	
	if ( !level.n_vehicles )
	{
		flag_set( "spawn_hip1_bp3" );
	}
	
	else if ( level.n_vehicles == 1 )
	{
		flag_set( "spawn_btr1_bp3" );
	}
	
	else
	{
		flag_set( "spawn_btr1_bp3" );
		
		wait 5;
		
		flag_set( "spawn_hip1_bp3" );
	}
}


btr1_logic()
{
	self endon( "death" );
	
	self thread bp3_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal1 = getstruct( "btr1_bp3_pos1", "targetname" );
	s_goal2 = getstruct( "btr1_bp3_pos2", "targetname" );
	s_goal3 = getstruct( "btr1_bp3_pos3", "targetname" );
	s_goal4 = getstruct( "btr1_bp3_pos4", "targetname" );
	s_goal5 = getstruct( "btr1_bp3_pos5", "targetname" );
	s_goal6 = getstruct( "btr1_bp3_pos6", "targetname" );
	s_goal7 = getstruct( "btr1_bp3_pos7", "targetname" );
	s_goal8 = getstruct( "btr1_bp3_pos8", "targetname" );
	s_goal9 = getstruct( "btr1_bp3_pos9", "targetname" );
	
	self enable_turret( 1 );
	
	self SetNearGoalNotifyDist( 100 );
	
	self setspeed( 10, 5, 2 );
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal3.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "attack_cache_bp3" );
	
	self SetBrake( false );
	
	self setspeed( 15, 5, 2 );
	self setvehgoalpos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal5.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal6.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal7.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self thread btr_attack_cache();
	
	flag_wait( "cache_destroyed_bp3" );
	
	self SetBrake( false );
	
	self setvehgoalpos( s_goal8.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal9.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


btr2_logic()
{
	self endon( "death" );
	
	self thread bp3_vehicle_destroyed();
	
	if ( level.n_current_wave == 2 )
	{
		self thread delete_corpse_wave2();
	}
	
	else
	{
		self thread delete_corpse_wave3();
	}
	
	s_goal1 = getstruct( "btr2_bp3_pos1", "targetname" );
	s_goal2 = getstruct( "btr2_bp3_pos2", "targetname" );
	s_goal3 = getstruct( "btr2_bp3_pos3", "targetname" );
	s_goal4 = getstruct( "btr2_bp3_pos4", "targetname" );
	s_goal5 = getstruct( "btr2_bp3_pos5", "targetname" );
	s_goal6 = getstruct( "btr2_bp3_pos6", "targetname" );
	s_goal7 = getstruct( "btr2_bp3_pos7", "targetname" );
	s_goal8 = getstruct( "btr2_bp3_pos8", "targetname" );
	s_goal9 = getstruct( "btr2_bp3_pos9", "targetname" );
	s_goal10 = getstruct( "btr2_bp3_pos10", "targetname" );
	s_goal11 = getstruct( "btr2_bp3_pos11", "targetname" );
	
	self enable_turret( 1 );
	
	self SetNearGoalNotifyDist( 100 );
	
	self setspeed( 10, 5, 2 );
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	if ( flag( "crew_inplace_bp3" ) )
	{
		self SetBrake( true );
		flag_wait( "crew_gone_bp3" );
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal4.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "attack_cache_bp3" );
	
	self SetBrake( false );
	
	self setspeed( 13, 4, 2 );
	self setvehgoalpos( s_goal5.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal6.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal7.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal8.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self thread btr_attack_cache();
	
	flag_wait( "cache_destroyed_bp3" );
	
	self SetBrake( false );
	
	self setvehgoalpos( s_goal9.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal10.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal11.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


btr_attack_cache()
{
	self endon( "death" );
		
	m_damage = GetEnt( "bp3_cache_accumulator", "targetname" );
	
	while ( 1 )
	{
		self set_turret_target( m_damage, ( 0, 0, 0 ), 1 );
		
		self fire_turret( 1 );
		
		wait RandomFloatRange( 2.0, 3.0 );
		
		self stop_firing_turret( 1 );
		
		if ( flag( "cache_destroyed_bp3" ) )
		{
			self set_turret_target( level.player, ( 0, 0, 32 ), 1 );	
			
			break;
		}
	}
}


bp3_vehicle_destroyed()
{
	self waittill( "death" );
	
	level.n_bp3_veh_destroyed++;
	
	autosave_by_name( "bp2_vehicle_destroyed" );
}


sniper_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	self disable_tactical_walk();
	
	flag_wait( "shoot_rider" );
	
	self shoot_at_target( level.rider_victim );
	
	flag_set( "rider_shot" );
	
	vol = getent( "vol_cache_bp3", "targetname" );
	
	self SetGoalVolumeAuto( vol );
}


bridge_crosser_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	self disable_tactical_walk();
	
	vol = getent( "vol_cache_bp3", "targetname" );
	
	self SetGoalVolumeAuto( vol );
}


foot_soldier_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
	
	vol = getent( "vol_cache_bp3", "targetname" );
	
	if ( cointoss() )
	{
		vol = getent( "vol_bp3_defend", "targetname" );
	}
	
	self SetGoalVolumeAuto( vol );
}


check_for_crew()
{
	level endon( "wave2_done" );
	level endon( "crew_gone_bp3" );
	
	//TODO - get flag to indicate crew deployment
	while( 1 )
	{
		a_rpg_guys = GetEntArray( "east_rpg_guy_spawn_ai", "targetname" );
		a_stinger_guys = GetEntArray( "east_stinger_guy_spawn_ai", "targetname" );
		a_mortar_guys = GetEntArray( "east_mortar_guy_spawn_ai", "targetname" );
		
		if ( a_rpg_guys.size || a_stinger_guys.size || a_mortar_guys.size )
		{
			level thread monitor_crew_bp3();
			flag_set( "crew_inplace_bp3" );
			break;
		}
		
		wait 1;
	}
}


monitor_crew_bp3()
{
	t_damage = GetEnt( "bp3_crew_damage", "targetname" );
	t_damage waittill( "trigger" );
	
	iprintlnbold( "crew dead" );
	
	flag_set( "crew_gone_bp3" );
	
	a_rpg_guys = GetEntArray( "east_rpg_guy_spawn_ai", "targetname" );
	a_stinger_guys = GetEntArray( "east_stinger_guy_spawn_ai", "targetname" );
	a_mortar_guys = GetEntArray( "east_mortar_guy_spawn_ai", "targetname" );
		
	if ( a_rpg_guys.size )
	{
		foreach( rpg_guy in a_rpg_guys )
		{
			rpg_guy delete();
		}
	}
	
	else if ( a_stinger_guys.size )
	{
		foreach( stinger_guy in a_stinger_guys )
		{
			stinger_guy delete();
		}
	}
	
	else if ( a_mortar_guys.size )
	{
		foreach( mortar_guy in a_mortar_guys )
		{
			mortar_guy delete();
		}
	}
	
	level thread monitor_crew_bp3();
}


crew_assault_team()
{
	flag_wait( "crew_inplace_bp3" );
	flag_wait( "attack_crew_bp3" );
	
	spawn_manager_enable( "manager_assaultcrew_bp3" );
	
	//TODO - wave 2
	flag_wait_any( "crew_gone_bp3", "wave3_done" );
	
	spawn_manager_disable( "manager_assaultcrew_bp3" );
}


bp3_crewassault_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}


monitor_weapons_cache( m_damage )
{	
	m_damage SetCanDamage( true );
	
	n_cache_health = 100;
	
	b_under_attack = false;
	b_down_50 = false;
	b_down_25 = false;
	b_destroyed = false;
	
	if ( m_damage.targetname == "bp2_cache_accumulator" )
	{
		cache_pris = GetEnt( "ammo_cache_BP2_pristine", "targetname" );
		cache_dmg = GetEnt( "ammo_cache_BP2_damaged", "targetname" );
		cache_dest = GetEnt( "ammo_cache_BP2_destroyed", "targetname" );
		cache_clip = GetEnt( "ammo_cache_BP2_clip", "targetname" );
	}
	else
	{
		cache_pris = GetEnt( "ammo_cache_BP3_pristine", "targetname" );
		cache_dmg = GetEnt( "ammo_cache_BP3_damaged", "targetname" );
		cache_dest = GetEnt( "ammo_cache_BP3_destroyed", "targetname" );
		cache_clip = GetEnt( "ammo_cache_BP3_clip", "targetname" );
	}
	
	while( 1 )
	{
		m_damage waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "apc_btr60" )
		{
			n_cache_health -= 0.2;
		}
		
		if ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "heli_hip" )
		{
			n_cache_health -= 0.8;
		}
		
		if ( ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "tank_t62" ) )
		{
			n_cache_health -= 10;
		}
		
		//TODO - get real hind weapons/////////////////////
		if ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "heli_hind_afghan" )
		{
			n_cache_health -= 5;
		}
		
		if ( type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" )
		{
			n_cache_health -= 10;
		}
		/////////////////////////////////////////////////////////
		
		if ( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
		{
			n_cache_health -= 4;
		}
		
		if ( n_cache_health < 100 )
		{
			if ( !b_under_attack )
			{
				iprintlnbold( "WEAPONS CACHE UNDER ATTACK!" );
				b_under_attack = true;
			}
		}
		
		if ( n_cache_health < 50 )
		{
			if ( !b_down_50 )
			{
				iprintlnbold( "WEAPONS CACHE DOWN TO 50 PERCENT!" );
				b_down_50 = true;
				cache_pris Delete();
				cache_dmg Show();
				PlayFX( level._effect[ "cache_dmg" ], cache_dmg.origin );
			}
		}
	
		if ( n_cache_health < 25 )
		{
			if ( !b_down_25 )
			{
				iprintlnbold( "WEAPONS CACHE DOWN TO 25 PERCENT!" );
				b_down_25 = true;
			}
		}
		
		if ( n_cache_health < 1 )
		{
			if ( !b_destroyed )
			{
				iprintlnbold( "WEAPONS CACHE DESTROYED!" );
				b_destroyed = true;
				PlayFX( level._effect[ "cache_dest" ], cache_dest.origin );
				wait 0.1;
				cache_dest Show();
				cache_dmg Delete();
				cache_clip Delete();
				
				if ( level.n_current_wave == 2 )
				{
					if ( level.wave2_loc == "blocking point 2" )
					{
						flag_set( "cache_destroyed_bp2" );
					}
					
					else
					{
						flag_set( "cache_destroyed_bp3" );
					}
				}
			}
		}
	}
}


/* ------------------------------------------------------------------------------------------
									Utility Functions
-------------------------------------------------------------------------------------------*/
cleanup_ai_bp2wave2()
{
	spawn_manager_disable( "manager_troops_exit" );
	spawn_manager_disable( "manager_hip3_troops" );
	spawn_manager_disable( "manager_hip4_troops" );
	
	a_ai_guys = getaiarray( "allies", "axis" );
	
	a_ai_guys = array_exclude( a_ai_guys, level.zhao );
	
	foreach( ai_guy in a_ai_guys )
	{
		ai_guy delete();
	}	
}


// Helicopter Functions
hip_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	
	self thread hip_fire_support();
	
	self SetSpeed( 50, 25, 20 );
	
	s_goal = s_start;
	
	while( 1 )
	{
		if ( s_goal.targetname == "hip_bp3_circle12" )
		{
			self setvehgoalpos( s_goal.origin, 1 );
			self waittill_any( "goal", "near_goal" );
			wait RandomFloatRange( 2.5, 4.0 );
		}
		
		else
		{
			self setvehgoalpos( s_goal.origin, 0 );
			self waittill_any( "goal", "near_goal" );
		}
		
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


hip_fire_support()
{
	self endon( "death" );
	self endon( "stop_circle" );
	
	self waittill_any( "goal", "near_goal" );
	
	self enable_turret( 2 );
}