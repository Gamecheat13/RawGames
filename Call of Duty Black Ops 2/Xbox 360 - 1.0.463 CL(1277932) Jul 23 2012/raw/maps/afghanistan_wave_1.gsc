#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_objectives;
#include maps\_vehicle;
//#include maps\_ai_rappel;
#include maps\_turret;
#include maps\_vehicle_aianim;
#include maps\_horse;
#include maps\_dialog;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


init_flags()
{
	flag_init( "shoot_hip" );
	flag_init( "kill_uaz" );
	flag_init( "bp1_bombs1" );
	flag_init( "bp1_bombs2" );
	flag_init( "bp1_stop_horse" );
	flag_init( "player_off_horse" );
	flag_init( "goto_town" );
	flag_init( "goto_cache" );
	flag_init( "player_has_rpg" );
	flag_init( "at_plaza" );
	flag_init( "spawn_btr1_bp1" );
	flag_init( "spawn_btr2_bp1" );
	flag_init( "spawn_hip1_bp1" );
	flag_init( "spawn_hip2_bp1" );
	flag_init( "crew_inplace_bp1" );
	flag_init( "crew_gone_bp1" );
	flag_init( "attack_crew_bp1" );
	flag_init( "attack_cache_bp1" );
	flag_init( "cache_destroyed_bp1" );
	flag_init( "ready_to_leave_bp1" );
	flag_init( "zhao_ready_bp1exit" );
	flag_init( "player_onhorse_bp1exit" );
	flag_init( "bp1_exit_done" );
	flag_init( "wave1_started" );
	flag_init( "wave1_done" );
	flag_init( "wave1_complete" );
	flag_init( "leaving_bp1" );
	flag_init( "leaving_bp1_exit" );
	flag_init( "safe_to_explode" );
	flag_init( "dome_exploded" );
	flag_init( "btr_chase_dead" );
	flag_init( "defend_against_btr" );
	flag_init( "started_crater_charge" );
}


init_spawn_funcs()
{
	add_spawn_function_group( "bp1_roof_jumper", "targetname", ::roof_jumper_logic );
	add_spawn_function_group( "bp1_initial_guard", "targetname", ::victim_bp1_logic );
	add_spawn_function_group( "bp1_initial_sniper", "targetname", ::fixed_bp1_logic );
	add_spawn_function_group( "bp1_initial_troops", "targetname", ::initial_bp1_logic );
	add_spawn_function_group( "bp1_reinforce", "targetname", ::reinforce_bp1_logic );
	add_spawn_function_group( "bp1_assault_troops", "targetname", ::assault_bp1_logic );
	add_spawn_function_group( "bp1_cache_guard1", "targetname", ::fixed_bp1_logic );
	add_spawn_function_group( "bp1_cache_guard2", "targetname", ::fixed_bp1_logic );
	add_spawn_function_group( "bp1_tower_rooftop", "targetname", ::bp1_rooftop_logic );
	add_spawn_function_group( "bp1_tower_diver", "targetname", ::fixed_bp1_logic );
	add_spawn_function_group( "bp1_hip1_rappel", "targetname", ::bp1_rappel_logic );
	add_spawn_function_group( "bp1_last_troops", "targetname", ::reinforce_bp1_logic );
	add_spawn_function_group( "soviet_cache5", "targetname", ::arena_crosser_logic );
	
	add_spawn_function_group( "muj_initial_bp1", "targetname", ::defend_bp1_logic );
	add_spawn_function_group( "muj_defend_bp1", "targetname", ::defend_bp1_logic );
	add_spawn_function_group( "muj_bp1_advance", "targetname", ::defend_bp1_logic );
	add_spawn_function_group( "bp1_muj_exit", "targetname", ::bp1_muj_exit_logic );
}


init_level_setup()
{	
	level.zhao_horse veh_magic_bullet_shield( true );
	level.zhao magic_bullet_shield();
	
	level.n_bp1wave1_soviet_killed = 0;
	level.b_plant_stairs = false;
	
	m_cratercharge_glow = GetEnt( "crater_charge_explosive_glow", "targetname" );
	m_cratercharge_glow Hide();
	
	level clientnotify( "dbw1" );
}


skipto_wave1()
{
	skipto_setup();
	
	init_hero( "zhao" );
	init_hero( "woods" );
	
	skipto_teleport( "skipto_wave1", level.heroes );
	
	t_chase = GetEnt( "trigger_uaz_chase", "targetname" );
	t_chase trigger_on();
	
	//level.player GiveWeapon( "sticky_grenade_afghan_sp" );
	//level.player GiveMaxAmmo( "sticky_grenade_afghan_sp" );
	
	level thread maps\_horse::set_horse_in_combat( true );
	
	level.zhao = getent( "zhao_ai", "targetname" );
	level.woods = getent( "woods_ai", "targetname" );
	
	remove_woods_facemask_util();
	
	s_player_horse_spawnpt = getstruct( "wave1_player_horse_spawnpt", "targetname" );
	s_zhao_horse_spawnpt = getstruct( "wave1_zhao_horse_spawnpt", "targetname" );
	s_woods_horse_spawnpt = getstruct( "wave1_woods_horse_spawnpt", "targetname" );
	
	level.zhao_horse = spawn_vehicle_from_targetname( "zhao_horse" );
	level.zhao_horse.origin = s_zhao_horse_spawnpt.origin;
	level.zhao_horse.angles = s_zhao_horse_spawnpt.angles;
	
	level.woods_horse = spawn_vehicle_from_targetname( "woods_horse" );
	level.woods_horse.origin = s_woods_horse_spawnpt.origin;
	level.woods_horse.angles = s_woods_horse_spawnpt.angles;
	
	level.mason_horse = spawn_vehicle_from_targetname( "mason_horse" );
	level.mason_horse.origin = s_player_horse_spawnpt.origin;
	level.mason_horse.angles = s_player_horse_spawnpt.angles;
	
	level.woods_horse MakeVehicleUnusable();
	level.zhao_horse MakeVehicleUnusable();
	level.mason_horse MakeVehicleUsable();
	
	level.woods_horse veh_magic_bullet_shield( true );
	level.zhao_horse veh_magic_bullet_shield( true );
	level.mason_horse veh_magic_bullet_shield( true );
		
	wait 0.1;
	
	level.woods enter_vehicle( level.woods_horse );
	level.zhao enter_vehicle( level.zhao_horse );
	
	//Setting the battle snapshot (audio)
	level clientnotify ("abs_1");
	
	wait 0.05;
	
	level.woods_horse notify( "groupedanimevent", "ride" );
	level.zhao_horse notify( "groupedanimevent", "ride" );
	
	level.woods maps\_horse_rider::ride_and_shoot( level.woods_horse );	
	level.zhao maps\_horse_rider::ride_and_shoot( level.zhao_horse );
		
	level clientnotify( "dbw1" );
	
	level.woods_horse thread woods_skipto_wave1();
	level.zhao_horse thread zhao_skipto_wave1();
		
	set_objective( level.OBJ_AFGHAN_BP1, level.zhao, "follow" );
	
	flag_wait( "afghanistan_gump_arena" );
}


uaz3_arena_skipto_logic()
{
	self endon( "death" );
	
	self thread delete_corpse_arena();
	
	s_goal = getstruct( "uaz3_goal", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetSpeed( 25, 15, 10 );
	
	self SetVehGoalPos( s_goal.origin, 0, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self notify( "unload" );
}


zhao_skipto_wave1()
{
	level.mason_horse waittill( "enter_vehicle", player );
	
	s_zhao_bp1 = getstruct( "zhao_bp1_goal", "targetname" );
	
	//self SetVehicleAvoidance( true );
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetSpeed( 25, 15, 10 );
	self SetVehGoalPos( s_zhao_bp1.origin, 1, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self SetSpeedImmediate( 0 );
	
	flag_set( "zhao_at_bp1" );
	
	s_zhao_bp1 = undefined;
}


woods_skipto_wave1()
{
	level.mason_horse waittill( "enter_vehicle", player );
	
	wait 1;
	
	s_woods_bp1 = getstruct( "woods_bp1_goal", "targetname" );
	
	//self SetVehicleAvoidance( true );
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetSpeed( 25, 15, 10 );
	self SetVehGoalPos( s_woods_bp1.origin, 1, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	self SetSpeedImmediate( 0 );
	
	flag_set( "woods_at_bp1" );
	
	s_woods_bp1 = undefined;
}


main()
{
	/#
		IPrintLn( "Wave 1" );
	#/
		
	maps\createart\afghanistan_art::open_area();
		
	init_spawn_funcs();
	init_level_setup();
	bp1_vehicle_chooser();
	wave1();
	
	flag_wait( "wave1_complete" );
	flag_wait( "bp1_exit_done" );
}


wave1()
{
	level.woods_horse ent_flag_init( "btr_chase_over" );
	
	level thread objectives_zhao_bp1();
	level thread objectives_bp1();
	
	if (  level.skipto_point == "wave_1" )
	{
		maps\afghanistan_anim::init_afghan_anims_part1b();
		delete_section1_scenes();
		delete_section3_scenes();
	}
	
	level.n_current_wave = 1;
	level.n_bp1_veh_destroyed = 0;
	
	level.zhao_horse thread zhao_wave1_bp1();
	level.woods_horse thread woods_wave1_bp1();
	level.mason_horse thread player_horse_behavior();
	
	level thread spawn_chase_truck();
	level thread spawn_bp1_horses();
	level thread vo_approach_bp1();
	
	trigger_wait( "spawn_bp1" );
	
	spawn_manager_kill( "manager_troops_exit" );
	spawn_manager_kill( "manager_hip3_troops" );
	
	t_chase = GetEnt( "trigger_uaz_chase", "targetname" );
	t_chase Delete();
	
	t_cache_guard = GetEnt( "trigger_firehorse_cache_guard", "targetname" );
	t_cache_guard Delete();
	
	flag_set( "wave1_started" );
	
	level thread vo_enter_bp1();
	level thread vo_engagement_bp1();
	level thread vo_vehicles_bp1();
	level thread vo_done_bp1();
	level thread vo_explosive_bp1();
		
	level thread check_player_has_rpg();
	level thread spawn_muj_defenders();
	level thread spawn_mig_intro();
	level thread bp1_entrance_explosions();
	level thread mig_bomb_entrance();
	level thread bp1_replenish_arena();
	level thread spawn_mig_tower();
	
	autosave_by_name( "blocking_point1" );
	
	cleanup_arena();
			
	sp_guard = GetEnt( "bp1_initial_guard", "targetname" );
	ai_guard = sp_guard spawn_ai( true );
	
	wait 0.1;
	
	level thread monitor_enemy_bp1();
	level thread bp1_crew_spawn();
			
	flag_wait( "wave1_complete" );
	
	level thread struct_cleanup_firehorse();
}


check_player_has_rpg()
{
	level endon( "player_has_rpg" );
	
	while( 1 )
	{
		a_weapons = level.player GetWeaponsList();
		
		for( i = 0; i < a_weapons.size; i++ )
		{
			str_class = WeaponClass( a_weapons[ i ] );
			
			if ( str_class == "rocketlauncher" )
			{
				flag_set( "player_has_rpg" );
			}
		}
		
		wait 1;
	}
}


objectives_zhao_bp1()
{
	flag_wait( "goto_cache" );
	
	if ( !flag( "player_has_rpg" ) )
	{
		s_rpg = getstruct( "rpg_pos1", "targetname" );
		
		set_objective( level.OBJ_AFGHAN_BP1, s_rpg, "use" );
	}
	
	while( !flag( "player_has_rpg" ) )
	{
		wait 0.1;	
	}
	
	set_objective( level.OBJ_AFGHAN_BP1, s_rpg, "remove" );
	
	flag_wait( "wave1_done" );
		
	set_objective( level.OBJ_AFGHAN_BP1, undefined, "done" );
}


objectives_bp1()
{
	flag_wait( "spawn_vehicles_bp1" );
	
	set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, undefined, undefined, level.n_bp1_veh_destroyed );
	
	flag_wait( "wave1_done" );
		
	m_cratercharge_glow = GetEnt( "crater_charge_explosive_glow", "targetname" );
	m_cratercharge_glow Show();
	
	set_objective( level.OBJ_DESTROY_DOME, m_cratercharge_glow, "breadcrumb" );
	
	level thread plant_explosive_dome();
	level thread monitor_crater_charge();
	
	flag_wait( "started_crater_charge" );
    
	if ( level.b_plant_stairs )
	{
		scene_wait( "plant_explosive_dome_stairs" );
	}
				
	else
	{
		scene_wait( "plant_explosive_dome" );
	}
	
	set_objective( level.OBJ_DESTROY_DOME, m_cratercharge_glow, "remove" );
	
	s_detonate_point = getstruct( "detonate_safe_point", "targetname" );
	
	set_objective( level.OBJ_DESTROY_DOME, s_detonate_point, "breadcrumb" );
	
	level thread vo_nag_safe_distance();
	
	flag_wait( "dome_exploded" );
	
	set_objective( level.OBJ_DESTROY_DOME, undefined, "done" );
	set_objective( level.OBJ_DESTROY_DOME, undefined, "delete" );
	
	flag_wait( "ready_to_leave_bp1" );
	
	set_objective( level.OBJ_FOLLOW_BP1, level.mason_horse, "use" );
		
	flag_wait( "player_onhorse_bp1exit" );
	
	set_objective( level.OBJ_FOLLOW_BP1, level.mason_horse, "remove" );
	
	set_objective( level.OBJ_FOLLOW_BP1, level.zhao, "follow" );
	
	trigger_wait( "bp1_exit_battle" );
		
	set_objective( level.OBJ_FOLLOW_BP1, level.zhao, "remove" );
	
	set_objective( level.OBJ_DEFEND_CACHE1, getstruct( "bp1_obj_marker2", "targetname" ).origin, "protect" );
	
	flag_wait( "bp1_exit_done" );
	
	set_objective( level.OBJ_DEFEND_CACHE1, undefined, "done" );
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		if ( !level.player is_on_horseback() )
		{
			set_objective( level.OBJ_AFGHAN_BP2, level.mason_horse, "use" );
		
			level.mason_horse waittill( "enter_vehicle", player );
		}
		
		set_objective( level.OBJ_AFGHAN_BP2, level.zhao, "follow" );
	}
	
	else
	{
		if ( !level.player is_on_horseback() )
		{
			set_objective( level.OBJ_AFGHAN_BP3, level.mason_horse, "use" );
		
			level.mason_horse waittill( "enter_vehicle", player );
		}
		
		set_objective( level.OBJ_AFGHAN_BP3, level.zhao, "follow" );
	}
}


spawn_chase_truck()
{
	trigger_wait( "trigger_uaz_chase" );
	
	s_spawnpt = getstruct( "chase_truck_spawnpt", "targetname" );
	
	nd_start = GetVehicleNode( "node_start_chase_truck", "targetname" );
	
	vh_truck = spawn_vehicle_from_targetname( "truck_afghan" );
	vh_truck.origin = s_spawnpt.origin;
	vh_truck.angles = s_spawnpt.angles;
	vh_truck thread chase_truck_logic();
	
	sp_rider = GetEnt( "muj_assault", "targetname" );
	
	ai_rider1 = sp_rider spawn_ai( true );
	ai_rider1.script_startingposition = 0;
	ai_rider1 enter_vehicle( vh_truck );
	
	ai_rider2 = sp_rider spawn_ai( true );
	ai_rider2.script_startingposition = 2;
	ai_rider2 enter_vehicle( vh_truck );
	
	wait 0.1;
	
	vh_truck thread go_path( nd_start );
}


chase_truck_logic()
{
	self endon( "death" );
	
	//TODO - replace corpse with script model
	self thread delete_corpse_bp1();
	self thread destroy_chase_truck_end();
	self thread spawn_chopper_victim();
	
	level thread uaz_arena_chase_horse();
	
	flag_wait( "kill_uaz" );
	
	self thread destroy_chase_truck();
}


spawn_chopper_victim()
{
	self endon( "death" );
	
	s_spawnpt = getstruct( "chopper_victim_spawnpt", "targetname" );
	
	vh_hip = spawn_vehicle_from_targetname( "hip_soviet" );
	wait 0.1;
	vh_hip.origin = s_spawnpt.origin;
	vh_hip.angles = s_spawnpt.angles;
	
	vh_hip thread chopper_victim_logic();
	
	flag_wait( "shoot_hip" );
	
	if ( IsAlive( vh_hip ) )
	{
		self set_turret_target( vh_hip, ( 0, -100, -32 ), 1 );
		self shoot_turret_at_target( vh_hip, 7, ( 0, 0, 0 ), 1 );
	}
}


chopper_victim_logic()
{
	self endon( "death" );
	
	self thread speed_up_crash();
	self thread heli_select_death();
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	
	s_goal0 = getstruct( "chopper_victim_goal0", "targetname" );
	s_goal1 = getstruct( "chopper_victim_goal1", "targetname" );
	s_goal2 = getstruct( "chopper_victim_goal2", "targetname" );
	s_goal3 = getstruct( "chopper_victim_goal3", "targetname" );
	s_goal4 = getstruct( "chopper_victim_goal4", "targetname" );
	s_goal5 = getstruct( "chopper_victim_goal5", "targetname" );
	
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 100, 50, 40 );
	
	self setvehgoalpos( s_goal0.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	flag_set( "shoot_hip" );
	
	self setvehgoalpos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self setvehgoalpos( s_goal5.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


speed_up_crash()
{
	self waittill( "death" );
	
	self SetSpeedImmediate( 150 );
}


destroy_chase_truck()
{
	self vehicle_detachfrompath();
	
	self LaunchVehicle( ( 0, 0, 300 ), ( AnglesToForward( self.angles ) * 180 ), true, 1 );
	
	play_fx( "truck_dmg", self.origin, self.angles, undefined, true, "tag_origin" );
	
	self PlaySound("evt_truck_flip");
	
	ai_gunner = GetEnt( "uaz_chase_shooter_ai", "targetname" );
	
	if ( IsAlive( ai_gunner ) )
	{
		ai_gunner die();
	}
	
	wait 1;
	
	RadiusDamage( self.origin, 100, 5000, 4000 );
	
	self StopSound("evt_truck_flip");
	
	self SetBrake( true );
}


destroy_chase_truck_end()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	
	self.exp_pos = ( AnglesToForward( self.angles ) * 100 );
	
	PlayFX( level._effect[ "explode_mortar_sand" ], self.exp_pos );
	
	PlaySoundAtPosition( "exp_mortar", self.exp_pos );
	
	Earthquake( 0.5, 1, self.exp_pos, 2000 );
	
	level.player PlayRumbleOnEntity( "artillery_rumble" );
		
	level thread check_explosion_radius( self.exp_pos );

	self thread destroy_chase_truck();
}


uaz_arena_chase_horse()
{
	s_spawnpt = getstruct( "uaz_chase_horse_spawnpt", "targetname" );
	
	vh_horses = [];
	
	for ( i = 0; i < 2; i++ )
	{
		vh_horses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		wait 0.1;
		vh_horses[ i ].origin = s_spawnpt.origin;
		vh_horses[ i ].angles = s_spawnpt.angles;
		
		s_goal = getstruct( "uaz_chase_horse_goal" +i, "targetname" );
		
		sp_rider = GetEnt( "muj_assault", "targetname" );
		vh_horses[ i ].rider = sp_rider spawn_ai( true );
				
		vh_horses[ i ] thread uaz_arena_chase_horse_behavior( vh_horses[ i ].rider, s_goal );
		
		if ( i == 0 )
		{
			 vh_horses[ i ] PathFixedOffset( (0, -100, 0) );
		}
		
		else
		{
			vh_horses[ i ] PathFixedOffset( (0, 100, 0) );
		}
		
		wait 0.3;
	}
		
	flag_wait( "wave2_started" );
	
	for ( i = 0; i < 2; i++ )
	{
		if ( IsDefined( vh_horses[ i ] ) )
		{
			VEHICLE_DELETE( vh_horses[ i ] );
		}
	}
	
	vh_horses = undefined;
}


uaz_arena_chase_horse_behavior( ai_rider, s_goal )  //self = ai horse
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 300 );
	self MakeVehicleUnusable();
	self SetSpeedImmediate( 25 );
	
	if ( IsAlive( ai_rider ) )
	{
		ai_rider enter_vehicle( self );
		ai_rider.vh_horse = self;
		ai_rider.horse_defender = true;
	}
	
	wait 0.1;
		
	self notify( "groupedanimevent", "ride" );
	
	if ( IsAlive( ai_rider ) )
	{
		ai_rider maps\_horse_rider::ride_and_shoot( self );
	}
	
	self setvehgoalpos( s_goal.origin, 1, 1 );
	self waittill_any( "goal", "near_goal" );	
	
	wait 1;
	
	if ( IsAlive( ai_rider ) )
	{
		ai_rider notify( "stop_riding" );
	}
	
	self vehicle_unload( 0.1 );
	self SetVehicleAvoidance( true );
	
	if ( IsAlive( ai_rider ) )
	{
		ai_rider thread defend_bp1_logic();
	}
	
	self MakeVehicleUnusable();
	
	wait 3;
	
	self thread bp1_horse_runaway();
}


spawn_bp1_horses()
{
	level endon( "wave1_started" );
	
	trigger_wait( "trigger_bp1_horses" );
	
	level thread vo_horse_riders_bp1();
	
	s_spawnpt = getstruct( "bp1_horse_spawnpt", "targetname" );
	
	vh_horses = [];
	
	n_offset = 0;
	
	for ( i = 0; i < 4; i++ )
	{
		vh_horses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		wait 0.1;
		vh_horses[ i ].origin = s_spawnpt.origin;
		vh_horses[ i ].angles = s_spawnpt.angles;
		vh_horses[ i ] PathFixedOffset( (0, i + n_offset, 0) );
		
		sp_rider = GetEnt( "muj_assault", "targetname" );
		ai_rider = sp_rider spawn_ai( true );
		ai_rider thread defend_bp1_logic();
		
		vh_horses[ i ] thread bp1_horse_behavior( ai_rider );
		
		wait 0.4;
		
		if ( cointoss() )
		{
			n_offset += 100;
		}
		
		else
		{
			n_offset -= 100;
		}
	}
	
	vh_horses = undefined;
}


vo_horse_riders_bp1()
{
	wait 3;
	
	level.zhao say_dialog( "muj0_hiyeeah_0", 0 );		//Hiyeeah!
	
	level.zhao say_dialog( "muj0_battle_cry_0", 2 );	//Battle cry
	
	flag_wait( "bp1_bombs1" );
	
	//level.zhao say_dialog( "muj0_screaming_0", 1 );	//Screaming
}


bp1_horse_behavior( ai_rider )
{
	self endon( "death" );
	
	ai_rider enter_vehicle( self );
	ai_rider.vh_horse = self;
	
	wait 0.1;
	
	self notify( "groupedanimevent", "ride" );
	
	ai_rider maps\_horse_rider::ride_and_shoot( self );
	
	s_start = getstruct( "bp1_horse_goal1", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	self SetSpeed( 22, 15, 10 );
	
	self SetVehGoalPos( s_start.origin, 0, true );
	self waittill_any( "goal", "near_goal" );
	
	s_next = getstruct( s_start.target, "targetname" );
	
	while( 1 )
	{
		if ( !IsDefined( s_next.target ) )
		{
			v_goal = s_next.origin + ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), 0 );
		}
		
		else
		{
			v_goal = s_next.origin;	
		}
		
		self SetVehGoalPos( v_goal, 0, true );
		self waittill_any( "goal", "near_goal" );
		
		if ( IsDefined( s_next.target ) )
		{
			s_next = getstruct( s_next.target, "targetname" );
		}
		
		else
		{
			break;	
		}
	}
	
	self SetBrake( true );
	
	if ( IsAlive( ai_rider ) )
	{
		ai_rider notify( "stop_riding" );
	
		self vehicle_unload( 0.1 );
	
		self waittill( "unloaded" );
	}
	
	self MakeVehicleUnusable();
	
	self SetVehicleAvoidance( true );
	
	wait 2;
	
	self thread bp1_horse_runaway();
}


plant_explosive_dome()
{	
	while ( !flag( "dome_exploded" ) )
	{
		trigger_wait( "trigger_dome_explosive" );
		
		t_explosive = GetEnt( "trigger_dome_explosive", "targetname" );
		m_cratercharge = GetEnt( "crater_charge_explosive", "targetname" );
		m_cratercharge_glow = GetEnt( "crater_charge_explosive_glow", "targetname" );
			
		while( level.player IsTouching( t_explosive ) )
		{
			screen_message_create( &"AFGHANISTAN_BP1_PLACE_CRATER_CHARGE" );
				
			if ( level.player UseButtonPressed() )
			{
				screen_message_delete();
				
				angles = level.player GetPlayerAngles();
								
				if ( angles[ 1 ]  > -90 && angles[ 1 ] < 90 )
				{
					level thread run_scene( "plant_explosive_dome" );
				}
				
				else
				{
					level thread run_scene( "plant_explosive_dome_stairs" );	
					level.b_plant_stairs = true;
				}
			
				wait 0.2;
				
				flag_set( "started_crater_charge" );
				
				level.woods thread check_friends_positions( getstruct( "teleport_woods_pos", "targetname" ) );
				level.zhao thread check_friends_positions( getstruct( "teleport_zhao_pos", "targetname" ) );
				
				m_cratercharge_glow Delete();
				m_cratercharge Show();
				
				if ( level.b_plant_stairs )
				{
					scene_wait( "plant_explosive_dome_stairs" );
				}
				
				else
				{
					scene_wait( "plant_explosive_dome" );
				}
				
				trigger_use( "triggercolor_leavetown" );
				
				autosave_by_name( "charge_planted" );
				
				m_cratercharge thread playfx_blinking_light();
				
				level.player thread explosion_safe_distance( m_cratercharge );
				
				level.player SetLowReady( true );
				
				currentweapon = level.player GetCurrentWeapon();
				
				level.player GiveWeapon( "satchel_charge_sp" );
				level.player SwitchToWeapon( "satchel_charge_sp" );
				level.player SetWeaponAmmoClip( "satchel_charge_sp", 0 );
				level.player SetWeaponAmmoStock( "satchel_charge_sp", 0 );
				level.player DisableWeaponCycling();
				level.player DisableOffhandWeapons();
				level.player thread disable_mines_at_dome();
				
				level thread bp1_hips_flyby();
				
				flag_wait( "safe_to_explode" );
			
				while( 1 )
				{
					if ( level.player GetCurrentWeapon() == "satchel_charge_sp" && level.player AttackButtonPressed() )
					{
						flag_set( "dome_exploded" );
						
						level.player playsound( "wpn_c4_activate_plr" );
						
						screen_message_delete();
						
						wait 0.1;
						
						m_cratercharge Delete();
						
						s_explode = getstruct ( "explosion_struct", "targetname" );
						
						exploder( 600 );
						
						PlaySoundAtPosition( "wpn_c4_explode", s_explode.origin );
						Earthquake( 0.5, 2.5, level.player.origin, 4000 );
						RadiusDamage( s_explode.origin, 1000, 5000, 5000, undefined, "MOD_PROJECTILE" );
						level.player PlayRumbleOnEntity( "artillery_rumble" );
						
						level notify( "fxanim_archway_collapse_start" );
						
						level thread check_player_position();
						level thread show_dome_destruction();
						level thread delete_dome();
												
						//TUEY Set music to RIDE_TO_FIGHT_TWO
						setmusicstate ("RIDE_TO_FIGHT_TWO");
						
						wait 2;
						
						level.player TakeWeapon( "satchel_charge_sp" );
						level.player EnableWeaponCycling();
						level.player EnableOffhandWeapons();
						level.player SwitchToWeapon( currentweapon );
						
						flag_set( "wave1_complete" );
						
						autosave_by_name( "dome_destroyed" );
						
						cleanup_bp_ai();
						respawn_arena();
							
						break;
					}
				
					wait 0.05;
				}
			
				break;
			}
		
			wait 0.05;
		}
		
		screen_message_delete();
	}
}


monitor_crater_charge()
{
	level endon( "dome_exploded" );
	
	trigger_wait( "trigger_check_cratercharge" );
	
	if ( !flag( "dome_exploded" ) )
	{
		missionfailedwrapper( &"AFGHANISTAN_OBJECTIVE_FAIL" );	
	}
}


check_friends_positions( s_pos )
{
	if (	Distance2DSquared( level.player.origin, self.origin ) > ( 400 * 400 ) )
	{
		self clear_force_color();
		
		wait 1;
		
		self Teleport( s_pos.origin, s_pos.angles );
		
		wait 1;
		
		self set_force_color( "r" );
	}
}


crater_charge_fx1( guy )
{
	PlayFXOnTag( level._effect[ "crater_charge_bury" ], GetEnt( "crater_charge_explosive", "targetname" ), "tag_origin" );
}


crater_charge_fx2( guy )
{
	PlayFXOnTag( level._effect[ "crater_charge_bury" ], GetEnt( "crater_charge_explosive", "targetname" ), "tag_origin" );
}


crater_charge_fx3( guy )
{
	PlayFXOnTag( level._effect[ "crater_charge_bury" ], GetEnt( "crater_charge_explosive", "targetname" ), "tag_origin" );
}


crater_charge_fx4( guy )
{
	PlayFXOnTag( level._effect[ "crater_charge_bury" ], GetEnt( "crater_charge_explosive", "targetname" ), "tag_origin" );
}


crater_charge_fx5( guy )
{
	PlayFXOnTag( level._effect[ "crater_charge_bury" ], GetEnt( "crater_charge_explosive", "targetname" ), "tag_origin" );
}


playfx_blinking_light()
{
	e_tag = spawn( "script_model", self.origin );
	e_tag SetModel( "tag_origin" );
	
	while( !flag( "dome_exploded" ) )
	{
		PlayFXOnTag( level._effect[ "cratercharge_light" ], e_tag, "tag_origin" );
		
		wait 0.25;
	}
	
	e_tag Delete();
}


disable_mines_at_dome()
{
	if ( self HasWeapon( "tc6_mine_sp" ) )
	{
		self SetActionSlot( 1, "" );		
		flag_wait( "wave1_complete" );		
		self SetActionSlot( 1, "weapon", "tc6_mine_sp" );
	}		
}


check_player_position()
{
	if ( level.player.origin[ 0 ] > 4100 )
	{
		level.woods thread say_dialog( "wood_come_on_0" );
		
		MissionFailed();
	}
	
	else if ( level.woods.origin [ 0 ] > 4100 || level.zhao.origin [ 0 ] > 4100 )
	{
		missionfailedwrapper( &"AFGHANISTAN_C4_FAIL" );
	}
}


show_dome_destruction()
{
	a_m_destroyed_dome = GetEntArray( "archway_destroyed_static", "targetname" );
	m_destroyed_dome_clip = GetEnt( "archway_destroyed_static_clip", "targetname" );
						
	foreach( m_dest in a_m_destroyed_dome )
	{
		m_dest Show();
	}
						
	m_destroyed_dome_clip MoveZ( 2080, 0.1 );
	m_destroyed_dome_clip waittill( "movedone" );
	m_destroyed_dome_clip DisconnectPaths();
}


delete_dome()
{
	a_m_dome = GetEntArray( "dome_pristine", "targetname" );
						
	foreach( m_dome in a_m_dome )
	{
		m_dome Delete();
	}
}


explosion_safe_distance( m_cratercharge )  //self = level.player
{
	self endon( "death" );
	
	while( ( Distance2DSquared( self.origin, m_cratercharge.origin ) < ( 1000 * 1000 ) ) || ( level.woods.origin[ 0 ] > 4100 ) || ( level.zhao.origin[ 0 ] > 4100 ) || ( self.origin[ 0 ] > 4100 ) )
	{
		wait 0.1;
	}
	
	level.woods thread say_dialog( "wood_blow_it_mason_0", 0 );  //Blow it, Mason.
	
	level thread nag_blow_it();
	
	level.player SetLowReady( false );
	
	screen_message_create( &"AFGHANISTAN_BP1_FIRE_CRATER_CHARGE" );
	
	flag_set( "safe_to_explode" );
}


nag_blow_it()
{
	level endon( "dome_exploded" );
	
	wait 8;
	
	n_nag = 0;
	
	while( 1 )
	{
		level.woods say_dialog( "wood_blow_it_mason_0", 0 );  //Blow it, Mason.
		
		wait 8;
		
		n_nag++;
		
		wait 8;
		
		level.woods say_dialog( "wood_blow_it_make_sure_0", 0 );  //Blow it - Make sure no more vehicles come through.
		
		n_nag++;
		
		wait 8;
		
		if ( n_nag > 5 )
		{
			missionfailedwrapper( &"AFGHANISTAN_OBJECTIVE_FAIL" );	
		}
	}
}


spawn_muj_defenders()
{
	sp_defender = GetEnt( "muj_initial_bp1", "targetname" );
	
	for ( i = 0; i < 3; i++ )
	{
		sp_defender spawn_ai( true );
		
		wait 0.1;
	}
	
	waittill_ai_group_count( "group_bp1_initial", 3 );
	
	spawn_manager_enable( "manager_muj_bp1" );
}


spawn_mig_intro()
{
	s_spawnpt = getstruct( "bp1_mig_spawnpt", "targetname" );
		
	vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
	wait 0.1;
	vh_mig.origin = s_spawnpt.origin;
	vh_mig.angles = s_spawnpt.angles;
	
	vh_mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	vh_mig thread bp1_mig_intro();
	
	s_spawnpt = undefined;
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
	
	self setvehgoalpos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	s_goal1 = undefined;
	s_goal2 = undefined;
	
	VEHICLE_DELETE( self );
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
		if ( i == 3 )
		{
			flag_set( "kill_uaz" );
		}
		
		PlayFX( level._effect[ "explode_mortar_sand" ], a_s_explosions[ i ].origin );
		PlaySoundAtPosition( "exp_mortar", a_s_explosions[ i ].origin );
		Earthquake( 0.5, 1, a_s_explosions[ i ].origin, 2000 );
		level.player PlayRumbleOnEntity( "artillery_rumble" );
		
		level thread check_explosion_radius( a_s_explosions[ i ].origin );
		
		if ( i == 3 )
		{
			flag_set( "bp1_bombs1" );
		}
		
		else if ( i == 4 )
		{
			flag_set( "bp1_bombs2" );
		}
		
		wait 1;
	}
	
	a_s_explosions = undefined;
}


mig_bomb_entrance()
{
	flag_wait( "enter_bp1" );
	
	s_spawnpt = getstruct( "bp1_mig2_spawnpt", "targetname" );
		
	vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
	wait 0.1;
	vh_mig.origin = s_spawnpt.origin;
	vh_mig.angles = s_spawnpt.angles;
	
	vh_mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	s_spawnpt = undefined;
	
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
	
	s_goal1 = undefined;
	s_goal2 = undefined;
	
	VEHICLE_DELETE( self );
}


bp1_mig2_bombs()
{
	s_bomb1 = getstruct( "bp1_mig2_exp1", "targetname" );
	s_bomb2 = getstruct( "bp1_mig2_exp2", "targetname" );
	
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb1.origin );
	PlaySoundAtPosition( "exp_mortar", s_bomb1.origin );
	Earthquake( 0.5, 1, s_bomb1.origin, 2000 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	RadiusDamage( s_bomb1.origin, 300, 120, 100, undefined, "MOD_PROJECTILE" );
	
	wait 1;
	
	flag_set( "bp1_stop_horse" );
	
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb2.origin );
	PlaySoundAtPosition( "exp_mortar", s_bomb2.origin );
	Earthquake( 0.5, 1, s_bomb2.origin, 2000 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	RadiusDamage( s_bomb2.origin, 300, 120, 100, undefined, "MOD_PROJECTILE" );
	
	s_bomb1 = undefined;
	s_bomb2 = undefined;
}


spawn_mig_tower()
{
	flag_wait( "tower_fall" );
	
	s_spawnpt = getstruct( "mig_tower_spawnpt", "targetname" );
		
	vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
	vh_mig.origin = s_spawnpt.origin;
	vh_mig.angles = s_spawnpt.angles;
	
	vh_mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	s_spawnpt = undefined;
	
	vh_mig thread mig_destroy_tower();
	
	//TODO
	//level notify( "fxanim_village_tower_start" );
}
	
	
mig_destroy_tower()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "mig_tower_goal1", "targetname" );
	s_goal2 = getstruct( "mig_tower_goal2", "targetname" );
	s_goal3 = getstruct( "mig_tower_goal3", "targetname" );
	s_goal4 = getstruct( "mig_tower_goal4", "targetname" );
	
	self veh_magic_bullet_shield( true );
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
		
	s_goal1 = undefined;
	s_goal2 = undefined;
	s_goal3 = undefined;
	s_goal4 = undefined;
	
	VEHICLE_DELETE( self );
}


tower_explosions()  //self = MiG
{
	s_bomb1 = getstruct( "mig_tower_bomb1", "targetname" );
	e_bomb2 = GetEnt( "mig_tower_bomb2", "targetname" );
	
	e_missile1 = MagicBullet( "stinger_sp", self GetTagOrigin( "tag_missle_left" ), s_bomb1.origin );
	e_missile1 thread missile_mig_explosion();
	
	wait 0.1;
	
	e_missile2 = MagicBullet( "stinger_sp", self GetTagOrigin( "tag_missle_right" ), e_bomb2.origin, self, e_bomb2 );
	e_missile2 thread missile_mig_explosion( true );
		
	wait 1;
	
	s_bomb1 = undefined;
	e_bomb2 Delete();
}


missile_mig_explosion( b_tower )  //self = mig missile
{
	self waittill( "death" );
	
	if ( IsDefined( b_tower ) )
	{
		PlayFX( level._effect[ "missile_impact_hip" ], self.origin );
	}
	
	else
	{
		PlayFX( level._effect[ "explode_mortar_sand" ], self.origin );
	}
	
	Earthquake( 0.3, 1, level.player.origin, 3000 );
	
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	
	PlaySoundAtPosition( "exp_mortar", self.origin );
	
	RadiusDamage( self.origin, 300, 2000, 2000, undefined, "MOD_PROJECTILE" );
	
	if ( IsDefined( b_tower ) )
	{
		level notify( "fxanim_village_tower_start" );
	}
}


mig1_strafe_logic()
{
	self endon( "death" );
	
	self setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	Target_Set( self );
	self SetForceNoCull();
	
	self thread go_path( GetVehicleNode( "start_node_mig_strafe", "targetname" ) );
	
	self thread mig_gun_strafe();
	
	self waittill( "reached_end_node" );
	
	VEHICLE_DELETE( self );
}


player_horse_behavior()  //self = level.mason_horse
{
	flag_wait( "bp1_stop_horse" );
	
	level thread bp1_spawn_hitch_horse();
	
	if ( IsDefined( level.player.viewlockedentity ) )
	{
		v_explosion = self.origin + ( AnglesToForward( self.angles ) * ( 400 ) );
		
		PlayFX( level._effect[ "explode_mortar_sand" ], v_explosion );
		PlaySoundAtPosition( "exp_mortar", v_explosion );
		Earthquake( 0.4, 2, level.player.origin, 100 );
		level.player PlayRumbleOnEntity( "grenade_rumble" );
		level.player playsound ("evt_mortar_dirt_close");
		level thread check_explosion_radius( v_explosion );
		
		wait 0.3;
		
		self SetBrake( true );
		self SetSpeedImmediate( 0 );
		
		if ( level.player is_on_horseback() )
		{
			level.player DisableWeapons();
		}
	
		self horse_rearback();
	
		level.player EnableWeapons();
		
		level clientNotify( "cease_aiming" );
			
		wait 0.1;
			
		self use_horse( level.player );
		
		self SetBrake( false );
		
		self waittill( "no_driver" );
		
		self MakeVehicleUnusable();
	}
	
	flag_wait( "goto_town" );
	
	self thread bp1_horse_runaway();
	
	autosave_by_name( "bp1_started" );
}


bp1_horse_runaway()
{
	self endon( "death" );
	
	goal = getstruct( "wave1_player_horse_spawnpt", "targetname" );
	
	self SetBrake( false );
	
	self SetSpeed( 20, 10, 5 );
	
	self SetVehGoalPos( goal.origin, 0, 1 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


bp1_spawn_hitch_horse()  //self = player horse
{
	s_hitchpt = getstruct( "bp1_hitch", "targetname" );
	
	flag_wait( "crew_showoff" );
	
	level.mason_horse = spawn_vehicle_from_targetname( "mason_horse" );
	level.mason_horse.origin = s_hitchpt.origin;
	level.mason_horse.angles = s_hitchpt.angles;
	
	level.mason_horse SetNearGoalNotifyDist( 300 );
	level.mason_horse SetBrake( false );
	level.mason_horse veh_magic_bullet_shield( true );
	level.mason_horse MakeVehicleUnusable();
	
	level.mason_horse thread horse_panic();
	
	flag_wait( "dome_exploded" );
	
	wait 0.1;
	
	level.mason_horse MakeVehicleUsable();
	
	if ( IsDefined( level.player.viewlockedentity ) )
	{
		flag_set( "player_onhorse_bp1exit" );
	}
	
	level.mason_horse waittill( "enter_vehicle", player );
	
	flag_set( "player_onhorse_bp1exit" );
}


bp1_replenish_arena()
{
	level endon( "wave1_done" );
	
	trigger_wait( "bp1_replenish_arena" );
	
	if ( !flag( "wave1_done" ) )
	{
		level thread replenish_bp1();
		
		if ( cointoss() )
		{
			level.woods thread say_dialog( "wood_where_the_fuck_are_y_0", 0 );		//Where the fuck are you going, Mason?!  We can't lose this position!
		}
		
		else
		{
			level.woods thread say_dialog("wood_get_back_here_we_ca_0", 0 );	//Get back here! We can't let them get a foothold!
		}
	}
	
	spawn_manager_disable( "manager_soviet_bp1" );
	spawn_manager_kill( "manager_bp1_reinforce" );
	spawn_manager_disable( "manager_muj_bp1" );
	
	wait 0.1;
	
	cleanup_bp_ai();
	respawn_arena();
}


replenish_bp1()
{
	trigger_wait( "spawn_bp1" );
	
	cleanup_arena();
	
	wait 0.1;
	
	spawn_manager_enable( "manager_soviet_bp1" );
	spawn_manager_enable( "manager_muj_bp1" );
	
	level thread bp1_replenish_arena();
}


zhao_wave1_bp1()  //self = level.zhao_horse
{
	flag_wait( "zhao_at_bp1" );
	
	self MakeVehicleUnusable();
	
	level.zhao notify( "stop_riding" );
	
	level.zhao set_force_color( "r" );
	
	self vehicle_unload( 0.1 );
	
	self waittill( "unloaded" );
	
	if ( !flag( "enter_bp1" ) )
	{
		level.zhao SetGoalPos( level.zhao.origin );
	}
	
	wait 1;
	
	self thread horse_zhao_runaway();
	
	level thread nag_follow( "bp1_stop_horse" );
	
	flag_wait( "goto_cache" );
	
	level.zhao change_movemode( "cqb_sprint" );
	
	flag_wait( "wave1_done" );
	
	level.zhao reset_movemode();
	
	flag_wait( "dome_exploded" );
	
	wait 2;
	
	self ClearVehGoalPos();
	
	level.zhao clear_force_color();
	
	level.zhao ai_mount_horse( self );
	
	flag_set( "ready_to_leave_bp1" );
	
	level thread bp1_exit_battle();
	level thread arena_hip_land();
	
	wait 1;
	
	self thread zhao_goto_wave2();
	
	flag_set( "zhao_ready_bp1exit" );
}


woods_wave1_bp1()  //self = level.woods_horse
{
	flag_wait( "woods_at_bp1" );
	
	self MakeVehicleUnusable();
	
	level.woods notify( "stop_riding" );
	
	level.woods set_force_color( "r" );
	
	self vehicle_unload( 0.1 );
	
	self waittill( "unloaded" );
	
	if ( !flag( "enter_bp1" ) )
	{
		level.woods SetGoalPos( level.woods.origin );
	}
	
	wait 1;
	
	self thread horse_woods_runaway();
	
	flag_wait( "goto_cache" );
	
	level.woods change_movemode( "cqb_sprint" );
	
	flag_wait( "wave1_done" );
	
	level.woods reset_movemode();
	
	flag_wait( "dome_exploded" );
	
	wait 0.2;
	
	self horse_rearback();
	
	wait 2;
	
	self ClearVehGoalPos();
	
	level.woods clear_force_color();
	
	level.woods ai_mount_horse( self );
	
	wait 1.5;
	
	level.woods thread say_dialog( "wood_let_s_ride_hya_0", 0 );	//Let?s ride! Hya!
	
	self thread woods_goto_wave2();
}


horse_zhao_runaway()  //self = level.zhao_horse
{
	s_run = getstruct( "zhao_bp1wave3_goal", "targetname" );
	s_ready = getstruct( "zhao_bp1_horse", "targetname" );
	
	self SetNearGoalNotifyDist( 300 );
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	
	//flag_wait( "goto_town" );
	
	self SetVehGoalPos( s_run.origin, 1, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	self ClearVehGoalPos();
	
	flag_wait( "soviet_fallback" );
	
	self.origin = s_ready.origin;
	self.angles = s_ready.angles;
	
	wait 0.1;
	
	self SetVehGoalPos( self.origin, 1, 1 );
	
	self SetBrake( true );
	
	self thread horse_panic();
}


horse_woods_runaway()  //self = level.woods_horse
{
	s_run = getstruct( "woods_bp1wave3_goal", "targetname" );
	s_ready = getstruct( "woods_bp1_horse", "targetname" );
	
	self SetNearGoalNotifyDist( 300 );
	self SetBrake( false );
	
	self SetSpeed( 25, 15, 10 );
	
	//flag_wait( "goto_town" );
	
	self SetVehGoalPos( s_run.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	self ClearVehGoalPos();
	
	flag_wait( "soviet_fallback" );
	
	self.origin = s_ready.origin;
	self.angles = s_ready.angles;
	
	wait 0.1;
	
	self SetVehGoalPos( self.origin, 1, 1 );
	
	self SetBrake( true );
	
	self thread horse_panic();
}


bp1_hips_flyby()
{
	trigger_wait( "trigger_hip_flyby" );
	
	s_hip_spawnpt = getstruct( "hip_flyby_spawnpt", "targetname" );
	
	for ( i = 0; i < 4; i++ )
	{
		vh_hip1 = spawn_vehicle_from_targetname( "hip_soviet" );
		v_spawnpt = s_hip_spawnpt.origin + ( 0, RandomIntRange( -1000, 1000 ), RandomIntRange( -800, 800 ) );
		vh_hip1.origin = v_spawnpt;
		vh_hip1.angles = s_hip_spawnpt.angles;
		vh_hip1 thread hip_flyby_bp2( v_spawnpt, i );
		
		wait RandomFloatRange( 0.8, 1.5 );
	}
}


hip_flyby_bp2( v_spawnpt, n_index )
{
	self endon( "death" );
	
	s_goal1 = getstruct( "hip_flyby_goal1", "targetname" );
	s_goal2 = getstruct( "hip_flyby_goal2", "targetname" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 500 );
	self SetForceNoCull();
	
	self setspeed( 100, 50, 45 );
	
	if ( n_index == 1 )
	{
		self thread hip_flyby_stingers();
	}
	
	else if ( n_index == 3 )
	{
		self thread hip_flyby_shot();
	}
	
	self setvehgoalpos( s_goal1.origin + ( RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ), RandomIntRange( -200, 200 ) ), 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread hip_flyby_flares();
	
	self setvehgoalpos( s_goal2.origin + ( RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ), RandomIntRange( -200, 200 ) ), 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


hip_flyby_stingers()
{
	self endon( "death" );
	
	wait 2;
	
	s_stinger = getstruct( "hip_flyby_stinger", "targetname" );
	
	for ( i = 0; i < 4; i++ )
	{
		MagicBullet( "stinger_sp", s_stinger.origin, self.origin + ( RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ), RandomIntRange( -100, 200 ) ) );
		
		wait RandomFloatRange( 1.0, 3.0 );
	}
}


hip_flyby_shot()
{
	self endon( "death" );
	
	wait 2.5;
	
	s_stinger = getstruct( "hip_flyby_stinger", "targetname" );
	
	MagicBullet( "stinger_sp", s_stinger.origin, self.origin, undefined, self, ( 0, 0, -50 ) );
}


hip_flyby_flares()
{
	self endon( "death" );
	
	for ( i = 0; i < 5; i++ )
	{
		PlayFX( level._effect[ "aircraft_flares" ], self.origin + ( 0, 0, -120 ) );
		
		wait 0.25;
	}
}


bp1_exit_battle()
{
	trigger_wait( "bp1_exit_battle" );
	
	level thread vo_get_horse();
	level thread vo_leave_bp1();
	
	trigger_on( "trigger_btr_chase", "script_noteworthy" );
	
	flag_set( "leaving_bp1" );
	
	level thread maps\afghanistan_wave_2::btr_chase();
	level thread spawn_bp1exit_uazs();
	
	wait 0.1;
	
	spawn_manager_enable( "manager_bp1_muj_exit" );
		
	//level thread spawn_arena_sniper();
	level thread monitor_cache_bp1exit();
		
	flag_wait( "bp1_exit_done" );
	
	autosave_by_name( "bp1_exit" );
	
	//wait 2;
	
	//flag_set( "spawn_btr_chase" );
	
	//level thread spawn_arena_crossers();
}


spawn_bp1exit_uazs()
{
	s_uaz1_spawnpt = getstruct( "uaz_bp1exit_spawnpt1", "targetname" );
	s_uaz2_spawnpt = getstruct( "uaz_bp1exit_spawnpt2", "targetname" );
	s_uaz3_spawnpt = getstruct( "uaz_bp1exit_spawnpt3", "targetname" );
	s_uaz4_spawnpt = getstruct( "uaz_bp1exit_spawnpt4", "targetname" );
	
	nd_start1 = GetVehicleNode( "uaz_startnode1", "targetname" );
	nd_start2 = GetVehicleNode( "uaz_startnode2", "targetname" );
	nd_start3 = GetVehicleNode( "uaz_startnode3", "targetname" );
	nd_start4 = GetVehicleNode( "uaz_startnode4", "targetname" );
		
	vh_uaz1 = spawn_vehicle_from_targetname( "uaz_soviet" );
	vh_uaz1.origin = s_uaz1_spawnpt.origin;
	vh_uaz1.angles = s_uaz1_spawnpt.angles;
	vh_uaz1 thread uaz_bp1_exit_logic( nd_start1 );
	
	vh_uaz2 = spawn_vehicle_from_targetname( "uaz_soviet" );
	vh_uaz2.origin = s_uaz2_spawnpt.origin;
	vh_uaz2.angles = s_uaz2_spawnpt.angles;
	vh_uaz2 thread uaz_bp1_exit_logic( nd_start2 );
	
	wait 3;
	
	vh_uaz3 = spawn_vehicle_from_targetname( "uaz_soviet" );
	vh_uaz3.origin = s_uaz3_spawnpt.origin;
	vh_uaz3.angles = s_uaz3_spawnpt.angles;
	vh_uaz3 thread uaz_bp1_exit_logic( nd_start3 );
	
	vh_uaz4 = spawn_vehicle_from_targetname( "uaz_soviet" );
	vh_uaz4.origin = s_uaz4_spawnpt.origin;
	vh_uaz4.angles = s_uaz4_spawnpt.angles;
	vh_uaz4 thread uaz_bp1_exit_logic( nd_start4 );
	
	wait 2;
	
	level thread monitor_bp1exit_soviet();
}


bp1_muj_exit_logic()
{
	self endon( "death" );
	
	self.arena_guy = true;
	self.goalradius = 64;
	
	self SetGoalVolumeAuto( GetEnt( "vol_cache4", "targetname" ) );
}


uaz_bp1_exit_logic( nd_start )
{
	self endon( "death" );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	for ( i = 0; i < 2; i++ )
	{
		n_aitype = RandomInt( 10 );
	
		if ( n_aitype < 5 )
		{
			sp_rider = GetEnt( "soviet_assault", "targetname" );
		}
		
		else if ( n_aitype < 8 )
		{
			sp_rider = GetEnt( "soviet_smg", "targetname" );
		}
		
		else
		{
			sp_rider = GetEnt( "soviet_lmg", "targetname" );
		}
	
		ai_rider = sp_rider spawn_ai( true );
		
		if ( IsDefined( ai_rider ) )
		{
			ai_rider.script_combat_getout = 1;
			ai_rider.arena_guy = true;
			ai_rider.bp1exit_guy = true;
			ai_rider.targetname = "bp1exit_soviet";
			
			wait 0.05;
		
			ai_rider enter_vehicle( self );
		}
	}
	
	self thread go_path( nd_start );
	
	self waittill( "reached_end_node" );
	
	self vehicle_detachfrompath();
	
	self SetBrake( true );
	
	flag_wait( "wave2_started" );
	
	VEHICLE_DELETE( self );
}


monitor_bp1exit_soviet()
{
	while ( 1 )
	{
		a_ai_guys = GetEntArray( "bp1exit_soviet", "targetname" );
		
		if ( !a_ai_guys.size )
		{
			break;
		}
		
		wait 1;
	}
	
	wait 2;
	
	flag_set( "bp1_exit_done" );
}


spawn_arena_crossers()
{
	sp_crosser = GetEnt( "soviet_cache5", "targetname" );
	
	for ( i = 0; i < 3; i++ )
	{
		sp_crosser spawn_ai( true );
		
		wait RandomFloatRange( 1.0, 2.0 );
	}
}


arena_crosser_logic()
{
	self endon( "death" );
	
	self.arena_guy = true;
	
	vol_cache = GetEnt( "vol_cache2", "targetname" );
	
	self SetGoalVolumeAuto( vol_cache );
}


arena_hip_land()
{
	trigger_wait( "trigger_mig1_strafe" );
	
	level thread spawn_mig_strafe();
	
	spawn_manager_kill( "manager_bp1_muj_exit" );
		
	s_spawnpt = getstruct( "arena_hip_land_spawnpt", "targetname" );
	
	vh_hip = spawn_vehicle_from_targetname( "hip_soviet_land" );
	vh_hip.origin = s_spawnpt.origin;
	vh_hip.angles = s_spawnpt.angles;
	
	vh_hip thread arena_hip_land_logic();
	
	a_ai_muj = GetEntArray( "bp1_muj_exit_ai", "targetname" );
	
	foreach( ai_muj in a_ai_muj )
	{
		ai_muj die();
	}
}


spawn_mig_strafe()
{
	s_spawnpt = getstruct( "mig1_strafe_spawnpt", "targetname" );
	
	vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
	vh_mig.origin = s_spawnpt.origin;
	vh_mig.angles = s_spawnpt.angles;
	
	vh_mig thread mig1_strafe_logic();
}


arena_hip_land_logic()
{
	self endon( "death" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self.dropoff_heli = true;
	self SetForceNoCull();
	self HidePart( "tag_back_door" );
	
	self.overrideVehicleDamage = ::heli_vehicle_damage;
	
	sp_rappel = GetEnt( "ambient_troops1", "targetname" );
		
	self SetNearGoalNotifyDist( 500 );
	self setspeed( 175, 85, 75 );

	s_goal1 = getstruct( "arena_hip_land_goal1", "targetname" );
	s_goal2 = getstruct( "arena_hip_land_goal2", "targetname" );
	s_goal3 = getstruct( "arena_hip_land_goal3", "targetname" );
	s_goal4 = getstruct( "arena_hip_land_goal4", "targetname" );
	s_goal5 = getstruct( "arena_hip_land_goal5", "targetname" );
	
	self SetVehGoalPos( s_goal1.origin, 0 );
	self waittill_any( "near_goal", "goal" );
	
	hip_land_dropoff( "arena_hip_land_goal2", sp_rappel );
	
	self SetVehGoalPos( s_goal3.origin, 0 );
	self waittill_any( "near_goal", "goal" );
	self SetVehGoalPos( s_goal4.origin, 0 );
	self waittill_any( "near_goal", "goal" );
	self SetVehGoalPos( s_goal5.origin, 0 );
	self waittill_any( "near_goal", "goal" );
	
	VEHICLE_DELETE( self );
}


hip_land_dropoff( drop_struct_name, sp_rappel )
{
	self endon( "death" );
	
	self SetHoverParams( 0, 0, 10 );
	
	drop_struct = GetStruct( drop_struct_name, "targetname" );
	drop_origin = drop_struct.origin;
	
	// save the original drop point
	original_drop_origin = drop_origin;
	original_drop_origin = ( original_drop_origin[0], original_drop_origin[1], original_drop_origin[2] + self.dropoffset );
		
	// Adjust for height
	drop_origin = ( drop_origin[0], drop_origin[1], drop_origin[2] + 350 );;
		
	// Fly there
	self setNearGoalNotifyDist( 100 );
	self SetVehGoalPos( drop_origin, 1 );
	
	// wait till we get there
	self waittill( "goal" );
	
	n_pos = 2;
	
	for ( i = 0; i < 4; i++ )
	{
		ai_rappeller = sp_rappel spawn_ai( true );
		ai_rappeller.script_startingposition = n_pos;
		ai_rappeller.arena_guy = true;
		ai_rappeller enter_vehicle( self );
		n_pos++;
		wait 0.1;
	}
	
	// fly down
	self SetVehGoalPos( original_drop_origin, 1 );
		
	// wait till we get there
	self waittill( "goal" );
	
	// Unload
	self notify( "unload" );
	
	// Wait until unload finished
	self waittill( "unloaded" );
}


spawn_arena_sniper()
{
	sp_sniper = GetEnt( "sniper_arena", "targetname" );
	ai_sniper = sp_sniper spawn_ai( true );
	ai_sniper thread arena_sniper_behavior();
}


arena_sniper_behavior()
{
	self endon( "death" );
	
	self.no_cleanup = true;
	self set_ignoreme( true );
	
	self set_ignoreme( false );	
}


vo_approach_bp1()
{
	flag_wait( "bp1_bombs1" );

	level.player say_dialog( "maso_dammit_0", 0.5 );	//Dammit!!
	
	flag_wait( "bp1_bombs2" );
	
	level.player say_dialog( "maso_shit_0", 0.5 );	//Shit!!!
}


vo_enter_bp1()
{
	level endon( "soviet_fallback" );
	
	flag_wait( "bp1_stop_horse" );
	
	level.woods say_dialog( "maso_too_fucking_close_0", 2 );	//Too fucking close!
	
	level.zhao say_dialog( "zhao_follow_me_0", 1 );	//Follow me!
		
	level.player say_dialog( "maso_right_behind_you_1", 0.5 );  //Right behind you!
	
	level thread nag_follow( "goto_town" );
}


vo_engagement_bp1()
{
	level endon( "spawn_vehicles_bp1" );
	
	trigger_wait( "zhao_to_weapons" );
	
	level thread cleanup_arena();
	
	flag_set( "goto_cache" );
	
	flag_wait( "soviet_fallback" );
	
	level.woods say_dialog( "wood_right_flank_0", 2.5 );	//Right flank!!
	
	level.zhao say_dialog( "zhao_hold_the_line_0", 0.5 );	//Hold the line!
	
	level.zhao say_dialog( "muj0_the_cowards_are_retr_0", 1 );	//The cowards are retreating
	
	level.zhao say_dialog( "muj0_do_not_die_without_y_0", 1 );	//Do not die without your rifle in your hand
}


vo_vehicles_bp1()
{
	level endon( "wave1_done" );
	
	flag_wait( "spawn_vehicles_bp1" );
	
	level.player say_dialog( "maso_they_re_bringing_in_0", 1.5 );	//They?re bringing in a BTR!
	
	level.woods say_dialog( "wood_take_the_bastard_out_0", 1 );		//Take the bastard out, Mason!
	
	level.zhao say_dialog( "zhao_we_cannot_let_their_0", 1.5 );	//We cannot let their vehicles through the valley!
	
	flag_wait( "spawn_btr2_bp1" );
	
	level.zhao say_dialog( "zhao_another_btr_is_heade_0", 1 );	//Another BTR is headed this way!
	
	wait 2;
	
	if ( !flag( "player_has_rpg" ) )
	{
		level.woods say_dialog( "wood_gonna_need_more_than_0", 0 );	//Gonna need more than a rifle, Mason!
		level.woods say_dialog( "wood_grab_an_rpg_from_the_0", 0.5 );	//Grab an RPG from the weapons cache!
	}
	
	wait 7;
	
	while( !flag( "player_has_rpg" ) )
	{
		level.woods say_dialog( "wood_grab_an_rpg_from_the_0", 0 );  //Grab an RPG from the weapons cache!
		
		wait 8;
	}
}


vo_done_bp1()
{
	level endon( "started_crater_charge" );
	
	flag_wait( "wave1_done" );
	
	//TUEY Set music to AFGHAN_C4
	setmusicstate ("AFGHAN_C4");
	
	level.woods say_dialog( "wood_nice_work_mason_0", 1 );	//Nice work, Mason!
	
	level.zhao say_dialog( "zhao_you_fight_bravely_a_0", 1 );		//You fight bravely, American.
	level.zhao say_dialog( "zhao_the_mujahideen_can_h_0", 0.5 );	//The Mujahideen can handle infantry.
	
	level.woods say_dialog( "wood_let_s_make_damn_sure_0", 1.5 );	//Let's make damn sure no more vehicles make it through here.
	level.woods say_dialog( "wood_mason_put_some_c4_u_0", 0.5 );	//Mason, put some C4 under the archway.
	
	//level.woods say_dialog( "wood_fuck_it_beat_pu_0", 0.5 );  //Fuck it. Use a cratering charge - just to make sure.
		
	//level.player say_dialog( "maso_okay_1", 0.5 );  //Okay.
	
	level thread nag_crater_charge();
}


nag_crater_charge()
{
	level endon( "started_crater_charge" );
	
	wait 8;
	
	n_nag = 0;
	
	while( 1 )
	{
		level.woods say_dialog( "wood_mason_put_some_c4_u_0", 0 );  //Mason, put some C4 under the archway.
		
		wait 8;
		
		n_nag++;
		
		if ( n_nag > 5 )
		{
			missionfailedwrapper( &"AFGHANISTAN_OBJECTIVE_FAIL" );	
		}
	}
}


vo_nag_safe_distance()
{
	level endon( "dome_exploded" );
	level endon( "safe_to_explode" );
	
	while( 1 )
	{
		wait 5;

		switch( RandomInt( 5 ) )
		{
			case 0:
			{
				level.woods say_dialog( "wood_back_it_up_mason_0", 0 );  //Back it up, Mason.
				
				break;
			}
			case 1:
			{
				level.woods say_dialog( "wood_retreat_to_a_safe_di_0", 1 );  //Retreat to a safe distance.
				
				break;
			}
			case 2:
			{
				level.woods say_dialog( "wood_you_re_too_close_ma_0", 1 );  //You're too close, Mason.  Get over here.
				
				break;
			}
			case 3:
			{
				level.woods say_dialog( "wood_mason_come_over_he_0", 1 );  //Mason.  Come over here.
				
				break;
			}
			case 4:
			{
				level.woods say_dialog( "wood_come_here_and_blow_t_0", 1 );  //Come here and blow that crater charge.
				
				break;
			}
		}
	}
}


vo_explosive_bp1()
{
	flag_wait( "started_crater_charge" );
	
	if ( level.b_plant_stairs )
	{
		scene_wait( "plant_explosive_dome_stairs" );
	}
				
	else
	{
		scene_wait( "plant_explosive_dome" );
	}
	
	level thread vo_detonation_warning();
	
	level.player say_dialog( "maso_set_0", 0.5 );	//Set.
	
	flag_wait( "dome_exploded" );
	
	level.woods say_dialog( "wood_choke_point_s_sealed_0", 1 );	//Choke point's sealed.  Time to go.
	
	level.player say_dialog( "maso_hudson_the_west_ch_0", 0.5 );	//Hudson.  The West choke point is secure.
	
	level.woods say_dialog( "huds_not_a_moment_too_soo_0", 1 );		//Not a moment too soon.
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		level.woods say_dialog( "huds_scouts_report_enemy_0", 0.5 );  //Scouts report enemy movement to the North.
	}
	
	else
	{
		level.woods say_dialog( "huds_we_re_seeing_enemy_a_0", 0.5 );	//We?re seeing enemy activity to the East.
	}
	
	level.woods say_dialog( "huds_ensure_they_don_t_pu_0", 0.5 );  //Ensure they don?t push through to the valley.
	
	//level.player say_dialog( "maso_it_won_t_0", 0.5 );	//It won?t.
}


vo_detonation_warning()
{
	while( !level.player AttackButtonPressed() )
	{
		wait 0.1;
	}
	
	if ( !flag( "safe_to_explode" ) )
	{
		level.woods say_dialog( "wood_you_trying_to_blow_y_0", 0 );  //You trying to blow yourself, up?!!
	}
}


vo_head_to_bp1exit()
{
	if ( flag( "leaving_bp1" ) )
	{
		return;	
	}
	
	level endon( "leaving_bp1" );
	
	wait 6;
	
	level.woods say_dialog("wood_where_the_hell_are_y_0", 0 );  //Where the hell are you, Mason?
	
	wait 6;
	
	level.woods say_dialog("wood_we_need_you_with_us_0", 0 );  //We need you with us.
	
	wait 6;
	
	level.woods say_dialog("wood_there_s_nothing_else_0", 0 );  //There's nothing else you can do... Get moving.
	
	wait 6;
	
	level.woods say_dialog("wood_job_s_done_gotta_m_0", 0 );  //Job's done.  Gotta move on, Mason.
	
	wait 6;
	
	level.woods say_dialog("wood_don_t_get_left_behin_0", 0 );  //Don't get left behind, Mason... You gotta follow us.
	
	wait 5;
	
	if ( !flag( "leaving_bp1" ) )
	{
		missionfailedwrapper( &"AFGHANISTAN_OBJECTIVE_FAIL" );		
	}
}


vo_leave_bp1()
{
	level endon( "bp1_exit_done" );
	
	level.zhao say_dialog( "zhao_we_must_hurry_the_c_0", 1 );  //We must hurry! The cache is under attack!
	
	level.zhao say_dialog( "zhao_the_mujahideen_are_l_0", 0.5 );	//The Mujahideen are losing ground!  We cannot let the Russians gain a foothold.

	level.player say_dialog( "maso_the_muj_ain_t_gonna_0", 1 );  //The Muj ain?t gonna hold out.
	
	level.woods say_dialog( "huds_do_what_you_can_but_0", 0.5 );  //Do what you can, but make it quick.We can?t leave the other choke points exposed.
}


zhao_goto_wave2()
{
	level.zhao.vh_horse = self;
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 300 );
	self SetBrake( false );
	self SetSpeed( 25, 15, 10 );
	
	s_exit_battle = getstruct( "exit_battle_goal", "targetname" );
	s_zhao_wave2 = getstruct( "zhao_bp3", "targetname" );
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		s_zhao_wave2 = getstruct( "zhao_bp2", "targetname" );
	}
	
	self SetVehGoalPos( s_exit_battle.origin, 1, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	wait 0.3;
	
	level.zhao notify( "stop_riding" );
	
	self vehicle_unload( 0.1 );
	
	self waittill( "unloaded" );
	
	level.zhao set_fixednode( false );
	
	flag_wait( "bp1_exit_done" );
	
	wait 1;
	
	level.zhao ai_mount_horse( self );
	
	wait 1;
	
	flag_set( "leaving_bp1_exit" );
	
	level.zhao thread say_dialog( "zhao_i_will_head_to_the_n_0", 0 );  //I will head to the next choke point to help the Mujahideen.
	
	///////////////////////////////////////////////////////////
	// BTR Chase Event
	///////////////////////////////////////////////////////////
	
//	if ( level.wave2_loc == "blocking point 3" )
//	{
//		level.zhao btr_chase_event();
//		
//		level.zhao_horse ent_flag_init( "btr_chase_over" );
//	
//		level.zhao_horse ent_flag_wait( "btr_chase_over" );
//	}
	
	///////////////////////////////////////////////////////////
	
	self SetVehGoalPos( s_zhao_wave2.origin, 1, 1 );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		flag_set( "zhao_at_bp2" );
	}
	
	else
	{
		flag_set( "zhao_at_bp3" );
	}
	
	s_exit_battle = undefined;
	s_zhao_wave2 = undefined;
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		s_zhao_wave2 = undefined;
	}
}


woods_goto_wave2()  //self = level.woods_horse
{
	level.woods.vh_horse = self;
	
	s_ready = getstruct( "bp1_hitch", "targetname" );
	s_exit_battle = getstruct( "exit_battle_goal", "targetname" );
	s_zhao_wave2 = getstruct( "zhao_bp3", "targetname" );
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		s_zhao_wave2 = getstruct( "zhao_bp2", "targetname" );
	}
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 300 );
	self SetBrake( false );
	self SetSpeed( 25, 15, 10 );
	
	self SetVehGoalPos( s_exit_battle.origin + ( 150, -100, 0 ), 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	wait 0.3;
	
	level.woods notify( "stop_riding" );
	
	self vehicle_unload( 0.1 );
	
	self waittill( "unloaded" );
	
	level thread vo_head_to_bp1exit();
	
	level.woods set_fixednode( false );
	
	flag_wait( "bp1_exit_done" );
	
	wait 1;
	
	level.woods ai_mount_horse( self );
	
	wait 1;
	
	flag_wait_or_timeout( "leaving_bp1_exit", 15 );
	
	wait 1;
	
	///////////////////////////////////////////////////////////
	// BTR Chase Event
	///////////////////////////////////////////////////////////
	
	//if ( level.wave2_loc == "blocking point 3" )
	//{
		level.woods btr_chase_event();
		
		level.woods_horse ent_flag_wait( "btr_chase_over" );
	//}
		
	///////////////////////////////////////////////////////////
	
	self SetBrake( false );
	self SetSpeed( 35, 25, 10 );
	self SetVehGoalPos( s_zhao_wave2.origin + ( 150, -100, 0 ), 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self horse_stop();
	
	if ( level.wave2_loc == "blocking point 2" )
	{
		flag_set( "woods_at_bp2" );
	}
	
	else
	{
		flag_set( "woods_at_bp3" );
	}
	
//	if ( !flag( "player_killed_btr" ) )
//	{
//		level.woods say_dialog( "wood_dammit_mason_we_l_0", 1 );  //Dammit, Mason!  We lost the base weapons cache.
//		level.woods say_dialog( "wood_fucking_btr_rolled_r_0", 0.5 );  //Fucking BTR rolled right through!
//	}
}


btr_chase_event()
{
	level endon( "btr_chase_dead" );
	
	self thread monitor_btr_chase_over();
	
	s_goal = getstruct( "btr_chase_approach_goal", "targetname" );
	
	self.vh_horse SetVehGoalPos( s_goal.origin, 0, 1 );
	self.vh_horse waittill_any( "goal", "near_goal" );
	
	if ( !flag( "btr_chase_dead" ) )
	{
		self thread shoot_at_btr();
	}
	
	if ( self.targetname == "zhao_ai" )
	{
		s_btr_goal = getstruct( "zhao_btr_chase_goal1", "targetname" );
	}
	
	else
	{
		s_btr_goal = getstruct( "woods_btr_chase_goal1", "targetname" );
	}
		
	self.vh_horse SetVehGoalPos( s_btr_goal.origin, 0, 1 );
	self.vh_horse waittill_any( "goal", "near_goal" );
	self.vh_horse SetBrake( true );
	
	if ( !flag( "btr_chase_dead" ) )
	{
		self thread defend_against_btr();
	}
}


monitor_btr_chase_over()  //self = woods/zhao
{
	flag_wait( "btr_chase_dead" );
	
	if ( self == level.zhao )
	{
		vh_horse = level.zhao_horse;
	}
	
	else
	{
		vh_horse = level.woods_horse;
	}
	
	wait 1;
	
	if ( !IsDefined( vh_horse get_driver() ) )
	{
		wait 1;
		
		self ai_mount_horse( vh_horse );
	}
	
	vh_horse SetBrake( false );
	vh_horse SetVehGoalPos( getstruct( "btr_chase_over_goal", "targetname" ).origin, 0, 1 );
	vh_horse waittill_any( "goal", "near_goal" );
	
	vh_horse ent_flag_set( "btr_chase_over" );
}


shoot_at_btr()
{
	vh_btr = GetEnt( "btr_chase", "targetname" );
	
	while( !flag( "btr_chase_dead" ) )
	{
		if ( IsAlive( vh_btr ) && IsDefined( vh_btr ) )
		{
			self shoot_at_target( vh_btr, undefined, 1, RandomFloatRange( 2.0, 3.5 ) );
		}
		
		wait RandomFloatRange( 1.0, 2.0 );
	}
	
	self stop_shoot_at_target();
}


defend_against_btr()
{
	level endon( "btr_chase_dead" );
	
	flag_set( "defend_against_btr" );
	
	self ai_dismount_horse( self.vh_horse );
	
	self set_fixednode( false );
	
	if ( self.targetname == "woods_ai" )
	{
		self thread force_goal( GetNode( "node_woods_base_entrance", "targetname" ), 32 );
	}
	
	else
	{
		self thread force_goal( GetNode( "node_zhao_base_entrance", "targetname" ), 32 );
	}
}


bp1_vehicle_chooser()
{
	//level.n_bp1_vehicles = RandomInt( 3 );
	level.n_bp1_vehicles = 2;
																												
	if ( level.n_bp1_vehicles == 0 )
	{
		level thread spawn_hip1_bp1();
		level thread spawn_btr1_bp1();
	}
	
	else if ( level.n_bp1_vehicles == 1 )
	{
		level thread spawn_hip1_bp1();
		level thread spawn_hip2_bp1();
	}
	
	else
	{
		level thread spawn_btr1_bp1();
		level thread spawn_btr2_bp1();
	}
	
	level thread trigger_vehicles();
}


spawn_hip1_bp1()
{
	flag_wait( "spawn_hip1_bp1" );
	
	s_spawnpt = getstruct( "hip1_bp1_spawnpt", "targetname" );
	
	hip1 = spawn_vehicle_from_targetname( "hip_soviet" );
	hip1.origin = s_spawnpt.origin;
	hip1.angles = s_spawnpt.angles;
	hip1 thread hip1_bp1_logic();
	hip1 thread delete_corpse_bp1();
	
	s_spawnpt = undefined;
}


spawn_hip2_bp1()
{
	flag_wait( "spawn_hip2_bp1" );
	
	s_spawnpt = getstruct( "hip2_bp1_spawnpt", "targetname" );
	
	hip2 = spawn_vehicle_from_targetname( "hip_soviet" );
	hip2.origin = s_spawnpt.origin;
	hip2.angles = s_spawnpt.angles;
	hip2 thread hip2_bp1_logic();
	hip2 thread delete_corpse_bp1();
	
	s_spawnpt = undefined;
}


spawn_btr1_bp1()
{
	flag_wait( "spawn_btr1_bp1" );
	
	s_spawnpt = getstruct( "btr1_bp1_spawnpt", "targetname" );
	
	vh_btr = spawn_vehicle_from_targetname( "btr_soviet" );
	vh_btr.origin = s_spawnpt.origin;
	vh_btr.angles = s_spawnpt.angles;
	vh_btr thread btr1_bp1_logic();
}


spawn_btr2_bp1()
{
	flag_wait( "spawn_btr2_bp1" );
	//flag_wait( "spawn_btr2" );
	
	s_spawnpt = getstruct( "btr2_bp1_spawnpt", "targetname" );
	
	vh_btr = spawn_vehicle_from_targetname( "btr_soviet" );
	vh_btr.origin = s_spawnpt.origin;
	vh_btr.angles = s_spawnpt.angles;
	vh_btr thread btr2_bp1_logic();
}


trigger_vehicles()
{
	level endon( "wave1_done" );
	
	flag_wait( "spawn_vehicles_bp1" );
	
	wait 0.5;
	
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
	
	self thread bp1_vehicle_destroyed();
	self thread delete_corpse_bp1();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread nag_destroy_vehicle();
	
	set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, self, "destroy", -1 );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	nd_start = GetVehicleNode( "wave1_btr1_start", "targetname" );
	
	self thread go_path( nd_start );
	
	self playsound ("veh_btr_drive_in");
	nd_attack = GetVehicleNode( "btr1_village_attack", "targetname" );
	nd_attack waittill( "trigger" );
	
	self SetSpeedImmediate( 0 );
}


btr2_bp1_logic()
{
	self endon( "death" );
	
	self thread bp1_vehicle_destroyed();
	self thread delete_corpse_bp1();
	self thread btr_attack();
	self thread projectile_fired_at_btr();
	self thread nag_destroy_vehicle();
	
	set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, self, "destroy", -1 );
	
	self.overrideVehicleDamage = ::sticky_grenade_damage;
	
	nd_start = GetVehicleNode( "wave1_btr2_start", "targetname" );
	nd_pause1 = GetVehicleNode( "btr2_village_pause1", "targetname" );
	nd_pause2 = GetVehicleNode( "btr2_village_pause2", "targetname" );
	nd_pause3 = GetVehicleNode( "btr2_village_pause3", "targetname" );
	
	self thread go_path( nd_start );
	
	while( 1 )
	{
		nd_pause3 waittill( "trigger" );
		self SetSpeedImmediate( 0 );
		
		wait RandomIntRange( 5, 8 );
		
		self ResumeSpeed( 5 );
	
		nd_pause2 waittill( "trigger" );
		self SetSpeedImmediate( 0 );
		
		wait RandomIntRange( 5, 8 );
		
		self ResumeSpeed( 5 );
		
		nd_pause1 waittill( "trigger" );
		self SetSpeedImmediate( 0 );
		
		wait RandomIntRange( 5, 8 );
		
		self ResumeSpeed( 5 );
	}
}


projectile_fired_at_bp1btr()
{
	self endon( "death" );
	
	while( 1 )
	{
		level.player waittill( "missile_fire", missile );
		
		self notify( "stop_attack" );
		
		wait 2;
		
		self shoot_turret_at_target( level.player, RandomIntRange( 3, 8 ), ( RandomInt( 64 ), RandomInt( 64 ), RandomInt( 64 ) ), 1, false );
		
		break;
	}
	
	cache_bp1_dest = GetEnt( "bp1_cache_origin", "targetname" );
	
	self thread attack_cache_btr( cache_bp1_dest );
}


hip1_bp1_logic()
{
	self endon( "death" );
	
	self.overrideVehicleDamage = ::heli_vehicle_damage;
	
	self SetVehicleAvoidance( true );
	self SetForceNoCull();
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self thread bp1_vehicle_destroyed();
	self thread heli_select_death();
	self thread nag_destroy_vehicle();
	
	set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, self, "destroy", -1 );
		
	s_goal01 = getstruct( "hip1_bp1_goal01", "targetname" );
	s_goal02 = getstruct( "hip1_bp1_goal02", "targetname" );
	s_goal03 = getstruct( "hip1_bp1_goal03", "targetname" );
	s_goal04 = getstruct( "hip1_bp1_goal04", "targetname" );
	s_goal05 = getstruct( "hip1_bp1_goal05", "targetname" );
	s_goal06 = getstruct( "hip1_bp1_goal06", "targetname" );
	
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 50, 20, 10 );
	self setvehgoalpos( s_goal01.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal01 = undefined;
	
	self setvehgoalpos( s_goal02.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal02 = undefined;
	
	self setvehgoalpos( s_goal03.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal03 = undefined;
	
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal04 = undefined;
	
	self setvehgoalpos( s_goal05.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal05 = undefined;
	
	self setvehgoalpos( s_goal06.origin, 1 );
	self waittill_any( "goal", "near_goal" );
	s_goal06 = undefined;
	
	self SetSpeed( 0, 25, 20 );
	
	wait 1;
	
	self SetSpeedImmediate( 0 );
	
	wait 1;
	
	//self thread bp1_hip1_rappel();
	
	self.b_rappel_done = false;
	
	wait 5;
	
	self.b_rappel_done = true;
	
	s_start = getstruct( "hip1_bp1_circle02", "targetname" );
	
	self thread bp1_hip_circle( s_start );
	self thread hip_attack();
	
	s_start = undefined;
	
	flag_wait( "attack_cache_bp1" );
	
	self notify( "stop_attack" );
	
	wait 2;
	
//	cache_bp1_dest = GetEnt( "bp1_cache_heli_target", "targetname" );
//	self thread hip_attack_cache( cache_bp1_dest );
//		
//	flag_wait( "cache_destroyed_bp1" );
//	
//	self notify( "stop_attack" );
	//self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	//s_start = getstruct( "bp1_sentry_goal01", "targetname" );
	
	//self thread bp1_hip_circle( s_start );
	self thread hip_attack();
}


bp1_hip1_rappel()
{	
	self endon( "death" );
	
	s_rappel_point = spawnstruct();
	s_rappel_point.origin = self.origin + ( AnglesToForward( self.angles ) * 135 ) - ( AnglesToRight( self.angles ) * 55 ) + ( 0, 0, -155 );
	
	sp_rappell = GetEnt( "bp1_hip1_rappel", "targetname" );
	//sp_rappell add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_point, true, false );
		
	spawn_manager_enable( "manager_wave1bp1_rappel1" );
}


bp1_rappel_logic()
{
	self endon( "death" );
	
	self.bp_ai = true;
}


hip2_bp1_logic()
{
	self endon( "death" );
	
	self.overrideVehicleDamage = ::heli_vehicle_damage;
	
	self SetVehicleAvoidance( true );
	self SetForceNoCull();
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self thread bp1_vehicle_destroyed();
	self thread heli_select_death();
	self thread nag_destroy_vehicle();
	
	set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, self, "destroy", -1 );
		
	s_goal01 = getstruct( "hip2_bp1_goal01", "targetname" );
	s_goal02 = getstruct( "hip2_bp1_goal02", "targetname" );
	s_goal03 = getstruct( "hip2_bp1_goal03", "targetname" );
	s_goal04 = getstruct( "hip2_bp1_goal04", "targetname" );
		
	self SetNearGoalNotifyDist( 500 );
	
	self setspeed( 50, 20, 10 );
	self setvehgoalpos( s_goal01.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal01 = undefined;
	
	self setvehgoalpos( s_goal02.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal02 = undefined;
	
	self setvehgoalpos( s_goal03.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal03 = undefined;
	
	self setvehgoalpos( s_goal04.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	s_goal04 = undefined;
	
	s_start = getstruct( "hip1_bp1_circle05", "targetname" );
	
	self thread bp1_hip_circle( s_start );
	self thread hip_attack();
	
	flag_wait( "attack_cache_bp1" );
	
	self notify( "stop_attack" );
	
	wait 2;
	
//	cache_bp1_dest = GetEnt( "bp1_cache_heli_target", "targetname" );
//	self thread hip_attack_cache( cache_bp1_dest );
//	
//	flag_wait( "cache_destroyed_bp1" );
//	
//	self notify( "stop_attack" );
	//self notify( "stop_circle" );
	
	self clear_turret_target( 2 );
	
	//s_start = getstruct( "bp1_sentry_goal01", "targetname" );
	
	//self thread bp1_hip_circle( s_start );
	self thread hip_attack();
}


bp1_hip_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	
	self SetSpeed( 50, 25, 20 );
	
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin );
		self waittill_any( "goal", "near_goal" );
		
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


bp1_crew_spawn()
{
	sp_launcher = GetEnt( "bp1_launcher", "targetname" );
	
	ai_launcher = sp_launcher spawn_ai( true );
	ai_launcher thread magic_bullet_shield();
	ai_launcher.ignoreall = true;
	
	flag_wait( "crew_showoff" );
	
	ai_launcher thread bp1_crew_showoff();
}


bp1_crew_showoff()  //self = rpg crew
{
	self endon( "death" );
	
	e_fire = GetEnt( "crew_rpg_fire", "targetname" );
	e_target = GetEnt( "crew_rpg_target", "targetname" );
	
	wait 0.1;
	
	e_rocket = MagicBullet( "rpg_magic_bullet_sp", e_fire.origin, e_target.origin );
		
	e_rocket thread crew_rocket_explode();
	
	e_fire Delete();
	e_target Delete();
	
	self thread crew_rpg_logic();
	
	self stop_magic_bullet_shield();
}


#using_animtree( "generic_human" );
crew_rocket_explode()
{
	self waittill( "death" );
	
	PlayFX( level._effect[ "explode_grenade_sand" ], self.origin );
	
	Earthquake( 0.2, 1, level.player.origin, 100 );
	
	ai_victim = GetEnt( "bp1_initial_guard_ai", "targetname" );
	
	if ( IsAlive( ai_victim ) )
	{
		ai_victim stop_magic_bullet_shield();
		
		ai_victim.deathanim = %death_explosion_right13;
		
		RadiusDamage( ai_victim.origin, 100, ai_victim.health, ai_victim.health, undefined, "MOD_PROJECTILE" );
	}
	
	level.zhao say_dialog( "muj0_enemy_killed_0", 1 );	//Enemy killed
}


defend_bp1_logic()
{
	self endon( "death" );
	
	self.bp_ai = true;
	
	self set_force_color( "o" );
}


initial_bp1_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self.bp_ai = true;
	
	self set_force_color( "p" );
}


reinforce_bp1_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self.bp_ai = true;
	self set_force_color( "p" );
}


fixed_bp1_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self thread force_goal();
	
	self.bp_ai = true;
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	self set_fixednode( true );
}


bp1_rooftop_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self thread force_goal();
	
	self.bp_ai = true;
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	self set_fixednode( true );
}


roof_jumper_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self thread force_goal( ( 6504, -19405, -251 ), 32, false );
	
	self.bp_ai = true;
	
	self waittill( "goal" );
	
	self set_fixednode( true );
}


victim_bp1_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self thread force_goal();
	self thread magic_bullet_shield();
	
	self.bp_ai = true;
	
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	self set_fixednode( true );
}


assault_bp1_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self.bp_ai = true;
	self set_force_color( "p" );
}


bp1wave1_monitor_soviets()
{
	level.n_bp1wave1_soviet_killed++;
	
	if ( level.n_bp1wave1_soviet_killed > 11 && !flag( "attack_crew_bp1" ) )
	{
		flag_set( "attack_crew_bp1" );
		flag_set( "attack_cache_bp1" );
			
		level thread monitor_cache_bp1();
	}
	
	return false;
}


monitor_enemy_bp1()
{
	trigger_use( "triggercolor_soviet_entrance" );
	
	spawn_manager_enable( "manager_initial_bp1" );
	
	sp_guard1 = GetEnt( "bp1_cache_guard1", "targetname" );
	sp_guard2 = GetEnt( "bp1_cache_guard2", "targetname" );
	
	sp_guard1 spawn_ai( true );
		
	trigger_wait( "zhao_to_town" );
	
	trigger_use( "triggercolor_soviet_cache" );
	
	flag_set( "goto_town" );
	
	flag_wait( "tower_fall" );
	
	ai_cache_guard2 = sp_guard2 spawn_ai( true );
	
	if ( IsDefined( ai_cache_guard2 ) )
	{
		ai_cache_guard2 thread crosser_logic();
	}
	
	trigger_wait( "zhao_to_weapons" );
	
	sp_sniper = GetEnt( "bp1_initial_sniper", "targetname" );
	ai_sniper = sp_sniper spawn_ai( true );
	
	spawn_manager_enable( "manager_soviet_bp1" );
	
	flag_wait( "soviet_fallback" );
	
	spawn_manager_kill( "manager_initial_bp1" );
	
	level thread spawn_tower_guys();
	
	trigger_use( "triggercolor_soviet_crosstown" );
	
	spawn_manager_disable( "manager_soviet_bp1" );
	
	wait 3;
	
	spawn_manager_enable( "manager_bp1_reinforce" );
	
	wait 7;
	
	flag_set( "spawn_vehicles_bp1" );
	
	wait 6;
	
	flag_set( "spawn_btr2_bp1" );
	
	autosave_by_name( "bp1_vehicle_spawn" );
	
	flag_wait( "wave1_done" );
	
	trigger_use( "triggercolor_crosstown" );
	
	spawn_manager_enable( "manager_muj_advance" );
	//spawn_manager_enable( "manager_bp1_last_troops" );
	
	spawn_manager_kill( "manager_muj_bp1" );
	
	wait 5;
	
	spawn_manager_kill( "manager_soviet_bp1" );
	spawn_manager_kill( "manager_bp1_reinforce" );
	spawn_manager_kill( "manager_bp1_last_troops" );
		
	flag_wait( "wave1_complete" );
	
	spawn_manager_kill( "manager_muj_advance" );
	//spawn_manager_kill( "manager_muj_bp1" );
	//spawn_manager_kill( "manager_soviet_bp1" );
	//spawn_manager_kill( "manager_bp1_reinforce" );
	//spawn_manager_kill( "manager_bp1_last_troops" );
}


crosser_logic()
{
	self endon( "death" );
	
	self thread force_goal( ( 6492, -18995, -203 ), 64 );
}


spawn_tower_guys()
{
	t_tower_guys = GetEnt( "spawn_tower_guys", "script_noteworthy" );
	
	t_tower_guys waittill( "trigger" );
	
	sp_rooftop = GetEnt( "bp1_tower_rooftop", "targetname" );
	sp_rooftop spawn_ai( true );
	
	wait 2;
	
	sp_diver = GetEnt( "bp1_tower_diver", "targetname" );
	sp_diver spawn_ai( true );
}


reinforce1_bp1_logic()
{
	self endon( "death" );
	
	self.deathFunction = ::bp1wave1_monitor_soviets;
	
	self.bp_ai = true;
	
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
	
	self waittill( "goal" );
	
	self reset_movemode();
}


reinforce2_bp1_logic()
{
	self endon( "death" );
	
	self.bp_ai = true;
	
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
	
	self.bp_ai = true;
	
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


monitor_cache_bp1()
{
	level endon( "cache_destroyed_bp1" );
	level endon( "wave1_complete" );
	
	cache_bp1_pris = GetEnt( "ammo_cache_BP1_pristine", "targetname" );
	cache_bp1_dmg = GetEnt( "ammo_cache_BP1_damaged", "targetname" );
	cache_bp1_dest = GetEnt( "ammo_cache_BP1_destroyed", "targetname" );
	cache_bp1_clip = GetEnt( "ammo_cache_BP1_clip", "targetname" );
	cache_bp1_origin = GetEnt( "bp1_cache_origin", "targetname" );
	
	cache_bp1_pris SetCanDamage( true );
	
	n_cache_health = 100;
	
	b_under_attack = false;
	b_down_50 = false;
	b_down_25 = false;
	b_destroyed = false;
	
	cache = cache_bp1_pris;
	
	while( 1 )
	{
		cache waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "apc_btr60" )
		{
			n_cache_health -= 0.5;
		}
		
		if ( IsDefined( attacker.vehicletype ) && attacker.vehicletype == "heli_hip" )
		{
			n_cache_health -= 0.5;
		}
		
		if ( ( type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" ) )
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
				b_under_attack = true;
    				
				//level.woods say_dialog( "wood_they_re_targeting_th_0", 1 );	//They?re targeting the weapons cache!
			}
		}
		
		if ( n_cache_health < 50 )
		{
			if ( !b_down_50 )
			{
				b_down_50 = true;
				
				cache_bp1_dmg SetCanDamage( true );
				cache = cache_bp1_dmg;
				
				cache_bp1_pris Delete();
				cache_bp1_dmg Show();
				
				PlayFX( level._effect[ "cache_dmg" ], cache_bp1_dmg.origin );
				
				//level.zhao say_dialog( "zhao_the_cache_is_taking_0", 0 );		//The cache is taking too much damage!
			}
		}
	
		if ( n_cache_health < 25 )
		{
			if ( !b_down_25 )
			{
				b_down_25 = true;
				
				//level.woods say_dialog( "wood_we_re_losing_it_mas_0", 0 );	//We?re losing it, Mason!
			}
		}
		
		if ( n_cache_health < 1 )
		{
			if ( !b_destroyed )
			{
				b_destroyed = true;
				
				PlayFX( level._effect[ "cache_dest" ], cache_bp1_dest.origin );
				
				wait 0.1;
				
				cache_bp1_dest Show();
				cache_bp1_dmg Delete();
				cache_bp1_clip Delete();
				cache_bp1_origin Delete();
				
				level.caches_lost++;
	    
    				//level.zhao say_dialog( "zhao_the_weapon_cache_has_0", 1 );	//The weapon cache has been destroyed!
				
				//level.woods say_dialog( "wood_dammit_we_lost_thi_0", 0.5 );	//Dammit!  We lost this one!
				
				flag_set( "cache_destroyed_bp1" );
			}
		}
	}
}


monitor_cache_bp1exit()
{
	cache_pris = GetEnt( "ammo_cache_arena_4_pristine", "targetname" );
	cache_dmg = GetEnt( "ammo_cache_arena_4_damaged", "targetname" );
	cache_dest = GetEnt( "ammo_cache_arena_4_destroyed", "targetname" );
	cache_clip = GetEnt( "ammo_cache_arena_4_clip", "targetname" );
	
	cache_dest SetCanDamage( true );
	
	n_cache_health = 100;
	
	b_under_attack = false;
	b_down_50 = false;
	b_down_25 = false;
	b_destroyed = false;
	
	cache = cache_dest;
	
	while( 1 )
	{
		cache waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
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
				b_under_attack = true;
			}
		}
		
		if ( n_cache_health < 50 )
		{
			if ( !b_down_50 )
			{
				b_down_50 = true;
				
				cache_dmg SetCanDamage( true );
				
				cache_pris Delete();
				cache_dmg Show();
				
				cache = cache_dmg;
				
				PlayFX( level._effect[ "cache_dmg" ], cache_dmg.origin );
			}
		}
	
		if ( n_cache_health < 25 )
		{
			if ( !b_down_25 )
			{
				b_down_25 = true;
			}
		}
		
		if ( n_cache_health < 1 )
		{
			if ( !b_destroyed )
			{
				b_destroyed = true;
				flag_set( "cache4_destroyed" );
				PlayFX( level._effect[ "cache_dest" ], cache_dest.origin );
				wait 0.1;
				cache_dest Show();
				cache_dmg Delete();
				cache_clip Delete();
				
				level.caches_lost++;
			}
		}
	}
}


bp1_vehicle_destroyed()
{
	self waittill( "death", attacker );
	
	set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, self, "remove" );
	
	level.n_bp1_veh_destroyed++;
	
	wait 0.2;
	
	set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, undefined, undefined, level.n_bp1_veh_destroyed );
	
	if ( level.n_bp1_veh_destroyed == 1 )
	{
		level.player say_dialog( "maso_the_btr_s_history_0", 0.5 );	//The BTR?s history!
		
		level.woods say_dialog( "wood_fucking_a_0", 0.5 );	//Fucking - A!
		
		level.zhao say_dialog( "muj0_cheer_0", 1 );	//Cheer!
	}
		
	if ( level.n_bp1_veh_destroyed > 1 )
	{
		flag_set( "wave1_done" );
				
		set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, undefined, "done" );
		set_objective( level.OBJ_AFGHAN_BP1_VEHICLES, undefined, "delete" );
		
		level.zhao say_dialog( "muj0_rejoicing_0", 1 );		//Rejoicing!
	}
	
	autosave_by_name( "bp1_vehicle_destroyed" );
}
