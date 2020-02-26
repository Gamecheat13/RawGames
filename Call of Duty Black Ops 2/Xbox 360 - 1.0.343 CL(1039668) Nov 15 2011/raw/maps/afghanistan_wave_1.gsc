#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_ai_rappel;
#include maps\_turret;
#include maps\_vehicle_aianim;
#include maps\_horse;


init_flags()
{
	flag_init( "bp1_stop_horse" );
	flag_init( "spawn_btr1_bp1" );
	flag_init( "spawn_btr2_bp1" );
	flag_init( "spawn_hip1_bp1" );
	flag_init( "spawn_hip2_bp1" );
	flag_init( "crew_inplace_bp1" );
	flag_init( "crew_gone_bp1" );
	flag_init( "attack_crew_bp1" );
	flag_init( "attack_cache_bp1" );
	flag_init( "cache_destroyed_bp1" );
	flag_init( "zhao_ready_bp1exit" );
	flag_init( "player_onhorse_bp1exit" );
	flag_init( "wave1_started" );
	flag_init( "wave1_done" );
	flag_init( "wave1_complete" );
}


init_spawn_funcs()
{
	add_spawn_function_veh( "btr1_bp1", ::btr1_bp1_logic );
	add_spawn_function_veh( "btr2_bp1", ::btr2_bp1_logic );
	add_spawn_function_veh( "hip1_bp1", ::hip1_bp1_logic );
	add_spawn_function_veh( "hip2_bp1", ::hip2_bp1_logic );
	
	add_spawn_function_group( "muj_defend_bp1", "targetname", ::defend_bp1_logic );
	add_spawn_function_group( "bp1_assault_troops", "targetname", ::assault_bp1_logic );
	add_spawn_function_group( "bp1_reinforce", "targetname", ::assault_bp1_logic );
	add_spawn_function_group( "bp1_reinforce_alt1", "targetname", ::reinforce1_bp1_logic );
	add_spawn_function_group( "bp1_reinforce_alt2", "targetname", ::reinforce2_bp1_logic );
	add_spawn_function_group( "bp1_reinforce_alt3", "targetname", ::reinforce3_bp1_logic );
}


init_level_setup()
{	
	//level thread spawn_weapon_cache( "rpg" );
	//level thread spawn_weapon_cache( "stinger" );
	
	level.horse_zhao SetCanDamage( false );
	level.zhao SetCanDamage( false );
	
	level.n_bp1wave1_soviet_killed = 0;
}


skipto_wave1()
{
	skipto_setup();
	
	init_hero( "zhao" );
	
	start_teleport( "skipto_wave1", level.heroes );
	
	init_weapon_cache();
	
	level.zhao = getent( "zhao_ai", "targetname" );
	
	t_horses = getent( "spawn_bp1_horses", "targetname" );
	t_horses notify( "trigger" );
	
	wait 0.1;
	
	level.horse_zhao = getent( "zhao_horse_bp1", "targetname" );
	level.player_horse = getent( "player_horse_bp1", "targetname" );
	
	level.player_horse MakeVehicleUsable();
		
	wait 0.1;
	
	level.zhao enter_vehicle( level.horse_zhao );
	
	wait 0.05;
	
	level.horse_zhao notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.horse_zhao );
	
	level.horse_zhao thread zhao_skipto_wave1();
	
	level.horse_zhao SetVehicleAvoidance( true );
	
	set_objective( level.OBJ_AFGHAN_BP1, level.zhao, "follow" );
}


zhao_skipto_wave1()
{
	level.player_horse waittill( "enter_vehicle", player );
	
	s_zhao_bp1 = getstruct( "zhao_bp1_goal", "targetname" );
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetSpeed( 25, 15, 10 );
	self SetVehGoalPos( s_zhao_bp1.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self SetSpeedImmediate( 0 );
	
	flag_set( "zhao_at_bp1" );	
}


main()
{
	init_spawn_funcs();
	init_level_setup();
	bp1_vehicle_chooser();
	wave1();
	
	flag_wait( "wave1_complete" );
}


wave1()
{
	level.n_current_wave = 1;
	level.n_bp1_veh_destroyed = 0;
		
	level.horse_zhao thread zhao_wave1_bp1();
	level.player_horse thread player_horse_behavior();
	
	trigger_wait( "spawn_bp1" );
	
	flag_set( "wave1_started" );
	
	level thread spawn_mig_intro();
	level thread mig_bomb_entrance();
	level thread bp1_replenish_arena();
	level thread spawn_mig_tower();
			
	autosave_by_name( "blocking_point1" );
	
	cleanup_arena();
	
	wait 0.1;
	
	spawn_manager_enable( "manager_initial_bp1" );
	spawn_manager_enable( "manager_muj_bp1" );
	
	level thread monitor_enemy_bp1();
	level thread spawn_reinforce1_bp1();
	level thread spawn_reinforce2_bp1();
	level thread spawn_reinforce3_bp1();
			
	while ( level.n_bp1_veh_destroyed < 2 )
	{
		wait 1;
	}
	
	flag_set( "wave1_done" );
	flag_set( "wave1_complete" );
	
	spawn_manager_disable( "manager_muj_bp1" );
	spawn_manager_disable( "manager_soviet_bp1" );
	spawn_manager_kill( "manager_bp1_reinforce" );
}


spawn_mig_intro()
{
	s_spawnpt = getstruct( "bp1_mig_spawnpt", "targetname" );
		
	vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
	vh_mig.origin = s_spawnpt.origin;
	vh_mig.angles = s_spawnpt.angles;
	
	vh_mig thread bp1_mig_intro();
}


bp1_mig_intro()
{
	self endon( "death" );
	
	self SetForceNoCull();
	
	s_goal1 = getstruct( "bp1_mig_goal1", "targetname" );
	s_goal2 = getstruct( "bp1_mig_goal2", "targetname" );
	
	Target_Set( self );
	
	self SetNearGoalNotifyDist( 1000 );
	
	self setspeed( 800, 700, 600 );
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread bp1_entrance_explosions();
	
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self Delete();
}


bp1_entrance_explosions()
{
	a_s_explosions = [];
	a_s_explosions[ 0 ] = getstruct( "bp1_mig_spawnpt", "targetname" );
	
	for ( i = 1; i < 7; i ++ )
	{
		a_s_explosions[ i ] = getstruct( "bp1_mig_exp"+i, "targetname" );
	}
	
	for ( i = 1; i < 7; i ++ )
	{
		PlayFX( level._effect[ "explode_mortar_sand" ], a_s_explosions[ i ].origin );
		PlaySoundAtPosition( "wpn_rocket_explode", a_s_explosions[ i ].origin );
		Earthquake( 0.5, 1, a_s_explosions[ i ].origin, 2000 );
		level.player PlayRumbleOnEntity( "artillery_rumble" );
		wait 1;	
	}
}


mig_bomb_entrance()
{
	flag_wait( "enter_bp1" );
	
	s_spawnpt = getstruct( "bp1_mig2_spawnpt", "targetname" );
		
	vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
	vh_mig.origin = s_spawnpt.origin;
	vh_mig.angles = s_spawnpt.angles;
	
	vh_mig thread bp1_mig2_bombrun();
}


bp1_mig2_bombrun()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "bp1_mig2_goal1", "targetname" );
	s_goal2 = getstruct( "bp1_mig2_goal2", "targetname" );
	
	Target_Set( self );
	
	self SetForceNoCull();
	
	self SetNearGoalNotifyDist( 1000 );
	
	self setspeed( 800, 700, 600 );
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread bp1_mig2_bombs();
	
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self Delete();
}


bp1_mig2_bombs()
{
	s_bomb1 = getstruct( "bp1_mig2_exp1", "targetname" );
	s_bomb2 = getstruct( "bp1_mig2_exp2", "targetname" );
	
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb1.origin );
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb1.origin );
	Earthquake( 0.5, 1, s_bomb1.origin, 2000 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	RadiusDamage( s_bomb1.origin, 300, 120, 100, undefined, "MOD_PROJECTILE" );
	
	wait 1;
	
	flag_set( "bp1_stop_horse" );
	
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb2.origin );
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb2.origin );
	Earthquake( 0.5, 1, s_bomb2.origin, 2000 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	RadiusDamage( s_bomb2.origin, 300, 120, 100, undefined, "MOD_PROJECTILE" );
}


spawn_mig_tower()
{
	//trigger_wait( "trigger_tower", "script_noteworthy" );
	trigger_wait( "zhao_to_weapons" );
	
	s_spawnpt = getstruct( "mig_tower_spawnpt", "targetname" );
		
	vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
	vh_mig.origin = s_spawnpt.origin;
	vh_mig.angles = s_spawnpt.angles;
	
	vh_mig thread mig_destroy_tower();
}
	
	
mig_destroy_tower()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "mig_tower_goal1", "targetname" );
	s_goal2 = getstruct( "mig_tower_goal2", "targetname" );
	s_goal3 = getstruct( "mig_tower_goal3", "targetname" );
	s_goal4 = getstruct( "mig_tower_goal4", "targetname" );
	s_goal5 = getstruct( "mig_tower_goal5", "targetname" );
	
	Target_Set( self );
	
	self SetForceNoCull();
	
	self SetNearGoalNotifyDist( 1000 );
	
	self setspeed( 500, 250, 200 );
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self thread tower_explosions();
	
	self setvehgoalpos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	self setvehgoalpos( s_goal5.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self Delete();
}


tower_explosions()
{
	s_bomb1 = getstruct( "mig_tower_bomb1", "targetname" );
	s_bomb2 = getstruct( "mig_tower_bomb2", "targetname" );
	
	MagicBullet( "stinger_sp", self GetTagOrigin( "tag_missle_right" ), s_bomb2.origin );
	wait 0.1;
	MagicBullet( "stinger_sp", self GetTagOrigin( "tag_missle_left" ), s_bomb1.origin );
	
	wait 1;

	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb1.origin );
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb1.origin );
	Earthquake( 0.4, 2, level.player.origin, 100 );
	level.player PlayRumbleOnEntity( "grenade_rumble" );

	wait 1;
	
	level notify( "fxanim_village_tower_start" );
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb2.origin );
	Earthquake( 0.4, 2, level.player.origin, 100 );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
}


player_horse_behavior()  //self = player horse
{
	self endon( "death" );
	
	flag_wait( "bp1_stop_horse" );
	
	self SetBrake( true );
	
	self horse_rearback();
	
	self thread bp1_player_horse_ready();
}


bp1_player_horse_ready()  //self = player horse
{
	s_hitchpt = getstruct( "bp1_hitch", "targetname" );
	
	trigger_wait( "start_tower_collapse" );
	
	self.origin = s_hitchpt.origin;
	self.angles = s_hitchpt.angles;
	
	self SetNearGoalNotifyDist( 300 );
	self MakeVehicleUsable();
	self SetBrake( false );
	self Godon();
	
	flag_wait( "zhao_ready_bp1exit" );
	
	set_objective( level.OBJ_FOLLOW, self, "use" );
	
	self waittill( "enter_vehicle", player );
	
	flag_set( "player_onhorse_bp1exit" );
	
	set_objective( level.OBJ_FOLLOW, level.zhao, "follow" );
}


bp1_replenish_arena()
{
	trigger_wait( "bp1_replenish_arena" );
	
	if ( !flag( "wave1_done" ) )
	{
		level thread replenish_bp1();
	}
	
	spawn_manager_disable( "manager_soviet_bp1" );
	spawn_manager_kill( "manager_bp1_reinforce" );
	spawn_manager_disable( "manager_muj_bp1" );
	
	cleanup_bp_ai();
	respawn_arena();
}


replenish_bp1()
{
	trigger_wait( "spawn_bp1" );
	
	spawn_manager_enable( "manager_soviet_bp1" );
	spawn_manager_enable( "manager_muj_bp1" );
	
	cleanup_arena();
	
	level thread bp1_replenish_arena();
}


zhao_wave1_bp1()  //self = level.horse_zhao
{
	flag_wait( "zhao_at_bp1" );
	
	self notify( "unload" );
	
	self MakeVehicleUnusable();
	
	level.zhao notify( "stop_riding" );
	level.zhao set_fixednode( false );
	
	level.zhao set_force_color( "o" );
	
	level.zhao thread force_goal();
	
	level thread instructions_bp1();
	
	flag_wait( "soviet_fallback" );
	
	level.zhao disable_ai_color();
	
	flag_wait_any( "wave1_done", "cache_destroyed_bp1" );
	
	level.zhao run_to_vehicle( self );
	
	wait 0.05;
	
	self notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( self );
	
	flag_set( "zhao_ready_bp1exit" );
	
	self thread zhao_goto_wave2();
}


instructions_bp1()
{
	iprintlnbold( "WE NEED TO GET TO THE WEAPONS CACHE!" );
	
	wait 0.5;
	
	iprintlnbold( "FOLLOW ME!" );
	
	trigger_wait( "zhao_to_weapons" );
	
	cache_bp1_pris = GetEnt( "ammo_cache_BP1_pristine", "targetname" );
	set_objective( level.OBJ_AFGHAN_BP1, cache_bp1_pris, "breadcrumb" );
	
	iprintlnbold( "GET TO THAT WEAPONS CACHE!" );
	
	if ( level.n_bp1_vehicles == 0 )
	{
		flag_wait( "spawn_btr1_bp1" );
		
		iprintlnbold( "MASON!  BTR APPROACHING, DESTROY IT!" );
		
		flag_wait( "spawn_hip1_bp1" );
		
		iprintlnbold( "DESTROY THAT HELICOPTER!" );
	}
	
	else if ( level.n_bp1_vehicles == 1 )
	{
		flag_wait( "spawn_hip1_bp1" );
		flag_wait( "spawn_hip2_bp1" );
		wait 2;
		iprintlnbold( "HELICOPTERS APPROACHING, DESTROY THEM!" );
	}
	
	else
	{
		flag_wait( "spawn_btr1_bp1" );
		flag_wait( "spawn_btr2_bp1" );
		wait 2;
		iprintlnbold( "MASON!  BTRs APPROACHING, DESTROY THEM!" );
	}
	
	flag_wait_any( "wave1_done", "cache_destroyed_bp1" );
		
	wait 1;
	
	if ( flag( "wave1_done" ) )
	{
		set_objective( level.OBJ_AFGHAN_BP1, undefined, "done" );
		
		iprintlnbold( "GOOD WORK, MASON!" );
		
		wait 0.5;
		
		iprintlnbold( "LET'S GO!" );
		
		if ( level.wave2_loc == "blocking point 2" )
		{
			iprintlnbold( "WE HAVE MORE ENEMIES APPROACHING BLOCKING POINT 2!" );
		}
	
		else
		{
			iprintlnbold( "WE HAVE MORE ENEMIES APPROACHING BLOCKING POINT 3!" );
		}
	}
	
	else
	{
		set_objective( level.OBJ_AFGHAN_BP1, undefined, "delete" );
		
		iprintlnbold( "WE'VE LOST THE WEAPONS CACHE!" );
		
		wait 0.5;
		
		iprintlnbold( "LET'S GET THE HELL OUT OF HERE!" );
	}
	
	set_objective( level.OBJ_FOLLOW, level.zhao, "follow" );
	
	flag_wait( "zhao_ready_bp1exit" );
		
	iprintlnbold( "MASON!  LET'S GO!" );
		
	flag_wait( "player_onhorse_bp1exit" );
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		set_objective( level.OBJ_AFGHAN_BP2, level.zhao, "follow" );
		
		iprintlnbold( "WE HAVE MORE ENEMIES APPROACHING BLOCKING POINT 2!" );
	}
	
	else
	{
		set_objective( level.OBJ_AFGHAN_BP3, level.zhao, "follow" );
		
		iprintlnbold( "WE HAVE MORE ENEMIES APPROACHING BLOCKING POINT 3!" );
	}
}


zhao_goto_wave2()
{
	while( Distance2D( level.zhao.origin, level.player.origin ) > 750 )
	{
		wait 1;
	}
	
	s_zhao_wave2 = getstruct( "zhao_bp3", "targetname" );
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		s_zhao_wave2 = getstruct( "zhao_bp2", "targetname" );
	}
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	self SetVehGoalPos( s_zhao_wave2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		flag_set( "zhao_at_bp2" );
	}
	
	else
	{
		flag_set( "zhao_at_bp3" );
	}
}


bp1_vehicle_chooser()
{
	level.n_bp1_vehicles = RandomInt( 3 );
							
	if ( level.n_bp1_vehicles == 0 )
	{
		//iprintlnbold( "1 Hip + 1 BTR" );
		level thread spawn_hip1_bp1();
		level thread spawn_btr1_bp1();
	}
	
	else if ( level.n_bp1_vehicles == 1 )
	{
		//iprintlnbold( "2 Hips" );
		level thread spawn_hip1_bp1();
		level thread spawn_hip2_bp1();
	}
	
	else
	{
		//iprintlnbold( "2 BTRs" );
		level thread spawn_btr1_bp1();
		level thread spawn_btr2_bp1();
	}
	
	level thread trigger_vehicles();
}


spawn_hip1_bp1()
{
	flag_wait( "spawn_hip1_bp1" );
	
	hip1 = spawn_vehicle_from_targetname( "hip1_bp1" );
	hip1 thread delete_corpse_bp1();
}


spawn_hip2_bp1()
{
	flag_wait( "spawn_hip2_bp1" );
	
	hip2 = spawn_vehicle_from_targetname( "hip2_bp1" );
	hip2 thread delete_corpse_bp1();
}


spawn_btr1_bp1()
{
	flag_wait( "spawn_btr1_bp1" );
	
	trigger_use( "bp1wave1_btr1_spawn" );
}


spawn_btr2_bp1()
{
	flag_wait( "spawn_btr2_bp1" );
	
	trigger_use( "bp1wave1_btr2_spawn" );
}


trigger_vehicles()
{
	level endon( "wave1_done" );
	
	flag_wait( "spawn_vehicles_bp1" );
	
	if ( level.n_bp1_vehicles == 0 )
	{
		flag_set( "spawn_btr1_bp1" );
		
		wait 5;
		
		flag_set( "spawn_hip1_bp1" );
	}
	
	else if ( level.n_bp1_vehicles == 1 )
	{
		flag_set( "spawn_hip1_bp1" );
		
		wait 3;
		
		flag_set( "spawn_hip2_bp1" );
	}
	
	else
	{
		flag_set( "spawn_btr1_bp1" );
		
		wait 2;
		
		flag_set( "spawn_btr2_bp1" );
	}
}


btr1_bp1_logic()
{
	self endon( "death" );
	
	self.is_btr = true;
	
	nd_ready = GetVehicleNode( "btr1_village_ready", "targetname" );
	nd_attack = GetVehicleNode( "btr1_village_attack", "targetname" );
	
	self thread bp1_vehicle_destroyed();
	self thread delete_corpse_bp1();
	self thread bp1_btr_attack();
	
	nd_ready.gateopen = false;
	nd_attack.gateopen = false;
	
	flag_wait( "attack_cache_bp1" );
	
	nd_ready.gateopen = true;
	self ResumeSpeed( 5 );
	
	self notify( "attack_cache" );
	
	flag_wait( "cache_destroyed_bp1" );
	
	wait 3;
	
	nd_attack.gateopen = true;
	self ResumeSpeed( 5 );
}


btr2_bp1_logic()
{
	self endon( "death" );
	
	self.is_btr = true;
	
	nd_ready = GetVehicleNode( "btr2_village_ready", "targetname" );
	nd_attack = GetVehicleNode( "btr2_village_attack", "targetname" );
	
	self thread bp1_vehicle_destroyed();
	self thread delete_corpse_bp1();
	self thread bp1_btr_attack();
	
	nd_ready.gateopen = false;
	nd_attack.gateopen = false;
	
	flag_wait( "attack_cache_bp1" );
	
	wait 1;
	
	nd_ready.gateopen = true;
	self ResumeSpeed( 5 );
	
	self notify( "attack_cache" );
	
	flag_wait( "cache_destroyed_bp1" );
	
	wait 2;
	
	nd_attack.gateopen = true;
	self ResumeSpeed( 5 );
}


hip1_bp1_logic()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	
	self thread bp1_vehicle_destroyed();
	
	s_goal01 = getstruct( "hip1_bp1_goal01", "targetname" );
	s_goal02 = getstruct( "hip1_bp1_goal02", "targetname" );
	s_goal03 = getstruct( "hip1_bp1_goal03", "targetname" );
	s_goal04 = getstruct( "hip1_bp1_goal04", "targetname" );
	s_goal05 = getstruct( "hip1_bp1_goal05", "targetname" );
	s_goal06 = getstruct( "hip1_bp1_goal06", "targetname" );
	
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
	
	self setvehgoalpos( s_goal06.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 0, 25, 20 );
	
	while( self GetSpeed() )
	{
		wait 1;
	}
	
	self thread bp1_hip1_rappel();
	
	wait 5;
	
	s_start = getstruct( "hip1_bp1_circle02", "targetname" );
	
	self thread bp1_hip_circle( s_start );
	
	flag_wait( "attack_cache_bp1" );
	
	self thread bp1_hip_attack_cache();
	
	flag_wait( "cache_destroyed_bp1" );
	
	self notify( "stop_cache_attack" );
	self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	s_start = getstruct( "bp1_sentry_goal01", "targetname" );
	
	self thread bp1_hip_circle( s_start );
}


bp1_hip1_rappel()
{	
	sp_hip1_rappell1 = GetEnt( "bp1_hip1_rappel1", "targetname" );
	sp_hip1_rappell2 = GetEnt( "bp1_hip1_rappel2", "targetname" );
	sp_hip1_rappell3 = GetEnt( "bp1_hip1_rappel3", "targetname" );
	sp_hip1_rappell4 = GetEnt( "bp1_hip1_rappel4", "targetname" );
	
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


hip1_rappel_logic()
{
	self endon( "death" );
	
	self waittill( "rappel_done" );
	
	self set_spawner_targets( "bp1_hip1_rappel" );
}


hip2_bp1_logic()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	
	self thread bp1_vehicle_destroyed();
	
	s_goal01 = getstruct( "hip2_bp1_goal01", "targetname" );
	s_goal02 = getstruct( "hip2_bp1_goal02", "targetname" );
	s_goal03 = getstruct( "hip2_bp1_goal03", "targetname" );
	s_goal04 = getstruct( "hip2_bp1_goal04", "targetname" );
	s_goal05 = getstruct( "hip2_bp1_goal05", "targetname" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 35, 20, 10 );
	self setvehgoalpos( s_goal01.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal02.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal03.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal05.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 0, 25, 20 );
	
	while( self GetSpeed() )
	{
		wait 1;
	}
	
	self thread bp1_hip2_rappel();
	
	wait 5;
	
	s_start = getstruct( "hip1_bp1_circle06", "targetname" );
	
	self thread bp1_hip_circle( s_start );
	
	flag_wait( "attack_cache_bp1" );
	
	self thread bp1_hip_attack_cache();
	
	flag_wait( "cache_destroyed_bp1" );
	
	self notify( "stop_cache_attack" );
	self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	s_start = getstruct( "bp1_sentry_goal01", "targetname" );
	
	self thread bp1_hip_circle( s_start );
}


bp1_hip2_rappel()
{	
	sp_hip2_rappell1 = GetEnt( "bp1_hip2_rappel1", "targetname" );
	sp_hip2_rappell2 = GetEnt( "bp1_hip2_rappel2", "targetname" );
	sp_hip2_rappell3 = GetEnt( "bp1_hip2_rappel3", "targetname" );
	sp_hip2_rappell4 = GetEnt( "bp1_hip2_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip2_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip2_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip2_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip2_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	sp_hip2_rappell1 spawn_ai( true );
	wait 0.3;
	sp_hip2_rappell2 spawn_ai( true );
	wait 1.3;
	sp_hip2_rappell3 spawn_ai( true );
	wait 1.4;
	sp_hip2_rappell4 spawn_ai( true );
}


hip2_rappel_logic()
{
	self endon( "death" );
	
	self waittill( "rappel_done" );
	
	self set_spawner_targets( "bp1_hip2_rappel" );
}


bp1_hip_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	
	self thread bp1_hip_fire_support();
	
	self SetSpeed( 50, 25, 20 );
	
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


bp1_hip_fire_support()
{
	self endon( "death" );
	
	self waittill_any( "goal", "near_goal" );
	
	self enable_turret( 2 );
}


bp1_hip_attack_cache()
{
	self endon( "death" );
	self notify( "stop_cache_attack" );
		
	self disable_turret( 2 );
	
	cache_bp1_dest = GetEnt( "ammo_cache_BP1_destroyed", "targetname" );
	
	while( !flag( "cache_destroyed_bp1" ) )
	{
		self thread shoot_turret_at_target( cache_bp1_dest, 10, ( 0, 0, 0 ), 2, false );
		
		wait 8;
	}
	
	self clear_turret_target( 2 );
}


bp1_btr_attack()
{
	self endon( "death" );
	
	self enable_turret( 1 );
	
	self waittill( "attack_cache" );
	
	self disable_turret( 1 );
	
	cache_bp1_dest = GetEnt( "ammo_cache_BP1_destroyed", "targetname" );
	
	wait 2;
	
	while( !flag( "cache_destroyed_bp1" ) )
	{
		self thread shoot_turret_at_target( cache_bp1_dest, 5, ( 0, 0, 0 ), 1, false );
		
		wait 8;
	}
}


defend_bp1_logic()
{
	self endon( "death" );
	
	flag_wait( "enter_bp1" );
	
	wait RandomFloatRange( 0.1, 1.5 );
	
	self force_goal();
	
	self set_spawner_targets( "bp1_entrance" );
	
	self set_fixednode( false );
}


assault_bp1_logic()
{
	self endon( "death" );
	
	self thread bp1wave1_monitor_soviets();
	
//	flag_wait( "soviet_fallback" );
//	
//	wait RandomFloatRange( 0.1, 2.5 );
//	
//	self force_goal();
//	
//	self set_spawner_targets( "soviet_fallback" );
}


bp1wave1_monitor_soviets()
{
	self waittill( "death" );
	
	level.n_bp1wave1_soviet_killed++;
	
	if ( level.n_bp1wave1_soviet_killed > 11 && !flag( "attack_crew_bp1" ) )
	{
		flag_set( "soviet_fallback" );
		flag_set( "attack_crew_bp1" );
		flag_set( "attack_cache_bp1" );
	
		level thread monitor_cache_bp1();
	}
}


monitor_enemy_bp1()
{
	trigger_wait( "zhao_to_town" );
	
	spawn_manager_enable( "manager_soviet_bp1" );
		
	flag_wait( "soviet_fallback" );
	
	spawn_manager_disable( "manager_soviet_bp1" );
	
	wait 3;
	
	spawn_manager_enable( "manager_bp1_reinforce" );
	
	flag_set( "spawn_vehicles_bp1" );
	
	flag_wait( "wave1_done" );
	
	spawn_manager_disable( "manager_bp1_reinforce" );
}


reinforce1_bp1_logic()
{
	self endon( "death" );
	
	self thread bp1wave1_monitor_soviets();
	
	nd_1 = GetNode( "alt1_1_goal", "targetname" );
	nd_2 = GetNode( "alt1_2_goal", "targetname" );
	nd_3 = GetNode( "alt1_3_goal", "targetname" );
	nd_4 = GetNode( "alt1_4_goal", "targetname" );
	
	self change_movemode( "sprint" );
	
	if ( self.script_noteworthy == "alt1_1" )
	{
		self thread force_goal( nd_1, 64, true );
		self waittill( "goal" );
		self reset_movemode();
		self set_fixednode( true );
		self thread shoot_at_target( level.player, undefined, 1, 5 );
		wait 5;
		self set_fixednode( false );
	}
	
	else if ( self.script_noteworthy == "alt1_2" )
	{
		self thread force_goal( nd_2, 64, true );
	}
	
	else if ( self.script_noteworthy == "alt1_3" )
	{
		self thread force_goal( nd_3, 64, true );
	}
	
	else if ( self.script_noteworthy == "alt1_4" )
	{
		self thread force_goal( nd_4, 64, true );
	}
	
	self waittill( "goal" );
	
	self reset_movemode();
}


reinforce2_bp1_logic()
{
	self endon( "death" );
	
	nd_1 = GetNode( "alt2_1_goal", "targetname" );
	nd_2 = GetNode( "alt2_2_goal", "targetname" );
	nd_3 = GetNode( "alt2_3_goal", "targetname" );
	nd_4 = GetNode( "alt2_4_goal", "targetname" );
	
	self change_movemode( "sprint" );
	
	if ( self.script_noteworthy == "alt2_1" )
	{
		self thread force_goal( nd_1, 64, true );
		self waittill( "goal" );
		self reset_movemode();
		self set_fixednode( true );
		self thread shoot_at_target( level.player, undefined, 1, 5 );
		wait 5;
		self set_fixednode( false );
	}
	
	else if ( self.script_noteworthy == "alt2_2" )
	{
		self thread force_goal( nd_2, 64, true );
	}
	
	else if ( self.script_noteworthy == "alt2_3" )
	{
		self thread force_goal( nd_3, 64, true );
	}
	
	else if ( self.script_noteworthy == "alt2_4" )
	{
		self thread force_goal( nd_4, 64, true );
	}
	
	self waittill( "goal" );
	
	self reset_movemode();
}


reinforce3_bp1_logic()
{
	self endon( "death" );
	
	nd_1 = GetNode( "alt3_1_goal", "targetname" );
	nd_2 = GetNode( "alt3_2_goal", "targetname" );
	nd_3 = GetNode( "alt3_3_goal", "targetname" );
	nd_4 = GetNode( "alt3_4_goal", "targetname" );
	
	self change_movemode( "sprint" );
	
	if ( self.script_noteworthy == "alt3_1" )
	{
		self thread force_goal( nd_1, 64, true );
		self waittill( "goal" );
		self reset_movemode();
		self set_fixednode( true );
		self thread shoot_at_target( level.player, undefined, 1, 5 );
		wait 5;
		self set_fixednode( false );
	}
	
	else if ( self.script_noteworthy == "alt3_2" )
	{
		self thread force_goal( nd_2, 64, true );
	}
	
	else if ( self.script_noteworthy == "alt3_3" )
	{
		self thread force_goal( nd_3, 64, true );
	}
	
	else if ( self.script_noteworthy == "alt3_4" )
	{
		self thread force_goal( nd_4, 64, true );
	}
	
	self waittill( "goal" );
	
	self reset_movemode();
}


spawn_reinforce1_bp1()
{
	level endon( "spawn_team_alt2" );
	level endon( "spawn_team_alt3" );
	
	flag_wait( "spawn_team_alt1" );
	
	if ( !flag( "wave1_done" ) )
	{
		a_sp_guys = GetEntArray( "bp1_reinforce_alt1", "targetname" );
	
		foreach( sp_guy in a_sp_guys )
		{
			sp_guy spawn_ai( true );
		
			wait 0.1;
		}
	}
}


spawn_reinforce2_bp1()
{
	level endon( "spawn_team_alt1" );
	level endon( "spawn_team_alt3" );
	
	flag_wait( "spawn_team_alt2" );
	
	if ( !flag( "wave1_done" ) )
	{
		a_sp_guys = GetEntArray( "bp1_reinforce_alt2", "targetname" );
	
		foreach( sp_guy in a_sp_guys )
		{
			sp_guy spawn_ai( true );
			
			wait 0.1;
		}
	}
}


spawn_reinforce3_bp1()
{
	level endon( "spawn_team_alt1" );
	level endon( "spawn_team_alt2" );
	
	flag_wait( "spawn_team_alt3" );
	
	if ( !flag( "wave1_done" ) )
	{
		a_sp_guys = GetEntArray( "bp1_reinforce_alt3", "targetname" );
	
		foreach( sp_guy in a_sp_guys )
		{
			sp_guy spawn_ai( true );
			
			wait 0.1;
		}
	}
}


monitor_cache_bp1()
{
	cache_bp1_pris = GetEnt( "ammo_cache_BP1_pristine", "targetname" );
	cache_bp1_dmg = GetEnt( "ammo_cache_BP1_damaged", "targetname" );
	cache_bp1_dest = GetEnt( "ammo_cache_BP1_destroyed", "targetname" );
	cache_bp1_clip = GetEnt( "ammo_cache_BP1_clip", "targetname" );
	
	cache_bp1_dest SetCanDamage( true );
	
	n_cache_health = 100;
	
	b_under_attack = false;
	b_down_50 = false;
	b_down_25 = false;
	b_destroyed = false;
	
	while( 1 )
	{
		cache_bp1_dest waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "apc_btr60" )
		{
			n_cache_health -= 0.5;
		}
		
		if ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "heli_hip" )
		{
			n_cache_health -= 0.5;
		}
		
		if ( ( type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH") )
		{
			n_cache_health -= 10;
		}
		
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
				cache_bp1_pris Delete();
				cache_bp1_dmg Show();
				PlayFX( level._effect[ "cache_dmg" ], cache_bp1_dmg.origin );
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
				flag_set( "cache_destroyed_bp1" );
				flag_set( "wave1_complete" );
				PlayFX( level._effect[ "cache_dest" ], cache_bp1_dest.origin );
				wait 0.1;
				cache_bp1_dest Show();
				cache_bp1_dmg Delete();
				cache_bp1_clip Delete();
			}
		}
	}
}


bp1_vehicle_destroyed()
{
	self waittill( "death" );
	
	level.n_bp1_veh_destroyed++;
	
	autosave_by_name( "bp1_vehicle_destroyed" );
}