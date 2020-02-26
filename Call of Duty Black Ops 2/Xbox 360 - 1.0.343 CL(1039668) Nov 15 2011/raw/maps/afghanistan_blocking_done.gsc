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
	flag_init( "bp1wave4_start" );
	flag_init( "bp2wave4_start" );
	flag_init( "bp3wave4_start" );
	flag_init( "wave4_started" );
	flag_init( "blocking_done" );
}


init_spawn_funcs()
{
	//Blocking Point 1
	add_spawn_function_group( "bp1wave4_uaz1_rider", "targetname", ::bp1wave4_uaz1_rider_logic );
	add_spawn_function_group( "bp1wave4_uaz2_rider", "targetname", ::bp1wave4_uaz2_rider_logic );
	
	add_spawn_function_veh( "bp1wave4_uaz1", ::bp1wave4_uaz1_behavior );
	add_spawn_function_veh( "bp1wave4_uaz2", ::bp1wave4_uaz2_behavior );
	
	//Blocking Point 2
	add_spawn_function_veh( "bp2wave4_uaz1", ::bp2wave4_uaz1_behavior );
	add_spawn_function_veh( "bp2wave4_uaz2", ::bp2wave4_uaz2_behavior );
	
	add_spawn_function_group( "bp2wave4_uaz1_rider", "targetname", ::bp2wave4_uaz1_rider_logic );
	add_spawn_function_group( "bp2wave4_uaz2_rider", "targetname", ::bp2wave4_uaz2_rider_logic );
	
	//Blocking Point 3
	add_spawn_function_veh( "bp3wave4_uaz1", ::bp3wave4_uaz1_behavior );
	add_spawn_function_veh( "bp3wave4_uaz2", ::bp3wave4_uaz2_behavior );
	
	add_spawn_function_group( "bp3wave4_uaz1_rider", "targetname", ::bp3wave4_uaz1_rider_logic );
	add_spawn_function_group( "bp3wave4_uaz2_rider", "targetname", ::bp3wave4_uaz2_rider_logic );
}


skipto_blockingdone()
{
	skipto_setup();
	
	init_hero( "zhao" );

	start_teleport( "skipto_blockingdone", level.heroes );
	
	init_weapon_cache();
	
	//level thread maps\_unit_command::load();
	
	level.zhao = getent( "zhao_ai", "targetname" );
	
	s_horse_zhao = getstruct( "last_zhao_horse", "targetname" );
	s_horse_player = getstruct( "last_player_horse", "targetname" );
	
	level.horse_zhao = spawn_vehicle_from_targetname( "wave4_zhao_horse" );
	level.horse_zhao.origin = s_horse_zhao.origin;
	level.horse_zhao.angles = s_horse_zhao.angles;
	
	level.player_horse = spawn_vehicle_from_targetname( "wave4_player_horse" );
	level.player_horse.origin = s_horse_player.origin;
	level.player_horse.angles = s_horse_player.angles;
	
	wait 0.1;
		
	level.player_horse MakeVehicleUsable();
		
	wait 0.1;
	
	level.zhao enter_vehicle( level.horse_zhao );
	
	wait 0.05;
	
	level.horse_zhao notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.horse_zhao );
	
	level.horse_zhao SetVehicleAvoidance( true );
	
	level.horse_zhao SetCanDamage( false );
	level.zhao SetCanDamage( false );
	
	level.horse_zhao thread goto_base();
	
	level.player_wave3_loc = 1;  //bp the player is located when wave3 is complete
	
	//trigger_wait( "return_base_trigger" );
	
	//flag_set( "blocking_done" );	
}


goto_base()
{
	s_return_base = getstruct( "zhao_charge", "targetname" );
	self SetNearGoalNotifyDist( 200 );
	self SetVehGoalPos( s_return_base.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	self SetBrake( true );
	self notify( "unload" );
}


main()
{
	init_spawn_funcs();
	init_wave4();
	
	level thread objectives_wave4();
	level.player thread horse_to_player();
	
	if ( level.player_wave3_loc == 1 )
	{
		level thread bp2wave4_start_event();
		level thread bp3wave4_start_event();
		
		flag_wait_any( "bp2wave4_start", "bp3wave4_start" );
		
		flag_set( "wave4_started" );
	
		level thread bp1wave4_start_event();
		
		while( !level.n_wave4_bp )
		{
			wait 1;	
		}
		
		wait 8;
		
		if ( flag( "bp2wave4_start" ) )
		{
			flag_set( "bp3wave4_start" );
		}
		else
		{
			flag_set( "bp2wave4_start" );
		}
	}
	
	else if ( level.player_wave3_loc == 2 )
	{
		level thread bp1wave4_start_event();
		level thread bp3wave4_start_event();
		
		flag_wait_any( "bp1wave4_start", "bp3wave4_start" );
		
		flag_set( "wave4_started" );
	
		level thread bp2wave4_start_event();
		
		while( !level.n_wave4_bp )
		{
			wait 1;	
		}
		
		wait 8;
		
		if ( flag( "bp1wave4_start" ) )
		{
			flag_set( "bp3wave4_start" );
		}
		else
		{
			flag_set( "bp1wave4_start" );
		}
	}
	
	else
	{
		level thread bp1wave4_start_event();
		level thread bp2wave4_start_event();
		
		flag_wait_any( "bp1wave4_start", "bp2wave4_start" );
	
		level thread bp3wave4_start_event();
		
		while( !level.n_wave4_bp )
		{
			wait 1;	
		}
		
		wait 8;
		
		if ( flag( "bp1wave4_start" ) )
		{
			flag_set( "bp2wave4_start" );
		}
		else
		{
			flag_set( "bp1wave4_start" );
		}
	}
		
	flag_wait( "blocking_done" );
}


init_wave4()
{
	level.n_bp1wave4_veh_destroyed = 0;
	level.n_bp2wave4_veh_destroyed = 0;
	level.n_bp3wave4_veh_destroyed = 0;
}


objectives_wave4()
{
	level.n_wave4_bp = 0;
	
	set_objective( level.OBJ_DEFEND_ALL, undefined, undefined, level.n_wave4_bp );
}


update_wave4_objective()
{
	self waittill("death");
	
	level.n_wave4_bp++;
	
	if ( IsDefined( self.target_pos ) )
	{
		set_objective( level.OBJ_DEFEND_ALL, self.target_pos, "remove" );
		self.target_pos Delete();
	}
	
	else
	{
		set_objective( level.OBJ_DEFEND_ALL, self, "remove" );	
	}
	
	if ( level.n_wave4_bp == 3 )
	{
		autosave_by_name( "arena_half_done" );	
	}
	
	wait 1;
	
	set_objective( level.OBJ_DEFEND_ALL, undefined, undefined, level.n_wave4_bp );
	
	if ( level.n_wave4_bp > 5 )
	{
		level thread back_to_base();
	}
}


back_to_base()
{
	set_objective( level.OBJ_DEFEND_ALL, undefined, "done" );
	
	s_return_base = getstruct( "return_base_pos", "targetname" );
	
	set_objective( level.OBJ_RETURN_BASE, s_return_base.origin, "breadcrumb" );
	
	trigger_wait( "return_base_trigger" );
	
	cleanup_arena();
	
	flag_set( "blocking_done" );
	
	set_objective( level.OBJ_RETURN_BASE, undefined, "done" );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 4: BLOCKING POINT 1 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
bp1wave4_start_event()
{
	level thread bp1wave4_start_vehicles();
	level thread bp1wave4_start_trigger();
}


bp1wave4_start_trigger()
{
	level endon( "bp1wave4_start" );
	level endon( "bp2wave4_start" );
	level endon( "bp3wave4_start" );
	
	trigger_wait( "spawn_bp1" );
	
	trigger_use( "bp1wave4_uaz1_trigger" );
	trigger_use( "bp1wave4_uaz2_trigger" );
	
	flag_set( "bp1wave4_start" );
}


bp1wave4_start_vehicles()
{
	flag_wait_or_timeout( "bp1wave4_start", 120 );
	
	//iprintlnbold( "start blocking point 1" );
	
	level thread bp1wave4_vehicle_chooser();
}


bp1wave4_vehicle_chooser()
{
	level.n_bp1wave4_vehicles = RandomInt( 3 );
	
	s_btr1_spawnpt = getstruct( "bp1wave4_btr1_spawnpt", "targetname" );
	s_btr2_spawnpt = getstruct( "bp1wave4_btr2_spawnpt", "targetname" );
	s_hip1_spawnpt = getstruct( "bp1wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp1wave4_hip2_spawnpt", "targetname" );
		
	if ( level.n_bp1wave4_vehicles == 0 )
	{
		//iprintlnbold( "1 Hip + 1 BTR" );
		vh_hip = spawn_vehicle_from_targetname( "hip1_bp1" );
		vh_hip.origin = s_hip1_spawnpt.origin;
		vh_hip.angles = s_hip1_spawnpt.angles;
		vh_hip thread bp1wave4_hip1_behavior();
		
		wait 3;
		
		vh_btr = spawn_vehicle_from_targetname( "btr1_bp1" );
		vh_btr.origin = s_btr1_spawnpt.origin;
		vh_btr.angles = s_btr1_spawnpt.angles;
		vh_btr thread bp1wave4_btr1_behavior();
	}
	
	else if ( level.n_bp1wave4_vehicles == 1 )
	{
		//iprintlnbold( "2 Hips" );
		vh_hip1 = spawn_vehicle_from_targetname( "hip1_bp1" );
		vh_hip1.origin = s_hip1_spawnpt.origin;
		vh_hip1.angles = s_hip1_spawnpt.angles;
		vh_hip1 thread bp1wave4_hip1_behavior();
		
		wait 2;
		
		vh_hip2 = spawn_vehicle_from_targetname( "hip2_bp1" );
		vh_hip2.origin = s_hip2_spawnpt.origin;
		vh_hip2.angles = s_hip2_spawnpt.angles;
		vh_hip2 thread bp1wave4_hip2_behavior();
	}
	
	else
	{
		//iprintlnbold( "2 BTRs" );
		vh_btr1 = spawn_vehicle_from_targetname( "btr1_bp1" );
		vh_btr1.origin = s_btr1_spawnpt.origin;
		vh_btr1.angles = s_btr1_spawnpt.angles;
		vh_btr1 thread bp1wave4_btr1_behavior();
		
		wait 2;
		
		vh_btr2 = spawn_vehicle_from_targetname( "btr2_bp1" );
		vh_btr2.origin = s_btr2_spawnpt.origin;
		vh_btr2.angles = s_btr2_spawnpt.angles;
		vh_btr2 thread bp1wave4_btr2_behavior();
	}
	
	////////////////////////////////////////////////
	wait 5;
	
	level.n_bp1wave4_boss = RandomInt( 3 );
	
	s_tank1_spawnpt = getstruct( "bp1wave4_tank1_spawnpt", "targetname" );
	s_tank2_spawnpt = getstruct( "bp1wave4_tank2_spawnpt", "targetname" );
	s_hind1_spawnpt = getstruct( "bp1wave4_hind1_spawnpt", "targetname" );
	s_hind2_spawnpt = getstruct( "bp1wave4_hind2_spawnpt", "targetname" );
	
	if ( level.n_bp1wave4_boss == 0 )
	{
		//iprintlnbold( "1 Tank + 1 Hind" );
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_tank1_spawnpt.origin;
		vh_tank1.angles = s_tank1_spawnpt.angles;
		vh_tank1 thread bp1wave4_tank1_behavior();
		vh_tank1 thread bp1wave4_vehicle_destroyed();
		
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp1wave4_hind1_behavior();
		vh_hind1 thread bp1wave4_vehicle_destroyed();
	}
	
	else if ( level.n_bp1wave4_boss == 1 )
	{
		//iprintlnbold( "2 Hinds" );
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp1wave4_hind1_behavior();
		vh_hind1 thread bp1wave4_vehicle_destroyed();
		
		wait 2;
		
		vh_hind2 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind2.origin = s_hind2_spawnpt.origin;
		vh_hind2.angles = s_hind2_spawnpt.angles;
		vh_hind2 thread bp1wave4_hind2_behavior();
		vh_hind2 thread bp1wave4_vehicle_destroyed();
	}
	
	else
	{
		//iprintlnbold( "2 Tanks" );
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_tank1_spawnpt.origin;
		vh_tank1.angles = s_tank1_spawnpt.angles;
		vh_tank1 thread bp1wave4_tank1_behavior();
		vh_tank1 thread bp1wave4_vehicle_destroyed();
		
		vh_tank2 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank2.origin = s_tank2_spawnpt.origin;
		vh_tank2.angles = s_tank2_spawnpt.angles;
		vh_tank2 thread bp1wave4_tank2_behavior();
		vh_tank2 thread bp1wave4_vehicle_destroyed();
	}
}


bp1wave4_uaz1_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp1wave4_uaz1_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave4_uaz1_goal2", "targetname" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 30, 20, 15 );
	
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


bp1wave4_uaz2_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp1wave4_uaz2_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave4_uaz2_goal2", "targetname" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 30, 20, 15 );
	
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


bp1wave4_hip1_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hip1_spawnpt", "targetname" );
	
	for( i = 1; i < 12; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hip1_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	Target_Set( self, ( -50, 0, -32 ) );
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 50, 25 );
	
	self.b_rappel_done = false;
	
	i = 1;
	
	while( i < 12 )
	{
		if ( i == 8 || i == 11 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 7 )
		{
			self setspeed( 50, 25, 20 );
		}
		
		if ( i == 8 )
		{
			if ( ( Distance2D( self.origin, level.player.origin ) < 1000 ) )	
			{
				self SetSpeedImmediate( 0, 25, 20 );
				wait 3;
				self thread bp1wave4_hip1_rappel();
				wait 3;
				self setspeed( 50, 25, 20 );
				
				self.b_rappel_done = true;
			}
		}
		
		i++;
	}
	
	if ( !self.b_rappel_done )
	{
		self SetSpeedImmediate( 0, 25, 20 );
		wait 3;
		self thread bp1wave4_hip1_rappel();
		wait 3;
		self setspeed( 50, 25, 20 );
	}
	
	s_start = getstruct( "bp1wave4_hip1_goal12", "targetname" );
	self thread wave4_hip_circle( s_start );
}


bp1wave4_hip1_rappel()
{	
	sp_hip_rappell1 = GetEnt( "bp1wave4_hip1_rappel1", "targetname" );
	sp_hip_rappell2 = GetEnt( "bp1wave4_hip1_rappel2", "targetname" );
	sp_hip_rappell3 = GetEnt( "bp1wave4_hip1_rappel3", "targetname" );
	sp_hip_rappell4 = GetEnt( "bp1wave4_hip1_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	ai_rappel1 = sp_hip_rappell1 spawn_ai( true );
	wait 0.3;
	ai_rappel2 = sp_hip_rappell2 spawn_ai( true );
	wait 1.3;
	ai_rappel3 = sp_hip_rappell3 spawn_ai( true );
	wait 1.4;
	ai_rappel4 = sp_hip_rappell4 spawn_ai( true );
	
	ai_rappel1.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel2.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel3.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel4.overrideActorKilled =::runover_by_horse_callback;
}


bp1wave4_hip2_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hip2_spawnpt", "targetname" );
	
	for( i = 1; i < 15; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hip2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 50, 25 );
	
	self.b_rappel_done = false;
	
	i = 1;
	
	while( i < 15 )
	{
		if ( i == 9 || i == 14 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 7 )
		{
			self setspeed( 50, 25, 15 );
		}
		
		if ( i == 9 )
		{
			if ( ( Distance2D( self.origin, level.player.origin ) < 1000 ) )	
			{
				self SetSpeedImmediate( 0, 25, 20 );
				wait 3;
				self thread bp1wave4_hip2_rappel();
				wait 3;
				self setspeed( 50, 25, 20 );
				
				self.b_rappel_done = true;
			}
		}
		
		i++;
	}
	
	if ( !self.b_rappel_done )
	{
		self SetSpeedImmediate( 0, 25, 20 );
		wait 3;
		self thread bp1wave4_hip2_rappel();
		wait 3;
		self setspeed( 50, 25, 20 );
	}
	
	s_start = getstruct( "bp1wave4_hip2_goal14", "targetname" );
	self thread wave4_hip_circle( s_start );
}


bp1wave4_hip2_rappel()
{	
	sp_hip_rappell1 = GetEnt( "bp1wave4_hip2_rappel1", "targetname" );
	sp_hip_rappell2 = GetEnt( "bp1wave4_hip2_rappel2", "targetname" );
	sp_hip_rappell3 = GetEnt( "bp1wave4_hip2_rappel3", "targetname" );
	sp_hip_rappell4 = GetEnt( "bp1wave4_hip2_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	ai_rappel1 = sp_hip_rappell1 spawn_ai( true );
	wait 0.3;
	ai_rappel2 = sp_hip_rappell2 spawn_ai( true );
	wait 1.3;
	ai_rappel3 = sp_hip_rappell3 spawn_ai( true );
	wait 1.4;
	ai_rappel4 = sp_hip_rappell4 spawn_ai( true );
	
	ai_rappel1.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel2.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel3.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel4.overrideActorKilled =::runover_by_horse_callback;
}


bp1wave4_btr1_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp1wave4_btr1_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave4_btr1_goal2", "targetname" );
		
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;	
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self thread btr_intermittent_attack();
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


bp1wave4_btr2_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp1wave4_btr2_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave4_btr2_goal2", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self thread btr_intermittent_attack();
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


btr_intermittent_attack()
{
	self endon( "death" );
	self endon( "stop_inter_attack" );
	
	while( 1 )
	{
		enable_turret( 1 );
		wait RandomIntRange( 3, 7 );
		disable_turret( 1 );
		wait RandomIntRange( 2, 4 );
	}
}


bp1wave4_hind1_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	self thread update_wave4_objective();
	
	set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hind1_spawnpt", "targetname" );
	
	for( i = 1; i < 23; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hind1_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( i < 23 )
	{
		if ( i == 5 || i == 8 || i == 9 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 5 || i == 8 || i == 9 )
		{
			self thread hind_stop_attack_aftertime( RandomIntRange( 7, 9 ) );
			self hind_attack_think( 3000 );
		}
		
		self ClearLookAtEnt();
		
		i++;
	}
	
	s_start = getstruct( "bp1wave4_hind1_goal10", "targetname" );
	self thread wave4_hind1_circle( s_start );
}


bp1wave4_hind2_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	self thread update_wave4_objective();
	
	set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hind2_spawnpt", "targetname" );
	
	for( i = 1; i < 18; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hind2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( i < 18 )
	{
		if ( i == 5 || i == 6 || i == 7 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 5 || i == 6 || i == 7 )
		{
			self thread hind_stop_attack_aftertime( RandomIntRange( 7, 9 ) );
			self hind_attack_think( 3000 );
		}
		
		self ClearLookAtEnt();
		
		i++;
	}
	
	s_start = getstruct( "bp1wave4_hind2_goal8", "targetname" );
	self thread wave4_hind2_circle( s_start );
}


bp1wave4_tank1_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	self thread update_wave4_objective();
	
	self.target_pos = spawn( "script_model", self.origin + ( 0, 0, 132 ) );
	self.target_pos SetModel( "tag_origin" );
	self.target_pos LinkTo( self );
	
	set_objective( level.OBJ_DEFEND_ALL, self.target_pos, "destroy", -1 );
	
	s_goal1 = getstruct( "bp1wave4_tank1_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave4_tank1_goal2", "targetname" );
	s_goal3 = getstruct( "bp1wave4_tank1_goal3", "targetname" );
	s_goal4 = getstruct( "bp1wave4_tank1_goal4", "targetname" );
	s_goal5 = getstruct( "bp1wave4_tank1_goal5", "targetname" );
	s_goal6 = getstruct( "bp1wave4_tank1_goal6", "targetname" );
	s_goal7 = getstruct( "bp1wave4_tank1_goal7", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self thread tank_targetting();
	wait RandomIntRange( 8, 13 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 8, 13 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal5.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 12, 16 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal6.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 12, 16 );
	self SetBrake( false );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal7.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


bp1wave4_tank2_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	self thread update_wave4_objective();
	
	self.target_pos = spawn( "script_model", self.origin + ( 0, 0, 132 ) );
	self.target_pos SetModel( "tag_origin" );
	self.target_pos LinkTo( self );
	
	set_objective( level.OBJ_DEFEND_ALL, self.target_pos, "destroy", -1 );
	
	s_goal1 = getstruct( "bp1wave4_tank2_goal1", "targetname" );
	s_goal2 = getstruct( "bp1wave4_tank2_goal2", "targetname" );
	s_goal3 = getstruct( "bp1wave4_tank2_goal3", "targetname" );
	s_goal4 = getstruct( "bp1wave4_tank2_goal4", "targetname" );
	s_goal5 = getstruct( "bp1wave4_tank2_goal5", "targetname" );
	s_goal6 = getstruct( "bp1wave4_tank2_goal6", "targetname" );
	s_goal7 = getstruct( "bp1wave4_tank2_goal7", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self thread tank_targetting();
	wait RandomIntRange( 8, 11 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 8, 11 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal5.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 8, 11 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal6.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 8, 11 );
	self SetBrake( false );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal7.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


bp1wave4_vehicle_destroyed()
{
	self waittill( "death" );
	
	level.n_bp1wave4_veh_destroyed++;
	
//	if ( level.n_bp1wave4_veh_destroyed == 2 )
//	{
//		if ( level.n_bp2wave4_veh_destroyed == 2 && level.n_bp3wave4_veh_destroyed == 2 )
//		{
//			flag_set( "blocking_done" );
//		}
//	}
}


bp1wave4_uaz1_rider_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}


bp1wave4_uaz2_rider_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 4: BLOCKING POINT 2 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
bp2wave4_start_event()
{
	level thread bp2wave4_start_vehicles();
	level thread bp2wave4_start_trigger();
}


bp2wave4_start_trigger()
{
	level endon( "bp1wave4_start" );
	level endon( "bp2wave4_start" );
	level endon( "bp3wave4_start" );
	
	trigger_wait( "spawn_wave2_bp2" );
	
	trigger_use( "bp2wave4_uaz1_trigger" );
	trigger_use( "bp2wave4_uaz2_trigger" );
	
	flag_set( "bp2wave4_start" );
}


bp2wave4_start_vehicles()
{
	flag_wait_or_timeout( "bp2wave4_start", 120 );
	
	//iprintlnbold( "start blocking point 2" );
	
	level thread bp2wave4_vehicle_chooser();
	wait 5;
	level thread bp2wave4_boss_chooser();
}


bp2wave4_vehicle_chooser()
{
	level.n_bp2wave4_vehicles = RandomInt( 3 );
		
	s_btr1_spawnpt = getstruct( "bp2wave4_btr1_spawnpt", "targetname" );
	s_btr2_spawnpt = getstruct( "bp2wave4_btr2_spawnpt", "targetname" );
	s_hip1_spawnpt = getstruct( "bp2wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp2wave4_hip2_spawnpt", "targetname" );
		
	if ( level.n_bp2wave4_vehicles == 0 )
	{
		//iprintlnbold( "1 Hip + 1 BTR" );
		vh_hip = spawn_vehicle_from_targetname( "hip1_bp1" );
		vh_hip.origin = s_hip1_spawnpt.origin;
		vh_hip.angles = s_hip1_spawnpt.angles;
		vh_hip thread bp2wave4_hip1_behavior();
		vh_hip thread vehicle_delete_after_defend();
		
		vh_btr = spawn_vehicle_from_targetname( "btr1_bp1" );
		vh_btr.origin = s_btr1_spawnpt.origin;
		vh_btr.angles = s_btr1_spawnpt.angles;
		vh_btr thread bp2wave4_btr1_behavior();
		vh_btr thread vehicle_delete_after_defend();
	}
	
	else if ( level.n_bp2wave4_vehicles == 1 )
	{
		//iprintlnbold( "2 Hips" );
		vh_hip1 = spawn_vehicle_from_targetname( "hip1_bp1" );
		vh_hip1.origin = s_hip1_spawnpt.origin;
		vh_hip1.angles = s_hip1_spawnpt.angles;
		vh_hip1 thread bp2wave4_hip1_behavior();
		vh_hip1 thread vehicle_delete_after_defend();
		
		wait 2;
		
		vh_hip2 = spawn_vehicle_from_targetname( "hip2_bp1" );
		vh_hip2.origin = s_hip2_spawnpt.origin;
		vh_hip2.angles = s_hip2_spawnpt.angles;
		vh_hip2 thread bp2wave4_hip2_behavior();
		vh_hip2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		//iprintlnbold( "2 BTRs" );
		vh_btr1 = spawn_vehicle_from_targetname( "btr1_bp1" );
		vh_btr1.origin = s_btr1_spawnpt.origin;
		vh_btr1.angles = s_btr1_spawnpt.angles;
		vh_btr1 thread bp2wave4_btr1_behavior();
		vh_btr1 thread vehicle_delete_after_defend();
	
		wait 2;
		
		vh_btr2 = spawn_vehicle_from_targetname( "btr2_bp1" );
		vh_btr2.origin = s_btr2_spawnpt.origin;
		vh_btr2.angles = s_btr2_spawnpt.angles;
		vh_btr2 thread bp2wave4_btr2_behavior();
		vh_btr2 thread vehicle_delete_after_defend();
	}
}


bp2wave4_uaz1_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp2wave4_uaz1_goal1", "targetname" );
	s_goal2 = getstruct( "bp2wave4_uaz1_goal2", "targetname" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 30, 20, 15 );
	
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


bp2wave4_uaz2_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp2wave4_uaz2_goal1", "targetname" );
	s_goal2 = getstruct( "bp2wave4_uaz2_goal2", "targetname" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 30, 20, 15 );
	
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


bp2wave4_hip1_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_hip1_spawnpt", "targetname" );
	
	for( i = 1; i < 17; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_hip1_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 25, 20 );
	
	i = 1;
	
	self.b_rappel_done = false;
	
	while( i < 17 )
	{
		if ( i == 8 || i == 9 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 8 )
		{
			if ( ( Distance2D( self.origin, level.player.origin ) < 2000 ) )
			{
				self SetSpeedImmediate( 0, 25, 20 );
				wait 3;
				self thread bp2wave4_hip1_rappel();
				wait 5;
				self setspeed( 50, 25, 20 );
				self.b_rappel_done = true;
			}
		}
		
		if ( i == 9 )
		{
			if ( !self.b_rappel_done )	
			{
				self SetSpeedImmediate( 0, 25, 20 );
				wait 3;
				self thread bp2wave4_hip1_rappel();
				wait 5;
				self setspeed( 50, 25, 20 );
				self.b_rappel_done = true;
			}
		}
				
		i++;
	}
	
	s_start = getstruct( "bp3wave4_hip1_goal10", "targetname" );
	self thread wave4_hip_circle( s_start );
}


bp2wave4_hip1_rappel()
{	
	sp_hip_rappell1 = GetEnt( "bp2wave4_hip1_rappel1", "targetname" );
	sp_hip_rappell2 = GetEnt( "bp2wave4_hip1_rappel2", "targetname" );
	sp_hip_rappell3 = GetEnt( "bp2wave4_hip1_rappel3", "targetname" );
	sp_hip_rappell4 = GetEnt( "bp2wave4_hip1_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	ai_rappel1 = sp_hip_rappell1 spawn_ai( true );
	wait 0.3;
	ai_rappel2 = sp_hip_rappell2 spawn_ai( true );
	wait 1.3;
	ai_rappel3 = sp_hip_rappell3 spawn_ai( true );
	wait 1.4;
	ai_rappel4 = sp_hip_rappell4 spawn_ai( true );
	
	ai_rappel1.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel2.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel3.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel4.overrideActorKilled =::runover_by_horse_callback;
}


bp2wave4_hip2_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_hip2_spawnpt", "targetname" );
	
	for( i = 1; i < 17; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_hip2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 25, 20 );
	
	self.b_rappel_done = false;
	
	i = 1;
	
	while( i < 17 )
	{
		if ( i == 8 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else if ( i == 9 && !self.b_rappel_done )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 8 )
		{
			if ( ( Distance2D( self.origin, level.player.origin ) < 2000 ) )
			{
				self SetSpeedImmediate( 0, 25, 20 );
				wait 3;
				self thread bp2wave4_hip2_rappel();
				wait 5;
				self setspeed( 50, 25, 20 );
				self.b_rappel_done = true;
			}
		}
		
		if ( i == 9 )
		{
			if ( !self.b_rappel_done )	
			{
				self SetSpeedImmediate( 0, 25, 20 );
				wait 3;
				self thread bp2wave4_hip2_rappel();
				wait 5;
				self setspeed( 50, 25, 20 );
				self.b_rappel_done = true;
			}
		}
		
		i++;
	}
	
	s_start = getstruct( "bp3wave4_hip2_goal9", "targetname" );
	self thread wave4_hip_circle( s_start );
}


bp2wave4_hip2_rappel()
{	
	sp_hip_rappell1 = GetEnt( "bp2wave4_hip2_rappel1", "targetname" );
	sp_hip_rappell2 = GetEnt( "bp2wave4_hip2_rappel2", "targetname" );
	sp_hip_rappell3 = GetEnt( "bp2wave4_hip2_rappel3", "targetname" );
	sp_hip_rappell4 = GetEnt( "bp2wave4_hip2_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	ai_rappel1 = sp_hip_rappell1 spawn_ai( true );
	wait 0.3;
	ai_rappel2 = sp_hip_rappell2 spawn_ai( true );
	wait 1.3;
	ai_rappel3 = sp_hip_rappell3 spawn_ai( true );
	wait 1.4;
	ai_rappel4 = sp_hip_rappell4 spawn_ai( true );
	
	ai_rappel1.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel2.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel3.overrideActorKilled =::runover_by_horse_callback;
	ai_rappel4.overrideActorKilled =::runover_by_horse_callback;
}


bp2wave4_btr1_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_btr1_spawnpt", "targetname" );
	
	for( i = 1; i < 5; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_btr1_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 15, 15, 10 );
	
	self thread btr_intermittent_attack();
	
	i = 1;
	
	while( i < 5 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 0, true );
		self waittill_any( "goal", "near_goal" );
		
		i++;
	}
	
	self SetBrake( true );
}


bp2wave4_btr2_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_btr2_spawnpt", "targetname" );
	
	for( i = 1; i < 4; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_btr2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 15, 15, 10 );
	
	self thread btr_intermittent_attack();
	
	i = 1;
	
	while( i < 4 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 0, true );
		self waittill_any( "goal", "near_goal" );
		
		i++;
	}
	
	self SetBrake( true );
}


bp2wave4_boss_chooser()
{
	level.n_bp2wave4_boss = RandomInt( 3 );
		
	if ( level.n_bp2wave4_boss == 0 )
	{
		s_tank1_spawnpt = getstruct( "bp2wave4_tank1_spawnpt", "targetname" );
		s_hind1_spawnpt = getstruct( "bp2wave4_hind1_spawnpt", "targetname" );
		
		//iprintlnbold( "1 Tank + 1 Hind" );
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_tank1_spawnpt.origin;
		vh_tank1.angles = s_tank1_spawnpt.angles;
		vh_tank1 thread bp2wave4_tank1_behavior();
		vh_tank1 thread bp2wave4_vehicle_destroyed();
		vh_tank1 thread vehicle_delete_after_defend();
		
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp2wave4_hind1_behavior();
		vh_hind1 thread bp2wave4_vehicle_destroyed();
		vh_hind1 thread vehicle_delete_after_defend();
	}
	
	else if ( level.n_bp2wave4_boss == 1 )
	{
		//iprintlnbold( "2 Hinds" );
		s_hind1_spawnpt = getstruct( "bp2wave4_hind1_spawnpt", "targetname" );
		s_hind2_spawnpt = getstruct( "bp2wave4_hind2_spawnpt", "targetname" );
		
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp2wave4_hind1_behavior();
		vh_hind1 thread bp2wave4_vehicle_destroyed();
		vh_hind1 thread vehicle_delete_after_defend();
		
		wait 2;
		
		vh_hind2 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind2.origin = s_hind2_spawnpt.origin;
		vh_hind2.angles = s_hind2_spawnpt.angles;
		vh_hind2 thread bp2wave4_hind2_behavior();
		vh_hind2 thread bp2wave4_vehicle_destroyed();
		vh_hind2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		//iprintlnbold( "2 Tanks" );
		s_tank1_spawnpt = getstruct( "bp2wave4_tank1_spawnpt", "targetname" );
		s_tank2_spawnpt = getstruct( "bp2wave4_tank2_spawnpt", "targetname" );
		
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_tank1_spawnpt.origin;
		vh_tank1.angles = s_tank1_spawnpt.angles;
		vh_tank1 thread bp2wave4_tank1_behavior();
		vh_tank1 thread bp2wave4_vehicle_destroyed();
		vh_tank1 thread vehicle_delete_after_defend();
		
		vh_tank2 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank2.origin = s_tank2_spawnpt.origin;
		vh_tank2.angles = s_tank2_spawnpt.angles;
		vh_tank2 thread bp2wave4_tank2_behavior();
		vh_tank2 thread bp2wave4_vehicle_destroyed();
		vh_tank2 thread vehicle_delete_after_defend();
	}	
}


bp2wave4_hind1_behavior()
{
	self endon( "death" );
	self endon( "bp2wave4_hind_attackbase" );
	
	self thread update_wave4_objective();
	
	set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	s_goal1 = getstruct( "bp2wave4_hind1_goal1", "targetname" );
	s_goal2 = getstruct( "bp2wave4_hind1_goal2", "targetname" );
	s_goal3 = getstruct( "bp2wave4_hind1_goal3", "targetname" );
	s_goal4 = getstruct( "bp2wave4_hind1_goal4", "targetname" );
	s_goal5 = getstruct( "bp2wave4_hind1_goal5", "targetname" );
	s_goal6 = getstruct( "bp2wave4_hind1_goal6", "targetname" );
	s_goal7 = getstruct( "bp2wave4_hind1_goal7", "targetname" );
	s_goal8 = getstruct( "bp2wave4_hind1_goal8", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 150, 25, 20 );
	
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread hind_strafe();
	
	self setvehgoalpos( s_goal2.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "stop_strafe" );
	
	self thread hind_attack_indefinitely();
	
	wait 4;
	
	self notify( "stop_attack" );
	
	self setvehgoalpos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread hind_attackbase_timer( 90 );
	
	a_s_leftgoal = [];
	a_s_rightgoal = [];
	
	a_s_leftgoal[ 0 ] = s_goal6;
	a_s_leftgoal[ 1 ] = s_goal7;
	a_s_leftgoal[ 2 ] = s_goal8;
	
	a_s_rightgoal[ 0 ] = s_goal3;
	a_s_rightgoal[ 1 ] = s_goal4;
	a_s_rightgoal[ 2 ] = s_goal5;
	
	while( 1 )
	{
		self setvehgoalpos( a_s_leftgoal[ RandomInt( 3 ) ].origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self thread hind_attack_indefinitely();
				
		wait 4;
		
		self notify( "stop_attack" );
		self ClearLookAtEnt();
		
		self setvehgoalpos( a_s_rightgoal[ RandomInt( 3 ) ].origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self thread hind_attack_indefinitely();
		
		wait RandomIntRange( 4, 7 );
		
		self notify( "stop_attack" );
		self ClearLookAtEnt();
	}
}


bp2wave4_hind2_behavior()
{
	self endon( "death" );
	
	self thread update_wave4_objective();
	
	set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	s_goal1 = getstruct( "bp2wave4_hind2_goal1", "targetname" );
	s_goal2 = getstruct( "bp2wave4_hind2_goal2", "targetname" );
	s_goal3 = getstruct( "bp2wave4_hind2_goal3", "targetname" );
	s_goal4 = getstruct( "bp2wave4_hind2_goal4", "targetname" );
	s_goal5 = getstruct( "bp2wave4_hind2_goal5", "targetname" );
	s_goal6 = getstruct( "bp2wave4_hind2_goal6", "targetname" );
		
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 150, 25, 20 );
	
	self setvehgoalpos( s_goal1.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self thread hind_strafe();
	
	self setvehgoalpos( s_goal2.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "stop_strafe" );
	
	self thread hind_attack_indefinitely();
	
	wait 8;
	
	self notify( "stop_attack" );
	
	self thread hind_attackbase_timer( 105 );
	
	while( 1 )
	{
		self setvehgoalpos( s_goal5.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
		
		self setvehgoalpos( s_goal6.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
		
		self setvehgoalpos( s_goal5.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
		
		self setvehgoalpos( s_goal2.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
		
		self setvehgoalpos( s_goal3.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
		
		self setvehgoalpos( s_goal4.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
		
		self setvehgoalpos( s_goal3.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
		
		self setvehgoalpos( s_goal2.origin, 1 );
		self waittill_any( "goal", "near_goal" );
		
		self hind_hover_attack();
	}
}


hind_hover_attack()
{
	self thread hind_attack_indefinitely();
	wait RandomIntRange( 4, 8 );
	self notify( "stop_attack" );
	self ClearLookAtEnt();	
}


hind_attackbase_timer( n_timer )
{
	self endon( "death" );
	
	wait n_timer;
	
	self notify( "bp2wave4_hind_attackbase" );
	
	self ClearLookAtEnt();
	self ClearVehGoalPos();
	
	self setspeed( 50, 25, 20 );
	
	s_goal1 = getstruct( "bp2wave4_hind_attackpos", "targetname" );
	
	iprintlnbold( "WE HAVE A HELICOPTER APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal1.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	wait 3;
	
	self thread hind_baseattack();
}


bp2wave4_tank1_behavior()
{
	self endon( "death" );
	
	self thread update_wave4_objective();
	
	self.target_pos = spawn( "script_model", self.origin + ( 0, 0, 132 ) );
	self.target_pos SetModel( "tag_origin" );
	self.target_pos LinkTo( self );
	
	set_objective( level.OBJ_DEFEND_ALL, self.target_pos, "destroy", -1 );
	
	s_goal1 = getstruct( "bp2wave4_tank1_goal1", "targetname" );
	s_goal2 = getstruct( "bp2wave4_tank1_goal2", "targetname" );
	s_goal3 = getstruct( "bp2wave4_tank1_goal3", "targetname" );
	s_goal4 = getstruct( "bp2wave4_tank1_goal4", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self enable_turret( 1 );
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self thread tank_targetting();
	wait RandomIntRange( 5, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal4.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


bp2wave4_tank2_behavior()
{
	self endon( "death" );
	
	self thread update_wave4_objective();
	
	self.target_pos = spawn( "script_model", self.origin + ( 0, 0, 132 ) );
	self.target_pos SetModel( "tag_origin" );
	self.target_pos LinkTo( self );
	
	set_objective( level.OBJ_DEFEND_ALL, self.target_pos, "destroy", -1 );
	
	s_goal1 = getstruct( "bp2wave4_tank2_goal1", "targetname" );
	s_goal2 = getstruct( "bp2wave4_tank2_goal2", "targetname" );
	s_goal3 = getstruct( "bp2wave4_tank2_goal3", "targetname" );
	s_goal4 = getstruct( "bp2wave4_tank2_goal4", "targetname" );
	s_goal5 = getstruct( "bp2wave4_tank2_goal5", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self enable_turret( 1 );
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self thread tank_targetting();
	wait RandomIntRange( 5, 7 );
	self SetBrake( false );
		
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 3, 7 );
	self SetBrake( false );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal5.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


bp2wave4_vehicle_destroyed()
{
	self waittill( "death" );
	
	level.n_bp2wave4_veh_destroyed++;
	
//	if ( level.n_bp2wave4_veh_destroyed == 2 )
//	{
//		if ( level.n_bp1wave4_veh_destroyed == 2 && level.n_bp3wave4_veh_destroyed == 2 )
//		{
//			flag_set( "blocking_done" );
//		}
//	}
}


bp2wave4_uaz1_rider_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}


bp2wave4_uaz2_rider_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// WAVE 4: BLOCKING POINT 3 ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
bp3wave4_start_event()
{
	level thread bp3wave4_start_vehicles();
	level thread bp3wave4_start_trigger();
}


bp3wave4_start_vehicles()
{
	flag_wait_or_timeout( "bp3wave4_start", 120 );
	
	//iprintlnbold( "start blocking point 3" );
	
	wait 3;
	
	level thread bp3wave4_vehicle_chooser();
}


bp3wave4_start_trigger()
{
	level endon( "bp1wave4_start" );
	level endon( "bp2wave4_start" );
	level endon( "bp3wave4_start" );
	
	trigger_wait( "spawn_wave2_bp3" );
	
	trigger_use( "bp3wave4_uaz1_trigger" );
	trigger_use( "bp3wave4_uaz2_trigger" );
	
	flag_set( "bp3wave4_start" );
}


bp3wave4_vehicle_chooser()
{
	//level.n_bp3wave4_vehicles = RandomInt( 3 );
	level.n_bp3wave4_vehicles = 0;
		
	s_btr1_spawnpt = getstruct( "bp3wave4_btr1_spawnpt", "targetname" );
	s_btr2_spawnpt = getstruct( "bp3wave4_btr2_spawnpt", "targetname" );
	s_hip1_spawnpt = getstruct( "bp3wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp3wave4_hip2_spawnpt", "targetname" );
		
	if ( level.n_bp3wave4_vehicles == 0 )
	{
		//iprintlnbold( "1 Hip + 1 BTR" );
		vh_hip = spawn_vehicle_from_targetname( "hip1_bp1" );
		vh_hip.origin = s_hip1_spawnpt.origin;
		vh_hip.angles = s_hip1_spawnpt.angles;
		vh_hip thread bp3wave4_hip1_behavior();
		vh_hip thread vehicle_delete_after_defend();
		
		vh_btr = spawn_vehicle_from_targetname( "btr1_bp1" );
		vh_btr.origin = s_btr1_spawnpt.origin;
		vh_btr.angles = s_btr1_spawnpt.angles;
		vh_btr thread bp3wave4_btr1_behavior();
		vh_btr thread vehicle_delete_after_defend();
	}
	
	else if ( level.n_bp3wave4_vehicles == 1 )
	{
		//iprintlnbold( "2 Hips" );
		vh_hip1 = spawn_vehicle_from_targetname( "hip1_bp1" );
		vh_hip1.origin = s_hip1_spawnpt.origin;
		vh_hip1.angles = s_hip1_spawnpt.angles;
		vh_hip1 thread bp3wave4_hip1_behavior();
		vh_hip1 thread vehicle_delete_after_defend();
		
		wait 2;
		
		vh_hip2 = spawn_vehicle_from_targetname( "hip2_bp1" );
		vh_hip2.origin = s_hip2_spawnpt.origin;
		vh_hip2.angles = s_hip2_spawnpt.angles;
		vh_hip2 thread bp3wave4_hip2_behavior();
		vh_hip2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		//iprintlnbold( "2 BTRs" );
		vh_btr1 = spawn_vehicle_from_targetname( "btr1_bp1" );
		vh_btr1.origin = s_btr1_spawnpt.origin;
		vh_btr1.angles = s_btr1_spawnpt.angles;
		vh_btr1 thread bp3wave4_btr1_behavior();
		vh_btr1 thread vehicle_delete_after_defend();
		
		wait 2;
		
		vh_btr2 = spawn_vehicle_from_targetname( "btr2_bp1" );
		vh_btr2.origin = s_btr2_spawnpt.origin;
		vh_btr2.angles = s_btr2_spawnpt.angles;
		vh_btr2 thread bp3wave4_btr2_behavior();
		vh_btr2 thread vehicle_delete_after_defend();
	}
	
	////////////////////////////////////////////////
	
	wait 5;
	
	level.n_bp3wave4_boss = RandomInt( 3 );
	
	s_tank1_spawnpt = getstruct( "bp3wave4_tank1_spawnpt", "targetname" );
	s_tank2_spawnpt = getstruct( "bp3wave4_tank2_spawnpt", "targetname" );
	s_hind1_spawnpt = getstruct( "bp3wave4_hind1_spawnpt", "targetname" );
	s_hind2_spawnpt = getstruct( "bp3wave4_hind2_spawnpt", "targetname" );
	
	if ( level.n_bp3wave4_boss == 0 )
	{
		//iprintlnbold( "1 Tank + 1 Hind" );
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_tank1_spawnpt.origin;
		vh_tank1.angles = s_tank1_spawnpt.angles;
		vh_tank1 thread bp3wave4_tank1_behavior();
		vh_tank1 thread bp3wave4_vehicle_destroyed();
		vh_tank1 thread vehicle_delete_after_defend();
		
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp3wave4_hind1_behavior();
		vh_hind1 thread bp3wave4_vehicle_destroyed();
		vh_hind1 thread vehicle_delete_after_defend();
	}
	
	else if ( level.n_bp3wave4_boss == 1 )
	{
		//iprintlnbold( "2 Hinds" );
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp3wave4_hind1_behavior();
		vh_hind1 thread bp3wave4_vehicle_destroyed();
		vh_hind1 thread vehicle_delete_after_defend();
		
		wait 3;
		
		vh_hind2 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind2.origin = s_hind2_spawnpt.origin;
		vh_hind2.angles = s_hind2_spawnpt.angles;
		vh_hind2 thread bp3wave4_hind2_behavior();
		vh_hind2 thread bp3wave4_vehicle_destroyed();
		vh_hind2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		//iprintlnbold( "2 Tanks" );
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_tank1_spawnpt.origin;
		vh_tank1.angles = s_tank1_spawnpt.angles;
		vh_tank1 thread bp3wave4_tank1_behavior();
		vh_tank1 thread bp3wave4_vehicle_destroyed();
		vh_tank1 thread vehicle_delete_after_defend();
		
		wait 4;
		
		vh_tank2 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank2.origin = s_tank2_spawnpt.origin;
		vh_tank2.angles = s_tank2_spawnpt.angles;
		vh_tank2 thread bp3wave4_tank2_behavior();
		vh_tank2 thread bp3wave4_vehicle_destroyed();
		vh_tank2 thread vehicle_delete_after_defend();
	}
}


bp3wave4_uaz1_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp3wave4_uaz1_goal1", "targetname" );
	s_goal2 = getstruct( "bp3wave4_uaz1_goal2", "targetname" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 30, 20, 15 );
	
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


bp3wave4_uaz2_behavior()
{
	self endon( "death" );
	
	self thread vehicle_delete_after_defend();
	
	s_goal1 = getstruct( "bp3wave4_uaz2_goal1", "targetname" );
	s_goal2 = getstruct( "bp3wave4_uaz2_goal2", "targetname" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 30, 20, 15 );
	
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_goal2.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	wait 1;
	
	self notify( "unload" );
}


bp3wave4_hip1_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hip1_spawnpt", "targetname" );
	
	for( i = 1; i < 14; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hip1_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( i < 14 )
	{
		if ( i == 5 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 3 )
		{
			self setspeed( 50, 25, 20 );
		}
		
		if ( i == 5 )
		{
			self SetSpeedImmediate( 0, 25, 20 );
			wait 3;
			self bp3wave4_hip1_rappel();
			wait 3;
			self setspeed( 50, 25, 20 );
		}
		
		i++;
	}
	
	s_start = getstruct( "bp3wave4_hip1_goal7", "targetname" );
	self thread wave4_hip_circle( s_start );
}


bp3wave4_hip1_rappel()
{	
	sp_hip_rappell1 = GetEnt( "bp3wave4_hip1_rappel1", "targetname" );
	sp_hip_rappell2 = GetEnt( "bp3wave4_hip1_rappel2", "targetname" );
	sp_hip_rappell3 = GetEnt( "bp3wave4_hip1_rappel3", "targetname" );
	sp_hip_rappell4 = GetEnt( "bp3wave4_hip1_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	sp_hip_rappell1 spawn_ai( true );
	wait 0.3;
	sp_hip_rappell2 spawn_ai( true );
	wait 1.3;
	sp_hip_rappell3 spawn_ai( true );
	wait 1.4;
	sp_hip_rappell4 spawn_ai( true );
}


bp3wave4_hip2_behavior()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hip2_spawnpt", "targetname" );
	
	for( i = 1; i < 14; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hip2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( i < 14 )
	{
		if ( i == 5 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 4 )
		{
			self setspeed( 50, 25, 15 );
		}
		
		if ( i == 5 )
		{
			self SetSpeedImmediate( 0, 25, 20 );
			wait 3;
			self bp3wave4_hip2_rappel();
			wait 3;
			self setspeed( 50, 25, 20 );
		}
		
		i++;
	}
	
	s_start = getstruct( "bp3wave4_hip2_goal7", "targetname" );
	self thread wave4_hip_circle( s_start );
}


bp3wave4_hip2_rappel()
{	
	sp_hip_rappell1 = GetEnt( "bp3wave4_hip2_rappel1", "targetname" );
	sp_hip_rappell2 = GetEnt( "bp3wave4_hip2_rappel2", "targetname" );
	sp_hip_rappell3 = GetEnt( "bp3wave4_hip2_rappel3", "targetname" );
	sp_hip_rappell4 = GetEnt( "bp3wave4_hip2_rappel4", "targetname" );
	
	s_rappel_point1 = spawnstruct();
	s_rappel_point1.origin = self.origin + ( 47, 127, -114 );
	
	s_rappel_point2 = spawnstruct();
	s_rappel_point2.origin = self.origin + ( 0, -115, -114 );
	
	sp_hip_rappell1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, true, false );
	sp_hip_rappell3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point1, false, true );
	
	sp_hip_rappell2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, true, false );
	sp_hip_rappell4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point2, false, true );
		
	sp_hip_rappell1 spawn_ai( true );
	wait 0.3;
	sp_hip_rappell2 spawn_ai( true );
	wait 1.3;
	sp_hip_rappell3 spawn_ai( true );
	wait 1.4;
	sp_hip_rappell4 spawn_ai( true );
}


bp3wave4_btr1_behavior()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "bp3wave4_btr1_goal1", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self thread btr_intermittent_attack();
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


bp3wave4_btr2_behavior()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "bp3wave4_btr2_goal1", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self thread btr_intermittent_attack();
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
}


bp3wave4_hind1_behavior()
{
	self endon( "death" );
	
	self thread update_wave4_objective();
	
	set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hind1_spawnpt", "targetname" );
	
	for( i = 1; i < 11; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hind1_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 25, 15 );
	
	i = 1;
	
	while( i < 11 )
	{
		if ( i == 10 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		i++;
	}
	
	self thread hind_attack_indefinitely();
	
	wait RandomIntRange( 40, 60 );
	
	self notify( "stop_attack" );
	
	s_goal = getstruct( "bp3wave4_hind1_goal11", "targetname" );
	
	self ClearLookAtEnt();
	self ClearVehGoalPos();
	
	iprintlnbold( "WE HAVE A HELICOPTER APPROACHING THE BASE" );
	
	self SetVehGoalPos( s_goal.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self thread hind_baseattack();
}


bp3wave4_hind2_behavior()
{
	self endon( "death" );
	
	self thread update_wave4_objective();
	
	set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hind2_spawnpt", "targetname" );
	
	for( i = 1; i < 8; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hind2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 50, 25, 15 );
	
	i = 1;
	
	while( i < 8 )
	{
		if ( i == 7 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		i++;
	}
	
	self thread hind_attack_indefinitely();
	
	wait RandomIntRange( 45, 70 );
	
	self notify( "stop_attack" );
	
	s_goal = getstruct( "bp3wave4_hind2_goal8", "targetname" );
	
	self ClearLookAtEnt();
	self ClearVehGoalPos();
	
	self SetVehGoalPos( s_goal.origin, 1 );
}


bp3wave4_tank1_behavior()
{
	self endon( "death" );
	
	self thread update_wave4_objective();
	
	self.target_pos = spawn( "script_model", self.origin + ( 0, 0, 132 ) );
	self.target_pos SetModel( "tag_origin" );
	self.target_pos LinkTo( self );
	
	set_objective( level.OBJ_DEFEND_ALL, self.target_pos, "destroy", -1 );
	
	s_goal1 = getstruct( "bp3wave4_tank1_goal1", "targetname" );
	s_goal2 = getstruct( "bp3wave4_tank1_goal2", "targetname" );
	s_goal3 = getstruct( "bp3wave4_tank1_goal3", "targetname" );
	s_goal4 = getstruct( "bp3wave4_tank1_goal4", "targetname" );
	s_goal5 = getstruct( "bp3wave4_tank1_goal5", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self enable_turret( 1 );
	
	self thread tank_targetting();
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 5, 7 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 8, 11 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 10, 17 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 15, 17 );
	self SetBrake( false );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal5.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


bp3wave4_tank2_behavior()
{
	self endon( "death" );
	
	self thread update_wave4_objective();
	
	self.target_pos = spawn( "script_model", self.origin + ( 0, 0, 132 ) );
	self.target_pos SetModel( "tag_origin" );
	self.target_pos LinkTo( self );
	
	set_objective( level.OBJ_DEFEND_ALL, self.target_pos, "destroy", -1 );
	
	s_goal1 = getstruct( "bp3wave4_tank2_goal1", "targetname" );
	s_goal2 = getstruct( "bp3wave4_tank2_goal2", "targetname" );
	s_goal3 = getstruct( "bp3wave4_tank2_goal3", "targetname" );
	s_goal4 = getstruct( "bp3wave4_tank2_goal4", "targetname" );
	s_goal5 = getstruct( "bp3wave4_tank2_goal5", "targetname" );
	
	self SetVehicleAvoidance( true );
	
	self SetBrake( true );
	wait 0.3;
	self SetBrake( false );
	
	self SetNearGoalNotifyDist( 200 );
	
	self enable_turret( 1 );
	
	self thread tank_targetting();
	
	self setspeed( 15, 15, 10 );
	self setvehgoalpos( s_goal1.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 9, 11 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal2.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 8, 10 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal3.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 11, 17 );
	self SetBrake( false );
	
	self setvehgoalpos( s_goal4.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	wait RandomIntRange( 15, 17 );
	self SetBrake( false );
	
	iprintlnbold( "WE HAVE A TANK APPROACHING THE BASE" );
	
	self setvehgoalpos( s_goal5.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	self notify( "tank_stop_attack" );
	
	self SetBrake( true );
	
	wait 3;
	
	self thread tank_baseattack();
}


bp3wave4_vehicle_destroyed()
{
	self waittill( "death" );
	
	level.n_bp3wave4_veh_destroyed++;
	
//	if ( level.n_bp3wave4_veh_destroyed == 2 )
//	{
//		if ( level.n_bp1wave4_veh_destroyed == 2 && level.n_bp2wave4_veh_destroyed == 2 )
//		{
//			flag_set( "blocking_done" );
//		}
//	}
}


wave4_hip_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	
	self thread bp3wave4_hip_fire_support();
	
	self SetSpeed( 50, 25, 20 );
	
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


wave4_hind1_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	self endon( "bp1wave4_hind1_attackbase" );
	
	self SetSpeed( 50, 25, 20 );
	
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		if ( s_goal.targetname == "bp1wave4_hind1_goal11" || s_goal.targetname == "bp1wave4_hind1_goal15" )
		{
			self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
			self hind_attack_think( 3000 );		
		}
			
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


wave4_hind2_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	self endon( "bp1wave4_hind2_attackbase" );
	
	self SetSpeed( 50, 25, 20 );
	
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		if ( s_goal.targetname == "bp1wave4_hind2_goal9" || s_goal.targetname == "bp1wave4_hind2_goal13" || s_goal.targetname == "bp1wave4_hind2_goal17" )
		{
			self thread hind_stop_attack_aftertime( RandomIntRange( 4, 8 ) );
			self hind_attack_think( 3000 );		
		}
			
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


bp3wave4_hip_fire_support()
{
	self endon( "death" );
	
	self waittill_any( "goal", "near_goal" );
	
	self enable_turret( 2 );
}


bp3wave4_uaz1_rider_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}


bp3wave4_uaz2_rider_logic()
{
	self endon( "death" );
	
	self.overrideActorKilled =::runover_by_horse_callback;
}


vehicle_delete_after_defend()
{
	flag_wait( "blocking_done" );
	
	self delete();
}


horse_to_player()  //self = level.player
{
	level endon( "blocking_done" );
	
	while( 1 )
	{
		self waittill( "exit_vehicle", vehicle );
		
		vehicle thread horse_follow_player();
		
		vehicle waittill( "death" );
		
		level thread spawn_backup_arena_horse();
				
		self waittill( "enter_vehicle", vehicle );
	}
}


spawn_backup_arena_horse()
{
	s_spawnpt = getstruct( "backup_horse_spawnpt", "targetname" );
	
	if ( !flag( "blocking_done" ) )
	{
		vh_horse = spawn_vehicle_from_targetname( "backup_horse" );
		vh_horse.origin = s_spawnpt.origin;
		vh_horse.angles = s_spawnpt.angles;
		
		vh_horse thread horse_follow_player();
		
		vh_horse Godon();
		vh_horse SetNearGoalNotifyDist( 200 );
		vh_horse SetSpeed( 25, 15, 10 );
	}
}


horse_follow_player()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	while( 1 )
	{
		if ( Distance2D( self.origin, level.player.origin ) > 500 )
		{
			self SetVehGoalPos( level.player.origin, 1, true );
		}
		
		wait 2;
	}
	
	self ClearVehGoalPos();
	self SetBrake( true );
	self SetSpeedImmediate( 0 );
	self MakeVehicleUsable();
	self SetBrake( false );
	self SetSpeed( 25, 15, 10 );
}