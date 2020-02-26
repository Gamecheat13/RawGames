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
	flag_init( "arena_return" );
	flag_init( "bp1wave4_start" );
	flag_init( "bp2wave4_start" );
	flag_init( "bp3wave4_start" );
	flag_init( "wave4_started" );
	flag_init( "all_veh_destroyed" );
	flag_init( "blocking_done" );
}


init_spawn_funcs()
{
	//Blocking Point 1
	add_spawn_function_veh( "bp1wave4_btr1", ::bp1wave4_btr1_behavior );
	add_spawn_function_veh( "bp1wave4_btr2", ::bp1wave4_btr2_behavior );
	add_spawn_function_veh( "bp1wave4_tank1", ::bp1wave4_tank1_behavior );
	add_spawn_function_veh( "bp1wave4_tank2", ::bp1wave4_tank2_behavior );
	
	add_spawn_function_group( "bp1wave4_hip1_rappel", "targetname", ::bp1wave4_hip1_rappel_logic );
	
	add_spawn_function_group( "base_launcher_defender", "targetname", ::launcher_defender_logic );
	add_spawn_function_group( "base_stinger_defender", "targetname", ::stinger_defender_logic );
}


skipto_blockingdone()
{
	skipto_setup();
	
	init_hero( "zhao" );
	init_hero( "woods" );

	skipto_teleport( "skipto_blockingdone", level.heroes );
	
	//level.player GiveWeapon( "sticky_grenade_afghan_sp" );
	//level.player GiveMaxAmmo( "sticky_grenade_afghan_sp" );
	
	level.player SetClientDvar("cg_objectiveIndicatorFarFadeDist", 13000);
	
	level thread maps\_horse::set_horse_in_combat( true );
	
	level.zhao = getent( "zhao_ai", "targetname" );
	level.woods = getent( "woods_ai", "targetname" );
	
	s_horse_zhao = getstruct( "last_zhao_horse", "targetname" );
	s_horse_woods = getstruct( "last_woods_horse", "targetname" );
	s_horse_player = getstruct( "last_player_horse", "targetname" );
	
	level.zhao_horse = spawn_vehicle_from_targetname( "zhao_horse" );
	level.zhao_horse.origin = s_horse_zhao.origin;
	level.zhao_horse.angles = s_horse_zhao.angles;
	level.zhao_horse veh_magic_bullet_shield( true );
	
	level.woods_horse = spawn_vehicle_from_targetname( "woods_horse" );
	level.woods_horse.origin = s_horse_woods.origin;
	level.woods_horse.angles = s_horse_woods.angles;
	level.woods_horse veh_magic_bullet_shield( true );
	
	level.mason_horse = spawn_vehicle_from_targetname( "mason_horse" );
	level.mason_horse.origin = s_horse_player.origin;
	level.mason_horse.angles = s_horse_player.angles;
	
	wait 0.1;
		
	level.mason_horse MakeVehicleUsable();
		
	wait 0.1;
	
	level.player_wave3_loc = 1;  //bp the player is located when wave3 is complete
	
	level thread monitor_base_health();
	level thread stock_weapon_caches();
	
	flag_wait( "afghanistan_gump_arena" );
}


zhao_return_base()
{
	level endon( "blocking_done" );
	
	s_return_base = getstruct( "zhao_return", "targetname" );
	
	self SetBrake( false );
	self SetNearGoalNotifyDist( 200 );
	self SetVehicleAvoidance( true );
	
	if ( !IsDefined( self get_driver() ) )
	{
		level.zhao ai_mount_horse( self );
	}
	
	wait 0.5;
	
	self setspeed( 25, 20, 10 );
	self setvehgoalpos( s_return_base.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	wait 0.5;
	
	level.zhao ai_dismount_horse( self );
	level.zhao set_fixednode( false );
}


woods_return_base()
{
	level endon( "blocking_done" );
		
	s_return_base = getstruct( "zhao_return", "targetname" );
	
	self SetBrake( false );
	self SetNearGoalNotifyDist( 200 );
	self SetVehicleAvoidance( true );
	
	if ( !IsDefined( self get_driver() ) )
	{
		level.woods ai_mount_horse( self );
	}
	
	wait 1.5;
	
	self setspeed( 25, 20, 10 );
	self setvehgoalpos( s_return_base.origin + ( 100, 100, 0 ), 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	wait 0.5;
	
	level.woods ai_dismount_horse( self );
	level.woods set_fixednode( false );
}


main()
{
	maps\createart\afghanistan_art::open_area();
	
	if (  level.skipto_point == "blocking_done" )
	{
		maps\afghanistan_anim::init_afghan_anims_part1b();
		delete_section1_scenes();
		delete_section3_scenes();
	}
	
	init_spawn_funcs();
	cleanup_arena();
	
	level.n_wave4_bp = 0;
	level.b_tank_warn = false;
	
	level thread base_reinforcement();
	level thread spawn_base_defenders();
	level thread objectives_wave4();
	
	level thread bp1wave4_start_event();
	level thread bp2wave4_start_event();
	level thread bp3wave4_start_event();
	
	level.zhao_horse thread zhao_return_base();
	level.woods_horse thread woods_return_base();
	
	spawn_manager_enable( "manager_arena_fight" );
	
	if ( level.player_wave3_loc == 1 )	//bp the player is located when wave 3 is completed
	{
		if ( cointoss() )
		{
			flag_set( "bp2wave4_start" );
		}
		
		else
		{
			flag_set( "bp3wave4_start" );
		}
		
		wait 9;
		
		if ( flag( "bp2wave4_start" ) )
		{
			flag_set( "bp3wave4_start" );
		}
		
		else
		{
			flag_set( "bp2wave4_start" );
		}
		
		wait 5;
		
		flag_set( "bp1wave4_start" );
	}
	
	else if ( level.player_wave3_loc == 2 )
	{
		if ( cointoss() )
		{
			flag_set( "bp1wave4_start" );
		}
		
		else
		{
			flag_set( "bp3wave4_start" );
		}
		
		wait 9;
		
		if ( flag( "bp1wave4_start" ) )
		{
			flag_set( "bp3wave4_start" );
		}
		
		else
		{
			flag_set( "bp1wave4_start" );
		}
		
		wait 5;
		
		flag_set( "bp2wave4_start" );
	}
	
	else
	{
		if ( cointoss() )
		{
			flag_set( "bp1wave4_start" );
		}
		
		else
		{
			flag_set( "bp2wave4_start" );
		}
		
		wait 9;
		
		if ( flag( "bp1wave4_start" ) )
		{
			flag_set( "bp2wave4_start" );
		}
		
		else
		{
			flag_set( "bp1wave4_start" );
		}
		
		wait 5;
		
		flag_set( "bp3wave4_start" );
	}
	
	level thread struct_cleanup_wave2();
	
	flag_set( "wave4_started" );
	
	flag_wait( "arena_return" );
		
	flag_wait( "blocking_done" );
}


objectives_wave4()
{
	flag_wait_any( "bp1wave4_start", "bp2wave4_start", "bp3wave4_start" );
	
	set_objective( level.OBJ_DEFEND_ALL, undefined, undefined, level.n_wave4_bp );
}


vo_defend()
{
	level.woods say_dialog( "wood_how_the_hell_d_they_0", 0 );  //How the Hell'd they slip through?!
	
	level.zhao say_dialog( "zhao_brute_force_and_stre_0", 1 );  //Brute force and strength in numbers?  You expected such a fight.
	
	level.woods say_dialog( "wood_doesn_t_mean_i_wante_0", 0.5 );  //Doesn't mean I wanted it.
	
	flag_wait_all( "bp1wave4_start", "bp2wave4_start", "bp3wave4_start" );
	
	level.woods say_dialog( "wood_they_russians_must_h_0", 1 );  //They Russians must have sent half their damn army!
	
	level.woods say_dialog( "wood_tear_em_up_mason_0", 2 );  //Tear ‘em up, Mason.
}


update_wave4_objective()
{
	level endon( "all_veh_destroyed" );
	
	self waittill( "death" );
	
	if ( level.n_wave4_bp < 6 )
	{
		level.n_wave4_bp++;
		
		if ( level.n_wave4_bp == 1 )
		{
			autosave_by_name( "arena_half_done" );	
		}
		
		else if ( level.n_wave4_bp == 2 )
		{
			level.player thread say_dialog( "maso_come_on_0", 1 );  //Come on!!!
						
			autosave_by_name( "wave4_vehicle" );
		}
		
		else if ( level.n_wave4_bp == 3 )
		{
			level.woods thread say_dialog( "wood_keep_it_up_brother_0", 1 );  //Keep it up, brother!	
		}
		
		else if ( level.n_wave4_bp == 4 )
		{
			level.woods thread say_dialog( "wood_come_on_0", 1 );  //Come on!
		}
		
		else
		{
			level.player thread say_dialog( "maso_fuck_you_1", 1 );  //Fuck you!
		}
			
		wait 1;
		
		set_objective( level.OBJ_DEFEND_ALL, undefined, undefined, level.n_wave4_bp );
		
		if ( level.n_wave4_bp > 5 && !flag( "all_veh_destroyed" ) )
		{
			level thread back_to_base();
			
			flag_set( "all_veh_destroyed" );
		}
	}
}


back_to_base()
{
	set_objective( level.OBJ_PROTECT, undefined, "done" );
	set_objective( level.OBJ_DEFEND_ALL, undefined, "done" );
		
	wait 1;
	
	set_objective( level.OBJ_DEFEND_ALL, undefined, "delete" );
	
	s_return_base = getstruct( "return_base_pos", "targetname" );
	
	//set_objective( level.OBJ_RETURN_BASE, level.zhao, "follow" );
	
	flag_wait( "all_veh_destroyed" );
	
	autosave_by_name( "wave4_done" );
	
	level.woods say_dialog( "huds_nice_work_guys_c_0", 0.5 );  //Nice work, guys... Come on back to base.
	
	level.woods say_dialog( "huds_leave_the_mopping_up_0", 0.5 );  //Leave the mopping up to the Muj.
	
	level.woods say_dialog( "wood_fucking_a_0", 0.5 );  //Fucking - A!
		
	wait 1;
	
	//trigger_wait( "return_base_trigger" );
		
	//cleanup_arena();
	
	flag_set( "blocking_done" );
	
	//set_objective( level.OBJ_RETURN_BASE, level.zhao, "remove" );
	
	//set_objective( level.OBJ_RETURN_BASE, undefined, "done" );
	
	level.player FreezeControls( true );
}


base_reinforcement()
{
	s_defend = getstruct( "base_defend_pos", "targetname" );
	
	set_objective( level.OBJ_PROTECT, s_defend, "defend" );
	
	trigger_wait( "trigger_horse_reinforcement" );
	
	level thread vo_defend();
	
	set_objective( level.OBJ_PROTECT, s_defend, "remove" );
	
	s_spawnpt = getstruct( "reinforcement_spawnpt", "targetname" );
	
	vh_horses = [];
	
	for ( i = 0; i < 4; i++ )
	{
		vh_horses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		vh_horses[ i ].origin = s_spawnpt.origin;
		vh_horses[ i ].angles = s_spawnpt.angles;
		
		sp_rider = GetEnt( "reinforcement_rider", "targetname" );
		ai_rider = sp_rider spawn_ai( true );
		
		vh_horses[ i ] thread horse_reinforcement_behavior( ai_rider );
		
		wait 0.3;
	}
	
//	wait 3;
//	
//	s_spawnpt = getstruct( "truck_base_defense_spawnpt", "targetname" );
//	
//	vh_truck = spawn_vehicle_from_targetname( "truck_afghan" );
//	vh_truck.origin = s_spawnpt.origin;
//	vh_truck.angles = s_spawnpt.angles;
//	
//	sp_rider = GetEnt( "muj_assault", "targetname" );
//	ai_rider1 = sp_rider spawn_ai( true );
//	ai_rider2 = sp_rider spawn_ai( true );
//	
//	if ( IsAlive( ai_rider1 ) && IsAlive( vh_truck ) )
//	{
//		ai_rider1.script_startingposition = 0;
//		ai_rider1 enter_vehicle( vh_truck );
//	}
//	
//	if ( IsAlive( ai_rider2 ) && IsAlive( vh_truck ) )
//	{
//		ai_rider2.script_startingposition = 2;
//		ai_rider2 enter_vehicle( vh_truck );
//	}
//	
//	if ( IsAlive( vh_truck ) )
//	{
//		vh_truck thread truck_base_defense_behavior();
//	}
	
	flag_wait( "blocking_done" );
	
	spawn_manager_kill( "manager_arena_fight" );
	spawn_manager_kill( "manager_hip3_troops" );
	
	flag_set( "end_arena_migs" );
	
//	for ( i = 0; i < 4; i++ )
//	{
//		if ( IsDefined( vh_horses[ i ] ) )
//		{
//			VEHICLE_DELETE( vh_horses[ i ] );
//		}
//	}
}


horse_reinforcement_behavior( ai_rider )  //self = ai horse
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	self MakeVehicleUnusable();
	
	self setspeed( 25, 20, 10 );
	
	if ( IsDefined( ai_rider ) )
	{
		ai_rider enter_vehicle( self );
	
		wait 0.1;
		
		self notify( "groupedanimevent", "ride" );
		
		if ( IsDefined( ai_rider ) )
		{
			ai_rider maps\_horse_rider::ride_and_shoot( self );
		}
	}
	
	s_goal0 = getstruct( "reinforcement_goal0", "targetname" );
	s_goal1 = getstruct( "reinforcement_goal1", "targetname" );
	s_goal2 = getstruct( "reinforcement_goal2", "targetname" );
	s_goal3 = getstruct( "reinforcement_goal3", "targetname" );
	
	while( 1 )
	{
		self setvehgoalpos( s_goal0.origin, 0, 1 );
		self waittill_any( "goal", "near_goal" );
		self setvehgoalpos( s_goal1.origin, 0, 1 );
		self waittill_any( "goal", "near_goal" );
		self setvehgoalpos( s_goal2.origin, 0, 1 );
		self waittill_any( "goal", "near_goal" );
		self setvehgoalpos( s_goal3.origin, 0, 1 );
		self waittill_any( "goal", "near_goal" );
	}
}


truck_base_defense_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self veh_magic_bullet_shield( true );
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	self MakeVehicleUnusable();
	
	self setspeed( 30, 20, 10 );
	
	s_goal0 = getstruct( "reinforcement_goal0", "targetname" );
	s_goal1 = getstruct( "truck_goal1", "targetname" );
	s_goal2 = getstruct( "truck_goal2", "targetname" );
	s_goal3 = getstruct( "truck_goal3", "targetname" );
	
	self setvehgoalpos( s_goal0.origin, 0, 1 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal1.origin, 0, 1 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0, 1 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal3.origin, 0, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self notify( "unload" );
	
	self waittill( "unloaded" );
	
	self MakeVehicleUsable();
}


spawn_base_defenders()
{
	trigger_wait( "trigger_horse_reinforcement" );
	
	ai_stinger = GetEnt( "base_stinger_defender", "targetname" ) spawn_ai( true );
	
	wait 0.1;
	
	ai_launcher = GetEnt( "base_launcher_defender", "targetname" ) spawn_ai( true );	
}


stinger_defender_logic()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self magic_bullet_shield();
	
	self thread crew_stinger_logic();
	
	flag_wait( "all_veh_destroyed" );
	
	self stop_magic_bullet_shield();
	
	self die();
}


launcher_defender_logic()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self magic_bullet_shield();
	
	self thread crew_rpg_logic();
	
	flag_wait( "all_veh_destroyed" );
	
	self stop_magic_bullet_shield();
	
	self die();
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
	
	flag_set( "bp1wave4_start" );
}


bp1wave4_start_vehicles()
{
	level endon( "blocking_done" );
	
	flag_wait( "bp1wave4_start" );
	
	level thread bp1wave4_boss_chooser();
	//level thread bp1wave4_vehicle_chooser();
	
	wait RandomIntRange( 5, 10 );
	
	level thread bp1wave4_vehicle_chooser();
	//level thread bp1wave4_boss_chooser();
}


bp1wave4_vehicle_chooser()
{
	level endon( "blocking_done" );
	
	level.n_bp1wave4_vehicles = 1;
	
	s_hip1_spawnpt = getstruct( "bp1wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp1wave4_hip2_spawnpt", "targetname" );
	
	if ( level.n_bp1wave4_vehicles == 1 )
	{
		vh_hip1 = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip1.origin = s_hip1_spawnpt.origin;
		vh_hip1.angles = s_hip1_spawnpt.angles;
		vh_hip1 thread bp1wave4_hip1_behavior();
		
		vh_hip1 waittill( "death" );
		
		vh_hip2 = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip2.origin = s_hip2_spawnpt.origin;
		vh_hip2.angles = s_hip2_spawnpt.angles;
		vh_hip2 thread bp1wave4_hip2_behavior();
	}
}


bp1wave4_boss_chooser()
{
	level endon( "blocking_done" );
	
	level.n_bp1wave4_boss = 1;
		
	s_hind1_spawnpt = getstruct( "bp1wave4_hind1_spawnpt", "targetname" );
	s_hind2_spawnpt = getstruct( "bp1wave4_hind2_spawnpt", "targetname" );
	
	if ( level.n_bp1wave4_boss == 1 )
	{
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp1wave4_hind1_behavior();
	}
}


bp1wave4_hip1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread vehicle_delete_after_defend();
	self thread heli_select_death();
	self thread update_wave4_objective();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hip1_spawnpt", "targetname" );
	
	for( i = 1; i < 12; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hip1_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self SetForceNoCull();
	
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
				//self bp1wave4_hip1_rappel();
				self.b_rappel_done = false;
				wait 3;
				self.b_rappel_done = true;
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
		self bp1wave4_hip1_rappel();
		wait 5;
		self setspeed( 50, 25, 20 );
		
		self.b_rappel_done = true;
	}
	
	s_start = getstruct( "bp1wave4_hip1_goal12", "targetname" );
	self thread hip_circle( s_start );
	self thread hip_attack();
}


bp1wave4_hip1_rappel()
{	
	self endon( "death" );
	level endon( "blocking_done" );
	
	s_rappel_point = spawnstruct();
	s_rappel_point.origin = self.origin + ( AnglesToForward( self.angles ) * 135 ) - ( AnglesToRight( self.angles ) * 55 ) + ( 0, 0, -155 );
	
	sp_rappell = GetEnt( "bp1wave4_hip1_rappel", "targetname" );
	//sp_rappell add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point, true, false );
		
	spawn_manager_enable( "manager_bp1wave4_hip1_rappel" );
	
	level thread bp1wave4_hip1_rappel_cache();
}


bp1wave4_hip1_rappel_logic()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	vol_cache = GetEnt( "vol_cache4", "targetname" );
	
	self SetGoalVolumeAuto( vol_cache );
}


bp1wave4_hip1_rappel_cache()
{
	flag_wait( "arena_return" );
	
	wait 5;
	
	a_ai_guys = GetEntArray( "bp1wave4_hip1_rappel_ai", "targetname" );
	
	vol_cache = GetEnt( "vol_cache3", "targetname" );
	
	if ( a_ai_guys.size )
	{
		foreach( ai_guy in a_ai_guys )
		{
			wait RandomFloatRange( 0.5, 2.0 );
			
			if ( IsAlive( ai_guy ) )
			{
				ai_guy ClearGoalVolume();
				ai_guy SetGoalVolumeAuto( vol_cache );
			}
		}
	}
}


bp1wave4_hip1_rappel_arena()
{
	a_ai_guys = GetEntArray( "bp1wave4_hip1_rappel_ai", "targetname" );
	
	vol_arena = GetEnt( "vol_arena", "targetname" );
	
	if ( a_ai_guys.size )
	{
		foreach( ai_guy in a_ai_guys )
		{
			wait RandomFloatRange( 0.5, 2.0 );
			
			if ( IsAlive( ai_guy ) )
			{
				ai_guy ClearGoalVolume();
				ai_guy SetGoalVolumeAuto( vol_arena );
			}
		}
	}
}


bp1wave4_hip2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self thread vehicle_delete_after_defend();
	self thread heli_select_death();
	self thread update_wave4_objective();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hip2_spawnpt", "targetname" );
	
	for( i = 1; i < 15; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hip2_goal"+i, "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self SetForceNoCull();
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( i < 14 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		
		self waittill_any( "goal", "near_goal" );
		
		i++;
	}
	
	s_start = getstruct( "bp1wave4_hip2_goal14", "targetname" );
	self thread hip_circle( s_start );
	self thread hip_attack();
}


bp1wave4_btr1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	self thread vehicle_delete_after_defend();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread update_wave4_objective();
}


bp1wave4_btr2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	self thread vehicle_delete_after_defend();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread update_wave4_objective();
}


bp1wave4_hind1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread vehicle_delete_after_defend();
	self thread update_wave4_objective();
	self thread heli_select_death();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hind1_spawnpt", "targetname" );
	
	for( i = 1; i < 23; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hind1_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 19 || i == 20 )
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
		
		if ( i == 20 )
		{
			self thread hind_attack_indefinitely();
			
			wait RandomFloatRange( 5.0, 8.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
		
		i++;
		
		if ( i > 22 )
		{
			i = 10;	
		}
	}
}


bp1wave4_hind2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread vehicle_delete_after_defend();
	self thread update_wave4_objective();
	self thread heli_select_death();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp1wave4_hind2_spawnpt", "targetname" );
	
	for( i = 1; i < 19; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp1wave4_hind2_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetForceNoCull();
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
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


bp1wave4_tank1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::tank_damage;
	
	self thread vehicle_delete_after_defend();
	self thread update_wave4_objective();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	self thread tank_targetting();
	
	self waittill( "reached_end_node" );
	      
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
}


bp1wave4_tank2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::tank_damage;
	
	self thread vehicle_delete_after_defend();
	self thread update_wave4_objective();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	self thread tank_targetting();
	
	self waittill( "reached_end_node" );
	
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
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
	
	flag_set( "bp2wave4_start" );
}


bp2wave4_start_vehicles()
{
	level endon( "blocking_done" );
	
	flag_wait( "bp2wave4_start" );
	
	level thread bp2wave4_boss_chooser();
	//level thread bp2wave4_vehicle_chooser();
	
	wait RandomIntRange( 5, 10 );
	
	level thread bp2wave4_vehicle_chooser();
	//level thread bp2wave4_boss_chooser();
}


bp2wave4_vehicle_chooser()
{
	level endon( "blocking_done" );
	level.n_bp2wave4_vehicles = RandomInt( 3 );
				
	s_hip1_spawnpt = getstruct( "bp2wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp2wave4_hip2_spawnpt", "targetname" );
	s_btr1_spawnpt = getstruct( "wave4bp2_btr1_spawnpt", "targetname" );
	s_btr2_spawnpt = getstruct( "wave4bp2_btr2_spawnpt", "targetname" );
		
	if ( level.n_bp2wave4_vehicles == 0 )
	{
		vh_hip = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip.origin = s_hip1_spawnpt.origin;
		vh_hip.angles = s_hip1_spawnpt.angles;
		vh_hip thread bp2wave4_hip1_behavior();
		vh_hip thread vehicle_delete_after_defend();
		
		vh_hip waittill( "death" );
		
		vh_btr = spawn_vehicle_from_targetname( "btr_soviet" );
		vh_btr.origin = s_btr1_spawnpt.origin;
		vh_btr.angles = s_btr1_spawnpt.angles;
		vh_btr.targetname = "wave4bp2_btr1";
		vh_btr thread wave4bp2_btr1_behavior();
		vh_btr thread vehicle_delete_after_defend();
	}
	
	else if ( level.n_bp2wave4_vehicles == 1 )
	{
		vh_hip1 = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip1.origin = s_hip1_spawnpt.origin;
		vh_hip1.angles = s_hip1_spawnpt.angles;
		vh_hip1 thread bp2wave4_hip1_behavior();
		vh_hip1 thread vehicle_delete_after_defend();
		
		vh_hip1 waittill( "death" );
		
		vh_hip2 = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip2.origin = s_hip2_spawnpt.origin;
		vh_hip2.angles = s_hip2_spawnpt.angles;
		vh_hip2 thread bp2wave4_hip2_behavior();
		vh_hip2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		vh_btr = spawn_vehicle_from_targetname( "btr_soviet" );
		vh_btr.origin = s_btr1_spawnpt.origin;
		vh_btr.angles = s_btr1_spawnpt.angles;
		vh_btr.targetname = "wave4bp2_btr1";
		vh_btr thread wave4bp2_btr1_behavior();
		vh_btr thread vehicle_delete_after_defend();
	
		vh_btr = getent( "wave4bp2_btr1", "targetname" );
		
		if ( IsAlive( vh_btr ) )
		{
			vh_btr waittill( "death" );
			
			vh_btr2 = spawn_vehicle_from_targetname( "btr_soviet" );
			vh_btr2.origin = s_btr2_spawnpt.origin;
			vh_btr2.angles = s_btr2_spawnpt.angles;
			vh_btr2.targetname = "wave4bp2_btr2";
			vh_btr2 thread wave4bp2_btr2_behavior();
			vh_btr2 thread vehicle_delete_after_defend();
		}
		
		else
		{
			vh_btr2 = spawn_vehicle_from_targetname( "btr_soviet" );
			vh_btr2.origin = s_btr2_spawnpt.origin;
			vh_btr2.angles = s_btr2_spawnpt.angles;
			vh_btr2.targetname = "wave4bp2_btr2";
			vh_btr2 thread wave4bp2_btr2_behavior();
			vh_btr2 thread vehicle_delete_after_defend();
		}
	}
}


bp2wave4_hip1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread heli_select_death();
	self thread update_wave4_objective();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_hip1_spawnpt", "targetname" );
	
	for( i = 1; i < 17; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_hip1_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self SetForceNoCull();
	
	self setspeed( 50, 25, 20 );
	
	i = 1;
	
	self.b_rappel_done = false;
	
	while( i < 17 )
	{
		if ( i == 9 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 9 )
		{
			if ( !self.b_rappel_done )	
			{
				self SetSpeedImmediate( 0, 25, 20 );
				wait 3;
				//self bp2wave4_hip1_rappel();
				wait 5;
				self setspeed( 50, 25, 20 );
				self.b_rappel_done = true;
				self thread hip_attack();
			}
		}
				
		i++;
		
		if ( i > 16 )
		{
			i = 10;	
		}
	}
}


bp2wave4_hip1_rappel()
{	
	self endon( "death" );
	level endon( "blocking_done" );
	
	s_rappel_point = spawnstruct();
	s_rappel_point.origin = self.origin + ( AnglesToForward( self.angles ) * 135 ) - ( AnglesToRight( self.angles ) * 55 ) + ( 0, 0, -155 );
	
	sp_rappell = GetEnt( "bp2wave4_hip1_rappel", "targetname" );
	//sp_rappell add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point, true, false );
		
	//spawn_manager_enable( "manager_bp2wave4_hip1_rappel" );
	
	level thread bp2wave4_hip1_rappel_cache();
}


bp2wave4_hip1_rappel_logic()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	vol_cache = GetEnt( "vol_cache7", "targetname" );
	
	self SetGoalVolumeAuto( vol_cache );
}


bp2wave4_hip1_rappel_cache()
{
	flag_wait( "arena_return" );
	
	wait 5;
	
	a_ai_guys = GetEntArray( "bp2wave4_hip1_rappel_ai", "targetname" );
		
	vol_cache = GetEnt( "vol_cache5", "targetname" );
		
	if ( a_ai_guys.size )
	{
		foreach( ai_guy in a_ai_guys )
		{
			if ( IsAlive( ai_guy ) )
			{
				ai_guy ClearGoalVolume();
				ai_guy SetGoalVolumeAuto( vol_cache );
			}
		}
	}
}


bp2wave4_hip1_rappel_arena()
{
	a_ai_guys = GetEntArray( "bp1wave4_hip1_rappel_ai", "targetname" );
	
	vol_arena = GetEnt( "vol_arena", "targetname" );
	
	if ( a_ai_guys.size )
	{
		foreach( ai_guy in a_ai_guys )
		{
			wait RandomFloatRange( 0.5, 2.0 );
			
			if ( IsAlive( ai_guy ) )
			{
				ai_guy ClearGoalVolume();
				ai_guy SetGoalVolumeAuto( vol_arena );
			}
		}
	}
}


bp2wave4_hip2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread heli_select_death();
	self thread update_wave4_objective();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_hip2_spawnpt", "targetname" );
	
	for( i = 1; i < 17; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_hip2_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self SetForceNoCull();
	
	self thread hip_attack();
	
	self setspeed( 50, 25, 20 );
	
	self.b_rappel_done = false;
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 8 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		i++;
		
		if ( i > 16 )
		{
			i = 9;	
		}
	}
}


wave4bp2_btr1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	self thread vehicle_delete_after_defend();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread update_wave4_objective();
	
	nd_start = GetVehicleNode( "wave4bp2_btr1_startnode", "targetname" );
	
	wait 0.5;
	
	self thread go_path( nd_start );
}


wave4bp2_btr2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	self thread vehicle_delete_after_defend();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread update_wave4_objective();
	
	nd_start = GetVehicleNode( "wave4bp2_btr2_startnode", "targetname" );
	
	wait 0.5;
	
	self thread go_path( nd_start );
}


bp2wave4_boss_chooser()
{
	level endon( "blocking_done" );
	
	level.n_bp2wave4_boss = RandomInt( 3 );
			
	if ( level.n_bp2wave4_boss == 0 )
	{
		s_spawnpt = getstruct( "wave4bp2_tank1_spawnpt", "targetname" );
				
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_spawnpt.origin;
		vh_tank1.angles = s_spawnpt.angles;
		vh_tank1 thread wave4bp2_tank1_behavior();
		vh_tank1 thread vehicle_delete_after_defend();
		
		s_hind1_spawnpt = getstruct( "bp2wave4_hind1_spawnpt", "targetname" );
				
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp2wave4_hind1_behavior();
		vh_hind1 thread vehicle_delete_after_defend();
	}
	
	else if ( level.n_bp2wave4_boss == 1 )
	{
		s_hind1_spawnpt = getstruct( "bp2wave4_hind1_spawnpt", "targetname" );
		s_hind2_spawnpt = getstruct( "bp2wave4_hind2_spawnpt", "targetname" );
		
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp2wave4_hind1_behavior();
		vh_hind1 thread vehicle_delete_after_defend();
		
		wait 2;
		
		vh_hind2 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind2.origin = s_hind2_spawnpt.origin;
		vh_hind2.angles = s_hind2_spawnpt.angles;
		vh_hind2 thread bp2wave4_hind2_behavior();
		vh_hind2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		s_spawnpt = getstruct( "wave4bp2_tank1_spawnpt", "targetname" );
				
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_spawnpt.origin;
		vh_tank1.angles = s_spawnpt.angles;
		vh_tank1 thread wave4bp2_tank1_behavior();
		vh_tank1 thread vehicle_delete_after_defend();
		
		wait 5;
		
		s_spawnpt = getstruct( "wave4bp2_tank2_spawnpt", "targetname" );
				
		vh_tank2 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank2.origin = s_spawnpt.origin;
		vh_tank2.angles = s_spawnpt.angles;
		vh_tank2 thread wave4bp2_tank2_behavior();
		vh_tank2 thread vehicle_delete_after_defend();
	}	
}


bp2wave4_hind1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread vehicle_delete_after_defend();
	self thread update_wave4_objective();
	self thread heli_select_death();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_hind1_spawnpt", "targetname" );
	
	for( i = 1; i < 12; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_hind1_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 2 || i == 3 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 2 )
		{
			wait RandomFloatRange( 2.0, 3.0 );
		}
		
		if ( i == 3 )
		{
			self thread hind_attack_indefinitely();
			
			wait RandomFloatRange( 4.0, 6.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
		
		if ( i == 5 )
		{
			self thread hind_attack_base();
		}
		
		if ( i == 6 )
		{
			self notify( "stop_attack" );
		}
		
		if ( i == 9 )
		{
			self setspeed( 200, 50, 25 );
		}
		
		if ( i == 10 )
		{
			self setspeed( 100, 50, 25 );
		}
		
		i++;
		
		if ( i > 11 )
		{
			i = 2;	
		}
	}
}


bp2wave4_hind2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread vehicle_delete_after_defend();
	self thread update_wave4_objective();
	self thread heli_select_death();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp2wave4_hind2_spawnpt", "targetname" );
	
	for( i = 1; i < 12; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp2wave4_hind2_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 2 || i == 3 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 2 )
		{
			wait RandomFloatRange( 2.0, 3.0 );
		}
		
		if ( i == 3 )
		{
			self thread hind_attack_indefinitely();
			
			wait RandomFloatRange( 4.0, 6.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
		
		if ( i == 4 )
		{
			self thread hind_attack_base();
		}
		
		if ( i == 5 )
		{
			self notify( "stop_attack" );
		}
		
		if ( i == 7 )
		{
			self setspeed( 200, 50, 25 );
		}
		
		if ( i == 8 )
		{
			self setspeed( 100, 50, 25 );
		}
		
		i++;
		
		if ( i > 10 )
		{
			i = 2;	
		}
	}
}


hind_attackbase_timer( n_timer )
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	wait n_timer;
	
	self notify( "bp2wave4_hind_attackbase" );
	
	self ClearLookAtEnt();
	self ClearVehGoalPos();
	
	self setspeed( 50, 25, 20 );
	
	s_goal1 = getstruct( "bp2wave4_hind_attackpos", "targetname" );
	
	//level.zhao say_dialog( "zhao_keep_those_helicopte_0" );
	
	self setvehgoalpos( s_goal1.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	
	wait 3;
	
	self thread hind_baseattack();
}


wave4bp2_tank1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	nd_start = GetVehicleNode( "wave4bp2_tank1_startnode", "targetname" );
	
	wait 0.1;
	
	self thread go_path( nd_start );
	
	self.overrideVehicleDamage = ::tank_damage;
	
	self thread update_wave4_objective();
	self thread vehicle_delete_after_defend();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	self thread tank_targetting();
	
	self waittill( "reached_end_node" );
	
	if ( !level.b_tank_warn )
	{
		level.woods thread say_dialog( "wood_watch_the_tanks_0", 0 );  //Watch the tanks!
		
		level.b_tank_warn = true;
	}
	
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
	
	self vehicle_detachfrompath();
	
	self SetBrake( true );
}


wave4bp2_tank2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	nd_start = GetVehicleNode( "wave4bp2_tank2_startnode", "targetname" );
	
	wait 0.1;
	
	self thread go_path( nd_start );
	
	self.overrideVehicleDamage = ::tank_damage;
	
	self thread update_wave4_objective();
	self thread vehicle_delete_after_defend();
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	self thread tank_targetting();
	
	self waittill( "reached_end_node" );
	
	if ( !level.b_tank_warn )
	{
		level.woods thread say_dialog( "wood_watch_the_tanks_0", 0 );  //Watch the tanks!
		
		level.b_tank_warn = true;
	}
	      
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
	
	self vehicle_detachfrompath();
	
	self SetBrake( true );
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
	level endon( "blocking_done" );
	
	flag_wait( "bp3wave4_start" );
	
	level thread bp3wave4_boss_chooser();
	//level thread bp3wave4_vehicle_chooser();
	
	wait RandomIntRange( 5, 10 );
	
	level thread bp3wave4_vehicle_chooser();
	//level thread bp3wave4_boss_chooser();
}


bp3wave4_start_trigger()
{
	level endon( "bp1wave4_start" );
	level endon( "bp2wave4_start" );
	level endon( "bp3wave4_start" );
	
	trigger_wait( "bp3_defense" );
	
	flag_set( "bp3wave4_start" );
}


bp3wave4_vehicle_chooser()
{
	level endon( "blocking_done" );
	level.n_bp3wave4_vehicles = RandomInt( 3 );
					
	s_hip1_spawnpt = getstruct( "bp3wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp3wave4_hip2_spawnpt", "targetname" );
		
	if ( level.n_bp3wave4_vehicles == 0 )
	{
		vh_hip = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip.origin = s_hip1_spawnpt.origin;
		vh_hip.angles = s_hip1_spawnpt.angles;
		vh_hip thread bp3wave4_hip1_behavior();
		vh_hip thread vehicle_delete_after_defend();
		
		vh_hip waittill( "death" );
		
		s_spawnpt = getstruct( "wave4bp3_btr1_spawnpt", "targetname" );
		
		vh_btr1 = spawn_vehicle_from_targetname( "btr_soviet" );
		vh_btr1.origin = s_spawnpt.origin;
		vh_btr1.angles = s_spawnpt.angles;
		vh_btr1 thread wave4bp3_btr1_behavior();
	}
	
	else if ( level.n_bp3wave4_vehicles == 1 )
	{
		vh_hip1 = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip1.origin = s_hip1_spawnpt.origin;
		vh_hip1.angles = s_hip1_spawnpt.angles;
		vh_hip1 thread bp3wave4_hip1_behavior();
		vh_hip1 thread vehicle_delete_after_defend();
		
		//wait 2;
		vh_hip1 waittill( "death" );
		
		vh_hip2 = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip2.origin = s_hip2_spawnpt.origin;
		vh_hip2.angles = s_hip2_spawnpt.angles;
		vh_hip2 thread bp3wave4_hip2_behavior();
		vh_hip2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		s_spawnpt = getstruct( "wave4bp3_btr1_spawnpt", "targetname" );
		
		vh_btr1 = spawn_vehicle_from_targetname( "btr_soviet" );
		vh_btr1.origin = s_spawnpt.origin;
		vh_btr1.angles = s_spawnpt.angles;
		vh_btr1 thread wave4bp3_btr1_behavior();
		
		wait 0.5;
		
		if ( IsAlive( vh_btr1 ) )
		{
			vh_btr1 waittill( "death" );
		}
		
		s_spawnpt = getstruct( "wave4bp3_btr2_spawnpt", "targetname" );
			
		vh_btr2 = spawn_vehicle_from_targetname( "btr_soviet" );
		vh_btr2.origin = s_spawnpt.origin;
		vh_btr2.angles = s_spawnpt.angles;
		vh_btr2 thread wave4bp3_btr2_behavior();
	}
}


bp3wave4_boss_chooser()
{
	level endon( "blocking_done" );
	
	level.n_bp3wave4_boss = RandomInt( 3 );
		
	s_hind1_spawnpt = getstruct( "bp3wave4_hind1_spawnpt", "targetname" );
	s_hind2_spawnpt = getstruct( "bp3wave4_hind2_spawnpt", "targetname" );
	
	if ( level.n_bp3wave4_boss == 0 )
	{
		s_spawnpt = getstruct( "wave4bp3_tank1_spawnpt", "targetname" );
	
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_spawnpt.origin;
		vh_tank1.angles = s_spawnpt.angles;
		vh_tank1 thread wave4bp3_tank1_behavior();
				
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp3wave4_hind1_behavior();
		vh_hind1 thread vehicle_delete_after_defend();
	}
	
	else if ( level.n_bp3wave4_boss == 1 )
	{
		vh_hind1 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind1.origin = s_hind1_spawnpt.origin;
		vh_hind1.angles = s_hind1_spawnpt.angles;
		vh_hind1 thread bp3wave4_hind1_behavior();
		vh_hind1 thread vehicle_delete_after_defend();
		
		wait 5;
		
		vh_hind2 = spawn_vehicle_from_targetname( "hind_soviet" );
		vh_hind2.origin = s_hind2_spawnpt.origin;
		vh_hind2.angles = s_hind2_spawnpt.angles;
		vh_hind2 thread bp3wave4_hind2_behavior();
		vh_hind2 thread vehicle_delete_after_defend();
	}
	
	else
	{
		s_spawnpt = getstruct( "wave4bp3_tank1_spawnpt", "targetname" );
	
		vh_tank1 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank1.origin = s_spawnpt.origin;
		vh_tank1.angles = s_spawnpt.angles;
		vh_tank1 thread wave4bp3_tank1_behavior();
		
		wait 4;
		
		s_spawnpt = getstruct( "wave4bp3_tank2_spawnpt", "targetname" );
	
		vh_tank2 = spawn_vehicle_from_targetname( "tank_soviet" );
		vh_tank2.origin = s_spawnpt.origin;
		vh_tank2.angles = s_spawnpt.angles;
		vh_tank2 thread wave4bp3_tank2_behavior();
	}
}


bp3wave4_hip1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread heli_select_death();
	self thread update_wave4_objective();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hip1_spawnpt", "targetname" );
	
	for( i = 1; i < 14; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hip1_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 200 );
	self SetForceNoCull();
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 6 )
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
		
		if ( i == 6 )
		{
			self SetSpeedImmediate( 0, 25, 20 );
			wait 3;
			//self bp3wave4_hip1_rappel();
			self.b_rappel_done = false;
			wait 5;
			self.b_rappel_done = true;
			self setspeed( 50, 25, 20 );
			
			self thread hip_attack();
		}
		
		i++;
		
		if ( i > 13 )
		{
			i = 7;	
		}
	}
}


//bp3wave4_hip1_rappel()
//{	
//	self endon( "death" );
//	
//	s_rappel_point = spawnstruct();
//	s_rappel_point.origin = self.origin + ( AnglesToForward( self.angles ) * 135 ) - ( AnglesToRight( self.angles ) * 55 ) + ( 0, 0, -155 );
//	
//	sp_rappell = GetEnt( "bp3wave4_hip1_rappel", "targetname" );
//	sp_rappell add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point, true, false );
//		
//	spawn_manager_enable( "manager_bp3wave4_hip1_rappel" );
//	
//	level thread bp3wave4_hip1_rappel_cache();
//}


//bp3wave4_hip1_rappel_logic()
//{
//	self endon( "death" );
//	
//	vol_cache = GetEnt( "vol_cache6", "targetname" );
//	
//	self SetGoalVolumeAuto( vol_cache );
//}


//bp3wave4_hip1_rappel_cache()
//{
//	flag_wait( "arena_return" );
//	
//	wait 5;
//	
//	a_ai_guys = GetEntArray( "bp3wave4_hip1_rappel_ai", "targetname" );
//	
//	vol_cache = GetEnt( "vol_cache2", "targetname" );
//	
//	if ( a_ai_guys.size )
//	{
//		foreach( ai_guy in a_ai_guys )
//		{
//			if ( IsAlive( ai_guy ) )
//			{
//				ai_guy ClearGoalVolume();
//				ai_guy SetGoalVolumeAuto( vol_cache );
//			}
//		}
//	}
//}


//bp3wave4_hip1_rappel_arena()
//{
//	a_ai_guys = GetEntArray( "bp1wave4_hip1_rappel_ai", "targetname" );
//	
//	vol_arena = GetEnt( "vol_arena", "targetname" );
//	
//	if ( a_ai_guys.size )
//	{
//		foreach( ai_guy in a_ai_guys )
//		{
//			wait RandomFloatRange( 0.5, 2.0 );
//			
//			if ( IsAlive( ai_guy ) )
//			{
//				ai_guy ClearGoalVolume();
//				ai_guy SetGoalVolumeAuto( vol_arena );
//			}
//		}
//	}
//}


bp3wave4_hip2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread heli_select_death();
	self thread update_wave4_objective();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hip2_spawnpt", "targetname" );
	
	for( i = 1; i < 14; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hip2_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self SetForceNoCull();
		
	self thread hip_attack();
	
	self setspeed( 50, 25, 20 );
	
	i = 1;
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		
		self waittill_any( "goal", "near_goal" );
		
		i++;
		
		if ( i > 13 )
		{
			i = 7;	
		}
	}
}


wave4bp3_btr1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	self thread go_path( GetVehicleNode( "wave4bp3_btr1_startnode", "targetname" ) );
	
	self thread vehicle_delete_after_defend();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread update_wave4_objective();
}


wave4bp3_btr2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	self thread go_path( GetVehicleNode( "wave4bp3_btr2_startnode", "targetname" ) );
	
	self thread vehicle_delete_after_defend();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread update_wave4_objective();
}


bp3wave4_hind1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self thread update_wave4_objective();
	self thread heli_select_death();
		
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hind1_spawnpt", "targetname" );
	
	for( i = 1; i < 13; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hind1_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 100, 50, 25 );
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 5 || i == 9 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 5 || i == 9 )
		{
			self thread hind_attack_indefinitely();
			
			wait RandomFloatRange( 4.0, 6.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
		
		if ( i == 6 )
		{
			self thread hind_attack_base();
		}
		
		if ( i == 7 )
		{
			self notify( "stop_attack" );
		}
				
		i++;
		
		if ( i > 12 )
		{
			i = 4;	
		}
	}
}


bp3wave4_hind2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	e_base_pos = GetEnt( "base_entrance_pos", "targetname" );
	
	self thread update_wave4_objective();
	self thread heli_select_death();
		
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "bp3wave4_hind2_spawnpt", "targetname" );
	
	for( i = 1; i < 13; i++ )
	{
		a_s_goal[ i ] = getstruct( "bp3wave4_hind2_goal"+i, "targetname" );
	}
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self SetForceNoCull();
	
	self setspeed( 80, 50, 25 );
	
	i = 1;
	
	while( 1 )
	{
		if ( i == 5 || i == 6 || i == 12 )
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 1 );
		}
		
		else
		{
			self setvehgoalpos( a_s_goal[ i ].origin, 0 );
		}
		
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 6 || i == 12 )
		{
			self setLookAtEnt( e_base_pos );
			
			wait 3;
			
			self thread hind_attack_base();
			
			wait RandomFloatRange( 4.0, 6.0 );
			
			self notify( "stop_attack" );
			
			self thread hind_attack_indefinitely();
			
			wait RandomFloatRange( 4.0, 6.0 );
			
			self notify( "stop_attack" );
			
			self ClearLookAtEnt();
		}
				
		i++;
		
		if ( i > 12 )
		{
			i = 5;	
		}
	}
}


wave4bp3_tank1_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::tank_damage;
	
	self thread update_wave4_objective();
	self thread vehicle_delete_after_defend();
	self thread go_path( GetVehicleNode( "wave4bp3_tank1_startnode", "targetname" ) );
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	self thread tank_targetting();

	self waittill( "reached_end_node" );
	
	if ( !level.b_tank_warn )
	{
		level.woods thread say_dialog( "wood_watch_the_tanks_0", 0 );  //Watch the tanks!
		
		level.b_tank_warn = true;
	}
	
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
	
	self vehicle_detachfrompath();
	
	self SetBrake( true );
}


wave4bp3_tank2_behavior()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
	self.overrideVehicleDamage = ::tank_damage;
	
	self thread update_wave4_objective();
	self thread vehicle_delete_after_defend();
	self thread go_path( GetVehicleNode( "wave4bp3_tank2_startnode", "targetname" ) );
	
	//set_objective( level.OBJ_DEFEND_ALL, self, "destroy", -1 );
	
	self thread tank_targetting();
	
	self waittill( "reached_end_node" );
	
	if ( !level.b_tank_warn )
	{
		level.woods thread say_dialog( "wood_watch_the_tanks_0", 0 );  //Watch the tanks!
		
		level.b_tank_warn = true;
	}
	
	self notify( "stop_attack" );
	
	self thread tank_baseattack();
	
	self vehicle_detachfrompath();
	
	self SetBrake( true );
}


wave4_hip_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	level endon( "blocking_done" );
	
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
	level endon( "blocking_done" );
	
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
	level endon( "blocking_done" );
	
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
	level endon( "blocking_done" );
	
	self waittill_any( "goal", "near_goal" );
	
	self enable_turret( 2 );
}


vehicle_delete_after_defend()
{
	flag_wait( "blocking_done" );
	
//	if ( IsDefined( self ) )
//	{
//		VEHICLE_DELETE( self );
//	}
}


horse_follow_player()
{
	self endon( "death" );
	level endon( "blocking_done" );
	
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