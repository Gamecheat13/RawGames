#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_dialog;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la_1.gsh;

#using_animtree( "generic_human" );

/* ------------------------------------------------------------------------------------------
AUTOEXEC
-------------------------------------------------------------------------------------------*/
autoexec event_funcs()
{
	if ( !level.createFX_enabled )
	{
		add_spawn_function_group( "mason_reflection", "targetname", ::reflection_scene_head_track );
	}
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_intro()
{
	start_teleport( "skipto_intro" );
}

/* ------------------------------------------------------------------------------------------
MAIN
-------------------------------------------------------------------------------------------*/

#define WINDOW_BLUR_SWITCH_TIME 48
	
main()
{
	/#
		PrintLn( "Intro" );
	#/
		
	load_gump( "la_1_gump_1a" );
			
	level.harper = init_hero( "harper" );
	level.hillary = init_hero( "hillary" );
	level.bill = init_hero( "bill" );
	level.ss1 = init_hero( "ss1" );
	level.johnson = init_hero( "johnson" );
	level.jones = init_hero( "jones" );
	level.secretary = init_hero( "secretary" );
		
	level thread drone_approach();
	
	flag_wait( "all_players_connected" );
	
	SetSavedDvar( "sm_sunSampleSizeNear", 0.4);
				
	s_cougar_spawner = get_vehicle_spawner( "intro_cougar" );
	veh_cougar = SpawnVehicle( "veh_t6_mil_cougar_interior", "intro_cougar", "apc_cougar_nophysics", s_cougar_spawner.origin, s_cougar_spawner.angles );
	veh_cougar thread intro_cougar();
	
	n_fov = GetDvarInt( "cg_fov" );
	level.player SetClientDvar( "cg_fov", 55 );
	
	run_scene_first_frame( "intro" );
	
	level thread intro_dialog();
	
	flag_wait( "starting final intro screen fadeout" );

	turn_on_reflection_cam();
		
	nd_cougar_path = GetVehicleNode( "intro_cougar_path", "targetname" );
	veh_cougar thread go_path( nd_cougar_path );
	
	level thread run_reflection_scene();
	
	level thread intro_scene_misc();
	
	level.player PlaySound( "evt_la_1_intro" );
	level run_scene_and_delete( "intro" );
	
	level.player SetClientDvar( "cg_fov", n_fov );
}

intro_cougar()
{
	self Attach( "veh_t6_mil_cougar_interior_shadow" );
	self play_fx( "cougar_dome_light", undefined, undefined, -1, true, "tag_fx_domelight" );
	self thread cougar_godrays();
}

set_chopper_dof()
{
	veh_cougar = GetEnt( "intro_cougar", "targetname" );
	veh_cougar SetClientFlag( CLIENT_FLAG_VEHICLE_REFLECTION_BLUR );
}

intro_dialog()
{
	//TUEY - sending client a notify for a sound snapshot activation (la_amb.csc file)
	clientNotify ("intro_started");
	setmusicstate ("LA_1_INTRO");
	
	level.secretary thread say_dialog( "oh_shit__oh_shit_001" );
//	wait 4;
//	level.harper thread say_dialog( "its_a_superficial_002" );
}

slowmo_start( m_player_body )
{
	level.player playsound ("blk_intro_snap_timer");
	timescale_tween( .1, .3, 1 );
}

slowmo_end( m_player_body )
{
	timescale_tween( .3, 1, 1 );
}

slowmo_med_start( m_player_body )
{
	timescale_tween( .2, .4, 1 );
}

slowmo_med_end( m_player_body )
{
	timescale_tween( .4, 1, 1 );
}

fade_out( m_player_body )
{
	turn_off_reflection_cam();
	fade_to_black( 0 );
	level thread maps\la_1_amb::play_post_cougar_blend();
}

run_reflection_scene()
{
	delay_thread( WINDOW_BLUR_SWITCH_TIME , ::set_chopper_dof );
	
	m_reflection_cougar = GetEnt( "cougar_reflection_scene", "targetname" );
	m_reflection_cougar SetModel( "veh_t6_mil_cougar_interior" );
	m_reflection_cougar Attach( "veh_t6_mil_cougar_interior_shadow" );
	
	level thread run_scene_and_delete( "intro_reflection" );
	
	scene_wait( "intro_reflection" );
	m_reflection_cougar Delete();
}

reflection_scene_head_track()
{
	self endon( "death" );
	
	while ( true )
	{
		v_forward = AnglesToForward( level.player GetPlayerAngles() );
		v_eye = level.player get_eye();
		
		self LookAtPos( v_eye + ( v_forward * 300 ) );
		
		wait .05;
	}
}

cougar_godrays()
{
	self endon( "death" );
	while ( true )
	{
		self play_fx( "intro_cougar_godrays", undefined, undefined, "stop_godrays", true, "tag_body_animate_jnt" );
		self waittill( "start_godrays" );
	}
}

warp( m_player_body )
{
	self play_fx( "intro_warp_smoke", undefined, undefined, 4, true, "tag_body_animate_jnt" );
	self notify( "stop_godrays" );
	
	wait 1;
	
	node = GetVehicleNode( "intro_cougar_path", "targetname" );
	level.player SetOrigin( node.origin );
	self thread go_path( node );
	
	wait 2;
	
	self notify( "start_godrays" );
}

#define REFLECTION_WIDTH 36.02
#define REFLECTION_HEIGHT 19.01

turn_on_reflection_cam()
{
	SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );
	sm_cam_ent = GetEnt( "reflection_cam", "targetname" );
	sm_cam_ent SetClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
}

turn_off_reflection_cam()
{
	sm_cam_ent = GetEnt( "reflection_cam", "targetname" );
	sm_cam_ent ClearClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
	sm_cam_ent delay_thread( 2, ::self_delete );
}

#define DRONE_APRPOACH_INTERVAL 3

drone_approach()
{
	exploder( 55 );
	
	a_drone_spawners = get_vehicle_spawners( "intro_drones" );
	
	while ( flag( "drone_approach" ) )
	{
		while ( GetVehicleArray().size > 55 )
		{
			wait .05;
		}
		
		a_drones = spawn_vehicles_from_targetname_and_drive( "intro_drones" );
		foreach ( veh_drone in a_drones )
		{
			veh_drone thread set_drone_path_variance();
		}
		
		wait RandomFloatRange( DRONE_APRPOACH_INTERVAL / 2, DRONE_APRPOACH_INTERVAL + DRONE_APRPOACH_INTERVAL / 2 );
	}
	
	stop_exploder( 55 );
}

set_drone_path_variance()
{
	self waittill( "start_path_variance" ); 
	self PathVariableOffset( (1000, 1000, 100), 1.5 );
}

blackhawk_explosion( veh_blackhawk )
{
	veh_blackhawk notify( "missile_hit" );
	veh_blackhawk play_fx( "intro_blackhawk_explode", undefined, undefined, -1, true, "body_animate_jnt" );
	wait .3;
	veh_blackhawk play_fx( "intro_blackhawk_trail", undefined, undefined, -1, true, "body_animate_jnt" );
}

intro_scene_misc()
{
	flag_wait( "intro_started" );
	
	policecar_lights();
	
	veh_blackhawk = GetEnt( "intro_blackhawk", "targetname" );
	veh_blackhawk play_fx( "blackhawk_groundfx", undefined, undefined, "missile_hit", true, "body_animate_jnt" );
	
	veh_drone1 = GetEnt( "intro_drone1", "targetname" );
	veh_drone2 = GetEnt( "intro_drone2", "targetname" );
	veh_drone3 = GetEnt( "intro_drone3", "targetname" );
	veh_drone4 = GetEnt( "intro_drone4", "targetname" );
	
	e_missile_target1 = GetEnt( "intro_missile_target1", "targetname" );
	e_missile_target2 = GetEnt( "intro_missile_target2", "targetname" );
	e_missile_target3 = GetEnt( "intro_missile_target3", "targetname" );
	e_missile_target4 = GetEnt( "intro_missile_target4", "targetname" );
	
	veh_drone1 maps\_turret::set_turret_target( e_missile_target4, undefined, 1 );
	veh_drone1 maps\_turret::set_turret_target( e_missile_target4, undefined, 2 );
	
	veh_drone2 maps\_turret::set_turret_target( e_missile_target1, undefined, 1 );
	veh_drone2 maps\_turret::set_turret_target( e_missile_target1, undefined, 2 );
	
	veh_drone3 maps\_turret::set_turret_target( e_missile_target2, undefined, 1 );
	veh_drone3 maps\_turret::set_turret_target( e_missile_target2, undefined, 2 );
	
	veh_drone4 maps\_turret::set_turret_target( e_missile_target3, undefined, 1 );
	veh_drone4 maps\_turret::set_turret_target( e_missile_target3, undefined, 2 );
	
	level thread run_scene( "intro_gunner" );
}

policecar_lights()
{
	GetEnt( "intro_copcar1", "targetname" ) thread police_car();
	GetEnt( "intro_copcar2", "targetname" ) thread police_car();
	GetEnt( "intro_copcar3", "targetname" ) thread police_car();
	GetEnt( "intro_copcar4", "targetname" ) thread police_car();
}

cougar3_aim( veh_cougar )
{
	veh_cougar3 = GetEnt( "intro_cougar3", "targetname" );
	veh_drone2 = GetEnt( "intro_drone2", "targetname" );
	
	veh_cougar3 maps\_turret::set_turret_target( veh_drone2, undefined, 2 );	                    
}