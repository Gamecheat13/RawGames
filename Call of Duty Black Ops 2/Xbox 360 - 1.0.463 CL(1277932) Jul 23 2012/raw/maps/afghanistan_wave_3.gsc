#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_horse;
#include maps\_turret;
#include maps\_vehicle_aianim;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


init_flags()
{
	flag_init( "player_at_bp1wave3" );
	flag_init( "player_at_bp2wave3" );
	flag_init( "player_at_bp3wave3" );
	flag_init( "bp1wave3_done" );
	flag_init( "bp2wave3_done" );
	flag_init( "bp3wave3_done" );
	flag_init( "zhao_wave3_bp1" );
	flag_init( "zhao_wave3_bp2" );
	flag_init( "zhao_wave3_bp3" );
	flag_init( "wave3_started" );
	flag_init( "wave3_done" );
	flag_init( "bp1_boss_spawn" );
	flag_init( "cache4_destroyed" );
	flag_init( "bp1wave3_muj_cleared" );
	flag_init( "zhao_turn_back" );
	flag_init( "spawn_truck_chase" );
	flag_init( "truck_chase_start" );
	flag_init( "truck_chase_over" );
}


init_spawn_funcs()
{
	add_spawn_function_group( "bp1wave3_soviet", "targetname", ::bp1wave3_soviet_logic );
	add_spawn_function_group( "muj_defend_bp1wave3", "targetname", ::bp1wave3_muj_logic );
}


init_wave3bp1_setup()
{
	level clientnotify( "dbw3" );
}


skipto_wave3()
{
	skipto_setup();
	
	init_hero( "zhao" );
	init_hero( "woods" );

	skipto_teleport( "skipto_wave1", level.heroes );
	
	//level.player GiveWeapon( "sticky_grenade_afghan_sp" );
	//level.player GiveMaxAmmo( "sticky_grenade_afghan_sp" );
	
	a_weapons = level.player GetWeaponsList();
	
	for( i = 0; i < a_weapons.size; i++ )
	{
		str_class = WeaponClass( a_weapons[ i ] );
		
		if ( str_class == "pistol" )
		{
			level.player TakeWeapon( a_weapons[ i ] );
		}
	}
	
	level.player GiveWeapon( "afghanstinger_sp" );
	level.player GiveMaxAmmo( "afghanstinger_sp" );
	
	level thread maps\_horse::set_horse_in_combat( true );
	
	level.wave3_loc = "blocking point 2";
	
	flag_set( "bp2_exit" );
	
	level.zhao = getent( "zhao_ai", "targetname" );
	level.zhao SetCanDamage( false );
	
	level.woods = getent( "woods_ai", "targetname" );
	level.woods SetCanDamage( false );
	remove_woods_facemask_util();
	
	s_player_horse_spawnpt = getstruct( "wave1_player_horse_spawnpt", "targetname" );
	s_zhao_horse_spawnpt = getstruct( "wave1_zhao_horse_spawnpt", "targetname" );
	s_woods_horse_spawnpt = getstruct( "wave1_woods_horse_spawnpt", "targetname" );
	
	level.woods_horse = spawn_vehicle_from_targetname( "woods_horse" );
	level.woods_horse.origin = s_woods_horse_spawnpt.origin;
	level.woods_horse.angles = s_woods_horse_spawnpt.angles;
	
	level.zhao_horse = spawn_vehicle_from_targetname( "zhao_horse" );
	level.zhao_horse.origin = s_zhao_horse_spawnpt.origin;
	level.zhao_horse.angles = s_zhao_horse_spawnpt.angles;
	
	level.mason_horse = spawn_vehicle_from_targetname( "mason_horse" );
	level.mason_horse.origin = s_player_horse_spawnpt.origin;
	level.mason_horse.angles = s_player_horse_spawnpt.angles;
	
	level.zhao_horse MakeVehicleUnusable();
	level.mason_horse MakeVehicleUsable();
	level.woods_horse MakeVehicleUsable();
	
	level.zhao_horse GodOn();
	level.woods_horse GodOn();
		
	wait 0.1;
	
	level.zhao enter_vehicle( level.zhao_horse );
	level.woods enter_vehicle( level.woods_horse );
	
	level clientnotify( "dbw3" );
	
	wait 0.05;
	
	level.zhao_horse notify( "groupedanimevent", "ride" );
	level.woods_horse notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.zhao_horse );
	level.woods maps\_horse_rider::ride_and_shoot( level.woods_horse );
	
	level.zhao_horse SetVehicleAvoidance( true );
	level.woods_horse SetVehicleAvoidance( true );
	
	level.mason_horse waittill( "enter_vehicle", player );
	
	level thread monitor_base_health();
	level thread stock_weapon_caches();
	
	flag_wait( "afghanistan_gump_arena" );
	
	level.zhao_horse thread maps\afghanistan_wave_3::follow_player();
	
	wait 1;
	
	level.woods_horse thread maps\afghanistan_wave_3::follow_player();
	
	//level thread skipto_bp1wave3();
}


skipto_bp1wave3()
{
	flag_wait( "player_at_bp1wave3" );
	
	level.woods_horse thread woods_goto_bp1wave3();
	level.zhao_horse thread zhao_goto_bp1wave3();
}


main()
{
	maps\createart\afghanistan_art::open_area();
	
	if (  level.skipto_point == "wave_3" )
	{
		maps\afghanistan_anim::init_afghan_anims_part1b();
		
		delete_section1_scenes();
		delete_section3_scenes();
	}
	
	level.n_current_wave = 3;
	
	init_spawn_funcs();
	init_wave3bp1_setup();
	
	level thread spawn_weapon_cache4( "afghanstinger" );
	level thread check_player_location();
	level thread objectives_wave3();
	
	level thread wave3_bp1_main();
	
	if ( level.wave3_loc == "blocking point 2" )
	{
		level thread wave3_bp2_main();
		
		flag_wait_all( "bp1wave3_done", "bp2wave3_done" );
	}
	else
	{
		level thread wave3_bp3_main();
		
		flag_wait_all( "bp1wave3_done", "bp3wave3_done" );
	}
	
	flag_set( "wave3_done" );
}


follow_player()  //self = horse
{
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 300 );
	self setspeed( 25, 20, 15 );
	
	while( 1 )
	{
		if ( Distance2DSquared( self.origin, level.player.origin ) > ( 400 * 400 ) )
		{
			self SetBrake( false );
			
			self setvehgoalpos( level.player.origin, 1, 1 );
			
			self waittill( "near_goal" );
			
			if ( flag( "player_at_bp1wave3" ) )
			{
				break;	
			}
			
			if ( flag( "player_at_bp2wave3" ) )
			{
				break;	
			}
			
			if ( flag( "player_at_bp3wave3" ) )
			{
				break;	
			}
			
			self SetBrake( true );
		}
		
		wait 1;
	}
}


zhao_goto_bp3()
{
	while( Distance2D( level.zhao.origin, level.player.origin ) > 750 )
	{
		wait 1;
	}
	
	flag_set( "goto_bp3" );
	
	level.zhao ai_mount_horse( self );
	
	wait 1;
	
	s_zhao_bp3 = getstruct( "zhao_bp3", "targetname" );
	s_zhao_bp3_approach = getstruct( "bp3_entrance", "targetname" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	self SetVehGoalPos( s_zhao_bp3_approach.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self SetVehGoalPos( s_zhao_bp3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_set( "zhao_at_bp3" );
}


woods_goto_bp3()
{
	flag_wait( "goto_bp3" );
	
	level.woods ai_mount_horse( self );
	
	wait 1;
	
	s_zhao_bp3 = getstruct( "zhao_bp3", "targetname" );
	s_zhao_bp3_approach = getstruct( "bp3_entrance", "targetname" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	self SetVehGoalPos( s_zhao_bp3_approach.origin + ( 150, 0, 0 ), 0, true );
	self waittill_any( "goal", "near_goal" );
	self SetVehGoalPos( s_zhao_bp3.origin + ( 0, -150, 0 ), 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 3: BLOCKING POINT 1 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
wave3_bp1_main()
{
	bp1_wave3();
}


bp1_wave3()
{
	level.n_bp1wave3_veh_destroyed = 0;
	
	trigger_wait( "spawn_bp1_wave3" );
	
	//level thread instructions_bp1_wave3();
		
	flag_set( "player_at_bp1wave3" );
	
	//level thread replenish_arena_wave3bp1();
	//level thread spawn_bp1_spetznaz();
				
	autosave_by_name( "wave3_blocking_point1" );
	
	cleanup_arena();
	
	if ( flag( "wave3_started" ) )
	{
		flag_wait_any( "bp2wave3_done", "bp3wave3_done" );
		
		level thread spawn_truckride();
		level thread hind_truck_chase();
	}
	
	//level thread bp1wave3_vehicle_chooser();
	level thread bp1wave3_boss_chooser();
			
	spawn_manager_enable( "manager_soviet_bp1wave3" );
	spawn_manager_enable( "manager_muj_bp1wave3" );
	
	level thread monitor_bp1wave3_muj();
	
	flag_set( "wave3_started" );
			
	flag_wait( "bp1wave3_done" );
	
	level thread cleanup_bp1wave3();
}


spawn_truckride()
{
	s_spawnpt = getstruct( "truckride_spawnpt", "targetname" );
	
	vh_truck = spawn_vehicle_from_targetname( "truck_afghan" );
	vh_truck.origin = s_spawnpt.origin;
	vh_truck.angles = s_spawnpt.angles;
	vh_truck.targetname = "truck_ride";
		
	wait 0.1;
	
	sp_rider = GetEnt( "muj_assault", "targetname" );
	
	ai_rider = sp_rider spawn_ai( true );
	
	if ( IsDefined( ai_rider ) )
	{
		ai_rider enter_vehicle( vh_truck );	
	}
	
	if ( IsDefined( vh_truck ) )
	{
		vh_truck thread truckride_logic();	
	}
}


truckride_logic()
{
	self endon( "death" );
	
	self veh_magic_bullet_shield( true );
	self SetVehicleAvoidance( true );
	self MakeVehicleUnusable();
	
	nd_start = GetVehicleNode( "truckride_start", "targetname" );
	self thread go_path( nd_start );
	
	nd_pickup = GetVehicleNode( "truckride_pickup", "targetname" );
	nd_pickup waittill( "trigger" );
	
	self SetSpeedImmediate( 0 );
	self SetBrake( true );
	
	self MakeVehicleUsable();
	
	level.player thread say_dialog( "maso_woods_there_s_a_mo_0", 1 );  //Woods,  there's a mounted MG on that truck!
	
	self waittill( "enter_vehicle", player );
	
	self MakeVehicleUnusable();
	
	self thread monitor_mason_on_truck();
	
	level.mason_horse thread horse_follow_truck();
	
	if ( !flag( "bp1wave3_done" ) )
	{
		flag_wait( "bp1wave3_done" );
	}
	
	wait 3;
	
	self ResumeSpeed( 5 );
	self SetBrake( false );
	
	flag_set( "truck_chase_start" );
	
	nd_hind = GetVehicleNode( "truckride_spawn_hind", "targetname" );
	nd_hind waittill( "trigger" );
	
	flag_set( "spawn_truck_chase" );
	
	self waittill( "reached_end_node" );
	
	flag_set( "truck_chase_over" );
	
	self MakeVehicleUsable();
	
	self vehicle_detachfrompath();
	
	self SetBrake( true );
}


monitor_mason_on_truck()
{
	self waittill( "exit_vehicle", player );
	
	flag_set( "truck_chase_over" );
	
	autosave_by_name( "wave3_bp1_truckdone" );
}


horse_follow_truck()
{
	flag_wait( "truck_chase_start" );
	
	self SetSpeed( 55, 35, 20 );
	self SetNearGoalNotifyDist( 300 );
	
	while( !flag( "truck_chase_over" ) )
	{
		if ( Distance2DSquared( self.origin, level.player.origin ) > ( 400 * 400 ) )
		{
			self SetBrake( false );
			
			self setvehgoalpos( level.player.origin, 1, 1 );
			
			self waittill( "near_goal" );
			
			self SetBrake( true );
		}
		
		wait 1;
	}
	
	if ( Distance2DSquared( self.origin, level.player.origin ) > ( 400 * 400 ) )
	{
		self SetBrake( false );
			
		self setvehgoalpos( level.player.origin, 1, 1 );
			
		self waittill( "near_goal" );
			
		self horse_stop();
	}
}


hind_truck_chase()
{
	flag_wait_any( "bp1wave4_start", "spawn_truck_chase" );
	
	if ( flag( "spawn_truck_chase" ) )
	{
		s_spawnpt = GetVehicleNode( "hind_truckchase_start", "targetname" );
	}
	
	else
	{
		s_spawnpt = getstruct( "bp1wave4_hind2_spawnpt", "targetname" );
	}
	
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	
	if ( flag( "spawn_truck_chase" ) )
	{
		vh_hind thread hind_truck_chase_logic();	
	}
	
	else
	{
		vh_hind thread maps\afghanistan_blocking_done::bp1wave4_hind2_behavior();
	}
}


hind_truck_chase_logic()
{
	self endon( "death" );
	
	//self thread maps\afghanistan_blocking_done::vehicle_delete_after_defend();
	//self thread maps\afghanistan_blocking_done::update_wave4_objective();
	
	Target_Set( self, ( -50, 0, -32 ) );
	self SetForceNoCull();
	
	self thread go_path( GetVehicleNode( "hind_truckchase_start", "targetname" ) );
	
	wait 2;
	
	self thread hind_truck_chase_attack();
	
	self waittill( "reached_end_node" );
	
	self notify( "stop_fire" );
	
	self vehicle_detachfrompath();
	
	self thread hind_truck_chase_behavior();
}


hind_truck_chase_attack()
{
	self endon( "death" );
	self endon( "stop_fire" );
	
	vh_truck = GetEnt( "truck_ride", "targetname" );
	
	while( 1 )
	{
		if ( IsDefined( vh_truck ) )
		{
			self set_turret_target( vh_truck, ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ) ), 1 );
			self fire_turret( 1 );
		
			wait 0.2;
			
			if ( IsDefined( vh_truck ) )
			{
				self set_turret_target( vh_truck, ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ) ), 2 );
				self fire_turret( 2 );
			}
		
			wait RandomFloatRange( 1.0, 2.5 );
		}
	}
}


hind_truck_chase_behavior()
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 200 );
	self setspeed( 100, 50, 25 );
	
	self SetVehGoalPos( getstruct( "bp1wave4_hind2_goal13", "targetname" ).origin, 0 );
	self waittill_any( "goal", "near_goal" );
		
	a_s_goal = [];
		
	for( i = 9; i < 19; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hind2_goal"+i, "targetname" );
	}
	
	i = 14;

	while( 1 )
	{
		if ( i == 17 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 11 )
		{
			self thread hind_attack_base();
		}
		
		if ( i == 12 )
		{
			self notify( "stop_attack" );
		}
		
		if ( i == 17 )
		{
			self thread hind_attack_indefinitely();
			
			wait RandomFloatRange( 5.0, 8.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
		
		i++;
		
		if ( i > 18 )
		{
			i = 9;	
		}
	}		
}


instructions_bp1_wave3()
{
	flag_wait( "wave3_started" );
	
	level.zhao say_dialog( "zhao_the_soviets_have_ove_0", 3 );
	
	wait 1;
		
	level.zhao say_dialog( "zhao_we_must_fallback_0" );
	
	//TODO
	wait 20;

	if ( level.n_bp1wave3_boss == 0 )
	{	
		level.zhao say_dialog( "zhao_keep_those_tanks_fro_0" );
			
		wait 1;
		
		level.zhao say_dialog( "zhao_keep_those_helicopte_0" );
	}
	
	else if ( level.n_bp1wave3_boss == 1 )
	{
		level.zhao say_dialog( "zhao_don_t_let_those_tank_0" );
	}
	
	else
	{
		level.zhao say_dialog( "zhao_don_t_let_those_heli_0" );
	}
}


cleanup_bp1wave3()
{
	spawn_manager_kill( "manager_muj_bp1wave3" );
}


replenish_arena_wave3bp1()
{
	trigger_wait( "bp1_replenish_arena" );
	
	if ( !flag( "bp1wave3_done" ) )
	{
		level thread replenish_wave3bp1();
	}
	
	spawn_manager_disable( "manager_muj_bp1wave3" );
	
	wait 0.1;
	
	cleanup_bp_ai();
	respawn_arena();
}


replenish_wave3bp1()
{
	trigger_wait( "spawn_bp1" );
	
	cleanup_arena();
	
	wait 0.1;
	
	spawn_manager_enable( "manager_soviet_bp1wave3" );
	spawn_manager_enable( "manager_muj_bp1wave3" );
	
	level thread replenish_arena_wave3bp1();
}


bp1wave3_replenish_arena()
{
	trigger_wait( "bp1_replenish_arena" );
	
	if ( !flag( "bp1wave3_done" ) )
	{
		level thread replenish_bp1wave3();
	}
	
	wait 0.1;
	
	cleanup_bp_ai();
	respawn_arena();
}


replenish_bp1wave3()
{
	trigger_wait( "spawn_bp1" );
	
	cleanup_arena();
	
	wait 0.1;
	
	level thread bp1wave3_replenish_arena();
}


spawn_bp1_spetznaz()
{
	trigger_wait( "trigger_bp1wave3_entered" );
	
	trigger_wait( "trigger_bp1_spetznaz_runners" );
	
	if ( !flag( "wave3_done" ) )
	{
		sp_sniper = GetEnt( "bp2_bp3_sniper", "targetname" );
		ai_sniper = sp_sniper spawn_ai( true );
		ai_sniper.no_cleanup = true;
	}
}


bp1wave3_muj_logic()
{
	self endon( "death" );
	
	self.bp_ai = true;
	
	self set_spawner_targets( "bp1_cache_perimeter" );
}


bp1wave3_soviet_logic()
{
	self endon( "death" );
	
	self.bp_ai = true;
	
	self set_spawner_targets( "bp1_cache_perimeter" );
}


monitor_bp1wave3_muj()
{
	waittill_spawn_manager_cleared( "manager_muj_bp1wave3" );
	
	flag_set( "bp1wave3_muj_cleared" );	
}


bp1wave3_vehicle_chooser()  //no ground vehicles allowed since we blew up the entrance
{
	//level.n_bp1wave3_vehicles = RandomInt( 3 );
	level.n_bp1wave3_vehicles = 1;
	
	wait 1;
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, undefined, undefined, level.n_bp1wave3_veh_destroyed );
	
	wait 1;
	
	if ( level.n_bp1wave3_vehicles == 0 )
	{
		trigger_use( "bp1wave3_btr1_trigger" );
		wait 1;
		level thread spawn_hip1_bp1();
	}
	
	else if ( level.n_bp1wave3_vehicles == 1 )
	{
		level thread spawn_hip1_bp1();
		wait 1;
		level thread spawn_hip2_bp1();
	}
	
	else
	{
		trigger_use( "bp1wave3_btr1_trigger" );
		wait 1;
		trigger_use( "bp1wave3_btr2_trigger" );
	}
	
	wait 7;
	
	level thread bp1wave3_boss_chooser();
}


bp1wave3_boss_chooser()  //no ground vehicles allowed since we blew up the entrance
{
	//level.n_bp1wave3_boss = RandomInt( 3 );
	level.n_bp1wave3_boss = 2;
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, undefined, undefined, level.n_bp1wave3_veh_destroyed );
	
	wait 1;
			
	if ( level.n_bp1wave3_boss == 0 )
	{
		trigger_use( "bp1wave3_tank1_trigger" );
		wait 2;
		level thread spawn_hind1_bp1();
	}
	
	else if ( level.n_bp1wave3_boss == 1 )
	{
		trigger_use( "bp1wave3_tank2_trigger" );
		wait 2;
		trigger_use( "bp1wave3_tank1_trigger" );
	}
	
	else
	{
		level thread spawn_hind1_bp1();
		wait 2;
		level thread spawn_hind2_bp1();
	}
}


spawn_hip1_bp1()
{
	s_spawnpt = getstruct( "bp1wave3_hip1_spawnpt", "targetname" );
	
	hip1 = spawn_vehicle_from_targetname( "hip_soviet" );
	hip1.origin = s_spawnpt.origin;
	hip1.angles = s_spawnpt.angles;
	hip1 thread bp1wave3_hip1_behavior();
	hip1 thread delete_corpse_wave3();
}


spawn_hip2_bp1()
{
	s_spawnpt = getstruct( "bp1wave3_hip2_spawnpt", "targetname" );
	
	hip2 = spawn_vehicle_from_targetname( "hip_soviet" );
	hip2.origin = s_spawnpt.origin;
	hip2.angles = s_spawnpt.angles;
	hip2 thread bp1wave3_hip2_behavior();
	hip2 thread delete_corpse_wave3();
}


spawn_hind1_bp1()
{
	s_spawnpt = getstruct( "bp1_hind1_spawnpt", "targetname" );
	
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	vh_hind thread hind1_behavior();
	vh_hind thread delete_corpse_wave3();
}


spawn_hind2_bp1()
{
	s_spawnpt = getstruct( "bp1_hind2_spawnpt", "targetname" );
	
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	vh_hind thread hind2_behavior();
	vh_hind thread delete_corpse_wave3();
}


bp1wave3_hip1_behavior()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "bp1wave3_hip1_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave3_hip1_goal2", "targetname" );
	
	self thread heli_select_death();
	self thread nag_destroy_vehicle();
	self thread bp1wave3_vehicle_destroyed();
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, self, "destroy", -1 );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	self HidePart( "tag_back_door" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 35, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0 );
	
	self thread hip_attack();
	
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	//self notify( "stop_attack" );
	
	self thread load_landing_troops( 4 );
	
	self hip_rappel_unload( "bp1wave3_hip1_goal3" );
	
	self setspeed( 50, 25, 20 );
	
	self thread hip_circle( getstruct( "bp1wave3_hip_circle2", "targetname" ) );
	self thread hip_attack();
	
	flag_wait( "cache4_destroyed" );
	
	self notify( "stop_circle" );
	
	self thread hip_circle( getstruct( "hip_arena_circle1", "targetname" ) );
}


bp1wave3_hip2_behavior()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "bp1wave3_hip2_goal1", "targetname" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self thread heli_select_death();
	self thread hip_attack();
	self thread nag_destroy_vehicle();
	self thread bp1wave3_vehicle_destroyed();
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, self, "destroy", -1 );
		
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self setspeed( 35, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0 );

	self waittill_any( "goal", "near_goal" );
	
	self thread hip_circle( getstruct( "bp1wave3_hip_circle1", "targetname" ) );
	
	flag_wait( "cache4_destroyed" );
	
	self notify( "stop_circle" );
	
	self thread hip_circle( getstruct( "hip_arena_circle1", "targetname" ) );
}


hind1_behavior()  //self = hind
{
	self endon( "death" );
	level endon( "cache4_destroyed" );
	
	self thread heli_select_death();
	self thread bp1wave3_hind1_flyto_base();
	self thread nag_destroy_vehicle();
	self thread bp1wave3_vehicle_destroyed();
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, self, "destroy", -1 );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 500 );
	self SetVehicleAvoidance( true );
	self SetForceNoCull();
	
	cache_dest = GetEnt( "ammo_cache_arena_4_destroyed", "targetname" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1_hind1_spawnpt", "targetname" );
	
	for ( i = 1; i < 10; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1_hind1_goal"+i, "targetname" );
	}
			
	self setspeed( 150, 65, 35 );
	
	self.b_outgoing = true;
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 5 || i == 9 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
			self waittill_any( "goal", "near_goal" );
			
			self thread hind_rocket_attack();
			
			wait RandomFloatRange( 2.0, 3.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
		
		else if ( i == 7 )
		{
			self setvehgoalpos( a_s_goal[i].origin, 0 );
			self waittill_any( "goal", "near_goal" );
			
			level.player thread say_dialog( "maso_incoming_choper_0", 1 );  //Incoming chopper!
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[i].origin, 0 );
			self waittill_any( "goal", "near_goal" );
		}
		
		if ( self.b_outgoing )
		{
			i++;
			
			if ( i > 9 )
			{
				self.b_outgoing = false;
				
				i = 8;
			}
		}
		
		else
		{
			i--;

			if ( i < 5 )
			{
				self.b_outgoing = true;
				
				i = 6;
			}
		}
		
		if ( i == 9 && flag( "bp1wave3_muj_cleared" ) )
		{
			self notify( "stop_attack" );
			self ClearLookAtEnt();
			
			self setvehgoalpos( a_s_goal[ 9 ].origin, 1 );
			self waittill_any( "goal", "near_goal" );
			
			break;
		}
	}
	
	goal1 = getstruct( "bp1_hind1_cache1", "targetname" );
	goal2 = getstruct( "bp1_hind1_cache2", "targetname" );
	goal3 = getstruct( "bp1_hind1_cache3", "targetname" );
	
	while( 1 )
	{
		self setvehgoalpos( goal1.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self thread hind_rocket_target( cache_dest );
				
		wait RandomFloatRange( 3.0, 5.0 );
		
		self setvehgoalpos( goal2.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self thread hind_rocket_target( cache_dest );
		
		wait RandomFloatRange( 3.0, 5.0 );
		
		self setvehgoalpos( goal3.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self thread hind_rocket_target( cache_dest );
		
		wait RandomFloatRange( 3.0, 5.0 );
		
		self setvehgoalpos( goal2.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self thread hind_rocket_target( cache_dest );
		
		wait RandomFloatRange( 3.0, 5.0 );
	}
}


bp1wave3_hind1_flyto_base()
{
	self endon( "death" );
	
	flag_wait( "cache4_destroyed" );
	
	self notify( "stop_attack" );
	
	wait RandomFloatRange( 1.0, 2.0 );
	
	self ClearLookAtEnt();
	
	self thread hind1_attack_base();

	level.zhao say_dialog( "zhao_that_chopper_is_head_0" );
}


hind1_attack_base()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 500 );
	self SetVehicleAvoidance( true );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1_hind1_spawnpt", "targetname" );
	
	for ( i = 1; i < 8; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1_hind1_basegoal"+i, "targetname" );
	}
	
	self ClearVehGoalPos();
			
	self setspeed( 100, 45, 35 );
	
	i = 1;
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 1 )
		{
			self setspeed( 60, 45, 35 );
			self thread hind_rocket_strafe();
		}
		
		if ( i == 3 )
		{
			self notify( "stop_strafe" );
		}
		
		if ( i == 5 )
		{
			self setspeed( 120, 45, 35 );
		}
		
		if ( i == 6 )
		{
			self setspeed( 60, 45, 35 );
		}
		
		i++;
		
		if ( i > 7 )
		{
			i = 1;	
		}
	}
}


hind2_behavior()  //self = hind
{
	self endon( "death" );
	level endon( "cache4_destroyed" );
	
	self thread heli_select_death();
	self thread bp1wave3_hind2_flyto_base();
	self thread nag_destroy_vehicle();
	self thread bp1wave3_vehicle_destroyed();
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, self, "destroy", -1 );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 500 );
	self SetVehicleAvoidance( true );
	self SetForceNoCull();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1_hind2_spawnpt", "targetname" );
	
	for ( i = 1; i < 10; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1_hind2_goal"+i, "targetname" );
	}
			
	self setspeed( 150, 65, 35 );
	
	self.b_outgoing = true;
	
	i = 1;
	
	cache_dest = GetEnt( "ammo_cache_arena_4_destroyed", "targetname" );
	
	while( 1 )
	{
		if ( i == 3 || i == 9 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
			self waittill_any( "goal", "near_goal" );
			
			self thread hind_rocket_attack();
			
			wait RandomFloatRange( 2.0, 3.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
			self waittill_any( "goal", "near_goal" );
		}
		
		if ( self.b_outgoing )
		{
			i++;
			
			if ( i > 9 )
			{
				self.b_outgoing = false;
				
				i = 8;
			}
		}
		
		else
		{
			i--;

			if ( i < 3 )
			{
				self.b_outgoing = true;
				
				i = 6;
			}
		}
		
		if ( i == 9 && flag( "bp1wave3_muj_cleared" ) )
		{
			self notify( "stop_attack" );
			self ClearLookAtEnt();
			
			self setvehgoalpos( a_s_goal[ 9 ].origin, 1 );
			self waittill_any( "goal", "near_goal" );
			
			break;
		}
	}
	
	goal1 = getstruct( "bp1_hind2_cache1", "targetname" );
	goal2 = getstruct( "bp1_hind2_cache2", "targetname" );
		
	while( 1 )
	{
		self setvehgoalpos( goal1.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self thread hind_rocket_target( cache_dest );
				
		wait RandomFloatRange( 3.0, 5.0 );
		
		if ( cointoss() )
		{
			self setvehgoalpos( goal1.origin + ( 0, 0, -800 ), 1 );
			self waittill_any( "goal", "near_goal" );
			self thread hind_rocket_target( cache_dest );
			
			wait RandomFloatRange( 3.0, 5.0 );
		}
				
		self setvehgoalpos( goal2.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self thread hind_rocket_target( cache_dest );
		
		wait RandomFloatRange( 3.0, 5.0 );
		
		if ( cointoss() )
		{
			self setvehgoalpos( goal2.origin + ( 0, 0, -800 ), 1 );
			self waittill_any( "goal", "near_goal" );
			self thread hind_rocket_target( cache_dest );
			
			wait RandomFloatRange( 3.0, 5.0 );
		}
	}
}


bp1wave3_hind2_flyto_base()
{
	self endon( "death" );
	
	flag_wait( "cache4_destroyed" );
	
	wait RandomFloatRange( 1.0, 2.0 );
	
	self notify( "stop_attack" );
	
	self ClearLookAtEnt();
	
	self thread hind2_attack_base();

	level.zhao say_dialog( "zhao_that_chopper_is_head_0" );
}


hind2_attack_base()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 500 );
	self SetVehicleAvoidance( true );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1_hind2_spawnpt", "targetname" );
	
	for ( i = 1; i < 8; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1_hind2_basegoal"+i, "targetname" );
	}
	
	self ClearVehGoalPos();
			
	self setspeed( 100, 45, 35 );
	
	i = 1;
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 1 )
		{
			self setspeed( 60, 45, 35 );
			self thread hind_rocket_strafe();
		}
		
		if ( i == 3 )
		{
			self notify( "stop_strafe" );
		}
		
		if ( i == 5 )
		{
			self setspeed( 120, 45, 35 );
		}
		
		if ( i == 6 )
		{
			self setspeed( 60, 45, 35 );
		}
		
		i++;
		
		if ( i > 7 )
		{
			i = 1;	
		}
	}
}


bp1wave3_vehicle_destroyed()
{
	self waittill( "death", attacker );
	
	level.n_bp1wave3_veh_destroyed++;
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, self, "remove" );
	
	wait 0.2;
	
	set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, undefined, undefined, level.n_bp1wave3_veh_destroyed );
	
	if ( level.n_bp1wave3_veh_destroyed > 1 && !flag( "bp1wave3_done" ) )
	{
		level.player thread say_dialog( "maso_chopper_s_down_0", 1 );	//Chopper's down!
		
		flag_set( "bp1wave3_done" );
		
		set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, undefined, "done" );
		
		wait 3;
		
		set_objective( level.OBJ_AFGHAN_BP1WAVE3_VEHICLES, undefined, "delete" );
	}
	
	else
	{
		level.woods thread say_dialog( "wood_mason_stay_on_em_0", 1 );  //Mason!  Stay on ‘em!	
	}
	
	autosave_by_name( "wave3_bp1_vehicle" );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 3: BLOCKING POINT 2 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
wave3_bp2_main()
{
	maps\afghanistan_wave_2::wave2_bp2_main();
	
	if ( !flag( "bp1wave3_done" ) )
	{
		level.zhao_horse thread maps\afghanistan_wave_3::zhao_goto_bp1wave3();
		level.woods_horse thread maps\afghanistan_wave_3::woods_goto_bp1wave3();
	}
}


bp2wave3_hind_behavior()
{
	self endon( "death" );
	
	self thread maps\afghanistan_wave_2::bp2_vehicle_destroyed();
	self thread heli_select_death();
	self thread set_flag_ondeath( "bp2wave3_hind_chase_dead" );
			
	set_objective( level.OBJ_AFGHAN_BP2WAVE3_VEHICLES, self, "destroy", -1 );
		
	self SetNearGoalNotifyDist( 200 );
	self SetForceNoCull();
	Target_Set( self, ( -50, 0, -32 ) );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave3_hind_spawnpt", "targetname" );
	
	for ( i = 1; i < 14; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave3_hind_goal"+i, "targetname" );
	}
			
	self setspeed( 100, 45, 35 );
	
	i = 1;
	
	self thread vo_hind_breakaway();
		
	while( i < 14 )
	{
		if ( i == 5 || i == 11 || i == 12 )
		{
			self setvehgoalpos( a_s_goal[i].origin, 1 );
			self waittill_any( "goal", "near_goal" );
			
			self bp2wave3_hind_aiattack();
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[i].origin, 0 );
			self waittill_any( "goal", "near_goal" );
		}
		
		if ( i == 3 )
		{
			flag_set( "bp2wave3_hind_chase" );	
		}
		
		if ( i == 7 )
		{
			self thread bp2wave3_hind_baseattack();
		}
		
		i++;
		
		if ( i > 13 )
		{
			i = 5;
		}
	}
}


vo_hind_breakaway()
{
	self endon( "death" );
	
	level.player say_dialog( "maso_watch_it_incoming_0", 2 );  //Watch it, incoming Hind!
	
	level.woods say_dialog( "wood_get_that_hind_mason_0", 1 );  //Get that Hind, Mason!  Gotta bring the bastard down.
	
	level.woods say_dialog( "wood_i_m_going_after_him_0", 0.5 ); //I'm going after him! On me!
}


bp2wave3_hind_baseattack()
{
	self endon( "death" );
	
	e_base_target = spawn_model( "tag_origin", ( 15104, -10100, 36 ), ( 0, 0, 0 ) );
	
	MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), e_base_target.origin, undefined, e_base_target, ( RandomIntRange( -500, 500 ), RandomIntRange( -500, 500 ), RandomIntRange( -200, 200 ) ) );
	
	wait 0.2;
	
	MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), e_base_target.origin, undefined, e_base_target, ( RandomIntRange( -500, 500 ), RandomIntRange( -500, 500 ), RandomIntRange( -200, 200 ) ) );
}


bp2wave3_hind_aiattack()
{
	self endon( "death" );
	
	a_ai_enemies = GetAIArray( "axis" );
	
	for ( i = 0; i < a_ai_enemies.size; i++ )
	{
		e_target = a_ai_enemies[ RandomInt( a_ai_enemies.size ) ];
		
		if ( Distance2DSquared( self.origin, e_target.origin ) <= ( 3000 * 3000 ) )
		{
			break;	
		}
	}
	
	if ( RandomInt( 4 ) == 1 )
	{
		e_target = level.player;
	}
	
	if ( IsDefined( e_target ) )
	{
		self setLookAtEnt( e_target );
	}
	
	wait 2;
	
	if ( IsDefined( e_target ) )
	{
		MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), e_target.origin, undefined, e_target, ( RandomIntRange( -500, 500 ), RandomIntRange( -500, 500 ), RandomIntRange( -200, 200 ) ) );
	
		wait 0.2;
		
		if ( IsDefined( e_target ) )
		{
			MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), e_target.origin, undefined, e_target, ( RandomIntRange( -500, 500 ), RandomIntRange( -500, 500 ), RandomIntRange( -200, 200 ) ) );
		}
	}
	
	self ClearLookAtEnt();
}


hind_approach_attack()
{
	e_target = vehicle_acquire_target();
	
	self SetLookAtEnt( e_target );
		
	wait 3;
	
	self thread hind_fireat_target( e_target );
	
	self setvehgoalpos( e_target.origin + ( 0, 0, 1000 ), 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetNearGoalNotifyDist( 200 );
		
	self ClearLookAtEnt();
}


bp2wave3_tank_behavior()
{
	self endon( "death" );
	
	nd_start = GetVehicleNode( "wave3bp2_tank_startnode", "targetname" );
	nd_approach = GetVehicleNode( "bp2wave3_tank2_approach", "targetname" );
	nd_exit = GetVehicleNode( "wave3bp2_tank_cache", "targetname" );
	
	self thread maps\afghanistan_wave_2::bp2_vehicle_destroyed();
	self thread set_flag_ondeath( "bp2wave3_tank_chase_dead" );
	
	wait 0.1;
	
	self thread go_path( nd_start );
	
	self.overrideVehicleDamage = ::tank_damage;
	
	self thread delete_corpse_wave3();
	
	nd_approach waittill( "trigger" );
	
	set_objective( level.OBJ_AFGHAN_BP2WAVE3_VEHICLES, self, "destroy", -1 );
	
	self thread vo_tank_approaching();
		
	self thread tank_targetting();
	
	nd_exit waittill( "trigger" );
	
	flag_set( "bp2wave3_tank_chase" );
	
	self thread vo_tank_breakaway();
	
	self waittill( "reached_end_node" );
	
	level.woods thread say_dialog( "wood_take_down_that_damn_0", 0 );  //Take down that damn tank!
	
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
}


vo_tank_approaching()
{
	self endon( "death" );
	
	level.woods say_dialog( "wood_got_tanks_coming_in_0", 0 );  //Got tanks coming in!
	
	level.player say_dialog( "maso_that_tank_is_moving_0", 1 );  //That tank is moving fast!
	
	level.woods say_dialog( "wood_damn_tank_s_making_a_0", 1 );//Damn tank's making a move on the base!
}


vo_tank_breakaway()
{
	self endon( "death" );
	
	level.woods say_dialog( "wood_i_m_going_after_him_0", 0 );  //I'm going after him! On me!
	
	level.woods say_dialog( "wood_gotta_stop_them_mas_0", 0.5 ); //Gotta stop them, Mason!
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 3: BLOCKING POINT 3 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
wave3_bp3_main()
{
	maps\afghanistan_wave_2::wave2_bp3_main();
	
	if ( !flag( "bp1wave3_done" ) )
	{
		level.zhao_horse thread maps\afghanistan_wave_3::zhao_goto_bp1wave3();
		level.woods_horse thread maps\afghanistan_wave_3::woods_goto_bp1wave3();
	}
}


bp3wave3_hind_behavior()
{
	self endon( "death" );
	
	self thread maps\afghanistan_wave_2::bp3_vehicle_destroyed();
	self thread heli_select_death();
	self thread delete_corpse_wave3();
	self thread set_flag_ondeath( "bp3wave3_hind_chase_dead" );
	
	set_objective( level.OBJ_AFGHAN_BP3WAVE3_VEHICLES, self, "destroy", -1 );
		
	self SetNearGoalNotifyDist( 200 );
	self SetForceNoCull();
	Target_Set( self, ( -50, 0, -32 ) );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave3_hind_spawnpt", "targetname" );
	
	for ( i = 1; i < 13; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave3_hind_goal"+i, "targetname" );
	}
			
	self setspeed( 100, 45, 35 );
	
	i = 1;
	
	self thread vo_hind_breakaway();
	
	while( 1 )
	{
		if ( i == 9 || i == 12 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
			self waittill_any( "goal", "near_goal" );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
			self waittill_any( "goal", "near_goal" );
		}
		
		if ( i == 4 )
		{
			flag_set( "bp3wave3_hind_chase" );	
		}
		
		if ( i == 2 || i == 6 )
		{
			self notify( "stop_strafe" );
			
			wait 0.1;
			
			self thread hind_rocket_strafe();
		}
		
		else if ( i == 4 || i == 8 || i == 11 )
		{
			self notify( "stop_strafe" );
		}
		
		else if ( i == 9 || i == 12 )
		{
			self thread hind_attack_indefinitely();	
			
			wait RandomFloatRange( 5.0, 8.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
			
			self thread hind_rocket_strafe();
		}
		
		i++;
		
		if ( i > 12 )
		{
			i = 6;
		}
	}
}


hind_fire_while_hover( n_fire_num )
{
	for ( i = 0; i < n_fire_num; i++ )
	{
		e_target = vehicle_acquire_target();
		
		self SetLookAtEnt( e_target );
		
		wait 3;
			
		self hind_fireat_target( e_target );
		
		self ClearLookAtEnt();
	}	
}


bp3wave3_tank_behavior()
{
	self endon( "death" );
	
	self.overrideVehicleDamage = ::tank_damage;
		
	self thread maps\afghanistan_wave_2::bp3_vehicle_destroyed();
	self thread delete_corpse_wave3();
	self thread go_path( GetVehicleNode( "wave3bp3_tank_startnode", "targetname" ) );
	self thread set_flag_ondeath( "bp3wave3_tank_chase_dead" );
	self thread tank_targetting();
	
	set_objective( level.OBJ_AFGHAN_BP3WAVE3_VEHICLES, self, "destroy", -1 );
	
	nd_approach = GetVehicleNode( "bp3_tank2_approach", "targetname" );
	nd_exit = GetVehicleNode( "bp3_tank2_exit", "targetname" );
	
	nd_approach waittill( "trigger" );
	
	level.woods thread say_dialog( "wood_got_tanks_coming_in_0", 0 );  //Got tanks coming in!
	level.player thread say_dialog( "maso_that_tank_is_moving_0", 2 );  //That tank is moving fast!
	
	nd_exit waittill( "trigger" );
	
	flag_set( "bp3wave3_tank_chase" );
	
	level.woods say_dialog( "wood_come_on_mason_we_0", 0 );  //Come on, Mason!  We gotta take out these tanks!
	
	self waittill( "reached_end_node" );
	
	level.woods thread say_dialog( "wood_take_down_that_damn_0", 0 );  //Take down that damn tank!
	
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
objectives_wave3()
{
	s_bp1_entrance = getstruct( "bp1_obj_marker2", "targetname" );
	s_bp2_entrance = getstruct( "bp2_obj_marker", "targetname" );
	s_bp3_entrance = getstruct( "bp3_obj_marker", "targetname" );
	
	flag_wait_any( "bp2_exit", "bp3_exit" );
	
	level.player SetClientDvar( "cg_objectiveIndicatorFarFadeDist", 20000 );
	
	set_objective( level.OBJ_FOLLOW_BP3, level.zhao, "remove" );
		
	level.n_wave3_bp = 0;
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	set_objective( level.OBJ_BP1_WAVE3, s_bp1_entrance, "breadcrumb" );
	
	level thread waittill_bp1wave3_done();
	
	if ( level.wave3_loc == "blocking point 2" )
	{
		set_objective( level.OBJ_BP2_WAVE3, s_bp2_entrance, "breadcrumb" );
		
		level thread waittill_bp2wave3_done();
	}
	
	else
	{
		set_objective( level.OBJ_BP3_WAVE3, s_bp3_entrance, "breadcrumb" );
		
		level thread waittill_bp3wave3_done();
	}
	
	flag_wait( "wave3_started" );
	
	if ( flag( "player_at_bp1wave3" ) )
	{
		if ( level.wave3_loc == "blocking point 2" )
		{
			set_objective( level.OBJ_BP2_WAVE3, s_bp2_entrance, "remove" );
			
			flag_wait( "bp1wave3_done" );
			
			set_objective( level.OBJ_BP2_WAVE3 );
			set_objective( level.OBJ_BP2_WAVE3, s_bp2_entrance, "breadcrumb" );
		}
		
		else
		{
			set_objective( level.OBJ_BP3_WAVE3, s_bp3_entrance, "remove" );
			
			flag_wait( "bp1wave3_done" );
			
			set_objective( level.OBJ_BP3_WAVE3 );
			set_objective( level.OBJ_BP3_WAVE3, s_bp3_entrance, "breadcrumb" );
		}
		
		//set_objective( level.OBJ_FOLLOW_BP3, level.zhao, "follow" );
	}
	
	else if ( flag( "player_at_bp2wave3" ) )
	{
		set_objective( level.OBJ_BP1_WAVE3, s_bp1_entrance, "remove" );
			
		flag_wait( "bp2wave3_done" );
		
		set_objective( level.OBJ_BP1_WAVE3 );
		set_objective( level.OBJ_BP1_WAVE3, s_bp1_entrance, "breadcrumb" );
	}
	
	else
	{
		set_objective( level.OBJ_BP1_WAVE3, s_bp1_entrance, "remove" );
			
		flag_wait( "bp3wave3_done" );
		
		set_objective( level.OBJ_BP1_WAVE3 );
		set_objective( level.OBJ_BP1_WAVE3, s_bp1_entrance, "breadcrumb" );
	}
}


waittill_bp1wave3_done()
{
	s_bp1_entrance = getstruct( "bp1_obj_marker2", "targetname" );
	
	flag_wait( "player_at_bp1wave3" );
	
	set_objective( level.OBJ_BP1_WAVE3, s_bp1_entrance, "remove" );
	set_objective( level.OBJ_BP1_WAVE3, undefined, "delete" );
	
	flag_wait( "bp1wave3_done" );
	
	level.n_wave3_bp++;
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	if ( level.n_wave3_bp > 1 )
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, undefined, "done" );
	}
	
	else
	{
		level.zhao say_dialog( "zhao_we_must_move_to_defe_0", 2 );  //We must move to defend the final choke point.	
	}
}


waittill_bp2wave3_done()
{
	s_bp2_entrance = getstruct( "bp2_obj_marker", "targetname" );
	
	flag_wait( "player_at_bp2wave3" );
	
	set_objective( level.OBJ_BP2_WAVE3, s_bp2_entrance, "remove" );
	set_objective( level.OBJ_BP2_WAVE3, undefined, "delete" );
	
	flag_wait( "bp2wave3_done" );
		
	level.n_wave3_bp++;
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	if ( level.n_wave3_bp > 1 )
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, undefined, "done" );
	}
	
	else
	{
		level.zhao say_dialog( "zhao_we_must_move_to_defe_0", 1 );  //We must move to defend the final choke point.	
	}
}


waittill_bp3wave3_done()
{
	s_bp3_entrance = getstruct( "bp3_obj_marker", "targetname" );
	
	flag_wait( "player_at_bp3wave3" );
	
	set_objective( level.OBJ_BP3_WAVE3, s_bp3_entrance, "remove" );
	set_objective( level.OBJ_BP3_WAVE3, undefined, "delete" );
	
	flag_wait( "bp3wave3_done" );
	
	level.n_wave3_bp++;
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	if ( level.n_wave3_bp > 1 )
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, undefined, "done" );
	}
	
	else
	{
		level.zhao say_dialog( "zhao_we_must_move_to_defe_0", 1 );  //We must move to defend the final choke point.	
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

zhao_goto_bp1wave3()  //self = level.zhao_horse
{
	s_zhao_bp1 = getstruct( "zhao_bp1wave3_goal", "targetname" );
	
	if ( !IsDefined( self get_driver() ) )
	{
		level.zhao ai_mount_horse( self );
		
		wait 1;
	} 	  	
	
	self SetBrake( false );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_zhao_bp1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	wait 0.5;
	
	level.zhao ai_dismount_horse( self );
	level.zhao set_spawner_targets( "bp1_cache_perimeter" );
	
	flag_wait( "bp1wave3_done" );
	
	level.zhao ai_mount_horse( self );
	
	wait 1;
	
	if ( !flag( "wave3_done" ) )
	{
		if ( level.wave3_loc == "blocking point 2" )
		{
			self thread zhao_goto_bp2wave3();
		}
		else
		{
			self thread zhao_goto_bp3wave3();
		}
	}
}


woods_goto_bp1wave3()  //self = level.woods_horse
{
	s_woods_bp1 = getstruct( "woods_bp1wave3_goal", "targetname" );
	
	if ( !IsDefined( self get_driver() ) )
	{
		level.woods ai_mount_horse( self );
		
		wait 1;
	}
	
	self SetBrake( false );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_woods_bp1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self horse_stop();
	
	wait 0.5;
	
	level.woods ai_dismount_horse( self );
	level.woods set_spawner_targets( "bp1_cache_perimeter" );
	
	flag_wait( "bp1wave3_done" );
	
	level.woods ai_mount_horse( self );
	
	wait 1;
	
	if ( !flag( "wave3_done" ) )
	{
		if ( level.wave3_loc == "blocking point 2" )
		{
			self thread woods_goto_bp2wave3();
		}
		else
		{
			self thread woods_goto_bp3wave3();
		}
	}
}


zhao_goto_bp2wave3()  //self = level.zhao_horse
{
	s_zhao_bp2 = getstruct( "zhao_bp2", "targetname" );
	
	self SetBrake( false );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_zhao_bp2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self thread zhao_at_bp2wave3();
}


woods_goto_bp2wave3()  //self = level.woods_horse
{
	s_woods_bp2 = getstruct( "woods_bp2", "targetname" );
	
	self SetBrake( false );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_woods_bp2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self thread woods_at_bp2wave3();
}


zhao_goto_bp3wave3()  //self = level.zhao_horse
{
	s_zhao_bp2 = getstruct( "zhao_bp3", "targetname" );
	
	self SetBrake( false );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_zhao_bp2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	self thread zhao_at_bp3wave3();
}


woods_goto_bp3wave3()  //self = level.woods_horse
{
	s_woods_bp2 = getstruct( "woods_bp3", "targetname" );
	
	self SetBrake( false );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_woods_bp2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	self thread woods_at_bp3wave3();
}


zhao_at_bp2wave3()  //self = level.zhao_horse
{
	self thread maps\afghanistan_wave_2::zhao_circle_bp2();
	
	flag_wait( "bp2wave3_done" );
	
//	level.zhao run_to_vehicle( self );
//	
//	wait 0.05;
//	
//	self notify( "groupedanimevent", "ride" );
//	
//	level.zhao maps\_horse_rider::ride_and_shoot( self );
	
	if ( !flag( "wave3_done" ) )
	{
		self thread zhao_goto_bp1wave3();
	}
}


woods_at_bp2wave3()  //self = level.woods_horse
{
	self SetSpeedImmediate( 0 );
	
	wait 1;
	
	level.woods notify( "stop_riding" );
	
	self notify( "unload" );
	
	flag_wait( "bp2wave3_done" );
	
	level.woods ai_mount_horse( self );
	
	wait 1;
	
	if ( !flag( "wave3_done" ) )
	{
		self thread woods_goto_bp1wave3();
	}
}


zhao_at_bp3wave3()  //self = level.zhao_horse
{
	flag_set( "zhao_at_bp3" );
	
	flag_wait( "bp3wave3_done" );
	
	level.zhao ai_mount_horse( self );
	
	wait 1;
	
	if ( !flag( "wave3_done" ) )
	{
		self thread zhao_goto_bp1wave3();
	}
}


woods_at_bp3wave3()  //self = level.zhao_horse
{
	flag_set( "woods_at_bp3" );
	
	flag_wait( "bp3wave3_done" );
	
	level.woods ai_mount_horse( self );
	
	wait 1;
	
	if ( !flag( "wave3_done" ) )
	{
		self thread woods_goto_bp1wave3();
	}
}


check_player_location()
{
	flag_wait_any( "bp1wave3_done", "bp2wave3_done", "bp3wave3_done" );
	
	if ( flag( "bp2wave3_done" )  || flag( "bp3wave3_done" ) )
	{
		level.player_wave3_loc = 1;
	}
	
	else if ( flag( "bp1wave3_done" ) )
	{
		if ( level.wave3_loc == "blocking point 2" )
		{
			level.player_wave3_loc = 2;
		}
		
		else
		{
			level.player_wave3_loc = 3;
		}
	}
}