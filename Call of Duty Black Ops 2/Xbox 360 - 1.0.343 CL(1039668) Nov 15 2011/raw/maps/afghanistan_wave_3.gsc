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
}


init_spawn_funcs()
{
	add_spawn_function_group( "bp1wave3_soviet", "targetname", ::bp1wave3_soviet_logic );
}


init_wave3bp1_setup()
{
	level.b_rpg_shift = false;
	level.b_stinger_shift = false;
	
	//level thread spawn_weapon_cache( "rpg" );
	//level thread spawn_weapon_cache( "stinger" );
}


skipto_wave3()
{
	skipto_setup();
	
	init_hero( "zhao" );

	start_teleport( "skipto_wave1", level.heroes );
	
	init_wave3bp1_setup();
	
	init_weapon_cache();
	
	//level thread maps\_unit_command::load();
	
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
	
	level.horse_zhao SetVehicleAvoidance( true );
	
	level.player_horse waittill( "enter_vehicle", player );
	
	level.horse_zhao thread zhao_goto_bp1wave3();
}


main()
{
	level.n_current_wave = 3;
	level.n_bp1wave3_soviets_killed = 0;
	
	init_spawn_funcs();
	
	level thread check_player_location();
	level thread wave3_bp1_main();
	
	if ( level.wave3_loc == "blocking point 2" )
	{
		wave3_bp2_main();
		
		flag_wait( "bp2wave3_done" );
	}
	else
	{
		wave3_bp3_main();
		
		flag_wait( "bp3wave3_done" );
	}
	
	flag_wait( "bp1wave3_done" );
	
	flag_set( "wave3_done" );
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
	
	flag_clear( "soviet_fallback" );
		
	trigger_wait( "spawn_bp1" );
	
	flag_set( "wave3_started" );
	
	flag_set( "player_at_bp1wave3" );
	
	level thread maps\afghanistan_wave_1::bp1_replenish_arena();
		
	autosave_by_name( "wave3_blocking_point1" );
	
	//TODO - cleanup ai
	flag_set( "stop_arena_explosions" );	
	spawn_manager_disable( "manager_troops_exit" );
	spawn_manager_disable( "manager_hip3_troops" );
	spawn_manager_disable( "manager_hip4_troops" );
	guys = getaiarray( "allies", "axis" );
	a_guys = array_exclude( guys, level.zhao );
	foreach( guy in a_guys )
	{
		guy delete();
	}
	
	//TODO - new spawners
	spawn_manager_enable( "manager_soviet_bp1wave3" );
	spawn_manager_enable( "manager_muj_bp1wave3" );
	
	level thread monitor_bp1wave3_defense();
			
	while ( level.n_bp1wave3_veh_destroyed < 4 )
	{
		wait 1;
	}
	
	flag_set( "bp1wave3_done" );
	
	//TODO - new spawners
	spawn_manager_disable( "manager_muj_bp1wave3" );
	spawn_manager_disable( "manager_soviet_bp1wave3" );
}


monitor_bp1wave3_defense()
{
	while( level.n_bp1wave3_soviets_killed < 4 )
	{
		wait 1;	
	}
	
	level thread bp1wave3_vehicle_chooser();
	
	while ( level.n_bp1wave3_veh_destroyed < 1 )
	{
		wait 1;
	}
	
	level thread bp1wave3_boss_chooser();
}


bp1wave3_vehicle_chooser()
{
	level.n_bp1wave3_vehicles = RandomInt( 3 );
			
	if ( level.n_bp1wave3_vehicles == 0 )
	{
		//iprintlnbold( "1 Hip + 1 BTR" );
		level thread spawn_hip1_bp1();
		level thread spawn_btr1_bp1();
	}
	
	else if ( level.n_bp1wave3_vehicles == 1 )
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
}


bp1wave3_boss_chooser()
{
	level.n_bp1wave3_boss = RandomInt( 3 );
		
	if ( level.n_bp1wave3_boss == 0 )
	{
		//iprintlnbold( "1 Tank + 1 Hind" );
		level thread spawn_tank1_bp1();
		wait 2;
		level thread spawn_hind1_bp1();
	}
	
	else if ( level.n_bp1wave3_boss == 1 )
	{
		//iprintlnbold( "2 Tanks" );
		level thread spawn_tank1_bp1();
		wait 2;
		level thread spawn_tank2_bp1();
	}
	
	else
	{
		//iprintlnbold( "2 Hinds" );
		level thread spawn_hind1_bp1();
		wait 2;
		level thread spawn_hind2_bp1();
	}
}


spawn_hip1_bp1()
{
	s_spawnpt = getstruct( "bp1wave3_hip1_spawnpt", "targetname" );
	
	hip1 = spawn_vehicle_from_targetname( "hip1_bp1" );
	hip1.origin = s_spawnpt.origin;
	hip1.angles = s_spawnpt.angles;
	hip1 thread bp1wave3_hip1_behavior();
	hip1 thread bp1wave3_vehicle_destroyed();
	hip1 thread delete_corpse_wave3();
}


spawn_hip2_bp1()
{
	s_spawnpt = getstruct( "bp1wave3_hip2_spawnpt", "targetname" );
	
	hip2 = spawn_vehicle_from_targetname( "hip2_bp1" );
	hip2.origin = s_spawnpt.origin;
	hip2.angles = s_spawnpt.angles;
	hip2 thread bp1wave3_hip2_behavior();
	hip2 thread bp1wave3_vehicle_destroyed();
	hip2 thread delete_corpse_wave3();
}


spawn_btr1_bp1()
{
	s_spawnpt = getstruct( "bp1wave3_btr1_spawnpt", "targetname" );
	
	btr1 = spawn_vehicle_from_targetname( "btr1_bp1" );
	btr1.origin = s_spawnpt.origin;
	btr1.angles = s_spawnpt.angles;
	btr1 thread bp1wave3_btr1_behavior();
	btr1 thread bp1wave3_vehicle_destroyed();
	btr1 thread delete_corpse_wave3();
}


spawn_btr2_bp1()
{
	s_spawnpt = getstruct( "bp1wave3_btr2_spawnpt", "targetname" );
	
	btr2 = spawn_vehicle_from_targetname( "btr2_bp1" );
	btr2.origin = s_spawnpt.origin;
	btr2.angles = s_spawnpt.angles;
	btr2 thread bp1wave3_btr2_behavior();
	btr2 thread bp1wave3_vehicle_destroyed();
	btr2 thread delete_corpse_wave3();
}


spawn_tank1_bp1()
{
	s_spawnpt = getstruct( "bp1_tank1_spawnpt", "targetname" );
		
	tank = spawn_vehicle_from_targetname( "tank_soviet" );
	tank.origin = s_spawnpt.origin;
	tank.angles = s_spawnpt.angles;
	tank thread tank1_behavior();
	tank thread bp1wave3_vehicle_destroyed();
	tank thread delete_corpse_wave3();
}


spawn_tank2_bp1()
{
	s_spawnpt = getstruct( "bp1_tank2_spawnpt", "targetname" );
	
	vh_tank = spawn_vehicle_from_targetname( "tank_soviet" );
	vh_tank.origin = s_spawnpt.origin;
	vh_tank.angles = s_spawnpt.angles;
	vh_tank thread tank2_behavior();
	vh_tank thread bp1wave3_vehicle_destroyed();
	vh_tank thread delete_corpse_wave3();
}


spawn_hind1_bp1()
{
	s_spawnpt = getstruct( "bp1_hind1_spawnpt", "targetname" );
	
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	vh_hind thread hind1_behavior();
	vh_hind thread bp1wave3_vehicle_destroyed();
	vh_hind thread delete_corpse_wave3();
}


spawn_hind2_bp1()
{
	s_spawnpt = getstruct( "bp1_hind2_spawnpt", "targetname" );
	
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	vh_hind thread hind2_behavior();
	vh_hind thread bp1wave3_vehicle_destroyed();
	vh_hind thread delete_corpse_wave3();
}


bp1wave3_btr1_behavior()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	s_goal1 = getstruct( "bp1wave3_btr1_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave3_btr1_goal2", "targetname" );
	s_goal3 = getstruct( "bp1wave3_btr1_goal3", "targetname" );
	s_goal4 = getstruct( "bp1wave3_btr1_goal4", "targetname" );
	s_goal5 = getstruct( "bp1wave3_btr1_goal5", "targetname" );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self enable_turret( 1 );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 20, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < 1100 ) )
	{
		self SetBrake( true );
		while( Distance2D( self.origin, level.player.origin ) < 1100 )
		{
			wait 1;	
		}
		wait 2;
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < 1200 ) )
	{
		self SetBrake( true );
		while( Distance2D( self.origin, level.player.origin ) < 1200 )
		{
			wait 1;	
		}
		wait 2;
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < 2000 ) )
	{
		self SetBrake( true );
		while( Distance2D( self.origin, level.player.origin ) < 2000 )
		{
			wait 1;	
		}
		wait 2;
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < 2000 ) )
	{
		self SetBrake( true );
		while( Distance2D( self.origin, level.player.origin ) < 2000 )
		{
			wait 1;	
		}
		wait 2;
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal5.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


bp1wave3_btr2_behavior()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	s_goal1 = getstruct( "bp1wave3_btr2_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave3_btr2_goal2", "targetname" );
	s_goal3 = getstruct( "bp1wave3_btr2_goal3", "targetname" );
	s_goal4 = getstruct( "bp1wave3_btr2_goal4", "targetname" );
		
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self enable_turret( 1 );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 20, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < 1600 ) )
	{
		self SetBrake( true );
		while( Distance2D( self.origin, level.player.origin ) < 1600 )
		{
			wait 1;	
		}
		wait 2;
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < 1600 ) )
	{
		self SetBrake( true );
		while( Distance2D( self.origin, level.player.origin ) < 1600 )
		{
			wait 1;	
		}
		wait 2;
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < 2000 ) )
	{
		self SetBrake( true );
		while( Distance2D( self.origin, level.player.origin ) < 2000 )
		{
			wait 1;	
		}
		wait 2;
		self SetBrake( false );
	}
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


bp1wave3_hip1_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave3_hip1_spawnpt", "targetname" );
	
	for( i = 1; i < 10; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave3_hip1_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 25, 20 );
	
	i = 1;
	
	while( i < 8 )
	{
		if ( i == 6 || i == 7 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 6 )
		{
			self SetSpeedImmediate( 0, 25, 20 );
	
			wait 3;
	
			self bp1wave3_hip1_rappel();
			
			wait 3;
			
			self setspeed( 50, 25, 20 );
		}
		
		i++;
	}
	
	e_facept = GetEnt( "bp1wave3_hip_face", "targetname" );
	
	self setLookAtEnt( e_facept );
	
	wait 2;
	
	self enable_turret( 2 );
	
	wait RandomIntRange( 5, 8 );
	
	self setspeed( 50, 25, 20 );
	
	self ClearLookAtEnt();
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ 8 ].origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self setvehgoalpos( a_s_goal[ 9 ].origin, 1 );
		self waittill_any( "goal", "near_goal" );
	}
}


bp1wave3_hip1_rappel()
{	
	sp_hip1_rappell1 = GetEnt( "bp1wave3_hip1_rappel1", "targetname" );
	sp_hip1_rappell2 = GetEnt( "bp1wave3_hip1_rappel2", "targetname" );
	sp_hip1_rappell3 = GetEnt( "bp1wave3_hip1_rappel3", "targetname" );
	sp_hip1_rappell4 = GetEnt( "bp1wave3_hip1_rappel4", "targetname" );
	
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


bp1wave3_hip2_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave3_hip2_spawnpt", "targetname" );
	
	for( i = 1; i < 10; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave3_hip2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 50, 25 );
	
	i = 1;
	
	while( i < 8 )
	{
		if ( i == 6 || i == 7 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 6 )
		{
			self SetSpeedImmediate( 0, 25, 20 );
	
			wait 3;
	
			self bp1wave3_hip2_rappel();
			
			wait 3;
			
			self setspeed( 50, 25, 20 );
		}
		
		i++;
	}
	
	e_facept = GetEnt( "bp1wave3_hip_face", "targetname" );
	
	self setLookAtEnt( e_facept );
	
	wait 2;
	
	self enable_turret( 2 );
	
	wait RandomIntRange( 5, 8 );
	
	self setspeed( 50, 25, 20 );
	
	self ClearLookAtEnt();
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ 8 ].origin, 1 );
		self waittill_any( "goal", "near_goal" );
		self setvehgoalpos( a_s_goal[ 9 ].origin, 1 );
		self waittill_any( "goal", "near_goal" );
	}
}


bp1wave3_hip2_rappel()
{	
	sp_hip2_rappell1 = GetEnt( "bp1wave3_hip2_rappel1", "targetname" );
	sp_hip2_rappell2 = GetEnt( "bp1wave3_hip2_rappel2", "targetname" );
	sp_hip2_rappell3 = GetEnt( "bp1wave3_hip2_rappel3", "targetname" );
	sp_hip2_rappell4 = GetEnt( "bp1wave3_hip2_rappel4", "targetname" );
	
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


hind1_behavior()  //self = hind
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
			
	s_goal1 = getstruct( "bp1_hind1_goal1", "targetname" );
	s_goal2 = getstruct( "bp1_hind1_goal2", "targetname" );
	s_goal3 = getstruct( "bp1_hind1_goal3", "targetname" );
	s_goal4 = getstruct( "bp1_hind1_goal4", "targetname" );
	s_goal5 = getstruct( "bp1_hind1_goal5", "targetname" );
	s_goal6 = getstruct( "bp1_hind1_goal6", "targetname" );
	s_goal7 = getstruct( "bp1_hind1_goal7", "targetname" );
	s_goal8 = getstruct( "bp1_hind1_goal8", "targetname" );
	s_goal9 = getstruct( "bp1_hind1_goal9", "targetname" );
	s_goal10 = getstruct( "bp1_hind1_goal10", "targetname" );
	s_goal11 = getstruct( "bp1_hind1_goal11", "targetname" );
	s_goal12 = getstruct( "bp1_hind1_goal12", "targetname" );
	s_goal13 = getstruct( "bp1_hind1_goal13", "targetname" );
	s_goal14 = getstruct( "bp1_hind1_goal14", "targetname" );
	s_goal15 = getstruct( "bp1_hind1_goal15", "targetname" );
	s_goal16 = getstruct( "bp1_hind1_goal16", "targetname" );
	s_goal17 = getstruct( "bp1_hind1_goal17", "targetname" );
	s_goal18 = getstruct( "bp1_hind1_goal18", "targetname" );
	s_goal19 = getstruct( "bp1_hind1_goal19", "targetname" );
	s_goal20 = getstruct( "bp1_hind1_goal20", "targetname" );
	
	self setspeed( 100, 45, 35 );
	
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setspeed( 50, 25, 15 );
	self setvehgoalpos( s_goal5.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
	self hind_attack_think( 4000 );
	
	self ClearLookAtEnt();
	self setvehgoalpos( s_goal6.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal7.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal8.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal9.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal10.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal11.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
	self hind_attack_think( 4000 );
	
	self ClearLookAtEnt();
	self setvehgoalpos( s_goal12.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal13.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal14.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
	self hind_attack_think( 4000 );
	
	self ClearLookAtEnt();
	self setvehgoalpos( s_goal15.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal16.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal17.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal18.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal19.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A HELICOPTER APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal20.origin, 1 );
	self waittill_any( "goal", "near_goal" );

	wait 4;
	
	self hind_baseattack();
}


hind2_behavior()  //self = hind
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	s_goal1 = getstruct( "bp1_hind2_goal1", "targetname" );
	s_goal2 = getstruct( "bp1_hind2_goal2", "targetname" );
	s_goal3 = getstruct( "bp1_hind2_goal3", "targetname" );
	s_goal4 = getstruct( "bp1_hind2_goal4", "targetname" );
	s_goal5 = getstruct( "bp1_hind2_goal5", "targetname" );
	s_goal6 = getstruct( "bp1_hind2_goal6", "targetname" );
	s_goal7 = getstruct( "bp1_hind2_goal7", "targetname" );
	s_goal8 = getstruct( "bp1_hind2_goal8", "targetname" );
	s_goal9 = getstruct( "bp1_hind2_goal9", "targetname" );
	s_goal10 = getstruct( "bp1_hind2_goal10", "targetname" );
	s_goal11 = getstruct( "bp1_hind2_goal11", "targetname" );
			
	self setspeed( 100, 45, 35 );
		
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setspeed( 50, 25, 15 );
	self setvehgoalpos( s_goal3.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
	self hind_attack_think( 4000 );
	
	self ClearLookAtEnt();
	self setvehgoalpos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal5.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
	self hind_attack_think( 4000 );
	
	self ClearLookAtEnt();
	self setvehgoalpos( s_goal6.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal7.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
	self hind_attack_think( 4000 );
	
	self ClearLookAtEnt();
	self setvehgoalpos( s_goal8.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal9.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal10.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A HELICOPTER APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal11.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	wait 4;
	
	self hind_baseattack();
}


tank1_behavior()
{
	self endon( "death" );
	
	s_goal01 = getstruct( "bp1_tank1_goal01", "targetname" );
	s_goal02 = getstruct( "bp1_tank1_goal02", "targetname" );
	s_goal03 = getstruct( "bp1_tank1_goal03", "targetname" );
	s_goal04 = getstruct( "bp1_tank1_goal04", "targetname" );
	s_goal05 = getstruct( "bp1_tank1_goal05", "targetname" );
	s_goal06 = getstruct( "bp1_tank1_goal06", "targetname" );
	s_goal07 = getstruct( "bp1_tank1_goal07", "targetname" );
	s_goal08 = getstruct( "bp1_tank1_goal08", "targetname" );
	s_goal09 = getstruct( "bp1_tank1_goal09", "targetname" );
	s_goal10 = getstruct( "bp1_tank1_goal10", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self enable_turret( 1 );
	
	self setspeed( 20, 15, 10 );
	self setvehgoalpos( s_goal01.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal02.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self thread tank_targetting();
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal03.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal04.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal05.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal06.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal07.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal08.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal09.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal10.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


tank2_behavior()
{
	self endon( "death" );
	
	s_goal01 = getstruct( "bp1_tank2_goal01", "targetname" );
	s_goal02 = getstruct( "bp1_tank2_goal02", "targetname" );
	s_goal03 = getstruct( "bp1_tank2_goal03", "targetname" );
	s_goal04 = getstruct( "bp1_tank2_goal04", "targetname" );
	s_goal05 = getstruct( "bp1_tank2_goal05", "targetname" );
	s_goal06 = getstruct( "bp1_tank2_goal06", "targetname" );
	s_goal07 = getstruct( "bp1_tank2_goal07", "targetname" );
	s_goal08 = getstruct( "bp1_tank2_goal08", "targetname" );
	s_goal09 = getstruct( "bp1_tank2_goal09", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 20, 15, 10 );
	self setvehgoalpos( s_goal01.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self thread tank_targetting();
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal02.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal03.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal04.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
		
	self setvehgoalpos( s_goal05.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal06.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal07.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal08.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal08.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


bp1wave3_soviet_logic()
{
	self endon( "death" );
	
	self thread bp1wave3_soviet_counter();
	
	self set_spawner_targets( "bp1wave3_soviet_front" );
	
	flag_wait( "soviet_fallback" );
	
	self set_spawner_targets( "bp1wave3_soviet_back" );
}


bp1wave3_soviet_counter()
{
	self waittill( "death" );
	
	level.n_bp1wave3_soviets_killed++;
}


bp1wave3_vehicle_destroyed()
{
	self waittill( "death" );
	
	level.n_bp1wave3_veh_destroyed++;
	
	autosave_by_name( "bp1wave3_vehicle_destroyed" );
}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 3: BLOCKING POINT 2 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
wave3_bp2_main()
{
	level thread objectives_wave3();
	
	maps\afghanistan_wave_2::wave2_bp2_main();
}


spawn_hind_bp2wave3()
{
	s_spawnpt = getstruct( "bp2wave3_hind_spawnpt", "targetname" );
		
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	vh_hind thread bp2wave3_hind_behavior();
	vh_hind thread delete_corpse_wave3();
}


bp2wave3_hind_behavior()
{
	self endon( "death" );
	
	self thread maps\afghanistan_wave_2::bp2_vehicle_destroyed();
	
	self SetNearGoalNotifyDist( 200 );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave3_hind_spawnpt", "targetname" );
	
	for ( i = 1; i < 10; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave3_hind_goal"+i, "targetname" );
	}
			
	self setspeed( 100, 45, 35 );
	
	i = 1;
	
	while( i < 10 )
	{
		self setvehgoalpos( a_s_goal[i].origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		i++;
	}
	
	self thread bp2wave3_hind_attack();
}


bp2wave3_hind_attack()
{
	self endon( "death" );
	
	a_s_attackpt = [];
	a_s_attackpt[ 0 ] = getstruct( "bp2wave3_hind_spawnpt", "targetname" );
	
	for ( i = 1; i < 7; i++ )
	{
		a_s_attackpt[ i ] = getstruct( "bp2wave3_hind_attackpt"+i, "targetname" );
	}
	
	self setvehgoalpos( a_s_attackpt[ 1 ].origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	while( 1 )
	{
		self setvehgoalpos( a_s_attackpt[ RandomIntRange( 4, 7 ) ].origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_approach_attack();
		
		self setvehgoalpos( a_s_attackpt[ RandomIntRange( 1, 4 ) ].origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_approach_attack();
	}
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


spawn_tank_bp2wave3()
{
	s_spawnpt = getstruct( "bp2wave3_tank_spawnpt", "targetname" );
		
	vh_tank = spawn_vehicle_from_targetname( "tank_soviet" );
	vh_tank.origin = s_spawnpt.origin;
	vh_tank.angles = s_spawnpt.angles;
	vh_tank thread bp2wave3_tank_behavior();
	vh_tank thread delete_corpse_wave3();
}


bp2wave3_tank_behavior()
{
	self endon( "death" );
	
	self thread maps\afghanistan_wave_2::bp2_vehicle_destroyed();
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	s_goal1 = getstruct( "bp2wave3_tank_goal1", "targetname" );
	s_goal2 = getstruct( "bp2wave3_tank_goal2", "targetname" );
	s_goal3 = getstruct( "bp2wave3_tank_goal3", "targetname" );
	s_goal4 = getstruct( "bp2wave3_tank_goal4", "targetname" );
	s_goal5 = getstruct( "bp2wave3_tank_goal5", "targetname" );
	
	self setspeed( 20, 10, 5 );
	
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal5.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 3: BLOCKING POINT 3 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
wave3_bp3_main()
{
	level thread objectives_wave3();
	
	maps\afghanistan_wave_2::wave2_bp3_main();
}


spawn_hind_bp3wave3()
{
	s_spawnpt = getstruct( "bp3wave3_hind_spawnpt", "targetname" );
		
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	vh_hind thread bp3wave3_hind_behavior();
	vh_hind thread delete_corpse_wave3();
}


bp3wave3_hind_behavior()
{
	self endon( "death" );
	
	self thread maps\afghanistan_wave_2::bp3_vehicle_destroyed();
	
	self SetNearGoalNotifyDist( 200 );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave3_hind_spawnpt", "targetname" );
	
	for ( i = 1; i < 11; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave3_hind_goal"+i, "targetname" );
	}
			
	self setspeed( 100, 45, 35 );
	
	for ( i = 1; i < 4; i++ )
	{
		if ( i == 3 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
			self waittill_any( "goal", "near_goal" );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
			self waittill_any( "goal", "near_goal" );
		}
	}
	
	wait 2;
	
	self hind_fire_while_hover( 5 );
	
	i = 4;
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 4 )
		{
			wait 2;
		
			self hind_fire_while_hover( 5 );
		}
		
		if ( i == 8 )
		{
			wait 2;
		
			self hind_fire_while_hover( 5 );
		}
		
		i++;
		
		if ( i > 10 )
		{
			i = 4;
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


spawn_tank_bp3wave3()
{
	s_spawnpt = getstruct( "bp3wave3_tank_spawnpt", "targetname" );
		
	vh_tank = spawn_vehicle_from_targetname( "tank_soviet" );
	vh_tank.origin = s_spawnpt.origin;
	vh_tank.angles = s_spawnpt.angles;
	vh_tank thread bp3wave3_tank_behavior();
	vh_tank thread delete_corpse_wave3();
}


bp3wave3_tank_behavior()
{
	self endon( "death" );
	
	self thread maps\afghanistan_wave_2::bp3_vehicle_destroyed();
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave3_tank_spawnpt", "targetname" );
	
	for ( i = 1; i < 11; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave3_tank_goal"+i, "targetname" );
	}
	
	self setspeed( 20, 10, 5 );
	
	i = 1;
	
	while( i < 9 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 0, true );
		self waittill_any( "goal", "near_goal" );
		
		i++;
		
		if ( i == 7 )
		{
			iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
		}
	}
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
objectives_wave3()
{
	s_bp1_entrance = getstruct( "bp1_entrance", "targetname" );
	s_bp2_entrance = getstruct( "bp2_entrance", "targetname" );
	s_bp3_entrance = getstruct( "bp3_entrance", "targetname" );
	
	flag_wait_any( "bp2_exit", "bp3_exit" );
	
	set_objective( level.OBJ_FOLLOW, level.zhao, "remove" );
	
	level.n_wave3_bp = 0;
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	set_objective( level.OBJ_AFGHAN_WAVE3, s_bp1_entrance, "breadcrumb", -1 );
	
	if ( level.wave3_loc == "blocking point 2" )
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, s_bp2_entrance, "breadcrumb", -1 );
		
		level thread waittill_bp2wave_done();
	}
	
	else
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, s_bp3_entrance, "breadcrumb", -1 );
		
		level thread waittill_bp3wave_done();
	}
	
	flag_wait( "bp1wave3_done" );
	
	level.n_wave3_bp++;
	
	set_objective( level.OBJ_AFGHAN_WAVE3, s_bp1_entrance, "remove" );
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	if ( level.n_wave3_bp > 1 )
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, undefined, "done" );
	}
}


waittill_bp2wave_done()
{
	flag_wait( "bp2wave3_done" );
	
	level.n_wave3_bp++;
	
	s_bp2_entrance = getstruct( "bp2_entrance", "targetname" );
	
	set_objective( level.OBJ_AFGHAN_WAVE3, s_bp2_entrance, "remove" );
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	if ( level.n_wave3_bp > 1 )
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, undefined, "done" );
	}
}


waittill_bp3wave_done()
{
	flag_wait( "bp3wave3_done" );
	
	level.n_wave3_bp++;
	
	s_bp3_entrance = getstruct( "bp3_entrance", "targetname" );
	
	set_objective( level.OBJ_AFGHAN_WAVE3, s_bp3_entrance, "remove" );
	
	set_objective( level.OBJ_AFGHAN_WAVE3, undefined, undefined, level.n_wave3_bp );
	
	if ( level.n_wave3_bp > 1 )
	{
		set_objective( level.OBJ_AFGHAN_WAVE3, undefined, "done" );
	}
}


zhao_goto_wave3()  //self = level.horse_zhao
{
	iprintlnbold( "Lead the way and get to a blocking point!" );
	
	self SetBrake( false );
	
	//self thread zhao_follow_player();
	
	flag_wait_any( "player_at_bp1wave3", "player_at_bp2wave3", "player_at_bp3wave3" );
		
	s_zhao_bp1 = getstruct( "zhao_bp1", "targetname" );
	s_zhao_bp2 = getstruct( "zhao_bp2", "targetname" );
	s_zhao_bp3 = getstruct( "zhao_bp3", "targetname" );
	
	self setspeed( 30, 15, 10 );
	
	if ( flag( "player_at_bp1wave3" ) )
	{
		//self setvehgoalpos( s_zhao_bp1.origin, 1, true );
		self thread zhao_goto_bp1wave3();
	}
	
	else if ( flag( "player_at_bp2wave3" ) )
	{
		//self setvehgoalpos( s_zhao_bp2.origin, 1, true );
		self thread zhao_goto_bp2wave3();
	}
	
	else if ( flag( "player_at_bp3wave3" ) )
	{
		//self setvehgoalpos( s_zhao_bp3.origin, 1, true );
		self thread zhao_goto_bp3wave3();
	}
	
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	if ( flag( "player_at_bp1wave3" ) )
	{
		flag_set( "zhao_wave3_bp1" );
	}
	
	else if ( flag( "player_at_bp2wave3" ) )
	{
		flag_set( "zhao_wave3_bp2" );
	}
	
	else if ( flag( "player_at_bp3wave3" ) )
	{
		flag_set( "zhao_wave3_bp3" );
	}
}


zhao_goto_bp1wave3()  //self = level.horse_zhao
{
	s_zhao_bp1 = getstruct( "zhao_bp1", "targetname" );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_zhao_bp1.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self thread zhao_at_bp1wave3();
}


zhao_goto_bp2wave3()  //self = level.horse_zhao
{
	s_zhao_bp2 = getstruct( "zhao_bp2", "targetname" );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_zhao_bp2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self thread zhao_at_bp2wave3();
}


zhao_goto_bp3wave3()  //self = level.horse_zhao
{
	s_zhao_bp2 = getstruct( "zhao_bp2", "targetname" );
	
	self setspeed( 25, 15, 10 );
	self setvehgoalpos( s_zhao_bp2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self thread zhao_at_bp3wave3();
}


zhao_at_bp1wave3()  //self = level.horse_zhao
{
	self SetBrake( true );
	
	self notify( "unload" );
	
	level.zhao notify( "stop_riding" );
	
	//TODO
	//level.zhao set_spawner_targets( "bp1_entrance" );
	
	flag_wait( "bp1wave3_done" );
	
	level.zhao run_to_vehicle( self );
	
	wait 0.05;
	
	self notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( self );
	
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


zhao_at_bp2wave3()  //self = level.horse_zhao
{
	self thread maps\afghanistan_wave_2::zhao_circle_bp2();
	
	flag_wait( "bp2wave3_done" );
	
	level.zhao run_to_vehicle( self );
	
	wait 0.05;
	
	self notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( self );
	
	if ( !flag( "wave3_done" ) )
	{
		self thread zhao_goto_bp1wave3();
	}
}


zhao_at_bp3wave3()  //self = level.horse_zhao
{
	self SetBrake( true );
	
	self notify( "unload" );
	
	level.zhao notify( "stop_riding" );
	
	//TODO
	//level.zhao set_spawner_targets( "bp1_entrance" );
	
	flag_wait( "bp1wave3_done" );
	
	level.zhao run_to_vehicle( self );
	
	wait 0.05;
	
	self notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( self );
	
	if ( !flag( "wave3_done" ) )
	{
		self thread zhao_goto_bp1wave3();
	}
}


zhao_follow_player()  //self = level.horse_zhao
{
	self setspeed( 25, 15, 10 );
	
	while( 1 )
	{
		self setvehgoalpos( level.player.origin, 0, true );
		self waittill_any( "goal", "near_goal" );
		iprintlnbold( "goal" );
		
		if ( flag( "player_at_bp1wave3" ) )
		{
			iprintlnbold( "player at bp1" );
			self thread zhao_at_bp1wave3();
			break;
		}
		
		else if ( flag( "player_at_bp2wave3" ) )
		{
			iprintlnbold( "player at bp2" );
			self thread zhao_at_bp2wave3();
			break;
		}
		
		else if ( flag( "player_at_bp3wave3" ) )
		{
			iprintlnbold( "player at bp3" );
			self thread zhao_at_bp3wave3();
			break;
		}
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