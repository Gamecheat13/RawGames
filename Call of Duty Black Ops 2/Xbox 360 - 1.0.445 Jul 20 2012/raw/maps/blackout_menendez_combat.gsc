/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
#include common_scripts\utility;
#include maps\_drones;
#include maps\_objectives;
#include maps\_scene;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_music;
#include maps\blackout_anim;


// internal references
#include maps\blackout_util;
#include maps\createart\blackout_art;

#insert raw\maps\blackout.gsh;

// skipto init functions
#define CLIENT_FLAG_INTRO_EXTRA_CAM		11
#define CLIENT_FLAG_MESSIAH_MODE		15
#define MESSIAH_EXPLODER				4000
#define TANKER_EXPLODER_STAGE_UNO		1001
#define TANKER_EXPLODER_STAGE_DUE		10101
#define HANGAR_EXPLODER					5001
	
// event-specific flags
init_flags()
{
	flag_init( "menendez_plane_start" );
	flag_init( "menendez_elevator_start" );
	flag_init( "menendez_on_hangar_floor" );
	flag_init( "crowbar_attacker_done", false );
	flag_Init( "fodder_rocket_fired" );
}

skipto_menendez_combat()
{	
	menendez_animations();
	
	skipto_setup();
	skipto_teleport("skipto_menendez_combat");
	
	level.salazar = init_hero_startstruct( "salazar", "skipto_menendez_combat_salazar" );
	spawn_defalco_or_standin( "skipto_menendez_combat_defalco" );
	
	level.player TakeAllWeapons();
	
	maps\blackout_menendez_start::server_room_exit_door_open();
	
	level.player AllowPickupWeapons( false );
	
	maps\blackout_menendez_start::notetrack_menenedez_mask_on( level.player );
	
	SetSavedDvar( "player_standingViewHeight", 64 );
}

skipto_menendez_hangar()
{
	menendez_animations();
	
	skipto_setup();
	skipto_teleport_players("player_skipto_menendez_hangar");
	level.player AllowPickupWeapons( false );
	set_objective( level.OBJ_MZ_FOLLOW_SALAZAR, level.salazar, "follow" );
	
	spawn_f38();
	
	SetSavedDvar( "player_standingViewHeight", 64 );
	
	wait_network_frame();

	obj_menendez_elevator = getstruct( "obj_menendez_elevator", "targetname" );
	set_objective( level.OBJ_BOARD_PLANE, obj_menendez_elevator.origin, "use" );
	
	level.salazar = init_hero_startstruct( "salazar", "skipto_hangar_salazar" );
	spawn_defalco_or_standin( "skipto_hangar_defalco" );
	
	setup_menendez_m32();
	
	level thread kill_player_attackers();
	
	maps\blackout_menendez_start::notetrack_menenedez_mask_on( level.player );
	
	//TUEY set music state to BLACKOUT_MENENDEZ_WALK
	setmusicstate ("BLACKOUT_MENENDEZ_WALK");
}

skipto_menendez_plane()
{
	menendez_animations();
	
	skipto_setup();
	skipto_teleport_players("player_skipto_menendez_plane");
	level.player AllowPickupWeapons( false );
	
	spawn_f38();
	
	obj_menendez_elevator = getstruct( "obj_menendez_elevator", "targetname" );
	set_objective( level.OBJ_BOARD_PLANE, obj_menendez_elevator.origin, "use" );
	
	maps\blackout_menendez_start::notetrack_menenedez_mask_on( level.player );
}

// skipto run functions
run_menendez_combat()
{
	set_objective( level.OBJ_MZ_FOLLOW_SALAZAR, level.salazar, "follow" );
	
	level thread scene_slaughter();
	level thread kill_player_attackers();
	level thread scene_pmc_hackers();
	
	level.player SetLowReady( true );
	
	level.player.ignoreme = true;

	level thread spawn_f38();
		
	flag_set( "menendez_plane_start" );
	
	level notify ( "ocean_emitter_start" );
	
	setup_menendez_m32();
	
	level.salazar set_combat_bro_status( true );
	level.defalco set_combat_bro_status( true );
	
	autosave_by_name( "menendez_combat" );
	
	//TUEY set music state to BLACKOUT_MENENDEZ_WALK
	setmusicstate ("BLACKOUT_MENENDEZ_WALK");
	
	level thread scene_control_room();
	
	// wait for the player to receive the weapon.
	wpn_list = [];
	while ( wpn_list.size == 0 )
	{
		wpn_list = level.player GetWeaponsListPrimaries();
		wait 0.2;
	}
	
	level.player AllowPickupWeapons( false );
	
	// give him full ammo.
	for ( i = 0; i < wpn_list.size; i++ )
	{
		level.player GiveMaxAmmo( wpn_list[i] );
	}
	
	// they run...carefully.
	level.salazar change_movemode( "cqb_sprint" );
	level.defalco change_movemode( "cqb_sprint" );

	level.player SetClientFlag( CLIENT_FLAG_MESSIAH_MODE );
	
	autosave_by_name( "menendez_combat_start" );
	
	// Entering the control room.
	trigger_wait( "hangar_tower_trigger" );
	
	// Start up the sacrifice scene.
	level thread scene_sacrifice();
	
	level.player SetLowReady( false );
	
	level.player play_fx( "messiah_papers", level.player.origin, level.player.angles, "stop_messiah_papers", true );
	exploder( MESSIAH_EXPLODER );
	
	// Entering the control room lower level.
	trigger_wait( "balcony_kill_trig" );
}

run_menendez_hangar()
{
	level.player SetClientFlag( CLIENT_FLAG_MESSIAH_MODE );
	
	// Set up the "salute" allies.
	add_spawn_function_ai_group( "salute_ally", ::run_salute_ally );
	add_spawn_function_ai_group( "hangar_sailors", ::run_hangar_sailor );
	add_spawn_function_ai_group( "menendez_fodder", ::run_menendez_fodder );
	add_spawn_function_ai_group( "menendez_fodder_close", ::run_menendez_fodder, 196 );
	
	// when the player enters the stairwell to the "crowbar attack" space.
	trigger_wait( "hangar_stairturn_trigger" );
	
	exploder( HANGAR_EXPLODER );
	
	// Start spawning sailors below.
	spawn_manager_enable( "sm_hangar_sailors" );
	
	SetSavedDvar( "r_skyTransition", 0 ); // un-flips the skybox
	level.player.ignoreme = true;
	
	// player is ready for crowbar attack.
	trigger_wait( "crowbar_attack_trigger" );
	
	level thread scene_crowbar_attack();
	
	set_objective( level.OBJ_MZ_FOLLOW_SALAZAR, undefined, "done" );
	
	obj_menendez_elevator = getstruct( "obj_menendez_elevator", "targetname" );
	set_objective( level.OBJ_BOARD_PLANE, obj_menendez_elevator.origin, "breadcrumb", undefined, true );
	
	// Wait to enter the hangar.
	trigger_wait( "hangar_enter_trigger" );
	
	set_messiah_speed( 0.5, 1.0 );
	
	stop_exploder( MESSIAH_EXPLODER );
	level.player notify( "stop_messiah_papers" );
	
	level.player ClearClientFlag( CLIENT_FLAG_MESSIAH_MODE );
	
	// player is at the hangar floor.
	trigger_wait( "hangar_floor_trigger" );
	
	spawn_manager_disable( "sm_hangar_sailors" );
	
	flag_set( "menendez_on_hangar_floor" );

	autosave_by_name( "menendez_combat_done" );
	
	// player is near the plane.
	trigger_wait( "menendez_near_plane_trigger" );
	
	SetTimeScale( 1.0 );
	
	level.player set_low_ready_after_enemies_dead( "at_plane" );
	
	level thread scene_sink_tanker();
	
	// hop to it--these guys need to get to the plane before the player does.
	level.salazar change_movemode( "sprint" );
	if ( level.is_defalco_alive )
	{
		level.defalco change_movemode( "sprint" );
	}
	
	// Kill any living enemies.	
	level thread systematically_kill_enemies( 6 );
	
	level.player.ignoreme = false;
}

#define REFLECTION_WIDTH 32
#define REFLECTION_HEIGHT 18

run_menendez_plane()
{
	add_spawn_function_group( "menendez_hanger_pmc", "script_noteworthy", ::set_ignoreall, true );
	add_spawn_function_group( "menendez_hanger_pmc", "script_noteworthy", ::set_ignoreme, true );
	
	trigger_wait("menendez_board_plane");
	level.player notify( "at_plane" );
	set_objective( level.OBJ_BOARD_PLANE, undefined, "done" );
	level.player SetLowReady( false );
	
	level player_enter_f35();
	SetSavedDvar( "player_standingViewHeight", 60 );
	stop_exploder( HANGAR_EXPLODER );
}

set_low_ready_after_enemies_dead( override_notify )
{
	self endon( override_notify );
	
	waittill_ai_group_ai_count( "hangar_sailors", 0 );
	waittill_ai_group_ai_count( "menendez_fodder", 0 );
	waittill_ai_group_ai_count( "menendez_fodder_close", 0 );
	
	self SetLowReady( true );
}

hangar_drone_spawning()
{
	sp_pmc_spawner = GetEnt( "pmc_hangar_drone_01", "targetname" );
	drones_assign_spawner( "pmc_hangar_drones_01", sp_pmc_spawner );
	
	sp_sailor_spawner = GetEnt( "sailor_hangar_drone_01", "targetname" );
	drones_assign_spawner( "sailor_hangar_drones_01", sp_sailor_spawner );
	
	wait_network_frame();
	
	drones_start( "pmc_hangar_drones_01" );
	drones_start( "sailor_hangar_drones_01" );
	
	s_kill_01 = GetStruct( "hangar_battle_bullet_pos_01", "targetname" );
	s_kill_01.m_next_node = GetStruct( s_kill_01.target, "targetname" );
	
	s_kill_02 = GetStruct( "hangar_battle_bullet_pos_02", "targetname" );
	s_kill_02.m_next_node = GetStruct( s_kill_02.target, "targetname" );
	
	// Shoot magic bullets until the player gets in the plane.
	//
	while ( !flag( "menendez_load_f38_started" ) )
	{
		start_pos = LerpVector( s_kill_01.origin, s_kill_01.m_next_node.origin, RandomFloat( 1.0 ) );
		end_pos = LerpVector( s_kill_02.origin, s_kill_02.m_next_node.origin, RandomFloat( 1.0 ) );
		
		end_pos = end_pos + ( 0, 0, RandomFloatRange( -10, 20 ) );
		
		// Half hte time, go one direction, the other half, the other direction.
		// A small percentage of the time, shoot a rocket.
		//
		if ( rand_chance( 0.01 ) )
		{
			if ( rand_chance( 0.5 ) )
				MagicBullet( "usrpg_player_sp", start_pos, end_pos );
			else
				MagicBullet( "usrpg_player_sp", end_pos, start_pos );
		}
		else if ( rand_chance( 0.5 ) )
		{
			MagicBullet( "scar_sp", start_pos, end_pos );
		}
		else
		{
			MagicBullet( "hk416_sp", end_pos, start_pos );
		}
		
		wait_network_frame();
	}
	
	drones_delete( "pmc_hangar_drones_01" );
	drones_delete( "sailor_hangar_drones_01" );
}

run_hero_victim( hero )
{
	self.ignoreme = true;
}

// These guys run to their targets, but get hit with a sniper bullet and die before they get there.
//
run_menendez_fodder( kill_radius = 256 )
{
	self endon( "death" );
	s_death_source = GetStruct( "menendez_fodder_death_source", "targetname" );
	node_target = GetNode( self.target, "targetname" );
	self thread force_goal( node_target, kill_radius, true );
	
	wait_network_frame();
	
	// Wait till we get near the player or our goal.
	waittill_player_nearby( kill_radius, "goal", true, false );
	
	bullet_type = "scar_sp";
	bullet_dest = self GetTagOrigin( "J_head" );
	if ( !flag( "fodder_rocket_fired" ) && kill_radius >= 256 )
	{
		flag_set( "fodder_rocket_fired" );
		bullet_type = "usrpg_magic_bullet_sp";
		bullet_dest = self.origin;													// shoot a rocket at his feet, not head.
		bullet_dest = bullet_dest + (128 * AnglesToForward( self.angles ) );		// lead the target.
	}
	MagicBullet( bullet_type, s_death_source.origin, bullet_dest );
	wait 0.5;
	self bloody_death();
}

// let them join the battle before letting them die.
//
run_hangar_sailor()
{
	self magic_bullet_shield();
	self.ignoreme = true;
	self.ignore_suppression = true;
	self.ignoreall = true;
	
	wait 4.0;
	
	self stop_magic_bullet_shield();
	self.ignoreme = false;
	self.ignore_suppression = false;
	self.ignoreall = false;
	
	while ( !isdefined( level.m_saluting_allies ) )
	{
		wait 1.0;
	}
	
	// Once the saluting sailors abandon the battle, these guys should just drop dead.
	while ( level.m_saluting_allies < 4 )
	{
		wait 1.0;
	}
	
	wait RandomFloatRange( 1.0, 4.0 );
	
	self bloody_death();
}

set_messiah_speed( walk_speed_pct, timescale_pct )
{
	speed = LerpFloat( 64, 190, walk_speed_pct );
	setsaveddvar( "g_speed", speed );
	SetTimeScale( timescale_pct );
}

// Keep grabbing the closest guy, get close to him,
// and kill the snot out of him.
//
do_hangar_killings( str_aigroup )
{
	self endon( "death" );
	
	original_color = self get_force_color();
	self clear_force_color();
	
	while ( true )
	{
		victims = get_ai_group_ai( str_aigroup );
		if ( victims.size == 0 )
			break;
		
		victim = get_closest_living( self.origin, victims, 2048 );
		if ( isdefined( victim ) )
		{
			// run to the closest one and kill him.
			self force_goal( victim.origin, 64, false );
			if ( isdefined( victim ) && IsAlive( victim ) )
			{
				self shoot_and_kill( victim );
			}
		}
		
		// wait till we get closer?
		wait 1.0;
	}
	
	self set_force_color( original_color );
}

run_control_room_pmc()
{
	self magic_bullet_shield();
	
	flag_wait( "menendez_elevator_start" );
	
	self stop_magic_bullet_shield();
}

run_control_room_sailor()
{
	self magic_bullet_shield();
	
	trigger_wait( "control_room_fight_start" );
	
	self stop_magic_bullet_shield();
}

control_room_fight()
{
	simple_spawn( "control_room_pmc", ::run_control_room_pmc );
}

scene_sink_tanker()
{
	// exploder for the ship outside.
	stop_exploder( TANKER_EXPLODER_STAGE_UNO );
	exploder( TANKER_EXPLODER_STAGE_DUE );
	
	s_sink_pos = GetStruct( "tanker_sink_pos", "targetname" );
	e_tanker = GetEnt( "sinking_tanker", "targetname" );
	
	e_tanker MoveTo( s_sink_pos.origin, 20, 2.0, 4.0 );
	e_tanker RotateTo( s_sink_pos.angles, 20, 2.0, 4.0 );
}

scene_wait_by_plane()
{
	level thread run_scene_and_delete( "pmc_wait_at_hanger");
	wait_network_frame();
	pmcs = get_ais_from_scene( "pmc_wait_at_hanger" );
	for ( i = 0; i < pmcs.size; i++ )
	{
		pmcs[i].ignoreme = true;
		pmcs[i].perfectaim = true;
	}
}

setup_menendez_m32()
{
	level.player TakeAllWeapons();
	level.player GiveWeapon( "m32_gas_sp" );
	level.player SwitchToWeapon( "m32_gas_sp" );
}

systematically_kill_enemies( max_time_s )
{
	enemies = GetAIArray( "axis" );
	foreach( enemy in enemies )
	{
		enemy delay_thread( RandomFloatRange( 0, max_time_s ), ::bloody_death );
	}
}

// Sets up one of Menendez's unstoppable bro-dudes for combat.
//
set_combat_bro_status( is_combat_bro )
{
	if ( is_combat_bro )
	{
		self magic_bullet_shield();
	} else {
		self stop_magic_bullet_shield();
	}
	
	self SetCanDamage( !is_combat_bro );
	self.perfectAim = is_combat_bro;
	self set_ignoreSuppression( is_combat_bro );
}

spawn_f38()
{
	level.f35 = spawn_vehicle_from_targetname( "F35"  );
	wait_network_frame();
	
	level.f35 veh_toggle_exhaust_fx( false );
	level.f35 veh_toggle_tread_fx( false );
	
	// let the landing gear attach before starting the scene.
	wait_network_frame();
	
	level.f35 NotSolid();
	
	level.f35 HidePart( "tag_display_flight" );
	level.f35 HidePart( "tag_display_standby" );
	level.f35 HidePart( "tag_display_message" );	
	level.f35 HidePart( "tag_display_damage" );		
	level.f35 HidePart( "tag_display_eject" );	
	level.f35 HidePart( "tag_display_skybuster" );
	level.f35 HidePart( "tag_display_malfunction" );
	level.f35 HidePart( "tag_display_missiles_agm" );
	level.f35 HidePart( "tag_display_missiles_aam" );
	
	level.f35 Attach( "veh_t6_air_fa38_landing_gear_proto", "tag_landing_gear_down" );
	level.f35 Attach( "veh_t6_air_fa38_ladder_proto", "tag_ladder" );
	
	run_scene_first_frame( "menendez_f38" );
}

gas_mask_remove()  // self = model
{
	if ( IsDefined( self.gas_mask_model ) )
	{
		self Detach( self.gas_mask_model, "J_Head" );
		self.gas_mask_model = undefined;
	}
}

player_controls_for_f38()
{
	level endon( "start_elevator" );
	
	ncurrent_speed = 0;
	self SetSpeed( 0 );
	
	while( 1 )
	{
		input = level.player GetNormalizedMovement();
		
		if( input[0] > 0 )
		{
			ncurrent_speed = DiffTrack( 15, ncurrent_speed, 1.2 * input[0], 0.05 );
			self SetSpeed( ncurrent_speed );
		}
		else 
		{
			ncurrent_speed = DiffTrack( 0, ncurrent_speed, 1.0, 0.05 );
			self SetSpeed( ncurrent_speed );
		}
		
		wait 0.05;
	}
	
	level notify( "menendez_enter_plane" );
}

spawn_ai_for_deck_battle()
{
	deck_ai = simple_spawn( "menendez_take_off_ai" );
	
	for( i = 0; i < deck_ai.size; i++ )
	{
		if( IsDefined( deck_ai[i] ) && IsAlive( deck_ai[i] ) )
		{
			if( IsAlive( deck_ai[ i ] ) && IsDefined( deck_ai[ i ] ) )
			{
				deck_ai[ i ] thread magic_bullet_shield();
			}
		}
	}
	
	level waittill( "delete_deck_combat" );
	
	for( i = 0; i < deck_ai.size; i++ )
	{
		if( IsAlive( deck_ai[ i ] ) && IsDefined( deck_ai[ i ] ) )
		{
			deck_ai[ i ] Delete();
		}
	}
}

player_enter_f35()
{
	level thread run_scene( "menendez_f38" );
	//level thread run_scene( "menendez_f38_elevator" );
	level thread run_scene( "menendez_load_f38" );
	level thread run_scene( "menendez_reflection" );
	
	//delay_thread( 33, ::run_scene, "fa38_crash" );
	
	flag_set( "menendez_elevator_start" );	

	level thread run_scene( "pmc_walkto_elevator");		
	
	//TODO:temp until we got the drivable version. PC
	
	level thread spawn_ai_for_deck_battle();
		
	screen_message_delete();
	
	level.menendez = init_hero( "menendez" );
	level.menendez Detach( "c_mul_menendez_old_head_bleed" );
	level.menendez Attach( "c_mul_menendez_old_noeye" );
	
	wait 20;
	
//	level.f35 DetachAll();
//	
//	level.f35 Attach( "veh_t6_air_fa38_extracam", "tag_canopy" );
//	
//	origin = getstruct( "reflection_cam", "targetname" );	
//	sm_cam_ent = spawn_model( "tag_origin", origin.origin, origin.angles );
//	
//	sm_cam_ent ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
//	
//	SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );
//	sm_cam_ent SetClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	wait 3;

	level.player thread elevator_audio();
	
	level.f35 ShowPart( "tag_display_flight" );
	
	scene_wait( "menendez_load_f38");
	
	menendez_cleanup();
	
	//sm_cam_ent ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	level.rewind_id = level thread play_movie_async( "rewind", true, true, undefined, false, "movie_done" );
	level.player playsound ("evt_time_rev_1");
		
	wait 0.5;
	
	VisionSetNaked( "sp_blackout_rewind" );
	
	level notify( "delete_deck_combat" );
	
	level.f35 Delete();
	
	wait 0.15;

	level.f35 = spawn_vehicle_from_targetname( "F35" );
	
	wait 0.5;
	run_scene_first_frame( "menendez_f38" );
	//run_scene_first_frame( "menendez_f38_elevator" );
	
	level thread run_scene( "rewind_plane" );
	
	wait 0.1;
	
	Stop3DCinematic( level.rewind_id );
	
	wait 2;
	
	level.rewind_id = level thread play_movie_async( "rewind", true, true, undefined, false, "movie_done" );
	level.player playsound ("evt_time_rev_2");
	level notify("f35_rewind_start");//kevin adding notify to shut off f38 snapshot
	
	wait 0.5;
	
	end_scene( "rewind_plane" );
		
	wait 0.25;
	
	level.f35 Delete();
	
	level thread run_scene( "rewind_mask" );
	
	wait 0.25;
	
	Stop3DCinematic( level.rewind_id );
	
	wait 2;
	
	level.rewind_id = level thread play_movie_async( "rewind", true, true, undefined, false, "movie_done" );
	level.player playsound ("evt_time_rev_1");

	wait 0.5;
	
	end_scene( "rewind_mask" );
	
	wait 0.25;
	
	level thread run_scene( "rewind_eye" );
	
	wait 0.5;
	
	Stop3DCinematic( level.rewind_id );
	
	wait 2;
	
	level.rewind_id = level thread play_movie_async( "rewind", true, true, undefined, false, "movie_done" );
	level.player playsound ("evt_time_rev_1");

	wait 0.5;
	
	end_scene( "rewind_eye" );
	
	wait 0.25;
	
	level thread run_scene( "rewind_meatshield" );
	
	wait 0.5;
	
	Stop3DCinematic( level.rewind_id );
	
	wait 2;
	
	level.rewind_id = level thread play_movie_async( "rewind", true, true, undefined, false, "movie_done" );
	level.player playsound ("evt_time_rev_2");

	wait 0.5;
	
	end_scene( "rewind_meatshield" );
	
	wait 0.25;
	
	level thread run_scene( "rewind_cctv" );
	
	wait 0.25;
	
	Stop3DCinematic( level.rewind_id );
	
	wait 2;
	
	level.rewind_id = level thread play_movie_async( "rewind", true, true, undefined, false, "movie_done" );
	level.player playsound ("evt_time_rev_3");

	wait 1;
	
	VisionSetNaked( "sp_blackout_default" );	
	
	teleport_struct = GetStruct( "player_skipto_mason_vent", "targetname" );
	
	level.player SetOrigin( teleport_struct.origin );
	level.player SetPlayerAngles( teleport_struct.angles );
	
	menendez_elevator = getent ("menendez_elevator", "targetname");
	menendez_elevator MoveZ (-576, 1, 0.5, 0.5);
	
	//stop walk music CDC
	setmusicstate ("BLACKOUT_MENENDEZ_OVER");		
}


elevator_audio()
{
	wait (6);
	playsoundatposition ("evt_elev_alarm", (815,-2177,-400));
	wait (1);
	self playsound ("evt_elev_start");
	wait (1);
	self playloopsound ("evt_elev_loop", 2);
	
	wait (10);
	self playsound ("evt_elev_stop");
	wait (.5);
	self stoploopsound (.3);
}

// returns when the scene ends or the guy is shot.
//
crowbar_attack_wait_scene( attacker )
{
	flag_wait( "crowbar_attacker_done" );
	attacker ent_flag_set( "kill_me" );
}

crowbar_attacker_done( attacker )
{
	flag_set( "crowbar_attacker_done" );
}

// Anyone who damages the player (even if on accident) must die!
//
kill_player_attackers()
{
	self endon( "menendez_elevator_start" );
	while ( true )
	{
		level.player waittill( "damage", damage, attacker, direction_vec, point, mod );
		if ( attacker.team == "axis" )
		{
			attacker notify( "kill_this_chump" );
		}
	}
}

slaughter_ready_wait()
{
	level.salazar endon( "goal" );
	level.defalco endon( "goal" );
	level.defalco waittill( "goal" );
}

scene_pmc_hackers()
{
	trigger_wait( "hackers_start_trig" );
	
	level thread run_scene_and_delete( "control_room_hacker_02_loop" );
}

ragdoll_on_grenade_explosion( e_grenade )
{
	set_messiah_speed( 0.5, 0.5 );
	e_grenade waittill( "death" );
	self stop_magic_bullet_shield();
	self ragdoll_death();
	
	wait 1.0;
	
	set_messiah_speed( 0.5, 0.9 );
}

scene_sacrifice()
{	
	run_scene_first_frame( "hangar_sacrifice_sailor" );
	s_grenade_target = GetStruct( "sacrifice_grenade_pos", "targetname" );
	run_scene_first_frame( "hangar_sacrifice_pmc" );
	
	wait_network_frame();
	
	sailor = GetEnt( "sacrifice_sailor_ai", "targetname" );
	pmc = GetEnt( "sacrifice_pmc_ai", "targetname" );
	
	sailor magic_bullet_shield();
	sailor.ignoreme = true;
	
	pmc.ignoreme = true;
	pmc magic_bullet_shield();

	level thread run_scene_and_delete( "hangar_sacrifice_pmc" );
	
	wait 2.0;
	
	level thread run_scene_and_delete( "hangar_sacrifice_sailor" );
	
	wait 2.5;
	
	
	hand_pos = sailor GetTagOrigin( "J_Wrist_RI" );
	e_grenade = sailor MagicGrenade( hand_pos, s_grenade_target.origin, 1.5 );
	
	sailor stop_magic_bullet_shield();
	sailor.ignoreme = false;
	
	pmc ragdoll_on_grenade_explosion( e_grenade );
	
	scene_wait( "hangar_sacrifice_sailor" );
	
	if ( IsAlive( sailor ) )
	{
		sailor bloody_death();
	}
}

scene_slaughter()
{
	level.salazar custom_ai_weapon_loadout( "scar_sp", undefined, "fiveseven_sp" );
	level.defalco custom_ai_weapon_loadout( "hk416_sp", undefined, "fiveseven_sp" );
	
	// ready the sacrifice scene and the slaughter scene.
	run_scene_first_frame( "hangar_slaughter_victims" );
	
	// fire the slaughter scene.
	if ( level.is_defalco_alive )
	{
		level thread run_scene_and_delete( "hangar_slaughter_wait_defalco" );
	} else {
		level thread run_scene_and_delete( "hangar_slaughter_wait_standin" );
	}
	
	level thread run_scene_and_delete( "hangar_slaughter_wait_pmc" );
	
	wait_network_frame();
	victims = get_ais_from_scene( "hangar_slaughter_victims" );
	
	foreach ( victim in victims )
	{
		victim.ignoreme = true;
	}
	
	// so they don't fire their "goal" too soon.
	wait_network_frame();
	
	{
		// don't need this since we're not reaching at the moment.
		//	slaughter_ready_wait();
		//	wait 1.0;
	}
	
	trigger_wait( "slaughter_start_trigger" );
	
	set_messiah_speed( 0.3, 0.5 );
	
	level thread control_room_fight();
	level thread run_scene_and_delete( "hangar_slaughter_victims" );
	
	if ( level.is_defalco_alive )
	{
		level thread run_scene_and_delete( "hangar_slaughter_defalco" );
	} else {
		level thread run_scene_and_delete( "hangar_slaughter_standin" );
	}
	
	wait 3.5;
	
	set_messiah_speed( 0.5, 0.9 );
	
	scene_wait( "hangar_slaughter_victims" );
	
	// TODO: remove this once the guy is dying properly
	foreach ( victim in victims )
	{
		if ( isdefined( victim ) )
		{
			victim SetCanDamage( true );
			victim die();
		}
	}
}

waittill_scene_or_death( str_scene_1, str_scene_2 )
{
	ais = get_ais_from_scene( str_scene_1 );
	foreach ( ai in ais )
	{
		ai endon( "death" );
	}
	
	ais = get_ais_from_scene( str_scene_2 );
	foreach ( ai in ais )
	{
		ai endon( "death" );
	}
	
	scene_wait( str_scene_1 );
}

run_control_room_anim( str_scene, str_attack_node, ai_victim = undefined )
{
	if ( isdefined( ai_victim ) )
	{
		ai_victim endon( "death" );
	}
	
	if ( scene_exists( str_scene + "_idle" ) )
	{
		level thread run_scene( str_scene + "_idle" );
	}
	
	if ( isdefined( str_attack_node ) )
	{
		start_node = GetNode( str_attack_node, "targetname" );
		self force_goal( start_node, 16, true );
	}
	
	if ( isdefined( ai_victim ) )
	{
		if ( !IsAlive( ai_victim ) )
		{
			return;
		}
	}
	
	level thread run_scene_and_delete( str_scene );
	level thread run_scene_and_delete( str_scene + "_victim" );
	
	wait_network_frame();
	ais = get_ais_from_scene( str_scene + "_victim" );
	foreach ( ai in ais )
	{
		ai magic_bullet_shield();
	}
	
	waittill_scene_or_death( str_scene + "_victim", str_scene );
	foreach ( ai in ais )
	{
		if ( IsAlive( ai ) )
		{
			ai stop_magic_bullet_shield();
		}
	}
}

get_by_script_animname_from_list( list, str_animname )
{
	foreach ( ai in list )
	{
		if ( !IsAlive( ai ) )
		{
			continue;
		}
		
		if ( ai.script_animname == str_animname )
		{
			return ai;
		}
	}
	
	return undefined;
}

scene_control_room_salazar( victim_list )
{	
	scene_wait( "hangar_sacrifice_sailor" );
	
	level.salazar force_goal( undefined, 16, false );
	level.salazar change_movemode( "cqb_run" );
	level.salazar clear_force_color();
	level.salazar.ignoreall = true;
	
	ai = get_by_script_animname_from_list( victim_list, "hangar_victim_01" );
	if ( IsAlive( ai ) )
	{
		level.salazar run_control_room_anim( "hangar_salazar_kill_01", "control_room_node_sal_01", ai );	
	}
	
	ai = get_by_script_animname_from_list( victim_list, "hangar_victim_03" );
	if ( IsAlive( ai ) )
	{
		level.salazar run_control_room_anim( "hangar_salazar_kill_02", "control_room_node_sal_02", ai );
	}
	
	level.salazar.ignoreall = false;
	level.salazar set_force_color( "r" );
}

scene_control_room_defalco( victim_list )
{
	scene_wait( "hangar_sacrifice_sailor" );
	
	level.defalco change_movemode( "cqb_run" );
	level.defalco clear_force_color();
	level.defalco force_goal( undefined, 16, false );
	level.defalco.ignoreall = true;
	
	ai = get_by_script_animname_from_list( victim_list, "hangar_victim_02" );
	if ( IsAlive( ai ) )
	{
		if ( level.is_defalco_alive )
		{
			level.defalco run_control_room_anim( "hangar_defalco_kill_01", "control_room_node_defalco_01", ai );
		} else {
			level.defalco run_control_room_anim( "hangar_standin_kill_01", "control_room_node_defalco_01", ai );
		}
	}
	
	level.defalco.ignoreall = false;
	level.defalco set_force_color( "o" );
}

setup_control_room_victim()
{
	self.ignoreall = true;
	self.ignoreme = true;
}

scene_control_room()
{
	victim_list = simple_spawn( "hangar_victim", ::setup_control_room_victim );
	level thread scene_control_room_salazar( victim_list );
	level thread scene_control_room_defalco( victim_list );
	
	run_scene_first_frame( "hangar_balcony_kill" );
	run_scene_first_frame( "hangar_balcony_kill_victim" );
	
	wait_network_frame();
	
	sailor = get_ais_from_scene( "hangar_balcony_kill_victim" )[0];
	pmc = get_ais_from_scene( "hangar_balcony_kill" )[0];
	pmc magic_bullet_shield();
	
	trigger_wait( "balcony_kill_trig" );
	
	if ( IsAlive( sailor ) )
	{
		sailor SetCanDamage( false );
		level thread run_scene( "hangar_balcony_kill" );
		run_scene( "hangar_balcony_kill_victim" );
		if ( IsAlive( sailor ) )
		{
			sailor SetCanDamage( true );
		}
	}
	
	// make him go hack a computer.
	level thread run_scene_and_delete( "control_room_hacker_01_loop" );
}

run_salute_ally()
{
	self endon( "death" );
	self magic_bullet_shield();
	
	// My node has the same targetname as my script_animname.
	mynode = GetNode( self.script_animname, "targetname" );
	
	// Wait till the player nears my node, then head to it.
	mynode waittill_player_nearby( 1500 );
	
	if ( !isdefined( level.m_saluting_allies ) )
	{
		level.m_saluting_allies = 1;
	} else {
		level.m_saluting_allies++;
	}
	
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignore_suppression = true;
	self change_movemode( "sprint" );
	
	self thread force_goal( mynode );
	
	do {
		wait 0.5;
		dist_sq = Distance2DSquared( self.origin, mynode.origin );
	} while ( dist_sq > (self.goalradius * self.goalradius) );
	
	fvec = AnglesToForward( mynode.angles );
	self AimAtPos( (self GetTagOrigin( "J_head" )) + (fvec * 1000));
	wait 2.0;
	
	run_scene_and_delete( level.salutes[ self.script_animname ].start );
	level thread run_scene_and_delete( level.salutes[ self.script_animname ].loop );
}

scene_crowbar_attack()
{
	level thread run_scene_and_delete( "crowbar_attack" );
	
	wait_network_frame();
	
	s_bullet_source = GetStruct( "crowbar_attacker_bullet_source", "targetname" );
	
	attacker = get_ais_from_scene( "crowbar_attack" )[0];
	attacker magic_bullet_shield();
	attacker ent_flag_init( "kill_me", false );
	attacker ent_flag_init( "launch_me", false );
	attacker.ignoreme = true;
	
	level.salazar aim_at_target( attacker );
	
	level thread crowbar_attack_wait_scene( attacker );
	
	// launch_me is set in run_m32_autokill.
	attacker ent_flag_wait_either( "kill_me", "launch_me" );
	
	attacker.ignoreme = false;
	
	if ( attacker ent_flag( "kill_me" ) )
	{
		// he wouldn't dare touch menendez.
		attacker aim_at_target( level.salazar );
		
		attacker stop_magic_bullet_shield();
		
		// kill him.
		for ( i = 0; i < 3; i++ )
		{
			level.salazar thread shoot_at_target( attacker, undefined, 0.0, 2.0 );
			MagicBullet( "scar_sp", s_bullet_source.origin, attacker GetTagOrigin( "J_head" ) );
			wait_network_frame();
		}
		attacker bloody_death();
		
		// make sure the crowbar gets cleaned up.
		end_scene( "crowbar_attack" );
	} else {
		attacker delay_thread( 1.5, ::stop_magic_bullet_shield );
		run_scene_and_delete( "crowbar_attack_success" );
	}
	
	level.salazar stop_aim_at_target();
}

// wait for the guy to get damaged, or for the player to look at him.
navy_hacker_wait()
{
	self endon( "death" );
	self endon( "damage" );
	level.player waittill_player_looking_at( self.origin + (0, 0, 96), 0.7 );
	wait RandomFloatRange( 0.0, 2.0 );
}

navy_hacker_react()
{
	self endon( "death" );
	self navy_hacker_wait();
	self stop_magic_bullet_shield();
	run_scene_and_delete( self.react_scene );
}

anim_f35_on_deck()
{
	level thread run_scene( "F35_vehicle_deck" );
	level thread run_scene( "F35_player_deck" );
}

init_doors()
{
	menendez_elevator = getent ("menendez_elevator", "targetname");
	menendez_elevator SetMovingPlatformEnabled( true );
}
