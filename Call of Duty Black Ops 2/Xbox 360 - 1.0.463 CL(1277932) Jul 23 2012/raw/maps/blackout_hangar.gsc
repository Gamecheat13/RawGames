/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 

#include maps\blackout_util;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_dynamic_nodes;
#include maps\_glasses;
#include maps\_dialog;
#include maps\blackout_anim;


// event-specific flags
init_flags()
{
	flag_init( "hanger_salazar_scene" );
}

init_spawn_funcs()
{
	sm_1 = GetEntArray( "sm_1_spawners", "targetname" );
	sm_2 = GetEntArray( "sm_2_spawners", "targetname" );

	sm_1[0] add_spawn_function( ::spawn_func_elevator_sm1 );
	sm_1[1] add_spawn_function( ::spawn_func_elevator_sm1 );
	sm_2[0] add_spawn_function( ::spawn_func_elevator_sm2 );
	sm_2[1] add_spawn_function( ::spawn_func_elevator_sm2 );
	
	sm_1[0] add_spawn_function( ::ai_elevator_think );
	sm_1[1] add_spawn_function( ::ai_elevator_think );
	sm_2[0] add_spawn_function( ::ai_elevator_think );
	sm_2[1] add_spawn_function( ::ai_elevator_think );
	
	spawner = GetEnt( "friendly_ai_die_1", "script_noteworthy" );
	spawner add_spawn_function( ::pip_dying_ai_1 );
	
	spawner = GetEnt( "friendly_ai_die_2", "script_noteworthy" );
	spawner add_spawn_function( ::pip_dying_ai_2 );
}

// skipto init functions
skipto_mason_hangar()
{
	mason_part_2_animations();
	
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_hangar");
	
//	level.is_briggs_alive = true;
//	level.is_harper_alive = true;
	
	level.salazar = init_hero_startstruct( "salazar", "salazar_skipto_mason_hangar" );
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "redshirt1_skipto_mason_hangar" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "redshirt2_skipto_mason_hangar" );
	
	level.ai_redshirt1 set_ignoreall ( true );
	level.ai_redshirt2 set_ignoreall ( true );
	
	if ( level.player get_story_stat( "FARID_DEAD_IN_YEMEN" ) )
	{
		level.harper = init_hero_startstruct( "harper", "harper_skipto_mason_hangar" );
		if ( level.player get_story_stat( "HARPER_SCARRED" ) )
		{
			level.harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
		}
	}
}

skipto_mason_salazar_caught()
{
	mason_part_2_animations();
	
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_salazar_caught");
}

skipto_mason_elevator()
{
	flag_set( "hanger_salazar_scene" );
	mason_part_2_animations();
	
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_elevator");
}


// skipto run functions
run_mason_hangar()
{	
	level thread gassed_navy();
	
	exploder (5001);
		
	level thread menendez_riding_elevator();
	
	set_objective( level.OBJ_FIND_MENEN  );
	
	autosave_by_name( "hangar" );

	hangar_betrayal_scene();
}

mason_elevator()
{
	autosave_by_name( "elevator" );
	
	mason_elevator = getent ("mason_elevator", "targetname");
	mason_elevator SetMovingPlatformEnabled( true );
	
	trigger_wait( "mason_elevator_trig" );
		
	mason_elevator thread elevator_audio();
	
	turn_off_extra_cam();
	
	for( i = 0; i < level.pip_ai.size; i++ )
	{
		if( IsAlive( level.pip_ai[ i ] ) )
		{
			level.pip_ai[ i ] stop_magic_bullet_shield();
		
			level.pip_ai[ i ] die();
		}
	}
	
	set_objective(level.OBJ_BREADCRUMB, undefined, "done" );
	
	node = GetNodeArray( "elevator_pathnode", "targetname" );

	for( i = 0; i < node.size; i++ )
	{
		node[i] node_disconnect_from_path();
	}
	
	wait 1.5;
	
	clip = GetEnt( "mason_elevator_clip", "targetname" );
	clip Solid();
	
	mason_elevator movez ( 576, 38, 1, 1 );	
		
	level thread run_menendez_f38();
	
	mason_elevator waittill ( "movedone" );
	
	trigger_use( "move_allies_off_elevator" );
	
	set_objective( level.OBJ_FIND_MENEN, undefined, "done" );
	set_objective( level.OBJ_STOP_MENEN, level.menendez_f38 );
	
	autosave_by_name( "deck" );
	
	node = GetNodeArray( "elevator_pathnode", "targetname" );

	for( i = 0; i < node.size; i++ )
	{
		node[i] node_connect_to_path();
	}
		
	spawn_manager_kill( "sm_2" );
	
	stop_exploder(5001);
	
	level notify( "start_vtol_timer" );
}

elevator_audio()
{
	playsoundatposition ("evt_elev_alarm", (815,-2177,-400));
	wait (1);
	self playsound ("evt_elev_start");
	wait (1);
	self playloopsound ("evt_elev_loop", 2);
	
	self waittill ("movedone");
	self playsound ("evt_elev_stop");
	wait (.5);
	self stoploopsound (.3);
}

run_menendez_f38()
{
	trigger_wait("sm_2");
	
	delay_thread( 3, ::run_scene, "fa38_crash" );
	
	level.menendez_f38 = spawn_vehicle_from_targetname( "F35"  );
	level.menendez_f38 thread go_path( GetVehicleNode( "menedez_deck_start", "targetname" ) );
	
	level.menendez_f38 Attach( "veh_t6_air_fa38_landing_gear", "tag_landing_gear_down" );
	
	level.menendez_f38 SetSpeed( 0 );
	
	level.menendez_f38 thread increase_f35_speed();
	
	trigger_wait( "move_allies_off_elevator" );
	
	level.menendez_f38 thread takeoff_sound();
	
	level.menendez_f38 SetSpeed( 5 );
	
	level thread menendez_f38_VO();
		
	level waittill( "resume_speed" );
	
	trigger_use( "menedez_take_off" );
	
	level.menendez_f38 waittill( "reached_end_node" );
	level.menendez_f38 Delete();
}

takeoff_sound()
{
	sound_ent = Spawn( "script_origin" , level.menendez_f38.origin );
	sound_ent LinkTo( level.menendez_f38 , "tag_canopy" );
	//sound_ent PlaySound( "evt_menendez_takeoff" , "sound_done" );//kevin putting sound on f35
	sound_ent PlayloopSound( "evt_menendez_takeoff");
	wait 27;
	sound_ent Delete();
}

increase_f35_speed()
{
	level endon( "resume_speed" );
	
	self thread f35_resume_speed();
	
	trigger_wait ( "menedez_take_off" );

	self SetSpeed( 15 );	
}

f35_resume_speed()
{
	level waittill("resume_speed");
	self ResumeSpeed( 10 );
}

menendez_f38_VO()
{
	
	level waittill( "take_off" );
	level.player say_dialog( "sect_shit_menendez_got_a_0" );
	
	level thread play_pip_dradis();
}

play_pip_dradis()
{
	wait 3;
	
	level thread play_pip( "blackout_dradis" );
}


spawn_func_elevator_sm1()
{
	goal_volume = GetEnt( "volume_sm_1", "targetname" );
	self SetGoalVolumeAuto( goal_volume );
}
spawn_func_elevator_sm2()
{
	goal_volume = GetEnt( "volume_sm_2", "targetname" );
	self SetGoalVolumeAuto( goal_volume );
}
	
menendez_riding_elevator()
{
	trigger_wait("mason_trigger_hanger");

	menendez_elevator = getent ("menendez_elevator", "targetname");
	
	landing_gears = getent( "landing_gear_hanger", "targetname" );
	
	if( IsDefined( landing_gears ) )
	{
		landing_gears Delete();
	}
	
	menendez_elevator MoveZ (200, 1, 0.5, 0.5);
	
	wait 1;
	
	menendez_elevator MoveZ (376, 30, 1, 1);
	
}

player_speech_and_dolly_zoom_animations()
{
	dolly_zoom_struct = getstruct("hanger_anim", "targetname");
	dolly_zoom_origin = spawn("script_model", dolly_zoom_struct.origin );
	dolly_zoom_origin SetModel( "tag_origin" );
	dolly_zoom_origin.targetname = "player_dolly_zoom";
	
	level thread run_scene_and_delete( "betrayal_speech_player" );
	
	anim_time = GetAnimLength( %player::p_command_06_06_betrayal_player_speach );
	wait anim_time - 3;

	level.player ShellShock( "death", 8 );

	wait 1;	
	dolly_zoom_origin MoveY( -150, 6 );
	level.player lerp_fov_overtime( 6, 110 );
	
	if ( level.is_harper_alive )
	{
		flag_wait( "betrayal_shot_started" );
		wait 0.5;
		
	}
	else
	{
		flag_wait( "betrayal_sal_captured_started" );
		wait 3.0;
	}
	
	dolly_zoom_origin MoveY( 150, 0.2 );
	level.player lerp_fov_overtime( 0.2, 65 );
	
	level.player SetLowReady( false );
	level.player AllowSprint( true );
	
	level thread run_scene_and_delete( "betrayal_dolly_zoom_pose_loop" );
	delete_scene( "betrayal_dolly_zoom_pose_loop" );
}

hangar_betrayal_scene()
{
	trigger_wait( "hangar_trigger" );
	
	level.salazar = init_hero( "salazar");
	level thread run_scene_and_delete( "betrayal_surrender_waving_loop" );

	trigger_wait( "trigger_harper_redshirt" );
	
	if ( level.is_harper_alive )
	{
		level.harper enable_ai_color();
		run_scene_and_delete( "betrayal_surrender_harper" );
		
		level thread run_scene_and_delete( "betrayal_surrender_harper_idle_loop" );
		
		trigger_wait( "hanger_player" );
		level thread player_speech_and_dolly_zoom_animations();
		run_scene_and_delete( "betrayal_speech_sal" );
		
		level.salazar stop_magic_bullet_shield();
		
		run_scene_and_delete( "betrayal_shot" );
	}
	else
	{
		run_scene_and_delete( "betrayal_redshirt_walkup" );
		
		level thread run_scene( "betrayal_redshirt_wait_loop" );
		run_scene_and_delete( "betrayal_sal_hands_down" );
		
		level thread run_scene_and_delete( "betrayal_surrender_sal_idle_loop" );
		
		trigger_wait( "hanger_player" );
		level thread player_speech_and_dolly_zoom_animations();
		run_scene_and_delete( "betrayal_speech_sal" );
		
		run_scene_and_delete( "betrayal_sal_captured" );
		level thread run_scene_and_delete( "betrayal_sal_captured_loop" );
	}
	
}

gassed_navy()
{
	level thread gassed_victim( "01" );
	level thread gassed_victim( "02" );
	level thread gassed_victim( "03" );
	level thread gassed_victim( "04" );
	level thread gassed_victim( "05" );
	level thread gassed_victim( "06" );
	level thread gassed_victim( "07" );
	level thread gassed_victim( "08" );
	level thread gassed_victim( "09" );
	
	level thread gassed_victim_group( "10" );
	level thread gassed_victim_group( "11" );
	level thread gassed_victim_group( "12" );
	
	trigger_wait( "mason_elevator_trig" );
	for( i = 1; i < 10; i++ )
	{
		ai = GetEnt( "aftermath_dead_" + i + "_ai" , "targetname" );
		if( IsDefined( ai ) && IsAlive( ai ) )
		{
			ai Delete();
		}
	}
	
	for( i = 1; i < 4; i++ )
	{
		ai = GetEnt( "guy" + i , "targetname" );
		if( IsDefined( ai ) && IsAlive( ai ) )
		{
			ai Delete();
		}
	}
}

gassed_victim( s_index )
{
	level thread run_scene( "victim" + s_index + "_floor_idle" );
	
	trigger_wait( "gas_victim_trigger_" + s_index );
	level run_scene( "victim" + s_index + "_transition" );
	level thread run_scene( "victim" + s_index + "_recover_idle" );
	
	flag_wait( "hanger_salazar_scene" );
	level delete_scene( "victim" + s_index + "_recover_idle" );
}

gassed_victim_group( s_index )
{
	level thread run_scene( "victim" + s_index + "_floor_idle" );
	
	trigger_wait( "gased_victims_trigger" );
	level run_scene( "victim" + s_index + "_transition" );
	level thread run_scene( "victim" + s_index + "_recover_idle" );
	
	trigger_wait( "mason_elevator_trig" );
	level delete_scene( "victim" + s_index + "_recover_idle" );
}

run_mason_salazar_caught()
{
}

run_mason_elevator()
{
	node = GetNodeArray( "elevator_pathnode", "targetname" );

	level thread spawn_seals_from_optional_objective();
	
	for( i = 0; i < node.size; i++ )
	{
		node[i] node_connect_to_path();
	}
	
	elevator_volume = GetEnt( "elevator_volume", "targetname" );
	sm_1 = GetEnt( "sm_1", "targetname" );
	
	level.redshirt1 = GetEnt( "redshirt1_ai", "targetname" );
	level.redshirt2 = GetEnt( "redshirt2_ai", "targetname" );

	if ( IsDefined( level.harper ) )
	{
		level.harper set_force_color( "r" );
		level.harper set_ignoreall( false );

	}
	if ( IsDefined( level.redshirt1 ) )
	{
		level.redshirt1 set_force_color( "r" );
		level.redshirt1 set_ignoreall( false );
	}
	if ( IsDefined( level.redshirt2 ) )
	{
		level.redshirt2 set_force_color( "r" );
		level.redshirt2 set_ignoreall( false );
	}
	
	wait 1;
	
	set_objective(level.OBJ_BREADCRUMB, sm_1.origin, "breadcrumb" );
	
	trigger_use( "color_trigger_hangar" );
	
	trigger_wait( "trigger_dead_body_fall" );
	
	level thread fxanim_debris_fx();
	
	level notify( "fxanim_black_elevator_debris_start" );
	
	level.pip_ai = simple_spawn( "pip_troops" );
	
	for( i = 0; i < level.pip_ai.size; i++ )
	{
		if( IsDefined( level.pip_ai[i] ) && IsAlive( level.pip_ai[i] ) )
		{
			level.pip_ai[i] thread magic_bullet_shield();
		}
	}
	
	level.pip = extra_cam_init( "troops_on_deck_pip", undefined );

	level thread pip_explosion();
	
	level mason_elevator();
}

fxanim_debris_fx()
{
	// Need to do this to grab the fxanim model properly
	level waittill( "fxanim_black_elevator_debris_start" );
	wait 0.05;
	
	Earthquake( 0.3, 1.5, level.player.origin, 128 );
	
	fxanim_model = GetEnt( "black_elevator_debris", "targetname" );
	
	cockpit_tag_origin 	= fxanim_model GetTagOrigin( "link_cockpit_debris_jnt" );
	wing_l_tag_origin 	= fxanim_model GetTagOrigin( "link_wing_l_debris_jnt" );
	wing_r_tag_origin	= fxanim_model GetTagOrigin( "link_wing_r_debris_jnt" );
	engine_tag_origin 	= fxanim_model GetTagOrigin( "link_engine_debris_jnt" );
	
	fxanim_model play_fx( "fx_com_elev_fa38_debri_trail", cockpit_tag_origin, ( 0, 0, 0 ), undefined, true, "link_cockpit_debris_jnt" );
	fxanim_model play_fx( "fx_com_elev_fa38_debri_trail", wing_l_tag_origin, ( 0, 0, 0 ), undefined, true, "link_wing_l_debris_jnt" );
	fxanim_model play_fx( "fx_com_elev_fa38_debri_trail", wing_r_tag_origin, ( 0, 0, 0 ), undefined, true, "link_wing_r_debris_jnt" );
	fxanim_model play_fx( "fx_com_elev_fa38_debri_trail", engine_tag_origin, ( 0, 0, 0 ), undefined, true, "link_engine_debris_jnt" );
	
	wait 2;
	
	Earthquake( 0.3, 1.5, level.player.origin, 128 );
	
	wait 3;
	
	mason_elevator = getent ("mason_elevator", "targetname");
	
	fxanim_model LinkTo( mason_elevator );
	
}

ambient_fire_on_deck()
{
	s_fire = get_struct( "s_deck_fire", "targetname" );
	play_fx( "fx_fire_line_md", s_fire.origin, s_fire.angles );
	
	s_smoke = get_struct( "s_deck_smoke_1", "targetname" );
	play_fx( "fx_smk_fire_lg_black", s_smoke.origin, s_smoke.angles );
	play_fx( "fx_fire_fuel_sm", s_smoke.origin, s_smoke.angles );
	
	s_smoke = get_struct( "s_deck_smoke_2", "targetname" );
	play_fx( "fx_smk_fire_lg_black", s_smoke.origin, s_smoke.angles );
	play_fx( "fx_fire_fuel_sm", s_smoke.origin, s_smoke.angles );
}

delete_and_create_runway_jets()
{
	runway_array = GetEntArray( "runway_jet_delete", "targetname" );
	array_delete( runway_array );
	
	spawn_vehicle_from_targetname( "defend_f38_1" );
	spawn_vehicle_from_targetname( "defend_f38_2" );
}

spawn_seals_from_optional_objective()
{
	trigger_wait( "move_allies_off_elevator" );
	
	if( level.num_seals_saved > 3 )
	{
		level.num_seals_saved = 3;
	}
	
	for( i = 1; i < ( level.num_seals_saved + 1 ); i++ )
	{
		seal = simple_spawn_single( "support_seal_" + i );
		seal thread magic_bullet_shield();
	}
}

gas_mask_remove()  // self = model
{
	if ( IsDefined( self.gas_mask_model ) )
	{
		self Detach( self.gas_mask_model, "J_Head" );
		self.gas_mask_model = undefined;
	}
}

ai_elevator_think()
{
	self endon( "death" );
	
	mason_elevator = getent ("mason_elevator", "targetname");
	
	a_stances = array( "stand", "crouch" );
	while( 1 )
	{
		self set_ignoreall( false );
		stance = random( a_stances );
		
		self AllowedStances( stance );
		wait RandomFloatRange( 3, 6 );
	}
}

pip_dying_ai_1()
{
	wait 1;
	self stop_magic_bullet_shield();
}

pip_dying_ai_2()
{
	wait 4;
	if( IsDefined( self ) && IsAlive( self ) )
	{
		self stop_magic_bullet_shield();
	}
}

pip_explosion()
{
	wait 3;
	
	struct = getstruct( "pip_explosion_struct", "targetname" );
	MagicBullet( "f35_missile_turret", struct.origin, struct.origin - ( 0,0, 10 ) );
}
