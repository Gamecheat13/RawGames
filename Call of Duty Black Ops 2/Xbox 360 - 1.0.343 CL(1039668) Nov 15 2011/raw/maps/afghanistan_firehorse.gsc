#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\afghanistan_utility;
#include maps\_horse;
#include maps\_vehicle;
#include maps\_vehicle_aianim;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/
init_flags()
{
	flag_init( "playerat_exit" );
	flag_init( "start_firehorse" );
	flag_init( "player_pickup" );
	flag_init( "player_onhorse" );
	flag_init( "zhao_mount" );
	flag_init( "mig_spawned" );
	flag_init( "arena_mig1" );
	flag_init( "arena_overlook" );
	flag_init( "firehorse_done" );
	
	flag_init( "hip3_troops_spawned" );
	flag_init( "monitor_hip3" );
	flag_init( "hip3_spawned" );
	flag_init( "hip4_spawned" );
	flag_init( "hip4_troops_spawned" );
	flag_init( "stop_arena_explosions" );
	
	flag_init( "zhao_at_bp1" );
}


init_spawn_funcs()
{
	add_spawn_function_veh( "muj_horse_start1", ::muj_horse_logic );
	add_spawn_function_veh( "muj_horse_start2", ::muj_horse_logic );
	add_spawn_function_veh( "muj_horse_start3", ::muj_horse_logic );
	add_spawn_function_veh( "muj_horse_start4", ::muj_horse_logic );
	add_spawn_function_veh( "muj_horse_start5", ::muj_horse_logic );
	add_spawn_function_veh( "firehorse_mason", ::firehorse_mason_logic );
	add_spawn_function_veh( "flaming_horse", ::flaming_horse_logic );
	add_spawn_function_veh( "mig23_firehorse", ::mig23_flyby_logic );
	add_spawn_function_veh( "mig23_overbase", ::mig23_overbase_logic );
	add_spawn_function_veh( "arena_hip1", ::hip_arena_takeoff_logic );
	add_spawn_function_veh( "arena_hip2", ::hip2_arena_land );
	add_spawn_function_veh( "arena_uaz1", ::uaz1_arena_logic );
	add_spawn_function_veh( "arena_uaz2", ::uaz2_arena_logic );
	
	add_spawn_function_group( "tunnel_runner_exp", "script_noteworthy", ::tunnel_runner_logic );
	add_spawn_function_group( "corral_jumper", "targetname", ::corral_jumper_logic );
	add_spawn_function_group( "tunnel_runner_delete", "script_noteworthy", ::runners_logic );
	add_spawn_function_group( "rooftop_mig_shooter", "targetname", ::rooftop_shooter_logic );
	add_spawn_function_group( "muj_rider_base", "targetname", ::muj_rider_base_logic );
	add_spawn_function_group( "hip3_troops", "targetname", ::hip3_guy_logic );
	add_spawn_function_group( "hip4_troops", "targetname", ::hip4_guy_logic );
	add_spawn_function_group( "base_guard", "targetname", ::arena_guy_logic );
	add_spawn_function_group( "muj_guard", "targetname", ::arena_guy_logic );
	add_spawn_function_group( "first_arena_enemy", "targetname", ::arena_guy_logic );
}


event_setup_firehorse()
{
	t_exit = getent( "tunnel_exit", "targetname" );
	t_exit trigger_on();
		
	t_horse = getent( "trigger_base_horse", "targetname" );
	t_horse trigger_on();
	
	t_overlook = getent( "player_at_overlook", "targetname" );
	t_overlook trigger_on();
	
	t_mig = getent( "mig_in_face", "targetname" );
	t_mig trigger_on();
	
	init_weapon_cache();
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_firehorse()
{
	skipto_setup();

	init_hero( "zhao" );
	init_hero( "woods" );
	init_hero( "hudson" );
	init_hero( "rebel_leader" );
	
	start_teleport( "skipto_firehorse", level.heroes );
	
	//level thread maps\_unit_command::load();
}


objectives_firehorse()
{
	set_objective( level.OBJ_AFGHAN_BP1, level.zhao, "follow" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
main()
{
	event_setup_firehorse();
	init_spawn_funcs();
	
	level thread run_firehorse_anims();
	level thread zhao_logic();
	level thread explosion_base();
	level thread ambience_manager();
	
	if ( IsDefined( level.muj_tank ) )
	{
		level.muj_tank thread muj_tank_behavior();
	}
	
	spawn_manager_enable( "base_tunnel" );
	spawn_manager_enable( "manager_rooftop_shooters" );
	
	flag_wait( "firehorse_done" );
}


/* ------------------------------------------------------------------------------------------
	Anim functions begin
-------------------------------------------------------------------------------------------*/
run_firehorse_anims()
{
	//level thread run_scene( "e3_horses_waiting" );
	
	level thread map_room_exit_anim();
	level thread zhao_firehorse_anim();
	//level thread base_explosion_playeranim();
	//level thread zhao_pickup_player_anim();
	//level thread base_explosion_horses();
	//level thread firehorse_anim();
}


zhao_firehorse_anim()
{
	trigger_use( "map_room_exit" );  //spawn player and Zhao's horses
	
	run_scene( "e3_exit_map_room_zhao" );
	level thread run_scene( "e3_zhao_exit_idle" );
	
	flag_wait( "playerat_exit" );

	run_scene( "e3_exit_cave_zhao" );
}


map_room_exit_anim()
{
	run_scene( "e3_exit_map_room" );
	level thread run_scene( "e3_map_room_idle" );
}


base_explosion_playeranim()
{
	trigger_wait( "trigger_player_knockdown" );
	
	run_scene( "e3_player_base_explosion" );
}


zhao_pickup_player_anim()
{
	//flag_wait( "player_pickup" );
	
	//run_scene( "e3_zhao_pickup" );
	run_scene( "e3_calm_horses" );
	
	//flag_set( "zhao_mount" );
	//level thread run_scene( "e3_zhao_horses_idle" );
	
	//flag_wait( "player_onhorse" );
	
	//end_scene( "e3_zhao_horses_idle" );
}


base_explosion_horses()
{
	trigger_wait( "trigger_player_knockdown" );
	
	end_scene( "e3_horses_waiting" );
	
	run_scene( "e3_horses_explosion" );
}


firehorse_anim()
{
	flag_wait( "start_firehorse" );
		
	run_scene( "e3_firehorse" );
}


/* ------------------------------------------------------------------------------------------
	Anim functions end
-------------------------------------------------------------------------------------------*/

	
#using_animtree( "horse" );
flaming_horse_logic()
{
	PlaySoundAtPosition( "wpn_rocket_explode", self.origin );
	PlayFX( level._effect[ "explode_mortar_sand" ], self.origin );
	Earthquake( 0.3, 2, level.player.origin, 100 );
	
	e_fire_tag = getent( "tag_firehorse", "targetname" );
	e_fire_tag LinkTo( self, "Bone_H_Saddle", ( 0, 0, 12 ) );
	
	PlayFXOnTag( level._effect[ "fire_horse" ], e_fire_tag, "tag_origin" );
	e_fire_tag playsound( "evt_horse_pain_vox" );
	e_fire_tag playloopsound( "evt_horse_fire", .25 );
	
	nd_jump = GetVehicleNode( "firehorse_jump", "targetname" );
	nd_jump waittill( "trigger" );
	
	self LaunchVehicle( (0, 0, 270), (0,0,0), 1 );

	self waittill( "reached_end_node" );
	
	e_fire_tag playsound( "evt_horse_death_vox" );
	
	t_mig23 = GetEnt( "trigger_firehorse_mig", "targetname" );
	t_mig23 notify( "trigger" );
	
	s_kill = getstruct( "flaming_horse_goal", "targetname" );
	
	RadiusDamage( s_kill.origin, 100, self.health, self.health );
	
	Earthquake( 0.3, 2, level.player.origin, 100 );
	
	wait 0.5;
	
	level notify( "fxanim_water_tower_start" );
		
	flag_wait( "wave1_done" );
	
	self delete();
}


muj_horse_logic()
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	
	self thread horse_remove();
	
	s_charge = getstruct( "muj_horse_charge1", "targetname" );
	
	s_goal1 = getstruct( "muj_horse_goal1_left", "targetname" );
	s_goal2 = getstruct( "muj_horse_goal2_left", "targetname" );
	s_goal3 = getstruct( "muj_horse_goal3_left", "targetname" );
	
	if ( self.script_noteworthy == "horse4" || self.script_noteworthy == "horse5" )
	{
		s_goal1 = getstruct( "muj_horse_goal1_right", "targetname" );
		s_goal2 = getstruct( "muj_horse_goal2_right", "targetname" );
		s_goal3 = getstruct( "muj_horse_goal3_right", "targetname" );
	}
	
	if ( self.script_noteworthy == "horse1" )
	{
		s_charge = getstruct( "muj_horse_charge2", "targetname" );
	}
	
	else if ( self.script_noteworthy == "horse2" )
	{
		s_charge = getstruct( "muj_horse_charge2", "targetname" );
	}
	
	else if ( self.script_noteworthy == "horse3" )
	{
		s_charge = getstruct( "muj_horse_charge3", "targetname" );
	}
	
	else if ( self.script_noteworthy == "horse4" )
	{
		s_charge = getstruct( "muj_horse_charge4", "targetname" );
	}
	
	else if ( self.script_noteworthy == "horse5" )
	{
		s_charge = getstruct( "muj_horse_charge5", "targetname" );
	}
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetSpeed( 25, 15, 10 );
	self setvehgoalpos( s_charge.origin, 1, true );
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	flag_wait( "arena_overlook" );
	
	self SetBrake( false );
	
	self setvehgoalpos( s_charge.origin + ( -1600, 0, 0 ), 0, true );
	self waittill_any( "goal", "near_goal" );
	
	while( 1 )
	{
		self setvehgoalpos( s_goal1.origin, 0, true );
		self waittill_any( "goal", "near_goal" );
		self setvehgoalpos( s_goal2.origin, 0, true );
		self waittill_any( "goal", "near_goal" );
		self setvehgoalpos( s_goal3.origin, 0, true );
		self waittill_any( "goal", "near_goal" );
	}
}


horse_remove()
{
	flag_wait( "wave3_done" );
	
	self delete();	
}


muj_rider_base_logic()
{
	self endon( "death" );
	
	self waittill( "enter_vehicle", vehicle );
	
	vehicle notify( "groupedanimevent", "ride" );
	
	self maps\_horse_rider::ride_and_shoot( vehicle );
	
	self.arena_guy = true;
}


arena_guy_logic()
{
	self endon( "death" );
	
	self.arena_guy = true;
}


mig23_arena_strafe()
{
	flag_wait( "arena_mig1" );
	
	s_mig23 = getstruct( "arena_mig1_start", "targetname" );
	s_mig23_mid = getstruct( "arena_mig1_mid", "targetname" );
	s_mig23_end = getstruct( "arena_mig1_end", "targetname" );
	
	vh_mig23 = spawn_vehicle_from_targetname( "mig23_spawner" );
	vh_mig23.origin = s_mig23.origin;
	vh_mig23.angles = s_mig23.angles;
	
	Target_Set( vh_mig23, ( -230, 0, -12 ) );
	
	vh_mig23 endon( "death" );
	
	vh_mig23 SetNearGoalNotifyDist( 600 );
	vh_mig23 setspeed( 300, 150, 100 );
	
	vh_mig23 setvehgoalpos( s_mig23_mid.origin );
	
	vh_mig23 waittill_any( "goal", "near_goal" );
	
	//vh_mig23 thread arena_mig1_bombs();
	
	vh_mig23 setvehgoalpos( s_mig23_end.origin );
	
	vh_mig23 waittill_any( "goal", "near_goal" );
	
	vh_mig23 delete();
}


arena_mig1_bombs()
{
	self endon( "death" );
	
	s_bomb1 = getstruct( "arena_mig1_bomb1", "targetname" );
	s_bomb2 = getstruct( "arena_mig1_bomb2", "targetname" );
	s_bomb3 = getstruct( "arena_mig1_bomb3", "targetname" );
	s_bomb4 = getstruct( "arena_mig1_bomb4", "targetname" );
	
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb1.origin );
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb1.origin );
	RadiusDamage( s_bomb1.origin, 500, 1000, 800 );
	
	wait 0.5;
	
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb2.origin );
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb2.origin );
	RadiusDamage( s_bomb2.origin, 500, 1000, 800 );
	
	wait 0.5;
	
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb3.origin );
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb3.origin );
	RadiusDamage( s_bomb3.origin, 500, 1000, 800 );
	
	wait 0.5;
	
	PlaySoundAtPosition( "wpn_rocket_explode", s_bomb4.origin );
	PlayFX( level._effect[ "explode_mortar_sand" ], s_bomb4.origin );
	RadiusDamage( s_bomb4.origin, 500, 1000, 800 );
}


mig23_flyby_logic()
{
	flag_set( "mig_spawned" );
	
	self setcandamage( false );
	
	self thread first_mig_bombs();
	
	s_delete = getstruct( "first_mig_delete", "targetname" );
	
	self setspeedimmediate( 250 );
	
	self SetNearGoalNotifyDist( 500 );
		
	self setvehgoalpos( s_delete.origin, 0 );
	                   
	self waittill_any( "goal", "near_goal" );
	
	self delete();
	
	wait 2;
	
	level thread migs_flyover_base();
	level thread migs_flyover_arena();
}


first_mig_bombs()
{
	s_bomb1 = getstruct( "mig23_bomb_exp1", "targetname" );
	s_bomb2 = getstruct( "mig23_bomb_exp2", "targetname" );
	
	wait 2;
	
	PlayFX( level._effect[ "explode_large_sand" ], s_bomb1.origin );
	Earthquake( 0.4, 2.5, level.player.origin, 100 );
	
	self thread shootat_mig23_flyby();
	
	wait 1;
	
	PlayFX( level._effect[ "explode_large_sand" ], s_bomb2.origin );
	Earthquake( 0.5, 3.0, level.player.origin, 100 );
}


migs_flyover_base()
{
	level endon( "end_base_migs" );
	
	a_s_mig_start = getstructarray( "mig_base_flyover1", "targetname" );
	a_s_mig_delete = getstructarray( "mig_flyover_delete1", "targetname" );
			
	if ( cointoss() )
	{
		a_s_mig_start = getstructarray( "mig_base_flyover2", "targetname" );
		a_s_mig_delete = getstructarray( "mig_flyover_delete2", "targetname" );
	}
	
	while( 1 )
	{
		s_mig_start = a_s_mig_start[ RandomInt( a_s_mig_start.size ) ];
		s_mig_delete = a_s_mig_delete[ RandomInt( a_s_mig_delete.size ) ];
		
		vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
		vh_mig.origin = s_mig_start.origin;
		vh_mig.angles = s_mig_start.angles;
		
		Target_Set( vh_mig, ( -230, 0, -12 ) );
		
		vh_mig thread mig_flyover_goal( s_mig_delete );
		
		wait RandomFloatRange( 6.0, 9.0 );
	}
}


migs_flyover_arena()
{
	level endon( "end_arena_migs" );
	
	flag_wait( "arena_overlook" );
	
	while( 1 )
	{
		n_index = RandomIntRange( 1, 4 );
	
		a_s_arena_start = getstructarray( "mig_arena_flyover"+n_index, "targetname" );
		a_s_arena_delete = getstructarray( "mig_arena_delete"+n_index, "targetname" );
	
		s_arena_start = a_s_arena_start[ RandomInt( a_s_arena_start.size ) ];
		s_arena_delete = a_s_arena_delete[ RandomInt( a_s_arena_delete.size ) ];
		n_waittime = RandomFloatRange( 6.0, 9.0 );
		
		vh_mig = spawn_vehicle_from_targetname( "mig23_spawner" );
		vh_mig.origin = s_arena_start.origin;
		vh_mig.angles = s_arena_start.angles;
		
		Target_Set( vh_mig, ( -230, 0, -12 ) );
		
		vh_mig thread mig_flyover_goal( s_arena_delete );
		
		wait n_waittime;
	}
}


mig_flyover_goal( s_goal )
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 300 );
		
	self setspeedimmediate( 400 );
		
	self setvehgoalpos( s_goal.origin, 0 );
		
	self waittill_any_or_timeout( 5, "goal", "near_goal" );
		
	self delete();
}


shootat_mig23_flyby()
{
	s_shootat = getstruct( "mig_shootat", "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_shootat.origin + ( 0, 0, 80 ), self.origin );
	
	fire_guns_base();
		
	wait 2;
	
	fire_stingers_base();
}


fire_stingers_base()
{
	a_s_stingers_right = getstructarray( "stinger_shootat_right", "targetname" );
	a_s_stingers_left = getstructarray( "stinger_shootat_left", "targetname" );
	
	array_thread( a_s_stingers_right, ::shoot_stingers, 0 );
	array_thread( a_s_stingers_left, ::shoot_stingers, 1 );
}


fire_guns_base()
{
	a_s_guns_left = getstructarray( "gun_shootat_left", "targetname" );
	a_s_guns_right = getstructarray( "gun_shootat_right", "targetname" );
	
	array_thread( a_s_guns_right, ::shoot_guns, 0 );
	array_thread( a_s_guns_left, ::shoot_guns, 1 );
}


shoot_stingers( n_side )
{
	level endon( "stop_stingers_base" );
	
	while( 1 )
	{
		if ( n_side )
		{
			v_target = ( RandomIntRange( -100, -50 ), RandomIntRange( 0, 200 ), RandomIntRange( 50, 400 ) );
		}
		else
		{
			v_target = ( RandomIntRange( -100, -50 ), RandomIntRange( -200, 0 ), RandomIntRange( 50, 400 ) );
		}
		
		MagicBullet( "rpg_magic_bullet_sp", self.origin, self.origin + v_target );
		
		wait RandomFloatRange( 5.0, 10.0 );
	}
}


shoot_guns( n_side )
{
	level endon( "stop_guns_base" );
	
	while( 1 )
	{
		if ( n_side )
		{
			v_target = ( RandomIntRange( -100, -50 ), RandomIntRange( 0, 200 ), RandomIntRange( 50, 400 ) );
		}
		else
		{
			v_target = ( RandomIntRange( -100, -50 ), RandomIntRange( -200, 0 ), RandomIntRange( 50, 400 ) );
		}
		
		n_burst = RandomIntRange( 5, 12 );
		
		for ( i = 0; i < n_burst; i++ )
		{
			MagicBullet( "ak47_sp", self.origin, self.origin + v_target );
			wait 0.1;
		}
		
		wait RandomFloatRange( 5.0, 10.0 );
	}
}


mig23_overbase_logic()
{
	self endon( "death" );
	
	level.player playsound( "evt_flyover_overwatch" );
	
	nd_bomb = getvehiclenode( "mig23_over_base", "targetname" );
	s_bomb1 = getstruct( "mig23_overbase_exp1", "targetname" );
	s_bomb2 = getstruct( "mig23_overbase_exp2", "targetname" );
	
	nd_bomb waittill( "trigger" );
	
	PlayFX( level._effect[ "explode_large_sand" ], s_bomb1.origin );
	Earthquake( 0.2, 1.5, level.player.origin, 100 );
	
	wait 1;
	
	PlayFX( level._effect[ "explode_large_sand" ], s_bomb2.origin );
	Earthquake( 0.1, 1, level.player.origin, 100 );
}


#using_animtree( "generic_human" );
tunnel_runner_logic()
{
	self endon( "death" );
	
	self.deathanim = %death_explosion_run_B_v1;
	self.goalradius = 120;
	
	self waittill( "goal" );
	
	s_killer = getstruct( "tunnel_runner_killer", "targetname" );
	PlayFX( level._effect[ "explode_large_sand" ], s_killer.origin );
	
	self dodamage( self.health, s_killer.origin );
}


runners_logic()
{
	self endon( "death" );
	
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	self die();
}


corral_jumper_logic()
{
	self endon( "death" );
	
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	self die();
}


rooftop_shooter_logic()
{
	self endon( "death" );
	
	self thread rooftop_delete_guy();
	
	flag_wait( "mig_spawned" );
	
	while( 1 )
	{
		a_vh_migs = getentarray( "mig_base", "targetname" );
		
		if ( a_vh_migs.size )
		{
			vh_mig = a_vh_migs[ 0 ];
			
			self shoot_at_target( vh_mig, undefined, undefined, RandomFloatRange( 3.0, 6.0 ) );
		}
		
		wait 0.1;
	}
}


rooftop_delete_guy()
{
	self endon( "death" );
	
	flag_wait( "arena_overlook" );
	
	self delete();
}


firehorse_mason_logic()
{
	level.player_horse = self;
		
	level thread player_horse_fx();
	level thread arena_explosion_fx();
	level thread player_arena_overlook();
	level thread mig_scares_horse();
	
	level.player_horse MakeVehicleUsable();
	
	flag_wait( "playerat_exit" );
	
	self.target_pos = spawn( "script_model", self.origin + ( 0, 0, 72 ) );
	self.target_pos SetModel( "tag_origin" );
	self.target_pos LinkTo( self );
	
	set_objective( level.OBJ_FOLLOW, self.target_pos, "use" );
	
	level.player_horse waittill( "enter_vehicle", player );
	
	level thread get_on_horse_explosion();
	
	self.target_pos Delete();
	set_objective( level.OBJ_FOLLOW, self, "remove" );
	
	flag_set( "player_onhorse" );
	
	autosave_by_name( "player_horse" );
	
	flag_wait( "arena_overlook" );
	
	wait 0.8;
	
	self SetBrake( true );
	
	self horse_rearback();
	
	wait 1;
	
	self SetBrake( false );
}


get_on_horse_explosion()
{
	wait 2.5;
	s_explosion = getstruct( "get_on_horse_explosion", "targetname" );
	PlayFX( level._effect[ "explode_mortar_sand" ], s_explosion.origin );
	Earthquake( 0.2, 1.5, level.player.origin, 100 );	
}


player_arena_overlook()
{
	trigger_wait( "player_at_overlook" );
	
	flag_set( "arena_overlook" );
	
	level thread remove_maproom_personnel();
}


mig_scares_horse()
{
	trigger_wait( "mig_in_face" );
	
	//level thread hip2_arena_land();
	level thread hip3_arena_land();
}


hip3_guy_logic()
{
	self endon( "death" );
	
	self.arena_guy = true;
	
	flag_set( "hip3_troops_spawned" );
}


hip4_guy_logic()
{
	self endon( "death" );
	
	self.arena_guy = true;
	
	flag_set( "hip4_troops_spawned" );
}


player_horse_fx()
{
	a_s_explosion = getstructarray( "explosion_player", "targetname" );
	
	foreach( s_explosion in a_s_explosion )
	{
		s_explosion thread player_explosion_fx();
	}
}


player_explosion_fx()
{
	while( ( Distance2D( level.player.origin, self.origin ) ) > 500 )
	{
		wait 0.05;	
	}
	
	playsoundatposition( "wpn_grenade_explode", self.origin );
	PlayFX( level._effect[ "explode_grenade_sand" ], self.origin );
	
	Earthquake( 0.2, 1, level.player.origin, 100 );
}


arena_explosion_fx()
{
	level endon( "stop_arena_explosions" );
	
	flag_wait( "arena_overlook" );
	
	a_s_explosion = getstructarray( "arena_explosion_far", "targetname" );
	
	num = a_s_explosion.size;
	
	while( 1 )
	{
		array_choice = RandomInt(num);
		PlayFX( level._effect[ "explode_mortar_sand" ], a_s_explosion[array_choice].origin );
		PlaySoundAtPosition( "wpn_rocket_explode", a_s_explosion[array_choice].origin );
		
		Earthquake( 0.2, 1, level.player.origin, 100 );
		
		wait RandomFloatRange( 2.5, 4.0 );
	}
}


stop_arena_explosions()
{
	trigger_wait( "stop_arena_explosions" );
	
	flag_set( "stop_arena_explosions" );
}


zhao_logic()
{
	s_zhao_base = getstruct( "zhao_base_entrance", "targetname" );
	s_zhao_bp1 = getstruct( "zhao_bp1_goal", "targetname" );
	s_zhao_bp2 = getstruct( "zhao_bp2", "targetname" );
	s_zhao_bp3 = getstruct( "zhao_bp3", "targetname" );
	s_zhao_charge = getstruct( "zhao_charge", "targetname" );
	nd_zhao_horse = getnode( "node_firehorse_zhao", "targetname" );
	
	level.zhao = getent( "zhao_ai", "targetname" );
	zhao = level.zhao;
	
	//TODO - temp
	level.zhao SetCanDamage( false );
	
	level thread objectives_firehorse();
	
	waittill_spawn_manager_complete( "base_tunnel" );
	
	wait 3;
	
	flag_wait( "playerat_exit" );
	
	level.player setlowready( false );
	
	level.zhao.fixednode = false;
	
	level.zhao thread force_goal( nd_zhao_horse, 32 );
	level.zhao waittill( "goal" );
	
	level.horse_zhao = getent( "firehorse_zhao", "targetname" );
	level.horse_zhao SetNearGoalNotifyDist( 64 );
	level.horse_zhao SetVehicleAvoidance( true );
	
	//flag_wait( "zhao_mount" );
	
	wait 0.5;
	
	level.zhao run_to_vehicle( level.horse_zhao );
	
	level.horse_zhao notify( "groupedanimevent", "ride" );
	
	level.zhao maps\_horse_rider::ride_and_shoot( level.horse_zhao );
	
	flag_wait( "player_onhorse" );
	
	//wait 2;
	
	level.horse_zhao SetSpeed( 25, 15, 10 );
	level.horse_zhao setvehgoalpos( s_zhao_base.origin, 1, true );
	level.horse_zhao waittill_any( "goal", "near_goal" );
	level.horse_zhao SetBrake( true );
	
	flag_wait( "arena_overlook" );
	
	level notify( "stop_base_exp" );
	level notify( "end_base_migs" );
	
	t_spawn_heli = getent( "spawn_arena_hip1", "targetname" );
	t_spawn_heli notify( "trigger" );
	
	level thread mig23_arena_strafe();
		
	spawn_manager_enable( "manager_first_arena" );
	
	//level thread blocking_point1();
	
	trigger_use( "spawn_arena_uaz1" );
	
	wait 1;
	
	trigger_use( "spawn_arena_uaz2" );
	
	wait 4;
	
	flag_set( "firehorse_done" );
	
	level.horse_zhao SetBrake( false );
	
	level.horse_zhao SetSpeed( 25, 15, 10 );
	level.horse_zhao setvehgoalpos( s_zhao_bp1.origin, 1, true );
	level.horse_zhao waittill_any( "goal", "near_goal" );
	
	level.horse_zhao SetBrake( true );
	
	level.horse_zhao SetSpeedImmediate( 0 );
	
	flag_set( "zhao_at_bp1" );
}


blocking_point1()
{
	trigger_wait( "spawn_bp1" );
	
	flag_set( "firehorse_done" );	
}


hip_arena_takeoff_logic()
{
	self endon( "death" );
	
	s_start = getstruct( "hip_takeoff_start", "targetname" );
	s_end = getstruct( "hip_takeoff_end", "targetname" );
	s_rpg = getstruct( "rpg_fireat_hip1", "targetname" );
	
	self SetNearGoalNotifyDist( 600 );
	
	wait 2;
	
	self SetSpeed( 25, 15, 10 );
	
	self SetVehGoalPos( s_start.origin, 0 );
	
	self waittill_any( "goal", "near_goal" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_rpg.origin, s_start.origin );
	
	self waittill_any_or_timeout( 2, "damage" );
	
	RadiusDamage( self.origin, 100, 5000, 5000 );
		
	self SetSpeed( 150, 20, 15 );
	
	self SetVehGoalPos( s_end.origin, 0 );
}


uaz1_arena_logic()
{
	self endon( "death" );
	
	self thread delete_corpse_arena();
	
	s_entry = getstruct( "uaz1_entry", "targetname" );
	s_goal = getstruct( "arena_goal_01", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetSpeed( 15, 5, 2 );
	
	self SetVehGoalPos( s_entry.origin, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self notify( "unload" );
	
	self waittill( "unloaded" );
	
	self SetBrake( false );
	
	self SetSpeed( 25, 5, 2 );
	
	self SetVehGoalPos( s_goal.origin, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self notify( "unload" );
	
	flag_wait( "wave3_done" );
	
	self delete();
}


uaz2_arena_logic()
{
	self endon( "death" );
	
	self thread delete_corpse_arena();
	
	s_goal1 = getstruct( "uaz2_goal_01", "targetname" );
	s_goal2 = getstruct( "uaz2_goal_02", "targetname" );
	s_goal3 = getstruct( "uaz2_goal_03", "targetname" );
	
	self SetNearGoalNotifyDist( 100 );
	
	self SetSpeed( 25, 5, 2 );
	
	self SetVehGoalPos( s_goal1.origin, 0 );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal2.origin, 0 );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal3.origin, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	self SetBrake( true );
	
	self notify( "unload" );
	
	flag_wait( "wave3_done" );
	
	self delete();
}


second_uaz_group()
{
	s_spawnpt = getstruct( "uaz_spawn_pt", "targetname" );
	vh_uaz = spawn_vehicle_from_targetname( "uaz_arena" );
		
	vh_uaz.origin = s_spawnpt.origin;
	vh_uaz.angles = s_spawnpt.angles;
	
	vh_uaz thread uaz3_goto_arena();
}


uaz3_goto_arena()
{
	self endon( "death" );
	
	self thread delete_corpse_arena();
	
	s_rpg = getstruct( "rpg_fireat_hip1", "targetname" );
	s_target = getstruct( "rpg_target_uaz", "targetname" );
	s_goto1 = getstruct( "uaz_goto_1", "targetname" );
	s_goto2 = getstruct( "uaz_goto_2", "targetname" );
	s_goto3 = getstruct( "uaz_goto_3", "targetname" );
	s_goto4 = getstruct( "uaz_goto_4", "targetname" );
	s_goto5 = getstruct( "uaz_goto_5", "targetname" );
		
	self SetNearGoalNotifyDist( 100 );
	self SetSpeed( 35, 15, 10 );
	
	self SetVehGoalPos( s_goto1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self SetVehGoalPos( s_goto2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	self SetVehGoalPos( s_goto3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goto4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	MagicBullet( "rpg_magic_bullet_sp", s_rpg.origin, s_target.origin );
	
	self thread uaz_rpg_launch();
	
	self SetVehGoalPos( s_goto5.origin, 0 );
	self waittill_any( "goal", "near_goal" );
}


uaz_rpg_launch()
{
	wait 1;
	
	self LaunchVehicle( ( 0, 0, 270 ), ( 0, 20, 20 ), true );
	
	wait 0.5;
	
	RadiusDamage( self.origin, 100, 5000, 5000 );
}


hip2_arena_land()
{
	s_hip2 = getstruct( "arena_hip2_spawn", "targetname" );
	s_hip2_start = getstruct( "arena_hip2_start", "targetname" );
	s_hip2_mid = getstruct( "arena_hip2_mid", "targetname" );
	s_hip2_dest = getstruct( "arena_hip2_destroy", "targetname" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 25, 10 );
	
	self setvehgoalpos( s_hip2_start.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_hip2_mid.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 20, 18, 15 );
	
	self setvehgoalpos( s_hip2_dest.origin, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	RadiusDamage( self.origin, 100, 5000, 5000 );
}


hip3_arena_land()
{
	s_hip3 = getstruct( "arena_hip3", "targetname" );
	s_hip3_start = getstruct( "arena_hip3_start", "targetname" );
	s_hip3_mid = getstruct( "arena_hip3_mid", "targetname" );
	s_hip3_land = getstruct( "arena_hip3_land", "targetname" );
	s_hip3_takeoff = getstruct( "arena_hip3_takeoff", "targetname" );
	s_hip3_air = getstruct( "arena_hip3_air", "targetname" );
	s_hip3_far = getstruct( "arena_hip3_far", "targetname" );
	s_hip3_end = getstruct( "arena_hip3_end", "targetname" );
	
	vh_hip3 = spawn_vehicle_from_targetname( "hip1_bp1" );
	vh_hip3.origin = s_hip3.origin;
	vh_hip3.angles = s_hip3.angles;
	
	Target_Set( vh_hip3, ( -50, 0, -32 ) );
	
	vh_hip3 SetNearGoalNotifyDist( 200 );
	
	vh_hip3 setspeed( 100, 25, 10 );
	
	vh_hip3 setvehgoalpos( s_hip3_start.origin );
	
	vh_hip3 waittill_any( "goal", "near_goal" );
	
	vh_hip3 setvehgoalpos( s_hip3_mid.origin );
	
	vh_hip3 waittill_any( "goal", "near_goal" );
	
	vh_hip3 setspeed( 20, 18, 15 );
	
	vh_hip3 setvehgoalpos( s_hip3_land.origin, 1 );
	
	vh_hip3 waittill_any( "goal", "near_goal" );
	
	vh_hip3 setspeedimmediate( 0 );
	
	wait 1;
	
	if ( !flag( "firehorse_done" ) )
	{
		spawn_manager_enable( "manager_hip3_troops" );
		
		wait 3;
	
		spawn_manager_disable( "manager_hip3_troops" );
	}
	
	vh_hip3 setspeed( 25, 10, 5 );
	
	vh_hip3 setvehgoalpos( s_hip3_takeoff.origin );
	
	vh_hip3 waittill_any( "goal", "near_goal" );
	
	vh_hip3 setspeed( 150, 25, 15 );
	
	vh_hip3 setvehgoalpos( s_hip3_air.origin );
	
	vh_hip3 waittill_any( "goal", "near_goal" );
	
	vh_hip3 thread hip3_countermeasures();
	
	vh_hip3 setspeed( 350, 35, 25 );
	
	vh_hip3 setvehgoalpos( s_hip3_far.origin );
	
	vh_hip3 waittill_any( "goal", "near_goal" );
	
	vh_hip3 setvehgoalpos( s_hip3_end.origin );
	
	vh_hip3 waittill_any( "goal", "near_goal" );
	
	vh_hip3 delete();
	
	flag_set( "monitor_hip3" );
}


hip3_replenish()
{
	s_hip3_spawn = getstruct( "hip3_factory", "targetname" );
		
	vh_hip3 = spawn_vehicle_from_targetname( "heli_hip_arena" );
	vh_hip3.origin = s_hip3_spawn.origin;
	vh_hip3.angles = s_hip3_spawn.angles;
	
	vh_hip3 thread hip3_behavior();
}


hip3_behavior()
{
	self endon( "death" );
	
	s_hip3_takeoff = getstruct( "hip3_takeoff", "targetname" );
	s_hip3_air = getstruct( "hip3_air", "targetname" );
	s_hip3_app = getstruct( "hip3_approach", "targetname" );
	s_hip3_land = getstruct( "hip3_land", "targetname" );
	
	self thread monitor_hip3();
	self thread delete_corpse_arena();
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	flag_set( "hip3_spawned" );
		
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 25, 10 );
	
	self setvehgoalpos( s_hip3_takeoff.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 150, 25, 10 );
	
	self setvehgoalpos( s_hip3_air.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 100, 25, 20 );
	
	self setvehgoalpos( s_hip3_app.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 20, 18, 15 );
	
	self setvehgoalpos( s_hip3_land.origin, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeedimmediate( 0 );
	
	wait 1;
	
	if ( !flag( "sm_manager_hip3_troops_enabled" )  )
	{
		spawn_manager_enable( "manager_hip3_troops" );
	}
	
	wait 3;
	
	spawn_manager_disable( "manager_hip3_troops" );
	
	self thread hip3_leave_arena();
}


hip3_leave_arena()
{
	self endon( "death" );
	
	s_hip3_takeoff = getstruct( "arena_hip3_takeoff", "targetname" );
	s_hip3_air = getstruct( "arena_hip3_air", "targetname" );
	s_hip3_far = getstruct( "arena_hip3_far", "targetname" );
	s_hip3_end = getstruct( "arena_hip3_end", "targetname" );
	
	self setspeed( 25, 10, 5 );
	
	self setvehgoalpos( s_hip3_takeoff.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self thread hip3_countermeasures();
	
	self setspeed( 150, 25, 15 );
	
	self setvehgoalpos( s_hip3_air.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 350, 35, 25 );
	
	self setvehgoalpos( s_hip3_far.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_hip3_end.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self delete();
}


hip3_countermeasures()
{
	s_rpg = getstruct( "rpg_fireat_hip1", "targetname" );
	MagicBullet( "rpg_magic_bullet_sp", s_rpg.origin, self.origin );
	
	wait 1;
	
	for ( i = 0; i < 5; i++ )
	{
		PlayFX( level._effect[ "aircraft_flares" ], self.origin + ( 0, 0, -120 ) );
		wait 0.25;
	}
}


hip4_replenish()
{
	s_hip_spawn = getstruct( "hip4_factory", "targetname" );
		
	vh_hip = spawn_vehicle_from_targetname( "heli_hip_arena" );
	vh_hip.origin = s_hip_spawn.origin;
	vh_hip.angles = s_hip_spawn.angles;
	
	vh_hip hip4_behavior();
}


hip4_behavior()
{
	self endon( "death" );
	
	s_hip_liftoff = getstruct( "hip4_liftoff", "targetname" );
	s_hip_air = getstruct( "hip4_air", "targetname" );
	s_hip_mid = getstruct( "hip4_mid", "targetname" );
	s_hip_approach = getstruct( "hip4_approach", "targetname" );
	s_hip_descent = getstruct( "hip4_descent", "targetname" );
	s_hip_hover = getstruct( "hip4_hover", "targetname" );
	
	self thread monitor_hip4();
	self thread delete_corpse_arena();
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	flag_set( "hip4_spawned" );
	
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 200 );
	
	self setspeed( 100, 25, 10 );
	
	self setvehgoalpos( s_hip_liftoff.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 150, 25, 10 );
	
	self setvehgoalpos( s_hip_air.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_hip_mid.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 80, 25, 20 );
	
	self setvehgoalpos( s_hip_approach.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 40, 20, 15 );
	
	self setvehgoalpos( s_hip_descent.origin, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 20, 18, 15 );
	
	self setvehgoalpos( s_hip_hover.origin, 1 );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeedimmediate( 0 );
	
	wait 1;
	
	if ( !flag( "sm_manager_hip4_troops_enabled" )  && !flag( "firehorse_done" ) )
	{
		spawn_manager_enable( "manager_hip4_troops" );
	}
	
	wait 3;
	
	spawn_manager_disable( "manager_hip4_troops" );
	
	self thread hip4_leave_arena();
}


hip4_leave_arena()
{
	self endon( "death" );
	
	s_hip_dustoff = getstruct( "hip4_dustoff", "targetname" );
	s_hip_bank = getstruct( "hip4_bank", "targetname" );
	s_hip_away = getstruct( "hip4_away", "targetname" );
	s_hip_turn = getstruct( "hip4_turn", "targetname" );
	s_hip_over = getstruct( "hip4_over", "targetname" );
	s_hip_dive = getstruct( "hip4_dive", "targetname" );
	
	self setspeed( 25, 10, 5 );
	
	self setvehgoalpos( s_hip_dustoff.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 150, 25, 15 );
	
	self setvehgoalpos( s_hip_bank.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self thread hip4_countermeasures();
	
	self setvehgoalpos( s_hip_away.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setspeed( 350, 35, 25 );
	
	self setvehgoalpos( s_hip_turn.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_hip_over.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self setvehgoalpos( s_hip_dive.origin );
	
	self waittill_any( "goal", "near_goal" );
	
	self delete();
}


hip4_countermeasures()
{
	for ( i = 0; i < 5; i++ )
	{
		PlayFX( level._effect[ "aircraft_flares" ], self.origin + ( 0, 0, -120 ) );
		wait 0.25;
	}
}


explosion_base()
{
	level thread explosion_cave_ambient();
		
	trigger_wait( "trigger_explosion_base01" );
	
	level thread spawn_base_personnel();
	
	flag_set( "playerat_exit" );
	
	s_explosion01 = getstruct( "explosion_base01", "targetname" );
	
	PlayFX( level._effect[ "explode_mortar_sand" ], s_explosion01.origin );
	PlaySoundAtPosition( "wpn_rocket_explode", s_explosion01.origin );
	Earthquake( 0.2, 2.5, level.player.origin, 100 );
	
	wait 1;
	
	level thread explosion_baseclose_manager();
	level thread explosion_basefar_manager();
}


spawn_base_personnel()
{
	trigger_wait( "tunnel_exit" );
	
	trigger_use( "trigger_base_horse" );
	
	wait 3;
	
	spawn_manager_enable( "manager_muj_entrance" );
	
	wait 3;
	
	waittill_spawn_manager_ai_remaining( "manager_muj_entrance", 3 );
	
	spawn_manager_enable( "manager_troops_exit" );
}


remove_maproom_personnel()
{
	ai_woods = GetEnt( "woods_ai", "targetname" );
	ai_hudson = GetEnt( "hudson_ai", "targetname" );
	ai_rebel_leader = GetEnt( "rebel_leader_ai", "targetname" );
	
	if ( IsDefined( ai_woods ) )
	{
		ai_woods Delete();
	}
	
	if ( IsDefined( ai_hudson ) )
	{
		ai_hudson Delete();
	}
	
	if ( IsDefined( ai_rebel_leader ) )
	{
		ai_rebel_leader Delete();
	}
}


explosion_cave_ambient()
{
	level endon( "playerat_exit" );
	
	while ( 1 )
	{
		Earthquake( RandomFloatRange( 0.2, 0.5 ), RandomFloatRange( 0.5, 2.0 ), level.player.origin, 100 );
		level.player playsound( "evt_cave_explosions" );
		
		exploder( 150 );
		
		wait RandomFloatRange( 2.0, 4.5 );
	}
}


explosion_baseclose_manager()
{
	level endon( "stop_base_exp" );
	
	a_s_explosion = getstructarray( "explosion_close_base", "targetname" );
	
	while( 1 )
	{
		foreach ( s_explosion in a_s_explosion )
		{
			PlaySoundAtPosition( "wpn_grenade_explode", s_explosion.origin );
			PlayFX( level._effect[ "explode_grenade_sand" ], s_explosion.origin );
			Earthquake( 0.2, 1, level.player.origin, 100 );
			wait RandomFloatRange( 1.5, 3.0 );
		}
	}
}


explosion_basefar_manager()
{
	level endon( "stop_base_exp" );
	
	a_s_explosion = getstructarray( "explosion_far_base", "targetname" );
	
	while( 1 )
	{
		foreach ( s_explosion in a_s_explosion )
		{
			PlaySoundAtPosition( "wpn_rocket_explode", s_explosion.origin );
			PlayFX( level._effect[ "explode_mortar_sand" ], s_explosion.origin );
			Earthquake( 0.1, 1, level.player.origin, 100 );
			wait RandomFloatRange( 1.5, 3.0 );
		}
	}
}


/* ------------------------------------------------------------------------------------------
	Ambience Manager
-------------------------------------------------------------------------------------------*/
ambience_manager()
{
	flag_wait( "monitor_hip3" );
	
	level thread hip3_arena_manager();
	
	wait 5;
	
	level thread hip4_arena_manager();
}


hip3_arena_manager()
{
	//TODO - notify to stop spawning Heli
	level endon( "stop_arena_explosions" );
	
	while( 1 )
	{
		while( flag( "hip3_spawned" ) )
		{
			wait 1;
		}
		
		while( 1 )
		{
			a_ai_guys = getentarray( "hip3_troops_ai", "targetname" );
			
			if ( a_ai_guys.size < 3 )
			{
				break;	
			}
			
			wait 1;
		}
		
		if ( flag( "stop_arena_explosions" ) )
		{
			break;
		}
		
		level thread hip3_replenish();
		
		wait 1;
	}
}


monitor_hip3()
{
	self waittill( "death" );
		
	wait RandomIntRange( 1, 4 );
		
	flag_clear( "hip3_spawned" );
}


hip4_arena_manager()
{
	//TODO - notify to stop spawning Heli
	level endon( "stop_arena_explosions" );
	
	while( 1 )
	{
		while( flag( "hip4_spawned" ) )
		{
			wait 1;
		}
		
		while( 1 )
		{
			a_ai_guys = getentarray( "hip4_troops_ai", "targetname" );
			
			if ( a_ai_guys.size < 3 )
			{
				break;	
			}
			
			wait 1;
		}
		
		if ( flag( "stop_arena_explosions" ) )
		{
			break;
		}
		
		level thread hip4_replenish();
		
		wait 1;
	}
}


monitor_hip4()
{
	self waittill( "death" );
		
	wait RandomIntRange( 1, 4 );
		
	flag_clear( "hip4_spawned" );
}


vehicle_route( s_start )
{
	self endon( "vehicle_stop" );
	self endon( "death" );
	
	self setvehgoalpos( s_start.origin, 0 );
	
	if ( IsDefined( s_start.target ) )
	{
		s_next_pos = getstruct( s_start.target, "targetname" );
	}
	
	if ( IsDefined( s_next_pos ) )
	{
		v_next_pos = s_next_pos.origin;
		
		while( 1 )
		{
			self setvehgoalpos( v_next_pos, 0 );
			
			self waittill_any( "goal", "near_goal" );
			
			if ( IsDefined( s_next_pos.target ) )
			{
				s_next_pos = getstruct( s_next_pos.target, "targetname" );
				v_next_pos = s_next_pos.origin;
			}
			else
			{
				break;
			}
		}
	}
}


muj_tank_behavior()
{
	self endon( "death" );
	
	while ( 1 )
	{
		tank_target = get_vehicle_target();
		
		if ( IsDefined( tank_target ) )
		{
			self SetTargetEntity( tank_target );
			
			self FireWeapon();

			radiusdamage( tank_target.origin + ( 0, 0, 32 ), 100, 1000, 1000 );
		}
		
		else
		{
			target = get_ai_target();
			
			if ( IsDefined( target ) )
			{
				self SetTargetEntity( target );
			
				self FireWeapon();
			}
		}
				
		wait RandomFloatRange( 5, 8 );
	}
}


get_vehicle_target()
{
	self endon( "death" );
	
	a_targets = getentarray( "script_vehicle", "classname" );
	
	vh_target = array_exclude( a_targets, self );
	
	if ( ( vh_target.size ) )
	{
		for( i = 0; i < vh_target.size; i++ )
		{
			if ( Distance2D( self.origin, vh_target[ i ].origin ) < 3200 )
			{
				if ( vh_target[ i ].vehicletype == "tank_t62" )
				{
					return vh_target[ i ];
				}
				
				else if ( vh_target[ i ].vehicletype == "apc_btr60" )
				{
					return vh_target[ i ];
				}
				
				else if ( vh_target[ i ].vehicletype == "jeep_uaz" )
				{
					return vh_target[ i ];
				}
			}
		}
	}
}


get_ai_target()
{
	self endon( "death" );
	
	a_ai_enemies = getaiarray( "axis" );
		
	if ( a_ai_enemies.size )
	{
		ai_target = a_ai_enemies[ RandomInt( a_ai_enemies.size ) ];
			
		if ( Distance2D( self.origin, ai_target.origin ) < 3200 )
		{
			if ( IsAlive( ai_target ) )
			{
				return ai_target;
			}
		}
	}	
}